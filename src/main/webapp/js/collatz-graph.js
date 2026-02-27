/**
 * Collatz Conjecture - Plotly Graph Module
 * Live-updating line chart that grows as each number is added
 */
(function() {
'use strict';

var __plotlyLoaded = false;
var __initDone = false;   // has Plotly.newPlot been called for current run?
var __containerId = '';

function loadPlotly(cb) {
    if (__plotlyLoaded) { if (cb) cb(); return; }
    if (window.Plotly) { __plotlyLoaded = true; if (cb) cb(); return; }
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
        lineColor: '#ea580c',
        fillColor: dark ? 'rgba(234, 88, 12, 0.15)' : 'rgba(234, 88, 12, 0.1)',
        peakColor: '#f59e0b',
        endColor: '#22c55e'
    };
}

// ==================== Live chart API ====================

/**
 * Initialise an empty Plotly chart, ready for live data.
 * Call once when animation starts.
 */
function initLiveChart(containerId, startNumber, totalSteps, peakValue) {
    __containerId = containerId;
    __initDone = false;

    var container = document.getElementById(containerId);
    if (!container) return;

    loadPlotly(function() {
        if (!window.Plotly) return;

        var colors = getPlotColors();
        var useLog = peakValue > 1000;

        // Main line trace (starts empty, will grow)
        var trace = {
            x: [],
            y: [],
            type: 'scatter',
            mode: 'lines',
            line: { color: colors.lineColor, width: 2, shape: 'linear' },
            fill: 'tozeroy',
            fillcolor: colors.fillColor,
            name: 'Sequence',
            hovertemplate: 'Step %{x}<br>Value: %{y:,.0f}<extra></extra>'
        };

        // Current-point marker (will be updated each step)
        var cursorTrace = {
            x: [],
            y: [],
            type: 'scatter',
            mode: 'markers',
            marker: { color: colors.lineColor, size: 8 },
            name: 'Current',
            showlegend: false,
            hoverinfo: 'skip'
        };

        var layout = {
            title: {
                text: 'Collatz Sequence: ' + startNumber.toLocaleString(),
                font: { size: 14, color: colors.textColor }
            },
            xaxis: {
                title: { text: 'Step', font: { size: 12 } },
                gridcolor: colors.gridColor,
                color: colors.textColor,
                zeroline: false,
                range: [0, Math.min(totalSteps, 50)]   // start with visible window
            },
            yaxis: {
                title: { text: 'Value', font: { size: 12 } },
                type: useLog ? 'log' : 'linear',
                gridcolor: colors.gridColor,
                color: colors.textColor,
                zeroline: false
            },
            plot_bgcolor: colors.bg,
            paper_bgcolor: colors.paper,
            font: { color: colors.textColor },
            margin: { t: 40, r: 20, b: 50, l: 60 },
            showlegend: false,
            hovermode: 'x unified'
        };

        var config = {
            responsive: true,
            displayModeBar: false,
            staticPlot: false
        };

        Plotly.newPlot(container, [trace, cursorTrace], layout, config);
        __initDone = true;
    });
}

/**
 * Add one data point to the live chart.
 * Called on each animation step.
 */
function addPoint(step, value, totalSteps) {
    if (!__initDone || !window.Plotly) return;
    var container = document.getElementById(__containerId);
    if (!container) return;

    // Extend main trace
    Plotly.extendTraces(container, { x: [[step]], y: [[value]] }, [0]);

    // Move cursor marker
    Plotly.restyle(container, { x: [[step]], y: [[value]] }, [1]);

    // Auto-scroll x-axis if we passed the initial window
    var xEnd = container.layout && container.layout.xaxis && container.layout.xaxis.range
        ? container.layout.xaxis.range[1] : 50;
    if (step > xEnd - 5) {
        var newEnd = Math.min(step + 20, totalSteps + 5);
        Plotly.relayout(container, { 'xaxis.range': [0, newEnd] });
    }
}

/**
 * Finalise chart after animation: add peak diamond + end circle markers,
 * set full x-axis range, update title.
 */
function finaliseChart(sequence) {
    if (!__initDone || !window.Plotly) return;
    var container = document.getElementById(__containerId);
    if (!container) return;

    var colors = getPlotColors();

    // Find peak
    var peakVal = 0, peakIdx = 0;
    for (var j = 0; j < sequence.length; j++) {
        if (sequence[j] > peakVal) { peakVal = sequence[j]; peakIdx = j; }
    }

    // Remove cursor trace, add peak + end markers
    var peakMarker = {
        x: [peakIdx],
        y: [peakVal],
        type: 'scatter',
        mode: 'markers',
        marker: { color: colors.peakColor, size: 10, symbol: 'diamond' },
        name: 'Peak (' + peakVal.toLocaleString() + ')',
        hovertemplate: 'Peak at step %{x}<br>Value: %{y:,.0f}<extra></extra>'
    };

    var endMarker = {
        x: [sequence.length - 1],
        y: [1],
        type: 'scatter',
        mode: 'markers',
        marker: { color: colors.endColor, size: 10, symbol: 'circle' },
        name: 'Reached 1',
        hovertemplate: 'Reached 1 at step %{x}<extra></extra>'
    };

    // Delete cursor trace (index 1), then add the two markers
    Plotly.deleteTraces(container, 1);
    Plotly.addTraces(container, [peakMarker, endMarker]);

    // Show full range + legend + update title
    Plotly.relayout(container, {
        'xaxis.range': [0, sequence.length + 2],
        'title.text': 'Collatz Sequence: ' + sequence[0].toLocaleString() + ' \u2192 1 (' + (sequence.length - 1) + ' steps)',
        showlegend: true
    });
}

function destroyChart(containerId) {
    __initDone = false;
    var container = document.getElementById(containerId);
    if (container && window.Plotly) {
        try { Plotly.purge(container); } catch (e) {}
    }
}

window.CollatzGraph = {
    loadPlotly: loadPlotly,
    initLiveChart: initLiveChart,
    addPoint: addPoint,
    finaliseChart: finaliseChart,
    destroyChart: destroyChart,
    isDarkMode: isDarkMode
};

})();
