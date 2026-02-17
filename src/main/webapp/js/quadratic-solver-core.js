/**
 * Quadratic Solver - Core Orchestration
 * State management, event binding, solve flow, preview updates
 */
(function() {
'use strict';

var R = window.QuadraticSolverRender;
var G = window.QuadraticSolverGraph;
var E = window.QuadraticSolverExport;

// ==================== State ====================

var state = {
    formType: 'standard',   // standard | vertex | factored | inequality
    method: 'all',           // all | formula | completing | factoring
    a: 1, b: 5, c: 6,       // standard-form coefficients (computed from any form)
    vertexA: 1, vertexH: 0, vertexK: 0,
    factorA: 1, factorR1: 0, factorR2: 0,
    operator: '>',
    lastResult: null,
    compilerLoaded: false,
    pendingGraph: false
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.formBtns = document.querySelectorAll('.qs-form-btn');
    els.formSections = {
        standard: document.getElementById('qs-form-standard'),
        vertex: document.getElementById('qs-form-vertex'),
        factored: document.getElementById('qs-form-factored'),
        inequality: document.getElementById('qs-form-inequality')
    };
    els.formHint = document.getElementById('qs-form-hint');

    // Standard inputs
    els.coeffA = document.getElementById('qs-coeff-a');
    els.coeffB = document.getElementById('qs-coeff-b');
    els.coeffC = document.getElementById('qs-coeff-c');

    // Vertex inputs
    els.vertexA = document.getElementById('qs-vertex-a');
    els.vertexH = document.getElementById('qs-vertex-h');
    els.vertexK = document.getElementById('qs-vertex-k');

    // Factored inputs
    els.factorA = document.getElementById('qs-factor-a');
    els.factorR1 = document.getElementById('qs-factor-r1');
    els.factorR2 = document.getElementById('qs-factor-r2');

    // Inequality inputs
    els.ineqA = document.getElementById('qs-ineq-a');
    els.ineqB = document.getElementById('qs-ineq-b');
    els.ineqC = document.getElementById('qs-ineq-c');
    els.ineqOp = document.getElementById('qs-ineq-op');

    // Preview
    els.preview = document.getElementById('qs-preview');

    // Method
    els.methodSelect = document.getElementById('qs-method');

    // Buttons
    els.solveBtn = document.getElementById('qs-solve-btn');
    els.clearBtn = document.getElementById('qs-clear-btn');

    // Output
    els.resultContent = document.getElementById('qs-result-content');
    els.emptyState = document.getElementById('qs-empty-state');
    els.stepsArea = document.getElementById('qs-steps-area');
    els.resultActions = document.getElementById('qs-result-actions');
    els.graphHint = document.getElementById('qs-graph-hint');
    els.compilerIframe = document.getElementById('qs-compiler-iframe');
    els.compilerTemplate = document.getElementById('qs-compiler-template');

    // Tabs
    els.tabBtns = document.querySelectorAll('.qs-output-tab');
    els.panels = document.querySelectorAll('.qs-panel');

    // Action buttons
    els.copyLatexBtn = document.getElementById('qs-copy-latex-btn');
    els.shareBtn = document.getElementById('qs-share-btn');
}

// ==================== Form Type Switching ====================

function switchFormType(type) {
    state.formType = type;

    els.formBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-type') === type);
    });

    Object.keys(els.formSections).forEach(function(key) {
        if (els.formSections[key]) {
            els.formSections[key].style.display = key === type ? 'block' : 'none';
        }
    });

    // Update hint
    if (els.formHint) {
        var hints = {
            standard: 'ax\u00B2 + bx + c = 0',
            vertex: 'a(x \u2212 h)\u00B2 + k = 0',
            factored: 'a(x \u2212 r\u2081)(x \u2212 r\u2082) = 0',
            inequality: 'ax\u00B2 + bx + c \u2277 0'
        };
        els.formHint.textContent = hints[type] || '';
    }

    // Show/hide method selector for inequality
    var methodGroup = document.getElementById('qs-method-group');
    if (methodGroup) {
        methodGroup.style.display = type === 'inequality' ? 'none' : 'block';
    }

    updatePreview();
}

