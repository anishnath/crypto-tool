/**
 * StatsGraph — Plotly-based graphing for statistics tools
 * Exposed as window.StatsGraph
 * Plotly and jStat are lazy-loaded on demand.
 */
(function() {
    'use strict';

    var plotlyLoaded = false;
    var plotlyLoading = false;
    var plotlyCallbacks = [];

    var jstatLoaded = false;
    var jstatLoading = false;
    var jstatCallbacks = [];

    /* ===== Lazy Loaders ===== */

    function loadPlotly(cb) {
        if (plotlyLoaded && window.Plotly) { cb(); return; }
        plotlyCallbacks.push(cb);
        if (plotlyLoading) return;
        plotlyLoading = true;
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() {
            plotlyLoaded = true;
            plotlyLoading = false;
            for (var i = 0; i < plotlyCallbacks.length; i++) plotlyCallbacks[i]();
            plotlyCallbacks = [];
        };
        s.onerror = function() {
            plotlyLoading = false;
            plotlyCallbacks = [];
        };
        document.head.appendChild(s);
    }

    function loadJStat(cb) {
        if (jstatLoaded && window.jStat) { cb(); return; }
        jstatCallbacks.push(cb);
        if (jstatLoading) return;
        jstatLoading = true;
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/jstat@1.9.6/dist/jstat.min.js';
        s.onload = function() {
            jstatLoaded = true;
            jstatLoading = false;
            for (var i = 0; i < jstatCallbacks.length; i++) jstatCallbacks[i]();
            jstatCallbacks = [];
        };
        s.onerror = function() {
            jstatLoading = false;
            jstatCallbacks = [];
        };
        document.head.appendChild(s);
    }

    /* ===== Theme Helpers ===== */

    function isDarkMode() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    function getPlotColors() {
        var dark = isDarkMode();
        return {
            bg: dark ? '#1e293b' : '#ffffff',
            paper: dark ? '#1e293b' : '#ffffff',
            grid: dark ? '#334155' : '#e2e8f0',
            text: dark ? '#f1f5f9' : '#0f172a',
            muted: dark ? '#94a3b8' : '#64748b',
            primary: '#e11d48',
            primaryLight: 'rgba(225, 29, 72, 0.6)',
            primaryFill: 'rgba(225, 29, 72, 0.3)',
            secondary: '#f43f5e',
            accent: '#3b82f6'
        };
    }

    function baseLayout(title, colors) {
        return {
            title: { text: title, font: { size: 14, color: colors.text } },
            paper_bgcolor: colors.paper,
            plot_bgcolor: colors.bg,
            font: { family: 'Inter, -apple-system, sans-serif', color: colors.text, size: 12 },
            margin: { t: 40, r: 20, b: 50, l: 50 },
            xaxis: {
                gridcolor: colors.grid,
                zerolinecolor: colors.grid,
                tickfont: { size: 10, color: colors.muted }
            },
            yaxis: {
                gridcolor: colors.grid,
                zerolinecolor: colors.grid,
                tickfont: { size: 10, color: colors.muted }
            }
        };
    }

    var plotConfig = { responsive: true, displayModeBar: false };

    /* ===== Renderers ===== */

    function renderHistogram(containerId, freqDist, options) {
        loadPlotly(function() {
            var el = document.getElementById(containerId);
            if (!el) return;
            el.innerHTML = '';
            var c = getPlotColors();
            var opts = options || {};

            var labels = freqDist.map(function(b) { return StatsCommon.fmt(b.lower, 1) + '–' + StatsCommon.fmt(b.upper, 1); });
            var freqs = freqDist.map(function(b) { return b.frequency; });

            var traces = [{
                x: labels,
                y: freqs,
                type: 'bar',
                marker: {
                    color: c.primaryLight,
                    line: { color: c.primary, width: 1.5 }
                },
                name: 'Frequency'
            }];

            // Optional normal overlay
            if (opts.normalOverlay && opts.mean != null && opts.sd && opts.sd > 0 && opts.n) {
                var midpoints = freqDist.map(function(b) { return b.midpoint; });
                var binWidth = freqDist.length > 1 ? freqDist[1].lower - freqDist[0].lower : 1;
                var xNorm = [], yNorm = [];
                var lo = freqDist[0].lower;
                var hi = freqDist[freqDist.length - 1].upper;
                var step = (hi - lo) / 100;
                for (var x = lo; x <= hi; x += step) {
                    xNorm.push(x);
                    var z = (x - opts.mean) / opts.sd;
                    var pdf = Math.exp(-0.5 * z * z) / (opts.sd * Math.sqrt(2 * Math.PI));
                    yNorm.push(pdf * opts.n * binWidth);
                }
                traces.push({
                    x: xNorm,
                    y: yNorm,
                    type: 'scatter',
                    mode: 'lines',
                    line: { color: c.accent, width: 2, dash: 'dot' },
                    name: 'Normal Curve',
                    xaxis: 'x2'
                });
            }

            var layout = baseLayout(opts.title || 'Frequency Histogram', c);
            layout.xaxis.title = { text: 'Class Interval', font: { size: 11, color: c.muted } };
            layout.yaxis.title = { text: 'Frequency', font: { size: 11, color: c.muted } };
            layout.bargap = 0.05;
            if (opts.normalOverlay) {
                layout.xaxis2 = { overlaying: 'x', side: 'top', showticklabels: false, showgrid: false };
            }

            Plotly.newPlot(el, traces, layout, plotConfig);
        });
    }

    function renderBoxPlot(containerId, data, options) {
        loadPlotly(function() {
            var el = document.getElementById(containerId);
            if (!el) return;
            el.innerHTML = '';
            var c = getPlotColors();
            var opts = options || {};

            var trace = {
                y: data,
                type: 'box',
                name: opts.name || 'Data',
                marker: { color: c.primary, size: 4 },
                line: { color: c.primary },
                fillcolor: c.primaryFill,
                boxpoints: 'outliers',
                jitter: 0.3,
                pointpos: -1.5
            };

            var layout = baseLayout(opts.title || 'Box Plot', c);
            layout.yaxis.title = { text: opts.yLabel || 'Value', font: { size: 11, color: c.muted } };
            layout.showlegend = false;

            Plotly.newPlot(el, [trace], layout, plotConfig);
        });
    }

    function renderNormalCurve(containerId, mean, sd, options) {
        loadPlotly(function() {
            var el = document.getElementById(containerId);
            if (!el) return;
            el.innerHTML = '';
            var c = getPlotColors();
            var opts = options || {};

            var lo = mean - 4 * sd;
            var hi = mean + 4 * sd;
            var step = (hi - lo) / 200;
            var xVals = [], yVals = [];
            for (var x = lo; x <= hi; x += step) {
                xVals.push(x);
                var z = (x - mean) / sd;
                yVals.push(Math.exp(-0.5 * z * z) / (sd * Math.sqrt(2 * Math.PI)));
            }

            var traces = [{
                x: xVals,
                y: yVals,
                type: 'scatter',
                mode: 'lines',
                fill: 'tozeroy',
                fillcolor: c.primaryFill,
                line: { color: c.primary, width: 2 },
                name: 'Normal PDF'
            }];

            // Sigma markers
            var sigmaColors = ['#10b981', '#f59e0b', '#ef4444'];
            var sigmaLabels = ['\u00b11\u03c3 (68.3%)', '\u00b12\u03c3 (95.4%)', '\u00b13\u03c3 (99.7%)'];
            for (var s = 1; s <= 3; s++) {
                traces.push({
                    x: [mean - s * sd, mean - s * sd],
                    y: [0, Math.exp(-0.5 * s * s) / (sd * Math.sqrt(2 * Math.PI))],
                    type: 'scatter',
                    mode: 'lines',
                    line: { color: sigmaColors[s - 1], width: 1, dash: 'dash' },
                    name: sigmaLabels[s - 1],
                    showlegend: s === 1
                });
                traces.push({
                    x: [mean + s * sd, mean + s * sd],
                    y: [0, Math.exp(-0.5 * s * s) / (sd * Math.sqrt(2 * Math.PI))],
                    type: 'scatter',
                    mode: 'lines',
                    line: { color: sigmaColors[s - 1], width: 1, dash: 'dash' },
                    showlegend: false
                });
            }

            var layout = baseLayout(opts.title || 'Normal Distribution', c);
            layout.xaxis.title = { text: 'Value', font: { size: 11, color: c.muted } };
            layout.yaxis.title = { text: 'Density', font: { size: 11, color: c.muted } };
            layout.showlegend = true;
            layout.legend = { font: { size: 10 }, x: 1, xanchor: 'right', y: 1 };

            Plotly.newPlot(el, traces, layout, plotConfig);
        });
    }

    function renderScatterPlot(containerId, xData, yData, options) {
        loadPlotly(function() {
            var el = document.getElementById(containerId);
            if (!el) return;
            el.innerHTML = '';
            var c = getPlotColors();
            var opts = options || {};

            var traces = [{
                x: xData,
                y: yData,
                type: 'scatter',
                mode: 'markers',
                marker: { color: c.primary, size: 6 },
                name: 'Data'
            }];

            // Add regression line if requested
            if (opts.regressionLine && xData.length > 1) {
                var n = xData.length;
                var sx = 0, sy = 0, sxy = 0, sxx = 0;
                for (var i = 0; i < n; i++) {
                    sx += xData[i]; sy += yData[i];
                    sxy += xData[i] * yData[i];
                    sxx += xData[i] * xData[i];
                }
                var slope = (n * sxy - sx * sy) / (n * sxx - sx * sx);
                var intercept = (sy - slope * sx) / n;
                var xMin = Math.min.apply(null, xData);
                var xMax = Math.max.apply(null, xData);
                traces.push({
                    x: [xMin, xMax],
                    y: [slope * xMin + intercept, slope * xMax + intercept],
                    type: 'scatter',
                    mode: 'lines',
                    line: { color: c.accent, width: 2, dash: 'dash' },
                    name: 'Regression'
                });
            }

            var layout = baseLayout(opts.title || 'Scatter Plot', c);
            layout.xaxis.title = { text: opts.xLabel || 'X', font: { size: 11, color: c.muted } };
            layout.yaxis.title = { text: opts.yLabel || 'Y', font: { size: 11, color: c.muted } };

            Plotly.newPlot(el, traces, layout, plotConfig);
        });
    }

    /* ===== Public API ===== */

    window.StatsGraph = {
        loadPlotly: loadPlotly,
        loadJStat: loadJStat,
        isDarkMode: isDarkMode,
        getPlotColors: getPlotColors,
        renderHistogram: renderHistogram,
        renderBoxPlot: renderBoxPlot,
        renderNormalCurve: renderNormalCurve,
        renderScatterPlot: renderScatterPlot
    };
})();
