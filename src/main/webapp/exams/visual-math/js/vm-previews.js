/**
 * Visual Math — Preview Sketches for Index Page Cards
 * Requires: vm-core.js
 *
 * Small auto-animating, non-interactive sketches used as card thumbnails.
 */
(function () {
    'use strict';

    // ---- Unit Circle Preview ----
    VisualMath.register('unit-circle-preview', function (p, container) {
        var W, H, cx, cy, R, angle = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
            cx = W * 0.38; cy = H / 2;
            R = Math.min(cx - 20, cy - 16);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            angle += 0.02;

            p.push(); p.translate(cx, cy);
            p.stroke(C.grid); p.strokeWeight(1);
            p.line(-R * 1.2, 0, R * 1.2, 0);
            p.line(0, -R * 1.2, 0, R * 1.2);

            p.noFill(); p.stroke(C.circle); p.strokeWeight(1.5);
            p.ellipse(0, 0, R * 2, R * 2);

            var px = Math.cos(angle) * R, py = -Math.sin(angle) * R;
            p.stroke(C.sin); p.strokeWeight(2); p.line(px, 0, px, py);
            p.stroke(C.cos); p.strokeWeight(2); p.line(0, 0, px, 0);
            p.stroke(C.text[0], C.text[1], C.text[2], 100); p.strokeWeight(1);
            p.line(0, 0, px, py);
            p.fill(C.accent); p.noStroke(); p.ellipse(px, py, 8, 8);
            p.pop();

            // Mini wave
            var wX = W * 0.62, wW = W * 0.32, wMid = H / 2, wAmp = H * 0.3;
            p.stroke(C.sin); p.strokeWeight(1.5); p.noFill();
            p.beginShape();
            for (var i = 0; i <= wW; i += 2)
                p.vertex(wX + i, wMid - Math.sin((i / wW) * Math.PI * 2 + angle) * wAmp);
            p.endShape();
        };
    });

    // ---- Riemann Sum Preview ----
    VisualMath.register('riemann-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.005;
            var pad = 24, gw = W - pad * 2, gh = H - pad * 2, baseY = pad + gh;

            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, baseY, pad + gw, baseY);
            p.line(pad, pad, pad, baseY);

            var fn = function (x) { return Math.sin(x * 3) * 0.35 + 0.6; };
            var n = Math.floor(4 + Math.abs(Math.sin(t * 2)) * 16);
            var dx = gw / n;

            for (var i = 0; i < n; i++) {
                var h = fn(i / n) * gh;
                p.fill(C.accent[0], C.accent[1], C.accent[2], 50);
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 120);
                p.strokeWeight(1);
                p.rect(pad + i * dx, baseY - h, dx, h);
            }

            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var j = 0; j <= gw; j += 2)
                p.vertex(pad + j, baseY - fn(j / gw) * gh);
            p.endShape();
        };
    });

    // ---- Matrix Transform Preview ----
    VisualMath.register('matrix-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            p.push(); p.translate(W / 2, H / 2);
            var s = 16;
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var i = -6; i <= 6; i++) {
                p.line(i * s, -6 * s, i * s, 6 * s);
                p.line(-6 * s, i * s, 6 * s, i * s);
            }
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(-W / 2, 0, W / 2, 0); p.line(0, -H / 2, 0, H / 2);

            var a = Math.cos(t) * 0.5, b = Math.sin(t) * 0.3;
            var m = [Math.cos(a), -Math.sin(a) + b, Math.sin(a), Math.cos(a) + b * 0.5];
            var pts = [[-1, -1], [1, -1], [1, 1], [-1, 1]], sc = s * 3;

            p.stroke(C.grid); p.strokeWeight(1); p.noFill();
            p.beginShape();
            for (var j = 0; j < 4; j++) p.vertex(pts[j][0] * sc, pts[j][1] * sc);
            p.endShape(p.CLOSE);

            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.stroke(C.accent); p.strokeWeight(2);
            p.beginShape();
            for (var k = 0; k < 4; k++) {
                p.vertex((m[0] * pts[k][0] + m[1] * pts[k][1]) * sc,
                    (m[2] * pts[k][0] + m[3] * pts[k][1]) * sc);
            }
            p.endShape(p.CLOSE);

            p.strokeWeight(2.5);
            p.stroke(C.sin); p.line(0, 0, m[0] * sc, m[2] * sc);
            p.stroke(C.cos); p.line(0, 0, m[1] * sc, m[3] * sc);
            p.pop();
        };
    });

    // ---- Taylor Series Preview ----
    VisualMath.register('taylor-preview', function (p, container) {
        var W, H, t = 0;
        function fact(n) { var r = 1; for (var i = 2; i <= n; i++) r *= i; return r; }

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;
            var pad = 24, gw = W - pad * 2, gh = H - pad * 2, midY = pad + gh / 2;

            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);
            p.line(pad + gw / 2, pad, pad + gw / 2, pad + gh);

            var amp = gh * 0.4;
            var terms = Math.floor(1 + Math.abs(Math.sin(t)) * 8);

            p.stroke(C.muted); p.strokeWeight(1); p.noFill();
            p.beginShape();
            for (var i = 0; i <= gw; i += 2)
                p.vertex(pad + i, midY - Math.sin(((i / gw) - 0.5) * 8) * amp);
            p.endShape();

            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var j = 0; j <= gw; j += 2) {
                var x = ((j / gw) - 0.5) * 8, val = 0;
                for (var n = 0; n < terms; n++)
                    val += Math.pow(-1, n) * Math.pow(x, 2 * n + 1) / fact(2 * n + 1);
                p.vertex(pad + j, midY - Math.max(-2, Math.min(2, val)) * amp);
            }
            p.endShape();

            p.fill(C.accent); p.noStroke(); p.textSize(11);
            p.textAlign(p.RIGHT, p.TOP);
            p.text(terms + ' terms', pad + gw - 4, pad + 4);
        };
    });

    // ---- Function Plotter Preview ----
    VisualMath.register('function-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.01;
            var pad = 24, gw = W - pad * 2, midY = pad + (H - pad * 2) / 2, amp = (H - pad * 2) * 0.35;
            p.stroke(C.axis); p.strokeWeight(1); p.line(pad, midY, pad + gw, midY);

            var fns = [
                function (x) { return Math.sin(x * 2 + t); },
                function (x) { return 0.5 * Math.cos(x * 3 - t * 0.7); },
                function (x) { return Math.sin(x * 2 + t) + 0.5 * Math.cos(x * 3 - t * 0.7); }
            ];
            var cols = [C.sin, C.cos, C.accent];

            for (var f = 0; f < 3; f++) {
                p.stroke(cols[f]); p.strokeWeight(f === 2 ? 2.5 : 1.5);
                if (f < 2) p.drawingContext.setLineDash([4, 4]);
                p.noFill(); p.beginShape();
                for (var i = 0; i <= gw; i += 2)
                    p.vertex(pad + i, midY - fns[f]((i / gw) * Math.PI * 4) * amp);
                p.endShape();
                p.drawingContext.setLineDash([]);
            }
        };
    });

    // ---- Central Limit Theorem Preview ----
    VisualMath.register('probability-preview', function (p, container) {
        var W, H, bins = [], frame = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
            for (var i = 0; i < 30; i++) bins[i] = 0;
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            frame++;

            for (var s = 0; s < 3; s++) {
                var sum = 0;
                for (var d = 0; d < 6; d++) sum += Math.random();
                var idx = Math.floor((sum / 6) * bins.length);
                bins[Math.max(0, Math.min(bins.length - 1, idx))]++;
            }
            if (frame > 500) {
                frame = 0;
                for (var r = 0; r < bins.length; r++) bins[r] = 0;
            }

            var maxBin = Math.max.apply(null, bins) || 1;
            var pad = 16, gw = W - pad * 2, gh = H - pad * 2, baseY = pad + gh, bw = gw / bins.length;

            for (var i = 0; i < bins.length; i++) {
                var bh = (bins[i] / maxBin) * gh * 0.9;
                p.fill(C.accent[0], C.accent[1], C.accent[2], 120);
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 180);
                p.strokeWeight(1);
                p.rect(pad + i * bw, baseY - bh, bw - 1, bh);
            }

            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var j = 0; j <= gw; j += 2) {
                var x = (j / gw - 0.5) * 6;
                p.vertex(pad + j, baseY - Math.exp(-x * x / 2) / Math.sqrt(2 * Math.PI) * gh * 2.2);
            }
            p.endShape();
        };
    });

    // ---- Normal Distribution Preview ----
    VisualMath.register('normal-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.012;
            var pad = 20, gw = W - pad * 2, gh = H - pad * 2, baseY = pad + gh;

            // Bell curve
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = 0; i <= gw; i += 2) {
                var x = (i / gw - 0.5) * 6;
                p.vertex(pad + i, baseY - Math.exp(-x * x / 2) / Math.sqrt(2 * Math.PI) * gh * 2.3);
            }
            p.endShape();

            // Animated shaded area
            var bound = Math.sin(t) * 2;
            var bx = pad + (bound / 6 + 0.5) * gw;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 50); p.noStroke();
            p.beginShape();
            p.vertex(pad, baseY);
            for (var j = pad; j <= bx; j += 2) {
                var x2 = ((j - pad) / gw - 0.5) * 6;
                p.vertex(j, baseY - Math.exp(-x2 * x2 / 2) / Math.sqrt(2 * Math.PI) * gh * 2.3);
            }
            p.vertex(bx, baseY);
            p.endShape(p.CLOSE);

            // Bound marker
            p.stroke(C.accent); p.strokeWeight(1.5);
            p.drawingContext.setLineDash([3, 3]);
            p.line(bx, pad, bx, baseY);
            p.drawingContext.setLineDash([]);
        };
    });

    // ---- Derivative Preview ----
    VisualMath.register('derivative-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;
            var pad = 24, gw = W - pad * 2, midY = pad + (H - pad * 2) / 2, amp = (H - pad * 2) * 0.35;

            // Axis
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);

            // sin curve
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = 0; i <= gw; i += 2)
                p.vertex(pad + i, midY - Math.sin(((i / gw) - 0.5) * 8) * amp);
            p.endShape();

            // Animated point + tangent
            var xp = ((Math.sin(t) + 1) / 2) * 0.7 + 0.15; // 15%-85% of range
            var xVal = (xp - 0.5) * 8;
            var yVal = Math.sin(xVal);
            var slope = Math.cos(xVal);
            var px = pad + xp * gw, py = midY - yVal * amp;

            // Tangent line
            var tLen = gw * 0.15;
            p.stroke(C.tan); p.strokeWeight(2);
            p.line(px - tLen, py + slope * tLen * amp / 4, px + tLen, py - slope * tLen * amp / 4);

            // Point
            p.fill(C.accent); p.noStroke();
            p.ellipse(px, py, 10, 10);
        };
    });

    // ---- Quadratic Preview ----
    VisualMath.register('quadratic-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.01;
            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw / 2, baseY = pad + gh * 0.75;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, baseY, pad + gw, baseY);
            p.line(midX, pad, midX, pad + gh);

            // Animated parabola (b oscillates)
            var a = 1, b = Math.sin(t) * 3, c = -2;
            var vh = -b / (2 * a);
            var xRange = 5;

            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = 0; i <= gw; i += 2) {
                var x = (i / gw - 0.5) * xRange * 2;
                var y = a * x * x + b * x + c;
                var py = baseY - y * (gh * 0.08);
                py = Math.max(pad - 10, Math.min(pad + gh + 10, py));
                p.vertex(pad + i, py);
            }
            p.endShape();

            // Vertex dot
            var vk = a * vh * vh + b * vh + c;
            var vxs = midX + vh * (gw / (xRange * 2));
            var vys = baseY - vk * (gh * 0.08);
            if (vys > pad - 5 && vys < pad + gh + 5) {
                p.fill(C.accent); p.noStroke();
                p.ellipse(vxs, vys, 8, 8);
            }

            // Roots
            var disc = b * b - 4 * a * c;
            if (disc >= 0) {
                var r1 = (-b - Math.sqrt(disc)) / (2 * a);
                var r2 = (-b + Math.sqrt(disc)) / (2 * a);
                p.fill(C.cos); p.noStroke();
                var rx1 = midX + r1 * (gw / (xRange * 2));
                var rx2 = midX + r2 * (gw / (xRange * 2));
                if (rx1 > pad && rx1 < pad + gw) p.ellipse(rx1, baseY, 7, 7);
                if (rx2 > pad && rx2 < pad + gw) p.ellipse(rx2, baseY, 7, 7);
            }
        };
    });

    // ---- Pythagorean Theorem Preview ----
    VisualMath.register('pythagorean-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var pad = 30, scale = (H - pad * 2) / 12;
            var a = 3 + Math.sin(t) * 1.5;
            var b = 4 + Math.cos(t * 0.7) * 1.5;
            var c = Math.sqrt(a * a + b * b);

            var cx = W / 2, cy = H / 2 + 20;
            var ax = cx - a * scale / 2, ay = cy + b * scale / 2;
            var bx = cx + a * scale / 2, by = cy + b * scale / 2;
            var ccx = cx + a * scale / 2, ccy = cy - b * scale / 2;

            // Squares (faded)
            p.fill(C.sin[0], C.sin[1], C.sin[2], 30);
            p.stroke(C.sin[0], C.sin[1], C.sin[2], 100);
            p.strokeWeight(1.5);
            p.rect(ax - a * scale, ay, a * scale, -a * scale);

            p.fill(C.cos[0], C.cos[1], C.cos[2], 30);
            p.stroke(C.cos[0], C.cos[1], C.cos[2], 100);
            p.rect(ax, ay, a * scale, b * scale);

            // Triangle
            p.fill(C.bg[0], C.bg[1], C.bg[2], 200);
            p.stroke(C.text);
            p.strokeWeight(2);
            p.triangle(ax, ay, bx, by, ccx, ccy);

            // Right angle
            p.noFill();
            p.stroke(C.accent);
            p.strokeWeight(1.5);
            var corner = 10;
            p.beginShape();
            p.vertex(bx - corner, by);
            p.vertex(bx - corner, by - corner);
            p.vertex(bx, by - corner);
            p.endShape();

            // Labels
            p.fill(C.text);
            p.noStroke();
            p.textSize(11);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('a²+b²=c²', W / 2, 15);
        };
    });

    // ---- Circle Theorems Preview ----
    VisualMath.register('circle-theorems-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var cx = W / 2, cy = H / 2, R = Math.min(W, H) * 0.35;

            // Circle
            p.noFill();
            p.stroke(C.circle);
            p.strokeWeight(2);
            p.ellipse(cx, cy, R * 2, R * 2);

            // Center
            p.fill(C.muted);
            p.noStroke();
            p.ellipse(cx, cy, 4, 4);

            // Animated inscribed angle
            var A = 0.3 + Math.sin(t) * 0.3;
            var B = 2.5 + Math.cos(t * 0.8) * 0.3;
            var Cpt = 4.5;

            var ax = cx + Math.cos(A) * R, ay = cy + Math.sin(A) * R;
            var bx = cx + Math.cos(B) * R, by = cy + Math.sin(B) * R;
            var ccx = cx + Math.cos(Cpt) * R, ccy = cy + Math.sin(Cpt) * R;

            // Arc
            p.noFill();
            p.stroke(C.accent[0], C.accent[1], C.accent[2], 80);
            p.strokeWeight(3);
            p.arc(cx, cy, R * 2, R * 2, A, B);

            // Chords
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.line(ax, ay, ccx, ccy);
            p.line(bx, by, ccx, ccy);

            // Central angle (dashed)
            p.drawingContext.setLineDash([3, 3]);
            p.stroke(C.cos);
            p.strokeWeight(1.5);
            p.line(cx, cy, ax, ay);
            p.line(cx, cy, bx, by);
            p.drawingContext.setLineDash([]);

            // Points
            p.fill(C.point);
            p.stroke(C.accent);
            p.strokeWeight(1.5);
            p.ellipse(ax, ay, 7, 7);
            p.ellipse(bx, by, 7, 7);
            p.ellipse(ccx, ccy, 7, 7);
        };
    });

    // ---- Trig Graphs Preview ----
    VisualMath.register('trig-graphs-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.02;

            var pad = 30, plotW = W - pad * 2, plotH = H - pad * 2;
            var midY = pad + plotH / 2;

            // Axes
            p.stroke(C.axis);
            p.strokeWeight(1);
            p.line(pad, midY, pad + plotW, midY);

            // Sin wave
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.noFill();
            p.beginShape();
            for (var i = 0; i <= plotW; i += 2) {
                var x = (i / plotW) * 2 * Math.PI;
                var y = Math.sin(x + t) * (plotH / 4);
                p.vertex(pad + i, midY - y);
            }
            p.endShape();

            // Cos wave
            p.stroke(C.cos);
            p.beginShape();
            for (var j = 0; j <= plotW; j += 2) {
                var x2 = (j / plotW) * 2 * Math.PI;
                var y2 = Math.cos(x2 + t) * (plotH / 4);
                p.vertex(pad + j, midY - y2);
            }
            p.endShape();
        };
    });

    // ---- Triangle Solver Preview ----
    VisualMath.register('triangle-solver-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.01;

            var cx = W / 2, cy = H / 2 + 10;
            var size = Math.min(W, H) * 0.3;
            var angle = Math.sin(t) * 0.3 + 0.5;

            var ax = cx - size / 2, ay = cy + size / 3;
            var bx = cx + size / 2, by = cy + size / 3;
            var ccx = cx, ccy = cy - size / 2;

            // Triangle
            p.fill(C.accent[0], C.accent[1], C.accent[2], 30);
            p.stroke(C.sin);
            p.strokeWeight(2);
            p.triangle(ax, ay, bx, by, ccx, ccy);

            // Vertices
            p.fill(C.point);
            p.stroke(C.accent);
            p.ellipse(ax, ay, 6, 6);
            p.ellipse(bx, by, 6, 6);
            p.ellipse(ccx, ccy, 6, 6);

            // Labels
            p.fill(C.text);
            p.noStroke();
            p.textSize(10);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('SSS/SAS/ASA', W / 2, 15);
        };
    });

    // ---- Statistics Dashboard Preview ----
    VisualMath.register('statistics-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.02;

            var pad = 30, plotW = W - pad * 2, plotH = H - pad * 2;

            // Animated histogram
            var bins = 8;
            var barWidth = plotW / bins;

            for (var i = 0; i < bins; i++) {
                var height = (Math.sin(t + i * 0.5) * 0.4 + 0.6) * plotH;
                var x = pad + i * barWidth;
                var y = pad + plotH - height;

                p.fill(C.accent[0], C.accent[1], C.accent[2], 100);
                p.stroke(C.accent);
                p.strokeWeight(1.5);
                p.rect(x, y, barWidth - 3, height);
            }

            // Axis
            p.stroke(C.axis);
            p.strokeWeight(1.5);
            p.line(pad, pad + plotH, pad + plotW, pad + plotH);

            // Label
            p.fill(C.text);
            p.noStroke();
            p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text('Box Plot & Histogram', W / 2, 10);
        };
    });

    // ---- Linear Equation Preview ----
    VisualMath.register('linear-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw / 2, midY = pad + gh / 2;

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var i = -4; i <= 4; i++) {
                var gx = midX + i * (gw / 10), gy = midY + i * (gh / 10);
                p.line(gx, pad, gx, pad + gh);
                p.line(pad, gy, pad + gw, gy);
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, midY, pad + gw, midY);
            p.line(midX, pad, midX, pad + gh);

            // Animated line: slope rotates
            var m = Math.sin(t) * 3;
            var b = 1;
            var sx = gw / 10, sy = gh / 10;

            p.stroke(C.sin); p.strokeWeight(2.5);
            var x1 = -5, x2 = 5;
            var y1 = m * x1 + b, y2 = m * x2 + b;
            p.line(midX + x1 * sx, midY - y1 * sy, midX + x2 * sx, midY - y2 * sy);

            // Slope triangle
            var tx = 1;
            var ty1 = m * tx + b, ty2 = m * (tx + 1) + b;
            p.stroke(C.accent); p.strokeWeight(1.5);
            p.drawingContext.setLineDash([3, 3]);
            p.line(midX + tx * sx, midY - ty1 * sy, midX + (tx + 1) * sx, midY - ty1 * sy);
            p.line(midX + (tx + 1) * sx, midY - ty1 * sy, midX + (tx + 1) * sx, midY - ty2 * sy);
            p.drawingContext.setLineDash([]);

            // y-intercept dot
            p.fill(C.accent); p.noStroke();
            p.ellipse(midX, midY - b * sy, 8, 8);
        };
    });

    // ---- Systems of Equations Preview ----
    VisualMath.register('systems-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.012;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw / 2, midY = pad + gh / 2;
            var sx = gw / 10, sy = gh / 10;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);
            p.line(midX, pad, midX, pad + gh);

            // Line 1: fixed
            var m1 = 1, b1 = 1;
            p.stroke(C.sin); p.strokeWeight(2);
            p.line(midX + (-5) * sx, midY - (m1 * (-5) + b1) * sy,
                   midX + 5 * sx, midY - (m1 * 5 + b1) * sy);

            // Line 2: animated slope
            var m2 = Math.sin(t) * 3, b2 = -1;
            p.stroke(C.cos); p.strokeWeight(2);
            p.line(midX + (-5) * sx, midY - (m2 * (-5) + b2) * sy,
                   midX + 5 * sx, midY - (m2 * 5 + b2) * sy);

            // Intersection point
            if (Math.abs(m1 - m2) > 0.05) {
                var ix = (b2 - b1) / (m1 - m2);
                var iy = m1 * ix + b1;
                var px = midX + ix * sx, py = midY - iy * sy;
                if (px > pad && px < pad + gw && py > pad && py < pad + gh) {
                    p.fill(C.accent); p.noStroke();
                    p.ellipse(px, py, 10, 10);
                }
            }
        };
    });

    // ---- Polynomial Roots Preview ----
    VisualMath.register('polynomial-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw / 2, midY = pad + gh * 0.6;
            var sx = gw / 10, sy = gh * 0.02;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);
            p.line(midX, pad, midX, pad + gh);

            // Animated roots
            var r1 = -2 + Math.sin(t) * 0.5;
            var r2 = 0 + Math.cos(t * 0.7) * 0.5;
            var r3 = 3 + Math.sin(t * 1.3) * 0.5;

            // Draw polynomial
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = 0; i <= gw; i += 2) {
                var x = ((i / gw) - 0.5) * 10;
                var y = (x - r1) * (x - r2) * (x - r3) * 0.15;
                var py = midY - y * sy;
                py = Math.max(pad - 5, Math.min(pad + gh + 5, py));
                p.vertex(pad + i, py);
            }
            p.endShape();

            // Root dots
            p.fill(C.cos); p.stroke(C.accent); p.strokeWeight(1.5);
            var roots = [r1, r2, r3];
            for (var j = 0; j < roots.length; j++) {
                p.ellipse(midX + roots[j] * sx, midY, 8, 8);
            }
        };
    });

    // ---- Exponential & Log Preview ----
    VisualMath.register('exp-log-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad + gw * 0.3, oy = pad + gh * 0.65;
            var sx = gw / 10, sy = gh / 10;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // y = x dashed
            p.stroke(C.muted); p.strokeWeight(1);
            p.drawingContext.setLineDash([4, 4]);
            p.line(ox - 3 * sx, oy + 3 * sy, ox + 5 * sx, oy - 5 * sy);
            p.drawingContext.setLineDash([]);

            // Animated base
            var base = 1.5 + Math.sin(t) * 1.2;
            if (Math.abs(base - 1) < 0.1) base = 1.1;

            // y = a^x
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = -3; i <= 6; i += 0.1) {
                var ey = Math.pow(base, i);
                var screenY = oy - ey * sy;
                if (screenY > pad - 5 && screenY < pad + gh + 5) {
                    p.vertex(ox + i * sx, screenY);
                } else {
                    p.endShape(); p.beginShape();
                }
            }
            p.endShape();

            // y = log_a(x)
            p.stroke(C.cos); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var j = 0.05; j <= 8; j += 0.1) {
                var ly = Math.log(j) / Math.log(base);
                var slY = oy - ly * sy;
                if (slY > pad - 5 && slY < pad + gh + 5) {
                    p.vertex(ox + j * sx, slY);
                } else {
                    p.endShape(); p.beginShape();
                }
            }
            p.endShape();

            // Key points
            p.fill(C.sin); p.noStroke();
            p.ellipse(ox, oy - 1 * sy, 6, 6); // (0,1)
            p.fill(C.cos);
            p.ellipse(ox + 1 * sx, oy, 6, 6); // (1,0)
        };
    });

    // ---- 3D Shapes Preview ----
    VisualMath.register('3d-shapes-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var cx = W / 2, cy = H / 2;
            var size = Math.min(W, H) * 0.25;

            // Draw a simple 3D cube projection
            p.push();
            p.translate(cx, cy);

            var angle = t;
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);

            // Define cube vertices
            var vertices = [
                [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
                [-1, -1, 1], [1, -1, 1], [1, 1, 1], [-1, 1, 1]
            ];

            // Project to 2D
            var projected = vertices.map(function (v) {
                var x = v[0] * size;
                var y = v[1] * size;
                var z = v[2] * size;

                // Rotate around Y axis
                var rotX = x * cos - z * sin;
                var rotZ = x * sin + z * cos;

                return [rotX, y, rotZ];
            });

            // Draw edges
            p.stroke(C.accent);
            p.strokeWeight(2);
            var edges = [
                [0, 1], [1, 2], [2, 3], [3, 0], // back face
                [4, 5], [5, 6], [6, 7], [7, 4], // front face
                [0, 4], [1, 5], [2, 6], [3, 7]  // connecting edges
            ];

            edges.forEach(function (edge) {
                var p1 = projected[edge[0]];
                var p2 = projected[edge[1]];
                p.line(p1[0], p1[1], p2[0], p2[1]);
            });

            // Fill faces
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.noStroke();
            p.beginShape();
            [4, 5, 6, 7].forEach(function (i) {
                p.vertex(projected[i][0], projected[i][1]);
            });
            p.endShape(p.CLOSE);

            p.pop();

            // Label
            p.fill(C.text);
            p.noStroke();
            p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text('3D Shapes', W / 2, 10);
        };
    });

    // ---- Conic Sections Preview ----
    VisualMath.register('conics-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var cx = W / 2, cy = H / 2;
            var maxR = Math.min(W, H) * 0.35;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy, W - 20, cy);
            p.line(cx, 10, cx, H - 10);

            // Animated ellipse (a oscillates)
            var a = maxR * (0.6 + Math.sin(t) * 0.35);
            var b = maxR * 0.5;
            p.noFill(); p.stroke(C.sin); p.strokeWeight(2.5);
            p.ellipse(cx, cy, a * 2, b * 2);

            // Foci
            var c = Math.sqrt(Math.abs(a * a - b * b));
            p.fill(C.cos); p.noStroke();
            p.ellipse(cx - c, cy, 6, 6);
            p.ellipse(cx + c, cy, 6, 6);

            // Vertices
            p.fill(C.accent);
            p.ellipse(cx - a, cy, 5, 5);
            p.ellipse(cx + a, cy, 5, 5);
        };
    });

    // ---- Transformations Preview ----
    VisualMath.register('transformations-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var cx = W / 2, cy = H / 2;
            var sz = Math.min(W, H) * 0.15;

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var i = 0; i < W; i += 20) p.line(i, 0, i, H);
            for (var j = 0; j < H; j += 20) p.line(0, j, W, j);

            // Original triangle (ghost)
            var tri = [[-1, -0.5], [1, -0.5], [0, 1]];
            p.fill(C.sin[0], C.sin[1], C.sin[2], 30); p.stroke(C.sin[0], C.sin[1], C.sin[2], 80); p.strokeWeight(1.5);
            p.beginShape();
            tri.forEach(function (v) { p.vertex(cx - sz * 1.5 + v[0] * sz, cy + v[1] * sz); });
            p.endShape(p.CLOSE);

            // Transformed (rotated + translated)
            var ang = t;
            var dx = Math.sin(t * 0.7) * sz * 2;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40); p.stroke(C.accent); p.strokeWeight(2);
            p.beginShape();
            tri.forEach(function (v) {
                var rx = v[0] * Math.cos(ang) - v[1] * Math.sin(ang);
                var ry = v[0] * Math.sin(ang) + v[1] * Math.cos(ang);
                p.vertex(cx + dx + rx * sz, cy + ry * sz);
            });
            p.endShape(p.CLOSE);
        };
    });

    // ---- Vectors Preview ----
    VisualMath.register('vectors-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.02;

            var cx = W * 0.35, cy = H * 0.6;
            var sc = Math.min(W, H) * 0.08;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy, W - 20, cy);
            p.line(cx, 10, cx, H - 10);

            // Vector a (fixed)
            var ax = 3 * sc, ay = -1.5 * sc;
            p.stroke(C.sin); p.strokeWeight(2.5);
            p.line(cx, cy, cx + ax, cy + ay);
            p.fill(C.sin); p.noStroke(); p.ellipse(cx + ax, cy + ay, 7, 7);

            // Vector b (rotating)
            var bx = Math.cos(t) * 2 * sc, by = -Math.sin(t) * 2 * sc;
            p.stroke(C.cos); p.strokeWeight(2.5);
            p.line(cx, cy, cx + bx, cy + by);
            p.fill(C.cos); p.noStroke(); p.ellipse(cx + bx, cy + by, 7, 7);

            // Sum vector
            p.stroke(C.accent); p.strokeWeight(2);
            p.drawingContext.setLineDash([4, 3]);
            p.line(cx + ax, cy + ay, cx + ax + bx, cy + ay + by);
            p.line(cx + bx, cy + by, cx + ax + bx, cy + ay + by);
            p.drawingContext.setLineDash([]);
            p.fill(C.accent); p.noStroke();
            p.ellipse(cx + ax + bx, cy + ay + by, 6, 6);
        };
    });

    // ---- Sequences Preview ----
    VisualMath.register('sequences-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var pad = 20, gw = W - pad * 2, gh = H - pad * 2;
            var baseY = pad + gh, n = 8, barW = (gw - 10) / n - 3;

            // Axis
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, baseY, pad + gw, baseY);

            // Animated: geometric ratio oscillates
            var r = 0.7 + Math.sin(t) * 0.5;
            var a1 = 1;
            for (var i = 0; i < n; i++) {
                var term = a1 * Math.pow(r, i);
                var h = Math.min(gh * 0.9, Math.abs(term) * gh * 0.12);
                var x = pad + 5 + i * (barW + 3);
                p.fill(C.sin[0], C.sin[1], C.sin[2], 140);
                p.stroke(C.sin); p.strokeWeight(1);
                p.rect(x, baseY - h, barW, h);
            }

            // Partial sum line
            var cumSum = 0;
            p.stroke(C.accent); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var j = 0; j < n; j++) {
                cumSum += a1 * Math.pow(r, j);
                var sx = pad + 5 + j * (barW + 3) + barW / 2;
                var sy = baseY - Math.min(gh * 0.95, cumSum * gh * 0.12);
                p.vertex(sx, sy);
            }
            p.endShape();
        };
    });

    // ---- Complex Plane Preview ----
    VisualMath.register('complex-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.02;

            var cx = W / 2, cy = H / 2, sc = Math.min(W, H) * 0.06;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy, W - 20, cy);
            p.line(cx, 10, cx, H - 10);

            // z1 (fixed)
            var z1x = 2 * sc, z1y = -1.5 * sc;
            p.stroke(C.sin); p.strokeWeight(2);
            p.line(cx, cy, cx + z1x, cy + z1y);
            p.fill(C.sin); p.noStroke();
            p.ellipse(cx + z1x, cy + z1y, 8, 8);

            // z2 (rotating)
            var r2 = 2 * sc;
            var z2x = Math.cos(t) * r2, z2y = -Math.sin(t) * r2;
            p.stroke(C.cos); p.strokeWeight(2);
            p.line(cx, cy, cx + z2x, cy + z2y);
            p.fill(C.cos); p.noStroke();
            p.ellipse(cx + z2x, cy + z2y, 8, 8);

            // Product (add angles, multiply magnitudes)
            var rx = z1x + z2x, ry = z1y + z2y;
            p.stroke(C.accent); p.strokeWeight(2);
            p.line(cx, cy, cx + rx, cy + ry);
            p.fill(C.accent); p.noStroke();
            p.ellipse(cx + rx, cy + ry, 7, 7);

            // Modulus circle
            p.noFill(); p.stroke(C.sin[0], C.sin[1], C.sin[2], 40); p.strokeWeight(1);
            var r1 = Math.sqrt(z1x * z1x + z1y * z1y);
            p.ellipse(cx, cy, r1 * 2, r1 * 2);
        };
    });

    // ---- Polar Coordinates Preview ----
    VisualMath.register('polar-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.02;

            var cx = W / 2, cy = H / 2;
            var maxR = Math.min(W, H) * 0.38;

            // Polar grid
            p.noFill();
            for (var ring = 1; ring <= 3; ring++) {
                p.stroke(C.grid); p.strokeWeight(0.5);
                p.ellipse(cx, cy, maxR * ring / 1.5, maxR * ring / 1.5);
            }
            for (var a = 0; a < 6; a++) {
                var ang = a * Math.PI / 3;
                p.line(cx, cy, cx + Math.cos(ang) * maxR, cy - Math.sin(ang) * maxR);
            }

            // Rose curve r = cos(3θ), animated
            var n = 3;
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var th = 0; th <= Math.min(t * 2, Math.PI * 2); th += 0.03) {
                var r = Math.cos(n * th) * maxR * 0.9;
                p.vertex(cx + r * Math.cos(th), cy - r * Math.sin(th));
            }
            p.endShape();

            // Tracing point
            if (t * 2 < Math.PI * 2) {
                var curTh = t * 2;
                var curR = Math.cos(n * curTh) * maxR * 0.9;
                p.fill(C.accent); p.noStroke();
                p.ellipse(cx + curR * Math.cos(curTh), cy - curR * Math.sin(curTh), 8, 8);
            }
            if (t * 2 > Math.PI * 2 + 2) t = 0; // restart
        };
    });

    // ---- Parametric Curves Preview ----
    VisualMath.register('parametric-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var cx = W / 2, cy = H / 2;
            var sc = Math.min(W, H) * 0.35;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy, W - 20, cy);
            p.line(cx, 10, cx, H - 10);

            // Lissajous 3:2, animated trace
            var maxTh = Math.min(t * 1.5, Math.PI * 2);
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var th = 0; th <= maxTh; th += 0.03) {
                p.vertex(cx + Math.sin(3 * th) * sc * 0.85, cy - Math.sin(2 * th) * sc * 0.85);
            }
            p.endShape();

            if (maxTh < Math.PI * 2) {
                p.fill(C.accent); p.noStroke();
                p.ellipse(cx + Math.sin(3 * maxTh) * sc * 0.85, cy - Math.sin(2 * maxTh) * sc * 0.85, 8, 8);
            }
            if (t * 1.5 > Math.PI * 2 + 2) t = 0;
        };
    });

    // ---- Probability Distributions Preview ----
    VisualMath.register('distributions-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var pad = 20, gw = W - pad * 2, gh = H - pad * 2;
            var baseY = pad + gh;
            var n = 10, prob = 0.3 + Math.sin(t) * 0.2;

            // Axis
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, baseY, pad + gw, baseY);

            // Binomial bars
            var barW = (gw - 10) / (n + 1) - 2;
            var maxP = 0;
            var probs = [];
            for (var k = 0; k <= n; k++) {
                var pk = 1;
                for (var j = 0; j < k; j++) pk *= (n - j) / (j + 1) * prob / (1 - prob);
                pk *= Math.pow(1 - prob, n);
                probs.push(pk);
                if (pk > maxP) maxP = pk;
            }
            var yScale = (gh - 10) / (maxP || 0.1);

            for (var i = 0; i <= n; i++) {
                var bx = pad + 5 + i * (barW + 2);
                var bh = probs[i] * yScale;
                p.fill(C.sin[0], C.sin[1], C.sin[2], 150);
                p.stroke(C.sin); p.strokeWeight(1);
                p.rect(bx, baseY - bh, barW, bh);
            }

            // Mean line
            var mean = n * prob;
            var meanX = pad + 5 + mean * (barW + 2) + barW / 2;
            p.stroke(C.accent); p.strokeWeight(2);
            p.drawingContext.setLineDash([4, 3]);
            p.line(meanX, pad, meanX, baseY);
            p.drawingContext.setLineDash([]);
        };
    });

    // ---- Limits Preview ----
    VisualMath.register('limits-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.01;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw * 0.5, midY = pad + gh * 0.4;
            var sx = gw / 8, sy = gh / 8;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);
            p.line(midX, pad, midX, pad + gh);

            // f(x) = (x^2-1)/(x-1) = x+1, hole at x=1
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var i = -3; i < 0.95; i += 0.05) {
                p.vertex(midX + i * sx, midY - (i + 1) * sy);
            }
            p.endShape();
            p.beginShape();
            for (var j = 1.05; j <= 4; j += 0.05) {
                p.vertex(midX + j * sx, midY - (j + 1) * sy);
            }
            p.endShape();

            // Open circle at hole
            p.noFill(); p.stroke(C.sin); p.strokeWeight(2);
            p.ellipse(midX + 1 * sx, midY - 2 * sy, 10, 10);

            // Epsilon band
            var eps = 0.4 + Math.sin(t * 2) * 0.2;
            p.fill(C.cos[0], C.cos[1], C.cos[2], 25); p.noStroke();
            p.rect(pad, midY - (2 + eps) * sy, gw, eps * 2 * sy);

            // Animated approach dots
            var dist = 3 * (1 - (t % 1));
            if (dist > 0.1) {
                p.fill(C.accent); p.noStroke();
                p.ellipse(midX + (1 - dist) * sx, midY - (2 - dist) * sy, 7, 7);
                p.ellipse(midX + (1 + dist) * sx, midY - (2 + dist) * sy, 7, 7);
            }
        };
    });

    // ---- Slope Fields Preview ----
    VisualMath.register('slope-fields-preview', function (p, container) {
        var W, H;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var cx = W / 2, cy = H / 2;
            var step = 18, segLen = 7;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(10, cy, W - 10, cy);
            p.line(cx, 10, cx, H - 10);

            // Slope segments for dy/dx = y
            for (var x = step; x < W; x += step) {
                for (var y = step; y < H; y += step) {
                    var wx = (x - cx) / 30, wy = (cy - y) / 30;
                    var slope = wy; // dy/dx = y
                    var angle = Math.atan(slope);
                    var dx = Math.cos(angle) * segLen;
                    var dy = Math.sin(angle) * segLen;
                    var mag = Math.min(Math.abs(slope), 3) / 3;
                    p.stroke(C.sin[0] * (1 - mag) + C.accent[0] * mag,
                             C.sin[1] * (1 - mag) + C.accent[1] * mag,
                             C.sin[2] * (1 - mag) + C.accent[2] * mag, 180);
                    p.strokeWeight(1.5);
                    p.line(x - dx, y + dy, x + dx, y - dy);
                }
            }

            // Solution curve y = e^x (scaled)
            p.stroke(C.accent); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var i = 0; i < W; i += 2) {
                var wx2 = (i - cx) / 30;
                var vy = Math.exp(wx2) * 0.5;
                var sy = cy - vy * 30;
                if (sy > 5 && sy < H - 5) p.vertex(i, sy);
            }
            p.endShape();

            p.noLoop();
        };
    });

    // ---- Regression Preview ----
    VisualMath.register('regression-preview', function (p, container) {
        var W, H, t = 0;
        var pts = [
            { x: 1, y: 2.1 }, { x: 2, y: 3.8 }, { x: 3, y: 5.2 },
            { x: 4, y: 6.5 }, { x: 5, y: 8.1 }, { x: 6, y: 9.8 },
            { x: 7, y: 11.5 }, { x: 8, y: 12.9 }
        ];

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.008;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var baseY = pad + gh;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, baseY, pad + gw, baseY);
            p.line(pad, pad, pad, baseY);

            // Animated noise on points
            var noise = Math.sin(t) * 1.5;
            var sx = gw / 10, sy = gh / 18;

            // Regression line
            p.stroke(C.accent); p.strokeWeight(2);
            p.line(pad + 0.5 * sx, baseY - (1.5 + 0.5 * 1.6) * sy,
                   pad + 9.5 * sx, baseY - (1.5 + 9.5 * 1.6) * sy);

            // Points
            for (var i = 0; i < pts.length; i++) {
                var ny = pts[i].y + Math.sin(t + i) * noise * 0.3;
                p.fill(C.sin); p.stroke(C.accent); p.strokeWeight(1.5);
                p.ellipse(pad + pts[i].x * sx, baseY - ny * sy, 8, 8);
            }

            // R² label
            p.fill(C.accent); p.noStroke(); p.textSize(10);
            p.textAlign(p.RIGHT, p.TOP);
            p.text('R\u00B2 = 0.998', pad + gw, pad + 4);
        };
    });

    // ---- Fractals Preview ----
    VisualMath.register('fractals-preview', function (p, container) {
        var W, H;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            // Draw Koch snowflake (3 iterations)
            var cx = W / 2, cy = H / 2 + 10;
            var size = Math.min(W, H) * 0.6;
            var h = size * Math.sqrt(3) / 2;

            var pts = [
                { x: cx - size / 2, y: cy + h / 3 },
                { x: cx + size / 2, y: cy + h / 3 },
                { x: cx, y: cy - 2 * h / 3 }
            ];

            p.stroke(C.sin); p.strokeWeight(1.5); p.noFill();
            for (var i = 0; i < 3; i++) {
                kochEdge(p, pts[i].x, pts[i].y, pts[(i + 1) % 3].x, pts[(i + 1) % 3].y, 3);
            }
            p.noLoop();
        };

        function kochEdge(p, x1, y1, x2, y2, d) {
            if (d === 0) { p.line(x1, y1, x2, y2); return; }
            var dx = x2 - x1, dy = y2 - y1;
            var ax = x1 + dx / 3, ay = y1 + dy / 3;
            var bx = x1 + 2 * dx / 3, by = y1 + 2 * dy / 3;
            var mx = (x1 + x2) / 2 - dy * Math.sqrt(3) / 6;
            var my = (y1 + y2) / 2 + dx * Math.sqrt(3) / 6;
            kochEdge(p, x1, y1, ax, ay, d - 1);
            kochEdge(p, ax, ay, mx, my, d - 1);
            kochEdge(p, mx, my, bx, by, d - 1);
            kochEdge(p, bx, by, x2, y2, d - 1);
        }
    });

    // ---- Venn Diagram Preview ----
    VisualMath.register('venn-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.012;

            var cx = W / 2, cy = H / 2;
            var R = Math.min(W, H) * 0.28;
            var sep = R * 0.4 + Math.sin(t) * R * 0.3;

            // Circle A
            p.noFill(); p.stroke(C.sin); p.strokeWeight(2.5);
            p.ellipse(cx - sep, cy, R * 2, R * 2);

            // Circle B
            p.stroke(C.cos); p.strokeWeight(2.5);
            p.ellipse(cx + sep, cy, R * 2, R * 2);

            // Shade intersection
            var step = 4;
            p.noStroke();
            for (var sy = cy - R; sy < cy + R; sy += step) {
                for (var sx = cx - R; sx < cx + R; sx += step) {
                    var dA = Math.hypot(sx - (cx - sep), sy - cy);
                    var dB = Math.hypot(sx - (cx + sep), sy - cy);
                    if (dA <= R && dB <= R) {
                        p.fill(C.accent[0], C.accent[1], C.accent[2], 50);
                        p.rect(sx, sy, step, step);
                    }
                }
            }

            // Labels
            p.fill(C.sin); p.noStroke(); p.textSize(14);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('A', cx - sep - R * 0.4, cy);
            p.fill(C.cos);
            p.text('B', cx + sep + R * 0.4, cy);
        };
    });

    // ---- Matrix Calculator Preview ----
    VisualMath.register('matrix-calc-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.015;

            var cx = W / 2, cy = H / 2;
            var sc = Math.min(W, H) * 0.08;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy, W - 20, cy);
            p.line(cx, 10, cx, H - 10);

            // Animated matrix: rotation
            var angle = t;
            var m00 = Math.cos(angle), m01 = -Math.sin(angle);
            var m10 = Math.sin(angle), m11 = Math.cos(angle);

            // Unit square ghost
            p.fill(C.muted[0], C.muted[1], C.muted[2], 20);
            p.stroke(C.muted[0], C.muted[1], C.muted[2], 60); p.strokeWeight(1);
            p.beginShape();
            p.vertex(cx, cy); p.vertex(cx + sc, cy);
            p.vertex(cx + sc, cy - sc); p.vertex(cx, cy - sc);
            p.endShape(p.CLOSE);

            // Transformed parallelogram
            var pts = [[0, 0], [1, 0], [1, 1], [0, 1]];
            p.fill(C.accent[0], C.accent[1], C.accent[2], 35);
            p.stroke(C.accent); p.strokeWeight(2);
            p.beginShape();
            for (var i = 0; i < 4; i++) {
                var tx = m00 * pts[i][0] + m01 * pts[i][1];
                var ty = m10 * pts[i][0] + m11 * pts[i][1];
                p.vertex(cx + tx * sc, cy - ty * sc);
            }
            p.endShape(p.CLOSE);

            // Basis vectors
            p.stroke(C.sin); p.strokeWeight(2.5);
            p.line(cx, cy, cx + m00 * sc, cy - m10 * sc);
            p.fill(C.sin); p.noStroke();
            p.ellipse(cx + m00 * sc, cy - m10 * sc, 6, 6);

            p.stroke(C.cos); p.strokeWeight(2.5);
            p.line(cx, cy, cx + m01 * sc, cy - m11 * sc);
            p.fill(C.cos); p.noStroke();
            p.ellipse(cx + m01 * sc, cy - m11 * sc, 6, 6);
        };
    });

    // ---- Integration Preview ----
    VisualMath.register('integration-preview', function (p, container) {
        var W, H, t = 0;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            t += 0.01;

            var pad = 24, gw = W - pad * 2, gh = H - pad * 2;
            var midX = pad + gw * 0.25, midY = pad + gh * 0.7;
            var sx = gw / 6, sy = gh / 6;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, midY, pad + gw, midY);
            p.line(midX, pad, midX, pad + gh);

            // Shaded area under x^2 from 0 to animated b
            var b = 1.5 + Math.sin(t) * 1.2;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.noStroke();
            p.beginShape();
            p.vertex(midX, midY);
            for (var x = 0; x <= b; x += 0.05) {
                p.vertex(midX + x * sx, midY - x * x * sy);
            }
            p.vertex(midX + b * sx, midY);
            p.endShape(p.CLOSE);

            // Curve f(x) = x^2
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var i = -1; i <= 4; i += 0.05) {
                var fy = i * i;
                var scrY = midY - fy * sy;
                if (scrY > pad - 5 && scrY < pad + gh + 5) {
                    p.vertex(midX + i * sx, scrY);
                } else {
                    p.endShape(); p.beginShape();
                }
            }
            p.endShape();

            // Bound markers
            p.stroke(C.accent); p.strokeWeight(1.5);
            p.drawingContext.setLineDash([3, 3]);
            p.line(midX + b * sx, pad, midX + b * sx, pad + gh);
            p.drawingContext.setLineDash([]);
        };
    });

    // ---- Combinatorics Preview ----
    VisualMath.register('combinatorics-preview', function (p, container) {
        var W, H;

        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H);
        };

        function comb(n, k) {
            if (k > n || k < 0) return 0;
            if (k === 0 || k === n) return 1;
            var r = 1;
            for (var i = 0; i < k; i++) r = r * (n - i) / (i + 1);
            return Math.round(r);
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var maxN = 7;
            var cellSize = Math.min(22, (W - 40) / (maxN + 2));
            var cy = 12;

            p.textAlign(p.CENTER, p.CENTER);

            for (var row = 0; row <= maxN; row++) {
                var rowWidth = (row + 1) * cellSize;
                var startX = W / 2 - rowWidth / 2 + cellSize / 2;

                for (var col = 0; col <= row; col++) {
                    var val = comb(row, col);
                    var cx = startX + col * cellSize;

                    // Highlight row 6, col 2
                    if (row === 6 && col === 2) {
                        p.fill(C.accent); p.noStroke();
                        p.ellipse(cx, cy, cellSize * 0.8, cellSize * 0.8);
                        p.fill(255); p.textSize(Math.min(10, cellSize * 0.35));
                        p.text(val, cx, cy);
                    } else {
                        p.fill(row === 6 ? C.sin : C.text); p.noStroke();
                        p.textSize(Math.min(9, cellSize * 0.3));
                        p.text(val, cx, cy);
                    }
                }
                cy += cellSize;
            }

            p.noLoop();
        };
    });

})();
