/**
 * Percentile Calculator — Orchestration IIFE
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
        mode: 'rank', // 'rank' | 'value' | 'summary'
        targetValue: null,
        targetPercentile: null,
        stats: null,
        quartiles: null,
        pendingGraph: null
    };

    /* ===== Examples ===== */
    var examples = {
        'test-scores': '72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79',
        'salaries': '35000, 42000, 48000, 55000, 62000, 68000, 75000, 85000, 95000, 120000, 150000',
        'heights': '155, 158, 160, 162, 163, 165, 167, 168, 170, 172, 175, 178, 180, 183, 185',
        'response-times': '12, 15, 18, 20, 22, 25, 28, 32, 35, 42, 55, 78, 95, 120, 250'
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.dataInput    = document.getElementById('pct-data-input');
        els.preview      = document.getElementById('pct-preview');
        els.resultContent= document.getElementById('pct-result-content');
        els.resultActions= document.getElementById('pct-result-actions');
        els.graphContent = document.getElementById('pct-graph-content');
        els.compilerIframe = document.getElementById('pct-compiler-iframe');
        els.calcBtn      = document.getElementById('pct-calc-btn');
        els.clearBtn     = document.getElementById('pct-clear-btn');
        els.randomBtn    = document.getElementById('pct-random-btn');
        els.rankBtn      = document.getElementById('pct-mode-rank');
        els.valueBtn     = document.getElementById('pct-mode-value');
        els.summaryBtn   = document.getElementById('pct-mode-summary');
        els.targetGroup  = document.getElementById('pct-target-group');
        els.targetLabel  = document.getElementById('pct-target-label');
        els.targetInput  = document.getElementById('pct-target-input');
        els.targetHint   = document.getElementById('pct-target-hint');
    }

    /* ===== Tabs ===== */

    function initTabs() {
        var tabs = document.querySelectorAll('.stat-output-tab');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].addEventListener('click', function() {
                var target = this.getAttribute('data-tab');
                document.querySelectorAll('.stat-output-tab').forEach(function(t) { t.classList.remove('active'); });
                document.querySelectorAll('.stat-panel').forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById(target);
                if (panel) panel.classList.add('active');
                if (target === 'pct-graph-panel' && state.pendingGraph) { state.pendingGraph(); state.pendingGraph = null; }
                if (target === 'pct-compiler-panel' && !els.compilerIframe.src) loadCompiler();
            });
        }
    }

    /* ===== Mode Toggle ===== */

    function initModes() {
        els.rankBtn.addEventListener('click', function() { setMode('rank'); });
        els.valueBtn.addEventListener('click', function() { setMode('value'); });
        els.summaryBtn.addEventListener('click', function() { setMode('summary'); });
    }

    function setMode(m) {
        state.mode = m;
        els.rankBtn.classList.toggle('active', m === 'rank');
        els.valueBtn.classList.toggle('active', m === 'value');
        els.summaryBtn.classList.toggle('active', m === 'summary');

        if (m === 'summary') {
            els.targetGroup.style.display = 'none';
        } else {
            els.targetGroup.style.display = '';
            if (m === 'rank') {
                els.targetLabel.textContent = 'Value to find rank for';
                els.targetInput.placeholder = 'e.g. 88';
                els.targetHint.textContent = 'What percentile is this value at?';
                els.targetInput.value = els.targetInput.value || '88';
                els.targetInput.removeAttribute('min');
                els.targetInput.removeAttribute('max');
            } else {
                els.targetLabel.textContent = 'Target percentile (0\u2013100)';
                els.targetInput.placeholder = 'e.g. 75';
                els.targetHint.textContent = 'Find the value at this percentile';
                els.targetInput.value = els.targetInput.value || '75';
                els.targetInput.setAttribute('min', '0');
                els.targetInput.setAttribute('max', '100');
            }
        }
        if (state.data.length) calculate();
    }

    /* ===== Preview ===== */

    function updatePreview() {
        var nums = C.parseNumbers(els.dataInput.value);
        els.preview.textContent = nums.length ? nums.length + ' data point' + (nums.length !== 1 ? 's' : '') : 'Enter numbers above';
    }

    /* ===== Percentile computations ===== */

    function calcPercentile(sorted, p) {
        if (!sorted.length) return null;
        if (sorted.length === 1) return sorted[0];
        var n = sorted.length;
        var pos = (n + 1) * (p / 100);
        if (pos <= 1) return sorted[0];
        if (pos >= n) return sorted[n - 1];
        var lo = Math.floor(pos) - 1;
        var hi = Math.ceil(pos) - 1;
        var frac = pos - Math.floor(pos);
        return sorted[lo] + frac * (sorted[hi] - sorted[lo]);
    }

    function calcPercentileRank(sorted, value) {
        var n = sorted.length, below = 0, equal = 0;
        for (var i = 0; i < n; i++) {
            if (sorted[i] < value) below++;
            else if (sorted[i] === value) equal++;
        }
        return ((below + 0.5 * equal) / n) * 100;
    }

    function calcQuartiles(sorted) {
        var q1 = calcPercentile(sorted, 25);
        var q2 = calcPercentile(sorted, 50);
        var q3 = calcPercentile(sorted, 75);
        var iqr = q3 - q1;
        var lf = q1 - 1.5 * iqr;
        var uf = q3 + 1.5 * iqr;
        return {
            min: sorted[0], q1: q1, median: q2, q3: q3, max: sorted[sorted.length - 1],
            iqr: iqr, lowerFence: lf, upperFence: uf,
            outliers: sorted.filter(function(x) { return x < lf || x > uf; })
        };
    }

    /* ===== Calculate ===== */

    function calculate() {
        var nums = C.parseNumbers(els.dataInput.value);
        if (!nums.length) { C.showError(els.resultContent, 'Please enter at least one number.'); return; }
        state.data = nums;
        state.sorted = nums.slice().sort(function(a, b) { return a - b; });
        state.stats = C.computeDescriptive(nums);
        state.quartiles = calcQuartiles(state.sorted);

        if (state.mode === 'rank') {
            var v = parseFloat(els.targetInput.value);
            if (isNaN(v)) { C.showError(els.resultContent, 'Enter a valid number for the target value.'); return; }
            state.targetValue = v;
            renderRankResult();
        } else if (state.mode === 'value') {
            var p = parseFloat(els.targetInput.value);
            if (isNaN(p) || p < 0 || p > 100) { C.showError(els.resultContent, 'Enter a percentile between 0 and 100.'); return; }
            state.targetPercentile = p;
            renderValueResult();
        } else {
            renderSummaryResult();
        }

        prepareGraph();
        els.resultActions.innerHTML =
            '<button class="stat-action-btn" onclick="document.querySelector(\'[data-tab=pct-graph-panel]\').click()" title="View box plot"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="9" y1="3" x2="9" y2="21"/></svg></button>' +
            '<button class="stat-action-btn" onclick="StatsExport.copyLatex(\'Percentile\', window._pctLatexStats)" title="Copy LaTeX"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg></button>' +
            '<button class="stat-action-btn" onclick="StatsExport.copyShareUrl({d:document.getElementById(\'pct-data-input\').value,m:\'' + state.mode + '\',t:document.getElementById(\'pct-target-input\')?.value||\'\'} )" title="Share URL"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" y1="2" x2="12" y2="15"/></svg></button>';

        // Store latex stats for copy
        window._pctLatexStats = {
            n: state.stats.n, mean: state.stats.mean, median: state.stats.median,
            q1: state.quartiles.q1, q3: state.quartiles.q3, iqr: state.quartiles.iqr,
            min: state.quartiles.min, max: state.quartiles.max
        };

        // Reset compiler — reload if Python tab is active, otherwise just clear
        var compilerTab = document.querySelector('[data-tab="pct-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) {
            loadCompiler();
        } else {
            els.compilerIframe.removeAttribute('src');
        }
    }

    /* ===== Render: Percentile Rank ===== */

    function renderRankResult() {
        var v = state.targetValue;
        var rank = calcPercentileRank(state.sorted, v);
        var q = state.quartiles;
        var quartileLabel;
        if (v < q.q1) quartileLabel = 'Below Q1 (Bottom 25%)';
        else if (v < q.median) quartileLabel = 'Q1\u2013Median (25th\u201350th)';
        else if (v < q.q3) quartileLabel = 'Median\u2013Q3 (50th\u201375th)';
        else quartileLabel = 'Above Q3 (Top 25%)';

        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(rank, 2) + '</span><span class="stat-hero-label">Percentile Rank</span></div>';
        h += '<div style="text-align:center;margin-bottom:1rem"><span class="stat-result-badge">' + quartileLabel + '</span></div>';

        // Result section
        h += buildSection('Percentile Rank', [
            ['Your Value', C.fmt(v, 4)],
            ['Percentile Rank', C.fmt(rank, 2) + '%'],
            ['Better Than', C.fmt(rank, 1) + '% of values'],
            ['Worse Than', C.fmt(100 - rank, 1) + '% of values']
        ]);

        h += buildFiveNumberSection(q);
        h += buildDescriptiveSection();
        h += renderSteps('rank', v, rank);

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Value at Percentile ===== */

    function renderValueResult() {
        var p = state.targetPercentile;
        var val = calcPercentile(state.sorted, p);
        var q = state.quartiles;
        var below = state.sorted.filter(function(x) { return x < val; }).length;
        var above = state.sorted.filter(function(x) { return x > val; }).length;
        var n = state.stats.n;

        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(val, 4) + '</span><span class="stat-hero-label">Value at P' + C.fmt(p, 0) + '</span></div>';

        h += buildSection('Value at Percentile', [
            ['Target Percentile', C.fmt(p, 1) + '%'],
            ['Value at P' + C.fmt(p, 0), C.fmt(val, 4)],
            ['Values Below', below + ' (' + C.fmt((below / n) * 100, 1) + '%)'],
            ['Values Above', above + ' (' + C.fmt((above / n) * 100, 1) + '%)']
        ]);

        h += buildFiveNumberSection(q);
        h += buildDescriptiveSection();
        h += renderSteps('value', p, val);

        h += '<div class="stat-interpretation stat-interpretation-normal">' +
            '<strong>Interpretation:</strong> ' + C.fmt(p, 1) + '% of values in the dataset are below ' +
            C.fmt(val, 4) + ', and ' + C.fmt(100 - p, 1) + '% are above it.</div>';

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Full Summary ===== */

    function renderSummaryResult() {
        var q = state.quartiles;
        var s = state.stats;

        var h = '<div class="stat-hero"><span class="stat-hero-value">Q1=' + C.fmt(q.q1, 2) + '  Q3=' + C.fmt(q.q3, 2) + '</span><span class="stat-hero-label">Five-Number Summary</span></div>';

        if (q.outliers.length) {
            h += '<div style="text-align:center;margin-bottom:1rem"><span class="stat-result-badge" style="background:var(--error);color:#fff">' + q.outliers.length + ' outlier' + (q.outliers.length > 1 ? 's' : '') + ' detected</span></div>';
        }

        h += buildFiveNumberSection(q);

        h += buildSection('Spread Measures', [
            ['Range', C.fmt(q.max - q.min, 4)],
            ['IQR (Q3 \u2212 Q1)', C.fmt(q.iqr, 4)],
            ['Lower Fence', C.fmt(q.lowerFence, 4)],
            ['Upper Fence', C.fmt(q.upperFence, 4)]
        ]);

        h += buildDescriptiveSection();

        // Key percentiles
        var pcts = [10, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 95, 99];
        var pctRows = [];
        for (var i = 0; i < pcts.length; i++) {
            pctRows.push(['P' + pcts[i], C.fmt(calcPercentile(state.sorted, pcts[i]), 4)]);
        }
        h += buildSection('Percentile Table', pctRows);

        if (q.outliers.length) {
            var olRows = [];
            var lower = state.sorted.filter(function(x) { return x < q.lowerFence; });
            var upper = state.sorted.filter(function(x) { return x > q.upperFence; });
            if (lower.length) olRows.push(['Lower Outliers', lower.map(function(x) { return C.fmt(x, 2); }).join(', ')]);
            if (upper.length) olRows.push(['Upper Outliers', upper.map(function(x) { return C.fmt(x, 2); }).join(', ')]);
            olRows.push(['Detection Rule', 'x < Q1 \u2212 1.5\u00d7IQR  or  x > Q3 + 1.5\u00d7IQR']);
            h += buildSection('Outliers', olRows);
        }

        h += renderSteps('summary', null, null);

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Helpers ===== */

    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function buildFiveNumberSection(q) {
        return buildSection('Five-Number Summary', [
            ['Minimum', C.fmt(q.min, 4)],
            ['Q1 (25th)', C.fmt(q.q1, 4)],
            ['Median (50th)', C.fmt(q.median, 4)],
            ['Q3 (75th)', C.fmt(q.q3, 4)],
            ['Maximum', C.fmt(q.max, 4)]
        ]);
    }

    function buildDescriptiveSection() {
        var s = state.stats;
        return buildSection('Descriptive Statistics', [
            ['Sample Size (n)', s.n],
            ['Mean', C.fmt(s.mean, 4)],
            ['Std Deviation', C.fmt(s.sd, 4)],
            ['Variance', C.fmt(s.variance, 4)]
        ]);
    }

    function renderSteps(mode, arg1, arg2) {
        var n = state.stats.n;
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (mode === 'rank') {
            h += step(1, 'Sort the data', 'Sort all ' + n + ' values in ascending order.');
            h += step(2, 'Count values below and equal', '<span class="stat-katex" data-tex="\\text{Below} = ' + state.sorted.filter(function(x){return x < arg1;}).length + ',\;\\text{Equal} = ' + state.sorted.filter(function(x){return x === arg1;}).length + '"></span>');
            h += step(3, 'Apply midpoint formula', '<span class="stat-katex" data-tex="PR = \\frac{B + 0.5E}{n} \\times 100 = \\frac{' + state.sorted.filter(function(x){return x < arg1;}).length + ' + 0.5 \\times ' + state.sorted.filter(function(x){return x === arg1;}).length + '}{' + n + '} \\times 100"></span>');
            h += step(4, 'Result', '<span class="stat-katex" data-tex="PR = ' + C.fmt(arg2, 2) + '\\%"></span>');
        } else if (mode === 'value') {
            var pos = (n + 1) * (arg1 / 100);
            h += step(1, 'Sort the data', 'Sort all ' + n + ' values in ascending order.');
            h += step(2, 'Calculate position', '<span class="stat-katex" data-tex="L = (n+1) \\times \\frac{p}{100} = (' + n + '+1) \\times \\frac{' + C.fmt(arg1, 1) + '}{100} = ' + C.fmt(pos, 4) + '"></span>');
            if (pos !== Math.floor(pos)) {
                var lo = Math.max(0, Math.floor(pos) - 1);
                var hi = Math.min(state.sorted.length - 1, Math.ceil(pos) - 1);
                var frac = pos - Math.floor(pos);
                h += step(3, 'Interpolate', '<span class="stat-katex" data-tex="V = x_{' + (lo+1) + '} + ' + C.fmt(frac, 4) + ' \\times (x_{' + (hi+1) + '} - x_{' + (lo+1) + '}) = ' + C.fmt(state.sorted[lo], 4) + ' + ' + C.fmt(frac, 4) + ' \\times ' + C.fmt(state.sorted[hi] - state.sorted[lo], 4) + '"></span>');
            }
            h += step(pos !== Math.floor(pos) ? 4 : 3, 'Result', '<span class="stat-katex" data-tex="P_{' + C.fmt(arg1, 0) + '} = ' + C.fmt(arg2, 4) + '"></span>');
        } else {
            var q = state.quartiles;
            h += step(1, 'Sort data', 'Sort all ' + n + ' values in ascending order.');
            h += step(2, 'Calculate quartiles', '<span class="stat-katex" data-tex="Q_1 = ' + C.fmt(q.q1, 4) + ',\; Q_2 = ' + C.fmt(q.median, 4) + ',\; Q_3 = ' + C.fmt(q.q3, 4) + '"></span>');
            h += step(3, 'Calculate IQR', '<span class="stat-katex" data-tex="IQR = Q_3 - Q_1 = ' + C.fmt(q.q3, 4) + ' - ' + C.fmt(q.q1, 4) + ' = ' + C.fmt(q.iqr, 4) + '"></span>');
            h += step(4, 'Outlier fences', '<span class="stat-katex" data-tex="\\text{Lower} = Q_1 - 1.5 \\times IQR = ' + C.fmt(q.lowerFence, 4) + ',\; \\text{Upper} = Q_3 + 1.5 \\times IQR = ' + C.fmt(q.upperFence, 4) + '"></span>');
        }
        return h + '</div>';
    }

    function step(num, title, content) {
        return '<div class="stat-step"><div class="stat-step-number">' + num + '</div><div class="stat-step-content"><strong>' + title + '</strong><div style="margin-top:0.25rem">' + content + '</div></div></div>';
    }

    function renderKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var tex = spans[i].getAttribute('data-tex');
            if (tex && window.katex) {
                try { window.katex.render(tex, spans[i], { throwOnError: false }); } catch(e) {}
            }
        }
    }

    /* ===== Graph ===== */

    function prepareGraph() {
        state.pendingGraph = function() {
            G.loadPlotly(function() {
                renderBoxPlot();
            });
        };
        // If graph tab already active, render immediately
        var graphTab = document.querySelector('[data-tab="pct-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) {
            state.pendingGraph();
            state.pendingGraph = null;
        }
    }

    function renderBoxPlot() {
        var gc = document.getElementById('pct-graph-content');
        if (gc) gc.innerHTML = '';
        var q = state.quartiles;
        var dark = G.isDarkMode();
        var colors = G.getPlotColors();

        var trace = {
            y: state.data,
            type: 'box',
            name: 'Data',
            marker: { color: '#e11d48', outliercolor: '#ef4444', size: 6 },
            line: { color: '#e11d48' },
            boxpoints: 'outliers',
            jitter: 0.3,
            whiskerwidth: 0.5
        };

        // If mode is 'rank', add a marker for the target value
        var traces = [trace];
        if (state.mode === 'rank' && state.targetValue !== null) {
            traces.push({
                y: [state.targetValue],
                x: ['Data'],
                type: 'scatter',
                mode: 'markers',
                name: 'Your Value (' + C.fmt(state.targetValue, 2) + ')',
                marker: { color: '#3b82f6', size: 14, symbol: 'diamond', line: { color: '#1e40af', width: 2 } }
            });
        }
        if (state.mode === 'value' && state.targetPercentile !== null) {
            var val = calcPercentile(state.sorted, state.targetPercentile);
            traces.push({
                y: [val],
                x: ['Data'],
                type: 'scatter',
                mode: 'markers',
                name: 'P' + C.fmt(state.targetPercentile, 0) + ' = ' + C.fmt(val, 2),
                marker: { color: '#10b981', size: 14, symbol: 'star', line: { color: '#065f46', width: 2 } }
            });
        }

        var layout = {
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            font: { color: colors.text, family: 'Inter, sans-serif' },
            margin: { l: 50, r: 20, t: 30, b: 30 },
            yaxis: { title: 'Value', gridcolor: colors.grid, zeroline: false },
            showlegend: traces.length > 1,
            legend: { orientation: 'h', y: -0.15 }
        };

        Plotly.newPlot('pct-graph-content', traces, layout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */

    function loadCompiler() {
        var dataStr = state.data.join(', ');
        var template = 'import numpy as np\nfrom scipy import stats\n\n';
        template += '# Data\ndata = np.array([' + dataStr + '])\ndata_sorted = np.sort(data)\nn = len(data)\n\n';
        template += '# Five-number summary\nprint("Five-Number Summary:")\nprint(f"  Min:    {np.min(data):.4f}")\nprint(f"  Q1:     {np.percentile(data, 25):.4f}")\nprint(f"  Median: {np.median(data):.4f}")\nprint(f"  Q3:     {np.percentile(data, 75):.4f}")\nprint(f"  Max:    {np.max(data):.4f}")\n\n';
        template += '# IQR and outliers\nq1 = np.percentile(data, 25)\nq3 = np.percentile(data, 75)\niqr = q3 - q1\nlower_fence = q1 - 1.5 * iqr\nupper_fence = q3 + 1.5 * iqr\nprint(f"\\nIQR: {iqr:.4f}")\nprint(f"Lower fence: {lower_fence:.4f}")\nprint(f"Upper fence: {upper_fence:.4f}")\noutliers = data[(data < lower_fence) | (data > upper_fence)]\nif len(outliers): print(f"Outliers: {outliers}")\nelse: print("No outliers detected")\n\n';

        if (state.mode === 'rank' && state.targetValue !== null) {
            template += '# Percentile rank\nvalue = ' + state.targetValue + '\nrank = stats.percentileofscore(data, value, kind="mean")\nprint(f"\\nPercentile rank of {value}: {rank:.2f}%")\n';
        } else if (state.mode === 'value' && state.targetPercentile !== null) {
            template += '# Value at percentile\np = ' + state.targetPercentile + '\nval = np.percentile(data, p)\nprint(f"\\nValue at P{p}: {val:.4f}")\n';
        }

        template += '\n# Key percentiles\nfor p in [10, 25, 50, 75, 90, 95, 99]:\n    print(f"  P{p:2d}: {np.percentile(data, p):.4f}")\n';

        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(template, null, cp);
    }

    /* ===== Random ===== */

    var randomPresets = [
        { name: 'Normal', fn: function() { var d=[]; for(var i=0;i<20;i++){var u1=Math.random(),u2=Math.random();d.push(Math.round((50+10*Math.sqrt(-2*Math.log(u1))*Math.cos(2*Math.PI*u2))*10)/10);}return d; }},
        { name: 'With outliers', fn: function() { var d=[]; for(var i=0;i<18;i++) d.push(Math.round((50+Math.random()*30)*10)/10); d.push(5,120); return d; }},
        { name: 'Uniform', fn: function() { var d=[]; for(var i=0;i<20;i++) d.push(Math.round(Math.random()*100*10)/10); return d; }},
        { name: 'Skewed', fn: function() { var d=[]; for(var i=0;i<20;i++) d.push(Math.round(Math.exp(Math.random()*4)*10)/10); return d; }}
    ];
    var rIdx = 0;

    function loadRandom() {
        var preset = randomPresets[rIdx % randomPresets.length];
        rIdx++;
        els.dataInput.value = preset.fn().join(', ');
        updatePreview();
        calculate();
    }

    /* ===== Examples ===== */

    function loadExample(key) {
        if (examples[key]) {
            els.dataInput.value = examples[key];
            updatePreview();
            calculate();
        }
    }

    /* ===== Clear ===== */

    function clearAll() {
        els.dataInput.value = '';
        els.targetInput.value = '';
        updatePreview();
        C.showEmpty(els.resultContent, '\u{1F4CA}', 'No Data Yet', 'Enter numbers and click Calculate');
        els.resultActions.innerHTML = '';
        if (els.compilerIframe.src) els.compilerIframe.src = '';
        var gc = document.getElementById('pct-graph-content');
        if (gc && gc.data) Plotly.purge(gc);
        state.data = [];
        state.sorted = [];
    }

    /* ===== Share URL ===== */

    function checkShareUrl() {
        var params = new URLSearchParams(window.location.search);
        var d = params.get('d');
        if (d) {
            try {
                var obj = JSON.parse(atob(d));
                if (obj.d) els.dataInput.value = obj.d;
                if (obj.m) setMode(obj.m);
                if (obj.t) els.targetInput.value = obj.t;
                updatePreview();
                calculate();
                return true;
            } catch(e) {}
        }
        return false;
    }

    /* ===== Init ===== */

    function init() {
        initDOM();
        initTabs();
        initModes();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);
        els.randomBtn.addEventListener('click', loadRandom);
        els.dataInput.addEventListener('input', updatePreview);

        // Example chips
        document.querySelectorAll('[data-example]').forEach(function(el) {
            el.addEventListener('click', function() { loadExample(this.getAttribute('data-example')); });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Init
        if (!checkShareUrl()) {
            setMode('rank');
            updatePreview();
            calculate();
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
