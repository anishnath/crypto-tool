/**
 * Visual Math — Probability Distributions
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function distributionsViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        var factCache = [1, 1];
        function fact(n) {
            if (n < 0) return 1;
            if (n > 170) return Infinity;
            if (factCache[n] != null) return factCache[n];
            factCache[n] = n * fact(n - 1);
            return factCache[n];
        }

        function choose(n, k) {
            if (k < 0 || k > n) return 0;
            if (k === 0 || k === n) return 1;
            if (k > n - k) k = n - k;
            var r = 1;
            for (var i = 0; i < k; i++) r = r * (n - i) / (i + 1);
            return r;
        }

        function pmf(k) {
            var dist = state.distType || 'binomial';
            var n = state.n != null ? state.n : 10;
            var pr = state.p != null ? state.p : 0.5;
            var lam = state.lambda != null ? state.lambda : 3;

            if (dist === 'binomial') {
                return choose(n, k) * Math.pow(pr, k) * Math.pow(1 - pr, n - k);
            }
            if (dist === 'poisson') {
                if (k < 0) return 0;
                return Math.exp(-lam) * Math.pow(lam, k) / fact(k);
            }
            if (dist === 'geometric') {
                if (k < 0) return 0;
                return Math.pow(1 - pr, k) * pr;
            }
            if (dist === 'uniform') {
                if (k >= 0 && k <= n) return 1 / (n + 1);
                return 0;
            }
            return 0;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawDistribution(C);
            updateValues();
            p.noLoop();
        };

        function drawDistribution(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var dist = state.distType || 'binomial';
            var n = state.n != null ? state.n : 10;
            var lam = state.lambda != null ? state.lambda : 3;
            var pr = state.p != null ? state.p : 0.5;

            var kMin = 0, kMax;
            if (dist === 'binomial') kMax = n;
            else if (dist === 'poisson') kMax = Math.min(30, Math.max(10, Math.ceil(lam + 4 * Math.sqrt(Math.max(lam, 1)))));
            else if (dist === 'geometric') kMax = Math.min(25, Math.max(8, Math.ceil(4 / Math.max(pr, 0.05))));
            else kMax = n;

            var numBars = kMax - kMin + 1;
            var probs = [];
            var maxP = 0;
            for (var k = kMin; k <= kMax; k++) {
                var pk = pmf(k);
                probs.push(isFinite(pk) ? pk : 0);
                if (isFinite(pk) && pk > maxP) maxP = pk;
            }
            if (maxP < 0.001) maxP = 0.1;

            var barSpacing = gw / numBars;
            var barW = Math.max(4, Math.min(32, barSpacing - 2));
            var baseY = pad + gh;
            var yScale = (gh - 30) / maxP;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, baseY, pad + gw, baseY);
            p.line(pad, pad, pad, baseY);

            // Y grid + labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            p.textAlign(p.RIGHT, p.CENTER);
            for (var y = 0; y <= 4; y++) {
                var yVal = maxP * y / 4;
                var yPos = baseY - yVal * yScale;
                p.text(yVal.toFixed(3), pad - 4, yPos);
                if (y > 0) {
                    p.stroke(C.grid || [200, 200, 200, 40]); p.strokeWeight(0.5);
                    p.line(pad, yPos, pad + gw, yPos);
                    p.noStroke();
                }
            }

            // Mean line
            var mean = getMean();
            if (isFinite(mean)) {
                var meanX = pad + (mean - kMin + 0.5) * barSpacing;
                if (meanX > pad && meanX < pad + gw) {
                    p.stroke(C.cos[0], C.cos[1], C.cos[2], 150); p.strokeWeight(2);
                    p.drawingContext.setLineDash([5, 4]);
                    p.line(meanX, pad + 15, meanX, baseY);
                    p.drawingContext.setLineDash([]);
                    p.fill(C.cos); p.noStroke(); p.textSize(10);
                    p.textAlign(p.CENTER, p.TOP);
                    p.text('\u03BC=' + mean.toFixed(2), meanX, pad + 2);
                }
            }

            // Bars
            for (var i = 0; i < probs.length; i++) {
                var bx = pad + i * barSpacing + (barSpacing - barW) / 2;
                var bh = probs[i] * yScale;
                p.fill(C.sin[0], C.sin[1], C.sin[2], 160);
                p.stroke(C.sin); p.strokeWeight(1);
                p.rect(bx, baseY - bh, barW, bh);

                if (numBars <= 20 || i % Math.ceil(numBars / 15) === 0) {
                    p.fill(C.muted); p.noStroke(); p.textSize(8);
                    p.textAlign(p.CENTER, p.TOP);
                    p.text(kMin + i, bx + barW / 2, baseY + 3);
                }
            }

            // Std dev band
            var variance = getVariance();
            if (isFinite(variance) && variance > 0) {
                var std = Math.sqrt(variance);
                var sdLeft = pad + (mean - std - kMin + 0.5) * barSpacing;
                var sdRight = pad + (mean + std - kMin + 0.5) * barSpacing;
                sdLeft = Math.max(pad, sdLeft);
                sdRight = Math.min(pad + gw, sdRight);
                p.fill(C.accent[0], C.accent[1], C.accent[2], 20);
                p.noStroke();
                p.rect(sdLeft, pad + 15, sdRight - sdLeft, gh - 15);
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(11);
            p.textAlign(p.RIGHT, p.BOTTOM);
            var names = { binomial: 'Binomial', poisson: 'Poisson', geometric: 'Geometric', uniform: 'Discrete Uniform' };
            p.text('P(X = k) \u2014 ' + (names[dist] || dist), pad + gw, pad - 2);

            // X axis label
            p.fill(C.muted); p.textSize(10); p.textAlign(p.CENTER, p.TOP);
            p.text('k', pad + gw / 2, baseY + 14);
        }

        function getMean() {
            var dist = state.distType || 'binomial';
            var n = state.n != null ? state.n : 10;
            var pr = state.p != null ? state.p : 0.5;
            var lam = state.lambda != null ? state.lambda : 3;
            if (dist === 'binomial') return n * pr;
            if (dist === 'poisson') return lam;
            if (dist === 'geometric') return (1 - pr) / pr;
            if (dist === 'uniform') return n / 2;
            return 0;
        }

        function getVariance() {
            var dist = state.distType || 'binomial';
            var n = state.n != null ? state.n : 10;
            var pr = state.p != null ? state.p : 0.5;
            var lam = state.lambda != null ? state.lambda : 3;
            if (dist === 'binomial') return n * pr * (1 - pr);
            if (dist === 'poisson') return lam;
            if (dist === 'geometric') return (1 - pr) / (pr * pr);
            if (dist === 'uniform') return n * (n + 2) / 12;
            return 0;
        }

        function updateValues() {
            var dist = state.distType || 'binomial';
            var n = state.n != null ? state.n : 10;
            var pr = state.p != null ? state.p : 0.5;
            var lam = state.lambda != null ? state.lambda : 3;
            var names = { binomial: 'Binomial(n, p)', poisson: 'Poisson(\u03BB)', geometric: 'Geometric(p)', uniform: 'Uniform(0, n)' };
            setEl('val-dist', names[dist] || dist);

            if (dist === 'binomial') {
                setEl('val-pmf', 'C(n,k)\u00B7p\u1D4F\u00B7(1\u2212p)\u207F\u207B\u1D4F');
                setEl('val-params', 'n=' + n + ', p=' + pr.toFixed(2));
            } else if (dist === 'poisson') {
                setEl('val-pmf', 'e\u207B\u03BB\u00B7\u03BB\u1D4F / k!');
                setEl('val-params', '\u03BB=' + lam.toFixed(1));
            } else if (dist === 'geometric') {
                setEl('val-pmf', '(1\u2212p)\u1D4F\u00B7p');
                setEl('val-params', 'p=' + pr.toFixed(2));
            } else if (dist === 'uniform') {
                setEl('val-pmf', '1/(n+1)');
                setEl('val-params', 'n=' + n);
            }

            var mean = getMean();
            var vari = getVariance();
            setEl('val-mean', '\u03BC = ' + mean.toFixed(2));
            setEl('val-variance', '\u03C3\u00B2 = ' + vari.toFixed(2));
            setEl('val-std', '\u03C3 = ' + Math.sqrt(vari).toFixed(3));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('distributions', distributionsViz);
})();
