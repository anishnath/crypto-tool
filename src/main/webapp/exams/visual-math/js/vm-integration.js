/**
 * Visual Math — Integration Explorer (Definite Integrals, FTC, Area Between Curves)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function integrationViz(p, container) {
        state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getFunc(x) {
            var ft = state.funcType || 'x2';
            if (ft === 'x2') return x * x;
            if (ft === 'sinx') return Math.sin(x);
            if (ft === 'cosx') return Math.cos(x);
            if (ft === 'ex') return Math.exp(x);
            if (ft === 'sqrtx') return x >= 0 ? Math.sqrt(x) : 0;
            if (ft === 'x3-3x') return x * x * x - 3 * x;
            return x * x;
        }

        function getAntideriv(x) {
            var ft = state.funcType || 'x2';
            if (ft === 'x2') return x * x * x / 3;
            if (ft === 'sinx') return -Math.cos(x);
            if (ft === 'cosx') return Math.sin(x);
            if (ft === 'ex') return Math.exp(x);
            if (ft === 'sqrtx') return x >= 0 ? 2 * Math.pow(x, 1.5) / 3 : 0;
            if (ft === 'x3-3x') return x * x * x * x / 4 - 1.5 * x * x;
            return x * x * x / 3;
        }

        function getFunc2(x) {
            // Second function for area-between mode
            if (state.mode === 'between') {
                var ft2 = state.func2Type || 'linear';
                if (ft2 === 'linear') return x;
                if (ft2 === 'zero') return 0;
                if (ft2 === 'const') return 1;
                return 0;
            }
            return 0;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            drawIntegration(C);
            updateValues();
            if (state.animating) {
                state.animBound = (state.animBound || state.lower || 0) + 0.03;
                if (state.animBound > (state.upper || 3)) {
                    state.animBound = state.upper || 3;
                    state.animating = false;
                }
            } else {
                p.noLoop();
            }
        };

        function drawIntegration(C) {
            var gw = W - pad * 2, gh = H - pad * 2;
            var mode = state.mode || 'single';
            var a = state.lower != null ? state.lower : 0;
            var b = state.upper != null ? state.upper : 3;
            var animB = state.animating ? (state.animBound || a) : b;

            // Determine view
            var xMin = Math.min(a, -1) - 1, xMax = Math.max(b, 4) + 1;
            var ft = state.funcType || 'x2';
            var yMin = -2, yMax = 6;
            if (ft === 'sinx' || ft === 'cosx') { yMin = -2; yMax = 2; }
            if (ft === 'ex') { yMin = -1; yMax = Math.min(Math.exp(b) + 1, 15); }
            if (ft === 'x3-3x') { yMin = -5; yMax = 5; }

            var xScale = gw / (xMax - xMin);
            var yScale = gh / (yMax - yMin);

            function toSx(x) { return pad + (x - xMin) * xScale; }
            function toSy(y) { return pad + (yMax - y) * yScale; }

            // Grid
            p.stroke(C.grid || [200, 200, 200, 60]); p.strokeWeight(0.5);
            for (var gx = Math.ceil(xMin); gx <= Math.floor(xMax); gx++)
                p.line(toSx(gx), pad, toSx(gx), pad + gh);
            for (var gy = Math.ceil(yMin); gy <= Math.floor(yMax); gy++)
                p.line(pad, toSy(gy), pad + gw, toSy(gy));

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            if (toSy(0) >= pad && toSy(0) <= pad + gh) p.line(pad, toSy(0), pad + gw, toSy(0));
            if (toSx(0) >= pad && toSx(0) <= pad + gw) p.line(toSx(0), pad, toSx(0), pad + gh);

            // Tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(9);
            for (var tx = Math.ceil(xMin); tx <= Math.floor(xMax); tx++) {
                if (tx === 0) continue;
                p.textAlign(p.CENTER, p.TOP);
                if (toSy(0) >= pad && toSy(0) <= pad + gh)
                    p.text(tx, toSx(tx), toSy(0) + 3);
            }

            // Shaded area
            p.fill(C.accent[0], C.accent[1], C.accent[2], 40);
            p.noStroke();
            p.beginShape();
            if (mode === 'between') {
                // Area between f and g
                var dx = (animB - a) / 200;
                for (var x1 = a; x1 <= animB; x1 += dx) {
                    p.vertex(toSx(x1), toSy(getFunc(x1)));
                }
                for (var x2 = animB; x2 >= a; x2 -= dx) {
                    p.vertex(toSx(x2), toSy(getFunc2(x2)));
                }
            } else {
                // Area under f(x) to x-axis
                p.vertex(toSx(a), toSy(0));
                var dx2 = (animB - a) / 200;
                for (var x3 = a; x3 <= animB; x3 += dx2) {
                    p.vertex(toSx(x3), toSy(getFunc(x3)));
                }
                p.vertex(toSx(animB), toSy(0));
            }
            p.endShape(p.CLOSE);

            // Function curve f(x)
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var x4 = xMin; x4 <= xMax; x4 += 0.02) {
                var y4 = getFunc(x4);
                if (y4 >= yMin - 1 && y4 <= yMax + 1) p.vertex(toSx(x4), toSy(y4));
                else { p.endShape(); p.beginShape(); }
            }
            p.endShape();

            // Second function (if between mode)
            if (mode === 'between') {
                p.stroke(C.cos); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var x5 = xMin; x5 <= xMax; x5 += 0.02) {
                    var y5 = getFunc2(x5);
                    if (y5 >= yMin - 1 && y5 <= yMax + 1) p.vertex(toSx(x5), toSy(y5));
                }
                p.endShape();
            }

            // Bounds markers
            p.stroke(C.accent); p.strokeWeight(1.5);
            p.drawingContext.setLineDash([4, 3]);
            p.line(toSx(a), pad, toSx(a), pad + gh);
            p.line(toSx(animB), pad, toSx(animB), pad + gh);
            p.drawingContext.setLineDash([]);

            // Labels at bounds
            p.fill(C.accent); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP);
            p.text('a=' + a.toFixed(1), toSx(a), pad + gh + 3);
            p.text('b=' + b.toFixed(1), toSx(b), pad + gh + 14);

            // Antiderivative line (if showFTC)
            if (state.showFTC) {
                p.stroke(C.cos); p.strokeWeight(1.5); p.noFill();
                p.drawingContext.setLineDash([5, 4]);
                p.beginShape();
                for (var x6 = xMin; x6 <= xMax; x6 += 0.02) {
                    var y6 = getAntideriv(x6);
                    if (y6 >= yMin - 1 && y6 <= yMax + 1) p.vertex(toSx(x6), toSy(y6));
                    else { p.endShape(); p.beginShape(); }
                }
                p.endShape();
                p.drawingContext.setLineDash([]);

                // F(b) - F(a) markers
                var Fa = getAntideriv(a), Fb = getAntideriv(animB);
                p.fill(C.cos); p.noStroke();
                p.ellipse(toSx(a), toSy(Fa), 8, 8);
                p.ellipse(toSx(animB), toSy(Fb), 8, 8);
                p.textSize(10); p.textAlign(p.LEFT, p.BOTTOM);
                p.text('F(a)=' + Fa.toFixed(2), toSx(a) + 6, toSy(Fa) - 3);
                p.text('F(b)=' + Fb.toFixed(2), toSx(animB) + 6, toSy(Fb) - 3);
            }

            // Equation label
            p.fill(C.sin); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.TOP);
            var funcNames = { x2: 'x\u00B2', sinx: 'sin(x)', cosx: 'cos(x)', ex: 'e\u02E3', sqrtx: '\u221Ax', 'x3-3x': 'x\u00B3\u22123x' };
            p.text('f(x) = ' + (funcNames[ft] || ft), pad + 6, pad + 4);
        }

        function numericalIntegral(a, b) {
            // Simpson's rule
            var n = 200;
            var h = (b - a) / n;
            var sum = getFunc(a) + getFunc(b);
            for (var i = 1; i < n; i++) {
                var x = a + i * h;
                var mode2 = state.mode || 'single';
                if (mode2 === 'between') {
                    sum += (i % 2 === 0 ? 2 : 4) * (getFunc(x) - getFunc2(x));
                } else {
                    sum += (i % 2 === 0 ? 2 : 4) * getFunc(x);
                }
            }
            if (state.mode === 'between') {
                sum = (getFunc(a) - getFunc2(a)) + (getFunc(b) - getFunc2(b));
                for (var j = 1; j < n; j++) {
                    var xj = a + j * h;
                    sum += (j % 2 === 0 ? 2 : 4) * (getFunc(xj) - getFunc2(xj));
                }
            }
            return sum * h / 3;
        }

        function updateValues() {
            var ft = state.funcType || 'x2';
            var a = state.lower != null ? state.lower : 0;
            var b = state.upper != null ? state.upper : 3;

            var funcNames = { x2: 'x\u00B2', sinx: 'sin(x)', cosx: 'cos(x)', ex: 'e\u02E3', sqrtx: '\u221Ax', 'x3-3x': 'x\u00B3\u22123x' };
            setEl('val-func', 'f(x) = ' + (funcNames[ft] || ft));
            setEl('val-bounds', '[' + a.toFixed(1) + ', ' + b.toFixed(1) + ']');

            var integral = numericalIntegral(a, b);
            setEl('val-integral', integral.toFixed(4));

            // Exact via antiderivative
            var exact = getAntideriv(b) - getAntideriv(a);
            setEl('val-exact', exact.toFixed(4));

            var antiderivNames = { x2: 'x\u00B3/3', sinx: '\u2212cos(x)', cosx: 'sin(x)', ex: 'e\u02E3', sqrtx: '2x\u00B3\u02F2/3', 'x3-3x': 'x\u2074/4\u22121.5x\u00B2' };
            setEl('val-antideriv', 'F(x) = ' + (antiderivNames[ft] || '\u2014'));
            setEl('val-ftc', 'F(' + b.toFixed(1) + ') \u2212 F(' + a.toFixed(1) + ') = ' + exact.toFixed(4));
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('integration', integrationViz);
})();
