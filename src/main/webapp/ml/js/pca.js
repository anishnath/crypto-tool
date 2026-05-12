/*
 * pca.js — Principal Component Analysis, with real numpy via Pyodide.
 *
 * Two Plotly 3D panels:
 *   1. Left:  original data + PC arrows (red/green/blue) from centroid
 *   2. Right: projected data (in PC coordinates; missing dims = 0)
 *
 * Plus a scree plot canvas below.  Six datasets cover the cases where
 * PCA works beautifully (line, plane, anisotropic cloud, two clusters)
 * and where it doesn't (isotropic sphere, swiss-roll nonlinearity).
 */

(function () {
    'use strict';

    // ── DOM handles ──────────────────────────────────────────
    const els = {
        pill:        document.getElementById('mlRuntimePill'),
        pillLabel:   document.getElementById('mlRuntimeLabel'),
        original3d:  document.getElementById('pcaOriginal'),
        projected3d: document.getElementById('pcaProjected'),
        scree:       document.getElementById('pcaScree'),
        origReadout: document.getElementById('pcaOrigReadout'),
        projReadout: document.getElementById('pcaProjReadout'),
        code:        document.getElementById('pcaCode'),
        runBtn:      document.getElementById('pcaRun'),
        resetBtn:    document.getElementById('pcaReset'),
        resetCodeBtn:document.getElementById('pcaResetCode'),
        copyBtn:     document.getElementById('pcaCopy'),
        console:     document.getElementById('pcaConsole'),
        dataset:     document.getElementById('pcaDataset'),
        datasetStory:document.getElementById('pcaDatasetStory'),
        dimsSlider:  document.getElementById('pcaDims'),
        dimsValue:   document.getElementById('pcaDimsValue'),
        standardize: document.getElementById('pcaStandardize'),
    };

    // ── State ────────────────────────────────────────────────
    let pyodide = null;
    let pyodideLoading = null;
    let lastResult = null;
    let defaultCode = '';

    // ── Seeded PRNG + Gaussian ───────────────────────────────
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
    const DATASETS = {
        hyperplane: {
            label: 'Noisy line in 3D',
            story: 'Points along a diagonal + noise. PC1 captures most variance — the canonical PCA case.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                for (let i = 0; i < 200; i++) {
                    const t = -1 + 2 * (i / 199);
                    const n = 0.25;
                    xs.push(t + gauss(rng) * n);
                    ys.push(t + gauss(rng) * n);
                    zs.push(t + gauss(rng) * n);
                }
                return { xs, ys, zs };
            },
        },
        plane: {
            label: 'Points on a plane',
            story: 'A 2D plane embedded in 3D. PC1+PC2 capture ~95% variance; PC3 is the noise normal.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                for (let i = 0; i < 200; i++) {
                    const u = (rng() - 0.5) * 2;
                    const v = (rng() - 0.5) * 2;
                    xs.push(u);
                    ys.push(v);
                    zs.push(0.4 * u + 0.6 * v + gauss(rng) * 0.08);
                }
                return { xs, ys, zs };
            },
        },
        anisotropic: {
            label: 'Anisotropic blob (rotated)',
            story: 'A Gaussian cloud stretched along one off-axis direction. PCA aligns to it.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                const c = Math.cos(0.6), s = Math.sin(0.6);
                for (let i = 0; i < 200; i++) {
                    const a = gauss(rng) * 1.4;
                    const b = gauss(rng) * 0.35;
                    const z = gauss(rng) * 0.25;
                    xs.push(a * c - b * s);
                    ys.push(a * s + b * c);
                    zs.push(z);
                }
                return { xs, ys, zs };
            },
        },
        sphere: {
            label: 'Sphere shell (isotropic — PCA fails)',
            story: 'All directions have equal variance. PCA can\'t pick a "best" axis — eigenvalues are roughly equal.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                for (let i = 0; i < 200; i++) {
                    let u1, u2, s2;
                    do {
                        u1 = 2 * rng() - 1;
                        u2 = 2 * rng() - 1;
                        s2 = u1 * u1 + u2 * u2;
                    } while (s2 >= 1 || s2 === 0);
                    const f = 2 * Math.sqrt(1 - s2);
                    xs.push(u1 * f);
                    ys.push(u2 * f);
                    zs.push(1 - 2 * s2);
                }
                return { xs, ys, zs };
            },
        },
        swissRoll: {
            label: 'Swiss roll (nonlinear — PCA flattens)',
            story: 'A curved 2D manifold. Linear PCA flattens it — motivates t-SNE / UMAP / kernel PCA.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                for (let i = 0; i < 200; i++) {
                    const t = 1.5 * Math.PI * (1 + 1.6 * rng());
                    const h = 2 * (rng() - 0.5);
                    xs.push(t * Math.cos(t) * 0.18 + gauss(rng) * 0.04);
                    ys.push(h);
                    zs.push(t * Math.sin(t) * 0.18 + gauss(rng) * 0.04);
                }
                return { xs, ys, zs };
            },
        },
        twoClusters: {
            label: 'Two clusters along diagonal',
            story: 'Two Gaussian blobs at opposite corners. PC1 lines up between them — variance has structure.',
            generate (rng) {
                const xs = [], ys = [], zs = [];
                for (let i = 0; i < 100; i++) {
                    xs.push(-0.8 + gauss(rng) * 0.22);
                    ys.push(-0.8 + gauss(rng) * 0.22);
                    zs.push(-0.8 + gauss(rng) * 0.22);
                }
                for (let i = 0; i < 100; i++) {
                    xs.push(0.8 + gauss(rng) * 0.22);
                    ys.push(0.8 + gauss(rng) * 0.22);
                    zs.push(0.8 + gauss(rng) * 0.22);
                }
                return { xs, ys, zs };
            },
        },
    };

    const state = {
        key:  'hyperplane',
        spec: DATASETS.hyperplane,
        data: DATASETS.hyperplane.generate(mulberry32(42)),
    };

    // ── Pyodide bootstrap ────────────────────────────────────
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
        const rows = state.data.xs.map((_, i) => [state.data.xs[i], state.data.ys[i], state.data.zs[i]]);
        pyodide.globals.set('_DATA_ROWS', rows);
        await pyodide.runPythonAsync(
            'import numpy as np\n' +
            'DATA_X = np.asarray([list(r) for r in _DATA_ROWS], dtype=float)\n'
        );
    }

    function selectDataset (key) {
        const spec = DATASETS[key] || DATASETS.hyperplane;
        state.key  = key;
        state.spec = spec;
        state.data = spec.generate(mulberry32(42));
        if (els.datasetStory) els.datasetStory.textContent = spec.story;
        lastResult = null;
        injectDataset();
        renderOriginal();
        renderProjected(null);
        drawScree(null);
    }

    // ── Plotly bootstrap (already loaded via JSP script tag) ──
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

    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    function buildLayout (titleLeft, titleRight, axisX, axisY, axisZ) {
        const dark = isDark();
        const ink   = dark ? '#e7e5e4' : '#1c1917';
        const muted = dark ? '#a8a29e' : '#78716c';
        const grid  = dark ? 'rgba(245,245,244,0.10)' : 'rgba(28,25,23,0.08)';
        const line  = dark ? 'rgba(245,245,244,0.22)' : 'rgba(28,25,23,0.22)';
        const fmt = (name) => ({
            title: { text: name, font: { color: muted, size: 11, family: 'Inter, system-ui, sans-serif' } },
            color: ink,
            gridcolor: grid,
            linecolor: line,
            zerolinecolor: grid,
            tickfont: { color: muted, size: 10, family: 'JetBrains Mono, monospace' },
            showbackground: false,
        });
        return {
            scene: {
                xaxis: fmt(axisX || 'x'),
                yaxis: fmt(axisY || 'y'),
                zaxis: fmt(axisZ || 'z'),
                camera: { eye: { x: 1.5, y: 1.5, z: 1.0 } },
                aspectmode: 'cube',
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

    // ── Left panel: original data + PC arrows ────────────────
    async function renderOriginal () {
        if (!els.original3d) return;
        await ensurePlotly();
        const data = state.data;

        const traces = [{
            type: 'scatter3d', mode: 'markers',
            x: data.xs, y: data.ys, z: data.zs,
            marker: { color: '#4f46e5', size: 3, opacity: 0.55 },
            hovertemplate: 'x=%{x:.2f}<br>y=%{y:.2f}<br>z=%{z:.2f}<extra></extra>',
            name: 'data',
        }];

        // Overlay PC arrows from the data mean (if PCA has been run)
        if (lastResult) {
            const dims = parseInt(els.dimsSlider.value, 10);
            const mean = lastResult.mean;
            const std  = lastResult.std;
            const eigVecs = lastResult.eig_vecs;   // 3×3, columns are PCs
            const eigVals = lastResult.eig_vals;
            const colors  = ['#ef4444', '#22c55e', '#0ea5e9'];
            for (let pc = 0; pc < dims; pc++) {
                // Re-scale the PC direction back to original-data scale: multiply by std.
                // Length = 2 * sqrt(eigval) so the arrow spans roughly ±2σ in PC direction.
                const scale = 2 * Math.sqrt(Math.max(0, eigVals[pc]));
                const v = [
                    eigVecs[0][pc] * std[0] * scale,
                    eigVecs[1][pc] * std[1] * scale,
                    eigVecs[2][pc] * std[2] * scale,
                ];
                traces.push({
                    type: 'scatter3d',
                    mode: 'lines+markers',
                    x: [mean[0] - v[0], mean[0] + v[0]],
                    y: [mean[1] - v[1], mean[1] + v[1]],
                    z: [mean[2] - v[2], mean[2] + v[2]],
                    line: { color: colors[pc], width: 7 },
                    marker: { color: colors[pc], size: [0, 6] },
                    hovertemplate: 'PC' + (pc + 1) + '<br>variance share %{customdata:.1%}<extra></extra>',
                    customdata: [lastResult.variance_pct[pc], lastResult.variance_pct[pc]],
                    name: 'PC' + (pc + 1),
                });
            }
        }

        await window.Plotly.react(els.original3d, traces, buildLayout('', '', 'x', 'y', 'z'), {
            displaylogo: false,
            responsive: true,
            modeBarButtonsToRemove: ['toImage', 'sendDataToCloud', 'orbitRotation', 'tableRotation', 'resetCameraLastSave3d'],
        });

        if (els.origReadout) {
            els.origReadout.innerHTML =
                '<span>' + data.xs.length + ' points · 3 features</span>' +
                (lastResult
                    ? '<span>PC1 captures ' + (lastResult.variance_pct[0] * 100).toFixed(1) + '% variance</span>'
                    : '<span>click Run to compute PCs</span>');
        }
    }

    // ── Right panel: projected data ──────────────────────────
    async function renderProjected (result) {
        if (!els.projected3d) return;
        await ensurePlotly();

        const dark = isDark();
        const dims = parseInt(els.dimsSlider.value, 10);

        let traces = [];
        if (result) {
            const proj = result.projected;   // (N, dims) — JS array of arrays
            const xs = proj.map((p) => p[0]);
            const ys = dims >= 2 ? proj.map((p) => p[1]) : proj.map(() => 0);
            const zs = dims >= 3 ? proj.map((p) => p[2]) : proj.map(() => 0);
            traces.push({
                type: 'scatter3d', mode: 'markers',
                x: xs, y: ys, z: zs,
                marker: { color: '#22c55e', size: 3, opacity: 0.75 },
                hovertemplate: 'PC1=%{x:.2f}' + (dims >= 2 ? '<br>PC2=%{y:.2f}' : '') + (dims >= 3 ? '<br>PC3=%{z:.2f}' : '') + '<extra></extra>',
                name: 'projected',
            });
        } else {
            // Empty state — show axes only
            traces.push({
                type: 'scatter3d', mode: 'markers',
                x: [], y: [], z: [],
            });
        }

        const labels = ['PC1', dims >= 2 ? 'PC2' : '(unused)', dims >= 3 ? 'PC3' : '(unused)'];
        await window.Plotly.react(els.projected3d, traces, buildLayout('', '', labels[0], labels[1], labels[2]), {
            displaylogo: false,
            responsive: true,
            modeBarButtonsToRemove: ['toImage', 'sendDataToCloud', 'orbitRotation', 'tableRotation', 'resetCameraLastSave3d'],
        });

        if (els.projReadout) {
            els.projReadout.innerHTML = result
                ? '<span>dims = ' + dims + '</span>' +
                  '<span>retained ' + (result.variance_pct.slice(0, dims).reduce((a, b) => a + b, 0) * 100).toFixed(1) + '% variance</span>'
                : '<span>projection appears after Run</span>';
        }
    }

    // ── Scree plot (canvas) ─────────────────────────────────
    function drawScree (result) {
        const canvas = els.scree;
        if (!canvas) return;
        const dpr = window.devicePixelRatio || 1;
        const rect = canvas.getBoundingClientRect();
        canvas.width  = Math.max(1, Math.floor(rect.width * dpr));
        canvas.height = Math.max(1, Math.floor(rect.height * dpr));
        const ctx = canvas.getContext('2d');
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        const w = rect.width, h = rect.height;
        ctx.clearRect(0, 0, w, h);

        const dark = isDark();
        const pad = { l: 50, r: 14, t: 14, b: 24 };
        const plotW = w - pad.l - pad.r, plotH = h - pad.t - pad.b;

        // Axes
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.18)' : 'rgba(28,25,23,0.18)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad.l, pad.t); ctx.lineTo(pad.l, pad.t + plotH);
        ctx.lineTo(pad.l + plotW, pad.t + plotH);
        ctx.stroke();

        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        ctx.fillText('variance %', 4, pad.t + 8);
        ctx.fillText('PC', pad.l + plotW - 14, pad.t + plotH + 16);

        if (!result) return;

        const variancePct = result.variance_pct;
        const k = variancePct.length;
        // Evenly spaced bars: bar i centered at (i + 0.5) / k of plotW.
        const slotWidth  = plotW / k;
        const barInner   = slotWidth * 0.6;   // 60% bar, 40% gap

        // Y-axis gridlines + tick labels (0, 25, 50, 75, 100)
        const ticks = [0, 0.25, 0.5, 0.75, 1.0];
        ticks.forEach((t) => {
            const y = pad.t + plotH - t * plotH;
            ctx.strokeStyle = dark ? 'rgba(245,245,244,0.07)' : 'rgba(28,25,23,0.06)';
            ctx.beginPath(); ctx.moveTo(pad.l, y); ctx.lineTo(pad.l + plotW, y); ctx.stroke();
            ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
            ctx.fillText((t * 100).toFixed(0) + '%', 8, y + 3);
        });

        // Bars
        const colors = ['#ef4444', '#22c55e', '#0ea5e9'];
        for (let i = 0; i < k; i++) {
            const v = variancePct[i];
            const cx = pad.l + (i + 0.5) * slotWidth;
            const barLeft = cx - barInner / 2;
            const barH = v * plotH;
            ctx.fillStyle = colors[i] || '#78716c';
            ctx.fillRect(barLeft, pad.t + plotH - barH, barInner, barH);
            // PC label below the bar
            ctx.fillStyle = dark ? 'rgba(229,229,228,0.95)' : 'rgba(28,25,23,0.95)';
            ctx.font = '500 10px JetBrains Mono, monospace';
            const pcLabel = 'PC' + (i + 1);
            ctx.fillText(pcLabel, cx - ctx.measureText(pcLabel).width / 2, pad.t + plotH + 16);
            // % value above the bar
            ctx.fillStyle = colors[i] || '#78716c';
            ctx.font = '600 11px Inter, system-ui, sans-serif';
            const pct = (v * 100).toFixed(1) + '%';
            ctx.fillText(pct, cx - ctx.measureText(pct).width / 2, pad.t + plotH - barH - 4);
        }

        // Cumulative variance line
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.5)' : 'rgba(28,25,23,0.45)';
        ctx.lineWidth = 1.5;
        ctx.setLineDash([4, 4]);
        ctx.beginPath();
        let cum = 0;
        for (let i = 0; i < k; i++) {
            cum += variancePct[i];
            const cx = pad.l + (i + 0.5) * slotWidth;
            const cy = pad.t + plotH - cum * plotH;
            if (i === 0) ctx.moveTo(cx, cy); else ctx.lineTo(cx, cy);
            // Dot at each cumulative point
            ctx.fillStyle = dark ? 'rgba(229,229,228,0.85)' : 'rgba(28,25,23,0.75)';
            ctx.fillRect(cx - 2, cy - 2, 4, 4);
        }
        ctx.stroke();
        ctx.setLineDash([]);
    }

    // ── Console ──────────────────────────────────────────────
    function writeConsole (line, isErr) {
        if (!els.console) return;
        const div = document.createElement('div');
        if (isErr) div.classList.add('pca-err');
        div.textContent = String(line);
        els.console.appendChild(div);
        els.console.scrollTop = els.console.scrollHeight;
    }
    function clearConsole () { if (els.console) els.console.textContent = ''; }

    // ── Run ──────────────────────────────────────────────────
    async function run () {
        try {
            els.runBtn.classList.add('is-busy');
            els.runBtn.disabled = true;
            await loadPyodideOnce();
            await injectDataset();
            clearConsole();

            const standardize = els.standardize ? els.standardize.checked : true;
            pyodide.globals.set('_STANDARDIZE', standardize);
            const userCode = els.code.value;
            const call =
                '\n\n# ── auto-injected by the demo runner ──\n' +
                'result = pca(DATA_X, standardize_first=bool(_STANDARDIZE))\n';
            await pyodide.runPythonAsync(userCode + call);
            const py = pyodide.globals.get('result');
            const obj = py.toJs({ dict_converter: Object.fromEntries });
            py.destroy && py.destroy();

            lastResult = {
                eig_vals:     Array.from(obj.eig_vals, Number),
                eig_vecs:     obj.eig_vecs.map((row) => Array.from(row, Number)),
                projected:    obj.projected.map((row) => Array.from(row, Number)),
                variance_pct: Array.from(obj.variance_pct, Number),
                mean:         Array.from(obj.mean, Number),
                std:          Array.from(obj.std, Number),
            };

            renderOriginal();
            renderProjected(lastResult);
            drawScree(lastResult);
            writeConsole(
                'PCs computed · variance shares: ' +
                lastResult.variance_pct.map((v) => (v * 100).toFixed(1) + '%').join(' / ')
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
        lastResult = null;
        clearConsole();
        renderOriginal();
        renderProjected(null);
        drawScree(null);
    }

    // ── Wire-up ──────────────────────────────────────────────
    function wireControls () {
        if (!els.dimsSlider) return;
        const fmtDims = () => {
            els.dimsValue.textContent = els.dimsSlider.value;
            renderProjected(lastResult);
            renderOriginal();
        };
        els.dimsSlider.addEventListener('input', fmtDims);
        fmtDims();

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
        if (!els.original3d || !els.projected3d) return;
        defaultCode = els.code ? els.code.value : '';

        if (els.dataset && DATASETS[els.dataset.value]) {
            const key = els.dataset.value;
            if (key !== state.key) {
                state.key  = key;
                state.spec = DATASETS[key];
                state.data = state.spec.generate(mulberry32(42));
            }
        }
        if (els.datasetStory) els.datasetStory.textContent = state.spec.story;

        wireControls();
        renderOriginal();
        renderProjected(null);
        drawScree(null);

        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        const themeObserver = new MutationObserver(() => {
            renderOriginal();
            renderProjected(lastResult);
            drawScree(lastResult);
        });
        themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['data-theme'],
        });
        window.addEventListener('resize', () => {
            // Plotly auto-resizes; only the scree canvas needs a redraw.
            drawScree(lastResult);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
