/**
 * Series Calculator - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

var R = window.SeriesCalcRender;

// ==================== LaTeX ====================

function buildFullLatex(funcLatex, derivs, numTerms, center, seriesType) {
    var latex = '\\text{Function: } f(x) = ' + funcLatex + '\n\n';
    var seriesName = seriesType === 'maclaurin' ? 'Maclaurin' : 'Taylor';
    latex += '\\text{' + seriesName + ' Series around } x = ' + R.fmt(center) + '\n\n';
    latex += 'f(x) \\approx ' + R.buildSeriesLatex(derivs, numTerms, center) + '\n\n';
    latex += '\\text{Terms: } ' + numTerms;
    return latex;
}

function copyLatex(funcLatex, derivs, numTerms, center, seriesType) {
    var latex = buildFullLatex(funcLatex, derivs, numTerms, center, seriesType);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        f: state.funcInput,
        t: state.seriesType,
        c: state.center,
        n: state.numTerms
    };
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

    // Legacy format: ?f=e^x&type=maclaurin&n=5
    var f = params.get('f');
    if (!f) return null;

    return {
        f: f,
        t: params.get('type') || 'maclaurin',
        c: parseFloat(params.get('c')) || 0,
        n: parseInt(params.get('n')) || 5
    };
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

function buildSympySeriesCode(funcStr, center, numTerms) {
    return 'from sympy import symbols, series, sin, cos, tan, exp, ln, sqrt, pi, pprint\n\n' +
        'x = symbols("x")\n\n' +
        '# Define the function\n' +
        'f = ' + convertToSympy(funcStr) + '\n\n' +
        '# Calculate Taylor/Maclaurin series\n' +
        'result = series(f, x, ' + center + ', n=' + numTerms + ')\n\n' +
        'print("Function:", f)\n' +
        'print("\\nSeries expansion around x =", ' + center + ')\n' +
        'print("Number of terms:", ' + numTerms + ')\n' +
        'print("\\nSeries:")\n' +
        'pprint(result)\n\n' +
        '# Remove O() term to get polynomial\n' +
        'poly = result.removeO()\n' +
        'print("\\nPolynomial approximation:")\n' +
        'pprint(poly)\n\n' +
        '# Evaluate at a point\n' +
        'test_x = ' + (center === 0 ? '0.5' : String(center + 0.5)) + '\n' +
        'exact = float(f.subs(x, test_x))\n' +
        'approx = float(poly.subs(x, test_x))\n' +
        'print(f"\\nAt x = {test_x}:")\n' +
        'print(f"  Exact:  {exact:.10f}")\n' +
        'print(f"  Approx: {approx:.10f}")\n' +
        'print(f"  Error:  {abs(exact - approx):.2e}")\n';
}

function buildNumpyApproxCode(funcStr, center, numTerms) {
    return 'import numpy as np\n\n' +
        '# Function definition\n' +
        'def f(x):\n' +
        '    return ' + convertToNumpy(funcStr) + '\n\n' +
        '# Numerical derivatives at center point\n' +
        'center = ' + center + '\n' +
        'h = 1e-8  # step size for numerical differentiation\n' +
        'n_terms = ' + numTerms + '\n\n' +
        'def nth_derivative(func, x0, n, h=1e-5):\n' +
        '    """Compute nth derivative numerically using central differences"""\n' +
        '    if n == 0:\n' +
        '        return func(x0)\n' +
        '    return (nth_derivative(func, x0 + h, n-1, h) - nth_derivative(func, x0 - h, n-1, h)) / (2 * h)\n\n' +
        'coefficients = []\n' +
        'for n in range(n_terms):\n' +
        '    deriv = nth_derivative(f, center, n)\n' +
        '    coeff = deriv / np.math.factorial(n)\n' +
        '    coefficients.append(coeff)\n' +
        '    print(f"n={n}: f^({n})({center}) = {deriv:.8f}, coeff = {coeff:.8f}")\n\n' +
        '# Evaluate approximation\n' +
        'def series_approx(x, coeffs, center):\n' +
        '    return sum(c * (x - center)**n for n, c in enumerate(coeffs))\n\n' +
        '# Compare at several points\n' +
        'print(f"\\nComparison (center = {center}, {n_terms} terms):")\n' +
        'print(f"{\'x\':>8} {\'Exact\':>14} {\'Approx\':>14} {\'Error\':>12}")\n' +
        'for xi in np.linspace(center - 2, center + 2, 9):\n' +
        '    try:\n' +
        '        exact = f(xi)\n' +
        '        approx = series_approx(xi, coefficients, center)\n' +
        '        print(f"{xi:8.2f} {exact:14.8f} {approx:14.8f} {abs(exact-approx):12.2e}")\n' +
        '    except:\n' +
        '        print(f"{xi:8.2f} {"undefined":>14}")\n';
}

function buildSympyConvergenceCode(funcStr, center, numTerms) {
    return 'from sympy import symbols, series, sin, cos, tan, exp, ln, sqrt, pi, oo\n' +
        'from sympy import limit, Abs, factorial, Rational\n\n' +
        'x, n = symbols("x n")\n\n' +
        '# Define the function\n' +
        'f = ' + convertToSympy(funcStr) + '\n\n' +
        '# Compute series with increasing terms\n' +
        'print("=== Convergence Analysis ===")\n' +
        'print(f"Function: {f}")\n' +
        'print(f"Center: x = {' + center + '}\\n")\n\n' +
        'prev_poly = None\n' +
        'for num_terms in [3, 5, 8, 10, ' + numTerms + ']:\n' +
        '    s = series(f, x, ' + center + ', n=num_terms)\n' +
        '    poly = s.removeO()\n' +
        '    print(f"{num_terms} terms: {poly}")\n' +
        '    prev_poly = poly\n\n' +
        '# Test convergence at a point\n' +
        'test_x = ' + (center === 0 ? '1' : String(center + 1)) + '\n' +
        'print(f"\\n=== Convergence at x = {test_x} ===")\n' +
        'exact = float(f.subs(x, test_x))\n' +
        'print(f"Exact value: {exact:.10f}\\n")\n\n' +
        'for k in range(1, ' + (numTerms + 1) + '):\n' +
        '    s = series(f, x, ' + center + ', n=k).removeO()\n' +
        '    approx = float(s.subs(x, test_x))\n' +
        '    error = abs(exact - approx)\n' +
        '    print(f"  {k:2d} terms: approx = {approx:14.8f}, error = {error:.2e}")\n';
}

function convertToSympy(funcStr) {
    return funcStr
        .replace(/\bln\(/g, 'ln(')
        .replace(/\be\^x\b/g, 'exp(x)')
        .replace(/\be\^\(/g, 'exp(')
        .replace(/\bpi\b/g, 'pi');
}

function convertToNumpy(funcStr) {
    return funcStr
        .replace(/\bln\(/g, 'np.log(')
        .replace(/\blog\(/g, 'np.log(')
        .replace(/\bsin\(/g, 'np.sin(')
        .replace(/\bcos\(/g, 'np.cos(')
        .replace(/\btan\(/g, 'np.tan(')
        .replace(/\bsqrt\(/g, 'np.sqrt(')
        .replace(/\be\^x\b/g, 'np.exp(x)')
        .replace(/\be\^\(/g, 'np.exp(')
        .replace(/\bexp\(/g, 'np.exp(')
        .replace(/\bpi\b/g, 'np.pi')
        .replace(/\^/g, '**');
}

function getCompilerUrl(template, funcStr, center, numTerms, contextPath) {
    var code;
    switch (template) {
        case 'numpy-approx': code = buildNumpyApproxCode(funcStr, center, numTerms); break;
        case 'sympy-convergence': code = buildSympyConvergenceCode(funcStr, center, numTerms); break;
        default: code = buildSympySeriesCode(funcStr, center, numTerms);
    }
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.SeriesCalcExport = {
    buildFullLatex: buildFullLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getCompilerUrl: getCompilerUrl
};

})();
