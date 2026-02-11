/**
 * Visual Math — Polar Coordinates
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function polarViz(p, container) {
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
            drawPolar(C);
            updateValues();
            if (state.animating) {
                state.traceAngle = (state.traceAngle || 0) + 0.03;
                if (state.traceAngle > Math.PI * 4) state.traceAngle = 0;
            } else {
                p.noLoop();
            }
        };

        function drawPolar(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad + gw / 2, oy = pad + gh / 2;
            var maxR = Math.min(gw, gh) / 2 - 10;

            var curveType = state.curveType || 'rose';
            var paramA = state.paramA != null ? state.paramA : 3;
            var paramN = state.paramN != null ? state.paramN : 3;

            function rFunc(theta) {
                if (curveType === 'rose') return paramA * Math.cos(paramN * theta);
                if (curveType === 'cardioid') return paramA * (1 + Math.cos(theta));
                if (curveType === 'spiral') return 0.3 * theta;
                if (curveType === 'lemniscate') {
                    var val = paramA * paramA * Math.cos(2 * theta);
                    return val >= 0 ? Math.sqrt(val) : null;
                }
                if (curveType === 'limacon') return paramA + paramN * Math.cos(theta);
                if (curveType === 'circle') return paramA;
                return paramA * Math.cos(paramN * theta);
            }

            // Find max r for scaling
            var rMax = 0;
            for (var t = 0; t <= Math.PI * 4; t += 0.05) {
                var rv = rFunc(t);
                if (rv !== null && !isNaN(rv)) rMax = Math.max(rMax, Math.abs(rv));
            }
            if (rMax < 0.1) rMax = 1;
            var rScale = maxR / rMax;

            // Polar grid: concentric circles
            var rings = 4;
            for (var ring = 1; ring <= rings; ring++) {
                var ringR = (ring / rings) * maxR;
                p.noFill(); p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
                p.ellipse(ox, oy, ringR * 2, ringR * 2);

                p.fill(C.muted); p.noStroke(); p.textSize(8);
                p.textAlign(p.LEFT, p.CENTER);
                p.text((ring * rMax / rings).toFixed(1), ox + ringR + 3, oy);
            }

            // Radial lines
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var a = 0; a < 12; a++) {
                var angle = a * Math.PI / 6;
                p.line(ox, oy, ox + Math.cos(angle) * maxR, oy - Math.sin(angle) * maxR);
            }

            // Axes (bolder)
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, oy, pad + gw, oy);
            p.line(ox, pad, ox, pad + gh);

            // Draw curve
            var maxTheta = (curveType === 'spiral') ? Math.PI * 4 : Math.PI * 2;
            var traceEnd = state.animating ? (state.traceAngle || 0) : maxTheta;

            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();

            if (curveType === 'lemniscate') {
                for (var branch = 0; branch < 2; branch++) {
                    p.beginShape();
                    var start = branch * Math.PI;
                    var end = Math.min(start + Math.PI, traceEnd);
                    for (var t1 = start; t1 <= end; t1 += 0.02) {
                        var r1 = rFunc(t1);
                        if (r1 !== null && !isNaN(r1))
                            p.vertex(ox + r1 * Math.cos(t1) * rScale, oy - r1 * Math.sin(t1) * rScale);
                    }
                    p.endShape();
                }
            } else {
                p.beginShape();
                for (var t2 = 0; t2 <= Math.min(maxTheta, traceEnd); t2 += 0.02) {
                    var r2 = rFunc(t2);
                    if (r2 !== null && !isNaN(r2))
                        p.vertex(ox + r2 * Math.cos(t2) * rScale, oy - r2 * Math.sin(t2) * rScale);
                }
                p.endShape();
            }

            // Current point during animation
            if (state.animating && traceEnd < maxTheta) {
                var currR = rFunc(traceEnd);
                if (currR !== null && !isNaN(currR)) {
                    var cpx = ox + currR * Math.cos(traceEnd) * rScale;
                    var cpy = oy - currR * Math.sin(traceEnd) * rScale;

                    p.stroke(C.accent[0], C.accent[1], C.accent[2], 100); p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(ox, oy, cpx, cpy);
                    p.drawingContext.setLineDash([]);

                    p.fill(C.accent); p.noStroke();
                    p.ellipse(cpx, cpy, 10, 10);

                    p.noFill(); p.stroke(C.accent[0], C.accent[1], C.accent[2], 80); p.strokeWeight(1.5);
                    p.arc(ox, oy, 30, 30, -traceEnd, 0);
                }
            }

            // Equation label
            p.fill(C.sin); p.noStroke(); p.textSize(12);
            p.textAlign(p.LEFT, p.TOP);
            var formula = '';
            if (curveType === 'rose') formula = 'r = ' + paramA.toFixed(1) + 'cos(' + paramN + '\u03B8)';
            else if (curveType === 'cardioid') formula = 'r = ' + paramA.toFixed(1) + '(1 + cos\u03B8)';
            else if (curveType === 'spiral') formula = 'r = 0.3\u03B8';
            else if (curveType === 'lemniscate') formula = 'r\u00B2 = ' + (paramA * paramA).toFixed(1) + 'cos(2\u03B8)';
            else if (curveType === 'limacon') formula = 'r = ' + paramA.toFixed(1) + ' + ' + paramN.toFixed(1) + 'cos\u03B8';
            else if (curveType === 'circle') formula = 'r = ' + paramA.toFixed(1);
            p.text(formula, pad + 6, pad + 6);
        }

        function updateValues() {
            var curveType = state.curveType || 'rose';
            var paramA = state.paramA != null ? state.paramA : 3;
            var paramN = state.paramN != null ? state.paramN : 3;

            var names = { rose: 'Rose Curve', cardioid: 'Cardioid', spiral: 'Archimedean Spiral', lemniscate: 'Lemniscate', limacon: 'Lima\u00E7on', circle: 'Circle' };
            setEl('val-curve', names[curveType] || curveType);

            if (curveType === 'rose') {
                setEl('val-polar-eq', 'r = ' + paramA.toFixed(1) + 'cos(' + paramN + '\u03B8)');
                setEl('val-petals', ((paramN % 2 === 0) ? 2 * paramN : paramN) + ' petals');
                setEl('val-symmetry', paramN % 2 === 0 ? 'Both axes' : 'x-axis');
            } else if (curveType === 'cardioid') {
                setEl('val-polar-eq', 'r = ' + paramA.toFixed(1) + '(1+cos\u03B8)');
                setEl('val-petals', 'Heart-shaped');
                setEl('val-symmetry', 'x-axis');
            } else if (curveType === 'spiral') {
                setEl('val-polar-eq', 'r = 0.3\u03B8');
                setEl('val-petals', 'Infinite spiral');
                setEl('val-symmetry', 'None');
            } else if (curveType === 'lemniscate') {
                setEl('val-polar-eq', 'r\u00B2 = ' + (paramA * paramA).toFixed(1) + 'cos(2\u03B8)');
                setEl('val-petals', '2 loops');
                setEl('val-symmetry', 'Both axes + origin');
            } else if (curveType === 'limacon') {
                setEl('val-polar-eq', 'r = ' + paramA.toFixed(1) + '+' + paramN.toFixed(1) + 'cos\u03B8');
                setEl('val-petals', paramA > paramN ? 'Dimpled' : (Math.abs(paramA - paramN) < 0.01 ? 'Cardioid' : 'Inner loop'));
                setEl('val-symmetry', 'x-axis');
            } else if (curveType === 'circle') {
                setEl('val-polar-eq', 'r = ' + paramA.toFixed(1));
                setEl('val-petals', 'Circle');
                setEl('val-symmetry', 'All');
            }
            setEl('val-max-r', 'r\u2098\u2090\u2093 = ' + paramA.toFixed(1));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('polar', polarViz);
})();
