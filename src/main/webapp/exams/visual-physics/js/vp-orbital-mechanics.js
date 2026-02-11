/**
 * Visual Physics — Orbital Mechanics Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function orbitalViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = false;
        var trueAnomaly = 0;
        var trailPoints = [];
        var sweepStart = 0;
        var sweepPoints = [];
        var G_SUN = 4 * Math.PI * Math.PI; // AU^3/yr^2 for M=1 M_sun

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

        function getA() { return state.semiMajor || 1; }
        function getE() { return state.eccentricity || 0.017; }
        function getM() { return state.centralMass || 1; }

        function calcPeriod() {
            var a = getA(), M = getM();
            return Math.sqrt(a * a * a / M); // years
        }

        function orbitRadius(theta) {
            var a = getA(), e = getE();
            return a * (1 - e * e) / (1 + e * Math.cos(theta));
        }

        function perihelion() { return getA() * (1 - getE()); }
        function aphelion() { return getA() * (1 + getE()); }

        function visViva(r) {
            var a = getA(), M = getM();
            return Math.sqrt(G_SUN * M * (2 / r - 1 / a));
        }

        function escapeVelocity(r) {
            return Math.sqrt(2 * G_SUN * getM() / r);
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var a = getA(), e = getE(), M = getM();
            var cx = W * 0.45, cy = H / 2;

            // Scale: fit orbit in view
            var maxR = aphelion();
            var scale = Math.min(W * 0.38, H * 0.38) / Math.max(maxR, 1);

            // Gravitational field (optional faint radial)
            if (state.showField) {
                p.noFill();
                for (var ri = 1; ri <= 6; ri++) {
                    p.stroke(C.grid); p.strokeWeight(0.5);
                    p.ellipse(cx, cy, ri * scale * maxR / 3, ri * scale * maxR / 3);
                }
            }

            // Orbit trace
            if (state.showTrace !== false) {
                p.stroke(C.muted); p.strokeWeight(1); p.noFill();
                p.beginShape();
                for (var th = 0; th < Math.PI * 2; th += 0.02) {
                    var r = orbitRadius(th);
                    var ox = cx + r * scale * Math.cos(th);
                    var oy = cy - r * scale * Math.sin(th);
                    p.vertex(ox, oy);
                }
                p.endShape(p.CLOSE);
            }

            // Active trail
            if (trailPoints.length > 1) {
                p.stroke(C.sin); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var ti = 0; ti < trailPoints.length; ti++) {
                    p.vertex(trailPoints[ti].x, trailPoints[ti].y);
                }
                p.endShape();
            }

            // Kepler sweep area
            if (state.showSweep && sweepPoints.length > 2) {
                p.fill(C.accent[0] || 99, C.accent[1] || 102, C.accent[2] || 241, 30);
                p.stroke(C.accent[0] || 99, C.accent[1] || 102, C.accent[2] || 241, 80);
                p.strokeWeight(0.5);
                p.beginShape();
                p.vertex(cx, cy);
                for (var si = 0; si < sweepPoints.length; si++) {
                    p.vertex(sweepPoints[si].x, sweepPoints[si].y);
                }
                p.endShape(p.CLOSE);
            }

            // Planet
            var curR = orbitRadius(trueAnomaly);
            var px = cx + curR * scale * Math.cos(trueAnomaly);
            var py = cy - curR * scale * Math.sin(trueAnomaly);

            p.fill(59, 130, 246); p.stroke(255); p.strokeWeight(1.5);
            p.ellipse(px, py, 12, 12);

            // Velocity vector
            if (state.showVelocity) {
                var v = visViva(curR);
                // Velocity is tangent to orbit
                var dr = orbitRadius(trueAnomaly + 0.01);
                var dx = dr * Math.cos(trueAnomaly + 0.01) - curR * Math.cos(trueAnomaly);
                var dy = -(dr * Math.sin(trueAnomaly + 0.01) - curR * Math.sin(trueAnomaly));
                var mag = Math.sqrt(dx * dx + dy * dy);
                if (mag > 0) {
                    dx /= mag; dy /= mag;
                    var vLen = v * scale * 0.3;
                    p.stroke(34, 197, 94); p.strokeWeight(2);
                    p.line(px, py, px + dx * vLen, py + dy * vLen);
                    drawArrow(p, px, py, px + dx * vLen, py + dy * vLen, [34, 197, 94]);
                }
            }

            // Sun
            p.fill(255, 200, 50); p.stroke(255, 150, 0); p.strokeWeight(2);
            p.ellipse(cx, cy, 20, 20);

            // Perihelion/aphelion markers
            var periX = cx + perihelion() * scale;
            var apoX = cx - aphelion() * scale;
            p.fill(C.muted); p.noStroke(); p.textSize(8);
            p.textAlign(p.CENTER, p.TOP);
            p.text('P', periX, cy + 12);
            p.text('A', apoX, cy + 12);
            p.stroke(C.muted); p.strokeWeight(1);
            p.point(periX, cy); p.point(apoX, cy);

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Orbital Mechanics', 8, 8);

            syncValues(curR);

            if (running) {
                // Kepler's equation: angular speed varies
                var period = calcPeriod();
                var n = 2 * Math.PI / period; // mean motion
                var dTheta = n * 0.002 * (a * a / (curR * curR)); // approximate angular speed
                trueAnomaly += dTheta;
                if (trueAnomaly > 2 * Math.PI) trueAnomaly -= 2 * Math.PI;

                var newR = orbitRadius(trueAnomaly);
                var npx = cx + newR * scale * Math.cos(trueAnomaly);
                var npy = cy - newR * scale * Math.sin(trueAnomaly);
                trailPoints.push({ x: npx, y: npy });
                if (trailPoints.length > 500) trailPoints.shift();

                // Sweep area tracking
                sweepPoints.push({ x: npx, y: npy });
                if (sweepPoints.length > 100) {
                    sweepPoints.shift();
                }
            } else {
                p.noLoop();
            }
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 7;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4));
        }

        function syncValues(curR) {
            setEl('val-semimajor', getA().toFixed(3) + ' AU');
            setEl('val-eccentricity', getE().toFixed(3));
            setEl('val-period', calcPeriod().toFixed(3) + ' yr');
            setEl('val-perihelion', perihelion().toFixed(3) + ' AU');
            setEl('val-aphelion', aphelion().toFixed(3) + ' AU');
            setEl('val-distance', curR.toFixed(3) + ' AU');
            setEl('val-speed', visViva(curR).toFixed(2) + ' AU/yr');
            setEl('val-escape', escapeVelocity(curR).toFixed(2) + ' AU/yr');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._play = function () { running = true; p.loop(); };
        state._pause = function () { running = false; };
        state._reset = function () { running = false; trueAnomaly = 0; trailPoints = []; sweepPoints = []; time = 0; p.loop(); };
        state._redraw = function () { trailPoints = []; sweepPoints = []; p.redraw(); };
    }

    VisualMath.register('orbital-mechanics', orbitalViz);
})();
