// End-to-end test for the PGP intent router (pgp-intent-router.js + pgp-redact.js).
//
// Calls the live /ai endpoint with the EXACT message shape that buildRouterMessages
// would send (including the real redactPgpForAi pipeline), and verifies that:
//   1. Common intents (explain, generate_keys, encrypt, sign) classify correctly
//   2. Pasted PGP blocks are stripped before reaching the model
//   3. PGP packet-dump output is redacted from chat history (no Encoded: hex leaks)
//   4. Pending-op + short-reply multi-turn flows preserve intent
//
// Run:
//   AI_URL=http://localhost:8080/mywebapp2_war_exploded/ai node router.test.mjs
//
// Or just:
//   node router.test.mjs   (uses the default URL above)

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROUTER_SRC = path.join(__dirname, 'pgp-intent-router.js');

// Use the real redactor (proves the wire path is covered).
const redact = await import(new URL('./pgp-redact.js', import.meta.url));
const { redactPgpForAi, redactPgpHistoryForAi } = redact;

const ROUTER_PROMPT = fs.readFileSync(ROUTER_SRC, 'utf8')
  .match(/const ROUTER_PROMPT = `([\s\S]*?)`;/)[1];

const AI_URL = process.env.AI_URL || 'http://localhost:8080/mywebapp2_war_exploded/ai';

// --- Mirror of normalizePlan from pgp-intent-router.js ---
const VALID_INTENTS = new Set(['generate_keys','encrypt','decrypt','sign','verify','verify_file','dump','explain','clarify']);
const VALID_KEYSIZES = new Set(['1024','2048','4096']);
const VALID_CIPHERS  = new Set(['AES_256','AES_192','AES_128','TWOFISH','BLOWFISH','CAST5','TRIPLE_DES']);
const VALID_MISSING  = new Set(['identity','message','publicKey','privateKey','passphrase','pgpMessage','signedMaterial','dumpInput','fileBase64']);

function parseLoose(t) {
  const raw = String(t || '').trim();
  const fence = raw.match(/```(?:json)?\s*\n?([\s\S]*?)```/i);
  const cand = fence ? fence[1].trim() : raw;
  const s = cand.indexOf('{'), e = cand.lastIndexOf('}');
  if (s < 0 || e <= s) return null;
  try { return JSON.parse(cand.slice(s, e + 1)); } catch { return null; }
}
function normalizePlan(o) {
  if (!o || typeof o !== 'object') return null;
  const intent = String(o.intent || 'explain').toLowerCase();
  const p = o.params && typeof o.params === 'object' ? o.params : {};
  return {
    intent: VALID_INTENTS.has(intent) ? intent : 'explain',
    use_session_keys: o.use_session_keys === true,
    is_follow_up: o.is_follow_up === true,
    params: {
      identity: String(p.identity || '').trim(),
      passphrase: String(p.passphrase || '').trim(),
      keysize: VALID_KEYSIZES.has(String(p.keysize)) ? String(p.keysize) : '2048',
      cipher: VALID_CIPHERS.has(String(p.cipher)) ? String(p.cipher) : 'AES_256',
      message: String(p.message || '').trim(),
      publicKey: String(p.publicKey || '').trim(),
      privateKey: String(p.privateKey || '').trim(),
      pgpMessage: String(p.pgpMessage || p.encryptedMessage || '').trim(),
      signedMaterial: String(p.signedMaterial || p.signedMessage || '').trim(),
      dumpInput: String(p.dumpInput || p.input || '').trim(),
      fileBase64: String(p.fileBase64 || '').trim(),
      fileName: String(p.fileName || 'signed-file.bin').trim(),
    },
    missing: Array.isArray(o.missing) ? o.missing.map(String).filter((x) => VALID_MISSING.has(x)) : [],
    clarify_message: String(o.clarify_message || '').trim(),
  };
}

