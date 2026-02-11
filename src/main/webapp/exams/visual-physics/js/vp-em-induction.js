/**
 * Visual Physics — Electromagnetic Induction Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function emInductionViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = false;
        var magnetPos = 0; // -1 to 1, center of coil = 0

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getMode() { return state.mode || 'magnet'; }
        function getSpeed() { return state.magnetSpeed || 5; }
        function getTurns() { return state.turns || 10; }
        function getArea() { return state.coilArea || 0.05; }
        function getBField() { return state.bField || 0.5; }

        function calcFlux() {
            var B = getBField(), A = getArea(), N = getTurns();
            if (getMode() === 'magnet') {
                // Approximate: flux depends on magnet position relative to coil
                var proximity = Math.exp(-magnetPos * magnetPos * 4);
                return N * B * A * proximity;
            }
            return N * B * A;
        }

        function calcEMF() {
            var speed = getSpeed();
            var N = getTurns(), B = getBField(), A = getArea();
            if (getMode() === 'magnet') {
                // dΦ/dt approximation
                var proximity = Math.exp(-magnetPos * magnetPos * 4);
                var dPhiDt = N * B * A * (-2 * magnetPos * 4) * proximity * speed * 0.1;
                return -dPhiDt;
            } else if (getMode() === 'generator') {
                // Rotating coil
                return N * B * A * 2 * Math.PI * speed * Math.sin(2 * Math.PI * speed * time * 0.01);
            }
            return 0;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var mode = getMode();
            var cx = W / 2, cy = H * 0.45;

            // Draw coil
            var coilX = cx, coilY = cy;
            var coilW = 80, coilH = 60;
            var turns = getTurns();
            p.stroke(249, 115, 22); p.strokeWeight(2); p.noFill();
            for (var i = 0; i < Math.min(turns, 8); i++) {
                var offset = i * 4 - Math.min(turns, 8) * 2;
                p.ellipse(coilX + offset, coilY, coilW, coilH);
            }

            // Turns label
            p.fill(C.text); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text('N=' + turns, coilX, coilY + coilH / 2 + 5);

            if (mode === 'magnet') {
                // Magnet
                var magnetX = coilX + magnetPos * W * 0.35;
                var magnetY = coilY;
                var mw = 40, mh = 25;

                // Magnet body
                p.fill(239, 68, 68); p.stroke(C.text); p.strokeWeight(1);
                p.rect(magnetX - mw / 2, magnetY - mh / 2, mw / 2, mh, 3, 0, 0, 3);
                p.fill(59, 130, 246);
                p.rect(magnetX, magnetY - mh / 2, mw / 2, mh, 0, 3, 3, 0);
                p.fill(255); p.noStroke(); p.textSize(11);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('N', magnetX - mw / 4, magnetY);
                p.text('S', magnetX + mw / 4, magnetY);

                // Velocity arrow
                if (running) {
                    var speed = getSpeed();
                    p.stroke(34, 197, 94); p.strokeWeight(2);
                    var arrDir = magnetPos < 0 ? 1 : -1;
                    p.line(magnetX, magnetY - mh / 2 - 10,
                        magnetX + arrDir * 20, magnetY - mh / 2 - 10);
                    drawArrow(p, magnetX, magnetY - mh / 2 - 10,
                        magnetX + arrDir * 20, magnetY - mh / 2 - 10, [34, 197, 94]);
                }
            } else if (mode === 'generator') {
                // Rotating coil representation
                var rotAngle = time * getSpeed() * 0.05;
                var visualW = coilW * Math.abs(Math.cos(rotAngle));
                p.stroke(168, 85, 247); p.strokeWeight(2.5); p.noFill();
                p.ellipse(coilX, coilY, Math.max(4, visualW), coilH);

                // B field arrows (horizontal)
                p.stroke(59, 130, 246, 100); p.strokeWeight(1);
                for (var by = coilY - 40; by <= coilY + 40; by += 20) {
                    p.line(coilX - 60, by, coilX + 60, by);
                    drawArrow(p, coilX - 60, by, coilX + 60, by, [59, 130, 246]);
                }
                p.fill(59, 130, 246); p.noStroke(); p.textSize(9);
                p.text('B', coilX + 65, coilY);
            }

            // Flux arrows
            if (state.showFlux) {
                var flux = calcFlux();
                var fluxScale = flux * 100;
                p.stroke(34, 197, 94, 120); p.strokeWeight(1.5);
                for (var fi = -2; fi <= 2; fi++) {
                    var fx = coilX + fi * 12;
                    var arrowLen = Math.min(30, Math.abs(fluxScale));
                    p.line(fx, coilY - arrowLen, fx, coilY + arrowLen);
                    if (fluxScale > 1) drawArrow(p, fx, coilY - arrowLen, fx, coilY + arrowLen, [34, 197, 94]);
                }
            }

            // Induced current direction
            if (state.showCurrent) {
                var emf = calcEMF();
                if (Math.abs(emf) > 0.001) {
                    var dir = emf > 0 ? 1 : -1;
                    p.fill(249, 115, 22, 180); p.noStroke(); p.textSize(16);
                    p.textAlign(p.CENTER, p.CENTER);
                    p.text(dir > 0 ? '\u21BB' : '\u21BA', coilX, coilY - coilH / 2 - 15);
                    p.textSize(9);
                    p.text('I', coilX + 15, coilY - coilH / 2 - 15);
                }
            }

            // EMF graph
            if (state.showGraph) {
                var gx = 20, gy = H * 0.7, gw = W - 40, gh = H * 0.25;
                p.stroke(C.axis); p.strokeWeight(1);
                p.line(gx, gy, gx, gy + gh);
                p.line(gx, gy + gh / 2, gx + gw, gy + gh / 2);

                p.fill(C.muted); p.noStroke(); p.textSize(8);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('EMF', gx + 2, gy + 5);
                p.textAlign(p.CENTER, p.TOP);
                p.text('time', gx + gw / 2, gy + gh + 2);

                // Plot EMF vs position/time
                if (mode === 'generator') {
                    p.stroke(239, 68, 68); p.strokeWeight(1.5); p.noFill();
                    p.beginShape();
                    var N = getTurns(), B = getBField(), A = getArea(), spd = getSpeed();
                    var maxEMF = N * B * A * 2 * Math.PI * spd;
                    for (var px = 0; px < gw; px++) {
                        var t = px / gw * 4 * Math.PI;
                        var emfVal = Math.sin(t);
                        p.vertex(gx + px, gy + gh / 2 - emfVal * gh * 0.4);
                    }
                    p.endShape();

                    // Current time marker
                    var curT = (time * spd * 0.05) % (4 * Math.PI);
                    var curPx = curT / (4 * Math.PI) * gw;
                    p.fill(239, 68, 68); p.noStroke();
                    p.ellipse(gx + curPx, gy + gh / 2 - Math.sin(curT) * gh * 0.4, 6, 6);
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var modeNames = { magnet: 'Magnet through Coil', changing: 'Changing B', wire: 'Moving Wire', generator: 'Generator' };
            p.text('EM Induction \u2014 ' + (modeNames[mode] || mode), 8, 8);

            syncValues();

            if (running) {
                time++;
                if (mode === 'magnet') {
                    magnetPos += getSpeed() * 0.003 * (magnetPos < 0 ? 1 : -1);
                    if (Math.abs(magnetPos) < 0.01 && time > 50) {
                        magnetPos = -magnetPos;
                    }
                    if (time > 200) { running = false; p.noLoop(); }
                }
            } else {
                p.noLoop();
            }
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 6;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4));
        }

        function syncValues() {
            var modeNames = { magnet: 'Magnet through Coil', changing: 'Changing B', wire: 'Moving Wire', generator: 'Generator' };
            setEl('val-mode', modeNames[getMode()] || getMode());
            setEl('val-bfield', getBField().toFixed(2) + ' T');
            setEl('val-turns', getTurns().toString());
            setEl('val-area', getArea().toFixed(3) + ' m\u00B2');
            setEl('val-flux', calcFlux().toFixed(4) + ' Wb');
            setEl('val-dphi', '\u2248 varies');
            setEl('val-emf', calcEMF().toFixed(4) + ' V');
            var emf = calcEMF();
            setEl('val-currentdir', Math.abs(emf) < 0.001 ? 'None' : emf > 0 ? 'CCW' : 'CW');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._push = function () { magnetPos = -1; running = true; time = 0; p.loop(); };
        state._play = function () { running = true; p.loop(); };
        state._pause = function () { running = false; };
        state._reset = function () { magnetPos = -1; running = false; time = 0; p.loop(); };
        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('em-induction', emInductionViz);
})();
