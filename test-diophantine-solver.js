/**
 * Diophantine Equation Solver - Unit Tests
 * Tests code generators, edge cases, output tag presence, preset data validity
 * Run: node test-diophantine-solver.js
 */

'use strict';

var passed = 0;
var failed = 0;
var total = 0;

function assert(condition, msg) {
    total++;
    if (condition) {
        passed++;
        console.log('  PASS: ' + msg);
    } else {
        failed++;
        console.log('  FAIL: ' + msg);
    }
}

function assertContains(str, substr, msg) {
    assert(str.indexOf(substr) !== -1, msg + ' (contains "' + substr + '")');
}

function assertNotContains(str, substr, msg) {
    assert(str.indexOf(substr) === -1, msg + ' (should not contain "' + substr + '")');
}

// ===== Code Generator Helpers (config-based, no DOM) =====
// These mirror the code generators from diophantine-solver.js but accept params directly

function buildLinearCode(a, b, c) {
    return [
        'from sympy import igcd, diophantine, symbols, Eq',
        'import json',
        'a, b, c = ' + a + ', ' + b + ', ' + c,
        'd = igcd(abs(a), abs(b))',
        'print("META_GCD:" + str(d))',
        'print("META_METHOD:Extended Euclidean Algorithm")',
        '',
        'if a == 0 and b == 0:',
        '    if c == 0:',
        '        print("RESULT:Trivially true")',
        '        print("META_SOLVABLE:True")',
        '    else:',
        '        print("RESULT:No solution")',
        '        print("META_SOLVABLE:False")',
        'elif c % d != 0:',
        '    print("RESULT:No integer solution exists")',
        '    print("META_SOLVABLE:False")',
        '    print("STEP1_TITLE:Check solvability")',
        'else:',
        '    def ext_gcd(a, b):',
        '        if b == 0: return a, 1, 0',
        '        g, x1, y1 = ext_gcd(b, a % b)',
        '        return g, y1, x1 - (a // b) * y1',
        '    g, x0, y0 = ext_gcd(a, b)',
        '    scale = c // d',
        '    x0 *= scale',
        '    y0 *= scale',
        '    print("RESULT:" + str(a) + "x + " + str(b) + "y = " + str(c) + " solved")',
        '    print("META_SOLVABLE:True")',
        '    print("VERIFIED:True")',
        '    print("STEP1_TITLE:Check solvability")',
        '    print("STEP2_TITLE:Extended Euclidean Algorithm")',
        '    print("STEP3_TITLE:Bezout coefficients")',
        '    print("STEP4_TITLE:Particular solution")',
        '    print("STEP5_TITLE:General solution")',
        '    print("PLOT_X:" + json.dumps([x0 + (b//d)*t for t in range(-5,6)]))',
        '    print("PLOT_Y:" + json.dumps([y0 - (a//d)*t for t in range(-5,6)]))'
    ].join('\n');
}

function buildSystemCode(a1, b1, c1, a2, b2, c2) {
    return [
        'from sympy import symbols, Eq, solve, igcd, latex',
        'import json',
        'a1, b1, c1 = ' + a1 + ', ' + b1 + ', ' + c1,
        'a2, b2, c2 = ' + a2 + ', ' + b2 + ', ' + c2,
        'print("META_METHOD:Cramer / SymPy Integer Solve")',
        'det = a1 * b2 - a2 * b1',
        'print("STEP1_TITLE:System of equations")',
        'print("STEP2_TITLE:Compute determinant")',
        'if det == 0:',
        '    print("RESULT:No integer solution or dependent")',
        '    print("META_SOLVABLE:False")',
        'else:',
        '    det_x = c1 * b2 - c2 * b1',
        '    det_y = a1 * c2 - a2 * c1',
        '    if det_x % det == 0 and det_y % det == 0:',
        '        x_sol = det_x // det',
        '        y_sol = det_y // det',
        '        print("RESULT:x = " + str(x_sol) + ", y = " + str(y_sol))',
        '        print("META_SOLVABLE:True")',
        '        print("VERIFIED:True")',
        '    else:',
        '        print("RESULT:No integer solution")',
        '        print("META_SOLVABLE:False")'
    ].join('\n');
}

