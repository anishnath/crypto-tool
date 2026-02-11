/**
 * Visual Physics — Snell's Law / Refraction Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function snellViz(p, container) {
        var state = VisualMath.getState();
        var W, H;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); state._redraw(); };

        function getN1() { return state.n1 || 1.0; }
        function getN2() { return state.n2 || 1.5; }
        function getIncident() { return (state.incidentAngle || 30) * Math.PI / 180; }

        function calcRefracted() {
            var n1 = getN1(), n2 = getN2(), theta1 = getIncident();
            var sinTheta2 = n1 * Math.sin(theta1) / n2;
            if (Math.abs(sinTheta2) > 1) return null; // TIR
            return Math.asin(sinTheta2);
        }

        function calcCritical() {
            var n1 = getN1(), n2 = getN2();
            if (n1 <= n2) return null;
            return Math.asin(n2 / n1);
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var cx = W / 2, cy = H / 2;
            var n1 = getN1(), n2 = getN2();
            var theta1 = getIncident();
            var theta2 = calcRefracted();
            var tir = theta2 === null;

            // Interface line
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(0, cy, W, cy);

            // Medium labels
            p.fill(C.text); p.noStroke(); p.textSize(13); p.textAlign(p.LEFT, p.TOP);
            p.text('n\u2081 = ' + n1.toFixed(2), 10, 10);
            p.textAlign(p.LEFT, p.BOTTOM);
            p.text('n\u2082 = ' + n2.toFixed(2), 10, H - 10);

            // Medium shading
            var isDark = VisualMath.isDark();
            p.noStroke();
            p.fill(isDark ? 'rgba(59,130,246,0.06)' : 'rgba(59,130,246,0.05)');
            p.rect(0, 0, W, cy);
            p.fill(isDark ? 'rgba(59,130,246,0.15)' : 'rgba(59,130,246,0.12)');
            p.rect(0, cy, W, cy);

            // Normal line
            if (state.showNormal !== false) {
                p.stroke(C.muted); p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                p.line(cx, 0, cx, H);
                p.drawingContext.setLineDash([]);
            }

            var rayLen = Math.min(W, H) * 0.4;

            // Incident ray (coming from upper-left toward center)
            var ix = cx - rayLen * Math.sin(theta1);
            var iy = cy - rayLen * Math.cos(theta1);
            p.stroke(239, 68, 68); p.strokeWeight(2.5);
            p.line(ix, iy, cx, cy);
            drawArrow(p, ix, iy, cx, cy, [239, 68, 68]);

            // Reflected ray
            if (state.showReflected !== false) {
                var rx = cx + rayLen * Math.sin(theta1);
                var ry = cy - rayLen * Math.cos(theta1);
                p.stroke(C.muted[0] || 148, C.muted[1] || 163, C.muted[2] || 184, 160);
                p.strokeWeight(1.5);
                p.drawingContext.setLineDash([6, 4]);
                p.line(cx, cy, rx, ry);
                p.drawingContext.setLineDash([]);
            }

            // Refracted ray or TIR
            if (tir) {
                // Total internal reflection
                var trx = cx + rayLen * Math.sin(theta1);
                var try_ = cy - rayLen * Math.cos(theta1);
                p.stroke(59, 130, 246); p.strokeWeight(2.5);
                p.line(cx, cy, trx, try_);
                drawArrow(p, cx, cy, trx, try_, [59, 130, 246]);

                p.fill(239, 68, 68); p.noStroke(); p.textSize(14); p.textAlign(p.CENTER, p.TOP);
                p.text('Total Internal Reflection', cx, cy + 20);
            } else {
                var refX = cx + rayLen * Math.sin(theta2);
                var refY = cy + rayLen * Math.cos(theta2);
                p.stroke(59, 130, 246); p.strokeWeight(2.5);
                p.line(cx, cy, refX, refY);
                drawArrow(p, cx, cy, refX, refY, [59, 130, 246]);
            }

            // Angle labels
            if (state.showLabels !== false) {
                p.noFill(); p.strokeWeight(1.5);
                // Incident angle arc
                p.stroke(239, 68, 68, 180);
                var arcR = 40;
                p.arc(cx, cy, arcR * 2, arcR * 2, -Math.PI / 2 - theta1, -Math.PI / 2);
                p.fill(239, 68, 68); p.noStroke(); p.textSize(11); p.textAlign(p.LEFT, p.BOTTOM);
                var labelX1 = cx + (arcR + 8) * Math.sin(theta1 / 2);
                var labelY1 = cy - (arcR + 8) * Math.cos(theta1 / 2);
                p.text('\u03B8\u2081=' + (state.incidentAngle || 30) + '\u00B0', labelX1 - 30, labelY1);

                if (!tir && theta2 !== null) {
                    p.noFill(); p.stroke(59, 130, 246, 180); p.strokeWeight(1.5);
                    p.arc(cx, cy, arcR * 2, arcR * 2, Math.PI / 2, Math.PI / 2 + theta2);
                    p.fill(59, 130, 246); p.noStroke(); p.textSize(11); p.textAlign(p.LEFT, p.TOP);
                    var labelX2 = cx + (arcR + 8) * Math.sin(theta2 / 2);
                    var labelY2 = cy + (arcR + 8) * Math.cos(theta2 / 2);
                    p.text('\u03B8\u2082=' + (theta2 * 180 / Math.PI).toFixed(1) + '\u00B0', labelX2 - 30, labelY2);
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text("Snell's Law", 8, 8);

            syncValues();
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 8;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(
                x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4)
            );
        }

        function syncValues() {
            var n1 = getN1(), n2 = getN2();
            var theta1 = state.incidentAngle || 30;
            var theta1Rad = theta1 * Math.PI / 180;
            var theta2 = calcRefracted();
            var thetaC = calcCritical();
            var tir = theta2 === null;

            setEl('val-incident', theta1 + '\u00B0');
            setEl('val-n1', n1.toFixed(2));
            setEl('val-n2', n2.toFixed(2));
            setEl('val-refracted', tir ? 'TIR' : (theta2 * 180 / Math.PI).toFixed(1) + '\u00B0');
            setEl('val-critical', thetaC !== null ? (thetaC * 180 / Math.PI).toFixed(1) + '\u00B0' : 'N/A');
            setEl('val-tir', tir ? 'Yes' : 'No');
            setEl('val-speedratio', (n1 / n2).toFixed(3));
            setEl('val-snell', (n1 * Math.sin(theta1Rad)).toFixed(4));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('snells-law', snellViz);
})();
