/**
 * Visual Math — Systems of Linear Equations
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function systemsViz(p, container) {
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
            var ox = pad + gw / 2;
            var oy = pad + gh / 2;
            var xRange = 10, yRange = 10;
            var sx = gw / (2 * xRange);
            var sy = gh / (2 * yRange);

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

            // Tick labels
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

            var m1 = state.m1 != null ? state.m1 : 1;
            var b1 = state.b1 != null ? state.b1 : 2;
            var m2 = state.m2 != null ? state.m2 : -0.5;
            var b2 = state.b2 != null ? state.b2 : -1;

            // Line 1
            drawLine(m1, b1, C.sin, 2.5, toX, toY, xRange);
            // Line 2
            drawLine(m2, b2, C.cos, 2.5, toX, toY, xRange);

            // Intersection point
            var dm = m1 - m2;
            if (Math.abs(dm) > 0.001) {
                var ix = (b2 - b1) / dm;
                var iy = m1 * ix + b1;

                if (Math.abs(ix) <= xRange + 1 && Math.abs(iy) <= yRange + 1) {
                    // Crosshair
                    p.stroke(C.accent[0], C.accent[1], C.accent[2], 80);
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(toX(ix), pad, toX(ix), pad + gh);
                    p.line(pad, toY(iy), pad + gw, toY(iy));
                    p.drawingContext.setLineDash([]);

                    // Point
                    p.fill(C.accent);
                    p.stroke(255);
                    p.strokeWeight(2);
                    p.ellipse(toX(ix), toY(iy), 14, 14);

                    // Label
                    if (state.showLabels !== false) {
                        p.fill(C.accent);
                        p.noStroke();
                        p.textSize(14);
                        p.textAlign(p.LEFT, p.BOTTOM);
                        p.text('(' + ix.toFixed(2) + ', ' + iy.toFixed(2) + ')', toX(ix) + 10, toY(iy) - 6);
                    }
                }
            }

            // Equation labels
            p.noStroke();
            p.textSize(14);
            p.textAlign(p.LEFT, p.TOP);
            p.fill(C.sin);
            p.text(fmtEq('y', m1, b1, '1'), pad + 8, pad + 8);
            p.fill(C.cos);
            p.text(fmtEq('y', m2, b2, '2'), pad + 8, pad + 26);
        }

        function fmtEq(lhs, m, b) {
            var s = lhs + ' = ' + m.toFixed(1) + 'x';
            if (b >= 0) s += ' + ' + b.toFixed(1);
            else s += ' \u2212 ' + Math.abs(b).toFixed(1);
            return s;
        }

        function drawLine(m, b, color, weight, toX, toY, xRange) {
            var x1 = -xRange, y1 = m * x1 + b;
            var x2 = xRange, y2 = m * x2 + b;
            p.stroke(color);
            p.strokeWeight(weight);
            p.line(toX(x1), toY(y1), toX(x2), toY(y2));
        }

        function updateValues() {
            var m1 = state.m1 != null ? state.m1 : 1;
            var b1 = state.b1 != null ? state.b1 : 2;
            var m2 = state.m2 != null ? state.m2 : -0.5;
            var b2 = state.b2 != null ? state.b2 : -1;

            var dm = m1 - m2;
            var caseType, solution;

            if (Math.abs(dm) < 0.001) {
                // Parallel or same line
                if (Math.abs(b1 - b2) < 0.01) {
                    caseType = 'Infinite Solutions';
                    solution = 'Same line';
                } else {
                    caseType = 'No Solution';
                    solution = 'Parallel lines';
                }
            } else {
                var ix = (b2 - b1) / dm;
                var iy = m1 * ix + b1;
                caseType = 'One Solution';
                solution = '(' + ix.toFixed(2) + ', ' + iy.toFixed(2) + ')';
            }

            setEl('val-case', caseType);
            setEl('val-solution', solution);
            setEl('val-eq1', fmtEq('y', m1, b1));
            setEl('val-eq2', fmtEq('y', m2, b2));

            // Relationship
            var rel = '';
            if (Math.abs(dm) < 0.001) rel = Math.abs(b1 - b2) < 0.01 ? 'Coincident' : 'Parallel';
            else if (Math.abs(m1 * m2 + 1) < 0.05) rel = 'Perpendicular';
            else rel = 'Intersecting';
            setEl('val-relationship', rel);
        }

        function fmtEq(lhs, m, b) {
            var s = lhs + ' = ' + m.toFixed(1) + 'x';
            if (b >= 0) s += ' + ' + b.toFixed(1);
            else s += ' \u2212 ' + Math.abs(b).toFixed(1);
            return s;
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('systems', systemsViz);
})();
