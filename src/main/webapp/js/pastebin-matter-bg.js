/**
 * Decorative Matter.js background for pastebin.jsp — layered “code universe”:
 * paste cards, pills, shards, hex bits, gentle wind, occasional spawns.
 * Skips when prefers-reduced-motion; pauses when tab hidden.
 */
(function () {
    'use strict';

    var hostId = 'pb-matter-host';
    var mqReduce = typeof window.matchMedia === 'function'
        ? window.matchMedia('(prefers-reduced-motion: reduce)')
        : { matches: false };

    var tickHandler;
    var spawnTimer;
    var timeOrigin = 0;
    var maxDynamics = 32;

    function mqOnChange(mq, fn) {
        if (mq && typeof mq.addEventListener === 'function') {
            mq.addEventListener('change', fn);
        } else if (mq && typeof mq.addListener === 'function') {
            mq.addListener(fn);
        }
    }

    function themeIsDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    /** Richer theme-aware palette — multiple tiers + indigo accent */
    function palette() {
        if (themeIsDark()) {
            return {
                chipA: 'rgba(52, 211, 153, 0.32)',
                chipB: 'rgba(45, 212, 191, 0.2)',
                chipC: 'rgba(16, 185, 129, 0.14)',
                pill: 'rgba(99, 102, 241, 0.18)',
                tri: 'rgba(52, 211, 153, 0.26)',
                gem: 'rgba(167, 139, 250, 0.16)',
                dot: 'rgba(52, 211, 153, 0.2)',
                accent: 'rgba(129, 140, 248, 0.28)',
                stroke: 'rgba(52, 211, 153, 0.38)',
                strokeSoft: 'rgba(148, 163, 184, 0.25)'
            };
        }
        return {
            chipA: 'rgba(16, 185, 129, 0.34)',
            chipB: 'rgba(20, 184, 166, 0.22)',
            chipC: 'rgba(5, 150, 105, 0.14)',
            pill: 'rgba(99, 102, 241, 0.2)',
            tri: 'rgba(16, 185, 129, 0.3)',
            gem: 'rgba(139, 92, 246, 0.14)',
            dot: 'rgba(16, 185, 129, 0.22)',
            accent: 'rgba(99, 102, 241, 0.26)',
            stroke: 'rgba(5, 150, 105, 0.42)',
            strokeSoft: 'rgba(100, 116, 139, 0.22)'
        };
    }

    function styleForLabel(label, pal, body) {
        var seed = body && typeof body.id === 'number' ? body.id : 0;
        var fill;
        switch (label) {
            case 'pb-chip':
                fill = [pal.chipA, pal.chipB, pal.chipC][Math.abs(seed) % 3];
                break;
            case 'pb-pill':
                fill = pal.pill;
                break;
            case 'pb-tri':
                fill = pal.tri;
                break;
            case 'pb-gem':
                fill = pal.gem;
                break;
            case 'pb-dot':
                fill = pal.dot;
                break;
            case 'pb-accent':
                fill = pal.accent;
                break;
            default:
                fill = pal.chipA;
        }
        return {
            fill: fill,
            stroke: label === 'pb-pill' || label === 'pb-accent' ? pal.strokeSoft : pal.stroke,
            lw: label === 'pb-dot' ? 0.5 : 1
        };
    }

    function applyColorsToBodies(world, pal) {
        var bodies;
        try {
            bodies = Matter.Composite.allBodies(world);
        } catch (e) {
            bodies = world.bodies;
        }
        if (!bodies || !bodies.length) return;
        var i;
        var b;
        var st;
        for (i = 0; i < bodies.length; i++) {
            b = bodies[i];
            if (b.isStatic) continue;
            if (!b.render) b.render = {};
            st = styleForLabel(b.label, pal, b);
            b.render.fillStyle = st.fill;
            b.render.strokeStyle = st.stroke;
            b.render.lineWidth = st.lw;
        }
    }

    function countDynamic(world) {
        var bodies = Matter.Composite.allBodies(world) || world.bodies || [];
        var n = 0;
        var i;
        for (i = 0; i < bodies.length; i++) {
            if (!bodies[i].isStatic) n++;
        }
        return n;
    }

    var engine;
    var render;
    var runner;
    var walls = [];
    var resizeTimer;
    var obs;

    function clearTickAndSpawn() {
        if (typeof Matter === 'undefined') return;
        if (tickHandler && engine) {
            try { Matter.Events.off(engine, 'beforeUpdate', tickHandler); } catch (e) { /* ignore */ }
        }
        tickHandler = null;
        if (spawnTimer) {
            clearInterval(spawnTimer);
            spawnTimer = null;
        }
    }

    function teardown() {
        clearTickAndSpawn();
        if (obs) {
            try { obs.disconnect(); } catch (e) { /* ignore */ }
            obs = null;
        }
        window.removeEventListener('resize', onResizeDebounced);
        document.removeEventListener('visibilitychange', onVisibility);
        if (typeof Matter === 'undefined') return;
        if (render) {
            try { Matter.Render.stop(render); } catch (e) { /* ignore */ }
            if (render.canvas && render.canvas.parentNode) {
                render.canvas.parentNode.removeChild(render.canvas);
            }
            render = null;
        }
        if (runner) {
            try { Matter.Runner.stop(runner); } catch (e) { /* ignore */ }
            runner = null;
        }
        if (engine) {
            try { Matter.Composite.clear(engine.world, false); } catch (e) { /* ignore */ }
            try { Matter.Engine.clear(engine); } catch (e2) { /* ignore */ }
            engine = null;
        }
        walls = [];
    }

    function spawnOne(Matter, w, pal) {
        if (!engine || !engine.world) return;
        if (countDynamic(engine.world) >= maxDynamics) return;

        var Bodies = Matter.Bodies;
        var Composite = Matter.Composite;
        var rnd = Math.random;
        var x = rnd() * w;
        var y = -40 - rnd() * 60;
        var r = rnd();
        var body;

        if (r < 0.35) {
            body = Bodies.rectangle(x, y, 36 + rnd() * 56, 18 + rnd() * 22, {
                chamfer: { radius: 8 },
                angle: rnd() * Math.PI * 2,
                restitution: 0.12,
                frictionAir: 0.038,
                label: 'pb-chip',
                render: { lineWidth: 1 }
            });
        } else if (r < 0.55) {
            body = Bodies.rectangle(x, y, 70 + rnd() * 90, 10 + rnd() * 8, {
                chamfer: { radius: 5 },
                angle: rnd() * 0.4,
                restitution: 0.1,
                frictionAir: 0.04,
                label: 'pb-pill',
                render: { lineWidth: 1 }
            });
        } else if (r < 0.72) {
            body = Bodies.polygon(x, y, 3, 11 + rnd() * 10, {
                angle: rnd() * Math.PI * 2,
                restitution: 0.18,
                frictionAir: 0.035,
                label: 'pb-tri',
                render: { lineWidth: 1 }
            });
        } else if (r < 0.88) {
            body = Bodies.polygon(x, y, 6, 9 + rnd() * 8, {
                angle: rnd() * Math.PI * 2,
                restitution: 0.15,
                frictionAir: 0.04,
                label: 'pb-gem',
                render: { lineWidth: 1 }
            });
        } else if (r < 0.96) {
            body = Bodies.circle(x, y, 3 + rnd() * 7, {
                restitution: 0.22,
                frictionAir: 0.05,
                label: 'pb-dot',
                render: { lineWidth: 0.5 }
            });
        } else {
            body = Bodies.rectangle(x, y, 24 + rnd() * 20, 24 + rnd() * 20, {
                chamfer: { radius: 4 },
                angle: rnd() * Math.PI * 2,
                restitution: 0.2,
                frictionAir: 0.032,
                label: 'pb-accent',
                render: { lineWidth: 1 }
            });
        }

        Composite.add(engine.world, body);
        var st = styleForLabel(body.label, pal, body);
        body.render.fillStyle = st.fill;
        body.render.strokeStyle = st.stroke;
        body.render.lineWidth = st.lw;
    }

    function attachWindAndSpawns(MatterRef, w, pal) {
        clearTickAndSpawn();
        timeOrigin = Date.now();

        tickHandler = function () {
            if (!engine || !engine.world) return;
            var t = Date.now() - timeOrigin;
            engine.world.gravity.x = Math.sin(t * 0.00028) * 0.22;
            engine.world.gravity.y = 0.36 + Math.cos(t * 0.0002) * 0.06;
        };
        MatterRef.Events.on(engine, 'beforeUpdate', tickHandler);

        spawnTimer = setInterval(function () {
            if (document.hidden || mqReduce.matches) return;
            spawnOne(MatterRef, w, palette());
        }, 11000);
    }

    function buildWorld(Matter, w, h, pal) {
        var Bodies = Matter.Bodies;
        var Composite = Matter.Composite;

        var wallT = 80;
        var ground = Bodies.rectangle(w / 2, h + wallT / 2 - 2, w + wallT * 2, wallT, {
            isStatic: true,
            render: { visible: false },
            label: 'wall-ground'
        });
        var left = Bodies.rectangle(-wallT / 2, h / 2, wallT, h * 2, {
            isStatic: true,
            render: { visible: false },
            label: 'wall-left'
        });
        var right = Bodies.rectangle(w + wallT / 2, h / 2, wallT, h * 2, {
            isStatic: true,
            render: { visible: false },
            label: 'wall-right'
        });
        walls = [ground, left, right];

        var mobile = w < 640;
        maxDynamics = mobile ? 22 : 34;
        var count = mobile ? 12 : 22;
        var rnd = Math.random;
        var bodies = [];
        var i;
        var x;
        var y;
        var r;
        var b;

        for (i = 0; i < count; i++) {
            x = rnd() * w;
            y = -100 - rnd() * (h * 0.9);
            r = rnd();

            if (r < 0.32) {
                b = Bodies.rectangle(x, y, 38 + rnd() * 52, 22 + rnd() * 26, {
                    chamfer: { radius: 8 },
                    angle: rnd() * Math.PI * 2,
                    restitution: 0.12,
                    frictionAir: 0.034,
                    label: 'pb-chip',
                    render: { lineWidth: 1 }
                });
            } else if (r < 0.5) {
                b = Bodies.rectangle(x, y, 80 + rnd() * 100, 9 + rnd() * 10, {
                    chamfer: { radius: 5 },
                    angle: (rnd() - 0.5) * 0.5,
                    restitution: 0.1,
                    frictionAir: 0.042,
                    label: 'pb-pill',
                    render: { lineWidth: 1 }
                });
            } else if (r < 0.65) {
                b = Bodies.polygon(x, y, 3, 12 + rnd() * 12, {
                    angle: rnd() * Math.PI * 2,
                    restitution: 0.16,
                    frictionAir: 0.036,
                    label: 'pb-tri',
                    render: { lineWidth: 1 }
                });
            } else if (r < 0.8) {
                b = Bodies.polygon(x, y, 6, 10 + rnd() * 9, {
                    angle: rnd() * Math.PI * 2,
                    restitution: 0.14,
                    frictionAir: 0.038,
                    label: 'pb-gem',
                    render: { lineWidth: 1 }
                });
            } else if (r < 0.92) {
                b = Bodies.circle(x, y, 4 + rnd() * 10, {
                    restitution: 0.2,
                    frictionAir: 0.046,
                    label: 'pb-dot',
                    render: { lineWidth: 0.5 }
                });
            } else {
                b = Bodies.rectangle(x, y, 26 + rnd() * 24, 26 + rnd() * 24, {
                    chamfer: { radius: 5 },
                    angle: rnd() * Math.PI * 2,
                    restitution: 0.18,
                    frictionAir: 0.032,
                    label: 'pb-accent',
                    render: { lineWidth: 1 }
                });
            }
            bodies.push(b);
        }

        Composite.add(engine.world, walls.concat(bodies));
        applyColorsToBodies(engine.world, pal);
    }

    function init() {
        if (mqReduce.matches) return;
        if (typeof Matter === 'undefined') return;
        if (engine) return;

        var host = document.getElementById(hostId);
        if (!host) return;

        var MatterRef = Matter;
        var Engine = MatterRef.Engine;
        var Render = MatterRef.Render;
        var Runner = MatterRef.Runner;

        var w = Math.max(320, window.innerWidth);
        var h = Math.max(400, window.innerHeight);
        var pal = palette();

        engine = Engine.create({
            enableSleeping: true,
            gravity: { x: 0, y: 0.38 }
        });

        render = Render.create({
            element: host,
            engine: engine,
            options: {
                width: w,
                height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: Math.min(2, window.devicePixelRatio || 1)
            }
        });

        buildWorld(MatterRef, w, h, pal);
        attachWindAndSpawns(MatterRef, w, pal);

        runner = Runner.create();
        Runner.run(runner, engine);
        MatterRef.Render.run(render);

        window.addEventListener('resize', onResizeDebounced, { passive: true });
        document.addEventListener('visibilitychange', onVisibility);

        obs = new MutationObserver(function () {
            if (!engine || !engine.world) return;
            applyColorsToBodies(engine.world, palette());
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    function onVisibility() {
        if (!runner) return;
        runner.enabled = !document.hidden;
    }

    function onResizeDebounced() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(rebuild, 220);
    }

    function rebuild() {
        if (typeof Matter === 'undefined' || !engine || !render) return;

        var MatterRef = Matter;
        var Composite = MatterRef.Composite;
        var w = Math.max(320, window.innerWidth);
        var h = Math.max(400, window.innerHeight);
        var pal = palette();

        clearTickAndSpawn();

        Composite.clear(engine.world, false);

        render.options.width = w;
        render.options.height = h;
        render.canvas.width = w;
        render.canvas.height = h;
        render.bounds.max.x = w;
        render.bounds.max.y = h;
        render.bounds.min.x = 0;
        render.bounds.min.y = 0;

        if (typeof MatterRef.Render.setPixelRatio === 'function') {
            MatterRef.Render.setPixelRatio(render, Math.min(2, window.devicePixelRatio || 1));
        }

        buildWorld(MatterRef, w, h, pal);
        attachWindAndSpawns(MatterRef, w, pal);
    }

    function start() {
        if (mqReduce.matches) return;
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', tryInit, { once: true });
        } else {
            tryInit();
        }
    }

    var matterPolls = 0;
    var matterPollMax = 80;
    function tryInit() {
        if (mqReduce.matches) return;
        if (typeof Matter === 'undefined') {
            matterPolls += 1;
            if (matterPolls < matterPollMax) {
                setTimeout(tryInit, 25);
            }
            return;
        }
        try {
            init();
        } catch (err) {
            if (typeof console !== 'undefined' && console.warn) {
                console.warn('pastebin-matter-bg: init failed', err);
            }
        }
    }

    mqOnChange(mqReduce, function () {
        if (mqReduce.matches) {
            teardown();
        } else {
            start();
        }
    });

    try {
        if (!mqReduce.matches) start();
    } catch (err) {
        if (typeof console !== 'undefined' && console.warn) {
            console.warn('pastebin-matter-bg: bootstrap failed', err);
        }
    }
})();
