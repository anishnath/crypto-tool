#!/usr/bin/env node
/**
 * Test suite for integral-calculator.jsp
 * Tests the ACTUAL JSP logic from integral-calculator-core.js
 */
const nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

// ----- Load actual JSP logic (integral-calculator-core.js from webapp) -----
const IntegralCalculatorCore = require('./require-core');
const normalizeExpr = IntegralCalculatorCore.normalizeExpr;
const checkNonElementaryIntegral = IntegralCalculatorCore.checkNonElementaryIntegral;
const evalBound = (s) => IntegralCalculatorCore.evalBound(s, nerdamer);

function integrate(expr, v) {
    const normalized = normalizeExpr(expr);
    return nerdamer('integrate(' + normalized + ', ' + v + ')');
}

function differentiate(expr, v) {
    return nerdamer('diff(' + expr + ', ' + v + ')');
}

function simplifyExpr(s) {
    return nerdamer(s).expand().text();
}

// ----- Test helpers -----
let passed = 0, failed = 0;

function ok(cond, msg) {
    if (cond) {
        passed++;
        console.log('  \x1b[32m✓\x1b[0m', msg);
        return true;
    }
    failed++;
    console.log('  \x1b[31m✗\x1b[0m', msg);
    return false;
}

function eq(a, b, msg) {
    const sa = String(a).replace(/\s/g, '');
    const sb = String(b).replace(/\s/g, '');
    if (sa === sb) {
        passed++;
        console.log('  \x1b[32m✓\x1b[0m', msg);
        return true;
    }
    failed++;
    console.log('  \x1b[31m✗\x1b[0m', msg, '| Got:', a, '| Expected:', b);
    return false;
}

function testIndefinite(name, integrand, expectedAntideriv, v = 'x') {
    console.log('\n' + name);
    try {
        const result = integrate(integrand, v);
        const hasUnresolved = result.hasIntegral && result.hasIntegral();
        if (hasUnresolved) {
            ok(false, 'Integral returned unresolved (hasIntegral)');
            return;
        }
        const antideriv = result.text();
        const deriv = differentiate(antideriv, v);
        let match = false;
        try {
            const derivText = deriv.simplify().text();
            const integNorm = nerdamer(normalizeExpr(integrand)).expand().text();
            match = derivText === integNorm;
            if (!match) {
                const diff = nerdamer(derivText + '-(' + integNorm + ')');
                const diffStr = diff.simplify().text();
                match = diffStr === '0' || diffStr === '';
            }
        } catch (_) { /* symbolic check failed, try numeric */ }
        if (!match) {
            const samples = [0.5, 1.5, 2.3];
            let okCount = 0;
            for (const x0 of samples) {
                try {
                    const dVal = parseFloat(deriv.evaluate({ [v]: x0 }).text('decimals'));
                    const iVal = parseFloat(nerdamer(normalizeExpr(integrand)).evaluate({ [v]: x0 }).text('decimals'));
                    if (isFinite(dVal) && isFinite(iVal) && Math.abs(dVal - iVal) < 1e-5) okCount++;
                } catch (_) { /* skip sample */ }
            }
            match = okCount >= 2;
        }
        ok(match, '∫ ' + integrand + ' dx → ' + antideriv + ' + C (deriv check)');
        if (expectedAntideriv && !match) {
            eq(antideriv.replace(/\s/g, ''), expectedAntideriv.replace(/\s/g, ''), 'Matches expected: ' + expectedAntideriv);
        }
    } catch (err) {
        ok(false, 'Exception: ' + err.message);
    }
}

function testDefinite(name, integrand, a, b, expectedApprox, v = 'x', tol = 0.001) {
    console.log('\n' + name);
    try {
        const result = integrate(integrand, v);
        if (result.hasIntegral && result.hasIntegral()) {
            ok(false, 'Integral unresolved');
            return;
        }
        const antideriv = result.text();
        const aNum = evalBound(a), bNum = evalBound(b);
        const F = nerdamer(antideriv);
        const Fa = F.evaluate({ [v]: aNum }).text('decimals');
        const Fb = F.evaluate({ [v]: bNum }).text('decimals');
        const numeric = parseFloat(Fb) - parseFloat(Fa);
        ok(Math.abs(numeric - expectedApprox) < tol, 
            '∫_' + a + '^' + b + ' ' + integrand + ' dx ≈ ' + numeric + ' (expected ≈ ' + expectedApprox + ')');
    } catch (err) {
        ok(false, 'Exception: ' + err.message);
    }
}

