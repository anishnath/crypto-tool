/**
 * Trigonometry Calculator - Export & Share Module
 * LaTeX copy, share URLs, Python SymPy templates
 */
(function() {
'use strict';

var TC = window.TrigCommon;

// ==================== LaTeX ====================

function buildLatex(mode, state) {
    var latex = '';
    var expr = state.expression || '';

    switch (mode) {
        case 'evaluate':
            latex = '\\text{Evaluate: } ' + expr;
            break;
        case 'quadrant':
            latex = '\\text{Quadrant of } ' + expr;
            break;
        case 'coterminal':
            latex = '\\text{Coterminal angles of } ' + expr;
            break;
        case 'identity':
            latex = '\\text{Trig Identity: } ' + (state.identityType || 'pythagorean');
            break;
        case 'prove':
            latex = '\\text{Prove: } ' + (state.lhs || '') + ' = ' + (state.rhs || '');
            break;
        case 'solve_equation':
            latex = '\\text{Solve: } ' + expr;
            break;
        case 'solve_inequality':
            latex = '\\text{Solve: } ' + expr;
            break;
        case 'simplify':
            latex = '\\text{Simplify: } ' + expr;
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
        e: state.expression || '',
        u: state.unit || 'deg',
        it: state.identityType || '',
        l: state.lhs || '',
        r: state.rhs || ''
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

// ==================== Python SymPy Templates ====================

function buildSymPyCode(mode, state) {
    var expr = state.expression || 'sin(x)';
    var code = 'from sympy import *\n';
    code += 'x, theta = symbols("x theta")\n\n';

    switch (mode) {
        case 'evaluate':
            code += '# Evaluate trigonometric expression\n';
            code += 'expr = ' + _toSymPy(expr) + '\n';
            if (state.unit === 'deg') {
                code += 'angle = rad(' + (state.angle || '45') + ')  # Convert degrees to radians\n';
            } else {
                code += 'angle = ' + (state.angle || 'pi/4') + '\n';
            }
            code += 'result = expr.subs(x, angle)\n';
            code += 'print(f"Exact: {result}")\n';
            code += 'print(f"Decimal: {float(result):.6f}")\n';
            break;

        case 'quadrant':
            code += '# Determine quadrant and reference angle\n';
            code += 'angle = ' + (state.angle || '210') + '  # degrees\n';
            code += 'normalized = angle % 360\n';
            code += 'if normalized < 0: normalized += 360\n';
            code += 'quadrant = 1 + int(normalized // 90) if normalized % 90 != 0 else max(1, int(normalized // 90))\n';
            code += 'print(f"Quadrant: {quadrant}")\n';
            code += '# Reference angle\n';
            code += 'ref = normalized % 90\n';
            code += 'if normalized > 90 and normalized <= 180: ref = 180 - normalized\n';
            code += 'elif normalized > 180 and normalized <= 270: ref = normalized - 180\n';
            code += 'elif normalized > 270: ref = 360 - normalized\n';
            code += 'print(f"Reference angle: {ref} degrees")\n';
            break;

        case 'coterminal':
            code += '# Find coterminal angles\n';
            code += 'angle = ' + (state.angle || '750') + '  # degrees\n';
            code += 'print(f"Original: {angle} degrees")\n';
            code += 'print(f"Normalized: {angle % 360} degrees")\n';
            code += 'print("Positive coterminal angles:")\n';
            code += 'for n in range(1, 4):\n';
            code += '    print(f"  {angle % 360 + 360*n} degrees")\n';
            code += 'print("Negative coterminal angles:")\n';
            code += 'for n in range(1, 4):\n';
            code += '    print(f"  {angle % 360 - 360*n} degrees")\n';
            break;

        case 'prove':
            code += '# Verify trig identity\n';
            code += 'lhs = ' + _toSymPy(state.lhs || 'tan(x)**2 - sin(x)**2') + '\n';
            code += 'rhs = ' + _toSymPy(state.rhs || 'tan(x)**2 * sin(x)**2') + '\n';
            code += 'diff = simplify(lhs - rhs)\n';
            code += 'print(f"LHS: {lhs}")\n';
            code += 'print(f"RHS: {rhs}")\n';
            code += 'print(f"LHS - RHS simplified: {diff}")\n';
            code += 'print(f"Identity verified: {diff == 0}")\n';
            break;

        case 'solve_equation':
            code += '# Solve trigonometric equation\n';
            code += 'eq = ' + _toSymPyEq(expr) + '\n';
            code += 'solutions = solve(eq, x)\n';
            code += 'print(f"Solutions: {solutions}")\n';
            code += '# Solutions in [0, 2*pi)\n';
            code += 'for s in solutions:\n';
            code += '    val = s.evalf()\n';
            code += '    print(f"  x = {s} ≈ {val:.4f}")\n';
            break;

        case 'solve_inequality':
            code += '# Solve trigonometric inequality\n';
            code += '# Note: SymPy solvesets works with continuous domains\n';
            code += 'from sympy import solveset, S, Interval\n';
            code += 'solution = solveset(' + _toSymPy(expr) + ', x, S.Reals)\n';
            code += 'print(f"Solution set: {solution}")\n';
            break;

        case 'simplify':
            code += '# Simplify trigonometric expression\n';
            code += 'expr = ' + _toSymPy(expr) + '\n';
            code += 'simplified = trigsimp(expr)\n';
            code += 'print(f"Original: {expr}")\n';
            code += 'print(f"Simplified: {simplified}")\n';
            code += '# Try alternative simplifications\n';
            code += 'print(f"expand_trig: {expand_trig(expr)}")\n';
            break;

        default:
            code += '# Trigonometric calculation\n';
            code += 'expr = ' + _toSymPy(expr) + '\n';
            code += 'print(simplify(expr))\n';
    }

    return code;
}

function _toSymPy(expr) {
    if (!expr) return 'S(0)';
    return expr
        .replace(/\^/g, '**')
        .replace(/(\d)([a-zA-Z])/g, '$1*$2');
}

function _toSymPyEq(expr) {
    if (expr.indexOf('=') !== -1) {
        var parts = expr.split('=');
        return 'Eq(' + _toSymPy(parts[0].trim()) + ', ' + _toSymPy(parts[1].trim()) + ')';
    }
    return _toSymPy(expr);
}

function getCompilerUrl(template, state, contextPath) {
    var code = buildSymPyCode(template || state.mode, state);
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Export Namespace ====================

window.TrigExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    buildSymPyCode: buildSymPyCode,
    getCompilerUrl: getCompilerUrl
};

})();
