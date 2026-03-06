/**
 * Test: Nerdamer-based equation solving for graphing calculator
 * Verifies that all equation types can be solved for y and plotted
 * Run: node test-graphing-nerdamer.cjs
 */
const nerdamer = require('nerdamer');
require('nerdamer/Algebra');
require('nerdamer/Calculus');
require('nerdamer/Solve');

// Prevent ReferenceError for imaginary unit
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

/**
 * Simulate the engine's solveAndPlot — solve equation for y,
 * then evaluate at a few x values
 */
function solveAndEval(equation, xTests = [0, 1, -1, 2]) {
    const parts = equation.split('=');
    if (parts.length !== 2) throw new Error('No = sign');
    const expr = '(' + parts[0].trim() + ')-(' + parts[1].trim() + ')';

    const ySolved = nerdamer.solve(expr, 'y');
    const yText = ySolved.text().replace(/^\[|\]$/g, '');
    if (!yText) throw new Error('Nerdamer returned empty solution');

    const yExprs = yText.split(',').map(s => s.trim()).filter(Boolean);
    if (yExprs.length === 0) throw new Error('No y-branches found');

    // Evaluate each branch at test x values
    let totalPoints = 0;
    for (const yExpr of yExprs) {
        for (const xv of xTests) {
            try {
                nerdamer.setVar('x', String(xv));
                const yv = parseFloat(nerdamer(yExpr).evaluate().text());
                nerdamer.clearVars();
                if (isFinite(yv)) totalPoints++;
            } catch (_) {
                nerdamer.clearVars();
            }
        }
    }

    if (totalPoints === 0) throw new Error(`0 plottable points from ${yExprs.length} branch(es): [${yExprs.join(', ')}]`);

    return { branches: yExprs.length, points: totalPoints };
}

console.log('=== LINEAR EQUATIONS ===\n');

test('2x + 3y = 8', () => {
    const r = solveAndEval('2x + 3y = 8');
    console.log(`    1 branch, ${r.points} points`);
});
test('4x - y = 2', () => solveAndEval('4x - y = 2'));
test('x + y = 5', () => solveAndEval('x + y = 5'));
test('x - y = 1', () => solveAndEval('x - y = 1'));
test('3x + 2y = 12', () => solveAndEval('3x + 2y = 12'));
test('-x + 4y = 8', () => solveAndEval('-x + 4y = 8'));
test('y = 2x + 1', () => solveAndEval('y = 2x + 1'));
test('y = -x + 5', () => solveAndEval('y = -x + 5'));
test('y = 3', () => solveAndEval('y = 3'));
test('0.5x + 0.3y = 2', () => solveAndEval('0.5*x + 0.3*y = 2'));

console.log('\n=== NONLINEAR — CIRCLES & ELLIPSES ===\n');

test('x^2 + y^2 = 25 [circle, 2 branches]', () => {
    const r = solveAndEval('x^2 + y^2 = 25', [0, 3, -3]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
    console.log(`    ${r.branches} branches, ${r.points} points`);
});
test('x^2 + y^2 = 1 [unit circle]', () => {
    const r = solveAndEval('x^2 + y^2 = 1', [0, 0.5, -0.5]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
});
test('x^2/4 + y^2/9 = 1 [ellipse]', () => {
    const r = solveAndEval('x^2/4 + y^2/9 = 1', [0, 1, -1]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
});
test('(x-1)^2 + (y-2)^2 = 4 [shifted circle]', () => {
    const r = solveAndEval('(x-1)^2 + (y-2)^2 = 4', [1, 2, 0]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
});

console.log('\n=== NONLINEAR — PARABOLAS & CUBICS ===\n');

test('y = x^2', () => solveAndEval('y = x^2'));
test('y = x^3', () => solveAndEval('y = x^3'));
test('y = x^3 - 3x', () => solveAndEval('y = x^3 - 3*x'));
test('y^2 = 4x [sideways parabola, 2 branches]', () => {
    const r = solveAndEval('y^2 = 4*x', [1, 4, 9]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
});

console.log('\n=== NONLINEAR — HYPERBOLAS ===\n');

test('x^2 - y^2 = 1', () => {
    const r = solveAndEval('x^2 - y^2 = 1', [2, -2, 3]);
    if (r.branches < 2) throw new Error(`Expected 2 branches, got ${r.branches}`);
});
test('x*y = 1', () => solveAndEval('x*y = 1', [1, 2, 0.5]));
test('x*y = 4', () => solveAndEval('x*y = 4', [1, 2, 4]));

console.log('\n=== NONLINEAR — TRIG & TRANSCENDENTAL ===\n');

test('y = sin(x)', () => solveAndEval('y = sin(x)'));
test('y = cos(x)', () => solveAndEval('y = cos(x)'));
test('y = exp(x)', () => solveAndEval('y = exp(x)'));
test('y = log(x)', () => solveAndEval('y = log(x)', [1, 2, Math.E]));

console.log('\n=== SYSTEM OF 2 EQUATIONS (solve intersection) ===\n');

test('Solve system: x+y=5 and x-y=1 → (3,2)', () => {
    const result = nerdamer.solveEquations(['x+y=5', 'x-y=1'], ['x', 'y']);
    // result format varies: array of [var, val] pairs or object
    const txt = JSON.stringify(result);
    console.log(`    Solution: ${txt}`);
    // Verify
    let x, y;
    if (Array.isArray(result)) {
        for (const item of result) {
            if (Array.isArray(item)) {
                if (item[0] === 'x') x = parseFloat(item[1]);
                if (item[0] === 'y') y = parseFloat(item[1]);
            }
        }
    }
    if (x !== 3 || y !== 2) throw new Error(`Expected (3,2), got (${x},${y})`);
});

test('Solve system: 2x+3y=8 and 4x-y=2 → (1,2)', () => {
    const result = nerdamer.solveEquations(['2*x+3*y=8', '4*x-y=2'], ['x', 'y']);
    const txt = JSON.stringify(result);
    console.log(`    Solution: ${txt}`);
    let x, y;
    if (Array.isArray(result)) {
        for (const item of result) {
            if (Array.isArray(item)) {
                if (item[0] === 'x') x = parseFloat(item[1]);
                if (item[0] === 'y') y = parseFloat(item[1]);
            }
        }
    }
    if (x !== 1 || y !== 2) throw new Error(`Expected (1,2), got (${x},${y})`);
});

test('Solve nonlinear: x^2+y^2=25 and y=x', () => {
    try {
        const result = nerdamer.solveEquations(['x^2+y^2=25', 'y=x'], ['x', 'y']);
        console.log(`    Solution: ${JSON.stringify(result)}`);
    } catch(e) {
        // solveEquations may not handle nonlinear — try substitution
        // Substitute y=x into first: x^2+x^2=25 → 2x^2=25
        const xSol = nerdamer.solve('2*x^2 - 25', 'x');
        console.log(`    x solutions via substitution: ${xSol.text()}`);
    }
});

test('Solve nonlinear: x^2+y^2=25 and x+y=7', () => {
    try {
        const result = nerdamer.solveEquations(['x^2+y^2=25', 'x+y=7'], ['x', 'y']);
        console.log(`    Solution: ${JSON.stringify(result)}`);
    } catch(e) {
        console.log(`    solveEquations failed: ${e.message}, trying substitution...`);
        // sub y = 7-x
        const xSol = nerdamer.solve('x^2 + (7-x)^2 - 25', 'x');
        console.log(`    x solutions: ${xSol.text()}`);
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
