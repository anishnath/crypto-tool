/**
 * Vector Calculator - Core Orchestration
 * State management, event binding, calculation flow
 */
(function() {
'use strict';

var R = window.VecCalcRender;
var G = window.VecCalcGraph;
var E = window.VecCalcExport;

// ==================== State ====================

var state = {
    mode: 'add',
    dim: 3,
    a: [1, 2, 3],
    b: [4, -1, 2],
    c: [0, 0, 0],
    scalar: 2,
    lastResult: null,
    compilerLoaded: false,
    pendingGraph: null
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.modeBtns = document.querySelectorAll('.vc-mode-btn');
    els.dimBtns = document.querySelectorAll('.vc-dim-btn');
    els.ax = document.getElementById('vc-ax');
    els.ay = document.getElementById('vc-ay');
    els.az = document.getElementById('vc-az');
    els.bx = document.getElementById('vc-bx');
    els.by = document.getElementById('vc-by');
    els.bz = document.getElementById('vc-bz');
    els.cx = document.getElementById('vc-cx');
    els.cy = document.getElementById('vc-cy');
    els.cz = document.getElementById('vc-cz');
    els.scalarInput = document.getElementById('vc-scalar');
    els.vecBGroup = document.getElementById('vc-vecb-group');
    els.vecCGroup = document.getElementById('vc-vecc-group');
    els.scalarGroup = document.getElementById('vc-scalar-group');
    els.zFields = document.querySelectorAll('.vc-z-field');
    els.preview = document.getElementById('vc-preview');
    els.calcBtn = document.getElementById('vc-calc-btn');
    els.clearBtn = document.getElementById('vc-clear-btn');
    els.resultContent = document.getElementById('vc-result-content');
    els.emptyState = document.getElementById('vc-empty-state');
    els.resultActions = document.getElementById('vc-result-actions');
    els.graphHint = document.getElementById('vc-graph-hint');
    els.compilerIframe = document.getElementById('vc-compiler-iframe');
    els.tabBtns = document.querySelectorAll('.vc-output-tab');
    els.panels = document.querySelectorAll('.vc-panel');
    els.copyLatexBtn = document.getElementById('vc-copy-latex-btn');
    els.shareBtn = document.getElementById('vc-share-btn');
}

// ==================== Mode & Dimension ====================

// Modes that need vec b
var NEED_B = ['add', 'subtract', 'dot_product', 'cross_product', 'angle', 'projection', 'rejection', 'area', 'linear_independence', 'triple_scalar'];
// Modes that need vec c
var NEED_C = ['triple_scalar'];
// Modes that need scalar
var NEED_K = ['scalar_multiply'];
// 3D-only modes
var ONLY_3D = ['cross_product', 'triple_scalar'];

function switchMode(mode) {
    // If 2D and mode is 3D-only, ignore
    if (state.dim === 2 && ONLY_3D.indexOf(mode) >= 0) return;

    state.mode = mode;

    els.modeBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-mode') === mode);
    });

    // Show/hide inputs
    if (els.vecBGroup) els.vecBGroup.style.display = NEED_B.indexOf(mode) >= 0 ? 'block' : 'none';
    if (els.vecCGroup) els.vecCGroup.style.display = NEED_C.indexOf(mode) >= 0 ? 'block' : 'none';
    if (els.scalarGroup) els.scalarGroup.style.display = NEED_K.indexOf(mode) >= 0 ? 'block' : 'none';

    updatePreview();
}

function switchDim(dim) {
    state.dim = dim;

    els.dimBtns.forEach(function(btn) {
        btn.classList.toggle('active', parseInt(btn.getAttribute('data-dim')) === dim);
    });

    // Show/hide z fields
    els.zFields.forEach(function(el) {
        el.classList.toggle('hidden', dim === 2);
    });

    // Disable 3D-only modes in 2D
    els.modeBtns.forEach(function(btn) {
        var m = btn.getAttribute('data-mode');
        if (ONLY_3D.indexOf(m) >= 0) {
            btn.classList.toggle('disabled', dim === 2);
            if (dim === 2 && state.mode === m) {
                switchMode('add');
            }
        }
    });

    updatePreview();
}

