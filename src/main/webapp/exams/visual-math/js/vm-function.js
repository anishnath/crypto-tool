/**
 * Visual Math — Function Plotter
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;
    var parsedFns = [null, null, null];
    var COLORS = [
        [239, 68, 68],
        [59, 130, 246],
        [34, 197, 94]
    ];

    function functionPlotter(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 20, padB = 40;

        if (!state.exprs) state.exprs = ['sin(x)', '', ''];
        if (state.xMin == null) state.xMin = -6.28;
        if (state.xMax == null) state.xMax = 6.28;
        reparseAll();

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

            var xMin = state.xMin, xMax = state.xMax;
            var gw = W - padL - padR;
            var gh = H - padT - padB;

            // Auto y-range
            var yMin = -1, yMax = 1, found = false;
            for (var fi = 0; fi < 3; fi++) {
                if (!parsedFns[fi]) continue;
                for (var si = 0; si <= 300; si++) {
                    var sx = xMin + (si / 300) * (xMax - xMin);
                    try {
                        var sy = parsedFns[fi](sx);
                        if (isFinite(sy) && Math.abs(sy) < 1e6) {
                            if (!found) { yMin = sy; yMax = sy; found = true; }
                            if (sy < yMin) yMin = sy;
                            if (sy > yMax) yMax = sy;
                        }
                    } catch(e) {}
                }
            }
            if (!found) { yMin = -5; yMax = 5; }
            var yPad = (yMax - yMin) * 0.1 || 1;
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
            var xStart = Math.ceil(xMin / xStep) * xStep;
            for (var xg = xStart; xg <= xMax; xg += xStep) {
                var xx = mapX(xg);
                if (xx > padL && xx < padL + gw) {
                    p.line(xx, padT, xx, padT + gh);
                }
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            if (yMin <= 0 && yMax >= 0) p.line(padL, mapY(0), padL + gw, mapY(0));
            if (xMin <= 0 && xMax >= 0) p.line(mapX(0), padT, mapX(0), padT + gh);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            var baseY = (yMin <= 0 && yMax >= 0) ? mapY(0) + 6 : padT + gh + 6;
            for (var xl = xStart; xl <= xMax; xl += xStep) {
                var xlx = mapX(xl);
                if (xlx > padL + 15 && xlx < padL + gw - 15) {
                    p.text(fmt(xl), xlx, baseY);
                }
            }

            // Plot each function
            for (var fi2 = 0; fi2 < 3; fi2++) {
                if (!parsedFns[fi2]) continue;
                p.stroke(COLORS[fi2]); p.strokeWeight(2.5); p.noFill();
                var drawing = false;
                var prevPy = NaN;
                p.beginShape();
                for (var pi = 0; pi <= gw; pi++) {
                    var px = xMin + (pi / gw) * (xMax - xMin);
                    try {
                        var py = parsedFns[fi2](px);
                        if (isFinite(py) && Math.abs(py) < 1e6) {
                            // Break on large jumps (discontinuities)
                            if (drawing && Math.abs(py - prevPy) > (yMax - yMin) * 4) {
                                p.endShape(); p.beginShape(); drawing = false;
                            }
                            var sy2 = mapY(py);
                            sy2 = Math.max(padT - 50, Math.min(padT + gh + 50, sy2));
                            if (!drawing) { p.endShape(); p.beginShape(); }
                            p.vertex(padL + pi, sy2);
                            drawing = true;
                            prevPy = py;
                        } else {
                            if (drawing) { p.endShape(); p.beginShape(); drawing = false; }
                            prevPy = NaN;
                        }
                    } catch(e) {
                        if (drawing) { p.endShape(); p.beginShape(); drawing = false; }
                        prevPy = NaN;
                    }
                }
                p.endShape();
            }

            // Crosshair on hover
            var mx = p.mouseX, my = p.mouseY;
            if (mx > padL && mx < padL + gw && my > padT && my < padT + gh) {
                var xv = xMin + ((mx - padL) / gw) * (xMax - xMin);
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 60);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(mx, padT, mx, padT + gh);
                p.drawingContext.setLineDash([]);

                var ty = padT + 10;
                p.textSize(11); p.textAlign(p.LEFT, p.TOP);
                p.fill(C.muted); p.noStroke();
                p.text('x = ' + xv.toFixed(3), mx + 8, ty); ty += 15;
                for (var ci = 0; ci < 3; ci++) {
                    if (!parsedFns[ci]) continue;
                    try {
                        var cv = parsedFns[ci](xv);
                        if (isFinite(cv)) {
                            var cvy = mapY(cv);
                            if (cvy > padT - 10 && cvy < padT + gh + 10) {
                                p.fill(COLORS[ci]); p.noStroke();
                                p.ellipse(mx, cvy, 7, 7);
                            }
                            p.fill(COLORS[ci]); p.noStroke();
                            p.text('f' + (ci + 1) + ' = ' + cv.toFixed(3), mx + 8, ty); ty += 15;
                        }
                    } catch(e) {}
                }
            }

            p.noLoop();
        };

        p.mouseMoved = function() { p.redraw(); };

        function reparseAll() {
            for (var i = 0; i < 3; i++) {
                parsedFns[i] = state.exprs[i] ? parseExpr(state.exprs[i]) : null;
            }
        }

        state._redraw = function() { reparseAll(); p.loop(); };
    }

    // --- Expression Parser ---
    function parseExpr(input) {
        var str = input.replace(/\s+/g, '');
        if (!str) return null;
        var pos = 0;

        function peek() { return pos < str.length ? str[pos] : ''; }
        function consume() { return str[pos++]; }

        function parseExpression() { return parseAddSub(); }

        function parseAddSub() {
            var node = parseMulDiv();
            while (peek() === '+' || peek() === '-') {
                var op = consume();
                node = { t: 'o', o: op, l: node, r: parseMulDiv() };
            }
            return node;
        }

        function parseMulDiv() {
            var node = parseImplicit();
            while (peek() === '*' || peek() === '/') {
                var op = consume();
                node = { t: 'o', o: op, l: node, r: parseImplicit() };
            }
            return node;
        }

        function parseImplicit() {
            var node = parsePow();
            while (canStartFactor()) {
                node = { t: 'o', o: '*', l: node, r: parsePow() };
            }
            return node;
        }

        function canStartFactor() {
            var c = peek();
            return c === '(' || c === '|' ||
                (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
        }

        function parsePow() {
            var node = parseUnary();
            if (peek() === '^') { consume(); node = { t: 'o', o: '^', l: node, r: parsePow() }; }
            return node;
        }

        function parseUnary() {
            if (peek() === '-') { consume(); return { t: 'n', a: parseUnary() }; }
            if (peek() === '+') { consume(); return parseUnary(); }
            return parseAtom();
        }

        function parseAtom() {
            var c = peek();

            // Number
            if ((c >= '0' && c <= '9') || c === '.') {
                var s = pos, hasDot = false;
                while ((peek() >= '0' && peek() <= '9') || (!hasDot && peek() === '.')) {
                    if (peek() === '.') hasDot = true;
                    consume();
                }
                return { t: 'v', v: parseFloat(str.substring(s, pos)) };
            }

            // Parentheses
            if (c === '(') {
                consume();
                var node = parseExpression();
                if (peek() === ')') consume();
                return node;
            }

            // Absolute value |...|
            if (c === '|') {
                consume();
                var node2 = parseExpression();
                if (peek() === '|') consume();
                return { t: 'f', f: 'abs', a: node2 };
            }

            // Name (variable, constant, or function)
            if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
                var s2 = pos;
                while ((peek() >= 'a' && peek() <= 'z') || (peek() >= 'A' && peek() <= 'Z')) consume();
                var name = str.substring(s2, pos);

                // Handle log10, log2
                if (name === 'log' && peek() === '1' && pos + 1 < str.length && str[pos + 1] === '0') {
                    consume(); consume(); name = 'log10';
                } else if (name === 'log' && peek() === '2' && str[pos + 1] !== '(') {
                    consume(); name = 'log2';
                }

                if (name === 'x' || name === 'X') return { t: 'x' };
                if (name === 'pi' || name === 'PI') return { t: 'v', v: Math.PI };
                if (name === 'e') return { t: 'v', v: Math.E };

                // Function call
                if (peek() === '(') {
                    consume();
                    var arg = parseExpression();
                    if (peek() === ')') consume();
                    return { t: 'f', f: name.toLowerCase(), a: arg };
                }

                return { t: 'v', v: NaN };
            }

            if (peek()) consume();
            return { t: 'v', v: NaN };
        }

        try {
            var tree = parseExpression();
        } catch(e) { return null; }

        return function(x) {
            try { return evalNode(tree, x); }
            catch(e) { return NaN; }
        };
    }

    function evalNode(n, x) {
        switch(n.t) {
            case 'v': return n.v;
            case 'x': return x;
            case 'n': return -evalNode(n.a, x);
            case 'f':
                var a = evalNode(n.a, x);
                switch(n.f) {
                    case 'sin': return Math.sin(a);
                    case 'cos': return Math.cos(a);
                    case 'tan': return Math.tan(a);
                    case 'asin': case 'arcsin': return Math.asin(a);
                    case 'acos': case 'arccos': return Math.acos(a);
                    case 'atan': case 'arctan': return Math.atan(a);
                    case 'log': case 'ln': return Math.log(a);
                    case 'log10': return Math.log10(a);
                    case 'log2': return Math.log2(a);
                    case 'sqrt': return Math.sqrt(a);
                    case 'abs': return Math.abs(a);
                    case 'exp': return Math.exp(a);
                    case 'floor': return Math.floor(a);
                    case 'ceil': return Math.ceil(a);
                    case 'sign': case 'sgn': return Math.sign(a);
                    case 'sinh': return Math.sinh(a);
                    case 'cosh': return Math.cosh(a);
                    case 'tanh': return Math.tanh(a);
                    default: return NaN;
                }
            case 'o':
                var l = evalNode(n.l, x), r = evalNode(n.r, x);
                switch(n.o) {
                    case '+': return l + r;
                    case '-': return l - r;
                    case '*': return l * r;
                    case '/': return l / r;
                    case '^': return Math.pow(l, r);
                }
                return NaN;
            default: return NaN;
        }
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

    VisualMath.register('function-plotter', functionPlotter);
    VisualMath._parseExpr = parseExpr;
})();
