/*
 * gradient-descent.js — gradient descent through linear regression.
 *
 * Refactored from the toy-surfaces version: instead of watching an
 * abstract parameter roll down a bowl, the student watches gradient
 * descent *fit a line* to a real dataset.  Two canvases:
 *
 *   1. Left:  spending → sales scatter + the current y = w·x + b line.
 *   2. Right: MSE contour over the (w, b) plane + the descent path.
 *
 * The dataset is generated once (deterministic seeded PRNG) and
 * injected into Pyodide as DATA_X / DATA_Y numpy arrays.  The Python
 * textarea defines run(lr, epochs, w0, b0) → history; JS animates
 * through history step by step.
 */

(function () {
    'use strict';

    // ── DOM handles ──────────────────────────────────────────
    const els = {
        pill:        document.getElementById('mlRuntimePill'),
        pillLabel:   document.getElementById('mlRuntimeLabel'),
        fit:         document.getElementById('gdFit'),
        surface:     document.getElementById('gdSurface'),
        fitReadout:  document.getElementById('gdFitReadout'),
        surfReadout: document.getElementById('gdSurfReadout'),
        code:        document.getElementById('gdCode'),
        runBtn:      document.getElementById('gdRun'),
        resetBtn:    document.getElementById('gdReset'),
        resetCodeBtn:document.getElementById('gdResetCode'),
        copyBtn:     document.getElementById('gdCopy'),
        console:     document.getElementById('gdConsole'),
        dataset:     document.getElementById('gdDataset'),
        datasetStory:document.getElementById('gdDatasetStory'),
        lrSlider:    document.getElementById('gdLr'),
        lrValue:     document.getElementById('gdLrValue'),
        epochsSlider:document.getElementById('gdEpochs'),
        epochsValue: document.getElementById('gdEpochsValue'),
        initW:       document.getElementById('gdInitW'),
        initB:       document.getElementById('gdInitB'),
        speedSlider: document.getElementById('gdSpeed'),
        speedValue:  document.getElementById('gdSpeedValue'),
    };

    // ── State ────────────────────────────────────────────────
    let pyodide = null;
    let pyodideLoading = null;
    let lastHistory = null;          // { w: [...], b: [...], loss: [...] }
    let anim = { raf: null, i: 0, frames: null };
    let defaultCode = '';
    let surfaceCache = null;         // cached MSE heatmap pixels

    // ── Seeded PRNG (deterministic per dataset) ──────────────
    function mulberry32 (seed) {
        return function () {
            let t = (seed += 0x6D2B79F5);
            t = Math.imul(t ^ (t >>> 15), t | 1);
            t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
            return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
        };
    }
    // Approx N(0, 1) via Irwin–Hall (sum of 3 uniforms); kept simple/fast.
    function gauss (rng) { return rng() + rng() + rng() - 1.5; }

    // ── Dataset library ──────────────────────────────────────
    // Each entry teaches a different ML lesson while running the SAME
    // gradient-descent algorithm.  See the .story field on each one.
    const DATASETS = {
        ads: {
            label: 'Ad spend → Sales',
            story: 'Clean linear: GD converges nicely (the baseline).',
            xLabel: 'spending', yLabel: 'sales',
            dataRange: { xMin: 0, xMax: 50, yMin: -5, yMax: 28 },
            xTickStep: 10, yTickStep: 5,
            wRange: { wMin: -0.05, wMax: 0.7 },
            bRange: { bMin: -2, bMax: 16 },
            wTickStep: 0.1, bTickStep: 5, wTickFmt: (v) => v.toFixed(1),
            defaultLr: 5e-5, defaultEpochs: 200,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 200; i++) {
                    const x = rng() * 50;
                    const y = 0.45 * x + 1.5 + gauss(rng) * 4.0;
                    xs.push(x); ys.push(y);
                }
                return { xs, ys };
            },
        },

        study: {
            label: 'Hours studied → Exam score',
            story: 'Heavy noise: GD still finds the slope through scatter.',
            xLabel: 'hours studied', yLabel: 'exam score',
            dataRange: { xMin: 0, xMax: 20, yMin: 0, yMax: 105 },
            xTickStep: 5, yTickStep: 20,
            wRange: { wMin: -1, wMax: 8 },
            bRange: { bMin: -10, bMax: 60 },
            wTickStep: 1, bTickStep: 10, wTickFmt: (v) => v.toFixed(0),
            defaultLr: 1e-4, defaultEpochs: 400,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 200; i++) {
                    const x = rng() * 20;
                    let y = 4 * x + 20 + (gauss(rng) + (rng() - 0.5)) * 12;
                    y = Math.max(0, Math.min(100, y));
                    xs.push(x); ys.push(y);
                }
                return { xs, ys };
            },
        },

        salary: {
            label: 'Years experience → Salary (outliers)',
            story: 'A few extreme points yank the MSE line off-trend — motivates MAE.',
            xLabel: 'years exp.', yLabel: 'salary (k$)',
            dataRange: { xMin: 0, xMax: 20, yMin: 30, yMax: 260 },
            xTickStep: 5, yTickStep: 50,
            wRange: { wMin: -2, wMax: 20 },
            bRange: { bMin: 0, bMax: 100 },
            wTickStep: 4, bTickStep: 20, wTickFmt: (v) => v.toFixed(0),
            defaultLr: 2e-5, defaultEpochs: 400,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 195; i++) {
                    const x = rng() * 20;
                    const y = 6 * x + 50 + gauss(rng) * 10;
                    xs.push(x); ys.push(y);
                }
                for (let i = 0; i < 5; i++) {           // outliers: junior with founder pay
                    xs.push(2 + rng() * 4);
                    ys.push(200 + rng() * 50);
                }
                return { xs, ys };
            },
        },

        freethrows: {
            label: 'Practice hours → Free throws (curve)',
            story: 'Linear regression underfits nonlinear data — motivates polynomial features.',
            xLabel: 'practice hours', yLabel: 'free throws / 100',
            dataRange: { xMin: 0, xMax: 100, yMin: 0, yMax: 105 },
            xTickStep: 20, yTickStep: 20,
            wRange: { wMin: -0.2, wMax: 1.6 },
            bRange: { bMin: 0, bMax: 60 },
            wTickStep: 0.2, bTickStep: 10, wTickFmt: (v) => v.toFixed(1),
            defaultLr: 1e-5, defaultEpochs: 400,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 200; i++) {
                    const x = rng() * 100;
                    const y = 90 * (1 - Math.exp(-x / 30)) + gauss(rng) * 3;
                    xs.push(x); ys.push(y);
                }
                return { xs, ys };
            },
        },

        income: {
            label: 'Income → Spending (heteroscedastic)',
            story: 'Variance grows with x — same slope, different uncertainty.',
            xLabel: 'income (k$)', yLabel: 'spending (k$)',
            dataRange: { xMin: 20, xMax: 200, yMin: 0, yMax: 200 },
            xTickStep: 40, yTickStep: 40,
            wRange: { wMin: -0.2, wMax: 1.5 },
            bRange: { bMin: -20, bMax: 60 },
            wTickStep: 0.3, bTickStep: 20, wTickFmt: (v) => v.toFixed(1),
            defaultLr: 2e-6, defaultEpochs: 600,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 200; i++) {
                    const x = 20 + rng() * 180;
                    const noise = gauss(rng) * (x * 0.12);   // std grows with x
                    const y = 0.6 * x + 10 + noise;
                    xs.push(x); ys.push(y);
                }
                return { xs, ys };
            },
        },

        products: {
            label: 'Two products mixed (bimodal)',
            story: 'Mixed populations: one line splits both groups awkwardly — motivates clustering.',
            xLabel: 'marketing budget', yLabel: 'revenue',
            dataRange: { xMin: 0, xMax: 50, yMin: 0, yMax: 65 },
            xTickStep: 10, yTickStep: 10,
            wRange: { wMin: -0.2, wMax: 2 },
            bRange: { bMin: -5, bMax: 30 },
            wTickStep: 0.4, bTickStep: 5, wTickFmt: (v) => v.toFixed(1),
            defaultLr: 3e-5, defaultEpochs: 400,
            generate (rng) {
                const xs = [], ys = [];
                for (let i = 0; i < 100; i++) {           // Product A: gentle slope
                    const x = rng() * 50;
                    xs.push(x); ys.push(0.4 * x + 3 + gauss(rng) * 2);
                }
                for (let i = 0; i < 100; i++) {           // Product B: steep slope
                    const x = rng() * 50;
                    xs.push(x); ys.push(1.0 * x + 8 + gauss(rng) * 2);
                }
                return { xs, ys };
            },
        },
    };

    // Current dataset state — mutated by selectDataset().
    const state = {
        key:  'ads',
        spec: DATASETS.ads,
        data: DATASETS.ads.generate(mulberry32(42)),
    };

    // ── Log-scale learning-rate slider ───────────────────────
    // Slider value is a linear "position" 0–100; the actual lr is
    // mapped log-uniformly across [LR_MIN, LR_MAX].  Standard ML
    // viz pattern — gives fine control near tiny lrs while still
    // reaching large ones.
    const LR_MIN = 1e-6;
    const LR_MAX = 1e-2;
    const LOG_LR_MIN = Math.log10(LR_MIN);
    const LOG_LR_MAX = Math.log10(LR_MAX);
    function lrFromSlider () {
        const t = parseFloat(els.lrSlider.value) / 100;
        return Math.pow(10, LOG_LR_MIN + t * (LOG_LR_MAX - LOG_LR_MIN));
    }
    function sliderFromLr (lr) {
        const clamped = Math.max(LR_MIN, Math.min(LR_MAX, lr));
        return 100 * (Math.log10(clamped) - LOG_LR_MIN) / (LOG_LR_MAX - LOG_LR_MIN);
    }

    // ── Pyodide bootstrap (lazy) ─────────────────────────────
    function setPillState (state, text) {
        if (!els.pill) return;
        els.pill.setAttribute('data-state', state);
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

                    // Inject the current dataset.  Re-injected on every
                    // selectDataset() change too — see injectDataset().
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

    // ── Dataset injection (Pyodide globals) ──────────────────
    async function injectDataset () {
        if (!pyodide) return;
        pyodide.globals.set('_DATA_X_LIST', state.data.xs);
        pyodide.globals.set('_DATA_Y_LIST', state.data.ys);
        await pyodide.runPythonAsync(
            'import numpy as np\n' +
            'DATA_X = np.asarray(list(_DATA_X_LIST), dtype=float)\n' +
            'DATA_Y = np.asarray(list(_DATA_Y_LIST), dtype=float)\n'
        );
    }

    function selectDataset (key) {
        const spec = DATASETS[key] || DATASETS.ads;
        state.key  = key;
        state.spec = spec;
        state.data = spec.generate(mulberry32(42));
        surfaceCache = null;

        if (els.datasetStory) els.datasetStory.textContent = spec.story;

        // Apply this dataset's pedagogical defaults to the sliders.
        if (els.lrSlider && spec.defaultLr != null) {
            els.lrSlider.value = String(sliderFromLr(spec.defaultLr));
            els.lrSlider.dispatchEvent(new Event('input'));
        }
        if (els.epochsSlider && spec.defaultEpochs != null) {
            els.epochsSlider.value = String(spec.defaultEpochs);
            els.epochsSlider.dispatchEvent(new Event('input'));
        }

        // Re-inject + redraw.  If the run loop was active, drop it.
        stopAnim();
        lastHistory = null;
        if (els.fitReadout)  els.fitReadout.innerHTML = '';
        if (els.surfReadout) els.surfReadout.innerHTML = '';
        injectDataset();
        drawFit(undefined, undefined, null);
        renderSurface(null, null);
    }

    // ── Console ──────────────────────────────────────────────
    function writeConsole (line, isErr) {
        if (!els.console) return;
        const div = document.createElement('div');
        if (isErr) div.classList.add('gd-err');
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

    // ── Left canvas: data scatter + regression line ──────────
    function drawFit (w, b, epoch) {
        if (!els.fit) return;
        const spec = state.spec, data = state.data;
        const { ctx, w: cw, h: ch } = getCanvasCtx(els.fit);
        const pad = { l: 42, r: 14, t: 18, b: 28 };
        const plotW = cw - pad.l - pad.r, plotH = ch - pad.t - pad.b;
        const { xMin, xMax, yMin, yMax } = spec.dataRange;
        const tx = (x) => pad.l + ((x - xMin) / (xMax - xMin)) * plotW;
        const ty = (y) => pad.t + plotH - ((y - yMin) / (yMax - yMin)) * plotH;
        const dark = isDark();

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
        for (let xv = xMin; xv <= xMax + 1e-9; xv += spec.xTickStep) {
            const x = tx(xv);
            ctx.beginPath(); ctx.moveTo(x, pad.t + plotH); ctx.lineTo(x, pad.t + plotH + 4); ctx.stroke();
            ctx.fillText(String(Math.round(xv)), x - 7, pad.t + plotH + 16);
        }
        for (let yv = yMin; yv <= yMax + 1e-9; yv += spec.yTickStep) {
            const y = ty(yv);
            ctx.beginPath(); ctx.moveTo(pad.l - 4, y); ctx.lineTo(pad.l, y); ctx.stroke();
            ctx.fillText(String(Math.round(yv)), 10, y + 3);
        }
        ctx.fillText(spec.xLabel, pad.l + plotW - 60, pad.t + plotH + 24);
        ctx.save();
        ctx.translate(13, pad.t + 6); ctx.rotate(-Math.PI / 2);
        ctx.fillText(spec.yLabel, -70, 0);
        ctx.restore();

        // Scatter
        ctx.fillStyle = dark ? 'rgba(165,180,252,0.45)' : 'rgba(79,70,229,0.35)';
        for (let i = 0; i < data.xs.length; i++) {
            const x = tx(data.xs[i]), y = ty(data.ys[i]);
            ctx.beginPath(); ctx.arc(x, y, 2.5, 0, Math.PI * 2); ctx.fill();
        }

        // Regression line y = w·x + b across the visible range
        if (w !== undefined && b !== undefined) {
            const x1 = xMin, y1 = w * x1 + b;
            const x2 = xMax, y2 = w * x2 + b;
            ctx.strokeStyle = '#4f46e5';
            ctx.lineWidth = 2.2;
            ctx.beginPath(); ctx.moveTo(tx(x1), ty(y1)); ctx.lineTo(tx(x2), ty(y2)); ctx.stroke();
        }

        if (els.fitReadout && w !== undefined) {
            els.fitReadout.innerHTML =
                '<span>epoch ' + (epoch == null ? '—' : epoch) + '</span>' +
                '<span>y = ' + w.toFixed(4) + '·x + ' + b.toFixed(3) + '</span>';
        }
    }

    // ── Right panel: 3D MSE surface via Plotly ───────────────
    // Surface trace (the bowl) + scatter3d trace (the descent path).
    // Plotly handles rotation, zoom, hover, and click-to-seed for us.

    const SURF_RES = 72; // grid resolution; 72×72 gives smooth contour lines without taxing WebGL

    function ensurePlotly () {
        if (typeof window.Plotly !== 'undefined') return Promise.resolve();
        return new Promise((resolve) => {
            const tick = () => {
                if (typeof window.Plotly !== 'undefined') resolve();
                else setTimeout(tick, 60);
            };
            tick();
        });
    }

    function computeMseSurface (cols, rows) {
        const { wMin, wMax } = state.spec.wRange;
        const { bMin, bMax } = state.spec.bRange;
        const xs = state.data.xs, ys = state.data.ys, N = xs.length;

        const wAxis = new Array(cols);
        const bAxis = new Array(rows);
        for (let c = 0; c < cols; c++) wAxis[c] = wMin + (c / (cols - 1)) * (wMax - wMin);
        for (let r = 0; r < rows; r++) bAxis[r] = bMin + (r / (rows - 1)) * (bMax - bMin);

        // z[r][c] = MSE at (wAxis[c], bAxis[r])
        const z = new Array(rows);
        let lo = Infinity, hi = -Infinity;
        for (let r = 0; r < rows; r++) {
            const b = bAxis[r];
            const row = new Array(cols);
            for (let c = 0; c < cols; c++) {
                const w = wAxis[c];
                let s = 0;
                for (let i = 0; i < N; i++) {
                    const e = ys[i] - (w * xs[i] + b);
                    s += e * e;
                }
                const v = s / N;
                row[c] = v;
                if (v < lo) lo = v;
                if (v > hi) hi = v;
            }
            z[r] = row;
        }
        return { wAxis, bAxis, z, lo, hi, cols, rows };
    }

    // Jet (rainbow) — the scientific-paper standard for surface plots.
    // Low values (basin) read as deep blue; high (rim) saturates to red.
    // Perceptually non-uniform, yes — but instantly readable as "this is
    // a research figure," matches Ibnkahla et al. style, and makes the
    // descent path's blue→cool→hot direction visually unambiguous.
    const JET_COLORSCALE = [
        [0.00, '#00007f'],
        [0.10, '#0000ff'],
        [0.25, '#007fff'],
        [0.40, '#00ffff'],
        [0.55, '#7fff7f'],
        [0.70, '#ffff00'],
        [0.85, '#ff7f00'],
        [1.00, '#7f0000'],
    ];

    function buildLayout () {
        const dark = isDark();
        const ink     = dark ? '#e7e5e4' : '#1c1917';
        const muted   = dark ? '#a8a29e' : '#78716c';
        const gridCol = dark ? 'rgba(245,245,244,0.10)' : 'rgba(28,25,23,0.08)';
        const lineCol = dark ? 'rgba(245,245,244,0.22)' : 'rgba(28,25,23,0.22)';
        const axisFmt = {
            color: ink, gridcolor: gridCol, linecolor: lineCol, zerolinecolor: gridCol,
            titlefont: { color: muted, size: 11, family: 'Inter, system-ui, sans-serif' },
            tickfont:  { color: muted, size: 10, family: 'JetBrains Mono, monospace' },
            showbackground: false,
        };
        return {
            scene: {
                xaxis: Object.assign({ title: 'w (slope)' }, axisFmt),
                yaxis: Object.assign({ title: 'b (intercept)' }, axisFmt),
                zaxis: Object.assign({ title: 'MSE', exponentformat: 'power' }, axisFmt),
                camera: { eye: { x: 1.65, y: -1.55, z: 0.85 } }, // similar to reference notebook view_init(15, -35)
                aspectmode: 'manual',
                aspectratio: { x: 1, y: 1, z: 0.7 },
                bgcolor: 'transparent',
            },
            margin: { l: 0, r: 0, t: 0, b: 0 },
            paper_bgcolor: 'transparent',
            plot_bgcolor: 'transparent',
            font: { family: 'Inter, system-ui, sans-serif', color: ink },
            showlegend: false,
            hovermode: 'closest',
        };
    }

    function buildSurfaceFigure (history, upTo) {
        if (!surfaceCache) surfaceCache = computeMseSurface(SURF_RES, SURF_RES);
        const dark = isDark();
        const muted = dark ? '#a8a29e' : '#78716c';

        const traces = [{
            type: 'surface',
            x: surfaceCache.wAxis,
            y: surfaceCache.bAxis,
            z: surfaceCache.z,
            colorscale: JET_COLORSCALE,
            cmin: surfaceCache.lo,
            cmax: surfaceCache.hi,
            opacity: 0.95,
            showscale: true,
            colorbar: {
                title: { text: 'MSE', font: { color: muted, size: 11, family: 'Inter, system-ui, sans-serif' } },
                tickfont: { color: muted, size: 9, family: 'JetBrains Mono, monospace' },
                thickness: 12,
                len: 0.65,
                x: 1.02,
                xpad: 0,
                outlinewidth: 0,
                tickformat: '.0f',
            },
            // Lines etched into the surface itself + projected onto the z-floor.
            // The floor projection mimics a topographic map under the bowl.
            contours: {
                z: {
                    show: true,
                    usecolormap: false,
                    color: dark ? 'rgba(255,255,255,0.35)' : 'rgba(255,255,255,0.55)',
                    width: 1,
                    project: { z: true },
                    start: surfaceCache.lo,
                    end:   surfaceCache.hi,
                    size:  (surfaceCache.hi - surfaceCache.lo) / 14,
                },
            },
            // Light source angled for clear bowl shading.
            lighting:    { ambient: 0.55, diffuse: 0.8, specular: 0.18, roughness: 0.65, fresnel: 0.18 },
            lightposition: { x: 100, y: 200, z: 8000 },
            hovertemplate: 'w=%{x:.3f}<br>b=%{y:.2f}<br>MSE=%{z:.2f}<extra></extra>',
            name: 'MSE',
        }];

        if (history) {
            const n = Math.max(1, Math.min(upTo + 1, history.w.length));
            // Trail: white line+small dots, high contrast against the rainbow surface
            traces.push({
                type: 'scatter3d',
                mode: 'lines+markers',
                x: history.w.slice(0, n),
                y: history.b.slice(0, n),
                z: history.loss.slice(0, n),
                line:   { color: '#ffffff', width: 5 },
                marker: { color: '#ffffff', size: 3, opacity: 0.9, line: { color: '#1f2937', width: 0.5 } },
                hoverinfo: 'skip',
                name: 'descent path',
                showlegend: false,
            });

            // Current head marker — magenta with white outline, pops off any colormap.
            traces.push({
                type: 'scatter3d',
                mode: 'markers',
                x: [history.w[n - 1]],
                y: [history.b[n - 1]],
                z: [history.loss[n - 1]],
                marker: { color: '#ff006e', size: 8, line: { color: '#ffffff', width: 2 } },
                hoverinfo: 'skip',
                name: 'current (w, b)',
                showlegend: false,
            });
        }

        return { data: traces, layout: buildLayout() };
    }

    async function renderSurface (history, upTo) {
        if (!els.surface) return;
        await ensurePlotly();
        const fig = buildSurfaceFigure(history, upTo == null ? 0 : upTo);
        // Plotly.react re-uses the existing plot when possible — much faster
        // than newPlot during the animation loop.
        await window.Plotly.react(els.surface, fig.data, fig.layout, {
            displaylogo: false,
            responsive: true,
            modeBarButtonsToRemove: ['toImage', 'sendDataToCloud', 'orbitRotation', 'tableRotation', 'resetCameraLastSave3d'],
        });

        if (history && upTo != null) {
            const wi = history.w[upTo], bi = history.b[upTo];
            if (els.surfReadout) {
                els.surfReadout.innerHTML =
                    '<span>w = ' + wi.toFixed(4) + ' · b = ' + bi.toFixed(3) + '</span>' +
                    '<span>loss = ' + history.loss[upTo].toFixed(3) + '</span>';
            }
        }
    }

    // During animation we update only the path trace data — restyle is faster
    // than a full react with three traces.
    function updatePathOnSurface (history, upTo) {
        if (!els.surface || typeof window.Plotly === 'undefined') return;
        const n = Math.max(1, Math.min(upTo + 1, history.w.length));
        // Trace 1 is the path, trace 2 is the current marker
        window.Plotly.restyle(els.surface, {
            x: [history.w.slice(0, n), [history.w[n - 1]]],
            y: [history.b.slice(0, n), [history.b[n - 1]]],
            z: [history.loss.slice(0, n), [history.loss[n - 1]]],
        }, [1, 2]);

        if (els.surfReadout) {
            const wi = history.w[n - 1], bi = history.b[n - 1];
            els.surfReadout.innerHTML =
                '<span>w = ' + wi.toFixed(4) + ' · b = ' + bi.toFixed(3) + '</span>' +
                '<span>loss = ' + history.loss[n - 1].toFixed(3) + '</span>';
        }
    }

    // ── Animation ────────────────────────────────────────────
    function stopAnim () {
        if (anim.raf) cancelAnimationFrame(anim.raf);
        anim.raf = null;
    }

    function buildFrames (history) {
        // Subsample history to ≤120 frames so long runs stay fast.
        const total = history.w.length;
        const MAX = 120;
        if (total <= MAX) return Array.from({ length: total }, (_, i) => i);
        const frames = [];
        for (let i = 0; i < MAX; i++) {
            frames.push(Math.floor((i / (MAX - 1)) * (total - 1)));
        }
        return frames;
    }

    function startAnim () {
        stopAnim();
        anim.frames = buildFrames(lastHistory);
        anim.i = 0;
        const speed = Number(els.speedSlider ? els.speedSlider.value : 30);
        // Render the surface + initial path once via Plotly.react.  After
        // that, the per-frame tick only restyle()s the path trace.
        renderSurface(lastHistory, anim.frames[0]);

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
            drawFit(lastHistory.w[idx], lastHistory.b[idx], idx);
            updatePathOnSurface(lastHistory, idx);
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
            await injectDataset();      // make sure DATA_X/Y match the currently selected dataset
            clearConsole();

            const lr = lrFromSlider();
            const epochs = parseInt(els.epochsSlider.value, 10);
            const w0 = parseFloat(els.initW.value);
            const b0 = parseFloat(els.initB.value);

            const userCode = els.code.value;
            const call =
                '\n\n# ── auto-injected by the demo runner ──\n' +
                '_args = dict(lr=' + lr + ', epochs=' + epochs +
                    ', w0=' + w0 + ', b0=' + b0 + ')\n' +
                'history = run(**_args)\n';

            await pyodide.runPythonAsync(userCode + call);
            const py = pyodide.globals.get('history');
            const obj = py.toJs({ dict_converter: Object.fromEntries });
            py.destroy && py.destroy();

            lastHistory = {
                w:    Array.from(obj.w,    Number),
                b:    Array.from(obj.b,    Number),
                loss: Array.from(obj.loss, Number),
            };

            startAnim();
            writeConsole(
                'Trained for ' + epochs + ' epochs · final w=' +
                lastHistory.w[lastHistory.w.length - 1].toFixed(4) +
                ' b=' + lastHistory.b[lastHistory.b.length - 1].toFixed(3) +
                ' loss=' + lastHistory.loss[lastHistory.loss.length - 1].toFixed(3)
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
        drawFit(undefined, undefined, null);
        renderSurface(null, null);
        if (els.fitReadout)  els.fitReadout.innerHTML = '';
        if (els.surfReadout) els.surfReadout.innerHTML = '';
    }

    // ── Wire-up ──────────────────────────────────────────────
    function wireControls () {
        if (!els.lrSlider) return;
        const fmtLr = () => {
            const v = lrFromSlider();
            els.lrValue.textContent = v < 0.0001 ? v.toExponential(1) : v.toFixed(4);
        };
        const fmtEpochs = () => { els.epochsValue.textContent = els.epochsSlider.value; };
        const fmtSpeed  = () => { els.speedValue.textContent  = els.speedSlider.value + '/s'; };
        els.lrSlider.addEventListener('input', fmtLr);
        els.epochsSlider.addEventListener('input', fmtEpochs);
        els.speedSlider.addEventListener('input', fmtSpeed);
        fmtLr(); fmtEpochs(); fmtSpeed();

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
            els.dataset.addEventListener('change', (ev) => {
                selectDataset(ev.target.value);
            });
        }

        // Plotly fires `plotly_click` with the picked surface point —
        // far simpler than the canvas pixel math we used in the 2D version.
        // We register the listener after the first newPlot finishes.
        const registerSurfaceClick = () => {
            if (!els.surface || !els.surface.on) return;
            els.surface.on('plotly_click', (ev) => {
                if (!ev || !ev.points || !ev.points.length) return;
                const p = ev.points[0];
                if (p.x == null || p.y == null) return;
                els.initW.value = Number(p.x).toFixed(3);
                els.initB.value = Number(p.y).toFixed(2);
                run();
            });
        };
        // Plotly attaches .on() to the div only after the first render.
        // Poll briefly until it's available, then register once.
        (function waitForPlot () {
            if (els.surface && typeof els.surface.on === 'function') {
                registerSurfaceClick();
            } else {
                setTimeout(waitForPlot, 200);
            }
        })();
    }

    // ── Boot ─────────────────────────────────────────────────
    function boot () {
        if (!els.fit || !els.surface) return;
        defaultCode = els.code ? els.code.value : '';

        // Sync UI with the initial dataset.  If the <select> markup
        // defaults to a different key than the JS state, follow it.
        if (els.dataset && DATASETS[els.dataset.value]) {
            const initialKey = els.dataset.value;
            if (initialKey !== state.key) {
                state.key  = initialKey;
                state.spec = DATASETS[initialKey];
                state.data = state.spec.generate(mulberry32(42));
                surfaceCache = null;
            }
        }
        if (els.datasetStory) els.datasetStory.textContent = state.spec.story;
        if (els.lrSlider && state.spec.defaultLr != null) {
            els.lrSlider.value = String(sliderFromLr(state.spec.defaultLr));
        }
        if (els.epochsSlider && state.spec.defaultEpochs != null) {
            els.epochsSlider.value = String(state.spec.defaultEpochs);
        }

        wireControls();
        drawFit(undefined, undefined, null);
        // First surface render — runs once Plotly is loaded.  Doesn't block boot.
        renderSurface(null, null);

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
                // Plotly handles its own resize via `responsive: true`; we
                // just redraw the scatter canvas.
                if (lastHistory) {
                    const idx = anim.frames ? anim.frames[anim.i] : lastHistory.w.length - 1;
                    drawFit(lastHistory.w[idx], lastHistory.b[idx], idx);
                } else {
                    drawFit(undefined, undefined, null);
                }
            }, 120);
        });

        // Re-theme the 3D surface when the user toggles dark mode.
        const themeObserver = new MutationObserver(() => {
            surfaceCache = null;
            const idx = (lastHistory && anim.frames) ? anim.frames[anim.i] : null;
            renderSurface(lastHistory, idx);
        });
        themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['data-theme'],
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
