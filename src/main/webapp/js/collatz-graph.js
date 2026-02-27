/**
 * Collatz Conjecture - Plotly Graph Module
 * Lazy-loaded line chart of sequence values vs step number
 */
(function() {
'use strict';

var __plotlyLoaded = false;

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

function renderSequenceChart(containerId, sequence) {
    var container = document.getElementById(containerId);
    if (!container) return;

    loadPlotly(function() {
        if (!window.Plotly) return;

        var colors = getPlotColors();

        var steps = [];
        var values = [];
        for (var i = 0; i < sequence.length; i++) {
            steps.push(i);
            values.push(sequence[i]);
        }

        // Find peak for annotation
        var peakVal = 0;
        var peakIdx = 0;
        for (var j = 0; j < sequence.length; j++) {
            if (sequence[j] > peakVal) {
                peakVal = sequence[j];
                peakIdx = j;
            }
        }

        // Use log scale for large peak values
        var useLog = peakVal > 1000;

        var trace = {
            x: steps,
            y: values,
            type: 'scatter',
            mode: 'lines',
            line: { color: colors.lineColor, width: 2 },
            fill: 'tozeroy',
            fillcolor: colors.fillColor,
            name: 'Sequence',
            hovertemplate: 'Step %{x}<br>Value: %{y:,.0f}<extra></extra>'
        };

        // Peak marker
        var peakMarker = {
            x: [peakIdx],
            y: [peakVal],
            type: 'scatter',
            mode: 'markers',
            marker: { color: colors.peakColor, size: 10, symbol: 'diamond' },
            name: 'Peak (' + peakVal.toLocaleString() + ')',
            hovertemplate: 'Peak at step %{x}<br>Value: %{y:,.0f}<extra></extra>'
        };

        // End marker (1)
        var endMarker = {
            x: [sequence.length - 1],
            y: [1],
            type: 'scatter',
            mode: 'markers',
            marker: { color: colors.endColor, size: 10, symbol: 'circle' },
            name: 'Reached 1',
            hovertemplate: 'Reached 1 at step %{x}<extra></extra>'
        };

        var layout = {
            title: {
                text: 'Collatz Sequence: ' + sequence[0].toLocaleString() + ' to 1',
                font: { size: 14, color: colors.textColor }
            },
            xaxis: {
                title: { text: 'Step Number', font: { size: 12 } },
                gridcolor: colors.gridColor,
                color: colors.textColor,
                zeroline: false
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
            showlegend: true,
            legend: {
                x: 1,
                xanchor: 'right',
                y: 1,
                bgcolor: 'rgba(0,0,0,0)',
                font: { size: 11 }
            },
            hovermode: 'x unified'
        };

        var config = {
            responsive: true,
            displayModeBar: false,
            staticPlot: false
        };

        Plotly.newPlot(container, [trace, peakMarker, endMarker], layout, config);
    });
}

function destroyChart(containerId) {
    var container = document.getElementById(containerId);
    if (container && window.Plotly) {
        try { Plotly.purge(container); } catch (e) {}
    }
}

window.CollatzGraph = {
    loadPlotly: loadPlotly,
    renderSequenceChart: renderSequenceChart,
    destroyChart: destroyChart,
    isDarkMode: isDarkMode
};

})();
