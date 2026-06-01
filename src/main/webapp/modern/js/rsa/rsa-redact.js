/** Strip RSA PEM keys and signatures before AI endpoints. */

const PEM_PATTERNS = [
  { re: /-----BEGIN PUBLIC KEY-----[\s\S]*?-----END PUBLIC KEY-----/gim, hint: '[RSA public key on file in session — not sent to AI]' },
  { re: /-----BEGIN RSA PUBLIC KEY-----[\s\S]*?-----END RSA PUBLIC KEY-----/gim, hint: '[RSA public key on file in session — not sent to AI]' },
  { re: /-----BEGIN PRIVATE KEY-----[\s\S]*?-----END PRIVATE KEY-----/gim, hint: '[RSA private key on file in session — not sent to AI]' },
  { re: /-----BEGIN RSA PRIVATE KEY-----[\s\S]*?-----END RSA PRIVATE KEY-----/gim, hint: '[RSA private key on file in session — not sent to AI]' },
];

export function isAiPlaceholderSecret(value) {
  const v = String(value || '').trim();
  if (!v) return false;
  return v.startsWith('[') && (
    /not sent to AI/i.test(v)
    || /on file in session/i.test(v)
    || /redacted/i.test(v)
  );
}

export function scrubAiPlaceholdersFromPlan(plan) {
  if (!plan?.params) return plan;
  const params = { ...plan.params };
  const secretFields = ['publicKey', 'privateKey', 'ciphertext', 'signature'];
  for (const field of secretFields) {
    if (isAiPlaceholderSecret(params[field])) params[field] = '';
  }
  return { ...plan, params };
}

export function redactRsaForAi(text) {
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

export function redactRsaHistoryForAi(turns) {
  if (!Array.isArray(turns)) return [];
  return turns.map((turn) => ({
    role: turn.role,
    content: redactRsaForAi(turn.content),
  }));
}

export function redactRsaParamsForAi(params) {
  if (!params || typeof params !== 'object') return {};
  const safe = { ...params };
  for (const field of ['publicKey', 'privateKey', 'ciphertext', 'signature']) {
    if (safe[field]) safe[field] = `[${field} on file in session — not sent to AI]`;
  }
  return safe;
}
