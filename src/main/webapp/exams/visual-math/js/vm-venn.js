/**
 * Visual Math — Venn Diagram / Set Operations
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function vennViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 30;
        var dragging = null;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function defaults() {
            if (state.ax == null) state.ax = -0.6;
            if (state.ay == null) state.ay = 0;
            if (state.bx == null) state.bx = 0.6;
            if (state.by == null) state.by = 0;
            if (!state.operation) state.operation = 'union';
            if (!state.setA) state.setA = [1, 2, 3, 4, 5];
            if (!state.setB) state.setB = [3, 4, 5, 6, 7];
        }

        p.draw = function () {
            defaults();
            var C = VisualMath.palette();
            p.background(C.bg);
            drawVenn(C);
            updateValues();
            if (!dragging) p.noLoop();
        };

        function drawVenn(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var cx = pad + gw / 2, cy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 4;
            var R = sc * 1.2;

            var axs = cx + state.ax * sc, ays = cy + state.ay * sc;
            var bxs = cx + state.bx * sc, bys = cy + state.by * sc;
            var op = state.operation || 'union';

            // Universal set rectangle
            p.noFill(); p.stroke(C.muted); p.strokeWeight(1);
            p.rect(pad + 10, pad + 10, gw - 20, gh - 20);
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.RIGHT, p.TOP);
            p.text('U', pad + gw - 14, pad + 14);

            // Shading via pixel-level clipping using canvas compositing
            // We'll use a simple approach: draw filled shapes with clipping
            var ctx = p.drawingContext;

            // Helper: is point in circle
            function inA(x, y) { return Math.hypot(x - axs, y - ays) <= R; }
            function inB(x, y) { return Math.hypot(x - bxs, y - bys) <= R; }

            function shouldShade(x, y) {
                var a = inA(x, y), b = inB(x, y);
                if (op === 'union') return a || b;
                if (op === 'intersection') return a && b;
                if (op === 'differenceAB') return a && !b;
                if (op === 'differenceBA') return b && !a;
                if (op === 'symmetric') return (a || b) && !(a && b);
                if (op === 'complement') return !a && !b;
                return false;
            }

            // Shade region using scanlines (efficient enough for interactive)
            var step = 3;
            p.noStroke();
            for (var sy = pad + 12; sy < pad + gh - 12; sy += step) {
                for (var sx = pad + 12; sx < pad + gw - 12; sx += step) {
                    if (shouldShade(sx, sy)) {
                        p.fill(C.accent[0], C.accent[1], C.accent[2], 50);
                        p.rect(sx, sy, step, step);
                    }
                }
            }

            // Circle A outline
            p.noFill(); p.stroke(C.sin); p.strokeWeight(2.5);
            p.ellipse(axs, ays, R * 2, R * 2);

            // Circle B outline
            p.noFill(); p.stroke(C.cos); p.strokeWeight(2.5);
            p.ellipse(bxs, bys, R * 2, R * 2);

            // Labels
            p.noStroke(); p.textSize(16); p.textAlign(p.CENTER, p.CENTER);
            p.fill(C.sin);
            p.text('A', axs - R * 0.5, ays - R * 0.6);
            p.fill(C.cos);
            p.text('B', bxs + R * 0.5, bys - R * 0.6);

            // Elements in regions
            var setA = state.setA, setB = state.setB;
            var onlyA = setA.filter(function (x) { return setB.indexOf(x) < 0; });
            var onlyB = setB.filter(function (x) { return setA.indexOf(x) < 0; });
            var both = setA.filter(function (x) { return setB.indexOf(x) >= 0; });

            p.textSize(12); p.textAlign(p.CENTER, p.CENTER);
            // Only A region
            p.fill(C.sin);
            if (onlyA.length > 0) {
                var oax = axs - (bxs - axs) * 0.3;
                p.text('{' + onlyA.join(', ') + '}', oax, ays + 10);
            }
            // Only B region
            p.fill(C.cos);
            if (onlyB.length > 0) {
                var obx = bxs + (bxs - axs) * 0.3;
                p.text('{' + onlyB.join(', ') + '}', obx, bys + 10);
            }
            // Intersection
            p.fill(C.accent);
            if (both.length > 0) {
                var imx = (axs + bxs) / 2, imy = (ays + bys) / 2;
                p.text('{' + both.join(', ') + '}', imx, imy + 10);
            }

            // Operation label
            p.fill(C.text); p.textSize(13); p.textAlign(p.CENTER, p.TOP);
            var opLabels = {
                union: 'A \u222A B', intersection: 'A \u2229 B',
                differenceAB: 'A \\ B', differenceBA: 'B \\ A',
                symmetric: 'A \u2206 B', complement: "(A \u222A B)'"
            };
            p.text(opLabels[op] || '', cx, pad + 14);

            // Drag handles
            p.fill(C.sin[0], C.sin[1], C.sin[2], 200); p.stroke(255); p.strokeWeight(2);
            p.ellipse(axs, ays, 14, 14);
            p.fill(C.cos[0], C.cos[1], C.cos[2], 200);
            p.ellipse(bxs, bys, 14, 14);
        }

        function updateValues() {
            var setA = state.setA || [], setB = state.setB || [];
            var op = state.operation || 'union';

            var result;
            if (op === 'union') result = setA.concat(setB.filter(function (x) { return setA.indexOf(x) < 0; }));
            else if (op === 'intersection') result = setA.filter(function (x) { return setB.indexOf(x) >= 0; });
            else if (op === 'differenceAB') result = setA.filter(function (x) { return setB.indexOf(x) < 0; });
            else if (op === 'differenceBA') result = setB.filter(function (x) { return setA.indexOf(x) < 0; });
            else if (op === 'symmetric') {
                result = setA.filter(function (x) { return setB.indexOf(x) < 0; })
                    .concat(setB.filter(function (x) { return setA.indexOf(x) < 0; }));
            }
            else if (op === 'complement') result = [];
            else result = [];

            result.sort(function (a, b) { return a - b; });

            setEl('val-setA', '{' + setA.join(', ') + '}');
            setEl('val-setB', '{' + setB.join(', ') + '}');
            setEl('val-sizeA', '|A| = ' + setA.length);
            setEl('val-sizeB', '|B| = ' + setB.length);

            var opLabels = {
                union: 'A \u222A B', intersection: 'A \u2229 B',
                differenceAB: 'A \\ B', differenceBA: 'B \\ A',
                symmetric: 'A \u2206 B', complement: "(A \u222A B)'"
            };
            setEl('val-operation', opLabels[op] || '');
            setEl('val-result', result.length > 0 ? '{' + result.join(', ') + '}' : '\u2205');
            setEl('val-result-size', '|Result| = ' + result.length);
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        // Drag circle centers
        p.mousePressed = function () {
            defaults();
            var gw = W - pad * 2, gh = H - pad * 2;
            var cx = pad + gw / 2, cy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 4;
            var axs = cx + state.ax * sc, ays = cy + state.ay * sc;
            var bxs = cx + state.bx * sc, bys = cy + state.by * sc;

            if (Math.hypot(p.mouseX - axs, p.mouseY - ays) < 20) { dragging = 'a'; p.loop(); }
            else if (Math.hypot(p.mouseX - bxs, p.mouseY - bys) < 20) { dragging = 'b'; p.loop(); }
        };

        p.mouseDragged = function () {
            if (!dragging) return;
            var gw = W - pad * 2, gh = H - pad * 2;
            var cx = pad + gw / 2, cy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 4;
            var nx = (p.mouseX - cx) / sc, ny = (p.mouseY - cy) / sc;
            nx = Math.max(-2, Math.min(2, nx));
            ny = Math.max(-1.5, Math.min(1.5, ny));
            if (dragging === 'a') { state.ax = nx; state.ay = ny; }
            else { state.bx = nx; state.by = ny; }
        };

        p.mouseReleased = function () { dragging = null; };

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('venn', vennViz);
})();
