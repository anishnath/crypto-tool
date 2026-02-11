/**
 * Visual Math — Regression & Scatter Plot
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function regressionViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 50;
        var dragging = -1;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function defaultPoints() {
            return [
                { x: 1, y: 2.1 }, { x: 2, y: 3.8 }, { x: 3, y: 5.2 },
                { x: 4, y: 6.5 }, { x: 5, y: 8.1 }, { x: 6, y: 9.8 },
                { x: 7, y: 11.5 }, { x: 8, y: 12.9 }, { x: 9, y: 14.2 },
                { x: 10, y: 16.1 }
            ];
        }

        function getPoints() {
            if (!state.points || state.points.length === 0) state.points = defaultPoints();
            return state.points;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawRegression(C);
            updateValues();
            if (dragging < 0) p.noLoop();
        };

        function drawRegression(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var pts = getPoints();
            var regType = state.regType || 'linear';

            // Find data bounds
            var xMin = Infinity, xMax = -Infinity, yMin = Infinity, yMax = -Infinity;
            for (var i = 0; i < pts.length; i++) {
                if (pts[i].x < xMin) xMin = pts[i].x;
                if (pts[i].x > xMax) xMax = pts[i].x;
                if (pts[i].y < yMin) yMin = pts[i].y;
                if (pts[i].y > yMax) yMax = pts[i].y;
            }
            var xPad = (xMax - xMin) * 0.15 || 1;
            var yPad = (yMax - yMin) * 0.15 || 1;
            xMin -= xPad; xMax += xPad; yMin -= yPad; yMax += yPad;

            var xScale = gw / (xMax - xMin);
            var yScale = gh / (yMax - yMin);

            function toSx(x) { return pad + (x - xMin) * xScale; }
            function toSy(y) { return pad + (yMax - y) * yScale; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            var xStep = niceStep(xMax - xMin, 8);
            var yStep = niceStep(yMax - yMin, 8);
            for (var gx = Math.ceil(xMin / xStep) * xStep; gx <= xMax; gx += xStep) {
                p.line(toSx(gx), pad, toSx(gx), pad + gh);
            }
            for (var gy = Math.ceil(yMin / yStep) * yStep; gy <= yMax; gy += yStep) {
                p.line(pad, toSy(gy), pad + gw, toSy(gy));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            var zx = toSx(0), zy = toSy(0);
            if (zx >= pad && zx <= pad + gw) p.line(zx, pad, zx, pad + gh);
            if (zy >= pad && zy <= pad + gh) p.line(pad, zy, pad + gw, zy);

            // Tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            p.textAlign(p.CENTER, p.TOP);
            for (var tx = Math.ceil(xMin / xStep) * xStep; tx <= xMax; tx += xStep) {
                p.text(tx.toFixed(1), toSx(tx), pad + gh + 4);
            }
            p.textAlign(p.RIGHT, p.CENTER);
            for (var ty = Math.ceil(yMin / yStep) * yStep; ty <= yMax; ty += yStep) {
                p.text(ty.toFixed(1), pad - 4, toSy(ty));
            }

            // Compute regression
            var reg = computeRegression(pts, regType);

            // Draw regression line/curve
            if (state.showLine !== false) {
                p.stroke(C.accent); p.strokeWeight(2.5); p.noFill();
                p.beginShape();
                for (var rx = xMin; rx <= xMax; rx += (xMax - xMin) / 200) {
                    var ry;
                    if (regType === 'linear') {
                        ry = reg.slope * rx + reg.intercept;
                    } else {
                        ry = reg.a * rx * rx + reg.b * rx + reg.c;
                    }
                    if (ry >= yMin - 1 && ry <= yMax + 1) {
                        p.vertex(toSx(rx), toSy(ry));
                    }
                }
                p.endShape();
            }

            // Residuals
            if (state.showResiduals) {
                for (var ri = 0; ri < pts.length; ri++) {
                    var predY;
                    if (regType === 'linear') {
                        predY = reg.slope * pts[ri].x + reg.intercept;
                    } else {
                        predY = reg.a * pts[ri].x * pts[ri].x + reg.b * pts[ri].x + reg.c;
                    }
                    p.stroke(C.cos[0], C.cos[1], C.cos[2], 150); p.strokeWeight(1.5);
                    p.line(toSx(pts[ri].x), toSy(pts[ri].y), toSx(pts[ri].x), toSy(predY));
                }
            }

            // Data points
            for (var di = 0; di < pts.length; di++) {
                var sx = toSx(pts[di].x), sy = toSy(pts[di].y);
                p.fill(C.sin); p.stroke(C.accent); p.strokeWeight(2);
                p.ellipse(sx, sy, 12, 12);
            }

            // Equation label
            p.fill(C.accent); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.TOP);
            if (regType === 'linear') {
                p.text('y = ' + reg.slope.toFixed(3) + 'x + ' + reg.intercept.toFixed(3), pad + 6, pad + 4);
            } else {
                p.text('y = ' + reg.a.toFixed(3) + 'x\u00B2 + ' + reg.b.toFixed(3) + 'x + ' + reg.c.toFixed(3), pad + 6, pad + 4);
            }

            // Store for values panel
            state._reg = reg;
            state._xScale = xScale;
            state._yScale = yScale;
            state._xMin = xMin;
            state._yMax = yMax;
        }

        function computeRegression(pts, type) {
            var n = pts.length;
            if (n === 0) return { slope: 0, intercept: 0, r2: 0, a: 0, b: 0, c: 0 };

            var sx = 0, sy = 0, sxy = 0, sx2 = 0, sy2 = 0;
            for (var i = 0; i < n; i++) {
                sx += pts[i].x; sy += pts[i].y;
                sxy += pts[i].x * pts[i].y;
                sx2 += pts[i].x * pts[i].x;
                sy2 += pts[i].y * pts[i].y;
            }

            if (type === 'linear') {
                var denom = n * sx2 - sx * sx;
                var slope = denom ? (n * sxy - sx * sy) / denom : 0;
                var intercept = (sy - slope * sx) / n;

                // R-squared
                var yMean = sy / n;
                var ssRes = 0, ssTot = 0;
                for (var j = 0; j < n; j++) {
                    var pred = slope * pts[j].x + intercept;
                    ssRes += (pts[j].y - pred) * (pts[j].y - pred);
                    ssTot += (pts[j].y - yMean) * (pts[j].y - yMean);
                }
                var r2 = ssTot > 0 ? 1 - ssRes / ssTot : 1;
                return { slope: slope, intercept: intercept, r2: r2 };
            }

            // Quadratic: y = ax^2 + bx + c  (normal equations)
            var sx3 = 0, sx4 = 0, sx2y = 0;
            for (var k = 0; k < n; k++) {
                var x2 = pts[k].x * pts[k].x;
                sx3 += x2 * pts[k].x;
                sx4 += x2 * x2;
                sx2y += x2 * pts[k].y;
            }

            // Solve 3x3 system using Cramer's
            var M = [
                [sx4, sx3, sx2],
                [sx3, sx2, sx],
                [sx2, sx, n]
            ];
            var V = [sx2y, sxy, sy];
            var det = det3(M);
            if (Math.abs(det) < 1e-10) return { a: 0, b: 0, c: sy / n, r2: 0 };

            var a = det3([V, M[1], M[2]].map(function (r, i) { return i === 0 ? [V[0], r[1], r[2]] : r; }));
            // Actually let me do this properly
            var Ma = [[V[0], M[0][1], M[0][2]], [V[1], M[1][1], M[1][2]], [V[2], M[2][1], M[2][2]]];
            var Mb = [[M[0][0], V[0], M[0][2]], [M[1][0], V[1], M[1][2]], [M[2][0], V[2], M[2][2]]];
            var Mc = [[M[0][0], M[0][1], V[0]], [M[1][0], M[1][1], V[1]], [M[2][0], M[2][1], V[2]]];

            var qa = det3(Ma) / det;
            var qb = det3(Mb) / det;
            var qc = det3(Mc) / det;

            var yMean2 = sy / n;
            var ssRes2 = 0, ssTot2 = 0;
            for (var m = 0; m < n; m++) {
                var pred2 = qa * pts[m].x * pts[m].x + qb * pts[m].x + qc;
                ssRes2 += (pts[m].y - pred2) * (pts[m].y - pred2);
                ssTot2 += (pts[m].y - yMean2) * (pts[m].y - yMean2);
            }
            var r2q = ssTot2 > 0 ? 1 - ssRes2 / ssTot2 : 1;
            return { a: qa, b: qb, c: qc, r2: r2q };
        }

        function det3(m) {
            return m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
                 - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
                 + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
        }

        function niceStep(range, targetTicks) {
            var rough = range / targetTicks;
            var mag = Math.pow(10, Math.floor(Math.log10(rough)));
            var norm = rough / mag;
            var step;
            if (norm < 1.5) step = 1;
            else if (norm < 3.5) step = 2;
            else if (norm < 7.5) step = 5;
            else step = 10;
            return step * mag;
        }

        function updateValues() {
            var pts = getPoints();
            var reg = state._reg || { slope: 0, intercept: 0, r2: 0, a: 0, b: 0, c: 0 };
            var regType = state.regType || 'linear';

            setEl('val-n', pts.length + ' points');
            if (regType === 'linear') {
                setEl('val-equation', 'y = ' + reg.slope.toFixed(3) + 'x + ' + reg.intercept.toFixed(3));
                setEl('val-slope', reg.slope.toFixed(4));
                setEl('val-intercept', reg.intercept.toFixed(4));
            } else {
                setEl('val-equation', 'y = ' + reg.a.toFixed(3) + 'x\u00B2 + ' + reg.b.toFixed(3) + 'x + ' + reg.c.toFixed(3));
                setEl('val-slope', 'N/A (quadratic)');
                setEl('val-intercept', reg.c.toFixed(4));
            }
            setEl('val-r2', (reg.r2 != null ? reg.r2.toFixed(5) : '\u2014'));
            setEl('val-r', (reg.r2 != null ? Math.sqrt(Math.abs(reg.r2)).toFixed(5) : '\u2014'));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        // Drag data points
        p.mousePressed = function () {
            var pts = getPoints();
            var gw = W - pad * 2, gh = H - pad * 2;
            var xMin = state._xMin, yMax = state._yMax;
            var xSc = state._xScale, ySc = state._yScale;
            if (!xSc) return;

            for (var i = 0; i < pts.length; i++) {
                var sx = pad + (pts[i].x - xMin) * xSc;
                var sy = pad + (yMax - pts[i].y) * ySc;
                if (Math.hypot(p.mouseX - sx, p.mouseY - sy) < 18) {
                    dragging = i;
                    p.loop();
                    return;
                }
            }
        };

        p.mouseDragged = function () {
            if (dragging < 0) return;
            var pts = getPoints();
            var gw = W - pad * 2, gh = H - pad * 2;
            var xMin = state._xMin, yMax = state._yMax;
            var xSc = state._xScale, ySc = state._yScale;
            if (!xSc) return;

            var nx = (p.mouseX - pad) / xSc + xMin;
            var ny = yMax - (p.mouseY - pad) / ySc;
            nx = Math.round(nx * 4) / 4;
            ny = Math.round(ny * 4) / 4;
            pts[dragging].x = nx;
            pts[dragging].y = ny;
        };

        p.mouseReleased = function () { dragging = -1; };

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('regression', regressionViz);
})();
