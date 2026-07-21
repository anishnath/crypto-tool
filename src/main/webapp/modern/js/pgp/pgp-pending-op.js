/** Tracks an in-progress PGP operation awaiting user input (e.g. missing message). */
import {
  extractPgpMessage,
  extractSignedMessage,
  extractPublicKey,
  extractPrivateKey,
} from './pgp-armor.js';
import { isAiPlaceholderSecret } from './pgp-redact.js';

let pending = null;

export function setPendingOperation(plan, missing) {
  if (!plan?.intent || !missing?.length) {
    pending = null;
    return;
  }
  pending = {
    intent: plan.intent,
    params: { ...(plan.params || {}) },
    missing: [...missing],
  };
}

export function getPendingOperation() {
  if (!pending) return null;
  return {
    intent: pending.intent,
    params: { ...pending.params },
    missing: [...pending.missing],
  };
}

export function clearPendingOperation() {
  pending = null;
}

const FIELD_SETTERS = {
  message: (params, value) => { params.message = value; },
  identity: (params, value) => { params.identity = value; },
  passphrase: (params, value) => { params.passphrase = value; },
  pgpMessage: (params, value) => { params.pgpMessage = value; },
  signedMaterial: (params, value) => { params.signedMaterial = value; },
  dumpInput: (params, value) => { params.dumpInput = value; },
  fileBase64: (params, value) => { params.fileBase64 = value; },
};

function extractPendingFieldValue(field, text) {
  if (field === 'pgpMessage') {
    return extractPgpMessage(text) || extractSignedMessage(text) || '';
  }
  if (field === 'signedMaterial') {
    return extractSignedMessage(text) || extractPgpMessage(text) || '';
  }
  if (field === 'dumpInput') {
    return extractPgpMessage(text)
      || extractSignedMessage(text)
      || extractPublicKey(text)
      || extractPrivateKey(text)
      || '';
  }
  return text;
}

/** Safety net when the router misses a follow-up; prompt is primary. */
export function applyPendingFallback(userText, pendingOp, plan) {
  if (!pendingOp?.intent || !pendingOp.missing?.length) return plan;

  const routerHandled = plan?.is_follow_up
    || (plan?.intent === pendingOp.intent && plan?.params?.message);
  if (routerHandled) return plan;

  const needsHelp = !plan
    || plan.intent === 'explain'
    || plan.intent === 'clarify';
  if (!needsHelp) return plan;

  const text = String(userText || '').trim();
  if (!text || text.length > 8000 || isAiPlaceholderSecret(text)) return plan;

  const field = pendingOp.missing[0];
  let value = text;
  if (/-----BEGIN PGP/.test(text)) {
    value = extractPendingFieldValue(field, text);
    if (!value) return plan;
  }

  const params = { ...pendingOp.params, ...(plan?.params || {}) };
  const setter = FIELD_SETTERS[field];
  if (setter && !params[field]) setter(params, value);

  return {
    intent: pendingOp.intent,
    use_session_keys: plan?.use_session_keys ?? true,
    is_follow_up: true,
    params,
    missing: pendingOp.missing.filter((f) => f !== field),
    clarify_message: '',
  };
}
