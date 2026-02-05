/**
 * Refraction of Light - Snell's law, apparent depth, slab shift, lateral shift, critical angle, TIR
 */
(function () {
    'use strict';

    var toRad = Math.PI / 180;

    function getActiveTab() {
        var t = document.querySelector('.refr-tab.active');
        return t ? t.getAttribute('data-tab') : 'snell';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && x !== 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesSnell() {
        var n1 = parseFloat(document.getElementById('refr-n1').value);
        var n2 = parseFloat(document.getElementById('refr-n2').value);
        var iDeg = parseFloat(document.getElementById('refr-i').value);
        var rDeg = parseFloat(document.getElementById('refr-r').value);
        var solveBtn = document.querySelector('.refr-solve-btn.active');
        var solveFor = (solveBtn && solveBtn.getAttribute('data-var')) ? solveBtn.getAttribute('data-var') : 'r';
        if (isNaN(n1)) n1 = 1;
        if (isNaN(n2)) n2 = 1.33;
        var iRad = (iDeg === undefined || isNaN(iDeg)) ? NaN : iDeg * toRad;
        var rRad = (rDeg === undefined || isNaN(rDeg)) ? NaN : rDeg * toRad;
        if (solveFor === 'r' && !isNaN(n1) && !isNaN(n2) && !isNaN(iRad)) {
            var sinR = (n1 / n2) * Math.sin(iRad);
            if (sinR <= 1 && sinR >= -1) rRad = Math.asin(sinR);
            else rRad = NaN;
        } else if (solveFor === 'i' && !isNaN(n1) && !isNaN(n2) && !isNaN(rRad)) {
            var sinI = (n2 / n1) * Math.sin(rRad);
            if (sinI <= 1 && sinI >= -1) iRad = Math.asin(sinI);
            else iRad = NaN;
        } else if (solveFor === 'n2' && !isNaN(n1) && !isNaN(iRad) && !isNaN(rRad)) {
            n2 = n1 * Math.sin(iRad) / Math.sin(rRad);
        }
        return { n1: n1, n2: n2, i: iRad, r: rRad, iDeg: iRad / toRad, rDeg: rRad / toRad, solveFor: solveFor };
    }

    function getValuesApparentDepth() {
        var d = parseFloat(document.getElementById('refr-d').value);
        var n = parseFloat(document.getElementById('refr-n-depth').value);
        if (isNaN(d) || isNaN(n) || n <= 0) return { d: d, n: n, dPrime: NaN };
        var dPrime = d / n;
        return { d: d, n: n, dPrime: dPrime };
    }

    function getValuesSlabShift() {
        var t = parseFloat(document.getElementById('refr-t').value);
        var n = parseFloat(document.getElementById('refr-n-slab').value);
        if (isNaN(t) || isNaN(n) || n <= 0) return { t: t, n: n, shift: NaN };
        var shift = t * (1 - 1 / n);
        return { t: t, n: n, shift: shift };
    }

    function getValuesLateralShift() {
        var t = parseFloat(document.getElementById('refr-t-lat').value);
        var iDeg = parseFloat(document.getElementById('refr-i-lat').value);
        var n = parseFloat(document.getElementById('refr-n-lat').value);
        if (isNaN(t) || isNaN(iDeg) || isNaN(n) || n <= 0) return { t: t, i: iDeg * toRad, r: NaN, shift: NaN };
        var iRad = iDeg * toRad;
        var sinR = Math.sin(iRad) / n;
        if (sinR > 1) return { t: t, i: iRad, r: NaN, shift: NaN, n: n };
        var rRad = Math.asin(sinR);
        var shift = t * Math.sin(iRad - rRad) / Math.cos(rRad);
        return { t: t, i: iRad, r: rRad, shift: shift, n: n };
    }

    function getValuesCritical() {
        var n = parseFloat(document.getElementById('refr-n-crit').value);
        if (isNaN(n) || n <= 0) return { n: n, C: NaN };
        if (n < 1) return { n: n, C: NaN };
        var sinC = 1 / n;
        var C = Math.asin(sinC) / toRad;
        return { n: n, C: C };
    }

    function buildStepsSnell(data) {
        var steps = [];
        if (data.solveFor === 'r') {
            steps.push({ title: "Snell's law", formula: 'n₁ sin i = n₂ sin r ⇒ sin r = (n₁/n₂) sin i', calc: 'sin r = (' + formatNum(data.n1) + '/' + formatNum(data.n2) + ') sin ' + formatNum(data.iDeg) + '° = ' + formatNum((data.n1 / data.n2) * Math.sin(data.i)) + ' ⇒ r = ' + formatNum(data.rDeg) + '°' });
        } else if (data.solveFor === 'i') {
            steps.push({ title: "Snell's law", formula: 'n₁ sin i = n₂ sin r ⇒ sin i = (n₂/n₁) sin r', calc: 'sin i = (' + formatNum(data.n2) + '/' + formatNum(data.n1) + ') sin ' + formatNum(data.rDeg) + '° ⇒ i = ' + formatNum(data.iDeg) + '°' });
        } else {
            steps.push({ title: "Snell's law", formula: 'n₂ = n₁ sin i / sin r', calc: 'n₂ = ' + formatNum(data.n1) + ' × sin ' + formatNum(data.iDeg) + '° / sin ' + formatNum(data.rDeg) + '° = ' + formatNum(data.n2) });
        }
        return steps;
    }

    function buildStepsApparentDepth(data) {
        var steps = [];
        steps.push({ title: 'Apparent depth', formula: "d' = d / n", calc: "d' = " + formatNum(data.d) + " / " + formatNum(data.n) + " = " + formatNum(data.dPrime) });
        return steps;
    }

    function buildStepsSlabShift(data) {
        var steps = [];
        steps.push({ title: 'Shift due to slab', formula: 'Shift = t (1 − 1/n)', calc: 'Shift = ' + formatNum(data.t) + ' × (1 − 1/' + formatNum(data.n) + ') = ' + formatNum(data.shift) });
        return steps;
    }

    function buildStepsLateralShift(data) {
        var steps = [];
        steps.push({ title: 'Lateral shift', formula: 'd = t sin(i − r) / cos r', calc: 'r = ' + formatNum(data.r / toRad) + '°, shift = ' + formatNum(data.shift) });
        return steps;
    }

    function buildStepsCritical(data) {
        var steps = [];
        steps.push({ title: 'Critical angle', formula: 'sin C = 1/n (denser to rarer, n₂ = 1)', calc: 'sin C = 1/' + formatNum(data.n) + ' ⇒ C = ' + formatNum(data.C) + '°' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('refr-steps-body');
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

    function drawRefrViz(tab, data) {
        var c = document.getElementById('refr-viz-container');
        var can = document.getElementById('refr-viz-canvas');
        var placeholder = document.getElementById('refr-viz-placeholder');
        if (!c || !can) return;
        var ctx = can.getContext('2d');
        if (!ctx) return;
        var w = c.offsetWidth || 600;
        var h = c.offsetHeight || 260;
        can.width = w;
        can.height = h;
        ctx.clearRect(0, 0, w, h);

        if (tab === 'snell' && data && !isNaN(data.i) && !isNaN(data.r)) {
            drawSnellViz(ctx, w, h, data.n1, data.n2, data.i, data.r);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'apparent' && data && !isNaN(data.dPrime)) {
            drawApparentDepthViz(ctx, w, h, data.d, data.n, data.dPrime);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'slab' && data && !isNaN(data.shift)) {
            drawSlabViz(ctx, w, h, data.t, data.n, data.shift);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'lateral' && data && !isNaN(data.shift)) {
            drawLateralViz(ctx, w, h, data.t, data.i, data.r, data.shift, data.n);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'critical' && data && !isNaN(data.C)) {
            drawCriticalViz(ctx, w, h, data.n, data.C);
            if (placeholder) placeholder.style.display = 'none';
        } else {
            if (placeholder) placeholder.style.display = 'block';
        }
    }

    function drawSnellViz(ctx, w, h, n1, n2, iRad, rRad) {
        var cy = h / 2;
        var yInterface = cy;
        ctx.fillStyle = 'rgba(14,165,233,0.15)';
        ctx.fillRect(0, 0, w, yInterface);
        ctx.fillStyle = 'rgba(34,197,94,0.15)';
        ctx.fillRect(0, yInterface, w, h - yInterface);
        ctx.strokeStyle = 'rgba(0,0,0,0.4)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, yInterface);
        ctx.lineTo(w, yInterface);
        ctx.stroke();
        var len = Math.min(w * 0.35, 120);
        var xHit = w / 2;
        var incEndX = xHit - len * Math.sin(iRad);
        var incEndY = yInterface - len * Math.cos(iRad);
        var refEndX = xHit + len * Math.sin(rRad);
        var refEndY = yInterface + len * Math.cos(rRad);
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.moveTo(incEndX, incEndY);
        ctx.lineTo(xHit, yInterface);
        ctx.stroke();
        ctx.strokeStyle = '#059669';
        ctx.beginPath();
        ctx.moveTo(xHit, yInterface);
        ctx.lineTo(refEndX, refEndY);
        ctx.stroke();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.textAlign = 'center';
        ctx.fillText('n₁ = ' + formatNum(n1), w / 4, 20);
        ctx.fillText('n₂ = ' + formatNum(n2), w * 3 / 4, h - 10);
        ctx.fillText('i', incEndX - 18, incEndY + 4);
        ctx.fillText('r', refEndX + 18, refEndY - 4);
    }

    function drawApparentDepthViz(ctx, w, h, d, n, dPrime) {
        var cy = h / 2;
        var scale = 3;
        var ySurface = cy - 30;
        var realY = ySurface + d * scale;
        var apparentY = ySurface + dPrime * scale;
        ctx.fillStyle = 'rgba(14,165,233,0.2)';
        ctx.fillRect(0, 0, w, ySurface);
        ctx.fillStyle = 'rgba(34,197,94,0.2)';
        ctx.fillRect(0, ySurface, w, h - ySurface);
        ctx.strokeStyle = 'rgba(0,0,0,0.5)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, ySurface);
        ctx.lineTo(w, ySurface);
        ctx.stroke();
        var xObj = w / 2;
        ctx.fillStyle = '#dc2626';
        ctx.beginPath();
        ctx.arc(xObj, realY, 8, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = 'rgba(220,38,38,0.6)';
        ctx.setLineDash([4, 4]);
        ctx.beginPath();
        ctx.moveTo(xObj, realY);
        ctx.lineTo(xObj, apparentY);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.fillStyle = '#059669';
        ctx.beginPath();
        ctx.arc(xObj, apparentY, 6, 0, Math.PI * 2);
        ctx.fill();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText("Real d = " + formatNum(d), xObj + 25, realY + 4);
        ctx.fillText("d' = d/n = " + formatNum(dPrime), xObj + 25, apparentY + 4);
    }

    function drawSlabViz(ctx, w, h, t, n, shift) {
        var cy = h / 2;
        var scale = 4;
        var slabH = t * scale;
        if (slabH > h - 60) slabH = h - 60;
        var y1 = cy - slabH / 2;
        var y2 = cy + slabH / 2;
        ctx.fillStyle = 'rgba(34,197,94,0.25)';
        ctx.fillRect(0, y1, w, slabH);
        ctx.strokeStyle = 'rgba(0,0,0,0.5)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, y1);
        ctx.lineTo(w, y1);
        ctx.moveTo(0, y2);
        ctx.lineTo(w, y2);
        ctx.stroke();
        var shiftPx = shift * scale;
        if (Math.abs(shiftPx) > w / 2 - 40) shiftPx = (shiftPx > 0 ? 1 : -1) * (w / 2 - 40);
        var x1 = w / 2 - 60;
        var x2 = w / 2 + 60 + shiftPx;
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 2;
        ctx.setLineDash([2, 2]);
        ctx.beginPath();
        ctx.moveTo(x1, y1 - 20);
        ctx.lineTo(w / 2, y1);
        ctx.lineTo(w / 2, y2);
        ctx.lineTo(x2, y2 + 20);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.strokeStyle = 'rgba(220,38,38,0.8)';
        ctx.beginPath();
        ctx.moveTo(w / 2, y1);
        ctx.lineTo(w / 2 + shiftPx, y1);
        ctx.stroke();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('t = ' + formatNum(t), w / 2 + 70, cy);
        ctx.fillText('shift = ' + formatNum(shift), w / 2 + shiftPx / 2, y1 - 8);
    }

    function drawLateralViz(ctx, w, h, t, iRad, rRad, shift, n) {
        var cy = h / 2;
        var scale = 3;
        var slabH = t * scale;
        if (slabH > h - 50) slabH = h - 50;
        var y1 = cy - slabH / 2;
        var y2 = cy + slabH / 2;
        ctx.fillStyle = 'rgba(34,197,94,0.2)';
        ctx.fillRect(0, y1, w, slabH);
        ctx.strokeStyle = 'rgba(0,0,0,0.5)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, y1);
        ctx.lineTo(w, y1);
        ctx.moveTo(0, y2);
        ctx.lineTo(w, y2);
        ctx.stroke();
        var len = 80;
        var xHit = w / 2;
        var topX = xHit - len * Math.sin(iRad);
        var topY = y1 - len * Math.cos(iRad);
        var botX = xHit + len * Math.sin(rRad);
        var botY = y2 + len * Math.cos(rRad);
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(topX, topY);
        ctx.lineTo(xHit, y1);
        ctx.lineTo(xHit + shift, y2);
        ctx.lineTo(botX + shift, botY);
        ctx.stroke();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('Lateral shift = ' + formatNum(shift), xHit + shift / 2, cy);
    }

    function drawCriticalViz(ctx, w, h, n, Cdeg) {
        var cy = h / 2;
        var Crad = Cdeg * toRad;
        var len = Math.min(w, h) * 0.4;
        var xC = w / 2;
        ctx.fillStyle = 'rgba(34,197,94,0.2)';
        ctx.fillRect(0, cy, w, h - cy);
        ctx.strokeStyle = 'rgba(0,0,0,0.5)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, cy);
        ctx.lineTo(w, cy);
        ctx.stroke();
        var rayX = xC + len * Math.sin(Crad);
        var rayY = cy - len * Math.cos(Crad);
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.moveTo(xC, cy);
        ctx.lineTo(rayX, rayY);
        ctx.stroke();
        ctx.font = '12px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.fillText('C = ' + formatNum(Cdeg) + '°', rayX + 25, rayY);
        ctx.fillText('sin C = 1/n', xC, cy - 30);
    }

    function runRefraction() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'snell') {
            data = getValuesSnell();
            resultEl = document.getElementById('refr-snell-result');
            if (data.solveFor === 'r') resultText = 'r = ' + (isNaN(data.rDeg) ? 'TIR or invalid' : formatNum(data.rDeg) + '°');
            else if (data.solveFor === 'i') resultText = 'i = ' + (isNaN(data.iDeg) ? '—' : formatNum(data.iDeg) + '°');
            else resultText = 'n₂ = ' + formatNum(data.n2);
            steps = buildStepsSnell(data);
        } else if (tab === 'apparent') {
            data = getValuesApparentDepth();
            resultEl = document.getElementById('refr-apparent-result');
            resultText = isNaN(data.dPrime) ? '—' : "d' = " + formatNum(data.dPrime);
            steps = buildStepsApparentDepth(data);
        } else if (tab === 'slab') {
            data = getValuesSlabShift();
            resultEl = document.getElementById('refr-slab-result');
            resultText = isNaN(data.shift) ? '—' : 'Shift = ' + formatNum(data.shift);
            steps = buildStepsSlabShift(data);
        } else if (tab === 'lateral') {
            data = getValuesLateralShift();
            resultEl = document.getElementById('refr-lateral-result');
            resultText = isNaN(data.shift) ? 'TIR or invalid' : 'Lateral shift = ' + formatNum(data.shift);
            steps = buildStepsLateralShift(data);
        } else if (tab === 'critical') {
            data = getValuesCritical();
            resultEl = document.getElementById('refr-critical-result');
            resultText = isNaN(data.C) ? '—' : 'C = ' + formatNum(data.C) + '°';
            steps = buildStepsCritical(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps || []);
        drawRefrViz(tab, data);
    }

    function setRefrSolveFor(variable) {
        var btns = document.querySelectorAll('.refr-solve-btn[data-var]');
        if (btns.length) btns.forEach(function (b) { b.classList.toggle('active', b.getAttribute('data-var') === variable); });
        var n2Sec = document.getElementById('refr-n2-section');
        var iSec = document.getElementById('refr-i-section');
        var rSec = document.getElementById('refr-r-section');
        if (n2Sec) n2Sec.style.display = variable === 'n2' ? 'none' : 'block';
        if (iSec) iSec.style.display = variable === 'i' ? 'none' : 'block';
        if (rSec) rSec.style.display = variable === 'r' ? 'none' : 'block';
        runRefraction();
    }

    function switchRefrTab(tabId, btn) {
        document.querySelectorAll('.refr-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.refr-panel').forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.refr-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-refr-' + tabId);
        if (panel) panel.classList.add('active');
        runRefraction();
    }

    function toggleRefrSteps() {
        var body = document.getElementById('refr-steps-body');
        var toggle = document.getElementById('refr-steps-toggle');
        if (body && toggle) {
            body.classList.toggle('collapsed');
            toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        runRefraction();
        document.querySelectorAll('.refr-number-input').forEach(function (inp) { inp.addEventListener('input', runRefraction); });
        document.querySelectorAll('.refr-unit-select').forEach(function (sel) { sel.addEventListener('change', runRefraction); });
        window.addEventListener('resize', function () {
            var tab = getActiveTab();
            var data = tab === 'snell' ? getValuesSnell() : tab === 'apparent' ? getValuesApparentDepth() : tab === 'slab' ? getValuesSlabShift() : tab === 'lateral' ? getValuesLateralShift() : tab === 'critical' ? getValuesCritical() : null;
            drawRefrViz(tab, data);
        });
    });

    window.runRefraction = runRefraction;
    window.switchRefrTab = switchRefrTab;
    window.setRefrSolveFor = setRefrSolveFor;
    window.toggleRefrSteps = toggleRefrSteps;
})();
