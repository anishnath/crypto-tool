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
        intersection:'#f59e0b'    // Amber for intersection point
    };
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

// ==================== Exports ====================

window.SystemsSolverGraph = {
    draw2x2: draw2x2,
    drawNonlinear2: drawNonlinear2,
    clear: clear
};

})();
