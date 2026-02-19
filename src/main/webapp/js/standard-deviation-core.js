/**
 * Standard Deviation Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        data: [],
        isSample: true,
        stats: null,
        pendingGraph: null
    };

    /* ===== Examples ===== */
    var examples = {
        'exam-scores': '72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79',
        'measurements': '10.2, 10.5, 9.8, 10.1, 10.4, 9.9, 10.3, 10.0, 10.6, 9.7, 10.2, 10.1',
        'daily-temps': '68, 72, 75, 71, 69, 74, 73, 70, 76, 67, 71, 73, 72, 74, 70',
        'reaction-times': '245, 312, 278, 295, 261, 289, 302, 267, 285, 299, 273, 308, 252, 291, 276'
    };

    /* ===== DOM References ===== */
    var els = {};

    function initDOM() {
        els.dataInput = document.getElementById('sd-data-input');
        els.preview = document.getElementById('sd-preview');
        els.resultContent = document.getElementById('sd-result-content');
        els.resultActions = document.getElementById('sd-result-actions');
        els.graphContent = document.getElementById('sd-graph-content');
        els.compilerIframe = document.getElementById('sd-compiler-iframe');
        els.calcBtn = document.getElementById('sd-calc-btn');
        els.clearBtn = document.getElementById('sd-clear-btn');
        els.randomBtn = document.getElementById('sd-random-btn');
        els.sampleBtn = document.getElementById('sd-mode-sample');
        els.popBtn = document.getElementById('sd-mode-population');
    }

    /* ===== Tab Switching ===== */

    function initTabs() {
        var tabs = document.querySelectorAll('.stat-output-tab');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].addEventListener('click', function() {
                var panel = this.getAttribute('data-panel');
                var allTabs = document.querySelectorAll('.stat-output-tab');
                for (var j = 0; j < allTabs.length; j++) allTabs[j].classList.remove('active');
                this.classList.add('active');
                var allPanels = document.querySelectorAll('.stat-panel');
                for (var k = 0; k < allPanels.length; k++) allPanels[k].classList.remove('active');
                var target = document.getElementById('sd-panel-' + panel);
                if (target) target.classList.add('active');
                if (panel === 'graph' && state.pendingGraph) {
                    state.pendingGraph();
                    state.pendingGraph = null;
                }
                if (panel === 'python' && els.compilerIframe && !els.compilerIframe.src && state.data.length > 0) {
                    loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */

    function initModeToggle() {
        if (els.sampleBtn) {
            els.sampleBtn.addEventListener('click', function() {
                state.isSample = true;
                els.sampleBtn.classList.add('active');
                if (els.popBtn) els.popBtn.classList.remove('active');
                if (state.data.length > 0) calculate();
            });
        }
        if (els.popBtn) {
            els.popBtn.addEventListener('click', function() {
                state.isSample = false;
                els.popBtn.classList.add('active');
                if (els.sampleBtn) els.sampleBtn.classList.remove('active');
                if (state.data.length > 0) calculate();
            });
        }
    }

    /* ===== Example Chips ===== */

    function initExamples() {
        var chips = document.querySelectorAll('.stat-example-chip[data-example]');
        for (var i = 0; i < chips.length; i++) {
            chips[i].addEventListener('click', function() {
                var key = this.getAttribute('data-example');
                if (examples[key] && els.dataInput) {
                    els.dataInput.value = examples[key];
                    updatePreview();
                    calculate();
                }
            });
        }
    }

    /* ===== Preview ===== */

    function updatePreview() {
        if (!els.preview || !els.dataInput) return;
        var nums = C.parseNumbers(els.dataInput.value);
        if (nums.length === 0) {
            els.preview.innerHTML = '<span style="color:var(--text-muted);">Enter data above\u2026</span>';
        } else {
            els.preview.innerHTML = '<span class="stat-preview-count">' + nums.length + '</span> data points detected';
        }
    }

    /* ===== Calculate ===== */

    function calculate() {
        if (!els.dataInput || !els.resultContent) return;

        var data = C.parseNumbers(els.dataInput.value);
        if (data.length === 0) {
            C.showError(els.resultContent, 'Please enter at least one valid number.');
            E.hideActionButtons(els.resultActions);
            return;
        }

        state.data = data;
        state.stats = C.computeDescriptive(data);

        renderResults();
        prepareGraph();
        updatePreview();

        E.renderActionButtons(els.resultActions, {
            toolName: 'Standard Deviation',
            getLatex: function() { return state.stats ? E.buildLatex('Standard Deviation', state.stats) : ''; },
            getShareState: function() { return { data: els.dataInput ? els.dataInput.value : '', mode: state.isSample ? 'sample' : 'population' }; },
            resultEl: '#sd-result-content'
        });
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render Results ===== */

    function renderResults() {
        var s = state.stats;
        var container = els.resultContent;
        container.innerHTML = '';

        var isSample = state.isSample;
        var variance = isSample ? s.variance : s.variancePop;
        var sd = isSample ? s.sd : s.sdPop;
        var symbol = isSample ? 's' : '\u03C3';
        var varSymbol = isSample ? 's\u00B2' : '\u03C3\u00B2';
        var denomLabel = isSample ? 'n \u2212 1 = ' + (s.n - 1) : 'n = ' + s.n;

        // Hero number
        var hero = document.createElement('div');
        hero.style.cssText = 'text-align:center;padding:1rem;margin-bottom:1rem;background:var(--stat-light);border-radius:0.75rem;';
        hero.innerHTML = '<div style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--stat-tool);margin-bottom:0.25rem;">Standard Deviation (' + symbol + ')</div>' +
                         '<div style="font-size:2rem;font-weight:800;color:var(--text-primary);font-family:var(--font-mono);">' + C.fmt(sd, 6) + '</div>';
        container.appendChild(hero);

        // Badge
        var badge = document.createElement('div');
        badge.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
        badge.innerHTML = '<span class="stat-result-badge">n = ' + s.n + '</span>' +
                          '<span class="stat-result-badge">' + (isSample ? 'Sample' : 'Population') + '</span>';
        container.appendChild(badge);

        // Key Results
        container.appendChild(C.buildStatSection('Key Results', [
            C.buildStatRow('Standard Deviation (' + symbol + ')', C.fmt(sd, 6)),
            C.buildStatRow('Variance (' + varSymbol + ')', C.fmt(variance, 6)),
            C.buildStatRow('Mean (' + (isSample ? 'x\u0305' : '\u03BC') + ')', C.fmt(s.mean, 6)),
            C.buildStatRow('Count (n)', String(s.n)),
            C.buildStatRow('Sum (\u03A3x)', C.fmt(s.sum, 6))
        ]));

        // Additional Stats
        container.appendChild(C.buildStatSection('Additional Statistics', [
            C.buildStatRow('Minimum', C.fmt(s.min)),
            C.buildStatRow('Maximum', C.fmt(s.max)),
            C.buildStatRow('Range', C.fmt(s.range)),
            C.buildStatRow('Coeff. of Variation', C.fmt(s.cv, 2) + '%'),
            C.buildStatRow('Std Error (SEM)', C.fmt(s.sem))
        ]));

        // Step-by-step
        var stepsSection = document.createElement('div');
        stepsSection.className = 'stat-section';
        var stepsTitle = document.createElement('div');
        stepsTitle.className = 'stat-section-title';
        stepsTitle.textContent = 'Step-by-Step Calculation';
        stepsSection.appendChild(stepsTitle);

        // Compute sum of squares for display
        var ssq = 0;
        for (var i = 0; i < state.data.length; i++) {
            var d = state.data[i] - s.mean;
            ssq += d * d;
        }

        stepsSection.appendChild(C.buildStepDOM(1, 'Calculate the mean', '\\bar{x} = \\frac{\\sum x_i}{n} = \\frac{' + C.fmt(s.sum) + '}{' + s.n + '} = ' + C.fmt(s.mean, 6)));
        stepsSection.appendChild(C.buildStepDOM(2, 'Compute squared deviations', '\\sum(x_i - \\bar{x})^2 = ' + C.fmt(ssq, 6)));
        stepsSection.appendChild(C.buildStepDOM(3, 'Divide by ' + denomLabel, varSymbol + ' = \\frac{' + C.fmt(ssq, 6) + '}{' + (isSample ? (s.n - 1) : s.n) + '} = ' + C.fmt(variance, 6)));
        stepsSection.appendChild(C.buildStepDOM(4, 'Take the square root', symbol + ' = \\sqrt{' + C.fmt(variance, 6) + '} = ' + C.fmt(sd, 6)));

        container.appendChild(stepsSection);

        // 68-95-99.7 rule
        if (sd > 0) {
            var ruleSection = document.createElement('div');
            ruleSection.className = 'stat-section';
            var ruleTitle = document.createElement('div');
            ruleTitle.className = 'stat-section-title';
            ruleTitle.textContent = '68\u201395\u201399.7 Rule';
            ruleSection.appendChild(ruleTitle);

            ruleSection.appendChild(C.buildStatRow('\u03BC \u00B1 1\u03C3 (68.3%)', C.fmt(s.mean - sd, 2) + ' to ' + C.fmt(s.mean + sd, 2)));
            ruleSection.appendChild(C.buildStatRow('\u03BC \u00B1 2\u03C3 (95.4%)', C.fmt(s.mean - 2 * sd, 2) + ' to ' + C.fmt(s.mean + 2 * sd, 2)));
            ruleSection.appendChild(C.buildStatRow('\u03BC \u00B1 3\u03C3 (99.7%)', C.fmt(s.mean - 3 * sd, 2) + ' to ' + C.fmt(s.mean + 3 * sd, 2)));

            container.appendChild(ruleSection);
        }
    }

    /* ===== Prepare Graph ===== */

    function prepareGraph() {
        var graphFn = function() {
            if (!els.graphContent) return;
            els.graphContent.innerHTML = '';

            var sd = state.isSample ? state.stats.sd : state.stats.sdPop;
            if (!sd || sd <= 0) {
                els.graphContent.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>Cannot draw bell curve</h3><p>Standard deviation must be greater than zero.</p></div>';
                return;
            }

            var bellDiv = document.createElement('div');
            bellDiv.id = 'sd-bell-curve';
            bellDiv.style.cssText = 'width:100%;min-height:400px;';
            els.graphContent.appendChild(bellDiv);

            G.renderNormalCurve('sd-bell-curve', state.stats.mean, sd, {
                title: 'Normal Distribution (Bell Curve)'
            });
        };

        var graphPanel = document.getElementById('sd-panel-graph');
        if (graphPanel && graphPanel.classList.contains('active')) {
            graphFn();
        } else {
            state.pendingGraph = graphFn;
        }
    }

    /* ===== Load Compiler ===== */

    function loadCompiler() {
        if (!els.compilerIframe || state.data.length === 0) return;
        var isSample = state.isSample;
        var lines = [
            'import numpy as np',
            'from scipy import stats',
            '',
            '# Standard Deviation Calculator',
            'data = np.array([' + state.data.join(', ') + '])',
            '',
            'n = len(data)',
            'mean = np.mean(data)',
            'std_sample = np.std(data, ddof=1)',
            'std_pop = np.std(data, ddof=0)',
            'var_sample = np.var(data, ddof=1)',
            'var_pop = np.var(data, ddof=0)',
            '',
            'print(f"n = {n}")',
            'print(f"Mean = {mean:.6f}")',
            'print(f"\\nSample Statistics (ddof=1):")',
            'print(f"  Variance (s²) = {var_sample:.6f}")',
            'print(f"  Std Dev  (s)  = {std_sample:.6f}")',
            'print(f"\\nPopulation Statistics (ddof=0):")',
            'print(f"  Variance (σ²) = {var_pop:.6f}")',
            'print(f"  Std Dev  (σ)  = {std_pop:.6f}")',
            'print(f"\\n68-95-99.7 Rule (' + (isSample ? 'sample' : 'population') + '):")',
            'sd = ' + (isSample ? 'std_sample' : 'std_pop'),
            'print(f"  μ ± 1σ: [{mean - sd:.2f}, {mean + sd:.2f}]")',
            'print(f"  μ ± 2σ: [{mean - 2*sd:.2f}, {mean + 2*sd:.2f}]")',
            'print(f"  μ ± 3σ: [{mean - 3*sd:.2f}, {mean + 3*sd:.2f}]")'
        ];
        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Random Data ===== */

    function generateRandom() {
        var sizes = [15, 20, 25, 30, 50];
        var n = sizes[Math.floor(Math.random() * sizes.length)];
        var mean = 20 + Math.random() * 80;
        var sd = 2 + Math.random() * 15;
        var arr = [];
        for (var i = 0; i < n; i++) {
            var u1 = Math.random(), u2 = Math.random();
            var z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
            arr.push(Math.round((mean + sd * z) * 10) / 10);
        }
        if (els.dataInput) {
            els.dataInput.value = arr.join(', ');
            updatePreview();
            calculate();
        }
    }

    /* ===== Clear ===== */

    function clear() {
        if (els.dataInput) els.dataInput.value = '';
        state.data = [];
        state.stats = null;
        state.pendingGraph = null;
        C.showEmpty(els.resultContent, '\uD83D\uDCC9', 'Enter data and click Calculate', 'Paste numbers to compute standard deviation with step-by-step solution.');
        E.hideActionButtons(els.resultActions);
        if (els.graphContent) els.graphContent.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the bell curve.</p></div>';
        updatePreview();
    }

    /* ===== Action Buttons (handled by E.renderActionButtons) ===== */
    function initActions() {}

    /* ===== Init ===== */

    function init() {
        initDOM();
        initTabs();
        initModeToggle();
        initExamples();
        initActions();

        if (els.dataInput) els.dataInput.addEventListener('input', updatePreview);
        if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
        if (els.clearBtn) els.clearBtn.addEventListener('click', clear);
        if (els.randomBtn) els.randomBtn.addEventListener('click', generateRandom);

        // Restore from share URL
        var shared = E.parseShareUrl();
        if (shared && shared.data) {
            els.dataInput.value = shared.data;
            if (shared.mode === 'population') {
                state.isSample = false;
                if (els.sampleBtn) els.sampleBtn.classList.remove('active');
                if (els.popBtn) els.popBtn.classList.add('active');
            }
        }

        updatePreview();
        calculate();
        C.initScrollReveal();

        // FAQ accordion
        var items = document.querySelectorAll('.faq-item');
        for (var i = 0; i < items.length; i++) {
            var btn = items[i].querySelector('.faq-question');
            if (btn) {
                btn.addEventListener('click', function() {
                    this.parentElement.classList.toggle('open');
                });
            }
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
