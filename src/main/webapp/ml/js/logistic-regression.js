/*
 * logistic-regression.js — interactive binary classifier with gradient descent.
 *
 * Two panels:
 *   1. Left  — scatter of points + decision boundary + optional probability field.
 *              Click to add points (toggle class via dropdown).
 *   2. Right — training-loss curve.  Updates after every step / batch.
 *
 * Logic ported from the legacy /Logistic_Regression.jsp inline script.
 * Same algorithm (batch gradient descent on cross-entropy + optional L2),
 * same dataset presets (Balanced / Overlap / Imbalanced / XOR), now with
 * a live loss-history chart and the new theme.
 */

(function () {
    'use strict';

    // ── Helpers ──────────────────────────────────────────────
    const $ = (id) => document.getElementById(id);
    function link (range, num, onInput) {
        range.addEventListener('input', () => { num.value = range.value; if (onInput) onInput(); });
        num.addEventListener('input',   () => { range.value = num.value; if (onInput) onInput(); });
    }
    function randn () {
        let u = 0, v = 0;
        while (u === 0) u = Math.random();
        while (v === 0) v = Math.random();
        return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v);
    }
    const sigmoid = (z) => 1 / (1 + Math.exp(-z));

    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    // ── Boot ─────────────────────────────────────────────────
    function boot () {
        const w0 = $('lrW0'),  w1 = $('lrW1'),  b = $('lrB');
        const w0Num = $('lrW0Num'), w1Num = $('lrW1Num'), bNum = $('lrBNum');
        const th  = $('lrTh'),  thNum = $('lrThNum');
        const lr  = $('lrLr'),  lrNum = $('lrLrNum');
        const lam = $('lrLam'), lamNum = $('lrLamNum');
        if (!w0 || !w1 || !b) return;

        const classSel = $('lrClassSel');
        const classIndicator = $('lrClassIndicator');
        const classIndicatorText = $('lrClassIndicatorText');
        const showField = $('lrShowField');
        const probe = $('lrProbe');

        const kLoss  = $('lrKLoss');
        const kAcc   = $('lrKAcc');
        const kSteps = $('lrKSteps');
        const kN     = $('lrKN');
        const kDelta = $('lrKDelta');

        const cmTN = $('lrCmTN'), cmFP = $('lrCmFP'), cmFN = $('lrCmFN'), cmTP = $('lrCmTP');

        // ── State ─────────────────────────────────────────────
        let points = [];               // {x, y, t}
        let stepCount = 0;             // total gradient steps
        let stepBatches = 0;           // number of times stepGD() called
        let lastLoss = null;
        let lossHistory = [];          // sparse [{step, loss}, ...]
        let autoTimer = null;

        // ── Chart: boundary + scatter ────────────────────────
        const ctx = $('lrChart');
        const chart = new Chart(ctx, {
            type: 'scatter',
            data: { datasets: [
                { label: 'Class 0',           data: [], pointRadius: 5, backgroundColor: '#ef4444', order: 1 },
                { label: 'Class 1',           data: [], pointRadius: 5, backgroundColor: '#22c55e', order: 1 },
                { label: 'Decision boundary', type: 'line', data: [], borderWidth: 2, pointRadius: 0,
                  borderDash: [6, 6], parsing: false, borderColor: '#4f46e5', order: 2 },
                { label: 'Prob field', data: [], type: 'scatter', pointRadius: 2, order: 0,
                  backgroundColor: (c) => {
                      const p = (c.raw && c.raw.p !== undefined) ? c.raw.p : 0;
                      return 'rgba(79, 70, 229,' + (p * 0.28).toFixed(3) + ')';
                  }, hidden: true },
            ] },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { min: -5, max: 5, ticks: { color: chartTickColor() }, grid: { color: chartGridColor() } },
                    y: { min: -5, max: 5, ticks: { color: chartTickColor() }, grid: { color: chartGridColor() } },
                },
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: (c) =>
                        (c.raw && c.raw.x !== undefined) ? '(' + c.raw.x.toFixed(2) + ', ' + c.raw.y.toFixed(2) + ')' : ''
                    } },
                },
            },
        });

        // ── Chart: loss curve ────────────────────────────────
        const ctxLoss = $('lrLossChart');
        const lossChart = new Chart(ctxLoss, {
            type: 'line',
            data: { datasets: [{
                label: 'Loss', data: [], borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.10)',
                borderWidth: 2, pointRadius: 0, tension: 0.2, fill: true,
            }] },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                parsing: false,
                scales: {
                    x: { type: 'linear', title: { display: true, text: 'training step', color: chartTickColor(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: chartTickColor(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: chartGridColor() } },
                    y: { title: { display: true, text: 'log loss', color: chartTickColor(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: chartTickColor(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: chartGridColor() } },
                },
                plugins: { legend: { display: false } },
            },
        });

        // ── Wiring ───────────────────────────────────────────
        link(w0, w0Num, updateAll);
        link(w1, w1Num, updateAll);
        link(b,  bNum,  updateAll);
        link(th, thNum, updateAll);
        link(lr, lrNum);
        link(lam, lamNum);

        ctx.addEventListener('click', (evt) => {
            const pos = Chart.helpers.getRelativePosition(evt, chart);
            const x = chart.scales.x.getValueForPixel(chart.scales.x.left + pos.x * chart.width / chart.chartArea.width);
            const y = chart.scales.y.getValueForPixel(chart.scales.y.top  + pos.y * chart.height / chart.chartArea.height);
            const t = Number(classSel.value);
            points.push({ x, y, t });
            renderPoints(); updateAll();
        });
        if (probe) {
            ctx.addEventListener('mousemove', (evt) => {
                const pos = Chart.helpers.getRelativePosition(evt, chart);
                const x = chart.scales.x.getValueForPixel(chart.scales.x.left + pos.x * chart.width / chart.chartArea.width);
                const y = chart.scales.y.getValueForPixel(chart.scales.y.top  + pos.y * chart.height / chart.chartArea.height);
                const z = Number(w0.value) * x + Number(w1.value) * y + Number(b.value);
                const p = sigmoid(z);
                probe.textContent = 'x=' + x.toFixed(2) + '  y=' + y.toFixed(2) + '  z=' + z.toFixed(2) + '  p=' + p.toFixed(3);
            });
            ctx.addEventListener('mouseleave', () => { probe.textContent = 'hover the chart to probe σ(w·x + b)'; });
        }

        // Probability field — initialize visibility from the checkbox's
        // default-checked state, then keep it in sync on toggle.
        if (showField) {
            chart.data.datasets[3].hidden = !showField.checked;
            showField.addEventListener('change', () => {
                chart.data.datasets[3].hidden = !showField.checked;
                if (showField.checked) updateField();
                chart.update();
            });
        }

        // Class indicator — click to flip between Class 0 and Class 1.
        // It mirrors the (now hidden) classSel dropdown so the chart's
        // existing click-handler logic doesn't need to change.
        if (classIndicator) {
            classIndicator.addEventListener('click', () => {
                const next = classIndicator.dataset.class === '0' ? '1' : '0';
                classIndicator.dataset.class = next;
                if (classIndicatorText) classIndicatorText.textContent = 'Class ' + next;
                classSel.value = next;
            });
        }

        $('lrBtnStep').addEventListener('click',    () => { stepGD(1);   });
        $('lrBtnStep100').addEventListener('click', () => { stepGD(100); });
        $('lrBtnResetW').addEventListener('click',  () => resetWeights());
        $('lrBtnClear').addEventListener('click',   () => { points = []; renderPoints(); resetTraining(); updateAll(); });

        const btnAuto = $('lrBtnAuto');
        btnAuto.addEventListener('click', () => {
            if (autoTimer) {
                clearInterval(autoTimer); autoTimer = null;
                btnAuto.textContent = '▶ Auto-train';
                return;
            }
            btnAuto.textContent = '⏸ Pause';
            autoTimer = setInterval(() => stepGD(10), 120);
        });

        // Preset datasets
        const presets = {
            blobs:    () => loadDataset([{ cx: -1.5, cy: -1, std: 0.7, n: 60, t: 0 }, { cx: 1.3,  cy: 1, std: 0.7, n: 60, t: 1 }]),
            balanced: () => loadDataset([{ cx: -2,   cy: -1.5, std: 0.8, n: 60, t: 0 }, { cx: 2,    cy: 1.5, std: 0.8, n: 60, t: 1 }]),
            overlap:  () => loadDataset([{ cx: -1,   cy: -0.5, std: 1.2, n: 60, t: 0 }, { cx: 1,    cy: 0.5, std: 1.2, n: 60, t: 1 }]),
            imbalanced: () => loadDataset([{ cx: -1.5, cy: -1, std: 0.7, n: 20, t: 0 }, { cx: 1.3,  cy: 1, std: 0.7, n: 100, t: 1 }]),
            xor:      () => loadDataset([
                { cx: -1.5, cy: -1.5, std: 0.5, n: 30, t: 0 },
                { cx:  1.5, cy:  1.5, std: 0.5, n: 30, t: 0 },
                { cx: -1.5, cy:  1.5, std: 0.5, n: 30, t: 1 },
                { cx:  1.5, cy: -1.5, std: 0.5, n: 30, t: 1 },
            ]),
        };
        $('lrPresetBlobs').addEventListener('click',      presets.blobs);
        $('lrPresetBalanced').addEventListener('click',   presets.balanced);
        $('lrPresetOverlap').addEventListener('click',    presets.overlap);
        $('lrPresetImbalanced').addEventListener('click', presets.imbalanced);
        $('lrPresetXOR').addEventListener('click',        presets.xor);

        function loadDataset (clusters) {
            points = [];
            clusters.forEach(({ cx, cy, std, n, t }) => {
                for (let i = 0; i < n; i++) {
                    points.push({ x: cx + randn() * std, y: cy + randn() * std, t });
                }
            });
            resetTraining();
            renderPoints();
            updateAll();
        }

        // ── Rendering ────────────────────────────────────────
        function renderPoints () {
            chart.data.datasets[0].data = points.filter((p) => p.t === 0).map((p) => ({ x: p.x, y: p.y }));
            chart.data.datasets[1].data = points.filter((p) => p.t === 1).map((p) => ({ x: p.x, y: p.y }));
            kN.textContent = String(points.length);
        }
        function currentBoundaryPts () {
            const w0v = Number(w0.value), w1v = Number(w1.value), bv = Number(b.value);
            const xmin = chart.scales.x.min, xmax = chart.scales.x.max;
            const ymin = chart.scales.y.min, ymax = chart.scales.y.max;
            if (Math.abs(w1v) < 1e-9) {
                const x = -bv / (w0v || 1e-9);
                return [{ x, y: ymin }, { x, y: ymax }];
            }
            const yAt = (x) => -(w0v / w1v) * x - bv / w1v;
            return [{ x: xmin, y: yAt(xmin) }, { x: xmax, y: yAt(xmax) }];
        }
        function decisionLine () { chart.data.datasets[2].data = currentBoundaryPts(); }

        function updateField () {
            const ds = chart.data.datasets[3];
            ds.data.length = 0;
            const xs = 35, ys = 35;
            const xmin = chart.scales.x.min, xmax = chart.scales.x.max;
            const ymin = chart.scales.y.min, ymax = chart.scales.y.max;
            for (let i = 0; i < xs; i++) {
                const x = xmin + (xmax - xmin) * (i / (xs - 1));
                for (let j = 0; j < ys; j++) {
                    const y = ymin + (ymax - ymin) * (j / (ys - 1));
                    const z = Number(w0.value) * x + Number(w1.value) * y + Number(b.value);
                    ds.data.push({ x, y, p: sigmoid(z) });
                }
            }
        }

        function metrics () {
            if (points.length === 0) {
                kLoss.textContent = '—'; kAcc.textContent = '—'; kDelta.textContent = '—';
                cmTN.textContent = cmFP.textContent = cmFN.textContent = cmTP.textContent = '—';
                return;
            }
            const lambda = Number(lam.value), tau = Number(th.value);
            let loss = 0, correct = 0, TN = 0, FP = 0, FN = 0, TP = 0;
            for (const p of points) {
                const z = Number(w0.value) * p.x + Number(w1.value) * p.y + Number(b.value);
                const pr = sigmoid(z);
                const t = p.t, eps = 1e-9;
                loss += -(t * Math.log(pr + eps) + (1 - t) * Math.log(1 - pr + eps));
                const pred = pr >= tau ? 1 : 0;
                if (pred === t) correct++;
                if (t === 0 && pred === 0) TN++;
                else if (t === 0 && pred === 1) FP++;
                else if (t === 1 && pred === 0) FN++;
                else TP++;
            }
            loss /= points.length;
            const reg = lambda * (Number(w0.value) ** 2 + Number(w1.value) ** 2);
            const total = loss + reg;
            kDelta.textContent = (lastLoss !== null ? (total - lastLoss).toFixed(4) : '—');
            lastLoss = total;
            kLoss.textContent = total.toFixed(4);
            kAcc.textContent = (correct / points.length * 100).toFixed(1) + '%';
            kSteps.textContent = String(stepBatches);
            cmTN.textContent = TN; cmFP.textContent = FP; cmFN.textContent = FN; cmTP.textContent = TP;
            return total;
        }

        function pushLossHistory (lossVal) {
            lossHistory.push({ x: stepCount, y: lossVal });
            // Down-sample if history gets too dense
            if (lossHistory.length > 400) {
                const sampled = [];
                for (let i = 0; i < lossHistory.length; i += 2) sampled.push(lossHistory[i]);
                lossHistory = sampled;
            }
            lossChart.data.datasets[0].data = lossHistory;
            lossChart.update('none');
        }

        function updateAll () {
            decisionLine(); const total = metrics();
            renderPoints();
            if (showField && showField.checked) updateField();
            chart.update('none');
            if (total !== undefined && points.length > 0) {
                pushLossHistory(total);
            }
        }

        // ── Training (batch gradient descent) ────────────────
        function stepGD (steps) {
            const eta = Number(lr.value);
            const lambda = Number(lam.value);
            for (let s = 0; s < steps; s++) {
                if (points.length === 0) break;
                let g0 = 0, g1 = 0, gb = 0;
                for (const p of points) {
                    const z  = Number(w0.value) * p.x + Number(w1.value) * p.y + Number(b.value);
                    const pr = sigmoid(z);
                    const d  = pr - p.t;
                    g0 += d * p.x; g1 += d * p.y; gb += d;
                }
                g0 = g0 / points.length + 2 * lambda * Number(w0.value);
                g1 = g1 / points.length + 2 * lambda * Number(w1.value);
                gb = gb / points.length;
                w0.value = Number(w0.value) - eta * g0;
                w1.value = Number(w1.value) - eta * g1;
                b.value  = Number(b.value)  - eta * gb;
                w0Num.value = w0.value; w1Num.value = w1.value; bNum.value = b.value;
                stepCount++;
            }
            stepBatches++;
            updateAll();
        }

        function resetWeights () {
            w0.value = 1; w1.value = -1; b.value = 0;
            w0Num.value = 1; w1Num.value = -1; bNum.value = 0;
            resetTraining();
            updateAll();
        }

        function resetTraining () {
            stepCount = 0; stepBatches = 0;
            lastLoss = null;
            lossHistory = [];
            lossChart.data.datasets[0].data = lossHistory;
            lossChart.update();
        }

        // ── Theme observer ───────────────────────────────────
        const obs = new MutationObserver(() => {
            const tick = chartTickColor(), grid = chartGridColor();
            [chart, lossChart].forEach((c) => {
                Object.values(c.options.scales).forEach((s) => {
                    if (s.ticks)            s.ticks.color = tick;
                    if (s.grid)             s.grid.color = grid;
                    if (s.title && s.title.color !== undefined) s.title.color = tick;
                });
                c.update();
            });
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

        // KaTeX render (math card)
        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        // Initial state — auto-seed so users see something immediately
        presets.blobs();
        updateAll();
    }

    function chartTickColor () { return isDark() ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)'; }
    function chartGridColor () { return isDark() ? 'rgba(245,245,244,0.08)' : 'rgba(28,25,23,0.06)'; }

    // ── Init / bootstrap (placed at the bottom so every const above
    //    is initialized before boot() runs — avoids TDZ). ─────
    function bootWhenReady () {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', boot);
        } else {
            boot();
        }
    }
    if (typeof window.Chart === 'undefined') {
        // Chart.js loads via the JSP script tag — poll briefly if it's not ready.
        let waited = 0;
        const tick = setInterval(() => {
            waited += 60;
            if (typeof window.Chart !== 'undefined') {
                clearInterval(tick);
                bootWhenReady();
            } else if (waited > 10000) {
                clearInterval(tick);
                console.error('Chart.js failed to load — Logistic Regression demo unavailable');
            }
        }, 60);
    } else {
        bootWhenReady();
    }
})();
