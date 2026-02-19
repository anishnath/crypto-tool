/**
 * Effect Size Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Pure JS — no jStat needed.
 * Uses Plotly (lazy-loaded) for effect-size visualizations.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== Z-score table ===== */
    var Z_TABLE = { 90: 1.645, 95: 1.96, 99: 2.576 };

    /* ===== State ===== */
    var state = {
        mode: 'cohend',
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('es-result-content');
        els.resultActions  = document.getElementById('es-result-actions');
        els.graphPanel     = document.getElementById('es-graph-panel');
        els.graphContainer = document.getElementById('es-graph-container');
        els.compilerPanel  = document.getElementById('es-compiler-panel');
        els.compilerIframe = document.getElementById('es-compiler-iframe');
        els.calcBtn        = document.getElementById('es-calc-btn');
        els.clearBtn       = document.getElementById('es-clear-btn');

        els.modeCohend  = document.getElementById('es-mode-cohend');
        els.modePearson = document.getElementById('es-mode-pearsonr');
        els.modeEta     = document.getElementById('es-mode-eta');
        els.modeOdds    = document.getElementById('es-mode-odds');

        els.panelCohend  = document.getElementById('es-input-cohend');
        els.panelPearson = document.getElementById('es-input-pearsonr');
        els.panelEta     = document.getElementById('es-input-eta');
        els.panelOdds    = document.getElementById('es-input-odds');
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
                if (target === 'es-graph-panel') loadGraph();
                if (target === 'es-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeCohend.addEventListener('click', function() { setMode('cohend'); });
        els.modePearson.addEventListener('click', function() { setMode('pearsonr'); });
        els.modeEta.addEventListener('click', function() { setMode('eta'); });
        els.modeOdds.addEventListener('click', function() { setMode('odds'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeCohend.classList.toggle('active', m === 'cohend');
        els.modePearson.classList.toggle('active', m === 'pearsonr');
        els.modeEta.classList.toggle('active', m === 'eta');
        els.modeOdds.classList.toggle('active', m === 'odds');
        els.panelCohend.style.display  = m === 'cohend'  ? '' : 'none';
        els.panelPearson.style.display = m === 'pearsonr' ? '' : 'none';
        els.panelEta.style.display     = m === 'eta'      ? '' : 'none';
        els.panelOdds.style.display    = m === 'odds'     ? '' : 'none';
    }

    /* ===== Sub-panel toggles ===== */
    function initSubPanels() {
        var rMethod = document.getElementById('es-r-method');
        if (rMethod) {
            rMethod.addEventListener('change', function() {
                var v = this.value;
                document.getElementById('es-r-direct-panel').style.display = v === 'direct' ? '' : 'none';
                document.getElementById('es-r-ttest-panel').style.display  = v === 'ttest'  ? '' : 'none';
            });
        }
        var etaMethod = document.getElementById('es-eta-method');
        if (etaMethod) {
            etaMethod.addEventListener('change', function() {
                var v = this.value;
                document.getElementById('es-eta-fstat-panel').style.display  = v === 'fstat'  ? '' : 'none';
                document.getElementById('es-eta-direct-panel').style.display = v === 'direct' ? '' : 'none';
            });
        }
    }

    /* ===== Confidence Level ===== */
    function getConfLevel() {
        var sel = document.getElementById('es-confidence');
        return sel ? parseFloat(sel.value) : 95;
    }

    function getZ() {
        var conf = getConfLevel();
        return Z_TABLE[conf] || 1.96;
    }

    /* ===== Interpretation helpers ===== */
    function interpretCohenD(d) {
        var a = Math.abs(d);
        if (a < 0.2)  return { label: 'Negligible', cls: 'stat-interpretation-normal' };
        if (a < 0.5)  return { label: 'Small',      cls: 'stat-interpretation-warning' };
        if (a < 0.8)  return { label: 'Medium',     cls: 'stat-interpretation-caution' };
        return                { label: 'Large',      cls: 'stat-interpretation-reject' };
    }

    function interpretR(r) {
        var a = Math.abs(r);
        if (a < 0.1)  return { label: 'Negligible', cls: 'stat-interpretation-normal' };
        if (a < 0.3)  return { label: 'Small',      cls: 'stat-interpretation-warning' };
        if (a < 0.5)  return { label: 'Medium',     cls: 'stat-interpretation-caution' };
        return                { label: 'Large',      cls: 'stat-interpretation-reject' };
    }

    function interpretEta(eta) {
        if (eta < 0.01) return { label: 'Negligible', cls: 'stat-interpretation-normal' };
        if (eta < 0.06) return { label: 'Small',      cls: 'stat-interpretation-warning' };
        if (eta < 0.14) return { label: 'Medium',     cls: 'stat-interpretation-caution' };
        return                 { label: 'Large',      cls: 'stat-interpretation-reject' };
    }

    function interpretOR(val) {
        if (val > 0.9 && val < 1.1) return { label: 'No Effect',  cls: 'stat-interpretation-normal' };
        if (val >= 1.1)             return { label: 'Increased',   cls: 'stat-interpretation-reject' };
        return                             { label: 'Protective',  cls: 'stat-interpretation-warning' };
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var r;
        var z = getZ();
        var conf = getConfLevel();

        if (state.mode === 'cohend') {
            var m1  = parseFloat(document.getElementById('es-m1').value);
            var m2  = parseFloat(document.getElementById('es-m2').value);
            var sd1 = parseFloat(document.getElementById('es-sd1').value);
            var sd2 = parseFloat(document.getElementById('es-sd2').value);
            var n1  = parseFloat(document.getElementById('es-n1').value);
            var n2  = parseFloat(document.getElementById('es-n2').value);
            if (isNaN(m1) || isNaN(m2)) { C.showError(els.resultContent, 'Enter valid means for both groups.'); return; }
            if (isNaN(sd1) || sd1 <= 0 || isNaN(sd2) || sd2 <= 0) { C.showError(els.resultContent, 'Enter valid standard deviations (> 0).'); return; }
            if (isNaN(n1) || n1 < 2 || isNaN(n2) || n2 < 2) { C.showError(els.resultContent, 'Enter valid sample sizes (>= 2).'); return; }
            var sdPooled = Math.sqrt((sd1 * sd1 + sd2 * sd2) / 2);
            var d = (m1 - m2) / sdPooled;
            var seD = Math.sqrt((n1 + n2) / (n1 * n2) + (d * d) / (2 * (n1 + n2)));
            var ciLow = d - z * seD;
            var ciHigh = d + z * seD;
            var interp = interpretCohenD(d);
            r = { mode: 'cohend', m1: m1, m2: m2, sd1: sd1, sd2: sd2, n1: n1, n2: n2, sdPooled: sdPooled, d: d, se: seD, ciLow: ciLow, ciHigh: ciHigh, conf: conf, z: z, interp: interp };
            renderCohenD(r);

        } else if (state.mode === 'pearsonr') {
            var method = document.getElementById('es-r-method').value;
            var rVal, n;
            if (method === 'direct') {
                rVal = parseFloat(document.getElementById('es-r').value);
                n    = parseFloat(document.getElementById('es-r-n').value);
                if (isNaN(rVal) || rVal < -1 || rVal > 1) { C.showError(els.resultContent, 'Enter a valid r value (-1 to 1).'); return; }
                if (isNaN(n) || n < 4) { C.showError(els.resultContent, 'Enter a valid sample size (>= 4).'); return; }
            } else {
                var t  = parseFloat(document.getElementById('es-r-t').value);
                var df = parseFloat(document.getElementById('es-r-df').value);
                if (isNaN(t)) { C.showError(els.resultContent, 'Enter a valid t-statistic.'); return; }
                if (isNaN(df) || df < 1) { C.showError(els.resultContent, 'Enter valid degrees of freedom (>= 1).'); return; }
                rVal = t / Math.sqrt(t * t + df);
                n = df + 2;
            }
            var rSq = rVal * rVal;
            var zr = 0.5 * Math.log((1 + rVal) / (1 - rVal));
            var seZr = 1 / Math.sqrt(n - 3);
            var zrLow  = zr - z * seZr;
            var zrHigh = zr + z * seZr;
            var ciLow  = (Math.exp(2 * zrLow) - 1) / (Math.exp(2 * zrLow) + 1);
            var ciHigh = (Math.exp(2 * zrHigh) - 1) / (Math.exp(2 * zrHigh) + 1);
            var interp = interpretR(rVal);
            r = { mode: 'pearsonr', method: method, r: rVal, n: n, rSq: rSq, zr: zr, seZr: seZr, zrLow: zrLow, zrHigh: zrHigh, ciLow: ciLow, ciHigh: ciHigh, conf: conf, z: z, interp: interp };
            if (method === 'ttest') { r.t = t; r.df = df; }
            renderPearsonR(r);

        } else if (state.mode === 'eta') {
            var method = document.getElementById('es-eta-method').value;
            var eta;
            if (method === 'fstat') {
                var F   = parseFloat(document.getElementById('es-eta-f').value);
                var dfB = parseFloat(document.getElementById('es-eta-df-between').value);
                var dfW = parseFloat(document.getElementById('es-eta-df-within').value);
                if (isNaN(F) || F < 0) { C.showError(els.resultContent, 'Enter a valid F-statistic (>= 0).'); return; }
                if (isNaN(dfB) || dfB < 1) { C.showError(els.resultContent, 'Enter valid df between (>= 1).'); return; }
                if (isNaN(dfW) || dfW < 1) { C.showError(els.resultContent, 'Enter valid df within (>= 1).'); return; }
                eta = (F * dfB) / (F * dfB + dfW);
                r = { mode: 'eta', method: 'fstat', F: F, dfB: dfB, dfW: dfW, eta: eta };
            } else {
                var ssB = parseFloat(document.getElementById('es-eta-ss-between').value);
                var ssT = parseFloat(document.getElementById('es-eta-ss-total').value);
                if (isNaN(ssB) || ssB < 0) { C.showError(els.resultContent, 'Enter a valid SS between (>= 0).'); return; }
                if (isNaN(ssT) || ssT <= 0) { C.showError(els.resultContent, 'Enter a valid SS total (> 0).'); return; }
                if (ssB > ssT) { C.showError(els.resultContent, 'SS between cannot exceed SS total.'); return; }
                eta = ssB / ssT;
                r = { mode: 'eta', method: 'direct', ssB: ssB, ssT: ssT, eta: eta };
            }
            var interp = interpretEta(eta);
            r.conf = conf;
            r.interp = interp;
            renderEta(r);

        } else {
            var type = document.getElementById('es-or-type').value;
            var a = parseFloat(document.getElementById('es-or-a').value);
            var b = parseFloat(document.getElementById('es-or-b').value);
            var c = parseFloat(document.getElementById('es-or-c').value);
            var d = parseFloat(document.getElementById('es-or-d').value);
            if (isNaN(a) || a <= 0 || isNaN(b) || b <= 0 || isNaN(c) || c <= 0 || isNaN(d) || d <= 0) {
                C.showError(els.resultContent, 'Enter valid cell counts (all > 0).'); return;
            }
            var val, seLn, label;
            if (type === 'or') {
                val = (a * d) / (b * c);
                seLn = Math.sqrt(1/a + 1/b + 1/c + 1/d);
                label = 'Odds Ratio';
            } else {
                val = (a / (a + c)) / (b / (b + d));
                seLn = Math.sqrt(1/a - 1/(a + c) + 1/b - 1/(b + d));
                label = 'Risk Ratio';
            }
            var lnVal = Math.log(val);
            var ciLow  = Math.exp(lnVal - z * seLn);
            var ciHigh = Math.exp(lnVal + z * seLn);
            var interp = interpretOR(val);
            r = { mode: 'odds', type: type, a: a, b: b, c: c, d: d, val: val, lnVal: lnVal, seLn: seLn, ciLow: ciLow, ciHigh: ciHigh, conf: conf, z: z, label: label, interp: interp };
            renderOdds(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Effect Size Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Effect Size Calculator}\\\\[4pt]');
                if (s.mode === 'cohend') {
                    lines.push('M_1 = ' + C.fmt(s.m1, 4) + ',\\quad M_2 = ' + C.fmt(s.m2, 4) + '\\\\');
                    lines.push('SD_1 = ' + C.fmt(s.sd1, 4) + ',\\quad SD_2 = ' + C.fmt(s.sd2, 4) + '\\\\');
                    lines.push('n_1 = ' + s.n1 + ',\\quad n_2 = ' + s.n2 + '\\\\');
                    lines.push('SD_{pooled} = \\sqrt{\\frac{SD_1^2 + SD_2^2}{2}} = ' + C.fmt(s.sdPooled, 4) + '\\\\');
                    lines.push('d = \\frac{M_1 - M_2}{SD_{pooled}} = ' + C.fmt(s.d, 4) + '\\\\');
                    lines.push('SE(d) = ' + C.fmt(s.se, 6) + '\\\\');
                    lines.push(C.fmt(s.conf, 0) + '\\%\\;CI = [' + C.fmt(s.ciLow, 4) + ',\\,' + C.fmt(s.ciHigh, 4) + ']\\\\');
                    lines.push('\\text{Interpretation: ' + s.interp.label + '}');
                } else if (s.mode === 'pearsonr') {
                    lines.push('r = ' + C.fmt(s.r, 4) + '\\\\');
                    lines.push('n = ' + s.n + '\\\\');
                    lines.push('r^2 = ' + C.fmt(s.rSq, 4) + '\\;(' + C.fmt(s.rSq * 100, 2) + '\\%)\\\\');
                    lines.push('z_r = ' + C.fmt(s.zr, 6) + '\\\\');
                    lines.push('SE(z_r) = ' + C.fmt(s.seZr, 6) + '\\\\');
                    lines.push(C.fmt(s.conf, 0) + '\\%\\;CI = [' + C.fmt(s.ciLow, 4) + ',\\,' + C.fmt(s.ciHigh, 4) + ']\\\\');
                    lines.push('\\text{Interpretation: ' + s.interp.label + '}');
                } else if (s.mode === 'eta') {
                    if (s.method === 'fstat') {
                        lines.push('F = ' + C.fmt(s.F, 4) + ',\\quad df_B = ' + s.dfB + ',\\quad df_W = ' + s.dfW + '\\\\');
                    } else {
                        lines.push('SS_B = ' + C.fmt(s.ssB, 4) + ',\\quad SS_T = ' + C.fmt(s.ssT, 4) + '\\\\');
                    }
                    lines.push('\\eta^2 = ' + C.fmt(s.eta, 4) + '\\\\');
                    lines.push('\\text{Variance Explained} = ' + C.fmt(s.eta * 100, 2) + '\\%\\\\');
                    lines.push('\\text{Interpretation: ' + s.interp.label + '}');
                } else {
                    lines.push('\\text{' + s.label + '}\\\\');
                    lines.push('a = ' + s.a + ',\\;b = ' + s.b + ',\\;c = ' + s.c + ',\\;d = ' + s.d + '\\\\');
                    lines.push(s.label + ' = ' + C.fmt(s.val, 4) + '\\\\');
                    lines.push('\\ln(' + s.label + ') = ' + C.fmt(s.lnVal, 6) + '\\\\');
                    lines.push('SE(\\ln) = ' + C.fmt(s.seLn, 6) + '\\\\');
                    lines.push(C.fmt(s.conf, 0) + '\\%\\;CI = [' + C.fmt(s.ciLow, 4) + ',\\,' + C.fmt(s.ciHigh, 4) + ']\\\\');
                    lines.push('\\text{Interpretation: ' + s.interp.label + '}');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: state.mode, conf: s.conf };
                if (s.mode === 'cohend') {
                    shared.m1 = s.m1; shared.m2 = s.m2;
                    shared.sd1 = s.sd1; shared.sd2 = s.sd2;
                    shared.n1 = s.n1; shared.n2 = s.n2;
                } else if (s.mode === 'pearsonr') {
                    shared.method = s.method;
                    shared.r = s.r; shared.n = s.n;
                    if (s.method === 'ttest') { shared.t = s.t; shared.df = s.df; }
                } else if (s.mode === 'eta') {
                    shared.method = s.method;
                    if (s.method === 'fstat') { shared.F = s.F; shared.dfB = s.dfB; shared.dfW = s.dfW; }
                    else { shared.ssB = s.ssB; shared.ssT = s.ssT; }
                } else {
                    shared.type = s.type;
                    shared.a = s.a; shared.b = s.b; shared.c = s.c; shared.d = s.d;
                }
                return shared;
            },
            resultEl: '#es-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="es-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="es-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    /* ===== Render: Cohen's d ===== */
    function renderCohenD(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.d, 4) + '</span>';
        h += '<span class="stat-hero-label">Cohen\'s d <span class="stat-badge ' + r.interp.cls + '">' + r.interp.label + '</span></span></div>';
        h += buildSection('Effect Size', [
            ['Mean 1 (M\u2081)', C.fmt(r.m1, 4)],
            ['Mean 2 (M\u2082)', C.fmt(r.m2, 4)],
            ['SD 1 (SD\u2081)', C.fmt(r.sd1, 4)],
            ['SD 2 (SD\u2082)', C.fmt(r.sd2, 4)],
            ['n\u2081', r.n1],
            ['n\u2082', r.n2],
            ['Pooled SD', C.fmt(r.sdPooled, 4)],
            ['Cohen\'s d', C.fmt(r.d, 4)]
        ]);
        h += buildSection('Confidence Interval', [
            ['SE(d)', C.fmt(r.se, 6)],
            ['z-critical (' + C.fmt(r.conf, 0) + '%)', C.fmt(r.z, 4)],
            ['Lower Bound', C.fmt(r.ciLow, 4)],
            ['Upper Bound', C.fmt(r.ciHigh, 4)]
        ]);
        h += buildSteps('cohend', r);
        h += '<div class="stat-interpretation ' + r.interp.cls + '"><strong>Interpretation:</strong> Cohen\'s d = ' + C.fmt(r.d, 4) + ' indicates a <strong>' + r.interp.label.toLowerCase() + '</strong> effect size. The ' + C.fmt(r.conf, 0) + '% CI is [' + C.fmt(r.ciLow, 4) + ', ' + C.fmt(r.ciHigh, 4) + '].</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Pearson's r ===== */
    function renderPearsonR(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.r, 4) + '</span>';
        h += '<span class="stat-hero-label">Pearson\'s r <span class="stat-badge ' + r.interp.cls + '">' + r.interp.label + '</span></span></div>';
        var rows = [];
        if (r.method === 'ttest') {
            rows.push(['t-statistic', C.fmt(r.t, 4)]);
            rows.push(['Degrees of Freedom', r.df]);
        }
        rows.push(['Pearson\'s r', C.fmt(r.r, 4)]);
        rows.push(['Sample Size (n)', r.n]);
        rows.push(['r\u00B2 (Variance Explained)', C.fmt(r.rSq * 100, 2) + '%']);
        h += buildSection('Effect Size', rows);
        h += buildSection('Confidence Interval', [
            ['Fisher\'s z\u1D63', C.fmt(r.zr, 6)],
            ['SE(z\u1D63)', C.fmt(r.seZr, 6)],
            ['CI in z-space', '[' + C.fmt(r.zrLow, 4) + ', ' + C.fmt(r.zrHigh, 4) + ']'],
            ['CI for r', '[' + C.fmt(r.ciLow, 4) + ', ' + C.fmt(r.ciHigh, 4) + ']']
        ]);
        h += buildSteps('pearsonr', r);
        h += '<div class="stat-interpretation ' + r.interp.cls + '"><strong>Interpretation:</strong> r = ' + C.fmt(r.r, 4) + ' indicates a <strong>' + r.interp.label.toLowerCase() + '</strong> effect. ' + C.fmt(r.rSq * 100, 2) + '% of the variance is explained. The ' + C.fmt(r.conf, 0) + '% CI is [' + C.fmt(r.ciLow, 4) + ', ' + C.fmt(r.ciHigh, 4) + '].</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Eta-squared ===== */
    function renderEta(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.eta, 4) + '</span>';
        h += '<span class="stat-hero-label">\u03B7\u00B2 (Eta-squared) <span class="stat-badge ' + r.interp.cls + '">' + r.interp.label + '</span></span></div>';
        var rows = [];
        if (r.method === 'fstat') {
            rows.push(['F-statistic', C.fmt(r.F, 4)]);
            rows.push(['df between', r.dfB]);
            rows.push(['df within', r.dfW]);
        } else {
            rows.push(['SS between', C.fmt(r.ssB, 4)]);
            rows.push(['SS total', C.fmt(r.ssT, 4)]);
        }
        rows.push(['\u03B7\u00B2', C.fmt(r.eta, 4)]);
        rows.push(['Variance Explained', C.fmt(r.eta * 100, 2) + '%']);
        h += buildSection('Effect Size', rows);
        h += buildSteps('eta', r);
        h += '<div class="stat-interpretation ' + r.interp.cls + '"><strong>Interpretation:</strong> \u03B7\u00B2 = ' + C.fmt(r.eta, 4) + ' indicates a <strong>' + r.interp.label.toLowerCase() + '</strong> effect. ' + C.fmt(r.eta * 100, 2) + '% of total variance is explained by group membership.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Odds / Risk Ratio ===== */
    function renderOdds(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.val, 4) + '</span>';
        h += '<span class="stat-hero-label">' + r.label + ' <span class="stat-badge ' + r.interp.cls + '">' + r.interp.label + '</span></span></div>';
        h += buildSection('2\u00D72 Contingency Table', [
            ['a (Exposed + Outcome)', r.a],
            ['b (Unexposed + Outcome)', r.b],
            ['c (Exposed + No Outcome)', r.c],
            ['d (Unexposed + No Outcome)', r.d]
        ]);
        h += buildSection('Effect Size', [
            [r.label, C.fmt(r.val, 4)],
            ['ln(' + r.label + ')', C.fmt(r.lnVal, 6)],
            ['SE(ln)', C.fmt(r.seLn, 6)]
        ]);
        h += buildSection('Confidence Interval', [
            ['z-critical (' + C.fmt(r.conf, 0) + '%)', C.fmt(r.z, 4)],
            ['Lower Bound', C.fmt(r.ciLow, 4)],
            ['Upper Bound', C.fmt(r.ciHigh, 4)]
        ]);
        h += buildSteps('odds', r);
        var effDesc = r.val > 1 ? 'an increased likelihood' : r.val < 1 ? 'a protective effect' : 'no association';
        h += '<div class="stat-interpretation ' + r.interp.cls + '"><strong>Interpretation:</strong> ' + r.label + ' = ' + C.fmt(r.val, 4) + ' suggests <strong>' + effDesc + '</strong>. The ' + C.fmt(r.conf, 0) + '% CI is [' + C.fmt(r.ciLow, 4) + ', ' + C.fmt(r.ciHigh, 4) + '].' + (r.ciLow > 1 || r.ciHigh < 1 ? ' The CI does not include 1, indicating statistical significance.' : ' The CI includes 1, so the result is not statistically significant.') + '</div>';
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
        if (mode === 'cohend') {
            h += step(1, 'Pooled Standard Deviation', '<span class="stat-katex" data-tex="SD_{pooled} = \\sqrt{\\frac{SD_1^2 + SD_2^2}{2}} = \\sqrt{\\frac{' + C.fmt(r.sd1*r.sd1, 2) + ' + ' + C.fmt(r.sd2*r.sd2, 2) + '}{2}} = ' + C.fmt(r.sdPooled, 4) + '"></span>');
            h += step(2, 'Cohen\'s d', '<span class="stat-katex" data-tex="d = \\frac{M_1 - M_2}{SD_{pooled}} = \\frac{' + C.fmt(r.m1, 4) + ' - ' + C.fmt(r.m2, 4) + '}{' + C.fmt(r.sdPooled, 4) + '} = ' + C.fmt(r.d, 4) + '"></span>');
            h += step(3, 'Standard Error', '<span class="stat-katex" data-tex="SE(d) = \\sqrt{\\frac{n_1+n_2}{n_1 \\cdot n_2} + \\frac{d^2}{2(n_1+n_2)}} = ' + C.fmt(r.se, 6) + '"></span>');
            h += step(4, 'Confidence Interval', '<span class="stat-katex" data-tex="CI = d \\pm z \\cdot SE = ' + C.fmt(r.d, 4) + ' \\pm ' + C.fmt(r.z, 4) + ' \\times ' + C.fmt(r.se, 6) + ' = [' + C.fmt(r.ciLow, 4) + ',\\,' + C.fmt(r.ciHigh, 4) + ']"></span>');
        } else if (mode === 'pearsonr') {
            if (r.method === 'ttest') {
                h += step(1, 'r from t-statistic', '<span class="stat-katex" data-tex="r = \\frac{t}{\\sqrt{t^2 + df}} = \\frac{' + C.fmt(r.t, 4) + '}{\\sqrt{' + C.fmt(r.t*r.t, 4) + ' + ' + r.df + '}} = ' + C.fmt(r.r, 4) + '"></span>');
            } else {
                h += step(1, 'Observed r', '<span class="stat-katex" data-tex="r = ' + C.fmt(r.r, 4) + '"></span>');
            }
            h += step(2, 'Fisher\'s z Transform', '<span class="stat-katex" data-tex="z_r = \\frac{1}{2}\\ln\\left(\\frac{1+r}{1-r}\\right) = ' + C.fmt(r.zr, 6) + '"></span>');
            h += step(3, 'Standard Error', '<span class="stat-katex" data-tex="SE(z_r) = \\frac{1}{\\sqrt{n-3}} = \\frac{1}{\\sqrt{' + (r.n - 3) + '}} = ' + C.fmt(r.seZr, 6) + '"></span>');
            h += step(4, 'CI in z-space', '<span class="stat-katex" data-tex="CI_z = z_r \\pm z \\cdot SE = [' + C.fmt(r.zrLow, 4) + ',\\,' + C.fmt(r.zrHigh, 4) + ']"></span>');
            h += step(5, 'Back-transform to r', '<span class="stat-katex" data-tex="r = \\frac{e^{2z}-1}{e^{2z}+1} \\Rightarrow CI = [' + C.fmt(r.ciLow, 4) + ',\\,' + C.fmt(r.ciHigh, 4) + ']"></span>');
            h += step(6, 'Variance Explained', '<span class="stat-katex" data-tex="r^2 = ' + C.fmt(r.r, 4) + '^2 = ' + C.fmt(r.rSq, 4) + ' \\;(' + C.fmt(r.rSq * 100, 2) + '\\%)"></span>');
        } else if (mode === 'eta') {
            if (r.method === 'fstat') {
                h += step(1, 'Eta-squared from F', '<span class="stat-katex" data-tex="\\eta^2 = \\frac{F \\cdot df_B}{F \\cdot df_B + df_W} = \\frac{' + C.fmt(r.F, 4) + ' \\times ' + r.dfB + '}{' + C.fmt(r.F, 4) + ' \\times ' + r.dfB + ' + ' + r.dfW + '} = ' + C.fmt(r.eta, 4) + '"></span>');
            } else {
                h += step(1, 'Eta-squared from SS', '<span class="stat-katex" data-tex="\\eta^2 = \\frac{SS_B}{SS_T} = \\frac{' + C.fmt(r.ssB, 4) + '}{' + C.fmt(r.ssT, 4) + '} = ' + C.fmt(r.eta, 4) + '"></span>');
            }
            h += step(2, 'Interpretation', '<span class="stat-katex" data-tex="\\eta^2 = ' + C.fmt(r.eta, 4) + ' \\Rightarrow ' + C.fmt(r.eta * 100, 2) + '\\% \\text{ variance explained}"></span>');
        } else {
            if (r.type === 'or') {
                h += step(1, 'Odds Ratio', '<span class="stat-katex" data-tex="OR = \\frac{a \\cdot d}{b \\cdot c} = \\frac{' + r.a + ' \\times ' + r.d + '}{' + r.b + ' \\times ' + r.c + '} = ' + C.fmt(r.val, 4) + '"></span>');
            } else {
                h += step(1, 'Risk Ratio', '<span class="stat-katex" data-tex="RR = \\frac{a/(a+c)}{b/(b+d)} = \\frac{' + r.a + '/' + (r.a + r.c) + '}{' + r.b + '/' + (r.b + r.d) + '} = ' + C.fmt(r.val, 4) + '"></span>');
            }
            h += step(2, 'Log Transform', '<span class="stat-katex" data-tex="\\ln(' + r.label + ') = ' + C.fmt(r.lnVal, 6) + '"></span>');
            h += step(3, 'Standard Error', '<span class="stat-katex" data-tex="SE(\\ln) = ' + C.fmt(r.seLn, 6) + '"></span>');
            h += step(4, 'Confidence Interval', '<span class="stat-katex" data-tex="CI = e^{\\ln(val) \\pm z \\cdot SE} = [' + C.fmt(r.ciLow, 4) + ',\\,' + C.fmt(r.ciHigh, 4) + ']"></span>');
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
            var container = document.getElementById('es-graph-container');
            container.innerHTML = '';

            if (r.mode === 'cohend') {
                drawCohenDGraph(container, r);
            } else if (r.mode === 'pearsonr') {
                drawPearsonRGraph(container, r);
            } else if (r.mode === 'eta') {
                drawEtaGraph(container, r);
            } else {
                drawOddsGraph(container, r);
            }
        });
    }

    function normalPDF(x, mu, sd) {
        var z = (x - mu) / sd;
        return Math.exp(-0.5 * z * z) / (sd * Math.sqrt(2 * Math.PI));
    }

    function drawCohenDGraph(container, r) {
        var sd = r.sdPooled;
        var mu1 = r.m1, mu2 = r.m2;
        var lo = Math.min(mu1, mu2) - 4 * sd;
        var hi = Math.max(mu1, mu2) + 4 * sd;
        var xs = [], y1s = [], y2s = [];
        for (var i = 0; i <= 200; i++) {
            var x = lo + (hi - lo) * i / 200;
            xs.push(x);
            y1s.push(normalPDF(x, mu1, sd));
            y2s.push(normalPDF(x, mu2, sd));
        }
        var traces = [
            { x: xs, y: y1s, mode: 'lines', name: 'Group 1 (M=' + C.fmt(mu1, 1) + ')', line: { color: '#6366f1', width: 2 }, fill: 'tozeroy', fillcolor: 'rgba(99,102,241,0.15)' },
            { x: xs, y: y2s, mode: 'lines', name: 'Group 2 (M=' + C.fmt(mu2, 1) + ')', line: { color: '#ef4444', width: 2 }, fill: 'tozeroy', fillcolor: 'rgba(239,68,68,0.15)' }
        ];
        var layout = {
            title: 'Cohen\'s d = ' + C.fmt(r.d, 4) + ' — Distribution Overlap',
            xaxis: { title: 'Value' },
            yaxis: { title: 'Density', rangemode: 'tozero' },
            showlegend: true, legend: { orientation: 'h', y: -0.25 },
            margin: { t: 50, b: 70, l: 50, r: 30 },
            height: 320
        };
        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    function drawPearsonRGraph(container, r) {
        var val = r.r;
        var cats = ['r = ' + C.fmt(val, 4)];
        var traces = [
            { type: 'bar', x: cats, y: [val], marker: { color: val >= 0 ? '#6366f1' : '#ef4444' }, width: [0.4], name: 'r' },
            { type: 'scatter', x: [cats[0], cats[0]], y: [r.ciLow, r.ciHigh], mode: 'lines+markers', line: { color: '#1e293b', width: 3 }, marker: { size: 8, color: '#1e293b' }, name: C.fmt(r.conf, 0) + '% CI' }
        ];
        var layout = {
            title: 'Pearson\'s r = ' + C.fmt(val, 4) + ' (r\u00B2 = ' + C.fmt(r.rSq * 100, 1) + '%)',
            yaxis: { title: 'Correlation (r)', range: [-1.1, 1.1], zeroline: true, zerolinecolor: '#94a3b8' },
            xaxis: { title: '' },
            showlegend: true, legend: { orientation: 'h', y: -0.25 },
            margin: { t: 50, b: 70, l: 50, r: 30 },
            height: 320,
            shapes: [{ type: 'line', x0: -0.5, x1: 1.5, y0: 0, y1: 0, line: { color: '#94a3b8', dash: 'dot', width: 1 } }]
        };
        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    function drawEtaGraph(container, r) {
        var traces = [{
            type: 'pie',
            values: [r.eta * 100, (1 - r.eta) * 100],
            labels: ['Explained (\u03B7\u00B2)', 'Unexplained'],
            marker: { colors: ['#6366f1', '#e2e8f0'] },
            textinfo: 'label+percent',
            hole: 0.4
        }];
        var layout = {
            title: '\u03B7\u00B2 = ' + C.fmt(r.eta, 4) + ' — Variance Explained',
            showlegend: true, legend: { orientation: 'h', y: -0.15 },
            margin: { t: 50, b: 50, l: 30, r: 30 },
            height: 320
        };
        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    function drawOddsGraph(container, r) {
        var traces = [
            { x: [r.val], y: [r.label], mode: 'markers', marker: { size: 14, color: '#6366f1', symbol: 'diamond' }, name: r.label, showlegend: true, type: 'scatter' },
            { x: [r.ciLow, r.ciHigh], y: [r.label, r.label], mode: 'lines+markers', line: { color: '#6366f1', width: 4 }, marker: { size: 10, color: '#6366f1' }, name: C.fmt(r.conf, 0) + '% CI', showlegend: true, type: 'scatter' }
        ];
        var layout = {
            title: r.label + ' = ' + C.fmt(r.val, 4) + ' — Forest Plot',
            xaxis: { title: r.label, type: 'log', zeroline: false },
            yaxis: { visible: false, range: [-0.5, 0.5] },
            showlegend: true, legend: { orientation: 'h', y: -0.25 },
            margin: { t: 50, b: 70, l: 30, r: 30 },
            height: 260,
            shapes: [{ type: 'line', x0: 1, x1: 1, y0: -0.5, y1: 0.5, line: { color: '#ef4444', dash: 'dash', width: 2 } }],
            annotations: [{ x: Math.log10(1), y: 0.4, text: 'Null (1.0)', showarrow: false, font: { size: 10, color: '#ef4444' } }]
        };
        window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [];

        if (r.mode === 'cohend') {
            lines.push('import numpy as np');
            lines.push('from scipy import stats');
            lines.push('');
            lines.push('# Cohen\'s d — Two independent groups');
            lines.push('m1, m2 = ' + r.m1 + ', ' + r.m2);
            lines.push('sd1, sd2 = ' + r.sd1 + ', ' + r.sd2);
            lines.push('n1, n2 = ' + r.n1 + ', ' + r.n2);
            lines.push('');
            lines.push('sd_pooled = np.sqrt((sd1**2 + sd2**2) / 2)');
            lines.push('d = (m1 - m2) / sd_pooled');
            lines.push('se_d = np.sqrt((n1+n2)/(n1*n2) + d**2/(2*(n1+n2)))');
            lines.push('z = ' + C.fmt(r.z, 4));
            lines.push('ci = (d - z*se_d, d + z*se_d)');
            lines.push('');
            lines.push('print(f"Pooled SD = {sd_pooled:.4f}")');
            lines.push('print(f"Cohen\'s d = {d:.4f}")');
            lines.push('print(f"SE(d) = {se_d:.6f}")');
            lines.push('print(f"' + C.fmt(r.conf, 0) + '% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
        } else if (r.mode === 'pearsonr') {
            lines.push('import numpy as np');
            lines.push('from scipy import stats');
            lines.push('');
            if (r.method === 'ttest') {
                lines.push('# Pearson r from t-statistic');
                lines.push('t, df = ' + r.t + ', ' + r.df);
                lines.push('r = t / np.sqrt(t**2 + df)');
                lines.push('n = df + 2');
            } else {
                lines.push('# Pearson r — direct input');
                lines.push('r = ' + r.r);
                lines.push('n = ' + r.n);
            }
            lines.push('');
            lines.push('# Fisher z transform for CI');
            lines.push('z_r = 0.5 * np.log((1 + r) / (1 - r))');
            lines.push('se_zr = 1 / np.sqrt(n - 3)');
            lines.push('z = ' + C.fmt(r.z, 4));
            lines.push('ci_z = (z_r - z*se_zr, z_r + z*se_zr)');
            lines.push('ci_r = tuple(np.tanh(z) for z in ci_z)');
            lines.push('');
            lines.push('print(f"r = {r:.4f}")');
            lines.push('print(f"r-squared = {r**2:.4f} ({r**2*100:.2f}%)")');
            lines.push('print(f"Fisher z = {z_r:.6f}")');
            lines.push('print(f"' + C.fmt(r.conf, 0) + '% CI for r: ({ci_r[0]:.4f}, {ci_r[1]:.4f})")');
        } else if (r.mode === 'eta') {
            lines.push('import numpy as np');
            lines.push('from scipy import stats');
            lines.push('');
            if (r.method === 'fstat') {
                lines.push('# Eta-squared from F-statistic');
                lines.push('F, df_b, df_w = ' + r.F + ', ' + r.dfB + ', ' + r.dfW);
                lines.push('eta_sq = (F * df_b) / (F * df_b + df_w)');
            } else {
                lines.push('# Eta-squared from sum of squares');
                lines.push('ss_between = ' + r.ssB);
                lines.push('ss_total = ' + r.ssT);
                lines.push('eta_sq = ss_between / ss_total');
            }
            lines.push('');
            lines.push('print(f"Eta-squared = {eta_sq:.4f}")');
            lines.push('print(f"Variance explained = {eta_sq*100:.2f}%")');
            lines.push('if eta_sq < 0.01: size = "negligible"');
            lines.push('elif eta_sq < 0.06: size = "small"');
            lines.push('elif eta_sq < 0.14: size = "medium"');
            lines.push('else: size = "large"');
            lines.push('print(f"Effect size: {size}")');
        } else {
            lines.push('import numpy as np');
            lines.push('from scipy import stats');
            lines.push('');
            lines.push('# ' + r.label + ' from 2x2 contingency table');
            lines.push('a, b, c, d = ' + r.a + ', ' + r.b + ', ' + r.c + ', ' + r.d);
            if (r.type === 'or') {
                lines.push('OR = (a * d) / (b * c)');
                lines.push('se_ln = np.sqrt(1/a + 1/b + 1/c + 1/d)');
                lines.push('val = OR');
            } else {
                lines.push('RR = (a / (a + c)) / (b / (b + d))');
                lines.push('se_ln = np.sqrt(1/a - 1/(a+c) + 1/b - 1/(b+d))');
                lines.push('val = RR');
            }
            lines.push('z = ' + C.fmt(r.z, 4));
            lines.push('ci = (np.exp(np.log(val) - z*se_ln), np.exp(np.log(val) + z*se_ln))');
            lines.push('');
            lines.push('print(f"' + r.label + ' = {val:.4f}")');
            lines.push('print(f"' + C.fmt(r.conf, 0) + '% CI: ({ci[0]:.4f}, {ci[1]:.4f})")');
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
        document.getElementById('es-graph-container').innerHTML = '';
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'treatment-effect') {
            setMode('cohend');
            document.getElementById('es-m1').value  = '50';
            document.getElementById('es-m2').value  = '55';
            document.getElementById('es-sd1').value = '10';
            document.getElementById('es-sd2').value = '10';
            document.getElementById('es-n1').value  = '30';
            document.getElementById('es-n2').value  = '30';
        } else if (ex === 'study-correlation') {
            setMode('pearsonr');
            document.getElementById('es-r-method').value = 'direct';
            document.getElementById('es-r-direct-panel').style.display = '';
            document.getElementById('es-r-ttest-panel').style.display  = 'none';
            document.getElementById('es-r').value   = '0.35';
            document.getElementById('es-r-n').value = '100';
        } else if (ex === 'anova-groups') {
            setMode('eta');
            document.getElementById('es-eta-method').value = 'fstat';
            document.getElementById('es-eta-fstat-panel').style.display  = '';
            document.getElementById('es-eta-direct-panel').style.display = 'none';
            document.getElementById('es-eta-f').value          = '5.2';
            document.getElementById('es-eta-df-between').value = '2';
            document.getElementById('es-eta-df-within').value  = '57';
        } else if (ex === 'clinical-exposure') {
            setMode('odds');
            document.getElementById('es-or-type').value = 'or';
            document.getElementById('es-or-a').value = '20';
            document.getElementById('es-or-b').value = '10';
            document.getElementById('es-or-c').value = '30';
            document.getElementById('es-or-d').value = '40';
        }
        document.getElementById('es-confidence').value = '95';
        calculate();
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        setMode(shared.mode);

        if (shared.conf != null) document.getElementById('es-confidence').value = shared.conf;

        if (shared.mode === 'cohend') {
            if (shared.m1 != null) document.getElementById('es-m1').value = shared.m1;
            if (shared.m2 != null) document.getElementById('es-m2').value = shared.m2;
            if (shared.sd1 != null) document.getElementById('es-sd1').value = shared.sd1;
            if (shared.sd2 != null) document.getElementById('es-sd2').value = shared.sd2;
            if (shared.n1 != null) document.getElementById('es-n1').value = shared.n1;
            if (shared.n2 != null) document.getElementById('es-n2').value = shared.n2;
        } else if (shared.mode === 'pearsonr') {
            if (shared.method) {
                document.getElementById('es-r-method').value = shared.method;
                document.getElementById('es-r-direct-panel').style.display = shared.method === 'direct' ? '' : 'none';
                document.getElementById('es-r-ttest-panel').style.display  = shared.method === 'ttest'  ? '' : 'none';
            }
            if (shared.method === 'ttest') {
                if (shared.t != null) document.getElementById('es-r-t').value = shared.t;
                if (shared.df != null) document.getElementById('es-r-df').value = shared.df;
            } else {
                if (shared.r != null) document.getElementById('es-r').value = shared.r;
                if (shared.n != null) document.getElementById('es-r-n').value = shared.n;
            }
        } else if (shared.mode === 'eta') {
            if (shared.method) {
                document.getElementById('es-eta-method').value = shared.method;
                document.getElementById('es-eta-fstat-panel').style.display  = shared.method === 'fstat'  ? '' : 'none';
                document.getElementById('es-eta-direct-panel').style.display = shared.method === 'direct' ? '' : 'none';
            }
            if (shared.method === 'fstat') {
                if (shared.F != null) document.getElementById('es-eta-f').value = shared.F;
                if (shared.dfB != null) document.getElementById('es-eta-df-between').value = shared.dfB;
                if (shared.dfW != null) document.getElementById('es-eta-df-within').value = shared.dfW;
            } else {
                if (shared.ssB != null) document.getElementById('es-eta-ss-between').value = shared.ssB;
                if (shared.ssT != null) document.getElementById('es-eta-ss-total').value = shared.ssT;
            }
        } else if (shared.mode === 'odds') {
            if (shared.type) document.getElementById('es-or-type').value = shared.type;
            if (shared.a != null) document.getElementById('es-or-a').value = shared.a;
            if (shared.b != null) document.getElementById('es-or-b').value = shared.b;
            if (shared.c != null) document.getElementById('es-or-c').value = shared.c;
            if (shared.d != null) document.getElementById('es-or-d').value = shared.d;
        }

        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();
        initSubPanels();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.es-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        var exContainer = document.getElementById('es-examples');
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

        // Restore from shared URL or auto-load default example
        var restored = restoreFromUrl();
        if (restored) {
            calculate();
        } else {
            applyExample('treatment-effect');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
