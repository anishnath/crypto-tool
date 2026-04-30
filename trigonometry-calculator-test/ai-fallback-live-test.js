#!/usr/bin/env node
/**
 * Live test for the AI fallback path.
 *
 * Hits the AIProxyServlet at /ai with the EXACT payload shape that
 * trig-common.js → callAI() builds, for the cases the CAS layer can't
 * close (greedy-stuck simplifications, multi-step proofs, etc.).
 *
 * Verifies:
 *   1. Servlet returns 200 (not rate-limited / errored)
 *   2. Response contains parseable JSON in message.content
 *   3. JSON has {method, steps:[{title, latex}]} shape our renderer expects
 *   4. Final step is \boxed{...} (per system-prompt rule)
 *
 * Run:  node ai-fallback-live-test.js
 */
const BASE = 'http://localhost:8080/mywebapp2_war_exploded';
const URL  = BASE + '/ai';

const SYSTEM_PROMPT =
    'You are a precalculus tutor. Output ONLY valid JSON — no prose, no markdown fences. ' +
    'Schema: {"method": "<short label, e.g. \'Step-by-step solution\'>", ' +
    '"steps": [{"title": "<rule or action used>", "latex": "<LaTeX of the result of THIS step>"}]}. ' +
    'Rules:\n' +
    '1. Steps must be ordered: original → transformations → boxed final answer.\n' +
    '2. The LAST step\'s latex must wrap the final answer in \\boxed{...}.\n' +
    '3. Every "latex" field is pure LaTeX — no $ delimiters, no \\text wrappers around math.\n' +
    '4. Use named identities for "title" (e.g. "Apply Pythagorean identity", "Convert tan to sin/cos", "Factor difference of squares").\n' +
    '5. For "prove" mode: if the identity is FALSE, return method "Not an identity" with a counterexample step showing LHS(value) ≠ RHS(value).\n' +
    '6. Keep steps tight — between 3 and 6 steps is ideal.';

const MODE_LABELS = {
    'solve_equation':   'Solve the trigonometric equation for x.',
    'solve_inequality': 'Solve the trigonometric inequality for x and express the answer in interval notation.',
    'simplify':         'Simplify the trigonometric expression to its simplest form.',
    'evaluate':         'Evaluate the trigonometric expression to an exact value.',
    'prove':            'Prove (or disprove) the trigonometric identity by transforming one side until it matches the other.'
};

function buildPayload({ expression, mode, variable = 'x', answer = '' }) {
    const goal = MODE_LABELS[mode] || 'Solve this trigonometry problem.';
    let problem = expression;
    if (mode === 'prove' && answer) {
        problem = 'LHS: ' + expression + '\nRHS: ' + answer;
    }
    return {
        messages: [
            { role: 'system', content: SYSTEM_PROMPT },
            { role: 'user',   content: goal + '\n\nProblem:\n' + problem + '\n\nVariable: ' + variable }
        ],
        stream: false
    };
}

// Mirror the extractJsonObject helper in trig-common.js
function extractJsonObject(text) {
    if (!text) return null;
    text = text.replace(/^```(?:json)?\s*/i, '').replace(/\s*```\s*$/, '');
    try { return JSON.parse(text); } catch (_) {}
    const start = text.indexOf('{');
    if (start < 0) return null;
    let depth = 0, inStr = false, esc = false;
    for (let i = start; i < text.length; i++) {
        const ch = text[i];
        if (esc) { esc = false; continue; }
        if (ch === '\\' && inStr) { esc = true; continue; }
        if (ch === '"') { inStr = !inStr; continue; }
        if (inStr) continue;
        if (ch === '{') depth++;
        else if (ch === '}' && --depth === 0) {
            try { return JSON.parse(text.substring(start, i + 1)); } catch (_) { return null; }
        }
    }
    return null;
}

async function callAI(opts) {
    const t0 = Date.now();
    let resp;
    try {
        resp = await fetch(URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(buildPayload(opts)),
            signal: AbortSignal.timeout(60000)   // 60s — LLM can be cold
        });
    } catch (e) {
        return { ok: false, error: e.message, elapsedMs: Date.now() - t0 };
    }
    const elapsedMs = Date.now() - t0;
    const text = await resp.text();
    if (resp.status !== 200) {
        return { ok: false, status: resp.status, body: text.slice(0, 200), elapsedMs };
    }
    let envelope;
    try { envelope = JSON.parse(text); } catch (_) {
        return { ok: false, error: 'top-level JSON parse failed', body: text.slice(0, 200), elapsedMs };
    }
    const content = (envelope.message && envelope.message.content) ||
                    envelope.content || envelope.response || '';
    if (!content) {
        return { ok: false, error: 'no content field', envelope: Object.keys(envelope), elapsedMs };
    }
    const parsed = extractJsonObject(content);
    return { ok: true, parsed, raw: content, elapsedMs };
}

