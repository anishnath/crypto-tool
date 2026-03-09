#!/usr/bin/env node
/**
 * Test suite for derivative-calculator.jsp
 * Tests the ACTUAL JSP logic (normalizeExpr from integral-calculator-core.js)
 */
const nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

// ----- Load actual JSP logic (integral-calculator-core.js for normalizeExpr) -----
const IntegralCalculatorCore = require('./require-core');
const normalizeExpr = IntegralCalculatorCore.normalizeExpr;

function diff(expr, v, order = 1) {
    const normalized = normalizeExpr(expr);
    let current = normalized;
    for (let i = 0; i < order; i++) {
        current = nerdamer('diff(' + current + ',' + v + ')').text();
    }
    return nerdamer(current);
}

function differentiate(expr, v) {
    return nerdamer('diff(' + (normalizeExpr(expr)) + ',' + v + ')');
}

// Verify: ∫ diff(f) dx should equal f (+ C) — i.e. derivative of antideriv = integrand
function verifyByIntegrateBack(integrand, derivResult, v) {
    try {
        const antideriv = nerdamer('integrate(' + derivResult.text() + ',' + v + ')');
        if (antideriv.hasIntegral && antideriv.hasIntegral()) return false;
        const antiderivText = antideriv.text();
        const derivOfAntideriv = nerdamer('diff(' + antiderivText + ',' + v + ')');
        const integNorm = nerdamer(normalizeExpr(integrand)).expand().text();
        const derivText = derivOfAntideriv.simplify().text();
        if (derivText === integNorm) return true;
        const diff = nerdamer(derivText + '-(' + integNorm + ')').simplify().text();
        return diff === '0' || diff === '';
    } catch (_) { return false; }
}

function verifyNumeric(expr, derivResult, v, samples = [0.5, 1.2, 2.1], h = 1e-5) {
    const f = nerdamer(normalizeExpr(expr));
    const df = derivResult;
    let okCount = 0;
    for (const x0 of samples) {
        try {
            const f0 = parseFloat(f.evaluate({ [v]: x0 }).text('decimals'));
            const f1 = parseFloat(f.evaluate({ [v]: x0 + h }).text('decimals'));
            const numDeriv = (f1 - f0) / h;
            const symDeriv = parseFloat(df.evaluate({ [v]: x0 }).text('decimals'));
            if (isFinite(numDeriv) && isFinite(symDeriv) && Math.abs(numDeriv - symDeriv) < 1e-4) okCount++;
        } catch (_) { /* skip */ }
    }
    return okCount >= 2;
}

// ----- Test helpers -----
let passed = 0, failed = 0;

function ok(cond, msg) {
    if (cond) { passed++; console.log('  \x1b[32m✓\x1b[0m', msg); return true; }
    failed++; console.log('  \x1b[31m✗\x1b[0m', msg);
    return false;
}

function eq(a, b, msg) {
    const sa = String(a).replace(/\s/g, '');
    const sb = String(b).replace(/\s/g, '');
    if (sa === sb) { passed++; console.log('  \x1b[32m✓\x1b[0m', msg); return true; }
    failed++; console.log('  \x1b[31m✗\x1b[0m', msg, '| Got:', a, '| Expected:', b);
    return false;
}

function testNormalize(input, expected) {
    const out = normalizeExpr(input);
    eq(out, expected, 'normalize("' + input + '") → "' + expected + '"');
}

function testDeriv(name, expr, expectedDeriv, v = 'x') {
    console.log('\n' + name);
    try {
        const result = differentiate(expr, v);
        const resultText = result.simplify().text();
        const match = resultText === expectedDeriv || 
            nerdamer(resultText + '-(' + expectedDeriv + ')').simplify().text() === '0';
        if (match) {
            ok(true, 'd/d' + v + '[' + expr + '] = ' + resultText);
            return;
        }
        const numericOk = verifyNumeric(expr, result, v);
        ok(numericOk, 'd/d' + v + '[' + expr + '] ≈ numeric check');
    } catch (err) {
        ok(false, 'Exception: ' + err.message);
    }
}

function testDerivVerify(name, expr, v = 'x', samples) {
    console.log('\n' + name);
    try {
        const result = differentiate(expr, v);
        const verify = verifyByIntegrateBack(expr, result, v) || verifyNumeric(expr, result, v, samples);
        ok(verify, 'd/d' + v + '[' + expr + '] verify (integrate back or numeric)');
    } catch (err) {
        ok(false, 'Exception: ' + err.message);
    }
}

function testExpectError(name, fn) {
    console.log('\n' + name);
    try {
        fn();
        ok(false, 'Expected an error but none was thrown');
    } catch (err) {
        ok(true, 'Correctly threw: ' + err.message.substring(0, 50));
    }
}

// ----- Run tests -----
console.log('=== Derivative Calculator Test Suite ===\n');

// 1. Normalization (same as integral)
console.log('--- normalizeExpr ---');
testNormalize('sin3x', 'sin(3*x)');
testNormalize('cos2x', 'cos(2*x)');
testNormalize('sinx', 'sin(x)');
testNormalize('e^2x', 'e^(2*x)');
testNormalize('sin3x+cos2x', 'sin(3*x)+cos(2*x)');
testNormalize('tan5t', 'tan(5*t)');
testNormalize('cos2y', 'cos(2*y)');
// Shorthand without * (xe^x, xsin(x) - nerdamer would misparse without normalization)
testNormalize('xe^x', 'x*e^x');
testNormalize('xsin(x)', 'x*sin(x)');
testNormalize('xcos(x)', 'x*cos(x)');
testNormalize('xlog(x)', 'x*log(x)');
testNormalize('2xe^x', '2x*e^x');
testNormalize('te^t', 't*e^t');
testNormalize('tsin(t)', 't*sin(t)');
testNormalize('xe^2x', 'x*e^(2*x)');
testNormalize('asin(x)', 'asin(x)');  // preserve arcsin

