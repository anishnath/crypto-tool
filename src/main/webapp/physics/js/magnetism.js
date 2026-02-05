/**
 * Magnetism - calculators, Matter.js magnetic field visualizations, step-by-step
 * Magnetic field, force, torque, flux, magnetic moment, cyclotron
 */
(function () {
    'use strict';

    var mu0 = 4 * Math.PI * 1e-7; // T·m/A
    var currentToA = { 'A': 1, 'mA': 0.001 };
    var distToM = { 'm': 1, 'cm': 0.01 };
    var fieldToT = { 'T': 1, 'mT': 0.001, 'G': 1e-4 };
    var areaToM2 = { 'm²': 1, 'cm²': 0.0001 };
    var angleToRad = { 'deg': Math.PI / 180, 'rad': 1 };
    var chargeToC = { 'C': 1, 'e': 1.602176634e-19 };
    var massToKg = { 'kg': 1, 'g': 0.001 };
    var velocityToMs = { 'm/s': 1 };

    var canvas, ctx;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.fluid-tab.active');
        return t ? t.getAttribute('data-tab') : 'field';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e6) return (x / 1e6).toFixed(decimals) + ' M';
        if (Math.abs(x) >= 1e3) return (x / 1e3).toFixed(decimals) + ' k';
        if (Math.abs(x) < 0.01 && x !== 0) return x.toExponential(2);
        return x.toFixed(decimals);
    }

    function formatField(B) {
        if (B >= 1) return formatNum(B) + ' T';
        if (B >= 1e-3) return (B / 1e-3).toFixed(2) + ' mT';
        return formatNum(B) + ' T';
    }

    function formatFlux(Phi) {
        if (Phi >= 1) return formatNum(Phi) + ' Wb';
        if (Phi >= 1e-3) return (Phi / 1e-3).toFixed(2) + ' mWb';
        return formatNum(Phi) + ' Wb';
    }

    function getValuesField() {
        var type = document.getElementById('field-type').value;
        var iRaw = parseFloat(document.getElementById('field-i').value) || 0;
        var iUnit = document.getElementById('field-i-unit').value;
        var rRaw = parseFloat(document.getElementById('field-r').value) || 0;
        var rUnit = document.getElementById('field-r-unit').value;
        var nRaw = parseFloat(document.getElementById('field-n').value) || 0;
        var nUnit = document.getElementById('field-n-unit').value;
        var I = iRaw * (currentToA[iUnit] || 1);
        var r = rRaw * (distToM[rUnit] || 1);
        var n = nRaw * (nUnit === 'turns/m' ? 1 : 0);
        var B = 0;
        if (type === 'wire') {
            B = r > 0 ? (mu0 * I) / (2 * Math.PI * r) : 0;
        } else if (type === 'loop') {
            B = r > 0 ? (mu0 * I) / (2 * r) : 0;
        } else if (type === 'solenoid') {
            B = mu0 * n * I;
        }
        return { type: type, I: I, r: r, n: n, B: B };
    }

    function getValuesForce() {
        var iRaw = parseFloat(document.getElementById('force-i').value) || 0;
        var iUnit = document.getElementById('force-i-unit').value;
        var lRaw = parseFloat(document.getElementById('force-l').value) || 0;
        var lUnit = document.getElementById('force-l-unit').value;
        var bRaw = parseFloat(document.getElementById('force-b').value) || 0;
        var bUnit = document.getElementById('force-b-unit').value;
        var thetaRaw = parseFloat(document.getElementById('force-theta').value) || 0;
        var thetaUnit = document.getElementById('force-theta-unit').value;
        var I = iRaw * (currentToA[iUnit] || 1);
        var L = lRaw * (distToM[lUnit] || 1);
        var B = bRaw * (fieldToT[bUnit] || 1);
        var theta = thetaRaw * (angleToRad[thetaUnit] || 1);
        var F = I * L * B * Math.sin(theta);
        return { I: I, L: L, B: B, theta: theta, F: F };
    }

    function getValuesTorque() {
        var iRaw = parseFloat(document.getElementById('torque-i').value) || 0;
        var iUnit = document.getElementById('torque-i-unit').value;
        var aRaw = parseFloat(document.getElementById('torque-a').value) || 0;
        var aUnit = document.getElementById('torque-a-unit').value;
        var bRaw = parseFloat(document.getElementById('torque-b').value) || 0;
        var bUnit = document.getElementById('torque-b-unit').value;
        var thetaRaw = parseFloat(document.getElementById('torque-theta').value) || 0;
        var thetaUnit = document.getElementById('torque-theta-unit').value;
        var I = iRaw * (currentToA[iUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var B = bRaw * (fieldToT[bUnit] || 1);
        var theta = thetaRaw * (angleToRad[thetaUnit] || 1);
        var m = I * A;
        var tau = m * B * Math.sin(theta);
        return { I: I, A: A, B: B, theta: theta, m: m, tau: tau };
    }

    function getValuesFlux() {
        var bRaw = parseFloat(document.getElementById('flux-b').value) || 0;
        var bUnit = document.getElementById('flux-b-unit').value;
        var aRaw = parseFloat(document.getElementById('flux-a').value) || 0;
        var aUnit = document.getElementById('flux-a-unit').value;
        var thetaRaw = parseFloat(document.getElementById('flux-theta').value) || 0;
        var thetaUnit = document.getElementById('flux-theta-unit').value;
        var nRaw = parseFloat(document.getElementById('flux-n').value) || 1;
        var B = bRaw * (fieldToT[bUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var theta = thetaRaw * (angleToRad[thetaUnit] || 1);
        var Phi = B * A * Math.cos(theta);
        var NPhi = nRaw * Phi;
        return { B: B, A: A, theta: theta, N: nRaw, Phi: Phi, NPhi: NPhi };
    }

    function getValuesMoment() {
        var iRaw = parseFloat(document.getElementById('moment-i').value) || 0;
        var iUnit = document.getElementById('moment-i-unit').value;
        var aRaw = parseFloat(document.getElementById('moment-a').value) || 0;
        var aUnit = document.getElementById('moment-a-unit').value;
        var I = iRaw * (currentToA[iUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var m = I * A;
        return { I: I, A: A, m: m };
    }

    function getValuesCyclotron() {
        var type = document.getElementById('cyclo-type').value;
        var mRaw = parseFloat(document.getElementById('cyclo-m').value) || 0;
        var mUnit = document.getElementById('cyclo-m-unit').value;
        var qRaw = parseFloat(document.getElementById('cyclo-q').value) || 0;
        var qUnit = document.getElementById('cyclo-q-unit').value;
        var bRaw = parseFloat(document.getElementById('cyclo-b').value) || 0;
        var bUnit = document.getElementById('cyclo-b-unit').value;
        var vRaw = parseFloat(document.getElementById('cyclo-v').value) || 0;
        var vUnit = document.getElementById('cyclo-v-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var q = qRaw * (chargeToC[qUnit] || 1);
        var B = bRaw * (fieldToT[bUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var r = 0;
        var f = 0;
        if (type === 'radius') {
            r = (q > 0 && B > 0) ? (m * v) / (q * B) : 0;
        } else {
            f = (q > 0 && B > 0 && m > 0) ? (q * B) / (2 * Math.PI * m) : 0;
        }
        return { type: type, m: m, q: q, B: B, v: v, r: r, f: f };
    }

    function calcField() {
        var v = getValuesField();
        var el = document.getElementById('field-result');
        if (el) el.textContent = formatField(v.B);
        // Show/hide relevant inputs
        var rSection = document.getElementById('field-r-section');
        var nSection = document.getElementById('field-n-section');
        if (rSection) rSection.style.display = v.type === 'solenoid' ? 'none' : 'block';
        if (nSection) nSection.style.display = v.type === 'solenoid' ? 'block' : 'none';
        return v;
    }

    function calcForce() {
        var v = getValuesForce();
        var el = document.getElementById('force-result');
        if (el) el.textContent = formatNum(v.F) + ' N';
        return v;
    }

    function calcTorque() {
        var v = getValuesTorque();
        var el = document.getElementById('torque-result');
        if (el) el.textContent = formatNum(v.tau) + ' N·m';
        return v;
    }

    function calcFlux() {
        var v = getValuesFlux();
        var el = document.getElementById('flux-result');
        if (el) {
            if (v.N > 1) {
                el.textContent = formatFlux(v.NPhi) + ' (NΦ)';
            } else {
                el.textContent = formatFlux(v.Phi);
            }
        }
        return v;
    }

    function calcMoment() {
        var v = getValuesMoment();
        var el = document.getElementById('moment-result');
        if (el) el.textContent = formatNum(v.m) + ' A·m²';
        return v;
    }

    function calcCyclotron() {
        var v = getValuesCyclotron();
        var el = document.getElementById('cyclo-result');
        var labelEl = document.getElementById('cyclo-result-label');
        var vSection = document.getElementById('cyclo-v-section');
        if (v.type === 'radius') {
            if (el) el.textContent = formatNum(v.r) + ' m';
            if (labelEl) labelEl.textContent = 'Radius';
            if (vSection) vSection.style.display = 'block';
        } else {
            if (el) el.textContent = formatNum(v.f) + ' Hz';
            if (labelEl) labelEl.textContent = 'Frequency';
            if (vSection) vSection.style.display = 'none';
        }
        return v;
    }

    function buildStepsField(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var formula = '';
        var desc = '';
        if (v.type === 'wire') {
            formula = 'B = μ₀ I / (2 π r)';
            desc = 'Straight wire at distance r';
        } else if (v.type === 'loop') {
            formula = 'B = μ₀ I / (2 R)';
            desc = 'Circular loop center';
        } else {
            formula = 'B = μ₀ n I';
            desc = 'Solenoid (n = turns/m)';
        }
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, ' + (v.type === 'solenoid' ? 'Turns/m <span class="highlight">n = ' + formatNum(v.n) + ' turns/m</span>' : 'Distance/Radius <span class="highlight">r = ' + formatNum(v.r) + ' m</span>') + ', μ₀ = 4π × 10⁻⁷ T·m/A</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (' + desc + ')</div>'
            + '<div class="step-formula">' + formula + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">B = ' + (v.type === 'solenoid' ? '4π × 10⁻⁷ × ' + formatNum(v.n) + ' × ' + formatNum(v.I) : '4π × 10⁻⁷ × ' + formatNum(v.I) + ' / (2 × π × ' + formatNum(v.r) + ')') + ' = ' + formatField(v.B) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Magnetic Field </span><span class="step-result-value">B = ' + formatField(v.B) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsForce(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, Length <span class="highlight">L = ' + formatNum(v.L) + ' m</span>, Field <span class="highlight">B = ' + formatField(v.B) + '</span>, Angle <span class="highlight">θ = ' + formatNum(v.theta * 180 / Math.PI) + '°</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">F = I L B sin θ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">F = ' + formatNum(v.I) + ' × ' + formatNum(v.L) + ' × ' + formatNum(v.B) + ' × sin(' + formatNum(v.theta * 180 / Math.PI) + '°) = ' + formatNum(v.F) + ' N</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Force </span><span class="step-result-value">F = ' + formatNum(v.F) + ' N</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsTorque(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span>, Field <span class="highlight">B = ' + formatField(v.B) + '</span>, Angle <span class="highlight">θ = ' + formatNum(v.theta * 180 / Math.PI) + '°</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Magnetic Moment</div>'
            + '<div class="step-calc">m = I A = ' + formatNum(v.I) + ' × ' + formatNum(v.A) + ' = ' + formatNum(v.m) + ' A·m²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">τ = m B sin θ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Torque </span><span class="step-result-value">τ = ' + formatNum(v.tau) + ' N·m</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsFlux(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Field <span class="highlight">B = ' + formatField(v.B) + '</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span>, Angle <span class="highlight">θ = ' + formatNum(v.theta * 180 / Math.PI) + '°</span>, Turns <span class="highlight">N = ' + v.N + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Φ = B A cos θ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Φ = ' + formatNum(v.B) + ' × ' + formatNum(v.A) + ' × cos(' + formatNum(v.theta * 180 / Math.PI) + '°) = ' + formatFlux(v.Phi) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Magnetic Flux </span><span class="step-result-value">' + (v.N > 1 ? 'NΦ = ' + formatFlux(v.NPhi) : 'Φ = ' + formatFlux(v.Phi)) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsMoment(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Current <span class="highlight">I = ' + formatNum(v.I) + ' A</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">m = I A</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">m = ' + formatNum(v.I) + ' × ' + formatNum(v.A) + ' = ' + formatNum(v.m) + ' A·m²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Magnetic Moment </span><span class="step-result-value">m = ' + formatNum(v.m) + ' A·m²</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsCyclotron(v) {
        var body = document.getElementById('magnetic-steps-body');
        if (!body) return;
        var html = '';
        if (v.type === 'radius') {
            html = ''
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
                + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Charge <span class="highlight">q = ' + formatNum(v.q) + ' C</span>, Field <span class="highlight">B = ' + formatField(v.B) + '</span>, Velocity <span class="highlight">v = ' + formatNum(v.v) + ' m/s</span></div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
                + '<div class="step-formula">r = m v / (q B)</div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
                + '<div class="step-calc">r = (' + formatNum(v.m) + ' × ' + formatNum(v.v) + ') / (' + formatNum(v.q) + ' × ' + formatNum(v.B) + ') = ' + formatNum(v.r) + ' m</div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">4</span>Result</div>'
                + '<div class="step-calc"><span class="step-result-label">Radius </span><span class="step-result-value">r = ' + formatNum(v.r) + ' m</span></div>'
                + '</div>';
        } else {
            html = ''
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
                + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Charge <span class="highlight">q = ' + formatNum(v.q) + ' C</span>, Field <span class="highlight">B = ' + formatField(v.B) + '</span></div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
                + '<div class="step-formula">f = q B / (2 π m)</div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
                + '<div class="step-calc">f = (' + formatNum(v.q) + ' × ' + formatNum(v.B) + ') / (2 × π × ' + formatNum(v.m) + ') = ' + formatNum(v.f) + ' Hz</div>'
                + '</div>'
                + '<div class="step-item">'
                + '<div class="step-title"><span class="step-number">4</span>Result</div>'
                + '<div class="step-calc"><span class="step-result-label">Frequency </span><span class="step-result-value">f = ' + formatNum(v.f) + ' Hz</span></div>'
                + '</div>';
        }
        body.innerHTML = html;
    }

    function drawFieldViz(w, h, type, B, I, r, n) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        var cx = w / 2;
        var cy = h / 2;
        
        if (type === 'wire') {
            // Draw wire (vertical line)
            ctx.strokeStyle = '#9333ea';
            ctx.lineWidth = 4;
            ctx.beginPath();
            ctx.moveTo(cx, cy - 80);
            ctx.lineTo(cx, cy + 80);
            ctx.stroke();
            
            // Draw field lines (circles around wire)
            ctx.strokeStyle = '#7c3aed';
            ctx.lineWidth = 2;
            for (var i = 1; i <= 3; i++) {
                var radius = 20 + i * 15;
                ctx.beginPath();
                ctx.arc(cx, cy, radius, 0, Math.PI * 2);
                ctx.stroke();
            }
            
            // Current direction indicator
            ctx.fillStyle = '#9333ea';
            ctx.beginPath();
            ctx.moveTo(cx - 5, cy - 75);
            ctx.lineTo(cx, cy - 85);
            ctx.lineTo(cx + 5, cy - 75);
            ctx.fill();
        } else if (type === 'loop') {
            // Draw circular loop
            ctx.strokeStyle = '#9333ea';
            ctx.lineWidth = 4;
            var loopR = Math.min(60, r * 500);
            ctx.beginPath();
            ctx.arc(cx, cy, loopR, 0, Math.PI * 2);
            ctx.stroke();
            
            // Field lines at center
            ctx.strokeStyle = '#7c3aed';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(cx - 30, cy);
            ctx.lineTo(cx + 30, cy);
            ctx.moveTo(cx, cy - 30);
            ctx.lineTo(cx, cy + 30);
            ctx.stroke();
            
            // Current direction
            ctx.fillStyle = '#9333ea';
            ctx.font = 'bold 12px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('I', cx + loopR + 10, cy);
        } else {
            // Draw solenoid (coils)
            ctx.strokeStyle = '#9333ea';
            ctx.lineWidth = 3;
            var coilW = 100;
            var coilH = 40;
            var x1 = cx - coilW / 2;
            var y1 = cy - coilH / 2;
            var coils = 5;
            for (var i = 0; i < coils; i++) {
                var x = x1 + (i * coilW / (coils - 1));
                ctx.beginPath();
                ctx.arc(x, y1, 8, 0, Math.PI * 2);
                ctx.stroke();
                ctx.beginPath();
                ctx.arc(x, y1 + coilH, 8, 0, Math.PI * 2);
                ctx.stroke();
            }
            
            // Field lines (parallel inside)
            ctx.strokeStyle = '#7c3aed';
            ctx.lineWidth = 2;
            for (var j = 0; j < 3; j++) {
                var y = cy - 10 + j * 10;
                ctx.beginPath();
                ctx.moveTo(x1, y);
                ctx.lineTo(x1 + coilW, y);
                ctx.stroke();
            }
        }
        
        // Label
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('B = ' + formatField(B), w / 2, 30);
    }

    function drawForceViz(w, h, F, I, L, B) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw wire
        var cy = h / 2;
        var wireLen = Math.min(150, L * 300);
        var x1 = (w - wireLen) / 2;
        var x2 = x1 + wireLen;
        
        ctx.strokeStyle = '#9333ea';
        ctx.lineWidth = 4;
        ctx.beginPath();
        ctx.moveTo(x1, cy);
        ctx.lineTo(x2, cy);
        ctx.stroke();
        
        // Draw field lines (vertical)
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 1;
        for (var i = 0; i < 5; i++) {
            var x = x1 + (i * wireLen / 4);
            ctx.beginPath();
            ctx.moveTo(x, cy - 40);
            ctx.lineTo(x, cy + 40);
            ctx.stroke();
        }
        
        // Force arrow (perpendicular)
        ctx.strokeStyle = '#dc2626';
        ctx.fillStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx, cy - 50);
        ctx.lineTo(cx - 5, cy - 40);
        ctx.moveTo(cx, cy - 50);
        ctx.lineTo(cx + 5, cy - 40);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('F = ' + formatNum(F) + ' N', w / 2, 30);
    }

    function drawTorqueViz(w, h, tau, m, B) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw current loop (rectangle)
        var cx = w / 2;
        var cy = h / 2;
        var loopW = 80;
        var loopH = 60;
        
        ctx.strokeStyle = '#9333ea';
        ctx.lineWidth = 3;
        ctx.strokeRect(cx - loopW/2, cy - loopH/2, loopW, loopH);
        
        // Current direction arrows
        ctx.fillStyle = '#9333ea';
        ctx.beginPath();
        ctx.moveTo(cx - loopW/2 + 10, cy - loopH/2);
        ctx.lineTo(cx - loopW/2, cy - loopH/2 - 5);
        ctx.lineTo(cx - loopW/2 + 20, cy - loopH/2);
        ctx.fill();
        
        // Field lines
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 2;
        for (var i = 0; i < 3; i++) {
            var y = cy - 20 + i * 20;
            ctx.beginPath();
            ctx.moveTo(cx - 60, y);
            ctx.lineTo(cx + 60, y);
            ctx.stroke();
        }
        
        // Torque indicator (curved arrow)
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.arc(cx, cy, 50, -Math.PI/4, Math.PI/4);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('τ = ' + formatNum(tau) + ' N·m', w / 2, 30);
    }

    function drawFluxViz(w, h, Phi, B, A) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw area (rectangle)
        var cx = w / 2;
        var cy = h / 2;
        var areaW = Math.min(100, Math.sqrt(A) * 1000);
        var areaH = areaW;
        
        ctx.fillStyle = 'rgba(147,51,234,0.2)';
        ctx.fillRect(cx - areaW/2, cy - areaH/2, areaW, areaH);
        ctx.strokeStyle = '#9333ea';
        ctx.lineWidth = 2;
        ctx.strokeRect(cx - areaW/2, cy - areaH/2, areaW, areaH);
        
        // Field lines (parallel)
        ctx.strokeStyle = '#7c3aed';
        ctx.lineWidth = 2;
        for (var i = 0; i < 5; i++) {
            var y = cy - areaH/2 + (i * areaH / 4);
            ctx.beginPath();
            ctx.moveTo(cx - areaW/2 - 20, y);
            ctx.lineTo(cx + areaW/2 + 20, y);
            ctx.stroke();
        }
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Φ = ' + formatFlux(Phi), w / 2, 30);
    }

    function drawMomentViz(w, h, m, I, A) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw current loop
        var cx = w / 2;
        var cy = h / 2;
        var loopR = Math.min(50, Math.sqrt(A / Math.PI) * 100);
        
        ctx.strokeStyle = '#9333ea';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(cx, cy, loopR, 0, Math.PI * 2);
        ctx.stroke();
        
        // Magnetic moment vector (perpendicular arrow)
        ctx.strokeStyle = '#dc2626';
        ctx.fillStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx, cy - loopR - 30);
        ctx.lineTo(cx - 5, cy - loopR - 20);
        ctx.moveTo(cx, cy - loopR - 30);
        ctx.lineTo(cx + 5, cy - loopR - 20);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('m = ' + formatNum(m) + ' A·m²', w / 2, 30);
    }

    function drawCyclotronViz(w, h, type, r, f, m, q, B, v) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        var cx = w / 2;
        var cy = h / 2;
        
        if (type === 'radius') {
            // Draw circular path
            var pathR = Math.min(80, r * 100000);
            ctx.strokeStyle = '#9333ea';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(cx, cy, pathR, 0, Math.PI * 2);
            ctx.stroke();
            
            // Draw particle
            ctx.fillStyle = '#9333ea';
            ctx.beginPath();
            ctx.arc(cx, cy - pathR, 5, 0, Math.PI * 2);
            ctx.fill();
            
            // Velocity arrow (tangent)
            ctx.strokeStyle = '#10b981';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(cx + 5, cy - pathR);
            ctx.lineTo(cx + 20, cy - pathR);
            ctx.lineTo(cx + 15, cy - pathR - 5);
            ctx.moveTo(cx + 20, cy - pathR);
            ctx.lineTo(cx + 15, cy - pathR + 5);
            ctx.stroke();
            
            // Field lines (into page)
            ctx.fillStyle = '#7c3aed';
            ctx.font = 'bold 16px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('×', cx, cy);
            
            // Labels
            ctx.fillStyle = '#0f172a';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.fillText('r = ' + formatNum(r) + ' m', w / 2, 30);
        } else {
            // Draw frequency indicator (oscillating)
            var t = Date.now() / 1000;
            var amp = 30;
            var freq = f;
            var y = cy + amp * Math.sin(t * freq * 2 * Math.PI);
            
            ctx.strokeStyle = '#9333ea';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(cx - 40, cy);
            ctx.lineTo(cx + 40, cy);
            ctx.stroke();
            
            ctx.fillStyle = '#9333ea';
            ctx.beginPath();
            ctx.arc(cx, y, 8, 0, Math.PI * 2);
            ctx.fill();
            
            // Labels
            ctx.fillStyle = '#0f172a';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('f = ' + formatNum(f) + ' Hz', w / 2, 30);
        }
    }

    function drawViz(tab, data) {
        var c = document.getElementById('fluid-viz-container');
        var pills = document.getElementById('fluid-viz-pills');
        if (!c || !canvas || !ctx) return;
        
        var containerWidth = c.offsetWidth || 600;
        var containerHeight = c.offsetHeight || 300;
        canvas.width = containerWidth;
        canvas.height = containerHeight;
        var w = canvas.width;
        var h = canvas.height;
        
        if (tab === 'field') {
            var demoB = data.B || 1e-5;
            var demoI = data.I || 5;
            var demoR = data.r || 0.1;
            var demoN = data.n || 1000;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">B = ' + formatField(demoB) + '</span><span class="fluid-viz-pill">I = ' + formatNum(demoI) + ' A</span>';
            drawFieldViz(w, h, data.type || 'wire', demoB, demoI, demoR, demoN);
        } else if (tab === 'force') {
            var demoF = data.F || 0.01;
            var demoI = data.I || 2;
            var demoL = data.L || 0.5;
            var demoB = data.B || 0.01;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">F = ' + formatNum(demoF) + ' N</span><span class="fluid-viz-pill">B = ' + formatField(demoB) + '</span>';
            drawForceViz(w, h, demoF, demoI, demoL, demoB);
        } else if (tab === 'torque') {
            var demoTau = data.tau || 1e-5;
            var demoM = data.m || 0.01;
            var demoB = data.B || 0.01;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">τ = ' + formatNum(demoTau) + ' N·m</span><span class="fluid-viz-pill">m = ' + formatNum(demoM) + ' A·m²</span>';
            drawTorqueViz(w, h, demoTau, demoM, demoB);
        } else if (tab === 'flux') {
            var demoPhi = data.Phi || 1e-4;
            var demoB = data.B || 0.01;
            var demoA = data.A || 0.01;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">Φ = ' + formatFlux(demoPhi) + '</span><span class="fluid-viz-pill">B = ' + formatField(demoB) + '</span>';
            drawFluxViz(w, h, demoPhi, demoB, demoA);
        } else if (tab === 'moment') {
            var demoM = data.m || 0.01;
            var demoI = data.I || 1;
            var demoA = data.A || 0.01;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">m = ' + formatNum(demoM) + ' A·m²</span><span class="fluid-viz-pill">I = ' + formatNum(demoI) + ' A</span>';
            drawMomentViz(w, h, demoM, demoI, demoA);
        } else if (tab === 'cyclotron') {
            var demoR = data.r || 5.69e-4;
            var demoF = data.f || 2.8e9;
            var demoM = data.m || 9.11e-31;
            var demoQ = data.q || 1.6e-19;
            var demoB = data.B || 0.01;
            var demoV = data.v || 1e6;
            if (pills) {
                if (data.type === 'radius') {
                    pills.innerHTML = '<span class="fluid-viz-pill">r = ' + formatNum(demoR) + ' m</span><span class="fluid-viz-pill">B = ' + formatField(demoB) + '</span>';
                } else {
                    pills.innerHTML = '<span class="fluid-viz-pill">f = ' + formatNum(demoF) + ' Hz</span><span class="fluid-viz-pill">B = ' + formatField(demoB) + '</span>';
                }
            }
            drawCyclotronViz(w, h, data.type || 'radius', demoR, demoF, demoM, demoQ, demoB, demoV);
        }
    }

    function runMagnetism() {
        var tab = getActiveTab();
        if (tab === 'field') {
            var v = calcField();
            drawViz('field', v);
            buildStepsField(v);
        } else if (tab === 'force') {
            var v = calcForce();
            drawViz('force', v);
            buildStepsForce(v);
        } else if (tab === 'torque') {
            var v = calcTorque();
            drawViz('torque', v);
            buildStepsTorque(v);
        } else if (tab === 'flux') {
            var v = calcFlux();
            drawViz('flux', v);
            buildStepsFlux(v);
        } else if (tab === 'moment') {
            var v = calcMoment();
            drawViz('moment', v);
            buildStepsMoment(v);
        } else if (tab === 'cyclotron') {
            var v = calcCyclotron();
            drawViz('cyclotron', v);
            buildStepsCyclotron(v);
        }
    }
    window.runMagnetism = runMagnetism;

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('magnetic-steps-body');
        var toggle = document.getElementById('magnetic-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }
    window.toggleMagneticSteps = toggleSteps;

    function switchMagneticTab(tab, btn) {
        if (!tab) return;
        
        document.querySelectorAll('.fluid-tab').forEach(function (b) { 
            b.classList.remove('active'); 
        });
        document.querySelectorAll('.fluid-panel').forEach(function (p) { 
            p.classList.remove('active'); 
        });
        
        if (btn) btn.classList.add('active');
        var panel = document.getElementById('panel-' + tab);
        if (panel) {
            panel.classList.add('active');
        }
        
        setTimeout(function() {
            runMagnetism();
        }, 10);
    }
    window.switchMagneticTab = switchMagneticTab;

    function bindTabs() {
        var tabs = document.querySelectorAll('.fluid-tab');
        if (tabs.length === 0) {
            setTimeout(bindTabs, 100);
            return;
        }
        
        tabs.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                switchMagneticTab(tab, this);
            });
        });
    }

    // Handle field type change
    function bindFieldType() {
        var fieldType = document.getElementById('field-type');
        if (fieldType) {
            fieldType.addEventListener('change', function() {
                runMagnetism();
            });
        }
    }

    // Handle cyclotron type change
    function bindCyclotronType() {
        var cycloType = document.getElementById('cyclo-type');
        if (cycloType) {
            cycloType.addEventListener('change', function() {
                runMagnetism();
            });
        }
    }

    function init() {
        bindTabs();
        bindFieldType();
        bindCyclotronType();
        
        canvas = document.getElementById('fluid-viz-canvas');
        if (canvas) {
            ctx = canvas.getContext('2d');
        }
        
        function ensureCanvasSize() {
            var c = document.getElementById('fluid-viz-container');
            if (c && canvas && ctx) {
                var w = Math.max(c.offsetWidth || 600, 400);
                var h = Math.max(c.offsetHeight || 300, 250);
                if (w > 0 && h > 0) {
                    canvas.width = w;
                    canvas.height = h;
                    runMagnetism();
                    return true;
                }
            }
            return false;
        }
        
        if (!ensureCanvasSize()) {
            setTimeout(function() {
                if (!ensureCanvasSize()) {
                    setTimeout(ensureCanvasSize, 300);
                }
            }, 100);
        }
        
        setTimeout(function() {
            setInterval(function() {
                if (!canvas || !ctx) return;
                var tab = getActiveTab();
                if (tab) {
                    var data = null;
                    try {
                        if (tab === 'field') data = getValuesField();
                        else if (tab === 'force') data = getValuesForce();
                        else if (tab === 'torque') data = getValuesTorque();
                        else if (tab === 'flux') data = getValuesFlux();
                        else if (tab === 'moment') data = getValuesMoment();
                        else if (tab === 'cyclotron') data = getValuesCyclotron();
                        if (data) drawViz(tab, data);
                    } catch (e) {
                        console.error('Error updating visualization:', e);
                    }
                }
            }, 50);
        }, 300);
    }

    function startInit() {
        try {
            init();
        } catch (e) {
            console.error('Error initializing magnetism:', e);
            setTimeout(bindTabs, 100);
        }
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startInit);
    } else {
        startInit();
    }
})();
