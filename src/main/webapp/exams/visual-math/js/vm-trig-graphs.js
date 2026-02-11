/**
 * Visual Math — Trigonometric Graphs Visualizer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;

    function trigGraphsViz(p, container) {
        state = VisualMath.getState();
        var W, H;
        var pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            drawGraph(C);
            updateValues();

            p.noLoop();
        };

        function drawGraph(C) {
            var gw = W - pad * 2;
            var gh = H - pad * 2;
            var midY = pad + gh / 2;
            var midX = pad + gw / 2;

            p.push();

            // Grid
            if (state.showGrid) {
                p.stroke(C.grid);
                p.strokeWeight(0.5);
                var gridSpacing = gw / 12; // Every π/2
                for (var i = 0; i <= 12; i++) {
                    p.line(pad + i * gridSpacing, pad, pad + i * gridSpacing, pad + gh);
                }
                var vGridSpacing = gh / 8;
                for (var j = 0; j <= 8; j++) {
                    p.line(pad, pad + j * vGridSpacing, pad + gw, pad + j * vGridSpacing);
                }
            }

            // Axes
            p.stroke(C.axis);
            p.strokeWeight(2);
            p.line(pad, midY, pad + gw, midY); // X-axis
            p.line(midX, pad, midX, pad + gh); // Y-axis

            // Axis labels
            if (state.showLabels !== false) {
                p.fill(C.muted);
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER, p.TOP);

                // X-axis labels (in terms of π)
                var labels = ['0', 'π/2', 'π', '3π/2', '2π'];
                for (var k = 0; k < 5; k++) {
                    p.text(labels[k], pad + k * (gw / 4), midY + 6);
                }

                // Y-axis labels
                p.textAlign(p.RIGHT, p.CENTER);
                var amp = state.amplitude || 1;
                var vert = state.vertical || 0;
                var maxY = amp + vert;
                var minY = -amp + vert;
                p.text(maxY.toFixed(1), pad - 6, midY - gh / 4);
                p.text('0', pad - 6, midY);
                p.text(minY.toFixed(1), pad - 6, midY + gh / 4);
            }

            // Midline (if vertical shift)
            if (Math.abs(state.vertical || 0) > 0.01) {
                p.stroke(C.muted);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                var midlineY = midY - (state.vertical || 0) * (gh / 8);
                p.line(pad, midlineY, pad + gw, midlineY);
                p.drawingContext.setLineDash([]);
            }

            // Draw function(s)
            var funcType = state.funcType || 'sin';
            var A = state.amplitude || 1;
            var B = state.frequency || 1;
            var C_phase = state.phase || 0;
            var D = state.vertical || 0;

            var scale = gh / 8; // 1 unit = gh/8 pixels

            if (funcType === 'sin' || funcType === 'all') {
                drawFunction(p, C.sin, 'sin', A, B, C_phase, D, pad, gw, midY, scale);
            }
            if (funcType === 'cos' || funcType === 'all') {
                drawFunction(p, C.cos, 'cos', A, B, C_phase, D, pad, gw, midY, scale);
            }
            if (funcType === 'tan' || funcType === 'all') {
                drawTangent(p, C.tan, A, B, C_phase, D, pad, gw, midY, scale);
            }

            // Legend if showing all
            if (funcType === 'all' && state.showLabels !== false) {
                p.fill(C.sin);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.LEFT, p.TOP);
                p.text('sin', pad + 10, pad + 10);

                p.fill(C.cos);
                p.text('cos', pad + 50, pad + 10);

                p.fill(C.tan);
                p.text('tan', pad + 90, pad + 10);
            }

            p.pop();
        }

        function drawFunction(p, color, type, A, B, C_phase, D, startX, width, midY, scale) {
            p.stroke(color);
            p.strokeWeight(2.5);
            p.noFill();
            p.beginShape();

            for (var i = 0; i <= width; i += 2) {
                var x = (i / width) * 2 * Math.PI; // 0 to 2π
                var y;

                if (type === 'sin') {
                    y = A * Math.sin(B * (x - C_phase)) + D;
                } else if (type === 'cos') {
                    y = A * Math.cos(B * (x - C_phase)) + D;
                }

                var py = midY - y * scale;
                p.vertex(startX + i, py);
            }

            p.endShape();
        }

        function drawTangent(p, color, A, B, C_phase, D, startX, width, midY, scale) {
            p.stroke(color);
            p.strokeWeight(2.5);
            p.noFill();

            var segments = [];
            var currentSegment = [];

            for (var i = 0; i <= width; i += 2) {
                var x = (i / width) * 2 * Math.PI;
                var y = A * Math.tan(B * (x - C_phase)) + D;

                // Check for asymptotes (where tan is undefined)
                if (Math.abs(y) > 10) {
                    if (currentSegment.length > 0) {
                        segments.push(currentSegment);
                        currentSegment = [];
                    }
                } else {
                    var py = midY - y * scale;
                    currentSegment.push({ x: startX + i, y: py });
                }
            }

            if (currentSegment.length > 0) {
                segments.push(currentSegment);
            }

            // Draw each segment
            segments.forEach(function (segment) {
                p.beginShape();
                segment.forEach(function (point) {
                    p.vertex(point.x, point.y);
                });
                p.endShape();
            });

            // Draw asymptotes
            p.stroke(color[0], color[1], color[2], 80);
            p.strokeWeight(1);
            p.drawingContext.setLineDash([4, 4]);

            var period = Math.PI / B;
            var firstAsymptote = (Math.PI / 2 + C_phase) / (2 * Math.PI);

            for (var k = 0; k < 4; k++) {
                var asymX = startX + (firstAsymptote + k * period / (2 * Math.PI)) * width;
                if (asymX >= startX && asymX <= startX + width) {
                    p.line(asymX, midY - 100, asymX, midY + 100);
                }
            }

            p.drawingContext.setLineDash([]);
        }

        function updateValues() {
            var funcType = state.funcType || 'sin';
            var A = state.amplitude || 1;
            var B = state.frequency || 1;
            var C_phase = state.phase || 0;
            var D = state.vertical || 0;

            var funcName = funcType === 'all' ? 'sin/cos/tan' : funcType;
            var formula = 'y = ';

            if (Math.abs(A - 1) > 0.01) formula += A.toFixed(1) + '·';
            formula += funcName + '(';
            if (Math.abs(B - 1) > 0.01) formula += B.toFixed(1);
            formula += 'x';
            if (Math.abs(C_phase) > 0.01) {
                formula += (C_phase > 0 ? ' - ' : ' + ') + Math.abs(C_phase).toFixed(1);
            }
            formula += ')';
            if (Math.abs(D) > 0.01) {
                formula += (D > 0 ? ' + ' : ' - ') + Math.abs(D).toFixed(1);
            }

            var period = (funcType === 'tan' ? Math.PI : 2 * Math.PI) / B;
            var periodStr = period.toFixed(2);
            if (Math.abs(period - 2 * Math.PI) < 0.01) periodStr = '2π';
            else if (Math.abs(period - Math.PI) < 0.01) periodStr = 'π';
            else if (Math.abs(period - Math.PI / 2) < 0.01) periodStr = 'π/2';

            setEl('val-formula', formula);
            setEl('val-period', periodStr);
            setEl('val-amp', A.toFixed(1));
            setEl('val-max', (A + D).toFixed(1));
            setEl('val-min', (-A + D).toFixed(1));
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('trig-graphs', trigGraphsViz);
})();
