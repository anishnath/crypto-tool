/**
 * Linear Solver - Export & Python Compiler
 * Copy LaTeX, share URL, Python compiler templates (NumPy, SymPy, SciPy)
 */
(function() {
'use strict';

var M = window.LinearSolverMatrix;

// ==================== LaTeX Export ====================

function buildFullLatex(A, b, solution, method) {
    var latex = '';
    latex += '\\text{System: } ' + M.formatMatrix(A) + ' \\mathbf{x} = ' + M.formatVector(b) + '\n\n';
    latex += '\\text{Method: ' + method + '}\n\n';
    if (solution) {
        if (Array.isArray(solution[0])) {
            latex += '\\text{Solution: } X = ' + M.formatMatrix(solution);
        } else {
            latex += '\\text{Solution: } \\mathbf{x} = ' + M.formatVector(solution);
        }
    }
    return latex;
}

function copyLatex(A, b, solution, method) {
    var latex = buildFullLatex(A, b, solution, method);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        m: state.inputMode,
        A: state.A,
        b: state.b,
        method: state.method
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

// ==================== Python Compiler Templates ====================

function buildNumpyCode(A, b) {
    var aStr = A.map(function(row) { return '    [' + row.join(', ') + ']'; }).join(',\n');
    var bStr = b.join(', ');

    return 'import numpy as np\n\n' +
        '# Define the system Ax = b\n' +
        'A = np.array([\n' + aStr + '\n])\n\n' +
        'b = np.array([' + bStr + '])\n\n' +
        '# Solve using numpy\n' +
        'try:\n' +
        '    x = np.linalg.solve(A, b)\n' +
        '    print("Solution x =")\n' +
        '    for i, val in enumerate(x):\n' +
        '        print(f"  x{i+1} = {val:.6f}")\n' +
        '    \n' +
        '    # Verify: compute Ax and compare to b\n' +
        '    residual = np.linalg.norm(A @ x - b)\n' +
        '    print(f"\\nVerification: ||Ax - b|| = {residual:.2e}")\n' +
        'except np.linalg.LinAlgError as e:\n' +
        '    print(f"Error: {e}")\n' +
        '    print("Trying least squares solution...")\n' +
        '    x, residuals, rank, sv = np.linalg.lstsq(A, b, rcond=None)\n' +
        '    print("Least squares solution x =")\n' +
        '    for i, val in enumerate(x):\n' +
        '        print(f"  x{i+1} = {val:.6f}")\n';
}

function buildSympyCode(A, b) {
    var aStr = A.map(function(row) { return '    [' + row.join(', ') + ']'; }).join(',\n');
    var bStr = b.join(', ');
    var n = A[0].length;
    var vars = [];
    for (var i = 0; i < n; i++) vars.push('x' + (i + 1));

    return 'from sympy import Matrix, symbols, linsolve, pprint\n\n' +
        '# Define symbols\n' +
        vars.join(', ') + ' = symbols("' + vars.join(' ') + '")\n\n' +
        '# Define the system\n' +
        'A = Matrix([\n' + aStr + '\n])\n\n' +
        'b = Matrix([' + bStr + '])\n\n' +
        '# Method 1: linsolve\n' +
        'augmented = A.row_join(b)\n' +
        'solution = linsolve(augmented, ' + vars.join(', ') + ')\n' +
        'print("Solution (linsolve):")\n' +
        'pprint(solution)\n\n' +
        '# Method 2: A^(-1) * b (if square and invertible)\n' +
        'if A.is_square:\n' +
        '    try:\n' +
        '        x = A.inv() * b\n' +
        '        print("\\nSolution (A^-1 * b):")\n' +
        '        pprint(x)\n' +
        '    except Exception:\n' +
        '        print("\\nA is singular, no inverse exists")\n\n' +
        '# Method 3: LU decomposition\n' +
        'print("\\nLU Decomposition:")\n' +
        'L, U, perm = A.LUdecomposition()\n' +
        'print("L ="); pprint(L)\n' +
        'print("U ="); pprint(U)\n';
}

function buildScipyCode(A, b) {
    var aStr = A.map(function(row) { return '    [' + row.join(', ') + ']'; }).join(',\n');
    var bStr = b.join(', ');

    return 'import numpy as np\nfrom scipy import linalg\n\n' +
        '# Define the system\n' +
        'A = np.array([\n' + aStr + '\n])\n\n' +
        'b = np.array([' + bStr + '])\n\n' +
        '# Method 1: scipy.linalg.solve\n' +
        'try:\n' +
        '    x = linalg.solve(A, b)\n' +
        '    print("Solution (scipy.linalg.solve):")\n' +
        '    for i, val in enumerate(x):\n' +
        '        print(f"  x{i+1} = {val:.6f}")\n' +
        'except linalg.LinAlgError:\n' +
        '    print("Singular matrix, using lstsq")\n' +
        '    x, _, _, _ = linalg.lstsq(A, b)\n' +
        '    print("Least squares solution:")\n' +
        '    for i, val in enumerate(x):\n' +
        '        print(f"  x{i+1} = {val:.6f}")\n\n' +
        '# LU Decomposition\n' +
        'P, L, U = linalg.lu(A)\n' +
        'print("\\nLU Decomposition:")\n' +
        'print("L =\\n", np.round(L, 4))\n' +
        'print("U =\\n", np.round(U, 4))\n\n' +
        '# Condition number\n' +
        'cond = np.linalg.cond(A)\n' +
        'print(f"\\nCondition number: {cond:.4f}")\n' +
        'print(f"Determinant: {linalg.det(A):.6f}")\n';
}

function buildCompilerCode(template, A, b) {
    switch (template) {
        case 'sympy': return buildSympyCode(A, b);
        case 'scipy': return buildScipyCode(A, b);
        default: return buildNumpyCode(A, b);
    }
}

function getCompilerUrl(template, A, b, contextPath) {
    var code = buildCompilerCode(template, A, b);
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.LinearSolverExport = {
    buildFullLatex: buildFullLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    buildNumpyCode: buildNumpyCode,
    buildSympyCode: buildSympyCode,
    buildScipyCode: buildScipyCode,
    getCompilerUrl: getCompilerUrl
};

})();
