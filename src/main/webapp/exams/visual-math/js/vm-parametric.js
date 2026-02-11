/**
 * Visual Math — Parametric Curves Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function parametricViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getMaxT() {
            var curve = state.curveType || 'lissajous';
            if (curve === 'butterfly') return 12 * Math.PI;
            return 2 * Math.PI;
        }

        function getCurve(t) {
            var curve = state.curveType || 'lissajous';
            var a = state.paramA != null ? state.paramA : 3;
            var b = state.paramB != null ? state.paramB : 2;

            if (curve === 'lissajous') {
                return { x: Math.sin(a * t), y: Math.sin(b * t) };
            }
            if (curve === 'epicycloid') {
                var R = a, r = 1;
                return {
                    x: (R + r) * Math.cos(t) - r * Math.cos((R + r) / r * t),
                    y: (R + r) * Math.sin(t) - r * Math.sin((R + r) / r * t)
                };
            }
            if (curve === 'astroid') {
                return {
                    x: a * Math.pow(Math.cos(t), 3),
                    y: a * Math.pow(Math.sin(t), 3)
                };
            }
            if (curve === 'butterfly') {
                var bt = Math.exp(Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5);
                return { x: Math.sin(t) * bt, y: Math.cos(t) * bt };
            }
            if (curve === 'hypotrochoid') {
                var R2 = a, r2 = b;
                return {
                    x: (R2 - r2) * Math.cos(t) + r2 * Math.cos((R2 - r2) / r2 * t),
                    y: (R2 - r2) * Math.sin(t) - r2 * Math.sin((R2 - r2) / r2 * t)
                };
            }
            return { x: Math.sin(a * t), y: Math.sin(b * t) };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawParametric(C);
            updateValues();
            if (state.animating) {
                state.traceT = (state.traceT || 0) + 0.04;
                if (state.traceT > getMaxT()) state.traceT = getMaxT();
            } else {
                p.noLoop();
            }
        };

        function drawParametric(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad + gw / 2, oy = pad + gh / 2;

            // Find max extent for scaling
            var maxExt = 0;
            var maxT = getMaxT();
            for (var t = 0; t <= maxT; t += 0.05) {
                var pt = getCurve(t);
                if (!isNaN(pt.x) && !isNaN(pt.y)) {
                    maxExt = Math.max(maxExt, Math.abs(pt.x), Math.abs(pt.y));
                }
            }
            if (maxExt < 0.1) maxExt = 1;
            var sc = Math.min(gw, gh) / 2 / maxExt * 0.85;

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            var step = maxExt / 3;
            for (var g = -3; g <= 3; g++) {
                var gx = ox + g * step * sc, gy = oy - g * step * sc;
                if (gx > pad && gx < pad + gw) p.line(gx, pad, gx, pad + gh);
                if (gy > pad && gy < pad + gh) p.line(pad, gy, pad + gw, gy);
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Axis labels
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP); p.text('x', pad + gw - 6, oy + 4);
            p.textAlign(p.RIGHT, p.CENTER); p.text('y', ox - 6, pad + 8);

            // Tick labels
            p.textSize(8); p.textAlign(p.CENTER, p.TOP);
            for (var tk = -3; tk <= 3; tk++) {
                if (tk === 0) continue;
                var tv = tk * step;
                var tx = ox + tv * sc;
                if (tx > pad + 5 && tx < pad + gw - 5) p.text(tv.toFixed(1), tx, oy + 4);
            }

            // Draw curve
            var traceEnd = state.animating ? (state.traceT || 0) : maxT;
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var t2 = 0; t2 <= Math.min(maxT, traceEnd); t2 += 0.02) {
                var pt2 = getCurve(t2);
                if (!isNaN(pt2.x) && !isNaN(pt2.y)) {
                    var sx = ox + pt2.x * sc, sy = oy - pt2.y * sc;
                    if (sx >= pad - 10 && sx <= pad + gw + 10 && sy >= pad - 10 && sy <= pad + gh + 10) {
                        p.vertex(sx, sy);
                    } else {
                        p.endShape();
                        p.beginShape();
                    }
                }
            }
            p.endShape();

            // Current point during animation
            if (state.animating && traceEnd < maxT) {
                var curr = getCurve(traceEnd);
                if (!isNaN(curr.x) && !isNaN(curr.y)) {
                    var cpx = ox + curr.x * sc, cpy = oy - curr.y * sc;

                    p.stroke(C.accent[0], C.accent[1], C.accent[2], 80); p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(cpx, cpy, cpx, oy);
                    p.line(cpx, cpy, ox, cpy);
                    p.drawingContext.setLineDash([]);

                    p.fill(C.accent); p.noStroke();
                    p.ellipse(cpx, cpy, 10, 10);

                    p.fill(C.accent); p.textSize(10);
                    p.textAlign(p.LEFT, p.BOTTOM);
                    p.text('t = ' + traceEnd.toFixed(2), cpx + 8, cpy - 4);
                }
            }

            // Equation label
            p.fill(C.sin); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.TOP);
            p.text(getEqLabel(), pad + 6, pad + 6);
        }

        function getEqLabel() {
            var curve = state.curveType || 'lissajous';
            var a = state.paramA != null ? state.paramA : 3;
            var b = state.paramB != null ? state.paramB : 2;
            if (curve === 'lissajous') return 'x=sin(' + a + 't), y=sin(' + b + 't)';
            if (curve === 'epicycloid') return 'Epicycloid R=' + a + ', r=1';
            if (curve === 'astroid') return 'x=' + a + 'cos\u00B3t, y=' + a + 'sin\u00B3t';
            if (curve === 'butterfly') return 'Butterfly curve';
            if (curve === 'hypotrochoid') return 'Hypotrochoid R=' + a + ', r=' + b;
            return '';
        }

        function updateValues() {
            var curve = state.curveType || 'lissajous';
            var a = state.paramA != null ? state.paramA : 3;
            var b = state.paramB != null ? state.paramB : 2;
            var names = { lissajous: 'Lissajous Curve', epicycloid: 'Epicycloid', astroid: 'Astroid', butterfly: 'Butterfly Curve', hypotrochoid: 'Hypotrochoid' };
            setEl('val-curve', names[curve] || curve);

            if (curve === 'lissajous') {
                setEl('val-xt', 'x(t) = sin(' + a + 't)');
                setEl('val-yt', 'y(t) = sin(' + b + 't)');
                setEl('val-period', '2\u03C0');
                setEl('val-symmetry', 'Ratio ' + a + ':' + b);
            } else if (curve === 'epicycloid') {
                setEl('val-xt', 'x = ' + (a + 1) + 'cos t \u2212 cos(' + (a + 1) + 't)');
                setEl('val-yt', 'y = ' + (a + 1) + 'sin t \u2212 sin(' + (a + 1) + 't)');
                setEl('val-period', '2\u03C0');
                setEl('val-symmetry', a + ' cusps');
            } else if (curve === 'astroid') {
                setEl('val-xt', 'x(t) = ' + a + '\u00B7cos\u00B3(t)');
                setEl('val-yt', 'y(t) = ' + a + '\u00B7sin\u00B3(t)');
                setEl('val-period', '2\u03C0');
                setEl('val-symmetry', 'Both axes');
            } else if (curve === 'butterfly') {
                setEl('val-xt', 'x = sin(t)\u00B7f(t)');
                setEl('val-yt', 'y = cos(t)\u00B7f(t)');
                setEl('val-period', '12\u03C0');
                setEl('val-symmetry', 'y-axis');
            } else if (curve === 'hypotrochoid') {
                setEl('val-xt', 'x = ' + (a - b) + 'cos t + ' + b + 'cos(' + ((a - b) / b).toFixed(1) + 't)');
                setEl('val-yt', 'y = ' + (a - b) + 'sin t \u2212 ' + b + 'sin(' + ((a - b) / b).toFixed(1) + 't)');
                setEl('val-period', '2\u03C0');
                setEl('val-symmetry', (a % b === 0) ? 'Closed (' + (a / b) + '-fold)' : 'Open');
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('parametric', parametricViz);
})();
