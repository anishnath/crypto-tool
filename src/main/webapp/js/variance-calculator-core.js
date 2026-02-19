/**
 * Variance Calculator — Orchestration IIFE
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
        'simple-data': '12, 15, 18, 20, 22, 25, 28',
        'test-scores': '72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79',
        'heights': '165, 170, 168, 172, 175, 169, 171, 174, 167, 173, 176, 170, 169, 172',
        'stock-returns': '2.5, -1.3, 4.2, -0.8, 3.1, 1.7, -2.4, 5.3, -0.5, 2.8, 1.2, -1.9, 3.6'
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.dataInput = document.getElementById('var-data-input');
        els.preview = document.getElementById('var-preview');
        els.resultContent = document.getElementById('var-result-content');
        els.resultActions = document.getElementById('var-result-actions');
        els.graphContent = document.getElementById('var-graph-content');
        els.compilerIframe = document.getElementById('var-compiler-iframe');
        els.calcBtn = document.getElementById('var-calc-btn');
        els.clearBtn = document.getElementById('var-clear-btn');
        els.randomBtn = document.getElementById('var-random-btn');
        els.sampleBtn = document.getElementById('var-mode-sample');
        els.popBtn = document.getElementById('var-mode-population');
    }

    /* ===== Tabs ===== */

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
                var target = document.getElementById('var-panel-' + panel);
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

    /* ===== Examples ===== */

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
        if (data.length < 2 && state.isSample) {
            C.showError(els.resultContent, 'Sample variance requires at least 2 data points.');
            E.hideActionButtons(els.resultActions);
            return;
        }

        state.data = data;
        state.stats = C.computeDescriptive(data);

        renderResults();
        prepareGraph();
        updatePreview();

        E.renderActionButtons(els.resultActions, {
            toolName: 'Variance Calculator',
            getLatex: function() { return state.stats ? E.buildLatex('Variance', state.stats) : ''; },
            getShareState: function() { return { data: els.dataInput ? els.dataInput.value : '', mode: state.isSample ? 'sample' : 'population' }; },
            resultEl: '#var-result-content'
        });
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render ===== */

    function renderResults() {
        var s = state.stats;
        var container = els.resultContent;
        container.innerHTML = '';

        var isSample = state.isSample;
        var variance = isSample ? s.variance : s.variancePop;
        var sd = isSample ? s.sd : s.sdPop;
        var varSymbol = isSample ? 's\u00B2' : '\u03C3\u00B2';
        var sdSymbol = isSample ? 's' : '\u03C3';
        var denomLabel = isSample ? 'n \u2212 1' : 'n';
        var denomVal = isSample ? (s.n - 1) : s.n;

        // Hero variance
        var hero = document.createElement('div');
        hero.style.cssText = 'text-align:center;padding:1rem;margin-bottom:1rem;background:var(--stat-light);border-radius:0.75rem;';
        hero.innerHTML = '<div style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--stat-tool);margin-bottom:0.25rem;">Variance (' + varSymbol + ')</div>' +
                         '<div style="font-size:2rem;font-weight:800;color:var(--text-primary);font-family:var(--font-mono);">' + C.fmt(variance, 6) + '</div>' +
                         '<div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">' + (isSample ? 'Sample' : 'Population') + ' variance</div>';
        container.appendChild(hero);

        // Badge
        var badge = document.createElement('div');
        badge.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
        badge.innerHTML = '<span class="stat-result-badge">n = ' + s.n + '</span>' +
                          '<span class="stat-result-badge">' + (isSample ? 'Sample (n\u22121)' : 'Population (n)') + '</span>';
        container.appendChild(badge);

        // Variance & SD
        container.appendChild(C.buildStatSection('Variance & Standard Deviation', [
            C.buildStatRow('Variance (' + varSymbol + ')', C.fmt(variance, 6)),
            C.buildStatRow('Std Deviation (' + sdSymbol + ')', C.fmt(sd, 6)),
            C.buildStatRow('Coeff. of Variation', C.fmt(s.cv, 2) + '%'),
            C.buildStatRow('Std Error (SEM)', C.fmt(s.sem))
        ]));

        // Descriptive
        container.appendChild(C.buildStatSection('Descriptive Statistics', [
            C.buildStatRow('Count (n)', String(s.n)),
            C.buildStatRow('Sum (\u03A3x)', C.fmt(s.sum)),
            C.buildStatRow('Mean', C.fmt(s.mean, 6)),
            C.buildStatRow('Minimum', C.fmt(s.min)),
            C.buildStatRow('Maximum', C.fmt(s.max)),
            C.buildStatRow('Range', C.fmt(s.range))
        ]));

        // Sum of squares breakdown
        var ssq = 0;
        for (var i = 0; i < state.data.length; i++) {
            var d = state.data[i] - s.mean;
            ssq += d * d;
        }

        container.appendChild(C.buildStatSection('Sum of Squares Breakdown', [
            C.buildStatRow('\u03A3(x\u1D62 \u2212 x\u0305)\u00B2', C.fmt(ssq, 6)),
            C.buildStatRow('Divisor (' + denomLabel + ')', String(denomVal)),
            C.buildStatRow('Variance', C.fmt(variance, 6))
        ]));

        // Step-by-step
        var stepsSection = document.createElement('div');
        stepsSection.className = 'stat-section';
        var stepsTitle = document.createElement('div');
        stepsTitle.className = 'stat-section-title';
        stepsTitle.textContent = 'Step-by-Step Calculation';
        stepsSection.appendChild(stepsTitle);

        stepsSection.appendChild(C.buildStepDOM(1, 'Calculate the mean', '\\bar{x} = \\frac{\\sum x_i}{n} = \\frac{' + C.fmt(s.sum) + '}{' + s.n + '} = ' + C.fmt(s.mean, 6)));
        stepsSection.appendChild(C.buildStepDOM(2, 'Compute sum of squared deviations', '\\sum(x_i - \\bar{x})^2 = ' + C.fmt(ssq, 6)));
        stepsSection.appendChild(C.buildStepDOM(3, 'Divide by ' + denomLabel + ' = ' + denomVal, varSymbol + ' = \\frac{' + C.fmt(ssq, 6) + '}{' + denomVal + '} = ' + C.fmt(variance, 6)));
        stepsSection.appendChild(C.buildStepDOM(4, 'Standard deviation is the square root', sdSymbol + ' = \\sqrt{' + C.fmt(variance, 6) + '} = ' + C.fmt(sd, 6)));

        container.appendChild(stepsSection);

        // Deviation table (first 20 values)
        renderDeviationTable(container, ssq);
    }

    function renderDeviationTable(container, totalSS) {
        var s = state.stats;
        var section = document.createElement('div');
        section.className = 'stat-section';
        var title = document.createElement('div');
        title.className = 'stat-section-title';
        title.textContent = 'Deviation Table';
        section.appendChild(title);

        var table = document.createElement('table');
        table.className = 'stat-freq-table';
        var maxRows = Math.min(state.data.length, 20);

        var thead = '<thead><tr><th>x\u1D62</th><th>x\u1D62 \u2212 x\u0305</th><th>(x\u1D62 \u2212 x\u0305)\u00B2</th></tr></thead>';
        var tbody = '<tbody>';
        for (var i = 0; i < maxRows; i++) {
            var v = state.data[i];
            var dev = v - s.mean;
            var sqDev = dev * dev;
            tbody += '<tr><td>' + C.fmt(v) + '</td><td>' + C.fmt(dev) + '</td><td>' + C.fmt(sqDev) + '</td></tr>';
        }
        if (state.data.length > 20) {
            tbody += '<tr><td colspan="3" style="text-align:center;color:var(--text-muted);font-style:italic;">... ' + (state.data.length - 20) + ' more rows</td></tr>';
        }
        tbody += '<tr style="font-weight:700;border-top:2px solid var(--border);"><td>Sum</td><td>\u22480</td><td>' + C.fmt(totalSS, 6) + '</td></tr>';
        tbody += '</tbody>';

        table.innerHTML = thead + tbody;
        section.appendChild(table);
        container.appendChild(section);
    }

    /* ===== Graph ===== */

    function prepareGraph() {
        var graphFn = function() {
            if (!els.graphContent) return;
            els.graphContent.innerHTML = '';

            // Deviation bar chart
            var devDiv = document.createElement('div');
            devDiv.id = 'var-deviation-chart';
            devDiv.style.cssText = 'width:100%;min-height:400px;';
            els.graphContent.appendChild(devDiv);

            var deviations = [];
            for (var i = 0; i < state.data.length; i++) {
                deviations.push(state.data[i] - state.stats.mean);
            }

            var labels = [];
            for (var j = 0; j < state.data.length; j++) {
                labels.push('x' + (j + 1));
            }

            var colors = [];
            for (var k = 0; k < deviations.length; k++) {
                colors.push(deviations[k] >= 0 ? 'rgba(225,29,72,0.6)' : 'rgba(59,130,246,0.6)');
            }

            G.loadPlotly(function() {
                var dark = G.isDarkMode();
                Plotly.newPlot(devDiv, [{
                    type: 'bar',
                    x: labels,
                    y: deviations,
                    marker: { color: colors },
                    hovertemplate: '%{x}: %{y:.4f}<extra></extra>'
                }], {
                    title: { text: 'Deviations from Mean (' + C.fmt(state.stats.mean, 2) + ')', font: { size: 14 } },
                    xaxis: { title: 'Data Points' },
                    yaxis: { title: 'Deviation (x\u1D62 \u2212 x\u0305)', zeroline: true, zerolinewidth: 2, zerolinecolor: dark ? '#64748b' : '#94a3b8' },
                    paper_bgcolor: 'rgba(0,0,0,0)',
                    plot_bgcolor: 'rgba(0,0,0,0)',
                    font: { color: dark ? '#e2e8f0' : '#334155' },
                    margin: { t: 40, r: 20, b: 40, l: 50 }
                }, { responsive: true, displayModeBar: false });
            });
        };

        var graphPanel = document.getElementById('var-panel-graph');
        if (graphPanel && graphPanel.classList.contains('active')) {
            graphFn();
        } else {
            state.pendingGraph = graphFn;
        }
    }

    /* ===== Compiler ===== */

    function loadCompiler() {
        if (!els.compilerIframe || state.data.length === 0) return;
        var isSample = state.isSample;
        var lines = [
            'import numpy as np',
            '',
            '# Variance Calculator',
            'data = np.array([' + state.data.join(', ') + '])',
            '',
            'n = len(data)',
            'mean = np.mean(data)',
            'var_sample = np.var(data, ddof=1)',
            'var_pop = np.var(data, ddof=0)',
            'sd_sample = np.std(data, ddof=1)',
            'sd_pop = np.std(data, ddof=0)',
            'cv = (sd_sample / abs(mean)) * 100 if mean != 0 else 0',
            'sem = sd_sample / np.sqrt(n)',
            '',
            'print(f"n = {n}")',
            'print(f"Mean = {mean:.6f}")',
            'print(f"\\nSample Statistics (ddof=1):")',
            'print(f"  Variance (s\u00B2) = {var_sample:.6f}")',
            'print(f"  Std Dev (s) = {sd_sample:.6f}")',
            'print(f"\\nPopulation Statistics (ddof=0):")',
            'print(f"  Variance (\u03C3\u00B2) = {var_pop:.6f}")',
            'print(f"  Std Dev (\u03C3) = {sd_pop:.6f}")',
            'print(f"\\nCV = {cv:.2f}%")',
            'print(f"SEM = {sem:.6f}")',
            '',
            '# Deviation table',
            'deviations = data - mean',
            'sq_deviations = deviations ** 2',
            'print(f"\\nSum of squared deviations = {sq_deviations.sum():.6f}")',
            'print(f"\\nFirst 10 deviations:")',
            'for i, (v, d, sq) in enumerate(zip(data[:10], deviations[:10], sq_deviations[:10])):',
            '    print(f"  x{i+1}={v:.2f}, dev={d:.4f}, dev\u00B2={sq:.4f}")'
        ];
        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Random ===== */

    function generateRandom() {
        var sizes = [8, 10, 15, 20];
        var n = sizes[Math.floor(Math.random() * sizes.length)];
        var mean = 10 + Math.random() * 90;
        var sd = 2 + Math.random() * 15;
        var arr = [];
        for (var i = 0; i < n; i++) {
            var u1 = Math.random(), u2 = Math.random();
            var z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
            arr.push(Math.round((mean + sd * z) * 100) / 100);
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
        C.showEmpty(els.resultContent, '\uD83D\uDCC9', 'Enter data and click Calculate', 'Paste numbers to compute variance with step-by-step breakdown.');
        E.hideActionButtons(els.resultActions);
        if (els.graphContent) els.graphContent.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see deviation chart.</p></div>';
        updatePreview();
    }

    /* ===== Actions (handled by E.renderActionButtons) ===== */
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
