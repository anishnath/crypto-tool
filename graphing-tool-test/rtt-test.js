#!/usr/bin/env node
/**
 * Round-Trip Tests (RTT) for graphing-tool-engine.js
 *
 * Tests the LaTeX ↔ MathJS conversion pipeline and special-syntax handler matching.
 * Covers: int(), sum(), prod(), deriv() — both MathQuill and plain-text paths.
 *
 * Run: node rtt-test.js
 */

let pass = 0, fail = 0;

function assert(condition, msg) {
    if (condition) { pass++; process.stdout.write('  ✓ ' + msg + '\n'); }
    else { fail++; process.stdout.write('  ✗ FAIL: ' + msg + '\n'); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Extract the ACTUAL functions from graphing-tool-engine.js
// (copied verbatim — keep in sync with the source)
// ═══════════════════════════════════════════════════════════════════════════════

function latexToMathJS(latex) {
    if (!latex || typeof latex !== 'string') return '';
    let s = latex.trim();
    if (!s) return '';

    // Fractions
    for (let i = 0; i < 10; i++) {
        const prev = s;
        s = s.replace(/\\frac\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '(($1)/($2))');
        if (s === prev) break;
    }
    // Sqrt
    s = s.replace(/\\sqrt\[([^\]]+)\]\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, 'nthRoot($2, $1)');
    s = s.replace(/\\sqrt\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, 'sqrt($1)');

    // ── INTEGRAL / SUM / PROD — before exponents & subscripts ──
    s = s.replace(/\\[,;!]\s*d([a-zA-Z])/g, ' d$1');
    // Normalize mixed braces: \int_0^{10} → \int_{0}^{10}
    s = s.replace(/(\\(?:int|sum|prod)\s*)_([^{\s\\])(\^)/g, '$1_{$2}$3');
    // Both braced
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^\{([^{}]*)\}\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^\{([^{}]*)\}\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // Mixed: braced lower, unbraced upper
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^([^{}\s])\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^([^{}\s])\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // Both unbraced
    s = s.replace(/\\int\s*_([^{}\s])\^([^{}\s])\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_([^{}\s])\^([^{}\s])\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // No-dx braced
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^\{([^{}]+)\}\s*(.+)$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^\{([^{}]+)\}$/g, 'int(x, $1, $2)');
    // No-dx mixed
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^([^{}\s])\s*(.+)$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^([^{}\s])$/g, 'int(x, $1, $2)');
    s = s.replace(/\\int\s*(.+?)\s*d([a-zA-Z])\s*$/g, '$1');

    s = s.replace(/\\sum_\{([a-zA-Z])=([^}]+)\}\^\{([^}]+)\}\s*(.+)$/g, 'sum($1, $2, $3, $4)');
    s = s.replace(/\\sum_([a-zA-Z])=(\d+)\^(\d+)\s*(.+)$/g, 'sum($1, $2, $3, $4)');
    s = s.replace(/\\prod_\{([a-zA-Z])=([^}]+)\}\^\{([^}]+)\}\s*(.+)$/g, 'prod($1, $2, $3, $4)');
    s = s.replace(/\\prod_([a-zA-Z])=(\d+)\^(\d+)\s*(.+)$/g, 'prod($1, $2, $3, $4)');

    // Exponents
    s = s.replace(/\^\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '^($1)');
    // Subscripts
    s = s.replace(/_\{[^{}]*\}/g, '');
    s = s.replace(/_[a-zA-Z0-9]/g, '');
    // Abs
    s = s.replace(/\\left\|([^|]*?)\\right\|/g, 'abs($1)');
    s = s.replace(/\|([^|]+)\|/g, 'abs($1)');
    // Greek
    s = s.replace(/\\pi/g, 'pi');
    s = s.replace(/\\theta/g, 'theta');
    s = s.replace(/\\infty/g, 'Infinity');
    // Trig / log
    s = s.replace(/\\(sin|cos|tan|sec|csc|cot|arcsin|arccos|arctan|sinh|cosh|tanh|ln|log|exp|abs|min|max|floor|ceil|sign|round)\b/g, '$1');
    // Parens
    s = s.replace(/\\left\s*([(\[{|])/g, '$1');
    s = s.replace(/\\right\s*([)\]}|])/g, '$1');
    s = s.replace(/\\left\s*\./g, '');
    s = s.replace(/\\right\s*\./g, '');
    // Operators
    s = s.replace(/\\cdot/g, '*');
    s = s.replace(/\\times/g, '*');
    s = s.replace(/\\div/g, '/');
    // Braces
    s = s.replace(/\{/g, '(');
    s = s.replace(/\}/g, ')');
    s = s.replace(/\(\s*\)/g, '');
    // e^x
    s = s.replace(/(?<![a-zA-Z])e\^\(([^)]+)\)/g, 'exp($1)');
    s = s.replace(/(?<![a-zA-Z])e\^([a-zA-Z0-9])/g, 'exp($1)');
    // Cleanup
    s = s.replace(/\\ /g, ' ');
    s = s.replace(/\\,/g, '');
    s = s.replace(/\\;/g, '');
    s = s.replace(/\\!/g, '');
    s = s.replace(/\\text\{([^}]*)\}/g, '$1');
    s = s.replace(/\\mathrm\{([^}]*)\}/g, '$1');
    s = s.replace(/\\operatorname\{([^}]*)\}/g, '$1');
    s = s.replace(/\\[a-zA-Z]+/g, '');
    s = s.replace(/\s+/g, ' ').trim();
    return s;
}

