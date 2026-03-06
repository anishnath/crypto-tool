/**
 * Test: graphing-calculator with linear & nonlinear system-of-equation inputs
 * Run: node test-graphing-systems.cjs
 */
const math = require('mathjs');

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

// Simulate engine helpers
function normalize(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    let s = expr.trim();
    s = s.replace(/\*\*/g, '^');
    s = s.replace(/\bln\s*\(/g, 'log(');
    // Implicit multiplication: xy → x*y (only single-letter vars, not inside function names)
    s = s.replace(/(?<![a-zA-Z])([a-zA-Z])([a-zA-Z])(?![a-zA-Z(])/g, (m, a, b) => {
        if ((a + b).toLowerCase() === 'pi') return m;
        return a + '*' + b;
    });
    return s;
}

function stripCartesianPrefix(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    return expr.replace(/^\s*y\s*=\s*/i, '');
}

// Simulate generateCartesian
function testCartesian(expression, xTest = 1) {
    let expr = normalize(expression);
    expr = stripCartesianPrefix(expr);
    const compiled = math.compile(expr);
    const y = compiled.evaluate({ x: xTest });
    if (typeof y !== 'number' || !isFinite(y)) throw new Error(`Cartesian: got ${y} for "${expression}" at x=${xTest}`);
    return y;
}

// Simulate generateImplicit (split on =, evaluate both sides)
function testImplicit(expression, x = 1, y = 1) {
    let leftExpr, rightExpr;
    if (expression.includes('=')) {
        const parts = expression.split('=');
        leftExpr = normalize(parts[0].trim());
        rightExpr = normalize(parts[1].trim());
    } else {
        leftExpr = normalize(expression);
        rightExpr = '0';
    }
    const lc = math.compile(leftExpr);
    const rc = math.compile(rightExpr);
    const lv = lc.evaluate({ x, y });
    const rv = rc.evaluate({ x, y });
    if (!isFinite(lv) || !isFinite(rv)) throw new Error(`Implicit: got ${lv} - ${rv} for "${expression}"`);
    return lv - rv;
}

// Simulate inequality parsing
function testInequality(expression, x = 1, y = 1) {
    const match = expression.match(/(.+?)(>=|<=|>|<)(.+)/);
    if (!match) throw new Error(`Can't parse inequality: ${expression}`);
    const lc = math.compile(normalize(match[1].trim()));
    const rc = math.compile(normalize(match[3].trim()));
    const lv = lc.evaluate({ x, y });
    const rv = rc.evaluate({ x, y });
    if (!isFinite(lv) || !isFinite(rv)) throw new Error(`Inequality: got ${lv} vs ${rv}`);
}

// Detect if an expression contains y (and thus needs implicit, not cartesian)
function containsY(expr) {
    return /\by\b/.test(expr);
}

// Simulate the engine's autoDetectType (assumes starting from 'cartesian')
// Returns the type the engine would auto-switch to, or 'cartesian' if no switch
function detectType(expr) {
    const s = expr.trim();
    if (!s) return 'cartesian';

    // Inequality
    if (/[^<>=!](>=|<=|>(?!=)|<(?!=))[^<>=]/.test(' ' + s + ' ')) return 'inequality';

    // "y = <expr>" where RHS is f(x) only → cartesian
    if (/^\s*y\s*=\s*/i.test(s)) {
        const rhs = s.replace(/^\s*y\s*=\s*/i, '');
        if (/(?<![a-zA-Z])y(?![a-zA-Z])/.test(rhs)) return 'equation';
        return 'cartesian';
    }

    // Has "=" AND contains y → equation (Nerdamer-based solving)
    if (s.includes('=') && /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) return 'equation';

    // Default: stay cartesian
    return 'cartesian';
}


console.log('=== LINEAR SYSTEMS (as user would type) ===\n');

// Standard linear equations — should work in implicit mode
test('2x + 3y = 8 [implicit]', () => testImplicit('2x + 3y = 8'));
test('4x - y = 2 [implicit]', () => testImplicit('4x - y = 2'));
test('x + y = 5 [implicit]', () => testImplicit('x + y = 5'));
test('x - y = 1 [implicit]', () => testImplicit('x - y = 1'));
test('3x + 2y = 12 [implicit]', () => testImplicit('3x + 2y = 12'));
test('-x + 4y = 8 [implicit]', () => testImplicit('-x + 4y = 8'));
test('0.5x + 0.3y = 2 [implicit]', () => testImplicit('0.5x + 0.3y = 2'));

// Linear equations that users might enter in cartesian mode (with y= prefix)
test('y = 2x + 1 [cartesian, strip y=]', () => testCartesian('y = 2x + 1'));
test('y = -x + 5 [cartesian]', () => testCartesian('y = -x + 5'));
test('y = 0.5x - 3 [cartesian]', () => testCartesian('y = 0.5x - 3'));
test('y = 3 [constant]', () => testCartesian('y = 3'));

// Problem: user types "2x + 3y = 8" in cartesian mode → FAILS because y is a variable
test('2x + 3y = 8 in CARTESIAN mode (has y → should fail)', () => {
    try {
        testCartesian('2x + 3y = 8');
        throw new Error('Should have failed — y is undefined in cartesian scope');
    } catch (e) {
        if (e.message.includes('Should have failed')) throw e;
        // Expected failure — good
    }
});

console.log('\n=== NONLINEAR SYSTEMS (implicit) ===\n');

test('x^2 + y^2 = 25 [circle]', () => testImplicit('x^2 + y^2 = 25'));
test('x^2 + y^2 = 1 [unit circle]', () => testImplicit('x^2 + y^2 = 1'));
test('x^2/4 + y^2/9 = 1 [ellipse]', () => testImplicit('x^2/4 + y^2/9 = 1'));
test('x^2 - y^2 = 1 [hyperbola]', () => testImplicit('x^2 - y^2 = 1'));
test('y = x^2 [parabola as implicit]', () => testImplicit('y = x^2'));
test('y = x^3 [cubic]', () => testImplicit('y = x^3'));
test('y = sin(x) [trig]', () => testImplicit('y = sin(x)'));
test('y = exp(x) [exponential]', () => testImplicit('y = exp(x)'));
test('x^2 + y^2 - 2x = 0 [shifted circle]', () => testImplicit('x^2 + y^2 - 2x = 0'));
test('(x-1)^2 + (y-2)^2 = 4 [circle at (1,2)]', () => testImplicit('(x-1)^2 + (y-2)^2 = 4'));
test('x*y = 1 [hyperbola]', () => testImplicit('x*y = 1'));
test('y^2 = 4x [parabola opening right]', () => testImplicit('y^2 = 4x'));
test('x^3 + y^3 = 6xy [folium]', () => testImplicit('x^3 + y^3 = 6xy'));

// Mixed: one linear + one nonlinear
test('y = x (as implicit, for intersection with circle)', () => testImplicit('y = x'));
test('2x + y = 5 (linear, with circle)', () => testImplicit('2x + y = 5'));

console.log('\n=== NONLINEAR AS CARTESIAN (y = f(x) form) ===\n');

test('y = x^2 [cartesian]', () => testCartesian('y = x^2'));
test('y = x^3 - 3x [cartesian]', () => testCartesian('y = x^3 - 3x'));
test('y = sin(x) [cartesian]', () => testCartesian('y = sin(x)'));
test('y = sqrt(x) [cartesian]', () => testCartesian('y = sqrt(x)', 4));
test('y = 1/(1+exp(-x)) [sigmoid]', () => testCartesian('y = 1/(1+exp(-x))'));
test('y = log(x) [cartesian]', () => testCartesian('y = log(x)', 2));
test('y = abs(x) [cartesian]', () => testCartesian('y = abs(x)', -3));

console.log('\n=== AUTO-DETECT TYPE ===\n');

test('detect: 2x + 3y = 8 → equation', () => {
    if (detectType('2x + 3y = 8') !== 'equation') throw new Error('wrong');
});
test('detect: y = 2x + 1 → cartesian', () => {
    if (detectType('y = 2x + 1') !== 'cartesian') throw new Error('wrong');
});
test('detect: x^2 + y^2 = 25 → equation', () => {
    if (detectType('x^2 + y^2 = 25') !== 'equation') throw new Error('wrong');
});
test('detect: sin(x) → cartesian', () => {
    if (detectType('sin(x)') !== 'cartesian') throw new Error('wrong');
});
test('detect: y > x^2 → inequality', () => {
    if (detectType('y > x^2') !== 'inequality') throw new Error('wrong');
});
test('detect: y = x^2 → cartesian', () => {
    if (detectType('y = x^2') !== 'cartesian') throw new Error('wrong');
});
test('detect: x = 5 → cartesian (vertical line handled there)', () => {
    if (detectType('x = 5') !== 'cartesian') throw new Error('wrong');
});
test('detect: y = sin(x) → cartesian', () => {
    if (detectType('y = sin(x)') !== 'cartesian') throw new Error('wrong');
});
test('detect: x*y = 1 → equation', () => {
    if (detectType('x*y = 1') !== 'equation') throw new Error('wrong');
});
test('detect: y^2 = 4x → equation', () => {
    if (detectType('y^2 = 4x') !== 'equation') throw new Error('wrong');
});
test('detect: y <= 2x + 1 → inequality', () => {
    if (detectType('y <= 2x + 1') !== 'inequality') throw new Error('wrong');
});

console.log('\n=== IMPLICIT MODE: CONTOUR LEVEL CORRECTNESS ===\n');

// For implicit: the contour at z=0 should pass through points on the curve
test('circle x^2+y^2=25: point (3,4) is ON curve', () => {
    const diff = testImplicit('x^2 + y^2 = 25', 3, 4);
    if (Math.abs(diff) > 0.01) throw new Error(`Expected ~0, got ${diff}`);
});
test('circle x^2+y^2=25: point (0,0) is NOT on curve', () => {
    const diff = testImplicit('x^2 + y^2 = 25', 0, 0);
    if (Math.abs(diff) < 1) throw new Error(`Expected far from 0, got ${diff}`);
});
test('line 2x+3y=8: point (1,2) is ON line', () => {
    const diff = testImplicit('2x + 3y = 8', 1, 2);
    if (Math.abs(diff) > 0.01) throw new Error(`Expected ~0, got ${diff}`);
});
test('line x+y=5: point (2,3) is ON line', () => {
    const diff = testImplicit('x + y = 5', 2, 3);
    if (Math.abs(diff) > 0.01) throw new Error(`Expected ~0, got ${diff}`);
});
test('parabola y=x^2: point (3,9) is ON curve', () => {
    const diff = testImplicit('y = x^2', 3, 9);
    if (Math.abs(diff) > 0.01) throw new Error(`Expected ~0, got ${diff}`);
});
test('ellipse x^2/4+y^2/9=1: point (2,0) is ON curve', () => {
    const diff = testImplicit('x^2/4 + y^2/9 = 1', 2, 0);
    if (Math.abs(diff) > 0.01) throw new Error(`Expected ~0, got ${diff}`);
});

console.log('\n=== VERTICAL LINE x=constant ===\n');

// Vertical line regex from engine
function isVerticalLine(expr) {
    return /^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/.test(expr);
}

test('x = 2 is vertical line', () => { if (!isVerticalLine('x = 2')) throw new Error('no match'); });
test('x = -3.5 is vertical line', () => { if (!isVerticalLine('x = -3.5')) throw new Error('no match'); });
test('x = 0 is vertical line', () => { if (!isVerticalLine('x = 0')) throw new Error('no match'); });
test('2x + y = 5 is NOT vertical line', () => { if (isVerticalLine('2x + y = 5')) throw new Error('false match'); });
test('x^2 = 4 is NOT vertical line', () => { if (isVerticalLine('x^2 = 4')) throw new Error('false match'); });

// x = <expr> that aren't simple constants → should work in implicit mode
test('x = y^2 [implicit, parabola opening right]', () => testImplicit('x = y^2'));
test('x = sin(y) [implicit]', () => testImplicit('x = sin(y)'));

console.log('\n' + '='.repeat(60));
console.log(`RESULTS: ${passed} passed, ${failed} failed`);
if (failures.length > 0) {
    console.log('\nFAILURES:');
    failures.forEach(f => console.log(`  - ${f.label}\n    ${f.error}`));
}
console.log('='.repeat(60));

process.exit(failed > 0 ? 1 : 0);
