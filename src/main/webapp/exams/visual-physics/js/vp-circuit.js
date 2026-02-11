/**
 * Visual Physics — Circuit Builder (Ohm's Law)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function circuitViz(p, container) {
        var state = VisualMath.getState();
        var W, H, pad = 40;
        var dotPhase = 0;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(480, W * 0.5));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getCircuit() { return state.circuitType || 'single'; }
        function getV() { return state.voltage || 12; }
        function getR1() { return state.r1 || 10; }
        function getR2() { return state.r2 || 20; }
        function getR3() { return state.r3 || 30; }

        function calcCircuit() {
            var type = getCircuit();
            var V = getV(), r1 = getR1(), r2 = getR2(), r3 = getR3();
            var Rtotal, I, drops = [];

            if (type === 'single') {
                Rtotal = r1;
                I = V / Rtotal;
                drops = [{ r: r1, v: V, i: I }];
            } else if (type === 'series2') {
                Rtotal = r1 + r2;
                I = V / Rtotal;
                drops = [
                    { r: r1, v: I * r1, i: I },
                    { r: r2, v: I * r2, i: I }
                ];
            } else if (type === 'series3') {
                Rtotal = r1 + r2 + r3;
                I = V / Rtotal;
                drops = [
                    { r: r1, v: I * r1, i: I },
                    { r: r2, v: I * r2, i: I },
                    { r: r3, v: I * r3, i: I }
                ];
            } else if (type === 'parallel2') {
                Rtotal = (r1 * r2) / (r1 + r2);
                I = V / Rtotal;
                drops = [
                    { r: r1, v: V, i: V / r1 },
                    { r: r2, v: V, i: V / r2 }
                ];
            } else if (type === 'combo') {
                // R2 and R3 in parallel, series with R1
                var rPar = (r2 * r3) / (r2 + r3);
                Rtotal = r1 + rPar;
                I = V / Rtotal;
                var vR1 = I * r1;
                var vPar = I * rPar;
                drops = [
                    { r: r1, v: vR1, i: I },
                    { r: r2, v: vPar, i: vPar / r2 },
                    { r: r3, v: vPar, i: vPar / r3 }
                ];
            }

            return { Rtotal: Rtotal, I: I, P: V * I, drops: drops };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var result = calcCircuit();
            var type = getCircuit();

            var cx = W / 2, cy = H / 2;
            var boxW = W - pad * 4, boxH = H - pad * 3;
            var left = cx - boxW / 2, right = cx + boxW / 2;
            var top = cy - boxH / 2, bottom = cy + boxH / 2;

            if (type === 'single' || type === 'series2' || type === 'series3') {
                drawSeriesCircuit(p, left, top, right, bottom, result, C, type);
            } else if (type === 'parallel2') {
                drawParallelCircuit(p, left, top, right, bottom, result, C);
            } else {
                drawComboCircuit(p, left, top, right, bottom, result, C);
            }

            // Animated dots
            if (state.showAnimation !== false) {
                dotPhase += result.I * 0.005;
                if (dotPhase > 1) dotPhase -= 1;
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var names = { single: 'Single Resistor', series2: 'Series (2R)', series3: 'Series (3R)', parallel2: 'Parallel (2R)', combo: 'Series-Parallel' };
            p.text(names[type], pad + 4, 8);

            syncValues(result);
            if (state.showAnimation !== false) {
                // keep looping for animation
            } else {
                p.noLoop();
            }
        };

        function drawSeriesCircuit(p, left, top, right, bottom, result, C, type) {
            var nR = result.drops.length;
            var rSpacing = (right - left) / (nR + 1);

            // Wires
            p.stroke(C.axis); p.strokeWeight(2);
            // Top wire
            p.line(left, top, right, top);
            // Right wire
            p.line(right, top, right, bottom);
            // Bottom wire with resistors
            var y = bottom;

            // Battery on left
            drawBattery(p, left, top, left, bottom, C, state.voltage || 12);
            p.stroke(C.axis); p.strokeWeight(2);

            // Resistors on top
            for (var i = 0; i < nR; i++) {
                var rx = left + rSpacing * (i + 1);
                drawResistor(p, rx - rSpacing * 0.35, top, rx + rSpacing * 0.35, top, C);

                // Wire segments
                if (i === 0) {
                    p.stroke(C.axis); p.strokeWeight(2);
                    p.line(left, top, rx - rSpacing * 0.35, top);
                }
                if (i < nR - 1) {
                    p.stroke(C.axis); p.strokeWeight(2);
                    p.line(rx + rSpacing * 0.35, top, left + rSpacing * (i + 2) - rSpacing * 0.35, top);
                } else {
                    p.stroke(C.axis); p.strokeWeight(2);
                    p.line(rx + rSpacing * 0.35, top, right, top);
                }

                // Labels
                p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.BOTTOM);
                p.text('R' + (i + 1) + '=' + result.drops[i].r + '\u03A9', rx, top - 14);

                if (state.showVdrops !== false) {
                    p.fill(C.sin); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                    p.text(result.drops[i].v.toFixed(2) + 'V', rx, top + 12);
                }
            }

            // Bottom return wire
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(left, bottom, right, bottom);

            // Animated current dots
            if (state.showAnimation !== false) {
                drawCurrentDots(p, [
                    { x: left, y: bottom }, { x: left, y: top },
                    { x: right, y: top }, { x: right, y: bottom },
                    { x: left, y: bottom }
                ], C, result.I);
            }
        }

        function drawParallelCircuit(p, left, top, right, bottom, result, C) {
            var midY = (top + bottom) / 2;
            var branch1Y = midY - 40;
            var branch2Y = midY + 40;

            // Battery on left
            drawBattery(p, left, top, left, bottom, C, state.voltage || 12);

            // Junction wires
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(left, top, right, top);
            p.line(left, bottom, right, bottom);
            // Branch connections
            var jLeft = left + (right - left) * 0.25;
            var jRight = left + (right - left) * 0.75;
            p.line(jLeft, top, jLeft, branch1Y);
            p.line(jLeft, top, jLeft, branch2Y);
            p.line(jRight, branch1Y, jRight, top);
            p.line(jRight, branch2Y, jRight, bottom);
            p.line(jLeft, branch2Y, jLeft, bottom);
            p.line(jRight, top, right, top);

            // Branch wires
            p.line(jLeft, branch1Y, jLeft + 20, branch1Y);
            p.line(jRight - 20, branch1Y, jRight, branch1Y);
            p.line(jLeft, branch2Y, jLeft + 20, branch2Y);
            p.line(jRight - 20, branch2Y, jRight, branch2Y);

            // Resistors
            drawResistor(p, jLeft + 20, branch1Y, jRight - 20, branch1Y, C);
            drawResistor(p, jLeft + 20, branch2Y, jRight - 20, branch2Y, C);

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.BOTTOM);
            p.text('R1=' + result.drops[0].r + '\u03A9', (jLeft + jRight) / 2, branch1Y - 10);
            p.text('R2=' + result.drops[1].r + '\u03A9', (jLeft + jRight) / 2, branch2Y - 10);

            if (state.showVdrops !== false) {
                p.fill(C.sin); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                p.text('I=' + result.drops[0].i.toFixed(2) + 'A', (jLeft + jRight) / 2, branch1Y + 8);
                p.text('I=' + result.drops[1].i.toFixed(2) + 'A', (jLeft + jRight) / 2, branch2Y + 8);
            }
        }

        function drawComboCircuit(p, left, top, right, bottom, result, C) {
            var midX = (left + right) / 2;
            var branch1Y = (top + bottom) / 2 - 35;
            var branch2Y = (top + bottom) / 2 + 35;

            // Battery
            drawBattery(p, left, top, left, bottom, C, state.voltage || 12);

            p.stroke(C.axis); p.strokeWeight(2);
            // Main wires
            p.line(left, top, midX - 60, top);
            p.line(left, bottom, right, bottom);
            p.line(right, top, right, bottom);

            // R1 on top-left
            drawResistor(p, left + 30, top, midX - 60, top, C);

            // Junction for parallel
            p.line(midX - 60, top, midX - 60, branch1Y);
            p.line(midX - 60, top, midX - 60, branch2Y);
            p.line(midX + 60, branch1Y, midX + 60, top);
            p.line(midX + 60, branch2Y, midX + 60, top);
            p.line(midX + 60, top, right, top);

            // Parallel branches
            p.line(midX - 60, branch1Y, midX - 30, branch1Y);
            p.line(midX + 30, branch1Y, midX + 60, branch1Y);
            p.line(midX - 60, branch2Y, midX - 30, branch2Y);
            p.line(midX + 30, branch2Y, midX + 60, branch2Y);

            drawResistor(p, midX - 30, branch1Y, midX + 30, branch1Y, C);
            drawResistor(p, midX - 30, branch2Y, midX + 30, branch2Y, C);

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.BOTTOM);
            p.text('R1=' + result.drops[0].r + '\u03A9', (left + 30 + midX - 60) / 2, top - 10);
            p.text('R2=' + result.drops[1].r + '\u03A9', midX, branch1Y - 10);
            p.text('R3=' + result.drops[2].r + '\u03A9', midX, branch2Y - 10);
        }

        function drawBattery(p, x1, y1, x2, y2, C, V) {
            var cx = x1, midY = (y1 + y2) / 2;
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(cx, y1, cx, midY - 12);
            p.line(cx, midY + 12, cx, y2);

            // Battery symbol: long line (+) and short line (-)
            p.strokeWeight(2.5);
            p.line(cx - 12, midY - 6, cx + 12, midY - 6); // + plate
            p.strokeWeight(2.5);
            p.line(cx - 6, midY + 6, cx + 6, midY + 6); // - plate

            // Labels
            p.fill(C.accent); p.noStroke(); p.textSize(10); p.textAlign(p.RIGHT, p.CENTER);
            p.text(V + 'V', cx - 16, midY);
            p.fill(C.sin); p.textSize(8);
            p.textAlign(p.LEFT, p.CENTER);
            p.text('+', cx + 14, midY - 6);
            p.text('\u2212', cx + 14, midY + 6);
        }

        function drawResistor(p, x1, y, x2, y2, C) {
            var len = x2 - x1;
            var midX = (x1 + x2) / 2;
            var teeth = 5;
            var th = 8;

            p.stroke(C.text); p.strokeWeight(1.5); p.noFill();
            p.beginShape();
            p.vertex(x1, y);
            var segLen = len / (teeth * 2 + 2);
            p.vertex(x1 + segLen, y);
            for (var i = 0; i < teeth; i++) {
                p.vertex(x1 + segLen + (i * 2 + 0.5) * segLen, y - th);
                p.vertex(x1 + segLen + (i * 2 + 1.5) * segLen, y + th);
            }
            p.vertex(x2 - segLen, y);
            p.vertex(x2, y);
            p.endShape();
        }

        function drawCurrentDots(p, path, C, current) {
            if (current < 0.01) return;
            var totalLen = 0;
            for (var i = 1; i < path.length; i++) {
                totalLen += p.dist(path[i - 1].x, path[i - 1].y, path[i].x, path[i].y);
            }
            var spacing = Math.max(20, 60 - current * 5);
            var nDots = Math.floor(totalLen / spacing);

            for (var d = 0; d < nDots; d++) {
                var frac = ((d / nDots) + dotPhase) % 1;
                var targetDist = frac * totalLen;
                var accum = 0;
                for (var s = 1; s < path.length; s++) {
                    var segLen = p.dist(path[s - 1].x, path[s - 1].y, path[s].x, path[s].y);
                    if (accum + segLen >= targetDist) {
                        var t = (targetDist - accum) / segLen;
                        var dx = p.lerp(path[s - 1].x, path[s].x, t);
                        var dy = p.lerp(path[s - 1].y, path[s].y, t);
                        p.fill(249, 115, 22); p.noStroke();
                        p.ellipse(dx, dy, 5, 5);
                        break;
                    }
                    accum += segLen;
                }
            }
        }

        function syncValues(result) {
            setEl('val-vsource', getV().toFixed(1) + ' V');
            setEl('val-rtotal', result.Rtotal.toFixed(2) + ' \u03A9');
            setEl('val-itotal', result.I.toFixed(3) + ' A');
            setEl('val-ptotal', result.P.toFixed(2) + ' W');

            for (var i = 0; i < 3; i++) {
                if (i < result.drops.length) {
                    setEl('val-vr' + (i + 1), result.drops[i].v.toFixed(2) + ' V');
                } else {
                    setEl('val-vr' + (i + 1), '--');
                }
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('circuit-builder', circuitViz);
})();
