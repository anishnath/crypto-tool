#!/usr/bin/env node
/**
 * MIT Integration Bee 2026 (qualifying PDF) — ENTRY SAFETY ONLY.
 *
 * Pass = normalizeExpr + nerdamer PARSE succeeds (preview / integrate step can run).
 * Does NOT assert antiderivatives or definite values.
 *
 * Run: node mit-bee-entry-safety-test.js
 */
'use strict';

const nerdamer = require('nerdamer');
require('nerdamer/Algebra.js');

const Core = require('./require-core');
const normalizeExpr = Core.normalizeExpr;

/**
 * ui: type this in "Function f(x)" (indefinite mode) unless notes say definite / sympy style.
 * enterable: false = not reasonably representable as one calculator line (PDF structure).
 */
const CASES = [
    { id: 1, ui: 'sin^2025(x)*cos^2026(x)', note: 'PDF: sin^2025·cos^2026 with explicit *' },
    { id: '1-chain', ui: 'sin^2025(x)cos^2026(x)', note: 'Same as PDF, no * between factors (normalize fixes preview)' },
    { id: 2, ui: 'e^(2026*e^x+x)', note: 'PDF: e^(2026e^x+x)' },
    { id: 3, ui: 'mod(floor(x)/3,1)', note: 'PDF: fractional part {⌊x⌋/3}; use definite 0..2026 in UI' },
    { id: 4, enterable: false, reason: '2026 nested |x+…| terms — not one finite input string' },
    { id: 5, ui: '1/(sqrt(x+1)-sqrt(x-1))', note: 'Rationalize-type; domain x≥1' },
    { id: 6, ui: 'sqrt(1+cosh(x))', note: 'PDF: √(1+cosh x)' },
    { id: '7a', ui: '2^log(x)/x^2', note: 'PDF: 2^log x / x² interpretation' },
    { id: '7b', ui: '2*log(x)/x^2', note: 'Alternative: 2 log x / x²' },
    { id: 8, enterable: false, reason: 'Σ x^n/n! from n=2 — use Sum() in CAS; no single integrand token in UI' },
    { id: 9, ui: 'x^2*sin(x)', note: 'PDF: x² sin x' },
    { id: 10, ui: '(x-1)^2/(2*e^x+x^2+1)', note: 'PDF: (x-1)²/(2e^x+x²+1)' },
    { id: 11, ui: 'max(0,sqrt(1-x^2)-1/2)', note: 'Definite -1..1; max() depends on nerdamer build' },
    { id: 12, enterable: false, reason: 'Infinite nested √(x²+x+…) — no closed finite string' },
    { id: 13, ui: 'cos(x)^5-10*cos(x)^3*sin(x)^2+5*cos(x)*sin(x)^4', note: 'PDF trig polynomial' },
    { id: 14, ui: 'atan(sqrt(x))', note: 'PDF: arctan(√x)' },
    { id: 15, enterable: false, reason: 'Long floor/ceiling + fractional parts (6 terms) — typeable but impractical / error-prone' },
    { id: 16, ui: 'sqrt(cos(x)*cot(x)*csc(x)/(sin(x)*tan(x)*sec(x)))', note: 'PDF: big radical of trig ratio' },
    { id: 17, ui: 'e^(-x^2)/(1+e^(2*x))', note: 'Definite -∞..∞; bounds oo / -oo in UI' },
    { id: 18, ui: 'sin(x)^2/x^2-sin(2*x)/x', note: 'PDF: sin²x/x² − sin(2x)/x' },
    { id: 19, ui: 'log(log(x))*log(log(log(x)))/(x*log(x))', note: 'Triple log chain' },
    { id: 20, ui: 'cos(pi/2*cos(pi/2*cos(x)^2)^2)^2', note: 'PDF nested cos²; definite 0..pi/2' }
];

let failed = 0;
let passed = 0;
let skipped = 0;

function tryParse(ui) {
    const n = normalizeExpr(ui);
    nerdamer(n); // parse only
    return n;
}

console.log('MIT Bee 2026 PDF — entry safety (parse only, not solve)\n');

for (const c of CASES) {
    if (c.enterable === false) {
        skipped++;
        console.log('  [SKIP] #' + c.id + ' — ' + (c.reason || 'N/A'));
        continue;
    }
    if (!c.ui) {
        skipped++;
        console.log('  [SKIP] #' + c.id + ' — no ui string');
        continue;
    }
    try {
        const norm = tryParse(c.ui);
        passed++;
        console.log('  ✓ #' + c.id + ' parse OK  →  ' + norm.substring(0, 72) + (norm.length > 72 ? '…' : ''));
    } catch (e) {
        failed++;
        console.log('  ✗ #' + c.id + ' FAIL: ' + e.message);
        console.log('      ui: ' + c.ui);
    }
}

console.log('\n---');
console.log('Entered & parsed:', passed, '| Skipped (not one-line / not practical):', skipped, '| Failed:', failed);
console.log('---');
console.log('This test does NOT check integration results, timeouts, or SymPy fallback success.\n');

process.exit(failed > 0 ? 1 : 0);
