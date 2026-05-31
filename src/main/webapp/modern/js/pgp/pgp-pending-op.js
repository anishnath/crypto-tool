/** Tracks an in-progress PGP operation awaiting user input (e.g. missing message). */
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
  if (!text || text.length > 8000 || /-----BEGIN PGP/.test(text)) return plan;

  const params = { ...pendingOp.params, ...(plan?.params || {}) };
  const field = pendingOp.missing[0];
  const setter = FIELD_SETTERS[field];
  if (setter && !params[field]) setter(params, text);

  return {
    intent: pendingOp.intent,
    use_session_keys: plan?.use_session_keys ?? true,
    is_follow_up: true,
    params,
    missing: pendingOp.missing.filter((f) => f !== field),
    clarify_message: '',
  };
}
