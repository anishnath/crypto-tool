/** Client-side OpenPGP.js ops (fallback + cleartext sign/verify). Matches pgp-suite.jsp. */

let openpgpLoadPromise = null;

function loadOpenPgp() {
  if (typeof window !== 'undefined' && window.openpgp) {
    return Promise.resolve(window.openpgp);
  }
  if (!openpgpLoadPromise) {
    openpgpLoadPromise = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = 'https://unpkg.com/openpgp@5.11.2/dist/openpgp.min.js';
      script.async = true;
      script.onload = () => resolve(window.openpgp);
      script.onerror = () => reject(new Error('Failed to load OpenPGP.js'));
      document.head.appendChild(script);
    });
  }
  return openpgpLoadPromise;
}

/** Cleartext sign in browser (private key never sent to server). */
export async function signCleartextClient({ message = '', privateKey = '', passphrase = '' } = {}) {
  const text = String(message || '').trim();
  const privArm = String(privateKey || '').trim();
  const pass = String(passphrase || '');
  if (!text || !privArm || !pass) {
    throw new Error('Message, private key, and passphrase are required to sign');
  }

  const openpgp = await loadOpenPgp();
  const priv = await openpgp.readPrivateKey({ armoredKey: privArm });
  const dPriv = await openpgp.decryptKey({ privateKey: priv, passphrase: pass });
  const msg = await openpgp.createCleartextMessage({ text });
  const signed = await openpgp.sign({ message: msg, signingKeys: dPriv });
  return String(signed);
}

/** Verify cleartext signed message in browser. */
export async function verifyCleartextClient({ signedMaterial = '', publicKey = '' } = {}) {
  const signed = String(signedMaterial || '').trim();
  const pubArm = String(publicKey || '').trim();
  if (!signed || !pubArm) {
    throw new Error('Signed message and public key are required');
  }

  const openpgp = await loadOpenPgp();
  const publicKeyObj = await openpgp.readKey({ armoredKey: pubArm });
  const message = await openpgp.readCleartextMessage({ cleartextMessage: signed });
  const verification = await openpgp.verify({ message, verificationKeys: publicKeyObj });
  const { verified, keyID } = verification.signatures[0] || {};
  await verified;
  const data = message.getText();
  return {
    valid: true,
    message: `Signature valid. Signer key ID: ${keyID?.toHex?.() || keyID || 'unknown'}\n\nExtracted message:\n${data}`,
    plaintext: data,
  };
}

export function isCleartextSignedBlock(text) {
  const s = String(text || '');
  return s.includes('BEGIN PGP SIGNED MESSAGE') && s.includes('BEGIN PGP SIGNATURE');
}
