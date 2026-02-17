/**
 * Percentage Calculator - Core Orchestration
 * State management, events, integration with Render/Export modules
 */
(function() {
'use strict';

var R = window.PctCalcRender;
var E = window.PctCalcExport;

// ==================== State ====================

var state = {
    mode: 'percentOf',
    x: 10, y: 200,
    a: 120, b: 150,
    discPct: 20, finalPrice: 80,
    basePrice: 1000, discPctSim: 15, taxPctSim: 5, qty: 1,
    chainStart: 100, chainSteps: '+10%, -5%, +8%',
    compilerLoaded: false
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function val(id, fallback) {
    var el = $(id);
    if (!el) return fallback || 0;
    return parseFloat(el.value) || fallback || 0;
}

function strVal(id, fallback) {
    var el = $(id);
    if (!el) return fallback || '';
    return el.value || fallback || '';
}

// ==================== Mode Switching ====================

var simpleModes = { percentOf: true, whatPercent: true, increaseBy: true, decreaseBy: true };

var simpleLabels = {
    percentOf:   { x: 'X (percent)', y: 'Y (base)', hint: 'Calculate X% of Y with step-by-step solution' },
    whatPercent:  { x: 'X (value)', y: 'Y (total)', hint: 'X is what percent of Y?' },
    increaseBy:  { x: 'X (percent)', y: 'Y (base value)', hint: 'Increase Y by X%' },
    decreaseBy:  { x: 'X (percent)', y: 'Y (base value)', hint: 'Decrease Y by X%' }
};

function switchMode(mode) {
    state.mode = mode;

    var btns = document.querySelectorAll('.pc-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }

    // Determine which form to show
    var formId = simpleModes[mode] ? 'pc-form-simple' : 'pc-form-' + mode;
    var forms = document.querySelectorAll('.pc-mode-form');
    for (var j = 0; j < forms.length; j++) {
        forms[j].classList.toggle('active', forms[j].id === formId);
    }

    // Update labels for simple modes
    if (simpleModes[mode]) {
        var labels = simpleLabels[mode];
        var xLabel = $('pc-x-label');
        var yLabel = $('pc-y-label');
        var hint = $('pc-simple-hint');
        if (xLabel) xLabel.textContent = labels.x;
        if (yLabel) yLabel.textContent = labels.y;
        if (hint) hint.textContent = labels.hint;
    }

    updatePreview();
}

// ==================== Calculate ====================

function calculate() {
    var container = $('pc-result-content');
    if (!container) return;

    var empty = $('pc-empty-state');
    if (empty) empty.style.display = 'none';

    var actions = $('pc-result-actions');
    if (actions) actions.style.display = 'flex';

    if (state.mode === 'percentOf') {
        state.x = val('pc-x', 10);
        state.y = val('pc-y', 200);
        R.renderPercentOf(container, state.x, state.y);

    } else if (state.mode === 'whatPercent') {
        state.x = val('pc-x', 10);
        state.y = val('pc-y', 200);
        R.renderWhatPercent(container, state.x, state.y);

    } else if (state.mode === 'increaseBy') {
        state.x = val('pc-x', 10);
        state.y = val('pc-y', 200);
        R.renderIncreaseBy(container, state.x, state.y);

    } else if (state.mode === 'decreaseBy') {
        state.x = val('pc-x', 10);
        state.y = val('pc-y', 200);
        R.renderDecreaseBy(container, state.x, state.y);

    } else if (state.mode === 'percentChange') {
        state.a = val('pc-a', 120);
        state.b = val('pc-b', 150);
        R.renderPercentChange(container, state.a, state.b);

    } else if (state.mode === 'reversePct') {
        state.discPct = val('pc-disc-pct', 20);
        state.finalPrice = val('pc-final-price', 80);
        R.renderReverse(container, state.discPct, state.finalPrice);

    } else if (state.mode === 'discountSim') {
        state.basePrice = val('pc-base-price', 1000);
        state.discPctSim = val('pc-disc-sim', 15);
        state.taxPctSim = val('pc-tax-sim', 5);
        state.qty = val('pc-qty', 1);
        R.renderDiscountSim(container, state.basePrice, state.discPctSim, state.taxPctSim, state.qty);

    } else if (state.mode === 'chain') {
        state.chainStart = val('pc-chain-start', 100);
        state.chainSteps = strVal('pc-chain-steps', '+10%, -5%, +8%');
        R.renderChain(container, state.chainStart, state.chainSteps);
    }

    updateCompiler();
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        var preview = $('pc-preview');
        if (!preview || !window.katex) return;

        var latex = '';
        if (state.mode === 'percentOf') {
            latex = R.fmt(val('pc-x', 10)) + '\\% \\text{ of } ' + R.fmt(val('pc-y', 200));
        } else if (state.mode === 'whatPercent') {
            latex = R.fmt(val('pc-x', 10)) + ' \\text{ is ?\\% of } ' + R.fmt(val('pc-y', 200));
        } else if (state.mode === 'increaseBy') {
            latex = R.fmt(val('pc-y', 200)) + ' + ' + R.fmt(val('pc-x', 10)) + '\\%';
        } else if (state.mode === 'decreaseBy') {
            latex = R.fmt(val('pc-y', 200)) + ' - ' + R.fmt(val('pc-x', 10)) + '\\%';
        } else if (state.mode === 'percentChange') {
            latex = '\\frac{B - A}{A} \\times 100\\%';
        } else if (state.mode === 'reversePct') {
            latex = '\\text{Original} = \\frac{\\text{Final}}{1 - \\text{Disc\\%}}';
        } else if (state.mode === 'discountSim') {
            latex = '\\text{Price} - \\text{Disc} + \\text{Tax}';
        } else if (state.mode === 'chain') {
            latex = '\\text{Start} \\xrightarrow{\\text{steps}} \\text{Final}';
        }

        R.renderKaTeX(preview, latex, true);
    }, 100);
}

// ==================== Compiler ====================

function updateCompiler() {
    if (!state.compilerLoaded) return;
    var iframe = $('pc-compiler-iframe');
    var templateSelect = $('pc-compiler-template');
    if (!iframe || !templateSelect) return;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var url = E.getCompilerUrl(templateSelect.value, state, contextPath);
    iframe.src = url;
}

function loadCompiler() {
    if (state.compilerLoaded) return;
    state.compilerLoaded = true;
    updateCompiler();
}

// ==================== Examples ====================

function loadExample(name) {
    var examples = {
        'pct-of':       { mode: 'percentOf', x: 25, y: 200 },
        'what-pct':     { mode: 'whatPercent', x: 45, y: 180 },
        'increase':     { mode: 'increaseBy', x: 15, y: 500 },
        'decrease':     { mode: 'decreaseBy', x: 20, y: 800 },
        'change':       { mode: 'percentChange', a: 120, b: 150 },
        'reverse':      { mode: 'reversePct', discPct: 25, finalPrice: 75 },
        'discount':     { mode: 'discountSim', basePrice: 1000, discPctSim: 15, taxPctSim: 8, qty: 2 },
        'chain':        { mode: 'chain', chainStart: 100, chainSteps: '+10%, -5%, +8%' }
    };

    var ex = examples[name];
    if (!ex) return;

    switchMode(ex.mode);

    if (ex.mode === 'percentOf' || ex.mode === 'whatPercent' || ex.mode === 'increaseBy' || ex.mode === 'decreaseBy') {
        var xInput = $('pc-x');
        var yInput = $('pc-y');
        if (xInput) xInput.value = ex.x;
        if (yInput) yInput.value = ex.y;
    } else if (ex.mode === 'percentChange') {
        var aInput = $('pc-a');
        var bInput = $('pc-b');
        if (aInput) aInput.value = ex.a;
        if (bInput) bInput.value = ex.b;
    } else if (ex.mode === 'reversePct') {
        var dp = $('pc-disc-pct');
        var fp = $('pc-final-price');
        if (dp) dp.value = ex.discPct;
        if (fp) fp.value = ex.finalPrice;
    } else if (ex.mode === 'discountSim') {
        var bp = $('pc-base-price');
        var ds = $('pc-disc-sim');
        var ts = $('pc-tax-sim');
        var q = $('pc-qty');
        if (bp) bp.value = ex.basePrice;
        if (ds) ds.value = ex.discPctSim;
        if (ts) ts.value = ex.taxPctSim;
        if (q) q.value = ex.qty;
    } else if (ex.mode === 'chain') {
        var cs = $('pc-chain-start');
        var cst = $('pc-chain-steps');
        if (cs) cs.value = ex.chainStart;
        if (cst) cst.value = ex.chainSteps;
    }

    calculate();
}

// ==================== Clear ====================

function clearAll() {
    var xInput = $('pc-x');
    var yInput = $('pc-y');
    if (xInput) xInput.value = '10';
    if (yInput) yInput.value = '200';

    var content = $('pc-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="pc-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">%</div>' +
            '<h3>Enter values to calculate</h3>' +
            '<p>Solve any percentage problem with step-by-step solutions.</p></div>';
    }

    var actions = $('pc-result-actions');
    if (actions) actions.style.display = 'none';

    switchMode('percentOf');
    updatePreview();
}

// ==================== URL State ====================

function loadFromURL() {
    var data = E.parseShareUrl();
    if (!data) return false;

    if (data.mode) switchMode(data.mode);

    if (data.mode === 'percentOf' || data.mode === 'whatPercent' || data.mode === 'increaseBy' || data.mode === 'decreaseBy') {
        var xInput = $('pc-x');
        var yInput = $('pc-y');
        if (xInput && data.x !== undefined) xInput.value = data.x;
        if (yInput && data.y !== undefined) yInput.value = data.y;
    } else if (data.mode === 'percentChange') {
        var aInput = $('pc-a');
        var bInput = $('pc-b');
        if (aInput && data.a !== undefined) aInput.value = data.a;
        if (bInput && data.b !== undefined) bInput.value = data.b;
    } else if (data.mode === 'reversePct') {
        var dp = $('pc-disc-pct');
        var fp = $('pc-final-price');
        if (dp && data.dp !== undefined) dp.value = data.dp;
        if (fp && data.fp !== undefined) fp.value = data.fp;
    } else if (data.mode === 'discountSim') {
        var bp = $('pc-base-price');
        var ds = $('pc-disc-sim');
        var ts = $('pc-tax-sim');
        var q = $('pc-qty');
        if (bp && data.bp !== undefined) bp.value = data.bp;
        if (ds && data.dp !== undefined) ds.value = data.dp;
        if (ts && data.tp !== undefined) ts.value = data.tp;
        if (q && data.q !== undefined) q.value = data.q;
    } else if (data.mode === 'chain') {
        var cs = $('pc-chain-start');
        var cst = $('pc-chain-steps');
        if (cs && data.s !== undefined) cs.value = data.s;
        if (cst && data.st !== undefined) cst.value = data.st;
    }

    calculate();
    return true;
}

// ==================== Initialization ====================

function init() {
    // Mode toggle
    var modeBtns = document.querySelectorAll('.pc-mode-btn');
    for (var i = 0; i < modeBtns.length; i++) {
        modeBtns[i].addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    }

    // Solve & Clear
    var solveBtn = $('pc-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    var clearBtn = $('pc-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Output tabs
    var tabs = document.querySelectorAll('.pc-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');
            var panels = document.querySelectorAll('.pc-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'pc-panel-' + panel);
            }
            if (panel === 'python' && !state.compilerLoaded) loadCompiler();
        });
    }

    // Input changes trigger preview
    var inputs = document.querySelectorAll('.pc-input, .pc-input-text');
    for (var p = 0; p < inputs.length; p++) {
        inputs[p].addEventListener('input', updatePreview);
    }

    // Enter key to calculate
    var allInputs = document.querySelectorAll('.pc-input, .pc-input-text');
    for (var q = 0; q < allInputs.length; q++) {
        allInputs[q].addEventListener('keydown', function(e) {
            if (e.key === 'Enter') calculate();
        });
    }

    // Action buttons
    var copyBtn = $('pc-copy-latex-btn');
    if (copyBtn) {
        copyBtn.addEventListener('click', function() {
            E.copyLatex(state.mode, state);
        });
    }

    var shareBtn = $('pc-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Compiler template
    var compilerTemplate = $('pc-compiler-template');
    if (compilerTemplate) compilerTemplate.addEventListener('change', updateCompiler);

    // Example chips
    var chips = document.querySelectorAll('.pc-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    }

    // FAQ
    if (typeof window.toggleFaq === 'undefined') {
        window.toggleFaq = function(btn) {
            var item = btn.parentElement;
            var answer = item.querySelector('.faq-answer');
            var chevron = btn.querySelector('.faq-chevron');
            var isOpen = answer.style.maxHeight && answer.style.maxHeight !== '0px';
            answer.style.maxHeight = isOpen ? '0px' : answer.scrollHeight + 'px';
            answer.style.padding = isOpen ? '0 1rem' : '0.75rem 1rem';
            if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
        };
    }

    updatePreview();
    if (!loadFromURL()) {
        // default state
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
