/**
 * Visual Math — Polynomial Roots Explorer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;
    var roots = [-2, 0, 3]; // default cubic
    var dragging = null;

    function polynomialViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            var c = p.createCanvas(W, H);
            c.mousePressed(onPress);
            c.mouseReleased(onRelease);
            c.touchStarted(onPress);
            c.touchEnded(onRelease);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (dragging !== null) handleDrag();

            drawGraph(C);
            updateValues();

            if (dragging === null) p.noLoop();
        };

        function drawGraph(C) {
            var gw = W - pad * 2;
            var gh = H - pad * 2;
            var ox = pad + gw / 2;
            var oy = pad + gh / 2;
            var xRange = 6;
            var sx = gw / (2 * xRange);

            function toX(v) { return ox + v * sx; }

            // Auto-scale y based on polynomial extremes
            var yMax = 1;
            for (var xi = -xRange; xi <= xRange; xi += 0.2) {
                var val = Math.abs(evalPoly(xi));
                if (val > yMax && val < 500) yMax = val;
            }
            yMax = Math.ceil(yMax * 1.2);
            var sy = gh / (2 * yMax);
            function toY(v) { return oy - v * sy; }

            // Grid
            if (state.showGrid !== false) {
                p.stroke(C.grid || [200, 200, 200, 60]);
                p.strokeWeight(0.5);
                for (var i = -xRange; i <= xRange; i++) {
                    p.line(toX(i), pad, toX(i), pad + gh);
                }
                var yStep = Math.max(1, Math.floor(yMax / 5));
                for (var j = -yMax; j <= yMax; j += yStep) {
                    p.line(pad, toY(j), pad + gw, toY(j));
                }
            }

            // Axes
            p.stroke(C.axis);
            p.strokeWeight(2);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Tick labels
            p.fill(C.muted);
            p.noStroke();
            p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            for (var k = -xRange; k <= xRange; k++) {
                if (k !== 0) p.text(k, toX(k), oy + 4);
            }

            // Draw polynomial curve
            var a = state.leading != null ? state.leading : 1;
            p.stroke(C.sin);
            p.strokeWeight(2.5);
            p.noFill();
            p.beginShape();
            for (var px = -xRange; px <= xRange; px += 0.05) {
                var py = evalPoly(px);
                var screenY = toY(py);
                // Clip to canvas
                if (screenY > pad - 20 && screenY < pad + gh + 20) {
                    p.vertex(toX(px), screenY);
                } else {
                    p.endShape();
                    p.beginShape();
                }
            }
            p.endShape();

            // Draw root points (draggable)
            for (var r = 0; r < roots.length; r++) {
                var rx = toX(roots[r]);
                var ry = toY(0);

                // Vertical dashed line from x-axis
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 60);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(rx, pad, rx, pad + gh);
                p.drawingContext.setLineDash([]);

                // Root dot
                p.fill(r === dragging ? C.accent : C.point);
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.ellipse(rx, ry, 14, 14);

                // Label
                if (state.showLabels !== false) {
                    p.fill(C.accent);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.CENTER, p.BOTTOM);
                    p.text('r' + (r + 1) + '=' + roots[r].toFixed(1), rx, ry - 10);
                }
            }

            // Y-intercept
            var yInt = evalPoly(0);
            if (Math.abs(yInt) < yMax) {
                p.fill(C.cos);
                p.stroke(C.accent);
                p.strokeWeight(2);
                p.ellipse(toX(0), toY(yInt), 8, 8);
            }

            // Factored form label
            p.fill(C.text);
            p.noStroke();
            p.textSize(14);
            p.textAlign(p.LEFT, p.TOP);
            p.text(getFactoredForm(), pad + 8, pad + 8);
        }

        function evalPoly(x) {
            var a = state.leading != null ? state.leading : 1;
            var result = a;
            for (var i = 0; i < roots.length; i++) {
                result *= (x - roots[i]);
            }
            return result;
        }

        function getFactoredForm() {
            var a = state.leading != null ? state.leading : 1;
            var s = 'f(x) = ';
            if (Math.abs(a - 1) > 0.01 && Math.abs(a + 1) > 0.01) s += a.toFixed(1);
            else if (Math.abs(a + 1) < 0.01) s += '-';

            for (var i = 0; i < roots.length; i++) {
                var r = roots[i];
                if (Math.abs(r) < 0.01) s += '(x)';
                else if (r > 0) s += '(x \u2212 ' + r.toFixed(1) + ')';
                else s += '(x + ' + Math.abs(r).toFixed(1) + ')';
            }
            return s;
        }

        function getExpandedForm() {
            // Expand polynomial coefficients from roots
            var a = state.leading != null ? state.leading : 1;
            var coeffs = [1]; // Start with 1

            for (var i = 0; i < roots.length; i++) {
                var newCoeffs = new Array(coeffs.length + 1).fill(0);
                for (var j = 0; j < coeffs.length; j++) {
                    newCoeffs[j] += coeffs[j];                    // multiply by x
                    newCoeffs[j + 1] += coeffs[j] * (-roots[i]); // multiply by -root
                }
                coeffs = newCoeffs;
            }

            // Build string
            var s = 'f(x) = ';
            var terms = [];
            for (var k = 0; k < coeffs.length; k++) {
                var c = a * coeffs[k];
                if (Math.abs(c) < 0.001) continue;
                var deg = coeffs.length - 1 - k;
                var term = '';
                if (terms.length === 0) {
                    if (Math.abs(c - 1) < 0.01 && deg > 0) term = '';
                    else if (Math.abs(c + 1) < 0.01 && deg > 0) term = '-';
                    else term = c.toFixed(1);
                } else {
                    term = (c > 0 ? ' + ' : ' \u2212 ');
                    var ac = Math.abs(c);
                    if (Math.abs(ac - 1) < 0.01 && deg > 0) { /* skip 1 */ }
                    else term += ac.toFixed(1);
                }
                if (deg === 0) {
                    if (terms.length > 0 && Math.abs(Math.abs(c) - 1) < 0.01) {
                        term += Math.abs(c).toFixed(1);
                    } else if (terms.length === 0 && Math.abs(c) < 0.01) continue;
                    else if (terms.length === 0) { /* already have coeff */ }
                }
                if (deg > 1) term += 'x\u00B2'.replace('2', deg > 2 ? '\u00B3'.charAt(0) : '');
                if (deg === 2) term += 'x\u00B2';
                else if (deg === 3) term += 'x\u00B3';
                else if (deg === 4) term += 'x\u2074';
                else if (deg === 5) term += 'x\u2075';
                else if (deg === 1) term += 'x';
                terms.push(term);
            }
            return s + terms.join('');
        }

        function onPress() {
            var gw = W - pad * 2;
            var ox = pad + gw / 2;
            var oy = pad + (H - pad * 2) / 2;
            var sx = gw / 12;
            var mx = p.mouseX;
            var my = p.mouseY;

            for (var i = 0; i < roots.length; i++) {
                var rx = ox + roots[i] * sx;
                if (Math.abs(mx - rx) < 20 && Math.abs(my - oy) < 30) {
                    dragging = i;
                    p.loop();
                    return false;
                }
            }
        }

        function onRelease() {
            dragging = null;
        }

        function handleDrag() {
            var gw = W - pad * 2;
            var ox = pad + gw / 2;
            var sx = gw / 12;
            var newRoot = (p.mouseX - ox) / sx;
            newRoot = Math.max(-5.5, Math.min(5.5, newRoot));
            // Snap to 0.1
            roots[dragging] = Math.round(newRoot * 10) / 10;
        }

        p.mouseDragged = function () {
            if (dragging !== null) return false;
        };
        p.touchMoved = function () {
            if (dragging !== null) return false;
        };

        function updateValues() {
            var a = state.leading != null ? state.leading : 1;

            setEl('val-degree', roots.length.toString());
            setEl('val-factored', getFactoredForm().replace('f(x) = ', ''));
            setEl('val-roots', roots.map(function (r) { return r.toFixed(1); }).join(', '));
            setEl('val-yint', '(0, ' + evalPoly(0).toFixed(2) + ')');
            setEl('val-leading', a.toFixed(1));

            // End behavior
            var deg = roots.length;
            var end = '';
            if (a > 0) end = deg % 2 === 0 ? '\u2191 \u2191' : '\u2193 \u2191';
            else end = deg % 2 === 0 ? '\u2193 \u2193' : '\u2191 \u2193';
            setEl('val-end', end);
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
        state._setRoots = function (newRoots) {
            roots = newRoots.slice();
            p.loop();
        };
        state._getRoots = function () { return roots.slice(); };
    }

    VisualMath.register('polynomial', polynomialViz);
})();
