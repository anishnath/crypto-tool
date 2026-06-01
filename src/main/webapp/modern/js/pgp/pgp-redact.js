/**
 * Strip PGP secrets before any text is sent to AI endpoints.
 * Full armored keys stay in session store + local chat UI only.
 */

const ARMOR_KINDS = [
  'PUBLIC KEY',
  'PRIVATE KEY',
  'MESSAGE',
  'SIGNED MESSAGE',
  'SIGNATURE',
];

const ARMOR_HINT = {
  'PUBLIC KEY': '[PGP public key on file in this session — not sent to AI]',
  'PRIVATE KEY': '[PGP private key on file in this session — not sent to AI]',
  MESSAGE: '[PGP ciphertext on file in this session — not sent to AI]',
  'SIGNED MESSAGE': '[PGP signed message on file — not sent to AI]',
  SIGNATURE: '[PGP signature on file — not sent to AI]',
};

function redactArmoredBlocks(text) {
  let s = String(text || '');
  for (const kind of ARMOR_KINDS) {
    const re = new RegExp(
      `-----BEGIN PGP ${kind} BLOCK-----[\\s\\S]*?-----END PGP ${kind} BLOCK-----`,
      'gim',
    );
    s = s.replace(re, ARMOR_HINT[kind] || '[PGP block redacted]');
  }
  return s;
}

function redactPassphrases(text) {
  let s = String(text || '');
  s = s.replace(
    /Passphrase \(save this[^`\n]*`[^`]+`/gi,
    'Passphrase: [stored in browser session only — not sent to AI]',
  );
  s = s.replace(
    />\s*Passphrase[^`\n]*`[^`]+`/gi,
    'Passphrase: [stored in browser session only — not sent to AI]',
  );
  s = s.replace(/\bpassphrase:\s*`[^`]+`/gi, 'passphrase: [redacted]');
  return s;
}

function redactPgpFences(text) {
  return String(text || '').replace(
    /```(?:\w*\n)?([\s\S]*?)```/g,
    (match, inner) => {
      if (/BEGIN PGP/i.test(inner)) {
        return '```\n[PGP material redacted — available in session]\n```';
      }
      // PGP packet dump output: fenced block listing packet fields
      // (e.g. "Key ID:", "Encoded:", "Fingerprint:", "Bit Strength:").
      // The full Encoded hex is up to ~600 chars and serves no purpose to the AI —
      // the deterministic dump already ran. Redact the same way armored blocks are.
      if (/^\s*(Key ID|Fingerprint|Algorithm|Encoded|Bit Strength|Creation Time)\s*:/im.test(inner)
          && /(Encoded|Fingerprint|Key ID)\s*:/i.test(inner)) {
        return '```\n[PGP packet dump on file in this session — not sent to AI]\n```';
      }
      return match;
    },
  );
}

/** True when value is a redaction hint echoed by the model — not a real secret. */
export function isAiPlaceholderSecret(value) {
  const v = String(value || '').trim();
  if (!v) return false;
  if (v.startsWith('[') && (
    /not sent to AI/i.test(v)
    || /on file in session/i.test(v)
    || /redacted/i.test(v)
    || /available in session/i.test(v)
  )) {
    return true;
  }
  return false;
}

/** Remove AI placeholder strings from router params before crypto merge. */
export function scrubAiPlaceholdersFromPlan(plan) {
  if (!plan?.params) return plan;
  const params = { ...plan.params };
  const secretFields = [
    'passphrase', 'publicKey', 'privateKey', 'pgpMessage',
    'signedMaterial', 'dumpInput', 'fileBase64',
  ];
  for (const field of secretFields) {
    if (isAiPlaceholderSecret(params[field])) params[field] = '';
  }
  return { ...plan, params };
}

/** Redact PGP keys, messages, and passphrases from text bound for an AI endpoint. */
export function redactPgpForAi(text) {
  if (!text) return '';
  let s = String(text);
  s = redactArmoredBlocks(s);
  s = redactPassphrases(s);
  s = redactPgpFences(s);
  return s.trim();
}

/** Redact chat turns before sending to the router or explain stream. */
export function redactPgpHistoryForAi(turns) {
  if (!Array.isArray(turns)) return [];
  return turns.map((turn) => ({
    role: turn.role,
    content: redactPgpForAi(turn.content),
  }));
}

/** Strip secret fields from params logged in pending-operation context. */
export function redactPgpParamsForAi(params) {
  if (!params || typeof params !== 'object') return {};
  const safe = { ...params };
  const secretFields = [
    'publicKey', 'privateKey', 'passphrase', 'pgpMessage',
    'signedMaterial', 'dumpInput', 'fileBase64',
  ];
  for (const field of secretFields) {
    if (safe[field]) {
      safe[field] = `[${field} on file in session — not sent to AI]`;
    }
  }
  return safe;
}
