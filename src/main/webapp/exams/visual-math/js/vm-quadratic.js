/**
 * Visual Math — Quadratic Explorer
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;

    function quadratic(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 20, padB = 40;

        if (state.a == null) state.a = 1;
        if (state.b == null) state.b = 0;
        if (state.c == null) state.c = -4;

        function layout() {
            W = container.clientWidth;
            H = Math.max(350, Math.min(480, W * 0.55));
        }

        p.setup = function() { layout(); p.createCanvas(W, H); };
        p.windowResized = function() { layout(); p.resizeCanvas(W, H); };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);

            var a = state.a, b = state.b, c = state.c;
            if (a === 0) a = 0.01; // avoid degenerate case
            var gw = W - padL - padR, gh = H - padT - padB;

            // Vertex
            var vh = -b / (2 * a);
            var vk = a * vh * vh + b * vh + c;

            // Discriminant
            var disc = b * b - 4 * a * c;
            var roots = [];
            if (disc >= 0) {
                roots.push((-b - Math.sqrt(disc)) / (2 * a));
                roots.push((-b + Math.sqrt(disc)) / (2 * a));
            }

            // X range: show vertex and roots
            var xCenter = vh;
            var xSpan = Math.max(6, Math.abs(vh) * 2 + 4);
            if (roots.length === 2) {
                xSpan = Math.max(xSpan, Math.abs(roots[1] - roots[0]) * 2 + 4);
            }
            var xMin = xCenter - xSpan / 2;
            var xMax = xCenter + xSpan / 2;

            // Y range from sampling
            var yMin = Infinity, yMax = -Infinity;
            for (var si = 0; si <= 200; si++) {
                var sx = xMin + (si / 200) * (xMax - xMin);
                var sy = a * sx * sx + b * sx + c;
                if (isFinite(sy) && Math.abs(sy) < 1e4) {
                    if (sy < yMin) yMin = sy;
                    if (sy > yMax) yMax = sy;
                }
            }
            // Ensure 0 is visible
            if (yMin > 0) yMin = -1;
            if (yMax < 0) yMax = 1;
            var yPad = (yMax - yMin) * 0.12 || 1;
            yMin -= yPad; yMax += yPad;

            function mapX(x) { return padL + ((x - xMin) / (xMax - xMin)) * gw; }
            function mapY(y) { return padT + gh - ((y - yMin) / (yMax - yMin)) * gh; }

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            var yStep = niceStep(yMax - yMin, 5);
            var yStart = Math.ceil(yMin / yStep) * yStep;
            for (var yg = yStart; yg <= yMax; yg += yStep) {
                var yy = mapY(yg);
                if (yy > padT && yy < padT + gh) {
                    p.line(padL, yy, padL + gw, yy);
                    p.fill(C.muted); p.noStroke(); p.textSize(10);
                    p.textAlign(p.RIGHT, p.CENTER);
                    p.text(fmt(yg), padL - 6, yy);
                    p.stroke(C.grid); p.strokeWeight(0.5);
                }
            }
            var xStep = niceStep(xMax - xMin, 6);
            var xs = Math.ceil(xMin / xStep) * xStep;
            for (var xg = xs; xg <= xMax; xg += xStep) {
                var xx = mapX(xg);
                if (xx > padL && xx < padL + gw) p.line(xx, padT, xx, padT + gh);
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            if (yMin <= 0 && yMax >= 0) p.line(padL, mapY(0), padL + gw, mapY(0));
            if (xMin <= 0 && xMax >= 0) p.line(mapX(0), padT, mapX(0), padT + gh);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.TOP);
            var baseY = (yMin <= 0 && yMax >= 0) ? mapY(0) + 6 : padT + gh + 6;
            for (var xl = xs; xl <= xMax; xl += xStep) {
                var xlx = mapX(xl);
                if (xlx > padL + 15 && xlx < padL + gw - 15) p.text(fmt(xl), xlx, baseY);
            }

            // Axis of symmetry (dashed)
            p.stroke(C.accent[0], C.accent[1], C.accent[2], 80); p.strokeWeight(1);
            p.drawingContext.setLineDash([5, 5]);
            p.line(mapX(vh), padT, mapX(vh), padT + gh);
            p.drawingContext.setLineDash([]);

            // Parabola
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var ci = 0; ci <= gw; ci += 2) {
                var cx = xMin + (ci / gw) * (xMax - xMin);
                var cy = a * cx * cx + b * cx + c;
                if (isFinite(cy)) {
                    var py = mapY(cy);
                    py = Math.max(padT - 50, Math.min(padT + gh + 50, py));
                    p.vertex(padL + ci, py);
                }
            }
            p.endShape();

            // Vertex
            var vxs = mapX(vh), vys = mapY(vk);
            if (vys > padT - 20 && vys < padT + gh + 20) {
                p.fill(C.accent); p.stroke(255); p.strokeWeight(2);
                p.ellipse(vxs, vys, 12, 12);
                p.fill(C.accent); p.noStroke(); p.textSize(11);
                p.textAlign(p.CENTER, a > 0 ? p.BOTTOM : p.TOP);
                p.text('(' + vh.toFixed(2) + ', ' + vk.toFixed(2) + ')', vxs, vys + (a > 0 ? -10 : 14));
            }

            // Roots
            for (var ri = 0; ri < roots.length; ri++) {
                var rx = mapX(roots[ri]), ry = mapY(0);
                p.fill(C.cos); p.stroke(255); p.strokeWeight(2);
                p.ellipse(rx, ry, 10, 10);
                p.fill(C.cos); p.noStroke(); p.textSize(10);
                p.textAlign(p.CENTER, p.TOP);
                p.text(roots[ri].toFixed(2), rx, ry + 8);
            }

            // Y-intercept
            var yi = mapX(0), yiy = mapY(c);
            if (yi > padL && yi < padL + gw && yiy > padT && yiy < padT + gh) {
                p.fill(C.tan); p.noStroke();
                p.ellipse(yi, yiy, 8, 8);
            }

            // Info labels
            p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.fill(C.sin);
            var eq = 'y = ' + fmtCoeff(a) + 'x\u00B2' + fmtTerm(b, 'x') + fmtConst(c);
            p.text(eq, padL + 10, padT + 6);
            p.fill(C.muted); p.textSize(10);
            p.text('vertex: (' + vh.toFixed(2) + ', ' + vk.toFixed(2) + ')', padL + 10, padT + 24);
            p.text('\u0394 = ' + disc.toFixed(2) + (disc > 0 ? ' (2 real roots)' : disc === 0 ? ' (1 root)' : ' (no real roots)'), padL + 10, padT + 38);

            // Sync panel
            setEl('val-vertex', '(' + vh.toFixed(2) + ', ' + vk.toFixed(2) + ')');
            setEl('val-disc', disc.toFixed(2));
            if (roots.length === 2) {
                setEl('val-roots', roots[0].toFixed(3) + ', ' + roots[1].toFixed(3));
            } else if (roots.length === 1) {
                setEl('val-roots', roots[0].toFixed(3));
            } else {
                setEl('val-roots', 'None (complex)');
            }
            setEl('val-yint', c.toFixed(2));
            setEl('val-vertex-form', fmtCoeff(a) + '(x ' + (vh >= 0 ? '- ' : '+ ') + Math.abs(vh).toFixed(2) + ')\u00B2 ' + (vk >= 0 ? '+ ' : '- ') + Math.abs(vk).toFixed(2));

            p.noLoop();
        };

        function fmtCoeff(v) {
            if (v === 1) return '';
            if (v === -1) return '-';
            return v.toFixed(1);
        }
        function fmtTerm(v, x) {
            if (Math.abs(v) < 0.01) return '';
            var sign = v >= 0 ? ' + ' : ' - ';
            var av = Math.abs(v);
            return sign + (av === 1 ? '' : av.toFixed(1)) + x;
        }
        function fmtConst(v) {
            if (Math.abs(v) < 0.01) return '';
            return v >= 0 ? ' + ' + v.toFixed(1) : ' - ' + Math.abs(v).toFixed(1);
        }
        function niceStep(range, target) {
            var rough = range / target;
            var mag = Math.pow(10, Math.floor(Math.log10(rough)));
            var norm = rough / mag;
            if (norm < 1.5) return mag;
            if (norm < 3) return 2 * mag;
            if (norm < 7) return 5 * mag;
            return 10 * mag;
        }
        function fmt(v) {
            if (Math.abs(v) < 0.0001) return '0';
            if (Math.abs(v - Math.round(v)) < 0.0001) return String(Math.round(v));
            return v.toFixed(1);
        }
        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function() { p.loop(); };
    }

    VisualMath.register('quadratic', quadratic);
})();
