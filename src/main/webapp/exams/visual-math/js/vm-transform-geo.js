/**
 * Visual Math — Geometric Transformations
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;
    var baseShape = [[-1, -1], [2, -1], [2, 1.5], [0, 2.5]]; // L-shaped quad for clarity

    function transformGeoViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawTransform(C);
            updateValues();
            p.noLoop();
        };

        function drawTransform(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad + gw / 2, oy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 16;

            function toX(v) { return ox + v * sc; }
            function toY(v) { return oy - v * sc; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var i = -8; i <= 8; i++) {
                p.line(toX(i), pad, toX(i), pad + gh);
                p.line(pad, toY(i), pad + gw, toY(i));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            var transType = state.transformType || 'translate';
            var tx = state.tx || 0, ty = state.ty || 0;
            var angle = state.angle || 0;
            var scaleFactor = state.scaleFactor || 1;
            var reflectAxis = state.reflectAxis || 'x';

            // Reflection line
            if (transType === 'reflect') {
                p.stroke(C.muted); p.strokeWeight(1.5);
                p.drawingContext.setLineDash([5, 4]);
                if (reflectAxis === 'x') p.line(pad, oy, pad + gw, oy);
                else if (reflectAxis === 'y') p.line(ox, pad, ox, pad + gh);
                else if (reflectAxis === 'y=x') p.line(toX(-8), toY(-8), toX(8), toY(8));
                p.drawingContext.setLineDash([]);
            }

            // Compute transformed shape
            var transformed = baseShape.map(function (pt) {
                var x = pt[0], y = pt[1];
                if (transType === 'translate') return [x + tx, y + ty];
                if (transType === 'rotate') {
                    var rad = angle * Math.PI / 180;
                    return [x * Math.cos(rad) - y * Math.sin(rad), x * Math.sin(rad) + y * Math.cos(rad)];
                }
                if (transType === 'reflect') {
                    if (reflectAxis === 'x') return [x, -y];
                    if (reflectAxis === 'y') return [-x, y];
                    return [y, x]; // y=x
                }
                if (transType === 'dilate') return [x * scaleFactor, y * scaleFactor];
                return [x, y];
            });

            // Original shape (ghost)
            p.fill(C.sin[0], C.sin[1], C.sin[2], 25);
            p.stroke(C.sin[0], C.sin[1], C.sin[2], 80); p.strokeWeight(1.5);
            p.beginShape();
            for (var i2 = 0; i2 < baseShape.length; i2++) p.vertex(toX(baseShape[i2][0]), toY(baseShape[i2][1]));
            p.endShape(p.CLOSE);

            // Original vertices
            p.fill(C.sin[0], C.sin[1], C.sin[2], 120); p.noStroke();
            for (var j = 0; j < baseShape.length; j++) p.ellipse(toX(baseShape[j][0]), toY(baseShape[j][1]), 6, 6);

            // Transformed shape
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.stroke(C.accent); p.strokeWeight(2.5);
            p.beginShape();
            for (var m = 0; m < transformed.length; m++) p.vertex(toX(transformed[m][0]), toY(transformed[m][1]));
            p.endShape(p.CLOSE);

            // Transformed vertices
            p.fill(C.accent); p.noStroke();
            for (var n = 0; n < transformed.length; n++) p.ellipse(toX(transformed[n][0]), toY(transformed[n][1]), 8, 8);

            // Mapping arrows
            p.stroke(C.muted); p.strokeWeight(1);
            var labels = ['A', 'B', 'C', 'D'];
            for (var q = 0; q < baseShape.length; q++) {
                var fx = toX(baseShape[q][0]), fy = toY(baseShape[q][1]);
                var ttx = toX(transformed[q][0]), tty = toY(transformed[q][1]);
                if (Math.hypot(ttx - fx, tty - fy) > 10) {
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(fx, fy, ttx, tty);
                    p.drawingContext.setLineDash([]);
                }

                p.noStroke(); p.textSize(11); p.textAlign(p.LEFT, p.BOTTOM);
                p.fill(C.sin[0], C.sin[1], C.sin[2], 150);
                p.text(labels[q], fx + 5, fy - 4);
                p.fill(C.accent);
                p.text(labels[q] + '\u2032', ttx + 5, tty - 4);
            }
        }

        function updateValues() {
            var type = state.transformType || 'translate';
            var names = { translate: 'Translation', rotate: 'Rotation', reflect: 'Reflection', dilate: 'Dilation' };
            setEl('val-transform', names[type] || type);

            if (type === 'translate') {
                setEl('val-rule', '(x,y) \u2192 (x+' + (state.tx || 0).toFixed(1) + ', y+' + (state.ty || 0).toFixed(1) + ')');
                setEl('val-params', 'dx=' + (state.tx || 0).toFixed(1) + ', dy=' + (state.ty || 0).toFixed(1));
            } else if (type === 'rotate') {
                setEl('val-rule', '(x,y) \u2192 (xcos\u03B8\u2212ysin\u03B8, xsin\u03B8+ycos\u03B8)');
                setEl('val-params', '\u03B8 = ' + (state.angle || 0).toFixed(0) + '\u00B0');
            } else if (type === 'reflect') {
                var ax = state.reflectAxis || 'x';
                var rules = { x: '(x,y) \u2192 (x,\u2212y)', y: '(x,y) \u2192 (\u2212x,y)', 'y=x': '(x,y) \u2192 (y,x)' };
                setEl('val-rule', rules[ax] || '');
                setEl('val-params', 'Axis: ' + (ax === 'x' ? 'x-axis' : ax === 'y' ? 'y-axis' : 'y = x'));
            } else if (type === 'dilate') {
                var s = state.scaleFactor || 1;
                setEl('val-rule', '(x,y) \u2192 (' + s.toFixed(1) + 'x, ' + s.toFixed(1) + 'y)');
                setEl('val-params', 'k = ' + s.toFixed(1));
            }
            setEl('val-preserves', type === 'dilate' ? 'Shape (not size)' : 'Shape and size');
            setEl('val-isometry', type === 'dilate' ? (Math.abs((state.scaleFactor || 1)) === 1 ? 'Yes' : 'No') : 'Yes');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('transform-geo', transformGeoViz);
})();
