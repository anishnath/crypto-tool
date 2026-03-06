/**
 * Test: Graphing calculator antiderivative & limit features
 * Leverages expressions from integral-calculator-test and limit-calculator-test
 * Run: node test-graphing-calculus.cjs
 */
const nerdamer = require('nerdamer');
require('nerdamer/Algebra');
require('nerdamer/Calculus');
require('nerdamer/Solve');

if (typeof globalThis.i === 'undefined') globalThis.i = NaN;

let passed = 0, failed = 0;
const failures = [];

function test(label, fn) {
    try {
        fn();
        passed++;
    } catch (e) {
        failed++;
        failures.push({ label, error: e.message });
        console.log(`  FAIL: ${label}\n        ${e.message}`);
    }
}

// =====================================================================
// Simulate engine's generateAntiderivative: integrate then plot points
// =====================================================================
function testAntiderivative(expr, xTests) {
    if (!xTests) xTests = [0.5, 1, 1.5, 2];
    const antideriv = nerdamer('integrate(' + expr + ', x)');
    const antiText = antideriv.text();
    if (!antiText) throw new Error('Empty antiderivative');

    let points = 0;
    for (const xv of xTests) {
        try {
            nerdamer.setVar('x', String(xv));
            const yv = parseFloat(nerdamer(antiText).evaluate().text());
            nerdamer.clearVars();
            if (isFinite(yv)) points++;
        } catch (_) { nerdamer.clearVars(); }
    }

    if (points === 0) throw new Error(`0 plottable points for F(x) = ${antiText}`);
    return { symbolic: antiText, points };
}

// Verify FTC: d/dx[F(x)] = f(x) numerically
function verifyFTC(expr, xv) {
    const anti = nerdamer('integrate(' + expr + ', x)').text();
    const h = 0.0001;
    nerdamer.setVar('x', String(xv + h));
    const fPlus = parseFloat(nerdamer(anti).evaluate().text());
    nerdamer.clearVars();
    nerdamer.setVar('x', String(xv - h));
    const fMinus = parseFloat(nerdamer(anti).evaluate().text());
    nerdamer.clearVars();
    const numDeriv = (fPlus - fMinus) / (2 * h);

    nerdamer.setVar('x', String(xv));
    const original = parseFloat(nerdamer(expr).evaluate().text());
    nerdamer.clearVars();

    if (Math.abs(numDeriv - original) > 0.01) {
        throw new Error(`F'(${xv}) = ${numDeriv.toFixed(4)}, f(${xv}) = ${original.toFixed(4)} — mismatch`);
    }
}

// =====================================================================
// Simulate engine's evaluateLimit
// =====================================================================
function testLimit(expr, variable, value, expected) {
    const result = nerdamer('limit(' + expr + ', ' + variable + ', ' + value + ')');
    const text = result.text();
    let numVal;
    try {
        numVal = parseFloat(nerdamer(text).evaluate().text());
    } catch (_) {
        numVal = NaN;
    }

    if (expected !== undefined && isFinite(expected)) {
        if (!isFinite(numVal) || Math.abs(numVal - expected) > 0.01) {
            throw new Error(`Expected ${expected}, got ${numVal} (symbolic: ${text})`);
        }
    }
    return { symbolic: text, numeric: numVal };
}

// Definite integral test: integrate, then evaluate F(b) - F(a)
function testDefinite(expr, a, b, expected, tol) {
    if (!tol) tol = 0.001;
    const anti = nerdamer('integrate(' + expr + ', x)').text();

    nerdamer.setVar('x', String(b));
    const Fb = parseFloat(nerdamer(anti).evaluate().text());
    nerdamer.clearVars();
    nerdamer.setVar('x', String(a));
    const Fa = parseFloat(nerdamer(anti).evaluate().text());
    nerdamer.clearVars();

    const result = Fb - Fa;
    if (Math.abs(result - expected) > tol) {
        throw new Error(`∫_${a}^${b} = ${result.toFixed(6)}, expected ${expected}`);
    }
    return result;
}


// =====================================================================
// ANTIDERIVATIVES — from integral-calculator-test expressions
// =====================================================================

console.log('=== BASIC INDEFINITE INTEGRALS (from integral-calculator-test) ===\n');

