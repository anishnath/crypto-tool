import {
  rsaGenerateKeys,
  rsaEncrypt,
  rsaDecrypt,
  rsaSign,
  rsaVerify,
} from './rsa-api-client.js';
import {
  mergePlanWithContext,
  requiredFieldsMissing,
  buildClarifyMessage,
} from './rsa-intent-router.js';
import { extractKeysFromHistory, extractPublicKey, extractPrivateKey } from './rsa-pem.js';
import { getRsaSession, saveRsaSession } from './rsa-session-store.js';

function fence(label, text) {
  const body = String(text || '').trim();
  return `**${label}**\n\n\`\`\`\n${body}\n\`\`\``;
}

export function formatKeyGenResult(data, { keysize } = {}) {
  const lines = [
    `Generated **RSA-${keysize || data.keySize || '2048'}** key pair.`,
    '',
    fence('Public key (PEM) — share freely', data.publicKey),
    '',
    fence('Private key (PEM) — keep secret', data.privateKey),
    '',
    '⚠️ **Save both keys offline.** Session keys are stored in your browser only.',
  ];
  return lines.join('\n');
}

export function formatEncryptResult(data) {
  return [
    'Message encrypted successfully.',
    '',
    fence('Ciphertext (Base64)', data.ciphertext),
    '',
    'Copy this Base64 string for decryption or sharing.',
  ].join('\n');
}

export function formatDecryptResult(data) {
  return [
    'Message decrypted successfully.',
    '',
    fence('Plaintext', data.plaintext),
  ].join('\n');
}

export function formatSignResult(data) {
  return [
    'Message signed successfully.',
    '',
    fence('Signature (Base64)', data.signature),
  ].join('\n');
}

export function formatVerifyResult(data) {
  const status = data.valid ? '✅ **Signature valid**' : '❌ **Signature invalid**';
  return [
    status,
    '',
    fence('Verification result', data.message || '(no details)'),
  ].join('\n');
}

/**
 * Level-2: run real RSA operation and return markdown for chat.
 */
export async function executeRsaPlan(ctx, plan, opContext) {
  const merged = opContext ? mergePlanWithContext(plan, opContext) : plan;
  const missing = requiredFieldsMissing(merged);
  if (missing.length) {
    return { handled: true, markdown: buildClarifyMessage(merged, missing) };
  }

  const p = merged.params;

  switch (merged.intent) {
    case 'generate_keys': {
      const data = await rsaGenerateKeys(ctx, { keysize: p.keysize });
      saveRsaSession({
        publicKey: data.publicKey,
        privateKey: data.privateKey,
        keySize: data.keySize || p.keysize,
      });
      return {
        handled: true,
        markdown: formatKeyGenResult(data, { keysize: p.keysize }),
      };
    }
    case 'encrypt': {
      const data = await rsaEncrypt(ctx, {
        message: p.message,
        publicKey: p.publicKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatEncryptResult(data) };
    }
    case 'decrypt': {
      const data = await rsaDecrypt(ctx, {
        ciphertext: p.ciphertext,
        privateKey: p.privateKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatDecryptResult(data) };
    }
    case 'sign': {
      const data = await rsaSign(ctx, {
        message: p.message,
        privateKey: p.privateKey,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatSignResult(data) };
    }
    case 'verify': {
      const data = await rsaVerify(ctx, {
        message: p.message,
        publicKey: p.publicKey,
        signature: p.signature,
        algorithm: p.algorithm,
      });
      return { handled: true, markdown: formatVerifyResult(data) };
    }
    default:
      return { handled: false };
  }
}

export function buildOperationContext(formContext, userText, history) {
  const form = formContext || readRsaFormContext();
  const session = getRsaSession();
  const fromHistory = extractKeysFromHistory(history);

  return {
    ...form,
    userText: String(userText || ''),
    hasSessionKeys: Boolean(session?.publicKey),
    sessionPublicKey: session?.publicKey || '',
    sessionPrivateKey: session?.privateKey || '',
    sessionKeySize: session?.keySize || '',
    historyPublicKey: fromHistory.publicKey,
    historyPrivateKey: fromHistory.privateKey,
    historyCiphertext: fromHistory.ciphertext,
    historySignature: fromHistory.signature,
  };
}

export function readRsaFormContext() {
  if (typeof document === 'undefined') return {};
  const val = (id) => {
    const el = document.getElementById(id);
    return el ? String(el.value || '').trim() : '';
  };
  const modeEl = document.querySelector('input[name="op_mode"]:checked');
  const mode = modeEl ? modeEl.value : 'encrypt';
  const keysizeEl = document.querySelector('input[name="keysize_ui"]:checked');
  const keysize = keysizeEl ? keysizeEl.value : '2048';
  const message = val('message');
  return {
    mode,
    keysize,
    plainMessage: mode === 'decrypt' ? '' : message,
    ciphertext: mode === 'decrypt' ? message : '',
    signature: val('signatureInput'),
    publicKey: val('publickeyparam'),
    privateKey: val('privatekeyparam'),
    algorithm: val('cipherSelect'),
  };
}

export function buildRsaSeedContext() {
  const c = readRsaFormContext();
  const session = getRsaSession();
  const parts = [`Tool mode: ${c.mode}`, `Key size (form): ${c.keysize}`];

  if (session?.publicKey) {
    parts.push(
      `[SESSION KEYS]\n`
      + `status: available\n`
      + `key_size: ${session.keySize || c.keysize}\n`
      + `has_public_key: yes\n`
      + `has_private_key: yes\n`
      + `instruction: Set use_session_keys true when user wants these keys. Never request PEM key text — client injects keys.`,
    );
  } else {
    parts.push('[SESSION KEYS]\nstatus: none');
  }

  if (c.plainMessage) {
    parts.push(`Form message field: yes (${c.plainMessage.length} chars — content not sent to AI)`);
  }
  if (c.ciphertext) {
    parts.push(`Form ciphertext field: yes (${c.ciphertext.length} chars — not sent to AI)`);
  }
  if (c.publicKey) {
    parts.push('Form public key field: filled (PEM not sent to AI)');
  }
  if (c.privateKey) {
    parts.push('Form private key field: filled (not sent to AI)');
  }
  if (c.signature) {
    parts.push('Form signature field: filled (not sent to AI)');
  }
  if (c.algorithm) {
    parts.push(`Form algorithm: ${c.algorithm}`);
  }
  return parts.join('\n\n');
}

export function applyUserMessageKeys(plan, userText) {
  if (!plan?.params || !userText) return plan;
  const pastedPub = extractPublicKey(userText);
  const pastedPriv = extractPrivateKey(userText);
  const p = { ...plan, params: { ...plan.params } };
  if (pastedPub) p.params.publicKey = pastedPub;
  if (pastedPriv) p.params.privateKey = pastedPriv;
  return p;
}
