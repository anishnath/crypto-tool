/**
 * math-matter-bg.js — decorative Matter.js physics backdrop for math pages.
 *
 * Pattern cloned from /seo/js/seo-matter-bg.js with these adaptations:
 *   · Math-themed shapes: circles (unit), squares (variables), triangles
 *     (geometry), hexagons (structure), tag chips (formulas).
 *   · Palette keyed to --ms-accent (green/sage) so the backdrop sits
 *     harmoniously with the rest of the math-studio design system.
 *   · Theme-aware: re-colors on `data-theme` flip.
 *   · Respects `prefers-reduced-motion` — never runs for users who opt out.
 *   · Pauses when tab is hidden to save battery.
 *   · Gentle sideways "wind" gives the scene constant micro-motion without
 *     any strong movement that would distract from the actual tool.
 *
 * Host element: <div id="math-matter-host"></div> (see partials/matter-bg.jsp).
 * Canvas fills the host; host is positioned absolute inside a page-level
 * wrapper with a fade-to-transparent mask at the bottom so content further
 * down the page sits on the plain page background.
 */
(function () {
    'use strict';

    var HOST_ID  = 'math-matter-host';
    var MAX_BODIES = 22;

    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var engine, render, runner, spawnTimer, resizeTimer, walls = [];

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    // Palette keyed to math-studio's --ms-accent tokens, but coded as
    // literals here so the canvas doesn't need to resolve CSS vars each
    // frame.  Light/dark variants differ only in alpha + lift.
    function palette() {
        if (themeIsDark()) {
            return {
                fillA:   'rgba(74, 222, 128, 0.12)',   /* accent soft */
                fillB:   'rgba(74, 222, 128, 0.08)',
                fillC:   'rgba(134, 239, 172, 0.10)',
                fillD:   'rgba(167, 139, 250, 0.08)',  /* hint of indigo */
                stroke:  'rgba(74, 222, 128, 0.28)',
                strokeS: 'rgba(148, 163, 184, 0.16)'
            };
        }
        return {
            fillA:   'rgba(21, 128, 61, 0.09)',        /* accent soft */
            fillB:   'rgba(34, 197, 94, 0.07)',
            fillC:   'rgba(16, 185, 129, 0.06)',
            fillD:   'rgba(79, 70, 229, 0.05)',        /* hint of indigo */
            stroke:  'rgba(21, 128, 61, 0.24)',
            strokeS: 'rgba(100, 116, 139, 0.15)'
        };
    }

    function styleFor(label, pal, body) {
        var seed = (body && typeof body.id === 'number') ? body.id : 0;
        var fill;
        switch (label) {
            case 'm-circle':  fill = pal.fillB; break;
            case 'm-square':  fill = pal.fillA; break;
            case 'm-tri':     fill = pal.fillC; break;
            case 'm-hex':     fill = pal.fillD; break;
            case 'm-chip':    fill = [pal.fillA, pal.fillB][Math.abs(seed) % 2]; break;
            default:          fill = pal.fillA;
        }
        return {
            fill:   fill,
            stroke: (label === 'm-circle' || label === 'm-square') ? pal.stroke : pal.strokeS,
            lw:     label === 'm-chip' ? 1 : 0.75
        };
    }

    function colorAll(world, pal) {
        var bodies = Matter.Composite.allBodies(world);
        for (var i = 0; i < bodies.length; i++) {
            var b = bodies[i];
            if (b.isStatic) continue;
            if (!b.render) b.render = {};
            var st = styleFor(b.label, pal, b);
            b.render.fillStyle   = st.fill;
            b.render.strokeStyle = st.stroke;
            b.render.lineWidth   = st.lw;
        }
    }

    function countDynamic(world) {
        var all = Matter.Composite.allBodies(world);
        var n = 0;
        for (var i = 0; i < all.length; i++) { if (!all[i].isStatic) n++; }
        return n;
    }

    function spawnOne(w, pal) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= MAX_BODIES) return;

        var B = Matter.Bodies, C = Matter.Composite, r = Math.random;
        var x = r() * w;
        var y = -30 - r() * 60;
        var rnd = r();
        var body;

        if (rnd < 0.32) {
            // Circle — unit circles / point constants
            body = B.circle(x, y, 8 + r() * 14, {
                restitution: 0.14,
                frictionAir: 0.035,
                label: 'm-circle',
                render: { lineWidth: 0.75 }
            });
        } else if (rnd < 0.55) {
            // Rounded square — variables, scalars
            var s = 16 + r() * 22;
            body = B.rectangle(x, y, s, s, {
                chamfer: { radius: 5 },
                angle: r() * Math.PI,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'm-square',
                render: { lineWidth: 0.75 }
            });
        } else if (rnd < 0.72) {
            // Chip — horizontal pill, represents identifiers / labels
            body = B.rectangle(x, y, 42 + r() * 48, 14 + r() * 10, {
                chamfer: { radius: 7 },
                angle: r() * 0.5 - 0.25,
                restitution: 0.08,
                frictionAir: 0.045,
                label: 'm-chip',
                render: { lineWidth: 1 }
            });
        } else if (rnd < 0.88) {
            // Triangle — geometric / proof motif
            body = B.polygon(x, y, 3, 12 + r() * 14, {
                angle: r() * Math.PI * 2,
                restitution: 0.12,
                frictionAir: 0.042,
                label: 'm-tri',
                render: { lineWidth: 0.75 }
            });
        } else {
            // Hexagon — structure / tiling
            body = B.polygon(x, y, 6, 11 + r() * 13, {
                angle: r() * Math.PI,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'm-hex',
                render: { lineWidth: 0.75 }
            });
        }

        var st = styleFor(body.label, pal, body);
        body.render.fillStyle   = st.fill;
        body.render.strokeStyle = st.stroke;
        body.render.lineWidth   = st.lw;
        C.add(engine.world, body);
    }

    function buildWalls(w, h) {
        var B = Matter.Bodies, C = Matter.Composite;
        var thick = 60;
        var opts = { isStatic: true, render: { visible: false } };

        walls.forEach(function (wall) { C.remove(engine.world, wall); });
        walls = [
            B.rectangle(w / 2, h + thick / 2, w + 200, thick, opts),   // floor
            B.rectangle(-thick / 2, h / 2, thick, h + 200, opts),      // left
            B.rectangle(w + thick / 2, h / 2, thick, h + 200, opts)    // right
        ];
        walls.forEach(function (wall) { C.add(engine.world, wall); });
    }

    function init() {
        if (typeof Matter === 'undefined') return;
        if (mqReduce.matches) return;

        var host = document.getElementById(HOST_ID);
        if (!host) return;

        var w = host.clientWidth || window.innerWidth;
        var h = host.clientHeight || 700;

        // Slightly gentler gravity than seo-checker — bodies hang a bit
        // longer, giving the scene a more meditative feel.
        engine = Matter.Engine.create({ gravity: { x: 0, y: 0.18 } });

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

        // Gentle sideways + vertical wind — keeps the scene alive without
        // strong motion that would pull focus from the tool.
        var timeOrigin = Date.now();
        Matter.Events.on(engine, 'beforeUpdate', function () {
            var t = (Date.now() - timeOrigin) / 1000;
            var windX = Math.sin(t * 0.13) * 0.00025;
            var windY = Math.cos(t * 0.09) * 0.00010;
            var bodies = Matter.Composite.allBodies(engine.world);
            for (var i = 0; i < bodies.length; i++) {
                if (!bodies[i].isStatic) {
                    Matter.Body.applyForce(bodies[i], bodies[i].position, { x: windX, y: windY });
                }
            }
            // Cull bodies that fell past the floor.
            for (var j = bodies.length - 1; j >= 0; j--) {
                var b = bodies[j];
                if (!b.isStatic && b.position.y > h + 100) {
                    Matter.Composite.remove(engine.world, b);
                }
            }
        });

        // Initial spawn — pre-scatter so the scene doesn't look empty.
        var pal = palette();
        for (var i = 0; i < 14; i++) {
            spawnOne(w, pal);
            var bodies = Matter.Composite.allBodies(engine.world);
            var last = bodies[bodies.length - 1];
            if (last && !last.isStatic) {
                Matter.Body.setPosition(last, { x: last.position.x, y: Math.random() * h * 0.85 });
            }
        }

        // Drip new bodies over time
        spawnTimer = setInterval(function () {
            if (document.hidden) return;
            spawnOne(w, palette());
        }, 3500);

        runner = Matter.Runner.create();
        Matter.Render.run(render);
        Matter.Runner.run(runner, engine);

        // Resize
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () {
                var nw = host.clientWidth || window.innerWidth;
                var nh = host.clientHeight || 700;
                render.canvas.width = nw;
                render.canvas.height = nh;
                render.options.width = nw;
                render.options.height = nh;
                buildWalls(nw, nh);
            }, 200);
        });

        // Battery saver
        document.addEventListener('visibilitychange', function () {
            if (!runner) return;
            if (document.hidden) Matter.Runner.stop(runner);
            else                 Matter.Runner.run(runner, engine);
        });

        // Recolor on theme flip
        var obs = new MutationObserver(function () { colorAll(engine.world, palette()); });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 120); });
    } else {
        setTimeout(init, 120);
    }
})();
