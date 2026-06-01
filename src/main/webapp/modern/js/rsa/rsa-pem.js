export function extractPublicKey(text) {
  const raw = String(text || '');
  const patterns = [
    /-----BEGIN PUBLIC KEY-----[\s\S]*?-----END PUBLIC KEY-----/m,
    /-----BEGIN RSA PUBLIC KEY-----[\s\S]*?-----END RSA PUBLIC KEY-----/m,
  ];
  for (const re of patterns) {
    const m = raw.match(re);
    if (m) return m[0].trim();
  }
  return '';
}

export function extractPrivateKey(text) {
  const raw = String(text || '');
  const patterns = [
    /-----BEGIN PRIVATE KEY-----[\s\S]*?-----END PRIVATE KEY-----/m,
    /-----BEGIN RSA PRIVATE KEY-----[\s\S]*?-----END RSA PRIVATE KEY-----/m,
  ];
  for (const re of patterns) {
    const m = raw.match(re);
    if (m) return m[0].trim();
  }
  return '';
}

export function isValidPublicKey(key) {
  const k = String(key || '');
  return (k.includes('BEGIN PUBLIC KEY') || k.includes('BEGIN RSA PUBLIC KEY'))
    && (k.includes('END PUBLIC KEY') || k.includes('END RSA PUBLIC KEY'));
}

export function isValidPrivateKey(key) {
  const k = String(key || '');
  return (k.includes('BEGIN PRIVATE KEY') || k.includes('BEGIN RSA PRIVATE KEY'))
    && (k.includes('END PRIVATE KEY') || k.includes('END RSA PRIVATE KEY'));
}

export function extractKeysFromHistory(history) {
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
