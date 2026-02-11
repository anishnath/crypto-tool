/**
 * Visual Math — 2D Vector Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function vectorsViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;
        var dragging = null;
        var ox, oy, sc;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function toX(v) { return ox + v * sc; }
        function toY(v) { return oy - v * sc; }
        function fromX(sx) { return (sx - ox) / sc; }
        function fromY(sy) { return -(sy - oy) / sc; }

        function drawArrow(col, x1, y1, x2, y2, w) {
            p.stroke(col); p.strokeWeight(w || 2.5);
            p.line(toX(x1), toY(y1), toX(x2), toY(y2));
            var ang = Math.atan2(-(toY(y2) - toY(y1)), toX(x2) - toX(x1));
            var hl = 10;
            p.fill(col); p.noStroke();
            p.push(); p.translate(toX(x2), toY(y2)); p.rotate(-ang);
            p.triangle(0, 0, -hl, -hl * 0.4, -hl, hl * 0.4);
            p.pop();
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var gw = W - pad * 2, gh = H - pad * 2;
            ox = pad + gw / 2; oy = pad + gh / 2;
            sc = Math.min(gw, gh) / 14;

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var i = -7; i <= 7; i++) {
                p.line(toX(i), pad, toX(i), pad + gh);
                p.line(pad, toY(i), pad + gw, toY(i));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            var ax = state.ax != null ? state.ax : 3, ay = state.ay != null ? state.ay : 2;
            var bx = state.bx != null ? state.bx : 1, by = state.by != null ? state.by : 4;
            var showSum = state.showSum !== false;
            var showDot = state.showDot;

            // Sum parallelogram
            if (showSum) {
                p.fill(C.accent[0], C.accent[1], C.accent[2], 20);
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 60); p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 3]);
                p.beginShape();
                p.vertex(toX(0), toY(0)); p.vertex(toX(ax), toY(ay));
                p.vertex(toX(ax + bx), toY(ay + by)); p.vertex(toX(bx), toY(by));
                p.endShape(p.CLOSE);
                p.drawingContext.setLineDash([]);

                drawArrow(C.accent, 0, 0, ax + bx, ay + by, 2);
            }

            // Projection
            if (showDot) {
                var dot = ax * bx + ay * by;
                var magB2 = bx * bx + by * by;
                if (magB2 > 0.01) {
                    var projS = dot / magB2;
                    var projX = projS * bx, projY = projS * by;
                    p.stroke(C.muted); p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(toX(ax), toY(ay), toX(projX), toY(projY));
                    p.drawingContext.setLineDash([]);
                    p.fill(C.muted); p.noStroke();
                    p.ellipse(toX(projX), toY(projY), 7, 7);
                }
            }

            // Vectors
            drawArrow(C.sin, 0, 0, ax, ay);
            drawArrow(C.cos, 0, 0, bx, by);

            // Draggable tips
            p.fill(C.sin); p.stroke(C.accent); p.strokeWeight(2);
            p.ellipse(toX(ax), toY(ay), 12, 12);
            p.fill(C.cos);
            p.ellipse(toX(bx), toY(by), 12, 12);

            // Angle arc
            var magA = Math.sqrt(ax * ax + ay * ay);
            var magB = Math.sqrt(bx * bx + by * by);
            if (magA > 0.1 && magB > 0.1) {
                var angA = Math.atan2(ay, ax), angB = Math.atan2(by, bx);
                var s = Math.min(angA, angB), e = Math.max(angA, angB);
                if (e - s > Math.PI) { var tmp = s; s = e; e = tmp + 2 * Math.PI; }
                p.noFill(); p.stroke(C.accent[0], C.accent[1], C.accent[2], 120); p.strokeWeight(1.5);
                p.arc(ox, oy, sc * 1.5, sc * 1.5, -e, -s);
            }

            // Labels
            p.noStroke(); p.textSize(13); p.textAlign(p.LEFT, p.CENTER);
            p.fill(C.sin); p.text('\u20D7a', toX(ax) + 10, toY(ay));
            p.fill(C.cos); p.text('\u20D7b', toX(bx) + 10, toY(by));
            if (showSum) { p.fill(C.accent); p.text('\u20D7a+\u20D7b', toX(ax + bx) + 8, toY(ay + by)); }

            updateValues();
            if (!dragging) p.noLoop();
        };

        function updateValues() {
            var ax = state.ax != null ? state.ax : 3, ay = state.ay != null ? state.ay : 2;
            var bx = state.bx != null ? state.bx : 1, by = state.by != null ? state.by : 4;
            var magA = Math.sqrt(ax * ax + ay * ay), magB = Math.sqrt(bx * bx + by * by);
            var dot = ax * bx + ay * by;
            var angle = (magA > 0.01 && magB > 0.01) ? Math.acos(Math.max(-1, Math.min(1, dot / (magA * magB)))) * 180 / Math.PI : 0;

            setEl('val-vec-a', '(' + ax.toFixed(1) + ', ' + ay.toFixed(1) + ')');
            setEl('val-vec-b', '(' + bx.toFixed(1) + ', ' + by.toFixed(1) + ')');
            setEl('val-mag-a', '|a| = ' + magA.toFixed(2));
            setEl('val-mag-b', '|b| = ' + magB.toFixed(2));
            setEl('val-dot', 'a\u00B7b = ' + dot.toFixed(2));
            setEl('val-angle', '\u03B8 = ' + angle.toFixed(1) + '\u00B0');
            setEl('val-sum', '(' + (ax + bx).toFixed(1) + ', ' + (ay + by).toFixed(1) + ')');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        p.mousePressed = function () {
            var ax = state.ax != null ? state.ax : 3, ay = state.ay != null ? state.ay : 2;
            var bx = state.bx != null ? state.bx : 1, by = state.by != null ? state.by : 4;
            if (Math.hypot(p.mouseX - toX(ax), p.mouseY - toY(ay)) < 20) { dragging = 'a'; p.loop(); }
            else if (Math.hypot(p.mouseX - toX(bx), p.mouseY - toY(by)) < 20) { dragging = 'b'; p.loop(); }
        };

        p.mouseDragged = function () {
            if (!dragging) return;
            var x = Math.round(fromX(p.mouseX) * 2) / 2;
            var y = Math.round(fromY(p.mouseY) * 2) / 2;
            x = Math.max(-6, Math.min(6, x)); y = Math.max(-6, Math.min(6, y));
            if (dragging === 'a') { state.ax = x; state.ay = y; }
            else { state.bx = x; state.by = y; }
        };

        p.mouseReleased = function () { dragging = null; };

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('vectors', vectorsViz);
})();
