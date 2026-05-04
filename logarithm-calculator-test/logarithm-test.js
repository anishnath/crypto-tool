/**
 * logarithm-test.js — JS unit tests for logarithm-calculator.jsp.
 *
 * Run:  node logarithm-test.js
 *       (or `npm test` from this directory)
 *
 * Covers:
 *   1. normalizeInput() — converts user notation to nerdamer-friendly form
 *      (ln→log, log_2→log2, log2(x)→(log(x)/log(2)), logb(x,b)→…)
 *   2. _filterExtraneousJs() — JS-side domain filter that rejects roots
 *      where any log argument is ≤ 0
 *   3. _buildSympyCode() — templates the embedded Python source with
 *      mode/var/raw substitutions
 *
 * The SymPy power-engine itself (expand_log / logcombine / solve with
 * domain filter) is exercised by sympy-cases-test.py which exec's the
 * same template against the local Python sympy install.
 */

'use strict';

const path = require('path');
const fs = require('fs');
const { loadCore } = require('./require-core.js');

// Lightweight assertion helper — exits with non-zero on first failure
// so CI can detect.  Reports passed and failed cases.
let _pass = 0, _fail = 0;
const failures = [];
function assertEqual(actual, expected, label) {
    if (actual === expected) {
        _pass++;
        return;
    }
    _fail++;
    failures.push({ label, actual, expected });
}
function assertContains(actual, needle, label) {
    if (typeof actual === 'string' && actual.indexOf(needle) !== -1) {
        _pass++;
        return;
    }
    _fail++;
    failures.push({ label, actual, expected: 'contains: ' + needle });
}
function assertDeepEqual(actual, expected, label) {
    const a = JSON.stringify(actual);
    const e = JSON.stringify(expected);
    if (a === e) { _pass++; return; }
    _fail++;
    failures.push({ label, actual: a, expected: e });
}

const win = loadCore();
const T = win.LogarithmCalculator && win.LogarithmCalculator.__test;
if (!T) {
    console.error('FATAL: __test exports not present — _LC_TEST_HOOK injection failed.');
    process.exit(2);
}

console.log('\n═══ normalizeInput ═══');

// ln(x) → log(x) (nerdamer convention is natural log in the bare `log`)
assertEqual(T.normalizeInput('ln(x)'), 'log(x)',
    'ln(x) → log(x)');
assertEqual(T.normalizeInput('ln(x+1) + ln(x-1)'), 'log(x+1) + log(x-1)',
    'ln(...) + ln(...)');

// log_2(x) → log2(x) → (log(x)/log(2))
assertEqual(T.normalizeInput('log_2(x)'), '(log(x)/log(2))',
    'log_2(x) → (log(x)/log(2))');
assertEqual(T.normalizeInput('log_10(x)'), '(log(x)/log(10))',
    'log_10(x) → (log(x)/log(10))');

// log2/log3/log10 → change of base
assertEqual(T.normalizeInput('log2(x)'), '(log(x)/log(2))',
    'log2(x) → change of base');
assertEqual(T.normalizeInput('log10(1000)'), '(log(1000)/log(10))',
    'log10(1000) → change of base');

// logb(x, b) → (log(x)/log(b))
assertEqual(T.normalizeInput('logb(x, 5)'), '(log(x)/log(5))',
    'logb(x, 5)');
assertEqual(T.normalizeInput('logb(2*x, 3)'), '(log(2*x)/log(3))',
    'logb(2*x, 3)');

// Nested log_b inside another log_b
assertEqual(T.normalizeInput('log2(log3(x))'),
    '(log((log(x)/log(3)))/log(2))',
    'nested change-of-base');

// Equation form preserved
assertEqual(T.normalizeInput('log2(x) = 5'), '(log(x)/log(2)) = 5',
    'equation form preserved');

// Whitespace stripping
assertEqual(T.normalizeInput('  log2(x)  '), '(log(x)/log(2))',
    'leading/trailing whitespace stripped');

