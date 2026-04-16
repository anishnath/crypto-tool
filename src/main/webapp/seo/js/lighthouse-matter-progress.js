/**
 * "Building the report" Matter.js animation for the Lighthouse progress screen.
 *
 * Shapes fall from above and pile up on a floor, accumulating over 30-90s.
 * Phase 1 (queued):  slow trickle of small dots — "waiting"
 * Phase 2 (running): faster stream of gauge circles, metric chips, score bars — "gathering data"
 * Phase 3 (done):    burst of green shapes, then stop
 *
 * Exposed as window.LighthouseProgressBg.start() / .stop() / .setPhase('queued'|'running'|'done')
 */
(function () {
    'use strict';

    var hostId = 'lh-progress-matter';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var engine, render, runner;
    var walls = [];
    var spawnTimer, resizeTimer;
    var started = false;
    var phase = 'queued'; // queued | running | done
    var maxBodies = 120;

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    // ── Palettes per phase ──

    function queuedPalette() {
        var a = themeIsDark() ? 0.25 : 0.18;
        return {
            fills: [
                'rgba(148, 163, 184, ' + a + ')',  // slate
                'rgba(99, 102, 241, ' + (a * 0.7) + ')',   // indigo hint
                'rgba(139, 92, 246, ' + (a * 0.6) + ')'    // violet hint
            ],
            stroke: 'rgba(148, 163, 184, ' + (a * 0.5) + ')'
        };
    }

    function runningPalette() {
        var a = themeIsDark() ? 0.35 : 0.25;
        return {
            fills: [
                'rgba(13, 128, 67, ' + a + ')',     // Lighthouse green
                'rgba(230, 119, 0, ' + (a * 0.85) + ')',   // Lighthouse orange
                'rgba(199, 34, 31, ' + (a * 0.7) + ')',    // Lighthouse red
                'rgba(99, 102, 241, ' + (a * 0.8) + ')',   // indigo
                'rgba(139, 92, 246, ' + (a * 0.7) + ')',   // violet
                'rgba(59, 130, 246, ' + (a * 0.6) + ')'    // blue
            ],
            stroke: 'rgba(99, 102, 241, ' + (a * 0.4) + ')'
        };
    }

    function donePalette() {
        var a = themeIsDark() ? 0.4 : 0.3;
        return {
            fills: [
                'rgba(13, 128, 67, ' + a + ')',
                'rgba(34, 197, 94, ' + a + ')',
                'rgba(16, 185, 129, ' + a + ')'
            ],
            stroke: 'rgba(13, 128, 67, ' + (a * 0.5) + ')'
        };
    }

    function currentPalette() {
        if (phase === 'done') return donePalette();
        if (phase === 'running') return runningPalette();
        return queuedPalette();
    }

    function pick(arr) { return arr[Math.floor(Math.random() * arr.length)]; }

    function countDynamic(world) {
        var all = Matter.Composite.allBodies(world);
        var n = 0;
        for (var i = 0; i < all.length; i++) { if (!all[i].isStatic) n++; }
        return n;
    }

    // ── Spawn shapes based on phase ──

    function spawnOne(w) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= maxBodies) return;

        var B = Matter.Bodies;
        var r = Math.random;
        var pal = currentPalette();
        var fill = pick(pal.fills);
        var stroke = pal.stroke;
        var x = 80 + r() * (w - 160); // avoid edges
        var y = -20 - r() * 60;
        var body;

        if (phase === 'queued') {
            // Small dots only — waiting state
            body = B.circle(x, y, 3 + r() * 6, {
                restitution: 0.3,
                frictionAir: 0.015,
                friction: 0.3,
                label: 'dot',
                render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 0.5 }
            });
        } else if (phase === 'done') {
            // Celebration burst — green circles
            body = B.circle(x, y, 6 + r() * 14, {
                restitution: 0.5,
                frictionAir: 0.01,
                friction: 0.2,
                label: 'celebrate',
                render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 1 }
            });
        } else {
            // Running — diverse Lighthouse shapes
            var rnd = r();

            if (rnd < 0.25) {
                // Gauge circle (pass/warn/fail)
                body = B.circle(x, y, 10 + r() * 14, {
                    restitution: 0.2,
                    frictionAir: 0.012,
                    friction: 0.4,
                    label: 'gauge',
                    render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 1.5 }
                });
            } else if (rnd < 0.45) {
                // Metric chip
                body = B.rectangle(x, y, 36 + r() * 40, 12 + r() * 8, {
                    chamfer: { radius: 5 },
                    angle: (r() - 0.5) * 0.3,
                    restitution: 0.15,
                    frictionAir: 0.015,
                    friction: 0.5,
                    label: 'chip',
                    render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 1 }
                });
            } else if (rnd < 0.6) {
                // Score bar
                body = B.rectangle(x, y, 50 + r() * 70, 4 + r() * 4, {
                    chamfer: { radius: 2 },
                    angle: (r() - 0.5) * 0.15,
                    restitution: 0.1,
                    frictionAir: 0.018,
                    friction: 0.6,
                    label: 'bar',
                    render: { fillStyle: fill, strokeStyle: 'transparent', lineWidth: 0 }
                });
            } else if (rnd < 0.75) {
                // Hollow ring — gauge outline
                body = B.circle(x, y, 8 + r() * 12, {
                    restitution: 0.25,
                    frictionAir: 0.014,
                    friction: 0.3,
                    label: 'ring',
                    render: { fillStyle: 'transparent', strokeStyle: fill, lineWidth: 2 }
                });
            } else if (rnd < 0.88) {
                // Small triangle — fail marker
                body = B.polygon(x, y, 3, 8 + r() * 8, {
                    restitution: 0.2,
                    frictionAir: 0.016,
                    friction: 0.4,
                    label: 'triangle',
                    render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 1 }
                });
            } else {
                // Tiny data dot
                body = B.circle(x, y, 3 + r() * 5, {
                    restitution: 0.35,
                    frictionAir: 0.01,
                    friction: 0.3,
                    label: 'dot',
                    render: { fillStyle: fill, strokeStyle: 'transparent', lineWidth: 0 }
                });
            }
        }

        Matter.Composite.add(engine.world, body);
    }

    // ── Walls (floor + sides) ──

    function buildWalls(w, h) {
        var B = Matter.Bodies;
        var C = Matter.Composite;
        var thick = 60;
        var opts = { isStatic: true, render: { visible: false } };

        walls.forEach(function (wall) { C.remove(engine.world, wall); });
        walls = [
            B.rectangle(w / 2, h + thick / 2 - 10, w + 200, thick, opts),  // floor (slightly above bottom)
            B.rectangle(-thick / 2, h / 2, thick, h + 200, opts),           // left
            B.rectangle(w + thick / 2, h / 2, thick, h + 200, opts)         // right
        ];
        walls.forEach(function (wall) { C.add(engine.world, wall); });
    }

    // ── Spawn rate based on phase ──

    function spawnInterval() {
        if (phase === 'done') return 150;     // rapid burst
        if (phase === 'running') return 800;  // steady stream
        return 2000;                           // slow trickle
    }

    function restartSpawnTimer(w) {
        if (spawnTimer) clearInterval(spawnTimer);
        spawnTimer = setInterval(function () {
            if (document.hidden) return;
            spawnOne(w);
        }, spawnInterval());
    }

    // ── Init / lifecycle ──

    function init() {
        if (typeof Matter === 'undefined') return;
        if (mqReduce.matches) return;
        if (started) return;

        var host = document.getElementById(hostId);
        if (!host) return;

        var section = document.getElementById('lh-progress-section');
        var w = section ? section.clientWidth : window.innerWidth;
        var h = section ? section.clientHeight : window.innerHeight;
        if (h < 300) h = Math.max(window.innerHeight - 100, 400);

        engine = Matter.Engine.create({ gravity: { x: 0, y: 0.6 } });

        render = Matter.Render.create({
            element: host,
            engine: engine,
            options: {
                width: w,
                height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: Math.min(window.devicePixelRatio || 1, 2)
            }
        });

        buildWalls(w, h);

        // Gentle horizontal sway
        var timeOrigin = Date.now();
        Matter.Events.on(engine, 'beforeUpdate', function () {
            var t = (Date.now() - timeOrigin) / 1000;
            var sway = Math.sin(t * 0.2) * 0.0002;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: sway, y: 0 });
                }
            }
        });

        // Seed a few initial shapes
        for (var i = 0; i < 5; i++) {
            spawnOne(w);
            var bodies = Matter.Composite.allBodies(engine.world);
            var last = bodies[bodies.length - 1];
            if (last && !last.isStatic) {
                Matter.Body.setPosition(last, {
                    x: 80 + Math.random() * (w - 160),
                    y: h * 0.5 + Math.random() * (h * 0.4)
                });
            }
        }

        restartSpawnTimer(w);

        runner = Matter.Runner.create();
        Matter.Render.run(render);
        Matter.Runner.run(runner, engine);
        started = true;

        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () {
                var sec = document.getElementById('lh-progress-section');
                var nw = sec ? sec.clientWidth : window.innerWidth;
                var nh = sec ? sec.clientHeight : window.innerHeight;
                if (nh < 300) nh = Math.max(window.innerHeight - 100, 400);
                render.canvas.width = nw;
                render.canvas.height = nh;
                render.options.width = nw;
                render.options.height = nh;
                buildWalls(nw, nh);
                restartSpawnTimer(nw);
            }, 200);
        });

        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) Matter.Runner.stop(runner);
            else Matter.Runner.run(runner, engine);
        });

        // React to theme changes
        var obs = new MutationObserver(function () {
            // Existing bodies keep their color; new ones pick up new palette
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    function stop() {
        if (runner) Matter.Runner.stop(runner);
        if (render) Matter.Render.stop(render);
        if (spawnTimer) clearInterval(spawnTimer);
        spawnTimer = null;
        // Clear all bodies for a fresh start next time
        if (engine && engine.world) {
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = bodies.length - 1; i >= 0; i--) {
                if (!bodies[i].isStatic) {
                    Matter.Composite.remove(engine.world, bodies[i]);
                }
            }
        }
        started = false;
        // Remove the canvas
        var host = document.getElementById(hostId);
        if (host) host.innerHTML = '';
        engine = null;
        render = null;
        runner = null;
        walls = [];
        phase = 'queued';
    }

    function setPhase(newPhase) {
        if (newPhase === phase) return;
        phase = newPhase;
        if (!started) return;

        var section = document.getElementById('lh-progress-section');
        var w = section ? section.clientWidth : window.innerWidth;
        restartSpawnTimer(w);

        // On "done", fire a quick burst
        if (phase === 'done') {
            for (var i = 0; i < 15; i++) {
                spawnOne(w);
            }
            // Stop spawning after the burst
            setTimeout(function () {
                if (spawnTimer) clearInterval(spawnTimer);
            }, 1500);
        }
    }

    window.LighthouseProgressBg = {
        start: function () {
            phase = 'queued';
            if (started) return;
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 100); });
            } else {
                setTimeout(init, 100);
            }
        },
        stop: stop,
        setPhase: setPhase
    };
})();
