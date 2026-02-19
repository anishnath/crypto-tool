/**
 * T-Test Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for t-distribution p-values and critical values.
 * Uses Plotly (lazy-loaded) for t-distribution curve visualization.
 *
 * Modes: one-sample, two-sample (equal var), paired, welch (unequal var)
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'one',       // one | two | paired | welch
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('tt-result-content');
        els.resultActions  = document.getElementById('tt-result-actions');
        els.graphPanel     = document.getElementById('tt-graph-panel');
        els.graphContainer = document.getElementById('tt-graph-container');
        els.compilerPanel  = document.getElementById('tt-compiler-panel');
        els.compilerIframe = document.getElementById('tt-compiler-iframe');
        els.calcBtn        = document.getElementById('tt-calc-btn');
        els.clearBtn       = document.getElementById('tt-clear-btn');

        els.modeOne    = document.getElementById('tt-mode-one');
        els.modeTwo    = document.getElementById('tt-mode-two');
        els.modePaired = document.getElementById('tt-mode-paired');
        els.modeWelch  = document.getElementById('tt-mode-welch');

        els.panelOne    = document.getElementById('tt-input-one');
        els.panelTwo    = document.getElementById('tt-input-two');
        els.panelPaired = document.getElementById('tt-input-paired');
        els.panelWelch  = document.getElementById('tt-input-welch');
    }

    /* ===== Inline Helpers ===== */
    function mean(arr) {
        var s = 0;
        for (var i = 0; i < arr.length; i++) s += arr[i];
        return s / arr.length;
    }

    function variance(arr, ddof) {
        var m = mean(arr);
        var ss = 0;
        for (var i = 0; i < arr.length; i++) ss += (arr[i] - m) * (arr[i] - m);
        return ss / (arr.length - (ddof || 0));
    }

    function stddev(arr, ddof) {
        return Math.sqrt(variance(arr, ddof));
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
                if (target === 'tt-graph-panel') loadGraph();
                if (target === 'tt-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeOne.addEventListener('click', function() { setMode('one'); });
        els.modeTwo.addEventListener('click', function() { setMode('two'); });
        els.modePaired.addEventListener('click', function() { setMode('paired'); });
        els.modeWelch.addEventListener('click', function() { setMode('welch'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeOne.classList.toggle('active', m === 'one');
        els.modeTwo.classList.toggle('active', m === 'two');
        els.modePaired.classList.toggle('active', m === 'paired');
        els.modeWelch.classList.toggle('active', m === 'welch');
        els.panelOne.style.display    = m === 'one' ? '' : 'none';
        els.panelTwo.style.display    = m === 'two' ? '' : 'none';
        els.panelPaired.style.display = m === 'paired' ? '' : 'none';
        els.panelWelch.style.display  = m === 'welch' ? '' : 'none';
    }

    /* ===== Read Shared Controls ===== */
    function getAlpha() {
        var el = document.getElementById('tt-alpha');
        return el ? parseFloat(el.value) : 0.05;
    }

    function getTail() {
        var el = document.getElementById('tt-tail');
        return el ? el.value : 'two';
    }

    /* ===== P-value & Critical Value ===== */
    function pValue(t, df, tail) {
        if (!window.jStat) return NaN;
        var cdf = window.jStat.studentt.cdf(t, df);
        if (tail === 'two')   return 2 * (1 - window.jStat.studentt.cdf(Math.abs(t), df));
        if (tail === 'right') return 1 - cdf;
        /* left */ return cdf;
    }

    function criticalValue(alpha, df, tail) {
        if (!window.jStat) return NaN;
        if (tail === 'two') return window.jStat.studentt.inv(1 - alpha / 2, df);
        return window.jStat.studentt.inv(1 - alpha, df);
    }

    /* ===== Cohen's d Interpretation ===== */
    function cohenLabel(d) {
        var a = Math.abs(d);
        if (a < 0.2)  return 'Negligible';
        if (a < 0.5)  return 'Small';
        if (a < 0.8)  return 'Medium';
        return 'Large';
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var alpha = getAlpha();
        var tail  = getTail();
        var r;

        if (state.mode === 'one') {
            var data = C.parseNumbers(document.getElementById('tt-one-data').value);
            var mu0  = parseFloat(document.getElementById('tt-one-mu').value);
            if (data.length < 2) { C.showError(els.resultContent, 'Enter at least 2 data values.'); return; }
            if (isNaN(mu0)) { C.showError(els.resultContent, 'Enter a valid population mean.'); return; }
            var n = data.length, xbar = mean(data), s = stddev(data, 1);
            var se = s / Math.sqrt(n);
            var t = (xbar - mu0) / se;
            var df = n - 1;
            var p = pValue(t, df, tail);
            var tCrit = criticalValue(alpha, df, tail);
            var margin = criticalValue(alpha, df, 'two') * se;
            var ciLo = xbar - margin, ciHi = xbar + margin;
            var d = (xbar - mu0) / s;
            r = { mode: 'one', data: data, mu0: mu0, n: n, xbar: xbar, s: s, se: se, t: t, df: df, p: p, tCrit: tCrit, alpha: alpha, tail: tail, ciLo: ciLo, ciHi: ciHi, cohenD: d, estimate: xbar, margin: margin };

        } else if (state.mode === 'two') {
            var d1 = C.parseNumbers(document.getElementById('tt-two-data1').value);
            var d2 = C.parseNumbers(document.getElementById('tt-two-data2').value);
            if (d1.length < 2) { C.showError(els.resultContent, 'Enter at least 2 values for Sample 1.'); return; }
            if (d2.length < 2) { C.showError(els.resultContent, 'Enter at least 2 values for Sample 2.'); return; }
            var n1 = d1.length, n2 = d2.length;
            var x1 = mean(d1), x2 = mean(d2);
            var s1 = stddev(d1, 1), s2 = stddev(d2, 1);
            var pooledVar = ((n1 - 1) * s1 * s1 + (n2 - 1) * s2 * s2) / (n1 + n2 - 2);
            var se = Math.sqrt(pooledVar * (1 / n1 + 1 / n2));
            var t = (x1 - x2) / se;
            var df = n1 + n2 - 2;
            var p = pValue(t, df, tail);
            var tCrit = criticalValue(alpha, df, tail);
            var pooledSd = Math.sqrt(pooledVar);
            var d = (x1 - x2) / pooledSd;
            var margin = criticalValue(alpha, df, 'two') * se;
            var ciLo = (x1 - x2) - margin, ciHi = (x1 - x2) + margin;
            r = { mode: 'two', d1: d1, d2: d2, n1: n1, n2: n2, x1: x1, x2: x2, s1: s1, s2: s2, pooledVar: pooledVar, se: se, t: t, df: df, p: p, tCrit: tCrit, alpha: alpha, tail: tail, ciLo: ciLo, ciHi: ciHi, cohenD: d, estimate: x1 - x2, margin: margin };

        } else if (state.mode === 'paired') {
            var before = C.parseNumbers(document.getElementById('tt-paired-before').value);
            var after  = C.parseNumbers(document.getElementById('tt-paired-after').value);
            if (before.length < 2) { C.showError(els.resultContent, 'Enter at least 2 values for Before.'); return; }
            if (before.length !== after.length) { C.showError(els.resultContent, 'Before and After must have the same number of values.'); return; }
            var diffs = [];
            for (var i = 0; i < before.length; i++) diffs.push(before[i] - after[i]);
            var n = diffs.length, dbar = mean(diffs), sd = stddev(diffs, 1);
            var se = sd / Math.sqrt(n);
            var t = dbar / se;
            var df = n - 1;
            var p = pValue(t, df, tail);
            var tCrit = criticalValue(alpha, df, tail);
            var d = dbar / sd;
            var margin = criticalValue(alpha, df, 'two') * se;
            var ciLo = dbar - margin, ciHi = dbar + margin;
            r = { mode: 'paired', before: before, after: after, diffs: diffs, n: n, dbar: dbar, sd: sd, se: se, t: t, df: df, p: p, tCrit: tCrit, alpha: alpha, tail: tail, ciLo: ciLo, ciHi: ciHi, cohenD: d, estimate: dbar, margin: margin };

        } else {
            /* welch */
            var d1 = C.parseNumbers(document.getElementById('tt-welch-data1').value);
            var d2 = C.parseNumbers(document.getElementById('tt-welch-data2').value);
            if (d1.length < 2) { C.showError(els.resultContent, 'Enter at least 2 values for Sample 1.'); return; }
            if (d2.length < 2) { C.showError(els.resultContent, 'Enter at least 2 values for Sample 2.'); return; }
            var n1 = d1.length, n2 = d2.length;
            var x1 = mean(d1), x2 = mean(d2);
            var s1 = stddev(d1, 1), s2 = stddev(d2, 1);
            var se = Math.sqrt(s1 * s1 / n1 + s2 * s2 / n2);
            var t = (x1 - x2) / se;
            var v1 = s1 * s1 / n1, v2 = s2 * s2 / n2;
            var df = (v1 + v2) * (v1 + v2) / (v1 * v1 / (n1 - 1) + v2 * v2 / (n2 - 1));
            var p = pValue(t, df, tail);
            var tCrit = criticalValue(alpha, df, tail);
            var pooledSd = Math.sqrt(((n1 - 1) * s1 * s1 + (n2 - 1) * s2 * s2) / (n1 + n2 - 2));
            var d = (x1 - x2) / pooledSd;
            var margin = criticalValue(alpha, df, 'two') * se;
            var ciLo = (x1 - x2) - margin, ciHi = (x1 - x2) + margin;
            r = { mode: 'welch', d1: d1, d2: d2, n1: n1, n2: n2, x1: x1, x2: x2, s1: s1, s2: s2, se: se, t: t, df: df, p: p, tCrit: tCrit, alpha: alpha, tail: tail, ciLo: ciLo, ciHi: ciHi, cohenD: d, estimate: x1 - x2, margin: margin };
        }

        state.result = r;
        renderResult(r);

        E.renderActionButtons(els.resultActions, {
            toolName: 'T-Test Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                var tailLabel = s.tail === 'two' ? 'Two-Tailed' : s.tail === 'right' ? 'Right-Tailed' : 'Left-Tailed';
                lines.push('\\textbf{T-Test Calculator}\\\\[4pt]');
                lines.push('\\text{Mode: ' + s.mode + ', ' + tailLabel + '}\\\\[2pt]');
                lines.push('t = ' + C.fmt(s.t, 4) + '\\\\');
                lines.push('df = ' + C.fmt(s.df, 4) + '\\\\');
                lines.push('p = ' + C.fmt(s.p, 6) + '\\\\');
                lines.push('\\alpha = ' + s.alpha + '\\\\');
                lines.push('t_{\\text{crit}} = ' + C.fmt(s.tCrit, 4) + '\\\\');
                lines.push('\\text{CI}_{' + C.fmt((1 - s.alpha) * 100, 0) + '\\%} = [' + C.fmt(s.ciLo, 4) + ',\\,' + C.fmt(s.ciHi, 4) + ']\\\\');
                lines.push("d_{\\text{Cohen}} = " + C.fmt(s.cohenD, 4) + '\\\\');
                if (s.mode === 'one') {
                    lines.push('n = ' + s.n + '\\\\');
                    lines.push('\\bar{x} = ' + C.fmt(s.xbar, 4) + '\\\\');
                    lines.push('s = ' + C.fmt(s.s, 4) + '\\\\');
                    lines.push('\\mu_0 = ' + s.mu0);
                } else if (s.mode === 'paired') {
                    lines.push('n = ' + s.n + '\\\\');
                    lines.push('\\bar{d} = ' + C.fmt(s.dbar, 4) + '\\\\');
                    lines.push('s_d = ' + C.fmt(s.sd, 4));
                } else {
                    lines.push('n_1 = ' + s.n1 + ',\\; n_2 = ' + s.n2 + '\\\\');
                    lines.push('\\bar{x}_1 = ' + C.fmt(s.x1, 4) + ',\\; \\bar{x}_2 = ' + C.fmt(s.x2, 4) + '\\\\');
                    lines.push('s_1 = ' + C.fmt(s.s1, 4) + ',\\; s_2 = ' + C.fmt(s.s2, 4));
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: s.mode, alpha: s.alpha, tail: s.tail };
                if (s.mode === 'one') {
                    shared.data = s.data.join(', ');
                    shared.mu0 = s.mu0;
                } else if (s.mode === 'two') {
                    shared.d1 = s.d1.join(', ');
                    shared.d2 = s.d2.join(', ');
                } else if (s.mode === 'paired') {
                    shared.before = s.before.join(', ');
                    shared.after = s.after.join(', ');
                } else {
                    shared.d1 = s.d1.join(', ');
                    shared.d2 = s.d2.join(', ');
                }
                return shared;
            },
            resultEl: '#tt-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="tt-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="tt-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    /* ===== Render Result ===== */
    function renderResult(r) {
        var sig = r.p < r.alpha;
        var sigBadge = sig
            ? '<span class="stat-badge stat-badge-success">Significant</span>'
            : '<span class="stat-badge stat-badge-muted">Not Significant</span>';

        var tailLabel = r.tail === 'two' ? 'Two-Tailed' : r.tail === 'right' ? 'Right-Tailed' : 'Left-Tailed';

        var h = '<div class="stat-hero"><span class="stat-hero-value">t = ' + C.fmt(r.t, 4) + '</span>' + sigBadge + '<span class="stat-hero-label">' + tailLabel + ' T-Test</span></div>';

        /* Test Results section */
        h += buildSection('Test Results', [
            ['t-Statistic', C.fmt(r.t, 4)],
            ['Degrees of Freedom (df)', C.fmt(r.df, 4)],
            ['p-Value', C.fmt(r.p, 6)],
            ['Significance Level (\u03B1)', r.alpha],
            ['Critical Value (t)', C.fmt(r.tCrit, 4)],
            ['Tail', tailLabel]
        ]);

        /* Confidence Interval section */
        h += buildSection('Confidence Interval (' + C.fmt((1 - r.alpha) * 100, 0) + '%)', [
            ['Lower Bound', C.fmt(r.ciLo, 4)],
            ['Upper Bound', C.fmt(r.ciHi, 4)],
            ['Margin of Error', C.fmt(r.margin, 4)]
        ]);

        /* Effect Size section */
        h += buildSection('Effect Size', [
            ["Cohen's d", C.fmt(r.cohenD, 4)],
            ['Interpretation', cohenLabel(r.cohenD)]
        ]);

        /* Sample Statistics section */
        h += renderSampleStats(r);

        /* KaTeX formula steps */
        h += buildSteps(r);

        /* Interpretation */
        var h0Desc = getH0Description(r);
        if (sig) {
            h += '<div class="stat-interpretation stat-interpretation-success"><strong>Reject H\u2080:</strong> ' + h0Desc + ' The p-value (' + C.fmt(r.p, 6) + ') is less than \u03B1 = ' + r.alpha + ', providing sufficient evidence against the null hypothesis.</div>';
        } else {
            h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Fail to Reject H\u2080:</strong> ' + h0Desc + ' The p-value (' + C.fmt(r.p, 6) + ') is greater than \u03B1 = ' + r.alpha + ', so there is insufficient evidence against the null hypothesis.</div>';
        }

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    function getH0Description(r) {
        if (r.mode === 'one')    return 'H\u2080: \u03BC = ' + r.mu0 + '.';
        if (r.mode === 'paired') return 'H\u2080: Mean difference = 0.';
        return 'H\u2080: \u03BC\u2081 = \u03BC\u2082.';
    }

    function renderSampleStats(r) {
        if (r.mode === 'one') {
            return buildSection('Sample Statistics', [
                ['n', r.n],
                ['Mean (\u0078\u0304)', C.fmt(r.xbar, 4)],
                ['Std Dev (s)', C.fmt(r.s, 4)],
                ['Std Error (SE)', C.fmt(r.se, 6)],
                ['Population Mean (\u03BC\u2080)', r.mu0]
            ]);
        }
        if (r.mode === 'paired') {
            return buildSection('Sample Statistics', [
                ['n (pairs)', r.n],
                ['Mean Difference (\u0064\u0304)', C.fmt(r.dbar, 4)],
                ['SD of Differences', C.fmt(r.sd, 4)],
                ['Std Error (SE)', C.fmt(r.se, 6)]
            ]);
        }
        /* two or welch */
        return buildSection('Sample Statistics', [
            ['n\u2081', r.n1],
            ['Mean \u0078\u0304\u2081', C.fmt(r.x1, 4)],
            ['SD s\u2081', C.fmt(r.s1, 4)],
            ['n\u2082', r.n2],
            ['Mean \u0078\u0304\u2082', C.fmt(r.x2, 4)],
            ['SD s\u2082', C.fmt(r.s2, 4)],
            ['Std Error (SE)', C.fmt(r.se, 6)]
        ]);
    }

    /* ===== KaTeX Steps ===== */
    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        if (r.mode === 'one') {
            h += step(1, 'Standard Error', tex('SE = \\frac{s}{\\sqrt{n}} = \\frac{' + C.fmt(r.s, 4) + '}{\\sqrt{' + r.n + '}} = ' + C.fmt(r.se, 6)));
            h += step(2, 't-Statistic', tex('t = \\frac{\\bar{x} - \\mu_0}{SE} = \\frac{' + C.fmt(r.xbar, 4) + ' - ' + r.mu0 + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.t, 4)));
            h += step(3, 'Degrees of Freedom', tex('df = n - 1 = ' + r.n + ' - 1 = ' + C.fmt(r.df, 0)));
            h += step(4, 'p-Value', tex('p = ' + C.fmt(r.p, 6)));
            h += step(5, "Cohen's d", tex('d = \\frac{\\bar{x} - \\mu_0}{s} = \\frac{' + C.fmt(r.xbar, 4) + ' - ' + r.mu0 + '}{' + C.fmt(r.s, 4) + '} = ' + C.fmt(r.cohenD, 4)));
        } else if (r.mode === 'two') {
            h += step(1, 'Pooled Variance', tex('s_p^2 = \\frac{(n_1-1)s_1^2 + (n_2-1)s_2^2}{n_1+n_2-2} = ' + C.fmt(r.pooledVar, 4)));
            h += step(2, 'Standard Error', tex('SE = \\sqrt{s_p^2\\left(\\frac{1}{n_1}+\\frac{1}{n_2}\\right)} = ' + C.fmt(r.se, 6)));
            h += step(3, 't-Statistic', tex('t = \\frac{\\bar{x}_1 - \\bar{x}_2}{SE} = \\frac{' + C.fmt(r.x1, 4) + ' - ' + C.fmt(r.x2, 4) + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.t, 4)));
            h += step(4, 'Degrees of Freedom', tex('df = n_1 + n_2 - 2 = ' + r.n1 + ' + ' + r.n2 + ' - 2 = ' + C.fmt(r.df, 0)));
            h += step(5, 'p-Value', tex('p = ' + C.fmt(r.p, 6)));
        } else if (r.mode === 'paired') {
            h += step(1, 'Mean Difference', tex('\\bar{d} = \\frac{\\sum d_i}{n} = ' + C.fmt(r.dbar, 4)));
            h += step(2, 'SD of Differences', tex('s_d = ' + C.fmt(r.sd, 4)));
            h += step(3, 'Standard Error', tex('SE = \\frac{s_d}{\\sqrt{n}} = \\frac{' + C.fmt(r.sd, 4) + '}{\\sqrt{' + r.n + '}} = ' + C.fmt(r.se, 6)));
            h += step(4, 't-Statistic', tex('t = \\frac{\\bar{d}}{SE} = \\frac{' + C.fmt(r.dbar, 4) + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.t, 4)));
            h += step(5, 'Degrees of Freedom', tex('df = n - 1 = ' + r.n + ' - 1 = ' + C.fmt(r.df, 0)));
            h += step(6, 'p-Value', tex('p = ' + C.fmt(r.p, 6)));
        } else {
            /* welch */
            h += step(1, 'Standard Error', tex('SE = \\sqrt{\\frac{s_1^2}{n_1} + \\frac{s_2^2}{n_2}} = \\sqrt{\\frac{' + C.fmt(r.s1 * r.s1, 4) + '}{' + r.n1 + '} + \\frac{' + C.fmt(r.s2 * r.s2, 4) + '}{' + r.n2 + '}} = ' + C.fmt(r.se, 6)));
            h += step(2, 't-Statistic', tex('t = \\frac{\\bar{x}_1 - \\bar{x}_2}{SE} = \\frac{' + C.fmt(r.x1, 4) + ' - ' + C.fmt(r.x2, 4) + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.t, 4)));
            h += step(3, 'Welch-Satterthwaite df', tex('df = \\frac{\\left(\\frac{s_1^2}{n_1}+\\frac{s_2^2}{n_2}\\right)^2}{\\frac{(s_1^2/n_1)^2}{n_1-1}+\\frac{(s_2^2/n_2)^2}{n_2-1}} = ' + C.fmt(r.df, 4)));
            h += step(4, 'p-Value', tex('p = ' + C.fmt(r.p, 6)));
            h += step(5, "Cohen's d", tex('d = \\frac{\\bar{x}_1 - \\bar{x}_2}{s_p} = ' + C.fmt(r.cohenD, 4)));
        }

        return h + '</div>';
    }

    function tex(expr) {
        return '<span class="stat-katex" data-tex="' + expr.replace(/"/g, '&quot;') + '"></span>';
    }

    /* ===== Shared Builders ===== */
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

    function renderKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var t = spans[i].getAttribute('data-tex');
            if (t && window.katex) {
                try { window.katex.render(t, spans[i], { throwOnError: false }); } catch(e) {}
            }
        }
    }

    /* ===== Graph ===== */
    function loadGraph() {
        if (!state.result) return;
        G.loadPlotly(function() {
            var r = state.result;
            var container = document.getElementById('tt-graph-container');
            container.innerHTML = '';

            /* Build t-distribution curve */
            var range = Math.max(Math.abs(r.t), Math.abs(r.tCrit)) + 2;
            var xVals = [], yVals = [];
            var nPts = 300;
            for (var i = 0; i <= nPts; i++) {
                var x = -range + (2 * range * i / nPts);
                xVals.push(x);
                yVals.push(window.jStat.studentt.pdf(x, r.df));
            }

            var traces = [];

            /* Main curve */
            traces.push({
                x: xVals, y: yVals, type: 'scatter', mode: 'lines',
                line: { color: '#6366f1', width: 2 },
                name: 't(' + C.fmt(r.df, 2) + ')', fill: 'none'
            });

            /* Shaded rejection region(s) */
            if (r.tail === 'two') {
                traces.push(shadedRegion(r.df, r.tCrit, range, 'right', '#ef444466'));
                traces.push(shadedRegion(r.df, -r.tCrit, range, 'left', '#ef444466'));
            } else if (r.tail === 'right') {
                traces.push(shadedRegion(r.df, r.tCrit, range, 'right', '#ef444466'));
            } else {
                traces.push(shadedRegion(r.df, -r.tCrit, range, 'left', '#ef444466'));
            }

            /* t-statistic vertical line */
            var tPdf = window.jStat.studentt.pdf(r.t, r.df);
            traces.push({
                x: [r.t, r.t], y: [0, tPdf], type: 'scatter', mode: 'lines',
                line: { color: '#10b981', width: 3 },
                name: 't = ' + C.fmt(r.t, 4)
            });

            /* Critical value dashed lines */
            if (r.tail === 'two') {
                var cPdf = window.jStat.studentt.pdf(r.tCrit, r.df);
                traces.push(critLine(r.tCrit, cPdf, '+t\u2091'));
                traces.push(critLine(-r.tCrit, cPdf, '-t\u2091'));
            } else if (r.tail === 'right') {
                var cPdf = window.jStat.studentt.pdf(r.tCrit, r.df);
                traces.push(critLine(r.tCrit, cPdf, 't\u2091'));
            } else {
                var cPdf = window.jStat.studentt.pdf(-r.tCrit, r.df);
                traces.push(critLine(-r.tCrit, cPdf, '-t\u2091'));
            }

            var layout = {
                title: 't-Distribution (df = ' + C.fmt(r.df, 2) + ')',
                xaxis: { title: 't-value', zeroline: true },
                yaxis: { title: 'Density', rangemode: 'tozero' },
                showlegend: true, legend: { orientation: 'h', y: -0.25 },
                margin: { t: 50, b: 70, l: 50, r: 30 },
                height: 340
            };

            window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
        });
    }

    function shadedRegion(df, crit, range, side, color) {
        var xs = [], ys = [];
        var lo = (side === 'left') ? -range : crit;
        var hi = (side === 'left') ? crit   : range;
        var pts = 80;
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(window.jStat.studentt.pdf(x, df));
        }
        return {
            x: xs, y: ys, type: 'scatter', mode: 'lines',
            fill: 'tozeroy', fillcolor: color,
            line: { color: 'transparent', width: 0 },
            showlegend: false
        };
    }

    function critLine(xVal, yVal, label) {
        return {
            x: [xVal, xVal], y: [0, yVal], type: 'scatter', mode: 'lines',
            line: { color: '#ef4444', width: 2, dash: 'dash' },
            name: label + ' = ' + C.fmt(xVal, 4)
        };
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = ['import numpy as np', 'from scipy import stats', ''];

        if (r.mode === 'one') {
            lines.push('# One-Sample t-Test');
            lines.push('data = np.array([' + r.data.join(', ') + '])');
            lines.push('mu0 = ' + r.mu0);
            lines.push('alpha = ' + r.alpha);
            lines.push('');
            lines.push('t_stat, p_value = stats.ttest_1samp(data, mu0)');
            lines.push('n = len(data)');
            lines.push('print(f"t-statistic: {t_stat:.4f}")');
            lines.push('print(f"p-value (two-tailed): {p_value:.6f}")');
            lines.push('print(f"Mean: {np.mean(data):.4f}")');
            lines.push('print(f"Std Dev: {np.std(data, ddof=1):.4f}")');
            lines.push('print(f"n: {n}")');
            lines.push('print(f"df: {n - 1}")');
            lines.push('print(f"Cohen\'s d: {(np.mean(data) - mu0) / np.std(data, ddof=1):.4f}")');

        } else if (r.mode === 'two') {
            lines.push('# Two-Sample Independent t-Test (Equal Variances)');
            lines.push('data1 = np.array([' + r.d1.join(', ') + '])');
            lines.push('data2 = np.array([' + r.d2.join(', ') + '])');
            lines.push('alpha = ' + r.alpha);
            lines.push('');
            lines.push('t_stat, p_value = stats.ttest_ind(data1, data2, equal_var=True)');
            lines.push('print(f"t-statistic: {t_stat:.4f}")');
            lines.push('print(f"p-value (two-tailed): {p_value:.6f}")');
            lines.push('print(f"Mean 1: {np.mean(data1):.4f}, Mean 2: {np.mean(data2):.4f}")');
            lines.push('print(f"SD 1: {np.std(data1, ddof=1):.4f}, SD 2: {np.std(data2, ddof=1):.4f}")');
            lines.push('print(f"df: {len(data1) + len(data2) - 2}")');

        } else if (r.mode === 'paired') {
            lines.push('# Paired t-Test');
            lines.push('before = np.array([' + r.before.join(', ') + '])');
            lines.push('after = np.array([' + r.after.join(', ') + '])');
            lines.push('alpha = ' + r.alpha);
            lines.push('');
            lines.push('t_stat, p_value = stats.ttest_rel(before, after)');
            lines.push('diffs = before - after');
            lines.push('print(f"t-statistic: {t_stat:.4f}")');
            lines.push('print(f"p-value (two-tailed): {p_value:.6f}")');
            lines.push('print(f"Mean Difference: {np.mean(diffs):.4f}")');
            lines.push('print(f"SD of Differences: {np.std(diffs, ddof=1):.4f}")');
            lines.push('print(f"n pairs: {len(diffs)}")');
            lines.push('print(f"Cohen\'s d: {np.mean(diffs) / np.std(diffs, ddof=1):.4f}")');

        } else {
            lines.push("# Welch's t-Test (Unequal Variances)");
            lines.push('data1 = np.array([' + r.d1.join(', ') + '])');
            lines.push('data2 = np.array([' + r.d2.join(', ') + '])');
            lines.push('alpha = ' + r.alpha);
            lines.push('');
            lines.push('t_stat, p_value = stats.ttest_ind(data1, data2, equal_var=False)');
            lines.push('print(f"t-statistic: {t_stat:.4f}")');
            lines.push('print(f"p-value (two-tailed): {p_value:.6f}")');
            lines.push('print(f"Mean 1: {np.mean(data1):.4f}, Mean 2: {np.mean(data2):.4f}")');
            lines.push('print(f"SD 1: {np.std(data1, ddof=1):.4f}, SD 2: {np.std(data2, ddof=1):.4f}")');
            lines.push('# Welch-Satterthwaite df');
            lines.push('v1 = np.var(data1, ddof=1) / len(data1)');
            lines.push('v2 = np.var(data2, ddof=1) / len(data2)');
            lines.push('df = (v1 + v2)**2 / (v1**2/(len(data1)-1) + v2**2/(len(data2)-1))');
            lines.push('print(f"Welch df: {df:.4f}")');
        }

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83D\uDCCA', 'No Result Yet', 'Enter data and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        document.getElementById('tt-graph-container').innerHTML = '';
        state.result = null;

        /* Clear all textareas and inputs in panels */
        var areas = document.querySelectorAll('#tt-input-one textarea, #tt-input-two textarea, #tt-input-paired textarea, #tt-input-welch textarea');
        for (var i = 0; i < areas.length; i++) areas[i].value = '';
        var mu = document.getElementById('tt-one-mu');
        if (mu) mu.value = '';
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'exam-scores') {
            setMode('one');
            document.getElementById('tt-one-data').value = '78, 82, 71, 69, 85, 77, 73, 80, 76, 74';
            document.getElementById('tt-one-mu').value = '75';
        } else if (ex === 'drug-trial') {
            setMode('two');
            document.getElementById('tt-two-data1').value = '5.1, 4.8, 5.3, 4.9, 5.0';
            document.getElementById('tt-two-data2').value = '6.2, 5.8, 6.5, 6.1, 5.9';
        } else if (ex === 'weight-loss') {
            setMode('paired');
            document.getElementById('tt-paired-before').value = '185, 192, 178, 200, 175, 188';
            document.getElementById('tt-paired-after').value = '180, 186, 174, 195, 170, 182';
        } else if (ex === 'teaching-methods') {
            setMode('welch');
            document.getElementById('tt-welch-data1').value = '85, 78, 92, 88, 76, 95, 82';
            document.getElementById('tt-welch-data2').value = '72, 68, 75, 70, 65, 73, 80, 69';
        }

        /* Reset shared controls to defaults */
        var alphaEl = document.getElementById('tt-alpha');
        if (alphaEl) alphaEl.value = '0.05';
        var tailEl = document.getElementById('tt-tail');
        if (tailEl) tailEl.value = 'two';

        calculate();
    }

    /* ===== Restore from Share URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        var m = shared.mode;
        setMode(m);

        /* Restore shared controls */
        var alphaEl = document.getElementById('tt-alpha');
        if (alphaEl && shared.alpha != null) alphaEl.value = shared.alpha;
        var tailEl = document.getElementById('tt-tail');
        if (tailEl && shared.tail) tailEl.value = shared.tail;

        /* Restore mode-specific inputs */
        if (m === 'one') {
            if (shared.data) document.getElementById('tt-one-data').value = shared.data;
            if (shared.mu0 != null) document.getElementById('tt-one-mu').value = shared.mu0;
        } else if (m === 'two') {
            if (shared.d1) document.getElementById('tt-two-data1').value = shared.d1;
            if (shared.d2) document.getElementById('tt-two-data2').value = shared.d2;
        } else if (m === 'paired') {
            if (shared.before) document.getElementById('tt-paired-before').value = shared.before;
            if (shared.after) document.getElementById('tt-paired-after').value = shared.after;
        } else if (m === 'welch') {
            if (shared.d1) document.getElementById('tt-welch-data1').value = shared.d1;
            if (shared.d2) document.getElementById('tt-welch-data2').value = shared.d2;
        }

        calculate();
        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        /* Enter key on textareas */
        var inputs = document.querySelectorAll('#tt-input-one input, #tt-input-two input, #tt-input-paired input, #tt-input-welch input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        /* Example chips */
        var exContainer = document.getElementById('tt-examples');
        if (exContainer) {
            exContainer.querySelectorAll('[data-example]').forEach(function(el) {
                el.addEventListener('click', function() {
                    applyExample(this.getAttribute('data-example'));
                });
            });
        }

        /* Scroll animations */
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        /* Pre-load jStat so t-distribution is ready */
        G.loadJStat(function() {
            /* Try restoring from share URL first; fall back to default example */
            if (!restoreFromUrl()) {
                applyExample('exam-scores');
            }
        });

        setMode('one');
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
