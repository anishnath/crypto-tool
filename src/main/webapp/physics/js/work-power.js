/**
 * Work & Power - calculators, visualization, step-by-step, Chart.js W vs θ
 * Open source: Chart.js (CDN) for W = F d cos(θ) vs angle chart.
 */
(function () {
    'use strict';

    var forceToN = { 'N': 1, 'kN': 1000, 'lbf': 4.44822 };
    var distToM = { 'm': 1, 'cm': 0.01, 'ft': 0.3048 };
    var workToJ = { 'J': 1, 'kJ': 1000 };
    var timeToS = { 's': 1, 'min': 60, 'h': 3600 };

    var canvas, ctx;
    var wpChart = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.wp-tab.active');
        return t ? t.getAttribute('data-tab') : 'work';
    }

    function getValuesWork() {
        var fRaw = parseFloat(document.getElementById('work-f').value) || 0;
        var fUnit = document.getElementById('work-f-unit').value;
        var dRaw = parseFloat(document.getElementById('work-d').value) || 0;
        var dUnit = document.getElementById('work-d-unit').value;
        var thetaDeg = parseFloat(document.getElementById('work-theta').value) || 0;
        var F = fRaw * (forceToN[fUnit] || 1);
        var d = dRaw * (distToM[dUnit] || 1);
        var thetaRad = (thetaDeg * Math.PI) / 180;
        var W = F * d * Math.cos(thetaRad);
        return { F: F, Fraw: fRaw, Funit: fUnit, d: d, draw: dRaw, dunit: dUnit, thetaDeg: thetaDeg, thetaRad: thetaRad, W: W };
    }

    function getValuesPower() {
        var wRaw = parseFloat(document.getElementById('power-w').value) || 0;
        var wUnit = document.getElementById('power-w-unit').value;
        var tRaw = parseFloat(document.getElementById('power-t').value) || 0;
        var tUnit = document.getElementById('power-t-unit').value;
        var W = wRaw * (workToJ[wUnit] || 1);
        var t = tRaw * (timeToS[tUnit] || 1);
        var P = t > 0 ? W / t : 0;
        return { W: W, Wraw: wRaw, Wunit: wUnit, t: t, traw: tRaw, tunit: tUnit, P: P };
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e4 || (Math.abs(x) < 0.01 && x !== 0)) return x.toExponential(2);
        return x.toFixed(decimals);
    }

    function calcWork() {
        var v = getValuesWork();
        var el = document.getElementById('work-value');
        if (el) el.textContent = formatNum(v.W) + ' J';
        return v;
    }

    function calcPower() {
        var v = getValuesPower();
        var el = document.getElementById('power-value');
        if (el) el.textContent = formatNum(v.P) + ' W';
        return v;
    }

    function buildStepsWork(v) {
        var body = document.getElementById('wp-steps-body');
        if (!body) return;
        var cosVal = Math.cos(v.thetaRad);
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force <span class="highlight">F = ' + formatNum(v.F) + ' N</span>, Displacement <span class="highlight">d = ' + formatNum(v.d) + ' m</span>, Angle <span class="highlight">θ = ' + v.thetaDeg + '°</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">W = F d cos θ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">W = ' + formatNum(v.F) + ' × ' + formatNum(v.d) + ' × cos(' + v.thetaDeg + '°) = ' + formatNum(v.F) + ' × ' + formatNum(v.d) + ' × ' + formatNum(cosVal) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Work </span><span class="step-result-value">W = ' + formatNum(v.W) + ' J</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPower(v) {
        var body = document.getElementById('wp-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Work <span class="highlight">W = ' + formatNum(v.W) + ' J</span>, Time <span class="highlight">t = ' + formatNum(v.t) + ' s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">P = W / t</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P = ' + formatNum(v.W) + ' / ' + formatNum(v.t) + ' = ' + formatNum(v.P) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Power </span><span class="step-result-value">P = ' + formatNum(v.P) + ' W</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawWorkViz(w, h, F, d, thetaDeg) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w * 0.35;
        var cy = h / 2;
        var scaleD = Math.min(40, (w * 0.4) / Math.max(d, 0.1));
        var scaleF = Math.min(30, (w * 0.25) / Math.max(F, 0.1));
        var thetaRad = (thetaDeg * Math.PI) / 180;
        var dx = d * scaleD;
        var dispEndX = cx + dx;
        ctx.strokeStyle = '#0d9488';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(dispEndX, cy);
        ctx.stroke();
        ctx.fillStyle = '#0d9488';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('d = ' + formatNum(d) + ' m', (cx + dispEndX) / 2, cy + 22);

        var fx = F * scaleF * Math.cos(thetaRad);
        var fy = -F * scaleF * Math.sin(thetaRad);
        var arrowLen = Math.sqrt(fx * fx + fy * fy) || 1;
        var ax = cx + fx;
        var ay = cy + fy;
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(ax, ay);
        ctx.stroke();
        var head = 12;
        var angle = Math.atan2(ay - cy, ax - cx);
        ctx.beginPath();
        ctx.moveTo(ax, ay);
        ctx.lineTo(ax - head * Math.cos(angle - 0.35), ay + head * Math.sin(angle - 0.35));
        ctx.lineTo(ax - head * Math.cos(angle + 0.35), ay + head * Math.sin(angle + 0.35));
        ctx.closePath();
        ctx.fillStyle = '#dc2626';
        ctx.fill();
        ctx.fillStyle = '#0f172a';
        ctx.fillText('F', ax + 18 * Math.cos(angle), ay - 18 * Math.sin(angle));

        if (thetaDeg !== 0 && thetaDeg !== 180) {
            var arcR = Math.min(35, arrowLen * 0.5);
            ctx.strokeStyle = '#7c3aed';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(cx, cy, arcR, -thetaRad, 0, thetaRad < 0);
            ctx.stroke();
            ctx.fillStyle = '#7c3aed';
            ctx.font = '12px Inter, sans-serif';
            ctx.fillText('θ = ' + thetaDeg + '°', cx + arcR * 0.8, cy - arcR * 0.6);
        }

        var boxX = dispEndX + 20;
        var boxW = 28;
        var boxH = 22;
        ctx.fillStyle = 'rgba(8, 145, 178, 0.2)';
        ctx.strokeStyle = '#0891b2';
        ctx.lineWidth = 2;
        ctx.strokeRect(boxX, cy - boxH / 2, boxW, boxH);
        ctx.fillRect(boxX, cy - boxH / 2, boxW, boxH);
    }

    function drawPowerViz(w, h, W, t, P) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = '16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P = W / t', cx, cy - 30);
        ctx.fillText('W = ' + formatNum(W) + ' J', cx, cy);
        ctx.fillText('t = ' + formatNum(t) + ' s', cx, cy + 24);
        ctx.fillStyle = '#0891b2';
        ctx.font = 'bold 20px JetBrains Mono, monospace';
        ctx.fillText('P = ' + formatNum(P) + ' W', cx, cy + 58);
        var barW = Math.min(200, w * 0.5);
        var barH = 14;
        var left = cx - barW / 2;
        var top = cy + 82;
        ctx.strokeStyle = '#e2e8f0';
        ctx.lineWidth = 2;
        ctx.strokeRect(left, top, barW, barH);
        ctx.fillStyle = '#cffafe';
        ctx.fillRect(left, top, barW, barH);
        var fillW = barW * Math.min(1, P / 50);
        ctx.fillStyle = '#0891b2';
        ctx.fillRect(left, top, fillW, barH);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('wp-viz-container');
        var pills = document.getElementById('wp-viz-pills');
        if (!c || !canvas || !ctx) return;
        canvas.width = c.offsetWidth;
        canvas.height = c.offsetHeight;
        var w = canvas.width;
        var h = canvas.height;

        if (tab === 'work') {
            if (pills) pills.innerHTML = '<span class="wp-viz-pill">W = ' + formatNum(data.W) + ' J</span><span class="wp-viz-pill">θ = ' + data.thetaDeg + '°</span>';
            drawWorkViz(w, h, data.F, data.d, data.thetaDeg);
            updateWorkChart(data);
            document.getElementById('wp-chart-wrap').style.display = 'block';
        } else {
            if (pills) pills.innerHTML = '<span class="wp-viz-pill">P = ' + formatNum(data.P) + ' W</span><span class="wp-viz-pill">W = ' + formatNum(data.W) + ' J</span>';
            drawPowerViz(w, h, data.W, data.t, data.P);
            document.getElementById('wp-chart-wrap').style.display = 'none';
        }
    }

    function updateWorkChart(v) {
        var wrap = document.getElementById('wp-chart-wrap');
        var can = document.getElementById('wp-chart-canvas');
        if (typeof Chart === 'undefined' || !wrap || !can) return;
        var angles = [];
        var works = [];
        for (var deg = 0; deg <= 180; deg += 10) {
            angles.push(deg + '°');
            works.push(v.F * v.d * Math.cos((deg * Math.PI) / 180));
        }
        if (wpChart) wpChart.destroy();
        wpChart = new Chart(can.getContext('2d'), {
            type: 'line',
            data: {
                labels: angles,
                datasets: [{
                    label: 'W = F d cos θ (J)',
                    data: works,
                    borderColor: '#0891b2',
                    backgroundColor: 'rgba(8, 145, 178, 0.1)',
                    fill: true,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Work W vs angle θ (your F, d)' }
                },
                scales: {
                    x: { title: { display: true, text: 'θ (degrees)' } },
                    y: { title: { display: true, text: 'W (J)' } }
                }
            }
        });
    }

    function runWorkPower() {
        var tab = getActiveTab();
        if (tab === 'work') {
            var v = calcWork();
            drawViz('work', v);
            buildStepsWork(v);
        } else {
            var v = calcPower();
            drawViz('power', v);
            buildStepsPower(v);
        }
    }

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('wp-steps-body');
        var toggle = document.getElementById('wp-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }

    function bindTabs() {
        document.querySelectorAll('.wp-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                document.querySelectorAll('.wp-tab').forEach(function (b) { b.classList.remove('active'); });
                document.querySelectorAll('.wp-panel').forEach(function (p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById('panel-' + tab);
                if (panel) panel.classList.add('active');
                runWorkPower();
            });
        });
    }

    function init() {
        canvas = document.getElementById('wp-viz-canvas');
        if (canvas) ctx = canvas.getContext('2d');
        bindTabs();
        runWorkPower();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.runWorkPower = runWorkPower;
    window.toggleWorkPowerSteps = toggleSteps;
})();
