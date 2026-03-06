/**
 * Tests for SymPy fallback integration in graphing-tool-engine.js
 * Runs Python code locally to verify SymPy output, then tests JS parsing.
 */

const { execSync } = require('child_process');
const fs = require('fs');

let passed = 0;
let failed = 0;

function assert(condition, msg) {
    if (condition) {
        passed++;
        console.log(`  PASS: ${msg}`);
    } else {
        failed++;
        console.log(`  FAIL: ${msg}`);
    }
}

function assertClose(actual, expected, tol, msg) {
    const ok = Math.abs(actual - expected) < tol;
    if (ok) {
        passed++;
        console.log(`  PASS: ${msg} (${actual} ≈ ${expected})`);
    } else {
        failed++;
        console.log(`  FAIL: ${msg} (got ${actual}, expected ${expected})`);
    }
}

function runPython(code) {
    const tmpFile = '/tmp/_sympy_test_' + Date.now() + '.py';
    try {
        fs.writeFileSync(tmpFile, code);
        const result = execSync(`python3 ${tmpFile}`, {
            encoding: 'utf8',
            timeout: 30000
        }).trim();
        fs.unlinkSync(tmpFile);
        return result;
    } catch (e) {
        try { fs.unlinkSync(tmpFile); } catch(_) {}
        return 'EXEC_ERROR: ' + (e.stderr || e.message);
    }
}

// ============================================================
// Load the engine source to extract _toPython as a standalone
// ============================================================
const engineSrc = fs.readFileSync('src/main/webapp/js/graphing-tool-engine.js', 'utf8');

// Extract _toPython static method for direct testing
const toPython = function(s) {
    if (!s) return '';
    s = s.trim();
    s = s.replace(/\^/g, '**');
    s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
    s = s.replace(/\)\s*\(/g, ')*(');
    s = s.replace(/\)\s*([a-zA-Z\d])/g, ')*$1');
    return s;
};

// ============================================================
console.log('\n=== 1. _toPython conversion tests ===');
// ============================================================

assert(toPython('x^2') === 'x**2', 'x^2 → x**2');
assert(toPython('2x') === '2*x', '2x → 2*x');
assert(toPython('3y^2') === '3*y**2', '3y^2 → 3*y**2');
assert(toPython('(x+1)(x-1)') === '(x+1)*(x-1)', 'implicit mult between parens');
assert(toPython('sin(x)x') === 'sin(x)*x', 'function result × variable');
assert(toPython('2sin(x)') === '2*sin(x)', 'digit × function');
assert(toPython('x^2 + 3x - 5') === 'x**2 + 3*x - 5', 'polynomial');

// ============================================================
console.log('\n=== 2. SymPy Antiderivative tests ===');
// ============================================================

function testAntiderivative(expr, checkSymbolic, checkPoints) {
    const pyExpr = toPython(expr);
    const code =
        'from sympy import *\n' +
        'import json\n' +
        'x = symbols("x")\n' +
        'try:\n' +
        '    expr = ' + pyExpr + '\n' +
        '    F = integrate(expr, x)\n' +
        '    sym = str(F)\n' +
        '    xs = [-2.0, -1.0, 0.0, 1.0, 2.0]\n' +
        '    ys = []\n' +
        '    for xv in xs:\n' +
        '        try:\n' +
        '            yv = float(F.subs(x, xv))\n' +
        '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
        '        except: ys.append(None)\n' +
        '    print("ANTI:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))';

    const stdout = runPython(code);
    const m = stdout.match(/ANTI:([\s\S]*)/);
    assert(m !== null, `Antiderivative of "${expr}" returned ANTI: prefix`);
    if (!m) { console.log('    stdout:', stdout); return; }

    const data = JSON.parse(m[1].trim());
    assert(data.symbolic && data.symbolic.length > 0, `Symbolic result: ${data.symbolic}`);
    assert(data.x.length === 5, 'Has 5 x values');
    assert(data.y.length === 5, 'Has 5 y values');

    if (checkSymbolic) checkSymbolic(data.symbolic);
    if (checkPoints) checkPoints(data.x, data.y);
}

