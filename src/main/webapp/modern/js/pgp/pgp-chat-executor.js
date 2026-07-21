import {
  pgpGenerateKeys,
  pgpEncrypt,
  pgpDecrypt,
  pgpSign,
  pgpVerify,
  pgpVerifyFile,
  pgpDump,
  generateSecurePassphrase,
} from './pgp-api-client.js';
import {
  signCleartextClient,
  verifyCleartextClient,
  isCleartextSignedBlock,
} from './pgp-openpgp-ops.js';
import {
  mergePlanWithContext,
  requiredFieldsMissing,
  buildClarifyMessage,
} from './pgp-intent-router.js';
import {
  extractKeysFromHistory,
  extractPublicKey,
  extractPrivateKey,
  extractPgpMessage,
  extractSignedMessage,
} from './pgp-armor.js';
import { syncPgpResultToForm } from './pgp-form-sync.js';
import { getPgpSession, savePgpSession } from './pgp-session-store.js';
import { isAiPlaceholderSecret } from './pgp-redact.js';

function fence(label, text) {
  const body = String(text || '').trim();
  return `**${label}**\n\n\`\`\`\n${body}\n\`\`\``;
}

export function formatKeyGenResult(data, { keysize, cipher, generatedPassphrase } = {}) {
  const lines = [
    `Generated **RSA-${keysize || '2048'}** key pair (${cipher || 'AES_256'}) for **${data.identity}**.`,
  ];
  if (generatedPassphrase) {
    lines.push('');
    lines.push(`> Passphrase (save this — we don't store it): \`${generatedPassphrase}\``);
  }
  lines.push('');
  lines.push(fence('Public key — share freely', data.publicKey));
  lines.push('');
  lines.push(fence('Private key — keep secret', data.privateKey));
  lines.push('');
  lines.push('⚠️ **Save both keys offline.** Nothing is stored on our servers.');
  return lines.join('\n');
}

export function formatEncryptResult(data) {
  return [
    'Message encrypted successfully.',
    '',
    fence('PGP message', data.encrypted),
    '',
    'Copy and send this block to the recipient.',
  ].join('\n');
}

export function formatDecryptResult(data) {
  return [
    'Message decrypted successfully.',
    '',
    fence('Plaintext', data.plaintext),
  ].join('\n');
}

export function formatSignResult(signed) {
  return [
    'Message signed successfully.',
    '',
    fence('PGP signed message', signed),
  ].join('\n');
}

export function formatVerifyResult(data) {
  const status = data.valid ? '✅ **Signature valid**' : '❌ **Signature invalid**';
  return [
    status,
    '',
    fence('Verification result', data.message || data.plaintext || '(no details)'),
  ].join('\n');
}

export function formatDumpResult(data) {
  return [
    'PGP packet dump (RFC 4880 structure):',
    '',
    fence('Decoded packets', data.dump),
  ].join('\n');
}

function toBase64(text) {
  const bytes = new TextEncoder().encode(String(text || ''));
  let bin = '';
  bytes.forEach((b) => { bin += String.fromCharCode(b); });
  return btoa(bin);
}

async function signMessage(ctx, p) {
  try {
    const data = await pgpSign(ctx, {
      message: p.message,
      privateKey: p.privateKey,
      passphrase: p.passphrase,
    });
    return { markdown: formatSignResult(data.signed), signed: data.signed };
  } catch {
    const signed = await signCleartextClient({
      message: p.message,
      privateKey: p.privateKey,
      passphrase: p.passphrase,
    });
    return { markdown: formatSignResult(signed), signed };
  }
}

async function verifyMessage(ctx, p) {
  if (isCleartextSignedBlock(p.signedMaterial)) {
    try {
      const client = await verifyCleartextClient({
        signedMaterial: p.signedMaterial,
        publicKey: p.publicKey,
      });
      return formatVerifyResult(client);
    } catch (err) {
      return formatVerifyResult({ valid: false, message: err.message || String(err) });
    }
  }
  const data = await pgpVerify(ctx, {
    signedMaterial: p.signedMaterial,
    publicKey: p.publicKey,
  });
  return formatVerifyResult(data);
}

/**
 * Level-2: run real PGP operation and return markdown for chat.
 * @param {object} plan - intent plan (may already be merged with operation context)
 * @param {object} [opContext] - form + session + history context for merge/fallback
 */