// 2. First derivative - power rule
console.log('\n--- First derivative: Power rule ---');
testDeriv('x^2', 'x^2', '2*x');
testDeriv('x^3', 'x^3', '3*x^2');
testDeriv('x^4', 'x^4', '4*x^3');
testDeriv('x', 'x', '1');
testDeriv('1', '1', '0');
testDeriv('2*x', '2*x', '2');
testDeriv('3*x^2', '3*x^2', '6*x');

// 3. First derivative - trig
console.log('\n--- First derivative: Trig ---');
testDeriv('sin(x)', 'sin(x)', 'cos(x)');
testDeriv('cos(x)', 'cos(x)', '-sin(x)');
testDeriv('tan(x)', 'tan(x)', 'sec(x)^2');
testDeriv('sin3x', 'sin3x', '3*cos(3*x)');
testDeriv('cos2x', 'cos2x', '-2*sin(2*x)');
testDeriv('sin(2*x)', 'sin(2*x)', '2*cos(2*x)');

// 4. First derivative - exp and log
console.log('\n--- First derivative: Exp & Log ---');
testDeriv('e^x', 'e^x', 'e^x');
testDeriv('e^2x', 'e^2x', '2*e^(2*x)');
testDeriv('log(x)', 'log(x)', '1/x');
testDeriv('log(2*x)', 'log(2*x)', '1/x');

// 5. First derivative - product & quotient
console.log('\n--- First derivative: Product & Quotient ---');
testDerivVerify('x*e^x', 'x*e^x');
testDerivVerify('x*sin(x)', 'x*sin(x)');
// Shorthand forms (must normalize to x*e^x etc. or nerdamer returns wrong result)
testDerivVerify('xe^x - shorthand', 'xe^x');
testDerivVerify('xsin(x) - shorthand', 'xsin(x)');
testDerivVerify('xcos(x) - shorthand', 'xcos(x)');
testDerivVerify('xlog(x) - shorthand', 'xlog(x)');
testDerivVerify('2xe^x - shorthand', '2xe^x', 'x', [0.5, 1.0, 2.0]);
testDerivVerify('te^t wrt t', 'te^t', 't');
testDerivVerify('x^2*log(x)', 'x^2*log(x)');
testDerivVerify('sin(x)/x', 'sin(x)/x');
testDerivVerify('log(x)/x', 'log(x)/x');
// (x^2+1)/(x-1) has singularity at x=1; verify numeric (avoid x=1)
testDerivVerify('(x^2+1)/(x-1)', '(x^2+1)/(x-1)', 'x', [0.5, 2, 3]);

// 5b. More product rule with shorthand (use safe samples: avoid pi/2 where tan/sec blow up)
testDerivVerify('xtan(x) - shorthand', 'xtan(x)', 'x', [0.3, 0.5, 1.0]);
testDerivVerify('xsec(x)^2 - shorthand', 'xsec(x)^2', 'x', [0.3, 0.5, 1.0]);

// 6. First derivative - chain rule
console.log('\n--- First derivative: Chain rule ---');
testDerivVerify('sqrt(x^2+1)', 'sqrt(x^2+1)');
// e^(x^2) has no elementary antiderivative; verify with small x (avoid large values)
testDerivVerify('e^(x^2)', 'e^(x^2)', 'x', [0.2, 0.4, 0.6]);
testDerivVerify('sin(x)^2', 'sin(x)^2');
testDerivVerify('cos(x)^2', 'cos(x)^2');
testDerivVerify('log(sin(x))', 'log(sin(x))');

// 7. Higher-order derivatives
console.log('\n--- Higher-order derivatives ---');
(function(){
    const r = diff('x^4', 'x', 2);
    ok(r.simplify().text().replace(/\s/g,'') === '12*x^2', 'diff(x^4, x, 2) = 12*x^2');
})();
(function(){
    const r = diff('sin(x)', 'x', 2);
    ok(r.simplify().text().replace(/\s/g,'') === '-sin(x)', 'diff(sin(x), x, 2) = -sin(x)');
})();
(function(){
    const r = diff('e^x', 'x', 3);
    ok(r.text() === 'e^x', 'diff(e^x, x, 3) = e^x');
})();
(function(){
    const r = diff('x^5', 'x', 5);
    ok(r.text() === '120', 'diff(x^5, x, 5) = 120');
})();

// 8. Variable t, y
console.log('\n--- Variable t, y ---');
testDeriv('sin(t) wrt t', 'sin(t)', 'cos(t)', 't');
testDeriv('sin3t wrt t', 'sin3t', '3*cos(3*t)', 't');
testDeriv('cos2y wrt y', 'cos2y', '-2*sin(2*y)', 'y');

// 9. Edge cases
console.log('\n--- Edge cases ---');
ok(normalizeExpr('') === '', 'normalizeExpr("") returns ""');
ok(normalizeExpr(null) === null, 'normalizeExpr(null) returns null');
testExpectError('Invalid: unclosed paren', function() { differentiate('sin(3*x', 'x'); });
testExpectError('Invalid: empty', function() {
    const e = normalizeExpr('   ');
    nerdamer('diff(' + e + ', x)');
});

// Summary
console.log('\n' + '='.repeat(50));
console.log('\x1b[32mPassed:\x1b[0m', passed);
console.log('\x1b[31mFailed:\x1b[0m', failed);
console.log('Total:', passed + failed);
process.exit(failed > 0 ? 1 : 0);
