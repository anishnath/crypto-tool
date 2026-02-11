/**
 * Visual Math — Permutations & Combinations Visualizer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function combinatoricsViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 30;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function fact(n) {
            if (n <= 1) return 1;
            var r = 1;
            for (var i = 2; i <= n; i++) r *= i;
            return r;
        }

        function perm(n, r) { return fact(n) / fact(n - r); }
        function comb(n, r) { return fact(n) / (fact(r) * fact(n - r)); }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var mode = state.vizMode || 'pascal';
            if (mode === 'pascal') drawPascal(C);
            else if (mode === 'selection') drawSelection(C);
            else if (mode === 'arrangement') drawArrangement(C);
            updateValues();
            p.noLoop();
        };

        function drawPascal(C) {
            var n = state.n != null ? state.n : 6;
            var r = state.r != null ? state.r : 2;
            var maxN = Math.min(n, 12);
            var cellSize = Math.min(40, (W - pad * 2) / (maxN + 2));
            var cy = pad + 20;

            p.textAlign(p.CENTER, p.CENTER);

            for (var row = 0; row <= maxN; row++) {
                var rowWidth = (row + 1) * cellSize;
                var startX = W / 2 - rowWidth / 2 + cellSize / 2;

                for (var col = 0; col <= row; col++) {
                    var val = comb(row, col);
                    var cx = startX + col * cellSize;
                    var isHighlighted = (row === n && col === r);
                    var isInRow = (row === n);

                    if (isHighlighted) {
                        p.fill(C.accent); p.noStroke();
                        p.ellipse(cx, cy, cellSize * 0.85, cellSize * 0.85);
                        p.fill(255); p.textSize(Math.min(12, cellSize * 0.35));
                        p.text(val > 9999 ? val.toExponential(0) : val, cx, cy);
                    } else {
                        if (isInRow) {
                            p.fill(C.sin[0], C.sin[1], C.sin[2], 60); p.noStroke();
                            p.ellipse(cx, cy, cellSize * 0.75, cellSize * 0.75);
                        }
                        p.fill(isInRow ? C.sin : C.text); p.noStroke();
                        p.textSize(Math.min(11, cellSize * 0.3));
                        p.text(val > 9999 ? val.toExponential(0) : val, cx, cy);
                    }
                }

                // Row label
                p.fill(C.muted); p.textSize(9); p.textAlign(p.RIGHT, p.CENTER);
                p.text('n=' + row, W / 2 - rowWidth / 2 - 8, cy);

                cy += cellSize;
            }
        }

        function drawSelection(C) {
            var n = state.n != null ? state.n : 6;
            var r = state.r != null ? state.r : 2;
            n = Math.min(n, 10);
            r = Math.min(r, n);

            var cx = W / 2, baseY = H / 2 - 20;
            var spacing = Math.min(50, (W - pad * 4) / n);
            var startX = cx - (n - 1) * spacing / 2;
            var radius = Math.min(18, spacing * 0.35);

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(13);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('Choose ' + r + ' from ' + n + ' items', cx, pad + 20);

            // All items
            for (var i = 0; i < n; i++) {
                var ix = startX + i * spacing;
                var selected = i < r;

                if (selected) {
                    p.fill(C.accent); p.stroke(C.accent); p.strokeWeight(2);
                    p.ellipse(ix, baseY, radius * 2, radius * 2);
                    p.fill(255); p.noStroke(); p.textSize(14);
                    p.text(i + 1, ix, baseY);

                    // Arrow pointing down
                    p.stroke(C.accent); p.strokeWeight(1.5);
                    p.line(ix, baseY + radius + 5, ix, baseY + radius + 30);
                    p.fill(C.accent); p.noStroke();
                    p.triangle(ix, baseY + radius + 35, ix - 4, baseY + radius + 28, ix + 4, baseY + radius + 28);
                } else {
                    p.fill(C.muted[0], C.muted[1], C.muted[2], 80);
                    p.stroke(C.muted); p.strokeWeight(1.5);
                    p.ellipse(ix, baseY, radius * 2, radius * 2);
                    p.fill(C.muted); p.noStroke(); p.textSize(14);
                    p.text(i + 1, ix, baseY);
                }
            }

            // Selected group
            var selY = baseY + radius + 55;
            p.fill(C.accent[0], C.accent[1], C.accent[2], 20); p.stroke(C.accent); p.strokeWeight(1);
            var selWidth = Math.max(r * spacing, 60);
            p.rect(cx - selWidth / 2 - 10, selY - radius - 10, selWidth + 20, radius * 2 + 20, 8);

            for (var j = 0; j < r; j++) {
                var jx = cx - (r - 1) * spacing / 2 + j * spacing;
                p.fill(C.accent); p.noStroke();
                p.ellipse(jx, selY, radius * 1.8, radius * 1.8);
                p.fill(255); p.textSize(14);
                p.text(j + 1, jx, selY);
            }

            // Result
            p.fill(C.text); p.noStroke(); p.textSize(12);
            p.textAlign(p.CENTER, p.TOP);
            var cVal = comb(state.n || 6, state.r || 2);
            p.text('C(' + (state.n || 6) + ',' + (state.r || 2) + ') = ' + cVal + ' ways', cx, selY + radius + 20);
        }

        function drawArrangement(C) {
            var n = state.n != null ? state.n : 6;
            var r = state.r != null ? state.r : 2;
            n = Math.min(n, 8);
            r = Math.min(r, n);

            var cx = W / 2;
            var spacing = Math.min(50, (W - pad * 4) / n);
            var startX = cx - (n - 1) * spacing / 2;
            var radius = Math.min(18, spacing * 0.35);
            var baseY = H * 0.25;

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(13);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('Arrange ' + r + ' from ' + n + ' items (order matters)', cx, pad + 20);

            // Source items
            for (var i = 0; i < n; i++) {
                var ix = startX + i * spacing;
                p.fill(i < r ? C.sin : C.muted[0], i < r ? C.sin[1] : C.muted[1], i < r ? C.sin[2] : C.muted[2], i < r ? 200 : 80);
                p.stroke(i < r ? C.sin : C.muted); p.strokeWeight(1.5);
                p.ellipse(ix, baseY, radius * 2, radius * 2);
                p.fill(i < r ? 255 : C.muted); p.noStroke(); p.textSize(14);
                p.text(i + 1, ix, baseY);
            }

            // Slots below showing order
            var slotY = baseY + 80;
            var slotSpacing = Math.min(60, (W - pad * 4) / r);
            var slotStartX = cx - (r - 1) * slotSpacing / 2;

            for (var j = 0; j < r; j++) {
                var jx = slotStartX + j * slotSpacing;
                // Slot box
                p.fill(C.accent[0], C.accent[1], C.accent[2], 30);
                p.stroke(C.accent); p.strokeWeight(2);
                p.rect(jx - radius - 5, slotY - radius - 5, radius * 2 + 10, radius * 2 + 10, 6);

                // Position label
                p.fill(C.muted); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER, p.TOP);
                p.text('pos ' + (j + 1), jx, slotY + radius + 8);

                // Choices remaining
                p.fill(C.accent); p.textSize(11);
                p.textAlign(p.CENTER, p.CENTER);
                p.text(n - j + ' choices', jx, slotY - radius - 18);
            }

            // Multiplication arrows
            for (var k = 0; k < r - 1; k++) {
                var kx = slotStartX + k * slotSpacing + radius + 10;
                p.fill(C.text); p.noStroke(); p.textSize(16);
                p.textAlign(p.CENTER, p.CENTER);
                p.text('\u00D7', kx + (slotSpacing - radius * 2 - 20) / 2, slotY);
            }

            // Result
            p.fill(C.text); p.noStroke(); p.textSize(12);
            p.textAlign(p.CENTER, p.TOP);
            var pVal = perm(state.n || 6, state.r || 2);
            p.text('P(' + (state.n || 6) + ',' + (state.r || 2) + ') = ' + pVal + ' arrangements', cx, slotY + radius + 35);
        }

        function updateValues() {
            var n = state.n != null ? state.n : 6;
            var r = state.r != null ? state.r : 2;

            var pVal = perm(n, r);
            var cVal = comb(n, r);

            setEl('val-n', n);
            setEl('val-r', r);
            setEl('val-perm', 'P(' + n + ',' + r + ') = ' + (pVal > 1e9 ? pVal.toExponential(2) : pVal));
            setEl('val-comb', 'C(' + n + ',' + r + ') = ' + (cVal > 1e9 ? cVal.toExponential(2) : cVal));
            setEl('val-nfact', n + '! = ' + fact(n));
            setEl('val-ratio', 'P/C = ' + r + '! = ' + fact(r));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('combinatorics', combinatoricsViz);
})();
