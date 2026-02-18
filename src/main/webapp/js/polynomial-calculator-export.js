/**
 * Polynomial Calculator - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

var R = window.PolyCalcRender;

// ==================== LaTeX ====================

function buildLatex(mode, state) {
    var latex = '';
    var p1tex = R.safeTeX(state.p1);
    var p2tex = state.p2 ? R.safeTeX(state.p2) : '';

    switch (mode) {
        case 'add':
            latex = '\\text{Add: } (' + p1tex + ') + (' + p2tex + ')';
            break;
        case 'subtract':
            latex = '\\text{Subtract: } (' + p1tex + ') - (' + p2tex + ')';
            break;
        case 'multiply':
            latex = '\\text{Multiply: } (' + p1tex + ') \\cdot (' + p2tex + ')';
            break;
        case 'divide':
            latex = '\\text{Divide: } \\frac{' + p1tex + '}{' + p2tex + '}';
            break;
        case 'factor':
            latex = '\\text{Factor: } ' + p1tex;
            break;
        case 'roots':
            latex = '\\text{Roots of: } ' + p1tex + ' = 0';
            break;
        case 'evaluate':
            latex = '\\text{Evaluate: } P(' + (state.evalX || 'x') + ') \\text{ where } P(x) = ' + p1tex;
            break;
    }
    return latex;
}

function copyLatex(mode, state) {
    var latex = buildLatex(mode, state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        m: state.mode,
        p1: state.p1,
        p2: state.p2 || '',
        ex: state.evalX || ''
    };
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return null;
    try {
        return JSON.parse(atob(d));
    } catch (e) {
        return null;
    }
}

function copyShareUrl(state) {
    var url = buildShareUrl(state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

// ==================== Python Templates ====================

function buildSympyBasicCode(p1, p2, mode) {
    var code = 'from sympy import symbols, Poly, expand, factor, div, solve, pprint\n\n';
    code += 'x = symbols("x")\n\n';
    code += '# Define polynomials\n';
    code += 'P = ' + sympyExpr(p1) + '\n';
    if (p2) code += 'Q = ' + sympyExpr(p2) + '\n';
    code += '\n';

    switch (mode) {
        case 'add':
            code += '# Add polynomials\n';
            code += 'result = expand(P + Q)\n';
            code += 'print("P(x) =", P)\nprint("Q(x) =", Q)\n';
            code += 'print("P + Q =", result)\n';
            break;
        case 'subtract':
            code += '# Subtract polynomials\n';
            code += 'result = expand(P - Q)\n';
            code += 'print("P(x) =", P)\nprint("Q(x) =", Q)\n';
            code += 'print("P - Q =", result)\n';
            break;
        case 'multiply':
            code += '# Multiply polynomials\n';
            code += 'result = expand(P * Q)\n';
            code += 'print("P(x) =", P)\nprint("Q(x) =", Q)\n';
            code += 'print("P * Q =", result)\n';
            break;
        case 'divide':
            code += '# Polynomial division\n';
            code += 'quotient, remainder = div(P, Q, x)\n';
            code += 'print("P(x) =", P)\nprint("Q(x) =", Q)\n';
            code += 'print("Quotient:", quotient)\n';
            code += 'print("Remainder:", remainder)\n';
            code += 'print("Verification:", expand(quotient * Q + remainder) == expand(P))\n';
            break;
        case 'factor':
            code += '# Factor polynomial\n';
            code += 'result = factor(P)\n';
            code += 'print("P(x) =", P)\n';
            code += 'print("Factored:", result)\n';
            break;
        case 'roots':
            code += '# Find roots\n';
            code += 'roots = solve(P, x)\n';
            code += 'print("P(x) =", P)\n';
            code += 'print("Roots:")\n';
            code += 'for i, r in enumerate(roots):\n';
            code += '    print(f"  x{i+1} = {r}")\n';
            break;
        case 'evaluate':
            code += '# Evaluate polynomial\n';
            code += 'print("P(x) =", P)\n';
            code += 'print("P(' + (p2 || '2') + ') =", P.subs(x, ' + (p2 || '2') + '))\n';
            break;
    }
    return code;
}

function buildNumpyRootsCode(poly) {
    return 'import numpy as np\nfrom numpy.polynomial import polynomial as P\n\n' +
        '# For NumPy, you can also use np.roots with coefficient array\n' +
        '# Example: np.roots([1, 0, -1]) finds roots of x^2 - 1\n\n' +
        'from sympy import symbols, Poly, solve\n' +
        'x = symbols("x")\n' +
        'p = ' + sympyExpr(poly) + '\n' +
        'print("Polynomial:", p)\n\n' +
        '# Find all roots\n' +
        'roots = solve(p, x)\n' +
        'print("Roots:")\n' +
        'for i, r in enumerate(roots):\n' +
        '    print(f"  x{i+1} = {r} \\u2248 {complex(r):.6f}")\n\n' +
        '# Verify roots\n' +
        'print("\\nVerification:")\n' +
        'for r in roots:\n' +
        '    print(f"  P({r}) = {p.subs(x, r)}")\n';
}

function buildLongDivisionCode(dividend, divisor) {
    return 'from sympy import symbols, div, expand, Poly, pprint\n\n' +
        'x = symbols("x")\n\n' +
        '# Polynomial long division\n' +
        'P = ' + sympyExpr(dividend) + '  # dividend\n' +
        'Q = ' + sympyExpr(divisor) + '  # divisor\n\n' +
        'quotient, remainder = div(P, Q, x)\n\n' +
        'print("=== Polynomial Long Division ===")\n' +
        'print(f"Dividend:  {P}")\n' +
        'print(f"Divisor:   {Q}")\n' +
        'print(f"Quotient:  {quotient}")\n' +
        'print(f"Remainder: {remainder}")\n\n' +
        '# Verify: P = Q * quotient + remainder\n' +
        'check = expand(Q * quotient + remainder)\n' +
        'print(f"\\nVerification: Q * quotient + remainder = {check}")\n' +
        'print(f"Matches dividend: {expand(check - P) == 0}")\n';
}

function sympyExpr(expr) {
    // Convert nerdamer-style to sympy-style
    return expr.replace(/\^/g, '**');
}

function getCompilerUrl(template, state, contextPath) {
    var code;
    switch (template) {
        case 'numpy-roots':
            code = buildNumpyRootsCode(state.p1);
            break;
        case 'long-division':
            code = buildLongDivisionCode(state.p1, state.p2 || 'x-1');
            break;
        default:
            code = buildSympyBasicCode(state.p1, state.p2, state.mode);
    }
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.PolyCalcExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getCompilerUrl: getCompilerUrl
};

})();
