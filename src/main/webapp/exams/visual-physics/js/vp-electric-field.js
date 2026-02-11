/**
 * Visual Physics — Electric Field Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function electricFieldViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var charges = [];
        var dragging = -1;
        var k = 8.99e9; // Coulomb's constant (scaled for display)
        var kDisplay = 50000; // scaled constant for visual field lines

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(520, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            // Default: dipole
            if (!state._chargesInit) {
                charges = [
                    { x: W * 0.35, y: H / 2, q: 1 },
                    { x: W * 0.65, y: H / 2, q: -1 }
                ];
                state._chargesInit = true;
            }
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function fieldAt(px, py) {
            var Ex = 0, Ey = 0;
            for (var i = 0; i < charges.length; i++) {
                var dx = px - charges[i].x;
                var dy = py - charges[i].y;
                var r2 = dx * dx + dy * dy;
                if (r2 < 100) r2 = 100;
                var r = Math.sqrt(r2);
                var E = kDisplay * charges[i].q / r2;
                Ex += E * dx / r;
                Ey += E * dy / r;
            }
            return { x: Ex, y: Ey };
        }

        function potentialAt(px, py) {
            var V = 0;
            for (var i = 0; i < charges.length; i++) {
                var dx = px - charges[i].x;
                var dy = py - charges[i].y;
                var r = Math.sqrt(dx * dx + dy * dy);
                if (r < 5) r = 5;
                V += kDisplay * charges[i].q / r;
            }
            return V;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (charges.length === 0) {
                p.fill(C.muted); p.noStroke(); p.textSize(14);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('Click "+ Add Charge" to place charges', W / 2, H / 2);
                syncValues();
                p.noLoop();
                return;
            }

            // Draw field lines
            if (state.showFieldLines !== false) {
                drawFieldLines(C);
            }

            // Draw equipotential
            if (state.showEquipotential) {
                drawEquipotential(C);
            }

            // Draw field vectors on grid
            if (state.showVectors) {
                drawFieldVectors(C);
            }

            // Draw charges
            for (var i = 0; i < charges.length; i++) {
                var ch = charges[i];
                var col = ch.q > 0 ? [239, 68, 68] : [59, 130, 246];
                p.fill(col); p.stroke(255); p.strokeWeight(2);
                var r = 10 + Math.abs(ch.q) * 6;
                p.ellipse(ch.x, ch.y, r * 2, r * 2);
                p.fill(255); p.noStroke(); p.textSize(12); p.textAlign(p.CENTER, p.CENTER);
                var label = (ch.q > 0 ? '+' : '') + ch.q + 'q';
                p.text(label, ch.x, ch.y);
            }

            // Field at cursor
            if (state.showTestCharge && p.mouseX > 0 && p.mouseX < W && p.mouseY > 0 && p.mouseY < H) {
                var field = fieldAt(p.mouseX, p.mouseY);
                var mag = Math.sqrt(field.x * field.x + field.y * field.y);
                if (mag > 0.1) {
                    var angle = Math.atan2(field.y, field.x);
                    var arrowLen = Math.min(30, mag * 2);
                    p.stroke(34, 197, 94); p.strokeWeight(2);
                    var ax = p.mouseX + arrowLen * Math.cos(angle);
                    var ay = p.mouseY + arrowLen * Math.sin(angle);
                    p.line(p.mouseX, p.mouseY, ax, ay);
                    // Arrow head
                    p.fill(34, 197, 94); p.noStroke();
                    p.triangle(
                        ax, ay,
                        ax - 6 * Math.cos(angle - 0.4), ay - 6 * Math.sin(angle - 0.4),
                        ax - 6 * Math.cos(angle + 0.4), ay - 6 * Math.sin(angle + 0.4)
                    );
                    // Small test charge
                    p.fill(34, 197, 94, 150); p.noStroke();
                    p.ellipse(p.mouseX, p.mouseY, 8, 8);
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Electric Field', 8, 8);

            syncValues();
            p.noLoop();
        };

        function drawFieldLines(C) {
            var nLines = 12;
            for (var i = 0; i < charges.length; i++) {
                if (charges[i].q <= 0) continue; // only start from positive
                var nL = nLines * Math.abs(charges[i].q);
                for (var j = 0; j < nL; j++) {
                    var angle = (j / nL) * 2 * Math.PI;
                    traceFieldLine(charges[i].x + 15 * Math.cos(angle), charges[i].y + 15 * Math.sin(angle), 1, C);
                }
            }
            // If only negative charges, trace inward
            var hasPos = charges.some(function (c) { return c.q > 0; });
            if (!hasPos) {
                for (var n = 0; n < charges.length; n++) {
                    var nL2 = nLines * Math.abs(charges[n].q);
                    for (var j2 = 0; j2 < nL2; j2++) {
                        var angle2 = (j2 / nL2) * 2 * Math.PI;
                        traceFieldLine(charges[n].x + 15 * Math.cos(angle2), charges[n].y + 15 * Math.sin(angle2), -1, C);
                    }
                }
            }
        }

        function traceFieldLine(sx, sy, dir, C) {
            var x = sx, y = sy;
            var step = 3;
            var maxSteps = 300;

            p.stroke(C.sin[0], C.sin[1], C.sin[2], 120); p.strokeWeight(1); p.noFill();
            p.beginShape();
            for (var s = 0; s < maxSteps; s++) {
                if (x < 0 || x > W || y < 0 || y > H) break;
                p.vertex(x, y);

                var field = fieldAt(x, y);
                var mag = Math.sqrt(field.x * field.x + field.y * field.y);
                if (mag < 0.01) break;

                x += dir * step * field.x / mag;
                y += dir * step * field.y / mag;

                // Stop if near a charge
                for (var c = 0; c < charges.length; c++) {
                    var d = p.dist(x, y, charges[c].x, charges[c].y);
                    if (d < 12) { p.vertex(x, y); s = maxSteps; break; }
                }
            }
            p.endShape();
        }

        function drawEquipotential(C) {
            var gridStep = 8;
            p.strokeWeight(1);
            for (var gx = 0; gx < W; gx += gridStep) {
                for (var gy = 0; gy < H; gy += gridStep) {
                    var V = potentialAt(gx, gy);
                    var Vr = potentialAt(gx + gridStep, gy);
                    var Vd = potentialAt(gx, gy + gridStep);
                    // Check for sign changes (rough contour detection)
                    var levels = [-200, -100, -50, -20, 0, 20, 50, 100, 200];
                    for (var l = 0; l < levels.length; l++) {
                        var lev = levels[l];
                        if ((V - lev) * (Vr - lev) < 0 || (V - lev) * (Vd - lev) < 0) {
                            p.stroke(C.accent[0], C.accent[1], C.accent[2], 60);
                            p.point(gx, gy);
                        }
                    }
                }
            }
        }

        function drawFieldVectors(C) {
            var step = 40;
            for (var gx = step; gx < W; gx += step) {
                for (var gy = step; gy < H; gy += step) {
                    // Skip if too close to a charge
                    var tooClose = false;
                    for (var c = 0; c < charges.length; c++) {
                        if (p.dist(gx, gy, charges[c].x, charges[c].y) < 25) { tooClose = true; break; }
                    }
                    if (tooClose) continue;

                    var field = fieldAt(gx, gy);
                    var mag = Math.sqrt(field.x * field.x + field.y * field.y);
                    if (mag < 0.5) continue;

                    var angle = Math.atan2(field.y, field.x);
                    var arrowLen = Math.min(15, mag * 0.5);
                    var alpha = Math.min(200, mag * 3 + 40);

                    p.stroke(C.tan[0], C.tan[1], C.tan[2], alpha); p.strokeWeight(1);
                    var ax = gx + arrowLen * Math.cos(angle);
                    var ay = gy + arrowLen * Math.sin(angle);
                    p.line(gx, gy, ax, ay);
                }
            }
        }

        function syncValues() {
            setEl('val-numCharges', charges.length.toString());
            var netQ = 0;
            for (var i = 0; i < charges.length; i++) netQ += charges[i].q;
            setEl('val-netCharge', (netQ > 0 ? '+' : '') + netQ + 'q');

            if (p.mouseX > 0 && p.mouseX < W && p.mouseY > 0 && p.mouseY < H) {
                var field = fieldAt(p.mouseX, p.mouseY);
                var mag = Math.sqrt(field.x * field.x + field.y * field.y);
                var angle = Math.atan2(field.y, field.x) * 180 / Math.PI;
                setEl('val-fieldMag', mag.toFixed(1));
                setEl('val-fieldDir', angle.toFixed(1) + '\u00B0');
                setEl('val-potential', potentialAt(p.mouseX, p.mouseY).toFixed(1));
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        // Mouse interaction
        p.mousePressed = function () {
            if (p.mouseX < 0 || p.mouseX > W || p.mouseY < 0 || p.mouseY > H) return;
            for (var i = 0; i < charges.length; i++) {
                if (p.dist(p.mouseX, p.mouseY, charges[i].x, charges[i].y) < 20) {
                    dragging = i;
                    return;
                }
            }
        };
        p.mouseDragged = function () {
            if (dragging >= 0) {
                charges[dragging].x = p.constrain(p.mouseX, 20, W - 20);
                charges[dragging].y = p.constrain(p.mouseY, 20, H - 20);
                p.loop();
            }
        };
        p.mouseReleased = function () { dragging = -1; };
        p.mouseMoved = function () {
            if (state.showTestCharge && p.mouseX > 0 && p.mouseX < W && p.mouseY > 0 && p.mouseY < H) {
                p.loop();
            }
        };

        state._addCharge = function (q) {
            charges.push({ x: W / 2 + (Math.random() - 0.5) * 100, y: H / 2 + (Math.random() - 0.5) * 80, q: q });
            p.loop();
        };
        state._clearCharges = function () {
            charges = [];
            state._chargesInit = true;
            p.loop();
        };
        state._setPreset = function (preset) {
            if (preset === 'dipole') {
                charges = [
                    { x: W * 0.35, y: H / 2, q: 1 },
                    { x: W * 0.65, y: H / 2, q: -1 }
                ];
            } else if (preset === 'two-positive') {
                charges = [
                    { x: W * 0.35, y: H / 2, q: 1 },
                    { x: W * 0.65, y: H / 2, q: 1 }
                ];
            } else if (preset === 'quadrupole') {
                charges = [
                    { x: W * 0.35, y: H * 0.35, q: 1 },
                    { x: W * 0.65, y: H * 0.35, q: -1 },
                    { x: W * 0.35, y: H * 0.65, q: -1 },
                    { x: W * 0.65, y: H * 0.65, q: 1 }
                ];
            } else if (preset === 'plates') {
                charges = [];
                for (var i = 0; i < 5; i++) {
                    charges.push({ x: W * 0.3, y: H * 0.25 + i * (H * 0.5 / 4), q: 1 });
                    charges.push({ x: W * 0.7, y: H * 0.25 + i * (H * 0.5 / 4), q: -1 });
                }
            }
            p.loop();
        };
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('electric-field', electricFieldViz);
})();
