/**
 * Trigonometric Identity Calculator - Core Orchestration
 * Modes: identity | prove
 */
(function() {
'use strict';

var TC = window.TrigCommon;
var G = window.TrigGraph;
var E = window.TrigExport;

// ==================== State ====================

var state = {
    mode: 'identity',
    identityType: 'pythagorean',
    expression: '',
    lhs: '',
    rhs: '',
    lastResult: null,
    compilerLoaded: false,
    pendingGraph: null
};

// ==================== DOM References ====================

var els = {};

function initDOM() {
    els.modeBtns = document.querySelectorAll('.trig-mode-btn');
    els.identitySelect = document.getElementById('trig-identity-type');
    els.identityGroup = document.getElementById('trig-identity-group');
    els.proveGroup = document.getElementById('trig-prove-group');
    els.lhsInput = document.getElementById('trig-lhs');
    els.rhsInput = document.getElementById('trig-rhs');
    els.exprInput = document.getElementById('trig-expr');
    els.exprGroup = document.getElementById('trig-expr-group');
    els.preview = document.getElementById('trig-preview');
    els.calcBtn = document.getElementById('trig-calc-btn');
    els.clearBtn = document.getElementById('trig-clear-btn');
    els.resultContent = document.getElementById('trig-result-content');
    els.emptyState = document.getElementById('trig-empty-state');
    els.resultActions = document.getElementById('trig-result-actions');
    els.tabBtns = document.querySelectorAll('.trig-output-tab');
    els.panels = document.querySelectorAll('.trig-panel');
    els.copyLatexBtn = document.getElementById('trig-copy-latex-btn');
    els.shareBtn = document.getElementById('trig-share-btn');
    els.compilerIframe = document.getElementById('trig-compiler-iframe');
    els.graphHint = document.getElementById('trig-graph-hint');
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;
    els.modeBtns.forEach(function(btn) {
        btn.classList.toggle('active', btn.getAttribute('data-mode') === mode);
    });

    var isIdentity = mode === 'identity';
    if (els.identityGroup) els.identityGroup.style.display = isIdentity ? 'block' : 'none';
    if (els.exprGroup) els.exprGroup.style.display = isIdentity ? 'block' : 'none';
    if (els.proveGroup) els.proveGroup.style.display = isIdentity ? 'none' : 'block';

    updatePreview();
}

// ==================== Preview ====================

function updatePreview() {
    if (!els.preview) return;
    if (state.mode === 'identity') {
        var cat = TC.IDENTITY_CATEGORIES[state.identityType];
        if (cat) {
            TC.renderKaTeX(els.preview, '\\text{' + cat.name + '}', false);
        }
    } else {
        var lhs = (els.lhsInput ? els.lhsInput.value : '').trim();
        var rhs = (els.rhsInput ? els.rhsInput.value : '').trim();
        if (lhs && rhs) {
            TC.renderKaTeX(els.preview, TC.exprToLatex(lhs) + ' = ' + TC.exprToLatex(rhs), false);
        } else if (lhs) {
            TC.renderKaTeX(els.preview, TC.exprToLatex(lhs) + ' = \\; ?', false);
        } else {
            els.preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter LHS and RHS\u2026</span>';
        }
    }
}

// ==================== Identity Mode ====================

function renderIdentity(container, type, expr) {
    container.innerHTML = '';
    var cat = TC.IDENTITY_CATEGORIES[type];
    if (!cat) {
        TC.showError(container, 'Unknown identity category.');
        return;
    }

    var badge = document.createElement('div');
    badge.className = 'trig-result-badge';
    badge.textContent = cat.name;
    container.appendChild(badge);

    var grid = document.createElement('div');
    grid.className = 'trig-identity-grid';

    for (var i = 0; i < cat.identities.length; i++) {
        var id = cat.identities[i];
        var card = document.createElement('div');
        card.className = 'trig-identity-card';

        var title = document.createElement('div');
        title.className = 'trig-identity-card-title';
        title.textContent = id.description;
        card.appendChild(title);

        var math = document.createElement('div');
        math.className = 'trig-identity-card-math';
        TC.renderKaTeX(math, id.latex, true);
        card.appendChild(math);

        grid.appendChild(card);
    }

    container.appendChild(grid);

    // If expression is provided, show substitution
    if (expr && expr.trim()) {
        var subDiv = document.createElement('div');
        subDiv.style.marginTop = '1rem';
        subDiv.appendChild(TC.buildStepDOM('?', 'Apply to expression: <code>' + expr + '</code>', ''));
        container.appendChild(subDiv);
    }

    state.lastResult = { type: type, category: cat };

    // Graph: show sin and cos for visualization
    state.pendingGraph = function() {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [
                { expr: 'sin(x)', label: 'sin(x)' },
                { expr: 'cos(x)', label: 'cos(x)' }
            ]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Prove Mode ====================

function renderProve(container, lhs, rhs) {
    container.innerHTML = '';
    if (!lhs || !rhs) {
        TC.showError(container, 'Enter both LHS and RHS of the identity to prove.');
        return;
    }

    TC.showSpinner(container, 'Proving identity...');

    // Always use AI for proving
    var expression = lhs + ' = ' + rhs;
    TC.callAI('trigonometry', expression, 'prove', 'x', '', function(err, steps, method) {
        if (err) {
            TC.showError(container, 'Error: ' + err);
            return;
        }
        TC.showAISteps(container, steps, method || 'Identity Proof');
    });

    state.lastResult = { lhs: lhs, rhs: rhs };

    // Graph: plot both sides to verify visually
    state.pendingGraph = function() {
        G.renderFunctionPlot('trig-graph-container', {
            functions: [
                { expr: lhs.replace(/\^2/g, '**2'), label: 'LHS' },
                { expr: rhs.replace(/\^2/g, '**2'), label: 'RHS' }
            ]
        });
        if (els.graphHint) els.graphHint.style.display = 'none';
    };
}

// ==================== Calculate ====================

function calculate() {
    var container = els.resultContent;
    if (!container) return;

    if (els.emptyState) els.emptyState.style.display = 'none';
    if (els.resultActions) els.resultActions.style.display = 'flex';

    if (state.mode === 'identity') {
        state.identityType = els.identitySelect ? els.identitySelect.value : 'pythagorean';
        state.expression = els.exprInput ? els.exprInput.value.trim() : '';
        renderIdentity(container, state.identityType, state.expression);
    } else {
        state.lhs = els.lhsInput ? els.lhsInput.value.trim() : '';
        state.rhs = els.rhsInput ? els.rhsInput.value.trim() : '';
        renderProve(container, state.lhs, state.rhs);
    }
}

// ==================== Tab Switching ====================

function switchTab(panel) {
    els.tabBtns.forEach(function(b) { b.classList.toggle('active', b.getAttribute('data-panel') === panel); });
    els.panels.forEach(function(p) { p.classList.toggle('active', p.id === 'trig-panel-' + panel); });

    if (panel === 'graph' && state.pendingGraph) {
        state.pendingGraph();
        state.pendingGraph = null;
    }
    if (panel === 'python' && !state.compilerLoaded && els.compilerIframe) {
        var contextMeta = document.querySelector('meta[name="context-path"]');
        var contextPath = contextMeta ? contextMeta.content : '';
        els.compilerIframe.src = E.getCompilerUrl(state.mode, state, contextPath);
        state.compilerLoaded = true;
    }
}

// ==================== Examples ====================

var EXAMPLES = {
    'id-pythagorean':  { mode: 'identity', type: 'pythagorean' },
    'id-double':       { mode: 'identity', type: 'double_angle' },
    'id-sum2prod':     { mode: 'identity', type: 'sum_to_product' },
    'prove-tansin':    { mode: 'prove', lhs: 'tan(x)^2 - sin(x)^2', rhs: 'tan(x)^2 * sin(x)^2' },
    'prove-cos2x':     { mode: 'prove', lhs: '(1 - cos(2*x)) / sin(2*x)', rhs: 'tan(x)' }
};

function loadExample(key) {
    var ex = EXAMPLES[key];
    if (!ex) return;
    switchMode(ex.mode);
    if (ex.type && els.identitySelect) els.identitySelect.value = ex.type;
    if (ex.lhs && els.lhsInput) els.lhsInput.value = ex.lhs;
    if (ex.rhs && els.rhsInput) els.rhsInput.value = ex.rhs;
    updatePreview();
    calculate();
}

// ==================== Share URL ====================

function loadFromUrl() {
    var data = E.parseShareUrl();
    if (!data) return;
    if (data.m) switchMode(data.m);
    if (data.it && els.identitySelect) els.identitySelect.value = data.it;
    if (data.l && els.lhsInput) els.lhsInput.value = data.l;
    if (data.r && els.rhsInput) els.rhsInput.value = data.r;
    if (data.e && els.exprInput) els.exprInput.value = data.e;
    updatePreview();
    setTimeout(calculate, 100);
}

// ==================== Init ====================

function init() {
    initDOM();

    els.modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchMode(btn.getAttribute('data-mode')); });
    });

    if (els.identitySelect) {
        els.identitySelect.addEventListener('change', function() {
            state.identityType = els.identitySelect.value;
            updatePreview();
        });
    }

    if (els.lhsInput) els.lhsInput.addEventListener('input', updatePreview);
    if (els.rhsInput) els.rhsInput.addEventListener('input', updatePreview);

    if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
    if (els.clearBtn) els.clearBtn.addEventListener('click', function() {
        if (els.lhsInput) els.lhsInput.value = '';
        if (els.rhsInput) els.rhsInput.value = '';
        if (els.exprInput) els.exprInput.value = '';
        if (els.resultContent) els.resultContent.innerHTML = '';
        if (els.emptyState) { els.emptyState.style.display = 'flex'; els.resultContent.appendChild(els.emptyState); }
        if (els.resultActions) els.resultActions.style.display = 'none';
        updatePreview();
    });

    els.tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() { switchTab(btn.getAttribute('data-panel')); });
    });

    if (els.copyLatexBtn) els.copyLatexBtn.addEventListener('click', function() { E.copyLatex(state.mode, state); });
    if (els.shareBtn) els.shareBtn.addEventListener('click', function() { E.copyShareUrl(state); });

    document.querySelectorAll('.trig-example-chip').forEach(function(chip) {
        chip.addEventListener('click', function() { loadExample(chip.getAttribute('data-example')); });
    });

    loadFromUrl();
    updatePreview();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
