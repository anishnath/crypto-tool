/**
 * Visual Math — Exponential & Logarithm Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function expLogViz(p, container) {
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
            var ox = pad + gw * 0.35; // shift origin left to show more of exp growth
            var oy = pad + gh * 0.6;  // shift origin down
            var xRange = 8, yRange = 8;
            var sx = gw / (xRange + 4); // adjusted scale
            var sy = gh / (yRange + 4);

            function toX(v) { return ox + v * sx; }
            function toY(v) { return oy - v * sy; }

            // Grid
            if (state.showGrid !== false) {
                p.stroke(C.grid || [200, 200, 200, 60]);
                p.strokeWeight(0.5);
                for (var i = -4; i <= xRange; i++) {
                    p.line(toX(i), pad, toX(i), pad + gh);
                }
                for (var j = -4; j <= yRange; j++) {
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
            for (var k = -4; k <= xRange; k++) {
                if (k !== 0) p.text(k, toX(k), oy + 4);
            }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var l = -4; l <= yRange; l++) {
                if (l !== 0) p.text(l, ox - 6, toY(l));
            }

            var base = state.base != null ? state.base : Math.E;
            var showExp = state.showExp !== false;
            var showLog = state.showLog !== false;
            var showReflection = state.showReflection !== false;

            // y = x reflection line
            if (showReflection) {
                p.stroke(C.muted);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([6, 4]);
                p.line(toX(-4), toY(-4), toX(xRange), toY(xRange));
                p.drawingContext.setLineDash([]);

                if (state.showLabels !== false) {
                    p.fill(C.muted);
                    p.noStroke();
                    p.textSize(11);
                    p.textAlign(p.LEFT, p.BOTTOM);
                    p.text('y = x', toX(3.5), toY(3.8));
                }
            }

            // Asymptotes
            if (showExp) {
                // y = 0 is asymptote of a^x
                p.stroke(C.sin[0], C.sin[1], C.sin[2], 60);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                p.line(pad, oy, pad + gw, oy);
                p.drawingContext.setLineDash([]);
            }

            if (showLog) {
                // x = 0 is asymptote of log_a(x)
                p.stroke(C.cos[0], C.cos[1], C.cos[2], 60);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                p.line(ox, pad, ox, pad + gh);
                p.drawingContext.setLineDash([]);
            }

            // Draw y = a^x
            if (showExp) {
                p.stroke(C.sin);
                p.strokeWeight(2.5);
                p.noFill();
                p.beginShape();
                for (var ex = -4; ex <= xRange; ex += 0.05) {
                    var ey = Math.pow(base, ex);
                    var sY = toY(ey);
                    if (sY > pad - 10 && sY < pad + gh + 10) {
                        p.vertex(toX(ex), sY);
                    } else {
                        p.endShape();
                        p.beginShape();
                    }
                }
                p.endShape();

                // Key point (0, 1)
                p.fill(C.sin);
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.ellipse(toX(0), toY(1), 10, 10);

                // Key point (1, a)
                if (Math.abs(Math.pow(base, 1)) <= yRange) {
                    p.ellipse(toX(1), toY(base), 8, 8);
                }

                if (state.showLabels !== false) {
                    p.fill(C.sin);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.LEFT, p.CENTER);
                    p.text('(0, 1)', toX(0) + 8, toY(1));
                    p.text('y = ' + fmtBase(base) + '^x', pad + 8, pad + 16);
                }
            }

            // Draw y = log_a(x)
            if (showLog) {
                p.stroke(C.cos);
                p.strokeWeight(2.5);
                p.noFill();
                p.beginShape();
                for (var lx = 0.02; lx <= xRange; lx += 0.05) {
                    var ly = Math.log(lx) / Math.log(base);
                    var slY = toY(ly);
                    if (slY > pad - 10 && slY < pad + gh + 10) {
                        p.vertex(toX(lx), slY);
                    } else {
                        p.endShape();
                        p.beginShape();
                    }
                }
                p.endShape();

                // Key point (1, 0)
                p.fill(C.cos);
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.ellipse(toX(1), toY(0), 10, 10);

                // Key point (a, 1)
                if (base <= xRange) {
                    p.ellipse(toX(base), toY(1), 8, 8);
                }

                if (state.showLabels !== false) {
                    p.fill(C.cos);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.LEFT, p.CENTER);
                    p.text('(1, 0)', toX(1) + 8, toY(0) + 14);

                    var logLabel = 'y = log';
                    if (Math.abs(base - Math.E) < 0.01) logLabel = 'y = ln(x)';
                    else logLabel += '_' + fmtBase(base) + '(x)';
                    p.text(logLabel, pad + 8, pad + (showExp ? 34 : 16));
                }
            }
        }

        function fmtBase(b) {
            if (Math.abs(b - Math.E) < 0.01) return 'e';
            if (Math.abs(b - Math.round(b)) < 0.01) return Math.round(b).toString();
            return b.toFixed(1);
        }

        function updateValues() {
            var base = state.base != null ? state.base : Math.E;

            setEl('val-base', fmtBase(base));
            setEl('val-exp-eq', 'y = ' + fmtBase(base) + '^x');

            var logEq = '';
            if (Math.abs(base - Math.E) < 0.01) logEq = 'y = ln(x)';
            else logEq = 'y = log_' + fmtBase(base) + '(x)';
            setEl('val-log-eq', logEq);

            setEl('val-exp-key', '(0, 1), (1, ' + base.toFixed(2) + ')');
            setEl('val-log-key', '(1, 0), (' + base.toFixed(2) + ', 1)');

            var growth = base > 1 ? 'Growth' : (base < 1 && base > 0 ? 'Decay' : 'Invalid');
            setEl('val-growth', growth);
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('exp-log', expLogViz);
})();
