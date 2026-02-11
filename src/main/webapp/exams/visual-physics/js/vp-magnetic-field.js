/**
 * Visual Physics — Magnetic Field Visualizer
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    function magneticFieldViz(p, container) {
        var state = VisualMath.getState();
        var W, H;
        var mu0 = 4 * Math.PI * 1e-7;

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

        function getSource() { return state.sourceType || 'bar'; }
        function getStrength() { return state.strength || 5; }
        function getCurrent() { return state.current || 10; }

        function barMagnetField(px, py, cx, cy, mLen) {
            // Dipole approximation
            var halfLen = mLen / 2;
            var northX = cx, northY = cy - halfLen;
            var southX = cx, southY = cy + halfLen;

            var dx1 = px - northX, dy1 = py - northY;
            var dx2 = px - southX, dy2 = py - southY;
            var r1 = Math.max(10, Math.sqrt(dx1 * dx1 + dy1 * dy1));
            var r2 = Math.max(10, Math.sqrt(dx2 * dx2 + dy2 * dy2));

            var strength = getStrength();
            var bx = strength * (dx1 / (r1 * r1 * r1) - dx2 / (r2 * r2 * r2)) * 5000;
            var by = strength * (dy1 / (r1 * r1 * r1) - dy2 / (r2 * r2 * r2)) * 5000;
            return { x: bx, y: by };
        }

        function wireField(px, py, cx, cy) {
            var dx = px - cx, dy = py - cy;
            var r = Math.max(5, Math.sqrt(dx * dx + dy * dy));
            var I = getCurrent();
            var B = I / (2 * Math.PI * r) * 50;
            // Perpendicular (right-hand rule: out of screen → CCW)
            return { x: -dy / r * B, y: dx / r * B };
        }

        function loopField(px, py, cx, cy) {
            // Simplified loop field
            var dx = px - cx, dy = py - cy;
            var r = Math.max(5, Math.sqrt(dx * dx + dy * dy));
            var I = getCurrent();
            var R = 40; // loop radius
            // Along axis approximation
            if (Math.abs(dx) < R * 0.3) {
                var B = I * R * R / (2 * Math.pow(R * R + dy * dy, 1.5)) * 2000;
                return { x: 0, y: dy > 0 ? -B : B };
            }
            // Off-axis: dipole-like
            var B2 = I / (r * r * r) * 2000;
            return { x: -dy / r * B2, y: dx / r * B2 };
        }

        function solenoidField(px, py, cx, cy) {
            var dx = px - cx, dy = py - cy;
            var solenoidW = 120, solenoidH = 40;
            var inside = Math.abs(dx) < solenoidW / 2 && Math.abs(dy) < solenoidH / 2;
            var I = getCurrent();

            if (inside) {
                // Uniform field inside
                var nI = getStrength() * I * 0.5;
                return { x: nI, y: 0 };
            }
            // Outside: dipole-like
            var r = Math.max(10, Math.sqrt(dx * dx + dy * dy));
            var B = getStrength() * I / (r * r * r) * 5000;
            return { x: dx / r * B, y: dy / r * B };
        }

        function getField(px, py, cx, cy) {
            var source = getSource();
            if (source === 'bar') return barMagnetField(px, py, cx, cy, 80);
            if (source === 'wire') return wireField(px, py, cx, cy);
            if (source === 'loop') return loopField(px, py, cx, cy);
            if (source === 'solenoid') return solenoidField(px, py, cx, cy);
            return { x: 0, y: 0 };
        }

        p.draw = function () {
            var C = VisualMath.palette();
            var isDark = VisualMath.isDark();
            p.background(C.bg);

            var cx = W / 2, cy = H / 2;
            var source = getSource();

            // Draw source
            if (source === 'bar') {
                var mLen = 80;
                // North pole (red)
                p.fill(239, 68, 68); p.stroke(C.text); p.strokeWeight(1);
                p.rect(cx - 20, cy - mLen / 2, 40, mLen / 2, 3, 3, 0, 0);
                // South pole (blue)
                p.fill(59, 130, 246);
                p.rect(cx - 20, cy, 40, mLen / 2, 0, 0, 3, 3);
                p.fill(255); p.noStroke(); p.textSize(14); p.textAlign(p.CENTER, p.CENTER);
                p.text('N', cx, cy - mLen / 4);
                p.text('S', cx, cy + mLen / 4);
            } else if (source === 'wire') {
                // Wire coming out of screen
                p.fill(C.accent); p.stroke(C.text); p.strokeWeight(2);
                p.ellipse(cx, cy, 24, 24);
                p.fill(C.bg); p.noStroke(); p.textSize(16); p.textAlign(p.CENTER, p.CENTER);
                p.text('\u2299', cx, cy); // dot for out of page
            } else if (source === 'loop') {
                p.noFill(); p.stroke(C.accent); p.strokeWeight(3);
                p.ellipse(cx, cy, 80, 80);
                p.fill(C.text); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER, p.TOP);
                p.text('I', cx + 45, cy - 5);
            } else if (source === 'solenoid') {
                p.noFill(); p.stroke(C.accent); p.strokeWeight(2);
                var sw = 120, sh = 40;
                for (var i = 0; i < 8; i++) {
                    var sx = cx - sw / 2 + i * sw / 7;
                    p.arc(sx, cy, sw / 7, sh, -Math.PI / 2, Math.PI / 2);
                }
                p.stroke(C.text); p.strokeWeight(1);
                p.line(cx - sw / 2, cy - sh / 2, cx + sw / 2, cy - sh / 2);
                p.line(cx - sw / 2, cy + sh / 2, cx + sw / 2, cy + sh / 2);
            }

            // Iron filings pattern
            if (state.showFilings) {
                var spacing = W < 500 ? 20 : 15;
                for (var fy = spacing; fy < H; fy += spacing) {
                    for (var fx = spacing; fx < W; fx += spacing) {
                        var B = getField(fx, fy, cx, cy);
                        var mag = Math.sqrt(B.x * B.x + B.y * B.y);
                        if (mag < 0.1) continue;
                        var angle = Math.atan2(B.y, B.x);
                        var len = Math.min(8, mag * 0.5);
                        var alpha = Math.min(200, mag * 20 + 30);
                        p.stroke(isDark ? ('rgba(200,200,200,' + alpha / 255 + ')') : ('rgba(80,80,80,' + alpha / 255 + ')'));
                        p.strokeWeight(1);
                        p.line(fx - len * Math.cos(angle), fy - len * Math.sin(angle),
                            fx + len * Math.cos(angle), fy + len * Math.sin(angle));
                    }
                }
            }

            // Field lines
            if (state.showFieldLines) {
                var numLines = 12;
                for (var li = 0; li < numLines; li++) {
                    var startAngle = (li / numLines) * 2 * Math.PI;
                    var startR = source === 'bar' ? 50 : 20;
                    var lx = cx + startR * Math.cos(startAngle);
                    var ly = cy + startR * Math.sin(startAngle);

                    p.noFill();
                    p.stroke(isDark ? 'rgba(99,102,241,0.5)' : 'rgba(59,130,246,0.5)');
                    p.strokeWeight(1.5);
                    p.beginShape();
                    for (var step = 0; step < 200; step++) {
                        p.vertex(lx, ly);
                        var B2 = getField(lx, ly, cx, cy);
                        var mag2 = Math.sqrt(B2.x * B2.x + B2.y * B2.y);
                        if (mag2 < 0.01) break;
                        lx += B2.x / mag2 * 3;
                        ly += B2.y / mag2 * 3;
                        if (lx < 0 || lx > W || ly < 0 || ly > H) break;
                    }
                    p.endShape();
                }
            }

            // Field vectors (grid)
            if (state.showVectors) {
                var vSpacing = W < 500 ? 40 : 30;
                for (var vy = vSpacing; vy < H; vy += vSpacing) {
                    for (var vx = vSpacing; vx < W; vx += vSpacing) {
                        var Bv = getField(vx, vy, cx, cy);
                        var magV = Math.sqrt(Bv.x * Bv.x + Bv.y * Bv.y);
                        if (magV < 0.1) continue;
                        var arrLen = Math.min(12, magV * 0.8);
                        var nx = Bv.x / magV, ny = Bv.y / magV;
                        p.stroke(99, 102, 241, 150); p.strokeWeight(1);
                        p.line(vx, vy, vx + nx * arrLen, vy + ny * arrLen);
                    }
                }
            }

            // Compass needles
            if (state.showCompass) {
                var cSpacing = W < 500 ? 50 : 40;
                for (var cy2 = cSpacing; cy2 < H; cy2 += cSpacing) {
                    for (var cx2 = cSpacing; cx2 < W; cx2 += cSpacing) {
                        var Bc = getField(cx2, cy2, cx, cy);
                        var magC = Math.sqrt(Bc.x * Bc.x + Bc.y * Bc.y);
                        if (magC < 0.05) continue;
                        var cAngle = Math.atan2(Bc.y, Bc.x);
                        var needleLen = 8;
                        // Red end (north)
                        p.stroke(239, 68, 68); p.strokeWeight(2);
                        p.line(cx2, cy2, cx2 + needleLen * Math.cos(cAngle), cy2 + needleLen * Math.sin(cAngle));
                        // White end (south)
                        p.stroke(200); p.strokeWeight(2);
                        p.line(cx2, cy2, cx2 - needleLen * Math.cos(cAngle), cy2 - needleLen * Math.sin(cAngle));
                    }
                }
            }

            // Title
            p.fill(C.text); p.noStroke(); p.textSize(12); p.textAlign(p.LEFT, p.TOP);
            var sourceNames = { bar: 'Bar Magnet', wire: 'Straight Wire', loop: 'Wire Loop', solenoid: 'Solenoid' };
            p.text('Magnetic Field \u2014 ' + (sourceNames[source] || source), 8, 8);

            syncValues();
        };

        function syncValues() {
            var sourceNames = { bar: 'Bar Magnet', wire: 'Straight Wire', loop: 'Wire Loop', solenoid: 'Solenoid' };
            setEl('val-source', sourceNames[getSource()] || getSource());
            setEl('val-strength', getStrength().toString());
            setEl('val-current', getCurrent() + ' A');

            // B at a reference point
            var cx = W / 2, cy = H / 2;
            var refX = cx + 80, refY = cy;
            var B = getField(refX, refY, cx, cy);
            var mag = Math.sqrt(B.x * B.x + B.y * B.y);
            setEl('val-bat', mag.toFixed(2) + ' (arb)');
            setEl('val-direction', (Math.atan2(B.y, B.x) * 180 / Math.PI).toFixed(1) + '\u00B0');
            var source = getSource();
            setEl('val-poles', source === 'bar' ? 'N (top), S (bottom)' : 'N/A');
        }

        function setEl(id, txt) { var el = document.getElementById(id); if (el) el.textContent = txt; }

        state._setPreset = function (name) {
            if (name === 'bar') { state.sourceType = 'bar'; }
            else if (name === 'wire') { state.sourceType = 'wire'; }
            else if (name === 'helmholtz') { state.sourceType = 'loop'; }
            else if (name === 'solenoid') { state.sourceType = 'solenoid'; }
            p.redraw();
        };
        state._redraw = function () { p.redraw(); };
    }

    VisualMath.register('magnetic-field', magneticFieldViz);
})();
