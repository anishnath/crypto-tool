/** Pending RSA operation awaiting user input. */
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
  ciphertext: (params, value) => { params.ciphertext = value; },
  signature: (params, value) => { params.signature = value; },
  keysize: (params, value) => { params.keysize = value; },
  algorithm: (params, value) => { params.algorithm = value; },
};

export function applyPendingFallback(userText, pendingOp, plan) {
  if (!pendingOp?.intent || !pendingOp.missing?.length) return plan;

  const routerHandled = plan?.is_follow_up
    || (plan?.intent === pendingOp.intent && plan?.params?.message);
  if (routerHandled) return plan;

  const needsHelp = !plan || plan.intent === 'explain' || plan.intent === 'clarify';
  if (!needsHelp) return plan;

  const text = String(userText || '').trim();
  if (!text || /-----BEGIN (RSA )?(PUBLIC|PRIVATE) KEY/i.test(text)) return plan;

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
