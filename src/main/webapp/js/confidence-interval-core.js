/**
 * Confidence Interval Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for t-distribution critical values.
 * Uses Plotly (lazy-loaded) for CI visualization chart.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== Z-score fallback table ===== */
    var Z_TABLE = { 80: 1.282, 85: 1.44, 90: 1.645, 95: 1.96, 98: 2.326, 99: 2.576, 99.5: 2.807, 99.9: 3.291 };

    /* ===== State ===== */
    var state = {
        mode: 'mean',
        confLevel: 95,
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('ci-result-content');
        els.resultActions  = document.getElementById('ci-result-actions');
        els.graphPanel     = document.getElementById('ci-graph-panel');
        els.graphContainer = document.getElementById('ci-graph-container');
        els.compilerPanel  = document.getElementById('ci-compiler-panel');
        els.compilerIframe = document.getElementById('ci-compiler-iframe');
        els.calcBtn        = document.getElementById('ci-calc-btn');
        els.clearBtn       = document.getElementById('ci-clear-btn');

        els.modeMean     = document.getElementById('ci-mode-mean');
        els.modeProp     = document.getElementById('ci-mode-proportion');
        els.modeTwoMean  = document.getElementById('ci-mode-twomean');
        els.modeTwoProp  = document.getElementById('ci-mode-twoprop');

        els.panelMean     = document.getElementById('ci-input-mean');
        els.panelProp     = document.getElementById('ci-input-proportion');
        els.panelTwoMean  = document.getElementById('ci-input-twomean');
        els.panelTwoProp  = document.getElementById('ci-input-twoprop');
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
                if (target === 'ci-graph-panel') loadGraph();
                if (target === 'ci-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeMean.addEventListener('click', function() { setMode('mean'); });
        els.modeProp.addEventListener('click', function() { setMode('proportion'); });
        els.modeTwoMean.addEventListener('click', function() { setMode('twoMean'); });
        els.modeTwoProp.addEventListener('click', function() { setMode('twoProp'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeMean.classList.toggle('active', m === 'mean');
        els.modeProp.classList.toggle('active', m === 'proportion');
        els.modeTwoMean.classList.toggle('active', m === 'twoMean');
        els.modeTwoProp.classList.toggle('active', m === 'twoProp');
        els.panelMean.style.display = m === 'mean' ? '' : 'none';
        els.panelProp.style.display = m === 'proportion' ? '' : 'none';
        els.panelTwoMean.style.display = m === 'twoMean' ? '' : 'none';
        els.panelTwoProp.style.display = m === 'twoProp' ? '' : 'none';
    }

    /* ===== Confidence Level ===== */
    function initConfLevel() {
        document.querySelectorAll('.ci-conf-pill').forEach(function(pill) {
            pill.addEventListener('click', function() {
                document.querySelectorAll('.ci-conf-pill').forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                var val = this.getAttribute('data-conf');
                if (val === 'custom') {
                    var customEl = document.getElementById('ci-custom-conf');
                    if (customEl) customEl.style.display = '';
                } else {
                    state.confLevel = parseFloat(val);
                    var customEl = document.getElementById('ci-custom-conf');
                    if (customEl) customEl.style.display = 'none';
                }
            });
        });
        var customInput = document.getElementById('ci-custom-conf');
        if (customInput) {
            customInput.addEventListener('change', function() {
                var v = parseFloat(this.value);
                if (!isNaN(v) && v > 0 && v < 100) state.confLevel = v;
            });
        }
    }

    function getConfLevel() {
        var activePill = document.querySelector('.ci-conf-pill.active');
        if (activePill && activePill.getAttribute('data-conf') === 'custom') {
            var customEl = document.getElementById('ci-custom-conf');
            var v = customEl ? parseFloat(customEl.value) : 95;
            return (!isNaN(v) && v > 0 && v < 100) ? v : 95;
        }
        return state.confLevel;
    }

    /* ===== Critical Value Helpers ===== */
    function getZScore(confPercent) {
        var alpha = 1 - confPercent / 100;
        if (window.jStat) return window.jStat.normal.inv(1 - alpha / 2, 0, 1);
        if (Z_TABLE[confPercent] !== undefined) return Z_TABLE[confPercent];
        // Linear interpolation fallback for uncommon values
        return 1.96;
    }

    function getTScore(confPercent, df) {
        var alpha = 1 - confPercent / 100;
        if (window.jStat) return window.jStat.studentt.inv(1 - alpha / 2, df);
        // For large df, approximate with Z
        if (df >= 120) return getZScore(confPercent);
        // Fallback: use Z approximation for large samples
        return getZScore(confPercent);
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var r;
        var conf = getConfLevel();
        var alpha = 1 - conf / 100;

        if (state.mode === 'mean') {
            var xbar = parseFloat(document.getElementById('ci-mean').value);
            var s = parseFloat(document.getElementById('ci-sd').value);
            var n = parseFloat(document.getElementById('ci-n').value);
            if (isNaN(xbar)) { C.showError(els.resultContent, 'Enter a valid sample mean.'); return; }
            if (isNaN(s) || s <= 0) { C.showError(els.resultContent, 'Enter a valid standard deviation (> 0).'); return; }
            if (isNaN(n) || n < 2 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 2).'); return; }
            var df = n - 1;
            var se = s / Math.sqrt(n);
            var tCrit = getTScore(conf, df);
            var moe = tCrit * se;
            var lower = xbar - moe;
            var upper = xbar + moe;
            r = { mode: 'mean', xbar: xbar, s: s, n: n, df: df, se: se, critVal: tCrit, critType: 't', moe: moe, lower: lower, upper: upper, conf: conf, alpha: alpha };
            renderMeanResult(r);

        } else if (state.mode === 'proportion') {
            var x = parseFloat(document.getElementById('ci-successes').value);
            var n = parseFloat(document.getElementById('ci-n-prop').value);
            if (isNaN(x) || x < 0 || x !== Math.floor(x)) { C.showError(els.resultContent, 'Enter a valid number of successes (integer \u2265 0).'); return; }
            if (isNaN(n) || n < 1 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 1).'); return; }
            if (x > n) { C.showError(els.resultContent, 'Successes cannot exceed sample size.'); return; }
            var phat = x / n;
            var se = Math.sqrt(phat * (1 - phat) / n);
            var z = getZScore(conf);
            var moe = z * se;
            var lower = phat - moe;
            var upper = phat + moe;
            r = { mode: 'proportion', x: x, n: n, phat: phat, se: se, critVal: z, critType: 'z', moe: moe, lower: lower, upper: upper, conf: conf, alpha: alpha };
            renderProportionResult(r);

        } else if (state.mode === 'twoMean') {
            var x1 = parseFloat(document.getElementById('ci-mean1').value);
            var s1 = parseFloat(document.getElementById('ci-sd1').value);
            var n1 = parseFloat(document.getElementById('ci-n1').value);
            var x2 = parseFloat(document.getElementById('ci-mean2').value);
            var s2 = parseFloat(document.getElementById('ci-sd2').value);
            var n2 = parseFloat(document.getElementById('ci-n2').value);
            if (isNaN(x1)) { C.showError(els.resultContent, 'Enter a valid mean for sample 1.'); return; }
            if (isNaN(s1) || s1 <= 0) { C.showError(els.resultContent, 'Enter a valid SD for sample 1 (> 0).'); return; }
            if (isNaN(n1) || n1 < 2 || n1 !== Math.floor(n1)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 1 (integer \u2265 2).'); return; }
            if (isNaN(x2)) { C.showError(els.resultContent, 'Enter a valid mean for sample 2.'); return; }
            if (isNaN(s2) || s2 <= 0) { C.showError(els.resultContent, 'Enter a valid SD for sample 2 (> 0).'); return; }
            if (isNaN(n2) || n2 < 2 || n2 !== Math.floor(n2)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 2 (integer \u2265 2).'); return; }
            var diff = x1 - x2;
            var se = Math.sqrt((s1 * s1 / n1) + (s2 * s2 / n2));
            var v1 = s1 * s1 / n1;
            var v2 = s2 * s2 / n2;
            var df = Math.floor((v1 + v2) * (v1 + v2) / ((v1 * v1 / (n1 - 1)) + (v2 * v2 / (n2 - 1))));
            var tCrit = getTScore(conf, df);
            var moe = tCrit * se;
            var lower = diff - moe;
            var upper = diff + moe;
            r = { mode: 'twoMean', x1: x1, s1: s1, n1: n1, x2: x2, s2: s2, n2: n2, diff: diff, se: se, df: df, critVal: tCrit, critType: 't', moe: moe, lower: lower, upper: upper, conf: conf, alpha: alpha };
            renderTwoMeanResult(r);

        } else {
            var x1 = parseFloat(document.getElementById('ci-x1').value);
            var n1 = parseFloat(document.getElementById('ci-np1').value);
            var x2 = parseFloat(document.getElementById('ci-x2').value);
            var n2 = parseFloat(document.getElementById('ci-np2').value);
            if (isNaN(x1) || x1 < 0 || x1 !== Math.floor(x1)) { C.showError(els.resultContent, 'Enter valid successes for sample 1 (integer \u2265 0).'); return; }
            if (isNaN(n1) || n1 < 1 || n1 !== Math.floor(n1)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 1 (integer \u2265 1).'); return; }
            if (x1 > n1) { C.showError(els.resultContent, 'Successes cannot exceed sample size for sample 1.'); return; }
            if (isNaN(x2) || x2 < 0 || x2 !== Math.floor(x2)) { C.showError(els.resultContent, 'Enter valid successes for sample 2 (integer \u2265 0).'); return; }
            if (isNaN(n2) || n2 < 1 || n2 !== Math.floor(n2)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 2 (integer \u2265 1).'); return; }
            if (x2 > n2) { C.showError(els.resultContent, 'Successes cannot exceed sample size for sample 2.'); return; }
            var p1 = x1 / n1;
            var p2 = x2 / n2;
            var diff = p1 - p2;
            var se = Math.sqrt((p1 * (1 - p1) / n1) + (p2 * (1 - p2) / n2));
            var z = getZScore(conf);
            var moe = z * se;
            var lower = diff - moe;
            var upper = diff + moe;
            r = { mode: 'twoProp', x1: x1, n1: n1, x2: x2, n2: n2, p1: p1, p2: p2, diff: diff, se: se, critVal: z, critType: 'z', moe: moe, lower: lower, upper: upper, conf: conf, alpha: alpha };
            renderTwoPropResult(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Confidence Interval',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Confidence Interval Calculator}\\\\[4pt]');
                lines.push('\\text{Mode: ' + s.mode + '}\\\\');
                lines.push('\\text{Confidence Level: } ' + C.fmt(s.conf, 0) + '\\%\\\\[4pt]');
                if (s.mode === 'mean') {
                    lines.push('\\bar{x} = ' + C.fmt(s.xbar, 4) + ',\\; s = ' + C.fmt(s.s, 4) + ',\\; n = ' + s.n + '\\\\');
                    lines.push('SE = \\frac{s}{\\sqrt{n}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('t_{' + C.fmt(s.alpha / 2, 4) + ',\\,' + s.df + '} = ' + C.fmt(s.critVal, 4) + '\\\\');
                    lines.push('E = t \\times SE = ' + C.fmt(s.moe, 4) + '\\\\');
                    lines.push('CI = \\bar{x} \\pm E = [' + C.fmt(s.lower, 4) + ',\\,' + C.fmt(s.upper, 4) + ']');
                } else if (s.mode === 'proportion') {
                    lines.push('x = ' + s.x + ',\\; n = ' + s.n + '\\\\');
                    lines.push('\\hat{p} = ' + C.fmt(s.phat, 6) + '\\\\');
                    lines.push('SE = \\sqrt{\\frac{\\hat{p}(1-\\hat{p})}{n}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.alpha / 2, 4) + '} = ' + C.fmt(s.critVal, 4) + '\\\\');
                    lines.push('CI = \\hat{p} \\pm z \\times SE = [' + C.fmt(s.lower, 4) + ',\\,' + C.fmt(s.upper, 4) + ']');
                } else if (s.mode === 'twoMean') {
                    lines.push('\\bar{x}_1 = ' + C.fmt(s.x1, 4) + ',\\; s_1 = ' + C.fmt(s.s1, 4) + ',\\; n_1 = ' + s.n1 + '\\\\');
                    lines.push('\\bar{x}_2 = ' + C.fmt(s.x2, 4) + ',\\; s_2 = ' + C.fmt(s.s2, 4) + ',\\; n_2 = ' + s.n2 + '\\\\');
                    lines.push('\\bar{x}_1 - \\bar{x}_2 = ' + C.fmt(s.diff, 4) + '\\\\');
                    lines.push('SE = ' + C.fmt(s.se, 6) + ',\\; df = ' + s.df + '\\\\');
                    lines.push('t_{' + C.fmt(s.alpha / 2, 4) + ',\\,' + s.df + '} = ' + C.fmt(s.critVal, 4) + '\\\\');
                    lines.push('CI = [' + C.fmt(s.lower, 4) + ',\\,' + C.fmt(s.upper, 4) + ']');
                } else {
                    lines.push('x_1 = ' + s.x1 + ',\\; n_1 = ' + s.n1 + ',\\; \\hat{p}_1 = ' + C.fmt(s.p1, 6) + '\\\\');
                    lines.push('x_2 = ' + s.x2 + ',\\; n_2 = ' + s.n2 + ',\\; \\hat{p}_2 = ' + C.fmt(s.p2, 6) + '\\\\');
                    lines.push('\\hat{p}_1 - \\hat{p}_2 = ' + C.fmt(s.diff, 6) + '\\\\');
                    lines.push('SE = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.alpha / 2, 4) + '} = ' + C.fmt(s.critVal, 4) + '\\\\');
                    lines.push('CI = [' + C.fmt(s.lower, 4) + ',\\,' + C.fmt(s.upper, 4) + ']');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: s.mode, conf: s.conf };
                if (s.mode === 'mean') {
                    shared.xbar = s.xbar; shared.s = s.s; shared.n = s.n;
                } else if (s.mode === 'proportion') {
                    shared.x = s.x; shared.n = s.n;
                } else if (s.mode === 'twoMean') {
                    shared.x1 = s.x1; shared.s1 = s.s1; shared.n1 = s.n1;
                    shared.x2 = s.x2; shared.s2 = s.s2; shared.n2 = s.n2;
                } else {
                    shared.x1 = s.x1; shared.n1 = s.n1;
                    shared.x2 = s.x2; shared.n2 = s.n2;
                }
                return shared;
            },
            resultEl: '#ci-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="ci-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="ci-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    /* ===== Render: One-Sample Mean ===== */
    function renderMeanResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">[' + C.fmt(r.lower, 4) + ', ' + C.fmt(r.upper, 4) + ']</span><span class="stat-hero-label">' + C.fmt(r.conf, 0) + '% Confidence Interval</span></div>';
        h += buildSection('Confidence Interval for Mean', [
            ['Sample Mean (\u0078\u0304)', C.fmt(r.xbar, 4)],
            ['Standard Deviation (s)', C.fmt(r.s, 4)],
            ['Sample Size (n)', r.n],
            ['Degrees of Freedom (df)', r.df],
            ['Standard Error (SE)', C.fmt(r.se, 6)],
            ['Critical Value (t)', C.fmt(r.critVal, 4)],
            ['Margin of Error', C.fmt(r.moe, 4)],
            ['Lower Bound', C.fmt(r.lower, 4)],
            ['Upper Bound', C.fmt(r.upper, 4)]
        ]);
        h += buildSteps('mean', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> We are ' + C.fmt(r.conf, 0) + '% confident that the true population mean lies between ' + C.fmt(r.lower, 4) + ' and ' + C.fmt(r.upper, 4) + '. The margin of error is \u00B1' + C.fmt(r.moe, 4) + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Proportion ===== */
    function renderProportionResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">[' + C.fmt(r.lower, 4) + ', ' + C.fmt(r.upper, 4) + ']</span><span class="stat-hero-label">' + C.fmt(r.conf, 0) + '% Confidence Interval</span></div>';
        h += buildSection('Confidence Interval for Proportion', [
            ['Successes (x)', r.x],
            ['Sample Size (n)', r.n],
            ['Sample Proportion (\u0070\u0302)', C.fmt(r.phat, 6)],
            ['Standard Error (SE)', C.fmt(r.se, 6)],
            ['Critical Value (z)', C.fmt(r.critVal, 4)],
            ['Margin of Error', C.fmt(r.moe, 4)],
            ['Lower Bound', C.fmt(r.lower, 4)],
            ['Upper Bound', C.fmt(r.upper, 4)]
        ]);
        h += buildSteps('proportion', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> We are ' + C.fmt(r.conf, 0) + '% confident that the true population proportion lies between ' + C.fmt(r.lower * 100, 2) + '% and ' + C.fmt(r.upper * 100, 2) + '%. The sample proportion is ' + C.fmt(r.phat * 100, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Two-Sample Mean ===== */
    function renderTwoMeanResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">[' + C.fmt(r.lower, 4) + ', ' + C.fmt(r.upper, 4) + ']</span><span class="stat-hero-label">' + C.fmt(r.conf, 0) + '% CI for Difference in Means</span></div>';
        h += buildSection('Two-Sample Mean Difference', [
            ['Mean 1 (\u0078\u0304\u2081)', C.fmt(r.x1, 4)],
            ['SD 1 (s\u2081)', C.fmt(r.s1, 4)],
            ['n\u2081', r.n1],
            ['Mean 2 (\u0078\u0304\u2082)', C.fmt(r.x2, 4)],
            ['SD 2 (s\u2082)', C.fmt(r.s2, 4)],
            ['n\u2082', r.n2],
            ['Difference (\u0078\u0304\u2081 \u2212 \u0078\u0304\u2082)', C.fmt(r.diff, 4)],
            ['Welch df', r.df],
            ['Standard Error', C.fmt(r.se, 6)],
            ['Critical Value (t)', C.fmt(r.critVal, 4)],
            ['Margin of Error', C.fmt(r.moe, 4)],
            ['Lower Bound', C.fmt(r.lower, 4)],
            ['Upper Bound', C.fmt(r.upper, 4)]
        ]);
        h += buildSteps('twoMean', r);
        var sig = (r.lower > 0 || r.upper < 0) ? 'The interval does not contain 0, suggesting a statistically significant difference.' : 'The interval contains 0, so the difference is not statistically significant at this level.';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> We are ' + C.fmt(r.conf, 0) + '% confident that the true difference in means lies between ' + C.fmt(r.lower, 4) + ' and ' + C.fmt(r.upper, 4) + '. ' + sig + '</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Two-Sample Proportion ===== */
    function renderTwoPropResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">[' + C.fmt(r.lower, 4) + ', ' + C.fmt(r.upper, 4) + ']</span><span class="stat-hero-label">' + C.fmt(r.conf, 0) + '% CI for Difference in Proportions</span></div>';
        h += buildSection('Two-Sample Proportion Difference', [
            ['Successes 1 (x\u2081)', r.x1],
            ['Sample Size 1 (n\u2081)', r.n1],
            ['Proportion 1 (\u0070\u0302\u2081)', C.fmt(r.p1, 6)],
            ['Successes 2 (x\u2082)', r.x2],
            ['Sample Size 2 (n\u2082)', r.n2],
            ['Proportion 2 (\u0070\u0302\u2082)', C.fmt(r.p2, 6)],
            ['Difference (\u0070\u0302\u2081 \u2212 \u0070\u0302\u2082)', C.fmt(r.diff, 6)],
            ['Standard Error', C.fmt(r.se, 6)],
            ['Critical Value (z)', C.fmt(r.critVal, 4)],
            ['Margin of Error', C.fmt(r.moe, 4)],
            ['Lower Bound', C.fmt(r.lower, 4)],
            ['Upper Bound', C.fmt(r.upper, 4)]
        ]);
        h += buildSteps('twoProp', r);
        var sig = (r.lower > 0 || r.upper < 0) ? 'The interval does not contain 0, suggesting a statistically significant difference.' : 'The interval contains 0, so the difference is not statistically significant at this level.';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> We are ' + C.fmt(r.conf, 0) + '% confident that the true difference in proportions lies between ' + C.fmt(r.lower * 100, 2) + '% and ' + C.fmt(r.upper * 100, 2) + '%. ' + sig + '</div>';
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
        if (mode === 'mean') {
            h += step(1, 'Standard Error', '<span class="stat-katex" data-tex="SE = \\frac{s}{\\sqrt{n}} = \\frac{' + C.fmt(r.s, 4) + '}{\\sqrt{' + r.n + '}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(2, 'Critical Value', '<span class="stat-katex" data-tex="t_{' + C.fmt(r.alpha / 2, 4) + ',\\,' + r.df + '} = ' + C.fmt(r.critVal, 4) + '"></span>');
            h += step(3, 'Margin of Error', '<span class="stat-katex" data-tex="E = t \\times SE = ' + C.fmt(r.critVal, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = ' + C.fmt(r.moe, 4) + '"></span>');
            h += step(4, 'Confidence Interval', '<span class="stat-katex" data-tex="\\bar{x} \\pm E = ' + C.fmt(r.xbar, 4) + ' \\pm ' + C.fmt(r.moe, 4) + ' = [' + C.fmt(r.lower, 4) + ',\\,' + C.fmt(r.upper, 4) + ']"></span>');
        } else if (mode === 'proportion') {
            h += step(1, 'Sample Proportion', '<span class="stat-katex" data-tex="\\hat{p} = \\frac{x}{n} = \\frac{' + r.x + '}{' + r.n + '} = ' + C.fmt(r.phat, 6) + '"></span>');
            h += step(2, 'Standard Error', '<span class="stat-katex" data-tex="SE = \\sqrt{\\frac{\\hat{p}(1-\\hat{p})}{n}} = \\sqrt{\\frac{' + C.fmt(r.phat, 4) + ' \\times ' + C.fmt(1 - r.phat, 4) + '}{' + r.n + '}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(3, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.alpha / 2, 4) + '} = ' + C.fmt(r.critVal, 4) + '"></span>');
            h += step(4, 'Confidence Interval', '<span class="stat-katex" data-tex="\\hat{p} \\pm z \\times SE = ' + C.fmt(r.phat, 4) + ' \\pm ' + C.fmt(r.moe, 4) + ' = [' + C.fmt(r.lower, 4) + ',\\,' + C.fmt(r.upper, 4) + ']"></span>');
        } else if (mode === 'twoMean') {
            h += step(1, 'Point Estimate', '<span class="stat-katex" data-tex="\\bar{x}_1 - \\bar{x}_2 = ' + C.fmt(r.x1, 4) + ' - ' + C.fmt(r.x2, 4) + ' = ' + C.fmt(r.diff, 4) + '"></span>');
            h += step(2, 'Standard Error', '<span class="stat-katex" data-tex="SE = \\sqrt{\\frac{s_1^2}{n_1} + \\frac{s_2^2}{n_2}} = \\sqrt{\\frac{' + C.fmt(r.s1 * r.s1, 2) + '}{' + r.n1 + '} + \\frac{' + C.fmt(r.s2 * r.s2, 2) + '}{' + r.n2 + '}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(3, 'Welch Degrees of Freedom', '<span class="stat-katex" data-tex="df = \\frac{\\left(\\frac{s_1^2}{n_1} + \\frac{s_2^2}{n_2}\\right)^2}{\\frac{(s_1^2/n_1)^2}{n_1-1} + \\frac{(s_2^2/n_2)^2}{n_2-1}} = ' + r.df + '"></span>');
            h += step(4, 'Critical Value', '<span class="stat-katex" data-tex="t_{' + C.fmt(r.alpha / 2, 4) + ',\\,' + r.df + '} = ' + C.fmt(r.critVal, 4) + '"></span>');
            h += step(5, 'Confidence Interval', '<span class="stat-katex" data-tex="(' + C.fmt(r.diff, 4) + ') \\pm ' + C.fmt(r.critVal, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = [' + C.fmt(r.lower, 4) + ',\\,' + C.fmt(r.upper, 4) + ']"></span>');
        } else {
            h += step(1, 'Sample Proportions', '<span class="stat-katex" data-tex="\\hat{p}_1 = \\frac{' + r.x1 + '}{' + r.n1 + '} = ' + C.fmt(r.p1, 6) + ',\\;\\hat{p}_2 = \\frac{' + r.x2 + '}{' + r.n2 + '} = ' + C.fmt(r.p2, 6) + '"></span>');
            h += step(2, 'Point Estimate', '<span class="stat-katex" data-tex="\\hat{p}_1 - \\hat{p}_2 = ' + C.fmt(r.diff, 6) + '"></span>');
            h += step(3, 'Standard Error', '<span class="stat-katex" data-tex="SE = \\sqrt{\\frac{\\hat{p}_1(1-\\hat{p}_1)}{n_1} + \\frac{\\hat{p}_2(1-\\hat{p}_2)}{n_2}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(4, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.alpha / 2, 4) + '} = ' + C.fmt(r.critVal, 4) + '"></span>');
            h += step(5, 'Confidence Interval', '<span class="stat-katex" data-tex="(' + C.fmt(r.diff, 4) + ') \\pm ' + C.fmt(r.critVal, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = [' + C.fmt(r.lower, 4) + ',\\,' + C.fmt(r.upper, 4) + ']"></span>');
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
    function loadGraph() {
        if (!state.result) return;
        G.loadPlotly(function() {
            var r = state.result;
            var container = document.getElementById('ci-graph-container');
            container.innerHTML = '';
            var isProp = (r.mode === 'proportion' || r.mode === 'twoProp');
            var pointEst = (r.mode === 'mean') ? r.xbar : (r.mode === 'proportion') ? r.phat : (r.mode === 'twoMean') ? r.diff : r.diff;
            var lo = isProp ? r.lower * 100 : r.lower;
            var hi = isProp ? r.upper * 100 : r.upper;
            var pt = isProp ? pointEst * 100 : pointEst;
            var suffix = isProp ? '%' : '';
            var traces = [
                { x: [lo, hi], y: [1, 1], mode: 'lines+markers', line: { color: '#6366f1', width: 4 }, marker: { size: 10, color: '#6366f1' }, name: C.fmt(r.conf, 0) + '% CI', showlegend: true },
                { x: [pt], y: [1], mode: 'markers', marker: { size: 14, color: '#ef4444', symbol: 'diamond' }, name: 'Point Estimate', showlegend: true }
            ];
            var layout = {
                title: C.fmt(r.conf, 0) + '% Confidence Interval',
                xaxis: { title: isProp ? 'Proportion (%)' : 'Value', zeroline: true },
                yaxis: { visible: false, range: [0.5, 1.5] },
                showlegend: true, legend: { orientation: 'h', y: -0.2 },
                margin: { t: 50, b: 60, l: 40, r: 40 },
                annotations: [
                    { x: lo, y: 1.15, text: C.fmt(lo, 2) + suffix, showarrow: false, font: { size: 11 } },
                    { x: hi, y: 1.15, text: C.fmt(hi, 2) + suffix, showarrow: false, font: { size: 11 } },
                    { x: pt, y: 0.85, text: C.fmt(pt, 2) + suffix, showarrow: false, font: { size: 11, color: '#ef4444' } }
                ],
                height: 220
            };
            window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
        });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [];

        if (r.mode === 'mean') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('xbar = ' + r.xbar);
            lines.push('s = ' + r.s);
            lines.push('n = ' + r.n);
            lines.push('conf = ' + r.conf / 100);
            lines.push('alpha = 1 - conf');
            lines.push('df = n - 1');
            lines.push('');
            lines.push('se = s / math.sqrt(n)');
            lines.push('t_crit = stats.t.ppf(1 - alpha/2, df)');
            lines.push('moe = t_crit * se');
            lines.push('ci = (xbar - moe, xbar + moe)');
            lines.push('');
            lines.push('print(f"SE = {se:.6f}")');
            lines.push('print(f"t-critical = {t_crit:.4f}")');
            lines.push('print(f"Margin of Error = {moe:.4f}")');
            lines.push('print(f"{conf*100:.0f}% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
        } else if (r.mode === 'proportion') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('x = ' + r.x);
            lines.push('n = ' + r.n);
            lines.push('conf = ' + r.conf / 100);
            lines.push('alpha = 1 - conf');
            lines.push('');
            lines.push('p_hat = x / n');
            lines.push('se = math.sqrt(p_hat * (1 - p_hat) / n)');
            lines.push('z = stats.norm.ppf(1 - alpha/2)');
            lines.push('moe = z * se');
            lines.push('ci = (p_hat - moe, p_hat + moe)');
            lines.push('');
            lines.push('print(f"p-hat = {p_hat:.6f}")');
            lines.push('print(f"SE = {se:.6f}")');
            lines.push('print(f"z-critical = {z:.4f}")');
            lines.push('print(f"{conf*100:.0f}% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
        } else if (r.mode === 'twoMean') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('x1, s1, n1 = ' + r.x1 + ', ' + r.s1 + ', ' + r.n1);
            lines.push('x2, s2, n2 = ' + r.x2 + ', ' + r.s2 + ', ' + r.n2);
            lines.push('conf = ' + r.conf / 100);
            lines.push('alpha = 1 - conf');
            lines.push('');
            lines.push('diff = x1 - x2');
            lines.push('se = math.sqrt(s1**2/n1 + s2**2/n2)');
            lines.push('v1, v2 = s1**2/n1, s2**2/n2');
            lines.push('df = int((v1 + v2)**2 / (v1**2/(n1-1) + v2**2/(n2-1)))');
            lines.push('t_crit = stats.t.ppf(1 - alpha/2, df)');
            lines.push('moe = t_crit * se');
            lines.push('ci = (diff - moe, diff + moe)');
            lines.push('');
            lines.push('print(f"Difference = {diff:.4f}")');
            lines.push('print(f"Welch df = {df}")');
            lines.push('print(f"SE = {se:.6f}")');
            lines.push('print(f"t-critical = {t_crit:.4f}")');
            lines.push('print(f"{conf*100:.0f}% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
        } else {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('x1, n1 = ' + r.x1 + ', ' + r.n1);
            lines.push('x2, n2 = ' + r.x2 + ', ' + r.n2);
            lines.push('conf = ' + r.conf / 100);
            lines.push('alpha = 1 - conf');
            lines.push('');
            lines.push('p1, p2 = x1/n1, x2/n2');
            lines.push('diff = p1 - p2');
            lines.push('se = math.sqrt(p1*(1-p1)/n1 + p2*(1-p2)/n2)');
            lines.push('z = stats.norm.ppf(1 - alpha/2)');
            lines.push('moe = z * se');
            lines.push('ci = (diff - moe, diff + moe)');
            lines.push('');
            lines.push('print(f"p1 = {p1:.6f}, p2 = {p2:.6f}")');
            lines.push('print(f"Difference = {diff:.6f}")');
            lines.push('print(f"SE = {se:.6f}")');
            lines.push('print(f"z-critical = {z:.4f}")');
            lines.push('print(f"{conf*100:.0f}% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
        }

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
        document.getElementById('ci-graph-container').innerHTML = '';
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'exam-scores') {
            setMode('mean');
            document.getElementById('ci-mean').value = '75';
            document.getElementById('ci-sd').value = '12';
            document.getElementById('ci-n').value = '40';
        } else if (ex === 'poll') {
            setMode('proportion');
            document.getElementById('ci-successes').value = '520';
            document.getElementById('ci-n-prop').value = '1000';
        } else if (ex === 'treatment') {
            setMode('twoMean');
            document.getElementById('ci-mean1').value = '85';
            document.getElementById('ci-sd1').value = '10';
            document.getElementById('ci-n1').value = '50';
            document.getElementById('ci-mean2').value = '78';
            document.getElementById('ci-sd2').value = '11';
            document.getElementById('ci-n2').value = '45';
        } else if (ex === 'ab-test') {
            setMode('twoProp');
            document.getElementById('ci-x1').value = '120';
            document.getElementById('ci-np1').value = '500';
            document.getElementById('ci-x2').value = '95';
            document.getElementById('ci-np2').value = '500';
        }
        state.confLevel = 95;
        document.querySelectorAll('.ci-conf-pill').forEach(function(p) {
            p.classList.toggle('active', p.getAttribute('data-conf') === '95');
        });
        calculate();
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();
        initConfLevel();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.ci-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-ci-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-ci-example'));
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Pre-load jStat so t-distribution is ready
        G.loadJStat(function() {});

        // Restore from share URL or auto-calculate with defaults
        var shared = E.parseShareUrl();
        if (shared && shared.mode) {
            if (shared.conf) {
                state.confLevel = shared.conf;
                document.querySelectorAll('.ci-conf-pill').forEach(function(p) {
                    p.classList.toggle('active', parseFloat(p.getAttribute('data-conf')) === shared.conf);
                });
            }
            if (shared.mode === 'mean' && shared.xbar !== undefined) {
                setMode('mean');
                document.getElementById('ci-mean').value = shared.xbar;
                document.getElementById('ci-sd').value = shared.s;
                document.getElementById('ci-n').value = shared.n;
            } else if (shared.mode === 'proportion' && shared.x !== undefined) {
                setMode('proportion');
                document.getElementById('ci-successes').value = shared.x;
                document.getElementById('ci-n-prop').value = shared.n;
            } else if (shared.mode === 'twoMean' && shared.x1 !== undefined) {
                setMode('twoMean');
                document.getElementById('ci-mean1').value = shared.x1;
                document.getElementById('ci-sd1').value = shared.s1;
                document.getElementById('ci-n1').value = shared.n1;
                document.getElementById('ci-mean2').value = shared.x2;
                document.getElementById('ci-sd2').value = shared.s2;
                document.getElementById('ci-n2').value = shared.n2;
            } else if (shared.mode === 'twoProp' && shared.x1 !== undefined) {
                setMode('twoProp');
                document.getElementById('ci-x1').value = shared.x1;
                document.getElementById('ci-np1').value = shared.n1;
                document.getElementById('ci-x2').value = shared.x2;
                document.getElementById('ci-np2').value = shared.n2;
            } else {
                setMode('mean');
                document.getElementById('ci-mean').value = '50';
                document.getElementById('ci-sd').value = '10';
                document.getElementById('ci-n').value = '30';
            }
        } else {
            setMode('mean');
            document.getElementById('ci-mean').value = '50';
            document.getElementById('ci-sd').value = '10';
            document.getElementById('ci-n').value = '30';
        }
        calculate();
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
