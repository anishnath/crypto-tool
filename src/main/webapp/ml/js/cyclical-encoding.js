/*
 * cyclical-encoding.js — Cyclical Encoding visualizer.
 *
 * Maps a periodic scalar (hour / month / day-of-week / angle) onto the
 * unit circle via (cos θ, sin θ), and compares raw-numeric vs sin/cos
 * encodings on a synthetic regression/classification task across three
 * model families: linear, tree-binning, and kNN (with cyclic distance).
 *
 * All IDs use the `ce*` prefix (paired with .ce-* CSS classes).
 */
(function () {
    'use strict';

    var TAU = Math.PI * 2;
    var MAX_TRAIL = 60;

    // ── Elements (resolved on init) ──────────────────────────
    var unitCircle, perfChart, sizeChart;
    var featureSel, valueRange, valueLabel;
    var periodRange, periodLabel, noiseRange, noiseLabel;
    var modeSel, modelSel, compareOneHot;
    var mR2, mMAE, mAcc, mF1;
    var impSin, impCos, impSinLbl, impCosLbl;

    // ── State ────────────────────────────────────────────────
    var trail = [];

    var presets = {
        hour:  { min: 0, max: 23,  step: 1, period: 24,  start: 0 },
        month: { min: 1, max: 12,  step: 1, period: 12,  start: 1 },
        dow:   { min: 0, max: 6,   step: 1, period: 7,   start: 0 },
        angle: { min: 0, max: 360, step: 1, period: 360, start: 0 }
    };

    // ── Canvas sizing ────────────────────────────────────────
    function fitCanvas(cnv) {
        var rect = cnv.getBoundingClientRect();
        cnv.width  = Math.max(320, Math.floor(rect.width));
        cnv.height = Math.max(160, Math.floor(rect.height));
    }
    function fitAll() {
        fitCanvas(unitCircle);
        fitCanvas(perfChart);
        fitCanvas(sizeChart);
        drawAll();
    }

    // ── Math helpers ─────────────────────────────────────────
    function cyclicAngle(value, period) {
        return TAU * (Number(value) % period) / period;
    }
    function cyclicDistance(a, b, period) {
        var d = Math.abs(a - b);
        return Math.min(d, period - d);
    }

    function fitLinearXY(x, y) {
        var n = x.length;
        var sx = 0, sy = 0, sxx = 0, sxy = 0;
        for (var i = 0; i < n; i++) { sx += x[i]; sy += y[i]; sxx += x[i] * x[i]; sxy += x[i] * y[i]; }
        var denom = (n * sxx - sx * sx);
        var b = denom === 0 ? 0 : (n * sxy - sx * sy) / denom;
        var a = sy / n - b * (sx / n);
        return { a: a, b: b };
    }
    function predictLinearXY(model, x) { return model.a + model.b * x; }

    function solve3x3(A, b) {
        var M = [
            [A[0][0], A[0][1], A[0][2], b[0]],
            [A[1][0], A[1][1], A[1][2], b[1]],
            [A[2][0], A[2][1], A[2][2], b[2]]
        ];
        for (var i = 0; i < 3; i++) {
            var maxRow = i;
            for (var r = i + 1; r < 3; r++) if (Math.abs(M[r][i]) > Math.abs(M[maxRow][i])) maxRow = r;
            var tmp = M[i]; M[i] = M[maxRow]; M[maxRow] = tmp;
            var pivot = M[i][i] || 1e-12;
            for (var c = i; c < 4; c++) M[i][c] /= pivot;
            for (var r2 = 0; r2 < 3; r2++) {
                if (r2 === i) continue;
                var factor = M[r2][i];
                for (var c2 = i; c2 < 4; c2++) M[r2][c2] -= factor * M[i][c2];
            }
        }
        return [M[0][3], M[1][3], M[2][3]];
    }
    function fitLinearSinCos(data) {
        var n = data.length;
        var s1 = 0, ssin = 0, scos = 0;
        var s_sin2 = 0, s_cos2 = 0, s_sin_cos = 0;
        var s1_y = 0, s_sin_y = 0, s_cos_y = 0;
        for (var i = 0; i < n; i++) {
            var si = data[i].sin, co = data[i].cos, y = data[i].y;
            s1 += 1;
            ssin += si; scos += co;
            s_sin2 += si * si; s_cos2 += co * co; s_sin_cos += si * co;
            s1_y += y; s_sin_y += si * y; s_cos_y += co * y;
        }
        var A = [
            [s1,   ssin,    scos],
            [ssin, s_sin2,  s_sin_cos],
            [scos, s_sin_cos, s_cos2]
        ];
        var rhs = [s1_y, s_sin_y, s_cos_y];
        var beta = solve3x3(A, rhs);
        return { w0: beta[0], wSin: beta[1], wCos: beta[2] };
    }

    function fitTreeBins(data, bins) {
        var period = Number(periodRange.value);
        var binSize = period / bins;
        var stats = [];
        for (var k = 0; k < bins; k++) stats.push({ sum: 0, cnt: 0, pos: 0 });
        data.forEach(function (d) {
            var idx = Math.floor(d.x / binSize);
            if (idx < 0) idx = 0;
            if (idx >= bins) idx = bins - 1;
            stats[idx].sum += d.y;
            stats[idx].cnt += 1;
            stats[idx].pos += d.yClass ? 1 : 0;
        });
        var means = stats.map(function (s) { return s.cnt ? s.sum / s.cnt : 0; });
        var maj = stats.map(function (s) { return s.pos >= (s.cnt - s.pos) ? 1 : 0; });
        return { bins: bins, binSize: binSize, means: means, maj: maj };
    }
    function predictTree(model, x, mode) {
        var idx = Math.floor(x / model.binSize);
        if (idx < 0) idx = 0;
        if (idx >= model.bins) idx = model.bins - 1;
        return mode === 'reg' ? model.means[idx] : model.maj[idx];
    }

    function predictKNN(data, x, k, mode) {
        var period = Number(periodRange.value);
        var arr = data.map(function (d) {
            return { d: cyclicDistance(d.x, x, period), y: d.y, yClass: d.yClass };
        });
        arr.sort(function (a, b) { return a.d - b.d; });
        var take = arr.slice(0, k);
        if (mode === 'reg') {
            var s = 0; for (var i = 0; i < take.length; i++) s += take[i].y;
            return s / take.length;
        } else {
            var pos = 0; for (var j = 0; j < take.length; j++) pos += take[j].yClass ? 1 : 0;
            return pos >= (take.length - pos) ? 1 : 0;
        }
    }

    // Metrics
    function mae(y, yhat) {
        var s = 0; for (var i = 0; i < y.length; i++) s += Math.abs(y[i] - yhat[i]);
        return s / y.length;
    }
    function r2(y, yhat) {
        var m = 0; for (var i = 0; i < y.length; i++) m += y[i]; m /= y.length;
        var ssTot = 0, ssRes = 0;
        for (var j = 0; j < y.length; j++) { ssTot += Math.pow(y[j] - m, 2); ssRes += Math.pow(y[j] - yhat[j], 2); }
        return ssTot === 0 ? 1 : 1 - (ssRes / ssTot);
    }
    function accuracy(yTrue, yPred) {
        var c = 0; for (var i = 0; i < yTrue.length; i++) if (yTrue[i] === yPred[i]) c++;
        return c / yTrue.length;
    }
    function f1Score(yTrue, yPred) {
        var tp = 0, fp = 0, fn = 0;
        for (var i = 0; i < yTrue.length; i++) {
            if (yPred[i] === 1 && yTrue[i] === 1) tp++;
            else if (yPred[i] === 1 && yTrue[i] === 0) fp++;
            else if (yPred[i] === 0 && yTrue[i] === 1) fn++;
        }
        var prec = tp === 0 ? 0 : tp / (tp + fp);
        var rec  = tp === 0 ? 0 : tp / (tp + fn);
        return (prec + rec === 0) ? 0 : 2 * prec * rec / (prec + rec);
    }

    // ── Drawing: unit circle ─────────────────────────────────
    function drawUnitCircle() {
        var ctx = unitCircle.getContext('2d');
        var w = unitCircle.width, h = unitCircle.height;
        ctx.clearRect(0, 0, w, h);

        var cx = w / 2, cy = h / 2, r = Math.min(w, h) * 0.38;

        // Axes
        ctx.strokeStyle = 'rgba(0,0,0,0.10)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(cx - r - 14, cy); ctx.lineTo(cx + r + 14, cy);
        ctx.moveTo(cx, cy - r - 14); ctx.lineTo(cx, cy + r + 14);
        ctx.stroke();

        // Circle
        ctx.beginPath();
        ctx.arc(cx, cy, r, 0, TAU);
        ctx.strokeStyle = 'rgba(245, 158, 11, 0.4)';
        ctx.lineWidth = 2;
        ctx.stroke();

        // Radial steps
        var period = Number(periodRange.value);
        ctx.strokeStyle = 'rgba(0,0,0,0.12)';
        ctx.lineWidth = 1;
        for (var i = 0; i < period; i++) {
            var a = TAU * i / period;
            var x = cx + r * Math.cos(a);
            var y = cy + r * Math.sin(a);
            ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(x, y); ctx.stroke();
        }

        // Current point
        var val = Number(valueRange.value);
        var aNow = cyclicAngle(val, period);
        var px = cx + r * Math.cos(aNow);
        var py = cy + r * Math.sin(aNow);

        // Trail
        trail.push({ x: px, y: py, a: aNow });
        if (trail.length > MAX_TRAIL) trail.shift();
        for (var t = 0; t < trail.length; t++) {
            var alpha = 0.10 + 0.55 * (t / trail.length);
            ctx.fillStyle = 'rgba(245, 158, 11,' + alpha.toFixed(3) + ')';
            ctx.beginPath();
            ctx.arc(trail[t].x, trail[t].y, 3, 0, TAU);
            ctx.fill();
        }

        // Current dot
        ctx.fillStyle = '#f59e0b';
        ctx.beginPath();
        ctx.arc(px, py, 7, 0, TAU);
        ctx.fill();
        ctx.strokeStyle = '#b45309';
        ctx.lineWidth = 1.5;
        ctx.stroke();

        // Label θ in degrees
        ctx.fillStyle = '#44403c';
        ctx.font = '12px ui-monospace, monospace';
        ctx.fillText('θ = ' + (aNow * 180 / Math.PI).toFixed(1) + '°', px + 12, py - 12);
    }

    // ── Data + evaluate + curves ─────────────────────────────
    function generateData(n, period, noise) {
        var data = [];
        for (var i = 0; i < n; i++) {
            var x = Math.random() * period;
            var a = TAU * (x / period);
            var base = Math.sin(a);
            var y = base + (Math.random() * 2 - 1) * noise;
            data.push({
                x: x, a: a, sin: Math.sin(a), cos: Math.cos(a),
                y: y, yClass: (y >= 0) ? 1 : 0
            });
        }
        return data;
    }

    function drawPerfChart(data, period, mode, modelKind) {
        var ctx = perfChart.getContext('2d');
        var w = perfChart.width, h = perfChart.height, pad = 30;
        ctx.clearRect(0, 0, w, h);

        ctx.strokeStyle = 'rgba(0,0,0,0.12)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad, h - pad); ctx.lineTo(w - pad, h - pad);
        ctx.moveTo(pad, pad);     ctx.lineTo(pad, h - pad);
        ctx.stroke();

        function x2px(x) { return pad + (w - 2 * pad) * (x / period); }
        function y2py(y) {
            var minY = mode === 'reg' ? -1.5 : -0.2;
            var maxY = mode === 'reg' ?  1.5 :  1.2;
            return h - pad - (h - 2 * pad) * ((y - minY) / (maxY - minY));
        }

        var gridN = Math.max(60, Math.floor(3 * period));
        var xs = []; for (var k = 0; k < gridN; k++) xs.push(k * (period / (gridN - 1)));

        function predRaw(x) {
            if (modelKind === 'linear') {
                var mdl = fitLinearXY(
                    data.map(function (d) { return d.x; }),
                    mode === 'reg' ? data.map(function (d) { return d.y; })
                                   : data.map(function (d) { return d.yClass; })
                );
                var p = predictLinearXY(mdl, x);
                return mode === 'reg' ? p : (p >= 0.5 ? 1 : 0);
            } else if (modelKind === 'tree') {
                var tree = fitTreeBins(data, 12);
                return predictTree(tree, x, mode);
            } else {
                return predictKNN(data, x, 5, mode);
            }
        }
        function predSC(x) {
            var a = TAU * (x / period);
            if (modelKind === 'linear') {
                if (mode === 'reg') {
                    var mdlSC = fitLinearSinCos(data);
                    return mdlSC.w0 + mdlSC.wSin * Math.sin(a) + mdlSC.wCos * Math.cos(a);
                } else {
                    var c0 = { sx: 0, cx: 0, n: 0 }, c1 = { sx: 0, cx: 0, n: 0 };
                    data.forEach(function (d) {
                        if (d.yClass === 1) { c1.sx += d.sin; c1.cx += d.cos; c1.n++; }
                        else { c0.sx += d.sin; c0.cx += d.cos; c0.n++; }
                    });
                    if (c0.n === 0 || c1.n === 0) return 0;
                    c0.sx /= c0.n; c0.cx /= c0.n; c1.sx /= c1.n; c1.cx /= c1.n;
                    var s = Math.sin(a), co = Math.cos(a);
                    var d0 = Math.hypot(s - c0.sx, co - c0.cx);
                    var d1 = Math.hypot(s - c1.sx, co - c1.cx);
                    return d1 < d0 ? 1 : 0;
                }
            } else if (modelKind === 'tree') {
                var tree2 = fitTreeBins(data, 12);
                return predictTree(tree2, x, mode);
            } else {
                return predictKNN(data, x, 5, mode);
            }
        }

        ctx.lineWidth = 2;

        // RAW curve — red
        ctx.strokeStyle = '#ef4444';
        ctx.beginPath();
        for (var i = 0; i < xs.length; i++) {
            var v = predRaw(xs[i]);
            var py = y2py(v), px = x2px(xs[i]);
            if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
        }
        ctx.stroke();

        // SC curve — amber
        ctx.strokeStyle = '#f59e0b';
        ctx.beginPath();
        for (var j = 0; j < xs.length; j++) {
            var v2 = predSC(xs[j]);
            var py2 = y2py(v2), px2 = x2px(xs[j]);
            if (j === 0) ctx.moveTo(px2, py2); else ctx.lineTo(px2, py2);
        }
        ctx.stroke();

        // Legend
        ctx.font = '12px ui-monospace, monospace';
        ctx.fillStyle = '#ef4444'; ctx.fillRect(pad + 2, pad + 4, 12, 3);
        ctx.fillStyle = '#44403c'; ctx.fillText('raw numeric',  pad + 20, pad + 10);
        ctx.fillStyle = '#f59e0b'; ctx.fillRect(pad + 2, pad + 18, 12, 3);
        ctx.fillStyle = '#44403c'; ctx.fillText('sin/cos',      pad + 20, pad + 24);
    }

    function importanceFromSC(mdl) {
        var a = Math.abs(mdl.wSin), b = Math.abs(mdl.wCos);
        var s = (a + b) || 1;
        return { sin: a / s, cos: b / s };
    }

    function evaluate(data, period, mode, modelKind) {
        var yTrueReg = data.map(function (d) { return d.y; });
        var yTrueClf = data.map(function (d) { return d.yClass; });

        var yPredRaw = [], yPredSC = [];
        if (modelKind === 'linear') {
            if (mode === 'reg') {
                var mdlRaw = fitLinearXY(data.map(function (d) { return d.x; }), yTrueReg);
                var mdlSC = fitLinearSinCos(data);
                for (var i = 0; i < data.length; i++) {
                    yPredRaw.push(predictLinearXY(mdlRaw, data[i].x));
                    yPredSC.push(mdlSC.w0 + mdlSC.wSin * data[i].sin + mdlSC.wCos * data[i].cos);
                }
                return {
                    r2Raw: r2(yTrueReg, yPredRaw), maeRaw: mae(yTrueReg, yPredRaw),
                    r2SC:  r2(yTrueReg, yPredSC),  maeSC:  mae(yTrueReg, yPredSC),
                    accRaw: NaN, accSC: NaN, f1Raw: NaN, f1SC: NaN,
                    importances: importanceFromSC(mdlSC)
                };
            } else {
                // RAW: best single-threshold classifier on x
                var sorted = data.slice().sort(function (a, b) { return a.x - b.x; });
                var bestAcc = -1, bestT = 0;
                for (var i2 = 1; i2 < sorted.length; i2++) {
                    var t = (sorted[i2 - 1].x + sorted[i2].x) / 2;
                    var yp = sorted.map(function (d) { return (d.x >= t) ? 1 : 0; });
                    var acc = accuracy(yTrueClf, yp);
                    if (acc > bestAcc) { bestAcc = acc; bestT = t; }
                }
                yPredRaw = data.map(function (d) { return (d.x >= bestT) ? 1 : 0; });

                // SC: nearest centroid in (sin, cos)
                var c0 = { sx: 0, cx: 0, n: 0 }, c1 = { sx: 0, cx: 0, n: 0 };
                data.forEach(function (d) {
                    if (d.yClass === 1) { c1.sx += d.sin; c1.cx += d.cos; c1.n++; }
                    else { c0.sx += d.sin; c0.cx += d.cos; c0.n++; }
                });
                if (c0.n > 0) { c0.sx /= c0.n; c0.cx /= c0.n; }
                if (c1.n > 0) { c1.sx /= c1.n; c1.cx /= c1.n; }
                yPredSC = data.map(function (d) {
                    var d0 = Math.hypot(d.sin - c0.sx, d.cos - c0.cx);
                    var d1 = Math.hypot(d.sin - c1.sx, d.cos - c1.cx);
                    return d1 < d0 ? 1 : 0;
                });
                return {
                    r2Raw: NaN, maeRaw: NaN, r2SC: NaN, maeSC: NaN,
                    accRaw: accuracy(yTrueClf, yPredRaw),
                    accSC:  accuracy(yTrueClf, yPredSC),
                    f1Raw:  f1Score(yTrueClf, yPredRaw),
                    f1SC:   f1Score(yTrueClf, yPredSC),
                    importances: { sin: 0.5, cos: 0.5 }
                };
            }
        } else if (modelKind === 'tree') {
            var tree = fitTreeBins(data, 12);
            yPredRaw = data.map(function (d) { return predictTree(tree, d.x, mode); });
            yPredSC = yPredRaw.slice();
        } else {
            yPredRaw = data.map(function (d) { return predictKNN(data, d.x, 5, mode); });
            yPredSC  = yPredRaw.slice();
        }

        if (mode === 'reg') {
            return {
                r2Raw: r2(yTrueReg, yPredRaw), maeRaw: mae(yTrueReg, yPredRaw),
                r2SC:  r2(yTrueReg, yPredSC),  maeSC:  mae(yTrueReg, yPredSC),
                accRaw: NaN, accSC: NaN, f1Raw: NaN, f1SC: NaN,
                importances: { sin: 0.5, cos: 0.5 }
            };
        }
        return {
            r2Raw: NaN, maeRaw: NaN, r2SC: NaN, maeSC: NaN,
            accRaw: accuracy(yTrueClf, yPredRaw), accSC: accuracy(yTrueClf, yPredSC),
            f1Raw:  f1Score(yTrueClf, yPredRaw),  f1SC:  f1Score(yTrueClf, yPredSC),
            importances: { sin: 0.5, cos: 0.5 }
        };
    }

    function drawSizeChart(period, perf, mode) {
        var ctx = sizeChart.getContext('2d');
        var w = sizeChart.width, h = sizeChart.height, pad = 30;
        ctx.clearRect(0, 0, w, h);

        var labels = ['raw (1)', 'sin+cos (2)', 'one-hot (' + Math.round(period) + ')', 'both (' + (Math.round(period) + 2) + ')'];
        var sizes  = [1, 2, period, period + 2];
        var perfVals;
        if (mode === 'reg') {
            var worst = Math.max(perf.maeRaw, perf.maeSC);
            var ref = worst || 1;
            var rawScore = 1 - (perf.maeRaw / ref);
            var scScore  = 1 - (perf.maeSC  / ref);
            perfVals = [rawScore, scScore, Math.min(1, scScore * 1.02), Math.min(1, scScore * 1.02)];
        } else {
            var rawScore2 = perf.accRaw || 0;
            var scScore2  = perf.accSC  || 0;
            perfVals = [rawScore2, scScore2, Math.min(1, scScore2 * 1.02), Math.min(1, scScore2 * 1.02)];
        }

        function xOf(i) { return pad + i * ((w - 2 * pad) / labels.length) + 20; }
        function yOf(v) { return h - pad - v * (h - 2 * pad); }

        ctx.strokeStyle = 'rgba(0,0,0,0.12)';
        ctx.beginPath();
        ctx.moveTo(pad, h - pad); ctx.lineTo(w - pad, h - pad);
        ctx.stroke();

        var maxSize = Math.max.apply(null, sizes);
        for (var i = 0; i < labels.length; i++) {
            var szh = (sizes[i] / maxSize) * 0.9;
            ctx.fillStyle = 'rgba(120, 113, 108, 0.55)';
            ctx.fillRect(xOf(i) - 10, yOf(szh), 20, (h - pad) - yOf(szh));
        }
        for (var j = 0; j < labels.length; j++) {
            ctx.fillStyle = (j === 0) ? '#ef4444' : '#f59e0b';
            var v = perfVals[j];
            ctx.fillRect(xOf(j) + 12, yOf(v), 20, (h - pad) - yOf(v));
        }

        ctx.fillStyle = '#44403c';
        ctx.font = '11px ui-monospace, monospace';
        for (var k = 0; k < labels.length; k++) {
            ctx.save();
            ctx.translate(xOf(k) + 12, h - pad + 14);
            ctx.rotate(-Math.PI / 5);
            ctx.fillText(labels[k], 0, 0);
            ctx.restore();
        }
    }

    function updateMetrics(perf, mode) {
        function fmt(v, digits) { return isFinite(v) ? v.toFixed(digits) : '—'; }
        if (mode === 'reg') {
            mR2.innerHTML  = 'R<sup>2</sup>: <strong>' + fmt(perf.r2SC, 2) + '</strong> <span style="color:#b91c1c;">(' + fmt(perf.r2Raw, 2) + ' raw)</span>';
            mMAE.innerHTML = 'MAE: <strong>' + fmt(perf.maeSC, 3) + '</strong> <span style="color:#b91c1c;">(' + fmt(perf.maeRaw, 3) + ' raw)</span>';
            mAcc.innerHTML = 'Accuracy: <strong>—</strong>';
            mF1.innerHTML  = 'F1: <strong>—</strong>';
        } else {
            mR2.innerHTML  = 'R<sup>2</sup>: <strong>—</strong>';
            mMAE.innerHTML = 'MAE: <strong>—</strong>';
            mAcc.innerHTML = 'Accuracy: <strong>' + (isFinite(perf.accSC) ? (perf.accSC * 100).toFixed(1) + '%' : '—') + '</strong> <span style="color:#b91c1c;">(' + (isFinite(perf.accRaw) ? (perf.accRaw * 100).toFixed(1) + '%' : '—') + ' raw)</span>';
            mF1.innerHTML  = 'F1: <strong>' + fmt(perf.f1SC, 2) + '</strong> <span style="color:#b91c1c;">(' + fmt(perf.f1Raw, 2) + ' raw)</span>';
        }
        var sIm = (perf.importances && isFinite(perf.importances.sin)) ? perf.importances.sin : 0.5;
        var cIm = (perf.importances && isFinite(perf.importances.cos)) ? perf.importances.cos : 0.5;
        impSin.style.width = (sIm * 100).toFixed(0) + '%';
        impCos.style.width = (cIm * 100).toFixed(0) + '%';
        impSinLbl.textContent = sIm.toFixed(2);
        impCosLbl.textContent = cIm.toFixed(2);
    }

    function setFeatureUI(kind) {
        var p = presets[kind];
        valueRange.min = p.min;
        valueRange.max = p.max;
        valueRange.step = p.step;
        valueRange.value = p.start;
        valueLabel.textContent = String(p.start);
        periodRange.value = p.period;
        periodLabel.textContent = String(p.period);
        trail = [];
        drawAll();
    }

    function drawAll() {
        var period = Number(periodRange.value);
        var mode = modeSel.value;
        var modelKind = modelSel.value;

        drawUnitCircle();

        var data = generateData(240, period, Number(noiseRange.value));
        var perf = evaluate(data, period, mode, modelKind);
        updateMetrics(perf, mode);
        drawPerfChart(data, period, mode, modelKind);
        if (compareOneHot.checked) {
            drawSizeChart(period, perf, mode);
        } else {
            var ctx = sizeChart.getContext('2d');
            ctx.clearRect(0, 0, sizeChart.width, sizeChart.height);
        }

        // Linear-only sections (perf chart + importance bars).  Trees split on thresholds
        // and our kNN already uses cyclic distance, so for both, raw and sin/cos collapse to
        // the same curve — confusing without an explainer. Same goes for the regression
        // weight bars, which are only well-defined for the linear-regression fit.
        var perfWrap = document.getElementById('cePerfWrap');
        var impWrap  = document.getElementById('ceImpWrap');
        var msg      = document.getElementById('ceDisabledMsg');
        var isLinear = (modelKind === 'linear');
        if (perfWrap) perfWrap.classList.toggle('is-disabled', !isLinear);
        if (impWrap)  impWrap.classList.toggle('is-disabled', !isLinear);
        if (!isLinear && msg) {
            msg.innerHTML = (modelKind === 'tree')
                ? 'Trees split on thresholds — they don’t care about cyclic structure. Switch to <em>Linear</em> to see the seam break.'
                : 'kNN here already uses <em>cyclic distance</em>, so encoding is irrelevant. Switch to <em>Linear</em> to see the seam break.';
        }
    }

    // ── Init / bootstrap (TDZ-safe: bottom of IIFE) ──────────
    function init() {
        unitCircle    = document.getElementById('ceUnitCircle');
        perfChart     = document.getElementById('cePerfChart');
        sizeChart     = document.getElementById('ceSizeChart');
        featureSel    = document.getElementById('ceFeature');
        valueRange    = document.getElementById('ceValue');
        valueLabel    = document.getElementById('ceValueLabel');
        periodRange   = document.getElementById('cePeriod');
        periodLabel   = document.getElementById('cePeriodLabel');
        noiseRange    = document.getElementById('ceNoise');
        noiseLabel    = document.getElementById('ceNoiseLabel');
        modeSel       = document.getElementById('ceMode');
        modelSel      = document.getElementById('ceModel');
        compareOneHot = document.getElementById('ceCompareOneHot');
        mR2  = document.getElementById('ceMetricR2');
        mMAE = document.getElementById('ceMetricMAE');
        mAcc = document.getElementById('ceMetricAcc');
        mF1  = document.getElementById('ceMetricF1');
        impSin    = document.getElementById('ceImpSin');
        impCos    = document.getElementById('ceImpCos');
        impSinLbl = document.getElementById('ceImpSinLbl');
        impCosLbl = document.getElementById('ceImpCosLbl');

        window.addEventListener('resize', fitAll);

        featureSel.addEventListener('change', function () { setFeatureUI(featureSel.value); });
        valueRange.addEventListener('input', function () { valueLabel.textContent = String(valueRange.value); drawAll(); });
        periodRange.addEventListener('input', function () {
            var p = Number(periodRange.value);
            periodLabel.textContent = String(p);
            // Keep the value slider bounded by the current period so the dot can sweep the full circle
            // without going past it (otherwise hour=23 stays put while period→360 leaves most of the circle untouched).
            valueRange.max = String(p - 1);
            if (Number(valueRange.value) > p - 1) {
                valueRange.value = String(p - 1);
                valueLabel.textContent = valueRange.value;
            }
            trail = [];
            drawAll();
        });
        noiseRange.addEventListener('input', function () { noiseLabel.textContent = Number(noiseRange.value).toFixed(2); drawAll(); });
        modeSel.addEventListener('change', drawAll);
        modelSel.addEventListener('change', drawAll);
        compareOneHot.addEventListener('change', drawAll);

        setFeatureUI('hour');
        noiseLabel.textContent = Number(noiseRange.value).toFixed(2);
        fitAll();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
