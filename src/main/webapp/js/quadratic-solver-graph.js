/**
 * Quadratic Solver - Plotly Graph Module
 * Interactive parabola visualization with vertex, roots, axis of symmetry, inequality shading
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
        parabolaColor: '#7c3aed',
        vertexColor: '#10b981',
        rootColor: '#ef4444',
        yInterceptColor: '#f59e0b',
        axisColor: '#7c3aed',
        shadingColor: dark ? 'rgba(124,58,237,0.15)' : 'rgba(124,58,237,0.1)'
    };
}

function renderParabola(containerId, a, b, c, roots, inequalityOp) {
    if (!window.Plotly) return;
    var container = document.getElementById(containerId);
    if (!container) return;

    var colors = getPlotColors();

    // Vertex
    var h = -b / (2 * a);
    var k = c - b * b / (4 * a);

    // Dynamic range: center on vertex, extend past roots
    var xMin = h - 8, xMax = h + 8;
    if (roots && roots.type === 'real') {
        var r1 = Math.min(roots.x1, roots.x2);
        var r2 = Math.max(roots.x1, roots.x2);
        var span = Math.max(r2 - r1, 4);
        xMin = Math.min(r1 - span * 0.5, h - 4);
        xMax = Math.max(r2 + span * 0.5, h + 4);
    }

    // Generate parabola points
    var xs = [], ys = [];
    var nPts = 200;
    var step = (xMax - xMin) / nPts;
    for (var i = 0; i <= nPts; i++) {
        var x = xMin + step * i;
        xs.push(x);
        ys.push(a * x * x + b * x + c);
    }

    var traces = [];

    // Inequality shading
    if (inequalityOp && roots && roots.type === 'real') {
        var x1 = Math.min(roots.x1, roots.x2);
        var x2 = Math.max(roots.x1, roots.x2);
        var needBetween = (a > 0 && (inequalityOp === '<' || inequalityOp === '<=')) ||
                          (a < 0 && (inequalityOp === '>' || inequalityOp === '>='));

        if (needBetween) {
            // Shade between roots
            var sxs = [], sys = [];
            for (var j = 0; j <= nPts; j++) {
                var sx = xMin + step * j;
                if (sx >= x1 && sx <= x2) {
                    sxs.push(sx);
                    sys.push(a * sx * sx + b * sx + c);
                }
            }
            traces.push({
                x: sxs, y: sys,
                fill: 'tozeroy',
                fillcolor: colors.shadingColor,
                line: { width: 0 },
                showlegend: false,
                hoverinfo: 'skip'
            });
        } else {
            // Shade outside roots
            var lxs = [], lys = [], rxs = [], rys = [];
            for (var j2 = 0; j2 <= nPts; j2++) {
                var sx2 = xMin + step * j2;
                if (sx2 <= x1) { lxs.push(sx2); lys.push(a * sx2 * sx2 + b * sx2 + c); }
                if (sx2 >= x2) { rxs.push(sx2); rys.push(a * sx2 * sx2 + b * sx2 + c); }
            }
            traces.push({
                x: lxs, y: lys,
                fill: 'tozeroy', fillcolor: colors.shadingColor,
                line: { width: 0 }, showlegend: false, hoverinfo: 'skip'
            });
            traces.push({
                x: rxs, y: rys,
                fill: 'tozeroy', fillcolor: colors.shadingColor,
                line: { width: 0 }, showlegend: false, hoverinfo: 'skip'
            });
        }
    }

    // Parabola curve
    traces.push({
        x: xs, y: ys,
        mode: 'lines',
        name: 'y = ' + formatEq(a, b, c),
        line: { color: colors.parabolaColor, width: 3 }
    });

    // Axis of symmetry (dashed vertical)
    var yRange = Math.max.apply(null, ys.map(Math.abs));
    traces.push({
        x: [h, h],
        y: [k - yRange * 0.8, k + yRange * 0.8],
        mode: 'lines',
        name: 'Axis: x = ' + h.toFixed(2),
        line: { color: colors.axisColor, width: 1.5, dash: 'dash' }
    });

    // Vertex
    traces.push({
        x: [h], y: [k],
        mode: 'markers+text',
        name: 'Vertex (' + h.toFixed(2) + ', ' + k.toFixed(2) + ')',
        marker: { color: colors.vertexColor, size: 10, symbol: 'diamond', line: { color: '#fff', width: 2 } },
        text: ['Vertex'],
        textposition: 'top center',
        textfont: { size: 11, color: colors.textColor }
    });

    // Roots
    if (roots && roots.type === 'real') {
        var rootPts = [];
        if (Math.abs(roots.x1 - roots.x2) > 0.0001) {
            rootPts.push({ x: roots.x1, y: 0 }, { x: roots.x2, y: 0 });
        } else {
            rootPts.push({ x: roots.x1, y: 0 });
        }
        traces.push({
            x: rootPts.map(function(p) { return p.x; }),
            y: rootPts.map(function(p) { return p.y; }),
            mode: 'markers',
            name: 'Roots',
            marker: { color: colors.rootColor, size: 10, symbol: 'circle', line: { color: '#fff', width: 2 } }
        });
    }

    // Y-intercept
    traces.push({
        x: [0], y: [c],
        mode: 'markers',
        name: 'Y-intercept (0, ' + c + ')',
        marker: { color: colors.yInterceptColor, size: 9, symbol: 'circle', line: { color: '#fff', width: 2 } }
    });

    // Determine Y axis range
    var yMin = Math.min.apply(null, ys);
    var yMax = Math.max.apply(null, ys);
    var yPad = (yMax - yMin) * 0.1 || 5;

    var layout = {
        title: { text: 'Parabola Graph', font: { size: 14, color: colors.textColor } },
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

function formatEq(a, b, c) {
    var eq = '';
    if (a !== 0) eq += (a === 1 ? '' : (a === -1 ? '-' : a)) + 'x\u00B2';
    if (b !== 0) {
        if (eq && b > 0) eq += ' + ';
        if (eq && b < 0) eq += ' - ';
        if (!eq && b < 0) eq += '-';
        var absB = Math.abs(b);
        eq += (absB === 1 ? '' : absB) + 'x';
    }
    if (c !== 0) {
        if (eq && c > 0) eq += ' + ';
        if (eq && c < 0) eq += ' - ';
        eq += Math.abs(c);
    }
    return eq || '0';
}

// ==================== Exports ====================

window.QuadraticSolverGraph = {
    loadPlotly: loadPlotly,
    renderParabola: renderParabola
};

})();
