/**
 * Chi-Square Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for chi-square distribution.
 * Uses Plotly (lazy-loaded) for distribution chart.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'independence',
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('chi-result-content');
        els.resultActions  = document.getElementById('chi-result-actions');
        els.graphPanel     = document.getElementById('chi-graph-panel');
        els.graphContainer = document.getElementById('chi-graph-container');
        els.compilerPanel  = document.getElementById('chi-compiler-panel');
        els.compilerIframe = document.getElementById('chi-compiler-iframe');
        els.calcBtn        = document.getElementById('chi-calc-btn');
        els.clearBtn       = document.getElementById('chi-clear-btn');

        els.modeIndependence = document.getElementById('chi-mode-independence');
        els.modeGoodness     = document.getElementById('chi-mode-goodness');

        els.panelIndependence = document.getElementById('chi-input-independence');
        els.panelGoodness     = document.getElementById('chi-input-goodness');

        els.numRows        = document.getElementById('chi-num-rows');
        els.numCols        = document.getElementById('chi-num-cols');
        els.tableContainer = document.getElementById('chi-table-container');

        els.observed = document.getElementById('chi-observed');
        els.expected = document.getElementById('chi-expected');
        els.alpha    = document.getElementById('chi-alpha');
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
                if (target === 'chi-graph-panel') loadGraph();
                if (target === 'chi-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeIndependence.addEventListener('click', function() { setMode('independence'); });
        els.modeGoodness.addEventListener('click', function() { setMode('goodness'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeIndependence.classList.toggle('active', m === 'independence');
        els.modeGoodness.classList.toggle('active', m === 'goodness');
        els.panelIndependence.style.display = m === 'independence' ? '' : 'none';
        els.panelGoodness.style.display = m === 'goodness' ? '' : 'none';
    }

    /* ===== Dynamic Contingency Table ===== */
    function buildTable(rows, cols) {
        var h = '<table class="chi-contingency-table"><thead><tr><th></th>';
        for (var c = 0; c < cols; c++) {
            h += '<th>Col ' + (c + 1) + '</th>';
        }
        h += '<th class="chi-total-col">Row Total</th></tr></thead><tbody>';
        for (var r = 0; r < rows; r++) {
            h += '<tr><th>Row ' + (r + 1) + '</th>';
            for (var cc = 0; cc < cols; cc++) {
                h += '<td><input type="number" id="chi-cell-' + r + '-' + cc + '" class="chi-cell-input" min="0" step="1" placeholder="0"></td>';
            }
            h += '<td class="chi-total-col chi-row-total" id="chi-rowtotal-' + r + '">0</td></tr>';
        }
        h += '</tbody><tfoot><tr><th class="chi-total-col">Col Total</th>';
        for (var c2 = 0; c2 < cols; c2++) {
            h += '<td class="chi-total-col chi-col-total" id="chi-coltotal-' + c2 + '">0</td>';
        }
        h += '<td class="chi-total-col chi-grand-total" id="chi-grandtotal">0</td></tr></tfoot></table>';
        els.tableContainer.innerHTML = h;

        // Live totals
        var inputs = els.tableContainer.querySelectorAll('.chi-cell-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('input', function() { updateTotals(rows, cols); });
        }
    }

    function updateTotals(rows, cols) {
        var grand = 0;
        for (var r = 0; r < rows; r++) {
            var rowSum = 0;
            for (var c = 0; c < cols; c++) {
                var v = parseFloat(document.getElementById('chi-cell-' + r + '-' + c).value) || 0;
                rowSum += v;
            }
            var rtEl = document.getElementById('chi-rowtotal-' + r);
            if (rtEl) rtEl.textContent = rowSum;
            grand += rowSum;
        }
        for (var c2 = 0; c2 < cols; c2++) {
            var colSum = 0;
            for (var r2 = 0; r2 < rows; r2++) {
                colSum += (parseFloat(document.getElementById('chi-cell-' + r2 + '-' + c2).value) || 0);
            }
            var ctEl = document.getElementById('chi-coltotal-' + c2);
            if (ctEl) ctEl.textContent = colSum;
        }
        var gtEl = document.getElementById('chi-grandtotal');
        if (gtEl) gtEl.textContent = grand;
    }

    function getTableDimensions() {
        return {
            rows: parseInt(els.numRows.value, 10) || 2,
            cols: parseInt(els.numCols.value, 10) || 2
        };
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch (e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var alpha = parseFloat(els.alpha.value) || 0.05;
        var r;

        if (state.mode === 'independence') {
            r = calcIndependence(alpha);
        } else {
            r = calcGoodness(alpha);
        }

        if (!r) return;
        state.result = r;

        if (r.mode === 'independence') {
            renderIndependenceResult(r);
        } else {
            renderGoodnessResult(r);
        }

        E.renderActionButtons(els.resultActions, {
            toolName: 'Chi-Square Test',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                if (s.mode === 'independence') {
                    lines.push('\\textbf{Chi-Square Test of Independence}\\\\[4pt]');
                    lines.push('\\chi^2 = \\sum \\frac{(O_{ij} - E_{ij})^2}{E_{ij}} = ' + C.fmt(s.chiSq, 4) + '\\\\');
                    lines.push('df = (r-1)(c-1) = (' + s.rows + '-1)(' + s.cols + '-1) = ' + s.df + '\\\\');
                    lines.push('p = ' + fmtP(s.pValue) + '\\\\');
                    lines.push('\\alpha = ' + s.alpha + '\\\\');
                    if (s.critValue !== null) lines.push('\\chi^2_{\\text{crit}} = ' + C.fmt(s.critValue, 4) + '\\\\');
                    lines.push("\\text{Cram\u00E9r's V} = " + C.fmt(s.cramersV, 4) + '\\\\');
                    lines.push('\\text{Decision: ' + (s.reject ? 'Reject' : 'Fail to reject') + ' } H_0');
                } else {
                    lines.push('\\textbf{Chi-Square Goodness-of-Fit Test}\\\\[4pt]');
                    lines.push('\\text{Observed: } [' + s.observed.join(', ') + ']\\\\');
                    lines.push('\\text{Expected: } [' + s.expected.map(function(e) { return C.fmt(e, 2); }).join(', ') + ']\\\\');
                    lines.push('\\chi^2 = \\sum_{i=1}^{k} \\frac{(O_i - E_i)^2}{E_i} = ' + C.fmt(s.chiSq, 4) + '\\\\');
                    lines.push('df = k - 1 = ' + s.k + ' - 1 = ' + s.df + '\\\\');
                    lines.push('p = ' + fmtP(s.pValue) + '\\\\');
                    lines.push('\\alpha = ' + s.alpha + '\\\\');
                    if (s.critValue !== null) lines.push('\\chi^2_{\\text{crit}} = ' + C.fmt(s.critValue, 4) + '\\\\');
                    lines.push('\\text{Decision: ' + (s.reject ? 'Reject' : 'Fail to reject') + ' } H_0');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: s.mode, alpha: s.alpha };
                if (s.mode === 'independence') {
                    shared.rows = s.rows;
                    shared.cols = s.cols;
                    shared.observed = s.observed;
                } else {
                    shared.observed = s.observed;
                    shared.expected = s.expected;
                }
                return shared;
            },
            resultEl: '#chi-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="chi-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="chi-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) loadGraph();
    }

    function calcIndependence(alpha) {
        var dim = getTableDimensions();
        var rows = dim.rows, cols = dim.cols;
        var observed = [];
        var rowTotals = [];
        var colTotals = new Array(cols);
        for (var c = 0; c < cols; c++) colTotals[c] = 0;
        var grandTotal = 0;

        for (var r = 0; r < rows; r++) {
            observed[r] = [];
            var rowSum = 0;
            for (var c2 = 0; c2 < cols; c2++) {
                var v = parseFloat(document.getElementById('chi-cell-' + r + '-' + c2).value);
                if (isNaN(v) || v < 0) { C.showError(els.resultContent, 'All cell values must be non-negative numbers.'); return null; }
                observed[r][c2] = v;
                rowSum += v;
                colTotals[c2] += v;
            }
            rowTotals[r] = rowSum;
            grandTotal += rowSum;
        }

        if (grandTotal === 0) { C.showError(els.resultContent, 'Grand total must be greater than 0.'); return null; }

        // Expected frequencies
        var expected = [];
        for (var r2 = 0; r2 < rows; r2++) {
            expected[r2] = [];
            for (var c3 = 0; c3 < cols; c3++) {
                expected[r2][c3] = (rowTotals[r2] * colTotals[c3]) / grandTotal;
            }
        }

        // Chi-square statistic and contributions
        var chiSq = 0;
        var contributions = [];
        for (var r3 = 0; r3 < rows; r3++) {
            contributions[r3] = [];
            for (var c4 = 0; c4 < cols; c4++) {
                var diff = observed[r3][c4] - expected[r3][c4];
                var contrib = (diff * diff) / expected[r3][c4];
                contributions[r3][c4] = contrib;
                chiSq += contrib;
            }
        }

        var df = (rows - 1) * (cols - 1);
        var pValue = window.jStat ? (1 - window.jStat.chisquare.cdf(chiSq, df)) : null;
        var critValue = window.jStat ? window.jStat.chisquare.inv(1 - alpha, df) : null;
        var minDim = Math.min(rows, cols);
        var cramersV = Math.sqrt(chiSq / (grandTotal * (minDim - 1)));

        return {
            mode: 'independence', rows: rows, cols: cols,
            observed: observed, expected: expected, contributions: contributions,
            rowTotals: rowTotals, colTotals: colTotals, grandTotal: grandTotal,
            chiSq: chiSq, df: df, pValue: pValue, critValue: critValue,
            alpha: alpha, cramersV: cramersV, reject: pValue !== null ? pValue < alpha : null
        };
    }

    function calcGoodness(alpha) {
        var obs = C.parseNumbers(els.observed.value);
        if (!obs || obs.length < 2) { C.showError(els.resultContent, 'Enter at least 2 observed frequencies (comma or space separated).'); return null; }

        var k = obs.length;
        var obsTotal = 0;
        for (var i = 0; i < k; i++) {
            if (obs[i] < 0) { C.showError(els.resultContent, 'Observed frequencies must be non-negative.'); return null; }
            obsTotal += obs[i];
        }
        if (obsTotal === 0) { C.showError(els.resultContent, 'Total observed count must be greater than 0.'); return null; }

        var exp = C.parseNumbers(els.expected.value);
        if (!exp || exp.length === 0) {
            // Equal expected frequencies
            exp = [];
            var eq = obsTotal / k;
            for (var j = 0; j < k; j++) exp[j] = eq;
        }

        if (exp.length !== k) { C.showError(els.resultContent, 'Observed (' + k + ') and expected (' + exp.length + ') must have the same number of categories.'); return null; }

        var chiSq = 0;
        var contributions = [];
        for (var i2 = 0; i2 < k; i2++) {
            if (exp[i2] <= 0) { C.showError(els.resultContent, 'Expected frequencies must be positive.'); return null; }
            var diff = obs[i2] - exp[i2];
            var contrib = (diff * diff) / exp[i2];
            contributions[i2] = contrib;
            chiSq += contrib;
        }

        var df = k - 1;
        var pValue = window.jStat ? (1 - window.jStat.chisquare.cdf(chiSq, df)) : null;
        var critValue = window.jStat ? window.jStat.chisquare.inv(1 - alpha, df) : null;

        return {
            mode: 'goodness', k: k,
            observed: obs, expected: exp, contributions: contributions,
            total: obsTotal, chiSq: chiSq, df: df,
            pValue: pValue, critValue: critValue,
            alpha: alpha, reject: pValue !== null ? pValue < alpha : null
        };
    }

    /* ===== Render Helpers ===== */
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

    function sigBadge(reject) {
        if (reject === null) return '';
        return reject
            ? '<span class="stat-badge stat-badge-danger">Significant</span>'
            : '<span class="stat-badge stat-badge-success">Not Significant</span>';
    }

    function fmtP(p) {
        if (p === null) return 'N/A (jStat loading)';
        if (p < 0.0001) return '< 0.0001';
        return C.fmt(p, 6);
    }

    function cramersInterpretation(v) {
        if (v < 0.1) return 'Negligible';
        if (v < 0.3) return 'Small';
        if (v < 0.5) return 'Medium';
        return 'Large';
    }

    /* ===== Render: Independence ===== */
    function renderIndependenceResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">\u03C7\u00B2 = ' + C.fmt(r.chiSq, 4) + '</span>' + sigBadge(r.reject) + '<span class="stat-hero-label">Chi-Square Test of Independence</span></div>';

        h += buildSection('Test Results', [
            ['Chi-Square Statistic (\u03C7\u00B2)', C.fmt(r.chiSq, 4)],
            ['Degrees of Freedom (df)', r.df],
            ['p-value', fmtP(r.pValue)],
            ['Critical Value (\u03B1 = ' + r.alpha + ')', r.critValue !== null ? C.fmt(r.critValue, 4) : 'N/A'],
            ['Significance Level (\u03B1)', r.alpha]
        ]);

        h += buildSection('Effect Size', [
            ["Cram\u00E9r's V", C.fmt(r.cramersV, 4)],
            ['Interpretation', cramersInterpretation(r.cramersV)]
        ]);

        // Expected frequencies table
        h += '<div class="stat-section"><div class="stat-section-title">Expected Frequencies</div>';
        h += '<div class="chi-table-wrapper"><table class="chi-result-table"><thead><tr><th></th>';
        for (var c = 0; c < r.cols; c++) h += '<th>Col ' + (c + 1) + '</th>';
        h += '</tr></thead><tbody>';
        for (var rr = 0; rr < r.rows; rr++) {
            h += '<tr><th>Row ' + (rr + 1) + '</th>';
            for (var cc = 0; cc < r.cols; cc++) {
                h += '<td>' + C.fmt(r.expected[rr][cc], 2) + '</td>';
            }
            h += '</tr>';
        }
        h += '</tbody></table></div></div>';

        // Contributions table
        h += '<div class="stat-section"><div class="stat-section-title">Cell Contributions (O\u2212E)\u00B2/E</div>';
        h += '<div class="chi-table-wrapper"><table class="chi-result-table"><thead><tr><th></th>';
        for (var c2 = 0; c2 < r.cols; c2++) h += '<th>Col ' + (c2 + 1) + '</th>';
        h += '</tr></thead><tbody>';
        for (var r2 = 0; r2 < r.rows; r2++) {
            h += '<tr><th>Row ' + (r2 + 1) + '</th>';
            for (var c3 = 0; c3 < r.cols; c3++) {
                h += '<td>' + C.fmt(r.contributions[r2][c3], 4) + '</td>';
            }
            h += '</tr>';
        }
        h += '</tbody></table></div></div>';

        // Calculation steps
        h += buildSteps(r);

        // Interpretation
        if (r.reject !== null) {
            var cls = r.reject ? 'stat-interpretation-warning' : 'stat-interpretation-normal';
            var txt = r.reject
                ? '<strong>Reject H\u2080:</strong> There is a statistically significant association between the row and column variables (p = ' + fmtP(r.pValue) + ' < \u03B1 = ' + r.alpha + '). The observed frequencies differ significantly from what would be expected under independence.'
                : '<strong>Fail to reject H\u2080:</strong> There is no statistically significant association between the row and column variables (p = ' + fmtP(r.pValue) + ' \u2265 \u03B1 = ' + r.alpha + '). The observed frequencies are consistent with independence.';
            h += '<div class="stat-interpretation ' + cls + '">' + txt + '</div>';
        }

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Goodness of Fit ===== */
    function renderGoodnessResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">\u03C7\u00B2 = ' + C.fmt(r.chiSq, 4) + '</span>' + sigBadge(r.reject) + '<span class="stat-hero-label">Chi-Square Goodness-of-Fit Test</span></div>';

        h += buildSection('Test Results', [
            ['Chi-Square Statistic (\u03C7\u00B2)', C.fmt(r.chiSq, 4)],
            ['Degrees of Freedom (df)', r.df],
            ['p-value', fmtP(r.pValue)],
            ['Critical Value (\u03B1 = ' + r.alpha + ')', r.critValue !== null ? C.fmt(r.critValue, 4) : 'N/A'],
            ['Significance Level (\u03B1)', r.alpha],
            ['Number of Categories (k)', r.k]
        ]);

        // Expected vs Observed list
        h += '<div class="stat-section"><div class="stat-section-title">Expected vs Observed Frequencies</div>';
        h += '<div class="chi-table-wrapper"><table class="chi-result-table"><thead><tr><th>Category</th><th>Observed</th><th>Expected</th><th>(O\u2212E)\u00B2/E</th></tr></thead><tbody>';
        for (var i = 0; i < r.k; i++) {
            h += '<tr><td>' + (i + 1) + '</td><td>' + C.fmt(r.observed[i], 2) + '</td><td>' + C.fmt(r.expected[i], 2) + '</td><td>' + C.fmt(r.contributions[i], 4) + '</td></tr>';
        }
        h += '</tbody></table></div></div>';

        // Steps
        h += buildSteps(r);

        // Interpretation
        if (r.reject !== null) {
            var cls = r.reject ? 'stat-interpretation-warning' : 'stat-interpretation-normal';
            var txt = r.reject
                ? '<strong>Reject H\u2080:</strong> The observed distribution differs significantly from the expected distribution (p = ' + fmtP(r.pValue) + ' < \u03B1 = ' + r.alpha + '). The data does not fit the hypothesized distribution.'
                : '<strong>Fail to reject H\u2080:</strong> There is no significant difference between the observed and expected distributions (p = ' + fmtP(r.pValue) + ' \u2265 \u03B1 = ' + r.alpha + '). The data is consistent with the hypothesized distribution.';
            h += '<div class="stat-interpretation ' + cls + '">' + txt + '</div>';
        }

        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== KaTeX Steps ===== */
    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (r.mode === 'independence') {
            h += step(1, 'Expected Frequencies', '<span class="stat-katex" data-tex="E_{ij} = \\frac{R_i \\times C_j}{N}"></span>');
            h += step(2, 'Chi-Square Statistic', '<span class="stat-katex" data-tex="\\chi^2 = \\sum \\frac{(O_{ij} - E_{ij})^2}{E_{ij}} = ' + C.fmt(r.chiSq, 4) + '"></span>');
            h += step(3, 'Degrees of Freedom', '<span class="stat-katex" data-tex="df = (r-1)(c-1) = (' + r.rows + '-1)(' + r.cols + '-1) = ' + r.df + '"></span>');
            h += step(4, 'p-value', '<span class="stat-katex" data-tex="p = P(\\chi^2_{' + r.df + '} \\geq ' + C.fmt(r.chiSq, 4) + ') = ' + fmtP(r.pValue) + '"></span>');
            h += step(5, "Cram\u00E9r's V", '<span class="stat-katex" data-tex="V = \\sqrt{\\frac{\\chi^2}{N \\cdot (\\min(r,c)-1)}} = \\sqrt{\\frac{' + C.fmt(r.chiSq, 4) + '}{' + r.grandTotal + ' \\cdot ' + (Math.min(r.rows, r.cols) - 1) + '}} = ' + C.fmt(r.cramersV, 4) + '"></span>');
        } else {
            h += step(1, 'Expected Frequencies', '<span class="stat-katex" data-tex="E_i = ' + (r.expected[0] === r.expected[1] ? '\\frac{N}{k} = \\frac{' + C.fmt(r.total, 0) + '}{' + r.k + '} = ' + C.fmt(r.expected[0], 2) : 'specified') + '"></span>');
            h += step(2, 'Chi-Square Statistic', '<span class="stat-katex" data-tex="\\chi^2 = \\sum_{i=1}^{k} \\frac{(O_i - E_i)^2}{E_i} = ' + C.fmt(r.chiSq, 4) + '"></span>');
            h += step(3, 'Degrees of Freedom', '<span class="stat-katex" data-tex="df = k - 1 = ' + r.k + ' - 1 = ' + r.df + '"></span>');
            h += step(4, 'p-value', '<span class="stat-katex" data-tex="p = P(\\chi^2_{' + r.df + '} \\geq ' + C.fmt(r.chiSq, 4) + ') = ' + fmtP(r.pValue) + '"></span>');
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
    function loadGraph() {
        if (!state.result) return;
        G.loadPlotly(function() {
            var r = state.result;
            var container = document.getElementById('chi-graph-container');
            container.innerHTML = '';

            var df = r.df;
            var chiSq = r.chiSq;
            var critVal = r.critValue;

            // Generate chi-square PDF curve
            var maxX = Math.max(chiSq * 1.5, (critVal || 0) * 1.5, df + 4 * Math.sqrt(2 * df));
            maxX = Math.max(maxX, 10);
            var nPoints = 200;
            var step = maxX / nPoints;
            var xCurve = [], yCurve = [];
            var xShade = [], yShade = [];

            for (var i = 0; i <= nPoints; i++) {
                var x = i * step;
                var y = chiSqPDF(x, df);
                xCurve.push(x);
                yCurve.push(y);
                if (critVal !== null && x >= critVal) {
                    xShade.push(x);
                    yShade.push(y);
                }
            }

            var traces = [
                {
                    x: xCurve, y: yCurve, type: 'scatter', mode: 'lines',
                    line: { color: '#6366f1', width: 2 }, name: '\u03C7\u00B2(' + df + ') distribution',
                    showlegend: true
                }
            ];

            // Shaded rejection region
            if (critVal !== null && xShade.length > 0) {
                traces.push({
                    x: [critVal].concat(xShade).concat([xShade[xShade.length - 1]]),
                    y: [0].concat(yShade).concat([0]),
                    type: 'scatter', fill: 'toself', mode: 'lines',
                    fillcolor: 'rgba(239,68,68,0.25)', line: { color: 'rgba(239,68,68,0.5)', width: 0 },
                    name: 'Rejection region (\u03B1 = ' + r.alpha + ')', showlegend: true
                });
            }

            var shapes = [];
            var annotations = [];

            // Vertical line at chi-square statistic
            shapes.push({
                type: 'line', x0: chiSq, x1: chiSq, y0: 0, y1: 1, yref: 'paper',
                line: { color: '#ef4444', width: 2 }
            });
            annotations.push({
                x: chiSq, y: 1.05, yref: 'paper', text: '\u03C7\u00B2 = ' + C.fmt(chiSq, 2),
                showarrow: false, font: { size: 11, color: '#ef4444' }
            });

            // Vertical dashed line at critical value
            if (critVal !== null) {
                shapes.push({
                    type: 'line', x0: critVal, x1: critVal, y0: 0, y1: 1, yref: 'paper',
                    line: { color: '#f59e0b', width: 2, dash: 'dash' }
                });
                annotations.push({
                    x: critVal, y: 0.95, yref: 'paper', text: 'Crit = ' + C.fmt(critVal, 2),
                    showarrow: false, font: { size: 11, color: '#f59e0b' }
                });
            }

            var layout = {
                title: '\u03C7\u00B2 Distribution (df = ' + df + ')',
                xaxis: { title: '\u03C7\u00B2', zeroline: true, rangemode: 'tozero' },
                yaxis: { title: 'Density', rangemode: 'tozero' },
                shapes: shapes, annotations: annotations,
                showlegend: true, legend: { orientation: 'h', y: -0.25 },
                margin: { t: 50, b: 70, l: 50, r: 30 },
                height: 340
            };

            window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
        });
    }

    /** Approximate chi-square PDF using jStat or manual calculation */
    function chiSqPDF(x, df) {
        if (x <= 0) return 0;
        if (window.jStat) return window.jStat.chisquare.pdf(x, df);
        // Fallback: use the formula: f(x) = x^(df/2-1) * e^(-x/2) / (2^(df/2) * Gamma(df/2))
        var k2 = df / 2;
        var logPdf = (k2 - 1) * Math.log(x) - x / 2 - k2 * Math.log(2) - lnGamma(k2);
        return Math.exp(logPdf);
    }

    /** Log-gamma via Stirling approximation (fallback when jStat unavailable) */
    function lnGamma(z) {
        if (window.jStat) return window.jStat.gammaln(z);
        // Lanczos approximation
        var g = 7;
        var coef = [0.99999999999980993, 676.5203681218851, -1259.1392167224028,
            771.32342877765313, -176.61502916214059, 12.507343278686905,
            -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7];
        if (z < 0.5) return Math.log(Math.PI / Math.sin(Math.PI * z)) - lnGamma(1 - z);
        z -= 1;
        var x = coef[0];
        for (var i = 1; i < g + 2; i++) x += coef[i] / (z + i);
        var t = z + g + 0.5;
        return 0.5 * Math.log(2 * Math.PI) + (z + 0.5) * Math.log(t) - t + Math.log(x);
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [];

        lines.push('import numpy as np');
        lines.push('from scipy import stats');
        lines.push('');

        if (r.mode === 'independence') {
            lines.push('# Observed contingency table');
            lines.push('observed = np.array([');
            for (var rr = 0; rr < r.rows; rr++) {
                lines.push('    [' + r.observed[rr].join(', ') + ']' + (rr < r.rows - 1 ? ',' : ''));
            }
            lines.push('])');
            lines.push('');
            lines.push('# Chi-square test of independence');
            lines.push('chi2, p_value, dof, expected = stats.chi2_contingency(observed)');
            lines.push('');
            lines.push('print(f"Chi-Square Statistic: {chi2:.4f}")');
            lines.push('print(f"Degrees of Freedom: {dof}")');
            lines.push('print(f"p-value: {p_value:.6f}")');
            lines.push('print(f"\\nExpected Frequencies:")');
            lines.push('print(np.round(expected, 2))');
            lines.push('');
            lines.push('# Cramer\'s V');
            lines.push('n = observed.sum()');
            lines.push('min_dim = min(observed.shape) - 1');
            lines.push('cramers_v = np.sqrt(chi2 / (n * min_dim))');
            lines.push('print(f"\\nCramer\'s V: {cramers_v:.4f}")');
            lines.push('');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"\\nReject H0: {p_value < alpha}")');
        } else {
            lines.push('# Observed frequencies');
            lines.push('observed = np.array([' + r.observed.join(', ') + '])');
            if (r.expected[0] === r.expected[1]) {
                lines.push('');
                lines.push('# Goodness-of-fit test (equal expected)');
                lines.push('chi2, p_value = stats.chisquare(observed)');
            } else {
                lines.push('expected = np.array([' + r.expected.map(function(e) { return C.fmt(e, 2); }).join(', ') + '])');
                lines.push('');
                lines.push('# Goodness-of-fit test');
                lines.push('chi2, p_value = stats.chisquare(observed, f_exp=expected)');
            }
            lines.push('');
            lines.push('print(f"Chi-Square Statistic: {chi2:.4f}")');
            lines.push('print(f"Degrees of Freedom: {len(observed) - 1}")');
            lines.push('print(f"p-value: {p_value:.6f}")');
            lines.push('');
            lines.push('alpha = ' + r.alpha);
            lines.push('print(f"\\nReject H0: {p_value < alpha}")');
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
        document.getElementById('chi-graph-container').innerHTML = '';
        state.result = null;

        if (state.mode === 'independence') {
            var dim = getTableDimensions();
            var inputs = els.tableContainer.querySelectorAll('.chi-cell-input');
            for (var i = 0; i < inputs.length; i++) inputs[i].value = '';
            updateTotals(dim.rows, dim.cols);
        } else {
            els.observed.value = '';
            els.expected.value = '';
        }
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'gender-product') {
            setMode('independence');
            els.numRows.value = '2';
            els.numCols.value = '2';
            buildTable(2, 2);
            setCell(0, 0, 30); setCell(0, 1, 20);
            setCell(1, 0, 15); setCell(1, 1, 35);
            updateTotals(2, 2);
            els.alpha.value = '0.05';
        } else if (ex === 'survey-3x3') {
            setMode('independence');
            els.numRows.value = '3';
            els.numCols.value = '3';
            buildTable(3, 3);
            setCell(0, 0, 20); setCell(0, 1, 15); setCell(0, 2, 10);
            setCell(1, 0, 12); setCell(1, 1, 18); setCell(1, 2, 25);
            setCell(2, 0, 8);  setCell(2, 1, 12); setCell(2, 2, 20);
            updateTotals(3, 3);
            els.alpha.value = '0.05';
        } else if (ex === 'dice-roll') {
            setMode('goodness');
            els.observed.value = '18, 15, 22, 17, 12, 16';
            els.expected.value = '';
            els.alpha.value = '0.05';
        } else if (ex === 'coin-flip') {
            setMode('goodness');
            els.observed.value = '58, 42';
            els.expected.value = '50, 50';
            els.alpha.value = '0.05';
        }
        calculate();
    }

    function setCell(r, c, val) {
        var el = document.getElementById('chi-cell-' + r + '-' + c);
        if (el) el.value = val;
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        var alpha = shared.alpha || 0.05;
        els.alpha.value = alpha;

        if (shared.mode === 'independence' && shared.observed) {
            setMode('independence');
            var rows = shared.rows || shared.observed.length;
            var cols = shared.cols || (shared.observed[0] ? shared.observed[0].length : 2);
            els.numRows.value = rows;
            els.numCols.value = cols;
            buildTable(rows, cols);
            for (var r = 0; r < rows; r++) {
                for (var c = 0; c < cols; c++) {
                    var val = shared.observed[r] && shared.observed[r][c] != null ? shared.observed[r][c] : 0;
                    setCell(r, c, val);
                }
            }
            updateTotals(rows, cols);
        } else if (shared.mode === 'goodness' && shared.observed) {
            setMode('goodness');
            els.observed.value = shared.observed.join(', ');
            if (shared.expected) {
                els.expected.value = shared.expected.map(function(e) { return C.fmt(e, 2); }).join(', ');
            }
        } else {
            return false;
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

        // Row/col select triggers rebuild
        els.numRows.addEventListener('change', function() {
            var dim = getTableDimensions();
            buildTable(dim.rows, dim.cols);
        });
        els.numCols.addEventListener('change', function() {
            var dim = getTableDimensions();
            buildTable(dim.rows, dim.cols);
        });

        // Enter key on inputs
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && (e.target.classList.contains('chi-cell-input') || e.target.id === 'chi-observed' || e.target.id === 'chi-expected')) {
                calculate();
            }
        });

        // Quick examples
        var exContainer = document.getElementById('chi-examples');
        if (exContainer) {
            exContainer.querySelectorAll('[data-example]').forEach(function(el) {
                el.addEventListener('click', function() {
                    applyExample(this.getAttribute('data-example'));
                });
            });
        }

        // Scroll animations
        C.initScrollReveal();

        // Pre-load jStat
        G.loadJStat(function() {});

        // Restore from shared URL or load default example
        var restored = restoreFromUrl();
        if (restored) {
            calculate();
        } else {
            setMode('independence');
            buildTable(2, 2);
            applyExample('gender-product');
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
