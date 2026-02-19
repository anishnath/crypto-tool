/**
 * Mean, Median, Mode Calculator — Orchestration IIFE
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
        pendingGraph: null
    };

    /* ===== Examples ===== */
    var examples = {
        'test-scores': '72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79, 85, 90, 85',
        'shoe-sizes': '7, 8, 8, 9, 9, 9, 10, 10, 10, 10, 11, 11, 12, 8, 9, 10, 10, 9',
        'temperatures': '68, 72, 75, 71, 69, 74, 73, 70, 76, 67, 71, 73, 72, 74, 70, 72, 73, 71',
        'dice-rolls': '3, 5, 2, 6, 4, 1, 3, 5, 6, 2, 4, 3, 5, 1, 6, 3, 4, 2, 5, 3, 6, 4, 3, 5, 2',
        'with-outliers': '12, 15, 15, 16, 18, 19, 20, 21, 22, 22, 23, 24, 25, 85, 92'
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.dataInput = document.getElementById('mmm-data-input');
        els.preview = document.getElementById('mmm-preview');
        els.resultContent = document.getElementById('mmm-result-content');
        els.resultActions = document.getElementById('mmm-result-actions');
        els.graphContent = document.getElementById('mmm-graph-content');
        els.compilerIframe = document.getElementById('mmm-compiler-iframe');
        els.calcBtn = document.getElementById('mmm-calc-btn');
        els.clearBtn = document.getElementById('mmm-clear-btn');
        els.randomBtn = document.getElementById('mmm-random-btn');
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
                var target = document.getElementById('mmm-panel-' + panel);
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

        state.data = data;
        state.sorted = data.slice().sort(function(a, b) { return a - b; });
        state.stats = C.computeDescriptive(data);
        state.quartiles = C.computeQuartiles(state.sorted);

        renderResults();
        prepareGraph();
        updatePreview();

        E.renderActionButtons(els.resultActions, {
            toolName: 'Mean Median Mode',
            getLatex: function() { return state.stats ? E.buildLatex('Mean, Median, Mode', state.stats) : ''; },
            getShareState: function() { return { data: els.dataInput ? els.dataInput.value : '' }; },
            resultEl: '#mmm-result-content'
        });
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render ===== */

    function renderResults() {
        var s = state.stats;
        var q = state.quartiles;
        var container = els.resultContent;
        container.innerHTML = '';

        // Hero: three measures side by side
        var hero = document.createElement('div');
        hero.style.cssText = 'display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.75rem;margin-bottom:1rem;';
        hero.innerHTML =
            buildHeroCard('Mean', C.fmt(s.mean, 6), 'x\u0305 = \u03A3x/n') +
            buildHeroCard('Median', C.fmt(s.median, 6), 'Middle value') +
            buildHeroCard('Mode', formatMode(s.mode), s.mode.description);
        container.appendChild(hero);

        // Badge
        var badge = document.createElement('div');
        badge.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
        badge.innerHTML = '<span class="stat-result-badge">n = ' + s.n + '</span>' +
                          '<span class="stat-result-badge">Range = ' + C.fmt(s.range) + '</span>';
        container.appendChild(badge);

        // Central Tendency section
        container.appendChild(C.buildStatSection('Central Tendency', [
            C.buildStatRow('Mean (x\u0305)', C.fmt(s.mean, 6)),
            C.buildStatRow('Median', C.fmt(s.median, 6)),
            C.buildStatRow('Mode', formatMode(s.mode)),
            C.buildStatRow('Mode Frequency', s.mode.modes.length > 0 ? String(s.mode.maxFreq) : 'N/A')
        ]));

        // Spread section
        container.appendChild(C.buildStatSection('Spread & Position', [
            C.buildStatRow('Min', C.fmt(s.min)),
            C.buildStatRow('Max', C.fmt(s.max)),
            C.buildStatRow('Range', C.fmt(s.range)),
            C.buildStatRow('Q1 (25th %ile)', C.fmt(q.q1)),
            C.buildStatRow('Q3 (75th %ile)', C.fmt(q.q3)),
            C.buildStatRow('IQR', C.fmt(q.iqr)),
            C.buildStatRow('Std Dev (sample)', C.fmt(s.sd)),
            C.buildStatRow('Variance', C.fmt(s.variance))
        ]));

        // Outliers
        var outlierText = q.outliers.length > 0 ? q.outliers.map(function(v) { return C.fmt(v); }).join(', ') : 'None detected';
        container.appendChild(C.buildStatSection('Outlier Detection (IQR Method)', [
            C.buildStatRow('Lower Fence', C.fmt(q.lowerFence)),
            C.buildStatRow('Upper Fence', C.fmt(q.upperFence)),
            C.buildStatRow('Outliers', outlierText)
        ]));

        // Step-by-step
        var stepsSection = document.createElement('div');
        stepsSection.className = 'stat-section';
        var stepsTitle = document.createElement('div');
        stepsTitle.className = 'stat-section-title';
        stepsTitle.textContent = 'Step-by-Step Calculation';
        stepsSection.appendChild(stepsTitle);

        // Mean step
        var displayNums = state.sorted.slice(0, 15).map(function(v) { return C.fmt(v); }).join(' + ');
        if (state.sorted.length > 15) displayNums += ' + \\cdots';
        stepsSection.appendChild(C.buildStepDOM(1, 'Calculate the mean', '\\bar{x} = \\frac{' + displayNums + '}{' + s.n + '} = ' + C.fmt(s.mean, 6)));

        // Median step
        var medLatex;
        if (s.n % 2 === 1) {
            var midIdx = Math.floor(s.n / 2);
            medLatex = '\\tilde{x} = x_{(' + (midIdx + 1) + ')} = ' + C.fmt(state.sorted[midIdx], 6);
        } else {
            var i1 = s.n / 2 - 1, i2 = s.n / 2;
            medLatex = '\\tilde{x} = \\frac{x_{(' + (i1 + 1) + ')} + x_{(' + (i2 + 1) + ')}}{2} = \\frac{' + C.fmt(state.sorted[i1]) + ' + ' + C.fmt(state.sorted[i2]) + '}{2} = ' + C.fmt(s.median, 6);
        }
        stepsSection.appendChild(C.buildStepDOM(2, 'Find the median (middle value of sorted data)', medLatex));

        // Mode step
        var modeLatex;
        if (s.mode.modes.length === 0) {
            modeLatex = '\\text{No mode — all values appear with equal frequency}';
        } else {
            modeLatex = '\\text{Mode} = ' + s.mode.modes.join(', ') + ' \\quad (\\text{frequency} = ' + s.mode.maxFreq + ')';
        }
        stepsSection.appendChild(C.buildStepDOM(3, 'Identify the mode (most frequent value)', modeLatex));

        // IQR step
        stepsSection.appendChild(C.buildStepDOM(4, 'Compute IQR for outlier detection', 'IQR = Q_3 - Q_1 = ' + C.fmt(q.q3) + ' - ' + C.fmt(q.q1) + ' = ' + C.fmt(q.iqr) + ', \\quad \\text{Fences: } [' + C.fmt(q.lowerFence) + ',\\,' + C.fmt(q.upperFence) + ']'));

        container.appendChild(stepsSection);

        // Sorted values with highlights
        renderSortedChips(container);
    }

    function buildHeroCard(label, value, sub) {
        return '<div style="text-align:center;padding:0.75rem;background:var(--stat-light);border-radius:0.75rem;">' +
               '<div style="font-size:0.7rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--stat-tool);margin-bottom:0.2rem;">' + label + '</div>' +
               '<div style="font-size:1.25rem;font-weight:800;color:var(--text-primary);font-family:var(--font-mono);">' + value + '</div>' +
               '<div style="font-size:0.65rem;color:var(--text-muted);margin-top:0.15rem;">' + sub + '</div>' +
               '</div>';
    }

    function formatMode(modeObj) {
        if (modeObj.modes.length === 0) return 'No mode';
        if (modeObj.modes.length > 3) return modeObj.modes.slice(0, 3).join(', ') + '\u2026 (' + modeObj.modes.length + ')';
        return modeObj.modes.join(', ');
    }

    function renderSortedChips(container) {
        var section = document.createElement('div');
        section.className = 'stat-section';
        var title = document.createElement('div');
        title.className = 'stat-section-title';
        title.textContent = 'Sorted Values';
        section.appendChild(title);

        var hint = document.createElement('div');
        hint.style.cssText = 'font-size:0.75rem;color:var(--text-muted);margin-bottom:0.5rem;';
        hint.textContent = 'Median highlighted in green, mode in purple, outliers in red.';
        section.appendChild(hint);

        var chipsDiv = document.createElement('div');
        chipsDiv.style.cssText = 'display:flex;flex-wrap:wrap;gap:4px;';

        var q = state.quartiles;
        var s = state.stats;
        var outlierSet = {};
        for (var i = 0; i < q.outliers.length; i++) outlierSet[q.outliers[i]] = true;
        var modeSet = {};
        for (var j = 0; j < s.mode.modes.length; j++) modeSet[s.mode.modes[j]] = true;

        var medianVal = s.median;
        var medianFound = false;

        for (var k = 0; k < state.sorted.length; k++) {
            var v = state.sorted[k];
            var chip = document.createElement('span');
            chip.style.cssText = 'display:inline-block;padding:2px 8px;border-radius:999px;font-size:0.75rem;font-weight:600;border:1px solid var(--border);background:var(--bg-secondary);color:var(--text-primary);';

            if (outlierSet[v]) {
                chip.style.background = '#fee2e2';
                chip.style.color = '#991b1b';
                chip.style.borderColor = '#fca5a5';
            } else if (!medianFound && v === medianVal) {
                chip.style.background = '#dcfce7';
                chip.style.color = '#065f46';
                chip.style.borderColor = '#86efac';
                medianFound = true;
            } else if (modeSet[v]) {
                chip.style.background = '#ede9fe';
                chip.style.color = '#5b21b6';
                chip.style.borderColor = '#c4b5fd';
            }

            chip.textContent = String(v);
            chipsDiv.appendChild(chip);
        }

        section.appendChild(chipsDiv);
        container.appendChild(section);
    }

    /* ===== Graph ===== */

    function prepareGraph() {
        var graphFn = function() {
            if (!els.graphContent) return;
            els.graphContent.innerHTML = '';

            // Histogram
            var histDiv = document.createElement('div');
            histDiv.id = 'mmm-histogram';
            histDiv.style.cssText = 'width:100%;min-height:350px;';
            els.graphContent.appendChild(histDiv);

            var freqDist = C.computeFrequencyDist(state.sorted);
            G.renderHistogram('mmm-histogram', freqDist, {
                title: 'Frequency Distribution',
                meanLine: state.stats.mean,
                medianLine: state.stats.median
            });

            // Box plot
            var boxDiv = document.createElement('div');
            boxDiv.id = 'mmm-boxplot';
            boxDiv.style.cssText = 'width:100%;min-height:250px;margin-top:1rem;';
            els.graphContent.appendChild(boxDiv);

            G.renderBoxPlot('mmm-boxplot', state.data, {
                title: 'Box Plot'
            });
        };

        var graphPanel = document.getElementById('mmm-panel-graph');
        if (graphPanel && graphPanel.classList.contains('active')) {
            graphFn();
        } else {
            state.pendingGraph = graphFn;
        }
    }

    /* ===== Compiler ===== */

    function loadCompiler() {
        if (!els.compilerIframe || state.data.length === 0) return;
        var lines = [
            'import numpy as np',
            'from scipy import stats as sp',
            'from collections import Counter',
            '',
            '# Mean, Median, Mode Calculator',
            'data = np.array([' + state.data.join(', ') + '])',
            '',
            '# Central Tendency',
            'mean = np.mean(data)',
            'median = np.median(data)',
            'counter = Counter(data)',
            'max_freq = max(counter.values())',
            'modes = sorted([k for k, v in counter.items() if v == max_freq])',
            'has_mode = len(modes) < len(counter)',
            '',
            'print(f"n = {len(data)}")',
            'print(f"Mean = {mean:.6f}")',
            'print(f"Median = {median:.6f}")',
            'print(f"Mode = {modes} (freq={max_freq})" if has_mode else "No mode")',
            '',
            '# Quartiles & Outliers',
            'q1 = np.percentile(data, 25)',
            'q3 = np.percentile(data, 75)',
            'iqr = q3 - q1',
            'lower = q1 - 1.5 * iqr',
            'upper = q3 + 1.5 * iqr',
            'outliers = data[(data < lower) | (data > upper)]',
            '',
            'print(f"\\nQ1 = {q1:.4f}, Q3 = {q3:.4f}, IQR = {iqr:.4f}")',
            'print(f"Fences: [{lower:.4f}, {upper:.4f}]")',
            'print(f"Outliers: {sorted(outliers)}" if len(outliers) else "No outliers")',
            '',
            '# Spread',
            'print(f"\\nRange = {np.ptp(data):.4f}")',
            'print(f"Std Dev (sample) = {np.std(data, ddof=1):.6f}")',
            'print(f"Variance = {np.var(data, ddof=1):.6f}")',
            'print(f"\\nSorted: {sorted(data.tolist())}")'
        ];
        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Random ===== */

    function generateRandom() {
        var presets = [
            { name: 'Normal', fn: function() { var u = Math.random(), v = Math.random(); return Math.round((50 + 15 * Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v)) * 10) / 10; } },
            { name: 'With repeats', fn: function() { return Math.floor(Math.random() * 20) + 1; } },
            { name: 'Bimodal', fn: function() { return Math.random() < 0.5 ? Math.round((30 + 5 * (Math.random() + Math.random() - 1)) * 10) / 10 : Math.round((70 + 5 * (Math.random() + Math.random() - 1)) * 10) / 10; } },
            { name: 'With outliers', fn: function() { if (Math.random() < 0.1) return Math.round((150 + Math.random() * 50) * 10) / 10; return Math.round((40 + Math.random() * 30) * 10) / 10; } },
            { name: 'Integers', fn: function() { return Math.floor(Math.random() * 50) + 1; } }
        ];
        var preset = presets[Math.floor(Math.random() * presets.length)];
        var sizes = [15, 20, 25, 30];
        var n = sizes[Math.floor(Math.random() * sizes.length)];
        var arr = [];
        for (var i = 0; i < n; i++) arr.push(preset.fn());

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
        state.sorted = [];
        state.stats = null;
        state.quartiles = null;
        state.pendingGraph = null;
        C.showEmpty(els.resultContent, '\uD83D\uDCCA', 'Enter data and click Calculate', 'Paste numbers to find mean, median, mode with step-by-step solution.');
        E.hideActionButtons(els.resultActions);
        if (els.graphContent) els.graphContent.innerHTML = '<div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see histogram and box plot.</p></div>';
        updatePreview();
    }

    /* ===== Actions (handled by E.renderActionButtons) ===== */
    function initActions() {}

    /* ===== Init ===== */

    function init() {
        initDOM();
        initTabs();
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
