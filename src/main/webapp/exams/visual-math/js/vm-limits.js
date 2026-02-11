/**
 * Visual Math — Limits & Continuity
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function limitsViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        // Function definitions — each returns { y, leftLim, rightLim, limitExists, discType }
        function getFunc(x) {
            var ft = state.funcType || 'removable';
            var c = state.approachX != null ? state.approachX : 1;

            if (ft === 'removable') {
                // f(x) = (x^2 - c^2) / (x - c), hole at x = c, limit = 2c
                if (Math.abs(x - c) < 0.001) return null; // hole
                return (x * x - c * c) / (x - c);
            }
            if (ft === 'jump') {
                // f(x) = { x + 1 for x < c, x + 3 for x >= c }
                if (Math.abs(x - c) < 0.001) return null;
                return x < c ? x + 1 : x + 3;
            }
            if (ft === 'infinite') {
                // f(x) = 1 / (x - c)
                if (Math.abs(x - c) < 0.01) return null;
                return 1 / (x - c);
            }
            if (ft === 'oscillating') {
                // f(x) = sin(1 / (x - c))
                if (Math.abs(x - c) < 0.001) return null;
                return Math.sin(1 / (x - c));
            }
            if (ft === 'continuous') {
                // f(x) = x^2 - 1, continuous everywhere
                return x * x - 1;
            }
            return x;
        }

        function getLimits() {
            var ft = state.funcType || 'removable';
            var c = state.approachX != null ? state.approachX : 1;
            if (ft === 'removable') return { left: c + c, right: c + c, exists: true, val: 2 * c };
            if (ft === 'jump') return { left: c + 1, right: c + 3, exists: false, val: null };
            if (ft === 'infinite') return { left: '-\u221E', right: '+\u221E', exists: false, val: null };
            if (ft === 'oscillating') return { left: 'DNE', right: 'DNE', exists: false, val: null };
            if (ft === 'continuous') return { left: c * c - 1, right: c * c - 1, exists: true, val: c * c - 1 };
            return { left: 0, right: 0, exists: true, val: 0 };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawLimits(C);
            updateValues();
            if (state.animating) {
                state.animT = (state.animT || 0) + 0.01;
                if (state.animT > 1) state.animT = 0;
            } else {
                p.noLoop();
            }
        };

        function drawLimits(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var ft = state.funcType || 'removable';
            var c = state.approachX != null ? state.approachX : 1;

            // Determine view window
            var xMin = c - 5, xMax = c + 5;
            var yMin = -6, yMax = 6;
            if (ft === 'continuous') { yMin = -3; yMax = c * c + 4; }
            if (ft === 'removable') { yMin = c * 2 - 5; yMax = c * 2 + 5; }
            if (ft === 'jump') { yMin = c - 4; yMax = c + 8; }

            var xScale = gw / (xMax - xMin);
            var yScale = gh / (yMax - yMin);

            function toSx(x) { return pad + (x - xMin) * xScale; }
            function toSy(y) { return pad + (yMax - y) * yScale; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var gx = Math.ceil(xMin); gx <= Math.floor(xMax); gx++) {
                p.line(toSx(gx), pad, toSx(gx), pad + gh);
            }
            for (var gy = Math.ceil(yMin); gy <= Math.floor(yMax); gy++) {
                p.line(pad, toSy(gy), pad + gw, toSy(gy));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            var zeroX = toSx(0), zeroY = toSy(0);
            if (zeroX >= pad && zeroX <= pad + gw) p.line(zeroX, pad, zeroX, pad + gh);
            if (zeroY >= pad && zeroY <= pad + gh) p.line(pad, zeroY, pad + gw, zeroY);

            // Tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            for (var tx = Math.ceil(xMin); tx <= Math.floor(xMax); tx++) {
                if (tx === 0) continue;
                p.textAlign(p.CENTER, p.TOP);
                if (zeroY >= pad && zeroY <= pad + gh) p.text(tx, toSx(tx), zeroY + 3);
            }

            // Epsilon-delta bands
            if (state.showEpsDelta) {
                var eps = state.epsilon != null ? state.epsilon : 0.5;
                var lims = getLimits();
                if (lims.exists && typeof lims.val === 'number') {
                    var L = lims.val;
                    // Epsilon band (horizontal)
                    p.fill(C.cos[0], C.cos[1], C.cos[2], 25); p.noStroke();
                    var epsTop = toSy(L + eps), epsBot = toSy(L - eps);
                    p.rect(pad, epsTop, gw, epsBot - epsTop);
                    p.stroke(C.cos[0], C.cos[1], C.cos[2], 100); p.strokeWeight(1);
                    p.drawingContext.setLineDash([4, 3]);
                    p.line(pad, epsTop, pad + gw, epsTop);
                    p.line(pad, epsBot, pad + gw, epsBot);
                    p.drawingContext.setLineDash([]);

                    // L label
                    p.fill(C.cos); p.noStroke(); p.textSize(10);
                    p.textAlign(p.LEFT, p.BOTTOM);
                    p.text('L=' + L.toFixed(2), pad + 4, toSy(L) - 2);

                    // Epsilon labels
                    p.textSize(9); p.textAlign(p.RIGHT, p.CENTER);
                    p.text('L+\u03B5', pad - 3, epsTop);
                    p.text('L\u2212\u03B5', pad - 3, epsBot);

                    // Delta band (vertical)
                    var delta = eps / 2; // simplified
                    if (ft === 'removable') delta = eps / 2;
                    if (ft === 'continuous') delta = Math.sqrt(eps);
                    p.fill(C.sin[0], C.sin[1], C.sin[2], 20); p.noStroke();
                    var delLeft = toSx(c - delta), delRight = toSx(c + delta);
                    p.rect(delLeft, pad, delRight - delLeft, gh);
                    p.stroke(C.sin[0], C.sin[1], C.sin[2], 80); p.strokeWeight(1);
                    p.drawingContext.setLineDash([4, 3]);
                    p.line(delLeft, pad, delLeft, pad + gh);
                    p.line(delRight, pad, delRight, pad + gh);
                    p.drawingContext.setLineDash([]);

                    p.fill(C.sin); p.noStroke(); p.textSize(9);
                    p.textAlign(p.CENTER, p.BOTTOM);
                    p.text('c\u2212\u03B4', delLeft, pad + gh + 12);
                    p.text('c+\u03B4', delRight, pad + gh + 12);
                }
            }

            // Draw function curve
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            // Left of c
            p.beginShape();
            for (var x1 = xMin; x1 < c - 0.02; x1 += 0.02) {
                var y1 = getFunc(x1);
                if (y1 !== null && isFinite(y1) && y1 > yMin - 1 && y1 < yMax + 1) {
                    p.vertex(toSx(x1), toSy(y1));
                } else {
                    p.endShape();
                    p.beginShape();
                }
            }
            p.endShape();

            // Right of c
            p.beginShape();
            for (var x2 = c + 0.02; x2 <= xMax; x2 += 0.02) {
                var y2 = getFunc(x2);
                if (y2 !== null && isFinite(y2) && y2 > yMin - 1 && y2 < yMax + 1) {
                    p.vertex(toSx(x2), toSy(y2));
                } else {
                    p.endShape();
                    p.beginShape();
                }
            }
            p.endShape();

            // Draw discontinuity marker
            var csx = toSx(c);
            if (ft === 'removable') {
                var holeY = 2 * c; // limit value
                p.noFill(); p.stroke(C.sin); p.strokeWeight(2);
                p.ellipse(csx, toSy(holeY), 10, 10); // open circle
            } else if (ft === 'jump') {
                var leftY = c + 1, rightY = c + 3;
                p.noFill(); p.stroke(C.sin); p.strokeWeight(2);
                p.ellipse(csx, toSy(leftY), 10, 10); // open circle (left)
                p.fill(C.sin); p.stroke(C.sin); p.strokeWeight(2);
                p.ellipse(csx, toSy(rightY), 10, 10); // filled (right)
            } else if (ft === 'infinite') {
                // Vertical asymptote
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 100); p.strokeWeight(1.5);
                p.drawingContext.setLineDash([5, 4]);
                p.line(csx, pad, csx, pad + gh);
                p.drawingContext.setLineDash([]);
            }

            // Animated approach arrows
            if (state.animating) {
                var t = state.animT || 0;
                var dist = 4 * (1 - t) + 0.05;
                // Left approach
                var lx = c - dist;
                var ly = getFunc(lx);
                if (ly !== null && isFinite(ly) && ly > yMin && ly < yMax) {
                    p.fill(C.accent); p.noStroke();
                    p.ellipse(toSx(lx), toSy(ly), 8, 8);
                }
                // Right approach
                var rx = c + dist;
                var ry = getFunc(rx);
                if (ry !== null && isFinite(ry) && ry > yMin && ry < yMax) {
                    p.fill(C.accent); p.noStroke();
                    p.ellipse(toSx(rx), toSy(ry), 8, 8);
                }
            }

            // Approach point label
            p.stroke(C.accent[0], C.accent[1], C.accent[2], 60); p.strokeWeight(1);
            p.drawingContext.setLineDash([3, 3]);
            p.line(csx, pad, csx, pad + gh);
            p.drawingContext.setLineDash([]);
            p.fill(C.accent); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text('x\u2192' + c, csx, pad + gh + 3);
        }

        function updateValues() {
            var ft = state.funcType || 'removable';
            var c = state.approachX != null ? state.approachX : 1;
            var names = { removable: 'Removable (hole)', jump: 'Jump', infinite: 'Infinite', oscillating: 'Oscillating', continuous: 'Continuous' };
            setEl('val-type', names[ft] || ft);

            var funcStrs = {
                removable: '(x\u00B2\u2212' + (c * c).toFixed(0) + ')/(x\u2212' + c + ')',
                jump: '{x+1, x<' + c + '; x+3, x\u2265' + c + '}',
                infinite: '1/(x\u2212' + c + ')',
                oscillating: 'sin(1/(x\u2212' + c + '))',
                continuous: 'x\u00B2 \u2212 1'
            };
            setEl('val-func', funcStrs[ft] || '');

            var lims = getLimits();
            setEl('val-left-lim', typeof lims.left === 'number' ? lims.left.toFixed(2) : String(lims.left));
            setEl('val-right-lim', typeof lims.right === 'number' ? lims.right.toFixed(2) : String(lims.right));
            setEl('val-limit', lims.exists ? (typeof lims.val === 'number' ? lims.val.toFixed(2) : String(lims.val)) : 'Does not exist');
            setEl('val-continuous', ft === 'continuous' ? 'Yes' : 'No');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('limits', limitsViz);
})();
