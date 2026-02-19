/**
 * Z-Score Calculator — Orchestration IIFE
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
        mode: 'score', // 'score' | 'prob' | 'percentile' | 'reverse'
        result: null,
        pendingGraph: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('zs-result-content');
        els.resultActions  = document.getElementById('zs-result-actions');
        els.graphContent   = document.getElementById('zs-graph-content');
        els.compilerIframe = document.getElementById('zs-compiler-iframe');
        els.calcBtn        = document.getElementById('zs-calc-btn');
        els.clearBtn       = document.getElementById('zs-clear-btn');

        // Mode buttons
        els.modeScore      = document.getElementById('zs-mode-score');
        els.modeProb       = document.getElementById('zs-mode-prob');
        els.modePercentile = document.getElementById('zs-mode-percentile');
        els.modeReverse    = document.getElementById('zs-mode-reverse');

        // Input panels
        els.panelScore     = document.getElementById('zs-input-score');
        els.panelProb      = document.getElementById('zs-input-prob');
        els.panelPercentile= document.getElementById('zs-input-percentile');
        els.panelReverse   = document.getElementById('zs-input-reverse');
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
                if (target === 'zs-graph-panel' && state.pendingGraph) { state.pendingGraph(); state.pendingGraph = null; }
                if (target === 'zs-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */

    function initModes() {
        els.modeScore.addEventListener('click', function() { setMode('score'); });
        els.modeProb.addEventListener('click', function() { setMode('prob'); });
        els.modePercentile.addEventListener('click', function() { setMode('percentile'); });
        els.modeReverse.addEventListener('click', function() { setMode('reverse'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeScore.classList.toggle('active', m === 'score');
        els.modeProb.classList.toggle('active', m === 'prob');
        els.modePercentile.classList.toggle('active', m === 'percentile');
        els.modeReverse.classList.toggle('active', m === 'reverse');

        els.panelScore.style.display = m === 'score' ? '' : 'none';
        els.panelProb.style.display = m === 'prob' ? '' : 'none';
        els.panelPercentile.style.display = m === 'percentile' ? '' : 'none';
        els.panelReverse.style.display = m === 'reverse' ? '' : 'none';
    }

    /* ===== Normal distribution helpers (require jStat) ===== */

    function normalCDF(z) { return jStat.normal.cdf(z, 0, 1); }
    function normalPDF(z) { return jStat.normal.pdf(z, 0, 1); }
    function normalInv(p) { return jStat.normal.inv(p, 0, 1); }

    /* ===== Calculate ===== */

    function calculate() {
        G.loadJStat(function() {
            try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
        });
    }

    function doCalculate() {
        var r = {};
        var m = state.mode;

        if (m === 'score') {
            var x = parseFloat(document.getElementById('zs-raw-score').value);
            var mu = parseFloat(document.getElementById('zs-mean').value);
            var sigma = parseFloat(document.getElementById('zs-stddev').value);
            if (isNaN(x) || isNaN(mu) || isNaN(sigma) || sigma <= 0) { C.showError(els.resultContent, 'Enter valid values (\u03C3 > 0).'); return; }
            r.z = (x - mu) / sigma;
            r.percentile = normalCDF(r.z) * 100;
            r.leftTail = normalCDF(r.z);
            r.rightTail = 1 - r.leftTail;
            r.x = x; r.mu = mu; r.sigma = sigma;
            r.areaType = 'left';
            renderScoreResult(r);
        } else if (m === 'prob') {
            var z = parseFloat(document.getElementById('zs-z-prob').value);
            var areaType = document.getElementById('zs-area-type').value;
            if (isNaN(z)) { C.showError(els.resultContent, 'Enter a valid Z-score.'); return; }
            var prob;
            if (areaType === 'left') prob = normalCDF(z);
            else if (areaType === 'right') prob = 1 - normalCDF(z);
            else if (areaType === 'between') prob = normalCDF(Math.abs(z)) - normalCDF(-Math.abs(z));
            else prob = 1 - (normalCDF(Math.abs(z)) - normalCDF(-Math.abs(z)));
            r.z = z; r.prob = prob; r.areaType = areaType;
            renderProbResult(r);
        } else if (m === 'percentile') {
            var pct = parseFloat(document.getElementById('zs-percentile').value);
            if (isNaN(pct) || pct <= 0 || pct >= 100) { C.showError(els.resultContent, 'Enter a percentile between 0 and 100.'); return; }
            r.percentile = pct;
            r.z = normalInv(pct / 100);
            r.prob = pct / 100;
            r.areaType = 'left';
            renderPercentileResult(r);
        } else {
            var z2 = parseFloat(document.getElementById('zs-z-reverse').value);
            var mu2 = parseFloat(document.getElementById('zs-mean-reverse').value);
            var sigma2 = parseFloat(document.getElementById('zs-stddev-reverse').value);
            if (isNaN(z2) || isNaN(mu2) || isNaN(sigma2) || sigma2 <= 0) { C.showError(els.resultContent, 'Enter valid values (\u03C3 > 0).'); return; }
            r.z = z2; r.mu = mu2; r.sigma = sigma2;
            r.x = mu2 + z2 * sigma2;
            r.percentile = normalCDF(z2) * 100;
            r.areaType = 'left';
            renderReverseResult(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Z-Score Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Z-Score Calculator}\\\\[4pt]');
                if (state.mode === 'score') {
                    lines.push('x = ' + C.fmt(s.x, 4) + '\\\\');
                    lines.push('\\mu = ' + C.fmt(s.mu, 4) + '\\\\');
                    lines.push('\\sigma = ' + C.fmt(s.sigma, 4) + '\\\\');
                    lines.push('Z = \\frac{x - \\mu}{\\sigma} = \\frac{' + C.fmt(s.x, 4) + ' - ' + C.fmt(s.mu, 4) + '}{' + C.fmt(s.sigma, 4) + '} = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('P(Z \\leq ' + C.fmt(s.z, 4) + ') = ' + C.fmt(s.leftTail, 6) + '\\\\');
                    lines.push('\\text{Percentile} = ' + C.fmt(s.percentile, 2) + '\\%');
                } else if (state.mode === 'prob') {
                    lines.push('Z = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\text{Area Type: ' + s.areaType + '}\\\\');
                    lines.push('P = ' + C.fmt(s.prob, 6));
                } else if (state.mode === 'percentile') {
                    lines.push('\\text{Percentile} = ' + C.fmt(s.percentile, 2) + '\\%\\\\');
                    lines.push('Z = \\Phi^{-1}(' + C.fmt(s.prob, 4) + ') = ' + C.fmt(s.z, 4));
                } else {
                    lines.push('Z = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\mu = ' + C.fmt(s.mu, 4) + '\\\\');
                    lines.push('\\sigma = ' + C.fmt(s.sigma, 4) + '\\\\');
                    lines.push('x = \\mu + Z \\times \\sigma = ' + C.fmt(s.x, 4) + '\\\\');
                    lines.push('\\text{Percentile} = ' + C.fmt(s.percentile, 2) + '\\%');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: state.mode };
                if (state.mode === 'score') {
                    shared.x = s.x; shared.mu = s.mu; shared.sigma = s.sigma;
                } else if (state.mode === 'prob') {
                    shared.z = s.z; shared.areaType = s.areaType;
                } else if (state.mode === 'percentile') {
                    shared.percentile = s.percentile;
                } else {
                    shared.z = s.z; shared.mu = s.mu; shared.sigma = s.sigma;
                }
                return shared;
            },
            resultEl: '#zs-result-content'
        });

        prepareGraph(r);

        // Reload compiler if tab active
        var compilerTab = document.querySelector('[data-tab="zs-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) {
            loadCompiler();
        } else {
            els.compilerIframe.removeAttribute('src');
        }
    }

    /* ===== Render: Score → Z ===== */

    function renderScoreResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">Z = ' + C.fmt(r.z, 4) + '</span><span class="stat-hero-label">' + C.fmt(r.percentile, 2) + 'th Percentile</span></div>';

        h += buildSection('Z-Score Result', [
            ['Z-Score', C.fmt(r.z, 4)],
            ['Percentile', C.fmt(r.percentile, 2) + '%'],
            ['Left Tail P(Z \u2264 z)', C.fmt(r.leftTail, 6)],
            ['Right Tail P(Z \u2265 z)', C.fmt(r.rightTail, 6)]
        ]);

        h += buildSteps('score', r);
        h += buildInterpretation(r.z, r.percentile);
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Z → Probability ===== */

    function renderProbResult(r) {
        var probLabel = '';
        if (r.areaType === 'left') probLabel = 'P(Z \u2264 ' + C.fmt(r.z, 2) + ')';
        else if (r.areaType === 'right') probLabel = 'P(Z \u2265 ' + C.fmt(r.z, 2) + ')';
        else if (r.areaType === 'between') probLabel = 'P(\u2212' + C.fmt(Math.abs(r.z), 2) + ' \u2264 Z \u2264 ' + C.fmt(Math.abs(r.z), 2) + ')';
        else probLabel = 'P(Z \u2264 \u2212' + C.fmt(Math.abs(r.z), 2) + ' or Z \u2265 ' + C.fmt(Math.abs(r.z), 2) + ')';

        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob, 6) + '</span><span class="stat-hero-label">' + probLabel + '</span></div>';

        h += buildSection('Probability Result', [
            ['Probability', C.fmt(r.prob, 6)],
            ['Percentage', C.fmt(r.prob * 100, 2) + '%'],
            ['Area Type', r.areaType.charAt(0).toUpperCase() + r.areaType.slice(1)]
        ]);

        h += buildSteps('prob', r);
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Percentile → Z ===== */

    function renderPercentileResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">Z = ' + C.fmt(r.z, 4) + '</span><span class="stat-hero-label">' + C.fmt(r.percentile, 2) + 'th Percentile</span></div>';

        h += buildSection('Inverse Normal Result', [
            ['Percentile', C.fmt(r.percentile, 2) + '%'],
            ['Z-Score', C.fmt(r.z, 4)],
            ['Cumulative Probability', C.fmt(r.prob, 6)]
        ]);

        h += buildSteps('percentile', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> ' + C.fmt(r.percentile, 2) + '% of values in the standard normal distribution fall below Z = ' + C.fmt(r.z, 4) + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Z → Score ===== */

    function renderReverseResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">x = ' + C.fmt(r.x, 4) + '</span><span class="stat-hero-label">Raw Score</span></div>';

        h += buildSection('Denormalization Result', [
            ['Raw Score (x)', C.fmt(r.x, 4)],
            ['Z-Score', C.fmt(r.z, 4)],
            ['Mean (\u03BC)', C.fmt(r.mu, 4)],
            ['Std Dev (\u03C3)', C.fmt(r.sigma, 4)],
            ['Percentile', C.fmt(r.percentile, 2) + '%']
        ]);

        h += buildSteps('reverse', r);
        h += buildInterpretation(r.z, r.percentile);
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
        if (mode === 'score') {
            h += step(1, 'Identify values', '<span class="stat-katex" data-tex="x = ' + C.fmt(r.x, 4) + ',\; \\mu = ' + C.fmt(r.mu, 4) + ',\; \\sigma = ' + C.fmt(r.sigma, 4) + '"></span>');
            h += step(2, 'Apply Z-score formula', '<span class="stat-katex" data-tex="Z = \\frac{x - \\mu}{\\sigma} = \\frac{' + C.fmt(r.x, 4) + ' - ' + C.fmt(r.mu, 4) + '}{' + C.fmt(r.sigma, 4) + '} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(3, 'Look up cumulative probability', '<span class="stat-katex" data-tex="P(Z \\leq ' + C.fmt(r.z, 4) + ') = ' + C.fmt(r.leftTail, 6) + '"></span>');
            h += step(4, 'Convert to percentile', '<span class="stat-katex" data-tex="\\text{Percentile} = ' + C.fmt(r.percentile, 2) + '\\%"></span>');
        } else if (mode === 'prob') {
            h += step(1, 'Input Z-score', '<span class="stat-katex" data-tex="Z = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(2, 'Look up \u03A6(z)', '<span class="stat-katex" data-tex="\\Phi(' + C.fmt(r.z, 4) + ') = ' + C.fmt(normalCDF(r.z), 6) + '"></span>');
            if (r.areaType === 'right') h += step(3, 'Right tail', '<span class="stat-katex" data-tex="P(Z \\geq z) = 1 - \\Phi(z) = ' + C.fmt(r.prob, 6) + '"></span>');
            else if (r.areaType === 'between') h += step(3, 'Between \u00B1z', '<span class="stat-katex" data-tex="P(-|z| \\leq Z \\leq |z|) = \\Phi(|z|) - \\Phi(-|z|) = ' + C.fmt(r.prob, 6) + '"></span>');
            else if (r.areaType === 'outside') h += step(3, 'Outside \u00B1z', '<span class="stat-katex" data-tex="P(|Z| \\geq |z|) = 1 - [\\Phi(|z|) - \\Phi(-|z|)] = ' + C.fmt(r.prob, 6) + '"></span>');
            else h += step(3, 'Left tail', '<span class="stat-katex" data-tex="P(Z \\leq z) = \\Phi(z) = ' + C.fmt(r.prob, 6) + '"></span>');
        } else if (mode === 'percentile') {
            h += step(1, 'Input percentile', '<span class="stat-katex" data-tex="p = ' + C.fmt(r.percentile, 2) + '\\%"></span>');
            h += step(2, 'Convert to probability', '<span class="stat-katex" data-tex="P = ' + C.fmt(r.prob, 4) + '"></span>');
            h += step(3, 'Apply inverse normal', '<span class="stat-katex" data-tex="Z = \\Phi^{-1}(' + C.fmt(r.prob, 4) + ') = ' + C.fmt(r.z, 4) + '"></span>');
        } else {
            h += step(1, 'Identify values', '<span class="stat-katex" data-tex="Z = ' + C.fmt(r.z, 4) + ',\; \\mu = ' + C.fmt(r.mu, 4) + ',\; \\sigma = ' + C.fmt(r.sigma, 4) + '"></span>');
            h += step(2, 'Apply reverse formula', '<span class="stat-katex" data-tex="x = \\mu + Z \\times \\sigma = ' + C.fmt(r.mu, 4) + ' + ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.sigma, 4) + ' = ' + C.fmt(r.x, 4) + '"></span>');
            h += step(3, 'Percentile', '<span class="stat-katex" data-tex="\\text{Percentile} = ' + C.fmt(r.percentile, 2) + '\\%"></span>');
        }
        return h + '</div>';
    }

    function buildInterpretation(z, pct) {
        var desc;
        if (Math.abs(z) < 1) desc = 'Within 1 SD of the mean (typical range).';
        else if (Math.abs(z) < 2) desc = 'Between 1\u20132 SD from the mean (somewhat unusual).';
        else if (Math.abs(z) < 3) desc = 'Between 2\u20133 SD from the mean (unusual/outlier).';
        else desc = 'More than 3 SD from the mean (extreme outlier).';

        return '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> Z = ' + C.fmt(z, 4) + ' is ' + C.fmt(Math.abs(z), 2) + ' standard deviations ' + (z >= 0 ? 'above' : 'below') + ' the mean (' + C.fmt(pct, 2) + 'th percentile). ' + desc + '</div>';
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

    /* ===== Graph (Plotly normal curve with shaded area) ===== */

    function prepareGraph(r) {
        state.pendingGraph = function() {
            G.loadPlotly(function() {
                renderNormalCurve(r);
            });
        };
        var graphTab = document.querySelector('[data-tab="zs-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) {
            state.pendingGraph();
            state.pendingGraph = null;
        }
    }

    function renderNormalCurve(r) {
        var gc = document.getElementById('zs-graph-content');
        if (gc) gc.innerHTML = '';
        var z = r.z;
        var areaType = r.areaType || 'left';
        var colors = G.getPlotColors();

        // Generate curve data
        var xVals = [], yVals = [];
        for (var t = -4; t <= 4; t += 0.05) {
            xVals.push(t);
            yVals.push(normalPDF(t));
        }

        // Shaded area
        var xFill = [], yFill = [];
        for (var i = 0; i < xVals.length; i++) {
            var keep = false;
            if (areaType === 'left') keep = xVals[i] <= z;
            else if (areaType === 'right') keep = xVals[i] >= z;
            else if (areaType === 'between') keep = xVals[i] >= -Math.abs(z) && xVals[i] <= Math.abs(z);
            else keep = xVals[i] <= -Math.abs(z) || xVals[i] >= Math.abs(z);
            if (keep) { xFill.push(xVals[i]); yFill.push(yVals[i]); }
        }

        var traces = [
            { x: xVals, y: yVals, type: 'scatter', mode: 'lines', name: 'Normal PDF', line: { color: '#e11d48', width: 2.5 } },
            { x: xFill, y: yFill, type: 'scatter', mode: 'lines', fill: 'tozeroy', name: 'Area', fillcolor: 'rgba(225,29,72,0.2)', line: { color: 'rgba(225,29,72,0.4)', width: 0 } }
        ];

        // Z-score marker line
        traces.push({
            x: [z, z], y: [0, normalPDF(z)], type: 'scatter', mode: 'lines',
            name: 'Z = ' + C.fmt(z, 2), line: { color: '#3b82f6', width: 2, dash: 'dash' }
        });

        var layout = {
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            font: { color: colors.text, family: 'Inter, sans-serif', size: 12 },
            margin: { l: 45, r: 20, t: 30, b: 40 },
            xaxis: { title: 'Z-Score', gridcolor: colors.grid, zeroline: true, zerolinecolor: colors.grid, range: [-4, 4] },
            yaxis: { title: 'Density', gridcolor: colors.grid, zeroline: false },
            showlegend: true,
            legend: { orientation: 'h', y: -0.2 }
        };

        Plotly.newPlot('zs-graph-content', traces, layout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */

    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [
            'from scipy import stats',
            'import numpy as np',
            ''
        ];

        if (state.mode === 'score') {
            lines.push('# Score to Z-Score');
            lines.push('x = ' + r.x);
            lines.push('mu = ' + r.mu);
            lines.push('sigma = ' + r.sigma);
            lines.push('z = (x - mu) / sigma');
            lines.push('percentile = stats.norm.cdf(z) * 100');
            lines.push('');
            lines.push('print(f"Z-Score: {z:.4f}")');
            lines.push('print(f"Percentile: {percentile:.2f}%")');
            lines.push('print(f"Left tail P(Z <= z): {stats.norm.cdf(z):.6f}")');
            lines.push('print(f"Right tail P(Z >= z): {1 - stats.norm.cdf(z):.6f}")');
        } else if (state.mode === 'prob') {
            lines.push('# Z-Score to Probability');
            lines.push('z = ' + r.z);
            lines.push('');
            lines.push('left = stats.norm.cdf(z)');
            lines.push('right = 1 - left');
            lines.push('between = stats.norm.cdf(abs(z)) - stats.norm.cdf(-abs(z))');
            lines.push('outside = 1 - between');
            lines.push('');
            lines.push('print(f"Left tail P(Z <= {z}): {left:.6f}")');
            lines.push('print(f"Right tail P(Z >= {z}): {right:.6f}")');
            lines.push('print(f"Between +/-{abs(z)}: {between:.6f}")');
            lines.push('print(f"Outside +/-{abs(z)}: {outside:.6f}")');
        } else if (state.mode === 'percentile') {
            lines.push('# Percentile to Z-Score');
            lines.push('percentile = ' + r.percentile);
            lines.push('z = stats.norm.ppf(percentile / 100)');
            lines.push('');
            lines.push('print(f"Percentile: {percentile}%")');
            lines.push('print(f"Z-Score: {z:.4f}")');
            lines.push('print(f"Cumulative probability: {percentile/100:.6f}")');
        } else {
            lines.push('# Z-Score to Raw Score');
            lines.push('z = ' + r.z);
            lines.push('mu = ' + r.mu);
            lines.push('sigma = ' + r.sigma);
            lines.push('x = mu + z * sigma');
            lines.push('percentile = stats.norm.cdf(z) * 100');
            lines.push('');
            lines.push('print(f"Raw Score: {x:.4f}")');
            lines.push('print(f"Z-Score: {z:.4f}")');
            lines.push('print(f"Percentile: {percentile:.2f}%")');
        }

        lines.push('');
        lines.push('# Common Z-score reference table');
        lines.push('print("\\nZ-Score Reference:")');
        lines.push('for z_ref in [-3, -2, -1, 0, 1, 1.645, 1.96, 2, 2.576, 3]:');
        lines.push('    print(f"  Z={z_ref:+.3f}  Percentile={stats.norm.cdf(z_ref)*100:.2f}%")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */

    function clearAll() {
        C.showEmpty(els.resultContent, '\u{1F4CA}', 'No Result Yet', 'Enter values and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        var gc = document.getElementById('zs-graph-content');
        if (gc && typeof Plotly !== 'undefined' && gc.data) Plotly.purge(gc);
        state.result = null;
    }

    /* ===== Restore from shared URL ===== */

    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        setMode(shared.mode);

        if (shared.mode === 'score') {
            if (shared.x != null) document.getElementById('zs-raw-score').value = shared.x;
            if (shared.mu != null) document.getElementById('zs-mean').value = shared.mu;
            if (shared.sigma != null) document.getElementById('zs-stddev').value = shared.sigma;
        } else if (shared.mode === 'prob') {
            if (shared.z != null) document.getElementById('zs-z-prob').value = shared.z;
            if (shared.areaType) document.getElementById('zs-area-type').value = shared.areaType;
        } else if (shared.mode === 'percentile') {
            if (shared.percentile != null) document.getElementById('zs-percentile').value = shared.percentile;
        } else if (shared.mode === 'reverse') {
            if (shared.z != null) document.getElementById('zs-z-reverse').value = shared.z;
            if (shared.mu != null) document.getElementById('zs-mean-reverse').value = shared.mu;
            if (shared.sigma != null) document.getElementById('zs-stddev-reverse').value = shared.sigma;
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

        // Enter key to calculate
        var inputs = document.querySelectorAll('.zs-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick example chips
        document.querySelectorAll('[data-zs-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                var ex = this.getAttribute('data-zs-example');
                if (ex === 'sat') { setMode('score'); document.getElementById('zs-raw-score').value = '1200'; document.getElementById('zs-mean').value = '1060'; document.getElementById('zs-stddev').value = '195'; }
                else if (ex === 'iq') { setMode('score'); document.getElementById('zs-raw-score').value = '130'; document.getElementById('zs-mean').value = '100'; document.getElementById('zs-stddev').value = '15'; }
                else if (ex === '95ci') { setMode('prob'); document.getElementById('zs-z-prob').value = '1.96'; document.getElementById('zs-area-type').value = 'between'; }
                else if (ex === 'top5') { setMode('percentile'); document.getElementById('zs-percentile').value = '95'; }
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

        // Restore from shared URL or auto-calculate default
        var restored = restoreFromUrl();
        if (!restored) setMode('score');
        calculate();
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
