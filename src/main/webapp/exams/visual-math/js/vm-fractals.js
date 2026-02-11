/**
 * Visual Math — Fractal Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function fractalViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 20;
        var mbBuffer = null; // off-screen buffer for Mandelbrot

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); mbBuffer = null; };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var ft = state.fractalType || 'koch';
            var iter = state.iterations != null ? state.iterations : 4;

            if (ft === 'mandelbrot') drawMandelbrot(C);
            else if (ft === 'koch') drawKoch(C, iter);
            else if (ft === 'sierpinski') drawSierpinski(C, iter);
            else if (ft === 'tree') drawTree(C, iter);
            else if (ft === 'fern') drawFern(C);

            updateValues();
            if (state.animating) {
                state.animT = (state.animT || 0) + 0.02;
                if (state.animT > 1) state.animT = 0;
            } else {
                p.noLoop();
            }
        };

        // ---- Koch Snowflake ----
        function drawKoch(C, depth) {
            depth = Math.min(depth, 7);
            var cx = W / 2, cy = H / 2 + 20;
            var size = Math.min(W, H) * 0.7;
            var h = size * Math.sqrt(3) / 2;

            // Equilateral triangle vertices
            var pts = [
                { x: cx - size / 2, y: cy + h / 3 },
                { x: cx + size / 2, y: cy + h / 3 },
                { x: cx, y: cy - 2 * h / 3 }
            ];

            p.stroke(C.sin); p.strokeWeight(1.5); p.noFill();
            for (var i = 0; i < 3; i++) {
                var a = pts[i], b = pts[(i + 1) % 3];
                kochEdge(a.x, a.y, b.x, b.y, depth);
            }
        }

        function kochEdge(x1, y1, x2, y2, depth) {
            if (depth === 0) {
                p.line(x1, y1, x2, y2);
                return;
            }
            var dx = x2 - x1, dy = y2 - y1;
            var ax = x1 + dx / 3, ay = y1 + dy / 3;
            var bx = x1 + 2 * dx / 3, by = y1 + 2 * dy / 3;
            var mx = (x1 + x2) / 2 - dy * Math.sqrt(3) / 6;
            var my = (y1 + y2) / 2 + dx * Math.sqrt(3) / 6;

            kochEdge(x1, y1, ax, ay, depth - 1);
            kochEdge(ax, ay, mx, my, depth - 1);
            kochEdge(mx, my, bx, by, depth - 1);
            kochEdge(bx, by, x2, y2, depth - 1);
        }

        // ---- Sierpinski Triangle ----
        function drawSierpinski(C, depth) {
            depth = Math.min(depth, 8);
            var cx = W / 2, cy = H / 2 + 20;
            var size = Math.min(W, H) * 0.75;
            var h = size * Math.sqrt(3) / 2;

            var a = { x: cx - size / 2, y: cy + h / 3 };
            var b = { x: cx + size / 2, y: cy + h / 3 };
            var c = { x: cx, y: cy - 2 * h / 3 };

            p.fill(C.sin[0], C.sin[1], C.sin[2], 100);
            p.stroke(C.sin); p.strokeWeight(1);
            sierpinskiRec(a, b, c, depth);
        }

        function sierpinskiRec(a, b, c, depth) {
            if (depth === 0) {
                p.triangle(a.x, a.y, b.x, b.y, c.x, c.y);
                return;
            }
            var ab = { x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 };
            var bc = { x: (b.x + c.x) / 2, y: (b.y + c.y) / 2 };
            var ca = { x: (c.x + a.x) / 2, y: (c.y + a.y) / 2 };

            sierpinskiRec(a, ab, ca, depth - 1);
            sierpinskiRec(ab, b, bc, depth - 1);
            sierpinskiRec(ca, bc, c, depth - 1);
        }

        // ---- Fractal Tree ----
        function drawTree(C, depth) {
            depth = Math.min(depth, 12);
            var angle = state.branchAngle != null ? state.branchAngle : 25;
            var baseX = W / 2, baseY = H - pad - 10;
            var trunkLen = Math.min(W, H) * 0.25;

            treeRec(baseX, baseY, -90, trunkLen, depth, angle, C);
        }

        function treeRec(x, y, ang, len, depth, branchAng, C) {
            if (depth === 0 || len < 2) return;

            var rad = ang * Math.PI / 180;
            var x2 = x + Math.cos(rad) * len;
            var y2 = y + Math.sin(rad) * len;

            var t = depth / (state.iterations || 8);
            var r = C.sin[0] * (1 - t) + C.cos[0] * t;
            var g = C.sin[1] * (1 - t) + C.cos[1] * t;
            var b = C.sin[2] * (1 - t) + C.cos[2] * t;
            p.stroke(r, g, b); p.strokeWeight(Math.max(1, depth * 0.8));
            p.line(x, y, x2, y2);

            var shrink = state.shrinkRatio != null ? state.shrinkRatio : 0.7;
            treeRec(x2, y2, ang - branchAng, len * shrink, depth - 1, branchAng, C);
            treeRec(x2, y2, ang + branchAng, len * shrink, depth - 1, branchAng, C);
        }

        // ---- Barnsley Fern ----
        function drawFern(C) {
            var n = state.fernPoints || 50000;
            var cx = W / 2, baseY = H - pad;
            var scale = Math.min(W, H) * 0.045;

            var x = 0, y = 0;
            p.noStroke();
            for (var i = 0; i < n; i++) {
                var r = Math.random();
                var nx, ny;
                if (r < 0.01) { nx = 0; ny = 0.16 * y; }
                else if (r < 0.86) { nx = 0.85 * x + 0.04 * y; ny = -0.04 * x + 0.85 * y + 1.6; }
                else if (r < 0.93) { nx = 0.20 * x - 0.26 * y; ny = 0.23 * x + 0.22 * y + 1.6; }
                else { nx = -0.15 * x + 0.28 * y; ny = 0.26 * x + 0.24 * y + 0.44; }
                x = nx; y = ny;

                var sx = cx + x * scale;
                var sy = baseY - y * scale;
                if (sx >= 0 && sx <= W && sy >= 0 && sy <= H) {
                    var t = y / 10;
                    p.fill(C.sin[0] * (1 - t) + C.cos[0] * t,
                           C.sin[1] * (1 - t) + C.cos[1] * t,
                           C.sin[2] * (1 - t) + C.cos[2] * t, 150);
                    p.rect(sx, sy, 1, 1);
                }
            }
        }

        // ---- Mandelbrot Set ----
        function drawMandelbrot(C) {
            var maxIter = state.maxIter || 50;
            var cx = state.centerX != null ? state.centerX : -0.5;
            var cy = state.centerY != null ? state.centerY : 0;
            var zoom = state.zoom || 1.5;

            // Render to buffer (or use cached)
            if (!mbBuffer || mbBuffer.width !== W || mbBuffer.height !== H ||
                state._mbDirty) {
                mbBuffer = p.createGraphics(W, H);
                mbBuffer.loadPixels();

                for (var px = 0; px < W; px++) {
                    for (var py = 0; py < H; py++) {
                        var x0 = cx + (px - W / 2) / W * zoom * 4;
                        var y0 = cy + (py - H / 2) / H * zoom * 4 * (H / W);
                        var x = 0, y = 0, iter = 0;

                        while (x * x + y * y <= 4 && iter < maxIter) {
                            var xn = x * x - y * y + x0;
                            y = 2 * x * y + y0;
                            x = xn;
                            iter++;
                        }

                        var idx = (py * W + px) * 4;
                        if (iter === maxIter) {
                            mbBuffer.pixels[idx] = 0;
                            mbBuffer.pixels[idx + 1] = 0;
                            mbBuffer.pixels[idx + 2] = 0;
                        } else {
                            var t = iter / maxIter;
                            mbBuffer.pixels[idx] = Math.floor(C.sin[0] * t + C.bg[0] * (1 - t));
                            mbBuffer.pixels[idx + 1] = Math.floor(C.sin[1] * t + C.accent[1] * (1 - t));
                            mbBuffer.pixels[idx + 2] = Math.floor(C.accent[2] * t + C.cos[2] * (1 - t));
                        }
                        mbBuffer.pixels[idx + 3] = 255;
                    }
                }
                mbBuffer.updatePixels();
                state._mbDirty = false;
            }

            p.image(mbBuffer, 0, 0);

            // Crosshair at center
            p.stroke(255, 255, 255, 100); p.strokeWeight(1);
            p.drawingContext.setLineDash([3, 3]);
            p.line(W / 2 - 15, H / 2, W / 2 + 15, H / 2);
            p.line(W / 2, H / 2 - 15, W / 2, H / 2 + 15);
            p.drawingContext.setLineDash([]);

            // Info
            p.fill(255, 255, 255, 200); p.noStroke(); p.textSize(10);
            p.textAlign(p.LEFT, p.TOP);
            p.text('Center: ' + cx.toFixed(4) + ' + ' + cy.toFixed(4) + 'i', pad, pad);
            p.text('Zoom: ' + (1 / zoom).toFixed(1) + 'x | Iterations: ' + maxIter, pad, pad + 14);
        }

        function updateValues() {
            var ft = state.fractalType || 'koch';
            var iter = state.iterations != null ? state.iterations : 4;
            var names = { koch: 'Koch Snowflake', sierpinski: 'Sierpinski Triangle', tree: 'Fractal Tree', fern: 'Barnsley Fern', mandelbrot: 'Mandelbrot Set' };
            setEl('val-fractal', names[ft] || ft);

            if (ft === 'koch') {
                setEl('val-dimension', 'log4/log3 \u2248 1.262');
                setEl('val-segments', Math.pow(4, iter) * 3 + ' segments');
                setEl('val-property', 'Infinite perimeter, finite area');
                setEl('val-iterations', iter + ' iterations');
            } else if (ft === 'sierpinski') {
                setEl('val-dimension', 'log3/log2 \u2248 1.585');
                setEl('val-segments', Math.pow(3, iter) + ' triangles');
                setEl('val-property', 'Area \u2192 0 as iterations \u2192 \u221E');
                setEl('val-iterations', iter + ' iterations');
            } else if (ft === 'tree') {
                setEl('val-dimension', '~1.5 (varies)');
                setEl('val-segments', Math.pow(2, iter + 1) - 1 + ' branches');
                setEl('val-property', 'Angle: ' + (state.branchAngle || 25) + '\u00B0');
                setEl('val-iterations', iter + ' depth');
            } else if (ft === 'fern') {
                setEl('val-dimension', '~1.45');
                setEl('val-segments', (state.fernPoints || 50000) + ' points');
                setEl('val-property', 'Iterated Function System');
                setEl('val-iterations', '4 affine transforms');
            } else if (ft === 'mandelbrot') {
                setEl('val-dimension', '2.0 (boundary)');
                setEl('val-segments', W * H + ' pixels');
                setEl('val-property', 'z\u2099\u208A\u2081 = z\u2099\u00B2 + c');
                setEl('val-iterations', (state.maxIter || 50) + ' max iterations');
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { state._mbDirty = true; p.loop(); };
    }

    VisualMath.register('fractals', fractalViz);
})();
