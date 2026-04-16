/**
 * Ambient Matter.js background for Lighthouse results page.
 * Soft floating particles that rise slowly — like data streaming upward.
 * Very subtle, no gravity, gentle drift. Completely different from the hero bg.
 */
(function () {
    'use strict';

    var hostId = 'lh-results-matter';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var maxBodies = 40;
    var engine, render, runner;
    var walls = [];
    var spawnTimer, resizeTimer;
    var started = false;

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    function palette() {
        if (themeIsDark()) {
            return [
                'rgba(99, 102, 241, 0.07)',   // indigo
                'rgba(139, 92, 246, 0.06)',    // violet
                'rgba(59, 130, 246, 0.06)',    // blue
                'rgba(14, 165, 233, 0.05)',    // sky
                'rgba(236, 72, 153, 0.04)',    // pink
                'rgba(13, 128, 67, 0.05)',     // green
                'rgba(230, 119, 0, 0.04)'      // orange
            ];
        }
        return [
            'rgba(99, 102, 241, 0.05)',
            'rgba(139, 92, 246, 0.04)',
            'rgba(59, 130, 246, 0.04)',
            'rgba(14, 165, 233, 0.035)',
            'rgba(236, 72, 153, 0.03)',
            'rgba(13, 128, 67, 0.035)',
            'rgba(230, 119, 0, 0.03)'
        ];
    }

    function pick(arr) { return arr[Math.floor(Math.random() * arr.length)]; }

    function countDynamic(world) {
        var all = Matter.Composite.allBodies(world);
        var n = 0;
        for (var i = 0; i < all.length; i++) { if (!all[i].isStatic) n++; }
        return n;
    }

    function spawnOne(w, h) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= maxBodies) return;

        var B = Matter.Bodies;
        var r = Math.random;
        var pal = palette();
        var fill = pick(pal);
        var strokeAlpha = themeIsDark() ? 0.08 : 0.05;
        var stroke = 'rgba(148, 163, 184, ' + strokeAlpha + ')';

        var x = r() * w;
        var y = h + 20 + r() * 40; // start below viewport
        var rnd = r();
        var body;

        if (rnd < 0.35) {
            // Soft circle — like a data point
            body = B.circle(x, y, 4 + r() * 12, {
                frictionAir: 0.01 + r() * 0.02,
                label: 'particle',
                render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 0.5 }
            });
        } else if (rnd < 0.55) {
            // Tiny ring — hollow circle
            var radius = 6 + r() * 10;
            body = B.circle(x, y, radius, {
                frictionAir: 0.012 + r() * 0.02,
                label: 'ring',
                render: { fillStyle: 'transparent', strokeStyle: fill, lineWidth: 1.5 }
            });
        } else if (rnd < 0.75) {
            // Small rounded rect — like a metric chip
            body = B.rectangle(x, y, 20 + r() * 30, 8 + r() * 6, {
                chamfer: { radius: 4 },
                angle: r() * Math.PI * 2,
                frictionAir: 0.015 + r() * 0.02,
                label: 'chip',
                render: { fillStyle: fill, strokeStyle: stroke, lineWidth: 0.5 }
            });
        } else if (rnd < 0.9) {
            // Thin line — like a score bar fragment
            body = B.rectangle(x, y, 30 + r() * 50, 2 + r() * 2, {
                chamfer: { radius: 1 },
                angle: r() * Math.PI,
                frictionAir: 0.018 + r() * 0.02,
                label: 'line',
                render: { fillStyle: fill, strokeStyle: 'transparent', lineWidth: 0 }
            });
        } else {
            // Tiny dot
            body = B.circle(x, y, 2 + r() * 3, {
                frictionAir: 0.008 + r() * 0.015,
                label: 'dot',
                render: { fillStyle: fill, strokeStyle: 'transparent', lineWidth: 0 }
            });
        }

        Matter.Composite.add(engine.world, body);
    }

    function buildWalls(w, h) {
        var B = Matter.Bodies;
        var C = Matter.Composite;
        var thick = 60;
        var opts = { isStatic: true, render: { visible: false } };

        walls.forEach(function (wall) { C.remove(engine.world, wall); });
        // Ceiling catches rising particles, side walls contain them
        walls = [
            B.rectangle(w / 2, -thick / 2, w + 200, thick, opts),        // ceiling
            B.rectangle(-thick / 2, h / 2, thick, h + 200, opts),         // left
            B.rectangle(w + thick / 2, h / 2, thick, h + 200, opts)       // right
        ];
        walls.forEach(function (wall) { C.add(engine.world, wall); });
    }

    function recolorAll() {
        if (!engine || !engine.world) return;
        var pal = palette();
        var strokeAlpha = themeIsDark() ? 0.08 : 0.05;
        var stroke = 'rgba(148, 163, 184, ' + strokeAlpha + ')';
        var bodies = Matter.Composite.allBodies(engine.world);
        for (var i = 0; i < bodies.length; i++) {
            var b = bodies[i];
            if (b.isStatic) continue;
            var fill = pick(pal);
            if (b.label === 'ring') {
                b.render.fillStyle = 'transparent';
                b.render.strokeStyle = fill;
            } else {
                b.render.fillStyle = fill;
                b.render.strokeStyle = b.label === 'line' || b.label === 'dot' ? 'transparent' : stroke;
            }
        }
    }

    function init() {
        if (typeof Matter === 'undefined') return;
        if (mqReduce.matches) return;
        if (started) return;

        var host = document.getElementById(hostId);
        if (!host) return;

        var w = window.innerWidth;
        var h = window.innerHeight;

        // Negative gravity — particles float upward
        engine = Matter.Engine.create({ gravity: { x: 0, y: -0.08 } });

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
            var sway = Math.sin(t * 0.08) * 0.00012;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: sway, y: 0 });
                }
            }
            // Remove particles that float above viewport
            for (var j = bodies.length - 1; j >= 0; j--) {
                if (!bodies[j].isStatic && bodies[j].position.y < -80) {
                    Matter.Composite.remove(engine.world, bodies[j]);
                }
            }
        });

        // Seed initial particles spread across the viewport
        for (var i = 0; i < 20; i++) {
            spawnOne(w, h);
            var bodies = Matter.Composite.allBodies(engine.world);
            var last = bodies[bodies.length - 1];
            if (last && !last.isStatic) {
                Matter.Body.setPosition(last, {
                    x: Math.random() * w,
                    y: Math.random() * h
                });
            }
        }

        spawnTimer = setInterval(function () {
            if (document.hidden) return;
            spawnOne(w, h);
        }, 2000);

        runner = Matter.Runner.create();
        Matter.Render.run(render);
        Matter.Runner.run(runner, engine);
        started = true;

        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () {
                var nw = window.innerWidth;
                var nh = window.innerHeight;
                render.canvas.width = nw;
                render.canvas.height = nh;
                render.options.width = nw;
                render.options.height = nh;
                buildWalls(nw, nh);
            }, 200);
        });

        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) Matter.Runner.stop(runner);
            else Matter.Runner.run(runner, engine);
        });

        // React to theme changes
        var obs = new MutationObserver(function () { recolorAll(); });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    // Expose start/stop so lighthouse.js can control it
    window.LighthouseResultsBg = {
        start: function () {
            if (started) return;
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 200); });
            } else {
                setTimeout(init, 200);
            }
        },
        stop: function () {
            if (runner) Matter.Runner.stop(runner);
            if (spawnTimer) clearInterval(spawnTimer);
        },
        resume: function () {
            if (runner && engine) Matter.Runner.run(runner, engine);
        }
    };
})();
