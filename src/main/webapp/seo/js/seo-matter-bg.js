/**
 * Decorative Matter.js background for SEO Checker hero —
 * Floating SEO-themed shapes: tag chips, link icons, dots, shards.
 * Skips when prefers-reduced-motion; pauses when tab hidden.
 */
(function () {
    'use strict';

    var hostId = 'seo-matter-host';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var maxBodies = 28;
    var spawnTimer;

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    function palette() {
        if (themeIsDark()) {
            return {
                tagA:    'rgba(99, 102, 241, 0.18)',
                tagB:    'rgba(129, 140, 248, 0.14)',
                pill:    'rgba(139, 92, 246, 0.15)',
                dot:     'rgba(99, 102, 241, 0.20)',
                shard:   'rgba(167, 139, 250, 0.12)',
                accent:  'rgba(52, 211, 153, 0.18)',
                stroke:  'rgba(129, 140, 248, 0.30)',
                strokeS: 'rgba(148, 163, 184, 0.15)'
            };
        }
        return {
            tagA:    'rgba(99, 102, 241, 0.22)',
            tagB:    'rgba(79, 70, 229, 0.16)',
            pill:    'rgba(139, 92, 246, 0.18)',
            dot:     'rgba(99, 102, 241, 0.24)',
            shard:   'rgba(167, 139, 250, 0.14)',
            accent:  'rgba(16, 185, 129, 0.20)',
            stroke:  'rgba(99, 102, 241, 0.35)',
            strokeS: 'rgba(100, 116, 139, 0.18)'
        };
    }

    function styleFor(label, pal, body) {
        var seed = body && typeof body.id === 'number' ? body.id : 0;
        var fill;
        switch (label) {
            case 'seo-tag':   fill = [pal.tagA, pal.tagB][Math.abs(seed) % 2]; break;
            case 'seo-pill':  fill = pal.pill; break;
            case 'seo-dot':   fill = pal.dot; break;
            case 'seo-shard': fill = pal.shard; break;
            case 'seo-accent': fill = pal.accent; break;
            default: fill = pal.tagA;
        }
        return {
            fill: fill,
            stroke: label === 'seo-dot' ? pal.strokeS : pal.stroke,
            lw: label === 'seo-dot' ? 0.5 : 1
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

        if (rnd < 0.30) {
            // Tag chip — represents <title>, <meta>, <h1> etc
            body = B.rectangle(x, y, 40 + r() * 50, 16 + r() * 12, {
                chamfer: { radius: 6 },
                angle: r() * Math.PI * 2,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'seo-tag',
                render: { lineWidth: 1 }
            });
        } else if (rnd < 0.50) {
            // Pill — represents a link/URL
            body = B.rectangle(x, y, 60 + r() * 80, 8 + r() * 6, {
                chamfer: { radius: 4 },
                angle: r() * 0.3,
                restitution: 0.08,
                frictionAir: 0.045,
                label: 'seo-pill',
                render: { lineWidth: 1 }
            });
        } else if (rnd < 0.70) {
            // Small dot — data point
            body = B.circle(x, y, 4 + r() * 6, {
                restitution: 0.15,
                frictionAir: 0.03,
                label: 'seo-dot',
                render: { lineWidth: 0.5 }
            });
        } else if (rnd < 0.85) {
            // Triangle shard — represents broken/warning
            body = B.polygon(x, y, 3, 12 + r() * 16, {
                angle: r() * Math.PI * 2,
                restitution: 0.12,
                frictionAir: 0.042,
                label: 'seo-shard',
                render: { lineWidth: 1 }
            });
        } else {
            // Hexagon — represents checkmark/shield
            body = B.polygon(x, y, 6, 10 + r() * 12, {
                angle: r() * Math.PI,
                restitution: 0.1,
                frictionAir: 0.038,
                label: 'seo-accent',
                render: { lineWidth: 1 }
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

        // Remove old walls
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
        var tickHandler = function () {
            var t = (Date.now() - timeOrigin) / 1000;
            var windX = Math.sin(t * 0.15) * 0.0003;
            var windY = Math.cos(t * 0.1) * 0.00015;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: windX, y: windY });
                }
            }

            // Cull bodies that fell below the floor
            for (var j = bodies.length - 1; j >= 0; j--) {
                if (!bodies[j].isStatic && bodies[j].position.y > h + 100) {
                    Matter.Composite.remove(engine.world, bodies[j]);
                }
            }
        };
        var timeOrigin = Date.now();
        Matter.Events.on(engine, 'beforeUpdate', tickHandler);

        // Spawn initial batch
        var pal = palette();
        for (var i = 0; i < 14; i++) {
            spawnOne(w, pal);
            // Spread initial bodies vertically
            var bodies = Matter.Composite.allBodies(engine.world);
            var last = bodies[bodies.length - 1];
            if (last && !last.isStatic) {
                Matter.Body.setPosition(last, { x: last.position.x, y: Math.random() * h * 0.8 });
            }
        }

        // Periodic spawns
        spawnTimer = setInterval(function () {
            if (document.hidden) return;
            spawnOne(w, palette());
        }, 3000);

        runner = Matter.Runner.create();
        Matter.Render.run(render);
        Matter.Runner.run(runner, engine);

        // Resize
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

        // Pause when tab hidden
        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) {
                Matter.Runner.stop(runner);
            } else {
                Matter.Runner.run(runner, engine);
            }
        });

        // Theme change — recolor
        var obs = new MutationObserver(function () {
            colorAll(engine.world, palette());
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    // Init after DOM + Matter.js loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 100); });
    } else {
        setTimeout(init, 100);
    }
})();
