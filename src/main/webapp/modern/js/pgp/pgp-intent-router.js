import { chat } from '../llm-client.js';
import {
  isValidPublicKey,
  isValidPrivateKey,
} from './pgp-armor.js';
import {
  redactPgpForAi,
  redactPgpHistoryForAi,
  redactPgpParamsForAi,
  isAiPlaceholderSecret,
  scrubAiPlaceholdersFromPlan,
} from './pgp-redact.js';

export { scrubAiPlaceholdersFromPlan } from './pgp-redact.js';

const ROUTER_PROMPT = `You are the intent router for an OpenPGP encrypt/decrypt tool.
Users write in many styles — casual, formal, typos, one-word replies.
Read the FULL conversation and return ONE JSON plan for what to do NOW.

Return ONLY valid JSON (no markdown fences):
{
  "intent": "generate_keys" | "encrypt" | "decrypt" | "sign" | "verify" | "verify_file" | "dump" | "explain" | "clarify",
  "use_session_keys": false,
  "is_follow_up": false,
  "params": {
    "identity": "",
    "passphrase": "",
    "keysize": "2048",
    "cipher": "AES_256",
    "message": "",
    "publicKey": "",
    "privateKey": "",
    "pgpMessage": "",
    "signedMaterial": "",
    "dumpInput": "",
    "fileBase64": "",
    "fileName": ""
  },
  "missing": [],
  "clarify_message": ""
}

INTENTS
- generate_keys: new RSA key pair (identity required)
- encrypt: encrypt plaintext (message + public key)
- decrypt: decrypt armored message (pgpMessage + private key + passphrase)
- sign: cleartext-sign (message + private key + passphrase)
- verify / verify_file / dump / explain / clarify — as labeled

SESSION KEYS
- [SESSION KEYS] = keys generated earlier in THIS chat.
- Set use_session_keys: true for "my keys", "what you generated", "same key", "my pubkey", etc.
- When use_session_keys is true, leave publicKey, privateKey, and passphrase as empty strings "" — the client injects the real values.
- NEVER echo redaction markers or placeholder text in JSON params (e.g. "[passphrase on file…]").

PASTED BLOCKS
- If the user pastes an armored PGP block (PUBLIC KEY, PRIVATE KEY, MESSAGE, SIGNATURE), do NOT copy the block text into params.publicKey / params.privateKey / params.pgpMessage / params.signedMaterial / params.dumpInput.
- The client extracts the block from the raw message after routing (applyUserMessageKeys). Your job is only to choose the intent.

MULTI-TURN
- Read the whole thread. Short replies ("THIS", "hello world", "test@foo.com") often answer a prior question.
- If [PENDING OPERATION] is set, keep the SAME intent and fill the missing param from the latest message.
- Set is_follow_up: true when completing a prior request.
- Do NOT switch intent on a short reply (after sign request, "hello" → sign, NOT encrypt).

MISSING
- Keep the concrete intent (encrypt, sign, etc.) even when fields are missing.
- List needed param names in missing[] and write clarify_message.
- Use intent "clarify" ONLY when you cannot tell which operation the user wants.

EXAMPLES
"gimme keys for alice@corp.com" → generate_keys
"lock this up: secret" (after keygen) → encrypt, use_session_keys true
"THIS" (after asked for message) → same intent, message "THIS", is_follow_up true
"sign hello" → sign, message "hello"
"what is pgp?" → explain

Do NOT invent keys or ciphertext.`;

