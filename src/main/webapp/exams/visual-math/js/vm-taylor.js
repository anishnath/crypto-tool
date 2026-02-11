/**
 * Visual Math — Taylor Series Builder
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;

    var FUNCTIONS = {
        'sin':  { fn: Math.sin,  label: 'sin(x)',  center: 0, range: [-7, 7] },
        'cos':  { fn: Math.cos,  label: 'cos(x)',  center: 0, range: [-7, 7] },
        'exp':  { fn: Math.exp,  label: 'e\u02E3', center: 0, range: [-4, 4] },
        'ln1x': { fn: function(x){return Math.log(1+x);}, label: 'ln(1+x)', center: 0, range: [-0.9, 4] },
        '1/(1-x)': { fn: function(x){return 1/(1-x);}, label: '1/(1-x)', center: 0, range: [-3, 0.9] }
    };

    // Taylor coefficients at center=0 for each function
    function taylorCoeff(name, n) {
        switch (name) {
            case 'sin':
                // sin: 0, 1, 0, -1/6, 0, 1/120, ...
                if (n % 2 === 0) return 0;
                var k = (n - 1) / 2;
                return Math.pow(-1, k) / factorial(n);
            case 'cos':
                if (n % 2 === 1) return 0;
                var k2 = n / 2;
                return Math.pow(-1, k2) / factorial(n);
            case 'exp':
                return 1 / factorial(n);
            case 'ln1x':
                if (n === 0) return 0;
                return Math.pow(-1, n + 1) / n;
            case '1/(1-x)':
                return 1; // geometric series: sum x^n
            default:
                return 0;
        }
    }

    function factorial(n) {
        var r = 1;
        for (var i = 2; i <= n; i++) r *= i;
        return r;
    }

    function taylorEval(name, x, terms) {
        var sum = 0;
        for (var n = 0; n < terms; n++) {
            sum += taylorCoeff(name, n) * Math.pow(x, n);
        }
        return sum;
    }

    function taylor(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 30, padB = 40;

        if (!state.func) state.func = 'sin';
        if (!state.terms) state.terms = 3;

        function layout() {
            W = container.clientWidth;
            H = Math.max(350, Math.min(480, W * 0.55));
        }

        p.setup = function() {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function() {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);

            var cfg = FUNCTIONS[state.func];
            var fn = cfg.fn;
            var xMin = cfg.range[0], xMax = cfg.range[1];
            var terms = state.terms;

            var gw = W - padL - padR;
            var gh = H - padT - padB;

            // Find y range from the exact function
            var yMin = Infinity, yMax = -Infinity;
            for (var si = 0; si <= 200; si++) {
                var sx = xMin + (si / 200) * (xMax - xMin);
                var sy = fn(sx);
                if (isFinite(sy)) {
                    if (sy < yMin) yMin = sy;
                    if (sy > yMax) yMax = sy;
                }
            }
            var yPad = (yMax - yMin) * 0.15 || 1;
            yMin -= yPad;
            yMax += yPad;

            function mapX(x) { return padL + ((x - xMin) / (xMax - xMin)) * gw; }
            function mapY(y) { return padT + gh - ((y - yMin) / (yMax - yMin)) * gh; }

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            // Horizontal
            var yStep = niceStep(yMax - yMin, 5);
            var yStart = Math.ceil(yMin / yStep) * yStep;
            for (var yg = yStart; yg <= yMax; yg += yStep) {
                var yy = mapY(yg);
                if (yy > padT && yy < padT + gh) {
                    p.line(padL, yy, padL + gw, yy);
                    p.fill(C.muted); p.noStroke(); p.textSize(10);
                    p.textAlign(p.RIGHT, p.CENTER);
                    p.text(yg.toFixed(1), padL - 6, yy);
                    p.stroke(C.grid); p.strokeWeight(0.5);
                }
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            if (yMin <= 0 && yMax >= 0) p.line(padL, mapY(0), padL + gw, mapY(0));
            if (xMin <= 0 && xMax >= 0) p.line(mapX(0), padT, mapX(0), padT + gh);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            var xStep = niceStep(xMax - xMin, 6);
            var xs = Math.ceil(xMin / xStep) * xStep;
            var baselineY = (yMin <= 0 && yMax >= 0) ? mapY(0) + 6 : padT + gh + 6;
            for (var xl = xs; xl <= xMax; xl += xStep) {
                p.text(xl.toFixed(1), mapX(xl), baselineY);
            }

            // Error shading between exact and approx
            if (state.showError !== false) {
                p.fill(C.sin[0], C.sin[1], C.sin[2], 20);
                p.noStroke();
                p.beginShape();
                for (var ei = 0; ei <= gw; ei += 2) {
                    var ex = xMin + (ei / gw) * (xMax - xMin);
                    var ey = fn(ex);
                    if (isFinite(ey)) p.vertex(padL + ei, clampY(mapY(ey)));
                }
                for (var ej = gw; ej >= 0; ej -= 2) {
                    var ex2 = xMin + (ej / gw) * (xMax - xMin);
                    var ty = taylorEval(state.func, ex2, terms);
                    if (isFinite(ty)) p.vertex(padL + ej, clampY(mapY(ty)));
                }
                p.endShape(p.CLOSE);
            }

            // Exact function (gray)
            p.stroke(C.muted); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var ci = 0; ci <= gw; ci += 2) {
                var cx = xMin + (ci / gw) * (xMax - xMin);
                var cy = fn(cx);
                if (isFinite(cy)) p.vertex(padL + ci, clampY(mapY(cy)));
            }
            p.endShape();

            // Taylor approximation (colored)
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var ti = 0; ti <= gw; ti += 2) {
                var tx = xMin + (ti / gw) * (xMax - xMin);
                var tv = taylorEval(state.func, tx, terms);
                if (isFinite(tv)) p.vertex(padL + ti, clampY(mapY(tv)));
            }
            p.endShape();

            // Center point marker
            p.fill(C.accent); p.noStroke();
            p.ellipse(mapX(0), clampY(mapY(fn(0))), 10, 10);

            // Labels
            p.fill(C.muted); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text(cfg.label + ' (exact)', padL + 10, padT + 6);
            p.fill(C.sin);
            p.text('T\u2099(x), n=' + terms, padL + 10, padT + 22);

            // Build formula string
            var formula = buildFormula(state.func, terms);
            setEl('val-formula', formula);
            setEl('val-terms', String(terms));

            function clampY(y) { return Math.max(padT - 20, Math.min(padT + gh + 20, y)); }

            p.noLoop();
        };

        state._redraw = function() { p.loop(); };
    }

    function buildFormula(name, terms) {
        var parts = [];
        for (var n = 0; n < terms; n++) {
            var c = taylorCoeff(name, n);
            if (Math.abs(c) < 1e-15) continue;
            var term = '';
            if (Math.abs(c - 1) < 1e-10 && n > 0) term = '';
            else if (Math.abs(c + 1) < 1e-10 && n > 0) term = '-';
            else {
                var frac = toFraction(c);
                term = frac;
            }
            if (n === 0) term += (term === '' || term === '-') ? (c >= 0 ? '1' : '1') : '';
            else if (n === 1) term += 'x';
            else term += 'x' + superscript(n);

            if (parts.length > 0 && c > 0) term = ' + ' + term;
            else if (parts.length > 0 && c < 0 && term[0] !== '-') term = ' - ' + term;
            else if (parts.length > 0 && c < 0) term = ' ' + term;
            parts.push(term);
        }
        return parts.join('') || '0';
    }

    function superscript(n) {
        var sup = { '0':'\u2070','1':'\u00B9','2':'\u00B2','3':'\u00B3','4':'\u2074',
                    '5':'\u2075','6':'\u2076','7':'\u2077','8':'\u2078','9':'\u2079' };
        return String(n).split('').map(function(d) { return sup[d] || d; }).join('');
    }

    function toFraction(c) {
        if (Math.abs(c - Math.round(c)) < 1e-10) return String(Math.round(c));
        // Try common denominators
        for (var d = 2; d <= 720; d++) {
            var n = c * d;
            if (Math.abs(n - Math.round(n)) < 1e-8) {
                return Math.round(n) + '/' + d;
            }
        }
        return c.toFixed(4);
    }

    function niceStep(range, targetSteps) {
        var rough = range / targetSteps;
        var mag = Math.pow(10, Math.floor(Math.log10(rough)));
        var norm = rough / mag;
        var step;
        if (norm < 1.5) step = 1;
        else if (norm < 3) step = 2;
        else if (norm < 7) step = 5;
        else step = 10;
        return step * mag;
    }

    function setEl(id, txt) {
        var el = document.getElementById(id);
        if (el) el.textContent = txt;
    }

    VisualMath.register('taylor-series', taylor);
    VisualMath._taylorFunctions = FUNCTIONS;
})();
