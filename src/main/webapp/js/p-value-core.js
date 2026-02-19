/**
 * P-Value Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for CDF calculations across 4 distributions.
 * Uses Plotly (lazy-loaded) for distribution curve visualization.
 *
 * Modes: z (Z-Test), t (T-Test), chi (Chi-Square), f (F-Test)
 * Tail types: left, two (default), right
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    var PREFIX = 'pv-';

    /* ===== State ===== */
    var state = {
        mode: 'z',
        tail: 'two',
        results: null
    };

    /* ===== DOM Cache ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById(PREFIX + 'result-content');
        els.resultActions  = document.getElementById(PREFIX + 'result-actions');
        els.graphPanel     = document.getElementById(PREFIX + 'graph-panel');
        els.graphContainer = document.getElementById(PREFIX + 'graph-container');
        els.compilerPanel  = document.getElementById(PREFIX + 'compiler-panel');
        els.compilerIframe = document.getElementById(PREFIX + 'compiler-iframe');
        els.calcBtn        = document.getElementById(PREFIX + 'calc-btn');
        els.clearBtn       = document.getElementById(PREFIX + 'clear-btn');

        els.modeZ   = document.getElementById(PREFIX + 'mode-z');
        els.modeT   = document.getElementById(PREFIX + 'mode-t');
        els.modeChi = document.getElementById(PREFIX + 'mode-chi');
        els.modeF   = document.getElementById(PREFIX + 'mode-f');

        els.panelZ   = document.getElementById(PREFIX + 'input-z');
        els.panelT   = document.getElementById(PREFIX + 'input-t');
        els.panelChi = document.getElementById(PREFIX + 'input-chi');
        els.panelF   = document.getElementById(PREFIX + 'input-f');
    }

    /* ===== Examples ===== */
    var EXAMPLES = {
        'z-critical': { mode: 'z', z: 1.96, tail: 'two', desc: 'Z = 1.96 (95% critical)' },
        't-small':    { mode: 't', t: 2.5, df: 20, tail: 'two', desc: 'T-test (df=20)' },
        'chi-gof':    { mode: 'chi', chi: 5.99, df: 2, desc: 'Chi-Square GOF' },
        'f-anova':    { mode: 'f', f: 3.5, df1: 3, df2: 20, desc: 'F-test (ANOVA)' }
    };

    /* ===== Core Computation Functions ===== */

    function computeZ(z, tail) {
        var cdf = window.jStat.normal.cdf(z, 0, 1);
        var p;
        if (tail === 'left') {
            p = cdf;
        } else if (tail === 'right') {
            p = 1 - cdf;
        } else {
            p = 2 * Math.min(cdf, 1 - cdf);
        }
        return { test: 'Z-Test', stat: z, statName: 'Z', pValue: p, tail: tail, dist: 'normal' };
    }

    function computeT(t, df, tail) {
        var cdf = window.jStat.studentt.cdf(t, df);
        var p;
        if (tail === 'left') {
            p = cdf;
        } else if (tail === 'right') {
            p = 1 - cdf;
        } else {
            p = 2 * Math.min(cdf, 1 - cdf);
        }
        return { test: 'T-Test', stat: t, df: df, statName: 't', pValue: p, tail: tail, dist: 't' };
    }

    function computeChi(chi, df) {
        var p = 1 - window.jStat.chisquare.cdf(chi, df);
        return { test: 'Chi-Square', stat: chi, df: df, statName: '\u03C7\u00B2', pValue: p, tail: 'right', dist: 'chi' };
    }

    function computeF(f, df1, df2) {
        var p = 1 - window.jStat.centralF.cdf(f, df1, df2);
        return { test: 'F-Test', stat: f, df1: df1, df2: df2, statName: 'F', pValue: p, tail: 'right', dist: 'f' };
    }

    /* ===== Significance Classification ===== */

    function getSig(p) {
        if (p < 0.001) return { label: 'Highly Significant', cls: 'stat-interpretation-normal', stars: '***' };
        if (p < 0.01)  return { label: 'Very Significant', cls: 'stat-interpretation-normal', stars: '**' };
        if (p < 0.05)  return { label: 'Significant', cls: 'stat-interpretation-normal', stars: '*' };
        if (p < 0.10)  return { label: 'Marginally Significant', cls: 'stat-interpretation-warning', stars: '\u2020' };
        return { label: 'Not Significant', cls: 'stat-interpretation-warning', stars: '' };
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
                if (target === PREFIX + 'graph-panel') renderGraph();
                if (target === PREFIX + 'compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */

    function initModes() {
        if (els.modeZ)   els.modeZ.addEventListener('click', function()   { setMode('z'); });
        if (els.modeT)   els.modeT.addEventListener('click', function()   { setMode('t'); });
        if (els.modeChi) els.modeChi.addEventListener('click', function() { setMode('chi'); });
        if (els.modeF)   els.modeF.addEventListener('click', function()   { setMode('f'); });
    }

    function setMode(m) {
        state.mode = m;
        if (els.modeZ)   els.modeZ.classList.toggle('active', m === 'z');
        if (els.modeT)   els.modeT.classList.toggle('active', m === 't');
        if (els.modeChi) els.modeChi.classList.toggle('active', m === 'chi');
        if (els.modeF)   els.modeF.classList.toggle('active', m === 'f');

        if (els.panelZ)   els.panelZ.style.display   = m === 'z'   ? '' : 'none';
        if (els.panelT)   els.panelT.style.display   = m === 't'   ? '' : 'none';
        if (els.panelChi) els.panelChi.style.display = m === 'chi' ? '' : 'none';
        if (els.panelF)   els.panelF.style.display   = m === 'f'   ? '' : 'none';

        /* Chi-Square and F-Test are always right-tailed */
        if (m === 'chi' || m === 'f') {
            state.tail = 'right';
            updateTailButtons();
            disableTailToggle(true);
        } else {
            disableTailToggle(false);
        }
    }

    /* ===== Tail Toggle ===== */

    function initTailToggle() {
        var btns = document.querySelectorAll('[data-tail]');
        for (var i = 0; i < btns.length; i++) {
            btns[i].addEventListener('click', function() {
                if (this.disabled || this.classList.contains('disabled')) return;
                state.tail = this.getAttribute('data-tail');
                updateTailButtons();
            });
        }
    }

    function updateTailButtons() {
        var btns = document.querySelectorAll('[data-tail]');
        for (var i = 0; i < btns.length; i++) {
            btns[i].classList.toggle('active', btns[i].getAttribute('data-tail') === state.tail);
        }
    }

    function disableTailToggle(disabled) {
        var btns = document.querySelectorAll('[data-tail]');
        for (var i = 0; i < btns.length; i++) {
            if (disabled) {
                btns[i].classList.add('disabled');
                btns[i].setAttribute('disabled', 'disabled');
            } else {
                btns[i].classList.remove('disabled');
                btns[i].removeAttribute('disabled');
            }
        }
        if (disabled) updateTailButtons();
    }

    /* ===== Calculate — Main Entry ===== */

    function calculate() {
        G.loadJStat(function() {
            try {
                doCalculate();
            } catch (e) {
                C.showError(els.resultContent, 'Calculation error: ' + e.message);
            }
        });
    }

    function doCalculate() {
        var r;

        if (state.mode === 'z') {
            var zVal = parseFloat(getInput(PREFIX + 'z-score'));
            if (isNaN(zVal)) { C.showError(els.resultContent, 'Enter a valid Z-score.'); return; }
            r = computeZ(zVal, state.tail);

        } else if (state.mode === 't') {
            var tVal = parseFloat(getInput(PREFIX + 't-stat'));
            var tDf  = parseFloat(getInput(PREFIX + 't-df'));
            if (isNaN(tVal)) { C.showError(els.resultContent, 'Enter a valid t-statistic.'); return; }
            if (isNaN(tDf) || tDf < 1) { C.showError(els.resultContent, 'Degrees of freedom must be at least 1.'); return; }
            r = computeT(tVal, tDf, state.tail);

        } else if (state.mode === 'chi') {
            var chiVal = parseFloat(getInput(PREFIX + 'chi-stat'));
            var chiDf  = parseFloat(getInput(PREFIX + 'chi-df'));
            if (isNaN(chiVal) || chiVal < 0) { C.showError(els.resultContent, 'Chi-square statistic must be a non-negative number.'); return; }
            if (isNaN(chiDf) || chiDf < 1) { C.showError(els.resultContent, 'Degrees of freedom must be at least 1.'); return; }
            r = computeChi(chiVal, chiDf);

        } else if (state.mode === 'f') {
            var fVal = parseFloat(getInput(PREFIX + 'f-stat'));
            var fDf1 = parseFloat(getInput(PREFIX + 'f-df1'));
            var fDf2 = parseFloat(getInput(PREFIX + 'f-df2'));
            if (isNaN(fVal) || fVal < 0) { C.showError(els.resultContent, 'F-statistic must be a non-negative number.'); return; }
            if (isNaN(fDf1) || fDf1 < 1) { C.showError(els.resultContent, 'Numerator degrees of freedom (df1) must be at least 1.'); return; }
            if (isNaN(fDf2) || fDf2 < 1) { C.showError(els.resultContent, 'Denominator degrees of freedom (df2) must be at least 1.'); return; }
            r = computeF(fVal, fDf1, fDf2);
        }

        if (!r) return;

        state.results = r;
        renderResults(r);

        /* Action buttons: Share, Copy LaTeX, Download */
        E.renderActionButtons(els.resultActions, {
            toolName: 'P-Value Calculator',
            getLatex: function() {
                var s = state.results;
                if (!s) return '';
                var sig = getSig(s.pValue);
                var tailLabel = s.tail === 'two' ? 'Two-Tailed' : s.tail === 'right' ? 'Right-Tailed' : 'Left-Tailed';
                var lines = [];
                lines.push('\\textbf{P-Value Calculator}\\\\[4pt]');
                lines.push('\\text{Test: ' + s.test + '}\\\\');
                lines.push(s.statName + ' = ' + C.fmt(s.stat, 6) + '\\\\');
                if (s.dist === 't' || s.dist === 'chi') {
                    lines.push('df = ' + C.fmt(s.df, 0) + '\\\\');
                }
                if (s.dist === 'f') {
                    lines.push('df_1 = ' + C.fmt(s.df1, 0) + ',\\; df_2 = ' + C.fmt(s.df2, 0) + '\\\\');
                }
                lines.push('\\text{Tail: ' + tailLabel + '}\\\\[4pt]');
                lines.push('p = ' + s.pValue.toFixed(6) + '\\\\');
                lines.push('\\text{' + sig.label + (sig.stars ? ' ' + sig.stars : '') + '}');
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.results;
                if (!s) return null;
                var shared = { mode: state.mode, tail: state.tail };
                if (state.mode === 'z') {
                    shared.z = s.stat;
                } else if (state.mode === 't') {
                    shared.t = s.stat;
                    shared.df = s.df;
                } else if (state.mode === 'chi') {
                    shared.chi = s.stat;
                    shared.df = s.df;
                } else if (state.mode === 'f') {
                    shared.f = s.stat;
                    shared.df1 = s.df1;
                    shared.df2 = s.df2;
                }
                return shared;
            },
            resultEl: '#pv-result-content'
        });

        /* Queue graph if graph tab is active */
        var graphTab = document.querySelector('[data-tab="' + PREFIX + 'graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) renderGraph();

        /* Queue compiler if compiler tab is active */
        var compilerTab = document.querySelector('[data-tab="' + PREFIX + 'compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    function getInput(id) {
        var el = document.getElementById(id);
        return el ? el.value : '';
    }

    /* ===== Render Results ===== */

    function renderResults(r) {
        var sig = getSig(r.pValue);
        var tailLabel = r.tail === 'two' ? 'Two-Tailed' : r.tail === 'right' ? 'Right-Tailed' : 'Left-Tailed';

        var h = '';

        /* 1. P-Value Hero */
        var badgeColor = r.pValue < 0.05 ? '#10b981' : r.pValue < 0.10 ? '#f59e0b' : '#64748b';
        h += '<div class="stat-hero">';
        h += '<div class="stat-hero-value">p = ' + r.pValue.toFixed(6) + '</div>';
        h += '<div class="stat-hero-badge" style="color:' + badgeColor + '">' + sig.label + (sig.stars ? ' ' + sig.stars : '') + '</div>';
        h += '</div>';

        /* 2. Test Details section */
        var detailRows = [
            ['Test Type', r.test],
            [r.statName + ' Statistic', C.fmt(r.stat, 6)]
        ];
        if (r.dist === 't' || r.dist === 'chi') {
            detailRows.push(['Degrees of Freedom (df)', C.fmt(r.df, 0)]);
        }
        if (r.dist === 'f') {
            detailRows.push(['Numerator df (df1)', C.fmt(r.df1, 0)]);
            detailRows.push(['Denominator df (df2)', C.fmt(r.df2, 0)]);
        }
        detailRows.push(['Tail Type', tailLabel]);
        detailRows.push(['P-Value', r.pValue.toFixed(6)]);
        h += buildSection('Test Details', detailRows);

        /* 3. Significance Levels */
        var thresholds = [
            { alpha: 0.001, label: 'p < 0.001' },
            { alpha: 0.01,  label: 'p < 0.01' },
            { alpha: 0.05,  label: 'p < 0.05' },
            { alpha: 0.10,  label: 'p < 0.10' }
        ];
        var sigRows = [];
        for (var i = 0; i < thresholds.length; i++) {
            var pass = r.pValue < thresholds[i].alpha;
            var icon = pass ? '\u2714' : '\u2718';
            var color = pass ? '#10b981' : '#ef4444';
            sigRows.push([thresholds[i].label, '<span style="color:' + color + ';font-weight:600">' + icon + ' ' + (pass ? 'Yes' : 'No') + '</span>']);
        }
        h += buildSection('Significance Levels', sigRows);

        /* 4. Interpretation */
        var reject05 = r.pValue < 0.05;
        h += '<div class="stat-interpretation ' + sig.cls + '">';
        h += '<strong>Interpretation:</strong><br>';
        h += 'The p-value of <strong>' + r.pValue.toFixed(6) + '</strong> represents the probability of observing a test statistic ';
        if (r.tail === 'two') {
            h += 'as extreme as ' + r.statName + ' = ' + C.fmt(r.stat, 4) + ' (in either direction) ';
        } else if (r.tail === 'right') {
            h += 'as large as ' + r.statName + ' = ' + C.fmt(r.stat, 4) + ' ';
        } else {
            h += 'as small as ' + r.statName + ' = ' + C.fmt(r.stat, 4) + ' ';
        }
        h += 'under the null hypothesis.<br><br>';
        h += '<strong>Decision Rule:</strong> If \u03B1 = 0.05, you would <strong>';
        h += reject05 ? 'reject' : 'fail to reject';
        h += '</strong> H\u2080.';
        h += '</div>';

        /* 5. Step-by-step KaTeX formulas */
        h += buildSteps(r);

        els.resultContent.innerHTML = h;
        renderAllKaTeX();
    }

    /* ===== KaTeX Step Builder ===== */

    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        if (r.dist === 'normal') {
            h += step(1, 'Compute CDF',
                tex('\\Phi(z) = \\Phi(' + C.fmt(r.stat, 4) + ') = ' + C.fmt(window.jStat.normal.cdf(r.stat, 0, 1), 6)));
            if (r.tail === 'left') {
                h += step(2, 'Left-Tailed P-Value',
                    tex('p = \\Phi(z) = ' + r.pValue.toFixed(6)));
            } else if (r.tail === 'right') {
                h += step(2, 'Right-Tailed P-Value',
                    tex('p = 1 - \\Phi(z) = 1 - ' + C.fmt(window.jStat.normal.cdf(r.stat, 0, 1), 6) + ' = ' + r.pValue.toFixed(6)));
            } else {
                h += step(2, 'Two-Tailed Adjustment',
                    tex('p = 2 \\cdot \\min(\\Phi(z),\\; 1 - \\Phi(z)) = 2 \\cdot ' + C.fmt(Math.min(window.jStat.normal.cdf(r.stat, 0, 1), 1 - window.jStat.normal.cdf(r.stat, 0, 1)), 6)));
            }
            h += step(3, 'Final P-Value', tex('p = ' + r.pValue.toFixed(6)));

        } else if (r.dist === 't') {
            h += step(1, 'Compute CDF',
                tex('F_t(t, df) = F_t(' + C.fmt(r.stat, 4) + ',\\; ' + C.fmt(r.df, 0) + ') = ' + C.fmt(window.jStat.studentt.cdf(r.stat, r.df), 6)));
            if (r.tail === 'left') {
                h += step(2, 'Left-Tailed P-Value',
                    tex('p = F_t(t, df) = ' + r.pValue.toFixed(6)));
            } else if (r.tail === 'right') {
                h += step(2, 'Right-Tailed P-Value',
                    tex('p = 1 - F_t(t, df) = ' + r.pValue.toFixed(6)));
            } else {
                h += step(2, 'Two-Tailed Adjustment',
                    tex('p = 2 \\cdot \\min(F_t(t, df),\\; 1 - F_t(t, df))'));
            }
            h += step(3, 'Final P-Value', tex('p = ' + r.pValue.toFixed(6)));

        } else if (r.dist === 'chi') {
            h += step(1, 'Compute CDF',
                tex('F_{\\chi^2}(x, df) = F_{\\chi^2}(' + C.fmt(r.stat, 4) + ',\\; ' + C.fmt(r.df, 0) + ') = ' + C.fmt(window.jStat.chisquare.cdf(r.stat, r.df), 6)));
            h += step(2, 'Right-Tailed P-Value (always)',
                tex('p = 1 - F_{\\chi^2}(x, df) = 1 - ' + C.fmt(window.jStat.chisquare.cdf(r.stat, r.df), 6)));
            h += step(3, 'Final P-Value', tex('p = ' + r.pValue.toFixed(6)));

        } else if (r.dist === 'f') {
            h += step(1, 'Compute CDF',
                tex('F_F(x, df_1, df_2) = F_F(' + C.fmt(r.stat, 4) + ',\\; ' + C.fmt(r.df1, 0) + ',\\; ' + C.fmt(r.df2, 0) + ') = ' + C.fmt(window.jStat.centralF.cdf(r.stat, r.df1, r.df2), 6)));
            h += step(2, 'Right-Tailed P-Value (always)',
                tex('p = 1 - F_F(x, df_1, df_2) = 1 - ' + C.fmt(window.jStat.centralF.cdf(r.stat, r.df1, r.df2), 6)));
            h += step(3, 'Final P-Value', tex('p = ' + r.pValue.toFixed(6)));
        }

        return h + '</div>';
    }

    /* ===== Shared HTML Builders ===== */

    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function step(num, title, content) {
        return '<div class="stat-step"><div class="stat-step-number">' + num + '</div><div class="stat-step-content"><strong>' + title + '</strong><div style="margin-top:0.25rem">' + content + '</div></div></div>';
    }

    function tex(expr) {
        return '<span class="stat-katex" data-tex="' + expr.replace(/"/g, '&quot;') + '"></span>';
    }

    function renderAllKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var t = spans[i].getAttribute('data-tex');
            if (t && window.katex) {
                try { window.katex.render(t, spans[i], { throwOnError: false }); } catch (e) {}
            }
        }
    }

    /* ===== Graph ===== */

    function renderGraph() {
        if (!state.results) return;
        G.loadPlotly(function() {
            G.loadJStat(function() {
                drawGraph();
            });
        });
    }

    function drawGraph() {
        var r = state.results;
        var container = els.graphContainer;
        if (!container) return;
        container.innerHTML = '';

        var colors = G.getPlotColors();
        var traces = [];
        var xVals = [], yVals = [];
        var nPts = 400;
        var title = '';

        if (r.dist === 'normal') {
            /* Z: standard normal bell curve from -4 to 4 */
            var lo = -4, hi = 4;
            for (var i = 0; i <= nPts; i++) {
                var x = lo + (hi - lo) * i / nPts;
                xVals.push(x);
                yVals.push(window.jStat.normal.pdf(x, 0, 1));
            }
            title = 'Standard Normal Distribution (Z-Test)';

            /* Main curve */
            traces.push({
                x: xVals, y: yVals, type: 'scatter', mode: 'lines',
                line: { color: colors.accent, width: 2 },
                name: 'N(0, 1)', fill: 'none'
            });

            /* Shaded rejection region(s) */
            if (r.tail === 'left') {
                traces.push(shadedNormal(lo, r.stat, nPts, colors.primaryFill));
            } else if (r.tail === 'right') {
                traces.push(shadedNormal(r.stat, hi, nPts, colors.primaryFill));
            } else {
                traces.push(shadedNormal(lo, -Math.abs(r.stat), nPts, colors.primaryFill));
                traces.push(shadedNormal(Math.abs(r.stat), hi, nPts, colors.primaryFill));
            }

            /* Test statistic vertical line */
            var zPdf = window.jStat.normal.pdf(r.stat, 0, 1);
            traces.push({
                x: [r.stat, r.stat], y: [0, zPdf], type: 'scatter', mode: 'lines',
                line: { color: '#10b981', width: 3 },
                name: 'Z = ' + C.fmt(r.stat, 4)
            });

        } else if (r.dist === 't') {
            /* t-distribution bell curve from -4 to 4 */
            var lo = -4, hi = 4;
            for (var i = 0; i <= nPts; i++) {
                var x = lo + (hi - lo) * i / nPts;
                xVals.push(x);
                yVals.push(window.jStat.studentt.pdf(x, r.df));
            }
            title = 't-Distribution (df = ' + C.fmt(r.df, 0) + ')';

            traces.push({
                x: xVals, y: yVals, type: 'scatter', mode: 'lines',
                line: { color: colors.accent, width: 2 },
                name: 't(' + C.fmt(r.df, 0) + ')', fill: 'none'
            });

            if (r.tail === 'left') {
                traces.push(shadedT(lo, r.stat, r.df, nPts, colors.primaryFill));
            } else if (r.tail === 'right') {
                traces.push(shadedT(r.stat, hi, r.df, nPts, colors.primaryFill));
            } else {
                traces.push(shadedT(lo, -Math.abs(r.stat), r.df, nPts, colors.primaryFill));
                traces.push(shadedT(Math.abs(r.stat), hi, r.df, nPts, colors.primaryFill));
            }

            var tPdf = window.jStat.studentt.pdf(r.stat, r.df);
            traces.push({
                x: [r.stat, r.stat], y: [0, tPdf], type: 'scatter', mode: 'lines',
                line: { color: '#10b981', width: 3 },
                name: 't = ' + C.fmt(r.stat, 4)
            });

        } else if (r.dist === 'chi') {
            /* Chi-square from 0 to max */
            var maxX = Math.max(r.stat * 2, r.df + 4 * Math.sqrt(2 * r.df));
            maxX = Math.max(maxX, 10);
            for (var i = 0; i <= nPts; i++) {
                var x = 0.01 + (maxX - 0.01) * i / nPts;
                xVals.push(x);
                yVals.push(window.jStat.chisquare.pdf(x, r.df));
            }
            title = '\u03C7\u00B2 Distribution (df = ' + C.fmt(r.df, 0) + ')';

            traces.push({
                x: xVals, y: yVals, type: 'scatter', mode: 'lines',
                line: { color: colors.accent, width: 2 },
                name: '\u03C7\u00B2(' + C.fmt(r.df, 0) + ')', fill: 'none'
            });

            /* Shade right tail beyond test statistic */
            traces.push(shadedChi(r.stat, maxX, r.df, nPts, colors.primaryFill));

            var chiPdf = window.jStat.chisquare.pdf(r.stat, r.df);
            traces.push({
                x: [r.stat, r.stat], y: [0, chiPdf], type: 'scatter', mode: 'lines',
                line: { color: '#10b981', width: 3 },
                name: '\u03C7\u00B2 = ' + C.fmt(r.stat, 4)
            });

        } else if (r.dist === 'f') {
            /* F-distribution from 0 to max */
            var maxX = Math.max(r.stat * 2.5, 5);
            maxX = Math.max(maxX, 8);
            for (var i = 0; i <= nPts; i++) {
                var x = 0.01 + (maxX - 0.01) * i / nPts;
                xVals.push(x);
                yVals.push(window.jStat.centralF.pdf(x, r.df1, r.df2));
            }
            title = 'F-Distribution (df1 = ' + C.fmt(r.df1, 0) + ', df2 = ' + C.fmt(r.df2, 0) + ')';

            traces.push({
                x: xVals, y: yVals, type: 'scatter', mode: 'lines',
                line: { color: colors.accent, width: 2 },
                name: 'F(' + C.fmt(r.df1, 0) + ', ' + C.fmt(r.df2, 0) + ')', fill: 'none'
            });

            /* Shade right tail beyond test statistic */
            traces.push(shadedF(r.stat, maxX, r.df1, r.df2, nPts, colors.primaryFill));

            var fPdf = window.jStat.centralF.pdf(r.stat, r.df1, r.df2);
            traces.push({
                x: [r.stat, r.stat], y: [0, fPdf], type: 'scatter', mode: 'lines',
                line: { color: '#10b981', width: 3 },
                name: 'F = ' + C.fmt(r.stat, 4)
            });
        }

        var layout = {
            title: { text: title, font: { color: colors.text, size: 14 } },
            xaxis: { title: r.statName + ' value', zeroline: true, gridcolor: colors.grid, color: colors.text },
            yaxis: { title: 'Density', rangemode: 'tozero', gridcolor: colors.grid, color: colors.text },
            showlegend: true,
            legend: { orientation: 'h', y: -0.25, font: { color: colors.text } },
            margin: { t: 50, b: 70, l: 50, r: 30 },
            height: 360,
            paper_bgcolor: colors.paper,
            plot_bgcolor: colors.bg,
            font: { color: colors.text }
        };

        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    /* Shaded region helpers */

    function shadedNormal(lo, hi, nPts, fillColor) {
        var xs = [], ys = [];
        var pts = Math.min(nPts, 100);
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(window.jStat.normal.pdf(x, 0, 1));
        }
        return { x: xs, y: ys, type: 'scatter', mode: 'lines', fill: 'tozeroy', fillcolor: fillColor, line: { color: 'transparent', width: 0 }, showlegend: false };
    }

    function shadedT(lo, hi, df, nPts, fillColor) {
        var xs = [], ys = [];
        var pts = Math.min(nPts, 100);
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(window.jStat.studentt.pdf(x, df));
        }
        return { x: xs, y: ys, type: 'scatter', mode: 'lines', fill: 'tozeroy', fillcolor: fillColor, line: { color: 'transparent', width: 0 }, showlegend: false };
    }

    function shadedChi(lo, hi, df, nPts, fillColor) {
        var xs = [], ys = [];
        var pts = Math.min(nPts, 100);
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(window.jStat.chisquare.pdf(x, df));
        }
        return { x: xs, y: ys, type: 'scatter', mode: 'lines', fill: 'tozeroy', fillcolor: fillColor, line: { color: 'transparent', width: 0 }, showlegend: false };
    }

    function shadedF(lo, hi, df1, df2, nPts, fillColor) {
        var xs = [], ys = [];
        var pts = Math.min(nPts, 100);
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(window.jStat.centralF.pdf(x, df1, df2));
        }
        return { x: xs, y: ys, type: 'scatter', mode: 'lines', fill: 'tozeroy', fillcolor: fillColor, line: { color: 'transparent', width: 0 }, showlegend: false };
    }

    /* ===== Python Compiler ===== */

    function loadCompiler() {
        if (!state.results) return;
        var code = preparePython(state.results);
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    function preparePython(r) {
        var lines = ['from scipy import stats', ''];

        if (r.dist === 'normal') {
            lines.push('# Z-Test P-Value Calculator');
            lines.push('z = ' + C.fmt(r.stat, 6));
            lines.push('');
            lines.push('p_two = 2 * (1 - stats.norm.cdf(abs(z)))');
            lines.push('p_left = stats.norm.cdf(z)');
            lines.push('p_right = 1 - stats.norm.cdf(z)');
            lines.push('');
            lines.push('print(f"Z = {z}")');
            lines.push('print(f"Two-tailed p = {p_two:.6f}")');
            lines.push('print(f"Left-tailed p = {p_left:.6f}")');
            lines.push('print(f"Right-tailed p = {p_right:.6f}")');

        } else if (r.dist === 't') {
            lines.push('# T-Test P-Value Calculator');
            lines.push('t = ' + C.fmt(r.stat, 6));
            lines.push('df = ' + C.fmt(r.df, 0));
            lines.push('');
            lines.push('p_two = 2 * (1 - stats.t.cdf(abs(t), df))');
            lines.push('p_left = stats.t.cdf(t, df)');
            lines.push('p_right = 1 - stats.t.cdf(t, df)');
            lines.push('');
            lines.push('print(f"t = {t}, df = {df}")');
            lines.push('print(f"Two-tailed p = {p_two:.6f}")');
            lines.push('print(f"Left-tailed p = {p_left:.6f}")');
            lines.push('print(f"Right-tailed p = {p_right:.6f}")');

        } else if (r.dist === 'chi') {
            lines.push('# Chi-Square P-Value Calculator');
            lines.push('chi2 = ' + C.fmt(r.stat, 6));
            lines.push('df = ' + C.fmt(r.df, 0));
            lines.push('');
            lines.push('p = 1 - stats.chi2.cdf(chi2, df)');
            lines.push('');
            lines.push('print(f"Chi-Square = {chi2}, df = {df}")');
            lines.push('print(f"P-value (right-tailed) = {p:.6f}")');

        } else if (r.dist === 'f') {
            lines.push('# F-Test P-Value Calculator');
            lines.push('f = ' + C.fmt(r.stat, 6));
            lines.push('df1 = ' + C.fmt(r.df1, 0));
            lines.push('df2 = ' + C.fmt(r.df2, 0));
            lines.push('');
            lines.push('p = 1 - stats.f.cdf(f, df1, df2)');
            lines.push('');
            lines.push('print(f"F = {f}, df1 = {df1}, df2 = {df2}")');
            lines.push('print(f"P-value (right-tailed) = {p:.6f}")');
        }

        return lines.join('\n');
    }

    /* ===== Clear ===== */

    function clearAll() {
        C.showEmpty(els.resultContent, '&#x1F4CA;', 'No Result Yet', 'Enter a test statistic and click Calculate');
        E.hideActionButtons(els.resultActions);
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
        if (els.graphContainer) els.graphContainer.innerHTML = '';
        state.results = null;

        /* Clear all inputs across panels */
        var inputs = document.querySelectorAll(
            '#' + PREFIX + 'input-z input, #' + PREFIX + 'input-t input, ' +
            '#' + PREFIX + 'input-chi input, #' + PREFIX + 'input-f input'
        );
        for (var i = 0; i < inputs.length; i++) inputs[i].value = '';
    }

    /* ===== Example Application ===== */

    function applyExample(key) {
        var ex = EXAMPLES[key];
        if (!ex) return;

        setMode(ex.mode);

        if (ex.tail) {
            state.tail = ex.tail;
            updateTailButtons();
        }

        if (ex.mode === 'z') {
            setInput(PREFIX + 'z-score', ex.z);
        } else if (ex.mode === 't') {
            setInput(PREFIX + 't-stat', ex.t);
            setInput(PREFIX + 't-df', ex.df);
        } else if (ex.mode === 'chi') {
            setInput(PREFIX + 'chi-stat', ex.chi);
            setInput(PREFIX + 'chi-df', ex.df);
        } else if (ex.mode === 'f') {
            setInput(PREFIX + 'f-stat', ex.f);
            setInput(PREFIX + 'f-df1', ex.df1);
            setInput(PREFIX + 'f-df2', ex.df2);
        }

        calculate();
    }

    function setInput(id, val) {
        var el = document.getElementById(id);
        if (el) el.value = val;
    }

    /* ===== FAQ Accordion ===== */

    function initFAQ() {
        var questions = document.querySelectorAll('.stat-faq-question');
        for (var i = 0; i < questions.length; i++) {
            questions[i].addEventListener('click', function() {
                var answer = this.nextElementSibling;
                var isOpen = this.classList.contains('active');
                /* Close all */
                document.querySelectorAll('.stat-faq-question').forEach(function(q) {
                    q.classList.remove('active');
                    if (q.nextElementSibling) q.nextElementSibling.style.maxHeight = null;
                });
                /* Toggle current */
                if (!isOpen) {
                    this.classList.add('active');
                    if (answer) answer.style.maxHeight = answer.scrollHeight + 'px';
                }
            });
        }
    }

    /* ===== Scroll Reveal ===== */

    function initScrollReveal() {
        if (!('IntersectionObserver' in window)) {
            var animEls = document.querySelectorAll('.stat-anim');
            for (var i = 0; i < animEls.length; i++) animEls[i].classList.add('stat-visible');
            return;
        }
        var observer = new IntersectionObserver(function(entries) {
            for (var i = 0; i < entries.length; i++) {
                if (entries[i].isIntersecting) {
                    entries[i].target.classList.add('stat-visible');
                    observer.unobserve(entries[i].target);
                }
            }
        }, { threshold: 0.1 });
        var animEls = document.querySelectorAll('.stat-anim');
        for (var j = 0; j < animEls.length; j++) observer.observe(animEls[j]);
    }

    /* ===== Restore from shared URL ===== */

    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        setMode(shared.mode);

        if (shared.tail) {
            state.tail = shared.tail;
            updateTailButtons();
        }

        if (shared.mode === 'z') {
            if (shared.z != null) setInput(PREFIX + 'z-score', shared.z);
        } else if (shared.mode === 't') {
            if (shared.t != null) setInput(PREFIX + 't-stat', shared.t);
            if (shared.df != null) setInput(PREFIX + 't-df', shared.df);
        } else if (shared.mode === 'chi') {
            if (shared.chi != null) setInput(PREFIX + 'chi-stat', shared.chi);
            if (shared.df != null) setInput(PREFIX + 'chi-df', shared.df);
        } else if (shared.mode === 'f') {
            if (shared.f != null) setInput(PREFIX + 'f-stat', shared.f);
            if (shared.df1 != null) setInput(PREFIX + 'f-df1', shared.df1);
            if (shared.df2 != null) setInput(PREFIX + 'f-df2', shared.df2);
        }

        return true;
    }

    /* ===== Init ===== */

    function init() {
        initDOM();
        initTabs();
        initModes();
        initTailToggle();
        initFAQ();
        initScrollReveal();

        if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
        if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

        /* Enter key on inputs triggers calculate */
        var inputs = document.querySelectorAll(
            '#' + PREFIX + 'input-z input, #' + PREFIX + 'input-t input, ' +
            '#' + PREFIX + 'input-chi input, #' + PREFIX + 'input-f input'
        );
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        /* Example chips */
        var exContainer = document.getElementById(PREFIX + 'examples');
        if (exContainer) {
            var chips = exContainer.querySelectorAll('[data-example]');
            for (var j = 0; j < chips.length; j++) {
                chips[j].addEventListener('click', function() {
                    applyExample(this.getAttribute('data-example'));
                });
            }
        }

        /* Set initial mode and tail */
        setMode('z');
        updateTailButtons();

        /* Show empty state */
        C.showEmpty(els.resultContent, '&#x1F4CA;', 'No Result Yet', 'Enter a test statistic and click Calculate');

        /* Restore from shared URL or auto-calculate default example */
        var restored = restoreFromUrl();
        G.loadJStat(function() {
            if (restored) {
                calculate();
            } else {
                applyExample('z-critical');
            }
        });
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
