/**
 * Visual Math — Unit Circle Explorer
 * Requires: vm-core.js
 */
(function() {
    'use strict';

    var state = null; // set by VisualMath.init

    function unitCircle(p, container) {
        state = VisualMath.getState();
        var W, H, cx, cy, R;
        var waveX, waveW, waveH;
        var angle = Math.PI / 4;
        var dragging = false;
        var animating = false;
        var animSpeed = 0.018;

        function layout() {
            W = container.clientWidth;
            H = Math.max(380, Math.min(480, W * 0.55));
            if (W > 600) {
                cx = W * 0.27;
                cy = H / 2;
                R = Math.min(cx - 50, cy - 40);
                waveX = W * 0.52;
                waveW = W * 0.43;
                waveH = H - 60;
            } else {
                cx = W / 2;
                cy = H * 0.35;
                R = Math.min(W / 2 - 40, cy - 30);
                waveX = 30;
                waveW = W - 60;
                waveH = H * 0.25;
            }
        }

        p.setup = function() {
            layout();
            var c = p.createCanvas(W, H);
            c.mousePressed(onPress);
            c.mouseReleased(onRelease);
            c.touchStarted(onPress);
            c.touchEnded(onRelease);
        };

        p.windowResized = function() {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function() {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (animating) {
                angle += animSpeed;
                if (angle > Math.PI * 2) angle -= Math.PI * 2;
                syncControls();
            }

            if (dragging) {
                var dx = p.mouseX - cx;
                var dy = p.mouseY - cy;
                angle = Math.atan2(-dy, dx);
                if (angle < 0) angle += Math.PI * 2;
                syncControls();
            }

            drawUnitCircle(C);
            if (W > 450) drawWaveGraph(C);
            syncValues();
        };

        // ---- Circle ----

        function drawUnitCircle(C) {
            p.push();
            p.translate(cx, cy);

            // Grid
            p.stroke(C.grid);
            p.strokeWeight(1);
            for (var i = -1; i <= 1; i += 0.5) {
                if (i === 0) continue;
                p.line(-R * 1.25, i * R, R * 1.25, i * R);
                p.line(i * R, -R * 1.25, i * R, R * 1.25);
            }

            // Axes
            p.stroke(C.axis);
            p.strokeWeight(1.5);
            p.line(-R * 1.25, 0, R * 1.3, 0);
            p.line(0, -R * 1.25, 0, R * 1.3);

            // Axis labels
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.CENTER, p.TOP);
            p.text('1', R, 6); p.text('-1', -R, 6);
            p.textAlign(p.LEFT, p.CENTER);
            p.text('1', 6, -R); p.text('-1', 6, R);

            // Special angle dots
            p.fill(C.grid); p.noStroke();
            var specials = [0,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330];
            for (var s = 0; s < specials.length; s++) {
                var sa = specials[s] * Math.PI / 180;
                p.ellipse(Math.cos(sa) * R, -Math.sin(sa) * R, 4, 4);
            }

            // Circle
            p.noFill(); p.stroke(C.circle); p.strokeWeight(2);
            p.ellipse(0, 0, R * 2, R * 2);

            var px = Math.cos(angle) * R;
            var py = -Math.sin(angle) * R;

            // Reference triangle
            p.fill(C.accent[0], C.accent[1], C.accent[2], 20);
            p.noStroke();
            p.triangle(0, 0, px, 0, px, py);

            // Cos line
            if (state.showCos !== false) {
                p.stroke(C.cos); p.strokeWeight(3);
                p.line(0, 0, px, 0);
                p.fill(C.cos); p.noStroke(); p.textSize(11);
                p.textAlign(p.CENTER, p.TOP);
                p.text('cos', px / 2, 6);
            }

            // Sin line
            if (state.showSin !== false) {
                p.stroke(C.sin); p.strokeWeight(3);
                p.line(px, 0, px, py);
                p.fill(C.sin); p.noStroke(); p.textSize(11);
                p.textAlign(px > 0 ? p.LEFT : p.RIGHT, p.CENTER);
                p.text('sin', px + (px >= 0 ? 6 : -6), py / 2);
            }

            // Tan line
            if (state.showTan && Math.abs(Math.cos(angle)) > 0.03) {
                var tanVal = Math.tan(angle);
                var tanY = -tanVal * R;
                tanY = Math.max(-R * 2.5, Math.min(R * 2.5, tanY));
                p.stroke(C.tan); p.strokeWeight(2.5);
                p.line(R, 0, R, tanY);
                p.drawingContext.setLineDash([4, 4]);
                p.stroke(C.tan[0], C.tan[1], C.tan[2], 120);
                p.strokeWeight(1.5);
                p.line(px, py, R, tanY);
                p.drawingContext.setLineDash([]);
                p.fill(C.tan); p.noStroke(); p.textSize(11);
                p.textAlign(p.LEFT, p.CENTER);
                p.text('tan', R + 6, tanY / 2);
            }

            // Radius
            p.stroke(C.text); p.strokeWeight(1.5);
            p.line(0, 0, px, py);

            // Angle arc
            p.noFill(); p.stroke(C.accent); p.strokeWeight(1.5);
            var arcR = R * 0.18;
            if (angle > 0.05) p.arc(0, 0, arcR * 2, arcR * 2, -angle, 0);

            // Angle label
            var mid = angle / 2;
            p.fill(C.accent); p.noStroke(); p.textSize(12);
            p.textAlign(p.CENTER, p.CENTER);
            var deg = Math.round(angle * 180 / Math.PI);
            p.text(deg + '\u00B0', Math.cos(-mid) * (arcR + 16), Math.sin(-mid) * (arcR + 16));

            // Quadrant labels
            var q = getQuadrant(angle);
            p.textSize(10); p.textAlign(p.CENTER, p.CENTER);
            var qPos = [[R*0.6,-R*0.6],[-R*0.6,-R*0.6],[-R*0.6,R*0.6],[R*0.6,R*0.6]];
            for (var qi = 0; qi < 4; qi++) {
                p.fill(qi + 1 === q ? C.accent : C.grid);
                p.text(['I','II','III','IV'][qi], qPos[qi][0], qPos[qi][1]);
            }

            // Point
            p.fill(C.point); p.stroke(C.accent); p.strokeWeight(2);
            p.ellipse(px, py, 14, 14);

            // Coordinate
            p.fill(C.text); p.noStroke(); p.textSize(11);
            p.textAlign(px >= 0 ? p.LEFT : p.RIGHT, p.BOTTOM);
            p.text('(' + Math.cos(angle).toFixed(2) + ', ' + Math.sin(angle).toFixed(2) + ')',
                   px + (px >= 0 ? 12 : -12), py - 10);

            p.pop();
        }

        // ---- Wave Graph ----

        function drawWaveGraph(C) {
            p.push();
            var x0, y0, gw, gh;
            if (W > 600) {
                x0 = waveX; y0 = 30; gw = waveW; gh = waveH;
            } else {
                x0 = waveX; y0 = cy + R + 40; gw = waveW; gh = waveH;
            }
            var midY = y0 + gh / 2;

            // Axes
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(x0, midY, x0 + gw, midY);
            p.line(x0, y0, x0, y0 + gh);

            // Y grid
            p.stroke(C.grid); p.strokeWeight(0.5);
            p.line(x0, y0 + 4, x0 + gw, y0 + 4);
            p.line(x0, y0 + gh - 4, x0 + gw, y0 + gh - 4);

            // X labels
            p.fill(C.muted); p.noStroke(); p.textSize(10);
            p.textAlign(p.CENTER, p.TOP);
            p.text('0', x0, midY + 4);
            p.text('\u03C0', x0 + gw / 2, midY + 4);
            p.text('2\u03C0', x0 + gw, midY + 4);
            p.textAlign(p.RIGHT, p.CENTER);
            p.text('1', x0 - 4, y0 + 4);
            p.text('-1', x0 - 4, y0 + gh - 4);

            var amp = (gh / 2) - 6;

            // Sin wave
            if (state.showSin !== false) {
                p.stroke(C.sin); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var i = 0; i <= gw; i += 2) {
                    p.vertex(x0 + i, midY - Math.sin((i / gw) * Math.PI * 2) * amp);
                }
                p.endShape();
            }

            // Cos wave
            if (state.showCos !== false) {
                p.stroke(C.cos); p.strokeWeight(2); p.noFill();
                p.beginShape();
                for (var j = 0; j <= gw; j += 2) {
                    p.vertex(x0 + j, midY - Math.cos((j / gw) * Math.PI * 2) * amp);
                }
                p.endShape();
            }

            // Position marker
            var markerX = x0 + (angle / (Math.PI * 2)) * gw;
            p.stroke(C.accent[0], C.accent[1], C.accent[2], 80);
            p.strokeWeight(1);
            p.drawingContext.setLineDash([3, 3]);
            p.line(markerX, y0, markerX, y0 + gh);
            p.drawingContext.setLineDash([]);

            if (state.showSin !== false) {
                p.fill(C.sin); p.noStroke();
                p.ellipse(markerX, midY - Math.sin(angle) * amp, 8, 8);
            }
            if (state.showCos !== false) {
                p.fill(C.cos); p.noStroke();
                p.ellipse(markerX, midY - Math.cos(angle) * amp, 8, 8);
            }

            // Title
            p.fill(C.muted); p.noStroke(); p.textSize(11);
            p.textAlign(p.LEFT, p.BOTTOM);
            p.text('f(\u03B8) vs \u03B8', x0, y0 - 4);

            p.pop();
        }

        // ---- Interaction ----

        function onPress() {
            var dx = p.mouseX - cx, dy = p.mouseY - cy;
            if (Math.sqrt(dx * dx + dy * dy) < R * 1.4) {
                dragging = true;
                return false;
            }
        }
        function onRelease() { dragging = false; }
        p.mouseDragged = function() { if (dragging) return false; };
        p.touchMoved = function() { if (dragging) return false; };

        // ---- Controls Sync ----

        function syncControls() {
            var slider = document.getElementById('angle-slider');
            if (slider) {
                var deg = Math.round(angle * 180 / Math.PI);
                slider.value = deg;
                var d = document.getElementById('angle-display');
                if (d) d.textContent = deg + '\u00B0';
            }
        }

        function syncValues() {
            var deg = angle * 180 / Math.PI;
            var sinV = Math.sin(angle);
            var cosV = Math.cos(angle);
            var tanV = Math.abs(Math.cos(angle)) > 0.01 ? Math.tan(angle) : Infinity;

            setEl('val-angle', Math.round(deg) + '\u00B0 (' + toFrac(angle) + ')');
            setEl('val-sin', sinV.toFixed(4));
            setEl('val-cos', cosV.toFixed(4));
            setEl('val-tan', Math.abs(tanV) > 1000 ? 'undefined' : tanV.toFixed(4));
            setEl('val-quadrant', 'Q' + getQuadrant(angle));
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        function toFrac(a) {
            var deg = Math.round(a * 180 / Math.PI);
            var f = {
                0:'0',30:'\u03C0/6',45:'\u03C0/4',60:'\u03C0/3',90:'\u03C0/2',
                120:'2\u03C0/3',135:'3\u03C0/4',150:'5\u03C0/6',180:'\u03C0',
                210:'7\u03C0/6',225:'5\u03C0/4',240:'4\u03C0/3',270:'3\u03C0/2',
                300:'5\u03C0/3',315:'7\u03C0/4',330:'11\u03C0/6',360:'2\u03C0'
            };
            return f[deg] || (a / Math.PI).toFixed(2) + '\u03C0';
        }

        function getQuadrant(a) {
            var d = (a * 180 / Math.PI) % 360;
            if (d < 90) return 1; if (d < 180) return 2;
            if (d < 270) return 3; return 4;
        }

        // External API
        state._setAngle = function(deg) { angle = deg * Math.PI / 180; syncControls(); };
        state._toggleAnim = function() { animating = !animating; return animating; };
        state._isAnimating = function() { return animating; };
    }

    VisualMath.register('unit-circle', unitCircle);
})();
