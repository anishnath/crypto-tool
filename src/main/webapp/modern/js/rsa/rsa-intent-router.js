import { chat } from '../llm-client.js';
import {
  isValidPublicKey,
  isValidPrivateKey,
} from './rsa-pem.js';
import {
  redactRsaForAi,
  redactRsaHistoryForAi,
  redactRsaParamsForAi,
  isAiPlaceholderSecret,
  scrubAiPlaceholdersFromPlan,
} from './rsa-redact.js';

export { scrubAiPlaceholdersFromPlan } from './rsa-redact.js';

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

export function buildRouterContextBlock(pageSnapshot, pendingOp) {
  const parts = [`[PAGE CONTEXT]\n${pageSnapshot || '(empty)'}`];
  if (pendingOp?.intent && pendingOp.missing?.length) {
    parts.push(
      `[PENDING OPERATION]\n`
      + `intent: ${pendingOp.intent}\n`
      + `still_need: ${pendingOp.missing.join(', ')}\n`
      + `partial_params: ${JSON.stringify(redactRsaParamsForAi(pendingOp.params || {}))}\n`
      + `Latest user message likely supplies the missing field. Keep intent "${pendingOp.intent}".`,
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

export async function analyzeRsaIntent(assistant, routerCtx) {
  const {
    pageSnapshot = '',
    pendingOp = null,
    recentChat = [],
    userText = '',
  } = routerCtx || {};

  const messages = buildRouterMessages(
    buildRouterContextBlock(pageSnapshot, pendingOp),
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

export function mergePlanWithContext(plan, context) {
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

export function resolveMissingFields(plan) {
  return requiredFieldsMissing(plan);
}

export function requiredFieldsMissing(plan) {
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

export function buildClarifyMessage(plan, missing) {
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
