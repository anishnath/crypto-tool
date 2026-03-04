/**
 * Systems of Equations Solver - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

// ==================== Helpers ====================

function fmtNum(n) {
    if (n === null || n === undefined) return '0';
    if (!isFinite(n)) return String(n);
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return parseFloat(n.toFixed(8)).toString();
}

function fmtCoeff(c, varName, isFirst) {
    if (Math.abs(c) < 1e-12) return '';
    var s = '';
    if (!isFirst) s = c >= 0 ? ' + ' : ' - ';
    else if (c < 0) s = '-';
    var abs = Math.abs(c);
    var absStr = Math.abs(abs - Math.round(abs)) < 1e-9 ? String(Math.round(abs)) : parseFloat(abs.toFixed(6)).toString();
    return s + (absStr === '1' ? '' : absStr) + varName;
}

// ==================== LaTeX ====================

function buildLatex(state) {
    if (!state) return '';

    var solution = state.lastResult && state.lastResult.solution ? state.lastResult.solution : null;
    var A = state._A, b = state._b, vars = state._vars;

    // Linear system path: reconstruct from extracted A/b
    if (A && b && vars) {
        var size = vars.length;
        var lines = [];
        for (var i = 0; i < size; i++) {
            var row = A[i];
            var parts = [], firstNonZero = true;
            for (var j = 0; j < row.length; j++) {
                if (Math.abs(row[j]) < 1e-12) continue;
                parts.push(fmtCoeff(row[j], vars[j], firstNonZero));
                firstNonZero = false;
            }
            var lhs = parts.length > 0 ? parts.join('') : '0';
            lines.push('  ' + lhs + ' &= ' + fmtNum(b[i]));
        }
        var systemLatex = '\\begin{cases}\n' + lines.join(' \\\\\\\\\n') + '\n\\end{cases}';
        if (!solution || !Array.isArray(solution)) return systemLatex;
        var solParts = vars.map(function(v, k) { return v + ' = ' + fmtNum(solution[k]); });
        return systemLatex + '\n\\quad \\Rightarrow \\quad ' + solParts.join(',\\; ');
    }

    // Fallback: use raw equation strings
    if (state.equations && state.equations.length) {
        var eqLines = state.equations
            .filter(function(e) { return e && e.trim(); })
            .map(function(e) { return '  ' + e.trim(); });
        return '\\begin{cases}\n' + eqLines.join(' \\\\\\\\\n') + '\n\\end{cases}';
    }

    return '';
}

function copyLatex(state) {
    var latex = buildLatex(state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = {
        eqs: state.equations || [],
        mt: state.method || 'cramer'
    };

    var encoded;
    try {
        encoded = btoa(unescape(encodeURIComponent(JSON.stringify(data))));
    } catch (e) {
        encoded = '';
    }

    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return null;
    try {
        return JSON.parse(decodeURIComponent(escape(atob(d))));
    } catch (e) {
        // Try old format (legacy share links with sz/A2/b2 keys)
        try { return JSON.parse(atob(d)); } catch(e2) { return null; }
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

function buildNumpyCode(A, b, size) {
    var n = size;
    var aRows = [];
    for (var i = 0; i < n; i++) {
        aRows.push('    [' + A[i].join(', ') + ']');
    }
    var bRow = '    [' + b.join(', ') + ']';

    return 'import numpy as np\n\n' +
        '# ' + n + 'x' + n + ' System of Linear Equations: Ax = b\n' +
        '# Solved using numpy.linalg.solve\n\n' +
        'A = np.array([\n' + aRows.join(',\n') + '\n], dtype=float)\n\n' +
        'b = np.array(\n' + bRow + '\n, dtype=float)\n\n' +
        'print("Coefficient matrix A:")\n' +
        'print(A)\n' +
        'print("\\nRHS vector b:")\n' +
        'print(b)\n\n' +
        '# Check if system has a unique solution\n' +
        'det = np.linalg.det(A)\n' +
        'print(f"\\nDeterminant of A: {det:.6f}")\n\n' +
        'if abs(det) < 1e-10:\n' +
        '    print("Matrix is singular — system may be inconsistent or have infinite solutions.")\n' +
        'else:\n' +
        '    x = np.linalg.solve(A, b)\n' +
        '    print("\\nSolution:")\n' +
        '    for i, val in enumerate(x):\n' +
        '        var_name = chr(ord("x") + i)\n' +
        '        print(f"  {var_name} = {val:.6f}")\n\n' +
        '    # Verify: Ax should equal b\n' +
        '    residual = np.dot(A, x) - b\n' +
        '    print(f"\\nResidual ||Ax - b|| = {np.linalg.norm(residual):.2e}")\n' +
        '    print("Verification (Ax):", np.dot(A, x))\n';
}

function buildCramerCode(A, b, size) {
    var n = size;
    var aRows = [];
    for (var i = 0; i < n; i++) {
        aRows.push('[' + A[i].join(', ') + ']');
    }
    var bLit = '[' + b.join(', ') + ']';

    var detFunc = n === 2 ?
        'def det2(m):\n    return m[0][0]*m[1][1] - m[0][1]*m[1][0]\n\ndef det(m):\n    return det2(m)\n' :
        'def det3(m):\n' +
        '    return (m[0][0]*(m[1][1]*m[2][2]-m[1][2]*m[2][1])\n' +
        '           -m[0][1]*(m[1][0]*m[2][2]-m[1][2]*m[2][0])\n' +
        '           +m[0][2]*(m[1][0]*m[2][1]-m[1][1]*m[2][0]))\n\ndef det(m):\n    return det3(m)\n';

    return '# ' + n + 'x' + n + ' System of Linear Equations — Cramer\'s Rule (no libraries)\n\n' +
        'import copy\n\n' +
        'A = [' + aRows.join(', ') + ']\n' +
        'b = ' + bLit + '\n\n' +
        detFunc + '\n' +
        'def replace_col(matrix, col_idx, col_vals):\n' +
        '    """Return a new matrix with column col_idx replaced by col_vals."""\n' +
        '    m = copy.deepcopy(matrix)\n' +
        '    for i in range(len(m)):\n' +
        '        m[i][col_idx] = col_vals[i]\n' +
        '    return m\n\n' +
        'def cramer(A, b):\n' +
        '    n = len(A)\n' +
        '    detA = det(A)\n' +
        '    print(f"det(A) = {detA}")\n' +
        '    if abs(detA) < 1e-10:\n' +
        '        print("det(A) ≈ 0: system has no unique solution.")\n' +
        '        return None\n' +
        '    solution = []\n' +
        '    var_names = [chr(ord("x") + i) for i in range(n)]\n' +
        '    for i in range(n):\n' +
        '        Ai = replace_col(A, i, b)\n' +
        '        di = det(Ai)\n' +
        '        xi = di / detA\n' +
        '        solution.append(xi)\n' +
        '        print(f"  det(A{var_names[i]}) = {di:.6f} → {var_names[i]} = {di:.6f}/{detA:.6f} = {xi:.6f}")\n' +
        '    return solution\n\n' +
        'print("Coefficient matrix A:", A)\n' +
        'print("RHS vector b:", b)\n' +
        'print("\\nApplying Cramer\'s Rule:")\n' +
        'sol = cramer(A, b)\n' +
        'if sol:\n' +
        '    print("\\nSolution:")\n' +
        '    for i, v in enumerate(sol):\n' +
        '        print(f"  {chr(ord(\'x\')+i)} = {v:.6f}")\n' +
        '    # Verify\n' +
        '    print("\\nVerification (Ax):")\n' +
        '    for i in range(len(A)):\n' +
        '        row_sum = sum(A[i][j]*sol[j] for j in range(len(sol)))\n' +
        '        print(f"  Equation {i+1}: {row_sum:.6f} (expected {b[i]})")\n';
}

function buildSympyCode(A, b, size) {
    var n = size;
    var aRows = [];
    for (var i = 0; i < n; i++) {
        aRows.push('    [' + A[i].join(', ') + ']');
    }
    var bRow = '[' + b.join(', ') + ']';
    var varNames = size === 2 ? ['x', 'y'] : ['x', 'y', 'z'];
    var varDecl = varNames.join(', ') + ' = symbols("' + varNames.join(' ') + '")';
    var varList = 'var_list = [' + varNames.join(', ') + ']';

    return 'from sympy import symbols, Matrix, linsolve, Rational, pprint, det\n\n' +
        '# ' + n + 'x' + n + ' System — SymPy symbolic solution\n\n' +
        varDecl + '\n' +
        varList + '\n\n' +
        'A = Matrix([\n' + aRows.join(',\n') + '\n])\n\n' +
        'b = Matrix(' + bRow + ')\n\n' +
        'print("Coefficient matrix A:")\n' +
        'pprint(A)\n' +
        'print("\\nRHS vector b:")\n' +
        'pprint(b)\n\n' +
        '# Augmented matrix\n' +
        'aug = A.row_join(b)\n' +
        'print("\\nAugmented matrix [A|b]:")\n' +
        'pprint(aug)\n\n' +
        '# Determinant\n' +
        'd = det(A)\n' +
        'print(f"\\ndet(A) = {d}")\n\n' +
        '# Solve using linsolve\n' +
        'sol = linsolve((A, b), var_list)\n' +
        'print("\\nSolution set:")\n' +
        'pprint(sol)\n\n' +
        '# Extract and display\n' +
        'sol_list = list(sol)\n' +
        'if sol_list:\n' +
        '    print("\\nNumerical values:")\n' +
        '    s = sol_list[0]\n' +
        '    for i, var_sym in enumerate(var_list):\n' +
        '        print(f"  {var_sym} = {float(s[i]):.6f}")\n\n' +
        '# Inverse method (only for square non-singular)\n' +
        'if d != 0:\n' +
        '    print("\\nUsing Matrix inverse (A⁻¹b):")\n' +
        '    x_inv = A.inv() * b\n' +
        '    pprint(x_inv)\n';
}

function getPythonTemplate(templateId, state) {
    var A = state._A || [[2,3],[4,-1]];
    var b = state._b || [8,2];
    var size = A.length;

    switch (templateId) {
        case 'numpy':
            return buildNumpyCode(A, b, size);
        case 'cramer':
            return buildCramerCode(A, b, size);
        case 'sympy':
            return buildSympyCode(A, b, size);
        default:
            return buildNumpyCode(A, b, size);
    }
}

// ==================== Exports ====================

window.SystemsSolverExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getPythonTemplate: getPythonTemplate
};

})();
