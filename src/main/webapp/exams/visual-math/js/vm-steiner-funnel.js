/**
 * vm-steiner-funnel.js
 * Steiner Funnel — 3D visualization of Steiner circuits
 *
 * Every Steiner circuit spirals upward at most one revolution then
 * drops to the beginning of the next circuit. Radius and height of
 * the spiral correspond to the x parameter. The angle is derived
 * from 2π·n/(N+1) where N is the number of elements in the circuit.
 * A functions spiral CCW, B functions spiral CW.
 */
(function (global) {
    'use strict';

    // ── A / B point functions ───────────────────────────────────────────────
    //  Returns the 3-D position of element n inside a circuit with parameter x.
    //  baseZ  : height at which this circuit begins.
    //  dir    : +1 for A (CCW), -1 for B (CW).
    function circuitPoint(x, n, N, baseZ, dir) {
        var theta = dir * 2 * Math.PI * n / (N + 1);
        return {
            x: x * Math.cos(theta),
            y: x * Math.sin(theta),
            z: baseZ + x * (n / (N + 1))
        };
    }

    // ── Build the full list of Steiner circuits ────────────────────────────
    function buildCircuits(cfg) {
        var nc  = cfg.numCircuits;
        var circuits = [];
        var baseZ = 0;

        for (var i = 0; i < nc; i++) {
            var t  = (nc > 1) ? i / (nc - 1) : 0;
            // x decreases smoothly → funnel tapers upward
            var x  = cfg.xMax * Math.pow(1 - t, 1.15) + cfg.xMin * t;
            // circuits deeper in the funnel have more sample points
            var N  = Math.round(cfg.nMin + (cfg.nMax - cfg.nMin) * (1 - t));
            var dir = (i % 2 === 0) ? 1 : -1;          // A=CCW(+1), B=CW(-1)
            var isA = dir > 0;

            var pts = [];
            // start point: angle 0, at baseZ
            pts.push({ x: x, y: 0, z: baseZ });
            // intermediate points
            for (var ni = 1; ni <= N; ni++) {
                pts.push(circuitPoint(x, ni, N, baseZ, dir));
            }
            // end / snap point: full revolution back to angle 0, at topZ
            var topZ = baseZ + x;
            pts.push({ x: x, y: 0, z: topZ });

            circuits.push({
                index : i,
                x     : parseFloat(x.toFixed(3)),
                N     : N,
                isA   : isA,
                pts   : pts,
                baseZ : baseZ,
                topZ  : topZ
            });
            baseZ = topZ;
        }
        return circuits;
    }

    // ── p5.js sketch factory ───────────────────────────────────────────────
    function makeSketch(containerId, st) {
        // mutable closure vars (re-assigned by _replay)
        var circuits = buildCircuits(st);
        var totalPts = countPts(circuits);
        var maxZ     = circuits[circuits.length - 1].topZ;
        var maxR     = circuits[0].x;
        var SC       = 1;   // world → canvas scale (set in resize)

        function countPts(arr) {
            return arr.reduce(function (s, c) { return s + c.pts.length; }, 0);
        }

        return function (p) {
            var W, H;
            var rotX = -0.52, rotY = 0.35;
            var dragX, dragY, dragging = false;
            var revealed = 0;
            var playing  = true;

            // ── sizing ──────────────────────────────────────────────────────
            function resize() {
                var el = document.getElementById(containerId);
                W  = el ? (el.clientWidth  || 640) : 640;
                H  = Math.max(460, Math.min(580, W * 0.72));
                // scale so the whole funnel fits comfortably
                SC = Math.min(W, H) / ((maxZ + maxR * 2) || 1) * 0.52;
            }

            // ── setup ───────────────────────────────────────────────────────
            p.setup = function () {
                resize();
                p.createCanvas(W, H, p.WEBGL);
                p.colorMode(p.RGB, 255, 255, 255, 255);
                p.smooth();
                revealed = 0;
                playing  = true;
            };

            p.windowResized = function () {
                resize();
                p.resizeCanvas(W, H);
            };

            // ── main draw ───────────────────────────────────────────────────
            p.draw = function () {
                var dark = document.documentElement.getAttribute('data-theme') === 'dark';
                p.background(dark ? p.color(8, 12, 28) : p.color(244, 246, 255));

                if (st.autoRotate) rotY += 0.006;

                if (playing) {
                    revealed = Math.min(revealed + st.animSpeed, totalPts);
                    if (revealed >= totalPts) playing = false;
                }

                p.push();
                // centre the funnel vertically
                p.translate(0, maxZ * SC * 0.5, 0);
                p.rotateX(rotX);
                p.rotateY(rotY);

                drawGrid(p, dark);
                drawAxis(p, dark);
                drawAllCircuits(p, dark);

                p.pop();

                // update sidebar info panel
                updateInfoPanel(dark);
            };

            // ── floor grid ──────────────────────────────────────────────────
            function drawGrid(p, dark) {
                p.strokeWeight(0.7);
                p.stroke(128, 128, 200, dark ? 16 : 18);
                var r  = maxR * SC * 1.7;
                var gs = maxR * SC * 0.45;
                for (var i = -5; i <= 5; i++) {
                    var d = i * gs;
                    p.line(-r, 0, d,  r, 0, d);
                    p.line( d, 0, -r, d, 0, r);
                }
            }

            // ── central axis ────────────────────────────────────────────────
            function drawAxis(p, dark) {
                p.stroke(dark ? p.color(90, 90, 200, 100) : p.color(60, 60, 180, 70));
                p.strokeWeight(1.2);
                p.line(0, 0, 0, 0, -(maxZ + 0.4) * SC, 0);
                // tick marks at each circuit baseZ
                for (var ci = 0; ci < circuits.length; ci++) {
                    var yz = -circuits[ci].baseZ * SC;
                    p.strokeWeight(0.6);
                    p.line(-5, yz, 0, 5, yz, 0);
                }
            }

            // ── all circuits ─────────────────────────────────────────────────
            function drawAllCircuits(p, dark) {
                var soFar = 0;

                for (var ci = 0; ci < circuits.length; ci++) {
                    var c    = circuits[ci];
                    var skip = (c.isA && !st.showA) || (!c.isA && !st.showB);
                    var plen = c.pts.length;
                    // floor: revealed is a float; array indices must be integers
                    var show = Math.floor(Math.max(0, Math.min(plen, revealed - soFar)));

                    if (!skip && show >= 2) {
                        drawHelixSegment(p, c, show, dark);
                    }

                    // pulsing frontier sphere (leading point of the active circuit)
                    var isFront = playing && show >= 1 && !skip && (soFar + show >= Math.floor(revealed));
                    if (isFront && c.pts[show - 1]) {
                        drawFrontierSphere(p, c.pts[show - 1], c.isA, dark);
                    }

                    // drop-line between consecutive circuits once a circuit is fully drawn
                    if (!skip && show === plen && ci + 1 < circuits.length) {
                        var nc2   = circuits[ci + 1];
                        var nShow = Math.floor(Math.max(0, Math.min(nc2.pts.length, revealed - soFar - plen)));
                        if (nShow > 0) {
                            var ep = c.pts[plen - 1];
                            var sp = nc2.pts[0];
                            p.stroke(180, 180, 180, dark ? 55 : 45);
                            p.strokeWeight(0.8);
                            p.line(ep.x * SC, -ep.z * SC, ep.y * SC,
                                   sp.x * SC, -sp.z * SC, sp.y * SC);
                        }
                    }

                    soFar += plen;
                    if (soFar > Math.ceil(revealed) + 1) break;
                }
            }

            // ── single helix circuit ────────────────────────────────────────
            function drawHelixSegment(p, c, show, dark) {
                // A = cyan/blue family  |  B = orange/red family
                var rgb = c.isA
                    ? (dark ? [30, 200, 255] : [14, 130, 220])
                    : (dark ? [255, 130, 40] : [220, 70,   10]);

                // three passes: wide glow → medium glow → crisp core
                var passes = [
                    { sw: 6,   a: dark ? 40 : 25  },
                    { sw: 2.8, a: dark ? 110 : 80 },
                    { sw: 1.2, a: -1               }   // -1 = gradient per vertex
                ];

                for (var pi = 0; pi < passes.length; pi++) {
                    var pa = passes[pi];
                    p.strokeWeight(pa.sw);
                    if (pa.a >= 0) p.stroke(rgb[0], rgb[1], rgb[2], pa.a);
                    p.noFill();
                    p.beginShape();
                    for (var j = 0; j < show; j++) {
                        var pt = c.pts[j];
                        if (pa.a < 0) {
                            // gradient: dim at start → bright at end
                            var br = 60 + Math.round(195 * (j / Math.max(show - 1, 1)));
                            p.stroke(rgb[0], rgb[1], rgb[2], br);
                        }
                        p.vertex(pt.x * SC, -pt.z * SC, pt.y * SC);
                    }
                    p.endShape();
                }

                // small node spheres at each sample point (only for sparser circuits)
                if (show <= 16) {
                    p.noStroke();
                    p.fill(rgb[0], rgb[1], rgb[2], 210);
                    for (var k = 0; k < show; k++) {
                        var sp2 = c.pts[k];
                        p.push();
                        p.translate(sp2.x * SC, -sp2.z * SC, sp2.y * SC);
                        p.sphere(2.8);
                        p.pop();
                    }
                }
            }

            // ── pulsing frontier sphere ─────────────────────────────────────
            function drawFrontierSphere(p, pt, isA, dark) {
                var rgb = isA
                    ? (dark ? [30, 220, 255] : [14, 130, 220])
                    : (dark ? [255, 150, 50] : [234, 88,   12]);
                var pulse = 4.5 + 2.5 * Math.sin(p.frameCount * 0.09);

                p.push();
                p.translate(pt.x * SC, -pt.z * SC, pt.y * SC);
                p.noStroke();
                p.fill(rgb[0], rgb[1], rgb[2], 55);
                p.sphere(pulse * 2.6);
                p.fill(rgb[0], rgb[1], rgb[2], 200);
                p.sphere(pulse);
                p.pop();
            }

            // ── info-panel update (DOM, not p5 canvas) ──────────────────────
            function updateInfoPanel() {
                var el = document.getElementById('sf-info');
                if (!el) return;

                var soFar = 0, ac = null;
                for (var ci = 0; ci < circuits.length; ci++) {
                    soFar += circuits[ci].pts.length;
                    if (soFar >= revealed) { ac = circuits[ci]; break; }
                }
                if (!ac) ac = circuits[circuits.length - 1];

                var typeLabel = ac.isA ? 'A Circuit' : 'B Circuit';
                var thetaFmt  = '2&pi;&middot;n / ' + (ac.N + 1);
                var dirLabel  = ac.isA ? 'CCW (+)' : 'CW (&minus;)';

                el.innerHTML =
                    '<div class="sf-info-chip ' + (ac.isA ? 'sf-a' : 'sf-b') + '">' + typeLabel + '</div>' +
                    '<table class="sf-info-table">' +
                    '<tr><th>x</th><td>' + ac.x + '</td></tr>' +
                    '<tr><th>N</th><td>' + ac.N + '</td></tr>' +
                    '<tr><th>&theta;</th><td>' + thetaFmt + '</td></tr>' +
                    '<tr><th>dir</th><td>' + dirLabel + '</td></tr>' +
                    '<tr><th>m</th><td>&asymp; ' + ac.x + '</td></tr>' +
                    '</table>';
            }

            // ── mouse / touch drag ──────────────────────────────────────────
            p.mousePressed = function () {
                if (p.mouseX >= 0 && p.mouseX <= W && p.mouseY >= 0 && p.mouseY <= H) {
                    dragging = true;
                    dragX = p.mouseX; dragY = p.mouseY;
                    st.autoRotate = false;
                    var rb = document.getElementById('btn-rotate');
                    if (rb) { rb.classList.remove('viz-btn-primary'); rb.classList.add('viz-btn-secondary'); }
                }
            };
            p.mouseReleased = function () { dragging = false; };
            p.mouseDragged  = function () {
                if (dragging) {
                    rotY += (p.mouseX - dragX) * 0.013;
                    rotX += (p.mouseY - dragY) * 0.013;
                    rotX  = Math.max(-1.45, Math.min(1.45, rotX));
                    dragX = p.mouseX; dragY = p.mouseY;
                }
            };
            p.touchStarted = function () {
                if (p.touches && p.touches.length === 1) {
                    dragging = true;
                    dragX = p.touches[0].x; dragY = p.touches[0].y;
                    st.autoRotate = false;
                    return false;
                }
            };
            p.touchMoved = function () {
                if (dragging && p.touches && p.touches.length === 1) {
                    rotY += (p.touches[0].x - dragX) * 0.013;
                    rotX += (p.touches[0].y - dragY) * 0.013;
                    dragX = p.touches[0].x; dragY = p.touches[0].y;
                    return false;
                }
            };
            p.touchEnded = function () { dragging = false; };

            // ── public replay API ───────────────────────────────────────────
            st._replay = function () {
                circuits = buildCircuits(st);
                totalPts = countPts(circuits);
                maxZ     = circuits[circuits.length - 1].topZ;
                maxR     = circuits[0].x;
                resize();
                revealed = 0;
                playing  = true;
            };
        };
    }

    // ── Public API ──────────────────────────────────────────────────────────
    global.SteinerFunnel = {
        init: function (containerId, options) {
            var defaults = {
                numCircuits : 8,
                xMax        : 3.0,
                xMin        : 0.25,
                nMin        : 3,
                nMax        : 9,
                animSpeed   : 1.2,
                showA       : true,
                showB       : true,
                autoRotate  : true,
                _replay     : null
            };
            var st = Object.assign({}, defaults, options || {});
            var container = document.getElementById(containerId);
            new p5(makeSketch(containerId, st), container);
            return st;
        }
    };

}(window));
