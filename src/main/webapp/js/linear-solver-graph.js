/**
 * Linear Solver - Plotly Visualization
 * 2D line plots for 2-variable systems, 3D plane plots for 3-variable systems
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
        lineColors: ['#6366f1', '#ef4444', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899'],
        solutionColor: '#6366f1'
    };
}

// ==================== 2D Visualization ====================

function render2D(container, A, b, solution) {
    if (!window.Plotly || !container) return;

    var colors = getPlotColors();
    var traces = [];

    // Determine plot range based on solution
    var xCenter = solution ? solution[0] : 0;
    var yCenter = solution ? solution[1] : 0;
    var range = 10;
    var xMin = xCenter - range, xMax = xCenter + range;

    // Plot each equation as a line: a1*x + a2*y = b_i → y = (b_i - a1*x) / a2
    for (var i = 0; i < Math.min(A.length, 6); i++) {
        var a1 = A[i][0], a2 = A[i][1], bi = b[i];
        var xs = [], ys = [];
        var n = 200;

        if (Math.abs(a2) < 1e-10) {
            // Vertical line: x = b_i / a1
            if (Math.abs(a1) > 1e-10) {
                var xVal = bi / a1;
                traces.push({
                    x: [xVal, xVal],
                    y: [yCenter - range, yCenter + range],
                    mode: 'lines',
                    name: 'Eq ' + (i + 1) + ': ' + formatEquation(A[i], bi),
                    line: { color: colors.lineColors[i % colors.lineColors.length], width: 2.5 }
                });
            }
            continue;
        }

        for (var j = 0; j <= n; j++) {
            var x = xMin + (xMax - xMin) * j / n;
            var y = (bi - a1 * x) / a2;
            xs.push(x);
            ys.push(y);
        }

        traces.push({
            x: xs,
            y: ys,
            mode: 'lines',
            name: 'Eq ' + (i + 1) + ': ' + formatEquation(A[i], bi),
            line: { color: colors.lineColors[i % colors.lineColors.length], width: 2.5 }
        });
    }

    // Plot solution point
    if (solution) {
        traces.push({
            x: [solution[0]],
            y: [solution[1]],
            mode: 'markers+text',
            name: 'Solution (' + solution[0].toFixed(2) + ', ' + solution[1].toFixed(2) + ')',
            marker: { color: colors.solutionColor, size: 12, symbol: 'circle', line: { color: '#fff', width: 2 } },
            text: ['(' + solution[0].toFixed(2) + ', ' + solution[1].toFixed(2) + ')'],
            textposition: 'top right',
            textfont: { size: 12, color: colors.textColor }
        });
    }

    var layout = {
        title: { text: 'System of Equations', font: { size: 14, color: colors.textColor } },
        xaxis: { title: 'x', gridcolor: colors.gridColor, zerolinecolor: colors.gridColor, color: colors.textColor, range: [xMin, xMax] },
        yaxis: { title: 'y', gridcolor: colors.gridColor, zerolinecolor: colors.gridColor, color: colors.textColor, range: [yCenter - range, yCenter + range] },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, sans-serif', color: colors.textColor },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 40, r: 20, b: 50, l: 50 }
    };

    Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
}

// ==================== 3D Visualization ====================

function render3D(container, A, b, solution) {
    if (!window.Plotly || !container) return;

    var colors = getPlotColors();
    var traces = [];

    var center = solution || [0, 0, 0];
    var range = 8;

    // Plot each equation as a plane: a1*x + a2*y + a3*z = b_i → z = (b_i - a1*x - a2*y) / a3
    for (var i = 0; i < Math.min(A.length, 4); i++) {
        var a1 = A[i][0], a2 = A[i][1], a3 = A[i][2], bi = b[i];

        if (Math.abs(a3) < 1e-10) continue; // skip if z coefficient is 0

        var n = 20;
        var xVals = [], yVals = [], zVals = [];

        for (var xi = 0; xi <= n; xi++) {
            var xRow = [], yRow = [], zRow = [];
            for (var yi = 0; yi <= n; yi++) {
                var x = center[0] - range + (2 * range * xi / n);
                var y = center[1] - range + (2 * range * yi / n);
                var z = (bi - a1 * x - a2 * y) / a3;
                xRow.push(x);
                yRow.push(y);
                zRow.push(z);
            }
            xVals.push(xRow);
            yVals.push(yRow);
            zVals.push(zRow);
        }

        traces.push({
            type: 'surface',
            x: xVals,
            y: yVals,
            z: zVals,
            name: 'Eq ' + (i + 1),
            opacity: 0.6,
            showscale: false,
            colorscale: [[0, colors.lineColors[i % colors.lineColors.length]], [1, colors.lineColors[i % colors.lineColors.length]]]
        });
    }

    // Solution point
    if (solution) {
        traces.push({
            type: 'scatter3d',
            x: [solution[0]],
            y: [solution[1]],
            z: [solution[2]],
            mode: 'markers+text',
            name: 'Solution',
            marker: { color: colors.solutionColor, size: 8, symbol: 'circle' },
            text: ['(' + solution.map(function(v) { return v.toFixed(2); }).join(', ') + ')'],
            textposition: 'top'
        });
    }

    var layout = {
        title: { text: '3D System of Equations', font: { size: 14, color: colors.textColor } },
        scene: {
            xaxis: { title: 'x', gridcolor: colors.gridColor, color: colors.textColor },
            yaxis: { title: 'y', gridcolor: colors.gridColor, color: colors.textColor },
            zaxis: { title: 'z', gridcolor: colors.gridColor, color: colors.textColor },
            bgcolor: colors.bg
        },
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, sans-serif', color: colors.textColor },
        showlegend: true,
        margin: { t: 40, r: 10, b: 10, l: 10 }
    };

    Plotly.newPlot(container, traces, layout, { responsive: true });
}

// ==================== Helpers ====================

function formatEquation(coeffs, b) {
    var varNames = ['x', 'y', 'z', 'w'];
    var parts = [];
    for (var i = 0; i < coeffs.length; i++) {
        var c = coeffs[i];
        if (Math.abs(c) < 1e-10) continue;
        var sign = c > 0 && parts.length > 0 ? '+' : '';
        var coef = Math.abs(c) === 1 ? (c < 0 ? '-' : '') : c.toString();
        parts.push(sign + coef + (varNames[i] || 'x' + (i + 1)));
    }
    return (parts.join('') || '0') + ' = ' + (typeof b === 'number' ? b.toFixed(1) : b);
}

// ==================== Exports ====================

window.LinearSolverGraph = {
    loadPlotly: loadPlotly,
    render2D: render2D,
    render3D: render3D
};

})();
