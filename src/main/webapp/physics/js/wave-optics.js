/**
 * Wave Optics - Young's double slit, diffraction grating, single slit
 * Young: β = λD/d, y_n = nλD/d (bright), (2n-1)λD/(2d) (dark)
 * Grating: d sin θ = n λ
 * Single slit: angular width ≈ 2λ/a
 */
(function () {
    'use strict';

    var toRad = Math.PI / 180;
    var lambdaToM = { 'm': 1, 'mm': 1e-3, 'nm': 1e-9, 'Å': 1e-10 };
    var distToM = { 'm': 1, 'cm': 0.01, 'mm': 0.001 };

    function getActiveTab() {
        var t = document.querySelector('.wo-tab.active');
        return t ? t.getAttribute('data-tab') : 'young';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && x !== 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesYoung() {
        var lambda = parseFloat(document.getElementById('wo-lambda').value);
        var lambdaU = document.getElementById('wo-lambda-unit').value || 'nm';
        var D = parseFloat(document.getElementById('wo-D').value);
        var DU = document.getElementById('wo-D-unit').value || 'm';
        var d = parseFloat(document.getElementById('wo-d').value);
        var dU = document.getElementById('wo-d-unit').value || 'mm';
        var lambdaM = lambda * (lambdaToM[lambdaU] || 1e-9);
        var Dm = D * (distToM[DU] || 1);
        var dm = d * (distToM[dU] || 0.001);
        if (isNaN(lambda) || isNaN(D) || isNaN(d) || dm <= 0 || Dm <= 0 || lambdaM <= 0) return { lambda: lambdaM, D: Dm, d: dm, beta: NaN };
        var beta = (lambdaM * Dm) / dm;
        return { lambda: lambdaM, D: Dm, d: dm, beta: beta };
    }

    function getValuesYoungPosition() {
        var lambda = parseFloat(document.getElementById('wo-lambda-pos').value);
        var lambdaU = document.getElementById('wo-lambda-pos-unit').value || 'nm';
        var D = parseFloat(document.getElementById('wo-D-pos').value);
        var DU = document.getElementById('wo-D-pos-unit').value || 'm';
        var d = parseFloat(document.getElementById('wo-d-pos').value);
        var dU = document.getElementById('wo-d-pos-unit').value || 'mm';
        var n = parseFloat(document.getElementById('wo-n-fringe').value);
        var type = (document.querySelector('.wo-fringe-type:checked') || {}).value || 'bright';
        var lambdaM = lambda * (lambdaToM[lambdaU] || 1e-9);
        var Dm = D * (distToM[DU] || 1);
        var dm = d * (distToM[dU] || 0.001);
        if (isNaN(lambda) || isNaN(D) || isNaN(d) || isNaN(n) || dm <= 0 || Dm <= 0) return { lambda: lambdaM, D: Dm, d: dm, n: n, type: type, y: NaN };
        var y = type === 'bright' ? (n * lambdaM * Dm) / dm : ((2 * n - 1) * lambdaM * Dm) / (2 * dm);
        return { lambda: lambdaM, D: Dm, d: dm, n: n, type: type, y: y };
    }

    function getValuesGrating() {
        var d = parseFloat(document.getElementById('wo-grating-d').value);
        var dU = document.getElementById('wo-grating-d-unit').value || 'm';
        var n = parseFloat(document.getElementById('wo-grating-n').value);
        var lambda = parseFloat(document.getElementById('wo-grating-lambda').value);
        var lambdaU = document.getElementById('wo-grating-lambda-unit').value || 'nm';
        var thetaDeg = parseFloat(document.getElementById('wo-grating-theta').value);
        var solveBtn = document.querySelector('.wo-grating-solve.active');
        var solveFor = (solveBtn && solveBtn.getAttribute('data-var')) ? solveBtn.getAttribute('data-var') : 'theta';
        var dToM = { 'm': 1, 'cm': 0.01, 'mm': 1e-3, 'μm': 1e-6, 'nm': 1e-9 };
        var dm = d * (dToM[dU] || 1);
        var lambdaM = lambda * (lambdaToM[lambdaU] || 1e-9);
        var thetaRad = thetaDeg * toRad;
        var result = { d: dm, n: n, lambda: lambdaM, theta: thetaRad, thetaDeg: thetaDeg, solveFor: solveFor };
        if (solveFor === 'theta' && !isNaN(dm) && !isNaN(n) && !isNaN(lambdaM) && dm > 0 && lambdaM > 0) {
            var sinT = (n * lambdaM) / dm;
            if (sinT <= 1 && sinT >= -1) result.theta = Math.asin(sinT); result.thetaDeg = result.theta / toRad;
        } else if (solveFor === 'lambda' && !isNaN(dm) && !isNaN(n) && !isNaN(thetaRad)) {
            result.lambda = (dm * Math.sin(thetaRad)) / n;
        } else if (solveFor === 'n' && !isNaN(dm) && !isNaN(lambdaM) && !isNaN(thetaRad) && lambdaM > 0) {
            result.n = (dm * Math.sin(thetaRad)) / lambdaM;
        } else if (solveFor === 'd' && !isNaN(n) && !isNaN(lambdaM) && !isNaN(thetaRad) && n !== 0) {
            result.d = (n * lambdaM) / Math.sin(thetaRad);
        }
        return result;
    }

    function getValuesSingleSlit() {
        var lambda = parseFloat(document.getElementById('wo-slit-lambda').value);
        var lambdaU = document.getElementById('wo-slit-lambda-unit').value || 'nm';
        var a = parseFloat(document.getElementById('wo-slit-a').value);
        var aU = document.getElementById('wo-slit-a-unit').value || 'mm';
        var lambdaM = lambda * (lambdaToM[lambdaU] || 1e-9);
        var am = a * (distToM[aU] || 0.001);
        if (isNaN(lambda) || isNaN(a) || am <= 0 || lambdaM <= 0) return { lambda: lambdaM, a: am, angWidth: NaN, angWidthDeg: NaN };
        var angWidthRad = 2 * lambdaM / am;
        var angWidthDeg = angWidthRad / toRad;
        return { lambda: lambdaM, a: am, angWidth: angWidthRad, angWidthDeg: angWidthDeg };
    }

    function buildStepsYoung(data) {
        return [{ title: "Young's double slit – fringe width", formula: 'β = λ D / d', calc: 'β = ' + formatNum(data.lambda) + ' × ' + formatNum(data.D) + ' / ' + formatNum(data.d) + ' = ' + formatNum(data.beta) + ' m' }];
    }

    function buildStepsYoungPosition(data) {
        var formula = data.type === 'bright' ? 'y_n = n λ D / d' : 'y_n = (2n−1) λ D / (2d)';
        var calc = 'y = ' + formatNum(data.y) + ' m';
        return [{ title: "Position of " + (data.type === 'bright' ? 'nth bright' : 'nth dark') + " fringe", formula: formula, calc: calc }];
    }

    function buildStepsGrating(data) {
        var s = data.solveFor;
        var steps = [];
        if (s === 'theta') steps.push({ title: 'Diffraction grating', formula: 'd sin θ = n λ ⇒ θ = arcsin(nλ/d)', calc: 'θ = ' + formatNum(data.thetaDeg) + '°' });
        else if (s === 'lambda') steps.push({ title: 'Diffraction grating', formula: 'λ = d sin θ / n', calc: 'λ = ' + formatNum(data.lambda) + ' m' });
        else if (s === 'n') steps.push({ title: 'Diffraction grating', formula: 'n = d sin θ / λ', calc: 'n = ' + formatNum(data.n) + ' (order)' });
        else steps.push({ title: 'Diffraction grating', formula: 'd = n λ / sin θ', calc: 'd = ' + formatNum(data.d) + ' m' });
        return steps;
    }

    function buildStepsSingleSlit(data) {
        return [{ title: 'Single slit – angular width of central maximum', formula: 'Angular width ≈ 2λ/a', calc: '2λ/a = ' + formatNum(data.angWidth) + ' rad = ' + formatNum(data.angWidthDeg) + '°' }];
    }

    function renderSteps(steps) {
        var container = document.getElementById('wo-steps-body');
        if (!container) return;
        container.innerHTML = '';
        steps.forEach(function (s, i) {
            var div = document.createElement('div');
            div.className = 'step-item';
            div.innerHTML = '<div class="step-title"><span class="step-number">' + (i + 1) + '</span>' + s.title + '</div>' +
                (s.formula ? '<div class="step-formula">' + s.formula + '</div>' : '') +
                (s.calc ? '<div class="step-calc">' + s.calc + '</div>' : '');
            container.appendChild(div);
        });
    }

    function drawWaveOpticsViz(tab, data) {
        var c = document.getElementById('wo-viz-container');
        var can = document.getElementById('wo-viz-canvas');
        var placeholder = document.getElementById('wo-viz-placeholder');
        if (!c || !can) return;
        var ctx = can.getContext('2d');
        if (!ctx) return;
        var w = c.offsetWidth || 600;
        var h = c.offsetHeight || 220;
        can.width = w;
        can.height = h;
        ctx.clearRect(0, 0, w, h);

        if (tab === 'young' && data && !isNaN(data.beta)) {
            drawYoungViz(ctx, w, h, data.beta, data.d, data.D);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'grating' && data && !isNaN(data.theta)) {
            drawGratingViz(ctx, w, h, data.thetaDeg, data.n);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'singleslit' && data && !isNaN(data.angWidthDeg)) {
            drawSingleSlitViz(ctx, w, h, data.angWidthDeg);
            if (placeholder) placeholder.style.display = 'none';
        } else {
            if (placeholder) placeholder.style.display = 'block';
        }
    }

    function drawYoungViz(ctx, w, h, beta, d, D) {
        var cy = h / 2;
        var scale = Math.min(w / (6 * Math.max(beta, 1e-6)), 80);
        var nFringes = 5;
        ctx.strokeStyle = '#6366f1';
        ctx.lineWidth = 2;
        for (var i = -nFringes; i <= nFringes; i++) {
            var x = w / 2 + i * beta * scale;
            if (x >= 0 && x <= w) {
                ctx.beginPath();
                ctx.moveTo(x, 0);
                ctx.lineTo(x, h);
                ctx.stroke();
            }
        }
        ctx.fillStyle = '#0f172a';
        ctx.font = '12px Inter';
        ctx.textAlign = 'center';
        ctx.fillText('β = ' + formatNum(beta * 1000, 2) + ' mm', w / 2, h - 12);
    }

    function drawGratingViz(ctx, w, h, thetaDeg, n) {
        var cx = w / 2;
        var cy = h / 2;
        var len = 60;
        var thetaRad = thetaDeg * toRad;
        var dx = len * Math.sin(thetaRad);
        var dy = -len * Math.cos(thetaRad);
        ctx.strokeStyle = 'rgba(0,0,0,0.3)';
        ctx.beginPath();
        ctx.moveTo(cx - 80, cy);
        ctx.lineTo(cx + 80, cy);
        ctx.stroke();
        ctx.strokeStyle = '#8b5cf6';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + dx, cy + dy);
        ctx.stroke();
        ctx.fillStyle = '#0f172a';
        ctx.fillText('θ = ' + formatNum(thetaDeg) + '°  (n = ' + formatNum(n) + ')', cx + dx / 2 + 20, cy + dy / 2);
    }

    function drawSingleSlitViz(ctx, w, h, angWidthDeg) {
        var cx = w / 2;
        var cy = h / 2;
        var halfAng = angWidthDeg / 2 * toRad;
        var len = 70;
        var dx1 = len * Math.sin(-halfAng);
        var dy1 = -len * Math.cos(-halfAng);
        var dx2 = len * Math.sin(halfAng);
        var dy2 = -len * Math.cos(halfAng);
        ctx.strokeStyle = 'rgba(0,0,0,0.3)';
        ctx.beginPath();
        ctx.moveTo(cx - 60, cy);
        ctx.lineTo(cx + 60, cy);
        ctx.stroke();
        ctx.strokeStyle = '#ec4899';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + dx1, cy + dy1);
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + dx2, cy + dy2);
        ctx.stroke();
        ctx.fillStyle = '#0f172a';
        ctx.fillText('Angular width ≈ ' + formatNum(angWidthDeg) + '°', cx, cy + 50);
    }

    function runWaveOptics() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'young') {
            data = getValuesYoung();
            resultEl = document.getElementById('wo-young-result');
            resultText = isNaN(data.beta) ? '—' : 'β = ' + formatNum(data.beta * 1000, 3) + ' mm';
            steps = buildStepsYoung(data);
        } else if (tab === 'youngpos') {
            data = getValuesYoungPosition();
            resultEl = document.getElementById('wo-youngpos-result');
            resultText = isNaN(data.y) ? '—' : 'y = ' + formatNum(data.y * 1000, 3) + ' mm';
            steps = buildStepsYoungPosition(data);
        } else if (tab === 'grating') {
            data = getValuesGrating();
            resultEl = document.getElementById('wo-grating-result');
            if (data.solveFor === 'theta') resultText = 'θ = ' + (isNaN(data.thetaDeg) ? '—' : formatNum(data.thetaDeg) + '°');
            else if (data.solveFor === 'lambda') resultText = 'λ = ' + formatNum(data.lambda * 1e9, 2) + ' nm';
            else if (data.solveFor === 'n') resultText = 'n = ' + formatNum(data.n, 2);
            else resultText = 'd = ' + formatNum(data.d * 1e6, 3) + ' μm';
            steps = buildStepsGrating(data);
        } else if (tab === 'singleslit') {
            data = getValuesSingleSlit();
            resultEl = document.getElementById('wo-singleslit-result');
            resultText = isNaN(data.angWidthDeg) ? '—' : formatNum(data.angWidthDeg, 3) + '°';
            steps = buildStepsSingleSlit(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps || []);
        drawWaveOpticsViz(tab, data);
    }

    function setGratingSolve(variable) {
        document.querySelectorAll('.wo-grating-solve').forEach(function (b) { b.classList.toggle('active', b.getAttribute('data-var') === variable); });
        ['theta', 'lambda', 'n', 'd'].forEach(function (v) {
            var el = document.getElementById('wo-grating-section-' + v);
            if (el) el.style.display = v === variable ? 'none' : 'block';
        });
        runWaveOptics();
    }

    function switchWOTab(tabId, btn) {
        document.querySelectorAll('.wo-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.wo-panel').forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.wo-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-wo-' + tabId);
        if (panel) panel.classList.add('active');
        runWaveOptics();
    }

    function toggleWOSteps() {
        var body = document.getElementById('wo-steps-body');
        var toggle = document.getElementById('wo-steps-toggle');
        if (body && toggle) {
            body.classList.toggle('collapsed');
            toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        setGratingSolve('theta');
        runWaveOptics();
        document.querySelectorAll('.wo-number-input').forEach(function (inp) { inp.addEventListener('input', runWaveOptics); });
        document.querySelectorAll('.wo-unit-select').forEach(function (sel) { sel.addEventListener('change', runWaveOptics); });
        document.querySelectorAll('.wo-fringe-type').forEach(function (r) { r.addEventListener('change', runWaveOptics); });
        window.addEventListener('resize', function () {
            var tab = getActiveTab();
            var data = tab === 'young' ? getValuesYoung() : tab === 'youngpos' ? getValuesYoungPosition() : tab === 'grating' ? getValuesGrating() : tab === 'singleslit' ? getValuesSingleSlit() : null;
            drawWaveOpticsViz(tab, data);
        });
    });

    window.runWaveOptics = runWaveOptics;
    window.switchWOTab = switchWOTab;
    window.setGratingSolve = setGratingSolve;
    window.toggleWOSteps = toggleWOSteps;
})();
