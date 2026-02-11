/**
 * Visual Physics — Doppler Effect Simulator
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function dopplerViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var time = 0;
        var running = true;
        var wavefronts = [];
        var emitInterval = 0;
        var lastEmit = 0;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(500, W * 0.55));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getVs() { return state.sourceSpeed || 0; }
        function getVo() { return state.observerSpeed || 0; }
        function getF0() { return state.sourceFreq || 700; }
        function getV() { return state.waveSpeed || 340; }

        function calcApproach() {
            var v = getV(), vs = getVs(), vo = getVo(), f0 = getF0();
            if (v - vs <= 0) return Infinity;
            return f0 * (v + vo) / (v - vs);
        }
        function calcRecede() {
            var v = getV(), vs = getVs(), vo = getVo(), f0 = getF0();
            return f0 * (v - vo) / (v + vs);
        }
        function getMach() { return getVs() / getV(); }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var vs = getVs(), v = getV(), f0 = getF0();
            var mach = getMach();
            var supersonic = mach >= 1;

            // Source position (moves left to right)
            var sourceX = W * 0.2 + (time * vs * 0.3) % (W * 0.6);
            var sourceY = H / 2;

            // Emit wavefronts
            emitInterval = 1 / f0 * 60; // frames between emissions
            if (time - lastEmit > emitInterval || wavefronts.length === 0) {
                wavefronts.push({ x: sourceX, y: sourceY, r: 0, born: time });
                lastEmit = time;
                if (wavefronts.length > 80) wavefronts.shift();
            }

            // Draw wavefronts
            if (state.showWavefronts !== false) {
                p.noFill();
                for (var i = 0; i < wavefronts.length; i++) {
                    var wf = wavefronts[i];
                    var age = time - wf.born;
                    var r = age * v * 0.3;
                    if (r > Math.max(W, H)) continue;
                    var alpha = Math.max(10, 120 - age * 2);
                    var isDark = VisualMath.isDark();
                    p.stroke(isDark ? 'rgba(99,102,241,' + (alpha / 255) + ')' : 'rgba(59,130,246,' + (alpha / 255) + ')');
                    p.strokeWeight(1);
                    p.ellipse(wf.x, wf.y, r * 2, r * 2);
                }
            }

            // Mach cone
            if (state.showMachCone && supersonic) {
                var coneAngle = Math.asin(1 / mach);
                p.stroke(239, 68, 68, 120); p.strokeWeight(1.5);
                var lineLen = W;
                p.line(sourceX, sourceY,
                    sourceX - lineLen * Math.cos(coneAngle), sourceY - lineLen * Math.sin(coneAngle));
                p.line(sourceX, sourceY,
                    sourceX - lineLen * Math.cos(coneAngle), sourceY + lineLen * Math.sin(coneAngle));

                p.fill(239, 68, 68); p.noStroke(); p.textSize(10);
                p.textAlign(p.LEFT, p.BOTTOM);
                p.text('Mach cone \u03B1=' + (coneAngle * 180 / Math.PI).toFixed(1) + '\u00B0', sourceX + 10, sourceY - 20);
            }

            // Source
            p.fill(239, 68, 68); p.stroke(255); p.strokeWeight(2);
            p.ellipse(sourceX, sourceY, 18, 18);
            p.fill(255); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.CENTER);
            p.text('S', sourceX, sourceY);

            // Observer
            var obsX = W * 0.85;
            var obsY = H / 2;
            p.fill(59, 130, 246); p.stroke(255); p.strokeWeight(2);
            p.rect(obsX - 10, obsY - 10, 20, 20, 3);
            p.fill(255); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.CENTER);
            p.text('O', obsX, obsY);

            // Velocity arrow for source
            if (vs > 0) {
                p.stroke(239, 68, 68); p.strokeWeight(2);
                var arrLen = Math.min(60, vs * 0.5);
                p.line(sourceX + 15, sourceY - 20, sourceX + 15 + arrLen, sourceY - 20);
                drawArrow(p, sourceX + 15, sourceY - 20, sourceX + 15 + arrLen, sourceY - 20, [239, 68, 68]);
                p.fill(C.text); p.noStroke(); p.textSize(9); p.textAlign(p.LEFT, p.BOTTOM);
                p.text('v\u209B=' + vs + ' m/s', sourceX + 20, sourceY - 25);
            }

            // Frequency spectrum
            if (state.showSpectrum) {
                var specY = H - 60;
                var specW = W * 0.6;
                var specX = W * 0.2;
                p.stroke(C.grid); p.strokeWeight(1);
                p.line(specX, specY, specX + specW, specY);

                // f0 marker
                var fNorm = 0.5; // f0 at center
                p.stroke(C.muted); p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(specX + fNorm * specW, specY - 30, specX + fNorm * specW, specY + 5);
                p.drawingContext.setLineDash([]);
                p.fill(C.muted); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                p.text('f\u2080', specX + fNorm * specW, specY + 6);

                // Approach freq
                var fa = calcApproach();
                if (fa < Infinity) {
                    var faNorm = Math.min(0.95, 0.5 * fa / f0);
                    p.stroke(239, 68, 68); p.strokeWeight(2);
                    p.line(specX + faNorm * specW, specY - 25, specX + faNorm * specW, specY);
                    p.fill(239, 68, 68); p.noStroke(); p.textSize(8);
                    p.text('f\u2090', specX + faNorm * specW, specY + 6);
                }

                // Recede freq
                var fr = calcRecede();
                var frNorm = Math.max(0.05, 0.5 * fr / f0);
                p.stroke(59, 130, 246); p.strokeWeight(2);
                p.line(specX + frNorm * specW, specY - 25, specX + frNorm * specW, specY);
                p.fill(59, 130, 246); p.noStroke(); p.textSize(8);
                p.text('f\u1D63', specX + frNorm * specW, specY + 6);
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            p.text('Doppler Effect', 8, 8);

            syncValues();

            if (running) {
                time += 1;
            } else {
                p.noLoop();
            }
        };

        function drawArrow(p, x1, y1, x2, y2, col) {
            var angle = Math.atan2(y2 - y1, x2 - x1);
            var len = 6;
            p.fill(col[0], col[1], col[2]); p.noStroke();
            p.triangle(
                x2, y2,
                x2 - len * Math.cos(angle - 0.4), y2 - len * Math.sin(angle - 0.4),
                x2 - len * Math.cos(angle + 0.4), y2 - len * Math.sin(angle + 0.4)
            );
        }

        function syncValues() {
            var f0 = getF0(), vs = getVs(), vo = getVo(), v = getV();
            setEl('val-f0', f0 + ' Hz');
            setEl('val-vs', vs + ' m/s');
            setEl('val-vo', vo + ' m/s');
            setEl('val-v', v + ' m/s');
            var fa = calcApproach();
            setEl('val-fapproach', fa < 10000 ? fa.toFixed(1) + ' Hz' : '\u221E (shock)');
            setEl('val-frecede', calcRecede().toFixed(1) + ' Hz');
            setEl('val-mach', getMach().toFixed(3));
            setEl('val-lambdaApproach', fa < 10000 ? (v / fa).toFixed(4) + ' m' : '0');
            setEl('val-lambdaRecede', (v / calcRecede()).toFixed(4) + ' m');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._play = function () { running = true; wavefronts = []; time = 0; p.loop(); };
        state._pause = function () { running = false; };
        state._redraw = function () { wavefronts = []; time = 0; p.loop(); };
    }

    VisualMath.register('doppler-effect', dopplerViz);
})();
