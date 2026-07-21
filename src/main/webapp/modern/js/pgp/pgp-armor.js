/** OpenPGP armor headers — not all block types use the " BLOCK" suffix (RFC 4880). */
const ARMOR_HEADERS = {
  'PUBLIC KEY': { begin: 'BEGIN PGP PUBLIC KEY BLOCK', end: 'END PGP PUBLIC KEY BLOCK' },
  'PRIVATE KEY': { begin: 'BEGIN PGP PRIVATE KEY BLOCK', end: 'END PGP PRIVATE KEY BLOCK' },
  MESSAGE: { begin: 'BEGIN PGP MESSAGE', end: 'END PGP MESSAGE' },
  'SIGNED MESSAGE': { begin: 'BEGIN PGP SIGNED MESSAGE', end: 'END PGP SIGNED MESSAGE' },
  SIGNATURE: { begin: 'BEGIN PGP SIGNATURE', end: 'END PGP SIGNATURE' },
};

function armorRegex(kind, flags = 'm') {
  const h = ARMOR_HEADERS[kind];
  if (!h) return null;
  return new RegExp(
    `-----${h.begin}-----[\\s\\S]*?-----${h.end}-----`,
    flags,
  );
}

/** Extract a full armored OpenPGP block from text (markdown fences OK). */
export function extractArmoredBlock(text, kind) {
  const re = armorRegex(kind);
  if (!re) return '';
  const m = String(text || '').match(re);
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

/** Scan chat history for the most recent armored blocks (assistant + user turns). */
export function extractKeysFromHistory(history) {
  const out = { publicKey: '', privateKey: '', pgpMessage: '', signedMaterial: '' };
  if (!Array.isArray(history)) return out;

  for (let i = history.length - 1; i >= 0; i--) {
    const msg = history[i];
    if (msg?.role !== 'assistant' && msg?.role !== 'user') continue;
    const text = msg.content || '';
    if (!out.publicKey) out.publicKey = extractPublicKey(text);
    if (!out.privateKey) out.privateKey = extractPrivateKey(text);
    if (!out.pgpMessage) out.pgpMessage = extractPgpMessage(text);
    if (!out.signedMaterial) out.signedMaterial = extractSignedMessage(text);
    if (out.publicKey && out.privateKey && out.pgpMessage) break;
  }
  return out;
}
