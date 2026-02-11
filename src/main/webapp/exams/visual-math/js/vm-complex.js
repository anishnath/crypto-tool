/**
 * Visual Math — Complex Plane Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function complexViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;
        var dragging = null;
        var ox, oy, sc;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function toX(v) { return ox + v * sc; }
        function toY(v) { return oy - v * sc; }
        function fromX(sx) { return (sx - ox) / sc; }
        function fromY(sy) { return -(sy - oy) / sc; }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var gw = W - pad * 2, gh = H - pad * 2;
            ox = pad + gw / 2; oy = pad + gh / 2;
            sc = Math.min(gw, gh) / 12;

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var i = -6; i <= 6; i++) {
                p.line(toX(i), pad, toX(i), pad + gh);
                p.line(pad, toY(i), pad + gw, toY(i));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Labels
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP); p.text('Re', pad + gw - 6, oy + 6);
            p.textAlign(p.RIGHT, p.CENTER); p.text('Im', ox - 8, pad + 8);

            // Tick labels
            p.textSize(9); p.textAlign(p.CENTER, p.TOP);
            for (var k = -5; k <= 5; k++) { if (k !== 0) p.text(k, toX(k), oy + 4); }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var l = -5; l <= 5; l++) { if (l !== 0) p.text(l + 'i', ox - 6, toY(l)); }

            var re1 = state.re1 != null ? state.re1 : 3;
            var im1 = state.im1 != null ? state.im1 : 2;
            var re2 = state.re2 != null ? state.re2 : -1;
            var im2 = state.im2 != null ? state.im2 : 3;
            var op = state.operation || 'add';

            // z1 modulus circle
            var r1 = Math.sqrt(re1 * re1 + im1 * im1);
            p.noFill(); p.stroke(C.sin[0], C.sin[1], C.sin[2], 40); p.strokeWeight(1);
            p.drawingContext.setLineDash([3, 3]);
            p.ellipse(ox, oy, r1 * sc * 2, r1 * sc * 2);
            p.drawingContext.setLineDash([]);

            // z1 vector
            p.stroke(C.sin); p.strokeWeight(2);
            p.line(ox, oy, toX(re1), toY(im1));
            p.fill(C.sin); p.stroke(C.accent); p.strokeWeight(2);
            p.ellipse(toX(re1), toY(im1), 12, 12);

            // z2 vector
            p.stroke(C.cos); p.strokeWeight(2);
            p.line(ox, oy, toX(re2), toY(im2));
            p.fill(C.cos); p.stroke(C.accent); p.strokeWeight(2);
            p.ellipse(toX(re2), toY(im2), 12, 12);

            // Result
            var resRe, resIm;
            if (op === 'add') {
                resRe = re1 + re2; resIm = im1 + im2;
                p.noFill(); p.stroke(C.accent[0], C.accent[1], C.accent[2], 60); p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 3]);
                p.line(toX(re1), toY(im1), toX(resRe), toY(resIm));
                p.line(toX(re2), toY(im2), toX(resRe), toY(resIm));
                p.drawingContext.setLineDash([]);
            } else if (op === 'subtract') {
                resRe = re1 - re2; resIm = im1 - im2;
            } else if (op === 'multiply') {
                resRe = re1 * re2 - im1 * im2; resIm = re1 * im2 + im1 * re2;
            } else if (op === 'divide') {
                var denom = re2 * re2 + im2 * im2;
                if (denom > 0.001) {
                    resRe = (re1 * re2 + im1 * im2) / denom;
                    resIm = (im1 * re2 - re1 * im2) / denom;
                } else { resRe = 0; resIm = 0; }
            }

            // Result vector
            if (Math.abs(resRe) <= 6 && Math.abs(resIm) <= 6) {
                p.stroke(C.accent); p.strokeWeight(2.5);
                p.line(ox, oy, toX(resRe), toY(resIm));
                p.fill(C.accent); p.noStroke();
                p.ellipse(toX(resRe), toY(resIm), 10, 10);
            }

            // Labels
            p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.CENTER);
            p.fill(C.sin); p.text('z\u2081', toX(re1) + 10, toY(im1));
            p.fill(C.cos); p.text('z\u2082', toX(re2) + 10, toY(im2));
            if (Math.abs(resRe) <= 6 && Math.abs(resIm) <= 6) {
                var opSym = { add: '+', subtract: '\u2212', multiply: '\u00D7', divide: '\u00F7' };
                p.fill(C.accent); p.text('z\u2081' + (opSym[op] || '+') + 'z\u2082', toX(resRe) + 10, toY(resIm));
            }

            updateValues(re1, im1, re2, im2, op, resRe, resIm);
            if (!dragging) p.noLoop();
        };

        function fmtZ(re, im) {
            var s = re.toFixed(1);
            if (im >= 0) s += ' + ' + im.toFixed(1) + 'i';
            else s += ' \u2212 ' + Math.abs(im).toFixed(1) + 'i';
            return s;
        }

        function updateValues(re1, im1, re2, im2, op, resRe, resIm) {
            setEl('val-z1', fmtZ(re1, im1));
            setEl('val-z2', fmtZ(re2, im2));
            setEl('val-polar1', Math.sqrt(re1 * re1 + im1 * im1).toFixed(2) + '\u2220' + (Math.atan2(im1, re1) * 180 / Math.PI).toFixed(1) + '\u00B0');
            setEl('val-polar2', Math.sqrt(re2 * re2 + im2 * im2).toFixed(2) + '\u2220' + (Math.atan2(im2, re2) * 180 / Math.PI).toFixed(1) + '\u00B0');
            var opNames = { add: 'z\u2081 + z\u2082', subtract: 'z\u2081 \u2212 z\u2082', multiply: 'z\u2081 \u00D7 z\u2082', divide: 'z\u2081 \u00F7 z\u2082' };
            setEl('val-result-label', opNames[op] || '');
            setEl('val-result', fmtZ(resRe, resIm));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        p.mousePressed = function () {
            var re1 = state.re1 != null ? state.re1 : 3, im1 = state.im1 != null ? state.im1 : 2;
            var re2 = state.re2 != null ? state.re2 : -1, im2 = state.im2 != null ? state.im2 : 3;
            if (Math.hypot(p.mouseX - toX(re1), p.mouseY - toY(im1)) < 20) { dragging = 'z1'; p.loop(); }
            else if (Math.hypot(p.mouseX - toX(re2), p.mouseY - toY(im2)) < 20) { dragging = 'z2'; p.loop(); }
        };

        p.mouseDragged = function () {
            if (!dragging) return;
            var x = Math.round(fromX(p.mouseX) * 2) / 2;
            var y = Math.round(fromY(p.mouseY) * 2) / 2;
            x = Math.max(-5, Math.min(5, x)); y = Math.max(-5, Math.min(5, y));
            if (dragging === 'z1') { state.re1 = x; state.im1 = y; }
            else { state.re2 = x; state.im2 = y; }
        };

        p.mouseReleased = function () { dragging = null; };

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('complex', complexViz);
})();
