/**
 * Energy Calculator - KE, PE_g, PE_elastic
 * Unit conversions, step-by-step solutions, and educational visualization.
 */

(function () {
    'use strict';

    // Unit conversions to SI (mass→kg, velocity→m/s, length→m, k→N/m)
    var massToKg = { 'kg': 1, 'g': 0.001, 'lb': 0.453592 };
    var velocityToMs = { 'm/s': 1, 'km/h': 1 / 3.6, 'mph': 0.44704, 'ft/s': 0.3048 };
    var lengthToM = { 'm': 1, 'cm': 0.01, 'ft': 0.3048, 'mm': 0.001 };
    var kToNm = { 'N/m': 1, 'kN/m': 1000, 'lbf/in': 175.127 };
    var energyFromJ = { 'J': 1, 'kJ': 1000, 'cal': 4.184 };

    var canvas, ctx;
    var stepsExpanded = false;
    var animId = null;

    function getActiveTab() {
        var t = document.querySelector('.energy-tab.active');
        return t ? t.getAttribute('data-tab') : 'ke';
    }

    function formatNum(val, outUnit) {
        var scale = energyFromJ[outUnit] || 1;
        var v = val / scale;
        if (v === 0) return '0 ' + outUnit;
        if (Math.abs(v) >= 1e6 || (Math.abs(v) < 0.01 && v !== 0)) return v.toExponential(3) + ' ' + outUnit;
        if (Math.abs(v) < 1 && Math.abs(v) >= 0.0001) return v.toFixed(4) + ' ' + outUnit;
        return v.toFixed(2) + ' ' + outUnit;
    }

    function getValuesKE() {
        var mRaw = parseFloat(document.getElementById('ke-mass').value) || 0;
        var mUnit = document.getElementById('ke-mass-unit').value;
        var vRaw = parseFloat(document.getElementById('ke-velocity').value) || 0;
        var vUnit = document.getElementById('ke-velocity-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var ke = 0.5 * m * v * v;
        var outUnit = (document.getElementById('out-unit-ke') && document.getElementById('out-unit-ke').value) || 'J';
        return { m: m, mRaw: mRaw, mUnit: mUnit, v: v, vRaw: vRaw, vUnit: vUnit, ke: ke, outUnit: outUnit };
    }

    function getValuesPEg() {
        var mRaw = parseFloat(document.getElementById('peg-mass').value) || 0;
        var mUnit = document.getElementById('peg-mass-unit').value;
        var hRaw = parseFloat(document.getElementById('peg-height').value) || 0;
        var hUnit = document.getElementById('peg-height-unit').value;
        var g = parseFloat(document.getElementById('peg-g').value) || 9.8;
        var m = mRaw * (massToKg[mUnit] || 1);
        var h = hRaw * (lengthToM[hUnit] !== undefined ? lengthToM[hUnit] : 1);
        var peg = m * g * h;
        var outUnit = (document.getElementById('out-unit-peg') && document.getElementById('out-unit-peg').value) || 'J';
        return { m: m, mRaw: mRaw, mUnit: mUnit, h: h, hRaw: hRaw, hUnit: hUnit, g: g, peg: peg, outUnit: outUnit };
    }

    function getValuesPEelastic() {
        var kRaw = parseFloat(document.getElementById('pel-k').value) || 0;
        var kUnit = document.getElementById('pel-k-unit').value;
        var xRaw = parseFloat(document.getElementById('pel-x').value) || 0;
        var xUnit = document.getElementById('pel-x-unit').value;
        var k = kRaw * (kToNm[kUnit] || 1);
        var x = xRaw * (lengthToM[xUnit] !== undefined ? lengthToM[xUnit] : 1);
        var pel = 0.5 * k * x * x;
        var outUnit = (document.getElementById('out-unit-pel') && document.getElementById('out-unit-pel').value) || 'J';
        return { k: k, kRaw: kRaw, kUnit: kUnit, x: x, xRaw: xRaw, xUnit: xUnit, pel: pel, outUnit: outUnit };
    }

    function calcKE() {
        var v = getValuesKE();
        document.getElementById('ke-value').textContent = formatNum(v.ke, v.outUnit);
        return v;
    }

    function calcPEg() {
        var v = getValuesPEg();
        document.getElementById('peg-value').textContent = formatNum(v.peg, v.outUnit);
        return v;
    }

    function calcPEelastic() {
        var v = getValuesPEelastic();
        document.getElementById('pel-value').textContent = formatNum(v.pel, v.outUnit);
        return v;
    }

    function runAll() {
        var tab = getActiveTab();
        if (tab === 'ke') {
            var v = calcKE();
            drawViz('ke', v);
            buildStepsKE(v);
        } else if (tab === 'pe-g') {
            var vg = calcPEg();
            drawViz('pe-g', vg);
            buildStepsPEg(vg);
        } else if (tab === 'pe-elastic') {
            var ve = calcPEelastic();
            drawViz('pe-elastic', ve);
            buildStepsPEelastic(ve);
        }
    }

    function buildStepsKE(v) {
        var body = document.getElementById('steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + v.m + ' kg</span>, Speed <span class="highlight">v = ' + v.v + ' m/s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">KE = ½ m v²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">KE = ½ × <span class="highlight">' + v.m + '</span> × <span class="highlight">' + v.v + '</span>² = ½ × ' + v.m + ' × ' + (v.v * v.v) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Kinetic energy</span><br><span class="step-result-value">' + formatNum(v.ke, v.outUnit) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPEg(v) {
        var body = document.getElementById('steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + v.m + ' kg</span>, Height <span class="highlight">h = ' + v.h + ' m</span>, g = ' + v.g + ' m/s²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">PE_g = m g h</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">PE_g = <span class="highlight">' + v.m + '</span> × <span class="highlight">' + v.g + '</span> × <span class="highlight">' + v.h + '</span> = ' + (v.m * v.g * v.h) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Gravitational potential energy</span><br><span class="step-result-value">' + formatNum(v.peg, v.outUnit) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPEelastic(v) {
        var body = document.getElementById('steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Spring constant <span class="highlight">k = ' + v.k + ' N/m</span>, Displacement <span class="highlight">x = ' + v.x + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">PE_elastic = ½ k x²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">PE = ½ × <span class="highlight">' + v.k + '</span> × <span class="highlight">' + v.x + '</span>² = ½ × ' + v.k + ' × ' + (v.x * v.x) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Elastic potential energy</span><br><span class="step-result-value">' + formatNum(v.pel, v.outUnit) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    window.toggleSteps = function () {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('steps-body');
        var toggle = document.getElementById('steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    };

    function drawViz(tab, data) {
        if (!canvas || !ctx) return;
        var c = document.getElementById('energy-viz-container');
        if (!c) return;
        canvas.width = c.offsetWidth;
        canvas.height = c.offsetHeight;
        var w = canvas.width;
        var h = canvas.height;

        var pills = document.getElementById('energy-viz-pills');
        if (pills) pills.innerHTML = '';

        if (tab === 'ke') {
            var ke = data.ke;
            pills.innerHTML = '<span class="energy-viz-pill">KE = ' + formatNum(ke, 'J') + '</span><span class="energy-viz-pill">v = ' + data.v + ' m/s</span>';
            drawKEViz(w, h, data.v, data.m);
        } else if (tab === 'pe-g') {
            var peg = data.peg;
            pills.innerHTML = '<span class="energy-viz-pill">PE_g = ' + formatNum(peg, 'J') + '</span><span class="energy-viz-pill">h = ' + data.h + ' m</span>';
            drawPEgViz(w, h, data.h, data.m);
        } else if (tab === 'pe-elastic') {
            var pel = data.pel;
            pills.innerHTML = '<span class="energy-viz-pill">PE_elastic = ' + formatNum(pel, 'J') + '</span><span class="energy-viz-pill">x = ' + data.x + ' m</span>';
            drawSpringViz(w, h, data.x, data.k);
        }
    }

    function drawKEViz(w, h, v, m) {
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        var ballR = Math.min(28, w / 12);
        var scale = Math.min(1, v / 15);
        var x = (w * 0.2) + ((Date.now() / 50) % (w * 0.6));
        if (x > w * 0.8 - ballR) x = w * 0.2;
        ctx.fillStyle = '#d97706';
        ctx.beginPath();
        ctx.arc(x, cy, ballR, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#b45309';
        ctx.lineWidth = 2;
        ctx.stroke();
        ctx.fillStyle = 'rgba(0,0,0,0.6)';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('KE = ½mv²', w / 2, 24);
        ctx.fillText('m = ' + m.toFixed(1) + ' kg, v = ' + v.toFixed(1) + ' m/s', w / 2, 44);
    }

    function drawPEgViz(w, h, heightM, m) {
        ctx.clearRect(0, 0, w, h);
        var groundY = h - 40;
        var maxH = Math.max(1, heightM);
        var norm = Math.min(1, heightM / 20);
        var ballY = groundY - norm * (groundY - 50);
        var ballX = w / 2;
        var ballR = 22;
        ctx.fillStyle = '#78716c';
        ctx.fillRect(0, groundY, w, h - groundY);
        ctx.fillStyle = '#d97706';
        ctx.beginPath();
        ctx.arc(ballX, ballY, ballR, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#b45309';
        ctx.lineWidth = 2;
        ctx.stroke();
        ctx.fillStyle = 'rgba(0,0,0,0.6)';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('PE_g = mgh', w / 2, 24);
        ctx.fillText('h = ' + heightM + ' m', w / 2, 44);
    }

    function drawSpringViz(w, h, x, k) {
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        var left = 60;
        var right = w - 60;
        var coils = 6;
        var stretch = Math.min(1, Math.max(0.1, x / 0.5));
        var blockW = 50;
        var springLen = (right - left - blockW) * 0.25 + (right - left) * 0.45 * stretch;
        var blockX = left + springLen;
        ctx.strokeStyle = '#d97706';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(left, cy);
        var amp = 14;
        for (var i = 1; i <= coils * 4; i++) {
            var t = i / (coils * 4);
            var px = left + t * springLen;
            var py = cy + (i % 2 === 1 ? amp : -amp);
            ctx.lineTo(px, py);
        }
        ctx.lineTo(blockX, cy);
        ctx.stroke();
        ctx.fillStyle = '#b45309';
        ctx.fillRect(blockX, cy - 25, blockW, 50);
        ctx.strokeStyle = '#92400e';
        ctx.lineWidth = 2;
        ctx.strokeRect(blockX, cy - 25, blockW, 50);
        ctx.fillStyle = 'rgba(0,0,0,0.6)';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('PE = ½kx²', w / 2, 24);
        ctx.fillText('x = ' + x + ' m', w / 2, 44);
    }

    function animate() {
        var tab = getActiveTab();
        if (tab === 'ke') {
            var v = getValuesKE();
            drawViz('ke', v);
        }
        animId = requestAnimationFrame(animate);
    }

    document.addEventListener('DOMContentLoaded', function () {
        canvas = document.getElementById('energy-viz-canvas');
        if (canvas) ctx = canvas.getContext('2d');

        document.querySelectorAll('.energy-tab').forEach(function (tab) {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.energy-tab').forEach(function (t) { t.classList.remove('active'); });
                document.querySelectorAll('.energy-panel').forEach(function (p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById('panel-' + this.getAttribute('data-tab'));
                if (panel) panel.classList.add('active');
                runAll();
            });
        });

        document.querySelectorAll('.number-input, .unit-select').forEach(function (el) {
            el.addEventListener('input', runAll);
            el.addEventListener('change', runAll);
        });

        runAll();
        if (ctx) animate();
    });

    window.calcKE = function () { runAll(); };
    window.calcPEg = function () { runAll(); };
    window.calcPEelastic = function () { runAll(); };
})();
