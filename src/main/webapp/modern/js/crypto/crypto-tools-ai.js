/**
 * Crypto tools AI — single bundled module (registry, API, router, executor, adapter).
 * Lazy-loaded once per page to avoid a deep ES module chain on first AI open.
 */
import { chat } from '../llm-client.js';
import { VibeCodingAssistant } from '../ai/assistant-core.js';

// --- api ---
/**
 * Unified crypto tool API — POST /api/crypto/execute
 */

function joinUrl(ctx, path) {
  const base = String(ctx || '').replace(/\/$/, '');
  return base + path;
}

async function postJson(ctx, body) {
  const res = await fetch(joinUrl(ctx, '/api/crypto/execute'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify(body),
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok || data.ok === false) {
    const err = new Error(data.error || data.errorMessage || `Request failed (${res.status})`);
    err.status = res.status;
    err.data = data;
    throw err;
  }
  return data;
}

/**
 * @param {string} ctx
 * @param {{ tool: string, operation: string, params?: object }} req
 */
async function cryptoExecute(ctx, { tool, operation, params = {} }) {
  return postJson(ctx, { tool, operation, params });
}
// --- registry ---
/**
 * Per-page profiles for the unified crypto AI assistant.
 * tool: backend CryptoBackendClient key
 * toolId: billing / analytics path
 */

/** Checkbox values on hmacgen.jsp — must match MDFunctionality macchoices */
const HMAC_CANONICAL_IDS = [
  'HmacSHA256', 'HmacSHA512', 'HmacSHA224', 'HmacSHA384',
  'HmacSHA1', 'HMACTIGER', 'HMACRIPEMD128', 'HMACRIPEMD160',
  'RC2MAC', 'RC5MAC', 'IDEAMAC', 'DES', 'DESEDEMAC',
  'HMACMD5', 'HMACMD4', 'HMACMD2',
];

const CRYPTO_TOOLS = {
  'message-digest': {
    tool: 'message-digest',
    toolId: 'cryptography/message-digest',
    title: 'Hash AI',
    subtitle: 'Hash text with MD5, SHA-2, SHA-3, BLAKE2, and more.',
    operations: ['hash', 'explain'],
    defaultAlgorithms: ['SHA-256'],
    readForm: () => ({
      text: document.getElementById('inputtext')?.value || '',
      algorithms: selectedCheckboxes('cipherparameternew'),
    }),
    applyToForm: (params) => {
      if (params.text) {
        const el = document.getElementById('inputtext');
        if (el) el.value = params.text;
      }
      if (params.algorithms?.length) {
        setCheckboxes('cipherparameternew', params.algorithms);
      }
    },
    quickActions: [
      { label: 'SHA-256', prompt: 'Hash "hello world" with SHA-256', sendImmediately: true },
      { label: 'SHA-512', prompt: 'Hash "test" with SHA-512 and SHA-256', sendImmediately: true },
      { label: 'What is SHA-256?', prompt: 'Explain SHA-256 in plain English.', sendImmediately: true },
    ],
  },
  hmac: {
    tool: 'hmac',
    toolId: 'cryptography/hmac',
    title: 'HMAC AI',
    subtitle: 'Keyed hashes for API signing and message authentication.',
    operations: ['hmac', 'explain'],
    defaultAlgorithms: ['HmacSHA256'],
    supportedAlgorithms: HMAC_CANONICAL_IDS,
    readForm: () => ({
      text: document.querySelector('#hmacForm [name=text], #inputtext')?.value || '',
      key: document.getElementById('passphrase')?.value || '',
      algorithms: selectedHmacAlgorithms(),
    }),
    applyToForm: (params) => {
      const textEl = document.querySelector('#hmacForm [name=text], #inputtext');
      if (textEl && params.text) textEl.value = params.text;
      const keyEl = document.getElementById('passphrase');
      if (keyEl && params.key) keyEl.value = params.key;
      if (params.algorithms?.length) setHmacCheckboxes(params.algorithms);
    },
    quickActions: [
      { label: 'HMAC-SHA256', prompt: 'Compute HMAC-SHA256 of "hello" with key "secretsecretsecret"', sendImmediately: true },
      { label: 'Explain HMAC', prompt: 'What is HMAC and when should I use it?', sendImmediately: true },
    ],
  },
  cipher: {
    tool: 'cipher',
    toolId: 'cryptography/cipher',
    title: 'Cipher AI',
    subtitle: 'Encrypt and decrypt with AES, ChaCha20, and 100+ algorithms.',
    operations: ['encrypt', 'decrypt', 'explain'],
    readForm: () => ({
      message: document.getElementById('plaintext')?.value || '',
      secretKey: document.getElementById('secretkey')?.value || '',
      algorithm: document.querySelector('[name=cipherparameternew]:checked')?.value
        || document.getElementById('cipherparameternew')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.message) {
        const el = document.getElementById('plaintext');
        if (el) el.value = params.message;
      }
      if (params.secretKey) {
        const el = document.getElementById('secretkey');
        if (el) el.value = params.secretKey;
      }
      if (params.algorithm) {
        const sel = document.getElementById('cipherparameternew');
        if (sel) {
          const resolved = resolveCipherAlgorithm(params.algorithm, '', params.secretKey);
          if (resolved) sel.value = resolved;
        }
      }
    },
    quickActions: [
      { label: 'AES-GCM encrypt', prompt: 'Encrypt "secret data" with AES/GCM/NoPadding using a random 256-bit key (hex)', sendImmediately: true },
      { label: 'Explain modes', prompt: 'Explain AES-GCM vs CBC for encryption.', sendImmediately: true },
    ],
  },
  pbkdf: {
    tool: 'pbkdf',
    toolId: 'cryptography/pbkdf',
    title: 'PBKDF2 AI',
    subtitle: 'Derive keys from passwords with PBKDF2.',
    operations: ['derive', 'explain'],
    readForm: () => ({
      password: document.getElementById('password')?.value || '',
      salt: document.getElementById('salt')?.value || '',
      rounds: document.getElementById('rounds')?.value || '',
      keyLength: document.getElementById('keylength')?.value || '',
      algorithms: selectedCheckboxes('cipherparameternew'),
    }),
    applyToForm: (params) => {
      if (params.password) {
        const el = document.getElementById('password');
        if (el) el.value = params.password;
      }
      if (params.salt) {
        const el = document.getElementById('salt');
        if (el) el.value = params.salt;
      }
      if (params.rounds) {
        const el = document.getElementById('rounds');
        if (el) el.value = params.rounds;
      }
      const kl = params.keyLength || params.keylength;
      if (kl) {
        const el = document.getElementById('keylength');
        if (el) el.value = kl;
      }
      const algos = params.algorithms?.length
        ? params.algorithms
        : (params.algorithm ? [params.algorithm] : []);
      if (algos.length) setCheckboxes('cipherparameternew', algos.map((a) => normalizePbkdfAlgorithm(a)).filter(Boolean));
    },
    quickActions: [
      { label: 'Derive key', prompt: 'Derive a 32-byte key with PBKDF2-HMAC-SHA256, password "test", salt "salt", 10000 rounds', sendImmediately: true },
    ],
  },
  pbe: {
    tool: 'pbe',
    toolId: 'cryptography/pbe',
    title: 'PBE AI',
    subtitle: 'Password-based encrypt/decrypt (PBEWith* algorithms).',
    operations: ['encrypt', 'decrypt', 'explain'],
    defaultAlgorithms: ['PBEWITHHMACSHA256ANDAES_256'],
    readForm: () => {
      const sel = document.getElementById('cipherparameternew');
      const algorithms = sel
        ? [...sel.selectedOptions].map((o) => o.value).filter(Boolean)
        : [];
      return {
        message: document.getElementById('message')?.value || '',
        password: document.getElementById('password')?.value || '',
        rounds: document.getElementById('rounds')?.value || '10000',
        algorithm: algorithms[0] || '',
        algorithms,
      };
    },
    applyToForm: (params) => {
      if (params.message) {
        const el = document.getElementById('message');
        if (el) el.value = params.message;
      }
      if (params.password) {
        const el = document.getElementById('password');
        if (el) el.value = params.password;
      }
      if (params.rounds) {
        const el = document.getElementById('rounds');
        if (el) el.value = params.rounds;
      }
      const algo = normalizePbeAlgorithm(
        params.algorithm || params.algorithms?.[0] || params.algo || '',
      );
      if (algo) {
        const sel = document.getElementById('cipherparameternew');
        if (sel) sel.value = algo;
      }
      const modeEl = document.getElementById('encryptdecryptparameter');
      if (modeEl && (params.intent === 'decrypt' || params.mode === 'decrypt')) {
        modeEl.value = 'decryprt';
      } else if (modeEl && (params.intent === 'encrypt' || params.mode === 'encrypt')) {
        modeEl.value = 'encrypt';
      }
    },
    quickActions: [
      { label: 'PBE encrypt', prompt: 'Encrypt "hello" with PBEWITHHMACSHA256ANDAES_256 password "pass" 10000 rounds', sendImmediately: true },
    ],
  },
  bcrypt: {
    tool: 'bcrypt',
    toolId: 'cryptography/bcrypt',
    title: 'bcrypt AI',
    subtitle: 'Hash and verify passwords with bcrypt.',
    operations: ['hash', 'verify', 'explain'],
    readForm: () => ({
      password: document.getElementById('password')?.value
        || document.getElementById('verifyPassword')?.value || '',
      hash: document.getElementById('verifyHash')?.value || '',
      cost: document.querySelector('input[name=workload]:checked')?.value || '12',
    }),
    quickActions: [
      { label: 'Hash password', prompt: 'bcrypt-hash password "MyP@ssw0rd" with cost 12', sendImmediately: true },
    ],
  },
  scrypt: {
    tool: 'scrypt',
    toolId: 'cryptography/scrypt',
    title: 'scrypt AI',
    subtitle: 'Memory-hard password hashing with scrypt.',
    operations: ['hash', 'verify', 'explain'],
    readForm: () => ({
      password: document.getElementById('password')?.value
        || document.getElementById('verifyPassword')?.value || '',
      hash: document.getElementById('verifyHash')?.value || '',
      salt: document.getElementById('salt')?.value
        || document.getElementById('verifySalt')?.value || '',
      n: document.getElementById('workparam')?.value || '',
      r: document.getElementById('memoryparam')?.value || '',
      p: document.getElementById('parallelizationparam')?.value || '',
      length: document.getElementById('length')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.password) {
        const el = document.getElementById('password');
        if (el) el.value = params.password;
      }
      if (params.salt) {
        const el = document.getElementById('salt');
        if (el) el.value = params.salt;
      }
      const setSelect = (id, val) => {
        if (val == null || val === '') return;
        const el = document.getElementById(id);
        if (el) el.value = String(val);
      };
      setSelect('workparam', params.n || params.workparam);
      setSelect('memoryparam', params.r || params.memoryparam);
      setSelect('parallelizationparam', params.p || params.parallelizationparam);
      setSelect('length', params.length);
      if (params.hash) {
        const el = document.getElementById('verifyHash');
        if (el) el.value = params.hash;
      }
      if (params.password && params.intent === 'verify') {
        const el = document.getElementById('verifyPassword');
        if (el) el.value = params.password;
      }
      if (params.salt && params.intent === 'verify') {
        const el = document.getElementById('verifySalt');
        if (el) el.value = params.salt;
      }
    },
    quickActions: [
      { label: 'scrypt hash', prompt: 'scrypt-hash password "test" with salt "randomsalt"', sendImmediately: true },
    ],
  },
  htpasswd: {
    tool: 'htpasswd',
    toolId: 'cryptography/htpasswd',
    title: 'htpasswd AI',
    subtitle: 'Generate Apache/Nginx htpasswd lines — or ask how to add users and configure basic auth.',
    operations: ['generate', 'verify', 'explain'],
    readForm: () => ({
      username: document.getElementById('username')?.value || '',
      password: document.getElementById('password')?.value
        || document.getElementById('verifyPassword')?.value || '',
      hash: document.getElementById('verifyHash')?.value || '',
      algorithm: document.querySelector('input[name=workload]:checked')?.value || 'bcrypt',
    }),
    applyToForm: (params) => {
      if (params.username) {
        const el = document.getElementById('username');
        if (el) el.value = params.username;
      }
      if (params.password) {
        const el = document.getElementById('password');
        if (el) el.value = params.password;
      }
      const algo = normalizeHtpasswdAlgorithm(params.algorithm || params.algo || params.workload);
      if (algo) {
        const radio = document.querySelector(`input[name=workload][value="${algo}"]`);
        if (radio) {
          radio.checked = true;
          document.querySelectorAll('.algo-btn').forEach((b) => b.classList.remove('active'));
          const label = radio.closest('.algo-btn');
          if (label) label.classList.add('active');
        }
      }
      if (params.hash) {
        const el = document.getElementById('verifyHash');
        if (el) el.value = params.hash;
      }
      if (params.password && params.intent === 'verify') {
        const el = document.getElementById('verifyPassword');
        if (el) el.value = params.password;
      }
    },
    quickActions: [
      { label: 'Generate (bcrypt)', prompt: 'Generate htpasswd for user "admin" password "secret" with bcrypt', sendImmediately: true },
      { label: 'SHA-512 entry', prompt: 'Generate htpasswd for user "deploy" password "changeme" with sha512', sendImmediately: true },
      { label: 'How to add a user', prompt: 'How do I add a new user to an existing .htpasswd file on Apache and Nginx? Show the htpasswd -b command and the line format (username:hash).', sendImmediately: true },
      { label: 'Create new file', prompt: 'How do I create a brand-new .htpasswd file with htpasswd -c? Explain when to use -c vs appending without -c.', sendImmediately: true },
      { label: 'Nginx basic auth', prompt: 'Show a minimal Nginx location block using auth_basic, auth_basic_user_file, and where the htpasswd line goes.', sendImmediately: true },
      { label: 'Apache basic auth', prompt: 'Show minimal Apache AuthType Basic, AuthUserFile, and Require valid-user configuration.', sendImmediately: true },
      { label: 'bcrypt vs SHA-512', prompt: 'For htpasswd, compare bcrypt ($2y$) vs SHA-512 ($6$) — which should I use in 2025 and why?', sendImmediately: true },
      { label: 'Prefix meanings', prompt: 'Explain htpasswd hash prefixes $2y$, $apr1$, $5$, $6$, and {SHA} in plain English.', sendImmediately: true },
      { label: 'Verify a hash', prompt: 'Explain how to verify a password against an htpasswd line on this page (Verify tab).', sendImmediately: true },
      { label: 'What is htpasswd?', prompt: 'What is htpasswd used for in Apache and Nginx?', sendImmediately: true },
    ],
  },
  argon2: {
    tool: 'argon2',
    toolId: 'cryptography/argon2',
    title: 'Argon2 AI',
    subtitle: 'Hash and verify passwords with Argon2 in your browser (PHC winner).',
    operations: ['hash', 'verify', 'explain'],
    clientSide: true,
    readForm: () => ({
      password: document.getElementById('password')?.value
        || document.getElementById('verifyPassword')?.value || '',
      hash: document.getElementById('verifyHash')?.value || '',
      salt: document.getElementById('salt')?.value || '',
      variant: argon2VariantFromPage(),
      memory: document.getElementById('memorySlider')?.value || '65536',
      time: document.getElementById('timeSlider')?.value || '3',
      parallel: document.getElementById('parallelSlider')?.value || '4',
      hashLen: document.getElementById('hashLenSlider')?.value || '32',
    }),
    applyToForm: (params) => applyArgon2ParamsToPage(params),
    quickActions: [
      { label: 'Argon2id hash', prompt: 'Argon2id-hash password "test" with moderate preset', sendImmediately: true },
      { label: 'Argon2id explain', prompt: 'Explain Argon2id vs Argon2i for password hashing.', sendImmediately: true },
    ],
  },
  ec: {
    tool: 'ec',
    toolId: 'cryptography/ec',
    title: 'EC AI',
    subtitle: 'ECDH keygen, shared secret, and EC encrypt/decrypt.',
    operations: ['generate_keys', 'encrypt', 'decrypt', 'explain'],
    readForm: () => ({
      curve: document.getElementById('ecparam')?.value || '',
      message: document.getElementById('message')?.value || '',
      publicKeyAlice: document.getElementById('publickeyparama')?.value || '',
      privateKeyAlice: document.getElementById('privatekeyparama')?.value || '',
      publicKeyBob: document.getElementById('publickeyparamb')?.value || '',
      privateKeyBob: document.getElementById('privatekeyparamb')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.curve) {
        const el = document.getElementById('ecparam');
        if (el) el.value = normalizeEcCurve(params.curve);
      }
      const set = (id, val) => {
        if (!val) return;
        const el = document.getElementById(id);
        if (el) el.value = val;
      };
      set('publickeyparama', params.publicKeyAlice);
      set('privatekeyparama', params.privateKeyAlice);
      set('publickeyparamb', params.publicKeyBob);
      set('privatekeyparamb', params.privateKeyBob);
      if (params.message) set('message', params.message);
    },
    quickActions: [
      { label: 'P-256 keys', prompt: 'Generate ECDH key pairs on P-256', sendImmediately: true },
    ],
  },
  'ec-sign-verify': {
    tool: 'ec-sign-verify',
    toolId: 'cryptography/ec-sign-verify',
    title: 'ECDSA AI',
    subtitle: 'ECDSA sign and verify messages.',
    operations: ['generate_keys', 'sign', 'verify', 'explain'],
    readForm: () => ({
      curve: document.getElementById('ecparam')?.value || '',
      message: document.getElementById('message')?.value || '',
      publicKey: document.getElementById('privatekeyparam')?.value || '',
      privateKey: document.getElementById('publickeyparam')?.value || '',
      signature: document.getElementById('signature')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.curve) {
        const el = document.getElementById('ecparam');
        if (el) el.value = normalizeEcCurve(params.curve);
      }
      if (params.privateKey) {
        const el = document.getElementById('publickeyparam');
        if (el) el.value = params.privateKey;
      }
      if (params.publicKey) {
        const el = document.getElementById('privatekeyparam');
        if (el) el.value = params.publicKey;
      }
      if (params.signature) {
        const el = document.getElementById('signature');
        if (el) el.value = params.signature;
      }
      if (params.message) {
        const el = document.getElementById('message');
        if (el) el.value = params.message;
      }
    },
    quickActions: [
      { label: 'Sign message', prompt: 'Sign "hello" with ECDSA on P-256 using keys from the form', sendImmediately: true },
    ],
  },
  elgamal: {
    tool: 'elgamal',
    toolId: 'cryptography/elgamal',
    title: 'ElGamal AI',
    subtitle: 'ElGamal keygen, encrypt, and decrypt.',
    operations: ['generate_keys', 'encrypt', 'decrypt', 'explain'],
    readForm: () => ({
      keySize: document.querySelector('input[name=keysize]:checked')?.value || '160',
      message: document.getElementById('message')?.value || '',
      publicKey: document.getElementById('publickeyparam')?.value || '',
      privateKey: document.getElementById('privatekeyparam')?.value || '',
      algorithm: document.querySelector('input[name=cipherparameter]:checked')?.value || 'ELGAMAL',
    }),
    applyToForm: (params) => {
      if (params.keySize) {
        const radio = document.querySelector(`input[name=keysize][value="${params.keySize}"]`);
        if (radio) radio.checked = true;
      }
      if (params.publicKey) {
        const el = document.getElementById('publickeyparam');
        if (el) el.value = params.publicKey;
      }
      if (params.privateKey) {
        const el = document.getElementById('privatekeyparam');
        if (el) el.value = params.privateKey;
      }
      if (params.message) {
        const el = document.getElementById('message');
        if (el) el.value = params.message;
      }
      const algo = normalizeElgamalAlgorithm(params.algorithm || params.algo);
      if (algo) {
        const ar = document.querySelector(`input[name=cipherparameter][value="${algo}"]`);
        if (ar) ar.checked = true;
      }
      if (params.intent === 'encrypt') {
        const enc = document.getElementById('encryptparameter');
        if (enc) enc.checked = true;
      }
      if (params.intent === 'decrypt') {
        const dec = document.getElementById('decryptparameter');
        if (dec) dec.checked = true;
      }
    },
    quickActions: [
      { label: 'Generate 160-bit keys', prompt: 'Generate ElGamal 160-bit keys', sendImmediately: true },
      { label: 'Encrypt', prompt: 'ElGamal-encrypt "test" with keys in the form', sendImmediately: true },
    ],
  },
  dsa: {
    tool: 'dsa',
    toolId: 'cryptography/dsa',
    title: 'DSA AI',
    subtitle: 'DSA keygen via AI; sign/verify still needs file upload on the page.',
    operations: ['generate_keys', 'explain'],
    readForm: () => ({
      keySize: document.querySelector('input[name=keysize]:checked')?.value || '1024',
      publicKey: document.getElementById('publickeyparam')?.value || '',
      privateKey: document.getElementById('privatekeyparam')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.keySize) {
        const radio = document.querySelector(`input[name=keysize][value="${params.keySize}"]`);
        if (radio) radio.checked = true;
      }
      if (params.publicKey) {
        const el = document.getElementById('publickeyparam');
        if (el) el.value = params.publicKey;
      }
      if (params.privateKey) {
        const el = document.getElementById('privatekeyparam');
        if (el) el.value = params.privateKey;
      }
    },
    quickActions: [
      { label: 'Generate 1024-bit keys', prompt: 'Generate DSA 1024-bit keys', sendImmediately: true },
      { label: 'Explain DSA', prompt: 'How does DSA signing work?', sendImmediately: true },
    ],
  },
  ntru: {
    tool: 'ntru',
    toolId: 'cryptography/ntru',
    title: 'NTRU AI',
    subtitle: 'NTRU keygen, encrypt, and decrypt.',
    operations: ['generate_keys', 'encrypt', 'decrypt', 'explain'],
    formSelector: '#form',
    supportedParameterSets: [
      'APR2011_743_FAST', 'APR2011_743', 'APR2011_439_FAST', 'APR2011_439',
      'EES1087EP2', 'EES1087EP2_FAST', 'EES1171EP1', 'EES1171EP1_FAST',
      'EES1499EP1', 'EES1499EP1_FAST',
    ],
    readForm: () => ({
      parameterSet: document.getElementById('p_ntru')?.value || document.getElementById('ntruparam')?.value || '',
      message: document.getElementById('message')?.value || '',
      publicKey: document.getElementById('publickeyparam')?.value || '',
      privateKey: document.getElementById('privatekeyparam')?.value || '',
    }),
    applyToForm: (params) => {
      const ps = params.parameterSet || params.param;
      if (ps) {
        const el = document.getElementById('p_ntru');
        const el2 = document.getElementById('ntruparam');
        if (el) el.value = ps;
        if (el2) el2.value = ps;
      }
      if (params.publicKey) {
        const pk = document.getElementById('publickeyparam');
        if (pk) pk.value = params.publicKey;
      }
      if (params.privateKey) {
        const sk = document.getElementById('privatekeyparam');
        if (sk) sk.value = params.privateKey;
      }
      if (params.message) {
        const msg = document.getElementById('message');
        if (msg) msg.value = params.message;
      }
      const keySection = document.getElementById('keySection');
      if (keySection && (params.publicKey || params.privateKey)) {
        keySection.classList.add('show');
        const toggle = document.getElementById('toggleText');
        if (toggle) toggle.textContent = 'collapse';
      }
    },
    quickActions: [
      { label: 'Generate keys', prompt: 'Generate NTRU keys for APR2011_439', sendImmediately: true },
    ],
  },
  'jws-gen': {
    tool: 'jws-gen',
    toolId: 'cryptography/jws-gen',
    title: 'JWS Generator AI',
    subtitle: 'Auto-generate keys and sign JSON — HS256 for internal APIs, RS256/ES256 for public JWTs.',
    operations: ['generate', 'explain'],
    defaultAlgorithms: ['HS256'],
    readForm: () => ({
      algorithm: selectedRadio('algo') || 'HS256',
      payload: document.getElementById('payload')?.value || '',
    }),
    applyToForm: (params) => {
      if (params.algorithm || params.algo) setRadio('algo', params.algorithm || params.algo);
      const payload = params.payload || params.message || params.claims;
      if (payload) {
        const el = document.getElementById('payload');
        if (el) el.value = typeof payload === 'string' ? payload : JSON.stringify(payload, null, 2);
      }
    },
    quickActions: [
      { label: 'HS256 JWT', prompt: 'Generate JWS for payload {"sub":"1234567890","name":"John Doe","iat":1516239022} with HS256', sendImmediately: true },
      { label: 'RS256 JWT', prompt: 'Generate JWS with RS256 for {"sub":"api-client","scope":"read write"}', sendImmediately: true },
      { label: 'ES256 JWT', prompt: 'Generate JWS with ES256 for {"sub":"user-42","iss":"https://8gwifi.org"}', sendImmediately: true },
      { label: 'HS256 vs RS256', prompt: 'When should I use HS256 vs RS256 for JWT signing? Compare symmetric vs asymmetric on this generator page.', sendImmediately: true },
      { label: 'What is JWS?', prompt: 'What is a JSON Web Signature (JWS) and how does it relate to JWT?', sendImmediately: true },
      { label: 'JWT claims', prompt: 'Explain common JWT registered claims (iss, sub, aud, exp, nbf, iat, jti) with a short example payload.', sendImmediately: true },
      { label: 'OAuth-style token', prompt: 'Generate HS256 JWS for OAuth-style payload {"sub":"user1","scope":"openid profile","exp":1893456000}', sendImmediately: true },
      { label: 'PS256 (RSA-PSS)', prompt: 'Generate JWS with PS256 for {"hello":"world"} and explain when to use RSA-PSS.', sendImmediately: true },
      { label: 'Gen vs Sign page', prompt: 'What is the difference between this JWS Generator (auto key) and the JWS Sign page (your own key)?', sendImmediately: true },
      { label: 'Verify next', prompt: 'After generating a JWS here, how do I verify the signature on jwsverify.jsp?', sendImmediately: true },
    ],
  },
  'jws-sign': {
    tool: 'jws-sign',
    toolId: 'cryptography/jws-sign',
    title: 'JWS Sign AI',
    subtitle: 'Sign JSON with your HMAC secret or PEM private key — keys stay on the form, not in chat.',
    operations: ['sign', 'explain'],
    defaultAlgorithms: ['HS256'],
    readForm: () => ({
      algorithm: selectedRadio('algo') || 'HS256',
      payload: document.getElementById('payload')?.value || '',
      sharedsecret: document.getElementById('sharedsecret')?.value || '',
      key: document.getElementById('key')?.value || '',
    }),
    applyToForm: (params) => {
      const algo = params.algorithm || params.algo;
      if (algo) setRadio('algo', algo);
      const payload = params.payload || params.message || params.claims;
      if (payload) {
        const el = document.getElementById('payload');
        if (el) el.value = typeof payload === 'string' ? payload : JSON.stringify(payload, null, 2);
      }
      const secret = params.sharedsecret || params.sharedSecret;
      if (secret) {
        const el = document.getElementById('sharedsecret');
        if (el) el.value = secret;
      }
      const pem = params.key || params.privateKey || params.privatekey;
      if (pem) {
        const el = document.getElementById('key');
        if (el) el.value = pem;
      }
      if (algo) {
        const a = String(algo).toUpperCase();
        if (a.startsWith('HS')) {
          $('#key1').hide();
          $('#sharedsecret1').show();
        } else if (/^(RS|PS|ES)/.test(a)) {
          $('#sharedsecret1').hide();
          $('#key1').show();
        }
      }
    },
    quickActions: [
      { label: 'Sign HS256', prompt: 'Sign the JSON payload on the form with HS256 using the shared secret on the form', sendImmediately: true },
      { label: 'Sign RS256', prompt: 'Select RS256, use the sample RSA private key on the form, and sign the JSON payload on the form', sendImmediately: true },
      { label: 'Sign ES256', prompt: 'Select ES256, use the sample EC private key on the form, and sign the JSON payload on the form', sendImmediately: true },
      { label: 'HS256 vs RS256', prompt: 'When should I use HS256 vs RS256 for JWT signing on this page vs jwsgen.jsp?', sendImmediately: true },
      { label: 'Sign vs Generator', prompt: 'What is the difference between jwssign.jsp (my key) and jwsgen.jsp (auto-generated key)?', sendImmediately: true },
      { label: 'HMAC secret size', prompt: 'What shared secret length does HS256/HS384/HS512 require on this sign page?', sendImmediately: true },
      { label: 'PEM key format', prompt: 'What PEM private key format does RS256 and ES256 expect on this page?', sendImmediately: true },
      { label: 'JWT claims', prompt: 'Explain common JWT claims to put in the payload field (iss, sub, aud, exp, iat).', sendImmediately: true },
      { label: 'Verify next', prompt: 'After signing here, how do I verify the JWS on jwsverify.jsp?', sendImmediately: true },
      { label: 'Parse token', prompt: 'How do I decode the signed JWS on jwsparse.jsp?', sendImmediately: true },
    ],
  },
  'jws-parse': {
    tool: 'jws-parse',
    toolId: 'cryptography/jws-parse',
    title: 'JWS Parser AI',
    subtitle: 'Paste a JWT — the page decodes it; ask about claims, alg, or verify next steps.',
    operations: ['parse', 'explain'],
    readForm: () => {
      const el = document.getElementById('serialized');
      let serialized = el?.value?.trim() || '';
      if (!serialized) {
        try {
          serialized = sessionStorage.getItem(JWS_PARSE_STORAGE_KEY) || '';
          if (serialized && el) el.value = serialized;
        } catch {
          /* private mode */
        }
      }
      return { serialized };
    },
    applyToForm: (params) => {
      const tok = firstNonEmptyString(
        params.serialized,
        params.token,
        params.jwt,
        params.jws,
      );
      if (tok) {
        const el = document.getElementById('serialized');
        if (el) el.value = tok;
        persistJwsParseToken(tok);
      }
    },
    quickActions: [
      { label: 'Decode token', prompt: 'Parse and decode the JWS/JWT token on the form', sendImmediately: true },
      { label: 'Parse sample JWT', prompt: 'Parse the JWS token already in the form', sendImmediately: true },
      { label: 'Explain claims', prompt: 'Parse the token on the form, then explain the JWT registered claims (iss, sub, aud, exp, iat) in plain English.', sendImmediately: true },
      { label: 'What is alg?', prompt: 'Parse the token on the form, then explain the header alg field and what it means for verification.', sendImmediately: true },
      { label: 'Parse vs verify', prompt: 'What is the difference between parsing a JWT and verifying its signature?', sendImmediately: true },
      { label: 'JWS format', prompt: 'Explain JWS compact serialization (header.payload.signature) and Base64URL encoding.', sendImmediately: true },
      { label: 'Read exp claim', prompt: 'Parse the token on the form and tell me if it is expired based on the exp claim.', sendImmediately: true },
      { label: 'HS256 vs RS256', prompt: 'Compare HS256 and RS256 for JWT signing — when to use each?', sendImmediately: true },
      { label: 'Verify next step', prompt: 'How do I verify this JWS signature after parsing? Which key do I need for HS256 vs RS256?', sendImmediately: true },
    ],
  },
  'jws-verify': {
    tool: 'jws-verify',
    toolId: 'cryptography/jws-verify',
    title: 'JWS Verify AI',
    subtitle: 'Verify JWT/JWS signatures — token and keys stay on the form, not in chat.',
    operations: ['verify', 'explain'],
    readForm: () => {
      const el = document.getElementById('serialized');
      let serialized = el?.value?.trim() || '';
      if (!serialized) {
        try {
          serialized = sessionStorage.getItem(JWS_PARSE_STORAGE_KEY) || '';
          if (serialized && el) el.value = serialized;
        } catch { /* private mode */ }
      }
      return {
        serialized,
        sharedsecret: document.getElementById('sharedsecret')?.value || '',
        publickey: document.getElementById('publickey')?.value || '',
      };
    },
    applyToForm: (params) => {
      const tok = firstNonEmptyString(params.serialized, params.token, params.jwt, params.jws);
      if (tok) {
        const el = document.getElementById('serialized');
        if (el) el.value = tok;
        persistJwsParseToken(tok);
      }
      const secret = params.sharedsecret || params.sharedSecret;
      if (secret) {
        const el = document.getElementById('sharedsecret');
        if (el) el.value = secret;
      }
      const pub = params.publickey || params.publicKey;
      if (pub) {
        const el = document.getElementById('publickey');
        if (el) el.value = pub;
      }
    },
    quickActions: [
      { label: 'Verify token', prompt: 'Verify the JWS/JWT token on the form using the keys on the form', sendImmediately: true },
      { label: 'Verify HS256', prompt: 'Verify the token on the form with the HMAC shared secret on the form', sendImmediately: true },
      { label: 'Parse vs verify', prompt: 'What is the difference between parsing a JWT on jwsparse.jsp and verifying it here?', sendImmediately: true },
      { label: 'Which key?', prompt: 'For HS256 vs RS256 tokens, which field should I use — shared secret or public key PEM?', sendImmediately: true },
      { label: 'After jwsgen', prompt: 'Explain step by step: I generated a JWS on jwsgen.jsp — how do I verify it on jwsverify.jsp? Do not run verification or generate a new token.', sendImmediately: true },
      { label: 'Invalid signature', prompt: 'My verification fails — what are common causes (wrong key, tampered token, algorithm mismatch)?', sendImmediately: true },
      { label: 'PEM public key', prompt: 'What PEM format should the RSA/EC public key be in for verification?', sendImmediately: true },
    ],
  },
  jwk: {
    tool: 'jwk',
    toolId: 'cryptography/jwk',
    title: 'JWK Generator AI',
    subtitle: 'Generate RSA, EC, Ed25519, and symmetric JWKs — param 1–17 on the form.',
    operations: ['generate', 'explain'],
    readForm: () => ({
      param: selectedRadio('param') || '1',
    }),
    applyToForm: (params) => {
      const p = normalizeJwkParamValue(params.param || params.keyType || params.algorithm, '');
      if (p) setRadio('param', p);
    },
    quickActions: [
      { label: 'P-256 JWK', prompt: 'Generate a P-256 EC JWK (param 5)', sendImmediately: true },
      { label: 'Ed25519 JWK', prompt: 'Generate Ed25519 JWK (param 9)', sendImmediately: true },
      { label: 'RSA-2048 JWK', prompt: 'Generate RSA-2048 encrypt JWK (param 1)', sendImmediately: true },
      { label: 'HS256 JWK', prompt: 'Generate HS256 symmetric JWK (param 11)', sendImmediately: true },
      { label: 'What is JWK?', prompt: 'What is a JSON Web Key (JWK) and how is it used with JWT?', sendImmediately: true },
      { label: 'JWK vs PEM', prompt: 'When should I use JWK format vs PEM keys?', sendImmediately: true },
      { label: 'Convert to PEM', prompt: 'How do I convert a generated JWK to PEM on jwkconvertfunctions.jsp?', sendImmediately: true },
      { label: 'Param list', prompt: 'Explain JWK generator param numbers 1–17 (RSA, EC, Ed25519, HMAC, AES).', sendImmediately: true },
    ],
  },
  'jwk-convert': {
    tool: 'jwk-convert',
    toolId: 'cryptography/jwk-convert',
    title: 'JWK Convert AI',
    subtitle: 'Convert JWK ↔ PEM — key material stays in the form, not in chat.',
    operations: ['convert', 'explain'],
    readForm: () => ({
      param: selectedRadio('param') || 'JWK-to-PEM',
      input: document.getElementById('input')?.value || '',
    }),
    applyToForm: (params) => {
      const dir = params.param || params.direction;
      if (dir) {
        const v = /pem.*jwk|pem-to-jwk/i.test(String(dir)) ? 'PEM-to-JWK' : 'JWK-to-PEM';
        setRadio('param', v);
      }
      const inp = params.input || params.jwk || params.pem || params.key;
      if (inp) {
        const el = document.getElementById('input');
        if (el) el.value = inp;
      }
    },
    quickActions: [
      { label: 'JWK to PEM', prompt: 'Convert the JWK in the input field to PEM (JWK-to-PEM)', sendImmediately: true },
      { label: 'PEM to JWK', prompt: 'Select PEM-to-JWK and convert the PEM key in the input field', sendImmediately: true },
      { label: 'EC JWK to PEM', prompt: 'Explain JWK-to-PEM for Elliptic Curve keys (P-256) on this page', sendImmediately: true },
      { label: 'RSA limits', prompt: 'Why does PEM-to-JWK only support RSA on this tool?', sendImmediately: true },
      { label: 'What is JWK?', prompt: 'What is JWK format vs PEM for API keys?', sendImmediately: true },
      { label: 'Generate JWK', prompt: 'How do I generate a new JWK on jwkfunctions.jsp first?', sendImmediately: true },
      { label: 'Use in JWT', prompt: 'How do JWK and PEM relate to signing JWTs on jwsgen.jsp?', sendImmediately: true },
    ],
  },
};

function getCryptoToolProfile(toolKey) {
  return CRYPTO_TOOLS[toolKey] || null;
}

/** Snapshot of current form state for AI context (secrets redacted). */
function buildCryptoSeedContext(profile) {
  const form = profile.readForm ? profile.readForm() : {};
  const ctx = {
    tool: profile.tool,
    operations: profile.operations,
    form: redactFormForAi(form),
  };
  if (profile.tool === 'jws-parse' && form.serialized) {
    ctx.jwsTokenOnForm = true;
    ctx.jwsTokenSummary = redactJwsSerialized(form.serialized);
  }
  if (profile.tool === 'jws-sign') {
    const algo = String(form.algorithm || '').toUpperCase();
    if (form.payload?.trim()) ctx.payloadOnForm = true;
    if (algo.startsWith('HS') && form.sharedsecret) ctx.hmacSecretOnForm = true;
    if (/^(RS|PS|ES)/.test(algo) && form.key) ctx.privateKeyOnForm = true;
  }
  if (profile.tool === 'jws-verify') {
    if (form.serialized) {
      ctx.jwsTokenOnForm = true;
      ctx.jwsTokenSummary = redactJwsSerialized(form.serialized);
    }
    if (form.sharedsecret) ctx.hmacSecretOnForm = true;
    if (form.publickey) ctx.publicKeyOnForm = true;
  }
  if (profile.tool === 'jwk-convert' && form.input?.trim()) {
    ctx.keyMaterialOnForm = true;
    ctx.keyMaterialHint = '[key in input field — not sent to AI]';
  }
  return ctx;
}

function selectedCheckboxes(name) {
  return Array.from(document.querySelectorAll(`input[name="${name}"]:checked`))
    .map((el) => el.value)
    .filter(Boolean);
}

function setCheckboxes(name, values) {
  const set = new Set(values.map(String));
  document.querySelectorAll(`input[name="${name}"]`).forEach((el) => {
    el.checked = set.has(el.value);
  });
}

function selectedRadio(name) {
  return document.querySelector(`input[name="${name}"]:checked`)?.value || '';
}

function setRadio(name, value) {
  const el = document.querySelector(`input[name="${name}"][value="${value}"]`);
  if (el) el.checked = true;
}

function selectedHmacAlgorithms() {
  const form = document.getElementById('hmacForm');
  if (!form) return selectedCheckboxes('cipherparameternew');
  return Array.from(form.querySelectorAll('input[type="checkbox"]:checked'))
    .map((el) => el.value || el.name)
    .filter(Boolean);
}

function setHmacCheckboxes(algorithms) {
  const form = document.getElementById('hmacForm');
  if (!form) {
    setCheckboxes('cipherparameternew', algorithms);
    return;
  }
  const supported = hmacPageAlgorithmIds() || [];
  const names = new Set(algorithms.map((a) => normalizeHmacAlgorithmName(a, supported)).filter(Boolean));
  form.querySelectorAll('input[type="checkbox"]').forEach((el) => {
    const id = el.value || el.name;
    el.checked = names.has(id);
  });
}

/** Normalize user/LLM labels to lookup keys (matches Java hmacAliasKey). */
function hmacAliasKey(label) {
  return String(label || '').trim().replace(/[\s_-]/g, '').toUpperCase();
}

/** Read checkbox ids from the live page when available. */
function hmacPageAlgorithmIds() {
  const form = document.getElementById('hmacForm');
  if (!form) return null;
  const ids = Array.from(form.querySelectorAll('input[type="checkbox"]'))
    .map((el) => el.value || el.name)
    .filter(Boolean);
  return ids.length ? ids : null;
}

function hmacSupportedAlgorithms(profile) {
  return hmacPageAlgorithmIds() || profile.supportedAlgorithms || [];
}

/** UI labels on hmacgen.jsp → macchoices checkbox value */
const HMAC_LABEL_ALIASES = [
  ['HMAC-SHA-256', 'HmacSHA256'],
  ['HMAC-SHA-512', 'HmacSHA512'],
  ['HMAC-SHA-224', 'HmacSHA224'],
  ['HMAC-SHA-384', 'HmacSHA384'],
  ['HMAC-SHA-1', 'HmacSHA1'],
  ['HMAC-TIGER', 'HMACTIGER'],
  ['HMAC-RIPEMD-128', 'HMACRIPEMD128'],
  ['HMAC-RIPEMD-160', 'HMACRIPEMD160'],
  ['RC2-MAC', 'RC2MAC'],
  ['RC5-MAC', 'RC5MAC'],
  ['IDEA-MAC', 'IDEAMAC'],
  ['DES-MAC', 'DES'],
  ['3DES-MAC', 'DESEDEMAC'],
  ['HMAC-MD5', 'HMACMD5'],
  ['HMAC-MD4', 'HMACMD4'],
  ['HMAC-MD2', 'HMACMD2'],
  // Digest-style names (common LLM mistake)
  ['SHA-256', 'HmacSHA256'],
  ['SHA256', 'HmacSHA256'],
  ['SHA-512', 'HmacSHA512'],
  ['SHA512', 'HmacSHA512'],
  ['SHA-384', 'HmacSHA384'],
  ['SHA384', 'HmacSHA384'],
  ['SHA-224', 'HmacSHA224'],
  ['SHA224', 'HmacSHA224'],
  ['SHA-1', 'HmacSHA1'],
  ['SHA1', 'HmacSHA1'],
  ['HS256', 'HmacSHA256'],
  ['HS384', 'HmacSHA384'],
  ['HS512', 'HmacSHA512'],
  ['MD5', 'HMACMD5'],
  ['MD4', 'HMACMD4'],
  ['MD2', 'HMACMD2'],
  ['TIGER', 'HMACTIGER'],
  ['RIPEMD128', 'HMACRIPEMD128'],
  ['RIPEMD160', 'HMACRIPEMD160'],
  ['3DES', 'DESEDEMAC'],
];

const HMAC_ALGO_LOOKUP = (() => {
  const map = new Map();
  const put = (alias, id) => map.set(hmacAliasKey(alias), id);
  HMAC_CANONICAL_IDS.forEach((id) => put(id, id));
  for (const [alias, id] of HMAC_LABEL_ALIASES) put(alias, id);
  return map;
})();

function normalizeHmacAlgorithmName(name, supported) {
  const raw = String(name || '').trim();
  if (!raw) return '';
  const key = hmacAliasKey(raw);
  const fromAlias = HMAC_ALGO_LOOKUP.get(key);
  if (fromAlias) return fromAlias;
  const canon = (supported || []).find((id) => hmacAliasKey(id) === key);
  return canon || '';
}

function normalizePlanAlgorithms(profile, params) {
  if (profile.tool === 'hmac') {
    const supported = hmacSupportedAlgorithms(profile);
    const raw = []
      .concat(params.algorithms || [])
      .concat(params.algorithm || [])
      .concat(params.algo || []);
    const normalized = [...new Set(raw.map((a) => normalizeHmacAlgorithmName(a, supported)).filter(Boolean))];
    if (normalized.length) {
      params.algorithms = normalized;
      params.algorithm = normalized[0];
      params.algo = normalized[0];
    } else if (profile.defaultAlgorithms?.length) {
      params.algorithms = [...profile.defaultAlgorithms];
    }
    return;
  }
  if (profile.tool === 'message-digest' && params.algorithm && !params.algorithms?.length) {
    params.algorithms = [params.algorithm];
  }
  if (profile.tool === 'pbkdf') {
    const raw = []
      .concat(params.algorithms || [])
      .concat(params.algorithm || [])
      .concat(params.algo || []);
    const normalized = [...new Set(raw.map((a) => normalizePbkdfAlgorithm(a)).filter(Boolean))];
    if (normalized.length) {
      params.algorithms = normalized;
      params.algorithm = normalized[0];
      params.algo = normalized[0];
    }
  }
  if (profile.tool === 'pbe') {
    const raw = []
      .concat(params.algorithms || [])
      .concat(params.algorithm || [])
      .concat(params.algo || []);
    const normalized = [...new Set(raw.map((a) => normalizePbeAlgorithm(a)).filter(Boolean))];
    if (normalized.length) {
      params.algorithms = normalized;
      params.algorithm = normalized[0];
      params.algo = normalized[0];
    } else if (profile.defaultAlgorithms?.length) {
      params.algorithms = [...profile.defaultAlgorithms];
      params.algorithm = profile.defaultAlgorithms[0];
    }
  }
  if (profile.tool === 'argon2') {
    normalizeArgon2Params(params);
  }
  if (profile.tool === 'elgamal') {
    normalizeElgamalParams(params);
  }
  if (profile.tool === 'scrypt') {
    normalizeScryptParams(params);
  }
  if (profile.tool === 'htpasswd') {
    normalizeHtpasswdParams(params);
  }
}

function argon2VariantFromPage() {
  if (typeof window.currentVariant === 'number') {
    return ['argon2d', 'argon2i', 'argon2id'][window.currentVariant] || 'argon2id';
  }
  if (document.getElementById('variantBtn2')?.classList.contains('active')) return 'argon2id';
  if (document.getElementById('variantBtn1')?.classList.contains('active')) return 'argon2i';
  if (document.getElementById('variantBtn0')?.classList.contains('active')) return 'argon2d';
  return 'argon2id';
}

function argon2VariantToType(variant) {
  const v = String(variant || 'argon2id').toLowerCase();
  if (v.includes('argon2d') && !v.includes('argon2id')) return 0;
  if (v.includes('argon2i') && !v.includes('argon2id')) return 1;
  return 2;
}

function normalizeElgamalAlgorithm(name) {
  const raw = String(name || '').trim();
  if (!raw) return 'ELGAMAL';
  const upper = raw.toUpperCase();
  if (upper === 'ELGAMAL') return 'ELGAMAL';
  const known = [
    'ELGAMAL',
    'ELGAMAL/ECB/PKCS1PADDING',
    'ELGAMAL/NONE/NOPADDING',
    'ELGAMAL/PKCS1',
  ];
  const match = known.find((k) => k.toUpperCase() === upper.replace(/\s+/g, ''));
  if (match) return match;
  const onPage = document.querySelector(`input[name=cipherparameter][value="${raw}"]`);
  if (onPage) return raw;
  return 'ELGAMAL';
}

function normalizeElgamalParams(params) {
  params.algorithm = normalizeElgamalAlgorithm(params.algorithm || params.algo);
  params.algo = params.algorithm;
}

function normalizeHtpasswdAlgorithm(name) {
  const raw = String(name || '').trim().toLowerCase();
  if (!raw) return 'bcrypt';
  if (raw.includes('bcrypt') || raw === '2y') return 'bcrypt';
  if (raw.includes('sha512') || raw === '6') return 'sha512';
  if (raw.includes('sha256') || raw === '5') return 'sha256';
  if (raw.includes('apr')) return 'apr';
  if (raw.includes('md5')) return 'md5';
  if (raw.includes('crypt')) return 'crypt';
  return raw;
}

function htpasswdEntryMatchesAlgo(entry, preferred) {
  const want = normalizeHtpasswdAlgorithm(preferred).toLowerCase();
  const algo = String(entry?.algorithm || '').toLowerCase();
  if (want === 'bcrypt') return algo.includes('bcrypt');
  if (want === 'apr') return algo.includes('apr');
  if (want === 'sha512') return algo.includes('sha512');
  if (want === 'sha256') return algo.includes('sha256');
  return algo.includes(want);
}

function pickHtpasswdEntries(data, preferredAlgo) {
  const all = data?.htpasswdEntries || [];
  if (!preferredAlgo || !all.length) return all;
  const filtered = all.filter((e) => htpasswdEntryMatchesAlgo(e, preferredAlgo));
  return filtered.length ? filtered : all;
}

/** Map JWK generator radio values 1–17 from user text or aliases. */
function normalizeJwkParamValue(raw, userText = '') {
  const s = String(raw || '').trim();
  if (/^\d{1,2}$/.test(s)) return s;
  const t = `${userText || ''} ${s}`.toLowerCase();
  if (/\bed25519\b/.test(t)) return '9';
  if (/\bx25519\b/.test(t)) return '10';
  if (/\bp-256k\b|secp256k1\b/.test(t)) return '6';
  if (/\bp-384\b/.test(t)) return '7';
  if (/\bp-521\b/.test(t)) return '8';
  if (/\bp-256\b|secp256r1\b|prime256v1\b/.test(t)) return '5';
  if (/\brsa.?4096.*sign\b/.test(t)) return '4';
  if (/\brsa.?2048.*sign\b/.test(t)) return '3';
  if (/\brsa.?4096\b/.test(t)) return '2';
  if (/\brsa.?2048\b/.test(t)) return '1';
  if (/\bhs512\b/.test(t)) return '13';
  if (/\bhs384\b/.test(t)) return '12';
  if (/\bhs256\b/.test(t)) return '11';
  if (/\ba256gcm\b/.test(t)) return '16';
  if (/\ba192gcm\b/.test(t)) return '15';
  if (/\ba128cbc\b/.test(t)) return '17';
  if (/\ba128gcm\b/.test(t)) return '14';
  return s;
}

function normalizeHtpasswdParams(params) {
  const a = normalizeHtpasswdAlgorithm(params.algorithm || params.algo || params.workload);
  params.algorithm = a;
  params.algo = a;
  params.workload = a;
}

function normalizeScryptParams(params) {
  const pick = (...vals) => {
    for (const v of vals) {
      if (v != null && v !== '') return String(v);
    }
    return '';
  };
  const n = pick(params.n, params.N, params.workparam, params.cpuCost);
  const r = pick(params.r, params.memoryparam, params.memoryCost);
  const p = pick(params.p, params.parallelizationparam, params.parallelization);
  const len = pick(params.length, params.keyLength, params.keylength);
  params.n = n || '2048';
  params.workparam = params.n;
  params.r = r || '8';
  params.memoryparam = params.r;
  params.p = p || '1';
  params.parallelizationparam = params.p;
  params.length = len || '32';
}

function normalizeArgon2Params(params) {
  if (params.variant) {
    params.variant = String(params.variant).toLowerCase();
  } else {
    params.variant = 'argon2id';
  }
  if (params.memory == null || params.memory === '') params.memory = '65536';
  if (params.time == null || params.time === '') params.time = '3';
  if (params.parallel == null || params.parallel === '') params.parallel = '4';
  if (params.hashLen == null || params.hashLen === '') params.hashLen = '32';
  if (/\b(interactive|fast|quick)\b/i.test(params.preset || '')) {
    params.memory = '4096';
    params.time = '3';
    params.parallel = '1';
  }
  if (/\b(moderate|default|balanced)\b/i.test(params.preset || '')) {
    params.memory = '65536';
    params.time = '3';
    params.parallel = '4';
  }
  if (/\b(sensitive|strong|paranoid)\b/i.test(params.preset || '')) {
    params.memory = '262144';
    params.time = '5';
    params.parallel = '4';
  }
}

function applyArgon2ParamsToPage(params) {
  const variantIdx = argon2VariantToType(params.variant);
  if (typeof window.selectArgon2Variant === 'function') {
    window.selectArgon2Variant(variantIdx);
  }
  const setSlider = (id, valId, value) => {
    if (value == null || value === '') return;
    const slider = document.getElementById(id);
    const label = document.getElementById(valId);
    if (slider) slider.value = value;
    if (label) label.textContent = value;
  };
  setSlider('memorySlider', 'memoryValue', params.memory);
  setSlider('timeSlider', 'timeValue', params.time);
  setSlider('parallelSlider', 'parallelValue', params.parallel);
  setSlider('hashLenSlider', 'hashLenValue', params.hashLen);
  if (params.password) {
    const el = document.getElementById('password');
    if (el) el.value = params.password;
  }
  if (params.salt) {
    const el = document.getElementById('salt');
    if (el) el.value = params.salt;
  }
  if (params.hash) {
    const el = document.getElementById('verifyHash');
    if (el) el.value = params.hash;
  }
  if (params.password && params.intent === 'verify') {
    const el = document.getElementById('verifyPassword');
    if (el) el.value = params.password;
  }
}

async function executeArgon2Client(plan) {
  if (typeof argon2 === 'undefined') {
    return {
      ok: false,
      errorMessage: 'Argon2 library is still loading — wait a moment and try again.',
    };
  }
  const p = plan.params || {};
  if (plan.intent === 'verify') {
    const password = p.password || '';
    const hash = p.hash || '';
    if (!password || !hash) {
      return { ok: false, errorMessage: 'password and hash are required for verify' };
    }
    if (!hash.startsWith('$argon2')) {
      return { ok: false, errorMessage: 'Invalid Argon2 hash format (must start with $argon2)' };
    }
    try {
      await argon2.verify({ pass: password, encoded: hash });
      return { ok: true, verified: true, verificationMessage: 'Password matches the hash.' };
    } catch (e) {
      return { ok: true, verified: false, verificationMessage: e.message || 'Password does not match.' };
    }
  }
  if (plan.intent === 'hash') {
    let salt = String(p.salt || '').trim();
    if (!salt && typeof window.generateSalt === 'function') {
      window.generateSalt();
      salt = document.getElementById('salt')?.value || '';
    }
    if (!p.password) {
      return { ok: false, errorMessage: 'password is required' };
    }
    try {
      const result = await argon2.hash({
        pass: p.password,
        salt: new TextEncoder().encode(salt),
        time: parseInt(p.time, 10) || 3,
        mem: parseInt(p.memory, 10) || 65536,
        parallelism: parseInt(p.parallel, 10) || 4,
        hashLen: parseInt(p.hashLen, 10) || 32,
        type: argon2VariantToType(p.variant),
      });
      return {
        ok: true,
        hash: result.encoded,
        hashHex: result.hashHex,
        variant: p.variant,
      };
    } catch (e) {
      return { ok: false, errorMessage: e.message || 'Argon2 hash failed' };
    }
  }
  return { ok: false, errorMessage: 'Unsupported argon2 operation' };
}

const FORM_REDACTED = '[on form — not sent to AI]';
const JWS_PARSE_STORAGE_KEY = 'crypto-jws-parse-token';

function firstNonEmptyString(...vals) {
  for (const v of vals) {
    if (v != null && String(v).trim() !== '') return String(v).trim();
  }
  return '';
}

function persistJwsParseToken(token) {
  const t = String(token || '').trim();
  if (!t) return;
  try {
    sessionStorage.setItem(JWS_PARSE_STORAGE_KEY, t);
  } catch {
    /* quota / private mode */
  }
}

/** Compact JWS/JWE in user message or form — not sent to the LLM in full. */
function extractJwsSerializedFromText(text) {
  const raw = String(text || '').trim();
  if (!raw) return '';
  const quoted = raw.match(/["'](eyJ[A-Za-z0-9_-]+(?:\.[A-Za-z0-9_-]+){2,4})["']/);
  if (quoted) return quoted[1];
  const bare = raw.match(/eyJ[A-Za-z0-9_-]+(?:\.[A-Za-z0-9_-]+){2,4}/);
  return bare ? bare[0] : '';
}

function isRedactedJwsPlaceholder(val) {
  const s = String(val || '');
  return s.includes('[JWS') || s.includes('on form —') || s.includes('run Parse to decode');
}

function isValidJwsSerialized(val) {
  const t = String(val || '').trim();
  return /^eyJ[A-Za-z0-9_-]+(?:\.[A-Za-z0-9_-]+){2,4}$/.test(t);
}

function resolveJwsSerializedForExecution(params, form, userText, profile) {
  const fromForm = String(form.serialized || '').trim();
  const fromMsg = extractJwsSerializedFromText(userText);
  const fromParams = String(params.serialized || '').trim();

  if (isValidJwsSerialized(fromForm)) {
    params.serialized = fromForm;
    if (profile.tool === 'jws-parse') persistJwsParseToken(fromForm);
    return;
  }
  if (isValidJwsSerialized(fromMsg)) {
    params.serialized = fromMsg;
    if (profile.tool === 'jws-parse') persistJwsParseToken(fromMsg);
    return;
  }
  if (isValidJwsSerialized(fromParams) && !isRedactedJwsPlaceholder(fromParams)) {
    return;
  }
  if (isRedactedJwsPlaceholder(fromParams)) {
    delete params.serialized;
  }
}

function redactJwsSerialized(val) {
  const t = String(val || '').trim();
  if (!t) return '';
  const parts = t.split('.');
  let algHint = '';
  if (parts[0]?.startsWith('eyJ')) {
    try {
      const b64 = parts[0].replace(/-/g, '+').replace(/_/g, '/');
      const pad = b64.length % 4 === 0 ? '' : '='.repeat(4 - (b64.length % 4));
      const hdr = JSON.parse(atob(b64 + pad));
      if (hdr.alg) algHint = String(hdr.alg);
      if (hdr.enc) algHint = algHint ? `${algHint} (JWE)` : 'JWE';
    } catch {
      /* ignore */
    }
  }
  const kind = parts.length >= 5 ? 'JWE' : parts.length === 3 ? 'JWS/JWT' : 'token';
  return `[${kind} on form — ${parts.length} segment(s), ${t.length} chars${algHint ? `, alg ${algHint}` : ''} — run Parse to decode]`;
}

function redactFormForAi(form) {
  const out = { ...form };
  const secretKeys = ['key', 'password', 'secretKey', 'sharedsecret', 'publickey', 'publicKey', 'privateKey', 'privateKeyAlice', 'privateKeyBob', 'input'];
  for (const k of secretKeys) {
    if (out[k]) out[k] = FORM_REDACTED;
  }
  if (out.serialized) out.serialized = redactJwsSerialized(out.serialized);
  return out;
}
// --- utils ---
/**
 * Shared UX helpers for the crypto tools AI adapter.
 */

function removeLastUserTurn(ai) {
  if (ai.history.length && ai.history[ai.history.length - 1].role === 'user') {
    ai.history.pop();
  }
  const msgs = ai._els?.messages;
  const last = msgs?.lastElementChild;
  if (last?.classList.contains('user') && last.classList.contains('vca-msg')) {
    last.remove();
  }
}

/** Workflow / navigation questions (e.g. jwsgen → jwsverify) — explain only, no crypto run. */
function looksLikeWorkflowExplain(text) {
  const t = String(text || '').trim().toLowerCase();
  if (!t) return false;
  if (/\bhow (do|to|can) i\b/.test(t) && /\b(jwsgen|jwssign|jwsparse|jwsverify|jwkfunctions|this page|on this page|\.jsp)\b/.test(t)) {
    return !/\b(verify|sign|parse|convert|generate) (it |the token |now|for me)\b/.test(t);
  }
  if (/\b(i generated|after jwsgen)\b/.test(t) && /\bhow\b/.test(t)) return true;
  return false;
}

/** Fast path: obvious conceptual questions → generic assistant (skip router LLM). */
function looksLikeExplainOnly(text) {
  const t = String(text || '').trim().toLowerCase();
  if (!t) return false;
  if (looksLikeWorkflowExplain(text)) return true;
  if (/\bhow do i\b/.test(t) && !/\b(with|using|on the form now|for me now|please run)\b/.test(t)) {
    if (/\b(verify|sign|parse|convert|use|get to|navigate)\b/.test(t)) return true;
  }
  if (/^(what|why|how|when|where|who|explain|describe|tell me|help me understand)\b/.test(t)) {
    if (/\b(hash|encrypt|decrypt|sign|verify|derive|generate|parse|convert|hmac|bcrypt|scrypt|jws|jwt|jwk)\b/.test(t)
      && /\b(with|using|for|my|this|the form|sha-|aes|hs256|rs256)\b/.test(t)) {
      return false;
    }
    return true;
  }
  if (/\b(difference between|vs\.?|versus|compare|when should i|best practice)\b/.test(t)) {
    return !/\b(run|compute|calculate|do it|now|please)\b/.test(t);
  }
  return false;
}

function buildPageSystemPrompt(profile) {
  const ops = profile.operations.filter((o) => o !== 'explain').join(', ');
  return `You are the assistant on **${profile.title}** at 8gwifi.org — ${profile.subtitle || 'a cryptography tool page'}.

**What you can do on this page**
- Run real operations via the page engine: ${ops || 'see form'}.
- Answer conceptual questions in plain language (definitions, when to use an algorithm, security tradeoffs).

**Rules**
- Never invent digests, ciphertext, signatures, keys, or tokens. If the user wants a computation, they should ask in plain language (e.g. "hash hello with SHA-256") and you will run the tool — or they can use the form.
- Passwords and private keys on the form are never sent to the AI; say "use the key on the form" when relevant.
- Keep answers concise and practical. Use short steps or bullet lists when helpful.
- If unsure which operation they want, ask one clear question instead of guessing.${profile.tool === 'jws-parse' ? `

**JWS Parser**
- The full JWT/JWS string stays in the page textarea (and browser session); you only see a redacted summary in [FORM STATE], not the raw token.
- Never Base64-decode or invent header/payload yourself — use intent **parse** so the page engine runs PARSE_JWS.
- If jwsTokenOnForm is true, assume the user wants that token parsed; do not ask them to paste it again.` : ''}${profile.tool === 'jws-sign' ? `

**JWS Sign (custom key)**
- Shared secrets and PEM private keys stay on the form only — never sent to the AI. Say "use the shared secret on the form" or "use the private key on the form".
- For sign requests, the page engine runs SIGN_JSON; do not invent JWS compact tokens.` : ''}${profile.tool === 'jws-verify' ? `

**JWS Verify**
- Token, shared secret, and public key PEM stay on the form — never sent to the AI.
- Use intent **verify** only when the user wants to run verification now; workflow questions ("how do I verify after jwsgen") → explain with steps, do not run verify.
- Leave serialized/sharedsecret/publickey empty when jwsTokenOnForm or keys are on the form — the client merges real values.
- Do not invent VALID/INVALID results.` : ''}${profile.tool === 'jwk-convert' ? `

**JWK Convert**
- Key material in the input textarea is never sent to the AI.
- Use intent **convert**; leave input empty when keyMaterialOnForm is true — client reads the form.` : ''}`;
}

function placeholderForProfile(profile) {
  const map = {
    'message-digest': 'e.g. Hash "hello world" with SHA-256',
    hmac: 'e.g. HMAC-SHA256 of "data" with my secret key',
    cipher: 'e.g. Encrypt this text with AES-256-GCM',
    pbkdf: 'e.g. Derive a 32-byte key with PBKDF2-HMAC-SHA256',
    pbe: 'e.g. Encrypt my message with PBEWITHMD5ANDDES',
    bcrypt: 'e.g. Hash password "test" with cost 12',
    scrypt: 'e.g. Hash with scrypt using salt on the form',
    htpasswd: 'e.g. Generate htpasswd for user admin',
    argon2: 'e.g. Argon2id-hash password "test" with moderate preset',
    ec: 'e.g. Generate P-256 keys and shared secret',
    'ec-sign-verify': 'e.g. Sign this message with ECDSA',
    elgamal: 'e.g. ElGamal-encrypt my message',
    dsa: 'e.g. How does DSA signing work?',
    ntru: 'e.g. Generate NTRU keys for APR2011_439',
    'jws-gen': 'e.g. Create HS256 JWS for {"sub":"123"}',
    'jws-sign': 'e.g. Sign payload with RS256 using my PEM key',
    'jws-parse': 'e.g. Parse the JWT in the form',
    'jws-verify': 'e.g. Verify the token on the form',
    jwk: 'e.g. Generate Ed25519 JWK',
    'jwk-convert': 'e.g. Convert this JWK to PEM',
  };
  return map[profile.tool] || 'Ask a question or describe what to compute…';
}
// --- router ---

function parseJsonLoose(text) {
  const raw = String(text || '').trim();
  const fence = raw.match(/```(?:json)?\s*\n?([\s\S]*?)```/i);
  const candidate = fence ? fence[1].trim() : raw;
  const start = candidate.indexOf('{');
  const end = candidate.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    return JSON.parse(candidate.slice(start, end + 1));
  } catch {
    return null;
  }
}

function operationHints(profile) {
  const tool = profile.tool;
  const hints = {
    'message-digest': 'hash — digest text with one or more algorithms (SHA-256, MD5, etc.)',
    hmac: 'hmac — keyed hash; needs text + secret key + algorithms[] (exact macchoices ids from page; NOT plain SHA-256)',
    cipher: 'encrypt | decrypt — params: message, secretKey (hex), algorithm (exact select value)',
    pbe: 'encrypt | decrypt — message, password, rounds; algorithm e.g. PBEWITHHMACSHA256ANDAES_256',
    pbkdf: 'derive — key derivation; needs password, salt, rounds, algorithm(s)',
    bcrypt: 'hash — bcrypt password hash with cost; verify — check password against hash field',
    scrypt: 'hash — scrypt hash; verify — check password against hash on form',
    htpasswd: 'generate — Apache htpasswd line; optional verify with hash',
    argon2: 'hash | verify — runs in browser (Argon2id/i/d); optional memory/time/parallel presets',
    ec: 'generate_keys | encrypt | decrypt — ECDH / EC encrypt',
    'ec-sign-verify': 'generate_keys | sign | verify — note: form field ids swap PEM labels',
    elgamal: 'generate_keys (160|320) | encrypt | decrypt',
    dsa: 'generate_keys (512|1024|2048) | explain — sign/verify needs file upload on page',
    ntru: 'generate_keys | encrypt | decrypt — params: parameterSet, message, publicKey, privateKey',
    'jws-gen': 'generate — auto key + sign JSON payload (algo: HS256, RS256, ES256, …)',
    'jws-sign': 'sign — payload + algo + shared secret (HS*) or PEM private key (RS/PS/ES)',
    'jws-parse': 'parse — compact JWS/JWT string',
    'jws-verify': 'verify — token + HMAC secret OR RSA/EC public key PEM',
    jwk: 'generate — param 1–16 (1=RSA-2048 encrypt, 5=P-256, 9=Ed25519, …)',
    'jwk-convert': 'convert — param JWK-to-PEM or PEM-to-JWK + input',
  };
  return hints[tool] || profile.operations.join(', ');
}

function cipherSelectOptionValues() {
  const sel = document.getElementById('cipherparameternew');
  if (!sel) return [];
  return Array.from(sel.options).map((o) => o.value).filter(Boolean);
}

function cipherAliasKey(label) {
  return String(label || '').trim().toUpperCase().replace(/\s+/g, '').replace(/-/g, '_');
}

function inferCipherKeyBytes(userText, algorithm) {
  const t = `${userText || ''} ${algorithm || ''}`;
  if (/\b256[\s-]*bit\b/i.test(t) || /\b32[\s-]*byte/i.test(t)) return 32;
  if (/\b192[\s-]*bit\b/i.test(t) || /\b24[\s-]*byte/i.test(t)) return 24;
  if (/\b128[\s-]*bit\b/i.test(t) || /\b16[\s-]*byte/i.test(t)) return 16;
  if (/AES_256|AES256/i.test(t)) return 32;
  if (/AES_192|AES192/i.test(t)) return 24;
  if (/AES_128|AES128/i.test(t)) return 16;
  return 32;
}

function userWantsRandomCipherKey(userText) {
  const t = String(userText || '');
  return /\b(random|generate|generated|gen)\b/i.test(t) && /\b(key|secret)\b/i.test(t)
    || /\brandom\s+.*\b\d{2,4}[\s-]*bit\b/i.test(t);
}

function generateRandomHexKey(byteLength) {
  const hexChars = '0123456789abcdef';
  const bytes = new Uint8Array(byteLength);
  if (globalThis.crypto?.getRandomValues) {
    globalThis.crypto.getRandomValues(bytes);
  } else {
    for (let i = 0; i < byteLength; i++) bytes[i] = Math.floor(Math.random() * 256);
  }
  let hex = '';
  for (let i = 0; i < byteLength; i++) {
    hex += hexChars[(bytes[i] >> 4) & 0xf] + hexChars[bytes[i] & 0xf];
  }
  return hex;
}

/** Map LLM labels to CipherFunctions.jsp select values (e.g. AES/GCM/NoPadding → AES_256/GCM/NOPADDING). */
function secretKeyByteLength(hexKey) {
  return Math.floor(String(hexKey || '').replace(/\s/g, '').length / 2);
}

function resolveCipherAlgorithm(raw, userText, secretKey = '') {
  const algo = String(raw || '').trim();
  if (!algo) return '';
  const options = cipherSelectOptionValues();
  if (options.includes(algo)) return algo;

  const ctx = `${algo} ${userText || ''}`;
  const keyBytes = secretKeyByteLength(secretKey);
  const bits = keyBytes >= 32 ? 256 : keyBytes >= 24 ? 192 : keyBytes >= 16 ? 128 : inferCipherKeyBytes(ctx, algo);
  const upper = algo.toUpperCase().replace(/\s+/g, '').replace(/-/g, '_');

  if (/AES.*GCM/i.test(upper) || upper === 'AES/GCM/NOPADDING') {
    if (bits >= 32 || /256/.test(ctx)) return pickCipherOption(options, 'AES_256/GCM/NOPADDING');
    if (bits >= 24 || /192/.test(ctx)) return pickCipherOption(options, 'AES_192/GCM/NOPADDING');
    if (bits >= 16 || /128/.test(ctx)) return pickCipherOption(options, 'AES_128/GCM/NOPADDING');
    return pickCipherOption(options, 'AES_256/GCM/NOPADDING');
  }
  if (/AES.*CBC.*PKCS5/i.test(upper)) return pickCipherOption(options, 'AES/CBC/PKCS5PADDING');
  if (/AES.*CBC.*NOPAD/i.test(upper) && bits >= 32) return pickCipherOption(options, 'AES_256/CBC/NOPADDING');
  if (/CHACHA/i.test(upper)) return pickCipherOption(options, 'CHACHA');

  const want = cipherAliasKey(algo);
  const exact = options.find((o) => cipherAliasKey(o) === want);
  if (exact) return exact;

  const partial = options.find((o) => cipherAliasKey(o).includes(want) || want.includes(cipherAliasKey(o)));
  return partial || algo;
}

function pickCipherOption(options, preferred) {
  if (options.includes(preferred)) return preferred;
  return preferred;
}

function cipherUsesManualBlockPadding(algorithm) {
  return /\/(CBC|ECB)\/NOPADDING/i.test(String(algorithm || ''));
}

function cipherBlockBytes(algorithm) {
  const a = String(algorithm || '');
  if (/DESEDE|3DES/i.test(a)) return 8;
  if (/(^|\/)DES[\/_]/i.test(a) && !/AES/i.test(a)) return 8;
  return 16;
}

function messageByteLength(text) {
  return new TextEncoder().encode(String(text || '')).length;
}

function suggestCipherAlgorithmForPlaintext(algorithm, secretKey) {
  const a = String(algorithm || '');
  const kb = secretKeyByteLength(secretKey);
  if (/AES.*GCM/i.test(a) || /GCM/i.test(a)) {
    if (kb >= 32) return 'AES_256/GCM/NOPADDING';
    if (kb >= 24) return 'AES_192/GCM/NOPADDING';
    if (kb >= 16) return 'AES_128/GCM/NOPADDING';
    return 'AES_256/GCM/NOPADDING';
  }
  if (kb >= 32) return 'AES_256/GCM/NOPADDING';
  if (kb >= 24) return 'AES_192/GCM/NOPADDING';
  return 'AES/CBC/PKCS5PADDING';
}

function validateCipherPlan(plan) {
  const intent = plan.intent;
  if (intent !== 'encrypt' && intent !== 'decrypt') return null;
  const p = plan.params || {};
  const algo = p.algorithm || '';
  const msg = p.message || '';
  if (!cipherUsesManualBlockPadding(algo)) return null;

  const block = cipherBlockBytes(algo);
  if (intent === 'encrypt') {
    const len = messageByteLength(msg);
    if (len % block !== 0) {
      const suggest = suggestCipherAlgorithmForPlaintext(algo, p.secretKey);
      return {
        error: `Plaintext is ${len} bytes; **${algo}** needs a multiple of ${block} bytes (no padding).`,
        hint: `For arbitrary text, use **${suggest}** (PKCS5 or GCM handles length automatically).`,
        suggestAlgorithm: suggest,
      };
    }
  }
  return null;
}

function buildCipherStaticDecryptGuide(plan, extra = {}) {
  const p = plan.params || {};
  const lines = [
    '**How to decrypt on this page**',
    '1. Choose **Decrypt** (not Encrypt).',
    '2. Paste the **ciphertext** from the output into the message field (Base64 or hex as produced by the tool).',
    `3. Use the **same hex key** and algorithm (\`${p.algorithm || '…'}\`).`,
    '4. Click the main action button — plaintext appears in the output area.',
  ];
  if (extra.hint) lines.push('', extra.hint);
  if (extra.suggestAlgorithm) {
    lines.push('', `**Suggested algorithm for this message:** \`${extra.suggestAlgorithm}\``);
  }
  return lines.join('\n');
}

async function fetchCipherWorkflowExplain(ai, { plan, outcome, errorText }) {
  const p = plan.params || {};
  const keyBytes = secretKeyByteLength(p.secretKey);
  const msgBytes = messageByteLength(p.message);
  const userBlock = [
    `Outcome: ${outcome}`,
    `User operation: ${plan.intent}`,
    `Algorithm: ${p.algorithm || '(none)'}`,
    `Plaintext/ciphertext field length: ${msgBytes} bytes (encrypt input)`,
    `Secret key: ${keyBytes ? `${keyBytes} bytes hex` : 'not set'}`,
    errorText ? `Backend error: ${errorText}` : 'Backend encryption succeeded; full ciphertext is on the page.',
    '',
    'Explain briefly:',
    '- Why this succeeded or failed (padding/block size if relevant)',
    '- Exact steps to decrypt on CipherFunctions.jsp (Decrypt mode, paste output, same key & algorithm)',
    '- One practical tip (GCM vs CBC/PKCS5) — do not invent ciphertext or keys',
  ].join('\n');

  const reply = await chat(
    ai.aiUrl,
    {
      messages: [
        {
          role: 'system',
          content: 'You teach symmetric encryption on a JSP cipher tool. Concise markdown, under 15 lines. No JSON. No made-up ciphertext.',
        },
        { role: 'user', content: userBlock },
      ],
      stream: false,
    },
    { useGateway: ai.useGateway, userId: ai.userId, toolId: 'cryptography/cipher' },
  );
  return String(reply || '').trim();
}

function normalizeCipherParams(params, userText) {
  if (params.text && !params.message) params.message = params.text;
  if (params.key && !params.secretKey) params.secretKey = params.key;
  if (params.plaintext && !params.message) params.message = params.plaintext;

  if (params.algorithm) {
    let resolved = resolveCipherAlgorithm(params.algorithm, userText, params.secretKey);
    if (/\bGCM\b/i.test(userText) && /\/CBC\/NOPADDING/i.test(resolved)) {
      resolved = suggestCipherAlgorithmForPlaintext('AES/GCM', params.secretKey);
    }
    params.algorithm = resolved;
    params.algo = resolved;
  }

  const keyEmpty = !params.secretKey || params.secretKey === FORM_REDACTED;
  if (userWantsRandomCipherKey(userText) && keyEmpty) {
    const bytes = inferCipherKeyBytes(userText, params.algorithm);
    params.secretKey = generateRandomHexKey(bytes);
    params._clientGeneratedKey = true;
  }
}

const EC_CURVE_ALIASES = new Map([
  ['SECP256R1', 'P-256'],
  ['PRIME256V1', 'P-256'],
  ['P256', 'P-256'],
  ['NISTP256', 'P-256'],
  ['SECP384R1', 'P-384'],
  ['P384', 'P-384'],
  ['SECP521R1', 'P-521'],
  ['P521', 'P-521'],
  ['SECP256K1', 'secp256k1'],
]);

function normalizeEcCurve(name) {
  const raw = String(name || '').trim();
  if (!raw) return '';
  const key = raw.replace(/[\s_-]+/g, '').toUpperCase();
  return EC_CURVE_ALIASES.get(key) || raw;
}

function normalizeCommonCryptoParams(params, profile) {
  if (params.text && !params.message) params.message = params.text;
  if (params.key && profile.tool === 'cipher' && !params.secretKey) params.secretKey = params.key;
  if (profile.tool === 'ec' || profile.tool === 'ec-sign-verify') {
    if (params.curve) params.curve = normalizeEcCurve(params.curve);
  }
}

const PBKDF_ALGO_ALIASES = [
  ['PBKDF2-HMAC-SHA256', 'PBKDF2WithHmacSHA256'],
  ['PBKDF2-HMAC-SHA384', 'PBKDF2WithHmacSHA384'],
  ['PBKDF2-HMAC-SHA512', 'PBKDF2WithHmacSHA512'],
  ['PBKDF2-HMAC-SHA224', 'PBKDF2WithHmacSHA224'],
  ['SHA-256', 'PBKDF2WithHmacSHA256'],
  ['SHA256', 'PBKDF2WithHmacSHA256'],
  ['SHA-512', 'PBKDF2WithHmacSHA512'],
  ['SHA512', 'PBKDF2WithHmacSHA512'],
];

/** Canonical PBE algorithm ids from pbe.jsp (subset of most common). */
const PBE_CANONICAL = [
  'PBEWITHHMACSHA256ANDAES_256',
  'PBEWITHHMACSHA512ANDAES_256',
  'PBEWITHHMACSHA256ANDAES_128',
  'PBEWITHMD5AND256BITAES-CBC-OPENSSL',
  'PBEWITHMD5ANDDES',
  'PBEWITHSHA256AND256BITAES-CBC-BC',
];

const PBE_ALGO_ALIASES = [
  ['PBEWITHMD5AND256BITAES-CBC-OPENSSL', 'PBEWITHMD5AND256BITAES-CBC-OPENSSL'],
  ['PBEWITHMD5AND256BITAES', 'PBEWITHMD5AND256BITAES-CBC-OPENSSL'],
  ['PBEWITHHMACSHA256ANDAES256', 'PBEWITHHMACSHA256ANDAES_256'],
  ['PBEWITHHMACSHA256ANDAES-256', 'PBEWITHHMACSHA256ANDAES_256'],
  ['PBEWITHHMACSHA512ANDAES256', 'PBEWITHHMACSHA512ANDAES_256'],
  ['AES-256-PBE', 'PBEWITHHMACSHA256ANDAES_256'],
  ['PBE-SHA256-AES256', 'PBEWITHHMACSHA256ANDAES_256'],
];

function normalizePbeAlgorithm(name) {
  const raw = String(name || '').trim();
  if (!raw) return '';
  const compact = raw.toUpperCase().replace(/[\s-]+/g, '');
  for (const [alias, canon] of PBE_ALGO_ALIASES) {
    if (compact === alias.toUpperCase().replace(/[\s-]+/g, '')) return canon;
  }
  const exact = PBE_CANONICAL.find(
    (id) => id.toUpperCase().replace(/[\s-]+/g, '') === compact,
  );
  if (exact) return exact;
  const sel = document.getElementById('cipherparameternew');
  if (sel) {
    const match = [...sel.options].find(
      (o) => o.value.toUpperCase().replace(/[\s-]+/g, '') === compact,
    );
    if (match) return match.value;
  }
  return raw.replace(/[\s-]+/g, '').includes('PBEWITH') ? raw.replace(/[\s-]+/g, '') : '';
}

function normalizePbkdfAlgorithm(name) {
  const raw = String(name || '').trim();
  if (!raw) return '';
  const upper = raw.toUpperCase().replace(/[\s-]+/g, '');
  for (const [alias, canon] of PBKDF_ALGO_ALIASES) {
    if (upper === alias.toUpperCase().replace(/[\s-]+/g, '')) return canon;
  }
  if (/^PBKDF2WITHHMACSHA\d+$/i.test(raw.replace(/[\s-]/g, ''))) {
    return raw.replace(/[\s-]/g, '');
  }
  return raw;
}

function normalizeNtruParams(params, userText, profile) {
  const sets = profile.supportedParameterSets || [];
  const raw = String(params.parameterSet || params.param || '').trim();
  if (raw && sets.includes(raw)) return;
  const fromText = String(userText || '').match(
    /APR2011_\d+(?:_FAST)?|EES\d+EP\d(?:_FAST)?/i,
  );
  if (fromText) {
    const id = fromText[0].toUpperCase().replace(/_FAST/i, '_FAST');
    if (!sets.length || sets.includes(id)) {
      params.parameterSet = id;
    }
  }
}

function ntruRouterRule(profile) {
  const sets = profile.supportedParameterSets || [];
  if (!sets.length) return '';
  return `
8. NTRU page only — use EXACT param names:
   parameterSet: one of ${sets.join(', ')} (match user text, e.g. APR2011_439)
   message: plaintext or Base64 ciphertext
   publicKey / privateKey: leave "" if generating keys (not in chat)
   generate_keys: only needs parameterSet; encrypt needs message + publicKey; decrypt needs message + both keys`;
}

function cipherRouterRule() {
  const sample = cipherSelectOptionValues().slice(0, 8);
  const examples = sample.length ? sample.join(', ') : 'AES_256/GCM/NOPADDING, AES/CBC/PKCS5PADDING';
  return `
8. Cipher page only — use EXACT param names (not text/key):
   message: plaintext or ciphertext string from the user (quoted text without quotes)
   secretKey: hex key string; leave "" if user asks for random/generated key (client generates)
   algorithm: exact dropdown value (underscores, NOPADDING uppercase), e.g. ${examples}
   Map "AES/GCM/NoPadding" + 256-bit key → AES_256/GCM/NOPADDING; pick AES variant from key length (32-byte hex → AES_256).
   CBC/ECB/NOPADDING requires plaintext length multiple of 16 bytes — prefer GCM or AES/CBC/PKCS5PADDING for normal text.
   Do not list message/secretKey in missing[] when present in the user message or form.`;
}

function hmacRouterAlgorithmRule(profile) {
  const ids = hmacSupportedAlgorithms(profile);
  if (!ids.length) return '';
  return `
8. HMAC page only: put algorithms in params.algorithms as EXACT checkbox values:
   ${ids.join(', ')}
   Map user wording to these ids (e.g. "HMAC-SHA-256" or "HMAC SHA256" → HmacSHA256).
   Never use plain SHA-256/MD5 alone — use HmacSHA256/HMACMD5 etc.
   User may request multiple algorithms; include every requested id in algorithms[].`;
}

function buildRouterPrompt(profile) {
  const cryptoOps = profile.operations.filter((o) => o !== 'explain');
  const opList = [...cryptoOps, 'explain', 'clarify'].join(' | ');
  const hmacAlgoRule = profile.tool === 'hmac' ? hmacRouterAlgorithmRule(profile) : '';
  const cipherAlgoRule = profile.tool === 'cipher' ? cipherRouterRule() : '';
  const ntruAlgoRule = profile.tool === 'ntru' ? ntruRouterRule(profile) : '';
  const ecCurveRule = (profile.tool === 'ec' || profile.tool === 'ec-sign-verify')
    ? '\n8. EC curves: use dropdown values P-256, P-384, P-521, secp256k1, secp256r1 — map secp256r1/prime256v1 → P-256.'
    : '';
  const pbeAlgoRule = profile.tool === 'pbe'
    ? '\n8. PBE: algorithm must be exact Jasypt id e.g. PBEWITHHMACSHA256ANDAES_256 (default). Use rounds 10000+. Params: message, password, rounds, algorithm.'
    : '';
  const argon2Rule = profile.tool === 'argon2'
    ? '\n8. Argon2: hash intent needs password; variant argon2id|argon2i|argon2d; optional memory (KB), time, parallel, hashLen, preset interactive|moderate|sensitive. verify needs password + hash ($argon2...).'
    : '';
  const elgamalRule = profile.tool === 'elgamal'
    ? '\n8. ElGamal: encrypt needs message + publicKey (privateKey on form for decrypt only). algorithm defaults to ELGAMAL — do not ask user for algorithm unless they want ECB/PKCS1 variant. Params: message, publicKey, privateKey, keySize (160|320).'
    : '';
  const scryptRule = profile.tool === 'scrypt'
    ? '\n8. Scrypt hash: needs password + salt. Optional n (CPU cost N, default 2048), r (block size, default 8), p (parallelism, default 1), length (default 32). Do not list N/r/p in missing[] — client applies page defaults.'
    : '';
  const htpasswdRule = profile.tool === 'htpasswd'
    ? '\n8. htpasswd generate: username, password, optional algorithm (bcrypt|sha512|sha256|apr). Server returns all formats; UI highlights requested algorithm. Params: username, password, algorithm.'
    : '';
  const jwsParseRule = profile.tool === 'jws-parse'
    ? '\n8. JWS parse: intent parse. If jwsTokenOnForm is true, set serialized to "" (empty) — the client loads the real token from the page. Never copy the redacted FORM STATE summary into serialized. If user pastes eyJ… in chat, you may set serialized to that token only.'
    : '';
  const jwsSignRule = profile.tool === 'jws-sign'
    ? '\n8. JWS sign: intent sign. Leave sharedsecret and key as "" — client merges from form (hmacSecretOnForm / privateKeyOnForm). Never put PEM or secrets in params. HS* → sharedsecret on form; RS/PS/ES* → PEM key on form.'
    : '';
  const jwsVerifyRule = profile.tool === 'jws-verify'
    ? '\n8. JWS verify: intent **verify** only when the user wants to run verification now (e.g. "verify the token on the form"). Workflow questions ("how do I verify after jwsgen", "I generated on jwsgen — how to verify here") → intent **explain** — do NOT run verify. serialized "" if jwsTokenOnForm; sharedsecret/publickey "" if on form. Never copy redacted summaries. HS* needs sharedsecret; RS/PS/ES* needs publickey PEM.'
    : '';
  const jwkGenRule = profile.tool === 'jwk'
    ? '\n8. JWK generate: intent generate, param 1–17 (5=P-256, 9=Ed25519, 11=HS256, 1=RSA-2048-encrypt). Map user wording to param number.'
    : '';
  const jwkConvertRule = profile.tool === 'jwk-convert'
    ? '\n8. JWK convert: intent convert, param JWK-to-PEM or PEM-to-JWK. input "" if keyMaterialOnForm — client reads textarea.'
    : '';
  return `You route user requests for: ${profile.title}.
Return ONLY valid JSON (no markdown):
{
  "intent": "${opList}",
  "params": {},
  "missing": [],
  "clarify_message": ""
}

PAGE CAPABILITIES: ${operationHints(profile)}

ALLOWED intents: ${opList}
- **explain**: user asks what/why/how, comparisons, best practices — NO execution
- **clarify**: user wants crypto but operation or inputs are ambiguous — ask in clarify_message
- **Crypto intents**: ${cryptoOps.join(', ')} — fill params from user message + [FORM STATE] below

PARAM NAMES (use exact names; empty string if unknown — client merges form):
text, message, key, password, secretKey, algorithms (array), algorithm, algo, rounds, cost, workload, salt, keyLength, keylength,
curve, publicKey, publickey, privateKey, publicKeyAlice, privateKeyAlice, publicKeyBob, privateKeyBob,
signature, parameterSet, username, hash, payload, serialized, sharedsecret, param, input, direction, plaintext

RULES:
1. Pick the ONE best intent for this page only (do not use ops from other tools).
2. Never put real passwords/PEM/shared secrets in params — use "" if user says "on form" / "my key".
3. For bcrypt/scrypt "hash" intent = password hashing, NOT message-digest hash.
4. JWS algorithms: HS256, HS384, HS512, RS256, RS384, RS512, PS256, PS384, PS512, ES256, ES384, ES512.
5. If user pasted a JWT/JWS dot-separated token on a parse page → intent parse, param serialized.
6. List missing human-readable fields in missing[]; friendly clarify_message if intent is clarify.
7. Do NOT invent digests, ciphertext, signatures, or keys.${hmacAlgoRule}${cipherAlgoRule}${ntruAlgoRule}${ecCurveRule}${pbeAlgoRule}${argon2Rule}${elgamalRule}${scryptRule}${htpasswdRule}${jwsParseRule}${jwsSignRule}${jwsVerifyRule}${jwkGenRule}${jwkConvertRule}`;
}

function normalizeIntent(plan, profile, userText) {
  const allowed = new Set([...profile.operations, 'clarify']);
  let intent = String(plan.intent || '').trim().toLowerCase();

  if (intent === 'clarify') return plan;

  if (looksLikeWorkflowExplain(userText) && profile.operations.includes('explain')) {
    plan.intent = 'explain';
    return plan;
  }

  if (!allowed.has(intent)) {
    const inferred = inferIntent(userText, profile);
    if (inferred) {
      plan.intent = inferred;
      return plan;
    }
    if (!allowed.has(intent)) {
      plan.intent = 'explain';
    }
  }
  return plan;
}

function inferIntent(userText, profile) {
  const t = String(userText || '').toLowerCase();
  const ops = new Set(profile.operations);

  if (/\b(what is|what's|explain|how does|why use|difference|vs\.?|versus|compare)\b/.test(t)
    && !/\b(hash|encrypt|decrypt|sign|verify|derive|generate|parse|convert|run|compute|calculate)\b.*\b(with|using|for me|now)\b/.test(t)) {
    return ops.has('explain') ? 'explain' : null;
  }

  if (ops.has('parse') && (/\bparse\b/.test(t) || /\bdecode\b/.test(t) || /\beyJ[a-z0-9_-]+\./i.test(userText))) {
    return 'parse';
  }
  if (ops.has('verify') && !/\bhow (do|to|can) i\b/.test(t)) {
    if (/\b(verify|validate|check)\b/.test(t)
      && /\b(sign|token|jwt|jws|signature|hash|password)\b/.test(t)
      && !/\b(jwsgen|after jwsgen|on this page|how to)\b/.test(t)) {
      return 'verify';
    }
  }
  if (ops.has('sign') && /\bsign\b/.test(t)) return 'sign';
  if (ops.has('encrypt') && /\bencrypt/.test(t)) return 'encrypt';
  if (ops.has('decrypt') && /\bdecrypt/.test(t)) return 'decrypt';
  if (ops.has('convert') && /\bconvert\b/.test(t)) return 'convert';
  if (ops.has('derive') && /\b(derive|pbkdf)/.test(t)) return 'derive';
  if (ops.has('generate_keys') && /\b(generate|create).*(key|pair)/.test(t)) return 'generate_keys';
  if (ops.has('generate') && (/\b(generate|create)\b/.test(t) || /\bhtpasswd\b/.test(t))) return 'generate';
  if (ops.has('hmac') && /\bhmac\b/.test(t)) return 'hmac';
  if (ops.has('hash') && profile.tool === 'message-digest' && /\b(hash|digest|sha|md5|blake)/.test(t)) {
    return 'hash';
  }
  if (ops.has('hash') && (profile.tool === 'bcrypt' || profile.tool === 'scrypt' || profile.tool === 'argon2')
    && /\b(hash|bcrypt|scrypt|argon2)\b/.test(t)) {
    return 'hash';
  }
  return null;
}

async function analyzeCryptoIntent(ai, { profile, pageSnapshot, userText }) {
  const prompt = buildRouterPrompt(profile);
  const formState = typeof pageSnapshot === 'string'
    ? pageSnapshot
    : JSON.stringify(pageSnapshot, null, 2);
  const reply = await chat(
    ai.aiUrl,
    {
      messages: [
        { role: 'system', content: prompt },
        { role: 'user', content: `[FORM STATE]\n${formState}\n\n[USER]\n${userText}` },
      ],
    },
    {
      useGateway: ai.useGateway,
      userId: ai.userId,
      toolId: profile.toolId,
    },
  );
  const plan = parseJsonLoose(reply) || {
    intent: 'clarify',
    params: {},
    missing: ['request'],
    clarify_message: 'I could not understand that. Try rephrasing, or pick a quick action above.',
  };
  plan.params = plan.params && typeof plan.params === 'object' ? plan.params : {};
  return normalizeIntent(plan, profile, userText);
}

function mergePlanWithForm(plan, profile, userText = '') {
  const form = profile.readForm?.() || {};
  const params = { ...plan.params };
  const fillIfEmpty = (key, val) => {
    if ((params[key] == null || params[key] === '') && val) params[key] = val;
  };
  Object.entries(form).forEach(([k, v]) => {
    if (typeof v === 'string' && v !== FORM_REDACTED) fillIfEmpty(k, v);
    if (Array.isArray(v) && v.length && (!params[k] || !params[k].length)) params[k] = v;
  });
  normalizeCommonCryptoParams(params, profile);
  if (profile.tool === 'cipher') normalizeCipherParams(params, userText);
  if (profile.tool === 'ntru') normalizeNtruParams(params, userText, profile);
  normalizePlanAlgorithms(profile, params);
  if (!params.algorithms?.length && profile.defaultAlgorithms?.length) {
    params.algorithms = [...profile.defaultAlgorithms];
  }
  if (params.algo && !params.algorithm) params.algorithm = params.algo;
  if (!params.algorithm && !params.algo && form.algorithm) {
    params.algorithm = form.algorithm;
    params.algo = form.algorithm;
  }
  if (params.publicKey && !params.publickey) params.publickey = params.publicKey;
  if (profile.tool === 'jws-parse' || profile.tool === 'jws-verify') {
    resolveJwsSerializedForExecution(params, form, userText, profile);
  }
  if (profile.tool === 'jws-sign') {
    if (params.privateKey && !params.key) params.key = params.privateKey;
    if (params.sharedSecret && !params.sharedsecret) params.sharedsecret = params.sharedSecret;
    if (!params.algorithm && form.algorithm) {
      params.algorithm = form.algorithm;
      params.algo = form.algorithm;
    }
  }
  if (profile.tool === 'jws-verify') {
    if (form.sharedsecret && !params.sharedsecret) params.sharedsecret = form.sharedsecret;
    if (form.publickey && !params.publickey && !params.publicKey) params.publickey = form.publickey;
  }
  if (profile.tool === 'jwk') {
    const p = normalizeJwkParamValue(params.param || params.algorithm || params.algo, userText);
    if (p) params.param = p;
  }
  if (profile.tool === 'jwk-convert') {
    if (form.input?.trim() && (!params.input || isRedactedJwsPlaceholder(params.input))) {
      params.input = form.input;
    }
  }
  return { ...plan, params };
}

function resolveMissingFields(plan, profile) {
  const missing = [];
  const p = plan.params || {};
  const need = (field, label) => {
    const v = p[field];
    if (v == null || v === '' || (Array.isArray(v) && !v.length)) missing.push(label || field);
  };

  switch (plan.intent) {
    case 'hash':
      if (profile.tool === 'message-digest') {
        need('text', 'text to hash');
        need('algorithms', 'hash algorithm(s)');
      } else {
        need('password', 'password to hash');
      }
      break;
    case 'hmac':
      need('text', 'text to authenticate');
      need('key', 'HMAC secret key');
      need('algorithms', 'HMAC algorithm(s)');
      break;
    case 'encrypt':
    case 'decrypt':
      if (profile.tool === 'cipher') {
        need('message', 'message (or ciphertext for decrypt)');
        need('secretKey', 'secret key (hex)');
        need('algorithm', 'cipher algorithm');
      } else {
        need('message', 'message');
        if (profile.tool === 'pbe') need('password', 'password');
        need('algorithm', 'algorithm');
      }
      break;
    case 'derive':
      need('password', 'password');
      need('salt', 'salt');
      need('algorithms', 'PBKDF algorithm');
      break;
    case 'generate':
      if (profile.tool === 'jwk') {
        need('param', 'key type (1–16, e.g. 5 for P-256)');
      } else if (profile.tool === 'jws-gen') {
        need('payload', 'JSON payload');
        need('algorithm', 'JWS algorithm (e.g. HS256)');
      } else if (profile.tool === 'htpasswd') {
        need('username', 'username');
        need('password', 'password');
      }
      break;
    case 'parse':
      need('serialized', 'JWS/JWT token');
      break;
    case 'convert':
      need('input', 'JWK or PEM input');
      if (profile.tool === 'jwk-convert') need('param', 'direction (JWK-to-PEM or PEM-to-JWK)');
      break;
    case 'verify':
      if (profile.tool === 'jws-verify') {
        need('serialized', 'JWS/JWT token');
        if (!p.sharedsecret && !p.publickey && !p.publicKey) {
          missing.push('HMAC shared secret or public key PEM');
        }
      } else if (profile.tool === 'bcrypt' || profile.tool === 'scrypt' || profile.tool === 'argon2') {
        need('password', 'password');
        need('hash', 'hash to verify against');
      } else if (profile.tool === 'htpasswd') {
        need('password', 'password');
        need('hash', 'htpasswd hash line');
      } else {
        need('message', 'message');
        need('signature', 'signature');
        need('publicKey', 'public key');
      }
      break;
    case 'sign':
      if (profile.tool === 'jws-sign') {
        need('payload', 'JSON payload');
        const algo = String(p.algorithm || p.algo || '').toUpperCase();
        need('algorithm', 'JWS algorithm');
        if (algo.startsWith('HS')) need('sharedsecret', 'shared secret');
        else if (algo) need('key', 'PEM private key');
        else if (!algo) missing.push('algorithm (HS256, RS256, …)');
      } else {
        need('message', 'message');
        need('privateKey', 'private key');
      }
      break;
    case 'generate_keys':
      if (profile.tool === 'ec' || profile.tool === 'ec-sign-verify') need('curve', 'elliptic curve');
      if (profile.tool === 'ntru') need('parameterSet', 'NTRU parameter set');
      break;
    default:
      break;
  }
  return missing;
}

function buildClarifyMessage(plan, missing) {
  if (plan.clarify_message) return plan.clarify_message;
  if (missing.length === 1) return `To run this on the page, I need: **${missing[0]}**.`;
  return `To run this on the page, I still need:\n${missing.map((m) => `- ${m}`).join('\n')}`;
}
// --- executor ---

function fence(label, text) {
  const body = String(text || '').trim();
  return `**${label}**\n\n\`\`\`\n${body}\n\`\`\``;
}

function base64ToHex(b64) {
  try {
    const binary = atob(String(b64 || '').replace(/\s/g, ''));
    return Array.from(binary, (c) => `0${c.charCodeAt(0).toString(16)}`.slice(-2)).join('');
  } catch {
    return '';
  }
}

function formatCipherErrorMessage(raw, plan) {
  const msg = String(raw || 'Operation failed');
  const p = plan.params || {};
  if (/IllegalBlockSize|not multiple of \d+ bytes/i.test(msg)) {
    const len = messageByteLength(p.message);
    const block = cipherBlockBytes(p.algorithm);
    const suggest = suggestCipherAlgorithmForPlaintext(p.algorithm, p.secretKey);
    return [
      `**Encryption failed:** plaintext is ${len} bytes; **${p.algorithm}** requires a multiple of ${block} bytes without padding.`,
      '',
      `**Fix:** switch algorithm to \`${suggest}\`, or pad the message to a ${block}-byte boundary.`,
    ].join('\n');
  }
  return `**Error:** ${msg}`;
}

function formatCryptoResult(data, plan, profile) {
  if (data.ok === false) {
    if (profile.tool === 'cipher') return formatCipherErrorMessage(data.error || data.errorMessage, plan);
    return `**Error:** ${data.error || data.errorMessage || 'Operation failed'}`;
  }

  if (data.message === 'VALID' || data.message === 'INVALID') {
    const lines = [
      data.message === 'VALID'
        ? '**Signature valid** — verification succeeded.'
        : '**Signature invalid** — verification failed.',
    ];
    if (data.jwsState) lines.push('', data.jwsState);
    if (profile.tool === 'jws-verify') lines.push('', 'See **Verification Result** on the page for details.');
    return lines.join('\n');
  }
  if (data.jwsSerialize) {
    const lines = ['**JWS ready** — full output is on the page.', ''];
    if (data.algorithm) lines.push(`- Algorithm: \`${data.algorithm}\``);
    lines.push('', '**Compact token:**', '', '```', String(data.jwsSerialize), '```');
    return lines.join('\n');
  }
  if (data.jwsHeader || data.jwsPayload) {
    const lines = ['**Parsed JWS/JWT** — full breakdown is on the page.', ''];
    if (data.jwsHeader) lines.push('**Header:**', '```json', String(data.jwsHeader), '```', '');
    if (data.jwsPayload) lines.push('**Payload:**', '```json', String(data.jwsPayload), '```', '');
    const claims = [];
    if (data.issuer) claims.push(`- iss: \`${data.issuer}\``);
    if (data.subject) claims.push(`- sub: \`${data.subject}\``);
    if (data.audienceSize) claims.push(`- aud: \`${data.audienceSize}\``);
    if (data.expirationTime) claims.push(`- exp: \`${data.expirationTime}\``);
    if (data.notBeforeTime) claims.push(`- nbf: \`${data.notBeforeTime}\``);
    if (data.issueTime) claims.push(`- iat: \`${data.issueTime}\``);
    if (data.jwtId) claims.push(`- jti: \`${data.jwtId}\``);
    if (claims.length) {
      lines.push('**Registered claims:**', '', ...claims, '');
    }
    if (data.jwsState) lines.push(`**State:** ${data.jwsState}`);
    return lines.join('\n');
  }
  if (profile.tool === 'jwk' && data.message) {
    let body = String(data.message);
    try {
      body = JSON.stringify(JSON.parse(body), null, 2);
    } catch { /* keep raw */ }
    return ['**JWK generated** — full JSON is on the page.', '', fence('JWK', body.slice(0, 6000))].join('\n');
  }
  if (profile.tool === 'jwk-convert' && data.success !== false) {
    const op = data.algorithm || plan.params?.param || '';
    if (op === 'JWK-to-PEM') {
      return [
        '**JWK → PEM conversion done** — keys are on the page.',
        data.base64Encoded ? '- Private key PEM shown (if present in JWK)' : '',
        data.message ? '- Public key PEM shown' : '',
      ].filter(Boolean).join('\n');
    }
    if (op === 'PEM-to-JWK' && data.message) {
      let jwk = String(data.message);
      try { jwk = JSON.stringify(JSON.parse(jwk), null, 2); } catch { /* */ }
      return ['**PEM → JWK conversion done** — full JWK is on the page.', '', fence('JWK', jwk.slice(0, 6000))].join('\n');
    }
  }
  if (data.verified === true || data.verified === false) {
    const msg = data.verificationMessage || (data.verified ? 'Password matches hash.' : 'Password does not match hash.');
    return data.verified ? `**Verified:** ${msg}` : `**Not verified:** ${msg}`;
  }
  if (profile.tool === 'ec' && data.publicKeyAlice && data.privateKeyAlice) {
    return [
      '**ECDH key pairs generated** — Alice and Bob keys are on the page.',
      '',
      `- Curve: \`${data.curve || plan.params?.curve || ''}\``,
      '- Use **Encrypt** / **Decrypt** with both parties’ keys filled in.',
    ].join('\n');
  }
  if (profile.tool === 'ec-sign-verify' && data.privateKey && data.publicKey) {
    return [
      '**ECDSA key pair generated** — keys are filled on the page (private in the first PEM box).',
      '',
      `- Curve: \`${data.curve || plan.params?.curve || ''}\``,
    ].join('\n');
  }
  if (profile.tool === 'ntru') {
    if (data.publicKey && data.privateKey) {
      const ps = data.parameterSet || plan.params?.parameterSet || '';
      return [
        '**NTRU key pair generated** — keys are filled on the page.',
        '',
        `- Parameter set: \`${ps}\``,
        '- Expand **NTRU Keys** to view public/private key material.',
        '',
        '**Next — encrypt:** enter plaintext, stay on **Encrypt**, send a message like “encrypt hello”.',
        '**Next — decrypt:** switch to **Decrypt**, paste the Base64 ciphertext from results, use the same keys.',
      ].join('\n');
    }
    if (data.ciphertext) {
      return fence('Ciphertext (Base64)', data.ciphertext);
    }
    if (data.plaintext) {
      return fence('Plaintext', data.plaintext);
    }
  }
  if (data.hash && profile.tool === 'scrypt') {
    const lines = ['**Scrypt hash generated** — see the page output panel.', ''];
    if (data.cpuCost || data.memoryCost) {
      lines.push(`- N=${data.cpuCost || plan.params?.n || ''}, r=${data.memoryCost || plan.params?.r || ''}, p=${data.parallelization || plan.params?.p || ''}`);
    }
    lines.push('', '**Hash (hex):**', '', '```', String(data.hash), '```');
    return lines.join('\n');
  }
  if (data.hash && (profile.tool === 'bcrypt' || profile.tool === 'argon2')) {
    return fence(profile.tool === 'argon2' ? 'Argon2 hash' : 'Hash', data.hash);
  }
  if (profile.tool === 'htpasswd' && data.htpasswdEntries?.length) {
    const pref = plan.params?.algorithm || plan.params?.algo || 'bcrypt';
    const entries = pickHtpasswdEntries(data, pref);
    const lines = [
      '**htpasswd entry generated** — full lines are on the page.',
      data.username ? `- User: \`${data.username}\`` : '',
      '',
    ].filter(Boolean);
    entries.forEach((e) => {
      lines.push(`**${e.algorithm}**`, '', '```', String(e.fullEntry || `${data.username || ''}:${e.hash || ''}`), '```', '');
    });
    return lines.join('\n');
  }
  if (profile.tool === 'elgamal') {
    if (data.ciphertext) {
      return fence('ElGamal ciphertext (Base64)', data.ciphertext);
    }
    if (data.plaintext) {
      return fence('Plaintext', data.plaintext);
    }
  }
  if (profile.tool === 'dsa' || profile.tool === 'elgamal') {
    if (data.publicKey && data.privateKey) {
      return [
        `**${profile.tool === 'dsa' ? 'DSA' : 'ElGamal'} keys generated** — PEM keys are on the page.`,
        '',
        `- Key size: \`${data.keySize || plan.params?.keySize || ''}\` bits`,
        '- Encrypt using the public key; decrypt with the private key.',
        profile.tool === 'dsa'
          ? '- DSA sign/verify still requires **file upload** on the page.'
          : '- **Encrypt:** send e.g. `ElGamal-encrypt "hello"` (uses keys on the form).',
      ].filter(Boolean).join('\n');
    }
  }
  if (data.results && Array.isArray(data.results)) {
    const lines = data.results.map((r) => {
      const algo = r.algorithm || r.name || 'result';
      const derived = r.derivedKey || '';
      const b64 = derived || r.base64Encoded || r.base64 || '';
      const hex = r.hexEncoded || r.hex || (b64 ? base64ToHex(b64) : '');
      const enc = r.encryptedMessage || r.message || '';
      if (enc) return `- **${algo}**: ${String(enc).slice(0, 120)}${String(enc).length > 120 ? '…' : ''}`;
      if (profile.tool === 'pbkdf' && b64) {
        return `- **${algo}**: base64 \`${b64}\`${hex ? `, hex \`${hex}\`` : ''}`;
      }
      return `- **${algo}**: hex \`${hex}\`${b64 ? `, base64 \`${b64}\`` : ''}`;
    });
    const header = profile.tool === 'pbkdf'
      ? '**PBKDF2 derived key** — full output is on the page.'
      : '**Done** — details are in the page output.';
    const meta = profile.tool === 'pbkdf' && data.iterations
      ? [`- Iterations: ${data.iterations}`, data.keyLengthBytes ? `- Key length: ${data.keyLengthBytes} bytes` : '', data.salt ? `- Salt: \`${data.salt}\`` : '']
      : [];
    return [header, '', ...meta.filter(Boolean), ...meta.length ? [''] : [], ...lines].join('\n');
  }
  if (data.output) {
    return fence('Result', stripHtml(data.output));
  }
  if (data.message && typeof data.message === 'string' && data.message.length < 8000) {
    return fence('Result', stripHtml(data.message));
  }
  const lines = ['**Done** — check the **Output** section on the page for the full result.'];
  if (plan.params?._clientGeneratedKey && plan.params?.secretKey) {
    lines.unshift(`Generated **${plan.params.secretKey.length / 2}-byte** random hex key (filled on the form).`);
  }
  if (profile.tool === 'cipher' && plan.intent === 'encrypt') {
    lines.push('', buildCipherStaticDecryptGuide(plan));
  }
  return lines.join('\n');
}

function stripHtml(html) {
  const div = document.createElement('div');
  div.innerHTML = String(html || '');
  return div.textContent || div.innerText || String(html || '');
}

async function executeCryptoPlan(ctx, plan, profile, userText = '') {
  const intent = plan.intent;
  if (intent === 'explain') {
    return { ok: true, explain: true };
  }

  const params = { ...plan.params };
  if (params.algo && !params.algorithm) params.algorithm = params.algo;
  if (params.algorithm && !params.algo) params.algo = params.algorithm;
  if (params.publicKey && !params.publickey) params.publickey = params.publicKey;
  if (params.plaintext && !params.message) params.message = params.plaintext;
  if (params.message && !params.plaintext && profile.tool === 'cipher') params.plaintext = params.message;
  normalizeCommonCryptoParams(params, profile);
  if (profile.tool === 'cipher') normalizeCipherParams(params, userText);
  if (profile.tool === 'elgamal') normalizeElgamalParams(params);
  if (profile.tool === 'scrypt') normalizeScryptParams(params);
  if (profile.tool === 'htpasswd') normalizeHtpasswdParams(params);
  if ((profile.tool === 'jws-parse' || profile.tool === 'jws-verify')
    && (intent === 'parse' || intent === 'verify')) {
    const form = profile.readForm?.() || {};
    resolveJwsSerializedForExecution(params, form, userText, profile);
  }
  if (params.algorithms && !Array.isArray(params.algorithms)) {
    params.algorithms = [params.algorithms];
  }
  if (params.algorithm && !params.algorithms?.length) {
    params.algorithms = [params.algorithm];
  }
  normalizePlanAlgorithms(profile, params);

  if (profile.applyToForm && intent !== 'explain') {
    profile.applyToForm({ ...params, intent });
  }

  if (profile.tool === 'cipher') {
    const preflight = validateCipherPlan({ intent, params });
    if (preflight) {
      const markdown = [
        preflight.error,
        '',
        preflight.hint,
        '',
        buildCipherStaticDecryptGuide({ intent, params }, preflight),
      ].join('\n');
      return { ok: false, error: preflight.error, markdown, preflight: true };
    }
  }

  if (profile.clientSide && profile.tool === 'argon2') {
    normalizeArgon2Params(params);
    const data = await executeArgon2Client({ intent, params });
    if (data.ok === false) {
      return {
        ok: false,
        error: data.errorMessage,
        markdown: `**Error:** ${data.errorMessage}`,
      };
    }
    if (data.hash) params.hash = data.hash;
    profile.applyToForm?.({ ...params, intent });
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  const data = await cryptoExecute(ctx, {
    tool: profile.tool,
    operation: mapIntentToOperation(intent, profile),
    params,
  });

  if (data.ok === false) {
    const errPlan = { intent, params };
    return {
      ok: false,
      error: data.error || data.errorMessage || 'Operation failed',
      markdown: formatCryptoResult({ ok: false, errorMessage: data.errorMessage || data.error }, errPlan, profile),
    };
  }

  if (profile.tool === 'ntru') {
    if (data.publicKey) params.publicKey = data.publicKey;
    if (data.privateKey) params.privateKey = data.privateKey;
    if (data.parameterSet) params.parameterSet = data.parameterSet;
    if (data.ciphertext) params.message = data.ciphertext;
    if (data.plaintext) params.message = data.plaintext;
  }
  if (profile.tool === 'ec') {
    if (data.publicKeyAlice) params.publicKeyAlice = data.publicKeyAlice;
    if (data.privateKeyAlice) params.privateKeyAlice = data.privateKeyAlice;
    if (data.publicKeyBob) params.publicKeyBob = data.publicKeyBob;
    if (data.privateKeyBob) params.privateKeyBob = data.privateKeyBob;
    if (data.curve) params.curve = data.curve;
  }
  if (profile.tool === 'ec-sign-verify') {
    if (data.privateKey) params.privateKey = data.privateKey;
    if (data.publicKey) params.publicKey = data.publicKey;
    if (data.curve) params.curve = data.curve;
    if (data.signature) params.signature = data.signature;
  }
  if (profile.tool === 'dsa' || profile.tool === 'elgamal') {
    if (data.publicKey) params.publicKey = data.publicKey;
    if (data.privateKey) params.privateKey = data.privateKey;
    if (data.keySize) params.keySize = data.keySize;
  }
  if (profile.tool === 'elgamal') {
    if (data.ciphertext) params.message = data.ciphertext;
    if (data.plaintext) params.message = data.plaintext;
  }

  profile.applyToForm?.({ ...params, intent });

  if (
    profile.tool === 'elgamal'
    && (plan.intent === 'encrypt' || plan.intent === 'decrypt')
    && data.success !== false
    && typeof window.renderElGamalResult === 'function'
  ) {
    window.renderElGamalResult(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'pbkdf'
    && plan.intent === 'derive'
    && data.success !== false
    && typeof window.renderPbkdfKeyResults === 'function'
  ) {
    window.renderPbkdfKeyResults(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    (profile.tool === 'scrypt')
    && (plan.intent === 'hash' || plan.intent === 'verify')
    && data.success !== false
    && typeof window.renderScryptFromApi === 'function'
  ) {
    window.renderScryptFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'jws-sign'
    && plan.intent === 'sign'
    && data.success !== false
    && typeof window.renderJwsSignFromApi === 'function'
  ) {
    window.renderJwsSignFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'jws-verify'
    && plan.intent === 'verify'
    && data.success !== false
    && typeof window.renderJwsVerifyFromApi === 'function'
  ) {
    if (params.serialized) persistJwsParseToken(params.serialized);
    window.renderJwsVerifyFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'jwk'
    && plan.intent === 'generate'
    && data.success !== false
    && typeof window.renderJwkGenFromApi === 'function'
  ) {
    window.renderJwkGenFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'jwk-convert'
    && plan.intent === 'convert'
    && data.success !== false
    && typeof window.renderJwkConvertFromApi === 'function'
  ) {
    window.renderJwkConvertFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'jws-parse'
    && plan.intent === 'parse'
    && data.success !== false
    && typeof window.renderJwsParseFromApi === 'function'
  ) {
    if (params.serialized) persistJwsParseToken(params.serialized);
    window.renderJwsParseFromApi(data);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'htpasswd'
    && (plan.intent === 'generate' || plan.intent === 'verify')
    && data.success !== false
    && typeof window.renderHtpasswdFromApi === 'function'
  ) {
    const view = { ...data };
    if (!view.username && params.username) view.username = params.username;
    if (plan.intent === 'generate') {
      view.htpasswdEntries = pickHtpasswdEntries(data, params.algorithm || params.algo);
    }
    window.renderHtpasswdFromApi(view);
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  if (
    profile.tool === 'ntru'
    && (plan.intent === 'encrypt' || plan.intent === 'decrypt')
    && data.success !== false
    && typeof window.displayResult === 'function'
  ) {
    window.displayResult({
      success: true,
      operation: plan.intent,
      parameterSet: data.parameterSet || params.parameterSet,
      ciphertext: data.ciphertext,
      plaintext: data.plaintext,
    });
    return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
  }

  triggerFormSubmit(profile, plan);

  return { ok: true, data, markdown: formatCryptoResult(data, plan, profile) };
}

function mapIntentToOperation(intent, profile) {
  if (profile.tool === 'hmac' && intent === 'hmac') return 'hmac';
  if (profile.tool === 'message-digest' && intent === 'hash') return 'hash';
  return intent;
}

function triggerFormSubmit(profile, plan) {
  if (
    (profile.tool === 'ntru' || profile.tool === 'ec' || profile.tool === 'ec-sign-verify'
      || profile.tool === 'dsa' || profile.tool === 'elgamal' || profile.tool === 'argon2')
    && (plan.intent === 'generate_keys' || profile.clientSide)
  ) {
    return;
  }
  if (profile.tool === 'pbkdf' && plan.intent === 'derive') {
    return;
  }
  if (profile.tool === 'scrypt' && (plan.intent === 'hash' || plan.intent === 'verify')) {
    return;
  }
  if (profile.tool === 'htpasswd' && (plan.intent === 'generate' || plan.intent === 'verify')) {
    return;
  }
  if (profile.tool === 'jws-parse' && plan.intent === 'parse') {
    return;
  }
  if (profile.tool === 'jws-sign' && plan.intent === 'sign') {
    return;
  }
  if (profile.tool === 'jws-verify' && plan.intent === 'verify') {
    return;
  }
  if (profile.tool === 'jwk' && plan.intent === 'generate') {
    return;
  }
  if (profile.tool === 'jwk-convert' && plan.intent === 'convert') {
    return;
  }

  const verifyTools = new Set(['bcrypt', 'scrypt', 'htpasswd']);
  const selectors = [
    profile.formSelector,
    plan.intent === 'verify' && verifyTools.has(profile.tool) ? '#verifyForm' : null,
    plan.intent === 'hash' && profile.tool === 'bcrypt' ? '#bcryptForm' : null,
    plan.intent === 'hash' && profile.tool === 'scrypt' ? '#scryptForm' : null,
    plan.intent === 'generate' && profile.tool === 'htpasswd' ? '#htpasswdForm' : null,
    '#form',
    '#hmacForm',
    '#pbkdfForm',
    '#pbeForm',
    '#bcryptForm',
    '#scryptForm',
    '#htpasswdForm',
    '#form1',
  ].filter(Boolean);

  let form = null;
  for (const sel of selectors) {
    form = document.querySelector(sel);
    if (form) break;
  }
  if (!form) return;

  if (typeof window.$ === 'function') {
    try {
      window.$(form).trigger('submit');
      return;
    } catch {
      /* fall through */
    }
  }
  if (typeof form.requestSubmit === 'function') {
    try {
      form.requestSubmit();
      return;
    } catch {
      /* fall through */
    }
  }
  form.dispatchEvent(new Event('submit', { bubbles: true, cancelable: true }));
}

// --- adapter ---

/**
 * @param {object} opts
 * @param {string} opts.toolKey - Registry key (e.g. message-digest, hmac, cipher)
 */
export function createCryptoToolAssistant(opts) {
  const profile = getCryptoToolProfile(opts.toolKey);
  if (!profile) {
    throw new Error(`Unknown crypto tool key: ${opts.toolKey}`);
  }

  const ctx = opts.ctx || '';
  const assistant = new VibeCodingAssistant({
    ctx,
    aiUrl: opts.aiUrl,
    useGateway: opts.useGateway,
    aiRouteMode: opts.aiRouteMode,
    aiRouteByTier: opts.aiRouteByTier,
    userId: opts.userId,
    billing: {
      enabled: opts.billing?.enabled !== false,
      ctx: opts.billing?.ctx || ctx,
      userId: opts.billing?.userId || opts.userId || '',
    },
    toolId: profile.toolId,
    title: profile.title,
    subtitle: profile.subtitle,
    placeholder: placeholderForProfile(profile),
    footerText: 'Runs on this page\'s crypto engine · secrets stay on the form, not in AI chat',
    historyTurns: 8,
    systemPrompt: buildPageSystemPrompt(profile),
    seedContext: () => buildCryptoSeedContext(profile),
    getQuickActions: () => profile.quickActions || [],
    onSend: async (userText, ai) => handleCryptoChatSend(userText, ai, ctx, profile),
  });

  return assistant;
}

async function handleCryptoChatSend(userText, ai, ctx, profile) {
  const pageSnapshot = buildCryptoSeedContext(profile);

  ai.history.push({ role: 'user', content: userText });
  ai._appendBubble('user', userText, { streaming: false });

  if (looksLikeExplainOnly(userText)) {
    removeLastUserTurn(ai);
    return false;
  }

  const thinking = ai._appendBubble('assistant', 'Understanding your request…', { streaming: true });

  let plan;
  try {
    plan = await analyzeCryptoIntent(ai, { profile, pageSnapshot, userText });
  } catch (err) {
    thinking.bubble.remove();
    removeLastUserTurn(ai);
    throw err;
  }
  thinking.bubble.remove();

  if (plan.intent === 'explain') {
    removeLastUserTurn(ai);
    return false;
  }

  if (plan.intent === 'clarify') {
    const msg = plan.clarify_message || 'What would you like to do on this page? You can hash, encrypt, sign, or ask how something works.';
    ai._appendBubble('assistant', msg, { streaming: false });
    return true;
  }

  const merged = mergePlanWithForm(plan, profile, userText);
  const missing = resolveMissingFields(merged, profile);

  if (missing.length) {
    ai._appendBubble('assistant', buildClarifyMessage(merged, missing), { streaming: false });
    return true;
  }

  const work = ai._appendBubble('assistant', 'Running on the page…', { streaming: true });
  try {
    const result = await executeCryptoPlan(ctx, merged, profile, userText);
    work.bubble.remove();
    if (result.explain) {
      removeLastUserTurn(ai);
      return false;
    }
    if (!result.ok) {
      let body = result.markdown || `**Could not complete:** ${result.error || 'Operation failed'}`;
      if (profile.tool === 'cipher') {
        const thinkingExplain = ai._appendBubble('assistant', 'Explaining what went wrong and how decrypt works…', { streaming: true });
        try {
          const llm = await fetchCipherWorkflowExplain(ai, {
            plan: merged,
            outcome: 'error',
            errorText: result.error || '',
          });
          if (llm) body = `${body}\n\n---\n\n${llm}`;
        } catch {
          /* static guide already in body */
        }
        thinkingExplain.bubble.remove();
      }
      ai.history.push({ role: 'assistant', content: body });
      ai._appendBubble('assistant', body, { kind: 'error', streaming: false });
      return true;
    }
    let body = result.markdown;
    if (profile.tool === 'cipher' && (merged.intent === 'encrypt' || merged.intent === 'decrypt')) {
      const thinkingExplain = ai._appendBubble('assistant', 'Adding decrypt steps…', { streaming: true });
      try {
        const llm = await fetchCipherWorkflowExplain(ai, {
          plan: merged,
          outcome: 'success',
          errorText: '',
        });
        if (llm) body = `${body}\n\n---\n\n${llm}`;
      } catch {
        /* static decrypt guide already on success encrypt */
      }
      thinkingExplain.bubble.remove();
    }
    ai.history.push({ role: 'assistant', content: body });
    ai._appendBubble('assistant', body, { streaming: false });
    return true;
  } catch (err) {
    work.bubble.remove();
    const detail = err.data?.error || err.data?.errorMessage || err.message || 'Operation failed';
    ai._appendBubble('assistant', `**Could not complete:** ${detail}`, { kind: 'error' });
    return true;
  }
}
