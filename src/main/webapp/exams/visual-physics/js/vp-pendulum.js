/**
 * Visual Physics — Pendulum & SHM Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function pendulumViz(p, container) {
        var state = VisualMath.getState();
        var W, H, pad = 30;
        var time = 0;
        var running = false;
        var graphBuf = [];
        var maxBuf = 300;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(520, W * 0.55));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getMode() { return state.mode || 'pendulum'; }
        function getLength() { return state.length || 1.0; }
        function getK() { return state.springK || 10; }
        function getMass() { return state.mass || 1.0; }
        function getG() { return state.gravity || 9.8; }
        function getDamping() { return state.damping || 0; }
        function getAmplitude() { return state.amplitude || 30; }

        function getOmega() {
            if (getMode() === 'pendulum') return Math.sqrt(getG() / getLength());
            return Math.sqrt(getK() / getMass());
        }
        function getPeriod() { return 2 * Math.PI / getOmega(); }

        function displacement(t) {
            var w = getOmega();
            var d = getDamping();
            var A = getMode() === 'pendulum' ? getAmplitude() * Math.PI / 180 : getAmplitude() / 100;
            var env = Math.exp(-d * t);
            return A * env * Math.cos(w * t);
        }

        function velocity(t) {
            var w = getOmega();
            var d = getDamping();
            var A = getMode() === 'pendulum' ? getAmplitude() * Math.PI / 180 : getAmplitude() / 100;
            var env = Math.exp(-d * t);
            return -A * env * (w * Math.sin(w * t) + d * Math.cos(w * t));
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var halfW = W / 2;

            // Left half: animation
            drawAnimation(C, pad, pad, halfW - pad * 1.5, H - pad * 2);

            // Right half: displacement graph
            drawGraph(C, halfW + pad * 0.5, pad, halfW - pad * 1.5, H - pad * 2);

            // Energy bar
            drawEnergyBar(C, halfW - 12, pad + 20, 24, H - pad * 2 - 40);

            syncValues();

            if (running) {
                time += 0.03;
                var disp = displacement(time);
                graphBuf.push(disp);
                if (graphBuf.length > maxBuf) graphBuf.shift();
            } else {
                p.noLoop();
            }
        };

        function drawAnimation(C, x, y, w, h) {
            var cx = x + w / 2;
            var pivotY = y + 30;
            var disp = displacement(time);

            if (getMode() === 'pendulum') {
                // Pendulum
                var L = Math.min(h * 0.65, 200);
                var angle = disp;
                var bobX = cx + L * Math.sin(angle);
                var bobY = pivotY + L * Math.cos(angle);

                // Rod
                p.stroke(C.axis); p.strokeWeight(2);
                p.line(cx, pivotY, bobX, bobY);

                // Pivot
                p.fill(C.muted); p.noStroke();
                p.ellipse(cx, pivotY, 8, 8);

                // Bob
                p.fill(C.sin); p.noStroke();
                p.ellipse(bobX, bobY, 24, 24);

                // Angle arc
                if (Math.abs(angle) > 0.01) {
                    p.noFill(); p.stroke(C.accent); p.strokeWeight(1);
                    var arcR = 30;
                    var startA = Math.PI / 2 - Math.abs(angle);
                    var endA = Math.PI / 2;
                    if (angle > 0) {
                        p.arc(cx, pivotY, arcR * 2, arcR * 2, startA, endA);
                    } else {
                        p.arc(cx, pivotY, arcR * 2, arcR * 2, endA, endA + Math.abs(angle));
                    }
                }

                // Label
                p.fill(C.text); p.noStroke(); p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                p.text('Pendulum', cx, y + 4);
            } else {
                // Spring-mass
                var restY = pivotY + h * 0.3;
                var stretch = disp * h * 0.3;
                var massY = restY + stretch;

                // Spring coils
                drawSpring(p, cx, pivotY, cx, massY, C.axis);

                // Mass block
                p.fill(C.cos); p.noStroke();
                p.rectMode(p.CENTER);
                p.rect(cx, massY, 30, 30, 4);
                p.rectMode(p.CORNER);

                // Equilibrium line
                p.stroke(C.muted); p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                p.line(x + 10, restY, x + w - 10, restY);
                p.drawingContext.setLineDash([]);

                p.fill(C.muted); p.noStroke(); p.textSize(9);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('equilibrium', x + w - 55, restY);

                // Label
                p.fill(C.text); p.noStroke(); p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                p.text('Spring-Mass', cx, y + 4);
            }
        }

        function drawSpring(p, x1, y1, x2, y2, col) {
            var coils = 10;
            var springW = 12;
            var dy = (y2 - y1) / (coils * 2 + 2);
            p.stroke(col); p.strokeWeight(1.5); p.noFill();
            p.beginShape();
            p.vertex(x1, y1);
            p.vertex(x1, y1 + dy);
            for (var i = 0; i < coils; i++) {
                var yy = y1 + dy + i * 2 * dy + dy;
                p.vertex(x1 + (i % 2 === 0 ? springW : -springW), yy);
                p.vertex(x1 + (i % 2 === 0 ? -springW : springW), yy + dy);
            }
            p.vertex(x2, y2 - dy);
            p.vertex(x2, y2);
            p.endShape();
        }

        function drawGraph(C, x, y, w, h) {
            // Graph background
            p.fill(C.bg); p.stroke(C.grid); p.strokeWeight(1);
            p.rect(x, y, w, h, 4);

            // Zero line
            var cy = y + h / 2;
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(x, cy, x + w, cy);

            // Label
            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.TOP);
            p.text('Displacement vs Time', x + w / 2, y + 4);

            if (graphBuf.length < 2) return;

            // Scale
            var maxAmp = getMode() === 'pendulum' ? getAmplitude() * Math.PI / 180 : getAmplitude() / 100;
            if (maxAmp < 0.01) maxAmp = 0.01;
            var scY = (h / 2 - 20) / maxAmp;
            var dx = w / maxBuf;

            // Draw
            p.stroke(C.sin); p.strokeWeight(1.5); p.noFill();
            p.beginShape();
            for (var i = 0; i < graphBuf.length; i++) {
                var gx = x + w - (graphBuf.length - i) * dx;
                var gy = cy - graphBuf[i] * scY;
                gy = p.constrain(gy, y + 10, y + h - 10);
                p.vertex(gx, gy);
            }
            p.endShape();
        }

        function drawEnergyBar(C, x, y, w, h) {
            var disp = displacement(time);
            var vel = velocity(time);
            var maxAmp = getMode() === 'pendulum' ? getAmplitude() * Math.PI / 180 : getAmplitude() / 100;
            if (maxAmp < 0.001) return;

            var omega = getOmega();
            var totalE = 0.5 * omega * omega * maxAmp * maxAmp;
            if (totalE < 0.0001) return;

            var pe = 0.5 * omega * omega * disp * disp;
            var ke = totalE - pe;
            if (ke < 0) ke = 0;

            var peFrac = pe / totalE;
            var keFrac = ke / totalE;

            // Background
            p.fill(C.grid); p.noStroke();
            p.rect(x, y, w, h, 3);

            // PE (blue, from bottom)
            var peH = h * peFrac;
            p.fill(59, 130, 246, 180);
            p.rect(x, y + h - peH, w, peH, 0, 0, 3, 3);

            // KE (red, on top of PE)
            var keH = h * keFrac;
            p.fill(239, 68, 68, 180);
            p.rect(x, y + h - peH - keH, w, keH, 3, 3, 0, 0);

            // Labels
            p.fill(C.muted); p.noStroke(); p.textSize(7);
            p.textAlign(p.CENTER, p.TOP);
            p.text('KE', x + w / 2, y - 12);
            p.text('PE', x + w / 2, y + h + 3);
        }

        function syncValues() {
            var mode = getMode();
            setEl('val-mode', mode === 'pendulum' ? 'Pendulum' : 'Spring-Mass');
            if (mode === 'pendulum') {
                setEl('val-param', 'L = ' + getLength().toFixed(2) + ' m');
            } else {
                setEl('val-param', 'k = ' + getK().toFixed(1) + ' N/m');
            }
            setEl('val-period', getPeriod().toFixed(3) + ' s');
            setEl('val-frequency', (1 / getPeriod()).toFixed(3) + ' Hz');
            var ampDisp = mode === 'pendulum' ? getAmplitude().toFixed(1) + '\u00B0' : (getAmplitude() / 100).toFixed(3) + ' m';
            setEl('val-amplitude', ampDisp);

            var d = displacement(time);
            var v = velocity(time);
            if (mode === 'pendulum') {
                setEl('val-theta', (d * 180 / Math.PI).toFixed(2) + '\u00B0');
                setEl('val-omega', v.toFixed(3) + ' rad/s');
            } else {
                setEl('val-theta', d.toFixed(4) + ' m');
                setEl('val-omega', v.toFixed(3) + ' m/s');
            }

            var maxAmp = mode === 'pendulum' ? getAmplitude() * Math.PI / 180 : getAmplitude() / 100;
            var omega = getOmega();
            var totalE = 0.5 * omega * omega * maxAmp * maxAmp;
            var pe = 0.5 * omega * omega * d * d;
            var ke = Math.max(0, totalE - pe);
            setEl('val-ke', ke.toFixed(4));
            setEl('val-pe', pe.toFixed(4));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._start = function () { running = true; p.loop(); };
        state._pause = function () { running = false; };
        state._reset = function () {
            running = false; time = 0; graphBuf = [];
            p.loop();
        };
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('pendulum-shm', pendulumViz);
})();
