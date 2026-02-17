/**
 * Exponent Calculator - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

var R = window.ExponentCalcRender;

// ==================== LaTeX ====================

function buildLatex(mode, params) {
    if (mode === 'basic') {
        var result = Math.pow(params.base, params.exp);
        return R.fmt(params.base) + '^{' + R.fmt(params.exp) + '} = ' + R.fmtSci(result);
    }
    if (mode === 'product') return R.fmt(params.base) + '^{' + R.fmt(params.m) + '} \\times ' + R.fmt(params.base) + '^{' + R.fmt(params.n) + '} = ' + R.fmt(params.base) + '^{' + R.fmt(params.m + params.n) + '}';
    if (mode === 'quotient') return '\\frac{' + R.fmt(params.base) + '^{' + R.fmt(params.m) + '}}{' + R.fmt(params.base) + '^{' + R.fmt(params.n) + '}} = ' + R.fmt(params.base) + '^{' + R.fmt(params.m - params.n) + '}';
    if (mode === 'power') return '(' + R.fmt(params.base) + '^{' + R.fmt(params.m) + '})^{' + R.fmt(params.n) + '} = ' + R.fmt(params.base) + '^{' + R.fmt(params.m * params.n) + '}';
    return '';
}

function copyLatex(mode, params) {
    var latex = buildLatex(mode, params);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = { mode: state.mode };
    if (state.mode === 'basic') { data.b = state.base; data.e = state.exp; }
    else if (state.mode === 'rules') { data.rule = state.rule; data.b = state.base; data.m = state.m; data.n = state.n; data.b2 = state.base2; data.fm = state.fracM; data.fn = state.fracN; }
    else if (state.mode === 'simplify') { data.st = state.simplifyType; data.a = state.simplifyA; data.sb = state.simplifyB; }
    else if (state.mode === 'alllaws') { data.b = state.base; }
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return null;
    try { return JSON.parse(atob(d)); } catch (e) { return null; }
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

function buildBasicPowerCode(base, exp) {
    return 'import math\n\n' +
        '# Basic Power Calculation\n' +
        'base = ' + base + '\n' +
        'exponent = ' + exp + '\n\n' +
        'result = base ** exponent\n' +
        'print(f"{base}^{exponent} = {result}")\n\n' +
        '# Step-by-step for integer exponents\n' +
        'if isinstance(exponent, int) and exponent > 0 and exponent <= 10:\n' +
        '    parts = " x ".join([str(base)] * exponent)\n' +
        '    print(f"= {parts}")\n' +
        '    print(f"= {result}")\n\n' +
        '# Special cases\n' +
        'if exponent == 0:\n' +
        '    print(f"\\nZero Exponent Rule: {base}^0 = 1")\n' +
        'elif exponent < 0:\n' +
        '    print(f"\\nNegative Exponent: {base}^{exponent} = 1/{base}^{abs(exponent)} = 1/{base**abs(exponent)} = {result}")\n' +
        'elif exponent != int(exponent):\n' +
        '    print(f"\\nFractional Exponent: {base}^{exponent} = {result:.10f}")\n\n' +
        '# Scientific notation\n' +
        'print(f"\\nScientific notation: {result:.6e}")\n';
}

function buildAllLawsCode(base) {
    return 'import math\n\n' +
        'a = ' + base + '\n' +
        'print(f"=== All 8 Laws of Exponents (a = {a}) ===")\n\n' +
        '# 1. Product Rule\n' +
        'print(f"1. Product: {a}^3 x {a}^2 = {a}^5 = {a**5}")\n\n' +
        '# 2. Quotient Rule\n' +
        'print(f"2. Quotient: {a}^7 / {a}^4 = {a}^3 = {a**3}")\n\n' +
        '# 3. Power Rule\n' +
        'print(f"3. Power: ({a}^2)^3 = {a}^6 = {a**6}")\n\n' +
        '# 4. Power of Product\n' +
        'print(f"4. Product Power: ({a}*3)^2 = {a}^2 * 9 = {a**2 * 9}")\n\n' +
        '# 5. Power of Quotient\n' +
        'print(f"5. Quotient Power: ({a}/2)^2 = {a**2}/{4} = {a**2/4}")\n\n' +
        '# 6. Negative Exponent\n' +
        'print(f"6. Negative: {a}^-2 = 1/{a}^2 = {a**-2:.6f}")\n\n' +
        '# 7. Zero Exponent\n' +
        'print(f"7. Zero: {a}^0 = {a**0}")\n\n' +
        '# 8. Fractional Exponent\n' +
        'print(f"8. Fractional: {a}^(3/2) = sqrt({a}^3) = {a**1.5:.6f}")\n';
}

function buildSympyCode(base, exp) {
    return 'from sympy import symbols, simplify, Rational, sqrt, pprint\n\n' +
        'x, a, m, n = symbols("x a m n")\n\n' +
        '# Symbolic exponent operations\n' +
        'base = ' + base + '\n' +
        'exponent = Rational(' + exp + ')\n\n' +
        'expr = base ** exponent\n' +
        'print(f"Expression: {base}^{exponent}")\n' +
        'print(f"Simplified: {simplify(expr)}")\n' +
        'print(f"Value: {float(expr):.10f}")\n\n' +
        '# Demonstrate laws symbolically\n' +
        'print("\\n=== Symbolic Laws ===")\n' +
        'print(f"Product: a^m * a^n = a^(m+n)")\n' +
        'print(f"  Verify: {base}^3 * {base}^2 = {base**3 * base**2} = {base}^5 = {base**5}")\n\n' +
        'print(f"Quotient: a^m / a^n = a^(m-n)")\n' +
        'print(f"  Verify: {base}^5 / {base}^2 = {base**5 // base**2} = {base}^3 = {base**3}")\n\n' +
        'print(f"Power: (a^m)^n = a^(m*n)")\n' +
        'print(f"  Verify: ({base}^2)^3 = {(base**2)**3} = {base}^6 = {base**6}")\n';
}

function getCompilerUrl(template, base, exp, contextPath) {
    var code;
    switch (template) {
        case 'all-laws': code = buildAllLawsCode(base); break;
        case 'sympy': code = buildSympyCode(base, exp); break;
        default: code = buildBasicPowerCode(base, exp);
    }
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.ExponentCalcExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getCompilerUrl: getCompilerUrl
};

})();
