/**
 * Visual Physics Lab — Preview Sketches for Index Cards
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    /* ---- Projectile Motion Preview ---- */
    VisualMath.register('projectile-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var pad = 20, gw = W - pad * 2, gh = H - pad * 2;
            var ox = pad, oy = pad + gh;

            // Ground
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(ox, oy, ox + gw, oy);

            // Trajectory arc
            p.stroke(C.sin); p.strokeWeight(2); p.noFill();
            p.beginShape();
            for (var t = 0; t <= 1; t += 0.02) {
                var x = ox + t * gw;
                var y = oy - 4 * gh * 0.7 * t * (1 - t);
                p.vertex(x, y);
            }
            p.endShape();

            // Ball at peak
            p.fill(C.accent); p.noStroke();
            p.ellipse(ox + gw * 0.5, oy - gh * 0.7, 10, 10);

            // Velocity arrows at start
            p.stroke(C.cos); p.strokeWeight(1.5);
            p.line(ox, oy, ox + 30, oy);
            p.stroke(C.sin);
            p.line(ox, oy, ox, oy - 25);
        };
    });

    /* ---- Pendulum/SHM Preview ---- */
    VisualMath.register('pendulum-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W * 0.35, pivotY = 20;
            var L = H * 0.55;
            var angle = 0.4;
            var bobX = cx + L * Math.sin(angle);
            var bobY = pivotY + L * Math.cos(angle);

            // Rod
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(cx, pivotY, bobX, bobY);
            // Pivot
            p.fill(C.muted); p.noStroke(); p.ellipse(cx, pivotY, 6, 6);
            // Bob
            p.fill(C.sin); p.noStroke(); p.ellipse(bobX, bobY, 16, 16);

            // Sine wave on right
            p.stroke(C.cos); p.strokeWeight(1.5); p.noFill();
            p.beginShape();
            for (var t = 0; t < W * 0.45; t += 2) {
                p.vertex(W * 0.55 + t, H / 2 + 30 * Math.sin(t * 0.06));
            }
            p.endShape();
        };
    });

    /* ---- Collisions Preview ---- */
    VisualMath.register('collisions-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cy = H / 2;

            // Ground line
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(20, cy + 30, W - 20, cy + 30);

            // Ball 1 (larger, moving right)
            p.fill(239, 68, 68); p.noStroke();
            p.ellipse(W * 0.3, cy, 28, 28);

            // Velocity arrow for ball 1
            p.stroke(239, 68, 68); p.strokeWeight(2);
            p.line(W * 0.3 + 18, cy, W * 0.3 + 40, cy);
            p.line(W * 0.3 + 36, cy - 4, W * 0.3 + 40, cy);
            p.line(W * 0.3 + 36, cy + 4, W * 0.3 + 40, cy);

            // Ball 2 (smaller, stationary)
            p.fill(59, 130, 246); p.noStroke();
            p.ellipse(W * 0.65, cy, 20, 20);

            // Momentum bars at bottom
            p.fill(239, 68, 68, 100); p.noStroke();
            p.rect(W * 0.15, cy + 40, W * 0.3, 10, 3);
            p.fill(59, 130, 246, 100);
            p.rect(W * 0.55, cy + 40, W * 0.15, 10, 3);
        };
    });

    /* ---- Inclined Plane Preview ---- */
    VisualMath.register('inclined-plane-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var pad = 25;
            var bx = pad, by = H - pad;
            var tx = W - pad * 2, ty = pad + 15;

            // Incline surface
            p.stroke(C.axis); p.strokeWeight(2);
            p.line(bx, by, tx, ty);
            p.line(bx, by, tx, by);

            // Block on slope
            var frac = 0.4;
            var mx = p.lerp(bx, tx, frac);
            var my = p.lerp(by, ty, frac);
            p.push();
            p.translate(mx, my);
            p.rotate(Math.atan2(ty - by, tx - bx));
            p.fill(C.accent); p.noStroke();
            p.rect(-12, -20, 24, 20, 2);
            p.pop();

            // Weight arrow (down)
            p.stroke(239, 68, 68); p.strokeWeight(1.5);
            p.line(mx, my, mx, my + 30);
            p.fill(239, 68, 68); p.noStroke();
            p.triangle(mx, my + 30, mx - 3, my + 25, mx + 3, my + 25);

            // Normal arrow
            var ang = Math.atan2(ty - by, tx - bx);
            var nx = -Math.sin(ang) * 25;
            var ny = Math.cos(ang) * 25;
            p.stroke(59, 130, 246); p.strokeWeight(1.5);
            p.line(mx, my - 10, mx + nx, my - 10 + ny);

            // Angle arc
            p.noFill(); p.stroke(C.muted); p.strokeWeight(1);
            p.arc(bx, by, 40, 40, Math.atan2(ty - by, tx - bx), 0);
        };
    });

    /* ---- Torque & Rotation Preview ---- */
    VisualMath.register('torque-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, cy = H / 2;

            // Lever bar
            p.stroke(C.axis); p.strokeWeight(3);
            p.line(cx - W * 0.35, cy, cx + W * 0.35, cy);

            // Pivot (triangle)
            p.fill(C.muted); p.noStroke();
            p.triangle(cx - 8, cy + 2, cx + 8, cy + 2, cx, cy + 18);

            // Force arrow at end
            p.stroke(239, 68, 68); p.strokeWeight(2);
            var fx = cx + W * 0.3;
            p.line(fx, cy, fx, cy - 35);
            p.fill(239, 68, 68); p.noStroke();
            p.triangle(fx, cy - 35, fx - 4, cy - 28, fx + 4, cy - 28);

            // Rotation arrow (curved)
            p.noFill(); p.stroke(C.accent); p.strokeWeight(1.5);
            p.arc(cx, cy, 50, 50, -Math.PI * 0.7, -Math.PI * 0.2);
            // Arrowhead
            var ax = cx + 25 * Math.cos(-Math.PI * 0.2);
            var ay = cy + 25 * Math.sin(-Math.PI * 0.2);
            p.fill(C.accent); p.noStroke();
            p.ellipse(ax, ay, 5, 5);

            // Weight at other end
            p.fill(59, 130, 246); p.noStroke();
            p.rect(cx - W * 0.3 - 8, cy + 2, 16, 16, 2);
        };
    });

    /* ---- Orbital Mechanics Preview ---- */
    VisualMath.register('orbital-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, cy = H / 2;
            var a = Math.min(W, H) * 0.38;
            var e = 0.5;
            var b = a * Math.sqrt(1 - e * e);
            var focusX = cx + a * e;

            // Orbit ellipse
            p.noFill(); p.stroke(C.sin); p.strokeWeight(1.5);
            p.ellipse(cx, cy, a * 2, b * 2);

            // Sun at focus
            p.fill(255, 200, 50); p.noStroke();
            p.ellipse(focusX, cy, 14, 14);

            // Planet on orbit
            var theta = -0.6;
            var r = a * (1 - e * e) / (1 + e * Math.cos(theta));
            var px = focusX + r * Math.cos(theta);
            var py = cy - r * Math.sin(theta);
            p.fill(C.accent); p.noStroke();
            p.ellipse(px, py, 10, 10);

            // Velocity arrow
            p.stroke(C.cos); p.strokeWeight(1.5);
            var vx = -Math.sin(theta) * 20;
            var vy = -Math.cos(theta) * 15;
            p.line(px, py, px + vx, py + vy);
        };
    });

    /* ---- Lens Ray Diagram Preview ---- */
    VisualMath.register('lens-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, cy = H / 2;

            // Axis
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(10, cy, W - 10, cy);

            // Lens
            p.stroke(C.accent); p.strokeWeight(2); p.noFill();
            p.arc(cx - 4, cy, 16, H * 0.7, -Math.PI / 2, Math.PI / 2);
            p.arc(cx + 4, cy, 16, H * 0.7, Math.PI / 2, 3 * Math.PI / 2);

            // Object arrow
            var objX = cx - W * 0.25;
            p.stroke(C.sin); p.strokeWeight(2);
            p.line(objX, cy, objX, cy - 40);
            p.fill(C.sin); p.noStroke();
            p.triangle(objX, cy - 40, objX - 4, cy - 32, objX + 4, cy - 32);

            // Rays
            p.stroke(239, 68, 68, 160); p.strokeWeight(1);
            p.line(objX, cy - 40, cx, cy - 40);
            p.line(cx, cy - 40, cx + W * 0.25, cy + 20);
            p.stroke(59, 130, 246, 160);
            p.line(objX, cy - 40, cx + W * 0.25, cy + 20);
        };
    });

    /* ---- Snell's Law Preview ---- */
    VisualMath.register('snells-law-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cy = H / 2;

            // Media boundary
            p.fill(59, 130, 246, 30); p.noStroke();
            p.rect(0, cy, W, H / 2);

            // Normal (dashed)
            p.stroke(C.muted); p.strokeWeight(1);
            for (var y = 10; y < H - 10; y += 8) {
                p.line(W / 2, y, W / 2, y + 4);
            }

            // Incident ray
            var incAngle = 0.7;
            p.stroke(239, 68, 68); p.strokeWeight(2);
            p.line(W / 2 - Math.sin(incAngle) * cy, 5, W / 2, cy);

            // Refracted ray (Snell's law: n1=1.0, n2=1.5)
            var refAngle = Math.asin(Math.sin(incAngle) / 1.5);
            p.stroke(59, 130, 246); p.strokeWeight(2);
            p.line(W / 2, cy, W / 2 + Math.sin(refAngle) * (H / 2 - 5), H - 5);

            // Reflected ray
            p.stroke(239, 68, 68, 120); p.strokeWeight(1);
            p.line(W / 2, cy, W / 2 + Math.sin(incAngle) * (cy - 10), 10);

            // Labels
            p.fill(C.text); p.noStroke(); p.textSize(9); p.textAlign(p.LEFT);
            p.text('n\u2081', 8, cy - 8);
            p.text('n\u2082', 8, cy + 14);
        };
    });

    /* ---- Diffraction Preview ---- */
    VisualMath.register('diffraction-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.pixelDensity(1); p.noLoop();
        };
        p.draw = function () {
            var isDark = VisualMath.isDark();
            var slitWidth = 8;
            var wavelength = 550;
            var k = 2 * Math.PI / (wavelength * 0.00005);

            p.loadPixels();
            for (var y = 0; y < H; y += 2) {
                for (var x = 0; x < W; x += 2) {
                    var angle = Math.atan2(y - H / 2, W * 0.8);
                    var beta = Math.PI * slitWidth * Math.sin(angle) / (wavelength * 0.0001);
                    var sinc = beta === 0 ? 1 : Math.sin(beta) / beta;
                    var intensity = sinc * sinc;

                    var r, g, b;
                    if (isDark) {
                        r = Math.floor(intensity * 120);
                        g = Math.floor(intensity * 180);
                        b = Math.floor(15 + intensity * 240);
                    } else {
                        r = Math.floor(255 - intensity * 200);
                        g = Math.floor(255 - intensity * 160);
                        b = Math.floor(255 - intensity * 60);
                    }

                    for (var dy = 0; dy < 2 && y + dy < H; dy++) {
                        for (var dx = 0; dx < 2 && x + dx < W; dx++) {
                            var idx = 4 * ((y + dy) * W + (x + dx));
                            p.pixels[idx] = r; p.pixels[idx + 1] = g; p.pixels[idx + 2] = b; p.pixels[idx + 3] = 255;
                        }
                    }
                }
            }
            p.updatePixels();

            // Slit indicator on left
            p.stroke(249, 115, 22); p.strokeWeight(2);
            p.line(5, H / 2 - 20, 5, H / 2 - 3);
            p.line(5, H / 2 + 3, 5, H / 2 + 20);
        };
    });

    /* ---- Electric Field Preview ---- */
    VisualMath.register('electric-field-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            // Two charges
            var x1 = W * 0.35, x2 = W * 0.65, cy = H / 2;
            p.fill(239, 68, 68); p.stroke(255); p.strokeWeight(1.5);
            p.ellipse(x1, cy, 18, 18);
            p.fill(59, 130, 246); p.ellipse(x2, cy, 18, 18);
            p.fill(255); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER, p.CENTER);
            p.text('+', x1, cy); p.text('\u2212', x2, cy);

            // Field lines (simplified curves)
            p.noFill(); p.strokeWeight(1);
            var angles = [-0.6, -0.3, 0, 0.3, 0.6];
            for (var i = 0; i < angles.length; i++) {
                p.stroke(C.sin[0], C.sin[1], C.sin[2], 100);
                var a = angles[i];
                p.beginShape();
                for (var t = 0; t <= 1; t += 0.05) {
                    var x = p.lerp(x1 + 12 * Math.cos(a), x2 - 12 * Math.cos(a), t);
                    var yOff = Math.sin(t * Math.PI) * (30 + Math.abs(a) * 40);
                    p.vertex(x, cy + yOff * (a >= 0 ? -1 : 1));
                }
                p.endShape();
            }
        };
    });

    /* ---- Magnetic Field Preview ---- */
    VisualMath.register('magnetic-field-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, cy = H / 2;

            // Bar magnet
            p.fill(239, 68, 68); p.noStroke();
            p.rect(cx - 35, cy - 10, 35, 20, 3, 0, 0, 3);
            p.fill(59, 130, 246);
            p.rect(cx, cy - 10, 35, 20, 0, 3, 3, 0);
            p.fill(255); p.textSize(10); p.textAlign(p.CENTER, p.CENTER);
            p.text('N', cx - 17, cy);
            p.text('S', cx + 17, cy);

            // Field line loops
            p.noFill(); p.strokeWeight(1);
            var loops = [25, 45, 65];
            for (var i = 0; i < loops.length; i++) {
                var r = loops[i];
                p.stroke(C.sin[0], C.sin[1], C.sin[2], 140 - i * 30);
                p.beginShape();
                for (var a = 0; a <= Math.PI * 2; a += 0.1) {
                    var lx = cx + (40 + r * 0.5) * Math.cos(a);
                    var ly = cy + r * Math.sin(a);
                    p.vertex(lx, ly);
                }
                p.endShape(p.CLOSE);
            }
        };
    });

    /* ---- Circuit Builder Preview ---- */
    VisualMath.register('circuit-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var pad = 25;
            var left = pad, right = W - pad, top = pad + 10, bottom = H - pad - 10;

            // Circuit loop
            p.stroke(C.axis); p.strokeWeight(2); p.noFill();
            p.line(left, top, right, top);
            p.line(right, top, right, bottom);
            p.line(right, bottom, left, bottom);
            p.line(left, bottom, left, top + 30);
            p.line(left, top - 5, left, top);

            // Battery
            p.strokeWeight(2.5);
            var midY = (top + bottom) / 2 + 20;
            p.line(left - 8, midY - 5, left + 8, midY - 5);
            p.line(left - 4, midY + 5, left + 4, midY + 5);

            // Resistor zigzag on top
            var rx1 = left + (right - left) * 0.3;
            var rx2 = left + (right - left) * 0.7;
            p.strokeWeight(1.5); p.stroke(C.text);
            p.beginShape();
            p.vertex(rx1, top);
            var teeth = 5, th = 8, segLen = (rx2 - rx1) / (teeth * 2);
            for (var i = 0; i < teeth; i++) {
                p.vertex(rx1 + (i * 2 + 0.5) * segLen, top - th);
                p.vertex(rx1 + (i * 2 + 1.5) * segLen, top + th);
            }
            p.vertex(rx2, top);
            p.endShape();

            // Current dots
            p.fill(249, 115, 22); p.noStroke();
            p.ellipse(right - 20, top + 15, 4, 4);
            p.ellipse(right, (top + bottom) / 2, 4, 4);
            p.ellipse(right - 40, bottom, 4, 4);
        };
    });

    /* ---- EM Induction Preview ---- */
    VisualMath.register('em-induction-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, cy = H / 2;

            // Coil (series of ellipses)
            p.noFill(); p.stroke(C.accent); p.strokeWeight(1.5);
            for (var i = 0; i < 5; i++) {
                p.ellipse(cx + i * 8, cy, 20, 50);
            }

            // Bar magnet approaching from left
            p.fill(239, 68, 68); p.noStroke();
            p.rect(cx - 65, cy - 8, 25, 16, 3, 0, 0, 3);
            p.fill(59, 130, 246);
            p.rect(cx - 40, cy - 8, 25, 16, 0, 3, 3, 0);
            p.fill(255); p.textSize(8); p.textAlign(p.CENTER, p.CENTER);
            p.text('N', cx - 52, cy);
            p.text('S', cx - 28, cy);

            // Motion arrow
            p.stroke(C.sin); p.strokeWeight(2);
            p.line(cx - 70, cy - 20, cx - 50, cy - 20);
            p.fill(C.sin); p.noStroke();
            p.triangle(cx - 50, cy - 20, cx - 55, cy - 23, cx - 55, cy - 17);

            // Induced current arrow
            p.noFill(); p.stroke(249, 115, 22); p.strokeWeight(1.5);
            p.arc(cx + 55, cy, 20, 30, -Math.PI * 0.6, Math.PI * 0.6);
        };
    });

    /* ---- Wave Interference Preview ---- */
    VisualMath.register('wave-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.pixelDensity(1); p.noLoop();
        };
        p.draw = function () {
            var isDark = VisualMath.isDark();
            var s1x = W * 0.4, s2x = W * 0.6, sy = H / 2;
            var wavelength = 30;
            var k = 2 * Math.PI / wavelength;

            p.loadPixels();
            for (var y = 0; y < H; y += 3) {
                for (var x = 0; x < W; x += 3) {
                    var d1 = Math.sqrt((x - s1x) * (x - s1x) + (y - sy) * (y - sy));
                    var d2 = Math.sqrt((x - s2x) * (x - s2x) + (y - sy) * (y - sy));
                    var amp = Math.sin(k * d1) + Math.sin(k * d2);
                    var intensity = amp * amp * 0.25;
                    intensity = Math.min(1, intensity);
                    var r, g, b;
                    if (isDark) {
                        r = Math.floor(15 + intensity * 90); g = Math.floor(23 + intensity * 130); b = Math.floor(42 + intensity * 190);
                    } else {
                        r = Math.floor(255 - intensity * 190); g = Math.floor(255 - intensity * 170); b = Math.floor(255 - intensity * 90);
                    }
                    for (var dy = 0; dy < 3 && y + dy < H; dy++) {
                        for (var dx = 0; dx < 3 && x + dx < W; dx++) {
                            var idx = 4 * ((y + dy) * W + (x + dx));
                            p.pixels[idx] = r; p.pixels[idx + 1] = g; p.pixels[idx + 2] = b; p.pixels[idx + 3] = 255;
                        }
                    }
                }
            }
            p.updatePixels();

            // Source markers
            p.fill(239, 68, 68); p.stroke(255); p.strokeWeight(1);
            p.ellipse(s1x, sy, 8, 8); p.ellipse(s2x, sy, 8, 8);
        };
    });

    /* ---- Standing Waves Preview ---- */
    VisualMath.register('standing-waves-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var pad = 20;
            var cy = H / 2;
            var n = 3; // 3rd harmonic

            // Fixed endpoints
            p.fill(C.muted); p.noStroke();
            p.ellipse(pad, cy, 8, 8);
            p.ellipse(W - pad, cy, 8, 8);

            // Equilibrium line
            p.stroke(C.axis); p.strokeWeight(1);
            p.line(pad, cy, W - pad, cy);

            // Standing wave (envelope)
            p.stroke(C.sin); p.strokeWeight(1); p.noFill();
            p.beginShape();
            for (var x = pad; x <= W - pad; x += 2) {
                var frac = (x - pad) / (W - 2 * pad);
                var y = cy - 35 * Math.sin(n * Math.PI * frac);
                p.vertex(x, y);
            }
            p.endShape();

            // Lower envelope
            p.stroke(C.sin[0], C.sin[1], C.sin[2], 80);
            p.beginShape();
            for (var x2 = pad; x2 <= W - pad; x2 += 2) {
                var frac2 = (x2 - pad) / (W - 2 * pad);
                var y2 = cy + 35 * Math.sin(n * Math.PI * frac2);
                p.vertex(x2, y2);
            }
            p.endShape();

            // Node markers
            p.fill(239, 68, 68); p.noStroke();
            for (var k = 1; k < n; k++) {
                var nx = pad + (W - 2 * pad) * k / n;
                p.ellipse(nx, cy, 6, 6);
            }
        };
    });

    /* ---- Doppler Effect Preview ---- */
    VisualMath.register('doppler-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var sx = W * 0.4, sy = H / 2;

            // Expanding wavefronts (offset to show compression)
            p.noFill(); p.strokeWeight(1);
            var radii = [20, 40, 60, 80];
            var offsets = [6, 12, 18, 24]; // source was moving right
            for (var i = 0; i < radii.length; i++) {
                var alpha = 200 - i * 40;
                p.stroke(34, 197, 94, alpha);
                p.ellipse(sx - offsets[i], sy, radii[i] * 2, radii[i] * 2);
            }

            // Source (moving right)
            p.fill(239, 68, 68); p.noStroke();
            p.ellipse(sx, sy, 12, 12);

            // Motion arrow
            p.stroke(C.text); p.strokeWeight(1.5);
            p.line(sx + 10, sy, sx + 30, sy);
            p.fill(C.text); p.noStroke();
            p.triangle(sx + 30, sy, sx + 26, sy - 3, sx + 26, sy + 3);
        };
    });

    /* ---- Pulley Systems Preview ---- */
    VisualMath.register('pulley-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cx = W / 2, supportY = 15;

            // Support beam
            p.fill(C.muted); p.noStroke();
            p.rect(cx - 40, supportY, 80, 6, 2);
            p.stroke(C.muted); p.strokeWeight(1);
            for (var i = cx - 35; i < cx + 40; i += 7) {
                p.line(i, supportY, i - 4, supportY - 5);
            }

            // Pulley wheel
            var pR = 14, pY = supportY + pR + 8;
            p.fill(VisualMath.isDark() ? 60 : 200); p.stroke(C.axis); p.strokeWeight(1.5);
            p.ellipse(cx, pY, pR * 2, pR * 2);
            p.fill(C.text); p.noStroke();
            p.ellipse(cx, pY, 5, 5);

            // Rope
            var ropeCol = VisualMath.isDark() ? [180, 160, 120] : [120, 100, 60];
            p.stroke(ropeCol); p.strokeWeight(2);
            // Left side (effort)
            p.line(cx - pR, pY, cx - pR, H - 25);
            // Right side (load)
            p.line(cx + pR, pY, cx + pR, pY + 65);

            // Effort arrow
            p.stroke(59, 130, 246); p.strokeWeight(1.5);
            p.line(cx - pR, H - 40, cx - pR, H - 15);
            p.fill(59, 130, 246); p.noStroke();
            p.triangle(cx - pR, H - 15, cx - pR - 3, H - 20, cx - pR + 3, H - 20);

            // Load mass
            var lx = cx + pR, ly = pY + 65;
            p.fill(239, 68, 68); p.stroke(C.axis); p.strokeWeight(1);
            p.rect(lx - 14, ly, 28, 22, 3);
            p.fill(255); p.noStroke(); p.textSize(8); p.textAlign(p.CENTER, p.CENTER);
            p.text('m', lx, ly + 11);

            // MA label
            p.fill(C.text); p.noStroke(); p.textSize(9); p.textAlign(p.CENTER);
            p.text('MA = 2\u207f', cx, H - 5);
        };
    });

    /* ---- Ideal Gas Law Preview ---- */
    VisualMath.register('ideal-gas-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var pad = 25;

            // PV axes
            p.stroke(C.axis); p.strokeWeight(1.5);
            p.line(pad, pad, pad, H - pad);
            p.line(pad, H - pad, W - pad, H - pad);

            // Axis labels
            p.fill(C.muted); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
            p.text('V', W / 2, H - 8);
            p.push(); p.translate(10, H / 2); p.rotate(-Math.PI / 2);
            p.text('P', 0, 0); p.pop();

            // Isothermal curve (PV = const)
            var gw = W - 2 * pad, gh = H - 2 * pad;
            p.noFill(); p.stroke(234, 179, 8); p.strokeWeight(2);
            p.beginShape();
            for (var v = 0.2; v <= 1; v += 0.02) {
                var px = pad + v * gw;
                var pv = 0.2 / v; // PV=const
                var py = H - pad - pv * gh;
                if (py > pad) p.vertex(px, py);
            }
            p.endShape();

            // Adiabatic curve (steeper)
            p.stroke(168, 85, 247); p.strokeWeight(1.5);
            p.beginShape();
            for (var v2 = 0.2; v2 <= 1; v2 += 0.02) {
                var px2 = pad + v2 * gw;
                var pv2 = 0.2 / Math.pow(v2, 1.4);
                var py2 = H - pad - pv2 * gh;
                if (py2 > pad) p.vertex(px2, py2);
            }
            p.endShape();

            // Work shading
            p.fill(234, 179, 8, 30); p.noStroke();
            p.beginShape();
            p.vertex(pad + 0.2 * gw, H - pad);
            for (var v3 = 0.2; v3 <= 0.7; v3 += 0.02) {
                var px3 = pad + v3 * gw;
                var pv3 = 0.2 / v3;
                var py3 = H - pad - pv3 * gh;
                if (py3 > pad) p.vertex(px3, py3);
            }
            p.vertex(pad + 0.7 * gw, H - pad);
            p.endShape(p.CLOSE);
        };
    });

    /* ---- Photoelectric Effect Preview ---- */
    VisualMath.register('photoelectric-preview', function (p, container) {
        var W, H;
        p.setup = function () {
            W = container.clientWidth; H = container.clientHeight || 180;
            p.createCanvas(W, H); p.noLoop();
        };
        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);
            var cy = H / 2;

            // Metal plate
            p.fill(C.muted); p.noStroke();
            p.rect(W * 0.45, cy - 30, 12, 60, 2);

            // Photon beams (wavy arrows from left)
            p.stroke(168, 85, 247); p.strokeWeight(1.5);
            for (var i = 0; i < 3; i++) {
                var py = cy - 15 + i * 15;
                p.beginShape();
                for (var x = W * 0.1; x < W * 0.44; x += 2) {
                    p.vertex(x, py + 3 * Math.sin(x * 0.3));
                }
                p.endShape();
                // Arrowhead
                p.fill(168, 85, 247); p.noStroke();
                p.triangle(W * 0.44, py, W * 0.42, py - 3, W * 0.42, py + 3);
                p.noFill(); p.stroke(168, 85, 247); p.strokeWeight(1.5);
            }

            // Ejected electrons (dots flying right)
            p.fill(59, 130, 246); p.noStroke();
            p.ellipse(W * 0.6, cy - 18, 6, 6);
            p.ellipse(W * 0.7, cy + 5, 6, 6);
            p.ellipse(W * 0.65, cy + 15, 6, 6);

            // Electron arrows
            p.stroke(59, 130, 246); p.strokeWeight(1);
            p.line(W * 0.6, cy - 18, W * 0.66, cy - 22);
            p.line(W * 0.7, cy + 5, W * 0.76, cy + 2);
            p.line(W * 0.65, cy + 15, W * 0.72, cy + 12);

            // Label
            p.fill(C.text); p.noStroke(); p.textSize(8); p.textAlign(p.CENTER);
            p.text('h\u03bd', W * 0.25, cy - 28);
            p.text('e\u207b', W * 0.72, cy - 28);
        };
    });

})();
