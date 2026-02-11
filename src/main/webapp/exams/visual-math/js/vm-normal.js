/**
 * Visual Math — Normal Distribution Calculator
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;

    // Standard normal PDF
    function phi(x) {
        return Math.exp(-0.5 * x * x) / Math.sqrt(2 * Math.PI);
    }

    // Standard normal CDF (Abramowitz & Stegun approximation)
    function Phi(x) {
        var t = 1 / (1 + 0.2316419 * Math.abs(x));
        var p = phi(Math.abs(x)) * t *
            (0.319381530 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))));
        return x >= 0 ? 1 - p : p;
    }

    // General normal PDF/CDF
    function normalPDF(x, mu, sigma) { return phi((x - mu) / sigma) / sigma; }
    function normalCDF(x, mu, sigma) { return Phi((x - mu) / sigma); }

    function normalDist(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 30, padB = 50;

        if (state.mu == null) state.mu = 0;
        if (state.sigma == null) state.sigma = 1;
        if (state.mode == null) state.mode = 'less';
        if (state.xVal == null) state.xVal = 1;
        if (state.xVal2 == null) state.xVal2 = -1;

        function layout() {
            W = container.clientWidth;
            H = Math.max(350, Math.min(480, W * 0.55));
        }

        p.setup = function() { layout(); p.createCanvas(W, H); };
        p.windowResized = function() { layout(); p.resizeCanvas(W, H); };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);

            var mu = state.mu, sigma = state.sigma;
            var xMin = mu - 4 * sigma, xMax = mu + 4 * sigma;
            var gw = W - padL - padR;
            var gh = H - padT - padB;
            var yMax = normalPDF(mu, mu, sigma) * 1.15;

            function mapX(x) { return padL + ((x - xMin) / (xMax - xMin)) * gw; }
            function mapY(y) { return padT + gh - (y / yMax) * gh; }

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var g = 1; g <= 3; g++) {
                var gx1 = mapX(mu - g * sigma), gx2 = mapX(mu + g * sigma);
                p.line(gx1, padT, gx1, padT + gh);
                p.line(gx2, padT, gx2, padT + gh);
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(padL, padT + gh, padL + gw, padT + gh);
            p.line(mapX(mu), padT, mapX(mu), padT + gh);

            // Shaded area
            var prob = 0;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 50);
            p.noStroke();
            p.beginShape();

            if (state.mode === 'less') {
                var xBound = state.xVal;
                prob = normalCDF(xBound, mu, sigma);
                var bx = Math.min(mapX(xBound), padL + gw);
                p.vertex(padL, padT + gh);
                for (var i = padL; i <= bx; i += 2) {
                    var x = xMin + ((i - padL) / gw) * (xMax - xMin);
                    p.vertex(i, mapY(normalPDF(x, mu, sigma)));
                }
                p.vertex(bx, padT + gh);
            } else if (state.mode === 'greater') {
                var xBound2 = state.xVal;
                prob = 1 - normalCDF(xBound2, mu, sigma);
                var bx2 = Math.max(mapX(xBound2), padL);
                p.vertex(bx2, padT + gh);
                for (var i2 = bx2; i2 <= padL + gw; i2 += 2) {
                    var x2 = xMin + ((i2 - padL) / gw) * (xMax - xMin);
                    p.vertex(i2, mapY(normalPDF(x2, mu, sigma)));
                }
                p.vertex(padL + gw, padT + gh);
            } else { // between
                var lo = Math.min(state.xVal2, state.xVal);
                var hi = Math.max(state.xVal2, state.xVal);
                prob = normalCDF(hi, mu, sigma) - normalCDF(lo, mu, sigma);
                var bxLo = Math.max(mapX(lo), padL);
                var bxHi = Math.min(mapX(hi), padL + gw);
                p.vertex(bxLo, padT + gh);
                for (var i3 = bxLo; i3 <= bxHi; i3 += 2) {
                    var x3 = xMin + ((i3 - padL) / gw) * (xMax - xMin);
                    p.vertex(i3, mapY(normalPDF(x3, mu, sigma)));
                }
                p.vertex(bxHi, padT + gh);
            }
            p.endShape(p.CLOSE);

            // Bell curve
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var ci = 0; ci <= gw; ci += 2) {
                var cx = xMin + (ci / gw) * (xMax - xMin);
                p.vertex(padL + ci, mapY(normalPDF(cx, mu, sigma)));
            }
            p.endShape();

            // X labels (sigma marks)
            p.fill(C.muted); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            for (var s = -3; s <= 3; s++) {
                var lx = mapX(mu + s * sigma);
                var label = s === 0 ? '\u03BC' : (s > 0 ? '\u03BC+' + s + '\u03C3' : '\u03BC' + s + '\u03C3');
                if (sigma === 1 && mu === 0) label = String(s);
                p.text(label, lx, padT + gh + 6);
            }

            // Bound markers
            p.stroke(C.accent); p.strokeWeight(2);
            p.drawingContext.setLineDash([4, 4]);
            if (state.mode === 'between') {
                p.line(mapX(state.xVal2), padT, mapX(state.xVal2), padT + gh);
            }
            p.line(mapX(state.xVal), padT, mapX(state.xVal), padT + gh);
            p.drawingContext.setLineDash([]);

            // Probability display
            var z = (state.xVal - mu) / sigma;
            p.fill(C.text); p.noStroke(); p.textSize(14); p.textAlign(p.LEFT, p.TOP);
            var pLabel = state.mode === 'less' ? 'P(X < ' + state.xVal.toFixed(2) + ')' :
                         state.mode === 'greater' ? 'P(X > ' + state.xVal.toFixed(2) + ')' :
                         'P(' + Math.min(state.xVal2, state.xVal).toFixed(2) + ' < X < ' + Math.max(state.xVal2, state.xVal).toFixed(2) + ')';
            p.text(pLabel + ' = ' + prob.toFixed(4), padL + 8, padT + 8);
            p.fill(C.muted); p.textSize(11);
            p.text('z = ' + z.toFixed(3), padL + 8, padT + 28);

            // Sync external display
            setEl('val-prob', prob.toFixed(6));
            setEl('val-z', z.toFixed(4));
            setEl('val-pct', (prob * 100).toFixed(2) + '%');

            p.noLoop();
        };

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }
        state._redraw = function() { p.loop(); };
    }

    VisualMath.register('normal-distribution', normalDist);
})();
