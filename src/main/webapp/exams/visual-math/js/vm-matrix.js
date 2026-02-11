/**
 * Visual Math — Matrix Transformer
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;
    var animT = 0, animFrom = [1,0,0,1], animTo = [1,0,0,1], animating = false;

    function matrixTransform(p, container) {
        state = VisualMath.getState();
        var W, H, scale;

        // Default matrix = identity
        if (!state.m) state.m = [1, 0, 0, 1];

        function layout() {
            W = container.clientWidth;
            H = Math.max(350, Math.min(480, W * 0.55));
            scale = Math.min(W, H) / 8;
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

            var m = state.m;

            // Animate between presets
            if (animating) {
                animT += 0.03;
                if (animT >= 1) {
                    animT = 1;
                    animating = false;
                }
                var t = easeInOut(animT);
                m = [
                    lerp(animFrom[0], animTo[0], t),
                    lerp(animFrom[1], animTo[1], t),
                    lerp(animFrom[2], animTo[2], t),
                    lerp(animFrom[3], animTo[3], t)
                ];
                state.m = m;
                syncInputs(m);
            }

            p.push();
            p.translate(W / 2, H / 2);

            // Background grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var i = -6; i <= 6; i++) {
                p.line(i * scale, -6 * scale, i * scale, 6 * scale);
                p.line(-6 * scale, i * scale, 6 * scale, i * scale);
            }

            // Transformed grid lines (subtle)
            p.stroke(C.accent[0], C.accent[1], C.accent[2], 30);
            p.strokeWeight(0.8);
            for (var g = -6; g <= 6; g++) {
                // Vertical lines: x=g mapped
                var x1 = m[0] * g * scale + m[1] * (-6) * scale;
                var y1 = m[2] * g * scale + m[3] * (-6) * scale;
                var x2 = m[0] * g * scale + m[1] * 6 * scale;
                var y2 = m[2] * g * scale + m[3] * 6 * scale;
                p.line(x1, y1, x2, y2);
                // Horizontal lines: y=g mapped
                x1 = m[0] * (-6) * scale + m[1] * g * scale;
                y1 = m[2] * (-6) * scale + m[3] * g * scale;
                x2 = m[0] * 6 * scale + m[1] * g * scale;
                y2 = m[2] * 6 * scale + m[3] * g * scale;
                p.line(x1, y1, x2, y2);
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(-W / 2, 0, W / 2, 0);
            p.line(0, -H / 2, 0, H / 2);

            // Original unit square (ghost)
            var pts = [[0,0],[1,0],[1,1],[0,1]];
            p.stroke(C.grid); p.strokeWeight(1); p.noFill();
            p.beginShape();
            for (var j = 0; j < 4; j++) p.vertex(pts[j][0] * scale, pts[j][1] * scale);
            p.endShape(p.CLOSE);

            // Transformed shape
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.stroke(C.accent); p.strokeWeight(2);
            p.beginShape();
            for (var k = 0; k < 4; k++) {
                var tx = (m[0] * pts[k][0] + m[1] * pts[k][1]) * scale;
                var ty = (m[2] * pts[k][0] + m[3] * pts[k][1]) * scale;
                p.vertex(tx, ty);
            }
            p.endShape(p.CLOSE);

            // Basis vector e1 (first column)
            drawArrow(p, 0, 0, m[0] * scale, m[2] * scale, C.sin, 'e\u2081');
            // Basis vector e2 (second column)
            drawArrow(p, 0, 0, m[1] * scale, m[3] * scale, C.cos, 'e\u2082');

            // Origin dot
            p.fill(C.point); p.noStroke();
            p.ellipse(0, 0, 8, 8);

            p.pop();

            // Determinant
            var det = m[0] * m[3] - m[1] * m[2];
            setEl('val-det', det.toFixed(4));
            setEl('val-det-meaning', det > 0 ? 'Preserves orientation' :
                                     det < 0 ? 'Flips orientation' : 'Singular (collapses)');

            if (!animating) p.noLoop();
        };

        function drawArrow(p, x1, y1, x2, y2, col, label) {
            p.stroke(col); p.strokeWeight(3);
            p.line(x1, y1, x2, y2);
            // Arrowhead
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var hl = 10;
            p.fill(col); p.noStroke();
            p.triangle(
                x2, y2,
                x2 - hl * Math.cos(angle - 0.4), y2 - hl * Math.sin(angle - 0.4),
                x2 - hl * Math.cos(angle + 0.4), y2 - hl * Math.sin(angle + 0.4)
            );
            // Label
            p.textSize(12); p.textAlign(p.CENTER, p.CENTER);
            p.text(label, x2 + 14 * Math.cos(angle + 0.5), y2 + 14 * Math.sin(angle + 0.5));
        }

        function syncInputs(m) {
            setVal('mat-a', m[0].toFixed(2));
            setVal('mat-b', m[1].toFixed(2));
            setVal('mat-c', m[2].toFixed(2));
            setVal('mat-d', m[3].toFixed(2));
        }

        function setVal(id, v) {
            var el = document.getElementById(id);
            if (el) el.value = v;
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        function lerp(a, b, t) { return a + (b - a) * t; }
        function easeInOut(t) { return t < 0.5 ? 2*t*t : -1+(4-2*t)*t; }

        // External API
        state._redraw = function() { p.loop(); };
        state._animateTo = function(target) {
            animFrom = state.m.slice();
            animTo = target;
            animT = 0;
            animating = true;
            p.loop();
        };
    }

    VisualMath.register('matrix-transform', matrixTransform);
})();
