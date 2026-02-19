/**
 * Correlation Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy) for t-distribution p-value, Plotly (lazy) for scatter plot.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'pearson',
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('corr-result-content');
        els.resultActions  = document.getElementById('corr-result-actions');
        els.graphPanel     = document.getElementById('corr-graph-panel');
        els.graphContainer = document.getElementById('corr-graph-container');
        els.compilerPanel  = document.getElementById('corr-compiler-panel');
        els.compilerIframe = document.getElementById('corr-compiler-iframe');
        els.calcBtn        = document.getElementById('corr-calc-btn');
        els.clearBtn       = document.getElementById('corr-clear-btn');

        els.modePearson  = document.getElementById('corr-mode-pearson');
        els.modeSpearman = document.getElementById('corr-mode-spearman');
        els.modeBoth     = document.getElementById('corr-mode-both');

        els.xData = document.getElementById('corr-x-data');
        els.yData = document.getElementById('corr-y-data');
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
                if (target === 'corr-graph-panel') loadGraph();
                if (target === 'corr-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modePearson.addEventListener('click', function() { setMode('pearson'); });
        els.modeSpearman.addEventListener('click', function() { setMode('spearman'); });
        els.modeBoth.addEventListener('click', function() { setMode('both'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modePearson.classList.toggle('active', m === 'pearson');
        els.modeSpearman.classList.toggle('active', m === 'spearman');
        els.modeBoth.classList.toggle('active', m === 'both');
    }

    /* ===== Math Helpers ===== */
    function parseNumbers(text) {
        return text.trim().split(/[\n]+/).map(function(s) { return parseFloat(s.trim()); }).filter(function(v) { return !isNaN(v); });
    }

    function mean(arr) {
        var sum = 0; for (var i = 0; i < arr.length; i++) sum += arr[i]; return sum / arr.length;
    }

    function stddev(arr) {
        var m = mean(arr), s = 0;
        for (var i = 0; i < arr.length; i++) s += (arr[i] - m) * (arr[i] - m);
        return Math.sqrt(s / arr.length);
    }

    function pearsonCorr(x, y) {
        var n = x.length, mx = mean(x), my = mean(y);
        var num = 0, dx2 = 0, dy2 = 0;
        for (var i = 0; i < n; i++) {
            var dx = x[i] - mx, dy = y[i] - my;
            num += dx * dy; dx2 += dx * dx; dy2 += dy * dy;
        }
        return dx2 * dy2 === 0 ? 0 : num / Math.sqrt(dx2 * dy2);
    }

    function rankData(arr) {
        var indexed = arr.map(function(v, i) { return { val: v, idx: i }; });
        indexed.sort(function(a, b) { return a.val - b.val; });
        var ranks = new Array(arr.length);
        var i = 0;
        while (i < indexed.length) {
            var j = i;
            while (j < indexed.length && indexed[j].val === indexed[i].val) j++;
            var avgRank = (i + 1 + j) / 2;
            for (var k = i; k < j; k++) ranks[indexed[k].idx] = avgRank;
            i = j;
        }
        return ranks;
    }

    function spearmanCorr(x, y) {
        return pearsonCorr(rankData(x), rankData(y));
    }

    function significance(r, n) {
        if (Math.abs(r) >= 1) return { t: Infinity, df: n - 2, p: 0 };
        var t = r * Math.sqrt(n - 2) / Math.sqrt(1 - r * r);
        var df = n - 2;
        var p;
        if (window.jStat) {
            p = 2 * (1 - window.jStat.studentt.cdf(Math.abs(t), df));
        } else {
            p = n > 30 ? 0.001 : 0.05;
        }
        return { t: t, df: df, p: p };
    }

    function getStrength(r) {
        var abs = Math.abs(r);
        if (abs >= 0.8) return 'Very Strong';
        if (abs >= 0.6) return 'Strong';
        if (abs >= 0.4) return 'Moderate';
        if (abs >= 0.2) return 'Weak';
        return 'Very Weak';
    }

    function getDirection(r) {
        if (r > 0) return 'Positive';
        if (r < 0) return 'Negative';
        return 'None';
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var x = parseNumbers(els.xData.value);
        var y = parseNumbers(els.yData.value);

        if (x.length < 3) { C.showError(els.resultContent, 'Enter at least 3 X values (one per line).'); return; }
        if (y.length < 3) { C.showError(els.resultContent, 'Enter at least 3 Y values (one per line).'); return; }
        if (x.length !== y.length) { C.showError(els.resultContent, 'X and Y must have the same number of values. X has ' + x.length + ', Y has ' + y.length + '.'); return; }

        var n = x.length;
        var r = {};
        r.x = x;
        r.y = y;
        r.n = n;

        if (state.mode === 'pearson' || state.mode === 'both') {
            r.pearson = pearsonCorr(x, y);
            r.pearsonR2 = r.pearson * r.pearson;
            r.pearsonSig = significance(r.pearson, n);
        }
        if (state.mode === 'spearman' || state.mode === 'both') {
            r.spearman = spearmanCorr(x, y);
            r.spearmanR2 = r.spearman * r.spearman;
            r.spearmanSig = significance(r.spearman, n);
        }

        state.result = r;

        if (state.mode === 'pearson') renderPearsonResult(r);
        else if (state.mode === 'spearman') renderSpearmanResult(r);
        else renderBothResult(r);

        E.renderActionButtons(els.resultActions, {
            toolName: 'Correlation Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Correlation Calculator}\\\\[4pt]');
                lines.push('n = ' + s.n + '\\\\');
                if (s.pearson != null) {
                    lines.push('r_{\\text{Pearson}} = ' + C.fmt(s.pearson, 6) + '\\\\');
                    lines.push('R^2_{\\text{Pearson}} = ' + C.fmt(s.pearsonR2, 6) + '\\\\');
                    lines.push('t = ' + C.fmt(s.pearsonSig.t, 4) + ',\\quad p = ' + (s.pearsonSig.p < 0.0001 ? '< 0.0001' : C.fmt(s.pearsonSig.p, 6)) + '\\\\');
                }
                if (s.spearman != null) {
                    lines.push('\\rho_{\\text{Spearman}} = ' + C.fmt(s.spearman, 6) + '\\\\');
                    lines.push('R^2_{\\text{Spearman}} = ' + C.fmt(s.spearmanR2, 6) + '\\\\');
                    lines.push('t = ' + C.fmt(s.spearmanSig.t, 4) + ',\\quad p = ' + (s.spearmanSig.p < 0.0001 ? '< 0.0001' : C.fmt(s.spearmanSig.p, 6)) + '\\\\');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                return {
                    mode: state.mode,
                    x: els.xData.value,
                    y: els.yData.value
                };
            },
            resultEl: '#corr-result-content'
        });

        // Refresh compiler if active
        var compilerTab = document.querySelector('[data-tab="corr-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        // Refresh graph if active
        var graphTab = document.querySelector('[data-tab="corr-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    /* ===== Render: Pearson ===== */
    function renderPearsonResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">r = ' + C.fmt(r.pearson, 4) + '</span><span class="stat-hero-label">Pearson Correlation</span></div>';
        h += buildCorrSection('Pearson Correlation', r.pearson, r.pearsonR2, r.pearsonSig, r.n);
        h += buildSteps('pearson', r);
        h += buildInterpretation(r.pearson, r.pearsonR2, r.pearsonSig, 'Pearson');
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Spearman ===== */
    function renderSpearmanResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">\u03C1 = ' + C.fmt(r.spearman, 4) + '</span><span class="stat-hero-label">Spearman Correlation</span></div>';
        h += buildCorrSection('Spearman Rank Correlation', r.spearman, r.spearmanR2, r.spearmanSig, r.n);
        h += buildSteps('spearman', r);
        h += buildInterpretation(r.spearman, r.spearmanR2, r.spearmanSig, 'Spearman');
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Both ===== */
    function renderBothResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">r = ' + C.fmt(r.pearson, 4) + ' | \u03C1 = ' + C.fmt(r.spearman, 4) + '</span><span class="stat-hero-label">Pearson vs Spearman</span></div>';
        h += buildCorrSection('Pearson Correlation', r.pearson, r.pearsonR2, r.pearsonSig, r.n);
        h += buildCorrSection('Spearman Rank Correlation', r.spearman, r.spearmanR2, r.spearmanSig, r.n);
        h += buildSteps('both', r);
        var diff = Math.abs(r.pearson - r.spearman);
        var comparison = diff < 0.05
            ? 'Pearson and Spearman coefficients are very similar, suggesting the relationship is approximately linear.'
            : diff < 0.15
            ? 'There is a moderate difference between the two coefficients, indicating some non-linearity in the relationship.'
            : 'The substantial difference between Pearson (' + C.fmt(r.pearson, 4) + ') and Spearman (' + C.fmt(r.spearman, 4) + ') suggests a non-linear but monotonic relationship.';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Comparison:</strong> ' + comparison + '</div>';
        h += buildInterpretation(r.pearson, r.pearsonR2, r.pearsonSig, 'Pearson');
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Helpers ===== */
    function buildCorrSection(title, rVal, r2, sig, n) {
        var pStr = sig.p < 0.0001 ? '< 0.0001' : C.fmt(sig.p, 6);
        var tStr = Math.abs(sig.t) === Infinity ? '\u221E' : C.fmt(sig.t, 4);
        var rows = [
            ['Correlation (r)', C.fmt(rVal, 6)],
            ['R\u00B2', C.fmt(r2, 6)],
            ['p-value', pStr],
            ['t-statistic', tStr],
            ['Degrees of Freedom', sig.df],
            ['Sample Size (n)', n],
            ['Strength', getStrength(rVal)],
            ['Direction', getDirection(rVal)]
        ];
        return buildSection(title, rows);
    }

    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function buildSteps(mode, r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (mode === 'pearson' || mode === 'both') {
            h += step(1, 'Compute Means', '<span class="stat-katex" data-tex="\\bar{x} = \\frac{1}{n}\\sum x_i,\\quad \\bar{y} = \\frac{1}{n}\\sum y_i"></span>');
            h += step(2, 'Pearson Formula', '<span class="stat-katex" data-tex="r = \\frac{\\sum (x_i - \\bar{x})(y_i - \\bar{y})}{\\sqrt{\\sum (x_i - \\bar{x})^2 \\cdot \\sum (y_i - \\bar{y})^2}} = ' + C.fmt(r.pearson, 6) + '"></span>');
            h += step(3, 'Coefficient of Determination', '<span class="stat-katex" data-tex="R^2 = r^2 = ' + C.fmt(r.pearson, 4) + '^2 = ' + C.fmt(r.pearsonR2, 6) + '"></span>');
            h += step(4, 'Significance Test', '<span class="stat-katex" data-tex="t = \\frac{r\\sqrt{n-2}}{\\sqrt{1-r^2}} = \\frac{' + C.fmt(r.pearson, 4) + '\\sqrt{' + (r.n - 2) + '}}{\\sqrt{1 - ' + C.fmt(r.pearsonR2, 4) + '}} = ' + C.fmt(r.pearsonSig.t, 4) + '"></span>');
        }
        if (mode === 'spearman' || mode === 'both') {
            var sn = mode === 'both' ? 5 : 1;
            h += step(sn, 'Assign Ranks', '<span class="stat-katex" data-tex="\\text{Rank each } x_i \\text{ and } y_i \\text{ (average ties)}"></span>');
            h += step(sn + 1, 'Spearman Formula', '<span class="stat-katex" data-tex="\\rho = \\text{Pearson}(\\text{rank}(x),\\; \\text{rank}(y)) = ' + C.fmt(r.spearman, 6) + '"></span>');
            h += step(sn + 2, 'Spearman R\u00B2', '<span class="stat-katex" data-tex="R^2 = \\rho^2 = ' + C.fmt(r.spearmanR2, 6) + '"></span>');
        }
        return h + '</div>';
    }

    function buildInterpretation(rVal, r2, sig, label) {
        var strength = getStrength(rVal);
        var dir = getDirection(rVal);
        var sigText = sig.p < 0.05
            ? 'The correlation is statistically significant (p ' + (sig.p < 0.0001 ? '< 0.0001' : '= ' + C.fmt(sig.p, 4)) + '), meaning it is unlikely due to chance.'
            : 'The correlation is not statistically significant (p = ' + C.fmt(sig.p, 4) + '), so this result could be due to random variation.';
        var r2Text = 'R\u00B2 = ' + C.fmt(r2 * 100, 1) + '% of the variance in Y is explained by X.';
        return '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The ' + label + ' correlation is <strong>' + C.fmt(rVal, 4) + '</strong>, indicating a <strong>' + strength.toLowerCase() + ' ' + dir.toLowerCase() + '</strong> relationship. ' + sigText + ' ' + r2Text + '</div>';
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

    /* ===== Graph (Scatter Plot) ===== */
    function loadGraph() {
        if (!state.result) return;
        G.loadPlotly(function() {
            var r = state.result;
            var x = r.x, y = r.y;
            var mx = mean(x), my = mean(y);
            var sx = stddev(x), sy = stddev(y);
            var rVal = (state.mode === 'spearman') ? r.spearman : r.pearson;
            var slope = sx > 0 ? rVal * (sy / sx) : 0;
            var intercept = my - slope * mx;

            var xMin = Math.min.apply(null, x);
            var xMax = Math.max.apply(null, x);
            var pad = (xMax - xMin) * 0.1 || 1;
            var lineX = [xMin - pad, xMax + pad];
            var lineY = [slope * lineX[0] + intercept, slope * lineX[1] + intercept];

            var scatter = {
                x: x, y: y,
                mode: 'markers',
                type: 'scatter',
                name: 'Data Points',
                marker: { color: '#6366f1', size: 10, opacity: 0.8 }
            };
            var trendline = {
                x: lineX, y: lineY,
                mode: 'lines',
                type: 'scatter',
                name: 'Trend Line (r = ' + C.fmt(rVal, 4) + ')',
                line: { color: '#ef4444', width: 2, dash: 'dash' }
            };
            var layout = {
                title: 'Scatter Plot with Trend Line',
                xaxis: { title: 'X' },
                yaxis: { title: 'Y' },
                showlegend: true,
                margin: { t: 50, r: 30, b: 50, l: 50 },
                font: { family: 'Inter, system-ui, sans-serif' }
            };

            els.graphContainer.innerHTML = '';
            window.Plotly.newPlot(els.graphContainer, [scatter, trendline], layout, { responsive: true });
        });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var xStr = r.x.join(', ');
        var yStr = r.y.join(', ');
        var lines = [];
        lines.push('import numpy as np');
        lines.push('from scipy import stats');
        lines.push('');
        lines.push('x = np.array([' + xStr + '])');
        lines.push('y = np.array([' + yStr + '])');
        lines.push('');
        lines.push('r_pearson, p_pearson = stats.pearsonr(x, y)');
        lines.push('r_spearman, p_spearman = stats.spearmanr(x, y)');
        lines.push('r_squared = r_pearson ** 2');
        lines.push('');
        lines.push('print(f"Pearson r = {r_pearson:.6f}, p = {p_pearson:.6f}")');
        lines.push('print(f"Spearman rho = {r_spearman:.6f}, p = {p_spearman:.6f}")');
        lines.push('print(f"R-squared = {r_squared:.6f}")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83D\uDCC8', 'No Result Yet', 'Enter X and Y data and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        els.graphContainer.innerHTML = '';
        els.xData.value = '';
        els.yData.value = '';
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    var examples = {
        'positive-strong': {
            x: [10, 20, 30, 40, 50, 60, 70, 80],
            y: [15, 28, 35, 45, 58, 62, 75, 85]
        },
        'negative-strong': {
            x: [1, 2, 3, 4, 5, 6, 7, 8],
            y: [10, 9, 8, 7, 6, 5, 4, 3]
        },
        'weak': {
            x: [5, 10, 15, 20, 25, 30],
            y: [12, 8, 18, 15, 22, 10]
        },
        'nonlinear': {
            x: [1, 2, 3, 4, 5, 6, 7, 8],
            y: [1, 4, 9, 16, 25, 36, 49, 64]
        }
    };

    function applyExample(name) {
        var ex = examples[name];
        if (!ex) return;
        els.xData.value = ex.x.join('\n');
        els.yData.value = ex.y.join('\n');
        calculate();
    }

    /* ===== Restore from URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared) return false;
        if (shared.mode) setMode(shared.mode);
        if (shared.x) els.xData.value = shared.x;
        if (shared.y) els.yData.value = shared.y;
        calculate();
        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();

        // Pre-load jStat for significance tests
        G.loadJStat(function() {});

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        // Enter key on textareas
        var inputs = document.querySelectorAll('.corr-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter' && e.ctrlKey) calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-corr-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-corr-example'));
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Restore from shared URL, or fall back to default example
        setMode('pearson');
        if (!restoreFromUrl()) {
            applyExample('positive-strong');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
