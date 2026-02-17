/**
 * Series Calculator - Plotly Graph Module
 * Interactive visualization of original function vs series approximation
 */
(function() {
'use strict';

var __plotlyLoaded = false;

function loadPlotly(cb) {
    if (__plotlyLoaded) { if (cb) cb(); return; }
    var s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
    document.head.appendChild(s);
}

function isDarkMode() {
    return document.documentElement.getAttribute('data-theme') === 'dark';
}

function getPlotColors() {
    var dark = isDarkMode();
    return {
        bg: dark ? '#1e293b' : '#ffffff',
        paper: dark ? '#1e293b' : '#ffffff',
        gridColor: dark ? '#334155' : '#e2e8f0',
        textColor: dark ? '#cbd5e1' : '#475569',
        originalColor: '#2563eb',
        approxColor: '#ef4444',
        centerColor: '#f59e0b',
        convergenceColor: dark ? 'rgba(37,99,235,0.15)' : 'rgba(37,99,235,0.08)'
    };
}

function factorial(n) {
    if (n === 0 || n === 1) return 1;
    var r = 1;
    for (var i = 2; i <= n; i++) r *= i;
    return r;
}

function evaluateSeries(x, derivs, center, numTerms) {
    var sum = 0;
    for (var n = 0; n < numTerms && n < derivs.length; n++) {
        sum += (derivs[n] / factorial(n)) * Math.pow(x - center, n);
    }
    return sum;
}

function renderGraph(containerId, compiledFunc, variable, derivs, center, numTerms) {
    if (!window.Plotly) return;
    var container = document.getElementById(containerId);
    if (!container) return;

    var colors = getPlotColors();
    var nPts = 300;
    var xMin = center - 6;
    var xMax = center + 6;
    var step = (xMax - xMin) / nPts;

    // Generate original function points
    var origXs = [], origYs = [];
    for (var i = 0; i <= nPts; i++) {
        var x = xMin + step * i;
        try {
            var scope = {};
            scope[variable] = x;
            var y = compiledFunc.evaluate(scope);
            if (isFinite(y) && Math.abs(y) < 1000) {
                origXs.push(x);
                origYs.push(y);
            }
        } catch (e) {}
    }

    // Generate series approximation points
    var approxXs = [], approxYs = [];
    for (var j = 0; j <= nPts; j++) {
        var ax = xMin + step * j;
        var ay = evaluateSeries(ax, derivs, center, numTerms);
        if (isFinite(ay) && Math.abs(ay) < 1000) {
            approxXs.push(ax);
            approxYs.push(ay);
        }
    }

    // Calculate y range from both curves
    var allYs = origYs.concat(approxYs);
    var yMin = Math.min.apply(null, allYs);
    var yMax = Math.max.apply(null, allYs);
    if (!isFinite(yMin) || !isFinite(yMax)) { yMin = -10; yMax = 10; }
    var yPad = (yMax - yMin) * 0.15 || 5;

    var traces = [];

    // Original function
    traces.push({
        x: origXs,
        y: origYs,
        mode: 'lines',
        name: 'f(x) Original',
        line: { color: colors.originalColor, width: 3 }
    });

    // Series approximation
    traces.push({
        x: approxXs,
        y: approxYs,
        mode: 'lines',
        name: numTerms + '-term approximation',
        line: { color: colors.approxColor, width: 2.5, dash: 'dot' }
    });

    // Center point marker
    var centerY = evaluateSeries(center, derivs, center, numTerms);
    traces.push({
        x: [center],
        y: [isFinite(centerY) ? centerY : 0],
        mode: 'markers',
        name: 'Center: x = ' + center,
        marker: { color: colors.centerColor, size: 10, symbol: 'diamond', line: { color: '#fff', width: 2 } }
    });

    // Vertical center line
    traces.push({
        x: [center, center],
        y: [yMin - yPad, yMax + yPad],
        mode: 'lines',
        name: 'Center',
        showlegend: false,
        line: { color: colors.centerColor, width: 1.5, dash: 'dash' }
    });

    var layout = {
        title: { text: 'Function vs Series Approximation', font: { size: 14, color: colors.textColor } },
        xaxis: {
            title: 'x',
            gridcolor: colors.gridColor,
            zerolinecolor: colors.gridColor,
            zerolinewidth: 2,
            color: colors.textColor,
            range: [xMin, xMax]
        },
        yaxis: {
            title: 'y',
            gridcolor: colors.gridColor,
            zerolinecolor: colors.gridColor,
            zerolinewidth: 2,
            color: colors.textColor,
            range: [yMin - yPad, yMax + yPad]
        },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, sans-serif', color: colors.textColor },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 40, r: 20, b: 50, l: 50 }
    };

    Plotly.newPlot(container, traces, layout, {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d']
    });
}

// ==================== Exports ====================

window.SeriesCalcGraph = {
    loadPlotly: loadPlotly,
    renderGraph: renderGraph,
    evaluateSeries: evaluateSeries
};

})();
