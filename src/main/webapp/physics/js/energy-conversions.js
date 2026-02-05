/**
 * Energy Conversion Formulas - calculators, visualization, step-by-step, Chart.js
 * Battery (E = nFE°), Motor (P = τω), Generator (KE), Hydro (PE), Combustion (ΔH), Nuclear (E = Δmc²), Solar (η), LED (luminous flux)
 */
(function () {
    'use strict';

    var F = 96485;
    var c = 299792458;
    var uToKg = 1.66053906660e-27;
    var massToKg = { 'kg': 1, 'g': 0.001 };
    var distToM = { 'm': 1, 'ft': 0.3048 };
    var velocityToMs = { 'm/s': 1, 'km/h': 1 / 3.6 };
    var torqueToNm = { 'N·m': 1, 'lb·ft': 1.35582 };
    var omegaToRads = { 'rad/s': 1, 'rpm': Math.PI / 30 };
    var powerToW = { 'W': 1, 'kW': 1000, 'mW': 0.001 };
    var energyToJ = { 'J': 1, 'kJ': 1000 };
    var enthalpyToJmol = { 'kJ/mol': 1000, 'J/mol': 1 };

    var canvas, ctx;
    var convChart = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.conv-tab.active');
        return t ? t.getAttribute('data-tab') : 'battery';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e12) return formatNum(x / 1e12) + ' T';
        if (Math.abs(x) >= 1e9) return formatNum(x / 1e9) + ' G';
        if (Math.abs(x) >= 1e6) return formatNum(x / 1e6) + ' M';
        if (Math.abs(x) >= 1000) return formatNum(x / 1000) + ' k';
        if (Math.abs(x) < 0.001 && x !== 0) return x.toExponential(2);
        return x.toFixed(decimals);
    }

    function formatEnergy(x) {
        if (x >= 1e12) return formatNum(x / 1e12) + ' TJ';
        if (x >= 1e9) return formatNum(x / 1e9) + ' GJ';
        if (x >= 1000) return formatNum(x / 1000) + ' kJ';
        if (x >= 1) return formatNum(x) + ' J';
        return formatNum(x * 1000) + ' mJ';
    }

    function formatPower(x) {
        if (x >= 1000) return formatNum(x / 1000) + ' kW';
        if (x >= 1) return formatNum(x) + ' W';
        return formatNum(x * 1000) + ' mW';
    }

    function formatPercent(x) {
        return formatNum(x * 100) + '%';
    }

    function getValuesBattery() {
        var n = parseFloat(document.getElementById('bat-n').value) || 0;
        var e0Raw = parseFloat(document.getElementById('bat-e0').value) || 0;
        var E = n * F * e0Raw;
        return { n: n, e0: e0Raw, E: E };
    }

    function getValuesMotor() {
        var tauRaw = parseFloat(document.getElementById('mot-tau').value) || 0;
        var tauUnit = document.getElementById('mot-tau-unit').value;
        var omegaRaw = parseFloat(document.getElementById('mot-omega').value) || 0;
        var omegaUnit = document.getElementById('mot-omega-unit').value;
        var tau = tauRaw * (torqueToNm[tauUnit] || 1);
        var omega = omegaRaw * (omegaToRads[omegaUnit] || 1);
        var P = tau * omega;
        return { tau: tau, tauraw: tauRaw, tauunit: tauUnit, omega: omega, omegaraw: omegaRaw, omegaunit: omegaUnit, P: P };
    }

    function getValuesGenerator() {
        var mRaw = parseFloat(document.getElementById('gen-m').value) || 0;
        var mUnit = document.getElementById('gen-m-unit').value;
        var vRaw = parseFloat(document.getElementById('gen-v').value) || 0;
        var vUnit = document.getElementById('gen-v-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var E = 0.5 * m * v * v;
        return { m: m, mraw: mRaw, munit: mUnit, v: v, vraw: vRaw, vunit: vUnit, E: E };
    }

    function getValuesHydro() {
        var mRaw = parseFloat(document.getElementById('hyd-m').value) || 0;
        var mUnit = document.getElementById('hyd-m-unit').value;
        var hRaw = parseFloat(document.getElementById('hyd-h').value) || 0;
        var hUnit = document.getElementById('hyd-h-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var h = hRaw * (distToM[hUnit] || 1);
        var g = 9.8;
        var E = m * g * h;
        return { m: m, mraw: mRaw, munit: mUnit, h: h, hraw: hRaw, hunit: hUnit, E: E };
    }

    function getValuesCombustion() {
        var dhRaw = parseFloat(document.getElementById('comb-dh').value) || 0;
        var dhUnit = document.getElementById('comb-dh-unit').value;
        var n = parseFloat(document.getElementById('comb-n').value) || 0;
        var dH = dhRaw * (enthalpyToJmol[dhUnit] || 1);
        var Q = n * dH;
        return { dH: dH, dhraw: dhRaw, dhunit: dhUnit, n: n, Q: Q };
    }

    function getValuesNuclear() {
        var dmRaw = parseFloat(document.getElementById('nuc-dm').value) || 0;
        var dmUnit = document.getElementById('nuc-dm-unit').value;
        var dm;
        if (dmUnit === 'u') {
            dm = dmRaw * uToKg;
        } else {
            dm = dmRaw * (massToKg[dmUnit] || 1);
        }
        var E = dm * c * c;
        return { dm: dm, dmraw: dmRaw, dmunit: dmUnit, E: E };
    }

    function getValuesSolar() {
        var poutRaw = parseFloat(document.getElementById('sol-pout').value) || 0;
        var poutUnit = document.getElementById('sol-pout-unit').value;
        var pinRaw = parseFloat(document.getElementById('sol-pin').value) || 0;
        var pinUnit = document.getElementById('sol-pin-unit').value;
        var P_out = poutRaw * (powerToW[poutUnit] || 1);
        var P_in = pinRaw * (powerToW[pinUnit] || 1);
        var eta = P_in > 0 ? P_out / P_in : 0;
        return { P_out: P_out, poutraw: poutRaw, poutunit: poutUnit, P_in: P_in, pinraw: pinRaw, pinunit: pinUnit, eta: eta };
    }

    function getValuesLED() {
        var pRaw = parseFloat(document.getElementById('led-p').value) || 0;
        var pUnit = document.getElementById('led-p-unit').value;
        var eff = parseFloat(document.getElementById('led-eff').value) || 0;
        var P = pRaw * (powerToW[pUnit] || 1);
        var flux = P * eff;
        return { P: P, praw: pRaw, punit: pUnit, eff: eff, flux: flux };
    }

    function calcBattery() {
        var v = getValuesBattery();
        var el = document.getElementById('bat-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcMotor() {
        var v = getValuesMotor();
        var el = document.getElementById('mot-value');
        if (el) el.textContent = formatPower(v.P);
        return v;
    }

    function calcGenerator() {
        var v = getValuesGenerator();
        var el = document.getElementById('gen-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcHydro() {
        var v = getValuesHydro();
        var el = document.getElementById('hyd-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcCombustion() {
        var v = getValuesCombustion();
        var el = document.getElementById('comb-value');
        if (el) el.textContent = formatEnergy(v.Q);
        return v;
    }

    function calcNuclear() {
        var v = getValuesNuclear();
        var el = document.getElementById('nuc-value');
        if (el) el.textContent = formatEnergy(v.E);
        return v;
    }

    function calcSolar() {
        var v = getValuesSolar();
        var el = document.getElementById('sol-value');
        if (el) el.textContent = formatPercent(v.eta);
        return v;
    }

    function calcLED() {
        var v = getValuesLED();
        var el = document.getElementById('led-value');
        if (el) el.textContent = formatNum(v.flux) + ' lm';
        return v;
    }

    function buildStepsBattery(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Moles of electrons <span class="highlight">n = ' + formatNum(v.n) + ' mol</span>, Cell potential <span class="highlight">E° = ' + formatNum(v.e0) + ' V</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = n F E°</div>'
            + '<div class="step-calc">F = Faraday constant = 96485 C/mol</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ' + formatNum(v.n) + ' × 96485 × ' + formatNum(v.e0) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Battery energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsMotor(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Torque <span class="highlight">τ = ' + formatNum(v.tau) + ' N·m</span>, Angular speed <span class="highlight">ω = ' + formatNum(v.omega) + ' rad/s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">P = τ ω</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P = ' + formatNum(v.tau) + ' × ' + formatNum(v.omega) + ' = ' + formatNum(v.P) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Motor power </span><span class="step-result-value">P = ' + formatPower(v.P) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsGenerator(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Speed <span class="highlight">v = ' + formatNum(v.v) + ' m/s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = ½ m v²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ½ × ' + formatNum(v.m) + ' × ' + formatNum(v.v) + '² = ½ × ' + formatNum(v.m) + ' × ' + formatNum(v.v * v.v) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Kinetic energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsHydro(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Height <span class="highlight">h = ' + formatNum(v.h) + ' m</span>, g = 9.8 m/s²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">PE = m g h</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">PE = ' + formatNum(v.m) + ' × 9.8 × ' + formatNum(v.h) + ' = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Gravitational PE </span><span class="step-result-value">PE = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsCombustion(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Enthalpy change <span class="highlight">ΔH = ' + formatNum(v.dH) + ' J/mol</span>, Moles <span class="highlight">n = ' + formatNum(v.n) + ' mol</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Q = n ΔH</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Q = ' + formatNum(v.n) + ' × ' + formatNum(v.dH) + ' = ' + formatNum(v.Q) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Heat released </span><span class="step-result-value">Q = ' + formatEnergy(v.Q) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsNuclear(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass defect <span class="highlight">Δm = ' + formatNum(v.dm) + ' kg</span>, c = 3.00×10⁸ m/s</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">E = Δm c²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">E = ' + formatNum(v.dm) + ' × (3.00×10⁸)² = ' + formatNum(v.dm) + ' × 9.00×10¹⁶ = ' + formatNum(v.E) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Nuclear energy </span><span class="step-result-value">E = ' + formatEnergy(v.E) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsSolar(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Power output <span class="highlight">P_out = ' + formatNum(v.P_out) + ' W</span>, Power input <span class="highlight">P_in = ' + formatNum(v.P_in) + ' W</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">η = P_out / P_in</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">η = ' + formatNum(v.P_out) + ' / ' + formatNum(v.P_in) + ' = ' + formatNum(v.eta) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Solar efficiency </span><span class="step-result-value">η = ' + formatPercent(v.eta) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsLED(v) {
        var body = document.getElementById('conv-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Electrical power <span class="highlight">P = ' + formatNum(v.P) + ' W</span>, Luminous efficacy <span class="highlight">= ' + formatNum(v.eff) + ' lm/W</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Luminous flux = P × efficacy</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Flux = ' + formatNum(v.P) + ' × ' + formatNum(v.eff) + ' = ' + formatNum(v.flux) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Luminous flux </span><span class="step-result-value">= ' + formatNum(v.flux) + ' lm</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawBatteryViz(w, h, n, e0, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var batW = 50;
        var batH = 30;
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 3;
        ctx.strokeRect(cx - batW / 2, cy - batH / 2, batW, batH);
        ctx.fillStyle = '#d1fae5';
        ctx.fillRect(cx - batW / 2, cy - batH / 2, batW, batH);
        ctx.fillStyle = '#059669';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('+', cx - 15, cy);
        ctx.fillText('−', cx + 15, cy);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('E = nFE°', cx, cy - batH / 2 - 20);
        ctx.fillText('E = ' + formatEnergy(E), cx, cy + batH / 2 + 30);
    }

    function drawMotorViz(w, h, tau, omega, P) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var r = 40;
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(cx, cy, r, 0, Math.PI * 2);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + r * Math.cos(omega * 0.1), cy - r * Math.sin(omega * 0.1));
        ctx.stroke();
        ctx.fillStyle = '#0284c7';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P = τω', cx, cy - r - 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('P = ' + formatPower(P), cx, cy + r + 30);
    }

    function drawGeneratorViz(w, h, m, v, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('E = ½mv²', cx, cy - 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('m = ' + formatNum(m) + ' kg', cx - 60, cy);
        ctx.fillText('v = ' + formatNum(v) + ' m/s', cx + 60, cy);
        ctx.fillStyle = '#059669';
        ctx.font = 'bold 18px JetBrains Mono, monospace';
        ctx.fillText('E = ' + formatEnergy(E), cx, cy + 40);
    }

    function drawHydroViz(w, h, m, hVal, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var topY = 40;
        var bottomY = h - 40;
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx - 30, topY);
        ctx.lineTo(cx - 30, bottomY);
        ctx.lineTo(cx + 30, bottomY);
        ctx.lineTo(cx + 30, topY);
        ctx.stroke();
        ctx.fillStyle = '#0284c7';
        ctx.fillRect(cx - 25, topY, 50, 20);
        ctx.fillStyle = '#059669';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('PE = mgh', cx, topY - 20);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('PE = ' + formatEnergy(E), cx, bottomY + 30);
    }

    function drawCombustionViz(w, h, dH, n, Q) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#dc2626';
        ctx.font = 'bold 18px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('🔥', cx, cy - 30);
        ctx.fillText('Q = nΔH', cx, cy);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('Q = ' + formatEnergy(Q), cx, cy + 30);
    }

    function drawNuclearViz(w, h, dm, E) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var r = 30;
        ctx.fillStyle = '#7c3aed';
        ctx.beginPath();
        ctx.arc(cx, cy, r, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#f3e8ff';
        ctx.lineWidth = 2;
        for (var i = 0; i < 8; i++) {
            var angle = (i * Math.PI * 2) / 8;
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.lineTo(cx + r * 1.5 * Math.cos(angle), cy + r * 1.5 * Math.sin(angle));
            ctx.stroke();
        }
        ctx.fillStyle = '#7c3aed';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('E = Δmc²', cx, cy - r - 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('E = ' + formatEnergy(E), cx, cy + r + 30);
    }

    function drawSolarViz(w, h, P_out, P_in, eta) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var sunR = 25;
        ctx.fillStyle = '#f59e0b';
        ctx.beginPath();
        ctx.arc(cx - 40, cy - 20, sunR, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 3;
        ctx.strokeRect(cx + 10, cy - 15, 30, 20);
        ctx.fillStyle = '#0284c7';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('η = P_out/P_in', cx, cy + 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('η = ' + formatPercent(eta), cx, cy + 50);
    }

    function drawLEDViz(w, h, P, eff, flux) {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        ctx.fillStyle = '#fbbf24';
        ctx.beginPath();
        ctx.arc(cx, cy, 20, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.strokeRect(cx - 15, cy + 25, 30, 10);
        ctx.fillStyle = '#059669';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Flux = P × efficacy', cx, cy - 40);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('Flux = ' + formatNum(flux) + ' lm', cx, cy + 50);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('conv-viz-container');
        var pills = document.getElementById('conv-viz-pills');
        if (!c || !canvas || !ctx) return;
        canvas.width = c.offsetWidth;
        canvas.height = c.offsetHeight;
        var w = canvas.width;
        var h = canvas.height;

        if (tab === 'battery') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="conv-viz-pill">E° = ' + formatNum(data.e0) + ' V</span>';
            drawBatteryViz(w, h, data.n, data.e0, data.E);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'motor') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">P = ' + formatPower(data.P) + '</span><span class="conv-viz-pill">τ = ' + formatNum(data.tau) + ' N·m</span>';
            drawMotorViz(w, h, data.tau, data.omega, data.P);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'generator') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="conv-viz-pill">v = ' + formatNum(data.v) + ' m/s</span>';
            drawGeneratorViz(w, h, data.m, data.v, data.E);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'hydro') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">PE = ' + formatEnergy(data.E) + '</span><span class="conv-viz-pill">h = ' + formatNum(data.h) + ' m</span>';
            drawHydroViz(w, h, data.m, data.h, data.E);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'combustion') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">Q = ' + formatEnergy(data.Q) + '</span><span class="conv-viz-pill">ΔH = ' + formatNum(data.dH) + ' J/mol</span>';
            drawCombustionViz(w, h, data.dH, data.n, data.Q);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'nuclear') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">E = ' + formatEnergy(data.E) + '</span><span class="conv-viz-pill">Δm = ' + formatNum(data.dm) + ' kg</span>';
            drawNuclearViz(w, h, data.dm, data.E);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        } else if (tab === 'solar') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">η = ' + formatPercent(data.eta) + '</span><span class="conv-viz-pill">P_out = ' + formatPower(data.P_out) + '</span>';
            drawSolarViz(w, h, data.P_out, data.P_in, data.eta);
            updateSolarChart(data);
            document.getElementById('conv-chart-wrap').style.display = 'block';
        } else if (tab === 'led') {
            if (pills) pills.innerHTML = '<span class="conv-viz-pill">Flux = ' + formatNum(data.flux) + ' lm</span><span class="conv-viz-pill">P = ' + formatPower(data.P) + '</span>';
            drawLEDViz(w, h, data.P, data.eff, data.flux);
            document.getElementById('conv-chart-wrap').style.display = 'none';
        }
    }

    function updateSolarChart(v) {
        var wrap = document.getElementById('conv-chart-wrap');
        var can = document.getElementById('conv-chart-canvas');
        if (typeof Chart === 'undefined' || !wrap || !can) return;
        var pinVals = [];
        var poutVals = [];
        var maxPin = Math.max(v.P_in, 1000);
        for (var pin = 0; pin <= maxPin; pin += maxPin / 10) {
            pinVals.push(formatPower(pin));
            poutVals.push(pin > 0 ? (v.P_out / v.P_in) * pin : 0);
        }
        if (convChart) convChart.destroy();
        convChart = new Chart(can.getContext('2d'), {
            type: 'line',
            data: {
                labels: pinVals,
                datasets: [{
                    label: 'P_out = η × P_in',
                    data: poutVals,
                    borderColor: '#059669',
                    backgroundColor: 'rgba(5, 150, 105, 0.1)',
                    fill: true,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Solar cell: P_out vs P_in (your efficiency)' }
                },
                scales: {
                    x: { title: { display: true, text: 'P_in (incident light power)' } },
                    y: { title: { display: true, text: 'P_out (electrical power)' } }
                }
            }
        });
    }

    function runEnergyConv() {
        var tab = getActiveTab();
        if (tab === 'battery') {
            var v = calcBattery();
            drawViz('battery', v);
            buildStepsBattery(v);
        } else if (tab === 'motor') {
            var v = calcMotor();
            drawViz('motor', v);
            buildStepsMotor(v);
        } else if (tab === 'generator') {
            var v = calcGenerator();
            drawViz('generator', v);
            buildStepsGenerator(v);
        } else if (tab === 'hydro') {
            var v = calcHydro();
            drawViz('hydro', v);
            buildStepsHydro(v);
        } else if (tab === 'combustion') {
            var v = calcCombustion();
            drawViz('combustion', v);
            buildStepsCombustion(v);
        } else if (tab === 'nuclear') {
            var v = calcNuclear();
            drawViz('nuclear', v);
            buildStepsNuclear(v);
        } else if (tab === 'solar') {
            var v = calcSolar();
            drawViz('solar', v);
            buildStepsSolar(v);
        } else if (tab === 'led') {
            var v = calcLED();
            drawViz('led', v);
            buildStepsLED(v);
        }
    }

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('conv-steps-body');
        var toggle = document.getElementById('conv-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }

    function bindTabs() {
        document.querySelectorAll('.conv-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                document.querySelectorAll('.conv-tab').forEach(function (b) { b.classList.remove('active'); });
                document.querySelectorAll('.conv-panel').forEach(function (p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById('panel-' + tab);
                if (panel) panel.classList.add('active');
                runEnergyConv();
            });
        });
    }

    function init() {
        canvas = document.getElementById('conv-viz-canvas');
        if (canvas) ctx = canvas.getContext('2d');
        bindTabs();
        runEnergyConv();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.runEnergyConv = runEnergyConv;
    window.toggleConvSteps = toggleSteps;
})();
