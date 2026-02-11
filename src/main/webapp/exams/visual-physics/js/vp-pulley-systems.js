/**
 * Visual Physics — Pulley Systems
 * Modes: fixed, movable, block-tackle, atwood
 * Requires: vm-core.js, p5.js
 */
(function () {
    'use strict';

    function pulleySystemsViz(p, container) {
        var state = VisualMath.getState();
        var W, H, dark;
        var C;
        var time = 0, running = false;

        /* ---------- layout ---------- */
        function layout() {
            W = container.clientWidth || 600;
            H = container.clientHeight || 500;
            dark = VisualMath.isDark();
            C = VisualMath.palette();
        }

        /* ---------- physics ---------- */
        function calcMA() {
            switch (state.mode) {
                case 'fixed':    return 1;
                case 'movable':  return 2;
                case 'block-tackle': return Math.pow(2, state.numPulleys);
                case 'atwood':   return 1; // not applicable
            }
            return 1;
        }

        function calcEffort() {
            var ma = calcMA();
            if (state.mode === 'atwood') {
                // Tension T = 2*m1*m2*g / (m1+m2)
                return (2 * state.mass * state.mass2 * 9.81) / (state.mass + state.mass2);
            }
            var load = state.mass * 9.81;
            return load / (ma * (state.efficiency / 100));
        }

        function calcAtwoodAccel() {
            var m1 = Math.max(state.mass, state.mass2);
            var m2 = Math.min(state.mass, state.mass2);
            return 9.81 * (m1 - m2) / (m1 + m2);
        }

        function calcAtwoodTension() {
            return (2 * state.mass * state.mass2 * 9.81) / (state.mass + state.mass2);
        }

        /* ---------- drawing helpers ---------- */
        function drawPulley(cx, cy, r) {
            p.fill(dark ? 60 : 200); p.stroke(C.axis); p.strokeWeight(2);
            p.ellipse(cx, cy, r * 2, r * 2);
            // Axle
            p.fill(C.text); p.noStroke();
            p.ellipse(cx, cy, 6, 6);
        }

        function drawRope(points) {
            p.stroke(dark ? [180, 160, 120] : [120, 100, 60]); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var i = 0; i < points.length; i++) {
                p.vertex(points[i][0], points[i][1]);
            }
            p.endShape();
        }

        function drawMass(cx, cy, mass, color) {
            var w = 40 + mass * 1.5;
            var h = 30 + mass;
            p.fill(color); p.stroke(C.axis); p.strokeWeight(1);
            p.rect(cx - w / 2, cy, w, h, 4);
            p.fill(255); p.noStroke();
            p.textSize(11); p.textAlign(p.CENTER, p.CENTER);
            p.text(mass + ' kg', cx, cy + h / 2);
        }

        function drawArrow(x, y, dx, dy, col, label) {
            p.stroke(col); p.strokeWeight(2);
            p.line(x, y, x + dx, y + dy);
            // Arrowhead
            var len = Math.sqrt(dx * dx + dy * dy);
            if (len < 5) return;
            var ux = dx / len, uy = dy / len;
            var px = -uy, py = ux;
            p.fill(col); p.noStroke();
            p.triangle(x + dx, y + dy,
                x + dx - ux * 8 + px * 4, y + dy - uy * 8 + py * 4,
                x + dx - ux * 8 - px * 4, y + dy - uy * 8 - py * 4);
            if (label) {
                p.fill(col); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
                p.text(label, x + dx + px * 12, y + dy + py * 12);
            }
        }

        function drawSupport(cx, y, w) {
            // Ceiling / support beam
            p.fill(dark ? 50 : 180); p.stroke(C.axis); p.strokeWeight(1);
            p.rect(cx - w / 2, y - 8, w, 8, 2);
            // Hatching
            p.stroke(C.muted); p.strokeWeight(1);
            for (var i = cx - w / 2 + 5; i < cx + w / 2; i += 8) {
                p.line(i, y - 8, i - 5, y - 14);
            }
        }

        /* ---------- mode drawings ---------- */
        function drawFixed() {
            var cx = W / 2, supportY = 60;
            var pulleyR = 22;
            var pulleyY = supportY + pulleyR + 5;

            drawSupport(cx, supportY, 80);

            // Pulley
            drawPulley(cx, pulleyY, pulleyR);

            // Calculate displacement for animation
            var disp = running ? Math.min(time * 20, 80) : 0;

            // Rope: effort side (left) up over pulley, load side (right) down
            var leftX = cx - pulleyR;
            var rightX = cx + pulleyR;
            var loadY = pulleyY + 100 + disp;
            var effortY = pulleyY + 100 + disp; // MA=1, same displacement

            drawRope([
                [leftX, pulleyY + 200 - disp], // person pulls down
                [leftX, pulleyY],
                [rightX, pulleyY],
                [rightX, loadY]
            ]);

            // Load
            drawMass(rightX, loadY, state.mass, [239, 68, 68]);

            // Effort arrow (person pulling)
            if (state.showForces) {
                var effort = calcEffort();
                var load = state.mass * 9.81;
                drawArrow(leftX, pulleyY + 180 - disp, 0, 30, [59, 130, 246], 'F=' + effort.toFixed(1) + 'N');
                drawArrow(rightX + 25, loadY + 15, 0, 30, [239, 68, 68], 'W=' + load.toFixed(1) + 'N');
            }

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
            p.text('MA = 1', cx, H - 20);
            p.text('Fixed Pulley', cx, supportY - 20);
        }

        function drawMovable() {
            var cx = W / 2, supportY = 50;
            var pR = 20;

            drawSupport(cx, supportY, 120);

            // Fixed pulley at top-right
            var fpX = cx + 40, fpY = supportY + pR + 5;
            drawPulley(fpX, fpY, pR);

            // Movable pulley (goes down with load)
            var disp = running ? Math.min(time * 15, 60) : 0;
            var mpY = fpY + 100 + disp;
            var mpX = cx - 10;
            drawPulley(mpX, mpY, pR);

            // Rope: anchored at support, down around movable, up over fixed, down to person
            var anchorX = cx - 50;
            drawRope([
                [anchorX, supportY],           // anchor point
                [anchorX, mpY],                // down to movable left
                [mpX - pR, mpY],               // around movable
                [mpX + pR, mpY],               // to movable right
                [fpX - pR, fpY],               // up to fixed left
                [fpX + pR, fpY],               // over fixed
                [fpX + pR, fpY + 160 - disp / 2] // down to person (moves half as much)
            ]);

            // Load hanging from movable pulley
            drawMass(mpX, mpY + pR + 5, state.mass, [239, 68, 68]);

            if (state.showForces) {
                var effort = calcEffort();
                var load = state.mass * 9.81;
                drawArrow(fpX + pR + 5, fpY + 140 - disp / 2, 0, 25, [59, 130, 246], 'F=' + effort.toFixed(1) + 'N');
                drawArrow(mpX + 30, mpY + pR + 20, 0, 25, [239, 68, 68], 'W=' + load.toFixed(1) + 'N');
            }

            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
            p.text('MA = 2', cx, H - 20);
            p.text('Movable Pulley', cx, supportY - 20);
        }

        function drawBlockTackle() {
            var cx = W / 2, supportY = 40;
            var pR = 16;
            var n = state.numPulleys;
            var ma = calcMA();

            drawSupport(cx, supportY, W * 0.6);

            var disp = running ? Math.min(time * 10, 50) : 0;
            var spacing = Math.min(50, (W - 80) / (n + 1));
            var startX = cx - (n - 1) * spacing / 2;

            // Draw n stages
            for (var i = 0; i < n; i++) {
                var px = startX + i * spacing;
                // Fixed pulley on top
                var fpY = supportY + pR + 5;
                drawPulley(px, fpY, pR);

                // Movable pulley below
                var mpY = fpY + 70 + disp;
                drawPulley(px, mpY, pR);

                // Connecting ropes (simplified)
                p.stroke(dark ? [180, 160, 120] : [120, 100, 60]); p.strokeWeight(2);
                p.line(px - pR, fpY, px - pR, mpY);
                p.line(px + pR, fpY, px + pR, mpY);
            }

            // Load bar connecting movable pulleys
            var barY = supportY + pR + 5 + 70 + disp + pR + 5;
            p.stroke(C.axis); p.strokeWeight(3);
            if (n > 1) {
                p.line(startX, barY, startX + (n - 1) * spacing, barY);
            }

            // Load
            drawMass(cx, barY + 5, state.mass, [239, 68, 68]);

            // Effort rope
            var lastX = startX + (n - 1) * spacing + pR;
            p.stroke(dark ? [180, 160, 120] : [120, 100, 60]); p.strokeWeight(2.5);
            p.line(lastX + 10, supportY + pR + 5, lastX + 10, supportY + pR + 5 + 120 - disp / ma);

            if (state.showForces) {
                var effort = calcEffort();
                var load = state.mass * 9.81;
                drawArrow(lastX + 15, supportY + pR + 100 - disp / ma, 0, 25, [59, 130, 246], 'F=' + effort.toFixed(1) + 'N');
                drawArrow(cx + 35, barY + 25, 0, 25, [239, 68, 68], 'W=' + load.toFixed(1) + 'N');
            }

            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
            p.text('MA = 2^' + n + ' = ' + ma, cx, H - 20);
            p.text('Block & Tackle (' + n + ' stage' + (n > 1 ? 's' : '') + ')', cx, supportY - 20);
        }

        function drawAtwood() {
            var cx = W / 2, supportY = 50;
            var pR = 24;
            var pulleyY = supportY + pR + 5;

            drawSupport(cx, supportY, 100);
            drawPulley(cx, pulleyY, pR);

            // Calculate positions based on animation
            var accel = calcAtwoodAccel();
            var heavySide = state.mass >= state.mass2 ? 'left' : 'right';
            var dispHeavy = running ? Math.min(0.5 * accel * time * time * 5, 80) : 0;
            var dispLight = -dispHeavy;

            var leftX = cx - pR - 10;
            var rightX = cx + pR + 10;
            var baseY = pulleyY + 80;

            var leftY = baseY + (heavySide === 'left' ? dispHeavy : dispLight);
            var rightY = baseY + (heavySide === 'right' ? dispHeavy : dispLight);

            // Rope
            drawRope([
                [leftX, leftY],
                [leftX, pulleyY],
                [cx - pR, pulleyY],
                [cx + pR, pulleyY],
                [rightX, pulleyY],
                [rightX, rightY]
            ]);

            // Masses
            drawMass(leftX, leftY, state.mass, [239, 68, 68]);
            drawMass(rightX, rightY, state.mass2, [59, 130, 246]);

            if (state.showForces) {
                var T = calcAtwoodTension();
                // Tension up on both
                drawArrow(leftX - 25, leftY, 0, -30, [34, 197, 94], 'T=' + T.toFixed(1) + 'N');
                drawArrow(rightX + 25, rightY, 0, -30, [34, 197, 94], 'T=' + T.toFixed(1) + 'N');
                // Weight down on both
                var w1 = state.mass * 9.81;
                var w2 = state.mass2 * 9.81;
                drawArrow(leftX - 25, leftY + 45, 0, 25, [239, 68, 68], w1.toFixed(1) + 'N');
                drawArrow(rightX + 25, rightY + 45, 0, 25, [59, 130, 246], w2.toFixed(1) + 'N');
            }

            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
            p.text('a = ' + accel.toFixed(2) + ' m/s\u00b2', cx, H - 20);
            p.text('Atwood Machine', cx, supportY - 20);
        }

        /* ---------- sync values ---------- */
        function syncValues() {
            var mode = state.mode;
            var modeNames = { 'fixed': 'Fixed Pulley', 'movable': 'Movable Pulley', 'block-tackle': 'Block & Tackle', 'atwood': 'Atwood Machine' };
            var el = function (id) { return document.getElementById(id); };

            el('val-mode').textContent = modeNames[mode] || mode;
            el('val-mass').textContent = state.mass + ' kg';
            el('val-load').textContent = (state.mass * 9.81).toFixed(1) + ' N';

            if (mode === 'atwood') {
                el('val-ma').textContent = 'N/A';
                el('val-effort').textContent = 'T = ' + calcAtwoodTension().toFixed(1) + ' N';
                el('val-accel').textContent = calcAtwoodAccel().toFixed(3) + ' m/s\u00b2';
                el('val-mass2').textContent = state.mass2 + ' kg';
                el('val-numstages').textContent = 'N/A';
            } else {
                var ma = calcMA();
                el('val-ma').textContent = ma;
                el('val-effort').textContent = calcEffort().toFixed(1) + ' N';
                el('val-accel').textContent = '--';
                el('val-mass2').textContent = '--';
                el('val-numstages').textContent = mode === 'block-tackle' ? state.numPulleys : (mode === 'movable' ? '1' : '0');
            }

            el('val-efficiency').textContent = state.efficiency + '%';
        }

        /* ---------- p5 lifecycle ---------- */
        p.setup = function () {
            layout();
            var canvas = p.createCanvas(W, H);
            canvas.parent(container);
            p.textFont('system-ui');
            p.noLoop();
            syncValues();
        };

        p.draw = function () {
            layout();
            C = VisualMath.palette();
            p.background(C.bg);

            if (running) time += p.deltaTime / 1000;

            switch (state.mode) {
                case 'fixed':       drawFixed(); break;
                case 'movable':     drawMovable(); break;
                case 'block-tackle': drawBlockTackle(); break;
                case 'atwood':      drawAtwood(); break;
            }

            syncValues();
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
            p.redraw();
        };

        /* ---------- public methods ---------- */
        state._redraw = function () { p.redraw(); };
        state._reset = function () { time = 0; running = false; p.noLoop(); p.redraw(); };
        state._run = function () { time = 0; running = true; p.loop(); };
    }

    VisualMath.register('pulley-systems', pulleySystemsViz);
})();
