/*
 * neural-network-playground.js — interactive MLP training playground.
 *
 * Ported from the legacy /neural_network_playground.jsp inline script.
 * Same algorithm (mini-batch SGD on softmax-cross-entropy with manual
 * backprop), same four datasets (spiral / XOR / circle / moons), same
 * dynamic layer builder.  Only the surrounding theme and DOM IDs changed.
 */

(function () {
    'use strict';

    const $ = (id) => document.getElementById(id);

    // ── State ────────────────────────────────────────────────
    const state = {
        canvas: null, ctx: null,
        lossChart: null,
        network: {
            layers: [
                { type: 'input',  neurons: 2, weights: null, biases: null },
                { type: 'hidden', neurons: 4, activation: 'relu', weights: null, biases: null },
                { type: 'hidden', neurons: 4, activation: 'relu', weights: null, biases: null },
                { type: 'output', neurons: 2, activation: 'sigmoid', weights: null, biases: null },
            ],
        },
        dataPoints: [],
        currentClass: 1,
        isTraining: false,
        epoch: 0,
        trainingInterval: null,
        lossHistory: [],
        currentActivation: 'relu',
        learningRate: 0.01,
        batchSize: 32,
        currentDataset: 'spiral',
    };

    // Canvas pixel-space center / scale (set on resize).
    let cx = 350, cy = 230, sx = 350, sy = 230;

    // ── Math helpers ────────────────────────────────────────
    function randn () {
        let u = 0, v = 0;
        while (!u) u = Math.random();
        while (!v) v = Math.random();
        return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v);
    }
    function clamp (x, lo, hi) { return Math.max(lo, Math.min(hi, x)); }

    const relu        = (x) => Math.max(0, x);
    const reluD       = (x) => x > 0 ? 1 : 0;
    const sigmoid     = (x) => 1 / (1 + Math.exp(-clamp(x, -500, 500)));
    const sigmoidD    = (x) => { const s = sigmoid(x); return s * (1 - s); };
    const tanhFn      = (x) => Math.tanh(x);
    const tanhD       = (x) => 1 - Math.tanh(x) ** 2;
    const leakyRelu   = (x) => x > 0 ? x : 0.01 * x;
    const leakyReluD  = (x) => x > 0 ? 1 : 0.01;

    function activate (x, activation) {
        switch (activation) {
            case 'relu':       return relu(x);
            case 'sigmoid':    return sigmoid(x);
            case 'tanh':       return tanhFn(x);
            case 'leaky_relu': return leakyRelu(x);
            default:           return relu(x);
        }
    }
    function activateD (x, activation) {
        switch (activation) {
            case 'relu':       return reluD(x);
            case 'sigmoid':    return sigmoidD(x);
            case 'tanh':       return tanhD(x);
            case 'leaky_relu': return leakyReluD(x);
            default:           return reluD(x);
        }
    }

    // ── Network init / forward / backward ───────────────────
    function initializeNetwork () {
        for (let i = 1; i < state.network.layers.length; i++) {
            const prev = state.network.layers[i - 1].neurons;
            const curr = state.network.layers[i].neurons;
            state.network.layers[i].weights = Array(curr).fill(0).map(() =>
                Array(prev).fill(0).map(() => randn() * 0.5));
            state.network.layers[i].biases = Array(curr).fill(0).map(() => randn() * 0.1);
        }
        state.epoch = 0;
        state.lossHistory = [];
    }

    function forward (input) {
        const activations = [input];
        const zValues     = [input];
        for (let i = 1; i < state.network.layers.length; i++) {
            const layer = state.network.layers[i];
            const prevA = activations[i - 1];
            const z = [], a = [];
            for (let j = 0; j < layer.neurons; j++) {
                let sum = layer.biases[j];
                for (let k = 0; k < prevA.length; k++) sum += layer.weights[j][k] * prevA[k];
                z.push(sum);
                a.push(activate(sum, layer.activation));
            }
            zValues.push(z);
            activations.push(a);
        }
        return { activations, zValues };
    }

    function backward (input, target, activations, zValues) {
        const gradients = { weights: [], biases: [] };
        let delta = [];
        const lastIdx = state.network.layers.length - 1;
        const output = activations[lastIdx];
        for (let i = 0; i < output.length; i++) {
            delta[i] = (output[i] - target[i]) *
                       activateD(zValues[lastIdx][i], state.network.layers[lastIdx].activation);
        }
        for (let i = state.network.layers.length - 1; i >= 1; i--) {
            const layer = state.network.layers[i];
            const prevA = activations[i - 1];
            const wGrad = Array(layer.neurons).fill(0).map(() => Array(prevA.length).fill(0));
            const bGrad = Array(layer.neurons).fill(0);
            for (let j = 0; j < layer.neurons; j++) {
                bGrad[j] = delta[j];
                for (let k = 0; k < prevA.length; k++) wGrad[j][k] = delta[j] * prevA[k];
            }
            gradients.weights.unshift(wGrad);
            gradients.biases.unshift(bGrad);
            if (i > 1) {
                const nextDelta = Array(prevA.length).fill(0);
                for (let j = 0; j < prevA.length; j++) {
                    let sum = 0;
                    for (let k = 0; k < layer.neurons; k++) sum += layer.weights[k][j] * delta[k];
                    nextDelta[j] = sum * activateD(zValues[i - 1][j], state.network.layers[i - 1].activation);
                }
                delta = nextDelta;
            }
        }
        return gradients;
    }

    // ── Training step (mini-batch SGD) ──────────────────────
    function trainStep () {
        if (state.dataPoints.length === 0) return;
        let totalLoss = 0, correct = 0;
        const gradAccum = { weights: [], biases: [] };
        for (let i = 1; i < state.network.layers.length; i++) {
            gradAccum.weights.push(Array(state.network.layers[i].neurons).fill(0).map(() =>
                Array(state.network.layers[i - 1].neurons).fill(0)));
            gradAccum.biases.push(Array(state.network.layers[i].neurons).fill(0));
        }
        const batch = [];
        for (let i = 0; i < Math.min(state.batchSize, state.dataPoints.length); i++) {
            batch.push(Math.floor(Math.random() * state.dataPoints.length));
        }
        for (const idx of batch) {
            const p = state.dataPoints[idx];
            const input  = [(p.x - cx) / sx, (p.y - cy) / sy];
            const target = p.class === 1 ? [0, 1] : [1, 0];
            const { activations, zValues } = forward(input);
            const g = backward(input, target, activations, zValues);
            for (let i = 0; i < g.weights.length; i++) {
                for (let j = 0; j < g.weights[i].length; j++) {
                    for (let k = 0; k < g.weights[i][j].length; k++) {
                        gradAccum.weights[i][j][k] += g.weights[i][j][k];
                    }
                }
                for (let j = 0; j < g.biases[i].length; j++) gradAccum.biases[i][j] += g.biases[i][j];
            }
            const out = activations[activations.length - 1];
            totalLoss += -Math.log(out[p.class] + 1e-10);
            const pred = out[0] > out[1] ? 0 : 1;
            if (pred === p.class) correct++;
        }
        for (let i = 1; i < state.network.layers.length; i++) {
            const layer = state.network.layers[i];
            for (let j = 0; j < layer.neurons; j++) {
                layer.biases[j] -= state.learningRate * gradAccum.biases[i - 1][j] / batch.length;
                for (let k = 0; k < layer.weights[j].length; k++) {
                    layer.weights[j][k] -= state.learningRate * gradAccum.weights[i - 1][j][k] / batch.length;
                }
            }
        }
        state.epoch++;
        const avgLoss = totalLoss / batch.length;
        const accuracy = correct / batch.length;
        state.lossHistory.push(avgLoss);
        if (state.lossHistory.length > 100) state.lossHistory.shift();
        updateMetrics(avgLoss, accuracy);
    }

    // ── Drawing ──────────────────────────────────────────────
    function syncCanvasSize () {
        const canvas = state.canvas;
        const dpr = window.devicePixelRatio || 1;
        const rect = canvas.getBoundingClientRect();
        canvas.width  = Math.max(1, Math.floor(rect.width * dpr));
        canvas.height = Math.max(1, Math.floor(rect.height * dpr));
        state.ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        cx = rect.width / 2; cy = rect.height / 2;
        sx = rect.width / 2; sy = rect.height / 2;
    }
    function drawNetwork () {
        if (!state.canvas) return;
        syncCanvasSize();
        const ctx = state.ctx;
        const w = state.canvas.getBoundingClientRect().width;
        const h = state.canvas.getBoundingClientRect().height;
        ctx.clearRect(0, 0, w, h);
        if ($('nnpShowBoundary') && $('nnpShowBoundary').checked && state.network.layers[1].weights) {
            drawDecisionBoundary(w, h);
        }
        for (const p of state.dataPoints) {
            ctx.beginPath(); ctx.arc(p.x, p.y, 6, 0, Math.PI * 2);
            ctx.fillStyle = p.class === 1 ? '#22c55e' : '#ef4444';
            ctx.fill();
            ctx.strokeStyle = p.class === 1 ? '#15803d' : '#b91c1c';
            ctx.lineWidth = 1.5;
            ctx.stroke();
        }
    }
    function drawDecisionBoundary (w, h) {
        const ctx = state.ctx;
        const res = 6;
        for (let x = 0; x < w; x += res) {
            for (let y = 0; y < h; y += res) {
                const input = [(x - cx) / sx, (y - cy) / sy];
                const out = forward(input).activations.slice(-1)[0];
                const prob = out[1];
                const a = Math.abs(prob - 0.5) * 0.34;
                ctx.fillStyle = prob > 0.5
                    ? 'rgba(34, 197, 94, ' + a + ')'
                    : 'rgba(239, 68, 68, ' + a + ')';
                ctx.fillRect(x, y, res, res);
            }
        }
    }

    function updateMetrics (loss, acc) {
        if ($('nnpEpoch'))   $('nnpEpoch').textContent   = state.epoch;
        if ($('nnpLossVal')) $('nnpLossVal').textContent = loss.toFixed(4);
        if ($('nnpAcc'))     $('nnpAcc').textContent     = (acc * 100).toFixed(1) + '%';
        updateLossChart();
    }

    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }
    function tickCol () { return isDark() ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)'; }
    function gridCol () { return isDark() ? 'rgba(245,245,244,0.08)' : 'rgba(28,25,23,0.06)'; }

    function initLossChart () {
        if (!$('nnpLossChart') || typeof window.Chart === 'undefined') return;
        state.lossChart = new window.Chart($('nnpLossChart'), {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Training loss', data: [],
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.10)',
                    borderWidth: 2, pointRadius: 0, tension: 0.3, fill: true,
                }],
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { title: { display: true, text: 'epoch', color: tickCol(),
                                  font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         grid: { color: gridCol() } },
                    y: { beginAtZero: true,
                         title: { display: true, text: 'loss', color: tickCol(),
                                  font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         ticks: { color: tickCol(), font: { family: 'JetBrains Mono, monospace', size: 10 } },
                         grid: { color: gridCol() } },
                },
            },
        });
    }
    function updateLossChart () {
        if (!state.lossChart) return;
        state.lossChart.data.labels = state.lossHistory.map((_, i) => i);
        state.lossChart.data.datasets[0].data = state.lossHistory;
        state.lossChart.update('none');
    }

    // ── Dataset generators ──────────────────────────────────
    function generateSpiral () {
        state.dataPoints = [];
        const n = 100;
        for (let i = 0; i < n / 2; i++) {
            const r = i / n * 5;
            const t = 1.25 * i / n * 2 * Math.PI;
            state.dataPoints.push({ x: cx + r * 50 * Math.cos(t) + randn() * 5,
                                    y: cy + r * 50 * Math.sin(t) + randn() * 5, class: 0 });
            state.dataPoints.push({ x: cx + r * 50 * Math.cos(t + Math.PI) + randn() * 5,
                                    y: cy + r * 50 * Math.sin(t + Math.PI) + randn() * 5, class: 1 });
        }
    }
    function generateXOR () {
        state.dataPoints = [];
        for (let i = 0; i < 50; i++) {
            state.dataPoints.push({ x: cx - 150 + randn() * 30, y: cy - 100 + randn() * 30, class: 0 });
            state.dataPoints.push({ x: cx + 150 + randn() * 30, y: cy - 100 + randn() * 30, class: 0 });
            state.dataPoints.push({ x: cx - 150 + randn() * 30, y: cy + 100 + randn() * 30, class: 1 });
            state.dataPoints.push({ x: cx + 150 + randn() * 30, y: cy + 100 + randn() * 30, class: 1 });
        }
    }
    function generateCircle () {
        state.dataPoints = [];
        for (let i = 0; i < 100; i++) {
            const r = Math.random() * 80, t = Math.random() * 2 * Math.PI;
            state.dataPoints.push({ x: cx + r * Math.cos(t), y: cy + r * Math.sin(t), class: 0 });
            const r2 = 120 + Math.random() * 60, t2 = Math.random() * 2 * Math.PI;
            state.dataPoints.push({ x: cx + r2 * Math.cos(t2), y: cy + r2 * Math.sin(t2), class: 1 });
        }
    }
    function generateMoons () {
        state.dataPoints = [];
        const n = 100;
        for (let i = 0; i < n / 2; i++) {
            const t = Math.PI * i / (n / 2);
            state.dataPoints.push({ x: cx + 100 * Math.cos(t) + randn() * 10,
                                    y: cy + 50 * Math.sin(t) + randn() * 10, class: 0 });
            state.dataPoints.push({ x: cx + 100 * Math.cos(t + Math.PI) + randn() * 10,
                                    y: cy - 50 + 50 * Math.sin(t + Math.PI) + randn() * 10, class: 1 });
        }
    }

    function loadDataset (key) {
        state.currentDataset = key;
        if      (key === 'spiral') generateSpiral();
        else if (key === 'xor')    generateXOR();
        else if (key === 'circle') generateCircle();
        else if (key === 'moons')  generateMoons();
        if (!state.isTraining) initializeNetwork();
        drawNetwork();
    }

    // ── Layer builder ───────────────────────────────────────
    function renderLayers () {
        const builder = $('nnpLayers');
        if (!builder) return;
        builder.innerHTML = '';
        state.network.layers.forEach((layer, idx) => {
            const item = document.createElement('div');
            item.className = 'nnp-layer is-' + layer.type;
            const title = layer.type === 'input'  ? 'Input'
                        : layer.type === 'output' ? 'Output'
                        : 'Hidden ' + idx;
            const visibleNeurons = Math.min(layer.neurons, 10);
            const dots = Array(visibleNeurons).fill(0).map(() => '<span class="nnp-neuron-dot"></span>').join('');
            const more = layer.neurons > 10 ? ' …' : '';
            const left = document.createElement('div');
            left.innerHTML =
                '<div class="nnp-layer-title">' + title + '</div>' +
                '<div class="nnp-layer-neurons">' + dots + more +
                '<span class="nnp-layer-meta">' + layer.neurons + ' neurons</span></div>';
            item.appendChild(left);
            if (layer.type === 'hidden') {
                const ctrls = document.createElement('div');
                ctrls.className = 'nnp-layer-controls';
                const input = document.createElement('input');
                input.type = 'number'; input.min = 1; input.max = 16;
                input.value = layer.neurons; input.className = 'nnp-layer-input';
                input.addEventListener('change', (e) => {
                    layer.neurons = parseInt(e.target.value, 10) || 1;
                    initializeNetwork();
                    renderLayers();
                });
                ctrls.appendChild(input);
                const rm = document.createElement('button');
                rm.className = 'nnp-layer-remove'; rm.textContent = '✕';
                rm.addEventListener('click', () => {
                    if (state.network.layers.filter(l => l.type === 'hidden').length > 1) {
                        state.network.layers.splice(idx, 1);
                        initializeNetwork();
                        renderLayers();
                    }
                });
                ctrls.appendChild(rm);
                item.appendChild(ctrls);
            }
            builder.appendChild(item);
        });
    }

    // ── Activation graph ────────────────────────────────────
    function drawActivationGraph (activation) {
        const canvas = $('nnpActivationGraph');
        if (!canvas) return;
        const dpr = window.devicePixelRatio || 1;
        const rect = canvas.getBoundingClientRect();
        canvas.width  = Math.max(1, Math.floor(rect.width * dpr));
        canvas.height = Math.max(1, Math.floor(rect.height * dpr));
        const ctx = canvas.getContext('2d');
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        const w = rect.width, h = rect.height;
        ctx.clearRect(0, 0, w, h);
        ctx.strokeStyle = isDark() ? 'rgba(245,245,244,0.18)' : 'rgba(28,25,23,0.18)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(0, h / 2); ctx.lineTo(w, h / 2);
        ctx.moveTo(w / 2, 0); ctx.lineTo(w / 2, h);
        ctx.stroke();
        ctx.strokeStyle = '#4f46e5';
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (let x = 0; x < w; x++) {
            const input = (x / w - 0.5) * 10;
            const output = activate(input, activation);
            const y = h / 2 - output * (h / 6);
            if (x === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
        }
        ctx.stroke();
    }

    // ── Dataset preset preview canvases ────────────────────
    function drawSpiralPreview (canvas) {
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 56, 56);
        ctx.fillStyle = '#ef4444';
        for (let i = 0; i < 10; i++) {
            const r = i / 10 * 20;
            const t = i / 10 * Math.PI;
            ctx.fillRect(28 + r * Math.cos(t) - 1, 28 + r * Math.sin(t) - 1, 2, 2);
        }
        ctx.fillStyle = '#22c55e';
        for (let i = 0; i < 10; i++) {
            const r = i / 10 * 20;
            const t = i / 10 * Math.PI + Math.PI;
            ctx.fillRect(28 + r * Math.cos(t) - 1, 28 + r * Math.sin(t) - 1, 2, 2);
        }
    }
    function drawXorPreview (canvas) {
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 56, 56);
        ctx.fillStyle = '#ef4444';
        ctx.fillRect(8, 8, 14, 14); ctx.fillRect(34, 34, 14, 14);
        ctx.fillStyle = '#22c55e';
        ctx.fillRect(34, 8, 14, 14); ctx.fillRect(8, 34, 14, 14);
    }
    function drawCirclePreview (canvas) {
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 56, 56);
        ctx.fillStyle = '#22c55e';
        ctx.beginPath(); ctx.arc(28, 28, 22, 0, Math.PI * 2); ctx.fill();
        ctx.fillStyle = '#fefdfb';
        ctx.beginPath(); ctx.arc(28, 28, 16, 0, Math.PI * 2); ctx.fill();
        ctx.fillStyle = '#ef4444';
        ctx.beginPath(); ctx.arc(28, 28, 10, 0, Math.PI * 2); ctx.fill();
    }
    function drawMoonsPreview (canvas) {
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 56, 56);
        ctx.fillStyle = '#ef4444';
        ctx.beginPath(); ctx.arc(28, 22, 14, 0, Math.PI); ctx.fill();
        ctx.fillStyle = '#22c55e';
        ctx.beginPath(); ctx.arc(28, 34, 14, Math.PI, Math.PI * 2); ctx.fill();
    }
    function drawDatasetPreviews () {
        const map = {
            'nnpPreviewSpiral': drawSpiralPreview,
            'nnpPreviewXor':    drawXorPreview,
            'nnpPreviewCircle': drawCirclePreview,
            'nnpPreviewMoons':  drawMoonsPreview,
        };
        Object.entries(map).forEach(([id, fn]) => {
            const c = $(id); if (!c) return;
            c.width = 56; c.height = 56;
            fn(c);
        });
    }

    // ── Wire-up ─────────────────────────────────────────────
    function wire () {
        state.canvas = $('nnpCanvas');
        state.ctx    = state.canvas ? state.canvas.getContext('2d') : null;
        if (!state.canvas) return;

        // Click on canvas → add point of current class
        state.canvas.addEventListener('click', (e) => {
            const rect = state.canvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            state.dataPoints.push({ x, y, class: state.currentClass });
            drawNetwork();
        });

        // Class indicator toggle
        const indicator = $('nnpClassIndicator');
        if (indicator) {
            indicator.addEventListener('click', () => {
                state.currentClass = state.currentClass === 1 ? 0 : 1;
                indicator.dataset.class = String(state.currentClass);
                $('nnpClassIndicatorText').textContent = 'Class ' + state.currentClass;
            });
        }

        // Dataset preset selection
        document.querySelectorAll('.nnp-dataset').forEach((btn) => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.nnp-dataset').forEach((b) => b.classList.remove('is-active'));
                btn.classList.add('is-active');
                loadDataset(btn.dataset.dataset);
            });
        });

        // Clear data
        if ($('nnpBtnClear')) {
            $('nnpBtnClear').addEventListener('click', () => {
                state.dataPoints = [];
                drawNetwork();
            });
        }

        // Activation function selector
        document.querySelectorAll('.nnp-activation-btn').forEach((btn) => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.nnp-activation-btn').forEach((b) => b.classList.remove('is-active'));
                btn.classList.add('is-active');
                state.currentActivation = btn.dataset.activation;
                for (let i = 1; i < state.network.layers.length - 1; i++) {
                    state.network.layers[i].activation = state.currentActivation;
                }
                drawActivationGraph(state.currentActivation);
                initializeNetwork();
            });
        });

        // Add layer
        if ($('nnpBtnAddLayer')) {
            $('nnpBtnAddLayer').addEventListener('click', () => {
                if (state.network.layers.length < 8) {
                    state.network.layers.splice(state.network.layers.length - 1, 0, {
                        type: 'hidden',
                        neurons: 4,
                        activation: state.currentActivation,
                        weights: null,
                        biases: null,
                    });
                    initializeNetwork();
                    renderLayers();
                }
            });
        }

        // Hyperparameters
        if ($('nnpLr')) {
            $('nnpLr').addEventListener('input', (e) => {
                state.learningRate = parseFloat(e.target.value);
                $('nnpLrValue').textContent = state.learningRate.toFixed(3);
            });
        }
        if ($('nnpBatch')) {
            $('nnpBatch').addEventListener('input', (e) => {
                state.batchSize = parseInt(e.target.value, 10);
                $('nnpBatchValue').textContent = state.batchSize;
            });
        }
        if ($('nnpSpeed')) {
            $('nnpSpeed').addEventListener('input', (e) => {
                const speeds = ['Slowest','Slower','Slow','Normal','Normal','Fast','Faster','Fastest','Ultra','Instant'];
                $('nnpSpeedValue').textContent = speeds[parseInt(e.target.value, 10) - 1] || 'Normal';
            });
        }

        // Play / Pause
        if ($('nnpBtnPlay')) {
            $('nnpBtnPlay').addEventListener('click', () => {
                state.isTraining = !state.isTraining;
                const btn = $('nnpBtnPlay');
                if (state.isTraining) {
                    btn.classList.add('is-running');
                    btn.textContent = '⏸ Pause Training';
                    const speed = parseInt(($('nnpSpeed') || { value: 5 }).value, 10);
                    const interval = Math.max(10, 200 - speed * 15);
                    state.trainingInterval = setInterval(() => {
                        trainStep();
                        drawNetwork();
                    }, interval);
                } else {
                    btn.classList.remove('is-running');
                    btn.textContent = '▶ Resume Training';
                    clearInterval(state.trainingInterval);
                }
            });
        }

        // Reset
        if ($('nnpBtnReset')) {
            $('nnpBtnReset').addEventListener('click', () => {
                state.isTraining = false;
                clearInterval(state.trainingInterval);
                if ($('nnpBtnPlay')) {
                    $('nnpBtnPlay').classList.remove('is-running');
                    $('nnpBtnPlay').textContent = '▶ Train Network';
                }
                initializeNetwork();
                drawNetwork();
                updateMetrics(0, 0);
            });
        }

        // Decision boundary toggle
        if ($('nnpShowBoundary')) {
            $('nnpShowBoundary').addEventListener('change', drawNetwork);
        }
    }

    function boot () {
        wire();
        initLossChart();
        renderLayers();
        loadDataset('spiral');
        drawActivationGraph('relu');
        drawDatasetPreviews();
        initializeNetwork();
        drawNetwork();

        // KaTeX (for the math card)
        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        // Theme observer — re-theme loss chart + activation graph on dark toggle
        const obs = new MutationObserver(() => {
            if (state.lossChart) {
                Object.values(state.lossChart.options.scales).forEach((s) => {
                    if (s.ticks) s.ticks.color = tickCol();
                    if (s.grid)  s.grid.color  = gridCol();
                    if (s.title) s.title.color = tickCol();
                });
                state.lossChart.update();
            }
            drawActivationGraph(state.currentActivation);
            drawNetwork();
        });
        obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

        // Window resize → redraw canvas at new DPR + size
        let resizeTO = null;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTO);
            resizeTO = setTimeout(() => {
                drawActivationGraph(state.currentActivation);
                drawDatasetPreviews();
                drawNetwork();
            }, 120);
        });
    }

    // ── Init (bottom of IIFE to avoid TDZ on const helpers) ──
    function bootWhenReady () {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', boot);
        } else {
            boot();
        }
    }
    if (typeof window.Chart === 'undefined') {
        let waited = 0;
        const tick = setInterval(() => {
            waited += 60;
            if (typeof window.Chart !== 'undefined') {
                clearInterval(tick);
                bootWhenReady();
            } else if (waited > 10000) {
                clearInterval(tick);
                console.error('Chart.js failed to load — NN playground unavailable');
            }
        }, 60);
    } else {
        bootWhenReady();
    }
})();