// ==================== Coefficient Reading ====================

function getStandardCoeffs() {
    var a, b, c;

    switch (state.formType) {
        case 'standard':
            a = parseFloat(els.coeffA.value) || 0;
            b = parseFloat(els.coeffB.value) || 0;
            c = parseFloat(els.coeffC.value) || 0;
            break;
        case 'vertex':
            var va = parseFloat(els.vertexA.value) || 0;
            var vh = parseFloat(els.vertexH.value) || 0;
            var vk = parseFloat(els.vertexK.value) || 0;
            state.vertexA = va; state.vertexH = vh; state.vertexK = vk;
            a = va;
            b = -2 * va * vh;
            c = va * vh * vh + vk;
            break;
        case 'factored':
            var fa = parseFloat(els.factorA.value) || 0;
            var fr1 = parseFloat(els.factorR1.value) || 0;
            var fr2 = parseFloat(els.factorR2.value) || 0;
            state.factorA = fa; state.factorR1 = fr1; state.factorR2 = fr2;
            a = fa;
            b = -fa * (fr1 + fr2);
            c = fa * fr1 * fr2;
            break;
        case 'inequality':
            a = parseFloat(els.ineqA.value) || 0;
            b = parseFloat(els.ineqB.value) || 0;
            c = parseFloat(els.ineqC.value) || 0;
            state.operator = els.ineqOp ? els.ineqOp.value : '>';
            break;
        default:
            a = 0; b = 0; c = 0;
    }

    state.a = a; state.b = b; state.c = c;
    return { a: a, b: b, c: c };
}

// ==================== Root Calculation ====================

function calculateRoots(a, b, c) {
    var disc = b * b - 4 * a * c;
    if (disc >= 0) {
        var sqrtDisc = Math.sqrt(disc);
        return { type: 'real', x1: (-b + sqrtDisc) / (2 * a), x2: (-b - sqrtDisc) / (2 * a) };
    } else {
        return { type: 'complex', real: -b / (2 * a), imag: Math.sqrt(-disc) / (2 * a) };
    }
}

// ==================== Inequality Solver ====================

function solveInequalityResult(a, b, c, roots, op) {
    var opSymbol = op === '>=' ? '\u2265' : (op === '<=' ? '\u2264' : op);
    var result = { intervalLatex: '', intervalHtml: '' };

    if (roots.type === 'complex') {
        var allOrNone = (a > 0 && (op === '>' || op === '>=')) || (a < 0 && (op === '<' || op === '<='));
        if (allOrNone) {
            result.intervalLatex = 'x \\in \\mathbb{R}';
            result.intervalHtml = 'x \u2208 \u211D (all real numbers)';
        } else {
            result.intervalLatex = '\\emptyset';
            result.intervalHtml = 'No solution (\u2205)';
        }
        return result;
    }

    var x1 = Math.min(roots.x1, roots.x2);
    var x2 = Math.max(roots.x1, roots.x2);
    var f = R.fmt;

    var needBetween = (a > 0 && (op === '<' || op === '<=')) || (a < 0 && (op === '>' || op === '>='));
    var inclusive = op === '>=' || op === '<=';

    if (needBetween) {
        var lb = inclusive ? '[' : '(';
        var rb = inclusive ? ']' : ')';
        result.intervalLatex = 'x \\in ' + lb + f(x1) + ',\\,' + f(x2) + rb;
        result.intervalHtml = 'x \u2208 ' + lb + f(x1) + ', ' + f(x2) + rb;
    } else {
        var lb1 = '(-\\infty,\\,';
        var rb1 = inclusive ? ']' : ')';
        var lb2 = inclusive ? '[' : '(';
        var rb2 = ',\\,+\\infty)';
        result.intervalLatex = 'x \\in ' + lb1 + f(x1) + rb1 + ' \\cup ' + lb2 + f(x2) + rb2;
        var hLb1 = inclusive ? ']' : ')';
        var hLb2 = inclusive ? '[' : '(';
        result.intervalHtml = 'x \u2208 (-\u221E, ' + f(x1) + hLb1 + ' \u222A ' + hLb2 + f(x2) + ', +\u221E)';
    }

    return result;
}

