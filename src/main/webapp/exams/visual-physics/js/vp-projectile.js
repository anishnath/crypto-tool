/**
 * Visual Physics — Projectile Motion Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function projectileViz(p, container) {
        var state = VisualMath.getState();
        var W, H, pad = 50;
        var trail = [];
        var ghosts = [];
        var t = 0;
        var launched = false;
        var completed = false;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getG() { return state.gravity || 9.8; }
        function getAngle() { return (state.angle || 45) * Math.PI / 180; }
        function getV0() { return state.v0 || 25; }

        function calcRange() {
            var v = getV0(), a = getAngle(), g = getG();
            return v * v * Math.sin(2 * a) / g;
        }
        function calcMaxH() {
            var v = getV0(), a = getAngle(), g = getG();
            return v * v * Math.sin(a) * Math.sin(a) / (2 * g);
        }
        function calcTOF() {
            var v = getV0(), a = getAngle(), g = getG();
            return 2 * v * Math.sin(a) / g;
        }
        function posAt(tt) {
            var v = getV0(), a = getAngle(), g = getG();
            var x = v * Math.cos(a) * tt;
            var y = v * Math.sin(a) * tt - 0.5 * g * tt * tt;
            return { x: x, y: Math.max(0, y) };
        }

        function worldToScreen(wx, wy, scX, scY, ox, oy) {
            return { x: ox + wx * scX, y: oy - wy * scY };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad, oy = pad + gh;

            // Determine scale
            var R = Math.max(calcRange(), 10);
            var MH = Math.max(calcMaxH(), 5);
            var scX = gw / (R * 1.15);
            var scY = gh / (MH * 1.3);

            // Ground
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(ox, oy, ox + gw, oy);

            // Grid lines
            p.stroke(C.grid); p.strokeWeight(0.5);
            var stepX = R / 5;
            for (var i = 0; i <= 5; i++) {
                var gx = ox + i * stepX * scX;
                p.line(gx, pad, gx, oy);
                p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                p.text((i * stepX).toFixed(1) + 'm', gx, oy + 4);
                p.stroke(C.grid); p.strokeWeight(0.5);
            }
            var stepY = MH / 4;
            for (var j = 0; j <= 4; j++) {
                var gy = oy - j * stepY * scY;
                p.line(ox, gy, ox + gw, gy);
                if (j > 0) {
                    p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.RIGHT, p.CENTER);
                    p.text((j * stepY).toFixed(1) + 'm', ox - 4, gy);
                    p.stroke(C.grid); p.strokeWeight(0.5);
                }
            }

            // Full trajectory (faded)
            p.stroke(C.muted[0] || 148, C.muted[1] || 163, C.muted[2] || 184, 60);
            p.strokeWeight(1); p.noFill();
            var tof = calcTOF();
            p.beginShape();
            for (var dt = 0; dt <= tof; dt += tof / 100) {
                var pp = posAt(dt);
                var sp = worldToScreen(pp.x, pp.y, scX, scY, ox, oy);
                p.vertex(sp.x, sp.y);
            }
            p.endShape();

            // Trail
            if (state.showTrail !== false && trail.length > 1) {
                p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
                p.beginShape();
                for (var k = 0; k < trail.length; k++) {
                    var sp2 = worldToScreen(trail[k].x, trail[k].y, scX, scY, ox, oy);
                    p.vertex(sp2.x, sp2.y);
                }
                p.endShape();
            }

            // Ghost markers
            if (state.showMarkers !== false && ghosts.length > 0) {
                for (var m = 0; m < ghosts.length; m++) {
                    var gp = worldToScreen(ghosts[m].x, ghosts[m].y, scX, scY, ox, oy);
                    p.fill(C.accent[0], C.accent[1], C.accent[2], 100);
                    p.noStroke();
                    p.ellipse(gp.x, gp.y, 8, 8);
                }
            }

            // Current position
            if (launched) {
                var pos = posAt(t);
                var sc = worldToScreen(pos.x, pos.y, scX, scY, ox, oy);

                // Velocity vectors
                if (state.showVelocity !== false) {
                    var v0 = getV0(), a = getAngle(), g = getG();
                    var vx = v0 * Math.cos(a);
                    var vy = v0 * Math.sin(a) - g * t;
                    var vScale = 1.5;

                    // Horizontal component (blue)
                    p.stroke(C.cos); p.strokeWeight(2);
                    p.line(sc.x, sc.y, sc.x + vx * vScale, sc.y);
                    drawArrow(p, sc.x, sc.y, sc.x + vx * vScale, sc.y, C.cos);

                    // Vertical component (red)
                    p.stroke(C.sin); p.strokeWeight(2);
                    p.line(sc.x, sc.y, sc.x, sc.y - vy * vScale);
                    drawArrow(p, sc.x, sc.y, sc.x, sc.y - vy * vScale, C.sin);
                }

                // Ball
                p.fill(C.accent); p.noStroke();
                p.ellipse(sc.x, sc.y, 14, 14);
            }

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Projectile Motion', pad + 4, 8);

            syncValues();

            if (launched && !completed) {
                t += 0.02;
                var pos2 = posAt(t);
                trail.push({ x: pos2.x, y: pos2.y });
                // Add ghost every tof/8
                if (ghosts.length < 8 && t >= (ghosts.length + 1) * tof / 8) {
                    ghosts.push({ x: pos2.x, y: pos2.y });
                }
                if (t >= tof) {
                    t = tof;
                    completed = true;
                    p.noLoop();
                }
            } else {
                p.noLoop();
            }
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 6;
            p.fill(col); p.noStroke();
            p.triangle(
                x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4)
            );
        }

        function syncValues() {
            var a = state.angle || 45;
            var v0 = state.v0 || 25;
            var g = getG();
            var rad = a * Math.PI / 180;
            setEl('val-angle', a + '\u00B0');
            setEl('val-v0', v0.toFixed(1) + ' m/s');
            setEl('val-v0x', (v0 * Math.cos(rad)).toFixed(2) + ' m/s');
            setEl('val-v0y', (v0 * Math.sin(rad)).toFixed(2) + ' m/s');
            setEl('val-maxHeight', calcMaxH().toFixed(2) + ' m');
            setEl('val-range', calcRange().toFixed(2) + ' m');
            setEl('val-tof', calcTOF().toFixed(2) + ' s');
            setEl('val-currentT', t.toFixed(2) + ' s');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._launch = function () {
            launched = true; completed = false; t = 0;
            trail = []; ghosts = [];
            p.loop();
        };
        state._reset = function () {
            launched = false; completed = false; t = 0;
            trail = []; ghosts = [];
            p.loop();
        };
        state._redraw = function () {
            if (!launched) { trail = []; ghosts = []; t = 0; }
            p.loop();
        };
    }

    VisualMath.register('projectile-motion', projectileViz);
})();
