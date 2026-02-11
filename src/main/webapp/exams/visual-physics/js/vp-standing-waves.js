/**
 * Visual Physics — Standing Waves & Harmonics Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function standingWaveViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = true;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getMode() { return state.mode || 'string'; }
        function getHarmonic() { return state.harmonic || 1; }
        function getLength() { return state.length || 1.0; }
        function getSpeed() { return state.waveSpeed || 340; }

        function calcWavelength() {
            var n = getHarmonic(), L = getLength(), mode = getMode();
            if (mode === 'closed') return 4 * L / n;
            return 2 * L / n; // string and open
        }

        function calcFrequency() {
            return getSpeed() / calcWavelength();
        }

        function nodesCount() {
            var n = getHarmonic(), mode = getMode();
            if (mode === 'string') return n + 1;
            if (mode === 'open') return n + 1;
            if (mode === 'closed') return Math.ceil((n + 1) / 2);
            return n + 1;
        }

        function antinodesCount() {
            var n = getHarmonic(), mode = getMode();
            if (mode === 'string') return n;
            if (mode === 'open') return n;
            if (mode === 'closed') return Math.ceil(n / 2);
            return n;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var pad = 50;
            var gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad, cy = H / 2;

            var mode = getMode();
            var n = getHarmonic();
            var L = getLength();
            var wl = calcWavelength();
            var omega = 2 * Math.PI * calcFrequency();

            // Effective n for closed pipe (odd only)
            var effN = n;
            if (mode === 'closed') effN = n; // already odd-enforced in JSP

            // Draw boundaries
            p.stroke(C.axis); p.strokeWeight(3);
            if (mode === 'string') {
                // Fixed endpoints
                p.fill(C.text); p.noStroke();
                p.ellipse(ox, cy, 10, 10);
                p.ellipse(ox + gw, cy, 10, 10);
            } else if (mode === 'open') {
                // Open pipe
                p.stroke(C.axis); p.strokeWeight(2);
                p.line(ox, cy - gh * 0.35, ox, cy + gh * 0.35);
                p.line(ox + gw, cy - gh * 0.35, ox + gw, cy + gh * 0.35);
            } else {
                // Closed pipe: closed on left, open on right
                p.stroke(C.axis); p.strokeWeight(3);
                p.line(ox, cy - gh * 0.35, ox, cy + gh * 0.35);
                p.stroke(C.axis); p.strokeWeight(2);
                p.line(ox + gw, cy - gh * 0.35, ox + gw, cy + gh * 0.35);
                p.drawingContext.setLineDash([4, 4]);
                p.line(ox + gw, cy - gh * 0.35, ox + gw, cy + gh * 0.35);
                p.drawingContext.setLineDash([]);
            }

            // Equilibrium line
            p.stroke(C.grid); p.strokeWeight(0.5);
            p.line(ox, cy, ox + gw, cy);

            var amp = gh * 0.3;
            var k;
            if (mode === 'closed') {
                k = effN * Math.PI / (2 * gw);
            } else {
                k = effN * Math.PI / gw;
            }

            // Envelope (optional)
            if (state.showEnvelope) {
                p.stroke(C.accent[0] || 99, C.accent[1] || 102, C.accent[2] || 241, 60);
                p.strokeWeight(1); p.noFill();
                p.beginShape();
                for (var ex = 0; ex <= gw; ex += 2) {
                    var envY;
                    if (mode === 'closed') {
                        envY = amp * Math.cos(k * ex);
                    } else {
                        envY = amp * Math.abs(Math.sin(k * ex));
                    }
                    p.vertex(ox + ex, cy - envY);
                }
                p.endShape();
                p.beginShape();
                for (var ex2 = 0; ex2 <= gw; ex2 += 2) {
                    var envY2;
                    if (mode === 'closed') {
                        envY2 = amp * Math.cos(k * ex2);
                    } else {
                        envY2 = amp * Math.abs(Math.sin(k * ex2));
                    }
                    p.vertex(ox + ex2, cy + envY2);
                }
                p.endShape();
            }

            // Standing wave
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            p.beginShape();
            for (var x = 0; x <= gw; x += 2) {
                var y;
                if (mode === 'closed') {
                    // Closed: pressure node at closed end = displacement antinode
                    y = amp * Math.cos(k * x) * Math.cos(omega * time * 0.001);
                } else {
                    y = amp * Math.sin(k * x) * Math.cos(omega * time * 0.001);
                }
                p.vertex(ox + x, cy - y);
            }
            p.endShape();

            // Node/antinode labels
            if (state.showLabels) {
                p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                for (var nx = 0; nx <= gw; nx += 2) {
                    var spatial;
                    if (mode === 'closed') {
                        spatial = Math.cos(k * nx);
                    } else {
                        spatial = Math.sin(k * nx);
                    }
                    if (Math.abs(spatial) < 0.03 && nx > 2) {
                        // Node
                        p.fill(239, 68, 68); p.noStroke();
                        p.ellipse(ox + nx, cy, 6, 6);
                        p.text('N', ox + nx, cy + 10);
                        p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
                    }
                    if (Math.abs(Math.abs(spatial) - 1) < 0.03) {
                        // Antinode
                        p.fill(59, 130, 246); p.noStroke();
                        p.ellipse(ox + nx, cy, 6, 6);
                        p.text('A', ox + nx, cy + 10);
                        p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
                    }
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var modeName = mode === 'string' ? 'Fixed String' : mode === 'open' ? 'Open Pipe' : 'Closed Pipe';
            p.text('Standing Waves — ' + modeName + ' (n=' + n + ')', 8, 8);

            syncValues();

            if (running && state.animate !== false) {
                time += 16;
            } else {
                p.noLoop();
            }
        };

        function syncValues() {
            var mode = getMode();
            var modeName = mode === 'string' ? 'Fixed String' : mode === 'open' ? 'Open Pipe' : 'Closed Pipe';
            setEl('val-mode', modeName);
            setEl('val-harmonic', getHarmonic().toString());
            setEl('val-length', getLength().toFixed(2) + ' m');
            setEl('val-wavelength', calcWavelength().toFixed(3) + ' m');
            setEl('val-frequency', calcFrequency().toFixed(1) + ' Hz');
            setEl('val-speed', getSpeed() + ' m/s');
            setEl('val-nodes', nodesCount().toString());
            setEl('val-antinodes', antinodesCount().toString());
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._play = function () { running = true; p.loop(); };
        state._pause = function () { running = false; };
        state._reset = function () { time = 0; running = true; p.loop(); };
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('standing-waves', standingWaveViz);
})();
