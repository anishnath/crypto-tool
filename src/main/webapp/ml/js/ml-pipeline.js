/*
 * ml-pipeline.js — six-step ML lifecycle wizard.
 *
 * Logic is a faithful port of the inline script in the legacy
 * /ML_Pipeline.jsp.  Same three synthetic datasets, same simplified
 * Logistic / KNN / Decision-Tree implementations, same five Chart.js
 * charts.  Only the surrounding theme and DOM IDs changed.
 */

(function () {
    'use strict';

    // ── Synthetic data (Box-Muller noise) ────────────────────
    function rn () {
        let u = 0, v = 0;
        while (!u) u = Math.random();
        while (!v) v = Math.random();
        return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v);
    }
    function shuffle (a) {
        for (let i = a.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [a[i], a[j]] = [a[j], a[i]];
        }
        return a;
    }
    function sigmoid (z) { return 1 / (1 + Math.exp(-z)); }

    function genIris () {
        const d = [];
        for (let i = 0; i < 50; i++) d.push([5 + rn() * 0.35,  3.4 + rn() * 0.38, 1.5 + rn() * 0.17, 0.2 + rn() * 0.1,  0]);
        for (let i = 0; i < 50; i++) d.push([5.9 + rn() * 0.52, 2.8 + rn() * 0.31, 4.3 + rn() * 0.47, 1.3 + rn() * 0.2,  1]);
        for (let i = 0; i < 50; i++) d.push([6.6 + rn() * 0.64, 3   + rn() * 0.32, 5.6 + rn() * 0.55, 2   + rn() * 0.27, 2]);
        return shuffle(d);
    }
    function genWine () {
        const d = [];
        for (let i = 0; i < 140; i++) d.push([ 9   + rn() * 0.8,  3.2 + rn() * 0.3,  2.5 + rn() * 1.2, 3.2 + rn() * 0.15, 0.5 + rn() * 0.1,  0.996 + rn() * 0.002, 0]);
        for (let i = 0; i <  60; i++) d.push([11.5 + rn() * 0.9,  2.8 + rn() * 0.25, 2.2 + rn() * 0.8, 3.3 + rn() * 0.12, 0.7 + rn() * 0.12, 0.994 + rn() * 0.001, 1]);
        return shuffle(d);
    }
    function genHealth () {
        const d = [];
        for (let i = 0; i < 90; i++) d.push([45 + rn() * 10, 120 + rn() *  8, 180 + rn() * 20, 70 + rn() *  8, 23 + rn() * 2, 0]);
        for (let i = 0; i < 90; i++) d.push([58 + rn() * 12, 145 + rn() * 15, 240 + rn() * 30, 85 + rn() * 10, 28 + rn() * 3, 1]);
        return shuffle(d);
    }

    // Re-generated each boot so refreshing the page gives fresh data.
    const DATASETS = {
        iris:   { name: 'Iris',  features: ['sepal_len', 'sepal_wid', 'petal_len', 'petal_wid'], classes: ['Setosa', 'Versicolor', 'Virginica'] },
        wine:   { name: 'Wine',  features: ['alcohol', 'acidity', 'sugar', 'pH', 'sulfates', 'density'], classes: ['Bad', 'Good'] },
        health: { name: 'Heart', features: ['age', 'bp', 'chol', 'hr', 'bmi'], classes: ['Healthy', 'Disease'] },
    };

    // ── State ────────────────────────────────────────────────
    let currentDataset = null;     // key into DATASETS
    let processedData  = null;     // { trainData, testData }
    let trainedModels  = null;     // { logistic, knn, tree }
    let bestModel      = null;     // { name, ...trained-model-fields }
    let currentStep    = 1;
    const charts = {};
    let trainingHistory = { logistic: [], knn: [], tree: [] };

    // ── Boot ─────────────────────────────────────────────────
    function boot () {
        // Populate live dataset rows.
        DATASETS.iris.data   = genIris();
        DATASETS.wine.data   = genWine();
        DATASETS.health.data = genHealth();

        wireSteps();
        wireDataset();
        wireSplit();
        wirePreprocess();
        wireTrain();
        wirePredict();
    }

    // ── Step nav ─────────────────────────────────────────────
    function wireSteps () {
        document.querySelectorAll('.mp-step').forEach((s) => {
            s.addEventListener('click', () => {
                const target = parseInt(s.getAttribute('data-step'), 10);
                // Don't allow jumping ahead past unprepared state.
                if (target > currentStep + 1) return;
                if (target === 2 && !currentDataset) return;
                if (target >= 4 && !processedData) return;
                if (target >= 5 && !trainedModels) return;
                goToStep(target);
            });
        });
        document.querySelectorAll('[data-go-step]').forEach((btn) => {
            btn.addEventListener('click', () => {
                const target = parseInt(btn.getAttribute('data-go-step'), 10);
                goToStep(target);
            });
        });
    }

    function goToStep (step) {
        currentStep = step;
        for (let i = 1; i <= 6; i++) {
            const content = document.getElementById('mpStepContent' + i);
            if (content) content.classList.toggle('is-visible', i === step);
            const ind = document.querySelector('.mp-step[data-step="' + i + '"]');
            if (ind) {
                ind.classList.remove('is-active', 'is-completed');
                if (i <  step) ind.classList.add('is-completed');
                if (i === step) ind.classList.add('is-active');
            }
        }
        if (step === 2) renderEDA();
        if (step === 3) renderPreprocess();
        if (step === 4) initTrainingChart();
        if (step === 5) renderEval();
        if (step === 6) renderDeploy();
        // Smooth-scroll the workspace into view on small screens
        const top = document.getElementById('mpSteps');
        if (top && window.matchMedia('(max-width: 900px)').matches) {
            top.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    // ── Step 1: dataset selection ────────────────────────────
    function wireDataset () {
        document.querySelectorAll('.mp-dataset-card').forEach((c) => {
            c.addEventListener('click', () => {
                document.querySelectorAll('.mp-dataset-card').forEach((x) => x.classList.remove('is-selected'));
                c.classList.add('is-selected');
                currentDataset = c.getAttribute('data-dataset');
                const btn = document.getElementById('mpBtnLoadDataset');
                if (btn) btn.disabled = false;
            });
        });
        const loadBtn = document.getElementById('mpBtnLoadDataset');
        if (loadBtn) loadBtn.addEventListener('click', () => currentDataset && goToStep(2));
    }

    // ── Step 2: EDA ──────────────────────────────────────────
    function renderEDA () {
        const ds = DATASETS[currentDataset];
        if (!ds) return;
        setText('mpStatSamples',  ds.data.length);
        setText('mpStatFeatures', ds.features.length);
        setText('mpStatClasses',  ds.classes.length);

        if (charts.dist) charts.dist.destroy();
        charts.dist = new Chart(document.getElementById('mpChartDist'), {
            type: 'bar',
            data: {
                labels: ds.features,
                datasets: [{
                    label: 'Mean values',
                    data: ds.features.map((_, i) => ds.data.reduce((s, r) => s + r[i], 0) / ds.data.length),
                    backgroundColor: 'rgba(79, 70, 229, 0.65)',
                    borderColor: '#4f46e5',
                    borderWidth: 1,
                    borderRadius: 4,
                }],
            },
            options: chartOpts({ title: 'Feature means' }),
        });

        if (charts.cls) charts.cls.destroy();
        const counts = ds.classes.map((_, i) => ds.data.filter((r) => r[r.length - 1] === i).length);
        charts.cls = new Chart(document.getElementById('mpChartClass'), {
            type: 'doughnut',
            data: {
                labels: ds.classes,
                datasets: [{
                    data: counts,
                    backgroundColor: ['#4f46e5', '#22c55e', '#f59e0b'],
                    borderColor: '#ffffff',
                    borderWidth: 2,
                }],
            },
            options: chartOpts({ legend: true }),
        });
    }

    // ── Step 3: preprocessing ────────────────────────────────
    function wireSplit () {
        const r = document.getElementById('mpSplitRatio');
        if (!r) return;
        r.addEventListener('input', () => {
            setText('mpSplitLabel', r.value + '/' + (100 - parseInt(r.value, 10)));
            renderPreprocess();
        });
    }
    function renderPreprocess () {
        const ds = DATASETS[currentDataset];
        if (!ds) return;
        const ratio = parseInt(document.getElementById('mpSplitRatio').value, 10);
        const trainN = Math.floor(ds.data.length * ratio / 100);
        setText('mpTrainSamples', trainN);
        setText('mpTestSamples',  ds.data.length - trainN);
        setText('mpSplitLabel',   ratio + '/' + (100 - ratio));
    }
    function wirePreprocess () {
        const btn = document.getElementById('mpBtnPreprocess');
        if (!btn) return;
        btn.addEventListener('click', () => {
            const ds = DATASETS[currentDataset];
            const ratio = parseInt(document.getElementById('mpSplitRatio').value, 10) / 100;
            const splitIdx = Math.floor(ds.data.length * ratio);
            let trainData = ds.data.slice(0, splitIdx);
            let testData  = ds.data.slice(splitIdx);

            if (document.getElementById('mpOptNormalize').checked) {
                const mins = [], maxs = [];
                for (let i = 0; i < ds.features.length; i++) {
                    const col = trainData.map((r) => r[i]);
                    mins[i] = Math.min.apply(null, col);
                    maxs[i] = Math.max.apply(null, col);
                }
                const norm = (r) => {
                    const out = r.slice();
                    for (let i = 0; i < ds.features.length; i++) {
                        out[i] = (r[i] - mins[i]) / (maxs[i] - mins[i] + 1e-10);
                    }
                    return out;
                };
                trainData = trainData.map(norm);
                testData  = testData.map(norm);
            }
            processedData = { trainData, testData };
            goToStep(4);
        });
    }

    // ── Step 4: training ─────────────────────────────────────
    function initTrainingChart () {
        if (charts.training) charts.training.destroy();
        trainingHistory = { logistic: [], knn: [], tree: [] };
        charts.training = new Chart(document.getElementById('mpChartTraining'), {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    { label: 'Logistic regression', data: [], borderColor: '#4f46e5', backgroundColor: 'rgba(79,70,229,0.10)', borderWidth: 2, tension: 0.3 },
                    { label: 'KNN',                 data: [], borderColor: '#22c55e', backgroundColor: 'rgba(34,197,94,0.10)', borderWidth: 2, tension: 0.3 },
                    { label: 'Decision tree',       data: [], borderColor: '#f59e0b', backgroundColor: 'rgba(245,158,11,0.10)', borderWidth: 2, tension: 0.3 },
                ],
            },
            options: chartOpts({
                title: 'Training progress — accuracy over time',
                legend: true,
                yMin: 0, yMax: 1,
                xTitle: 'Training step', yTitle: 'Accuracy',
            }),
        });
    }
    function updateTrainingChart (model, acc) {
        trainingHistory[model].push(acc);
        const max = Math.max(trainingHistory.logistic.length, trainingHistory.knn.length, trainingHistory.tree.length);
        charts.training.data.labels = Array.from({ length: max }, (_, i) => i + 1);
        charts.training.data.datasets[0].data = trainingHistory.logistic;
        charts.training.data.datasets[1].data = trainingHistory.knn;
        charts.training.data.datasets[2].data = trainingHistory.tree;
        charts.training.update('none');
    }

    function sleep (ms) { return new Promise((r) => setTimeout(r, ms)); }

    function wireTrain () {
        const btn = document.getElementById('mpBtnTrain');
        if (!btn) return;
        btn.addEventListener('click', async () => {
            btn.disabled = true;
            btn.textContent = 'Training…';
            trainedModels = {};
            await trainLogistic();
            await trainKNN();
            await trainTree();
            const models = Object.entries(trainedModels);
            bestModel = models.reduce((b, [n, m]) => m.acc > b.acc ? Object.assign({ name: n }, m) : b, { acc: 0 });
            highlightBest();
            document.getElementById('mpBtnToEval').disabled = false;
            btn.textContent = 'Training complete';
        });
    }

    async function trainLogistic () {
        const ds = DATASETS[currentDataset];
        const { trainData, testData } = processedData;
        const w = Array(ds.features.length).fill(0); let b = 0;
        const lr = 0.01, epochs = 100;
        for (let e = 0; e < epochs; e++) {
            for (const row of trainData) {
                const x = row.slice(0, -1), y = row[row.length - 1];
                const z = x.reduce((s, xi, i) => s + xi * w[i], b);
                const pred = sigmoid(z);
                const err = pred - (y > 0 ? 1 : 0);
                for (let i = 0; i < w.length; i++) w[i] -= lr * err * x[i];
                b -= lr * err;
            }
            if (e % 10 === 0) {
                const acc = testData.reduce((c, r) => {
                    const z = r.slice(0, -1).reduce((s, xi, i) => s + xi * w[i], b);
                    return c + (((z > 0 ? 1 : 0) === (r[r.length - 1] > 0 ? 1 : 0)) ? 1 : 0);
                }, 0) / testData.length;
                updateTrainingChart('logistic', acc);
                setProgress('mpProgLog', (e / epochs) * 100);
                await sleep(30);
            }
        }
        const acc = testData.reduce((c, r) => {
            const z = r.slice(0, -1).reduce((s, xi, i) => s + xi * w[i], b);
            return c + (((z > 0 ? 1 : 0) === (r[r.length - 1] > 0 ? 1 : 0)) ? 1 : 0);
        }, 0) / testData.length;
        trainedModels.logistic = { w, b, acc };
        updateTrainingChart('logistic', acc);
        setText('mpAccLog', (acc * 100).toFixed(1) + '%');
        setProgress('mpProgLog', 100);
    }

    async function trainKNN () {
        const { trainData, testData } = processedData;
        updateTrainingChart('knn', 0);
        setProgress('mpProgKNN', 50);
        await sleep(300);
        const k = 5;
        let correct = 0;
        for (const t of testData) {
            const dists = trainData
                .map((tr) => ({
                    d: Math.sqrt(t.slice(0, -1).reduce((s, xi, i) => s + (xi - tr[i]) ** 2, 0)),
                    l: tr[tr.length - 1],
                }))
                .sort((a, b) => a.d - b.d)
                .slice(0, k);
            const votes = {};
            dists.forEach((n) => { votes[n.l] = (votes[n.l] || 0) + 1; });
            const pred = parseInt(Object.keys(votes).reduce((a, b) => votes[a] > votes[b] ? a : b), 10);
            if (pred === t[t.length - 1]) correct++;
        }
        const acc = correct / testData.length;
        trainedModels.knn = { k, acc };
        updateTrainingChart('knn', acc);
        setText('mpAccKNN', (acc * 100).toFixed(1) + '%');
        setProgress('mpProgKNN', 100);
    }

    async function trainTree () {
        const ds = DATASETS[currentDataset];
        const { trainData, testData } = processedData;
        updateTrainingChart('tree', 0);
        setProgress('mpProgTree', 50);
        await sleep(300);

        // 1-rule "decision tree": pick the feature most correlated with y,
        // split at its mean.  Crude but conveys the idea.
        let bestFeat = 0, bestCorr = 0;
        for (let i = 0; i < ds.features.length; i++) {
            const x = trainData.map((r) => r[i]);
            const y = trainData.map((r) => r[r.length - 1]);
            const c = Math.abs(corr(x, y));
            if (c > bestCorr) { bestCorr = c; bestFeat = i; }
        }
        const thresh = trainData.map((r) => r[bestFeat]).reduce((a, b) => a + b) / trainData.length;
        const acc = testData.reduce(
            (c, r) => c + (((r[bestFeat] > thresh ? 1 : 0) === (r[r.length - 1] > 0 ? 1 : 0)) ? 1 : 0),
            0
        ) / testData.length;
        trainedModels.tree = { bestFeat, thresh, acc };
        updateTrainingChart('tree', acc);
        setText('mpAccTree', (acc * 100).toFixed(1) + '%');
        setProgress('mpProgTree', 100);
    }

    function corr (x, y) {
        const n = x.length;
        const mx = x.reduce((a, b) => a + b) / n;
        const my = y.reduce((a, b) => a + b) / n;
        const num = x.reduce((s, xi, i) => s + (xi - mx) * (y[i] - my), 0);
        const dx = Math.sqrt(x.reduce((s, xi) => s + (xi - mx) ** 2, 0));
        const dy = Math.sqrt(y.reduce((s, yi) => s + (yi - my) ** 2, 0));
        return num / (dx * dy + 1e-10);
    }

    function highlightBest () {
        const map = { logistic: 'mpModelLog', knn: 'mpModelKNN', tree: 'mpModelTree' };
        Object.values(map).forEach((id) => {
            const el = document.getElementById(id);
            if (el) el.classList.remove('is-best');
        });
        const el = document.getElementById(map[bestModel.name]);
        if (el) el.classList.add('is-best');
    }

    // ── Step 5: evaluation ───────────────────────────────────
    function renderEval () {
        if (!trainedModels) return;
        if (charts.comp) charts.comp.destroy();
        charts.comp = new Chart(document.getElementById('mpChartComp'), {
            type: 'bar',
            data: {
                labels: ['Logistic', 'KNN', 'Decision tree'],
                datasets: [{
                    label: 'Test accuracy',
                    data: [trainedModels.logistic.acc, trainedModels.knn.acc, trainedModels.tree.acc],
                    backgroundColor: ['#4f46e5', '#22c55e', '#f59e0b'],
                    borderRadius: 4,
                }],
            },
            options: chartOpts({ legend: false, yMin: 0, yMax: 1, yTitle: 'Accuracy' }),
        });

        const ds = DATASETS[currentDataset];
        const imp = trainedModels.logistic.w.map(Math.abs);
        const mx = Math.max.apply(null, imp);
        const html = ds.features.map((f, i) => {
            const pct = (imp[i] / (mx + 1e-12) * 100).toFixed(0);
            return (
                '<div class="mp-feat-row">' +
                '<div class="mp-feat-name">' + f + '</div>' +
                '<div class="mp-feat-bar-wrap">' +
                '<div class="mp-feat-bar" style="width:' + pct + '%"></div>' +
                '<span class="mp-feat-pct">' + pct + '%</span>' +
                '</div></div>'
            );
        }).join('');
        document.getElementById('mpFeatImport').innerHTML = html;

        const niceName = { logistic: 'Logistic Regression', knn: 'K-Nearest Neighbors', tree: 'Decision Tree' };
        setText('mpBestModel', niceName[bestModel.name] + ' — ' + (bestModel.acc * 100).toFixed(1) + '% accuracy');
    }

    // ── Step 6: deployment ───────────────────────────────────
    function renderDeploy () {
        if (!bestModel) return;
        const ds = DATASETS[currentDataset];
        const html = ds.features.map((f, i) => (
            '<div class="mp-pred-input">' +
            '<label for="mpPredIn' + i + '">' + f + '</label>' +
            '<input type="number" id="mpPredIn' + i + '" step="0.1" />' +
            '</div>'
        )).join('');
        document.getElementById('mpPredInputs').innerHTML = html;

        if (charts.deploy) charts.deploy.destroy();
        charts.deploy = new Chart(document.getElementById('mpChartDeploy'), {
            type: 'radar',
            data: {
                labels: ['Accuracy', 'Precision', 'Recall', 'F1', 'Speed'],
                datasets: [{
                    label: bestModel.name,
                    data: [bestModel.acc, bestModel.acc * 0.95, bestModel.acc * 1.05, bestModel.acc, 0.9],
                    backgroundColor: 'rgba(79, 70, 229, 0.18)',
                    borderColor: '#4f46e5',
                    borderWidth: 2,
                    pointBackgroundColor: '#4f46e5',
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { r: { beginAtZero: true, max: 1, ticks: { stepSize: 0.25 } } },
                plugins: { legend: { display: false } },
            },
        });
    }

    function wirePredict () {
        const btn = document.getElementById('mpBtnPredict');
        if (!btn) return;
        btn.addEventListener('click', () => {
            if (!bestModel) return;
            const ds = DATASETS[currentDataset];
            const inputs = ds.features.map((_, i) => {
                const v = parseFloat(document.getElementById('mpPredIn' + i).value);
                return isFinite(v) ? v : 0;
            });
            let pred, conf;
            if (bestModel.name === 'logistic') {
                const z = inputs.reduce((s, xi, i) => s + xi * bestModel.w[i], bestModel.b);
                const prob = sigmoid(z);
                pred = z > 0 ? 1 : 0;
                conf = (Math.abs(prob - 0.5) * 200).toFixed(1);
            } else if (bestModel.name === 'knn') {
                pred = 1; conf = '75';
            } else {
                pred = inputs[bestModel.bestFeat] > bestModel.thresh ? 1 : 0;
                conf = '80';
            }
            setText('mpPredClass', ds.classes[pred]);
            setText('mpPredConf', conf);
            document.getElementById('mpPredResult').classList.add('is-visible');
        });
    }

    // ── Chart.js helpers ─────────────────────────────────────
    function chartOpts (cfg) {
        cfg = cfg || {};
        const dark = isDark();
        const tickCol = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        const gridCol = dark ? 'rgba(245,245,244,0.08)' : 'rgba(28,25,23,0.06)';
        return {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: !!cfg.legend, position: 'top', labels: { color: tickCol, font: { family: 'Inter, system-ui, sans-serif' } } },
                title:  cfg.title ? { display: true, text: cfg.title, color: dark ? '#e7e5e4' : '#1c1917', font: { family: 'Inter, system-ui, sans-serif', size: 12, weight: '600' } } : { display: false },
            },
            scales: {
                x: {
                    title: cfg.xTitle ? { display: true, text: cfg.xTitle, color: tickCol } : undefined,
                    ticks: { color: tickCol, font: { family: 'JetBrains Mono, monospace', size: 10 } },
                    grid:  { color: gridCol, drawBorder: false },
                },
                y: {
                    title: cfg.yTitle ? { display: true, text: cfg.yTitle, color: tickCol } : undefined,
                    ticks: { color: tickCol, font: { family: 'JetBrains Mono, monospace', size: 10 } },
                    grid:  { color: gridCol, drawBorder: false },
                    beginAtZero: true,
                    min: cfg.yMin,
                    max: cfg.yMax,
                },
            },
        };
    }
    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    // ── Tiny DOM helpers ─────────────────────────────────────
    function setText (id, val) {
        const el = document.getElementById(id);
        if (el) el.textContent = val;
    }
    function setProgress (id, pct) {
        const el = document.getElementById(id);
        if (el) el.style.width = Math.max(0, Math.min(100, pct)) + '%';
    }

    // ── Init — placed at the bottom so every const/let above is
    // already initialized by the time we call boot().  (Function
    // declarations hoist, const/let live in the temporal dead zone
    // until their lexical line is executed.)
    if (typeof window.Chart === 'undefined') {
        // Chart.js loads via the script tag in the JSP head — if it
        // isn't here yet (slow CDN), poll for it before running boot.
        let waited = 0;
        const tick = setInterval(() => {
            waited += 60;
            if (typeof window.Chart !== 'undefined') {
                clearInterval(tick);
                boot();
            } else if (waited > 10000) {
                clearInterval(tick);
                console.error('Chart.js failed to load — ML Pipeline charts unavailable');
            }
        }, 60);
    } else if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