// ─── Greedy-stuck cases (the ~15% CAS can't close on its own) ──────
const CASES = [
    // SIMPLIFY — greedy-stuck via cost monotonicity (TR2 expansion
    // increases trig-fn count temporarily before algebraic collapse)
    { label: 'simp: tan(x) + cot(x)', mode: 'simplify',
      expression: 'tan(x) + cot(x)' },
    { label: 'simp: cos(2x) + sin(2x)*tan(x)', mode: 'simplify',
      expression: 'cos(2*x) + sin(2*x)*tan(x)' },
    { label: 'simp: (tan(x) - sin(x))/(tan(x) + sin(x))', mode: 'simplify',
      expression: '(tan(x) - sin(x))/(tan(x) + sin(x))' },

    // PROVE — true identities that need multi-step lookahead
    { label: 'prove: sin(3x) = 3sin(x) - 4sin³(x)', mode: 'prove',
      expression: 'sin(3*x)', answer: '3*sin(x) - 4*sin(x)**3' },
    { label: 'prove: cos(3x) = 4cos³(x) - 3cos(x)', mode: 'prove',
      expression: 'cos(3*x)', answer: '4*cos(x)**3 - 3*cos(x)' },

    // PROVE — false identity (LLM should explain why, not just match RHS)
    { label: 'prove FALSE: cos(x) = 1 - x²/2', mode: 'prove',
      expression: 'cos(x)', answer: '1 - x**2/2' },

    // SOLVE — the kind of equation the regex shortcut misses but
    // SymPy already handles; included as control to verify AI gives
    // a comparable answer when it does fire
    { label: 'solve: sin(x) + sqrt(3)*cos(x) = 1 (auxiliary angle)', mode: 'solve_equation',
      expression: 'sin(x) + sqrt(3)*cos(x) = 1' },
];

// Rate limit is 5 req/min per IP per AIProxyServlet. Pace ourselves.
const PACE_MS = 14000;   // 14s between calls = ~4.3/min

const sleep = (ms) => new Promise(r => setTimeout(r, ms));

(async () => {
    console.log(`\n══ AI fallback live test → ${URL} ══`);
    console.log(`   (pacing ${PACE_MS}ms between calls to respect the 5/min rate limit)\n`);
    let pass = 0, fail = 0;
    for (let i = 0; i < CASES.length; i++) {
        if (i > 0) await sleep(PACE_MS);
        const c = CASES[i];
        let res = await callAI(c);

        // If rate-limited despite pacing, wait the suggested time + a bit
        if (!res.ok && res.status === 429) {
            const wait = 5000;
            console.log(`   …rate-limited, backing off ${wait}ms…`);
            await sleep(wait);
            res = await callAI(c);
        }
        const elapsed = res.elapsedMs.toString().padStart(5);

        if (!res.ok) {
            fail++;
            console.log(`✗  [${elapsed}ms]  ${c.label}`);
            console.log(`           error: ${res.error || 'status ' + res.status}`);
            if (res.body) console.log(`           body: ${res.body}`);
            continue;
        }

        const p = res.parsed;
        if (!p) {
            fail++;
            console.log(`✗  [${elapsed}ms]  ${c.label}`);
            console.log(`           AI returned non-JSON content (preview):`);
            console.log(`           ${res.raw.slice(0, 200).replace(/\n/g, ' ')}`);
            continue;
        }

        const steps = Array.isArray(p.steps) ? p.steps : [];
        const lastBox = steps.length && /\\boxed\{/.test(steps[steps.length - 1].latex || '');
        const ok = steps.length >= 2 && lastBox;
        if (ok) pass++; else fail++;

        console.log(`${ok ? '✓' : '⚠'}  [${elapsed}ms]  ${c.label}`);
        console.log(`           method: ${p.method || '(none)'} | ${steps.length} steps${lastBox ? ' | last is \\boxed' : ' | last NOT \\boxed'}`);
        steps.forEach((s, i) => {
            const tex = (s.latex || '').slice(0, 80);
            console.log(`           ${i + 1}. ${s.title || s.t || '(untitled)'}: ${tex}`);
        });
    }
    console.log(`\n──────────────────`);
    console.log(`${pass}/${CASES.length} produced parseable {method, steps[…\\boxed]} output`);
    console.log(`──────────────────`);
    process.exit(fail ? 1 : 0);
})();
