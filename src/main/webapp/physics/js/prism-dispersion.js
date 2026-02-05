/**
 * Prism & Dispersion - angle of deviation, minimum deviation, n from prism, dispersion, dispersive power, achromatic
 */
(function () {
    'use strict';

    var toRad = Math.PI / 180;

    function getActiveTab() {
        var t = document.querySelector('.prism-tab.active');
        return t ? t.getAttribute('data-tab') : 'deviation';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && x !== 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesDeviation() {
        var i = parseFloat(document.getElementById('prism-i').value);
        var e = parseFloat(document.getElementById('prism-e').value);
        var A = parseFloat(document.getElementById('prism-A').value);
        if (isNaN(i) || isNaN(e) || isNaN(A)) return { i: i, e: e, A: A, delta: NaN };
        var delta = i + e - A;
        return { i: i, e: e, A: A, delta: delta };
    }

    function getValuesMinDeviation() {
        var i = parseFloat(document.getElementById('prism-i-min').value);
        var A = parseFloat(document.getElementById('prism-A-min').value);
        if (isNaN(i) || isNaN(A)) return { i: i, A: A, deltaM: NaN };
        var deltaM = 2 * i - A;
        return { i: i, A: A, deltaM: deltaM };
    }

    function getValuesNFromPrism() {
        var A = parseFloat(document.getElementById('prism-A-n').value);
        var deltaM = parseFloat(document.getElementById('prism-deltaM').value);
        if (isNaN(A) || isNaN(deltaM) || A <= 0) return { A: A, deltaM: deltaM, n: NaN };
        var Arad = A * toRad;
        var drad = deltaM * toRad;
        var n = Math.sin((Arad + drad) / 2) / Math.sin(Arad / 2);
        return { A: A, deltaM: deltaM, n: n };
    }

    function getValuesDispersion() {
        var nv = parseFloat(document.getElementById('prism-nv').value);
        var nr = parseFloat(document.getElementById('prism-nr').value);
        var A = parseFloat(document.getElementById('prism-A-disp').value);
        if (isNaN(nv) || isNaN(nr) || isNaN(A)) return { nv: nv, nr: nr, A: A, angDisp: NaN };
        var angDisp = (nv - nr) * A;
        return { nv: nv, nr: nr, A: A, angDisp: angDisp };
    }

    function getValuesDispersivePower() {
        var nv = parseFloat(document.getElementById('prism-nv-om').value);
        var nr = parseFloat(document.getElementById('prism-nr-om').value);
        var nMean = parseFloat(document.getElementById('prism-n-mean').value);
        if (isNaN(nv) || isNaN(nr)) return { nv: nv, nr: nr, n: nMean, omega: NaN };
        var n = isNaN(nMean) || nMean <= 0 ? (nv + nr) / 2 : nMean;
        if (n <= 1) return { nv: nv, nr: nr, n: n, omega: NaN };
        var omega = (nv - nr) / (n - 1);
        return { nv: nv, nr: nr, n: n, omega: omega };
    }

    function getValuesAchromatic() {
        var om1 = parseFloat(document.getElementById('prism-om1').value);
        var f1 = parseFloat(document.getElementById('prism-f1').value);
        var om2 = parseFloat(document.getElementById('prism-om2').value);
        var f2 = parseFloat(document.getElementById('prism-f2').value);
        var solveBtn = document.querySelector('.prism-solve-btn.active');
        var solveFor = (solveBtn && solveBtn.getAttribute('data-var')) ? solveBtn.getAttribute('data-var') : 'f2';
        if (solveFor === 'f2' && !isNaN(om1) && !isNaN(f1) && !isNaN(om2) && om2 !== 0) {
            f2 = -(om1 / om2) * f1;
        } else if (solveFor === 'f1' && !isNaN(om1) && !isNaN(om2) && !isNaN(f2) && om1 !== 0) {
            f1 = -(om2 / om1) * f2;
        }
        return { om1: om1, f1: f1, om2: om2, f2: f2, solveFor: solveFor };
    }

    function buildStepsDeviation(data) {
        return [{ title: 'Angle of deviation', formula: 'δ = i + e − A', calc: 'δ = ' + formatNum(data.i) + ' + ' + formatNum(data.e) + ' − ' + formatNum(data.A) + ' = ' + formatNum(data.delta) + '°' }];
    }

    function buildStepsMinDeviation(data) {
        return [{ title: 'Minimum deviation', formula: 'δ_m = 2i − A (when i = e)', calc: 'δ_m = 2×' + formatNum(data.i) + ' − ' + formatNum(data.A) + ' = ' + formatNum(data.deltaM) + '°' }];
    }

    function buildStepsNFromPrism(data) {
        return [{ title: 'Refractive index from prism', formula: 'n = sin((A + δ_m)/2) / sin(A/2)', calc: 'n = sin(' + formatNum((data.A + data.deltaM) / 2) + '°) / sin(' + formatNum(data.A / 2) + '°) = ' + formatNum(data.n) }];
    }

    function buildStepsDispersion(data) {
        return [{ title: 'Angular dispersion', formula: 'δ_v − δ_r = (n_v − n_r) A', calc: '(' + formatNum(data.nv) + ' − ' + formatNum(data.nr) + ') × ' + formatNum(data.A) + '° = ' + formatNum(data.angDisp) + '°' }];
    }

    function buildStepsDispersivePower(data) {
        return [{ title: 'Dispersive power', formula: 'ω = (n_v − n_r) / (n − 1)', calc: 'ω = (' + formatNum(data.nv) + ' − ' + formatNum(data.nr) + ') / (' + formatNum(data.n) + ' − 1) = ' + formatNum(data.omega) }];
    }

    function buildStepsAchromatic(data) {
        var s = data.solveFor;
        if (s === 'f2') {
            return [{ title: 'Achromatic combination', formula: 'ω₁/f₁ + ω₂/f₂ = 0 ⇒ f₂ = −(ω₁/ω₂) f₁', calc: 'f₂ = −(' + formatNum(data.om1) + '/' + formatNum(data.om2) + ') × ' + formatNum(data.f1) + ' = ' + formatNum(data.f2) + ' cm' }];
        }
        return [{ title: 'Achromatic combination', formula: 'ω₁/f₁ + ω₂/f₂ = 0 ⇒ f₁ = −(ω₂/ω₁) f₂', calc: 'f₁ = ' + formatNum(data.f1) + ' cm' }];
    }

    function renderSteps(steps) {
        var container = document.getElementById('prism-steps-body');
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

    function drawPrismViz(tab, data) {
        var c = document.getElementById('prism-viz-container');
        var can = document.getElementById('prism-viz-canvas');
        var placeholder = document.getElementById('prism-viz-placeholder');
        if (!c || !can) return;
        var ctx = can.getContext('2d');
        if (!ctx) return;
        var w = c.offsetWidth || 600;
        var h = c.offsetHeight || 240;
        can.width = w;
        can.height = h;
        ctx.clearRect(0, 0, w, h);

        if (tab === 'deviation' && data && !isNaN(data.delta)) {
            drawDeviationViz(ctx, w, h, data.A, data.i, data.e, data.delta);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'mindeviation' && data && !isNaN(data.deltaM)) {
            drawMinDeviationViz(ctx, w, h, data.A, data.deltaM);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'nfromprism' && data && !isNaN(data.n)) {
            drawNFromPrismViz(ctx, w, h, data.A, data.deltaM, data.n);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'dispersion' && data && !isNaN(data.angDisp)) {
            drawDispersionViz(ctx, w, h, data.A, data.nv, data.nr, data.angDisp);
            if (placeholder) placeholder.style.display = 'none';
        } else {
            if (placeholder) placeholder.style.display = 'block';
        }
    }

    function drawDeviationViz(ctx, w, h, A, i, e, delta) {
        var cx = w / 2;
        var cy = h / 2;
        var toRad = Math.PI / 180;
        var size = Math.min(w, h) * 0.35;
        var Arad = A * toRad;
        var irad = i * toRad;
        var erad = e * toRad;
        var top = [cx - size * Math.sin(Arad / 2), cy - size * Math.cos(Arad / 2)];
        var left = [cx + size * Math.sin(Arad / 2), cy + size * Math.cos(Arad / 2)];
        var right = [cx, cy + size];
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(top[0], top[1]);
        ctx.lineTo(left[0], left[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.closePath();
        ctx.stroke();
        var inLen = 90;
        var inX = cx - inLen * Math.sin(irad);
        var inY = cy - size - inLen * Math.cos(irad);
        ctx.strokeStyle = '#0284c7';
        ctx.beginPath();
        ctx.moveTo(inX, inY);
        ctx.lineTo(top[0], top[1]);
        ctx.stroke();
        var outLen = 80;
        var outX = right[0] + outLen * Math.sin(erad);
        var outY = right[1] - outLen * Math.cos(erad);
        ctx.beginPath();
        ctx.moveTo(right[0], right[1]);
        ctx.lineTo(outX, outY);
        ctx.stroke();
        ctx.font = '12px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('A = ' + formatNum(A) + '°', cx, cy + size + 25);
        ctx.fillText('δ = ' + formatNum(delta) + '°', cx + 50, cy - 20);
    }

    function drawMinDeviationViz(ctx, w, h, A, deltaM, n) {
        var cx = w / 2;
        var cy = h / 2;
        var toRad = Math.PI / 180;
        var size = Math.min(w, h) * 0.32;
        var Arad = A * toRad;
        var irad = (A + deltaM) / 2 * toRad;
        var top = [cx - size * Math.sin(Arad / 2), cy - size * Math.cos(Arad / 2)];
        var left = [cx + size * Math.sin(Arad / 2), cy + size * Math.cos(Arad / 2)];
        var right = [cx, cy + size];
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(top[0], top[1]);
        ctx.lineTo(left[0], left[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.closePath();
        ctx.stroke();
        var len = 75;
        var inX = cx - len * Math.sin(irad);
        var inY = cy - size - len * Math.cos(irad);
        var outX = right[0] + len * Math.sin(irad);
        var outY = right[1] - len * Math.cos(irad);
        ctx.strokeStyle = '#059669';
        ctx.beginPath();
        ctx.moveTo(inX, inY);
        ctx.lineTo(top[0], top[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.lineTo(outX, outY);
        ctx.stroke();
        ctx.font = '12px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('δ_m = ' + formatNum(deltaM) + '°', cx, cy - size/2 - 15);
        ctx.fillText('i = e', cx + 55, cy + 5);
    }

    function drawNFromPrismViz(ctx, w, h, A, deltaM, n) {
        drawMinDeviationViz(ctx, w, h, A, deltaM, n);
        var cx = w / 2;
        var cy = h / 2;
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('n = ' + formatNum(n, 3), cx, cy + 45);
    }

    function drawDispersionViz(ctx, w, h, A, nv, nr, angDisp) {
        var cx = w / 2;
        var cy = h / 2;
        var toRad = Math.PI / 180;
        var size = Math.min(w, h) * 0.3;
        var Arad = A * toRad;
        var top = [cx - size * Math.sin(Arad / 2), cy - size * Math.cos(Arad / 2)];
        var left = [cx + size * Math.sin(Arad / 2), cy + size * Math.cos(Arad / 2)];
        var right = [cx, cy + size];
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(top[0], top[1]);
        ctx.lineTo(left[0], left[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.closePath();
        ctx.stroke();
        ctx.strokeStyle = 'rgba(239,68,68,0.8)';
        ctx.beginPath();
        ctx.moveTo(cx - 70, cy - size - 30);
        ctx.lineTo(top[0], top[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.lineTo(cx + 65, right[1] - 25);
        ctx.stroke();
        ctx.strokeStyle = 'rgba(59,130,246,0.8)';
        ctx.beginPath();
        ctx.moveTo(cx - 55, cy - size - 45);
        ctx.lineTo(top[0], top[1]);
        ctx.lineTo(right[0], right[1]);
        ctx.lineTo(cx + 80, right[1] - 40);
        ctx.stroke();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('δ_v − δ_r = ' + formatNum(angDisp) + '°', cx, cy + size + 22);
    }

    function runPrism() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'deviation') {
            data = getValuesDeviation();
            resultEl = document.getElementById('prism-deviation-result');
            resultText = isNaN(data.delta) ? '—' : 'δ = ' + formatNum(data.delta) + '°';
            steps = buildStepsDeviation(data);
        } else if (tab === 'mindeviation') {
            data = getValuesMinDeviation();
            resultEl = document.getElementById('prism-mindeviation-result');
            resultText = isNaN(data.deltaM) ? '—' : 'δ_m = ' + formatNum(data.deltaM) + '°';
            steps = buildStepsMinDeviation(data);
        } else if (tab === 'nfromprism') {
            data = getValuesNFromPrism();
            resultEl = document.getElementById('prism-nfromprism-result');
            resultText = isNaN(data.n) ? '—' : 'n = ' + formatNum(data.n, 4);
            steps = buildStepsNFromPrism(data);
        } else if (tab === 'dispersion') {
            data = getValuesDispersion();
            resultEl = document.getElementById('prism-dispersion-result');
            resultText = isNaN(data.angDisp) ? '—' : 'δ_v − δ_r = ' + formatNum(data.angDisp) + '°';
            steps = buildStepsDispersion(data);
        } else if (tab === 'dispersivepower') {
            data = getValuesDispersivePower();
            resultEl = document.getElementById('prism-omega-result');
            resultText = isNaN(data.omega) ? '—' : 'ω = ' + formatNum(data.omega, 4);
            steps = buildStepsDispersivePower(data);
        } else if (tab === 'achromatic') {
            data = getValuesAchromatic();
            resultEl = document.getElementById('prism-achromatic-result');
            resultText = data.solveFor === 'f2' ? 'f₂ = ' + formatNum(data.f2) + ' cm' : 'f₁ = ' + formatNum(data.f1) + ' cm';
            steps = buildStepsAchromatic(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps || []);
        drawPrismViz(tab, data);
    }

    function setPrismSolveFor(variable) {
        var btns = document.querySelectorAll('.prism-solve-btn[data-var]');
        if (btns.length) btns.forEach(function (b) { b.classList.toggle('active', b.getAttribute('data-var') === variable); });
        var f1Sec = document.getElementById('prism-f1-section');
        var f2Sec = document.getElementById('prism-f2-section');
        if (f1Sec) f1Sec.style.display = variable === 'f1' ? 'none' : 'block';
        if (f2Sec) f2Sec.style.display = variable === 'f2' ? 'none' : 'block';
        runPrism();
    }

    function switchPrismTab(tabId, btn) {
        document.querySelectorAll('.prism-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.prism-panel').forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.prism-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-prism-' + tabId);
        if (panel) panel.classList.add('active');
        runPrism();
    }

    function togglePrismSteps() {
        var body = document.getElementById('prism-steps-body');
        var toggle = document.getElementById('prism-steps-toggle');
        if (body && toggle) {
            body.classList.toggle('collapsed');
            toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        runPrism();
        document.querySelectorAll('.prism-number-input').forEach(function (inp) { inp.addEventListener('input', runPrism); });
        window.addEventListener('resize', function () {
            var tab = getActiveTab();
            var data = tab === 'deviation' ? getValuesDeviation() : tab === 'mindeviation' ? getValuesMinDeviation() : tab === 'nfromprism' ? getValuesNFromPrism() : tab === 'dispersion' ? getValuesDispersion() : null;
            drawPrismViz(tab, data);
        });
    });

    window.runPrism = runPrism;
    window.switchPrismTab = switchPrismTab;
    window.setPrismSolveFor = setPrismSolveFor;
    window.togglePrismSteps = togglePrismSteps;
})();
