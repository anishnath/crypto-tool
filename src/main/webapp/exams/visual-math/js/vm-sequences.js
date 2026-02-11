/**
 * Visual Math — Sequences & Series
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function sequencesViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawSequence(C);
            updateValues();
            p.noLoop();
        };

        function drawSequence(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var seqType = state.seqType || 'arithmetic';
            var a1 = state.a1 != null ? state.a1 : 2;
            var d = state.d != null ? state.d : 3;
            var r = state.r != null ? state.r : 2;
            var n = state.n || 10;

            // Generate terms and partial sums
            var terms = [], sums = [], cumSum = 0;
            for (var i = 0; i < n; i++) {
                var term = seqType === 'arithmetic' ? a1 + i * d : a1 * Math.pow(r, i);
                terms.push(term);
                cumSum += term;
                sums.push(cumSum);
            }

            // Scaling
            var allVals = terms.concat(state.showSum !== false ? sums : []);
            var maxAbs = Math.max.apply(null, allVals.map(function (v) { return Math.abs(v); }));
            if (maxAbs < 1) maxAbs = 1;
            if (maxAbs > 1e6) maxAbs = 1e6; // cap for display
            var hasNeg = allVals.some(function (v) { return v < 0; });

            var barSpacing = (gw - 20) / n;
            var barW = Math.max(6, Math.min(36, barSpacing - 4));
            var zeroY, yScale;
            if (hasNeg) {
                zeroY = pad + gh / 2;
                yScale = (gh / 2 - 10) / maxAbs;
            } else {
                zeroY = pad + gh;
                yScale = (gh - 20) / maxAbs;
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, zeroY, pad + gw, zeroY);
            p.line(pad + 10, pad, pad + 10, pad + gh);

            // Bars for terms
            for (var k = 0; k < terms.length; k++) {
                var barX = pad + 15 + k * barSpacing;
                var barH = Math.max(-gh, Math.min(gh, terms[k] * yScale));
                p.fill(C.sin[0], C.sin[1], C.sin[2], 140);
                p.stroke(C.sin); p.strokeWeight(1);
                p.rect(barX, zeroY - Math.max(0, barH), barW, Math.abs(barH));

                p.fill(C.muted); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER, p.TOP);
                p.text(k + 1, barX + barW / 2, zeroY + 4);
            }

            // Partial sum line
            if (state.showSum !== false) {
                p.stroke(C.accent); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var m = 0; m < sums.length; m++) {
                    var sx = pad + 15 + m * barSpacing + barW / 2;
                    var sy = zeroY - Math.max(-gh, Math.min(gh, sums[m] * yScale));
                    sy = Math.max(pad, Math.min(pad + gh, sy));
                    p.vertex(sx, sy);
                }
                p.endShape();

                p.fill(C.accent); p.noStroke();
                for (var q = 0; q < sums.length; q++) {
                    var dx = pad + 15 + q * barSpacing + barW / 2;
                    var dy = zeroY - Math.max(-gh, Math.min(gh, sums[q] * yScale));
                    dy = Math.max(pad, Math.min(pad + gh, dy));
                    p.ellipse(dx, dy, 6, 6);
                }
            }

            // Convergence line for geometric |r| < 1
            if (seqType === 'geometric' && Math.abs(r) < 1 && Math.abs(1 - r) > 0.001) {
                var sInf = a1 / (1 - r);
                var sInfY = zeroY - sInf * yScale;
                if (sInfY > pad && sInfY < pad + gh) {
                    p.stroke(C.cos[0], C.cos[1], C.cos[2], 100); p.strokeWeight(1);
                    p.drawingContext.setLineDash([5, 4]);
                    p.line(pad, sInfY, pad + gw, sInfY);
                    p.drawingContext.setLineDash([]);
                    p.fill(C.cos); p.noStroke(); p.textSize(10);
                    p.textAlign(p.RIGHT, p.BOTTOM);
                    p.text('S\u221E = ' + sInf.toFixed(1), pad + gw, sInfY - 4);
                }
            }

            // Legend
            p.noStroke(); p.textSize(11); p.textAlign(p.LEFT, p.CENTER);
            p.fill(C.sin); p.rect(pad + gw - 120, pad + 6, 10, 10);
            p.fill(C.text); p.text('Terms', pad + gw - 106, pad + 12);
            if (state.showSum !== false) {
                p.fill(C.accent); p.rect(pad + gw - 120, pad + 22, 10, 10);
                p.fill(C.text); p.text('Partial sum', pad + gw - 106, pad + 28);
            }
        }

        function updateValues() {
            var seqType = state.seqType || 'arithmetic';
            var a1 = state.a1 != null ? state.a1 : 2;
            var d = state.d != null ? state.d : 3;
            var r = state.r != null ? state.r : 2;
            var n = state.n || 10;

            setEl('val-type', seqType === 'arithmetic' ? 'Arithmetic' : 'Geometric');

            if (seqType === 'arithmetic') {
                setEl('val-formula', 'a\u2099 = ' + a1 + ' + (n\u22121)\u00D7' + d);
                var an = a1 + (n - 1) * d;
                setEl('val-nth', 'a\u2099 = ' + an.toFixed(1));
                setEl('val-sum', 'S\u2099 = ' + (n * (a1 + an) / 2).toFixed(1));
                setEl('val-convergence', d === 0 ? 'Constant' : 'Diverges');
            } else {
                setEl('val-formula', 'a\u2099 = ' + a1 + '\u00D7' + r + '^(n\u22121)');
                var an2 = a1 * Math.pow(r, n - 1);
                setEl('val-nth', 'a\u2099 = ' + (Math.abs(an2) > 9999 ? an2.toExponential(2) : an2.toFixed(1)));
                var sum2 = Math.abs(r - 1) < 0.001 ? a1 * n : a1 * (1 - Math.pow(r, n)) / (1 - r);
                setEl('val-sum', 'S\u2099 = ' + (Math.abs(sum2) > 9999 ? sum2.toExponential(2) : sum2.toFixed(1)));
                var conv = Math.abs(r) < 1 ? 'Converges (S\u221E=' + (a1 / (1 - r)).toFixed(2) + ')' : (Math.abs(r) === 1 ? 'Constant' : 'Diverges');
                setEl('val-convergence', conv);
            }

            var terms = [];
            for (var i = 0; i < Math.min(5, n); i++) {
                if (seqType === 'arithmetic') terms.push((a1 + i * d).toFixed(1));
                else terms.push((a1 * Math.pow(r, i)).toFixed(1));
            }
            setEl('val-terms', terms.join(', ') + ', \u2026');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('sequences', sequencesViz);
})();
