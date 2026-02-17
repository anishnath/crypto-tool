/**
 * Linear Solver - Core Orchestration
 * App state, input parsing, mode management, AI integration, solve flow
 */
(function() {
'use strict';

var M = window.LinearSolverMatrix;
var R = window.LinearSolverRender;
var G = window.LinearSolverGraph;
var E = window.LinearSolverExport;

// ==================== State ====================

var state = {
    inputMode: 'text',       // 'text' | 'grid' | 'polynomial'
    method: 'gaussian',
    m: 3,
    n: 3,
    A: null,
    b: null,
    lastResult: null,
    lastMethod: '',
    compilerLoaded: false,
    pendingGraph: null,
    gridInputs: []
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.inputModeToggle = document.querySelectorAll('.ls-input-mode-btn');
    els.textInputSection = document.getElementById('ls-text-input');
    els.gridInputSection = document.getElementById('ls-grid-input');
    els.polyInputSection = document.getElementById('ls-poly-input');
    els.matrixA = document.getElementById('ls-matrix-a');
    els.vectorB = document.getElementById('ls-vector-b');
    els.numEquations = document.getElementById('ls-num-equations');
    els.numVariables = document.getElementById('ls-num-variables');
    els.methodSelect = document.getElementById('ls-method');
    els.solveBtn = document.getElementById('ls-solve-btn');
    els.clearBtn = document.getElementById('ls-clear-btn');
    els.randomBtn = document.getElementById('ls-random-btn');
    els.matrixGrid = document.getElementById('ls-matrix-grid');
    els.polyEquations = document.getElementById('ls-poly-equations');
    els.polyGuess = document.getElementById('ls-poly-guess');
    els.resultContent = document.getElementById('ls-result-content');
    els.resultActions = document.getElementById('ls-result-actions');
    els.emptyState = document.getElementById('ls-empty-state');
    els.stepsArea = document.getElementById('ls-steps-area');
    els.graphContainer = document.getElementById('ls-graph-container');
    els.graphHint = document.getElementById('ls-graph-hint');
    els.compilerIframe = document.getElementById('ls-compiler-iframe');
    els.compilerTemplate = document.getElementById('ls-compiler-template');
    els.tabBtns = document.querySelectorAll('.ls-output-tab');
    els.panels = document.querySelectorAll('.ls-panel');
    els.systemHint = document.getElementById('ls-system-hint');
    els.methodHint = document.getElementById('ls-method-hint');
    els.copyLatexBtn = document.getElementById('ls-copy-latex-btn');
    els.shareBtn = document.getElementById('ls-share-btn');
    els.verifyArea = document.getElementById('ls-verify-area');
}

// ==================== Input Mode Switching ====================

function switchInputMode(mode) {
    state.inputMode = mode;

    // Update toggle buttons
    els.inputModeToggle.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-mode') === mode);
    });

    // Show/hide sections
    if (els.textInputSection) els.textInputSection.style.display = mode === 'text' ? 'block' : 'none';
    if (els.gridInputSection) els.gridInputSection.style.display = mode === 'grid' ? 'block' : 'none';
    if (els.polyInputSection) els.polyInputSection.style.display = mode === 'polynomial' ? 'block' : 'none';

    // Sync data when switching
    if (mode === 'grid') {
        buildGrid();
        syncTextToGrid();
    } else if (mode === 'text' && state.gridInputs.length > 0) {
        syncGridToText();
    }
}

// ==================== Grid Management ====================

function buildGrid() {
    var m = parseInt(els.numEquations.value) || 3;
    var n = parseInt(els.numVariables.value) || 3;
    state.m = m;
    state.n = n;
    state.gridInputs = [];

    var varNames = [];
    for (var j = 0; j < n; j++) varNames.push('x' + (j + 1));

    var html = '<div class="ls-grid-header">';
    for (var j = 0; j < n; j++) {
        html += '<span class="ls-grid-label">' + varNames[j] + '</span>';
    }
    html += '<span class="ls-grid-divider-label">|</span>';
    html += '<span class="ls-grid-label">b</span>';
    html += '</div>';

    for (var i = 0; i < m; i++) {
        html += '<div class="ls-grid-row">';
        for (var j = 0; j < n; j++) {
            html += '<input type="number" step="any" class="ls-grid-cell" id="ls-cell-' + i + '-' + j + '" value="0">';
        }
        html += '<span class="ls-grid-divider">|</span>';
        html += '<input type="number" step="any" class="ls-grid-cell ls-grid-b" id="ls-cell-' + i + '-b" value="0">';
        html += '</div>';
    }

    if (els.matrixGrid) els.matrixGrid.innerHTML = html;

    // Store references
    for (var i = 0; i < m; i++) {
        state.gridInputs[i] = [];
        for (var j = 0; j < n; j++) {
            state.gridInputs[i][j] = document.getElementById('ls-cell-' + i + '-' + j);
        }
        state.gridInputs[i].push(document.getElementById('ls-cell-' + i + '-b'));
    }
}

