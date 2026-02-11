/**
 * Visual Math — Statistics Dashboard (Box Plot & Histogram)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;
    var data = [];
    var stats = null;

    function statisticsViz(p, container) {
        state = VisualMath.getState();
        var W, H;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (data.length > 0 && stats) {
                var vizType = state.vizType || 'box';
                if (vizType === 'box') {
                    drawBoxPlot(C);
                } else if (vizType === 'histogram') {
                    drawHistogram(C);
                } else if (vizType === 'both') {
                    drawBoth(C);
                }
            } else {
                drawPlaceholder(C);
            }

            p.noLoop();
        };

        function drawPlaceholder(C) {
            p.fill(C.muted);
            p.noStroke();
            p.textSize(16);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('Enter data and click Calculate', W / 2, H / 2);
        }

        function drawBoxPlot(C) {
            var pad = 60;
            var boxY = H / 2;
            var boxH = 60;
            var plotW = W - pad * 2;

            var min = stats.min;
            var max = stats.max;
            var range = max - min;

            function xPos(val) {
                return pad + ((val - min) / range) * plotW;
            }

            // Draw axis
            p.stroke(C.axis);
            p.strokeWeight(2);
            p.line(pad, boxY + boxH / 2, W - pad, boxY + boxH / 2);

            // Draw whiskers
            p.stroke(C.muted);
            p.strokeWeight(2);
            p.line(xPos(stats.min), boxY, xPos(stats.min), boxY + boxH);
            p.line(xPos(stats.max), boxY, xPos(stats.max), boxY + boxH);
            p.line(xPos(stats.min), boxY + boxH / 2, xPos(stats.q1), boxY + boxH / 2);
            p.line(xPos(stats.q3), boxY + boxH / 2, xPos(stats.max), boxY + boxH / 2);

            // Draw box
            var boxX = xPos(stats.q1);
            var boxWidth = xPos(stats.q3) - boxX;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.rect(boxX, boxY, boxWidth, boxH);

            // Draw median line
            p.stroke(C.sin);
            p.strokeWeight(3);
            p.line(xPos(stats.median), boxY, xPos(stats.median), boxY + boxH);

            // Draw outliers
            if (stats.outliers.length > 0) {
                p.fill(C.sin);
                p.noStroke();
                stats.outliers.forEach(function (outlier) {
                    p.ellipse(xPos(outlier), boxY + boxH / 2, 8, 8);
                });
            }

            // Labels
            if (state.showLabels !== false) {
                p.fill(C.text);
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER, p.TOP);
                p.text('Min\n' + stats.min.toFixed(1), xPos(stats.min), boxY + boxH + 5);
                p.text('Q1\n' + stats.q1.toFixed(1), xPos(stats.q1), boxY + boxH + 5);
                p.text('Median\n' + stats.median.toFixed(1), xPos(stats.median), boxY + boxH + 5);
                p.text('Q3\n' + stats.q3.toFixed(1), xPos(stats.q3), boxY + boxH + 5);
                p.text('Max\n' + stats.max.toFixed(1), xPos(stats.max), boxY + boxH + 5);

                // Title
                p.textSize(14);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text('Box Plot', W / 2, boxY - 10);
            }
        }

        function drawHistogram(C) {
            var pad = 50;
            var plotW = W - pad * 2;
            var plotH = H - pad * 2;

            var bins = state.bins || 10;
            var min = stats.min;
            var max = stats.max;
            var binWidth = (max - min) / bins;

            // Create histogram bins
            var histogram = new Array(bins).fill(0);
            data.forEach(function (val) {
                var binIndex = Math.min(Math.floor((val - min) / binWidth), bins - 1);
                histogram[binIndex]++;
            });

            var maxFreq = Math.max.apply(null, histogram);

            // Draw axes
            p.stroke(C.axis);
            p.strokeWeight(2);
            p.line(pad, pad, pad, pad + plotH);
            p.line(pad, pad + plotH, pad + plotW, pad + plotH);

            // Draw bars
            var barWidth = plotW / bins;
            histogram.forEach(function (freq, i) {
                var barH = (freq / maxFreq) * plotH;
                var x = pad + i * barWidth;
                var y = pad + plotH - barH;

                p.fill(C.accent[0], C.accent[1], C.accent[2], 120);
                p.stroke(C.accent);
                p.strokeWeight(1.5);
                p.rect(x, y, barWidth - 2, barH);
            });

            // Labels
            if (state.showLabels !== false) {
                p.fill(C.text);
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER, p.TOP);

                // X-axis labels
                for (var i = 0; i <= bins; i += Math.ceil(bins / 5)) {
                    var val = min + i * binWidth;
                    var x = pad + i * barWidth;
                    p.text(val.toFixed(1), x, pad + plotH + 5);
                }

                // Y-axis labels
                p.textAlign(p.RIGHT, p.CENTER);
                for (var j = 0; j <= 5; j++) {
                    var freq = Math.round((maxFreq / 5) * j);
                    var y = pad + plotH - (plotH / 5) * j;
                    p.text(freq, pad - 10, y);
                }

                // Title
                p.textSize(14);
                p.textAlign(p.CENTER, p.TOP);
                p.text('Histogram', W / 2, 10);

                // Axis labels
                p.textSize(12);
                p.text('Value', W / 2, pad + plotH + 25);
                p.push();
                p.translate(15, H / 2);
                p.rotate(-Math.PI / 2);
                p.text('Frequency', 0, 0);
                p.pop();
            }
        }

        function drawBoth(C) {
            var pad = 40;
            var topH = H * 0.55;
            var bottomY = H * 0.6;
            var bottomH = H * 0.35;

            // Draw histogram on top
            var bins = state.bins || 10;
            var min = stats.min;
            var max = stats.max;
            var binWidth = (max - min) / bins;

            var histogram = new Array(bins).fill(0);
            data.forEach(function (val) {
                var binIndex = Math.min(Math.floor((val - min) / binWidth), bins - 1);
                histogram[binIndex]++;
            });

            var maxFreq = Math.max.apply(null, histogram);
            var plotW = W - pad * 2;
            var barWidth = plotW / bins;

            histogram.forEach(function (freq, i) {
                var barH = (freq / maxFreq) * (topH - 30);
                var x = pad + i * barWidth;
                var y = topH - barH;

                p.fill(C.accent[0], C.accent[1], C.accent[2], 100);
                p.stroke(C.accent);
                p.strokeWeight(1.5);
                p.rect(x, y, barWidth - 2, barH);
            });

            // Draw box plot on bottom
            var boxY = bottomY;
            var boxH = 40;

            function xPos(val) {
                return pad + ((val - min) / (max - min)) * plotW;
            }

            p.stroke(C.muted);
            p.strokeWeight(2);
            p.line(xPos(stats.min), boxY, xPos(stats.min), boxY + boxH);
            p.line(xPos(stats.max), boxY, xPos(stats.max), boxY + boxH);
            p.line(xPos(stats.min), boxY + boxH / 2, xPos(stats.q1), boxY + boxH / 2);
            p.line(xPos(stats.q3), boxY + boxH / 2, xPos(stats.max), boxY + boxH / 2);

            var boxX = xPos(stats.q1);
            var boxWidth = xPos(stats.q3) - boxX;
            p.fill(C.sin[0], C.sin[1], C.sin[2], 40);
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.rect(boxX, boxY, boxWidth, boxH);

            p.stroke(C.sin);
            p.strokeWeight(3);
            p.line(xPos(stats.median), boxY, xPos(stats.median), boxY + boxH);

            // Labels
            p.fill(C.text);
            p.noStroke();
            p.textSize(12);
            p.textAlign(p.CENTER, p.TOP);
            p.text('Histogram & Box Plot', W / 2, 5);
        }

        // External API
        state._redraw = function () { p.loop(); };
        state._setData = function (newData) {
            data = newData.slice().sort((a, b) => a - b);
            stats = calculateStats(data);
            updateDisplay();
            p.loop();
        };

        function calculateStats(arr) {
            var n = arr.length;
            var min = arr[0];
            var max = arr[n - 1];
            var sum = arr.reduce((a, b) => a + b, 0);
            var mean = sum / n;

            // Quartiles
            var q1 = percentile(arr, 25);
            var median = percentile(arr, 50);
            var q3 = percentile(arr, 75);
            var iqr = q3 - q1;

            // Outliers
            var lowerFence = q1 - 1.5 * iqr;
            var upperFence = q3 + 1.5 * iqr;
            var outliers = arr.filter(x => x < lowerFence || x > upperFence);

            return {
                count: n,
                min: min,
                max: max,
                mean: mean,
                median: median,
                q1: q1,
                q3: q3,
                iqr: iqr,
                outliers: outliers
            };
        }

        function percentile(arr, p) {
            var index = (p / 100) * (arr.length - 1);
            var lower = Math.floor(index);
            var upper = Math.ceil(index);
            var weight = index - lower;
            return arr[lower] * (1 - weight) + arr[upper] * weight;
        }

        function updateDisplay() {
            setEl('val-count', stats.count);
            setEl('val-min', stats.min.toFixed(2));
            setEl('val-q1', stats.q1.toFixed(2));
            setEl('val-median', stats.median.toFixed(2));
            setEl('val-q3', stats.q3.toFixed(2));
            setEl('val-max', stats.max.toFixed(2));
            setEl('val-mean', stats.mean.toFixed(2));
            setEl('val-iqr', stats.iqr.toFixed(2));
            setEl('val-outliers', stats.outliers.length > 0 ? stats.outliers.map(x => x.toFixed(1)).join(', ') : 'None');
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }
    }

    VisualMath.register('statistics', statisticsViz);
})();
