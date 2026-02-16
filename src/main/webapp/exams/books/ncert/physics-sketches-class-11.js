/**
 * Physics Interactive Sketches — Class XI (NCERT Part 1)
 * p5.js instance-mode renderers for kinematics, vectors, forces, energy, and gravitation
 * 
 * Usage: PhysicsSketchesClass11.render(containerEl, type, params)
 * 
 * Chapters Covered:
 * - Chapter 2: Motion in a Straight Line
 * - Chapter 3: Motion in a Plane
 * - Chapter 4: Laws of Motion
 * - Chapter 5: Work, Energy and Power
 * - Chapter 6: Systems of Particles and Rotational Motion
 * - Chapter 7: Gravitation
 */
var PhysicsSketchesClass11 = (function () {
    'use strict';

    // --- Color palette (dark-mode aware) ---
    var COLORS = {
        primary: '#3b82f6',      // Blue
        secondary: '#8b5cf6',    // Purple
        accent: '#f59e0b',       // Amber
        success: '#22c55e',      // Green
        danger: '#ef4444',       // Red
        warning: '#f59e0b',      // Orange

        // Physics-specific
        velocity: '#3b82f6',     // Blue
        acceleration: '#ef4444', // Red
        force: '#f59e0b',        // Orange
        energy: '#8b5cf6',       // Purple
        path: '#22c55e',         // Green
        displacement: '#06b6d4', // Cyan

        // UI
        bg: '#1a1a2e',
        bgLight: '#f8fafc',
        text: '#e2e8f0',
        textLight: '#1e293b',
        grid: 'rgba(255,255,255,0.06)',
        gridLight: 'rgba(0,0,0,0.06)',
        axis: 'rgba(255,255,255,0.15)',
        axisLight: 'rgba(0,0,0,0.15)',
        label: '#94a3b8',
        white: '#ffffff'
    };

    // --- Theme detection ---
    function isDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark' ||
            window.matchMedia('(prefers-color-scheme: dark)').matches;
    }

    function getBg() { return isDark() ? COLORS.bg : COLORS.bgLight; }
    function getTextColor() { return isDark() ? COLORS.text : COLORS.textLight; }
    function getGridColor() { return isDark() ? COLORS.grid : COLORS.gridLight; }
    function getAxisColor() { return isDark() ? COLORS.axis : COLORS.axisLight; }

    // --- Utility functions ---
    function drawGrid(p, spacing) {
        p.stroke(getGridColor());
        p.strokeWeight(1);
        for (var x = 0; x < p.width; x += spacing) {
            p.line(x, 0, x, p.height);
        }
        for (var y = 0; y < p.height; y += spacing) {
            p.line(0, y, p.width, y);
        }
    }

    function drawAxes(p, originX, originY, xLabel, yLabel) {
        p.stroke(getAxisColor());
        p.strokeWeight(2);

        // X-axis
        p.line(20, originY, p.width - 20, originY);
        drawArrow(p, p.width - 30, originY, p.width - 20, originY, getAxisColor(), 2);

        // Y-axis
        p.line(originX, p.height - 20, originX, 20);
        drawArrow(p, originX, 30, originX, 20, getAxisColor(), 2);

        // Labels
        p.fill(getTextColor());
        p.noStroke();
        p.textAlign(p.RIGHT, p.TOP);
        p.textSize(12);
        if (xLabel) p.text(xLabel, p.width - 25, originY + 5);
        if (yLabel) p.text(yLabel, originX - 5, 25);
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

    function drawVector(p, x, y, vx, vy, color, label, scale) {
        scale = scale || 1;
        var endX = x + vx * scale;
        var endY = y + vy * scale;
        drawArrow(p, x, y, endX, endY, color, 3);

        if (label) {
            p.fill(color);
            p.noStroke();
            p.textAlign(p.CENTER);
            p.textSize(11);
            p.textStyle(p.BOLD);
            var labelX = (x + endX) / 2;
            var labelY = (y + endY) / 2 - 10;
            p.text(label, labelX, labelY);
            p.textStyle(p.NORMAL);
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

    // =====================================================
    //  CHAPTER 1: UNITS AND MEASUREMENT
    // =====================================================

    /**
     * Unit Conversion Visualizer
     * Supports length (cm↔m) and volume (cm³→m³) modes for Q1.1 alignment
     * Type: 'unit-conversion-visual'
     */
    function unitConversionVisual(containerEl, params) {
        var mode = params.mode || 'length';
        var fromUnit = params.fromUnit || 'cm';
        var toUnit = params.toUnit || 'm';
        var value = params.value || 1;

        return new p5(function (p) {
            var W, H;
            var animProgress = 0;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 300;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                animProgress += 0.01;
                if (animProgress > 1) animProgress = 0;

                p.background(getBg());
                drawGrid(p, 30);

                if (mode === 'volume') {
                    // Q1.1(a): Volume of cube of side 1 cm = ? m³
                    // 1 cm = 10⁻² m → (1 cm)³ = (10⁻² m)³ = 10⁻⁶ m³
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(15);
                    p.textStyle(p.BOLD);
                    p.text('Volume Conversion: Cube of side 1 cm → m³', W / 2, 28);
                    p.textStyle(p.NORMAL);

                    var cx = W / 2 - 80, cy = H / 2 - 20;
                    var sidePx = 80;
                    p.fill(COLORS.primary);
                    p.stroke(getTextColor());
                    p.strokeWeight(1);
                    p.rect(cx, cy, sidePx, sidePx, 4);
                    p.fill(255);
                    p.noStroke();
                    p.textSize(11);
                    p.text('1 cm', cx + sidePx / 2, cy - 8);
                    p.text('1 cm³', cx + sidePx / 2, cy + sidePx + 22);

                    p.fill(getTextColor());
                    p.textSize(13);
                    p.text('1 cm = 10⁻² m', W / 2 + 60, cy - 10);
                    p.text('(1 cm)³ = (10⁻² m)³', W / 2 + 60, cy + 15);
                    p.text('= 10⁻⁶ m³', W / 2 + 60, cy + 40);

                    p.fill(COLORS.success);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Answer: 1 cm³ = 10⁻⁶ m³', W / 2, H - 35);
                    p.textStyle(p.NORMAL);
                } else {
                    // Length mode
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(16);
                    p.textStyle(p.BOLD);
                    p.text('Unit Conversion: ' + value + ' ' + fromUnit + ' = ? ' + toUnit, W / 2, 30);
                    p.textStyle(p.NORMAL);

                    var factor = 1;
                    if (fromUnit === 'cm' && toUnit === 'm') factor = 0.01;
                    else if (fromUnit === 'm' && toUnit === 'cm') factor = 100;
                    else if (fromUnit === 'km' && toUnit === 'm') factor = 1000;

                    var result = value * factor;
                    var barY = H / 2;
                    var maxBarW = W - 100;
                    var fromBarW = Math.min(value * 50, maxBarW);
                    var toBarW = Math.min(result * 50, maxBarW);

                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.rect(50, barY - 60, fromBarW, 30, 4);
                    p.fill(255);
                    p.textAlign(p.LEFT, p.CENTER);
                    p.textSize(12);
                    p.text(value + ' ' + fromUnit, 60, barY - 45);

                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.textSize(24);
                    p.text('↓', W / 2, barY);
                    p.textSize(11);
                    p.text('× ' + factor, W / 2, barY + 20);

                    p.fill(COLORS.success);
                    p.noStroke();
                    p.rect(50, barY + 50, toBarW, 30, 4);
                    p.fill(255);
                    p.textAlign(p.LEFT, p.CENTER);
                    p.textSize(12);
                    p.text(result.toFixed(4) + ' ' + toUnit, 60, barY + 65);
                }
            };
        }, containerEl);
    }

    /**
     * Interactive Vernier Callipers
     * Drag to measure objects
     * Type: 'vernier-callipers'
     */
    function vernierCallipers(containerEl, params) {
        var mainScaleDivision = params.mainScaleDivision || 1; // mm
        var vernierDivisions = params.vernierDivisions || 20;
        var objectSize = params.objectSize || 2.35; // cm

        return new p5(function (p) {
            var W, H;
            var vernierPos = 0;
            var dragging = false;
            var leastCount = mainScaleDivision / vernierDivisions;
            var scaleY, scaleStart, scaleEnd, pixelsPerMm;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 300;
                p.createCanvas(W, H);
                vernierPos = objectSize * 10; // Convert cm to mm

                // Initialize scale variables
                scaleY = H / 2;
                scaleStart = 50;
                scaleEnd = W - 50;
                pixelsPerMm = (scaleEnd - scaleStart) / 100; // 100mm scale
            };

            p.draw = function () {
                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Interactive Vernier Callipers', W / 2, 20);
                p.textStyle(p.NORMAL);

                // Draw main scale
                p.fill(200);
                p.stroke(0);
                p.strokeWeight(2);
                p.rect(scaleStart, scaleY - 20, scaleEnd - scaleStart, 40);

                // Main scale markings
                p.stroke(0);
                p.strokeWeight(1);
                for (var i = 0; i <= 100; i++) {
                    var x = scaleStart + i * pixelsPerMm;
                    var h = i % 10 === 0 ? 15 : (i % 5 === 0 ? 10 : 5);
                    p.line(x, scaleY - 20, x, scaleY - 20 + h);

                    if (i % 10 === 0) {
                        p.fill(0);
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.textSize(9);
                        p.text(i / 10, x, scaleY - 25);
                    }
                }

                // Vernier scale
                var vernierX = scaleStart + vernierPos * pixelsPerMm;
                p.fill(150, 150, 200);
                p.stroke(0);
                p.strokeWeight(2);
                p.rect(vernierX, scaleY + 20, vernierDivisions * pixelsPerMm * 0.95, 30);

                // Vernier markings
                for (var i = 0; i <= vernierDivisions; i++) {
                    var x = vernierX + i * pixelsPerMm * 0.95;
                    p.stroke(0);
                    p.strokeWeight(1);
                    p.line(x, scaleY + 20, x, scaleY + 30);
                }

                // Reading
                var mainScaleReading = Math.floor(vernierPos / mainScaleDivision) * mainScaleDivision;
                var vernierCoinciding = Math.round((vernierPos - mainScaleReading) / leastCount);
                var totalReading = mainScaleReading + vernierCoinciding * leastCount;

                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(12);
                p.text('Main Scale Reading: ' + mainScaleReading.toFixed(1) + ' mm', 50, H - 60);
                p.text('Vernier Coinciding: ' + vernierCoinciding, 50, H - 45);
                p.text('Least Count: ' + leastCount.toFixed(2) + ' mm', 50, H - 30);
                p.text('Total Reading: ' + totalReading.toFixed(2) + ' mm = ' + (totalReading / 10).toFixed(3) + ' cm', 50, H - 15);

                // Instructions
                p.textAlign(p.RIGHT);
                p.textSize(10);
                p.fill(COLORS.label);
                p.text('Drag the vernier scale to measure', W - 50, H - 15);
            };

            p.mousePressed = function () {
                var vernierX = scaleStart + vernierPos * pixelsPerMm;
                if (p.mouseX > vernierX && p.mouseX < vernierX + vernierDivisions * pixelsPerMm * 0.95 &&
                    p.mouseY > scaleY + 20 && p.mouseY < scaleY + 50) {
                    dragging = true;
                }
            };

            p.mouseDragged = function () {
                if (dragging) {
                    var newPos = (p.mouseX - scaleStart) / pixelsPerMm;
                    vernierPos = p.constrain(newPos, 0, 100 - vernierDivisions * 0.95);
                }
            };

            p.mouseReleased = function () {
                dragging = false;
            };
        }, containerEl);
    }

    /**
     * Interactive Screw Gauge
     * Rotate to measure objects
     * Type: 'screw-gauge'
     */
    function screwGauge(containerEl, params) {
        var pitch = params.pitch || 1; // mm
        var circularDivisions = params.circularDivisions || 100;
        var objectDiameter = params.objectDiameter || 0.52; // mm

        return new p5(function (p) {
            var W, H;
            var rotation = 0;
            var leastCount = pitch / circularDivisions;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
                rotation = (objectDiameter / pitch) * p.TWO_PI;
            };

            p.draw = function () {
                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Interactive Screw Gauge', W / 2, 20);
                p.textStyle(p.NORMAL);

                // Linear scale
                var scaleY = H / 2 - 50;
                var scaleX = W / 2 - 150;
                p.fill(200);
                p.stroke(0);
                p.strokeWeight(2);
                p.rect(scaleX, scaleY, 300, 30);

                // Linear scale markings (0-5 mm)
                for (var i = 0; i <= 5; i++) {
                    var x = scaleX + i * 60;
                    p.stroke(0);
                    p.strokeWeight(1);
                    p.line(x, scaleY, x, scaleY + 15);
                    p.fill(0);
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(10);
                    p.text(i, x, scaleY + 25);
                }

                // Circular scale
                var circleX = W / 2;
                var circleY = H / 2 + 50;
                var radius = 80;

                p.fill(150, 150, 200);
                p.stroke(0);
                p.strokeWeight(2);
                p.ellipse(circleX, circleY, radius * 2, radius * 2);

                // Circular scale divisions
                p.push();
                p.translate(circleX, circleY);
                p.rotate(rotation);
                for (var i = 0; i < circularDivisions; i++) {
                    var angle = (i / circularDivisions) * p.TWO_PI;
                    var x1 = Math.cos(angle) * (radius - 10);
                    var y1 = Math.sin(angle) * (radius - 10);
                    var x2 = Math.cos(angle) * radius;
                    var y2 = Math.sin(angle) * radius;

                    p.stroke(0);
                    p.strokeWeight(i % 10 === 0 ? 2 : 1);
                    p.line(x1, y1, x2, y2);

                    if (i % 10 === 0) {
                        p.fill(0);
                        p.noStroke();
                        p.textAlign(p.CENTER, p.CENTER);
                        p.textSize(9);
                        var labelX = Math.cos(angle) * (radius - 20);
                        var labelY = Math.sin(angle) * (radius - 20);
                        p.text(i, labelX, labelY);
                    }
                }
                p.pop();

                // Reading
                var linearReading = Math.floor((rotation / p.TWO_PI) * pitch * 10) / 10;
                var circularReading = Math.round(((rotation / p.TWO_PI) % 1) * circularDivisions);
                var totalReading = linearReading + circularReading * leastCount;

                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(12);
                p.text('Linear Scale Reading: ' + linearReading.toFixed(1) + ' mm', 50, H - 60);
                p.text('Circular Scale Reading: ' + circularReading, 50, H - 45);
                p.text('Least Count: ' + leastCount.toFixed(3) + ' mm', 50, H - 30);
                p.text('Total Reading: ' + totalReading.toFixed(3) + ' mm', 50, H - 15);

                // Instructions
                p.textAlign(p.RIGHT);
                p.textSize(10);
                p.fill(COLORS.label);
                p.text('Click and drag to rotate', W - 50, H - 15);
            };

            p.mouseDragged = function () {
                var dx = p.mouseX - W / 2;
                var dy = p.mouseY - (H / 2 + 50);
                var angle = p.atan2(dy, dx);
                rotation = angle;
                if (rotation < 0) rotation += p.TWO_PI;
            };
        }, containerEl);
    }

    /**
     * Significant Figures Visualization
     * Shows step-by-step sig fig calculation
     * Type: 'sig-fig-visualization'
     */
    function sigFigVisualization(containerEl, params) {
        var operation = params.operation || 'multiplication';
        var number1 = params.number1 || 4.234;
        var number2 = params.number2 || 1.005;

        return new p5(function (p) {
            var W, H;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
            };

            p.draw = function () {
                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Significant Figures in ' + operation.charAt(0).toUpperCase() + operation.slice(1), W / 2, 30);
                p.textStyle(p.NORMAL);

                // Count sig figs
                var sigFigs1 = countSigFigs(number1.toString());
                var sigFigs2 = countSigFigs(number2.toString());
                var result = operation === 'multiplication' ? number1 * number2 : number1 + number2;
                var minSigFigs = Math.min(sigFigs1, sigFigs2);

                // Display numbers with highlighted sig figs
                var y = 80;
                p.textAlign(p.LEFT);
                p.textSize(16);

                // Number 1
                p.fill(COLORS.primary);
                p.text(number1.toString(), 100, y);
                p.fill(getTextColor());
                p.textSize(12);
                p.text('(' + sigFigs1 + ' sig figs)', 200, y);

                // Operator
                y += 40;
                p.textSize(16);
                p.text(operation === 'multiplication' ? '×' : '+', 100, y);

                // Number 2
                y += 40;
                p.fill(COLORS.accent);
                p.text(number2.toString(), 100, y);
                p.fill(getTextColor());
                p.textSize(12);
                p.text('(' + sigFigs2 + ' sig figs)', 200, y);

                // Line
                y += 30;
                p.stroke(getTextColor());
                p.strokeWeight(2);
                p.line(90, y, 300, y);

                // Result
                y += 30;
                p.noStroke();
                p.fill(getTextColor());
                p.textSize(16);
                p.text('= ' + result.toFixed(6), 100, y);

                // Rounded result
                y += 40;
                var rounded = operation === 'multiplication' ?
                    result.toPrecision(minSigFigs) :
                    result.toFixed(Math.min(getDecimalPlaces(number1), getDecimalPlaces(number2)));
                p.fill(COLORS.success);
                p.textSize(18);
                p.textStyle(p.BOLD);
                p.text('Final: ' + rounded, 100, y);
                p.textStyle(p.NORMAL);

                // Rule
                y += 40;
                p.fill(COLORS.label);
                p.textSize(11);
                var rule = operation === 'multiplication' ?
                    'Rule: Result has ' + minSigFigs + ' sig figs (minimum of operands)' :
                    'Rule: Result has same decimal places as least precise number';
                p.text(rule, 100, y);
            };

            function countSigFigs(numStr) {
                numStr = numStr.replace(/^0+/, ''); // Remove leading zeros
                numStr = numStr.replace('.', ''); // Remove decimal point
                return numStr.length;
            }

            function getDecimalPlaces(num) {
                var str = num.toString();
                if (str.indexOf('.') === -1) return 0;
                return str.split('.')[1].length;
            }
        }, containerEl);
    }

    /**
     * Microscope Magnification Demo
     * Shows actual vs magnified size comparison
     * Type: 'microscope-magnification'
     */
    function microscopeMagnification(containerEl, params) {
        var magnification = params.magnification || 100;
        var observedWidth = params.observedWidth || 3.5; // mm
        var actualThickness = observedWidth / magnification;

        return new p5(function (p) {
            var W, H;
            var currentMag = magnification;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
            };

            p.draw = function () {
                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Microscope Magnification Demo', W / 2, 25);
                p.textStyle(p.NORMAL);

                // Left side: Actual size
                var leftX = W * 0.25;
                var leftY = H / 2;

                p.fill(getTextColor());
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('Actual Size', leftX, 60);
                p.textStyle(p.NORMAL);

                // Draw tiny hair (actual size) - exaggerated for visibility
                var actualScale = 20; // pixels per mm for visibility
                var hairWidth = actualThickness * actualScale;
                p.fill(100, 50, 0);
                p.noStroke();
                p.rect(leftX - hairWidth / 2, leftY - 30, hairWidth, 60, 2);

                // Label
                p.fill(getTextColor());
                p.textSize(10);
                p.text('Hair: ' + (actualThickness * 1000).toFixed(1) + ' μm', leftX, leftY + 50);
                p.text('(' + actualThickness.toFixed(3) + ' mm)', leftX, leftY + 65);

                // Right side: Magnified view
                var rightX = W * 0.75;
                var rightY = H / 2;

                p.fill(getTextColor());
                p.textSize(12);
                p.textStyle(p.BOLD);
                p.text('Under Microscope (×' + currentMag + ')', rightX, 60);
                p.textStyle(p.NORMAL);

                // Microscope circle
                p.stroke(COLORS.primary);
                p.strokeWeight(3);
                p.noFill();
                p.ellipse(rightX, rightY, 120, 120);

                // Draw magnified hair
                var magScale = 2; // pixels per mm in microscope view
                var magHairWidth = observedWidth * magScale;
                p.fill(100, 50, 0);
                p.noStroke();
                p.rect(rightX - magHairWidth / 2, rightY - 40, magHairWidth, 80, 2);

                // Label
                p.fill(getTextColor());
                p.textSize(10);
                p.text('Observed: ' + observedWidth.toFixed(1) + ' mm', rightX, rightY + 70);

                // Formula
                p.fill(COLORS.accent);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('Magnification = Image Size / Object Size', W / 2, H - 60);
                p.textStyle(p.NORMAL);
                p.fill(getTextColor());
                p.textSize(10);
                p.text(currentMag + ' = ' + observedWidth.toFixed(1) + ' mm / ' + actualThickness.toFixed(3) + ' mm', W / 2, H - 40);
                p.text('Actual Thickness = ' + observedWidth.toFixed(1) + ' / ' + currentMag + ' = ' + actualThickness.toFixed(3) + ' mm', W / 2, H - 25);
                p.text('= ' + (actualThickness * 1000).toFixed(1) + ' μm', W / 2, H - 10);
            };
        }, containerEl);
    }

    /**
     * Thread Winding Demo
     * Shows measurement technique by winding thread
     * Type: 'thread-winding-demo'
     */
    function threadWindingDemo(containerEl, params) {
        var threadDiameter = params.threadDiameter || 0.5; // mm
        var numberOfTurns = params.numberOfTurns || 20;
        var pencilRadius = params.pencilRadius || 4; // mm

        return new p5(function (p) {
            var W, H;
            var animProgress = 0;
            var playing = true;
            var currentTurns = numberOfTurns;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    animProgress += 0.01;
                    if (animProgress > 1) animProgress = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Thread Diameter Measurement by Winding', W / 2, 25);
                p.textStyle(p.NORMAL);

                // Pencil
                var pencilX = W / 2;
                var pencilY = H / 2 - 30;
                var pencilLength = 200;
                var scale = 3; // pixels per mm

                // Draw pencil body
                p.fill(255, 220, 100);
                p.stroke(0);
                p.strokeWeight(2);
                p.rect(pencilX - pencilLength / 2, pencilY - pencilRadius * scale,
                    pencilLength, pencilRadius * 2 * scale, 5);

                // Draw wound thread
                var turnsToShow = Math.floor(animProgress * currentTurns);
                var totalLength = currentTurns * threadDiameter;

                for (var i = 0; i <= turnsToShow; i++) {
                    var x = pencilX - pencilLength / 2 + 20 + i * (threadDiameter * scale);

                    // Thread winding
                    p.stroke(200, 50, 50);
                    p.strokeWeight(threadDiameter * scale);
                    p.noFill();

                    // Draw spiral
                    p.beginShape();
                    for (var angle = 0; angle <= p.TWO_PI; angle += 0.1) {
                        var r = pencilRadius * scale;
                        var px = x + r * p.cos(angle);
                        var py = pencilY + r * p.sin(angle);
                        p.vertex(px, py);
                    }
                    p.endShape();
                }

                // Measurement arrow
                if (turnsToShow > 0) {
                    var startX = pencilX - pencilLength / 2 + 20;
                    var endX = startX + turnsToShow * threadDiameter * scale;
                    var arrowY = pencilY + pencilRadius * scale + 30;

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.line(startX, arrowY, endX, arrowY);

                    // Arrow heads
                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.triangle(startX, arrowY, startX + 8, arrowY - 4, startX + 8, arrowY + 4);
                    p.triangle(endX, arrowY, endX - 8, arrowY - 4, endX - 8, arrowY + 4);

                    // Length label
                    p.fill(COLORS.primary);
                    p.textAlign(p.CENTER);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    var measuredLength = turnsToShow * threadDiameter;
                    p.text('L = ' + measuredLength.toFixed(1) + ' mm', (startX + endX) / 2, arrowY + 20);
                    p.textStyle(p.NORMAL);
                }

                // Info panel
                var infoY = H - 120;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, infoY, W - 40, 100, 8);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Number of turns (N): ' + turnsToShow, 40, infoY + 25);
                p.text('Total length (L): ' + (turnsToShow * threadDiameter).toFixed(1) + ' mm', 40, infoY + 45);

                p.fill(COLORS.success);
                p.textStyle(p.BOLD);
                p.textSize(12);
                p.text('Thread Diameter = L / N = ' + (turnsToShow * threadDiameter).toFixed(1) + ' / ' + turnsToShow + ' = ' + threadDiameter.toFixed(2) + ' mm', 40, infoY + 70);
                p.textStyle(p.NORMAL);

                // Slider
                p.fill(getTextColor());
                p.textSize(10);
                p.textAlign(p.RIGHT);
                p.text('Adjust turns: ' + currentTurns, W - 40, infoY + 25);

                // Play/Pause button
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 40, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 52);
            };

            p.mousePressed = function () {
                // Play/pause button
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 40 && p.mouseY < 65) {
                    playing = !playing;
                }
            };

            p.keyPressed = function () {
                if (p.keyCode === p.UP_ARROW && currentTurns < 50) {
                    currentTurns++;
                    animProgress = 0;
                } else if (p.keyCode === p.DOWN_ARROW && currentTurns > 5) {
                    currentTurns--;
                    animProgress = 0;
                }
            };
        }, containerEl);
    }

    /**
     * Area Magnification Demo
     * Shows relationship between area and linear magnification
     * Type: 'area-magnification'
     */
    function areaMagnification(containerEl, params) {
        var slideArea = params.slideArea || 1.75; // cm²
        var screenArea = params.screenArea || 15500; // cm²

        return new p5(function (p) {
            var W, H;
            var animProgress = 0;
            var playing = true;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    animProgress += 0.01;
                    if (animProgress > 1) animProgress = 1;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Area Magnification vs Linear Magnification', W / 2, 25);
                p.textStyle(p.NORMAL);

                // Slide (left)
                var slideX = W * 0.25;
                var slideY = H / 2;
                var slideSize = Math.sqrt(slideArea) * 15; // pixels

                p.fill(getTextColor());
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text('Slide', slideX, slideY - slideSize / 2 - 15);
                p.textStyle(p.NORMAL);

                // Draw slide
                p.fill(100, 150, 255, 150);
                p.stroke(COLORS.primary);
                p.strokeWeight(2);
                p.rect(slideX - slideSize / 2, slideY - slideSize / 2, slideSize, slideSize);

                // Area label
                p.fill(255);
                p.noStroke();
                p.textSize(10);
                p.text(slideArea.toFixed(2) + ' cm²', slideX, slideY);

                // Projection beam (animated)
                if (animProgress > 0) {
                    var beamProgress = Math.min(animProgress * 1.5, 1);
                    var screenX = W * 0.75;

                    p.stroke(255, 255, 0, 100);
                    p.strokeWeight(2);
                    p.noFill();

                    // Beam lines
                    var targetSize = Math.sqrt(screenArea) * 1.5;
                    p.line(slideX - slideSize / 2, slideY - slideSize / 2,
                        p.lerp(slideX - slideSize / 2, screenX - targetSize / 2, beamProgress),
                        p.lerp(slideY - slideSize / 2, slideY - targetSize / 2, beamProgress));
                    p.line(slideX + slideSize / 2, slideY - slideSize / 2,
                        p.lerp(slideX + slideSize / 2, screenX + targetSize / 2, beamProgress),
                        p.lerp(slideY - slideSize / 2, slideY - targetSize / 2, beamProgress));
                    p.line(slideX - slideSize / 2, slideY + slideSize / 2,
                        p.lerp(slideX - slideSize / 2, screenX - targetSize / 2, beamProgress),
                        p.lerp(slideY + slideSize / 2, slideY + targetSize / 2, beamProgress));
                    p.line(slideX + slideSize / 2, slideY + slideSize / 2,
                        p.lerp(slideX + slideSize / 2, screenX + targetSize / 2, beamProgress),
                        p.lerp(slideY + slideSize / 2, slideY + targetSize / 2, beamProgress));
                }

                // Screen (right)
                if (animProgress > 0.5) {
                    var screenX = W * 0.75;
                    var screenY = slideY;
                    var screenSize = Math.sqrt(screenArea) * 1.5;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.text('Screen', screenX, screenY - screenSize / 2 - 15);
                    p.textStyle(p.NORMAL);

                    // Draw screen
                    var alpha = (animProgress - 0.5) * 2 * 255;
                    p.fill(100, 150, 255, alpha * 0.6);
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.rect(screenX - screenSize / 2, screenY - screenSize / 2, screenSize, screenSize);

                    // Area label
                    p.fill(255, alpha);
                    p.noStroke();
                    p.textSize(10);
                    p.text(screenArea.toFixed(0) + ' cm²', screenX, screenY);
                }

                // Calculation panel
                var panelY = H - 100;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, panelY, W - 40, 80, 8);

                var areaMag = screenArea / slideArea;
                var linearMag = Math.sqrt(areaMag);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Area Magnification = Screen Area / Slide Area', 40, panelY + 20);
                p.text('= ' + screenArea.toFixed(0) + ' / ' + slideArea.toFixed(2) + ' = ' + areaMag.toFixed(0), 40, panelY + 35);

                p.fill(COLORS.success);
                p.textStyle(p.BOLD);
                p.textSize(12);
                p.text('Linear Magnification = √(Area Magnification) = √' + areaMag.toFixed(0) + ' = ' + linearMag.toFixed(1), 40, panelY + 60);
                p.textStyle(p.NORMAL);

                // Play/Pause button
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 40, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 52);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 40 && p.mouseY < 65) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  CHAPTER 2: MOTION IN A STRAIGHT LINE
    // =====================================================

    /**
     * Daily Commute Graph
     * Woman's journey: walk to office, stay, return by auto
     * Type: 'daily-commute-graph'
     */
    function dailyCommuteGraph(containerEl, params) {
        var distance = params.distance || 2.5; // km
        var walkSpeed = params.walkSpeed || 5; // km/h
        var autoSpeed = params.autoSpeed || 25; // km/h
        var stayDuration = params.stayDuration || 7.5; // hours

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var playing = true;

            var walkTime = distance / walkSpeed; // 0.5 h
            var returnTime = distance / autoSpeed; // 0.1 h
            var totalTime = walkTime + stayDuration + returnTime; // 8.1 h

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    t += 0.05;
                    if (t > totalTime) t = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Daily Commute: Position-Time Graph', W / 2, 20);
                p.textStyle(p.NORMAL);

                // Calculate current position
                var currentPos = 0;
                var phase = '';
                if (t <= walkTime) {
                    currentPos = (t / walkTime) * distance;
                    phase = 'Walking to office';
                } else if (t <= walkTime + stayDuration) {
                    currentPos = distance;
                    phase = 'At office';
                } else {
                    var returnProgress = (t - walkTime - stayDuration) / returnTime;
                    currentPos = distance * (1 - returnProgress);
                    phase = 'Returning home';
                }

                // x-t graph
                var graphX = 80;
                var graphY = H - 100;
                var graphW = W - 160;
                var graphH = 250;

                // Axes
                p.stroke(getTextColor());
                p.strokeWeight(2);
                p.line(graphX, graphY, graphX + graphW, graphY); // t-axis
                p.line(graphX, graphY, graphX, graphY - graphH); // x-axis

                // Labels
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER);
                p.text('Time (hours)', graphX + graphW / 2, graphY + 25);
                p.textAlign(p.RIGHT);
                p.text('Position (km)', graphX - 10, graphY - graphH - 10);

                var xScale = graphH / (distance * 1.2);
                var tScale = graphW / totalTime;

                // Segment 1: Walk to office
                p.stroke(COLORS.primary);
                p.strokeWeight(3);
                p.line(graphX, graphY,
                    graphX + walkTime * tScale, graphY - distance * xScale);

                // Segment 2: At office
                p.stroke(COLORS.accent);
                p.line(graphX + walkTime * tScale, graphY - distance * xScale,
                    graphX + (walkTime + stayDuration) * tScale, graphY - distance * xScale);

                // Segment 3: Return home
                p.stroke(COLORS.success);
                p.line(graphX + (walkTime + stayDuration) * tScale, graphY - distance * xScale,
                    graphX + totalTime * tScale, graphY);

                // Current point
                p.fill(COLORS.danger);
                p.noStroke();
                p.ellipse(graphX + t * tScale, graphY - currentPos * xScale, 10, 10);

                // Animation: Woman walking/at office/in auto
                var animY = 80;
                var animScale = (W - 160) / distance;

                // Road
                p.stroke(100);
                p.strokeWeight(2);
                p.line(80, animY, W - 80, animY);

                // Home
                p.fill(150, 100, 50);
                p.noStroke();
                p.rect(75, animY - 20, 15, 20);
                p.fill(getTextColor());
                p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('Home', 82, animY + 10);

                // Office
                p.fill(100, 100, 150);
                p.rect(80 + distance * animScale - 15, animY - 25, 20, 25);
                p.fill(getTextColor());
                p.text('Office', 80 + distance * animScale - 5, animY + 10);

                // Woman/Auto
                var womanX = 80 + currentPos * animScale;
                if (phase === 'Returning home') {
                    // Auto
                    p.fill(255, 200, 0);
                    p.stroke(0);
                    p.strokeWeight(1);
                    p.rect(womanX - 15, animY - 10, 30, 15, 3);
                    // Wheels
                    p.fill(50);
                    p.ellipse(womanX - 8, animY + 5, 6, 6);
                    p.ellipse(womanX + 8, animY + 5, 6, 6);
                } else {
                    // Woman
                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.ellipse(womanX, animY - 10, 12, 12); // head
                    p.ellipse(womanX, animY, 10, 15); // body
                }

                // Info panel
                var panelY = H - 70;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, panelY, W - 40, 60, 8);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Time: ' + t.toFixed(2) + ' h (' + phase + ')', 30, panelY + 20);
                p.text('Position: ' + currentPos.toFixed(2) + ' km', 30, panelY + 38);

                // Segment info
                p.fill(COLORS.primary);
                p.text('Walk: ' + walkTime.toFixed(1) + ' h', 250, panelY + 20);
                p.fill(COLORS.accent);
                p.text('Stay: ' + stayDuration.toFixed(1) + ' h', 250, panelY + 38);
                p.fill(COLORS.success);
                p.text('Return: ' + returnTime.toFixed(1) + ' h', 250, panelY + 56);

                // Play/Pause
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 47);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 35 && p.mouseY < 60) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Braking Car Demo
     * Shows car decelerating to a stop
     * Type: 'braking-car-demo'
     */
    function brakingCarDemo(containerEl, params) {
        var u = params.initialSpeed || 35; // m/s
        var s = params.distance || 200; // m

        // Calculate deceleration: v² = u² + 2as, v=0
        var a = -(u * u) / (2 * s); // negative for deceleration
        var stopTime = -u / a; // v = u + at, v=0

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var playing = true;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    t += 0.1;
                    if (t > stopTime + 1) t = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Braking Car: Deceleration and Stopping Distance', W / 2, 20);
                p.textStyle(p.NORMAL);

                // Calculate current state
                var currentT = Math.min(t, stopTime);
                var v = u + a * currentT;
                var distance = u * currentT + 0.5 * a * currentT * currentT;

                // Road animation
                var roadY = 120;
                var carScale = (W - 200) / s;

                // Road
                p.stroke(150);
                p.strokeWeight(3);
                p.line(80, roadY, W - 80, roadY);

                // Dashed center line
                p.drawingContext.setLineDash([10, 10]);
                p.stroke(255, 255, 0);
                p.strokeWeight(2);
                p.line(80, roadY - 15, W - 80, roadY - 15);
                p.drawingContext.setLineDash([]);

                // Starting point marker
                p.fill(COLORS.success);
                p.noStroke();
                p.textSize(10);
                p.textAlign(p.CENTER);
                p.text('Start', 80, roadY + 25);
                p.text(u + ' m/s', 80, roadY + 38);

                // Stopping point marker
                p.fill(COLORS.danger);
                p.text('Stop', 80 + s * carScale, roadY + 25);
                p.text('0 m/s', 80 + s * carScale, roadY + 38);

                // Distance marker
                p.stroke(COLORS.accent);
                p.strokeWeight(1);
                p.line(80, roadY + 50, 80 + s * carScale, roadY + 50);
                p.fill(COLORS.accent);
                p.noStroke();
                p.textAlign(p.CENTER);
                p.text(s + ' m', 80 + (s * carScale) / 2, roadY + 65);

                // Car
                var carX = 80 + distance * carScale;
                var carW = 50;
                var carH = 25;

                // Car body
                p.fill(v > 0 ? COLORS.primary : COLORS.danger);
                p.stroke(0);
                p.strokeWeight(2);
                p.rect(carX - carW / 2, roadY - carH - 10, carW, carH, 5);

                // Wheels
                p.fill(50);
                p.ellipse(carX - 15, roadY - 10, 12, 12);
                p.ellipse(carX + 15, roadY - 10, 12, 12);

                // Brake lights (when braking)
                if (v > 0) {
                    p.fill(255, 0, 0);
                    p.noStroke();
                    p.ellipse(carX - carW / 2 + 5, roadY - carH / 2 - 10, 6, 6);
                }

                // Velocity vector
                if (v > 0) {
                    var vScale = 2;
                    p.stroke(COLORS.success);
                    p.strokeWeight(3);
                    p.line(carX, roadY - carH - 25, carX + v * vScale, roadY - carH - 25);

                    // Arrow
                    p.fill(COLORS.success);
                    p.noStroke();
                    p.triangle(carX + v * vScale, roadY - carH - 25,
                        carX + v * vScale - 8, roadY - carH - 28,
                        carX + v * vScale - 8, roadY - carH - 22);

                    p.fill(getTextColor());
                    p.textSize(10);
                    p.textAlign(p.CENTER);
                    p.text('v = ' + v.toFixed(1) + ' m/s', carX + v * vScale / 2, roadY - carH - 35);
                }

                // v-t graph
                if (params.showVTGraph !== false) {
                    var graphX = W - 250;
                    var graphY = H - 150;
                    var graphW = 200;
                    var graphH = 100;

                    // Border
                    p.stroke(getTextColor());
                    p.strokeWeight(1);
                    p.noFill();
                    p.rect(graphX, graphY - graphH, graphW, graphH);

                    // Axes
                    p.line(graphX, graphY, graphX + graphW, graphY); // t-axis
                    p.line(graphX, graphY, graphX, graphY - graphH); // v-axis

                    // Labels
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.CENTER);
                    p.text('t (s)', graphX + graphW / 2, graphY + 15);
                    p.textAlign(p.RIGHT);
                    p.text('v (m/s)', graphX - 5, graphY - graphH - 5);

                    // v-t line
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.line(graphX, graphY - (u / u) * graphH,
                        graphX + graphW, graphY);

                    // Current point
                    var currentX = graphX + (currentT / stopTime) * graphW;
                    var currentY = graphY - (v / u) * graphH;
                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.ellipse(currentX, currentY, 8, 8);
                }

                // Calculations panel
                var panelY = H - 80;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, panelY, W - 40, 70, 8);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Time: ' + currentT.toFixed(2) + ' s', 30, panelY + 20);
                p.text('Distance: ' + distance.toFixed(1) + ' m', 30, panelY + 38);
                p.text('Velocity: ' + v.toFixed(1) + ' m/s', 30, panelY + 56);

                p.fill(COLORS.danger);
                p.textStyle(p.BOLD);
                p.textSize(12);
                p.text('Retardation: ' + Math.abs(a).toFixed(2) + ' m/s²', 250, panelY + 20);
                p.text('Stopping time: ' + stopTime.toFixed(2) + ' s', 250, panelY + 38);
                p.textStyle(p.NORMAL);

                // Play/Pause
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 47);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 35 && p.mouseY < 60) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Position-Time Graph Interactive
     * Shows motion of objects with adjustable speeds and start times
     * Type: 'position-time-graph'
     */
    function positionTimeGraph(containerEl, params) {
        var objects = params.objects || [
            { id: 'A', label: 'Object A', start_time: 0, speed: 5, final_position: 2.5, color: COLORS.primary },
            { id: 'B', label: 'Object B', start_time: 0.5, speed: 7.5, final_position: 5, color: COLORS.accent }
        ];
        var timeRange = params.time_range || [0, 1];
        var positionRange = params.position_range || [0, 6];

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var animTime = 0;
            var playing = true;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                t += 0.02;
                if (playing) {
                    animTime += 0.005;
                    if (animTime > timeRange[1]) animTime = 0;
                }

                p.background(getBg());

                // Graph area
                var margin = { left: 60, right: 40, top: 40, bottom: 60 };
                var graphW = W - margin.left - margin.right;
                var graphH = H - margin.top - margin.bottom;
                var originX = margin.left;
                var originY = H - margin.bottom;

                // Draw grid
                p.stroke(getGridColor());
                p.strokeWeight(1);
                for (var i = 0; i <= 10; i++) {
                    var x = originX + (i / 10) * graphW;
                    var y = originY - (i / 10) * graphH;
                    p.line(x, originY, x, margin.top);
                    p.line(originX, y, originX + graphW, y);
                }

                // Draw axes
                p.stroke(getAxisColor());
                p.strokeWeight(2);
                p.line(originX, originY, originX + graphW, originY); // x-axis
                p.line(originX, originY, originX, margin.top); // y-axis

                // Axis labels
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(12);
                p.text('Time (h)', originX + graphW / 2, H - 10);

                p.push();
                p.translate(15, originY - graphH / 2);
                p.rotate(-p.HALF_PI);
                p.text('Position (km)', 0, 0);
                p.pop();

                // Draw position-time lines for each object
                for (var i = 0; i < objects.length; i++) {
                    var obj = objects[i];
                    var startX = originX + (obj.start_time / timeRange[1]) * graphW;
                    var endTime = obj.start_time + (obj.final_position / obj.speed);
                    var endX = originX + (endTime / timeRange[1]) * graphW;
                    var endY = originY - (obj.final_position / positionRange[1]) * graphH;

                    // Draw line
                    p.stroke(obj.color);
                    p.strokeWeight(2);
                    p.line(startX, originY, endX, endY);

                    // Draw current position marker
                    if (animTime >= obj.start_time && animTime <= endTime) {
                        var currentTime = animTime - obj.start_time;
                        var currentPos = obj.speed * currentTime;
                        var markerX = originX + (animTime / timeRange[1]) * graphW;
                        var markerY = originY - (currentPos / positionRange[1]) * graphH;

                        p.fill(obj.color);
                        p.noStroke();
                        p.ellipse(markerX, markerY, 10, 10);

                        // Glow effect
                        for (var g = 2; g > 0; g--) {
                            var alpha = 30 - g * 10;
                            p.fill(p.red(p.color(obj.color)), p.green(p.color(obj.color)), p.blue(p.color(obj.color)), alpha);
                            p.ellipse(markerX, markerY, 10 + g * 6, 10 + g * 6);
                        }
                    }

                    // Label
                    p.fill(obj.color);
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.text(obj.label, endX + 5, endY);
                    p.textStyle(p.NORMAL);
                }

                // Time marker (vertical line)
                var timeX = originX + (animTime / timeRange[1]) * graphW;
                p.stroke(COLORS.label);
                p.strokeWeight(1);
                drawDashedLine(p, timeX, originY, timeX, margin.top);

                // Title
                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }

                // Play/Pause button
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 10, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 22);
            };

            p.mousePressed = function () {
                // Check if play/pause button clicked
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 10 && p.mouseY < 35) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Vertical Projectile Motion
     * Ball thrown upward with gravity - shows v=0 but a≠0 at max height
     * Type: 'vertical-projectile'
     */
    function verticalProjectile(containerEl, params) {
        var initialVelocity = params.initial_velocity || 29.4; // m/s
        var gravity = params.gravity || 9.8; // m/s²
        var showVectors = params.show_vectors !== false;

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var simTime = 0;
            var playing = true;
            var maxHeight, timeToMax, totalTime;

            p.setup = function () {
                W = containerEl.offsetWidth || 500;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);

                // Calculate motion parameters
                timeToMax = initialVelocity / gravity;
                maxHeight = (initialVelocity * initialVelocity) / (2 * gravity);
                totalTime = 2 * timeToMax;
            };

            p.draw = function () {
                t += 0.02;
                if (playing) {
                    simTime += 0.03;
                    if (simTime > totalTime) simTime = 0;
                }

                p.background(getBg());
                drawGrid(p, 30);

                // Animation area (left side)
                var animW = W * 0.4;
                var animH = H - 80;
                var graphW = W * 0.55;
                var graphX = animW + 20;

                // Ground line
                var groundY = H - 40;
                p.stroke(COLORS.success);
                p.strokeWeight(3);
                p.line(0, groundY, animW, groundY);

                // Calculate current position and velocity
                var currentY, currentVy;
                if (simTime <= timeToMax) {
                    currentY = initialVelocity * simTime - 0.5 * gravity * simTime * simTime;
                    currentVy = initialVelocity - gravity * simTime;
                } else {
                    var fallTime = simTime - timeToMax;
                    currentY = maxHeight - 0.5 * gravity * fallTime * fallTime;
                    currentVy = -gravity * fallTime;
                }

                var scale = (animH - 40) / maxHeight;
                var ballY = groundY - currentY * scale;
                var ballX = animW / 2;

                // Draw trajectory path (faint)
                p.stroke(COLORS.path);
                p.strokeWeight(1);
                p.noFill();
                p.beginShape();
                for (var i = 0; i <= totalTime; i += 0.1) {
                    var y = i <= timeToMax ?
                        initialVelocity * i - 0.5 * gravity * i * i :
                        maxHeight - 0.5 * gravity * (i - timeToMax) * (i - timeToMax);
                    var py = groundY - y * scale;
                    p.vertex(ballX, py);
                }
                p.endShape();

                // Draw ball
                p.fill(COLORS.primary);
                p.noStroke();
                p.ellipse(ballX, ballY, 20, 20);

                // Glow effect
                for (var g = 2; g > 0; g--) {
                    var alpha = 30 - g * 10;
                    p.fill(p.red(p.color(COLORS.primary)), p.green(p.color(COLORS.primary)), p.blue(p.color(COLORS.primary)), alpha);
                    p.ellipse(ballX, ballY, 20 + g * 8, 20 + g * 8);
                }

                // Draw vectors
                if (showVectors) {
                    var vScale = 2;

                    // Velocity vector (blue)
                    if (Math.abs(currentVy) > 0.5) {
                        drawVector(p, ballX, ballY, 0, -currentVy * vScale, COLORS.velocity, 'v⃗', 1);
                    }

                    // Acceleration vector (red, always downward)
                    drawVector(p, ballX + 30, ballY, 0, gravity * vScale * 0.5, COLORS.acceleration, 'a⃗', 1);
                }

                // Highlight max height
                if (Math.abs(simTime - timeToMax) < 0.1) {
                    p.stroke(COLORS.warning);
                    p.strokeWeight(2);
                    p.noFill();
                    p.ellipse(ballX, ballY, 40 + Math.sin(t * 5) * 5, 40 + Math.sin(t * 5) * 5);

                    p.fill(COLORS.warning);
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.textStyle(p.BOLD);
                    p.text('v = 0', ballX + 25, ballY - 30);
                    p.text('a = g ≠ 0', ballX + 25, ballY - 15);
                    p.textStyle(p.NORMAL);
                }

                // Graphs (right side)
                var graphH = (H - 100) / 2;
                var graphMargin = 40;

                // Velocity-time graph
                drawMiniGraph(p, graphX, 50, graphW, graphH, 'Velocity vs Time', 't (s)', 'v (m/s)',
                    totalTime, initialVelocity, -initialVelocity, function (t) {
                        return t <= timeToMax ? initialVelocity - gravity * t : -gravity * (t - timeToMax);
                    }, simTime, COLORS.velocity);

                // Position-time graph
                drawMiniGraph(p, graphX, 50 + graphH + 20, graphW, graphH, 'Position vs Time', 't (s)', 'y (m)',
                    totalTime, maxHeight, 0, function (t) {
                        return t <= timeToMax ?
                            initialVelocity * t - 0.5 * gravity * t * t :
                            maxHeight - 0.5 * gravity * (t - timeToMax) * (t - timeToMax);
                    }, simTime, COLORS.success);

                // Title
                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }

                // Play/Pause button
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, H - 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, H - 22);
            };

            function drawMiniGraph(p, x, y, w, h, title, xLabel, yLabel, xMax, yMax, yMin, func, currentT, color) {
                // Background
                p.fill(isDark() ? 'rgba(255,255,255,0.02)' : 'rgba(0,0,0,0.02)');
                p.noStroke();
                p.rect(x, y, w, h, 4);

                // Grid
                p.stroke(getGridColor());
                p.strokeWeight(1);
                for (var i = 0; i <= 5; i++) {
                    var gx = x + (i / 5) * w;
                    var gy = y + (i / 5) * h;
                    p.line(gx, y, gx, y + h);
                    p.line(x, gy, x + w, gy);
                }

                // Axes
                var zeroY = y + h - (0 - yMin) / (yMax - yMin) * h;
                p.stroke(getAxisColor());
                p.strokeWeight(2);
                p.line(x, zeroY, x + w, zeroY);
                p.line(x, y, x, y + h);

                // Plot function
                p.stroke(color);
                p.strokeWeight(2);
                p.noFill();
                p.beginShape();
                for (var i = 0; i <= 100; i++) {
                    var t = (i / 100) * xMax;
                    var val = func(t);
                    var px = x + (t / xMax) * w;
                    var py = y + h - ((val - yMin) / (yMax - yMin)) * h;
                    p.vertex(px, py);
                }
                p.endShape();

                // Current time marker
                var markerX = x + (currentT / xMax) * w;
                var markerVal = func(currentT);
                var markerY = y + h - ((markerVal - yMin) / (yMax - yMin)) * h;
                p.fill(color);
                p.noStroke();
                p.ellipse(markerX, markerY, 8, 8);

                // Labels
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(11);
                p.textStyle(p.BOLD);
                p.text(title, x + w / 2, y + 12);
                p.textStyle(p.NORMAL);
                p.textSize(9);
                p.text(xLabel, x + w / 2, y + h + 15);

                p.push();
                p.translate(x - 25, y + h / 2);
                p.rotate(-p.HALF_PI);
                p.text(yLabel, 0, 0);
                p.pop();
            }

            p.mousePressed = function () {
                // Check if play/pause button clicked
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > H - 35 && p.mouseY < H - 10) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Free Fall Demo
     * Stone thrown upward with gravity
     * Type: 'free-fall-demo'
     */
    function freeFallDemo(containerEl, params) {
        var u = params.initialVelocity || 20; // m/s upward
        var g = params.gravity || 9.8; // m/s²

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var playing = true;
            var maxTime = 2 * u / g; // Total flight time

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 500;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    t += 0.05;
                    if (t > maxTime) t = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Free Fall: Stone Thrown Upward', W / 2, 20);
                p.textStyle(p.NORMAL);

                // Calculate current state
                var y = u * t - 0.5 * g * t * t; // height
                var v = u - g * t; // velocity
                var tMax = u / g; // time at max height
                var hMax = (u * u) / (2 * g); // max height

                // Left side: Animation
                var animX = W * 0.3;
                var groundY = H - 80;
                var scale = (groundY - 100) / hMax; // pixels per meter

                // Ground
                p.stroke(100);
                p.strokeWeight(3);
                p.line(animX - 100, groundY, animX + 100, groundY);

                // Trajectory path (parabola)
                p.stroke(COLORS.label);
                p.strokeWeight(1);
                p.noFill();
                p.beginShape();
                for (var time = 0; time <= maxTime; time += 0.1) {
                    var height = u * time - 0.5 * g * time * time;
                    if (height >= 0) {
                        p.vertex(animX, groundY - height * scale);
                    }
                }
                p.endShape();

                // Stone
                var stoneY = groundY - y * scale;
                p.fill(150, 100, 50);
                p.stroke(0);
                p.strokeWeight(2);
                p.ellipse(animX, stoneY, 20, 20);

                // Velocity vector
                if (params.showVelocityVector !== false) {
                    var vScale = 5; // pixels per m/s
                    p.stroke(v >= 0 ? COLORS.success : COLORS.danger);
                    p.strokeWeight(3);
                    p.line(animX, stoneY, animX, stoneY - v * vScale);

                    // Arrow head
                    p.fill(v >= 0 ? COLORS.success : COLORS.danger);
                    p.noStroke();
                    if (v >= 0) {
                        p.triangle(animX, stoneY - v * vScale,
                            animX - 5, stoneY - v * vScale + 10,
                            animX + 5, stoneY - v * vScale + 10);
                    } else {
                        p.triangle(animX, stoneY - v * vScale,
                            animX - 5, stoneY - v * vScale - 10,
                            animX + 5, stoneY - v * vScale - 10);
                    }

                    // Velocity label
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.textAlign(p.LEFT);
                    p.text('v = ' + v.toFixed(1) + ' m/s', animX + 15, stoneY);
                }

                // Max height marker
                if (params.showMaxHeight !== false) {
                    var maxHeightY = groundY - hMax * scale;
                    p.stroke(COLORS.accent);
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash([5, 5]);
                    p.line(animX - 80, maxHeightY, animX + 80, maxHeightY);
                    p.drawingContext.setLineDash([]);

                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.RIGHT);
                    p.text('Max height: ' + hMax.toFixed(1) + ' m', animX - 85, maxHeightY);
                    p.text('(v = 0)', animX - 85, maxHeightY + 12);
                }

                // Right side: v-t graph
                if (params.showVTGraph !== false) {
                    var graphX = W * 0.65;
                    var graphY = H / 2;
                    var graphW = 200;
                    var graphH = 150;

                    // Graph border
                    p.stroke(getTextColor());
                    p.strokeWeight(2);
                    p.noFill();
                    p.rect(graphX, graphY - graphH / 2, graphW, graphH);

                    // Axes
                    p.stroke(getTextColor());
                    p.strokeWeight(1);
                    p.line(graphX, graphY, graphX + graphW, graphY); // t-axis
                    p.line(graphX, graphY - graphH / 2, graphX, graphY + graphH / 2); // v-axis

                    // Labels
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.CENTER);
                    p.text('t (s)', graphX + graphW / 2, graphY + graphH / 2 + 15);
                    p.textAlign(p.RIGHT);
                    p.text('v (m/s)', graphX - 5, graphY - graphH / 2 - 5);

                    // v-t line
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.line(graphX, graphY - (u / (2 * u)) * graphH,
                        graphX + graphW, graphY + (u / (2 * u)) * graphH);

                    // Current point
                    var currentX = graphX + (t / maxTime) * graphW;
                    var currentY = graphY - (v / (2 * u)) * graphH;
                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.ellipse(currentX, currentY, 8, 8);

                    // Zero velocity line
                    p.stroke(COLORS.accent);
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash([3, 3]);
                    p.line(graphX + (tMax / maxTime) * graphW, graphY - graphH / 2,
                        graphX + (tMax / maxTime) * graphW, graphY + graphH / 2);
                    p.drawingContext.setLineDash([]);
                }

                // Info panel
                var panelY = H - 60;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, panelY, W - 40, 50, 8);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Time: ' + t.toFixed(2) + ' s', 30, panelY + 20);
                p.text('Height: ' + Math.max(0, y).toFixed(2) + ' m', 30, panelY + 38);

                p.text('Velocity: ' + v.toFixed(2) + ' m/s ' + (v >= 0 ? '↑' : '↓'), 200, panelY + 20);
                p.text('Max Height: ' + hMax.toFixed(2) + ' m', 200, panelY + 38);

                // Symmetry note
                if (params.showSymmetry !== false && t > tMax) {
                    p.fill(COLORS.success);
                    p.textStyle(p.BOLD);
                    p.text('Symmetry: Time up = Time down', 400, panelY + 29);
                    p.textStyle(p.NORMAL);
                }

                // Play/Pause button
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 47);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 35 && p.mouseY < 60) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Velocity-Time Analysis
     * Shows area under curve = displacement
     * Type: 'velocity-time-analysis'
     */
    function velocityTimeAnalysis(containerEl, params) {
        var u = params.initialVelocity || 0;
        var a = params.acceleration || 2;
        var duration = params.duration || 10;

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var playing = true;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    t += 0.1;
                    if (t > duration) t = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Velocity-Time Graph: Area Under Curve = Displacement', W / 2, 20);
                p.textStyle(p.NORMAL);

                // v-t graph
                var graphX = 80;
                var graphY = H / 2 + 50;
                var graphW = W - 200;
                var graphH = 200;

                // Axes
                p.stroke(getTextColor());
                p.strokeWeight(2);
                p.line(graphX, graphY, graphX + graphW, graphY); // t-axis
                p.line(graphX, graphY, graphX, graphY - graphH); // v-axis

                // Labels
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER);
                p.text('Time (s)', graphX + graphW / 2, graphY + 25);
                p.textAlign(p.RIGHT);
                p.text('Velocity (m/s)', graphX - 10, graphY - graphH - 10);

                // v-t line
                var v = u + a * t;
                var vMax = u + a * duration;
                var vScale = graphH / vMax;

                // Shaded area (displacement)
                if (params.showArea !== false) {
                    p.fill(COLORS.primary + '40');
                    p.noStroke();
                    p.beginShape();
                    p.vertex(graphX, graphY);
                    for (var time = 0; time <= t; time += 0.5) {
                        var vel = u + a * time;
                        var x = graphX + (time / duration) * graphW;
                        var y = graphY - vel * vScale;
                        p.vertex(x, y);
                    }
                    p.vertex(graphX + (t / duration) * graphW, graphY);
                    p.endShape(p.CLOSE);
                }

                // v-t line (full)
                p.stroke(COLORS.primary);
                p.strokeWeight(2);
                p.line(graphX, graphY - u * vScale,
                    graphX + graphW, graphY - vMax * vScale);

                // Current point
                var currentX = graphX + (t / duration) * graphW;
                var currentY = graphY - v * vScale;
                p.fill(COLORS.danger);
                p.noStroke();
                p.ellipse(currentX, currentY, 10, 10);

                // Vertical line at current time
                p.stroke(COLORS.danger);
                p.strokeWeight(1);
                p.drawingContext.setLineDash([3, 3]);
                p.line(currentX, graphY, currentX, currentY);
                p.drawingContext.setLineDash([]);

                // Particle animation
                if (params.showParticle !== false) {
                    var s = u * t + 0.5 * a * t * t; // displacement
                    var particleScale = 2; // pixels per meter
                    var particleX = 80 + s * particleScale;
                    var particleY = 80;

                    // Track
                    p.stroke(100);
                    p.strokeWeight(2);
                    p.line(80, particleY, W - 80, particleY);

                    // Particle
                    p.fill(COLORS.success);
                    p.noStroke();
                    p.ellipse(Math.min(particleX, W - 80), particleY, 20, 20);

                    // Displacement arrow
                    p.stroke(COLORS.success);
                    p.strokeWeight(2);
                    p.line(80, particleY + 30, Math.min(particleX, W - 80), particleY + 30);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.textAlign(p.CENTER);
                    p.text('s = ' + s.toFixed(1) + ' m', (80 + Math.min(particleX, W - 80)) / 2, particleY + 45);
                }

                // Calculations
                var displacement = u * t + 0.5 * a * t * t;
                var area = displacement; // Area under v-t curve

                var panelY = H - 80;
                p.fill(isDark() ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)');
                p.noStroke();
                p.rect(20, panelY, W - 40, 70, 8);

                p.fill(getTextColor());
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Time: ' + t.toFixed(1) + ' s', 30, panelY + 20);
                p.text('Velocity: v = u + at = ' + u + ' + ' + a + ' × ' + t.toFixed(1) + ' = ' + v.toFixed(1) + ' m/s', 30, panelY + 38);

                p.fill(COLORS.success);
                p.textStyle(p.BOLD);
                p.textSize(12);
                p.text('Area under curve = Displacement = ' + area.toFixed(1) + ' m', 30, panelY + 58);
                p.textStyle(p.NORMAL);

                // Play/Pause
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 47);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 35 && p.mouseY < 60) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    /**
     * Position-Time Comparison
     * Two children returning home
     * Type: 'position-time-comparison'
     */
    function positionTimeComparison(containerEl, params) {
        var childA = params.childA || { distance: 400, startTime: 0, speed: 2, name: 'Child A' };
        var childB = params.childB || { distance: 600, startTime: 50, speed: 4, name: 'Child B' };

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var playing = true;
            var maxTime = Math.max(childA.distance / childA.speed,
                childB.startTime + childB.distance / childB.speed);

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 450;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                if (playing) {
                    t += 1;
                    if (t > maxTime) t = 0;
                }

                p.background(getBg());

                // Title
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.CENTER);
                p.textSize(14);
                p.textStyle(p.BOLD);
                p.text('Position-Time Graph: Two Children Returning Home', W / 2, 20);
                p.textStyle(p.NORMAL);

                // x-t graph
                var graphX = 80;
                var graphY = H - 120;
                var graphW = W - 160;
                var graphH = 200;

                // Axes
                p.stroke(getTextColor());
                p.strokeWeight(2);
                p.line(graphX, graphY, graphX + graphW, graphY); // t-axis
                p.line(graphX, graphY, graphX, graphY - graphH); // x-axis

                // Labels
                p.fill(getTextColor());
                p.noStroke();
                p.textSize(11);
                p.textAlign(p.CENTER);
                p.text('Time (s)', graphX + graphW / 2, graphY + 25);
                p.textAlign(p.RIGHT);
                p.text('Distance (m)', graphX - 10, graphY - graphH - 10);

                // Calculate positions
                var xA = t >= childA.startTime ? Math.min(childA.speed * (t - childA.startTime), childA.distance) : 0;
                var xB = t >= childB.startTime ? Math.min(childB.speed * (t - childB.startTime), childB.distance) : 0;

                var maxDist = Math.max(childA.distance, childB.distance);
                var xScale = graphH / maxDist;
                var tScale = graphW / maxTime;

                // Child A line
                p.stroke(COLORS.primary);
                p.strokeWeight(2);
                p.line(graphX + childA.startTime * tScale, graphY,
                    graphX + (childA.startTime + childA.distance / childA.speed) * tScale,
                    graphY - childA.distance * xScale);

                // Child B line
                p.stroke(COLORS.accent);
                p.line(graphX + childB.startTime * tScale, graphY,
                    graphX + (childB.startTime + childB.distance / childB.speed) * tScale,
                    graphY - childB.distance * xScale);

                // Current points
                p.fill(COLORS.primary);
                p.noStroke();
                p.ellipse(graphX + t * tScale, graphY - xA * xScale, 10, 10);

                p.fill(COLORS.accent);
                p.ellipse(graphX + t * tScale, graphY - xB * xScale, 10, 10);

                // Animation (children walking)
                var animY = 80;
                var animScale = (W - 160) / maxDist;

                // Path
                p.stroke(100);
                p.strokeWeight(2);
                p.line(80, animY, W - 80, animY);

                // School
                p.fill(150);
                p.noStroke();
                p.rect(75, animY - 15, 10, 30);
                p.fill(getTextColor());
                p.textSize(9);
                p.textAlign(p.CENTER);
                p.text('School', 80, animY + 35);

                // Child A
                p.fill(COLORS.primary);
                p.ellipse(80 + xA * animScale, animY, 15, 15);
                p.fill(255);
                p.textSize(10);
                p.text('A', 80 + xA * animScale, animY + 4);

                // Child B
                p.fill(COLORS.accent);
                p.ellipse(80 + xB * animScale, animY, 15, 15);
                p.fill(255);
                p.text('B', 80 + xB * animScale, animY + 4);

                // Info
                p.fill(getTextColor());
                p.noStroke();
                p.textAlign(p.LEFT);
                p.textSize(11);
                p.text('Time: ' + t.toFixed(0) + ' s', 30, H - 80);
                p.fill(COLORS.primary);
                p.text('Child A: ' + xA.toFixed(0) + ' m (speed: ' + childA.speed + ' m/s)', 30, H - 60);
                p.fill(COLORS.accent);
                p.text('Child B: ' + xB.toFixed(0) + ' m (speed: ' + childB.speed + ' m/s)', 30, H - 40);

                // Play/Pause
                p.fill(playing ? COLORS.success : COLORS.danger);
                p.noStroke();
                p.rect(W - 50, 35, 40, 25, 4);
                p.fill(255);
                p.textAlign(p.CENTER, p.CENTER);
                p.textSize(10);
                p.text(playing ? '❚❚' : '▶', W - 30, 47);
            };

            p.mousePressed = function () {
                if (p.mouseX > W - 50 && p.mouseX < W - 10 && p.mouseY > 35 && p.mouseY < 60) {
                    playing = !playing;
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  CHAPTER 3: MOTION IN A PLANE
    // =====================================================

    /**
     * Vector Addition Interactive
     * Drag-and-drop vectors to visualize addition
     * Type: 'vector-addition'
     */
    function vectorAddition(containerEl, params) {
        var vectors = params.vectors || [
            { id: 'a', magnitude: 5, angle: 0, color: COLORS.primary, label: 'a⃗' },
            { id: 'b', magnitude: 3, angle: 60, color: COLORS.accent, label: 'b⃗' }
        ];
        var showResultant = params.show_resultant !== false;
        var showComponents = params.show_components || false;
        var method = params.method || 'triangle'; // 'triangle', 'parallelogram', 'component'

        return new p5(function (p) {
            var W, H;
            var t = 0;
            var draggingVector = null;

            p.setup = function () {
                W = containerEl.offsetWidth || 600;
                H = params.height || 400;
                p.createCanvas(W, H);
                p.frameRate(30);
            };

            p.draw = function () {
                t += 0.02;
                p.background(getBg());
                drawGrid(p, 30);

                var originX = W / 2;
                var originY = H / 2;
                var scale = 30; // pixels per unit

                // Draw axes
                drawAxes(p, originX, originY, 'x', 'y');

                // Calculate resultant
                var resultantX = 0, resultantY = 0;
                for (var i = 0; i < vectors.length; i++) {
                    var v = vectors[i];
                    var rad = v.angle * Math.PI / 180;
                    resultantX += v.magnitude * Math.cos(rad);
                    resultantY += v.magnitude * Math.sin(rad);
                }

                // Draw based on method
                if (method === 'triangle') {
                    // Draw vectors head-to-tail
                    var currentX = originX;
                    var currentY = originY;

                    for (var i = 0; i < vectors.length; i++) {
                        var v = vectors[i];
                        var rad = v.angle * Math.PI / 180;
                        var endX = currentX + v.magnitude * Math.cos(rad) * scale;
                        var endY = currentY - v.magnitude * Math.sin(rad) * scale;

                        drawVector(p, currentX, currentY,
                            v.magnitude * Math.cos(rad) * scale,
                            -v.magnitude * Math.sin(rad) * scale,
                            v.color, v.label, 1);

                        currentX = endX;
                        currentY = endY;
                    }

                    // Draw resultant from origin to final position
                    if (showResultant) {
                        drawVector(p, originX, originY,
                            resultantX * scale, -resultantY * scale,
                            COLORS.success, 'R⃗', 1);

                        // Dashed line back to origin
                        p.stroke(getGridColor());
                        p.strokeWeight(1);
                        drawDashedLine(p, currentX, currentY, originX, originY);
                    }
                } else if (method === 'parallelogram' && vectors.length === 2) {
                    // Draw both vectors from origin
                    var v1 = vectors[0];
                    var v2 = vectors[1];
                    var rad1 = v1.angle * Math.PI / 180;
                    var rad2 = v2.angle * Math.PI / 180;

                    var end1X = originX + v1.magnitude * Math.cos(rad1) * scale;
                    var end1Y = originY - v1.magnitude * Math.sin(rad1) * scale;
                    var end2X = originX + v2.magnitude * Math.cos(rad2) * scale;
                    var end2Y = originY - v2.magnitude * Math.sin(rad2) * scale;

                    drawVector(p, originX, originY,
                        v1.magnitude * Math.cos(rad1) * scale,
                        -v1.magnitude * Math.sin(rad1) * scale,
                        v1.color, v1.label, 1);

                    drawVector(p, originX, originY,
                        v2.magnitude * Math.cos(rad2) * scale,
                        -v2.magnitude * Math.sin(rad2) * scale,
                        v2.color, v2.label, 1);

                    // Complete parallelogram
                    p.stroke(getGridColor());
                    p.strokeWeight(1);
                    drawDashedLine(p, end1X, end1Y, end1X + end2X - originX, end1Y + end2Y - originY);
                    drawDashedLine(p, end2X, end2Y, end1X + end2X - originX, end1Y + end2Y - originY);

                    // Resultant (diagonal)
                    if (showResultant) {
                        drawVector(p, originX, originY,
                            resultantX * scale, -resultantY * scale,
                            COLORS.success, 'R⃗', 1);
                    }
                }

                // Show resultant magnitude and angle
                if (showResultant) {
                    var resultantMag = Math.sqrt(resultantX * resultantX + resultantY * resultantY);
                    var resultantAngle = Math.atan2(resultantY, resultantX) * 180 / Math.PI;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.text('|R⃗| = ' + resultantMag.toFixed(2) + ' units', 10, H - 40);
                    p.text('θ = ' + resultantAngle.toFixed(1) + '°', 10, H - 25);
                }

                // Show components
                if (showComponents) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.textSize(11);
                    p.text('Rₓ = ' + resultantX.toFixed(2), 10, H - 10);
                    p.text('Rᵧ = ' + resultantY.toFixed(2), 100, H - 10);
                }

                // Title
                if (params.title) {
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text(params.title, W / 2, 20);
                    p.textStyle(p.NORMAL);
                }

                // Method selector
                var methods = ['triangle', 'parallelogram'];
                for (var i = 0; i < methods.length; i++) {
                    var btnX = W - 150 + i * 70;
                    var btnY = 10;
                    var isActive = method === methods[i];

                    p.fill(isActive ? COLORS.primary : getGridColor());
                    p.noStroke();
                    p.rect(btnX, btnY, 65, 25, 4);

                    p.fill(255);
                    p.textAlign(p.CENTER, p.CENTER);
                    p.textSize(9);
                    p.text(methods[i], btnX + 32, btnY + 12);
                }
            };

            p.mousePressed = function () {
                // Check method buttons
                var methods = ['triangle', 'parallelogram'];
                for (var i = 0; i < methods.length; i++) {
                    var btnX = W - 150 + i * 70;
                    var btnY = 10;
                    if (p.mouseX > btnX && p.mouseX < btnX + 65 && p.mouseY > btnY && p.mouseY < btnY + 25) {
                        method = methods[i];
                    }
                }
            };
        }, containerEl);
    }

    // =====================================================
    //  PUBLIC API
    // =====================================================

    /**
     * Main render function
     * @param {HTMLElement} containerEl - Container element
     * @param {string} type - Sketch type
     * @param {object} params - Parameters for the sketch
     */
    function render(containerEl, type, params) {
        params = params || {};


        /**
         * Displacement Comparison (Q3.8)
         * Comparing different paths between same two points
         */
        function displacementComparison(containerEl, params) {
            var radius = params.radius || 200;
            var startLabel = params.start_point || 'P';
            var endLabel = params.end_point || 'Q';
            var paths = params.paths || [];

            return new p5(function (p) {
                var W, H;
                var t = 0;
                var playing = true;
                var cycleTime = 10; // 10 seconds per cycle

                p.setup = function () {
                    W = containerEl.offsetWidth || 600;
                    H = 500;
                    p.createCanvas(W, H);
                    p.frameRate(30);
                    p.textSize(14);
                };

                p.draw = function () {
                    p.background(getBg());

                    // Centered coordinates
                    var cx = W / 2;
                    var cy = H / 2;
                    var scale = Math.min(W, H) / (radius * 2.5);

                    if (playing) {
                        t += 1 / 30;
                        if (t > cycleTime) t = 0;
                    }
                    var progress = Math.min(t / (cycleTime * 0.8), 1); // Stay at end for 20% time

                    // Title
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.text('Displacement vs Path Length', cx, 30);

                    // Draw Ground/Circle reference
                    p.noFill();
                    p.stroke(isDark() ? 50 : 200);
                    p.strokeWeight(1);
                    p.ellipse(cx, cy, radius * 2 * scale);

                    // Start/End points
                    var startX = cx - radius * scale;
                    var endX = cx + radius * scale;
                    var startY = cy;
                    var endY = cy;

                    // Points labels
                    p.fill(getTextColor());
                    p.noStroke();
                    p.text(startLabel, startX - 20, startY);
                    p.text(endLabel, endX + 20, endY);
                    p.fill(COLORS.text);
                    p.ellipse(startX, startY, 5, 5);
                    p.ellipse(endX, endY, 5, 5);

                    // Displacement Vector (Straight line P->Q)
                    if (params.show_displacement) {
                        drawArrow(p, startX, startY + 20, endX, endY + 20, COLORS.success, 2);
                        p.fill(COLORS.success);
                        p.noStroke();
                        p.textAlign(p.CENTER);
                        p.text('Displacement Δx', cx, cy + 40);
                    }

                    // Draw Paths and Particles
                    paths.forEach(function (path, index) {
                        var col = path.color || COLORS.primary;
                        p.stroke(col);
                        p.strokeWeight(2);
                        p.noFill();

                        // Calculate position based on path type
                        var curX, curY;
                        var pathLen = 0;

                        if (path.type === 'straight') {
                            // Straight diameter
                            p.line(startX, startY, endX, endY);
                            pathLen = 2 * radius;

                            curX = p.lerp(startX, endX, progress);
                            curY = p.lerp(startY, endY, progress);
                        }
                        else if (path.type === 'arc') {
                            // Semi-circle arc
                            p.arc(cx, cy, radius * 2 * scale, radius * 2 * scale, p.PI, p.TWO_PI);
                            pathLen = p.PI * radius;

                            var angle = p.PI + progress * p.PI;
                            curX = cx + radius * scale * p.cos(angle);
                            curY = cy + radius * scale * p.sin(angle);
                        }
                        else if (path.type === 'curved' && path.control_points) {
                            // Bezier curve
                            var cp1 = path.control_points[0];
                            var cp2 = path.control_points[1];
                            // Convert relative control points to screen coords
                            var cp1x = cx + cp1[0] * scale;
                            var cp1y = cy + cp1[1] * scale;
                            var cp2x = cx + cp2[0] * scale;
                            var cp2y = cy + cp2[1] * scale;

                            p.bezier(startX, startY, cp1x, cp1y, cp2x, cp2y, endX, endY);
                            // Approximate length (simplified)
                            pathLen = 2 * radius * 1.5; // Placeholder for bezier length

                            var bx = p.bezierPoint(startX, cp1x, cp2x, endX, progress);
                            var by = p.bezierPoint(startY, cp1y, cp2y, endY, progress);
                            curX = bx;
                            curY = by;
                        }

                        // Draw Particle
                        p.fill(col);
                        p.noStroke();
                        p.ellipse(curX, curY, 10, 10);
                        p.text(path.label ? path.label.split(' ')[1] : '', curX, curY - 15);

                        // Stats
                        var yPos = H - 100 + index * 20;
                        p.fill(col);
                        p.textAlign(p.LEFT);
                        p.text(path.label + ': Path Length ≈ ' + Math.round(pathLen) + ' m', 20, yPos);
                    });

                    p.fill(COLORS.success);
                    p.text('Displacement Magnitude: ' + (radius * 2) + ' m (Same for all)', 20, H - 20);
                };
            }, containerEl);
        }

        /**
         * Sequential Path (Q3.9)
         * Single path composed of segments (e.g. O->P->Q->O)
         */
        function sequentialPath(containerEl, params) {
            var radius = params.radius || 1000;
            var segments = params.segments || [];
            var totalTime = params.total_time || 10;

            return new p5(function (p) {
                var W, H;
                var t = 0;
                var playing = true;

                p.setup = function () {
                    W = containerEl.offsetWidth || 600;
                    H = 500;
                    p.createCanvas(W, H);
                    p.frameRate(30);
                };

                p.draw = function () {
                    p.background(getBg());
                    var cx = W / 2;
                    var cy = H / 2;
                    var scale = Math.min(W, H) / (radius * 2.5);

                    if (playing) {
                        t += 0.05;
                        if (t > totalTime + 1) t = 0;
                    }
                    var timeProgress = Math.min(t / totalTime, 1);

                    // Draw Path
                    p.stroke(isDark() ? 50 : 200);
                    p.noFill();
                    p.ellipse(cx, cy, radius * 2 * scale); // Park boundary
                    p.fill(getTextColor());
                    p.text('O', cx - 10, cy + 10);

                    // Calculate total path length for normalization
                    var totalLen = 0;
                    // Simplified: Assuming 3 segments: Radial, Arc, Radial
                    // This is hardcoded for Q3.9 structure for stability
                    var len1 = radius; // O->P
                    var len2 = (p.PI * radius) / 2; // Arc P->Q (90 deg)
                    var len3 = radius; // Q->O
                    totalLen = len1 + len2 + len3;

                    var curDist = totalLen * timeProgress;
                    var px = cx, py = cy; // Start at O

                    // Segment 1: O -> P
                    p.stroke(COLORS.primary);
                    p.strokeWeight(3);
                    var pX = cx + radius * scale;
                    var pY = cy;
                    p.line(cx, cy, pX, pY);
                    p.noStroke(); p.fill(getTextColor()); p.text('P', pX + 10, pY);

                    // Segment 2: Arc P -> Q
                    p.stroke(COLORS.accent);
                    p.strokeWeight(3);
                    p.noFill();
                    p.arc(cx, cy, radius * 2 * scale, radius * 2 * scale, 0, p.HALF_PI); // 0 to 90
                    var qX = cx;
                    var qY = cy + radius * scale;
                    p.noStroke(); p.fill(getTextColor()); p.text('Q', qX, qY + 20);

                    // Segment 3: Q -> O
                    p.stroke(COLORS.success);
                    p.strokeWeight(3);
                    p.line(qX, qY, cx, cy);

                    // Animate Particle
                    var particleX, particleY;
                    if (curDist <= len1) {
                        // Moving O->P
                        var prog = curDist / len1;
                        particleX = p.lerp(cx, pX, prog);
                        particleY = p.lerp(cy, pY, prog);
                    } else if (curDist <= len1 + len2) {
                        // Moving Arc P->Q
                        var prog = (curDist - len1) / len2;
                        var ang = prog * p.HALF_PI;
                        particleX = cx + radius * scale * p.cos(ang);
                        particleY = cy + radius * scale * p.sin(ang);
                    } else {
                        // Moving Q->O
                        var prog = (curDist - len1 - len2) / len3;
                        particleX = p.lerp(qX, cx, prog);
                        particleY = p.lerp(qY, cy, prog);
                    }

                    // Draw Particle
                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.ellipse(particleX, particleY, 12, 12);

                    // Draw Displacement Vector (O -> Particle)
                    if (curDist < totalLen) {
                        drawArrow(p, cx, cy, particleX, particleY, COLORS.warning, 2);
                    }

                    // Stats
                    var panelY = H - 60;
                    p.fill(getTextColor());
                    p.textAlign(p.LEFT);
                    p.text('Time: ' + t.toFixed(1) + ' / ' + totalTime + ' m', 20, panelY);
                    p.text('Displacement: ' + p.dist(cx, cy, particleX, particleY).toFixed(0) + ' units', 20, panelY + 20);
                    p.text('Path Length: ' + curDist.toFixed(0) + ' units', 200, panelY + 20);
                };
            }, containerEl);
        }

        /**
         * Polygon Path (Q3.10)
         * Generative path based on turns
         */
        function polygonPath(containerEl, params) {
            var segLen = params.segment_length || 500;
            var turnAngle = params.turn_angle || 60;
            var numSegs = params.num_segments || 8;

            return new p5(function (p) {
                var W, H;
                var t = 0;
                var vertices = [];

                p.setup = function () {
                    W = containerEl.offsetWidth || 600;
                    H = 500;
                    p.createCanvas(W, H);
                    p.frameRate(30);

                    // Precompute vertices
                    var x = 0, y = 0;
                    var ang = 0;
                    vertices.push({ x: x, y: y });
                    for (var i = 0; i < numSegs; i++) {
                        x += segLen * p.cos(p.radians(ang));
                        y += segLen * p.sin(p.radians(ang));
                        vertices.push({ x: x, y: y });
                        ang += turnAngle;
                    }
                };

                p.draw = function () {
                    p.background(getBg());
                    var cx = W / 2 - 100; // Offset center
                    var cy = H / 2 - 100;
                    var scale = 0.3; // Scale down to fit

                    t += 0.05;
                    if (t > numSegs) t = 0;

                    // Draw static path
                    p.stroke(isDark() ? 100 : 200);
                    p.strokeWeight(1);
                    p.noFill();
                    p.beginShape();
                    for (var i = 0; i < vertices.length; i++) {
                        p.vertex(cx + vertices[i].x * scale, cy + vertices[i].y * scale);
                    }
                    p.endShape();

                    // Draw active segments
                    var currentSegIndex = Math.floor(t);
                    var segProgress = t % 1;

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.beginShape();
                    for (var i = 0; i <= currentSegIndex; i++) {
                        p.vertex(cx + vertices[i].x * scale, cy + vertices[i].y * scale);
                    }
                    p.endShape();

                    // Current Pos
                    var p1 = vertices[currentSegIndex];
                    var p2 = vertices[Math.min(currentSegIndex + 1, vertices.length - 1)];
                    var curX = cx + p.lerp(p1.x, p2.x, segProgress) * scale;
                    var curY = cy + p.lerp(p1.y, p2.y, segProgress) * scale;

                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.ellipse(curX, curY, 8, 8);

                    // Displacement Vector
                    drawArrow(p, cx, cy, curX, curY, COLORS.success, 2);

                    // Stats
                    var dispMag = p.dist(cx, cy, curX, curY) / scale;
                    var pathL = t * segLen;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.LEFT);
                    p.text('Turn: ' + (currentSegIndex + 1) + ' / ' + numSegs, 20, H - 60);
                    p.text('Displacement: ' + Math.round(dispMag) + ' m', 20, H - 40);
                    p.text('Path Length: ' + Math.round(pathL) + ' m', 200, H - 40);
                    p.text('Angle: ' + ((currentSegIndex) * turnAngle) + '°', 200, H - 60);
                };
            }, containerEl);
        }

        /**
         * Projectile Motion (General/Q3.12)
         */
        function projectileMotion(containerEl, params) {
            var v0 = params.initial_velocity || 40;
            var angle = params.launch_angle || 45;
            var g = params.gravity || 9.8;
            var ceilingY = params.ceiling_height || null; // In meters

            return new p5(function (p) {
                var W, H;
                var t = 0;
                var playing = false;
                var points = [];
                var hitCeiling = false;

                p.setup = function () {
                    W = containerEl.offsetWidth || 600;
                    H = 400;
                    p.createCanvas(W, H);

                    // Add controls
                    var controlsDiv = document.createElement('div');
                    controlsDiv.style.marginTop = '10px';
                    controlsDiv.innerHTML = `
                    <label>Angle: <input type="range" min="0" max="90" value="${angle}" id="angleSlider"></label>
                    <span id="angleVal">${angle}°</span>
                    <button id="fireBtn" style="margin-left:10px;">Fire</button>
                    <button id="resetBtn">Reset</button>
                `;
                    containerEl.appendChild(controlsDiv);

                    containerEl.querySelector('#angleSlider').oninput = function (e) {
                        angle = parseFloat(e.target.value);
                        containerEl.querySelector('#angleVal').innerText = angle + '°';
                        reset();
                    };
                    containerEl.querySelector('#fireBtn').onclick = function () { playing = true; };
                    containerEl.querySelector('#resetBtn').onclick = reset;
                };

                function reset() {
                    t = 0;
                    playing = false;
                    points = [];
                    hitCeiling = false;
                }

                p.draw = function () {
                    p.background(getBg());
                    var scale = 4; // pixels per meter
                    var originX = 50;
                    var originY = H - 50;

                    // Draw Ceiling
                    if (ceilingY) {
                        var ceilYPix = originY - ceilingY * scale;
                        p.stroke(COLORS.danger);
                        p.strokeWeight(2);
                        p.line(0, ceilYPix, W, ceilYPix);
                        p.noStroke();
                        p.fill(COLORS.danger);
                        p.text('Ceiling (25m)', 10, ceilYPix - 5);
                    }

                    // Ground
                    p.stroke(isDark() ? 200 : 50);
                    p.line(0, originY, W, originY);

                    if (playing && !hitCeiling) {
                        t += 0.1;
                    }

                    // Physics
                    var rad = p.radians(angle);
                    var vx = v0 * p.cos(rad);
                    var vy = v0 * p.sin(rad) - g * t;

                    // Position physics
                    var x = v0 * p.cos(rad) * t;
                    var y = v0 * p.sin(rad) * t - 0.5 * g * t * t;

                    // Ceiling check
                    if (ceilingY && y >= ceilingY) {
                        y = ceilingY;
                        hitCeiling = true; // Stop or bounce
                        playing = false; // Stop for this demo
                        p.fill(COLORS.danger);
                        p.text('HIT CEILING!', W / 2, H / 2);
                    }

                    // Ground check
                    if (y < 0 && t > 0.1) {
                        y = 0;
                        playing = false;
                    }

                    // Store point
                    if (playing || points.length === 0) {
                        points.push({ x: originX + x * scale, y: originY - y * scale });
                    }

                    // Draw Trajectory
                    p.noFill();
                    p.stroke(COLORS.primary);
                    p.beginShape();
                    points.forEach(pt => p.vertex(pt.x, pt.y));
                    p.endShape();

                    // Draw Projectile
                    var curX = originX + x * scale;
                    var curY = originY - y * scale;
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.ellipse(curX, curY, 10, 10);

                    // Stats
                    p.fill(getTextColor());
                    p.text('Range: ' + x.toFixed(1) + ' m', 20, 30);
                    p.text('Height: ' + y.toFixed(1) + ' m', 150, 30);
                    p.text('Time: ' + t.toFixed(1) + ' s', 280, 30);
                };
            }, containerEl);
        }

        // --- Chapter 4: Laws of Motion Sketches ---

        function trainDrop(containerEl, params) {
            params = params || {};
            return new p5(function (p) {
                var trainX = 50;
                var trainSpeed = params.speed || 3;
                var dropped = false;
                var stone = { x: 0, y: 0, vx: 0, vy: 0 };
                var groundY = 250;
                var path = [];
                var viewFrame = 'Ground';

                p.setup = function () {
                    p.createCanvas(600, 350);
                    createControls();
                };

                function createControls() {
                    var controlsDiv = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createButton('Drop Stone').parent(controlsDiv).mousePressed(function () {
                        if (!dropped) {
                            dropped = true;
                            stone.x = trainX + 60;
                            stone.y = 100;
                            stone.vx = trainSpeed;
                            stone.vy = 0;
                            path = [];
                        }
                    });
                    p.createButton('Reset').parent(controlsDiv).style('margin-left', '10px').mousePressed(function () {
                        dropped = false;
                        trainX = 50;
                        path = [];
                    });
                    p.createButton('Toggle View').parent(controlsDiv).style('margin-left', '10px').mousePressed(function () {
                        viewFrame = viewFrame === 'Ground' ? 'Train' : 'Ground';
                    });
                }

                p.draw = function () {
                    p.background(getBg());

                    if (!dropped || stone.y < groundY) {
                        trainX += trainSpeed;
                        if (trainX > p.width + 200) trainX = -150;
                    }

                    if (dropped && stone.y < groundY) {
                        stone.x += stone.vx;
                        stone.vy += 0.2;
                        stone.y += stone.vy;
                        path.push({ x: stone.x, y: stone.y });
                    }

                    p.push();
                    if (viewFrame === 'Train') {
                        p.translate(-trainX + 250, 0);
                        p.background(getBg()); // Clear again relative
                    }

                    // Ground
                    p.noStroke();
                    p.fill(isDark() ? 80 : 120);
                    p.rect(-5000, groundY + 40, 10000, 50);

                    // Train
                    p.fill(COLORS.primary);
                    p.rect(trainX, 60, 150, 80, 5);
                    p.fill(220);
                    p.rect(trainX + 40, 70, 40, 40);
                    p.fill(50);
                    p.ellipse(trainX + 30, 140, 30, 30);
                    p.ellipse(trainX + 120, 140, 30, 30);

                    // Stone & Path
                    p.noFill();
                    p.stroke(COLORS.accent);
                    p.strokeWeight(2);
                    p.beginShape();
                    for (var i = 0; i < path.length; i++) {
                        p.vertex(path[i].x, path[i].y);
                    }
                    p.endShape();

                    if (dropped) {
                        p.fill(COLORS.accent);
                        p.noStroke();
                        p.ellipse(stone.x, stone.y, 20, 20);
                    }
                    p.pop();

                    // Overlay Info
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(14);
                    p.text('View Frame: ' + viewFrame, 10, 20);
                    if (viewFrame === 'Train') p.text('Stone falls vertically relative to train', 10, 40);
                    else p.text('Stone follows parabola relative to ground (Inertia)', 10, 40);
                };
            }, containerEl);
        }

        function pendulumCut(containerEl, params) {
            return new p5(function (p) {
                var angle = 0, aVel = 0, r = 150;
                var origin = { x: 300, y: 50 };
                var bob = { x: 0, y: 0 }, bobVel = { x: 0, y: 0 };
                var cut = false, gravity = 0.4;

                p.setup = function () { p.createCanvas(600, 400); angle = Math.PI / 4; createUI(); };

                function createUI() {
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createButton('Cut String').parent(div).mousePressed(function () {
                        if (!cut) {
                            cut = true;
                            var vTan = r * aVel;
                            // Tangential velocity: vx = r*θ̇*cos(θ), vy = -r*θ̇*sin(θ) (y increases downward)
                            bobVel.x = vTan * Math.cos(angle);
                            bobVel.y = -vTan * Math.sin(angle);
                        }
                    });
                    p.createButton('Reset').parent(div).style('margin-left', '10px').mousePressed(function () {
                        cut = false; angle = Math.PI / 4; aVel = 0;
                    });
                }

                p.draw = function () {
                    p.background(getBg());
                    if (!cut) {
                        var acc = -0.01 * Math.sin(angle);
                        aVel += acc; aVel *= 0.995; angle += aVel;
                        bob.x = origin.x + r * Math.sin(angle);
                        bob.y = origin.y + r * Math.cos(angle);
                        p.stroke(getAxisColor()); p.line(origin.x, origin.y, bob.x, bob.y);
                    } else {
                        bob.x += bobVel.x; bobVel.y += gravity; bob.y += bobVel.y;
                    }
                    p.fill(COLORS.accent); p.noStroke(); p.ellipse(bob.x, bob.y, 30, 30);

                    // Velocity Vector (tangential: vx = r·θ̇·cos(θ), vy = -r·θ̇·sin(θ))
                    var vx = cut ? bobVel.x * 10 : (r * aVel * Math.cos(angle) * 10);
                    var vy = cut ? bobVel.y * 10 : (-r * aVel * Math.sin(angle) * 10);
                    drawArrow(p, bob.x, bob.y, vx, vy, COLORS.primary);

                    p.fill(getTextColor()); p.noStroke();
                    p.text(cut ? 'String Cut!' : 'Oscillating...', 10, 20);
                    if (cut) p.text(Math.abs(bobVel.x) < 0.5 ? 'Vertical Fall (Free Fall)' : 'Parabolic Trajectory (Projectile)', 10, 40);
                };

                function drawArrow(p, x, y, dx, dy, c) {
                    p.push(); p.stroke(c); p.fill(c); p.translate(x, y); p.line(0, 0, dx, dy);
                    p.rotate(Math.atan2(dy, dx)); p.translate(p.dist(0, 0, dx, dy), 0);
                    p.triangle(0, 0, -5, 3, -5, -3); p.pop();
                }
            }, containerEl);
        }

        function liftApparentWeight(containerEl, params) {
            return new p5(function (p) {
                var liftY = 200, vel = 0, acc = 0, mass = 70, g = 10;
                var scenario = 'stationary';

                p.setup = function () { p.createCanvas(600, 400); createUI(); };

                function createUI() {
                    var d = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    var s = p.createSelect().parent(d);
                    s.option('Stationary', 'stationary');
                    s.option('Acc Up (+5)', 'up');
                    s.option('Acc Down (-5)', 'down');
                    s.option('Free Fall', 'fall');
                    s.changed(function () { scenario = s.value(); reset(); });
                    reset(); // Initialize state for default 'stationary' scenario
                }

                function reset() {
                    liftY = 200; vel = 0;
                    if (scenario === 'stationary') acc = 0;
                    if (scenario === 'up') acc = -0.1;
                    if (scenario === 'down') acc = 0.1;
                    if (scenario === 'fall') acc = 0.2;
                }

                p.draw = function () {
                    p.background(getBg());
                    if (scenario !== 'stationary') {
                        vel += acc; liftY += vel;
                        if (liftY < 50 || liftY > 350) { liftY = 200; vel = 0; }
                    }

                    var physA = (scenario === 'up') ? 5 : (scenario === 'down' ? -5 : (scenario === 'fall' ? -10 : 0));
                    var normal = mass * (g + physA);
                    if (normal < 0) normal = 0;

                    p.stroke(getAxisColor()); p.noFill(); p.rect(200, liftY, 200, 250); // Lift
                    p.fill(isDark() ? 80 : 120); p.noStroke(); p.rect(280, liftY + 240, 40, 10); // Scale
                    // Person
                    p.stroke(getAxisColor()); p.line(300, liftY + 240, 300, liftY + 160);
                    p.circle(300, liftY + 140, 30);
                    p.line(300, liftY + 180, 280, liftY + 210); p.line(300, liftY + 180, 320, liftY + 210);
                    p.line(300, liftY + 240, 280, liftY + 280); p.line(300, liftY + 240, 320, liftY + 280);

                    // Dashboard
                    p.noStroke(); p.fill(getTextColor());
                    p.text('Acc (a): ' + physA + ' m/s²', 450, 50);
                    p.text('Weight (mg): 700 N', 450, 70);
                    p.text('Normal (N): ' + normal + ' N', 450, 90);
                    p.text('Scale Reading: ' + (normal / 10) + ' kg', 450, 110);

                    // Vectors
                    drawVec(p, 300, liftY + 160, 0, 60, 'mg', COLORS.primary);
                    drawVec(p, 300, liftY + 240, 0, -p.map(normal, 0, 1400, 0, 120), 'N', COLORS.accent);
                };

                function drawVec(p, x, y, dx, dy, l, c) {
                    if (Math.abs(dy) < 1) return;
                    p.push(); p.stroke(c); p.strokeWeight(3); p.line(x, y, x + dx, y + dy);
                    p.translate(x + dx, y + dy); p.rotate(Math.atan2(dy, dx));
                    p.fill(c); p.triangle(0, 0, -6, 3, -6, -3); p.noStroke(); p.text(l, 10, 0); p.pop();
                }
            }, containerEl);
        }

        function atwoodsMachine(containerEl, params) {
            return new p5(function (p) {
                var m1 = 10, m2 = 20, y1 = 150, y2 = 150, v = 0, active = false;
                var s1, s2;

                p.setup = function () { p.createCanvas(600, 400); createUI(); };

                function reset() {
                    active = false;
                    y1 = 150; y2 = 150; v = 0;
                    if (s1 && s2) { m1 = Number(s1.value()); m2 = Number(s2.value()); }
                }

                function createUI() {
                    var d = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createSpan('M1: ').parent(d);
                    s1 = p.createSlider(1, 50, 10).parent(d).input(function () { if (!active) m1 = Number(this.value()); });
                    p.createSpan(' M2: ').parent(d);
                    s2 = p.createSlider(1, 50, 20).parent(d).input(function () { if (!active) m2 = Number(this.value()); });
                    p.createButton('Start').parent(d).mousePressed(function () { if (!active) active = true; });
                    p.createButton('Reset').parent(d).style('margin-left', '10px').mousePressed(function () { reset(); });
                }

                p.draw = function () {
                    p.background(getBg());
                    var a = ((m2 - m1) / (m1 + m2)) * 9.8;
                    if (active) { v += a * 0.05; y1 -= v; y2 += v; if (y1 < 50 || y2 < 50 || y1 > 350 || y2 > 350) active = false; }

                    p.fill(isDark() ? 100 : 150); p.noStroke(); p.circle(300, 50, 60);
                    p.stroke(getAxisColor()); p.line(270, 50, 270, 50 + y1); p.line(330, 50, 330, 50 + y2);

                    drawMass(p, 270, 50 + y1, m1, 'M1');
                    drawMass(p, 330, 50 + y2, m2, 'M2');

                    p.noStroke(); p.fill(getTextColor());
                    p.text('Acc: ' + a.toFixed(2) + ' m/s²', 20, 20);
                    var T = (2 * m1 * m2 * 9.8) / (m1 + m2);
                    p.text('Tension: ' + T.toFixed(1) + ' N', 20, 40);
                };

                function drawMass(p, x, y, m, l) {
                    var s = Math.sqrt(m) * 10;
                    p.fill(COLORS.primary); p.rect(x - s / 2, y, s, s);
                    p.fill(255); p.textAlign(p.CENTER, p.CENTER); p.text(l, x, y + s / 2);
                }
            }, containerEl);
        }

        // --- Chapter 5: Work, Energy and Power Sketches ---

        function potentialEnergyGraphs(containerEl, params) {
            params = params || {};
            return new p5(function (p) {
                var type = params.initialType || 'well';
                var E = 2.0;
                var sliderE;
                var selectType;

                p.setup = function () {
                    var canvas = p.createCanvas(600, 300);
                    canvas.parent(containerEl);
                    p.textAlign(p.CENTER, p.CENTER);

                    var controls = p.createDiv().parent(containerEl).style('display', 'flex').style('gap', '10px').style('margin-top', '10px');

                    selectType = p.createSelect().parent(controls);
                    selectType.option('Potential Well', 'well');
                    selectType.option('Step Potential', 'step');
                    selectType.option('Harmonic Oscillator', 'harmonic');
                    selectType.selected(type);
                    selectType.changed(function () { type = selectType.value(); });

                    p.createSpan('Total Energy (E):').parent(controls).style('align-self', 'center');
                    sliderE = p.createSlider(0, 5, 2, 0.1).parent(controls);
                };

                p.draw = function () {
                    p.background(getBg());
                    E = sliderE.value();

                    p.push();
                    p.translate(50, 250);
                    var xScale = 40;
                    var yScale = 40;

                    p.stroke(isDark() ? 200 : 50);
                    p.strokeWeight(1);
                    p.line(0, 0, 500, 0);
                    p.line(0, 0, 0, -200);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.text('x', 510, 0);
                    p.text('V(x)', 0, -210);

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();

                    p.beginShape();
                    if (type === 'well') {
                        p.vertex(0, -4 * yScale);
                        p.vertex(3 * xScale, -4 * yScale);
                        p.vertex(3 * xScale, 0);
                        p.vertex(9 * xScale, 0);
                        p.vertex(9 * xScale, -4 * yScale);
                        p.vertex(12 * xScale, -4 * yScale);
                    } else if (type === 'step') {
                        p.vertex(0, 0);
                        p.vertex(6 * xScale, 0);
                        p.vertex(6 * xScale, -3 * yScale);
                        p.vertex(12 * xScale, -3 * yScale);
                    } else if (type === 'harmonic') {
                        for (var x = 0; x <= 12; x += 0.1) {
                            var V = 0.2 * Math.pow(x - 6, 2);
                            p.vertex(x * xScale, -V * yScale);
                        }
                    }
                    p.endShape();

                    p.stroke(COLORS.accent);
                    p.strokeWeight(2);
                    p.line(0, -E * yScale, 500, -E * yScale);
                    p.noStroke();
                    p.fill(COLORS.accent);
                    p.text('E', 510, -E * yScale);

                    p.fill(255, 0, 0, 50);
                    p.noStroke();
                    for (var x = 0; x <= 12; x += 0.1) {
                        var V = 0;
                        if (type === 'well') V = (x >= 3 && x <= 9) ? 0 : 4;
                        else if (type === 'step') V = (x < 6) ? 0 : 3;
                        else if (type === 'harmonic') V = 0.2 * Math.pow(x - 6, 2);

                        if (V > E) {
                            p.rect(x * xScale, -200, xScale * 0.1 + 2, 200);
                        }
                    }

                    p.pop();

                    p.fill(getTextColor());
                    p.textAlign(p.LEFT, p.TOP);
                    p.text('Forbidden Region (V > E)', 400, 20);
                    p.fill(255, 0, 0, 50);
                    p.rect(370, 20, 20, 20);
                };
            }, containerEl);
        }

        function collisionOutcomes(containerEl, params) {
            return new p5(function (p) {
                var scenario = 2;
                var balls = [];
                var running = false;
                var V = 3;

                p.setup = function () {
                    p.createCanvas(600, 250).parent(containerEl);
                    p.textAlign(p.LEFT, p.TOP);
                    reset();

                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    var s = p.createSelect().parent(div);
                    s.option('Scenario i: 1 stops, 2&3 move V/2', 1);
                    s.option('Scenario ii: 1&2 stop, 3 moves V', 2);
                    s.option('Scenario iii: All move V/3', 3);
                    s.selected('2');
                    s.changed(function () { scenario = parseInt(s.value()); reset(); });

                    p.createButton('Start').parent(div).style('margin-left', '10px').mousePressed(function () { if (!running) running = true; else reset(); });
                };

                function reset() {
                    running = false;
                    balls = [
                        { x: 50, y: 125, v: V, label: '1', color: COLORS.primary },
                        { x: 200, y: 125, v: 0, label: '2', color: COLORS.secondary },
                        { x: 240, y: 125, v: 0, label: '3', color: COLORS.accent }
                    ];
                }

                p.draw = function () {
                    p.background(getBg());

                    if (running) {
                        if (balls[0].x + 35 >= balls[1].x) {
                            if (scenario === 1) {
                                balls[0].v = 0; balls[1].v = V / 2; balls[2].v = V / 2;
                            } else if (scenario === 2) {
                                balls[0].v = 0; balls[1].v = 0; balls[2].v = V;
                            } else if (scenario === 3) {
                                balls[0].v = V / 3; balls[1].v = V / 3; balls[2].v = V / 3;
                            }
                        }
                        balls.forEach(b => b.x += b.v);
                    }

                    balls.forEach(b => {
                        p.fill(b.color);
                        p.noStroke();
                        p.circle(b.x, b.y, 40);
                        p.fill(255);
                        p.textAlign(p.CENTER, p.CENTER);
                        p.text(b.label, b.x, b.y);
                    });

                    p.fill(getTextColor());
                    p.textAlign(p.LEFT, p.TOP);
                    p.textSize(14);

                    p.text('Momentum: Conserved (mV)', 10, 10);
                    p.text('Kinetic Energy: ' + (scenario === 2 ? 'Conserved (Elastic)' : 'NOT Conserved (Inelastic)'), 10, 30);

                    if (balls[0].x > 60) {
                        p.fill(scenario === 2 ? COLORS.success : COLORS.error);
                        p.text(scenario === 2 ? 'PHYSICALLY POSSIBLE' : 'VIOLATES ENERGY CONSERVATION', 10, 60);
                    }
                };
            }, containerEl);
        }

        function windmillPower(containerEl, params) {
            return new p5(function (p) {
                var particles = [];
                var v = 0.5;
                var sliderV;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createSpan('Wind Velocity (v): ').parent(div);
                    sliderV = p.createSlider(0.1, 1.0, 0.5, 0.05).parent(div);

                    for (var i = 0; i < 30; i++) particles.push({ x: Math.random() * 600, y: Math.random() * 200 + 50 });
                };

                p.draw = function () {
                    p.background(getBg());
                    v = sliderV.value();

                    p.fill(100, 150, 255, 100);
                    p.noStroke();
                    particles.forEach(pt => {
                        pt.x += v * 10;
                        if (pt.x > 600) pt.x = 0;
                        p.circle(pt.x, pt.y, 3);
                    });

                    p.noFill();
                    p.stroke(COLORS.accent);
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash([5, 5]);
                    p.rect(300 - v * 100, 100, v * 200, 100);
                    p.drawingContext.setLineDash([]);

                    p.noStroke();
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.text('Swept Volume Rate = A·v', 300, 220);
                    p.text('Mass Rate = ρ·A·v', 300, 240);
                    p.text('KE Rate (Power) = ½·(ρAv)·v² = ½ρAv³', 300, 260);

                    p.push();
                    p.translate(500, 150);
                    p.rotate(p.millis() * 0.005 * v);
                    p.fill(200);
                    p.stroke(0);
                    p.strokeWeight(1); // Explicitly reset weight
                    for (var i = 0; i < 3; i++) {
                        p.rotate(p.TWO_PI / 3);
                        p.rect(0, -5, 60, 10, 5);
                    }
                    p.pop();
                };
            }, containerEl);
        }

        // --- Chapter 6: Systems of Particles and Rotational Motion Sketches ---

        function centerOfMassShapes(containerEl, params) {
            return new p5(function (p) {
                var shape = 'Triangle';
                var selectShape;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createSpan('Select Shape: ').parent(div);
                    selectShape = p.createSelect().parent(div);
                    selectShape.option('Triangle');
                    selectShape.option('L-Shape');
                    selectShape.option('T-Shape');
                    selectShape.selected(shape);
                    selectShape.changed(function () { shape = selectShape.value(); });
                };

                p.draw = function () {
                    p.background(getBg());
                    p.translate(300, 150);

                    p.fill(COLORS.primary);
                    p.stroke(255);
                    p.strokeWeight(2);

                    var cmX = 0, cmY = 0;

                    if (shape === 'Triangle') {
                        // Equilateral triangle
                        p.triangle(-50, 50, 50, 50, 0, -50);
                        // CM is at centroid (sum of coords / 3)
                        cmX = (-50 + 50 + 0) / 3;
                        cmY = (50 + 50 - 50) / 3;
                    } else if (shape === 'L-Shape') {
                        // L-shape composed of two rects:
                        // Vertical: 20x100 at x=-40, y=0 (center)
                        // Horizontal: 60x20 at x=0, y=40 (center)
                        p.rectMode(p.CENTER);
                        p.rect(-40, 0, 20, 100);
                        p.rect(0, 40, 60, 20);

                        var m1 = 20 * 100, x1 = -40, y1 = 0;
                        var m2 = 60 * 20, x2 = 0, y2 = 40;
                        cmX = (m1 * x1 + m2 * x2) / (m1 + m2);
                        cmY = (m1 * y1 + m2 * y2) / (m1 + m2);
                    } else if (shape === 'T-Shape') {
                        p.rectMode(p.CENTER);
                        // Top bar: 100x20 at x=0, y=-40
                        // Vert bar: 20x80 at x=0, y=10
                        p.rect(0, -40, 100, 20);
                        p.rect(0, 10, 20, 80);

                        var m1 = 100 * 20, x1 = 0, y1 = -40;
                        var m2 = 20 * 80, x2 = 0, y2 = 10;
                        cmX = (m1 * x1 + m2 * x2) / (m1 + m2);
                        cmY = (m1 * y1 + m2 * y2) / (m1 + m2);
                    }

                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(cmX, cmY, 10);

                    p.fill(getTextColor());
                    p.textAlign(p.LEFT, p.CENTER);
                    p.text('Center of Mass', cmX + 15, cmY);
                };
            }, containerEl);
        }

        function cmVelocityDemo(containerEl, params) {
            return new p5(function (p) {
                var trolleyX = 50;
                var childX = 0; // Relative to trolley
                var v = 1;      // Trolley specific velocity
                var childV = 0; // Child relative velocity
                var running = false;
                var time = 0;

                p.setup = function () {
                    p.createCanvas(600, 200).parent(containerEl);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createButton('Start/Reset').parent(div).mousePressed(function () {
                        if (running) { running = false; trolleyX = 50; childX = 0; time = 0; }
                        else { running = true; }
                    });
                    p.createSpan(' Child Action: ').parent(div);
                    var sel = p.createSelect().parent(div);
                    sel.option('Sit Still', 0);
                    sel.option('Walk Right', 1);
                    sel.option('Walk Left', -1);
                    sel.changed(function () { childV = parseInt(sel.value()); });
                };

                p.draw = function () {
                    p.background(getBg());

                    if (running) {
                        trolleyX += v;
                        childX += childV;
                        if (trolleyX > 650) { trolleyX = -100; }
                    }

                    // Draw Trolley
                    p.fill(COLORS.secondary);
                    p.rect(trolleyX, 150, 100, 20);
                    p.fill(100);
                    p.circle(trolleyX + 20, 170, 15);
                    p.circle(trolleyX + 80, 170, 15);

                    // Draw Child
                    p.fill(COLORS.primary);
                    p.circle(trolleyX + 50 + childX, 140, 20);

                    // CM Calculation (simple model)
                    // Trolley M=100, Child m=20
                    // X_cm = (M*Xt + m*Xc) / (M+m)
                    // Xt is trolley center = trolleyX + 50
                    // Xc is child pos = trolleyX + 50 + childX
                    var M = 100, m = 20;
                    var trolleyCenter = trolleyX + 50;
                    var childPos = trolleyCenter + childX;
                    var cmPos = (M * trolleyCenter + m * childPos) / (M + m);

                    p.fill(COLORS.accent);
                    p.circle(cmPos, 160, 10);
                    p.noStroke();
                    p.fill(getTextColor());
                    p.text('CM', cmPos, 130);

                    p.text('Internal forces (walking) do not change CM velocity.', 10, 20);
                    p.text('CM moves at constant V regardless of child.', 10, 40);
                };
            }, containerEl);
        }

        function momentOfInertiaRace(containerEl, params) {
            return new p5(function (p) {
                var rotation1 = 0, rotation2 = 0;
                var vel1 = 0, vel2 = 0;
                var running = false;
                // Torque = I * alpha => alpha = Torque / I
                // Let Torque = 1
                // I_cyl = mR^2 = 1 (m=1, R=1) => alpha1 = 1
                // I_sph = 0.4 mR^2 = 0.4 => alpha2 = 1/0.4 = 2.5
                var alpha1 = 0.05;
                var alpha2 = 0.05 * 2.5;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    p.textAlign(p.CENTER);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createButton('Start Race').parent(div).mousePressed(function () {
                        running = true; rotation1 = 0; rotation2 = 0; vel1 = 0; vel2 = 0;
                    });
                    p.createButton('Reset').parent(div).style('margin-left', '10px').mousePressed(function () {
                        running = false; rotation1 = 0; rotation2 = 0; vel1 = 0; vel2 = 0;
                    });
                };

                p.draw = function () {
                    p.background(getBg());

                    if (running) {
                        vel1 += alpha1;
                        vel2 += alpha2;
                        rotation1 += vel1;
                        rotation2 += vel2;
                    }

                    // Hollow Cylinder
                    p.push();
                    p.translate(150, 150);
                    p.rotate(rotation1);
                    p.stroke(COLORS.primary);
                    p.strokeWeight(5);
                    p.noFill();
                    p.circle(0, 0, 100);
                    p.strokeWeight(1);
                    p.line(0, 0, 50, 0); // radius line
                    p.pop();
                    p.noStroke();
                    p.fill(getTextColor());
                    p.text('Hollow Cylinder', 150, 220);
                    p.text('I = MR²', 150, 240);
                    p.text('α ∝ 1/I', 150, 260);

                    // Solid Sphere
                    p.push();
                    p.translate(450, 150);
                    p.rotate(rotation2);
                    p.fill(COLORS.secondary);
                    p.noStroke();
                    p.circle(0, 0, 100);
                    p.stroke(255);
                    p.line(0, 0, 50, 0);
                    p.pop();
                    p.fill(getTextColor());
                    p.text('Solid Sphere', 450, 220);
                    p.text('I = 2/5 MR²', 450, 240);
                    p.text('Has smaller I -> Larger α', 450, 260);

                    if (running) {
                        p.fill(COLORS.accent);
                        p.textSize(20);
                        if (rotation2 > rotation1 + 1) p.text('Sphere Leading!', 300, 50);
                    }
                };
            }, containerEl);
        }

        // --- Chapter 7: Gravitation Sketches ---

        function gravitationalForceDemo(containerEl, params) {
            return new p5(function (p) {
                var G = 6.67e-11;
                var m1 = 1e24, m2 = 1e20, dist = 100;
                var sliderDist;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    p.createSpan('Distance r (scaled): ').parent(div);
                    sliderDist = p.createSlider(50, 250, 100, 5).parent(div);
                    p.createSpan('  F = GMm/r\u00B2').parent(div).style('margin-left', '10px');
                };

                p.draw = function () {
                    p.background(getBg());
                    dist = sliderDist.value();
                    var r = dist * 1e6;
                    var F = (G * m1 * m2) / (r * r);
                    var scale = 1e-5;

                    var cx = 300, radius = 40;
                    var x1 = cx - dist / 2, x2 = cx + dist / 2;
                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.circle(x1, 150, radius);
                    p.fill(COLORS.secondary);
                    p.circle(x2, 150, radius);

                    p.stroke(COLORS.accent);
                    p.strokeWeight(3);
                    var arrowLen = Math.min(80, F * scale);
                    p.line(x1 + radius / 2, 150, x1 + radius / 2 + arrowLen, 150);
                    p.line(x2 - radius / 2, 150, x2 - radius / 2 - arrowLen, 150);

                    p.noStroke();
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.text('F \u221d 1/r\u00B2', 300, 50);
                    p.text('F \u2248 ' + F.toExponential(1) + ' N (scaled)', 300, 270);
                };
            }, containerEl);
        }

        function orbitalMotionDemo(containerEl, params) {
            return new p5(function (p) {
                var angle = 0;
                var running = false;
                var radius = 120;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    var div = p.createDiv().parent(containerEl).style('margin-top', '10px');
                    var btn = p.createButton('Start').parent(div);
                    btn.mousePressed(function () {
                        running = !running;
                        btn.elt.textContent = running ? 'Pause' : 'Start';
                    });
                    p.createButton('Reset').parent(div).style('margin-left', '10px').mousePressed(function () {
                        running = false;
                        angle = 0;
                        btn.elt.textContent = 'Start';
                    });
                };

                p.draw = function () {
                    p.background(getBg());
                    if (running) angle += 0.02;

                    var cx = 300, cy = 150;
                    p.stroke(getAxisColor());
                    p.noFill();
                    p.strokeWeight(1);
                    p.circle(cx, cy, radius * 2);

                    var px = cx + radius * Math.cos(angle);
                    var py = cy + radius * Math.sin(angle);
                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.circle(cx, cy, 30);
                    p.fill(COLORS.accent);
                    p.circle(px, py, 20);

                    var vx = -radius * Math.sin(angle) * 0.3;
                    var vy = radius * Math.cos(angle) * 0.3;
                    p.stroke(COLORS.accent);
                    p.strokeWeight(2);
                    p.line(px, py, px + vx, py + vy);

                    p.noStroke();
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.text('Orbital motion: v \u27F6 tangent, F \u27F6 center', 300, 30);
                    p.text('T\u00B2 \u221D R\u00B3 (Kepler)', 300, 275);
                };
            }, containerEl);
        }

        // --- Chapter 8: Mechanical Properties of Solids ---

        function stressStrainCurve(containerEl, params) {
            return new p5(function (p) {
                var Y = params.youngsModulus || 75e9;
                var yieldStress = params.yieldStress || 3e8;
                var originX = 80, originY = 260, scaleX = 400, scaleY = 200;

                p.setup = function () {
                    p.createCanvas(600, 320).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Stress-Strain Curve: Y = \u03C3/\u03B5 (slope)', 300, 20);
                    p.textStyle(p.NORMAL);

                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.noFill();
                    p.line(originX, originY, originX + scaleX, originY);
                    p.line(originX, originY, originX, originY - scaleY);

                    var eYield = yieldStress / Y;
                    var eMax = Math.min(0.004, eYield * 1.5);
                    var pts = 40;
                    p.noFill();
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.beginShape();
                    for (var i = 0; i <= pts; i++) {
                        var e = (i / pts) * eMax;
                        var sigma = e <= eYield ? Y * e : yieldStress + (e - eYield) * Y * 0.1;
                        var x = originX + (e / eMax) * scaleX * 0.7;
                        var y = originY - (sigma / (yieldStress * 1.2)) * scaleY;
                        p.vertex(x, y);
                    }
                    p.endShape();

                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(originX + (eYield / eMax) * scaleX * 0.7, originY - (yieldStress / (yieldStress * 1.2)) * scaleY, 8);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('Yield', originX + (eYield / eMax) * scaleX * 0.7, originY + 20);
                    p.text('\u03B5 (strain)', 300, 300);
                    p.push();
                    p.translate(20, 160);
                    p.rotate(-p.PI / 2);
                    p.text('\u03C3 (stress)', 0, 0);
                    p.pop();
                };
            }, containerEl);
        }

        function wireLoadingDemo(containerEl, params) {
            return new p5(function (p) {
                var L1 = params.steelLength || 1.5, L2 = params.brassLength || 1.0;
                var m1 = params.mass1 || 4, m2 = params.mass2 || 6;
                var deltaL1 = params.deltaL1 || 0.00015, deltaL2 = params.deltaL2 || 0.00013;

                p.setup = function () {
                    p.createCanvas(600, 350).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    var cx = 300, topY = 40;
                    var scale = 120;
                    var wire1Len = L1 * scale + deltaL1 * scale * 500;
                    var wire2Len = L2 * scale + deltaL2 * scale * 500;

                    p.stroke(COLORS.primary);
                    p.strokeWeight(4);
                    p.line(cx, topY, cx, topY + wire1Len);
                    p.fill(COLORS.primary);
                    p.noStroke();
                    p.rect(cx - 25, topY + wire1Len, 50, 30, 4);
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.textSize(11);
                    p.text(m1 + ' kg', cx, topY + wire1Len + 20);

                    p.stroke(COLORS.accent);
                    p.strokeWeight(4);
                    p.line(cx, topY + wire1Len + 30, cx, topY + wire1Len + 30 + wire2Len);
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.rect(cx - 35, topY + wire1Len + 30 + wire2Len, 70, 35, 4);
                    p.fill(getTextColor());
                    p.text((m1 + m2) + ' kg', cx, topY + wire1Len + 30 + wire2Len + 22);

                    p.fill(getTextColor());
                    p.textSize(12);
                    p.textStyle(p.BOLD);
                    p.text('Steel wire', cx - 90, topY + wire1Len / 2);
                    p.text('Brass wire', cx - 90, topY + wire1Len + 30 + wire2Len / 2);
                    p.textStyle(p.NORMAL);
                    p.textSize(10);
                    p.text('\u0394L\u2081 = ' + (deltaL1 * 1000).toFixed(2) + ' mm', cx + 90, topY + wire1Len / 2);
                    p.text('\u0394L\u2082 = ' + (deltaL2 * 1000).toFixed(2) + ' mm', cx + 90, topY + wire1Len + 30 + wire2Len / 2);
                };
            }, containerEl);
        }

        // --- Chapter 10: Thermal Properties of Matter ---

        function temperatureScalesVisual(containerEl, params) {
            return new p5(function (p) {
                var T_K = params.T_K || 300;

                p.setup = function () {
                    p.createCanvas(600, 200).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    var tc = T_K - 273.15;
                    var tF = (9 / 5) * tc + 32;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Temperature Scales: K \u2194 \u00B0C \u2194 \u00B0F', 300, 25);
                    p.textStyle(p.NORMAL);

                    var barW = 400;
                    var barH = 24;
                    var cx = 300, cy = 90;
                    p.fill(80, 80, 120, 150);
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.rect(cx - barW / 2, cy - barH / 2, barW, barH);

                    var tMin = 200, tMax = 400;
                    var frac = Math.max(0, Math.min(1, (T_K - tMin) / (tMax - tMin)));
                    var markX = cx - barW / 2 + frac * barW;
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.triangle(markX, cy - barH / 2 - 8, markX - 6, cy, markX + 6, cy);

                    p.fill(getTextColor());
                    p.textSize(12);
                    p.text('K: ' + T_K.toFixed(1), markX, cy - 20);
                    p.text('\u00B0C: ' + tc.toFixed(1), markX, cy + barH / 2 + 25);
                    p.text('\u00B0F: ' + tF.toFixed(1), markX, cy + barH / 2 + 42);

                    p.textSize(10);
                    p.text('200 K', cx - barW / 2 - 15, cy + 5);
                    p.text('400 K', cx + barW / 2 + 15, cy + 5);
                };
            }, containerEl);
        }

        function linearExpansionDemo(containerEl, params) {
            return new p5(function (p) {
                var L0 = params.L0 || 1;
                var alpha = params.alpha || 1.2e-5;
                var dT = params.dT !== undefined ? params.dT : 18;
                var scale = 200;
                var exaggerate = 500;

                p.setup = function () {
                    p.createCanvas(600, 180).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    var deltaL = L0 * alpha * dT;
                    var L1 = L0 * (1 + alpha * dT);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Linear Expansion: \u0394L = L\u2080\u03B1\u0394T', 300, 22);
                    p.textStyle(p.NORMAL);

                    var baseY = 120;
                    var lenCold = L0 * scale;
                    var lenHot = lenCold * (1 + exaggerate * alpha * dT);

                    p.stroke(COLORS.primary);
                    p.strokeWeight(6);
                    p.line(80, baseY, 80 + lenCold, baseY);
                    p.fill(getTextColor());
                    p.textSize(11);
                    p.text('T\u2080 (cold)', 80 + lenCold / 2, baseY + 20);
                    p.text('L\u2080 = ' + L0 + ' m', 80 + lenCold / 2, baseY + 35);

                    p.stroke(COLORS.accent);
                    p.strokeWeight(6);
                    p.line(80, baseY + 55, 80 + lenHot, baseY + 55);
                    p.fill(getTextColor());
                    p.text('T\u2080 + \u0394T (hot, \u0394L exaggerated)', 80 + lenHot / 2, baseY + 75);
                    p.text('L = ' + L1.toFixed(4) + ' m, \u0394L = ' + (deltaL * 1000).toFixed(3) + ' mm', 80 + lenHot / 2, baseY + 90);
                };
            }, containerEl);
        }

        // --- Chapter 11: Thermodynamics ---

        function pvDiagramDemo(containerEl, params) {
            return new p5(function (p) {
                var PD = params.PD || 600, PE = params.PE || 300;
                var VD = params.VD || 2, VE = params.VE || 5, VF = params.VF || 2;
                var originX = 80, originY = 280;
                var scaleX = 350, scaleY = 220;

                p.setup = function () {
                    p.createCanvas(600, 320).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('P-V Diagram: Work = Area under curve', 300, 22);
                    p.textStyle(p.NORMAL);

                    var pmax = Math.max(PD, PE);
                    var vmax = Math.max(VD, VE, VF);
                    var sx = scaleX / vmax;
                    var sy = scaleY / pmax;

                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.line(originX, originY, originX + scaleX, originY);
                    p.line(originX, originY, originX, originY - scaleY);

                    var xD = originX + VD * sx;
                    var yD = originY - PD * sy;
                    var xE = originX + VE * sx;
                    var yE = originY - PE * sy;
                    var xF = originX + VF * sx;
                    var yF = originY - PE * sy;

                    p.fill(80, 120, 200, 80);
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.beginShape();
                    p.vertex(xD, originY);
                    p.vertex(xD, yD);
                    p.vertex(xE, yE);
                    p.vertex(xE, originY);
                    p.endShape(p.CLOSE);

                    p.fill(200, 150, 80, 80);
                    p.stroke(COLORS.accent);
                    p.strokeWeight(2);
                    p.beginShape();
                    p.vertex(xE, originY);
                    p.vertex(xE, yE);
                    p.vertex(xF, yF);
                    p.vertex(xF, originY);
                    p.endShape(p.CLOSE);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(11);
                    p.text('D', xD, originY + 16);
                    p.text('E', xE, originY + 16);
                    p.text('F', xF, originY + 16);
                    p.text('P (Pa)', originX - 10, 25);
                    p.text('V (m\u00B3)', originX + scaleX / 2, originY + 20);
                };
            }, containerEl);
        }

        function freeExpansionDemo(containerEl, params) {
            return new p5(function (p) {
                var fillFrac = params.fillFrac !== undefined ? params.fillFrac : 0.5;

                p.setup = function () {
                    p.createCanvas(600, 200).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Free Expansion: Gas expands into vacuum (Q=0, W=0, \u0394U=0)', 300, 22);
                    p.textStyle(p.NORMAL);

                    var cx = 300, cy = 110;
                    var boxW = 120, boxH = 80;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.rect(cx - 140, cy - boxH / 2, boxW, boxH);
                    p.rect(cx + 20, cy - boxH / 2, boxW, boxH);

                    p.fill(100, 150, 255, 180);
                    p.noStroke();
                    p.rect(cx - 138, cy - boxH / 2 + 2, boxW * fillFrac - 4, boxH - 4);

                    p.fill(getTextColor());
                    p.textSize(11);
                    p.text('A (STP)', cx - 80, cy - boxH / 2 - 10);
                    p.text('B (vacuum)', cx + 80, cy - boxH / 2 - 10);
                    p.text('\u2192 stopcock open \u2192', 300, cy + 60);
                };
            }, containerEl);
        }

        // --- Chapter 12: Kinetic Theory ---

        function gasMoleculesFractionDemo(containerEl, params) {
            return new p5(function (p) {
                var frac = params.fraction !== undefined ? params.fraction : 0.0004;
                var nDots = 30;

                p.setup = function () {
                    p.createCanvas(600, 200).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Molecular Volume Fraction at STP (O\u2082: ~4\u00D710\u207B\u2074)', 300, 22);
                    p.textStyle(p.NORMAL);

                    var boxW = 400, boxH = 80;
                    var cx = 300, cy = 110;
                    p.stroke(getAxisColor());
                    p.strokeWeight(2);
                    p.noFill();
                    p.rect(cx - boxW / 2, cy - boxH / 2, boxW, boxH);

                    var side = Math.sqrt(frac) * Math.min(boxW, boxH) * 0.8;
                    p.fill(100, 150, 255, 200);
                    p.noStroke();
                    p.rect(cx - side / 2, cy - side / 2, side, side);

                    p.fill(getTextColor());
                    p.textSize(11);
                    p.text('Molecules: ' + (frac * 100).toFixed(2) + '% of volume', 300, cy + 55);
                };
            }, containerEl);
        }

        function bubbleRiseDemo(containerEl, params) {
            return new p5(function (p) {
                var V1 = params.V1 || 1;
                var V2 = params.V2 || 5.3;

                p.setup = function () {
                    p.createCanvas(600, 250).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Air Bubble: P\u2081V\u2081/T\u2081 = P\u2082V\u2082/T\u2082', 300, 22);
                    p.textStyle(p.NORMAL);

                    var baseY = 200;
                    var r1 = 15, r2 = 15 * Math.pow(V2 / V1, 1 / 3);
                    p.fill(200, 230, 255, 180);
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.ellipse(180, baseY - 120, r1 * 2, r1 * 2);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.text('Bottom: V=' + V1 + ' cm\u00B3', 180, baseY - 100);
                    p.text('P=P_atm+\u03C1gh', 180, baseY - 88);

                    p.fill(200, 230, 255, 180);
                    p.stroke(COLORS.accent);
                    p.strokeWeight(2);
                    p.ellipse(420, baseY - 120, Math.min(r2 * 2, 80), Math.min(r2 * 2, 80));
                    p.fill(getTextColor());
                    p.noStroke();
                    p.text('Surface: V=' + V2.toFixed(1) + ' cm\u00B3', 420, baseY - 100);
                    p.text('P=P_atm', 420, baseY - 88);
                    p.text('\u2191', 300, baseY - 50);
                };
            }, containerEl);
        }

        function rmsSpeedComparisonDemo(containerEl, params) {
            return new p5(function (p) {
                var T = params.T || 300;

                p.setup = function () {
                    p.createCanvas(600, 180).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('v_rms \u221d 1/\u221aM: Lighter molecules move faster', 300, 22);
                    p.textStyle(p.NORMAL);

                    var vNe = Math.sqrt(3 * 8.31 * T / 0.02);
                    var vCl = Math.sqrt(3 * 8.31 * T / 0.071);
                    var vUf = Math.sqrt(3 * 8.31 * T / 0.352);
                    var maxV = vNe;

                    var baseY = 130;
                    var w = 120;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.rect(80, baseY - 60, w, 50);
                    p.fill(100, 150, 255, 100);
                    p.rect(82, baseY - 58, (vNe / maxV) * (w - 4), 46);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('Ne', 80 + w / 2, baseY - 70);
                    p.text(vNe.toFixed(0) + ' m/s', 80 + w / 2, baseY + 5);

                    p.stroke(COLORS.accent);
                    p.noFill();
                    p.rect(240, baseY - 60, w, 50);
                    p.fill(200, 150, 80, 100);
                    p.rect(242, baseY - 58, (vCl / maxV) * (w - 4), 46);
                    p.fill(getTextColor());
                    p.text('Cl\u2082', 240 + w / 2, baseY - 70);
                    p.text(vCl.toFixed(0) + ' m/s', 240 + w / 2, baseY + 5);

                    p.stroke(COLORS.secondary);
                    p.noFill();
                    p.rect(400, baseY - 60, w, 50);
                    p.fill(150, 100, 200, 100);
                    p.rect(402, baseY - 58, (vUf / maxV) * (w - 4), 46);
                    p.fill(getTextColor());
                    p.text('UF\u2086', 400 + w / 2, baseY - 70);
                    p.text(vUf.toFixed(0) + ' m/s', 400 + w / 2, baseY + 5);
                };
            }, containerEl);
        }

        // --- Chapter 13: Oscillations (Animated) ---

        function springMassOscillatorAnim(containerEl, params) {
            return new p5(function (p) {
                var k = params.k || 1200;
                var m = params.m || 3;
                var A = (params.A !== undefined ? params.A : 0.02) * 100;
                var omega = Math.sqrt(k / m);
                var scale = 1500;

                p.setup = function () {
                    p.createCanvas(600, 280).parent(containerEl);
                    p.frameRate(45);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 45;
                    var x = A * Math.cos(omega * t);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Spring-Mass Oscillator: x = A cos(\u03C9t)', 300, 20);
                    p.textStyle(p.NORMAL);
                    p.textSize(11);
                    p.text('T = 2\u03C0\u221a(m/k) = ' + (2 * Math.PI / omega).toFixed(2) + ' s', 300, 38);

                    var cx = 80, cy = 140;
                    var springLen = Math.max(50, 100 + x * 5);
                    var coils = 8;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(3);
                    p.noFill();
                    p.line(cx, cy, cx + 15, cy);
                    var prevX = cx + 15, prevY = cy;
                    for (var i = 0; i < coils; i++) {
                        var seg = springLen / coils;
                        var nextX = prevX + seg;
                        var nextY = cy + (i % 2 === 0 ? 12 : -12);
                        p.line(prevX, prevY, nextX, nextY);
                        prevX = nextX;
                        prevY = nextY;
                    }
                    p.line(prevX, prevY, cx + 15 + springLen, cy);
                    p.line(cx + 15 + springLen, cy, cx + 15 + springLen + 35, cy);

                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.rect(cx + 15 + springLen + 5, cy - 25, 50, 50, 4);
                    p.fill(getTextColor());
                    p.text('m', cx + 15 + springLen + 30, cy + 5);

                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.line(80, 200, 520, 200);
                    p.line(300, 200, 300 + x * 2.5, 195);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.text('x = ' + (x / 100).toFixed(3) + ' m', 300 + x, 220);
                };
            }, containerEl);
        }

        function shmReferenceCircleAnim(containerEl, params) {
            return new p5(function (p) {
                var omega = params.omega || 2;
                var R = params.radius || 80;

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    p.frameRate(40);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 40;
                    var angle = omega * t;
                    var px = 200 + R * Math.cos(angle);
                    var py = 120 - R * Math.sin(angle);
                    var projX = 200 + R * Math.cos(angle);
                    var projY = 220;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('SHM Reference Circle: x = A cos(\u03C9t)', 300, 22);
                    p.textStyle(p.NORMAL);

                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.noFill();
                    p.circle(200, 120, R * 2);
                    p.line(200 - R - 20, 120, 200 + R + 20, 120);

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.line(200, 120, px, py);
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(px, py, 14);

                    p.stroke(COLORS.secondary);
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash && p.drawingContext.setLineDash([4, 4]);
                    p.line(px, py, projX, projY);
                    p.drawingContext.setLineDash && p.drawingContext.setLineDash([]);

                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.rect(projX - 8, projY - 8, 16, 16);

                    p.stroke(getAxisColor());
                    p.line(80, 220, 320, 220);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('x', 330, 225);
                };
            }, containerEl);
        }

        function simplePendulumAnim(containerEl, params) {
            return new p5(function (p) {
                var L = params.L || 120;
                var thetaMax = (params.thetaMax || 0.3) * 180 / Math.PI;
                var g = 9.8;
                var omega = Math.sqrt(g / (L / 100));

                p.setup = function () {
                    p.createCanvas(600, 300).parent(containerEl);
                    p.frameRate(45);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 45;
                    var theta = thetaMax * (Math.PI / 180) * Math.cos(omega * t);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Simple Pendulum: T = 2\u03C0\u221a(L/g)', 300, 20);

                    var pivotX = 300, pivotY = 50;
                    var bobX = pivotX + L * Math.sin(theta);
                    var bobY = pivotY + L * Math.cos(theta);

                    p.stroke(COLORS.primary);
                    p.strokeWeight(3);
                    p.line(pivotX, pivotY, bobX, bobY);
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(bobX, bobY, 28);
                    p.fill(100);
                    p.stroke(0);
                    p.strokeWeight(1);
                    p.circle(pivotX, pivotY, 10);
                };
            }, containerEl);
        }

        function ballInBowlAnim(containerEl, params) {
            return new p5(function (p) {
                var R = params.R || 100;
                var omega = params.omega || 3;

                p.setup = function () {
                    p.createCanvas(600, 220).parent(containerEl);
                    p.frameRate(45);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 45;
                    var theta = 0.5 * Math.cos(omega * t);
                    var cx = 300, baseY = 160;
                    var bx = cx + R * Math.sin(theta);
                    var by = baseY - R + R * Math.cos(theta);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Ball in Bowl: SHM for small \u03B8', 300, 20);

                    p.noFill();
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.arc(cx, baseY, R * 2, R * 1.2, Math.PI, 0);
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(bx, by, 24);
                };
            }, containerEl);
        }

        // --- Chapter 14: Waves (Animated) ---

        function transverseWaveAnim(containerEl, params) {
            return new p5(function (p) {
                var A = params.A || 25;
                var k = params.k || 0.4;
                var omega = params.omega || 4;

                p.setup = function () {
                    p.createCanvas(600, 260).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 50;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Travelling Wave: y = A sin(kx \u2212 \u03C9t)', 300, 22);

                    var baseY = 130;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var x = 0; x <= 600; x += 4) {
                        var y = baseY + A * Math.sin(k * x * 0.1 - omega * t);
                        p.vertex(x, y);
                    }
                    p.endShape();
                };
            }, containerEl);
        }

        function standingWaveAnim(containerEl, params) {
            return new p5(function (p) {
                var A = params.A || 30;
                var k = params.k || 0.5;
                var omega = params.omega || 5;

                p.setup = function () {
                    p.createCanvas(600, 260).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 50;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Standing Wave: y = 2A sin(kx) cos(\u03C9t)', 300, 22);

                    var baseY = 130;
                    p.stroke(COLORS.secondary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var x = 0; x <= 600; x += 4) {
                        var y = baseY + 2 * A * Math.sin(k * x * 0.1) * Math.cos(omega * t);
                        p.vertex(x, y);
                    }
                    p.endShape();
                };
            }, containerEl);
        }

        function beatsAnim(containerEl, params) {
            return new p5(function (p) {
                var f1 = params.f1 || 256;
                var f2 = params.f2 || 260;
                var scale = 0.02;

                p.setup = function () {
                    p.createCanvas(600, 280).parent(containerEl);
                    p.frameRate(60);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 60;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Beats: f_beat = |f\u2081 \u2212 f\u2082| = ' + Math.abs(f2 - f1) + ' Hz', 300, 20);
                    p.textStyle(p.NORMAL);
                    p.textSize(11);
                    p.text('y = sin(2\u03C0f\u2081t) + sin(2\u03C0f\u2082t)  (shows beat envelope)', 300, 38);

                    var baseY = 140;
                    var A = 35;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var i = 0; i <= 600; i += 2) {
                        var ti = (i / 600) * 0.08 + t * scale;
                        var y = baseY + A * (Math.sin(2 * Math.PI * f1 * ti) + Math.sin(2 * Math.PI * f2 * ti));
                        p.vertex(i, y);
                    }
                    p.endShape();
                };
            }, containerEl);
        }

        function stringHarmonicsAnim(containerEl, params) {
            return new p5(function (p) {
                var n = params.n || 1;
                var A = params.A || 25;
                var omega = params.omega || 4;

                p.setup = function () {
                    p.createCanvas(600, 260).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 50;
                    var L = 550;
                    var k = (n * Math.PI) / (L / 100);

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('String Harmonics: n = ' + n + '  (L = n\u03BB/2)', 300, 20);
                    p.textStyle(p.NORMAL);

                    var baseY = 130;
                    p.stroke(n === 1 ? COLORS.primary : COLORS.secondary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var x = 25; x <= 575; x += 3) {
                        var xx = (x - 25) / 550;
                        var y = baseY + A * Math.sin(n * Math.PI * xx) * Math.cos(omega * t);
                        p.vertex(x, y);
                    }
                    p.endShape();
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.line(25, baseY, 575, baseY);
                };
            }, containerEl);
        }

        function waveReflectionAnim(containerEl, params) {
            return new p5(function (p) {
                var A = 24, W = 40;

                p.setup = function () {
                    p.createCanvas(600, 220).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = (p.frameCount / 50) % 4;
                    var baseY = 110;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Pulse Reflection at Fixed End (\u03C0 phase change)', 300, 22);
                    p.textStyle(p.NORMAL);

                    var pos, sign;
                    if (t < 2) {
                        pos = 60 + t * 220;
                        sign = 1;
                    } else {
                        pos = 60 + (4 - t) * 220;
                        sign = -1;
                    }

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var x = 30; x <= 530; x += 3) {
                        var dx = (x - pos) / W;
                        var y = baseY + sign * A * Math.exp(-dx * dx);
                        p.vertex(x, y);
                    }
                    p.endShape();

                    p.stroke(getAxisColor());
                    p.strokeWeight(2);
                    p.line(530, 50, 530, 170);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(10);
                    p.text('Fixed', 545, 112);
                };
            }, containerEl);
        }

        function phaseDifferenceAnim(containerEl, params) {
            return new p5(function (p) {
                var omega = params.omega || 4;
                var k = params.k || 0.3;

                p.setup = function () {
                    p.createCanvas(600, 280).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 50;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Phase Difference: y(x,t) = A sin(\u03C9t + kx). Different x \u2192 different phase', 300, 20);

                    var baseY = 90;
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var x = 0; x <= 600; x += 4) {
                        var y = baseY + 20 * Math.sin(omega * t + k * x * 0.15);
                        p.vertex(x, y);
                    }
                    p.endShape();

                    var x1 = 150, x2 = 350;
                    var y1 = baseY + 20 * Math.sin(omega * t + k * x1 * 0.15);
                    var y2 = baseY + 20 * Math.sin(omega * t + k * x2 * 0.15);
                    p.fill(COLORS.accent);
                    p.noStroke();
                    p.circle(x1, y1, 12);
                    p.circle(x2, y2, 12);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('x\u2081', x1, baseY + 55);
                    p.text('x\u2082', x2, baseY + 55);
                    p.text('\u0394\u03D5 = k(x\u2082 \u2212 x\u2081)', 300, baseY + 75);
                };
            }, containerEl);
        }

        function longitudinalWaveAnim(containerEl, params) {
            return new p5(function (p) {
                var k = params.k || 0.35;
                var omega = params.omega || 3.5;

                p.setup = function () {
                    p.createCanvas(600, 200).parent(containerEl);
                    p.frameRate(50);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 50;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Longitudinal Wave: Compression & Rarefaction', 300, 22);
                    p.textStyle(p.NORMAL);
                    p.textSize(10);
                    p.text('Displacement \u03BE(x,t) = A sin(kx \u2212 \u03C9t). Particles oscillate along propagation.', 300, 40);

                    var baseY = 110;
                    var N = 40;
                    var A = 18;
                    var spacing = 14;
                    for (var i = 0; i < N; i++) {
                        var x0 = 50 + i * spacing;
                        var xx = (x0 - 50) * 0.08;
                        var xi = A * Math.sin(k * xx - omega * t);
                        var x = x0 + xi;
                        var r = 6 + 4 * Math.cos(k * xx - omega * t);
                        p.fill(COLORS.primary);
                        p.noStroke();
                        p.circle(x, baseY, Math.max(4, r));
                    }
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.line(50, baseY + 35, 550, baseY + 35);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.textSize(9);
                    p.text('Propagation \u2192', 300, baseY + 52);
                };
            }, containerEl);
        }

        function vibratingRodAnim(containerEl, params) {
            return new p5(function (p) {
                p.setup = function () {
                    p.createCanvas(600, 220).parent(containerEl);
                    p.frameRate(45);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 45;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Rod Clamped at Middle: L = \u03BB/2', 300, 22);
                    p.textStyle(p.NORMAL);
                    p.textSize(10);
                    p.text('Node at center, antinodes at ends. Fundamental: \u03BB = 2L', 300, 40);

                    var L = 400;
                    var cx = 300;
                    var baseY = 120;
                    var A = 25;
                    var k = Math.PI / (L / 100);

                    p.stroke(COLORS.secondary);
                    p.strokeWeight(3);
                    p.noFill();
                    p.beginShape();
                    for (var i = 0; i <= 100; i++) {
                        var s = i / 100;
                        var displace = A * Math.cos(Math.PI * s) * Math.cos(4 * t);
                        var x = cx - L / 2 + s * L;
                        var y = baseY + displace;
                        p.vertex(x, y);
                    }
                    p.endShape();

                    var midX = cx;
                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.circle(midX, baseY, 14);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('Node', midX, baseY + 35);
                    p.fill(COLORS.accent);
                    p.circle(cx - L / 2, baseY + A * Math.cos(4 * t), 10);
                    p.circle(cx + L / 2, baseY - A * Math.cos(4 * t), 10);
                    p.fill(getTextColor());
                    p.text('Antinode', cx - L / 2 - 25, baseY + 50);
                    p.text('Antinode', cx + L / 2 + 25, baseY + 50);
                    p.stroke(COLORS.danger);
                    p.strokeWeight(2);
                    p.line(midX - 25, baseY + 85, midX + 25, baseY + 85);
                    p.fill(getTextColor());
                    p.noStroke();
                    p.text('Clamp', midX, baseY + 100);
                };
            }, containerEl);
        }

        function dopplerEffectAnim(containerEl, params) {
            return new p5(function (p) {
                var sourceSpeed = params.sourceSpeed || 0.4;
                var waveSpeed = 1;

                p.setup = function () {
                    p.createCanvas(600, 320).parent(containerEl);
                    p.frameRate(40);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = (p.frameCount / 40) % 6;
                    var cx = 300;
                    var cy = 280;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Doppler Effect: Source Moving Toward Observer', 300, 22);
                    p.textStyle(p.NORMAL);
                    p.textSize(10);
                    p.text('Wavefronts compressed ahead (higher f), stretched behind (lower f)', 300, 40);

                    var srcX = cx - 180 + t * 80;
                    var srcY = cy - 30;

                    for (var i = 1; i <= 8; i++) {
                        var delay = i * 0.4;
                        if (t > delay) {
                            var dt = t - delay;
                            var r = dt * 55;
                            p.noFill();
                            p.stroke(COLORS.primary);
                            p.strokeWeight(1.5);
                            p.ellipse(srcX - (delay * 30), srcY, r * 2, r * 1.2);
                        }
                    }

                    p.fill(COLORS.danger);
                    p.noStroke();
                    p.circle(srcX, srcY, 24);
                    p.fill(COLORS.white);
                    p.textSize(11);
                    p.text('S', srcX, srcY + 4);
                    p.fill(getTextColor());
                    p.textSize(10);
                    p.text('Source \u2192', srcX + 20, srcY);
                    p.text('Observer', cx + 150, cy - 50);
                    p.stroke(getAxisColor());
                    p.strokeWeight(1);
                    p.drawingContext.setLineDash([5, 5]);
                    p.line(cx + 120, cy - 60, cx + 120, 40);
                    p.drawingContext.setLineDash([]);
                    p.noStroke();
                    p.fill(COLORS.accent);
                    p.circle(cx + 120, cy - 80, 12);
                };
            }, containerEl);
        }

        function organPipeModesAnim(containerEl, params) {
            return new p5(function (p) {
                var mode = params.mode || 1;
                var openEnd = params.openEnd !== false;

                p.setup = function () {
                    p.createCanvas(600, 240).parent(containerEl);
                    p.frameRate(45);
                };

                p.draw = function () {
                    p.background(getBg());
                    var t = p.frameCount / 45;

                    p.fill(getTextColor());
                    p.noStroke();
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text((openEnd ? 'Open' : 'Closed') + ' Pipe: n = ' + mode + '  (antinode at open end)', 300, 22);

                    var L = 400;
                    var cx = 300;
                    var pipeTop = 60, pipeH = 140;
                    var k = (mode * Math.PI) / (L / 80);

                    p.stroke(getAxisColor());
                    p.strokeWeight(2);
                    p.line(cx - 20, pipeTop, cx - 20, pipeTop + pipeH);
                    p.line(cx + 20, pipeTop, cx + 20, pipeTop + pipeH);
                    if (!openEnd) p.line(cx - 20, pipeTop + pipeH, cx + 20, pipeTop + pipeH);

                    var baseY = pipeTop + pipeH / 2;
                    p.stroke(COLORS.secondary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.beginShape();
                    for (var i = 0; i <= 80; i++) {
                        var yy = baseY - 35 * Math.sin(mode * Math.PI * i / 80) * Math.cos(3 * t);
                        var xx = cx - 25 + (i / 80) * 50;
                        p.vertex(xx, yy);
                    }
                    p.endShape();
                };
            }, containerEl);
        }

        // --- Chapter 9: Mechanical Properties of Fluids ---

        function hydrostaticPressureDemo(containerEl, params) {
            return new p5(function (p) {
                var rho = params.density || 1030;
                var maxH = params.maxDepth || 3;
                var P0 = 101300;

                p.setup = function () {
                    p.createCanvas(600, 320).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    var cx = 180, baseY = 280;
                    var colH = 200;
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Hydrostatic Pressure: P = P\u2080 + \u03C1gh', 300, 22);
                    p.textStyle(p.NORMAL);

                    p.fill(100, 150, 255, 180);
                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.rect(cx - 40, baseY - colH, 80, colH);

                    var step = maxH / 4;
                    for (var i = 1; i <= 4; i++) {
                        var h = i * step;
                        var P = P0 + rho * 9.8 * h * 1000;
                        var y = baseY - (i / 4) * colH;
                        p.fill(getTextColor());
                        p.noStroke();
                        p.textSize(10);
                        p.text('h=' + h.toFixed(1) + ' km', cx + 60, y);
                        p.text('P\u2248' + (P / 1e6).toFixed(2) + '\u00D710\u2076 Pa', cx + 60, y + 12);
                    }
                    p.fill(getTextColor());
                    p.text('Surface: P\u2080', cx, baseY + 18);
                };
            }, containerEl);
        }

        function barometerDemo(containerEl, params) {
            return new p5(function (p) {
                var rho = params.density || 13600;
                var h = params.height || 0.76;

                p.setup = function () {
                    p.createCanvas(600, 320).parent(containerEl);
                };

                p.draw = function () {
                    p.background(getBg());
                    var cx = 300, baseY = 280;
                    var scaleH = 180;
                    var colH = Math.min(h * 12, scaleH);
                    p.fill(getTextColor());
                    p.textAlign(p.CENTER);
                    p.textSize(14);
                    p.textStyle(p.BOLD);
                    p.text('Barometer: P_atm = \u03C1gh', 300, 22);
                    p.textStyle(p.NORMAL);

                    p.stroke(COLORS.primary);
                    p.strokeWeight(2);
                    p.noFill();
                    p.rect(cx - 30, baseY - colH, 60, colH);
                    p.fill(200, 200, 100, 200);
                    p.noStroke();
                    p.rect(cx - 28, baseY - colH + 2, 56, colH - 2);

                    p.fill(getTextColor());
                    p.textSize(11);
                    p.text('h = ' + (h * 100).toFixed(0) + ' cm', cx, baseY - colH - 10);
                    p.text('\u03C1 = ' + rho + ' kg/m\u00B3', cx, baseY + 20);
                };
            }, containerEl);
        }

        var sketchMap = {
            // Chapter 1: Units and Measurement
            'unit-conversion-visual': unitConversionVisual,
            'vernier-callipers': vernierCallipers,
            'screw-gauge': screwGauge,
            'sig-fig-visualization': sigFigVisualization,
            'microscope-magnification': microscopeMagnification,
            'thread-winding-demo': threadWindingDemo,
            'area-magnification': areaMagnification,

            // Chapter 2: Motion in a Straight Line
            'position-time-graph': positionTimeGraph,
            'vertical-projectile': verticalProjectile,
            'free-fall-demo': freeFallDemo,
            'velocity-time-analysis': velocityTimeAnalysis,
            'position-time-comparison': positionTimeComparison,
            'daily-commute-graph': dailyCommuteGraph,
            'braking-car-demo': brakingCarDemo,

            // Chapter 3: Motion in a Plane
            'vector-addition': vectorAddition,
            'displacement-comparison': displacementComparison,
            'sequential-path': sequentialPath,
            'polygon-path': polygonPath,
            'projectile-motion': projectileMotion,

            // Chapter 4: Laws of Motion
            'train-drop': trainDrop,
            'pendulum-cut': pendulumCut,
            'lift-apparent-weight': liftApparentWeight,
            'atwoods-machine': atwoodsMachine,

            // Chapter 5: Work, Energy and Power
            'potential-energy-graphs': potentialEnergyGraphs,
            'collision-outcomes': collisionOutcomes,
            'windmill-power': windmillPower,

            // Chapter 6: Systems of Particles and Rotational Motion
            'center-of-mass-shapes': centerOfMassShapes,
            'cm-velocity-demo': cmVelocityDemo,
            'moment-of-inertia-race': momentOfInertiaRace,

            // Chapter 7: Gravitation
            'gravitational-force-demo': gravitationalForceDemo,
            'orbital-motion-demo': orbitalMotionDemo,

            // Chapter 8: Mechanical Properties of Solids
            'stress-strain-curve': stressStrainCurve,
            'wire-loading-demo': wireLoadingDemo,

            // Chapter 9: Mechanical Properties of Fluids
            'hydrostatic-pressure-demo': hydrostaticPressureDemo,
            'barometer-demo': barometerDemo,

            // Chapter 10: Thermal Properties of Matter
            'temperature-scales-visual': temperatureScalesVisual,
            'linear-expansion-demo': linearExpansionDemo,

            // Chapter 11: Thermodynamics
            'pv-diagram-demo': pvDiagramDemo,
            'free-expansion-demo': freeExpansionDemo,

            // Chapter 12: Kinetic Theory
            'gas-molecules-fraction-demo': gasMoleculesFractionDemo,
            'bubble-rise-demo': bubbleRiseDemo,
            'rms-speed-comparison-demo': rmsSpeedComparisonDemo,

            // Chapter 13: Oscillations (Animated)
            'spring-mass-oscillator-anim': springMassOscillatorAnim,
            'shm-reference-circle-anim': shmReferenceCircleAnim,
            'simple-pendulum-anim': simplePendulumAnim,
            'ball-in-bowl-anim': ballInBowlAnim,

            // Chapter 14: Waves (Animated)
            'transverse-wave-anim': transverseWaveAnim,
            'standing-wave-anim': standingWaveAnim,
            'beats-anim': beatsAnim,
            'string-harmonics-anim': stringHarmonicsAnim,
            'wave-reflection-anim': waveReflectionAnim,
            'phase-difference-anim': phaseDifferenceAnim,
            'organ-pipe-modes-anim': organPipeModesAnim,
            'longitudinal-wave-anim': longitudinalWaveAnim,
            'vibrating-rod-anim': vibratingRodAnim,
            'doppler-effect-anim': dopplerEffectAnim
        };

        var sketchFn = sketchMap[type];
        if (!sketchFn) {
            console.error('Unknown sketch type for Class XI:', type);
            containerEl.innerHTML = '<p style="color: red;">Unknown sketch type: ' + type + '</p>';
            return null;
        }

        return sketchFn(containerEl, params);
    }

    // Public API
    return {
        render: render,
        COLORS: COLORS
    };
})();