export async function executePgpPlan(ctx, plan, opContext, options = {}) {
  const merged = opContext
    ? mergePlanWithContext(plan, opContext, options)
    : plan;
  const missing = requiredFieldsMissing(merged);
  if (missing.length) {
    return { handled: true, markdown: buildClarifyMessage(merged, missing) };
  }

  const p = merged.params;

  switch (merged.intent) {
    case 'generate_keys': {
      let passphrase = isAiPlaceholderSecret(p.passphrase) ? '' : p.passphrase;
      let generatedPassphrase = '';
      if (!passphrase) {
        generatedPassphrase = generateSecurePassphrase(20);
        passphrase = generatedPassphrase;
      }
      const data = await pgpGenerateKeys(ctx, {
        identity: p.identity,
        passphrase,
        keysize: p.keysize,
        cipher: p.cipher,
      });
      savePgpSession({
        identity: data.identity,
        publicKey: data.publicKey,
        privateKey: data.privateKey,
        passphrase,
      });
      syncPgpResultToForm('generate_keys', {
        identity: data.identity,
        publicKey: data.publicKey,
        privateKey: data.privateKey,
        passphrase,
      });
      return {
        handled: true,
        markdown: formatKeyGenResult(data, {
          keysize: p.keysize,
          cipher: p.cipher,
          generatedPassphrase,
        }),
      };
    }
    case 'encrypt': {
      const data = await pgpEncrypt(ctx, {
        message: p.message,
        publicKey: p.publicKey,
      });
      syncPgpResultToForm('encrypt', { encrypted: data.encrypted });
      return { handled: true, markdown: formatEncryptResult(data) };
    }
    case 'decrypt': {
      const data = await pgpDecrypt(ctx, {
        message: p.pgpMessage,
        privateKey: p.privateKey,
        passphrase: p.passphrase,
      });
      syncPgpResultToForm('decrypt', { plaintext: data.plaintext });
      return { handled: true, markdown: formatDecryptResult(data) };
    }
    case 'sign': {
      const { markdown, signed } = await signMessage(ctx, p);
      if (signed) syncPgpResultToForm('sign', { signed });
      return { handled: true, markdown };
    }
    case 'verify': {
      const markdown = await verifyMessage(ctx, p);
      return { handled: true, markdown };
    }
    case 'verify_file': {
      let fileBase64 = p.fileBase64;
      if (fileBase64 && !/^[A-Za-z0-9+/=]+$/.test(fileBase64.replace(/\s+/g, ''))) {
        fileBase64 = toBase64(fileBase64);
      }
      const data = await pgpVerifyFile(ctx, {
        fileBase64,
        fileName: p.fileName,
        publicKey: p.publicKey,
      });
      return { handled: true, markdown: formatVerifyResult(data) };
    }
    case 'dump': {
      const data = await pgpDump(ctx, { input: p.dumpInput });
      syncPgpResultToForm('dump', { input: p.dumpInput });
      return { handled: true, markdown: formatDumpResult(data) };
    }
    default:
      return { handled: false };
  }
}

/** Merge form fields, chat session keys, and history-extracted blocks. */
export function buildOperationContext(formContext, userText, history) {
  const form = formContext || readPgpFormContext();
  const session = getPgpSession();
  const fromHistory = extractKeysFromHistory(history);

  return {
    ...form,
    userText: String(userText || ''),
    hasSessionKeys: Boolean(session?.publicKey),
    sessionPublicKey: session?.publicKey || '',
    sessionPrivateKey: session?.privateKey || '',
    sessionPassphrase: session?.passphrase || '',
    sessionIdentity: session?.identity || '',
    historyPublicKey: fromHistory.publicKey,
    historyPrivateKey: fromHistory.privateKey,
    historyPgpMessage: fromHistory.pgpMessage,
    historySignedMaterial: fromHistory.signedMaterial,
  };
}

/** Read live form values for context merge (browser only). */
export function readPgpFormContext() {
  if (typeof document === 'undefined') return {};
  const val = (id) => {
    const el = document.getElementById(id);
    return el ? String(el.value || '').trim() : '';
  };
  const mode = val('encryptdecrypt') || 'encrypt';
  return {
    mode,
    plainMessage: val('p_cmsg'),
    publicKey: val('p_publicKey'),
    pgpMessage: val('p_pgpmessage'),
    privateKey: val('p_privateKey'),
    passphrase: val('p_passpharse'),
  };
}

export function buildPgpSeedContext() {
  const c = readPgpFormContext();
  const session = getPgpSession();
  const parts = [`Tool mode: ${c.mode}`];

  if (session?.publicKey) {
    parts.push(
      `[SESSION KEYS]\n`
      + `status: available\n`
      + `identity: ${session.identity || '(unknown)'}\n`
      + `has_public_key: yes\n`
      + `has_private_key: yes\n`
      + `has_passphrase: ${session.passphrase ? 'yes' : 'no'}\n`
      + `instruction: Set use_session_keys true when user wants these keys. Never request armored key text — client injects keys.`,
    );
  } else {
    parts.push('[SESSION KEYS]\nstatus: none');
  }

  if (c.plainMessage) {
    parts.push(`Form plaintext: yes (${c.plainMessage.length} chars — content not sent to AI)`);
  }
  if (c.publicKey) {
    parts.push('Form public key field: filled (demo/sample — armored block not sent to AI)');
  }
  if (c.privateKey) {
    parts.push('Form private key field: filled (not sent to AI)');
  }
  if (c.pgpMessage) {
    parts.push(`Form PGP message field: filled (${c.pgpMessage.length} chars — not sent to AI)`);
  }
  if (c.passphrase) {
    parts.push('Form passphrase: provided (not sent to AI)');
  }
  return parts.join('\n\n');
}

/** Pull armored blocks pasted in the user's message (overrides session when valid). */
export function applyUserMessageKeys(plan, userText) {
  if (!plan?.params || !userText) return plan;
  const pastedPub = extractPublicKey(userText);
  const pastedPriv = extractPrivateKey(userText);
  const pastedMsg = extractPgpMessage(userText);
  const pastedSigned = extractSignedMessage(userText);
  const p = { ...plan, params: { ...plan.params } };
  if (pastedPub) p.params.publicKey = pastedPub;
  if (pastedPriv) p.params.privateKey = pastedPriv;
  if (pastedMsg) p.params.pgpMessage = pastedMsg;
  if (pastedSigned) p.params.signedMaterial = pastedSigned;
  return p;
}