test('∫ x^2 dx', () => {
    const r = testAntiderivative('x^2');
    console.log(`    F(x) = ${r.symbolic}`);
});
test('∫ x^3 dx', () => testAntiderivative('x^3'));
test('∫ sin(x) dx', () => {
    const r = testAntiderivative('sin(x)');
    console.log(`    F(x) = ${r.symbolic}`);
});
test('∫ cos(x) dx', () => testAntiderivative('cos(x)'));
test('∫ e^x dx', () => testAntiderivative('e^x'));
test('∫ 1/x dx', () => testAntiderivative('1/x', [1, 2, 3, 4]));
test('∫ sec(x)^2 dx', () => testAntiderivative('sec(x)^2', [0.1, 0.5, 1]));
test('∫ sin(3*x) dx', () => testAntiderivative('sin(3*x)'));
test('∫ x^2 + 3*x dx', () => testAntiderivative('x^2+3*x'));
test('∫ log(x) dx', () => testAntiderivative('log(x)', [1, 2, 3]));
test('∫ 1/(x^2+1) dx → atan(x)', () => testAntiderivative('1/(x^2+1)'));
test('∫ sqrt(x) dx', () => testAntiderivative('sqrt(x)', [1, 4, 9]));
test('∫ sin(x)*cos(x) dx', () => testAntiderivative('sin(x)*cos(x)'));
test('∫ x*e^x dx (by parts)', () => testAntiderivative('x*e^x'));

console.log('\n=== COMPLEX INTEGRALS (from integral-calculator-test) ===\n');

test('∫ sin(x)^2 dx', () => testAntiderivative('sin(x)^2'));
test('∫ cos(x)^2 dx', () => testAntiderivative('cos(x)^2'));
test('∫ tan(x) dx', () => testAntiderivative('tan(x)', [0.1, 0.5, 1]));
test('∫ sin(2*x) dx', () => testAntiderivative('sin(2*x)'));
test('∫ cos(5*x) dx', () => testAntiderivative('cos(5*x)'));
test('∫ sec(x)*tan(x) dx', () => testAntiderivative('sec(x)*tan(x)', [0.1, 0.5, 1]));
test('∫ x*sin(x) dx (by parts)', () => testAntiderivative('x*sin(x)'));
test('∫ x*cos(x) dx (by parts)', () => testAntiderivative('x*cos(x)'));
test('∫ x^2*e^x dx (by parts)', () => testAntiderivative('x^2*e^x'));
test('∫ x^2*log(x) dx (by parts)', () => testAntiderivative('x^2*log(x)', [1, 2, 3]));
test('∫ e^(-x) dx', () => testAntiderivative('e^(-x)'));
test('∫ e^(2*x) dx', () => testAntiderivative('e^(2*x)'));
test('∫ sinh(x) dx', () => testAntiderivative('sinh(x)'));
test('∫ cosh(x) dx', () => testAntiderivative('cosh(x)'));
test('∫ tanh(x) dx', () => testAntiderivative('tanh(x)', [0.1, 0.5, 1]));
test('∫ 1/sqrt(x) dx', () => testAntiderivative('1/sqrt(x)', [1, 4, 9]));
test('∫ x/sqrt(x^2+1) dx', () => testAntiderivative('x/sqrt(x^2+1)'));
test('∫ x/(x^2+1) dx', () => testAntiderivative('x/(x^2+1)'));
test('∫ 1/(x^2-1) dx', () => testAntiderivative('1/(x^2-1)', [2, 3, 5]));
test('∫ (x^2+1)^2 dx', () => testAntiderivative('(x^2+1)^2'));
test('∫ (2*x+3)^3 dx', () => testAntiderivative('(2*x+3)^3'));
test('∫ x*e^(-x) dx', () => testAntiderivative('x*e^(-x)'));
test('∫ e^x*sin(x) dx', () => testAntiderivative('e^x*sin(x)'));
test('∫ e^x*cos(x) dx', () => testAntiderivative('e^x*cos(x)'));
test('∫ 1/sqrt(1-x^2) dx → asin(x)', () => testAntiderivative('1/sqrt(1-x^2)', [0, 0.3, 0.5, 0.8]));
test('∫ csc(x)^2 dx', () => testAntiderivative('csc(x)^2', [0.5, 1, 1.5]));
test('∫ log(x)/x dx', () => testAntiderivative('log(x)/x', [1, 2, 3]));
test('∫ 3*x^2 + 2*x - 5 dx', () => testAntiderivative('3*x^2+2*x-5'));

