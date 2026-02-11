/**
 * Visual Math — Circle Theorems Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function circleTheoremsViz(p, container) {
        state = VisualMath.getState();
        var W, H, cx, cy, R;
        var dragging = null;
        var animating = false;
        var animSpeed = 0.01;

        // Points on circle (angles in radians)
        var points = {
            inscribed: [0.3, 2.5, 4.5],  // A, B, C
            central: [0.5, 3.0],          // A, B
            semicircle: [0, Math.PI, 2.5], // A (0), B (π), C
            tangent: [0.8],               // Point of tangency
            cyclic: [0.3, 1.5, 3.0, 4.5]  // A, B, C, D
        };
        var currentPoints = points.inscribed.slice();

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
            cx = W / 2;
            cy = H / 2;
            R = Math.min(W, H) * 0.35;
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

            if (animating) {
                currentPoints[0] += animSpeed;
                if (currentPoints[0] > Math.PI * 2) currentPoints[0] -= Math.PI * 2;
            }

            if (dragging !== null) {
                handleDrag();
            }

            drawTheorem(C);
            updateValues();

            if (!animating && dragging === null) p.noLoop();
        };

        function drawTheorem(C) {
            p.push();
            p.translate(cx, cy);

            // Draw circle
            p.noFill();
            p.stroke(C.circle);
            p.strokeWeight(2);
            p.ellipse(0, 0, R * 2, R * 2);

            // Draw center point
            p.fill(C.muted);
            p.noStroke();
            p.ellipse(0, 0, 6, 6);
            if (state.showLabels !== false) {
                p.fill(C.muted);
                p.textSize(12);
                p.textAlign(p.CENTER, p.TOP);
                p.text('O', 0, 8);
            }

            var theorem = state.theorem || 'inscribed';

            if (theorem === 'inscribed') {
                drawInscribedAngle(C);
            } else if (theorem === 'central') {
                drawCentralAngle(C);
            } else if (theorem === 'semicircle') {
                drawSemicircle(C);
            } else if (theorem === 'tangent') {
                drawTangent(C);
            } else if (theorem === 'cyclic') {
                drawCyclicQuad(C);
            }

            p.pop();
        }

        function drawInscribedAngle(C) {
            var A = currentPoints[0];
            var B = currentPoints[1];
            var C_pt = currentPoints[2];

            var ax = Math.cos(A) * R, ay = Math.sin(A) * R;
            var bx = Math.cos(B) * R, by = Math.sin(B) * R;
            var cx = Math.cos(C_pt) * R, cy = Math.sin(C_pt) * R;

            // Draw arc
            if (state.showArcs) {
                p.noFill();
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 100);
                p.strokeWeight(4);
                p.arc(0, 0, R * 2, R * 2, A, B);
            }

            // Draw chords
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.line(ax, ay, cx, cy);
            p.line(bx, by, cx, cy);

            // Draw central angle lines (dashed)
            p.drawingContext.setLineDash([4, 4]);
            p.stroke(C.cos);
            p.strokeWeight(1.5);
            p.line(0, 0, ax, ay);
            p.line(0, 0, bx, by);
            p.drawingContext.setLineDash([]);

            // Inscribed angle
            var inscribedAngle = Math.abs(Math.atan2(by - cy, bx - cx) - Math.atan2(ay - cy, ax - cx));
            if (inscribedAngle > Math.PI) inscribedAngle = 2 * Math.PI - inscribedAngle;

            // Central angle
            var centralAngle = Math.abs(B - A);
            if (centralAngle > Math.PI) centralAngle = 2 * Math.PI - centralAngle;

            // Draw angle arcs
            if (state.showAngles !== false) {
                // Inscribed angle arc
                p.noFill();
                p.stroke(C.sin);
                p.strokeWeight(2);
                var startA = Math.atan2(ay - cy, ax - cx);
                var endA = Math.atan2(by - cy, bx - cx);
                p.arc(cx, cy, 40, 40, startA, endA);

                // Central angle arc
                p.stroke(C.cos);
                p.arc(0, 0, 50, 50, A, B);

                // Angle labels
                if (state.showLabels !== false) {
                    p.fill(C.sin);
                    p.noStroke();
                    p.textSize(14);
                    p.textAlign(p.CENTER, p.CENTER);
                    p.text((inscribedAngle * 180 / Math.PI).toFixed(0) + '°', cx * 0.7, cy * 0.7);

                    p.fill(C.cos);
                    p.text((centralAngle * 180 / Math.PI).toFixed(0) + '°', 0, -30);
                }
            }

            // Draw points
            drawPoint(ax, ay, 'A', C);
            drawPoint(bx, by, 'B', C);
            drawPoint(cx, cy, 'C', C);
        }

        function drawCentralAngle(C) {
            var A = currentPoints[0];
            var B = currentPoints[1];

            var ax = Math.cos(A) * R, ay = Math.sin(A) * R;
            var bx = Math.cos(B) * R, by = Math.sin(B) * R;

            // Draw arc
            if (state.showArcs) {
                p.noFill();
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 100);
                p.strokeWeight(4);
                p.arc(0, 0, R * 2, R * 2, A, B);
            }

            // Draw radii
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.line(0, 0, ax, ay);
            p.line(0, 0, bx, by);

            // Central angle
            var centralAngle = Math.abs(B - A);
            if (centralAngle > Math.PI) centralAngle = 2 * Math.PI - centralAngle;

            // Draw angle arc
            if (state.showAngles !== false) {
                p.noFill();
                p.stroke(C.sin);
                p.strokeWeight(2);
                p.arc(0, 0, 60, 60, A, B);

                if (state.showLabels !== false) {
                    p.fill(C.sin);
                    p.noStroke();
                    p.textSize(14);
                    p.textAlign(p.CENTER, p.CENTER);
                    var midAngle = (A + B) / 2;
                    p.text((centralAngle * 180 / Math.PI).toFixed(0) + '°',
                        Math.cos(midAngle) * 40, Math.sin(midAngle) * 40);
                }
            }

            drawPoint(ax, ay, 'A', C);
            drawPoint(bx, by, 'B', C);
        }

        function drawSemicircle(C) {
            var A = currentPoints[0];
            var B = currentPoints[1];
            var C_pt = currentPoints[2];

            var ax = Math.cos(A) * R, ay = Math.sin(A) * R;
            var bx = Math.cos(B) * R, by = Math.sin(B) * R;
            var cx = Math.cos(C_pt) * R, cy = Math.sin(C_pt) * R;

            // Draw diameter
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.line(ax, ay, bx, by);

            // Draw triangle
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.line(ax, ay, cx, cy);
            p.line(bx, by, cx, cy);

            // Right angle indicator
            var angle = Math.atan2(by - cy, bx - cx) - Math.atan2(ay - cy, ax - cx);
            var cornerSize = 20;
            p.noFill();
            p.stroke(C.sin);
            p.strokeWeight(2);
            var dir1x = Math.cos(Math.atan2(ay - cy, ax - cx)) * cornerSize;
            var dir1y = Math.sin(Math.atan2(ay - cy, ax - cx)) * cornerSize;
            var dir2x = Math.cos(Math.atan2(by - cy, bx - cx)) * cornerSize;
            var dir2y = Math.sin(Math.atan2(by - cy, bx - cx)) * cornerSize;
            p.beginShape();
            p.vertex(cx + dir1x, cy + dir1y);
            p.vertex(cx + dir1x + dir2x, cy + dir1y + dir2y);
            p.vertex(cx + dir2x, cy + dir2y);
            p.endShape();

            if (state.showLabels !== false) {
                p.fill(C.sin);
                p.noStroke();
                p.textSize(14);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('90°', cx - 25, cy - 25);
            }

            drawPoint(ax, ay, 'A', C);
            drawPoint(bx, by, 'B', C);
            drawPoint(cx, cy, 'C', C);
        }

        function drawTangent(C) {
            var A = currentPoints[0];
            var ax = Math.cos(A) * R, ay = Math.sin(A) * R;

            // Draw radius
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.line(0, 0, ax, ay);

            // Draw tangent line (perpendicular to radius)
            var tangentAngle = A + Math.PI / 2;
            var tx1 = ax + Math.cos(tangentAngle) * R * 0.8;
            var ty1 = ay + Math.sin(tangentAngle) * R * 0.8;
            var tx2 = ax - Math.cos(tangentAngle) * R * 0.8;
            var ty2 = ay - Math.sin(tangentAngle) * R * 0.8;

            p.stroke(C.cos);
            p.strokeWeight(2);
            p.line(tx1, ty1, tx2, ty2);

            // Right angle indicator
            var cornerSize = 15;
            p.noFill();
            p.stroke(C.accent);
            p.strokeWeight(2);
            var dir1x = Math.cos(A) * cornerSize;
            var dir1y = Math.sin(A) * cornerSize;
            var dir2x = Math.cos(tangentAngle) * cornerSize;
            var dir2y = Math.sin(tangentAngle) * cornerSize;
            p.beginShape();
            p.vertex(ax - dir1x + dir2x, ay - dir1y + dir2y);
            p.vertex(ax - dir1x, ay - dir1y);
            p.vertex(ax - dir1x - dir2x, ay - dir1y - dir2y);
            p.endShape();

            if (state.showLabels !== false) {
                p.fill(C.accent);
                p.noStroke();
                p.textSize(14);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('90°', ax - dir1x * 2, ay - dir1y * 2);

                p.fill(C.sin);
                p.text('Radius', ax / 2, ay / 2 - 15);

                p.fill(C.cos);
                p.text('Tangent', (tx1 + ax) / 2, (ty1 + ay) / 2 + 15);
            }

            drawPoint(ax, ay, 'A', C);
        }

        function drawCyclicQuad(C) {
            var A = currentPoints[0];
            var B = currentPoints[1];
            var C_pt = currentPoints[2];
            var D = currentPoints[3];

            var ax = Math.cos(A) * R, ay = Math.sin(A) * R;
            var bx = Math.cos(B) * R, by = Math.sin(B) * R;
            var cx = Math.cos(C_pt) * R, cy = Math.sin(C_pt) * R;
            var dx = Math.cos(D) * R, dy = Math.sin(D) * R;

            // Draw quadrilateral
            p.fill(C.accent[0], C.accent[1], C.accent[2], 20);
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.beginShape();
            p.vertex(ax, ay);
            p.vertex(bx, by);
            p.vertex(cx, cy);
            p.vertex(dx, dy);
            p.endShape(p.CLOSE);

            // Calculate opposite angles
            var angleA = calcAngle(dx, dy, ax, ay, bx, by);
            var angleC = calcAngle(bx, by, cx, cy, dx, dy);

            if (state.showAngles !== false && state.showLabels !== false) {
                p.fill(C.sin);
                p.noStroke();
                p.textSize(14);
                p.textAlign(p.CENTER, p.CENTER);
                p.text((angleA * 180 / Math.PI).toFixed(0) + '°', ax * 0.7, ay * 0.7);
                p.text((angleC * 180 / Math.PI).toFixed(0) + '°', cx * 0.7, cy * 0.7);
            }

            drawPoint(ax, ay, 'A', C);
            drawPoint(bx, by, 'B', C);
            drawPoint(cx, cy, 'C', C);
            drawPoint(dx, dy, 'D', C);
        }

        function calcAngle(x1, y1, x2, y2, x3, y3) {
            var angle1 = Math.atan2(y1 - y2, x1 - x2);
            var angle2 = Math.atan2(y3 - y2, x3 - x2);
            var diff = Math.abs(angle2 - angle1);
            if (diff > Math.PI) diff = 2 * Math.PI - diff;
            return diff;
        }

        function drawPoint(x, y, label, C) {
            p.fill(C.point);
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.ellipse(x, y, 12, 12);

            if (state.showLabels !== false) {
                p.fill(C.text);
                p.noStroke();
                p.textSize(14);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text(label, x, y - 12);
            }
        }

        function onPress() {
            var mx = p.mouseX - cx;
            var my = p.mouseY - cy;

            for (var i = 0; i < currentPoints.length; i++) {
                var px = Math.cos(currentPoints[i]) * R;
                var py = Math.sin(currentPoints[i]) * R;
                if (dist(mx, my, px, py) < 20) {
                    dragging = i;
                    p.loop();
                    return false;
                }
            }
        }

        function onRelease() {
            dragging = null;
        }

        function handleDrag() {
            var mx = p.mouseX - cx;
            var my = p.mouseY - cy;
            var angle = Math.atan2(my, mx);
            if (angle < 0) angle += 2 * Math.PI;

            // Special handling for semicircle - keep A and B fixed
            if (state.theorem === 'semicircle' && (dragging === 0 || dragging === 1)) {
                return;
            }

            currentPoints[dragging] = angle;
        }

        function dist(x1, y1, x2, y2) {
            return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        }

        p.mouseDragged = function () {
            if (dragging !== null) return false;
        };

        p.touchMoved = function () {
            if (dragging !== null) return false;
        };

        function updateValues() {
            var theorem = state.theorem || 'inscribed';

            if (theorem === 'inscribed') {
                var inscribed = Math.abs(Math.atan2(Math.sin(currentPoints[1]) * R - Math.sin(currentPoints[2]) * R,
                    Math.cos(currentPoints[1]) * R - Math.cos(currentPoints[2]) * R) -
                    Math.atan2(Math.sin(currentPoints[0]) * R - Math.sin(currentPoints[2]) * R,
                        Math.cos(currentPoints[0]) * R - Math.cos(currentPoints[2]) * R));
                if (inscribed > Math.PI) inscribed = 2 * Math.PI - inscribed;
                var central = Math.abs(currentPoints[1] - currentPoints[0]);
                if (central > Math.PI) central = 2 * Math.PI - central;

                setEl('label-1', 'Inscribed ∠');
                setEl('label-2', 'Central ∠');
                setEl('label-3', 'Relation');
                setEl('label-4', 'Arc');
                setEl('val-1', (inscribed * 180 / Math.PI).toFixed(1) + '°');
                setEl('val-2', (central * 180 / Math.PI).toFixed(1) + '°');
                setEl('val-3', '∠inscribed = ∠central/2');
                setEl('val-4', (central * 180 / Math.PI).toFixed(1) + '°');
            } else if (theorem === 'cyclic') {
                var angleA = calcAngle(Math.cos(currentPoints[3]) * R, Math.sin(currentPoints[3]) * R,
                    Math.cos(currentPoints[0]) * R, Math.sin(currentPoints[0]) * R,
                    Math.cos(currentPoints[1]) * R, Math.sin(currentPoints[1]) * R);
                var angleC = calcAngle(Math.cos(currentPoints[1]) * R, Math.sin(currentPoints[1]) * R,
                    Math.cos(currentPoints[2]) * R, Math.sin(currentPoints[2]) * R,
                    Math.cos(currentPoints[3]) * R, Math.sin(currentPoints[3]) * R);

                setEl('label-1', '∠A');
                setEl('label-2', '∠C');
                setEl('label-3', 'Sum');
                setEl('label-4', 'Property');
                setEl('val-1', (angleA * 180 / Math.PI).toFixed(1) + '°');
                setEl('val-2', (angleC * 180 / Math.PI).toFixed(1) + '°');
                setEl('val-3', ((angleA + angleC) * 180 / Math.PI).toFixed(1) + '°');
                setEl('val-4', '∠A + ∠C = 180°');
            }
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
        state._changeTheorem = function (theorem) {
            currentPoints = points[theorem].slice();
            p.loop();
        };
        state._toggleAnim = function () {
            animating = !animating;
            p.loop();
            return animating;
        };
        state._isAnimating = function () {
            return animating;
        };
        state._reset = function () {
            currentPoints = points[state.theorem || 'inscribed'].slice();
            p.loop();
        };
    }

    VisualMath.register('circle-theorems', circleTheoremsViz);
})();
