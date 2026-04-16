/**
 * Decorative Matter.js background for Structured Data hero.
 * Schema-themed shapes: JSON braces, tag rectangles, data dots, angle brackets.
 */
(function () {
    'use strict';

    var hostId = 'sd-matter-host';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var maxBodies = 24;
    var spawnTimer;

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    function palette() {
        var a = themeIsDark() ? 0.22 : 0.18;
        return {
            green:   'rgba(16, 185, 129, ' + a + ')',
            blue:    'rgba(59, 130, 246, ' + a + ')',
            violet:  'rgba(139, 92, 246, ' + a + ')',
            indigo:  'rgba(99, 102, 241, ' + a + ')',
            pink:    'rgba(236, 72, 153, ' + (a * 0.7) + ')',
            orange:  'rgba(245, 158, 11, ' + (a * 0.7) + ')',
            stroke:  'rgba(139, 92, 246, ' + (a * 1.4) + ')',
            strokeS: 'rgba(148, 163, 184, ' + (a * 0.6) + ')'
        };
    }

    function pickFill(pal, label) {
        switch (label) {
            case 'brace':   return pal.green;
            case 'tag':     return pal.indigo;
            case 'bracket': return pal.blue;
            case 'chip':    return pal.violet;
            case 'dot':     return pal.pink;
            default:        return pal.indigo;
        }
    }

    var engine, render, runner, walls = [];
    var resizeTimer;

    function countDynamic(world) {
        var all = Matter.Composite.allBodies(world);
        var n = 0;
        for (var i = 0; i < all.length; i++) { if (!all[i].isStatic) n++; }
        return n;
    }

    function spawnOne(w, pal) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= maxBodies) return;

        var B = Matter.Bodies;
        var r = Math.random;
        var x = r() * w;
        var y = -30 - r() * 50;
        var rnd = r();
        var body;

        if (rnd < 0.25) {
            // JSON brace — tall thin rounded rect
            body = B.rectangle(x, y, 12 + r() * 6, 28 + r() * 14, {
                chamfer: { radius: 4 },
                restitution: 0.12,
                frictionAir: 0.04,
                label: 'brace'
            });
        } else if (rnd < 0.5) {
            // Meta tag chip — wider rounded rect
            body = B.rectangle(x, y, 50 + r() * 40, 16 + r() * 6, {
                chamfer: { radius: 8 },
                angle: r() * 0.3,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'tag'
            });
        } else if (rnd < 0.7) {
            // Angle bracket — triangle
            body = B.polygon(x, y, 3, 10 + r() * 8, {
                restitution: 0.15,
                frictionAir: 0.042,
                label: 'bracket'
            });
        } else if (rnd < 0.85) {
            // Data dot
            body = B.circle(x, y, 4 + r() * 6, {
                restitution: 0.2,
                frictionAir: 0.03,
                label: 'dot'
            });
        } else {
            // Schema chip — small square
            body = B.rectangle(x, y, 14 + r() * 10, 14 + r() * 10, {
                chamfer: { radius: 3 },
                angle: r() * Math.PI,
                restitution: 0.1,
                frictionAir: 0.045,
                label: 'chip'
            });
        }

        var fill = pickFill(pal, body.label);
        body.render.fillStyle = fill;
        body.render.strokeStyle = body.label === 'dot' ? pal.strokeS : pal.stroke;
        body.render.lineWidth = body.label === 'dot' ? 0.5 : 1;
        Matter.Composite.add(engine.world, body);
    }

    function buildWalls(w, h) {
        var B = Matter.Bodies;
        var C = Matter.Composite;
        var thick = 60;
        var opts = { isStatic: true, render: { visible: false } };
        walls.forEach(function (wall) { C.remove(engine.world, wall); });
        walls = [
            B.rectangle(w / 2, h + thick / 2, w + 200, thick, opts),
            B.rectangle(-thick / 2, h / 2, thick, h + 200, opts),
            B.rectangle(w + thick / 2, h / 2, thick, h + 200, opts)
        ];
        walls.forEach(function (wall) { C.add(engine.world, wall); });
    }

    function colorAll(world, pal) {
        var bodies = Matter.Composite.allBodies(world);
        for (var i = 0; i < bodies.length; i++) {
            var b = bodies[i];
            if (b.isStatic) continue;
            b.render.fillStyle = pickFill(pal, b.label);
            b.render.strokeStyle = b.label === 'dot' ? pal.strokeS : pal.stroke;
        }
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
                width: w, height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: Math.min(window.devicePixelRatio || 1, 2)
            }
        });

        buildWalls(w, h);

        var timeOrigin = Date.now();
        Matter.Events.on(engine, 'beforeUpdate', function () {
            var t = (Date.now() - timeOrigin) / 1000;
            var windX = Math.sin(t * 0.15) * 0.0003;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: windX, y: 0 });
                }
            }
            for (var j = bodies.length - 1; j >= 0; j--) {
                if (!bodies[j].isStatic && bodies[j].position.y > h + 100) {
                    Matter.Composite.remove(engine.world, bodies[j]);
                }
            }
        });

        var pal = palette();
        for (var i = 0; i < 12; i++) {
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

        window.addEventListener('resize', function () {
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
        });

        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) Matter.Runner.stop(runner);
            else Matter.Runner.run(runner, engine);
        });

        var obs = new MutationObserver(function () { colorAll(engine.world, palette()); });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 100); });
    } else {
        setTimeout(init, 100);
    }
})();
