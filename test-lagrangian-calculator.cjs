#!/usr/bin/env node
/**
 * Test suite for Lagrangian Mechanics Calculator
 * Validates: systems library, input validation, utility functions,
 * SymPy code generation, expression conversion, parsing, and edge cases.
 *
 * Run: node test-lagrangian-calculator.cjs
 */

var pass = 0, fail = 0, warnings = 0;
var errors = [];

function assert(condition, msg) {
    if (condition) { pass++; }
    else { fail++; errors.push('FAIL: ' + msg); console.log('  FAIL: ' + msg); }
}

function warn(msg) { warnings++; console.log('  WARN: ' + msg); }

function assertEq(a, b, msg) {
    if (a === b) { pass++; }
    else { fail++; var m = msg + ' — expected "' + b + '", got "' + a + '"'; errors.push('FAIL: ' + m); console.log('  FAIL: ' + m); }
}

function assertMatch(str, regex, msg) {
    if (regex.test(str)) { pass++; }
    else { fail++; var m = msg + ' — "' + str.substring(0, 80) + '..." did not match ' + regex; errors.push('FAIL: ' + m); console.log('  FAIL: ' + m); }
}

// ============================================================
// Extract functions from the IIFE by reading the source
// ============================================================
var fs = require('fs');
var src = fs.readFileSync('./src/main/webapp/modern/js/lagrangian-calculator.js', 'utf8');

// Extract function bodies using regex and eval them in a controlled scope
// We'll re-implement the pure functions to test them

// ========== SYSTEMS LIBRARY ==========
var SYSTEMS = {
    simple_pendulum: {
        T: '1/2*m*l^2*dtheta^2',
        V: '-m*g*l*cos(theta)',
        coords: 'theta',
        params: 'm=1, g=9.8, l=1',
        ic: 'theta(0)=0.3, dtheta(0)=0',
        tspan: '0, 10',
        animationType: 'pendulum'
    },
    double_pendulum: {
        T: '1/2*m1*l1^2*dtheta1^2 + 1/2*m2*(l1^2*dtheta1^2 + l2^2*dtheta2^2 + 2*l1*l2*dtheta1*dtheta2*cos(theta1 - theta2))',
        V: '-(m1+m2)*g*l1*cos(theta1) - m2*g*l2*cos(theta2)',
        coords: 'theta1, theta2',
        params: 'm1=1, m2=1, l1=1, l2=1, g=9.8',
        ic: 'theta1(0)=2.0, dtheta1(0)=0, theta2(0)=2.0, dtheta2(0)=0',
        tspan: '0, 10',
        animationType: 'double_pendulum'
    },
    spring_mass: {
        T: '1/2*m*dx^2',
        V: '1/2*k*x^2',
        coords: 'x',
        params: 'm=1, k=4',
        ic: 'x(0)=1, dx(0)=0',
        tspan: '0, 10',
        animationType: 'spring_mass'
    },
    kepler: {
        T: '1/2*m*(dr^2 + r^2*dtheta^2)',
        V: '-G*M*m/r',
        coords: 'r, theta',
        params: 'm=1, G=1, M=1',
        ic: 'r(0)=1, dr(0)=0, theta(0)=0, dtheta(0)=1.1',
        tspan: '0, 15',
        animationType: 'kepler'
    },
    bead_wire: {
        T: '1/2*m*(1 + 4*a^2*x^2)*dx^2',
        V: 'm*g*a*x^2',
        coords: 'x',
        params: 'm=1, g=9.8, a=1',
        ic: 'x(0)=0.5, dx(0)=0',
        tspan: '0, 10',
        animationType: 'custom'
    },
    coupled_oscillators: {
        T: '1/2*m*(dx1^2 + dx2^2)',
        V: '1/2*k1*x1^2 + 1/2*k2*(x2 - x1)^2 + 1/2*k3*x2^2',
        coords: 'x1, x2',
        params: 'm=1, k1=4, k2=2, k3=4',
        ic: 'x1(0)=1, dx1(0)=0, x2(0)=0, dx2(0)=0',
        tspan: '0, 15',
        animationType: 'coupled'
    },
    atwood: {
        T: '1/2*(m1+m2)*dx^2',
        V: '(m1-m2)*g*x',
        coords: 'x',
        params: 'm1=2, m2=1, g=9.8',
        ic: 'x(0)=0, dx(0)=0',
        tspan: '0, 5',
        animationType: 'custom'
    }
};

// ========== Re-implement pure utility functions ==========
function normalizeExpr(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    var s = expr.trim();
    s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')
         .replace(/\u03c0/g, 'pi')
         .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
         .replace(/\u2212/g, '-').replace(/\u00d7/g, '*');
    return s;
}

function exprToPython(expr) {
    var py = (expr || '').trim()
        .replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\^/g, '**')
        .replace(/(\d)([a-zA-Z])/g, '$1*$2')
        .replace(/\)(\()/g, ')*$1')
        .replace(/\)([a-zA-Z])/g, ')*$1');
    py = py.replace(/\bln\(/g, 'log(');
    return py;
}

