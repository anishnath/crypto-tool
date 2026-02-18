/**
 * Polynomial Calculator - Core Orchestration
 * State management, event binding, calculation flow
 */
(function() {
'use strict';

var R = window.PolyCalcRender;
var G = window.PolyCalcGraph;
var E = window.PolyCalcExport;

// ==================== State ====================

var state = {
    mode: 'add',
    p1: 'x^3+2*x^2-5*x+3',
    p2: 'x^2-4',
    evalX: 2,
    lastResult: null,
    compilerLoaded: false,
    pendingGraph: null
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.modeBtns = document.querySelectorAll('.poly-mode-btn');
    els.p1Input = document.getElementById('poly-p1');
    els.p2Input = document.getElementById('poly-p2');
    els.evalXInput = document.getElementById('poly-eval-x');
    els.p2Group = document.getElementById('poly-p2-group');
    els.evalXGroup = document.getElementById('poly-eval-x-group');
    els.varSelect = document.getElementById('poly-var');
    els.preview = document.getElementById('poly-preview');
    els.calcBtn = document.getElementById('poly-calc-btn');
    els.clearBtn = document.getElementById('poly-clear-btn');
    els.resultContent = document.getElementById('poly-result-content');
    els.emptyState = document.getElementById('poly-empty-state');
    els.resultActions = document.getElementById('poly-result-actions');
    els.graphHint = document.getElementById('poly-graph-hint');
    els.compilerIframe = document.getElementById('poly-compiler-iframe');
    els.compilerTemplate = document.getElementById('poly-compiler-template');
    els.tabBtns = document.querySelectorAll('.poly-output-tab');
    els.panels = document.querySelectorAll('.poly-panel');
    els.copyLatexBtn = document.getElementById('poly-copy-latex-btn');
    els.shareBtn = document.getElementById('poly-share-btn');
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;

    els.modeBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-mode') === mode);
    });

    // Show/hide inputs based on mode
    var needP2 = (mode === 'add' || mode === 'subtract' || mode === 'multiply' || mode === 'divide');
    var needEvalX = (mode === 'evaluate');

    if (els.p2Group) els.p2Group.style.display = needP2 ? 'block' : 'none';
    if (els.evalXGroup) els.evalXGroup.style.display = needEvalX ? 'block' : 'none';

    updatePreview();
}

// ==================== Calculate ====================

function calculate() {
    var p1 = els.p1Input ? els.p1Input.value.trim() : '';
    if (!p1) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a polynomial.', 2000, 'warning');
        return;
    }
    state.p1 = p1;

    var p2 = els.p2Input ? els.p2Input.value.trim() : '';
    state.p2 = p2;

    var evalX = els.evalXInput ? els.evalXInput.value.trim() : '';
    state.evalX = evalX;

    var container = els.resultContent;
    if (!container) return;

    // Validate input is parseable before attempting computation
    var needP2 = (state.mode === 'add' || state.mode === 'subtract' || state.mode === 'multiply' || state.mode === 'divide');
    try {
        nerdamer(p1);
    } catch (e) {
        R.showError(container, 'Invalid polynomial P(x). Check your syntax.');
        return;
    }
    if (needP2) {
        if (!p2) { R.showError(container, 'Please enter Q(x).'); return; }
        try {
            nerdamer(p2);
        } catch (e) {
            R.showError(container, 'Invalid polynomial Q(x). Check your syntax.');
            return;
        }
    }
    if (state.mode === 'evaluate' && !evalX) {
        R.showError(container, 'Please enter a value for x.');
        return;
    }

    var result = null;

    switch (state.mode) {
        case 'add':
            result = R.renderAdd(container, p1, p2);
            break;
        case 'subtract':
            result = R.renderSubtract(container, p1, p2);
            break;
        case 'multiply':
            result = R.renderMultiply(container, p1, p2);
            break;
        case 'divide':
            result = R.renderDivide(container, p1, p2);
            break;
        case 'factor':
            result = R.renderFactor(container, p1);
            break;
        case 'roots':
            result = R.renderRoots(container, p1);
            break;
        case 'evaluate':
            result = R.renderEvaluate(container, p1, evalX);
            break;
    }

    // Only show AI fallback if input was valid but Nerdamer couldn't compute the result
    if (!result) {
        var fallbackBtn = document.createElement('button');
        fallbackBtn.type = 'button';
        fallbackBtn.className = 'poly-steps-btn';
        fallbackBtn.id = 'poly-steps-btn';
        fallbackBtn.innerHTML = '&#128221; Try AI Solution';
        fallbackBtn.addEventListener('click', showAISteps);
        container.appendChild(fallbackBtn);
        if (els.emptyState) els.emptyState.style.display = 'none';
        return;
    }

    state.lastResult = result;

    // Show action buttons
    if (els.emptyState) els.emptyState.style.display = 'none';
    if (els.resultActions) els.resultActions.style.display = 'flex';

    // Prepare graph
    prepareGraph(result);
    if (els.graphHint) els.graphHint.style.display = 'none';

    var graphPanel = document.getElementById('poly-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active')) {
        renderPendingGraph();
    }

    // Update compiler if loaded
    if (state.compilerLoaded) {
        loadCompiler();
    }
}

