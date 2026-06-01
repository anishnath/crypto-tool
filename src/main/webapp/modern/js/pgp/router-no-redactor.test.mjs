// Negative/regression test — proves WHY redactPgpForAi is required on the wire.
//
// This suite bypasses pgp-redact.js and sends raw user text + history straight to
// the router. The expected behavior is:
//   - Pasted PGP blocks WILL be echoed into params.publicKey by the model.
//   - Dump output's Encoded: hex WILL appear in the messages payload.
// If T4/T7 here ever pass, it means redaction stopped being necessary at the
// prompt layer (router prompt now reliably refuses to copy blocks) — at which
// point the wire-level redactor could be relaxed. Today, they should FAIL,
// confirming the wire-level redactor is load-bearing.
//
// Run:
//   node router-no-redactor.test.mjs
//
// Keep this file alongside router.test.mjs — together they document the
// "defense in depth" intent: redactor is primary, prompt rule is secondary.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROUTER_SRC = path.join(__dirname, 'pgp-intent-router.js');
const ROUTER_PROMPT = fs.readFileSync(ROUTER_SRC, 'utf8')
  .match(/const ROUTER_PROMPT = `([\s\S]*?)`;/)[1];

const AI_URL = process.env.AI_URL || 'http://localhost:8080/mywebapp2_war_exploded/ai';

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
      message: String(p.message || '').trim(),
      publicKey: String(p.publicKey || '').trim(),
      privateKey: String(p.privateKey || '').trim(),
      pgpMessage: String(p.pgpMessage || '').trim(),
    },
    missing: Array.isArray(o.missing) ? o.missing.map(String).filter((x) => VALID_MISSING.has(x)) : [],
    clarify_message: String(o.clarify_message || '').trim(),
  };
}

// NO redactor — raw text in, raw text out.
function buildMessages(context, history, userText) {
  const msgs = [{ role: 'system', content: ROUTER_PROMPT }];
  if (context) {
    msgs.push({ role: 'user', content: context });
    msgs.push({ role: 'assistant', content: 'Understood. I will use page context and pending operation when routing.' });
  }
  for (const t of history) msgs.push({ role: t.role === 'assistant' ? 'assistant' : 'user', content: t.content });
  msgs.push({ role: 'user', content: String(userText || '') });
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

const PASTED_PUBKEY = `-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
=Qteg
-----END PGP PUBLIC KEY BLOCK-----`;

const DUMP_OUTPUT_TURN = `PGP packet dump (RFC 4880 structure):

\`\`\`
Key ID: 9824bde2e0c3c7d9
\t Encoded: 988d045a238c790104008982110527490e7879efa69e400db23caf666d90b02d6c188044a66c896e1db15ae96e27f2954c8512a9b90b384ab808e225cc6d1f86eaee51604cdbe00d6b3ab98e4c4bad89875f803003643a8ef777c44f01d6e563a93d1310ac99b660707ac12cc14c5bfaf3b054b756297a5cc925ed2108682960145731bb7b9b846b0c970011010001b405616e697368889c04100102000605025a238c79000a09109824bde2e0c3c7d9477b03ff
\`\`\``;

const SESSION_CTX = 'Tool mode: encrypt\n\n[SESSION KEYS]\nstatus: available\nidentity: me@example.com';

// These tests assert what happens WITHOUT the redactor — passing means leakage.
// EXPECTED outcome of this file: T4 and T7 FAIL (proving redaction is required).
const tests = [
  {
    name: 'NEG-T4: WITHOUT redactor — model likely copies pasted PGP block into params',
    userText: `please encrypt "ping" with this key:\n${PASTED_PUBKEY}`,
    history: [], pageSnapshot: 'Tool mode: encrypt\n\n[SESSION KEYS]\nstatus: none',
    // PASS means model obeyed the prompt rule on its own. FAIL means leakage.
    expect: (p) => !/BEGIN PGP/.test(p.publicKey || ''),
  },
  {
    name: 'NEG-T7: WITHOUT redactor — Encoded: hex reaches model in history',
    userText: 'encrypt hello with my public key',
    history: [
      { role: 'user', content: 'Dump my public key' },
      { role: 'assistant', content: DUMP_OUTPUT_TURN },
    ],
    pageSnapshot: SESSION_CTX,
    expect: (_p, messages) => {
      const all = messages.map((m) => m.content).join('\n');
      return !/988d045a238c790104008982110527/.test(all);
    },
  },
];

console.log('Negative test: router WITHOUT redactor — expecting leakage');
console.log('Endpoint:', AI_URL, '\n');

let pass = 0, fail = 0;
for (const t of tests) {
  const messages = buildMessages(t.pageSnapshot, t.history, t.userText);
  try {
    const { raw, plan, elapsed } = await callRouter(messages);
    const safePlan = plan?.params || plan || {};
    const ok = t.expect(safePlan, messages);
    console.log(`${ok ? '✓ PASS (model self-defended — promote prompt rule)' : '✗ FAIL (leakage — wire-level redactor is required)'} ${t.name}  (${elapsed}ms)`);
    if (safePlan.publicKey)  console.log(`  → publicKey len=${safePlan.publicKey.length}`);
    console.log('');
    ok ? pass++ : fail++;
  } catch (e) {
    fail++;
    console.log(`✗ ERROR ${t.name}: ${e.message}\n`);
  }
  await new Promise((r) => setTimeout(r, 1500));
}

console.log(`Result: ${pass}/${tests.length} passed.`);
console.log(`Reminder: in this file, FAIL is the normal/safe outcome — it documents WHY redactPgpForAi must run on the wire.`);
