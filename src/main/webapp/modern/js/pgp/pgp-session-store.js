/** In-memory keys from the current chat session (never sent to server for storage). */
let session = null;

export function savePgpSession(data) {
  if (!data?.publicKey || !data?.privateKey) return;
  session = {
    identity: String(data.identity || '').trim(),
    publicKey: String(data.publicKey).trim(),
    privateKey: String(data.privateKey).trim(),
    passphrase: String(data.passphrase || '').trim(),
    savedAt: Date.now(),
  };
}

export function getPgpSession() {
  return session ? { ...session } : null;
}

export function clearPgpSession() {
  session = null;
}
