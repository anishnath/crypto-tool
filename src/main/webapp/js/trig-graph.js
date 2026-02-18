/**
 * Trigonometry Calculator - Graph Module
 * Unit circle and function plot visualization with Plotly
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
        primaryColor: '#7c3aed',
        secondaryColor: '#a78bfa',
        angleColor: '#f59e0b',
        refAngleColor: '#10b981',
        pointColor: '#ef4444',
        solutionColor: '#0ea5e9',
        shadeColor: 'rgba(124, 58, 237, 0.1)'
    };
}

// ==================== Unit Circle ====================

function renderUnitCircle(containerId, options) {
    loadPlotly(function() {
        _drawUnitCircle(containerId, options || {});
    });
}

function _drawUnitCircle(containerId, opts) {
    var container = document.getElementById(containerId);
    if (!container || !window.Plotly) return;

    var colors = getPlotColors();
    var traces = [];

    // Unit circle
    var circleX = [], circleY = [];
    for (var i = 0; i <= 360; i++) {
        var rad = i * Math.PI / 180;
        circleX.push(Math.cos(rad));
        circleY.push(Math.sin(rad));
    }
    traces.push({
        x: circleX, y: circleY,
        mode: 'lines',
        line: { color: colors.gridColor, width: 1.5 },
        showlegend: false, hoverinfo: 'skip'
    });

    // Axes
    traces.push({
        x: [-1.3, 1.3], y: [0, 0],
        mode: 'lines', line: { color: colors.gridColor, width: 0.8 },
        showlegend: false, hoverinfo: 'skip'
    });
    traces.push({
        x: [0, 0], y: [-1.3, 1.3],
        mode: 'lines', line: { color: colors.gridColor, width: 0.8 },
        showlegend: false, hoverinfo: 'skip'
    });

    // Angle rays
    var angles = opts.angles || [];
    for (var a = 0; a < angles.length; a++) {
        var angleDeg = angles[a];
        var angleRad = angleDeg * Math.PI / 180;
        var cx = Math.cos(angleRad);
        var cy = Math.sin(angleRad);

        // Ray from origin to point
        traces.push({
            x: [0, cx], y: [0, cy],
            mode: 'lines',
            line: { color: colors.primaryColor, width: 2.5 },
            showlegend: false, hoverinfo: 'skip'
        });

        // Terminal point
        traces.push({
            x: [cx], y: [cy],
            mode: 'markers',
            marker: { color: colors.pointColor, size: 10, line: { color: '#fff', width: 2 } },
            showlegend: false,
            text: ['(' + cx.toFixed(3) + ', ' + cy.toFixed(3) + ')'],
            hoverinfo: 'text'
        });

        // Angle arc
        var arcX = [], arcY = [];
        var arcR = 0.25;
        var arcEnd = angleDeg > 0 ? angleDeg : angleDeg + 360;
        for (var d = 0; d <= arcEnd; d += 2) {
            var ar = d * Math.PI / 180;
            arcX.push(arcR * Math.cos(ar));
            arcY.push(arcR * Math.sin(ar));
        }
        traces.push({
            x: arcX, y: arcY,
            mode: 'lines',
            line: { color: colors.angleColor, width: 2 },
            showlegend: false, hoverinfo: 'skip'
        });

        // Dashed lines to axes
        traces.push({
            x: [cx, cx], y: [0, cy],
            mode: 'lines', line: { color: colors.primaryColor, width: 1, dash: 'dash' },
            showlegend: false, hoverinfo: 'skip'
        });
        traces.push({
            x: [0, cx], y: [cy, cy],
            mode: 'lines', line: { color: colors.primaryColor, width: 1, dash: 'dash' },
            showlegend: false, hoverinfo: 'skip'
        });
    }

    // Reference angle arc (if specified)
    if (opts.showRefAngle && angles.length > 0) {
        var mainAngle = angles[0];
        var refAngle = window.TrigCommon ? window.TrigCommon.getReferenceAngle(mainAngle) : 0;
        var norm = window.TrigCommon ? window.TrigCommon.normalizeAngleDeg(mainAngle) : mainAngle;

        if (refAngle > 0 && refAngle < 90) {
            var refStart = 0, refEnd = refAngle;
            if (norm > 90 && norm <= 180) { refStart = 180 - refAngle; refEnd = 180; }
            else if (norm > 180 && norm <= 270) { refStart = 180; refEnd = 180 + refAngle; }
            else if (norm > 270 && norm < 360) { refStart = 360 - refAngle; refEnd = 360; }

            var refArcX = [], refArcY = [];
            var refR = 0.18;
            for (var rd = refStart; rd <= refEnd; rd += 1) {
                var rr = rd * Math.PI / 180;
                refArcX.push(refR * Math.cos(rr));
                refArcY.push(refR * Math.sin(rr));
            }
            traces.push({
                x: refArcX, y: refArcY,
                mode: 'lines',
                line: { color: colors.refAngleColor, width: 2.5 },
                showlegend: false, hoverinfo: 'skip'
            });
        }
    }

    // Coterminal angles
    if (opts.showCoterminals && opts.coterminals) {
        for (var ci = 0; ci < opts.coterminals.length; ci++) {
            var cAngle = opts.coterminals[ci];
            var cRad = cAngle * Math.PI / 180;
            // Just mark the same point with a ring
            traces.push({
                x: [Math.cos(cRad)], y: [Math.sin(cRad)],
                mode: 'markers',
                marker: { color: 'rgba(0,0,0,0)', size: 16, line: { color: colors.solutionColor, width: 2 } },
                showlegend: false, hoverinfo: 'skip'
            });
        }
    }

    // Quadrant highlight
    if (opts.highlightQuadrant) {
        var q = opts.highlightQuadrant;
        var shapeX0 = (q === 1 || q === 4) ? 0 : -1.2;
        var shapeX1 = (q === 1 || q === 4) ? 1.2 : 0;
        var shapeY0 = (q === 1 || q === 2) ? 0 : -1.2;
        var shapeY1 = (q === 1 || q === 2) ? 1.2 : 0;

        traces.push({
            x: [shapeX0, shapeX1, shapeX1, shapeX0, shapeX0],
            y: [shapeY0, shapeY0, shapeY1, shapeY1, shapeY0],
            fill: 'toself',
            fillcolor: colors.shadeColor,
            mode: 'lines',
            line: { color: 'transparent' },
            showlegend: false, hoverinfo: 'skip'
        });
    }

    var layout = {
        xaxis: { range: [-1.4, 1.4], zeroline: false, showgrid: false, showticklabels: true, tickfont: { size: 10, color: colors.textColor }, dtick: 0.5, scaleanchor: 'y' },
        yaxis: { range: [-1.4, 1.4], zeroline: false, showgrid: false, showticklabels: true, tickfont: { size: 10, color: colors.textColor }, dtick: 0.5 },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        margin: { l: 40, r: 20, t: 20, b: 40 },
        showlegend: false
    };

    Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
}

// ==================== Function Plot ====================

function renderFunctionPlot(containerId, options) {
    loadPlotly(function() {
        _drawFunctionPlot(containerId, options || {});
    });
}

function _drawFunctionPlot(containerId, opts) {
    var container = document.getElementById(containerId);
    if (!container || !window.Plotly) return;

    var colors = getPlotColors();
    var traces = [];

    // Main functions
    var funcs = opts.functions || [];
    var funcColors = [colors.primaryColor, colors.secondaryColor, '#f59e0b', '#10b981'];

    var xMin = opts.xMin != null ? opts.xMin : -2 * Math.PI;
    var xMax = opts.xMax != null ? opts.xMax : 2 * Math.PI;
    var nPts = 500;
    var step = (xMax - xMin) / nPts;
    var xs = [];
    for (var i = 0; i <= nPts; i++) { xs.push(xMin + step * i); }

    for (var f = 0; f < funcs.length; f++) {
        var fn = funcs[f];
        var ys = [];
        for (var j = 0; j < xs.length; j++) {
            var y = evalTrigExpr(fn.expr, xs[j]);
            ys.push(y);
        }
        traces.push({
            x: xs, y: ys,
            mode: 'lines',
            name: fn.label || fn.expr,
            line: { color: funcColors[f % funcColors.length], width: 2.5 }
        });
    }

    // Solution points
    if (opts.solutions) {
        var solX = [], solY = [], solText = [];
        for (var s = 0; s < opts.solutions.length; s++) {
            var sol = opts.solutions[s];
            solX.push(sol.x);
            solY.push(sol.y != null ? sol.y : 0);
            solText.push(sol.label || 'x = ' + sol.x.toFixed(4));
        }
        if (solX.length > 0) {
            traces.push({
                x: solX, y: solY,
                mode: 'markers',
                name: 'Solutions',
                marker: { color: colors.pointColor, size: 9, line: { color: '#fff', width: 2 } },
                text: solText,
                hoverinfo: 'text'
            });
        }
    }

    // Overlay functions (e.g., y=k line)
    if (opts.overlayFunctions) {
        for (var oi = 0; oi < opts.overlayFunctions.length; oi++) {
            var ofn = opts.overlayFunctions[oi];
            var oYs = [];
            for (var ok = 0; ok < xs.length; ok++) {
                oYs.push(evalTrigExpr(ofn.expr, xs[ok]));
            }
            traces.push({
                x: xs, y: oYs,
                mode: 'lines',
                name: ofn.label || ofn.expr,
                line: { color: colors.solutionColor, width: 1.5, dash: 'dash' }
            });
        }
    }

    // Shade region (for inequalities)
    if (opts.shadeRegion) {
        var sr = opts.shadeRegion;
        var shadeXs = [], shadeYs = [];
        for (var si = 0; si < xs.length; si++) {
            var sy = evalTrigExpr(sr.expr, xs[si]);
            if (sy != null && isFinite(sy) && sr.test(xs[si], sy)) {
                shadeXs.push(xs[si]);
                shadeYs.push(sy);
            }
        }
        if (shadeXs.length > 0) {
            traces.push({
                x: shadeXs, y: shadeYs,
                fill: 'tozeroy',
                fillcolor: colors.shadeColor,
                mode: 'lines',
                line: { color: 'transparent' },
                showlegend: false, hoverinfo: 'skip'
            });
        }
    }

    // π tick labels
    var tickVals = [];
    var tickText = [];
    for (var t = Math.ceil(xMin / Math.PI); t <= Math.floor(xMax / Math.PI); t++) {
        tickVals.push(t * Math.PI);
        if (t === 0) tickText.push('0');
        else if (t === 1) tickText.push('π');
        else if (t === -1) tickText.push('-π');
        else tickText.push(t + 'π');
    }
    // Half-pi ticks
    for (var h = Math.ceil(xMin / (Math.PI / 2)); h <= Math.floor(xMax / (Math.PI / 2)); h++) {
        var hv = h * Math.PI / 2;
        if (tickVals.indexOf(hv) === -1) {
            tickVals.push(hv);
            if (h === 1) tickText.push('π/2');
            else if (h === -1) tickText.push('-π/2');
            else if (h % 2 !== 0) tickText.push(h + 'π/2');
        }
    }

    var layout = {
        xaxis: { range: [xMin, xMax], tickvals: tickVals, ticktext: tickText, gridcolor: colors.gridColor, tickfont: { size: 10, color: colors.textColor }, zeroline: true, zerolinecolor: colors.gridColor },
        yaxis: { range: [opts.yMin || -2.5, opts.yMax || 2.5], gridcolor: colors.gridColor, tickfont: { size: 10, color: colors.textColor }, zeroline: true, zerolinecolor: colors.gridColor },
        plot_bgcolor: colors.bg,
        paper_bgcolor: colors.paper,
        margin: { l: 40, r: 20, t: 20, b: 40 },
        legend: { x: 0, y: 1.1, orientation: 'h', font: { size: 11, color: colors.textColor } }
    };

    Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: false });
}

// ==================== Safe Trig Expression Evaluator ====================

function evalTrigExpr(expr, x) {
    try {
        // Try nerdamer first if available
        if (typeof nerdamer !== 'undefined') {
            var val = nerdamer(expr).evaluate({ x: x });
            var num = parseFloat(val.text('decimals'));
            if (isFinite(num) && Math.abs(num) < 1000) return num;
        }
    } catch (e) { /* fallback */ }

    // Simple evaluator for common trig expressions
    try {
        var fn = expr.replace(/\bsin\b/g, 'Math.sin')
                     .replace(/\bcos\b/g, 'Math.cos')
                     .replace(/\btan\b/g, 'Math.tan')
                     .replace(/\bcsc\b/g, '(1/Math.sin')
                     .replace(/\bsec\b/g, '(1/Math.cos')
                     .replace(/\bcot\b/g, '(1/Math.tan')
                     .replace(/\bpi\b/gi, 'Math.PI')
                     .replace(/\bsqrt\b/g, 'Math.sqrt')
                     .replace(/\babs\b/g, 'Math.abs')
                     .replace(/\^/g, '**');
        /* eslint-disable no-new-func */
        var result = new Function('x', 'return ' + fn + ';')(x);
        if (isFinite(result) && Math.abs(result) < 1000) return result;
    } catch (e) { /* ignore */ }

    return null;
}

// ==================== Export Namespace ====================

window.TrigGraph = {
    loadPlotly: loadPlotly,
    isDarkMode: isDarkMode,
    getPlotColors: getPlotColors,
    renderUnitCircle: renderUnitCircle,
    renderFunctionPlot: renderFunctionPlot,
    evalTrigExpr: evalTrigExpr
};

})();
