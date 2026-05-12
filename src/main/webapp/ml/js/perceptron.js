/*
 * perceptron.js — 3D Perceptron with hinge loss + Novikoff convergence.
 *
 * Mirrors the ml-visualized.com reference: 3D scatter of labelled points,
 * a decision hyperplane that moves as the perceptron rule is applied,
 * and a normal-vector arrow from the origin.  Below the 3D viz, a 2D
 * hinge-loss curve fills in as training progresses.  Convergence banner
 * triggers when zero points are misclassified — proof Rosenblatt was right
 * for linearly separable data.
 *
 * Pure JS — no Pyodide.  Plotly gl3d for the 3D scene, Chart.js for the
 * loss curve.  Both are loaded via the JSP's <script defer> tags.
 */

(function () {
    'use strict';

    const COLORS = {
        pos:    '#22c55e',
        neg:    '#ef4444',
        mis:    '#f59e0b',
        normal: '#4f46e5',
        plane:  '#4f46e5',
    };

    const PLANE_RANGE = 1.4;
    const PLANE_GRID  = 14;

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

    // ── Dataset library — six 3D cases ──────────────────────
    const DATASETS = {
        blobs3d: {
            label: 'Two blobs in 3D',
            story: 'Linearly separable — perceptron converges in tens of epochs.',
            recommendedEta: 0.05,
            generate (rng) {
                const pts = [];
                for (let i = 0; i < 80; i++) pts.push({ x: 0.85 + gauss(rng) * 0.3, y: 0.85 + gauss(rng) * 0.3, z: 0.85 + gauss(rng) * 0.3, t:  1 });
                for (let i = 0; i < 80; i++) pts.push({ x: -0.85 + gauss(rng) * 0.3, y: -0.85 + gauss(rng) * 0.3, z: -0.85 + gauss(rng) * 0.3, t: -1 });
                return pts;
            },
        },
        hyperplane: {
            label: 'Hyperplane grid (reference)',
            story: 'Points on a 5×5×5 lattice, labelled by sign of (1,1,1)·x. The textbook case.',
            recommendedEta: 0.02,
            generate (rng) {
                const pts = [];
                const norm = Math.sqrt(3);
                const nv = [1 / norm, 1 / norm, 1 / norm];
                const N = 5;
                for (let i = 0; i < N; i++)
                    for (let j = 0; j < N; j++)
                        for (let k = 0; k < N; k++) {
                            const x = -1 + 2 * i / (N - 1) + (rng() - 0.5) * 0.04;
                            const y = -1 + 2 * j / (N - 1) + (rng() - 0.5) * 0.04;
                            const z = -1 + 2 * k / (N - 1) + (rng() - 0.5) * 0.04;
                            const d = nv[0] * x + nv[1] * y + nv[2] * z;
                            pts.push({ x, y, z, t: d >= 0 ? 1 : -1 });
                        }
                return pts;
            },
        },
        overlap: {
            label: 'Overlapping blobs (oscillates)',
            story: 'Some overlap — perceptron never quite converges; weights oscillate near the boundary.',
            recommendedEta: 0.02,
            generate (rng) {
                const pts = [];
                for (let i = 0; i < 80; i++) pts.push({ x: 0.4 + gauss(rng) * 0.65, y: 0.4 + gauss(rng) * 0.65, z: 0.4 + gauss(rng) * 0.65, t:  1 });
                for (let i = 0; i < 80; i++) pts.push({ x: -0.4 + gauss(rng) * 0.65, y: -0.4 + gauss(rng) * 0.65, z: -0.4 + gauss(rng) * 0.65, t: -1 });
                return pts;
            },
        },
        slabs: {
            label: 'Two parallel slabs',
            story: 'Classes split along the z-axis. An axis-aligned plane separates them perfectly.',
            recommendedEta: 0.05,
            generate (rng) {
                const pts = [];
                for (let i = 0; i < 90; i++) pts.push({ x: gauss(rng) * 0.55, y: gauss(rng) * 0.55, z: 0.55 + gauss(rng) * 0.12, t:  1 });
                for (let i = 0; i < 90; i++) pts.push({ x: gauss(rng) * 0.55, y: gauss(rng) * 0.55, z: -0.55 + gauss(rng) * 0.12, t: -1 });
                return pts;
            },
        },
        xor3d: {
            label: 'XOR — 3D parity (fails)',
            story: 'Label = sign(x · y · z). 8 corner clusters with alternating classes. No plane separates them — perceptron never converges.',
            recommendedEta: 0.04,
            generate (rng) {
                const pts = [];
                for (let sx = -1; sx <= 1; sx += 2)
                    for (let sy = -1; sy <= 1; sy += 2)
                        for (let sz = -1; sz <= 1; sz += 2) {
                            const t = (sx * sy * sz) > 0 ? 1 : -1;
                            for (let i = 0; i < 18; i++) {
                                pts.push({
                                    x: sx * 0.75 + gauss(rng) * 0.12,
                                    y: sy * 0.75 + gauss(rng) * 0.12,
                                    z: sz * 0.75 + gauss(rng) * 0.12,
                                    t,
                                });
                            }
                        }
                return pts;
            },
        },
        shells: {
            label: 'Concentric shells (fails)',
            story: 'Inner ball vs outer shell. Both share the origin — a plane can never separate them.',
            recommendedEta: 0.04,
            generate (rng) {
                const pts = [];
                // Inner ball
                for (let i = 0; i < 80; i++) {
                    const r = rng() * 0.4 + 0.05;
                    const theta = rng() * 2 * Math.PI;
                    const phi   = Math.acos(2 * rng() - 1);
                    pts.push({
                        x: r * Math.sin(phi) * Math.cos(theta),
                        y: r * Math.sin(phi) * Math.sin(theta),
                        z: r * Math.cos(phi),
                        t: 1,
                    });
                }
                // Outer shell
                for (let i = 0; i < 140; i++) {
                    const r = 0.9 + rng() * 0.15;
                    const theta = rng() * 2 * Math.PI;
                    const phi   = Math.acos(2 * rng() - 1);
                    pts.push({
                        x: r * Math.sin(phi) * Math.cos(theta),
                        y: r * Math.sin(phi) * Math.sin(theta),
                        z: r * Math.cos(phi),
                        t: -1,
                    });
                }
                return pts;
            },
        },
    };

    // ── State ────────────────────────────────────────────────
    const state = {
        key:  'blobs3d',
        spec: DATASETS.blobs3d,
        data: DATASETS.blobs3d.generate(mulberry32(42)),
        // Weights, bias — the hyperplane normal + offset
        w0: 1, w1: -1, w2: 1, b: 0,
        // Hyperparameter
        eta: 0.05,
        // Training stats
        epoch: 0,
        currentLoss: 0,
        misclassifiedCount: 0,
        converged: false,
        lossHistory: [],
        autoTimer: null,
    };

    // ── DOM handles ──────────────────────────────────────────
    const $ = (id) => document.getElementById(id);
    let els;

    function captureDom () {
        els = {
            plot3d:        $('pn3d'),
            lossCanvas:    $('pnLoss'),
            datasetSel:    $('pnDataset'),
            datasetStory:  $('pnDatasetStory'),
            readout:       $('pn3dReadout'),
            lossReadout:   $('pnLossReadout'),
            converge:      $('pnConverge'),
            kpiEpoch:      $('pnKEpoch'),
            kpiLoss:       $('pnKLoss'),
            kpiMis:        $('pnKMis'),
            kpiN:          $('pnKN'),
            w0Slider:      $('pnW0'),     w0Num:     $('pnW0Num'),
            w1Slider:      $('pnW1'),     w1Num:     $('pnW1Num'),
            w2Slider:      $('pnW2'),     w2Num:     $('pnW2Num'),
            bSlider:       $('pnB'),      bNum:      $('pnBNum'),
            etaSlider:     $('pnEta'),    etaNum:    $('pnEtaNum'),
            btnStep:       $('pnBtnStep'),
            btnStep100:    $('pnBtnStep100'),
            btnAuto:       $('pnBtnAuto'),
            btnResetW:     $('pnBtnResetW'),
            btnRegen:      $('pnBtnRegen'),
            presetBlobs:   $('pnPresetBlobs'),
            presetHyper:   $('pnPresetHyper'),
            presetOverlap: $('pnPresetOverlap'),
            presetSlabs:   $('pnPresetSlabs'),
            presetXor:     $('pnPresetXor'),
            presetShells:  $('pnPresetShells'),
        };
    }

    // ── Plotly + Chart.js bootstrap ──────────────────────────
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
    function ensureChart () {
        if (typeof window.Chart !== 'undefined') return Promise.resolve();
        return new Promise((resolve) => {
            const tick = () => {
                if (typeof window.Chart !== 'undefined') resolve();
                else setTimeout(tick, 60);
            };
            tick();
        });
    }

    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    // ── Algorithm: hinge loss + perceptron update ────────────
    function predict (p) {
        return state.w0 * p.x + state.w1 * p.y + state.w2 * p.z + state.b;
    }
    function classify (p) { return predict(p) >= 0 ? 1 : -1; }

    function recomputeStats () {
        let loss = 0;
        let mis = 0;
        for (const p of state.data) {
            const z = predict(p);
            const margin = p.t * z;
            loss += Math.max(0, -margin);
            if (margin <= 0) mis++;
        }
        state.currentLoss = loss / state.data.length;
        state.misclassifiedCount = mis;
        state.converged = mis === 0 && state.epoch > 0;
    }

    function trainEpoch () {
        // Per-example (online) updates — classical perceptron rule.
        for (const p of state.data) {
            const z = predict(p);
            if (p.t * z <= 0) {
                state.w0 += state.eta * p.t * p.x;
                state.w1 += state.eta * p.t * p.y;
                state.w2 += state.eta * p.t * p.z;
                state.b  += state.eta * p.t;
            }
        }
        state.epoch++;
        recomputeStats();
        state.lossHistory.push({ x: state.epoch, y: state.currentLoss });
        if (state.lossHistory.length > 400) {
            const decimated = [];
            for (let i = 0; i < state.lossHistory.length; i += 2) decimated.push(state.lossHistory[i]);
            state.lossHistory = decimated;
        }
        syncSlidersFromState();
    }

    function syncSlidersFromState () {
        if (els.w0Slider) { els.w0Slider.value = state.w0.toFixed(3); els.w0Num.value = state.w0.toFixed(3); }
        if (els.w1Slider) { els.w1Slider.value = state.w1.toFixed(3); els.w1Num.value = state.w1.toFixed(3); }
        if (els.w2Slider) { els.w2Slider.value = state.w2.toFixed(3); els.w2Num.value = state.w2.toFixed(3); }
        if (els.bSlider)  { els.bSlider.value  = state.b.toFixed(3);  els.bNum.value  = state.b.toFixed(3);  }
    }

    // ── 3D rendering ─────────────────────────────────────────
    function buildPlaneTrace () {
        const xs = [], ys = [];
        for (let i = 0; i < PLANE_GRID; i++) {
            const t = -PLANE_RANGE + 2 * PLANE_RANGE * (i / (PLANE_GRID - 1));
            xs.push(t); ys.push(t);
        }
        // Avoid div-by-zero when w2 is set to 0.
        const w2safe = Math.abs(state.w2) < 0.05 ? (state.w2 >= 0 ? 0.05 : -0.05) : state.w2;
        const z = ys.map((y) => xs.map((x) => -(state.w0 * x + state.w1 * y + state.b) / w2safe));
        return {
            type: 'surface',
            x: xs, y: ys, z,
            colorscale: [[0, 'rgba(79,70,229,0.25)'], [1, 'rgba(79,70,229,0.55)']],
            showscale: false,
            opacity: 0.6,
            hoverinfo: 'skip',
            name: 'plane',
        };
    }

    function buildNormalArrow () {
        const mag = Math.sqrt(state.w0 ** 2 + state.w1 ** 2 + state.w2 ** 2);
        const len = 1.25;
        const norm = mag > 1e-6 ? mag : 1;
        return {
            type: 'scatter3d',
            mode: 'lines+markers',
            x: [0, state.w0 * len / norm],
            y: [0, state.w1 * len / norm],
            z: [0, state.w2 * len / norm],
            line: { color: COLORS.normal, width: 6 },
            marker: { color: COLORS.normal, size: [0, 6] },
            hoverinfo: 'skip',
            name: 'normal w',
            showlegend: false,
        };
    }

    function buildPointTraces () {
        const pos = [], neg = [], mis = [];
        for (const p of state.data) {
            const z = predict(p);
            const correct = p.t * z > 0;
            (p.t === 1 ? pos : neg).push(p);
            if (!correct) mis.push(p);
        }
        const traces = [
            {
                type: 'scatter3d', mode: 'markers',
                x: pos.map(p => p.x), y: pos.map(p => p.y), z: pos.map(p => p.z),
                marker: { color: COLORS.pos, size: 4, opacity: 0.85,
                          line: { color: '#16a34a', width: 0.5 } },
                hovertemplate: 'class +1<br>(%{x:.2f}, %{y:.2f}, %{z:.2f})<extra></extra>',
                name: 'class +1',
            },
            {
                type: 'scatter3d', mode: 'markers',
                x: neg.map(p => p.x), y: neg.map(p => p.y), z: neg.map(p => p.z),
                marker: { color: COLORS.neg, size: 4, opacity: 0.85,
                          line: { color: '#dc2626', width: 0.5 } },
                hovertemplate: 'class −1<br>(%{x:.2f}, %{y:.2f}, %{z:.2f})<extra></extra>',
                name: 'class -1',
            },
        ];
        if (mis.length) {
            traces.push({
                type: 'scatter3d', mode: 'markers',
                x: mis.map(p => p.x), y: mis.map(p => p.y), z: mis.map(p => p.z),
                marker: {
                    color: 'rgba(0,0,0,0)',
                    size: 10,
                    line: { color: COLORS.mis, width: 2.5 },
                },
                hoverinfo: 'skip',
                name: 'misclassified',
            });
        }
        return traces;
    }

    function buildLayout () {
        const dark = isDark();
        const ink   = dark ? '#e7e5e4' : '#1c1917';
        const muted = dark ? '#a8a29e' : '#78716c';
        const grid  = dark ? 'rgba(245,245,244,0.10)' : 'rgba(28,25,23,0.08)';
        const line  = dark ? 'rgba(245,245,244,0.22)' : 'rgba(28,25,23,0.22)';
        const fmt = (name) => ({
            title: { text: name, font: { color: muted, size: 11, family: 'Inter, system-ui, sans-serif' } },
            color: ink, gridcolor: grid, linecolor: line, zerolinecolor: grid,
            range: [-PLANE_RANGE, PLANE_RANGE],
            tickfont: { color: muted, size: 10, family: 'JetBrains Mono, monospace' },
            showbackground: false,
        });
        return {
            scene: {
                xaxis: fmt('x'),
                yaxis: fmt('y'),
                zaxis: fmt('z'),
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

    async function render3D () {
        if (!els.plot3d) return;
        await ensurePlotly();
        const traces = [
            buildPlaneTrace(),
            buildNormalArrow(),
            ...buildPointTraces(),
        ];
        await window.Plotly.react(els.plot3d, traces, buildLayout(), {
            displaylogo: false,
            responsive: true,
            modeBarButtonsToRemove: ['toImage', 'sendDataToCloud', 'orbitRotation', 'tableRotation', 'resetCameraLastSave3d'],
        });
        if (els.readout) {
            els.readout.innerHTML =
                '<span>w=(' + state.w0.toFixed(2) + ', ' + state.w1.toFixed(2) + ', ' + state.w2.toFixed(2) + ')</span>' +
                '<span>b=' + state.b.toFixed(2) + '</span>';
        }
    }

    // ── Loss-curve chart ─────────────────────────────────────
    let lossChart = null;
    function tickCol () { return isDark() ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)'; }
    function gridCol () { return isDark() ? 'rgba(245,245,244,0.08)' : 'rgba(28,25,23,0.06)'; }

    async function setupLossChart () {
        await ensureChart();
        if (lossChart || !els.lossCanvas) return;
        lossChart = new window.Chart(els.lossCanvas, {
            type: 'line',
            data: { datasets: [{
                label: 'hinge loss', data: [], borderColor: '#4f46e5',
                backgroundColor: 'rgba(79,70,229,0.10)', borderWidth: 2,
                pointRadius: 0, tension: 0.2, fill: true,
            }] },
            options: {
                responsive: true, maintainAspectRatio: false, parsing: false,
                scales: {
                    x: { type: 'linear',
                         title: { display: true, text: 'epoch', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         grid: { color: gridCol() } },
                    y: { title: { display: true, text: 'hinge loss', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         grid: { color: gridCol() }, beginAtZero: true },
                },
                plugins: { legend: { display: false } },
            },
        });
    }

    function renderLoss () {
        if (!lossChart) return;
        lossChart.data.datasets[0].data = state.lossHistory;
        lossChart.update('none');
        if (els.lossReadout) {
            els.lossReadout.innerHTML = state.epoch > 0
                ? '<span>epoch ' + state.epoch + '</span><span>loss = ' + state.currentLoss.toFixed(4) + '</span>'
                : '<span>train to draw the curve</span>';
        }
    }

    // ── KPIs + convergence banner ────────────────────────────
    function renderKPIs () {
        if (els.kpiEpoch) els.kpiEpoch.textContent = state.epoch;
        if (els.kpiLoss)  els.kpiLoss.textContent  = state.epoch === 0 ? '—' : state.currentLoss.toFixed(4);
        if (els.kpiMis)   els.kpiMis.textContent   = state.epoch === 0 ? '—' : state.misclassifiedCount;
        if (els.kpiN)     els.kpiN.textContent     = state.data.length;
    }

    function renderConvergeBanner () {
        if (!els.converge) return;
        els.converge.classList.remove('is-converged', 'is-stuck', 'is-visible');
        if (state.converged) {
            els.converge.innerHTML =
                '<span><strong>Converged in ' + state.epoch + ' epoch' + (state.epoch === 1 ? '' : 's') +
                '.</strong> Zero misclassified points — Novikoff&rsquo;s theorem says this <em>had</em> to happen on linearly separable data.</span>';
            els.converge.classList.add('is-converged', 'is-visible');
        } else if (state.epoch >= 50 && state.misclassifiedCount > 0 && state.misclassifiedCount === state.lastStuckCount) {
            els.converge.innerHTML =
                '<span><strong>Still misclassifying ' + state.misclassifiedCount + ' point' +
                (state.misclassifiedCount === 1 ? '' : 's') + '</strong> after ' + state.epoch +
                ' epochs. This dataset may not be linearly separable &mdash; perceptron can&rsquo;t converge.</span>';
            els.converge.classList.add('is-stuck', 'is-visible');
        }
        state.lastStuckCount = state.misclassifiedCount;
    }

    // ── Master render ────────────────────────────────────────
    function renderAll () {
        recomputeStats();
        render3D();
        renderLoss();
        renderKPIs();
        renderConvergeBanner();
    }

    // ── Dataset switching ────────────────────────────────────
    function selectDataset (key) {
        const spec = DATASETS[key] || DATASETS.blobs3d;
        state.key  = key;
        state.spec = spec;
        state.data = spec.generate(mulberry32(42));
        if (els.datasetStory) els.datasetStory.textContent = spec.story;
        if (els.etaSlider && spec.recommendedEta != null) {
            els.etaSlider.value = String(spec.recommendedEta);
            els.etaNum.value    = String(spec.recommendedEta);
            state.eta = spec.recommendedEta;
        }
        if (els.datasetSel && els.datasetSel.value !== key) els.datasetSel.value = key;
        resetTraining();
        renderAll();
    }

    function regenerateData () {
        state.data = state.spec.generate(mulberry32(Math.floor(Math.random() * 1e9)));
        resetTraining();
        renderAll();
    }

    function resetTraining () {
        state.epoch = 0;
        state.currentLoss = 0;
        state.misclassifiedCount = 0;
        state.converged = false;
        state.lossHistory = [];
        state.lastStuckCount = -1;
        if (els.converge) {
            els.converge.classList.remove('is-converged', 'is-stuck', 'is-visible');
        }
    }

    function resetWeights () {
        state.w0 = 1; state.w1 = -1; state.w2 = 1; state.b = 0;
        syncSlidersFromState();
        resetTraining();
        renderAll();
    }

    // ── Wire-up ──────────────────────────────────────────────
    function wireControls () {
        function link (slider, num, onChange) {
            slider.addEventListener('input', () => { num.value = slider.value; onChange(); });
            num.addEventListener('input',   () => { slider.value = num.value; onChange(); });
        }
        const onWeightChange = () => {
            state.w0 = parseFloat(els.w0Slider.value);
            state.w1 = parseFloat(els.w1Slider.value);
            state.w2 = parseFloat(els.w2Slider.value);
            state.b  = parseFloat(els.bSlider.value);
            // Manual edits invalidate the training history
            if (state.epoch > 0) resetTraining();
            renderAll();
        };
        link(els.w0Slider, els.w0Num, onWeightChange);
        link(els.w1Slider, els.w1Num, onWeightChange);
        link(els.w2Slider, els.w2Num, onWeightChange);
        link(els.bSlider,  els.bNum,  onWeightChange);
        link(els.etaSlider, els.etaNum, () => { state.eta = parseFloat(els.etaSlider.value); });

        els.btnStep.addEventListener('click', () => { trainEpoch(); renderAll(); });
        els.btnStep100.addEventListener('click', () => {
            for (let i = 0; i < 100; i++) {
                trainEpoch();
                if (state.converged) break;
            }
            renderAll();
        });
        els.btnResetW.addEventListener('click', resetWeights);
        els.btnRegen.addEventListener('click', regenerateData);

        els.btnAuto.addEventListener('click', () => {
            if (state.autoTimer) {
                clearInterval(state.autoTimer); state.autoTimer = null;
                els.btnAuto.textContent = '▶ Auto-train';
                return;
            }
            els.btnAuto.textContent = '⏸ Pause';
            state.autoTimer = setInterval(() => {
                for (let i = 0; i < 3; i++) {
                    if (state.converged) break;
                    trainEpoch();
                }
                renderAll();
                if (state.converged) {
                    clearInterval(state.autoTimer); state.autoTimer = null;
                    els.btnAuto.textContent = '▶ Auto-train';
                }
            }, 120);
        });

        if (els.datasetSel) {
            els.datasetSel.addEventListener('change', (ev) => selectDataset(ev.target.value));
        }
        const presets = {
            blobs3d:    els.presetBlobs,
            hyperplane: els.presetHyper,
            overlap:    els.presetOverlap,
            slabs:      els.presetSlabs,
            xor3d:      els.presetXor,
            shells:     els.presetShells,
        };
        Object.entries(presets).forEach(([key, btn]) => {
            if (btn) btn.addEventListener('click', () => selectDataset(key));
        });
    }

    // ── Boot ─────────────────────────────────────────────────
    async function boot () {
        captureDom();
        if (!els.plot3d) return;
        syncSlidersFromState();
        if (els.etaSlider) els.etaSlider.value = String(state.eta);
        if (els.etaNum)    els.etaNum.value    = String(state.eta);
        if (els.datasetStory) els.datasetStory.textContent = state.spec.story;
        wireControls();
        await setupLossChart();
        await render3D();
        renderLoss();
        renderKPIs();

        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        // Theme reactivity
        const themeObs = new MutationObserver(() => {
            render3D();
            if (lossChart) {
                Object.values(lossChart.options.scales).forEach((s) => {
                    if (s.ticks) s.ticks.color = tickCol();
                    if (s.grid)  s.grid.color  = gridCol();
                    if (s.title) s.title.color = tickCol();
                });
                lossChart.update();
            }
        });
        themeObs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    }

    // ── Init (bottom-of-IIFE — avoids TDZ on consts above) ──
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
