/**
 * Quadratic Solver - Export & Python Compiler
 * LaTeX copy, share URLs (backward-compatible), Python compiler templates
 */
(function() {
'use strict';

var R = window.QuadraticSolverRender;

// ==================== LaTeX ====================

function buildFullLatex(a, b, c, roots, method) {
    var f = R.fmt;
    var latex = '';
    latex += '\\text{Equation: } ' + f(a) + 'x^2';
    if (b !== 0) latex += (b > 0 ? ' + ' : ' - ') + f(Math.abs(b)) + 'x';
    if (c !== 0) latex += (c > 0 ? ' + ' : ' - ') + f(Math.abs(c));
    latex += ' = 0\n\n';

    var disc = b * b - 4 * a * c;
    latex += '\\Delta = ' + f(disc) + '\n\n';

    if (roots.type === 'real') {
        if (disc > 0) {
            latex += 'x_1 = ' + f(roots.x1) + ', \\quad x_2 = ' + f(roots.x2);
        } else {
            latex += 'x = ' + f(roots.x1) + ' \\text{ (double root)}';
        }
    } else {
        latex += 'x = ' + f(roots.real) + ' \\pm ' + f(roots.imag) + 'i';
    }

    if (method) latex += '\n\n\\text{Method: ' + method + '}';
    return latex;
}

function copyLatex(a, b, c, roots, method) {
    var latex = buildFullLatex(a, b, c, roots, method);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        t: state.formType,
        m: state.method,
        a: state.a,
        b: state.b,
        c: state.c
    };
    if (state.formType === 'vertex') {
        data.vh = state.vertexH;
        data.vk = state.vertexK;
        data.va = state.vertexA;
    } else if (state.formType === 'factored') {
        data.fa = state.factorA;
        data.fr1 = state.factorR1;
        data.fr2 = state.factorR2;
    } else if (state.formType === 'inequality') {
        data.op = state.operator;
    }
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);

    // New format: ?d=base64
    var d = params.get('d');
    if (d) {
        try {
            return JSON.parse(atob(d));
        } catch (e) {
            return null;
        }
    }

    // Old format: ?type=standard&a=1&b=5&c=6
    var type = params.get('type');
    if (!type) return null;

    var result = { t: type };
    if (type === 'standard' || type === 'inequality') {
        result.a = parseFloat(params.get('a')) || 0;
        result.b = parseFloat(params.get('b')) || 0;
        result.c = parseFloat(params.get('c')) || 0;
        if (type === 'inequality') {
            result.op = params.get('op') || '>';
        }
    } else if (type === 'vertex') {
        result.t = 'vertex';
        result.va = parseFloat(params.get('a')) || 1;
        result.vh = parseFloat(params.get('h')) || 0;
        result.vk = parseFloat(params.get('k')) || 0;
    } else if (type === 'factored') {
        result.t = 'factored';
        result.fa = parseFloat(params.get('a')) || 1;
        result.fr1 = parseFloat(params.get('r1')) || 0;
        result.fr2 = parseFloat(params.get('r2')) || 0;
    }

    return result;
}

