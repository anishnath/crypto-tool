/**
 * Series Calculator - Core Orchestration
 * State management, events, integration with Render/Graph/Export modules
 * Uses Nerdamer for symbolic differentiation (exact fractions, clean LaTeX)
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
    currentFunction: null,  // preprocessed string for nerdamer
    derivativesAtCenter: [],
    derivativeExprs: [],    // LaTeX strings for step display
    derivativeTexts: [],    // raw nerdamer text strings for symbolic coefficients
    compilerLoaded: false,
    pendingGraph: false
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function toLatex(exprStr) {
    try {
        return nerdamer(exprStr).toTeX();
    } catch (e) {
        return exprStr;
    }
}

function detectPolynomialDegree(expr) {
    var match = expr.match(/x\^(\d+)/g);
    if (!match) return 0;
    var maxDeg = 0;
    for (var i = 0; i < match.length; i++) {
        var d = parseInt(match[i].replace('x^', ''));
        if (d > maxDeg) maxDeg = d;
    }
    return maxDeg;
}

// ==================== Autocomplete ====================

var acSuggestions = [
    { expr: 'e^x', display: 'e^x', cat: 'Exponential' },
    { expr: 'e^(-x)', display: 'e^(-x)', cat: 'Exponential' },
    { expr: 'e^(2*x)', display: 'e^(2*x)', cat: 'Exponential' },
    { expr: 'x*e^x', display: 'x*e^x', cat: 'Exponential' },
    { expr: 'sin(x)', display: 'sin(x)', cat: 'Trig' },
    { expr: 'cos(x)', display: 'cos(x)', cat: 'Trig' },
    { expr: 'tan(x)', display: 'tan(x)', cat: 'Trig' },
    { expr: 'sin(2*x)', display: 'sin(2*x)', cat: 'Trig' },
    { expr: 'cos(2*x)', display: 'cos(2*x)', cat: 'Trig' },
    { expr: 'sin(x)^2', display: 'sin(x)^2', cat: 'Trig' },
    { expr: 'cos(x)^2', display: 'cos(x)^2', cat: 'Trig' },
    { expr: 'ln(1+x)', display: 'ln(1+x)', cat: 'Logarithmic' },
    { expr: 'ln(x)', display: 'ln(x)', cat: 'Logarithmic' },
    { expr: 'ln(1-x)', display: 'ln(1-x)', cat: 'Logarithmic' },
    { expr: 'sqrt(1+x)', display: 'sqrt(1+x)', cat: 'Power/Root' },
    { expr: '(1+x)^n', display: '(1+x)^n', cat: 'Power/Root' },
    { expr: 'x^2', display: 'x^2', cat: 'Power/Root' },
    { expr: 'x^3', display: 'x^3', cat: 'Power/Root' },
    { expr: '1/(1-x)', display: '1/(1-x)', cat: 'Geometric' },
    { expr: '1/(1+x)', display: '1/(1+x)', cat: 'Geometric' },
    { expr: '1/(1-x)^2', display: '1/(1-x)^2', cat: 'Geometric' },
    { expr: 'x/(1-x)', display: 'x/(1-x)', cat: 'Geometric' },
    { expr: 'asin(x)', display: 'asin(x)', cat: 'Inverse Trig' },
    { expr: 'atan(x)', display: 'atan(x)', cat: 'Inverse Trig' },
    { expr: 'acos(x)', display: 'acos(x)', cat: 'Inverse Trig' },
    { expr: 'sinh(x)', display: 'sinh(x)', cat: 'Hyperbolic' },
    { expr: 'cosh(x)', display: 'cosh(x)', cat: 'Hyperbolic' },
    { expr: 'tanh(x)', display: 'tanh(x)', cat: 'Hyperbolic' },
    { expr: 'e^x*sin(x)', display: 'e^x*sin(x)', cat: 'Combined' },
    { expr: 'e^x*cos(x)', display: 'e^x*cos(x)', cat: 'Combined' },
    { expr: 'x*sin(x)', display: 'x*sin(x)', cat: 'Combined' },
    { expr: 'x*cos(x)', display: 'x*cos(x)', cat: 'Combined' },
    { expr: 'sin(x)/x', display: 'sin(x)/x', cat: 'Combined' }
];

var acSelectedIndex = -1;
var acVisible = false;
var acBlurTimer = null;

function acFilter(query) {
    if (!query) return [];
    var q = query.toLowerCase();
    var matches = [];
    for (var i = 0; i < acSuggestions.length; i++) {
        var s = acSuggestions[i];
        if (s.expr.toLowerCase().indexOf(q) !== -1 || s.display.toLowerCase().indexOf(q) !== -1) {
            matches.push(s);
            if (matches.length >= 8) break;
        }
    }
    return matches;
}

function acRender(matches) {
    var dropdown = $('sc-func-autocomplete');
    if (!dropdown) return;
    if (matches.length === 0) {
        dropdown.classList.remove('active');
        acVisible = false;
        acSelectedIndex = -1;
        return;
    }
    var html = '';
    for (var i = 0; i < matches.length; i++) {
        html += '<div class="sc-func-ac-item" data-index="' + i + '" data-expr="' + matches[i].expr + '">'
            + '<span>' + matches[i].display + '</span>'
            + '<span class="sc-func-ac-cat">' + matches[i].cat + '</span>'
            + '</div>';
    }
    dropdown.innerHTML = html;
    dropdown.classList.add('active');
    acVisible = true;
    acSelectedIndex = -1;
}

function acSelect(expr) {
    var input = $('sc-func-input');
    if (input) {
        input.value = expr;
        input.focus();
    }
    acClose();
    updatePreview();
}

function acClose() {
    var dropdown = $('sc-func-autocomplete');
    if (dropdown) dropdown.classList.remove('active');
    acVisible = false;
    acSelectedIndex = -1;
}

function acHighlight(index) {
    var dropdown = $('sc-func-autocomplete');
    if (!dropdown) return;
    var items = dropdown.querySelectorAll('.sc-func-ac-item');
    for (var i = 0; i < items.length; i++) {
        items[i].classList.toggle('selected', i === index);
    }
    if (items[index]) {
        items[index].scrollIntoView({ block: 'nearest' });
    }
    acSelectedIndex = index;
}

function initAutocomplete() {
    var input = $('sc-func-input');
    var dropdown = $('sc-func-autocomplete');
    if (!input || !dropdown) return;

    input.addEventListener('input', function() {
        var val = this.value.trim();
        var matches = acFilter(val);
        acRender(matches);
    });

    input.addEventListener('keydown', function(e) {
        if (!acVisible) return;
        var dropdown = $('sc-func-autocomplete');
        var items = dropdown ? dropdown.querySelectorAll('.sc-func-ac-item') : [];
        var count = items.length;
        if (count === 0) return;

        if (e.key === 'ArrowDown') {
            e.preventDefault();
            var next = acSelectedIndex < count - 1 ? acSelectedIndex + 1 : 0;
            acHighlight(next);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            var prev = acSelectedIndex > 0 ? acSelectedIndex - 1 : count - 1;
            acHighlight(prev);
        } else if (e.key === 'Enter') {
            if (acSelectedIndex >= 0 && acSelectedIndex < count) {
                e.preventDefault();
                e.stopPropagation();
                var expr = items[acSelectedIndex].getAttribute('data-expr');
                acSelect(expr);
            }
        } else if (e.key === 'Escape') {
            e.preventDefault();
            acClose();
        }
    });

    input.addEventListener('blur', function() {
        acBlurTimer = setTimeout(function() { acClose(); }, 150);
    });

    input.addEventListener('focus', function() {
        var val = this.value.trim();
        if (val) {
            var matches = acFilter(val);
            acRender(matches);
        }
    });

    dropdown.addEventListener('mousedown', function(e) {
        e.preventDefault(); // prevent blur
        var item = e.target.closest('.sc-func-ac-item');
        if (item) {
            var expr = item.getAttribute('data-expr');
            acSelect(expr);
        }
    });
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

    if (!window.nerdamer) {
        R.showError($('sc-result-content'), 'Math library not loaded. Please refresh the page.');
        return;
    }

    numTerms = Math.max(1, Math.min(20, numTerms));

    try {
        // Parse center point
        state.center = parseFloat(nerdamer(centerStr).evaluate().text());
        state.funcInput = funcInput;
        state.numTerms = numTerms;

        // Preprocess function input for nerdamer
        var processedInput = funcInput
            .replace(/\be\^x\b/g, 'exp(x)')
            .replace(/\be\^\(/g, 'exp(')
            .replace(/\bln\(/g, 'log(')
            .replace(/\bpi\b/g, 'pi');

        // Store function as string (nerdamer works with strings)
        state.currentFunction = processedInput;

        // For polynomials, auto-detect degree and ensure enough terms
        var detectedDegree = detectPolynomialDegree(processedInput);
        if (detectedDegree > 0 && numTerms <= detectedDegree) {
            numTerms = detectedDegree + 1;
            state.numTerms = numTerms;
            var numTermsInput = $('sc-num-terms');
            if (numTermsInput) numTermsInput.value = numTerms;
        }

        // Calculate derivatives using nerdamer
        state.derivativesAtCenter = [];
        state.derivativeExprs = [];
        state.derivativeTexts = [];
        var derivStr = processedInput;

        for (var n = 0; n < numTerms; n++) {
            // Evaluate derivative at center
            var value = parseFloat(nerdamer(derivStr).evaluate({ x: state.center }).text());
            state.derivativesAtCenter.push(value);

            // Store LaTeX derivative expression for step display
            state.derivativeExprs.push(toLatex(derivStr));

            // Store raw nerdamer text for symbolic coefficient rendering
            state.derivativeTexts.push(derivStr);

            // Differentiate for next iteration
            if (n < numTerms - 1) {
                derivStr = nerdamer.diff(derivStr, 'x').text();
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

        // Render steps (pass derivativeTexts for symbolic fractions)
        R.renderSteps(
            $('sc-steps-area'),
            state.derivativesAtCenter,
            numTerms,
            state.center,
            state.derivativeExprs,
            state.derivativeTexts
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
    var funcStr = state.currentFunction;
    var evalFn = function(xVal) {
        try {
            return parseFloat(nerdamer(funcStr).evaluate({ x: xVal }).text());
        } catch(e) { return NaN; }
    };
    var sliderVal = parseInt(($('sc-term-slider') || {}).value) || state.numTerms;
    G.renderGraph(
        'sc-graph-container',
        evalFn,
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
    state.derivativeTexts = [];
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

    // Enter key to solve (only when autocomplete is not active with a selection)
    if (funcInput) funcInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !(acVisible && acSelectedIndex >= 0)) calculateSeries();
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

    var copySeriesBtn = $('sc-copy-series-btn');
    if (copySeriesBtn) {
        copySeriesBtn.addEventListener('click', function() {
            if (!state.currentFunction || state.derivativesAtCenter.length === 0) return;
            var text = 'f(x) = ' + state.funcInput + '\n';
            text += (state.center === 0 ? 'Maclaurin' : 'Taylor') + ' series around x = ' + state.center + '\n';
            text += 'f(x) ≈ ';
            var parts = [];
            for (var i = 0; i < state.numTerms; i++) {
                var c = state.derivativesAtCenter[i] / R.factorial(i);
                if (Math.abs(c) < 1e-12) continue;
                var term = '';
                if (i === 0) {
                    term = R.fmt(c);
                } else {
                    var xp = state.center === 0 ? 'x' : '(x - ' + R.fmt(state.center) + ')';
                    if (i > 1) xp += '^' + i;
                    term = R.fmt(c) + '*' + xp;
                }
                if (parts.length > 0 && c > 0) term = '+ ' + term;
                parts.push(term);
            }
            text += parts.join(' ') + ' + ...';
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(text, { toastMessage: 'Series copied!' });
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(text);
            }
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

    // Initialize autocomplete
    initAutocomplete();

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
