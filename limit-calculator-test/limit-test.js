#!/usr/bin/env node
/**
 * Test suite for limit-calculator.jsp
 * Uses normalizeExpr from integral-calculator-core.js
 */
const nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

const IntegralCalculatorCore = require('./require-core');
const normalizeExpr = IntegralCalculatorCore.normalizeExpr;

function limit(expr, v, a) {
    const normalized = normalizeExpr(expr);
    let pt = a;
    if (pt === Infinity) pt = 'infinity';
    else if (pt === -Infinity) pt = '-infinity';
    return nerdamer('limit(' + normalized + ',' + v + ',' + pt + ')');
}

let passed = 0, failed = 0;

function ok(cond, msg) {
    if (cond) { passed++; console.log('  \x1b[32m✓\x1b[0m', msg); return; }
    failed++; console.log('  \x1b[31m✗\x1b[0m', msg);
}

function eq(a, b, msg) {
    const sa = String(a).replace(/\s/g, '');
    const sb = String(b).replace(/\s/g, '');
    if (sa === sb) { passed++; console.log('  \x1b[32m✓\x1b[0m', msg); return; }
    failed++; console.log('  \x1b[31m✗\x1b[0m', msg, '| Got:', a, '| Expected:', b);
}

function testNormalize(input, expected) {
    const out = normalizeExpr(input);
    eq(out, expected, 'normalize("' + input + '") → "' + expected + '"');
}

function testLimit(name, expr, v, a, expected) {
    console.log('\n' + name);
    try {
        const r = limit(expr, v, a);
        const val = r.text();
        let match = val === String(expected) || (typeof expected === 'number' && parseFloat(val) === expected);
        if (!match && expected === 0 && (val === 'infinity^(-1)' || val === '0')) match = true;
        ok(match, 'lim(' + v + '→' + a + ') ' + expr + ' = ' + val);
    } catch (err) {
        ok(false, 'Exception: ' + err.message);
    }
}

console.log('=== Limit Calculator Test Suite ===\n');

// 1. Normalization
console.log('--- normalizeExpr ---');
testNormalize('sin3x', 'sin(3*x)');
testNormalize('cos2x', 'cos(2*x)');
testNormalize('sinx', 'sin(x)');
testNormalize('e^2x', 'e^(2*x)');
testNormalize('sin3x+cos2x', 'sin(3*x)+cos(2*x)');
// Shorthand without * (xe^x, xsin(x) - must normalize for correct limit)
testNormalize('xe^x', 'x*e^x');
testNormalize('xsin(x)', 'x*sin(x)');
testNormalize('xcos(x)', 'x*cos(x)');
testNormalize('2xe^x', '2x*e^x');
testNormalize('te^t', 't*e^t');

// 2. Known limits - direct substitution
console.log('\n--- Direct substitution ---');
testLimit('x^2 at 3', 'x^2', 'x', 3, 9);
testLimit('x+1 at 0', 'x+1', 'x', 0, 1);
testLimit('2*x at 5', '2*x', 'x', 5, 10);

// 3. sin(x)/x → 1
console.log('\n--- sin(x)/x at 0 ---');
testLimit('sin(x)/x at 0', 'sin(x)/x', 'x', 0, 1);
testLimit('sin3x/(3*x) at 0 - shorthand', 'sin3x/(3*x)', 'x', 0, 1);

// 3b. Shorthand forms - lim x→0 (xe^x, xsin(x) etc) = 0
console.log('\n--- Shorthand forms at 0 ---');
testLimit('xe^x at 0', 'xe^x', 'x', 0, 0);
testLimit('xsin(x) at 0', 'xsin(x)', 'x', 0, 0);
testLimit('xcos(x) at 0', 'xcos(x)', 'x', 0, 0);
testLimit('te^t at 0', 'te^t', 't', 0, 0);

// 4. (x^2-1)/(x-1) → 2 at 1
console.log('\n--- (x^2-1)/(x-1) at 1 ---');
testLimit('(x^2-1)/(x-1) at 1', '(x^2-1)/(x-1)', 'x', 1, 2);

// 5. (e^x-1)/x → 1 at 0
console.log('\n--- (e^x-1)/x at 0 ---');
testLimit('(e^x-1)/x at 0', '(e^x-1)/x', 'x', 0, 1);

// 6. tan(x)/x → 1 at 0
console.log('\n--- tan(x)/x at 0 ---');
testLimit('tan(x)/x at 0', 'tan(x)/x', 'x', 0, 1);

// 7. Limits at infinity
console.log('\n--- Limits at infinity ---');
testLimit('1/x at infinity', '1/x', 'x', Infinity, 0);
testLimit('x at infinity', 'x', 'x', Infinity, 'infinity');
testLimit('xe^x at 1', 'xe^x', 'x', 1, Math.E);  // shorthand, lim = e

// 7b. More limits - polynomial, rational
console.log('\n--- More limits ---');
testLimit('(x^2+1)/(x+1) at 0', '(x^2+1)/(x+1)', 'x', 0, 1);
testLimit('sqrt(x+1)-1 at 0', 'sqrt(x+1)-1', 'x', 0, 0);

// 8. Variable t
console.log('\n--- Variable t ---');
testLimit('sin(t)/t at 0', 'sin(t)/t', 't', 0, 1);
testLimit('sin3t/(3*t) at 0', 'sin3t/(3*t)', 't', 0, 1);

// 9. Edge cases
console.log('\n--- Edge cases ---');
ok(normalizeExpr('') === '', 'normalizeExpr("") returns ""');
ok(normalizeExpr(null) === null, 'normalizeExpr(null) returns null');
// Shorthand in sums and quotients
testNormalize('xe^x+1', 'x*e^x+1');
testNormalize('xsin(x)/x', 'x*sin(x)/x');

console.log('\n' + '='.repeat(50));
console.log('\x1b[32mPassed:\x1b[0m', passed);
console.log('\x1b[31mFailed:\x1b[0m', failed);
console.log('Total:', passed + failed);
process.exit(failed > 0 ? 1 : 0);
