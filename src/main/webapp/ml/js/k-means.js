/*
 * k-means.js — Lloyd's algorithm visualized, in your browser.
 *
 * Two panels:
 *   1. Left:  2D scatter, points colored by current cluster.  Centroids
 *             drawn as bordered X-markers.  A soft Voronoi tessellation
 *             paints the background.
 *   2. Right: Inertia (WCSS) vs iteration — monotonically decreasing,
 *             which IS Lloyd's convergence guarantee made visible.
 *
 * Six datasets teach different ML truths: K-means converges fast on
 * well-separated blobs, splits half-moons badly, can't see concentric
 * rings at all, and gets thrown off by anisotropic / unequal-variance
 * clusters.  Same Python algorithm runs on all of them.
 */

(function () {
    'use strict';

    // ── DOM handles ──────────────────────────────────────────
    const els = {
        pill:        document.getElementById('mlRuntimePill'),
        pillLabel:   document.getElementById('mlRuntimeLabel'),
        scatter:     document.getElementById('kmScatter'),
        inertia:     document.getElementById('kmInertia'),
        scatterReadout: document.getElementById('kmScatterReadout'),
        inertiaReadout: document.getElementById('kmInertiaReadout'),
        legend:      document.getElementById('kmLegend'),
        code:        document.getElementById('kmCode'),
        runBtn:      document.getElementById('kmRun'),
        resetBtn:    document.getElementById('kmReset'),
        resetCodeBtn:document.getElementById('kmResetCode'),
        copyBtn:     document.getElementById('kmCopy'),
        console:     document.getElementById('kmConsole'),
        dataset:     document.getElementById('kmDataset'),
        datasetStory:document.getElementById('kmDatasetStory'),
        kSlider:     document.getElementById('kmK'),
        kValue:      document.getElementById('kmKValue'),
        initSelect:  document.getElementById('kmInit'),
        maxIter:     document.getElementById('kmMaxIter'),
        seed:        document.getElementById('kmSeed'),
        speedSlider: document.getElementById('kmSpeed'),
        speedValue:  document.getElementById('kmSpeedValue'),
    };

    // ── State ────────────────────────────────────────────────
    let pyodide = null;
    let pyodideLoading = null;
    let lastHistory = null;          // { centroids: [[[x,y],...]_t], labels: [[c,...]_t], inertia: [v_t] }
    let anim = { raf: null, i: 0, frames: null };
    let defaultCode = '';
    let voronoiCache = null;         // cached Voronoi imageData keyed by dataset+centroids hash

    // ── Cluster palette (categorical, distinct) ──────────────
    const CLUSTER_COLORS = [
        '#4f46e5', // indigo
        '#ef4444', // red
        '#22c55e', // green
        '#f59e0b', // amber
        '#14b8a6', // teal
        '#ec4899', // pink
        '#8b5cf6', // violet
        '#f97316', // orange
    ];

    // ── Seeded PRNG ──────────────────────────────────────────
    function mulberry32 (seed) {
        return function () {
            let t = (seed += 0x6D2B79F5);
            t = Math.imul(t ^ (t >>> 15), t | 1);
            t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
            return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
        };
    }
    function gauss (rng) { return rng() + rng() + rng() - 1.5; }

    // ── Dataset library ──────────────────────────────────────
    // Each entry: label, story, recommended_k, data range, default
    // hyperparameters, and a generate(rng) function returning (xs, ys).
    const DATASETS = {
        blobs: {
            label: 'Three well-separated blobs',
            story: 'The baseline: K-means converges in 2–3 iterations and finds the truth.',
            xRange: [-7, 7], yRange: [-7, 7],
            recommendedK: 3, defaultMaxIter: 20,
            generate (rng) {
                const centers = [[-3, -3], [3, 3], [3, -3]];
                const xs = [], ys = [];
                for (let c = 0; c < 3; c++) {
                    for (let i = 0; i < 80; i++) {
                        xs.push(centers[c][0] + gauss(rng) * 0.65);
                        ys.push(centers[c][1] + gauss(rng) * 0.65);
                    }
                }
                return { xs, ys };
            },
        },

        anisotropic: {
            label: 'Anisotropic blobs (stretched)',
            story: 'K-means assumes spherical clusters — stretched ones get split or merged wrong.',
            xRange: [-8, 8], yRange: [-6, 6],
            recommendedK: 3, defaultMaxIter: 25,
            generate (rng) {
                const xs = [], ys = [];
                const centers = [[-3, 2], [3, 2], [0, -3]];
                // Each cluster gets a different stretch direction via a 2x2 transform.
                const transforms = [
                    [[1.6, 0.6], [0.0, 0.4]],
                    [[0.4, 0.0], [0.6, 1.6]],
                    [[1.4, -0.4], [-0.2, 1.4]],
                ];
                for (let c = 0; c < 3; c++) {
                    const [cx, cy] = centers[c], T = transforms[c];
                    for (let i = 0; i < 80; i++) {
                        const u = gauss(rng), v = gauss(rng);
                        xs.push(cx + T[0][0] * u + T[0][1] * v);
                        ys.push(cy + T[1][0] * u + T[1][1] * v);
                    }
                }
                return { xs, ys };
            },
        },

        unequalSize: {
            label: 'Unequal cluster sizes',
            story: 'A small cluster between two big ones tends to get absorbed by the mean pull.',
            xRange: [-7, 7], yRange: [-7, 7],
            recommendedK: 3, defaultMaxIter: 25,
            generate (rng) {
                const xs = [], ys = [];
                // Two big clusters
                for (let i = 0; i < 150; i++) {
                    xs.push(-3 + gauss(rng) * 0.8); ys.push(-3 + gauss(rng) * 0.8);
                }
                for (let i = 0; i < 150; i++) {
                    xs.push( 3 + gauss(rng) * 0.8); ys.push( 3 + gauss(rng) * 0.8);
                }
                // One tiny cluster in the middle
                for (let i = 0; i < 15; i++) {
                    xs.push( 0 + gauss(rng) * 0.3); ys.push( 0 + gauss(rng) * 0.3);
                }
                return { xs, ys };
            },
        },

        unequalVariance: {
            label: 'Unequal variance (tight + spread)',
            story: 'A spread-out cluster fights a tight one for points in the overlap zone.',
            xRange: [-7, 9], yRange: [-7, 7],
            recommendedK: 3, defaultMaxIter: 25,
            generate (rng) {
                const xs = [], ys = [];
                // Tight cluster
                for (let i = 0; i < 100; i++) {
                    xs.push(-3 + gauss(rng) * 0.25); ys.push(-3 + gauss(rng) * 0.25);
                }
                // Spread cluster
                for (let i = 0; i < 100; i++) {
                    xs.push( 2 + gauss(rng) * 2.0); ys.push( 2 + gauss(rng) * 2.0);
                }
                // Medium cluster
                for (let i = 0; i < 80; i++) {
                    xs.push( 5 + gauss(rng) * 0.7); ys.push(-3 + gauss(rng) * 0.7);
                }
                return { xs, ys };
            },
        },

        moons: {
            label: 'Two moons (non-convex)',
            story: "K-means visibly fails — it splits the moons vertically. Motivates DBSCAN / spectral clustering.",
            xRange: [-1.8, 2.8], yRange: [-1.2, 1.8],
            recommendedK: 2, defaultMaxIter: 25,
            generate (rng) {
                const xs = [], ys = [];
                const n = 150;
                for (let i = 0; i < n; i++) {
                    const t = Math.PI * (i / n);
                    xs.push(Math.cos(t) + (rng() - 0.5) * 0.18);
                    ys.push(Math.sin(t) + (rng() - 0.5) * 0.18);
                }
                for (let i = 0; i < n; i++) {
                    const t = Math.PI * (i / n);
                    xs.push(1 - Math.cos(t) + (rng() - 0.5) * 0.18);
                    ys.push(0.5 - Math.sin(t) + (rng() - 0.5) * 0.18);
                }
                return { xs, ys };
            },
        },

        rings: {
            label: 'Concentric rings',
            story: 'Both rings have the same mean — K-means cannot tell them apart at all.',
            xRange: [-3.5, 3.5], yRange: [-3.5, 3.5],
            recommendedK: 2, defaultMaxIter: 25,
            generate (rng) {
                const xs = [], ys = [];
                // Inner ring r ~ 1
                for (let i = 0; i < 150; i++) {
                    const a = rng() * 2 * Math.PI;
                    const r = 1 + (rng() - 0.5) * 0.18;
                    xs.push(r * Math.cos(a)); ys.push(r * Math.sin(a));
                }
                // Outer ring r ~ 2.6
                for (let i = 0; i < 200; i++) {
                    const a = rng() * 2 * Math.PI;
                    const r = 2.6 + (rng() - 0.5) * 0.22;
                    xs.push(r * Math.cos(a)); ys.push(r * Math.sin(a));
                }
                return { xs, ys };
            },
        },
    };

    const state = {
        key:  'blobs',
        spec: DATASETS.blobs,
        data: DATASETS.blobs.generate(mulberry32(42)),
    };

    // ── Pyodide ──────────────────────────────────────────────
    function setPillState (s, text) {
        if (!els.pill) return;
        els.pill.setAttribute('data-state', s);
        if (text && els.pillLabel) els.pillLabel.textContent = text;
    }

    function loadPyodideOnce () {
        if (pyodide) return Promise.resolve(pyodide);
        if (pyodideLoading) return pyodideLoading;
        setPillState('loading', 'Demo runtime · downloading (~4.5 MB)');
        pyodideLoading = new Promise((resolve, reject) => {
            const s = document.createElement('script');
            s.src = 'https://cdn.jsdelivr.net/pyodide/v0.27.0/full/pyodide.js';
            s.onload = async () => {
                try {
                    setPillState('loading', 'Demo runtime · starting up');
                    // eslint-disable-next-line no-undef
                    pyodide = await loadPyodide({
                        indexURL: 'https://cdn.jsdelivr.net/pyodide/v0.27.0/full/',
                        stdout: (line) => writeConsole(line),
                        stderr: (line) => writeConsole(line, true),
                    });
                    setPillState('loading', 'Demo runtime · loading numerical libraries');
                    await pyodide.loadPackage(['numpy']);
                    await injectDataset();
                    setPillState('ready', 'Demo runtime · ready');
                    resolve(pyodide);
                } catch (e) {
                    setPillState('error', 'Demo runtime · failed to load — see console');
                    reject(e);
                }
            };
            s.onerror = () => {
                setPillState('error', 'Demo runtime · unreachable');
                reject(new Error('Pyodide CDN script failed to load'));
            };
            document.head.appendChild(s);
        });
        return pyodideLoading;
    }

    async function injectDataset () {
        if (!pyodide) return;
        pyodide.globals.set('_DATA_X_LIST', state.data.xs);
        pyodide.globals.set('_DATA_Y_LIST', state.data.ys);
        await pyodide.runPythonAsync(
            'import numpy as np\n' +
            'DATA_X = np.column_stack([np.asarray(list(_DATA_X_LIST), dtype=float),\n' +
            '                         np.asarray(list(_DATA_Y_LIST), dtype=float)])\n'
        );
    }

    function selectDataset (key) {
        const spec = DATASETS[key] || DATASETS.blobs;
        state.key  = key;
        state.spec = spec;
        state.data = spec.generate(mulberry32(42));
        voronoiCache = null;

        if (els.datasetStory) els.datasetStory.textContent = spec.story;
        if (els.kSlider && spec.recommendedK != null) {
            els.kSlider.value = String(spec.recommendedK);
            els.kSlider.dispatchEvent(new Event('input'));
        }
        if (els.maxIter && spec.defaultMaxIter != null) {
            els.maxIter.value = String(spec.defaultMaxIter);
        }

        stopAnim();
        lastHistory = null;
        if (els.scatterReadout) els.scatterReadout.innerHTML = '';
        if (els.inertiaReadout) els.inertiaReadout.innerHTML = '';
        injectDataset();
        drawScatter(null, 0);
        drawInertia(null, 0);
        renderLegend(parseInt(els.kSlider ? els.kSlider.value : '3', 10));
    }

    // ── Console ──────────────────────────────────────────────
    function writeConsole (line, isErr) {
        if (!els.console) return;
        const div = document.createElement('div');
        if (isErr) div.classList.add('km-err');
        div.textContent = String(line);
        els.console.appendChild(div);
        els.console.scrollTop = els.console.scrollHeight;
    }
    function clearConsole () { if (els.console) els.console.textContent = ''; }

    // ── Canvas helpers ───────────────────────────────────────
    function getCanvasCtx (canvas) {
        const dpr = window.devicePixelRatio || 1;
        const rect = canvas.getBoundingClientRect();
        canvas.width  = Math.max(1, Math.floor(rect.width  * dpr));
        canvas.height = Math.max(1, Math.floor(rect.height * dpr));
        const ctx = canvas.getContext('2d');
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        return { ctx, w: rect.width, h: rect.height };
    }
    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    // ── Left canvas: scatter + Voronoi shading + centroids ───
    function paintVoronoi (ctx, pad, plotW, plotH, tx, ty, centroids) {
        // Coarse 1px-step Voronoi via nearest-centroid lookup.  Cheap
        // because k is small and we paint at half-resolution.
        const step = 4;
        const rows = Math.ceil(plotH / step);
        const cols = Math.ceil(plotW / step);
        const k = centroids.length;
        const { xRange, yRange } = { xRange: state.spec.xRange, yRange: state.spec.yRange };
        for (let r = 0; r < rows; r++) {
            const py = pad.t + r * step + step / 2;
            const dataY = yRange[1] - ((py - pad.t) / plotH) * (yRange[1] - yRange[0]);
            for (let c = 0; c < cols; c++) {
                const px = pad.l + c * step + step / 2;
                const dataX = xRange[0] + ((px - pad.l) / plotW) * (xRange[1] - xRange[0]);
                let best = 0, bestD = Infinity;
                for (let j = 0; j < k; j++) {
                    const dx = dataX - centroids[j][0];
                    const dy = dataY - centroids[j][1];
                    const d = dx * dx + dy * dy;
                    if (d < bestD) { bestD = d; best = j; }
                }
                ctx.fillStyle = CLUSTER_COLORS[best % CLUSTER_COLORS.length] + '14'; // 8% alpha
                ctx.fillRect(pad.l + c * step, pad.t + r * step, step + 0.5, step + 0.5);
            }
        }
    }

    function drawScatter (history, idx) {
        if (!els.scatter) return;
        const spec = state.spec, data = state.data;
        const { ctx, w: cw, h: ch } = getCanvasCtx(els.scatter);
        const pad = { l: 38, r: 14, t: 18, b: 28 };
        const plotW = cw - pad.l - pad.r, plotH = ch - pad.t - pad.b;
        const [xMin, xMax] = spec.xRange, [yMin, yMax] = spec.yRange;
        const tx = (x) => pad.l + ((x - xMin) / (xMax - xMin)) * plotW;
        const ty = (y) => pad.t + plotH - ((y - yMin) / (yMax - yMin)) * plotH;
        const dark = isDark();

        // Voronoi shading first (only if we have centroids)
        if (history && history.centroids[idx]) {
            paintVoronoi(ctx, pad, plotW, plotH, tx, ty, history.centroids[idx]);
        }

        // Axes
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.18)' : 'rgba(28,25,23,0.18)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad.l, pad.t); ctx.lineTo(pad.l, pad.t + plotH);
        ctx.lineTo(pad.l + plotW, pad.t + plotH);
        ctx.stroke();

        // Tick labels
        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        const xStep = Math.max(1, Math.round((xMax - xMin) / 6));
        const yStep = Math.max(1, Math.round((yMax - yMin) / 6));
        for (let xv = Math.ceil(xMin / xStep) * xStep; xv <= xMax + 1e-9; xv += xStep) {
            const x = tx(xv);
            ctx.beginPath(); ctx.moveTo(x, pad.t + plotH); ctx.lineTo(x, pad.t + plotH + 4); ctx.stroke();
            ctx.fillText(String(xv), x - 6, pad.t + plotH + 16);
        }
        for (let yv = Math.ceil(yMin / yStep) * yStep; yv <= yMax + 1e-9; yv += yStep) {
            const y = ty(yv);
            ctx.beginPath(); ctx.moveTo(pad.l - 4, y); ctx.lineTo(pad.l, y); ctx.stroke();
            ctx.fillText(String(yv), 8, y + 3);
        }
        ctx.fillText('x', pad.l + plotW - 12, pad.t + plotH + 16);
        ctx.fillText('y', pad.l - 14, pad.t + 8);

        // Scatter — colored by current label, or grey if no run yet
        const labels = history ? history.labels[idx] : null;
        for (let i = 0; i < data.xs.length; i++) {
            const x = tx(data.xs[i]), y = ty(data.ys[i]);
            if (labels) {
                ctx.fillStyle = CLUSTER_COLORS[labels[i] % CLUSTER_COLORS.length];
                ctx.globalAlpha = 0.85;
            } else {
                ctx.fillStyle = dark ? 'rgba(165,180,252,0.45)' : 'rgba(79,70,229,0.35)';
                ctx.globalAlpha = 1.0;
            }
            ctx.beginPath(); ctx.arc(x, y, 3, 0, Math.PI * 2); ctx.fill();
        }
        ctx.globalAlpha = 1.0;

        // Centroids — large bordered X markers, color-coded
        if (history && history.centroids[idx]) {
            const centroids = history.centroids[idx];
            centroids.forEach((c, j) => {
                const px = tx(c[0]), py = ty(c[1]);
                const col = CLUSTER_COLORS[j % CLUSTER_COLORS.length];
                // White halo behind the marker for contrast
                ctx.strokeStyle = dark ? '#1c1917' : '#ffffff';
                ctx.lineWidth = 4;
                ctx.beginPath();
                ctx.moveTo(px - 8, py - 8); ctx.lineTo(px + 8, py + 8);
                ctx.moveTo(px + 8, py - 8); ctx.lineTo(px - 8, py + 8);
                ctx.stroke();
                // Colored X on top
                ctx.strokeStyle = col;
                ctx.lineWidth = 2.2;
                ctx.beginPath();
                ctx.moveTo(px - 8, py - 8); ctx.lineTo(px + 8, py + 8);
                ctx.moveTo(px + 8, py - 8); ctx.lineTo(px - 8, py + 8);
                ctx.stroke();
            });
        }

        if (els.scatterReadout) {
            els.scatterReadout.innerHTML = history
                ? '<span>iteration ' + idx + ' / ' + (history.centroids.length - 1) + '</span>' +
                  '<span>' + history.centroids[idx].length + ' clusters</span>'
                : '<span>' + data.xs.length + ' points</span>';
        }
    }

    // ── Right canvas: inertia vs iteration ───────────────────
    function drawInertia (history, upTo) {
        if (!els.inertia) return;
        const { ctx, w: cw, h: ch } = getCanvasCtx(els.inertia);
        const pad = { l: 46, r: 14, t: 18, b: 28 };
        const plotW = cw - pad.l - pad.r, plotH = ch - pad.t - pad.b;
        const dark = isDark();

        // Axes
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.18)' : 'rgba(28,25,23,0.18)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad.l, pad.t); ctx.lineTo(pad.l, pad.t + plotH);
        ctx.lineTo(pad.l + plotW, pad.t + plotH);
        ctx.stroke();

        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        ctx.fillText('inertia (WCSS)', 4, pad.t + 8);
        ctx.fillText('iter', pad.l + plotW - 24, pad.t + plotH + 16);

        if (!history || !history.inertia.length) return;
        const inertia = history.inertia;
        const n = Math.min(upTo + 1, inertia.length);
        const max = Math.max(...inertia), min = 0;
        const tx = (i) => pad.l + (i / Math.max(1, inertia.length - 1)) * plotW;
        const ty = (v) => pad.t + plotH - ((v - min) / Math.max(1e-9, max - min)) * plotH;

        // Tick marks for inertia
        const yStep = max > 1000 ? Math.pow(10, Math.floor(Math.log10(max))) : Math.max(1, Math.round(max / 5));
        for (let v = 0; v <= max + 1e-9; v += yStep) {
            const y = ty(v);
            ctx.strokeStyle = dark ? 'rgba(245,245,244,0.10)' : 'rgba(28,25,23,0.06)';
            ctx.beginPath(); ctx.moveTo(pad.l, y); ctx.lineTo(pad.l + plotW, y); ctx.stroke();
            ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
            const lbl = v >= 1000 ? (v / 1000).toFixed(1) + 'k' : String(Math.round(v));
            ctx.fillText(lbl, 4, y + 3);
        }

        // Iteration marks on x-axis
        const xStep = Math.max(1, Math.ceil(inertia.length / 6));
        for (let i = 0; i < inertia.length; i += xStep) {
            const x = tx(i);
            ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
            ctx.fillText(String(i), x - 4, pad.t + plotH + 16);
        }

        // Line
        ctx.strokeStyle = '#4f46e5';
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (let i = 0; i < n; i++) {
            const x = tx(i), y = ty(inertia[i]);
            if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
        }
        ctx.stroke();

        // Current marker
        if (n > 0) {
            const i = n - 1;
            const x = tx(i), y = ty(inertia[i]);
            ctx.fillStyle = '#4f46e5';
            ctx.strokeStyle = '#fff';
            ctx.lineWidth = 2;
            ctx.beginPath(); ctx.arc(x, y, 5, 0, Math.PI * 2); ctx.fill(); ctx.stroke();

            if (els.inertiaReadout) {
                els.inertiaReadout.innerHTML =
                    '<span>iter ' + i + '</span>' +
                    '<span>inertia = ' + inertia[i].toFixed(2) + '</span>';
            }
        }
    }

    // ── Cluster legend chips ─────────────────────────────────
    function renderLegend (k) {
        if (!els.legend) return;
        const items = [];
        for (let i = 0; i < k; i++) {
            const col = CLUSTER_COLORS[i % CLUSTER_COLORS.length];
            items.push(
                '<span class="km-legend-chip">' +
                '<span class="km-legend-dot" style="background:' + col + '"></span>' +
                'cluster ' + i +
                '</span>'
            );
        }
        els.legend.innerHTML = items.join('');
    }

    // ── Animation ────────────────────────────────────────────
    function stopAnim () {
        if (anim.raf) cancelAnimationFrame(anim.raf);
        anim.raf = null;
    }

    function buildFrames (history) {
        // K-means usually converges in <30 iters, so no subsampling needed.
        return Array.from({ length: history.centroids.length }, (_, i) => i);
    }

    function startAnim () {
        stopAnim();
        anim.frames = buildFrames(lastHistory);
        anim.i = 0;
        const speed = Number(els.speedSlider ? els.speedSlider.value : 2); // iter/sec, slow by default
        let lastTime = performance.now();
        let accum = 0;
        function tick (t) {
            const dt = (t - lastTime) / 1000;
            lastTime = t;
            accum += dt * speed;
            while (accum >= 1 && anim.i < anim.frames.length - 1) {
                anim.i++;
                accum -= 1;
            }
            const idx = anim.frames[anim.i];
            drawScatter(lastHistory, idx);
            drawInertia(lastHistory, idx);
            if (anim.i < anim.frames.length - 1) {
                anim.raf = requestAnimationFrame(tick);
            } else {
                anim.raf = null;
            }
        }
        anim.raf = requestAnimationFrame(tick);
    }

    // ── Run ──────────────────────────────────────────────────
    async function run () {
        try {
            els.runBtn.classList.add('is-busy');
            els.runBtn.disabled = true;
            await loadPyodideOnce();
            await injectDataset();
            clearConsole();

            const k = parseInt(els.kSlider.value, 10);
            const maxIter = parseInt(els.maxIter.value, 10);
            const init = els.initSelect.value;
            const seed = parseInt(els.seed.value, 10);

            renderLegend(k);

            const userCode = els.code.value;
            const call =
                '\n\n# ── auto-injected by the demo runner ──\n' +
                '_args = dict(k=' + k + ', max_iter=' + maxIter +
                    ', init=' + JSON.stringify(init) + ', seed=' + seed + ')\n' +
                'history = run(**_args)\n';

            await pyodide.runPythonAsync(userCode + call);
            const py = pyodide.globals.get('history');
            const obj = py.toJs({ dict_converter: Object.fromEntries });
            py.destroy && py.destroy();

            lastHistory = {
                centroids: obj.centroids.map((cs) => cs.map((c) => [Number(c[0]), Number(c[1])])),
                labels:    obj.labels.map((ls) => Array.from(ls, Number)),
                inertia:   Array.from(obj.inertia, Number),
            };

            startAnim();
            writeConsole(
                'Converged in ' + (lastHistory.centroids.length - 1) + ' iterations · final inertia ' +
                lastHistory.inertia[lastHistory.inertia.length - 1].toFixed(2)
            );
        } catch (e) {
            writeConsole(String(e && e.message ? e.message : e), true);
            setPillState('error', 'Demo runtime · error — see console');
        } finally {
            els.runBtn.classList.remove('is-busy');
            els.runBtn.disabled = false;
        }
    }

    function reset () {
        stopAnim();
        lastHistory = null;
        clearConsole();
        drawScatter(null, 0);
        drawInertia(null, 0);
        if (els.scatterReadout) els.scatterReadout.innerHTML = '';
        if (els.inertiaReadout) els.inertiaReadout.innerHTML = '';
    }

    // ── Wire-up ──────────────────────────────────────────────
    function wireControls () {
        if (!els.kSlider) return;
        const fmtK = () => {
            els.kValue.textContent = els.kSlider.value;
            renderLegend(parseInt(els.kSlider.value, 10));
        };
        const fmtSpeed = () => { els.speedValue.textContent = els.speedSlider.value + '/s'; };
        els.kSlider.addEventListener('input', fmtK);
        els.speedSlider.addEventListener('input', fmtSpeed);
        fmtK(); fmtSpeed();

        els.runBtn.addEventListener('click', run);
        els.resetBtn.addEventListener('click', reset);
        els.resetCodeBtn.addEventListener('click', () => { els.code.value = defaultCode; });
        els.copyBtn.addEventListener('click', async () => {
            try {
                await navigator.clipboard.writeText(els.code.value);
                els.copyBtn.textContent = 'copied';
                setTimeout(() => { els.copyBtn.textContent = 'copy'; }, 1200);
            } catch (e) { /* no-op */ }
        });
        if (els.dataset) {
            els.dataset.addEventListener('change', (ev) => selectDataset(ev.target.value));
        }
    }

    // ── Boot ─────────────────────────────────────────────────
    function boot () {
        if (!els.scatter || !els.inertia) return;
        defaultCode = els.code ? els.code.value : '';

        if (els.dataset && DATASETS[els.dataset.value]) {
            const initialKey = els.dataset.value;
            if (initialKey !== state.key) {
                state.key  = initialKey;
                state.spec = DATASETS[initialKey];
                state.data = state.spec.generate(mulberry32(42));
                voronoiCache = null;
            }
        }
        if (els.datasetStory) els.datasetStory.textContent = state.spec.story;
        if (els.kSlider && state.spec.recommendedK != null) {
            els.kSlider.value = String(state.spec.recommendedK);
        }
        if (els.maxIter && state.spec.defaultMaxIter != null) {
            els.maxIter.value = String(state.spec.defaultMaxIter);
        }

        wireControls();
        renderLegend(parseInt(els.kSlider.value, 10));
        drawScatter(null, 0);
        drawInertia(null, 0);

        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        let resizeTO = null;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTO);
            resizeTO = setTimeout(() => {
                const idx = lastHistory && anim.frames ? anim.frames[anim.i] : 0;
                drawScatter(lastHistory, idx);
                drawInertia(lastHistory, idx);
            }, 120);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