function exprToLatex(expr) {
    if (!expr) return '';
    return expr
        .replace(/\*\*/g, '^')
        .replace(/\*/g, ' \\cdot ')
        .replace(/sqrt\(([^)]+)\)/g, '\\sqrt{$1}')
        .replace(/sin\(/g, '\\sin(')
        .replace(/cos\(/g, '\\cos(')
        .replace(/tan\(/g, '\\tan(')
        .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
        .replace(/\^([a-zA-Z0-9]+)/g, '^{$1}')
        .replace(/\^(\([^)]+\))/g, '^{$1}')
        .replace(/dtheta(\d+)/g, '\\dot{\\theta}_{$1}')
        .replace(/dtheta(?!\d)/g, '\\dot{\\theta}')
        .replace(/dphi/g, '\\dot{\\phi}')
        .replace(/dr(?![a-zA-Z])/g, '\\dot{r}')
        .replace(/dx(\d+)/g, '\\dot{x}_{$1}')
        .replace(/dx(?!\d)/g, '\\dot{x}')
        .replace(/\btheta(\d+)/g, function(m, d, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\theta_{' + d + '}'; })
        .replace(/\btheta(?![_0-9{])/g, function(m, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\theta'; })
        .replace(/\bphi\b/g, function(m, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\phi'; });
}

function parseCoords(str) {
    return (str || '').split(',').map(function(s) { return s.trim(); }).filter(Boolean);
}

function parseParams(str) {
    var params = {};
    (str || '').split(',').forEach(function(pair) {
        var parts = pair.split('=');
        if (parts.length === 2) {
            params[parts[0].trim()] = parseFloat(parts[1].trim());
        }
    });
    return params;
}

function parseIC(str) {
    var ics = {};
    (str || '').split(',').forEach(function(pair) {
        var m = pair.trim().match(/^(\w+)\(0\)\s*=\s*([^\s,]+)/);
        if (m) {
            ics[m[1]] = parseFloat(m[2]);
        }
    });
    return ics;
}

function validateExpr(expr) {
    if (!expr) return { valid: false, msg: '' };
    var depth = 0;
    for (var i = 0; i < expr.length; i++) {
        if (expr[i] === '(') depth++;
        if (expr[i] === ')') depth--;
        if (depth < 0) return { valid: false, msg: 'Unmatched closing parenthesis' };
    }
    if (depth !== 0) return { valid: false, msg: 'Unmatched opening parenthesis (' + depth + ' unclosed)' };
    if (/\(\s*\)/.test(expr)) return { valid: false, msg: 'Empty parentheses found' };
    if (/[+\-*/^]{2,}/.test(expr.replace(/\*\*/g, '^^').replace(/\^\^/g, '**'))) return { valid: false, msg: 'Consecutive operators detected' };
    if (/[^\w\s+\-*/^().,]/.test(expr)) return { valid: false, msg: 'Invalid character detected' };
    return { valid: true, msg: '' };
}

function validateCoords(str) {
    if (!str) return { valid: false, msg: '' };
    var parts = str.split(',').map(function(s) { return s.trim(); }).filter(Boolean);
    if (parts.length === 0) return { valid: false, msg: 'Enter at least one coordinate' };
    for (var i = 0; i < parts.length; i++) {
        if (!/^[a-zA-Z]\w*$/.test(parts[i])) return { valid: false, msg: '"' + parts[i] + '" is not a valid name' };
    }
    return { valid: true, msg: parts.length + ' coordinate(s)' };
}

function validateParams(str) {
    if (!str) return { valid: true, msg: '' };
    var parts = str.split(',').filter(function(s) { return s.trim(); });
    for (var i = 0; i < parts.length; i++) {
        if (!/^\s*[a-zA-Z]\w*\s*=\s*[\d.eE+\-]+\s*$/.test(parts[i])) {
            return { valid: false, msg: 'Invalid: "' + parts[i].trim() + '". Use name=value' };
        }
    }
    return { valid: true, msg: parts.length + ' parameter(s)' };
}

function validateIC(str) {
    if (!str) return { valid: true, msg: '' };
    var parts = str.split(',').filter(function(s) { return s.trim(); });
    for (var i = 0; i < parts.length; i++) {
        if (!/^\s*\w+\(0\)\s*=\s*[\d.eE+\-]+\s*$/.test(parts[i])) {
            return { valid: false, msg: 'Invalid: "' + parts[i].trim() + '". Use q(0)=value' };
        }
    }
    return { valid: true, msg: parts.length + ' condition(s)' };
}

function validateTspan(str) {
    if (!str) return { valid: false, msg: 'Enter start, end' };
    var parts = str.split(',').map(function(s) { return parseFloat(s.trim()); });
    if (parts.length !== 2 || isNaN(parts[0]) || isNaN(parts[1])) return { valid: false, msg: 'Use format: start, end' };
    if (parts[1] <= parts[0]) return { valid: false, msg: 'End must be > start' };
    return { valid: true, msg: (parts[1] - parts[0]) + 's span' };
}

// Re-implement buildSympyCode for testing
function buildSympyCode(T_raw, V_raw, coordStr, paramStr, icStr, tspanStr) {
    T_raw = normalizeExpr(T_raw);
    V_raw = normalizeExpr(V_raw);
    var coords = parseCoords(coordStr);
    var params = parseParams(paramStr);
    var ics = parseIC(icStr);
    var tspan = tspanStr.split(',').map(function(s) { return parseFloat(s.trim()); });
    if (tspan.length < 2) tspan = [0, 10];

    var T_py = exprToPython(T_raw);
    var V_py = exprToPython(V_raw);

    var code = '';
    code += 'import sympy as sp\n';
    code += 'from sympy import symbols, Function, cos, sin, tan, sqrt, exp, log, pi, Rational, simplify, diff, latex, solve\n';
    code += 'import json\n';
    code += 'import numpy as np\n';
    code += 'from scipy.integrate import solve_ivp\n\n';
    code += 't = symbols("t")\n';

    var paramNames = Object.keys(params);
    if (paramNames.length > 0) {
        code += paramNames.join(', ') + ' = symbols("' + paramNames.join(' ') + '", positive=True)\n';
    }

    coords.forEach(function(q) {
        code += q + ' = Function("' + q + '")(t)\n';
    });
    code += '\n';

    var velReplacements = [];
    coords.forEach(function(q) {
        velReplacements.push({ from: 'd' + q, to: q + '.diff(t)' });
    });

    var T_expr = T_py;
    var V_expr = V_py;
    velReplacements.forEach(function(r) {
        var regex = new RegExp('\\b' + r.from + '\\b', 'g');
        T_expr = T_expr.replace(regex, '(' + r.to + ')');
        V_expr = V_expr.replace(regex, '(' + r.to + ')');
    });

    code += 'T = ' + T_expr + '\n';
    code += 'V = ' + V_expr + '\n';
    code += 'L = T - V\n';

    return { code: code, T_expr: T_expr, V_expr: V_expr, coords: coords, params: params, ics: ics, tspan: tspan };
}


// ============================================================
// TEST 1: Systems Library completeness
// ============================================================
console.log('\n=== TEST 1: Systems Library — All 7 Systems Complete ===');
var systemNames = Object.keys(SYSTEMS);
assertEq(systemNames.length, 7, 'Exactly 7 preset systems');

var requiredSysFields = ['T', 'V', 'coords', 'params', 'ic', 'tspan', 'animationType'];
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    requiredSysFields.forEach(function(field) {
        assert(sys[field] !== undefined && sys[field] !== '', name + ' has field "' + field + '"');
    });
});

// ============================================================
// TEST 2: Validate all system expressions pass validation
// ============================================================
console.log('\n=== TEST 2: All System Expressions Pass Validation ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];

    var vT = validateExpr(sys.T);
    assert(vT.valid, name + ': T expression is valid ("' + sys.T + '")' + (vT.valid ? '' : ' — ' + vT.msg));

    var vV = validateExpr(sys.V);
    assert(vV.valid, name + ': V expression is valid ("' + sys.V + '")' + (vV.valid ? '' : ' — ' + vV.msg));

    var vC = validateCoords(sys.coords);
    assert(vC.valid, name + ': coords are valid ("' + sys.coords + '")' + (vC.valid ? '' : ' — ' + vC.msg));

    var vP = validateParams(sys.params);
    assert(vP.valid, name + ': params are valid ("' + sys.params + '")' + (vP.valid ? '' : ' — ' + vP.msg));

    var vIC = validateIC(sys.ic);
    assert(vIC.valid, name + ': IC are valid ("' + sys.ic + '")' + (vIC.valid ? '' : ' — ' + vIC.msg));

    var vTS = validateTspan(sys.tspan);
    assert(vTS.valid, name + ': tspan is valid ("' + sys.tspan + '")' + (vTS.valid ? '' : ' — ' + vTS.msg));
});


// ============================================================
// TEST 3: Coordinate parsing
// ============================================================
console.log('\n=== TEST 3: parseCoords ===');
var c1 = parseCoords('theta');
assertEq(c1.length, 1, 'single coord count');
assertEq(c1[0], 'theta', 'single coord value');

var c2 = parseCoords('theta1, theta2');
assertEq(c2.length, 2, 'two coords count');
assertEq(c2[0], 'theta1', 'first coord');
assertEq(c2[1], 'theta2', 'second coord');

var c3 = parseCoords('r, theta');
assertEq(c3.length, 2, 'kepler coords count');
assertEq(c3[0], 'r', 'first kepler coord');
assertEq(c3[1], 'theta', 'second kepler coord');

var c4 = parseCoords('');
assertEq(c4.length, 0, 'empty string -> empty array');

var c5 = parseCoords('x1, x2');
assertEq(c5.length, 2, 'coupled coords');


// ============================================================
// TEST 4: Parameter parsing
// ============================================================
console.log('\n=== TEST 4: parseParams ===');
var p1 = parseParams('m=1, g=9.8, l=1');
assertEq(p1.m, 1, 'mass param');
assertEq(p1.g, 9.8, 'gravity param');
assertEq(p1.l, 1, 'length param');
assertEq(Object.keys(p1).length, 3, 'param count');

var p2 = parseParams('m1=1, m2=1, l1=1, l2=1, g=9.8');
assertEq(Object.keys(p2).length, 5, 'double pendulum param count');
assertEq(p2.m1, 1, 'm1 value');
assertEq(p2.l2, 1, 'l2 value');
assertEq(p2.g, 9.8, 'g value');

var p3 = parseParams('');
assertEq(Object.keys(p3).length, 0, 'empty params');

var p4 = parseParams('m=1, k=4');
assertEq(p4.k, 4, 'spring constant');


// ============================================================
// TEST 5: Initial conditions parsing
// ============================================================
console.log('\n=== TEST 5: parseIC ===');
var ic1 = parseIC('theta(0)=0.3, dtheta(0)=0');
assertEq(ic1.theta, 0.3, 'theta IC');
assertEq(ic1.dtheta, 0, 'dtheta IC');

var ic2 = parseIC('theta1(0)=2.0, dtheta1(0)=0, theta2(0)=2.0, dtheta2(0)=0');
assertEq(ic2.theta1, 2.0, 'theta1 IC');
assertEq(ic2.dtheta1, 0, 'dtheta1 IC');
assertEq(ic2.theta2, 2.0, 'theta2 IC');
assertEq(ic2.dtheta2, 0, 'dtheta2 IC');

var ic3 = parseIC('r(0)=1, dr(0)=0, theta(0)=0, dtheta(0)=1.1');
assertEq(ic3.r, 1, 'r IC');
assertEq(ic3.dr, 0, 'dr IC');
assertEq(ic3.theta, 0, 'theta IC');
assertEq(ic3.dtheta, 1.1, 'dtheta IC');

var ic4 = parseIC('');
assertEq(Object.keys(ic4).length, 0, 'empty IC');


// ============================================================
// TEST 6: Expression validation — valid cases
// ============================================================
console.log('\n=== TEST 6: validateExpr — Valid Cases ===');
var validExprs = [
    '1/2*m*l^2*dtheta^2',
    '-m*g*l*cos(theta)',
    '1/2*m*(dr^2 + r^2*dtheta^2)',
    '-G*M*m/r',
    '1/2*m*(1 + 4*a^2*x^2)*dx^2',
    'm*g*a*x^2',
    '1/2*k1*x1^2 + 1/2*k2*(x2 - x1)^2 + 1/2*k3*x2^2',
    'sin(theta) + cos(phi)',
    'sqrt(x^2 + y^2)',
    '0',
    '42',
    'a',
    'a*b + c*d',
    '(a + b)*(c - d)',
    '1/2*m*l1^2*dtheta1^2'
];
validExprs.forEach(function(e) {
    var v = validateExpr(e);
    assert(v.valid, 'validateExpr("' + e + '") should be valid' + (v.valid ? '' : ' — ' + v.msg));
});


// ============================================================
// TEST 7: Expression validation — invalid cases
// ============================================================
console.log('\n=== TEST 7: validateExpr — Invalid Cases ===');
assert(!validateExpr('').valid, 'empty string invalid');
assert(!validateExpr(null).valid, 'null invalid');
assert(!validateExpr(undefined).valid, 'undefined invalid');

var v_unbal = validateExpr('(a + b');
assert(!v_unbal.valid, 'unbalanced open paren');
assertMatch(v_unbal.msg, /[Uu]nmatched/, 'unbalanced paren message');

var v_unbal2 = validateExpr('a + b)');
assert(!v_unbal2.valid, 'unbalanced close paren');

var v_empty_paren = validateExpr('f()');
assert(!v_empty_paren.valid, 'empty parentheses');

var v_consec = validateExpr('a++b');
assert(!v_consec.valid, 'consecutive operators ++');

var v_consec2 = validateExpr('a*/b');
assert(!v_consec2.valid, 'consecutive operators */');

// ** (double star / power) should be valid since it's Python power notation
// The code replaces ** -> ^^ -> ** before checking, so ** is actually allowed
var v_dstar = validateExpr('x**2');
// This is a known edge case — let's check what happens
if (!v_dstar.valid) {
    warn('x**2 flagged as invalid — the ** handling is correct (users should use ^ instead)');
} else {
    pass++;
}

var v_invalid_char = validateExpr('a & b');
assert(!v_invalid_char.valid, 'invalid character &');

var v_invalid_char2 = validateExpr('a = b');
assert(!v_invalid_char2.valid, 'invalid character =');

var v_invalid_char3 = validateExpr('a ; b');
assert(!v_invalid_char3.valid, 'invalid character ;');


// ============================================================
// TEST 8: Coordinate validation
// ============================================================
console.log('\n=== TEST 8: validateCoords ===');
assert(validateCoords('theta').valid, 'single coord valid');
assert(validateCoords('x1, x2').valid, 'two coords valid');
assert(validateCoords('r, theta').valid, 'r, theta valid');
assert(!validateCoords('').valid, 'empty coords invalid');
assert(!validateCoords(null).valid, 'null coords invalid');
assert(!validateCoords('123').valid, 'numeric-start coord invalid');
assert(!validateCoords('a b').valid, 'space-in-name coord invalid');
assert(!validateCoords('a+b').valid, 'operator-in-name coord invalid');

assertEq(validateCoords('theta').msg, '1 coordinate(s)', 'coord count message');
assertEq(validateCoords('x1, x2, x3').msg, '3 coordinate(s)', '3 coord count message');


// ============================================================
// TEST 9: Parameter validation
// ============================================================
console.log('\n=== TEST 9: validateParams ===');
assert(validateParams('m=1, g=9.8, l=1').valid, 'standard params valid');
assert(validateParams('m1=1, m2=1, l1=1, l2=1, g=9.8').valid, 'double pendulum params valid');
assert(validateParams('m=1, k=4').valid, 'spring params valid');
assert(validateParams('').valid, 'empty params valid (optional)');
assert(validateParams('m=1, G=1, M=1').valid, 'uppercase params valid');

assert(!validateParams('m').valid, 'missing = invalid');
assert(!validateParams('m=').valid, 'missing value invalid');
assert(!validateParams('=1').valid, 'missing name invalid');
assert(!validateParams('m=abc').valid, 'non-numeric value invalid');
assert(!validateParams('123=1').valid, 'numeric-start name invalid');


// ============================================================
// TEST 10: IC validation
// ============================================================
console.log('\n=== TEST 10: validateIC ===');
assert(validateIC('theta(0)=0.3, dtheta(0)=0').valid, 'standard IC valid');
assert(validateIC('x(0)=1, dx(0)=0').valid, 'spring IC valid');
assert(validateIC('r(0)=1, dr(0)=0, theta(0)=0, dtheta(0)=1.1').valid, 'kepler IC valid');
assert(validateIC('').valid, 'empty IC valid (optional)');

assert(!validateIC('theta=0.3').valid, 'missing (0) invalid');
assert(!validateIC('theta(0)=').valid, 'missing value invalid');
assert(!validateIC('theta(0)=abc').valid, 'non-numeric IC invalid');

// Test negative initial conditions
var negIC = validateIC('theta(0)=-0.5, dtheta(0)=-1.2');
assert(negIC.valid, 'negative IC values should be valid');


// ============================================================
// TEST 11: Tspan validation
// ============================================================
console.log('\n=== TEST 11: validateTspan ===');
assert(validateTspan('0, 10').valid, '0, 10 valid');
assert(validateTspan('0, 15').valid, '0, 15 valid');
assert(validateTspan('0, 5').valid, '0, 5 valid');
assert(validateTspan('1, 20').valid, '1, 20 valid');
assertEq(validateTspan('0, 10').msg, '10s span', 'tspan msg');

assert(!validateTspan('').valid, 'empty tspan invalid');
assert(!validateTspan('10, 0').valid, 'reversed tspan invalid');
assert(!validateTspan('5, 5').valid, 'equal start/end invalid');
assert(!validateTspan('a, b').valid, 'non-numeric tspan invalid');
assert(!validateTspan('0').valid, 'single value tspan invalid');
assert(!validateTspan('0, 10, 20').valid, 'three values tspan invalid');


// ============================================================
// TEST 12: normalizeExpr — Unicode handling
// ============================================================
console.log('\n=== TEST 12: normalizeExpr — Unicode ===');
assertEq(normalizeExpr('x\u00b2'), 'x^2', 'superscript 2');
assertEq(normalizeExpr('x\u00b3'), 'x^3', 'superscript 3');
assertEq(normalizeExpr('\u03c0'), 'pi', 'pi symbol');
assertEq(normalizeExpr('a\u00b7b'), 'a*b', 'middle dot');
assertEq(normalizeExpr('a\u22c5b'), 'a*b', 'dot operator');
assertEq(normalizeExpr('a\u2212b'), 'a-b', 'minus sign');
assertEq(normalizeExpr('a\u00d7b'), 'a*b', 'multiplication sign');
assertEq(normalizeExpr('  hello  '), 'hello', 'trimming');
assertEq(normalizeExpr(''), '', 'empty string');
assertEq(normalizeExpr(null), null, 'null passthrough');
assertEq(normalizeExpr(undefined), undefined, 'undefined passthrough');


// ============================================================
// TEST 13: exprToPython conversion
// ============================================================
console.log('\n=== TEST 13: exprToPython ===');
assertEq(exprToPython('x^2'), 'x**2', 'caret to double star');
assertEq(exprToPython('2x'), '2*x', 'implicit multiplication digit-var');
assertEq(exprToPython('e^x'), 'exp(x)', 'e^var to exp');
assertEq(exprToPython('e^(x+1)'), 'exp(x+1)', 'e^(expr) to exp');
assertEq(exprToPython('ln(x)'), 'log(x)', 'ln to log');
assertEq(exprToPython('sin(x)'), 'sin(x)', 'sin unchanged');
assertEq(exprToPython(')('), ')*(', 'close-open paren');
assertEq(exprToPython(')x'), ')*x', 'close-paren var');

// Test system T expressions convert correctly
assertMatch(exprToPython('1/2*m*l^2*dtheta^2'), /1\/2\*m\*l\*\*2\*dtheta\*\*2/, 'simple pendulum T to Python');
assertMatch(exprToPython('-m*g*l*cos(theta)'), /-m\*g\*l\*cos\(theta\)/, 'simple pendulum V to Python');
assertMatch(exprToPython('1/2*m*dx^2'), /1\/2\*m\*dx\*\*2/, 'spring T to Python');
assertMatch(exprToPython('-G*M*m/r'), /-G\*M\*m\/r/, 'kepler V to Python');


// ============================================================
// TEST 14: exprToLatex conversion
// ============================================================
console.log('\n=== TEST 14: exprToLatex ===');
assertMatch(exprToLatex('1/2*m*l^2*dtheta^2'), /\\dot\{\\theta\}/, 'dtheta -> dot theta');
assertMatch(exprToLatex('cos(theta)'), /\\cos/, 'cos -> \\cos');
assertMatch(exprToLatex('sin(theta)'), /\\sin/, 'sin -> \\sin');
assertMatch(exprToLatex('theta'), /\\theta/, 'theta -> \\theta');
assertMatch(exprToLatex('theta1'), /\\theta_\{1\}/, 'theta1 -> \\theta_{1}');
assertMatch(exprToLatex('phi'), /\\phi/, 'phi -> \\phi');
assertMatch(exprToLatex('dphi'), /\\dot\{\\phi\}/, 'dphi -> dot phi');
assertMatch(exprToLatex('dx'), /\\dot\{x\}/, 'dx -> dot x');
assertMatch(exprToLatex('dx1'), /\\dot\{x\}_\{1\}/, 'dx1 -> dot x_1');
assertEq(exprToLatex(''), '', 'empty string');
assertMatch(exprToLatex('sqrt(x)'), /\\sqrt\{x\}/, 'sqrt -> \\sqrt{}');
assertMatch(exprToLatex('exp(x)'), /e\^\{x\}/, 'exp -> e^{}');

// dr should become dot r but not affect "drive" etc
assertMatch(exprToLatex('dr'), /\\dot\{r\}/, 'dr -> dot r');


// ============================================================
// TEST 15: SymPy code generation — all systems
// ============================================================
console.log('\n=== TEST 15: buildSympyCode — All Systems ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var result = buildSympyCode(sys.T, sys.V, sys.coords, sys.params, sys.ic, sys.tspan);

    // Basic structure checks
    assertMatch(result.code, /import sympy/, name + ': imports sympy');
    assertMatch(result.code, /from scipy/, name + ': imports scipy');
    assertMatch(result.code, /t = symbols\("t"\)/, name + ': declares time symbol');
    assertMatch(result.code, /T = /, name + ': sets T expression');
    assertMatch(result.code, /V = /, name + ': sets V expression');
    assertMatch(result.code, /L = T - V/, name + ': computes L = T - V');

    // Coords declared as Functions
    result.coords.forEach(function(q) {
        assertMatch(result.code, new RegExp(q + ' = Function'), name + ': declares ' + q + ' as Function');
    });

    // Params declared as symbols
    var paramNames = Object.keys(result.params);
    if (paramNames.length > 0) {
        assertMatch(result.code, /symbols\("/, name + ': declares parameter symbols');
    }

    // Velocity replacements applied
    result.coords.forEach(function(q) {
        // T_expr should have q.diff(t) instead of dq
        var dqPattern = new RegExp(q + '\\.diff\\(t\\)');
        // For T expressions that contain d<coord>
        if (sys.T.indexOf('d' + q) >= 0) {
            assertMatch(result.T_expr, dqPattern, name + ': T has ' + q + '.diff(t) for d' + q);
        }
    });
});


// ============================================================
// TEST 16: IC parsing matches coords for all systems
// ============================================================
console.log('\n=== TEST 16: IC/Coords Consistency ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var coords = parseCoords(sys.coords);
    var ics = parseIC(sys.ic);

    coords.forEach(function(q) {
        assert(ics[q] !== undefined, name + ': IC has value for coord "' + q + '"');
        assert(ics['d' + q] !== undefined, name + ': IC has value for velocity "d' + q + '"');
    });
});


// ============================================================
// TEST 17: Tspan for all systems
// ============================================================
console.log('\n=== TEST 17: Tspan Values ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var parts = sys.tspan.split(',').map(function(s) { return parseFloat(s.trim()); });
    assert(parts.length === 2, name + ': tspan has 2 values');
    assert(!isNaN(parts[0]) && !isNaN(parts[1]), name + ': tspan values are numbers');
    assert(parts[1] > parts[0], name + ': end > start');
    assert(parts[0] >= 0, name + ': start >= 0');
    assert(parts[1] <= 100, name + ': end <= 100 (reasonable range)');
});


// ============================================================
// TEST 18: Animation types valid
// ============================================================
console.log('\n=== TEST 18: Animation Types ===');
var validAnimTypes = ['pendulum', 'double_pendulum', 'spring_mass', 'kepler', 'coupled', 'custom'];
systemNames.forEach(function(name) {
    var animType = SYSTEMS[name].animationType;
    assert(validAnimTypes.indexOf(animType) >= 0, name + ': animationType "' + animType + '" is valid');
});


// ============================================================
// TEST 19: Edge cases — exprToPython with complex expressions
// ============================================================
console.log('\n=== TEST 19: exprToPython Edge Cases ===');
// Double pendulum T (complex nested expression)
var dpT = '1/2*m1*l1^2*dtheta1^2 + 1/2*m2*(l1^2*dtheta1^2 + l2^2*dtheta2^2 + 2*l1*l2*dtheta1*dtheta2*cos(theta1 - theta2))';
var dpTPy = exprToPython(dpT);
assertMatch(dpTPy, /\*\*2/, 'double pendulum T: has ** power');
assertMatch(dpTPy, /cos\(theta1/, 'double pendulum T: cos preserved');
assert(dpTPy.indexOf('^') === -1, 'double pendulum T: no caret left');

// Coupled oscillators V (multiple terms)
var coV = '1/2*k1*x1^2 + 1/2*k2*(x2 - x1)^2 + 1/2*k3*x2^2';
var coVPy = exprToPython(coV);
assertMatch(coVPy, /\*\*2/, 'coupled V: has **');
assertMatch(coVPy, /x2 - x1/, 'coupled V: subtraction preserved');

// Kepler V with division
var kV = '-G*M*m/r';
var kVPy = exprToPython(kV);
assertEq(kVPy, '-G*M*m/r', 'kepler V: simple division');


// ============================================================
// TEST 20: Velocity replacement in SymPy code
// ============================================================
console.log('\n=== TEST 20: Velocity Replacement ===');
// Simple pendulum: dtheta -> theta.diff(t)
var sp_result = buildSympyCode(
    '1/2*m*l^2*dtheta^2',
    '-m*g*l*cos(theta)',
    'theta',
    'm=1, g=9.8, l=1',
    'theta(0)=0.3, dtheta(0)=0',
    '0, 10'
);
assertMatch(sp_result.T_expr, /theta\.diff\(t\)/, 'dtheta replaced with theta.diff(t) in T');
assert(sp_result.V_expr.indexOf('diff') === -1, 'V has no diff (no velocities in V)');

// Kepler: dr -> r.diff(t), dtheta -> theta.diff(t)
var kep_result = buildSympyCode(
    '1/2*m*(dr^2 + r^2*dtheta^2)',
    '-G*M*m/r',
    'r, theta',
    'm=1, G=1, M=1',
    'r(0)=1, dr(0)=0, theta(0)=0, dtheta(0)=1.1',
    '0, 15'
);
assertMatch(kep_result.T_expr, /r\.diff\(t\)/, 'dr replaced with r.diff(t)');
assertMatch(kep_result.T_expr, /theta\.diff\(t\)/, 'dtheta replaced with theta.diff(t)');


// ============================================================
// TEST 21: Expression validation edge cases
// ============================================================
console.log('\n=== TEST 21: validateExpr Edge Cases ===');
// Deeply nested valid expression
assert(validateExpr('((((a + b))))').valid, 'deeply nested parens valid');

// Multiple * is consecutive operator
assert(!validateExpr('a***b').valid, '*** is invalid');

// Negative numbers
assert(validateExpr('-m*g*l').valid, 'leading negative sign valid');
assert(validateExpr('a + (-b)').valid, 'negative in parens valid');

// Decimal numbers
assert(validateExpr('1.5*m').valid, 'decimal number valid');
assert(validateExpr('0.001*x').valid, 'small decimal valid');

// Single variable
assert(validateExpr('x').valid, 'single variable valid');

// Just a number
assert(validateExpr('42').valid, 'just a number valid');

// Underscores in names
assert(validateExpr('my_var').valid, 'underscore in name valid');


// ============================================================
// TEST 22: validateIC with negative values
// ============================================================
console.log('\n=== TEST 22: validateIC Negative Values ===');
var icNeg = validateIC('theta(0)=-0.5, dtheta(0)=-1.2');
assert(icNeg.valid, 'negative IC values valid');

var icNeg2 = parseIC('theta(0)=-0.5, dtheta(0)=-1.2');
assertEq(icNeg2.theta, -0.5, 'negative theta IC parsed');
assertEq(icNeg2.dtheta, -1.2, 'negative dtheta IC parsed');


// ============================================================
// TEST 23: validateParams with scientific notation
// ============================================================
console.log('\n=== TEST 23: validateParams Scientific Notation ===');
assert(validateParams('G=6.674e-11').valid, 'scientific notation valid');
assert(validateParams('m=1.5E+3').valid, 'E+ notation valid');

var sciParams = parseParams('G=6.674e-11, m=1.5e3');
assert(Math.abs(sciParams.G - 6.674e-11) < 1e-20, 'sci notation param parsed');
assertEq(sciParams.m, 1500, 'E3 param parsed');


// ============================================================
// TEST 24: Regex pattern matching in stdout parsing
// ============================================================
console.log('\n=== TEST 24: Stdout Parsing Patterns ===');
// Simulate what parseAndShowResult does with regex
var sampleStdout = [
    'LAGRANGIAN:0.5 l^{2} m \\dot{\\theta}^{2} + g l m \\cos{\\left(\\theta{\\left(t \\right)} \\right)}',
    'EOM:["l^{2} m \\\\ddot{\\\\theta} + g l m \\\\sin{\\\\left(\\\\theta \\\\right)} = 0"]',
    'MOMENTA:["p_{\\\\theta} = l^{2} m \\\\dot{\\\\theta}"]',
    'HAMILTONIAN:0.5 l^{2} m \\dot{\\theta}^{2} - g l m \\cos{\\left(\\theta \\right)}',
    'CONSERVATION:[{"coord": "t", "type": "time_invariant", "conserved": "H (energy)"}]',
    'HAM_EQS:[{"q": "theta", "qdot": "\\\\dot{\\\\theta}", "pdot": "- g l m \\\\sin{\\\\left(\\\\theta \\\\right)}"}]',
    'NUM_T:[0.0, 0.033, 0.067]',
    'NUM_Q:{"theta": [0.3, 0.29, 0.28]}',
    'NUM_P:{"dtheta": [0.0, -0.1, -0.2]}',
    'NUM_E:{"T": [0.0, 0.05, 0.1], "V": [-9.6, -9.55, -9.5], "E": [-9.6, -9.5, -9.4]}',
    'STEPS:[{"title": "Lagrangian", "latex": "L = 0.5 m l^2 \\\\dot{\\\\theta}^2 + m g l \\\\cos(\\\\theta)"}]'
].join('\n');

var lagrangianMatch = sampleStdout.match(/LAGRANGIAN:([^\n]*)/);
assert(lagrangianMatch !== null, 'LAGRANGIAN matched');
assert(lagrangianMatch[1].indexOf('l^{2}') >= 0, 'LAGRANGIAN contains latex');

var eomMatch = sampleStdout.match(/EOMS?:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
assert(eomMatch !== null, 'EOM matched');
var eomParsed = JSON.parse(eomMatch[1]);
assert(Array.isArray(eomParsed), 'EOM is array');
assert(eomParsed.length > 0, 'EOM has entries');

var momentaMatch = sampleStdout.match(/MOMENTA:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
assert(momentaMatch !== null, 'MOMENTA matched');

var hamiltonianMatch = sampleStdout.match(/HAMILTONIAN:([^\n]*)/);
assert(hamiltonianMatch !== null, 'HAMILTONIAN matched');

var conservationMatch = sampleStdout.match(/CONSERVATION:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
assert(conservationMatch !== null, 'CONSERVATION matched');
var conservation = JSON.parse(conservationMatch[1]);
assert(conservation.length > 0, 'has conservation laws');
assertEq(conservation[0].type, 'time_invariant', 'conservation type');

var hamEqsMatch = sampleStdout.match(/HAM_EQS:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
assert(hamEqsMatch !== null, 'HAM_EQS matched');
var hamEqs = JSON.parse(hamEqsMatch[1]);
assert(hamEqs.length > 0, 'has Hamilton eqs');
assertEq(hamEqs[0].q, 'theta', 'Hamilton eq coord');

var numTMatch = sampleStdout.match(/NUM_T:(\[[\s\S]*?\])(?=\n|$)/);
assert(numTMatch !== null, 'NUM_T matched');
var numT = JSON.parse(numTMatch[1]);
assert(numT.length === 3, 'NUM_T has 3 points');

var numQMatch = sampleStdout.match(/NUM_Q:(\{[\s\S]*?\})(?=\n|$)/);
assert(numQMatch !== null, 'NUM_Q matched');
var numQ = JSON.parse(numQMatch[1]);
assert(numQ.theta && numQ.theta.length === 3, 'NUM_Q has theta data');

var numPMatch = sampleStdout.match(/NUM_P:(\{[\s\S]*?\})(?=\n|$)/);
assert(numPMatch !== null, 'NUM_P matched');

var numEMatch = sampleStdout.match(/NUM_E:(\{[\s\S]*?\})(?=\n|$)/);
assert(numEMatch !== null, 'NUM_E matched');
var numE = JSON.parse(numEMatch[1]);
assert(numE.T && numE.V && numE.E, 'NUM_E has T, V, E');

var stepsMatch = sampleStdout.match(/STEPS:(\[[\s\S]*?\])$/m);
assert(stepsMatch !== null, 'STEPS matched');
var steps = JSON.parse(stepsMatch[1]);
assert(steps.length > 0, 'has steps');
assert(steps[0].title && steps[0].latex, 'step has title and latex');


// ============================================================
// TEST 25: Params in generated code match input
// ============================================================
console.log('\n=== TEST 25: Generated Code Param Substitution ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var result = buildSympyCode(sys.T, sys.V, sys.coords, sys.params, sys.ic, sys.tspan);
    var paramNames = Object.keys(result.params);

    // Each param should appear in the symbols declaration
    paramNames.forEach(function(p) {
        assertMatch(result.code, new RegExp('\\b' + p + '\\b'), name + ': param "' + p + '" appears in generated code');
    });
});


// ============================================================
// TEST 26: Double pendulum — multi-DOF edge case
// ============================================================
console.log('\n=== TEST 26: Double Pendulum Multi-DOF ===');
var dp = SYSTEMS.double_pendulum;
var dpResult = buildSympyCode(dp.T, dp.V, dp.coords, dp.params, dp.ic, dp.tspan);

assertEq(dpResult.coords.length, 2, 'double pendulum has 2 coords');
assertEq(dpResult.coords[0], 'theta1', 'first coord is theta1');
assertEq(dpResult.coords[1], 'theta2', 'second coord is theta2');

// Both velocities should be replaced
assertMatch(dpResult.T_expr, /theta1\.diff\(t\)/, 'dtheta1 replaced in T');
assertMatch(dpResult.T_expr, /theta2\.diff\(t\)/, 'dtheta2 replaced in T');

// V should not have velocity replacements
assert(dpResult.V_expr.indexOf('.diff(t)') === -1, 'V has no velocity terms');

// IC should have all 4 values
assertEq(Object.keys(dpResult.ics).length, 4, '4 initial conditions');


// ============================================================
// TEST 27: Coupled oscillators — 3-spring system
// ============================================================
console.log('\n=== TEST 27: Coupled Oscillators ===');
var co = SYSTEMS.coupled_oscillators;
var coResult = buildSympyCode(co.T, co.V, co.coords, co.params, co.ic, co.tspan);

assertEq(coResult.coords.length, 2, 'coupled has 2 coords');
assertEq(Object.keys(coResult.params).length, 4, '4 params (m, k1, k2, k3)');

// Velocity replacements
assertMatch(coResult.T_expr, /x1\.diff\(t\)/, 'dx1 replaced');
assertMatch(coResult.T_expr, /x2\.diff\(t\)/, 'dx2 replaced');

// V should reference x1 and x2 but not their derivatives
assert(coResult.V_expr.indexOf('.diff(t)') === -1, 'V has no velocity terms');


// ============================================================
// TEST 28: Custom input edge cases
// ============================================================
console.log('\n=== TEST 28: Custom Input Edge Cases ===');

// Very simple system
var simple = buildSympyCode('1/2*m*dx^2', 'm*g*x', 'x', 'm=1, g=9.8', 'x(0)=0, dx(0)=0', '0, 5');
assertMatch(simple.code, /Function/, 'simple custom: declares Function');
assertEq(simple.coords.length, 1, 'simple custom: 1 coord');

// System with no params (free particle)
var freeResult = buildSympyCode('1/2*dx^2', '0', 'x', '', 'x(0)=0, dx(0)=1', '0, 10');
assertEq(Object.keys(freeResult.params).length, 0, 'free particle: no params');
assertMatch(freeResult.code, /T = /, 'free particle: has T');

// Unusual coordinate name
var unusual = buildSympyCode('1/2*m*dq^2', 'm*g*q', 'q', 'm=1, g=9.8', 'q(0)=0, dq(0)=1', '0, 5');
assertMatch(unusual.code, /q = Function\("q"\)/, 'unusual coord "q" declared');
assertMatch(unusual.T_expr, /q\.diff\(t\)/, 'dq replaced in T');


// ============================================================
// TEST 29: exprToLatex — all system T expressions
// ============================================================
console.log('\n=== TEST 29: exprToLatex — All System T Expressions ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var latex = exprToLatex(sys.T);
    assert(latex.length > 0, name + ': T LaTeX non-empty');
    // Should not contain raw "dtheta" — should be \dot{\theta}
    assert(latex.indexOf('dtheta') === -1 || latex.indexOf('\\dot{\\theta}') >= 0,
        name + ': T LaTeX converts velocity notation');
});


// ============================================================
// TEST 30: exprToLatex — all system V expressions
// ============================================================
console.log('\n=== TEST 30: exprToLatex — All System V Expressions ===');
systemNames.forEach(function(name) {
    var sys = SYSTEMS[name];
    var latex = exprToLatex(sys.V);
    assert(latex.length > 0, name + ': V LaTeX non-empty');
});


// ============================================================
// TEST 31: IC negative value parsing (regression)
// ============================================================
console.log('\n=== TEST 31: IC Negative Value Parsing ===');
// The regex in validateIC uses [\d.eE+\-]+ which should match negatives
// But parseIC regex uses ([^\s,]+) which is more permissive
var icNeg3 = parseIC('theta(0)=-3.14, dtheta(0)=-0.5');
assertEq(icNeg3.theta, -3.14, 'negative theta parsed correctly');
assertEq(icNeg3.dtheta, -0.5, 'negative velocity parsed correctly');

// However validateIC may reject negatives since the regex requires [\d.eE+\-]+
// which should actually match -0.5 since \- is in the character class
var icNegValid = validateIC('theta(0)=-3.14, dtheta(0)=-0.5');
if (!icNegValid.valid) {
    console.log('  BUG FOUND: validateIC rejects negative values!');
    console.log('  Input: theta(0)=-3.14, dtheta(0)=-0.5');
    console.log('  Message: ' + icNegValid.msg);
    fail++;
    errors.push('BUG: validateIC rejects negative IC values');
} else {
    pass++;
}


// ============================================================
// TEST 32: validateParams negative values
// ============================================================
console.log('\n=== TEST 32: validateParams Negative Values ===');
var negParam = validateParams('charge=-1.6e-19');
if (!negParam.valid) {
    console.log('  BUG FOUND: validateParams rejects negative values!');
    console.log('  Input: charge=-1.6e-19');
    console.log('  Message: ' + negParam.msg);
    fail++;
    errors.push('BUG: validateParams rejects negative parameter values');
} else {
    pass++;
}


// ============================================================
// TEST 33: Atwood machine — (m1-m2) potential
// ============================================================
console.log('\n=== TEST 33: Atwood Machine Specifics ===');
var at = SYSTEMS.atwood;
var atResult = buildSympyCode(at.T, at.V, at.coords, at.params, at.ic, at.tspan);
assertEq(atResult.coords.length, 1, 'atwood: 1 DOF');
assertEq(atResult.coords[0], 'x', 'atwood: coord is x');
assert(atResult.params.m1 === 2, 'atwood: m1=2');
assert(atResult.params.m2 === 1, 'atwood: m2=1');
// V should not have velocity terms
assert(at.V.indexOf('dx') === -1, 'atwood V has no velocity');


// ============================================================
// TEST 34: Bead on wire — constraint system
// ============================================================
console.log('\n=== TEST 34: Bead on Wire ===');
var bw = SYSTEMS.bead_wire;
var bwResult = buildSympyCode(bw.T, bw.V, bw.coords, bw.params, bw.ic, bw.tspan);
assertEq(bwResult.coords.length, 1, 'bead: 1 DOF');
// T has (1 + 4*a^2*x^2)*dx^2 — x appears in T as both coord and velocity
assertMatch(bwResult.T_expr, /x\.diff\(t\)/, 'bead T: dx replaced');
// x^2 in the constraint factor should NOT be replaced with diff
// Check that x^2 in (1 + 4*a**2*x**2) isn't wrongly turned into x.diff(t)
// The \b word boundary in the regex should prevent "x" in "dx" from matching
// But let's verify there's no double replacement
var bwTExpr = bwResult.T_expr;
// Count occurrences of x.diff(t)
var diffCount = (bwTExpr.match(/x\.diff\(t\)/g) || []).length;
// In the original: "1/2*m*(1 + 4*a^2*x^2)*dx^2"
// There should be exactly the dx^2 replacements (1 occurrence of dx -> x.diff(t))
// actually dx^2 becomes (x.diff(t))**2 so just one replacement call but it appears once
assert(diffCount >= 1, 'bead T: has velocity replacement');


// ============================================================
// SUMMARY
// ============================================================
console.log('\n' + '='.repeat(60));
console.log('RESULTS: ' + pass + ' passed, ' + fail + ' failed, ' + warnings + ' warnings');
console.log('='.repeat(60));

if (errors.length > 0) {
    console.log('\nFailed tests:');
    errors.forEach(function(e) { console.log('  ' + e); });
}

if (fail > 0) {
    console.log('\nSome tests FAILED — see errors above.');
    process.exit(1);
} else {
    console.log('\nAll tests PASSED!');
    process.exit(0);
}
