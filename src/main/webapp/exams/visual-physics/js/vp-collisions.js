/**
 * Visual Physics — Collisions Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function collisionsViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var launched = false;
        var completed = false;
        var ball1, ball2;
        var v1After, v2After;
        var collisionTime = 0;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            resetBalls();
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getMode() { return state.mode || 'elastic'; }
        function getM1() { return state.m1 || 5; }
        function getM2() { return state.m2 || 5; }
        function getV1() { return state.v1 || 10; }
        function getV2() { return state.v2 || 0; }

        function calcAfterVelocities() {
            var m1 = getM1(), m2 = getM2(), v1 = getV1(), v2 = getV2();
            var mode = getMode();
            if (mode === 'elastic') {
                var v1f = ((m1 - m2) * v1 + 2 * m2 * v2) / (m1 + m2);
                var v2f = ((m2 - m1) * v2 + 2 * m1 * v1) / (m1 + m2);
                return { v1: v1f, v2: v2f };
            } else {
                var vf = (m1 * v1 + m2 * v2) / (m1 + m2);
                return { v1: vf, v2: vf };
            }
        }

        function resetBalls() {
            var pad = 80;
            ball1 = { x: pad + 40, y: H / 2, r: 15 + getM1() * 1.5 };
            ball2 = { x: W - pad - 40, y: H / 2, r: 15 + getM2() * 1.5 };
            var after = calcAfterVelocities();
            v1After = after.v1;
            v2After = after.v2;
        }

        function totalP_before() {
            return getM1() * getV1() + getM2() * getV2();
        }
        function totalKE_before() {
            return 0.5 * getM1() * getV1() * getV1() + 0.5 * getM2() * getV2() * getV2();
        }
        function totalP_after() {
            return getM1() * v1After + getM2() * v2After;
        }
        function totalKE_after() {
            return 0.5 * getM1() * v1After * v1After + 0.5 * getM2() * v2After * v2After;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var mode = getMode();
            var m1 = getM1(), m2 = getM2();

            // Ground line
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(30, H * 0.7, W - 30, H * 0.7);

            // Phase
            var cx = W / 2;
            var maxTravel = W * 0.3;
            var speed = 2;
            var phase; // 'before', 'colliding', 'after'

            if (!launched) {
                phase = 'before';
                ball1.x = cx - maxTravel;
                ball2.x = cx + maxTravel;
            } else if (time < 1) {
                phase = 'before';
                var t = time;
                ball1.x = (cx - maxTravel) + t * maxTravel * (getV1() > 0 ? 1 : -1);
                ball2.x = (cx + maxTravel) + t * maxTravel * (getV2() < 0 ? -1 : getV2() > 0 ? 1 : 0) * Math.abs(getV2()) / Math.max(1, Math.abs(getV1()));
            } else if (time < 1.3) {
                phase = 'colliding';
                ball1.x = cx - ball1.r * 0.3;
                ball2.x = cx + ball2.r * 0.3;
            } else {
                phase = 'after';
                var tAfter = (time - 1.3);
                var afterScale = maxTravel;
                ball1.x = cx + tAfter * v1After * speed;
                ball2.x = cx + tAfter * v2After * speed;
            }

            ball1.r = 15 + m1 * 1.5;
            ball2.r = 15 + m2 * 1.5;
            ball1.y = H * 0.7 - ball1.r;
            ball2.y = H * 0.7 - ball2.r;

            // Ball 1
            p.fill(239, 68, 68); p.stroke(255); p.strokeWeight(1.5);
            p.ellipse(ball1.x, ball1.y, ball1.r * 2, ball1.r * 2);
            p.fill(255); p.noStroke(); p.textSize(11); p.textAlign(p.CENTER, p.CENTER);
            p.text('m\u2081', ball1.x, ball1.y);

            // Ball 2
            p.fill(59, 130, 246); p.stroke(255); p.strokeWeight(1.5);
            p.ellipse(ball2.x, ball2.y, ball2.r * 2, ball2.r * 2);
            p.fill(255); p.noStroke(); p.textSize(11); p.textAlign(p.CENTER, p.CENTER);
            p.text('m\u2082', ball2.x, ball2.y);

            // Momentum vectors
            if (state.showMomentum) {
                var pScale = 3;
                if (phase !== 'after') {
                    drawVec(p, ball1.x, ball1.y - ball1.r - 10, getV1() * m1 * pScale / 10, 0, [239, 68, 68]);
                    drawVec(p, ball2.x, ball2.y - ball2.r - 10, getV2() * m2 * pScale / 10, 0, [59, 130, 246]);
                } else {
                    drawVec(p, ball1.x, ball1.y - ball1.r - 10, v1After * m1 * pScale / 10, 0, [239, 68, 68]);
                    drawVec(p, ball2.x, ball2.y - ball2.r - 10, v2After * m2 * pScale / 10, 0, [59, 130, 246]);
                }
            }

            // Energy bars
            if (state.showEnergy) {
                var barW = 60, barH = 80;
                var barX = W - 90, barY = 30;
                var keBefore = totalKE_before();
                var keAfter = totalKE_after();
                var maxKE = Math.max(keBefore, 1);

                p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.BOTTOM);
                p.text('KE Before', barX, barY);
                p.text('KE After', barX + barW + 10, barY);

                p.stroke(C.grid); p.strokeWeight(1); p.noFill();
                p.rect(barX - 15, barY + 2, 30, barH);
                p.rect(barX + barW - 5, barY + 2, 30, barH);

                p.noStroke();
                p.fill(34, 197, 94);
                var h1 = (keBefore / maxKE) * barH;
                p.rect(barX - 15, barY + 2 + barH - h1, 30, h1);

                var h2 = (keAfter / maxKE) * barH;
                p.fill(249, 115, 22);
                p.rect(barX + barW - 5, barY + 2 + barH - h2, 30, h2);
            }

            // Center of mass
            if (state.showCOM) {
                var comX = (m1 * ball1.x + m2 * ball2.x) / (m1 + m2);
                p.stroke(168, 85, 247); p.strokeWeight(2);
                p.drawingContext.setLineDash([4, 3]);
                p.line(comX, H * 0.3, comX, H * 0.7);
                p.drawingContext.setLineDash([]);
                p.fill(168, 85, 247); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER, p.TOP);
                p.text('COM', comX, H * 0.3 - 12);
            }

            // Mode & title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var modeName = mode === 'elastic' ? 'Elastic 1D' : mode === 'inelastic' ? 'Inelastic 1D' : '2D Collision';
            p.text('Collisions \u2014 ' + modeName, 8, 8);

            syncValues();

            if (launched && !completed) {
                time += 0.02;
                if (time > 3) { completed = true; p.noLoop(); }
            } else if (!launched) {
                p.noLoop();
            }
        };

        function drawVec(p, x, y, dx, dy, col) {
            if (Math.abs(dx) < 0.5 && Math.abs(dy) < 0.5) return;
            p.stroke(col[0], col[1], col[2]); p.strokeWeight(2);
            p.line(x, y, x + dx, y + dy);
            var angle = Math.atan2(dy, dx);
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(
                x + dx, y + dy,
                x + dx - 6 * Math.cos(angle - 0.4), y + dy - 6 * Math.sin(angle - 0.4),
                x + dx - 6 * Math.cos(angle + 0.4), y + dy - 6 * Math.sin(angle + 0.4)
            );
        }

        function syncValues() {
            var mode = getMode();
            var modeName = mode === 'elastic' ? 'Elastic 1D' : mode === 'inelastic' ? 'Inelastic 1D' : '2D';
            setEl('val-mode', modeName);
            setEl('val-m1', getM1() + ' kg');
            setEl('val-m2', getM2() + ' kg');
            setEl('val-v1before', getV1().toFixed(1) + ' m/s');
            setEl('val-v2before', getV2().toFixed(1) + ' m/s');
            setEl('val-v1after', v1After.toFixed(2) + ' m/s');
            setEl('val-v2after', v2After.toFixed(2) + ' m/s');
            setEl('val-pbefore', totalP_before().toFixed(1) + ' kg\u00B7m/s');
            setEl('val-pafter', totalP_after().toFixed(1) + ' kg\u00B7m/s');
            setEl('val-kebefore', totalKE_before().toFixed(1) + ' J');
            setEl('val-keafter', totalKE_after().toFixed(1) + ' J');
            setEl('val-kelost', (totalKE_before() - totalKE_after()).toFixed(1) + ' J');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._launch = function () {
            resetBalls();
            launched = true; completed = false; time = 0;
            p.loop();
        };
        state._reset = function () {
            launched = false; completed = false; time = 0;
            resetBalls();
            p.loop();
        };
        state._redraw = function () {
            resetBalls();
            p.redraw();
        };
    }

    VisualMath.register('collisions', collisionsViz);
})();
