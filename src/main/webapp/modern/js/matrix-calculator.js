/**
 * matrix-calculator.js — single controller for the unified Matrix Calculator.
 *
 * Covers 13 operations:
 *   Unary scalar:  determinant, trace, rank
 *   Unary matrix:  inverse, transpose, RREF
 *   Unary list:    eigenvalues, eigenvectors, characteristic polynomial
 *   Unary param:   power (A^n)
 *   Binary:        addition, subtraction, multiplication
 *
 * MathLive is the only input mechanism — matrices are entered as native
 * \begin{pmatrix} via <math-field>, navigation via Tab/arrows.  No custom
 * cell grid, no plain-text fallback.
 *
 * SymPy backend via /OneCompilerFunctionality (same pattern as the limit
 * + series + vector calc tools).  The controller assembles a Python
 * template per operation that:
 *   1. Parses the math-field LaTeX with sympy.parsing.latex.parse_latex
 *   2. Builds a Matrix object (and Matrix B / exponent n if relevant)
 *   3. Computes the operation, validating shapes/conditions
 *   4. Prints LATEX:, TEXT:, STEPS:[json] in the convention used by the
 *      sibling tools' renderers.
 *
 * Steps depth — operation-specific:
 *   tutorial:  hand-crafted didactic chain (cofactor expansion, augmented
 *              matrix Gauss-Jordan, det(A−λI)=0 → expand → solve)
 *   chain:     SymPy's intermediate symbolic chain (eigenvectors per λ,
 *              repeated multiplication for power, RREF row ops)
 *   simple:    just the result with a one-line explanation (transpose,
 *              trace, rank, charpoly, add, subtract)
 */
