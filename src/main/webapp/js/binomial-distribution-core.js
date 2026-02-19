/**
 * Binomial Distribution Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Pure JS computation — no jStat needed for binomial.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'exact',
        n: 10,
        p: 0.5,
        result: null,
        pendingGraph: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('bd-result-content');
        els.resultActions  = document.getElementById('bd-result-actions');
        els.graphContent   = document.getElementById('bd-graph-content');
        els.compilerIframe = document.getElementById('bd-compiler-iframe');
        els.calcBtn        = document.getElementById('bd-calc-btn');
        els.clearBtn       = document.getElementById('bd-clear-btn');
        els.nInput         = document.getElementById('bd-n');
        els.pInput         = document.getElementById('bd-p');

        els.modeExact      = document.getElementById('bd-mode-exact');
        els.modeCumulative = document.getElementById('bd-mode-cumulative');
        els.modeRange      = document.getElementById('bd-mode-range');

        els.panelExact     = document.getElementById('bd-input-exact');
        els.panelCumulative= document.getElementById('bd-input-cumulative');
        els.panelRange     = document.getElementById('bd-input-range');
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
                if (target === 'bd-graph-panel' && state.pendingGraph) { state.pendingGraph(); state.pendingGraph = null; }
                if (target === 'bd-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeExact.addEventListener('click', function() { setMode('exact'); });
        els.modeCumulative.addEventListener('click', function() { setMode('cumulative'); });
        els.modeRange.addEventListener('click', function() { setMode('range'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeExact.classList.toggle('active', m === 'exact');
        els.modeCumulative.classList.toggle('active', m === 'cumulative');
        els.modeRange.classList.toggle('active', m === 'range');
        els.panelExact.style.display = m === 'exact' ? '' : 'none';
        els.panelCumulative.style.display = m === 'cumulative' ? '' : 'none';
        els.panelRange.style.display = m === 'range' ? '' : 'none';
    }

    /* ===== Binomial Math (pure JS) ===== */
    function binomialCoeff(n, k) {
        if (k < 0 || k > n) return 0;
        if (k === 0 || k === n) return 1;
        if (k > n - k) k = n - k;
        var c = 1;
        for (var i = 0; i < k; i++) {
            c = c * (n - i) / (i + 1);
        }
        return c;
    }

    function binomialPMF(n, p, k) {
        if (k < 0 || k > n) return 0;
        return binomialCoeff(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
    }

    function binomialCDF(n, p, k) {
        var sum = 0;
        for (var i = 0; i <= Math.min(k, n); i++) {
            sum += binomialPMF(n, p, i);
        }
        return sum;
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var n = parseInt(els.nInput.value, 10);
        var p = parseFloat(els.pInput.value);
        if (isNaN(n) || n < 0 || !Number.isInteger(n)) { C.showError(els.resultContent, 'Enter a valid number of trials (n \u2265 0).'); return; }
        if (isNaN(p) || p < 0 || p > 1) { C.showError(els.resultContent, 'Enter a valid probability (0 \u2264 p \u2264 1).'); return; }
        state.n = n;
        state.p = p;

        var mean = n * p;
        var variance = n * p * (1 - p);
        var sd = Math.sqrt(variance);
        var skewness = variance > 0 ? (1 - 2 * p) / Math.sqrt(variance) : 0;
        var r = { n: n, p: p, mean: mean, variance: variance, sd: sd, skewness: skewness };

        if (state.mode === 'exact') {
            var k = parseInt(document.getElementById('bd-k-exact').value, 10);
            if (isNaN(k) || k < 0 || k > n) { C.showError(els.resultContent, 'Enter a valid k (0 \u2264 k \u2264 n).'); return; }
            r.k = k;
            r.prob = binomialPMF(n, p, k);
            r.cdf = binomialCDF(n, p, k);
            r.complement = 1 - r.cdf;
            renderExactResult(r);
        } else if (state.mode === 'cumulative') {
            var k = parseInt(document.getElementById('bd-k-cumulative').value, 10);
            if (isNaN(k) || k < 0 || k > n) { C.showError(els.resultContent, 'Enter a valid k (0 \u2264 k \u2264 n).'); return; }
            r.k = k;
            r.cdf = binomialCDF(n, p, k);
            r.complement = 1 - r.cdf;
            renderCumulativeResult(r);
        } else {
            var a = parseInt(document.getElementById('bd-range-a').value, 10);
            var b = parseInt(document.getElementById('bd-range-b').value, 10);
            if (isNaN(a) || isNaN(b) || a < 0 || b > n || a > b) { C.showError(els.resultContent, 'Enter a valid range (0 \u2264 a \u2264 b \u2264 n).'); return; }
            r.a = a;
            r.b = b;
            var cdfB = binomialCDF(n, p, b);
            var cdfAm1 = a > 0 ? binomialCDF(n, p, a - 1) : 0;
            r.prob = cdfB - cdfAm1;
            r.pBelow = cdfAm1;
            r.pAbove = 1 - cdfB;
            renderRangeResult(r);
        }

        state.result = r;
        prepareGraph(r);

        var compilerTab = document.querySelector('[data-tab="bd-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render: Exact P(X = k) ===== */
    function renderExactResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob, 6) + '</span><span class="stat-hero-label">P(X = ' + r.k + ')</span></div>';
        h += buildSection('Exact Probability', [
            ['Trials (n)', r.n],
            ['Probability (p)', C.fmt(r.p, 4)],
            ['k', r.k],
            ['P(X = ' + r.k + ')', C.fmt(r.prob, 6)],
            ['P(X \u2264 ' + r.k + ')', C.fmt(r.cdf, 6)],
            ['P(X > ' + r.k + ')', C.fmt(r.complement, 6)],
            ['Mean', C.fmt(r.mean, 4)],
            ['Std Dev', C.fmt(r.sd, 4)]
        ]);
        h += buildSteps('exact', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The probability of exactly ' + r.k + ' successes in ' + r.n + ' trials (p=' + C.fmt(r.p, 2) + ') is ' + C.fmt(r.prob * 100, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
        showActionButtons(r);
    }

    /* ===== Render: Cumulative P(X ≤ k) ===== */
    function renderCumulativeResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.cdf, 6) + '</span><span class="stat-hero-label">P(X \u2264 ' + r.k + ')</span></div>';
        h += buildSection('Cumulative Probability', [
            ['Trials (n)', r.n],
            ['Probability (p)', C.fmt(r.p, 4)],
            ['k', r.k],
            ['P(X \u2264 ' + r.k + ')', C.fmt(r.cdf, 6)],
            ['P(X > ' + r.k + ')', C.fmt(r.complement, 6)],
            ['Mean', C.fmt(r.mean, 4)],
            ['Std Dev', C.fmt(r.sd, 4)]
        ]);
        h += buildSteps('cumulative', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The probability of at most ' + r.k + ' successes in ' + r.n + ' trials (p=' + C.fmt(r.p, 2) + ') is ' + C.fmt(r.cdf * 100, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
        showActionButtons(r);
    }

    /* ===== Render: Range P(a ≤ X ≤ b) ===== */
    function renderRangeResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob * 100, 2) + '%</span><span class="stat-hero-label">P(' + r.a + ' \u2264 X \u2264 ' + r.b + ')</span></div>';
        h += buildSection('Range Probability', [
            ['Range', '[' + r.a + ', ' + r.b + ']'],
            ['P(' + r.a + ' \u2264 X \u2264 ' + r.b + ')', C.fmt(r.prob, 6)],
            ['P(X < ' + r.a + ')', C.fmt(r.pBelow, 6)],
            ['P(X > ' + r.b + ')', C.fmt(r.pAbove, 6)],
            ['Mean', C.fmt(r.mean, 4)],
            ['Std Dev', C.fmt(r.sd, 4)]
        ]);
        h += buildSteps('range', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The probability of between ' + r.a + ' and ' + r.b + ' successes in ' + r.n + ' trials (p=' + C.fmt(r.p, 2) + ') is ' + C.fmt(r.prob * 100, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
        showActionButtons(r);
    }

    /* ===== Action Buttons (Share / Copy LaTeX / Download) ===== */
    function showActionButtons(r) {
        E.renderActionButtons(els.resultActions, {
            toolName: 'Binomial Distribution',
            getLatex: function() {
                var lines = [];
                lines.push('\\text{Binomial Distribution } B(n=' + r.n + ',\\; p=' + C.fmt(r.p, 4) + ')');
                lines.push('\\mu = ' + C.fmt(r.mean, 4) + ',\\quad \\sigma = ' + C.fmt(r.sd, 4));
                if (state.mode === 'exact') {
                    lines.push('P(X = ' + r.k + ') = \\binom{' + r.n + '}{' + r.k + '} \\cdot ' + C.fmt(r.p, 4) + '^{' + r.k + '} \\cdot ' + C.fmt(1 - r.p, 4) + '^{' + (r.n - r.k) + '} = ' + C.fmt(r.prob, 6));
                    lines.push('P(X \\leq ' + r.k + ') = ' + C.fmt(r.cdf, 6));
                    lines.push('P(X > ' + r.k + ') = ' + C.fmt(r.complement, 6));
                } else if (state.mode === 'cumulative') {
                    lines.push('P(X \\leq ' + r.k + ') = \\sum_{i=0}^{' + r.k + '} \\binom{' + r.n + '}{i} p^{i}(1-p)^{n-i} = ' + C.fmt(r.cdf, 6));
                    lines.push('P(X > ' + r.k + ') = ' + C.fmt(r.complement, 6));
                } else {
                    lines.push('P(' + r.a + ' \\leq X \\leq ' + r.b + ') = ' + C.fmt(r.prob, 6));
                    lines.push('P(X < ' + r.a + ') = ' + C.fmt(r.pBelow, 6));
                    lines.push('P(X > ' + r.b + ') = ' + C.fmt(r.pAbove, 6));
                }
                return lines.join(' \\\\\n');
            },
            getShareState: function() {
                var s = { mode: state.mode, n: r.n, p: r.p };
                if (state.mode === 'exact' || state.mode === 'cumulative') { s.k = r.k; }
                else { s.a = r.a; s.b = r.b; }
                return s;
            },
            resultEl: '#bd-result-content'
        });
    }

    /* ===== Helpers ===== */
    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function buildSteps(mode, r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (mode === 'exact') {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="n = ' + r.n + ',\\; p = ' + C.fmt(r.p, 4) + ',\\; k = ' + r.k + '"></span>');
            h += step(2, 'Binomial Coefficient', '<span class="stat-katex" data-tex="\\binom{' + r.n + '}{' + r.k + '} = ' + C.fmt(binomialCoeff(r.n, r.k), 0) + '"></span>');
            h += step(3, 'PMF Formula', '<span class="stat-katex" data-tex="P(X=' + r.k + ') = \\binom{' + r.n + '}{' + r.k + '} \\cdot ' + C.fmt(r.p, 4) + '^{' + r.k + '} \\cdot ' + C.fmt(1 - r.p, 4) + '^{' + (r.n - r.k) + '}"></span>');
            h += step(4, 'Result', '<span class="stat-katex" data-tex="P(X = ' + r.k + ') = ' + C.fmt(r.prob, 6) + '"></span>');
        } else if (mode === 'cumulative') {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="n = ' + r.n + ',\\; p = ' + C.fmt(r.p, 4) + ',\\; k = ' + r.k + '"></span>');
            h += step(2, 'Sum Formula', '<span class="stat-katex" data-tex="P(X \\leq ' + r.k + ') = \\sum_{i=0}^{' + r.k + '} \\binom{' + r.n + '}{i} \\cdot ' + C.fmt(r.p, 4) + '^{i} \\cdot ' + C.fmt(1 - r.p, 4) + '^{' + r.n + '-i}"></span>');
            h += step(3, 'Result', '<span class="stat-katex" data-tex="P(X \\leq ' + r.k + ') = ' + C.fmt(r.cdf, 6) + '"></span>');
        } else {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="n = ' + r.n + ',\\; p = ' + C.fmt(r.p, 4) + ',\\; a = ' + r.a + ',\\; b = ' + r.b + '"></span>');
            h += step(2, 'Sum Formula', '<span class="stat-katex" data-tex="P(' + r.a + ' \\leq X \\leq ' + r.b + ') = \\sum_{i=' + r.a + '}^{' + r.b + '} \\binom{' + r.n + '}{i} \\cdot ' + C.fmt(r.p, 4) + '^{i} \\cdot ' + C.fmt(1 - r.p, 4) + '^{' + r.n + '-i}"></span>');
            h += step(3, 'Result', '<span class="stat-katex" data-tex="P(' + r.a + ' \\leq X \\leq ' + r.b + ') = ' + C.fmt(r.prob, 6) + '"></span>');
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

    /* ===== Graph (Plotly bar chart) ===== */
    function prepareGraph(r) {
        state.pendingGraph = function() {
            G.loadPlotly(function() { renderPMF(r); });
        };
        var graphTab = document.querySelector('[data-tab="bd-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) {
            state.pendingGraph();
            state.pendingGraph = null;
        }
    }

    function renderPMF(r) {
        var gc = document.getElementById('bd-graph-content');
        if (gc) gc.innerHTML = '';
        var colors = G.getPlotColors();

        var xVals = [], yVals = [], barColors = [];
        var highlightColor = 'rgba(225,29,72,0.8)';
        var defaultColor = 'rgba(156,163,175,0.5)';

        for (var i = 0; i <= r.n; i++) {
            xVals.push(i);
            yVals.push(binomialPMF(r.n, r.p, i));
            var highlight = false;
            if (state.mode === 'exact') highlight = (i === r.k);
            else if (state.mode === 'cumulative') highlight = (i <= r.k);
            else highlight = (i >= r.a && i <= r.b);
            barColors.push(highlight ? highlightColor : defaultColor);
        }

        var traces = [
            {
                x: xVals,
                y: yVals,
                type: 'bar',
                marker: { color: barColors },
                name: 'P(X = k)',
                hovertemplate: 'k=%{x}<br>P(X=%{x})=%{y:.6f}<extra></extra>'
            },
            {
                x: [r.mean, r.mean],
                y: [0, Math.max.apply(null, yVals) * 1.05],
                type: 'scatter',
                mode: 'lines',
                name: '\u03BC = ' + C.fmt(r.mean, 2),
                line: { color: 'rgba(100,100,100,0.6)', width: 2, dash: 'dash' }
            }
        ];

        var layout = {
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            font: { color: colors.text, family: 'Inter, sans-serif', size: 12 },
            margin: { l: 50, r: 20, t: 30, b: 40 },
            xaxis: { title: 'k', gridcolor: colors.grid, zeroline: false, dtick: r.n <= 20 ? 1 : undefined },
            yaxis: { title: 'P(X = k)', gridcolor: colors.grid, zeroline: false },
            showlegend: true,
            legend: { orientation: 'h', y: -0.2 },
            bargap: 0.1
        };

        Plotly.newPlot('bd-graph-content', traces, layout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [
            'from scipy import stats',
            'import numpy as np',
            '',
            '# Binomial Distribution B(n=' + r.n + ', p=' + r.p + ')',
            'n = ' + r.n,
            'p = ' + r.p,
            'dist = stats.binom(n, p)',
            ''
        ];

        if (state.mode === 'exact') {
            lines.push('# Exact probability P(X = k)');
            lines.push('k = ' + r.k);
            lines.push('pmf = dist.pmf(k)');
            lines.push('cdf = dist.cdf(k)');
            lines.push('');
            lines.push('print(f"P(X = {k}) = {pmf:.6f}")');
            lines.push('print(f"P(X <= {k}) = {cdf:.6f}")');
            lines.push('print(f"P(X > {k}) = {1-cdf:.6f}")');
        } else if (state.mode === 'cumulative') {
            lines.push('# Cumulative probability P(X <= k)');
            lines.push('k = ' + r.k);
            lines.push('cdf = dist.cdf(k)');
            lines.push('');
            lines.push('print(f"P(X <= {k}) = {cdf:.6f}")');
            lines.push('print(f"P(X > {k}) = {1-cdf:.6f}")');
        } else {
            lines.push('# Range probability P(a <= X <= b)');
            lines.push('a = ' + r.a);
            lines.push('b = ' + r.b);
            lines.push('prob = dist.cdf(b) - dist.cdf(a - 1)');
            lines.push('');
            lines.push('print(f"P({a} <= X <= {b}) = {prob:.6f}")');
            lines.push('print(f"P(X < {a}) = {dist.cdf(a-1):.6f}")');
            lines.push('print(f"P(X > {b}) = {1-dist.cdf(b):.6f}")');
        }

        lines.push('');
        lines.push('# Summary statistics');
        lines.push('print(f"\\nMean = {dist.mean():.4f}")');
        lines.push('print(f"Variance = {dist.var():.4f}")');
        lines.push('print(f"Std Dev = {dist.std():.4f}")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83D\uDCCA', 'No Result Yet', 'Enter parameters and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        var gc = document.getElementById('bd-graph-content');
        if (gc && typeof Plotly !== 'undefined' && gc.data) Plotly.purge(gc);
        state.result = null;
        state.pendingGraph = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'coin') {
            els.nInput.value = '10';
            els.pInput.value = '0.5';
            setMode('exact');
            document.getElementById('bd-k-exact').value = '6';
        } else if (ex === 'defect') {
            els.nInput.value = '100';
            els.pInput.value = '0.05';
            setMode('cumulative');
            document.getElementById('bd-k-cumulative').value = '3';
        } else if (ex === 'survey') {
            els.nInput.value = '50';
            els.pInput.value = '0.3';
            setMode('range');
            document.getElementById('bd-range-a').value = '10';
            document.getElementById('bd-range-b').value = '20';
        } else if (ex === 'medical') {
            els.nInput.value = '20';
            els.pInput.value = '0.7';
            setMode('exact');
            document.getElementById('bd-k-exact').value = '15';
        }
        calculate();
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared) return false;
        if (shared.n !== undefined) els.nInput.value = shared.n;
        if (shared.p !== undefined) els.pInput.value = shared.p;
        if (shared.mode) setMode(shared.mode);
        if (shared.mode === 'exact' && shared.k !== undefined) {
            document.getElementById('bd-k-exact').value = shared.k;
        } else if (shared.mode === 'cumulative' && shared.k !== undefined) {
            document.getElementById('bd-k-cumulative').value = shared.k;
        } else if (shared.mode === 'range') {
            if (shared.a !== undefined) document.getElementById('bd-range-a').value = shared.a;
            if (shared.b !== undefined) document.getElementById('bd-range-b').value = shared.b;
        }
        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.bd-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-bd-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-bd-example'));
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Restore from shared URL or use defaults
        if (!restoreFromUrl()) {
            setMode('exact');
        }
        calculate();
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
