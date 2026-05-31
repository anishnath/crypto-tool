/**
 * JSON client for /api/pgp/* — real crypto via Tomcat, never in the LLM.
 */

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
    const err = new Error(data.error || `PGP request failed (${res.status})`);
    err.status = res.status;
    throw err;
  }
  return data;
}

export async function pgpGenerateKeys(ctx, {
  identity = '',
  passphrase = '',
  keysize = '2048',
  cipher = 'AES_256',
} = {}) {
  return postJson(ctx, '/api/pgp/generate-keys', {
    identity,
    passphrase,
    keysize,
    cipher,
  });
}

export async function pgpEncrypt(ctx, { message = '', publicKey = '' } = {}) {
  return postJson(ctx, '/api/pgp/encrypt', { message, publicKey });
}

export async function pgpDecrypt(ctx, {
  message = '',
  privateKey = '',
  passphrase = '',
} = {}) {
  return postJson(ctx, '/api/pgp/decrypt', { message, privateKey, passphrase });
}

export async function pgpSign(ctx, { message = '', privateKey = '', passphrase = '' } = {}) {
  return postJson(ctx, '/api/pgp/sign', { message, privateKey, passphrase });
}

export async function pgpVerify(ctx, { signedMaterial = '', publicKey = '' } = {}) {
  return postJson(ctx, '/api/pgp/verify', { signedMaterial, publicKey });
}

export async function pgpVerifyFile(ctx, { fileBase64 = '', fileName = '', publicKey = '' } = {}) {
  return postJson(ctx, '/api/pgp/verify-file', { fileBase64, fileName, publicKey });
}

export async function pgpDump(ctx, { input = '' } = {}) {
  return postJson(ctx, '/api/pgp/dump', { input });
}

/** Generate a random passphrase for key generation when user did not supply one. */
export function generateSecurePassphrase(length = 20) {
  const chars = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%&*';
  const bytes = new Uint8Array(length);
  crypto.getRandomValues(bytes);
  let out = '';
  for (let i = 0; i < length; i += 1) {
    out += chars[bytes[i] % chars.length];
  }
  return out;
}
