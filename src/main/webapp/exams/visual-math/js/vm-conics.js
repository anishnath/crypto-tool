/**
 * Visual Math — Conic Sections Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function conicsViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawConic(C);
            updateValues();
            p.noLoop();
        };

        function drawConic(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad + gw / 2, oy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 14;

            function toX(v) { return ox + v * sc; }
            function toY(v) { return oy - v * sc; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]);
            p.strokeWeight(0.5);
            for (var i = -7; i <= 7; i++) {
                p.line(toX(i), pad, toX(i), pad + gh);
                p.line(pad, toY(i), pad + gw, toY(i));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            p.textAlign(p.CENTER, p.TOP);
            for (var k = -6; k <= 6; k += 2) { if (k !== 0) p.text(k, toX(k), oy + 4); }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var l = -6; l <= 6; l += 2) { if (l !== 0) p.text(l, ox - 6, toY(l)); }

            var type = state.conicType || 'ellipse';
            var a = state.a || 3, b = state.b || 2;

            if (type === 'circle') {
                p.noFill(); p.stroke(C.sin); p.strokeWeight(2.5);
                p.ellipse(ox, oy, a * sc * 2, a * sc * 2);

                p.fill(C.accent); p.noStroke();
                p.ellipse(ox, oy, 8, 8);

                // Radius line
                p.stroke(C.accent); p.strokeWeight(1.5);
                p.drawingContext.setLineDash([4, 3]);
                p.line(ox, oy, toX(a), oy);
                p.drawingContext.setLineDash([]);

                p.fill(C.sin); p.noStroke(); p.textSize(12);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('r = ' + a.toFixed(1), toX(a) + 6, oy - 10);

            } else if (type === 'ellipse') {
                p.noFill(); p.stroke(C.sin); p.strokeWeight(2.5);
                p.ellipse(ox, oy, a * sc * 2, b * sc * 2);

                var c = Math.sqrt(Math.abs(a * a - b * b));
                var major = a >= b;

                // Foci
                p.fill(C.cos); p.noStroke();
                if (major) {
                    p.ellipse(toX(c), oy, 9, 9);
                    p.ellipse(toX(-c), oy, 9, 9);
                } else {
                    p.ellipse(ox, toY(c), 9, 9);
                    p.ellipse(ox, toY(-c), 9, 9);
                }

                // Vertices
                p.fill(C.accent); p.noStroke();
                p.ellipse(toX(a), oy, 7, 7); p.ellipse(toX(-a), oy, 7, 7);
                p.ellipse(ox, toY(b), 7, 7); p.ellipse(ox, toY(-b), 7, 7);

                // Labels
                p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                p.fill(C.cos);
                if (major) {
                    p.text('F\u2081', toX(-c), oy + 10);
                    p.text('F\u2082', toX(c), oy + 10);
                }

                // Directrices
                if (state.showDirectrix && c > 0.01) {
                    var dxVal = a * a / c;
                    p.stroke(C.muted); p.strokeWeight(1);
                    p.drawingContext.setLineDash([5, 4]);
                    p.line(toX(dxVal), pad, toX(dxVal), pad + gh);
                    p.line(toX(-dxVal), pad, toX(-dxVal), pad + gh);
                    p.drawingContext.setLineDash([]);
                }

            } else if (type === 'hyperbola') {
                var ch = Math.sqrt(a * a + b * b);

                // Asymptotes
                p.stroke(C.muted); p.strokeWeight(1);
                p.drawingContext.setLineDash([5, 4]);
                p.line(toX(-7), toY(-7 * b / a), toX(7), toY(7 * b / a));
                p.line(toX(-7), toY(7 * b / a), toX(7), toY(-7 * b / a));
                p.drawingContext.setLineDash([]);

                // Right branch
                p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
                p.beginShape();
                for (var t = -2.5; t <= 2.5; t += 0.04) {
                    var hx = a * Math.cosh(t), hy = b * Math.sinh(t);
                    if (Math.abs(hx) <= 7 && Math.abs(hy) <= 7) p.vertex(toX(hx), toY(hy));
                }
                p.endShape();

                // Left branch
                p.beginShape();
                for (var t2 = -2.5; t2 <= 2.5; t2 += 0.04) {
                    var hx2 = -a * Math.cosh(t2), hy2 = b * Math.sinh(t2);
                    if (Math.abs(hx2) <= 7 && Math.abs(hy2) <= 7) p.vertex(toX(hx2), toY(hy2));
                }
                p.endShape();

                // Foci & vertices
                p.fill(C.cos); p.noStroke();
                p.ellipse(toX(ch), oy, 9, 9); p.ellipse(toX(-ch), oy, 9, 9);
                p.fill(C.accent);
                p.ellipse(toX(a), oy, 7, 7); p.ellipse(toX(-a), oy, 7, 7);

                p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                p.fill(C.cos);
                p.text('F\u2081', toX(-ch), oy + 10);
                p.text('F\u2082', toX(ch), oy + 10);

            } else if (type === 'parabola') {
                var pv = a;

                p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
                p.beginShape();
                for (var px = -7; px <= 7; px += 0.05) {
                    var py = px * px / (4 * pv);
                    if (Math.abs(py) <= 7) p.vertex(toX(px), toY(py));
                }
                p.endShape();

                // Focus
                p.fill(C.cos); p.noStroke();
                p.ellipse(ox, toY(pv), 9, 9);

                // Directrix
                p.stroke(C.muted); p.strokeWeight(1);
                p.drawingContext.setLineDash([5, 4]);
                p.line(pad, toY(-pv), pad + gw, toY(-pv));
                p.drawingContext.setLineDash([]);

                // Vertex
                p.fill(C.accent); p.noStroke();
                p.ellipse(ox, oy, 8, 8);

                p.fill(C.cos); p.textSize(11);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('Focus', ox + 8, toY(pv));
                p.fill(C.muted);
                p.text('Directrix', pad + 6, toY(-pv) - 10);
            }
        }

        function updateValues() {
            var type = state.conicType || 'ellipse';
            var a = state.a || 3, b = state.b || 2;

            setEl('val-type', type.charAt(0).toUpperCase() + type.slice(1));

            if (type === 'circle') {
                setEl('val-equation', 'x\u00B2 + y\u00B2 = ' + (a * a).toFixed(1));
                setEl('val-foci', 'Center (0, 0)');
                setEl('val-eccentricity', 'e = 0');
                setEl('val-vertices', '(\u00B1' + a.toFixed(1) + ', 0)');
                setEl('val-extra', 'r = ' + a.toFixed(2));
            } else if (type === 'ellipse') {
                var c = Math.sqrt(Math.abs(a * a - b * b));
                var e = a >= b ? c / a : c / b;
                setEl('val-equation', 'x\u00B2/' + (a * a).toFixed(1) + ' + y\u00B2/' + (b * b).toFixed(1) + ' = 1');
                setEl('val-foci', '(\u00B1' + c.toFixed(2) + ', 0)');
                setEl('val-eccentricity', 'e = ' + e.toFixed(3));
                setEl('val-vertices', '(\u00B1' + a.toFixed(1) + ', 0), (0, \u00B1' + b.toFixed(1) + ')');
                setEl('val-extra', 'c = ' + c.toFixed(2));
            } else if (type === 'hyperbola') {
                var ch = Math.sqrt(a * a + b * b);
                setEl('val-equation', 'x\u00B2/' + (a * a).toFixed(1) + ' \u2212 y\u00B2/' + (b * b).toFixed(1) + ' = 1');
                setEl('val-foci', '(\u00B1' + ch.toFixed(2) + ', 0)');
                setEl('val-eccentricity', 'e = ' + (ch / a).toFixed(3));
                setEl('val-vertices', '(\u00B1' + a.toFixed(1) + ', 0)');
                setEl('val-extra', 'Asymptotes: y = \u00B1' + (b / a).toFixed(2) + 'x');
            } else if (type === 'parabola') {
                setEl('val-equation', 'x\u00B2 = ' + (4 * a).toFixed(1) + 'y');
                setEl('val-foci', '(0, ' + a.toFixed(2) + ')');
                setEl('val-eccentricity', 'e = 1');
                setEl('val-vertices', '(0, 0)');
                setEl('val-extra', 'Directrix: y = ' + (-a).toFixed(2));
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('conics', conicsViz);
})();
