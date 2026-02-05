/**
 * Thermal & Heat-Related Conversions - calculators, visualization, step-by-step, Chart.js
 * Q = mcΔT, Q = mL, η = W/Q_in, η_Carnot = 1 - T_cold/T_hot
 */
(function () {
    'use strict';

    var massToKg = { 'kg': 1, 'g': 0.001, 'lb': 0.453592 };
    var specHeatToJkgK = { 'J/(kg·K)': 1, 'J/(kg·°C)': 1, 'cal/(g·°C)': 4186 };
    var tempToK = { 'K': 1, '°C': function(c) { return c + 273.15; }, '°F': function(f) { return (f - 32) * 5/9 + 273.15; } };
    var deltaTempToK = { 'K': 1, '°C': 1, '°F': 5/9 };
    var latentToJkg = { 'J/kg': 1, 'kJ/kg': 1000, 'cal/g': 4186 };
    var energyToJ = { 'J': 1, 'kJ': 1000 };

    var canvas, ctx;
    var thermalChart = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.thermal-tab.active');
        return t ? t.getAttribute('data-tab') : 'sensible';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 0.001 && x !== 0)) return x.toExponential(2);
        if (Math.abs(x) < 1 && Math.abs(x) >= 0.0001) return x.toFixed(4);
        return x.toFixed(decimals);
    }

    function formatEnergy(x) {
        if (x >= 1000) return formatNum(x / 1000) + ' kJ';
        if (x >= 1) return formatNum(x) + ' J';
        if (x >= 0.001) return formatNum(x * 1000) + ' mJ';
        return formatNum(x * 1e6) + ' μJ';
    }

    function formatPercent(x) {
        return formatNum(x * 100) + '%';
    }

    function convertTempToK(value, unit) {
        if (unit === 'K') return value;
        if (unit === '°C') return value + 273.15;
        if (unit === '°F') return (value - 32) * 5/9 + 273.15;
        return value;
    }

    function convertDeltaTempToK(value, unit) {
        if (unit === 'K' || unit === '°C') return value;
        if (unit === '°F') return value * 5/9;
        return value;
    }

    function getValuesSensible() {
        var mRaw = parseFloat(document.getElementById('sens-m').value) || 0;
        var mUnit = document.getElementById('sens-m-unit').value;
        var cRaw = parseFloat(document.getElementById('sens-c').value) || 0;
        var cUnit = document.getElementById('sens-c-unit').value;
        var dtRaw = parseFloat(document.getElementById('sens-dt').value) || 0;
        var dtUnit = document.getElementById('sens-dt-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var c = cRaw * (specHeatToJkgK[cUnit] || 1);
        var dt = convertDeltaTempToK(dtRaw, dtUnit);
        var Q = m * c * dt;
        return { m: m, mraw: mRaw, munit: mUnit, c: c, craw: cRaw, cunit: cUnit, dt: dt, draw: dtRaw, dtunit: dtUnit, Q: Q };
    }

    function getValuesLatent() {
        var mRaw = parseFloat(document.getElementById('lat-m').value) || 0;
        var mUnit = document.getElementById('lat-m-unit').value;
        var lRaw = parseFloat(document.getElementById('lat-l').value) || 0;
        var lUnit = document.getElementById('lat-l-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var L = lRaw * (latentToJkg[lUnit] || 1);
        var Q = m * L;
        return { m: m, mraw: mRaw, munit: mUnit, L: L, lraw: lRaw, lunit: lUnit, Q: Q };
    }

    function getValuesEfficiency() {
        var wRaw = parseFloat(document.getElementById('eff-w').value) || 0;
        var wUnit = document.getElementById('eff-w-unit').value;
        var qinRaw = parseFloat(document.getElementById('eff-qin').value) || 0;
        var qinUnit = document.getElementById('eff-qin-unit').value;
        var W = wRaw * (energyToJ[wUnit] || 1);
        var Q_in = qinRaw * (energyToJ[qinUnit] || 1);
        var eta = Q_in > 0 ? W / Q_in : 0;
        var Q_out = Q_in - W;
        return { W: W, wraw: wRaw, wunit: wUnit, Q_in: Q_in, qinraw: qinRaw, qinunit: qinUnit, Q_out: Q_out, eta: eta };
    }

    function getValuesCarnot() {
        var thotRaw = parseFloat(document.getElementById('car-thot').value) || 0;
        var thotUnit = document.getElementById('car-thot-unit').value;
        var tcoldRaw = parseFloat(document.getElementById('car-tcold').value) || 0;
        var tcoldUnit = document.getElementById('car-tcold-unit').value;
        var T_hot = convertTempToK(thotRaw, thotUnit === 'C' ? '°C' : thotUnit);
        var T_cold = convertTempToK(tcoldRaw, tcoldUnit === 'C' ? '°C' : tcoldUnit);
        var eta = T_hot > 0 ? Math.max(0, 1 - T_cold / T_hot) : 0;
        return { T_hot: T_hot, thotraw: thotRaw, thotunit: thotUnit, T_cold: T_cold, tcoldraw: tcoldRaw, tcoldunit: tcoldUnit, eta: eta };
    }

    function getValuesTemp() {
        var val = parseFloat(document.getElementById('temp-value-in').value);
        var unit = document.getElementById('temp-unit').value;
        if (isNaN(val)) return { K: NaN, C: NaN, F: NaN };
        var K = unit === 'K' ? val : unit === 'C' ? val + 273.15 : (val - 32) * 5/9 + 273.15;
        var C = K - 273.15;
        var F = C * 9/5 + 32;
        return { K: K, C: C, F: F, val: val, unit: unit };
    }

    function getValuesCOP() {
        var thotRaw = parseFloat(document.getElementById('cop-thot').value) || 0;
        var tcoldRaw = parseFloat(document.getElementById('cop-tcold').value) || 0;
        var thotUnit = document.getElementById('cop-thot-unit').value;
        var tcoldUnit = document.getElementById('cop-tcold-unit').value;
        var T_H = thotUnit === 'C' ? thotRaw + 273.15 : thotRaw;
        var T_C = tcoldUnit === 'C' ? tcoldRaw + 273.15 : tcoldRaw;
        var cop = (T_H > T_C && T_C > 0) ? T_C / (T_H - T_C) : 0;
        return { T_H: T_H, T_C: T_C, cop: cop };
    }

    function calcSensible() {
        var v = getValuesSensible();
        var el = document.getElementById('sens-value');
        if (el) el.textContent = formatEnergy(v.Q);
        return v;
    }

    function calcLatent() {
        var v = getValuesLatent();
        var el = document.getElementById('lat-value');
        if (el) el.textContent = formatEnergy(v.Q);
        return v;
    }

    function calcEfficiency() {
        var v = getValuesEfficiency();
        var el = document.getElementById('eff-value');
        if (el) el.textContent = formatPercent(v.eta);
        return v;
    }

    function calcCarnot() {
        var v = getValuesCarnot();
        var el = document.getElementById('car-value');
        if (el) el.textContent = formatPercent(v.eta);
        return v;
    }

    function calcTemp() {
        var v = getValuesTemp();
        var el = document.getElementById('temp-value');
        if (el) el.textContent = isNaN(v.K) ? '—' : formatNum(v.K) + ' K = ' + formatNum(v.C) + ' °C = ' + formatNum(v.F) + ' °F';
        return v;
    }

    function calcCOP() {
        var v = getValuesCOP();
        var el = document.getElementById('cop-value');
        if (el) el.textContent = formatNum(v.cop);
        return v;
    }

    function buildStepsSensible(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Specific heat <span class="highlight">c = ' + formatNum(v.c) + ' J/(kg·K)</span>, ΔT <span class="highlight">= ' + formatNum(v.dt) + ' K</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Q = m c ΔT</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Q = ' + formatNum(v.m) + ' × ' + formatNum(v.c) + ' × ' + formatNum(v.dt) + ' = ' + formatNum(v.Q) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Heat </span><span class="step-result-value">Q = ' + formatEnergy(v.Q) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsLatent(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Latent heat <span class="highlight">L = ' + formatNum(v.L) + ' J/kg</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Q = m L</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Q = ' + formatNum(v.m) + ' × ' + formatNum(v.L) + ' = ' + formatNum(v.Q) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Latent heat </span><span class="step-result-value">Q = ' + formatEnergy(v.Q) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsEfficiency(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Work output <span class="highlight">W = ' + formatNum(v.W) + ' J</span>, Heat input <span class="highlight">Q_in = ' + formatNum(v.Q_in) + ' J</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">η = W / Q_in</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">η = ' + formatNum(v.W) + ' / ' + formatNum(v.Q_in) + ' = ' + formatNum(v.eta) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Efficiency </span><span class="step-result-value">η = ' + formatPercent(v.eta) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsCarnot(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Hot reservoir <span class="highlight">T_hot = ' + formatNum(v.T_hot) + ' K</span>, Cold reservoir <span class="highlight">T_cold = ' + formatNum(v.T_cold) + ' K</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">η_Carnot = 1 − (T_cold / T_hot)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">η_Carnot = 1 − (' + formatNum(v.T_cold) + ' / ' + formatNum(v.T_hot) + ') = 1 − ' + formatNum(v.T_cold / v.T_hot) + ' = ' + formatNum(v.eta) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Carnot efficiency </span><span class="step-result-value">η_Carnot = ' + formatPercent(v.eta) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsTemp(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item"><div class="step-title"><span class="step-number">1</span>Formula</div>'
            + '<div class="step-formula">K = °C + 273.15, °F = (9/5)°C + 32</div></div>'
            + '<div class="step-item"><div class="step-title"><span class="step-number">2</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-value">' + formatNum(v.K) + ' K = ' + formatNum(v.C) + ' °C = ' + formatNum(v.F) + ' °F</span></div></div>';
        body.innerHTML = html;
    }

    function buildStepsCOP(v) {
        var body = document.getElementById('thermal-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item"><div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">T_H = ' + formatNum(v.T_H) + ' K, T_C = ' + formatNum(v.T_C) + ' K</div></div>'
            + '<div class="step-item"><div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">COP_Carnot = T_C / (T_H − T_C)</div></div>'
            + '<div class="step-item"><div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">COP = ' + formatNum(v.T_C) + ' / (' + formatNum(v.T_H) + ' − ' + formatNum(v.T_C) + ') = ' + formatNum(v.cop) + '</div></div>';
        body.innerHTML = html;
    }

    function drawSensibleViz(w, h, m, c, dt, Q) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 18px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Q = m × c × ΔT', cx, cy - 40);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('m = ' + formatNum(m) + ' kg', cx - 80, cy - 10);
        ctx.fillText('c = ' + formatNum(c) + ' J/(kg·K)', cx, cy - 10);
        ctx.fillText('ΔT = ' + formatNum(dt) + ' K', cx + 80, cy - 10);
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 20px JetBrains Mono, monospace';
        ctx.fillText('Q = ' + formatEnergy(Q), cx, cy + 30);
        var barW = Math.min(200, w * 0.5);
        var barH = 14;
        var left = cx - barW / 2;
        var top = cy + 60;
        ctx.strokeStyle = '#e2e8f0';
        ctx.lineWidth = 2;
        ctx.strokeRect(left, top, barW, barH);
        ctx.fillStyle = '#fee2e2';
        ctx.fillRect(left, top, barW, barH);
        var fillW = barW * Math.min(1, Q / 100000);
        ctx.fillStyle = '#dc2626';
        ctx.fillRect(left, top, fillW, barH);
    }

    function drawLatentViz(w, h, m, L, Q) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 18px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Q = m × L', cx, cy - 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('m = ' + formatNum(m) + ' kg', cx - 60, cy);
        ctx.fillText('L = ' + formatNum(L) + ' J/kg', cx + 60, cy);
        ctx.fillStyle = '#ea580c';
        ctx.font = 'bold 20px JetBrains Mono, monospace';
        ctx.fillText('Q = ' + formatEnergy(Q), cx, cy + 40);
        var phaseW = 60;
        var phaseH = 40;
        ctx.strokeStyle = '#ea580c';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(cx - phaseW, cy - 50, 15, 0, Math.PI * 2);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(cx, cy - 50);
        ctx.lineTo(cx + phaseW, cy - 50);
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(cx + phaseW, cy - 50, 15, 0, Math.PI * 2);
        ctx.fill();
    }

    function drawEfficiencyViz(w, h, W, Q_in, eta) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var boxW = 120;
        var boxH = 80;
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.strokeRect(cx - boxW / 2, cy - boxH / 2, boxW, boxH);
        ctx.fillStyle = '#fee2e2';
        ctx.fillRect(cx - boxW / 2, cy - boxH / 2, boxW, boxH);
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Heat Engine', cx, cy - 20);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('Q_in = ' + formatEnergy(Q_in), cx, cy);
        ctx.fillText('W = ' + formatEnergy(W), cx, cy + 20);
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('η = ' + formatPercent(eta), cx, cy + 50);
    }

    function drawTempViz(w, h, v) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('K = °C + 273.15', cx, cy - 30);
        ctx.fillText(formatNum(v.K) + ' K  =  ' + formatNum(v.C) + ' °C  =  ' + formatNum(v.F) + ' °F', cx, cy + 10);
    }

    function drawCOPViz(w, h, T_H, T_C, cop) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#2563eb';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('T_H = ' + formatNum(T_H) + ' K', cx, cy - 40);
        ctx.fillText('T_C = ' + formatNum(T_C) + ' K', cx, cy + 40);
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('COP = ' + formatNum(cop), cx, cy);
    }

    function drawCarnotViz(w, h, T_hot, T_cold, eta) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var hotY = cy - 50;
        var coldY = cy + 50;
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('T_hot = ' + formatNum(T_hot) + ' K', cx, hotY);
        ctx.fillStyle = '#2563eb';
        ctx.fillText('T_cold = ' + formatNum(T_cold) + ' K', cx, coldY);
        ctx.strokeStyle = '#0f172a';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(cx - 40, hotY + 15);
        ctx.lineTo(cx - 40, coldY - 15);
        ctx.moveTo(cx + 40, hotY + 15);
        ctx.lineTo(cx + 40, coldY - 15);
        ctx.stroke();
        ctx.fillStyle = '#ea580c';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('η_Carnot = ' + formatPercent(eta), cx, cy);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('thermal-viz-container');
        var pills = document.getElementById('thermal-viz-pills');
        if (!c || !canvas || !ctx) return;
        canvas.width = c.offsetWidth;
        canvas.height = c.offsetHeight;
        var w = canvas.width;
        var h = canvas.height;

        if (tab === 'sensible') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">Q = ' + formatEnergy(data.Q) + '</span><span class="thermal-viz-pill">ΔT = ' + formatNum(data.dt) + ' K</span>';
            drawSensibleViz(w, h, data.m, data.c, data.dt, data.Q);
            document.getElementById('thermal-chart-wrap').style.display = 'none';
        } else if (tab === 'latent') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">Q = ' + formatEnergy(data.Q) + '</span><span class="thermal-viz-pill">L = ' + formatNum(data.L) + ' J/kg</span>';
            drawLatentViz(w, h, data.m, data.L, data.Q);
            document.getElementById('thermal-chart-wrap').style.display = 'none';
        } else if (tab === 'efficiency') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">η = ' + formatPercent(data.eta) + '</span><span class="thermal-viz-pill">W = ' + formatEnergy(data.W) + '</span>';
            drawEfficiencyViz(w, h, data.W, data.Q_in, data.eta);
            document.getElementById('thermal-chart-wrap').style.display = 'none';
        } else if (tab === 'temp') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">K = ' + formatNum(data.K) + '</span><span class="thermal-viz-pill">°C = ' + formatNum(data.C) + '</span><span class="thermal-viz-pill">°F = ' + formatNum(data.F) + '</span>';
            drawTempViz(w, h, data);
            document.getElementById('thermal-chart-wrap').style.display = 'none';
        } else if (tab === 'cop') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">COP = ' + formatNum(data.cop) + '</span>';
            drawCOPViz(w, h, data.T_H, data.T_C, data.cop);
            document.getElementById('thermal-chart-wrap').style.display = 'none';
        } else if (tab === 'carnot') {
            if (pills) pills.innerHTML = '<span class="thermal-viz-pill">η_Carnot = ' + formatPercent(data.eta) + '</span><span class="thermal-viz-pill">T_hot/T_cold = ' + formatNum(data.T_hot / data.T_cold, 2) + '</span>';
            drawCarnotViz(w, h, data.T_hot, data.T_cold, data.eta);
            updateCarnotChart(data);
            document.getElementById('thermal-chart-wrap').style.display = 'block';
        }
    }

    function updateCarnotChart(v) {
        var wrap = document.getElementById('thermal-chart-wrap');
        var can = document.getElementById('thermal-chart-canvas');
        if (typeof Chart === 'undefined' || !wrap || !can) return;
        var ratios = [];
        var efficiencies = [];
        var baseRatio = v.T_hot > 0 ? v.T_cold / v.T_hot : 0;
        for (var r = 0; r <= 1; r += 0.1) {
            ratios.push(r.toFixed(1));
            efficiencies.push(Math.max(0, 1 - r));
        }
        if (thermalChart) thermalChart.destroy();
        thermalChart = new Chart(can.getContext('2d'), {
            type: 'line',
            data: {
                labels: ratios,
                datasets: [{
                    label: 'η_Carnot = 1 - (T_cold/T_hot)',
                    data: efficiencies,
                    borderColor: '#dc2626',
                    backgroundColor: 'rgba(220, 38, 38, 0.1)',
                    fill: true,
                    tension: 0.2,
                    pointRadius: 0
                }, {
                    label: 'Your point',
                    data: Array(11).fill(null).map(function(_, i) {
                        return i === Math.round(baseRatio * 10) ? v.eta : null;
                    }),
                    borderColor: '#ea580c',
                    backgroundColor: '#ea580c',
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Carnot efficiency vs T_cold/T_hot ratio' }
                },
                scales: {
                    x: { title: { display: true, text: 'T_cold / T_hot' } },
                    y: { title: { display: true, text: 'η_Carnot' }, min: 0, max: 1 }
                }
            }
        });
    }

    function runThermal() {
        var tab = getActiveTab();
        if (tab === 'sensible') {
            var v = calcSensible();
            drawViz('sensible', v);
            buildStepsSensible(v);
        } else if (tab === 'latent') {
            var v = calcLatent();
            drawViz('latent', v);
            buildStepsLatent(v);
        } else if (tab === 'temp') {
            var v = calcTemp();
            drawViz('temp', v);
            buildStepsTemp(v);
        } else if (tab === 'efficiency') {
            var v = calcEfficiency();
            drawViz('efficiency', v);
            buildStepsEfficiency(v);
        } else if (tab === 'carnot') {
            var v = calcCarnot();
            drawViz('carnot', v);
            buildStepsCarnot(v);
        } else if (tab === 'cop') {
            var v = calcCOP();
            drawViz('cop', v);
            buildStepsCOP(v);
        }
    }

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('thermal-steps-body');
        var toggle = document.getElementById('thermal-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }

    function bindTabs() {
        document.querySelectorAll('.thermal-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                document.querySelectorAll('.thermal-tab').forEach(function (b) { b.classList.remove('active'); });
                document.querySelectorAll('.thermal-panel').forEach(function (p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById('panel-' + tab);
                if (panel) panel.classList.add('active');
                runThermal();
            });
        });
    }

    function init() {
        canvas = document.getElementById('thermal-viz-canvas');
        if (canvas) ctx = canvas.getContext('2d');
        bindTabs();
        runThermal();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.runThermal = runThermal;
    window.toggleThermalSteps = toggleSteps;
})();