function syncGridToText() {
    var m = parseInt(els.numEquations.value) || 3;
    var n = parseInt(els.numVariables.value) || 3;
    var aText = '', bText = '';

    for (var i = 0; i < m; i++) {
        var row = [];
        for (var j = 0; j < n; j++) {
            row.push(state.gridInputs[i] && state.gridInputs[i][j] ? state.gridInputs[i][j].value || '0' : '0');
        }
        aText += row.join(' ') + '\n';
        bText += (state.gridInputs[i] && state.gridInputs[i][n] ? state.gridInputs[i][n].value || '0' : '0') + '\n';
    }

    if (els.matrixA) els.matrixA.value = aText.trim();
    if (els.vectorB) els.vectorB.value = bText.trim();
}

function syncTextToGrid() {
    var m = parseInt(els.numEquations.value) || 3;
    var n = parseInt(els.numVariables.value) || 3;
    try {
        var A = parseMatrix(els.matrixA.value, m, n);
        var b = parseVector(els.vectorB.value, m);

        for (var i = 0; i < m; i++) {
            for (var j = 0; j < n; j++) {
                if (state.gridInputs[i] && state.gridInputs[i][j]) {
                    state.gridInputs[i][j].value = A[i][j];
                }
            }
            if (state.gridInputs[i] && state.gridInputs[i][n]) {
                state.gridInputs[i][n].value = b[i];
            }
        }
    } catch (err) {
        // Ignore parsing errors during sync
    }
}

// ==================== Parsing ====================

function parseMatrix(text, rows, cols) {
    var lines = text.trim().split('\n').filter(function(r) { return r.trim(); });
    if (rows === -1) rows = lines.length;
    if (lines.length !== rows) throw new Error('Expected ' + rows + ' rows, got ' + lines.length);

    var matrix = [];
    for (var i = 0; i < rows; i++) {
        var entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
        if (i === 0 && cols === -1) cols = entries.length;
        if (entries.length !== cols) throw new Error('Row ' + (i + 1) + ': expected ' + cols + ' entries, got ' + entries.length);

        var row = entries.map(function(e) {
            var num = parseFloat(e);
            if (!isFinite(num)) throw new Error('Invalid number: ' + e);
            return num;
        });
        matrix.push(row);
    }
    return matrix;
}

function parseVector(text, size) {
    var entries = text.trim().split(/[\s\n,]+/).filter(Boolean);
    if (entries.length !== size) throw new Error('Expected ' + size + ' values, got ' + entries.length);
    return entries.map(function(e) {
        var num = parseFloat(e);
        if (!isFinite(num)) throw new Error('Invalid number: ' + e);
        return num;
    });
}

function parsePolynomialEquations(text, numVars) {
    var lines = text.trim().split('\n').filter(function(l) { return l.trim(); });
    var equations = [];

    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.indexOf('=') === -1) throw new Error("Equation must contain '=': " + line);
        var parts = line.split('=');
        if (parts.length !== 2) throw new Error('Invalid equation format: ' + line);
        equations.push({ left: parts[0].trim(), right: parts[1].trim(), original: line.trim() });
    }

    if (equations.length < numVars) throw new Error('Need at least ' + numVars + ' equations for ' + numVars + ' variables');
    return equations.slice(0, numVars);
}

// ==================== Solve ====================

