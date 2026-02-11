/**
 * Visual Physics — Lens & Mirror Ray Diagram
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function lensViz(p, container) {
        var state = VisualMath.getState();
        var W, H, pad = 40;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(480, W * 0.5));
        }

        p.setup = function () { layout(); p.createCanvas(W, H); };
        p.windowResized = function () { layout(); p.resizeCanvas(W, H); };

        function getType() { return state.lensType || 'convex-lens'; }
        function getU() { return state.objectDist || 30; }
        function getF() { return state.focalLength || 15; }
        function getObjH() { return state.objectHeight || 2; }

        function calcImage() {
            var type = getType();
            var u = getU();
            var f = getF();
            var v, m;

            if (type === 'convex-lens') {
                // 1/v - 1/u = 1/f, sign: u negative (left), f positive
                // Using: 1/v = 1/f + 1/(-u) => 1/v = 1/f - 1/u
                if (Math.abs(u - f) < 0.5) return { v: Infinity, m: Infinity, real: false };
                v = (u * f) / (u - f);
                m = v / u;
            } else if (type === 'concave-lens') {
                // f is negative for concave lens
                v = (u * (-f)) / (u - (-f));
                v = -(u * f) / (u + f); // always virtual (negative v)
                m = Math.abs(v) / u;
                if (v > 0) v = -v; // ensure virtual
            } else if (type === 'concave-mirror') {
                // Mirror: 1/v + 1/u = 1/f (all positive for concave)
                if (Math.abs(u - f) < 0.5) return { v: Infinity, m: Infinity, real: false };
                v = (u * f) / (u - f);
                m = -v / u;
            } else {
                // Convex mirror: f negative
                v = (u * f) / (u + f); // always virtual
                m = v / u;
                v = -v; // virtual
            }

            var real = v > 0;
            if (type.includes('mirror')) real = v > 0;
            if (type === 'concave-lens' || type === 'convex-mirror') real = false;

            return { v: v, m: m, real: real };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            var cx = W / 2, cy = H / 2;
            var axisLen = W - pad * 2;
            var isMirror = getType().includes('mirror');
            var scale = (axisLen / 2) / (getU() * 1.8);

            // Principal axis
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, cy, W - pad, cy);

            // Lens or Mirror at center
            drawOptic(p, cx, cy, C);

            // Focal points
            if (state.showFocal !== false) {
                var fDist = getF() * scale;
                p.fill(C.accent); p.noStroke();
                if (!isMirror) {
                    // Lens: F on both sides
                    p.ellipse(cx + fDist, cy, 7, 7);
                    p.ellipse(cx - fDist, cy, 7, 7);
                    // 2F
                    p.ellipse(cx + fDist * 2, cy, 5, 5);
                    p.ellipse(cx - fDist * 2, cy, 5, 5);
                    p.fill(C.muted); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                    p.text('F', cx + fDist, cy + 6);
                    p.text('F', cx - fDist, cy + 6);
                    p.text('2F', cx + fDist * 2, cy + 6);
                    p.text('2F', cx - fDist * 2, cy + 6);
                } else {
                    // Mirror: F on one side (left of mirror for concave, right for convex)
                    var fSide = getType() === 'concave-mirror' ? -1 : 1;
                    p.ellipse(cx + fSide * fDist, cy, 7, 7);
                    p.ellipse(cx + fSide * fDist * 2, cy, 5, 5);
                    p.fill(C.muted); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                    p.text('F', cx + fSide * fDist, cy + 6);
                    p.text('C', cx + fSide * fDist * 2, cy + 6);
                }
            }

            // Object arrow (on left)
            var objX = cx - getU() * scale;
            var objTopY = cy - getObjH() * scale * 10;
            p.stroke(C.sin); p.strokeWeight(2.5);
            p.line(objX, cy, objX, objTopY);
            drawTriArrow(p, objX, objTopY, true, C.sin);

            // Rays & Image
            var img = calcImage();
            if (Math.abs(img.v) < 5000) {
                var imgX, imgTopY;
                if (isMirror) {
                    if (img.real) {
                        imgX = cx - img.v * scale;
                    } else {
                        imgX = cx + Math.abs(img.v) * scale;
                    }
                } else {
                    imgX = cx + img.v * scale;
                }
                var imgH = getObjH() * Math.abs(img.m) * scale * 10;
                var inverted = (getType() === 'convex-lens' && getU() > getF()) || getType() === 'concave-mirror';
                imgTopY = inverted ? cy + imgH : cy - imgH;

                // Draw 3 rays
                if (state.showRays !== false) {
                    drawRays(p, cx, cy, objX, objTopY, imgX, imgTopY, scale, C, img.real);
                }

                // Image arrow
                if (state.showImage !== false) {
                    var imgCol = img.real ? C.cos : [C.cos[0], C.cos[1], C.cos[2]];
                    if (!img.real) {
                        p.drawingContext.setLineDash([6, 4]);
                    }
                    p.stroke(imgCol); p.strokeWeight(2.5);
                    p.line(imgX, cy, imgX, imgTopY);
                    drawTriArrow(p, imgX, imgTopY, !inverted, imgCol);
                    p.drawingContext.setLineDash([]);
                }
            }

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var typeNames = { 'convex-lens': 'Convex Lens', 'concave-lens': 'Concave Lens', 'concave-mirror': 'Concave Mirror', 'convex-mirror': 'Convex Mirror' };
            p.text(typeNames[getType()], pad + 4, 8);

            syncValues(img);
            p.noLoop();
        };

        function drawOptic(p, cx, cy, C) {
            var type = getType();
            var halfH = H / 2 - pad - 10;

            if (type === 'convex-lens') {
                p.stroke(C.accent); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var t = -Math.PI / 2; t <= Math.PI / 2; t += 0.05) {
                    p.vertex(cx + 8 * Math.cos(t), cy + halfH * Math.sin(t) / (Math.PI / 2) * t / (Math.PI / 2) + halfH * (t / (Math.PI / 2)));
                }
                p.endShape();
                // Simplified: just draw a double-convex shape
                p.noFill(); p.stroke(C.accent); p.strokeWeight(2);
                p.arc(cx - 6, cy, 20, halfH * 2, -Math.PI / 2, Math.PI / 2);
                p.arc(cx + 6, cy, 20, halfH * 2, Math.PI / 2, 3 * Math.PI / 2);
            } else if (type === 'concave-lens') {
                p.stroke(C.accent); p.strokeWeight(2); p.noFill();
                p.arc(cx + 8, cy, 20, halfH * 2, -Math.PI / 2, Math.PI / 2);
                p.arc(cx - 8, cy, 20, halfH * 2, Math.PI / 2, 3 * Math.PI / 2);
                p.line(cx - 3, cy - halfH, cx + 3, cy - halfH);
                p.line(cx - 3, cy + halfH, cx + 3, cy + halfH);
            } else {
                // Mirrors: curved line
                p.stroke(C.accent); p.strokeWeight(2.5); p.noFill();
                var curveDir = type === 'concave-mirror' ? 1 : -1;
                p.beginShape();
                for (var a = -0.8; a <= 0.8; a += 0.05) {
                    var mx = cx + curveDir * 10 * (1 - Math.cos(a));
                    var my = cy + halfH * Math.sin(a) / 0.8;
                    p.vertex(mx, my);
                }
                p.endShape();
                // Hatching behind mirror
                p.stroke(C.muted); p.strokeWeight(0.5);
                for (var hi = -halfH; hi <= halfH; hi += 8) {
                    p.line(cx + curveDir * 4, cy + hi, cx + curveDir * 12, cy + hi - 5);
                }
            }
        }

        function drawRays(p, cx, cy, objX, objTopY, imgX, imgTopY, scale, C, isReal) {
            var type = getType();
            var fDist = getF() * scale;

            // Ray colors
            var r1 = [239, 68, 68, 200]; // parallel then through F
            var r2 = [59, 130, 246, 200]; // through center
            var r3 = [34, 197, 94, 200]; // through F then parallel

            p.strokeWeight(1.5);

            if (type === 'convex-lens') {
                // Ray 1: parallel to axis -> through F on other side
                p.stroke(r1);
                p.line(objX, objTopY, cx, objTopY);
                if (isReal) {
                    p.line(cx, objTopY, imgX, imgTopY);
                } else {
                    p.drawingContext.setLineDash([4, 4]);
                    p.line(cx, objTopY, cx - (cx - objX) * 2, objTopY + (objTopY - cy) * 0.5);
                    p.drawingContext.setLineDash([]);
                    p.line(cx, objTopY, imgX, imgTopY);
                }

                // Ray 2: through optical center (straight)
                p.stroke(r2);
                p.line(objX, objTopY, imgX, imgTopY);

                // Ray 3: through F on object side -> parallel after lens
                p.stroke(r3);
                p.line(objX, objTopY, cx, cy - (objTopY - cy) * (fDist / (cx - objX - fDist + 0.01)));
                p.line(cx, cy - (objTopY - cy) * (fDist / (cx - objX - fDist + 0.01)), imgX, imgTopY);
            } else if (type === 'concave-lens') {
                // Ray 1: parallel -> diverge as if from F on same side
                p.stroke(r1);
                p.line(objX, objTopY, cx, objTopY);
                p.line(cx, objTopY, W - pad, objTopY + (objTopY - cy) * 0.8);
                p.drawingContext.setLineDash([4, 4]);
                p.line(cx, objTopY, imgX, imgTopY);
                p.drawingContext.setLineDash([]);

                // Ray 2: through center
                p.stroke(r2);
                p.line(objX, objTopY, W - pad, objTopY + (W - pad - objX) * (objTopY - cy) / (cx - objX + 0.01) * -1);

                // Ray 3: toward F on other side -> parallel
                p.stroke(r3);
                p.line(objX, objTopY, cx, cy);
                p.line(cx, cy, W - pad, cy);
            } else {
                // Mirrors: simplified ray diagram
                p.stroke(r1);
                p.line(objX, objTopY, cx, objTopY);
                if (isReal) {
                    p.line(cx, objTopY, imgX, imgTopY);
                } else {
                    p.line(cx, objTopY, objX, objTopY + (cy - objTopY) * 2);
                    p.drawingContext.setLineDash([4, 4]);
                    p.line(cx, objTopY, imgX, imgTopY);
                    p.drawingContext.setLineDash([]);
                }

                p.stroke(r2);
                p.line(objX, objTopY, cx, cy);
                if (isReal) {
                    p.line(cx, cy, imgX, imgTopY);
                }
            }
        }

        function drawTriArrow(p, x, y, up, col) {
            p.fill(col); p.noStroke();
            var d = up ? -1 : 1;
            p.triangle(x, y, x - 5, y + d * 10, x + 5, y + d * 10);
        }

        function syncValues(img) {
            setEl('val-u', getU().toFixed(1) + ' cm');
            setEl('val-f', getF().toFixed(1) + ' cm');
            if (Math.abs(img.v) > 5000) {
                setEl('val-v', '\u221E');
                setEl('val-mag', '\u221E');
                setEl('val-imageType', 'At infinity');
                setEl('val-imageSize', '\u221E');
            } else {
                setEl('val-v', Math.abs(img.v).toFixed(1) + ' cm');
                setEl('val-mag', Math.abs(img.m).toFixed(2) + '\u00D7');
                var type = img.real ? 'Real' : 'Virtual';
                var orient = img.m < 0 ? ', Inverted' : ', Erect';
                if (!img.real) orient = ', Erect';
                setEl('val-imageType', type + orient);
                setEl('val-imageSize', (getObjH() * Math.abs(img.m)).toFixed(2) + ' cm');
            }
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('lens-ray', lensViz);
})();
