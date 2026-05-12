/*
 * roc-auc.js — interactive ROC / AUC / Precision-Recall demo.
 *
 * Three Chart.js charts:
 *   1. ROC curve  — with a live operating-point marker tied to threshold τ
 *   2. PR  curve  — same model, ranked differently
 *   3. Dataset    — scatter with the decision boundary (smaller, secondary)
 *
 * Same logistic-regression mechanics as the LogReg page (training loop,
 * presets, sliders) but with the metrics charts as the focal visuals.
 */

(function () {
    'use strict';

    const $ = (id) => document.getElementById(id);
    function link (range, num, on) {
        range.addEventListener('input', () => { num.value = range.value; if (on) on(); });
        num.addEventListener('input',   () => { range.value = num.value; if (on) on(); });
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
    const tickCol = () => isDark() ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
    const gridCol = () => isDark() ? 'rgba(245,245,244,0.08)' : 'rgba(28,25,23,0.06)';

    function boot () {
        // ── DOM ──────────────────────────────────────────────
        const w0 = $('raW0'), w1 = $('raW1'), b = $('raB');
        const w0Num = $('raW0Num'), w1Num = $('raW1Num'), bNum = $('raBNum');
        const th  = $('raTh'),  thNum  = $('raThNum');
        const lr  = $('raLr'),  lrNum  = $('raLrNum');
        if (!w0) return;

        const classSel = $('raClassSel');
        const classIndicator = $('raClassIndicator');
        const classIndicatorText = $('raClassIndicatorText');
        const kAUC = $('raKAUC'),   kAP = $('raKAP');
        const aucBand = $('raAUCBand'), aucBandText = $('raAUCBandText');
        const apBand  = $('raAPBand'),  apBandText  = $('raAPBandText');
        const kAcc = $('raKAcc'),   kPrec = $('raKPrec'), kRec = $('raKRec'), kF1 = $('raKF1');
        const kN   = $('raKN');
        const opLabel = $('raOpLabel'), prOpLabel = $('raPrOpLabel');
        const cmTN = $('raCmTN'), cmFP = $('raCmFP'), cmFN = $('raCmFN'), cmTP = $('raCmTP');

        // ── State ────────────────────────────────────────────
        let points = [];
        let autoTimer = null;
        let probsCache = null;  // sorted [{prob, t}] for fast ROC/PR updates

        // ── Charts ───────────────────────────────────────────
        const ctxROC = $('raChartROC');
        const chartROC = new Chart(ctxROC, {
            type: 'line',
            data: { datasets: [
                { label: 'ROC',        data: [], borderColor: '#4f46e5', borderWidth: 2, pointRadius: 0,
                  fill: { target: 'origin', above: 'rgba(79, 70, 229, 0.10)' }, order: 2 },
                { label: 'Random',     data: [{ x: 0, y: 0 }, { x: 1, y: 1 }], borderDash: [5, 5],
                  borderColor: 'rgba(120,113,108,0.6)', borderWidth: 1, pointRadius: 0, order: 3 },
                { label: 'Operating',  data: [], type: 'scatter', backgroundColor: '#ec4899',
                  borderColor: '#fff', borderWidth: 2, pointRadius: 7, order: 1 },
            ] },
            options: {
                responsive: true, maintainAspectRatio: false, parsing: false,
                scales: {
                    x: { min: 0, max: 1, title: { display: true, text: 'False Positive Rate', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: gridCol() } },
                    y: { min: 0, max: 1, title: { display: true, text: 'True Positive Rate', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: gridCol() } },
                },
                plugins: { legend: { display: false } },
            },
        });

        const ctxPR = $('raChartPR');
        const chartPR = new Chart(ctxPR, {
            type: 'line',
            data: { datasets: [
                { label: 'PR',         data: [], borderColor: '#22c55e', borderWidth: 2, pointRadius: 0,
                  fill: { target: 'origin', above: 'rgba(34, 197, 94, 0.10)' }, order: 2 },
                { label: 'Operating',  data: [], type: 'scatter', backgroundColor: '#ec4899',
                  borderColor: '#fff', borderWidth: 2, pointRadius: 7, order: 1 },
            ] },
            options: {
                responsive: true, maintainAspectRatio: false, parsing: false,
                scales: {
                    x: { min: 0, max: 1, title: { display: true, text: 'Recall', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: gridCol() } },
                    y: { min: 0, max: 1, title: { display: true, text: 'Precision', color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } }, grid: { color: gridCol() } },
                },
                plugins: { legend: { display: false } },
            },
        });

        const ctxXY = $('raChartXY');
        const chartXY = new Chart(ctxXY, {
            type: 'scatter',
            data: { datasets: [
                { label: 'Class 0', data: [], pointRadius: 4, backgroundColor: '#ef4444' },
                { label: 'Class 1', data: [], pointRadius: 4, backgroundColor: '#22c55e' },
                { label: 'Decision boundary', type: 'line', data: [], pointRadius: 0, borderWidth: 2,
                  borderDash: [6, 6], parsing: false, borderColor: '#4f46e5' },
            ] },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: {
                    x: { min: -5, max: 5, ticks: { color: tickCol() }, grid: { color: gridCol() } },
                    y: { min: -5, max: 5, ticks: { color: tickCol() }, grid: { color: gridCol() } },
                },
                plugins: { legend: { display: false } },
            },
        });

        // ── Wiring ───────────────────────────────────────────
        link(w0, w0Num, updateAll);
        link(w1, w1Num, updateAll);
        link(b,  bNum,  updateAll);
        link(lr, lrNum);
        // Threshold changes only need to update the operating point + metrics.
        // Animate the marker for a smooth visual link between slider and point.
        link(th, thNum, () => updateOperatingPoint(true));

        ctxXY.addEventListener('click', (evt) => {
            const pos = Chart.helpers.getRelativePosition(evt, chartXY);
            const x = chartXY.scales.x.getValueForPixel(chartXY.scales.x.left + pos.x * chartXY.width / chartXY.chartArea.width);
            const y = chartXY.scales.y.getValueForPixel(chartXY.scales.y.top  + pos.y * chartXY.height / chartXY.chartArea.height);
            points.push({ x, y, t: Number(classSel.value) });
            renderPoints(); updateAll();
        });

        // Class indicator — click flips between Class 0 and Class 1.
        if (classIndicator) {
            classIndicator.addEventListener('click', () => {
                const next = classIndicator.dataset.class === '0' ? '1' : '0';
                classIndicator.dataset.class = next;
                if (classIndicatorText) classIndicatorText.textContent = 'Class ' + next;
                classSel.value = next;
            });
        }

        $('raBtnStep').addEventListener('click',    () => { stepGD(1);   });
        $('raBtnStep100').addEventListener('click', () => { stepGD(100); });
        $('raBtnResetW').addEventListener('click',  () => resetWeights());
        $('raBtnClear').addEventListener('click',   () => { points = []; renderPoints(); updateAll(); });

        const btnAuto = $('raBtnAuto');
        btnAuto.addEventListener('click', () => {
            if (autoTimer) {
                clearInterval(autoTimer); autoTimer = null;
                btnAuto.textContent = '▶ Auto-train';
                return;
            }
            btnAuto.textContent = '⏸ Pause';
            autoTimer = setInterval(() => stepGD(10), 120);
        });

        const presets = {
            blobs:    () => loadDataset([{ cx: -1.5, cy: -1, std: 0.7, n: 60, t: 0 }, { cx: 1.3,  cy: 1, std: 0.7, n: 60, t: 1 }]),
            balanced: () => loadDataset([{ cx: -2,   cy: -1.5, std: 0.8, n: 60, t: 0 }, { cx: 2, cy: 1.5, std: 0.8, n: 60, t: 1 }]),
            overlap:  () => loadDataset([{ cx: -1,   cy: -0.5, std: 1.2, n: 60, t: 0 }, { cx: 1, cy: 0.5, std: 1.2, n: 60, t: 1 }]),
            imbalanced: () => loadDataset([{ cx: -1.5, cy: -1, std: 0.7, n: 20, t: 0 }, { cx: 1.3, cy: 1, std: 0.7, n: 100, t: 1 }]),
            perfect: () => loadDataset([{ cx: -2.5, cy: -2.5, std: 0.4, n: 60, t: 0 }, { cx: 2.5, cy: 2.5, std: 0.4, n: 60, t: 1 }]),
        };
        $('raPresetBlobs').addEventListener('click',      presets.blobs);
        $('raPresetBalanced').addEventListener('click',   presets.balanced);
        $('raPresetOverlap').addEventListener('click',    presets.overlap);
        $('raPresetImbalanced').addEventListener('click', presets.imbalanced);
        $('raPresetPerfect').addEventListener('click',    presets.perfect);

        function loadDataset (clusters) {
            points = [];
            clusters.forEach(({ cx, cy, std, n, t }) => {
                for (let i = 0; i < n; i++) {
                    points.push({ x: cx + randn() * std, y: cy + randn() * std, t });
                }
            });
            renderPoints(); updateAll();
        }

        // ── Render ───────────────────────────────────────────
        function renderPoints () {
            chartXY.data.datasets[0].data = points.filter((p) => p.t === 0).map((p) => ({ x: p.x, y: p.y }));
            chartXY.data.datasets[1].data = points.filter((p) => p.t === 1).map((p) => ({ x: p.x, y: p.y }));
            kN.textContent = String(points.length);
        }
        function decisionLine () {
            const w0v = Number(w0.value), w1v = Number(w1.value), bv = Number(b.value);
            const xmin = chartXY.scales.x.min, xmax = chartXY.scales.x.max;
            const ymin = chartXY.scales.y.min, ymax = chartXY.scales.y.max;
            let pts;
            if (Math.abs(w1v) < 1e-9) {
                const x = -bv / (w0v || 1e-9);
                pts = [{ x, y: ymin }, { x, y: ymax }];
            } else {
                const yAt = (x) => -(w0v / w1v) * x - bv / w1v;
                pts = [{ x: xmin, y: yAt(xmin) }, { x: xmax, y: yAt(xmax) }];
            }
            chartXY.data.datasets[2].data = pts;
        }

        // ── ROC / PR / AUC computation ───────────────────────
        function recomputeCurves () {
            if (points.length === 0) {
                chartROC.data.datasets[0].data = [];
                chartPR.data.datasets[0].data  = [];
                kAUC.textContent = '—'; kAP.textContent = '—';
                probsCache = null;
                applyBand(aucBand, aucBandText, NaN);
                applyBand(apBand,  apBandText,  NaN);
                return;
            }
            const probs = points.map((p) => ({
                prob: sigmoid(Number(w0.value) * p.x + Number(w1.value) * p.y + Number(b.value)),
                t: p.t,
            }));
            probs.sort((a, b) => b.prob - a.prob);
            probsCache = probs;

            const totalP = probs.filter((q) => q.t === 1).length;
            const totalN = probs.length - totalP;

            // ROC: sweep through sorted probabilities, accumulate TPR/FPR
            const roc = [{ x: 0, y: 0 }];
            let tp = 0, fp = 0;
            for (const q of probs) {
                if (q.t === 1) tp++; else fp++;
                roc.push({ x: totalN ? fp / totalN : 0, y: totalP ? tp / totalP : 0 });
            }
            chartROC.data.datasets[0].data = roc;
            // AUC via trapezoidal integration
            let auc = 0;
            for (let i = 1; i < roc.length; i++) auc += (roc[i].x - roc[i - 1].x) * (roc[i].y + roc[i - 1].y) / 2;
            kAUC.textContent = isFinite(auc) ? auc.toFixed(3) : '—';
            applyBand(aucBand, aucBandText, auc);

            // PR: same sweep but precision = tp / (tp + fp), recall = tp / totalP
            const pr = [];
            tp = 0; fp = 0;
            for (const q of probs) {
                if (q.t === 1) tp++; else fp++;
                pr.push({ x: totalP ? tp / totalP : 0, y: (tp + fp) ? tp / (tp + fp) : 1 });
            }
            chartPR.data.datasets[0].data = pr;
            // PR AUC (average precision) — sum of precision * Δrecall
            let ap = 0;
            for (let i = 1; i < pr.length; i++) ap += (pr[i].x - pr[i - 1].x) * pr[i].y;
            kAP.textContent = isFinite(ap) ? ap.toFixed(3) : '—';
            applyBand(apBand, apBandText, ap);
        }

        // Map AUC score → verbal band (sklearn / interview lore).  PR AUC's
        // bands shift down because random PR ≠ 0.5 (depends on base rate),
        // but for our roughly-balanced datasets the same thresholds work.
        function applyBand (badge, textEl, score) {
            if (!badge || !textEl || !isFinite(score)) {
                if (badge) badge.className = 'ra-auc-band is-random';
                if (textEl) textEl.textContent = 'awaiting data';
                return;
            }
            let cls = 'is-random', label = 'Effectively random';
            if      (score >= 0.95) { cls = 'is-excellent'; label = 'Excellent ranking'; }
            else if (score >= 0.85) { cls = 'is-good';      label = 'Good ranking'; }
            else if (score >= 0.70) { cls = 'is-fair';      label = 'Fair — room to grow'; }
            else if (score >= 0.55) { cls = 'is-weak';      label = 'Weak — barely beats random'; }
            else if (score >= 0.45) { cls = 'is-random';    label = 'Effectively random'; }
            else                    { cls = 'is-anti';      label = 'Anti-correlated — invert predictions'; }
            badge.className = 'ra-auc-band ' + cls;
            textEl.textContent = label;
        }

        function updateOperatingPoint (animate) {
            const tau = Number(th.value);
            if (!probsCache || probsCache.length === 0) {
                chartROC.data.datasets[2].data = [];
                chartPR.data.datasets[1].data  = [];
                if (opLabel) opLabel.textContent = '';
                if (prOpLabel) prOpLabel.textContent = '';
                updateConfusion(0, 0, 0, 0);
                chartROC.update('none'); chartPR.update('none');
                return;
            }
            // At threshold τ: predict positive iff prob >= τ
            let TP = 0, FP = 0, TN = 0, FN = 0;
            for (const q of probsCache) {
                const pred = q.prob >= tau ? 1 : 0;
                if (q.t === 1 && pred === 1) TP++;
                else if (q.t === 1 && pred === 0) FN++;
                else if (q.t === 0 && pred === 1) FP++;
                else TN++;
            }
            const totalP = TP + FN, totalN = TN + FP;
            const tpr = totalP ? TP / totalP : 0;
            const fpr = totalN ? FP / totalN : 0;
            const precision = (TP + FP) ? TP / (TP + FP) : 1;
            const recall = totalP ? TP / totalP : 0;
            const f1 = (precision + recall > 0) ? 2 * precision * recall / (precision + recall) : 0;

            chartROC.data.datasets[2].data = [{ x: fpr, y: tpr }];
            chartPR.data.datasets[1].data  = [{ x: recall, y: precision }];
            if (opLabel)   opLabel.textContent   = 'τ=' + tau.toFixed(2) + '  FPR=' + fpr.toFixed(2) + '  TPR=' + tpr.toFixed(2);
            if (prOpLabel) prOpLabel.textContent = 'τ=' + tau.toFixed(2) + '  P=' + precision.toFixed(2) + '  R=' + recall.toFixed(2);

            updateConfusion(TN, FP, FN, TP);
            updateAccPrecRecF1(TP + TN, points.length, precision, recall, f1);
            // Smooth marker animation when the threshold changes from a
            // slider event; immediate when called as part of a full retrain.
            const mode = animate ? undefined : 'none';
            chartROC.update(mode); chartPR.update(mode);
        }

        function updateConfusion (TN, FP, FN, TP) {
            cmTN.textContent = TN; cmFP.textContent = FP; cmFN.textContent = FN; cmTP.textContent = TP;
        }
        function updateAccPrecRecF1 (correct, total, p, r, f1) {
            if (total === 0) {
                kAcc.textContent = '—'; kPrec.textContent = '—'; kRec.textContent = '—'; kF1.textContent = '—';
                return;
            }
            kAcc.textContent = (correct / total * 100).toFixed(1) + '%';
            kPrec.textContent = isFinite(p) ? p.toFixed(3) : '—';
            kRec.textContent  = isFinite(r) ? r.toFixed(3) : '—';
            kF1.textContent   = isFinite(f1) ? f1.toFixed(3) : '—';
        }

        function updateAll () {
            decisionLine();
            recomputeCurves();
            updateOperatingPoint();
            chartXY.update('none');
        }

        // ── Training ─────────────────────────────────────────
        function stepGD (steps) {
            const eta = Number(lr.value);
            for (let s = 0; s < steps; s++) {
                if (points.length === 0) break;
                let g0 = 0, g1 = 0, gb = 0;
                for (const p of points) {
                    const z = Number(w0.value) * p.x + Number(w1.value) * p.y + Number(b.value);
                    const pr = sigmoid(z);
                    const d = pr - p.t;
                    g0 += d * p.x; g1 += d * p.y; gb += d;
                }
                g0 /= points.length; g1 /= points.length; gb /= points.length;
                w0.value = Number(w0.value) - eta * g0;
                w1.value = Number(w1.value) - eta * g1;
                b.value  = Number(b.value)  - eta * gb;
                w0Num.value = w0.value; w1Num.value = w1.value; bNum.value = b.value;
            }
            updateAll();
        }

        function resetWeights () {
            w0.value = 1; w1.value = -1; b.value = 0;
            w0Num.value = 1; w1Num.value = -1; bNum.value = 0;
            updateAll();
        }

        // ── Theme + KaTeX ────────────────────────────────────
        const obs = new MutationObserver(() => {
            [chartROC, chartPR, chartXY].forEach((c) => {
                Object.values(c.options.scales).forEach((s) => {
                    if (s.ticks) s.ticks.color = tickCol();
                    if (s.grid)  s.grid.color  = gridCol();
                    if (s.title) s.title.color = tickCol();
                });
                c.update();
            });
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        // Initial state
        presets.blobs();
        // Pre-train a few rounds so curves look meaningful on first load
        stepGD(50);
    }

    // ── Init / bootstrap (bottom-of-IIFE to avoid TDZ on consts) ──
    function bootWhenReady () {
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot);
        else boot();
    }
    if (typeof window.Chart === 'undefined') {
        let waited = 0;
        const tick = setInterval(() => {
            waited += 60;
            if (typeof window.Chart !== 'undefined') { clearInterval(tick); bootWhenReady(); }
            else if (waited > 10000) { clearInterval(tick); console.error('Chart.js failed to load'); }
        }, 60);
    } else {
        bootWhenReady();
    }
})();
