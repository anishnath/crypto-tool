#!/usr/bin/env node
/**
 * Test suite for `unwrapSemanticDerivative()` — the pre-parser that strips
 * d/dx operators, wrapping brackets, and |_{x=V} evaluation bars from
 * MathLive / textbook-style input.
 *
 * Loads the ACTUAL function body from
 *   src/main/webapp/modern/js/derivative-calculator.js
 * via a regex-extract + eval so tests can never drift from the shipping
 * implementation.  If the extract regex stops matching, that itself is a
 * signal the function was renamed / reorganised — `node unwrap-test.js`
 * will fail loudly instead of silently testing an outdated copy.
 */
'use strict';
const fs = require('fs');
const path = require('path');

// ── Load the function straight out of the source file ─────────────────
const SRC = path.join(
    __dirname, '..', 'src', 'main', 'webapp', 'modern', 'js',
    'derivative-calculator.js'
);
const code = fs.readFileSync(SRC, 'utf8');

// Match `function unwrapSemanticDerivative(...) { ... }` greedily to the
// balanced closing brace at column 0.  If this stops working, edit here —
// the test's job is to catch THAT mismatch, but only once the function
// still lives somewhere.
const m = code.match(/function unwrapSemanticDerivative[\s\S]+?^}\s*$/m);
if (!m) {
    console.error('FAIL: could not locate unwrapSemanticDerivative in ' + SRC);
    process.exit(1);
}
// Compile the extracted function body via `new Function` so it works in
// strict mode.  Wrapping as `return (function foo() { ... })` evaluates
// the function expression and hands it back as the test's callable.
const unwrap = (new Function('return (' + m[0] + ')'))();
if (typeof unwrap !== 'function') {
    console.error('FAIL: extracted body did not compile to a function');
    process.exit(1);
}

// ── Mocks for DOM side-effect targets ─────────────────────────────────
function mockVarSelect(initial) {
    return {
        value: initial || 'x',
        querySelector(sel) {
            const name = (sel.match(/value="([^"]+)"/) || [])[1];
            if (!name) return null;
            // Every one-letter var + 'theta' is allowed (matches the real
            // <select id="dc-var"> option set).
            return name.length === 1 || name === 'theta' ? { value: name } : null;
        }
    };
}
function mockInput(initial) { return { value: initial || '' }; }

// ── Case table ────────────────────────────────────────────────────────
const cases = [
    // --- The user's actual input (MathLive ascii-math variants) ---
    { name: 'MathLive: (d)/(dx) with * + |_(x=2)',    in: '(d)/(dx)*3sin(x)|_(x=2)',   out: '3sin(x)',   v: 'x', eval: '2'  },
    { name: 'MathLive: no * after operator',          in: '(d)/(dx)3sin(x)|_(x=2)',    out: '3sin(x)',   v: 'x', eval: '2'  },
    { name: 'MathLive: curly subscript on bar',       in: '(d)/(dx)3sin(x)|_{x=2}',    out: '3sin(x)',   v: 'x', eval: '2'  },

    // --- Textbook notations ---
    { name: 'plain d/dx[f(x)] + |_{x=2}',             in: 'd/dx[3*sin(x)]|_{x=2}',     out: '3*sin(x)',  v: 'x', eval: '2'  },
    { name: 'plain d/dx(f(x)) + |_{x=1}',             in: 'd/dx(x^2 + 1)|_{x=1}',      out: 'x^2 + 1',   v: 'x', eval: '1'  },
    { name: 'alt variable: d/dt[...] + |_{t=pi}',     in: 'd/dt[t*cos(t)]|_{t=pi}',    out: 't*cos(t)',  v: 't', eval: 'pi' },

    // --- Higher-order operator ---
    { name: '2nd derivative operator (d^2)/(dx^2)',   in: '(d^2)/(dx^2)[x^4]',         out: 'x^4',       v: 'x', eval: ''   },

    // --- Eval-point flavours ---
    { name: 'eval at pi/4',                           in: 'd/dx[sin(x)]|_{x=pi/4}',    out: 'sin(x)',    v: 'x', eval: 'pi/4' },
    { name: 'eval at negative',                       in: 'd/dx[x^3]|_{x=-2}',         out: 'x^3',       v: 'x', eval: '-2' },

    // --- Pass-through (no operator, no bar) ---
    { name: 'plain function pass-through',            in: '3*sin(x)',                  out: '3*sin(x)',  v: 'x', eval: ''   },

    // --- User's existing eval-point wins over expr's |_{...} ---
    { name: 'user eval=3 beats expr |_{x=2}',         in: 'd/dx[x^2]|_{x=2}',          out: 'x^2',       v: 'x', eval: '3',
      hintEval: '3' },

    // --- Edge cases ---
    { name: 'just d/dx — no body, returns raw',       in: 'd/dx',                      out: 'd/dx',      v: 'x', eval: ''   },
    { name: 'empty string',                           in: '',                          out: '',          v: 'x', eval: ''   },
    { name: 'whitespace only',                        in: '   ',                       out: '   ',       v: 'x', eval: ''   },
];

// ── Run ───────────────────────────────────────────────────────────────
let pass = 0, fail = 0;
const failed = [];
for (const t of cases) {
    const vs = mockVarSelect('x');
    const ei = mockInput(t.hintEval || '');
    const got = unwrap(t.in, { varSelect: vs, evalInput: ei });

    const ok =
        got === t.out &&
        vs.value === t.v &&
        ei.value === t.eval;

    if (ok) {
        pass++;
        console.log('  ✓ ' + t.name);
    } else {
        fail++;
        failed.push({ name: t.name, in: t.in, got, v: vs.value, eval: ei.value, expect: t });
        console.log('  ✗ ' + t.name);
    }
}

console.log(`\n${pass}/${pass + fail} passed`);
if (failed.length) {
    console.log('\nFailures:');
    for (const f of failed) {
        console.log('  · ' + f.name);
        console.log('      input   :', JSON.stringify(f.in));
        console.log('      got     :', JSON.stringify(f.got), `var=${f.v} eval=${JSON.stringify(f.eval)}`);
        console.log('      expected:', JSON.stringify(f.expect.out), `var=${f.expect.v} eval=${JSON.stringify(f.expect.eval)}`);
    }
    process.exit(1);
}