// ==================== Input Parsing ====================

function parseVector(prefix) {
    var x = parseFloat(document.getElementById('vc-' + prefix + 'x').value);
    var y = parseFloat(document.getElementById('vc-' + prefix + 'y').value);
    if (isNaN(x) || isNaN(y)) return null;
    if (state.dim === 2) return [x, y];
    var z = parseFloat(document.getElementById('vc-' + prefix + 'z').value);
    if (isNaN(z)) return null;
    return [x, y, z];
}

// ==================== Calculate ====================

function calculate() {
    var a = parseVector('a');
    if (!a) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Vector a has invalid components.', 2000, 'warning');
        return;
    }
    state.a = a;

    var needB = NEED_B.indexOf(state.mode) >= 0;
    var needC = NEED_C.indexOf(state.mode) >= 0;
    var needK = NEED_K.indexOf(state.mode) >= 0;

    var b = null, c = null, k = null;

    if (needB) {
        b = parseVector('b');
        if (!b) {
            R.showError(els.resultContent, 'Vector b has invalid components.');
            return;
        }
        state.b = b;
    }

    if (needC) {
        c = parseVector('c');
        if (!c) {
            R.showError(els.resultContent, 'Vector c has invalid components.');
            return;
        }
        state.c = c;
    }

    if (needK) {
        k = parseFloat(els.scalarInput.value);
        if (isNaN(k)) {
            R.showError(els.resultContent, 'Please enter a valid scalar.');
            return;
        }
        state.scalar = k;
    }

    var container = els.resultContent;
    if (!container) return;

    var result = null;

    switch (state.mode) {
        case 'add':           result = R.renderAdd(container, a, b, state.dim); break;
        case 'subtract':      result = R.renderSubtract(container, a, b, state.dim); break;
        case 'scalar_multiply': result = R.renderScalarMultiply(container, a, state.scalar, state.dim); break;
        case 'dot_product':   result = R.renderDotProduct(container, a, b, state.dim); break;
        case 'cross_product': result = R.renderCrossProduct(container, a, b); break;
        case 'magnitude':     result = R.renderMagnitude(container, a, state.dim); break;
        case 'unit_vector':   result = R.renderUnitVector(container, a, state.dim); break;
        case 'angle':         result = R.renderAngle(container, a, b, state.dim); break;
        case 'projection':    result = R.renderProjection(container, a, b, state.dim); break;
        case 'rejection':     result = R.renderRejection(container, a, b, state.dim); break;
        case 'area':          result = R.renderArea(container, a, b, state.dim); break;
        case 'triple_scalar': result = R.renderTripleScalar(container, a, b, c); break;
        case 'linear_independence': result = R.renderLinearIndependence(container, a, b, state.dim); break;
    }

    // AI fallback if client computation failed but input was valid
    if (!result) {
        var fallbackBtn = document.createElement('button');
        fallbackBtn.type = 'button';
        fallbackBtn.className = 'vc-steps-btn';
        fallbackBtn.id = 'vc-steps-btn';
        fallbackBtn.innerHTML = '&#128221; Try AI Solution';
        fallbackBtn.addEventListener('click', showAISteps);
        container.appendChild(fallbackBtn);
        if (els.emptyState) els.emptyState.style.display = 'none';
        return;
    }

    state.lastResult = result;

    if (els.emptyState) els.emptyState.style.display = 'none';
    if (els.resultActions) els.resultActions.style.display = 'flex';

    // Prepare graph
    prepareGraph(result);
    if (els.graphHint) els.graphHint.style.display = 'none';

    var graphPanel = document.getElementById('vc-panel-graph');
    if (graphPanel && graphPanel.classList.contains('active')) {
        renderPendingGraph();
    }

    if (state.compilerLoaded) {
        loadCompiler();
    }
}

