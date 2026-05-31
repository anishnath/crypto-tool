/** Extract a full armored OpenPGP block from text (markdown fences OK). */
export function extractArmoredBlock(text, kind) {
  const raw = String(text || '');
  const re = new RegExp(
    `-----BEGIN PGP ${kind} BLOCK-----[\\s\\S]*?-----END PGP ${kind} BLOCK-----`,
    'm',
  );
  const m = raw.match(re);
  return m ? m[0].trim() : '';
}

export function extractPublicKey(text) {
  return extractArmoredBlock(text, 'PUBLIC KEY');
}

export function extractPrivateKey(text) {
  return extractArmoredBlock(text, 'PRIVATE KEY');
}

export function extractPgpMessage(text) {
  return extractArmoredBlock(text, 'MESSAGE');
}

export function extractSignedMessage(text) {
  const signed = extractArmoredBlock(text, 'SIGNED MESSAGE');
  if (signed) return signed;
  const sig = extractArmoredBlock(text, 'SIGNATURE');
  return sig;
}

export function isValidPublicKey(key) {
  const k = String(key || '');
  return k.includes('BEGIN PGP PUBLIC KEY BLOCK') && k.includes('END PGP PUBLIC KEY BLOCK');
}

export function isValidPrivateKey(key) {
  const k = String(key || '');
  return k.includes('BEGIN PGP PRIVATE KEY BLOCK') && k.includes('END PGP PRIVATE KEY BLOCK');
}

/** User refers to keys from this chat session, not the form defaults. */
export function prefersSessionKeys(userText) {
  const t = String(userText || '').toLowerCase();
  return (
    /\b(my|the|these|those)\s+(pgp\s+)?(public\s+|private\s+)?keys?\b/.test(t)
    || /\bkeys?\s+(you|we|i|just)\s+(generated|created|made)\b/.test(t)
    || /\buse\s+(my|the)\s+(public\s+|private\s+)?keys?\b/.test(t)
    || /\b(the|my)\s+key\s+(pair|from|you)\b/.test(t)
    || /\bpublic keys?\s+to\s+encrypt\b/.test(t)
    || /\bencrypt.*\bmy\b.*\bkeys?\b/.test(t)
  );
}

/** Scan assistant history for the most recent full key blocks. */
export function extractKeysFromHistory(history) {
  const out = { publicKey: '', privateKey: '', pgpMessage: '', signedMaterial: '' };
  if (!Array.isArray(history)) return out;

  for (let i = history.length - 1; i >= 0; i--) {
    const msg = history[i];
    if (msg?.role !== 'assistant') continue;
    const text = msg.content || '';
    if (!out.publicKey) out.publicKey = extractPublicKey(text);
    if (!out.privateKey) out.privateKey = extractPrivateKey(text);
    if (!out.pgpMessage) out.pgpMessage = extractPgpMessage(text);
    if (!out.signedMaterial) out.signedMaterial = extractSignedMessage(text);
    if (out.publicKey && out.privateKey) break;
  }
  return out;
}