(function () {
    'use strict';

    /* ─────────────────────────────────────────────────────────────────
       Operation registry — declarative source of truth that drives the
       UI shape (which inputs to show), the validator, and the Python
       code generator.  Adding a 14th op = add a row here + a Python
       branch below + an example chip in the JSP.
       ───────────────────────────────────────────────────────────────── */
    var OPS = {
        determinant:  { label: 'det A',         binary: false, requireSquare: true,  needsExponent: false, steps: 'tutorial' },
        inverse:      { label: 'A\u207B\u00B9', binary: false, requireSquare: true,  needsExponent: false, steps: 'tutorial' },
        transpose:    { label: 'A\u1D40',       binary: false, requireSquare: false, needsExponent: false, steps: 'simple'   },
        trace:        { label: 'tr A',          binary: false, requireSquare: true,  needsExponent: false, steps: 'simple'   },
        rank:         { label: 'rank A',        binary: false, requireSquare: false, needsExponent: false, steps: 'simple'   },
        rref:         { label: 'RREF',          binary: false, requireSquare: false, needsExponent: false, steps: 'chain'    },
        power:        { label: 'A\u207F',       binary: false, requireSquare: true,  needsExponent: true,  steps: 'chain'    },
        eigenvalues:  { label: 'eigenvalues',   binary: false, requireSquare: true,  needsExponent: false, steps: 'tutorial' },
        eigenvectors: { label: 'eigenvectors',  binary: false, requireSquare: true,  needsExponent: false, steps: 'chain'    },
        charpoly:     { label: 'char. poly',    binary: false, requireSquare: true,  needsExponent: false, steps: 'simple'   },
        add:          { label: 'A + B',         binary: true,  requireSquare: false, needsExponent: false, steps: 'simple', sameDims: true },
        subtract:     { label: 'A \u2212 B',    binary: true,  requireSquare: false, needsExponent: false, steps: 'simple', sameDims: true },
        multiply:     { label: 'A \u00B7 B',    binary: true,  requireSquare: false, needsExponent: false, steps: 'tutorial', mulCompat: true }
    };

    var DEFAULT_OP = 'determinant';
    var MAX_SIZE = 8;     /* hard ceiling — beyond this, MathLive is unwieldy */
    var DEFAULT_SIZE = 3; /* both A and B start 3×3 */

    /* ─────────────────────────────────────────────────────────────────
       LaTeX matrix template helpers — used by size picker, reset, and
       the example chips.  All emit \begin{pmatrix}…\end{pmatrix} which
       MathLive renders natively as an editable matrix grid.
       ───────────────────────────────────────────────────────────────── */
    function emptyMatrixLatex(rows, cols) {
        var lines = [];
        for (var i = 0; i < rows; i++) {
            var cells = [];
            for (var j = 0; j < cols; j++) cells.push('0');
            lines.push(cells.join(' & '));
        }
        return '\\begin{pmatrix}' + lines.join('\\\\') + '\\end{pmatrix}';
    }

    function randomMatrixLatex(rows, cols) {
        var lines = [];
        for (var i = 0; i < rows; i++) {
            var cells = [];
            for (var j = 0; j < cols; j++) {
                /* small signed integers in [-5, 9] — friendly for hand-checking */
                cells.push(String(Math.floor(Math.random() * 15) - 5));
            }
            lines.push(cells.join(' & '));
        }
        return '\\begin{pmatrix}' + lines.join('\\\\') + '\\end{pmatrix}';
    }

    /* Parse a MathLive matrix LaTeX → JS array-of-arrays of cell
       strings.  We do the row/col split client-side rather than
       leaning on SymPy's parse_latex matrix support (which is
       inconsistent across versions, especially on the Lark backend).
       Each returned cell is a scalar LaTeX expression that SymPy can
       handle individually via parse_latex or sympify.
       Returns null if the LaTeX isn't a recognizable matrix. */
    function parseMatrixCells(latex) {
        if (!latex) return null;
        var m = latex.match(/\\begin\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}([\s\S]*?)\\end\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/);
        if (!m) return null;
        var body = m[1];
        /* Split rows on \\ but tolerate trailing/leading whitespace
           and the optional `\\[size]` row-spacing form MathLive can
           emit (`\\[2pt]`, `\\[1ex]`, …). */
        var rows = body.split(/\\\\(?:\s*\[[^\]]*\])?/);
        if (rows.length && rows[rows.length - 1].trim() === '') rows.pop();
        if (!rows.length) return null;
        var cells = rows.map(function (r) {
            return r.split('&').map(function (c) { return c.trim(); });
        });
        /* Pad short rows with "0" so all rows have equal length —
           MathLive sometimes emits ragged rows when the user adds a
           column to one row but not the others. */
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

    /* ─────────────────────────────────────────────────────────────────
       Symbolab-style operator detection.  Inspects a LaTeX expression
       for an operation token (prefix keyword, postfix suffix, or
       infix operator) and returns {op, latexA, latexB, n} when one is
       found.  Lets the user type a single self-describing expression
       (`\det A`, `A^{-1}`, `A B`, `gauss jordan A`, …) instead of
       relying on chip+B+exponent state.

       The function is non-destructive — it does NOT modify the input
       LaTeX or the math-field.  Callers that want the extracted form
       use the returned latexA/latexB/n; the user's typed form stays
       in the math-field intact.

       Returns null when no recognizable wrapper is found, in which
       case callers fall back to chip + B-field + exponent-input
       semantics.
       ───────────────────────────────────────────────────────────────── */
    /* Build a regex source that matches one balanced \begin{X}…\end{X}
       block for any of the standard matrix environments.  Used as a
       reusable subexpression below. */
    var MATRIX_RE_SRC =
        '\\\\begin\\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\\}' +
        '[\\s\\S]*?' +
        '\\\\end\\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\\}';

    /* Normalise Symbolab-style expressions: their `\:` `\,` `\;` `\!`
       spacing commands and any Unicode whitespace collapse to single
       ASCII spaces, so the structural regexes don't have to thread
       around them. */
    function normaliseExpression(s) {
        return (s || '')
            .replace(/\\[,;:!]/g, ' ')
            .replace(/[\u00A0\s]+/g, ' ')
            .trim();
    }

    /* Try every detection pattern in priority order.  First match
       wins; recursive descent (e.g. `\det` of a power) is intentionally
       NOT supported — keep the rules simple, fall back to chip mode
       for anything more elaborate. */
    function detectOpFromExpression(rawLatex) {
        var s = normaliseExpression(rawLatex);
        if (!s) return null;

        /* ── Prefix keyword + matrix ── */
        var prefixes = [
            { re: /^\\det\s+/i,                                                                  op: 'determinant'  },
            { re: /^(?:\\tr|tr|trace)\s+/i,                                                      op: 'trace'        },
            { re: /^rank\s+/i,                                                                   op: 'rank'         },
            { re: /^(?:rref|gauss[\s-]*jordan|reduced[\s-]*row[\s-]*echelon|row[\s-]*echelon)\s+/i, op: 'rref'      },
            { re: /^eigen\s*values?\s+/i,                                                        op: 'eigenvalues'  },
            { re: /^(?:eigen\s*vectors?|diagonali[sz]e)\s+/i,                                    op: 'eigenvectors' },
            { re: /^(?:char(?:acteristic)?\s*poly(?:nomial)?)\s+/i,                              op: 'charpoly'     }
        ];
        for (var i = 0; i < prefixes.length; i++) {
            var pm = s.match(prefixes[i].re);
            if (!pm) continue;
            var rest = s.slice(pm[0].length).trim();
            var bareMatrix = rest.match(new RegExp('^(' + MATRIX_RE_SRC + ')$'));
            if (bareMatrix) return { op: prefixes[i].op, latexA: bareMatrix[1] };
        }

        /* ── Suffix and infix patterns require finding a matrix at the
              start of the expression.  Capture it greedily-but-balanced
              by anchoring on \end{…} of the same environment. ── */
        var firstMatch = s.match(new RegExp('^(' + MATRIX_RE_SRC + ')([\\s\\S]*)$'));
        if (!firstMatch) return null;
        var matA = firstMatch[1];
        var tail = firstMatch[2].trim();

        if (!tail) return null; /* bare matrix → no operation, defer to chip */

        /* Suffix: ^{-1} → inverse */
        if (/^\^\s*\{?\s*-\s*1\s*\}?\s*$/.test(tail)) {
            return { op: 'inverse', latexA: matA };
        }
        /* Suffix: ^T or ^{T} → transpose */
        if (/^\^\s*\{?\s*T\s*\}?\s*$/.test(tail)) {
            return { op: 'transpose', latexA: matA };
        }
        /* Suffix: ^n (integer, possibly negative) → power.  n=-1 is
           handled by the inverse rule above; everything else (n=0, 1,
           ≥2, ≤-2) takes this branch and the SymPy backend handles
           the n<0 path via inversion. */
        var powMatch = tail.match(/^\^\s*\{?\s*(-?\d+)\s*\}?\s*$/);
        if (powMatch) {
            return { op: 'power', latexA: matA, n: parseInt(powMatch[1], 10) };
        }

        /* Infix: matrix [+|-|·|×|·|juxtaposition] matrix → add / sub /
           multiply.  Empty separator (juxtaposition) means multiply,
           matching standard linear-algebra notation. */
        var infixMatch = tail.match(new RegExp(
            '^\\s*([+\\-]|\\\\cdot|\\\\times|\\*)?\\s*(' + MATRIX_RE_SRC + ')\\s*$'
        ));
        if (infixMatch) {
            var sep = infixMatch[1] || '';
            var matB = infixMatch[2];
            var op =
                sep === '+'  ? 'add'      :
                sep === '-'  ? 'subtract' :
                               'multiply';
            return { op: op, latexA: matA, latexB: matB };
        }

        return null;
    }

    /* getEffective() — single source of truth for "what should we
       actually compute right now?".  Combines the detection pass with
       the chip / B-field / exponent fallback so calculate() and
       validate() share the same logic. */
    function getEffective() {
        var rawA = getLatex(els.matrixA);
        var detected = detectOpFromExpression(rawA);
        if (detected) {
            var def = OPS[detected.op];
            return {
                op: detected.op,
                latexA: detected.latexA,
                latexB: detected.latexB
                       || (def && def.binary ? getLatex(els.matrixB) : null),
                n: detected.n != null ? detected.n
                  : (def && def.needsExponent ? parseInt(els.exponent.value || '0', 10) : null),
                detected: true
            };
        }
        var def2 = OPS[currentOp];
        return {
            op: currentOp,
            latexA: rawA,
            latexB: def2 && def2.binary ? getLatex(els.matrixB) : null,
            n: def2 && def2.needsExponent ? parseInt(els.exponent.value || '0', 10) : null,
            detected: false
        };
    }

    /* ─────────────────────────────────────────────────────────────────
       DOM hooks — all IDs defined in matrix-calculator.jsp.  Cached at
       boot for hot-path access during op switches and calculate.
       ───────────────────────────────────────────────────────────────── */
    var els = {};
    function $(id) { return document.getElementById(id); }

    function cacheDom() {
        els.opChips        = document.querySelectorAll('.mc-op-chip');
        els.matrixA        = $('mc-matrix-a');
        els.matrixB        = $('mc-matrix-b');
        els.wrapB          = $('mc-wrap-b');
        els.sizeA          = $('mc-size-a');
        els.sizeB          = $('mc-size-b');
        els.resetA         = $('mc-reset-a');
        els.resetB         = $('mc-reset-b');
        els.randomA        = $('mc-random-a');
        els.randomB        = $('mc-random-b');
        els.wrapExp        = $('mc-wrap-exp');
        els.exponent       = $('mc-exponent');
        els.calculate      = $('mc-calculate-btn');
        els.warn           = $('mc-warn');
        els.exampleChips   = document.querySelectorAll('.mc-example-chip');
        els.outputTabs     = document.querySelectorAll('.mc-output-tab');
        els.panels         = document.querySelectorAll('.mc-panel');
        els.resultBody     = $('mc-result-content');
        els.stepsBody      = $('mc-steps-content');
        els.compilerIframe = $('mc-compiler-iframe');
    }

    /* ─────────────────────────────────────────────────────────────────
       Op switching — selects a chip, reshapes the UI (show/hide B and
       exponent inputs), and updates the URL deep-link.  Matrix A
       contents persist across switches by design.
       ───────────────────────────────────────────────────────────────── */
    var currentOp = DEFAULT_OP;

    function setOp(op) {
        if (!OPS[op]) op = DEFAULT_OP;
        currentOp = op;
        var def = OPS[op];

        els.opChips.forEach(function (c) {
            var active = c.getAttribute('data-op') === op;
            c.classList.toggle('active', active);
            c.setAttribute('aria-pressed', active ? 'true' : 'false');
        });

        if (els.wrapB) els.wrapB.style.display = def.binary ? '' : 'none';
        if (els.wrapExp) els.wrapExp.style.display = def.needsExponent ? '' : 'none';

        if (els.calculate) els.calculate.textContent = 'Calculate ' + def.label;

        try {
            var url = new URL(window.location.href);
            url.searchParams.set('op', op);
            window.history.replaceState({}, '', url);
        } catch (e) {}

        clearWarn();
        validate();
    }

    /* ─────────────────────────────────────────────────────────────────
       Matrix-field size + reset + random helpers.  Each math-field
       carries a `data-size="NxM"` attribute that the size picker uses.
       Resetting writes a fresh empty template; randomising fills with
       small integers.  Both go through the math-field's own setValue
       so MathLive renders them properly.
       ───────────────────────────────────────────────────────────────── */
    function applyMatrixLatex(mf, latex) {
        if (!mf || typeof mf.setValue !== 'function') return;
        /* Be explicit about the format — without it MathLive falls
           back to auto-detection and (on some versions) misinterprets
           ascii-math-shaped fragments inside cells.  We always emit
           LaTeX, so pin format. */
        try { mf.setValue(latex, { format: 'latex', silenceNotifications: false }); } catch (e) {}
    }

    function readSize(picker) {
        var v = (picker && picker.value) || '3x3';
        var parts = v.split('x');
        return {
            rows: Math.max(1, Math.min(MAX_SIZE, parseInt(parts[0], 10) || 3)),
            cols: Math.max(1, Math.min(MAX_SIZE, parseInt(parts[1], 10) || 3))
        };
    }

    function resetMatrix(mf, picker) {
        var s = readSize(picker);
        applyMatrixLatex(mf, emptyMatrixLatex(s.rows, s.cols));
    }

    function randomMatrix(mf, picker) {
        var s = readSize(picker);
        applyMatrixLatex(mf, randomMatrixLatex(s.rows, s.cols));
    }

    /* ─────────────────────────────────────────────────────────────────
       Validation — fast client-side dimension checks BEFORE we bother
       the SymPy backend.  Op-specific rules live in the OPS registry.
       ───────────────────────────────────────────────────────────────── */
    function getLatex(mf) {
        if (!mf) return '';
        try { return (mf.getValue ? mf.getValue('latex') : '') || ''; }
        catch (e) { return ''; }
    }

    function showWarn(msg) {
        if (!els.warn) return;
        els.warn.textContent = msg || '';
        els.warn.classList.toggle('show', !!msg);
    }
    function clearWarn() { showWarn(''); }

    /* Suppress validation noise during boot until MathLive has upgraded
       and seedInitialTemplates has filled the math-fields.  Otherwise
       the user sees an "Matrix A is empty or invalid" warning flash on
       page load, before the 3×3 zero template is rendered. */
    var BOOT_DONE = false;

    function validate() {
        if (!BOOT_DONE) return true;
        var eff = getEffective();
        var def = OPS[eff.op];
        if (!def) return false;
        var dimA = parseMatrixDims(eff.latexA);
        if (!dimA) {
            showWarn('Matrix A is empty or invalid.');
            return false;
        }
        if (def.requireSquare && dimA.rows !== dimA.cols) {
            showWarn('Matrix A must be square for ' + def.label + ' (got ' + dimA.rows + '\u00D7' + dimA.cols + ').');
            return false;
        }
        if (def.binary) {
            var dimB = parseMatrixDims(eff.latexB);
            if (!dimB) {
                showWarn('Matrix B is empty or invalid.');
                return false;
            }
            if (def.sameDims && (dimA.rows !== dimB.rows || dimA.cols !== dimB.cols)) {
                showWarn('A and B must have the same shape for ' + def.label + ' (A is ' + dimA.rows + '\u00D7' + dimA.cols + ', B is ' + dimB.rows + '\u00D7' + dimB.cols + ').');
                return false;
            }
            if (def.mulCompat && dimA.cols !== dimB.rows) {
                showWarn('For A\u00B7B, A\u2019s column count must equal B\u2019s row count (got ' + dimA.cols + ' vs ' + dimB.rows + ').');
                return false;
            }
        }
        if (def.needsExponent) {
            if (eff.n == null || isNaN(eff.n)) {
                showWarn('Enter an integer exponent n.');
                return false;
            }
        }
        clearWarn();
        return true;
    }

    /* ─────────────────────────────────────────────────────────────────
       Python code generator.  Assembles a single SymPy program tailored
       to the current operation.  All ops share a common preamble that
       parses the matrix LaTeX from MathLive and strips MathLive's
       \left/\right sizing decorations (parse_latex doesn't always
       handle those cleanly).
       ───────────────────────────────────────────────────────────────── */
    /* Turn a 2D array of cell-LaTeX strings into a Python list literal
       of doubly-quoted r-strings.  We avoid embedding a single \begin
       {pmatrix} blob into Python because parse_latex's matrix support
       is inconsistent across SymPy versions; building Matrix from a
       row-of-rows where each cell is parsed individually works
       reliably on every version that has parse_latex at all. */
    function cellsToPyList(cells) {
        if (!cells) return '[]';
        var rows = cells.map(function (row) {
            var parts = row.map(function (c) {
                /* Escape the cell for Python r-string. r-strings
                   accept any backslash literal but cannot end with a
                   single backslash and cannot contain the same quote
                   that delimits them.  We pick triple-double-quote
                   delimiters and replace any literal triple-quote in
                   the cell. */
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
        code += 'import json, re\n\n';
        /* _cell parses one matrix cell.  Empty cell → 0.  Try
           parse_latex first; fall back to sympify with light cleanup
           so plain numbers, fractions, and simple symbols still work
           even if parse_latex chokes (e.g. on the lark backend). */
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

    /* Per-op Python branches.  Each branch sets `result` to the SymPy
       expression and appends step dicts to `steps`.  The final block
       prints LATEX:, TEXT:, STEPS: in the convention used by the
       sibling tools.

       For tutorial-grade ops (det, inverse, eigenvalues, multiply) we
       emit explicit Python that walks the algorithm; for chain ops
       we let SymPy do the work and capture intermediates; for simple
       ops we just compute and emit a one-line "what we did" caption. */
    function buildPython(op, cellsA, cellsB, n) {
        var def = OPS[op];
        var py = pythonPreamble(cellsA, def.binary ? cellsB : null);

        py += 'try:\n';

        if (op === 'determinant') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Determinant requires a square matrix")\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    if A.rows == 1:\n';
            py += '        result = A[0,0]\n';
            py += '        steps.append({"title":"1\\u00d71 trivial case","latex":"\\\\det(A) = " + latex(result)})\n';
            py += '    elif A.rows == 2:\n';
            py += '        a,b,c,d = A[0,0],A[0,1],A[1,0],A[1,1]\n';
            py += '        steps.append({"title":"2\\u00d72 formula","latex":"\\\\det(A) = ad - bc"})\n';
            py += '        steps.append({"title":"Substitute","latex":"= (" + latex(a) + ")(" + latex(d) + ") - (" + latex(b) + ")(" + latex(c) + ")"})\n';
            py += '        result = simplify(a*d - b*c)\n';
            py += '        steps.append({"title":"Simplify","latex":"\\\\det(A) = " + latex(result)})\n';
            py += '    else:\n';
            py += '        steps.append({"title":"Cofactor expansion along row 1","latex":"\\\\det(A) = \\\\sum_{j=1}^{n} (-1)^{1+j} a_{1j} M_{1j}"})\n';
            py += '        terms = []\n';
            py += '        running = []\n';
            py += '        for j in range(A.cols):\n';
            py += '            sign = 1 if j % 2 == 0 else -1\n';
            py += '            entry = A[0,j]\n';
            py += '            minor_mat = A.minor_submatrix(0, j)\n';
            py += '            minor_val = minor_mat.det()\n';
            py += '            terms.append(sign * entry * minor_val)\n';
            py += '            running.append(("+" if sign>0 else "-") + " " + latex(entry) + " \\\\cdot " + latex(minor_val))\n';
            py += '        steps.append({"title":"Compute each minor","latex":" ".join(running).lstrip("+ ").strip()})\n';
            py += '        result = simplify(sum(terms))\n';
            py += '        steps.append({"title":"Sum and simplify","latex":"\\\\det(A) = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'inverse') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Inverse requires a square matrix")\n';
            py += '    detA = A.det()\n';
            py += '    if detA == 0:\n';
            py += '        raise ValueError("Matrix is singular (det = 0); no inverse exists")\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Determinant","latex":"\\\\det(A) = " + latex(detA)})\n';
            py += '    if A.rows <= 3:\n';
            py += '        cof = A.cofactor_matrix()\n';
            py += '        adj = cof.T\n';
            py += '        steps.append({"title":"Cofactor matrix","latex":"\\\\mathrm{cof}(A) = " + latex(cof)})\n';
            py += '        steps.append({"title":"Adjugate (transpose of cofactor)","latex":"\\\\mathrm{adj}(A) = " + latex(adj)})\n';
            py += '        result = adj / detA\n';
            py += '        result = simplify(result)\n';
            py += '        steps.append({"title":"Divide by det(A)","latex":"A^{-1} = \\\\frac{1}{\\\\det(A)}\\\\,\\\\mathrm{adj}(A) = " + latex(result)})\n';
            py += '    else:\n';
            py += '        aug = A.row_join(eye(A.rows))\n';
            py += '        steps.append({"title":"Augment with identity","latex":"[A \\\\mid I] = " + latex(aug)})\n';
            py += '        rref_mat, _ = aug.rref()\n';
            py += '        steps.append({"title":"Row-reduce to [I | A^{-1}]","latex":"\\\\mathrm{RREF} = " + latex(rref_mat)})\n';
            py += '        result = rref_mat[:, A.cols:]\n';
            py += '        result = simplify(result)\n';
            py += '        steps.append({"title":"Right block is A^{-1}","latex":"A^{-1} = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'transpose') {
            py += '    result = A.T\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Swap rows and columns","latex":"A^T_{ij} = A_{ji}"})\n';
            py += '    steps.append({"title":"Result","latex":"A^T = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'trace') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Trace requires a square matrix")\n';
            py += '    diag_terms = [A[i,i] for i in range(A.rows)]\n';
            py += '    result = sum(diag_terms)\n';
            /* Use Add(*diag, evaluate=False) so SymPy formats negative
               diagonal entries as `1 - 2 + 3` rather than concatenating
               via " + ".join which produces `1 + -2 + 3`. */
            py += '    diag_sum_unsim = Add(*diag_terms, evaluate=False)\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Sum of the main diagonal","latex":"\\\\mathrm{tr}(A) = " + latex(diag_sum_unsim)})\n';
            py += '    steps.append({"title":"Result","latex":"\\\\mathrm{tr}(A) = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'rank') {
            py += '    rref_mat, pivots = A.rref()\n';
            py += '    result = len(pivots)\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Row-reduced echelon form","latex":"\\\\mathrm{RREF}(A) = " + latex(rref_mat)})\n';
            py += '    steps.append({"title":"Rank = number of pivot columns","latex":"\\\\mathrm{rank}(A) = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'rref') {
            py += '    rref_mat, pivots = A.rref()\n';
            py += '    result = rref_mat\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Apply Gauss-Jordan elimination","latex":"\\\\text{Pivot columns: } " + str(list(pivots))})\n';
            py += '    steps.append({"title":"Reduced row echelon form","latex":"\\\\mathrm{RREF}(A) = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'power') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("A^n requires a square matrix")\n';
            py += '    n = ' + (parseInt(n, 10) || 0) + '\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    if n == 0:\n';
            py += '        result = eye(A.rows)\n';
            py += '        steps.append({"title":"A^0 = I","latex":"A^0 = " + latex(result)})\n';
            py += '    elif n == 1:\n';
            py += '        result = A\n';
            py += '        steps.append({"title":"A^1 = A","latex":"A^1 = " + latex(result)})\n';
            py += '    elif n < 0:\n';
            py += '        if A.det() == 0:\n';
            py += '            raise ValueError("Negative powers require an invertible matrix")\n';
            py += '        Ainv = A.inv()\n';
            py += '        steps.append({"title":"Negative power: invert A first","latex":"A^{-1} = " + latex(Ainv)})\n';
            py += '        result = Ainv ** abs(n)\n';
            py += '        steps.append({"title":"Raise A^{-1} to |n|","latex":"A^{" + str(n) + "} = " + latex(result)})\n';
            py += '    else:\n';
            /* Cap step generation at MAX_POWER_STEPS frames to keep the
               Steps panel scannable.  For n > 6 we emit the first ~3
               frames, an ellipsis placeholder, the previous frame, and
               the final result.  The numeric answer is still exact —
               only the printed step list is summarised. */
            py += '        MAX_POWER_STEPS = 6\n';
            py += '        cur = A\n';
            py += '        if n <= MAX_POWER_STEPS:\n';
            py += '            for k in range(2, n+1):\n';
            py += '                nxt = cur * A\n';
            py += '                steps.append({"title":"A^"+str(k),"latex":"A^{"+str(k-1)+"}\\\\cdot A = " + latex(nxt)})\n';
            py += '                cur = nxt\n';
            py += '        else:\n';
            /* Show A^2..A^4 in detail, then ellipsis, then last few. */
            py += '            for k in range(2, 5):\n';
            py += '                nxt = cur * A\n';
            py += '                steps.append({"title":"A^"+str(k),"latex":"A^{"+str(k-1)+"}\\\\cdot A = " + latex(nxt)})\n';
            py += '                cur = nxt\n';
            py += '            steps.append({"title":"\\u22EE","latex":"\\\\text{(continuing similarly through } A^{" + str(n-1) + "} \\\\text{)}"})\n';
            py += '            cur = A ** n\n';
            py += '            steps.append({"title":"A^"+str(n),"latex":"A^{"+str(n)+"} = " + latex(cur)})\n';
            py += '        result = cur\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'eigenvalues') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Eigenvalues require a square matrix")\n';
            py += '    lam = symbols("lambda")\n';
            py += '    char_mat = A - lam*eye(A.rows)\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Form A - \\\\lambda I","latex":"A - \\\\lambda I = " + latex(char_mat)})\n';
            py += '    char_poly = char_mat.det()\n';
            py += '    char_poly_expanded = expand(char_poly)\n';
            py += '    steps.append({"title":"Characteristic polynomial","latex":"\\\\det(A - \\\\lambda I) = " + latex(char_poly_expanded)})\n';
            py += '    steps.append({"title":"Set characteristic polynomial = 0","latex":latex(char_poly_expanded) + " = 0"})\n';
            py += '    eigs = A.eigenvals()\n';
            py += '    eig_list = list(eigs.items())\n';
            py += '    if not eig_list:\n';
            py += '        raise ValueError("SymPy could not find closed-form eigenvalues for this matrix")\n';
            py += '    parts = []\n';
            py += '    for v, mult in eig_list:\n';
            py += '        parts.append(latex(v) + (" \\\\,(\\\\text{mult. " + str(mult) + "})" if mult > 1 else ""))\n';
            py += '    steps.append({"title":"Solve for \\\\lambda","latex":"\\\\lambda = " + ", \\\\;".join(parts)})\n';
            py += '    result_text = ", ".join(str(v) + ("^" + str(mult) if mult>1 else "") for v,mult in eig_list)\n';
            py += '    print("LATEX:" + ", \\\\;".join(parts))\n';
            py += '    print("TEXT:" + result_text)\n';

        } else if (op === 'eigenvectors') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Eigenvectors require a square matrix")\n';
            py += '    lam = symbols("lambda")\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            /* Show characteristic polynomial first so the user sees
               WHERE the eigenvalues come from before we use them. */
            py += '    char_mat0 = A - lam*eye(A.rows)\n';
            py += '    char_poly0 = expand((char_mat0).det())\n';
            py += '    steps.append({"title":"Characteristic polynomial","latex":"\\\\det(A - \\\\lambda I) = " + latex(char_poly0) + " = 0"})\n';
            py += '    eig_data = A.eigenvects()\n';
            py += '    out_parts = []\n';
            py += '    for val, mult, vects in eig_data:\n';
            py += '        steps.append({"title":"Eigenvalue \\\\lambda = " + latex(val),"latex":"\\\\lambda = " + latex(val) + " \\\\;\\\\text{(algebraic mult. " + str(mult) + ")}"})\n';
            /* Show (A - λI), its RREF, and how the free-variable
               parameterisation gives the eigenvector(s).  This is the
               textbook derivation a teacher expects to see — instead
               of just stating the answer. */
            py += '        AmlI = A - val*eye(A.rows)\n';
            py += '        steps.append({"title":"Form (A - \\\\lambda I) for \\\\lambda = " + latex(val),"latex":"A - (" + latex(val) + ") I = " + latex(AmlI)})\n';
            py += '        try:\n';
            py += '            rref_mat, _piv = AmlI.rref()\n';
            py += '            steps.append({"title":"Row-reduce (solve (A-\\\\lambda I) v = 0)","latex":"\\\\mathrm{RREF} = " + latex(rref_mat)})\n';
            py += '        except Exception:\n';
            py += '            pass\n';
            py += '        for k, v in enumerate(vects, 1):\n';
            py += '            steps.append({"title":"Eigenvector " + str(k) + " for \\\\lambda = " + latex(val),"latex":"v_{" + str(k) + "} = " + latex(v)})\n';
            py += '            out_parts.append("\\\\lambda = " + latex(val) + ":\\\\; v = " + latex(v))\n';
            py += '    result_latex = " \\\\\\\\ ".join(out_parts)\n';
            py += '    print("LATEX:" + result_latex)\n';
            py += '    print("TEXT:" + str(eig_data))\n';

        } else if (op === 'charpoly') {
            py += '    if A.rows != A.cols:\n';
            py += '        raise ValueError("Characteristic polynomial requires a square matrix")\n';
            py += '    lam = symbols("lambda")\n';
            py += '    poly = A.charpoly(lam).as_expr()\n';
            py += '    steps.append({"title":"Matrix","latex":"A = " + latex(A)})\n';
            py += '    steps.append({"title":"Characteristic polynomial","latex":"p(\\\\lambda) = \\\\det(A - \\\\lambda I) = " + latex(poly)})\n';
            py += '    result = poly\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'add') {
            py += '    if A.shape != B.shape:\n';
            py += '        raise ValueError("A + B requires same shape")\n';
            py += '    result = A + B\n';
            py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + ", \\\\quad B = " + latex(B)})\n';
            py += '    steps.append({"title":"Element-wise sum","latex":"(A+B)_{ij} = A_{ij} + B_{ij}"})\n';
            py += '    steps.append({"title":"Result","latex":"A + B = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'subtract') {
            py += '    if A.shape != B.shape:\n';
            py += '        raise ValueError("A - B requires same shape")\n';
            py += '    result = A - B\n';
            py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + ", \\\\quad B = " + latex(B)})\n';
            py += '    steps.append({"title":"Element-wise difference","latex":"(A-B)_{ij} = A_{ij} - B_{ij}"})\n';
            py += '    steps.append({"title":"Result","latex":"A - B = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else if (op === 'multiply') {
            py += '    if A.cols != B.rows:\n';
            py += '        raise ValueError("A.cols must equal B.rows for multiplication")\n';
            py += '    result = A * B\n';
            py += '    steps.append({"title":"Matrices","latex":"A = " + latex(A) + " \\\\;(" + str(A.rows) + "\\\\times" + str(A.cols) + "), \\\\quad B = " + latex(B) + " \\\\;(" + str(B.rows) + "\\\\times" + str(B.cols) + ")"})\n';
            py += '    steps.append({"title":"Definition","latex":"(AB)_{ij} = \\\\sum_{k} A_{ik}B_{kj}"})\n';
            py += '    if A.rows*B.cols <= 9:\n';
            py += '        for i in range(A.rows):\n';
            py += '            for j in range(B.cols):\n';
            py += '                terms = []\n';
            py += '                for k in range(A.cols):\n';
            py += '                    terms.append("(" + latex(A[i,k]) + ")(" + latex(B[k,j]) + ")")\n';
            py += '                steps.append({"title":"Entry ("+str(i+1)+","+str(j+1)+")","latex":"(AB)_{" + str(i+1) + str(j+1) + "} = " + " + ".join(terms) + " = " + latex(result[i,j])})\n';
            py += '    steps.append({"title":"Result","latex":"AB = " + latex(result)})\n';
            py += '    print("LATEX:" + latex(result))\n';
            py += '    print("TEXT:" + str(result))\n';

        } else {
            py += '    raise ValueError("Unknown operation: ' + op + '")\n';
        }

        py += '    print("STEPS:" + json.dumps(steps))\n';
        py += 'except Exception as e:\n';
        py += '    print("ERROR:" + str(e))\n';

        return py;
    }

    /* ─────────────────────────────────────────────────────────────────
       Calculate — assemble Python, POST to OneCompiler, parse the
       LATEX:/TEXT:/STEPS: output, render Result and Steps tabs.
       ───────────────────────────────────────────────────────────────── */
    var BUSY = false;
    var SAFETY_TIMER = null;
    var lastPageResult = null;

    function lock() {
        if (BUSY) return false;
        BUSY = true;
        if (els.calculate) els.calculate.classList.add('is-busy');
        SAFETY_TIMER = setTimeout(unlock, 30000);
        return true;
    }
    function unlock() {
        BUSY = false;
        if (els.calculate) els.calculate.classList.remove('is-busy');
        if (SAFETY_TIMER) { clearTimeout(SAFETY_TIMER); SAFETY_TIMER = null; }
    }

    function calculate() {
        if (BUSY) return;
        if (!validate()) return;
        if (!lock()) return;

        var eff = getEffective();
        var cellsA = parseMatrixCells(eff.latexA);
        var cellsB = OPS[eff.op].binary ? parseMatrixCells(eff.latexB) : null;
        var n = OPS[eff.op].needsExponent ? eff.n : null;
        var code = buildPython(eff.op, cellsA, cellsB, n);

        renderResultLoading();
        updatePythonTab(code);

        var ctx = (window.__MC_CTX || '');
        fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (stdout.indexOf('ERROR:') === 0) {
                renderResultError(stdout.replace(/^ERROR:/, ''));
                return;
            }
            if (!stdout && stderr) {
                renderResultError(stderr.split('\n').pop() || 'Solver error');
                return;
            }
            if (!stdout) {
                renderResultError('No result from solver');
                return;
            }

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            /* GREEDY (no `?` quantifier) — the inner JSON contains `]`
               characters when steps embed Python list reprs (rank /
               RREF emit `[0, 1, 2]` for pivot columns).  A lazy match
               stops at the first inner `]` and produces malformed JSON.
               STEPS: is always the last line printed, so a greedy
               match safely lands on the outer closing bracket. */
            var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*\])(?:\n|$)/);
            var resultLatex = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultLatex;
            var stepsArr = [];
            if (stepsMatch) {
                try { stepsArr = JSON.parse(stepsMatch[1]); } catch (e) {}
            }

            renderResult(resultLatex, resultText);
            renderSteps(stepsArr);
            lastPageResult = {
                op: eff.op,
                resultLatex: resultLatex,
                resultText: resultText
            };
            /* Visualize tab is always present.  Render whatever we can
               for the current op; the function shows a friendly "not
               available" message when canVisualize() returns false. */
            try { renderVisualization(eff.op, cellsA, cellsB, n); } catch (e) {}
        })
        .catch(function (err) {
            renderResultError((err && err.message) || 'Network error');
        })
        .finally(unlock);
    }

    /* ─────────────────────────────────────────────────────────────────
       Result + Steps + Python tab renderers.
       ───────────────────────────────────────────────────────────────── */
    function renderResultLoading() {
        if (els.resultBody) els.resultBody.innerHTML = '<div class="mc-spinner" aria-label="Computing"></div>';
        if (els.stepsBody) els.stepsBody.innerHTML = '<div class="mc-spinner" aria-label="Computing"></div>';
    }

    function renderResult(latexStr, textStr) {
        if (!els.resultBody) return;
        if (!latexStr && !textStr) {
            els.resultBody.innerHTML = '<div class="mc-empty">No result.</div>';
            return;
        }
        var html = '<div class="mc-result-tex" id="mc-result-tex"></div>';
        html += '<div class="mc-result-text" id="mc-result-text">' + (textStr || '').replace(/</g, '&lt;') + '</div>';
        html += '<div class="mc-result-actions">';
        html += '  <button type="button" class="mc-action-btn" id="mc-copy-latex">Copy LaTeX</button>';
        html += '  <button type="button" class="mc-action-btn" id="mc-copy-text">Copy text</button>';
        html += '</div>';
        els.resultBody.innerHTML = html;

        /* `latexStr` is already KaTeX-ready: `r.json()` unwrapped the
           OneCompiler servlet's JSON layer, and the LATEX: line was
           printed verbatim by Python (single-backslash for control
           sequences, double-backslash for matrix row separators).
           Don't apply replace(/\\\\/g, '\\') — that destroys the
           matrix row separators and turns matrices into a single
           line of run-on numbers. */
        var el = document.getElementById('mc-result-tex');
        if (window.katex && el) {
            try { katex.render(latexStr, el, { throwOnError: false, displayMode: true }); }
            catch (e) { el.textContent = latexStr; }
        } else if (el) {
            el.textContent = latexStr;
        }

        var copyL = document.getElementById('mc-copy-latex');
        if (copyL) copyL.addEventListener('click', function () { copyTo(latexStr || ''); });
        var copyT = document.getElementById('mc-copy-text');
        if (copyT) copyT.addEventListener('click', function () { copyTo(textStr || ''); });
    }

    function renderResultError(msg) {
        if (!els.resultBody) return;
        els.resultBody.innerHTML = '<div class="mc-error">' + (msg || 'Error').replace(/</g, '&lt;') + '</div>';
        if (els.stepsBody) els.stepsBody.innerHTML = '<div class="mc-empty">No steps available.</div>';
    }

    function renderSteps(steps) {
        if (!els.stepsBody) return;
        if (!steps || !steps.length) {
            els.stepsBody.innerHTML = '<div class="mc-empty">No steps available for this operation.</div>';
            return;
        }
        var html = '<ol class="mc-steps">';
        steps.forEach(function (s, i) {
            var stepId = 'mc-step-' + i;
            html += '<li class="mc-step">';
            html += '  <div class="mc-step-title">' + (s.title || '').replace(/</g, '&lt;') + '</div>';
            html += '  <div class="mc-step-tex" id="' + stepId + '" data-step-tex="' + (s.latex || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;') + '"></div>';
            html += '</li>';
        });
        html += '</ol>';
        els.stepsBody.innerHTML = html;

        if (window.katex) {
            /* Same reasoning as renderResult — JSON.parse on the STEPS
               array already converted the JSON-escaped \\\\ pairs to
               \\, leaving matrix row separators intact and control
               sequences as single backslashes.  No further de-escape
               needed. */
            els.stepsBody.querySelectorAll('[data-step-tex]').forEach(function (el) {
                var raw = el.getAttribute('data-step-tex');
                try { katex.render(raw, el, { throwOnError: false, displayMode: true }); }
                catch (e) { el.textContent = raw; }
            });
        }
    }

    function updatePythonTab(code) {
        if (!els.compilerIframe) return;
        /* onecompiler-embed.jsp expects ?c=<URL-encoded JSON> where JSON
           is {lang, code} with code base64-encoded.  Same envelope used
           by limit / integral / derivative tools. */
        var b64;
        try { b64 = btoa(unescape(encodeURIComponent(code))); }
        catch (e) { return; }
        var config = JSON.stringify({ lang: 'python', code: b64 });
        var ctx = (window.__MC_CTX || '');
        els.compilerIframe.src = ctx + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    function copyTo(text) {
        if (!text) return;
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function () {
                if (window.toolUtils && window.toolUtils.toast) window.toolUtils.toast('Copied');
            }, function () {});
        }
    }

    /* ─────────────────────────────────────────────────────────────────
       Visualize — geometric overlay of the matrix transformation.

       Strategy: every linear map A: R^n → R^n acts on the unit cube
       (or unit square for n=2).  By plotting the image of the unit
       hypercube under A (and B, and AB, etc., depending on the op)
       we give the user an immediate geometric read on what the matrix
       does.  Det = signed area / signed volume, eigenvectors = fixed
       directions, A·B = composition, etc.

       Scope (intentionally narrow — wider visualizations get noisy):
         · 2D supported ops:  det, inverse, transpose, eigenvectors,
                              power, multiply, add, subtract
         · 3D supported ops:  det, inverse, transpose, multiply, add,
                              subtract, power
         · Eigenvectors 3D:   skipped (real eigenvectors of a generic
                              3×3 matrix is a per-case affair; we'd
                              rather show nothing than a misleading
                              picture)
         · Non-square / 4×4+ / non-numeric / unsupported op: friendly
           "not available" message with the rules spelled out.
       ───────────────────────────────────────────────────────────────── */
    var VISUALIZABLE_OPS = ['determinant', 'inverse', 'transpose', 'eigenvectors',
                            'power', 'multiply', 'add', 'subtract'];

    /* Strict numeric check on a cell — rejects symbolic content even
       if parseFloat would extract a leading number.  We need EVERY
       cell to be a finite number for the geometric viz to make sense. */
    function isNumericCells(cells) {
        if (!cells || !cells.length) return false;
        var numRe = /^-?\d*\.?\d+(?:[eE][+-]?\d+)?$/;
        for (var i = 0; i < cells.length; i++) {
            var row = cells[i];
            if (!row || !row.length) return false;
            for (var j = 0; j < row.length; j++) {
                var s = (row[j] || '').trim();
                if (!numRe.test(s)) return false;
                var v = parseFloat(s);
                if (!isFinite(v)) return false;
            }
        }
        return true;
    }

    function canVisualize(op, cellsA, cellsB) {
        if (VISUALIZABLE_OPS.indexOf(op) === -1) return false;
        if (!cellsA) return false;
        var rows = cellsA.length;
        var cols = cellsA[0] ? cellsA[0].length : 0;
        if (rows !== cols) return false;
        if (rows !== 2 && rows !== 3) return false;
        if (op === 'eigenvectors' && rows === 3) return false; /* 3D eig viz is too case-dependent */
        if (!isNumericCells(cellsA)) return false;
        if (OPS[op].binary) {
            if (!cellsB || !isNumericCells(cellsB)) return false;
            if (cellsB.length !== rows || cellsB[0].length !== cols) return false;
        }
        return true;
    }

    function cellsToMatrix(cells) {
        return cells.map(function (row) {
            return row.map(function (c) { return parseFloat(c); });
        });
    }

    function applyMat(M, vec) {
        var n = M.length;
        var out = new Array(n);
        for (var i = 0; i < n; i++) {
            var s = 0;
            for (var j = 0; j < n; j++) s += M[i][j] * vec[j];
            out[i] = s;
        }
        return out;
    }
    function transformPath(M, path) { return path.map(function (p) { return applyMat(M, p); }); }
    function unitSquare()           { return [[0,0],[1,0],[1,1],[0,1],[0,0]]; }
    function unitCubeVerts()        {
        return [[0,0,0],[1,0,0],[1,1,0],[0,1,0],
                [0,0,1],[1,0,1],[1,1,1],[0,1,1]];
    }
    var CUBE_FACES = [
        [0,1,2],[0,2,3],   /* bottom z=0 */
        [4,5,6],[4,6,7],   /* top    z=1 */
        [0,1,5],[0,5,4],   /* front  y=0 */
        [3,2,6],[3,6,7],   /* back   y=1 */
        [1,2,6],[1,6,5],   /* right  x=1 */
        [0,3,7],[0,7,4]    /* left   x=0 */
    ];
    var CUBE_EDGES = [
        [0,1],[1,2],[2,3],[3,0],
        [4,5],[5,6],[6,7],[7,4],
        [0,4],[1,5],[2,6],[3,7]
    ];

    function det2(M) { return M[0][0]*M[1][1] - M[0][1]*M[1][0]; }
    function det3(M) {
        return M[0][0]*(M[1][1]*M[2][2] - M[1][2]*M[2][1])
             - M[0][1]*(M[1][0]*M[2][2] - M[1][2]*M[2][0])
             + M[0][2]*(M[1][0]*M[2][1] - M[1][1]*M[2][0]);
    }
    function inv2(M) {
        var d = det2(M);
        if (Math.abs(d) < 1e-12) return null;
        return [
            [ M[1][1]/d, -M[0][1]/d],
            [-M[1][0]/d,  M[0][0]/d]
        ];
    }
    function inv3(M) {
        var d = det3(M);
        if (Math.abs(d) < 1e-12) return null;
        var c = function (i, j) {
            /* cofactor: (-1)^(i+j) * det of 2×2 minor */
            var rs = [0,1,2].filter(function (r) { return r !== i; });
            var cs = [0,1,2].filter(function (s) { return s !== j; });
            var m = [[M[rs[0]][cs[0]], M[rs[0]][cs[1]]],
                     [M[rs[1]][cs[0]], M[rs[1]][cs[1]]]];
            return ((i+j) % 2 === 0 ? 1 : -1) * det2(m);
        };
        /* inverse = adjugate / det = transpose(cofactor) / det */
        var out = [[0,0,0],[0,0,0],[0,0,0]];
        for (var i = 0; i < 3; i++)
            for (var j = 0; j < 3; j++)
                out[i][j] = c(j, i) / d;
        return out;
    }
    function combine(A, B, op) {
        var n = A.length, C = [];
        for (var i = 0; i < n; i++) {
            var r = [];
            for (var j = 0; j < n; j++) {
                r.push(op === 'add' ? A[i][j] + B[i][j] : A[i][j] - B[i][j]);
            }
            C.push(r);
        }
        return C;
    }

    /* Eigenvectors of a real 2×2 matrix.  Returns null when eigenvalues
       are complex (we don't draw imaginary directions on a real plane).
       Normalized to unit length so the arrows compare visually. */
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

    /* ── 2D Plotly trace builders ── */
    var COLORS = {
        unit:    '#94a3b8',
        primary: '#15803d',
        flip:    '#dc2626',     /* used when det < 0 — orientation reversed */
        b:       '#0891b2',
        sum:     '#7c3aed',
        eig1:    '#ea580c',
        eig2:    '#0891b2'
    };

    function trace2DPath(path, name, color, opts) {
        opts = opts || {};
        return {
            x: path.map(function (p) { return p[0]; }),
            y: path.map(function (p) { return p[1]; }),
            mode: 'lines',
            name: name,
            line: { color: color, width: opts.width || 3, dash: opts.dash || 'solid' },
            fill: opts.nofill ? 'none' : 'toself',
            fillcolor: opts.fill || (color + '33'),  /* trailing 33 = ~20% alpha hex */
            hoverinfo: 'name'
        };
    }
    function trace2DArrow(p0, p1, name, color) {
        return {
            x: [p0[0], p1[0]], y: [p0[1], p1[1]],
            mode: 'lines+markers', name: name,
            line: { color: color, width: 4 },
            marker: { size: [0, 12], color: color, symbol: 'arrow', angleref: 'previous' },
            hoverinfo: 'name'
        };
    }

    function build2DTraces(op, A, B, n) {
        var sq = unitSquare();
        var traces = [];
        traces.push(trace2DPath(sq, 'Unit square', COLORS.unit, { dash: 'dot', width: 2, fill: 'rgba(148,163,184,0.10)' }));

        if (op === 'determinant' || op === 'transpose' || op === 'eigenvectors') {
            var Asq = transformPath(A, sq);
            var d = det2(A);
            var primary = (op === 'determinant' && d < 0) ? COLORS.flip : COLORS.primary;
            traces.push(trace2DPath(Asq, op === 'transpose' ? 'A applied' : 'A applied',
                primary, { fill: primary + '40' }));

            if (op === 'transpose') {
                var At = [[A[0][0], A[1][0]], [A[0][1], A[1][1]]];
                var Atsq = transformPath(At, sq);
                traces.push(trace2DPath(Atsq, 'A^T applied', COLORS.b,
                    { dash: 'dash', fill: COLORS.b + '30' }));
            }
            if (op === 'eigenvectors') {
                var eig = eigen2(A);
                if (eig) {
                    eig.vectors.forEach(function (v, i) {
                        var color = i === 0 ? COLORS.eig1 : COLORS.eig2;
                        var lam = eig.values[i];
                        traces.push(trace2DArrow([0,0], [v[0]*1.5, v[1]*1.5],
                            'v' + (i+1) + '  (\u03BB = ' + lam.toFixed(2) + ')', color));
                        /* A·v = λ·v — draw the image as a translucent arrow
                           in the same direction (or opposite if λ<0) so the
                           user SEES that eigenvectors don't rotate. */
                        var avx = v[0]*lam*1.5, avy = v[1]*lam*1.5;
                        traces.push({
                            x: [0, avx], y: [0, avy],
                            mode: 'lines', name: 'A v' + (i+1) + ' = \u03BB v' + (i+1),
                            line: { color: color, width: 2, dash: 'dot' },
                            hoverinfo: 'name', showlegend: false
                        });
                    });
                } else {
                    /* Complex eigenvalues — no real direction to draw.
                       Annotate at the origin so the user understands
                       why no arrows appear (instead of silently dropping
                       them like the previous version did). */
                    traces.push({
                        x: [0], y: [0],
                        mode: 'text',
                        text: ['\u00A0\u00A0\u00A0\u00A0(complex eigenvalues — no real eigenvectors to draw)'],
                        textposition: 'middle right',
                        textfont: { size: 12, color: COLORS.flip },
                        name: 'Complex eigenvalues',
                        hoverinfo: 'text',
                        showlegend: false
                    });
                }
            }
        }
        else if (op === 'inverse') {
            var Asq2 = transformPath(A, sq);
            traces.push(trace2DPath(Asq2, 'A applied', COLORS.primary,
                { fill: COLORS.primary + '40' }));
            var Ainv = inv2(A);
            if (Ainv) {
                var AinvSq = transformPath(Ainv, sq);
                traces.push(trace2DPath(AinvSq, 'A^{-1} applied', COLORS.flip,
                    { dash: 'dash', fill: COLORS.flip + '20' }));
            }
        }
        else if (op === 'multiply') {
            var Bsq = transformPath(B, sq);
            traces.push(trace2DPath(Bsq, 'B applied', COLORS.b,
                { dash: 'dash', fill: COLORS.b + '30' }));
            var ABsq = transformPath(A, Bsq);
            traces.push(trace2DPath(ABsq, '(A B) applied', COLORS.primary,
                { fill: COLORS.primary + '40' }));
        }
        else if (op === 'add' || op === 'subtract') {
            var Asq3 = transformPath(A, sq);
            var Bsq3 = transformPath(B, sq);
            var Csq3 = transformPath(combine(A, B, op), sq);
            traces.push(trace2DPath(Asq3, 'A applied',         COLORS.primary, { width: 2, fill: COLORS.primary + '20' }));
            traces.push(trace2DPath(Bsq3, 'B applied',         COLORS.b,       { width: 2, fill: COLORS.b + '20' }));
            traces.push(trace2DPath(Csq3, (op === 'add' ? '(A+B)' : '(A\u2212B)') + ' applied',
                COLORS.sum, { width: 3, fill: COLORS.sum + '40' }));
        }
        else if (op === 'power') {
            /* Cap at 4 frames — beyond that the parallelograms either
               explode off the chart or collapse to a point.  Symbolic
               cap, not a feature limit; user still gets the right
               numeric result, just bounded visualization. */
            var k, current = sq.slice(), absN = Math.min(Math.abs(n || 0), 4);
            for (k = 1; k <= absN; k++) {
                current = transformPath(A, current);
                var alpha = Math.round((0.18 + (k / absN) * 0.30) * 255).toString(16).padStart(2, '0');
                traces.push(trace2DPath(current, 'A^' + k + ' applied',
                    COLORS.primary, { width: 2 + Math.min(k, 2), fill: COLORS.primary + alpha }));
            }
            if (absN === 0) {
                traces.push(trace2DPath(sq, 'A^0 = I (= unit square)', COLORS.primary, { fill: COLORS.primary + '40' }));
            }
        }
        return traces;
    }

    function layout2D() {
        return {
            autosize: true,
            margin: { l: 40, r: 20, t: 30, b: 50 },
            xaxis: {
                scaleanchor: 'y', scaleratio: 1,
                zeroline: true, zerolinecolor: '#cbd5e1', zerolinewidth: 1,
                gridcolor: '#e2e8f0'
            },
            yaxis: {
                zeroline: true, zerolinecolor: '#cbd5e1', zerolinewidth: 1,
                gridcolor: '#e2e8f0'
            },
            showlegend: true,
            legend: { orientation: 'h', y: -0.12 },
            hovermode: 'closest',
            plot_bgcolor: '#ffffff',
            paper_bgcolor: 'transparent'
        };
    }

    /* ── 3D Plotly trace builders ── */
    function transformedCube(M) {
        return unitCubeVerts().map(function (v) { return applyMat(M, v); });
    }
    function trace3DMesh(verts, name, color, opacity) {
        return {
            type: 'mesh3d',
            x: verts.map(function (v) { return v[0]; }),
            y: verts.map(function (v) { return v[1]; }),
            z: verts.map(function (v) { return v[2]; }),
            i: CUBE_FACES.map(function (f) { return f[0]; }),
            j: CUBE_FACES.map(function (f) { return f[1]; }),
            k: CUBE_FACES.map(function (f) { return f[2]; }),
            opacity: opacity, color: color,
            name: name, showlegend: true, hoverinfo: 'name', flatshading: true
        };
    }
    function trace3DEdges(verts, color) {
        var xs = [], ys = [], zs = [];
        CUBE_EDGES.forEach(function (e) {
            xs.push(verts[e[0]][0], verts[e[1]][0], null);
            ys.push(verts[e[0]][1], verts[e[1]][1], null);
            zs.push(verts[e[0]][2], verts[e[1]][2], null);
        });
        return {
            type: 'scatter3d', mode: 'lines',
            x: xs, y: ys, z: zs,
            line: { color: color, width: 4 },
            showlegend: false, hoverinfo: 'skip'
        };
    }

    function build3DTraces(op, A, B, n) {
        var verts0 = unitCubeVerts();
        var traces = [];
        traces.push(trace3DMesh(verts0, 'Unit cube', COLORS.unit, 0.10));
        traces.push(trace3DEdges(verts0, COLORS.unit));

        if (op === 'determinant' || op === 'transpose') {
            var At = transformedCube(A);
            var primary = (op === 'determinant' && det3(A) < 0) ? COLORS.flip : COLORS.primary;
            traces.push(trace3DMesh(At, 'A applied', primary, 0.30));
            traces.push(trace3DEdges(At, primary));
            if (op === 'transpose') {
                var Atrans = [[A[0][0],A[1][0],A[2][0]],
                              [A[0][1],A[1][1],A[2][1]],
                              [A[0][2],A[1][2],A[2][2]]];
                var Att = transformedCube(Atrans);
                traces.push(trace3DMesh(Att, 'A^T applied', COLORS.b, 0.20));
                traces.push(trace3DEdges(Att, COLORS.b));
            }
        }
        else if (op === 'inverse') {
            var At2 = transformedCube(A);
            traces.push(trace3DMesh(At2, 'A applied', COLORS.primary, 0.25));
            traces.push(trace3DEdges(At2, COLORS.primary));
            var Ainv3 = inv3(A);
            if (Ainv3) {
                var Ainvt = transformedCube(Ainv3);
                traces.push(trace3DMesh(Ainvt, 'A^{-1} applied', COLORS.flip, 0.15));
                traces.push(trace3DEdges(Ainvt, COLORS.flip));
            }
        }
        else if (op === 'multiply') {
            var Bt = transformedCube(B);
            var ABv = Bt.map(function (v) { return applyMat(A, v); });
            traces.push(trace3DMesh(Bt, 'B applied', COLORS.b, 0.18));
            traces.push(trace3DEdges(Bt, COLORS.b));
            traces.push(trace3DMesh(ABv, '(A B) applied', COLORS.primary, 0.30));
            traces.push(trace3DEdges(ABv, COLORS.primary));
        }
        else if (op === 'add' || op === 'subtract') {
            var At3 = transformedCube(A);
            var Bt3 = transformedCube(B);
            var Ct3 = transformedCube(combine(A, B, op));
            traces.push(trace3DMesh(At3, 'A applied', COLORS.primary, 0.15));
            traces.push(trace3DMesh(Bt3, 'B applied', COLORS.b,       0.15));
            traces.push(trace3DMesh(Ct3, (op === 'add' ? '(A+B)' : '(A\u2212B)') + ' applied',
                COLORS.sum, 0.30));
            traces.push(trace3DEdges(Ct3, COLORS.sum));
        }
        else if (op === 'power') {
            var absN = Math.min(Math.abs(n || 0), 3);
            var current = unitCubeVerts();
            for (var k = 1; k <= absN; k++) {
                current = current.map(function (v) { return applyMat(A, v); });
                traces.push(trace3DMesh(current, 'A^' + k + ' applied',
                    COLORS.primary, 0.15 + (k / absN) * 0.20));
                traces.push(trace3DEdges(current, COLORS.primary));
            }
        }
        return traces;
    }

    function layout3D() {
        return {
            autosize: true,
            margin: { l: 0, r: 0, t: 30, b: 0 },
            scene: {
                xaxis: { title: 'x', backgroundcolor: '#fafafa' },
                yaxis: { title: 'y', backgroundcolor: '#fafafa' },
                zaxis: { title: 'z', backgroundcolor: '#fafafa' },
                aspectmode: 'data',
                camera: { eye: { x: 1.6, y: 1.6, z: 1.2 } }
            },
            showlegend: true,
            legend: { orientation: 'h', y: -0.05 },
            paper_bgcolor: 'transparent'
        };
    }

    /* ── Top-level renderer ── */
    function makeCaption(op, A, B) {
        var det = A.length === 2 ? det2(A) : det3(A);
        switch (op) {
            case 'determinant':
                return 'Shaded ' + (A.length === 2 ? 'parallelogram' : 'parallelepiped') +
                       ' = image of the unit ' + (A.length === 2 ? 'square' : 'cube') +
                       ' under A. Its signed ' + (A.length === 2 ? 'area' : 'volume') +
                       ' = det A = ' + det.toFixed(4) +
                       (det < 0 ? ' \u2014 negative means orientation is reversed.' : '.');
            case 'inverse':
                return 'A applied (solid) and A\u207B\u00B9 applied (dashed). A\u207B\u00B9 undoes A: applying both in succession returns the unit shape.';
            case 'transpose':
                return 'Image of the unit shape under A (solid) vs. under A\u1D40 (dashed). They share the same ' +
                       (A.length === 2 ? 'area' : 'volume') + ' \u2014 in fact the same SIGNED ' +
                       (A.length === 2 ? 'area' : 'volume') + ' \u2014 since det(A\u1D40) = det(A).';
            case 'eigenvectors':
                return 'Coloured arrows are eigenvectors v\u1D62 \u2014 directions A leaves invariant. Dotted arrow shows A v\u1D62 = \u03BB\u1D62 v\u1D62 (same line, scaled by \u03BB\u1D62).';
            case 'power':
                return 'Successive applications of A: each frame is A times the previous. Capped at ' +
                       (A.length === 2 ? '4' : '3') + ' frames for readability.';
            case 'multiply':
                return 'Composition order: B is applied first (dashed), then A is applied to that (solid). The solid shape = (AB) applied to the unit ' +
                       (A.length === 2 ? 'square' : 'cube') + '.';
            case 'add':
            case 'subtract':
                return 'A applied, B applied, and (' + (op === 'add' ? 'A+B' : 'A\u2212B') +
                       ') applied to the unit shape. The combined map adds (or subtracts) the two transformations element-wise.';
        }
        return '';
    }

    function renderVisualization(op, cellsA, cellsB, n) {
        var container = document.getElementById('mc-viz-content');
        if (!container) return;

        if (!canVisualize(op, cellsA, cellsB)) {
            container.innerHTML =
                '<div class="mc-viz-na">' +
                '<strong>Visualization not available for this configuration.</strong><br>' +
                'Geometric overlays render only for <strong>2&times;2 or 3&times;3 numeric matrices</strong> ' +
                'on operations with a clean geometric interpretation: ' +
                '<em>det, inverse, transpose, eigenvectors (2D only), power, multiply, add, subtract</em>.<br>' +
                'Operations like rank, trace, RREF, char. polynomial, and eigenvalues alone are purely algebraic ' +
                'and don\u2019t correspond to a single picture.' +
                '</div>';
            return;
        }

        var A = cellsToMatrix(cellsA);
        var B = (cellsB && OPS[op].binary) ? cellsToMatrix(cellsB) : null;
        var dim = A.length;

        var captionText = makeCaption(op, A, B);
        container.innerHTML =
            (captionText ? '<div class="mc-viz-caption">' + captionText + '</div>' : '') +
            '<div id="mc-viz-container" class="mc-viz-container"></div>';

        var traces = (dim === 2)
            ? build2DTraces(op, A, B, n)
            : build3DTraces(op, A, B, n);
        var layout = (dim === 2) ? layout2D() : layout3D();
        var config = { responsive: true, displaylogo: false,
            modeBarButtonsToRemove: ['lasso2d', 'select2d', 'autoScale2d', 'toggleSpikelines'] };

        if (typeof loadPlotly !== 'function') {
            container.innerHTML = '<div class="mc-viz-na">Plotly loader unavailable. Refresh the page and try again.</div>';
            return;
        }
        loadPlotly(function () {
            if (window.Plotly && window.Plotly.newPlot) {
                window.Plotly.newPlot(document.getElementById('mc-viz-container'), traces, layout, config);
            }
        });
    }

    /* ─────────────────────────────────────────────────────────────────
       Tab switching + example chip handler.  Examples carry a JSON
       blob in data-preset that fully describes the populated state
       (op + matrices + exponent), so one click resets everything.
       ───────────────────────────────────────────────────────────────── */
    function wireTabs() {
        els.outputTabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                var panel = tab.getAttribute('data-panel');
                els.outputTabs.forEach(function (t) {
                    var active = t === tab;
                    t.classList.toggle('active', active);
                    t.setAttribute('aria-selected', active ? 'true' : 'false');
                });
                els.panels.forEach(function (p) {
                    p.classList.toggle('active', p.getAttribute('data-panel') === panel);
                });
            });
        });
    }

    function applyPreset(preset) {
        if (!preset) return;
        if (preset.op) setOp(preset.op);
        if (preset.size_a && els.sizeA) els.sizeA.value = preset.size_a;
        if (preset.size_b && els.sizeB) els.sizeB.value = preset.size_b;
        if (preset.matrix_a) applyMatrixLatex(els.matrixA, preset.matrix_a);
        if (preset.matrix_b) applyMatrixLatex(els.matrixB, preset.matrix_b);
        if (preset.n != null && els.exponent) els.exponent.value = String(preset.n);
        validate();
    }

    function wireExamples() {
        els.exampleChips.forEach(function (chip) {
            chip.addEventListener('click', function () {
                var raw = chip.getAttribute('data-preset');
                if (!raw) return;
                /* Defer until MathLive's <math-field> custom element has
                   upgraded — otherwise mf.setValue is undefined and the
                   matrix-fields silently stay empty on a fast click
                   over a slow CDN.  When already upgraded, the promise
                   resolves synchronously on the next microtask, so this
                   is essentially zero-cost on a warm page. */
                var apply = function () {
                    try { applyPreset(JSON.parse(raw)); } catch (e) {}
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else {
                    apply();
                }
            });
        });
    }

    /* ─────────────────────────────────────────────────────────────────
       Image-to-math scan + AI batch solve.

       Pipeline (handled by /modern/js/image-to-math.js, which is loaded
       by /math/partials/math-libs.jsp):
         1. User clicks Scan → upload modal
         2. OCR via /ai?action=ocr extracts raw text from image
         3. Second /ai call with our matrix-specific extractionPrompt
            returns a JSON array of {op, matrix_a, matrix_b, n, display}
         4. Picker modal:
              · "Solve this one" → onSelect → fillFormFromProblem +
                synthetic Calculate click — result + steps land in the
                main Result/Steps tabs.
              · "Solve all" → onSolveAll → solveBatch() opens a result
                overlay and per-problem fetches /OneCompilerFunctionality,
                renders KaTeX result + collapsible steps inline in each
                card.  No reliance on the chip / B-field / exponent
                state — the problem JSON carries everything.
       ───────────────────────────────────────────────────────────────── */
    function fillFormFromProblem(problem) {
        if (!problem) return;
        var op = OPS[problem.op] ? problem.op : 'determinant';
        setOp(op);
        if (problem.matrix_a) applyMatrixLatex(els.matrixA, problem.matrix_a);
        if (problem.matrix_b) applyMatrixLatex(els.matrixB, problem.matrix_b);
        if (problem.n != null && els.exponent) els.exponent.value = String(problem.n);
        validate();
    }

    function solveBatch(problems) {
        if (!problems || !problems.length) return;

        /* Reuse the shared image-to-math result-overlay markup so this
           page styles consistently with limit / series / vector calc
           batch flows.  IDs are itm-* (image-to-math) per convention. */
        var existing = document.getElementById('itm-results-overlay');
        if (existing) existing.remove();

        var ov = document.createElement('div');
        ov.id = 'itm-results-overlay';
        ov.className = 'itm-results-overlay';
        ov.innerHTML =
            '<div class="itm-results-modal">' +
            '  <div class="itm-results-header">' +
            '    <span class="itm-results-title">Solving ' + problems.length + ' Matrix Problem' + (problems.length > 1 ? 's' : '') + '</span>' +
            '    <button class="itm-close" id="itm-results-close">&times;</button>' +
            '  </div>' +
            '  <div class="itm-results-body" id="itm-results-body"></div>' +
            '  <div class="itm-results-footer">' +
            '    <button class="itm-btn" id="itm-results-done">Close</button>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(ov);
        ov.style.display = 'flex';
        document.body.style.overflow = 'hidden';

        var closeResults = function () {
            ov.style.display = 'none';
            document.body.style.overflow = '';
            ov.remove();
        };
        document.getElementById('itm-results-close').addEventListener('click', closeResults);
        document.getElementById('itm-results-done').addEventListener('click', closeResults);
        ov.addEventListener('click', function (e) { if (e.target === ov) closeResults(); });

        var body = document.getElementById('itm-results-body');
        problems.forEach(function (p, i) {
            var card = document.createElement('div');
            card.className = 'itm-result-card';
            card.id = 'itm-rc-' + i;
            card.innerHTML =
                '<div class="itm-result-card-header">' +
                '  <span class="itm-result-num">' + (i + 1) + '</span>' +
                '  <span class="itm-result-problem" id="itm-rp-' + i + '"></span>' +
                '  <span class="itm-result-status pending" id="itm-rs-' + i + '">Pending</span>' +
                '</div>' +
                '<div class="itm-result-card-body" id="itm-rb-' + i + '"></div>';
            body.appendChild(card);

            var probEl = document.getElementById('itm-rp-' + i);
            var display = p.display || (OPS[p.op] && OPS[p.op].label) || p.op || 'Matrix problem';
            if (window.katex && probEl) {
                try { katex.render(display, probEl, { throwOnError: false, displayMode: false }); }
                catch (e) { probEl.textContent = display; }
            } else if (probEl) {
                probEl.textContent = display;
            }
        });

        solveOne(problems, 0);
    }

    function solveOne(problems, idx) {
        if (idx >= problems.length) return;
        var p = problems[idx];
        var card = document.getElementById('itm-rc-' + idx);
        var status = document.getElementById('itm-rs-' + idx);
        var bodyEl = document.getElementById('itm-rb-' + idx);
        if (!card || !status || !bodyEl) { solveOne(problems, idx + 1); return; }

        card.className = 'itm-result-card solving';
        status.className = 'itm-result-status solving';
        status.textContent = 'Solving...';
        bodyEl.innerHTML = '<div class="itm-spinner"></div>';
        try { card.scrollIntoView({ behavior: 'smooth', block: 'nearest' }); } catch (e) {}

        var op = OPS[p.op] ? p.op : 'determinant';
        var def = OPS[op];
        var cellsA = parseMatrixCells(p.matrix_a || '');
        var cellsB = def.binary ? parseMatrixCells(p.matrix_b || '') : null;
        var n = def.needsExponent ? (p.n != null ? parseInt(p.n, 10) : 0) : null;

        if (!cellsA) {
            renderBatchError(card, status, bodyEl, 'Could not parse matrix A from image.');
            return solveOne(problems, idx + 1);
        }
        if (def.binary && !cellsB) {
            renderBatchError(card, status, bodyEl, 'Could not parse matrix B from image.');
            return solveOne(problems, idx + 1);
        }

        var code = buildPython(op, cellsA, cellsB, n);
        var ctx = (window.__MC_CTX || '');

        fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (stdout.indexOf('ERROR:') === 0) {
                throw new Error(stdout.replace(/^ERROR:/, ''));
            }
            if (!stdout && stderr) {
                throw new Error(stderr.split('\n').pop() || 'Solver error');
            }
            if (!stdout) throw new Error('No result from solver');

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*\])(?:\n|$)/);
            var resultLatex = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultLatex;
            var stepsArr = [];
            if (stepsMatch) {
                try { stepsArr = JSON.parse(stepsMatch[1]); } catch (e) {}
            }
            renderBatchResult(card, status, bodyEl, idx, p, resultLatex, resultText, stepsArr);
        })
        .catch(function (err) {
            renderBatchError(card, status, bodyEl, (err && err.message) || 'Error');
        })
        .finally(function () {
            solveOne(problems, idx + 1);
        });
    }

    function renderBatchError(card, status, bodyEl, msg) {
        card.className = 'itm-result-card error';
        status.className = 'itm-result-status fail';
        status.textContent = 'Failed';
        bodyEl.innerHTML = '<div class="itm-result-error-msg">' + (msg || 'Error').replace(/</g, '&lt;') + '</div>';
    }

    function renderBatchResult(card, status, bodyEl, idx, problem, resultLatex, resultText, steps) {
        var html = '';
        html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
        html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';
        if (steps && steps.length) {
            html += '<button class="itm-result-steps-btn" data-steps-idx="' + idx + '">Show Steps</button>';
            html += '<div class="itm-result-steps-area" id="itm-rsa-' + idx + '">';
            steps.forEach(function (s, j) {
                var stepId = 'itm-rst-' + idx + '-' + j;
                var titleSafe = (s.title || '').replace(/</g, '&lt;');
                var texSafe = (s.latex || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;');
                html += '<div class="itm-result-step">';
                html += '  <div class="itm-result-step-title">' + titleSafe + '</div>';
                html += '  <div id="' + stepId + '" data-step-katex="' + texSafe + '"></div>';
                html += '</div>';
            });
            html += '</div>';
        }
        bodyEl.innerHTML = html;

        if (window.katex) {
            var probEl = document.getElementById('itm-ri-' + idx);
            var ansEl = document.getElementById('itm-ra-' + idx);
            if (probEl) {
                var label = problem.display || (OPS[problem.op] && OPS[problem.op].label) || '';
                try { katex.render(label, probEl, { throwOnError: false, displayMode: false }); }
                catch (e) { probEl.textContent = label; }
            }
            if (ansEl) {
                /* No replace(/\\\\/g, '\\') here — the same fix that
                   applies to the main Result tab (matrix row separators
                   `\\` must NOT be collapsed to `\`).  resultLatex is
                   already KaTeX-ready coming out of JSON.parse. */
                try { katex.render('= ' + resultLatex, ansEl, { throwOnError: false, displayMode: true }); }
                catch (e) { ansEl.textContent = '= ' + resultText; }
            }
            bodyEl.querySelectorAll('[data-step-katex]').forEach(function (el) {
                var raw = el.getAttribute('data-step-katex');
                try { katex.render(raw, el, { throwOnError: false, displayMode: true }); }
                catch (e) { el.textContent = raw; }
            });
        }

        var stepsBtn = bodyEl.querySelector('[data-steps-idx="' + idx + '"]');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function () {
                var area = document.getElementById('itm-rsa-' + idx);
                if (area) {
                    area.classList.toggle('open');
                    stepsBtn.textContent = area.classList.contains('open') ? 'Hide Steps' : 'Show Steps';
                }
            });
        }

        card.className = 'itm-result-card solved';
        status.className = 'itm-result-status done';
        status.textContent = 'Solved';
    }

    function wireImageScan() {
        if (typeof window.ImageToMath === 'undefined' || !window.ImageToMath.init) return;
        if (!document.getElementById('mc-scan-btn')) return;

        var ctx = (window.__MC_CTX || '');
        window.ImageToMath.init({
            buttonId: 'mc-scan-btn',
            aiUrl: ctx + '/ai',
            toolName: 'Matrix Calculator',
            extractionPrompt:
                'You are a math problem extractor for a UNIFIED matrix calculator.\n' +
                'The calculator supports these 13 operations (use the EXACT op id):\n' +
                '  determinant, inverse, transpose, trace, rank, rref, power,\n' +
                '  eigenvalues, eigenvectors, charpoly, add, subtract, multiply\n\n' +
                'Given OCR text from a math image, extract ALL matrix problems.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "op": one of the 13 ids above\n' +
                '  - "matrix_a": primary matrix in `\\begin{pmatrix}...\\end{pmatrix}` LaTeX (cells separated by &, rows by \\\\)\n' +
                '  - "matrix_b": (binary ops only — add, subtract, multiply) second matrix in same form\n' +
                '  - "n": (power only) integer exponent (e.g. 2, 3, -1)\n' +
                '  - "display": full original problem in LaTeX, used as the card heading\n\n' +
                'Mapping rules (be liberal — students phrase things many ways):\n' +
                '  - "Find det A" / "|A|" / "Determinant of"               → op="determinant"\n' +
                '  - "A^{-1}" / "Find the inverse of"                       → op="inverse"\n' +
                '  - "A^T" / "transpose of A"                               → op="transpose"\n' +
                '  - "tr(A)" / "trace of A"                                 → op="trace"\n' +
                '  - "rank(A)" / "Find the rank"                            → op="rank"\n' +
                '  - "RREF" / "row reduce" / "Gauss-Jordan" / "echelon"     → op="rref"\n' +
                '  - "A^n" with explicit integer / "Compute A^5"            → op="power", set "n"\n' +
                '  - "eigenvalues" / "find lambda" / "spectrum"             → op="eigenvalues"\n' +
                '  - "eigenvectors" / "diagonalize"                         → op="eigenvectors"\n' +
                '  - "characteristic polynomial" / "p(lambda)"              → op="charpoly"\n' +
                '  - "A + B"                                                → op="add", set matrix_b\n' +
                '  - "A - B"                                                → op="subtract", set matrix_b\n' +
                '  - "AB" / "A times B" / "A multiplied by B" / "A . B"    → op="multiply", set matrix_b\n\n' +
                'CRITICAL RULES:\n' +
                '  - matrix_a / matrix_b MUST be valid `\\begin{pmatrix}...\\end{pmatrix}` strings.\n' +
                '  - Use & to separate cells in a row, \\\\ to separate rows. Example for [[1,2],[3,4]]: "\\\\begin{pmatrix}1 & 2\\\\\\\\3 & 4\\\\end{pmatrix}"\n' +
                '  - Cells may contain integers, fractions (`\\\\frac{1}{2}`), decimals, symbolic vars, `\\\\pi`, `e`.\n' +
                '  - Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
                '  - If no recognizable matrix problem is found, return [].\n\n' +
                'Example:\n' +
                'Input OCR: "Find the determinant of the matrix [[1,2,3],[4,5,6],[7,8,10]]"\n' +
                'Output: [{"op":"determinant","matrix_a":"\\\\begin{pmatrix}1 & 2 & 3\\\\\\\\4 & 5 & 6\\\\\\\\7 & 8 & 10\\\\end{pmatrix}","display":"\\\\det\\\\begin{pmatrix}1 & 2 & 3\\\\\\\\4 & 5 & 6\\\\\\\\7 & 8 & 10\\\\end{pmatrix}"}]',
            onSelect: function (problem) {
                /* Defer until MathLive has upgraded — same race-fix as
                   the example chip handler.  When the user clicks Scan
                   over a slow CDN they'd otherwise see an empty math-
                   field as fillFormFromProblem silently no-ops. */
                var apply = function () {
                    fillFormFromProblem(problem);
                    setTimeout(function () {
                        if (els.calculate) els.calculate.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else {
                    apply();
                }
            },
            onSolveAll: solveBatch
        });
    }

    /* ─────────────────────────────────────────────────────────────────
       Math AI page context — mirrors active op + matrices on the page.
       ───────────────────────────────────────────────────────────────── */
    window.mcGetContext = function () {
        var def = OPS[currentOp] || OPS[DEFAULT_OP];
        var snap = {
            toolType: 'matrix',
            op: currentOp,
            matrixA: getLatex(els.matrixA) || '',
            matrixB: def.binary ? (getLatex(els.matrixB) || '') : '',
            n: def.needsExponent && els.exponent
                ? (parseInt(els.exponent.value, 10) || 2)
                : null
        };
        if (lastPageResult && (lastPageResult.resultText || lastPageResult.resultLatex)) {
            snap.resultSummary = String(lastPageResult.resultText || lastPageResult.resultLatex).slice(0, 4000);
        }
        return snap;
    };

    /* ─────────────────────────────────────────────────────────────────
       Boot — read ?op= from URL, seed math-fields with empty templates,
       wire all listeners.
       ───────────────────────────────────────────────────────────────── */
    function boot() {
        cacheDom();

        els.opChips.forEach(function (chip) {
            chip.addEventListener('click', function () { setOp(chip.getAttribute('data-op')); });
        });

        if (els.sizeA) els.sizeA.addEventListener('change', function () { resetMatrix(els.matrixA, els.sizeA); validate(); });
        if (els.sizeB) els.sizeB.addEventListener('change', function () { resetMatrix(els.matrixB, els.sizeB); validate(); });
        if (els.resetA) els.resetA.addEventListener('click', function () { resetMatrix(els.matrixA, els.sizeA); validate(); });
        if (els.resetB) els.resetB.addEventListener('click', function () { resetMatrix(els.matrixB, els.sizeB); validate(); });
        if (els.randomA) els.randomA.addEventListener('click', function () { randomMatrix(els.matrixA, els.sizeA); validate(); });
        if (els.randomB) els.randomB.addEventListener('click', function () { randomMatrix(els.matrixB, els.sizeB); validate(); });

        /* Matrix A input runs detection — if the user typed a self-
           describing expression (`\det A`, `A^{-1}`, `A B`, …) we
           auto-switch the chip to match.  Visual feedback that
           Symbolab-style input is being recognized.  Then validate. */
        if (els.matrixA) {
            els.matrixA.addEventListener('input', function () {
                var detected = detectOpFromExpression(getLatex(els.matrixA));
                if (detected && detected.op !== currentOp) {
                    setOp(detected.op);
                } else {
                    validate();
                }
            });
        }
        if (els.matrixB) els.matrixB.addEventListener('input', validate);
        if (els.exponent) {
            els.exponent.addEventListener('input', validate);
            /* Enter on the exponent <input type="number"> would normally
               do nothing (no enclosing form).  Wire it to Calculate so
               the user can pick a size, type n, hit Enter — common flow
               for power op. */
            els.exponent.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') { e.preventDefault(); calculate(); }
            });
        }

        if (els.calculate) els.calculate.addEventListener('click', calculate);

        wireTabs();
        wireExamples();
        wireImageScan();

        /* Read ?op= deep link.  We have to call setOp BEFORE the
           math-field upgrade resolves because it controls which fields
           are visible — but the initial matrix-template seed has to
           wait until MathLive has registered the custom element and
           setValue() is callable. */
        var urlOp = null;
        try { urlOp = new URL(window.location.href).searchParams.get('op'); } catch (e) {}
        setOp(urlOp || DEFAULT_OP);

        /* Enter inside either math-field triggers calculate.  Bind
           once the elements have upgraded — otherwise addEventListener
           fires on the unupgraded HTMLElement and the listener never
           sees Enter (math-field intercepts it before bubble). */
        function bindEnter(mf) {
            if (!mf) return;
            mf.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); calculate(); }
            });
        }

        function seedInitialTemplates() {
            /* Only fill if the math-field is empty — preserves anything
               an example chip wrote before MathLive finished upgrading. */
            if (els.matrixA && els.sizeA && !getLatex(els.matrixA)) {
                resetMatrix(els.matrixA, els.sizeA);
            }
            if (els.matrixB && els.sizeB && !getLatex(els.matrixB)) {
                resetMatrix(els.matrixB, els.sizeB);
            }
            BOOT_DONE = true;
            validate();
        }

        if (window.customElements && customElements.whenDefined) {
            customElements.whenDefined('math-field').then(function () {
                seedInitialTemplates();
                bindEnter(els.matrixA);
                bindEnter(els.matrixB);
            }).catch(function () {
                /* MathLive failed to load — math-fields will stay as
                   plain HTMLElements, no editor.  Flip BOOT_DONE so
                   validate() resumes (will warn that matrices are
                   empty, which is accurate). */
                BOOT_DONE = true;
                validate();
            });
        } else {
            /* No custom-elements support — try seeding immediately
               (will be a no-op if setValue isn't on the element yet). */
            seedInitialTemplates();
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
