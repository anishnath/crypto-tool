/**
 * Test all expression types used in graphing-calculator.jsp
 * Tests both raw math.js evaluation and the normalizeExpression fixes.
 * Run: node test-graphing-expressions.cjs
 */
const math = require('mathjs');

let passed = 0, failed = 0;
const failures = [];

function test(label, fn) {
    try {
        const result = fn();
        if (result === false) throw new Error('returned false');
        passed++;
    } catch (e) {
        failed++;
        failures.push({ label, error: e.message || String(e) });
        console.log(`  FAIL: ${label} -> ${e.message}`);
    }
}

// Simulate engine's normalizeExpression
function normalize(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    let s = expr.trim();
    s = s.replace(/\*\*/g, '^');
    s = s.replace(/\bln\s*\(/g, 'log(');
    return s;
}

function stripCartesianPrefix(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    return expr.replace(/^\s*y\s*=\s*/i, '');
}

function evalCartesian(expr, x = 1) {
    let e = normalize(expr);
    e = stripCartesianPrefix(e);
    const compiled = math.compile(e);
    const y = compiled.evaluate({ x });
    if (typeof y !== 'number' || !isFinite(y)) throw new Error(`Got ${y} for x=${x}`);
    return y;
}

function evalPolar(expr, theta = 1) {
    const compiled = math.compile(normalize(expr));
    const r = compiled.evaluate({ theta, 'θ': theta });
    if (typeof r !== 'number' || !isFinite(r)) throw new Error(`Got ${r} for theta=${theta}`);
    return r;
}

function evalParametric(exprStr, t = 1) {
    const [xExpr, yExpr] = exprStr.split(',').map(e => e.trim());
    const xc = math.compile(normalize(xExpr));
    const yc = math.compile(normalize(yExpr));
    const xVal = xc.evaluate({ t });
    const yVal = yc.evaluate({ t });
    if (!isFinite(xVal) || !isFinite(yVal)) throw new Error(`Got (${xVal}, ${yVal}) for t=${t}`);
    return [xVal, yVal];
}

function evalImplicit(expr, x = 1, y = 1) {
    let leftExpr, rightExpr;
    if (expr.includes('=')) {
        const parts = expr.split('=');
        leftExpr = parts[0].trim();
        rightExpr = parts[1].trim();
    } else {
        leftExpr = expr; rightExpr = '0';
    }
    const lc = math.compile(normalize(leftExpr));
    const rc = math.compile(normalize(rightExpr));
    const lv = lc.evaluate({ x, y });
    const rv = rc.evaluate({ x, y });
    if (!isFinite(lv) || !isFinite(rv)) throw new Error(`Got ${lv} - ${rv}`);
    return lv - rv;
}

function evalInequality(expr, x = 1, y = 1) {
    const match = expr.match(/(.+?)(>=|<=|>|<)(.+)/);
    if (!match) throw new Error(`Can't parse inequality: ${expr}`);
    const lc = math.compile(normalize(match[1].trim()));
    const rc = math.compile(normalize(match[3].trim()));
    const lv = lc.evaluate({ x, y });
    const rv = rc.evaluate({ x, y });
    if (!isFinite(lv) || !isFinite(rv)) throw new Error(`Got ${lv} vs ${rv}`);
    return true;
}

console.log('\n=== CARTESIAN EXPRESSIONS ===');

// Basic
test('sin(x)', () => evalCartesian('sin(x)'));
test('cos(x)', () => evalCartesian('cos(x)'));
test('tan(x)', () => evalCartesian('tan(x)', 0.5));
test('cos(x)*sin(x)', () => evalCartesian('cos(x)*sin(x)'));
test('x^2', () => evalCartesian('x^2'));
test('x^3', () => evalCartesian('x^3'));
test('x^3 - 3*x^2 + 2*x', () => evalCartesian('x^3 - 3*x^2 + 2*x'));
test('x^4 - 5*x^2 + 4', () => evalCartesian('x^4 - 5*x^2 + 4'));
test('sqrt(x)', () => evalCartesian('sqrt(x)', 4));
test('abs(x)', () => evalCartesian('abs(x)', -3));
test('1/x', () => evalCartesian('1/x', 2));
test('exp(x)', () => evalCartesian('exp(x)'));
test('log(x)', () => evalCartesian('log(x)', 2));

// From presets
test('1/(1+exp(-x)) [sigmoid]', () => evalCartesian('1/(1+exp(-x))'));
test('0.2*exp(0.3*x)', () => evalCartesian('0.2*exp(0.3*x)'));
test('x^2 - 2*x + 1', () => evalCartesian('x^2 - 2*x + 1'));
test('5*exp(-0.15*x)*cos(2*x)', () => evalCartesian('5*exp(-0.15*x)*cos(2*x)'));
test('2*cosh(x/2) [catenary]', () => evalCartesian('2*cosh(x/2)'));
test('0.25*x^2 + 2', () => evalCartesian('0.25*x^2 + 2'));
test('sin(x + pi/4)', () => evalCartesian('sin(x + pi/4)'));
test('sin(x) + sin(x + pi/4)', () => evalCartesian('sin(x) + sin(x + pi/4)'));
test('sin(5*x) + sin(5.5*x)', () => evalCartesian('sin(5*x) + sin(5.5*x)'));

// Projectile
test('x*tan(pi/6) - projectile', () => evalCartesian('x*tan(pi/6) - (9.8*x^2)/(2*20^2*(cos(pi/6))^2)', 5));
test('x*tan(pi/4) - projectile', () => evalCartesian('x*tan(pi/4) - (9.8*x^2)/(2*20^2*(cos(pi/4))^2)', 5));
test('x*tan(pi/3) - projectile', () => evalCartesian('x*tan(pi/3) - (9.8*x^2)/(2*20^2*(cos(pi/3))^2)', 5));
test('x*tan(pi/4.5) - projectile', () => evalCartesian('x*tan(pi/4.5) - (9.8*x^2)/(2*20^2*(cos(pi/4.5))^2)', 5));

// ML presets
test('tanh(x)', () => evalCartesian('tanh(x)'));
test('max(0, x) [ReLU]', () => evalCartesian('max(0, x)', 3));
test('max(0.1*x, x) [Leaky ReLU]', () => evalCartesian('max(0.1*x, x)', 3));
test('log(1 + exp(x)) [Softplus]', () => evalCartesian('log(1 + exp(x))'));
test('x * (1/(1+exp(-x))) [Swish]', () => evalCartesian('x * (1/(1+exp(-x)))'));

// Huber loss with ternary
test('x < 1 ? 0.5*x^2 : abs(x) - 0.5 [ternary]', () => evalCartesian('x < 1 ? 0.5*x^2 : abs(x) - 0.5', 0.5));

// Gaussians
test('(1/sqrt(2*pi))*exp(-x^2/2) [normal]', () => evalCartesian('(1/sqrt(2*pi))*exp(-x^2/2)'));
test('(1/(2*sqrt(2*pi)))*exp(-x^2/(2*4))', () => evalCartesian('(1/(2*sqrt(2*pi)))*exp(-x^2/(2*4))'));
test('(1/(0.5*sqrt(2*pi)))*exp(-x^2/(2*0.25))', () => evalCartesian('(1/(0.5*sqrt(2*pi)))*exp(-x^2/(2*0.25))'));
test('(1/sqrt(2*pi))*exp(-(x-2)^2/2)', () => evalCartesian('(1/sqrt(2*pi))*exp(-(x-2)^2/2)'));

// t-distribution
test('t-distribution expression', () =>
    evalCartesian('(gamma((3+1)/2)/(sqrt(3*pi)*gamma(3/2)))* (1 + x^2/3)^(- (3+1)/2)'));

// Various other presets
test('sqrt(4 - 2*(1 - cos(x)))', () => evalCartesian('sqrt(4 - 2*(1 - cos(x)))', 0.5));
test('8/(x^2 + 4)', () => evalCartesian('8/(x^2 + 4)'));
test('0 [constant]', () => evalCartesian('0'));
test('2*cosh((x-4)/2)', () => evalCartesian('2*cosh((x-4)/2)', 4));
test('5*(1 + 0.5*x)*exp(-0.5*x)', () => evalCartesian('5*(1 + 0.5*x)*exp(-0.5*x)', 2));
test('0.5*x^2 + 0.3*sin(5*x)', () => evalCartesian('0.5*x^2 + 0.3*sin(5*x)'));
test('exp(-0.3*x)*cos(2*x)', () => evalCartesian('exp(-0.3*x)*cos(2*x)'));
test('0.5*x^2 + 0.5*abs(x)', () => evalCartesian('0.5*x^2 + 0.5*abs(x)'));
test('-x - 2', () => evalCartesian('-x - 2'));
test('((1/(1+exp(-x)))*(1-1/(1+exp(-x))))^4', () => evalCartesian('((1/(1+exp(-x)))*(1 - 1/(1+exp(-x))))^4'));

console.log('\n=== POLAR EXPRESSIONS ===');

test('theta', () => evalPolar('theta'));
test('2 + 2*cos(theta)', () => evalPolar('2 + 2*cos(theta)'));
test('1 + cos(theta)', () => evalPolar('1 + cos(theta)'));
test('2*cos(5*theta)', () => evalPolar('2*cos(5*theta)'));
test('2*sin(3*theta)', () => evalPolar('2*sin(3*theta)'));
test('0.1*theta', () => evalPolar('0.1*theta'));
test('0.1*exp(0.15*theta)', () => evalPolar('0.1*exp(0.15*theta)'));
test('butterfly curve', () => evalPolar('exp(sin(theta)) - 2*cos(4*theta) + (sin(theta/12))^5'));
test('1 + 2*cos(theta) [limacon]', () => evalPolar('1 + 2*cos(theta)'));
const phi = 1.618033988749895;
test('golden spiral', () => evalPolar(`0.3 * ${phi.toFixed(6)}^(2*theta/pi)`));

console.log('\n=== PARAMETRIC EXPRESSIONS ===');

test('cos(t), sin(t)', () => evalParametric('cos(t), sin(t)'));
test('t*cos(t), t*sin(t)', () => evalParametric('t*cos(t), t*sin(t)'));
test('sin(3*t), sin(4*t) [Lissajous]', () => evalParametric('sin(3*t), sin(4*t)'));
test('hypotrochoid', () => evalParametric('2*cos(t) + 5*cos((2/3)*t), 2*sin(t) - 5*sin((2/3)*t)'));
test('deltoid', () => evalParametric('3*cos(t) - cos(3*t), 3*sin(t) - sin(3*t)'));
test('heart', () => evalParametric('16*(sin(t))^3, 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)'));
test('spirograph', () => evalParametric('(5+3)*cos(t) - 5*cos((5+3)/3*t), (5+3)*sin(t) - 5*sin((5+3)/3*t)'));
test('astroid', () => evalParametric('4*(cos(t))^3, 4*(sin(t))^3'));
test('cycloid', () => evalParametric('2*(t - sin(t)), 2*(1 - cos(t))'));
test('cissoid', () => evalParametric('2*(sin(t))^2, 2*(sin(t))^3/cos(t)', 0.5));
test('tractrix', () => evalParametric('2*(t - tanh(t)), 2/cosh(t)'));

console.log('\n=== IMPLICIT EXPRESSIONS ===');

test('x^2 + y^2 = 25', () => evalImplicit('x^2 + y^2 = 25'));
test('x^2/16 + y^2/9 = 1 [ellipse]', () => evalImplicit('x^2/16 + y^2/9 = 1'));
test('(x^2 + y^2 - 1)^3 = x^2*y^3 [heart]', () => evalImplicit('(x^2 + y^2 - 1)^3 = x^2*y^3'));
test('x^2 - y^2 = 1 [hyperbola]', () => evalImplicit('x^2 - y^2 = 1'));
test('(x^2 + y^2)^2 = 8*(x^2 - y^2) [lemniscate]', () => evalImplicit('(x^2 + y^2)^2 = 8*(x^2 - y^2)'));
test('x^3 + y^3 = 3*2*x*y [folium]', () => evalImplicit('x^3 + y^3 = 3*2*x*y'));
test('abs(x) + abs(y) = 1 [L1 norm]', () => evalImplicit('abs(x) + abs(y) = 1'));

console.log('\n=== INEQUALITY EXPRESSIONS ===');

test('y > x^2', () => evalInequality('y > x^2'));
test('y < sin(x)', () => evalInequality('y < sin(x)'));
test('y > x - 1', () => evalInequality('y > x - 1'));
test('y < x + 1', () => evalInequality('y < x + 1'));

console.log('\n=== PIECEWISE CONDITIONS ===');

test('x < 0', () => {
    const result = math.compile('x < 0').evaluate({ x: -1 });
    if (result !== true) throw new Error(`Got ${result}`);
});
test('x >= 0', () => {
    const result = math.compile('x >= 0').evaluate({ x: 1 });
    if (result !== true) throw new Error(`Got ${result}`);
});
test('x >= -2 and x < 2 [math.js native and]', () => {
    const result = math.compile('x >= -2 and x < 2').evaluate({ x: 0 });
    if (result !== true) throw new Error(`Got ${result}`);
});
test('x >= -2 && x < 2 [converted to and by engine]', () => {
    // Simulates the fixed evaluateCondition
    const cond = 'x >= -2 && x < 2'.replace(/&&/g, ' and ').replace(/\|\|/g, ' or ');
    const result = math.compile(cond).evaluate({ x: 0 });
    if (result !== true) throw new Error(`Got ${result}`);
});
test('x < 0 or x > 5 [math.js native or]', () => {
    const result = math.compile('x < 0 or x > 5').evaluate({ x: -1 });
    if (result !== true) throw new Error(`Got ${result}`);
});

console.log('\n=== FIXES VERIFICATION ===');

// FIX 1: "y = x" now strips y= prefix
test('"y = x" -> strips prefix to "x"', () => {
    const cleaned = stripCartesianPrefix('y = x');
    if (cleaned !== 'x') throw new Error(`Got "${cleaned}"`);
    const result = math.compile(cleaned).evaluate({ x: 5 });
    if (result !== 5) throw new Error(`Got ${result}`);
});

test('"y = sin(x)" -> strips prefix', () => {
    const cleaned = stripCartesianPrefix('y = sin(x)');
    if (cleaned !== 'sin(x)') throw new Error(`Got "${cleaned}"`);
});

// FIX 2: x**2 now converted to x^2
test('x**2 -> x^2 via normalize', () => {
    const normed = normalize('x**2');
    if (normed !== 'x^2') throw new Error(`Got "${normed}"`);
    const result = math.compile(normed).evaluate({ x: 3 });
    if (result !== 9) throw new Error(`Got ${result}`);
});

test('2**x -> 2^x via normalize', () => {
    const normed = normalize('2**x');
    if (normed !== '2^x') throw new Error(`Got "${normed}"`);
    const result = math.compile(normed).evaluate({ x: 3 });
    if (result !== 8) throw new Error(`Got ${result}`);
});

// FIX 3: ln(x) now converted to log(x)
test('ln(x) -> log(x) via normalize', () => {
    const normed = normalize('ln(x)');
    if (normed !== 'log(x)') throw new Error(`Got "${normed}"`);
    const result = math.compile(normed).evaluate({ x: Math.E });
    if (Math.abs(result - 1) > 0.001) throw new Error(`Got ${result}`);
});

test('3*ln(x) + 1 -> 3*log(x) + 1', () => {
    const normed = normalize('3*ln(x) + 1');
    if (!normed.includes('log(x)')) throw new Error(`Got "${normed}"`);
    const result = math.compile(normed).evaluate({ x: Math.E });
    if (Math.abs(result - 4) > 0.001) throw new Error(`Got ${result}`);
});

// FIX 4: x = <constant> vertical line detection
test('"x = 2" matches vertical line regex', () => {
    const match = 'x = 2'.match(/^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/);
    if (!match || parseFloat(match[1]) !== 2) throw new Error(`No match or wrong value`);
});

test('"x = -3.5" matches vertical line regex', () => {
    const match = 'x = -3.5'.match(/^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/);
    if (!match || parseFloat(match[1]) !== -3.5) throw new Error(`No match or wrong value`);
});

test('"x^2 + 1" does NOT match vertical line regex', () => {
    const match = 'x^2 + 1'.match(/^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/);
    if (match) throw new Error(`Should not match`);
});

// FIX 5: && -> and in conditions
test('"x >= 0 && x < 5" -> "x >= 0 and x < 5"', () => {
    const fixed = 'x >= 0 && x < 5'.replace(/&&/g, ' and ').replace(/\|\|/g, ' or ');
    const result = math.compile(fixed).evaluate({ x: 3 });
    if (result !== true) throw new Error(`Got ${result}`);
});

// Gamma function
test('gamma function', () => {
    const result = math.evaluate('gamma(3/2)');
    if (!isFinite(result)) throw new Error(`Got ${result}`);
});

// cosh/tanh
test('cosh(1)', () => {
    if (!isFinite(math.evaluate('cosh(1)'))) throw new Error('failed');
});
test('tanh(1)', () => {
    if (!isFinite(math.evaluate('tanh(1)'))) throw new Error('failed');
});

// === SUMMARY ===
console.log('\n' + '='.repeat(60));
console.log(`RESULTS: ${passed} passed, ${failed} failed`);
if (failures.length > 0) {
    console.log('\nFAILURES:');
    failures.forEach(f => console.log(`  - ${f.label}: ${f.error}`));
}
console.log('='.repeat(60));

process.exit(failed > 0 ? 1 : 0);
