/**
 * Visual Physics — Inclined Plane & Forces Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function inclinedPlaneViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var animT = 0;
        var animating = false;
        var blockPos = 0; // 0 to 1, position along ramp

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

        function getAngle() { return (state.angle || 30) * Math.PI / 180; }
        function getMass() { return state.mass || 5; }
        function getMu() { return state.mu || 0.2; }
        function getG() { return 9.8; }

        function calcAccel() {
            var theta = getAngle(), mu = getMu(), g = getG();
            var a = g * (Math.sin(theta) - mu * Math.cos(theta));
            return Math.max(0, a);
        }

        function willSlide() {
            var theta = getAngle(), mu = getMu();
            return Math.tan(theta) > mu;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var pad = 40;
            var theta = getAngle();
            var mass = getMass();
            var mu = getMu();
            var g = getG();

            // Ramp geometry
            var rampLen = Math.min(W - pad * 2, H - pad * 2) * 0.85;
            var baseX = pad + 20;
            var baseY = H - pad - 20;
            var topX = baseX + rampLen * Math.cos(theta);
            var topY = baseY - rampLen * Math.sin(theta);

            // Draw ground
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(pad, baseY, W - pad, baseY);

            // Draw ramp
            p.stroke(C.text); p.strokeWeight(3);
            p.line(baseX, baseY, topX, topY);
            p.line(baseX, baseY, topX, baseY); // horizontal base

            // Angle arc
            p.noFill(); p.stroke(C.accent); p.strokeWeight(1.5);
            var arcR = 35;
            p.arc(baseX, baseY, arcR * 2, arcR * 2, -theta, 0);
            p.fill(C.text); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.BOTTOM);
            p.text((state.angle || 30) + '\u00B0', baseX + arcR + 4, baseY - 5);

            // Block on ramp
            var blockSize = 30;
            var posAlongRamp = 0.3 + blockPos * 0.5; // fraction along ramp
            var bx = baseX + posAlongRamp * rampLen * Math.cos(theta);
            var by = baseY - posAlongRamp * rampLen * Math.sin(theta);

            p.push();
            p.translate(bx, by);
            p.rotate(-theta);
            p.fill(C.accent); p.stroke(C.text); p.strokeWeight(1);
            p.rect(-blockSize / 2, -blockSize, blockSize, blockSize);
            p.fill(C.bg); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.CENTER);
            p.text(mass + 'kg', 0, -blockSize / 2);
            p.pop();

            // Force arrows (FBD)
            if (state.showFBD) {
                var arrowScale = 2.5;
                var weight = mass * g;
                var normal = weight * Math.cos(theta);
                var parallel = weight * Math.sin(theta);
                var friction = mu * normal;

                // Weight (straight down)
                drawForceArrow(p, bx, by, bx, by + weight * arrowScale / g * 3, [239, 68, 68], 'mg');

                // Normal (perpendicular to surface, away)
                var nx = -Math.sin(theta);
                var ny = -Math.cos(theta);
                drawForceArrow(p, bx, by, bx + nx * normal * arrowScale / g * 3, by + ny * normal * arrowScale / g * 3, [59, 130, 246], 'N');

                // Friction (up the ramp if sliding down)
                if (mu > 0) {
                    var fx = -Math.cos(theta);
                    var fy = Math.sin(theta);
                    drawForceArrow(p, bx, by, bx + fx * friction * arrowScale / g * 3, by + fy * friction * arrowScale / g * 3, [34, 197, 94], 'f');
                }
            }

            // Force components
            if (state.showComponents) {
                var weight2 = mass * g;
                var arrowScale2 = 2.5;
                // mg sin θ (down the ramp)
                var dxR = Math.cos(theta);
                var dyR = -Math.sin(theta);
                var mgSin = weight2 * Math.sin(theta);
                drawForceArrow(p, bx, by, bx + dxR * mgSin * arrowScale2 / g * 3, by - dyR * mgSin * arrowScale2 / g * 3, [249, 115, 22], 'mg sin\u03B8');

                // mg cos θ (into surface)
                var mgCos = weight2 * Math.cos(theta);
                var nx2 = Math.sin(theta);
                var ny2 = Math.cos(theta);
                drawForceArrow(p, bx, by, bx + nx2 * mgCos * arrowScale2 / g * 3, by + ny2 * mgCos * arrowScale2 / g * 3, [168, 85, 247], 'mg cos\u03B8');
            }

            // Acceleration indicator
            if (state.showAccel && willSlide()) {
                var accel = calcAccel();
                var ax = Math.cos(theta);
                var ay = -Math.sin(theta);
                var aScale = accel * 5;
                p.stroke(239, 68, 68); p.strokeWeight(3);
                p.line(bx, by - blockSize - 5, bx + ax * aScale, by - blockSize - 5 + ay * aScale);
                p.fill(239, 68, 68); p.noStroke(); p.textSize(10);
                p.text('a=' + accel.toFixed(2) + ' m/s\u00B2', bx + ax * aScale + 5, by - blockSize - 10 + ay * aScale);
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Inclined Plane', 8, 8);

            syncValues();

            if (animating && willSlide()) {
                blockPos = Math.min(1, blockPos + 0.005 * calcAccel());
                if (blockPos >= 1) { animating = false; p.noLoop(); }
            } else if (!animating) {
                p.noLoop();
            }
        };

        function drawForceArrow(p, x1, y1, x2, y2, col, label) {
            p.stroke(col[0], col[1], col[2]); p.strokeWeight(2);
            p.line(x1, y1, x2, y2);
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 7;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(
                x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4)
            );
            if (label) {
                p.textSize(10); p.textAlign(p.LEFT, p.CENTER);
                p.text(label, x2 + 5, y2);
            }
        }

        function syncValues() {
            var theta = state.angle || 30;
            var thetaRad = theta * Math.PI / 180;
            var mass = getMass();
            var mu = getMu();
            var g = getG();
            var weight = mass * g;

            setEl('val-angle', theta + '\u00B0');
            setEl('val-mass', mass + ' kg');
            setEl('val-weight', weight.toFixed(1) + ' N');
            setEl('val-normal', (weight * Math.cos(thetaRad)).toFixed(1) + ' N');
            setEl('val-mgsin', (weight * Math.sin(thetaRad)).toFixed(1) + ' N');
            setEl('val-mgcos', (weight * Math.cos(thetaRad)).toFixed(1) + ' N');
            setEl('val-friction', (mu * weight * Math.cos(thetaRad)).toFixed(1) + ' N');
            var netF = weight * Math.sin(thetaRad) - mu * weight * Math.cos(thetaRad);
            setEl('val-netforce', Math.max(0, netF).toFixed(1) + ' N');
            setEl('val-accel', calcAccel().toFixed(2) + ' m/s\u00B2');
            setEl('val-slide', willSlide() ? 'Yes' : 'No');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._release = function () { animating = true; blockPos = 0; p.loop(); };
        state._reset = function () { animating = false; blockPos = 0; p.loop(); };
        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('inclined-plane', inclinedPlaneViz);
})();
