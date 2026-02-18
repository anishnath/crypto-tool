/**
 * Vector Calculator - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

var R = window.VecCalcRender;

// ==================== LaTeX ====================

function buildLatex(mode, state) {
    var a = state.a, b = state.b, c = state.c;
    var dim = state.dim;

    function vecStr(v) {
        return '\\begin{pmatrix} ' + v.map(R.fmt).join(' \\\\ ') + ' \\end{pmatrix}';
    }

    switch (mode) {
        case 'add':
            return '\\vec{a} + \\vec{b} = ' + vecStr(a) + ' + ' + vecStr(b);
        case 'subtract':
            return '\\vec{a} - \\vec{b} = ' + vecStr(a) + ' - ' + vecStr(b);
        case 'scalar_multiply':
            return R.fmt(state.scalar) + ' \\cdot ' + vecStr(a);
        case 'dot_product':
            return '\\vec{a} \\cdot \\vec{b} = ' + vecStr(a) + ' \\cdot ' + vecStr(b);
        case 'cross_product':
            return '\\vec{a} \\times \\vec{b} = ' + vecStr(a) + ' \\times ' + vecStr(b);
        case 'magnitude':
            return '|\\vec{a}| \\text{ where } \\vec{a} = ' + vecStr(a);
        case 'unit_vector':
            return '\\hat{a} = \\frac{\\vec{a}}{|\\vec{a}|} \\text{ where } \\vec{a} = ' + vecStr(a);
        case 'angle':
            return '\\theta = \\arccos\\frac{\\vec{a} \\cdot \\vec{b}}{|\\vec{a}||\\vec{b}|}';
        case 'projection':
            return '\\text{proj}_{\\vec{a}} \\vec{b}';
        case 'rejection':
            return '\\text{rej}_{\\vec{a}} \\vec{b} = \\vec{b} - \\text{proj}_{\\vec{a}} \\vec{b}';
        case 'area':
            return dim === 3 ? '\\text{Area} = |\\vec{a} \\times \\vec{b}|' : '\\text{Area} = |a_x b_y - a_y b_x|';
        case 'triple_scalar':
            return '\\vec{a} \\cdot (\\vec{b} \\times \\vec{c})';
        case 'linear_independence':
            return dim === 3 ? '\\vec{a} \\times \\vec{b} \\stackrel{?}{=} \\vec{0}' : '\\det \\begin{pmatrix} a_x & b_x \\\\ a_y & b_y \\end{pmatrix} \\stackrel{?}{=} 0';
        default:
            return '';
    }
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
        d: state.dim,
        a: state.a,
        b: state.b,
        c: state.c,
        k: state.scalar
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

function buildNumpyCode(state) {
    var a = state.a, b = state.b, c = state.c;
    var mode = state.mode;

    var code = 'import numpy as np\n\n';
    code += '# Define vectors\n';
    code += 'a = np.array([' + a.join(', ') + '])\n';

    var needB = ['add', 'subtract', 'dot_product', 'cross_product', 'angle', 'projection', 'rejection', 'area', 'linear_independence'].indexOf(mode) >= 0;
    var needC = mode === 'triple_scalar';
    var needK = mode === 'scalar_multiply';

    if (needB) code += 'b = np.array([' + b.join(', ') + '])\n';
    if (needC) code += 'c = np.array([' + c.join(', ') + '])\n';
    if (needK) code += 'k = ' + state.scalar + '\n';
    code += '\n';

    switch (mode) {
        case 'add':
            code += '# Vector Addition\n';
            code += 'result = a + b\n';
            code += 'print("a + b =", result)\n';
            break;
        case 'subtract':
            code += '# Vector Subtraction\n';
            code += 'result = a - b\n';
            code += 'print("a - b =", result)\n';
            break;
        case 'scalar_multiply':
            code += '# Scalar Multiplication\n';
            code += 'result = k * a\n';
            code += 'print(f"{k} * a =", result)\n';
            break;
        case 'dot_product':
            code += '# Dot Product\n';
            code += 'result = np.dot(a, b)\n';
            code += 'print("a . b =", result)\n';
            break;
        case 'cross_product':
            code += '# Cross Product\n';
            code += 'result = np.cross(a, b)\n';
            code += 'print("a x b =", result)\n';
            code += 'print("Magnitude:", np.linalg.norm(result))\n';
            break;
        case 'magnitude':
            code += '# Magnitude\n';
            code += 'result = np.linalg.norm(a)\n';
            code += 'print("|a| =", result)\n';
            break;
        case 'unit_vector':
            code += '# Unit Vector\n';
            code += 'mag = np.linalg.norm(a)\n';
            code += 'unit = a / mag\n';
            code += 'print("Unit vector:", unit)\n';
            code += 'print("Verification |unit| =", np.linalg.norm(unit))\n';
            break;
        case 'angle':
            code += '# Angle Between Vectors\n';
            code += 'cos_theta = np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))\n';
            code += 'theta_rad = np.arccos(np.clip(cos_theta, -1, 1))\n';
            code += 'theta_deg = np.degrees(theta_rad)\n';
            code += 'print(f"Angle: {theta_rad:.6f} rad = {theta_deg:.4f} degrees")\n';
            break;
        case 'projection':
            code += '# Projection of b onto a\n';
            code += 'proj = (np.dot(a, b) / np.dot(a, a)) * a\n';
            code += 'print("proj_a(b) =", proj)\n';
            break;
        case 'rejection':
            code += '# Rejection of b from a\n';
            code += 'proj = (np.dot(a, b) / np.dot(a, a)) * a\n';
            code += 'rej = b - proj\n';
            code += 'print("rej_a(b) =", rej)\n';
            code += 'print("Verify orthogonality:", np.dot(proj, rej))\n';
            break;
        case 'area':
            code += '# Parallelogram Area\n';
            if (a.length === 3) {
                code += 'area = np.linalg.norm(np.cross(a, b))\n';
            } else {
                code += 'area = abs(a[0]*b[1] - a[1]*b[0])\n';
            }
            code += 'print("Area =", area)\n';
            break;
        case 'triple_scalar':
            code += '# Triple Scalar Product\n';
            code += 'result = np.dot(a, np.cross(b, c))\n';
            code += 'print("a . (b x c) =", result)\n';
            code += 'print("Volume =", abs(result))\n';
            break;
        case 'linear_independence':
            code += '# Linear Independence Check\n';
            if (a.length === 3) {
                code += 'cross = np.cross(a, b)\n';
                code += 'independent = np.linalg.norm(cross) > 1e-10\n';
            } else {
                code += 'det = a[0]*b[1] - a[1]*b[0]\n';
                code += 'independent = abs(det) > 1e-10\n';
            }
            code += 'print("Linearly Independent:" if independent else "Linearly Dependent:")\n';
            break;
    }

    return code;
}

function getCompilerUrl(template, state, contextPath) {
    var code = buildNumpyCode(state);
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.VecCalcExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    buildNumpyCode: buildNumpyCode,
    getCompilerUrl: getCompilerUrl
};

})();