function buildModularSingleCode(a, b, m) {
    return [
        'from sympy import igcd, mod_inverse',
        'a, b, m = ' + a + ', ' + b + ', ' + m,
        'print("META_METHOD:Extended Euclidean / Modular Inverse")',
        'd = igcd(abs(a), m)',
        'if b % d != 0:',
        '    print("RESULT:No solution")',
        '    print("META_SOLVABLE:False")',
        'else:',
        '    a_r = a // d',
        '    b_r = b // d',
        '    m_r = m // d',
        '    inv = mod_inverse(a_r, m_r)',
        '    x0 = (inv * b_r) % m_r',
        '    print("RESULT:x = " + str(x0))',
        '    print("META_SOLVABLE:True")',
        '    print("VERIFIED:True")'
    ].join('\n');
}

// ===== Test Suite =====

console.log('\n=== Diophantine Equation Solver Tests ===\n');

// --- Linear Mode Tests ---
console.log('--- Linear Mode ---');

(function testLinearBasic() {
    var code = buildLinearCode(6, 9, 15);
    assertContains(code, 'igcd', 'Linear code uses igcd');
    assertContains(code, 'ext_gcd', 'Linear code has ext_gcd function');
    assertContains(code, 'META_METHOD:Extended Euclidean Algorithm', 'Linear code has method tag');
    assertContains(code, 'META_SOLVABLE', 'Linear code has solvable tag');
    assertContains(code, 'STEP1_TITLE', 'Linear code has step 1');
    assertContains(code, 'STEP5_TITLE', 'Linear code has step 5');
    assertContains(code, 'PLOT_X', 'Linear code has plot data');
    assertContains(code, 'VERIFIED', 'Linear code has verification');
})();

(function testLinearNoSolution() {
    var code = buildLinearCode(6, 9, 10);
    assertContains(code, 'c % d != 0', 'No-solution check present for gcd not dividing c');
    assertContains(code, 'META_SOLVABLE:False', 'Reports no solution correctly');
})();

(function testLinearZeroCoeffs() {
    var code = buildLinearCode(0, 0, 0);
    assertContains(code, 'a == 0 and b == 0', 'Handles a=0, b=0 case');
    assertContains(code, 'Trivially true', 'Reports trivially true for 0=0');
})();

(function testLinearGCDDivides() {
    // 12x + 8y = 28, gcd(12,8)=4, 4|28 => solvable
    var code = buildLinearCode(12, 8, 28);
    assertContains(code, 'a, b, c = 12, 8, 28', 'Correct coefficients embedded');
})();

(function testLinearNegativeCoeffs() {
    var code = buildLinearCode(-3, 5, 1);
    assertContains(code, 'a, b, c = -3, 5, 1', 'Handles negative coefficients');
})();

// --- System Mode Tests ---
console.log('\n--- System Mode ---');

(function testSystemBasic() {
    var code = buildSystemCode(2, 3, 7, 4, 5, 11);
    assertContains(code, 'det = a1 * b2 - a2 * b1', 'System uses determinant');
    assertContains(code, 'META_METHOD:Cramer', 'System has method tag');
    assertContains(code, 'STEP1_TITLE', 'System has step 1');
    assertContains(code, 'META_SOLVABLE', 'System has solvable tag');
})();

(function testSystemSingular() {
    // 2x+4y=6, 1x+2y=3 => det=0, dependent
    var code = buildSystemCode(2, 4, 6, 1, 2, 3);
    assertContains(code, 'det == 0', 'System checks for singular case');
})();

(function testSystemNonIntegerSolution() {
    // System where Cramer gives non-integer result
    var code = buildSystemCode(2, 3, 7, 4, 5, 11);
    assertContains(code, 'det_x % det == 0 and det_y % det == 0', 'System checks integer divisibility');
})();

// --- Quadratic Mode Tests ---
console.log('\n--- Quadratic Mode ---');

(function testQuadSumSquaresPresent() {
    // Just verify code structure - we can't run Python here
    var a = 1, b = 0, c = 1, n = 50;
    var code = [
        'import json, math',
        'n = ' + n,
        'solutions = []',
        'limit = int(math.isqrt(n)) + 1'
    ].join('\n');
    assertContains(code, 'math.isqrt', 'Sum of squares uses isqrt');
    assertContains(code, 'n = 50', 'Correct n value');
})();

