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

/** Same as testNormalize but message starts with a label (e.g. MIT Bee problem id). */
function testNormalizeLabel(label, input, expected) {
    const out = normalizeExpr(input);
    eq(out, expected, label + ': normalize("' + input + '") → "' + expected + '"');
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
// arcsin → asin, arccos → acos, arctan → atan
testNormalize('arcsin(x)', 'asin(x)');
testNormalize('arccos(x)', 'acos(x)');
testNormalize('arctan(x)', 'atan(x)');
testNormalize('arctan(x)/(x*(1+x^2))', 'atan(x)/(x*(1+x^2))');

// MIT Integration Bee 2026 qualifying (PDF) — normalize only; solving is separate.
// PASS (below): stable normalize for preview/parse.
// REVIEW / not one-line UI: #4 nested abs×2026, #8 Σ x^n/n!, #12 infinite nested √, #15 long ⌊⌈·⌉⌋ expression.
console.log('\n--- normalizeExpr: MIT Bee 2026 qualifying (entry-safe) ---');
testNormalizeLabel('MIT Bee #1 (explicit *)', 'sin^2025(x)*cos^2026(x)', 'sin(x)^2025*cos(x)^2026');
testNormalizeLabel('MIT Bee #1 (chained)', 'sin^2025(x)cos^2026(x)', 'sin(x)^2025*cos(x)^2026');
testNormalizeLabel('MIT Bee #2', 'e^(2026*e^x+x)', 'e^(2026*e^x+x)');
testNormalizeLabel('MIT Bee #3', 'mod(floor(x)/3,1)', 'mod(floor(x)/3,1)');
testNormalizeLabel('MIT Bee #5', '1/(sqrt(x+1)-sqrt(x-1))', '1/(sqrt(x+1)-sqrt(x-1))');
testNormalizeLabel('MIT Bee #6', 'sqrt(1+cosh(x))', 'sqrt(1+cosh(x))');
testNormalizeLabel('MIT Bee #7a', '2^log(x)/x^2', '2^log(x)/x^2');
testNormalizeLabel('MIT Bee #7b', '2*log(x)/x^2', '2*log(x)/x^2');
testNormalizeLabel('MIT Bee #9', 'x^2*sin(x)', 'x^2*sin(x)');
testNormalizeLabel('MIT Bee #10', '(x-1)^2/(2*e^x+x^2+1)', '(x-1)^2/(2*e^x+x^2+1)');
testNormalizeLabel('MIT Bee #11', 'max(0,sqrt(1-x^2)-1/2)', 'max(0,sqrt(1-x^2)-1/2)');
testNormalizeLabel('MIT Bee #13', 'cos(x)^5-10*cos(x)^3*sin(x)^2+5*cos(x)*sin(x)^4', 'cos(x)^5-10*cos(x)^3*sin(x)^2+5*cos(x)*sin(x)^4');
testNormalizeLabel('MIT Bee #14', 'atan(sqrt(x))', 'atan(sqrt(x))');
testNormalizeLabel('MIT Bee #16', 'sqrt(cos(x)*cot(x)*csc(x)/(sin(x)*tan(x)*sec(x)))', 'sqrt(cos(x)*cot(x)*csc(x)/(sin(x)*tan(x)*sec(x)))');
testNormalizeLabel('MIT Bee #17', 'e^(-x^2)/(1+e^(2*x))', 'e^(-x^2)/(1+e^(2*x))');
testNormalizeLabel('MIT Bee #18', 'sin(x)^2/x^2-sin(2*x)/x', 'sin(x)^2/x^2-sin(2*x)/x');
testNormalizeLabel('MIT Bee #19', 'log(log(x))*log(log(log(x)))/(x*log(x))', 'log(log(x))*log(log(log(x)))/(x*log(x))');
testNormalizeLabel('MIT Bee #20', 'cos(pi/2*cos(pi/2*cos(x)^2)^2)^2', 'cos(pi/2*cos(pi/2*cos(x)^2)^2)^2');

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

// --- exprToLatex: nested fraction cleanup ---
console.log('\n--- exprToLatex: nested fraction cleanup ---');

function boundToLatex(s) {
    return String(s)
        .replace(/\u221e/g, '\\infty')
        .replace(/\u03c0/g, '\\pi')
        .replace(/\u2212/g, '-')
        .replace(/\u2080/g, '0').replace(/\u2081/g, '1')
        .replace(/\u2082/g, '2').replace(/\u2083/g, '3')
        .replace(/\u2084/g, '4').replace(/\u2085/g, '5')
        .replace(/\u2086/g, '6').replace(/\u2087/g, '7')
        .replace(/\u2088/g, '8').replace(/\u2089/g, '9')
        .replace(/\binfinity\b/gi, '\\infty')
        .replace(/\bInfinity\b/g, '\\infty')
        .replace(/\binf\b/gi, '\\infty')
        .replace(/\boo\b/g, '\\infty')
        .replace(/\bpi\b/gi, '\\pi');
}

/** SymPy-style Sum(term, (idx, lo, hi)); whole expression only (mirrors integral-calculator.js). */
function parseSympySum(expr) {
    if (!expr || typeof expr !== 'string') return null;
    var s = expr.replace(/\s+/g, ' ').trim();
    if (!/^Sum\s*\(/i.test(s)) return null;
    var open = s.indexOf('(');
    if (open < 0) return null;
    var p = open + 1;
    var depth = 1;
    var j = p;
    var sep = -1;
    while (j < s.length) {
        var c = s[j];
        if (c === '(') depth++;
        else if (c === ')') {
            depth--;
            if (depth === 0) return null;
        } else if (c === ',' && depth === 1) {
            sep = j;
            break;
        }
        j++;
    }
    if (sep < 0) return null;
    var term = s.slice(p, sep).trim();
    var rest = s.slice(sep + 1).trim();
    if (rest[0] !== '(') return null;
    var tdepth = 0;
    var ti;
    for (ti = 0; ti < rest.length; ti++) {
        if (rest[ti] === '(') tdepth++;
        else if (rest[ti] === ')') {
            tdepth--;
            if (tdepth === 0) break;
        }
    }
    if (tdepth !== 0 || ti >= rest.length) return null;
    var tupleInner = rest.slice(1, ti).trim();
    var afterTuple = rest.slice(ti + 1).trim();
    if (afterTuple !== ')') return null;
    var parts = tupleInner.split(',').map(function(x) { return x.trim(); });
    if (parts.length !== 3) return null;
    return { term: term, idx: parts[0], lo: parts[1], hi: parts[2] };
}

function exprToLatex(expr) {
    var sumParsed = parseSympySum(expr);
    if (sumParsed) {
        var termTex = exprToLatex(sumParsed.term);
        var loTex = boundToLatex(sumParsed.lo);
        var hiTex = boundToLatex(sumParsed.hi);
        return '\\sum_{' + sumParsed.idx + '=' + loTex + '}^{' + hiTex + '} \\left(' + termTex + '\\right)';
    }
    var parsed = nerdamer(expr);
    var tex = parsed.toTeX();
    tex = tex.replace(/\\frac\{1\}\{([a-zA-Z])\^\{([^{}]+(?:\{[^{}]*\}[^{}]*)*)\}\}/g, function(m, v, exp, off) {
        return off === 0 ? m : v + '^{-' + exp + '}';
    });
    tex = tex.replace(/\\frac\{1\}\{\\sqrt\{([a-zA-Z])\}\}/g, function(m, v, off) {
        return off === 0 ? m : v + '^{-1/2}';
    });
    tex = tex.replace(/\\frac\{1\}\{([a-zA-Z])\}/g, function(m, v, off) {
        return off === 0 ? m : v + '^{-1}';
    });
    return tex;
}

// Nested fractions: integer negative exponents
eq(exprToLatex('(1+x^4)/(1+x^(-4))'), '\\frac{x^{4}+1}{x^{-4}+1}',
    'exprToLatex("(1+x^4)/(1+x^(-4))") no nested frac');
eq(exprToLatex('(x+1)/(x^(-1)+1)'), '\\frac{x+1}{x^{-1}+1}',
    'exprToLatex("(x+1)/(x^(-1)+1)") no nested frac');
eq(exprToLatex('x^2/(1+x^(-3))'), '\\frac{x^{2}}{x^{-3}+1}',
    'exprToLatex("x^2/(1+x^(-3))") no nested frac');
eq(exprToLatex('1/(1+x^(-2))'), '\\frac{1}{\\left(x^{-2}+1\\right)}',
    'exprToLatex("1/(1+x^(-2))") no nested frac');

// Nested fractions: fractional negative exponents
eq(exprToLatex('(1+x^2)/(1+x^(-1/2))'), '\\frac{x^{2}+1}{x^{-1/2}+1}',
    'exprToLatex("(1+x^2)/(1+x^(-1/2))") sqrt nested frac cleaned');
eq(exprToLatex('(1+x^2)/(1+x^(-3/2))'), '\\frac{x^{2}+1}{x^{-\\frac{3}{2}}+1}',
    'exprToLatex("(1+x^2)/(1+x^(-3/2))") frac exponent nested frac cleaned');
eq(exprToLatex('(1+x^2)/(1+x^(-2/3))'), '\\frac{x^{2}+1}{x^{-\\frac{2}{3}}+1}',
    'exprToLatex("(1+x^2)/(1+x^(-2/3))") frac exponent nested frac cleaned');

// Nested fractions: pi exponents
eq(exprToLatex('(1+x^2)/(1+x^(-pi/4))'), '\\frac{x^{2}+1}{x^{-\\frac{\\pi}{4}}+1}',
    'exprToLatex("(1+x^2)/(1+x^(-pi/4))") pi/4 nested frac cleaned');
eq(exprToLatex('(1+x)/(1+x^(-pi))'), '\\frac{x+1}{x^{-\\pi}+1}',
    'exprToLatex("(1+x)/(1+x^(-pi))") pi nested frac cleaned');

// Standalone fractions should NOT be changed
eq(exprToLatex('1/x^4'), '\\frac{1}{x^{4}}',
    'exprToLatex("1/x^4") stays as single frac');
eq(exprToLatex('x^(-4)'), '\\frac{1}{x^{4}}',
    'exprToLatex("x^(-4)") stays as single frac');
eq(exprToLatex('x^(-pi/4)'), '\\frac{1}{x^{\\frac{\\pi}{4}}}',
    'exprToLatex("x^(-pi/4)") standalone stays as single frac');
eq(exprToLatex('x^(-3/2)'), '\\frac{1}{x^{\\frac{3}{2}}}',
    'exprToLatex("x^(-3/2)") standalone stays as single frac');

// Non-fraction expressions stay untouched
eq(exprToLatex('sin(x)/x'), '\\frac{\\mathrm{sin}\\left(x\\right)}{x}',
    'exprToLatex("sin(x)/x") untouched');
eq(exprToLatex('x^2+1'), 'x^{2}+1',
    'exprToLatex("x^2+1") no frac at all');

// SymPy Sum → KaTeX (MIT Bee #8 style)
eq(exprToLatex('Sum(x^n, (n, 2, oo))'), '\\sum_{n=2}^{\\infty} \\left(x^{n}\\right)',
    'exprToLatex SymPy Sum(x^n, (n, 2, oo))');

// --- King's Property detection ---
console.log("\n--- King's Property (symmetry) detection ---");

const checkKingsProperty = IntegralCalculatorCore.checkKingsProperty;

function testKings(name, expr, a, b, expectValue) {
    var result = checkKingsProperty(normalizeExpr(expr), 'x', a, b, nerdamer);
    if (expectValue === null) {
        ok(result === null, 'Kings: "' + name + '" correctly NOT detected');
    } else {
        var pass = result && Math.abs(result.value - expectValue) < 1e-9;
        ok(pass, 'Kings: "' + name + '" → ' + (result ? result.value.toFixed(6) : 'null') + ' (expect ' + expectValue.toFixed(6) + ')');
    }
}

// Should detect (result = π/4)
testKings('sin²/(cos²+sin²) [0,π/2]', 'sin(x)^2/(cos(x)^2+sin(x)^2)', '0', 'pi/2', Math.PI/4);
testKings('sin³/(cos³+sin³) [0,π/2]', 'sin(x)^3/(cos(x)^3+sin(x)^3)', '0', 'pi/2', Math.PI/4);
testKings('sin⁵/(cos⁵+sin⁵) [0,π/2]', 'sin(x)^5/(cos(x)^5+sin(x)^5)', '0', 'pi/2', Math.PI/4);
testKings('sin¹⁰/(cos¹⁰+sin¹⁰) [0,π/2]', 'sin(x)^10/(cos(x)^10+sin(x)^10)', '0', 'pi/2', Math.PI/4);
testKings('√sin/(√cos+√sin) [0,π/2]', 'sqrt(sin(x))/(sqrt(cos(x))+sqrt(sin(x)))', '0', 'pi/2', Math.PI/4);

// Famous integrals: verify input parsing (normalizeExpr → nerdamer parse → eval)
console.log('\n--- Famous integrals: input parsing ---');
function testParsable(name, raw, testX, expectApprox, tol) {
    var expr = normalizeExpr(raw);
    try {
        var val = parseFloat(nerdamer(expr).evaluate({x: testX}).text('decimals'));
        var pass = Math.abs(val - expectApprox) < (tol || 0.001);
        ok(pass, 'parse "' + raw + '" → eval(' + testX + ')=' + val.toFixed(6) + ' (expect ~' + expectApprox + ')');
    } catch(e) {
        ok(false, 'parse "' + raw + '" FAILED: ' + e.message.substring(0,50));
    }
}
testParsable('sin(x)/x', 'sin(x)/x', 0.5, 0.958851, 0.001);
testParsable('e^(-x^2)', 'e^(-x^2)', 0.5, 0.778801, 0.001);
testParsable('ln(-ln(x))/(1+x)', 'ln(-ln(x))/(1+x)', 0.3, 0.142790, 0.001);
testParsable('log(sin(x))', 'log(sin(x))', 0.5, -0.735167, 0.001);
testParsable('atan(x)/(x*(1+x^2))', 'atan(x)/(x*(1+x^2))', 0.5, 0.741836, 0.001);
testParsable('arctan(x)/(x*(1+x^2))', 'arctan(x)/(x*(1+x^2))', 0.5, 0.741836, 0.001);
testParsable('x/(e^x-1)', 'x/(e^x-1)', 0.5, 0.770747, 0.001);
testParsable('cos(2*x)/(x^2+1)', 'cos(2*x)/(x^2+1)', 0.5, 0.432242, 0.001);
testParsable('e^(-x)*sin(x)', 'e^(-x)*sin(x)', 0.5, 0.290786, 0.001);
testParsable('sinx/x shorthand', 'sinx/x', 0.5, 0.958851, 0.001);

// Symbolic parameter m — should still detect
testKings('sin^m/(cos^m+sin^m) symbolic m [0,π/2]', 'sin(x)^m/(cos(x)^m+sin(x)^m)', '0', 'pi/2', Math.PI/4);
testKings('sin^n/(cos^n+sin^n) symbolic n [0,π/2]', 'sin(x)^n/(cos(x)^n+sin(x)^n)', '0', 'pi/2', Math.PI/4);

// Should NOT detect
testKings('sin(x) [0,π/2]', 'sin(x)', '0', 'pi/2', null);
testKings('x² [0,1]', 'x^2', '0', '1', null);
testKings('1/x [1,2]', '1/x', '1', '2', null);

// Summary
console.log('\n' + '='.repeat(50));
console.log('\x1b[32mPassed:\x1b[0m', passed);
console.log('\x1b[31mFailed:\x1b[0m', failed);
console.log('Total:', passed + failed);
process.exit(failed > 0 ? 1 : 0);
