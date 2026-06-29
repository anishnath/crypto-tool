// matrix-calculator-core.js — headless API for the LaTeX editor's Σ Solve.
//
// Mirrors the integral/derivative/limit cores. Exposes:
//   MatrixCalculatorCore.parseLatexMatrix(latex)
//       → { op, opLabel, latexA, latexB?, n?, cellsA, cellsB? }  or  null
//   MatrixCalculatorCore.solveFromLatex(latex, { withSteps })
//       → Promise<{ ok, resultLatex, resultText, method, sympySteps[], opLabel, error }>
//
// The detection + Python-build logic is lifted from
//   /modern/js/matrix-calculator.js
// so the editor's inline solver and the dedicated calculator page agree on
// what counts as a determinant, inverse, etc. — and produce identical
// step-by-step LaTeX.
(function () {
  'use strict';

  var OPS = {
    determinant:  { label: 'determinant',  binary: false, requireSquare: true,  needsExponent: false },
    inverse:      { label: 'inverse',      binary: false, requireSquare: true,  needsExponent: false },
    transpose:    { label: 'transpose',    binary: false, requireSquare: false, needsExponent: false },
    trace:        { label: 'trace',        binary: false, requireSquare: true,  needsExponent: false },
    rank:         { label: 'rank',         binary: false, requireSquare: false, needsExponent: false },
    rref:         { label: 'RREF',         binary: false, requireSquare: false, needsExponent: false },
    power:        { label: 'power',        binary: false, requireSquare: true,  needsExponent: true  },
    eigenvalues:  { label: 'eigenvalues',  binary: false, requireSquare: true,  needsExponent: false },
    eigenvectors: { label: 'eigenvectors', binary: false, requireSquare: true,  needsExponent: false },
    charpoly:     { label: 'char. poly',   binary: false, requireSquare: true,  needsExponent: false },
    add:          { label: 'A + B',        binary: true,  requireSquare: false, needsExponent: false, sameDims: true },
    subtract:     { label: 'A − B',        binary: true,  requireSquare: false, needsExponent: false, sameDims: true },
    multiply:     { label: 'A · B',        binary: true,  requireSquare: false, needsExponent: false, mulCompat: true }
  };

  // Reusable subexpression matching one balanced matrix environment.
  var MATRIX_RE_SRC =
    '\\\\begin\\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\\}' +
    '[\\s\\S]*?' +
    '\\\\end\\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\\}';

  function normalise(s) {
    return (s || '')
      .replace(/\\[,;:!]/g, ' ')
      .replace(/[ \s]+/g, ' ')
      .trim();
  }

  // Strip outer math delimiters added by the user (`$…$`, `\[…\]`, `\(…\)`).
  function stripMathDelims(s) {
    if (!s) return s;
    return s.trim()
      .replace(/^\$\$([\s\S]+)\$\$$/, '$1')
      .replace(/^\$([\s\S]+)\$$/, '$1')
      .replace(/^\\\(([\s\S]+)\\\)$/, '$1')
      .replace(/^\\\[([\s\S]+)\\\]$/, '$1')
      .trim();
  }

  // Detection — returns { op, latexA, latexB?, n? } or null.
  function detectOp(rawLatex) {
    var s = normalise(stripMathDelims(rawLatex));
    if (!s) return null;

    var prefixes = [
      { re: /^\\det\s+/i,                                                                  op: 'determinant'  },
      { re: /^(?:\\tr|tr|trace)\s+/i,                                                      op: 'trace'        },
      { re: /^\\operatorname\s*\{\s*tr\s*\}/i,                                             op: 'trace'        },
      { re: /^rank\s+/i,                                                                   op: 'rank'         },
      { re: /^\\operatorname\s*\{\s*rank\s*\}/i,                                           op: 'rank'         },
      { re: /^(?:rref|gauss[\s-]*jordan|reduced[\s-]*row[\s-]*echelon|row[\s-]*echelon)\s+/i, op: 'rref'      },
      { re: /^\\operatorname\s*\{\s*RREF\s*\}/i,                                           op: 'rref'         },
      { re: /^eigen\s*values?\s+/i,                                                        op: 'eigenvalues'  },
      { re: /^\\operatorname\s*\{\s*eigenvalues\s*\}/i,                                   op: 'eigenvalues'  },
      { re: /^(?:eigen\s*vectors?|diagonali[sz]e)\s+/i,                                    op: 'eigenvectors' },
      { re: /^\\operatorname\s*\{\s*eigenvectors\s*\}/i,                                   op: 'eigenvectors' },
      { re: /^(?:char(?:acteristic)?\s*poly(?:nomial)?)\s+/i,                              op: 'charpoly'     },
      { re: /^\\operatorname\s*\{\s*char\\,poly\s*\}/i,                                    op: 'charpoly'     }
    ];
    for (var i = 0; i < prefixes.length; i++) {
      var pm = s.match(prefixes[i].re);
      if (!pm) continue;
      var rest = s.slice(pm[0].length).trim();
      var bare = rest.match(new RegExp('^(' + MATRIX_RE_SRC + ')$'));
      if (bare) return { op: prefixes[i].op, latexA: bare[1] };
    }

    var firstMatch = s.match(new RegExp('^(' + MATRIX_RE_SRC + ')([\\s\\S]*)$'));
    if (!firstMatch) return null;
    var matA = firstMatch[1];
    var tail = firstMatch[2].trim();
    if (!tail) return null;  // bare matrix — defer; no operation chosen

    // Suffix forms ─────────────────────────────────────────────
    if (/^\^\s*\{?\s*-\s*1\s*\}?\s*$/.test(tail))
      return { op: 'inverse', latexA: matA };
    if (/^\^\s*\{?\s*T\s*\}?\s*$/.test(tail))
      return { op: 'transpose', latexA: matA };
    var powMatch = tail.match(/^\^\s*\{?\s*(-?\d+)\s*\}?\s*$/);
    if (powMatch)
      return { op: 'power', latexA: matA, n: parseInt(powMatch[1], 10) };

    // Infix forms ──────────────────────────────────────────────
    var infixMatch = tail.match(new RegExp(
      '^\\s*([+\\-]|\\\\cdot|\\\\times|\\*)?\\s*(' + MATRIX_RE_SRC + ')\\s*$'
    ));
    if (infixMatch) {
      var sep = infixMatch[1] || '';
      var matB = infixMatch[2];
      var op = (sep === '+') ? 'add'
             : (sep === '-') ? 'subtract'
             :                 'multiply';
      return { op: op, latexA: matA, latexB: matB };
    }

    return null;
  }

  // Matrix cell parsing — same as the page version.
  function parseMatrixCells(latex) {
    if (!latex) return null;
    var m = latex.match(/\\begin\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}([\s\S]*?)\\end\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/);
    if (!m) return null;
    var body = m[1];
    var rows = body.split(/\\\\(?:\s*\[[^\]]*\])?/);
    if (rows.length && rows[rows.length - 1].trim() === '') rows.pop();
    if (!rows.length) return null;
    var cells = rows.map(function (r) {
      return r.split('&').map(function (c) { return c.trim(); });
    });
    var maxCols = 0;
    cells.forEach(function (r) { if (r.length > maxCols) maxCols = r.length; });
    cells.forEach(function (r) { while (r.length < maxCols) r.push('0'); });
    return cells;
  }
  function parseMatrixDims(latex) {
    var c = parseMatrixCells(latex);
    if (!c) return null;
    return { rows: c.length, cols: c[0] ? c[0].length : 0 };
  }

  // Public parse entry — combines detection + cell parse + dimension validation.
  function parseLatexMatrix(rawLatex) {
    var d = detectOp(rawLatex);
    if (!d) return null;
    var def = OPS[d.op];
    var cellsA = parseMatrixCells(d.latexA);
    if (!cellsA) return null;
    var dimA = { rows: cellsA.length, cols: cellsA[0].length };
    if (def.requireSquare && dimA.rows !== dimA.cols) return null;

    var cellsB = null;
    if (def.binary) {
      cellsB = parseMatrixCells(d.latexB);
      if (!cellsB) return null;
      var dimB = { rows: cellsB.length, cols: cellsB[0].length };
      if (def.sameDims && (dimA.rows !== dimB.rows || dimA.cols !== dimB.cols)) return null;
      if (def.mulCompat && dimA.cols !== dimB.rows) return null;
    }

    return {
      op: d.op,
      opLabel: def.label,
      latexA: d.latexA,
      latexB: d.latexB || null,
      n: d.n != null ? d.n : null,
      cellsA: cellsA,
      cellsB: cellsB,
      dimA: dimA
    };
  }

  // ── Python build (SymPy backend) ─────────────────────────────────────

  function cellsToPyList(cells) {
    if (!cells) return '[]';
    var rows = cells.map(function (row) {
      var parts = row.map(function (c) {
        var safe = (c || '0').replace(/"""/g, '\\"\\"\\"');
        return 'r"""' + safe + '"""';
      });
      return '[' + parts.join(', ') + ']';
    });
    return '[' + rows.join(', ') + ']';
  }

  function pythonPreamble(cellsA, cellsB) {
    var code = 'from sympy import *\n';
    code += 'from sympy.parsing.latex import parse_latex\n';
    code += 'import json, re, signal\n\n';
    code += 'def _to(sig, fr): raise TimeoutError("Solver timed out (15s)")\n';
    code += 'signal.signal(signal.SIGALRM, _to)\n';
    code += 'signal.alarm(15)\n\n';
    code += 'def _cell(s):\n';
    code += '    s = (s or "").strip()\n';
    code += '    if not s: return Integer(0)\n';
    code += '    s = re.sub(r"\\\\left\\s*([({\\[|])", r"\\1", s)\n';
    code += '    s = re.sub(r"\\\\right\\s*([)}\\]|])", r"\\1", s)\n';
    code += '    s = re.sub(r"\\\\(?:Big[lr]?|big[lr]?)\\s*", "", s)\n';
    code += '    try:\n';
    code += '        return parse_latex(s)\n';
    code += '    except Exception:\n';
    code += '        s2 = s.replace("\\\\pi", "pi").replace("\\\\theta", "theta")\n';
    code += '        s2 = re.sub(r"\\\\(?:cdot|times)", "*", s2)\n';
    code += '        s2 = s2.replace("^", "**")\n';
    code += '        try: return sympify(s2)\n';
    code += '        except Exception: raise ValueError("Could not parse cell: " + repr(s))\n\n';
    code += 'def _matrix(cells):\n';
    code += '    return Matrix([[_cell(c) for c in row] for row in cells])\n\n';
    code += 'A_DATA = ' + cellsToPyList(cellsA) + '\n';
    code += 'A = _matrix(A_DATA)\n';
    if (cellsB != null) {
      code += 'B_DATA = ' + cellsToPyList(cellsB) + '\n';
      code += 'B = _matrix(B_DATA)\n';
    }
    code += 'steps = []\n';
    return code;
  }

  // Per-op SymPy program — mirrors matrix-calculator.js exactly.
  function buildPython(op, cellsA, cellsB, n) {
    var def = OPS[op];
    var py = pythonPreamble(cellsA, def.binary ? cellsB : null);
    py += 'try:\n';

    if (op === 'determinant') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Determinant requires a square matrix")\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    if A.rows == 1:\n';
      py += '        result = A[0,0]\n';
      py += '        steps.append({"title":"1x1 trivial case","latex":"\\\\det(A) = " + latex(result)})\n';
      py += '    elif A.rows == 2:\n';
      py += '        a,b,c,d = A[0,0],A[0,1],A[1,0],A[1,1]\n';
      py += '        steps.append({"title":"2x2 formula","latex":"\\\\det(A) = ad - bc"})\n';
      py += '        steps.append({"title":"Substitute","latex":"= (" + latex(a) + ")(" + latex(d) + ") - (" + latex(b) + ")(" + latex(c) + ")"})\n';
      py += '        result = simplify(a*d - b*c)\n';
      py += '        steps.append({"title":"Simplify","latex":"\\\\det(A) = " + latex(result)})\n';
      py += '    else:\n';
      py += '        steps.append({"title":"Cofactor expansion along row 1","latex":"\\\\det(A) = \\\\sum_{j=1}^{n} (-1)^{1+j} a_{1j} M_{1j}"})\n';
      py += '        terms = []\n        running = []\n';
      py += '        for j in range(A.cols):\n';
      py += '            sign = 1 if j % 2 == 0 else -1\n';
      py += '            entry = A[0,j]\n';
      py += '            minor_val = A.minor_submatrix(0, j).det()\n';
      py += '            terms.append(sign * entry * minor_val)\n';
      py += '            running.append(("+" if sign>0 else "-") + " " + latex(entry) + " \\\\cdot " + latex(minor_val))\n';
      py += '        steps.append({"title":"Compute each minor","latex":" ".join(running).lstrip("+ ").strip()})\n';
      py += '        result = simplify(sum(terms))\n';
      py += '        steps.append({"title":"Sum and simplify","latex":"\\\\det(A) = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'inverse') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Inverse requires a square matrix")\n';
      py += '    detA = A.det()\n';
      py += '    if detA == 0:\n        raise ValueError("Matrix is singular (det = 0); no inverse exists")\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Determinant","latex":"\\\\det(A) = " + latex(detA)})\n';
      py += '    if A.rows <= 3:\n';
      py += '        cof = A.cofactor_matrix(); adj = cof.T\n';
      py += '        steps.append({"title":"Cofactor matrix","latex":"\\\\mathrm{cof}(A) = " + latex(cof)})\n';
      py += '        steps.append({"title":"Adjugate (transpose of cofactor)","latex":"\\\\mathrm{adj}(A) = " + latex(adj)})\n';
      py += '        result = simplify(adj / detA)\n';
      py += '        steps.append({"title":"Divide by det(A)","latex":"A^{-1} = \\\\tfrac{1}{\\\\det(A)}\\\\,\\\\mathrm{adj}(A) = " + latex(result)})\n';
      py += '    else:\n';
      py += '        aug = A.row_join(eye(A.rows))\n';
      py += '        steps.append({"title":"Augment with identity","latex":"[A \\\\mid I] = " + latex(aug)})\n';
      py += '        rref_mat, _ = aug.rref()\n';
      py += '        steps.append({"title":"Row-reduce to [I | A^{-1}]","latex":"\\\\mathrm{RREF} = " + latex(rref_mat)})\n';
      py += '        result = simplify(rref_mat[:, A.cols:])\n';
      py += '        steps.append({"title":"Right block is A^{-1}","latex":"A^{-1} = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'transpose') {
      py += '    result = A.T\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Swap rows and columns","latex":"A^T_{ij} = A_{ji}"})\n';
      py += '    steps.append({"title":"Result","latex":"A^T = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'trace') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Trace requires a square matrix")\n';
      py += '    diag_terms = [A[i,i] for i in range(A.rows)]\n';
      py += '    result = sum(diag_terms)\n';
      py += '    diag_sum_unsim = Add(*diag_terms, evaluate=False)\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Sum of the main diagonal","latex":"\\\\mathrm{tr}(A) = " + latex(diag_sum_unsim)})\n';
      py += '    steps.append({"title":"Result","latex":"\\\\mathrm{tr}(A) = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'rank') {
      py += '    rref_mat, pivots = A.rref()\n';
      py += '    result = len(pivots)\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Row-reduced echelon form","latex":"\\\\mathrm{RREF}(A) = " + latex(rref_mat)})\n';
      py += '    steps.append({"title":"Rank = number of pivot columns","latex":"\\\\mathrm{rank}(A) = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'rref') {
      py += '    rref_mat, pivots = A.rref()\n';
      py += '    result = rref_mat\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Apply Gauss-Jordan elimination","latex":"\\\\text{Pivot columns: } " + str(list(pivots))})\n';
      py += '    steps.append({"title":"Reduced row echelon form","latex":"\\\\mathrm{RREF}(A) = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'power') {
      py += '    if A.rows != A.cols:\n        raise ValueError("A^n requires a square matrix")\n';
      py += '    n = ' + (parseInt(n, 10) || 0) + '\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    if n == 0:\n';
      py += '        result = eye(A.rows); steps.append({"title":"A^0 = I","latex":"A^0 = " + latex(result)})\n';
      py += '    elif n == 1:\n';
      py += '        result = A; steps.append({"title":"A^1 = A","latex":"A^1 = " + latex(result)})\n';
      py += '    elif n < 0:\n';
      py += '        if A.det() == 0: raise ValueError("Negative powers require an invertible matrix")\n';
      py += '        Ainv = A.inv()\n';
      py += '        steps.append({"title":"Negative power: invert A first","latex":"A^{-1} = " + latex(Ainv)})\n';
      py += '        result = Ainv ** abs(n)\n';
      py += '        steps.append({"title":"Raise A^{-1} to |n|","latex":"A^{" + str(n) + "} = " + latex(result)})\n';
      py += '    else:\n';
      py += '        MAX_STEPS = 6; cur = A\n';
      py += '        if n <= MAX_STEPS:\n';
      py += '            for k in range(2, n+1):\n';
      py += '                nxt = cur * A\n';
      py += '                steps.append({"title":"A^"+str(k),"latex":"A^{"+str(k-1)+"}\\\\cdot A = " + latex(nxt)})\n';
      py += '                cur = nxt\n';
      py += '        else:\n';
      py += '            for k in range(2, 5):\n';
      py += '                nxt = cur * A\n';
      py += '                steps.append({"title":"A^"+str(k),"latex":"A^{"+str(k-1)+"}\\\\cdot A = " + latex(nxt)})\n';
      py += '                cur = nxt\n';
      py += '            steps.append({"title":"...","latex":"\\\\text{(continuing through } A^{" + str(n-1) + "} \\\\text{)}"})\n';
      py += '            cur = A ** n\n';
      py += '            steps.append({"title":"A^"+str(n),"latex":"A^{"+str(n)+"} = " + latex(cur)})\n';
      py += '        result = cur\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'eigenvalues') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Eigenvalues require a square matrix")\n';
      py += '    lam = symbols("lambda")\n';
      py += '    char_mat = A - lam*eye(A.rows)\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Form A - \\\\lambda I","latex":"A - \\\\lambda I = " + latex(char_mat)})\n';
      py += '    char_poly = expand(char_mat.det())\n';
      py += '    steps.append({"title":"Characteristic polynomial","latex":"\\\\det(A - \\\\lambda I) = " + latex(char_poly)})\n';
      py += '    steps.append({"title":"Set = 0","latex":latex(char_poly) + " = 0"})\n';
      py += '    eigs = A.eigenvals()\n';
      py += '    eig_list = list(eigs.items())\n';
      py += '    if not eig_list:\n        raise ValueError("No closed-form eigenvalues for this matrix")\n';
      py += '    parts = []\n';
      py += '    for v, mult in eig_list:\n';
      py += '        parts.append(latex(v) + (" \\\\,(\\\\text{mult. " + str(mult) + "})" if mult > 1 else ""))\n';
      py += '    steps.append({"title":"Solve for lambda","latex":"\\\\lambda = " + ", \\\\;".join(parts)})\n';
      py += '    out_latex = ", \\\\;".join(parts)\n';
      py += '    out_text = ", ".join(str(v) + ("^" + str(mult) if mult>1 else "") for v,mult in eig_list)\n';

    } else if (op === 'eigenvectors') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Eigenvectors require a square matrix")\n';
      py += '    lam = symbols("lambda")\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    char_poly0 = expand((A - lam*eye(A.rows)).det())\n';
      py += '    steps.append({"title":"Characteristic polynomial","latex":"\\\\det(A - \\\\lambda I) = " + latex(char_poly0) + " = 0"})\n';
      py += '    eig_data = A.eigenvects()\n';
      py += '    out_parts = []\n';
      py += '    for val, mult, vects in eig_data:\n';
      py += '        steps.append({"title":"Eigenvalue lambda = " + latex(val),"latex":"\\\\lambda = " + latex(val) + " \\\\;\\\\text{(algebraic mult. " + str(mult) + ")}"})\n';
      py += '        AmlI = A - val*eye(A.rows)\n';
      py += '        steps.append({"title":"Form (A - lambda I)","latex":"A - (" + latex(val) + ") I = " + latex(AmlI)})\n';
      py += '        try:\n';
      py += '            rref_mat, _piv = AmlI.rref()\n';
      py += '            steps.append({"title":"Row-reduce (solve (A-lambda I) v = 0)","latex":"\\\\mathrm{RREF} = " + latex(rref_mat)})\n';
      py += '        except Exception: pass\n';
      py += '        for k, v in enumerate(vects, 1):\n';
      py += '            steps.append({"title":"Eigenvector " + str(k) + " for lambda = " + latex(val),"latex":"v_{" + str(k) + "} = " + latex(v)})\n';
      py += '            out_parts.append("\\\\lambda = " + latex(val) + ":\\\\; v = " + latex(v))\n';
      py += '    out_latex = " \\\\\\\\ ".join(out_parts)\n';
      py += '    out_text = str(eig_data)\n';

    } else if (op === 'charpoly') {
      py += '    if A.rows != A.cols:\n        raise ValueError("Characteristic polynomial requires a square matrix")\n';
      py += '    lam = symbols("lambda")\n';
      py += '    poly = A.charpoly(lam).as_expr()\n';
      py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
      py += '    steps.append({"title":"Characteristic polynomial","latex":"p(\\\\lambda) = \\\\det(A - \\\\lambda I) = " + latex(poly)})\n';
      py += '    result = poly\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'add') {
      py += '    if A.shape != B.shape:\n        raise ValueError("A + B requires same shape")\n';
      py += '    result = A + B\n';
      py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + ", \\\\quad B = " + latex(B)})\n';
      py += '    steps.append({"title":"Element-wise sum","latex":"(A+B)_{ij} = A_{ij} + B_{ij}"})\n';
      py += '    steps.append({"title":"Result","latex":"A + B = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'subtract') {
      py += '    if A.shape != B.shape:\n        raise ValueError("A - B requires same shape")\n';
      py += '    result = A - B\n';
      py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + ", \\\\quad B = " + latex(B)})\n';
      py += '    steps.append({"title":"Element-wise difference","latex":"(A-B)_{ij} = A_{ij} - B_{ij}"})\n';
      py += '    steps.append({"title":"Result","latex":"A - B = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else if (op === 'multiply') {
      py += '    if A.cols != B.rows:\n        raise ValueError("A.cols must equal B.rows for multiplication")\n';
      py += '    result = A * B\n';
      py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + " \\\\;(" + str(A.rows) + "\\\\times" + str(A.cols) + "), \\\\quad B = " + latex(B) + " \\\\;(" + str(B.rows) + "\\\\times" + str(B.cols) + ")"})\n';
      py += '    steps.append({"title":"Definition","latex":"(AB)_{ij} = \\\\sum_{k} A_{ik}B_{kj}"})\n';
      py += '    if A.rows*B.cols <= 9:\n';
      py += '        for i in range(A.rows):\n';
      py += '            for j in range(B.cols):\n';
      py += '                terms = ["(" + latex(A[i,k]) + ")(" + latex(B[k,j]) + ")" for k in range(A.cols)]\n';
      py += '                steps.append({"title":"Entry ("+str(i+1)+","+str(j+1)+")","latex":"(AB)_{" + str(i+1) + str(j+1) + "} = " + " + ".join(terms) + " = " + latex(result[i,j])})\n';
      py += '    steps.append({"title":"Result","latex":"AB = " + latex(result)})\n';
      py += '    out_latex = latex(result); out_text = str(result)\n';

    } else {
      py += '    raise ValueError("Unknown operation: ' + op + '")\n';
    }

    // Common trailer — JSON-serialise result + steps so the JS caller can
    // shape it into the standard {ok, resultLatex, ...} envelope.
    py += '    out = {"ok": True, "latex": out_latex, "text": out_text, "steps": steps}\n';
    py += 'except TimeoutError:\n';
    py += '    out = {"ok": False, "error": "Solver timed out (15s)"}\n';
    py += 'except Exception as e:\n';
    py += '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}\n';
    py += 'finally:\n';
    py += '    signal.alarm(0)\n';
    py += 'print("RESULT:" + json.dumps(out))\n';
    return py;
  }

  function ctxPath() {
    if (typeof window === 'undefined') return '';
    if (window.MATH_CALC_CTX) return window.MATH_CALC_CTX;
    if (window.__MC_CTX) return window.__MC_CTX;
    if (window.INTEGRAL_CALC_CTX) return window.INTEGRAL_CALC_CTX;
    if (window.CONFIG && window.CONFIG.ctx) return window.CONFIG.ctx;
    var meta = document.querySelector && document.querySelector('meta[name="ctx"]');
    if (meta && meta.content) return meta.content;
    return '';
  }

  function solveFromLatex(rawLatex, opts) {
    opts = opts || {};
    var parsed = parseLatexMatrix(rawLatex);
    if (!parsed) {
      return Promise.resolve({ ok: false, error: 'Could not parse matrix expression' });
    }
    var def = OPS[parsed.op];
    var code = buildPython(parsed.op, parsed.cellsA, parsed.cellsB, parsed.n);

    return fetch(ctxPath() + '/OneCompilerFunctionality?action=execute', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ language: 'python', version: '3.10', code: code })
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
      var stdout = (data.Stdout || data.stdout || '').trim();
      var stderr = (data.Stderr || data.stderr || '').trim();
      var m = stdout.match(/RESULT:(\{[\s\S]*\})\s*$/);
      if (!m) {
        var hint = stderr.split('\n').pop() || stdout.split('\n').pop() || 'No solver output';
        return { ok: false, error: hint };
      }
      var parsedOut;
      try { parsedOut = JSON.parse(m[1]); }
      catch (e) { return { ok: false, error: 'Solver returned bad data' }; }
      if (!parsedOut.ok) return { ok: false, error: parsedOut.error || 'Solver failed' };
      return {
        ok: true,
        method: def.label,
        opLabel: def.label,
        op: parsed.op,
        resultLatex: parsedOut.latex || '',
        value: parsedOut.text || '',
        sympySteps: Array.isArray(parsedOut.steps) ? parsedOut.steps : [],
        // expose parsed input so math-insert can build labels / context
        input: parsed
      };
    })
    .catch(function (err) {
      return { ok: false, error: 'Solver network error: ' + (err && err.message || err) };
    });
  }

  // ── Geometric visualization eligibility (2×2 and 3×3 numeric) ─────────
  var VISUALIZABLE_OPS = ['determinant', 'inverse', 'transpose', 'eigenvectors',
    'power', 'multiply', 'add', 'subtract'];
  var VISUALIZABLE_OPS_2D = VISUALIZABLE_OPS.slice();

  function isNumericCells(cells) {
    if (!cells || !cells.length) return false;
    var numRe = /^-?\d*\.?\d+(?:[eE][+-]?\d+)?$/;
    for (var i = 0; i < cells.length; i++) {
      var row = cells[i];
      if (!row || !row.length) return false;
      for (var j = 0; j < row.length; j++) {
        var s = (row[j] || '').trim();
        if (!numRe.test(s) || !isFinite(parseFloat(s))) return false;
      }
    }
    return true;
  }

  function cellsToNumericMatrix(cells) {
    return cells.map(function (row) {
      return row.map(function (c) { return parseFloat(c); });
    });
  }

  // Can we draw a 2D pgfplots picture for this parsed expression?
  function canVisualize(op, cellsA, cellsB) {
    if (VISUALIZABLE_OPS.indexOf(op) === -1) return false;
    if (!cellsA) return false;
    var rows = cellsA.length;
    var cols = cellsA[0] ? cellsA[0].length : 0;
    if (rows !== cols) return false;
    if (rows !== 2 && rows !== 3) return false;
    if (op === 'eigenvectors' && rows === 3) return false;
    if (!isNumericCells(cellsA)) return false;
    if (OPS[op].binary) {
      if (!cellsB || !isNumericCells(cellsB)) return false;
      if (cellsB.length !== rows || cellsB[0].length !== cols) return false;
    }
    return true;
  }

  function canVisualize2D(parsed) {
    if (!parsed) return false;
    if (!canVisualize(parsed.op, parsed.cellsA, parsed.cellsB)) return false;
    return parsed.dimA && parsed.dimA.rows === 2 && parsed.dimA.cols === 2;
  }

  function applyMat2(M, v) {
    return [M[0][0]*v[0] + M[0][1]*v[1], M[1][0]*v[0] + M[1][1]*v[1]];
  }
  function transformPath(M, path) {
    return path.map(function (p) { return applyMat2(M, p); });
  }
  function unitSquare() { return [[0,0],[1,0],[1,1],[0,1],[0,0]]; }

  function det2(M) { return M[0][0]*M[1][1] - M[0][1]*M[1][0]; }
  function inv2(M) {
    var d = det2(M);
    if (Math.abs(d) < 1e-12) return null;
    return [[ M[1][1]/d, -M[0][1]/d],
            [-M[1][0]/d,  M[0][0]/d]];
  }
  function combine(A, B, op) {
    return [[A[0][0] + (op==='add'?B[0][0]:-B[0][0]), A[0][1] + (op==='add'?B[0][1]:-B[0][1])],
            [A[1][0] + (op==='add'?B[1][0]:-B[1][0]), A[1][1] + (op==='add'?B[1][1]:-B[1][1])]];
  }
  function mulMat2(A, B) {
    return [[A[0][0]*B[0][0]+A[0][1]*B[1][0], A[0][0]*B[0][1]+A[0][1]*B[1][1]],
            [A[1][0]*B[0][0]+A[1][1]*B[1][0], A[1][0]*B[0][1]+A[1][1]*B[1][1]]];
  }

  // Real eigenvectors of a 2x2 (returns null when eigenvalues are complex).
  function eigen2(A) {
    var a = A[0][0], b = A[0][1], c = A[1][0], d = A[1][1];
    var tr = a + d, det = a*d - b*c;
    var disc = tr*tr - 4*det;
    if (disc < 0) return null;
    var s = Math.sqrt(disc);
    var lams = [(tr + s) / 2, (tr - s) / 2];
    function vecFor(lam) {
      var v;
      if (Math.abs(b) > 1e-10)        v = [b, lam - a];
      else if (Math.abs(c) > 1e-10)   v = [lam - d, c];
      else                            v = (Math.abs(lam - a) < 1e-10) ? [1, 0] : [0, 1];
      var n = Math.sqrt(v[0]*v[0] + v[1]*v[1]) || 1;
      return [v[0]/n, v[1]/n];
    }
    return { values: lams, vectors: [vecFor(lams[0]), vecFor(lams[1])] };
  }

  function rowsToPmatrix(rows) {
    if (!rows || !rows.length) return '';
    return '\\begin{pmatrix}'
      + rows.map(function (r) { return r.join(' & '); }).join('\\\\')
      + '\\end{pmatrix}';
  }

  /** True when s is already a LaTeX matrix environment. */
  function isProperMatrixLatex(s) {
    return /\\begin\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/.test(String(s || ''));
  }

  /**
   * Rebuild every matrix environment from parsed cells so row separators are
   * correct for KaTeX (\\\\ in JS string). Fixes AI/chat backslash loss:
   * \begin{pmatrix}4 & 7\2 & 6\end{pmatrix} → proper pmatrix.
   */
  function repairMatrixLatex(s) {
    if (s == null) return '';
    var str = String(s);
    if (!isProperMatrixLatex(str)) return str;
    return str.replace(
      /\\begin\{(pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}([\s\S]*?)\\end\{(pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/g,
      function (full, envOpen, _body, envClose) {
        if (envOpen !== envClose) return full;
        var cells = parseMatrixCells(full);
        if (!cells || !cells.length) return full;
        return '\\begin{' + envOpen + '}'
          + cells.map(function (r) { return r.join(' & '); }).join('\\\\')
          + '\\end{' + envClose + '}';
      }
    );
  }

  /**
   * Convert AI/chat shorthand like "(2 1 \\ 5 3)" or "[[2,1],[5,3]]" to pmatrix LaTeX.
   * Existing pmatrix blocks are parsed and rebuilt (fixes single-\\ row separators).
   */
  function normalizeMatrixLatex(s) {
    if (s == null) return '';
    var t = String(s).trim();
    if (!t) return t;
    if (isProperMatrixLatex(t)) return repairMatrixLatex(t);

    /* [[2,1],[5,3]] or [[2, 1], [5, 3]] */
    if (/^\[\s*\[/.test(t)) {
      try {
        var parsed = JSON.parse(t.replace(/'/g, '"'));
        if (Array.isArray(parsed) && parsed.length && parsed.every(function (row) { return Array.isArray(row); })) {
          return rowsToPmatrix(parsed.map(function (row) {
            return row.map(function (c) { return String(c).trim(); });
          }));
        }
      } catch (e1) { /* fall through to bracket split */ }
      var inner = t.replace(/^\[\s*/, '').replace(/\s*\]\s*$/, '');
      var rowStrs = inner.split(/\]\s*,\s*\[/);
      var parsedRows = rowStrs.map(function (rs) {
        rs = rs.replace(/^\[/, '').replace(/\]$/, '');
        return rs.split(/,/).map(function (c) { return c.trim(); }).filter(Boolean);
      }).filter(function (r) { return r.length; });
      if (parsedRows.length >= 1) {
        var w0 = parsedRows[0].length;
        if (parsedRows.every(function (r) { return r.length === w0; })) return rowsToPmatrix(parsedRows);
      }
    }

    /* Strip one pair of outer parens/brackets: (2 1 \ 5 3) */
    var body = t;
    if (/^\(\s*[\s\S]+\s*\)$/.test(body)) body = body.slice(1, -1).trim();
    else if (/^\[\s*[\s\S]+\s*\]$/.test(body) && body.indexOf('[') === body.lastIndexOf('[')) {
      body = body.slice(1, -1).trim();
    }

    var rowParts = null;
    if (/\\/.test(body)) rowParts = body.split(/\\+/);
    else if (/;/.test(body)) rowParts = body.split(/\s*;\s*/);

    if (rowParts && rowParts.length >= 2) {
      rowParts = rowParts.map(function (r) { return r.trim(); }).filter(Boolean);
      var matrix = rowParts.map(function (row) {
        if (/,/.test(row)) return row.split(/\s*,\s*/).map(function (c) { return c.trim(); }).filter(Boolean);
        return row.split(/\s+/).filter(Boolean);
      });
      var cols = matrix[0].length;
      if (cols >= 1 && matrix.every(function (r) { return r.length === cols; })) {
        return rowsToPmatrix(matrix);
      }
    }

    return t;
  }

  /**
   * Normalize full matrix expressions (raw field) — shorthand parens, det/eigenvalues prefixes.
   */
  function normalizeMatrixExpression(expr) {
    if (expr == null) return '';
    var s = String(expr).trim();
    if (!s) return s;
    if (isProperMatrixLatex(s)) return repairMatrixLatex(s);

    /* Replace ( row \ row ) shorthand anywhere in the string */
    s = s.replace(/\(\s*([^()]*?\\[^()]*?)\s*\)/g, function (match, inner) {
      var pm = normalizeMatrixLatex('(' + inner + ')');
      return pm.indexOf('\\begin{pmatrix}') === 0 ? pm : match;
    });

    if (!isProperMatrixLatex(s)) {
      var whole = normalizeMatrixLatex(s);
      if (isProperMatrixLatex(whole)) s = whole;
    }

    s = s.replace(/\bdet\b/g, '\\det');
    s = s.replace(/\btrace\b/g, '\\operatorname{tr}');
    s = s.replace(/\beigenvalues\b/gi, '\\operatorname{eigenvalues}');
    s = s.replace(/\beigenvectors\b/gi, '\\operatorname{eigenvectors}');
    s = s.replace(/\bchar\s*poly\b/gi, '\\operatorname{char\\,poly}');
    return repairMatrixLatex(s);
  }

  function normalizeMatrixTask(task) {
    if (!task || typeof task !== 'object') return task;
    var out = {};
    Object.keys(task).forEach(function (k) { out[k] = task[k]; });
    if (out.matrixA) out.matrixA = normalizeMatrixLatex(out.matrixA);
    if (out.matrix_a) out.matrix_a = normalizeMatrixLatex(out.matrix_a);
    if (out.matrixB) out.matrixB = normalizeMatrixLatex(out.matrixB);
    if (out.matrix_b) out.matrix_b = normalizeMatrixLatex(out.matrix_b);
    if (out.raw) out.raw = normalizeMatrixExpression(out.raw);
    return out;
  }

  function buildLatexFromTask(task) {
    if (!task) return '';
    task = normalizeMatrixTask(task);
    if (task.raw) return normalizeMatrixExpression(String(task.raw).trim());
    var op = String(task.op || task.operation || 'determinant').toLowerCase();
    var A = String(task.matrixA || task.matrix_a || task.latexA || '').trim();
    var B = String(task.matrixB || task.matrix_b || task.latexB || '').trim();
    var n = task.n != null && task.n !== '' ? parseInt(String(task.n), 10) : 2;
    if (!A) return '';
    A = normalizeMatrixLatex(A);
    if (B) B = normalizeMatrixLatex(B);
    switch (op) {
      case 'determinant': case 'det': return '\\det ' + A;
      case 'inverse': return A + '^{-1}';
      case 'transpose': return A + '^{T}';
      case 'trace': case 'tr': return '\\operatorname{tr}' + A;
      case 'rank': return '\\operatorname{rank}' + A;
      case 'rref': return '\\operatorname{RREF}' + A;
      case 'eigenvalues': return '\\operatorname{eigenvalues}' + A;
      case 'eigenvectors': return '\\operatorname{eigenvectors}' + A;
      case 'charpoly': case 'characteristic': return '\\operatorname{char\\,poly}' + A;
      case 'power': return A + '^{' + (Number.isFinite(n) ? n : 2) + '}';
      case 'add': return B ? A + ' + ' + B : A;
      case 'subtract': case 'sub': return B ? A + ' - ' + B : A;
      case 'multiply': case 'mul': return B ? A + ' \\cdot ' + B : A;
      default: return A;
    }
  }

  function solveTask(task, opts) {
    opts = opts || {};
    var latex = buildLatexFromTask(task);
    if (!latex) {
      return Promise.resolve({ ok: false, error: 'Missing matrix expression (need op + matrixA or raw LaTeX).' });
    }
    return solveFromLatex(latex, { withSteps: !!(opts.withSteps || opts.mode === 'steps') });
  }

  /** Parse a matrix task object into { op, cellsA, cellsB, n, ... } (no SymPy call). */
  function parseTask(task) {
    if (!task) return null;
    task = normalizeMatrixTask(task);
    var latex = buildLatexFromTask(task);
    if (!latex) return null;
    var parsed = parseLatexMatrix(latex);
    if (!parsed) return null;
    if (task.n != null && task.n !== '' && parsed.n == null) parsed.n = task.n;
    return parsed;
  }

  function canVisualizeTask(task) {
    var parsed = parseTask(task);
    if (!parsed) return false;
    return canVisualize(parsed.op, parsed.cellsA, parsed.cellsB);
  }

  if (typeof window !== 'undefined') {
    window.MatrixCalculatorCore = {
      OPS: OPS,
      parseLatexMatrix: parseLatexMatrix,
      parseMatrixCells: parseMatrixCells,
      parseMatrixDims: parseMatrixDims,
      detectOp: detectOp,
      normalizeMatrixLatex: normalizeMatrixLatex,
      normalizeMatrixExpression: normalizeMatrixExpression,
      normalizeMatrixTask: normalizeMatrixTask,
      repairMatrixLatex: repairMatrixLatex,
      buildLatexFromTask: buildLatexFromTask,
      parseTask: parseTask,
      solveFromLatex: solveFromLatex,
      solveTask: solveTask,
      // Geometry helpers (used by the editor's graph-block builder + Math AI chat)
      canVisualize: canVisualize,
      canVisualizeTask: canVisualizeTask,
      canVisualize2D: canVisualize2D,
      isNumericCells: isNumericCells,
      cellsToNumericMatrix: cellsToNumericMatrix,
      transformPath: transformPath,
      unitSquare: unitSquare,
      det2: det2, inv2: inv2, mulMat2: mulMat2, combine: combine,
      eigen2: eigen2,
      VISUALIZABLE_OPS_2D: VISUALIZABLE_OPS_2D
    };
  }
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      OPS: OPS, parseLatexMatrix: parseLatexMatrix, detectOp: detectOp,
      solveFromLatex: solveFromLatex,
      canVisualize2D: canVisualize2D, eigen2: eigen2,
      transformPath: transformPath, unitSquare: unitSquare,
      det2: det2, inv2: inv2, mulMat2: mulMat2, combine: combine,
      cellsToNumericMatrix: cellsToNumericMatrix
    };
  }
})();
