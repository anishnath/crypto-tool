/** JSON client for /api/rsa/* */

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
    const err = new Error(data.error || `RSA request failed (${res.status})`);
    err.status = res.status;
    throw err;
  }
  return data;
}

export async function rsaGenerateKeys(ctx, { keysize = '2048' } = {}) {
  return postJson(ctx, '/api/rsa/generate-keys', { keysize });
}

export async function rsaEncrypt(ctx, { message = '', publicKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/encrypt', { message, publicKey, algorithm });
}

export async function rsaDecrypt(ctx, { ciphertext = '', privateKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/decrypt', { ciphertext, privateKey, algorithm });
}

export async function rsaSign(ctx, { message = '', privateKey = '', algorithm = '' } = {}) {
  return postJson(ctx, '/api/rsa/sign', { message, privateKey, algorithm });
}

export async function rsaVerify(ctx, {
  message = '', publicKey = '', signature = '', algorithm = '',
} = {}) {
  return postJson(ctx, '/api/rsa/verify', { message, publicKey, signature, algorithm });
}