function solve() {
    if (state.inputMode === 'grid') syncGridToText();

    try {
        if (state.inputMode === 'polynomial') {
            solvePolynomial();
            return;
        }

        var m = parseInt(els.numEquations.value) || 3;
        var n = parseInt(els.numVariables.value) || 3;

        if (m < 1 || m > 10 || n < 1 || n > 10) throw new Error('Dimensions must be between 1 and 10');

        var A = parseMatrix(els.matrixA.value, m, n);
        var b = parseVector(els.vectorB.value, m);
        var method = els.methodSelect.value;

        state.A = A;
        state.b = b;

        // Validate method compatibility
        if ((method === 'lu' || method === 'cramer' || method === 'inverse') && m !== n) {
            throw new Error(method.toUpperCase() + ' requires a square system. Current: ' + m + '×' + n);
        }
        if (method === 'cramer' && n > 4) {
            throw new Error("Cramer's rule is only efficient for n ≤ 4");
        }

        var result, methodName;

        switch (method) {
            case 'gaussian':
                result = M.solveGaussian(A, b);
                methodName = 'Gaussian Elimination';
                break;
            case 'gauss-jordan':
                result = M.solveGaussJordan(A, b);
                methodName = 'Gauss-Jordan (RREF)';
                break;
            case 'lu':
                result = M.solveLU(A, b);
                methodName = 'LU Decomposition';
                break;
            case 'cramer':
                result = M.solveCramer(A, b);
                methodName = "Cramer's Rule";
                break;
            case 'inverse':
                result = M.solveInverse(A, b);
                methodName = 'Matrix Inverse';
                break;
            case 'least-squares':
                result = M.solveLeastSquares(A, b);
                methodName = 'Least Squares';
                break;
            default:
                // Auto-select
                if (m > n) {
                    result = M.solveLeastSquares(A, b);
                    methodName = 'Least Squares (auto)';
                } else {
                    result = M.solveGaussian(A, b);
                    methodName = 'Gaussian Elimination (auto)';
                }
        }

        state.lastResult = result;
        state.lastMethod = methodName;

        displayResult(result, methodName, A, b);

    } catch (err) {
        showError(err.message);
    }
}

function solvePolynomial() {
    try {
        var numVars = 2; // default
        var polyVarsEl = document.getElementById('ls-poly-vars');
        if (polyVarsEl) numVars = parseInt(polyVarsEl.value) || 2;

        var guessText = els.polyGuess.value || '1, 1';
        var guess = guessText.split(',').map(function(v) { return parseFloat(v.trim()); });

        if (guess.length !== numVars || guess.some(isNaN)) {
            throw new Error('Initial guess must have ' + numVars + ' numbers');
        }

        var equations = parsePolynomialEquations(els.polyEquations.value, numVars);
        var result = M.solvePolynomialSystem(equations, numVars, guess);

        state.lastResult = result;
        state.lastMethod = 'Newton-Raphson';

        displayResult(result, 'Newton-Raphson', null, null);

    } catch (err) {
        showError(err.message);
    }
}

// ==================== Display ====================

function displayResult(result, methodName, A, b) {
    if (!els.resultContent) return;

    var html;
    switch (result.type) {
        case 'unique':
            html = R.renderUniqueResult(result, methodName);
            break;
        case 'least-squares':
            html = R.renderLeastSquaresResult(result, methodName);
            break;
        case 'matrix-solution':
            html = R.renderMatrixResult(result, methodName);
            break;
        case 'inconsistent':
            html = R.renderInconsistentResult(result);
            break;
        case 'infinite':
            html = R.renderInfiniteResult(result);
            break;
        case 'polynomial-solution':
            html = R.renderPolynomialResult(result);
            break;
        default:
            html = '<p>Unknown result type</p>';
    }

    els.resultContent.innerHTML = html;
    if (els.emptyState) els.emptyState.style.display = 'none';

    // Post-render KaTeX
    R.postRenderResult(result);

    // Show action buttons
    if (els.resultActions && result.type !== 'inconsistent') {
        els.resultActions.style.display = 'flex';
    }

    // Render local steps
    if (result.steps && result.steps.length > 0) {
        R.renderSteps(result.steps, els.stepsArea);
    }

    // Verification (for unique solutions of Ax=b)
    if (els.verifyArea && A && b && result.solution && !Array.isArray(result.solution[0])) {
        R.renderVerification(A, result.solution, b, els.verifyArea);
    }

    // Prepare graph
    if (A && b && result.solution && !Array.isArray(result.solution[0])) {
        var n = A[0].length;
        if (n === 2) {
            state.pendingGraph = { type: '2d', A: A, b: b, solution: result.solution };
        } else if (n === 3) {
            state.pendingGraph = { type: '3d', A: A, b: b, solution: result.solution };
        }

        if (els.graphHint) els.graphHint.style.display = 'none';

        // If graph tab is active, render immediately
        var graphPanel = document.getElementById('ls-panel-graph');
        if (graphPanel && graphPanel.classList.contains('active')) {
            renderPendingGraph();
        }
    }
}

function showError(message) {
    if (!els.resultContent) return;
    els.resultContent.innerHTML = '<div class="ls-error"><h4>Error</h4><p>' + message + '</p></div>';
    if (els.emptyState) els.emptyState.style.display = 'none';
    if (els.resultActions) els.resultActions.style.display = 'none';
}

