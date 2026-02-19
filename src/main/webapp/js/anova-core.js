/**
 * ANOVA Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Uses jStat (lazy-loaded) for F-distribution CDF and inverse.
 * Uses Plotly (lazy-loaded) for box plots and F-distribution curve.
 *
 * Mode: One-Way ANOVA with dynamic group management.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    var PREFIX = 'av-';

    /* ===== State ===== */
    var state = {
        groupCount: 3,
        groups: [],
        results: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent   = document.getElementById(PREFIX + 'result-content');
        els.resultActions   = document.getElementById(PREFIX + 'result-actions');
        els.graphPanel      = document.getElementById(PREFIX + 'graph-panel');
        els.graphContainer  = document.getElementById(PREFIX + 'graph-container');
        els.compilerPanel   = document.getElementById(PREFIX + 'compiler-panel');
        els.compilerIframe  = document.getElementById(PREFIX + 'compiler-iframe');
        els.calcBtn         = document.getElementById(PREFIX + 'calc-btn');
        els.clearBtn        = document.getElementById(PREFIX + 'clear-btn');
        els.groupsContainer = document.getElementById(PREFIX + 'groups-container');
        els.addGroupBtn     = document.getElementById(PREFIX + 'add-group-btn');
    }

    /* ===== Helpers ===== */
    function parseGroup(text) {
        return C.parseNumbers(text);
    }

    function mean(arr) {
        var s = 0;
        for (var i = 0; i < arr.length; i++) s += arr[i];
        return s / arr.length;
    }

    function stddev(arr) {
        var m = mean(arr);
        var ss = 0;
        for (var i = 0; i < arr.length; i++) ss += (arr[i] - m) * (arr[i] - m);
        return Math.sqrt(ss / (arr.length - 1));
    }

    function arrMin(arr) {
        var m = arr[0];
        for (var i = 1; i < arr.length; i++) if (arr[i] < m) m = arr[i];
        return m;
    }

    function arrMax(arr) {
        var m = arr[0];
        for (var i = 1; i < arr.length; i++) if (arr[i] > m) m = arr[i];
        return m;
    }

    /* ===== Eta-Squared Interpretation ===== */
    function etaLabel(eta) {
        if (eta < 0.01) return 'Negligible';
        if (eta < 0.06) return 'Small';
        if (eta < 0.14) return 'Medium';
        return 'Large';
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

    /* ===== Core Computation ===== */
    function computeANOVA(groups, alpha) {
        var k = groups.length;
        if (k < 2) return { error: 'Need at least 2 groups for ANOVA.' };
        for (var g = 0; g < k; g++) {
            if (groups[g].length < 2) return { error: 'Group ' + (g + 1) + ' needs at least 2 values.' };
        }

        var groupMeans = [];
        var groupSizes = [];
        var groupSDs = [];
        var groupMins = [];
        var groupMaxs = [];
        var allData = [];
        var N = 0;

        for (var i = 0; i < k; i++) {
            var grp = groups[i];
            groupMeans.push(mean(grp));
            groupSizes.push(grp.length);
            groupSDs.push(stddev(grp));
            groupMins.push(arrMin(grp));
            groupMaxs.push(arrMax(grp));
            N += grp.length;
            for (var j = 0; j < grp.length; j++) allData.push(grp[j]);
        }

        var grandMean = mean(allData);

        // Between-group sum of squares
        var SSB = 0;
        for (var i2 = 0; i2 < k; i2++) {
            SSB += groupSizes[i2] * (groupMeans[i2] - grandMean) * (groupMeans[i2] - grandMean);
        }

        // Within-group sum of squares
        var SSW = 0;
        for (var i3 = 0; i3 < k; i3++) {
            var grpMean = groupMeans[i3];
            for (var j2 = 0; j2 < groups[i3].length; j2++) {
                SSW += (groups[i3][j2] - grpMean) * (groups[i3][j2] - grpMean);
            }
        }

        var SST = SSB + SSW;
        var dfb = k - 1;
        var dfw = N - k;
        var dft = N - 1;
        var MSB = SSB / dfb;
        var MSW = SSW / dfw;
        var F = MSB / MSW;

        var pValue = 1 - window.jStat.centralF.cdf(F, dfb, dfw);
        var criticalF = window.jStat.centralF.inv(1 - alpha, dfb, dfw);
        var etaSquared = SSB / SST;
        var significant = pValue < alpha;

        return {
            k: k, N: N, alpha: alpha,
            groups: groups,
            groupMeans: groupMeans,
            groupSizes: groupSizes,
            groupSDs: groupSDs,
            groupMins: groupMins,
            groupMaxs: groupMaxs,
            grandMean: grandMean,
            SSB: SSB, SSW: SSW, SST: SST,
            dfb: dfb, dfw: dfw, dft: dft,
            MSB: MSB, MSW: MSW,
            F: F, pValue: pValue, criticalF: criticalF,
            etaSquared: etaSquared,
            significant: significant
        };
    }

    /* ===== Calculate (main entry) ===== */
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
        var groups = [];
        for (var i = 0; i < state.groupCount; i++) {
            var ta = document.getElementById(PREFIX + 'group-' + i);
            if (!ta) continue;
            var parsed = parseGroup(ta.value);
            if (parsed && parsed.length > 0) groups.push(parsed);
        }

        if (groups.length < 2) {
            C.showError(els.resultContent, 'Enter data for at least 2 groups.');
            return;
        }

        var alphaEl = document.getElementById(PREFIX + 'alpha');
        var alpha = alphaEl ? parseFloat(alphaEl.value) : 0.05;
        if (isNaN(alpha) || alpha <= 0 || alpha >= 1) alpha = 0.05;

        var r = computeANOVA(groups, alpha);
        if (r.error) {
            C.showError(els.resultContent, r.error);
            return;
        }

        state.groups = groups;
        state.results = r;

        renderResults(r);

        var compilerTab = document.querySelector('[data-tab="' + PREFIX + 'compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');

        var graphTab = document.querySelector('[data-tab="' + PREFIX + 'graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) renderGraph();
    }

    /* ===== Dynamic Group Management ===== */
    function buildGroupHTML(index, value) {
        var h = '<div class="av-group-box" id="' + PREFIX + 'group-box-' + index + '">';
        h += '<div class="av-group-header">';
        h += '<h5>Group ' + (index + 1) + '</h5>';
        if (state.groupCount > 2) {
            h += '<button type="button" class="av-remove-group-btn" data-group="' + index + '" title="Remove group">&times;</button>';
        }
        h += '</div>';
        h += '<textarea id="' + PREFIX + 'group-' + index + '" class="stat-textarea" rows="3" placeholder="Enter values separated by commas or spaces">';
        h += (value || '') + '</textarea>';
        h += '</div>';
        return h;
    }

    function rebuildGroups() {
        var values = [];
        for (var i = 0; i < state.groupCount; i++) {
            var ta = document.getElementById(PREFIX + 'group-' + i);
            values.push(ta ? ta.value : '');
        }
        return values;
    }

    function renderGroupInputs(values) {
        var h = '';
        for (var i = 0; i < state.groupCount; i++) {
            h += buildGroupHTML(i, values[i] || '');
        }
        els.groupsContainer.innerHTML = h;
        wireRemoveButtons();
    }

    function addGroup() {
        var values = rebuildGroups();
        state.groupCount++;
        values.push('');
        renderGroupInputs(values);
    }

    function removeGroup(index) {
        if (state.groupCount <= 2) return;
        var values = rebuildGroups();
        values.splice(index, 1);
        state.groupCount--;
        renderGroupInputs(values);
    }

    function wireRemoveButtons() {
        var btns = els.groupsContainer.querySelectorAll('.av-remove-group-btn');
        for (var i = 0; i < btns.length; i++) {
            btns[i].addEventListener('click', function() {
                var idx = parseInt(this.getAttribute('data-group'), 10);
                removeGroup(idx);
            });
        }
    }

    /* ===== Render Results ===== */
    function renderResults(r) {
        var h = '';

        // Decision Banner
        if (r.significant) {
            h += '<div class="stat-interpretation stat-interpretation-warning">';
            h += '<strong>Reject H\u2080</strong> \u2014 At least one group mean differs significantly (p = ' + fmtP(r.pValue) + ' < \u03B1 = ' + r.alpha + ')';
            h += '</div>';
        } else {
            h += '<div class="stat-interpretation stat-interpretation-normal">';
            h += '<strong>Fail to Reject H\u2080</strong> \u2014 No significant differences found between group means (p = ' + fmtP(r.pValue) + ' \u2265 \u03B1 = ' + r.alpha + ')';
            h += '</div>';
        }

        // Hero stat
        var sigBadge = r.significant
            ? '<span class="stat-badge stat-badge-danger">Significant</span>'
            : '<span class="stat-badge stat-badge-success">Not Significant</span>';
        h += '<div class="stat-hero"><span class="stat-hero-value">F = ' + C.fmt(r.F, 4) + '</span>' + sigBadge + '<span class="stat-hero-label">One-Way ANOVA (' + r.k + ' groups, N = ' + r.N + ')</span></div>';

        // ANOVA Table
        h += '<div class="stat-section"><div class="stat-section-title">ANOVA Table</div>';
        h += '<div style="overflow-x:auto">';
        h += '<table class="stat-ops-table">';
        h += '<thead><tr><th>Source</th><th>SS</th><th>df</th><th>MS</th><th>F</th><th>p-value</th></tr></thead>';
        h += '<tbody>';
        h += '<tr><td>Between Groups</td><td>' + C.fmt(r.SSB, 4) + '</td><td>' + r.dfb + '</td><td>' + C.fmt(r.MSB, 4) + '</td><td>' + C.fmt(r.F, 4) + '</td><td>' + fmtP(r.pValue) + '</td></tr>';
        h += '<tr><td>Within Groups</td><td>' + C.fmt(r.SSW, 4) + '</td><td>' + r.dfw + '</td><td>' + C.fmt(r.MSW, 4) + '</td><td></td><td></td></tr>';
        h += '<tr style="font-weight:600"><td>Total</td><td>' + C.fmt(r.SST, 4) + '</td><td>' + r.dft + '</td><td></td><td></td><td></td></tr>';
        h += '</tbody></table></div></div>';

        // Key Results
        h += buildSection('Key Results', [
            ['F-Statistic', C.fmt(r.F, 4)],
            ['P-Value', fmtP(r.pValue)],
            ['Critical F-Value (F\u2091)', C.fmt(r.criticalF, 4)],
            ['\u03B7\u00B2 (Eta-Squared)', C.fmt(r.etaSquared, 4) + ' \u2014 ' + etaLabel(r.etaSquared) + ' effect'],
            ['Significance Level (\u03B1)', r.alpha],
            ['Number of Groups (k)', r.k],
            ['Total Sample Size (N)', r.N]
        ]);

        // Group Statistics
        h += '<div class="stat-section"><div class="stat-section-title">Group Statistics</div>';
        h += '<div style="overflow-x:auto">';
        h += '<table class="stat-ops-table">';
        h += '<thead><tr><th>Group</th><th>n</th><th>Mean</th><th>SD</th><th>Min</th><th>Max</th></tr></thead>';
        h += '<tbody>';
        for (var i = 0; i < r.k; i++) {
            h += '<tr>';
            h += '<td>Group ' + (i + 1) + '</td>';
            h += '<td>' + r.groupSizes[i] + '</td>';
            h += '<td>' + C.fmt(r.groupMeans[i], 4) + '</td>';
            h += '<td>' + C.fmt(r.groupSDs[i], 4) + '</td>';
            h += '<td>' + C.fmt(r.groupMins[i], 4) + '</td>';
            h += '<td>' + C.fmt(r.groupMaxs[i], 4) + '</td>';
            h += '</tr>';
        }
        h += '</tbody></table></div></div>';

        // Interpretation
        h += '<div class="stat-section"><div class="stat-section-title">Interpretation</div>';
        if (r.significant) {
            h += '<p>The one-way ANOVA test found a statistically significant difference between the group means, ';
            h += 'F(' + r.dfb + ', ' + r.dfw + ') = ' + C.fmt(r.F, 4) + ', p = ' + fmtP(r.pValue) + '. ';
            h += 'This means at least one group has a mean that is significantly different from the others.</p>';
        } else {
            h += '<p>The one-way ANOVA test did not find a statistically significant difference between the group means, ';
            h += 'F(' + r.dfb + ', ' + r.dfw + ') = ' + C.fmt(r.F, 4) + ', p = ' + fmtP(r.pValue) + '. ';
            h += 'There is insufficient evidence to conclude that the group means differ.</p>';
        }
        h += '<p><strong>Effect Size:</strong> \u03B7\u00B2 = ' + C.fmt(r.etaSquared, 4) + ' (' + etaLabel(r.etaSquared) + '). ';
        if (r.etaSquared < 0.06) {
            h += 'This indicates that the grouping variable explains a small proportion of the total variance.</p>';
        } else if (r.etaSquared < 0.14) {
            h += 'This indicates a moderate proportion of variance is explained by the grouping variable.</p>';
        } else {
            h += 'This indicates that the grouping variable explains a large proportion of the total variance.</p>';
        }
        h += '</div>';

        // Calculation Steps (KaTeX)
        h += buildSteps(r);

        els.resultContent.innerHTML = h;
        renderKaTeX();

        E.renderActionButtons(els.resultActions, {
            toolName: 'ANOVA Calculator',
            getLatex: function() {
                var s = state.results;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{One-Way ANOVA}\\\\[4pt]');
                lines.push('k = ' + s.k + ',\\quad N = ' + s.N + ',\\quad \\alpha = ' + s.alpha + '\\\\[4pt]');
                lines.push('\\bar{x} = ' + C.fmt(s.grandMean, 4) + '\\\\');
                lines.push('SS_B = ' + C.fmt(s.SSB, 4) + ',\\quad df_B = ' + s.dfb + ',\\quad MS_B = ' + C.fmt(s.MSB, 4) + '\\\\');
                lines.push('SS_W = ' + C.fmt(s.SSW, 4) + ',\\quad df_W = ' + s.dfw + ',\\quad MS_W = ' + C.fmt(s.MSW, 4) + '\\\\');
                lines.push('SS_T = ' + C.fmt(s.SST, 4) + ',\\quad df_T = ' + s.dft + '\\\\[4pt]');
                lines.push('F = \\frac{MS_B}{MS_W} = \\frac{' + C.fmt(s.MSB, 4) + '}{' + C.fmt(s.MSW, 4) + '} = ' + C.fmt(s.F, 4) + '\\\\');
                lines.push('p = ' + fmtP(s.pValue) + ',\\quad F_{\\text{crit}} = ' + C.fmt(s.criticalF, 4) + '\\\\');
                lines.push('\\eta^2 = \\frac{SS_B}{SS_T} = ' + C.fmt(s.etaSquared, 4) + '\\\\[4pt]');
                if (s.significant) {
                    lines.push('p < \\alpha \\Rightarrow \\text{Reject } H_0');
                } else {
                    lines.push('p \\geq \\alpha \\Rightarrow \\text{Fail to Reject } H_0');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.results;
                if (!s) return null;
                var shared = { alpha: s.alpha, groups: [] };
                for (var i = 0; i < s.groups.length; i++) {
                    shared.groups.push(s.groups[i].join(','));
                }
                return shared;
            },
            resultEl: '#av-result-content'
        });
    }

    /* ===== Formatting Helpers ===== */
    function fmtP(p) {
        if (p === null || p === undefined || isNaN(p)) return 'N/A';
        if (p < 0.0001) return '< 0.0001';
        return C.fmt(p, 6);
    }

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

    /* ===== KaTeX Steps ===== */
    function buildSteps(r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';

        // Step 1: Grand Mean
        h += step(1, 'Grand Mean', tex(
            '\\bar{x} = \\frac{\\sum x_i}{N} = \\frac{' + C.fmt(r.grandMean * r.N, 2) + '}{' + r.N + '} = ' + C.fmt(r.grandMean, 4)
        ));

        // Step 2: SSB
        h += step(2, 'Between-Group Sum of Squares (SSB)', tex(
            'SS_B = \\sum_{j=1}^{k} n_j (\\bar{x}_j - \\bar{x})^2 = ' + C.fmt(r.SSB, 4)
        ));

        // Step 3: SSW
        h += step(3, 'Within-Group Sum of Squares (SSW)', tex(
            'SS_W = \\sum_{j=1}^{k} \\sum_{i=1}^{n_j} (x_{ij} - \\bar{x}_j)^2 = ' + C.fmt(r.SSW, 4)
        ));

        // Step 4: MSB and MSW
        h += step(4, 'Mean Squares', tex(
            'MS_B = \\frac{SS_B}{df_B} = \\frac{' + C.fmt(r.SSB, 4) + '}{' + r.dfb + '} = ' + C.fmt(r.MSB, 4)
        ) + '<br>' + tex(
            'MS_W = \\frac{SS_W}{df_W} = \\frac{' + C.fmt(r.SSW, 4) + '}{' + r.dfw + '} = ' + C.fmt(r.MSW, 4)
        ));

        // Step 5: F-statistic
        h += step(5, 'F-Statistic', tex(
            'F = \\frac{MS_B}{MS_W} = \\frac{' + C.fmt(r.MSB, 4) + '}{' + C.fmt(r.MSW, 4) + '} = ' + C.fmt(r.F, 4)
        ));

        // Step 6: Decision
        var decisionTex = r.significant
            ? 'p = ' + fmtP(r.pValue) + ' < \\alpha = ' + r.alpha + ' \\Rightarrow \\text{Reject } H_0'
            : 'p = ' + fmtP(r.pValue) + ' \\geq \\alpha = ' + r.alpha + ' \\Rightarrow \\text{Fail to Reject } H_0';
        h += step(6, 'Decision', tex(decisionTex));

        return h + '</div>';
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

    /* ===== Graph ===== */
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
        var container = document.getElementById(PREFIX + 'graph-container');
        container.innerHTML = '<div id="' + PREFIX + 'boxplot"></div><div id="' + PREFIX + 'fdist" style="margin-top:1rem"></div>';

        var colors = G.getPlotColors();

        // ---- Box Plots ----
        var boxTraces = [];
        var plotColors = ['#6366f1', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#14b8a6', '#f97316'];
        for (var i = 0; i < r.k; i++) {
            boxTraces.push({
                y: r.groups[i],
                type: 'box',
                name: 'Group ' + (i + 1),
                marker: { color: plotColors[i % plotColors.length] },
                boxmean: true
            });
        }

        var boxLayout = {
            title: { text: 'Group Distributions (Box Plots)', font: { size: 14, color: colors.text } },
            paper_bgcolor: colors.paper,
            plot_bgcolor: colors.bg,
            font: { family: 'Inter, -apple-system, sans-serif', color: colors.text, size: 12 },
            yaxis: { title: 'Value', gridcolor: colors.grid },
            xaxis: { gridcolor: colors.grid },
            showlegend: true,
            legend: { orientation: 'h', y: -0.2 },
            margin: { t: 40, b: 60, l: 50, r: 20 },
            height: 320
        };

        window.Plotly.newPlot(PREFIX + 'boxplot', boxTraces, boxLayout, { responsive: true, displayModeBar: false });

        // ---- F-Distribution Curve ----
        var maxX = Math.max(r.F * 1.5, r.criticalF * 1.5, r.dfb + 4);
        maxX = Math.max(maxX, 6);
        var nPts = 300;
        var xVals = [], yVals = [];
        var xShade = [], yShade = [];

        for (var p = 0; p <= nPts; p++) {
            var x = (maxX * p) / nPts;
            var y = 0;
            try { y = window.jStat.centralF.pdf(x, r.dfb, r.dfw); } catch (e) { y = 0; }
            if (isNaN(y) || !isFinite(y)) y = 0;
            xVals.push(x);
            yVals.push(y);
            if (x >= r.criticalF) {
                xShade.push(x);
                yShade.push(y);
            }
        }

        var fTraces = [];

        // Main curve
        fTraces.push({
            x: xVals, y: yVals, type: 'scatter', mode: 'lines',
            line: { color: '#6366f1', width: 2 },
            name: 'F(' + r.dfb + ', ' + r.dfw + ')'
        });

        // Shaded rejection region
        if (xShade.length > 0) {
            fTraces.push({
                x: [r.criticalF].concat(xShade).concat([xShade[xShade.length - 1]]),
                y: [0].concat(yShade).concat([0]),
                type: 'scatter', fill: 'toself', mode: 'lines',
                fillcolor: 'rgba(239,68,68,0.25)',
                line: { color: 'rgba(239,68,68,0.5)', width: 0 },
                name: 'Rejection Region (\u03B1 = ' + r.alpha + ')',
                showlegend: true
            });
        }

        // F-statistic vertical line
        var fPdf = 0;
        try { fPdf = window.jStat.centralF.pdf(r.F, r.dfb, r.dfw); } catch (e) {}
        if (isNaN(fPdf) || !isFinite(fPdf)) fPdf = 0;
        fTraces.push({
            x: [r.F, r.F], y: [0, fPdf], type: 'scatter', mode: 'lines',
            line: { color: '#10b981', width: 3 },
            name: 'F = ' + C.fmt(r.F, 4)
        });

        // Critical value dashed line
        var critPdf = 0;
        try { critPdf = window.jStat.centralF.pdf(r.criticalF, r.dfb, r.dfw); } catch (e) {}
        if (isNaN(critPdf) || !isFinite(critPdf)) critPdf = 0;
        fTraces.push({
            x: [r.criticalF, r.criticalF], y: [0, critPdf], type: 'scatter', mode: 'lines',
            line: { color: '#ef4444', width: 2, dash: 'dash' },
            name: 'F\u2091 = ' + C.fmt(r.criticalF, 4)
        });

        var fLayout = {
            title: { text: 'F-Distribution (df\u2081=' + r.dfb + ', df\u2082=' + r.dfw + ')', font: { size: 14, color: colors.text } },
            paper_bgcolor: colors.paper,
            plot_bgcolor: colors.bg,
            font: { family: 'Inter, -apple-system, sans-serif', color: colors.text, size: 12 },
            xaxis: { title: 'F-value', zeroline: true, gridcolor: colors.grid, rangemode: 'tozero' },
            yaxis: { title: 'Density', rangemode: 'tozero', gridcolor: colors.grid },
            showlegend: true,
            legend: { orientation: 'h', y: -0.25 },
            margin: { t: 40, b: 70, l: 50, r: 20 },
            height: 320
        };

        window.Plotly.newPlot(PREFIX + 'fdist', fTraces, fLayout, { responsive: true, displayModeBar: false });
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.results) return;
        var r = state.results;
        var code = preparePython(r);
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    function preparePython(r) {
        var lines = [];
        lines.push('import numpy as np');
        lines.push('from scipy import stats');
        lines.push('');
        lines.push('# One-Way ANOVA');

        for (var i = 0; i < r.k; i++) {
            lines.push('group' + (i + 1) + ' = np.array([' + r.groups[i].join(', ') + '])');
        }

        lines.push('');
        var groupVars = [];
        for (var j = 0; j < r.k; j++) groupVars.push('group' + (j + 1));
        lines.push('f_stat, p_value = stats.f_oneway(' + groupVars.join(', ') + ')');
        lines.push('');
        lines.push('print(f"F-statistic: {f_stat:.4f}")');
        lines.push('print(f"P-value: {p_value:.6f}")');
        lines.push('print(f"Alpha: ' + r.alpha + '")');
        lines.push('print(f"Significant: {p_value < ' + r.alpha + '}")');
        lines.push('');
        lines.push('# Eta-squared (effect size)');
        lines.push('all_data = np.concatenate([' + groupVars.join(', ') + '])');
        lines.push('grand_mean = np.mean(all_data)');
        lines.push('ss_between = sum(len(g) * (np.mean(g) - grand_mean)**2 for g in [' + groupVars.join(', ') + '])');
        lines.push('ss_total = np.sum((all_data - grand_mean)**2)');
        lines.push('eta_sq = ss_between / ss_total');
        lines.push('print(f"\\nEta-squared: {eta_sq:.4f}")');
        lines.push('');
        lines.push('# Group statistics');
        for (var g = 0; g < r.k; g++) {
            lines.push('print(f"Group ' + (g + 1) + ': n={len(group' + (g + 1) + ')}, mean={np.mean(group' + (g + 1) + '):.4f}, std={np.std(group' + (g + 1) + ', ddof=1):.4f}")');
        }

        return lines.join('\n');
    }

    /* ===== Quick Examples ===== */
    var EXAMPLES = {
        'teaching-methods': {
            groups: [
                [85, 90, 78, 92, 88],
                [75, 80, 72, 78, 76],
                [90, 95, 88, 92, 94]
            ],
            alpha: 0.05,
            desc: 'Teaching Methods'
        },
        'fertilizers': {
            groups: [
                [20.1, 21.5, 22.3, 19.8, 20.9],
                [25.3, 24.8, 26.1, 25.5, 24.2],
                [22.5, 23.1, 21.8, 22.9, 23.5],
                [28.1, 27.5, 29.2, 28.8, 27.9]
            ],
            alpha: 0.05,
            desc: 'Fertilizers (4 groups)'
        },
        'medications': {
            groups: [
                [4.5, 5.2, 4.8, 5.1, 4.7],
                [6.1, 5.8, 6.3, 5.9, 6.2],
                [5.0, 5.3, 4.9, 5.2, 5.1]
            ],
            alpha: 0.01,
            desc: 'Medications (\u03B1=0.01)'
        },
        'no-difference': {
            groups: [
                [10, 12, 11, 13, 10],
                [11, 10, 12, 11, 13],
                [12, 11, 10, 13, 11]
            ],
            alpha: 0.05,
            desc: 'No Difference'
        }
    };

    function applyExample(key) {
        var ex = EXAMPLES[key];
        if (!ex) return;

        // Set group count to match example
        state.groupCount = ex.groups.length;

        var values = [];
        for (var i = 0; i < ex.groups.length; i++) {
            values.push(ex.groups[i].join(', '));
        }
        renderGroupInputs(values);

        var alphaEl = document.getElementById(PREFIX + 'alpha');
        if (alphaEl) alphaEl.value = String(ex.alpha);

        calculate();
    }

    /* ===== FAQ Toggle ===== */
    function initFAQ() {
        var faqItems = document.querySelectorAll('.stat-faq-item');
        for (var i = 0; i < faqItems.length; i++) {
            var question = faqItems[i].querySelector('.stat-faq-question');
            if (question) {
                question.addEventListener('click', function() {
                    var item = this.parentElement;
                    var isOpen = item.classList.contains('open');
                    // Close all
                    document.querySelectorAll('.stat-faq-item').forEach(function(fi) { fi.classList.remove('open'); });
                    if (!isOpen) item.classList.add('open');
                });
            }
        }
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83D\uDCCA', 'No Result Yet', 'Enter data and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        document.getElementById(PREFIX + 'graph-container').innerHTML = '';
        state.results = null;
        state.groups = [];

        // Reset to 3 empty groups
        state.groupCount = 3;
        renderGroupInputs(['', '', '']);
    }

    /* ===== Restore from shared URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.groups || !shared.groups.length) return false;

        var groupCount = shared.groups.length;
        if (groupCount < 2) return false;

        state.groupCount = groupCount;
        var values = [];
        for (var i = 0; i < groupCount; i++) {
            values.push(shared.groups[i].replace(/,/g, ', '));
        }
        renderGroupInputs(values);

        if (shared.alpha != null) {
            var alphaEl = document.getElementById(PREFIX + 'alpha');
            if (alphaEl) alphaEl.value = shared.alpha;
        }

        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initFAQ();

        // Wire add group button
        if (els.addGroupBtn) {
            els.addGroupBtn.addEventListener('click', addGroup);
        }

        // Wire calculate & clear
        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        // Example chips
        var exContainer = document.getElementById(PREFIX + 'examples');
        if (exContainer) {
            exContainer.querySelectorAll('[data-example]').forEach(function(el) {
                el.addEventListener('click', function() {
                    applyExample(this.getAttribute('data-example'));
                });
            });
        }

        // Scroll animations
        C.initScrollReveal();

        // Build initial 3 groups
        renderGroupInputs(['', '', '']);

        // Restore from shared URL or auto-calculate default example
        G.loadJStat(function() {
            var restored = restoreFromUrl();
            if (restored) {
                calculate();
            } else {
                applyExample('teaching-methods');
            }
        });
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
