/**
 * Electrical Energy Conversions - calculators, visualization, step-by-step, Chart.js
 * E = VIt, P = VI, capacitor (½CV²), inductor (½LI²), Joule heating (I²Rt)
 */
(function () {
    'use strict';

    var voltageToV = { 'V': 1, 'kV': 1000, 'mV': 0.001 };
    var currentToA = { 'A': 1, 'mA': 0.001 };
    var timeToS = { 's': 1, 'min': 60, 'h': 3600 };
    var capToF = { 'F': 1, 'mF': 0.001, 'μF': 1e-6, 'nF': 1e-9 };
    var indToH = { 'H': 1, 'mH': 0.001, 'μH': 1e-6 };
    var resToOhm = { 'Ω': 1, 'kΩ': 1000, 'MΩ': 1000000 };

    var canvas, ctx;
    var elecChart = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.elec-tab.active');
        return t ? t.getAttribute('data-tab') : 'energy';
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

    function getValuesEnergy() {
        var vRaw = parseFloat(document.getElementById('energy-v').value) || 0;
        var vUnit = document.getElementById('energy-v-unit').value;
        var iRaw = parseFloat(document.getElementById('energy-i').value) || 0;
        var iUnit = document.getElementById('energy-i-unit').value;
        var tRaw = parseFloat(document.getElementById('energy-t').value) || 0;
        var tUnit = document.getElementById('energy-t-unit').value;
        var V = vRaw * (voltageToV[vUnit] || 1);
        var I = iRaw * (currentToA[iUnit] || 1);
        var t = tRaw * (timeToS[tUnit] || 1);
        var E = V * I * t;
        return { V: V, Vraw: vRaw, Vunit: vUnit, I: I, Iraw: iRaw, Iunit: iUnit, t: t, traw: tRaw, tunit: tUnit, E: E };
    }

    function getValuesPower() {
        var vRaw = parseFloat(document.getElementById('power-v').value) || 0;
        var vUnit = document.getElementById('power-v-unit').value;
        var iRaw = parseFloat(document.getElementById('power-i').value) || 0;
        var iUnit = document.getElementById('power-i-unit').value;
        var V = vRaw * (voltageToV[vUnit] || 1);
        var I = iRaw * (currentToA[iUnit] || 1);
        var P = V * I;
        return { V: V, Vraw: vRaw, Vunit: vUnit, I: I, Iraw: iRaw, Iunit: iUnit, P: P };
    }

    function getValuesCapacitor() {
        var cRaw = parseFloat(document.getElementById('cap-c').value) || 0;
        var cUnit = document.getElementById('cap-c-unit').value;
        var vRaw = parseFloat(document.getElementById('cap-v').value) || 0;
        var vUnit = document.getElementById('cap-v-unit').value;
        var C = cRaw * (capToF[cUnit] || 1);
        var V = vRaw * (voltageToV[vUnit] || 1);
        var E = 0.5 * C * V * V;
        return { C: C, Craw: cRaw, Cunit: cUnit, V: V, Vraw: vRaw, Vunit: vUnit, E: E };
    }

    function getValuesInductor() {
        var lRaw = parseFloat(document.getElementById('ind-l').value) || 0;
        var lUnit = document.getElementById('ind-l-unit').value;
        var iRaw = parseFloat(document.getElementById('ind-i').value) || 0;
        var iUnit = document.getElementById('ind-i-unit').value;
        var L = lRaw * (indToH[lUnit] || 1);
        var I = iRaw * (currentToA[iUnit] || 1);
        var E = 0.5 * L * I * I;
        return { L: L, Lraw: lRaw, Lunit: lUnit, I: I, Iraw: iRaw, Iunit: iUnit, E: E };
    }

    function getValuesJoule() {
        var iRaw = parseFloat(document.getElementById('joule-i').value) || 0;
        var iUnit = document.getElementById('joule-i-unit').value;
        var rRaw = parseFloat(document.getElementById('joule-r').value) || 0;
        var rUnit = document.getElementById('joule-r-unit').value;
        var tRaw = parseFloat(document.getElementById('joule-t').value) || 0;
        var tUnit = document.getElementById('joule-t-unit').value;
        var I = iRaw * (currentToA[iUnit] || 1);
        var R = rRaw * (resToOhm[rUnit] || 1);
        var t = tRaw * (timeToS[tUnit] || 1);
        var E = I * I * R * t;
        return { I: I, Iraw: iRaw, Iunit: iUnit, R: R, Rraw: rRaw, Runit: rUnit, t: t, traw: tRaw, tunit: tUnit, E: E };
    }

    function calcEnergy() {
        var v = getValuesEnergy();
        var el = document.getElementById('energy-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcPower() {
        var v = getValuesPower();
        var el = document.getElementById('power-value');
        if (el) el.textContent = formatNum(v.P) + ' W';
        return v;
    }

    function calcCapacitor() {
        var v = getValuesCapacitor();
        var el = document.getElementById('cap-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcInductor() {
        var v = getValuesInductor();
        var el = document.getElementById('ind-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcJoule() {
        var v = getValuesJoule();
        var el = document.getElementById('joule-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function buildStepsEnergy(v) {
        var body = document.getElementById('elec-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Voltage <span class="highlight">V = ' + formatNum(v.V) + ' V</span>, Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, Time <span class="highlight">t = ' + formatNum(v.t) + ' s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = V I t</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ' + formatNum(v.V) + ' × ' + formatNum(v.I) + ' × ' + formatNum(v.t) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPower(v) {
        var body = document.getElementById('elec-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Voltage <span class="highlight">V = ' + formatNum(v.V) + ' V</span>, Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">P = V I</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P = ' + formatNum(v.V) + ' × ' + formatNum(v.I) + ' = ' + formatNum(v.P) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Power </span><span class="step-result-value">P = ' + formatNum(v.P) + ' W</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsCapacitor(v) {
        var body = document.getElementById('elec-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Capacitance <span class="highlight">C = ' + formatNum(v.C) + ' F</span>, Voltage <span class="highlight">V = ' + formatNum(v.V) + ' V</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = ½ C V²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ½ × ' + formatNum(v.C) + ' × ' + formatNum(v.V) + '² = ½ × ' + formatNum(v.C) + ' × ' + formatNum(v.V * v.V) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Capacitor energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsInductor(v) {
        var body = document.getElementById('elec-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Inductance <span class="highlight">L = ' + formatNum(v.L) + ' H</span>, Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = ½ L I²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ½ × ' + formatNum(v.L) + ' × ' + formatNum(v.I) + '² = ½ × ' + formatNum(v.L) + ' × ' + formatNum(v.I * v.I) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Inductor energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsJoule(v) {
        var body = document.getElementById('elec-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, Resistance <span class="highlight">R = ' + formatNum(v.R) + ' Ω</span>, Time <span class="highlight">t = ' + formatNum(v.t) + ' s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = I² R t</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ' + formatNum(v.I) + '² × ' + formatNum(v.R) + ' × ' + formatNum(v.t) + ' = ' + formatNum(v.I * v.I) + ' × ' + formatNum(v.R) + ' × ' + formatNum(v.t) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Joule heating </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawEnergyViz(w, h, V, I, t, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 18px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('E = V × I × t', cx, cy - 40);
        ctx.font = '16px Inter, sans-serif';
        ctx.fillText('V = ' + formatNum(V) + ' V', cx - 80, cy);
        ctx.fillText('I = ' + formatNum(I) + ' A', cx, cy);
        ctx.fillText('t = ' + formatNum(t) + ' s', cx + 80, cy);
        ctx.fillStyle = '#2563eb';
        ctx.font = 'bold 20px JetBrains Mono, monospace';
        ctx.fillText('E = ' + formatEnergy(E), cx, cy + 50);
        var barW = Math.min(200, w * 0.5);
        var barH = 14;
        var left = cx - barW / 2;
        var top = cy + 80;
        ctx.strokeStyle = '#e2e8f0';
        ctx.lineWidth = 2;
        ctx.strokeRect(left, top, barW, barH);
        ctx.fillStyle = '#dbeafe';
        ctx.fillRect(left, top, barW, barH);
        var fillW = barW * Math.min(1, E / 1000);
        ctx.fillStyle = '#2563eb';
        ctx.fillRect(left, top, fillW, barH);
    }

    function drawPowerViz(w, h, V, I, P) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 18px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P = V × I', cx, cy - 30);
        ctx.font = '16px Inter, sans-serif';
        ctx.fillText('V = ' + formatNum(V) + ' V', cx - 60, cy);
        ctx.fillText('I = ' + formatNum(I) + ' A', cx + 60, cy);
        ctx.fillStyle = '#2563eb';
        ctx.font = 'bold 20px JetBrains Mono, monospace';
        ctx.fillText('P = ' + formatNum(P) + ' W', cx, cy + 40);
    }

    function drawCapacitorViz(w, h, C, V, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var capW = 60;
        var capH = 40;
        var gap = 8;
        ctx.strokeStyle = '#2563eb';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx - capW / 2, cy - capH / 2);
        ctx.lineTo(cx - capW / 2, cy + capH / 2);
        ctx.moveTo(cx + capW / 2, cy - capH / 2);
        ctx.lineTo(cx + capW / 2, cy + capH / 2);
        ctx.stroke();
        ctx.fillStyle = '#2563eb';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('C = ' + formatNum(C) + ' F', cx, cy - capH / 2 - 20);
        ctx.fillText('V = ' + formatNum(V) + ' V', cx, cy + capH / 2 + 20);
        ctx.fillStyle = '#9333ea';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('E = ½CV² = ' + formatEnergy(E), cx, cy + capH / 2 + 50);
    }

    function drawInductorViz(w, h, L, I, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var coilR = 8;
        var coilSpacing = 20;
        var numCoils = 5;
        ctx.strokeStyle = '#9333ea';
        ctx.lineWidth = 3;
        ctx.beginPath();
        var startX = cx - (numCoils - 1) * coilSpacing / 2;
        for (var i = 0; i < numCoils; i++) {
            var x = startX + i * coilSpacing;
            ctx.arc(x, cy, coilR, 0, Math.PI * 2);
        }
        ctx.stroke();
        ctx.fillStyle = '#9333ea';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('L = ' + formatNum(L) + ' H', cx, cy - 40);
        ctx.fillText('I = ' + formatNum(I) + ' A', cx, cy + 40);
        ctx.fillStyle = '#2563eb';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('E = ½LI² = ' + formatEnergy(E), cx, cy + 70);
    }

    function drawJouleViz(w, h, I, R, t, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var resW = 50;
        var resH = 30;
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx - resW / 2 - 20, cy);
        ctx.lineTo(cx - resW / 2, cy);
        ctx.moveTo(cx + resW / 2, cy);
        ctx.lineTo(cx + resW / 2 + 20, cy);
        ctx.rect(cx - resW / 2, cy - resH / 2, resW, resH);
        ctx.stroke();
        ctx.fillStyle = '#dc2626';
        ctx.font = '14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('R = ' + formatNum(R) + ' Ω', cx, cy);
        ctx.fillText('I = ' + formatNum(I) + ' A', cx, cy - 35);
        ctx.fillText('t = ' + formatNum(t) + ' s', cx, cy + 35);
        ctx.fillStyle = '#ea580c';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('E = I²Rt = ' + formatEnergy(E), cx, cy + 70);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('elec-viz-container');
        var pills = document.getElementById('elec-viz-pills');
        if (!c || !canvas || !ctx) return;
        canvas.width = c.offsetWidth;
        canvas.height = c.offsetHeight;
        var w = canvas.width;
        var h = canvas.height;

        if (tab === 'energy') {
            if (pills) pills.innerHTML = '<span class="elec-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="elec-viz-pill">V = ' + formatNum(data.V) + ' V</span><span class="elec-viz-pill">I = ' + formatNum(data.I) + ' A</span>';
            drawEnergyViz(w, h, data.V, data.I, data.t, data.E);
            updateEnergyChart(data);
            document.getElementById('elec-chart-wrap').style.display = 'block';
        } else if (tab === 'power') {
            if (pills) pills.innerHTML = '<span class="elec-viz-pill">P = ' + formatNum(data.P) + ' W</span><span class="elec-viz-pill">V = ' + formatNum(data.V) + ' V</span>';
            drawPowerViz(w, h, data.V, data.I, data.P);
            document.getElementById('elec-chart-wrap').style.display = 'none';
        } else if (tab === 'capacitor') {
            if (pills) pills.innerHTML = '<span class="elec-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="elec-viz-pill">C = ' + formatNum(data.C) + ' F</span>';
            drawCapacitorViz(w, h, data.C, data.V, data.E);
            document.getElementById('elec-chart-wrap').style.display = 'none';
        } else if (tab === 'inductor') {
            if (pills) pills.innerHTML = '<span class="elec-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="elec-viz-pill">L = ' + formatNum(data.L) + ' H</span>';
            drawInductorViz(w, h, data.L, data.I, data.E);
            document.getElementById('elec-chart-wrap').style.display = 'none';
        } else if (tab === 'joule') {
            if (pills) pills.innerHTML = '<span class="elec-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="elec-viz-pill">I²R = ' + formatNum(data.I * data.I * data.R) + ' W</span>';
            drawJouleViz(w, h, data.I, data.R, data.t, data.E);
            document.getElementById('elec-chart-wrap').style.display = 'none';
        }
    }

    function updateEnergyChart(v) {
        var wrap = document.getElementById('elec-chart-wrap');
        var can = document.getElementById('elec-chart-canvas');
        if (typeof Chart === 'undefined' || !wrap || !can) return;
        var times = [];
        var energies = [];
        var maxT = Math.max(v.t, 10);
        for (var t = 0; t <= maxT; t += maxT / 10) {
            times.push(t.toFixed(1) + ' s');
            energies.push(v.V * v.I * t);
        }
        if (elecChart) elecChart.destroy();
        elecChart = new Chart(can.getContext('2d'), {
            type: 'line',
            data: {
                labels: times,
                datasets: [{
                    label: 'E = V I t (J)',
                    data: energies,
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    fill: true,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Energy E vs time t (your V, I)' }
                },
                scales: {
                    x: { title: { display: true, text: 't (s)' } },
                    y: { title: { display: true, text: 'E (J)' } }
                }
            }
        });
    }

    function runElecEnergy() {
        var tab = getActiveTab();
        if (tab === 'energy') {
            var v = calcEnergy();
            drawViz('energy', v);
            buildStepsEnergy(v);
        } else if (tab === 'power') {
            var v = calcPower();
            drawViz('power', v);
            buildStepsPower(v);
        } else if (tab === 'capacitor') {
            var v = calcCapacitor();
            drawViz('capacitor', v);
            buildStepsCapacitor(v);
        } else if (tab === 'inductor') {
            var v = calcInductor();
            drawViz('inductor', v);
            buildStepsInductor(v);
        } else if (tab === 'joule') {
            var v = calcJoule();
            drawViz('joule', v);
            buildStepsJoule(v);
        }
    }

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('elec-steps-body');
        var toggle = document.getElementById('elec-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }

    function bindTabs() {
        document.querySelectorAll('.elec-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                document.querySelectorAll('.elec-tab').forEach(function (b) { b.classList.remove('active'); });
                document.querySelectorAll('.elec-panel').forEach(function (p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById('panel-' + tab);
                if (panel) panel.classList.add('active');
                runElecEnergy();
            });
        });
    }

    function init() {
        canvas = document.getElementById('elec-viz-canvas');
        if (canvas) ctx = canvas.getContext('2d');
        bindTabs();
        runElecEnergy();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.runElecEnergy = runElecEnergy;
    window.toggleElecSteps = toggleSteps;
})();
