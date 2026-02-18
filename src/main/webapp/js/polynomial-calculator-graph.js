/**
 * Polynomial Calculator - Graph Module
 * Interactive polynomial visualization with Plotly
 */
(function() {
'use strict';

var __plotlyLoaded = false;

function loadPlotly(cb) {
    if (__plotlyLoaded || window.Plotly) { __plotlyLoaded = true; if (cb) cb(); return; }
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
        p1Color: '#0d9488',
        p2Color: '#f59e0b',
        resultColor: '#10b981',
        rootColor: '#ef4444'
    };
}

function evalPoly(expr, xArr) {
    var ys = [];
    for (var i = 0; i < xArr.length; i++) {
        try {
            var val = nerdamer(expr).evaluate({ x: xArr[i] });
            var num = parseFloat(val.text('decimals'));
            ys.push(isFinite(num) ? num : null);
        } catch (e) {
            ys.push(null);
        }
    }
    return ys;
}

function renderGraph(containerId, polynomials, roots) {
    if (!window.Plotly) return;
    var container = document.getElementById(containerId);
    if (!container) return;

    var colors = getPlotColors();
    var traces = [];

    // Determine x-range from roots or default
    var xMin = -10, xMax = 10;
    if (roots && roots.length > 0) {
        var realRoots = [];
        for (var r = 0; r < roots.length; r++) {
            var rv = parseFloat(roots[r]);
            if (isFinite(rv)) realRoots.push(rv);
        }
        if (realRoots.length > 0) {
            var minR = Math.min.apply(null, realRoots);
            var maxR = Math.max.apply(null, realRoots);
            var span = Math.max(maxR - minR, 4);
            xMin = minR - span * 0.8;
            xMax = maxR + span * 0.8;
        }
    }

    // Generate x points
    var nPts = 300;
    var step = (xMax - xMin) / nPts;
    var xs = [];
    for (var i = 0; i <= nPts; i++) {
        xs.push(xMin + step * i);
    }

    // P(x) trace
    if (polynomials.p1) {
        var ys1 = evalPoly(polynomials.p1, xs);
        traces.push({
            x: xs, y: ys1,
            mode: 'lines',
            name: 'P(x)',
            line: { color: colors.p1Color, width: 3 }
        });
    }

    // Q(x) trace
    if (polynomials.p2) {
        var ys2 = evalPoly(polynomials.p2, xs);
        traces.push({
            x: xs, y: ys2,
            mode: 'lines',
            name: 'Q(x)',
            line: { color: colors.p2Color, width: 2.5 }
        });
    }

    // Result trace
    if (polynomials.result) {
        var ysR = evalPoly(polynomials.result, xs);
        traces.push({
            x: xs, y: ysR,
            mode: 'lines',
            name: 'Result',
            line: { color: colors.resultColor, width: 2.5, dash: 'dash' }
        });
    }

    // Root markers
    if (roots && roots.length > 0) {
        var rootXs = [], rootYs = [];
        for (var j = 0; j < roots.length; j++) {
            var rootVal = parseFloat(roots[j]);
            if (isFinite(rootVal)) {
                rootXs.push(rootVal);
                rootYs.push(0);
            }
        }
        if (rootXs.length > 0) {
            traces.push({
                x: rootXs, y: rootYs,
                mode: 'markers',
                name: 'Roots',
                marker: { color: colors.rootColor, size: 10, symbol: 'circle', line: { color: '#fff', width: 2 } }
            });
        }
    }

    // Calculate y range
    var allYs = [];
    for (var t = 0; t < traces.length; t++) {
        if (traces[t].y) {
            for (var k = 0; k < traces[t].y.length; k++) {
                if (traces[t].y[k] !== null && isFinite(traces[t].y[k])) {
                    allYs.push(traces[t].y[k]);
                }
            }
        }
    }
    var yMin = allYs.length > 0 ? Math.min.apply(null, allYs) : -10;
    var yMax = allYs.length > 0 ? Math.max.apply(null, allYs) : 10;
    var yPad = (yMax - yMin) * 0.1 || 5;
    // Clamp to reasonable range
    yMin = Math.max(yMin - yPad, -1000);
    yMax = Math.min(yMax + yPad, 1000);

    var layout = {
        title: { text: 'Polynomial Graph', font: { size: 14, color: colors.textColor } },
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
            range: [yMin, yMax]
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

window.PolyCalcGraph = {
    loadPlotly: loadPlotly,
    renderGraph: renderGraph
};

})();
