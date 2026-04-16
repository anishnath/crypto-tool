/**
 * Decorative Matter.js background for Lighthouse hero.
 * Lighthouse-themed shapes: gauge arcs, metric chips, dots, score bars.
 * Skips when prefers-reduced-motion; pauses when tab hidden.
 */
(function () {
    'use strict';

    var hostId = 'lh-matter-host';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var maxBodies = 26;
    var spawnTimer;

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    // Lighthouse score colors (green/orange/red) + nav-theme violet/indigo/pink accents
    function palette() {
        if (themeIsDark()) {
            return {
                pass:    'rgba(13, 128, 67, 0.22)',     // Lighthouse green
                warn:    'rgba(230, 119, 0, 0.20)',     // Lighthouse orange
                fail:    'rgba(199, 34, 31, 0.18)',     // Lighthouse red
                cyan:    'rgba(167, 139, 250, 0.22)',   // (violet, legacy key name)
                indigo:  'rgba(99, 102, 241, 0.18)',
                pink:    'rgba(236, 72, 153, 0.14)',
                dot:     'rgba(167, 139, 250, 0.20)',
                stroke:  'rgba(167, 139, 250, 0.30)',
                strokeS: 'rgba(148, 163, 184, 0.15)'
            };
        }
        return {
            pass:    'rgba(13, 128, 67, 0.20)',
            warn:    'rgba(230, 119, 0, 0.18)',
            fail:    'rgba(199, 34, 31, 0.16)',
            cyan:    'rgba(139, 92, 246, 0.22)',        // violet
            indigo:  'rgba(79, 70, 229, 0.16)',
            pink:    'rgba(236, 72, 153, 0.14)',
            dot:     'rgba(139, 92, 246, 0.24)',
            stroke:  'rgba(139, 92, 246, 0.35)',
            strokeS: 'rgba(100, 116, 139, 0.18)'
        };
    }

    function styleFor(label, pal, body) {
        var seed = body && typeof body.id === 'number' ? body.id : 0;
        var fill;
        switch (label) {
            case 'lh-gauge-pass': fill = pal.pass; break;
            case 'lh-gauge-warn': fill = pal.warn; break;
            case 'lh-gauge-fail': fill = pal.fail; break;
            case 'lh-metric':     fill = [pal.cyan, pal.indigo, pal.pink][Math.abs(seed) % 3]; break;
            case 'lh-bar':        fill = pal.cyan; break;
            case 'lh-dot':        fill = pal.dot; break;
            default: fill = pal.cyan;
        }
        return {
            fill: fill,
            stroke: label === 'lh-dot' ? pal.strokeS : pal.stroke,
            lw: label === 'lh-dot' ? 0.5 : 1
        };
    }

    function colorAll(world, pal) {
        var bodies = Matter.Composite.allBodies(world);
        for (var i = 0; i < bodies.length; i++) {
            var b = bodies[i];
            if (b.isStatic) continue;
            if (!b.render) b.render = {};
            var st = styleFor(b.label, pal, b);
            b.render.fillStyle = st.fill;
            b.render.strokeStyle = st.stroke;
            b.render.lineWidth = st.lw;
        }
    }

    function countDynamic(world) {
        var all = Matter.Composite.allBodies(world);
        var n = 0;
        for (var i = 0; i < all.length; i++) { if (!all[i].isStatic) n++; }
        return n;
    }

    var engine, render, runner, walls = [];
    var resizeTimer;

    function spawnOne(w, pal) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= maxBodies) return;

        var B = Matter.Bodies;
        var C = Matter.Composite;
        var r = Math.random;
        var x = r() * w;
        var y = -30 - r() * 50;
        var rnd = r();
        var body;

        if (rnd < 0.20) {
            // Score gauge — pass (green)
            body = B.circle(x, y, 14 + r() * 8, {
                restitution: 0.12,
                frictionAir: 0.04,
                label: 'lh-gauge-pass',
                render: { lineWidth: 1.5 }
            });
        } else if (rnd < 0.35) {
            // Score gauge — warn (orange)
            body = B.circle(x, y, 12 + r() * 6, {
                restitution: 0.12,
                frictionAir: 0.042,
                label: 'lh-gauge-warn',
                render: { lineWidth: 1.5 }
            });
        } else if (rnd < 0.45) {
            // Score gauge — fail (red), less common
            body = B.circle(x, y, 10 + r() * 6, {
                restitution: 0.12,
                frictionAir: 0.044,
                label: 'lh-gauge-fail',
                render: { lineWidth: 1.5 }
            });
        } else if (rnd < 0.65) {
            // Metric chip — represents LCP, FCP, CLS, etc
            body = B.rectangle(x, y, 50 + r() * 40, 18 + r() * 8, {
                chamfer: { radius: 6 },
                angle: r() * 0.4,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'lh-metric',
                render: { lineWidth: 1 }
            });
        } else if (rnd < 0.85) {
            // Bar — represents a score bar
            body = B.rectangle(x, y, 70 + r() * 60, 6 + r() * 4, {
                chamfer: { radius: 3 },
                angle: r() * 0.2,
                restitution: 0.08,
                frictionAir: 0.045,
                label: 'lh-bar',
                render: { lineWidth: 1 }
            });
        } else {
            // Small dot — data point
            body = B.circle(x, y, 3 + r() * 5, {
                restitution: 0.15,
                frictionAir: 0.03,
                label: 'lh-dot',
                render: { lineWidth: 0.5 }
            });
        }

        var st = styleFor(body.label, pal, body);
        body.render.fillStyle = st.fill;
        body.render.strokeStyle = st.stroke;
        body.render.lineWidth = st.lw;
        C.add(engine.world, body);
    }

    function buildWalls(w, h) {
        var B = Matter.Bodies;
        var C = Matter.Composite;
        var thick = 60;
        var opts = { isStatic: true, render: { visible: false } };

        walls.forEach(function(wall) { C.remove(engine.world, wall); });

        walls = [
            B.rectangle(w / 2, h + thick / 2, w + 200, thick, opts),  // floor
            B.rectangle(-thick / 2, h / 2, thick, h + 200, opts),      // left
            B.rectangle(w + thick / 2, h / 2, thick, h + 200, opts)    // right
        ];
        walls.forEach(function(wall) { C.add(engine.world, wall); });
    }

    function init() {
        if (typeof Matter === 'undefined') return;
        if (mqReduce.matches) return;

        var host = document.getElementById(hostId);
        if (!host) return;

        var w = host.clientWidth || window.innerWidth;
        var h = host.clientHeight || window.innerHeight;

        engine = Matter.Engine.create({ gravity: { x: 0, y: 0.25 } });

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

        // Gentle wind
        var timeOrigin = Date.now();
        Matter.Events.on(engine, 'beforeUpdate', function () {
            var t = (Date.now() - timeOrigin) / 1000;
            var windX = Math.sin(t * 0.15) * 0.0003;
            var windY = Math.cos(t * 0.1) * 0.00015;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: windX, y: windY });
                }
            }
            for (var j = bodies.length - 1; j >= 0; j--) {
                if (!bodies[j].isStatic && bodies[j].position.y > h + 100) {
                    Matter.Composite.remove(engine.world, bodies[j]);
                }
            }
        });

        var pal = palette();
        for (var i = 0; i < 14; i++) {
            spawnOne(w, pal);
            var bodies = Matter.Composite.allBodies(engine.world);
            var last = bodies[bodies.length - 1];
            if (last && !last.isStatic) {
                Matter.Body.setPosition(last, { x: last.position.x, y: Math.random() * h * 0.8 });
            }
        }

        spawnTimer = setInterval(function () {
            if (document.hidden) return;
            spawnOne(w, palette());
        }, 3000);

        runner = Matter.Runner.create();
        Matter.Render.run(render);
        Matter.Runner.run(runner, engine);

        var onResize = function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () {
                var nw = host.clientWidth || window.innerWidth;
                var nh = host.clientHeight || window.innerHeight;
                render.canvas.width = nw;
                render.canvas.height = nh;
                render.options.width = nw;
                render.options.height = nh;
                buildWalls(nw, nh);
            }, 200);
        };
        window.addEventListener('resize', onResize);

        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) Matter.Runner.stop(runner);
            else Matter.Runner.run(runner, engine);
        });

        var obs = new MutationObserver(function () {
            colorAll(engine.world, palette());
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 100); });
    } else {
        setTimeout(init, 100);
    }
})();
