/**
 * Visual Math — Triangle Solver (Law of Sines/Cosines)
 * Requires: vm-core.js
 */
(function () {
    'use strict';

    var state = null;
    var triangle = { a: null, b: null, c: null, A: null, B: null, C: null };
    var solved = false;

    function triangleSolverViz(p, container) {
        state = VisualMath.getState();
        var W, H;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            if (solved) {
                drawTriangle(C);
            } else {
                drawPlaceholder(C);
            }

            p.noLoop();
        };

        function drawPlaceholder(C) {
            p.fill(C.muted);
            p.noStroke();
            p.textSize(16);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('Enter 3 values and click Solve', W / 2, H / 2);
        }

        function drawTriangle(C) {
            var scale = Math.min(W, H) * 0.25;
            var cx = W / 2, cy = H / 2 + 20;

            // Normalize triangle for display
            var maxSide = Math.max(triangle.a, triangle.b, triangle.c);
            var a = (triangle.a / maxSide) * scale;
            var b = (triangle.b / maxSide) * scale;
            var c = (triangle.c / maxSide) * scale;

            // Position vertices
            var Ax = cx - c / 2;
            var Ay = cy + 50;
            var Bx = cx + c / 2;
            var By = cy + 50;

            // Use law of cosines to find position of C
            var angleA = triangle.A * Math.PI / 180;
            var Cx = Ax + b * Math.cos(angleA);
            var Cy = Ay - b * Math.sin(angleA);

            // Draw triangle
            p.fill(C.accent[0], C.accent[1], C.accent[2], 30);
            p.stroke(C.sin);
            p.strokeWeight(2.5);
            p.triangle(Ax, Ay, Bx, By, Cx, Cy);

            // Draw vertices
            p.fill(C.point);
            p.stroke(C.accent);
            p.strokeWeight(2);
            p.ellipse(Ax, Ay, 10, 10);
            p.ellipse(Bx, By, 10, 10);
            p.ellipse(Cx, Cy, 10, 10);

            // Labels
            p.fill(C.text);
            p.noStroke();
            p.textSize(14);

            // Vertex labels
            p.textAlign(p.CENTER, p.TOP);
            p.text('A', Ax, Ay + 8);
            p.text('B', Bx, By + 8);
            p.text('C', Cx, Cy - 18);

            // Side labels
            p.fill(C.sin);
            p.textAlign(p.CENTER, p.CENTER);
            p.text('a = ' + triangle.a.toFixed(2), (Bx + Cx) / 2 + 15, (By + Cy) / 2);
            p.text('b = ' + triangle.b.toFixed(2), (Ax + Cx) / 2 - 15, (Ay + Cy) / 2);
            p.text('c = ' + triangle.c.toFixed(2), (Ax + Bx) / 2, (Ay + By) / 2 + 15);

            // Angle labels
            p.fill(C.cos);
            p.textSize(12);
            p.text(triangle.A.toFixed(1) + '°', Ax + 20, Ay - 10);
            p.text(triangle.B.toFixed(1) + '°', Bx - 20, By - 10);
            p.text(triangle.C.toFixed(1) + '°', Cx, Cy + 15);
        }

        state._redraw = function () { p.loop(); };

        // External API
        state._solve = function (a, b, c, A, B, C) {
            var result = solveTriangle(a, b, c, A, B, C);
            if (result.error) {
                alert(result.error);
                solved = false;
            } else {
                triangle = result;
                solved = true;
                updateResults(result);
            }
            p.loop();
        };

        state._clear = function () {
            solved = false;
            triangle = { a: null, b: null, c: null, A: null, B: null, C: null };
            setEl('val-case', '--');
            setEl('val-area', '--');
            setEl('val-perimeter', '--');
            setEl('val-type', '--');
            p.loop();
        };

        function solveTriangle(a, b, c, A, B, C) {
            var count = [a, b, c, A, B, C].filter(x => x !== null).length;

            if (count < 3) {
                return { error: 'Please enter at least 3 values' };
            }

            var result = { a: a, b: b, c: c, A: A, B: B, C: C, case: '' };

            // SSS - Three sides
            if (a && b && c && !A && !B && !C) {
                result.case = 'SSS';
                // Law of cosines to find angles
                result.A = Math.acos((b * b + c * c - a * a) / (2 * b * c)) * 180 / Math.PI;
                result.B = Math.acos((a * a + c * c - b * b) / (2 * a * c)) * 180 / Math.PI;
                result.C = 180 - result.A - result.B;
            }
            // SAS - Two sides and included angle
            else if (a && b && C && !c) {
                result.case = 'SAS';
                result.c = Math.sqrt(a * a + b * b - 2 * a * b * Math.cos(C * Math.PI / 180));
                result.A = Math.asin(a * Math.sin(C * Math.PI / 180) / result.c) * 180 / Math.PI;
                result.B = 180 - result.A - C;
            }
            else if (a && c && B && !b) {
                result.case = 'SAS';
                result.b = Math.sqrt(a * a + c * c - 2 * a * c * Math.cos(B * Math.PI / 180));
                result.A = Math.asin(a * Math.sin(B * Math.PI / 180) / result.b) * 180 / Math.PI;
                result.C = 180 - result.A - B;
            }
            else if (b && c && A && !a) {
                result.case = 'SAS';
                result.a = Math.sqrt(b * b + c * c - 2 * b * c * Math.cos(A * Math.PI / 180));
                result.B = Math.asin(b * Math.sin(A * Math.PI / 180) / result.a) * 180 / Math.PI;
                result.C = 180 - A - result.B;
            }
            // ASA - Two angles and included side
            else if (A && B && c && !a && !b) {
                result.case = 'ASA';
                result.C = 180 - A - B;
                result.a = c * Math.sin(A * Math.PI / 180) / Math.sin(result.C * Math.PI / 180);
                result.b = c * Math.sin(B * Math.PI / 180) / Math.sin(result.C * Math.PI / 180);
            }
            else if (A && C && b && !a && !c) {
                result.case = 'ASA';
                result.B = 180 - A - C;
                result.a = b * Math.sin(A * Math.PI / 180) / Math.sin(result.B * Math.PI / 180);
                result.c = b * Math.sin(C * Math.PI / 180) / Math.sin(result.B * Math.PI / 180);
            }
            else if (B && C && a && !b && !c) {
                result.case = 'ASA';
                result.A = 180 - B - C;
                result.b = a * Math.sin(B * Math.PI / 180) / Math.sin(result.A * Math.PI / 180);
                result.c = a * Math.sin(C * Math.PI / 180) / Math.sin(result.A * Math.PI / 180);
            }
            // AAS - Two angles and non-included side
            else if (A && B && a && !b && !c) {
                result.case = 'AAS';
                result.C = 180 - A - B;
                result.b = a * Math.sin(B * Math.PI / 180) / Math.sin(A * Math.PI / 180);
                result.c = a * Math.sin(result.C * Math.PI / 180) / Math.sin(A * Math.PI / 180);
            }
            else if (A && C && a && !b && !B) {
                result.case = 'AAS';
                result.B = 180 - A - C;
                result.b = a * Math.sin(result.B * Math.PI / 180) / Math.sin(A * Math.PI / 180);
                result.c = a * Math.sin(C * Math.PI / 180) / Math.sin(A * Math.PI / 180);
            }
            else {
                return { error: 'Invalid combination of values. Try SSS, SAS, ASA, or AAS.' };
            }

            // Validate triangle inequality
            if (result.a + result.b <= result.c || result.a + result.c <= result.b || result.b + result.c <= result.a) {
                return { error: 'Invalid triangle: sides do not satisfy triangle inequality' };
            }

            return result;
        }

        function updateResults(tri) {
            // Calculate area using Heron's formula
            var s = (tri.a + tri.b + tri.c) / 2;
            var area = Math.sqrt(s * (s - tri.a) * (s - tri.b) * (s - tri.c));
            var perimeter = tri.a + tri.b + tri.c;

            // Classify triangle
            var type = '';
            if (Math.abs(tri.a - tri.b) < 0.01 && Math.abs(tri.b - tri.c) < 0.01) {
                type = 'Equilateral';
            } else if (Math.abs(tri.a - tri.b) < 0.01 || Math.abs(tri.b - tri.c) < 0.01 || Math.abs(tri.a - tri.c) < 0.01) {
                type = 'Isosceles';
            } else {
                type = 'Scalene';
            }

            if (Math.abs(tri.A - 90) < 0.1 || Math.abs(tri.B - 90) < 0.1 || Math.abs(tri.C - 90) < 0.1) {
                type += ', Right';
            } else if (tri.A > 90 || tri.B > 90 || tri.C > 90) {
                type += ', Obtuse';
            } else {
                type += ', Acute';
            }

            setEl('val-case', tri.case);
            setEl('val-area', area.toFixed(2));
            setEl('val-perimeter', perimeter.toFixed(2));
            setEl('val-type', type);
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }
    }

    VisualMath.register('triangle-solver', triangleSolverViz);
})();