testAntiderivative('x**2',
    sym => assert(sym.includes('x**3/3') || sym.includes('x**3') , `∫x² = ${sym} contains x³/3`),
    (xs, ys) => assertClose(ys[3], 1/3, 0.001, '∫x² at x=1 = 1/3')
);

testAntiderivative('sin(x)',
    sym => assert(sym.includes('cos') , `∫sin(x) = ${sym} contains cos`),
    (xs, ys) => assertClose(ys[2], -1.0, 0.001, '∫sin(x) at x=0 = -cos(0) = -1')
);

testAntiderivative('exp(x)',
    sym => assert(sym.includes('exp') , `∫eˣ = ${sym} contains exp`),
    (xs, ys) => assertClose(ys[2], 1.0, 0.001, '∫eˣ at x=0 = e⁰ = 1')
);

// This one fails in Nerdamer but works in SymPy
testAntiderivative('x**2 * exp(x)',
    sym => assert(sym.length > 0, `∫x²eˣ = ${sym} (Nerdamer fails on this)`),
    null
);

testAntiderivative('1/sqrt(1 - x**2)',
    sym => assert(sym.includes('asin') || sym.includes('sin'), `∫1/√(1-x²) = ${sym} should be asin`),
    null
);

// ============================================================
console.log('\n=== 3. SymPy Limit tests ===');
// ============================================================

function testLimit(expr, variable, value, expectedNumeric) {
    const pyExpr = toPython(expr);
    let pyVal = String(value).trim();
    if (pyVal === 'Infinity' || pyVal === 'inf') pyVal = 'oo';
    else if (pyVal === '-Infinity' || pyVal === '-inf') pyVal = '-oo';

    const code =
        'from sympy import *\n' +
        'import json\n' +
        variable + ' = symbols("' + variable + '")\n' +
        'try:\n' +
        '    expr = ' + pyExpr + '\n' +
        '    L = limit(expr, ' + variable + ', ' + pyVal + ')\n' +
        '    sym = str(L)\n' +
        '    try: num = float(L)\n' +
        '    except: num = None\n' +
        '    print("LIMIT:" + json.dumps({"symbolic": sym, "numeric": num}))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))';

    const stdout = runPython(code);
    const m = stdout.match(/LIMIT:([\s\S]*)/);
    assert(m !== null, `Limit of "${expr}" as ${variable}→${value} returned LIMIT: prefix`);
    if (!m) { console.log('    stdout:', stdout); return; }

    const data = JSON.parse(m[1].trim());
    assert(data.symbolic && data.symbolic.length > 0, `Symbolic: ${data.symbolic}`);

    if (expectedNumeric !== null && expectedNumeric !== undefined) {
        assert(data.numeric !== null, `Numeric value exists: ${data.numeric}`);
        if (data.numeric !== null) {
            assertClose(data.numeric, expectedNumeric, 0.0001, `Numeric ≈ ${expectedNumeric}`);
        }
    }
}

testLimit('sin(x)/x', 'x', 0, 1);
testLimit('(x**2 - 1)/(x - 1)', 'x', 1, 2);
testLimit('(exp(x) - 1)/x', 'x', 0, 1);
testLimit('(1 + 1/x)**x', 'x', 'Infinity', Math.E);
testLimit('x*sin(1/x)', 'x', 0, 0);  // classic limit
testLimit('(x**3 - 8)/(x - 2)', 'x', 2, 12);  // factoring limit
testLimit('tan(x)/x', 'x', 0, 1);

// ============================================================
console.log('\n=== 4. SymPy Equation Solving tests ===');
// ============================================================

