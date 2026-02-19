/**
 * Linear Regression Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses Plotly (lazy-loaded) for scatter + residual plots.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        result: null
    };

    /* ===== Quick Example Data ===== */
    var examples = {
        'study-hours':    '1, 45\n2, 50\n3, 55\n4, 60\n5, 70\n6, 75\n7, 80\n8, 85',
        'sales':          '10, 100\n20, 200\n30, 280\n40, 400\n50, 500\n60, 550\n70, 700\n80, 750',
        'temperature':    '15, 20\n20, 25\n25, 35\n30, 45\n35, 55\n40, 65',
        'height-weight':  '150, 50\n160, 55\n165, 60\n170, 68\n175, 72\n180, 78\n185, 85\n190, 90'
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.dataInput      = document.getElementById('lr-data-input');
        els.predictX       = document.getElementById('lr-predict-x');
        els.predictBtn     = document.getElementById('lr-predict-btn');
        els.predictResult  = document.getElementById('lr-predict-result');
        els.resultContent  = document.getElementById('lr-result-content');
        els.resultActions  = document.getElementById('lr-result-actions');
        els.graphPanel     = document.getElementById('lr-graph-panel');
        els.graphContainer = document.getElementById('lr-graph-container');
        els.compilerPanel  = document.getElementById('lr-compiler-panel');
        els.compilerIframe = document.getElementById('lr-compiler-iframe');
        els.calcBtn        = document.getElementById('lr-calc-btn');
        els.clearBtn       = document.getElementById('lr-clear-btn');
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
                if (target === 'lr-graph-panel') renderGraph();
                if (target === 'lr-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Parsing ===== */
    function parseXYPairs(text) {
        var pairs = [];
        var lines = text.trim().split(/[\n]+/);
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (!line) continue;
            var parts = line.split(/[,\s\t]+/);
            if (parts.length >= 2) {
                var x = parseFloat(parts[0]);
                var y = parseFloat(parts[1]);
                if (!isNaN(x) && !isNaN(y)) pairs.push({ x: x, y: y });
            }
        }
        return pairs;
    }

    /* ===== Computation ===== */
    function linearRegression(pairs) {
        var n = pairs.length;
        var sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
        for (var i = 0; i < n; i++) {
            sumX += pairs[i].x; sumY += pairs[i].y;
            sumXY += pairs[i].x * pairs[i].y;
            sumX2 += pairs[i].x * pairs[i].x;
            sumY2 += pairs[i].y * pairs[i].y;
        }
        var xbar = sumX / n, ybar = sumY / n;
        var sxx = sumX2 - n * xbar * xbar;
        var syy = sumY2 - n * ybar * ybar;
        var sxy = sumXY - n * xbar * ybar;
        var slope = sxy / sxx;
        var intercept = ybar - slope * xbar;

        var predicted = [], residuals = [], ssRes = 0;
        for (var i = 0; i < n; i++) {
            var yPred = intercept + slope * pairs[i].x;
            predicted.push(yPred);
            var resid = pairs[i].y - yPred;
            residuals.push(resid);
            ssRes += resid * resid;
        }

        var rSquared = 1 - ssRes / syy;
        var r = Math.sqrt(Math.abs(rSquared)) * (slope >= 0 ? 1 : -1);
        var see = n > 2 ? Math.sqrt(ssRes / (n - 2)) : 0;

        return {
            slope: slope, intercept: intercept,
            r: r, rSquared: rSquared, see: see,
            n: n, xbar: xbar, ybar: ybar,
            sxx: sxx, syy: syy, sxy: sxy, ssRes: ssRes,
            predicted: predicted, residuals: residuals,
            pairs: pairs
        };
    }

    function predict(xVal) {
        return state.result.intercept + state.result.slope * xVal;
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var text = els.dataInput.value;
        if (!text.trim()) { C.showError(els.resultContent, 'Enter X, Y data pairs (one per line).'); return; }

        var pairs = parseXYPairs(text);
        if (pairs.length < 2) { C.showError(els.resultContent, 'At least 2 valid X, Y pairs are required.'); return; }

        var r = linearRegression(pairs);

        if (!isFinite(r.slope) || !isFinite(r.intercept)) {
            C.showError(els.resultContent, 'Cannot compute regression — all X values may be identical.');
            return;
        }

        state.result = r;
        renderResult(r);
        showPredictionSection(true);

        E.renderActionButtons(els.resultActions, {
            toolName: 'Linear Regression',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Linear Regression Results}\\\\[4pt]');
                lines.push('\\hat{y} = ' + C.fmt(s.intercept, 6) + (s.slope >= 0 ? ' + ' : ' - ') + C.fmt(Math.abs(s.slope), 6) + 'x\\\\');
                lines.push('b = ' + C.fmt(s.slope, 6) + '\\\\');
                lines.push('a = ' + C.fmt(s.intercept, 6) + '\\\\');
                lines.push('R^2 = ' + C.fmt(s.rSquared, 6) + '\\\\');
                lines.push('r = ' + C.fmt(s.r, 6) + '\\\\');
                lines.push('\\text{SEE} = ' + C.fmt(s.see, 6) + '\\\\');
                lines.push('n = ' + s.n + '\\\\');
                lines.push('\\bar{x} = ' + C.fmt(s.xbar, 6) + '\\\\');
                lines.push('\\bar{y} = ' + C.fmt(s.ybar, 6));
                return lines.join('\n');
            },
            getShareState: function() {
                return { data: els.dataInput.value };
            },
            resultEl: '#lr-result-content'
        });

        // Refresh compiler if tab is active
        var compilerTab = document.querySelector('[data-tab="lr-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        // Refresh graph if tab is active
        var graphTab = document.querySelector('[data-tab="lr-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) renderGraph();
    }

    /* ===== Render Result ===== */
    function renderResult(r) {
        var eqStr = formatEquation(r.intercept, r.slope);
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + eqStr + '</span><span class="stat-hero-label">Regression Equation</span></div>';

        h += buildSection('Regression Statistics', [
            ['Slope (b)', C.fmt(r.slope, 6)],
            ['Intercept (a)', C.fmt(r.intercept, 6)],
            ['R\u00B2', C.fmt(r.rSquared, 6)],
            ['Correlation (r)', C.fmt(r.r, 6)],
            ['Standard Error (SEE)', C.fmt(r.see, 6)],
            ['Sample Size (n)', r.n],
            ['Mean X (\u0078\u0304)', C.fmt(r.xbar, 6)],
            ['Mean Y (\u0079\u0304)', C.fmt(r.ybar, 6)]
        ]);

        h += buildSteps(r);
        h += buildInterpretation(r);

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    function formatEquation(a, b) {
        var aStr = C.fmt(a, 4);
        var bStr = C.fmt(Math.abs(b), 4);
        if (b >= 0) return 'y = ' + aStr + ' + ' + bStr + 'x';
        return 'y = ' + aStr + ' \u2212 ' + bStr + 'x';
    }

    /* ===== Helpers ===== */
    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        h += step(1, 'Compute Means',
            '<span class="stat-katex" data-tex="\\bar{x} = \\frac{\\sum x_i}{n} = ' + C.fmt(r.xbar, 4) + '"></span>' +
            '<br><span class="stat-katex" data-tex="\\bar{y} = \\frac{\\sum y_i}{n} = ' + C.fmt(r.ybar, 4) + '"></span>');

        h += step(2, 'Compute Slope',
            '<span class="stat-katex" data-tex="S_{xy} = \\sum x_i y_i - n\\bar{x}\\bar{y} = ' + C.fmt(r.sxy, 4) + '"></span>' +
            '<br><span class="stat-katex" data-tex="S_{xx} = \\sum x_i^2 - n\\bar{x}^2 = ' + C.fmt(r.sxx, 4) + '"></span>' +
            '<br><span class="stat-katex" data-tex="b = \\frac{S_{xy}}{S_{xx}} = \\frac{' + C.fmt(r.sxy, 4) + '}{' + C.fmt(r.sxx, 4) + '} = ' + C.fmt(r.slope, 6) + '"></span>');

        h += step(3, 'Compute Intercept',
            '<span class="stat-katex" data-tex="a = \\bar{y} - b\\bar{x} = ' + C.fmt(r.ybar, 4) + ' - ' + C.fmt(r.slope, 4) + ' \\times ' + C.fmt(r.xbar, 4) + ' = ' + C.fmt(r.intercept, 6) + '"></span>');

        h += step(4, 'Compute R\u00B2',
            '<span class="stat-katex" data-tex="SS_{res} = \\sum(y_i - \\hat{y}_i)^2 = ' + C.fmt(r.ssRes, 4) + '"></span>' +
            '<br><span class="stat-katex" data-tex="SS_{tot} = S_{yy} = ' + C.fmt(r.syy, 4) + '"></span>' +
            '<br><span class="stat-katex" data-tex="R^2 = 1 - \\frac{SS_{res}}{SS_{tot}} = 1 - \\frac{' + C.fmt(r.ssRes, 4) + '}{' + C.fmt(r.syy, 4) + '} = ' + C.fmt(r.rSquared, 6) + '"></span>');

        return h + '</div>';
    }

    function step(num, title, content) {
        return '<div class="stat-step"><div class="stat-step-number">' + num + '</div><div class="stat-step-content"><strong>' + title + '</strong><div style="margin-top:0.25rem">' + content + '</div></div></div>';
    }

    function buildInterpretation(r) {
        var quality;
        if (r.rSquared >= 0.9) quality = 'excellent';
        else if (r.rSquared >= 0.7) quality = 'good';
        else if (r.rSquared >= 0.4) quality = 'moderate';
        else quality = 'weak';

        var qualityLabel = quality.charAt(0).toUpperCase() + quality.slice(1);
        var pct = C.fmt(r.rSquared * 100, 2);

        var slopeDir = r.slope > 0 ? 'positive' : r.slope < 0 ? 'negative' : 'zero';
        var slopeInterp = r.slope > 0
            ? 'For each unit increase in X, Y increases by approximately ' + C.fmt(Math.abs(r.slope), 4) + '.'
            : r.slope < 0
                ? 'For each unit increase in X, Y decreases by approximately ' + C.fmt(Math.abs(r.slope), 4) + '.'
                : 'X has no linear effect on Y.';

        return '<div class="stat-interpretation stat-interpretation-normal">' +
            '<strong>Interpretation:</strong> ' +
            'R\u00B2 = ' + C.fmt(r.rSquared, 4) + ' (' + qualityLabel + ' fit) \u2014 ' + pct + '% of the variance in Y is explained by X. ' +
            'The correlation r = ' + C.fmt(r.r, 4) + ' indicates a ' + slopeDir + ' linear relationship. ' +
            slopeInterp +
            '</div>';
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

    /* ===== Prediction ===== */
    function showPredictionSection(show) {
        var section = els.predictX ? els.predictX.closest('.lr-predict-section') : null;
        if (section) section.style.display = show ? '' : 'none';
    }

    function doPrediction() {
        if (!state.result) return;
        var xVal = parseFloat(els.predictX.value);
        if (isNaN(xVal)) {
            els.predictResult.innerHTML = '<span style="color:var(--stat-error,#e74c3c)">Enter a valid X value.</span>';
            return;
        }
        var yVal = predict(xVal);
        els.predictResult.innerHTML = '<strong>Predicted Y = ' + C.fmt(yVal, 6) + '</strong>' +
            ' <span style="opacity:0.7">(for X = ' + C.fmt(xVal, 4) + ')</span>';
    }

    /* ===== Graph ===== */
    function renderGraph() {
        if (!state.result) {
            C.showEmpty(els.graphContainer, '\uD83D\uDCC8', 'No Data', 'Calculate a regression first to see the plot.');
            return;
        }

        G.loadPlotly(function() {
            var r = state.result;
            var xs = [], ys = [], residXs = [], residYs = [];
            for (var i = 0; i < r.pairs.length; i++) {
                xs.push(r.pairs[i].x);
                ys.push(r.pairs[i].y);
                residXs.push(r.pairs[i].x);
                residYs.push(r.residuals[i]);
            }

            var xMin = Math.min.apply(null, xs);
            var xMax = Math.max.apply(null, xs);
            var pad = (xMax - xMin) * 0.05 || 1;
            var lineX = [xMin - pad, xMax + pad];
            var lineY = [r.intercept + r.slope * lineX[0], r.intercept + r.slope * lineX[1]];

            var scatterTrace = {
                x: xs, y: ys,
                mode: 'markers',
                type: 'scatter',
                name: 'Data Points',
                marker: { color: '#3498db', size: 8 },
                xaxis: 'x1', yaxis: 'y1'
            };

            var lineTrace = {
                x: lineX, y: lineY,
                mode: 'lines',
                type: 'scatter',
                name: formatEquation(r.intercept, r.slope),
                line: { color: '#e74c3c', width: 2, dash: 'solid' },
                xaxis: 'x1', yaxis: 'y1'
            };

            var residTrace = {
                x: residXs, y: residYs,
                mode: 'markers',
                type: 'scatter',
                name: 'Residuals',
                marker: { color: '#2ecc71', size: 7, symbol: 'diamond' },
                xaxis: 'x2', yaxis: 'y2'
            };

            var zeroLine = {
                x: lineX, y: [0, 0],
                mode: 'lines',
                type: 'scatter',
                name: 'Zero Line',
                line: { color: '#95a5a6', width: 1, dash: 'dash' },
                showlegend: false,
                xaxis: 'x2', yaxis: 'y2'
            };

            var layout = {
                grid: { rows: 2, columns: 1, pattern: 'independent', roworder: 'top to bottom' },
                xaxis: { title: 'X', domain: [0, 1], anchor: 'y1' },
                yaxis: { title: 'Y', domain: [0.55, 1], anchor: 'x1' },
                xaxis2: { title: 'X', domain: [0, 1], anchor: 'y2' },
                yaxis2: { title: 'Residual', domain: [0, 0.4], anchor: 'x2' },
                title: { text: 'Scatter Plot & Residuals', font: { size: 14 } },
                showlegend: true,
                legend: { orientation: 'h', y: -0.15 },
                margin: { t: 40, b: 60, l: 60, r: 20 },
                paper_bgcolor: 'rgba(0,0,0,0)',
                plot_bgcolor: 'rgba(0,0,0,0)',
                font: { family: 'inherit' }
            };

            var config = { responsive: true, displayModeBar: false };
            window.Plotly.newPlot(els.graphContainer, [scatterTrace, lineTrace, residTrace, zeroLine], layout, config);
        });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var xArr = [], yArr = [];
        for (var i = 0; i < r.pairs.length; i++) {
            xArr.push(r.pairs[i].x);
            yArr.push(r.pairs[i].y);
        }

        var lines = [];
        lines.push('import numpy as np');
        lines.push('from scipy import stats');
        lines.push('');
        lines.push('x = np.array([' + xArr.join(', ') + '])');
        lines.push('y = np.array([' + yArr.join(', ') + '])');
        lines.push('');
        lines.push('slope, intercept, r, p, se = stats.linregress(x, y)');
        lines.push('r_squared = r ** 2');
        lines.push('y_pred = intercept + slope * x');
        lines.push('residuals = y - y_pred');
        lines.push('see = np.sqrt(np.sum(residuals**2) / (len(x) - 2))');
        lines.push('');
        lines.push('print(f"Equation: y = {intercept:.4f} + {slope:.4f}x")');
        lines.push('print(f"R\\u00b2 = {r_squared:.6f}")');
        lines.push('print(f"r = {r:.6f}, p = {p:.6f}")');
        lines.push('print(f"SEE = {see:.4f}")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83D\uDCC9', 'No Result Yet', 'Enter X, Y data pairs and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        els.dataInput.value = '';
        els.predictX.value = '';
        els.predictResult.innerHTML = '';
        showPredictionSection(false);
        if (els.graphContainer) els.graphContainer.innerHTML = '';
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (examples[ex]) {
            els.dataInput.value = examples[ex];
            calculate();
        }
    }

    /* ===== Share URL Restore ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (shared && shared.data && els.dataInput) {
            els.dataInput.value = shared.data;
            calculate();
            return true;
        }
        return false;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        if (els.predictBtn) {
            els.predictBtn.addEventListener('click', doPrediction);
        }
        if (els.predictX) {
            els.predictX.addEventListener('keypress', function(e) { if (e.key === 'Enter') doPrediction(); });
        }

        var inputs = document.querySelectorAll('.lr-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-lr-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-lr-example'));
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Hide prediction section until first calculation
        showPredictionSection(false);

        // Restore from share URL, or load default example
        if (!restoreFromUrl()) {
            applyExample('study-hours');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