function copyShareUrl(state) {
    var url = buildShareUrl(state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

// ==================== Python Compiler Templates ====================

function buildSympySolveCode(a, b, c) {
    return 'from sympy import symbols, solve, sqrt, Rational, pprint\n\n' +
        'x = symbols("x")\n\n' +
        '# Define the quadratic equation\n' +
        'a, b, c = ' + a + ', ' + b + ', ' + c + '\n' +
        'equation = a*x**2 + b*x + c\n\n' +
        '# Solve\n' +
        'roots = solve(equation, x)\n' +
        'print("Equation:", equation, "= 0")\n' +
        'print("\\nRoots:")\n' +
        'for i, root in enumerate(roots):\n' +
        '    print(f"  x{i+1} = {root} \\u2248 {complex(root):.6f}")\n\n' +
        '# Discriminant\n' +
        'disc = b**2 - 4*a*c\n' +
        'print(f"\\nDiscriminant: {disc}")\n' +
        'if disc > 0:\n' +
        '    print("Two distinct real roots")\n' +
        'elif disc == 0:\n' +
        '    print("One repeated root")\n' +
        'else:\n' +
        '    print("Complex conjugate roots")\n\n' +
        '# Vertex\n' +
        'h = -b / (2*a)\n' +
        'k = c - b**2 / (4*a)\n' +
        'print(f"\\nVertex: ({h}, {k})")\n' +
        'print(f"Axis of symmetry: x = {h}")\n';
}

function buildNumpyPlotCode(a, b, c) {
    return 'import numpy as np\n\n' +
        '# Coefficients\n' +
        'a, b, c = ' + a + ', ' + b + ', ' + c + '\n\n' +
        '# Find roots\n' +
        'disc = b**2 - 4*a*c\n' +
        'if disc >= 0:\n' +
        '    x1 = (-b + np.sqrt(disc)) / (2*a)\n' +
        '    x2 = (-b - np.sqrt(disc)) / (2*a)\n' +
        '    print(f"Root 1: x = {x1:.6f}")\n' +
        '    print(f"Root 2: x = {x2:.6f}")\n' +
        'else:\n' +
        '    real = -b / (2*a)\n' +
        '    imag = np.sqrt(-disc) / (2*a)\n' +
        '    print(f"Root 1: x = {real:.4f} + {imag:.4f}i")\n' +
        '    print(f"Root 2: x = {real:.4f} - {imag:.4f}i")\n\n' +
        '# Vertex\n' +
        'h = -b / (2*a)\n' +
        'k = c - b**2 / (4*a)\n' +
        'print(f"\\nVertex: ({h:.4f}, {k:.4f})")\n' +
        'print(f"Discriminant: {disc}")\n\n' +
        '# Generate points for plotting\n' +
        'x = np.linspace(h - 10, h + 10, 200)\n' +
        'y = a * x**2 + b * x + c\n' +
        'print(f"\\nParabola opens {\"upward\" if a > 0 else \"downward\"}")\n' +
        'print(f"Y-intercept: (0, {c})")\n';
}

function buildSympyStepsCode(a, b, c) {
    return 'from sympy import symbols, sqrt, Rational, factor, simplify, pprint\n\n' +
        'x = symbols("x")\n' +
        'a, b, c = ' + a + ', ' + b + ', ' + c + '\n' +
        'expr = a*x**2 + b*x + c\n\n' +
        'print("=== Step-by-Step Solution ===")\n' +
        'print(f"\\nEquation: {expr} = 0")\n\n' +
        '# Step 1: Discriminant\n' +
        'disc = b**2 - 4*a*c\n' +
        'print(f"\\nStep 1: Discriminant")\n' +
        'print(f"  delta = b^2 - 4ac = {b}^2 - 4({a})({c}) = {disc}")\n\n' +
        '# Step 2: Quadratic formula\n' +
        'print("Step 2: Quadratic Formula")\n' +
        'print(f"  x = (-b +/- sqrt(delta)) / 2a")\n' +
        'print(f"  x = ({-b} +/- sqrt({disc})) / {2*a}")\n\n' +
        '# Step 3: Calculate\n' +
        'if disc >= 0:\n' +
        '    r1 = (-b + sqrt(disc)) / (2*a)\n' +
        '    r2 = (-b - sqrt(disc)) / (2*a)\n' +
        '    print(f"\\nStep 3: Calculate")\n' +
        '    print(f"  x1 = {simplify(r1)}")\n' +
        '    print(f"  x2 = {simplify(r2)}")\n' +
        'else:\n' +
        '    real_part = Rational(-b, 2*a)\n' +
        '    imag_part = sqrt(-disc) / (2*a)\n' +
        '    print(f"\\nStep 3: Complex roots")\n' +
        '    print(f"  x = {real_part} +/- {simplify(imag_part)}i")\n\n' +
        '# Step 4: Factored form\n' +
        'print(f"\\nStep 4: Factored form")\n' +
        'factored = factor(expr)\n' +
        'print(f"  {factored}")\n\n' +
        '# Step 5: Vertex form\n' +
        'h = Rational(-b, 2*a)\n' +
        'k = c - Rational(b**2, 4*a)\n' +
        'print(f"\\nStep 5: Vertex form")\n' +
        'print(f"  y = {a}(x - {h})^2 + {k}")\n' +
        'print(f"  Vertex: ({h}, {k})")\n';
}

function getCompilerUrl(template, a, b, c, contextPath) {
    var code;
    switch (template) {
        case 'numpy-plot': code = buildNumpyPlotCode(a, b, c); break;
        case 'sympy-steps': code = buildSympyStepsCode(a, b, c); break;
        default: code = buildSympySolveCode(a, b, c);
    }
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.QuadraticSolverExport = {
    buildFullLatex: buildFullLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getCompilerUrl: getCompilerUrl
};

})();