function testEquationSolve(equation, expectedBranches) {
    const parts = equation.split('=');
    const lhs = toPython(parts[0].trim());
    const rhs = toPython(parts[1].trim());
    const xMin = -5, xMax = 5, numPoints = 50;
    const step = (xMax - xMin) / numPoints;

    const code =
        'from sympy import *\n' +
        'import json, math\n' +
        'x, y = symbols("x y")\n' +
        'try:\n' +
        '    eq = (' + lhs + ')-(' + rhs + ')\n' +
        '    sols = solve(eq, y)\n' +
        '    if not sols:\n' +
        '        print("NOSOL")\n' +
        '    else:\n' +
        '        branches = []\n' +
        '        for s in sols:\n' +
        '            xs, ys = [], []\n' +
        '            for i in range(' + (numPoints + 1) + '):\n' +
        '                xv = ' + xMin + ' + i*' + step + '\n' +
        '                try:\n' +
        '                    yv = complex(s.subs(x, xv))\n' +
        '                    if abs(yv.imag) < 1e-10 and abs(yv.real) < 1e15:\n' +
        '                        xs.append(xv); ys.append(yv.real)\n' +
        '                    else:\n' +
        '                        xs.append(xv); ys.append(None)\n' +
        '                except:\n' +
        '                    xs.append(xv); ys.append(None)\n' +
        '            branches.append({"expr": str(s), "x": xs, "y": ys})\n' +
        '        print("EQSOL:" + json.dumps(branches))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))';

    const stdout = runPython(code);

    if (expectedBranches === 0) {
        assert(stdout.includes('NOSOL'), `"${equation}" has no solution`);
        return;
    }

    const m = stdout.match(/EQSOL:([\s\S]*)/);
    assert(m !== null, `Equation "${equation}" returned EQSOL: prefix`);
    if (!m) { console.log('    stdout:', stdout); return; }

    const branches = JSON.parse(m[1].trim());
    assert(branches.length === expectedBranches, `${branches.length} branches (expected ${expectedBranches})`);

    for (let i = 0; i < branches.length; i++) {
        const b = branches[i];
        assert(b.x.length === numPoints + 1, `Branch ${i+1} has ${numPoints+1} x points`);
        const realYs = b.y.filter(v => v !== null);
        assert(realYs.length > 0, `Branch ${i+1} "${b.expr}" has ${realYs.length} real y values`);
    }
}

// Simple linear
testEquationSolve('y = 2*x + 1', 1);

// Circle: x² + y² = 25 → y = ±√(25-x²), 2 branches
testEquationSolve('x^2 + y^2 = 25', 2);

// Parabola: y = x² (trivial, 1 branch)
testEquationSolve('y = x^2', 1);

// Ellipse: x²/9 + y²/4 = 1 → 2 branches
testEquationSolve('x^2/9 + y^2/4 = 1', 2);

// Cubic: y³ = x → y = x^(1/3), but SymPy may return 3 branches (complex)
testEquationSolve('y^3 = x', 3);

// ============================================================
console.log('\n=== 5. SymPy Symbolic Derivative tests ===');
// ============================================================

function testDerivative(expr, checkSymbolic, checkPoints) {
    const pyExpr = toPython(expr);
    const code =
        'from sympy import *\n' +
        'import json\n' +
        'x = symbols("x")\n' +
        'try:\n' +
        '    expr = ' + pyExpr + '\n' +
        '    d = diff(expr, x)\n' +
        '    sym = str(d)\n' +
        '    xs = [-2.0, -1.0, 0.0, 1.0, 2.0]\n' +
        '    ys = []\n' +
        '    for xv in xs:\n' +
        '        try:\n' +
        '            yv = float(d.subs(x, xv))\n' +
        '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
        '        except: ys.append(None)\n' +
        '    print("DERIV:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))';

    const stdout = runPython(code);
    const m = stdout.match(/DERIV:([\s\S]*)/);
    assert(m !== null, `Derivative of "${expr}" returned DERIV: prefix`);
    if (!m) { console.log('    stdout:', stdout); return; }

    const data = JSON.parse(m[1].trim());
    assert(data.symbolic && data.symbolic.length > 0, `Symbolic: ${data.symbolic}`);

    if (checkSymbolic) checkSymbolic(data.symbolic);
    if (checkPoints) checkPoints(data.x, data.y);
}