// ==================== Graph ====================

function renderPendingGraph() {
    if (!state.pendingGraph) return;
    G.loadPlotly(function() {
        if (state.pendingGraph.type === '2d') {
            G.render2D(els.graphContainer, state.pendingGraph.A, state.pendingGraph.b, state.pendingGraph.solution);
        } else if (state.pendingGraph.type === '3d') {
            G.render3D(els.graphContainer, state.pendingGraph.A, state.pendingGraph.b, state.pendingGraph.solution);
        }
    });
}

// ==================== Random Examples ====================

function generateRandom() {
    var m = parseInt(els.numEquations.value) || 3;
    var n = parseInt(els.numVariables.value) || 3;
    var A = [], b = [];

    for (var i = 0; i < m; i++) {
        A[i] = [];
        for (var j = 0; j < n; j++) {
            A[i][j] = Math.floor(Math.random() * 21) - 10;
        }
        b[i] = Math.floor(Math.random() * 21) - 10;
    }

    if (els.matrixA) els.matrixA.value = A.map(function(row) { return row.join(' '); }).join('\n');
    if (els.vectorB) els.vectorB.value = b.join('\n');

    if (state.inputMode === 'grid') {
        syncTextToGrid();
    }

    setTimeout(solve, 50);
}

function loadExample(type) {
    // Polynomial examples
    var polyExamples = {
        'poly-circle-line': { vars: 2, equations: 'x^2 + y^2 = 25\nx + y = 7', guess: '3, 4' },
        'poly-two-parabolas': { vars: 2, equations: 'y = x^2\nx = y^2 - 2', guess: '1, 1' },
        'poly-ellipse-hyperbola': { vars: 2, equations: 'x^2/4 + y^2/9 = 1\nx*y = 1', guess: '1, 1' },
        'poly-3var': { vars: 3, equations: 'x^2 + y + z = 6\nx + y^2 + z = 6\nx + y + z^2 = 6', guess: '1, 1, 1' },
        'poly-trig': { vars: 2, equations: 'sin(x) + y = 1\nx + cos(y) = 1', guess: '0.5, 0.5' }
    };

    var polyEx = polyExamples[type];
    if (polyEx) {
        switchInputMode('polynomial');
        var polyVarsEl = document.getElementById('ls-poly-vars');
        if (polyVarsEl) polyVarsEl.value = polyEx.vars;
        if (els.polyEquations) els.polyEquations.value = polyEx.equations;
        if (els.polyGuess) els.polyGuess.value = polyEx.guess;
        setTimeout(solve, 50);
        return;
    }

    // Linear examples
    switchInputMode('text');

    var examples = {
        'unique-3x3': { m: 3, n: 3, A: '2 1 -1\n-3 -1 2\n-2 1 2', b: '8\n-11\n-3', method: 'gaussian' },
        '2d-system': { m: 2, n: 2, A: '2 -1\n1 1', b: '1\n3', method: 'gaussian' },
        'overdetermined': { m: 4, n: 3, A: '1 1 1\n2 1 0\n1 2 1\n1 0 2', b: '6\n5\n8\n7', method: 'least-squares' },
        'underdetermined': { m: 2, n: 3, A: '1 2 1\n2 1 3', b: '4\n7', method: 'gaussian' },
        'cramer-2x2': { m: 2, n: 2, A: '3 2\n1 4', b: '7\n6', method: 'cramer' },
        'lu-3x3': { m: 3, n: 3, A: '1 2 3\n4 5 6\n7 8 10', b: '6\n15\n25', method: 'lu' }
    };

    var ex = examples[type];
    if (!ex) return;

    if (els.numEquations) els.numEquations.value = ex.m;
    if (els.numVariables) els.numVariables.value = ex.n;
    if (els.matrixA) els.matrixA.value = ex.A;
    if (els.vectorB) els.vectorB.value = ex.b;
    if (els.methodSelect) els.methodSelect.value = ex.method;

    updateHints();
    setTimeout(solve, 50);
}

// ==================== Hints ====================

