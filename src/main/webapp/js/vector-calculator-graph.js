/**
 * Vector Calculator - Graph Module
 * 2D and 3D vector visualization with Plotly
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
        vecAColor: '#0284c7',
        vecBColor: '#f59e0b',
        vecCColor: '#8b5cf6',
        resultColor: '#10b981',
        projColor: '#ef4444'
    };
}

function renderGraph2D(containerId, vectors, result, mode) {
    if (!window.Plotly) return;
    var container = document.getElementById(containerId);
    if (!container) return;

    var colors = getPlotColors();
    var traces = [];
    var shapes = [];
    var annotations = [];

    // Helper to add a 2D vector arrow
    function addVector(v, name, color, dash) {
        traces.push({
            x: [0, v[0]],
            y: [0, v[1]],
            mode: 'lines+markers',
            name: name,
            line: { color: color, width: 3, dash: dash || 'solid' },
            marker: { size: [4, 8], color: color, symbol: ['circle', 'triangle-up'] }
        });
    }

    // Vector a
    if (vectors.a) addVector(vectors.a, 'a', colors.vecAColor);
    // Vector b
    if (vectors.b) addVector(vectors.b, 'b', colors.vecBColor);
    // Result vector
    if (result && result.type === 'vector' && result.result) {
        addVector(result.result, 'Result', colors.resultColor, 'dash');
    }
    // Projection vector
    if (vectors.proj) {
        addVector(vectors.proj, 'Projection', colors.projColor, 'dot');
    }

    // Determine axis range
    var allX = [0], allY = [0];
    traces.forEach(function(t) {
        if (t.x) t.x.forEach(function(v) { allX.push(v); });
        if (t.y) t.y.forEach(function(v) { allY.push(v); });
    });
    var maxAbs = Math.max(
        Math.abs(Math.min.apply(null, allX)),
        Math.abs(Math.max.apply(null, allX)),
        Math.abs(Math.min.apply(null, allY)),
        Math.abs(Math.max.apply(null, allY)),
        1
    );
    var pad = maxAbs * 0.3 + 1;
    var range = [-(maxAbs + pad), maxAbs + pad];

    // Angle arc if in angle mode
    if (mode === 'angle' && vectors.a && vectors.b) {
        var R = window.VecCalcRender;
        if (R) {
            var angleResult = R.angle(vectors.a, vectors.b);
            if (angleResult) {
                var arcR = maxAbs * 0.3;
                var magA = R.magnitude(vectors.a);
                var magB = R.magnitude(vectors.b);
                if (magA > 0 && magB > 0) {
                    var startAngle = Math.atan2(vectors.a[1], vectors.a[0]);
                    var endAngle = Math.atan2(vectors.b[1], vectors.b[0]);
                    // Draw arc
                    var arcX = [], arcY = [];
                    var steps = 30;
                    var a1 = startAngle, a2 = endAngle;
                    if (a2 < a1) a2 += 2 * Math.PI;
                    for (var i = 0; i <= steps; i++) {
                        var t = a1 + (a2 - a1) * i / steps;
                        arcX.push(arcR * Math.cos(t));
                        arcY.push(arcR * Math.sin(t));
                    }
                    traces.push({
                        x: arcX, y: arcY,
                        mode: 'lines',
                        name: 'Angle',
                        line: { color: '#94a3b8', width: 1.5, dash: 'dot' },
                        showlegend: false
                    });
                }
            }
        }
    }

    var layout = {
        title: { text: '2D Vector Plot', font: { size: 14, color: colors.textColor } },
        xaxis: {
            title: 'x',
            gridcolor: colors.gridColor,
            zerolinecolor: colors.gridColor,
            zerolinewidth: 2,
            color: colors.textColor,
            range: range,
            scaleanchor: 'y',
            scaleratio: 1
        },
        yaxis: {
            title: 'y',
            gridcolor: colors.gridColor,
            zerolinecolor: colors.gridColor,
            zerolinewidth: 2,
            color: colors.textColor,
            range: range
        },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, sans-serif', color: colors.textColor },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 40, r: 20, b: 50, l: 50 },
        shapes: shapes,
        annotations: annotations
    };

    Plotly.newPlot(container, traces, layout, {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d']
    });
}

function renderGraph3D(containerId, vectors, result, mode) {
    if (!window.Plotly) return;
    var container = document.getElementById(containerId);
    if (!container) return;

    var colors = getPlotColors();
    var traces = [];

    // Helper to add a 3D vector arrow using line + cone
    function addVector3D(v, name, color, dash) {
        // Line from origin
        traces.push({
            x: [0, v[0]],
            y: [0, v[1]],
            z: [0, v[2]],
            mode: 'lines',
            name: name,
            type: 'scatter3d',
            line: { color: color, width: 5, dash: dash || 'solid' }
        });
        // Cone arrowhead at tip
        var mag = Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        if (mag > 0) {
            traces.push({
                x: [v[0]],
                y: [v[1]],
                z: [v[2]],
                u: [v[0]/mag],
                v: [v[1]/mag],
                w: [v[2]/mag],
                type: 'cone',
                sizemode: 'absolute',
                sizeref: mag * 0.12,
                colorscale: [[0, color], [1, color]],
                showscale: false,
                name: name + ' tip',
                showlegend: false
            });
        }
    }

    // Vector a
    if (vectors.a) addVector3D(vectors.a, 'a', colors.vecAColor);
    // Vector b
    if (vectors.b) addVector3D(vectors.b, 'b', colors.vecBColor);
    // Vector c
    if (vectors.c) addVector3D(vectors.c, 'c', colors.vecCColor);
    // Result vector
    if (result && result.type === 'vector' && result.result) {
        addVector3D(result.result, 'Result', colors.resultColor, 'dash');
    }
    // Projection
    if (vectors.proj) {
        addVector3D(vectors.proj, 'Projection', colors.projColor, 'dot');
    }

    // Area mesh (parallelogram) if in area mode
    if (mode === 'area' && vectors.a && vectors.b) {
        var a = vectors.a, b = vectors.b;
        traces.push({
            x: [0, a[0], a[0]+b[0], b[0]],
            y: [0, a[1], a[1]+b[1], b[1]],
            z: [0, a[2], a[2]+b[2], b[2]],
            i: [0, 0],
            j: [1, 2],
            k: [3, 3],
            type: 'mesh3d',
            color: colors.resultColor,
            opacity: 0.25,
            name: 'Parallelogram',
            showlegend: false
        });
    }

    // Determine range
    var allVals = [0];
    traces.forEach(function(t) {
        ['x', 'y', 'z'].forEach(function(axis) {
            if (t[axis]) {
                for (var i = 0; i < t[axis].length; i++) {
                    if (typeof t[axis][i] === 'number') allVals.push(t[axis][i]);
                }
            }
        });
    });
    var maxAbs = Math.max.apply(null, allVals.map(function(v) { return Math.abs(v); }).concat([1]));
    var pad = maxAbs * 0.3 + 1;
    var range = [-(maxAbs + pad), maxAbs + pad];

    var layout = {
        title: { text: '3D Vector Plot', font: { size: 14, color: colors.textColor } },
        scene: {
            xaxis: { title: 'x', gridcolor: colors.gridColor, zerolinecolor: colors.gridColor, color: colors.textColor, range: range },
            yaxis: { title: 'y', gridcolor: colors.gridColor, zerolinecolor: colors.gridColor, color: colors.textColor, range: range },
            zaxis: { title: 'z', gridcolor: colors.gridColor, zerolinecolor: colors.gridColor, color: colors.textColor, range: range },
            aspectmode: 'cube',
            camera: { eye: { x: 1.5, y: 1.5, z: 1.2 } },
            bgcolor: colors.bg
        },
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, sans-serif', color: colors.textColor },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 40, r: 10, b: 10, l: 10 }
    };

    Plotly.newPlot(container, traces, layout, {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d']
    });
}

// ==================== Exports ====================

window.VecCalcGraph = {
    loadPlotly: loadPlotly,
    renderGraph2D: renderGraph2D,
    renderGraph3D: renderGraph3D
};

})();