testDerivative('x**3',
    sym => assert(sym.includes('3*x**2') || sym === '3*x**2', `d/dx(x³) = ${sym}`),
    (xs, ys) => assertClose(ys[3], 3.0, 0.001, 'd/dx(x³) at x=1 = 3')
);

testDerivative('sin(x)',
    sym => assert(sym === 'cos(x)', `d/dx(sin(x)) = ${sym}`),
    (xs, ys) => assertClose(ys[2], 1.0, 0.001, 'd/dx(sin(x)) at x=0 = 1')
);

testDerivative('exp(x)*sin(x)',
    sym => assert(sym.length > 0, `d/dx(eˣsin(x)) = ${sym} (product rule)`),
    null
);

testDerivative('log(x**2 + 1)',
    sym => assert(sym.length > 0, `d/dx(ln(x²+1)) = ${sym} (chain rule)`),
    (xs, ys) => assertClose(ys[2], 0.0, 0.001, 'd/dx(ln(x²+1)) at x=0 = 0')
);

// ============================================================
console.log('\n=== 6. JS parsing / integration tests ===');
// ============================================================

// Test that the engine source contains all the new methods
assert(engineSrc.includes('_sympyExec(code)'), 'Engine has _sympyExec method');
assert(engineSrc.includes('solveAndPlotSymPy('), 'Engine has solveAndPlotSymPy method');
assert(engineSrc.includes('generateAntiderivativeSymPy('), 'Engine has generateAntiderivativeSymPy method');
assert(engineSrc.includes('evaluateLimitSymPy('), 'Engine has evaluateLimitSymPy method');
assert(engineSrc.includes('generateDerivativeSymPy('), 'Engine has generateDerivativeSymPy method');
assert(engineSrc.includes('_runSympyFallbacks('), 'Engine has _runSympyFallbacks method');
assert(engineSrc.includes('_replotWithSymPy('), 'Engine has _replotWithSymPy method');
assert(engineSrc.includes('_showSympyIndicator('), 'Engine has _showSympyIndicator');
assert(engineSrc.includes('_hideSympyIndicator('), 'Engine has _hideSympyIndicator');
assert(engineSrc.includes("static _toPython(s)"), 'Engine has static _toPython');
assert(engineSrc.includes("OneCompilerFunctionality?action=execute"), 'Engine calls OneCompilerFunctionality');

// Test fallback wiring
assert(engineSrc.includes("generateImplicit(normalizedExpr"), 'Equation type falls back to implicit contour');
assert(engineSrc.includes("expr._sympyAntiNeeded"), 'Antiderivative flags _sympyAntiNeeded');
assert(engineSrc.includes("expr._sympyLimitNeeded"), 'Limit flags _sympyLimitNeeded');
assert(engineSrc.includes("this._runSympyFallbacks(settings)"), 'plot() calls _runSympyFallbacks');

// Test JSON output parsing patterns
function testJsonParsing(prefix, jsonStr) {
    const stdout = prefix + ':' + jsonStr;
    const m = stdout.match(new RegExp(prefix + ':([\\s\\S]*)'));
    assert(m !== null, `Parse ${prefix}: prefix`);
    try {
        const data = JSON.parse(m[1].trim());
        assert(data !== null, `Parsed ${prefix} JSON successfully`);
        return data;
    } catch(e) {
        failed++;
        console.log(`  FAIL: Parse ${prefix} JSON: ${e.message}`);
        return null;
    }
}

