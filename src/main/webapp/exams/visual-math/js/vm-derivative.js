/**
 * Visual Math — Derivative / Tangent Line Visualizer
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;

    var FUNCTIONS = {
        'x2':    { fn: function(x){return x*x;},      dfn: function(x){return 2*x;},      label: 'x\u00B2',     dlabel: '2x',         range: [-4,4] },
        'x3':    { fn: function(x){return x*x*x;},    dfn: function(x){return 3*x*x;},    label: 'x\u00B3',     dlabel: '3x\u00B2',   range: [-3,3] },
        'sin':   { fn: Math.sin,                        dfn: Math.cos,                       label: 'sin(x)',      dlabel: 'cos(x)',      range: [-6.28,6.28] },
        'cos':   { fn: Math.cos,                        dfn: function(x){return -Math.sin(x);}, label: 'cos(x)', dlabel: '-sin(x)',     range: [-6.28,6.28] },
        'exp':   { fn: Math.exp,                        dfn: Math.exp,                       label: 'e\u02E3',    dlabel: 'e\u02E3',    range: [-3,3] },
        'ln':    { fn: Math.log,                        dfn: function(x){return 1/x;},       label: 'ln(x)',       dlabel: '1/x',        range: [0.1,8] },
        'sqrt':  { fn: Math.sqrt,                       dfn: function(x){return 0.5/Math.sqrt(x);}, label: '\u221Ax', dlabel: '1/(2\u221Ax)', range: [0,8] },
        '1/x':   { fn: function(x){return 1/x;},      dfn: function(x){return -1/(x*x);},  label: '1/x',         dlabel: '-1/x\u00B2', range: [-5,5] }
    };

    function derivative(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 20, padB = 40;

        if (!state.func) state.func = 'sin';
        if (state.xPos == null) state.xPos = 1;
        if (state.showDeriv == null) state.showDeriv = false;

        function layout() {
            W = container.clientWidth;
            H = Math.max(350, Math.min(480, W * 0.55));
        }

        p.setup = function() { layout(); p.createCanvas(W, H); };
        p.windowResized = function() { layout(); p.resizeCanvas(W, H); };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);

            var cfg = FUNCTIONS[state.func];
            var fn = cfg.fn, dfn = cfg.dfn;
            var xMin = cfg.range[0], xMax = cfg.range[1];
            var gw = W - padL - padR, gh = H - padT - padB;

            // Auto y-range
            var yMin = Infinity, yMax = -Infinity;
            for (var si = 0; si <= 200; si++) {
                var sx = xMin + (si / 200) * (xMax - xMin);
                var sy = fn(sx);
                if (isFinite(sy) && Math.abs(sy) < 1e4) {
                    if (sy < yMin) yMin = sy;
                    if (sy > yMax) yMax = sy;
                }
                if (state.showDeriv) {
                    var dy = dfn(sx);
                    if (isFinite(dy) && Math.abs(dy) < 1e4) {
                        if (dy < yMin) yMin = dy;
                        if (dy > yMax) yMax = dy;
                    }
                }
            }
            var yPad = (yMax - yMin) * 0.12 || 1;
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

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            if (yMin <= 0 && yMax >= 0) p.line(padL, mapY(0), padL + gw, mapY(0));
            if (xMin <= 0 && xMax >= 0) p.line(mapX(0), padT, mapX(0), padT + gh);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.TOP);
            var xStep = niceStep(xMax - xMin, 6);
            var xStart = Math.ceil(xMin / xStep) * xStep;
            var baseY = (yMin <= 0 && yMax >= 0) ? mapY(0) + 6 : padT + gh + 6;
            for (var xl = xStart; xl <= xMax; xl += xStep) {
                var xx = mapX(xl);
                if (xx > padL + 15 && xx < padL + gw - 15) p.text(fmt(xl), xx, baseY);
            }

            // Derivative curve (optional, behind main curve)
            if (state.showDeriv) {
                p.stroke(C.cos[0], C.cos[1], C.cos[2], 160); p.strokeWeight(2); p.noFill();
                p.beginShape();
                var prevValid = false;
                for (var di = 0; di <= gw; di += 2) {
                    var dx = xMin + (di / gw) * (xMax - xMin);
                    var dv = dfn(dx);
                    if (isFinite(dv) && Math.abs(dv) < 1e4) {
                        if (!prevValid) { p.endShape(); p.beginShape(); }
                        p.vertex(padL + di, mapY(dv));
                        prevValid = true;
                    } else { if (prevValid) { p.endShape(); p.beginShape(); } prevValid = false; }
                }
                p.endShape();
            }

            // Main function curve
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            var prevV = false;
            for (var fi = 0; fi <= gw; fi += 2) {
                var fx = xMin + (fi / gw) * (xMax - xMin);
                var fy = fn(fx);
                if (isFinite(fy) && Math.abs(fy) < 1e4) {
                    if (!prevV) { p.endShape(); p.beginShape(); }
                    p.vertex(padL + fi, mapY(fy));
                    prevV = true;
                } else { if (prevV) { p.endShape(); p.beginShape(); } prevV = false; }
            }
            p.endShape();

            // Tangent line at xPos
            var xp = state.xPos;
            var fp = fn(xp), slope = dfn(xp);
            if (isFinite(fp) && isFinite(slope)) {
                var tangentLen = (xMax - xMin) * 0.25;
                var x1 = xp - tangentLen, y1 = fp - slope * tangentLen;
                var x2 = xp + tangentLen, y2 = fp + slope * tangentLen;

                p.stroke(C.tan); p.strokeWeight(2.5);
                p.line(mapX(x1), mapY(y1), mapX(x2), mapY(y2));

                // Point on curve
                p.fill(C.point); p.stroke(C.accent); p.strokeWeight(2);
                p.ellipse(mapX(xp), mapY(fp), 12, 12);

                // Vertical dashed line
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 60); p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(mapX(xp), padT, mapX(xp), padT + gh);
                p.drawingContext.setLineDash([]);
            }

            // Legend
            p.textSize(12); p.textAlign(p.LEFT, p.TOP); p.noStroke();
            p.fill(C.sin); p.text('f(x) = ' + cfg.label, padL + 10, padT + 6);
            p.fill(C.tan); p.text('slope = ' + (isFinite(slope) ? slope.toFixed(4) : 'undefined'), padL + 10, padT + 22);
            if (state.showDeriv) {
                p.fill(C.cos); p.text("f'(x) = " + cfg.dlabel, padL + 10, padT + 38);
            }

            // Sync panel
            setEl('val-fx', isFinite(fp) ? fp.toFixed(4) : 'undefined');
            setEl('val-slope', isFinite(slope) ? slope.toFixed(4) : 'undefined');
            setEl('val-deriv-formula', "f'(x) = " + cfg.dlabel);

            p.noLoop();
        };

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
        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function() { p.loop(); };
    }

    VisualMath.register('derivative', derivative);
    VisualMath._derivFunctions = FUNCTIONS;
})();
