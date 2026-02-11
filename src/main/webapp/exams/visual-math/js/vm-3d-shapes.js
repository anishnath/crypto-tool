/**
 * Visual Math — 3D Shape Volume Calculator
 * Requires: vm-core.js, p5.js (WEBGL)
 */
(function () {
    'use strict';

    var state = null;
    var rotX = -0.4, rotY = 0;

    function shapes3DViz(p, container) {
        state = VisualMath.getState();
        var W, H;

        function layout() {
            W = container.clientWidth;
            H = Math.max(400, Math.min(500, W * 0.6));
        }

        p.setup = function () {
            layout();
            p.createCanvas(W, H, p.WEBGL);
        };

        p.windowResized = function () {
            layout();
            p.resizeCanvas(W, H);
        };

        p.draw = function () {
            var C = VisualMath.palette();
            p.background(C.bg);

            p.ambientLight(150);
            p.directionalLight(255, 255, 255, 0.5, 0.5, -1);
            p.directionalLight(100, 100, 100, -0.5, -0.3, 0.5);

            if (state.autoRotate) {
                rotY += 0.01;
            }

            p.rotateX(rotX);
            p.rotateY(rotY);

            var shape = state.shape || 'cube';
            var p1 = state.param1 || 5;
            var p2 = state.param2 || 5;
            var p3 = state.param3 || 5;
            var sc = 20;

            if (state.wireframe) {
                p.noFill();
                p.stroke(C.accent);
                p.strokeWeight(2);
            } else {
                p.fill(C.accent[0], C.accent[1], C.accent[2], 180);
                p.stroke(C.accent);
                p.strokeWeight(1);
            }

            if (shape === 'cube')            p.box(p1 * sc);
            else if (shape === 'cuboid')     p.box(p1 * sc, p2 * sc, p3 * sc);
            else if (shape === 'sphere')     p.sphere(p1 * sc);
            else if (shape === 'hemisphere') drawHemisphere(p1 * sc, 24);
            else if (shape === 'cylinder')   p.cylinder(p1 * sc, p2 * sc);
            else if (shape === 'cone')       p.cone(p1 * sc, p2 * sc);
            else if (shape === 'torus')      p.torus(p1 * sc, p2 * sc);
            else if (shape === 'pyramid')    drawPyramid(p1 * sc, p2 * sc);
            else if (shape === 'tetrahedron') drawTetrahedron(p1 * sc);
            else if (shape === 'octahedron')  drawOctahedron(p1 * sc);
            else if (shape === 'triangular-prism') drawTriangularPrism(p1 * sc, p2 * sc);

            updateValues(shape, p1, p2, p3);

            if (!state.autoRotate) p.noLoop();
        };

        // ---------- Custom geometry ----------

        function drawPyramid(base, height) {
            var h = base / 2;
            p.beginShape(p.TRIANGLES);
            // Base (two triangles)
            p.vertex(-h, height / 2, -h);
            p.vertex(h, height / 2, -h);
            p.vertex(h, height / 2, h);
            p.vertex(-h, height / 2, -h);
            p.vertex(h, height / 2, h);
            p.vertex(-h, height / 2, h);
            // 4 side faces
            p.vertex(0, -height / 2, 0); p.vertex(-h, height / 2, -h); p.vertex(h, height / 2, -h);
            p.vertex(0, -height / 2, 0); p.vertex(h, height / 2, -h);  p.vertex(h, height / 2, h);
            p.vertex(0, -height / 2, 0); p.vertex(h, height / 2, h);   p.vertex(-h, height / 2, h);
            p.vertex(0, -height / 2, 0); p.vertex(-h, height / 2, h);  p.vertex(-h, height / 2, -h);
            p.endShape();
        }

        function drawTetrahedron(edge) {
            // Regular tetrahedron vertices scaled to edge length
            var s = edge / (2 * Math.sqrt(2));
            var v = [
                [ s,  s,  s],
                [ s, -s, -s],
                [-s,  s, -s],
                [-s, -s,  s]
            ];
            p.beginShape(p.TRIANGLES);
            var faces = [[0,1,2],[0,1,3],[0,2,3],[1,2,3]];
            for (var i = 0; i < faces.length; i++) {
                var f = faces[i];
                p.vertex(v[f[0]][0], v[f[0]][1], v[f[0]][2]);
                p.vertex(v[f[1]][0], v[f[1]][1], v[f[1]][2]);
                p.vertex(v[f[2]][0], v[f[2]][1], v[f[2]][2]);
            }
            p.endShape();
        }

        function drawOctahedron(edge) {
            var a = edge / Math.sqrt(2);
            var v = [
                [ a, 0, 0], [-a, 0, 0],
                [0,  a, 0], [0, -a, 0],
                [0, 0,  a], [0, 0, -a]
            ];
            var faces = [
                [0,2,4],[0,4,3],[0,3,5],[0,5,2],
                [1,2,4],[1,4,3],[1,3,5],[1,5,2]
            ];
            p.beginShape(p.TRIANGLES);
            for (var i = 0; i < faces.length; i++) {
                var f = faces[i];
                p.vertex(v[f[0]][0], v[f[0]][1], v[f[0]][2]);
                p.vertex(v[f[1]][0], v[f[1]][1], v[f[1]][2]);
                p.vertex(v[f[2]][0], v[f[2]][1], v[f[2]][2]);
            }
            p.endShape();
        }

        function drawTriangularPrism(base, length) {
            // Equilateral triangle cross-section
            var h = base * Math.sqrt(3) / 2;
            var hl = length / 2;
            // 3 vertices of equilateral triangle (centered)
            var t = [
                [-base / 2, h / 3, 0],
                [ base / 2, h / 3, 0],
                [0, -2 * h / 3, 0]
            ];
            p.beginShape(p.TRIANGLES);
            // Front face
            p.vertex(t[0][0], t[0][1],  hl);
            p.vertex(t[1][0], t[1][1],  hl);
            p.vertex(t[2][0], t[2][1],  hl);
            // Back face
            p.vertex(t[0][0], t[0][1], -hl);
            p.vertex(t[2][0], t[2][1], -hl);
            p.vertex(t[1][0], t[1][1], -hl);
            // 3 rectangular side faces (each split into 2 triangles)
            for (var i = 0; i < 3; i++) {
                var j = (i + 1) % 3;
                p.vertex(t[i][0], t[i][1],  hl);
                p.vertex(t[j][0], t[j][1],  hl);
                p.vertex(t[j][0], t[j][1], -hl);
                p.vertex(t[i][0], t[i][1],  hl);
                p.vertex(t[j][0], t[j][1], -hl);
                p.vertex(t[i][0], t[i][1], -hl);
            }
            p.endShape();
        }

        function drawHemisphere(radius, detail) {
            var lat, lon;
            var steps = detail || 20;
            // Draw upper hemisphere (latitude 0 to π/2) using triangle strips
            for (lat = 0; lat < steps / 2; lat++) {
                var theta1 = (lat / steps) * Math.PI;
                var theta2 = ((lat + 1) / steps) * Math.PI;
                p.beginShape(p.TRIANGLE_STRIP);
                for (lon = 0; lon <= steps; lon++) {
                    var phi = (lon / steps) * 2 * Math.PI;
                    // Top row
                    p.vertex(
                        radius * Math.sin(theta1) * Math.cos(phi),
                        -radius * Math.cos(theta1),
                        radius * Math.sin(theta1) * Math.sin(phi)
                    );
                    // Bottom row
                    p.vertex(
                        radius * Math.sin(theta2) * Math.cos(phi),
                        -radius * Math.cos(theta2),
                        radius * Math.sin(theta2) * Math.sin(phi)
                    );
                }
                p.endShape();
            }
            // Flat bottom disc
            p.beginShape(p.TRIANGLE_FAN);
            p.vertex(0, 0, 0);
            for (lon = 0; lon <= steps; lon++) {
                var phi2 = (lon / steps) * 2 * Math.PI;
                p.vertex(radius * Math.cos(phi2), 0, radius * Math.sin(phi2));
            }
            p.endShape();
        }

        // ---------- Mouse interaction ----------

        p.mouseDragged = function () {
            if (p.mouseX > 0 && p.mouseX < W && p.mouseY > 0 && p.mouseY < H) {
                rotY += (p.mouseX - p.pmouseX) * 0.01;
                rotX += (p.mouseY - p.pmouseY) * 0.01;
                p.loop();
                return false;
            }
        };

        // ---------- Values panel ----------

        function updateValues(shape, p1, p2, p3) {
            var volume, surface, formulaV, formulaSA;
            var PI = Math.PI;

            if (shape === 'cube') {
                volume = Math.pow(p1, 3);
                surface = 6 * Math.pow(p1, 2);
                formulaV = 's\u00B3';
                formulaSA = '6s\u00B2';
            } else if (shape === 'cuboid') {
                volume = p1 * p2 * p3;
                surface = 2 * (p1 * p2 + p1 * p3 + p2 * p3);
                formulaV = 'l\u00D7w\u00D7h';
                formulaSA = '2(lw+lh+wh)';
            } else if (shape === 'sphere') {
                volume = (4 / 3) * PI * Math.pow(p1, 3);
                surface = 4 * PI * Math.pow(p1, 2);
                formulaV = '(4/3)\u03C0r\u00B3';
                formulaSA = '4\u03C0r\u00B2';
            } else if (shape === 'hemisphere') {
                volume = (2 / 3) * PI * Math.pow(p1, 3);
                surface = 3 * PI * Math.pow(p1, 2);
                formulaV = '(2/3)\u03C0r\u00B3';
                formulaSA = '3\u03C0r\u00B2';
            } else if (shape === 'cylinder') {
                volume = PI * Math.pow(p1, 2) * p2;
                surface = 2 * PI * Math.pow(p1, 2) + 2 * PI * p1 * p2;
                formulaV = '\u03C0r\u00B2h';
                formulaSA = '2\u03C0r\u00B2 + 2\u03C0rh';
            } else if (shape === 'cone') {
                volume = (1 / 3) * PI * Math.pow(p1, 2) * p2;
                var slant = Math.sqrt(p1 * p1 + p2 * p2);
                surface = PI * p1 * p1 + PI * p1 * slant;
                formulaV = '(1/3)\u03C0r\u00B2h';
                formulaSA = '\u03C0r\u00B2 + \u03C0rl';
            } else if (shape === 'torus') {
                // p1 = major radius R, p2 = tube radius r
                volume = 2 * PI * PI * p1 * p2 * p2;
                surface = 4 * PI * PI * p1 * p2;
                formulaV = '2\u03C0\u00B2Rr\u00B2';
                formulaSA = '4\u03C0\u00B2Rr';
            } else if (shape === 'pyramid') {
                volume = (1 / 3) * p1 * p1 * p2;
                var sl = Math.sqrt((p1 / 2) * (p1 / 2) + p2 * p2);
                surface = p1 * p1 + 2 * p1 * sl;
                formulaV = '(1/3)b\u00B2h';
                formulaSA = 'b\u00B2 + 2bl';
            } else if (shape === 'tetrahedron') {
                volume = (Math.sqrt(2) / 12) * Math.pow(p1, 3);
                surface = Math.sqrt(3) * Math.pow(p1, 2);
                formulaV = '(\u221A2/12)a\u00B3';
                formulaSA = '\u221A3\u00B7a\u00B2';
            } else if (shape === 'octahedron') {
                volume = (Math.sqrt(2) / 3) * Math.pow(p1, 3);
                surface = 2 * Math.sqrt(3) * Math.pow(p1, 2);
                formulaV = '(\u221A2/3)a\u00B3';
                formulaSA = '2\u221A3\u00B7a\u00B2';
            } else if (shape === 'triangular-prism') {
                // p1 = equilateral triangle side, p2 = prism length
                var triArea = (Math.sqrt(3) / 4) * p1 * p1;
                volume = triArea * p2;
                surface = 2 * triArea + 3 * p1 * p2;
                formulaV = '(\u221A3/4)a\u00B2\u00D7l';
                formulaSA = '(\u221A3/2)a\u00B2 + 3al';
            }

            setEl('val-volume', volume.toFixed(2));
            setEl('val-surface', surface.toFixed(2));
            setEl('val-formula-v', formulaV);
            setEl('val-formula-sa', formulaSA);
        }

        function setEl(id, txt) {
            var el = document.getElementById(id);
            if (el) el.textContent = txt;
        }

        // External API
        state._redraw = function () { p.loop(); };
    }

    VisualMath.register('3d-shapes', shapes3DViz);
})();