// ==================== AI Steps ====================

function showAISteps() {
    var stepsBtn = document.getElementById('poly-steps-btn');
    if (stepsBtn) {
        stepsBtn.classList.add('loading');
        stepsBtn.innerHTML = '<span class="poly-spinner"></span> Generating steps\u2026';
    }

    var contextMeta = document.querySelector('meta[name="context-path"]');
    var CTX = contextMeta ? contextMeta.content : '';

    var payload = {
        operation: 'polynomial',
        expression: state.p1,
        mode: state.mode,
        variable: els.varSelect ? els.varSelect.value : 'x'
    };
    if (state.p2 && (state.mode === 'add' || state.mode === 'subtract' || state.mode === 'multiply' || state.mode === 'divide')) {
        payload.answer = state.p2;
    }
    if (state.mode === 'evaluate' && state.evalX) {
        payload.answer = String(state.evalX);
    }

    fetch(CTX + '/CFExamMarkerFunctionality?action=math_steps', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success && data.steps && data.steps.length > 0) {
            var stepsArea = document.createElement('div');
            stepsArea.id = 'poly-ai-steps';
            R.showAISteps(stepsArea, data.steps, data.method || state.mode);
            els.resultContent.appendChild(stepsArea);
        } else {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Could not generate AI steps.', 2000, 'warning');
        }
        if (stepsBtn) stepsBtn.style.display = 'none';
    })
    .catch(function() {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('AI steps request failed.', 2000, 'error');
        if (stepsBtn) {
            stepsBtn.classList.remove('loading');
            stepsBtn.innerHTML = '&#128221; Show AI Steps';
        }
    });
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    if (previewTimer) clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        if (!els.preview) return;

        var p1 = els.p1Input ? els.p1Input.value.trim() : '';
        var p2 = els.p2Input ? els.p2Input.value.trim() : '';

        if (!p1) {
            els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter a polynomial above\u2026</span>';
            return;
        }

        try {
            var p1tex = R.safeTeX(p1);
            var latex = '';

            switch (state.mode) {
                case 'add':
                    latex = p2 ? '(' + p1tex + ') + (' + R.safeTeX(p2) + ')' : 'P(x) = ' + p1tex;
                    break;
                case 'subtract':
                    latex = p2 ? '(' + p1tex + ') - (' + R.safeTeX(p2) + ')' : 'P(x) = ' + p1tex;
                    break;
                case 'multiply':
                    latex = p2 ? '(' + p1tex + ') \\cdot (' + R.safeTeX(p2) + ')' : 'P(x) = ' + p1tex;
                    break;
                case 'divide':
                    latex = p2 ? '\\frac{' + p1tex + '}{' + R.safeTeX(p2) + '}' : 'P(x) = ' + p1tex;
                    break;
                case 'factor':
                    latex = '\\text{factor}\\left(' + p1tex + '\\right)';
                    break;
                case 'roots':
                    latex = p1tex + ' = 0';
                    break;
                case 'evaluate':
                    var xv = els.evalXInput ? els.evalXInput.value.trim() : 'x';
                    latex = 'P(' + (xv || 'x') + ') \\text{ where } P(x) = ' + p1tex;
                    break;
            }

            R.renderKaTeX(els.preview, latex, true);
        } catch (e) {
            els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }, 150);
}

// ==================== Graph ====================

