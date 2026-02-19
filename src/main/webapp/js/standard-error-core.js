/**
 * Standard Error Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Pure JS Z-score computation — no jStat needed.
 * Uses Plotly (lazy-loaded) for confidence interval visualization chart.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    var PREFIX = 'se-';

    /* ===== Z-score table (pure JS, no jStat) ===== */
    var Z_TABLE = { 80: 1.282, 85: 1.44, 90: 1.645, 95: 1.96, 99: 2.576, 99.5: 2.807, 99.9: 3.291 };

    function getZ(conf) {
        return Z_TABLE[conf] || Z_TABLE[95];
    }

    /* ===== State ===== */
    var state = {
        mode: 'mean',
        confidence: 95,
        results: null
    };

    /* ===== DOM ===== */
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

        els.panelMean     = document.getElementById(PREFIX + 'input-mean');
        els.panelProp     = document.getElementById(PREFIX + 'input-proportion');
        els.panelDiffMean = document.getElementById(PREFIX + 'input-diffmean');
        els.panelDiffProp = document.getElementById(PREFIX + 'input-diffprop');
    }

    /* ===== Core Computation Functions ===== */

    function computeSEMean(sd, n, conf) {
        var se = sd / Math.sqrt(n);
        var z = getZ(conf);
        var me = z * se;
        return { se: se, z: z, me: me, sd: sd, n: n, conf: conf };
    }

    function computeSEProp(p, n, conf) {
        var se = Math.sqrt(p * (1 - p) / n);
        var z = getZ(conf);
        var me = z * se;
        var ciLower = Math.max(0, p - me);
        var ciUpper = Math.min(1, p + me);
        return { se: se, z: z, me: me, p: p, n: n, conf: conf, ciLower: ciLower, ciUpper: ciUpper };
    }

    function computeSEDiffMean(s1, n1, s2, n2, conf) {
        var se = Math.sqrt(s1 * s1 / n1 + s2 * s2 / n2);
        var z = getZ(conf);
        var me = z * se;
        return { se: se, z: z, me: me, s1: s1, n1: n1, s2: s2, n2: n2, conf: conf };
    }

    function computeSEDiffProp(p1, n1, p2, n2, conf) {
        var se = Math.sqrt(p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2);
        var diff = p1 - p2;
        var z = getZ(conf);
        var me = z * se;
        var ciLower = diff - me;
        var ciUpper = diff + me;
        return { se: se, z: z, me: me, p1: p1, n1: n1, p2: p2, n2: n2, diff: diff, conf: conf, ciLower: ciLower, ciUpper: ciUpper };
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
                if (target === PREFIX + 'compiler-panel') preparePython();
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        var modeButtons = document.querySelectorAll('.stat-mode-btn');
        for (var i = 0; i < modeButtons.length; i++) {
            modeButtons[i].addEventListener('click', function() {
                var m = this.getAttribute('data-mode');
                if (m) setMode(m);
            });
        }
    }

    function setMode(m) {
        state.mode = m;
        var modeButtons = document.querySelectorAll('.stat-mode-btn');
        for (var i = 0; i < modeButtons.length; i++) {
            modeButtons[i].classList.toggle('active', modeButtons[i].getAttribute('data-mode') === m);
        }
        if (els.panelMean) els.panelMean.style.display = m === 'mean' ? '' : 'none';
        if (els.panelProp) els.panelProp.style.display = m === 'proportion' ? '' : 'none';
        if (els.panelDiffMean) els.panelDiffMean.style.display = m === 'diffmean' ? '' : 'none';
        if (els.panelDiffProp) els.panelDiffProp.style.display = m === 'diffprop' ? '' : 'none';
    }

    /* ===== Confidence Pills ===== */
    function initConfPills() {
        document.querySelectorAll('.se-conf-pill').forEach(function(pill) {
            pill.addEventListener('click', function() {
                document.querySelectorAll('.se-conf-pill').forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                var val = this.getAttribute('data-conf');
                if (val === 'custom') {
                    var customEl = document.getElementById(PREFIX + 'custom-conf');
                    if (customEl) customEl.style.display = '';
                } else {
                    state.confidence = parseFloat(val);
                    var customEl = document.getElementById(PREFIX + 'custom-conf');
                    if (customEl) customEl.style.display = 'none';
                }
            });
        });
        var customInput = document.getElementById(PREFIX + 'custom-conf');
        if (customInput) {
            customInput.addEventListener('change', function() {
                var v = parseFloat(this.value);
                if (!isNaN(v) && v > 0 && v < 100) state.confidence = v;
            });
        }
    }

    function getConfidence() {
        var activePill = document.querySelector('.se-conf-pill.active');
        if (activePill && activePill.getAttribute('data-conf') === 'custom') {
            var customEl = document.getElementById(PREFIX + 'custom-conf');
            var v = customEl ? parseFloat(customEl.value) : 95;
            return (!isNaN(v) && v > 0 && v < 100) ? v : 95;
        }
        return state.confidence;
    }

    /* ===== Calculate (main entry) ===== */
    function calculate() {
        try {
            doCalculate();
        } catch (e) {
            C.showError(els.resultContent, 'Calculation error: ' + e.message);
        }
    }

    function doCalculate() {
        var r;
        var conf = getConfidence();

        if (state.mode === 'mean') {
            var sd = parseFloat(document.getElementById(PREFIX + 'sd').value);
            var n  = parseFloat(document.getElementById(PREFIX + 'n').value);
            if (isNaN(sd) || sd <= 0) { C.showError(els.resultContent, 'Enter a valid standard deviation (> 0).'); return; }
            if (isNaN(n) || n < 2 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 2).'); return; }
            r = computeSEMean(sd, n, conf);
            r.mode = 'mean';

        } else if (state.mode === 'proportion') {
            var p = parseFloat(document.getElementById(PREFIX + 'p').value);
            var n = parseFloat(document.getElementById(PREFIX + 'n-prop').value);
            if (isNaN(p) || p <= 0 || p >= 1) { C.showError(els.resultContent, 'Enter a valid proportion (0 < p < 1).'); return; }
            if (isNaN(n) || n < 2 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 2).'); return; }
            r = computeSEProp(p, n, conf);
            r.mode = 'proportion';

        } else if (state.mode === 'diffmean') {
            var s1 = parseFloat(document.getElementById(PREFIX + 'sd1').value);
            var n1 = parseFloat(document.getElementById(PREFIX + 'n1').value);
            var s2 = parseFloat(document.getElementById(PREFIX + 'sd2').value);
            var n2 = parseFloat(document.getElementById(PREFIX + 'n2').value);
            if (isNaN(s1) || s1 <= 0) { C.showError(els.resultContent, 'Enter a valid SD for sample 1 (> 0).'); return; }
            if (isNaN(n1) || n1 < 2 || n1 !== Math.floor(n1)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 1 (integer \u2265 2).'); return; }
            if (isNaN(s2) || s2 <= 0) { C.showError(els.resultContent, 'Enter a valid SD for sample 2 (> 0).'); return; }
            if (isNaN(n2) || n2 < 2 || n2 !== Math.floor(n2)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 2 (integer \u2265 2).'); return; }
            r = computeSEDiffMean(s1, n1, s2, n2, conf);
            r.mode = 'diffmean';

        } else {
            var p1 = parseFloat(document.getElementById(PREFIX + 'p1').value);
            var n1 = parseFloat(document.getElementById(PREFIX + 'n1-prop').value);
            var p2 = parseFloat(document.getElementById(PREFIX + 'p2').value);
            var n2 = parseFloat(document.getElementById(PREFIX + 'n2-prop').value);
            if (isNaN(p1) || p1 <= 0 || p1 >= 1) { C.showError(els.resultContent, 'Enter a valid proportion for sample 1 (0 < p < 1).'); return; }
            if (isNaN(n1) || n1 < 2 || n1 !== Math.floor(n1)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 1 (integer \u2265 2).'); return; }
            if (isNaN(p2) || p2 <= 0 || p2 >= 1) { C.showError(els.resultContent, 'Enter a valid proportion for sample 2 (0 < p < 1).'); return; }
            if (isNaN(n2) || n2 < 2 || n2 !== Math.floor(n2)) { C.showError(els.resultContent, 'Enter a valid sample size for sample 2 (integer \u2265 2).'); return; }
            r = computeSEDiffProp(p1, n1, p2, n2, conf);
            r.mode = 'diffprop';
        }

        state.results = r;
        renderResults();

        E.renderActionButtons(els.resultActions, {
            toolName: 'Standard Error Calculator',
            getLatex: function() {
                var s = state.results;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Standard Error Calculator}\\\\[4pt]');
                if (s.mode === 'mean') {
                    lines.push('\\sigma = ' + C.fmt(s.sd, 4) + ',\\quad n = ' + s.n + '\\\\');
                    lines.push('\\text{SE} = \\frac{\\sigma}{\\sqrt{n}} = \\frac{' + C.fmt(s.sd, 4) + '}{\\sqrt{' + s.n + '}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.conf, 0) + '\\%} = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\text{ME} = z \\times \\text{SE} = ' + C.fmt(s.z, 4) + ' \\times ' + C.fmt(s.se, 6) + ' = ' + C.fmt(s.me, 6));
                } else if (s.mode === 'proportion') {
                    lines.push('\\hat{p} = ' + C.fmt(s.p, 4) + ',\\quad n = ' + s.n + '\\\\');
                    lines.push('\\text{SE} = \\sqrt{\\frac{\\hat{p}(1-\\hat{p})}{n}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.conf, 0) + '\\%} = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\text{ME} = ' + C.fmt(s.me, 6) + '\\\\');
                    lines.push('\\text{CI} = [' + C.fmt(s.ciLower, 4) + ',\\,' + C.fmt(s.ciUpper, 4) + ']');
                } else if (s.mode === 'diffmean') {
                    lines.push('s_1 = ' + C.fmt(s.s1, 4) + ',\\; n_1 = ' + s.n1 + ',\\; s_2 = ' + C.fmt(s.s2, 4) + ',\\; n_2 = ' + s.n2 + '\\\\');
                    lines.push('\\text{SE} = \\sqrt{\\frac{s_1^2}{n_1} + \\frac{s_2^2}{n_2}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.conf, 0) + '\\%} = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\text{ME} = ' + C.fmt(s.me, 6));
                } else {
                    lines.push('\\hat{p}_1 = ' + C.fmt(s.p1, 4) + ',\\; n_1 = ' + s.n1 + ',\\; \\hat{p}_2 = ' + C.fmt(s.p2, 4) + ',\\; n_2 = ' + s.n2 + '\\\\');
                    lines.push('\\hat{p}_1 - \\hat{p}_2 = ' + C.fmt(s.diff, 6) + '\\\\');
                    lines.push('\\text{SE} = \\sqrt{\\frac{\\hat{p}_1(1-\\hat{p}_1)}{n_1} + \\frac{\\hat{p}_2(1-\\hat{p}_2)}{n_2}} = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push('z_{' + C.fmt(s.conf, 0) + '\\%} = ' + C.fmt(s.z, 4) + '\\\\');
                    lines.push('\\text{ME} = ' + C.fmt(s.me, 6) + '\\\\');
                    lines.push('\\text{CI} = [' + C.fmt(s.ciLower, 4) + ',\\,' + C.fmt(s.ciUpper, 4) + ']');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.results;
                if (!s) return null;
                var shared = { mode: s.mode, conf: s.conf };
                if (s.mode === 'mean') {
                    shared.sd = s.sd; shared.n = s.n;
                } else if (s.mode === 'proportion') {
                    shared.p = s.p; shared.n = s.n;
                } else if (s.mode === 'diffmean') {
                    shared.s1 = s.s1; shared.n1 = s.n1; shared.s2 = s.s2; shared.n2 = s.n2;
                } else {
                    shared.p1 = s.p1; shared.n1 = s.n1; shared.p2 = s.p2; shared.n2 = s.n2;
                }
                return shared;
            },
            resultEl: '#se-result-content'
        });

        var graphTab = document.querySelector('[data-tab="' + PREFIX + 'graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) renderGraph();

        var compilerTab = document.querySelector('[data-tab="' + PREFIX + 'compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) preparePython();
        else if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render Results ===== */
    function renderResults() {
        var r = state.results;
        if (!r) return;
        var h = '';

        if (r.mode === 'mean') {
            h += '<div class="stat-hero"><span class="stat-hero-value">SE = ' + C.fmt(r.se, 6) + '</span><span class="stat-hero-label">Standard Error of the Mean</span></div>';
            h += buildSection('Standard Error', [
                ['Standard Error (SE)', C.fmt(r.se, 6)],
                ['Standard Deviation (\u03C3)', C.fmt(r.sd, 4)],
                ['Sample Size (n)', r.n]
            ]);
            h += buildSection('Margin of Error', [
                ['Confidence Level', C.fmt(r.conf, 1) + '%'],
                ['Critical Value (z)', C.fmt(r.z, 4)],
                ['Margin of Error (ME = z \u00D7 SE)', C.fmt(r.me, 6)]
            ]);
            h += buildSteps('mean', r);
            h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> With a standard deviation of ' + C.fmt(r.sd, 4) + ' and a sample size of ' + r.n + ', the standard error of the mean is ' + C.fmt(r.se, 6) + '. At a ' + C.fmt(r.conf, 0) + '% confidence level, the margin of error is \u00B1' + C.fmt(r.me, 4) + '. This means the sample mean is expected to be within ' + C.fmt(r.me, 4) + ' units of the true population mean.</div>';

        } else if (r.mode === 'proportion') {
            h += '<div class="stat-hero"><span class="stat-hero-value">SE = ' + C.fmt(r.se, 6) + '</span><span class="stat-hero-label">Standard Error of the Proportion</span></div>';
            h += buildSection('Standard Error', [
                ['Standard Error (SE)', C.fmt(r.se, 6)],
                ['Proportion (\u0070\u0302)', C.fmt(r.p, 4)],
                ['Sample Size (n)', r.n]
            ]);
            h += buildSection('Margin of Error', [
                ['Confidence Level', C.fmt(r.conf, 1) + '%'],
                ['Critical Value (z)', C.fmt(r.z, 4)],
                ['Margin of Error (ME = z \u00D7 SE)', C.fmt(r.me, 6)]
            ]);
            h += buildSection('Confidence Interval', [
                ['Lower Bound', C.fmt(r.ciLower, 6)],
                ['Upper Bound', C.fmt(r.ciUpper, 6)],
                ['CI (percentage)', C.fmt(r.ciLower * 100, 2) + '% \u2013 ' + C.fmt(r.ciUpper * 100, 2) + '%']
            ]);
            h += buildSteps('proportion', r);
            h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> With a sample proportion of ' + C.fmt(r.p, 4) + ' and n = ' + r.n + ', the standard error is ' + C.fmt(r.se, 6) + '. The ' + C.fmt(r.conf, 0) + '% confidence interval for the true proportion is [' + C.fmt(r.ciLower, 4) + ', ' + C.fmt(r.ciUpper, 4) + '], or roughly ' + C.fmt(r.ciLower * 100, 2) + '% to ' + C.fmt(r.ciUpper * 100, 2) + '%.</div>';

        } else if (r.mode === 'diffmean') {
            h += '<div class="stat-hero"><span class="stat-hero-value">SE = ' + C.fmt(r.se, 6) + '</span><span class="stat-hero-label">Standard Error of the Difference in Means</span></div>';
            h += buildSection('Standard Error', [
                ['Standard Error (SE)', C.fmt(r.se, 6)],
                ['SD 1 (s\u2081)', C.fmt(r.s1, 4)],
                ['n\u2081', r.n1],
                ['SD 2 (s\u2082)', C.fmt(r.s2, 4)],
                ['n\u2082', r.n2]
            ]);
            h += buildSection('Margin of Error', [
                ['Confidence Level', C.fmt(r.conf, 1) + '%'],
                ['Critical Value (z)', C.fmt(r.z, 4)],
                ['Margin of Error (ME = z \u00D7 SE)', C.fmt(r.me, 6)]
            ]);
            h += buildSteps('diffmean', r);
            h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The standard error for the difference between two means (s\u2081 = ' + C.fmt(r.s1, 2) + ', n\u2081 = ' + r.n1 + '; s\u2082 = ' + C.fmt(r.s2, 2) + ', n\u2082 = ' + r.n2 + ') is ' + C.fmt(r.se, 6) + '. At a ' + C.fmt(r.conf, 0) + '% confidence level, the margin of error for the difference is \u00B1' + C.fmt(r.me, 4) + '.</div>';

        } else {
            h += '<div class="stat-hero"><span class="stat-hero-value">SE = ' + C.fmt(r.se, 6) + '</span><span class="stat-hero-label">Standard Error of the Difference in Proportions</span></div>';
            h += buildSection('Standard Error', [
                ['Standard Error (SE)', C.fmt(r.se, 6)],
                ['Proportion 1 (\u0070\u0302\u2081)', C.fmt(r.p1, 4)],
                ['n\u2081', r.n1],
                ['Proportion 2 (\u0070\u0302\u2082)', C.fmt(r.p2, 4)],
                ['n\u2082', r.n2],
                ['Difference (\u0070\u0302\u2081 \u2212 \u0070\u0302\u2082)', C.fmt(r.diff, 6)]
            ]);
            h += buildSection('Margin of Error', [
                ['Confidence Level', C.fmt(r.conf, 1) + '%'],
                ['Critical Value (z)', C.fmt(r.z, 4)],
                ['Margin of Error (ME = z \u00D7 SE)', C.fmt(r.me, 6)]
            ]);
            h += buildSection('Confidence Interval', [
                ['Lower Bound', C.fmt(r.ciLower, 6)],
                ['Upper Bound', C.fmt(r.ciUpper, 6)],
                ['Difference', C.fmt(r.diff, 6)]
            ]);
            h += buildSteps('diffprop', r);
            var sig = (r.ciLower > 0 || r.ciUpper < 0) ? 'The interval does not contain 0, suggesting a statistically significant difference between the two proportions.' : 'The interval contains 0, so the difference is not statistically significant at this level.';
            h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> The standard error for the difference in proportions (\u0070\u0302\u2081 = ' + C.fmt(r.p1, 4) + ', \u0070\u0302\u2082 = ' + C.fmt(r.p2, 4) + ') is ' + C.fmt(r.se, 6) + '. The ' + C.fmt(r.conf, 0) + '% confidence interval for the difference is [' + C.fmt(r.ciLower, 4) + ', ' + C.fmt(r.ciUpper, 4) + ']. ' + sig + '</div>';
        }

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

    function step(num, title, content) {
        return '<div class="stat-step"><div class="stat-step-number">' + num + '</div><div class="stat-step-content"><strong>' + title + '</strong><div style="margin-top:0.25rem">' + content + '</div></div></div>';
    }

    function buildSteps(mode, r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        if (mode === 'mean') {
            h += step(1, 'Formula', '<span class="stat-katex" data-tex="\\text{SE} = \\frac{\\sigma}{\\sqrt{n}}"></span>');
            h += step(2, 'Substitute Values', '<span class="stat-katex" data-tex="\\text{SE} = \\frac{' + C.fmt(r.sd, 4) + '}{\\sqrt{' + r.n + '}} = \\frac{' + C.fmt(r.sd, 4) + '}{' + C.fmt(Math.sqrt(r.n), 4) + '} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(3, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.conf, 0) + '\\%} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(4, 'Margin of Error', '<span class="stat-katex" data-tex="\\text{ME} = z \\times \\text{SE} = ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = ' + C.fmt(r.me, 6) + '"></span>');

        } else if (mode === 'proportion') {
            h += step(1, 'Formula', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{\\hat{p}(1-\\hat{p})}{n}}"></span>');
            h += step(2, 'Substitute Values', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{' + C.fmt(r.p, 4) + ' \\times ' + C.fmt(1 - r.p, 4) + '}{' + r.n + '}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(3, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.conf, 0) + '\\%} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(4, 'Margin of Error', '<span class="stat-katex" data-tex="\\text{ME} = z \\times \\text{SE} = ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = ' + C.fmt(r.me, 6) + '"></span>');
            h += step(5, 'Confidence Interval', '<span class="stat-katex" data-tex="\\hat{p} \\pm \\text{ME} = ' + C.fmt(r.p, 4) + ' \\pm ' + C.fmt(r.me, 4) + ' = [' + C.fmt(r.ciLower, 4) + ',\\,' + C.fmt(r.ciUpper, 4) + ']"></span>');

        } else if (mode === 'diffmean') {
            h += step(1, 'Formula', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{s_1^2}{n_1} + \\frac{s_2^2}{n_2}}"></span>');
            h += step(2, 'Substitute Values', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{' + C.fmt(r.s1, 4) + '^2}{' + r.n1 + '} + \\frac{' + C.fmt(r.s2, 4) + '^2}{' + r.n2 + '}} = \\sqrt{' + C.fmt(r.s1 * r.s1 / r.n1, 4) + ' + ' + C.fmt(r.s2 * r.s2 / r.n2, 4) + '} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(3, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.conf, 0) + '\\%} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(4, 'Margin of Error', '<span class="stat-katex" data-tex="\\text{ME} = z \\times \\text{SE} = ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = ' + C.fmt(r.me, 6) + '"></span>');

        } else {
            h += step(1, 'Difference', '<span class="stat-katex" data-tex="\\hat{p}_1 - \\hat{p}_2 = ' + C.fmt(r.p1, 4) + ' - ' + C.fmt(r.p2, 4) + ' = ' + C.fmt(r.diff, 6) + '"></span>');
            h += step(2, 'Formula', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{\\hat{p}_1(1-\\hat{p}_1)}{n_1} + \\frac{\\hat{p}_2(1-\\hat{p}_2)}{n_2}}"></span>');
            h += step(3, 'Substitute Values', '<span class="stat-katex" data-tex="\\text{SE} = \\sqrt{\\frac{' + C.fmt(r.p1, 4) + ' \\times ' + C.fmt(1 - r.p1, 4) + '}{' + r.n1 + '} + \\frac{' + C.fmt(r.p2, 4) + ' \\times ' + C.fmt(1 - r.p2, 4) + '}{' + r.n2 + '}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(4, 'Critical Value', '<span class="stat-katex" data-tex="z_{' + C.fmt(r.conf, 0) + '\\%} = ' + C.fmt(r.z, 4) + '"></span>');
            h += step(5, 'Margin of Error', '<span class="stat-katex" data-tex="\\text{ME} = z \\times \\text{SE} = ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = ' + C.fmt(r.me, 6) + '"></span>');
            h += step(6, 'Confidence Interval', '<span class="stat-katex" data-tex="(\\hat{p}_1 - \\hat{p}_2) \\pm \\text{ME} = ' + C.fmt(r.diff, 4) + ' \\pm ' + C.fmt(r.me, 4) + ' = [' + C.fmt(r.ciLower, 4) + ',\\,' + C.fmt(r.ciUpper, 4) + ']"></span>');
        }

        return h + '</div>';
    }

    function renderKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var tex = spans[i].getAttribute('data-tex');
            if (tex && window.katex) {
                try { window.katex.render(tex, spans[i], { throwOnError: false }); } catch (e) {}
            }
        }
    }

    /* ===== Graph ===== */
    function renderGraph() {
        if (!state.results) return;
        G.loadPlotly(function(Plotly) {
            var r = state.results;
            var container = document.getElementById(PREFIX + 'graph-container');
            if (!container) return;
            container.innerHTML = '';

            var colors = G.getPlotColors();
            var primaryColor = colors.primary || '#6366f1';
            var accentColor = colors.accent || '#ef4444';
            var bgColor = colors.bg || '#ffffff';
            var textColor = colors.text || '#1e293b';
            var gridColor = colors.grid || '#e2e8f0';

            if (r.mode === 'mean') {
                var center = 0;
                var lo = center - r.me;
                var hi = center + r.me;
                var xRange = [lo - r.me * 0.5, hi + r.me * 0.5];
                var traces = [
                    { x: [lo, hi], y: [1, 1], mode: 'lines', line: { color: primaryColor, width: 6 }, name: C.fmt(r.conf, 0) + '% CI Range', showlegend: true },
                    { x: [lo], y: [1], mode: 'markers', marker: { size: 12, color: primaryColor, symbol: 'line-ns-open', line: { width: 3 } }, name: 'Lower: \u2212' + C.fmt(r.me, 4), showlegend: true },
                    { x: [hi], y: [1], mode: 'markers', marker: { size: 12, color: primaryColor, symbol: 'line-ns-open', line: { width: 3 } }, name: 'Upper: +' + C.fmt(r.me, 4), showlegend: true },
                    { x: [center], y: [1], mode: 'markers', marker: { size: 14, color: accentColor, symbol: 'diamond' }, name: 'Mean (center)', showlegend: true }
                ];
                var layout = {
                    title: { text: 'Confidence Interval Around the Mean', font: { color: textColor } },
                    xaxis: { title: 'Deviation from Mean', range: xRange, zeroline: true, zerolinecolor: gridColor, gridcolor: gridColor, color: textColor },
                    yaxis: { visible: false, range: [0.5, 1.5] },
                    showlegend: true, legend: { orientation: 'h', y: -0.25, font: { color: textColor } },
                    margin: { t: 50, b: 70, l: 40, r: 40 },
                    height: 280,
                    paper_bgcolor: bgColor, plot_bgcolor: bgColor,
                    annotations: [
                        { x: lo, y: 1.2, text: '\u2212' + C.fmt(r.me, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: hi, y: 1.2, text: '+' + C.fmt(r.me, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: center, y: 0.8, text: 'SE = ' + C.fmt(r.se, 4), showarrow: false, font: { size: 11, color: accentColor } }
                    ]
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });

            } else if (r.mode === 'proportion') {
                var lo = r.ciLower;
                var hi = r.ciUpper;
                var pt = r.p;
                var pad = (hi - lo) * 0.3;
                var traces = [
                    { x: [lo, hi], y: [1, 1], mode: 'lines', line: { color: primaryColor, width: 6 }, name: C.fmt(r.conf, 0) + '% CI', showlegend: true },
                    { x: [pt], y: [1], mode: 'markers', marker: { size: 14, color: accentColor, symbol: 'diamond' }, name: '\u0070\u0302 = ' + C.fmt(pt, 4), showlegend: true }
                ];
                var layout = {
                    title: { text: 'Confidence Interval for Proportion', font: { color: textColor } },
                    xaxis: { title: 'Proportion', range: [lo - pad, hi + pad], zeroline: false, gridcolor: gridColor, color: textColor },
                    yaxis: { visible: false, range: [0.5, 1.5] },
                    showlegend: true, legend: { orientation: 'h', y: -0.25, font: { color: textColor } },
                    margin: { t: 50, b: 70, l: 40, r: 40 },
                    height: 280,
                    paper_bgcolor: bgColor, plot_bgcolor: bgColor,
                    annotations: [
                        { x: lo, y: 1.15, text: C.fmt(lo, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: hi, y: 1.15, text: C.fmt(hi, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: pt, y: 0.82, text: C.fmt(pt, 4), showarrow: false, font: { size: 11, color: accentColor } }
                    ]
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });

            } else if (r.mode === 'diffmean') {
                var center = 0;
                var lo = center - r.me;
                var hi = center + r.me;
                var pad = r.me * 0.5;
                var traces = [
                    { x: [lo, hi], y: [1, 1], mode: 'lines', line: { color: primaryColor, width: 6 }, name: '\u00B1 ME = ' + C.fmt(r.me, 4), showlegend: true },
                    { x: [center], y: [1], mode: 'markers', marker: { size: 14, color: accentColor, symbol: 'diamond' }, name: 'Diff = 0 (center)', showlegend: true }
                ];
                var layout = {
                    title: { text: 'Margin of Error for Difference in Means', font: { color: textColor } },
                    xaxis: { title: 'Difference', range: [lo - pad, hi + pad], zeroline: true, zerolinecolor: gridColor, gridcolor: gridColor, color: textColor },
                    yaxis: { visible: false, range: [0.5, 1.5] },
                    showlegend: true, legend: { orientation: 'h', y: -0.25, font: { color: textColor } },
                    margin: { t: 50, b: 70, l: 40, r: 40 },
                    height: 280,
                    paper_bgcolor: bgColor, plot_bgcolor: bgColor,
                    annotations: [
                        { x: lo, y: 1.15, text: C.fmt(lo, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: hi, y: 1.15, text: C.fmt(hi, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: center, y: 0.82, text: 'SE = ' + C.fmt(r.se, 4), showarrow: false, font: { size: 11, color: accentColor } }
                    ]
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });

            } else {
                var lo = r.ciLower;
                var hi = r.ciUpper;
                var pt = r.diff;
                var pad = Math.max(Math.abs(hi - lo) * 0.3, 0.01);
                var traces = [
                    { x: [lo, hi], y: [1, 1], mode: 'lines', line: { color: primaryColor, width: 6 }, name: C.fmt(r.conf, 0) + '% CI', showlegend: true },
                    { x: [pt], y: [1], mode: 'markers', marker: { size: 14, color: accentColor, symbol: 'diamond' }, name: 'Diff = ' + C.fmt(pt, 4), showlegend: true },
                    { x: [0], y: [1], mode: 'markers', marker: { size: 10, color: gridColor, symbol: 'line-ns-open', line: { width: 2, color: textColor } }, name: 'Zero (no effect)', showlegend: true }
                ];
                var layout = {
                    title: { text: 'Confidence Interval for Difference in Proportions', font: { color: textColor } },
                    xaxis: { title: 'Difference in Proportions', range: [Math.min(lo, 0) - pad, Math.max(hi, 0) + pad], zeroline: true, zerolinecolor: textColor, zerolinewidth: 1, gridcolor: gridColor, color: textColor },
                    yaxis: { visible: false, range: [0.5, 1.5] },
                    showlegend: true, legend: { orientation: 'h', y: -0.25, font: { color: textColor } },
                    margin: { t: 50, b: 70, l: 40, r: 40 },
                    height: 280,
                    paper_bgcolor: bgColor, plot_bgcolor: bgColor,
                    annotations: [
                        { x: lo, y: 1.15, text: C.fmt(lo, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: hi, y: 1.15, text: C.fmt(hi, 4), showarrow: false, font: { size: 11, color: textColor } },
                        { x: pt, y: 0.82, text: C.fmt(pt, 4), showarrow: false, font: { size: 11, color: accentColor } }
                    ]
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
            }
        });
    }

    /* ===== Python Compiler ===== */
    function preparePython() {
        if (!state.results || !els.compilerIframe) return;
        var r = state.results;
        var lines = [];

        if (r.mode === 'mean') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('# Standard Error of the Mean');
            lines.push('sd = ' + r.sd);
            lines.push('n = ' + r.n);
            lines.push('conf = ' + r.conf / 100);
            lines.push('');
            lines.push('se = sd / math.sqrt(n)');
            lines.push('z = stats.norm.ppf((1 + conf) / 2)');
            lines.push('me = z * se');
            lines.push('');
            lines.push('print(f"Standard Error: {se:.6f}")');
            lines.push('print(f"Z-score ({conf*100:.0f}%): {z:.4f}")');
            lines.push('print(f"Margin of Error: {me:.6f}")');

        } else if (r.mode === 'proportion') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('# Standard Error of a Proportion');
            lines.push('p = ' + r.p);
            lines.push('n = ' + r.n);
            lines.push('conf = ' + r.conf / 100);
            lines.push('');
            lines.push('se = math.sqrt(p * (1 - p) / n)');
            lines.push('z = stats.norm.ppf((1 + conf) / 2)');
            lines.push('me = z * se');
            lines.push('ci_lower = max(0, p - me)');
            lines.push('ci_upper = min(1, p + me)');
            lines.push('');
            lines.push('print(f"Standard Error: {se:.6f}")');
            lines.push('print(f"Z-score ({conf*100:.0f}%): {z:.4f}")');
            lines.push('print(f"Margin of Error: {me:.6f}")');
            lines.push('print(f"{conf*100:.0f}% CI: [{ci_lower:.6f}, {ci_upper:.6f}]")');

        } else if (r.mode === 'diffmean') {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('# Standard Error of the Difference in Means');
            lines.push('s1, n1 = ' + r.s1 + ', ' + r.n1);
            lines.push('s2, n2 = ' + r.s2 + ', ' + r.n2);
            lines.push('conf = ' + r.conf / 100);
            lines.push('');
            lines.push('se = math.sqrt(s1**2 / n1 + s2**2 / n2)');
            lines.push('z = stats.norm.ppf((1 + conf) / 2)');
            lines.push('me = z * se');
            lines.push('');
            lines.push('print(f"Standard Error: {se:.6f}")');
            lines.push('print(f"Z-score ({conf*100:.0f}%): {z:.4f}")');
            lines.push('print(f"Margin of Error: {me:.6f}")');

        } else {
            lines.push('from scipy import stats');
            lines.push('import math');
            lines.push('');
            lines.push('# Standard Error of the Difference in Proportions');
            lines.push('p1, n1 = ' + r.p1 + ', ' + r.n1);
            lines.push('p2, n2 = ' + r.p2 + ', ' + r.n2);
            lines.push('conf = ' + r.conf / 100);
            lines.push('');
            lines.push('se = math.sqrt(p1*(1-p1)/n1 + p2*(1-p2)/n2)');
            lines.push('diff = p1 - p2');
            lines.push('z = stats.norm.ppf((1 + conf) / 2)');
            lines.push('me = z * se');
            lines.push('ci_lower = diff - me');
            lines.push('ci_upper = diff + me');
            lines.push('');
            lines.push('print(f"Difference: {diff:.6f}")');
            lines.push('print(f"Standard Error: {se:.6f}")');
            lines.push('print(f"Z-score ({conf*100:.0f}%): {z:.4f}")');
            lines.push('print(f"Margin of Error: {me:.6f}")');
            lines.push('print(f"{conf*100:.0f}% CI: [{ci_lower:.6f}, {ci_upper:.6f}]")');
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
        if (els.compilerIframe) els.compilerIframe.removeAttribute('src');
        var gc = document.getElementById(PREFIX + 'graph-container');
        if (gc) gc.innerHTML = '';
        state.results = null;

        // Reset inputs based on current mode
        var inputs = document.querySelectorAll('input[id^="se-"]');
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].type === 'number' || inputs[i].type === 'text') {
                inputs[i].value = '';
            }
        }
    }

    /* ===== Restore from URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared) return false;
        if (shared.mode) setMode(shared.mode);
        if (shared.conf) {
            state.confidence = parseFloat(shared.conf);
            document.querySelectorAll('.se-conf-pill').forEach(function(p) {
                p.classList.toggle('active', p.getAttribute('data-conf') === String(shared.conf));
            });
        }
        if (shared.mode === 'mean') {
            if (shared.sd) document.getElementById(PREFIX + 'sd').value = shared.sd;
            if (shared.n) document.getElementById(PREFIX + 'n').value = shared.n;
        } else if (shared.mode === 'proportion') {
            if (shared.p) document.getElementById(PREFIX + 'p').value = shared.p;
            if (shared.n) document.getElementById(PREFIX + 'n-prop').value = shared.n;
        } else if (shared.mode === 'diffmean') {
            if (shared.s1) document.getElementById(PREFIX + 'sd1').value = shared.s1;
            if (shared.n1) document.getElementById(PREFIX + 'n1').value = shared.n1;
            if (shared.s2) document.getElementById(PREFIX + 'sd2').value = shared.s2;
            if (shared.n2) document.getElementById(PREFIX + 'n2').value = shared.n2;
        } else if (shared.mode === 'diffprop') {
            if (shared.p1) document.getElementById(PREFIX + 'p1').value = shared.p1;
            if (shared.n1) document.getElementById(PREFIX + 'n1-prop').value = shared.n1;
            if (shared.p2) document.getElementById(PREFIX + 'p2').value = shared.p2;
            if (shared.n2) document.getElementById(PREFIX + 'n2-prop').value = shared.n2;
        }
        calculate();
        return true;
    }

    /* ===== Quick Examples ===== */
    var EXAMPLES = {
        'survey-mean': { mode: 'mean', sd: 15, n: 36, desc: 'Survey (SE of Mean)' },
        'election-poll': { mode: 'proportion', p: 0.52, n: 1000, desc: 'Election Poll (SE of Proportion)' },
        'drug-trial': { mode: 'diffmean', s1: 10, n1: 30, s2: 12, n2: 35, desc: 'Drug Trial (Diff Means)' },
        'ab-test': { mode: 'diffprop', p1: 0.12, n1: 500, p2: 0.10, n2: 500, desc: 'A/B Test (Diff Proportions)' }
    };

    function applyExample(key) {
        var ex = EXAMPLES[key];
        if (!ex) return;

        setMode(ex.mode);

        if (ex.mode === 'mean') {
            document.getElementById(PREFIX + 'sd').value = ex.sd;
            document.getElementById(PREFIX + 'n').value = ex.n;
        } else if (ex.mode === 'proportion') {
            document.getElementById(PREFIX + 'p').value = ex.p;
            document.getElementById(PREFIX + 'n-prop').value = ex.n;
        } else if (ex.mode === 'diffmean') {
            document.getElementById(PREFIX + 'sd1').value = ex.s1;
            document.getElementById(PREFIX + 'n1').value = ex.n1;
            document.getElementById(PREFIX + 'sd2').value = ex.s2;
            document.getElementById(PREFIX + 'n2').value = ex.n2;
        } else if (ex.mode === 'diffprop') {
            document.getElementById(PREFIX + 'p1').value = ex.p1;
            document.getElementById(PREFIX + 'n1-prop').value = ex.n1;
            document.getElementById(PREFIX + 'p2').value = ex.p2;
            document.getElementById(PREFIX + 'n2-prop').value = ex.n2;
        }

        state.confidence = 95;
        document.querySelectorAll('.se-conf-pill').forEach(function(p) {
            p.classList.toggle('active', p.getAttribute('data-conf') === '95');
        });
        var customEl = document.getElementById(PREFIX + 'custom-conf');
        if (customEl) customEl.style.display = 'none';

        calculate();
    }

    /* ===== FAQ Accordion ===== */
    function initFAQ() {
        var questions = document.querySelectorAll('.faq-question');
        for (var i = 0; i < questions.length; i++) {
            questions[i].addEventListener('click', function() {
                var item = this.parentElement;
                if (item && item.classList.contains('faq-item')) {
                    item.classList.toggle('open');
                }
            });
        }
    }

    /* ===== Scroll Reveal (IntersectionObserver) ===== */
    function initScrollReveal() {
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('stat-visible');
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) {
                observer.observe(el);
            });
        }
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();
        initConfPills();
        initFAQ();
        initScrollReveal();

        if (els.calcBtn) els.calcBtn.addEventListener('click', calculate);
        if (els.clearBtn) els.clearBtn.addEventListener('click', clearAll);

        // Enter key on inputs triggers calculate
        var inputs = document.querySelectorAll('.se-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) {
                if (e.key === 'Enter') calculate();
            });
        }

        // Quick example chips
        document.querySelectorAll('[data-se-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-se-example'));
            });
        });

        // Restore from shared URL, or fall back to default example
        setMode('mean');
        if (!restoreFromUrl()) {
            applyExample('survey-mean');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