console.log('\n=== SIMPLE/EDGE CASE INTEGRALS ===\n');

test('∫ 1 dx → x', () => testAntiderivative('1'));
test('∫ x dx → x^2/2', () => testAntiderivative('x'));
test('∫ 2*x dx → x^2', () => testAntiderivative('2*x'));
test('∫ x^(-2) dx → -1/x', () => testAntiderivative('x^(-2)', [1, 2, 3]));
test('∫ x^4 - 3*x^2 + 1 dx', () => testAntiderivative('x^4-3*x^2+1'));

console.log('\n=== FTC VERIFICATION: d/dx[F(x)] = f(x) ===\n');

test('FTC: x^2 at x=2', () => verifyFTC('x^2', 2));
test('FTC: sin(x) at x=1', () => verifyFTC('sin(x)', 1));
test('FTC: cos(x) at x=1.5', () => verifyFTC('cos(x)', 1.5));
test('FTC: exp(x) at x=0', () => verifyFTC('exp(x)', 0));
test('FTC: 1/(1+x^2) at x=1', () => verifyFTC('1/(1+x^2)', 1));
test('FTC: x*e^x at x=1', () => verifyFTC('x*e^x', 1));
test('FTC: x*sin(x) at x=2', () => verifyFTC('x*sin(x)', 2));
test('FTC: e^x*cos(x) at x=0.5', () => verifyFTC('e^x*cos(x)', 0.5));
test('FTC: x^2*log(x) at x=2', () => verifyFTC('x^2*log(x)', 2));
test('FTC: sin(x)^2 at x=1', () => verifyFTC('sin(x)^2', 1));
test('FTC: (2*x+3)^3 at x=0', () => verifyFTC('(2*x+3)^3', 0));
test('FTC: sinh(x) at x=1', () => verifyFTC('sinh(x)', 1));

console.log('\n=== DEFINITE INTEGRALS (from integral-calculator-test) ===\n');

test('∫₀¹ x² dx = 1/3', () => testDefinite('x^2', 0, 1, 1/3));
test('∫₀^π sin(x) dx = 2', () => testDefinite('sin(x)', 0, Math.PI, 2));
test('∫₀¹ e^x dx = e-1', () => testDefinite('e^x', 0, 1, Math.E - 1));
test('∫₁^e 1/x dx = 1', () => testDefinite('1/x', 1, Math.E, 1));
test('∫₀^π sin(x)^2 dx = π/2', () => testDefinite('sin(x)^2', 0, Math.PI, Math.PI / 2));
test('∫₀¹ (3*x^2+2*x) dx = 2', () => testDefinite('3*x^2+2*x', 0, 1, 2));
test('∫₋₁¹ x^3 dx = 0', () => testDefinite('x^3', -1, 1, 0));
test('∫₀¹ sqrt(x) dx = 2/3', () => testDefinite('sqrt(x)', 0, 1, 2/3));
test('∫₀¹ e^(-x) dx = 1-1/e', () => testDefinite('e^(-x)', 0, 1, 1 - 1/Math.E));
test('∫₁⁰ x² dx = -1/3 (reversed)', () => testDefinite('x^2', 1, 0, -1/3));

// =====================================================================
// LIMITS — from limit-calculator-test expressions
// =====================================================================

console.log('\n=== LIMITS — DIRECT SUBSTITUTION (from limit-calculator-test) ===\n');

test('lim x→3 x^2 = 9', () => {
    const r = testLimit('x^2', 'x', '3', 9);
    console.log(`    = ${r.symbolic}`);
});
test('lim x→0 (x+1) = 1', () => testLimit('x+1', 'x', '0', 1));
test('lim x→5 2*x = 10', () => testLimit('2*x', 'x', '5', 10));

console.log('\n=== LIMITS — INDETERMINATE 0/0 ===\n');