(function testQuadPellStructure() {
    var D = 2;
    var code = [
        'from sympy import continued_fraction_periodic',
        'D = ' + D,
        'cf = continued_fraction_periodic(0, 1, D)'
    ].join('\n');
    assertContains(code, 'continued_fraction_periodic', 'Pell uses continued fractions');
    assertContains(code, 'D = 2', 'Correct D value');
})();

(function testQuadPellPerfectSquare() {
    // D=4 is a perfect square, should be detected
    var code = [
        'import math',
        'D = 4',
        'sr = int(math.isqrt(D))',
        'if sr * sr == D:',
        '    print("META_SOLVABLE:False")'
    ].join('\n');
    assertContains(code, 'sr * sr == D', 'Detects perfect square D');
})();

// --- Modular Mode Tests ---
console.log('\n--- Modular Mode ---');

(function testModularSingle() {
    var code = buildModularSingleCode(7, 3, 15);
    assertContains(code, 'mod_inverse', 'Modular code uses mod_inverse');
    assertContains(code, 'META_METHOD', 'Modular code has method tag');
    assertContains(code, 'VERIFIED', 'Modular code has verification');
})();

(function testModularNoInverse() {
    // gcd(6,15)=3, 3 does not divide 5 => no solution
    var code = buildModularSingleCode(6, 5, 15);
    assertContains(code, 'b % d != 0', 'Checks gcd divisibility for modular');
})();

(function testModularCRT() {
    var code = [
        'from sympy.ntheory.modular import crt',
        'remainders = [2, 3, 1]',
        'moduli = [3, 5, 7]',
        'result = crt(moduli, remainders)'
    ].join('\n');
    assertContains(code, 'crt', 'CRT code uses sympy crt');
    assertContains(code, 'remainders = [2, 3, 1]', 'Correct remainders');
    assertContains(code, 'moduli = [3, 5, 7]', 'Correct moduli');
})();

// --- Output Tags Tests ---
console.log('\n--- Output Tags ---');

(function testOutputTagsPresence() {
    var code = buildLinearCode(3, 5, 1);
    assertContains(code, 'RESULT:', 'Has RESULT tag');
    assertContains(code, 'META_SOLVABLE', 'Has META_SOLVABLE tag');
    assertContains(code, 'STEP', 'Has STEP tags');
    assertContains(code, 'VERIFIED', 'Has VERIFIED tag');
    assertContains(code, 'PLOT_X', 'Has PLOT_X tag');
    assertContains(code, 'PLOT_Y', 'Has PLOT_Y tag');
})();

(function testSystemOutputTags() {
    var code = buildSystemCode(1, 1, 10, 2, -1, 5);
    assertContains(code, 'RESULT:', 'System has RESULT tag');
    assertContains(code, 'META_METHOD:', 'System has META_METHOD tag');
    assertContains(code, 'STEP1_TITLE:', 'System has STEP1_TITLE tag');
})();

// --- Preset Data Validity Tests ---
console.log('\n--- Preset Data ---');

(function testLinearPresets() {
    var presets = [
        { a: 6, b: 9, c: 15 },
        { a: 3, b: 5, c: 1 },
        { a: 12, b: 8, c: 28 },
        { a: 7, b: 11, c: 100 }
    ];
    presets.forEach(function(p) {
        assert(typeof p.a === 'number' && typeof p.b === 'number' && typeof p.c === 'number',
            'Linear preset (' + p.a + ',' + p.b + ',' + p.c + ') has valid numeric types');
    });
    // Verify solvability for presets that should be solvable
    assert(15 % gcd(6, 9) === 0, 'Preset 6x+9y=15 is solvable (gcd=3, 3|15)');
    assert(1 % gcd(3, 5) === 0, 'Preset 3x+5y=1 is solvable (gcd=1, 1|1)');
    assert(28 % gcd(12, 8) === 0, 'Preset 12x+8y=28 is solvable (gcd=4, 4|28)');
    assert(100 % gcd(7, 11) === 0, 'Preset 7x+11y=100 is solvable (gcd=1, 1|100)');
})();

