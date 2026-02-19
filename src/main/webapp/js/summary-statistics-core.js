/**
 * Summary Statistics Calculator — Orchestration IIFE
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
        sorted: [],
        stats: null,
        quartiles: null,
        shape: null,
        freqDist: null,
        showHistogram: true,
        showBoxPlot: true,
        showFrequency: true,
        pendingGraph: null
    };

    /* ===== Examples ===== */
    var examples = {
        'test-scores': '85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86',
        'heights': '165.2, 170.5, 158.3, 172.1, 168.7, 175.4, 162.8, 169.3, 171.6, 166.9, 173.2, 160.5, 167.8, 174.1, 163.4',
        'temperatures': '72.1, 68.5, 75.3, 71.8, 69.2, 74.6, 70.9, 73.4, 67.8, 76.1, 71.3, 69.7, 74.2, 70.5, 72.8',
        'stock-returns': '2.3, -1.5, 0.8, 3.2, -0.4, 1.7, -2.1, 0.5, 4.1, -0.9, 1.2, -1.8, 2.7, 0.3, -0.6',
        'survey': '4, 5, 3, 4, 5, 2, 4, 3, 5, 4, 4, 3, 5, 4, 2, 3, 4, 5, 4, 3'
    };

    /* ===== DOM References ===== */
    var els = {};

    function initDOM() {
        els.dataInput = document.getElementById('stat-data-input');
        els.preview = document.getElementById('stat-preview');
        els.resultContent = document.getElementById('stat-result-content');
        els.resultActions = document.getElementById('stat-result-actions');
        els.graphContainer = document.getElementById('stat-graph-content');
        els.compilerIframe = document.getElementById('stat-compiler-iframe');
        els.calcBtn = document.getElementById('stat-calc-btn');
        els.clearBtn = document.getElementById('stat-clear-btn');
        els.chkHistogram = document.getElementById('stat-chk-histogram');
        els.chkBoxPlot = document.getElementById('stat-chk-boxplot');
        els.chkFrequency = document.getElementById('stat-chk-frequency');
        els.randomBtn = document.getElementById('stat-random-btn');
    }

    /* ===== Tab Switching ===== */

    function initTabs() {
        var tabs = document.querySelectorAll('.stat-output-tab');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].addEventListener('click', function() {
                var panel = this.getAttribute('data-panel');
                // Remove active from all tabs
                var allTabs = document.querySelectorAll('.stat-output-tab');
                for (var j = 0; j < allTabs.length; j++) allTabs[j].classList.remove('active');
                this.classList.add('active');
                // Toggle panels
                var allPanels = document.querySelectorAll('.stat-panel');
                for (var k = 0; k < allPanels.length; k++) allPanels[k].classList.remove('active');
                var target = document.getElementById('stat-panel-' + panel);
                if (target) target.classList.add('active');
                // Lazy-load graphs
                if (panel === 'graph' && state.pendingGraph) {
                    state.pendingGraph();
                    state.pendingGraph = null;
                }
                // Lazy-load Python compiler
                if (panel === 'python' && els.compilerIframe && !els.compilerIframe.src && state.data.length > 0) {
                    loadCompiler();
                }
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
        state.sorted = state.stats.sorted;
        state.quartiles = C.computeQuartiles(state.sorted);
        state.shape = C.computeShape(data, state.stats.mean, state.stats.sd);
        state.freqDist = C.computeFrequencyDist(state.sorted);

        state.showHistogram = els.chkHistogram ? els.chkHistogram.checked : true;
        state.showBoxPlot = els.chkBoxPlot ? els.chkBoxPlot.checked : true;
        state.showFrequency = els.chkFrequency ? els.chkFrequency.checked : true;

        renderResults();
        prepareGraph();
        updatePreview();

        // Show result actions
        E.renderActionButtons(els.resultActions, {
            toolName: 'Summary Statistics',
            getLatex: function() { return state.stats ? E.buildLatex('Summary Statistics', state.stats) : ''; },
            getShareState: function() { return { data: els.dataInput ? els.dataInput.value : '' }; },
            resultEl: '#stat-result-content'
        });

        // Reset compiler iframe for fresh load on tab switch
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render Results ===== */

    function renderResults() {
        var s = state.stats;
        var q = state.quartiles;
        var sh = state.shape;
        var container = els.resultContent;
        container.innerHTML = '';

        // Badge
        var badge = document.createElement('div');
        badge.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
        badge.innerHTML = '<span class="stat-result-badge">n = ' + s.n + '</span>' +
                          '<span class="stat-result-badge">Sum = ' + C.fmt(s.sum) + '</span>';
        container.appendChild(badge);

        // Central Tendency
        container.appendChild(C.buildStatSection('Central Tendency', [
            C.buildStatRow('Mean (\u0078\u0305)', C.fmt(s.mean)),
            C.buildStatRow('Median', C.fmt(s.median)),
            C.buildStatRow('Mode', s.mode.description)
        ]));

        // Dispersion
        container.appendChild(C.buildStatSection('Dispersion (Spread)', [
            C.buildStatRow('Minimum', C.fmt(s.min)),
            C.buildStatRow('Maximum', C.fmt(s.max)),
            C.buildStatRow('Range', C.fmt(s.range)),
            C.buildStatRow('Variance (s\u00B2)', C.fmt(s.variance)),
            C.buildStatRow('Std Dev (s)', C.fmt(s.sd)),
            C.buildStatRow('Variance (\u03C3\u00B2)', C.fmt(s.variancePop)),
            C.buildStatRow('Std Dev (\u03C3)', C.fmt(s.sdPop)),
            C.buildStatRow('Coeff. of Variation', C.fmt(s.cv, 2) + '%'),
            C.buildStatRow('Std Error (SEM)', C.fmt(s.sem))
        ]));

        // Quartiles
        if (q) {
            container.appendChild(C.buildStatSection('Quartiles & Five-Number Summary', [
                C.buildStatRow('Q1 (25th percentile)', C.fmt(q.q1)),
                C.buildStatRow('Q2 (Median)', C.fmt(q.q2)),
                C.buildStatRow('Q3 (75th percentile)', C.fmt(q.q3)),
                C.buildStatRow('IQR (Q3 \u2212 Q1)', C.fmt(q.iqr)),
                C.buildStatRow('Lower Fence', C.fmt(q.lowerFence)),
                C.buildStatRow('Upper Fence', C.fmt(q.upperFence)),
                C.buildStatRow('Outliers', q.outliers.length > 0 ? q.outliers.map(function(o) { return C.fmt(o); }).join(', ') : 'None')
            ]));
        }

        // Shape
        if (sh) {
            container.appendChild(C.buildStatSection('Distribution Shape', [
                C.buildStatRow('Skewness', C.fmt(sh.skewness)),
                C.buildStatRow('Excess Kurtosis', C.fmt(sh.excessKurtosis))
            ]));
            container.appendChild(C.buildInterpretation(sh.skewness, sh.excessKurtosis));
        }

        // Frequency table
        if (state.showFrequency && state.freqDist.length > 0) {
            var freqSection = document.createElement('div');
            freqSection.className = 'stat-section';
            var freqTitle = document.createElement('div');
            freqTitle.className = 'stat-section-title';
            freqTitle.textContent = 'Frequency Distribution';
            freqSection.appendChild(freqTitle);

            var table = document.createElement('table');
            table.className = 'stat-freq-table';
            var thead = '<thead><tr><th>Class Interval</th><th>Freq</th><th>Relative</th><th>Cumulative</th></tr></thead>';
            var tbody = '<tbody>';
            for (var i = 0; i < state.freqDist.length; i++) {
                var b = state.freqDist[i];
                tbody += '<tr><td>' + C.fmt(b.lower, 2) + ' \u2013 ' + C.fmt(b.upper, 2) + '</td>' +
                         '<td>' + b.frequency + '</td>' +
                         '<td>' + C.fmtPct(b.relativeFreq, 1) + '</td>' +
                         '<td>' + b.cumulativeFreq + '</td></tr>';
            }
            tbody += '</tbody>';
            table.innerHTML = thead + tbody;
            freqSection.appendChild(table);
            container.appendChild(freqSection);
        }
    }

    /* ===== Prepare Graph ===== */

    function prepareGraph() {
        var graphFn = function() {
            if (!els.graphContainer) return;
            els.graphContainer.innerHTML = '';

            var needHistogram = state.showHistogram && state.freqDist.length > 0;
            var needBoxPlot = state.showBoxPlot && state.data.length > 0;

            if (needHistogram) {
                var histDiv = document.createElement('div');
                histDiv.id = 'stat-histogram';
                histDiv.style.cssText = 'width:100%;min-height:360px;';
                els.graphContainer.appendChild(histDiv);
                G.renderHistogram('stat-histogram', state.freqDist, {
                    title: 'Frequency Histogram',
                    normalOverlay: true,
                    mean: state.stats.mean,
                    sd: state.stats.sd,
                    n: state.stats.n
                });
            }

            if (needBoxPlot) {
                var boxDiv = document.createElement('div');
                boxDiv.id = 'stat-boxplot';
                boxDiv.style.cssText = 'width:100%;min-height:320px;margin-top:1rem;';
                els.graphContainer.appendChild(boxDiv);
                G.renderBoxPlot('stat-boxplot', state.data, {
                    title: 'Box & Whisker Plot',
                    yLabel: 'Value'
                });
            }

            if (!needHistogram && !needBoxPlot) {
                els.graphContainer.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>Enable histogram or box plot</h3><p>Check the options in the input panel.</p></div>';
            }
        };

        // If graph tab is visible, render immediately; otherwise queue
        var graphPanel = document.getElementById('stat-panel-graph');
        if (graphPanel && graphPanel.classList.contains('active')) {
            graphFn();
        } else {
            state.pendingGraph = graphFn;
        }
    }

    /* ===== Load Compiler ===== */

    function loadCompiler() {
        if (!els.compilerIframe || state.data.length === 0) return;
        var code = E.buildPythonCode('Summary Statistics', state.data, { histogram: true });
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Random Data ===== */

    var randomPresets = [
        { label: 'Normal (mean=50, sd=10)', fn: function() { return genNormal(20, 50, 10); } },
        { label: 'Normal (mean=100, sd=15)', fn: function() { return genNormal(25, 100, 15); } },
        { label: 'Uniform 1-100', fn: function() { return genUniform(20, 1, 100); } },
        { label: 'Skewed right', fn: function() { return genSkewed(25, true); } },
        { label: 'Skewed left', fn: function() { return genSkewed(25, false); } },
        { label: 'Bimodal', fn: function() { return genBimodal(30); } },
        { label: 'With outliers', fn: function() { return genWithOutliers(20); } }
    ];

    function genNormal(n, mean, sd) {
        var arr = [];
        for (var i = 0; i < n; i++) {
            // Box-Muller transform
            var u1 = Math.random(), u2 = Math.random();
            var z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
            arr.push(Math.round((mean + sd * z) * 10) / 10);
        }
        return arr;
    }

    function genUniform(n, lo, hi) {
        var arr = [];
        for (var i = 0; i < n; i++) {
            arr.push(Math.round((lo + Math.random() * (hi - lo)) * 10) / 10);
        }
        return arr;
    }

    function genSkewed(n, right) {
        var arr = [];
        for (var i = 0; i < n; i++) {
            // Exponential-ish distribution
            var val = -Math.log(1 - Math.random()) * 20;
            arr.push(Math.round((right ? val : 100 - val) * 10) / 10);
        }
        return arr;
    }

    function genBimodal(n) {
        var arr = [];
        for (var i = 0; i < n; i++) {
            var mean = Math.random() < 0.5 ? 30 : 70;
            var u1 = Math.random(), u2 = Math.random();
            var z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
            arr.push(Math.round((mean + 8 * z) * 10) / 10);
        }
        return arr;
    }

    function genWithOutliers(n) {
        var arr = genNormal(n, 50, 5);
        // Add 2-3 outliers
        arr.push(Math.round((5 + Math.random() * 5) * 10) / 10);
        arr.push(Math.round((90 + Math.random() * 15) * 10) / 10);
        if (Math.random() > 0.5) arr.push(Math.round((95 + Math.random() * 10) * 10) / 10);
        return arr;
    }

    function generateRandom() {
        var preset = randomPresets[Math.floor(Math.random() * randomPresets.length)];
        var data = preset.fn();
        if (els.dataInput) {
            els.dataInput.value = data.join(', ');
            updatePreview();
            calculate();
        }
    }

    /* ===== Clear ===== */

    function clear() {
        if (els.dataInput) els.dataInput.value = '';
        state.data = [];
        state.stats = null;
        state.quartiles = null;
        state.shape = null;
        state.freqDist = null;
        state.pendingGraph = null;

        C.showEmpty(els.resultContent, '\uD83D\uDCCA', 'Enter data and click Calculate', 'Paste numbers separated by commas, spaces, or newlines for instant descriptive statistics.');
        E.hideActionButtons(els.resultActions);
        if (els.graphContainer) els.graphContainer.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate statistics to see interactive charts.</p></div>';
        updatePreview();
    }

    /* ===== Action Buttons (handled by E.renderActionButtons) ===== */
    function initActions() {}

    /* ===== Share URL Restore ===== */

    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (shared && shared.data && els.dataInput) {
            els.dataInput.value = shared.data;
            calculate();
        }
    }

    /* ===== Init ===== */

    function init() {
        initDOM();
        initTabs();
        initExamples();
        initActions();

        // Input events
        if (els.dataInput) {
            els.dataInput.addEventListener('input', updatePreview);
        }
        if (els.calcBtn) {
            els.calcBtn.addEventListener('click', calculate);
        }
        if (els.clearBtn) {
            els.clearBtn.addEventListener('click', clear);
        }
        if (els.randomBtn) {
            els.randomBtn.addEventListener('click', generateRandom);
        }

        // Try to restore from share URL first
        var shared = E.parseShareUrl();
        if (shared && shared.data) {
            els.dataInput.value = shared.data;
        }

        // Auto-calculate with default data
        updatePreview();
        calculate();

        // Init scroll reveal for educational content
        C.initScrollReveal();

        // FAQ accordion
        initFAQ();
    }

    function initFAQ() {
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

    /* ===== Boot ===== */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
