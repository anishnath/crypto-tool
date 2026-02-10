/**
 * Physics Interactive Sketches — p5.js instance-mode renderers
 * Each sketch type is a factory that returns a p5 sketch function.
 * Usage: PhysicsSketches.render(containerEl, type, params)
 */
var PhysicsSketches = (function() {
    'use strict';

    // --- Color palette (dark-mode aware) ---
    var COLORS = {
        positive: '#ef4444',
        negative: '#3b82f6',
        neutral: '#6b7280',
        force: '#f59e0b',
        field: '#8b5cf6',
        fieldFaint: 'rgba(139, 92, 246, 0.25)',
        surface: 'rgba(34, 197, 94, 0.2)',
        surfaceStroke: '#22c55e',
        plate: '#64748b',
        bg: '#1a1a2e',
        text: '#e2e8f0',
        grid: 'rgba(255,255,255,0.06)',
        axis: 'rgba(255,255,255,0.15)',
        label: '#94a3b8',
        white: '#ffffff'
    };

    // Check dark mode
    function isDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark' ||
               window.matchMedia('(prefers-color-scheme: dark)').matches;
    }

    function getBg() { return isDark() ? '#1e1e2e' : '#f8fafc'; }
    function getTextColor() { return isDark() ? '#e2e8f0' : '#1e293b'; }
    function getGridColor() { return isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)'; }
    function getAxisColor() { return isDark() ? 'rgba(255,255,255,0.15)' : 'rgba(0,0,0,0.15)'; }

    // --- Utility functions ---
    function chargeColor(q) {
        return q > 0 ? COLORS.positive : q < 0 ? COLORS.negative : COLORS.neutral;
    }

    function drawGrid(p, spacing) {
        p.stroke(getGridColor());
        p.strokeWeight(1);
        for (var x = 0; x < p.width; x += spacing) { p.line(x, 0, x, p.height); }
        for (var y = 0; y < p.height; y += spacing) { p.line(0, y, p.width, y); }
    }

    function drawArrow(p, x1, y1, x2, y2, color, weight) {
        p.push();
        p.stroke(color);
        p.strokeWeight(weight || 2);
        p.fill(color);
        var angle = p.atan2(y2 - y1, x2 - x1);
        var len = p.dist(x1, y1, x2, y2);
        p.translate(x1, y1);
        p.rotate(angle);
        p.line(0, 0, len, 0);
        var headSize = Math.min(10, len * 0.3);
        p.triangle(len, 0, len - headSize, -headSize * 0.5, len - headSize, headSize * 0.5);
        p.pop();
    }

    function drawCharge(p, x, y, q, label, radius) {
        radius = radius || 18;
        var col = chargeColor(q);
        // Glow
        p.noStroke();
        for (var i = 3; i > 0; i--) {
            var a = 30 - i * 8;
            p.fill(p.red(p.color(col)), p.green(p.color(col)), p.blue(p.color(col)), a);
            p.ellipse(x, y, radius * 2 + i * 8, radius * 2 + i * 8);
        }
        // Solid circle
        p.fill(col);
        p.stroke(255);
        p.strokeWeight(2);
        p.ellipse(x, y, radius * 2, radius * 2);
        // Sign
        p.fill(255);
        p.noStroke();
        p.textAlign(p.CENTER, p.CENTER);
        p.textSize(14);
        p.textStyle(p.BOLD);
        p.text(q > 0 ? '+' : q < 0 ? '−' : '0', x, y);
        // Label
        if (label) {
            p.fill(getTextColor());
            p.textSize(11);
            p.textStyle(p.NORMAL);
            p.text(label, x, y + radius + 16);
        }
    }

    function drawDashedLine(p, x1, y1, x2, y2, dashLen) {
        dashLen = dashLen || 6;
        var d = p.dist(x1, y1, x2, y2);
        var steps = Math.floor(d / dashLen);
        for (var i = 0; i < steps; i += 2) {
            var t1 = i / steps;
            var t2 = Math.min((i + 1) / steps, 1);
            p.line(
                p.lerp(x1, x2, t1), p.lerp(y1, y2, t1),
                p.lerp(x1, x2, t2), p.lerp(y1, y2, t2)
            );
        }
    }

    // --- Electric field computation ---
    function electricField(charges, px, py, k) {
        k = k || 1;
        var ex = 0, ey = 0;
        for (var i = 0; i < charges.length; i++) {
            var c = charges[i];
            var dx = px - c.x;
            var dy = py - c.y;
            var r2 = dx * dx + dy * dy;
            if (r2 < 100) continue; // Skip if too close
            var r = Math.sqrt(r2);
            var e = k * c.q / r2;
            ex += e * dx / r;
            ey += e * dy / r;
        }
        return { x: ex, y: ey };
    }

    // --- Field line tracer ---
    function traceFieldLine(charges, startX, startY, direction, steps, stepSize, k) {
        steps = steps || 200;
        stepSize = stepSize || 3;
        k = k || 1;
        var points = [{ x: startX, y: startY }];
        var x = startX, y = startY;
        for (var i = 0; i < steps; i++) {
            var e = electricField(charges, x, y, k);
            var mag = Math.sqrt(e.x * e.x + e.y * e.y);
            if (mag < 0.0001) break;
            x += direction * stepSize * e.x / mag;
            y += direction * stepSize * e.y / mag;
            if (x < -50 || x > 600 || y < -50 || y > 500) break;
            // Check if too close to any charge
            var tooClose = false;
            for (var j = 0; j < charges.length; j++) {
                var d2 = (x - charges[j].x) * (x - charges[j].x) + (y - charges[j].y) * (y - charges[j].y);
                if (d2 < 200) { tooClose = true; break; }
            }
            if (tooClose) break;
            points.push({ x: x, y: y });
        }
        return points;
    }

    // =====================================================
    //  SKETCH TYPE: coulomb-force
    //  Two charges with force vectors
    // =====================================================
    function coulombForce(containerEl, params) {
        var charges = params.charges || [
            { x: 0.3, y: 0, q: 1, label: 'q₁' },
            { x: 0.7, y: 0, q: 1, label: 'q₂' }
        ];

        return new p5(function(p) {
            var W, H;
            var t = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
                p.frameRate(30);
            };
            p.draw = function() {
                t += 0.03;
                p.background(getBg());
                drawGrid(p, 30);

                // Map charges to pixel coordinates
                var cx = W / 2;
                var cy = H / 2;
                var scale = W * 0.7;
                var pixelCharges = charges.map(function(c) {
                    return {
                        px: cx + (c.x - 0.5) * scale,
                        py: cy + (c.y || 0) * scale,
                        q: c.q,
                        label: c.label
                    };
                });

                // Draw separation line
                if (pixelCharges.length === 2) {
                    var c1 = pixelCharges[0], c2 = pixelCharges[1];
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    drawDashedLine(p, c1.px, c1.py, c2.px, c2.py);

                    // Distance label
                    var midX = (c1.px + c2.px) / 2;
                    var midY = (c1.py + c2.py) / 2;
                    if (params.distance_label) {
                        p.fill(getTextColor());
                        p.noStroke();
                        p.textAlign(p.CENTER, p.CENTER);
                        p.textSize(11);
                        p.text(params.distance_label, midX, midY - 15);
                    }

                    // Force vectors (animated: pulse length)
                    if (params.show_force !== false) {
                        var isRepulsive = (c1.q * c2.q) > 0;
                        var baseFLen = Math.min(60, scale * 0.15);
                        var forceLen = baseFLen + Math.sin(t * 2) * 8;

                        if (isRepulsive) {
                            var angle = p.atan2(c2.py - c1.py, c2.px - c1.px);
                            drawArrow(p, c1.px, c1.py,
                                c1.px - forceLen * Math.cos(angle),
                                c1.py - forceLen * Math.sin(angle),
                                COLORS.force, 3);
                            drawArrow(p, c2.px, c2.py,
                                c2.px + forceLen * Math.cos(angle),
                                c2.py + forceLen * Math.sin(angle),
                                COLORS.force, 3);
                        } else {
                            var angle2 = p.atan2(c2.py - c1.py, c2.px - c1.px);
                            drawArrow(p, c1.px, c1.py,
                                c1.px + forceLen * Math.cos(angle2),
                                c1.py + forceLen * Math.sin(angle2),
                                COLORS.force, 3);
                            drawArrow(p, c2.px, c2.py,
                                c2.px - forceLen * Math.cos(angle2),
                                c2.py - forceLen * Math.sin(angle2),
                                COLORS.force, 3);
                        }

                        // Force label
                        p.fill(COLORS.force);
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.textSize(11);
                        p.textStyle(p.BOLD);
                        var forceLabel = isRepulsive ? 'Repulsive' : 'Attractive';
                        if (params.force_value) forceLabel += ': ' + params.force_value;
                        p.text(forceLabel, midX, midY + 20);
                        p.textStyle(p.NORMAL);
                    }
                }

                // Draw charges with animated glow
                for (var i = 0; i < pixelCharges.length; i++) {
                    var pc = pixelCharges[i];
                    var glowPulse = 18 + Math.sin(t * 2 + i) * 3;
                    // Extra animated glow ring
                    var col = chargeColor(pc.q);
                    p.noFill();
                    p.stroke(p.red(p.color(col)), p.green(p.color(col)), p.blue(p.color(col)), 40 + Math.sin(t * 3) * 20);
                    p.strokeWeight(2);
                    p.ellipse(pc.px, pc.py, glowPulse * 2 + 16, glowPulse * 2 + 16);
                    drawCharge(p, pc.px, pc.py, pc.q, pc.label);
                }

                // Title
                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: electric-field
    //  Point charges with field lines
    // =====================================================
    function electricFieldSketch(containerEl, params) {
        var charges = params.charges || [
            { x: 200, y: 175, q: 1, label: '+q' }
        ];
        var numLines = params.num_lines || 12;

        return new p5(function(p) {
            var W, H;
            var pixelCharges;
            var fieldPaths = [];
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 350;
                p.createCanvas(W, H);
                p.frameRate(30);

                // Scale charges to pixel coords
                var cx = W / 2;
                var cy = H / 2;
                var scale = Math.min(W, H) * 0.7;
                pixelCharges = charges.map(function(c) {
                    var px = c.x <= 1.5 ? cx + (c.x - 0.5) * scale : c.x;
                    var py = c.y <= 1.5 ? cy + (c.y - 0.5) * scale : c.y;
                    return { x: px, y: py, q: c.q, label: c.label };
                });

                // Pre-compute field line paths for animation
                for (var ci = 0; ci < pixelCharges.length; ci++) {
                    var ch = pixelCharges[ci];
                    if (ch.q === 0) continue;
                    var dir = ch.q > 0 ? 1 : -1;
                    for (var li = 0; li < numLines; li++) {
                        var angle = (li / numLines) * p.TWO_PI;
                        var startR = 22;
                        var sx = ch.x + startR * Math.cos(angle);
                        var sy = ch.y + startR * Math.sin(angle);
                        var pts = traceFieldLine(pixelCharges, sx, sy, dir, 300, 2.5, 5000);
                        if (pts.length > 2) fieldPaths.push(pts);
                    }
                }
            };

            p.draw = function() {
                t += 0.02;
                p.background(getBg());
                drawGrid(p, 30);

                // Draw field lines with flowing dots
                for (var fi = 0; fi < fieldPaths.length; fi++) {
                    var pts = fieldPaths[fi];
                    p.noFill();
                    p.stroke(COLORS.field);
                    p.strokeWeight(1.5);
                    p.beginShape();
                    for (var pi = 0; pi < pts.length; pi++) {
                        p.vertex(pts[pi].x, pts[pi].y);
                    }
                    p.endShape();

                    // Arrow at midpoint
                    var mid = Math.floor(pts.length * 0.4);
                    if (mid > 0 && mid < pts.length - 1) {
                        var ax = pts[mid].x;
                        var ay = pts[mid].y;
                        var dx = pts[mid + 1].x - pts[mid - 1].x;
                        var dy = pts[mid + 1].y - pts[mid - 1].y;
                        var a = p.atan2(dy, dx);
                        p.fill(COLORS.field);
                        p.noStroke();
                        p.push();
                        p.translate(ax, ay);
                        p.rotate(a);
                        p.triangle(5, 0, -5, -3.5, -5, 3.5);
                        p.pop();
                    }

                    // Flowing dots along field line
                    var dotCount = 3;
                    for (var di = 0; di < dotCount; di++) {
                        var frac = ((t * 0.8 + di / dotCount + fi * 0.17) % 1.0);
                        var idx = Math.floor(frac * (pts.length - 1));
                        if (idx >= 0 && idx < pts.length) {
                            p.fill(255, 255, 255, 200);
                            p.noStroke();
                            p.ellipse(pts[idx].x, pts[idx].y, 5, 5);
                        }
                    }
                }

                // Draw charges on top
                for (var i = 0; i < pixelCharges.length; i++) {
                    drawCharge(p, pixelCharges[i].x, pixelCharges[i].y,
                        pixelCharges[i].q, pixelCharges[i].label);
                }

                // Title
                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: charge-config
    //  Multiple charges in geometric arrangement
    // =====================================================
    function chargeConfig(containerEl, params) {
        var charges = params.charges || [];
        var testCharge = params.test_charge || null;

        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 350;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.03;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2;
                var cy = H / 2;
                var scale = Math.min(W, H) * 0.6;

                // Map to pixels
                var pxCharges = charges.map(function(c) {
                    return {
                        px: cx + (c.x - 0.5) * scale,
                        py: cy + (c.y - 0.5) * scale,
                        q: c.q,
                        label: c.label,
                        corner: c.corner
                    };
                });

                // Draw connecting lines (geometry)
                p.stroke(getAxisColor());
                p.strokeWeight(1);
                if (params.geometry === 'square' && pxCharges.length >= 4) {
                    for (var i = 0; i < 4; i++) {
                        var next = (i + 1) % 4;
                        drawDashedLine(p, pxCharges[i].px, pxCharges[i].py,
                            pxCharges[next].px, pxCharges[next].py);
                    }
                    p.stroke(getGridColor());
                    drawDashedLine(p, pxCharges[0].px, pxCharges[0].py,
                        pxCharges[2].px, pxCharges[2].py, 4);
                    drawDashedLine(p, pxCharges[1].px, pxCharges[1].py,
                        pxCharges[3].px, pxCharges[3].py, 4);
                }

                // Draw force vectors from test charge (animated pulse)
                if (testCharge) {
                    var tcx = cx + (testCharge.x - 0.5) * scale;
                    var tcy = cy + (testCharge.y - 0.5) * scale;

                    for (var fi = 0; fi < pxCharges.length; fi++) {
                        var fc = pxCharges[fi];
                        var fdx = tcx - fc.px;
                        var fdy = tcy - fc.py;
                        var fdist = Math.sqrt(fdx * fdx + fdy * fdy);
                        if (fdist < 5) continue;
                        var isRepulsive = (testCharge.q * fc.q) > 0;
                        var fdir = isRepulsive ? 1 : -1;
                        var fLen = 35 + Math.sin(t * 2 + fi) * 6;
                        drawArrow(p, tcx, tcy,
                            tcx + fdir * fLen * fdx / fdist,
                            tcy + fdir * fLen * fdy / fdist,
                            COLORS.force, 2);
                    }

                    drawCharge(p, tcx, tcy, testCharge.q, testCharge.label, 12);
                }

                // Draw main charges with animated glow
                for (var ci = 0; ci < pxCharges.length; ci++) {
                    var pc = pxCharges[ci];
                    // Animated glow ring
                    var col = chargeColor(pc.q);
                    var glowR = 22 + Math.sin(t * 2.5 + ci * 1.3) * 4;
                    p.noFill();
                    p.stroke(p.red(p.color(col)), p.green(p.color(col)), p.blue(p.color(col)), 35 + Math.sin(t * 3 + ci) * 15);
                    p.strokeWeight(2);
                    p.ellipse(pc.px, pc.py, glowR * 2, glowR * 2);
                    drawCharge(p, pc.px, pc.py, pc.q, pc.label);
                    if (pc.corner) {
                        p.fill(COLORS.label);
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.textSize(13);
                        p.textStyle(p.BOLD);
                        p.text(pc.corner, pc.px, pc.py - 30);
                        p.textStyle(p.NORMAL);
                    }
                }

                // Net force = 0 label
                if (params.result_label) {
                    p.fill(COLORS.surfaceStroke);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text(params.result_label, cx, H - 20);
                    p.textStyle(p.NORMAL);
                }

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: dipole
    //  Electric dipole with moment vector
    // =====================================================
    function dipoleSketch(containerEl, params) {
        var qPlus = params.positive || { x: 0.35, y: 0.5 };
        var qMinus = params.negative || { x: 0.65, y: 0.5 };
        var showMoment = params.show_moment !== false;
        var showFieldInUniform = params.uniform_field || false;

        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.025;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2;
                var cy = H / 2;
                var scale = Math.min(W, H) * 0.7;

                // Gentle oscillation of dipole angle
                var oscAngle = showFieldInUniform ? Math.sin(t) * 0.06 : 0;
                var cosO = Math.cos(oscAngle);
                var sinO = Math.sin(oscAngle);

                var rawPx = cx + (qPlus.x - 0.5) * scale;
                var rawPy = cy + (qPlus.y - 0.5) * scale;
                var rawMx = cx + (qMinus.x - 0.5) * scale;
                var rawMy = cy + (qMinus.y - 0.5) * scale;

                // Rotate around center
                var midRx = (rawPx + rawMx) / 2;
                var midRy = (rawPy + rawMy) / 2;
                var pxPlus = {
                    x: midRx + (rawPx - midRx) * cosO - (rawPy - midRy) * sinO,
                    y: midRy + (rawPx - midRx) * sinO + (rawPy - midRy) * cosO
                };
                var pxMinus = {
                    x: midRx + (rawMx - midRx) * cosO - (rawMy - midRy) * sinO,
                    y: midRy + (rawMx - midRx) * sinO + (rawMy - midRy) * cosO
                };

                // Uniform field background with flowing arrows
                if (showFieldInUniform) {
                    var spacing = 40;
                    p.stroke(COLORS.fieldFaint);
                    p.strokeWeight(1);
                    for (var fy = spacing; fy < H; fy += spacing) {
                        p.line(20, fy, W - 20, fy);
                        for (var fx = 80; fx < W - 40; fx += 80) {
                            // Flowing arrow position
                            var flowX = fx + ((t * 30) % 80) - 40;
                            if (flowX > 40 && flowX < W - 40) {
                                p.fill(COLORS.fieldFaint);
                                p.noStroke();
                                p.push();
                                p.translate(flowX, fy);
                                p.triangle(5, 0, -4, -3, -4, 3);
                                p.pop();
                                p.stroke(COLORS.fieldFaint);
                                p.strokeWeight(1);
                            }
                        }
                    }

                    p.fill(COLORS.field);
                    p.noStroke();
                    p.textAlign(p.RIGHT);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('E →', W - 15, 25);
                    p.textStyle(p.NORMAL);
                }

                // Draw dipole axis
                p.stroke(getAxisColor());
                p.strokeWeight(1.5);
                drawDashedLine(p, pxMinus.x, pxMinus.y, pxPlus.x, pxPlus.y);

                // Dipole moment vector (from -q to +q)
                if (showMoment) {
                    var mStartX = (pxMinus.x + pxPlus.x) / 2;
                    var mStartY = (pxMinus.y + pxPlus.y) / 2;
                    var mdx = pxPlus.x - pxMinus.x;
                    var mdy = pxPlus.y - pxMinus.y;
                    var mLen = Math.sqrt(mdx * mdx + mdy * mdy);
                    var arrowLen = mLen * 0.6;
                    drawArrow(p, mStartX - mdx / mLen * arrowLen * 0.5, mStartY - mdy / mLen * arrowLen * 0.5,
                        mStartX + mdx / mLen * arrowLen * 0.5, mStartY + mdy / mLen * arrowLen * 0.5,
                        COLORS.surfaceStroke, 3);

                    p.fill(COLORS.surfaceStroke);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('p\u20D7', mStartX, mStartY - 15);
                    p.textStyle(p.NORMAL);
                }

                // Torque arc
                if (showFieldInUniform && params.angle) {
                    p.noFill();
                    p.stroke(COLORS.force);
                    p.strokeWeight(2);
                    var arcR = 50;
                    p.arc(cx, cy, arcR * 2, arcR * 2, 0, -params.angle * Math.PI / 180);
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.text('\u03B8 = ' + params.angle + '\u00B0', cx + arcR + 5, cy - 5);
                }

                // Draw charges with glow
                var glowA = 35 + Math.sin(t * 3) * 15;
                p.noFill();
                p.stroke(p.red(p.color(COLORS.positive)), p.green(p.color(COLORS.positive)), p.blue(p.color(COLORS.positive)), glowA);
                p.strokeWeight(2);
                p.ellipse(pxPlus.x, pxPlus.y, 48, 48);
                drawCharge(p, pxPlus.x, pxPlus.y, 1, params.positive_label || '+q');

                p.noFill();
                p.stroke(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), glowA);
                p.strokeWeight(2);
                p.ellipse(pxMinus.x, pxMinus.y, 48, 48);
                drawCharge(p, pxMinus.x, pxMinus.y, -1, params.negative_label || '\u2212q');

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: flux-surface
    //  Gaussian surface with field arrows and flux
    // =====================================================
    function fluxSurface(containerEl, params) {
        var surfaceType = params.surface_type || 'square';
        var fieldDir = params.field_direction || 'right';
        var normalAngle = params.normal_angle || 0;

        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.025;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2;
                var cy = H / 2;

                // Animated flowing field arrows
                var arrowSpacing = 50;
                var flowOffset = (t * 40) % 70;
                for (var ay = cy - 100; ay <= cy + 100; ay += arrowSpacing) {
                    for (var ax = -30 + flowOffset; ax < W + 10; ax += 70) {
                        var x1 = Math.max(10, ax);
                        var x2 = Math.min(W - 10, ax + 40);
                        if (x2 > x1 + 10) {
                            drawArrow(p, x1, ay, x2, ay, COLORS.fieldFaint, 1.5);
                        }
                    }
                }
                p.fill(COLORS.field);
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('E\u20D7 \u2192', 10, 25);
                p.textStyle(p.NORMAL);

                if (surfaceType === 'square') {
                    var size = 120;
                    // Pulsing surface glow
                    var surfAlpha = 0.2 + Math.sin(t * 2) * 0.08;
                    p.push();
                    p.translate(cx, cy);
                    p.rotate(normalAngle * Math.PI / 180);

                    p.fill('rgba(34, 197, 94, ' + surfAlpha + ')');
                    p.stroke(COLORS.surfaceStroke);
                    p.strokeWeight(2);
                    p.rectMode(p.CENTER);
                    p.rect(0, 0, size, size, 4);

                    drawArrow(p, 0, 0, 70, 0, COLORS.surfaceStroke, 2.5);
                    p.fill(COLORS.surfaceStroke);
                    p.noStroke();
                    p.textSize(11);
                    p.text('n\u0302', 75, -5);

                    p.pop();

                    if (normalAngle !== 0) {
                        p.noFill();
                        p.stroke(COLORS.force);
                        p.strokeWeight(1.5);
                        p.arc(cx, cy, 60, 60, 0, -normalAngle * Math.PI / 180);
                        p.fill(COLORS.force);
                        p.noStroke();
                        p.textSize(11);
                        p.text('\u03B8=' + normalAngle + '\u00B0', cx + 35, cy - 10);
                    }

                    if (params.flux_label) {
                        p.fill(getTextColor());
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.textSize(12);
                        p.text(params.flux_label, cx, H - 15);
                    }

                } else if (surfaceType === 'cube') {
                    var s = 100;
                    var depth = 40;

                    p.fill(COLORS.surface);
                    p.stroke(COLORS.surfaceStroke);
                    p.strokeWeight(1);
                    p.quad(cx - s / 2 + depth, cy - s / 2 - depth,
                           cx + s / 2 + depth, cy - s / 2 - depth,
                           cx + s / 2 + depth, cy + s / 2 - depth,
                           cx - s / 2 + depth, cy + s / 2 - depth);

                    p.fill(COLORS.surface);
                    p.quad(cx - s / 2, cy - s / 2,
                           cx + s / 2, cy - s / 2,
                           cx + s / 2 + depth, cy - s / 2 - depth,
                           cx - s / 2 + depth, cy - s / 2 - depth);

                    p.quad(cx + s / 2, cy - s / 2,
                           cx + s / 2, cy + s / 2,
                           cx + s / 2 + depth, cy + s / 2 - depth,
                           cx + s / 2 + depth, cy - s / 2 - depth);

                    p.strokeWeight(2);
                    p.fill(COLORS.surface);
                    p.rect(cx - s / 2, cy - s / 2, s, s, 2);

                    // Animated entry/exit arrows (pulsing)
                    var arrowPulse = 50 + Math.sin(t * 2) * 8;
                    drawArrow(p, cx - s / 2 - arrowPulse, cy, cx - s / 2 - 5, cy, COLORS.field, 2);
                    drawArrow(p, cx + s / 2 + 5, cy, cx + s / 2 + arrowPulse, cy, COLORS.field, 2);

                    // Flowing dots through the cube
                    for (var di = 0; di < 3; di++) {
                        var dotFrac = ((t * 0.6 + di / 3) % 1.0);
                        var dotX = (cx - s / 2 - 50) + dotFrac * (s + 100);
                        var dotYs = [cy - 20, cy, cy + 20];
                        p.fill(255, 255, 255, 180);
                        p.noStroke();
                        p.ellipse(dotX, dotYs[di], 5, 5);
                    }

                    p.fill(COLORS.field);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(10);
                    p.text('\u03A6 in', cx - s / 2 - 25, cy - 15);
                    p.text('\u03A6 out', cx + s / 2 + 25, cy - 15);

                    if (params.result_label) {
                        p.fill(COLORS.surfaceStroke);
                        p.textSize(13);
                        p.textStyle(p.BOLD);
                        p.text(params.result_label, cx, H - 15);
                        p.textStyle(p.NORMAL);
                    }

                } else if (surfaceType === 'sphere') {
                    var r = 70;
                    // Pulsing Gaussian sphere
                    var pulseR = r + Math.sin(t * 2) * 3;
                    p.fill(COLORS.surface);
                    p.stroke(COLORS.surfaceStroke);
                    p.strokeWeight(2);
                    p.ellipse(cx, cy, pulseR * 2, pulseR * 2);

                    if (params.charge) {
                        drawCharge(p, cx, cy, params.charge.q, params.charge.label, 14);
                    }

                    // Outward arrows with flowing dots
                    var nArrows = 8;
                    for (var ai = 0; ai < nArrows; ai++) {
                        var a = (ai / nArrows) * p.TWO_PI;
                        var innerR = pulseR + 5;
                        var outerR = pulseR + 35;
                        drawArrow(p,
                            cx + innerR * Math.cos(a), cy + innerR * Math.sin(a),
                            cx + outerR * Math.cos(a), cy + outerR * Math.sin(a),
                            COLORS.field, 2);

                        // Flowing dot on each ray
                        var dotR = innerR + ((t * 30 + ai * 5) % (outerR - innerR));
                        p.fill(255, 255, 255, 200);
                        p.noStroke();
                        p.ellipse(cx + dotR * Math.cos(a), cy + dotR * Math.sin(a), 4, 4);
                    }

                    if (params.flux_label) {
                        p.fill(getTextColor());
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.textSize(12);
                        p.text(params.flux_label, cx, H - 15);
                    }
                }

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: parallel-plates
    //  Two charged plates with E field between
    // =====================================================
    function parallelPlates(containerEl, params) {
        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.025;
                p.background(getBg());
                drawGrid(p, 30);

                var leftX = W * 0.3;
                var rightX = W * 0.7;
                var plateTop = 40;
                var plateBot = H - 40;

                // Left plate (positive)
                p.stroke(COLORS.positive);
                p.strokeWeight(4);
                p.line(leftX, plateTop, leftX, plateBot);
                p.fill(COLORS.positive);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(16);
                for (var py = plateTop + 25; py < plateBot - 10; py += 35) {
                    p.text('+', leftX - 15, py);
                }

                // Right plate (negative)
                p.stroke(COLORS.negative);
                p.strokeWeight(4);
                p.line(rightX, plateTop, rightX, plateBot);
                p.fill(COLORS.negative);
                p.noStroke();
                for (var py2 = plateTop + 25; py2 < plateBot - 10; py2 += 35) {
                    p.text('\u2212', rightX + 15, py2);
                }

                // E field arrows between plates
                var arrowY;
                for (arrowY = plateTop + 30; arrowY < plateBot - 20; arrowY += 40) {
                    drawArrow(p, leftX + 15, arrowY, rightX - 15, arrowY, COLORS.field, 1.5);
                }

                // Flowing dots along E field
                var plateDist = rightX - leftX - 30;
                for (arrowY = plateTop + 30; arrowY < plateBot - 20; arrowY += 40) {
                    for (var di = 0; di < 3; di++) {
                        var frac = ((t * 0.7 + di / 3 + arrowY * 0.003) % 1.0);
                        var dotX = leftX + 15 + frac * plateDist;
                        p.fill(255, 255, 255, 200);
                        p.noStroke();
                        p.ellipse(dotX, arrowY, 5, 5);
                    }
                }

                // E label
                p.fill(COLORS.field);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('E\u20D7', (leftX + rightX) / 2, plateTop + 15);
                p.textStyle(p.NORMAL);

                // Region labels
                p.fill(getTextColor());
                p.textSize(11);
                p.textAlign(p.CENTER);
                p.text('E = 0', leftX / 2, H / 2);
                p.text('E = \u03C3/\u03B5\u2080', (leftX + rightX) / 2, plateBot + 5);
                p.text('E = 0', rightX + (W - rightX) / 2, H / 2);

                // Plate labels
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.fill(COLORS.positive);
                p.text('+\u03C3', leftX, plateTop - 10);
                p.fill(COLORS.negative);
                p.text('\u2212\u03C3', rightX, plateTop - 10);
                p.textStyle(p.NORMAL);

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 15);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: conducting-sphere
    //  Charged conducting sphere with external field
    // =====================================================
    function conductingSphere(containerEl, params) {
        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 320;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.025;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2;
                var cy = H / 2;
                var R = params.sphere_radius || 60;
                var isNegative = params.charge_sign === 'negative';

                // Sphere with subtle breathing
                var sphereColor = isNegative ? COLORS.negative : COLORS.positive;
                var breathR = R + Math.sin(t * 1.5) * 2;
                p.fill(p.red(p.color(sphereColor)), p.green(p.color(sphereColor)), p.blue(p.color(sphereColor)), 30);
                p.stroke(sphereColor);
                p.strokeWeight(2);
                p.ellipse(cx, cy, breathR * 2, breathR * 2);

                // Surface charges with shimmer
                var nSurface = 10;
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(12);
                for (var si = 0; si < nSurface; si++) {
                    var sa = (si / nSurface) * p.TWO_PI + Math.sin(t * 0.5) * 0.03;
                    var sx = cx + (breathR - 2) * Math.cos(sa);
                    var sy = cy + (breathR - 2) * Math.sin(sa);
                    var shimmer = 180 + Math.sin(t * 4 + si * 1.2) * 75;
                    p.fill(p.red(p.color(sphereColor)), p.green(p.color(sphereColor)), p.blue(p.color(sphereColor)), shimmer);
                    p.noStroke();
                    p.text(isNegative ? '\u2212' : '+', sx, sy);
                }

                // Field lines outside with flowing dots
                var nLines = 10;
                var dir = isNegative ? -1 : 1;
                for (var li = 0; li < nLines; li++) {
                    var la = (li / nLines) * p.TWO_PI;
                    var fromR = breathR + 8;
                    var toR = breathR + 60;
                    var fx = cx + fromR * Math.cos(la);
                    var fy = cy + fromR * Math.sin(la);
                    var tx = cx + toR * Math.cos(la);
                    var ty = cy + toR * Math.sin(la);

                    if (dir > 0) {
                        drawArrow(p, fx, fy, tx, ty, COLORS.field, 1.5);
                    } else {
                        drawArrow(p, tx, ty, fx, fy, COLORS.field, 1.5);
                    }

                    // Flowing dot on each ray
                    var dotR = fromR + ((t * 25 + li * 6) % (toR - fromR));
                    p.fill(255, 255, 255, 200);
                    p.noStroke();
                    p.ellipse(cx + dotR * Math.cos(la), cy + dotR * Math.sin(la), 4, 4);
                }

                // E = 0 inside
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('E = 0', cx, cy);
                p.textStyle(p.NORMAL);

                // Observation point
                if (params.observation_point) {
                    var op = params.observation_point;
                    var opx = cx + op.r * Math.cos(op.angle || 0);
                    var opy = cy + op.r * Math.sin(op.angle || 0);
                    p.fill(COLORS.force);
                    p.stroke(255);
                    p.strokeWeight(1.5);
                    p.ellipse(opx, opy, 10, 10);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.LEFT);
                    p.text(op.label || 'P', opx + 8, opy + 4);
                }

                // Radius labels
                if (params.show_radius) {
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    drawDashedLine(p, cx, cy, cx + R, cy);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.CENTER);
                    p.text('R', cx + R / 2, cy - 10);
                }

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: particle-tracks
    //  Charged particles deflecting in uniform field
    // =====================================================
    function particleTracks(containerEl, params) {
        var particles = params.particles || [
            { label: '1', q_sign: 1, curvature: 0.3 },
            { label: '2', q_sign: -1, curvature: 0.8 },
            { label: '3', q_sign: -1, curvature: 0.15 }
        ];

        return new p5(function(p) {
            var W, H;
            var t = 0;
            var trackPaths = [];

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 320;
                p.createCanvas(W, H);
                p.frameRate(30);

                // Pre-compute track paths
                var fieldDown = params.field_direction === 'down';
                var startX = 40;
                var spacing = H / (particles.length + 1);
                for (var pi = 0; pi < particles.length; pi++) {
                    var part = particles[pi];
                    var startY = spacing * (pi + 1);
                    var curv = part.curvature;
                    var deflection = part.q_sign > 0 ? 1 : -1;
                    if (fieldDown) deflection = -deflection;
                    var pts = [];
                    for (var tt = 0; tt < W - 80; tt += 3) {
                        var x = startX + tt;
                        var y = startY + deflection * curv * (tt * tt) / (W * 2);
                        if (y < 10 || y > H - 10) break;
                        pts.push({ x: x, y: y });
                    }
                    trackPaths.push(pts);
                }
            };

            p.draw = function() {
                t += 0.015;
                p.background(getBg());
                drawGrid(p, 30);

                // Field arrows
                var fieldDown = params.field_direction === 'down';
                if (fieldDown) {
                    for (var fx = 60; fx < W - 40; fx += 80) {
                        drawArrow(p, fx, 30, fx, H - 30, COLORS.fieldFaint, 1);
                    }
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.LEFT);
                    p.text('E\u20D7 \u2193', 10, 25);
                } else {
                    for (var fy = 60; fy < H - 40; fy += 60) {
                        drawArrow(p, 30, fy, W - 30, fy, COLORS.fieldFaint, 1);
                    }
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.textSize(12);
                    p.textAlign(p.LEFT);
                    p.text('E\u20D7 \u2192', 10, 25);
                }

                // Draw tracks with animated particle dot
                var trackColors = ['#ef4444', '#3b82f6', '#22c55e', '#f59e0b'];
                var startX = 40;
                var spacing = H / (particles.length + 1);

                for (var pi = 0; pi < particles.length; pi++) {
                    var part = particles[pi];
                    var startY = spacing * (pi + 1);
                    var col = trackColors[pi % trackColors.length];
                    var pts = trackPaths[pi];

                    // Draw full track (faded trail)
                    p.noFill();
                    p.stroke(p.red(p.color(col)), p.green(p.color(col)), p.blue(p.color(col)), 80);
                    p.strokeWeight(1.5);
                    p.beginShape();
                    for (var vi = 0; vi < pts.length; vi++) {
                        p.vertex(pts[vi].x, pts[vi].y);
                    }
                    p.endShape();

                    // Animated particle position (loops along the track)
                    var particleFrac = ((t * 0.8 + pi * 0.3) % 1.0);
                    var particleIdx = Math.floor(particleFrac * (pts.length - 1));

                    // Draw bright portion of track up to particle
                    p.noFill();
                    p.stroke(col);
                    p.strokeWeight(2.5);
                    p.beginShape();
                    for (var bi = 0; bi <= particleIdx && bi < pts.length; bi++) {
                        p.vertex(pts[bi].x, pts[bi].y);
                    }
                    p.endShape();

                    // Particle dot with glow
                    if (particleIdx < pts.length) {
                        var px = pts[particleIdx].x;
                        var ppy = pts[particleIdx].y;
                        p.fill(p.red(p.color(col)), p.green(p.color(col)), p.blue(p.color(col)), 60);
                        p.noStroke();
                        p.ellipse(px, ppy, 16, 16);
                        p.fill(col);
                        p.stroke(255);
                        p.strokeWeight(1.5);
                        p.ellipse(px, ppy, 8, 8);
                    }

                    // Particle label
                    p.fill(col);
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text(part.label, startX - 25, startY + 4);

                    if (part.qm_label) {
                        p.textSize(9);
                        p.textStyle(p.NORMAL);
                        p.text(part.qm_label, startX - 25, startY + 16);
                    }
                    p.textStyle(p.NORMAL);
                }

                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, H - 10);
                    p.textStyle(p.NORMAL);
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: rubbing-charges
    //  Charging by friction visualization
    // =====================================================
    function rubbingCharges(containerEl, params) {
        return new p5(function(p) {
            var W, H;
            var t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 260;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function() {
                t += 0.025;
                p.background(getBg());

                var mid = W / 2;
                var halfW = W * 0.35;
                var objH = 80;

                // Before rubbing
                var beforeY = 50;
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('Before Rubbing', mid, beforeY - 10);
                p.textStyle(p.NORMAL);

                // Glass rod (neutral) — gentle wobble to indicate rubbing
                var wobble = Math.sin(t * 4) * 3;
                p.fill(isDark() ? '#374151' : '#e5e7eb');
                p.stroke(getAxisColor());
                p.strokeWeight(1.5);
                p.rectMode(p.CENTER);
                p.rect(mid - halfW * 0.4 + wobble, beforeY + objH / 2, halfW * 0.6, objH, 8);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(10);
                p.text('Glass Rod', mid - halfW * 0.4, beforeY + objH + 18);
                p.text('(Neutral)', mid - halfW * 0.4, beforeY + objH + 30);

                // Silk (neutral) — opposite wobble
                p.fill(isDark() ? '#374151' : '#e5e7eb');
                p.stroke(getAxisColor());
                p.strokeWeight(1.5);
                p.rect(mid + halfW * 0.4 - wobble, beforeY + objH / 2, halfW * 0.6, objH, 8);
                p.fill(getTextColor());
                p.noStroke();
                p.text('Silk Cloth', mid + halfW * 0.4, beforeY + objH + 18);
                p.text('(Neutral)', mid + halfW * 0.4, beforeY + objH + 30);

                // Rubbing arrow (animated)
                var arrowY = beforeY + objH / 2;
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(20);
                var rubSymbol = Math.sin(t * 3) > 0 ? '\u21C6' : '\u21C4';
                p.text(rubSymbol, mid, arrowY);

                // After rubbing
                var afterY = H - objH - 30;
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('After Rubbing', mid, afterY - 10);
                p.textStyle(p.NORMAL);

                // Glass rod (positive) with pulsing glow
                var posAlpha = 25 + Math.sin(t * 2) * 10;
                p.fill(p.red(p.color(COLORS.positive)), p.green(p.color(COLORS.positive)), p.blue(p.color(COLORS.positive)), posAlpha);
                p.stroke(COLORS.positive);
                p.strokeWeight(2);
                p.rect(mid - halfW * 0.4, afterY + objH / 2, halfW * 0.6, objH, 8);
                p.fill(COLORS.positive);
                p.noStroke();
                p.textSize(16);
                p.text('+ + +', mid - halfW * 0.4, afterY + objH / 2);
                p.textSize(10);
                p.fill(getTextColor());
                p.text('Glass (+Q)', mid - halfW * 0.4, afterY + objH + 18);

                // Silk (negative) with pulsing glow
                var negAlpha = 25 + Math.sin(t * 2 + Math.PI) * 10;
                p.fill(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), negAlpha);
                p.stroke(COLORS.negative);
                p.strokeWeight(2);
                p.rect(mid + halfW * 0.4, afterY + objH / 2, halfW * 0.6, objH, 8);
                p.fill(COLORS.negative);
                p.noStroke();
                p.textSize(16);
                p.text('\u2212 \u2212 \u2212', mid + halfW * 0.4, afterY + objH / 2);
                p.textSize(10);
                p.fill(getTextColor());
                p.text('Silk (\u2212Q)', mid + halfW * 0.4, afterY + objH + 18);

                // Animated electron transfer — flowing dots from glass to silk
                var transferY = (beforeY + objH + afterY) / 2;
                drawArrow(p, mid - halfW * 0.1, transferY,
                    mid + halfW * 0.1, transferY,
                    COLORS.negative, 2);

                // Flowing electron dots
                var transferStart = mid - halfW * 0.1;
                var transferEnd = mid + halfW * 0.1;
                var transferDist = transferEnd - transferStart;
                for (var ei = 0; ei < 3; ei++) {
                    var eFrac = ((t * 1.2 + ei / 3) % 1.0);
                    var ex = transferStart + eFrac * transferDist;
                    p.fill(COLORS.negative);
                    p.noStroke();
                    p.ellipse(ex, transferY, 6, 6);
                    p.fill(255);
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(7);
                    p.text('\u2212', ex, transferY);
                }

                p.fill(COLORS.negative);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(9);
                p.text('e\u207B transfer', mid, transferY - 10);

                // Conservation note
                p.fill(COLORS.surfaceStroke);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('Total charge: +Q + (\u2212Q) = 0  \u2713  Charge conserved', mid, H - 8);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: simple-circuit
    //  Battery + resistor loop with animated current dots
    // =====================================================
    function simpleCircuit(containerEl, params) {
        var emf = params.emf || 12;
        var intR = params.internal_resistance || 0.4;
        var extR = params.external_resistance || 0;
        var currentVal = params.current || (emf / (intR + extR));
        var label_emf = params.label_emf || (emf + ' V');
        var label_r = params.label_r || (intR + ' Ω');
        var label_R = params.label_R || (extR > 0 ? extR + ' Ω' : '');
        var label_I = params.label_I || (currentVal.toFixed(1) + ' A');
        var showExtR = extR > 0;

        return new p5(function(p) {
            var W, H, t = 0;
            var path = []; // circuit path points for dot animation

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
                // Build rectangular circuit path (clockwise from top-left)
                var mx = W * 0.15, my = H * 0.18;
                var mw = W * 0.7, mh = H * 0.6;
                var segs = 80;
                // top: left to right
                for (var i = 0; i <= segs; i++) path.push({ x: mx + mw * (i / segs), y: my });
                // right: top to bottom
                for (var i = 1; i <= segs; i++) path.push({ x: mx + mw, y: my + mh * (i / segs) });
                // bottom: right to left
                for (var i = 1; i <= segs; i++) path.push({ x: mx + mw - mw * (i / segs), y: my + mh });
                // left: bottom to top
                for (var i = 1; i < segs; i++) path.push({ x: mx, y: my + mh - mh * (i / segs) });
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.02;

                var mx = W * 0.15, my = H * 0.18;
                var mw = W * 0.7, mh = H * 0.6;

                // Draw wires
                p.stroke(getTextColor());
                p.strokeWeight(2.5);
                p.noFill();
                p.rect(mx, my, mw, mh, 4);

                // Battery (left side, vertical)
                var bx = mx;
                var bcy = my + mh * 0.4;
                // Clear wire behind battery
                p.stroke(getBg());
                p.strokeWeight(6);
                p.line(bx, bcy - 18, bx, bcy + 18);
                // Long line (positive)
                p.stroke(COLORS.positive);
                p.strokeWeight(3);
                p.line(bx - 14, bcy - 10, bx + 14, bcy - 10);
                // Short line (negative)
                p.strokeWeight(5);
                p.line(bx - 8, bcy + 10, bx + 8, bcy + 10);
                // Labels
                p.fill(COLORS.positive);
                p.noStroke();
                p.textAlign(p.RIGHT, p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('E = ' + label_emf, bx - 18, bcy);
                p.textStyle(p.NORMAL);
                p.text('+', bx - 18, bcy - 12);
                p.text('−', bx - 18, bcy + 12);

                // Internal resistance (below battery on left side)
                var iry = my + mh * 0.7;
                p.stroke(COLORS.neutral);
                p.strokeWeight(2);
                p.noFill();
                // Zigzag
                var zw = 8, zn = 4;
                p.stroke(getBg()); p.strokeWeight(6);
                p.line(bx, iry - zn * 6, bx, iry + zn * 6);
                p.stroke(COLORS.neutral); p.strokeWeight(2);
                p.beginShape();
                p.vertex(bx, iry - zn * 6);
                for (var zi = 0; zi < zn; zi++) {
                    p.vertex(bx + zw, iry - zn * 6 + (zi * 2 + 1) * 6);
                    p.vertex(bx - zw, iry - zn * 6 + (zi * 2 + 2) * 6);
                }
                p.vertex(bx, iry + zn * 6);
                p.endShape();
                p.fill(COLORS.neutral);
                p.noStroke();
                p.textAlign(p.RIGHT, p.CENTER);
                p.textSize(11);
                p.text('r = ' + label_r, bx - 18, iry);

                // External resistor (right side, if present)
                if (showExtR) {
                    var rx = mx + mw;
                    var rcy = my + mh * 0.5;
                    p.stroke(getBg()); p.strokeWeight(6);
                    p.line(rx, rcy - zn * 6, rx, rcy + zn * 6);
                    p.stroke(COLORS.field); p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    p.vertex(rx, rcy - zn * 6);
                    for (var zi = 0; zi < zn; zi++) {
                        p.vertex(rx + zw, rcy - zn * 6 + (zi * 2 + 1) * 6);
                        p.vertex(rx - zw, rcy - zn * 6 + (zi * 2 + 2) * 6);
                    }
                    p.vertex(rx, rcy + zn * 6);
                    p.endShape();
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.textAlign(p.LEFT, p.CENTER);
                    p.textSize(11);
                    p.text('R = ' + label_R, rx + 18, rcy);
                }

                // Animated current dots
                var speed = Math.min(currentVal / 10, 3);
                var nDots = 12;
                var total = path.length;
                p.fill(COLORS.force);
                p.noStroke();
                for (var di = 0; di < nDots; di++) {
                    var idx = Math.floor((t * speed * 40 + di * total / nDots) % total);
                    if (idx < 0) idx += total;
                    p.ellipse(path[idx].x, path[idx].y, 8, 8);
                }

                // Current label (top)
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.textAlign(p.CENTER, p.BOTTOM);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text('I = ' + label_I, mx + mw / 2, my - 6);
                p.textStyle(p.NORMAL);

                // Arrow on top wire
                drawArrow(p, mx + mw * 0.35, my, mx + mw * 0.6, my, COLORS.surfaceStroke, 2);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: drift-velocity
    //  Wire cross-section with electrons drifting
    // =====================================================
    function driftVelocity(containerEl, params) {
        var wireLength = params.wire_length || 3.0;
        var current = params.current || 3.0;
        var nElectrons = params.num_electrons || 30;
        var label_vd = params.label_vd || '1.1 × 10⁻⁴ m/s';
        var label_time = params.label_time || '≈ 2.7 × 10⁴ s (7.6 hrs)';

        return new p5(function(p) {
            var W, H, electrons = [], t = 0;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 260;
                p.createCanvas(W, H);
                // Create random electron positions inside wire
                var wx1 = W * 0.1, wx2 = W * 0.9;
                var wy1 = H * 0.3, wy2 = H * 0.65;
                for (var i = 0; i < nElectrons; i++) {
                    electrons.push({
                        x: p.random(wx1, wx2),
                        y: p.random(wy1, wy2),
                        jx: p.random(-0.5, 0.5),
                        jy: p.random(-0.5, 0.5)
                    });
                }
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 1;

                var wx1 = W * 0.1, wx2 = W * 0.9;
                var wy1 = H * 0.3, wy2 = H * 0.65;
                var wireW = wx2 - wx1;
                var wireH = wy2 - wy1;

                // Wire body
                p.fill(isDark() ? 'rgba(180,120,60,0.15)' : 'rgba(180,120,60,0.1)');
                p.stroke(isDark() ? '#b87333' : '#a0522d');
                p.strokeWeight(2);
                p.rect(wx1, wy1, wireW, wireH, 6);

                // + and - terminals
                p.fill(COLORS.positive);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(18);
                p.textStyle(p.BOLD);
                p.text('+', wx2 + 20, (wy1 + wy2) / 2);
                p.fill(COLORS.negative);
                p.text('−', wx1 - 20, (wy1 + wy2) / 2);
                p.textStyle(p.NORMAL);

                // Electric field arrow (right to left inside wire — conventional)
                drawArrow(p, wx2 - 30, wy1 - 15, wx1 + 30, wy1 - 15, COLORS.field, 2);
                p.fill(COLORS.field);
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text('E field', (wx1 + wx2) / 2, wy1 - 18);

                // Move and draw electrons
                var driftSpeed = 0.3; // pixels per frame (slow!)
                p.fill(COLORS.negative);
                p.noStroke();
                for (var i = 0; i < electrons.length; i++) {
                    var e = electrons[i];
                    // Random thermal jitter + slow leftward drift
                    e.x += p.random(-1.2, 1.2) - driftSpeed;
                    e.y += p.random(-1.0, 1.0);
                    // Wrap around
                    if (e.x < wx1) e.x = wx2;
                    if (e.x > wx2) e.x = wx1;
                    if (e.y < wy1 + 4) e.y = wy1 + 4;
                    if (e.y > wy2 - 4) e.y = wy2 - 4;
                    p.ellipse(e.x, e.y, 7, 7);
                    // e⁻ label on first few
                    if (i < 3) {
                        p.textSize(7);
                        p.textAlign(p.CENTER);
                        p.fill(255);
                        p.text('e⁻', e.x, e.y + 1);
                        p.fill(COLORS.negative);
                    }
                }

                // Drift velocity arrow
                drawArrow(p, (wx1 + wx2) / 2 + 40, wy2 + 20, (wx1 + wx2) / 2 - 40, wy2 + 20, COLORS.surfaceStroke, 2.5);
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.textAlign(p.CENTER, p.TOP);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('v_d = ' + label_vd, (wx1 + wx2) / 2, wy2 + 30);
                p.textStyle(p.NORMAL);
                p.textSize(11);
                p.text('Drift time ≈ ' + label_time, (wx1 + wx2) / 2, wy2 + 46);

                // Conventional current arrow (opposite to electron drift)
                drawArrow(p, (wx1 + wx2) / 2 - 40, wy1 - 4, (wx1 + wx2) / 2 + 40, wy1 - 4, COLORS.force, 2);
                p.fill(COLORS.force);
                p.textSize(10);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text('I (conventional)', (wx1 + wx2) / 2, wy1 - 6);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text('Electron Drift in a Conductor', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: resistance-temperature
    //  Interactive R vs T linear graph
    // =====================================================
    function resistanceTemperature(containerEl, params) {
        var R0 = params.R0 || 100;
        var T0 = params.T0 || 27;
        var alpha = params.alpha || 1.7e-4;
        var R_final = params.R_final || 117;
        var T_final = params.T_final || 1027;
        var title = params.title || 'Resistance vs Temperature';

        return new p5(function(p) {
            var W, H;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
                p.noLoop();
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);

                var padL = 70, padR = 40, padT = 50, padB = 55;
                var gw = W - padL - padR;
                var gh = H - padT - padB;

                // Temperature range
                var Tmin = 0, Tmax = T_final * 1.15;
                var Rmin = R0 * (1 + alpha * (Tmin - T0));
                var Rmax = R0 * (1 + alpha * (Tmax - T0));

                function mapT(T) { return padL + (T - Tmin) / (Tmax - Tmin) * gw; }
                function mapR(R) { return padT + gh - (R - Rmin) / (Rmax - Rmin) * gh; }

                // Axes
                p.stroke(getAxisColor());
                p.strokeWeight(1.5);
                p.line(padL, padT, padL, padT + gh);
                p.line(padL, padT + gh, padL + gw, padT + gh);

                // Axis labels
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(11);
                p.text('Temperature (°C)', padL + gw / 2, H - 8);
                p.push();
                p.translate(15, padT + gh / 2);
                p.rotate(-p.HALF_PI);
                p.text('Resistance (Ω)', 0, 0);
                p.pop();

                // Tick marks
                p.textSize(9);
                p.fill(getTextColor());
                var nTicksX = 5;
                for (var i = 0; i <= nTicksX; i++) {
                    var Tv = Tmin + i * (Tmax - Tmin) / nTicksX;
                    var tx = mapT(Tv);
                    p.stroke(getAxisColor());
                    p.line(tx, padT + gh, tx, padT + gh + 4);
                    p.noStroke();
                    p.textAlign(p.CENTER, p.TOP);
                    p.text(Math.round(Tv), tx, padT + gh + 6);
                }
                var nTicksY = 5;
                for (var i = 0; i <= nTicksY; i++) {
                    var Rv = Rmin + i * (Rmax - Rmin) / nTicksY;
                    var ry = mapR(Rv);
                    p.stroke(getAxisColor());
                    p.line(padL - 4, ry, padL, ry);
                    p.noStroke();
                    p.textAlign(p.RIGHT, p.CENTER);
                    p.text(Rv.toFixed(1), padL - 8, ry);
                }

                // Line R = R0(1 + alpha(T - T0))
                p.stroke(COLORS.positive);
                p.strokeWeight(2.5);
                p.noFill();
                p.beginShape();
                for (var px = 0; px <= 100; px++) {
                    var Tv = Tmin + px / 100 * (Tmax - Tmin);
                    var Rv = R0 * (1 + alpha * (Tv - T0));
                    p.vertex(mapT(Tv), mapR(Rv));
                }
                p.endShape();

                // Mark initial point
                p.fill(COLORS.surfaceStroke);
                p.stroke(255);
                p.strokeWeight(2);
                p.ellipse(mapT(T0), mapR(R0), 10, 10);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.LEFT);
                p.text('(' + T0 + '°C, ' + R0 + ' Ω)', mapT(T0) + 8, mapR(R0) - 8);

                // Mark final point
                p.fill(COLORS.force);
                p.stroke(255);
                p.strokeWeight(2);
                p.ellipse(mapT(T_final), mapR(R_final), 10, 10);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.RIGHT);
                p.text('(' + T_final + '°C, ' + R_final + ' Ω)', mapT(T_final) - 8, mapR(R_final) - 8);

                // Dashed lines to axes for final point
                p.stroke(COLORS.force);
                p.strokeWeight(1);
                drawDashedLine(p, mapT(T_final), mapR(R_final), mapT(T_final), padT + gh);
                drawDashedLine(p, mapT(T_final), mapR(R_final), padL, mapR(R_final));

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(title, W / 2, 20);
                p.textStyle(p.NORMAL);

                // Formula
                p.textSize(11);
                p.fill(COLORS.positive);
                p.text('R = R₀(1 + α ΔT)', W / 2, 36);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: kirchhoff-network
    //  Wheatstone bridge with animated branch currents
    // =====================================================
    function kirchhoffNetwork(containerEl, params) {
        var resistors = params.resistors || { AB: 10, BC: 5, AD: 5, DC: 10, BD: 5 };
        var emf = params.emf || 10;

        return new p5(function(p) {
            var W, H, t = 0;
            var nodes = {};

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 360;
                p.createCanvas(W, H);
                // Node positions
                nodes.A = { x: W * 0.12, y: H * 0.5 };
                nodes.B = { x: W * 0.5, y: H * 0.12 };
                nodes.C = { x: W * 0.88, y: H * 0.5 };
                nodes.D = { x: W * 0.5, y: H * 0.85 };
            };

            function drawZigzag(x1, y1, x2, y2, color, label) {
                var mx = (x1 + x2) / 2;
                var my = (y1 + y2) / 2;
                var dx = x2 - x1;
                var dy = y2 - y1;
                var len = Math.sqrt(dx * dx + dy * dy);
                var ux = dx / len, uy = dy / len;
                var nx = -uy, ny = ux;
                var zLen = Math.min(len * 0.4, 50);
                var zStart = 0.5 - zLen / (2 * len);
                var zEnd = 0.5 + zLen / (2 * len);

                // Wire segments
                p.stroke(getTextColor());
                p.strokeWeight(2);
                p.line(x1, y1, x1 + dx * zStart, y1 + dy * zStart);
                p.line(x1 + dx * zEnd, y1 + dy * zEnd, x2, y2);

                // Zigzag part
                p.stroke(color);
                p.strokeWeight(2);
                p.noFill();
                var nz = 4, amp = 8;
                p.beginShape();
                p.vertex(x1 + dx * zStart, y1 + dy * zStart);
                for (var i = 0; i < nz; i++) {
                    var t1 = zStart + (i * 2 + 1) / (nz * 2) * (zEnd - zStart);
                    var t2 = zStart + (i * 2 + 2) / (nz * 2) * (zEnd - zStart);
                    var sign = (i % 2 === 0) ? 1 : -1;
                    p.vertex(x1 + dx * t1 + nx * amp * sign, y1 + dy * t1 + ny * amp * sign);
                    p.vertex(x1 + dx * t2 - nx * amp * sign, y1 + dy * t2 - ny * amp * sign);
                }
                p.vertex(x1 + dx * zEnd, y1 + dy * zEnd);
                p.endShape();

                // Label
                p.fill(color);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text(label, mx + nx * 20, my + ny * 20);
                p.textStyle(p.NORMAL);
            }

            function drawCurrentDots(x1, y1, x2, y2, nDots, speed) {
                p.fill(COLORS.force);
                p.noStroke();
                for (var i = 0; i < nDots; i++) {
                    var frac = ((t * speed + i / nDots) % 1 + 1) % 1;
                    p.ellipse(
                        p.lerp(x1, x2, frac),
                        p.lerp(y1, y2, frac),
                        6, 6
                    );
                }
            }

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.008;

                var A = nodes.A, B = nodes.B, C = nodes.C, D = nodes.D;

                // Draw resistor branches
                drawZigzag(A.x, A.y, B.x, B.y, COLORS.field, resistors.AB + ' Ω');
                drawZigzag(B.x, B.y, C.x, C.y, COLORS.field, resistors.BC + ' Ω');
                drawZigzag(A.x, A.y, D.x, D.y, COLORS.field, resistors.AD + ' Ω');
                drawZigzag(D.x, D.y, C.x, C.y, COLORS.field, resistors.DC + ' Ω');
                drawZigzag(B.x, B.y, D.x, D.y, COLORS.field, resistors.BD + ' Ω');

                // Animated current dots on branches
                drawCurrentDots(A.x, A.y, B.x, B.y, 3, 1.0);
                drawCurrentDots(B.x, B.y, C.x, C.y, 3, 1.0);
                drawCurrentDots(A.x, A.y, D.x, D.y, 3, 1.0);
                drawCurrentDots(D.x, D.y, C.x, C.y, 3, 1.0);
                drawCurrentDots(B.x, B.y, D.x, D.y, 2, 0.5);

                // Node dots
                var nodeNames = ['A', 'B', 'C', 'D'];
                for (var ni = 0; ni < nodeNames.length; ni++) {
                    var n = nodes[nodeNames[ni]];
                    p.fill(getTextColor());
                    p.stroke(255);
                    p.strokeWeight(2);
                    p.ellipse(n.x, n.y, 12, 12);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    var offX = nodeNames[ni] === 'A' ? -18 : nodeNames[ni] === 'C' ? 18 : 0;
                    var offY = nodeNames[ni] === 'B' ? -18 : nodeNames[ni] === 'D' ? 18 : 0;
                    p.text(nodeNames[ni], n.x + offX, n.y + offY);
                    p.textStyle(p.NORMAL);
                }

                // EMF label
                p.fill(COLORS.positive);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('E = ' + emf + ' V', W / 2, H - 10);
                p.textStyle(p.NORMAL);

                // Title
                p.fill(getTextColor());
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text("Kirchhoff's Network", W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: charging-circuit
    //  Battery being charged by external supply
    // =====================================================
    function chargingCircuit(containerEl, params) {
        var supplyV = params.supply_voltage || 120;
        var batteryE = params.battery_emf || 8;
        var seriesR = params.series_resistance || 15.5;
        var intR = params.internal_resistance || 0.5;
        var currentVal = (supplyV - batteryE) / (seriesR + intR);
        var terminalV = batteryE + currentVal * intR;

        return new p5(function(p) {
            var W, H, t = 0;
            var path = [];

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
                // Build circuit path
                var mx = W * 0.1, my = H * 0.15;
                var mw = W * 0.8, mh = H * 0.6;
                var segs = 60;
                for (var i = 0; i <= segs; i++) path.push({ x: mx + mw * (i / segs), y: my });
                for (var i = 1; i <= segs; i++) path.push({ x: mx + mw, y: my + mh * (i / segs) });
                for (var i = 1; i <= segs; i++) path.push({ x: mx + mw - mw * (i / segs), y: my + mh });
                for (var i = 1; i < segs; i++) path.push({ x: mx, y: my + mh - mh * (i / segs) });
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.02;

                var mx = W * 0.1, my = H * 0.15;
                var mw = W * 0.8, mh = H * 0.6;

                // Wires
                p.stroke(getTextColor());
                p.strokeWeight(2.5);
                p.noFill();
                p.rect(mx, my, mw, mh, 4);

                // DC Supply (left side)
                var sx = mx, scy = my + mh * 0.5;
                p.stroke(getBg()); p.strokeWeight(6);
                p.line(sx, scy - 15, sx, scy + 15);
                p.stroke('#7c3aed'); p.strokeWeight(3);
                p.line(sx - 14, scy - 8, sx + 14, scy - 8);
                p.strokeWeight(5);
                p.line(sx - 8, scy + 8, sx + 8, scy + 8);
                p.fill('#7c3aed'); p.noStroke();
                p.textAlign(p.RIGHT, p.CENTER);
                p.textSize(12); p.textStyle(p.BOLD);
                p.text(supplyV + ' V', sx - 18, scy);
                p.textStyle(p.NORMAL);

                // Series Resistor (top)
                var rcy = my;
                var rcx1 = mx + mw * 0.25, rcx2 = mx + mw * 0.45;
                p.stroke(getBg()); p.strokeWeight(6);
                p.line(rcx1, rcy, rcx2, rcy);
                p.stroke(COLORS.field); p.strokeWeight(2);
                p.noFill();
                var amp = 8, nz = 5;
                p.beginShape();
                p.vertex(rcx1, rcy);
                for (var i = 0; i < nz; i++) {
                    var sign = (i % 2 === 0) ? 1 : -1;
                    p.vertex(rcx1 + (rcx2 - rcx1) * (i * 2 + 1) / (nz * 2), rcy + amp * sign);
                    p.vertex(rcx1 + (rcx2 - rcx1) * (i * 2 + 2) / (nz * 2), rcy - amp * sign);
                }
                p.vertex(rcx2, rcy);
                p.endShape();
                p.fill(COLORS.field); p.noStroke();
                p.textAlign(p.CENTER, p.BOTTOM);
                p.textSize(11); p.textStyle(p.BOLD);
                p.text('R = ' + seriesR + ' Ω', (rcx1 + rcx2) / 2, rcy - 12);
                p.textStyle(p.NORMAL);

                // Battery being charged (right side)
                var bx = mx + mw, bcy = my + mh * 0.35;
                p.stroke(getBg()); p.strokeWeight(6);
                p.line(bx, bcy - 15, bx, bcy + 15);
                p.stroke(COLORS.positive); p.strokeWeight(3);
                p.line(bx - 14, bcy - 8, bx + 14, bcy - 8);
                p.strokeWeight(5);
                p.line(bx - 8, bcy + 8, bx + 8, bcy + 8);
                p.fill(COLORS.positive); p.noStroke();
                p.textAlign(p.LEFT, p.CENTER);
                p.textSize(12); p.textStyle(p.BOLD);
                p.text('E = ' + batteryE + ' V', bx + 18, bcy);
                p.textStyle(p.NORMAL);
                p.textSize(9);
                p.text('(charging)', bx + 18, bcy + 14);

                // Internal resistance (right side, below battery)
                var iry = my + mh * 0.65;
                p.stroke(getBg()); p.strokeWeight(6);
                p.line(bx, iry - 15, bx, iry + 15);
                p.stroke(COLORS.neutral); p.strokeWeight(2);
                p.noFill();
                p.beginShape();
                p.vertex(bx, iry - 15);
                for (var i = 0; i < 3; i++) {
                    var sign = (i % 2 === 0) ? 1 : -1;
                    p.vertex(bx + 8 * sign, iry - 15 + (i * 2 + 1) * 5);
                    p.vertex(bx - 8 * sign, iry - 15 + (i * 2 + 2) * 5);
                }
                p.vertex(bx, iry + 15);
                p.endShape();
                p.fill(COLORS.neutral); p.noStroke();
                p.textAlign(p.LEFT, p.CENTER);
                p.textSize(10);
                p.text('r = ' + intR + ' Ω', bx + 18, iry);

                // Animated current dots
                var nDots = 10;
                var total = path.length;
                p.fill(COLORS.force);
                p.noStroke();
                for (var di = 0; di < nDots; di++) {
                    var idx = Math.floor((t * 30 + di * total / nDots) % total);
                    p.ellipse(path[idx].x, path[idx].y, 7, 7);
                }

                // Current & terminal voltage labels
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12); p.textStyle(p.BOLD);
                p.text('I = ' + currentVal.toFixed(1) + ' A', mx + mw * 0.65, my - 8);
                p.textStyle(p.NORMAL);

                // Result box
                var bxR = mx + mw * 0.15, byR = my + mh + 16;
                p.fill(isDark() ? 'rgba(34,197,94,0.1)' : 'rgba(34,197,94,0.08)');
                p.stroke(COLORS.surfaceStroke);
                p.strokeWeight(1);
                p.rect(bxR, byR, mw * 0.7, 36, 6);
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12); p.textStyle(p.BOLD);
                p.text('V_terminal = E + Ir = ' + terminalV.toFixed(1) + ' V', bxR + mw * 0.35, byR + 22);
                p.textStyle(p.NORMAL);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text('Battery Charging Circuit', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    // =====================================================
    //  SKETCH TYPE: magnetic-field-wire
    //  Long straight wire with circular B-field lines
    // =====================================================
    function magneticFieldWire(containerEl, params) {
        var current = params.current || 35;
        var direction = params.current_direction || 'into'; // 'into' or 'outof'
        var label_B = params.label_B || '';
        var label_d = params.label_d || '';
        var show_point = params.show_point !== false;

        return new p5(function(p) {
            var W, H, dotAngle = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                dotAngle += 0.025;
                var cx = W * 0.4, cy = H * 0.5;
                var sign = direction === 'into' ? 1 : -1;

                // Concentric B-field circles
                p.noFill();
                for (var ri = 1; ri <= 4; ri++) {
                    var r = ri * 30;
                    var alpha = 200 - ri * 35;
                    p.stroke(p.red(p.color(COLORS.field)), p.green(p.color(COLORS.field)), p.blue(p.color(COLORS.field)), alpha);
                    p.strokeWeight(1.5);
                    p.ellipse(cx, cy, r * 2, r * 2);
                    // Arrow head on circle (right side)
                    var aAngle = -0.3;
                    var ax = cx + r * Math.cos(aAngle);
                    var ay = cy + r * Math.sin(aAngle);
                    var tangent = direction === 'into' ? aAngle + p.HALF_PI : aAngle - p.HALF_PI;
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.push();
                    p.translate(ax, ay);
                    p.rotate(tangent);
                    p.triangle(0, 0, -6, -3, -6, 3);
                    p.pop();
                    p.noFill();
                    // Animated dot orbiting on this circle
                    var da = sign * dotAngle * (1.4 - ri * 0.1);
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.ellipse(cx + r * Math.cos(da), cy + r * Math.sin(da), 7, 7);
                    p.noFill();
                }

                // Wire cross-section
                p.fill(isDark() ? '#b87333' : '#a0522d');
                p.stroke(255);
                p.strokeWeight(2);
                p.ellipse(cx, cy, 24, 24);
                // Current symbol
                p.fill(255);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(16);
                p.textStyle(p.BOLD);
                if (direction === 'into') {
                    // X for into page
                    p.text('×', cx, cy);
                } else {
                    // Dot for out of page
                    p.fill(255);
                    p.ellipse(cx, cy, 6, 6);
                }
                p.textStyle(p.NORMAL);

                // Current label
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.textAlign(p.CENTER, p.BOTTOM);
                p.text('I = ' + current + ' A', cx, cy - 20);
                p.textStyle(p.NORMAL);
                p.textSize(10);
                p.text(direction === 'into' ? '(into page)' : '(out of page)', cx, cy - 8);

                // Observation point
                if (show_point) {
                    var px = cx + 100, py = cy;
                    p.fill(COLORS.force);
                    p.stroke(255);
                    p.strokeWeight(1.5);
                    p.ellipse(px, py, 10, 10);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(11);
                    p.textAlign(p.LEFT);
                    p.text('P', px + 8, py + 4);
                    if (label_d) p.text(label_d, px + 8, py + 18);
                    if (label_B) {
                        p.fill(COLORS.field);
                        p.textStyle(p.BOLD);
                        p.text('B = ' + label_B, px + 8, py + 32);
                        p.textStyle(p.NORMAL);
                    }
                    // Distance line
                    p.stroke(COLORS.neutral);
                    p.strokeWeight(1);
                    drawDashedLine(p, cx + 12, cy, px - 6, py);
                }

                // Right-hand rule note
                p.fill(COLORS.field);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(10);
                p.text('B-field lines (right-hand rule)', cx, H - 15);

                // Title
                p.fill(getTextColor());
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Magnetic Field of a Straight Wire', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: solenoid-field
    //  Solenoid with uniform field inside
    // =====================================================
    function solenoidField(containerEl, params) {
        var nTurns = params.visible_turns || 12;
        var label_B = params.label_B || '';

        return new p5(function(p) {
            var W, H, flowT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                flowT += 0.02;
                var sx = W * 0.12, sy = H * 0.25;
                var sw = W * 0.76, sh = H * 0.45;

                // Solenoid coils
                p.stroke(isDark() ? '#b87333' : '#a0522d');
                p.strokeWeight(2);
                p.noFill();
                var coilW = sw / nTurns;
                for (var i = 0; i < nTurns; i++) {
                    var x = sx + i * coilW + coilW / 2;
                    p.ellipse(x, sy + sh / 2, coilW * 0.6, sh);
                }

                // Animated current dots on coils
                p.fill(COLORS.force);
                p.noStroke();
                for (var ci = 0; ci < nTurns; ci++) {
                    var cx = sx + ci * coilW + coilW / 2;
                    var ccy = sy + sh / 2;
                    var rx = coilW * 0.3, ry = sh / 2;
                    var da = flowT + ci * 0.5;
                    p.ellipse(cx + rx * Math.cos(da), ccy + ry * Math.sin(da), 5, 5);
                }

                // Field lines inside (uniform, horizontal)
                var nLines = 5;
                for (var li = 0; li < nLines; li++) {
                    var fy = sy + sh * (li + 1) / (nLines + 1);
                    drawArrow(p, sx + 10, fy, sx + sw - 10, fy, COLORS.field, 1.5);
                }

                // Animated field-line dots flowing right inside solenoid
                for (var fi = 0; fi < nLines; fi++) {
                    var ffy = sy + sh * (fi + 1) / (nLines + 1);
                    var fdx = sx + 10 + ((flowT * 80 + fi * 60) % (sw - 20));
                    p.fill(COLORS.field);
                    p.noStroke();
                    p.ellipse(fdx, ffy, 5, 5);
                }

                // Field lines outside (curved, return path)
                p.stroke(COLORS.field);
                p.strokeWeight(1);
                p.noFill();
                var outR = sh * 0.6;
                p.beginShape();
                for (var a = -0.3; a <= Math.PI + 0.3; a += 0.1) {
                    p.vertex(sx + sw / 2 + (sw / 2 + 20) * Math.cos(a), sy + sh / 2 - outR * Math.sin(a));
                }
                p.endShape();

                // B = 0 outside labels
                p.fill(COLORS.neutral);
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.CENTER);

                // B inside label
                if (label_B) {
                    p.fill(COLORS.field);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.textAlign(p.CENTER);
                    p.text('B = ' + label_B, sx + sw / 2, sy + sh + 30);
                    p.textStyle(p.NORMAL);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Solenoid Magnetic Field', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: circular-orbit
    //  Charged particle in circular path under B field
    // =====================================================
    function circularOrbit(containerEl, params) {
        var radius_label = params.radius_label || '4.2 cm';
        var particle = params.particle || 'electron';
        var field_dir = params.field_direction || 'into';

        return new p5(function(p) {
            var W, H, angle = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                angle += 0.03;

                var cx = W * 0.45, cy = H * 0.5;
                var R = Math.min(W, H) * 0.28;

                // B-field symbols (grid of dots or crosses)
                p.fill(COLORS.field);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.CENTER, p.CENTER);
                var spacing = 40;
                for (var bx = 30; bx < W - 20; bx += spacing) {
                    for (var by = 40; by < H - 20; by += spacing) {
                        if (field_dir === 'into') {
                            p.text('×', bx, by);
                        } else {
                            p.ellipse(bx, by, 4, 4);
                        }
                    }
                }
                p.textSize(10);
                p.text('B ' + (field_dir === 'into' ? '⊗ (into page)' : '⊙ (out of page)'), W - 70, 20);

                // Circular orbit
                p.noFill();
                p.stroke(COLORS.surfaceStroke);
                p.strokeWeight(2);
                p.ellipse(cx, cy, R * 2, R * 2);

                // Moving particle
                var px = cx + R * Math.cos(angle);
                var py = cy + R * Math.sin(angle);
                var col = particle === 'electron' ? COLORS.negative : COLORS.positive;
                p.fill(col);
                p.stroke(255);
                p.strokeWeight(2);
                p.ellipse(px, py, 14, 14);
                p.fill(255);
                p.noStroke();
                p.textSize(9);
                p.textStyle(p.BOLD);
                p.text(particle === 'electron' ? 'e⁻' : '+', px, py);
                p.textStyle(p.NORMAL);

                // Velocity arrow (tangent)
                var vx = -Math.sin(angle);
                var vy = Math.cos(angle);
                drawArrow(p, px, py, px + vx * 30, py + vy * 30, COLORS.force, 2);
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(10);
                p.text('v', px + vx * 35, py + vy * 35);

                // Radius line
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                drawDashedLine(p, cx, cy, px, py);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.textAlign(p.CENTER);
                p.text('r = ' + radius_label, cx, cy - 10);
                p.textStyle(p.NORMAL);

                // Title
                p.fill(getTextColor());
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Circular Orbit in Magnetic Field', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: torque-coil
    //  Current loop experiencing torque in B field
    // =====================================================
    function torqueCoil(containerEl, params) {
        var theta = params.angle || 30;
        var label_tau = params.label_tau || '';
        var coil_shape = params.coil_shape || 'square';

        return new p5(function(p) {
            var W, H, animT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                animT += 0.03;
                var cx = W * 0.45, cy = H * 0.5;
                var size = Math.min(W, H) * 0.25;

                // B-field arrows (uniform, horizontal right)
                p.stroke(COLORS.field);
                p.strokeWeight(1.5);
                for (var by = cy - size; by <= cy + size; by += 30) {
                    drawArrow(p, cx - size - 50, by, cx + size + 50, by, COLORS.field, 1);
                }
                p.fill(COLORS.field);
                p.noStroke();
                p.textAlign(p.RIGHT);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('B →', W - 20, 45);
                p.textStyle(p.NORMAL);

                // Coil (oscillates gently around theta to show torque effect)
                var currentTheta = theta + 6 * Math.sin(animT);
                var rad = currentTheta * Math.PI / 180;
                p.push();
                p.translate(cx, cy);

                // Coil rectangle (perspective: width = size, height compressed by cos theta)
                var halfW = size * 0.7;
                var halfH = size * 0.5;
                var apparentW = halfW * Math.cos(rad);

                p.stroke(COLORS.surfaceStroke);
                p.strokeWeight(3);
                p.noFill();
                p.beginShape();
                p.vertex(-apparentW, -halfH);
                p.vertex(apparentW, -halfH);
                p.vertex(apparentW, halfH);
                p.vertex(-apparentW, halfH);
                p.endShape(p.CLOSE);

                // Normal vector (perpendicular to coil plane)
                var normalLen = 60;
                var nx = normalLen * Math.sin(rad);
                var ny = 0;
                drawArrow(p, 0, 0, nx, ny, COLORS.positive, 2.5);
                p.fill(COLORS.positive);
                p.noStroke();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('n̂', nx + 12, ny + 4);
                p.textStyle(p.NORMAL);

                // Angle arc
                p.noFill();
                p.stroke(COLORS.force);
                p.strokeWeight(1.5);
                p.arc(0, 0, 40, 40, -0.1, rad);
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(11);
                p.text('θ≈' + theta + '°', 28, -8);

                // Current direction arrows on coil edges
                p.fill(COLORS.surfaceStroke);
                p.textSize(8);
                p.text('I →', apparentW + 5, -halfH / 2);

                p.pop();

                // Torque label
                if (label_tau) {
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text('τ = ' + label_tau, cx, H - 20);
                    p.textStyle(p.NORMAL);
                }

                // Torque direction (curved arrow)
                p.noFill();
                p.stroke(COLORS.force);
                p.strokeWeight(2);
                p.arc(cx, cy, size * 1.8, size * 1.8, -0.5, 0.5);
                var arrowTipX = cx + size * 0.9 * Math.cos(0.5);
                var arrowTipY = cy + size * 0.9 * Math.sin(0.5);
                p.fill(COLORS.force);
                p.noStroke();
                p.push();
                p.translate(arrowTipX, arrowTipY);
                p.rotate(0.5 + p.HALF_PI);
                p.triangle(0, 0, -5, -8, 5, -8);
                p.pop();
                p.fill(COLORS.force);
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('τ', arrowTipX + 6, arrowTipY);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Torque on Current Loop', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: parallel-wires
    //  Two parallel current-carrying wires with forces
    // =====================================================
    function parallelWires(containerEl, params) {
        var I1 = params.I1 || 8;
        var I2 = params.I2 || 5;
        var same_dir = params.same_direction !== false;
        var label_d = params.label_d || '4 cm';
        var label_F = params.label_F || '';

        return new p5(function(p) {
            var W, H, flowT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                flowT += 1.2;

                var x1 = W * 0.33, x2 = W * 0.67;
                var y1 = H * 0.15, y2 = H * 0.8;
                var wireLen = y2 - y1;

                // Wire A
                p.stroke(COLORS.positive);
                p.strokeWeight(4);
                p.line(x1, y1, x1, y2);
                drawArrow(p, x1, y2 - 20, x1, y1 + 20, COLORS.positive, 3);

                // Animated current dots on wire A (flowing upward)
                p.fill(255);
                p.noStroke();
                for (var da = 0; da < 4; da++) {
                    var dy1 = y2 - ((flowT + da * wireLen / 4) % wireLen);
                    p.ellipse(x1, dy1, 5, 5);
                }

                // Animated current dots on wire B
                p.fill(255);
                for (var db = 0; db < 4; db++) {
                    var dy2;
                    if (same_dir) {
                        dy2 = y2 - ((flowT + db * wireLen / 4 + wireLen / 8) % wireLen);
                    } else {
                        dy2 = y1 + ((flowT + db * wireLen / 4) % wireLen);
                    }
                    p.ellipse(x2, dy2, 5, 5);
                }
                p.fill(COLORS.positive);
                p.noStroke();
                p.textAlign(p.RIGHT);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('A', x1 - 12, H * 0.5);
                p.text('I₁=' + I1 + 'A', x1 - 12, H * 0.5 + 16);
                p.textStyle(p.NORMAL);

                // Wire B
                p.stroke(COLORS.negative);
                p.strokeWeight(4);
                p.line(x2, y1, x2, y2);
                if (same_dir) {
                    drawArrow(p, x2, y2 - 20, x2, y1 + 20, COLORS.negative, 3);
                } else {
                    drawArrow(p, x2, y1 + 20, x2, y2 - 20, COLORS.negative, 3);
                }
                p.fill(COLORS.negative);
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('B', x2 + 12, H * 0.5);
                p.text('I₂=' + I2 + 'A', x2 + 12, H * 0.5 + 16);
                p.textStyle(p.NORMAL);

                // Force arrows
                var fcy = H * 0.35;
                if (same_dir) {
                    // Attractive
                    drawArrow(p, x1 + 8, fcy, x1 + 35, fcy, COLORS.force, 2.5);
                    drawArrow(p, x2 - 8, fcy, x2 - 35, fcy, COLORS.force, 2.5);
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.text('Attractive', (x1 + x2) / 2, fcy - 8);
                } else {
                    // Repulsive
                    drawArrow(p, x1 - 8, fcy, x1 - 35, fcy, COLORS.force, 2.5);
                    drawArrow(p, x2 + 8, fcy, x2 + 35, fcy, COLORS.force, 2.5);
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.text('Repulsive', (x1 + x2) / 2, fcy - 8);
                }
                p.textStyle(p.NORMAL);

                // Distance
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                var dy = H * 0.88;
                p.line(x1, dy, x2, dy);
                p.line(x1, dy - 4, x1, dy + 4);
                p.line(x2, dy - 4, x2, dy + 4);
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(11);
                p.text('d = ' + label_d, (x1 + x2) / 2, dy + 14);

                // Force label
                if (label_F) {
                    p.fill(COLORS.force);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('F = ' + label_F, (x1 + x2) / 2, fcy + 14);
                    p.textStyle(p.NORMAL);
                }

                // Title
                p.fill(getTextColor());
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Force Between Parallel Wires', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: bar-magnet-torque
    //  Bar magnet oscillating in uniform B field (Ch5)
    // =====================================================
    function barMagnetTorque(containerEl, params) {
        var theta = params.angle || 30;
        var label_tau = params.label_tau || '';
        var label_m = params.label_m || '';

        return new p5(function(p) {
            var W, H, animT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                animT += 0.03;
                var cx = W * 0.45, cy = H * 0.5;
                var size = Math.min(W, H) * 0.22;

                // Uniform B-field arrows (horizontal right)
                p.stroke(COLORS.field);
                p.strokeWeight(1.5);
                for (var by = cy - size - 20; by <= cy + size + 20; by += 35) {
                    drawArrow(p, 30, by, W - 30, by, COLORS.field, 1);
                }
                p.fill(COLORS.field);
                p.noStroke();
                p.textAlign(p.RIGHT);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('B \u2192', W - 10, 32);
                p.textStyle(p.NORMAL);

                // Oscillating bar magnet
                var currentTheta = theta + 6 * Math.sin(animT);
                var rad = currentTheta * Math.PI / 180;
                var magLen = size * 1.6;
                var magH = size * 0.4;

                p.push();
                p.translate(cx, cy);
                p.rotate(rad);

                // North half (red)
                p.fill(COLORS.positive);
                p.stroke(getTextColor());
                p.strokeWeight(1.5);
                p.rect(0, -magH / 2, magLen / 2, magH, 0, 4, 4, 0);
                p.fill(255);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('N', magLen / 4, 0);

                // South half (blue)
                p.fill(COLORS.negative);
                p.stroke(getTextColor());
                p.strokeWeight(1.5);
                p.rect(-magLen / 2, -magH / 2, magLen / 2, magH, 4, 0, 0, 4);
                p.fill(255);
                p.noStroke();
                p.textSize(14);
                p.text('S', -magLen / 4, 0);

                // Magnetic moment vector m (along magnet axis, N direction)
                p.textStyle(p.NORMAL);
                drawArrow(p, 0, 0, magLen / 2 + 25, 0, COLORS.force, 2.5);
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('m\u20D7', magLen / 2 + 32, -2);
                p.textStyle(p.NORMAL);

                p.pop();

                // Angle arc (from B direction = horizontal to m direction)
                p.noFill();
                p.stroke(COLORS.force);
                p.strokeWeight(1.5);
                p.arc(cx, cy, 60, 60, 0, rad);
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.LEFT);
                p.text('\u03b8\u2248' + theta + '\u00b0', cx + 34, cy - 6);

                // Torque curved arrow
                p.noFill();
                p.stroke(COLORS.surfaceStroke);
                p.strokeWeight(2);
                p.arc(cx, cy, size * 2.2, size * 2.2, rad - 0.3, rad + 0.3);
                var tipX = cx + size * 1.1 * Math.cos(rad + 0.3);
                var tipY = cy + size * 1.1 * Math.sin(rad + 0.3);
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.push();
                p.translate(tipX, tipY);
                p.rotate(rad + 0.3 + p.HALF_PI);
                p.triangle(0, 0, -4, -7, 4, -7);
                p.pop();

                // Labels
                if (label_tau) {
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text('\u03c4 = ' + label_tau, cx, H - 15);
                    p.textStyle(p.NORMAL);
                }
                if (label_m) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.text(label_m, 10, H - 15);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Bar Magnet in Uniform Field', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: dipole-field
    //  Bar magnet dipole field with axial & equatorial points (Ch5)
    // =====================================================
    function dipoleField(containerEl, params) {
        var label_axial = params.label_axial || '';
        var label_eq = params.label_eq || '';

        return new p5(function(p) {
            var W, H, pulseT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 320;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                pulseT += 0.02;
                var cx = W * 0.5, cy = H * 0.5;
                var magLen = 60, magH = 22;

                // Dipole field lines (curves from N pole around to S pole)
                p.noFill();
                p.strokeWeight(1.2);
                var fieldCol = p.color(COLORS.field);
                var nCurves = 6;
                for (var ci = 0; ci < nCurves; ci++) {
                    var spread = 20 + ci * 18;
                    var alpha = 200 - ci * 25;
                    p.stroke(p.red(fieldCol), p.green(fieldCol), p.blue(fieldCol), alpha);

                    // Top curves (N to S via top)
                    p.beginShape();
                    p.noFill();
                    for (var t = 0; t <= 1; t += 0.02) {
                        var fx = cx + magLen / 2 - t * magLen;
                        var fy = cy - spread * Math.sin(t * Math.PI);
                        p.vertex(fx, fy);
                    }
                    p.endShape();

                    // Bottom curves (N to S via bottom)
                    p.beginShape();
                    p.noFill();
                    for (var t2 = 0; t2 <= 1; t2 += 0.02) {
                        var fx2 = cx + magLen / 2 - t2 * magLen;
                        var fy2 = cy + spread * Math.sin(t2 * Math.PI);
                        p.vertex(fx2, fy2);
                    }
                    p.endShape();
                }

                // Animated dots flowing along field lines
                p.fill(COLORS.field);
                p.noStroke();
                for (var di = 0; di < 3; di++) {
                    var dt = (pulseT * 0.5 + di * 0.33) % 1;
                    var spread2 = 50;
                    // Top field line dot
                    var ddx = cx + magLen / 2 - dt * magLen;
                    var ddy = cy - spread2 * Math.sin(dt * Math.PI);
                    p.ellipse(ddx, ddy, 5, 5);
                    // Bottom field line dot
                    p.ellipse(ddx, cy + spread2 * Math.sin(dt * Math.PI), 5, 5);
                }

                // Bar magnet
                // North half (right)
                p.fill(COLORS.positive);
                p.stroke(getTextColor());
                p.strokeWeight(1.5);
                p.rect(cx, cy - magH / 2, magLen / 2, magH, 0, 4, 4, 0);
                p.fill(255);
                p.noStroke();
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text('N', cx + magLen / 4, cy);

                // South half (left)
                p.fill(COLORS.negative);
                p.stroke(getTextColor());
                p.strokeWeight(1.5);
                p.rect(cx - magLen / 2, cy - magH / 2, magLen / 2, magH, 4, 0, 0, 4);
                p.fill(255);
                p.noStroke();
                p.textSize(13);
                p.text('S', cx - magLen / 4, cy);
                p.textStyle(p.NORMAL);

                // Axial point (along axis, to the right)
                var axDist = 120;
                var axX = cx + axDist;
                p.fill(COLORS.force);
                p.stroke(255);
                p.strokeWeight(1.5);
                p.ellipse(axX, cy, 10, 10);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.LEFT);
                p.textStyle(p.BOLD);
                p.text('P\u2081 (axial)', axX + 8, cy - 8);
                if (label_axial) {
                    p.fill(COLORS.field);
                    p.text('B = ' + label_axial, axX + 8, cy + 8);
                }
                // Distance line to axial
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                drawDashedLine(p, cx + magLen / 2 + 2, cy + magH / 2 + 8, axX, cy + magH / 2 + 8);
                p.fill(COLORS.neutral);
                p.noStroke();
                p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('r', (cx + magLen / 2 + axX) / 2, cy + magH / 2 + 20);

                // Equatorial point (perpendicular, above)
                var eqDist = 100;
                var eqY = cy - eqDist;
                p.fill(COLORS.surfaceStroke);
                p.stroke(255);
                p.strokeWeight(1.5);
                p.ellipse(cx, eqY, 10, 10);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.LEFT);
                p.textStyle(p.BOLD);
                p.text('P\u2082 (equatorial)', cx + 8, eqY - 6);
                if (label_eq) {
                    p.fill(COLORS.field);
                    p.text('B = ' + label_eq, cx + 8, eqY + 10);
                }
                // Distance line to equatorial
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                drawDashedLine(p, cx + 10, cy - magH / 2, cx + 10, eqY + 6);
                p.fill(COLORS.neutral);
                p.noStroke();
                p.textSize(9);
                p.text('r', cx + 18, (cy - magH / 2 + eqY) / 2);

                p.textStyle(p.NORMAL);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Magnetic Dipole Field', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: flux-change-loop
    //  Loop with changing flux and induced current (Ch6)
    // =====================================================
    function fluxChangeLoop(containerEl, params) {
        var flux_dir = params.flux_direction || 'increasing';
        var current_label = params.current_label || '';

        return new p5(function(p) {
            var W, H, t = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.03;
                var cx = W * 0.45, cy = H * 0.5;
                var loopR = Math.min(W, H) * 0.22;

                // B-field symbols (into page, pulsing)
                var pulse = flux_dir === 'increasing' ? 0.6 + 0.4 * Math.abs(Math.sin(t)) : 0.9 - 0.3 * Math.abs(Math.sin(t));
                p.fill(p.red(p.color(COLORS.field)), p.green(p.color(COLORS.field)), p.blue(p.color(COLORS.field)), pulse * 255);
                p.noStroke();
                p.textSize(14);
                p.textAlign(p.CENTER, p.CENTER);
                var sp = 35;
                for (var bx = cx - loopR; bx <= cx + loopR; bx += sp) {
                    for (var by = cy - loopR; by <= cy + loopR; by += sp) {
                        if (Math.sqrt((bx - cx) * (bx - cx) + (by - cy) * (by - cy)) < loopR - 5) {
                            p.text('\u00d7', bx, by);
                        }
                    }
                }
                p.fill(COLORS.field);
                p.textSize(10);
                p.text('B \u2297 (' + flux_dir + ')', cx, cy - loopR - 20);

                // Circular loop
                p.noFill();
                p.stroke(COLORS.surfaceStroke);
                p.strokeWeight(3);
                p.ellipse(cx, cy, loopR * 2, loopR * 2);

                // Animated induced current dots on loop
                p.fill(COLORS.force);
                p.noStroke();
                var dir = flux_dir === 'increasing' ? -1 : 1;
                for (var di = 0; di < 6; di++) {
                    var da = dir * t * 1.5 + di * Math.PI / 3;
                    p.ellipse(cx + loopR * Math.cos(da), cy + loopR * Math.sin(da), 6, 6);
                }

                // Current direction arrow
                var aAngle = dir * t * 1.5;
                var ax = cx + loopR * Math.cos(aAngle);
                var ay = cy + loopR * Math.sin(aAngle);
                var tangent = aAngle + dir * p.HALF_PI;
                p.fill(COLORS.force);
                p.push();
                p.translate(ax, ay);
                p.rotate(tangent);
                p.triangle(0, 0, -7, -4, -7, 4);
                p.pop();

                // Labels
                if (current_label) {
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text(current_label, cx, H - 15);
                    p.textStyle(p.NORMAL);
                }

                // Lenz's law note
                p.fill(COLORS.neutral);
                p.textSize(9);
                p.textAlign(p.LEFT);
                p.text('Induced current opposes flux change (Lenz)', 10, H - 5);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Electromagnetic Induction', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: motional-emf
    //  Rod sliding on rails in B field (Ch6)
    // =====================================================
    function motionalEmf(containerEl, params) {
        var emf_label = params.emf_label || '';

        return new p5(function(p) {
            var W, H, rodX = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                rodX = (rodX + 0.5) % (W * 0.5);

                var railY1 = H * 0.25, railY2 = H * 0.75;
                var railLeft = W * 0.1, railRight = W * 0.85;
                var railLen = railRight - railLeft;

                // B-field symbols (into page)
                p.fill(COLORS.field);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.CENTER, p.CENTER);
                for (var bx = railLeft + 15; bx < railRight; bx += 35) {
                    for (var by = railY1 + 15; by < railY2; by += 35) {
                        p.text('\u00d7', bx, by);
                    }
                }
                p.textSize(10);
                p.text('B \u2297', W - 30, 30);

                // Rails (two horizontal lines)
                p.stroke(COLORS.neutral);
                p.strokeWeight(3);
                p.line(railLeft, railY1, railRight, railY1);
                p.line(railLeft, railY2, railRight, railY2);

                // Left connecting wire
                p.line(railLeft, railY1, railLeft, railY2);

                // Sliding rod (animated)
                var rx = railLeft + 40 + rodX;
                p.stroke(COLORS.positive);
                p.strokeWeight(5);
                p.line(rx, railY1, rx, railY2);

                // Velocity arrow
                drawArrow(p, rx + 8, H * 0.5, rx + 35, H * 0.5, COLORS.surfaceStroke, 2);
                p.fill(COLORS.surfaceStroke);
                p.noStroke();
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('v \u2192', rx + 40, H * 0.5 - 8);
                p.textStyle(p.NORMAL);

                // Current direction (animated dots in loop)
                p.fill(COLORS.force);
                p.noStroke();
                var loopPerim = 2 * (railY2 - railY1) + 2 * (rx - railLeft);
                if (loopPerim > 0) {
                    for (var di = 0; di < 4; di++) {
                        var pos = ((rodX * 2 + di * loopPerim / 4) % loopPerim);
                        var dx, dy;
                        var segUp = railY2 - railY1;
                        var segTop = rx - railLeft;
                        var segDown = segUp;
                        if (pos < segUp) {
                            dx = rx; dy = railY2 - pos;
                        } else if (pos < segUp + segTop) {
                            dx = rx - (pos - segUp); dy = railY1;
                        } else if (pos < 2 * segUp + segTop) {
                            dx = railLeft; dy = railY1 + (pos - segUp - segTop);
                        } else {
                            dx = railLeft + (pos - 2 * segUp - segTop); dy = railY2;
                        }
                        p.ellipse(dx, dy, 5, 5);
                    }
                }

                // EMF and length labels
                if (emf_label) {
                    p.fill(COLORS.force);
                    p.textAlign(p.CENTER);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text('\u03b5 = ' + emf_label, W / 2, H - 12);
                    p.textStyle(p.NORMAL);
                }

                // Rod label
                p.fill(COLORS.positive);
                p.textAlign(p.LEFT);
                p.textSize(10);
                p.text('Rod (l)', rx + 6, railY2 - 15);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Motional EMF', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: rotating-rod
    //  Rod rotating about one end sweeping area in B field (Ch6)
    // =====================================================
    function rotatingRod(containerEl, params) {
        var emf_label = params.emf_label || '';

        return new p5(function(p) {
            var W, H, angle = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                angle += 0.02;
                var cx = W * 0.45, cy = H * 0.5;
                var rodLen = Math.min(W, H) * 0.3;

                // B-field symbols (into page)
                p.fill(COLORS.field);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.CENTER, p.CENTER);
                for (var bx = 30; bx < W - 20; bx += 40) {
                    for (var by = 40; by < H - 20; by += 40) {
                        p.text('\u00d7', bx, by);
                    }
                }
                p.textSize(10);
                p.text('B \u2297', W - 30, 25);

                // Swept area (filled sector up to current angle)
                var sweepAngle = angle % (2 * Math.PI);
                p.fill(p.red(p.color(COLORS.surfaceStroke)), p.green(p.color(COLORS.surfaceStroke)), p.blue(p.color(COLORS.surfaceStroke)), 40);
                p.noStroke();
                p.arc(cx, cy, rodLen * 2, rodLen * 2, 0, sweepAngle);

                // Outer ring
                p.noFill();
                p.stroke(COLORS.neutral);
                p.strokeWeight(2);
                p.ellipse(cx, cy, rodLen * 2, rodLen * 2);

                // Rotating rod
                var endX = cx + rodLen * Math.cos(angle);
                var endY = cy + rodLen * Math.sin(angle);
                p.stroke(COLORS.positive);
                p.strokeWeight(4);
                p.line(cx, cy, endX, endY);

                // Pivot point
                p.fill(getTextColor());
                p.stroke(255);
                p.strokeWeight(2);
                p.ellipse(cx, cy, 10, 10);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.LEFT);
                p.text('pivot', cx + 8, cy - 8);

                // Rod end
                p.fill(COLORS.positive);
                p.stroke(255);
                p.strokeWeight(1.5);
                p.ellipse(endX, endY, 8, 8);

                // \u03c9 arrow (curved)
                p.noFill();
                p.stroke(COLORS.force);
                p.strokeWeight(2);
                p.arc(cx, cy, 50, 50, angle - 0.8, angle - 0.1);
                var tipA = angle - 0.1;
                p.fill(COLORS.force);
                p.noStroke();
                p.push();
                p.translate(cx + 25 * Math.cos(tipA), cy + 25 * Math.sin(tipA));
                p.rotate(tipA + p.HALF_PI);
                p.triangle(0, 0, -4, -7, 4, -7);
                p.pop();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('\u03c9', cx + 30 * Math.cos(angle - 0.5), cy + 30 * Math.sin(angle - 0.5));
                p.textStyle(p.NORMAL);

                // Length label
                p.fill(getTextColor());
                p.textSize(11);
                p.textAlign(p.CENTER);
                var mx = (cx + endX) / 2, my = (cy + endY) / 2;
                p.text('l', mx + 10, my - 5);

                // EMF label
                if (emf_label) {
                    p.fill(COLORS.force);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text('\u03b5 = ' + emf_label, W / 2, H - 12);
                    p.textStyle(p.NORMAL);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Rotating Rod EMF', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: inductance-coil
    //  Coil with changing current and back-EMF (Ch6)
    // =====================================================
    function inductanceCoil(containerEl, params) {
        var L_label = params.L_label || '';
        var emf_label = params.emf_label || '';
        var change_dir = params.change || 'decreasing';

        return new p5(function(p) {
            var W, H, t = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 260;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.04;
                var cx = W * 0.5, cy = H * 0.45;

                // Coil symbol (inductor zigzag)
                var coilLeft = cx - 80, coilRight = cx + 80;
                p.stroke(isDark() ? '#b87333' : '#a0522d');
                p.strokeWeight(3);
                p.noFill();
                var nBumps = 6;
                var bumpW = (coilRight - coilLeft) / nBumps;
                p.beginShape();
                for (var i = 0; i <= nBumps; i++) {
                    var bx = coilLeft + i * bumpW;
                    if (i === 0 || i === nBumps) {
                        p.vertex(bx, cy);
                    } else {
                        p.vertex(bx - bumpW * 0.1, cy);
                        p.vertex(bx - bumpW * 0.3, cy - 18);
                        p.vertex(bx + bumpW * 0.3, cy - 18);
                        p.vertex(bx + bumpW * 0.1, cy);
                    }
                }
                p.endShape();

                // Wire leads
                p.line(W * 0.1, cy, coilLeft, cy);
                p.line(coilRight, cy, W * 0.9, cy);

                // Animated current dots (speed changes over time)
                var speed = change_dir === 'decreasing' ? 3 - 1.5 * Math.abs(Math.sin(t * 0.3)) : 1 + 2 * Math.abs(Math.sin(t * 0.3));
                p.fill(COLORS.force);
                p.noStroke();
                for (var di = 0; di < 5; di++) {
                    var dx = W * 0.1 + ((t * speed * 15 + di * (W * 0.8) / 5) % (W * 0.8));
                    p.ellipse(dx, cy, 5, 5);
                }

                // Current arrow
                drawArrow(p, W * 0.15, cy - 18, W * 0.35, cy - 18, COLORS.force, 2);
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.textAlign(p.CENTER);
                p.text('I (' + change_dir + ')', W * 0.25, cy - 25);
                p.textStyle(p.NORMAL);

                // Back-EMF arrow (opposes change)
                var emfDir = change_dir === 'decreasing' ? 1 : -1;
                var emfX1 = cx + emfDir * 30, emfX2 = cx - emfDir * 30;
                drawArrow(p, emfX1, cy + 25, emfX2, cy + 25, COLORS.positive, 2.5);
                p.fill(COLORS.positive);
                p.noStroke();
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('\u03b5 (back-EMF)', cx, cy + 42);
                p.textStyle(p.NORMAL);

                // L label
                if (L_label) {
                    p.fill(COLORS.surfaceStroke);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('L = ' + L_label, cx, cy - 30);
                    p.textStyle(p.NORMAL);
                }

                // EMF value
                if (emf_label) {
                    p.fill(COLORS.force);
                    p.textSize(13);
                    p.textStyle(p.BOLD);
                    p.text(emf_label, cx, H - 15);
                    p.textStyle(p.NORMAL);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Self-Inductance', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: ac-waveform
    //  Animated sinusoidal V and I waves with phase (Ch7)
    // =====================================================
    function acWaveform(containerEl, params) {
        var phase = params.phase_shift || 0; // degrees: 0=in-phase, 90=I lags, -90=I leads
        var show_rms = params.show_rms || false;

        return new p5(function(p) {
            var W, H, t = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.04;
                var cx = W * 0.5, cy = H * 0.5;
                var ampY = H * 0.3;
                var waveW = W * 0.8;
                var startX = W * 0.1;

                // Axes
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                p.line(startX, cy, startX + waveW, cy);
                p.line(startX, cy - ampY - 10, startX, cy + ampY + 10);
                p.fill(COLORS.neutral);
                p.noStroke();
                p.textSize(9);
                p.textAlign(p.RIGHT, p.CENTER);
                p.text('+', startX - 4, cy - ampY);
                p.text('\u2212', startX - 4, cy + ampY);
                p.textAlign(p.CENTER);
                p.text('t', startX + waveW + 10, cy + 4);

                // Voltage wave (red)
                p.stroke(COLORS.positive);
                p.strokeWeight(2);
                p.noFill();
                p.beginShape();
                for (var i = 0; i <= waveW; i += 2) {
                    var angle = (i / waveW) * 4 * Math.PI + t;
                    p.vertex(startX + i, cy - ampY * 0.85 * Math.sin(angle));
                }
                p.endShape();

                // Current wave (blue, shifted by phase)
                var phaseRad = phase * Math.PI / 180;
                p.stroke(COLORS.negative);
                p.strokeWeight(2);
                p.noFill();
                p.beginShape();
                for (var j = 0; j <= waveW; j += 2) {
                    var angle2 = (j / waveW) * 4 * Math.PI + t - phaseRad;
                    p.vertex(startX + j, cy - ampY * 0.65 * Math.sin(angle2));
                }
                p.endShape();

                // RMS level lines
                if (show_rms) {
                    var rmsY = ampY * 0.85 / 1.414;
                    p.stroke(COLORS.positive);
                    p.strokeWeight(1);
                    drawDashedLine(p, startX, cy - rmsY, startX + waveW, cy - rmsY);
                    drawDashedLine(p, startX, cy + rmsY, startX + waveW, cy + rmsY);
                    p.fill(COLORS.positive);
                    p.noStroke();
                    p.textSize(9);
                    p.textAlign(p.RIGHT);
                    p.text('V\u2080/\u221a2', startX - 4, cy - rmsY);
                }

                // Legend
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.fill(COLORS.positive);
                p.text('\u2014 V(t)', W - 90, 38);
                p.fill(COLORS.negative);
                p.text('\u2014 I(t)', W - 90, 54);
                p.textStyle(p.NORMAL);

                // Phase label
                if (phase !== 0) {
                    p.fill(COLORS.force);
                    p.textSize(11);
                    p.textAlign(p.CENTER);
                    var phaseText = phase > 0 ? 'I lags V by ' + phase + '\u00b0' : 'I leads V by ' + (-phase) + '\u00b0';
                    p.text(phaseText, cx, H - 10);
                } else {
                    p.fill(COLORS.surfaceStroke);
                    p.textSize(11);
                    p.textAlign(p.CENTER);
                    p.text('V and I in phase (\u03c6 = 0)', cx, H - 10);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'AC Waveform', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: lc-oscillation
    //  Animated LC circuit with energy exchange (Ch7)
    // =====================================================
    function lcOscillation(containerEl, params) {
        var freq_label = params.freq_label || '';

        return new p5(function(p) {
            var W, H, t = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.04;
                var q = Math.cos(t); // charge oscillation
                var i = Math.sin(t); // current (90° ahead)

                var capX = W * 0.25, indX = W * 0.75, midY = H * 0.4;

                // Capacitor symbol
                var plateH = 50, gap = 12;
                p.stroke(COLORS.neutral);
                p.strokeWeight(3);
                p.line(capX - gap / 2, midY - plateH / 2, capX - gap / 2, midY + plateH / 2);
                p.line(capX + gap / 2, midY - plateH / 2, capX + gap / 2, midY + plateH / 2);

                // Charge indicators on plates
                var chargeAlpha = Math.abs(q) * 200 + 55;
                if (q > 0) {
                    p.fill(p.red(p.color(COLORS.positive)), p.green(p.color(COLORS.positive)), p.blue(p.color(COLORS.positive)), chargeAlpha);
                    p.noStroke();
                    p.rect(capX - gap / 2 - 15, midY - plateH / 2, 15, plateH);
                    p.fill(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), chargeAlpha);
                    p.rect(capX + gap / 2, midY - plateH / 2, 15, plateH);
                } else {
                    p.fill(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), chargeAlpha);
                    p.noStroke();
                    p.rect(capX - gap / 2 - 15, midY - plateH / 2, 15, plateH);
                    p.fill(p.red(p.color(COLORS.positive)), p.green(p.color(COLORS.positive)), p.blue(p.color(COLORS.positive)), chargeAlpha);
                    p.rect(capX + gap / 2, midY - plateH / 2, 15, plateH);
                }
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('C', capX, midY + plateH / 2 + 18);

                // Inductor symbol
                p.stroke(isDark() ? '#b87333' : '#a0522d');
                p.strokeWeight(3);
                p.noFill();
                var nB = 5, bW = 50 / nB;
                for (var bi = 0; bi < nB; bi++) {
                    var bx = indX - 25 + bi * bW;
                    p.arc(bx + bW / 2, midY, bW, 20, Math.PI, 0);
                }

                // Magnetic field glow in inductor (proportional to current)
                var fieldAlpha = Math.abs(i) * 150 + 30;
                p.fill(p.red(p.color(COLORS.field)), p.green(p.color(COLORS.field)), p.blue(p.color(COLORS.field)), fieldAlpha);
                p.noStroke();
                p.ellipse(indX, midY - 5, 55, 25);

                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('L', indX, midY + 25);

                // Connecting wires
                p.stroke(COLORS.neutral);
                p.strokeWeight(2);
                // Top wire
                p.line(capX + gap / 2 + 15, midY - 30, capX + gap / 2 + 15, midY - 50);
                p.line(capX + gap / 2 + 15, midY - 50, indX, midY - 50);
                p.line(indX, midY - 50, indX - 25, midY);
                // Bottom wire
                p.line(capX - gap / 2 - 15, midY + 30, capX - gap / 2 - 15, midY + 50);
                p.line(capX - gap / 2 - 15, midY + 50, indX, midY + 50);
                p.line(indX, midY + 50, indX + 25, midY);

                // Animated current dots
                p.fill(COLORS.force);
                p.noStroke();
                var speed = i;
                var wireLen = 200;
                for (var di = 0; di < 3; di++) {
                    var pos = ((t * 20 * Math.abs(speed) + di * wireLen / 3) % wireLen);
                    if (Math.abs(speed) > 0.1) {
                        // Top wire dot
                        var frac = pos / wireLen;
                        var dx = capX + gap / 2 + 15 + frac * (indX - 25 - capX - gap / 2 - 15);
                        p.ellipse(dx, midY - 50, 5, 5);
                    }
                }

                // Energy bars
                var barX = W * 0.1, barW = W * 0.8, barY = H * 0.78, barH = 16;
                var eC = q * q; // U_E proportional to q^2
                var eL = i * i; // U_B proportional to i^2

                // Electric energy bar
                p.fill(isDark() ? '#333' : '#e5e7eb');
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                p.rect(barX, barY, barW, barH, 3);
                p.noStroke();
                p.fill(COLORS.positive);
                p.rect(barX + 1, barY + 1, (barW - 2) * eC, barH - 2, 2);
                p.fill(getTextColor());
                p.textSize(9);
                p.textAlign(p.LEFT);
                p.text('U_E (capacitor)', barX, barY - 3);

                // Magnetic energy bar
                p.fill(isDark() ? '#333' : '#e5e7eb');
                p.stroke(COLORS.neutral);
                p.strokeWeight(1);
                p.rect(barX, barY + 24, barW, barH, 3);
                p.noStroke();
                p.fill(COLORS.field);
                p.rect(barX + 1, barY + 25, (barW - 2) * eL, barH - 2, 2);
                p.fill(getTextColor());
                p.textSize(9);
                p.textAlign(p.LEFT);
                p.text('U_B (inductor)', barX, barY + 21);

                p.textStyle(p.NORMAL);

                // Frequency label
                if (freq_label) {
                    p.fill(COLORS.force);
                    p.textAlign(p.CENTER);
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('\u03c9 = ' + freq_label, cx || W / 2, H - 8);
                    p.textStyle(p.NORMAL);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'LC Oscillations', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: lcr-resonance
    //  Resonance curve: current vs frequency (Ch7)
    // =====================================================
    function lcrResonance(containerEl, params) {
        var f0 = params.resonance_freq || 8;
        var R_val = params.R || 40;
        var peak_label = params.peak_label || '';

        return new p5(function(p) {
            var W, H, dotT = 0;
            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 280;
                p.createCanvas(W, H);
            };
            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                dotT += 0.02;

                var plotLeft = W * 0.12, plotRight = W * 0.9;
                var plotTop = H * 0.12, plotBot = H * 0.8;
                var plotW = plotRight - plotLeft, plotH = plotBot - plotTop;

                // Axes
                p.stroke(COLORS.neutral);
                p.strokeWeight(1.5);
                p.line(plotLeft, plotBot, plotRight, plotBot);
                p.line(plotLeft, plotBot, plotLeft, plotTop);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.CENTER);
                p.text('Frequency f (Hz)', (plotLeft + plotRight) / 2, plotBot + 22);
                p.textAlign(p.CENTER);
                p.push();
                p.translate(plotLeft - 18, (plotTop + plotBot) / 2);
                p.rotate(-p.HALF_PI);
                p.text('Current I', 0, 0);
                p.pop();

                // Resonance curve (Lorentzian shape)
                var fMin = 0.5, fMax = f0 * 4;
                var gamma = R_val * 0.05; // width parameter
                p.stroke(COLORS.force);
                p.strokeWeight(2.5);
                p.noFill();
                p.beginShape();
                var peakI = 1;
                for (var fi = 0; fi <= plotW; fi += 2) {
                    var freq = fMin + (fi / plotW) * (fMax - fMin);
                    var ratio = freq / f0;
                    // I = V/Z, Z = sqrt(R^2 + ...), simplified Lorentzian
                    var I_norm = 1 / Math.sqrt(1 + Math.pow((ratio - 1 / ratio) / (gamma / f0), 2));
                    var py = plotBot - I_norm * plotH * 0.9;
                    p.vertex(plotLeft + fi, py);
                }
                p.endShape();

                // Peak marker (animated pulse)
                var peakX = plotLeft + ((f0 - fMin) / (fMax - fMin)) * plotW;
                var peakY = plotTop + plotH * 0.1;
                var pulseR = 5 + 2 * Math.sin(dotT * 3);
                p.fill(COLORS.force);
                p.noStroke();
                p.ellipse(peakX, peakY, pulseR * 2, pulseR * 2);

                // Dashed lines to axes at resonance
                p.stroke(COLORS.force);
                p.strokeWeight(1);
                drawDashedLine(p, peakX, peakY, peakX, plotBot);
                drawDashedLine(p, plotLeft, peakY, peakX, peakY);

                // f₀ label
                p.fill(COLORS.force);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('f\u2080=' + f0 + ' Hz', peakX, plotBot + 12);
                p.text('I_max', plotLeft - 5, peakY - 8);
                p.textStyle(p.NORMAL);

                // Peak label
                if (peak_label) {
                    p.fill(COLORS.surfaceStroke);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.textAlign(p.LEFT);
                    p.text(peak_label, peakX + 10, peakY + 4);
                    p.textStyle(p.NORMAL);
                }

                // "Resonance" annotation
                p.fill(getTextColor());
                p.textSize(10);
                p.textAlign(p.CENTER);
                p.text('Z = R (minimum) at resonance', (plotLeft + plotRight) / 2, H - 8);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'LCR Resonance', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  CH 8 — Electromagnetic Waves
    // =====================================================

    /**
     * displacement-current — animated capacitor with changing E field
     * params: title, I_label, E_label
     */
    function displacementCurrent(containerEl, params) {
        return new p5(function(p) {
            var W = 370, H = 300;
            var t = 0;
            p.setup = function() { p.createCanvas(W, H); };
            p.draw = function() {
                t += 0.02;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2, cy = H / 2;
                var plateW = 120, plateH = 10, gap = 80;
                var topY = cy - gap / 2, botY = cy + gap / 2;

                // Wires
                p.stroke(COLORS.neutral);
                p.strokeWeight(3);
                p.line(cx, 10, cx, topY);
                p.line(cx, botY, cx, H - 10);

                // Current dots on wires (animated)
                var nDots = 5;
                p.fill(COLORS.force);
                p.noStroke();
                for (var i = 0; i < nDots; i++) {
                    var frac = ((t * 0.5 + i / nDots) % 1);
                    // top wire: flowing downward
                    p.circle(cx, 10 + frac * (topY - 10), 5);
                    // bottom wire: flowing downward
                    p.circle(cx, botY + frac * (H - 10 - botY), 5);
                }

                // Plates
                p.fill(COLORS.plate);
                p.noStroke();
                p.rect(cx - plateW / 2, topY - plateH, plateW, plateH, 3);
                p.rect(cx - plateW / 2, botY, plateW, plateH, 3);

                // + / - labels
                var chargePhase = (Math.sin(t) + 1) / 2;
                p.textAlign(p.CENTER);
                p.textSize(16);
                p.fill(COLORS.positive);
                p.text('+', cx - plateW / 2 - 14, topY - 2);
                p.fill(COLORS.negative);
                p.text('−', cx - plateW / 2 - 14, botY + plateH + 2);

                // E-field arrows between plates (grow/shrink)
                var nLines = 5;
                var arrowAlpha = 0.4 + 0.6 * Math.abs(Math.sin(t));
                for (var i = 0; i < nLines; i++) {
                    var ax = cx - plateW / 3 + (i / (nLines - 1)) * plateW * 2 / 3;
                    var len = gap * 0.7 * (0.3 + 0.7 * Math.abs(Math.sin(t)));
                    var ay1 = cy - len / 2;
                    var ay2 = cy + len / 2;
                    p.stroke('rgba(139,92,246,' + arrowAlpha + ')');
                    p.strokeWeight(2);
                    p.line(ax, ay1, ax, ay2);
                    // arrowhead pointing down (+ to -)
                    p.line(ax, ay2, ax - 4, ay2 - 8);
                    p.line(ax, ay2, ax + 4, ay2 - 8);
                }

                // Displacement current label
                p.noStroke();
                p.fill(COLORS.field);
                p.textSize(11);
                p.textAlign(p.LEFT);
                p.text('E field', cx + plateW / 2 + 8, cy - 5);
                p.text('I_d = ε₀ dΦ_E/dt', cx + plateW / 2 + 8, cy + 12);

                // Circular B-field at edge (dashed circles)
                p.noFill();
                p.stroke(COLORS.negative);
                p.strokeWeight(1);
                var bRad = gap / 2 + 5;
                var nSeg = 24;
                for (var i = 0; i < nSeg; i++) {
                    if (i % 2 === 0) {
                        var a1 = (i / nSeg) * p.TWO_PI + t * 0.5;
                        var a2 = ((i + 1) / nSeg) * p.TWO_PI + t * 0.5;
                        var bx = cx + plateW / 2 + 20;
                        p.line(bx + bRad * 0.3 * Math.cos(a1), cy + bRad * 0.3 * Math.sin(a1),
                               bx + bRad * 0.3 * Math.cos(a2), cy + bRad * 0.3 * Math.sin(a2));
                    }
                }

                // I label on wire
                p.fill(COLORS.force);
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.LEFT);
                p.text(params.I_label || 'I', cx + 8, 30);

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Displacement Current', W / 2, H - 10);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    /**
     * em-wave-propagation — animated EM wave with E (red) and B (blue) perpendicular
     * params: title, label_E, label_B, lambda_label
     */
    function emWavePropagation(containerEl, params) {
        return new p5(function(p) {
            var W = 400, H = 300;
            var t = 0;
            p.setup = function() { p.createCanvas(W, H); };
            p.draw = function() {
                t += 0.03;
                p.background(getBg());
                drawGrid(p, 30);

                var cx = W / 2, cy = H / 2;
                var axisLen = W - 60;
                var startX = 30;
                var ampE = 80;
                var ampB = 50;

                // Propagation axis (z-axis)
                p.stroke(getAxisColor());
                p.strokeWeight(1.5);
                drawArrow(p, startX, cy, startX + axisLen, cy, getTextColor(), 1.5);
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(12);
                p.textAlign(p.LEFT);
                p.text('z', startX + axisLen + 4, cy + 4);

                // E-field (vertical, red sine wave)
                p.noFill();
                p.stroke(COLORS.positive);
                p.strokeWeight(2);
                p.beginShape();
                var nPts = 200;
                for (var i = 0; i <= nPts; i++) {
                    var frac = i / nPts;
                    var px = startX + frac * axisLen;
                    var phase = frac * 4 * Math.PI - t * 3;
                    var ey = cy - ampE * Math.sin(phase);
                    p.vertex(px, ey);
                }
                p.endShape();

                // E-field fill (semi-transparent)
                p.fill('rgba(239, 68, 68, 0.08)');
                p.noStroke();
                p.beginShape();
                p.vertex(startX, cy);
                for (var i = 0; i <= nPts; i++) {
                    var frac = i / nPts;
                    var px = startX + frac * axisLen;
                    var phase = frac * 4 * Math.PI - t * 3;
                    p.vertex(px, cy - ampE * Math.sin(phase));
                }
                p.vertex(startX + axisLen, cy);
                p.endShape(p.CLOSE);

                // B-field (depth axis, shown as horizontal offset from axis, blue sine)
                p.noFill();
                p.stroke(COLORS.negative);
                p.strokeWeight(2);
                p.beginShape();
                for (var i = 0; i <= nPts; i++) {
                    var frac = i / nPts;
                    var px = startX + frac * axisLen;
                    var phase = frac * 4 * Math.PI - t * 3;
                    // Show B as horizontal displacement (pseudo-3D)
                    var bx = px;
                    var by = cy + ampB * Math.sin(phase) * 0.5;
                    // Skew to show perspective
                    p.vertex(bx + ampB * 0.4 * Math.sin(phase), by);
                }
                p.endShape();

                // Vertical E arrows at quarter-wavelength intervals
                p.strokeWeight(1);
                for (var i = 0; i < 8; i++) {
                    var frac = (i + 0.5) / 8;
                    var px = startX + frac * axisLen;
                    var phase = frac * 4 * Math.PI - t * 3;
                    var ey = -ampE * Math.sin(phase);
                    if (Math.abs(ey) > 5) {
                        p.stroke(COLORS.positive);
                        p.strokeWeight(1);
                        p.line(px, cy, px, cy + ey);
                    }
                }

                // Labels
                p.noStroke();
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.fill(COLORS.positive);
                p.textAlign(p.LEFT);
                p.text('E', 10, cy - ampE - 5);
                p.fill(COLORS.negative);
                p.text('B', W - 35, cy + ampB * 0.5 + 20);
                p.textStyle(p.NORMAL);

                // Propagation arrow
                p.fill(COLORS.force);
                p.textSize(10);
                p.textAlign(p.CENTER);
                p.text('c →', startX + axisLen / 2, cy + ampE + 25);

                // Lambda/info label
                if (params.lambda_label) {
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.textAlign(p.RIGHT);
                    p.text(params.lambda_label, W - 10, 20);
                }

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'EM Wave Propagation', W / 2, H - 10);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    /**
     * em-spectrum — animated EM spectrum bar
     * params: title, highlight, highlight_label
     * highlight: "radio"|"microwave"|"infrared"|"visible"|"uv"|"xray"|"gamma"
     */
    function emSpectrum(containerEl, params) {
        return new p5(function(p) {
            var W = 400, H = 260;
            var t = 0;
            var bands = [
                { name: 'Radio',      f_min: 3e4,   f_max: 3e9,   color: '#ef4444' },
                { name: 'Microwave',  f_min: 3e9,   f_max: 3e11,  color: '#f97316' },
                { name: 'Infrared',   f_min: 3e11,  f_max: 4.3e14, color: '#f59e0b' },
                { name: 'Visible',    f_min: 4.3e14, f_max: 7.5e14, color: '#22c55e' },
                { name: 'UV',         f_min: 7.5e14, f_max: 3e16,  color: '#3b82f6' },
                { name: 'X-ray',      f_min: 3e16,  f_max: 3e19,  color: '#8b5cf6' },
                { name: 'Gamma',      f_min: 3e19,  f_max: 3e22,  color: '#ec4899' }
            ];
            p.setup = function() { p.createCanvas(W, H); };
            p.draw = function() {
                t += 0.015;
                p.background(getBg());

                var barLeft = 30, barRight = W - 30;
                var barTop = 70, barH = 50;
                var totalW = barRight - barLeft;
                var bandW = totalW / bands.length;

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(13);
                p.textStyle(p.BOLD);
                p.text(params.title || 'Electromagnetic Spectrum', W / 2, 25);
                p.textStyle(p.NORMAL);

                // Frequency arrow
                p.textSize(10);
                p.fill(getTextColor());
                p.textAlign(p.CENTER);
                p.text('Frequency →', (barLeft + barRight) / 2, barTop - 20);
                p.text('← Wavelength', (barLeft + barRight) / 2, barTop - 8);

                // Draw bands
                var highlight = (params.highlight || '').toLowerCase();
                for (var i = 0; i < bands.length; i++) {
                    var bx = barLeft + i * bandW;
                    var isHighlighted = highlight && bands[i].name.toLowerCase().indexOf(highlight) >= 0;

                    // Band rect
                    var alpha = isHighlighted ? (0.7 + 0.3 * Math.sin(t * 3)) : 0.6;
                    p.fill(p.color(bands[i].color + (isHighlighted ? '' : '99')));
                    p.noStroke();
                    var bh = isHighlighted ? barH + 8 : barH;
                    var bt = isHighlighted ? barTop - 4 : barTop;
                    p.rect(bx, bt, bandW, bh, i === 0 ? 4 : 0, i === bands.length - 1 ? 4 : 0,
                           i === bands.length - 1 ? 4 : 0, i === 0 ? 4 : 0);

                    // Band label
                    p.fill(isHighlighted ? '#ffffff' : getTextColor());
                    p.textSize(isHighlighted ? 10 : 8);
                    p.textStyle(isHighlighted ? p.BOLD : p.NORMAL);
                    p.textAlign(p.CENTER);
                    p.text(bands[i].name, bx + bandW / 2, barTop + barH / 2 + 4);
                }

                // Animated wave visualization below the bar
                var waveY = barTop + barH + 40;
                p.noFill();
                p.strokeWeight(2);

                // Show two contrasting waves: low freq (radio) and high freq
                // Low frequency wave
                p.stroke(bands[0].color);
                p.beginShape();
                for (var x = barLeft; x <= barRight; x += 2) {
                    var frac = (x - barLeft) / totalW;
                    p.vertex(x, waveY - 20 * Math.sin(frac * 4 * Math.PI - t * 2));
                }
                p.endShape();
                p.noStroke();
                p.fill(bands[0].color);
                p.textSize(8);
                p.textAlign(p.LEFT);
                p.text('Low f, long λ', barLeft, waveY + 30);

                // High frequency wave
                p.stroke(bands[5].color);
                p.strokeWeight(2);
                p.noFill();
                var waveY2 = waveY + 50;
                p.beginShape();
                for (var x = barLeft; x <= barRight; x += 2) {
                    var frac = (x - barLeft) / totalW;
                    p.vertex(x, waveY2 - 15 * Math.sin(frac * 20 * Math.PI - t * 8));
                }
                p.endShape();
                p.noStroke();
                p.fill(bands[5].color);
                p.textSize(8);
                p.textAlign(p.LEFT);
                p.text('High f, short λ', barLeft, waveY2 + 25);

                // Highlight label
                if (params.highlight_label) {
                    p.fill(COLORS.force);
                    p.textSize(11);
                    p.textAlign(p.CENTER);
                    p.text(params.highlight_label, W / 2, barTop + barH + 18);
                }

                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: wave-interference
    //  Young's double slit interference pattern (Ch10)
    //  Params: wavelength_nm, slit_sep_mm, screen_dist_m, title
    // =====================================================
    function waveInterference(containerEl, params) {
        var lambda = params.wavelength_nm || 600;
        var d = params.slit_sep_mm || 0.5;
        var D = params.screen_dist_m || 1;

        return new p5(function(p) {
            var W, H, t = 0;
            var slitX, screenX, cy;
            var fringeWidth;

            p.setup = function() {
                W = containerEl.offsetWidth || 550;
                H = params.height || 340;
                p.createCanvas(W, H);
                slitX = W * 0.25;
                screenX = W * 0.82;
                cy = H * 0.5;
                // Fringe width beta = lambda * D / d (in mm)
                fringeWidth = (lambda * 1e-6 * D) / (d * 1e-3) * 1000;
            };

            p.draw = function() {
                p.background(getBg());
                t += 0.03;
                var tc = getTextColor();
                var dk = isDark();

                // ── Source on left ──
                p.fill(COLORS.force);
                p.noStroke();
                p.ellipse(W * 0.08, cy, 10, 10);
                p.fill(tc); p.textSize(9); p.textAlign(p.CENTER);
                p.text('Source', W * 0.08, cy + 16);

                // ── Barrier with two slits ──
                p.stroke(dk ? '#64748b' : '#475569');
                p.strokeWeight(4);
                var slitGap = H * 0.06;
                var slitH = 8;
                p.line(slitX, 0, slitX, cy - slitGap - slitH);
                p.line(slitX, cy - slitGap + slitH, slitX, cy + slitGap - slitH);
                p.line(slitX, cy + slitGap + slitH, slitX, H);

                // Slit labels
                p.noStroke(); p.fill(COLORS.force); p.textSize(8);
                p.text('S\u2081', slitX + 10, cy - slitGap);
                p.text('S\u2082', slitX + 10, cy + slitGap);

                // ── Animated circular waves from slits ──
                p.noFill();
                p.strokeWeight(1);
                var waveSpeed = 80;
                for (var wi = 0; wi < 8; wi++) {
                    var r = ((t * waveSpeed + wi * 30) % 300);
                    var alpha = Math.max(0, 1 - r / 300) * (dk ? 80 : 60);
                    p.stroke(dk ? 'rgba(245,158,11,' + (alpha / 255) + ')' : 'rgba(234,88,12,' + (alpha / 255) + ')');
                    p.ellipse(slitX, cy - slitGap, r * 2, r * 2);
                    p.ellipse(slitX, cy + slitGap, r * 2, r * 2);
                }

                // ── Screen ──
                p.stroke(dk ? '#475569' : '#94a3b8');
                p.strokeWeight(2);
                p.line(screenX, 20, screenX, H - 20);

                // ── Interference pattern on screen ──
                var patternH = H * 0.7;
                var patternTop = cy - patternH / 2;
                // Scale: 1 fringe width in pixels
                var fringePixels = patternH / 10;
                for (var iy = 0; iy < patternH; iy += 2) {
                    var yy = patternTop + iy;
                    var yOffset = yy - cy;
                    // Intensity: I = I0 * cos^2(pi * d * y / (lambda * D))
                    var phase = Math.PI * yOffset / fringePixels;
                    var intensity = Math.pow(Math.cos(phase), 2);
                    var bright = Math.round(intensity * (dk ? 230 : 200));
                    if (dk) {
                        p.stroke(bright, bright, Math.min(255, bright + 50));
                    } else {
                        p.stroke(Math.max(0, 200 - bright), Math.max(0, 100 - bright), bright);
                    }
                    p.strokeWeight(2);
                    p.line(screenX + 3, yy, screenX + 18, yy);
                }

                // ── Fringe order labels ──
                p.noStroke(); p.fill(tc); p.textSize(8); p.textAlign(p.LEFT);
                p.text('m=0', screenX + 22, cy + 3);
                p.text('m=1', screenX + 22, cy - fringePixels + 3);
                p.text('m=-1', screenX + 22, cy + fringePixels + 3);

                // ── Path lines from slits to screen center ──
                p.stroke(dk ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.08)');
                p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 5]);
                p.line(slitX, cy - slitGap, screenX, cy);
                p.line(slitX, cy + slitGap, screenX, cy);
                p.drawingContext.setLineDash([]);

                // ── d and D labels ──
                p.stroke(COLORS.field); p.strokeWeight(1);
                drawArrow(p, slitX + 16, cy - slitGap, slitX + 16, cy + slitGap, COLORS.field, 1);
                p.noStroke(); p.fill(COLORS.field); p.textSize(9);
                p.text('d', slitX + 22, cy + 3);

                p.stroke(COLORS.neutral); p.strokeWeight(1);
                p.drawingContext.setLineDash([2, 3]);
                p.line(slitX, H - 15, screenX, H - 15);
                p.drawingContext.setLineDash([]);
                p.noStroke(); p.fill(COLORS.neutral); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('D', (slitX + screenX) / 2, H - 5);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Young\'s Double Slit Interference', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('\u03bb=' + lambda + 'nm  d=' + d + 'mm  D=' + D + 'm  \u03b2=' + fringeWidth.toFixed(2) + 'mm',
                    W - 10, H - 5);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: photoelectric-effect
    //  Photon hits metal → electron ejected (Ch11)
    //  Params: work_function_eV, photon_energy_eV, title
    // =====================================================
    function photoelectricEffect(containerEl, params) {
        var phi = params.work_function_eV || 2.14;
        var Ephoton = params.photon_energy_eV || 3.0;

        return new p5(function(p) {
            var W, H, t = 0;
            var metalX, metalW;
            var canEject;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 320;
                p.createCanvas(W, H);
                metalX = W * 0.4;
                metalW = W * 0.25;
                canEject = Ephoton >= phi;
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.02;
                var tc = getTextColor();
                var dk = isDark();

                // ── Metal plate ──
                p.fill(dk ? '#475569' : '#94a3b8');
                p.stroke(dk ? '#64748b' : '#475569');
                p.strokeWeight(2);
                p.rect(metalX, H * 0.2, metalW, H * 0.6, 4);
                p.noStroke(); p.fill(tc); p.textSize(10); p.textAlign(p.CENTER);
                p.text('Metal', metalX + metalW / 2, H * 0.2 - 8);
                p.text('\u03d5 = ' + phi + ' eV', metalX + metalW / 2, H * 0.85 + 12);

                // ── Incoming photons (wavy arrows from left) ──
                var photonY = [H * 0.35, H * 0.5, H * 0.65];
                for (var pi = 0; pi < photonY.length; pi++) {
                    var py = photonY[pi];
                    var phase = (t + pi * 0.5) % 1.5;
                    var px = W * 0.05 + phase * (metalX - W * 0.05);

                    // Wavy photon
                    p.stroke(COLORS.force);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var wx = px - 30; wx < px; wx += 2) {
                        p.vertex(wx, py + 4 * Math.sin((wx - px) * 0.5 + t * 5));
                    }
                    p.endShape();

                    // Photon dot
                    p.fill(COLORS.force);
                    p.noStroke();
                    p.ellipse(px, py, 8, 8);

                    // Label on first photon
                    if (pi === 0 && phase < 0.3) {
                        p.fill(COLORS.force); p.textSize(9); p.textAlign(p.LEFT);
                        p.text('h\u03bd = ' + Ephoton + ' eV', px + 10, py - 8);
                    }
                }

                // ── Ejected electrons (if energy sufficient) ──
                if (canEject) {
                    var KE = Ephoton - phi;
                    p.fill(COLORS.negative);
                    p.noStroke();
                    for (var ei = 0; ei < 4; ei++) {
                        var ePhase = (t * 0.8 + ei * 0.4) % 2;
                        if (ePhase < 1.5) {
                            var ex = metalX + metalW + ePhase * W * 0.22;
                            var ey = H * 0.3 + ei * H * 0.12 + Math.sin(ePhase * 3) * 10;
                            // Glow
                            p.fill(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), 40);
                            p.ellipse(ex, ey, 16, 16);
                            p.fill(COLORS.negative);
                            p.ellipse(ex, ey, 6, 6);
                            // e- label
                            if (ei === 0 && ePhase < 0.5) {
                                p.textSize(8); p.textAlign(p.LEFT);
                                p.text('e\u207b', ex + 8, ey - 4);
                            }
                        }
                    }
                    // KE label
                    p.fill(COLORS.surfaceStroke); p.textSize(10); p.textAlign(p.LEFT);
                    p.text('KE_max = ' + KE.toFixed(2) + ' eV', metalX + metalW + 10, H * 0.18);
                } else {
                    p.fill(COLORS.positive); p.textSize(11); p.textAlign(p.CENTER);
                    p.text('No emission (h\u03bd < \u03d5)', metalX + metalW + W * 0.15, H * 0.5);
                }

                // ── Energy level diagram (right side) ──
                var diagX = W * 0.8;
                var diagW = W * 0.15;
                var diagTop = H * 0.25;
                var diagBot = H * 0.75;
                var eScale = (diagBot - diagTop) / Math.max(Ephoton, phi) / 1.3;

                // Vacuum level
                p.stroke(dk ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.15)');
                p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 3]);
                var vacY = diagBot - phi * eScale;
                p.line(diagX - diagW / 2, vacY, diagX + diagW / 2, vacY);
                p.drawingContext.setLineDash([]);
                p.noStroke(); p.fill(COLORS.neutral); p.textSize(8); p.textAlign(p.LEFT);
                p.text('Vacuum', diagX + diagW / 2 + 3, vacY + 3);

                // Photon energy arrow
                var phY = diagBot - Ephoton * eScale;
                p.stroke(COLORS.force); p.strokeWeight(1.5);
                drawArrow(p, diagX, diagBot, diagX, phY, COLORS.force, 1.5);
                p.noStroke(); p.fill(COLORS.force); p.textSize(8);
                p.textAlign(p.RIGHT);
                p.text('h\u03bd', diagX - 5, (diagBot + phY) / 2 + 3);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Photoelectric Effect', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Formula ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('KE_max = h\u03bd \u2212 \u03d5', W - 10, H - 5);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: bohr-model
    //  Electron orbits and energy level transitions (Ch12)
    //  Params: n_initial, n_final, show_transition, title
    // =====================================================
    function bohrModel(containerEl, params) {
        var nInit = params.n_initial || 3;
        var nFinal = params.n_final || 1;
        var showTrans = params.show_transition !== false;

        return new p5(function(p) {
            var W, H, t = 0;
            var cx, cy, maxR;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 340;
                p.createCanvas(W, H);
                cx = W * 0.42;
                cy = H * 0.5;
                maxR = Math.min(W * 0.35, H * 0.4);
            };

            p.draw = function() {
                p.background(getBg());
                t += 0.02;
                var tc = getTextColor();
                var dk = isDark();
                var maxN = Math.max(nInit, 4);

                // ── Nucleus ──
                p.fill(COLORS.positive);
                p.noStroke();
                p.ellipse(cx, cy, 16, 16);
                p.fill(dk ? '#fef3c7' : '#92400e');
                p.textSize(8); p.textAlign(p.CENTER, p.CENTER);
                p.text('+', cx, cy);

                // ── Orbits ──
                for (var n = 1; n <= maxN; n++) {
                    var r = (n / maxN) * maxR;
                    p.noFill();
                    p.stroke(dk ? 'rgba(255,255,255,0.12)' : 'rgba(0,0,0,0.1)');
                    p.strokeWeight(1);
                    if (n === nInit || n === nFinal) {
                        p.stroke(n === nInit ? 'rgba(59,130,246,0.4)' : 'rgba(239,68,68,0.4)');
                        p.strokeWeight(2);
                    }
                    p.ellipse(cx, cy, r * 2, r * 2);

                    // n label
                    p.noStroke();
                    p.fill(COLORS.neutral);
                    p.textSize(9); p.textAlign(p.LEFT);
                    p.text('n=' + n, cx + r + 4, cy - 3);

                    // Energy level
                    var E = -13.6 / (n * n);
                    p.textSize(8);
                    p.text(E.toFixed(2) + ' eV', cx + r + 4, cy + 8);
                }

                // ── Electron on initial orbit ──
                var eR = (nInit / maxN) * maxR;
                var eAngle = t * 1.5;
                var ex = cx + eR * Math.cos(eAngle);
                var ey = cy + eR * Math.sin(eAngle);
                p.fill(COLORS.negative);
                p.noStroke();
                // Glow
                p.fill(p.red(p.color(COLORS.negative)), p.green(p.color(COLORS.negative)), p.blue(p.color(COLORS.negative)), 50);
                p.ellipse(ex, ey, 18, 18);
                p.fill(COLORS.negative);
                p.ellipse(ex, ey, 8, 8);

                // ── Transition photon ──
                if (showTrans) {
                    var transPhase = (t * 0.5) % 3;
                    if (transPhase > 1 && transPhase < 2.5) {
                        var tp = (transPhase - 1) / 1.5;
                        var rI = (nInit / maxN) * maxR;
                        var rF = (nFinal / maxN) * maxR;
                        var photonR = rI + (rI + 40) * (tp);
                        var photonAngle = eAngle + 0.5;
                        var ppx = cx + photonR * Math.cos(photonAngle);
                        var ppy = cy + photonR * Math.sin(photonAngle);

                        if (ppx > 0 && ppx < W && ppy > 0 && ppy < H) {
                            // Wavy line
                            p.stroke(COLORS.force);
                            p.strokeWeight(1.5);
                            p.noFill();
                            p.beginShape();
                            for (var wi = -15; wi <= 0; wi += 2) {
                                var wAngle = photonAngle;
                                var wr = photonR + wi;
                                p.vertex(
                                    cx + wr * Math.cos(wAngle) + 3 * Math.sin(wi * 0.8),
                                    cy + wr * Math.sin(wAngle) + 3 * Math.cos(wi * 0.8)
                                );
                            }
                            p.endShape();
                            p.fill(COLORS.force);
                            p.noStroke();
                            p.ellipse(ppx, ppy, 7, 7);
                        }
                    }

                    // Transition arrow on right side
                    var diagX = W * 0.82;
                    var diagTop = H * 0.15;
                    var diagBot = H * 0.85;
                    var levels = maxN;
                    for (var ln = 1; ln <= levels; ln++) {
                        var ly = diagBot - (1 - 1 / (ln * ln)) * (diagBot - diagTop);
                        p.stroke(dk ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.15)');
                        p.strokeWeight(1);
                        p.line(diagX - 20, ly, diagX + 20, ly);
                        p.noStroke(); p.fill(COLORS.neutral); p.textSize(8);
                        p.textAlign(p.LEFT);
                        p.text('n=' + ln, diagX + 24, ly + 3);
                    }

                    // Transition arrow
                    var yI = diagBot - (1 - 1 / (nInit * nInit)) * (diagBot - diagTop);
                    var yF = diagBot - (1 - 1 / (nFinal * nFinal)) * (diagBot - diagTop);
                    drawArrow(p, diagX, yI, diagX, yF, COLORS.force, 2);
                    var dE = 13.6 * (1 / (nFinal * nFinal) - 1 / (nInit * nInit));
                    p.noStroke(); p.fill(COLORS.force); p.textSize(8); p.textAlign(p.RIGHT);
                    p.text('\u0394E=' + dE.toFixed(2) + 'eV', diagX - 5, (yI + yF) / 2 + 3);
                }

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Bohr Model \u2014 Hydrogen Atom', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('E_n = -13.6/n\u00b2 eV', W - 10, H - 5);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: nuclear-binding-energy
    //  BE/A vs mass number curve (Ch13)
    //  Params: highlight_nuclei (array of {A, name}), title
    // =====================================================
    function nuclearBindingEnergy(containerEl, params) {
        var highlights = params.highlight_nuclei || [
            { A: 2, name: 'H-2', bea: 1.1 },
            { A: 4, name: 'He-4', bea: 7.07 },
            { A: 56, name: 'Fe-56', bea: 8.79 },
            { A: 120, name: 'Sn-120', bea: 8.5 },
            { A: 238, name: 'U-238', bea: 7.57 }
        ];

        return new p5(function(p) {
            var W, H;
            var plotLeft, plotRight, plotTop, plotBot;

            p.setup = function() {
                W = containerEl.offsetWidth || 550;
                H = params.height || 320;
                p.createCanvas(W, H);
                plotLeft = 55;
                plotRight = W - 30;
                plotTop = 40;
                plotBot = H - 45;
                p.noLoop();
            };

            p.draw = function() {
                p.background(getBg());
                var tc = getTextColor();
                var dk = isDark();
                var plotW = plotRight - plotLeft;
                var plotH = plotBot - plotTop;

                // ── Axes ──
                p.stroke(getAxisColor());
                p.strokeWeight(1);
                p.line(plotLeft, plotTop, plotLeft, plotBot);
                p.line(plotLeft, plotBot, plotRight, plotBot);

                // Y-axis ticks (BE/A: 0 to 9)
                p.fill(tc); p.noStroke(); p.textSize(9); p.textAlign(p.RIGHT, p.CENTER);
                for (var yv = 0; yv <= 9; yv++) {
                    var yy = plotBot - (yv / 9) * plotH;
                    p.stroke(getGridColor()); p.strokeWeight(0.5);
                    p.line(plotLeft, yy, plotRight, yy);
                    p.noStroke(); p.fill(tc);
                    p.text(yv, plotLeft - 5, yy);
                }
                p.textAlign(p.CENTER);
                p.push();
                p.translate(15, (plotTop + plotBot) / 2);
                p.rotate(-p.HALF_PI);
                p.text('BE/A (MeV)', 0, 0);
                p.pop();

                // X-axis ticks (A: 0 to 250)
                p.textAlign(p.CENTER, p.TOP);
                for (var xv = 0; xv <= 250; xv += 50) {
                    var xx = plotLeft + (xv / 250) * plotW;
                    p.stroke(getGridColor()); p.strokeWeight(0.5);
                    p.line(xx, plotTop, xx, plotBot);
                    p.noStroke(); p.fill(tc);
                    p.text(xv, xx, plotBot + 4);
                }
                p.text('Mass Number (A)', (plotLeft + plotRight) / 2, plotBot + 18);

                // ── BE/A curve (approximate) ──
                p.noFill();
                p.stroke(dk ? '#60a5fa' : '#2563eb');
                p.strokeWeight(2.5);
                p.beginShape();
                for (var A = 2; A <= 250; A++) {
                    var bea = beaApprox(A);
                    var px = plotLeft + (A / 250) * plotW;
                    var py = plotBot - (bea / 9) * plotH;
                    p.vertex(px, py);
                }
                p.endShape();

                // ── Highlight nuclei ──
                for (var hi = 0; hi < highlights.length; hi++) {
                    var h = highlights[hi];
                    var hx = plotLeft + (h.A / 250) * plotW;
                    var hy = plotBot - (h.bea / 9) * plotH;
                    p.fill(COLORS.positive);
                    p.noStroke();
                    p.ellipse(hx, hy, 8, 8);
                    p.fill(tc); p.textSize(9);
                    p.textAlign(h.A < 30 ? p.LEFT : p.CENTER);
                    p.text(h.name, hx + (h.A < 30 ? 6 : 0), hy - 10);
                }

                // ── Fission / Fusion labels ──
                p.fill(COLORS.surfaceStroke); p.textSize(10); p.textAlign(p.CENTER);
                p.text('\u2190 Fusion', plotLeft + plotW * 0.12, plotTop + 15);
                p.text('Fission \u2192', plotLeft + plotW * 0.85, plotTop + 15);

                // ── Peak label ──
                var peakX = plotLeft + (56 / 250) * plotW;
                var peakY = plotBot - (8.79 / 9) * plotH;
                p.fill(COLORS.force); p.textSize(9);
                p.text('\u2191 Most stable', peakX, peakY - 14);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Nuclear Binding Energy per Nucleon', W / 2, 18);
                p.textStyle(p.NORMAL);
            };

            // Approximate BE/A curve (semi-empirical mass formula simplified)
            function beaApprox(A) {
                if (A < 2) return 0;
                var aV = 15.56, aS = 17.23, aC = 0.7, aA = 23.285;
                var Z = Math.round(A / 2.1);
                var BE = aV * A - aS * Math.pow(A, 2 / 3) - aC * Z * (Z - 1) / Math.pow(A, 1 / 3) - aA * Math.pow(A - 2 * Z, 2) / A;
                return Math.max(0, BE / A);
            }
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: pn-junction
    //  p-n junction with depletion region (Ch14)
    //  Params: bias ('forward'|'reverse'|'none'), title
    // =====================================================
    function pnJunction(containerEl, params) {
        var bias = params.bias || 'none';

        return new p5(function(p) {
            var W, H, t = 0;
            var juncX;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 300;
                p.createCanvas(W, H);
                juncX = W * 0.5;
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.02;
                var tc = getTextColor();
                var dk = isDark();

                var blockTop = H * 0.25;
                var blockBot = H * 0.7;
                var blockH = blockBot - blockTop;
                var depW = bias === 'reverse' ? W * 0.12 : bias === 'forward' ? W * 0.04 : W * 0.08;

                // ── p-type region ──
                p.fill(dk ? 'rgba(239,68,68,0.15)' : 'rgba(239,68,68,0.12)');
                p.stroke(dk ? '#f87171' : '#dc2626');
                p.strokeWeight(2);
                p.rect(W * 0.1, blockTop, juncX - depW / 2 - W * 0.1, blockH, 4, 0, 0, 4);
                p.noStroke(); p.fill(dk ? '#fca5a5' : '#dc2626');
                p.textSize(14); p.textAlign(p.CENTER, p.CENTER);
                p.text('p', (W * 0.1 + juncX - depW / 2) / 2, (blockTop + blockBot) / 2);

                // ── n-type region ──
                p.fill(dk ? 'rgba(59,130,246,0.15)' : 'rgba(59,130,246,0.12)');
                p.stroke(dk ? '#60a5fa' : '#2563eb');
                p.strokeWeight(2);
                p.rect(juncX + depW / 2, blockTop, W * 0.9 - juncX - depW / 2, blockH, 0, 4, 4, 0);
                p.noStroke(); p.fill(dk ? '#93c5fd' : '#2563eb');
                p.textSize(14); p.textAlign(p.CENTER, p.CENTER);
                p.text('n', (juncX + depW / 2 + W * 0.9) / 2, (blockTop + blockBot) / 2);

                // ── Depletion region ──
                p.fill(dk ? 'rgba(148,163,184,0.12)' : 'rgba(148,163,184,0.15)');
                p.stroke(dk ? '#64748b' : '#94a3b8');
                p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.rect(juncX - depW / 2, blockTop, depW, blockH);
                p.drawingContext.setLineDash([]);
                p.noStroke(); p.fill(COLORS.neutral); p.textSize(8);
                p.textAlign(p.CENTER);
                p.text('Depletion', juncX, blockTop - 5);

                // ── Charge carriers ──
                // Holes in p (+ symbols)
                p.fill(dk ? 'rgba(252,165,165,0.6)' : 'rgba(220,38,38,0.5)');
                p.textSize(10); p.textAlign(p.CENTER, p.CENTER);
                var pLeft = W * 0.12;
                var pRight = juncX - depW / 2 - 5;
                for (var hi = 0; hi < 6; hi++) {
                    var hx = pLeft + (hi % 3) * ((pRight - pLeft) / 3) + 10;
                    var hy = blockTop + 15 + Math.floor(hi / 3) * (blockH / 3) + Math.sin(t + hi) * 3;
                    p.text('+', hx, hy);
                }

                // Electrons in n (- symbols)
                p.fill(dk ? 'rgba(147,197,253,0.6)' : 'rgba(37,99,235,0.5)');
                var nLeft = juncX + depW / 2 + 5;
                var nRight = W * 0.88;
                for (var ei = 0; ei < 6; ei++) {
                    var exx = nLeft + (ei % 3) * ((nRight - nLeft) / 3) + 10;
                    var ey = blockTop + 15 + Math.floor(ei / 3) * (blockH / 3) + Math.sin(t + ei + 2) * 3;
                    p.text('\u2013', exx, ey);
                }

                // ── Forward bias: current flow ──
                if (bias === 'forward') {
                    p.noStroke();
                    for (var fi = 0; fi < 3; fi++) {
                        var fph = (t * 0.8 + fi * 0.5) % 2;
                        var fpx, fpy = blockTop + blockH * (0.3 + fi * 0.2);
                        if (fph < 1) {
                            fpx = pLeft + fph * (W * 0.8 - pLeft);
                        } else {
                            fpx = pLeft + (W * 0.8 - pLeft);
                        }
                        if (fph < 1.8) {
                            p.fill(COLORS.force);
                            p.ellipse(fpx, fpy, 5, 5);
                        }
                    }
                    p.fill(COLORS.surfaceStroke); p.textSize(10); p.textAlign(p.CENTER);
                    p.text('Current \u2192', juncX, blockBot + 20);
                }

                // ── Built-in potential arrow ──
                p.stroke(COLORS.field); p.strokeWeight(1.5);
                var eFieldY = blockBot + 14;
                drawArrow(p, juncX + depW / 2 - 3, eFieldY, juncX - depW / 2 + 3, eFieldY, COLORS.field, 1.5);
                p.noStroke(); p.fill(COLORS.field); p.textSize(8); p.textAlign(p.CENTER);
                p.text('E', juncX, eFieldY - 6);

                // ── Battery (if biased) ──
                if (bias !== 'none') {
                    p.fill(tc); p.textSize(9); p.textAlign(p.CENTER);
                    var battLabel = bias === 'forward' ? 'V (Forward Bias)' : 'V (Reverse Bias)';
                    p.text(battLabel, juncX, H - 10);
                }

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'p-n Junction', W / 2, 18);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: refraction
    //  Snell's law at a plane interface (Ch9 Ray Optics)
    //  Params: n1, n2, angle_i (degrees), medium1, medium2, title, height
    // =====================================================
    function refractionSketch(containerEl, params) {
        var n1 = params.n1 || 1.0;
        var n2 = params.n2 || 1.5;
        var angleIDeg = params.angle_i || 45;
        var med1 = params.medium1 || 'Air';
        var med2 = params.medium2 || 'Glass';

        return new p5(function(p) {
            var W, H, t = 0;
            var interfaceY, angleI, angleR, sinR;
            var isTIR = false;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 340;
                p.createCanvas(W, H);
                interfaceY = H * 0.5;
                angleI = angleIDeg * Math.PI / 180;
                sinR = (n1 / n2) * Math.sin(angleI);
                if (sinR > 1) { isTIR = true; angleR = Math.PI / 2; }
                else { isTIR = false; angleR = Math.asin(sinR); }
            };

            p.draw = function() {
                p.background(getBg());
                t += 0.015;
                var tc = getTextColor();
                var dk = isDark();

                // ── Media backgrounds ──
                p.noStroke();
                p.fill(dk ? 'rgba(59,130,246,0.06)' : 'rgba(59,130,246,0.08)');
                p.rect(0, 0, W, interfaceY);
                p.fill(dk ? 'rgba(34,197,94,0.08)' : 'rgba(34,197,94,0.10)');
                p.rect(0, interfaceY, W, H - interfaceY);

                // ── Interface line ──
                p.stroke(dk ? '#64748b' : '#94a3b8');
                p.strokeWeight(2);
                p.line(0, interfaceY, W, interfaceY);

                // ── Normal (dashed) ──
                var cx = W * 0.5;
                p.stroke(dk ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.2)');
                p.strokeWeight(1);
                p.drawingContext.setLineDash([5, 5]);
                p.line(cx, 20, cx, H - 20);
                p.drawingContext.setLineDash([]);

                // ── Incident ray ──
                var rayLen = Math.min(W, H) * 0.38;
                var incX = cx - rayLen * Math.sin(angleI);
                var incY = interfaceY - rayLen * Math.cos(angleI);
                p.stroke('#f59e0b');
                p.strokeWeight(2);
                p.line(incX, incY, cx, interfaceY);
                // Arrow head at interface
                drawArrow(p, incX, incY, cx, interfaceY, '#f59e0b', 2);

                // ── Reflected ray ──
                var refX = cx + rayLen * 0.7 * Math.sin(angleI);
                var refY = interfaceY - rayLen * 0.7 * Math.cos(angleI);
                p.stroke(dk ? 'rgba(148,163,184,0.5)' : 'rgba(100,116,139,0.5)');
                p.strokeWeight(1.5);
                p.drawingContext.setLineDash([4, 4]);
                p.line(cx, interfaceY, refX, refY);
                p.drawingContext.setLineDash([]);

                // ── Refracted ray ──
                if (!isTIR) {
                    var rfrX = cx + rayLen * Math.sin(angleR);
                    var rfrY = interfaceY + rayLen * Math.cos(angleR);
                    drawArrow(p, cx, interfaceY, rfrX, rfrY, '#3b82f6', 2);
                } else {
                    // Total internal reflection: strong reflected ray
                    p.stroke(COLORS.positive);
                    p.strokeWeight(2);
                    p.drawingContext.setLineDash([]);
                    p.line(cx, interfaceY, refX, refY);
                    p.fill(COLORS.positive); p.noStroke();
                    p.textSize(10); p.textAlign(p.CENTER);
                    p.text('Total Internal Reflection', W / 2, 30);
                }

                // ── Angle arcs ──
                p.noFill();
                p.strokeWeight(1.5);
                var arcR = 40;
                // Incident angle arc
                p.stroke('#f59e0b');
                p.arc(cx, interfaceY, arcR * 2, arcR * 2, -p.HALF_PI - angleI, -p.HALF_PI);
                // Refracted angle arc
                if (!isTIR) {
                    p.stroke('#3b82f6');
                    p.arc(cx, interfaceY, arcR * 2, arcR * 2, p.HALF_PI - angleR, p.HALF_PI);
                }

                // ── Angle labels ──
                p.noStroke(); p.textSize(11);
                p.fill('#f59e0b'); p.textAlign(p.RIGHT);
                p.text('\u03b8\u1d62=' + angleIDeg + '\u00b0', cx - 8, interfaceY - arcR * 0.5 - 4);
                if (!isTIR) {
                    var angleRDeg = Math.round(angleR * 180 / Math.PI * 10) / 10;
                    p.fill('#3b82f6'); p.textAlign(p.LEFT);
                    p.text('\u03b8\u1d63=' + angleRDeg + '\u00b0', cx + 8, interfaceY + arcR * 0.5 + 12);
                }

                // ── Medium labels ──
                p.noStroke(); p.textSize(11); p.textAlign(p.LEFT);
                p.fill(dk ? '#93c5fd' : '#2563eb');
                p.text(med1 + ' (n\u2081=' + n1 + ')', 10, 25);
                p.fill(dk ? '#86efac' : '#16a34a');
                p.text(med2 + ' (n\u2082=' + n2 + ')', 10, H - 10);

                // ── Animated photon dot ──
                p.noStroke();
                var ph = (t * 0.5) % 2;
                var px, py;
                if (ph < 1) {
                    px = incX + (cx - incX) * ph;
                    py = incY + (interfaceY - incY) * ph;
                    photonDot(p, px, py, '#f59e0b');
                } else if (!isTIR) {
                    var rr = ph - 1;
                    var rfrX2 = cx + rayLen * Math.sin(angleR);
                    var rfrY2 = interfaceY + rayLen * Math.cos(angleR);
                    px = cx + (rfrX2 - cx) * rr;
                    py = interfaceY + (rfrY2 - interfaceY) * rr;
                    photonDot(p, px, py, '#3b82f6');
                } else {
                    var rr2 = ph - 1;
                    px = cx + (refX - cx) * rr2;
                    py = interfaceY + (refY - interfaceY) * rr2;
                    photonDot(p, px, py, COLORS.positive);
                }

                // ── Normal label ──
                p.fill(COLORS.neutral); p.textSize(8); p.textAlign(p.LEFT);
                p.text('Normal', cx + 4, 30);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Refraction \u2014 Snell\'s Law', W / 2, H - 30);
                p.textStyle(p.NORMAL);

                // ── Snell's law formula ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('n\u2081 sin\u03b8\u1d62 = n\u2082 sin\u03b8\u1d63', W - 10, H - 8);
            };

            function photonDot(p, px, py, col) {
                var c = p.color(col);
                p.fill(p.red(c), p.green(c), p.blue(c), 40);
                p.ellipse(px, py, 14, 14);
                p.fill(col);
                p.ellipse(px, py, 5, 5);
            }
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: total-internal-reflection
    //  Light at/beyond critical angle (Ch9)
    //  Params: n1 (denser), n2 (rarer), title, height
    // =====================================================
    function totalInternalReflection(containerEl, params) {
        var n1 = params.n1 || 1.5;
        var n2 = params.n2 || 1.0;
        var med1 = params.medium1 || 'Glass';
        var med2 = params.medium2 || 'Air';

        return new p5(function(p) {
            var W, H, t = 0;
            var interfaceY, critAngle;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 340;
                p.createCanvas(W, H);
                interfaceY = H * 0.45;
                critAngle = Math.asin(n2 / n1);
            };

            p.draw = function() {
                p.background(getBg());
                t += 0.012;
                var tc = getTextColor();
                var dk = isDark();

                // ── Media backgrounds ──
                p.noStroke();
                p.fill(dk ? 'rgba(34,197,94,0.08)' : 'rgba(34,197,94,0.10)');
                p.rect(0, 0, W, interfaceY);
                p.fill(dk ? 'rgba(59,130,246,0.06)' : 'rgba(59,130,246,0.08)');
                p.rect(0, interfaceY, W, H - interfaceY);

                // Interface
                p.stroke(dk ? '#64748b' : '#94a3b8');
                p.strokeWeight(2);
                p.line(0, interfaceY, W, interfaceY);

                var cx = W * 0.5;
                var rayLen = H * 0.32;

                // Normal (dashed)
                p.stroke(dk ? 'rgba(255,255,255,0.15)' : 'rgba(0,0,0,0.15)');
                p.strokeWeight(1);
                p.drawingContext.setLineDash([4, 4]);
                p.line(cx, interfaceY - rayLen * 1.1, cx, interfaceY + rayLen * 1.1);
                p.drawingContext.setLineDash([]);

                // Show 3 rays at different angles: sub-critical, critical, super-critical
                var angles = [critAngle * 0.5, critAngle, critAngle * 1.2];
                var colors = ['#3b82f6', '#f59e0b', '#ef4444'];
                var labels = ['Below \u03b8c', 'At \u03b8c', 'Above \u03b8c (TIR)'];

                for (var ri = 0; ri < 3; ri++) {
                    var ang = angles[ri];
                    var col = colors[ri];
                    var offX = (ri - 1) * W * 0.18;

                    // Incident ray (from below, in denser medium)
                    var startX = cx + offX - rayLen * Math.sin(ang);
                    var startY = interfaceY + rayLen * Math.cos(ang);
                    var hitX = cx + offX;

                    p.stroke(col);
                    p.strokeWeight(1.8);
                    p.drawingContext.setLineDash([]);
                    p.line(startX, startY, hitX, interfaceY);

                    var sinR = (n1 / n2) * Math.sin(ang);

                    if (sinR < 1) {
                        // Refracted ray above interface
                        var rAngle = Math.asin(sinR);
                        var rfrX = hitX + rayLen * 0.7 * Math.sin(rAngle);
                        var rfrY = interfaceY - rayLen * 0.7 * Math.cos(rAngle);
                        p.stroke(col);
                        p.strokeWeight(1.2);
                        p.line(hitX, interfaceY, rfrX, rfrY);
                    }

                    if (sinR >= 1 || ri === 1) {
                        // Reflected ray (total or partial at critical angle)
                        var reflX = hitX + rayLen * 0.7 * Math.sin(ang);
                        var reflY = interfaceY + rayLen * 0.7 * Math.cos(ang);
                        p.stroke(col);
                        p.strokeWeight(sinR >= 1 ? 2 : 1.2);
                        p.line(hitX, interfaceY, reflX, reflY);
                    }

                    // Animated dot
                    p.noStroke();
                    var ph = (t * 0.5 + ri * 0.4) % 2;
                    var dpx, dpy;
                    if (ph < 1) {
                        dpx = startX + (hitX - startX) * ph;
                        dpy = startY + (interfaceY - startY) * ph;
                    } else {
                        var rp = ph - 1;
                        if (sinR >= 1) {
                            var reflX2 = hitX + rayLen * 0.7 * Math.sin(ang);
                            var reflY2 = interfaceY + rayLen * 0.7 * Math.cos(ang);
                            dpx = hitX + (reflX2 - hitX) * rp;
                            dpy = interfaceY + (reflY2 - interfaceY) * rp;
                        } else {
                            var rAngle2 = Math.asin(sinR);
                            var rfrX2 = hitX + rayLen * 0.7 * Math.sin(rAngle2);
                            var rfrY2 = interfaceY - rayLen * 0.7 * Math.cos(rAngle2);
                            dpx = hitX + (rfrX2 - hitX) * rp;
                            dpy = interfaceY + (rfrY2 - interfaceY) * rp;
                        }
                    }
                    var cc = p.color(col);
                    p.fill(p.red(cc), p.green(cc), p.blue(cc), 40);
                    p.ellipse(dpx, dpy, 12, 12);
                    p.fill(col);
                    p.ellipse(dpx, dpy, 5, 5);
                }

                // ── Medium labels ──
                p.noStroke(); p.textSize(11); p.textAlign(p.LEFT);
                p.fill(dk ? '#86efac' : '#16a34a');
                p.text(med2 + ' (n\u2082=' + n2 + ') — Rarer', 10, 20);
                p.fill(dk ? '#93c5fd' : '#2563eb');
                p.text(med1 + ' (n\u2081=' + n1 + ') — Denser', 10, H - 8);

                // ── Legend ──
                p.textSize(9); p.textAlign(p.LEFT);
                var ly = interfaceY + 10;
                for (var li = 0; li < 3; li++) {
                    p.fill(colors[li]);
                    p.text('\u2500 ' + labels[li], W - 160, ly + li * 12);
                }

                // ── Critical angle label ──
                var critDeg = Math.round(critAngle * 180 / Math.PI * 10) / 10;
                p.fill(COLORS.force); p.textSize(10); p.textAlign(p.CENTER);
                p.text('\u03b8c = ' + critDeg + '\u00b0', W / 2, interfaceY - 8);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Total Internal Reflection', W / 2, H - 25);
                p.textStyle(p.NORMAL);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: prism-refraction
    //  Light through a triangular prism (Ch9)
    //  Params: prism_angle (deg), n, angle_i (deg), title
    // =====================================================
    function prismRefraction(containerEl, params) {
        var A = (params.prism_angle || 60) * Math.PI / 180;
        var n = params.n || 1.5;
        var angleIDeg = params.angle_i || 45;

        return new p5(function(p) {
            var W, H, t = 0;
            var cx, cy, prismSize;
            var vertices = [];
            var angleI, angleR1, angleI2, angleR2, deviation;

            p.setup = function() {
                W = containerEl.offsetWidth || 500;
                H = params.height || 340;
                p.createCanvas(W, H);
                cx = W * 0.5;
                cy = H * 0.55;
                prismSize = Math.min(W, H) * 0.32;

                // Equilateral-ish prism vertices
                var halfBase = prismSize * Math.sin(A / 2);
                var height = prismSize * Math.cos(A / 2);
                vertices = [
                    { x: cx, y: cy - height * 0.6 },
                    { x: cx - halfBase, y: cy + height * 0.4 },
                    { x: cx + halfBase, y: cy + height * 0.4 }
                ];

                angleI = angleIDeg * Math.PI / 180;
                angleR1 = Math.asin(Math.sin(angleI) / n);
                angleI2 = A - angleR1;
                var sinR2 = n * Math.sin(angleI2);
                angleR2 = sinR2 <= 1 ? Math.asin(sinR2) : Math.PI / 2;
                deviation = (angleI + angleR2) - A;
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.015;
                var tc = getTextColor();
                var dk = isDark();

                // ── Prism ──
                p.fill(dk ? 'rgba(59,130,246,0.1)' : 'rgba(59,130,246,0.12)');
                p.stroke(dk ? '#93c5fd' : '#3b82f6');
                p.strokeWeight(2.5);
                p.triangle(vertices[0].x, vertices[0].y, vertices[1].x, vertices[1].y, vertices[2].x, vertices[2].y);

                // ── Compute ray path through prism ──
                // Entry on left face
                var leftMidX = (vertices[0].x + vertices[1].x) / 2;
                var leftMidY = (vertices[0].y + vertices[1].y) / 2;
                // Left face normal (pointing outward/left)
                var leftDx = vertices[1].x - vertices[0].x;
                var leftDy = vertices[1].y - vertices[0].y;
                var leftNormAngle = Math.atan2(leftDx, -leftDy); // outward normal

                // Entry point on left face
                var entryX = leftMidX;
                var entryY = leftMidY;

                // Incident ray direction
                var incAngle = leftNormAngle + Math.PI + angleI;
                var incLen = W * 0.3;
                var incStartX = entryX - incLen * Math.cos(incAngle);
                var incStartY = entryY - incLen * Math.sin(incAngle);

                // Refracted ray inside prism
                var refr1Angle = leftNormAngle + Math.PI - angleR1;
                // Right face
                var rightMidX = (vertices[0].x + vertices[2].x) / 2;
                var rightMidY = (vertices[0].y + vertices[2].y) / 2;
                var rightDx = vertices[2].x - vertices[0].x;
                var rightDy = vertices[2].y - vertices[0].y;
                var rightNormAngle = Math.atan2(rightDx, -rightDy);

                // Exit point on right face
                var exitX = rightMidX;
                var exitY = rightMidY;

                // Emergent ray
                var emAngle = rightNormAngle + angleR2;
                var emLen = W * 0.3;
                var emEndX = exitX + emLen * Math.cos(emAngle);
                var emEndY = exitY + emLen * Math.sin(emAngle);

                // ── Draw rays ──
                // Incident
                p.stroke('#f59e0b');
                p.strokeWeight(2);
                p.line(incStartX, incStartY, entryX, entryY);
                // Inside prism
                p.stroke('#22c55e');
                p.strokeWeight(2);
                p.line(entryX, entryY, exitX, exitY);
                // Emergent
                p.stroke('#ef4444');
                p.strokeWeight(2);
                p.line(exitX, exitY, emEndX, emEndY);

                // ── Animated photon ──
                p.noStroke();
                var totalPhase = (t * 0.4) % 3;
                var dpx, dpy;
                var dotCol;
                if (totalPhase < 1) {
                    dpx = incStartX + (entryX - incStartX) * totalPhase;
                    dpy = incStartY + (entryY - incStartY) * totalPhase;
                    dotCol = '#f59e0b';
                } else if (totalPhase < 2) {
                    var rp = totalPhase - 1;
                    dpx = entryX + (exitX - entryX) * rp;
                    dpy = entryY + (exitY - entryY) * rp;
                    dotCol = '#22c55e';
                } else {
                    var rp2 = totalPhase - 2;
                    dpx = exitX + (emEndX - exitX) * rp2;
                    dpy = exitY + (emEndY - exitY) * rp2;
                    dotCol = '#ef4444';
                }
                var cc = p.color(dotCol);
                p.fill(p.red(cc), p.green(cc), p.blue(cc), 40);
                p.ellipse(dpx, dpy, 14, 14);
                p.fill(dotCol);
                p.ellipse(dpx, dpy, 6, 6);

                // ── Labels ──
                p.fill(COLORS.force); p.noStroke(); p.textSize(10); p.textAlign(p.CENTER);
                p.text('A=' + Math.round(A * 180 / Math.PI) + '\u00b0', vertices[0].x, vertices[0].y - 10);

                p.fill('#f59e0b'); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('i=' + angleIDeg + '\u00b0', entryX - 8, entryY - 8);

                var devDeg = Math.round(deviation * 180 / Math.PI * 10) / 10;
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.LEFT);
                p.text('n=' + n, vertices[2].x + 8, vertices[2].y);

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Refraction Through a Prism', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Deviation info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('Deviation \u03b4 \u2248 ' + devDeg + '\u00b0', W - 10, H - 8);

                // ── Legend ──
                p.textSize(9); p.textAlign(p.LEFT);
                var ly = H - 36;
                p.fill('#f59e0b'); p.text('\u2500 Incident ray', 10, ly);
                p.fill('#22c55e'); p.text('\u2500 Inside prism', 10, ly + 12);
                p.fill('#ef4444'); p.text('\u2500 Emergent ray', 10, ly + 24);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: lens-ray-diagram
    //  Converging or diverging lens ray diagram (Ch9)
    //  Params: u, f, h_obj, lens_type ('convex'|'concave'), title
    // =====================================================
    function lensRayDiagram(containerEl, params) {
        var uVal = params.u || 30;
        var fVal = params.f || 20;
        var hObjCm = params.h_obj || 3;
        var lensType = params.lens_type || 'convex';

        return new p5(function(p) {
            var W, H, t = 0;
            var lensX, axisY, sc;
            var objX, imgX, f1X, f2X;
            var objH, imgH, vVal, mag;
            var isVirtual;

            p.setup = function() {
                W = containerEl.offsetWidth || 550;
                H = params.height || 340;
                p.createCanvas(W, H);
                lensX = W * 0.45;
                axisY = Math.round(H * 0.52);

                if (lensType === 'convex') {
                    vVal = (uVal * fVal) / (uVal - fVal);
                    isVirtual = vVal < 0;
                } else {
                    vVal = -(uVal * fVal) / (uVal + fVal);
                    isVirtual = true;
                }
                mag = Math.abs(vVal) / uVal;

                var maxDist = Math.max(uVal, Math.abs(vVal), fVal) + 8;
                sc = (Math.min(lensX, W - lensX) - 30) / maxDist;

                objX = lensX - uVal * sc;
                f1X = lensX - fVal * sc;
                f2X = lensX + fVal * sc;

                if (isVirtual) {
                    imgX = lensX - Math.abs(vVal) * sc;
                } else {
                    imgX = lensX + vVal * sc;
                }

                objH = Math.min(hObjCm * sc * 1.2, H * 0.17);
                objH = Math.max(objH, 20);
                imgH = Math.min(objH * mag, H * 0.32);
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.012;
                var tc = getTextColor();
                var dk = isDark();
                var lensH = H * 0.6;

                // ── Principal axis ──
                p.stroke(getAxisColor());
                p.strokeWeight(1);
                p.line(15, axisY, W - 15, axisY);

                // ── Lens ──
                p.stroke(dk ? '#93c5fd' : '#3b82f6');
                p.strokeWeight(2.5);
                if (lensType === 'convex') {
                    p.noFill();
                    p.arc(lensX - 6, axisY, 12, lensH, -p.HALF_PI, p.HALF_PI);
                    p.arc(lensX + 6, axisY, 12, lensH, p.HALF_PI, p.HALF_PI + Math.PI);
                } else {
                    p.line(lensX, axisY - lensH / 2, lensX, axisY + lensH / 2);
                    p.noFill();
                    p.arc(lensX - 8, axisY, 16, lensH * 0.8, -p.HALF_PI, p.HALF_PI);
                    p.arc(lensX + 8, axisY, 16, lensH * 0.8, p.HALF_PI, p.HALF_PI + Math.PI);
                }
                // Arrow tips on lens
                p.strokeWeight(2);
                if (lensType === 'convex') {
                    p.line(lensX - 6, axisY - lensH / 2, lensX, axisY - lensH / 2 + 8);
                    p.line(lensX + 6, axisY - lensH / 2, lensX, axisY - lensH / 2 + 8);
                    p.line(lensX - 6, axisY + lensH / 2, lensX, axisY + lensH / 2 - 8);
                    p.line(lensX + 6, axisY + lensH / 2, lensX, axisY + lensH / 2 - 8);
                }

                // ── F markers ──
                p.stroke(COLORS.force); p.strokeWeight(2);
                p.line(f1X, axisY - 5, f1X, axisY + 5);
                p.line(f2X, axisY - 5, f2X, axisY + 5);
                p.noStroke(); p.fill(COLORS.force); p.textSize(10); p.textAlign(p.CENTER);
                p.text('F', f1X, axisY + 17);
                p.text('F\'', f2X, axisY + 17);

                // 2F markers
                var f1X2 = lensX - 2 * fVal * sc;
                var f2X2 = lensX + 2 * fVal * sc;
                p.stroke(COLORS.field); p.strokeWeight(1.5);
                p.line(f1X2, axisY - 4, f1X2, axisY + 4);
                p.line(f2X2, axisY - 4, f2X2, axisY + 4);
                p.noStroke(); p.fill(COLORS.field); p.textSize(9);
                p.text('2F', f1X2, axisY + 16);
                p.text('2F\'', f2X2, axisY + 16);

                // ── Object ──
                drawArrow(p, objX, axisY, objX, axisY - objH, COLORS.surfaceStroke, 3);
                p.fill(COLORS.surfaceStroke); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Object', objX, axisY - objH - 8);

                // ── Rays ──
                var a1 = dk ? 0.7 : 0.8;
                var imgTipY = isVirtual ? axisY - imgH : axisY + imgH;

                // Ray 1: Parallel → through F' (convex) or diverge from F (concave)
                p.stroke('rgba(245,158,11,' + a1 + ')');
                p.strokeWeight(1.5);
                p.line(objX, axisY - objH, lensX, axisY - objH);
                if (!isVirtual) {
                    p.line(lensX, axisY - objH, imgX, imgTipY);
                } else {
                    // Diverging ray with virtual extension
                    var ext = lensType === 'convex' ? imgX : imgX;
                    var extSlope = ((axisY - objH) - axisY) / (lensX - f2X);
                    var extEndX = W - 10;
                    var extEndY = (axisY - objH) + extSlope * (extEndX - lensX);
                    p.line(lensX, axisY - objH, extEndX, extEndY);
                    p.drawingContext.setLineDash([4, 4]);
                    p.stroke('rgba(245,158,11,0.35)');
                    p.line(lensX, axisY - objH, imgX, imgTipY);
                    p.drawingContext.setLineDash([]);
                }

                // Ray 2: Through optical center (straight line)
                p.stroke('rgba(34,197,94,' + a1 + ')');
                p.strokeWeight(1.5);
                p.drawingContext.setLineDash([]);
                var slope2 = ((axisY - objH) - axisY) / (objX - lensX);
                var r2endX = isVirtual ? imgX : imgX;
                p.line(objX, axisY - objH, r2endX, imgTipY);

                // Ray 3: Through F → parallel (convex)
                if (lensType === 'convex') {
                    p.stroke('rgba(59,130,246,' + a1 + ')');
                    p.strokeWeight(1.5);
                    var r3slope = ((axisY - objH) - axisY) / (objX - f1X);
                    var r3lensY = (axisY - objH) + r3slope * (lensX - objX);
                    p.line(objX, axisY - objH, lensX, r3lensY);
                    if (!isVirtual) {
                        p.line(lensX, r3lensY, imgX, r3lensY);
                    } else {
                        p.line(lensX, r3lensY, 15, r3lensY);
                        p.drawingContext.setLineDash([4, 4]);
                        p.stroke('rgba(59,130,246,0.35)');
                        p.line(lensX, r3lensY, imgX, imgTipY);
                        p.drawingContext.setLineDash([]);
                    }
                }

                // ── Image ──
                p.push();
                p.drawingContext.globalAlpha = 0.6 + 0.3 * Math.sin(t * 3);
                if (isVirtual) {
                    p.drawingContext.setLineDash([5, 4]);
                }
                drawArrow(p, imgX, axisY, imgX, imgTipY, COLORS.positive, 2.5);
                p.drawingContext.setLineDash([]);
                p.fill(COLORS.positive); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text(isVirtual ? 'Virtual Image' : 'Image', imgX, imgTipY + (isVirtual ? -8 : 14));
                p.drawingContext.globalAlpha = 1;
                p.pop();

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                var defTitle = (lensType === 'convex' ? 'Convex' : 'Concave') + ' Lens \u2014 Ray Diagram';
                p.text(params.title || defTitle, W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                var vStr = (isVirtual ? '-' : '') + Math.abs(vVal).toFixed(1);
                p.text('u=' + uVal + 'cm  f=' + fVal + 'cm  v=' + vStr + 'cm  m=' + mag.toFixed(2),
                    W - 10, H - 5);
            };
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: convex-mirror
    //  Ray diagram for convex mirror (Ch9 Ray Optics)
    //  Virtual image always between P and F, erect, diminished
    //  Params: u, f, h_obj, title, height
    // =====================================================
    function convexMirror(containerEl, params) {
        var uVal = params.u || 12;
        var fVal = params.f || 15;
        var hObjCm = params.h_obj || 4.5;

        return new p5(function(p) {
            var W, H, t = 0;
            var mirrorX, axisY, sc;
            var fX, cX, objX, imgX;
            var objH, imgH, vVal, mag;
            var aperture, curveD;

            p.setup = function() {
                W = containerEl.offsetWidth || 550;
                H = params.height || 340;
                p.createCanvas(W, H);

                mirrorX = W * 0.55;
                axisY = Math.round(H * 0.52);

                // Convex mirror: f positive, v positive (virtual image behind mirror)
                vVal = (uVal * fVal) / (uVal + fVal);
                mag = vVal / uVal;

                var maxDist = Math.max(uVal, fVal) + 8;
                sc = (mirrorX - 50) / maxDist;

                // F and C are BEHIND the mirror (to the right)
                fX = mirrorX + fVal * sc;
                cX = mirrorX + 2 * fVal * sc;
                objX = mirrorX - uVal * sc;
                imgX = mirrorX + vVal * sc;

                objH = Math.min(hObjCm * sc * 1.4, H * 0.18);
                objH = Math.max(objH, 22);
                imgH = objH * mag;

                aperture = H * 0.58;
                curveD = Math.min(aperture * 0.07, 14);
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.012;
                var tc = getTextColor();
                var dk = isDark();
                var halfA = aperture / 2;

                // ── Principal axis ──
                p.stroke(getAxisColor());
                p.strokeWeight(1);
                p.line(15, axisY, W - 10, axisY);

                // ── Convex mirror arc (curves away from object) ──
                p.noFill();
                p.stroke(dk ? '#94a3b8' : '#475569');
                p.strokeWeight(3);
                var mTop = axisY - halfA;
                var mBot = axisY + halfA;
                p.beginShape();
                for (var i = 0; i <= 24; i++) {
                    var yy = mTop + (i / 24) * aperture;
                    var dy = yy - axisY;
                    p.vertex(mirrorX - curveD * (dy * dy) / (halfA * halfA), yy);
                }
                p.endShape();

                // Hatching on back (right side for convex)
                p.strokeWeight(1);
                p.stroke(dk ? 'rgba(148,163,184,0.25)' : 'rgba(71,85,105,0.25)');
                for (var hy = mTop + 5; hy <= mBot; hy += 7) {
                    var hdy = hy - axisY;
                    var hx = mirrorX - curveD * (hdy * hdy) / (halfA * halfA);
                    p.line(hx, hy, hx - 7, hy - 5);
                }

                // ── Markers ──
                p.noStroke(); p.fill(tc); p.textSize(10); p.textAlign(p.CENTER);
                p.text('P', mirrorX, axisY + 18);

                // F behind mirror (dashed tick)
                p.stroke(COLORS.force); p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(fX, axisY - 6, fX, axisY + 6);
                p.drawingContext.setLineDash([]);
                p.noStroke(); p.fill(COLORS.force); p.text('F', fX, axisY + 18);

                // C behind mirror
                if (cX < W - 15) {
                    p.stroke(COLORS.field); p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(cX, axisY - 6, cX, axisY + 6);
                    p.drawingContext.setLineDash([]);
                    p.noStroke(); p.fill(COLORS.field); p.text('C', cX, axisY + 18);
                }

                // ── Object arrow ──
                drawArrow(p, objX, axisY, objX, axisY - objH, COLORS.surfaceStroke, 3);
                p.fill(COLORS.surfaceStroke); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Object', objX, axisY - objH - 8);

                // ── Three principal rays ──
                var a1 = dk ? 0.7 : 0.8;

                // Ray 1: Parallel to axis → diverges, extension passes through F
                p.stroke('rgba(245,158,11,' + a1 + ')');
                p.strokeWeight(1.5);
                p.line(objX, axisY - objH, mirrorX, axisY - objH);
                // Reflected ray diverges — goes up-left from mirror
                // Virtual extension (dashed) goes to F behind mirror
                var r1slope = (axisY - (axisY - objH)) / (fX - mirrorX);
                var r1endX = objX - 20;
                var r1endY = (axisY - objH) - r1slope * (mirrorX - r1endX);
                p.line(mirrorX, axisY - objH, r1endX, r1endY);
                // Dashed virtual extension toward F
                p.drawingContext.setLineDash([4, 4]);
                p.stroke('rgba(245,158,11,0.35)');
                p.line(mirrorX, axisY - objH, imgX, axisY - imgH);
                p.drawingContext.setLineDash([]);

                // Ray 2: Aimed at F behind mirror → reflects parallel
                p.stroke('rgba(59,130,246,' + a1 + ')');
                p.strokeWeight(1.5);
                var r2slope = ((axisY - objH) - axisY) / (objX - fX);
                var r2mirrorY = (axisY - objH) + r2slope * (mirrorX - objX);
                p.line(objX, axisY - objH, mirrorX, r2mirrorY);
                // Reflects parallel to axis (going left)
                p.line(mirrorX, r2mirrorY, objX - 20, r2mirrorY);
                // Dashed virtual extension
                p.drawingContext.setLineDash([4, 4]);
                p.stroke('rgba(59,130,246,0.35)');
                p.line(mirrorX, r2mirrorY, imgX, axisY - imgH);
                p.drawingContext.setLineDash([]);

                // Ray 3: Aimed at C behind mirror → reflects back on itself
                p.stroke('rgba(34,197,94,' + a1 + ')');
                p.strokeWeight(1.5);
                var r3slope = ((axisY - objH) - axisY) / (objX - cX);
                var r3mirrorY = (axisY - objH) + r3slope * (mirrorX - objX);
                if (r3mirrorY > axisY - halfA && r3mirrorY < axisY + halfA) {
                    p.line(objX, axisY - objH, mirrorX, r3mirrorY);
                    // Reflects back along same line (going left)
                    var r3backX = objX - 20;
                    var r3backY = r3mirrorY + (r3mirrorY - (axisY - objH)) / (mirrorX - objX) * (r3backX - mirrorX);
                    p.line(mirrorX, r3mirrorY, r3backX, r3backY);
                    // Dashed extension behind mirror to image
                    p.drawingContext.setLineDash([4, 4]);
                    p.stroke('rgba(34,197,94,0.35)');
                    p.line(mirrorX, r3mirrorY, imgX, axisY - imgH);
                    p.drawingContext.setLineDash([]);
                }

                // ── Virtual image (behind mirror, erect) ──
                p.push();
                p.drawingContext.globalAlpha = 0.55 + 0.25 * Math.sin(t * 3);
                p.drawingContext.setLineDash([5, 4]);
                drawArrow(p, imgX, axisY, imgX, axisY - imgH, COLORS.positive, 2.5);
                p.drawingContext.setLineDash([]);
                p.fill(COLORS.positive); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Virtual Image', imgX, axisY - imgH - 8);
                p.drawingContext.globalAlpha = 1;
                p.pop();

                // ── Photon dots on reflected rays ──
                p.noStroke();
                var sp = 0.55;
                cmPhotonCV(p, (t * sp) % 2, objX, axisY - objH, mirrorX, axisY - objH, mirrorX, axisY - objH, r1endX, r1endY, '#f59e0b');
                cmPhotonCV(p, (t * sp + 0.3) % 2, objX, axisY - objH, mirrorX, r2mirrorY, mirrorX, r2mirrorY, objX - 20, r2mirrorY, '#3b82f6');

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Convex Mirror \u2014 Ray Diagram', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Legend ──
                p.textSize(9); p.textAlign(p.LEFT);
                var ly = H - 36;
                p.fill('#f59e0b'); p.text('\u2500 Parallel \u2192 diverges (ext. through F)', 10, ly);
                p.fill('#3b82f6'); p.text('\u2500 Toward F \u2192 parallel', 10, ly + 12);
                p.fill('#22c55e'); p.text('\u2500 Toward C \u2192 back on itself', 10, ly + 24);

                // ── Info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('u=' + uVal + 'cm  f=' + fVal + 'cm  v=' + vVal.toFixed(1) + 'cm  m=' + mag.toFixed(2),
                    W - 10, H - 5);
            };

            function cmPhotonCV(p, ph, x1, y1, x2, y2, x3, y3, x4, y4, col) {
                var px, py;
                if (ph < 1) { px = x1 + (x2 - x1) * ph; py = y1 + (y2 - y1) * ph; }
                else { var r = ph - 1; px = x3 + (x4 - x3) * r; py = y3 + (y4 - y3) * r; }
                var c = p.color(col);
                p.fill(p.red(c), p.green(c), p.blue(c), 40);
                p.ellipse(px, py, 14, 14);
                p.fill(col);
                p.ellipse(px, py, 5, 5);
            }
        }, containerEl);
    }

    // =====================================================
    //  SKETCH TYPE: concave-mirror
    //  Ray diagram for concave mirror (Ch9 Ray Optics)
    //  Params: u (object dist cm), f (focal length cm),
    //          h_obj (object height cm), title, height
    // =====================================================
    function concaveMirror(containerEl, params) {
        var uVal = params.u || 27;
        var fVal = params.f || 18;
        var hObjCm = params.h_obj || 2.5;

        return new p5(function(p) {
            var W, H, t = 0;
            var mirrorX, axisY, sc;
            var fX, cX, objX, imgX;
            var objH, imgH, vVal, mag;
            var y2m, y3m;
            var aperture, curveD;

            p.setup = function() {
                W = containerEl.offsetWidth || 550;
                H = params.height || 340;
                p.createCanvas(W, H);

                mirrorX = W * 0.74;
                axisY = Math.round(H * 0.52);

                // Image distance from mirror formula
                vVal = (uVal * fVal) / (uVal - fVal);
                mag = vVal / uVal;

                // Scale: fit the farthest point with padding
                var maxDist = Math.max(uVal, vVal, 2 * fVal) + 6;
                sc = (mirrorX - 45) / maxDist;

                fX = mirrorX - fVal * sc;
                cX = mirrorX - 2 * fVal * sc;
                objX = mirrorX - uVal * sc;
                imgX = mirrorX - vVal * sc;

                // Object / image heights (exaggerated for clarity, capped)
                objH = Math.min(hObjCm * sc * 1.4, H * 0.18);
                objH = Math.max(objH, 22);
                imgH = Math.min(objH * mag, H * 0.34);

                // Ray-mirror intersection y-coords (paraxial approximation)
                // Ray 2 (through F → parallel): hits mirror below axis
                y2m = axisY + objH * fVal / (uVal - fVal);
                // Ray 3 (through C → back on itself): hits mirror above axis
                y3m = axisY - objH * 2 * fVal / (2 * fVal - uVal);

                aperture = H * 0.58;
                curveD = Math.min(aperture * 0.07, 14);
            };

            p.draw = function() {
                p.background(getBg());
                drawGrid(p, 30);
                t += 0.012;
                var tc = getTextColor();
                var dk = isDark();
                var halfA = aperture / 2;

                // ── Principal axis ──
                p.stroke(getAxisColor());
                p.strokeWeight(1);
                p.line(15, axisY, W - 10, axisY);

                // ── Concave mirror (parabolic arc + hatching) ──
                p.noFill();
                p.stroke(dk ? '#94a3b8' : '#475569');
                p.strokeWeight(3);
                var mTop = axisY - halfA;
                var mBot = axisY + halfA;
                p.beginShape();
                for (var i = 0; i <= 24; i++) {
                    var yy = mTop + (i / 24) * aperture;
                    var dy = yy - axisY;
                    p.vertex(mirrorX + curveD * (dy * dy) / (halfA * halfA), yy);
                }
                p.endShape();

                // Hatching behind mirror surface
                p.strokeWeight(1);
                p.stroke(dk ? 'rgba(148,163,184,0.25)' : 'rgba(71,85,105,0.25)');
                for (var hy = mTop + 5; hy <= mBot; hy += 7) {
                    var hdy = hy - axisY;
                    var hx = mirrorX + curveD * (hdy * hdy) / (halfA * halfA);
                    p.line(hx, hy, hx + 7, hy - 5);
                }

                // ── Markers: P, F, C ──
                p.noStroke(); p.fill(tc); p.textSize(10); p.textAlign(p.CENTER);
                p.text('P', mirrorX, axisY + 18);

                p.stroke(COLORS.force); p.strokeWeight(2);
                p.line(fX, axisY - 6, fX, axisY + 6);
                p.noStroke(); p.fill(COLORS.force); p.text('F', fX, axisY + 18);

                p.stroke(COLORS.field); p.strokeWeight(2);
                p.line(cX, axisY - 6, cX, axisY + 6);
                p.noStroke(); p.fill(COLORS.field); p.text('C', cX, axisY + 18);

                // ── Object arrow ──
                drawArrow(p, objX, axisY, objX, axisY - objH, COLORS.surfaceStroke, 3);
                p.fill(COLORS.surfaceStroke); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Object', objX, axisY - objH - 8);

                // ── Three principal rays ──
                var a1 = dk ? 0.7 : 0.8;

                // Ray 1: Parallel to axis → reflects through F (amber)
                p.stroke('rgba(245,158,11,' + a1 + ')');
                p.strokeWeight(1.5);
                p.line(objX, axisY - objH, mirrorX, axisY - objH);
                p.line(mirrorX, axisY - objH, imgX, axisY + imgH);

                // Ray 2: Through F → reflects parallel (blue)
                p.stroke('rgba(59,130,246,' + a1 + ')');
                p.strokeWeight(1.5);
                p.line(objX, axisY - objH, mirrorX, y2m);
                p.line(mirrorX, y2m, imgX, y2m);

                // Ray 3: Through C → reflects back on itself (green)
                var r3ok = y3m > 5 && y3m < H - 5;
                if (r3ok) {
                    p.stroke('rgba(34,197,94,' + a1 + ')');
                    p.strokeWeight(1.5);
                    p.line(objX, axisY - objH, mirrorX, y3m);
                    p.line(mirrorX, y3m, imgX, axisY + imgH);
                }

                // ── Animated photon dots ──
                p.noStroke();
                var sp = 0.55;
                cmPhoton(p, (t * sp) % 2, objX, axisY - objH, mirrorX, axisY - objH, imgX, axisY + imgH, '#f59e0b');
                cmPhoton(p, (t * sp + 0.7) % 2, objX, axisY - objH, mirrorX, axisY - objH, imgX, axisY + imgH, '#f59e0b');

                cmPhoton(p, (t * sp + 0.3) % 2, objX, axisY - objH, mirrorX, y2m, imgX, y2m, '#3b82f6');
                cmPhoton(p, (t * sp + 1.0) % 2, objX, axisY - objH, mirrorX, y2m, imgX, y2m, '#3b82f6');

                if (r3ok) {
                    cmPhoton(p, (t * sp + 0.5) % 2, objX, axisY - objH, mirrorX, y3m, imgX, axisY + imgH, '#22c55e');
                    cmPhoton(p, (t * sp + 1.2) % 2, objX, axisY - objH, mirrorX, y3m, imgX, axisY + imgH, '#22c55e');
                }

                // ── Image arrow (pulsing) ──
                p.push();
                p.drawingContext.globalAlpha = 0.65 + 0.35 * Math.sin(t * 3);
                drawArrow(p, imgX, axisY, imgX, axisY + imgH, COLORS.positive, 3);
                p.fill(COLORS.positive); p.noStroke(); p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Image', imgX, axisY + imgH + 14);
                p.drawingContext.globalAlpha = 1;
                p.pop();

                // ── Title ──
                p.fill(tc); p.noStroke(); p.textAlign(p.CENTER);
                p.textSize(13); p.textStyle(p.BOLD);
                p.text(params.title || 'Concave Mirror \u2014 Ray Diagram', W / 2, 18);
                p.textStyle(p.NORMAL);

                // ── Legend ──
                p.textSize(9); p.textAlign(p.LEFT);
                var ly = H - 36;
                p.fill('#f59e0b'); p.text('\u2500 Parallel \u2192 through F', 10, ly);
                p.fill('#3b82f6'); p.text('\u2500 Through F \u2192 parallel', 10, ly + 12);
                p.fill('#22c55e'); p.text('\u2500 Through C \u2192 back', 10, ly + 24);

                // ── Bottom info ──
                p.fill(COLORS.neutral); p.textSize(9); p.textAlign(p.RIGHT);
                p.text('u=' + uVal + 'cm  f=' + fVal + 'cm  v=' + vVal.toFixed(1) + 'cm  m=' + mag.toFixed(1) + '\u00d7',
                    W - 10, H - 5);
            };

            function cmPhoton(p, ph, x1, y1, x2, y2, x3, y3, col) {
                var px, py;
                if (ph < 1) { px = x1 + (x2 - x1) * ph; py = y1 + (y2 - y1) * ph; }
                else { var r = ph - 1; px = x2 + (x3 - x2) * r; py = y2 + (y3 - y2) * r; }
                var c = p.color(col);
                p.fill(p.red(c), p.green(c), p.blue(c), 40);
                p.ellipse(px, py, 14, 14);
                p.fill(col);
                p.ellipse(px, py, 5, 5);
            }
        }, containerEl);
    }

    //  PUBLIC API
    // =====================================================
    var sketchTypes = {
        'coulomb-force': coulombForce,
        'electric-field': electricFieldSketch,
        'charge-config': chargeConfig,
        'dipole': dipoleSketch,
        'flux-surface': fluxSurface,
        'parallel-plates': parallelPlates,
        'conducting-sphere': conductingSphere,
        'particle-tracks': particleTracks,
        'rubbing-charges': rubbingCharges,
        'simple-circuit': simpleCircuit,
        'drift-velocity': driftVelocity,
        'resistance-temperature': resistanceTemperature,
        'kirchhoff-network': kirchhoffNetwork,
        'charging-circuit': chargingCircuit,
        'magnetic-field-wire': magneticFieldWire,
        'solenoid-field': solenoidField,
        'circular-orbit': circularOrbit,
        'torque-coil': torqueCoil,
        'parallel-wires': parallelWires,
        'bar-magnet-torque': barMagnetTorque,
        'dipole-field': dipoleField,
        'flux-change-loop': fluxChangeLoop,
        'motional-emf': motionalEmf,
        'rotating-rod': rotatingRod,
        'inductance-coil': inductanceCoil,
        'ac-waveform': acWaveform,
        'lc-oscillation': lcOscillation,
        'lcr-resonance': lcrResonance,
        'displacement-current': displacementCurrent,
        'em-wave-propagation': emWavePropagation,
        'em-spectrum': emSpectrum,
        'wave-interference': waveInterference,
        'photoelectric-effect': photoelectricEffect,
        'bohr-model': bohrModel,
        'nuclear-binding-energy': nuclearBindingEnergy,
        'pn-junction': pnJunction,
        'refraction': refractionSketch,
        'total-internal-reflection': totalInternalReflection,
        'prism-refraction': prismRefraction,
        'lens-ray-diagram': lensRayDiagram,
        'convex-mirror': convexMirror,
        'concave-mirror': concaveMirror
    };

    return {
        render: function(containerEl, type, params) {
            var factory = sketchTypes[type];
            if (!factory) {
                console.warn('Unknown physics sketch type: ' + type);
                return null;
            }
            return factory(containerEl, params || {});
        },

        getTypes: function() {
            return Object.keys(sketchTypes);
        }
    };
})();