function mathJSToLatex(expr) {
    if (!expr || typeof expr !== 'string') return '';
    var intMatch = expr.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) {
        var body = mathJSToLatex(intMatch[1].trim());
        return '\\int_{' + intMatch[2].trim() + '}^{' + intMatch[3].trim() + '}' + body + '\\,dx';
    }
    var sumMatch = expr.match(/^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (sumMatch) {
        var sBody = mathJSToLatex(sumMatch[4].trim());
        return '\\sum_{' + sumMatch[1] + '=' + sumMatch[2].trim() + '}^{' + sumMatch[3].trim() + '}' + sBody;
    }
    var prodMatch = expr.match(/^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (prodMatch) {
        var pBody = mathJSToLatex(prodMatch[4].trim());
        return '\\prod_{' + prodMatch[1] + '=' + prodMatch[2].trim() + '}^{' + prodMatch[3].trim() + '}' + pBody;
    }
    return expr; // fallback
}

// Simulates _handleSpecialSyntaxFromInput regex matching
function handlerMatch(value) {
    var s = value.trim();
    var intMatch = s.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) return { type: 'int', expr: intMatch[1].trim(), a: intMatch[2].trim(), b: intMatch[3].trim() };
    var sumMatch = s.match(/^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (sumMatch) return { type: 'sum', v: sumMatch[1], start: sumMatch[2].trim(), end: sumMatch[3].trim(), body: sumMatch[4].trim() };
    var prodMatch = s.match(/^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (prodMatch) return { type: 'prod', v: prodMatch[1], start: prodMatch[2].trim(), end: prodMatch[3].trim(), body: prodMatch[4].trim() };
    var derivMatch = s.match(/^\s*deriv\s*\(\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (derivMatch) return { type: 'deriv', expr: derivMatch[1].trim(), x0: derivMatch[2].trim() };
    return null;
}

// Simulates _evaluateNumeric int() regex matching
function evalNumericIntMatch(value) {
    var s = value.trim();
    var intMatch = s.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) return { expr: intMatch[1].trim(), a: intMatch[2].trim(), b: intMatch[3].trim() };
    return null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 1: latexToMathJS — MathQuill LaTeX → plain math
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 1: latexToMathJS (MathQuill LaTeX → MathJS)      ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

// Integrals
assert(latexToMathJS('\\int_{0}^{1}x^{2}dx') === 'int(x^(2), 0, 1)', 'int 0..1 x^2 dx (no space)');
assert(latexToMathJS('\\int_{0}^{1}x^{2}\\,dx') === 'int(x^(2), 0, 1)', 'int 0..1 x^2 \\,dx (thin space)');
assert(latexToMathJS('\\int_{0}^{1}x^{2} dx') === 'int(x^(2), 0, 1)', 'int 0..1 x^2 dx (with space)');
assert(latexToMathJS('\\int_{0}^{10}x^{2}dx') === 'int(x^(2), 0, 10)', 'int 0..10 x^2 dx (multi-digit bound)');
assert(latexToMathJS('\\int_{0}^{10}x^{2}\\,dx') === 'int(x^(2), 0, 10)', 'int 0..10 x^2 \\,dx (multi-digit + thin space)');
assert(latexToMathJS('\\int_{0}^{\\pi}\\sin x\\,dx') === 'int(sin x, 0, pi)', 'int 0..pi sin(x) dx (Greek bound)');
assert(latexToMathJS('\\int_{-1}^{1}x^{3}dx') === 'int(x^(3), -1, 1)', 'int -1..1 x^3 dx (negative bound)');
assert(latexToMathJS('\\int_{0}^{2\\pi}\\cos x\\,dx') === 'int(cos x, 0, 2pi)', 'int 0..2pi cos(x) dx');

// No-dx fallback (MathQuill user hasn't typed dx yet)
assert(latexToMathJS('\\int_{0}^{1}x^{2}') === 'int(x^(2), 0, 1)', 'int no-dx: \\int_{0}^{1}x^{2}');
assert(latexToMathJS('\\int_{0}^{10}x^{2}') === 'int(x^(2), 0, 10)', 'int no-dx: \\int_{0}^{10}x^{2}');
assert(latexToMathJS('\\int_{0}^{10}') === 'int(x, 0, 10)', 'int bounds only: \\int_{0}^{10}');

// MathQuill mixed-brace bounds (THE critical bug: MQ outputs \int_0^{10} for single-char lower)
assert(latexToMathJS('\\int_0^{10}x^2dx') === 'int(x^2, 0, 10)', 'MQ mixed: \\int_0^{10}x^2dx (exact MQ output)');
assert(latexToMathJS('\\int_0^{10}x^{2}dx') === 'int(x^(2), 0, 10)', 'MQ mixed: \\int_0^{10}x^{2}dx (braced exponent)');
assert(latexToMathJS('\\int_0^{10}x^{2}\\,dx') === 'int(x^(2), 0, 10)', 'MQ mixed: \\int_0^{10}x^{2}\\,dx (thin space)');
assert(latexToMathJS('\\int_0^{10}x^{2} dx') === 'int(x^(2), 0, 10)', 'MQ mixed: \\int_0^{10}x^{2} dx (with space)');
assert(latexToMathJS('\\int_0^{1}x^{2}dx') === 'int(x^(2), 0, 1)', 'MQ mixed: \\int_0^{1}x^{2}dx (single upper too)');
assert(latexToMathJS('\\int_0^{\\pi}\\sin x\\,dx') === 'int(sin x, 0, pi)', 'MQ mixed: \\int_0^{\\pi}sin x dx');
assert(latexToMathJS('\\int_1^{10}x^{2}dx') === 'int(x^(2), 1, 10)', 'MQ mixed: \\int_1^{10}x^{2}dx');
assert(latexToMathJS('\\int_0^{10}x^{2}') === 'int(x^(2), 0, 10)', 'MQ mixed no-dx: \\int_0^{10}x^{2}');
assert(latexToMathJS('\\int_0^{10}') === 'int(x, 0, 10)', 'MQ mixed bounds only: \\int_0^{10}');
// Reverse mixed: unbraced upper, braced lower (less common but possible)
assert(latexToMathJS('\\int_{0}^1x^{2}dx') === 'int(x^(2), 0, 1)', 'reverse mixed: \\int_{0}^1x^{2}dx');

// Indefinite
assert(latexToMathJS('\\int x^{2} dx') === 'x^(2)', 'indefinite int → bare expression');

// Plain text passthrough
assert(latexToMathJS('int(x^2, 0, 1)') === 'int(x^2, 0, 1)', 'plain int() passthrough');

// Summation
assert(latexToMathJS('\\sum_{n=1}^{10}n^{2}') === 'sum(n, 1, 10, n^(2))', 'sum n=1..10 n^2');
assert(latexToMathJS('\\sum_{k=0}^{100}k') === 'sum(k, 0, 100, k)', 'sum k=0..100 k');

// Product
assert(latexToMathJS('\\prod_{n=1}^{5}n') === 'prod(n, 1, 5, n)', 'prod n=1..5 n (factorial)');

// Normal expressions (should NOT produce int/sum/prod)
assert(latexToMathJS('2+3') === '2+3', 'normal: 2+3');
assert(latexToMathJS('x^{2}') === 'x^(2)', 'normal: x^2');
assert(latexToMathJS('\\sin\\left(\\frac{\\pi}{4}\\right)') === 'sin(((pi)/(4)))', 'normal: sin(pi/4)');
assert(latexToMathJS('\\sqrt{2}') === 'sqrt(2)', 'normal: sqrt(2)');
assert(latexToMathJS('e^{2}') === 'exp(2)', 'normal: e^2');

// Mid-entry states (should NOT crash, may produce empty/garbage — that's OK)
const midEntry = latexToMathJS('\\int');
assert(midEntry === '' || !midEntry.includes('Error'), 'mid-entry: \\int → safe');
const midEntry2 = latexToMathJS('\\int_{0}^{}');
assert(typeof midEntry2 === 'string', 'mid-entry: \\int_{0}^{} → string');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 2: mathJSToLatex (reverse direction)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 2: mathJSToLatex (MathJS → LaTeX for MQ)         ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

assert(mathJSToLatex('int(x^2, 0, 1)') === '\\int_{0}^{1}x^2\\,dx', 'int(x^2,0,1) → LaTeX');
assert(mathJSToLatex('int(x^2, 0, 10)') === '\\int_{0}^{10}x^2\\,dx', 'int(x^2,0,10) → LaTeX');
assert(mathJSToLatex('sum(n, 1, 10, n^2)') === '\\sum_{n=1}^{10}n^2', 'sum → LaTeX');
assert(mathJSToLatex('prod(n, 1, 5, n)') === '\\prod_{n=1}^{5}n', 'prod → LaTeX');
assert(mathJSToLatex('x^2') === 'x^2', 'normal expr passthrough');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 3: Handler matching (_handleSpecialSyntaxFromInput)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 3: Handler matching                               ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

// Plain text input
let h;
h = handlerMatch('int(x^2, 0, 1)');
assert(h && h.type === 'int' && h.expr === 'x^2' && h.a === '0' && h.b === '1', 'plain: int(x^2, 0, 1)');

h = handlerMatch('int(x^2, 0, 10)');
assert(h && h.type === 'int' && h.expr === 'x^2' && h.a === '0' && h.b === '10', 'plain: int(x^2, 0, 10)');

h = handlerMatch('int(sin(x), 0, pi)');
assert(h && h.type === 'int' && h.expr === 'sin(x)' && h.a === '0' && h.b === 'pi', 'plain: int(sin(x), 0, pi)');

// MathQuill-converted input (from latexToMathJS)
h = handlerMatch('int(x^(2), 0, 1)');
assert(h && h.type === 'int' && h.expr === 'x^(2)' && h.a === '0' && h.b === '1', 'MQ: int(x^(2), 0, 1)');

h = handlerMatch('int(x^(2), 0, 10)');
assert(h && h.type === 'int' && h.expr === 'x^(2)' && h.a === '0' && h.b === '10', 'MQ: int(x^(2), 0, 10)');

h = handlerMatch('int(sin x, 0, pi)');
assert(h && h.type === 'int' && h.expr === 'sin x' && h.a === '0' && h.b === 'pi', 'MQ: int(sin x, 0, pi)');

h = handlerMatch('int(cos x, 0, 2pi)');
assert(h && h.type === 'int' && h.expr === 'cos x' && h.a === '0' && h.b === '2pi', 'MQ: int(cos x, 0, 2pi)');

// Sum/prod
h = handlerMatch('sum(n, 1, 10, n^2)');
assert(h && h.type === 'sum' && h.v === 'n' && h.end === '10' && h.body === 'n^2', 'plain: sum(n,1,10,n^2)');

h = handlerMatch('sum(n, 1, 10, n^(2))');
assert(h && h.type === 'sum' && h.v === 'n' && h.body === 'n^(2)', 'MQ: sum(n,1,10,n^(2))');

h = handlerMatch('prod(n, 1, 5, n)');
assert(h && h.type === 'prod' && h.v === 'n' && h.end === '5', 'plain: prod(n,1,5,n)');

// Deriv
h = handlerMatch('deriv(x^2, 3)');
assert(h && h.type === 'deriv' && h.expr === 'x^2' && h.x0 === '3', 'plain: deriv(x^2, 3)');

h = handlerMatch('deriv(x^(2), 3)');
assert(h && h.type === 'deriv' && h.expr === 'x^(2)' && h.x0 === '3', 'MQ: deriv(x^(2), 3)');

// Non-matching (normal expressions)
assert(handlerMatch('x^2') === null, 'x^2 → no match');
assert(handlerMatch('2+3') === null, '2+3 → no match');
assert(handlerMatch('sin(x)') === null, 'sin(x) → no match');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 4: _evaluateNumeric int() matching
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 4: _evaluateNumeric int() regex                   ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

let e;
e = evalNumericIntMatch('int(x^2, 0, 1)');
assert(e && e.a === '0' && e.b === '1', 'evalNum: int(x^2, 0, 1)');

e = evalNumericIntMatch('int(x^2, 0, 10)');
assert(e && e.a === '0' && e.b === '10', 'evalNum: int(x^2, 0, 10)');

e = evalNumericIntMatch('int(x^(2), 0, 10)');
assert(e && e.a === '0' && e.b === '10', 'evalNum: int(x^(2), 0, 10)');

e = evalNumericIntMatch('int(sin(x), 0, pi)');
assert(e && e.b === 'pi', 'evalNum: int(sin(x), 0, pi)');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 5: FULL ROUND-TRIP  plain → LaTeX → MathJS → handler
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 5: Full Round-Trip (Plain → LaTeX → MathJS → H)  ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

function rtt(plain, desc) {
    const latex = mathJSToLatex(plain);
    const back = latexToMathJS(latex);
    const h1 = handlerMatch(plain);
    const h2 = handlerMatch(back);
    const h1Type = h1 ? h1.type : null;
    const h2Type = h2 ? h2.type : null;
    const typeMatch = h1Type === h2Type;
    // For int: check bounds survive
    let boundsMatch = true;
    if (h1 && h2 && h1.type === 'int') {
        boundsMatch = h1.a === h2.a && h1.b === h2.b;
    }
    if (h1 && h2 && h1.type === 'sum') {
        boundsMatch = h1.start === h2.start && h1.end === h2.end;
    }
    assert(typeMatch && boundsMatch, `RTT ${desc}: "${plain}" → "${latex}" → "${back}" → handler ${h2Type}`);
    if (!typeMatch) console.log(`    Expected handler type ${h1Type}, got ${h2Type}`);
    if (!boundsMatch) console.log(`    Bounds mismatch: ${JSON.stringify(h1)} vs ${JSON.stringify(h2)}`);
}

rtt('int(x^2, 0, 1)', 'int basic');
rtt('int(x^2, 0, 10)', 'int multi-digit bound');
rtt('int(sin(x), 0, pi)', 'int with pi');
rtt('int(x^3, -1, 1)', 'int negative bound');
rtt('int(1/x, 1, 10)', 'int 1/x');
rtt('sum(n, 1, 10, n^2)', 'sum basic');
rtt('sum(k, 0, 100, k)', 'sum k 0..100');
rtt('prod(n, 1, 5, n)', 'prod basic');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 6: MathQuill → MathJS → handler (simulating actual MQ output)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 6: MathQuill Realistic LaTeX → Handler            ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

function mqTest(mqLatex, expectedType, expectedExpr, expectedA, expectedB, desc) {
    const mathJS = latexToMathJS(mqLatex);
    const h = handlerMatch(mathJS);
    const ok = h && h.type === expectedType;
    const exprOk = !expectedExpr || (h && h.expr === expectedExpr);
    const aOk = !expectedA || (h && h.a === expectedA);
    const bOk = !expectedB || (h && h.b === expectedB);
    assert(ok && exprOk && aOk && bOk, `MQ ${desc}: "${mqLatex}" → "${mathJS}"`);
    if (!ok) console.log(`    Handler: ${JSON.stringify(h)}`);
    if (!exprOk && h) console.log(`    Expr: expected "${expectedExpr}", got "${h.expr}"`);
    if (!aOk && h) console.log(`    Bound a: expected "${expectedA}", got "${h.a}"`);
    if (!bOk && h) console.log(`    Bound b: expected "${expectedB}", got "${h.b}"`);
}

// What MathQuill ACTUALLY produces (various styles)
mqTest('\\int_{0}^{1}x^{2}dx', 'int', 'x^(2)', '0', '1', 'int 0..1 compact');
mqTest('\\int_{0}^{1}x^{2}\\,dx', 'int', 'x^(2)', '0', '1', 'int 0..1 thin-space');
mqTest('\\int_{0}^{10}x^{2}dx', 'int', 'x^(2)', '0', '10', 'int 0..10 compact');
mqTest('\\int_{0}^{10}x^{2}\\,dx', 'int', 'x^(2)', '0', '10', 'int 0..10 thin-space');
mqTest('\\int_{0}^{10}x^{2}', 'int', 'x^(2)', '0', '10', 'int 0..10 no-dx');
mqTest('\\int_{-1}^{1}x^{3}dx', 'int', 'x^(3)', '-1', '1', 'int -1..1');
mqTest('\\int_{0}^{\\pi}\\sin x\\,dx', 'int', null, '0', 'pi', 'int 0..pi sin');
mqTest('\\sum_{n=1}^{10}n^{2}', 'sum', null, null, null, 'sum n=1..10');
mqTest('\\prod_{n=1}^{5}n', 'prod', null, null, null, 'prod n=1..5');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 7: Mid-entry states (should not produce unhandled int() strings)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 7: Mid-entry States (safety)                      ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

function midEntryTest(mqLatex, desc) {
    const mathJS = latexToMathJS(mqLatex);
    const h = handlerMatch(mathJS);
    const hasUnhandledInt = !h && /^\s*int\s*\(/.test(mathJS);
    assert(!hasUnhandledInt, `Mid-entry safe: ${desc} → "${mathJS}" ${h ? '(handler matched)' : '(no int())'}`);
    if (hasUnhandledInt) console.log(`    ⚠ Would cause createTrace error!`);
}

midEntryTest('\\int', 'just \\int');
midEntryTest('\\int_{0}', '\\int_{0}');
midEntryTest('\\int_{0}^{}', '\\int_{0}^{empty}');
midEntryTest('\\int_{0}^{1}', '\\int_{0}^{1} (no body)');
midEntryTest('\\int_{0}^{10}', '\\int_{0}^{10} (no body)');
midEntryTest('\\int_{0}^{10}x', '\\int_{0}^{10}x (partial body)');
midEntryTest('\\int_{0}^{10}x^{2}', '\\int_{0}^{10}x^{2} (no dx)');
midEntryTest('\\int_{}^{}', '\\int_{empty}^{empty}');
midEntryTest('\\int_{}^{10}x^{2}', '\\int_{empty}^{10}x^{2}');
midEntryTest('\\sum_{n=}^{}', '\\sum partial');
midEntryTest('\\sum_{n=1}^{}', '\\sum partial 2');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 8: Complex Expressions — fractions, nested trig, expression bounds, etc.
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 8: Complex Expression Variants                    ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

// --- 8a: Fraction integrands ---
assert(
    latexToMathJS('\\int_{0}^{1}\\frac{1}{x+1}dx') === 'int(((1)/(x+1)), 0, 1)',
    'frac integrand: \\int_0^1 1/(x+1) dx'
);
assert(
    latexToMathJS('\\int_{1}^{10}\\frac{x^{2}}{2}dx') === 'int(((x^(2))/(2)), 1, 10)',
    'frac integrand: \\int_1^{10} x^2/2 dx'
);
assert(
    latexToMathJS('\\int_{0}^{\\pi}\\frac{\\sin x}{x}dx') === 'int(((sin x)/(x)), 0, pi)',
    'frac integrand: sinc-like \\int_0^pi sin(x)/x dx'
);
// Mixed-brace + fraction
assert(
    latexToMathJS('\\int_0^{1}\\frac{1}{x+1}dx') === 'int(((1)/(x+1)), 0, 1)',
    'mixed-brace + frac: \\int_0^{1} 1/(x+1) dx'
);

// --- 8b: Sqrt integrands ---
assert(
    latexToMathJS('\\int_{0}^{4}\\sqrt{x}dx') === 'int(sqrt(x), 0, 4)',
    'sqrt integrand: \\int_0^4 sqrt(x) dx'
);
assert(
    latexToMathJS('\\int_{0}^{1}\\sqrt{1-x^{2}}dx') === 'int(sqrt(1-x^(2)), 0, 1)',
    'sqrt integrand: semicircle \\int_0^1 sqrt(1-x^2) dx'
);

// --- 8c: Trig integrands with \left \right ---
assert(
    latexToMathJS('\\int_{0}^{\\pi}\\sin\\left(2x\\right)dx') === 'int(sin(2x), 0, pi)',
    'trig \\left(\\right): \\int_0^pi sin(2x) dx'
);
assert(
    latexToMathJS('\\int_{0}^{2\\pi}\\cos\\left(\\frac{x}{2}\\right)dx') === 'int(cos(((x)/(2))), 0, 2pi)',
    'trig + frac: \\int_0^{2pi} cos(x/2) dx'
);

// --- 8d: Expression bounds (e.g. 2*pi, pi/2) ---
assert(
    latexToMathJS('\\int_{0}^{2\\pi}x\\,dx') === 'int(x, 0, 2pi)',
    'expr bound 2pi: \\int_0^{2pi} x dx'
);
// pi/2 as a fraction bound
assert(
    latexToMathJS('\\int_{0}^{\\frac{\\pi}{2}}\\sin x\\,dx') === 'int(sin x, 0, ((pi)/(2)))',
    'frac bound: \\int_0^{pi/2} sin x dx'
);
// Negative expression bound
assert(
    latexToMathJS('\\int_{-\\pi}^{\\pi}\\cos x\\,dx') === 'int(cos x, -pi, pi)',
    'expr bound: \\int_{-pi}^{pi} cos x dx'
);

// --- 8e: Product/multiply in integrand ---
assert(
    latexToMathJS('\\int_{0}^{1}x\\cdot e^{x}dx') === 'int(x* exp(x), 0, 1)',
    'cdot integrand: x*e^x'
);
assert(
    latexToMathJS('\\int_{0}^{1}2x\\,dx') === 'int(2x, 0, 1)',
    'simple coefficient: 2x'
);

// --- 8f: e^x / exp integrands ---
assert(
    latexToMathJS('\\int_{0}^{1}e^{x}dx') === 'int(exp(x), 0, 1)',
    'e^x integrand'
);
assert(
    latexToMathJS('\\int_{0}^{1}e^{-x}dx') === 'int(exp(-x), 0, 1)',
    'e^{-x} integrand'
);
assert(
    latexToMathJS('\\int_{0}^{1}e^{x^{2}}dx') === 'int(exp(x^(2)), 0, 1)',
    'e^{x^2} integrand (Gaussian-like)'
);

// --- 8g: Absolute value ---
assert(
    latexToMathJS('\\int_{-1}^{1}\\left|x\\right|dx') === 'int(abs(x), -1, 1)',
    'abs integrand: |x|'
);

// --- 8h: ln / log ---
assert(
    latexToMathJS('\\int_{1}^{10}\\ln x\\,dx') === 'int(ln x, 1, 10)',
    'ln integrand'
);
assert(
    latexToMathJS('\\int_{1}^{10}\\log x\\,dx') === 'int(log x, 1, 10)',
    'log integrand'
);

// --- 8i: Complex nested: frac inside sqrt inside integral ---
assert(
    latexToMathJS('\\int_{0}^{1}\\sqrt{\\frac{1}{x+1}}dx') === 'int(sqrt(((1)/(x+1))), 0, 1)',
    'nested: sqrt(1/(x+1)) integrand'
);

// --- 8j: Mixed-brace with complex body ---
assert(
    latexToMathJS('\\int_0^{\\pi}\\sin x\\cdot\\cos x\\,dx') === 'int(sin x*cos x, 0, pi)',
    'mixed-brace complex: sin(x)*cos(x)'
);
assert(
    latexToMathJS('\\int_1^{100}\\frac{1}{x}dx') === 'int(((1)/(x)), 1, 100)',
    'mixed-brace + frac: 1/x from 1 to 100'
);

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 9: Complex RTT — plain → LaTeX → MathJS → handler (complex expressions)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 9: Complex Round-Trip Variants                    ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

rtt('int(x^3, 0, 2)', 'int x^3');
rtt('int(sin(x)*cos(x), 0, pi)', 'int trig product');
rtt('int(exp(x), 0, 1)', 'int exp(x)');
rtt('int(1/(x+1), 0, 1)', 'int rational');
rtt('int(sqrt(x), 0, 4)', 'int sqrt(x)');
rtt('int(ln(x), 1, 10)', 'int ln(x)');
rtt('int(x^2+x+1, 0, 5)', 'int polynomial');
rtt('int(abs(x), -1, 1)', 'int abs(x)');
rtt('sum(n, 1, 100, 1/n^2)', 'sum Basel partial');
rtt('sum(k, 0, 10, 2^k)', 'sum geometric');
rtt('prod(n, 1, 10, n)', 'prod 10!');
rtt('prod(k, 1, 5, k^2)', 'prod k^2');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 10: Complex MQ LaTeX → Handler (realistic MathQuill output)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 10: Complex MathQuill → Handler                   ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

// Fraction integrand from MathQuill
mqTest('\\int_{0}^{1}\\frac{1}{x+1}dx', 'int', null, '0', '1', 'MQ frac integrand 1/(x+1)');
mqTest('\\int_{1}^{10}\\frac{x^{2}}{2}\\,dx', 'int', null, '1', '10', 'MQ frac x^2/2');

// Sqrt from MQ
mqTest('\\int_{0}^{4}\\sqrt{x}dx', 'int', 'sqrt(x)', '0', '4', 'MQ sqrt integrand');
mqTest('\\int_{0}^{1}\\sqrt{1-x^{2}}dx', 'int', null, '0', '1', 'MQ semicircle sqrt');

// e^x from MQ
mqTest('\\int_{0}^{1}e^{x}dx', 'int', 'exp(x)', '0', '1', 'MQ e^x');
mqTest('\\int_{0}^{1}e^{-x}dx', 'int', 'exp(-x)', '0', '1', 'MQ e^{-x}');

// Mixed-brace + complex body
mqTest('\\int_0^{\\pi}\\sin\\left(2x\\right)dx', 'int', null, '0', 'pi', 'MQ mixed sin(2x)');
mqTest('\\int_0^{1}\\frac{1}{x+1}dx', 'int', null, '0', '1', 'MQ mixed frac');
mqTest('\\int_0^{4}\\sqrt{x}\\,dx', 'int', 'sqrt(x)', '0', '4', 'MQ mixed sqrt');

// Expression bounds from MQ
mqTest('\\int_{0}^{2\\pi}\\cos x\\,dx', 'int', null, '0', '2pi', 'MQ bound 2pi');
mqTest('\\int_{-\\pi}^{\\pi}\\cos x\\,dx', 'int', null, '-pi', 'pi', 'MQ bound -pi..pi');
mqTest('\\int_{0}^{\\frac{\\pi}{2}}\\sin x\\,dx', 'int', null, '0', '((pi)/(2))', 'MQ frac bound pi/2');

// Absolute value from MQ
mqTest('\\int_{-1}^{1}\\left|x\\right|dx', 'int', 'abs(x)', '-1', '1', 'MQ abs(x)');

// ln/log from MQ
mqTest('\\int_{1}^{10}\\ln x\\,dx', 'int', 'ln x', '1', '10', 'MQ ln x');

// cdot multiply from MQ
mqTest('\\int_{0}^{1}x\\cdot e^{x}dx', 'int', null, '0', '1', 'MQ x*e^x cdot');

// Sum with complex body from MQ
mqTest('\\sum_{n=1}^{100}\\frac{1}{n^{2}}', 'sum', null, null, null, 'MQ sum 1/n^2 (Basel)');
mqTest('\\sum_{k=0}^{10}2^{k}', 'sum', null, null, null, 'MQ sum 2^k geometric');

// Prod from MQ
mqTest('\\prod_{n=1}^{10}n', 'prod', null, null, null, 'MQ prod 10!');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 11: Edge Cases & Adversarial Inputs
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 11: Edge Cases & Adversarial Inputs               ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

// Whitespace variations
assert(
    latexToMathJS('\\int_{0}^{1}  x^{2}  dx') === 'int(x^(2), 0, 1)',
    'extra whitespace in integrand'
);
assert(
    latexToMathJS('  \\int_{0}^{1}x^{2}dx  ') === 'int(x^(2), 0, 1)',
    'leading/trailing whitespace'
);

// Single-char variable (not x)
assert(
    latexToMathJS('\\int_{0}^{1}t^{2}dt') === 'int(t^(2), 0, 1)',
    'variable t: \\int_0^1 t^2 dt'
);
assert(
    latexToMathJS('\\int_{0}^{1}u^{3}du') === 'int(u^(3), 0, 1)',
    'variable u: \\int_0^1 u^3 du'
);

// Bounds with negative multi-digit
assert(
    latexToMathJS('\\int_{-10}^{10}x^{2}dx') === 'int(x^(2), -10, 10)',
    'negative multi-digit bound: -10 to 10'
);

// Very large bounds
assert(
    latexToMathJS('\\int_{0}^{1000}x\\,dx') === 'int(x, 0, 1000)',
    'large bound: 0 to 1000'
);

// Decimal bounds
assert(
    latexToMathJS('\\int_{0.5}^{1.5}x\\,dx') === 'int(x, 0.5, 1.5)',
    'decimal bounds: 0.5 to 1.5'
);

// Chained operations in integrand
assert(
    latexToMathJS('\\int_{0}^{1}x^{2}+x+1\\,dx') === 'int(x^(2)+x+1, 0, 1)',
    'polynomial integrand: x^2+x+1'
);

// \times in integrand
assert(
    latexToMathJS('\\int_{0}^{1}2\\times x\\,dx') === 'int(2* x, 0, 1)',
    '\\times in integrand'
);

// Empty / null / undefined safety
assert(latexToMathJS('') === '', 'empty string');
assert(latexToMathJS(null) === '', 'null input');
assert(latexToMathJS(undefined) === '', 'undefined input');
assert(mathJSToLatex('') === '', 'mathJSToLatex empty');
assert(mathJSToLatex(null) === '', 'mathJSToLatex null');
assert(handlerMatch('') === null, 'handler empty');
assert(handlerMatch('   ') === null, 'handler whitespace');

// Should NOT false-positive as int()
assert(handlerMatch('interpret(x)') === null, 'not int: interpret(x)');
assert(handlerMatch('integer(5)') === null, 'not int: integer(5)');
assert(handlerMatch('interval(0,1)') === null, 'not int: interval(0,1)');

// Mixed-brace mid-entry with complex partial
midEntryTest('\\int_0^{}', 'MQ mixed empty upper');
midEntryTest('\\int_0^{10}', 'MQ mixed bounds only (no body)');
midEntryTest('\\int_0^{\\pi}', 'MQ mixed pi upper (no body)');
midEntryTest('\\int_0^{10}x', 'MQ mixed partial body x');

// Sum/prod mid-entry
midEntryTest('\\sum_{n=1}^{}', 'sum empty upper');
midEntryTest('\\sum_{n=1}^{10}', 'sum no body');
midEntryTest('\\prod_{n=1}^{}', 'prod empty upper');

// ═══════════════════════════════════════════════════════════════════════════════
// TEST 12: Full Pipeline — MQ LaTeX → MathJS → LaTeX → MathJS (double RTT)
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║  TEST 12: Double Round-Trip (MQ → MathJS → LaTeX → MJ) ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

function doubleRTT(mqLatex, desc) {
    const mathJS1 = latexToMathJS(mqLatex);
    const h1 = handlerMatch(mathJS1);
    if (!h1) {
        assert(false, `dRTT ${desc}: first conversion failed → "${mathJS1}"`);
        return;
    }
    const latex2 = mathJSToLatex(mathJS1);
    const mathJS2 = latexToMathJS(latex2);
    const h2 = handlerMatch(mathJS2);
    const typeOk = h2 && h1.type === h2.type;
    let boundsOk = true;
    if (h1.type === 'int' && h2) boundsOk = h1.a === h2.a && h1.b === h2.b;
    if (h1.type === 'sum' && h2) boundsOk = h1.start === h2.start && h1.end === h2.end;
    assert(typeOk && boundsOk, `dRTT ${desc}: "${mqLatex}" → "${mathJS1}" → "${latex2}" → "${mathJS2}"`);
    if (!typeOk) console.log(`    Type: ${h1.type} → ${h2 ? h2.type : 'null'}`);
    if (!boundsOk) console.log(`    Bounds: ${JSON.stringify(h1)} vs ${JSON.stringify(h2)}`);
}

// MQ → MathJS → LaTeX → MathJS (simulates toggle: MQ mode → plain → MQ → plain)
doubleRTT('\\int_{0}^{1}x^{2}dx', 'basic int');
doubleRTT('\\int_{0}^{10}x^{2}dx', 'multi-digit');
doubleRTT('\\int_0^{10}x^{2}dx', 'mixed-brace');
doubleRTT('\\int_0^{1}x^{2}dx', 'mixed-brace single');
doubleRTT('\\int_{-1}^{1}x^{3}dx', 'negative bound');
doubleRTT('\\int_{0}^{\\pi}\\sin x\\,dx', 'trig + pi bound');
doubleRTT('\\int_{0}^{1}\\frac{1}{x+1}dx', 'frac integrand');
doubleRTT('\\int_{0}^{4}\\sqrt{x}dx', 'sqrt integrand');
doubleRTT('\\int_{0}^{1}e^{x}dx', 'e^x integrand');
doubleRTT('\\int_{-1}^{1}\\left|x\\right|dx', 'abs integrand');
doubleRTT('\\sum_{n=1}^{10}n^{2}', 'sum basic');
doubleRTT('\\prod_{n=1}^{5}n', 'prod basic');

// ═══════════════════════════════════════════════════════════════════════════════
// SUMMARY
// ═══════════════════════════════════════════════════════════════════════════════
console.log('\n════════════════════════════════════════════════════════════');
console.log(`  RESULTS: ${pass} passed, ${fail} failed`);
console.log('════════════════════════════════════════════════════════════\n');
process.exit(fail > 0 ? 1 : 0);
