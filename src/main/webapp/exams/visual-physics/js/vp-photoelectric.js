/**
 * Visual Physics — Photoelectric Effect Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function photoelectricViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = false;
        var photons = [];
        var electrons = [];
        var h = 6.626e-34;
        var c = 3e8;
        var eV = 1.602e-19;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getWavelength() { return state.wavelength || 400; }
        function getIntensity() { return state.intensity || 5; }
        function getWorkFunction() { return state.workFunction || 2.1; }
        function getStoppingV() { return state.stoppingVoltage || 0; }

        function photonEnergy() {
            return h * c / (getWavelength() * 1e-9) / eV; // in eV
        }

        function maxKE() {
            return Math.max(0, photonEnergy() - getWorkFunction());
        }

        function emitted() {
            return photonEnergy() >= getWorkFunction();
        }

        function thresholdFreq() {
            return getWorkFunction() * eV / h;
        }

        function thresholdWavelength() {
            return c / thresholdFreq() * 1e9;
        }

        function wavelengthToColor(wl) {
            // Approximate visible spectrum
            if (wl < 380) return [100, 0, 200];
            if (wl < 440) return [100 + (440 - wl) * 1.5, 0, 255];
            if (wl < 490) return [0, Math.floor((wl - 440) * 5.1), 255];
            if (wl < 510) return [0, 255, Math.floor((510 - wl) * 12.75)];
            if (wl < 580) return [Math.floor((wl - 510) * 3.64), 255, 0];
            if (wl < 645) return [255, Math.floor((645 - wl) * 3.92), 0];
            if (wl <= 780) return [255, 0, 0];
            return [200, 0, 0];
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var wl = getWavelength();
            var intensity = getIntensity();
            var phi = getWorkFunction();
            var emit = emitted();
            var col = wavelengthToColor(wl);

            // Metal plate
            var plateX = W * 0.55;
            var plateY1 = H * 0.15, plateY2 = H * 0.85;
            p.fill(120, 120, 140); p.stroke(C.text); p.strokeWeight(1);
            p.rect(plateX, plateY1, 20, plateY2 - plateY1, 2);
            p.fill(C.text); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text(state.material || 'Cesium', plateX + 10, plateY2 + 5);

            // Photon beam
            if (state.showPhotons !== false && running) {
                // Emit photons
                if (p.frameCount % Math.max(1, 6 - intensity) === 0) {
                    photons.push({ x: 30, y: H * 0.3 + Math.random() * H * 0.4, vx: 4 + Math.random() * 2 });
                }

                // Draw and move photons
                p.fill(col[0], col[1], col[2]); p.noStroke();
                for (var i = photons.length - 1; i >= 0; i--) {
                    var ph = photons[i];
                    ph.x += ph.vx;
                    // Wavy photon
                    var py = ph.y + Math.sin(ph.x * 0.1) * 3;
                    p.ellipse(ph.x, py, 6, 6);
                    // Trail
                    p.stroke(col[0], col[1], col[2], 60); p.strokeWeight(1);
                    p.line(ph.x - 10, py + Math.sin((ph.x - 10) * 0.1) * 3, ph.x, py);
                    p.noStroke();

                    if (ph.x > plateX) {
                        photons.splice(i, 1);
                        // Emit electron if energy sufficient
                        if (emit) {
                            var ke = maxKE();
                            var stopV = getStoppingV();
                            if (ke > stopV) {
                                electrons.push({
                                    x: plateX + 25,
                                    y: ph.y + (Math.random() - 0.5) * 20,
                                    vx: 2 + Math.random() * ke,
                                    vy: (Math.random() - 0.5) * 3,
                                    life: 60
                                });
                            }
                        }
                    }
                }
            }

            // Electrons
            p.fill(59, 130, 246); p.noStroke();
            for (var j = electrons.length - 1; j >= 0; j--) {
                var el = electrons[j];
                el.x += el.vx;
                el.y += el.vy;
                el.life--;
                p.ellipse(el.x, el.y, 5, 5);
                if (el.life <= 0 || el.x > W) electrons.splice(j, 1);
            }

            // Light source label
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.rect(10, H * 0.4, 15, H * 0.2, 3);
            p.fill(C.text); p.textSize(9); p.textAlign(p.LEFT, p.TOP);
            p.text(wl + 'nm', 10, H * 0.4 - 12);

            // Energy diagram
            if (state.showEnergyDiagram) {
                var diagX = W * 0.08, diagY = H * 0.1, diagH = H * 0.3;
                p.stroke(C.axis); p.strokeWeight(1);
                p.line(diagX, diagY, diagX, diagY + diagH);
                p.line(diagX - 5, diagY + diagH, diagX + 50, diagY + diagH);

                var ePhoton = photonEnergy();
                var ePhi = phi;
                var eScale = diagH / Math.max(ePhoton, ePhi, 5);

                // Photon energy bar
                p.fill(col[0], col[1], col[2], 150); p.noStroke();
                p.rect(diagX + 5, diagY + diagH - ePhoton * eScale, 15, ePhoton * eScale);

                // Work function line
                p.stroke(239, 68, 68); p.strokeWeight(1.5);
                p.drawingContext.setLineDash([4, 3]);
                p.line(diagX, diagY + diagH - ePhi * eScale, diagX + 50, diagY + diagH - ePhi * eScale);
                p.drawingContext.setLineDash([]);

                p.fill(C.text); p.noStroke(); p.textSize(8);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('E=' + ePhoton.toFixed(2) + 'eV', diagX + 25, diagY + diagH - ePhoton * eScale);
                p.text('\u03C6=' + ePhi.toFixed(1) + 'eV', diagX + 25, diagY + diagH - ePhi * eScale);
            }

            // KE vs f graph
            if (state.showGraph) {
                var gx = W * 0.08, gy = H * 0.65, gw2 = W * 0.35, gh = H * 0.25;
                p.stroke(C.axis); p.strokeWeight(1);
                p.line(gx, gy, gx, gy + gh);
                p.line(gx, gy + gh, gx + gw2, gy + gh);

                p.fill(C.muted); p.noStroke(); p.textSize(8);
                p.textAlign(p.CENTER, p.TOP);
                p.text('f (Hz)', gx + gw2 / 2, gy + gh + 3);
                p.textAlign(p.RIGHT, p.CENTER);
                p.text('KE', gx - 3, gy + gh / 2);

                // Plot KE = hf - phi line
                p.stroke(59, 130, 246); p.strokeWeight(1.5); p.noFill();
                var fMax = 2e15;
                var keMax = 6;
                var f0 = thresholdFreq();
                p.beginShape();
                for (var f = f0; f < fMax; f += fMax / 100) {
                    var ke = (h * f / eV) - phi;
                    var px = gx + (f / fMax) * gw2;
                    var py2 = gy + gh - (ke / keMax) * gh;
                    p.vertex(px, py2);
                }
                p.endShape();

                // Current point
                var curF = c / (wl * 1e-9);
                var curKE = maxKE();
                var cpx = gx + (curF / fMax) * gw2;
                var cpy = gy + gh - (curKE / keMax) * gh;
                p.fill(239, 68, 68); p.noStroke();
                p.ellipse(cpx, Math.min(cpy, gy + gh), 6, 6);
            }

            // Emission status
            p.fill(emit ? [34, 197, 94] : [239, 68, 68]); p.noStroke();
            p.textSize(13); p.textAlign(p.RIGHT, p.TOP);
            p.text(emit ? 'Electrons emitted!' : 'No emission (E < \u03C6)', W - 10, 10);

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Photoelectric Effect', 8, 8);

            syncValues();

            if (running) {
                time++;
            } else {
                p.noLoop();
            }
        };

        function syncValues() {
            var wl = getWavelength();
            var freq = c / (wl * 1e-9);
            setEl('val-wavelength', wl + ' nm');
            setEl('val-frequency', (freq / 1e14).toFixed(2) + ' \u00D7 10\u00B9\u2074 Hz');
            setEl('val-photonenergy', photonEnergy().toFixed(3) + ' eV');
            setEl('val-material', state.material || 'Cesium');
            setEl('val-workfunction', getWorkFunction().toFixed(1) + ' eV');
            setEl('val-threshfreq', (thresholdFreq() / 1e14).toFixed(2) + ' \u00D7 10\u00B9\u2074 Hz');
            setEl('val-threshwl', thresholdWavelength().toFixed(0) + ' nm');
            setEl('val-maxke', maxKE().toFixed(3) + ' eV');
            setEl('val-stoppingv', getStoppingV().toFixed(1) + ' V');
            setEl('val-emitted', emitted() ? 'Yes' : 'No');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._shine = function () { running = true; photons = []; electrons = []; time = 0; p.loop(); };
        state._reset = function () { running = false; photons = []; electrons = []; time = 0; p.loop(); };
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('photoelectric', photoelectricViz);
})();