// ==================== Solve ====================

function solve() {
    var coeffs = getStandardCoeffs();
    var a = coeffs.a, b = coeffs.b, c = coeffs.c;

    if (!a || a === 0) {
        R.showError(els.resultContent, 'Coefficient \'a\' must be non-zero for a quadratic equation.');
        if (els.emptyState) els.emptyState.style.display = 'none';
        if (els.resultActions) els.resultActions.style.display = 'none';
        if (els.stepsArea) els.stepsArea.innerHTML = '';
        return;
    }

    var disc = b * b - 4 * a * c;
    var roots = calculateRoots(a, b, c);
    var method = els.methodSelect ? els.methodSelect.value : 'all';

    var result = {
        a: a, b: b, c: c,
        disc: disc,
        roots: roots,
        method: method,
        formType: state.formType,
        isInequality: state.formType === 'inequality',
        operator: state.operator
    };

    // Inequality interval
    if (result.isInequality) {
        var ineqResult = solveInequalityResult(a, b, c, roots, state.operator);
        result.intervalLatex = ineqResult.intervalLatex;
        result.intervalHtml = ineqResult.intervalHtml;
    }

    state.lastResult = result;

    // Render result
    var html;
    if (result.isInequality) {
        html = R.renderInequality(result);
    } else {
        html = R.renderSolution(result);
    }

    if (els.resultContent) els.resultContent.innerHTML = html;
    if (els.emptyState) els.emptyState.style.display = 'none';

    // Post-render KaTeX
    R.postRenderRoots(result);

    // Show action buttons
    if (els.resultActions) els.resultActions.style.display = 'flex';

    // Render steps
    R.renderSteps(result, els.stepsArea);

    // Prepare graph
    state.pendingGraph = true;
    if (els.graphHint) els.graphHint.style.display = 'none';

    var graphPanel = document.getElementById('qs-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active')) {
        renderPendingGraph();
    }

    // Update compiler if loaded
    if (state.compilerLoaded) {
        loadCompiler();
    }
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    if (previewTimer) clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        if (!els.preview) return;

        var coeffs = getStandardCoeffs();
        var a = coeffs.a, b = coeffs.b, c = coeffs.c;
        var f = R.fmt;

        var latex = '';
        if (state.formType === 'vertex') {
            var va = state.vertexA, vh = state.vertexH, vk = state.vertexK;
            var aStr = va === 1 ? '' : (va === -1 ? '-' : f(va));
            var hSign = vh >= 0 ? '-' : '+';
            var kSign = vk >= 0 ? '+' : '-';
            latex = aStr + '(x ' + hSign + ' ' + f(Math.abs(vh)) + ')^2 ' + kSign + ' ' + f(Math.abs(vk)) + ' = 0';
        } else if (state.formType === 'factored') {
            var fa = state.factorA, fr1 = state.factorR1, fr2 = state.factorR2;
            var faStr = fa === 1 ? '' : (fa === -1 ? '-' : f(fa));
            var r1Sign = fr1 >= 0 ? '-' : '+';
            var r2Sign = fr2 >= 0 ? '-' : '+';
            latex = faStr + '(x ' + r1Sign + ' ' + f(Math.abs(fr1)) + ')(x ' + r2Sign + ' ' + f(Math.abs(fr2)) + ') = 0';
        } else {
            // Standard or inequality
            latex = '';
            if (a === 1) latex += 'x^2';
            else if (a === -1) latex += '-x^2';
            else if (a !== 0) latex += f(a) + 'x^2';

            if (b !== 0) {
                latex += (b > 0 ? ' + ' : ' - ') + (Math.abs(b) === 1 ? '' : f(Math.abs(b))) + 'x';
            }
            if (c !== 0) {
                latex += (c > 0 ? ' + ' : ' - ') + f(Math.abs(c));
            }

            if (state.formType === 'inequality') {
                var opMap = { '>': '>', '<': '<', '>=': '\\geq', '<=': '\\leq' };
                latex += ' ' + (opMap[state.operator] || '>') + ' 0';
            } else {
                latex += ' = 0';
            }
        }

        try {
            katex.render(latex, els.preview, { displayMode: true, throwOnError: false });
        } catch (e) {
            els.preview.textContent = latex;
        }
    }, 100);
}

