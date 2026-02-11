/**
 * Visual Physics — Torque & Rotational Motion Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function torqueViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var angVelocity = 0;
        var angle = 0;
        var running = false;

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

        function getMode() { return state.mode || 'lever'; }
        function getForce() { return state.force || 20; }
        function getLeverArm() { return state.leverArm || 0.5; }
        function getMass() { return state.mass || 5; }
        function getForceAngle() { return (state.forceAngle || 90) * Math.PI / 180; }

        function calcTorque() {
            return getForce() * getLeverArm() * Math.sin(getForceAngle());
        }

        function calcI() {
            var m = getMass(), mode = getMode();
            var r = getLeverArm();
            if (mode === 'disk') return 0.5 * m * r * r;
            if (mode === 'rolling') return 0.5 * m * r * r;
            return m * r * r; // point mass on lever
        }

        function calcAlpha() {
            return calcTorque() / calcI();
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var mode = getMode();
            var cx = W / 2, cy = H * 0.45;
            var force = getForce(), r = getLeverArm(), mass = getMass();
            var fAngle = state.forceAngle || 90;
            var torque = calcTorque();
            var I = calcI();
            var alpha = calcAlpha();
            var armPixels = r * 120;

            if (mode === 'lever') {
                // Pivot
                p.fill(C.text); p.noStroke();
                p.triangle(cx - 8, cy + 5, cx + 8, cy + 5, cx, cy - 5);

                // Lever arm
                p.push();
                p.translate(cx, cy);
                p.rotate(angle);
                p.stroke(C.accent); p.strokeWeight(4);
                p.line(0, 0, armPixels, 0);

                // Force arrow at end
                var fScale = force * 0.8;
                var fAngleRad = getForceAngle();
                var fx = armPixels + fScale * Math.cos(fAngleRad - Math.PI / 2);
                var fy = fScale * Math.sin(fAngleRad - Math.PI / 2);
                p.stroke(239, 68, 68); p.strokeWeight(2);
                p.line(armPixels, 0, fx, fy);
                drawArrow(p, armPixels, 0, fx, fy, [239, 68, 68]);

                // Mass at end
                p.fill(59, 130, 246); p.stroke(C.text); p.strokeWeight(1);
                p.ellipse(armPixels, 0, 20, 20);
                p.fill(255); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.CENTER);
                p.text(mass + 'kg', armPixels, 0);

                p.pop();

                // Lever arm label
                p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.BOTTOM);
                p.text('r=' + r.toFixed(1) + 'm', cx + armPixels / 2, cy - 10);

            } else if (mode === 'disk') {
                // Spinning disk
                var diskR = armPixels;
                p.push();
                p.translate(cx, cy);
                p.rotate(angle);

                // Disk
                p.fill(C.accent[0] || 99, C.accent[1] || 102, C.accent[2] || 241, 60);
                p.stroke(C.accent); p.strokeWeight(2);
                p.ellipse(0, 0, diskR * 2, diskR * 2);

                // Radius line
                p.stroke(C.text); p.strokeWeight(1.5);
                p.line(0, 0, diskR, 0);

                // Marker
                p.fill(239, 68, 68); p.noStroke();
                p.ellipse(diskR * 0.7, 0, 8, 8);

                p.pop();

                // Center
                p.fill(C.text); p.noStroke();
                p.ellipse(cx, cy, 8, 8);

                // Mass label
                p.fill(C.text); p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                p.text('M=' + mass + 'kg, R=' + r.toFixed(1) + 'm', cx, cy + diskR + 10);

            } else if (mode === 'rolling') {
                // Rolling disk
                var rollR = armPixels * 0.6;
                var rollX = cx - W * 0.3 + (angle * rollR) % (W * 0.6);

                // Ground
                p.stroke(C.axis); p.strokeWeight(2);
                p.line(cx - W * 0.4, cy + rollR, cx + W * 0.4, cy + rollR);

                p.push();
                p.translate(rollX, cy);
                p.rotate(angle);

                p.fill(C.accent[0] || 99, C.accent[1] || 102, C.accent[2] || 241, 60);
                p.stroke(C.accent); p.strokeWeight(2);
                p.ellipse(0, 0, rollR * 2, rollR * 2);
                p.stroke(C.text); p.strokeWeight(1);
                p.line(0, 0, rollR, 0);
                p.fill(239, 68, 68); p.noStroke();
                p.ellipse(rollR * 0.7, 0, 6, 6);

                p.pop();

                p.fill(C.text); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER, p.TOP);
                p.text('v = \u03C9r', rollX, cy + rollR + 10);
            }

            // Torque vector
            if (state.showTorque) {
                p.fill(168, 85, 247); p.noStroke(); p.textSize(11);
                p.textAlign(p.LEFT, p.CENTER);
                var tDir = torque >= 0 ? '\u21BA' : '\u21BB';
                p.textSize(24);
                p.text(tDir, cx - armPixels - 30, cy);
                p.textSize(10);
                p.text('\u03C4=' + torque.toFixed(1) + ' N\u00B7m', cx - armPixels - 30, cy + 20);
            }

            // Angular momentum
            if (state.showAngMomentum) {
                var L = I * angVelocity;
                p.fill(34, 197, 94); p.noStroke(); p.textSize(10);
                p.textAlign(p.RIGHT, p.TOP);
                p.text('L = I\u03C9 = ' + L.toFixed(2) + ' kg\u00B7m\u00B2/s', W - 10, 30);
            }

            // Moment of inertia display
            if (state.showInertia) {
                p.fill(59, 130, 246); p.noStroke(); p.textSize(10);
                p.textAlign(p.RIGHT, p.TOP);
                p.text('I = ' + I.toFixed(3) + ' kg\u00B7m\u00B2', W - 10, 50);
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var modeNames = { lever: 'Torque on Lever', disk: 'Spinning Disk', rolling: 'Rolling' };
            p.text('Torque & Rotation \u2014 ' + (modeNames[mode] || mode), 8, 8);

            syncValues();

            if (running) {
                angVelocity += alpha * 0.001;
                angle += angVelocity * 0.05;
            } else {
                p.noLoop();
            }
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var a = Math.atan2(y2 - y1, x2 - x1);
            var len = 7;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(x2, y2,
                x2 - len * Math.cos(a - 0.4), y2 - len * Math.sin(a - 0.4),
                x2 - len * Math.cos(a + 0.4), y2 - len * Math.sin(a + 0.4));
        }

        function syncValues() {
            var modeNames = { lever: 'Torque on Lever', disk: 'Spinning Disk', rolling: 'Rolling' };
            setEl('val-mode', modeNames[getMode()] || getMode());
            setEl('val-force', getForce() + ' N');
            setEl('val-leverarm', getLeverArm().toFixed(1) + ' m');
            setEl('val-torque', calcTorque().toFixed(1) + ' N\u00B7m');
            setEl('val-inertia', calcI().toFixed(3) + ' kg\u00B7m\u00B2');
            setEl('val-alpha', calcAlpha().toFixed(2) + ' rad/s\u00B2');
            setEl('val-omega', angVelocity.toFixed(3) + ' rad/s');
            setEl('val-angmomentum', (calcI() * angVelocity).toFixed(3) + ' kg\u00B7m\u00B2/s');
            setEl('val-rotke', (0.5 * calcI() * angVelocity * angVelocity).toFixed(3) + ' J');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._apply = function () { running = true; p.loop(); };
        state._reset = function () { running = false; angle = 0; angVelocity = 0; p.loop(); };
        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('torque-rotation', torqueViz);
})();
