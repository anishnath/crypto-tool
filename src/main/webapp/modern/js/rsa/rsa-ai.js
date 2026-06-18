/**
 * RSA AI — single module (api, session, redact, router, executor, adapter).
 * Loaded once from rsafunctions.jsp to avoid multi-file import chains (LCP/INP).
 */
import { chat } from '../llm-client.js';
import { VibeCodingAssistant } from '../ai/assistant-core.js';

// --- API client (/api/rsa/*) ---

function joinUrl(ctx, path) {
  const base = String(ctx || '').replace(/\/$/, '');
  return base + path;
}

async function postJson(ctx, path, body) {
  const res = await fetch(joinUrl(ctx, path), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok || data.ok === false) {
    const err = new Error(data.error || `RSA request failed (${res.status})`);
    err.status = res.status;
    throw err;
  }
  return data;
}

async function rsaGenerateKeys(ctx, { keysize = '2048' } = {}) {
  return postJson(ctx, '/api/rsa/generate-keys', { keysize });
}

async function rsaEncrypt(ctx, { message = '', publicKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/encrypt', { message, publicKey, algorithm });
}

async function rsaDecrypt(ctx, { ciphertext = '', privateKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/decrypt', { ciphertext, privateKey, algorithm });
}

async function rsaSign(ctx, { message = '', privateKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/sign', { message, privateKey, algorithm });
}

async function rsaVerify(ctx, {
  message = '', publicKey = '', signature = '', algorithm = '',
} = {}) {
  return postJson(ctx, '/api/rsa/verify', { message, publicKey, signature, algorithm });
}

// --- Session store ---

let rsaSession = null;

function saveRsaSession(data) {
  if (!data?.publicKey || !data?.privateKey) return;
  rsaSession = {
    publicKey: String(data.publicKey).trim(),
    privateKey: String(data.privateKey).trim(),
    keySize: String(data.keySize || '2048').trim(),
    savedAt: Date.now(),
  };
}

function getRsaSession() {
  return rsaSession ? { ...rsaSession } : null;
}

// --- Redact (never send PEM to AI) ---

const PEM_PATTERNS = [
  { re: /-----BEGIN PUBLIC KEY-----[\s\S]*?-----END PUBLIC KEY-----/gim, hint: '[RSA public key on file in session — not sent to AI]' },
  { re: /-----BEGIN RSA PUBLIC KEY-----[\s\S]*?-----END RSA PUBLIC KEY-----/gim, hint: '[RSA public key on file in session — not sent to AI]' },
  { re: /-----BEGIN PRIVATE KEY-----[\s\S]*?-----END PRIVATE KEY-----/gim, hint: '[RSA private key on file in session — not sent to AI]' },
  { re: /-----BEGIN RSA PRIVATE KEY-----[\s\S]*?-----END RSA PRIVATE KEY-----/gim, hint: '[RSA private key on file in session — not sent to AI]' },
];

function isAiPlaceholderSecret(value) {
  const v = String(value || '').trim();
  if (!v) return false;
  return v.startsWith('[') && (
    /not sent to AI/i.test(v)
    || /on file in session/i.test(v)
    || /redacted/i.test(v)
  );
}

function scrubAiPlaceholdersFromPlan(plan) {
  if (!plan?.params) return plan;
  const params = { ...plan.params };
  for (const field of ['publicKey', 'privateKey', 'ciphertext', 'signature']) {
    if (isAiPlaceholderSecret(params[field])) params[field] = '';
  }
  return { ...plan, params };
}

function redactRsaForAi(text) {
  if (!text) return '';
  let s = String(text);
  for (const { re, hint } of PEM_PATTERNS) {
    s = s.replace(re, hint);
  }
  s = s.replace(
    /```(?:\w*\n)?([\s\S]*?)```/g,
    (match, inner) => (/BEGIN (RSA )?(PUBLIC|PRIVATE) KEY/i.test(inner)
      ? '```\n[RSA key material redacted — available in session]\n```'
      : match),
  );
  return s.trim();
}

function redactRsaHistoryForAi(turns) {
  if (!Array.isArray(turns)) return [];
  return turns.map((turn) => ({
    role: turn.role,
    content: redactRsaForAi(turn.content),
  }));
}

function redactRsaParamsForAi(params) {
  if (!params || typeof params !== 'object') return {};
  const safe = { ...params };
  for (const field of ['publicKey', 'privateKey', 'ciphertext', 'signature']) {
    if (safe[field]) safe[field] = `[${field} on file in session — not sent to AI]`;
  }
  return safe;
}

// --- PEM helpers ---

function extractPublicKey(text) {
  const raw = String(text || '');
  for (const re of [
    /-----BEGIN PUBLIC KEY-----[\s\S]*?-----END PUBLIC KEY-----/m,
    /-----BEGIN RSA PUBLIC KEY-----[\s\S]*?-----END RSA PUBLIC KEY-----/m,
  ]) {
    const m = raw.match(re);
    if (m) return m[0].trim();
  }
  return '';
}

function extractPrivateKey(text) {
  const raw = String(text || '');
  for (const re of [
    /-----BEGIN PRIVATE KEY-----[\s\S]*?-----END PRIVATE KEY-----/m,
    /-----BEGIN RSA PRIVATE KEY-----[\s\S]*?-----END RSA PRIVATE KEY-----/m,
  ]) {
    const m = raw.match(re);
    if (m) return m[0].trim();
  }
  return '';
}

function isValidPublicKey(key) {
  const k = String(key || '');
  return (k.includes('BEGIN PUBLIC KEY') || k.includes('BEGIN RSA PUBLIC KEY'))
    && (k.includes('END PUBLIC KEY') || k.includes('END RSA PUBLIC KEY'));
}

function isValidPrivateKey(key) {
  const k = String(key || '');
  return (k.includes('BEGIN PRIVATE KEY') || k.includes('BEGIN RSA PRIVATE KEY'))
    && (k.includes('END PRIVATE KEY') || k.includes('END RSA PRIVATE KEY'));
}

function extractKeysFromHistory(history) {
  const out = { publicKey: '', privateKey: '', signature: '', ciphertext: '' };
  if (!Array.isArray(history)) return out;
  for (let i = history.length - 1; i >= 0; i--) {
    const msg = history[i];
    if (msg?.role !== 'assistant') continue;
    const text = msg.content || '';
    if (!out.publicKey) out.publicKey = extractPublicKey(text);
    if (!out.privateKey) out.privateKey = extractPrivateKey(text);
    if (!out.signature) {
      const sigMatch = text.match(/\*\*Signature \(Base64\)\*\*[\s\S]*?```\s*\n([\s\S]*?)```/);
      if (sigMatch) out.signature = sigMatch[1].trim();
    }
    if (!out.ciphertext) {
      const ctMatch = text.match(/\*\*Ciphertext \(Base64\)\*\*[\s\S]*?```\s*\n([\s\S]*?)```/);
      if (ctMatch) out.ciphertext = ctMatch[1].trim();
    }
    if (out.publicKey && out.privateKey) break;
  }
  return out;
}

// --- Pending operation (multi-turn) ---

let pendingOp = null;

function setPendingOperation(plan, missing) {
  if (!plan?.intent || !missing?.length) {
    pendingOp = null;
    return;
  }
  pendingOp = {
    intent: plan.intent,
    params: { ...(plan.params || {}) },
    missing: [...missing],
  };
}

function getPendingOperation() {
  if (!pendingOp) return null;
  return {
    intent: pendingOp.intent,
    params: { ...pendingOp.params },
    missing: [...pendingOp.missing],
  };
}

function clearPendingOperation() {
  pendingOp = null;
}

const PENDING_FIELD_SETTERS = {
  message: (params, value) => { params.message = value; },
  ciphertext: (params, value) => { params.ciphertext = value; },
  signature: (params, value) => { params.signature = value; },
  keysize: (params, value) => { params.keysize = value; },
  algorithm: (params, value) => { params.algorithm = value; },
};

function applyPendingFallback(userText, pending, plan) {
  if (!pending?.intent || !pending.missing?.length) return plan;

  const routerHandled = plan?.is_follow_up
    || (plan?.intent === pending.intent && plan?.params?.message);
  if (routerHandled) return plan;

  const needsHelp = !plan || plan.intent === 'explain' || plan.intent === 'clarify';
  if (!needsHelp) return plan;

  const text = String(userText || '').trim();
  if (!text || /-----BEGIN (RSA )?(PUBLIC|PRIVATE) KEY/i.test(text)) return plan;

  const params = { ...pending.params, ...(plan?.params || {}) };
  const field = pending.missing[0];
  const setter = PENDING_FIELD_SETTERS[field];
  if (setter && !params[field]) setter(params, text);

  return {
    intent: pending.intent,
    use_session_keys: plan?.use_session_keys ?? true,
    is_follow_up: true,
    params,
    missing: pending.missing.filter((f) => f !== field),
    clarify_message: '',
  };
}

// --- Intent router ---

const ROUTER_PROMPT = `You are the intent router for an RSA encrypt/decrypt/sign/verify tool.
Users write in many styles — casual, formal, typos, one-word replies.
Read the FULL conversation and return ONE JSON plan for what to do NOW.

Return ONLY valid JSON (no markdown fences):
{
  "intent": "generate_keys" | "encrypt" | "decrypt" | "sign" | "verify" | "explain" | "clarify",
  "use_session_keys": false,
  "is_follow_up": false,
  "params": {
    "keysize": "2048",
    "algorithm": "",
    "message": "",
    "ciphertext": "",
    "signature": "",
    "publicKey": "",
    "privateKey": ""
  },
  "missing": [],
  "clarify_message": ""
}

INTENTS
- generate_keys: new RSA PEM key pair (optional keysize: 512, 1024, 2048, 4096)
- encrypt: encrypt plaintext with public key (message + publicKey)
- decrypt: decrypt Base64 ciphertext with private key (ciphertext + privateKey)
- sign: create Base64 signature (message + privateKey)
- verify: verify signature (message + publicKey + signature)
- explain / clarify — as labeled

SESSION KEYS
- [SESSION KEYS] = keys generated earlier in THIS chat.
- Set use_session_keys: true for "my keys", "what you generated", "same key", etc.
- When use_session_keys is true, leave publicKey and privateKey as empty strings "" — the client injects real PEM keys.
- NEVER echo redaction markers in JSON params.

PASTED PEM BLOCKS
- If the user pastes PEM (BEGIN PUBLIC KEY / BEGIN PRIVATE KEY), do NOT copy the block into params — the client extracts PEM from the raw message.

MULTI-TURN
- Short replies ("THIS", "hello world") often answer a prior question.
- If [PENDING OPERATION] is set, keep the SAME intent and fill the missing param.
- Set is_follow_up: true when completing a prior request.
- Do NOT switch intent on a short reply.

ALGORITHMS
- encrypt/decrypt: RSA/ECB/OAEPWithSHA-256AndMGF1Padding (default), RSA/ECB/PKCS1Padding, etc.
- sign/verify: SHA256withRSA (default), SHA512withRSA, etc.
- Leave algorithm empty to use defaults.

MISSING
- Keep the concrete intent even when fields are missing.
- List needed param names in missing[] and write clarify_message.
- Use intent "clarify" ONLY when you cannot tell which operation the user wants.

EXAMPLES
"generate 2048 bit keys" → generate_keys, keysize 2048
"encrypt secret hello" (after keygen) → encrypt, use_session_keys true
"THIS" (after asked for message) → same intent, message "THIS", is_follow_up true
"what is OAEP?" → explain

Do NOT invent keys or ciphertext.`;

const VALID_INTENTS = new Set([
  'generate_keys', 'encrypt', 'decrypt', 'sign', 'verify', 'explain', 'clarify',
]);
const VALID_KEYSIZES = new Set(['512', '1024', '2048', '4096']);
const VALID_MISSING = new Set([
  'message', 'ciphertext', 'signature', 'publicKey', 'privateKey', 'keysize', 'algorithm',
]);

function parseJsonLoose(text) {
  const raw = String(text || '').trim();
  const fence = raw.match(/```(?:json)?\s*\n?([\s\S]*?)```/i);
  const candidate = fence ? fence[1].trim() : raw;
  const start = candidate.indexOf('{');
  const end = candidate.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    return JSON.parse(candidate.slice(start, end + 1));
  } catch {
    return null;
  }
}

function normalizePlan(obj) {
  if (!obj || typeof obj !== 'object') return null;
  const intent = String(obj.intent || 'explain').toLowerCase();
  const params = obj.params && typeof obj.params === 'object' ? obj.params : {};
  return {
    intent: VALID_INTENTS.has(intent) ? intent : 'explain',
    use_session_keys: obj.use_session_keys === true,
    is_follow_up: obj.is_follow_up === true,
    params: {
      keysize: VALID_KEYSIZES.has(String(params.keysize)) ? String(params.keysize) : '2048',
      algorithm: String(params.algorithm || '').trim(),
      message: String(params.message || '').trim(),
      ciphertext: String(params.ciphertext || params.encryptedMessage || '').trim(),
      signature: String(params.signature || '').trim(),
      publicKey: String(params.publicKey || '').trim(),
      privateKey: String(params.privateKey || '').trim(),
    },
    missing: Array.isArray(obj.missing)
      ? obj.missing.map(String).filter((m) => VALID_MISSING.has(m))
      : [],
    clarify_message: String(obj.clarify_message || '').trim(),
  };
}

function buildRouterContextBlock(pageSnapshot, pending) {
  const parts = [`[PAGE CONTEXT]\n${pageSnapshot || '(empty)'}`];
  if (pending?.intent && pending.missing?.length) {
    parts.push(
      `[PENDING OPERATION]\n`
      + `intent: ${pending.intent}\n`
      + `still_need: ${pending.missing.join(', ')}\n`
      + `partial_params: ${JSON.stringify(redactRsaParamsForAi(pending.params || {}))}\n`
      + `Latest user message likely supplies the missing field. Keep intent "${pending.intent}".`,
    );
  }
  return parts.join('\n\n');
}

function trimChatContent(content, max = 900) {
  const t = redactRsaForAi(content);
  return t.length > max ? `${t.slice(0, max)}…` : t;
}

function buildRouterMessages(contextBlock, recentChat, userText) {
  const messages = [{ role: 'system', content: ROUTER_PROMPT }];
  const safeContext = redactRsaForAi(contextBlock);
  if (safeContext) {
    messages.push({ role: 'user', content: safeContext });
    messages.push({
      role: 'assistant',
      content: 'Understood. I will use page context and pending operation when routing.',
    });
  }
  const turns = redactRsaHistoryForAi(Array.isArray(recentChat) ? recentChat.slice(-10) : []);
  for (const turn of turns) {
    messages.push({
      role: turn.role === 'assistant' ? 'assistant' : 'user',
      content: trimChatContent(turn.content),
    });
  }
  messages.push({ role: 'user', content: redactRsaForAi(String(userText || '')) });
  return messages;
}

async function analyzeRsaIntent(assistant, routerCtx) {
  const {
    pageSnapshot = '',
    pendingOp: pending = null,
    recentChat = [],
    userText = '',
  } = routerCtx || {};

  const messages = buildRouterMessages(
    buildRouterContextBlock(pageSnapshot, pending),
    recentChat,
    userText,
  );

  const reply = await chat(
    assistant.aiUrl,
    { messages },
    {
      useGateway: assistant.useGateway,
      userId: assistant.userId,
      toolId: assistant.toolId,
    },
  );
  return scrubAiPlaceholdersFromPlan(normalizePlan(parseJsonLoose(reply)) || {
    intent: 'explain',
    use_session_keys: false,
    is_follow_up: false,
    params: {},
    missing: [],
    clarify_message: '',
  });
}

function pickPublicKey(params, context, preferSession) {
  const candidates = preferSession
    ? [context.sessionPublicKey, params.publicKey, context.historyPublicKey, context.publicKey]
    : [params.publicKey, context.sessionPublicKey, context.historyPublicKey, context.publicKey];
  for (const key of candidates) {
    if (isValidPublicKey(key)) return key.trim();
  }
  return '';
}

function pickPrivateKey(params, context, preferSession) {
  const candidates = preferSession
    ? [context.sessionPrivateKey, params.privateKey, context.historyPrivateKey, context.privateKey]
    : [params.privateKey, context.sessionPrivateKey, context.historyPrivateKey, context.privateKey];
  for (const key of candidates) {
    if (isValidPrivateKey(key)) return key.trim();
  }
  return '';
}

function shouldPreferSession(plan, context) {
  if (plan.use_session_keys === true) return true;
  if (plan.use_session_keys === false) return false;
  if (context.hasSessionKeys) {
    const op = plan.intent;
    if (op === 'encrypt' || op === 'sign' || op === 'decrypt' || op === 'verify') return true;
  }
  return false;
}

function pickAlgorithm(intent, params, context) {
  const fromParams = String(params.algorithm || '').trim();
  if (fromParams && !isAiPlaceholderSecret(fromParams)) return fromParams;
  const fromForm = String(context.algorithm || '').trim();
  if (fromForm) return fromForm;
  if (intent === 'sign' || intent === 'verify') return 'SHA256withRSA';
  return 'RSA/ECB/OAEPWithSHA-256AndMGF1Padding';
}

function mergePlanWithContext(plan, context) {
  if (!plan?.params || !context) return plan;
  const preferSession = shouldPreferSession(plan, context);
  const p = { ...plan, params: { ...plan.params } };

  if (p.params.publicKey && !isValidPublicKey(p.params.publicKey)) p.params.publicKey = '';
  if (p.params.privateKey && !isValidPrivateKey(p.params.privateKey)) p.params.privateKey = '';
  if (isAiPlaceholderSecret(p.params.ciphertext)) p.params.ciphertext = '';
  if (isAiPlaceholderSecret(p.params.signature)) p.params.signature = '';

  if (!p.params.message && context.plainMessage) p.params.message = context.plainMessage;
  if (!p.params.ciphertext && context.ciphertext) p.params.ciphertext = context.ciphertext;
  if (!p.params.ciphertext && context.historyCiphertext) p.params.ciphertext = context.historyCiphertext;
  if (!p.params.signature && context.signature) p.params.signature = context.signature;
  if (!p.params.signature && context.historySignature) p.params.signature = context.historySignature;

  p.params.publicKey = pickPublicKey(p.params, context, preferSession);
  p.params.privateKey = pickPrivateKey(p.params, context, preferSession);
  p.params.algorithm = pickAlgorithm(p.intent, p.params, context);

  return p;
}

function requiredFieldsMissing(plan) {
  const missing = [];
  const p = plan.params || {};
  switch (plan.intent) {
    case 'generate_keys':
      break;
    case 'encrypt':
      if (!p.message) missing.push('message');
      if (!p.publicKey) missing.push('publicKey');
      break;
    case 'decrypt':
      if (!p.ciphertext) missing.push('ciphertext');
      if (!p.privateKey) missing.push('privateKey');
      break;
    case 'sign':
      if (!p.message) missing.push('message');
      if (!p.privateKey) missing.push('privateKey');
      break;
    case 'verify':
      if (!p.message) missing.push('message');
      if (!p.publicKey) missing.push('publicKey');
      if (!p.signature) missing.push('signature');
      break;
    default:
      break;
  }
  return missing;
}

function buildClarifyMessage(plan, missing) {
  if (plan.clarify_message) return plan.clarify_message;
  const labels = {
    message: 'the plaintext message',
    ciphertext: 'the Base64 ciphertext to decrypt',
    signature: 'the Base64 signature to verify',
    publicKey: 'the RSA public key (PEM)',
    privateKey: 'your RSA private key (PEM)',
    keysize: 'the key size (512, 1024, 2048, or 4096)',
    algorithm: 'the cipher or signature algorithm',
  };
  const parts = missing.map((m) => labels[m] || m);
  if (!parts.length) return 'Could you provide more details?';
  return `I need ${parts.join(', ')} before I can do that. Paste them here or fill the form on the left.`;
}

// --- Chat executor ---

function fence(label, text) {
  const body = String(text || '').trim();
  return `**${label}**\n\n\`\`\`\n${body}\n\`\`\``;
}

function formatKeyGenResult(data, { keysize } = {}) {
  const lines = [
    `Generated **RSA-${keysize || data.keySize || '2048'}** key pair.`,
    '',
    fence('Public key (PEM) — share freely', data.publicKey),
    '',
    fence('Private key (PEM) — keep secret', data.privateKey),
    '',
    '⚠️ **Save both keys offline.** Session keys are stored in your browser only.',
  ];
  return lines.join('\n');
}

function formatEncryptResult(data) {
  return [
    'Message encrypted successfully.',
    '',
    fence('Ciphertext (Base64)', data.ciphertext),
    '',
    'Copy this Base64 string for decryption or sharing.',
  ].join('\n');
}

function formatDecryptResult(data) {
  return [
    'Message decrypted successfully.',
    '',
    fence('Plaintext', data.plaintext),
  ].join('\n');
}

function formatSignResult(data) {
  return [
    'Message signed successfully.',
    '',
    fence('Signature (Base64)', data.signature),
  ].join('\n');
}

function formatVerifyResult(data) {
  const status = data.valid ? '✅ **Signature valid**' : '❌ **Signature invalid**';
  return [
    status,
    '',
    fence('Verification result', data.message || '(no details)'),
  ].join('\n');
}

async function executeRsaPlan(ctx, plan, opContext) {
  const merged = opContext ? mergePlanWithContext(plan, opContext) : plan;
  const missing = requiredFieldsMissing(merged);
  if (missing.length) {
    return { handled: true, markdown: buildClarifyMessage(merged, missing) };
  }

  const p = merged.params;

  switch (merged.intent) {
    case 'generate_keys': {
      const data = await rsaGenerateKeys(ctx, { keysize: p.keysize });
      saveRsaSession({
        publicKey: data.publicKey,
        privateKey: data.privateKey,
        keySize: data.keySize || p.keysize,
      });
      return {
        handled: true,
        markdown: formatKeyGenResult(data, { keysize: p.keysize }),
      };
    }
    case 'encrypt': {
      const data = await rsaEncrypt(ctx, {
        message: p.message,
        publicKey: p.publicKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatEncryptResult(data) };
    }
    case 'decrypt': {
      const data = await rsaDecrypt(ctx, {
        ciphertext: p.ciphertext,
        privateKey: p.privateKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatDecryptResult(data) };
    }
    case 'sign': {
      const data = await rsaSign(ctx, {
        message: p.message,
        privateKey: p.privateKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatSignResult(data) };
    }
    case 'verify': {
      const data = await rsaVerify(ctx, {
        message: p.message,
        publicKey: p.publicKey,
        signature: p.signature,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatVerifyResult(data) };
    }
    default:
      return { handled: false };
  }
}

function readRsaFormContext() {
  if (typeof document === 'undefined') return {};
  const val = (id) => {
    const el = document.getElementById(id);
    return el ? String(el.value || '').trim() : '';
  };
  const modeEl = document.querySelector('input[name="op_mode"]:checked');
  const mode = modeEl ? modeEl.value : 'encrypt';
  const keysizeEl = document.querySelector('input[name="keysize_ui"]:checked');
  const keysize = keysizeEl ? keysizeEl.value : '2048';
  const message = val('message');
  return {
    mode,
    keysize,
    plainMessage: mode === 'decrypt' ? '' : message,
    ciphertext: mode === 'decrypt' ? message : '',
    signature: val('signatureInput'),
    publicKey: val('publickeyparam'),
    privateKey: val('privatekeyparam'),
    algorithm: val('cipherSelect'),
  };
}

function buildOperationContext(formContext, userText, history) {
  const form = formContext || readRsaFormContext();
  const session = getRsaSession();
  const fromHistory = extractKeysFromHistory(history);

  return {
    ...form,
    userText: String(userText || ''),
    hasSessionKeys: Boolean(session?.publicKey),
    sessionPublicKey: session?.publicKey || '',
    sessionPrivateKey: session?.privateKey || '',
    sessionKeySize: session?.keySize || '',
    historyPublicKey: fromHistory.publicKey,
    historyPrivateKey: fromHistory.privateKey,
    historyCiphertext: fromHistory.ciphertext,
    historySignature: fromHistory.signature,
  };
}

function buildRsaSeedContext() {
  const c = readRsaFormContext();
  const session = getRsaSession();
  const parts = [`Tool mode: ${c.mode}`, `Key size (form): ${c.keysize}`];

  if (session?.publicKey) {
    parts.push(
      `[SESSION KEYS]\n`
      + `status: available\n`
      + `key_size: ${session.keySize || c.keysize}\n`
      + `has_public_key: yes\n`
      + `has_private_key: yes\n`
      + `instruction: Set use_session_keys true when user wants these keys. Never request PEM key text — client injects keys.`,
    );
  } else {
    parts.push('[SESSION KEYS]\nstatus: none');
  }

  if (c.plainMessage) {
    parts.push(`Form message field: yes (${c.plainMessage.length} chars — content not sent to AI)`);
  }
  if (c.ciphertext) {
    parts.push(`Form ciphertext field: yes (${c.ciphertext.length} chars — not sent to AI)`);
  }
  if (c.publicKey) {
    parts.push('Form public key field: filled (PEM not sent to AI)');
  }
  if (c.privateKey) {
    parts.push('Form private key field: filled (not sent to AI)');
  }
  if (c.signature) {
    parts.push('Form signature field: filled (not sent to AI)');
  }
  if (c.algorithm) {
    parts.push(`Form algorithm: ${c.algorithm}`);
  }
  return parts.join('\n\n');
}

function applyUserMessageKeys(plan, userText) {
  if (!plan?.params || !userText) return plan;
  const pastedPub = extractPublicKey(userText);
  const pastedPriv = extractPrivateKey(userText);
  const p = { ...plan, params: { ...plan.params } };
  if (pastedPub) p.params.publicKey = pastedPub;
  if (pastedPriv) p.params.privateKey = pastedPriv;
  return p;
}

// --- Assistant adapter ---

const EXPLAIN_PROMPT_SUFFIX = `
You help with RSA cryptography concepts on this page.
For explain-only questions: answer clearly in plain language.
Do NOT output fake keys or ciphertext — operations run separately via the tool API.`;

const PAGE_LAYOUT_NOTE = `This is a single-page RSA tool with operation modes and one output panel:
  • Encrypt — plaintext + public key, outputs Base64 ciphertext.
  • Decrypt — Base64 ciphertext + private key.
  • Sign — message + private key, outputs Base64 signature.
  • Verify — message + public key + Base64 signature.
  • Key size chips: 512, 1024, 2048 (recommended), 4096.
  • Cipher Mode dropdown: OAEP SHA-256 (recommended) or PKCS1 for encrypt/decrypt.
  • New Keys button regenerates the key pair instantly.
Output panel has buttons: Swap, Use for Verify, Share, Copy.
When suggesting next steps, name these exact labels.`;

function removeLastUserTurn(ai) {
  if (ai.history.length && ai.history[ai.history.length - 1].role === 'user') {
    ai.history.pop();
  }
  const msgs = ai._els?.messages;
  const last = msgs?.lastElementChild;
  if (last?.classList.contains('user') && last.classList.contains('vca-msg')) {
    last.remove();
  }
}

function pushAssistantReply(ai, markdown) {
  const { bubble, body } = ai._appendBubble('assistant', '', { streaming: false });
  ai._finalizeAssistantBubble(bubble, body, markdown);
  ai.history.push({ role: 'assistant', content: markdown });
  ai._saveHistory();
  ai._scroll();
  ai.onTurn?.(ai.history[ai.history.length - 2]?.content, markdown);
}

async function handleRsaChatSend(userText, ai, ctx) {
  const pageSnapshot = buildRsaSeedContext();
  const formContext = readRsaFormContext();
  const priorHistory = ai.history.slice(-10);
  const pending = getPendingOperation();
  const opContext = buildOperationContext(formContext, userText, priorHistory);

  ai.history.push({ role: 'user', content: userText });
  ai._appendBubble('user', userText, { streaming: false });

  const thinking = ai._appendBubble('assistant', 'Analyzing request…', { streaming: true });

  let plan;
  try {
    plan = await analyzeRsaIntent(ai, {
      pageSnapshot,
      pendingOp: pending,
      recentChat: priorHistory,
      userText,
    });
    plan = applyPendingFallback(userText, pending, plan);
    plan = scrubAiPlaceholdersFromPlan(plan);
  } catch {
    thinking.bubble.remove();
    removeLastUserTurn(ai);
    return false;
  }

  thinking.bubble.remove();

  plan = applyUserMessageKeys(plan, userText);

  if (plan.intent === 'explain') {
    clearPendingOperation();
    removeLastUserTurn(ai);
    return false;
  }

  if (plan.intent === 'clarify' && plan.clarify_message) {
    clearPendingOperation();
    pushAssistantReply(ai, plan.clarify_message);
    return true;
  }

  const merged = mergePlanWithContext(plan, opContext);
  const missing = requiredFieldsMissing(merged);

  if (missing.length) {
    const storeIntent = (merged.intent === 'clarify' || merged.intent === 'explain') && pending?.intent
      ? pending.intent
      : merged.intent;
    setPendingOperation({ ...merged, intent: storeIntent }, missing);
    pushAssistantReply(ai, buildClarifyMessage(merged, missing));
    return true;
  }

  clearPendingOperation();

  const work = ai._appendBubble('assistant', 'Running RSA operation…', { streaming: true });
  try {
    const result = await executeRsaPlan(ctx, merged, opContext);
    work.bubble.remove();
    if (result.handled) {
      pushAssistantReply(ai, result.markdown);
      return true;
    }
    ai.history.pop();
    return false;
  } catch (err) {
    work.bubble.remove();
    pushAssistantReply(ai, `**Operation failed:** ${err.message || String(err)}`);
    return true;
  }
}

export function createRsaAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

  const assistant = new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
      requireSignIn: opts.billing?.requireSignIn === true,
      ctx,
      userId: userId || '',
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: [
          'Much higher monthly AI limits',
          'Pro chat model tier',
          'No rate-limit waiting between requests',
        ],
      },
    },
    toolId: 'cryptography/rsa-functions',
    title: 'RSA AI',
    subtitle: 'Say what you want — generate keys, encrypt, decrypt, sign, verify, or ask.',
    placeholder: 'Try: "generate 2048-bit keys", "encrypt hello with my pubkey", "sign this message"...',
    footerText: 'Operations use real RSA crypto · private keys never sent to AI',
    historyTurns: 8,
    sanitizeForAi: redactRsaForAi,
    systemPrompt: `You are an expert RSA cryptography assistant on an in-browser RSA tool.
Never ask the user to paste private keys into chat. Crypto operations run via the tool API.
${PAGE_LAYOUT_NOTE}
${EXPLAIN_PROMPT_SUFFIX}`,
    seedContext: buildRsaSeedContext,
    getQuickActions: () => [
      { label: 'Generate keys', prompt: 'Generate a 2048-bit RSA key pair.', sendImmediately: true },
      { label: 'Encrypt message', prompt: 'Encrypt a message with my public key from this session.', sendImmediately: true },
      { label: 'Decrypt ciphertext', prompt: 'Decrypt the Base64 ciphertext in the form with my private key from this session.', sendImmediately: true },
      { label: 'Sign message', prompt: 'Sign a message with my private key from this session.', sendImmediately: true },
      { label: 'Verify signature', prompt: 'Verify the signature in the form with my public key from this session.', sendImmediately: true },
      { label: 'How RSA works', prompt: 'Explain how RSA asymmetric encryption works in plain English.', sendImmediately: true },
    ],
    onSend: async (userText, ai) => handleRsaChatSend(userText, ai, ctx),
  });

  return assistant;
}
