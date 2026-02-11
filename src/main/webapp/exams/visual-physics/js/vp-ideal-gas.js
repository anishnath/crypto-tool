/**
 * Visual Physics — Ideal Gas Law / PV Diagram Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function idealGasViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var animProgress = 0;
        var running = false;
        var R = 8.314;
        var gamma = 5 / 3; // monatomic

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
            p.noLoop();
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); state._redraw(); };

        function getProcess() { return state.process || 'isothermal'; }
        function getMoles() { return state.moles || 1; }
        function getTempInit() { return state.tempInit || 300; }
        function getPressureInit() { return state.pressureInit || 100; }
        function getVolRatio() { return state.volRatio || 2.0; }

        function calcVolInit() {
            return getMoles() * R * getTempInit() / (getPressureInit() * 1000); // m³
        }

        function calcFinalState() {
            var proc = getProcess();
            var n = getMoles(), Ti = getTempInit(), Pi = getPressureInit();
            var Vi = calcVolInit();
            var vr = getVolRatio();
            var Vf = Vi * vr;

            if (proc === 'isothermal') {
                return { T: Ti, P: Pi / vr, V: Vf };
            } else if (proc === 'adiabatic') {
                var Pf = Pi * Math.pow(Vi / Vf, gamma);
                var Tf = Ti * Math.pow(Vi / Vf, gamma - 1);
                return { T: Tf, P: Pf, V: Vf };
            } else if (proc === 'isobaric') {
                var Tf2 = Ti * vr;
                return { T: Tf2, P: Pi, V: Vf };
            } else if (proc === 'isochoric') {
                var Pf2 = Pi * vr; // vr reused as T ratio
                return { T: Ti * vr, P: Pf2, V: Vi };
            }
            return { T: Ti, P: Pi, V: Vi };
        }

        function calcWork() {
            var proc = getProcess();
            var n = getMoles(), Ti = getTempInit(), Pi = getPressureInit();
            var Vi = calcVolInit();
            var vr = getVolRatio();
            var Vf = Vi * vr;

            if (proc === 'isothermal') {
                return n * R * Ti * Math.log(vr);
            } else if (proc === 'adiabatic') {
                var fs = calcFinalState();
                return (Pi * 1000 * Vi - fs.P * 1000 * fs.V) / (gamma - 1);
            } else if (proc === 'isobaric') {
                return Pi * 1000 * (Vf - Vi);
            } else if (proc === 'isochoric') {
                return 0;
            }
            return 0;
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var proc = getProcess();
            var n = getMoles(), Ti = getTempInit(), Pi = getPressureInit();
            var Vi = calcVolInit();
            var vr = getVolRatio();
            var fs = calcFinalState();

            // PV Diagram area
            var pvX = 30, pvY = 30, pvW = W * 0.5 - 40, pvH = H * 0.65;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pvX, pvY, pvX, pvY + pvH);
            p.line(pvX, pvY + pvH, pvX + pvW, pvY + pvH);
            p.fill(C.text); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP);
            p.text('V (m\u00B3)', pvX + pvW / 2, pvY + pvH + 5);
            p.textAlign(p.RIGHT, p.CENTER);
            p.text('P', pvX - 5, pvY + pvH / 2);

            // Scale
            var Pmax = Math.max(Pi, fs.P) * 1.3;
            var Vmax = Math.max(Vi, fs.V) * 1.3;

            function pvToScreen(V, P) {
                return {
                    x: pvX + (V / Vmax) * pvW,
                    y: pvY + pvH - (P / Pmax) * pvH
                };
            }

            // Draw process curve
            p.stroke(C.sin); p.strokeWeight(2.5); p.noFill();
            var steps = 100;
            var curProgress = running ? animProgress : 1;

            p.beginShape();
            for (var i = 0; i <= steps * curProgress; i++) {
                var t = i / steps;
                var Vt, Pt;
                if (proc === 'isothermal') {
                    Vt = Vi * (1 + t * (vr - 1));
                    Pt = n * R * Ti / (Vt * 1000);
                } else if (proc === 'adiabatic') {
                    Vt = Vi * (1 + t * (vr - 1));
                    Pt = Pi * Math.pow(Vi / Vt, gamma);
                } else if (proc === 'isobaric') {
                    Vt = Vi * (1 + t * (vr - 1));
                    Pt = Pi;
                } else { // isochoric
                    Vt = Vi;
                    Pt = Pi * (1 + t * (vr - 1));
                }
                var sp = pvToScreen(Vt, Pt);
                p.vertex(sp.x, sp.y);
            }
            p.endShape();

            // Work area shading
            if (state.showWork && proc !== 'isochoric') {
                p.fill(C.sin[0] || 99, C.sin[1] || 102, C.sin[2] || 241, 30);
                p.noStroke();
                p.beginShape();
                var baseY = pvToScreen(Vi, 0).y;
                p.vertex(pvToScreen(Vi, 0).x, baseY);
                for (var j = 0; j <= steps * curProgress; j++) {
                    var t2 = j / steps;
                    var Vt2, Pt2;
                    if (proc === 'isothermal') {
                        Vt2 = Vi * (1 + t2 * (vr - 1));
                        Pt2 = n * R * Ti / (Vt2 * 1000);
                    } else if (proc === 'adiabatic') {
                        Vt2 = Vi * (1 + t2 * (vr - 1));
                        Pt2 = Pi * Math.pow(Vi / Vt2, gamma);
                    } else {
                        Vt2 = Vi * (1 + t2 * (vr - 1));
                        Pt2 = Pi;
                    }
                    var sp2 = pvToScreen(Vt2, Pt2);
                    p.vertex(sp2.x, sp2.y);
                }
                var lastV = Vi * (1 + curProgress * (vr - 1));
                p.vertex(pvToScreen(lastV, 0).x, baseY);
                p.endShape(p.CLOSE);
            }

            // Start/end markers
            var startPt = pvToScreen(Vi, Pi);
            var endPt = pvToScreen(fs.V, fs.P);
            p.fill(34, 197, 94); p.noStroke();
            p.ellipse(startPt.x, startPt.y, 8, 8);
            p.fill(239, 68, 68);
            p.ellipse(endPt.x, endPt.y, 8, 8);

            // Piston/container animation
            var pistonX = W * 0.6, pistonY = H * 0.1;
            var containerW = W * 0.32, containerH = H * 0.5;
            var pistonPos = 0.3 + curProgress * 0.4 * (vr > 1 ? 1 : -1);
            pistonPos = Math.max(0.2, Math.min(0.8, pistonPos));

            // Container
            p.stroke(C.text); p.strokeWeight(2); p.noFill();
            p.line(pistonX, pistonY, pistonX, pistonY + containerH);
            p.line(pistonX, pistonY + containerH, pistonX + containerW, pistonY + containerH);
            p.line(pistonX + containerW, pistonY, pistonX + containerW, pistonY + containerH);

            // Piston
            var pistonPixelY = pistonY + pistonPos * containerH * 0.3;
            p.fill(120, 120, 140); p.stroke(C.text); p.strokeWeight(1);
            p.rect(pistonX + 2, pistonPixelY, containerW - 4, 8, 2);

            // Molecules
            if (state.showMolecules) {
                var gasArea = containerH - (pistonPixelY - pistonY + 10);
                var numMols = Math.floor(n * 8);
                p.fill(59, 130, 246); p.noStroke();
                for (var mi = 0; mi < numMols; mi++) {
                    var mx = pistonX + 10 + ((mi * 37 + time_hash(mi)) % (containerW - 20));
                    var my = pistonPixelY + 15 + ((mi * 53 + time_hash(mi + 100)) % Math.max(10, gasArea));
                    p.ellipse(mx, my, 4, 4);
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var procNames = { isothermal: 'Isothermal', adiabatic: 'Adiabatic', isobaric: 'Isobaric', isochoric: 'Isochoric' };
            p.text('Ideal Gas \u2014 ' + (procNames[proc] || proc), 8, 8);

            syncValues();

            if (running) {
                animProgress = Math.min(1, animProgress + 0.01);
                if (animProgress >= 1) { running = false; p.noLoop(); }
            } else {
                p.noLoop();
            }
        };

        function time_hash(seed) {
            return Math.abs(Math.sin(seed * 12.9898) * 43758.5453) % 1000;
        }

        function syncValues() {
            var proc = getProcess();
            var procNames = { isothermal: 'Isothermal', adiabatic: 'Adiabatic', isobaric: 'Isobaric', isochoric: 'Isochoric' };
            var fs = calcFinalState();
            var W2 = calcWork();
            var n = getMoles(), Ti = getTempInit();
            var dU = n * (3 / 2) * R * (fs.T - Ti);
            var Q = dU + W2;

            setEl('val-process', procNames[proc] || proc);
            setEl('val-n', getMoles().toFixed(1) + ' mol');
            setEl('val-tinit', getTempInit().toFixed(0) + ' K');
            setEl('val-tfinal', fs.T.toFixed(1) + ' K');
            setEl('val-pinit', getPressureInit().toFixed(0) + ' kPa');
            setEl('val-pfinal', fs.P.toFixed(1) + ' kPa');
            setEl('val-vinit', (calcVolInit() * 1000).toFixed(2) + ' L');
            setEl('val-vfinal', (fs.V * 1000).toFixed(2) + ' L');
            setEl('val-work', W2.toFixed(1) + ' J');
            setEl('val-heat', Q.toFixed(1) + ' J');
            setEl('val-du', dU.toFixed(1) + ' J');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._run = function () { animProgress = 0; running = true; p.loop(); };
        state._reset = function () { animProgress = 0; running = false; p.loop(); };
        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('ideal-gas', idealGasViz);
})();
