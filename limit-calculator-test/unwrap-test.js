#!/usr/bin/env node
/**
 * Test suite for `unwrapSemanticLimit()` — the pre-parser that strips
 * `lim_(x->a)` operators, wrapping brackets, and one-sided (^+/^-)
 * markers from MathLive / textbook-style input.
 *
 * Loads the ACTUAL function body from
 *   src/main/webapp/modern/js/limit-calculator.js
 * via a regex-extract + new Function() so tests can never drift from
 * the shipping implementation.  If the extract regex stops matching,
 * that itself is a signal the function was renamed / reorganised —
 * `npm test` will fail loudly instead of silently testing an outdated
 * copy.
 */
'use strict';
const fs = require('fs');
const path = require('path');

// ── Load the function straight out of the source file ─────────────────
const SRC = path.join(
    __dirname, '..', 'src', 'main', 'webapp', 'modern', 'js',
    'limit-calculator.js'
);
const code = fs.readFileSync(SRC, 'utf8');

const m = code.match(/function unwrapSemanticLimit[\s\S]+?^}\s*$/m);
if (!m) {
    console.error('FAIL: could not locate unwrapSemanticLimit in ' + SRC);
    process.exit(1);
}
const unwrap = (new Function('return (' + m[0] + ')'))();
if (typeof unwrap !== 'function') {
    console.error('FAIL: extracted body did not compile to a function');
    process.exit(1);
}

// ── Mocks ──────────────────────────────────────────────────────────────
function mockVarSelect(initial) {
    return {
        value: initial || 'x',
        querySelector(sel) {
            const name = (sel.match(/value="([^"]+)"/) || [])[1];
            if (!name) return null;
            return name.length === 1 || name === 'theta' ? { value: name } : null;
        }
    };
}
function mockInput(initial) { return { value: initial || '' }; }
function mockDirButtons() {
    const btns = [
        { dir: 'left',      classes: new Set() },
        { dir: 'two-sided', classes: new Set(['active']) },
        { dir: 'right',     classes: new Set() }
    ];
    btns.forEach(b => {
        b.getAttribute = (a) => a === 'data-dir' ? b.dir : null;
        b.classList = {
            toggle: (cls, on) => { if (on) b.classes.add(cls); else b.classes.delete(cls); }
        };
    });
    btns.forEach = function (fn) { Array.prototype.forEach.call(this, fn); };
    return btns;
}
function activeDir(btns) {
    const active = Array.prototype.find.call(btns, b => b.classes.has('active'));
    return active ? active.dir : null;
}

// ── Cases ──────────────────────────────────────────────────────────────
const cases = [
    // The canonical example from the user.  Note: inner `(sin(x))` parens
    // are preserved — they wrap only sin(x), not the whole expression, so
    // the balanced-paren strip correctly skips them.  Functionally
    // identical to `sin(x)/x` for nerdamer.
    { name: 'MathLive: lim_(x->0) (sin(x))/x',          in: 'lim_(x->0) (sin(x))/x',         out: '(sin(x))/x', v: 'x', pt: '0',         dir: 'two-sided' },
    { name: 'MathLive: curly subscript variant',        in: 'lim_{x->0} (sin(x))/x',         out: '(sin(x))/x', v: 'x', pt: '0',         dir: 'two-sided' },
    { name: 'MathLive: with [brackets]',                in: 'lim_(x->0) [sin(x)/x]',         out: 'sin(x)/x',   v: 'x', pt: '0',         dir: 'two-sided' },

    // Different variables
    { name: 'lim_(t->1) for t variable',                in: 'lim_(t->1) (t^2 - 1)/(t - 1)',  out: '(t^2 - 1)/(t - 1)', v: 't', pt: '1', dir: 'two-sided' },

    // Infinity (oo → infinity normalisation)
    { name: 'lim_(x->oo) — oo normalised to infinity',  in: 'lim_(x->oo) e^x/x^2',           out: 'e^x/x^2',   v: 'x', pt: 'infinity',  dir: 'two-sided' },
    { name: 'lim_(x->-oo) negative infinity',           in: 'lim_(x->-oo) 1/x',              out: '1/x',       v: 'x', pt: '-infinity', dir: 'two-sided' },
    { name: 'lim with infinity word already',           in: 'lim_(x->infinity) x/(x+1)',     out: 'x/(x+1)',   v: 'x', pt: 'infinity',  dir: 'two-sided' },

    // One-sided (^+ / ^-)
    { name: 'right-sided lim_(x->0^+) 1/x',             in: 'lim_(x->0^+) 1/x',              out: '1/x',       v: 'x', pt: '0',         dir: 'right' },
    { name: 'left-sided lim_(x->0^-) abs(x)/x',         in: 'lim_(x->0^-) abs(x)/x',         out: 'abs(x)/x',  v: 'x', pt: '0',         dir: 'left' },

    // Special points
    { name: 'lim_(x->pi) cos(x)',                       in: 'lim_(x->pi) cos(x)',            out: 'cos(x)',    v: 'x', pt: 'pi',        dir: 'two-sided' },

    // Plain pass-through (no operator)
    { name: 'plain function pass-through',              in: 'sin(x)/x',                      out: 'sin(x)/x',  v: 'x', pt: '',          dir: 'two-sided' },

    // User's existing point wins over expr's
    { name: 'user point=5 beats expr lim_(x->0)',       in: 'lim_(x->0) sin(x)/x',           out: 'sin(x)/x',  v: 'x', pt: '5',         dir: 'two-sided', hintPoint: '5' },

    // Edge cases
    { name: 'empty string',                             in: '',                              out: '',          v: 'x', pt: '',          dir: 'two-sided' },
    { name: 'whitespace only',                          in: '   ',                           out: '   ',       v: 'x', pt: '',          dir: 'two-sided' },
];

// ── Run ───────────────────────────────────────────────────────────────
let pass = 0, fail = 0;
const failed = [];
for (const t of cases) {
    const vs = mockVarSelect('x');
    const pi = mockInput(t.hintPoint || '');
    const db = mockDirButtons();

    let firedDir = null;
    const got = unwrap(t.in, {
        varSelect: vs,
        pointInput: pi,
        dirButtons: db,
        onDirChange: (d) => { firedDir = d; }
    });

    const ok =
        got === t.out &&
        vs.value === t.v &&
        pi.value === t.pt &&
        activeDir(db) === t.dir;

    if (ok) {
        pass++;
        console.log('  ✓ ' + t.name);
    } else {
        fail++;
        failed.push({ name: t.name, in: t.in, got, vs: vs.value, pt: pi.value, dir: activeDir(db), expect: t });
        console.log('  ✗ ' + t.name);
    }
}

console.log(`\n${pass}/${pass + fail} passed`);
if (failed.length) {
    console.log('\nFailures:');
    for (const f of failed) {
        console.log('  · ' + f.name);
        console.log('      input   :', JSON.stringify(f.in));
        console.log('      got     :', JSON.stringify(f.got), `var=${f.vs} pt=${JSON.stringify(f.pt)} dir=${f.dir}`);
        console.log('      expected:', JSON.stringify(f.expect.out), `var=${f.expect.v} pt=${JSON.stringify(f.expect.pt)} dir=${f.expect.dir}`);
    }
    process.exit(1);
}
