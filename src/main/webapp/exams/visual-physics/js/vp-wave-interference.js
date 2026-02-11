/**
 * Visual Physics — Wave Interference Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function waveViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = true;
        var res = 3; // pixel resolution (lower = more detail, higher = faster)
        var source1, source2;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
            // Reduce resolution on mobile
            res = W < 500 ? 5 : 3;
            source1 = { x: W * 0.4, y: H / 2 };
            source2 = { x: W * 0.6, y: H / 2 };
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.pixelDensity(1);
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getFreq() { return state.frequency || 4; }
        function getSep() { return state.separation || 100; }
        function getPhase() { return state.phaseDiff || 0; }
        function getSpeed() { return 120; } // pixels/s

        p.draw = function () {
            var C = VisualMath.palette();
            var isDark = VisualMath.isDark();

            // Update source positions based on separation
            var sep = getSep();
            source1.x = W / 2 - sep / 2;
            source2.x = W / 2 + sep / 2;

            var freq = getFreq();
            var speed = getSpeed();
            var wavelength = speed / freq;
            var omega = 2 * Math.PI * freq;
            var k = 2 * Math.PI / wavelength;
            var phaseDiff = getPhase();

            // Pixel-level rendering for interference pattern
            p.loadPixels();
            for (var y = 0; y < H; y += res) {
                for (var x = 0; x < W; x += res) {
                    var d1 = Math.sqrt((x - source1.x) * (x - source1.x) + (y - source1.y) * (y - source1.y));
                    var d2 = Math.sqrt((x - source2.x) * (x - source2.x) + (y - source2.y) * (y - source2.y));

                    // Wave amplitude from each source (with decay)
                    var amp1 = Math.sin(k * d1 - omega * time) / Math.max(1, Math.sqrt(d1) * 0.1);
                    var amp2 = Math.sin(k * d2 - omega * time + phaseDiff) / Math.max(1, Math.sqrt(d2) * 0.1);

                    var totalAmp = amp1 + amp2;
                    var intensity = totalAmp * totalAmp * 0.25;
                    intensity = Math.min(1, intensity);

                    var r, g, b;
                    if (isDark) {
                        r = Math.floor(15 + intensity * 100);
                        g = Math.floor(23 + intensity * 140);
                        b = Math.floor(42 + intensity * 200);
                    } else {
                        r = Math.floor(255 - intensity * 200);
                        g = Math.floor(255 - intensity * 180);
                        b = Math.floor(255 - intensity * 100);
                    }

                    // Fill pixel block
                    for (var dy = 0; dy < res && y + dy < H; dy++) {
                        for (var dx = 0; dx < res && x + dx < W; dx++) {
                            var idx = 4 * ((y + dy) * W + (x + dx));
                            p.pixels[idx] = r;
                            p.pixels[idx + 1] = g;
                            p.pixels[idx + 2] = b;
                            p.pixels[idx + 3] = 255;
                        }
                    }
                }
            }
            p.updatePixels();

            // Draw wavefront circles (optional)
            if (state.showWavefronts) {
                p.noFill(); p.strokeWeight(0.5);
                var maxR = Math.max(W, H);
                for (var r2 = wavelength; r2 < maxR; r2 += wavelength) {
                    p.stroke(isDark ? 'rgba(255,255,255,0.15)' : 'rgba(0,0,0,0.1)');
                    p.ellipse(source1.x, source1.y, r2 * 2, r2 * 2);
                    p.ellipse(source2.x, source2.y, r2 * 2, r2 * 2);
                }
            }

            // Draw nodal lines (optional)
            if (state.showNodalLines) {
                p.stroke(239, 68, 68, 80); p.strokeWeight(1);
                for (var ny = 0; ny < H; ny += 2) {
                    for (var nx = 0; nx < W; nx += 2) {
                        var dd1 = Math.sqrt((nx - source1.x) * (nx - source1.x) + (ny - source1.y) * (ny - source1.y));
                        var dd2 = Math.sqrt((nx - source2.x) * (nx - source2.x) + (ny - source2.y) * (ny - source2.y));
                        var pathDiff = Math.abs(dd1 - dd2);
                        var halfWavelengths = pathDiff / (wavelength / 2);
                        var frac = halfWavelengths - Math.floor(halfWavelengths);
                        if (Math.abs(frac - 0.5) < 0.05) {
                            p.point(nx, ny);
                        }
                    }
                }
            }

            // Source markers
            p.fill(239, 68, 68); p.stroke(255); p.strokeWeight(2);
            p.ellipse(source1.x, source1.y, 12, 12);
            p.ellipse(source2.x, source2.y, 12, 12);
            p.fill(255); p.noStroke(); p.textSize(8);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('S1', source1.x, source1.y);
            p.text('S2', source2.x, source2.y);

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Wave Interference', 8, 8);

            syncValues(freq, wavelength, speed, sep, phaseDiff);

            if (running) {
                time += 0.016;
            } else {
                p.noLoop();
            }
        };

        function syncValues(freq, wavelength, speed, sep, phaseDiff) {
            setEl('val-frequency', freq.toFixed(1) + ' Hz');
            setEl('val-wavelength', wavelength.toFixed(1) + ' px');
            setEl('val-speed', speed + ' px/s');
            setEl('val-separation', sep.toFixed(0) + ' px');
            setEl('val-phaseDiff', (phaseDiff * 180 / Math.PI).toFixed(0) + '\u00B0');

            // Count maxima (approximate)
            var maxima = Math.floor(sep / wavelength) + 1;
            setEl('val-maxima', maxima.toString());
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._play = function () { running = true; p.loop(); };
        state._pause = function () { running = false; };
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('wave-interference', waveViz);
})();
