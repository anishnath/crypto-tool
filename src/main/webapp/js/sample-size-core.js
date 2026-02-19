/**
 * Sample Size Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Pure JS Z-score computation — no jStat needed.
 * Uses Plotly (lazy-loaded) for sample-size visualization chart.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== Z-score table ===== */
    var Z_TABLE = { 80: 1.282, 85: 1.44, 90: 1.645, 95: 1.96, 98: 2.326, 99: 2.576, 99.5: 2.807, 99.9: 3.291 };

    /* ===== State ===== */
    var state = {
        mode: 'survey',
        confLevel: 95,
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('ss-result-content');
        els.resultActions  = document.getElementById('ss-result-actions');
        els.graphPanel     = document.getElementById('ss-graph-panel');
        els.graphContainer = document.getElementById('ss-graph-container');
        els.compilerPanel  = document.getElementById('ss-compiler-panel');
        els.compilerIframe = document.getElementById('ss-compiler-iframe');
        els.calcBtn        = document.getElementById('ss-calc-btn');
        els.clearBtn       = document.getElementById('ss-clear-btn');

        els.modeSurvey  = document.getElementById('ss-mode-survey');
        els.modeMean    = document.getElementById('ss-mode-mean');
        els.modeAB      = document.getElementById('ss-mode-ab');
        els.modeCompare = document.getElementById('ss-mode-compare');

        els.panelSurvey  = document.getElementById('ss-input-survey');
        els.panelMean    = document.getElementById('ss-input-mean');
        els.panelAB      = document.getElementById('ss-input-ab');
        els.panelCompare = document.getElementById('ss-input-compare');
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
                if (target === 'ss-graph-panel') loadGraph();
                if (target === 'ss-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeSurvey.addEventListener('click', function() { setMode('survey'); });
        els.modeMean.addEventListener('click', function() { setMode('mean'); });
        els.modeAB.addEventListener('click', function() { setMode('ab'); });
        els.modeCompare.addEventListener('click', function() { setMode('compare'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeSurvey.classList.toggle('active', m === 'survey');
        els.modeMean.classList.toggle('active', m === 'mean');
        els.modeAB.classList.toggle('active', m === 'ab');
        els.modeCompare.classList.toggle('active', m === 'compare');
        els.panelSurvey.style.display  = m === 'survey'  ? '' : 'none';
        els.panelMean.style.display    = m === 'mean'    ? '' : 'none';
        els.panelAB.style.display      = m === 'ab'      ? '' : 'none';
        els.panelCompare.style.display = m === 'compare' ? '' : 'none';
    }

    /* ===== Confidence Level ===== */
    function initConfLevel() {
        document.querySelectorAll('.ss-conf-pill').forEach(function(pill) {
            pill.addEventListener('click', function() {
                document.querySelectorAll('.ss-conf-pill').forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                var val = this.getAttribute('data-conf');
                if (val === 'custom') {
                    var customEl = document.getElementById('ss-custom-conf');
                    if (customEl) customEl.style.display = '';
                } else {
                    state.confLevel = parseFloat(val);
                    var customEl = document.getElementById('ss-custom-conf');
                    if (customEl) customEl.style.display = 'none';
                }
            });
        });
        var customInput = document.getElementById('ss-custom-conf');
        if (customInput) {
            customInput.addEventListener('change', function() {
                var v = parseFloat(this.value);
                if (!isNaN(v) && v > 0 && v < 100) state.confLevel = v;
            });
        }
    }

    function getConfLevel() {
        var activePill = document.querySelector('.ss-conf-pill.active');
        if (activePill && activePill.getAttribute('data-conf') === 'custom') {
            var customEl = document.getElementById('ss-custom-conf');
            var v = customEl ? parseFloat(customEl.value) : 95;
            return (!isNaN(v) && v > 0 && v < 100) ? v : 95;
        }
        return state.confLevel;
    }

    /* ===== Z-score Helper ===== */
    function getZScore(confPercent) {
        if (Z_TABLE[confPercent] !== undefined) return Z_TABLE[confPercent];
        // Linear interpolation between nearest table entries
        var keys = Object.keys(Z_TABLE).map(Number).sort(function(a, b) { return a - b; });
        for (var i = 0; i < keys.length - 1; i++) {
            if (confPercent >= keys[i] && confPercent <= keys[i + 1]) {
                var frac = (confPercent - keys[i]) / (keys[i + 1] - keys[i]);
                return Z_TABLE[keys[i]] + frac * (Z_TABLE[keys[i + 1]] - Z_TABLE[keys[i]]);
            }
        }
        return 1.96; // fallback
    }

    function getZBeta(powerPercent) {
        // Power Z-scores: one-tailed
        var table = { 80: 0.842, 85: 1.036, 90: 1.282, 95: 1.645, 99: 2.326 };
        if (table[powerPercent] !== undefined) return table[powerPercent];
        var keys = Object.keys(table).map(Number).sort(function(a, b) { return a - b; });
        for (var i = 0; i < keys.length - 1; i++) {
            if (powerPercent >= keys[i] && powerPercent <= keys[i + 1]) {
                var frac = (powerPercent - keys[i]) / (keys[i + 1] - keys[i]);
                return table[keys[i]] + frac * (table[keys[i + 1]] - table[keys[i]]);
            }
        }
        return 0.842;
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var r;
        var conf = getConfLevel();
        var Z = getZScore(conf);

        if (state.mode === 'survey') {
            var p = parseFloat(document.getElementById('ss-proportion').value);
            var E_val = parseFloat(document.getElementById('ss-margin-error').value);
            var Nraw = document.getElementById('ss-pop-size').value.trim();
            var N = Nraw !== '' ? parseFloat(Nraw) : null;
            if (isNaN(p) || p <= 0 || p >= 1) { C.showError(els.resultContent, 'Enter a valid proportion (0 < p < 1).'); return; }
            if (isNaN(E_val) || E_val <= 0) { C.showError(els.resultContent, 'Enter a valid margin of error (> 0).'); return; }
            if (N !== null && (isNaN(N) || N < 1)) { C.showError(els.resultContent, 'Enter a valid population size (> 0) or leave blank.'); return; }
            var n0 = (Z * Z * p * (1 - p)) / (E_val * E_val);
            var n;
            if (N !== null) {
                n = Math.ceil(n0 / (1 + (n0 - 1) / N));
            } else {
                n = Math.ceil(n0);
            }
            r = { mode: 'survey', p: p, E: E_val, N: N, Z: Z, conf: conf, n0: n0, n: n };
            renderSurveyResult(r);

        } else if (state.mode === 'mean') {
            var sigma = parseFloat(document.getElementById('ss-std-dev').value);
            var E_val = parseFloat(document.getElementById('ss-margin-error-mean').value);
            var Nraw = document.getElementById('ss-pop-size-mean').value.trim();
            var N = Nraw !== '' ? parseFloat(Nraw) : null;
            if (isNaN(sigma) || sigma <= 0) { C.showError(els.resultContent, 'Enter a valid standard deviation (> 0).'); return; }
            if (isNaN(E_val) || E_val <= 0) { C.showError(els.resultContent, 'Enter a valid margin of error (> 0).'); return; }
            if (N !== null && (isNaN(N) || N < 1)) { C.showError(els.resultContent, 'Enter a valid population size (> 0) or leave blank.'); return; }
            var n0 = (Z * Z * sigma * sigma) / (E_val * E_val);
            var n;
            if (N !== null) {
                n = Math.ceil(n0 / (1 + (n0 - 1) / N));
            } else {
                n = Math.ceil(n0);
            }
            r = { mode: 'mean', sigma: sigma, E: E_val, N: N, Z: Z, conf: conf, n0: n0, n: n };
            renderMeanResult(r);

        } else if (state.mode === 'ab') {
            var p1 = parseFloat(document.getElementById('ss-p1').value);
            var p2 = parseFloat(document.getElementById('ss-p2').value);
            var power = parseFloat(document.getElementById('ss-power').value);
            if (isNaN(p1) || p1 <= 0 || p1 >= 1) { C.showError(els.resultContent, 'Enter a valid baseline rate p1 (0 < p1 < 1).'); return; }
            if (isNaN(p2) || p2 <= 0 || p2 >= 1) { C.showError(els.resultContent, 'Enter a valid expected rate p2 (0 < p2 < 1).'); return; }
            if (p1 === p2) { C.showError(els.resultContent, 'p1 and p2 must be different.'); return; }
            if (isNaN(power) || power <= 0 || power >= 100) { C.showError(els.resultContent, 'Enter a valid power (0 < power < 100).'); return; }
            var pbar = (p1 + p2) / 2;
            var delta = Math.abs(p2 - p1);
            var Zbeta = getZBeta(power);
            var nPerGroup = Math.ceil(2 * Math.pow(Z + Zbeta, 2) * pbar * (1 - pbar) / (delta * delta));
            var total = 2 * nPerGroup;
            r = { mode: 'ab', p1: p1, p2: p2, power: power, pbar: pbar, delta: delta, Z: Z, Zbeta: Zbeta, conf: conf, nPerGroup: nPerGroup, total: total };
            renderABResult(r);

        } else {
            var sigma = parseFloat(document.getElementById('ss-pooled-sd').value);
            var delta = parseFloat(document.getElementById('ss-effect-size').value);
            var power = parseFloat(document.getElementById('ss-power-means').value);
            if (isNaN(sigma) || sigma <= 0) { C.showError(els.resultContent, 'Enter a valid pooled standard deviation (> 0).'); return; }
            if (isNaN(delta) || delta <= 0) { C.showError(els.resultContent, 'Enter a valid effect size / difference (> 0).'); return; }
            if (isNaN(power) || power <= 0 || power >= 100) { C.showError(els.resultContent, 'Enter a valid power (0 < power < 100).'); return; }
            var Zbeta = getZBeta(power);
            var nPerGroup = Math.ceil(2 * Math.pow((Z + Zbeta) * sigma / delta, 2));
            var total = 2 * nPerGroup;
            r = { mode: 'compare', sigma: sigma, delta: delta, power: power, Z: Z, Zbeta: Zbeta, conf: conf, nPerGroup: nPerGroup, total: total };
            renderCompareResult(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Sample Size Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Sample Size Calculator}\\\\[4pt]');
                lines.push('\\text{Mode: ' + s.mode + '}\\\\[2pt]');
                lines.push('\\text{Confidence Level: } ' + C.fmt(s.conf, 1) + '\\%\\\\');
                lines.push('Z = ' + C.fmt(s.Z, 4) + '\\\\');
                if (s.mode === 'survey') {
                    lines.push('p = ' + C.fmt(s.p, 4) + '\\\\');
                    lines.push('E = ' + C.fmt(s.E, 4) + '\\\\');
                    if (s.N !== null) lines.push('N = ' + C.fmt(s.N, 0) + '\\\\');
                    lines.push('n_0 = \\frac{Z^2 \\cdot p(1-p)}{E^2} = ' + C.fmt(s.n0, 2) + '\\\\');
                    if (s.N !== null) {
                        lines.push('n = \\frac{n_0}{1 + \\frac{n_0-1}{N}} = ' + C.fmt(s.n, 0));
                    } else {
                        lines.push('n = \\lceil n_0 \\rceil = ' + C.fmt(s.n, 0));
                    }
                } else if (s.mode === 'mean') {
                    lines.push('\\sigma = ' + C.fmt(s.sigma, 4) + '\\\\');
                    lines.push('E = ' + C.fmt(s.E, 4) + '\\\\');
                    if (s.N !== null) lines.push('N = ' + C.fmt(s.N, 0) + '\\\\');
                    lines.push('n_0 = \\frac{Z^2 \\cdot \\sigma^2}{E^2} = ' + C.fmt(s.n0, 2) + '\\\\');
                    if (s.N !== null) {
                        lines.push('n = \\frac{n_0}{1 + \\frac{n_0-1}{N}} = ' + C.fmt(s.n, 0));
                    } else {
                        lines.push('n = \\lceil n_0 \\rceil = ' + C.fmt(s.n, 0));
                    }
                } else if (s.mode === 'ab') {
                    lines.push('p_1 = ' + C.fmt(s.p1, 4) + ', \\quad p_2 = ' + C.fmt(s.p2, 4) + '\\\\');
                    lines.push('\\bar{p} = ' + C.fmt(s.pbar, 4) + ', \\quad \\Delta = ' + C.fmt(s.delta, 4) + '\\\\');
                    lines.push('\\text{Power} = ' + C.fmt(s.power, 0) + '\\%, \\quad Z_{\\beta} = ' + C.fmt(s.Zbeta, 4) + '\\\\');
                    lines.push('n_{\\text{per group}} = \\left\\lceil \\frac{2(Z_{\\alpha/2}+Z_{\\beta})^2 \\bar{p}(1-\\bar{p})}{\\Delta^2} \\right\\rceil = ' + C.fmt(s.nPerGroup, 0) + '\\\\');
                    lines.push('n_{\\text{total}} = ' + C.fmt(s.total, 0));
                } else {
                    lines.push('\\sigma = ' + C.fmt(s.sigma, 4) + ', \\quad \\Delta = ' + C.fmt(s.delta, 4) + '\\\\');
                    lines.push('\\text{Power} = ' + C.fmt(s.power, 0) + '\\%, \\quad Z_{\\beta} = ' + C.fmt(s.Zbeta, 4) + '\\\\');
                    lines.push('n_{\\text{per group}} = \\left\\lceil 2\\left(\\frac{(Z_{\\alpha/2}+Z_{\\beta})\\sigma}{\\Delta}\\right)^2 \\right\\rceil = ' + C.fmt(s.nPerGroup, 0) + '\\\\');
                    lines.push('n_{\\text{total}} = ' + C.fmt(s.total, 0));
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: s.mode, conf: s.conf };
                if (s.mode === 'survey') {
                    shared.p = s.p; shared.E = s.E;
                    if (s.N !== null) shared.N = s.N;
                } else if (s.mode === 'mean') {
                    shared.sigma = s.sigma; shared.E = s.E;
                    if (s.N !== null) shared.N = s.N;
                } else if (s.mode === 'ab') {
                    shared.p1 = s.p1; shared.p2 = s.p2; shared.power = s.power;
                } else {
                    shared.sigma = s.sigma; shared.delta = s.delta; shared.power = s.power;
                }
                return shared;
            },
            resultEl: '#ss-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="ss-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="ss-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    /* ===== Render: Survey (Proportion) ===== */
    function renderSurveyResult(r) {
        var subtitle = r.N !== null ? 'respondents needed (with finite population correction)' : 'respondents needed';
        var h = '<div class="stat-hero"><span class="stat-hero-value">n = ' + C.fmt(r.n, 0) + '</span><span class="stat-hero-label">' + subtitle + '</span></div>';
        var rows = [
            ['Confidence Level', C.fmt(r.conf, 1) + '%'],
            ['Z-score', C.fmt(r.Z, 4)],
            ['Proportion (p)', C.fmt(r.p, 4)],
            ['Margin of Error (E)', C.fmt(r.E, 4)]
        ];
        if (r.N !== null) rows.push(['Population Size (N)', C.fmt(r.N, 0)]);
        rows.push(['Uncorrected n\u2080', C.fmt(r.n0, 2)]);
        if (r.N !== null) rows.push(['Corrected n', C.fmt(r.n, 0)]);
        h += buildSection('Parameters Used', rows);
        h += buildSurveySteps(r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> You need a sample of at least <strong>' + C.fmt(r.n, 0) + '</strong> respondents to estimate the population proportion within \u00B1' + C.fmt(r.E * 100, 1) + '% at a ' + C.fmt(r.conf, 0) + '% confidence level' + (r.N !== null ? ' from a population of ' + C.fmt(r.N, 0) : '') + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Mean Estimation ===== */
    function renderMeanResult(r) {
        var subtitle = r.N !== null ? 'observations needed (with finite population correction)' : 'observations needed';
        var h = '<div class="stat-hero"><span class="stat-hero-value">n = ' + C.fmt(r.n, 0) + '</span><span class="stat-hero-label">' + subtitle + '</span></div>';
        var rows = [
            ['Confidence Level', C.fmt(r.conf, 1) + '%'],
            ['Z-score', C.fmt(r.Z, 4)],
            ['Standard Deviation (\u03C3)', C.fmt(r.sigma, 4)],
            ['Margin of Error (E)', C.fmt(r.E, 4)]
        ];
        if (r.N !== null) rows.push(['Population Size (N)', C.fmt(r.N, 0)]);
        rows.push(['Uncorrected n\u2080', C.fmt(r.n0, 2)]);
        if (r.N !== null) rows.push(['Corrected n', C.fmt(r.n, 0)]);
        h += buildSection('Parameters Used', rows);
        h += buildMeanSteps(r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> You need a sample of at least <strong>' + C.fmt(r.n, 0) + '</strong> observations to estimate the population mean within \u00B1' + C.fmt(r.E, 2) + ' units at a ' + C.fmt(r.conf, 0) + '% confidence level' + (r.N !== null ? ' from a population of ' + C.fmt(r.N, 0) : '') + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: A/B Test (Two Proportions) ===== */
    function renderABResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">n = ' + C.fmt(r.nPerGroup, 0) + ' per group</span><span class="stat-hero-label">total = ' + C.fmt(r.total, 0) + ' participants</span></div>';
        h += buildSection('Parameters Used', [
            ['Confidence Level', C.fmt(r.conf, 1) + '%'],
            ['Z\u03B1/2', C.fmt(r.Z, 4)],
            ['Statistical Power', C.fmt(r.power, 0) + '%'],
            ['Z\u03B2', C.fmt(r.Zbeta, 4)],
            ['Baseline Rate (p\u2081)', C.fmt(r.p1, 4)],
            ['Expected Rate (p\u2082)', C.fmt(r.p2, 4)],
            ['Pooled Proportion (\u0070\u0304)', C.fmt(r.pbar, 4)],
            ['Detectable Difference (\u0394)', C.fmt(r.delta, 4)],
            ['Per Group', C.fmt(r.nPerGroup, 0)],
            ['Total', C.fmt(r.total, 0)]
        ]);
        h += buildABSteps(r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> To detect a change from ' + C.fmt(r.p1 * 100, 1) + '% to ' + C.fmt(r.p2 * 100, 1) + '% with ' + C.fmt(r.power, 0) + '% power at a ' + C.fmt(r.conf, 0) + '% confidence level, you need <strong>' + C.fmt(r.nPerGroup, 0) + ' participants per group</strong> (' + C.fmt(r.total, 0) + ' total).</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Compare Means ===== */
    function renderCompareResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">n = ' + C.fmt(r.nPerGroup, 0) + ' per group</span><span class="stat-hero-label">total = ' + C.fmt(r.total, 0) + ' participants</span></div>';
        h += buildSection('Parameters Used', [
            ['Confidence Level', C.fmt(r.conf, 1) + '%'],
            ['Z\u03B1/2', C.fmt(r.Z, 4)],
            ['Statistical Power', C.fmt(r.power, 0) + '%'],
            ['Z\u03B2', C.fmt(r.Zbeta, 4)],
            ['Pooled Std Dev (\u03C3)', C.fmt(r.sigma, 4)],
            ['Effect Size (\u0394)', C.fmt(r.delta, 4)],
            ['Per Group', C.fmt(r.nPerGroup, 0)],
            ['Total', C.fmt(r.total, 0)]
        ]);
        h += buildCompareSteps(r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> To detect a mean difference of ' + C.fmt(r.delta, 2) + ' (with \u03C3 = ' + C.fmt(r.sigma, 2) + ') at ' + C.fmt(r.power, 0) + '% power and ' + C.fmt(r.conf, 0) + '% confidence, you need <strong>' + C.fmt(r.nPerGroup, 0) + ' participants per group</strong> (' + C.fmt(r.total, 0) + ' total).</div>';
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

    function buildSurveySteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        h += step(1, 'Formula', '<span class="stat-katex" data-tex="n_0 = \\frac{Z^2 \\cdot p(1-p)}{E^2}"></span>');
        h += step(2, 'Substitute Values', '<span class="stat-katex" data-tex="n_0 = \\frac{' + C.fmt(r.Z, 4) + '^2 \\times ' + C.fmt(r.p, 4) + ' \\times ' + C.fmt(1 - r.p, 4) + '}{' + C.fmt(r.E, 4) + '^2} = ' + C.fmt(r.n0, 2) + '"></span>');
        if (r.N !== null) {
            h += step(3, 'Finite Population Correction', '<span class="stat-katex" data-tex="n = \\frac{n_0}{1 + \\frac{n_0 - 1}{N}} = \\frac{' + C.fmt(r.n0, 2) + '}{1 + \\frac{' + C.fmt(r.n0 - 1, 2) + '}{' + C.fmt(r.N, 0) + '}} = ' + C.fmt(r.n, 0) + '"></span>');
        } else {
            h += step(3, 'Round Up', '<span class="stat-katex" data-tex="n = \\lceil ' + C.fmt(r.n0, 2) + ' \\rceil = ' + C.fmt(r.n, 0) + '"></span>');
        }
        return h + '</div>';
    }

    function buildMeanSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        h += step(1, 'Formula', '<span class="stat-katex" data-tex="n_0 = \\frac{Z^2 \\cdot \\sigma^2}{E^2}"></span>');
        h += step(2, 'Substitute Values', '<span class="stat-katex" data-tex="n_0 = \\frac{' + C.fmt(r.Z, 4) + '^2 \\times ' + C.fmt(r.sigma, 4) + '^2}{' + C.fmt(r.E, 4) + '^2} = ' + C.fmt(r.n0, 2) + '"></span>');
        if (r.N !== null) {
            h += step(3, 'Finite Population Correction', '<span class="stat-katex" data-tex="n = \\frac{n_0}{1 + \\frac{n_0 - 1}{N}} = \\frac{' + C.fmt(r.n0, 2) + '}{1 + \\frac{' + C.fmt(r.n0 - 1, 2) + '}{' + C.fmt(r.N, 0) + '}} = ' + C.fmt(r.n, 0) + '"></span>');
        } else {
            h += step(3, 'Round Up', '<span class="stat-katex" data-tex="n = \\lceil ' + C.fmt(r.n0, 2) + ' \\rceil = ' + C.fmt(r.n, 0) + '"></span>');
        }
        return h + '</div>';
    }

    function buildABSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        h += step(1, 'Pooled Proportion', '<span class="stat-katex" data-tex="\\bar{p} = \\frac{p_1 + p_2}{2} = \\frac{' + C.fmt(r.p1, 4) + ' + ' + C.fmt(r.p2, 4) + '}{2} = ' + C.fmt(r.pbar, 4) + '"></span>');
        h += step(2, 'Effect Size', '<span class="stat-katex" data-tex="\\Delta = |p_2 - p_1| = |' + C.fmt(r.p2, 4) + ' - ' + C.fmt(r.p1, 4) + '| = ' + C.fmt(r.delta, 4) + '"></span>');
        h += step(3, 'Formula', '<span class="stat-katex" data-tex="n_{\\text{per group}} = \\left\\lceil \\frac{2(Z_{\\alpha/2} + Z_{\\beta})^2 \\cdot \\bar{p}(1-\\bar{p})}{\\Delta^2} \\right\\rceil"></span>');
        h += step(4, 'Substitute', '<span class="stat-katex" data-tex="n = \\left\\lceil \\frac{2(' + C.fmt(r.Z, 4) + ' + ' + C.fmt(r.Zbeta, 4) + ')^2 \\times ' + C.fmt(r.pbar, 4) + ' \\times ' + C.fmt(1 - r.pbar, 4) + '}{' + C.fmt(r.delta, 4) + '^2} \\right\\rceil = ' + C.fmt(r.nPerGroup, 0) + '"></span>');
        h += step(5, 'Total Sample', '<span class="stat-katex" data-tex="n_{\\text{total}} = 2 \\times ' + C.fmt(r.nPerGroup, 0) + ' = ' + C.fmt(r.total, 0) + '"></span>');
        return h + '</div>';
    }

    function buildCompareSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        h += step(1, 'Formula', '<span class="stat-katex" data-tex="n_{\\text{per group}} = \\left\\lceil 2\\left(\\frac{(Z_{\\alpha/2} + Z_{\\beta}) \\cdot \\sigma}{\\Delta}\\right)^2 \\right\\rceil"></span>');
        h += step(2, 'Substitute', '<span class="stat-katex" data-tex="n = \\left\\lceil 2\\left(\\frac{(' + C.fmt(r.Z, 4) + ' + ' + C.fmt(r.Zbeta, 4) + ') \\times ' + C.fmt(r.sigma, 4) + '}{' + C.fmt(r.delta, 4) + '}\\right)^2 \\right\\rceil = ' + C.fmt(r.nPerGroup, 0) + '"></span>');
        h += step(3, 'Total Sample', '<span class="stat-katex" data-tex="n_{\\text{total}} = 2 \\times ' + C.fmt(r.nPerGroup, 0) + ' = ' + C.fmt(r.total, 0) + '"></span>');
        return h + '</div>';
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
            var container = document.getElementById('ss-graph-container');
            container.innerHTML = '';

            if (r.mode === 'survey' || r.mode === 'mean') {
                // Line chart: sample size vs margin of error
                var xVals = [], yVals = [];
                var conf = r.conf;
                var Z = r.Z;
                var steps = 50;
                if (r.mode === 'survey') {
                    var p = r.p;
                    var minE = r.E * 0.2;
                    var maxE = r.E * 3;
                    for (var i = 0; i <= steps; i++) {
                        var E_i = minE + (maxE - minE) * i / steps;
                        var n0 = (Z * Z * p * (1 - p)) / (E_i * E_i);
                        var n = r.N !== null ? Math.ceil(n0 / (1 + (n0 - 1) / r.N)) : Math.ceil(n0);
                        xVals.push(+(E_i * 100).toFixed(2));
                        yVals.push(n);
                    }
                } else {
                    var sigma = r.sigma;
                    var minE = r.E * 0.2;
                    var maxE = r.E * 3;
                    for (var i = 0; i <= steps; i++) {
                        var E_i = minE + (maxE - minE) * i / steps;
                        var n0 = (Z * Z * sigma * sigma) / (E_i * E_i);
                        var n = r.N !== null ? Math.ceil(n0 / (1 + (n0 - 1) / r.N)) : Math.ceil(n0);
                        xVals.push(+E_i.toFixed(2));
                        yVals.push(n);
                    }
                }
                var curX = r.mode === 'survey' ? +(r.E * 100).toFixed(2) : +r.E.toFixed(2);
                var traces = [
                    { x: xVals, y: yVals, mode: 'lines', line: { color: '#6366f1', width: 2 }, name: 'Sample Size' },
                    { x: [curX], y: [r.n], mode: 'markers', marker: { size: 12, color: '#ef4444', symbol: 'diamond' }, name: 'Your Selection' }
                ];
                var layout = {
                    title: 'Sample Size vs Margin of Error',
                    xaxis: { title: r.mode === 'survey' ? 'Margin of Error (%)' : 'Margin of Error' },
                    yaxis: { title: 'Sample Size (n)' },
                    showlegend: true, legend: { orientation: 'h', y: -0.25 },
                    margin: { t: 50, b: 70, l: 70, r: 40 },
                    height: 350
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });

            } else {
                // Line chart: sample size vs power
                var xVals = [], yVals = [];
                var powerLevels = [];
                for (var pw = 50; pw <= 99; pw++) powerLevels.push(pw);
                for (var i = 0; i < powerLevels.length; i++) {
                    var pw = powerLevels[i];
                    var zb = getZBeta(pw);
                    var nPG;
                    if (r.mode === 'ab') {
                        nPG = Math.ceil(2 * Math.pow(r.Z + zb, 2) * r.pbar * (1 - r.pbar) / (r.delta * r.delta));
                    } else {
                        nPG = Math.ceil(2 * Math.pow((r.Z + zb) * r.sigma / r.delta, 2));
                    }
                    xVals.push(pw);
                    yVals.push(nPG);
                }
                var curPower = r.power;
                var curN = r.nPerGroup;
                var traces = [
                    { x: xVals, y: yVals, mode: 'lines', line: { color: '#6366f1', width: 2 }, name: 'n per Group' },
                    { x: [curPower], y: [curN], mode: 'markers', marker: { size: 12, color: '#ef4444', symbol: 'diamond' }, name: 'Your Selection' }
                ];
                var layout = {
                    title: 'Sample Size per Group vs Power',
                    xaxis: { title: 'Statistical Power (%)' },
                    yaxis: { title: 'Sample Size per Group' },
                    showlegend: true, legend: { orientation: 'h', y: -0.25 },
                    margin: { t: 50, b: 70, l: 70, r: 40 },
                    height: 350
                };
                window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
            }
        });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [];

        if (r.mode === 'survey') {
            lines.push('import math');
            lines.push('');
            lines.push('# Survey Sample Size (Proportion)');
            lines.push('Z = ' + r.Z + '  # Z-score for ' + r.conf + '% confidence');
            lines.push('p = ' + r.p);
            lines.push('E = ' + r.E);
            if (r.N !== null) lines.push('N = ' + r.N);
            lines.push('');
            lines.push('n0 = (Z**2 * p * (1 - p)) / E**2');
            lines.push('print(f"Uncorrected n0 = {n0:.2f}")');
            if (r.N !== null) {
                lines.push('n = math.ceil(n0 / (1 + (n0 - 1) / N))');
                lines.push('print(f"Corrected n = {n} (pop = {N})")');
            } else {
                lines.push('n = math.ceil(n0)');
                lines.push('print(f"Required n = {n}")');
            }
        } else if (r.mode === 'mean') {
            lines.push('import math');
            lines.push('');
            lines.push('# Mean Estimation Sample Size');
            lines.push('Z = ' + r.Z + '  # Z-score for ' + r.conf + '% confidence');
            lines.push('sigma = ' + r.sigma);
            lines.push('E = ' + r.E);
            if (r.N !== null) lines.push('N = ' + r.N);
            lines.push('');
            lines.push('n0 = (Z**2 * sigma**2) / E**2');
            lines.push('print(f"Uncorrected n0 = {n0:.2f}")');
            if (r.N !== null) {
                lines.push('n = math.ceil(n0 / (1 + (n0 - 1) / N))');
                lines.push('print(f"Corrected n = {n} (pop = {N})")');
            } else {
                lines.push('n = math.ceil(n0)');
                lines.push('print(f"Required n = {n}")');
            }
        } else if (r.mode === 'ab') {
            lines.push('import math');
            lines.push('from scipy import stats');
            lines.push('');
            lines.push('# A/B Test Sample Size (Two Proportions)');
            lines.push('p1 = ' + r.p1);
            lines.push('p2 = ' + r.p2);
            lines.push('alpha = ' + (1 - r.conf / 100));
            lines.push('power = ' + r.power / 100);
            lines.push('');
            lines.push('Z_alpha = stats.norm.ppf(1 - alpha/2)');
            lines.push('Z_beta = stats.norm.ppf(power)');
            lines.push('p_bar = (p1 + p2) / 2');
            lines.push('delta = abs(p2 - p1)');
            lines.push('');
            lines.push('n_per_group = math.ceil(2 * (Z_alpha + Z_beta)**2 * p_bar * (1 - p_bar) / delta**2)');
            lines.push('total = 2 * n_per_group');
            lines.push('');
            lines.push('print(f"Z_alpha/2 = {Z_alpha:.4f}")');
            lines.push('print(f"Z_beta = {Z_beta:.4f}")');
            lines.push('print(f"Per group = {n_per_group}")');
            lines.push('print(f"Total = {total}")');
        } else {
            lines.push('import math');
            lines.push('from scipy import stats');
            lines.push('');
            lines.push('# Compare Means Sample Size');
            lines.push('sigma = ' + r.sigma);
            lines.push('delta = ' + r.delta);
            lines.push('alpha = ' + (1 - r.conf / 100));
            lines.push('power = ' + r.power / 100);
            lines.push('');
            lines.push('Z_alpha = stats.norm.ppf(1 - alpha/2)');
            lines.push('Z_beta = stats.norm.ppf(power)');
            lines.push('');
            lines.push('n_per_group = math.ceil(2 * ((Z_alpha + Z_beta) * sigma / delta)**2)');
            lines.push('total = 2 * n_per_group');
            lines.push('');
            lines.push('print(f"Z_alpha/2 = {Z_alpha:.4f}")');
            lines.push('print(f"Z_beta = {Z_beta:.4f}")');
            lines.push('print(f"Per group = {n_per_group}")');
            lines.push('print(f"Total = {total}")');
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
        document.getElementById('ss-graph-container').innerHTML = '';
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'election-poll') {
            setMode('survey');
            document.getElementById('ss-proportion').value = '0.5';
            document.getElementById('ss-margin-error').value = '0.03';
            document.getElementById('ss-pop-size').value = '';
            state.confLevel = 95;
        } else if (ex === 'customer-survey') {
            setMode('survey');
            document.getElementById('ss-proportion').value = '0.5';
            document.getElementById('ss-margin-error').value = '0.05';
            document.getElementById('ss-pop-size').value = '10000';
            state.confLevel = 95;
        } else if (ex === 'ab-conversion') {
            setMode('ab');
            document.getElementById('ss-p1').value = '0.10';
            document.getElementById('ss-p2').value = '0.12';
            document.getElementById('ss-power').value = '80';
            state.confLevel = 95;
        } else if (ex === 'clinical-trial') {
            setMode('compare');
            document.getElementById('ss-pooled-sd').value = '10';
            document.getElementById('ss-effect-size').value = '5';
            document.getElementById('ss-power-means').value = '90';
            state.confLevel = 95;
        }
        document.querySelectorAll('.ss-conf-pill').forEach(function(p) {
            p.classList.toggle('active', p.getAttribute('data-conf') === '95');
        });
        var customEl = document.getElementById('ss-custom-conf');
        if (customEl) customEl.style.display = 'none';
        calculate();
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        // Set mode
        setMode(shared.mode);

        // Set confidence level
        if (shared.conf) {
            state.confLevel = shared.conf;
            document.querySelectorAll('.ss-conf-pill').forEach(function(p) {
                var val = p.getAttribute('data-conf');
                if (val === String(shared.conf)) {
                    p.classList.add('active');
                } else {
                    p.classList.remove('active');
                }
            });
        }

        // Populate inputs based on mode
        if (shared.mode === 'survey') {
            if (shared.p !== undefined) document.getElementById('ss-proportion').value = shared.p;
            if (shared.E !== undefined) document.getElementById('ss-margin-error').value = shared.E;
            if (shared.N !== undefined) document.getElementById('ss-pop-size').value = shared.N;
            else document.getElementById('ss-pop-size').value = '';
        } else if (shared.mode === 'mean') {
            if (shared.sigma !== undefined) document.getElementById('ss-std-dev').value = shared.sigma;
            if (shared.E !== undefined) document.getElementById('ss-margin-error-mean').value = shared.E;
            if (shared.N !== undefined) document.getElementById('ss-pop-size-mean').value = shared.N;
            else document.getElementById('ss-pop-size-mean').value = '';
        } else if (shared.mode === 'ab') {
            if (shared.p1 !== undefined) document.getElementById('ss-p1').value = shared.p1;
            if (shared.p2 !== undefined) document.getElementById('ss-p2').value = shared.p2;
            if (shared.power !== undefined) document.getElementById('ss-power').value = shared.power;
        } else if (shared.mode === 'compare') {
            if (shared.sigma !== undefined) document.getElementById('ss-pooled-sd').value = shared.sigma;
            if (shared.delta !== undefined) document.getElementById('ss-effect-size').value = shared.delta;
            if (shared.power !== undefined) document.getElementById('ss-power-means').value = shared.power;
        }

        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();
        initConfLevel();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.ss-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        var exContainer = document.getElementById('ss-examples');
        if (exContainer) {
            exContainer.querySelectorAll('[data-example]').forEach(function(el) {
                el.addEventListener('click', function() {
                    applyExample(this.getAttribute('data-example'));
                });
            });
        }

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        // Restore from shared URL or fall back to default example
        if (restoreFromUrl()) {
            calculate();
        } else {
            setMode('survey');
            applyExample('election-poll');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