function buildContext(snapshot, pendingOp) {
  const parts = [`[PAGE CONTEXT]\n${snapshot || '(empty)'}`];
  if (pendingOp?.intent && pendingOp.missing?.length) {
    parts.push(
      `[PENDING OPERATION]\nintent: ${pendingOp.intent}\n`
      + `still_need: ${pendingOp.missing.join(', ')}\n`
      + `Latest user message likely supplies the missing field. Keep intent "${pendingOp.intent}".`,
    );
  }
  return parts.join('\n\n');
}

function trim(s, max = 900) {
  const t = redactPgpForAi(s);
  return t.length > max ? `${t.slice(0, max)}…` : t;
}

// EXACT mirror of buildRouterMessages from pgp-intent-router.js
function buildMessages(context, history, userText) {
  const msgs = [{ role: 'system', content: ROUTER_PROMPT }];
  const safe = redactPgpForAi(context);
  if (safe) {
    msgs.push({ role: 'user', content: safe });
    msgs.push({ role: 'assistant', content: 'Understood. I will use page context and pending operation when routing.' });
  }
  const turns = redactPgpHistoryForAi(history.slice(-10));
  for (const t of turns) {
    msgs.push({ role: t.role === 'assistant' ? 'assistant' : 'user', content: trim(t.content) });
  }
  msgs.push({ role: 'user', content: redactPgpForAi(String(userText || '')) });
  return msgs;
}

async function callRouter(messages) {
  const t0 = Date.now();
  const res = await fetch(AI_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ messages, stream: false }),
  });
  const data = await res.json().catch(() => ({}));
  const raw = data?.message?.content || data?.content || '';
  return { raw, plan: normalizePlan(parseLoose(raw)), elapsed: Date.now() - t0, model: data?.model };
}

// --- Fixtures ---
const SESSION_CTX = `Tool mode: encrypt

[SESSION KEYS]
status: available
identity: me@example.com
has_public_key: yes
has_private_key: yes
has_passphrase: yes
instruction: Set use_session_keys true when user wants these keys.`;

const NO_SESSION_CTX = 'Tool mode: encrypt\n\n[SESSION KEYS]\nstatus: none';

const PASTED_PUBKEY = `-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
=Qteg
-----END PGP PUBLIC KEY BLOCK-----`;

const DUMP_OUTPUT_TURN = `PGP packet dump (RFC 4880 structure):

**Decoded packets**

\`\`\`
Key ID: 9824bde2e0c3c7d9
\t Algorithm: RSA_GENERAL
\t Fingerprint: a8da5fead1a625d1cb47429b9824bde2e0c3c7d9
\t Encoded: 988d045a238c790104008982110527490e7879efa69e400db23caf666d90b02d6c188044a66c896e1db15ae96e27f2954c8512a9b90b384ab808e225cc6d1f86eaee51604cdbe00d6b3ab98e4c4bad89875f803003643a8ef777c44f01d6e563a93d1310ac99b660707ac12cc14c5bfaf3b054b756297a5cc925ed2108682960145731bb7b9b846b0c970011010001b405616e697368889c04100102000605025a238c79000a09109824bde2e0c3c7d9477b03ff52db129379728f91a71f2a131d9333fac505a4595a9fb6a0a877faa55d8f81d6fd38c0956ae33097d6e33d8f47487420fdade04d0e6a36af6dc62236e05b28d90dc047a5dc564db04314baa6b27d8a63e2d67a576ab0b066412058b5d62ee40b1e8c515877fda2552a796ecf9304252752bd21bf39a424efc75e8337b43042ff
\t Creation Time: Sun Dec 03 11:02:41 IST 2017
\t Bit Strength: 1024
\`\`\``;