// ==================== AI Steps ====================

function showAISteps() {
    var stepsBtn = document.getElementById('vc-steps-btn');
    if (stepsBtn) {
        stepsBtn.classList.add('loading');
        stepsBtn.innerHTML = '<span class="vc-spinner"></span> Generating steps\u2026';
    }

    var contextMeta = document.querySelector('meta[name="context-path"]');
    var CTX = contextMeta ? contextMeta.content : '';

    var payload = {
        operation: 'vector',
        expression: JSON.stringify(state.a),
        mode: state.mode,
        variable: 'x'
    };
    if (state.b) payload.answer = JSON.stringify(state.b);

    fetch(CTX + '/CFExamMarkerFunctionality?action=math_steps', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success && data.steps && data.steps.length > 0) {
            var stepsArea = document.createElement('div');
            stepsArea.id = 'vc-ai-steps';
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
            stepsBtn.innerHTML = '&#128221; Try AI Solution';
        }
    });
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    if (previewTimer) clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        if (!els.preview) return;

        var a = parseVector('a');
        if (!a) {
            els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter vector components above\u2026</span>';
            return;
        }

        try {
            var latex = '';
            var b = parseVector('b');
            var aTeX = R.vecTeX(a, 'a');

            switch (state.mode) {
                case 'add':
                    latex = b ? aTeX + ' + ' + R.vecTeX(b, 'b') : aTeX;
                    break;
                case 'subtract':
                    latex = b ? aTeX + ' - ' + R.vecTeX(b, 'b') : aTeX;
                    break;
                case 'scalar_multiply':
                    var k = els.scalarInput ? els.scalarInput.value : '2';
                    latex = k + ' \\cdot ' + aTeX;
                    break;
                case 'dot_product':
                    latex = b ? aTeX + ' \\cdot ' + R.vecTeX(b, 'b') : aTeX;
                    break;
                case 'cross_product':
                    latex = b ? aTeX + ' \\times ' + R.vecTeX(b, 'b') : aTeX;
                    break;
                case 'magnitude':
                    latex = '|' + aTeX + '|';
                    break;
                case 'unit_vector':
                    latex = '\\hat{a} = \\frac{\\vec{a}}{|\\vec{a}|}';
                    break;
                case 'angle':
                    latex = '\\theta = \\angle(\\vec{a}, \\vec{b})';
                    break;
                case 'projection':
                    latex = '\\text{proj}_{\\vec{a}} \\vec{b}';
                    break;
                case 'rejection':
                    latex = '\\text{rej}_{\\vec{a}} \\vec{b}';
                    break;
                case 'area':
                    latex = '\\text{Area of parallelogram}';
                    break;
                case 'triple_scalar':
                    latex = '\\vec{a} \\cdot (\\vec{b} \\times \\vec{c})';
                    break;
                case 'linear_independence':
                    latex = '\\text{Linear independence check}';
                    break;
                default:
                    latex = aTeX;
            }

            R.renderKaTeX(els.preview, latex, true);
        } catch (e) {
            els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid input</span>';
        }
    }, 150);
}

// ==================== Graph ====================

function prepareGraph(result) {
    var vectors = { a: state.a };

    if (NEED_B.indexOf(state.mode) >= 0) {
        vectors.b = state.b;
    }
    if (NEED_C.indexOf(state.mode) >= 0) {
        vectors.c = state.c;
    }

    // Add projection vector for visualization
    if (state.mode === 'projection' && result && result.type === 'vector') {
        vectors.proj = result.result;
    }
    if (state.mode === 'rejection' && result && result.type === 'vector') {
        var p = R.proj(state.a, state.b);
        if (p) vectors.proj = p;
    }

    state.pendingGraph = { vectors: vectors, result: result, mode: state.mode };
}

function renderPendingGraph() {
    if (!state.pendingGraph) return;
    G.loadPlotly(function() {
        var pg = state.pendingGraph;
        if (state.dim === 2) {
            G.renderGraph2D('vc-graph-container', pg.vectors, pg.result, pg.mode);
        } else {
            G.renderGraph3D('vc-graph-container', pg.vectors, pg.result, pg.mode);
        }
    });
}

