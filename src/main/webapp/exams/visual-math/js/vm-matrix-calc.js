/**
 * Visual Math — Matrix Calculator (2×2, 3×3, 4×4)
 * Determinant, Inverse, Trace, Eigenvalues
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function matrixCalcViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getSize() { return state.size || 2; }

        function getMatrix() {
            var n = getSize();
            var m = [];
            for (var r = 0; r < n; r++) {
                for (var c = 0; c < n; c++) {
                    var key = 'm' + r + '' + c;
                    m.push(state[key] != null ? state[key] : (r === c ? 1 : 0));
                }
            }
            return m;
        }

        // ---- General matrix math ----
        function minor(m, n, row, col) {
            var sub = [];
            for (var r = 0; r < n; r++) {
                if (r === row) continue;
                for (var c = 0; c < n; c++) {
                    if (c === col) continue;
                    sub.push(m[r * n + c]);
                }
            }
            return sub;
        }

        function det(m, n) {
            if (n === 1) return m[0];
            if (n === 2) return m[0] * m[3] - m[1] * m[2];
            var d = 0;
            for (var c = 0; c < n; c++) {
                d += ((c % 2 === 0) ? 1 : -1) * m[c] * det(minor(m, n, 0, c), n - 1);
            }
            return d;
        }

        function tr(m, n) {
            var t = 0;
            for (var i = 0; i < n; i++) t += m[i * n + i];
            return t;
        }

        function adjugate(m, n) {
            var adj = new Array(n * n);
            for (var r = 0; r < n; r++) {
                for (var c = 0; c < n; c++) {
                    adj[c * n + r] = ((r + c) % 2 === 0 ? 1 : -1) * det(minor(m, n, r, c), n - 1);
                }
            }
            return adj;
        }

        function inverse(m, n) {
            var d = det(m, n);
            if (Math.abs(d) < 1e-10) return null;
            var adj = adjugate(m, n);
            return adj.map(function (v) { return v / d; });
        }

        function matMul(a, b, n) {
            var c = new Array(n * n).fill(0);
            for (var i = 0; i < n; i++)
                for (var j = 0; j < n; j++)
                    for (var k = 0; k < n; k++)
                        c[i * n + j] += a[i * n + k] * b[k * n + j];
            return c;
        }

        // ---- Eigenvalues ----
        function eigenvalues2x2(m) {
            var a = m[0], b = m[1], c = m[2], d = m[3];
            var trace = a + d, dt = a * d - b * c;
            var disc = trace * trace - 4 * dt;
            if (disc < -0.001) {
                return { real: false, values: [trace / 2, Math.sqrt(-disc) / 2], vectors: [] };
            }
            var sq = Math.sqrt(Math.max(0, disc));
            var l1 = (trace + sq) / 2, l2 = (trace - sq) / 2;
            var v1, v2;
            if (Math.abs(b) > 0.001) { v1 = [b, l1 - a]; v2 = [b, l2 - a]; }
            else if (Math.abs(c) > 0.001) { v1 = [l1 - d, c]; v2 = [l2 - d, c]; }
            else { v1 = [1, 0]; v2 = [0, 1]; }
            function norm(v) {
                var len = Math.sqrt(v[0] * v[0] + v[1] * v[1]);
                return len > 0.001 ? [v[0] / len, v[1] / len] : v;
            }
            return { real: true, values: [l1, l2], vectors: [norm(v1), norm(v2)] };
        }

        // 3×3: solve characteristic cubic
        function eigenvalues3x3(m) {
            var t = tr(m, 3);
            // Sum of 2×2 principal minors
            var p2 = (m[0] * m[4] - m[1] * m[3]) + (m[0] * m[8] - m[2] * m[6]) + (m[4] * m[8] - m[5] * m[7]);
            var d = det(m, 3);
            // Characteristic: λ³ - t·λ² + p2·λ - d = 0   →   x³ + ax² + bx + c = 0
            return solveCubic(-t, p2, -d);
        }

        function solveCubic(a, b, c) {
            // x³ + ax² + bx + c = 0
            var pp = b - a * a / 3;
            var qq = 2 * a * a * a / 27 - a * b / 3 + c;
            var disc = qq * qq / 4 + pp * pp * pp / 27;
            var roots = [];

            if (disc > 0.001) {
                var u = cbrt(-qq / 2 + Math.sqrt(disc));
                var v = cbrt(-qq / 2 - Math.sqrt(disc));
                roots.push(u + v - a / 3);
                var rp = -(u + v) / 2 - a / 3;
                var ip = Math.sqrt(3) * (u - v) / 2;
                return { real: false, values: [roots[0]], complexReal: rp, complexImag: Math.abs(ip) };
            } else if (Math.abs(disc) <= 0.001) {
                var u2 = cbrt(-qq / 2);
                roots = [2 * u2 - a / 3, -u2 - a / 3, -u2 - a / 3];
                roots.sort(function (x, y) { return y - x; });
                return { real: true, values: roots };
            } else {
                var r = Math.sqrt(-pp * pp * pp / 27);
                var theta = Math.acos(Math.max(-1, Math.min(1, -qq / (2 * r))));
                var m2 = 2 * cbrt(r);
                roots = [
                    m2 * Math.cos(theta / 3) - a / 3,
                    m2 * Math.cos((theta + 2 * Math.PI) / 3) - a / 3,
                    m2 * Math.cos((theta + 4 * Math.PI) / 3) - a / 3
                ];
                roots.sort(function (x, y) { return y - x; });
                return { real: true, values: roots };
            }
        }

        function cbrt(x) { return x >= 0 ? Math.pow(x, 1 / 3) : -Math.pow(-x, 1 / 3); }

        // 4×4: Faddeev-LeVerrier for characteristic polynomial, Durand-Kerner for roots
        function eigenvalues4x4(m) {
            var n = 4;
            var t1 = tr(m, n);
            var m2 = matMul(m, m, n), t2 = tr(m2, n);
            var m3 = matMul(m2, m, n), t3 = tr(m3, n);
            var m4 = matMul(m3, m, n), t4 = tr(m4, n);
            var c1 = t1;
            var c2 = (c1 * t1 - t2) / 2;
            var c3 = (c2 * t1 - c1 * t2 + t3) / 3;
            var c4 = (c3 * t1 - c2 * t2 + c1 * t3 - t4) / 4;
            // λ⁴ - c1·λ³ + c2·λ² - c3·λ + c4 = 0
            return durandKerner([1, -c1, c2, -c3, c4]);
        }

        function durandKerner(coeffs) {
            // Numerical root finding for polynomial
            var n = coeffs.length - 1; // degree
            var roots = [];
            for (var i = 0; i < n; i++) {
                var angle = (2 * Math.PI * i / n) + 0.4;
                roots.push({ re: 0.8 * Math.cos(angle), im: 0.8 * Math.sin(angle) });
            }

            for (var iter = 0; iter < 200; iter++) {
                for (var i2 = 0; i2 < n; i2++) {
                    var num = evalPoly(coeffs, roots[i2]);
                    var den = { re: 1, im: 0 };
                    for (var j = 0; j < n; j++) {
                        if (j !== i2) den = cmul(den, csub(roots[i2], roots[j]));
                    }
                    var corr = cdiv(num, den);
                    roots[i2].re -= corr.re;
                    roots[i2].im -= corr.im;
                }
            }

            var realRoots = [];
            var hasComplex = false;
            for (var k = 0; k < n; k++) {
                if (Math.abs(roots[k].im) < 0.01) {
                    realRoots.push(roots[k].re);
                } else {
                    hasComplex = true;
                }
            }

            if (!hasComplex) {
                realRoots.sort(function (a, b) { return b - a; });
                return { real: true, values: realRoots };
            }

            // Mix: return all as approximate values
            var allVals = roots.map(function (r) { return r.re; });
            allVals.sort(function (a, b) { return b - a; });
            return { real: false, values: allVals, complexRoots: roots };
        }

        function evalPoly(c, z) {
            var result = { re: 0, im: 0 };
            var zn = { re: 1, im: 0 };
            for (var i = c.length - 1; i >= 0; i--) {
                result.re += c[i] * zn.re;
                result.im += c[i] * zn.im;
                if (i > 0) zn = cmul(zn, z);
            }
            return result;
        }

        function cmul(a, b) { return { re: a.re * b.re - a.im * b.im, im: a.re * b.im + a.im * b.re }; }
        function csub(a, b) { return { re: a.re - b.re, im: a.im - b.im }; }
        function cdiv(a, b) {
            var d = b.re * b.re + b.im * b.im;
            if (d < 1e-30) return { re: 0, im: 0 };
            return { re: (a.re * b.re + a.im * b.im) / d, im: (a.im * b.re - a.re * b.im) / d };
        }

        function eigenvaluesGeneral(m, n) {
            if (n === 2) return eigenvalues2x2(m);
            if (n === 3) return eigenvalues3x3(m);
            return eigenvalues4x4(m);
        }

        // ---- Formatting ----
        function fmtN(v) {
            if (Math.abs(v) < 0.0005) return '0';
            if (Math.abs(v - Math.round(v)) < 0.001) return Math.round(v).toString();
            return v.toFixed(3);
        }

        function fmtShort(v) {
            if (Math.abs(v) < 0.0005) return '0';
            if (Math.abs(v - Math.round(v)) < 0.001) return Math.round(v).toString();
            return v.toFixed(2);
        }

        // ---- Drawing ----
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var n = getSize();
            if (n === 2) draw2x2(C);
            else drawNxN(C, n);
            updateValues(n);
            p.noLoop();
        };

        // ---- 2×2: geometric view ----
        function draw2x2(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var cx = pad + gw / 2, cy = pad + gh / 2;
            var sc = Math.min(gw, gh) / 10;
            var m = getMatrix();

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var i = -5; i <= 5; i++) {
                p.line(cx + i * sc, pad, cx + i * sc, pad + gh);
                p.line(pad, cy + i * sc, pad + gw, cy + i * sc);
            }
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, cy, pad + gw, cy);
            p.line(cx, pad, cx, pad + gh);

            p.fill(C.muted); p.noStroke(); p.textSize(9);
            for (var t = -4; t <= 4; t++) {
                if (t === 0) continue;
                p.textAlign(p.CENTER, p.TOP); p.text(t, cx + t * sc, cy + 3);
                p.textAlign(p.RIGHT, p.CENTER); p.text(t, cx - 4, cy - t * sc);
            }

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
            pts.forEach(function (pt) {
                p.vertex(cx + (m[0] * pt[0] + m[1] * pt[1]) * sc,
                         cy - (m[2] * pt[0] + m[3] * pt[1]) * sc);
            });
            p.endShape(p.CLOSE);

            drawArrow(cx, cy, cx + m[0] * sc, cy - m[2] * sc, C.sin, 2.5);
            drawArrow(cx, cy, cx + m[1] * sc, cy - m[3] * sc, C.cos, 2.5);

            p.noStroke(); p.textSize(12);
            p.fill(C.sin); p.textAlign(p.LEFT, p.CENTER);
            p.text('e\u2081\u2032', cx + m[0] * sc + 6, cy - m[2] * sc);
            p.fill(C.cos);
            p.text('e\u2082\u2032', cx + m[1] * sc + 6, cy - m[3] * sc);

            // Eigenvectors
            var eig = eigenvalues2x2(m);
            if (eig.real && eig.vectors.length >= 2) {
                for (var e = 0; e < eig.vectors.length; e++) {
                    var ev = eig.vectors[e];
                    var evLen = Math.sqrt(ev[0] * ev[0] + ev[1] * ev[1]);
                    if (evLen < 0.001) continue;
                    var evx = ev[0] / evLen * 5, evy = ev[1] / evLen * 5;
                    p.stroke(C.accent[0], C.accent[1], C.accent[2], 120); p.strokeWeight(1.5);
                    p.drawingContext.setLineDash([5, 4]);
                    p.line(cx - evx * sc, cy + evy * sc, cx + evx * sc, cy - evy * sc);
                    p.drawingContext.setLineDash([]);
                    drawArrow(cx, cy, cx + ev[0] * sc * 1.5, cy - ev[1] * sc * 1.5, C.accent, 2);
                    p.fill(C.accent); p.noStroke(); p.textSize(10);
                    p.textAlign(p.LEFT, p.BOTTOM);
                    p.text('\u03BB' + (e + 1) + '=' + eig.values[e].toFixed(2),
                        cx + ev[0] * sc * 1.5 + 6, cy - ev[1] * sc * 1.5 - 4);
                }
            }

            var d = det(m, 2);
            p.fill(C.text); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.TOP);
            p.text('det = ' + d.toFixed(2) + ' (area scale)', pad + 6, pad + 4);
        }

        function drawArrow(x1, y1, x2, y2, col, sw) {
            p.stroke(col); p.strokeWeight(sw);
            p.line(x1, y1, x2, y2);
            var angle = Math.atan2(y2 - y1, x2 - x1);
            p.fill(col); p.noStroke();
            p.push(); p.translate(x2, y2); p.rotate(angle);
            p.triangle(0, 0, -8, -3.2, -8, 3.2);
            p.pop();
        }

        // ---- 3×3 / 4×4: matrix display view ----
        function drawNxN(C, n) {
            var m = getMatrix();
            var gw = W - pad * 2, gh = H - pad * 2;

            // Left half: matrix A with brackets
            var matW = gw * 0.48;
            var cellSize = Math.min(matW / (n + 0.5), (gh * 0.45) / n);
            var matTotalW = n * cellSize;
            var matTotalH = n * cellSize;
            var matStartX = pad + (matW - matTotalW) / 2;
            var matStartY = pad + 24;

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(13);
            p.textAlign(p.CENTER, p.TOP);
            p.text('Matrix A  (' + n + '\u00D7' + n + ')', pad + matW / 2, pad + 4);

            // Brackets
            drawBrackets(matStartX - 10, matStartY - 6, matStartX + matTotalW + 4, matStartY + matTotalH + 2, C.text, 2.5);

            // Matrix entries
            var fontSize = Math.min(14, cellSize * 0.42);
            p.textAlign(p.CENTER, p.CENTER);
            for (var r = 0; r < n; r++) {
                for (var c = 0; c < n; c++) {
                    var val = m[r * n + c];
                    var ex = matStartX + c * cellSize + cellSize / 2;
                    var ey = matStartY + r * cellSize + cellSize / 2;
                    if (r === c) {
                        p.fill(C.accent[0], C.accent[1], C.accent[2], 20); p.noStroke();
                        p.rect(ex - cellSize / 2 + 1, ey - cellSize / 2 + 1, cellSize - 2, cellSize - 2, 3);
                    }
                    p.fill(r === c ? C.accent : C.text); p.noStroke(); p.textSize(fontSize);
                    p.text(fmtShort(val), ex, ey);
                }
            }

            // Right half: computed properties
            var propX = pad + matW + 16;
            var propY = pad + 28;
            var lineH = 20;

            p.textAlign(p.LEFT, p.TOP);

            var d = det(m, n);
            p.fill(C.accent); p.textSize(11); p.text('Determinant', propX, propY);
            propY += lineH * 0.8;
            p.fill(C.text); p.textSize(15); p.text(fmtN(d), propX + 4, propY);
            propY += lineH * 1.4;

            var t = tr(m, n);
            p.fill(C.accent); p.textSize(11); p.text('Trace', propX, propY);
            propY += lineH * 0.8;
            p.fill(C.text); p.textSize(15); p.text(fmtN(t), propX + 4, propY);
            propY += lineH * 1.4;

            // Eigenvalues
            p.fill(C.accent); p.textSize(11); p.text('Eigenvalues', propX, propY);
            propY += lineH * 0.8;
            var eig = eigenvaluesGeneral(m, n);
            p.fill(C.sin); p.textSize(12);
            if (eig.real) {
                for (var e = 0; e < eig.values.length; e++) {
                    p.text('\u03BB' + subscript(e + 1) + ' = ' + fmtN(eig.values[e]), propX + 4, propY);
                    propY += lineH * 0.85;
                }
            } else {
                // 3×3 with one real + complex pair
                if (n === 3 && eig.values.length === 1) {
                    p.text('\u03BB\u2081 = ' + fmtN(eig.values[0]), propX + 4, propY);
                    propY += lineH * 0.85;
                    p.text('\u03BB\u2082,\u2083 = ' + fmtN(eig.complexReal) + ' \u00B1 ' + fmtN(eig.complexImag) + 'i', propX + 4, propY);
                    propY += lineH * 0.85;
                } else {
                    for (var f = 0; f < eig.values.length; f++) {
                        p.text('\u03BB' + subscript(f + 1) + ' \u2248 ' + fmtN(eig.values[f]), propX + 4, propY);
                        propY += lineH * 0.85;
                    }
                }
            }
            propY += lineH * 0.5;

            // Invertible badge
            p.fill(Math.abs(d) > 0.001 ? [34, 197, 94] : [239, 68, 68]); p.textSize(11);
            p.text(Math.abs(d) > 0.001 ? '\u2713 Invertible' : '\u2717 Singular', propX, propY);

            // Bottom: inverse matrix (if exists and fits)
            if (Math.abs(d) > 0.001) {
                var inv = inverse(m, n);
                if (inv) {
                    var invY = matStartY + matTotalH + 28;
                    var spaceLeft = H - invY - 10;
                    var invCellSize = Math.min(cellSize * 0.72, spaceLeft / n);
                    if (invCellSize > 12) {
                        var invTotalW = n * invCellSize;
                        var invStartX = pad + (matW - invTotalW) / 2;

                        p.fill(C.muted); p.textSize(11); p.textAlign(p.CENTER, p.TOP);
                        p.text('A\u207B\u00B9', pad + matW / 2, invY - 16);

                        drawBrackets(invStartX - 8, invY - 4, invStartX + invTotalW + 3, invY + n * invCellSize, C.muted, 1.8);

                        var invFontSize = Math.min(11, invCellSize * 0.38);
                        p.textAlign(p.CENTER, p.CENTER);
                        for (var ir = 0; ir < n; ir++) {
                            for (var ic = 0; ic < n; ic++) {
                                var ivx = invStartX + ic * invCellSize + invCellSize / 2;
                                var ivy = invY + ir * invCellSize + invCellSize / 2;
                                p.fill(C.cos); p.textSize(invFontSize);
                                p.text(fmtShort(inv[ir * n + ic]), ivx, ivy);
                            }
                        }
                    }
                }
            }
        }

        function drawBrackets(x1, y1, x2, y2, col, sw) {
            p.stroke(col); p.strokeWeight(sw); p.noFill();
            var w = 7;
            p.line(x1 + w, y1, x1, y1); p.line(x1, y1, x1, y2); p.line(x1, y2, x1 + w, y2);
            p.line(x2 - w, y1, x2, y1); p.line(x2, y1, x2, y2); p.line(x2, y2, x2 - w, y2);
        }

        function subscript(n) {
            var subs = ['\u2080', '\u2081', '\u2082', '\u2083', '\u2084'];
            return n < subs.length ? subs[n] : n.toString();
        }

        // ---- Update value panel ----
        function updateValues(n) {
            var m = getMatrix();
            var d = det(m, n);
            var t = tr(m, n);

            // Matrix display
            var rows = [];
            for (var r = 0; r < n; r++) {
                var row = [];
                for (var c = 0; c < n; c++) row.push(fmtShort(m[r * n + c]));
                rows.push('[' + row.join(', ') + ']');
            }
            setEl('val-matrix', '[' + rows.join(', ') + ']');
            setEl('val-det', fmtN(d));
            setEl('val-trace', fmtN(t));

            // Rank (simple: count non-zero rows after Gaussian elimination)
            setEl('val-rank', computeRank(m, n).toString());

            // Inverse
            if (Math.abs(d) > 0.001) {
                var inv = inverse(m, n);
                if (inv) {
                    var irows = [];
                    for (var ir = 0; ir < n; ir++) {
                        var irow = [];
                        for (var ic = 0; ic < n; ic++) irow.push(fmtShort(inv[ir * n + ic]));
                        irows.push('[' + irow.join(', ') + ']');
                    }
                    setEl('val-inverse', '[' + irows.join(', ') + ']');
                }
            } else {
                setEl('val-inverse', 'Singular (no inverse)');
            }

            // Eigenvalues
            var eig = eigenvaluesGeneral(m, n);
            if (eig.real) {
                var eigStr = eig.values.map(function (v, i) {
                    return '\u03BB' + subscript(i + 1) + '=' + fmtN(v);
                }).join(', ');
                setEl('val-eigenvalues', eigStr);
            } else {
                if (n === 3 && eig.values.length === 1) {
                    setEl('val-eigenvalues', fmtN(eig.values[0]) + ', ' + fmtN(eig.complexReal) + ' \u00B1 ' + fmtN(eig.complexImag) + 'i');
                } else if (n === 2) {
                    setEl('val-eigenvalues', fmtN(eig.values[0]) + ' \u00B1 ' + fmtN(eig.values[1]) + 'i');
                } else {
                    setEl('val-eigenvalues', eig.values.map(function (v) { return '\u2248' + fmtN(v); }).join(', '));
                }
            }

            // Eigenvectors (only for 2×2 with real eigenvalues)
            if (n === 2 && eig.real && eig.vectors && eig.vectors.length >= 2) {
                setEl('val-eigenvectors',
                    'v\u2081=(' + fmtShort(eig.vectors[0][0]) + ',' + fmtShort(eig.vectors[0][1]) + '), ' +
                    'v\u2082=(' + fmtShort(eig.vectors[1][0]) + ',' + fmtShort(eig.vectors[1][1]) + ')');
            } else if (n === 2 && !eig.real) {
                setEl('val-eigenvectors', 'Complex (rotation)');
            } else {
                setEl('val-eigenvectors', '\u2014');
            }
        }

        function computeRank(m, n) {
            // Gaussian elimination to count pivots
            var a = m.slice(); // copy
            var rank = 0;
            for (var col = 0; col < n; col++) {
                // Find pivot
                var pivotRow = -1;
                for (var row = rank; row < n; row++) {
                    if (Math.abs(a[row * n + col]) > 1e-8) { pivotRow = row; break; }
                }
                if (pivotRow < 0) continue;
                // Swap rows
                if (pivotRow !== rank) {
                    for (var c2 = 0; c2 < n; c2++) {
                        var tmp = a[rank * n + c2];
                        a[rank * n + c2] = a[pivotRow * n + c2];
                        a[pivotRow * n + c2] = tmp;
                    }
                }
                // Eliminate below
                for (var row2 = rank + 1; row2 < n; row2++) {
                    var factor = a[row2 * n + col] / a[rank * n + col];
                    for (var c3 = col; c3 < n; c3++) {
                        a[row2 * n + c3] -= factor * a[rank * n + c3];
                    }
                }
                rank++;
            }
            return rank;
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('matrix-calc', matrixCalcViz);
})();