// Empty / undefined input
assertEqual(T.normalizeInput(''), '',
    'empty string returns empty');
assertEqual(T.normalizeInput('   '), '   ',
    'whitespace-only string passes through (matches legacy guard)');

console.log('   ' + (_fail === 0 ? '✓' : '✗') + '  '
    + _pass + ' passed, ' + _fail + ' failed (running tally)');

const passAfterNormalize = _pass, failAfterNormalize = _fail;

console.log('\n═══ findMatchingParen ═══');

assertEqual(T.findMatchingParen('(abc)', 1), 4,
    'simple paren pair');
assertEqual(T.findMatchingParen('(a(b)c)', 1), 6,
    'nested paren');
assertEqual(T.findMatchingParen('((a))', 1), 4,
    'nested empty');
assertEqual(T.findMatchingParen('(a,b,(c,d))', 1), 10,
    'comma-separated with nested group');

console.log('   ' + (_pass - passAfterNormalize) + ' passed, '
    + (_fail - failAfterNormalize) + ' failed');

console.log('\n═══ convertLogBases ═══');

assertEqual(T.convertLogBases('log2(8)'), '(log(8)/log(2))',
    'simple base');
assertEqual(T.convertLogBases('log2(x) + log2(y)'),
    '(log(x)/log(2)) + (log(y)/log(2))',
    'two terms same base');
assertEqual(T.convertLogBases('log2(log3(x))'),
    '(log((log(x)/log(3)))/log(2))',
    'nested bases');

console.log('\n═══ convertLogb ═══');

assertEqual(T.convertLogb('logb(x, 2)'), '(log(x)/log(2))',
    'logb with numeric base');
assertEqual(T.convertLogb('logb(x*y, 5)'), '(log(x*y)/log(5))',
    'logb with product arg');

console.log('\n═══ _filterExtraneousJs ═══');
// Only run filter tests if real nerdamer is available.  The stub returns
// non-evaluable values, so the filter would conservatively keep all roots.
let nerdamer = null;
try {
    nerdamer = require('nerdamer');
    require('nerdamer/Algebra.js');
    require('nerdamer/Calculus.js');
    require('nerdamer/Solve.js');
    win.nerdamer = nerdamer;
    nerdamer.setFunction('logb', ['x','b'], 'log(x)/log(b)');
} catch (e) {
    console.log('   (skipped — nerdamer not installed in test sandbox; run `npm install` first)');
}

if (nerdamer) {
    // ── Case A: log(x) + log(x-2) = log(3)
    //   Quadratic has roots x = 3 (valid) and x = -1 (invalid: log(-1)).
    let r = T.filterExtraneousJs(
        'log(x) + log(x-2) = log(3)',
        'x',
        ['3', '-1']);
    assertDeepEqual(r.valid, ['3'],
        'log(x)+log(x-2)=log(3): valid = [3]');
    assertDeepEqual(r.extraneous, ['-1'],
        'log(x)+log(x-2)=log(3): extraneous = [-1]');

    // ── Case B: log(x-1) = 0 → x = 2 (only)
    r = T.filterExtraneousJs('log(x-1) = 0', 'x', ['2']);
    assertDeepEqual(r.valid, ['2'],
        'log(x-1)=0: valid = [2]');

    // ── Case C: log(x^2) = 2 → x = e or -e (BOTH valid because x^2 > 0)
    //   Note: nerdamer's evaluate of `log((-2.718)^2)` should be positive
    //   so neither root is extraneous.
    r = T.filterExtraneousJs(
        'log(x^2) = 2',
        'x',
        ['e', '-e']);
    // Both must be valid because x² is always positive.  We check that
    // neither was flagged.
    assertEqual(r.extraneous.length, 0,
        'log(x^2)=2: both roots valid');

    // ── Case D: no `=` (not solve mode), no candidates → empty result
    r = T.filterExtraneousJs('log(x)', 'x', []);
    assertEqual(r.valid.length, 0,
        'no candidates → empty valid');
    assertEqual(r.extraneous.length, 0,
        'no candidates → empty extraneous');

    // ── Case E: `log(2*x-3) = 1` →  x = (e+3)/2 ≈ 2.86 (positive arg)
    //   For nerdamer-readable solution, send the numeric form.
    r = T.filterExtraneousJs(
        'log(2*x-3) = 1',
        'x',
        ['2.859']);
    assertEqual(r.extraneous.length, 0,
        'log(2x-3)=1 with valid root: kept');

    // ── Case F: `log(2*x-3) = 1` with EXTRANEOUS root inserted manually
    //   (mock a buggy upstream that returned x = 1, where 2x-3 = -1 < 0)
    r = T.filterExtraneousJs(
        'log(2*x-3) = 1',
        'x',
        ['2.859', '1']);
    assertEqual(r.extraneous.length, 1,
        'log(2x-3)=1 with x=1: extraneous detected');
}