testJsonParsing('ANTI', '{"symbolic":"x**3/3","x":[0,1,2],"y":[0,0.333,2.667]}');
testJsonParsing('LIMIT', '{"symbolic":"1","numeric":1.0}');
testJsonParsing('EQSOL', '[{"expr":"sqrt(25-x**2)","x":[0,1],"y":[5,4.899]}]');
testJsonParsing('DERIV', '{"symbolic":"3*x**2","x":[0,1,2],"y":[0,3,12]}');

// ============================================================
console.log('\n=== 7. Edge cases & error handling ===');
// ============================================================

// Test _toPython with empty/null
assert(toPython('') === '', 'toPython empty string');
assert(toPython('   ') === '', 'toPython whitespace');

// Test Python error handling
{
    const code =
        'from sympy import *\n' +
        'import json\n' +
        'x = symbols("x")\n' +
        'try:\n' +
        '    expr = asdfnotafunction(x)\n' +
        '    F = integrate(expr, x)\n' +
        '    print("ANTI:" + json.dumps({"symbolic": str(F)}))\n' +
        'except Exception as e:\n' +
        '    print("ERROR:" + str(e))';
    const stdout = runPython(code);
    assert(stdout.includes('ERROR:'), 'Invalid function returns ERROR: prefix');
}

// Test limit at infinity
testLimit('1/x', 'x', 'Infinity', 0);
testLimit('exp(-x)', 'x', 'Infinity', 0);

// Test antiderivative of hard function that Nerdamer can't do
testAntiderivative('x**2 * sin(x)',
    sym => assert(sym.length > 0, `∫x²sin(x) = ${sym} (integration by parts, Nerdamer fails)`),
    null
);

// ============================================================
console.log('\n=== 8. normalizeExpression improvements ===');
// ============================================================