const VALID_INTENTS = new Set([
  'generate_keys', 'encrypt', 'decrypt', 'sign', 'verify', 'verify_file', 'dump', 'explain', 'clarify',
]);
const VALID_KEYSIZES = new Set(['1024', '2048', '4096']);
const VALID_CIPHERS = new Set(['AES_256', 'AES_192', 'AES_128', 'TWOFISH', 'BLOWFISH', 'CAST5', 'TRIPLE_DES']);
const VALID_MISSING = new Set([
  'identity', 'message', 'publicKey', 'privateKey', 'passphrase',
  'pgpMessage', 'signedMaterial', 'dumpInput', 'fileBase64',
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
  const plan = {
    intent: VALID_INTENTS.has(intent) ? intent : 'explain',
    use_session_keys: obj.use_session_keys === true,
    is_follow_up: obj.is_follow_up === true,
    params: {
      identity: String(params.identity || '').trim(),
      passphrase: String(params.passphrase || '').trim(),
      keysize: VALID_KEYSIZES.has(String(params.keysize)) ? String(params.keysize) : '2048',
      cipher: VALID_CIPHERS.has(String(params.cipher)) ? String(params.cipher) : 'AES_256',
      message: String(params.message || '').trim(),
      publicKey: String(params.publicKey || '').trim(),
      privateKey: String(params.privateKey || '').trim(),
      pgpMessage: String(params.pgpMessage || params.encryptedMessage || '').trim(),
      signedMaterial: String(params.signedMaterial || params.signedMessage || '').trim(),
      dumpInput: String(params.dumpInput || params.input || '').trim(),
      fileBase64: String(params.fileBase64 || '').trim(),
      fileName: String(params.fileName || 'signed-file.bin').trim(),
    },
    missing: Array.isArray(obj.missing)
      ? obj.missing.map(String).filter((m) => VALID_MISSING.has(m))
      : [],
    clarify_message: String(obj.clarify_message || '').trim(),
  };
  return plan;
}

export function buildRouterContextBlock(pageSnapshot, pendingOp) {
  const parts = [`[PAGE CONTEXT]\n${pageSnapshot || '(empty)'}`];
  if (pendingOp?.intent && pendingOp.missing?.length) {
    parts.push(
      `[PENDING OPERATION]\n`
      + `intent: ${pendingOp.intent}\n`
      + `still_need: ${pendingOp.missing.join(', ')}\n`
      + `partial_params: ${JSON.stringify(redactPgpParamsForAi(pendingOp.params || {}))}\n`
      + `Latest user message likely supplies the missing field. Keep intent "${pendingOp.intent}".`,
    );
  }
  return parts.join('\n\n');
}

function trimChatContent(content, max = 900) {
  const t = redactPgpForAi(content);
  return t.length > max ? `${t.slice(0, max)}…` : t;
}

function buildRouterMessages(contextBlock, recentChat, userText) {
  const messages = [{ role: 'system', content: ROUTER_PROMPT }];
  const safeContext = redactPgpForAi(contextBlock);
  if (safeContext) {
    messages.push({ role: 'user', content: safeContext });
    messages.push({
      role: 'assistant',
      content: 'Understood. I will use page context and pending operation when routing.',
    });
  }
  const turns = redactPgpHistoryForAi(Array.isArray(recentChat) ? recentChat.slice(-10) : []);
  for (const turn of turns) {
    messages.push({
      role: turn.role === 'assistant' ? 'assistant' : 'user',
      content: trimChatContent(turn.content),
    });
  }
  messages.push({ role: 'user', content: redactPgpForAi(String(userText || '')) });
  return messages;
}

export async function analyzePgpIntent(assistant, routerCtx) {
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

function firstPgpBlock(context) {
  if (!context) return '';
  return context.publicKey || context.privateKey || context.pgpMessage || context.plainMessage || '';
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

function pickPassphrase(params, context, preferSession) {
  const fromParams = usablePassphrase(params.passphrase);
  const fromSession = usablePassphrase(context.sessionPassphrase);
  const fromForm = usablePassphrase(context.passphrase);

  if (preferSession) {
    return fromSession || fromParams || fromForm || '';
  }
  return fromParams || fromSession || fromForm || '';
}

function usablePassphrase(value) {
  const v = String(value || '').trim();
  return v && !isAiPlaceholderSecret(v) ? v : '';
}

function shouldPreferSession(plan, context) {
  if (plan.use_session_keys === true) return true;
  if (plan.use_session_keys === false) return false;
  if (context.hasSessionKeys) {
    const op = plan.intent;
    if (op === 'encrypt' || op === 'sign' || op === 'decrypt') return true;
  }
  return false;
}

export function mergePlanWithContext(plan, context) {
  if (!plan?.params || !context) return plan;
  const preferSession = shouldPreferSession(plan, context);

  const p = { ...plan, params: { ...plan.params } };

  if (p.params.publicKey && !isValidPublicKey(p.params.publicKey)) p.params.publicKey = '';
  if (p.params.privateKey && !isValidPrivateKey(p.params.privateKey)) p.params.privateKey = '';
  if (isAiPlaceholderSecret(p.params.passphrase)) p.params.passphrase = '';

  if (!p.params.message && context.plainMessage) p.params.message = context.plainMessage;
  if (!p.params.pgpMessage) {
    p.params.pgpMessage = context.pgpMessage || context.historyPgpMessage || '';
  }
  if (!p.params.signedMaterial) {
    p.params.signedMaterial = context.signedMaterial
      || context.historySignedMaterial
      || context.pgpMessage
      || context.historyPgpMessage
      || '';
  }

  p.params.publicKey = pickPublicKey(p.params, context, preferSession);
  p.params.privateKey = pickPrivateKey(p.params, context, preferSession);
  p.params.passphrase = pickPassphrase(p.params, context, preferSession);

  if (!p.params.dumpInput) p.params.dumpInput = firstPgpBlock(context);
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
      if (!p.identity) missing.push('identity');
      break;
    case 'encrypt':
      if (!p.message) missing.push('message');
      if (!p.publicKey) missing.push('publicKey');
      break;
    case 'decrypt':
      if (!p.pgpMessage) missing.push('pgpMessage');
      if (!p.privateKey) missing.push('privateKey');
      if (!p.passphrase) missing.push('passphrase');
      break;
    case 'sign':
      if (!p.message) missing.push('message');
      if (!p.privateKey) missing.push('privateKey');
      if (!p.passphrase) missing.push('passphrase');
      break;
    case 'verify':
      if (!p.signedMaterial) missing.push('signedMaterial');
      if (!p.publicKey) missing.push('publicKey');
      break;
    case 'verify_file':
      if (!p.fileBase64) missing.push('fileBase64');
      if (!p.publicKey) missing.push('publicKey');
      break;
    case 'dump':
      if (!p.dumpInput) missing.push('dumpInput');
      break;
    default:
      break;
  }
  return missing;
}

export function buildClarifyMessage(plan, missing) {
  if (plan.clarify_message) return plan.clarify_message;
  const labels = {
    identity: 'an identity (name or email for the key)',
    message: 'the plaintext message',
    publicKey: 'the PGP public key',
    pgpMessage: 'the PGP encrypted or signed message',
    privateKey: 'your PGP private key',
    passphrase: 'the private key passphrase',
    signedMaterial: 'the signed PGP message or signature block',
    dumpInput: 'a PGP public key, private key, message, or signature to analyze',
    fileBase64: 'the signed file content (paste or upload)',
  };
  const parts = missing.map((m) => labels[m] || m);
  if (!parts.length) return 'Could you provide more details?';
  return `I need ${parts.join(', ')} before I can do that. Paste them here or fill the form on the left.`;
}
