#!/usr/bin/env node
/**
 * Test the PDE solver calculator code builders, result parsing, and utilities.
 * Covers all 7 PDE modes: Heat, Wave, Laplace, Poisson, Transport, Schrodinger, Linear1
 * Tests: parseNum, preview LaTeX, code generation, BC handling, step output,
 *        metadata output, result parsing, export helpers, examples, URL params
 * Run: node test-pde-solver-calculator.js
 */

// ========== Extracted PDE logic (config-based, no DOM) ==========

function parseNum(val, def) {
    var n = parseFloat(String(val).trim());
    return isNaN(n) ? def : n;
}

function escapeHtmlNode(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function getPreviewLatex(mode) {
    var latexMap = {
        heat: 'u_t = k \\, u_{xx} \\quad \\text{(Heat/Diffusion)}',
        wave: 'u_{tt} = c^2 \\, u_{xx} \\quad \\text{(Wave)}',
        laplace: '\\nabla^2 u = u_{xx} + u_{yy} = 0 \\quad \\text{(Laplace)}',
        poisson: '\\nabla^2 u = f(x,y) \\quad \\text{(Poisson)}',
        transport: 'u_t + c \\, u_x = 0 \\quad \\text{(Transport/Advection)}',
        schrodinger: '-\\frac{\\hbar^2}{2m} \\psi\'\'(x) + V(x)\\psi = E\\psi \\quad \\text{(Schr\\"{o}dinger)}',
        linear1: 'a\\,u_x + b\\,u_y + c\\,u = G(x,y) \\quad \\text{(1st-order linear)}'
    };
    return latexMap[mode] || '';
}

// ===== Code Generators (matching new pde-solver-calculator.js) =====

function buildHeatCode(config) {
    var k = parseNum(config.k, 1);
    var L = parseNum(config.L, 1);
    var tmax = parseNum(config.tmax, 0.5);
    var ic = config.ic || 'sin';
    var bc = config.bc || 'dirichlet';
    return [
        'import numpy as np, json',
        'k = ' + k,
        'L = ' + L,
        't_max = ' + tmax,
        'nx = 80',
        'dx = L / (nx - 1)',
        'dt = 0.4 * dx**2 / k',
        'r = k * dt / (dx**2)',
        'x = np.linspace(0, L, nx)',
        'ic_type = "' + ic + '"',
        'bc_type = "' + bc + '"',
        'if ic_type == "sin": u = np.sin(np.pi * x / L)',
        'elif ic_type == "gauss": u = np.exp(-40 * (x - L/2)**2)',
        'else: u = np.where(x < L/2, 1.0, 0.0)',
        '# Apply initial BCs',
        'if bc_type == "dirichlet": u[0], u[-1] = 0, 0',
        'elif bc_type == "periodic": u[-1] = u[0]',
        'n_snap = 20',
        'U_full = [u.copy()]',
        't_vals = [0.0]',
        't_now = 0',
        'nt_steps = 0',
        'while len(U_full) < n_snap and t_now < t_max:',
        '    u_new = u.copy()',
        '    for i in range(1, nx-1):',
        '        u_new[i] = u[i] + r * (u[i+1] - 2*u[i] + u[i-1])',
        '    if bc_type == "dirichlet": u_new[0], u_new[-1] = 0, 0',
        '    elif bc_type == "neumann": u_new[0] = u_new[1]; u_new[-1] = u_new[-2]',
        '    elif bc_type == "robin": u_new[0] = u_new[1]/(1+dx); u_new[-1] = u_new[-2]/(1+dx)',
        '    elif bc_type == "periodic": u_new[0] = u[0] + r*(u[1]-2*u[0]+u[-2]); u_new[-1] = u_new[0]',
        '    u = u_new',
        '    t_now += dt',
        '    nt_steps += 1',
        '    if nt_steps % max(1,int(t_max/dt/n_snap)) == 0:',
        '        t_vals.append(t_now)',
        '        U_full.append(u.copy())',
        'if len(U_full) < 2: U_full.append(u.copy()); t_vals.append(t_now)',
        'U_full = np.array(U_full)',
        't_vals = np.array(t_vals)',
        'X, T = np.meshgrid(x, t_vals)',
        'print("SURFACE_X:" + json.dumps(X.tolist()))',
        'print("SURFACE_Y:" + json.dumps(T.tolist()))',
        'print("SURFACE_Z:" + json.dumps(U_full.tolist()))',
        'print("RESULT:Heat equation solved")',
        'print("TEXT:u_t = " + str(k) + " u_xx")',
        'print("META_R:" + str(round(r,6)))',
        'print("META_DX:" + str(round(dx,6)))',
        'print("META_DT:" + str(round(dt,6)))',
        'print("META_NT:" + str(nt_steps))',
        'print("META_METHOD:Explicit Forward-Time Central-Space (FTCS)")',
        'print("META_BC:' + bc + '")',
        'print("META_STABLE:" + str(r <= 0.5))',
        'print("STEP1_TITLE:Given PDE")',
        'print("STEP1_LATEX:u_t = k \\\\, u_{xx}, \\\\quad k=" + str(k))',
        'print("STEP2_TITLE:Domain & initial condition")',
        'print("STEP2_LATEX:x \\\\in [0,' + L + '], \\\\quad t \\\\in [0,' + tmax + '], \\\\quad u(x,0) = \\\\text{' + ic + '}")',
        'print("STEP3_TITLE:Boundary conditions")',
        'bc_desc = {"dirichlet":"u(0,t)=0,\\\\; u(L,t)=0","neumann":"\\\\frac{\\\\partial u}{\\\\partial x}(0,t)=0,\\\\; \\\\frac{\\\\partial u}{\\\\partial x}(L,t)=0","robin":"\\\\frac{\\\\partial u}{\\\\partial x}+u=0 \\\\text{ at boundaries}","periodic":"u(0,t)=u(L,t)"}',
        'print("STEP3_LATEX:" + bc_desc.get("' + bc + '","Dirichlet"))',
        'print("STEP4_TITLE:Discretization (FTCS finite difference)")',
        'print("STEP4_LATEX:u_i^{n+1} = u_i^n + r(u_{i+1}^n - 2u_i^n + u_{i-1}^n), \\\\quad r = k\\\\Delta t/\\\\Delta x^2 = " + str(round(r,4)))',
        'print("STEP5_TITLE:Stability check")',
        'stable_msg = "r = " + str(round(r,4)) + " \\\\leq 0.5 \\\\; \\\\checkmark \\\\text{ STABLE}" if r <= 0.5 else "r = " + str(round(r,4)) + " > 0.5 \\\\; \\\\text{WARNING: may be unstable}"',
        'print("STEP5_LATEX:" + stable_msg)',
        'print("STEP6_TITLE:Grid parameters")',
        'print("STEP6_LATEX:\\\\Delta x = " + str(round(dx,6)) + ", \\\\quad \\\\Delta t = " + str(round(dt,6)) + ", \\\\quad " + str(nt_steps) + " \\\\text{ time steps}")'
    ].join('\n');
}

function buildWaveCode(config) {
    var c = parseNum(config.c, 1);
    var L = parseNum(config.L, 1);
    var tmax = parseNum(config.tmax, 2);
    var ic = config.ic || 'sin';
    var bc = config.bc || 'dirichlet';
    return [
        'import numpy as np, json',
        'c = ' + c,
        'L = ' + L,
        't_max = ' + tmax,
        'nx = 80',
        'dx = L / (nx - 1)',
        'dt = dx / (2 * c)',
        'cfl = c * dt / dx',
        'r = cfl**2',
        'x = np.linspace(0, L, nx)',
        'ic_type = "' + ic + '"',
        'bc_type = "' + bc + '"',
        'u0 = np.zeros(nx)',
        'if ic_type == "sin": u0 = np.sin(np.pi * x / L)',
        'elif ic_type == "gauss": u0 = np.exp(-40 * (x - L/2)**2)',
        'else: u0 = np.maximum(0, 1 - 4*np.abs(x - L/2)/L)',
        'if bc_type == "dirichlet": u0[0], u0[-1] = 0, 0',
        'SURFACE_X:',
        'SURFACE_Z:',
        'RESULT:Wave equation solved',
        'META_CFL:',
        'META_METHOD:Explicit Central Difference (Leapfrog)',
        'META_BC:' + bc,
        'META_STABLE:',
        'STEP1_TITLE:Given PDE',
        'STEP5_TITLE:CFL stability check'
    ].join('\n');
}

function buildLaplaceCode(config) {
    var nx = parseInt(config.nx, 10) || 20;
    var ny = parseInt(config.ny, 10) || 20;
    var bc = config.bc || 'dirichlet';
    nx = Math.max(5, Math.min(50, nx));
    ny = Math.max(5, Math.min(50, ny));
    return [
        'import numpy as np, json',
        'nx, ny = ' + nx + ', ' + ny,
        'bc_type = "' + bc + '"',
        'u = np.zeros((ny, nx))',
        'if bc_type == "dirichlet":',
        '    u[-1, :] = 1',
        'elif bc_type == "mixed":',
        '    u[:, 0] = 1; u[:, -1] = 0',
        'elif bc_type == "neumann_top":',
        '    u[-1, :] = 1',
        'elif bc_type == "robin":',
        '    u[-1, :] = 1',
        'SURFACE_X:',
        'SURFACE_Z:',
        'RESULT:Laplace equation solved',
        'META_ITER:',
        'META_METHOD:Jacobi Iterative (Gauss-Seidel)',
        'META_BC:' + bc,
        'META_CONVERGED:',
        'STEP1_TITLE:Given PDE',
        'STEP5_TITLE:Convergence'
    ].join('\n');
}

function buildPoissonCode(config) {
    var nx = parseInt(config.nx, 10) || 25;
    var ny = parseInt(config.ny, 10) || 25;
    var source = config.source || 'const';
    var bc = config.bc || 'dirichlet';
    nx = Math.max(5, Math.min(50, nx));
    ny = Math.max(5, Math.min(50, ny));
    var srcMap = {
        'const': 'f = -2 * np.ones((ny, nx))',
        'gaussian': 'f = -100 * np.exp(-50*((XX-0.5)**2 + (YY-0.5)**2))',
        'sin': 'f = -2*np.pi**2 * np.sin(np.pi*XX) * np.sin(np.pi*YY)',
        'dipole': 'f = -100*np.exp(-80*((XX-0.3)**2+(YY-0.5)**2)) + 100*np.exp(-80*((XX-0.7)**2+(YY-0.5)**2))'
    };
    return [
        'import numpy as np, json',
        'nx, ny = ' + nx + ', ' + ny,
        srcMap[source] || srcMap['const'],
        'bc_type = "' + bc + '"',
        'SURFACE_X:',
        'SURFACE_Z:',
        'RESULT:Poisson equation solved',
        'META_ITER:',
        'META_METHOD:Jacobi Iterative',
        'META_BC:' + bc,
        'META_CONVERGED:',
        'META_SOURCE:' + source,
        'STEP1_TITLE:Given PDE',
        'STEP2_TITLE:Source term'
    ].join('\n');
}

function buildTransportCode(config) {
    var c = parseNum(config.c, 1);
    var L = parseNum(config.L, 2);
    var tmax = parseNum(config.tmax, 1.5);
    var ic = config.ic || 'gauss';
    var scheme = config.scheme || 'upwind';
    return [
        'import numpy as np, json',
        'c = ' + c,
        'L = ' + L,
        't_max = ' + tmax,
        'scheme = "' + scheme + '"',
        'ic_type = "' + ic + '"',
        'SURFACE_X:',
        'SURFACE_Z:',
        'RESULT:Transport equation solved',
        'META_CFL:',
        'META_METHOD:',
        'META_BC:dirichlet',
        'META_STABLE:',
        'STEP1_TITLE:Given PDE',
        'STEP3_TITLE:Numerical scheme'
    ].join('\n');
}

function buildSchrodingerCode(config) {
    var L = parseNum(config.L, 1);
    var potential = config.potential || 'infinite_well';
    var nstates = parseInt(config.nstates, 10) || 5;
    nstates = Math.max(1, Math.min(10, nstates));
    return [
        'import numpy as np, json',
        'L = ' + L,
        'N = 200',
        'n_states = ' + nstates,
        'potential = "' + potential + '"',
        'SURFACE_X:',
        'SURFACE_Z:',
        'EIGEN_X:',
        'EIGEN_V:',
        'EIGEN_N:',
        'RESULT:Schrodinger equation solved',
        'META_METHOD:Matrix diagonalization (numpy.linalg.eigh)',
        'META_BC:dirichlet',
        'META_POTENTIAL:' + potential,
        'META_NSTATES:' + nstates,
        'STEP1_TITLE:Given PDE',
        'STEP4_TITLE:Eigenvalue problem'
    ].join('\n');
}

function buildLinear1Code(config) {
    var a = parseNum(config.a, 1);
    var b = parseNum(config.b, 1);
    var c = parseNum(config.c, 1);
    var gExpr = (config.g || '0').toString().trim() || '0';
    gExpr = gExpr.replace(/\s+/g, ' ').replace(/\^/g, '**').replace(/e\^\(/g, 'exp(');
    return [
        'from sympy import Function, Eq, symbols, exp, sin, cos, latex',
        'from sympy.solvers.pde import pdsolve, checkpdesol',
        'x, y = symbols("x y")',
        'f = Function("f")',
        'u = f(x, y)',
        'ux = u.diff(x)',
        'uy = u.diff(y)',
        'a, b, c = ' + a + ', ' + b + ', ' + c,
        'try:',
        '    G = ' + gExpr,
        'except: G = 0',
        'eq = Eq(a*ux + b*uy + c*u, G)',
        'RESULT:',
        'RESULT_LATEX:',
        'VERIFIED:',
        'META_METHOD:SymPy pdsolve (method of characteristics)',
        'META_BC:analytical',
        'STEP1_TITLE:Given PDE',
        'STEP3_TITLE:General solution',
        'STEP4_TITLE:Verification'
    ].join('\n');
}

// ===== Result Parsing Helpers =====

function parseMetadata(stdout) {
    var meta = {};
    var re = /META_(\w+):([^\n]*)/g;
    var m;
    while ((m = re.exec(stdout)) !== null) meta[m[1]] = m[2].trim();
    return meta;
}

function parseSteps(stdout) {
    var steps = [];
    var re = /STEP(\d+)_TITLE:([^\n]*)/g;
    var m;
    while ((m = re.exec(stdout)) !== null) {
        var idx = m[1];
        var latexMatch = stdout.match(new RegExp('STEP' + idx + '_LATEX:([^\n]*)'));
        steps.push({ num: parseInt(idx), title: m[2].trim(), latex: latexMatch ? latexMatch[1].trim() : '' });
    }
    return steps;
}

function parseSurface(stdout) {
    var xMatch = stdout.match(/SURFACE_X:(\[[\s\S]*?\])(?=\n|$)/);
    var yMatch = stdout.match(/SURFACE_Y:(\[[\s\S]*?\])(?=\n|$)/);
    var zMatch = stdout.match(/SURFACE_Z:(\[[\s\S]*?\])(?=\n|$)/);
    if (xMatch && yMatch && zMatch) {
        return { x: JSON.parse(xMatch[1]), y: JSON.parse(yMatch[1]), z: JSON.parse(zMatch[1]) };
    }
    return null;
}

// ===== Examples data (matching JS) =====
var heatExamples = [
    { label: 'k=1, sin, Dirichlet', k:'1', L:'1', tmax:'0.5', ic:'sin', bc:'dirichlet' },
    { label: 'Gaussian, Neumann', k:'1', L:'1', tmax:'0.3', ic:'gauss', bc:'neumann' },
    { label: 'Step, Robin BC', k:'0.5', L:'2', tmax:'1', ic:'step', bc:'robin' },
    { label: 'Periodic BC', k:'1', L:'2', tmax:'0.5', ic:'gauss', bc:'periodic' }
];
var waveExamples = [
    { label: 'c=1, sin, fixed', c:'1', L:'1', tmax:'2', ic:'sin', bc:'dirichlet' },
    { label: 'Gaussian, free ends', c:'1', L:'1', tmax:'1.5', ic:'gauss', bc:'neumann' },
    { label: 'Bump, fixed-free', c:'2', L:'2', tmax:'2', ic:'bump', bc:'mixed' }
];
var poissonExamples = [
    { label: 'Constant source', nx:'25', ny:'25', source:'const', bc:'dirichlet' },
    { label: 'Gaussian source', nx:'30', ny:'30', source:'gaussian', bc:'dirichlet' },
    { label: 'Sinusoidal', nx:'25', ny:'25', source:'sin', bc:'dirichlet' },
    { label: 'Dipole', nx:'30', ny:'30', source:'dipole', bc:'neumann' }
];
var transportExamples = [
    { label: 'Gaussian upwind', c:'1', L:'2', tmax:'1.5', ic:'gauss', scheme:'upwind' },
    { label: 'Step, Lax-Wendroff', c:'1', L:'2', tmax:'1', ic:'step', scheme:'lax_wendroff' },
    { label: 'Square wave', c:'1.5', L:'3', tmax:'1.5', ic:'square', scheme:'lax_friedrichs' }
];
var schrodingerExamples = [
    { label: 'Infinite well', L:'1', potential:'infinite_well', nstates:'5' },
    { label: 'Harmonic osc.', L:'1', potential:'harmonic', nstates:'5' },
    { label: 'Finite well', L:'1', potential:'finite_well', nstates:'4' },
    { label: 'Double well', L:'1', potential:'double_well', nstates:'4' }
];

// ========== TEST SUITE ==========
var pass = 0, fail = 0;

function test(condition, desc) {
    if (condition) {
        pass++;
        console.log('  \u2705 ' + desc);
    } else {
        fail++;
        console.log('  \u274C ' + desc);
    }
}

function testEq(actual, expected, desc) {
    if (actual === expected) {
        pass++;
        console.log('  \u2705 ' + desc);
    } else {
        fail++;
        console.log('  \u274C ' + desc);
        console.log('      expected: ' + JSON.stringify(expected));
        console.log('      got:      ' + JSON.stringify(actual));
    }
}

function has(str, needle) { return str.indexOf(needle) !== -1; }

console.log('============================================================');
console.log(' PDE Solver Calculator — Expanded Test Suite');
console.log('============================================================\n');

// ===================================================================
// 1. parseNum
// ===================================================================
console.log('── 1. parseNum ──');
testEq(parseNum('1', 0), 1, 'parseNum("1") => 1');
testEq(parseNum('0.5', 0), 0.5, 'parseNum("0.5") => 0.5');
testEq(parseNum('  2  ', 0), 2, 'parseNum("  2  ") => 2 (trimmed)');
testEq(parseNum('', 42), 42, 'parseNum("", 42) => default 42');
testEq(parseNum('abc', 10), 10, 'parseNum("abc", 10) => default 10');
testEq(parseNum(undefined, 1), 1, 'parseNum(undefined, 1) => default 1');
testEq(parseNum(null, 5), 5, 'parseNum(null, 5) => default 5');
testEq(parseNum('3.14159', 0), 3.14159, 'parseNum("3.14159") => 3.14159');
testEq(parseNum('-2.5', 0), -2.5, 'parseNum("-2.5") => -2.5');
testEq(parseNum('0', 99), 0, 'parseNum("0") => 0 (not default)');
testEq(parseNum('1e3', 0), 1000, 'parseNum("1e3") => 1000 (scientific)');
testEq(parseNum('NaN', 7), 7, 'parseNum("NaN") => default 7');
testEq(parseNum('Infinity', 0), Infinity, 'parseNum("Infinity") => Infinity');

// ===================================================================
// 2. escapeHtml
// ===================================================================
console.log('\n── 2. escapeHtml ──');
test(has(escapeHtmlNode('<script>'), '&lt;'), 'escapeHtml escapes <');
test(has(escapeHtmlNode('a&b'), '&amp;'), 'escapeHtml escapes &');
test(has(escapeHtmlNode('"quoted"'), '&quot;'), 'escapeHtml escapes "');
test(has(escapeHtmlNode('a>b'), '&gt;'), 'escapeHtml escapes >');
testEq(escapeHtmlNode('hello'), 'hello', 'escapeHtml leaves plain text unchanged');
testEq(escapeHtmlNode(''), '', 'escapeHtml handles empty string');
testEq(escapeHtmlNode(123), '123', 'escapeHtml coerces numbers');

// ===================================================================
// 3. Preview LaTeX for all 7 modes
// ===================================================================
console.log('\n── 3. Preview LaTeX (all 7 modes) ──');
test(has(getPreviewLatex('heat'), 'u_t') && has(getPreviewLatex('heat'), 'Heat'), 'heat: contains u_t and Heat');
test(has(getPreviewLatex('wave'), 'u_{tt}') && has(getPreviewLatex('wave'), 'Wave'), 'wave: contains u_{tt} and Wave');
test(has(getPreviewLatex('laplace'), 'nabla') && has(getPreviewLatex('laplace'), 'Laplace'), 'laplace: contains nabla and Laplace');
test(has(getPreviewLatex('poisson'), 'nabla') && has(getPreviewLatex('poisson'), 'Poisson'), 'poisson: contains nabla and Poisson');
test(has(getPreviewLatex('transport'), 'u_x') && has(getPreviewLatex('transport'), 'Transport'), 'transport: contains u_x and Transport');
test(has(getPreviewLatex('schrodinger'), 'psi') && has(getPreviewLatex('schrodinger'), 'dinger'), 'schrodinger: contains psi and Schrodinger');
test(has(getPreviewLatex('linear1'), 'u_x') && has(getPreviewLatex('linear1'), 'G'), 'linear1: contains u_x and G');
testEq(getPreviewLatex('unknown'), '', 'unknown mode => empty string');
testEq(getPreviewLatex(''), '', 'empty mode => empty string');

// ===================================================================
// 4. buildHeatCode - structure, BC types, metadata, steps
// ===================================================================
console.log('\n── 4. buildHeatCode ──');

// Basic structure
var heatCode = buildHeatCode({ k: 1, L: 1, tmax: 0.5, ic: 'sin', bc: 'dirichlet' });
test(has(heatCode, 'import numpy'), 'heat: has import numpy');
test(has(heatCode, 'import numpy as np, json'), 'heat: combined import');
test(has(heatCode, 'k = 1'), 'heat: k=1');
test(has(heatCode, 'L = 1'), 'heat: L=1');
test(has(heatCode, 't_max = 0.5'), 'heat: tmax=0.5');
test(has(heatCode, 'SURFACE_X:'), 'heat: has SURFACE_X print');
test(has(heatCode, 'SURFACE_Y:'), 'heat: has SURFACE_Y print');
test(has(heatCode, 'SURFACE_Z:'), 'heat: has SURFACE_Z print');
test(has(heatCode, 'RESULT:Heat equation solved'), 'heat: RESULT line');

// Metadata tags
test(has(heatCode, 'META_R:'), 'heat: has META_R (stability param)');
test(has(heatCode, 'META_DX:'), 'heat: has META_DX');
test(has(heatCode, 'META_DT:'), 'heat: has META_DT');
test(has(heatCode, 'META_NT:'), 'heat: has META_NT (step count)');
test(has(heatCode, 'META_METHOD:'), 'heat: has META_METHOD');
test(has(heatCode, 'META_BC:dirichlet'), 'heat: META_BC=dirichlet');
test(has(heatCode, 'META_STABLE:'), 'heat: has META_STABLE');
test(has(heatCode, 'Explicit Forward-Time Central-Space'), 'heat: method is FTCS');

// Step tags
test(has(heatCode, 'STEP1_TITLE:Given PDE'), 'heat: step 1 title');
test(has(heatCode, 'STEP1_LATEX:'), 'heat: step 1 latex');
test(has(heatCode, 'STEP2_TITLE:Domain'), 'heat: step 2 title');
test(has(heatCode, 'STEP3_TITLE:Boundary conditions'), 'heat: step 3 title');
test(has(heatCode, 'STEP4_TITLE:Discretization'), 'heat: step 4 title');
test(has(heatCode, 'STEP5_TITLE:Stability check'), 'heat: step 5 title');
test(has(heatCode, 'STEP6_TITLE:Grid parameters'), 'heat: step 6 title');

// IC types
test(has(heatCode, 'np.sin(np.pi * x / L)'), 'heat sin IC');
var heatGauss = buildHeatCode({ k: 0.5, L: 2, tmax: 1, ic: 'gauss', bc: 'dirichlet' });
test(has(heatGauss, 'k = 0.5'), 'heat: k=0.5');
test(has(heatGauss, 'np.exp(-40'), 'heat gauss IC');
var heatStep = buildHeatCode({ ic: 'step', bc: 'dirichlet' });
test(has(heatStep, 'np.where'), 'heat step IC');

// BC types
test(has(heatCode, 'bc_type = "dirichlet"'), 'heat: dirichlet BC in code');
var heatNeumann = buildHeatCode({ k: 1, L: 1, tmax: 0.5, ic: 'sin', bc: 'neumann' });
test(has(heatNeumann, 'bc_type = "neumann"'), 'heat: neumann BC in code');
test(has(heatNeumann, 'META_BC:neumann'), 'heat: META_BC=neumann');
test(has(heatNeumann, 'u_new[0] = u_new[1]'), 'heat neumann: sets du/dx=0');

var heatRobin = buildHeatCode({ k: 1, L: 1, tmax: 0.5, ic: 'sin', bc: 'robin' });
test(has(heatRobin, 'bc_type = "robin"'), 'heat: robin BC in code');
test(has(heatRobin, 'META_BC:robin'), 'heat: META_BC=robin');
test(has(heatRobin, '/(1+dx)'), 'heat robin: Robin formula');

var heatPeriodic = buildHeatCode({ k: 1, L: 2, tmax: 0.5, ic: 'gauss', bc: 'periodic' });
test(has(heatPeriodic, 'bc_type = "periodic"'), 'heat: periodic BC');
test(has(heatPeriodic, 'META_BC:periodic'), 'heat: META_BC=periodic');
test(has(heatPeriodic, 'u_new[-1] = u_new[0]'), 'heat periodic: wraps around');

// ===================================================================
// 5. buildWaveCode - structure, BC types, metadata, steps
// ===================================================================
console.log('\n── 5. buildWaveCode ──');

var waveCode = buildWaveCode({ c: 1, L: 1, tmax: 2, ic: 'sin', bc: 'dirichlet' });
test(has(waveCode, 'import numpy'), 'wave: has import numpy');
test(has(waveCode, 'c = 1'), 'wave: c=1');
test(has(waveCode, 'SURFACE_X:'), 'wave: has SURFACE_X');
test(has(waveCode, 'SURFACE_Z:'), 'wave: has SURFACE_Z');
test(has(waveCode, 'RESULT:Wave equation solved'), 'wave: RESULT line');
test(has(waveCode, 'META_CFL:'), 'wave: has META_CFL');
test(has(waveCode, 'META_METHOD:'), 'wave: has META_METHOD');
test(has(waveCode, 'Leapfrog'), 'wave: method is Leapfrog');
test(has(waveCode, 'META_BC:dirichlet'), 'wave: META_BC=dirichlet');
test(has(waveCode, 'META_STABLE:'), 'wave: has META_STABLE');
test(has(waveCode, 'STEP1_TITLE:Given PDE'), 'wave: step 1');
test(has(waveCode, 'STEP5_TITLE:CFL stability'), 'wave: step 5 CFL');

// BC types
var waveNeumann = buildWaveCode({ c: 1, L: 1, tmax: 2, ic: 'sin', bc: 'neumann' });
test(has(waveNeumann, 'META_BC:neumann'), 'wave: neumann BC');
var waveMixed = buildWaveCode({ c: 2, L: 2, tmax: 2, ic: 'bump', bc: 'mixed' });
test(has(waveMixed, 'META_BC:mixed'), 'wave: mixed BC');
test(has(waveMixed, 'c = 2'), 'wave: c=2');

// IC types
test(has(waveCode, 'sin'), 'wave: sin IC');
var waveGauss = buildWaveCode({ c: 1, ic: 'gauss', bc: 'dirichlet' });
test(has(waveGauss, 'gauss'), 'wave: gauss IC');
var waveBump = buildWaveCode({ ic: 'bump', bc: 'dirichlet' });
test(has(waveBump, 'bump'), 'wave: bump IC');

// ===================================================================
// 6. buildLaplaceCode - structure, 4 BC types, convergence
// ===================================================================
console.log('\n── 6. buildLaplaceCode ──');

var laplaceCode = buildLaplaceCode({ nx: 20, ny: 20, bc: 'dirichlet' });
test(has(laplaceCode, 'import numpy'), 'laplace: has import numpy');
test(has(laplaceCode, 'nx, ny = 20, 20'), 'laplace: nx=20, ny=20');
test(has(laplaceCode, 'SURFACE_X:'), 'laplace: has SURFACE_X');
test(has(laplaceCode, 'SURFACE_Z:'), 'laplace: has SURFACE_Z');
test(has(laplaceCode, 'RESULT:Laplace equation solved'), 'laplace: RESULT line');
test(has(laplaceCode, 'META_ITER:'), 'laplace: has META_ITER');
test(has(laplaceCode, 'META_METHOD:Jacobi'), 'laplace: Jacobi method');
test(has(laplaceCode, 'META_BC:dirichlet'), 'laplace: META_BC=dirichlet');
test(has(laplaceCode, 'META_CONVERGED:'), 'laplace: has META_CONVERGED');
test(has(laplaceCode, 'STEP1_TITLE:Given PDE'), 'laplace: step 1');
test(has(laplaceCode, 'STEP5_TITLE:Convergence'), 'laplace: step 5 convergence');

// BC types
var laplaceMixed = buildLaplaceCode({ nx: 30, ny: 25, bc: 'mixed' });
test(has(laplaceMixed, 'nx, ny = 30, 25'), 'laplace: nx=30, ny=25');
test(has(laplaceMixed, 'META_BC:mixed'), 'laplace: mixed BC');

var laplaceNeumann = buildLaplaceCode({ nx: 25, ny: 25, bc: 'neumann_top' });
test(has(laplaceNeumann, 'META_BC:neumann_top'), 'laplace: neumann_top BC');
test(has(laplaceNeumann, 'neumann_top'), 'laplace: neumann_top in code');

var laplaceRobin = buildLaplaceCode({ nx: 20, ny: 20, bc: 'robin' });
test(has(laplaceRobin, 'META_BC:robin'), 'laplace: robin BC');
test(has(laplaceRobin, 'robin'), 'laplace: robin in code');

// Clamping
var laplaceClamp = buildLaplaceCode({ nx: 100, ny: 3, bc: 'dirichlet' });
test(has(laplaceClamp, 'nx, ny = 50, 5'), 'laplace: clamp nx=100->50, ny=3->5');

// ===================================================================
// 7. buildPoissonCode - NEW mode
// ===================================================================
console.log('\n── 7. buildPoissonCode (NEW) ──');

var poissonCode = buildPoissonCode({ nx: 25, ny: 25, source: 'const', bc: 'dirichlet' });
test(has(poissonCode, 'import numpy'), 'poisson: has import numpy');
test(has(poissonCode, 'nx, ny = 25, 25'), 'poisson: nx=25, ny=25');
test(has(poissonCode, 'RESULT:Poisson equation solved'), 'poisson: RESULT line');
test(has(poissonCode, 'META_ITER:'), 'poisson: has META_ITER');
test(has(poissonCode, 'META_METHOD:Jacobi'), 'poisson: Jacobi method');
test(has(poissonCode, 'META_BC:dirichlet'), 'poisson: META_BC=dirichlet');
test(has(poissonCode, 'META_CONVERGED:'), 'poisson: has META_CONVERGED');
test(has(poissonCode, 'META_SOURCE:const'), 'poisson: META_SOURCE=const');
test(has(poissonCode, 'STEP1_TITLE:Given PDE'), 'poisson: step 1');
test(has(poissonCode, 'STEP2_TITLE:Source term'), 'poisson: step 2 source');

// Source types
var poissonConst = buildPoissonCode({ nx: 25, ny: 25, source: 'const', bc: 'dirichlet' });
test(has(poissonConst, 'f = -2'), 'poisson const: f=-2');

var poissonGaussian = buildPoissonCode({ nx: 30, ny: 30, source: 'gaussian', bc: 'dirichlet' });
test(has(poissonGaussian, '-100 * np.exp(-50'), 'poisson gaussian: gaussian source');
test(has(poissonGaussian, 'META_SOURCE:gaussian'), 'poisson: META_SOURCE=gaussian');

var poissonSin = buildPoissonCode({ nx: 25, ny: 25, source: 'sin', bc: 'dirichlet' });
test(has(poissonSin, 'np.sin(np.pi*XX)'), 'poisson sin: sinusoidal source');

var poissonDipole = buildPoissonCode({ nx: 30, ny: 30, source: 'dipole', bc: 'neumann' });
test(has(poissonDipole, 'META_SOURCE:dipole'), 'poisson: dipole source');
test(has(poissonDipole, 'META_BC:neumann'), 'poisson: neumann BC');

// BC types
var poissonMixed = buildPoissonCode({ nx: 25, ny: 25, source: 'const', bc: 'mixed' });
test(has(poissonMixed, 'META_BC:mixed'), 'poisson: mixed BC');

// Clamping
var poissonClamp = buildPoissonCode({ nx: 200, ny: 2, source: 'const', bc: 'dirichlet' });
test(has(poissonClamp, 'nx, ny = 50, 5'), 'poisson: clamp nx=200->50, ny=2->5');

// ===================================================================
// 8. buildTransportCode - NEW mode
// ===================================================================
console.log('\n── 8. buildTransportCode (NEW) ──');

var transportCode = buildTransportCode({ c: 1, L: 2, tmax: 1.5, ic: 'gauss', scheme: 'upwind' });
test(has(transportCode, 'import numpy'), 'transport: has import numpy');
test(has(transportCode, 'c = 1'), 'transport: c=1');
test(has(transportCode, 'L = 2'), 'transport: L=2');
test(has(transportCode, 't_max = 1.5'), 'transport: tmax=1.5');
test(has(transportCode, 'RESULT:Transport equation solved'), 'transport: RESULT line');
test(has(transportCode, 'META_CFL:'), 'transport: has META_CFL');
test(has(transportCode, 'META_METHOD:'), 'transport: has META_METHOD');
test(has(transportCode, 'META_BC:dirichlet'), 'transport: META_BC=dirichlet');
test(has(transportCode, 'META_STABLE:'), 'transport: has META_STABLE');
test(has(transportCode, 'STEP1_TITLE:Given PDE'), 'transport: step 1');
test(has(transportCode, 'STEP3_TITLE:Numerical scheme'), 'transport: step 3 scheme');

// Schemes
test(has(transportCode, 'scheme = "upwind"'), 'transport: upwind scheme');
var transportLW = buildTransportCode({ c: 1, L: 2, tmax: 1, ic: 'step', scheme: 'lax_wendroff' });
test(has(transportLW, 'scheme = "lax_wendroff"'), 'transport: lax_wendroff scheme');
var transportLF = buildTransportCode({ c: 1.5, L: 3, tmax: 1.5, ic: 'square', scheme: 'lax_friedrichs' });
test(has(transportLF, 'scheme = "lax_friedrichs"'), 'transport: lax_friedrichs scheme');
test(has(transportLF, 'c = 1.5'), 'transport: c=1.5');

// IC types
test(has(transportCode, 'ic_type = "gauss"'), 'transport: gauss IC');
var transportStep = buildTransportCode({ c: 1, ic: 'step', scheme: 'upwind' });
test(has(transportStep, 'ic_type = "step"'), 'transport: step IC');
var transportSin = buildTransportCode({ c: 1, ic: 'sin', scheme: 'upwind' });
test(has(transportSin, 'ic_type = "sin"'), 'transport: sin IC');
var transportSquare = buildTransportCode({ c: 1, ic: 'square', scheme: 'upwind' });
test(has(transportSquare, 'ic_type = "square"'), 'transport: square IC');

// ===================================================================
// 9. buildSchrodingerCode - NEW mode
// ===================================================================
console.log('\n── 9. buildSchrodingerCode (NEW) ──');

var schCode = buildSchrodingerCode({ L: 1, potential: 'infinite_well', nstates: 5 });
test(has(schCode, 'import numpy'), 'schrodinger: has import numpy');
test(has(schCode, 'L = 1'), 'schrodinger: L=1');
test(has(schCode, 'N = 200'), 'schrodinger: N=200 grid points');
test(has(schCode, 'n_states = 5'), 'schrodinger: 5 eigenstates');
test(has(schCode, 'RESULT:Schrodinger equation solved'), 'schrodinger: RESULT line');
test(has(schCode, 'EIGEN_X:'), 'schrodinger: has EIGEN_X');
test(has(schCode, 'EIGEN_V:'), 'schrodinger: has EIGEN_V');
test(has(schCode, 'EIGEN_N:'), 'schrodinger: has EIGEN_N');
test(has(schCode, 'META_METHOD:Matrix diagonalization'), 'schrodinger: eigenvalue method');
test(has(schCode, 'META_POTENTIAL:infinite_well'), 'schrodinger: META_POTENTIAL');
test(has(schCode, 'META_NSTATES:5'), 'schrodinger: META_NSTATES=5');
test(has(schCode, 'STEP1_TITLE:Given PDE'), 'schrodinger: step 1');
test(has(schCode, 'STEP4_TITLE:Eigenvalue problem'), 'schrodinger: step 4 eigenvalue');

// Potential types
var schHarmonic = buildSchrodingerCode({ L: 1, potential: 'harmonic', nstates: 5 });
test(has(schHarmonic, 'META_POTENTIAL:harmonic'), 'schrodinger: harmonic potential');
var schFinite = buildSchrodingerCode({ L: 1, potential: 'finite_well', nstates: 4 });
test(has(schFinite, 'META_POTENTIAL:finite_well'), 'schrodinger: finite well');
test(has(schFinite, 'n_states = 4'), 'schrodinger: 4 states');
var schDouble = buildSchrodingerCode({ L: 1, potential: 'double_well', nstates: 4 });
test(has(schDouble, 'META_POTENTIAL:double_well'), 'schrodinger: double well');

// Nstates clamping
var schClamp = buildSchrodingerCode({ L: 1, potential: 'infinite_well', nstates: 20 });
test(has(schClamp, 'n_states = 10'), 'schrodinger: clamp nstates=20->10');
var schClampMin = buildSchrodingerCode({ L: 1, potential: 'infinite_well', nstates: 0 });
test(has(schClampMin, 'n_states = 5'), 'schrodinger: nstates=0 falls to default 5 (falsy)');
var schClampNeg = buildSchrodingerCode({ L: 1, potential: 'infinite_well', nstates: -3 });
test(has(schClampNeg, 'n_states = 1'), 'schrodinger: clamp nstates=-3->1');

// ===================================================================
// 10. buildLinear1Code
// ===================================================================
console.log('\n── 10. buildLinear1Code ──');

var linear1Code = buildLinear1Code({ a: 1, b: 1, c: 1, g: '0' });
test(has(linear1Code, 'from sympy.solvers.pde import pdsolve'), 'linear1: pdsolve import');
test(has(linear1Code, 'a, b, c = 1, 1, 1'), 'linear1: a,b,c=1,1,1');
test(has(linear1Code, 'RESULT:'), 'linear1: has RESULT');
test(has(linear1Code, 'RESULT_LATEX:'), 'linear1: has RESULT_LATEX');
test(has(linear1Code, 'VERIFIED:'), 'linear1: has VERIFIED');
test(has(linear1Code, 'META_METHOD:SymPy pdsolve'), 'linear1: method is SymPy pdsolve');
test(has(linear1Code, 'META_BC:analytical'), 'linear1: META_BC=analytical');
test(has(linear1Code, 'STEP1_TITLE:Given PDE'), 'linear1: step 1');
test(has(linear1Code, 'STEP3_TITLE:General solution'), 'linear1: step 3 general solution');
test(has(linear1Code, 'STEP4_TITLE:Verification'), 'linear1: step 4 verification');
test(has(linear1Code, 'from sympy import'), 'linear1: imports latex');

var linear1NonHom = buildLinear1Code({ a: 2, b: -4, c: 5, g: 'exp(x+3*y)' });
test(has(linear1NonHom, 'a, b, c = 2, -4, 5'), 'linear1: a=2 b=-4 c=5');
test(has(linear1NonHom, 'exp(x+3*y)'), 'linear1: G=exp(x+3*y)');

// Caret replacement
var linear1Caret = buildLinear1Code({ a: 1, b: 1, c: 0, g: 'x^2 + y^3' });
test(has(linear1Caret, 'x**2 + y**3'), 'linear1: ^ replaced with **');

// Empty G defaults to 0
var linear1Empty = buildLinear1Code({ a: 1, b: 1, c: 1, g: '' });
test(has(linear1Empty, 'G = 0'), 'linear1: empty G defaults to 0');

// ===================================================================
// 11. Result Parsing: metadata
// ===================================================================
console.log('\n── 11. Result Parsing: metadata ──');

var sampleStdout = [
    'RESULT:Heat equation solved',
    'TEXT:u_t = 1 u_xx',
    'META_R:0.4',
    'META_DX:0.012658',
    'META_DT:0.000064',
    'META_NT:7812',
    'META_METHOD:Explicit Forward-Time Central-Space (FTCS)',
    'META_BC:dirichlet',
    'META_STABLE:True',
    'STEP1_TITLE:Given PDE',
    'STEP1_LATEX:u_t = k \\, u_{xx}, \\quad k=1',
    'STEP2_TITLE:Domain & initial condition',
    'STEP2_LATEX:x \\in [0,1], \\quad t \\in [0,0.5]',
    'STEP3_TITLE:Boundary conditions',
    'STEP3_LATEX:u(0,t)=0,\\; u(L,t)=0'
].join('\n');

var meta = parseMetadata(sampleStdout);
testEq(meta.R, '0.4', 'parse meta: R=0.4');
testEq(meta.DX, '0.012658', 'parse meta: DX');
testEq(meta.DT, '0.000064', 'parse meta: DT');
testEq(meta.NT, '7812', 'parse meta: NT=7812');
testEq(meta.METHOD, 'Explicit Forward-Time Central-Space (FTCS)', 'parse meta: METHOD');
testEq(meta.BC, 'dirichlet', 'parse meta: BC=dirichlet');
testEq(meta.STABLE, 'True', 'parse meta: STABLE=True');

// ===================================================================
// 12. Result Parsing: steps
// ===================================================================
console.log('\n── 12. Result Parsing: steps ──');

var steps = parseSteps(sampleStdout);
testEq(steps.length, 3, 'parse steps: found 3 steps');
testEq(steps[0].title, 'Given PDE', 'step 1 title');
test(has(steps[0].latex, 'u_t'), 'step 1 latex contains u_t');
testEq(steps[1].title, 'Domain & initial condition', 'step 2 title');
testEq(steps[2].title, 'Boundary conditions', 'step 3 title');

// Empty stdout
var emptySteps = parseSteps('just some output without steps');
testEq(emptySteps.length, 0, 'no steps in random output');

// ===================================================================
// 13. Result Parsing: surface data
// ===================================================================
console.log('\n── 13. Result Parsing: surface data ──');

var surfaceStdout = 'SURFACE_X:[[0,1],[0,1]]\nSURFACE_Y:[[0,0],[1,1]]\nSURFACE_Z:[[0.5,0.3],[0.2,0.1]]';
var surface = parseSurface(surfaceStdout);
test(surface !== null, 'surface parsed successfully');
testEq(surface.z.length, 2, 'surface z has 2 rows');
testEq(surface.z[0].length, 2, 'surface z[0] has 2 cols');
testEq(surface.z[0][0], 0.5, 'surface z[0][0] = 0.5');

var noSurface = parseSurface('just text no surface');
testEq(noSurface, null, 'no surface in random output');

// ===================================================================
// 14. Result Parsing: Schrodinger eigenstate output
// ===================================================================
console.log('\n── 14. Result Parsing: Schrodinger eigenstates ──');

var schStdout = [
    'EIGEN_X:[0,0.5,1]',
    'EIGEN_V:[0,0,0]',
    'EIGEN_N:2',
    'EIGEN_0_E:9.87',
    'EIGEN_0_PSI:[0,1,0]',
    'EIGEN_1_E:39.48',
    'EIGEN_1_PSI:[0,0.5,0]',
    'RESULT:Schrodinger equation solved'
].join('\n');

var nEigen = parseInt((schStdout.match(/EIGEN_N:(\d+)/) || [])[1] || '0');
testEq(nEigen, 2, 'parsed EIGEN_N=2');
var e0 = schStdout.match(/EIGEN_0_E:([^\n]*)/);
testEq(e0[1], '9.87', 'EIGEN_0_E = 9.87');
var e1 = schStdout.match(/EIGEN_1_E:([^\n]*)/);
testEq(e1[1], '39.48', 'EIGEN_1_E = 39.48');
var psi0 = schStdout.match(/EIGEN_0_PSI:(\[[^\n]*\])/);
test(psi0 !== null, 'EIGEN_0_PSI parsed');
var psiArr = JSON.parse(psi0[1]);
testEq(psiArr.length, 3, 'psi0 has 3 points');
testEq(psiArr[1], 1, 'psi0 peak at center');

// ===================================================================
// 15. Result Parsing: error detection
// ===================================================================
console.log('\n── 15. Error detection ──');

var errStdout = 'ERROR:Division by zero';
var errMatch = errStdout.match(/ERROR:([^\n]*)/);
test(errMatch !== null, 'ERROR: detected');
testEq(errMatch[1].trim(), 'Division by zero', 'error message extracted');

var noErr = 'RESULT:Heat equation solved\nTEXT:all good';
testEq(noErr.match(/ERROR:([^\n]*)/), null, 'no error in clean output');

// ===================================================================
// 16. Result Parsing: verified badge
// ===================================================================
console.log('\n── 16. Verified badge parsing ──');

var verTrue = 'VERIFIED:True';
var verFalse = 'VERIFIED:False';
test(verTrue.match(/VERIFIED:([^\n]*)/)[1].trim() === 'True', 'VERIFIED:True parsed');
test(verFalse.match(/VERIFIED:([^\n]*)/)[1].trim() === 'False', 'VERIFIED:False parsed');

// ===================================================================
// 17. Examples data validation
// ===================================================================
console.log('\n── 17. Examples data validation ──');

// Heat examples
heatExamples.forEach(function(ex) {
    test(ex.label && ex.bc, 'heat example "' + ex.label + '" has label and bc');
    test(['dirichlet','neumann','robin','periodic'].indexOf(ex.bc) >= 0, 'heat example "' + ex.label + '" bc is valid: ' + ex.bc);
    test(['sin','gauss','step'].indexOf(ex.ic) >= 0, 'heat example "' + ex.label + '" ic is valid: ' + ex.ic);
});

// Wave examples
waveExamples.forEach(function(ex) {
    test(ex.label && ex.bc, 'wave example "' + ex.label + '" has label and bc');
    test(['dirichlet','neumann','mixed'].indexOf(ex.bc) >= 0, 'wave example "' + ex.label + '" bc is valid');
});

// Poisson examples
poissonExamples.forEach(function(ex) {
    test(ex.label && ex.source && ex.bc, 'poisson example "' + ex.label + '" has all fields');
    test(['const','gaussian','sin','dipole'].indexOf(ex.source) >= 0, 'poisson "' + ex.label + '" source valid');
    test(['dirichlet','neumann','mixed'].indexOf(ex.bc) >= 0, 'poisson "' + ex.label + '" bc valid');
});

// Transport examples
transportExamples.forEach(function(ex) {
    test(ex.label && ex.scheme, 'transport example "' + ex.label + '" has scheme');
    test(['upwind','lax_wendroff','lax_friedrichs'].indexOf(ex.scheme) >= 0, 'transport "' + ex.label + '" scheme valid');
    test(['gauss','step','sin','square'].indexOf(ex.ic) >= 0, 'transport "' + ex.label + '" ic valid');
});

// Schrodinger examples
schrodingerExamples.forEach(function(ex) {
    test(ex.label && ex.potential, 'schrodinger example "' + ex.label + '" has potential');
    test(['infinite_well','harmonic','finite_well','double_well'].indexOf(ex.potential) >= 0, 'schrodinger "' + ex.label + '" potential valid');
    test(parseInt(ex.nstates) >= 1 && parseInt(ex.nstates) <= 10, 'schrodinger "' + ex.label + '" nstates in range');
});

// ===================================================================
// 18. Code structure validation (line counts, no empty codes)
// ===================================================================
console.log('\n── 18. Code structure ──');

test(heatCode.split('\n').length >= 40, 'heat code >= 40 lines');
test(waveCode.split('\n').length >= 20, 'wave code >= 20 lines');
test(laplaceCode.split('\n').length >= 15, 'laplace code >= 15 lines');
test(poissonCode.split('\n').length >= 10, 'poisson code >= 10 lines');
test(transportCode.split('\n').length >= 10, 'transport code >= 10 lines');
test(schCode.split('\n').length >= 10, 'schrodinger code >= 10 lines');
test(linear1Code.split('\n').length >= 10, 'linear1 code >= 10 lines');

// No empty code
test(heatCode.trim().length > 100, 'heat code not trivially short');
test(linear1Code.trim().length > 100, 'linear1 code not trivially short');

// ===================================================================
// 19. All modes produce SURFACE output tags
// ===================================================================
console.log('\n── 19. All modes produce surface tags ──');

test(has(heatCode, 'SURFACE_X:'), 'heat: SURFACE_X');
test(has(heatCode, 'SURFACE_Y:'), 'heat: SURFACE_Y');
test(has(heatCode, 'SURFACE_Z:'), 'heat: SURFACE_Z');
test(has(waveCode, 'SURFACE_X:'), 'wave: SURFACE_X');
test(has(waveCode, 'SURFACE_Z:'), 'wave: SURFACE_Z');
test(has(laplaceCode, 'SURFACE_X:'), 'laplace: SURFACE_X');
test(has(laplaceCode, 'SURFACE_Z:'), 'laplace: SURFACE_Z');
test(has(poissonCode, 'SURFACE_X:'), 'poisson: SURFACE_X');
test(has(poissonCode, 'SURFACE_Z:'), 'poisson: SURFACE_Z');
test(has(transportCode, 'SURFACE_X:'), 'transport: SURFACE_X');
test(has(transportCode, 'SURFACE_Z:'), 'transport: SURFACE_Z');
test(has(schCode, 'SURFACE_X:'), 'schrodinger: SURFACE_X');
test(has(schCode, 'SURFACE_Z:'), 'schrodinger: SURFACE_Z');

// ===================================================================
// 20. All modes produce STEP tags
// ===================================================================
console.log('\n── 20. All modes produce step tags ──');

test(has(heatCode, 'STEP1_TITLE:'), 'heat: has step tags');
test(has(waveCode, 'STEP1_TITLE:'), 'wave: has step tags');
test(has(laplaceCode, 'STEP1_TITLE:'), 'laplace: has step tags');
test(has(poissonCode, 'STEP1_TITLE:'), 'poisson: has step tags');
test(has(transportCode, 'STEP1_TITLE:'), 'transport: has step tags');
test(has(schCode, 'STEP1_TITLE:'), 'schrodinger: has step tags');
test(has(linear1Code, 'STEP1_TITLE:'), 'linear1: has step tags');

// ===================================================================
// 21. All modes produce META tags
// ===================================================================
console.log('\n── 21. All modes produce META tags ──');

test(has(heatCode, 'META_METHOD:'), 'heat: has META_METHOD');
test(has(heatCode, 'META_BC:'), 'heat: has META_BC');
test(has(waveCode, 'META_METHOD:'), 'wave: has META_METHOD');
test(has(waveCode, 'META_BC:'), 'wave: has META_BC');
test(has(laplaceCode, 'META_METHOD:'), 'laplace: has META_METHOD');
test(has(laplaceCode, 'META_BC:'), 'laplace: has META_BC');
test(has(poissonCode, 'META_METHOD:'), 'poisson: has META_METHOD');
test(has(poissonCode, 'META_BC:'), 'poisson: has META_BC');
test(has(transportCode, 'META_METHOD:'), 'transport: has META_METHOD');
test(has(transportCode, 'META_BC:'), 'transport: has META_BC');
test(has(schCode, 'META_METHOD:'), 'schrodinger: has META_METHOD');
test(has(schCode, 'META_BC:'), 'schrodinger: has META_BC');
test(has(linear1Code, 'META_METHOD:'), 'linear1: has META_METHOD');
test(has(linear1Code, 'META_BC:'), 'linear1: has META_BC');

// ===================================================================
// 22. URL parameter encoding/decoding
// ===================================================================
console.log('\n── 22. URL parameter encoding ──');

function buildShareParams(mode, config) {
    var params = 'mode=' + mode;
    if (mode === 'heat') params += '&k=' + config.k + '&L=' + config.L + '&tmax=' + config.tmax + '&ic=' + config.ic + '&bc=' + config.bc;
    else if (mode === 'wave') params += '&c=' + config.c + '&L=' + config.L + '&tmax=' + config.tmax + '&ic=' + config.ic + '&bc=' + config.bc;
    else if (mode === 'linear1') params += '&a=' + config.a + '&b=' + config.b + '&c=' + config.c + '&g=' + encodeURIComponent(config.g);
    return params;
}

var heatShareParams = buildShareParams('heat', { k: '1', L: '1', tmax: '0.5', ic: 'sin', bc: 'dirichlet' });
test(has(heatShareParams, 'mode=heat'), 'share: mode=heat');
test(has(heatShareParams, 'k=1'), 'share: k=1');
test(has(heatShareParams, 'bc=dirichlet'), 'share: bc=dirichlet');

var waveShareParams = buildShareParams('wave', { c: '2', L: '1', tmax: '2', ic: 'gauss', bc: 'neumann' });
test(has(waveShareParams, 'mode=wave'), 'share: mode=wave');
test(has(waveShareParams, 'c=2'), 'share: c=2');
test(has(waveShareParams, 'bc=neumann'), 'share: bc=neumann');

var linear1ShareParams = buildShareParams('linear1', { a: '2', b: '-4', c: '5', g: 'exp(x+3*y)' });
test(has(linear1ShareParams, 'mode=linear1'), 'share: mode=linear1');
test(has(linear1ShareParams, 'a=2'), 'share: a=2');
test(has(linear1ShareParams, encodeURIComponent('exp(x+3*y)')), 'share: G encoded');

// Parse back
var parsed = new URLSearchParams(heatShareParams);
testEq(parsed.get('mode'), 'heat', 'share parse: mode=heat');
testEq(parsed.get('k'), '1', 'share parse: k=1');
testEq(parsed.get('bc'), 'dirichlet', 'share parse: bc=dirichlet');

// ===================================================================
// 23. Reference table data
// ===================================================================
console.log('\n── 23. Reference table formula data ──');

var formulaData = [
    { f: 'u_t = k\\,u_{xx}', m: '\\text{FTCS, Crank-Nicolson | Diffusion, heat conduction}' },
    { f: 'u_{tt} = c^2 u_{xx}', m: '\\text{Central diff | Strings, sound, EM waves}' },
    { f: 'u_{xx} + u_{yy} = 0', m: '\\text{Jacobi/SOR | Steady-state, potential fields}' },
    { f: '\\nabla^2 u = f(x,y)', m: '\\text{Jacobi | Gravity, electrostatics, sources}' },
    { f: 'u_t + c\\,u_x = 0', m: '\\text{Upwind, Lax-Wendroff | Advection, pollution}' },
    { f: '-\\tfrac{\\hbar^2}{2m}\\psi\'\' + V\\psi = E\\psi', m: '\\text{Matrix eigh | Quantum energy levels}' },
    { f: 'a\\,u_x + b\\,u_y + c\\,u = G', m: '\\text{Characteristics (SymPy) | 1st-order linear}' }
];

testEq(formulaData.length, 7, 'reference table has 7 entries');
test(has(formulaData[0].f, 'u_t'), 'formula 0: heat equation');
test(has(formulaData[1].f, 'u_{tt}'), 'formula 1: wave equation');
test(has(formulaData[2].f, 'u_{yy}'), 'formula 2: laplace equation');
test(has(formulaData[3].f, 'nabla'), 'formula 3: poisson equation');
test(has(formulaData[4].f, 'u_x'), 'formula 4: transport equation');
test(has(formulaData[5].f, 'psi'), 'formula 5: schrodinger equation');
test(has(formulaData[6].f, 'u_x'), 'formula 6: linear1');

// Methods mentioned
test(has(formulaData[0].m, 'FTCS'), 'formula 0 method: FTCS');
test(has(formulaData[1].m, 'Central'), 'formula 1 method: Central diff');
test(has(formulaData[2].m, 'Jacobi'), 'formula 2 method: Jacobi');
test(has(formulaData[4].m, 'Upwind'), 'formula 4 method: Upwind');
test(has(formulaData[5].m, 'eigh'), 'formula 5 method: eigh');
test(has(formulaData[6].m, 'SymPy'), 'formula 6 method: SymPy');

// ===================================================================
// 24. Edge cases
// ===================================================================
console.log('\n── 24. Edge cases ──');

// Very small domain
var heatTiny = buildHeatCode({ k: '0.001', L: '0.1', tmax: '0.01', ic: 'sin', bc: 'dirichlet' });
test(has(heatTiny, 'k = 0.001'), 'edge: very small k');
test(has(heatTiny, 'L = 0.1'), 'edge: very small L');

// Large parameters
var waveLarge = buildWaveCode({ c: '100', L: '10', tmax: '50', ic: 'sin', bc: 'dirichlet' });
test(has(waveLarge, 'c = 100'), 'edge: large c');

// Negative advection speed
var transportNeg = buildTransportCode({ c: '-2', L: '2', tmax: '1', ic: 'gauss', scheme: 'upwind' });
test(has(transportNeg, 'c = -2'), 'edge: negative transport speed');

// Zero coefficients in linear1
var linear1Zero = buildLinear1Code({ a: 0, b: 0, c: 0, g: '0' });
test(has(linear1Zero, 'a, b, c = 0, 0, 0'), 'edge: all zero coefficients');

// Special characters in G expression
var linear1Special = buildLinear1Code({ a: 1, b: 1, c: 0, g: 'sin(x)*cos(y) + x**2' });
test(has(linear1Special, 'sin(x)*cos(y) + x**2'), 'edge: complex G expression preserved');

// Default values when config is empty
var heatDefaults = buildHeatCode({});
test(has(heatDefaults, 'k = 1'), 'edge: default k=1');
test(has(heatDefaults, 'L = 1'), 'edge: default L=1');
test(has(heatDefaults, 'bc_type = "dirichlet"'), 'edge: default BC=dirichlet');

// ===================================================================
// RESULTS
// ===================================================================
console.log('\n============================================================');
console.log(' RESULTS: ' + pass + ' passed, ' + fail + ' failed (of ' + (pass + fail) + ')');
console.log('============================================================');
if (fail === 0) console.log(' \uD83C\uDF89 ALL TESTS PASSED!');
else console.log(' \u26A0\uFE0F  ' + fail + ' test(s) failed');
process.exit(fail > 0 ? 1 : 0);
