/**
 * Normal Distribution Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for normal distribution functions.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'prob',
        mu: 100,
        sigma: 15,
        result: null,
        pendingGraph: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('nd-result-content');
        els.resultActions  = document.getElementById('nd-result-actions');
        els.graphContent   = document.getElementById('nd-graph-content');
        els.compilerIframe = document.getElementById('nd-compiler-iframe');
        els.calcBtn        = document.getElementById('nd-calc-btn');
        els.clearBtn       = document.getElementById('nd-clear-btn');
        els.muInput        = document.getElementById('nd-mean');
        els.sigmaInput     = document.getElementById('nd-stddev');

        els.modeProb       = document.getElementById('nd-mode-prob');
        els.modePercentile = document.getElementById('nd-mode-percentile');
        els.modeRange      = document.getElementById('nd-mode-range');

        els.panelProb      = document.getElementById('nd-input-prob');
        els.panelPercentile= document.getElementById('nd-input-percentile');
        els.panelRange     = document.getElementById('nd-input-range');
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
                if (target === 'nd-graph-panel' && state.pendingGraph) { state.pendingGraph(); state.pendingGraph = null; }
                if (target === 'nd-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeProb.addEventListener('click', function() { setMode('prob'); });
        els.modePercentile.addEventListener('click', function() { setMode('percentile'); });
        els.modeRange.addEventListener('click', function() { setMode('range'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeProb.classList.toggle('active', m === 'prob');
        els.modePercentile.classList.toggle('active', m === 'percentile');
        els.modeRange.classList.toggle('active', m === 'range');
        els.panelProb.style.display = m === 'prob' ? '' : 'none';
        els.panelPercentile.style.display = m === 'percentile' ? '' : 'none';
        els.panelRange.style.display = m === 'range' ? '' : 'none';
    }

    /* ===== Calculate ===== */
    function calculate() {
        G.loadJStat(function() {
            try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
        });
    }

    function doCalculate() {
        var mu = parseFloat(els.muInput.value);
        var sigma = parseFloat(els.sigmaInput.value);
        if (isNaN(mu) || isNaN(sigma) || sigma <= 0) { C.showError(els.resultContent, 'Enter valid \u03BC and \u03C3 > 0.'); return; }
        state.mu = mu;
        state.sigma = sigma;
        var r = { mu: mu, sigma: sigma };

        if (state.mode === 'prob') {
            var x = parseFloat(document.getElementById('nd-x-value').value);
            var tail = document.getElementById('nd-prob-type').value;
            if (isNaN(x)) { C.showError(els.resultContent, 'Enter a valid X value.'); return; }
            r.x = x;
            r.z = (x - mu) / sigma;
            r.cdf = jStat.normal.cdf(x, mu, sigma);
            r.prob = tail === 'left' ? r.cdf : 1 - r.cdf;
            r.tail = tail;
            r.percentile = r.cdf * 100;
            renderProbResult(r);
        } else if (state.mode === 'percentile') {
            var pct = parseFloat(document.getElementById('nd-percentile').value);
            if (isNaN(pct) || pct <= 0 || pct >= 100) { C.showError(els.resultContent, 'Enter a percentile between 0 and 100.'); return; }
            r.percentile = pct;
            r.x = jStat.normal.inv(pct / 100, mu, sigma);
            r.z = (r.x - mu) / sigma;
            r.prob = pct / 100;
            r.tail = 'left';
            renderPercentileResult(r);
        } else {
            var a = parseFloat(document.getElementById('nd-range-a').value);
            var b = parseFloat(document.getElementById('nd-range-b').value);
            if (isNaN(a) || isNaN(b) || a >= b) { C.showError(els.resultContent, 'Enter a valid range (a < b).'); return; }
            r.a = a; r.b = b;
            r.zA = (a - mu) / sigma;
            r.zB = (b - mu) / sigma;
            var cdfA = jStat.normal.cdf(a, mu, sigma);
            var cdfB = jStat.normal.cdf(b, mu, sigma);
            r.prob = cdfB - cdfA;
            r.percentileA = cdfA * 100;
            r.percentileB = cdfB * 100;
            r.tail = 'range';
            renderRangeResult(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Normal Distribution',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\text{Normal Distribution } N(\\mu=' + C.fmt(s.mu, 4) + ',\\; \\sigma=' + C.fmt(s.sigma, 4) + ')');
                if (state.mode === 'prob') {
                    lines.push('X = ' + C.fmt(s.x, 4));
                    lines.push('Z = \\frac{X - \\mu}{\\sigma} = \\frac{' + C.fmt(s.x, 4) + ' - ' + C.fmt(s.mu, 4) + '}{' + C.fmt(s.sigma, 4) + '} = ' + C.fmt(s.z, 4));
                    lines.push('\\Phi(' + C.fmt(s.z, 4) + ') = ' + C.fmt(s.cdf, 6));
                    if (s.tail === 'left') {
                        lines.push('P(X \\leq ' + C.fmt(s.x, 2) + ') = ' + C.fmt(s.prob, 6));
                    } else {
                        lines.push('P(X \\geq ' + C.fmt(s.x, 2) + ') = ' + C.fmt(s.prob, 6));
                    }
                } else if (state.mode === 'percentile') {
                    lines.push('p = ' + C.fmt(s.percentile, 2) + '\\%');
                    lines.push('Z = \\Phi^{-1}(' + C.fmt(s.percentile / 100, 4) + ') = ' + C.fmt(s.z, 4));
                    lines.push('X = \\mu + Z \\cdot \\sigma = ' + C.fmt(s.x, 4));
                } else {
                    lines.push('a = ' + C.fmt(s.a, 2) + ',\\; b = ' + C.fmt(s.b, 2));
                    lines.push('Z_a = ' + C.fmt(s.zA, 4) + ',\\; Z_b = ' + C.fmt(s.zB, 4));
                    lines.push('P(' + C.fmt(s.a, 2) + ' \\leq X \\leq ' + C.fmt(s.b, 2) + ') = ' + C.fmt(s.prob, 6));
                }
                return lines.join(' \\\\\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var obj = { mode: state.mode, mu: s.mu, sigma: s.sigma };
                if (state.mode === 'prob') {
                    obj.x = s.x;
                    obj.tail = s.tail;
                } else if (state.mode === 'percentile') {
                    obj.percentile = s.percentile;
                } else {
                    obj.a = s.a;
                    obj.b = s.b;
                }
                return obj;
            },
            resultEl: '#nd-result-content'
        });

        prepareGraph(r);

        var compilerTab = document.querySelector('[data-tab="nd-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render: X → Probability ===== */
    function renderProbResult(r) {
        var probLabel = r.tail === 'left' ? 'P(X \u2264 ' + C.fmt(r.x, 2) + ')' : 'P(X \u2265 ' + C.fmt(r.x, 2) + ')';
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob, 6) + '</span><span class="stat-hero-label">' + probLabel + '</span></div>';
        h += buildSection('Probability Result', [
            ['X Value', C.fmt(r.x, 4)],
            ['Z-Score', C.fmt(r.z, 4)],
            ['Probability', C.fmt(r.prob, 6)],
            ['Percentile', C.fmt(r.percentile, 2) + '%'],
            ['Left Tail', C.fmt(r.cdf, 6)],
            ['Right Tail', C.fmt(1 - r.cdf, 6)]
        ]);
        h += buildSteps('prob', r);
        h += buildInterpretation(r);
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Percentile → X ===== */
    function renderPercentileResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">X = ' + C.fmt(r.x, 4) + '</span><span class="stat-hero-label">' + C.fmt(r.percentile, 2) + 'th Percentile</span></div>';
        h += buildSection('Inverse Normal Result', [
            ['Percentile', C.fmt(r.percentile, 2) + '%'],
            ['X Value', C.fmt(r.x, 4)],
            ['Z-Score', C.fmt(r.z, 4)],
            ['Mean (\u03BC)', C.fmt(r.mu, 4)],
            ['Std Dev (\u03C3)', C.fmt(r.sigma, 4)]
        ]);
        h += buildSteps('percentile', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> ' + C.fmt(r.percentile, 2) + '% of values from N(' + C.fmt(r.mu, 2) + ', ' + C.fmt(r.sigma, 2) + ') fall below ' + C.fmt(r.x, 4) + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Range P(a ≤ X ≤ b) ===== */
    function renderRangeResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob * 100, 2) + '%</span><span class="stat-hero-label">P(' + C.fmt(r.a, 2) + ' \u2264 X \u2264 ' + C.fmt(r.b, 2) + ')</span></div>';
        h += buildSection('Range Probability', [
            ['Range', '[' + C.fmt(r.a, 2) + ', ' + C.fmt(r.b, 2) + ']'],
            ['Probability', C.fmt(r.prob, 6)],
            ['Percentage', C.fmt(r.prob * 100, 2) + '%'],
            ['Z(a)', C.fmt(r.zA, 4)],
            ['Z(b)', C.fmt(r.zB, 4)],
            ['P(X \u2264 a)', C.fmt(r.percentileA, 2) + '%'],
            ['P(X \u2264 b)', C.fmt(r.percentileB, 2) + '%']
        ]);
        h += buildSteps('range', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> ' + C.fmt(r.prob * 100, 2) + '% of values from N(' + C.fmt(r.mu, 2) + ', ' + C.fmt(r.sigma, 2) + ') fall between ' + C.fmt(r.a, 2) + ' and ' + C.fmt(r.b, 2) + '.</div>';
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

    function buildSteps(mode, r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (mode === 'prob') {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="\\mu = ' + C.fmt(r.mu, 4) + ',\; \\sigma = ' + C.fmt(r.sigma, 4) + ',\; X = ' + C.fmt(r.x, 4) + '"></span>');
            h += step(2, 'Standardize', '<span class="stat-katex" data-tex="Z = \\frac{X - \\mu}{\\sigma} = \\frac{' + C.fmt(r.x, 4) + ' - ' + C.fmt(r.mu, 4) + '}{' + C.fmt(r.sigma, 4) + '} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(3, 'CDF lookup', '<span class="stat-katex" data-tex="\\Phi(' + C.fmt(r.z, 4) + ') = ' + C.fmt(r.cdf, 6) + '"></span>');
            if (r.tail === 'right') h += step(4, 'Right tail', '<span class="stat-katex" data-tex="P(X \\geq ' + C.fmt(r.x, 2) + ') = 1 - \\Phi(Z) = ' + C.fmt(r.prob, 6) + '"></span>');
            else h += step(4, 'Result', '<span class="stat-katex" data-tex="P(X \\leq ' + C.fmt(r.x, 2) + ') = ' + C.fmt(r.prob, 6) + '"></span>');
        } else if (mode === 'percentile') {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="\\mu = ' + C.fmt(r.mu, 4) + ',\; \\sigma = ' + C.fmt(r.sigma, 4) + ',\; p = ' + C.fmt(r.percentile, 2) + '\\%"></span>');
            h += step(2, 'Inverse standard normal', '<span class="stat-katex" data-tex="Z = \\Phi^{-1}(' + C.fmt(r.percentile / 100, 4) + ') = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(3, 'Convert to X', '<span class="stat-katex" data-tex="X = \\mu + Z \\cdot \\sigma = ' + C.fmt(r.mu, 4) + ' + ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.sigma, 4) + ' = ' + C.fmt(r.x, 4) + '"></span>');
        } else {
            h += step(1, 'Parameters', '<span class="stat-katex" data-tex="\\mu = ' + C.fmt(r.mu, 4) + ',\; \\sigma = ' + C.fmt(r.sigma, 4) + '"></span>');
            h += step(2, 'Standardize bounds', '<span class="stat-katex" data-tex="Z_a = ' + C.fmt(r.zA, 4) + ',\; Z_b = ' + C.fmt(r.zB, 4) + '"></span>');
            h += step(3, 'CDF at each bound', '<span class="stat-katex" data-tex="\\Phi(Z_b) - \\Phi(Z_a) = ' + C.fmt(r.percentileB / 100, 6) + ' - ' + C.fmt(r.percentileA / 100, 6) + '"></span>');
            h += step(4, 'Result', '<span class="stat-katex" data-tex="P(' + C.fmt(r.a, 2) + ' \\leq X \\leq ' + C.fmt(r.b, 2) + ') = ' + C.fmt(r.prob, 6) + '"></span>');
        }
        return h + '</div>';
    }

    function buildInterpretation(r) {
        var desc;
        var absZ = Math.abs(r.z);
        if (absZ < 1) desc = 'within 1\u03C3 of the mean (typical).';
        else if (absZ < 2) desc = 'between 1\u20132\u03C3 from the mean (somewhat unusual).';
        else if (absZ < 3) desc = 'between 2\u20133\u03C3 from the mean (unusual).';
        else desc = 'more than 3\u03C3 from the mean (extreme).';
        return '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> X = ' + C.fmt(r.x, 4) + ' is ' + C.fmt(absZ, 2) + ' standard deviations ' + (r.z >= 0 ? 'above' : 'below') + ' the mean, ' + desc + '</div>';
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
    function prepareGraph(r) {
        state.pendingGraph = function() {
            G.loadPlotly(function() { renderCurve(r); });
        };
        var graphTab = document.querySelector('[data-tab="nd-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) {
            state.pendingGraph();
            state.pendingGraph = null;
        }
    }

    function renderCurve(r) {
        var gc = document.getElementById('nd-graph-content');
        if (gc) gc.innerHTML = '';
        var mu = r.mu, sigma = r.sigma;
        var colors = G.getPlotColors();

        var xVals = [], yVals = [];
        for (var t = mu - 4 * sigma; t <= mu + 4 * sigma; t += sigma / 20) {
            xVals.push(t);
            yVals.push(jStat.normal.pdf(t, mu, sigma));
        }

        var xFill = [], yFill = [];
        for (var i = 0; i < xVals.length; i++) {
            var keep = false;
            if (r.tail === 'left') keep = xVals[i] <= (r.x != null ? r.x : 0);
            else if (r.tail === 'right') keep = xVals[i] >= (r.x != null ? r.x : 0);
            else if (r.tail === 'range') keep = xVals[i] >= r.a && xVals[i] <= r.b;
            if (keep) { xFill.push(xVals[i]); yFill.push(yVals[i]); }
        }

        var traces = [
            { x: xVals, y: yVals, type: 'scatter', mode: 'lines', name: 'N(\u03BC=' + C.fmt(mu, 1) + ', \u03C3=' + C.fmt(sigma, 1) + ')', line: { color: '#e11d48', width: 2.5 } },
            { x: xFill, y: yFill, type: 'scatter', mode: 'lines', fill: 'tozeroy', name: 'Shaded Area', fillcolor: 'rgba(225,29,72,0.2)', line: { color: 'rgba(225,29,72,0.4)', width: 0 } }
        ];

        // Add marker lines
        if (r.tail === 'range') {
            traces.push({ x: [r.a, r.a], y: [0, jStat.normal.pdf(r.a, mu, sigma)], type: 'scatter', mode: 'lines', name: 'a = ' + C.fmt(r.a, 2), line: { color: '#3b82f6', width: 2, dash: 'dash' } });
            traces.push({ x: [r.b, r.b], y: [0, jStat.normal.pdf(r.b, mu, sigma)], type: 'scatter', mode: 'lines', name: 'b = ' + C.fmt(r.b, 2), line: { color: '#10b981', width: 2, dash: 'dash' } });
        } else if (r.x != null) {
            traces.push({ x: [r.x, r.x], y: [0, jStat.normal.pdf(r.x, mu, sigma)], type: 'scatter', mode: 'lines', name: 'X = ' + C.fmt(r.x, 2), line: { color: '#3b82f6', width: 2, dash: 'dash' } });
        }
        // Mean line
        traces.push({ x: [mu, mu], y: [0, jStat.normal.pdf(mu, mu, sigma)], type: 'scatter', mode: 'lines', name: '\u03BC = ' + C.fmt(mu, 2), line: { color: 'rgba(100,100,100,0.4)', width: 1.5, dash: 'dot' }, showlegend: false });

        var layout = {
            paper_bgcolor: 'rgba(0,0,0,0)', plot_bgcolor: 'rgba(0,0,0,0)',
            font: { color: colors.text, family: 'Inter, sans-serif', size: 12 },
            margin: { l: 50, r: 20, t: 30, b: 40 },
            xaxis: { title: 'X', gridcolor: colors.grid, zeroline: false },
            yaxis: { title: 'Density', gridcolor: colors.grid, zeroline: false },
            showlegend: true, legend: { orientation: 'h', y: -0.2 }
        };

        Plotly.newPlot('nd-graph-content', traces, layout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [
            'from scipy import stats',
            'import numpy as np',
            '',
            '# Normal Distribution N(\u03BC=' + r.mu + ', \u03C3=' + r.sigma + ')',
            'mu = ' + r.mu,
            'sigma = ' + r.sigma,
            'dist = stats.norm(mu, sigma)',
            ''
        ];

        if (state.mode === 'prob') {
            lines.push('# X to Probability');
            lines.push('x = ' + r.x);
            lines.push('z = (x - mu) / sigma');
            lines.push('cdf = dist.cdf(x)');
            lines.push('');
            lines.push('print(f"X = {x}")');
            lines.push('print(f"Z-score = {z:.4f}")');
            lines.push('print(f"P(X <= {x}) = {cdf:.6f}")');
            lines.push('print(f"P(X >= {x}) = {1-cdf:.6f}")');
            lines.push('print(f"Percentile = {cdf*100:.2f}%")');
        } else if (state.mode === 'percentile') {
            lines.push('# Percentile to X');
            lines.push('percentile = ' + r.percentile);
            lines.push('x = dist.ppf(percentile / 100)');
            lines.push('z = (x - mu) / sigma');
            lines.push('');
            lines.push('print(f"Percentile = {percentile}%")');
            lines.push('print(f"X = {x:.4f}")');
            lines.push('print(f"Z-score = {z:.4f}")');
        } else {
            lines.push('# Range Probability');
            lines.push('a = ' + r.a);
            lines.push('b = ' + r.b);
            lines.push('prob = dist.cdf(b) - dist.cdf(a)');
            lines.push('');
            lines.push('print(f"P({a} <= X <= {b}) = {prob:.6f}")');
            lines.push('print(f"Percentage = {prob*100:.2f}%")');
            lines.push('print(f"Z(a) = {(a-mu)/sigma:.4f}")');
            lines.push('print(f"Z(b) = {(b-mu)/sigma:.4f}")');
        }

        lines.push('');
        lines.push('# Key percentiles');
        lines.push('for p in [1, 5, 10, 25, 50, 75, 90, 95, 99]:');
        lines.push('    print(f"  P{p:2d}: {dist.ppf(p/100):.4f}")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\u{1F4CA}', 'No Result Yet', 'Enter parameters and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        var gc = document.getElementById('nd-graph-content');
        if (gc && typeof Plotly !== 'undefined' && gc.data) Plotly.purge(gc);
        state.result = null;
    }

    /* ===== Share URL Restore ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mu || !shared.sigma) return;
        els.muInput.value = shared.mu;
        els.sigmaInput.value = shared.sigma;
        if (shared.mode) setMode(shared.mode);
        if (shared.mode === 'prob' && shared.x != null) {
            document.getElementById('nd-x-value').value = shared.x;
            if (shared.tail) document.getElementById('nd-prob-type').value = shared.tail;
        } else if (shared.mode === 'percentile' && shared.percentile != null) {
            document.getElementById('nd-percentile').value = shared.percentile;
        } else if (shared.mode === 'range' && shared.a != null && shared.b != null) {
            document.getElementById('nd-range-a').value = shared.a;
            document.getElementById('nd-range-b').value = shared.b;
        }
        calculate();
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.nd-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-nd-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                var ex = this.getAttribute('data-nd-example');
                if (ex === 'iq') { els.muInput.value = '100'; els.sigmaInput.value = '15'; setMode('prob'); document.getElementById('nd-x-value').value = '130'; document.getElementById('nd-prob-type').value = 'left'; }
                else if (ex === 'sat') { els.muInput.value = '1060'; els.sigmaInput.value = '195'; setMode('prob'); document.getElementById('nd-x-value').value = '1200'; document.getElementById('nd-prob-type').value = 'left'; }
                else if (ex === 'height') { els.muInput.value = '170'; els.sigmaInput.value = '7'; setMode('range'); document.getElementById('nd-range-a').value = '165'; document.getElementById('nd-range-b').value = '180'; }
                else if (ex === 'top10') { els.muInput.value = '100'; els.sigmaInput.value = '15'; setMode('percentile'); document.getElementById('nd-percentile').value = '90'; }
                calculate();
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        var shared = E.parseShareUrl();
        if (shared && shared.mu && shared.sigma) {
            restoreFromUrl();
        } else {
            setMode('prob');
            calculate();
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
