/**
 * Outlier Detection Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Supports IQR, Z-Score, Modified Z-Score (MAD), and Compare All methods.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;
    var PREFIX = 'od-';

    /* ===== State ===== */
    var state = {
        mode: 'iqr',
        data: [],
        sorted: [],
        results: null
    };

    /* ===== Examples ===== */
    var EXAMPLES = {
        'test-scores': { data: '10, 12, 15, 18, 20, 22, 25, 28, 30, 95', desc: 'Test Scores (1 outlier)' },
        'temperatures': { data: '20.1, 21.3, 19.8, 20.5, 21.0, 20.7, 45.2, 20.9, 21.1, 19.5, 20.3, 20.8', desc: 'Temperatures (sensor error)' },
        'salaries': { data: '45000, 48000, 52000, 55000, 58000, 62000, 65000, 250000, 51000, 49000', desc: 'Salaries (CEO outlier)' },
        'clean-data': { data: '10, 11, 12, 10.5, 11.5, 12.5, 11, 10, 12, 11.5', desc: 'Clean Data (no outliers)' }
    };

    /* ===== Helper: Percentile ===== */

    function percentile(sorted, p) {
        var n = sorted.length;
        if (n === 0) return null;
        if (n === 1) return sorted[0];

        var pos = (n + 1) * p / 100;
        if (pos <= 1) return sorted[0];
        if (pos >= n) return sorted[n - 1];

        var lower = Math.floor(pos) - 1;
        var upper = Math.ceil(pos) - 1;
        var frac = pos - Math.floor(pos);
        return sorted[lower] + frac * (sorted[upper] - sorted[lower]);
    }

    /* ===== Core Computation: IQR ===== */

    function computeIQR(data, sorted, k) {
        var q1 = percentile(sorted, 25);
        var q3 = percentile(sorted, 75);
        var iqr = q3 - q1;
        var lowerFence = q1 - k * iqr;
        var upperFence = q3 + k * iqr;

        var outliers = data.filter(function(x) { return x < lowerFence || x > upperFence; });
        var lowerOutliers = data.filter(function(x) { return x < lowerFence; }).sort(function(a, b) { return a - b; });
        var upperOutliers = data.filter(function(x) { return x > upperFence; }).sort(function(a, b) { return a - b; });

        return {
            method: 'IQR',
            q1: q1,
            q3: q3,
            iqr: iqr,
            k: k,
            lowerFence: lowerFence,
            upperFence: upperFence,
            outliers: outliers,
            lowerOutliers: lowerOutliers,
            upperOutliers: upperOutliers,
            n: data.length
        };
    }

    /* ===== Core Computation: Z-Score ===== */

    function computeZScore(data, sorted, threshold) {
        var n = data.length;
        var sum = 0;
        var i;
        for (i = 0; i < n; i++) sum += data[i];
        var mean = sum / n;

        var ssq = 0;
        for (i = 0; i < n; i++) ssq += (data[i] - mean) * (data[i] - mean);
        var variance = ssq / (n - 1);
        var sd = Math.sqrt(variance);

        var zScores = data.map(function(x) { return sd > 0 ? (x - mean) / sd : 0; });
        var outliers = data.filter(function(x, i) { return Math.abs(zScores[i]) > threshold; });
        var lowerOutliers = data.filter(function(x, i) { return zScores[i] < -threshold; }).sort(function(a, b) { return a - b; });
        var upperOutliers = data.filter(function(x, i) { return zScores[i] > threshold; }).sort(function(a, b) { return a - b; });

        return {
            method: 'Z-Score',
            mean: mean,
            sd: sd,
            threshold: threshold,
            zScores: zScores,
            outliers: outliers,
            lowerOutliers: lowerOutliers,
            upperOutliers: upperOutliers,
            n: n
        };
    }

    /* ===== Core Computation: Modified Z-Score (MAD) ===== */

    function computeModifiedZ(data, sorted, threshold) {
        var median = percentile(sorted, 50);
        var absDeviations = data.map(function(x) { return Math.abs(x - median); });
        var sortedDeviations = absDeviations.slice().sort(function(a, b) { return a - b; });
        var mad = percentile(sortedDeviations, 50);

        var modifiedZ = data.map(function(x) { return 0.6745 * (x - median) / (mad || 1); });
        var outliers = data.filter(function(x, i) { return Math.abs(modifiedZ[i]) > threshold; });
        var lowerOutliers = data.filter(function(x, i) { return modifiedZ[i] < -threshold; }).sort(function(a, b) { return a - b; });
        var upperOutliers = data.filter(function(x, i) { return modifiedZ[i] > threshold; }).sort(function(a, b) { return a - b; });

        return {
            method: 'Modified Z',
            median: median,
            mad: mad,
            threshold: threshold,
            modifiedZ: modifiedZ,
            outliers: outliers,
            lowerOutliers: lowerOutliers,
            upperOutliers: upperOutliers,
            n: data.length
        };
    }

    /* ===== Core Computation: Compare All ===== */

    function computeAll(data, sorted) {
        var iqrResult = computeIQR(data, sorted, 1.5);
        var zResult = computeZScore(data, sorted, 3.0);
        var modResult = computeModifiedZ(data, sorted, 3.5);

        var allSet = {};
        var i;
        for (i = 0; i < iqrResult.outliers.length; i++) allSet[iqrResult.outliers[i]] = true;
        for (i = 0; i < zResult.outliers.length; i++) allSet[zResult.outliers[i]] = true;
        for (i = 0; i < modResult.outliers.length; i++) allSet[modResult.outliers[i]] = true;

        var consensusOutliers = data.filter(function(x) {
            var flaggedByIQR = x < iqrResult.lowerFence || x > iqrResult.upperFence;
            var flaggedByZ = false;
            var flaggedByMod = false;
            for (var j = 0; j < data.length; j++) {
                if (data[j] === x) {
                    if (Math.abs(zResult.zScores[j]) > zResult.threshold) flaggedByZ = true;
                    if (Math.abs(modResult.modifiedZ[j]) > modResult.threshold) flaggedByMod = true;
                    break;
                }
            }
            return flaggedByIQR && flaggedByZ && flaggedByMod;
        });

        // Deduplicate consensus
        var seen = {};
        consensusOutliers = consensusOutliers.filter(function(x) {
            if (seen[x]) return false;
            seen[x] = true;
            return true;
        });

        return {
            iqr: iqrResult,
            zscore: zResult,
            modified: modResult,
            allOutliers: allSet,
            consensusOutliers: consensusOutliers
        };
    }

    /* ===== Count methods flagging a value ===== */

    function countMethodsFlagging(val, allResult) {
        var count = 0;
        if (allResult.iqr.outliers.indexOf(val) !== -1) count++;
        if (allResult.zscore.outliers.indexOf(val) !== -1) count++;
        if (allResult.modified.outliers.indexOf(val) !== -1) count++;
        return count;
    }

    /* ===== Calculate (main entry) ===== */

    function calculate() {
        var container = document.getElementById('od-result-content');
        var textVal = document.getElementById('od-data-input').value;
        var data = C.parseNumbers(textVal);

        if (data.length < 3) {
            C.showError(container, 'Please enter at least 3 numeric data points.');
            return;
        }

        var sorted = data.slice().sort(function(a, b) { return a - b; });
        state.data = data;
        state.sorted = sorted;

        var mode = state.mode;
        var results;

        if (mode === 'iqr') {
            var k = parseFloat(document.getElementById('od-iqr-k').value) || 1.5;
            results = computeIQR(data, sorted, k);
        } else if (mode === 'zscore') {
            var zThresh = parseFloat(document.getElementById('od-z-threshold').value) || 3.0;
            results = computeZScore(data, sorted, zThresh);
        } else if (mode === 'modified') {
            var madThresh = parseFloat(document.getElementById('od-mad-threshold').value) || 3.5;
            results = computeModifiedZ(data, sorted, madThresh);
        } else {
            results = computeAll(data, sorted);
        }

        state.results = results;
        renderResults();

        // Queue graph render
        var graphTab = document.querySelector('[data-tab="od-graph-panel"]');
        if (graphTab && graphTab.classList.contains('active')) {
            renderGraph();
        }

        // Reset compiler if not active
        var compilerTab = document.querySelector('[data-tab="od-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) {
            preparePython();
        }
    }

    /* ===== Render Results ===== */

    function renderResults() {
        var container = document.getElementById('od-result-content');
        if (!state.results) return;

        container.innerHTML = '';

        if (state.mode === 'all') {
            renderAllResults(container);
        } else {
            renderSingleResult(container);
        }

        E.renderActionButtons(els.resultActions, {
            toolName: 'Outlier Detection',
            getLatex: function() {
                var r = state.results;
                if (!r) return '';
                var d = state.data;
                var s = state.sorted;
                var lines = [];
                lines.push('\\textbf{Outlier Detection}\\\\[4pt]');
                lines.push('\\text{Data: } ' + d.join(',\\; ') + '\\\\');
                lines.push('n = ' + d.length + '\\\\[4pt]');
                if (state.mode === 'iqr') {
                    lines.push('\\textbf{IQR Method}\\\\');
                    lines.push('Q_1 = ' + C.fmt(r.q1, 4) + ',\\quad Q_3 = ' + C.fmt(r.q3, 4) + '\\\\');
                    lines.push('\\text{IQR} = Q_3 - Q_1 = ' + C.fmt(r.iqr, 4) + '\\\\');
                    lines.push('\\text{Lower Fence} = Q_1 - ' + C.fmt(r.k, 2) + ' \\times \\text{IQR} = ' + C.fmt(r.lowerFence, 4) + '\\\\');
                    lines.push('\\text{Upper Fence} = Q_3 + ' + C.fmt(r.k, 2) + ' \\times \\text{IQR} = ' + C.fmt(r.upperFence, 4) + '\\\\');
                    lines.push('\\text{Outliers: } ' + (r.outliers.length > 0 ? r.outliers.map(function(v) { return C.fmt(v, 4); }).join(',\\; ') : '\\text{None}'));
                } else if (state.mode === 'zscore') {
                    lines.push('\\textbf{Z-Score Method}\\\\');
                    lines.push('\\bar{x} = ' + C.fmt(r.mean, 4) + ',\\quad s = ' + C.fmt(r.sd, 4) + '\\\\');
                    lines.push('\\text{Threshold} = ' + C.fmt(r.threshold, 2) + '\\\\');
                    lines.push('Z_i = \\frac{x_i - \\bar{x}}{s}\\\\');
                    lines.push('\\text{Outliers } (|Z| > ' + C.fmt(r.threshold, 2) + '): ' + (r.outliers.length > 0 ? r.outliers.map(function(v) { return C.fmt(v, 4); }).join(',\\; ') : '\\text{None}'));
                } else if (state.mode === 'modified') {
                    lines.push('\\textbf{Modified Z-Score (MAD) Method}\\\\');
                    lines.push('\\tilde{x} = ' + C.fmt(r.median, 4) + ',\\quad \\text{MAD} = ' + C.fmt(r.mad, 4) + '\\\\');
                    lines.push('\\text{Threshold} = ' + C.fmt(r.threshold, 2) + '\\\\');
                    lines.push('M_i = \\frac{0.6745 \\cdot (x_i - \\tilde{x})}{\\text{MAD}}\\\\');
                    lines.push('\\text{Outliers } (|M| > ' + C.fmt(r.threshold, 2) + '): ' + (r.outliers.length > 0 ? r.outliers.map(function(v) { return C.fmt(v, 4); }).join(',\\; ') : '\\text{None}'));
                } else {
                    lines.push('\\textbf{Compare All Methods}\\\\');
                    lines.push('\\text{IQR outliers: } ' + r.iqr.outliers.length + '\\\\');
                    lines.push('\\text{Z-Score outliers: } ' + r.zscore.outliers.length + '\\\\');
                    lines.push('\\text{Modified Z outliers: } ' + r.modified.outliers.length + '\\\\');
                    lines.push('\\text{Consensus outliers: } ' + (r.consensusOutliers.length > 0 ? r.consensusOutliers.map(function(v) { return C.fmt(v, 4); }).join(',\\; ') : '\\text{None}'));
                }
                return lines.join('\n');
            },
            getShareState: function() {
                if (!state.results) return null;
                var shared = { mode: state.mode, data: state.data.join(',') };
                if (state.mode === 'iqr') {
                    shared.k = state.results.k;
                } else if (state.mode === 'zscore') {
                    shared.threshold = state.results.threshold;
                } else if (state.mode === 'modified') {
                    shared.threshold = state.results.threshold;
                }
                return shared;
            },
            resultEl: '#od-result-content'
        });
    }

    function renderSingleResult(container) {
        var r = state.results;
        var data = state.data;
        var sorted = state.sorted;
        var h = '';

        // Hero badge
        var outlierCount = r.outliers.length;
        var heroClass = outlierCount > 0 ? 'stat-hero-value' : 'stat-hero-value';
        h += '<div class="stat-hero">';
        h += '<span class="stat-hero-value">' + r.method + ' Method</span>';
        h += '<span class="stat-hero-label">' + outlierCount + ' outlier' + (outlierCount !== 1 ? 's' : '') + ' detected</span>';
        h += '</div>';

        // Method Details section
        var detailRows = [];
        if (r.method === 'IQR') {
            detailRows.push(['Q1 (25th percentile)', C.fmt(r.q1, 4)]);
            detailRows.push(['Q3 (75th percentile)', C.fmt(r.q3, 4)]);
            detailRows.push(['IQR (Q3 - Q1)', C.fmt(r.iqr, 4)]);
            detailRows.push(['Multiplier (k)', C.fmt(r.k, 2)]);
            detailRows.push(['Lower Fence', C.fmt(r.lowerFence, 4)]);
            detailRows.push(['Upper Fence', C.fmt(r.upperFence, 4)]);
        } else if (r.method === 'Z-Score') {
            detailRows.push(['Mean', C.fmt(r.mean, 4)]);
            detailRows.push(['Standard Deviation', C.fmt(r.sd, 4)]);
            detailRows.push(['Threshold', C.fmt(r.threshold, 2)]);
        } else {
            detailRows.push(['Median', C.fmt(r.median, 4)]);
            detailRows.push(['MAD (Median Absolute Deviation)', C.fmt(r.mad, 4)]);
            detailRows.push(['Threshold', C.fmt(r.threshold, 2)]);
        }

        h += '<div class="stat-section"><div class="stat-section-title">Method Details</div>';
        for (var i = 0; i < detailRows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + detailRows[i][0] + '</span><span class="stat-value">' + detailRows[i][1] + '</span></div>';
        }
        h += '</div>';

        // Detected Outliers section
        h += '<div class="stat-section"><div class="stat-section-title">Detected Outliers</div>';
        if (outlierCount > 0) {
            if (r.lowerOutliers.length > 0) {
                h += '<div style="margin-bottom:0.5rem;"><strong style="color:#ef4444;">Lower Outliers (' + r.lowerOutliers.length + '):</strong> ';
                h += '<span style="color:#ef4444;">' + r.lowerOutliers.map(function(v) { return C.fmt(v, 4); }).join(', ') + '</span></div>';
            }
            if (r.upperOutliers.length > 0) {
                h += '<div style="margin-bottom:0.5rem;"><strong style="color:#ef4444;">Upper Outliers (' + r.upperOutliers.length + '):</strong> ';
                h += '<span style="color:#ef4444;">' + r.upperOutliers.map(function(v) { return C.fmt(v, 4); }).join(', ') + '</span></div>';
            }
        } else {
            h += '<div class="stat-interpretation stat-interpretation-normal" style="color:#10b981;"><strong>No Outliers Detected</strong> — All data points fall within the expected range.</div>';
        }
        h += '</div>';

        // Data Summary section
        var sum = 0;
        for (var s = 0; s < data.length; s++) sum += data[s];
        var mean = sum / data.length;
        var median = percentile(sorted, 50);

        h += '<div class="stat-section"><div class="stat-section-title">Data Summary</div>';
        h += '<div class="stat-row"><span class="stat-label">Sample Size (n)</span><span class="stat-value">' + data.length + '</span></div>';
        h += '<div class="stat-row"><span class="stat-label">Minimum</span><span class="stat-value">' + C.fmt(sorted[0], 4) + '</span></div>';
        h += '<div class="stat-row"><span class="stat-label">Maximum</span><span class="stat-value">' + C.fmt(sorted[sorted.length - 1], 4) + '</span></div>';
        h += '<div class="stat-row"><span class="stat-label">Mean</span><span class="stat-value">' + C.fmt(mean, 4) + '</span></div>';
        h += '<div class="stat-row"><span class="stat-label">Median</span><span class="stat-value">' + C.fmt(median, 4) + '</span></div>';
        h += '</div>';

        // Interpretation section
        h += '<div class="stat-interpretation ' + (outlierCount > 0 ? 'stat-interpretation-warning' : 'stat-interpretation-normal') + '">';
        h += '<strong>Interpretation:</strong> ';
        if (r.method === 'IQR') {
            if (outlierCount > 0) {
                h += 'Using Tukey\'s Fences with k=' + C.fmt(r.k, 2) + ', ' + outlierCount + ' data point' + (outlierCount !== 1 ? 's fall' : ' falls') + ' outside the range [' + C.fmt(r.lowerFence, 2) + ', ' + C.fmt(r.upperFence, 2) + ']. ';
                h += 'These values are more than ' + C.fmt(r.k, 1) + ' times the IQR away from the quartiles and may represent unusual observations.';
            } else {
                h += 'No data points fall outside Tukey\'s Fences [' + C.fmt(r.lowerFence, 2) + ', ' + C.fmt(r.upperFence, 2) + ']. The dataset appears to have no extreme values using the IQR method with k=' + C.fmt(r.k, 2) + '.';
            }
        } else if (r.method === 'Z-Score') {
            if (outlierCount > 0) {
                h += outlierCount + ' data point' + (outlierCount !== 1 ? 's have' : ' has') + ' a Z-score with absolute value greater than ' + C.fmt(r.threshold, 2) + '. ';
                h += 'These values are more than ' + C.fmt(r.threshold, 1) + ' standard deviations from the mean and may be considered outliers.';
            } else {
                h += 'All data points have Z-scores within the range [-' + C.fmt(r.threshold, 2) + ', ' + C.fmt(r.threshold, 2) + ']. No extreme values detected using the Z-Score method.';
            }
        } else {
            if (outlierCount > 0) {
                h += outlierCount + ' data point' + (outlierCount !== 1 ? 's have' : ' has') + ' a modified Z-score with absolute value greater than ' + C.fmt(r.threshold, 2) + '. ';
                h += 'The Modified Z-Score method uses the median and MAD, making it more robust against the influence of outliers themselves.';
            } else {
                h += 'All data points have modified Z-scores within the threshold of ' + C.fmt(r.threshold, 2) + '. The dataset appears clean using the Modified Z-Score (MAD) method.';
            }
        }
        h += '</div>';

        container.innerHTML = h;
    }

    function renderAllResults(container) {
        var r = state.results;
        var data = state.data;
        var sorted = state.sorted;
        var h = '';

        // Hero
        var totalUnique = Object.keys(r.allOutliers).length;
        var consensusCount = r.consensusOutliers.length;
        h += '<div class="stat-hero">';
        h += '<span class="stat-hero-value">Compare All Methods</span>';
        h += '<span class="stat-hero-label">' + totalUnique + ' unique outlier' + (totalUnique !== 1 ? 's' : '') + ' found across all methods</span>';
        h += '</div>';

        // Summary comparison table
        h += '<div class="stat-section"><div class="stat-section-title">Method Comparison</div>';
        h += '<table style="width:100%;border-collapse:collapse;margin-top:0.5rem;">';
        h += '<thead><tr style="border-bottom:2px solid var(--border-color,#e2e8f0);">';
        h += '<th style="text-align:left;padding:0.5rem;">Method</th>';
        h += '<th style="text-align:center;padding:0.5rem;">Outliers Found</th>';
        h += '<th style="text-align:left;padding:0.5rem;">Values</th>';
        h += '</tr></thead><tbody>';

        var methods = [
            { name: 'IQR (k=1.5)', result: r.iqr },
            { name: 'Z-Score (threshold=3.0)', result: r.zscore },
            { name: 'Modified Z (threshold=3.5)', result: r.modified }
        ];

        for (var m = 0; m < methods.length; m++) {
            var mr = methods[m].result;
            h += '<tr style="border-bottom:1px solid var(--border-color,#e2e8f0);">';
            h += '<td style="padding:0.5rem;font-weight:500;">' + methods[m].name + '</td>';
            h += '<td style="text-align:center;padding:0.5rem;font-weight:700;color:' + (mr.outliers.length > 0 ? '#ef4444' : '#10b981') + ';">' + mr.outliers.length + '</td>';
            h += '<td style="padding:0.5rem;">';
            if (mr.outliers.length > 0) {
                h += mr.outliers.map(function(v) { return C.fmt(v, 2); }).join(', ');
            } else {
                h += '<span style="color:#10b981;">None</span>';
            }
            h += '</td></tr>';
        }
        h += '</tbody></table></div>';

        // Consensus outliers
        h += '<div class="stat-section"><div class="stat-section-title">Consensus Outliers</div>';
        if (consensusCount > 0) {
            h += '<div style="margin-bottom:0.5rem;color:#ef4444;"><strong>Flagged by ALL 3 methods (' + consensusCount + '):</strong> ';
            h += r.consensusOutliers.map(function(v) { return C.fmt(v, 4); }).join(', ');
            h += '</div>';
        } else {
            h += '<div style="color:#64748b;">No data points were flagged by all three methods simultaneously.</div>';
        }
        h += '</div>';

        // Per-method outlier lists
        h += '<div class="stat-section"><div class="stat-section-title">Per-Method Details</div>';
        for (var p = 0; p < methods.length; p++) {
            var pm = methods[p].result;
            h += '<div style="margin-bottom:0.75rem;"><strong>' + methods[p].name + ':</strong> ';
            if (pm.lowerOutliers.length > 0) {
                h += '<span style="color:#ef4444;">Lower: ' + pm.lowerOutliers.map(function(v) { return C.fmt(v, 2); }).join(', ') + '</span>';
                if (pm.upperOutliers.length > 0) h += ' | ';
            }
            if (pm.upperOutliers.length > 0) {
                h += '<span style="color:#ef4444;">Upper: ' + pm.upperOutliers.map(function(v) { return C.fmt(v, 2); }).join(', ') + '</span>';
            }
            if (pm.outliers.length === 0) {
                h += '<span style="color:#10b981;">No outliers</span>';
            }
            h += '</div>';
        }
        h += '</div>';

        // Recommendation
        h += '<div class="stat-interpretation ' + (consensusCount > 0 ? 'stat-interpretation-warning' : 'stat-interpretation-normal') + '">';
        h += '<strong>Recommendation:</strong> ';
        if (consensusCount > 0) {
            h += 'The value' + (consensusCount !== 1 ? 's ' : ' ') + r.consensusOutliers.map(function(v) { return C.fmt(v, 2); }).join(', ');
            h += (consensusCount !== 1 ? ' are' : ' is') + ' flagged by all three methods and ' + (consensusCount !== 1 ? 'are' : 'is') + ' very likely ' + (consensusCount !== 1 ? 'outliers' : 'an outlier') + '. ';
            h += 'Investigate these data points carefully before deciding whether to remove or adjust them.';
        } else if (totalUnique > 0) {
            h += 'Some methods detected outliers while others did not, suggesting borderline cases. ';
            h += 'Consider the context of your data and use domain knowledge to decide how to handle these observations.';
        } else {
            h += 'No methods detected any outliers. The dataset appears clean and free of extreme values. ';
            h += 'All observations fall within the expected range across IQR, Z-Score, and Modified Z-Score methods.';
        }
        h += '</div>';

        container.innerHTML = h;
    }

    /* ===== Render Graph ===== */

    function renderGraph() {
        if (!state.results || !state.data.length) return;

        G.loadPlotly(function(Plotly) {
            var gc = document.getElementById('od-graph-container');
            if (!gc) return;
            gc.innerHTML = '';

            var data = state.data;
            var results = state.results;
            var colors = G.getPlotColors();
            var mode = state.mode;

            var xVals = [];
            var yVals = [];
            for (var i = 0; i < data.length; i++) {
                xVals.push(i + 1);
                yVals.push(data[i]);
            }

            var traces = [];

            if (mode === 'all') {
                // Color by consensus level
                var allResult = results;
                var markerColors = [];
                var markerSizes = [];
                var hoverTexts = [];

                for (var a = 0; a < data.length; a++) {
                    var methodCount = countMethodsFlagging(data[a], allResult);
                    if (methodCount === 3) {
                        markerColors.push('#ef4444');
                        markerSizes.push(14);
                        hoverTexts.push('Value: ' + C.fmt(data[a], 4) + ' (all 3 methods)');
                    } else if (methodCount === 2) {
                        markerColors.push('#f97316');
                        markerSizes.push(12);
                        hoverTexts.push('Value: ' + C.fmt(data[a], 4) + ' (2 methods)');
                    } else if (methodCount === 1) {
                        markerColors.push('#93c5fd');
                        markerSizes.push(10);
                        hoverTexts.push('Value: ' + C.fmt(data[a], 4) + ' (1 method)');
                    } else {
                        markerColors.push('#3b82f6');
                        markerSizes.push(8);
                        hoverTexts.push('Value: ' + C.fmt(data[a], 4) + ' (normal)');
                    }
                }

                traces.push({
                    x: xVals,
                    y: yVals,
                    type: 'scatter',
                    mode: 'markers',
                    marker: { color: markerColors, size: markerSizes },
                    text: hoverTexts,
                    hoverinfo: 'text',
                    name: 'Data Points'
                });
            } else {
                // Single method: blue = normal, red = outlier
                var outlierSet = {};
                var singleOutliers = results.outliers;
                for (var o = 0; o < singleOutliers.length; o++) {
                    if (!outlierSet[singleOutliers[o]]) outlierSet[singleOutliers[o]] = 0;
                    outlierSet[singleOutliers[o]]++;
                }

                var normalX = [], normalY = [];
                var outlierX = [], outlierY = [];

                for (var d = 0; d < data.length; d++) {
                    var isOutlier = false;
                    if (outlierSet[data[d]] && outlierSet[data[d]] > 0) {
                        isOutlier = true;
                        outlierSet[data[d]]--;
                    }
                    if (isOutlier) {
                        outlierX.push(d + 1);
                        outlierY.push(data[d]);
                    } else {
                        normalX.push(d + 1);
                        normalY.push(data[d]);
                    }
                }

                traces.push({
                    x: normalX,
                    y: normalY,
                    type: 'scatter',
                    mode: 'markers',
                    marker: { color: '#3b82f6', size: 8 },
                    name: 'Normal'
                });

                if (outlierX.length > 0) {
                    traces.push({
                        x: outlierX,
                        y: outlierY,
                        type: 'scatter',
                        mode: 'markers',
                        marker: { color: '#ef4444', size: 12, symbol: 'diamond' },
                        name: 'Outliers'
                    });
                }

                // Add fence/threshold lines
                if (mode === 'iqr') {
                    traces.push({
                        x: [1, data.length],
                        y: [results.lowerFence, results.lowerFence],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: 'Lower Fence (' + C.fmt(results.lowerFence, 2) + ')'
                    });
                    traces.push({
                        x: [1, data.length],
                        y: [results.upperFence, results.upperFence],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: 'Upper Fence (' + C.fmt(results.upperFence, 2) + ')'
                    });
                } else if (mode === 'zscore') {
                    var upperLine = results.mean + results.threshold * results.sd;
                    var lowerLine = results.mean - results.threshold * results.sd;
                    traces.push({
                        x: [1, data.length],
                        y: [results.mean, results.mean],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#10b981', width: 1.5, dash: 'dot' },
                        name: 'Mean (' + C.fmt(results.mean, 2) + ')'
                    });
                    traces.push({
                        x: [1, data.length],
                        y: [lowerLine, lowerLine],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: '-' + C.fmt(results.threshold, 1) + ' SD (' + C.fmt(lowerLine, 2) + ')'
                    });
                    traces.push({
                        x: [1, data.length],
                        y: [upperLine, upperLine],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: '+' + C.fmt(results.threshold, 1) + ' SD (' + C.fmt(upperLine, 2) + ')'
                    });
                } else if (mode === 'modified') {
                    var madUpper = results.median + results.threshold * (results.mad || 1) / 0.6745;
                    var madLower = results.median - results.threshold * (results.mad || 1) / 0.6745;
                    traces.push({
                        x: [1, data.length],
                        y: [results.median, results.median],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#10b981', width: 1.5, dash: 'dot' },
                        name: 'Median (' + C.fmt(results.median, 2) + ')'
                    });
                    traces.push({
                        x: [1, data.length],
                        y: [madLower, madLower],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: 'Lower Threshold (' + C.fmt(madLower, 2) + ')'
                    });
                    traces.push({
                        x: [1, data.length],
                        y: [madUpper, madUpper],
                        type: 'scatter',
                        mode: 'lines',
                        line: { color: '#f59e0b', width: 2, dash: 'dash' },
                        name: 'Upper Threshold (' + C.fmt(madUpper, 2) + ')'
                    });
                }
            }

            var layout = {
                paper_bgcolor: 'rgba(0,0,0,0)',
                plot_bgcolor: 'rgba(0,0,0,0)',
                font: { color: colors.text, family: 'Inter, sans-serif', size: 12 },
                margin: { l: 55, r: 20, t: 30, b: 45 },
                xaxis: {
                    title: 'Data Point Index',
                    gridcolor: colors.grid,
                    zeroline: false
                },
                yaxis: {
                    title: 'Value',
                    gridcolor: colors.grid,
                    zeroline: true,
                    zerolinecolor: colors.grid
                },
                showlegend: true,
                legend: { orientation: 'h', y: -0.25, font: { size: 10 } }
            };

            window.Plotly.newPlot('od-graph-container', traces, layout, { responsive: true, displayModeBar: false });
        });
    }

    /* ===== Prepare Python ===== */

    function preparePython() {
        if (!state.data.length) return;

        var dataStr = state.data.join(', ');
        var lines = [
            'import numpy as np',
            '',
            'data = np.array([' + dataStr + '])',
            'n = len(data)',
            'print(f"Dataset: {data}")',
            'print(f"n = {n}")',
            'print()'
        ];

        // IQR Method
        lines.push('');
        lines.push('# === IQR Method (Tukey\'s Fences) ===');
        lines.push('q1, q3 = np.percentile(data, [25, 75])');
        lines.push('iqr = q3 - q1');
        lines.push('lower, upper = q1 - 1.5*iqr, q3 + 1.5*iqr');
        lines.push('outliers_iqr = data[(data < lower) | (data > upper)]');
        lines.push('print("IQR Method:")');
        lines.push('print(f"  Q1={q1:.4f}, Q3={q3:.4f}, IQR={iqr:.4f}")');
        lines.push('print(f"  Fences: [{lower:.4f}, {upper:.4f}]")');
        lines.push('print(f"  Outliers: {outliers_iqr}")');
        lines.push('print()');

        // Z-Score Method
        lines.push('');
        lines.push('# === Z-Score Method ===');
        lines.push('mean = np.mean(data)');
        lines.push('sd = np.std(data, ddof=1)');
        lines.push('z_scores = (data - mean) / sd');
        lines.push('threshold_z = 3.0');
        lines.push('outliers_z = data[np.abs(z_scores) > threshold_z]');
        lines.push('print("Z-Score Method:")');
        lines.push('print(f"  Mean={mean:.4f}, SD={sd:.4f}")');
        lines.push('print(f"  Z-scores: {np.round(z_scores, 4)}")');
        lines.push('print(f"  Outliers (|z|>{threshold_z}): {outliers_z}")');
        lines.push('print()');

        // Modified Z-Score Method
        lines.push('');
        lines.push('# === Modified Z-Score (MAD) Method ===');
        lines.push('median = np.median(data)');
        lines.push('mad = np.median(np.abs(data - median))');
        lines.push('modified_z = 0.6745 * (data - median) / (mad if mad > 0 else 1)');
        lines.push('threshold_m = 3.5');
        lines.push('outliers_mod = data[np.abs(modified_z) > threshold_m]');
        lines.push('print("Modified Z-Score (MAD) Method:")');
        lines.push('print(f"  Median={median:.4f}, MAD={mad:.4f}")');
        lines.push('print(f"  Modified Z-scores: {np.round(modified_z, 4)}")');
        lines.push('print(f"  Outliers (|mz|>{threshold_m}): {outliers_mod}")');
        lines.push('print()');

        // Consensus
        lines.push('');
        lines.push('# === Consensus ===');
        lines.push('iqr_set = set(outliers_iqr)');
        lines.push('z_set = set(outliers_z)');
        lines.push('mod_set = set(outliers_mod)');
        lines.push('all_outliers = iqr_set | z_set | mod_set');
        lines.push('consensus = iqr_set & z_set & mod_set');
        lines.push('print(f"All unique outliers: {all_outliers}")');
        lines.push('print(f"Consensus (all 3): {consensus}")');

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        var iframe = document.getElementById('od-compiler-iframe');
        if (iframe) {
            iframe.src = E.getCompilerUrl(code, null, cp);
        }
    }

    /* ===== Mode Switching ===== */

    function setMode(m) {
        state.mode = m;

        var btns = document.querySelectorAll('.stat-mode-btn[data-mode]');
        for (var i = 0; i < btns.length; i++) {
            btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === m);
        }

        var iqrOpts = document.getElementById('od-options-iqr');
        var zOpts = document.getElementById('od-options-zscore');
        var modOpts = document.getElementById('od-options-modified');

        if (iqrOpts) iqrOpts.style.display = m === 'iqr' ? '' : 'none';
        if (zOpts) zOpts.style.display = m === 'zscore' ? '' : 'none';
        if (modOpts) modOpts.style.display = m === 'modified' ? '' : 'none';
    }

    /* ===== Tab Switching ===== */

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
                if (target === 'od-graph-panel') {
                    renderGraph();
                }
                if (target === 'od-compiler-panel') {
                    preparePython();
                }
            });
        }
    }

    /* ===== Clear ===== */

    function clearAll() {
        var container = document.getElementById('od-result-content');
        var textarea = document.getElementById('od-data-input');
        if (textarea) textarea.value = '';
        state.data = [];
        state.sorted = [];
        state.results = null;
        C.showEmpty(container, '&#x1F50D;', 'No Results Yet', 'Enter data and select a detection method to find outliers');
        E.hideActionButtons(els.resultActions);

        var gc = document.getElementById('od-graph-container');
        if (gc && typeof Plotly !== 'undefined' && gc.data) window.Plotly.purge(gc);

        var iframe = document.getElementById('od-compiler-iframe');
        if (iframe) iframe.removeAttribute('src');
    }

    /* ===== FAQ Accordion ===== */

    function initFAQ() {
        var questions = document.querySelectorAll('.stat-faq-question');
        for (var i = 0; i < questions.length; i++) {
            questions[i].addEventListener('click', function() {
                var parent = this.parentElement;
                var isOpen = parent.classList.contains('active');
                document.querySelectorAll('.stat-faq-item').forEach(function(item) { item.classList.remove('active'); });
                if (!isOpen) parent.classList.add('active');
            });
        }
    }

    /* ===== Scroll Reveal ===== */

    function initScrollReveal() {
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) {
                    if (e.isIntersecting) {
                        e.target.classList.add('stat-visible');
                        observer.unobserve(e.target);
                    }
                });
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        } else {
            document.querySelectorAll('.stat-anim').forEach(function(el) { el.classList.add('stat-visible'); });
        }
    }

    /* ===== DOM References ===== */

    var els = {};

    function initDOM() {
        els.resultActions = document.getElementById(PREFIX + 'result-actions');
    }

    /* ===== Restore from shared URL ===== */

    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.data) return false;

        var textarea = document.getElementById('od-data-input');
        if (textarea) textarea.value = shared.data;

        if (shared.mode) setMode(shared.mode);

        if (shared.mode === 'iqr' && shared.k != null) {
            var kInput = document.getElementById('od-iqr-k');
            if (kInput) kInput.value = shared.k;
        } else if (shared.mode === 'zscore' && shared.threshold != null) {
            var zInput = document.getElementById('od-z-threshold');
            if (zInput) zInput.value = shared.threshold;
        } else if (shared.mode === 'modified' && shared.threshold != null) {
            var mInput = document.getElementById('od-mad-threshold');
            if (mInput) mInput.value = shared.threshold;
        }

        return true;
    }

    /* ===== Init ===== */

    function init() {
        initDOM();
        // Mode buttons
        var modeBtns = document.querySelectorAll('.stat-mode-btn[data-mode]');
        for (var i = 0; i < modeBtns.length; i++) {
            modeBtns[i].addEventListener('click', function() {
                setMode(this.getAttribute('data-mode'));
            });
        }

        // Tabs
        initTabs();

        // Calculate button
        var calcBtn = document.getElementById('od-calc-btn');
        if (calcBtn) calcBtn.addEventListener('click', calculate);

        // Clear button
        var clearBtn = document.getElementById('od-clear-btn');
        if (clearBtn) clearBtn.addEventListener('click', clearAll);

        // Enter key in textarea
        var textarea = document.getElementById('od-data-input');
        if (textarea) {
            textarea.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) {
                    e.preventDefault();
                    calculate();
                }
            });
        }

        // Example chips
        var exampleChips = document.querySelectorAll('[data-od-example]');
        for (var j = 0; j < exampleChips.length; j++) {
            exampleChips[j].addEventListener('click', function() {
                var key = this.getAttribute('data-od-example');
                var ex = EXAMPLES[key];
                if (ex && textarea) {
                    textarea.value = ex.data;
                    calculate();
                }
            });
        }

        // FAQ
        initFAQ();

        // Scroll reveal
        initScrollReveal();

        // Restore from shared URL or set defaults
        var restored = restoreFromUrl();
        if (!restored) {
            setMode('iqr');
            if (textarea && !textarea.value.trim()) {
                textarea.value = EXAMPLES['test-scores'].data;
            }
        }
        calculate();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