const tests = [
  {
    name: 'T1: explain question',
    userText: 'what is PGP?',
    history: [], pageSnapshot: NO_SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'explain',
  },
  {
    name: 'T2: generate keys with identity',
    userText: 'gimme keys for alice@corp.com',
    history: [], pageSnapshot: NO_SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'generate_keys' && /alice@corp\.com/i.test(p.params.identity),
  },
  {
    name: 'T3: encrypt after keygen — should use session keys',
    userText: 'encrypt hello with my public key',
    history: [
      { role: 'user', content: 'gimme keys for me@example.com' },
      { role: 'assistant', content: 'Generated RSA-2048 key pair for me@example.com.' },
    ],
    pageSnapshot: SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'encrypt' && p.use_session_keys === true,
  },
  {
    name: 'T4: pasted public key — wire-level redaction',
    userText: `please encrypt "ping" with this key:\n${PASTED_PUBKEY}`,
    history: [], pageSnapshot: NO_SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'encrypt' && !/BEGIN PGP/.test(p.params.publicKey),
    extraCheck: (messages) => {
      const userMsg = messages[messages.length - 1].content;
      return !/-----BEGIN PGP/.test(userMsg);  // redactor must have stripped the block
    },
  },
  {
    name: 'T5: short follow-up after sign request — keep sign intent',
    userText: 'hello world',
    history: [
      { role: 'user', content: 'sign a message with my key' },
      { role: 'assistant', content: 'What message would you like signed?' },
    ],
    pageSnapshot: SESSION_CTX,
    pendingOp: { intent: 'sign', missing: ['message'], params: {} },
    expect: (p) => p.intent === 'sign' && p.params.message === 'hello world',
  },
  {
    name: 'T6: ambiguous one-word reply, no pending op',
    userText: 'help',
    history: [], pageSnapshot: NO_SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'clarify' || p.intent === 'explain',
  },
  {
    name: 'T7: after dump output — Encoded: hex must not leak to model',
    userText: 'encrypt hello with my public key',
    history: [
      { role: 'user', content: 'Dump and analyze my PGP public key.' },
      { role: 'assistant', content: DUMP_OUTPUT_TURN },
    ],
    pageSnapshot: SESSION_CTX, pendingOp: null,
    expect: (p) => p.intent === 'encrypt',
    extraCheck: (messages) => {
      const all = messages.map((m) => m.content).join('\n');
      // Signature substring from the dump's Encoded: line
      return !/988d045a238c790104008982110527/.test(all);
    },
  },
];

console.log('Testing PGP intent router (with real redactor) against', AI_URL);
console.log('Scenarios:', tests.length, '\n');

let pass = 0, fail = 0;
for (const t of tests) {
  const context = buildContext(t.pageSnapshot, t.pendingOp);
  const messages = buildMessages(context, t.history, t.userText);
  try {
    const { raw, plan, elapsed, model } = await callRouter(messages);
    const safePlan = plan || { intent: 'explain', use_session_keys: false, is_follow_up: false, params: {}, missing: [], clarify_message: '' };
    const planOk = t.expect(safePlan);
    const extraOk = t.extraCheck ? t.extraCheck(messages) : true;
    const ok = planOk && extraOk;
    console.log(`${ok ? '✓ PASS' : '✗ FAIL'} ${t.name}  (${elapsed}ms${model ? `, ${model}` : ''})`);
    console.log(`  → intent=${safePlan.intent} session=${safePlan.use_session_keys} follow_up=${safePlan.is_follow_up} missing=[${safePlan.missing.join(',')}]`);
    if (safePlan.params.message)   console.log(`  → message="${safePlan.params.message.slice(0, 60)}"`);
    if (safePlan.params.identity)  console.log(`  → identity="${safePlan.params.identity}"`);
    if (safePlan.params.publicKey) console.log(`  → publicKey len=${safePlan.params.publicKey.length} starts="${safePlan.params.publicKey.slice(0, 40)}..."`);
    if (t.extraCheck) console.log(`  → wire-redaction check: ${extraOk ? 'OK (no raw bytes in any message)' : 'FAIL — raw bytes leaked!'}`);
    if (!ok && !plan) console.log(`  NOTE: empty/non-JSON model reply — production fallback would yield intent=explain. RAW: ${raw.slice(0, 200) || '<empty>'}`);
    console.log('');
    ok ? pass++ : fail++;
  } catch (e) {
    fail++;
    console.log(`✗ ERROR ${t.name}: ${e.message}\n`);
  }
  // Avoid hammering the model — small spacing between calls.
  await new Promise((r) => setTimeout(r, 1500));
}

console.log(`Result: ${pass}/${tests.length} passed, ${fail} failed.`);
process.exit(fail === 0 ? 0 : 1);
