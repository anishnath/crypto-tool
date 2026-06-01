/**
 * Stage 1: SSH intent classifier.
 *
 * Single-purpose call that returns a strict JSON plan — no prose, no explanation.
 * The adapter routes on the result:
 *   • intent="generate"  → apply the action immediately, no second LLM call
 *   • intent="explain"   → fall through to the default streaming chat with a
 *                          clean prompt that has zero action contract
 *
 * Modeled on pgp-intent-router.js.
 */
import { chat } from '../llm-client.js';

const ROUTER_PROMPT = `You are the intent router for an in-browser SSH key generator.
Read the user message and return ONE JSON object — no prose, no markdown fences, no commentary.

Shape:
{"intent": "generate" | "explain",
 "algorithm": "ED25519|RSA|ECDSA|DSA",   // only when intent=generate
 "keysize": "256|1024|2048|4096|384|521",// only when intent=generate
 "comment": "string",                    // optional
 "ppk": true|false}                      // only when intent=generate

Rules:
- intent="generate" ONLY when ALL of:
    (a) explicit action verb: generate / create / make / produce / new
    (b) noun is "key", "keypair", or "SSH key"
    (c) clear intent to produce fresh key material right now
- intent="explain" for everything else: comparisons, config questions, troubleshooting,
  "how do I add to GitHub", "give me sshd_config", "what's the command for X", etc.
- ppk=true ONLY when the user message mentions PuTTY, WinSCP, Pageant, Windows, or .ppk.
- Default algorithm if unspecified: "ED25519".
- Default keysize per algorithm: ED25519=256, RSA=2048, ECDSA=256, DSA=1024.
- If unsure, default to intent="explain". Better to over-explain than over-generate.

Examples:
"Generate an ED25519 key for me@laptop"        → {"intent":"generate","algorithm":"ED25519","keysize":"256","comment":"me@laptop","ppk":false}
"Make me an RSA 4096 key for PuTTY"            → {"intent":"generate","algorithm":"RSA","keysize":"4096","ppk":true}
"new key please"                                → {"intent":"generate","algorithm":"ED25519","keysize":"256","ppk":false}
"Compare ED25519 vs RSA"                        → {"intent":"explain"}
"What's the command to copy my key to a server"→ {"intent":"explain"}
"Give me a hardened sshd_config"                → {"intent":"explain"}
"How do I add my key to GitHub"                 → {"intent":"explain"}
"show me ~/.ssh/config for multi-account"       → {"intent":"explain"}
"hello"                                         → {"intent":"explain"}`;

const VALID_INTENTS = new Set(['generate', 'explain']);
const VALID_ALGOS = new Set(['ED25519', 'RSA', 'ECDSA', 'DSA']);
const VALID_KEYSIZES = new Set(['256', '384', '521', '1024', '2048', '4096']);
const DEFAULT_KEYSIZE = { ED25519: '256', RSA: '2048', ECDSA: '256', DSA: '1024' };

function parseJsonLoose(text) {
  const raw = String(text || '').trim();
  const fence = raw.match(/```(?:json)?\s*\n?([\s\S]*?)```/i);
  const candidate = fence ? fence[1].trim() : raw;
  const start = candidate.indexOf('{');
  const end = candidate.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try { return JSON.parse(candidate.slice(start, end + 1)); } catch { return null; }
}

function normalizePlan(obj) {
  if (!obj || typeof obj !== 'object') return { intent: 'explain' };
  const intent = String(obj.intent || 'explain').toLowerCase();
  if (!VALID_INTENTS.has(intent)) return { intent: 'explain' };
  if (intent === 'explain') return { intent: 'explain' };

  const algo = String(obj.algorithm || 'ED25519').toUpperCase();
  if (!VALID_ALGOS.has(algo)) return { intent: 'explain' };  // unknown algo → don't auto-execute

  let keysize = String(obj.keysize || DEFAULT_KEYSIZE[algo]);
  if (!VALID_KEYSIZES.has(keysize)) keysize = DEFAULT_KEYSIZE[algo];

  return {
    intent: 'generate',
    algorithm: algo,
    keysize,
    comment: String(obj.comment || '').trim(),
    ppk: obj.ppk === true,
  };
}

/**
 * Classify a user message into a strict plan.
 * Always returns a valid plan; on any failure (network / parse / unknown intent),
 * returns {intent: "explain"} so the caller streams a natural reply.
 */
export async function classifySshIntent(assistant, userText) {
  const messages = [
    { role: 'system', content: ROUTER_PROMPT },
    { role: 'user', content: String(userText || '').trim() },
  ];
  try {
    const reply = await chat(
      assistant.aiUrl,
      { messages },
      {
        useGateway: assistant.useGateway,
        userId: assistant.userId,
        toolId: assistant.toolId,
      },
    );
    return normalizePlan(parseJsonLoose(reply));
  } catch (err) {
    console.warn('[ssh-ai] intent router failed, defaulting to explain:', err?.message || err);
    return { intent: 'explain' };
  }
}