// ==================== Graph ====================

function renderPendingGraph() {
    if (!state.pendingGraph || !state.lastResult) return;
    G.loadPlotly(function() {
        var r = state.lastResult;
        var ineqOp = r.isInequality ? r.operator : null;
        G.renderParabola('qs-graph-container', r.a, r.b, r.c, r.roots, ineqOp);
    });
}

// ==================== Examples ====================

var examples = {
    'perfect-square': { type: 'standard', a: 1, b: -6, c: 9 },
    'two-roots': { type: 'standard', a: 1, b: 5, c: 6 },
    'complex': { type: 'standard', a: 1, b: 2, c: 5 },
    'difference-squares': { type: 'standard', a: 1, b: 0, c: -16 },
    'vertex-form': { type: 'vertex', a: 2, h: 3, k: -8 },
    'inequality': { type: 'inequality', a: 1, b: -5, c: 6, op: '<' },
    'random': null
};

function loadExample(name) {
    if (name === 'random') {
        var randomExamples = [
            { a: 1, b: 5, c: 6 }, { a: 1, b: -5, c: 6 }, { a: 1, b: 0, c: -16 },
            { a: 2, b: 4, c: -6 }, { a: 1, b: 2, c: 1 }, { a: -1, b: 4, c: -3 },
            { a: 3, b: -12, c: 9 }, { a: 1, b: 0, c: 1 }
        ];
        var ex = randomExamples[Math.floor(Math.random() * randomExamples.length)];
        switchFormType('standard');
        if (els.coeffA) els.coeffA.value = ex.a;
        if (els.coeffB) els.coeffB.value = ex.b;
        if (els.coeffC) els.coeffC.value = ex.c;
        updatePreview();
        setTimeout(solve, 50);
        return;
    }

    var ex = examples[name];
    if (!ex) return;

    switchFormType(ex.type);

    if (ex.type === 'standard') {
        if (els.coeffA) els.coeffA.value = ex.a;
        if (els.coeffB) els.coeffB.value = ex.b;
        if (els.coeffC) els.coeffC.value = ex.c;
    } else if (ex.type === 'vertex') {
        if (els.vertexA) els.vertexA.value = ex.a;
        if (els.vertexH) els.vertexH.value = ex.h;
        if (els.vertexK) els.vertexK.value = ex.k;
    } else if (ex.type === 'inequality') {
        if (els.ineqA) els.ineqA.value = ex.a;
        if (els.ineqB) els.ineqB.value = ex.b;
        if (els.ineqC) els.ineqC.value = ex.c;
        if (els.ineqOp) els.ineqOp.value = ex.op || '>';
    }

    updatePreview();
    setTimeout(solve, 50);
}

// ==================== URL Loading ====================

function loadFromURL() {
    var shared = E.parseShareUrl();
    if (!shared) return false;

    var type = shared.t || 'standard';
    switchFormType(type);

    if (type === 'vertex' && shared.va !== undefined) {
        if (els.vertexA) els.vertexA.value = shared.va;
        if (els.vertexH) els.vertexH.value = shared.vh || 0;
        if (els.vertexK) els.vertexK.value = shared.vk || 0;
    } else if (type === 'factored' && shared.fa !== undefined) {
        if (els.factorA) els.factorA.value = shared.fa;
        if (els.factorR1) els.factorR1.value = shared.fr1 || 0;
        if (els.factorR2) els.factorR2.value = shared.fr2 || 0;
    } else {
        // Standard or inequality
        if (els.coeffA) els.coeffA.value = shared.a || 1;
        if (els.coeffB) els.coeffB.value = shared.b || 0;
        if (els.coeffC) els.coeffC.value = shared.c || 0;

        if (type === 'inequality') {
            if (els.ineqA) els.ineqA.value = shared.a || 1;
            if (els.ineqB) els.ineqB.value = shared.b || 0;
            if (els.ineqC) els.ineqC.value = shared.c || 0;
            if (els.ineqOp && shared.op) els.ineqOp.value = shared.op;
        }
    }

    if (shared.m) {
        if (els.methodSelect) els.methodSelect.value = shared.m;
    }

    updatePreview();
    setTimeout(solve, 300);
    return true;
}

