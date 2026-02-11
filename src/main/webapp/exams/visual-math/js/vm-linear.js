/**
 * Visual Math — Linear Equation Explorer (y = mx + b)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function linearViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

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
            drawGraph(C);
            updateValues();
            p.noLoop();
        };

        function drawGraph(C) {
            var gw = W - pad * 2;
            var gh = H - pad * 2;
            var ox = pad + gw / 2; // origin x
            var oy = pad + gh / 2; // origin y
            var xRange = 10, yRange = 10;
            var sx = gw / (2 * xRange); // scale x
            var sy = gh / (2 * yRange); // scale y

            function toX(v) { return ox + v * sx; }
            function toY(v) { return oy - v * sy; }

            // Grid
            if (state.showGrid !== false) {
                p.stroke(C.grid || [200, 200, 200, 60]);
                p.strokeWeight(0.5);
                for (var i = -xRange; i <= xRange; i++) {
                    p.line(toX(i), pad, toX(i), pad + gh);
                }
                for (var j = -yRange; j <= yRange; j++) {
                    p.line(pad, toY(j), pad + gw, toY(j));
                }
            }

            // Axes
            p.stroke(C.axis);
            p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Axis labels
            p.fill(C.muted);
            p.noStroke();
            p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            for (var k = -xRange; k <= xRange; k += 2) {
                if (k !== 0) p.text(k, toX(k), oy + 4);
            }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var l = -yRange; l <= yRange; l += 2) {
                if (l !== 0) p.text(l, ox - 6, toY(l));
            }

            var m = state.m != null ? state.m : 1;
            var b = state.b != null ? state.b : 0;

            // --- Main line ---
            drawLine(m, b, C.sin, 2.5, toX, toY, xRange);

            // Slope triangle
            if (state.showSlope !== false && Math.abs(m) > 0.01) {
                var tx = 1;
                var ty1 = m * (tx - 1) + b; // start of run
                var ty2 = m * tx + b;        // end of rise

                // Run (horizontal)
                p.stroke(C.cos);
                p.strokeWeight(2);
                p.drawingContext.setLineDash([4, 4]);
                p.line(toX(tx - 1), toY(ty1), toX(tx), toY(ty1));
                p.drawingContext.setLineDash([]);

                // Rise (vertical)
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.drawingContext.setLineDash([4, 4]);
                p.line(toX(tx), toY(ty1), toX(tx), toY(ty2));
                p.drawingContext.setLineDash([]);

                // Labels
                if (state.showLabels !== false) {
                    p.fill(C.cos);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.CENTER, p.TOP);
                    p.text('run = 1', toX(tx - 0.5), toY(ty1) + 4);

                    p.fill(C.accent);
                    p.textAlign(p.LEFT, p.CENTER);
                    p.text('rise = ' + m.toFixed(1), toX(tx) + 6, toY((ty1 + ty2) / 2));
                }
            }

            // Y-intercept point
            p.fill(C.sin);
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.ellipse(toX(0), toY(b), 10, 10);

            if (state.showLabels !== false) {
                p.fill(C.sin);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('(0, ' + b.toFixed(1) + ')', toX(0) + 10, toY(b));
            }

            // X-intercept point (if on screen)
            if (Math.abs(m) > 0.001) {
                var xInt = -b / m;
                if (Math.abs(xInt) <= xRange) {
                    p.fill(C.cos);
                    p.stroke(C.accent);
                    p.strokeWeight(2);
                    p.ellipse(toX(xInt), toY(0), 10, 10);

                    if (state.showLabels !== false) {
                        p.fill(C.cos);
                        p.noStroke();
                        p.textSize(12);
                        p.textAlign(p.CENTER, p.BOTTOM);
                        p.text('(' + xInt.toFixed(1) + ', 0)', toX(xInt), toY(0) - 8);
                    }
                }
            }

            // Parallel / perpendicular line
            if (state.showParallel) {
                drawLine(m, b + 3, C.muted, 1.5, toX, toY, xRange);
            }
            if (state.showPerpendicular && Math.abs(m) > 0.001) {
                drawLine(-1 / m, 0, C.tan || C.muted, 1.5, toX, toY, xRange);
            }

            // Equation label
            p.fill(C.text);
            p.noStroke();
            p.textSize(16);
            p.textAlign(p.LEFT, p.TOP);
            var eq = 'y = ' + m.toFixed(1) + 'x';
            if (b >= 0) eq += ' + ' + b.toFixed(1);
            else eq += ' \u2212 ' + Math.abs(b).toFixed(1);
            p.text(eq, pad + 8, pad + 8);
        }

        function drawLine(m, b, color, weight, toX, toY, xRange) {
            var x1 = -xRange, y1 = m * x1 + b;
            var x2 = xRange, y2 = m * x2 + b;
            p.stroke(color);
            p.strokeWeight(weight);
            p.line(toX(x1), toY(y1), toX(x2), toY(y2));
        }

        function updateValues() {
            var m = state.m != null ? state.m : 1;
            var b = state.b != null ? state.b : 0;
            var xInt = Math.abs(m) > 0.001 ? (-b / m).toFixed(2) : 'none';

            setEl('val-slope', m.toFixed(1));
            setEl('val-yint', '(0, ' + b.toFixed(1) + ')');
            setEl('val-xint', xInt !== 'none' ? '(' + xInt + ', 0)' : 'none');

            var eq = 'y = ' + m.toFixed(1) + 'x';
            if (b >= 0) eq += ' + ' + b.toFixed(1);
            else eq += ' - ' + Math.abs(b).toFixed(1);
            setEl('val-equation', eq);

            // Slope classification
            var sType = '';
            if (Math.abs(m) < 0.01) sType = 'Horizontal';
            else if (m > 0) sType = 'Rising (positive)';
            else sType = 'Falling (negative)';
            setEl('val-direction', sType);
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('linear', linearViz);
})();