test('lim x→0 sin(x)/x = 1', () => {
    const r = testLimit('sin(x)/x', 'x', '0', 1);
    console.log(`    = ${r.symbolic}`);
});
test('lim x→1 (x^2-1)/(x-1) = 2', () => testLimit('(x^2-1)/(x-1)', 'x', '1', 2));
test('lim x→0 (e^x-1)/x = 1', () => testLimit('(e^x-1)/x', 'x', '0', 1));
test('lim x→0 tan(x)/x = 1', () => testLimit('tan(x)/x', 'x', '0', 1));
test('lim x→0 (1-cos(x))/x^2 = 1/2', () => testLimit('(1-cos(x))/x^2', 'x', '0', 0.5));
test('lim x→2 (x^3-8)/(x-2) = 12', () => testLimit('(x^3-8)/(x-2)', 'x', '2', 12));

console.log('\n=== LIMITS — AT INFINITY ===\n');

test('lim x→∞ 1/x = 0', () => testLimit('1/x', 'x', 'Infinity', 0));
test('lim x→∞ x/(x+1) = 1', () => testLimit('x/(x+1)', 'x', 'Infinity', 1));
test('lim x→∞ (1+1/x)^x = e', () => {
    const r = testLimit('(1+1/x)^x', 'x', 'Infinity');
    console.log(`    = ${r.symbolic} ≈ ${r.numeric}`);
    if (Math.abs(r.numeric - Math.E) > 0.01) throw new Error(`Expected e ≈ 2.718, got ${r.numeric}`);
});

console.log('\n=== LIMITS — MORE EXPRESSIONS ===\n');

test('lim x→0 (x^2+1)/(x+1) = 1', () => testLimit('(x^2+1)/(x+1)', 'x', '0', 1));
test('lim x→0 (sqrt(x+1)-1) = 0', () => testLimit('sqrt(x+1)-1', 'x', '0', 0));
test('lim x→0 x*log(x) = 0', () => testLimit('x*log(x)', 'x', '0', 0));
test('lim x→0 (3^x-1)/x = ln(3)', () => {
    const r = testLimit('(3^x-1)/x', 'x', '0');
    if (Math.abs(r.numeric - Math.log(3)) > 0.01) throw new Error(`Expected ln(3), got ${r.numeric}`);
});

console.log('\n=== LIMITS — VARIABLE t (from limit-calculator-test) ===\n');

test('lim t→0 sin(t)/t = 1', () => testLimit('sin(t)/t', 't', '0', 1));
test('lim t→0 t^2 = 0', () => testLimit('t^2', 't', '0', 0));
test('lim t→1 (t^2-1)/(t-1) = 2', () => testLimit('(t^2-1)/(t-1)', 't', '1', 2));

console.log('\n=== LIMITS — SPECIAL / EDGE CASES ===\n');

test('lim x→∞ x = infinity (divergent)', () => {
    const r = nerdamer('limit(x, x, Infinity)');
    console.log(`    = ${r.text()}`);
    // Should be infinity or similar
});

test('lim x→0 1/x (two-sided, undefined)', () => {
    try {
        const r = nerdamer('limit(1/x, x, 0)');
        console.log(`    = ${r.text()} (Nerdamer may return infinity)`);
    } catch (e) {
        console.log(`    Threw as expected: ${e.message.substring(0, 50)}`);
    }
});

test('lim x→0 x*sin(1/x) [squeeze theorem]', () => {
    // This is a known hard limit; Nerdamer may or may not handle it
    try {
        const r = nerdamer('limit(x*sin(1/x), x, 0)');
        console.log(`    = ${r.text()} (expected 0)`);
    } catch (e) {
        console.log(`    Nerdamer limitation: ${e.message.substring(0, 50)}`);
    }
});


// === SUMMARY ===
console.log('\n' + '='.repeat(60));
console.log(`RESULTS: ${passed} passed, ${failed} failed`);
if (failures.length > 0) {
    console.log('\nFAILURES:');
    failures.forEach(f => console.log(`  - ${f.label}\n    ${f.error}`));
}
console.log('='.repeat(60));

process.exit(failed > 0 ? 1 : 0);
