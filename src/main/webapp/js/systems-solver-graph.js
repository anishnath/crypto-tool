/**
 * Systems of Equations Solver - Plotly Graph Module
 * 2x2 system: plot both lines and intersection point
 */
(function() {
'use strict';

var __plotlyLoaded = false;

// ==================== Plotly Lazy Load ====================

function _loadPlotly(cb) {
    if (typeof window.Plotly !== 'undefined') {
        if (cb) cb();
        return;
    }
    // Poll until Plotly is ready (handles in-flight script tag from any source)
    function _poll() {
        if (typeof window.Plotly !== 'undefined') {
            if (cb) cb();
        } else {
            setTimeout(_poll, 80);
        }
    }
    if (__plotlyLoaded) {
        // Script already injected — just wait for it
        _poll();
        return;
    }
    __plotlyLoaded = true;
    var s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.26.0.min.js';
    s.onload = function() { if (cb) cb(); };
    s.onerror = function() { __plotlyLoaded = false; };
    document.head.appendChild(s);
}

// ==================== Theme ====================

function _isDark() {
    return document.documentElement.getAttribute('data-theme') === 'dark';
}

function _colors() {
    var dark = _isDark();
    return {
        bg:          dark ? '#1e293b' : '#ffffff',
        paper:       dark ? '#1e293b' : '#ffffff',
        grid:        dark ? '#334155' : '#e2e8f0',
        text:        dark ? '#cbd5e1' : '#475569',
        zeroline:    dark ? '#475569' : '#94a3b8',
        line1:       '#10b981',   // Emerald for equation 1
        line2:       '#3b82f6',   // Blue for equation 2
        line3:       '#8b5cf6',   // Violet for equation 3 (3D)
        intersection:'#f59e0b'    // Amber for intersection point
    };
}

// 3D equation label: a*x + b*y + c*z = d
function _eqLabel3(a, b, c, d) {
    var parts = [];
    var first = true;
    function coeffStr(coef, varName) {
        if (Math.abs(coef) < 1e-12) return;
        var sign = '';
        if (!first) sign = coef >= 0 ? ' + ' : ' - ';
        else if (coef < 0) sign = '-';
        var abs = Math.abs(coef);
        var absStr = Math.abs(abs - Math.round(abs)) < 1e-9
            ? String(Math.round(abs))
            : parseFloat(abs.toFixed(4)).toString();
        parts.push(sign + (absStr === '1' ? '' : absStr) + varName);
        first = false;
    }
    coeffStr(a, 'x'); coeffStr(b, 'y'); coeffStr(c, 'z');
    var lhs = parts.length ? parts.join('') : '0';
    var dStr = Math.abs(d - Math.round(d)) < 1e-9 ? String(Math.round(d)) : parseFloat(d.toFixed(4)).toString();
    return lhs + ' = ' + dStr;
}

// ==================== Equation label ====================

function _eqLabel(a, b, c) {
    // Equation: a*x + b*y = c
    var parts = [];
    var first = true;

    function coeffStr(coef, varName) {
        if (Math.abs(coef) < 1e-12) return;
        var sign = '';
        if (!first) sign = coef >= 0 ? ' + ' : ' - ';
        else if (coef < 0) sign = '-';
        var abs = Math.abs(coef);
        var absStr = Math.abs(abs - Math.round(abs)) < 1e-9
            ? String(Math.round(abs))
            : parseFloat(abs.toFixed(4)).toString();
        parts.push(sign + (absStr === '1' ? '' : absStr) + varName);
        first = false;
    }

    coeffStr(a, 'x');
    coeffStr(b, 'y');

    var lhs = parts.length ? parts.join('') : '0';
    var cStr = Math.abs(c - Math.round(c)) < 1e-9 ? String(Math.round(c)) : parseFloat(c.toFixed(4)).toString();
    return lhs + ' = ' + cStr;
}

// ==================== 2x2 Draw ====================

function draw2x2(A, b, solution, containerId) {
    var container = document.getElementById(containerId);
    if (!container) return;

    _loadPlotly(function() {
        if (!window.Plotly) return;
        _render2x2(A, b, solution, container);
    });
}

function _render2x2(A, b, solution, container) {
    var colors = _colors();
    var traces = [];

    // Determine axis range centered on solution (or origin)
    var xSol = solution ? solution[0] : 0;
    var ySol = solution ? solution[1] : 0;

    var xMin = Math.min(-10, xSol - 5);
    var xMax = Math.max(10, xSol + 5);
    var yMin = Math.min(-10, ySol - 5);
    var yMax = Math.max(10, ySol + 5);

    var N = 100;

    var lineColors = [colors.line1, colors.line2];

    for (var i = 0; i < 2; i++) {
        var a1 = A[i][0];
        var a2 = A[i][1];
        var bi = b[i];
        var label = 'Eq ' + (i + 1) + ': ' + _eqLabel(a1, a2, bi);

        if (Math.abs(a2) < 1e-10) {
            // Vertical line: x = bi/a1
            if (Math.abs(a1) > 1e-10) {
                var xv = bi / a1;
                traces.push({
                    x: [xv, xv],
                    y: [yMin - 2, yMax + 2],
                    mode: 'lines',
                    name: label,
                    line: {
                        color: lineColors[i],
                        width: 2.5
                    }
                });
            }
            continue;
        }

        // y = (bi - a1*x) / a2
        var xs = [];
        var ys = [];
        for (var j = 0; j <= N; j++) {
            var x = xMin + (xMax - xMin) * j / N;
            var y = (bi - a1 * x) / a2;
            xs.push(x);
            ys.push(y);
        }

        traces.push({
            x: xs,
            y: ys,
            mode: 'lines',
            name: label,
            line: {
                color: lineColors[i],
                width: 2.5
            }
        });
    }

    // Intersection / solution point
    if (solution && isFinite(solution[0]) && isFinite(solution[1])) {
        var xLabel = parseFloat(solution[0].toFixed(4));
        var yLabel = parseFloat(solution[1].toFixed(4));
        var ptLabel = '(' + xLabel + ', ' + yLabel + ')';

        traces.push({
            x: [solution[0]],
            y: [solution[1]],
            mode: 'markers+text',
            name: 'Intersection ' + ptLabel,
            marker: {
                color: colors.intersection,
                size: 13,
                symbol: 'circle',
                line: { color: '#ffffff', width: 2 }
            },
            text: [ptLabel],
            textposition: 'top right',
            textfont: { size: 12, color: colors.text }
        });
    }

    var layout = {
        title: {
            text: 'System of 2 Equations',
            font: { size: 14, color: colors.text, family: 'Inter, system-ui, sans-serif' }
        },
        xaxis: {
            title: 'x',
            gridcolor: colors.grid,
            zerolinecolor: colors.zeroline,
            color: colors.text,
            range: [xMin, xMax],
            showgrid: true,
            zeroline: true
        },
        yaxis: {
            title: 'y',
            gridcolor: colors.grid,
            zerolinecolor: colors.zeroline,
            color: colors.text,
            range: [yMin, yMax],
            showgrid: true,
            zeroline: true
        },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        font: { family: 'Inter, system-ui, sans-serif', color: colors.text, size: 12 },
        showlegend: true,
        legend: {
            x: 0,
            y: 1,
            bgcolor: 'rgba(0,0,0,0)',
            font: { size: 11 }
        },
        margin: { t: 45, r: 20, b: 50, l: 55 },
        annotations: solution && isFinite(solution[0]) ? [{
            x: solution[0],
            y: solution[1],
            xref: 'x',
            yref: 'y',
            text: 'Intersection',
            showarrow: true,
            arrowhead: 2,
            arrowsize: 1,
            arrowwidth: 1.5,
            arrowcolor: colors.intersection,
            ax: 40,
            ay: -40,
            font: { size: 11, color: colors.intersection },
            bgcolor: 'rgba(0,0,0,0)'
        }] : []
    };

    var config = {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d'],
        displaylogo: false
    };

    container.innerHTML = '';
    window.Plotly.newPlot(container, traces, layout, config);
}

// ==================== Nonlinear 2×2 Draw ====================

function drawNonlinear2(eqs, vars, solutions, containerId) {
    var container = document.getElementById(containerId);
    if (!container || !window.nerdamer) return;
    _loadPlotly(function() {
        if (!window.Plotly) return;
        _renderNonlinear2(eqs, vars, solutions, container);
    });
}

function _renderNonlinear2(eqs, vars, solutions, container) {
    var colors = _colors();
    var xVar = vars[0], yVar = vars[1];

    // Determine centre from solutions (or origin)
    var xCenter = 0, yCenter = 0;
    if (solutions && solutions.length > 0) {
        xCenter = solutions[0][xVar] || 0;
        yCenter = solutions[0][yVar] || 0;
    }
    var xMin = Math.min(-10, xCenter - 8);
    var xMax = Math.max(10,  xCenter + 8);
    var N = 300;

    var lineColors = [colors.line1, colors.line2];
    var traces = [];

    for (var i = 0; i < eqs.length; i++) {
        var eq = eqs[i];
        try {
            var parts = eq.split('=');
            var expr = '(' + parts[0] + ')-(' + parts[1] + ')';
            var ySolved = window.nerdamer.solve(expr, yVar);
            var yText = ySolved.text().replace(/^\[|\]$/g, '');
            if (!yText) continue;
            var yExprs = yText.split(',').map(function(s) { return s.trim(); }).filter(Boolean);

            for (var ve = 0; ve < yExprs.length; ve++) {
                var yExpr = yExprs[ve];
                var xs = [], ys = [];
                for (var j = 0; j <= N; j++) {
                    var xv = xMin + (xMax - xMin) * j / N;
                    try {
                        window.nerdamer.setVar(xVar, String(xv));
                        var yv = parseFloat(window.nerdamer(yExpr).evaluate().text());
                        window.nerdamer.clearVars();
                        if (isFinite(yv)) { xs.push(xv); ys.push(yv); }
                        else             { xs.push(null);  ys.push(null); }
                    } catch(e) { window.nerdamer.clearVars(); xs.push(null); ys.push(null); }
                }
                var branchSuffix = yExprs.length > 1 ? ' (branch ' + (ve + 1) + ')' : '';
                traces.push({
                    x: xs, y: ys,
                    mode: 'lines',
                    name: 'Eq\u00a0' + (i + 1) + branchSuffix + ': ' + eq,
                    line: { color: lineColors[i % 2], width: 2.5 },
                    connectgaps: false
                });
            }
        } catch(e) { /* skip equation if CAS fails */ }
    }

    // Plot solution points
    if (solutions && solutions.length > 0) {
        var ptXs = [], ptYs = [], ptLabels = [];
        for (var si = 0; si < solutions.length; si++) {
            var sol = solutions[si];
            var sx = sol[xVar], sy = sol[yVar];
            if (isFinite(sx) && isFinite(sy)) {
                ptXs.push(sx); ptYs.push(sy);
                ptLabels.push('(' + parseFloat(sx.toFixed(4)) + ',\u202f' + parseFloat(sy.toFixed(4)) + ')');
            }
        }
        if (ptXs.length) {
            traces.push({
                x: ptXs, y: ptYs,
                mode: 'markers+text',
                name: solutions.length === 1 ? 'Solution' : 'Solutions',
                marker: { color: colors.intersection, size: 12, symbol: 'circle', line: { color: '#fff', width: 2 } },
                text: ptLabels,
                textposition: 'top right',
                textfont: { size: 11, color: colors.text }
            });
        }
    }

    // Auto-range — focus on where the curves actually are
    var allX = [], allY = [];
    traces.forEach(function(t) {
        if (t.x) t.x.forEach(function(v) { if (v !== null && isFinite(v)) allX.push(v); });
        if (t.y) t.y.forEach(function(v) { if (v !== null && isFinite(v)) allY.push(v); });
    });
    var xPad = 1, yPad = 1;
    var xRange = allX.length ? [Math.min.apply(null, allX) - xPad, Math.max.apply(null, allX) + xPad] : [-12, 12];
    var yRange = allY.length ? [Math.min.apply(null, allY) - yPad, Math.max.apply(null, allY) + yPad] : [-12, 12];

    var layout = {
        title: { text: 'Nonlinear System — Intersection Curves', font: { size: 14, color: colors.text, family: 'Inter, system-ui, sans-serif' } },
        xaxis: { title: xVar, gridcolor: colors.grid, zerolinecolor: colors.zeroline, color: colors.text, range: xRange, showgrid: true, zeroline: true },
        yaxis: { title: yVar, gridcolor: colors.grid, zerolinecolor: colors.zeroline, color: colors.text, range: yRange, showgrid: true, zeroline: true },
        plot_bgcolor: colors.bg, paper_bgcolor: colors.paper,
        font: { family: 'Inter, system-ui, sans-serif', color: colors.text, size: 12 },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 45, r: 20, b: 50, l: 55 }
    };

    container.innerHTML = '';
    window.Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'], displaylogo: false });
}

// ==================== Clear ====================

function clear(containerId) {
    var container = document.getElementById(containerId);
    if (!container) return;
    if (window.Plotly) {
        try { window.Plotly.purge(container); } catch (e) { /* ignore */ }
    }
    container.innerHTML = '';
}

// ==================== 3x3 Draw — three planes in 3D ====================
// Each row of (A | b) defines a plane: a·x + b·y + c·z = d. Three planes
// generically intersect at a unique point (the system's solution). We
// render each as a Plotly 'surface' over a square (x, y) domain centered
// around the solution (or on [-10, 10]² when no unique intersection).
//
// Vertical-plane handling: when the z-coefficient c is ~0, the plane is
// parallel to the z-axis. We render it as a line-strip of constant
// (x, y) along the full z-range — Plotly's mesh3d would also work but
// surface is simpler with a synthetic constant grid.
function draw3x3(A, b, solution, vars, containerId) {
    var container = document.getElementById(containerId);
    if (!container) return;
    if (!window.Plotly) {
        _loadPlotly(function() { draw3x3(A, b, solution, vars, containerId); });
        return;
    }
    vars = vars || ['x', 'y', 'z'];
    var colors = _colors();

    // Center the viewing box on the solution if it's a finite point;
    // otherwise default to [-10, 10] in each axis.
    var hasSol = Array.isArray(solution) && solution.length === 3 &&
                 solution.every(function(v) { return isFinite(v); });
    var cx = hasSol ? solution[0] : 0;
    var cy = hasSol ? solution[1] : 0;
    var cz = hasSol ? solution[2] : 0;
    var halfRange = hasSol
        ? Math.max(5, 1.5 * Math.max(Math.abs(cx), Math.abs(cy), Math.abs(cz), 1))
        : 10;
    var xMin = cx - halfRange, xMax = cx + halfRange;
    var yMin = cy - halfRange, yMax = cy + halfRange;
    var zMin = cz - halfRange, zMax = cz + halfRange;

    var GRID = 12;
    function buildPlane(rowA, d, rowColor, label) {
        var aa = rowA[0], bb = rowA[1], cc = rowA[2];

        // Build x, y grids
        var xs = [], ys = [];
        for (var i = 0; i <= GRID; i++) {
            xs.push(xMin + (xMax - xMin) * i / GRID);
            ys.push(yMin + (yMax - yMin) * i / GRID);
        }

        // Vertical plane (z-coefficient ~ 0): generate a tall ribbon along
        // the line aa*x + bb*y = d in the xy-plane, swept up the z-axis.
        if (Math.abs(cc) < 1e-9) {
            // Need a line in xy: solve for one variable in terms of the other.
            var lineX = [], lineY = [];
            if (Math.abs(bb) >= Math.abs(aa)) {
                // y = (d - aa*x) / bb
                for (var i = 0; i <= GRID; i++) {
                    var xv = xMin + (xMax - xMin) * i / GRID;
                    lineX.push(xv); lineY.push((d - aa * xv) / bb);
                }
            } else {
                // x = (d - bb*y) / aa
                for (var j = 0; j <= GRID; j++) {
                    var yv = yMin + (yMax - yMin) * j / GRID;
                    lineX.push((d - bb * yv) / aa); lineY.push(yv);
                }
            }
            // Build 2D z-matrix: same (x,y) line repeated at z values from zMin..zMax
            var Z = [], Xs = [], Ys = [];
            for (var k = 0; k <= GRID; k++) {
                var zVal = zMin + (zMax - zMin) * k / GRID;
                Z.push(lineX.map(function() { return zVal; }));
            }
            return {
                type: 'surface',
                x: lineX, y: lineY, z: Z,
                colorscale: [[0, rowColor], [1, rowColor]],
                showscale: false, opacity: 0.5,
                name: label, hovertext: label,
                contours: { z: { show: false } }
            };
        }

        // Generic plane: z = (d - aa*x - bb*y) / cc
        var zMatrix = [];
        for (var i = 0; i <= GRID; i++) {
            var row = [];
            for (var j = 0; j <= GRID; j++) {
                row.push((d - aa * xs[j] - bb * ys[i]) / cc);
            }
            zMatrix.push(row);
        }
        return {
            type: 'surface',
            x: xs, y: ys, z: zMatrix,
            colorscale: [[0, rowColor], [1, rowColor]],
            showscale: false, opacity: 0.5,
            name: label, hovertext: label,
            contours: { z: { show: false } }
        };
    }

    var planeColors = [colors.line1, colors.line2, colors.line3];
    var traces = [];
    for (var p = 0; p < 3; p++) {
        traces.push(buildPlane(A[p], b[p], planeColors[p], _eqLabel3(A[p][0], A[p][1], A[p][2], b[p])));
    }

    // Intersection point (if it exists and is finite).
    if (hasSol) {
        traces.push({
            type: 'scatter3d', mode: 'markers+text',
            x: [solution[0]], y: [solution[1]], z: [solution[2]],
            marker: { color: colors.intersection, size: 6, symbol: 'diamond' },
            text: ['(' + solution.map(function(v) {
                return Math.abs(v - Math.round(v)) < 1e-9 ? Math.round(v) : parseFloat(v.toFixed(4));
            }).join(', ') + ')'],
            textposition: 'top center',
            textfont: { color: colors.text, size: 11 },
            name: 'Solution',
            hoverinfo: 'name+x+y+z'
        });
    }

    var layout = {
        paper_bgcolor: colors.paper,
        scene: {
            xaxis: { title: vars[0], backgroundcolor: colors.bg, gridcolor: colors.grid, zerolinecolor: colors.zeroline, color: colors.text, range: [xMin, xMax] },
            yaxis: { title: vars[1], backgroundcolor: colors.bg, gridcolor: colors.grid, zerolinecolor: colors.zeroline, color: colors.text, range: [yMin, yMax] },
            zaxis: { title: vars[2], backgroundcolor: colors.bg, gridcolor: colors.grid, zerolinecolor: colors.zeroline, color: colors.text, range: [zMin, zMax] },
            bgcolor: colors.bg,
            camera: { eye: { x: 1.4, y: 1.4, z: 1.0 } }
        },
        font: { family: 'Inter, system-ui, sans-serif', color: colors.text, size: 12 },
        showlegend: true,
        legend: { x: 0, y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11 } },
        margin: { t: 20, r: 10, b: 10, l: 10 }
    };

    container.innerHTML = '';
    window.Plotly.newPlot(container, traces, layout, {
        responsive: true, displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d'],
        displaylogo: false
    });
}

// ==================== Exports ====================

window.SystemsSolverGraph = {
    draw2x2: draw2x2,
    draw3x3: draw3x3,
    drawNonlinear2: drawNonlinear2,
    clear: clear
};

})();
