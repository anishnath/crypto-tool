/*
 * decision-tree-model-selection.js — Decision Tree Model Selection Lab.
 *
 * In-browser decision tree builder with k-fold CV, validation curves,
 * ccp_alpha pruning, grid-search heatmap, and a hold-out final test.
 * Five dataset generators (balanced / overlap / XOR / moons / circles)
 * and five metrics (accuracy / F1 / balanced acc / PR AUC / cost-based).
 *
 * All identifiers use the `dt-` / `dt*` prefix to match the page CSS.
 */
(function () {
    'use strict';

    function $(id) { return document.getElementById(id); }

    // ── Canvas refs ───────────────────────────────────────────
    var canvas, ctx, heat, hctx;
    var valChart = null;

    // ── State ─────────────────────────────────────────────────
    var points = [];          // {x, y, c}
    var tree = null;          // trained tree root
    var showSplits = true;
    var currentClass = 1;     // class toggle for click-to-add
    var activePreset = 'balanced';
    var heatData = { xs: [], ys: [], mat: [] };
    var testIdx = [];

    // ── Helpers ───────────────────────────────────────────────
    function randn() {
        var u = 0, v = 0;
        while (u === 0) u = Math.random();
        while (v === 0) v = Math.random();
        return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v);
    }
    function shuffle(a) {
        for (var i = a.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var t = a[i]; a[i] = a[j]; a[j] = t;
        }
        return a;
    }
    function meanArr(a) {
        if (a.length === 0) return 0;
        var s = 0; for (var i = 0; i < a.length; i++) s += a[i];
        return s / a.length;
    }
    function stdArr(a, m) {
        if (a.length === 0) return 0;
        var s = 0; for (var i = 0; i < a.length; i++) { var d = a[i] - m; s += d * d; }
        return Math.sqrt(s / a.length);
    }

    // Domain mapping over [-2, 2]
    function toCanvas(x, y) {
        var W = canvas.width, H = canvas.height;
        var nx = (x + 2) / 4, ny = (y + 2) / 4;
        return { cx: nx * W, cy: (1 - ny) * H };
    }
    function toDomain(cx, cy) {
        var W = canvas.width, H = canvas.height;
        var nx = cx / W, ny = 1 - (cy / H);
        return { x: nx * 4 - 2, y: ny * 4 - 2 };
    }

    function resizeCanvas() {
        var p = canvas.parentElement;
        canvas.width = Math.max(320, p.clientWidth - 4);
        canvas.height = Math.max(260, p.clientHeight - 4);
        drawAll();
    }
    function resizeHeat() {
        var p = heat.parentElement;
        heat.width = Math.max(320, p.clientWidth - 4);
        heat.height = Math.max(200, p.clientHeight - 4);
        drawHeatmap();
    }

    // ── Impurity ──────────────────────────────────────────────
    function impurityGini(labels) {
        var n = labels.length; if (n === 0) return 0;
        var c1 = 0; for (var i = 0; i < n; i++) if (labels[i] === 1) c1++;
        var p1 = c1 / n, p0 = 1 - p1;
        return 1 - (p0 * p0 + p1 * p1);
    }
    function impurityEntropy(labels) {
        var n = labels.length; if (n === 0) return 0;
        var c1 = 0; for (var i = 0; i < n; i++) if (labels[i] === 1) c1++;
        var p1 = c1 / n, p0 = 1 - p1;
        function H(p) { return p <= 0 ? 0 : -p * Math.log2(p); }
        return H(p0) + H(p1);
    }
    function criterionImp(labels) {
        return $('dtCriterion').value === 'gini'
            ? impurityGini(labels)
            : impurityEntropy(labels);
    }

    // ── Best split (with ccp_alpha gain threshold + feature subset) ─
    function bestSplit(samples, minLeaf, maxFeatures, alpha) {
        if (samples.length < 2 * minLeaf) return null;
        var features = [0, 1];
        if (maxFeatures === 1) { features = [Math.random() < 0.5 ? 0 : 1]; }
        var y = samples.map(function (i) { return points[i].c; });
        var base = criterionImp(y);
        var best = { gain: 0 };
        for (var fi = 0; fi < features.length; fi++) {
            var ax = features[fi];
            var sorted = samples.slice().sort(function (a, b) {
                return (ax === 0 ? points[a].x : points[a].y) - (ax === 0 ? points[b].x : points[b].y);
            });
            for (var k = minLeaf; k < sorted.length - minLeaf; k++) {
                var v1 = (ax === 0 ? points[sorted[k - 1]].x : points[sorted[k - 1]].y);
                var v2 = (ax === 0 ? points[sorted[k]].x : points[sorted[k]].y);
                var thr = (v1 + v2) / 2;
                var left = [], right = [];
                for (var s = 0; s < sorted.length; s++) {
                    var vv = (ax === 0 ? points[sorted[s]].x : points[sorted[s]].y);
                    if (vv <= thr) left.push(sorted[s]); else right.push(sorted[s]);
                }
                if (left.length < minLeaf || right.length < minLeaf) continue;
                var yL = left.map(function (i) { return points[i].c; });
                var yR = right.map(function (i) { return points[i].c; });
                var imp = (left.length / samples.length) * criterionImp(yL)
                        + (right.length / samples.length) * criterionImp(yR);
                var gain = base - imp;
                if (gain > best.gain) { best = { axis: ax, thr: thr, gain: gain, left: left, right: right }; }
            }
        }
        if (best.gain <= alpha) return null;
        return best;
    }

    function buildTree(samples, depth, maxDepth, minSplit, minLeaf, maxFeatures, alpha) {
        var n = samples.length;
        var node = { leaf: false, axis: null, thr: null, left: null, right: null,
                     pred: null, depth: depth, leaves: 1, n: n, pos: 0, neg: 0 };
        var c1 = 0; for (var i = 0; i < n; i++) if (points[samples[i]].c === 1) c1++;
        var maj = (c1 * 2 >= n) ? 1 : 0;
        if (depth >= maxDepth || n < minSplit || c1 === 0 || c1 === n) {
            node.leaf = true; node.pred = maj; node.pos = c1; node.neg = n - c1; return node;
        }
        var split = bestSplit(samples, minLeaf, maxFeatures, alpha);
        if (!split) { node.leaf = true; node.pred = maj; node.pos = c1; node.neg = n - c1; return node; }
        node.axis = split.axis; node.thr = split.thr;
        node.left = buildTree(split.left, depth + 1, maxDepth, minSplit, minLeaf, maxFeatures, alpha);
        node.right = buildTree(split.right, depth + 1, maxDepth, minSplit, minLeaf, maxFeatures, alpha);
        node.depth = Math.max(node.left.depth, node.right.depth);
        node.leaves = (node.left.leaf ? 1 : node.left.leaves) + (node.right.leaf ? 1 : node.right.leaves);
        node.pos = (node.left.pos || 0) + (node.right.pos || 0);
        node.neg = (node.left.neg || 0) + (node.right.neg || 0);
        return node;
    }

    function predictTree(node, x, y) {
        while (!node.leaf) {
            var v = node.axis === 0 ? x : y;
            if (v <= node.thr) node = node.left; else node = node.right;
        }
        return node.pred;
    }
    function predictProbaTree(node, x, y) {
        while (!node.leaf) {
            var v = node.axis === 0 ? x : y;
            if (v <= node.thr) node = node.left; else node = node.right;
        }
        var tot = (node.pos || 0) + (node.neg || 0);
        return tot > 0 ? (node.pos || 0) / tot : 0.5;
    }

    // ── Metrics ───────────────────────────────────────────────
    function accuracyOnIdx(modelTree, idx) {
        if (idx.length === 0) return 0;
        var correct = 0;
        for (var i = 0; i < idx.length; i++) {
            var p = points[idx[i]];
            if (predictTree(modelTree, p.x, p.y) === p.c) correct++;
        }
        return correct / idx.length;
    }
    function f1OnIdx(modelTree, idx) {
        var tp = 0, fp = 0, fn = 0, tn = 0;
        for (var i = 0; i < idx.length; i++) {
            var p = points[idx[i]], pred = predictTree(modelTree, p.x, p.y);
            if (pred === 1 && p.c === 1) tp++;
            else if (pred === 1 && p.c === 0) fp++;
            else if (pred === 0 && p.c === 1) fn++;
            else tn++;
        }
        var prec = tp + fp > 0 ? tp / (tp + fp) : 1;
        var rec = tp + fn > 0 ? tp / (tp + fn) : 0;
        return (prec + rec) > 0 ? 2 * prec * rec / (prec + rec) : 0;
    }
    function balancedAccOnIdx(modelTree, idx) {
        var tp = 0, fp = 0, fn = 0, tn = 0;
        for (var i = 0; i < idx.length; i++) {
            var p = points[idx[i]], pred = predictTree(modelTree, p.x, p.y);
            if (pred === 1 && p.c === 1) tp++;
            else if (pred === 1 && p.c === 0) fp++;
            else if (pred === 0 && p.c === 1) fn++;
            else tn++;
        }
        var tpr = tp + fn > 0 ? tp / (tp + fn) : 0;
        var tnr = tn + fp > 0 ? tn / (tn + fp) : 0;
        return (tpr + tnr) / 2;
    }
    function prAucOnIdx(modelTree, idx) {
        if (idx.length === 0) return 0;
        var probs = [], labels = [];
        for (var i = 0; i < idx.length; i++) {
            var p = points[idx[i]];
            probs.push(predictProbaTree(modelTree, p.x, p.y));
            labels.push(p.c);
        }
        var order = probs.map(function (_, i) { return i; }).sort(function (a, b) { return probs[b] - probs[a]; });
        var tp = 0, fp = 0, fn = 0, tn = 0, P = 0, N = 0;
        for (var j = 0; j < labels.length; j++) { if (labels[j] === 1) P++; else N++; }
        fn = P; tn = N;
        var curve = [{ x: 0, y: 1 }]; var last = -1;
        for (var k = 0; k < order.length; k++) {
            var i2 = order[k];
            if (labels[i2] === 1) { tp++; fn--; } else { fp++; tn--; }
            var rec = P > 0 ? tp / P : 0;
            var prec = (tp + fp) > 0 ? tp / (tp + fp) : 1;
            if (probs[i2] !== last) { curve.push({ x: rec, y: prec }); last = probs[i2]; }
        }
        var ap = 0;
        curve.sort(function (a, b) { return a.x - b.x; });
        for (var t = 1; t < curve.length; t++) {
            var x0 = curve[t - 1].x, y0 = curve[t - 1].y, x1 = curve[t].x, y1 = curve[t].y;
            ap += (x1 - x0) * ((y0 + y1) / 2);
        }
        return Math.max(0, Math.min(1, ap));
    }
    function costScoreOnIdx(modelTree, idx, cFP, cFN) {
        if (idx.length === 0) return 0;
        var probs = [], labels = [];
        for (var i = 0; i < idx.length; i++) {
            var p = points[idx[i]];
            probs.push(predictProbaTree(modelTree, p.x, p.y));
            labels.push(p.c);
        }
        var order = probs.map(function (_, i) { return i; }).sort(function (a, b) { return probs[b] - probs[a]; });
        var bestCost = Infinity;
        var P = 0, N = 0;
        for (var j = 0; j < labels.length; j++) { if (labels[j] === 1) P++; else N++; }
        var tp = 0, fp = 0, fn = P, tn = N, last = -1;
        for (var k = 0; k < order.length; k++) {
            var i2 = order[k];
            if (labels[i2] === 1) { tp++; fn--; } else { fp++; tn--; }
            if (probs[i2] !== last) {
                var cost = cFP * fp + cFN * fn;
                if (cost < bestCost) bestCost = cost;
                last = probs[i2];
            }
        }
        var denom = cFN * P + cFP * N;
        var score = denom > 0 ? 1 - (bestCost / denom) : 0;
        return Math.max(0, Math.min(1, score));
    }
    function scoreOnIdx(modelTree, idx) {
        var m = $('dtMetric').value;
        if (m === 'accuracy') return accuracyOnIdx(modelTree, idx);
        if (m === 'f1') return f1OnIdx(modelTree, idx);
        if (m === 'balanced') return balancedAccOnIdx(modelTree, idx);
        if (m === 'prauc') return prAucOnIdx(modelTree, idx);
        if (m === 'cost') {
            var cFP = parseFloat($('dtCostFP').value);
            var cFN = parseFloat($('dtCostFN').value);
            return costScoreOnIdx(modelTree, idx, cFP, cFN);
        }
        return accuracyOnIdx(modelTree, idx);
    }

    // ── Folds & CV ────────────────────────────────────────────
    function kFoldIndices(n, k) {
        var idx = []; for (var i = 0; i < n; i++) idx.push(i);
        idx = shuffle(idx);
        var folds = []; var size = Math.floor(n / k); var start = 0;
        for (var f = 0; f < k - 1; f++) { folds.push(idx.slice(start, start + size)); start += size; }
        folds.push(idx.slice(start));
        return folds;
    }
    function forwardFolds(n, k) {
        var idx = []; for (var i = 0; i < n; i++) idx.push(i);
        var size = Math.floor(n / k); var folds = []; var start = 0;
        for (var f = 0; f < k - 1; f++) { folds.push(idx.slice(start, start + size)); start += size; }
        folds.push(idx.slice(start));
        return folds;
    }
    function runCV(params) {
        var k = parseInt($('dtKfolds').value);
        var strategy = $('dtValStrategy').value;
        var scores = [], trainScores = [], depths = [];
        var folds;
        if (strategy === 'forward') {
            folds = forwardFolds(points.length, k);
            for (var f = 1; f < k; f++) {
                var valIdx = folds[f];
                var trainIdx = [];
                for (var g = 0; g < f; g++) { trainIdx = trainIdx.concat(folds[g]); }
                if (trainIdx.length === 0 || valIdx.length === 0) continue;
                var t = buildTree(trainIdx, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
                scores.push(scoreOnIdx(t, valIdx));
                trainScores.push(scoreOnIdx(t, trainIdx));
                depths.push(t.depth);
            }
        } else {
            folds = kFoldIndices(points.length, k);
            for (var f2 = 0; f2 < k; f2++) {
                var valIdx2 = folds[f2];
                var trainIdx2 = [];
                for (var g2 = 0; g2 < k; g2++) { if (g2 !== f2) trainIdx2 = trainIdx2.concat(folds[g2]); }
                if (trainIdx2.length === 0 || valIdx2.length === 0) continue;
                var t2 = buildTree(trainIdx2, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
                scores.push(scoreOnIdx(t2, valIdx2));
                trainScores.push(scoreOnIdx(t2, trainIdx2));
                depths.push(t2.depth);
            }
        }
        var mean = meanArr(scores), std = stdArr(scores, mean);
        return { mean: mean, std: std, train: meanArr(trainScores), depth: meanArr(depths) };
    }

    // ── Validation curve sweep ───────────────────────────────
    function computeValCurve() {
        var sweep = $('dtSweep').value;
        var base = getParams();
        var xs = [], tr = [], cv = [];
        if (sweep === 'maxDepth') {
            for (var d = 1; d <= 12; d++) {
                base.maxDepth = d;
                var r = runCV(base);
                xs.push('' + d); tr.push(r.train); cv.push(r.mean);
            }
        } else if (sweep === 'minLeaf') {
            for (var ml = 1; ml <= 20; ml += 1) {
                base.minLeaf = ml;
                var r2 = runCV(base);
                xs.push('' + ml); tr.push(r2.train); cv.push(r2.mean);
            }
        } else {
            for (var a = 0; a <= 0.05; a += 0.005) {
                base.alpha = parseFloat(a.toFixed(3));
                var r3 = runCV(base);
                xs.push(a.toFixed(3)); tr.push(r3.train); cv.push(r3.mean);
            }
        }
        valChart.data.labels = xs;
        valChart.data.datasets[0].data = tr;
        valChart.data.datasets[1].data = cv;
        valChart.update('none');
    }

    // ── Grid search heatmap ──────────────────────────────────
    function computeHeatmap() {
        var base = getParams();
        var depths = [2, 4, 6, 8, 10, 12];
        var leaves = [1, 2, 3, 4, 5, 8, 12, 16, 20];
        heatData = { xs: depths, ys: leaves, mat: [] };
        for (var yi = 0; yi < leaves.length; yi++) {
            var row = [];
            for (var xi = 0; xi < depths.length; xi++) {
                base.maxDepth = depths[xi];
                base.minLeaf = leaves[yi];
                var r = runCV(base);
                row.push(r.mean);
            }
            heatData.mat.push(row);
        }
        drawHeatmap();
    }
    function drawHeatmap() {
        var W = heat.width, H = heat.height;
        hctx.clearRect(0, 0, W, H);
        if (!heatData.mat || heatData.mat.length === 0) return;
        var rows = heatData.mat.length, cols = heatData.mat[0].length;
        var cw = W / cols, ch = H / rows;
        var min = 1, max = 0;
        for (var r = 0; r < rows; r++) {
            for (var c = 0; c < cols; c++) {
                var v = heatData.mat[r][c];
                if (v < min) min = v;
                if (v > max) max = v;
            }
        }
        function color(v) {
            var t = (v - min) / (Math.max(1e-9, (max - min)));
            // indigo (low) → green (high)
            var R = Math.floor(99 * (1 - t) + 34 * t);
            var G = Math.floor(102 * (1 - t) + 197 * t);
            var B = Math.floor(241 * (1 - t) + 94 * t);
            return 'rgb(' + R + ',' + G + ',' + B + ')';
        }
        for (var r2 = 0; r2 < rows; r2++) {
            for (var c2 = 0; c2 < cols; c2++) {
                hctx.fillStyle = color(heatData.mat[r2][c2]);
                hctx.fillRect(c2 * cw, r2 * ch, cw - 1, ch - 1);
            }
        }
        hctx.fillStyle = '#1c1917';
        hctx.font = '12px ui-monospace, monospace';
        for (var c3 = 0; c3 < cols; c3++) {
            hctx.fillText('d=' + heatData.xs[c3], c3 * cw + 4, 14);
        }
        for (var r3 = 0; r3 < rows; r3++) {
            hctx.fillText('leaf=' + heatData.ys[r3], 4, r3 * ch + ch - 6);
        }
    }

    // ── Visualization drawing ────────────────────────────────
    function drawRegions() {
        var step = 6;
        for (var y = 0; y < canvas.height; y += step) {
            for (var x = 0; x < canvas.width; x += step) {
                var d = toDomain(x, y);
                var pred = tree ? predictTree(tree, d.x, d.y) : -1;
                var alpha = 0.12;
                if (pred === -1) { ctx.fillStyle = 'rgba(0,0,0,0)'; }
                else ctx.fillStyle = pred === 1
                    ? 'rgba(34,197,94,' + alpha + ')'
                    : 'rgba(239,68,68,' + alpha + ')';
                ctx.fillRect(x, y, step, step);
            }
        }
    }
    function drawSplits(node, rect) {
        if (!showSplits || !node || node.leaf) return;
        if (node.axis === 0) {
            var sx = node.thr;
            var a = toCanvas(sx, rect.ymin), b = toCanvas(sx, rect.ymax);
            ctx.strokeStyle = '#4f46e5'; ctx.setLineDash([6, 6]);
            ctx.beginPath(); ctx.moveTo(a.cx, a.cy); ctx.lineTo(b.cx, b.cy); ctx.stroke();
            ctx.setLineDash([]);
            drawSplits(node.left, { xmin: rect.xmin, xmax: sx, ymin: rect.ymin, ymax: rect.ymax });
            drawSplits(node.right, { xmin: sx, xmax: rect.xmax, ymin: rect.ymin, ymax: rect.ymax });
        } else {
            var sy = node.thr;
            var c = toCanvas(rect.xmin, sy), d = toCanvas(rect.xmax, sy);
            ctx.strokeStyle = '#4f46e5'; ctx.setLineDash([6, 6]);
            ctx.beginPath(); ctx.moveTo(c.cx, c.cy); ctx.lineTo(d.cx, d.cy); ctx.stroke();
            ctx.setLineDash([]);
            drawSplits(node.left, { xmin: rect.xmin, xmax: rect.xmax, ymin: rect.ymin, ymax: sy });
            drawSplits(node.right, { xmin: rect.xmin, xmax: rect.xmax, ymin: sy, ymax: rect.ymax });
        }
    }
    function drawPoints() {
        for (var i = 0; i < points.length; i++) {
            var p = points[i], c = toCanvas(p.x, p.y);
            ctx.beginPath(); ctx.arc(c.cx, c.cy, 5, 0, Math.PI * 2);
            ctx.fillStyle = p.c === 1 ? '#22c55e' : '#ef4444';
            ctx.fill();
            ctx.lineWidth = 1.5;
            ctx.strokeStyle = p.c === 1 ? '#15803d' : '#b91c1c';
            ctx.stroke();
        }
    }
    function drawAll() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        drawRegions();
        if (tree && showSplits) drawSplits(tree, { xmin: -2, xmax: 2, ymin: -2, ymax: 2 });
        drawPoints();
    }

    // ── Params + fit-on-all ──────────────────────────────────
    function getParams() {
        return {
            maxDepth: parseInt($('dtMaxDepth').value),
            minSplit: parseInt($('dtMinSplit').value),
            minLeaf:  parseInt($('dtMinLeaf').value),
            maxFeatures: parseInt($('dtMaxFeatures').value),
            alpha: parseFloat($('dtAlpha').value)
        };
    }
    function fitOnAll(params) {
        var idx = []; for (var i = 0; i < points.length; i++) idx.push(i);
        return buildTree(idx, 0, params.maxDepth, params.minSplit, params.minLeaf, params.maxFeatures, params.alpha);
    }

    // ── Dataset generators ───────────────────────────────────
    function genBalanced() {
        points = [];
        for (var i = 0; i < 90; i++) points.push({ x: -1.2 + randn() * 0.5, y: -1.0 + randn() * 0.5, c: 0 });
        for (var j = 0; j < 90; j++) points.push({ x:  1.2 + randn() * 0.5, y:  1.0 + randn() * 0.5, c: 1 });
    }
    function genOverlap() {
        points = [];
        for (var i = 0; i < 90; i++) points.push({ x: -0.7 + randn() * 1.0, y: -0.7 + randn() * 1.0, c: 0 });
        for (var j = 0; j < 90; j++) points.push({ x:  0.7 + randn() * 1.0, y:  0.7 + randn() * 1.0, c: 1 });
    }
    function genXOR() {
        points = []; var s = 0.45, n = 60;
        for (var i = 0; i < n; i++)  points.push({ x:  1.3 + randn() * s, y:  1.3 + randn() * s, c: 0 });
        for (var i2 = 0; i2 < n; i2++) points.push({ x: -1.3 + randn() * s, y: -1.3 + randn() * s, c: 0 });
        for (var j = 0; j < n; j++)  points.push({ x:  1.3 + randn() * s, y: -1.3 + randn() * s, c: 1 });
        for (var j2 = 0; j2 < n; j2++) points.push({ x: -1.3 + randn() * s, y:  1.3 + randn() * s, c: 1 });
    }
    function genMoons() {
        points = [];
        for (var i = 0; i < 80; i++) {
            var t = i / 80 * Math.PI;
            points.push({ x: Math.cos(t) + randn() * 0.1, y: Math.sin(t) + randn() * 0.1, c: 0 });
        }
        for (var j = 0; j < 80; j++) {
            var t2 = j / 80 * Math.PI;
            points.push({ x: Math.cos(t2) + 0.9 + randn() * 0.1, y: -Math.sin(t2) + 0.2 + randn() * 0.1, c: 1 });
        }
    }
    function genCircles() {
        points = [];
        for (var i = 0; i < 120; i++) {
            var r = 0.6 + randn() * 0.06;
            var t = 2 * Math.PI * Math.random();
            points.push({ x: r * Math.cos(t), y: r * Math.sin(t), c: 0 });
        }
        for (var j = 0; j < 120; j++) {
            var r2 = 1.2 + randn() * 0.08;
            var t2 = 2 * Math.PI * Math.random();
            points.push({ x: r2 * Math.cos(t2), y: r2 * Math.sin(t2), c: 1 });
        }
    }
    function applyPreset(name) {
        activePreset = name;
        if (name === 'balanced') genBalanced();
        else if (name === 'overlap') genOverlap();
        else if (name === 'xor') genXOR();
        else if (name === 'moons') genMoons();
        else if (name === 'circles') genCircles();
        tree = fitOnAll(getParams());
        drawAll();
        // active state on preset row
        var btns = document.querySelectorAll('.dt-preset');
        for (var i = 0; i < btns.length; i++) {
            btns[i].classList.toggle('is-active', btns[i].dataset.preset === name);
        }
    }

    // ── Final hold-out test ──────────────────────────────────
    function makeFinalTestSplit(pct) {
        var n = points.length;
        var cut = Math.max(1, Math.floor(n * (1 - pct / 100)));
        testIdx = [];
        for (var i = cut; i < n; i++) testIdx.push(i);
    }
    function evaluateOnFinalTest() {
        if (testIdx.length === 0) { $('dtTestScore').textContent = '—'; return; }
        var p = getParams();
        var trainIdx = [];
        var testSet = testIdx.slice(0);
        for (var i = 0; i < points.length; i++) {
            if (testSet.indexOf(i) === -1) trainIdx.push(i);
        }
        var t = buildTree(trainIdx, 0, p.maxDepth, p.minSplit, p.minLeaf, p.maxFeatures, p.alpha);
        var m = $('dtMetric').value;
        var score;
        if (m === 'prauc') score = prAucOnIdx(t, testIdx);
        else if (m === 'cost') score = costScoreOnIdx(t, testIdx, parseFloat($('dtCostFP').value), parseFloat($('dtCostFN').value));
        else if (m === 'balanced') score = balancedAccOnIdx(t, testIdx);
        else if (m === 'f1') score = f1OnIdx(t, testIdx);
        else score = accuracyOnIdx(t, testIdx);
        $('dtTestScore').textContent = score.toFixed(3);
    }

    function runRecommend() {
        var p = getParams();
        var r = runCV(p);
        $('dtCvMean').textContent = r.mean.toFixed(3);
        $('dtCvStd').textContent  = r.std.toFixed(3);
        var best = { score: -1, params: null };
        for (var d = Math.max(1, p.maxDepth - 2); d <= Math.min(12, p.maxDepth + 2); d++) {
            for (var ml = Math.max(1, p.minLeaf - 2); ml <= Math.min(20, p.minLeaf + 2); ml++) {
                var trial = { maxDepth: d, minSplit: p.minSplit, minLeaf: ml, maxFeatures: p.maxFeatures, alpha: p.alpha };
                var rr = runCV(trial);
                var tieBetter = (rr.mean === best.score) && best.params && (d < best.params.maxDepth);
                if (rr.mean > best.score || tieBetter) { best = { score: rr.mean, params: trial }; }
            }
        }
        if (best.params) {
            $('dtRecParams').textContent =
                'depth=' + best.params.maxDepth + ', leaf=' + best.params.minLeaf +
                ', score=' + best.score.toFixed(3);
            tree = fitOnAll(best.params);
            drawAll();
        }
        computeValCurve();
        computeHeatmap();
    }

    // ── Class indicator toggle ───────────────────────────────
    function updateClassIndicator() {
        var btn = $('dtClassIndicator');
        if (!btn) return;
        btn.dataset.class = String(currentClass);
        $('dtClassIndicatorText').textContent = currentClass === 1 ? 'Class 1' : 'Class 0';
    }

    // ── Init / bootstrap (TDZ-safe: bottom of IIFE) ──────────
    function init() {
        canvas = $('dtCanvas');
        ctx = canvas.getContext('2d');
        heat = $('dtHeatCanvas');
        hctx = heat.getContext('2d');

        valChart = new Chart($('dtValChart'), {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    { label: 'Train', data: [], borderColor: '#4f46e5', backgroundColor: 'rgba(79,70,229,0.12)', tension: 0.2 },
                    { label: 'CV',    data: [], borderColor: '#22c55e', backgroundColor: 'rgba(34,197,94,0.12)', tension: 0.2 }
                ]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: {
                    x: { title: { display: true, text: 'Hyperparameter' } },
                    y: { min: 0, max: 1, title: { display: true, text: 'Score' } }
                },
                plugins: { legend: { display: true } }
            }
        });

        // Resize handling
        window.addEventListener('resize', function () { resizeCanvas(); resizeHeat(); });

        // Canvas point-adding
        canvas.addEventListener('click', function (evt) {
            var br = canvas.getBoundingClientRect();
            var x = evt.clientX - br.left, y = evt.clientY - br.top;
            var d = toDomain(x, y);
            points.push({ x: d.x, y: d.y, c: currentClass });
            tree = fitOnAll(getParams());
            drawAll();
        });

        // Class toggle indicator
        var classBtn = $('dtClassIndicator');
        if (classBtn) {
            classBtn.addEventListener('click', function () {
                currentClass = currentClass === 1 ? 0 : 1;
                updateClassIndicator();
            });
            updateClassIndicator();
        }

        // Presets
        document.querySelectorAll('.dt-preset').forEach(function (btn) {
            btn.addEventListener('click', function () {
                applyPreset(btn.dataset.preset);
            });
        });

        // Clear
        $('dtBtnClear').addEventListener('click', function () {
            points = []; tree = null; drawAll();
        });

        // Splits toggle
        $('dtShowSplits').addEventListener('change', function () {
            showSplits = this.checked; drawAll();
        });

        // Slider live-updates
        function bind(id, valId, fmt) {
            var el = $(id);
            if (!el) return;
            el.addEventListener('input', function () {
                if (valId) $(valId).textContent = fmt ? fmt(this.value) : this.value;
                tree = fitOnAll(getParams());
                drawAll();
            });
        }
        bind('dtMaxDepth',    'dtMaxDepthVal');
        bind('dtMinSplit',    'dtMinSplitVal');
        bind('dtMinLeaf',     'dtMinLeafVal');
        bind('dtMaxFeatures', 'dtMaxFeaturesVal');
        bind('dtAlpha',       'dtAlphaVal', function (v) { return parseFloat(v).toFixed(3); });

        // Non-fitting bindings (k-folds, costs just update text)
        $('dtKfolds').addEventListener('input', function () { $('dtKfoldsVal').textContent = this.value; });
        $('dtCostFP').addEventListener('input', function () { $('dtCostFPVal').textContent = parseFloat(this.value).toFixed(1); });
        $('dtCostFN').addEventListener('input', function () { $('dtCostFNVal').textContent = parseFloat(this.value).toFixed(1); });

        // Criterion change refits visualization
        $('dtCriterion').addEventListener('change', function () {
            tree = fitOnAll(getParams()); drawAll();
        });

        // Actions
        $('dtBtnRunCV').addEventListener('click', runRecommend);
        $('dtBtnValCurve').addEventListener('click', computeValCurve);
        $('dtSweep').addEventListener('change', computeValCurve);

        // Final test
        $('dtBtnMakeTest').addEventListener('click', function () {
            var pct = parseInt($('dtTestPct').value);
            makeFinalTestSplit(pct);
            $('dtTestScore').textContent = '—';
        });
        $('dtBtnEvalTest').addEventListener('click', evaluateOnFinalTest);

        // First paint
        resizeCanvas();
        resizeHeat();
        applyPreset('balanced');
        // Auto-run the two slow CV artifacts so first-time visitors see them populated.
        try { computeValCurve(); computeHeatmap(); } catch (e) {}
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