function testNormalize(input, expected) {
    const out = normalizeExpr(input);
    eq(out, expected, 'normalize("' + input + '") → "' + expected + '"');
}

function testNonElementary(input, v, shouldDetect) {
    const r = checkNonElementaryIntegral(input, v);
    const detected = !!r;
    ok(detected === shouldDetect, 
        'checkNonElementary("' + input + '") → ' + (r ? r.name : 'null') + ' (expect detect=' + shouldDetect + ')');
}

function testEvalBound(input, expected) {
    const out = evalBound(input);
    const pass = (expected === Infinity || expected === -Infinity) ? out === expected : Math.abs(out - expected) < 1e-9;
    ok(pass, 'evalBound("' + input + '") ≈ ' + expected);
}

function testExpectUnresolved(name, integrand, v = 'x') {
    console.log('\n' + name);
    if (checkNonElementaryIntegral(normalizeExpr(integrand), v)) {
        ok(true, 'Detected as non-elementary (blocked in JSP): ' + integrand);
        return;
    }
    try {
        const result = integrate(integrand, v);
        const hasUnresolved = result.hasIntegral && result.hasIntegral();
        ok(hasUnresolved || result.text().includes('integrate('), 
            'Expected unresolved or non-elementary: ' + integrand);
    } catch (err) {
        ok(true, 'Integration threw (expected for invalid): ' + err.message.substring(0, 40));
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
console.log('=== Integral Calculator Test Suite ===\n');

// 1. Normalization
console.log('--- normalizeExpr ---');
testNormalize('sin3x', 'sin(3*x)');
testNormalize('cos2x', 'cos(2*x)');
testNormalize('sinx', 'sin(x)');
testNormalize('e^2x', 'e^(2*x)');
testNormalize('sin(3*x)', 'sin(3*x)');
testNormalize('x^2', 'x^2');
// Shorthand without * (nerdamer parses xe^x as (xe)^x; xsin(x) as variable)
testNormalize('xe^x', 'x*e^x');
testNormalize('xsin(x)', 'x*sin(x)');
testNormalize('xcos(x)', 'x*cos(x)');
testNormalize('xlog(x)', 'x*log(x)');
testNormalize('xtan(x)', 'x*tan(x)');
testNormalize('2xe^x', '2*x*e^x');
testNormalize('3xe^x', '3*x*e^x');
testNormalize('te^t', 't*e^t');
testNormalize('tsin(t)', 't*sin(t)');
testNormalize('xe^2x', 'x*e^(2*x)');
testNormalize('xe^(-x)', 'x*e^(-x)');
// Implicit multiplication: digit-variable inside parens
testNormalize('sin(3x)', 'sin(3*x)');
testNormalize('cos(5x)', 'cos(5*x)');
testNormalize('sin(3x)^6*cos(3x)^7', 'sin(3*x)^6*cos(3*x)^7');
testNormalize('tan(2x)', 'tan(2*x)');
testNormalize('log(2x)', 'log(2*x)');
// Preserve asin, acos, atan (arc functions)
testNormalize('asin(x)', 'asin(x)');
testNormalize('acos(x)', 'acos(x)');

// 2. Non-elementary detection
console.log('\n--- checkNonElementaryIntegral ---');
testNonElementary('1/ln(x)', 'x', true);
testNonElementary('1/log(x)', 'x', true);
testNonElementary('1/lnx', 'x', true);
testNonElementary('1/sin(x)', 'x', false);
testNonElementary('e^(x^2)', 'x', true);
testNonElementary('sin(x)/x', 'x', true);

// 3. Basic indefinite integrals (derivative verification)
console.log('\n--- Indefinite integrals (derivative check) ---');
testIndefinite('Power: x^2', 'x^2', 'x^3/3');
testIndefinite('Power: x^3', 'x^3', 'x^4/4');
testIndefinite('sin(x)', 'sin(x)', '-cos(x)');
testIndefinite('cos(x)', 'cos(x)', 'sin(x)');
testIndefinite('e^x', 'e^x', 'e^x');
testIndefinite('1/x', '1/x', 'log(x)');
testIndefinite('sec(x)^2', 'sec(x)^2', 'tan(x)');
testIndefinite('sin(3*x) - shorthand', 'sin(3*x)', '-cos(3*x)/3');
testIndefinite('sin3x - normalized', 'sin3x', '-cos(3*x)/3');
testIndefinite('x^2 + 3*x', 'x^2+3*x', 'x^3/3+3*x^2/2');
testIndefinite('log(x)', 'log(x)', 'x*log(x)-x');
testIndefinite('1/(x^2+1)', '1/(x^2+1)', 'atan(x)');
testIndefinite('sqrt(x)', 'sqrt(x)', '2*x^(3/2)/3');
testIndefinite('sin(x)*cos(x)', 'sin(x)*cos(x)');
testIndefinite('x*e^x', 'x*e^x');

// 4a. Shorthand forms (no * between factor and function) - must normalize correctly
console.log('\n--- Shorthand forms (xe^x, xsin(x) without *) ---');
testIndefinite('xe^x - shorthand', 'xe^x');
testIndefinite('xsin(x) - shorthand', 'xsin(x)');
testIndefinite('xcos(x) - shorthand', 'xcos(x)');
testIndefinite('xlog(x) - shorthand', 'xlog(x)');
testIndefinite('2xe^x - shorthand', '2xe^x');
testIndefinite('te^t wrt t', 'te^t', undefined, 't');
testIndefinite('xe^2x - shorthand', 'xe^2x');
testIndefinite('xe^(-x) - shorthand', 'xe^(-x)');

// 4. Complex indefinite integrals
console.log('\n--- Complex indefinite integrals ---');
testIndefinite('sin(x)^2', 'sin(x)^2');
testIndefinite('cos(x)^2', 'cos(x)^2');
testIndefinite('tan(x)', 'tan(x)');
testIndefinite('sin(2*x)', 'sin(2*x)');
testIndefinite('cos(5*x)', 'cos(5*x)');
testIndefinite('sec(x)*tan(x)', 'sec(x)*tan(x)');
testIndefinite('x*sin(x) - by parts', 'x*sin(x)');
testIndefinite('x*cos(x) - by parts', 'x*cos(x)');
testIndefinite('x^2*e^x - by parts', 'x^2*e^x');
testIndefinite('x^2*log(x) - by parts', 'x^2*log(x)');
testIndefinite('e^(-x)', 'e^(-x)');
testIndefinite('e^(2*x)', 'e^(2*x)');
testIndefinite('sinh(x)', 'sinh(x)');
testIndefinite('cosh(x)', 'cosh(x)');
testIndefinite('tanh(x)', 'tanh(x)');
testIndefinite('1/sqrt(x)', '1/sqrt(x)');
testIndefinite('x/sqrt(x^2+1)', 'x/sqrt(x^2+1)');
testIndefinite('x/(x^2+1)', 'x/(x^2+1)');
testIndefinite('1/(x^2-1)', '1/(x^2-1)');
testIndefinite('(x^2+1)^2', '(x^2+1)^2');
testIndefinite('(2*x+3)^3', '(2*x+3)^3');
testIndefinite('x*e^(-x)', 'x*e^(-x)');
testIndefinite('e^x*sin(x)', 'e^x*sin(x)');
testIndefinite('e^x*cos(x)', 'e^x*cos(x)');
testIndefinite('1/sqrt(1-x^2)', '1/sqrt(1-x^2)');
testIndefinite('csc(x)^2', 'csc(x)^2');
testIndefinite('log(x)/x', 'log(x)/x');
testIndefinite('3*x^2 + 2*x - 5', '3*x^2+2*x-5');

// 5. Definite integrals
console.log('\n--- Definite integrals ---');
testDefinite('∫₀¹ x² dx', 'x^2', 0, 1, 1/3);
testDefinite('∫₀^π sin(x) dx', 'sin(x)', 0, 'pi', 2);
testDefinite('∫₀¹ e^x dx', 'e^x', 0, 1, Math.E - 1);
testDefinite('∫₁^e 1/x dx', '1/x', 1, 'e', 1);
testDefinite('∫₀^π sin(x)^2 dx', 'sin(x)^2', 0, 'pi', Math.PI / 2);
testDefinite('∫₀¹ (3*x^2+2*x) dx', '3*x^2+2*x', 0, 1, 2);
testDefinite('∫₋₁¹ x^3 dx', 'x^3', -1, 1, 0);
testDefinite('∫₀¹ sqrt(x) dx', 'sqrt(x)', 0, 1, 2/3);
testDefinite('∫₀¹ e^(-x) dx', 'e^(-x)', 0, 1, 1 - 1/Math.E);

// 6. 1/ln(x) - should be detected as non-elementary (we block it in the app)
console.log('\n--- Non-elementary: 1/ln(x) ---');
try {
    const oneOverLn = integrate('1/log(x)', 'x');
    const oneOverLnText = oneOverLn.text();
    console.log('  Nerdamer returns:', oneOverLnText.substring(0, 80) + '...');
    const hasUnevaluated = oneOverLnText.includes('integrate(');
    ok(hasUnevaluated || oneOverLn.hasIntegral?.(), '1/ln(x) either has unresolved integral or unevaluated parts');
} catch (err) {
    ok(true, '1/ln(x) detected as non-elementary (blocked in app)');
}

// 7. Edge cases
console.log('\n--- Edge cases ---');

// Normalization edge cases
testNormalize('sin3x+cos2x', 'sin(3*x)+cos(2*x)');
testNormalize('sin 3 x', 'sin(3*x)');  // space between 3 and x
testNormalize('tan5t', 'tan(5*t)');
testNormalize('cos2y', 'cos(2*y)');
testNormalize('e^3t', 'e^(3*t)');
// Shorthand in sums (ensure each term normalizes)
testNormalize('xe^x+sin(x)', 'x*e^x+sin(x)');
testNormalize('xsin(x)+x^2', 'x*sin(x)+x^2');

// Non-elementary with different variables
testNonElementary('1/ln(t)', 't', true);
testNonElementary('1/log(y)', 'y', true);

// evalBound edge cases
testEvalBound('0', 0);
testEvalBound('1', 1);
testEvalBound('pi', Math.PI);
testEvalBound('e', Math.E);
testEvalBound('3.14', 3.14);
testEvalBound('  2  ', 2);

// Minimal/simple integrals
testIndefinite('Constant 1', '1', 'x');
testIndefinite('Identity x', 'x', 'x^2/2');
testIndefinite('Constant times x', '2*x', 'x^2');
testIndefinite('x^0 = 1', 'x^0', 'x');
testIndefinite('Negative power x^(-2)', 'x^(-2)', '-1/x');

// Variable t integration
testIndefinite('sin(t) wrt t', 'sin(t)', '-cos(t)', 't');
testIndefinite('sin3t wrt t', 'sin3t', undefined, 't');

// All UI variables: y, z, u, v, w, r, s, theta, k, m, n, p, q
console.log('\n--- All variables (y,z,u,v,w,r,s,theta,k,m,n,p,q) ---');
const UI_VARS = ['y', 'z', 'u', 'v', 'w', 'r', 's', 'theta', 'k', 'm', 'n', 'p', 'q'];
UI_VARS.forEach(function(v) {
    testIndefinite(v + '^2 wrt ' + v, v + '^2', v + '^3/3', v);
    testIndefinite('sin(' + v + ') wrt ' + v, 'sin(' + v + ')', '-cos(' + v + ')', v);
});
// Definite with variable y
testDefinite('∫₀¹ y² dy', 'y^2', 0, 1, 1/3, 'y');
// theta (multi-char variable)
testIndefinite('theta^2 wrt theta', 'theta^2', 'theta^3/3', 'theta');

// Combined shorthand in one expression
testIndefinite('sin3x+cos2x', 'sin3x+cos2x');

// e^func(args) — nerdamer can't integrate, falls back to SymPy
// These test that normalizeExpr doesn't break e^sqrt(...) etc.
console.log('\n--- e^func(args) normalization ---');
testNormalize('e^sqrt(x+2)', 'e^sqrt(x+2)');
testNormalize('e^sin(x+1)', 'e^sin(x+1)');
testNormalize('e^log(2*x+1)', 'e^log(2*x+1)');

// Unresolved / non-elementary (expect hasIntegral or error)
testExpectUnresolved('e^(x^2) - Gaussian', 'e^(x^2)');
testExpectUnresolved('sin(x)/x - sinc', 'sin(x)/x');

// Invalid syntax - expect throw
testExpectError('Invalid: unclosed paren', function() { integrate('sin(3*x', 'x'); });
testExpectError('Invalid: empty after trim', function() { integrate('   ', 'x'); });

// normalizeExpr null/empty handling
ok(normalizeExpr('') === '', 'normalizeExpr("") returns ""');
ok(normalizeExpr(null) === null, 'normalizeExpr(null) returns null');

// Definite integral edge: reversed bounds
testDefinite('∫₁⁰ x² dx (reversed)', 'x^2', 1, 0, -1/3);
testDefinite('∫₀^0 x dx', 'x', 0, 0, 0);

// 8. Unicode input support
console.log('\n--- Unicode input ---');

// normalizeExpr: Unicode superscripts
testNormalize('x\u00b2', 'x^2');             // x² → x^2
testNormalize('x\u00b3+1', 'x^3+1');         // x³+1 → x^3+1
testNormalize('e^(x\u00b2)', 'e^(x^2)');     // e^(x²) → e^(x^2)
testNormalize('x\u2074+x\u00b3', 'x^4+x^3'); // x⁴+x³ → x^4+x^3

// normalizeExpr: Unicode superscript minus (negative exponents)
testNormalize('x\u207b\u00b2', 'x^(-2)');                              // x⁻² → x^(-2)
testNormalize('(1+x)\u207b\u00b3', '(1+x)^(-3)');                     // (1+x)⁻³ → (1+x)^(-3)
testNormalize('x\u207b\u00b9', 'x^(-1)');                              // x⁻¹ → x^(-1)
testNormalize('x\u00b2\u22c5(1+x\u00b2)\u207b\u00b3', 'x^2*(1+x^2)^(-3)'); // x²⋅(1+x²)⁻³
testNormalize('x\u00b2/(1+x\u00b2)\u00b3', 'x^2/(1+x^2)^3');         // x²/(1+x²)³

// normalizeExpr: Unicode symbols
testNormalize('\u03c0*x', 'pi*x');            // π*x → pi*x
testNormalize('\u221a(x)', 'sqrt(x)');        // √(x) → sqrt(x)
testNormalize('2\u22c5x', '2*x');             // 2⋅x → 2*x
testNormalize('2\u00d7x', '2*x');             // 2×x → 2*x
testNormalize('x\u00f72', 'x/2');             // x÷2 → x/2
testNormalize('x\u22122', 'x-2');             // x−2 → x-2 (Unicode minus)

// normalizeExpr: Unicode in full expressions that integrate
testIndefinite('x\u00b2 (Unicode superscript)', 'x\u00b2', 'x^3/3');  // x² → x^2

// evalBound: Unicode
testEvalBound('\u03c0', Math.PI);             // π → pi → Math.PI
testEvalBound('-\u03c0', -Math.PI);           // -π
testEvalBound('\u221e', Infinity);            // ∞ → Infinity
testEvalBound('-\u221e', -Infinity);          // -∞ → -Infinity
testEvalBound('inf', Infinity);               // inf
testEvalBound('-inf', -Infinity);             // -inf
testEvalBound('infinity', Infinity);          // infinity
testEvalBound('\u2212\u221e', -Infinity);     // −∞ (Unicode minus + infinity)

// Definite integral with Unicode bounds
testDefinite('\u222b\u2080\u03c0 sin(x) dx', 'sin(x)', 0, '\u03c0', 2);  // ∫₀^π sin(x) = 2

// Summary
console.log('\n' + '='.repeat(50));
console.log('\x1b[32mPassed:\x1b[0m', passed);
console.log('\x1b[31mFailed:\x1b[0m', failed);
console.log('Total:', passed + failed);
process.exit(failed > 0 ? 1 : 0);
