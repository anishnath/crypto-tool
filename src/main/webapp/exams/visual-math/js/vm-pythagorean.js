/**
 * Visual Math — Pythagorean Theorem Visualizer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function pythagoreanViz(p, container) {
        state = VisualMath.getState();
        var W, H;
        var sideA = 6, sideB = 8;
        var scale = 20;
        var dragging = null;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
            scale = Math.min(W, H) / 25;
        }

        p.setup = function () {
            layout();
            var c = p.createCanvas(W, H);
            c.mousePressed(onPress);
            c.mouseReleased(onRelease);
            c.touchStarted(onPress);
            c.touchEnded(onRelease);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (dragging) {
                handleDrag();
            }

            drawVisualization(C);
            syncValues();

            if (!dragging) p.noLoop();
        };

        function drawVisualization(C) {
            p.push();
            p.translate(W / 2, H / 2);

            var sideC = Math.sqrt(sideA * sideA + sideB * sideB);
            var ax = -sideA * scale / 2;
            var ay = sideB * scale / 2;
            var bx = sideA * scale / 2;
            var by = sideB * scale / 2;
            var cx = sideA * scale / 2;
            var cy = -sideB * scale / 2;

            // Grid
            if (state.showGrid) {
                p.stroke(C.grid);
                p.strokeWeight(0.5);
                var gridSize = scale;
                for (var i = -W / 2; i < W / 2; i += gridSize) {
                    p.line(i, -H / 2, i, H / 2);
                }
                for (var j = -H / 2; j < H / 2; j += gridSize) {
                    p.line(-W / 2, j, W / 2, j);
                }
            }

            // Draw squares if enabled
            if (state.showSquares !== false) {
                // Square on side A (vertical, left)
                p.fill(C.sin[0], C.sin[1], C.sin[2], 40);
                p.stroke(C.sin);
                p.strokeWeight(2);
                p.beginShape();
                p.vertex(ax, ay);
                p.vertex(ax - sideA * scale, ay);
                p.vertex(ax - sideA * scale, cy);
                p.vertex(ax, cy);
                p.endShape(p.CLOSE);

                // Square on side B (horizontal, bottom)
                p.fill(C.cos[0], C.cos[1], C.cos[2], 40);
                p.stroke(C.cos);
                p.strokeWeight(2);
                p.beginShape();
                p.vertex(ax, ay);
                p.vertex(bx, by);
                p.vertex(bx, by + sideB * scale);
                p.vertex(ax, ay + sideB * scale);
                p.endShape(p.CLOSE);

                // Square on hypotenuse (angled)
                var angle = Math.atan2(sideB, sideA);
                p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.push();
                p.translate((ax + bx) / 2, (cy + by) / 2);
                p.rotate(-angle);
                p.translate(sideC * scale / 2, 0);
                p.rect(-sideC * scale / 2, -sideC * scale / 2, sideC * scale, sideC * scale);
                p.pop();

                // Area labels on squares
                if (state.showLabels !== false) {
                    p.fill(C.sin);
                    p.noStroke();
                    p.textSize(14);
                    p.textAlign(p.CENTER, p.CENTER);
                    p.text('a² = ' + (sideA * sideA).toFixed(1), ax - sideA * scale / 2, (ay + cy) / 2);

                    p.fill(C.cos);
                    p.text('b² = ' + (sideB * sideB).toFixed(1), (ax + bx) / 2, ay + sideB * scale / 2);

                    p.fill(C.accent);
                    p.push();
                    p.translate((ax + bx) / 2, (cy + by) / 2);
                    p.rotate(-angle);
                    p.translate(sideC * scale / 2, 0);
                    p.text('c² = ' + (sideC * sideC).toFixed(1), 0, 0);
                    p.pop();
                }
            }

            // Draw the triangle
            p.fill(C.bg[0], C.bg[1], C.bg[2], 200);
            p.stroke(C.text);
            p.strokeWeight(3);
            p.triangle(ax, ay, bx, by, cx, cy);

            // Right angle indicator
            var cornerSize = 15;
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.noFill();
            p.beginShape();
            p.vertex(bx - cornerSize, by);
            p.vertex(bx - cornerSize, by - cornerSize);
            p.vertex(bx, by - cornerSize);
            p.endShape();

            // Side labels
            if (state.showLabels !== false) {
                p.fill(C.sin);
                p.noStroke();
                p.textSize(16);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('a = ' + sideA.toFixed(1), ax - 20, (ay + cy) / 2);

                p.fill(C.cos);
                p.text('b = ' + sideB.toFixed(1), (ax + bx) / 2, by + 20);

                p.fill(C.accent);
                var midX = (ax + cx) / 2;
                var midY = (ay + cy) / 2;
                p.text('c = ' + sideC.toFixed(1), midX - 20, midY - 20);
            }

            // Vertices (draggable points)
            p.fill(C.point);
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.ellipse(ax, ay, 12, 12);
            p.ellipse(bx, by, 12, 12);
            p.ellipse(cx, cy, 12, 12);

            p.pop();
        }

        function onPress() {
            var mx = p.mouseX - W / 2;
            var my = p.mouseY - H / 2;
            var ax = -sideA * scale / 2;
            var ay = sideB * scale / 2;
            var bx = sideA * scale / 2;
            var by = sideB * scale / 2;
            var cx = sideA * scale / 2;
            var cy = -sideB * scale / 2;

            if (dist(mx, my, ax, ay) < 20) dragging = 'A';
            else if (dist(mx, my, bx, by) < 20) dragging = 'B';
            else if (dist(mx, my, cx, cy) < 20) dragging = 'C';

            if (dragging) p.loop();
            return false;
        }

        function onRelease() {
            dragging = null;
        }

        function handleDrag() {
            var mx = p.mouseX - W / 2;
            var my = p.mouseY - H / 2;

            if (dragging === 'A') {
                sideB = Math.max(3, Math.min(12, -my / scale));
                syncSliders();
            } else if (dragging === 'B') {
                sideA = Math.max(3, Math.min(12, mx / scale));
                syncSliders();
            } else if (dragging === 'C') {
                sideA = Math.max(3, Math.min(12, mx / scale));
                sideB = Math.max(3, Math.min(12, -my / scale));
                syncSliders();
            }
        }

        function dist(x1, y1, x2, y2) {
            return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        }

        p.mouseDragged = function () {
            if (dragging) return false;
        };

        p.touchMoved = function () {
            if (dragging) return false;
        };

        function syncSliders() {
            var sliderA = document.getElementById('side-a-slider');
            var sliderB = document.getElementById('side-b-slider');
            if (sliderA) {
                sliderA.value = sideA;
                document.getElementById('side-a-display').textContent = sideA.toFixed(1);
            }
            if (sliderB) {
                sliderB.value = sideB;
                document.getElementById('side-b-display').textContent = sideB.toFixed(1);
            }
        }

        function syncValues() {
            var sideC = Math.sqrt(sideA * sideA + sideB * sideB);
            var a2 = sideA * sideA;
            var b2 = sideB * sideB;
            var c2 = sideC * sideC;
            var sum = a2 + b2;
            var isValid = Math.abs(sum - c2) < 0.01;

            setEl('val-a', sideA.toFixed(1));
            setEl('val-b', sideB.toFixed(1));
            setEl('val-c', sideC.toFixed(2));
            setEl('val-a2', a2.toFixed(1));
            setEl('val-b2', b2.toFixed(1));
            setEl('val-c2', c2.toFixed(1));
            setEl('val-sum', sum.toFixed(1));
            setEl('val-check', isValid ? '✓' : '✗');
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
        state._setSideA = function (val) {
            sideA = val;
            syncSliders();
            p.loop();
        };
        state._setSideB = function (val) {
            sideB = val;
            syncSliders();
            p.loop();
        };
    }

    VisualMath.register('pythagorean', pythagoreanViz);
})();
