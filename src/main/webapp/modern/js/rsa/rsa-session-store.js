let session = null;

export function saveRsaSession(data) {
  if (!data?.publicKey || !data?.privateKey) return;
  session = {
    publicKey: String(data.publicKey).trim(),
    privateKey: String(data.privateKey).trim(),
    keySize: String(data.keySize || '2048').trim(),
    savedAt: Date.now(),
  };
}

export function getRsaSession() {
  return session ? { ...session } : null;
}

export function clearRsaSession() {
  session = null;
}