console.log('\n═══ _buildSympyCode ═══');

const code = T.buildSympyCode('expand', 'log(x*y)', 'x');
if (typeof code !== 'string' || !code) {
    failures.push({ label: 'buildSympyCode returns string', actual: typeof code, expected: 'string' });
    _fail++;
} else {
    _pass++;
    assertContains(code, 'MODE = "expand"',
        'mode placeholder substituted');
    assertContains(code, 'VAR = "x"',
        'var placeholder substituted');
    const expectedB64 = Buffer.from('log(x*y)').toString('base64');
    assertContains(code, expectedB64,
        'raw input base64-encoded into RAW_B64');
    assertContains(code, 'expand_log',
        'Python expand_log() referenced');
    assertContains(code, 'logcombine',
        'Python logcombine() referenced');
}

// New mode: rewrite — verify the template still substitutes correctly
// and the embedded Python contains the rewrite branch.
const rewriteCode = T.buildSympyCode('rewrite', '5^3 = 125', 'x');
if (rewriteCode) {
    assertContains(rewriteCode, 'MODE = "rewrite"',
        'rewrite mode substituted');
    assertContains(rewriteCode, 'Rewrite (exponential',
        'Python source contains exponential→log branch');
    assertContains(rewriteCode, 'Rewrite (log',
        'Python source contains log→exponential branch');
}

// Fix #2 (recursion guard) — verify the Python source has the wrapper
// and the user-facing message.  The actual graceful-failure behaviour
// is exercised by sympy-cases-test.py.
const solveCode = T.buildSympyCode('solve', 'log(x)=2', 'x');
if (solveCode) {
    assertContains(solveCode, 'setrecursionlimit',
        'recursion limit lifted in template');
    assertContains(solveCode, 'too deeply nested',
        'graceful error message present for RecursionError');
}

// Fix #4 (LambertW numeric companion)
if (solveCode) {
    assertContains(solveCode, 'LambertW',
        'LambertW imported / referenced');
    assertContains(solveCode, '_numeric_companion',
        'numeric companion helper present');
}

// Fix #5 (symbolic-base cleanup)
if (solveCode) {
    assertContains(solveCode, '_cleanup_symbolic_base',
        'symbolic-base cleanup helper present');
    assertContains(solveCode, '_ugliness',
        'ugliness scorer present');
}

// Fix #7 (parameter-aware domain filter)
if (solveCode) {
    assertContains(solveCode, '_domain_ok',
        'parameter-aware domain helper present');
    assertContains(solveCode, 'free_symbols',
        'domain helper checks for free symbols (parameters)');
}

console.log('\n═══ Summary ═══');
console.log('Total: ' + _pass + ' passed, ' + _fail + ' failed');
if (_fail > 0) {
    console.error('\nFAILURES:');
    failures.forEach((f, i) => {
        console.error('  ' + (i+1) + '. ' + f.label);
        console.error('     expected: ' + JSON.stringify(f.expected));
        console.error('     actual:   ' + JSON.stringify(f.actual));
    });
    process.exit(1);
}
console.log('All JS tests passed ✓');
