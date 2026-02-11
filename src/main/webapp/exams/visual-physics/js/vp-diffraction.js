/**
 * Visual Physics — Diffraction Patterns Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function diffractionViz(p, container) {
        var state = VisualMath.getState();
        var W, H;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.pixelDensity(1);
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); state._redraw(); };

        function getMode() { return state.mode || 'single'; }
        function getSlitWidth() { return (state.slitWidth || 10) * 1e-6; }
        function getSlitSep() { return (state.slitSep || 25) * 1e-6; }
        function getWavelength() { return (state.wavelength || 550) * 1e-9; }
        function getNumSlits() { return state.numSlits || 2; }

        function wavelengthToColor(wl_nm) {
            if (wl_nm < 380) return [100, 0, 200];
            if (wl_nm < 440) return [100 + (440 - wl_nm) * 1.5, 0, 255];
            if (wl_nm < 490) return [0, Math.floor((wl_nm - 440) * 5.1), 255];
            if (wl_nm < 510) return [0, 255, Math.floor((510 - wl_nm) * 12.75)];
            if (wl_nm < 580) return [Math.floor((wl_nm - 510) * 3.64), 255, 0];
            if (wl_nm < 645) return [255, Math.floor((645 - wl_nm) * 3.92), 0];
            if (wl_nm <= 780) return [255, 0, 0];
            return [200, 0, 0];
        }

        function singleSlitIntensity(theta) {
            var a = getSlitWidth(), lam = getWavelength();
            var beta = Math.PI * a * Math.sin(theta) / lam;
            if (Math.abs(beta) < 1e-10) return 1;
            var sinc = Math.sin(beta) / beta;
            return sinc * sinc;
        }

        function doubleSlitIntensity(theta) {
            var d = getSlitSep(), lam = getWavelength();
            var delta = Math.PI * d * Math.sin(theta) / lam;
            var cosSquared = Math.cos(delta) * Math.cos(delta);
            return singleSlitIntensity(theta) * cosSquared;
        }

        function gratingIntensity(theta) {
            var d = getSlitSep(), lam = getWavelength(), N = getNumSlits();
            var delta = Math.PI * d * Math.sin(theta) / lam;
            var sinNd = Math.sin(N * delta);
            var sinD = Math.sin(delta);
            var multi;
            if (Math.abs(sinD) < 1e-10) {
                multi = N * N;
            } else {
                multi = (sinNd / sinD) * (sinNd / sinD);
            }
            return singleSlitIntensity(theta) * multi / (N * N);
        }

        function getIntensity(theta) {
            var mode = getMode();
            if (mode === 'single') return singleSlitIntensity(theta);
            if (mode === 'double') return doubleSlitIntensity(theta);
            if (mode === 'grating') return gratingIntensity(theta);
            return 0;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            var isDark = VisualMath.isDark();
            p.background(C.bg);

            var wl_nm = state.wavelength || 550;
            var col = wavelengthToColor(wl_nm);

            // Pattern area
            var patternY = 0;
            var patternH = H * 0.6;
            var screenX = W * 0.6;
            var screenW = W * 0.35;

            // Draw slit barrier
            var barrierX = W * 0.3;
            p.fill(isDark ? 60 : 180); p.noStroke();
            p.rect(barrierX - 3, 0, 6, H * 0.6);

            // Slit openings
            var slitPixels = 8;
            var mode = getMode();
            p.fill(C.bg);
            if (mode === 'single') {
                p.rect(barrierX - 3, patternH / 2 - slitPixels / 2, 6, slitPixels);
            } else {
                var sepPixels = 20;
                p.rect(barrierX - 3, patternH / 2 - sepPixels / 2 - slitPixels / 2, 6, slitPixels);
                p.rect(barrierX - 3, patternH / 2 + sepPixels / 2 - slitPixels / 2, 6, slitPixels);
            }

            // Incoming wave lines
            p.stroke(col[0], col[1], col[2], 60); p.strokeWeight(1);
            for (var wx = 10; wx < barrierX - 10; wx += 15) {
                p.line(wx, patternY + 10, wx, patternH - 10);
            }

            // Diffraction pattern on screen
            var maxAngle = 0.15;
            var res = 2;

            if (state.showColor !== false) {
                p.loadPixels();
                for (var y = 0; y < patternH; y += res) {
                    var theta = (y - patternH / 2) / patternH * maxAngle * 2;
                    var I = getIntensity(theta);
                    I = Math.min(1, I);
                    for (var x = Math.floor(screenX); x < Math.floor(screenX + screenW); x += res) {
                        var r = Math.floor(col[0] * I);
                        var g = Math.floor(col[1] * I);
                        var b = Math.floor(col[2] * I);
                        if (isDark) {
                            r = Math.floor(I * col[0]);
                            g = Math.floor(I * col[1]);
                            b = Math.floor(I * col[2]);
                        }
                        for (var dy = 0; dy < res && y + dy < patternH; dy++) {
                            for (var dx = 0; dx < res && x + dx < W; dx++) {
                                var idx = 4 * ((y + dy) * W + (x + dx));
                                p.pixels[idx] = r; p.pixels[idx + 1] = g;
                                p.pixels[idx + 2] = b; p.pixels[idx + 3] = 255;
                            }
                        }
                    }
                }
                p.updatePixels();
            }

            // Intensity graph
            if (state.showIntensity !== false) {
                var graphY = patternH + 20;
                var graphH = H - graphY - 20;
                var graphW = W - 40;
                var gx = 20;

                // Axes
                p.stroke(C.axis); p.strokeWeight(1);
                p.line(gx, graphY, gx, graphY + graphH);
                p.line(gx, graphY + graphH, gx + graphW, graphY + graphH);

                p.fill(C.muted); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER, p.TOP);
                p.text('sin\u03B8', gx + graphW / 2, graphY + graphH + 3);
                p.textAlign(p.RIGHT, p.CENTER);
                p.text('I/I\u2080', gx - 3, graphY + graphH / 2);

                // Plot
                p.stroke(col[0], col[1], col[2]); p.strokeWeight(1.5); p.noFill();
                p.beginShape();
                for (var px = 0; px < graphW; px++) {
                    var sinTheta = (px / graphW - 0.5) * maxAngle * 2;
                    var theta2 = Math.asin(Math.min(1, Math.abs(sinTheta))) * (sinTheta < 0 ? -1 : 1);
                    var I2 = getIntensity(theta2);
                    I2 = Math.min(1, I2);
                    p.vertex(gx + px, graphY + graphH - I2 * graphH * 0.9);
                }
                p.endShape();
            }

            // Angle markers
            if (state.showAngles) {
                p.fill(C.text); p.noStroke(); p.textSize(8);
                p.textAlign(p.CENTER, p.CENTER);
                var lam = getWavelength();
                var a = getSlitWidth();
                for (var m = 1; m <= 3; m++) {
                    var sinTh = m * lam / a;
                    if (sinTh > 1) break;
                    var angle = Math.asin(sinTh) * 180 / Math.PI;
                    var yPos = patternH / 2 + sinTh / (maxAngle * 2) * patternH;
                    var yNeg = patternH / 2 - sinTh / (maxAngle * 2) * patternH;
                    p.text('m=' + m, screenX - 15, yPos);
                    p.text('m=-' + m, screenX - 15, yNeg);
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var modeNames = { single: 'Single Slit', double: 'Double Slit', grating: 'Grating' };
            p.text('Diffraction \u2014 ' + (modeNames[mode] || mode), 8, 8);

            syncValues();
        };

        function syncValues() {
            var mode = getMode();
            var modeNames = { single: 'Single Slit', double: 'Double Slit', grating: 'Grating' };
            var wl = getWavelength();
            var a = getSlitWidth();
            var d = getSlitSep();

            setEl('val-mode', modeNames[mode] || mode);
            setEl('val-slitwidth', (a * 1e6).toFixed(1) + ' \u03BCm');
            setEl('val-slitsep', (d * 1e6).toFixed(1) + ' \u03BCm');
            setEl('val-wavelength', (wl * 1e9).toFixed(0) + ' nm');

            // Central max width (for single slit)
            var centralWidth = 2 * Math.asin(wl / a) * 180 / Math.PI;
            setEl('val-centralmax', isNaN(centralWidth) ? 'N/A' : centralWidth.toFixed(2) + '\u00B0');

            // 1st minimum angle
            var firstMin = Math.asin(Math.min(1, wl / a)) * 180 / Math.PI;
            setEl('val-firstmin', firstMin.toFixed(2) + '\u00B0');

            // Fringe spacing (double slit)
            if (mode !== 'single') {
                var fringeAngle = Math.asin(Math.min(1, wl / d)) * 180 / Math.PI;
                setEl('val-fringe', fringeAngle.toFixed(3) + '\u00B0');
            } else {
                setEl('val-fringe', 'N/A');
            }

            // Resolving power
            if (mode === 'grating') {
                setEl('val-resolving', (getNumSlits()).toString());
            } else {
                setEl('val-resolving', 'N/A');
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('diffraction', diffractionViz);
})();