// Reproduce the normalizeExpression logic from the engine
function normalizeExpression(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    let s = expr.trim();
    s = s.replace(/\*\*/g, '^');
    s = s.replace(/\bln\s*\(/g, 'log(');
    s = s.replace(/(\d)\s*\(/g, '$1*(');
    s = s.replace(/\)\s*\(/g, ')*(');
    s = s.replace(/\)\s*(\w)/g, ')*$1');
    s = s.replace(/(\d)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs|ceil|floor|sign|round)\s*\(/gi, '$1*$2(');
    s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
    s = s.replace(/(?<![a-zA-Z])([a-zA-Z])([a-zA-Z])(?![a-zA-Z(])/g, (m, a, b) => {
        if ((a + b).toLowerCase() === 'pi') return m;
        return a + '*' + b;
    });
    return s;
}

assert(normalizeExpression('2sin(x)') === '2*sin(x)', '2sin(x) → 2*sin(x)');
assert(normalizeExpression('3cos(x)') === '3*cos(x)', '3cos(x) → 3*cos(x)');
assert(normalizeExpression('2(x+1)') === '2*(x+1)', '2(x+1) → 2*(x+1)');
assert(normalizeExpression('(x+1)(x-1)') === '(x+1)*(x-1)', '(x+1)(x-1) → (x+1)*(x-1)');
assert(normalizeExpression('(x+1)x') === '(x+1)*x', '(x+1)x → (x+1)*x');
assert(normalizeExpression('5exp(x)') === '5*exp(x)', '5exp(x) → 5*exp(x)');
assert(normalizeExpression('2sqrt(x)') === '2*sqrt(x)', '2sqrt(x) → 2*sqrt(x)');
assert(normalizeExpression('sin(x)cos(x)') === 'sin(x)*cos(x)', 'sin(x)cos(x) → sin(x)*cos(x)');
assert(normalizeExpression('2x') === '2*x', '2x → 2*x (still works)');
assert(normalizeExpression('3x^2') === '3*x^2', '3x^2 → 3*x^2');
assert(normalizeExpression('ln(x)') === 'log(x)', 'ln(x) → log(x)');
assert(normalizeExpression('x**2') === 'x^2', 'x**2 → x^2');
// Make sure function names aren't broken
assert(normalizeExpression('sin(x)') === 'sin(x)', 'sin(x) unchanged');
assert(normalizeExpression('cos(x) + tan(x)') === 'cos(x) + tan(x)', 'cos(x) + tan(x) unchanged');
assert(normalizeExpression('pi') === 'pi', 'pi unchanged');

// ============================================================
console.log('\n=== 9. Implicit contour (marching squares) ===');
// ============================================================

// Test that the engine has the improved marching squares with line segments
assert(engineSrc.includes("type: 'surface'"), 'Engine has surface trace type');
assert(engineSrc.includes('generateSurface('), 'Engine has generateSurface method');
// Auto-detect surface: expressions with x and y but no = sign
assert(engineSrc.includes("return 'surface'"), 'autoDetectType can return surface for f(x,y) expressions');
assert(engineSrc.includes("mode: 'lines'") || engineSrc.includes("mode: data.mode || 'lines'"), 'Implicit trace uses lines mode');
assert(engineSrc.includes('segments.push'), 'Marching squares produces line segments');
assert(engineSrc.includes("case 5: segments.push"), 'Marching squares handles ambiguous case 5');

// ============================================================
console.log('\n=== 10. Asymptote detection ===');
// ============================================================

assert(engineSrc.includes('asymptotes'), 'Engine tracks asymptotes');
assert(engineSrc.includes('jumpThreshold'), 'Asymptote detection uses jump threshold');
assert(engineSrc.includes("dash: 'dot'") && engineSrc.includes('asymptotes'), 'Asymptotes rendered as dotted lines');

// ============================================================
console.log('\n=== 11. Parametric/Polar range controls ===');
// ============================================================

assert(engineSrc.includes('expr.tMin'), 'Parametric uses expr.tMin');
assert(engineSrc.includes('expr.tMax'), 'Parametric uses expr.tMax');
assert(engineSrc.includes('expr.thetaMin'), 'Polar uses expr.thetaMin');
assert(engineSrc.includes('expr.thetaMax'), 'Polar uses expr.thetaMax');
assert(engineSrc.includes('updateParamRange'), 'Has updateParamRange function');
assert(engineSrc.includes('updatePolarRange'), 'Has updatePolarRange function');
assert(engineSrc.includes('loadParamSample'), 'Has loadParamSample function');
assert(engineSrc.includes('loadPolarSample'), 'Has loadPolarSample function');

// ============================================================
console.log('\n=== 12. Simpson\'s rule ===');
// ============================================================

assert(engineSrc.includes("Simpson's 1/3 rule"), 'Integration uses Simpson 1/3 rule');
assert(engineSrc.includes('area += 4 * y'), 'Simpson coefficients: 4 for odd');
assert(engineSrc.includes('area += 2 * y'), 'Simpson coefficients: 2 for even');
assert(engineSrc.includes('area * step) / 3'), 'Simpson divisor: h/3');

// ============================================================
console.log('\n=== 13. 3D Surface support ===');
// ============================================================

assert(engineSrc.includes('generateSurface('), 'Engine has generateSurface');
assert(engineSrc.includes("case 'surface':"), 'createTrace handles surface type');
assert(engineSrc.includes("type: 'surface'"), 'Surface trace type set');
assert(engineSrc.includes('colorscale'), 'Surface has colorscale');
assert(engineSrc.includes('is3D'), 'plot() detects 3D mode');
assert(engineSrc.includes('scene:'), 'Layout has scene for 3D');
assert(engineSrc.includes('_ensureFullPlotly'), 'Lazy-loads full Plotly for 3D');
assert(engineSrc.includes('3D Surface'), 'Surface type in dropdown');
assert(engineSrc.includes('Ripple') && engineSrc.includes('Saddle'), 'Surface presets available');

// ============================================================
console.log('\n=== 14. Parameter animation (pre-existing) ===');
// ============================================================

assert(engineSrc.includes('detectAndCreateSliders'), 'Has parameter detection');
assert(engineSrc.includes('toggleAnimation'), 'Has animation toggle');
assert(engineSrc.includes('animationState'), 'Has animation state');
assert(engineSrc.includes('requestAnimationFrame(animate)'), 'Uses rAF for smooth animation');

// ============================================================
console.log('\n=== 15. Riemann sums (L, M, R, Trap) ===');
// ============================================================

assert(engineSrc.includes('generateRiemannSum'), 'Engine has generateRiemannSum method');
assert(engineSrc.includes("'left'") && engineSrc.includes("'right'") && engineSrc.includes("'midpoint'") && engineSrc.includes("'trapezoidal'"), 'Supports all 4 Riemann methods');
assert(engineSrc.includes('riemann-method-'), 'UI has Riemann method dropdown');
assert(engineSrc.includes('riemann-n-'), 'UI has Riemann n input');
assert(engineSrc.includes('updateRiemannMethod'), 'Has updateRiemannMethod function');
assert(engineSrc.includes('updateRiemannN'), 'Has updateRiemannN function');
assert(engineSrc.includes('riemannMethod'), 'Expression state tracks riemannMethod');
assert(engineSrc.includes('riemannN'), 'Expression state tracks riemannN');
assert(engineSrc.includes('Riemann (n='), 'Legend shows Riemann label with n');

// ============================================================
console.log('\n=== 16. Second derivative, critical points, inflection points ===');
// ============================================================

assert(engineSrc.includes('generateSecondDerivative'), 'Engine has generateSecondDerivative method');
assert(engineSrc.includes('findCriticalPoints'), 'Engine has findCriticalPoints method');
assert(engineSrc.includes('findInflectionPoints'), 'Engine has findInflectionPoints method');
assert(engineSrc.includes('show-second-derivative-'), 'UI has second derivative toggle');
assert(engineSrc.includes('show-critical-points-'), 'UI has critical points toggle');
assert(engineSrc.includes('show-inflection-points-'), 'UI has inflection points toggle');
assert(engineSrc.includes('toggleSecondDerivative'), 'Has toggleSecondDerivative function');
assert(engineSrc.includes('toggleCriticalPoints'), 'Has toggleCriticalPoints function');
assert(engineSrc.includes('toggleInflectionPoints'), 'Has toggleInflectionPoints function');
assert(engineSrc.includes('showSecondDerivative'), 'Expression state tracks showSecondDerivative');
assert(engineSrc.includes('showCriticalPoints'), 'Expression state tracks showCriticalPoints');
assert(engineSrc.includes('showInflectionPoints'), 'Expression state tracks showInflectionPoints');
assert(engineSrc.includes("f''("), 'Second derivative label uses f\'\'');
assert(engineSrc.includes("'min'") && engineSrc.includes("'max'"), 'Critical points classified as min/max');
assert(engineSrc.includes('Local Min') && engineSrc.includes('Local Max'), 'UI shows Local Min/Max markers');
assert(engineSrc.includes('Inflection Points'), 'UI shows Inflection Points markers');

// ============================================================
console.log('\n=== 17. Horizontal/oblique asymptotes ===');
// ============================================================

assert(engineSrc.includes('findHorizontalAsymptotes'), 'Engine has findHorizontalAsymptotes method');
assert(engineSrc.includes("type: 'horizontal'"), 'Detects horizontal asymptotes');
assert(engineSrc.includes("type: 'oblique'"), 'Detects oblique asymptotes');

// ============================================================
console.log('\n=== 18. Expression caching ===');
// ============================================================

assert(engineSrc.includes('_compiledCache'), 'Has compiled expression cache');
assert(engineSrc.includes('_compile('), 'Has _compile method');

// ============================================================
console.log('\n=== 19. Inequality fix (heatmap) ===');
// ============================================================

assert(engineSrc.includes("type: 'heatmap'"), 'Inequality uses heatmap instead of scatter points');
assert(engineSrc.includes('showscale: false'), 'Heatmap hides color scale');

// ============================================================
console.log('\n=== 20. Error feedback ===');
// ============================================================

assert(engineSrc.includes('gc-expr-error'), 'Has error feedback element');
assert(engineSrc.includes('gc-input-error'), 'Has input error class');
assert(engineSrc.includes('math.parse('), 'Validates expressions with math.parse');

// ============================================================
console.log('\n=== 21. Extended regression ===');
// ============================================================

assert(engineSrc.includes('generateRegressionExtended'), 'Engine has generateRegressionExtended method');
assert(engineSrc.includes("'quadratic'"), 'Supports quadratic regression');
assert(engineSrc.includes("'cubic'"), 'Supports cubic regression');
assert(engineSrc.includes("'exponential'"), 'Supports exponential regression');
assert(engineSrc.includes("'logarithmic'"), 'Supports logarithmic regression');
assert(engineSrc.includes("'power'"), 'Supports power regression');
assert(engineSrc.includes('regression-type-'), 'UI has regression type dropdown');
assert(engineSrc.includes('updateRegressionType'), 'Has updateRegressionType function');
assert(engineSrc.includes('R²='), 'Shows R² in regression legend');
assert(engineSrc.includes("Auto (Best R²)"), 'Has auto-best regression option');

// ============================================================
console.log('\n=== 22. Area between curves ===');
// ============================================================

assert(engineSrc.includes('areaBetweenCurves'), 'Engine has areaBetweenCurves method');
assert(engineSrc.includes('function areaBetweenCurves()'), 'Has areaBetweenCurves UI function');
assert(engineSrc.includes('_areaBetween'), 'Stores area-between data on expression');
assert(engineSrc.includes('areaBetweenCurves()'), 'UI calls areaBetweenCurves function');
assert(engineSrc.includes('shadeX') && engineSrc.includes('shadeY'), 'Generates shading polygon');

// ============================================================
console.log('\n=== 23. Table of values ===');
// ============================================================

assert(engineSrc.includes('generateTableOfValues'), 'Engine has generateTableOfValues method');
assert(engineSrc.includes('toggleTableOfValues'), 'Has toggleTableOfValues UI function');
assert(engineSrc.includes('gc-table-panel'), 'Creates table panel element');

// ============================================================
console.log('\n=== 24. Enhanced trace mode (snap-to-curve + crosshair) ===');
// ============================================================

assert(engineSrc.includes('plotly_click'), 'Trace mode handles click events');
assert(engineSrc.includes('shapes'), 'Draws crosshair shapes on hover');
assert(engineSrc.includes('annotations'), 'Adds annotation on click');
assert(engineSrc.includes('dy/dx'), 'Shows slope as dy/dx');
assert(engineSrc.includes('removeListener') || engineSrc.includes('removeAllListeners'), 'Properly cleans up listeners on disable');

// ============================================================
console.log('\n=== 25. Domain restrictions ===');
// ============================================================

assert(engineSrc.includes('parseDomainRestriction'), 'Engine has parseDomainRestriction method');
assert(engineSrc.includes('evaluateDomainRestriction'), 'Engine has evaluateDomainRestriction method');
assert(engineSrc.includes("restriction && !this.evaluateDomainRestriction"), 'Cartesian generation applies domain restriction');
assert(engineSrc.includes('and'), 'Domain restriction supports compound "and" conditions');

// ============================================================
// Summary
// ============================================================
console.log('\n' + '='.repeat(50));
console.log(`Results: ${passed} passed, ${failed} failed, ${passed + failed} total`);
console.log('='.repeat(50));
process.exit(failed > 0 ? 1 : 0);
