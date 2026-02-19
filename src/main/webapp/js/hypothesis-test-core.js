/**
 * Hypothesis Test Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for normal/t-distribution p-values and critical values.
 * Uses Plotly (lazy-loaded) for distribution curve visualization.
 *
 * Modes: zmean (Z-Test for Mean), tmean (T-Test for Mean),
 *        zprop (Z-Test for Proportion), twoprop (Two-Proportion Z-Test)
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    var PREFIX = 'ht-';

    /* ===== State ===== */
    var state = {
        mode: 'zmean',
        results: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('ht-result-content');
        els.resultActions  = document.getElementById('ht-result-actions');
        els.graphPanel     = document.getElementById('ht-graph-panel');
        els.graphContainer = document.getElementById('ht-graph-container');
        els.compilerPanel  = document.getElementById('ht-compiler-panel');
        els.compilerIframe = document.getElementById('ht-compiler-iframe');
        els.calcBtn        = document.getElementById('ht-calc-btn');
        els.clearBtn       = document.getElementById('ht-clear-btn');

        els.modeZMean   = document.getElementById('ht-mode-zmean');
        els.modeTMean   = document.getElementById('ht-mode-tmean');
        els.modeZProp   = document.getElementById('ht-mode-zprop');
        els.modeTwoProp = document.getElementById('ht-mode-twoprop');

        els.panelZMean   = document.getElementById('ht-input-zmean');
        els.panelTMean   = document.getElementById('ht-input-tmean');
        els.panelZProp   = document.getElementById('ht-input-zprop');
        els.panelTwoProp = document.getElementById('ht-input-twoprop');
    }

    /* ===== Examples ===== */
    var EXAMPLES = {
        'iq-test':   { mode: 'zmean',   xbar: 105, mu0: 100, sigma: 15, n: 36, alpha: 0.05, alt: 'two-tailed', desc: 'IQ Test (Z-Test)' },
        'drug-trial':{ mode: 'tmean',   xbar: 8.2, mu0: 10, s: 3.5, n: 16, alpha: 0.05, alt: 'less', desc: 'Drug Trial (T-Test)' },
        'coin-flip': { mode: 'zprop',   x: 55, n: 100, p0: 0.50, alpha: 0.05, alt: 'two-tailed', desc: 'Fair Coin (Proportion)' },
        'ab-test':   { mode: 'twoprop', x1: 45, n1: 100, x2: 60, n2: 120, alpha: 0.05, alt: 'two-tailed', desc: 'A/B Test (Two-Prop)' }
    };

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
                if (target === 'ht-graph-panel') renderGraph();
                if (target === 'ht-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeZMean.addEventListener('click', function() { setMode('zmean'); });
        els.modeTMean.addEventListener('click', function() { setMode('tmean'); });
        els.modeZProp.addEventListener('click', function() { setMode('zprop'); });
        els.modeTwoProp.addEventListener('click', function() { setMode('twoprop'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeZMean.classList.toggle('active', m === 'zmean');
        els.modeTMean.classList.toggle('active', m === 'tmean');
        els.modeZProp.classList.toggle('active', m === 'zprop');
        els.modeTwoProp.classList.toggle('active', m === 'twoprop');
        els.panelZMean.style.display   = m === 'zmean' ? '' : 'none';
        els.panelTMean.style.display   = m === 'tmean' ? '' : 'none';
        els.panelZProp.style.display   = m === 'zprop' ? '' : 'none';
        els.panelTwoProp.style.display = m === 'twoprop' ? '' : 'none';
    }

    /* ===== Core Computation Functions ===== */

    function computeZMean(xbar, mu0, sigma, n, alpha, alt) {
        var se = sigma / Math.sqrt(n);
        var z = (xbar - mu0) / se;
        var absZ = Math.abs(z);
        var pValue;
        if (alt === 'two-tailed') {
            pValue = 2 * (1 - jStat.normal.cdf(absZ, 0, 1));
        } else if (alt === 'greater') {
            pValue = 1 - jStat.normal.cdf(z, 0, 1);
        } else {
            pValue = jStat.normal.cdf(z, 0, 1);
        }
        var criticalValue;
        if (alt === 'two-tailed') {
            criticalValue = jStat.normal.inv(1 - alpha / 2, 0, 1);
        } else {
            criticalValue = jStat.normal.inv(1 - alpha, 0, 1);
        }
        var significant = pValue < alpha;
        return {
            test: 'Z-Test for Mean', stat: z, statName: 'Z', pValue: pValue,
            alpha: alpha, alt: alt, criticalValue: criticalValue,
            significant: significant, se: se,
            nullH: '\u03BC = ' + mu0, dist: 'normal'
        };
    }

    function computeTMean(xbar, mu0, s, n, alpha, alt) {
        var df = n - 1;
        var se = s / Math.sqrt(n);
        var t = (xbar - mu0) / se;
        var absT = Math.abs(t);
        var pValue;
        if (alt === 'two-tailed') {
            pValue = 2 * (1 - jStat.studentt.cdf(absT, df));
        } else if (alt === 'greater') {
            pValue = 1 - jStat.studentt.cdf(t, df);
        } else {
            pValue = jStat.studentt.cdf(t, df);
        }
        var criticalValue;
        if (alt === 'two-tailed') {
            criticalValue = jStat.studentt.inv(1 - alpha / 2, df);
        } else {
            criticalValue = jStat.studentt.inv(1 - alpha, df);
        }
        var significant = pValue < alpha;
        return {
            test: 'T-Test for Mean', stat: t, statName: 't', df: df,
            pValue: pValue, alpha: alpha, alt: alt,
            criticalValue: criticalValue, significant: significant, se: se,
            nullH: '\u03BC = ' + mu0, dist: 't'
        };
    }

    function computeZProp(x, n, p0, alpha, alt) {
        var phat = x / n;
        var se = Math.sqrt(p0 * (1 - p0) / n);
        var z = (phat - p0) / se;
        var absZ = Math.abs(z);
        var pValue;
        if (alt === 'two-tailed') {
            pValue = 2 * (1 - jStat.normal.cdf(absZ, 0, 1));
        } else if (alt === 'greater') {
            pValue = 1 - jStat.normal.cdf(z, 0, 1);
        } else {
            pValue = jStat.normal.cdf(z, 0, 1);
        }
        var criticalValue;
        if (alt === 'two-tailed') {
            criticalValue = jStat.normal.inv(1 - alpha / 2, 0, 1);
        } else {
            criticalValue = jStat.normal.inv(1 - alpha, 0, 1);
        }
        var significant = pValue < alpha;
        return {
            test: 'Z-Test for Proportion', stat: z, statName: 'Z',
            pValue: pValue, alpha: alpha, alt: alt,
            criticalValue: criticalValue, significant: significant, se: se,
            phat: phat, nullH: 'p = ' + p0, dist: 'normal'
        };
    }

    function computeTwoProp(x1, n1, x2, n2, alpha, alt) {
        var p1 = x1 / n1;
        var p2 = x2 / n2;
        var pPooled = (x1 + x2) / (n1 + n2);
        var se = Math.sqrt(pPooled * (1 - pPooled) * (1 / n1 + 1 / n2));
        var z = (p1 - p2) / se;
        var absZ = Math.abs(z);
        var pValue;
        if (alt === 'two-tailed') {
            pValue = 2 * (1 - jStat.normal.cdf(absZ, 0, 1));
        } else if (alt === 'greater') {
            pValue = 1 - jStat.normal.cdf(z, 0, 1);
        } else {
            pValue = jStat.normal.cdf(z, 0, 1);
        }
        var criticalValue;
        if (alt === 'two-tailed') {
            criticalValue = jStat.normal.inv(1 - alpha / 2, 0, 1);
        } else {
            criticalValue = jStat.normal.inv(1 - alpha, 0, 1);
        }
        var significant = pValue < alpha;
        return {
            test: 'Two-Proportion Z-Test', stat: z, statName: 'Z',
            pValue: pValue, alpha: alpha, alt: alt,
            criticalValue: criticalValue, significant: significant, se: se,
            p1: p1, p2: p2, pPooled: pPooled, diff: p1 - p2,
            nullH: 'p\u2081 = p\u2082', dist: 'normal'
        };
    }

    /* ===== Calculate (main entry) ===== */
    function calculate() {
        G.loadJStat(function() {
            try { doCalculate(); } catch (e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
        });
    }

    function doCalculate() {
        var r;

        if (state.mode === 'zmean') {
            var xbar  = parseFloat(document.getElementById('ht-zm-xbar').value);
            var mu0   = parseFloat(document.getElementById('ht-zm-mu0').value);
            var sigma = parseFloat(document.getElementById('ht-zm-sigma').value);
            var n     = parseFloat(document.getElementById('ht-zm-n').value);
            var alpha = parseFloat(document.getElementById('ht-zm-alpha').value);
            var alt   = document.getElementById('ht-zm-alt').value;
            if (isNaN(xbar)) { C.showError(els.resultContent, 'Enter a valid sample mean.'); return; }
            if (isNaN(mu0)) { C.showError(els.resultContent, 'Enter a valid hypothesized mean.'); return; }
            if (isNaN(sigma) || sigma <= 0) { C.showError(els.resultContent, 'Enter a valid population standard deviation (> 0).'); return; }
            if (isNaN(n) || n < 1 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 1).'); return; }
            if (isNaN(alpha) || alpha <= 0 || alpha >= 1) { C.showError(els.resultContent, 'Enter a valid significance level (0 < \u03B1 < 1).'); return; }
            r = computeZMean(xbar, mu0, sigma, n, alpha, alt);
            r._xbar = xbar; r._mu0 = mu0; r._sigma = sigma; r._n = n;

        } else if (state.mode === 'tmean') {
            var xbar  = parseFloat(document.getElementById('ht-tm-xbar').value);
            var mu0   = parseFloat(document.getElementById('ht-tm-mu0').value);
            var s     = parseFloat(document.getElementById('ht-tm-s').value);
            var n     = parseFloat(document.getElementById('ht-tm-n').value);
            var alpha = parseFloat(document.getElementById('ht-tm-alpha').value);
            var alt   = document.getElementById('ht-tm-alt').value;
            if (isNaN(xbar)) { C.showError(els.resultContent, 'Enter a valid sample mean.'); return; }
            if (isNaN(mu0)) { C.showError(els.resultContent, 'Enter a valid hypothesized mean.'); return; }
            if (isNaN(s) || s <= 0) { C.showError(els.resultContent, 'Enter a valid sample standard deviation (> 0).'); return; }
            if (isNaN(n) || n < 2 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 2).'); return; }
            if (isNaN(alpha) || alpha <= 0 || alpha >= 1) { C.showError(els.resultContent, 'Enter a valid significance level (0 < \u03B1 < 1).'); return; }
            r = computeTMean(xbar, mu0, s, n, alpha, alt);
            r._xbar = xbar; r._mu0 = mu0; r._s = s; r._n = n;

        } else if (state.mode === 'zprop') {
            var x     = parseFloat(document.getElementById('ht-zp-x').value);
            var n     = parseFloat(document.getElementById('ht-zp-n').value);
            var p0    = parseFloat(document.getElementById('ht-zp-p0').value);
            var alpha = parseFloat(document.getElementById('ht-zp-alpha').value);
            var alt   = document.getElementById('ht-zp-alt').value;
            if (isNaN(x) || x < 0 || x !== Math.floor(x)) { C.showError(els.resultContent, 'Enter a valid number of successes (integer \u2265 0).'); return; }
            if (isNaN(n) || n < 1 || n !== Math.floor(n)) { C.showError(els.resultContent, 'Enter a valid sample size (integer \u2265 1).'); return; }
            if (x > n) { C.showError(els.resultContent, 'Successes cannot exceed sample size.'); return; }
            if (isNaN(p0) || p0 <= 0 || p0 >= 1) { C.showError(els.resultContent, 'Enter a valid hypothesized proportion (0 < p\u2080 < 1).'); return; }
            if (isNaN(alpha) || alpha <= 0 || alpha >= 1) { C.showError(els.resultContent, 'Enter a valid significance level (0 < \u03B1 < 1).'); return; }
            r = computeZProp(x, n, p0, alpha, alt);
            r._x = x; r._n = n; r._p0 = p0;

        } else {
            /* twoprop */
            var x1    = parseFloat(document.getElementById('ht-tp-x1').value);
            var n1    = parseFloat(document.getElementById('ht-tp-n1').value);
            var x2    = parseFloat(document.getElementById('ht-tp-x2').value);
            var n2    = parseFloat(document.getElementById('ht-tp-n2').value);
            var alpha = parseFloat(document.getElementById('ht-tp-alpha').value);
            var alt   = document.getElementById('ht-tp-alt').value;
            if (isNaN(x1) || x1 < 0 || x1 !== Math.floor(x1)) { C.showError(els.resultContent, 'Enter valid successes for Sample 1 (integer \u2265 0).'); return; }
            if (isNaN(n1) || n1 < 1 || n1 !== Math.floor(n1)) { C.showError(els.resultContent, 'Enter a valid sample size for Sample 1 (integer \u2265 1).'); return; }
            if (x1 > n1) { C.showError(els.resultContent, 'Successes cannot exceed sample size for Sample 1.'); return; }
            if (isNaN(x2) || x2 < 0 || x2 !== Math.floor(x2)) { C.showError(els.resultContent, 'Enter valid successes for Sample 2 (integer \u2265 0).'); return; }
            if (isNaN(n2) || n2 < 1 || n2 !== Math.floor(n2)) { C.showError(els.resultContent, 'Enter a valid sample size for Sample 2 (integer \u2265 1).'); return; }
            if (x2 > n2) { C.showError(els.resultContent, 'Successes cannot exceed sample size for Sample 2.'); return; }
            if (isNaN(alpha) || alpha <= 0 || alpha >= 1) { C.showError(els.resultContent, 'Enter a valid significance level (0 < \u03B1 < 1).'); return; }
            r = computeTwoProp(x1, n1, x2, n2, alpha, alt);
            r._x1 = x1; r._n1 = n1; r._x2 = x2; r._n2 = n2;
        }

        state.results = r;
        renderResults(r);

        E.renderActionButtons(els.resultActions, {
            toolName: 'Hypothesis Test',
            getLatex: function() {
                var r = state.results;
                if (!r) return '';
                var lines = [];
                lines.push('\\textbf{Hypothesis Test Results}\\\\[4pt]');
                lines.push('\\text{Test: ' + r.test + '}\\\\');
                lines.push('H_0: ' + r.nullH + '\\\\');
                lines.push('H_1: ' + altHypothesis(r).replace(/≠/g, '\\neq ').replace(/₁/g, '_1').replace(/₂/g, '_2') + '\\\\');
                lines.push(r.statName + ' = ' + C.fmt(r.stat, 4) + '\\\\');
                if (r.df !== undefined) lines.push('df = ' + r.df + '\\\\');
                lines.push('\\text{SE} = ' + C.fmt(r.se, 6) + '\\\\');
                lines.push('p\\text{-value} = ' + C.fmt(r.pValue, 6) + '\\\\');
                lines.push('\\alpha = ' + r.alpha + '\\\\');
                lines.push('\\text{Critical Value} = ' + C.fmt(r.criticalValue, 4) + '\\\\');
                if (r.phat !== undefined) lines.push('\\hat{p} = ' + C.fmt(r.phat, 6) + '\\\\');
                if (r.p1 !== undefined) {
                    lines.push('\\hat{p}_1 = ' + C.fmt(r.p1, 6) + '\\\\');
                    lines.push('\\hat{p}_2 = ' + C.fmt(r.p2, 6) + '\\\\');
                    lines.push('\\hat{p}_{\\text{pooled}} = ' + C.fmt(r.pPooled, 6) + '\\\\');
                }
                lines.push('\\text{Decision: ' + (r.significant ? 'Reject' : 'Fail to Reject') + ' } H_0');
                return lines.join('\n');
            },
            getShareState: function() {
                var r = state.results;
                if (!r) return null;
                var shared = { mode: state.mode, alpha: r.alpha, alt: r.alt };
                if (state.mode === 'zmean') {
                    shared.xbar = r._xbar; shared.mu0 = r._mu0; shared.sigma = r._sigma; shared.n = r._n;
                } else if (state.mode === 'tmean') {
                    shared.xbar = r._xbar; shared.mu0 = r._mu0; shared.s = r._s; shared.n = r._n;
                } else if (state.mode === 'zprop') {
                    shared.x = r._x; shared.n = r._n; shared.p0 = r._p0;
                } else if (state.mode === 'twoprop') {
                    shared.x1 = r._x1; shared.n1 = r._n1; shared.x2 = r._x2; shared.n2 = r._n2;
                }
                return shared;
            },
            resultEl: '#ht-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="ht-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="ht-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) renderGraph();
    }

    /* ===== Alternative Hypothesis Label ===== */
    function altLabel(alt) {
        if (alt === 'two-tailed') return 'Two-Tailed';
        if (alt === 'greater') return 'Right-Tailed (Greater)';
        return 'Left-Tailed (Less)';
    }

    function altHypothesis(r) {
        if (state.mode === 'zmean' || state.mode === 'tmean') {
            if (r.alt === 'two-tailed') return '\u03BC \u2260 ' + r._mu0;
            if (r.alt === 'greater') return '\u03BC > ' + r._mu0;
            return '\u03BC < ' + r._mu0;
        }
        if (state.mode === 'zprop') {
            if (r.alt === 'two-tailed') return 'p \u2260 ' + r._p0;
            if (r.alt === 'greater') return 'p > ' + r._p0;
            return 'p < ' + r._p0;
        }
        /* twoprop */
        if (r.alt === 'two-tailed') return 'p\u2081 \u2260 p\u2082';
        if (r.alt === 'greater') return 'p\u2081 > p\u2082';
        return 'p\u2081 < p\u2082';
    }

    /* ===== Render Results ===== */
    function renderResults(r) {
        var h = '';

        /* 1. Decision Banner */
        if (r.significant) {
            h += '<div style="background:#fef2f2;border:2px solid #ef4444;border-radius:0.75rem;padding:1rem 1.25rem;margin-bottom:1.25rem;text-align:center;">';
            h += '<div style="color:#dc2626;font-weight:700;font-size:1.15rem;">Reject H\u2080 \u2014 Statistically Significant</div>';
            h += '<div style="color:#991b1b;font-size:0.9rem;margin-top:0.25rem;">p = ' + C.fmt(r.pValue, 6) + ' < \u03B1 = ' + r.alpha + '</div>';
            h += '</div>';
        } else {
            h += '<div style="background:#f0fdf4;border:2px solid #22c55e;border-radius:0.75rem;padding:1rem 1.25rem;margin-bottom:1.25rem;text-align:center;">';
            h += '<div style="color:#16a34a;font-weight:700;font-size:1.15rem;">Fail to Reject H\u2080 \u2014 Not Significant</div>';
            h += '<div style="color:#166534;font-size:0.9rem;margin-top:0.25rem;">p = ' + C.fmt(r.pValue, 6) + ' \u2265 \u03B1 = ' + r.alpha + '</div>';
            h += '</div>';
        }

        /* 2. Test Summary */
        h += buildSection('Test Summary', [
            ['Test Type', r.test],
            ['Null Hypothesis (H\u2080)', r.nullH],
            ['Alternative Hypothesis (H\u2081)', altHypothesis(r)],
            ['Test Statistic (' + r.statName + ')', C.fmt(r.stat, 4)],
            ['P-Value', C.fmt(r.pValue, 6)],
            ['Significance Level (\u03B1)', r.alpha],
            ['Critical Value', C.fmt(r.criticalValue, 4)]
        ]);

        /* 3. Additional Details (mode-specific) */
        var detailRows = [['Standard Error (SE)', C.fmt(r.se, 6)]];
        if (state.mode === 'tmean') {
            detailRows.push(['Degrees of Freedom (df)', r.df]);
        }
        if (state.mode === 'zprop') {
            detailRows.push(['Sample Proportion (\u0070\u0302)', C.fmt(r.phat, 6)]);
        }
        if (state.mode === 'twoprop') {
            detailRows.push(['\u0070\u0302\u2081', C.fmt(r.p1, 6)]);
            detailRows.push(['\u0070\u0302\u2082', C.fmt(r.p2, 6)]);
            detailRows.push(['Difference (\u0070\u0302\u2081 \u2212 \u0070\u0302\u2082)', C.fmt(r.diff, 6)]);
            detailRows.push(['Pooled \u0070\u0302', C.fmt(r.pPooled, 6)]);
        }
        h += buildSection('Additional Details', detailRows);

        /* 4. Interpretation */
        h += buildInterpretation(r);

        /* 5. Step-by-step KaTeX */
        h += buildSteps(r);

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Interpretation ===== */
    function buildInterpretation(r) {
        var text;
        if (r.significant) {
            text = 'There is sufficient evidence at \u03B1 = ' + r.alpha + ' to reject the null hypothesis (H\u2080: ' + r.nullH + '). ';
            if (state.mode === 'zmean' || state.mode === 'tmean') {
                if (r.alt === 'two-tailed') text += 'The sample mean differs significantly from ' + r._mu0 + '.';
                else if (r.alt === 'greater') text += 'The sample mean is significantly greater than ' + r._mu0 + '.';
                else text += 'The sample mean is significantly less than ' + r._mu0 + '.';
            } else if (state.mode === 'zprop') {
                if (r.alt === 'two-tailed') text += 'The sample proportion differs significantly from ' + r._p0 + '.';
                else if (r.alt === 'greater') text += 'The sample proportion is significantly greater than ' + r._p0 + '.';
                else text += 'The sample proportion is significantly less than ' + r._p0 + '.';
            } else {
                if (r.alt === 'two-tailed') text += 'The two population proportions differ significantly.';
                else if (r.alt === 'greater') text += 'The first proportion is significantly greater than the second.';
                else text += 'The first proportion is significantly less than the second.';
            }
        } else {
            text = 'There is insufficient evidence at \u03B1 = ' + r.alpha + ' to reject the null hypothesis (H\u2080: ' + r.nullH + '). ';
            if (state.mode === 'zmean' || state.mode === 'tmean') {
                text += 'The data does not provide enough evidence to conclude the mean differs from ' + r._mu0 + '.';
            } else if (state.mode === 'zprop') {
                text += 'The data does not provide enough evidence to conclude the proportion differs from ' + r._p0 + '.';
            } else {
                text += 'The data does not provide enough evidence to conclude the two proportions differ.';
            }
        }
        var cls = r.significant ? 'stat-interpretation-success' : 'stat-interpretation-normal';
        return '<div class="stat-interpretation ' + cls + '"><strong>Interpretation:</strong> ' + text + '</div>';
    }

    /* ===== KaTeX Steps ===== */
    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        if (state.mode === 'zmean') {
            /* Step 1: Hypotheses */
            var h0Tex = 'H_0: \\mu = ' + r._mu0;
            var h1Tex;
            if (r.alt === 'two-tailed') h1Tex = 'H_1: \\mu \\neq ' + r._mu0;
            else if (r.alt === 'greater') h1Tex = 'H_1: \\mu > ' + r._mu0;
            else h1Tex = 'H_1: \\mu < ' + r._mu0;
            h += step(1, 'State Hypotheses', tex(h0Tex + ', \\quad ' + h1Tex));

            h += step(2, 'Calculate Standard Error', tex('SE = \\frac{\\sigma}{\\sqrt{n}} = \\frac{' + C.fmt(r._sigma, 4) + '}{\\sqrt{' + r._n + '}} = ' + C.fmt(r.se, 6)));
            h += step(3, 'Calculate Test Statistic', tex('Z = \\frac{\\bar{x} - \\mu_0}{SE} = \\frac{' + C.fmt(r._xbar, 4) + ' - ' + r._mu0 + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.stat, 4)));
            h += step(4, 'Find P-Value', tex('p\\text{-value} = ' + C.fmt(r.pValue, 6)));
            var dec = r.significant ? 'p < \\alpha \\Rightarrow \\text{Reject } H_0' : 'p \\geq \\alpha \\Rightarrow \\text{Fail to Reject } H_0';
            h += step(5, 'Decision', tex(C.fmt(r.pValue, 6) + (r.significant ? ' < ' : ' \\geq ') + r.alpha + ', \\quad ' + dec));

        } else if (state.mode === 'tmean') {
            var h0Tex = 'H_0: \\mu = ' + r._mu0;
            var h1Tex;
            if (r.alt === 'two-tailed') h1Tex = 'H_1: \\mu \\neq ' + r._mu0;
            else if (r.alt === 'greater') h1Tex = 'H_1: \\mu > ' + r._mu0;
            else h1Tex = 'H_1: \\mu < ' + r._mu0;
            h += step(1, 'State Hypotheses', tex(h0Tex + ', \\quad ' + h1Tex));

            h += step(2, 'Calculate Standard Error', tex('SE = \\frac{s}{\\sqrt{n}} = \\frac{' + C.fmt(r._s, 4) + '}{\\sqrt{' + r._n + '}} = ' + C.fmt(r.se, 6)));
            h += step(3, 'Calculate Test Statistic', tex('t = \\frac{\\bar{x} - \\mu_0}{SE} = \\frac{' + C.fmt(r._xbar, 4) + ' - ' + r._mu0 + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.stat, 4) + ', \\quad df = ' + r.df));
            h += step(4, 'Find P-Value', tex('p\\text{-value} = ' + C.fmt(r.pValue, 6)));
            var dec = r.significant ? 'p < \\alpha \\Rightarrow \\text{Reject } H_0' : 'p \\geq \\alpha \\Rightarrow \\text{Fail to Reject } H_0';
            h += step(5, 'Decision', tex(C.fmt(r.pValue, 6) + (r.significant ? ' < ' : ' \\geq ') + r.alpha + ', \\quad ' + dec));

        } else if (state.mode === 'zprop') {
            var h0Tex = 'H_0: p = ' + r._p0;
            var h1Tex;
            if (r.alt === 'two-tailed') h1Tex = 'H_1: p \\neq ' + r._p0;
            else if (r.alt === 'greater') h1Tex = 'H_1: p > ' + r._p0;
            else h1Tex = 'H_1: p < ' + r._p0;
            h += step(1, 'State Hypotheses', tex(h0Tex + ', \\quad ' + h1Tex));

            h += step(2, 'Calculate Standard Error', tex('SE = \\sqrt{\\frac{p_0(1-p_0)}{n}} = \\sqrt{\\frac{' + C.fmt(r._p0, 4) + ' \\times ' + C.fmt(1 - r._p0, 4) + '}{' + r._n + '}} = ' + C.fmt(r.se, 6)));
            h += step(3, 'Calculate Test Statistic', tex('Z = \\frac{\\hat{p} - p_0}{SE} = \\frac{' + C.fmt(r.phat, 6) + ' - ' + r._p0 + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.stat, 4)));
            h += step(4, 'Find P-Value', tex('p\\text{-value} = ' + C.fmt(r.pValue, 6)));
            var dec = r.significant ? 'p < \\alpha \\Rightarrow \\text{Reject } H_0' : 'p \\geq \\alpha \\Rightarrow \\text{Fail to Reject } H_0';
            h += step(5, 'Decision', tex(C.fmt(r.pValue, 6) + (r.significant ? ' < ' : ' \\geq ') + r.alpha + ', \\quad ' + dec));

        } else {
            /* twoprop */
            var h0Tex = 'H_0: p_1 = p_2';
            var h1Tex;
            if (r.alt === 'two-tailed') h1Tex = 'H_1: p_1 \\neq p_2';
            else if (r.alt === 'greater') h1Tex = 'H_1: p_1 > p_2';
            else h1Tex = 'H_1: p_1 < p_2';
            h += step(1, 'State Hypotheses', tex(h0Tex + ', \\quad ' + h1Tex));

            h += step(2, 'Calculate Standard Error', tex('\\hat{p} = \\frac{x_1 + x_2}{n_1 + n_2} = ' + C.fmt(r.pPooled, 6) + ', \\quad SE = \\sqrt{\\hat{p}(1-\\hat{p})\\left(\\frac{1}{n_1}+\\frac{1}{n_2}\\right)} = ' + C.fmt(r.se, 6)));
            h += step(3, 'Calculate Test Statistic', tex('Z = \\frac{\\hat{p}_1 - \\hat{p}_2}{SE} = \\frac{' + C.fmt(r.p1, 6) + ' - ' + C.fmt(r.p2, 6) + '}{' + C.fmt(r.se, 6) + '} = ' + C.fmt(r.stat, 4)));
            h += step(4, 'Find P-Value', tex('p\\text{-value} = ' + C.fmt(r.pValue, 6)));
            var dec = r.significant ? 'p < \\alpha \\Rightarrow \\text{Reject } H_0' : 'p \\geq \\alpha \\Rightarrow \\text{Fail to Reject } H_0';
            h += step(5, 'Decision', tex(C.fmt(r.pValue, 6) + (r.significant ? ' < ' : ' \\geq ') + r.alpha + ', \\quad ' + dec));
        }

        return h + '</div>';
    }

    /* ===== Render Graph ===== */
    function renderGraph() {
        if (!state.results) return;
        G.loadPlotly(function() {
            G.loadJStat(function() {
                doRenderGraph();
            });
        });
    }

    function doRenderGraph() {
        var r = state.results;
        var container = document.getElementById('ht-graph-container');
        container.innerHTML = '';
        var colors = G.getPlotColors();

        var isT = (r.dist === 't');
        var df = r.df || 0;

        /* PDF function */
        function pdf(x) {
            if (isT) return jStat.studentt.pdf(x, df);
            return jStat.normal.pdf(x, 0, 1);
        }

        /* Determine x-axis range */
        var range = Math.max(Math.abs(r.stat), Math.abs(r.criticalValue)) + 2;
        if (range < 4) range = 4;

        /* Build curve */
        var nPts = 300;
        var xVals = [], yVals = [];
        for (var i = 0; i <= nPts; i++) {
            var x = -range + (2 * range * i / nPts);
            xVals.push(x);
            yVals.push(pdf(x));
        }

        var traces = [];

        /* Main distribution curve */
        traces.push({
            x: xVals, y: yVals, type: 'scatter', mode: 'lines',
            line: { color: colors.accent, width: 2 },
            name: isT ? 't(' + C.fmt(df, 0) + ')' : 'N(0,1)',
            fill: 'none'
        });

        /* Shaded rejection region(s) */
        if (r.alt === 'two-tailed') {
            traces.push(shadedRegion(pdf, r.criticalValue, range, 'right', 'rgba(239,68,68,0.3)'));
            traces.push(shadedRegion(pdf, -r.criticalValue, range, 'left', 'rgba(239,68,68,0.3)'));
        } else if (r.alt === 'greater') {
            traces.push(shadedRegion(pdf, r.criticalValue, range, 'right', 'rgba(239,68,68,0.3)'));
        } else {
            traces.push(shadedRegion(pdf, -r.criticalValue, range, 'left', 'rgba(239,68,68,0.3)'));
        }

        /* Test statistic vertical line */
        var statPdf = pdf(r.stat);
        traces.push({
            x: [r.stat, r.stat], y: [0, statPdf], type: 'scatter', mode: 'lines',
            line: { color: '#10b981', width: 3 },
            name: r.statName + ' = ' + C.fmt(r.stat, 4)
        });

        /* Critical value dashed lines */
        if (r.alt === 'two-tailed') {
            var cPdf = pdf(r.criticalValue);
            traces.push(critLine(r.criticalValue, cPdf, '+' + r.statName + '\u2091'));
            traces.push(critLine(-r.criticalValue, cPdf, '-' + r.statName + '\u2091'));
        } else if (r.alt === 'greater') {
            var cPdf = pdf(r.criticalValue);
            traces.push(critLine(r.criticalValue, cPdf, r.statName + '\u2091'));
        } else {
            var cPdf = pdf(-r.criticalValue);
            traces.push(critLine(-r.criticalValue, cPdf, '-' + r.statName + '\u2091'));
        }

        var annotations = [{
            x: r.stat,
            y: statPdf + 0.02,
            text: 'p = ' + C.fmt(r.pValue, 4),
            showarrow: true,
            arrowhead: 2,
            ax: 40,
            ay: -30,
            font: { size: 11, color: '#10b981' }
        }];

        var distLabel = isT ? 't-Distribution (df = ' + C.fmt(df, 0) + ')' : 'Standard Normal Distribution';
        var layout = {
            title: distLabel,
            xaxis: { title: r.statName + '-value', zeroline: true, gridcolor: colors.grid },
            yaxis: { title: 'Density', rangemode: 'tozero', gridcolor: colors.grid },
            showlegend: true,
            legend: { orientation: 'h', y: -0.25 },
            margin: { t: 50, b: 70, l: 50, r: 30 },
            height: 340,
            paper_bgcolor: colors.paper,
            plot_bgcolor: colors.bg,
            font: { family: 'Inter, -apple-system, sans-serif', color: colors.text, size: 12 },
            annotations: annotations
        };

        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    function shadedRegion(pdfFn, crit, range, side, color) {
        var xs = [], ys = [];
        var lo = (side === 'left') ? -range : crit;
        var hi = (side === 'left') ? crit : range;
        var pts = 80;
        for (var i = 0; i <= pts; i++) {
            var x = lo + (hi - lo) * i / pts;
            xs.push(x);
            ys.push(pdfFn(x));
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

    /* ===== Python Code ===== */
    function preparePython() {
        var r = state.results;
        if (!r) return '';
        var lines = ['from scipy import stats', 'import math', ''];

        if (state.mode === 'zmean') {
            lines.push('# Z-Test for Mean');
            lines.push('xbar, mu0, sigma, n = ' + r._xbar + ', ' + r._mu0 + ', ' + r._sigma + ', ' + r._n);
            lines.push('se = sigma / n**0.5');
            lines.push('z = (xbar - mu0) / se');
            lines.push('');
            if (r.alt === 'two-tailed') {
                lines.push('p_value = 2 * (1 - stats.norm.cdf(abs(z)))');
            } else if (r.alt === 'greater') {
                lines.push('p_value = 1 - stats.norm.cdf(z)');
            } else {
                lines.push('p_value = stats.norm.cdf(z)');
            }
            lines.push('');
            lines.push('print(f"Z = {z:.4f}, p = {p_value:.6f}")');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"Decision: {\'Reject H0\' if p_value < alpha else \'Fail to reject H0\'}")');

        } else if (state.mode === 'tmean') {
            lines.push('# T-Test for Mean');
            lines.push('xbar, mu0, s, n = ' + r._xbar + ', ' + r._mu0 + ', ' + r._s + ', ' + r._n);
            lines.push('df = n - 1');
            lines.push('se = s / n**0.5');
            lines.push('t = (xbar - mu0) / se');
            lines.push('');
            if (r.alt === 'two-tailed') {
                lines.push('p_value = 2 * (1 - stats.t.cdf(abs(t), df))');
            } else if (r.alt === 'greater') {
                lines.push('p_value = 1 - stats.t.cdf(t, df)');
            } else {
                lines.push('p_value = stats.t.cdf(t, df)');
            }
            lines.push('');
            lines.push('print(f"t = {t:.4f}, df = {df}, p = {p_value:.6f}")');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"Decision: {\'Reject H0\' if p_value < alpha else \'Fail to reject H0\'}")');

        } else if (state.mode === 'zprop') {
            lines.push('# Z-Test for Proportion');
            lines.push('x, n, p0 = ' + r._x + ', ' + r._n + ', ' + r._p0);
            lines.push('p_hat = x / n');
            lines.push('se = math.sqrt(p0 * (1 - p0) / n)');
            lines.push('z = (p_hat - p0) / se');
            lines.push('');
            if (r.alt === 'two-tailed') {
                lines.push('p_value = 2 * (1 - stats.norm.cdf(abs(z)))');
            } else if (r.alt === 'greater') {
                lines.push('p_value = 1 - stats.norm.cdf(z)');
            } else {
                lines.push('p_value = stats.norm.cdf(z)');
            }
            lines.push('');
            lines.push('print(f"p_hat = {p_hat:.6f}")');
            lines.push('print(f"Z = {z:.4f}, p = {p_value:.6f}")');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"Decision: {\'Reject H0\' if p_value < alpha else \'Fail to reject H0\'}")');

        } else {
            lines.push('# Two-Proportion Z-Test');
            lines.push('x1, n1, x2, n2 = ' + r._x1 + ', ' + r._n1 + ', ' + r._x2 + ', ' + r._n2);
            lines.push('p1, p2 = x1/n1, x2/n2');
            lines.push('p_pooled = (x1 + x2) / (n1 + n2)');
            lines.push('se = math.sqrt(p_pooled * (1 - p_pooled) * (1/n1 + 1/n2))');
            lines.push('z = (p1 - p2) / se');
            lines.push('');
            if (r.alt === 'two-tailed') {
                lines.push('p_value = 2 * (1 - stats.norm.cdf(abs(z)))');
            } else if (r.alt === 'greater') {
                lines.push('p_value = 1 - stats.norm.cdf(z)');
            } else {
                lines.push('p_value = stats.norm.cdf(z)');
            }
            lines.push('');
            lines.push('print(f"p1 = {p1:.6f}, p2 = {p2:.6f}")');
            lines.push('print(f"Pooled p = {p_pooled:.6f}")');
            lines.push('print(f"Z = {z:.4f}, p = {p_value:.6f}")');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"Decision: {\'Reject H0\' if p_value < alpha else \'Fail to reject H0\'}")');
        }

        return lines.join('\n');
    }

    function loadCompiler() {
        if (!state.results) return;
        var code = preparePython();
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
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

    function tex(expr) {
        return '<span class="stat-katex" data-tex="' + expr.replace(/"/g, '&quot;') + '"></span>';
    }

    function renderKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var t = spans[i].getAttribute('data-tex');
            if (t && window.katex) {
                try { window.katex.render(t, spans[i], { throwOnError: false }); } catch (e) {}
            }
        }
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '&#x1F4CA;', 'No Result Yet', 'Enter parameters and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        document.getElementById('ht-graph-container').innerHTML = '';
        state.results = null;

        /* Clear all inputs in all panels */
        var panels = ['ht-input-zmean', 'ht-input-tmean', 'ht-input-zprop', 'ht-input-twoprop'];
        for (var p = 0; p < panels.length; p++) {
            var panel = document.getElementById(panels[p]);
            if (!panel) continue;
            var inputs = panel.querySelectorAll('input[type="number"], input[type="text"]');
            for (var i = 0; i < inputs.length; i++) inputs[i].value = '';
            var selects = panel.querySelectorAll('select');
            for (var j = 0; j < selects.length; j++) selects[j].selectedIndex = 0;
        }
    }

    /* ===== Quick Examples ===== */
    function applyExample(key) {
        var ex = EXAMPLES[key];
        if (!ex) return;
        setMode(ex.mode);

        if (ex.mode === 'zmean') {
            document.getElementById('ht-zm-xbar').value = ex.xbar;
            document.getElementById('ht-zm-mu0').value = ex.mu0;
            document.getElementById('ht-zm-sigma').value = ex.sigma;
            document.getElementById('ht-zm-n').value = ex.n;
            document.getElementById('ht-zm-alpha').value = ex.alpha;
            document.getElementById('ht-zm-alt').value = ex.alt;
        } else if (ex.mode === 'tmean') {
            document.getElementById('ht-tm-xbar').value = ex.xbar;
            document.getElementById('ht-tm-mu0').value = ex.mu0;
            document.getElementById('ht-tm-s').value = ex.s;
            document.getElementById('ht-tm-n').value = ex.n;
            document.getElementById('ht-tm-alpha').value = ex.alpha;
            document.getElementById('ht-tm-alt').value = ex.alt;
        } else if (ex.mode === 'zprop') {
            document.getElementById('ht-zp-x').value = ex.x;
            document.getElementById('ht-zp-n').value = ex.n;
            document.getElementById('ht-zp-p0').value = ex.p0;
            document.getElementById('ht-zp-alpha').value = ex.alpha;
            document.getElementById('ht-zp-alt').value = ex.alt;
        } else if (ex.mode === 'twoprop') {
            document.getElementById('ht-tp-x1').value = ex.x1;
            document.getElementById('ht-tp-n1').value = ex.n1;
            document.getElementById('ht-tp-x2').value = ex.x2;
            document.getElementById('ht-tp-n2').value = ex.n2;
            document.getElementById('ht-tp-alpha').value = ex.alpha;
            document.getElementById('ht-tp-alt').value = ex.alt;
        }

        calculate();
    }

    /* ===== FAQ Toggle ===== */
    function initFAQ() {
        document.querySelectorAll('.stat-faq-question').forEach(function(q) {
            q.addEventListener('click', function() {
                var item = this.parentElement;
                var wasActive = item.classList.contains('active');
                /* Close all */
                document.querySelectorAll('.stat-faq-item').forEach(function(el) { el.classList.remove('active'); });
                if (!wasActive) item.classList.add('active');
            });
        });
    }

    /* ===== Scroll Reveal ===== */
    function initScrollReveal() {
        if (!('IntersectionObserver' in window)) {
            document.querySelectorAll('.stat-anim').forEach(function(el) { el.classList.add('stat-visible'); });
            return;
        }
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(e) {
                if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }
            });
        }, { threshold: 0.1 });
        document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        setMode(shared.mode);

        if (shared.mode === 'zmean') {
            if (shared.xbar != null) document.getElementById('ht-zm-xbar').value = shared.xbar;
            if (shared.mu0 != null) document.getElementById('ht-zm-mu0').value = shared.mu0;
            if (shared.sigma != null) document.getElementById('ht-zm-sigma').value = shared.sigma;
            if (shared.n != null) document.getElementById('ht-zm-n').value = shared.n;
            if (shared.alpha != null) document.getElementById('ht-zm-alpha').value = shared.alpha;
            if (shared.alt) document.getElementById('ht-zm-alt').value = shared.alt;
        } else if (shared.mode === 'tmean') {
            if (shared.xbar != null) document.getElementById('ht-tm-xbar').value = shared.xbar;
            if (shared.mu0 != null) document.getElementById('ht-tm-mu0').value = shared.mu0;
            if (shared.s != null) document.getElementById('ht-tm-s').value = shared.s;
            if (shared.n != null) document.getElementById('ht-tm-n').value = shared.n;
            if (shared.alpha != null) document.getElementById('ht-tm-alpha').value = shared.alpha;
            if (shared.alt) document.getElementById('ht-tm-alt').value = shared.alt;
        } else if (shared.mode === 'zprop') {
            if (shared.x != null) document.getElementById('ht-zp-x').value = shared.x;
            if (shared.n != null) document.getElementById('ht-zp-n').value = shared.n;
            if (shared.p0 != null) document.getElementById('ht-zp-p0').value = shared.p0;
            if (shared.alpha != null) document.getElementById('ht-zp-alpha').value = shared.alpha;
            if (shared.alt) document.getElementById('ht-zp-alt').value = shared.alt;
        } else if (shared.mode === 'twoprop') {
            if (shared.x1 != null) document.getElementById('ht-tp-x1').value = shared.x1;
            if (shared.n1 != null) document.getElementById('ht-tp-n1').value = shared.n1;
            if (shared.x2 != null) document.getElementById('ht-tp-x2').value = shared.x2;
            if (shared.n2 != null) document.getElementById('ht-tp-n2').value = shared.n2;
            if (shared.alpha != null) document.getElementById('ht-tp-alpha').value = shared.alpha;
            if (shared.alt) document.getElementById('ht-tp-alt').value = shared.alt;
        }

        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();
        initFAQ();
        initScrollReveal();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        /* Enter key on inputs */
        var allInputs = document.querySelectorAll('#ht-input-zmean input, #ht-input-tmean input, #ht-input-zprop input, #ht-input-twoprop input');
        for (var i = 0; i < allInputs.length; i++) {
            allInputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        /* Mode buttons via data-mode */
        document.querySelectorAll('[data-mode]').forEach(function(el) {
            el.addEventListener('click', function() {
                var m = this.getAttribute('data-mode');
                if (m === 'zmean' || m === 'tmean' || m === 'zprop' || m === 'twoprop') {
                    setMode(m);
                }
            });
        });

        /* Example chips */
        document.querySelectorAll('[data-ht-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-ht-example'));
            });
        });

        /* Restore from shared URL or auto-calculate with default zmean values */
        var restored = restoreFromUrl();
        G.loadJStat(function() {
            if (!restored) {
                setMode('zmean');
                document.getElementById('ht-zm-xbar').value = '105';
                document.getElementById('ht-zm-mu0').value = '100';
                document.getElementById('ht-zm-sigma').value = '15';
                document.getElementById('ht-zm-n').value = '36';
                document.getElementById('ht-zm-alpha').value = '0.05';
                document.getElementById('ht-zm-alt').value = 'two-tailed';
            }
            calculate();
        });
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