// ==================== Clear ====================

function clearAll() {
    if (els.coeffA) els.coeffA.value = 1;
    if (els.coeffB) els.coeffB.value = 0;
    if (els.coeffC) els.coeffC.value = 0;
    if (els.vertexA) els.vertexA.value = 1;
    if (els.vertexH) els.vertexH.value = 0;
    if (els.vertexK) els.vertexK.value = 0;
    if (els.factorA) els.factorA.value = 1;
    if (els.factorR1) els.factorR1.value = 0;
    if (els.factorR2) els.factorR2.value = 0;
    if (els.ineqA) els.ineqA.value = 1;
    if (els.ineqB) els.ineqB.value = 0;
    if (els.ineqC) els.ineqC.value = 0;

    if (els.resultContent) els.resultContent.innerHTML = '';
    if (els.emptyState) els.emptyState.style.display = 'flex';
    if (els.resultActions) els.resultActions.style.display = 'none';
    if (els.stepsArea) els.stepsArea.innerHTML = '';
    if (els.graphHint) els.graphHint.style.display = 'block';

    state.lastResult = null;
    state.pendingGraph = false;
    updatePreview();
}

// ==================== Compiler ====================

function loadCompiler() {
    if (!els.compilerIframe) return;
    var coeffs = getStandardCoeffs();
    if (!coeffs.a) return;
    var template = els.compilerTemplate ? els.compilerTemplate.value : 'sympy-solve';
    var contextMeta = document.querySelector('meta[name="context-path"]');
    var contextPath = contextMeta ? contextMeta.content : '';
    els.compilerIframe.src = E.getCompilerUrl(template, coeffs.a, coeffs.b, coeffs.c, contextPath);
}

// ==================== Event Binding ====================

function init() {
    initDOM();

    // Form type toggle
    els.formBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchFormType(this.getAttribute('data-type'));
        });
    });

    // Solve
    if (els.solveBtn) els.solveBtn.addEventListener('click', solve);

    // Clear
    if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

    // Output tabs
    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            els.tabBtns.forEach(function(b) { b.classList.remove('active'); });
            els.panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            var target = document.getElementById('qs-panel-' + panel);
            if (target) target.classList.add('active');

            if (panel === 'graph' && state.pendingGraph) {
                renderPendingGraph();
            }
            if (panel === 'python' && !state.compilerLoaded) {
                loadCompiler();
                state.compilerLoaded = true;
            }
        });
    });

    // Method change
    if (els.methodSelect) els.methodSelect.addEventListener('change', function() {
        state.method = this.value;
    });

    // Input change → preview update
    var allInputs = document.querySelectorAll('.qs-coeff-input, #qs-ineq-op');
    allInputs.forEach(function(input) {
        input.addEventListener('input', updatePreview);
        input.addEventListener('change', updatePreview);
    });

    // Action buttons
    if (els.copyLatexBtn) {
        els.copyLatexBtn.addEventListener('click', function() {
            if (state.lastResult) {
                var r = state.lastResult;
                E.copyLatex(r.a, r.b, r.c, r.roots, r.method);
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
        els.compilerTemplate.addEventListener('change', loadCompiler);
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

    // Load from URL or auto-solve
    if (!loadFromURL()) {
        updatePreview();
        setTimeout(solve, 300);
    }
}

// ==================== Init ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