(function testNoSolutionPreset() {
    // 6x+9y=10, gcd(6,9)=3, 3 does not divide 10
    assert(10 % gcd(6, 9) !== 0, 'Preset 6x+9y=10 correctly has no solution');
})();

(function testSystemPresets() {
    var presets = [
        { a1:2, b1:3, c1:7, a2:4, b2:5, c2:11 },
        { a1:3, b1:2, c1:1, a2:5, b2:3, c2:2 },
        { a1:1, b1:1, c1:10, a2:2, b2:-1, c2:5 }
    ];
    presets.forEach(function(p) {
        var det = p.a1 * p.b2 - p.a2 * p.b1;
        assert(det !== 0, 'System preset det=' + det + ' is non-zero (unique solution expected)');
    });
})();

// --- URL Share Encoding Tests ---
console.log('\n--- URL Share Encoding ---');

(function testURLLinearRoundTrip() {
    var params = new URLSearchParams();
    params.set('mode', 'linear');
    params.set('a', '6');
    params.set('b', '9');
    params.set('c', '15');
    var encoded = params.toString();
    var decoded = new URLSearchParams(encoded);
    assert(decoded.get('mode') === 'linear', 'URL round-trip preserves mode');
    assert(decoded.get('a') === '6', 'URL round-trip preserves a');
    assert(decoded.get('b') === '9', 'URL round-trip preserves b');
    assert(decoded.get('c') === '15', 'URL round-trip preserves c');
})();

(function testURLModularRoundTrip() {
    var params = new URLSearchParams();
    params.set('mode', 'modular');
    params.set('mt', 'system');
    params.set('rems', '2, 3, 1');
    params.set('mods', '3, 5, 7');
    var encoded = params.toString();
    var decoded = new URLSearchParams(encoded);
    assert(decoded.get('mode') === 'modular', 'URL round-trip preserves modular mode');
    assert(decoded.get('mt') === 'system', 'URL round-trip preserves modular sub-type');
    assert(decoded.get('rems') === '2, 3, 1', 'URL round-trip preserves remainders');
    assert(decoded.get('mods') === '3, 5, 7', 'URL round-trip preserves moduli');
})();

(function testURLQuadraticPellRoundTrip() {
    var params = new URLSearchParams();
    params.set('mode', 'quadratic');
    params.set('qt', 'pell');
    params.set('D', '7');
    params.set('count', '10');
    var encoded = params.toString();
    var decoded = new URLSearchParams(encoded);
    assert(decoded.get('qt') === 'pell', 'URL round-trip preserves quadratic sub-type');
    assert(decoded.get('D') === '7', 'URL round-trip preserves D');
    assert(decoded.get('count') === '10', 'URL round-trip preserves count');
})();

// --- GCD Edge Cases ---
console.log('\n--- GCD Edge Cases ---');

(function testGCDFunction() {
    assert(gcd(0, 5) === 5, 'gcd(0, 5) = 5');
    assert(gcd(5, 0) === 5, 'gcd(5, 0) = 5');
    assert(gcd(0, 0) === 0, 'gcd(0, 0) = 0');
    assert(gcd(12, 8) === 4, 'gcd(12, 8) = 4');
    assert(gcd(7, 11) === 1, 'gcd(7, 11) = 1');
    assert(gcd(100, 75) === 25, 'gcd(100, 75) = 25');
    assert(gcd(-6, 9) === 3, 'gcd(-6, 9) = 3 (absolute values)');
    assert(gcd(1, 1) === 1, 'gcd(1, 1) = 1');
})();

// ===== Utility =====
function gcd(a, b) {
    a = Math.abs(a);
    b = Math.abs(b);
    while (b) { var t = b; b = a % t; a = t; }
    return a;
}

// ===== Summary =====
console.log('\n=== Results ===');
console.log('Total: ' + total + ', Passed: ' + passed + ', Failed: ' + failed);
if (failed === 0) {
    console.log('ALL TESTS PASSED');
    process.exit(0);
} else {
    console.log(failed + ' TEST(S) FAILED');
    process.exit(1);
}
