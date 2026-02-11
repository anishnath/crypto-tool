/**
 * Visual Math — Riemann Sum Explorer
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state;

    // Built-in functions
    var FUNCTIONS = {
        'sin':   { fn: Math.sin, label: 'sin(x)', a: 0, b: Math.PI, exact: 2 },
        'x2':    { fn: function(x){return x*x;}, label: 'x\u00B2', a: 0, b: 2, exact: 8/3 },
        'x3':    { fn: function(x){return x*x*x;}, label: 'x\u00B3', a: 0, b: 2, exact: 4 },
        'sqrt':  { fn: Math.sqrt, label: '\u221Ax', a: 0, b: 4, exact: 16/3 },
        'cos+1': { fn: function(x){return Math.cos(x)+1;}, label: 'cos(x)+1', a: 0, b: 2*Math.PI, exact: 2*Math.PI },
        '1/x':   { fn: function(x){return 1/(x||0.001);}, label: '1/x', a: 1, b: 5, exact: Math.log(5) }
    };

    function riemann(p, container) {
        state = VisualMath.getState();
        var W, H;
        var padL = 50, padR = 20, padT = 30, padB = 40;

        // Defaults
        if (!state.func) state.func = 'sin';
        if (!state.n) state.n = 10;
        if (!state.method) state.method = 'left';

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
            var fn = cfg.fn, a = cfg.a, b = cfg.b;
            var n = state.n;
            var method = state.method;

            var gw = W - padL - padR;
            var gh = H - padT - padB;

            // Find y range
            var yMax = 0;
            for (var i = 0; i <= 200; i++) {
                var x = a + (i / 200) * (b - a);
                var y = fn(x);
                if (y > yMax) yMax = y;
            }
            yMax = Math.max(yMax * 1.15, 0.1);

            // Mapping helpers
            function mapX(x) { return padL + ((x - a) / (b - a)) * gw; }
            function mapY(y) { return padT + gh - (y / yMax) * gh; }

            // Grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            for (var gi = 1; gi <= 4; gi++) {
                var gy = yMax * gi / 4;
                p.line(padL, mapY(gy), padL + gw, mapY(gy));
            }

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(padL, mapY(0), padL + gw, mapY(0)); // x-axis
            p.line(padL, padT, padL, padT + gh);        // y-axis

            // X tick labels
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP);
            var xTicks = 5;
            for (var xt = 0; xt <= xTicks; xt++) {
                var xv = a + (xt / xTicks) * (b - a);
                p.text(xv.toFixed(1), mapX(xv), mapY(0) + 6);
            }

            // Y tick labels
            p.textAlign(p.RIGHT, p.CENTER);
            for (var yt = 1; yt <= 4; yt++) {
                var yv = yMax * yt / 4;
                p.text(yv.toFixed(1), padL - 6, mapY(yv));
            }

            // Rectangles
            var sum = 0;
            var dx = (b - a) / n;
            for (var ri = 0; ri < n; ri++) {
                var xLeft = a + ri * dx;
                var sampleX;
                if (method === 'left') sampleX = xLeft;
                else if (method === 'right') sampleX = xLeft + dx;
                else sampleX = xLeft + dx / 2; // midpoint

                var fv = fn(sampleX);
                sum += fv * dx;

                var rx = mapX(xLeft);
                var rw = mapX(xLeft + dx) - rx;
                var ry = mapY(Math.max(0, fv));
                var rh = mapY(0) - ry;

                p.fill(C.accent[0], C.accent[1], C.accent[2], 50);
                p.stroke(C.accent[0], C.accent[1], C.accent[2], 140);
                p.strokeWeight(1);
                p.rect(rx, ry, rw, rh);

                // Midpoint dot
                if (method === 'midpoint') {
                    p.fill(C.accent); p.noStroke();
                    p.ellipse(mapX(sampleX), mapY(fv), 5, 5);
                }
            }

            // Function curve
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var ci = 0; ci <= gw; ci += 2) {
                var cx = a + (ci / gw) * (b - a);
                p.vertex(padL + ci, mapY(fn(cx)));
            }
            p.endShape();

            // Info box
            var exact = cfg.exact;
            var error = Math.abs(sum - exact);
            var pctErr = exact !== 0 ? (error / Math.abs(exact) * 100) : 0;

            p.fill(C.text); p.noStroke(); p.textSize(13);
            p.textAlign(p.LEFT, p.TOP);
            p.text('Approx: ' + sum.toFixed(6), padL + 10, padT + 6);

            p.fill(C.muted); p.textSize(11);
            p.text('Exact: ' + exact.toFixed(6) + '  |  Error: ' + pctErr.toFixed(2) + '%',
                   padL + 10, padT + 24);

            // Sync external display
            setEl('val-approx', sum.toFixed(6));
            setEl('val-exact', exact.toFixed(6));
            setEl('val-error', pctErr.toFixed(2) + '%');
            setEl('val-n', String(n));

            p.noLoop(); // static until controls change
        };

        // Redraw on state change
        state._redraw = function() { p.loop(); };

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }
    }

    VisualMath.register('riemann-sum', riemann);
    // Expose FUNCTIONS for the page to build UI
    VisualMath._riemannFunctions = FUNCTIONS;
})();
