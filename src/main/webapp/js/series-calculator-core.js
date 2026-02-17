/**
 * Series Calculator - Core Orchestration
 * State management, events, integration with Render/Graph/Export modules
 */
(function() {
'use strict';

var R = window.SeriesCalcRender;
var G = window.SeriesCalcGraph;
var E = window.SeriesCalcExport;

// ==================== State ====================

var state = {
    funcInput: 'e^x',
    seriesType: 'maclaurin',
    center: 0,
    numTerms: 5,
    currentFunction: null,  // math.js parsed
    derivativesAtCenter: [],
    derivativeExprs: [],    // math.js expression objects for display
    compilerLoaded: false,
    pendingGraph: false
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function toLatex(expr) {
    try {
        var latex = expr.toTex ? expr.toTex() : expr.toString();
        latex = latex.replace(/\\cdot/g, '\\,');
        latex = latex.replace(/\*\*/g, '^');
        latex = latex.replace(/\\log/g, '\\ln');
        latex = latex.replace(/\blog\(/g, 'ln(');
        return latex;
    } catch (e) {
        return expr.toString();
    }
}

// ==================== Core Computation ====================

function calculateSeries() {
    var funcInput = $('sc-func-input').value.trim();
    var numTerms = parseInt($('sc-num-terms').value) || 5;
    var centerStr = $('sc-center-point').value.trim() || '0';

    if (!funcInput) {
        R.showError($('sc-result-content'), 'Please enter a function.');
        return;
    }

    if (!window.math) {
        R.showError($('sc-result-content'), 'Math library not loaded. Please refresh the page.');
        return;
    }

    numTerms = Math.max(1, Math.min(20, numTerms));

    try {
        // Parse center point
        state.center = math.evaluate(centerStr.replace(/\bpi\b/g, 'pi'));
        state.funcInput = funcInput;
        state.numTerms = numTerms;

        // Preprocess function input
        var processedInput = funcInput
            .replace(/\bln\(/g, 'log(')
            .replace(/\bpi\b/g, 'pi');

        // Parse function
        state.currentFunction = math.parse(processedInput);

        // Calculate derivatives
        state.derivativesAtCenter = [];
        state.derivativeExprs = [];
        var derivative = state.currentFunction;

        for (var n = 0; n < numTerms; n++) {
            var compiled = derivative.compile();
            var scope = { x: state.center };
            var value = compiled.evaluate(scope);
            state.derivativesAtCenter.push(value);

            // Store derivative expression for step display
            state.derivativeExprs.push(toLatex(derivative));

            if (n < numTerms - 1) {
                derivative = math.derivative(derivative, 'x');
            }
        }

        // Render result
        var funcLatex = toLatex(state.currentFunction);
        R.renderResult(
            $('sc-result-content'),
            funcLatex,
            state.derivativesAtCenter,
            numTerms,
            state.center,
            state.seriesType
        );

        // Render steps
        R.renderSteps(
            $('sc-steps-area'),
            state.derivativesAtCenter,
            numTerms,
            state.center,
            state.derivativeExprs
        );

        // Render convergence analysis
        R.renderConvergence($('sc-convergence-area'), funcInput);

        // Show result actions
        var actions = $('sc-result-actions');
        if (actions) actions.style.display = 'flex';

        // Hide empty state
        var empty = $('sc-empty-state');
        if (empty) empty.style.display = 'none';

        // Update graph
        updateGraph();

        // Update term slider
        var slider = $('sc-term-slider');
        if (slider) {
            slider.max = numTerms;
            slider.value = numTerms;
        }
        var sliderVal = $('sc-term-slider-value');
        if (sliderVal) sliderVal.textContent = numTerms;

        // Update compiler
        updateCompiler();

    } catch (error) {
        R.showError($('sc-result-content'), 'Error: ' + error.message);
    }
}

function updateGraph() {
    if (!state.currentFunction || state.derivativesAtCenter.length === 0) return;

    var container = $('sc-graph-container');
    if (!container) return;

    var hint = $('sc-graph-hint');
    if (hint) hint.style.display = 'none';

    if (!window.Plotly) {
        state.pendingGraph = true;
        G.loadPlotly(function() {
            state.pendingGraph = false;
            doRenderGraph();
        });
    } else {
        doRenderGraph();
    }
}

function doRenderGraph() {
    var sliderVal = parseInt(($('sc-term-slider') || {}).value) || state.numTerms;
    G.renderGraph(
        'sc-graph-container',
        state.currentFunction.compile(),
        'x',
        state.derivativesAtCenter,
        state.center,
        sliderVal
    );
}

function updateCompiler() {
    if (!state.compilerLoaded) return;
    var iframe = $('sc-compiler-iframe');
    var templateSelect = $('sc-compiler-template');
    if (!iframe || !templateSelect) return;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var url = E.getCompilerUrl(
        templateSelect.value,
        state.funcInput,
        state.center,
        state.numTerms,
        contextPath
    );
    iframe.src = url;
}

function loadCompiler() {
    if (state.compilerLoaded) return;
    state.compilerLoaded = true;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var iframe = $('sc-compiler-iframe');
    var templateSelect = $('sc-compiler-template');
    if (!iframe || !templateSelect) return;

    var url = E.getCompilerUrl(
        templateSelect.value,
        state.funcInput,
        state.center,
        state.numTerms,
        contextPath
    );
    iframe.src = url;
}

// ==================== UI Handlers ====================

function switchSeriesType(type) {
    state.seriesType = type;
    var btns = document.querySelectorAll('.sc-type-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-type') === type);
    }

    var centerGroup = $('sc-center-group');
    if (centerGroup) {
        centerGroup.style.display = type === 'taylor' ? 'block' : 'none';
    }
    if (type === 'maclaurin') {
        var centerInput = $('sc-center-point');
        if (centerInput) centerInput.value = '0';
        state.center = 0;
    }

    updatePreview();
}

var previewTimer = null;
function updatePreview() {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        var preview = $('sc-preview');
        if (!preview || !window.katex) return;

        var funcInput = ($('sc-func-input') || {}).value || '';
        var center = state.seriesType === 'maclaurin' ? 0 : (parseFloat(($('sc-center-point') || {}).value) || 0);
        var numTerms = parseInt(($('sc-num-terms') || {}).value) || 5;

        if (!funcInput) {
            preview.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter a function to see preview</span>';
            return;
        }

        var centerStr = center === 0 ? '' : ' - ' + center;
        var latex = 'f(x) = \\sum_{n=0}^{' + numTerms + '} \\frac{f^{(n)}(' + R.fmt(center) + ')}{n!}(x' + centerStr + ')^n';

        R.renderKaTeX(preview, latex, true);
    }, 100);
}

function loadExample(name) {
    var examples = {
        'exp':     { f: 'e^x',       t: 'maclaurin', n: 5 },
        'sin':     { f: 'sin(x)',     t: 'maclaurin', n: 7 },
        'cos':     { f: 'cos(x)',     t: 'maclaurin', n: 7 },
        'ln':      { f: 'ln(1+x)',    t: 'maclaurin', n: 6 },
        'geo':     { f: '1/(1-x)',    t: 'maclaurin', n: 6 },
        'sqrt':    { f: 'sqrt(1+x)',  t: 'maclaurin', n: 6 },
        'tan':     { f: 'tan(x)',     t: 'maclaurin', n: 5 },
        'taylor':  { f: 'sin(x)',     t: 'taylor',    n: 7, c: 'pi' }
    };

    var ex = examples[name];
    if (!ex) return;

    var funcInput = $('sc-func-input');
    var numTermsInput = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = ex.f;
    if (numTermsInput) numTermsInput.value = ex.n;
    if (centerInput) centerInput.value = ex.c || '0';

    switchSeriesType(ex.t);
    updatePreview();
    calculateSeries();
}

function clearAll() {
    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = '';
    if (numTerms) numTerms.value = '5';
    if (centerInput) centerInput.value = '0';

    state.derivativesAtCenter = [];
    state.derivativeExprs = [];
    state.currentFunction = null;

    var content = $('sc-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="sc-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&Sigma;</div>' +
            '<h3>Enter a function</h3>' +
            '<p>Calculate Taylor or Maclaurin series expansion with step-by-step solutions.</p>' +
            '</div>';
    }

    var actions = $('sc-result-actions');
    if (actions) actions.style.display = 'none';

    var stepsArea = $('sc-steps-area');
    if (stepsArea) stepsArea.innerHTML = '';

    var convergenceArea = $('sc-convergence-area');
    if (convergenceArea) convergenceArea.innerHTML = '';

    var hint = $('sc-graph-hint');
    if (hint) hint.style.display = '';

    switchSeriesType('maclaurin');
    updatePreview();
}

function loadFromURL() {
    var data = E.parseShareUrl();
    if (!data) return false;

    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.value = data.f || '';
    if (numTerms) numTerms.value = data.n || 5;
    if (centerInput) centerInput.value = data.c || '0';

    switchSeriesType(data.t || 'maclaurin');
    calculateSeries();
    return true;
}

// ==================== Initialization ====================

function init() {
    // Series type toggle
    var typeBtns = document.querySelectorAll('.sc-type-btn');
    for (var i = 0; i < typeBtns.length; i++) {
        typeBtns[i].addEventListener('click', function() {
            switchSeriesType(this.getAttribute('data-type'));
        });
    }

    // Solve & Clear buttons
    var solveBtn = $('sc-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculateSeries);

    var clearBtn = $('sc-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Output tabs
    var tabs = document.querySelectorAll('.sc-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');

            var panels = document.querySelectorAll('.sc-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'sc-panel-' + panel);
            }

            if (panel === 'graph' && state.currentFunction) updateGraph();
            if (panel === 'python' && !state.compilerLoaded) loadCompiler();
        });
    }

    // Function palette buttons
    var paletteBtns = document.querySelectorAll('.sc-palette-btn');
    for (var p = 0; p < paletteBtns.length; p++) {
        paletteBtns[p].addEventListener('click', function() {
            var input = $('sc-func-input');
            if (!input) return;
            var text = this.getAttribute('data-insert');
            var start = input.selectionStart;
            var end = input.selectionEnd;
            var val = input.value;
            input.value = val.substring(0, start) + text + val.substring(end);
            var newPos = start + text.length;
            input.setSelectionRange(newPos, newPos);
            input.focus();
            updatePreview();
        });
    }

    // Input changes trigger preview
    var funcInput = $('sc-func-input');
    var numTerms = $('sc-num-terms');
    var centerInput = $('sc-center-point');

    if (funcInput) funcInput.addEventListener('input', updatePreview);
    if (numTerms) numTerms.addEventListener('input', updatePreview);
    if (centerInput) centerInput.addEventListener('input', updatePreview);

    // Enter key to solve
    if (funcInput) funcInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') calculateSeries();
    });

    // Term slider
    var slider = $('sc-term-slider');
    if (slider) {
        slider.addEventListener('input', function() {
            var val = parseInt(this.value);
            var display = $('sc-term-slider-value');
            if (display) display.textContent = val;
            if (state.currentFunction && window.Plotly) {
                doRenderGraph();
            }
        });
    }

    // Action buttons
    var copyLatexBtn = $('sc-copy-latex-btn');
    if (copyLatexBtn) {
        copyLatexBtn.addEventListener('click', function() {
            if (!state.currentFunction) return;
            E.copyLatex(
                toLatex(state.currentFunction),
                state.derivativesAtCenter,
                state.numTerms,
                state.center,
                state.seriesType
            );
        });
    }

    var shareBtn = $('sc-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Compiler template change
    var compilerTemplate = $('sc-compiler-template');
    if (compilerTemplate) {
        compilerTemplate.addEventListener('change', updateCompiler);
    }

    // Example chips
    var chips = document.querySelectorAll('.sc-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    }

    // FAQ toggles
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

    // Initialize preview
    updatePreview();

    // Load from URL if params exist
    if (!loadFromURL()) {
        // Preload Plotly
        G.loadPlotly();
    }
}

// ==================== DOM Ready ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