function updateHints() {
    var m = parseInt(els.numEquations.value) || 3;
    var n = parseInt(els.numVariables.value) || 3;
    var method = els.methodSelect ? els.methodSelect.value : 'gaussian';

    if (els.systemHint) {
        if (m === n) {
            els.systemHint.textContent = 'Square system (m = n)';
            els.systemHint.style.color = 'var(--success, #10b981)';
        } else if (m > n) {
            els.systemHint.textContent = 'Overdetermined (m > n) — use Least Squares';
            els.systemHint.style.color = 'var(--warning, #f59e0b)';
        } else {
            els.systemHint.textContent = 'Underdetermined (m < n) — infinite solutions';
            els.systemHint.style.color = 'var(--info, #3b82f6)';
        }
    }

    if (els.methodHint) {
        if ((method === 'lu' || method === 'cramer' || method === 'inverse') && m !== n) {
            els.methodHint.textContent = 'This method requires a square system';
            els.methodHint.style.color = 'var(--error, #ef4444)';
        } else {
            els.methodHint.textContent = '';
        }
    }
}

// ==================== Clear ====================

function clearAll() {
    if (els.matrixA) els.matrixA.value = '';
    if (els.vectorB) els.vectorB.value = '';
    if (els.polyEquations) els.polyEquations.value = '';

    if (state.inputMode === 'grid') buildGrid();

    if (els.resultContent) els.resultContent.innerHTML = '';
    if (els.emptyState) els.emptyState.style.display = 'flex';
    if (els.resultActions) els.resultActions.style.display = 'none';
    if (els.stepsArea) els.stepsArea.innerHTML = '';
    if (els.verifyArea) els.verifyArea.innerHTML = '';
    if (els.graphHint) els.graphHint.style.display = 'block';

    state.lastResult = null;
    state.pendingGraph = null;
}

// ==================== Event Binding ====================

function init() {
    initDOM();

    // Input mode toggle
    els.inputModeToggle.forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchInputMode(this.getAttribute('data-mode'));
        });
    });

    // Solve button
    if (els.solveBtn) els.solveBtn.addEventListener('click', solve);

    // Clear button
    if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

    // Random button
    if (els.randomBtn) els.randomBtn.addEventListener('click', generateRandom);

    // Dimension changes
    if (els.numEquations) {
        els.numEquations.addEventListener('change', function() { updateHints(); if (state.inputMode === 'grid') buildGrid(); });
        els.numEquations.addEventListener('input', updateHints);
    }
    if (els.numVariables) {
        els.numVariables.addEventListener('change', function() { updateHints(); if (state.inputMode === 'grid') buildGrid(); });
        els.numVariables.addEventListener('input', updateHints);
    }

    // Method change
    if (els.methodSelect) els.methodSelect.addEventListener('change', updateHints);

    // Output tabs
    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            els.tabBtns.forEach(function(b) { b.classList.remove('active'); });
            els.panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            var targetPanel = document.getElementById('ls-panel-' + panel);
            if (targetPanel) targetPanel.classList.add('active');

            if (panel === 'graph' && state.pendingGraph) {
                renderPendingGraph();
            }
            if (panel === 'python' && !state.compilerLoaded) {
                loadCompiler();
                state.compilerLoaded = true;
            }
        });
    });

    // Action buttons
    if (els.copyLatexBtn) {
        els.copyLatexBtn.addEventListener('click', function() {
            if (state.A && state.b && state.lastResult && state.lastResult.solution) {
                E.copyLatex(state.A, state.b, state.lastResult.solution, state.lastMethod);
            }
        });
    }

    if (els.shareBtn) {
        els.shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Compiler template change
    if (els.compilerTemplate) {
        els.compilerTemplate.addEventListener('change', function() {
            loadCompiler();
        });
    }

    // Example chips
    document.querySelectorAll('[data-example]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    });

    // FAQ toggle
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // Load from URL
    var shared = E.parseShareUrl();
    if (shared) {
        if (shared.A && shared.b) {
            if (els.matrixA) els.matrixA.value = shared.A.map(function(row) { return row.join(' '); }).join('\n');
            if (els.vectorB) els.vectorB.value = shared.b.join('\n');
            if (shared.method && els.methodSelect) els.methodSelect.value = shared.method;
            var m = shared.A.length;
            var n = shared.A[0].length;
            if (els.numEquations) els.numEquations.value = m;
            if (els.numVariables) els.numVariables.value = n;
            updateHints();
            setTimeout(solve, 300);
        }
    }

    updateHints();
}

function loadCompiler() {
    if (!els.compilerIframe || !state.A || !state.b) return;
    var template = els.compilerTemplate ? els.compilerTemplate.value : 'numpy';
    var contextMeta = document.querySelector('meta[name="context-path"]');
    var contextPath = contextMeta ? contextMeta.content : '';
    els.compilerIframe.src = E.getCompilerUrl(template, state.A, state.b, contextPath);
}

// ==================== Init on DOM Ready ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