// ==================== Compiler ====================

function loadCompiler() {
    if (!els.compilerIframe) return;
    var contextMeta = document.querySelector('meta[name="context-path"]');
    var contextPath = contextMeta ? contextMeta.content : '';
    els.compilerIframe.src = E.getCompilerUrl('numpy', state, contextPath);
}

// ==================== Examples ====================

var examples = {
    'add-3d': { mode: 'add', dim: 3, a: [1, 2, 3], b: [4, -1, 2] },
    'dot-3d': { mode: 'dot_product', dim: 3, a: [1, 2, 3], b: [4, -1, 2] },
    'cross-3d': { mode: 'cross_product', dim: 3, a: [1, 2, 3], b: [4, -1, 2] },
    'mag-2d': { mode: 'magnitude', dim: 2, a: [3, 4], b: [0, 0] },
    'angle-2d': { mode: 'angle', dim: 2, a: [1, 0], b: [0, 1] },
    'proj-2d': { mode: 'projection', dim: 2, a: [1, 0], b: [3, 4] },
    'unit-3d': { mode: 'unit_vector', dim: 3, a: [2, 3, 6], b: [0, 0, 0] },
    'triple-3d': { mode: 'triple_scalar', dim: 3, a: [1, 0, 0], b: [0, 1, 0], c: [0, 0, 1] }
};

function loadExample(name) {
    var ex = examples[name];
    if (!ex) return;

    switchDim(ex.dim);
    switchMode(ex.mode);

    setVecInputs('a', ex.a, ex.dim);
    if (ex.b) setVecInputs('b', ex.b, ex.dim);
    if (ex.c) setVecInputs('c', ex.c, ex.dim);

    updatePreview();
    setTimeout(calculate, 50);
}

function setVecInputs(prefix, vals, dim) {
    var xEl = document.getElementById('vc-' + prefix + 'x');
    var yEl = document.getElementById('vc-' + prefix + 'y');
    var zEl = document.getElementById('vc-' + prefix + 'z');
    if (xEl) xEl.value = vals[0] || 0;
    if (yEl) yEl.value = vals[1] || 0;
    if (zEl) zEl.value = dim === 3 ? (vals[2] || 0) : 0;
}

// ==================== URL Loading ====================

function loadFromURL() {
    var shared = E.parseShareUrl();
    if (!shared) return false;

    if (shared.d) switchDim(shared.d);
    if (shared.m) switchMode(shared.m);
    if (shared.a) setVecInputs('a', shared.a, shared.d || 3);
    if (shared.b) setVecInputs('b', shared.b, shared.d || 3);
    if (shared.c) setVecInputs('c', shared.c, shared.d || 3);
    if (shared.k && els.scalarInput) els.scalarInput.value = shared.k;

    updatePreview();
    setTimeout(calculate, 300);
    return true;
}

// ==================== Clear ====================

function clearAll() {
    ['ax', 'ay', 'az', 'bx', 'by', 'bz', 'cx', 'cy', 'cz'].forEach(function(id) {
        var el = document.getElementById('vc-' + id);
        if (el) el.value = '0';
    });
    if (els.scalarInput) els.scalarInput.value = '2';

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
            if (this.classList.contains('disabled')) return;
            switchMode(this.getAttribute('data-mode'));
        });
    });

    // Dimension toggle
    els.dimBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchDim(parseInt(this.getAttribute('data-dim')));
        });
    });

    // Calculate
    if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);

    // Clear
    if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

    // Enter key
    document.querySelectorAll('.vc-vector-row input, #vc-scalar').forEach(function(input) {
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
            var target = document.getElementById('vc-panel-' + panel);
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
    document.querySelectorAll('.vc-vector-row input, #vc-scalar').forEach(function(input) {
        if (input) input.addEventListener('input', updatePreview);
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