function prepareGraph(result) {
    var polynomials = { p1: state.p1 };
    var roots = null;

    if (state.mode === 'add' || state.mode === 'subtract' || state.mode === 'multiply') {
        polynomials.p2 = state.p2;
        polynomials.result = result.resultText;
    } else if (state.mode === 'divide') {
        polynomials.p2 = state.p2;
        polynomials.result = result.resultText;
    } else if (state.mode === 'roots') {
        roots = result.roots || [];
    } else if (state.mode === 'factor') {
        // Try to find roots for the factored polynomial
        try {
            var rootsRes = nerdamer('roots(' + state.p1 + ')').text();
            roots = rootsRes.replace(/^\[|\]$/g, '').split(',').map(function(r) { return r.trim(); }).filter(function(r) { return r.length > 0; });
        } catch (e) {}
    }

    state.pendingGraph = { polynomials: polynomials, roots: roots };
}

function renderPendingGraph() {
    if (!state.pendingGraph) return;
    G.loadPlotly(function() {
        G.renderGraph('poly-graph-container', state.pendingGraph.polynomials, state.pendingGraph.roots);
    });
}

// ==================== Compiler ====================

function loadCompiler() {
    if (!els.compilerIframe) return;
    var template = els.compilerTemplate ? els.compilerTemplate.value : 'sympy-basic';
    var contextMeta = document.querySelector('meta[name="context-path"]');
    var contextPath = contextMeta ? contextMeta.content : '';
    els.compilerIframe.src = E.getCompilerUrl(template, state, contextPath);
}

// ==================== Examples ====================

var examples = {
    'add-basic': { mode: 'add', p1: 'x^3+2*x^2-5*x+3', p2: 'x^2-4' },
    'sub-basic': { mode: 'subtract', p1: '3*x^3-x^2+4', p2: 'x^3+2*x-1' },
    'mul-binomial': { mode: 'multiply', p1: 'x+1', p2: 'x-2' },
    'div-cubic': { mode: 'divide', p1: 'x^3-1', p2: 'x-1' },
    'factor-quad': { mode: 'factor', p1: 'x^2-5*x+6' },
    'roots-cubic': { mode: 'roots', p1: 'x^3-6*x^2+11*x-6' },
    'eval-quad': { mode: 'evaluate', p1: 'x^2+3*x-4', p2: '', evalX: '2' }
};

function loadExample(name) {
    var ex = examples[name];
    if (!ex) return;

    switchMode(ex.mode);
    if (els.p1Input) els.p1Input.value = ex.p1;
    if (els.p2Input) els.p2Input.value = ex.p2 || '';
    if (els.evalXInput && ex.evalX) els.evalXInput.value = ex.evalX;

    updatePreview();
    setTimeout(calculate, 50);
}

// ==================== URL Loading ====================

function loadFromURL() {
    var shared = E.parseShareUrl();
    if (!shared) return false;

    if (shared.m) switchMode(shared.m);
    if (shared.p1 && els.p1Input) els.p1Input.value = shared.p1;
    if (shared.p2 && els.p2Input) els.p2Input.value = shared.p2;
    if (shared.ex && els.evalXInput) els.evalXInput.value = shared.ex;

    updatePreview();
    setTimeout(calculate, 300);
    return true;
}

// ==================== Clear ====================

function clearAll() {
    if (els.p1Input) els.p1Input.value = '';
    if (els.p2Input) els.p2Input.value = '';
    if (els.evalXInput) els.evalXInput.value = '';

    if (els.resultContent) els.resultContent.innerHTML = '';
    if (els.emptyState) els.emptyState.style.display = 'flex';
    if (els.resultActions) els.resultActions.style.display = 'none';
    if (els.graphHint) els.graphHint.style.display = 'block';

    state.lastResult = null;
    state.pendingGraph = null;
    updatePreview();
}

// ==================== Event Binding ====================

function init() {
    initDOM();

    // Mode toggle
    els.modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    });

    // Calculate
    if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);

    // Clear
    if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

    // Enter key to calculate
    [els.p1Input, els.p2Input, els.evalXInput].forEach(function(input) {
        if (input) {
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); calculate(); }
            });
        }
    });

    // Output tabs
    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            els.tabBtns.forEach(function(b) { b.classList.remove('active'); });
            els.panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            var target = document.getElementById('poly-panel-' + panel);
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

    // Input change -> preview
    [els.p1Input, els.p2Input, els.evalXInput].forEach(function(input) {
        if (input) {
            input.addEventListener('input', updatePreview);
        }
    });

    // Action buttons
    if (els.copyLatexBtn) {
        els.copyLatexBtn.addEventListener('click', function() {
            E.copyLatex(state.mode, state);
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

    // Load from URL or auto-solve default
    if (!loadFromURL()) {
        updatePreview();
        setTimeout(calculate, 300);
    }
}

// ==================== Init ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
