/**
 * Reflection of Light - Spherical mirrors
 * Mirror formula 1/f = 1/v + 1/u, f = R/2, m = -v/u, number of images (two mirrors at angle θ)
 * Sign convention (New Cartesian): u < 0 real object, v > 0 real image / v < 0 virtual, f < 0 concave / f > 0 convex
 */
(function () {
    'use strict';

    var lengthConv = { 'cm': 1, 'm': 100, 'mm': 0.1 };
    var canvas, ctx;

    function getActiveTab() {
        var t = document.querySelector('.mirror-tab.active');
        return t ? t.getAttribute('data-tab') : 'formula';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && x !== 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function formatLen(x) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        var ax = Math.abs(x);
        if (ax >= 100) return formatNum(x, 1) + ' cm';
        if (ax >= 1) return formatNum(x, 2) + ' cm';
        return formatNum(x, 3) + ' cm';
    }

    // Mirror formula: 1/f = 1/v + 1/u  =>  1/v = 1/f - 1/u,  1/u = 1/f - 1/v,  1/f = 1/v + 1/u
    function getValuesFormula() {
        var fRaw = parseFloat(document.getElementById('mirror-f').value);
        var uRaw = parseFloat(document.getElementById('mirror-u').value);
        var vRaw = parseFloat(document.getElementById('mirror-v').value);
        var unit = document.getElementById('mirror-unit').value || 'cm';
        var k = lengthConv[unit] || 1;
        var f = (fRaw === undefined || fRaw === '') ? NaN : fRaw * k;
        var u = (uRaw === undefined || uRaw === '') ? NaN : uRaw * k;
        var v = (vRaw === undefined || vRaw === '') ? NaN : vRaw * k;
        var solveBtn = document.querySelector('.mirror-solve-btn.active');
        var solveFor = (solveBtn && solveBtn.getAttribute('data-var')) ? solveBtn.getAttribute('data-var') : 'v';

        if (solveFor === 'v' && !isNaN(f) && !isNaN(u) && f !== 0 && u !== 0) {
            v = 1 / (1 / f - 1 / u);
        } else if (solveFor === 'u' && !isNaN(f) && !isNaN(v) && f !== 0 && v !== 0) {
            u = 1 / (1 / f - 1 / v);
        } else if (solveFor === 'f' && !isNaN(u) && !isNaN(v) && u !== 0 && v !== 0) {
            f = 1 / (1 / v + 1 / u);
        }

        var m = (u !== 0 && !isNaN(v) && !isNaN(u)) ? -v / u : NaN;
        return { f: f, u: u, v: v, m: m, solveFor: solveFor, unit: unit };
    }

    function getValuesRadius() {
        var R = parseFloat(document.getElementById('mirror-R').value);
        var Runit = document.getElementById('mirror-R-unit').value || 'cm';
        var k = lengthConv[Runit] || 1;
        R = (R === undefined || isNaN(R)) ? 0 : R * k;
        var f = R / 2;
        return { R: R, f: f, unit: Runit };
    }

    function getValuesMagnification() {
        var vRaw = parseFloat(document.getElementById('mirror-m-v').value);
        var uRaw = parseFloat(document.getElementById('mirror-m-u').value);
        var munit = document.getElementById('mirror-m-unit').value || 'cm';
        var k = lengthConv[munit] || 1;
        var v = (vRaw === undefined || isNaN(vRaw)) ? NaN : vRaw * k;
        var u = (uRaw === undefined || isNaN(uRaw)) ? NaN : uRaw * k;
        var m = (u !== 0 && !isNaN(v)) ? -v / u : NaN;
        return { v: v, u: u, m: m, unit: munit };
    }

    function getValuesNumImages() {
        var theta = parseFloat(document.getElementById('mirror-theta').value);
        if (isNaN(theta) || theta <= 0 || theta > 360) return { theta: theta, n: null, note: 'Enter angle θ between 0° and 360°' };
        var ratio = 360 / theta;
        var isInt = Math.abs(ratio - Math.round(ratio)) < 1e-6;
        var n;
        if (isInt) {
            var k = Math.round(ratio);
            n = k % 2 === 0 ? k - 1 : k - 1;  // common formula: n = 360/θ - 1 when 360/θ is integer
        } else {
            n = Math.floor(ratio);
        }
        var note = isInt ? '360/θ is integer; formula n = 360/θ − 1' : '360/θ not integer; number of images = floor(360/θ)';
        return { theta: theta, n: n, ratio: ratio, isInt: isInt, note: note };
    }

    function buildStepsFormula(data) {
        var steps = [];
        var s = data.solveFor;
        if (s === 'v') {
            steps.push({ title: 'Mirror formula', formula: '1/f = 1/v + 1/u ⇒ 1/v = 1/f − 1/u', calc: '1/v = 1/(' + formatNum(data.f) + ') − 1/(' + formatNum(data.u) + ') = ' + formatNum(1 / data.f - 1 / data.u) + ' ⇒ v = ' + formatNum(data.v) + ' cm' });
        } else if (s === 'u') {
            steps.push({ title: 'Mirror formula', formula: '1/f = 1/v + 1/u ⇒ 1/u = 1/f − 1/v', calc: '1/u = 1/(' + formatNum(data.f) + ') − 1/(' + formatNum(data.v) + ') ⇒ u = ' + formatNum(data.u) + ' cm' });
        } else {
            steps.push({ title: 'Mirror formula', formula: '1/f = 1/v + 1/u', calc: '1/f = 1/(' + formatNum(data.v) + ') + 1/(' + formatNum(data.u) + ') = ' + formatNum(1 / data.v + 1 / data.u) + ' ⇒ f = ' + formatNum(data.f) + ' cm' });
        }
        if (!isNaN(data.m)) steps.push({ title: 'Magnification', formula: 'm = −v/u', calc: 'm = −(' + formatNum(data.v) + ')/(' + formatNum(data.u) + ') = ' + formatNum(data.m) });
        return steps;
    }

    function buildStepsRadius(data) {
        var steps = [];
        steps.push({ title: 'Focal length from radius', formula: 'f = R/2', calc: 'f = ' + formatNum(data.R) + ' / 2 = ' + formatNum(data.f) + ' cm' });
        return steps;
    }

    function buildStepsMagnification(data) {
        var steps = [];
        steps.push({ title: 'Magnification (mirrors)', formula: 'm = hᵢ/hₒ = −v/u', calc: 'm = −(' + formatNum(data.v) + ')/(' + formatNum(data.u) + ') = ' + formatNum(data.m) });
        return steps;
    }

    function buildStepsNumImages(data) {
        var steps = [];
        if (data.n != null) {
            steps.push({ title: 'Number of images', formula: 'n = 360°/θ − 1 (when 360/θ is integer)', calc: '360/θ = ' + formatNum(data.ratio) + ', n = ' + data.n });
            steps.push({ title: 'Note', formula: '', calc: data.note });
        }
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('mirror-steps-body');
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

    function runMirrors() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'formula') {
            data = getValuesFormula();
            resultEl = document.getElementById('mirror-formula-result');
            if (data.solveFor === 'v') resultText = 'v = ' + formatLen(data.v);
            else if (data.solveFor === 'u') resultText = 'u = ' + formatLen(data.u);
            else resultText = 'f = ' + formatLen(data.f);
            if (!isNaN(data.m)) resultText += ', m = ' + formatNum(data.m, 3);
            steps = buildStepsFormula(data);
        } else if (tab === 'radius') {
            data = getValuesRadius();
            resultEl = document.getElementById('mirror-radius-result');
            resultText = 'f = ' + formatLen(data.f);
            steps = buildStepsRadius(data);
        } else if (tab === 'magnification') {
            data = getValuesMagnification();
            resultEl = document.getElementById('mirror-mag-result');
            resultText = isNaN(data.m) ? '—' : 'm = ' + formatNum(data.m, 4);
            steps = buildStepsMagnification(data);
        } else if (tab === 'numimages') {
            data = getValuesNumImages();
            resultEl = document.getElementById('mirror-numimages-result');
            resultText = data.n != null ? 'n = ' + data.n + ' images' : '—';
            steps = buildStepsNumImages(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps || []);
        drawMirrorViz(tab, data);
    }

    function drawMirrorViz(tab, data) {
        var c = document.getElementById('mirror-viz-container');
        var can = document.getElementById('mirror-viz-canvas');
        var placeholder = document.getElementById('mirror-viz-placeholder');
        if (!c || !can) return;
        canvas = can;
        ctx = canvas.getContext('2d');
        if (!ctx) return;
        var w = c.offsetWidth || 600;
        var h = c.offsetHeight || 280;
        canvas.width = w;
        canvas.height = h;
        ctx.clearRect(0, 0, w, h);

        if (tab === 'formula' && data && !isNaN(data.f) && !isNaN(data.u) && data.f !== 0 && data.u !== 0) {
            drawMirrorRayDiagram(w, h, data.f, data.u, data.v, data.m);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'radius' && data && !isNaN(data.R) && data.R !== 0) {
            drawRadiusDiagram(w, h, data.R, data.f);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'magnification' && data && !isNaN(data.u) && data.u !== 0 && !isNaN(data.v)) {
            var f = data.u * data.v / (data.u + data.v);
            drawMirrorRayDiagram(w, h, f, data.u, data.v, data.m);
            if (placeholder) placeholder.style.display = 'none';
        } else if (tab === 'numimages' && data && data.n != null) {
            drawNumImagesDiagram(w, h, data.theta, data.n);
            if (placeholder) placeholder.style.display = 'none';
        } else {
            if (placeholder) placeholder.style.display = 'block';
        }
    }

    function drawMirrorRayDiagram(w, h, f, u, v, m) {
        var padding = 40;
        var cy = h / 2;
        var Px = w * 0.72;
        var scale = 3.5;
        var maxExtent = Math.max(Math.abs(u), Math.abs(v || 0), Math.abs(f) * 2) || 20;
        if (maxExtent * scale > Px - padding) scale = (Px - padding - 20) / maxExtent;
        var objH = 28;

        ctx.strokeStyle = 'rgba(0,0,0,0.25)';
        ctx.setLineDash([4, 4]);
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(padding, cy);
        ctx.lineTo(w - padding, cy);
        ctx.stroke();
        ctx.setLineDash([]);

        var R = 2 * f;
        var Cx = Px + R * scale;
        var Fx = Px + f * scale;
        var mirrorRadius = Math.abs(R) * scale;
        if (mirrorRadius > h / 2 - 10) mirrorRadius = h / 2 - 10;
        if (mirrorRadius < 15) mirrorRadius = 15;

        ctx.strokeStyle = '#d97706';
        ctx.lineWidth = 3;
        ctx.beginPath();
        if (f < 0) {
            ctx.arc(Cx, cy, mirrorRadius, -Math.PI / 2, Math.PI / 2);
        } else {
            ctx.arc(Cx, cy, mirrorRadius, Math.PI / 2, (3 * Math.PI) / 2);
        }
        ctx.stroke();

        ctx.fillStyle = '#b91c1c';
        ctx.font = 'bold 12px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.beginPath();
        ctx.arc(Fx, cy, 4, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = '#0f172a';
        ctx.fillText('F', Fx, cy + 18);
        ctx.beginPath();
        ctx.arc(Cx, cy, 4, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillText('C', Cx, cy + 18);
        ctx.fillText('P', Px, cy + 18);

        var objX = Px + u * scale;
        if (objX < padding + 5) objX = padding + 5;
        var objTop = cy - objH;

        ctx.strokeStyle = '#2563eb';
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.moveTo(objX, cy);
        ctx.lineTo(objX, objTop);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(objX, objTop - 6);
        ctx.lineTo(objX - 5, objTop);
        ctx.lineTo(objX + 5, objTop);
        ctx.closePath();
        ctx.fillStyle = '#2563eb';
        ctx.fill();
        ctx.font = '11px Inter';
        ctx.fillStyle = '#475569';
        ctx.textAlign = 'center';
        ctx.fillText('Object', objX, cy + 16);

        if (!isNaN(v) && isFinite(v)) {
            var imgX = Px + v * scale;
            var imgH = objH * Math.abs(m || 1);
            if (imgH > 50) imgH = 50;
            var imgTop = m >= 0 ? cy - imgH : cy + imgH;
            if (imgX > padding && imgX < w - padding) {
                ctx.strokeStyle = '#059669';
                ctx.lineWidth = 2.5;
                ctx.beginPath();
                ctx.moveTo(imgX, cy);
                ctx.lineTo(imgX, imgTop);
                ctx.stroke();
                ctx.beginPath();
                if (m >= 0) {
                    ctx.moveTo(imgX, imgTop - 6);
                    ctx.lineTo(imgX - 5, imgTop);
                    ctx.lineTo(imgX + 5, imgTop);
                } else {
                    ctx.moveTo(imgX, imgTop + 6);
                    ctx.lineTo(imgX - 5, imgTop);
                    ctx.lineTo(imgX + 5, imgTop);
                }
                ctx.closePath();
                ctx.fillStyle = '#059669';
                ctx.fill();
                ctx.fillStyle = '#475569';
                ctx.fillText('Image', imgX, (m >= 0 ? imgTop : cy) + 16);
            }
        }

        ctx.strokeStyle = 'rgba(217,119,6,0.7)';
        ctx.lineWidth = 1.5;
        var hitY = cy - (objTop - cy) * (Px - objX) / (Px - objX) || cy;
        if (hitY > cy - mirrorRadius && hitY < cy + mirrorRadius) {
            ctx.beginPath();
            ctx.moveTo(objX, objTop);
            ctx.lineTo(Px, hitY);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(Px, hitY);
            if (f < 0) ctx.lineTo(Fx, cy);
            else ctx.lineTo(objX - 80, objTop);
            ctx.stroke();
        }
        ctx.beginPath();
        ctx.moveTo(objX, objTop);
        ctx.lineTo(Fx, cy);
        ctx.lineTo(Px, cy + (Fx - Px) / (objX - Fx) * (cy - objTop));
        ctx.stroke();
    }

    function drawRadiusDiagram(w, h, R, f) {
        var padding = 40;
        var cy = h / 2;
        var Px = w * 0.7;
        var scale = 4;
        var r = Math.abs(R) * scale;
        if (r > h / 2 - 15) r = h / 2 - 15;
        var Cx = Px + (R < 0 ? -r : r);
        var Fx = Px + (f < 0 ? -r / 2 : r / 2);

        ctx.strokeStyle = 'rgba(0,0,0,0.25)';
        ctx.setLineDash([4, 4]);
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(padding, cy);
        ctx.lineTo(w - padding, cy);
        ctx.stroke();
        ctx.setLineDash([]);

        ctx.strokeStyle = '#d97706';
        ctx.lineWidth = 3;
        ctx.beginPath();
        if (R < 0) ctx.arc(Cx, cy, r, -Math.PI / 2, Math.PI / 2);
        else ctx.arc(Cx, cy, r, Math.PI / 2, (3 * Math.PI) / 2);
        ctx.stroke();

        ctx.strokeStyle = 'rgba(0,0,0,0.4)';
        ctx.setLineDash([2, 2]);
        ctx.beginPath();
        ctx.moveTo(Cx, cy);
        ctx.lineTo(Px, cy);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.font = '12px Inter';
        ctx.fillStyle = '#0f172a';
        ctx.textAlign = 'center';
        ctx.fillText('R', (Cx + Px) / 2, cy - 10);
        ctx.fillText('f = R/2', (Px + Fx) / 2, cy + 18);
        ctx.fillStyle = '#b91c1c';
        ctx.beginPath();
        ctx.arc(Fx, cy, 4, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = '#0f172a';
        ctx.fillText('F', Fx, cy - 12);
        ctx.fillText('P', Px, cy + 18);
        ctx.fillText('C', Cx, cy - 12);
    }

    function drawNumImagesDiagram(w, h, theta, n) {
        var cx = w / 2;
        var cy = h / 2;
        var len = Math.min(w, h) * 0.35;
        var rad = (theta * Math.PI) / 180;
        ctx.strokeStyle = '#d97706';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + len * Math.cos(-rad / 2), cy + len * Math.sin(-rad / 2));
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + len * Math.cos(rad / 2), cy + len * Math.sin(rad / 2));
        ctx.stroke();
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.fillStyle = '#0f172a';
        ctx.textAlign = 'center';
        ctx.fillText('θ = ' + formatNum(theta) + '°', cx, cy - len * 0.6);
        ctx.fillText('n = ' + n + ' images', cx, cy + len * 0.7);
    }

    function setMirrorSolveFor(variable) {
        var btns = document.querySelectorAll('.mirror-solve-btn[data-var]');
        if (btns.length) {
            btns.forEach(function (b) { b.classList.toggle('active', b.getAttribute('data-var') === variable); });
        }
        var focalSec = document.getElementById('mirror-focal-section');
        var objectSec = document.getElementById('mirror-object-section');
        var imageSec = document.getElementById('mirror-image-section');
        if (focalSec) focalSec.style.display = variable === 'f' ? 'none' : 'block';
        if (objectSec) objectSec.style.display = variable === 'u' ? 'none' : 'block';
        if (imageSec) imageSec.style.display = variable === 'v' ? 'none' : 'block';
        runMirrors();
    }

    function switchMirrorTab(tabId, btn) {
        var tabs = document.querySelectorAll('.mirror-tab');
        var panels = document.querySelectorAll('.mirror-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.mirror-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-mirror-' + tabId);
        if (panel) panel.classList.add('active');
        runMirrors();
    }

    function toggleMirrorSteps() {
        var body = document.getElementById('mirror-steps-body');
        var toggle = document.getElementById('mirror-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        runMirrors();
        document.querySelectorAll('.mirror-number-input').forEach(function (inp) {
            inp.addEventListener('input', runMirrors);
        });
        document.querySelectorAll('.mirror-unit-select').forEach(function (sel) {
            sel.addEventListener('change', runMirrors);
        });
        window.addEventListener('resize', function () {
            var tab = getActiveTab();
            var data = tab === 'formula' ? getValuesFormula() : tab === 'radius' ? getValuesRadius() : tab === 'numimages' ? getValuesNumImages() : null;
            drawMirrorViz(tab, data);
        });
    });

    window.runMirrors = runMirrors;
    window.switchMirrorTab = switchMirrorTab;
    window.setMirrorSolveFor = setMirrorSolveFor;
    window.toggleMirrorSteps = toggleMirrorSteps;
})();
