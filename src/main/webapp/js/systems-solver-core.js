/**
 * Systems of Equations Solver - Core Orchestration
 * Nerdamer-based symbolic parsing + existing linear step generators
 */
(function() {
'use strict';

var R = window.SystemsSolverRender;
var G = window.SystemsSolverGraph;
var E = window.SystemsSolverExport;

// nerdamer's Solve.js builds numeric evaluators via eval() that reference the
// imaginary unit `i` as a bare variable without declaring it in the generated
// function scope — causing a ReferenceError in Chrome even when caught.
// Defining window.i = NaN prevents the throw; complex roots evaluate to NaN
// and are filtered out by isFinite() checks as intended.
if (typeof window.i === 'undefined') window.i = NaN;

// ==================== State ====================

var state = {
    method: 'cramer',
    equations: ['2x + 3y = 8', '4x - y = 2'],
    activeTab: 'result',
    lastResult: null,
    // Populated after each solve for export/graph use
    _A: null, _b: null, _vars: null, _size: null,
    // Nonlinear graph state
    _nlEqs: null, _nlVars: null, _nlSolutions: null,
    // SymPy fallback flag
    _sympyNeeded: false
};

// ==================== DOM Helpers ====================

function $(id) {
    return document.getElementById(id);
}

// ==================== Equation Input Management ====================

var MAX_EQ = 3;
var MIN_EQ = 2;

function getEquationStrings() {
    var inputs = document.querySelectorAll('.sy-eq-input');
    var eqs = [];
    for (var i = 0; i < inputs.length; i++) {
        eqs.push(inputs[i].value);
    }
    return eqs;
}

function renderEquationInputs() {
    var list = $('sy-eq-list');
    if (!list) return;
    list.innerHTML = '';
    for (var i = 0; i < state.equations.length; i++) {
        list.appendChild(_makeEqRow(i, state.equations[i]));
    }
    _updateAddBtn();
    _updateRemoveBtns();
}

function _makeEqRow(idx, val) {
    var row = document.createElement('div');
    row.className = 'sy-sym-row';
    row.setAttribute('data-eq-idx', idx);

    var num = document.createElement('span');
    num.className = 'sy-sym-num';
    num.textContent = (idx + 1) + ':';

    var input = document.createElement('input');
    input.type = 'text';
    input.className = 'sy-sym-input sy-eq-input';
    input.value = val;
    input.placeholder = idx === 0 ? 'e.g. 2x + 3y = 8' : idx === 1 ? 'e.g. 4x - y = 2' : 'e.g. x + y + z = 6';
    input.setAttribute('aria-label', 'Equation ' + (idx + 1));
    input.setAttribute('autocomplete', 'off');
    input.setAttribute('spellcheck', 'false');

    var removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'sy-remove-eq-btn';
    removeBtn.title = 'Remove equation';
    removeBtn.innerHTML = '&times;';
    removeBtn.setAttribute('data-eq-idx', idx);
    removeBtn.style.display = idx < MIN_EQ ? 'none' : '';

    input.addEventListener('input', function() { _onEquationChange(); });
    input.addEventListener('keydown', function(ev) {
        if (ev.key === 'Enter') solve();
    });
    removeBtn.addEventListener('click', function() {
        removeEquation(parseInt(this.getAttribute('data-eq-idx')));
    });

    row.appendChild(num);
    row.appendChild(input);
    row.appendChild(removeBtn);
    return row;
}

function addEquation() {
    if (state.equations.length >= MAX_EQ) return;
    state.equations.push('');
    renderEquationInputs();
    // Focus the new input
    var inputs = document.querySelectorAll('.sy-eq-input');
    if (inputs.length) inputs[inputs.length - 1].focus();
    _onEquationChange();
}

function removeEquation(idx) {
    if (state.equations.length <= MIN_EQ) return;
    // Sync current values before removing
    var inputs = document.querySelectorAll('.sy-eq-input');
    for (var i = 0; i < inputs.length; i++) state.equations[i] = inputs[i].value;
    state.equations.splice(idx, 1);
    renderEquationInputs();
    _onEquationChange();
}

function _updateAddBtn() {
    var btn = $('sy-add-eq-btn');
    if (!btn) return;
    btn.disabled = state.equations.length >= MAX_EQ;
    btn.style.display = state.equations.length >= MAX_EQ ? 'none' : '';
}

function _updateRemoveBtns() {
    var btns = document.querySelectorAll('.sy-remove-eq-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].style.display = state.equations.length <= MIN_EQ ? 'none' : '';
    }
}

var _previewTimer = null;
function _onEquationChange() {
    // Sync state
    var inputs = document.querySelectorAll('.sy-eq-input');
    for (var i = 0; i < inputs.length; i++) state.equations[i] = inputs[i].value;
    // Debounce preview update
    if (_previewTimer) clearTimeout(_previewTimer);
    _previewTimer = setTimeout(_updatePreview, 350);
}

function _updatePreview() {
    var eqs = getEquationStrings().filter(function(e) { return e.trim(); });
    var preview = $('sy-preview');
    if (!preview) return;
    if (eqs.length === 0) { preview.style.display = 'none'; return; }

    // Build preview LaTeX
    var lines = eqs.map(function(eq) {
        var idx = eq.indexOf('=');
        if (idx < 0) return eq;
        return eq.substring(0, idx).trim() + ' = ' + eq.substring(idx + 1).trim();
    });
    var latex = '\\begin{cases}' + lines.join(' \\\\ ') + '\\end{cases}';

    preview.style.display = '';
    if (window.katex) {
        try {
            katex.render(latex, preview, { displayMode: true, throwOnError: false });
            return;
        } catch(e) { /* fall through to text */ }
    }
    preview.textContent = eqs.join('  |  ');

    // Update system badge
    _updateSystemBadge();
}

function _updateSystemBadge() {
    var badge = $('sy-sys-badge');
    if (!badge) return;
    if (!window.nerdamer) { badge.style.display = 'none'; return; }

    var eqs = getEquationStrings().filter(function(e) { return e.trim() && e.indexOf('=') >= 0; });
    if (eqs.length < 2) { badge.style.display = 'none'; return; }

    try {
        var vars = detectVars(eqs);
        var linear = vars.length > 0 && eqs.every(function(e) { return isLinearEquation(e, vars); });
        badge.style.display = 'inline-flex';
        var sizeLabel = eqs.length + '\u00d7' + eqs.length;
        if (linear) {
            badge.className = 'sy-sys-badge linear';
            badge.textContent = sizeLabel + ' Linear';
        } else {
            badge.className = 'sy-sys-badge nonlinear';
            badge.textContent = 'Nonlinear';
        }
        // Dim method selector for nonlinear
        var methodSec = document.querySelector('.sy-method-section');
        if (methodSec) {
            methodSec.classList.toggle('sy-nonlinear-mode', !linear);
        }
    } catch(e) {
        badge.style.display = 'none';
    }
}

// ==================== Unicode Normalization ====================

/**
 * Normalise Unicode math characters to ASCII equivalents understood by Nerdamer.
 * Called on every equation string before any parsing or solving.
 *
 * Handles:
 *  ² ³ ¹ ⁰ ⁴–⁹  → ^2 ^3 ^1 ^0 ^4–^9   (superscript digits)
 *  × ÷            → * /                   (multiplication / division signs)
 *  − (U+2212)     → -                     (real minus sign, not ASCII hyphen)
 *  · ∙ ⋅          → *                     (various middle dots / product dots)
 */
function _normalizeEq(s) {
    if (typeof s !== 'string') return s;
    return s
        .replace(/\u00B2/g, '^2')
        .replace(/\u00B3/g, '^3')
        .replace(/\u00B9/g, '^1')
        .replace(/\u2070/g, '^0')
        .replace(/\u2074/g, '^4')
        .replace(/\u2075/g, '^5')
        .replace(/\u2076/g, '^6')
        .replace(/\u2077/g, '^7')
        .replace(/\u2078/g, '^8')
        .replace(/\u2079/g, '^9')
        .replace(/\u00D7/g, '*')
        .replace(/\u00F7/g, '/')
        .replace(/\u2212/g, '-')
        .replace(/[\u00B7\u2219\u22C5]/g, '*');
}

// ==================== Nerdamer-based Parsing ====================

function hasNerdamer() {
    return typeof nerdamer !== 'undefined';
}

function splitEquation(eqStr) {
    var s = eqStr.trim();
    var idx = s.indexOf('=');
    if (idx < 0) return null;
    return { lhs: s.substring(0, idx).trim(), rhs: s.substring(idx + 1).trim() };
}

function detectVars(equations) {
    var varSet = {};
    for (var i = 0; i < equations.length; i++) {
        var eq = splitEquation(equations[i]);
        if (!eq) continue;
        try {
            var expr = nerdamer('(' + eq.lhs + ')- (' + eq.rhs + ')');
            var vars = expr.variables();
            for (var j = 0; j < vars.length; j++) {
                // Skip Euler's number 'e' and 'i' (imaginary unit)
                if (vars[j] !== 'e' && vars[j] !== 'i') varSet[vars[j]] = true;
            }
        } catch(ex) { /* skip */ }
    }
    return Object.keys(varSet).sort();
}

function isLinearEquation(eqStr, vars) {
    var eq = splitEquation(eqStr);
    if (!eq) return false;
    var expr = '(' + eq.lhs + ') - (' + eq.rhs + ')';
    for (var i = 0; i < vars.length; i++) {
        try {
            // Use functional nerdamer('diff(...)') form — more portable across versions
            var d = nerdamer('diff(' + expr + ', ' + vars[i] + ')');
            // If derivative still contains variables, the term is nonlinear
            if (d.variables().length > 0) return false;
        } catch(ex) { return false; }
    }
    return true;
}

function classifySystem(equations) {
    var eqs = equations
        .map(function(e) { return _normalizeEq(e); })
        .filter(function(e) { return e.trim() && e.indexOf('=') >= 0; });
    if (eqs.length < 2) return { _tooFew: true, eqs: eqs };
    if (eqs.length > 3) return { _tooMany: true, eqs: eqs };

    if (!hasNerdamer()) {
        // Nerdamer not available — try basic fallback parser for simple linear equations
        return _classifyFallback(eqs);
    }

    var vars = detectVars(eqs);
    if (vars.length === 0) return null;

    var linear = eqs.every(function(e) { return isLinearEquation(e, vars); });
    return { eqs: eqs, vars: vars, isLinear: linear };
}

// Basic fallback parser for ax+by=c style (no Nerdamer required)
function _classifyFallback(eqs) {
    // Simple regex coefficient extractor
    var allVars = {};
    var parsed = [];
    for (var i = 0; i < eqs.length; i++) {
        var eq = splitEquation(eqs[i]);
        if (!eq) return null;
        // Find variable names (single letters)
        var matches = (eq.lhs + eq.rhs).match(/[a-zA-Z]+/g) || [];
        for (var j = 0; j < matches.length; j++) {
            if (matches[j] !== 'e' && matches[j] !== 'i') allVars[matches[j]] = true;
        }
        parsed.push(eq);
    }
    var vars = Object.keys(allVars).sort();
    if (vars.length === 0 || vars.length > 3) return null;

    // If any equation contains ^ (exponent), it's nonlinear — can't solve without CAS
    var hasExponent = eqs.some(function(e) { return e.indexOf('^') >= 0; });
    if (hasExponent) return { eqs: eqs, vars: vars, isLinear: false, _useFallback: true };

    // Use basic extraction
    return { eqs: eqs, vars: vars, isLinear: true, _useFallback: true };
}

// Basic regex-based coefficient extractor (fallback when Nerdamer unavailable)
function _extractLinearFallback(eqs, vars) {
    var A = [], b = [];
    for (var i = 0; i < eqs.length; i++) {
        var eq = splitEquation(eqs[i]);
        if (!eq) return null;
        var row = new Array(vars.length).fill(0);
        // Tokenize: match patterns like 3x, -2y, x, -z, +5z, etc.
        var lhs = eq.lhs.replace(/\s+/g, '');
        // Add leading + for uniform parsing
        if (lhs[0] !== '-' && lhs[0] !== '+') lhs = '+' + lhs;
        var tokenRe = /([+-]?\d*\.?\d*)\*?([a-zA-Z]+)/g;
        var match;
        while ((match = tokenRe.exec(lhs)) !== null) {
            var cStr = match[1], vName = match[2];
            var c = (cStr === '' || cStr === '+') ? 1 : cStr === '-' ? -1 : parseFloat(cStr);
            var idx = vars.indexOf(vName);
            if (idx >= 0 && !isNaN(c)) row[idx] = c;
        }
        A.push(row);
        b.push(parseFloat(eq.rhs.trim()) || 0);
    }
    return { A: A, b: b };
}

function extractLinearSystem(eqs, vars) {
    var n = vars.length;
    var A = [], b = [];
    for (var i = 0; i < eqs.length; i++) {
        var eq = splitEquation(eqs[i]);
        if (!eq) return null;
        var expr = '(' + eq.lhs + ') - (' + eq.rhs + ')';
        var row = [];
        // Extract coefficient of each variable via partial derivative
        for (var j = 0; j < n; j++) {
            try {
                var coeff = parseFloat(
                    nerdamer('diff(' + expr + ', ' + vars[j] + ')').evaluate().text()
                );
                row.push(isNaN(coeff) ? 0 : coeff);
            } catch(ex) { row.push(0); }
        }
        A.push(row);
        // Constant term: set all vars = 0, evaluate the expression
        try {
            for (var k = 0; k < n; k++) nerdamer.setVar(vars[k], 0);
            var constTerm = parseFloat(nerdamer(expr).evaluate().text());
            nerdamer.clearVars();
            b.push(-constTerm);
        } catch(ex) {
            nerdamer.clearVars();
            b.push(0);
        }
    }
    return { A: A, b: b };
}

function solveWithNerdamer(eqs, vars) {
    // Only attempt for small polynomial systems (2 vars, low degree)
    // Cubic+ with 2+ vars can hang the browser indefinitely
    if (!hasNerdamer()) return null;
    try {
        var result = nerdamer.solveEquations(eqs, vars);
        return result;
    } catch(ex) {
        return null;
    }
}

function _maxDegree(eqStr) {
    // Estimate max polynomial degree from ^ notation
    var matches = eqStr.match(/\^(\d+)/g) || [];
    var max = 1;
    for (var i = 0; i < matches.length; i++) {
        var d = parseInt(matches[i].slice(1));
        if (d > max) max = d;
    }
    return max;
}

// ==================== Method Switching ====================

function switchMethod(method) {
    state.method = method;
    var ids = ['sy-method-cramer', 'sy-method-gaussian', 'sy-method-substitution', 'sy-method-matrix', 'sy-method-all'];
    for (var i = 0; i < ids.length; i++) {
        var btn = $(ids[i]);
        if (btn) btn.classList.toggle('active', ids[i] === 'sy-method-' + method);
    }
    _updateGraphTabVisibility();
}

function _updateGraphTabVisibility() {
    var tabGraph = $('sy-tab-graph');
    if (!tabGraph) return;
    var showLinear    = (state._size === 2 && state.method !== 'all' && state._A !== null);
    var showNonlinear = (state._nlEqs !== null && state._nlVars !== null && state._nlVars.length === 2);
    var show = showLinear || showNonlinear;
    tabGraph.style.display = '';   // always visible — was hidden by old init code
    tabGraph.disabled = !show;
    if (!show && state.activeTab === 'graph') switchTab('result');
}

// ==================== Tab Switching ====================

function switchTab(tab) {
    state.activeTab = tab;
    var tabs = ['result', 'graph'];
    for (var i = 0; i < tabs.length; i++) {
        var btn = $('sy-tab-' + tabs[i]);
        var panel = $('sy-panel-' + tabs[i]);
        var isActive = tabs[i] === tab;
        if (btn) btn.classList.toggle('active', isActive);
        // Use explicit 'block' — setting '' would fall back to CSS display:none on .sy-panel
        if (panel) panel.style.display = isActive ? 'block' : 'none';
    }
    // Defer graph render so the panel is painted and has real dimensions first
    if (tab === 'graph') {
        var tabGraphBtn = $('sy-tab-graph');
        if (tabGraphBtn) tabGraphBtn.disabled = true;
        setTimeout(function() {
            drawGraph();
            // Re-enable after Plotly has had time to render (~800 ms is plenty)
            setTimeout(function() {
                _updateGraphTabVisibility();
            }, 800);
        }, 0);
    }
}

// ==================== Math Utilities ====================

function _det2(A) {
    return A[0][0] * A[1][1] - A[0][1] * A[1][0];
}

function _det3(A) {
    return (
        A[0][0] * (A[1][1]*A[2][2] - A[1][2]*A[2][1]) -
        A[0][1] * (A[1][0]*A[2][2] - A[1][2]*A[2][0]) +
        A[0][2] * (A[1][0]*A[2][1] - A[1][1]*A[2][0])
    );
}

function _replaceCol(A, colIdx, colVals) {
    var n = A.length;
    var M = [];
    for (var i = 0; i < n; i++) {
        M[i] = A[i].slice();
        M[i][colIdx] = colVals[i];
    }
    return M;
}

function _fmtNum(n) {
    if (!isFinite(n)) return String(n);
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return parseFloat(n.toFixed(6)).toString();
}

// ==================== Solvers ====================

function _solveCramer2(A, b) {
    var det = _det2(A);
    if (Math.abs(det) < 1e-12) return null;
    return [_det2(_replaceCol(A, 0, b)) / det, _det2(_replaceCol(A, 1, b)) / det];
}

function _solveCramer3(A, b) {
    var det = _det3(A);
    if (Math.abs(det) < 1e-12) return null;
    return [
        _det3(_replaceCol(A, 0, b)) / det,
        _det3(_replaceCol(A, 1, b)) / det,
        _det3(_replaceCol(A, 2, b)) / det
    ];
}

function _solveGaussian(A, b) {
    var n = A.length;
    var aug = [];
    for (var i = 0; i < n; i++) { aug[i] = A[i].slice(); aug[i].push(b[i]); }

    for (var col = 0; col < n; col++) {
        var maxRow = col, maxVal = Math.abs(aug[col][col]);
        for (var r = col + 1; r < n; r++) {
            if (Math.abs(aug[r][col]) > maxVal) { maxVal = Math.abs(aug[r][col]); maxRow = r; }
        }
        var tmp = aug[col]; aug[col] = aug[maxRow]; aug[maxRow] = tmp;
        if (Math.abs(aug[col][col]) < 1e-12) return null;
        for (var row = col + 1; row < n; row++) {
            var factor = aug[row][col] / aug[col][col];
            for (var k = col; k <= n; k++) aug[row][k] -= factor * aug[col][k];
        }
    }

    var x = new Array(n);
    for (var i = n - 1; i >= 0; i--) {
        x[i] = aug[i][n];
        for (var j = i + 1; j < n; j++) x[i] -= aug[i][j] * x[j];
        x[i] /= aug[i][i];
    }
    return x;
}

function _solveSubstitution2(A, b) {
    var a = A[0][0], bCoef = A[0][1], c = b[0];
    var d = A[1][0], e = A[1][1], f = b[1];
    if (Math.abs(a) > 1e-12) {
        var denom = e - d * bCoef / a;
        if (Math.abs(denom) < 1e-12) return null;
        var y = (f - d * c / a) / denom;
        return [(c - bCoef * y) / a, y];
    } else if (Math.abs(bCoef) > 1e-12) {
        var y2 = c / bCoef;
        if (Math.abs(d) < 1e-12) return null;
        return [(f - e * y2) / d, y2];
    }
    return null;
}

// ==================== Step Builders ====================

// Render \(...\) inline math inside plain text titles
function _renderInlineMath(text) {
    if (!window.katex || text.indexOf('\\(') === -1) return text;
    return text.replace(/\\\(([^]*?)\\\)/g, function(_, math) {
        try {
            return katex.renderToString(math, { displayMode: false, throwOnError: false });
        } catch(e) { return math; }
    });
}

function _katexify(container) {
    if (!container || !window.katex) return;
    var elems = container.querySelectorAll('[data-latex]');
    for (var i = 0; i < elems.length; i++) {
        try {
            katex.render(elems[i].getAttribute('data-latex'), elems[i], {
                displayMode: elems[i].getAttribute('data-display') === 'true',
                throwOnError: false
            });
        } catch(e) {
            elems[i].textContent = elems[i].getAttribute('data-latex');
        }
    }
    if (window.renderMathInElement) {
        try {
            renderMathInElement(container, {
                delimiters: [
                    { left: '\\[', right: '\\]', display: true },
                    { left: '\\(', right: '\\)', display: false }
                ],
                throwOnError: false
            });
        } catch(e) { /* ignore */ }
    }
}

function _fmtCoeff(c, varName, isFirst) {
    if (Math.abs(c) < 1e-12) return '';
    var sign = '';
    if (!isFirst) sign = c >= 0 ? ' + ' : ' - ';
    else if (c < 0) sign = '-';
    var abs = Math.abs(c);
    var absStr = Math.abs(abs - Math.round(abs)) < 1e-9 ? String(Math.round(abs)) : parseFloat(abs.toFixed(4)).toString();
    return sign + (absStr === '1' ? '' : absStr) + varName;
}

function _buildEquationLatex(row, rhs, vars) {
    var parts = [], first = true;
    for (var i = 0; i < row.length; i++) {
        var s = _fmtCoeff(row[i], vars[i], first);
        if (s) { parts.push(s); first = false; }
    }
    return (parts.join('') || '0') + ' = ' + _fmtNum(rhs);
}

function _matrixLatex(M) {
    var rows = [];
    for (var i = 0; i < M.length; i++) {
        rows.push(M[i].map(function(v) { return _fmtNum(v); }).join(' & '));
    }
    return '\\begin{pmatrix}' + rows.join(' \\\\ ') + '\\end{pmatrix}';
}

function _stepDiv(num, title, latex, displayMode) {
    var mathId = 'sy-math-' + Math.random().toString(36).slice(2, 8);
    return '<div class="sy-step-item">' +
        '<div class="sy-step-num">' + num + '</div>' +
        '<div class="sy-step-body">' +
        '<div class="sy-step-title">' + _renderInlineMath(title) + '</div>' +
        (latex ? '<div id="' + mathId + '" class="sy-step-math" data-latex="' + latex.replace(/"/g, '&quot;') + '" data-display="' + (displayMode ? 'true' : 'false') + '"></div>' : '') +
        '</div></div>';
}

// ==================== Cramer Steps ====================

function _cramerSteps2(A, b) {
    var det = _det2(A), dx = _det2(_replaceCol(A, 0, b)), dy = _det2(_replaceCol(A, 1, b));
    var steps = [];
    steps.push(_stepDiv(1, 'Write coefficient matrix A and compute det(A)',
        'A = ' + _matrixLatex(A) + ', \\quad \\det(A) = ' + _fmtNum(det), true));
    if (Math.abs(det) < 1e-12) return steps;
    steps.push(_stepDiv(2, 'Replace column 1 with b \u2192 A\u2093; compute det(A\u2093)',
        'A_x = ' + _matrixLatex(_replaceCol(A, 0, b)) + ', \\quad \\det(A_x) = ' + _fmtNum(dx), true));
    steps.push(_stepDiv(3, 'Replace column 2 with b \u2192 A\u1D67; compute det(A\u1D67)',
        'A_y = ' + _matrixLatex(_replaceCol(A, 1, b)) + ', \\quad \\det(A_y) = ' + _fmtNum(dy), true));
    steps.push(_stepDiv(4, "Apply Cramer's Rule",
        'x = \\frac{\\det(A_x)}{\\det(A)} = \\frac{' + _fmtNum(dx) + '}{' + _fmtNum(det) + '} = ' + _fmtNum(dx/det) +
        ', \\quad y = \\frac{\\det(A_y)}{\\det(A)} = \\frac{' + _fmtNum(dy) + '}{' + _fmtNum(det) + '} = ' + _fmtNum(dy/det), true));
    return steps;
}

function _cramerSteps3(A, b) {
    var det = _det3(A);
    var dx = _det3(_replaceCol(A, 0, b)), dy = _det3(_replaceCol(A, 1, b)), dz = _det3(_replaceCol(A, 2, b));
    var steps = [];
    steps.push(_stepDiv(1, 'Compute det(A) using cofactor expansion', '\\det(A) = ' + _fmtNum(det), true));
    if (Math.abs(det) < 1e-12) return steps;
    steps.push(_stepDiv(2, 'Replace col 1 \u2192 det(A\u2093)', '\\det(A_x) = ' + _fmtNum(dx), false));
    steps.push(_stepDiv(3, 'Replace col 2 \u2192 det(A\u1D67)', '\\det(A_y) = ' + _fmtNum(dy), false));
    steps.push(_stepDiv(4, 'Replace col 3 \u2192 det(A\u1D68)', '\\det(A_z) = ' + _fmtNum(dz), false));
    steps.push(_stepDiv(5, "Apply Cramer's Rule",
        'x = \\frac{' + _fmtNum(dx) + '}{' + _fmtNum(det) + '} = ' + _fmtNum(dx/det) +
        ', \\; y = \\frac{' + _fmtNum(dy) + '}{' + _fmtNum(det) + '} = ' + _fmtNum(dy/det) +
        ', \\; z = \\frac{' + _fmtNum(dz) + '}{' + _fmtNum(det) + '} = ' + _fmtNum(dz/det), true));
    return steps;
}

// ==================== Gaussian Steps ====================

function _gaussianSteps(A, b) {
    var n = A.length;
    var vars = n === 2 ? ['x', 'y'] : ['x', 'y', 'z'];
    var steps = [];
    var aug = [];
    for (var i = 0; i < n; i++) { aug[i] = A[i].slice(); aug[i].push(b[i]); }

    function augLatex(m) {
        var rows = m.map(function(r) { return r.map(function(v) { return _fmtNum(v); }).join(' & '); });
        return '\\left[\\begin{array}{' + 'c'.repeat(n) + '|c}' + rows.join(' \\\\ ') + '\\end{array}\\right]';
    }

    steps.push(_stepDiv(1, 'Write augmented matrix [A|b]', augLatex(aug), true));

    for (var col = 0; col < n; col++) {
        var maxRow = col;
        for (var r = col + 1; r < n; r++) {
            if (Math.abs(aug[r][col]) > Math.abs(aug[maxRow][col])) maxRow = r;
        }
        if (maxRow !== col) {
            var tmp = aug[col]; aug[col] = aug[maxRow]; aug[maxRow] = tmp;
            steps.push(_stepDiv('R', 'Swap R' + (col+1) + ' \u2194 R' + (maxRow+1), augLatex(aug), true));
        }
        if (Math.abs(aug[col][col]) < 1e-12) break;
        for (var row = col + 1; row < n; row++) {
            var factor = aug[row][col] / aug[col][col];
            if (Math.abs(factor) < 1e-12) continue;
            for (var k = col; k <= n; k++) aug[row][k] -= factor * aug[col][k];
            steps.push(_stepDiv('E', 'R' + (row+1) + ' \u2190 R' + (row+1) + ' \u2212 (' + _fmtNum(factor) + ')R' + (col+1), augLatex(aug), true));
        }
    }
    steps.push(_stepDiv(n + 1, 'Back-substitute to find solution', null, false));
    return steps;
}

// ==================== Substitution Steps ====================

function _substitutionSteps2(A, b) {
    var steps = [];
    var a = A[0][0], bc = A[0][1], c = b[0];
    var d = A[1][0], e2 = A[1][1], f = b[1];

    steps.push(_stepDiv(1, 'Write the system',
        _buildEquationLatex(A[0], b[0], ['x','y']) + ' \\quad\\text{and}\\quad ' + _buildEquationLatex(A[1], b[1], ['x','y']), false));

    if (Math.abs(a) > 1e-12) {
        steps.push(_stepDiv(2, 'From equation 1, express x in terms of y',
            'x = \\dfrac{' + _fmtNum(c) + (Math.abs(bc) > 1e-12 ? ' - ' + _fmtNum(bc) + 'y' : '') + '}{' + _fmtNum(a) + '}', true));
        var denom = e2 - d * bc / a;
        steps.push(_stepDiv(3, 'Substitute into equation 2 and solve for y',
            _fmtNum(denom) + 'y = ' + _fmtNum(f - d * c / a), false));
    } else {
        steps.push(_stepDiv(2, 'From equation 1, express y directly', 'y = \\dfrac{' + _fmtNum(c) + '}{' + _fmtNum(bc) + '}', true));
        steps.push(_stepDiv(3, 'Substitute into equation 2 and solve for x', null, false));
    }
    steps.push(_stepDiv(4, 'Back-substitute to find both variables', null, false));
    return steps;
}

// ==================== Matrix Steps ====================

function _matrixSteps(A, b) {
    var n = A.length;
    var steps = [];
    steps.push(_stepDiv(1, 'Express as matrix equation AX = b',
        _matrixLatex(A) + ' \\mathbf{x} = ' + _matrixLatex(b.map(function(v) { return [v]; })), true));
    var det = n === 2 ? _det2(A) : _det3(A);
    steps.push(_stepDiv(2, 'Verify A is invertible: det(A) \u2260 0', '\\det(A) = ' + _fmtNum(det), false));
    if (Math.abs(det) > 1e-12) {
        steps.push(_stepDiv(3, 'Compute X = A\u207B\u00B9b using Gaussian elimination', null, false));
    }
    return steps;
}

// ==================== All Methods HTML ====================

function _allMethodsHTML(A, b, size, vars) {
    vars = vars || (size === 2 ? ['x', 'y'] : ['x', 'y', 'z']);
    var methods = size === 2
        ? ['cramer', 'gaussian', 'substitution', 'matrix']
        : ['cramer', 'gaussian', 'matrix'];

    var html = '<div style="display:flex;flex-direction:column;gap:1.25rem;">';
    for (var m = 0; m < methods.length; m++) {
        var method = methods[m];
        var sol = _runSolver(A, b, method, size);
        var badge = '<span style="display:inline-block;padding:0.125rem 0.5rem;border-radius:1rem;background:rgba(16,185,129,0.1);color:#10b981;font-size:0.7rem;font-weight:600;margin-bottom:0.5rem;">' + _methodLabel(method) + '</span>';
        html += '<div style="border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;padding:1rem;">';
        html += badge;
        if (sol) {
            var parts = vars.map(function(v, k) { return v + ' = ' + _fmtNum(sol[k]); });
            html += '<div data-latex="' + parts.join(', \\;').replace(/"/g, '&quot;') + '" data-display="false"></div>';
        } else {
            html += '<div style="color:#ef4444;font-size:0.8rem;">No unique solution (singular matrix)</div>';
        }
        html += '</div>';
    }
    html += '</div>';
    return html;
}

// ==================== Result HTML Builders ====================

function _methodLabel(method) {
    return { cramer: "Cramer's Rule", gaussian: 'Gaussian Elimination', substitution: 'Substitution', matrix: 'Matrix Method', all: 'All Methods' }[method] || method;
}

// Diagnose a singular system: 'inconsistent' (parallel) or 'dependent' (same line/plane)
function _diagnoseSingular(A, b) {
    // Augmented matrix [A|b] — check if the zero row has a non-zero RHS
    var n = A.length;
    var aug = [];
    for (var i = 0; i < n; i++) {
        aug.push(A[i].slice().concat([b[i]]));
    }
    // Forward elimination (simplified)
    for (var col = 0; col < n; col++) {
        var pivot = -1;
        for (var row = col; row < n; row++) {
            if (Math.abs(aug[row][col]) > 1e-10) { pivot = row; break; }
        }
        if (pivot === -1) continue;
        var tmp = aug[col]; aug[col] = aug[pivot]; aug[pivot] = tmp;
        for (var r = col + 1; r < n; r++) {
            var f = aug[r][col] / aug[col][col];
            for (var c = col; c <= n; c++) aug[r][c] -= f * aug[col][c];
        }
    }
    // Check zero rows
    for (var i = 0; i < n; i++) {
        var allZero = A[i].every(function(v) { return Math.abs(v) < 1e-10; });
        if (allZero) {
            // Zero row in A — check RHS
            return Math.abs(b[i]) > 1e-10 ? 'inconsistent' : 'dependent';
        }
        // Check post-elimination zero row
        var rowAllZero = true;
        for (var c = 0; c < n; c++) { if (Math.abs(aug[i][c]) > 1e-10) { rowAllZero = false; break; } }
        if (rowAllZero) {
            return Math.abs(aug[i][n]) > 1e-10 ? 'inconsistent' : 'dependent';
        }
    }
    return 'inconsistent';
}

function _buildResultHTML(A, b, method, solution, steps, vars) {
    vars = vars || (A.length === 2 ? ['x', 'y'] : ['x', 'y', 'z']);
    var size = A.length;
    var html = '';

    // System display
    var sysLines = [];
    for (var i = 0; i < size; i++) sysLines.push(_buildEquationLatex(A[i], b[i], vars));
    var sysLatex = '\\begin{cases}' + sysLines.join(' \\\\ ') + '\\end{cases}';

    html += '<div style="text-align:center;margin-bottom:1.25rem;">';
    html += '<span style="display:inline-block;padding:0.25rem 0.75rem;border-radius:1rem;background:rgba(16,185,129,0.1);color:#10b981;font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.75rem;">' + _methodLabel(method) + '</span>';
    html += '<div data-latex="' + sysLatex.replace(/"/g, '&quot;') + '" data-display="true" style="overflow-x:auto;"></div>';
    html += '</div>';

    if (!solution) {
        var diagnosis = _diagnoseSingular(A, b);
        if (diagnosis === 'dependent') {
            html += '<div class="sy-warn-box">' +
                '<strong>Infinitely Many Solutions</strong> &mdash; the equations describe the same line' + (size === 3 ? '/plane' : '') + '. ' +
                'One equation is a multiple of the other. Any point on the line satisfies both equations.</div>';
        } else {
            html += '<div class="sy-warn-box">' +
                '<strong>No Solution</strong> &mdash; the lines are parallel and never intersect. ' +
                'The equations are inconsistent (det\u2009=\u20090).</div>';
        }
        // Still show the steps so the user can see why
        if (steps && steps.length > 0) {
            html += '<button type="button" class="sy-steps-hdr" onclick="this.classList.toggle(\'open\');var bd=this.nextElementSibling;bd.classList.toggle(\'open\');">';
            html += '<span>Step-by-Step</span>';
            html += '<svg class="sy-chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><polyline points="6 9 12 15 18 9"/></svg>';
            html += '</button>';
            html += '<div class="sy-steps-body">';
            for (var ss = 0; ss < steps.length; ss++) html += steps[ss];
            html += '</div>';
        }
        return html;
    }

    // Answer chips
    html += '<div style="text-align:center;margin-bottom:0.75rem;">';
    html += '<div style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#10b981;margin-bottom:0.5rem;">Solution</div>';
    html += '<div class="sy-chips">';
    for (var k = 0; k < vars.length; k++) {
        html += '<span class="sy-chip" data-latex="' + vars[k] + ' = ' + _fmtNum(solution[k]).replace(/"/g, '&quot;') + '" data-display="false"></span>';
    }
    html += '</div></div>';

    // Collapsible steps
    if (steps && steps.length > 0) {
        html += '<button type="button" class="sy-steps-hdr" onclick="this.classList.toggle(\'open\');var bd=this.nextElementSibling;bd.classList.toggle(\'open\');">';
        html += '<span>Step-by-Step Solution</span>';
        html += '<svg class="sy-chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><polyline points="6 9 12 15 18 9"/></svg>';
        html += '</button>';
        html += '<div class="sy-steps-body">';
        for (var s = 0; s < steps.length; s++) html += steps[s];
        html += '</div>';
    }

    // Verification
    html += '<div class="sy-verify-section">';
    html += '<div class="sy-verify-header"><span class="sy-verify-num">&#10003;</span>Verification</div>';
    var allOk = true;
    for (var v = 0; v < size; v++) {
        var lhsVal = 0;
        for (var j = 0; j < size; j++) lhsVal += A[v][j] * solution[j];
        var ok = Math.abs(lhsVal - b[v]) < 1e-6;
        if (!ok) allOk = false;
        html += '<div class="sy-verify-row ' + (ok ? 'sy-verify-ok' : 'sy-verify-fail') + '">' +
            '<span>' + (ok ? '&#10003;' : '&#10007;') + '</span>' +
            '<span>Eq\u00a0' + (v+1) + ':</span>' +
            '<code class="sy-verify-code">' + _fmtNum(lhsVal) + ' = ' + _fmtNum(b[v]) + '</code>' +
            '</div>';
    }
    if (allOk) html += '<div class="sy-verify-ok" style="font-weight:600;margin-top:0.375rem;font-size:0.8rem;">All equations satisfied &#10003;</div>';
    html += '</div>';

    return html;
}

// ==================== Nonlinear Solver (substitution-based) ====================

/**
 * Solve a 2-variable nonlinear system using symbolic substitution.
 * Strategy: for each equation i, solve for each variable v,
 * then substitute the expression into the other equation and solve for the remaining variable.
 * All candidate solutions are verified by residual check before returning.
 *
 * Returns { solutions: [{x:num,y:num},...], trace: {pivotEq,pivotVar,vExpr,reducedExpr} }
 * or null if no approach works.
 */
function _solveNonlinear2(eqs, vars) {
    if (!hasNerdamer() || eqs.length !== 2 || vars.length !== 2) return null;

    function eqExpr(eqStr) {
        var eq = splitEquation(eqStr);
        if (!eq) return null;
        return '(' + eq.lhs + ')-(' + eq.rhs + ')';
    }

    function toTeX(obj) {
        try { return obj.toTeX(); } catch(e) {
            try { return obj.text(); } catch(e2) { return ''; }
        }
    }

    function _isUglyTeX(tex) {
        if (!tex || tex.length < 8) return false;
        if (tex.indexOf('\\frac') >= 0) {
            var nums = tex.match(/\d+/g) || [];
            for (var ni = 0; ni < nums.length; ni++) {
                if (parseInt(nums[ni], 10) > 9999) return true;
            }
        }
        if (tex.length > 60) return true;
        return false;
    }

    // Simplify b√n by extracting perfect square factors: e.g. 1√176 → 4√11.
    function _simplifySqrt(b, n) {
        for (var k = Math.floor(Math.sqrt(n)); k >= 2; k--) {
            if (n % (k * k) === 0) { return { coeff: b * k, rad: n / (k * k) }; }
        }
        return { coeff: b, rad: n };
    }

    // Reconstruct exact form like √6, √11-2, 4√11-10 from a numeric value.
    // Covers ±√n and a ± b√n for small integers — handles common textbook cases.
    function tryExactForm(num) {
        if (!isFinite(num)) return null;
        var absNum = Math.abs(num);
        // Simple ±√n (catches √6, √3, etc.)
        var n0 = Math.round(absNum * absNum);
        if (n0 >= 2 && n0 <= 500) {
            var sq0 = Math.round(Math.sqrt(n0));
            if (sq0 * sq0 !== n0 && Math.abs(Math.sqrt(n0) - absNum) < 1e-6) {
                var s0 = _simplifySqrt(1, n0);
                var bStr0 = s0.coeff === 1 ? '' : String(s0.coeff);
                return (num < 0 ? '-' : '') + bStr0 + '\\sqrt{' + s0.rad + '}';
            }
        }
        // a ± b√n  (handles √11-2, 4√11-10, etc.)
        for (var a = -20; a <= 20; a++) {
            var rem = num - a;
            var absRem = Math.abs(rem);
            if (absRem < 1e-10) continue;
            var signRem = rem > 0 ? 1 : -1;
            for (var b = 1; b <= 10; b++) {
                var sqrtCand = absRem / b;
                var n = Math.round(sqrtCand * sqrtCand);
                if (n < 2 || n > 500) continue;
                var sq = Math.round(Math.sqrt(n));
                if (sq * sq === n) continue;
                if (Math.abs(Math.sqrt(n) - sqrtCand) > 1e-6) continue;
                var simp = _simplifySqrt(b, n);
                var bStr = simp.coeff === 1 ? '' : String(simp.coeff);
                var sqrtTeX = bStr + '\\sqrt{' + simp.rad + '}';
                if (a === 0) return (signRem < 0 ? '-' : '') + sqrtTeX;
                if (signRem > 0 && a > 0) return sqrtTeX + '+' + a;
                if (signRem > 0 && a < 0) return sqrtTeX + '-' + Math.abs(a);
                if (signRem < 0 && a > 0) return String(a) + '-' + sqrtTeX;
                return '-' + sqrtTeX + (a > 0 ? '+' + a : '-' + Math.abs(a));
            }
        }
        return null;
    }

    // Solve symbolically → [{exact, tex, value}].
    // value may be NaN for symbolic expressions depending on another variable.
    // Use numericRoots() to filter to finite values only where needed.
    function solveSymbolic(expr, varName) {
        try {
            var sol = nerdamer.solve(expr, varName);
            var text = sol.text().replace(/^\[|\]$/g, '');
            if (!text) return [];
            var roots = text.split(',').map(function(s) { return s.trim(); }).filter(Boolean);
            return roots.map(function(r) {
                var obj = nerdamer(r);
                var numVal = parseFloat(obj.evaluate().text());
                var tex = toTeX(obj);
                if (isFinite(numVal) && _isUglyTeX(tex)) {
                    tex = tryExactForm(numVal) || ('\\approx ' + parseFloat(numVal.toFixed(4)));
                }
                return { exact: r, tex: tex, value: numVal };
            });
        } catch(e) { return []; }
    }

    function numericRoots(roots) {
        return roots.filter(function(r) { return isFinite(r.value); });
    }

    function checkResidual(sol) {
        try {
            for (var vi = 0; vi < vars.length; vi++) nerdamer.setVar(vars[vi], String(sol[vars[vi]]));
            var r0 = parseFloat(nerdamer(eqExpr(eqs[0])).evaluate().text());
            var r1 = parseFloat(nerdamer(eqExpr(eqs[1])).evaluate().text());
            nerdamer.clearVars();
            return isFinite(r0) && isFinite(r1) && Math.abs(r0) <= 1e-5 && Math.abs(r1) <= 1e-5;
        } catch(e) { nerdamer.clearVars(); return false; }
    }

    // ==================== Try Elimination ====================
    var expr0 = eqExpr(eqs[0]), expr1 = eqExpr(eqs[1]);
    if (expr0 && expr1) {
        var elimCombos = [[1, -1], [-1, 1], [1, 1]];
        for (var ec = 0; ec < elimCombos.length; ec++) {
            var c1 = elimCombos[ec][0], c2 = elimCombos[ec][1];
            try {
                var combined = nerdamer('expand((' + c1 + ')*(' + expr0 + ')+(' + c2 + ')*(' + expr1 + '))');
                var cVars = combined.variables();
                if (cVars.length !== 1) continue;

                var combinedVar = cVars[0];
                var otherVar = vars[0] === combinedVar ? vars[1] : vars[0];
                var opLabel = (c1 === 1 && c2 === -1) ? 'Subtract equation\u00a02 from equation\u00a01' :
                              (c1 === -1 && c2 === 1) ? 'Subtract equation\u00a01 from equation\u00a02' :
                              'Add the equations';

                var roots1 = numericRoots(solveSymbolic(combined.text(), combinedVar));
                if (!roots1.length) continue;

                // Choose simpler equation for back-sub (shorter LHS = fewer terms)
                var eq0p = splitEquation(eqs[0]), eq1p = splitEquation(eqs[1]);
                var backSubEqIdx = (eq0p && eq1p && eq1p.lhs.length < eq0p.lhs.length) ? 1 : 0;

                var allSols = [], backResults = [];
                for (var ri = 0; ri < roots1.length; ri++) {
                    var rootObj = roots1[ri];
                    var backSub = {}; backSub[combinedVar] = rootObj.exact;
                    var backExprStr = eqExpr(eqs[backSubEqIdx]);
                    if (!backExprStr) continue;
                    var backReduced = nerdamer(backExprStr, backSub);
                    var otherRoots = numericRoots(solveSymbolic(backReduced.text(), otherVar));
                    var solsForRoot = [];
                    for (var oi = 0; oi < otherRoots.length; oi++) {
                        var oRoot = otherRoots[oi];
                        var sol = {}; sol[combinedVar] = rootObj.value; sol[otherVar] = oRoot.value;
                        if (!isFinite(sol[vars[0]]) || !isFinite(sol[vars[1]])) continue;
                        if (!checkResidual(sol)) continue;
                        var dup = allSols.some(function(s) {
                            return Math.abs(s[vars[0]] - sol[vars[0]]) < 1e-6 &&
                                   Math.abs(s[vars[1]] - sol[vars[1]]) < 1e-6;
                        });
                        if (!dup) { allSols.push(sol); solsForRoot.push({ value: oRoot.value, tex: oRoot.tex }); }
                    }
                    backResults.push({
                        rootTex: rootObj.tex, rootVal: rootObj.value,
                        otherVar: otherVar, solutions: solsForRoot
                    });
                }

                if (allSols.length > 0) {
                    return {
                        solutions: allSols,
                        trace: {
                            method: 'elimination',
                            c1: c1, c2: c2, opLabel: opLabel,
                            combinedVar: combinedVar, otherVar: otherVar,
                            combinedTeX: toTeX(combined),
                            backSubEqIdx: backSubEqIdx,
                            backSubEqRaw: eqs[backSubEqIdx],
                            roots: roots1,
                            backResults: backResults
                        }
                    };
                }
            } catch(e) { try { nerdamer.clearVars(); } catch(e2) {} }
        }
    }

    // ==================== Substitution Fallback ====================
    // Try all pivots; keep the one that yields the most solutions.
    var bestSub = null;
    for (var i = 0; i < 2; i++) {
        for (var vj = 0; vj < 2; vj++) {
            var k = 1 - i, ov = 1 - vj;
            try {
                var expr_i = eqExpr(eqs[i]);
                if (!expr_i) continue;
                var vSols = solveSymbolic(expr_i, vars[vj]);
                if (!vSols.length) continue;

                var allSols2 = [], traceVExprTeX = vSols[0].tex, traceVExpr = vSols[0].exact;
                var traceReducedTeX = '', traceRootsTeX = [], traceBackTeX = [];

                for (var ve = 0; ve < vSols.length; ve++) {
                    var vExprExact = vSols[ve].exact;
                    var expr_k = eqExpr(eqs[k]);
                    if (!expr_k) continue;
                    var sub = {}; sub[vars[vj]] = vExprExact;
                    var reduced = nerdamer(expr_k, sub);
                    var reducedTeXStr = toTeX(reduced);
                    var otherRoots2 = numericRoots(solveSymbolic(reduced.text(), vars[ov]));
                    // Capture trace fields from first branch only
                    if (!traceReducedTeX && reducedTeXStr) {
                        traceReducedTeX = reducedTeXStr;
                        traceVExpr = vSols[ve].exact;
                        traceVExprTeX = vSols[ve].tex;
                    }
                    for (var or2 = 0; or2 < otherRoots2.length; or2++) {
                        var oRoot2 = otherRoots2[or2];
                        var sub2 = {}; sub2[vars[ov]] = oRoot2.exact;
                        var vjNum = parseFloat(nerdamer(vExprExact, sub2).evaluate().text());
                        var ovNum = oRoot2.value;
                        if (!isFinite(vjNum) || !isFinite(ovNum)) continue;
                        var sol2 = {}; sol2[vars[vj]] = vjNum; sol2[vars[ov]] = ovNum;
                        if (!checkResidual(sol2)) continue;
                        // Only add root to trace if it produced a valid solution
                        var dupRoot = traceRootsTeX.some(function(t) {
                            return t === oRoot2.tex || (isFinite(oRoot2.value) && t === ('\\approx ' + parseFloat(oRoot2.value.toFixed(4))));
                        });
                        if (!dupRoot) traceRootsTeX.push(oRoot2.tex);
                        try {
                            var backObj = nerdamer(vExprExact, sub2);
                            var backTeXStr = toTeX(backObj);
                            if (_isUglyTeX(backTeXStr)) backTeXStr = '\\approx ' + parseFloat(vjNum.toFixed(4));
                            traceBackTeX.push(vars[vj] + ' = ' + backTeXStr);
                        } catch(e) { traceBackTeX.push(vars[vj] + ' \\approx ' + vjNum.toFixed(4)); }
                        var dup2 = allSols2.some(function(s) {
                            return Math.abs(s[vars[vj]] - vjNum) < 1e-6 && Math.abs(s[vars[ov]] - ovNum) < 1e-6;
                        });
                        if (!dup2) allSols2.push(sol2);
                    }
                    // No break — process all branches to collect all solutions
                }

                if (allSols2.length > 0 && (!bestSub || allSols2.length > bestSub.solutions.length)) {
                    bestSub = {
                        solutions: allSols2,
                        trace: {
                            method: 'substitution',
                            pivotEq: i, pivotVar: vars[vj], otherVar: vars[ov],
                            vExpr: traceVExpr, vExprTeX: traceVExprTeX,
                            reducedTeX: traceReducedTeX,
                            rootsTeX: traceRootsTeX, backTeX: traceBackTeX
                        }
                    };
                }
            } catch(ex) { try { nerdamer.clearVars(); } catch(e) {} }
        }
    }
    return bestSub || null;
}

function _nonlinearResidual(eqStr, vars, vals, vj, ov) {
    // vals[0]=vars[vj] value, vals[1]=vars[ov] value
    var eq = splitEquation(eqStr);
    if (!eq) return Infinity;
    try {
        var sub = {};
        sub[vars[vj]] = String(vals[0]);
        sub[vars[ov]] = String(vals[1]);
        nerdamer.setVar(vars[vj], String(vals[0]));
        nerdamer.setVar(vars[ov], String(vals[1]));
        var res = parseFloat(nerdamer('(' + eq.lhs + ')-(' + eq.rhs + ')').evaluate().text());
        nerdamer.clearVars();
        return isFinite(res) ? res : Infinity;
    } catch(ex) { nerdamer.clearVars(); return Infinity; }
}

function _fmtSolNum(n) {
    if (!isFinite(n)) return String(n);
    // Show as fraction-like if close to simple value
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return parseFloat(n.toFixed(6)).toString();
}

function _buildNonlinearResult(info) {
    var eqs = info.eqs, vars = info.vars;

    // Populate graph state — always set so tab shows up
    state._nlEqs = eqs;
    state._nlVars = vars;
    state._nlSolutions = [];

    var sysLatex = '\\begin{cases}' + eqs.map(function(e) {
        var eq = splitEquation(e); return eq ? eq.lhs + ' = ' + eq.rhs : e;
    }).join(' \\\\ ') + '\\end{cases}';

    var html = '<div class="sy-system-display">';
    html += '<span class="sy-sys-badge nonlinear" style="display:inline-flex;margin-bottom:0.75rem;">Nonlinear System</span>';
    html += '<div data-latex="' + sysLatex.replace(/"/g, '&quot;') + '" data-display="true" class="sy-step-math"></div>';
    html += '</div>';

    if (!hasNerdamer() || vars.length !== 2 || eqs.length !== 2) {
        html += '<div class="sy-warn-box">Nonlinear solving requires exactly 2 equations and 2 variables.</div>';
        return html;
    }

    var result = null;
    try { result = _solveNonlinear2(eqs, vars); } catch(ex) { /* null */ }
    if (result && result.solutions) {
        state._nlSolutions = result.solutions;
        // If nerdamer found only numeric approximations (≈), escalate to CAS for exact forms
        var trace0 = result.trace || {};
        var approxOnly = false;
        if (trace0.method === 'substitution') {
            var rTeX = trace0.rootsTeX || [];
            approxOnly = rTeX.length > 0 && rTeX.every(function(t) { return t.indexOf('\\approx') === 0; });
        } else if (trace0.method === 'elimination') {
            var eRoots = trace0.roots || [];
            approxOnly = eRoots.length > 0 && eRoots.every(function(r) { return r.tex && r.tex.indexOf('\\approx') === 0; });
        }
        if (approxOnly) state._sympyNeeded = true;
    }

    if (!result) {
        // Try to detect whether roots exist but are complex (no real intersection)
        var noRealSol = false;
        try {
            if (hasNerdamer()) {
                // Attempt elimination to get a single-var polynomial, then check discriminant
                var eq0 = splitEquation(eqs[0]), eq1 = splitEquation(eqs[1]);
                if (eq0 && eq1) {
                    for (var ci = 0; ci < 2 && !noRealSol; ci++) {
                        var combined = nerdamer(
                            '(' + eq0.lhs + ')-(' + eq0.rhs + ')-(' + (ci === 0 ? 1 : -1) + ')*((' + eq1.lhs + ')-(' + eq1.rhs + '))'
                        );
                        var cRoots = nerdamer.solve(combined.text(), vars[ci]);
                        var cText = cRoots.text().replace(/^\[|\]$/g, '');
                        if (cText && cText.indexOf('i') !== -1 && cText.indexOf(vars[0]) === -1 && cText.indexOf(vars[1]) === -1) {
                            noRealSol = true;
                        }
                    }
                }
            }
        } catch(e) { /* best-effort */ }

        if (noRealSol) {
            html += '<div class="sy-warn-box"><strong>No Real Solutions</strong> &mdash; ' +
                'the curves defined by these equations do not intersect in the real plane. ' +
                'The system has only complex (imaginary) solutions.</div>';
        } else {
            state._sympyNeeded = true;
            html += '<div class="sy-warn-box sy-sympy-pending"><strong>Solving&hellip;</strong></div>';
        }
        return html;
    }

    var solutions = result.solutions;
    var trace = result.trace;
    var label = solutions.length === 1 ? '1\u00a0Solution Found' : solutions.length + '\u00a0Solutions Found';
    var methodTag = trace.method === 'elimination'
        ? '<span class="sy-method-label elim">Elimination</span>'
        : '<span class="sy-method-label subst">Substitution</span>';

    // ── Method label + answer chips ────────────────────────────────────────────
    html += '<div style="text-align:center;">' + methodTag + '</div>';
    html += '<div class="sy-sol-count">' + label + '</div>';
    // If we're about to escalate to CAS for exact forms, show a small indicator
    if (state._sympyNeeded) {
        html += '<div class="sy-sympy-pending" style="font-size:0.75rem;color:var(--text-muted);display:flex;align-items:center;gap:0.4rem;margin-bottom:0.5rem;">' +
            '<svg style="animation:spin 1s linear infinite;width:12px;height:12px;flex-shrink:0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
            '<circle cx="12" cy="12" r="10" stroke-opacity=".2"/><path d="M12 2a10 10 0 0 1 10 10" stroke="#10b981"/></svg>' +
            'Loading exact forms\u2026</div>';
    }
    for (var s = 0; s < solutions.length; s++) {
        var sol = solutions[s];
        html += '<div class="sy-sol-pair">';
        for (var vi = 0; vi < vars.length; vi++) {
            var v = vars[vi], val = _fmtSolNum(sol[v]);
            html += '<span class="sy-chip" data-latex="' + v + ' = ' + val.replace(/"/g, '&quot;') + '" data-display="false"></span>';
        }
        html += '</div>';
    }

    // ── Step-by-step block ─────────────────────────────────────────────────────
    var stepsId = 'sy-nl-steps-' + Date.now();
    html += '<button type="button" class="sy-steps-hdr open" style="margin-top:0.875rem;" onclick="this.classList.toggle(\'open\');document.getElementById(\'' + stepsId + '\').classList.toggle(\'open\');">';
    html += '<span>Step-by-step solution</span>';
    html += '<svg class="sy-chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><polyline points="6 9 12 15 18 9"/></svg>';
    html += '</button>';
    html += '<div class="sy-steps-body open" id="' + stepsId + '">';

    // Step 1: system
    html += _nlStep(1, 'Write the system', sysLatex, true);

    if (trace.method === 'elimination') {
        // ── Elimination path ──────────────────────────────────────────────────

        // Build TeX for each equation's LHS and RHS for the aligned display
        var eq0p = splitEquation(eqs[0]), eq1p = splitEquation(eqs[1]);
        var lhs0T = eq0p ? eq0p.lhs : '', rhs0T = eq0p ? eq0p.rhs : '';
        var lhs1T = eq1p ? eq1p.lhs : '', rhs1T = eq1p ? eq1p.rhs : '';
        try { lhs0T = nerdamer(eq0p.lhs).toTeX(); } catch(e) {}
        try { rhs0T = nerdamer(eq0p.rhs).toTeX(); } catch(e) {}
        try { lhs1T = nerdamer(eq1p.lhs).toTeX(); } catch(e) {}
        try { rhs1T = nerdamer(eq1p.rhs).toTeX(); } catch(e) {}

        var isAdd = (trace.c1 === 1 && trace.c2 === 1);
        var prefix2 = isAdd ? '+' : '-';
        var alignTeX = '\\begin{align*}' +
            ' & ' + lhs0T + ' &&= ' + rhs0T + ' \\\\' +
            prefix2 + '&\\ (' + lhs1T + ') &&= ' + rhs1T + ' \\\\' +
            '\\hline' +
            ' & ' + trace.combinedTeX + ' &&= 0' +
            '\\end{align*}';
        html += _nlStep(2, trace.opLabel, alignTeX, true);

        // Step 3: simplify
        html += _nlStep(3, 'Simplify', trace.combinedTeX + ' = 0', false);

        // Step 4: solve for combinedVar
        var roots4TeX = trace.roots.map(function(r) {
            return trace.combinedVar + ' = ' + r.tex;
        }).join(',\\quad ');
        html += _nlStep(4,
            'Solve \\(' + trace.combinedTeX + ' = 0\\)',
            roots4TeX, false);

        // Step 5: plug roots back into simpler original equation
        var backEqP = splitEquation(trace.backSubEqRaw);
        var backEqStr = backEqP ? backEqP.lhs + ' = ' + backEqP.rhs : trace.backSubEqRaw;
        var backLines5 = [];
        for (var bri = 0; bri < trace.backResults.length; bri++) {
            var br = trace.backResults[bri];
            if (!br.solutions.length) continue;
            var solStr = br.solutions.map(function(os) {
                return br.otherVar + ' = ' + os.tex;
            }).join(',\\;');
            backLines5.push(trace.combinedVar + ' = ' + br.rootTex + ' &\\Rightarrow ' + solStr);
        }
        var backLatex5 = '\\begin{aligned}' + backLines5.join(' \\\\[4pt] ') + '\\end{aligned}';
        html += _nlStep(5, 'Plug roots into \\(' + backEqStr + '\\)', backLatex5, true);

        // Step 6: all solution pairs with exact symbolic forms
        var pairsLines6 = [];
        for (var bri2 = 0; bri2 < trace.backResults.length; bri2++) {
            var br2 = trace.backResults[bri2];
            for (var si2 = 0; si2 < br2.solutions.length; si2++) {
                pairsLines6.push(
                    '(' + br2.otherVar + ' = ' + br2.solutions[si2].tex + ',\\; ' +
                    trace.combinedVar + ' = ' + br2.rootTex + ')'
                );
            }
        }
        var pairsLatex6 = pairsLines6.length === 1
            ? pairsLines6[0]
            : '\\begin{aligned}' + pairsLines6.join(' \\\\') + '\\end{aligned}';
        html += _nlStep(6, solutions.length + '\u00a0solution pair' + (solutions.length > 1 ? 's' : ''),
            pairsLatex6, pairsLines6.length > 1);

    } else {
        // ── Substitution path ─────────────────────────────────────────────────

        // Step 2: isolate pivotVar
        var eq2label = 'Isolate \\(' + trace.pivotVar + '\\) from equation\u00a0' + (trace.pivotEq + 1);
        html += _nlStep(2, eq2label, trace.pivotVar + ' = ' + trace.vExprTeX, false);

        // Step 3: substitute
        var eq3label = 'Substitute into equation\u00a0' + (trace.pivotEq === 0 ? 2 : 1);
        html += _nlStep(3, eq3label, trace.reducedTeX + ' = 0', false);

        // Step 4: solve for otherVar
        var rootsTeX4s = trace.rootsTeX && trace.rootsTeX.length
            ? trace.rootsTeX.map(function(r) { return trace.otherVar + ' = ' + r; }).join(',\\quad ')
            : solutions.map(function(s) { return trace.otherVar + ' = ' + _fmtSolNum(s[trace.otherVar]); }).join(',\\quad ');
        html += _nlStep(4, 'Solve for \\(' + trace.otherVar + '\\)', rootsTeX4s, false);

        // Step 5: back-substitute
        var backLatexS = trace.backTeX && trace.backTeX.length
            ? trace.backTeX.join(',\\quad ')
            : solutions.map(function(s) { return trace.pivotVar + ' = ' + _fmtSolNum(s[trace.pivotVar]); }).join(',\\quad ');
        html += _nlStep(5, 'Back-substitute to find \\(' + trace.pivotVar + '\\)', backLatexS, false);

        // Step 6: solution pairs (numeric, substitution gives fewer solutions typically)
        var pairsLatexS = solutions.length === 1
            ? '(' + vars.map(function(v) { return v + ' = ' + _fmtSolNum(solutions[0][v]); }).join(',\\;') + ')'
            : '\\begin{aligned}' + solutions.map(function(s) {
                return '(' + vars.map(function(v) { return v + ' = ' + _fmtSolNum(s[v]); }).join(',\\;') + ')';
              }).join(' \\\\') + '\\end{aligned}';
        html += _nlStep(6, solutions.length + '\u00a0solution pair' + (solutions.length > 1 ? 's' : ''),
            pairsLatexS, solutions.length > 1);
    }

    // Step 7: verification
    html += '<div class="sy-verify-section">';
    html += '<div class="sy-verify-header">';
    html += '<span class="sy-verify-num">7</span>';
    html += 'Verify \u2014 substitute back into both equations</div>';
    for (var si = 0; si < solutions.length; si++) {
        var s2 = solutions[si];
        var pairLbl = vars.map(function(v) { return v + ' = ' + _fmtSolNum(s2[v]); }).join(', ');
        html += '<div class="sy-verify-pair">' + pairLbl + '</div>';
        for (var ei = 0; ei < eqs.length; ei++) {
            var res = _nonlinearResidual(eqs[ei], vars, [s2[vars[0]], s2[vars[1]]], 0, 1);
            var ok  = Math.abs(res) < 1e-5;
            html += '<div class="sy-verify-row ' + (ok ? 'sy-verify-ok' : 'sy-verify-fail') + '">';
            html += '<span>' + (ok ? '&#10003;' : '&#10007;') + '</span>';
            html += '<span>Eq\u00a0' + (ei + 1) + ':</span>';
            html += '<code class="sy-verify-code">' + eqs[ei] + '</code>';
            if (!ok) html += '<span style="opacity:.7;">(residual: ' + res.toExponential(1) + ')</span>';
            html += '</div>';
        }
    }
    html += '</div>'; // sy-verify-section
    html += '</div>'; // sy-steps-body

    return html;
}

// ==================== SymPy Fallback ====================

function _toPython(s) {
    s = s.trim();
    // ^ → **
    s = s.replace(/\^/g, '**');
    // implicit: digit × letter (2x → 2*x, 3y → 3*y)
    s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
    // ) × ( → )*(
    s = s.replace(/\)\s*\(/g, ')*(');
    // ) × letter/digit → )*letter/digit
    s = s.replace(/\)\s*([a-zA-Z\d])/g, ')*$1');
    return s;
}

function _buildSympyResultHTML(eqs, vars, sympySols) {
    var sysLatex = '\\begin{cases}' + eqs.map(function(e) {
        var eq = splitEquation(e); return eq ? eq.lhs + ' = ' + eq.rhs : e;
    }).join(' \\\\ ') + '\\end{cases}';

    var html = '<div class="sy-system-display">';
    html += '<span class="sy-sys-badge nonlinear" style="display:inline-flex;margin-bottom:0.75rem;">Nonlinear System</span>';
    html += '<div data-latex="' + sysLatex.replace(/"/g, '&quot;') + '" data-display="true" class="sy-step-math"></div>';
    html += '</div>';

    html += '<div style="text-align:center;"><span class="sy-method-label sympy">Symbolic CAS</span></div>';
    var label = sympySols.length === 1 ? '1\u00a0Solution Found' : sympySols.length + '\u00a0Solutions Found';
    html += '<div class="sy-sol-count">' + label + '</div>';

    for (var s = 0; s < sympySols.length; s++) {
        var sol = sympySols[s];
        html += '<div class="sy-sol-pair">';
        for (var vi = 0; vi < vars.length; vi++) {
            var v = vars[vi];
            var entry = sol[v] || {};
            var displayVal = entry.sym || entry.num || '?';
            html += '<span class="sy-chip" data-latex="' + v + ' = ' + displayVal.replace(/"/g, '&quot;') + '" data-display="false"></span>';
            // Show numeric approximation when symbolic form differs
            if (entry.num && entry.sym && entry.sym !== entry.num && entry.num !== 'complex') {
                var numVal = parseFloat(entry.num);
                if (!isNaN(numVal)) {
                    html += '<span class="sy-chip-approx">\u2248\u202f' + parseFloat(numVal.toFixed(4)) + '</span>';
                }
            }
        }
        html += '</div>';
    }

    // Numerical verification
    var realSols = sympySols.filter(function(sol) {
        return vars.every(function(v) { return sol[v] && sol[v].num !== 'complex'; });
    });
    if (realSols.length > 0) {
        html += '<div class="sy-verify-section">';
        html += '<div class="sy-verify-header"><span class="sy-verify-num">&checkmark;</span>Numerical Verification</div>';
        for (var si = 0; si < realSols.length; si++) {
            var rsol = realSols[si];
            var pairLbl = vars.map(function(v) {
                return v + ' \u2248 ' + parseFloat(parseFloat(rsol[v].num).toFixed(4));
            }).join(', ');
            html += '<div class="sy-verify-pair">' + pairLbl + '</div>';
            var vals = vars.map(function(v) { return parseFloat(rsol[v].num); });
            for (var ei = 0; ei < eqs.length; ei++) {
                var res = _nonlinearResidual(eqs[ei], vars, vals, 0, 1);
                var ok = Math.abs(res) < 1e-4;
                html += '<div class="sy-verify-row ' + (ok ? 'sy-verify-ok' : 'sy-verify-fail') + '">';
                html += '<span>' + (ok ? '&#10003;' : '&#10007;') + '</span>';
                html += '<span>Eq\u00a0' + (ei + 1) + ':</span>';
                html += '<code class="sy-verify-code">' + eqs[ei] + '</code>';
                if (!ok) html += '<span style="opacity:.7;">(residual: ' + res.toExponential(1) + ')</span>';
                html += '</div>';
            }
        }
        html += '</div>';
    }

    return html;
}

function _sympyFallback(eqs, vars, container) {
    var pyEqs = eqs.map(function(eq) {
        var parsed = splitEquation(eq);
        if (!parsed) return null;
        return 'Eq(' + _toPython(parsed.lhs) + ', ' + _toPython(parsed.rhs) + ')';
    }).filter(Boolean);

    if (pyEqs.length < 2) return;

    var v0 = vars[0], v1 = vars[1];
    // Build raw expression strings (LHS - RHS) for each equation
    var rawExprs = eqs.map(function(eq) {
        var parsed = splitEquation(eq);
        return parsed ? '(' + _toPython(parsed.lhs) + ')-(' + _toPython(parsed.rhs) + ')' : null;
    }).filter(Boolean);

    if (rawExprs.length < 2) return;

    var code =
        'from sympy import symbols, solve, N, latex, sqrt, Rational\n' +
        'import json\n' +
        v0 + ', ' + v1 + ' = symbols("' + v0 + ' ' + v1 + '", real=True)\n' +
        'eq1 = ' + rawExprs[0] + '\n' +
        'eq2 = ' + rawExprs[1] + '\n' +
        'candidates = []\n' +
        '# Try solving eq1 for ' + v1 + ', substitute into eq2\n' +
        'try:\n' +
        '    ys = solve(eq1, ' + v1 + ')\n' +
        '    for y_expr in (ys or []):\n' +
        '        xs = solve(eq2.subs(' + v1 + ', y_expr), ' + v0 + ')\n' +
        '        candidates.extend([(' + v0 + 'v, y_expr.subs(' + v0 + ', ' + v0 + 'v)) for ' + v0 + 'v in xs])\n' +
        'except: pass\n' +
        '# If nothing, try solving eq1 for ' + v0 + ', substitute into eq2\n' +
        'if not candidates:\n' +
        '    try:\n' +
        '        xs = solve(eq1, ' + v0 + ')\n' +
        '        for x_expr in (xs or []):\n' +
        '            ys = solve(eq2.subs(' + v0 + ', x_expr), ' + v1 + ')\n' +
        '            candidates.extend([(x_expr.subs(' + v1 + ', ' + v1 + 'v), ' + v1 + 'v) for ' + v1 + 'v in ys])\n' +
        '    except: pass\n' +
        '# Filter real solutions only\n' +
        'real_sols = [(xv, yv) for xv, yv in candidates if xv.is_real and yv.is_real]\n' +
        'results = []\n' +
        'for xv, yv in real_sols:\n' +
        '    results.append({\n' +
        '        "' + v0 + '": {"sym": latex(xv), "num": str(float(N(xv, 9)))},\n' +
        '        "' + v1 + '": {"sym": latex(yv), "num": str(float(N(yv, 9)))}\n' +
        '    })\n' +
        'if results:\n' +
        '    print("SOLS:" + json.dumps(results))\n' +
        'else:\n' +
        '    print("NOSOL")';

    var controller = new AbortController();
    var timeoutId = setTimeout(function() { controller.abort(); }, 45000);
    var ctx = window.SYSTEMS_SOLVER_CTX || '';

    fetch(ctx + '/OneCompilerFunctionality?action=execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
        signal: controller.signal
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        clearTimeout(timeoutId);
        var stdout = (data.Stdout || data.stdout || '').trim();
        var warnBox = container.querySelector('.sy-sympy-pending');

        if (stdout.indexOf('NOSOL') !== -1) {
            if (warnBox) warnBox.outerHTML = '<div class="sy-warn-box"><strong>No Real Solutions</strong> \u2014 This system has no real solutions. The curves do not intersect in the real plane.</div>';
            return;
        }

        if (!stdout || stdout.indexOf('SOLS:') === -1) {
            var errMatch = stdout.match(/ERROR:(.*)/);
            var msg = errMatch ? errMatch[1] : 'Could not parse result.';
            if (warnBox) warnBox.outerHTML = '<div class="sy-warn-box"><strong>Could not solve.</strong> ' + msg + ' Try simplifying the equations or checking for typos.</div>';
            return;
        }

        var solsMatch = stdout.match(/SOLS:([\s\S]*)/);
        if (!solsMatch) return;

        var sympySols;
        try { sympySols = JSON.parse(solsMatch[1].trim()); } catch(e) { return; }
        if (!sympySols || !sympySols.length) return;

        var newHtml = _buildSympyResultHTML(eqs, vars, sympySols);
        container.innerHTML = newHtml;

        // Update graph state with numeric values
        state._nlSolutions = sympySols.map(function(sol) {
            var obj = {};
            vars.forEach(function(v) { obj[v] = sol[v] ? parseFloat(sol[v].num) : NaN; });
            return obj;
        }).filter(function(obj) { return vars.every(function(v) { return isFinite(obj[v]); }); });

        _katexify(container);
        _updateGraphTabVisibility();
        // If user is already on the graph tab, re-render so intersection markers appear
        if (state.activeTab === 'graph') setTimeout(drawGraph, 0);
    })
    .catch(function(err) {
        clearTimeout(timeoutId);
        var warnBox = container.querySelector('.sy-sympy-pending');
        var msg = err.name === 'AbortError' ? 'Request timed out.' : err.message;
        if (warnBox) warnBox.outerHTML = '<div class="sy-warn-box"><strong>Could not solve.</strong> ' + msg + '</div>';
    });
}

// Numbered step builder for nonlinear solutions
function _nlStep(num, title, latex, displayMode) {
    var mathId = 'sy-nl-math-' + num + '-' + Date.now();
    return '<div class="sy-step-item">' +
        '<span class="sy-nl-step-num">' + num + '</span>' +
        '<div class="sy-step-body">' +
        '<div class="sy-nl-step-title">' + _renderInlineMath(title) + '</div>' +
        (latex ? '<div id="' + mathId + '" class="sy-step-math" data-latex="' + latex.replace(/"/g, '&quot;') + '" data-display="' + (displayMode ? 'true' : 'false') + '"></div>' : '') +
        '</div></div>';
}

// ==================== Solver Dispatch ====================

function _runSolver(A, b, method, size) {
    switch (method) {
        case 'cramer':    return size === 2 ? _solveCramer2(A, b) : _solveCramer3(A, b);
        case 'substitution': return size === 2 ? _solveSubstitution2(A, b) : _solveGaussian(A, b);
        case 'gaussian':
        case 'matrix':
        default:          return _solveGaussian(A, b);
    }
}

function _buildSteps(A, b, method, size) {
    if (method === 'cramer')         return size === 2 ? _cramerSteps2(A, b) : _cramerSteps3(A, b);
    if (method === 'gaussian')       return _gaussianSteps(A, b);
    if (method === 'substitution' && size === 2) return _substitutionSteps2(A, b);
    if (method === 'matrix')         return _matrixSteps(A, b);
    return [];
}

// ==================== Solve ====================

function solve() {
    var container = $('sy-result-content');
    if (!container) return;

    try {
        _doSolve(container);
    } catch(err) {
        container.innerHTML =
            '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;' +
            'border-radius:0.5rem;color:#dc2626;font-size:0.875rem;">' +
            '<strong>Error:</strong> ' + (err && err.message ? err.message : String(err)) +
            '<br><small style="opacity:.7;">Check the browser console for details.</small></div>';
    }
}

function _doSolve(container) {
    // Sync equation strings from DOM — normalise Unicode on the way in
    var inputs = document.querySelectorAll('.sy-eq-input');
    for (var i = 0; i < inputs.length; i++) state.equations[i] = _normalizeEq(inputs[i].value);

    var info = classifySystem(state.equations);

    if (!info) {
        container.innerHTML = '<div class="tool-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1D4D0;</div>' +
            '<h3>Enter valid equations</h3>' +
            '<p>Type each equation with an equals sign, e.g. <code>2x + 3y = 8</code></p>' +
            '</div>';
        state._A = null; state._b = null; state._vars = null; state._size = null;
        _updateGraphTabVisibility();
        return;
    }

    if (info._tooFew) {
        container.innerHTML = '<div class="sy-warn-box"><strong>Need at least 2 equations.</strong> ' +
            'Add a second equation using the input below.</div>';
        _updateGraphTabVisibility();
        return;
    }

    if (info._tooMany) {
        container.innerHTML = '<div class="sy-warn-box"><strong>Too many equations.</strong> ' +
            'This solver supports up to 3 equations. Remove the extra equation.</div>';
        _updateGraphTabVisibility();
        return;
    }

    // Overdetermined: more equations than unknowns
    if (info.vars && info.eqs && info.eqs.length > info.vars.length && info.isLinear) {
        container.innerHTML = '<div class="sy-warn-box"><strong>Overdetermined system</strong> &mdash; ' +
            info.eqs.length + ' equations, ' + info.vars.length + ' unknowns. ' +
            'For a unique solution you need the same number of equations as unknowns.</div>';
        _updateGraphTabVisibility();
        return;
    }

    var html = '';

    if (info.isLinear && info.vars.length >= 2 && info.vars.length <= 3 && info.eqs.length === info.vars.length) {
        // Clear nonlinear state when switching to linear
        state._nlEqs = null; state._nlVars = null; state._nlSolutions = null;
        // Linear 2×2 or 3×3 — use existing step generators
        var extracted = info._useFallback
            ? _extractLinearFallback(info.eqs, info.vars)
            : extractLinearSystem(info.eqs, info.vars);
        if (!extracted) {
            container.innerHTML = '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;border-radius:0.5rem;color:#dc2626;font-size:0.875rem;"><strong>Parse error</strong> — could not extract coefficients.</div>';
            return;
        }
        var A = extracted.A, b = extracted.b, size = info.vars.length;

        // Store for graph/export
        state._A = A; state._b = b; state._vars = info.vars; state._size = size;

        if (state.method === 'all') {
            state.lastResult = { solution: _runSolver(A, b, 'gaussian', size) };
            html = _allMethodsHTML(A, b, size, info.vars);
        } else {
            var solution = _runSolver(A, b, state.method, size);
            state.lastResult = { solution: solution };
            var steps = _buildSteps(A, b, state.method, size);
            html = _buildResultHTML(A, b, state.method, solution, steps, info.vars);
        }
    } else {
        // Nonlinear — show spinner then solve via substitution
        state._A = null; state._b = null; state._vars = info.vars; state._size = null;
        state.lastResult = { solution: null };

        // Show a brief "Solving…" indicator so the UI isn't frozen-looking
        container.innerHTML =
            '<div style="display:flex;align-items:center;gap:0.75rem;padding:1.5rem;color:var(--text-secondary);">' +
            '<svg style="animation:spin 1s linear infinite;width:20px;height:20px;flex-shrink:0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10" stroke-opacity=".25"/><path d="M12 2a10 10 0 0 1 10 10" stroke="#10b981"/></svg>' +
            '<span style="font-size:0.875rem;">Solving nonlinear system&hellip;</span>' +
            '</div>';

        // Defer CAS work so spinner renders first
        var _info = info;
        state._sympyNeeded = false;
        setTimeout(function() {
            var nlHtml = _buildNonlinearResult(_info);
            container.innerHTML = nlHtml;
            _katexify(container);
            _updateGraphTabVisibility();
            if (state.activeTab !== 'result') switchTab('result');
            // If nerdamer failed, escalate to SymPy
            if (state._sympyNeeded) {
                _sympyFallback(_info.eqs, _info.vars, container);
            }
        }, 30);
        return; // early return — callback handles the rest
    }

    container.innerHTML = html;
    _katexify(container);

    _updateGraphTabVisibility();
    if (state.activeTab !== 'result') switchTab('result');
}

// ==================== Graph ====================

function drawGraph() {
    if (!G) return;
    var graphContainer = $('sy-graph-container');
    if (graphContainer) {
        graphContainer.innerHTML =
            '<div style="display:flex;align-items:center;justify-content:center;height:100%;gap:0.625rem;color:var(--text-secondary);">' +
            '<svg style="animation:spin 1s linear infinite;width:22px;height:22px;flex-shrink:0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
            '<circle cx="12" cy="12" r="10" stroke-opacity=".2"/><path d="M12 2a10 10 0 0 1 10 10" stroke="#10b981"/></svg>' +
            '<span style="font-size:0.875rem;">Rendering graph\u2026</span></div>';
    }
    if (state._A && state._size === 2) {
        var solution = state.lastResult ? state.lastResult.solution : null;
        G.draw2x2(state._A, state._b, solution, 'sy-graph-container');
    } else if (state._nlEqs && state._nlVars && state._nlVars.length === 2) {
        G.drawNonlinear2(state._nlEqs, state._nlVars, state._nlSolutions || [], 'sy-graph-container');
    } else {
        // Nothing to graph — clear the spinner
        if (graphContainer) graphContainer.innerHTML = '';
    }
}

// ==================== Worksheet ====================

function openWorksheet() {
    if (window.WorksheetEngine && window.WorksheetEngine.open) {
        window.WorksheetEngine.open({
            jsonUrl: 'worksheet/math/algebra/systems_of_linear_equations.json',
            title: 'Systems of Linear Equations',
            accentColor: '#10b981',
            branding: '8gwifi.org',
            defaultCount: 20
        });
    }
}

// ==================== Copy Actions ====================

function copyLatex() { if (E) E.copyLatex(state); }
function copyShareUrl() { if (E) E.copyShareUrl(state); }

// ==================== URL Restore ====================

function restoreFromUrl() {
    if (!E) return false;
    var data = E.parseShareUrl();
    if (!data) return false;
    try {
        if (data.eqs && Array.isArray(data.eqs)) state.equations = data.eqs;
        if (data.mt) state.method = String(data.mt);
        return true;
    } catch(e) {
        return false;
    }
}

// ==================== Event Binding ====================

function bindEvents() {
    // Add equation button
    var addBtn = $('sy-add-eq-btn');
    if (addBtn) addBtn.addEventListener('click', addEquation);

    // Method buttons
    var methodIds = ['cramer', 'gaussian', 'substitution', 'matrix', 'all'];
    for (var m = 0; m < methodIds.length; m++) {
        (function(method) {
            var btn = $('sy-method-' + method);
            if (btn) btn.addEventListener('click', function() { switchMethod(method); solve(); });
        })(methodIds[m]);
    }

    // Tab buttons
    var tabIds = ['result', 'graph'];
    for (var t = 0; t < tabIds.length; t++) {
        (function(tab) {
            var btn = $('sy-tab-' + tab);
            if (btn) btn.addEventListener('click', function() { switchTab(tab); });
        })(tabIds[t]);
    }

    // Solve button
    var solveBtn = $('sy-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', solve);

    // Worksheet buttons
    var wsBtn = $('sy-worksheet-btn');
    var wsToolbarBtn = $('sy-toolbar-worksheet-btn');
    if (wsBtn) wsBtn.addEventListener('click', openWorksheet);
    if (wsToolbarBtn) wsToolbarBtn.addEventListener('click', openWorksheet);

    // Copy LaTeX
    var latexBtn = $('sy-copy-latex-btn');
    if (latexBtn) latexBtn.addEventListener('click', copyLatex);

    // Share
    var shareBtn = $('sy-share-btn');
    if (shareBtn) shareBtn.addEventListener('click', copyShareUrl);
}

// ==================== Init ====================

function init() {
    // Restore URL params
    var restored = restoreFromUrl();
    if (!restored) {
        state.equations = ['2x + 3y = 8', '4x - y = 2'];
    }
    if (state.method) switchMethod(state.method);

    // Render symbolic inputs
    renderEquationInputs();

    bindEvents();

    // Initial tab — result visible, graph hidden
    var panelResult = $('sy-panel-result');
    if (panelResult) panelResult.style.display = 'block';
    var panelGraph = $('sy-panel-graph');
    if (panelGraph) panelGraph.style.display = 'none';
    var tabResult = $('sy-tab-result');
    if (tabResult) tabResult.classList.add('active');

    // Graph tab starts disabled (HTML attribute); _updateGraphTabVisibility controls it

    // Auto-solve on load
    setTimeout(function() {
        _updatePreview();
        solve();
    }, 100);
}

// ==================== Exports ====================

// Preserve _tryNerdamer if it was already set (set inside IIFE above)
var _prevTryNerdamer = window.SystemsSolverCore && window.SystemsSolverCore._tryNerdamer;
window.SystemsSolverCore = {
    init: init,
    loadExample: function(eqs) {
        state.equations = eqs.slice();
        renderEquationInputs();
        _onEquationChange();
        solve();
    }
};
if (_prevTryNerdamer) window.SystemsSolverCore._tryNerdamer = _prevTryNerdamer;

})();

document.addEventListener('DOMContentLoaded', function() {
    window.SystemsSolverCore.init();
});
