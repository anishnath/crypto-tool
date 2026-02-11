/**
 * Visual Math — Central Limit Theorem
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;
    var means = [];

    function boxMuller() {
        var u1 = Math.random(), u2 = Math.random();
        return Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
    }

    function gaussPDF(x, mu, sigma) {
        var z = (x - mu) / sigma;
        return Math.exp(-0.5 * z * z) / (sigma * Math.sqrt(2 * Math.PI));
    }

    var DISTS = {
        'uniform': {
            label: 'Uniform [0, 10]',
            mu: 5, sigma: Math.sqrt(100 / 12),
            range: [0, 10],
            sample: function() { return Math.random() * 10; },
            pdf: function(x) { return (x >= 0 && x <= 10) ? 0.1 : 0; }
        },
        'exponential': {
            label: 'Exponential (\u03BB=1)',
            mu: 1, sigma: 1,
            range: [0, 6],
            sample: function() { return -Math.log(1 - Math.random()); },
            pdf: function(x) { return x >= 0 ? Math.exp(-x) : 0; }
        },
        'bimodal': {
            label: 'Bimodal',
            mu: 5, sigma: Math.sqrt(5),
            range: [-1, 11],
            sample: function() {
                return Math.random() < 0.5 ? 3 + boxMuller() : 7 + boxMuller();
            },
            pdf: function(x) {
                return 0.5 * gaussPDF(x, 3, 1) + 0.5 * gaussPDF(x, 7, 1);
            }
        },
        'dice': {
            label: 'Dice (1\u20136)',
            mu: 3.5, sigma: Math.sqrt(35 / 12),
            range: [0.5, 6.5],
            discrete: true,
            sample: function() { return Math.floor(Math.random() * 6) + 1; },
            pdf: function(x) {
                var ix = Math.round(x);
                return (ix >= 1 && ix <= 6 && Math.abs(x - ix) < 0.01) ? 1 / 6 : 0;
            }
        }
    };

    function clt(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20;

        if (!state.dist) state.dist = 'uniform';
        if (!state.n) state.n = 5;
        state.running = false;
        means = [];

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(520, W * 0.6));
        }

        p.setup = function() {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function() {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);
            var d = DISTS[state.dist];
            var gw = W - padL - padR;

            // Top section: Population distribution (30%)
            var topH = H * 0.28;
            var topY = 10;
            drawPopulation(d, C, padL, topY, gw, topH);

            // Bottom section: Sampling distribution (58%)
            var botH = H * 0.55;
            var botY = topY + topH + H * 0.06;
            drawSampling(d, C, padL, botY, gw, botH);

            // Add samples if running
            if (state.running) {
                var batch = means.length < 200 ? 5 : 15;
                for (var b = 0; b < batch; b++) {
                    if (means.length >= 5000) { state.running = false; break; }
                    var sum = 0;
                    for (var i = 0; i < state.n; i++) sum += d.sample();
                    means.push(sum / state.n);
                }
                syncStats(d);
            }

            if (!state.running) p.noLoop();
        };

        function drawPopulation(d, C, x, y, w, h) {
            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Population: ' + d.label, x, y);
            p.fill(C.muted); p.textSize(10);
            p.text('\u03BC=' + d.mu.toFixed(2) + '  \u03C3=' + d.sigma.toFixed(2), x + w - 120, y);

            var plotY = y + 18;
            var plotH = h - 22;
            var r = d.range;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(x, plotY + plotH, x + w, plotY + plotH);
            p.line(x, plotY, x, plotY + plotH);

            // PDF curve or bars
            if (d.discrete) {
                var barW = w / (r[1] - r[0]) * 0.6;
                p.fill(C.accent[0], C.accent[1], C.accent[2], 80);
                p.stroke(C.accent); p.strokeWeight(1);
                for (var v = 1; v <= 6; v++) {
                    var bx = x + ((v - r[0]) / (r[1] - r[0])) * w;
                    var bh = (1 / 6) / 0.2 * plotH;
                    bh = Math.min(bh, plotH);
                    p.rect(bx - barW / 2, plotY + plotH - bh, barW, bh);
                }
            } else {
                // Find max PDF for scaling
                var maxPDF = 0;
                for (var si = 0; si <= 100; si++) {
                    var sx = r[0] + (si / 100) * (r[1] - r[0]);
                    var pv = d.pdf(sx);
                    if (pv > maxPDF) maxPDF = pv;
                }
                maxPDF = maxPDF || 0.1;

                p.fill(C.accent[0], C.accent[1], C.accent[2], 30);
                p.stroke(C.accent); p.strokeWeight(2);
                p.beginShape();
                p.vertex(x, plotY + plotH);
                for (var pi = 0; pi <= w; pi += 2) {
                    var px = r[0] + (pi / w) * (r[1] - r[0]);
                    var pv2 = d.pdf(px);
                    p.vertex(x + pi, plotY + plotH - (pv2 / maxPDF) * plotH * 0.9);
                }
                p.vertex(x + w, plotY + plotH);
                p.endShape(p.CLOSE);
            }

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
            var labels = d.discrete ? [1, 2, 3, 4, 5, 6] : [r[0], (r[0] + r[1]) / 2, r[1]];
            for (var li = 0; li < labels.length; li++) {
                var lx = x + ((labels[li] - r[0]) / (r[1] - r[0])) * w;
                p.text(labels[li], lx, plotY + plotH + 3);
            }
        }

        function drawSampling(d, C, x, y, w, h) {
            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Distribution of X\u0305  (n=' + state.n + ', N=' + means.length + ')', x, y);

            var plotY = y + 18;
            var plotH = h - 36;
            var r = d.range;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(x, plotY + plotH, x + w, plotY + plotH);
            p.line(x, plotY, x, plotY + plotH);

            if (means.length < 2) {
                p.fill(C.muted); p.textSize(14); p.textAlign(p.CENTER, p.CENTER);
                p.text('Click "Draw Samples" to start', x + w / 2, plotY + plotH / 2);
                return;
            }

            // Build histogram
            var bins = 40;
            var binW = (r[1] - r[0]) / bins;
            var counts = [];
            for (var bi = 0; bi < bins; bi++) counts[bi] = 0;
            for (var mi = 0; mi < means.length; mi++) {
                var idx = Math.floor((means[mi] - r[0]) / binW);
                if (idx >= 0 && idx < bins) counts[idx]++;
            }

            // Max density for scaling
            var maxDensity = 0;
            for (var bi2 = 0; bi2 < bins; bi2++) {
                var dens = counts[bi2] / (means.length * binW);
                if (dens > maxDensity) maxDensity = dens;
            }
            var sigmaM = d.sigma / Math.sqrt(state.n);
            var normalMax = gaussPDF(d.mu, d.mu, sigmaM);
            var yScale = plotH * 0.9 / Math.max(maxDensity, normalMax, 0.01);

            // Draw histogram bars
            p.noStroke();
            var bw = w / bins;
            for (var bi3 = 0; bi3 < bins; bi3++) {
                if (counts[bi3] === 0) continue;
                var dens2 = counts[bi3] / (means.length * binW);
                var bh = dens2 * yScale;
                p.fill(C.sin[0], C.sin[1], C.sin[2], 80);
                p.rect(x + bi3 * bw, plotY + plotH - bh, bw - 1, bh);
            }

            // Normal curve overlay
            p.stroke(C.cos); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var ni = 0; ni <= w; ni += 2) {
                var nx = r[0] + (ni / w) * (r[1] - r[0]);
                var nv = gaussPDF(nx, d.mu, sigmaM);
                p.vertex(x + ni, plotY + plotH - nv * yScale);
            }
            p.endShape();

            // Legend
            p.textSize(10); p.textAlign(p.RIGHT, p.TOP);
            p.fill(C.sin); p.noStroke();
            p.text('\u25A0 Sample means', x + w, y);
            p.fill(C.cos);
            p.text('\u2500 N(\u03BC, \u03C3\u00B2/n)', x + w, y + 13);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
            var step = niceStep(r[1] - r[0], 5);
            var ls = Math.ceil(r[0] / step) * step;
            for (var xl = ls; xl <= r[1]; xl += step) {
                var lx = x + ((xl - r[0]) / (r[1] - r[0])) * w;
                p.text(xl.toFixed(1), lx, plotY + plotH + 3);
            }

            // Bottom stats line
            var mMean = mean(means);
            var mStd = std(means, mMean);
            p.fill(C.muted); p.textSize(10); p.textAlign(p.LEFT, p.TOP);
            p.text('Mean=' + mMean.toFixed(3) + '  Std=' + mStd.toFixed(3) +
                   '  Theory: \u03C3/\u221An=' + sigmaM.toFixed(3), x, plotY + plotH + 16);
        }

        function syncStats(d) {
            setEl('val-n-drawn', String(means.length));
            if (means.length > 1) {
                var m = mean(means);
                var s = std(means, m);
                var sigmaM = d.sigma / Math.sqrt(state.n);
                setEl('val-mean', m.toFixed(4));
                setEl('val-std', s.toFixed(4));
                setEl('val-theory', sigmaM.toFixed(4));
            }
        }

        function mean(arr) {
            var s = 0;
            for (var i = 0; i < arr.length; i++) s += arr[i];
            return s / arr.length;
        }

        function std(arr, m) {
            var s = 0;
            for (var i = 0; i < arr.length; i++) s += (arr[i] - m) * (arr[i] - m);
            return Math.sqrt(s / arr.length);
        }

        function niceStep(range, target) {
            var rough = range / target;
            var mag = Math.pow(10, Math.floor(Math.log10(rough)));
            var norm = rough / mag;
            if (norm < 1.5) return mag;
            if (norm < 3) return 2 * mag;
            if (norm < 7) return 5 * mag;
            return 10 * mag;
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        state._redraw = function() { p.loop(); };
        state._reset = function() { means = []; syncStats(DISTS[state.dist]); p.loop(); };
        state._start = function() { state.running = true; p.loop(); };
        state._stop = function() { state.running = false; };
    }

    VisualMath.register('clt', clt);
})();
