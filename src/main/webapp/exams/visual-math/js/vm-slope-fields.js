/**
 * Visual Math — Slope Fields (ODE Visualizer)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function slopeFieldViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function dyDx(x, y) {
            var ode = state.odeType || 'y';
            if (ode === 'y') return y;
            if (ode === 'x+y') return x + y;
            if (ode === 'x-y') return x - y;
            if (ode === 'sinx') return Math.sin(x);
            if (ode === 'xy') return x * y;
            if (ode === '-y/x') return x === 0 ? 0 : -y / x;
            if (ode === 'x2-y') return x * x - y;
            return y;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawField(C);
            updateValues();
            p.noLoop();
        };

        function drawField(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var xMin = -4, xMax = 4, yMin = -4, yMax = 4;
            var xScale = gw / (xMax - xMin);
            var yScale = gh / (yMax - yMin);

            function toSx(x) { return pad + (x - xMin) * xScale; }
            function toSy(y) { return pad + (yMax - y) * yScale; }
            function fromSx(sx) { return (sx - pad) / xScale + xMin; }
            function fromSy(sy) { return yMax - (sy - pad) / yScale; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var gx = Math.ceil(xMin); gx <= Math.floor(xMax); gx++) {
                p.line(toSx(gx), pad, toSx(gx), pad + gh);
            }
            for (var gy = Math.ceil(yMin); gy <= Math.floor(yMax); gy++) {
                p.line(pad, toSy(gy), pad + gw, toSy(gy));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, toSy(0), pad + gw, toSy(0));
            p.line(toSx(0), pad, toSx(0), pad + gh);

            // Tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            for (var tx = Math.ceil(xMin); tx <= Math.floor(xMax); tx++) {
                if (tx === 0) continue;
                p.textAlign(p.CENTER, p.TOP);
                p.text(tx, toSx(tx), toSy(0) + 3);
            }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var ty = Math.ceil(yMin); ty <= Math.floor(yMax); ty++) {
                if (ty === 0) continue;
                p.text(ty, toSx(0) - 4, toSy(ty));
            }

            // Slope field segments
            var step = state.density || 0.5;
            var segLen = step * 0.35;

            for (var x = xMin + step / 2; x <= xMax; x += step) {
                for (var y = yMin + step / 2; y <= yMax; y += step) {
                    var slope = dyDx(x, y);
                    if (!isFinite(slope)) continue;

                    var angle = Math.atan(slope);
                    var dx = Math.cos(angle) * segLen;
                    var dy = Math.sin(angle) * segLen;

                    // Color by slope magnitude
                    var mag = Math.min(Math.abs(slope), 5) / 5;
                    var r = C.sin[0] * (1 - mag) + C.accent[0] * mag;
                    var g = C.sin[1] * (1 - mag) + C.accent[1] * mag;
                    var b = C.sin[2] * (1 - mag) + C.accent[2] * mag;

                    p.stroke(r, g, b, 180); p.strokeWeight(1.5);
                    p.line(toSx(x - dx), toSy(y - dy), toSx(x + dx), toSy(y + dy));
                }
            }

            // Solution curve through clicked point (Euler's method)
            if (state.showSolution && state.solX != null && state.solY != null) {
                var x0 = state.solX, y0 = state.solY;
                var dt = 0.02;

                // Forward
                p.stroke(C.accent); p.strokeWeight(2.5); p.noFill();
                p.beginShape();
                var cx = x0, cy = y0;
                for (var i = 0; i < 500; i++) {
                    if (cx < xMin - 1 || cx > xMax + 1 || cy < yMin - 5 || cy > yMax + 5) break;
                    p.vertex(toSx(cx), toSy(cy));
                    var s = dyDx(cx, cy);
                    if (!isFinite(s)) break;
                    cy += s * dt;
                    cx += dt;
                }
                p.endShape();

                // Backward
                p.beginShape();
                cx = x0; cy = y0;
                for (var j = 0; j < 500; j++) {
                    if (cx < xMin - 1 || cx > xMax + 1 || cy < yMin - 5 || cy > yMax + 5) break;
                    p.vertex(toSx(cx), toSy(cy));
                    var s2 = dyDx(cx, cy);
                    if (!isFinite(s2)) break;
                    cy -= s2 * dt;
                    cx -= dt;
                }
                p.endShape();

                // Initial point
                p.fill(C.accent); p.stroke(255); p.strokeWeight(2);
                p.ellipse(toSx(x0), toSy(y0), 12, 12);
            }

            // Equation label
            p.fill(C.text); p.noStroke(); p.textSize(12);
            p.textAlign(p.LEFT, p.TOP);
            var odeStr = getOdeStr();
            p.text("dy/dx = " + odeStr, pad + 6, pad + 4);
        }

        function getOdeStr() {
            var ode = state.odeType || 'y';
            var names = { y: 'y', 'x+y': 'x + y', 'x-y': 'x \u2212 y', sinx: 'sin(x)', xy: 'x\u00B7y', '-y/x': '\u2212y/x', 'x2-y': 'x\u00B2 \u2212 y' };
            return names[ode] || ode;
        }

        function updateValues() {
            var ode = state.odeType || 'y';
            setEl('val-ode', "dy/dx = " + getOdeStr());

            var solutions = {
                y: 'y = Ce\u02E3',
                'x+y': 'y = Ce\u02E3 \u2212 x \u2212 1',
                'x-y': 'y = x \u2212 1 + Ce\u207B\u02E3',
                sinx: 'y = \u2212cos(x) + C',
                xy: 'y = Ce\u02E3\u00B2\u002F\u0032',
                '-y/x': 'y = C/x',
                'x2-y': 'y = x\u00B2 \u2212 2x + 2 + Ce\u207B\u02E3'
            };
            setEl('val-solution', solutions[ode] || '\u2014');

            if (state.solX != null && state.solY != null) {
                setEl('val-ic', '(' + state.solX.toFixed(1) + ', ' + state.solY.toFixed(1) + ')');
                var slopeAtIC = dyDx(state.solX, state.solY);
                setEl('val-slope-ic', isFinite(slopeAtIC) ? slopeAtIC.toFixed(3) : '\u221E');
            } else {
                setEl('val-ic', 'Click canvas');
                setEl('val-slope-ic', '\u2014');
            }

            var eqPts = { y: '(x, 0)', 'x+y': 'y = \u2212x', 'x-y': 'y = x', sinx: 'x = n\u03C0', xy: 'x=0 or y=0', '-y/x': 'y = 0', 'x2-y': 'y = x\u00B2' };
            setEl('val-equilibrium', eqPts[ode] || '\u2014');
        }

        // Click to set initial condition
        p.mousePressed = function () {
            var gw = W - pad * 2, gh = H - pad * 2;
            if (p.mouseX >= pad && p.mouseX <= pad + gw && p.mouseY >= pad && p.mouseY <= pad + gh) {
                var x = (p.mouseX - pad) / gw * 8 - 4;
                var y = 4 - (p.mouseY - pad) / gh * 8;
                state.solX = Math.round(x * 4) / 4;
                state.solY = Math.round(y * 4) / 4;
                state.showSolution = true;
                p.loop();
            }
        };

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('slope-fields', slopeFieldViz);
})();
