/**
 * Wave Formulas - calculators, Matter.js animations, step-by-step, Chart.js
 * v = fλ, standing waves, Doppler, interference, beats, EM waves
 */
(function () {
    'use strict';

    var c = 299792458;
    var gamma_air = 1.4;
    var R = 8.314;
    var M_air = 0.029;

    var freqToHz = { 'Hz': 1, 'kHz': 1000, 'MHz': 1000000, 'THz': 1e12 };
    var lambdaToM = { 'm': 1, 'cm': 0.01, 'nm': 1e-9 };
    var velocityToMs = { 'm/s': 1, 'km/h': 1 / 3.6 };
    var distToM = { 'm': 1, 'cm': 0.01 };

    var canvas, ctx;
    var waveChart = null;
    var stepsExpanded = false;
    var matterEngine = null;
    var matterRender = null;
    var matterRunner = null;
    var waveParticles = [];

    function getActiveTab() {
        var t = document.querySelector('.wave-tab.active');
        return t ? t.getAttribute('data-tab') : 'basic';
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

    function formatSpeed(x) {
        if (x >= 1000) return formatNum(x / 1000) + ' km/s';
        return formatNum(x) + ' m/s';
    }

    function formatFreq(x) {
        if (x >= 1e12) return formatNum(x / 1e12) + ' THz';
        if (x >= 1e9) return formatNum(x / 1e9) + ' GHz';
        if (x >= 1e6) return formatNum(x / 1e6) + ' MHz';
        if (x >= 1000) return formatNum(x / 1000) + ' kHz';
        return formatNum(x) + ' Hz';
    }

    function formatLambda(x) {
        if (x >= 1) return formatNum(x) + ' m';
        if (x >= 0.01) return formatNum(x * 100) + ' cm';
        if (x >= 1e-6) return formatNum(x * 1e6) + ' μm';
        return formatNum(x * 1e9) + ' nm';
    }

    function getValuesBasic() {
        var fRaw = parseFloat(document.getElementById('basic-f').value) || 0;
        var fUnit = document.getElementById('basic-f-unit').value;
        var lambdaRaw = parseFloat(document.getElementById('basic-lambda').value) || 0;
        var lambdaUnit = document.getElementById('basic-lambda-unit').value;
        var f = fRaw * (freqToHz[fUnit] || 1);
        var lambda = lambdaRaw * (lambdaToM[lambdaUnit] || 1);
        var v = f * lambda;
        return { f: f, fraw: fRaw, funit: fUnit, lambda: lambda, lambdaraw: lambdaRaw, lambdaunit: lambdaUnit, v: v };
    }

    function getValuesStanding() {
        var lRaw = parseFloat(document.getElementById('stand-l').value) || 0;
        var lUnit = document.getElementById('stand-l-unit').value;
        var n = parseInt(document.getElementById('stand-n').value) || 1;
        var vRaw = parseFloat(document.getElementById('stand-v').value) || 0;
        var vUnit = document.getElementById('stand-v-unit').value;
        var L = lRaw * (distToM[lUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var lambda = (2 * L) / n;
        var f = (n * v) / (2 * L);
        return { L: L, lraw: lRaw, lunit: lUnit, n: n, v: v, vraw: vRaw, vunit: vUnit, lambda: lambda, f: f };
    }

    function getValuesSound() {
        var tRaw = parseFloat(document.getElementById('sound-t').value) || 0;
        var tUnit = document.getElementById('sound-t-unit').value;
        var T = tUnit === 'K' ? tRaw : tRaw + 273.15;
        var v = Math.sqrt(gamma_air * R * T / M_air);
        return { T: T, traw: tRaw, tunit: tUnit, v: v };
    }

    function getValuesDoppler() {
        var fRaw = parseFloat(document.getElementById('dop-f').value) || 0;
        var fUnit = document.getElementById('dop-f-unit').value;
        var vRaw = parseFloat(document.getElementById('dop-v').value) || 0;
        var vsRaw = parseFloat(document.getElementById('dop-vs').value) || 0;
        var voRaw = parseFloat(document.getElementById('dop-vo').value) || 0;
        var vsDir = parseInt(document.getElementById('dop-vs-dir').value) || 1;
        var voDir = parseInt(document.getElementById('dop-vo-dir').value) || 1;
        var f = fRaw * (freqToHz[fUnit] || 1);
        var v = vRaw * (velocityToMs[document.getElementById('dop-v-unit').value] || 1);
        var vs = vsRaw * (velocityToMs[document.getElementById('dop-vs-unit').value] || 1) * vsDir;
        var vo = voRaw * (velocityToMs[document.getElementById('dop-vo-unit').value] || 1) * voDir;
        var fprime = f * (v + vo) / (v - vs);
        return { f: f, fraw: fRaw, funit: fUnit, v: v, vs: vs, vo: vo, fprime: fprime };
    }

    function getValuesInterference() {
        var a1 = parseFloat(document.getElementById('int-a1').value) || 0;
        var a2 = parseFloat(document.getElementById('int-a2').value) || 0;
        var deltaRaw = parseFloat(document.getElementById('int-delta').value) || 0;
        var deltaUnit = document.getElementById('int-delta-unit').value;
        var delta = deltaUnit === 'deg' ? (deltaRaw * Math.PI) / 180 : deltaRaw;
        var A = Math.sqrt(a1 * a1 + a2 * a2 + 2 * a1 * a2 * Math.cos(delta));
        return { a1: a1, a2: a2, delta: delta, deltaraw: deltaRaw, deltaunit: deltaUnit, A: A };
    }

    function getValuesBeats() {
        var f1Raw = parseFloat(document.getElementById('beat-f1').value) || 0;
        var f2Raw = parseFloat(document.getElementById('beat-f2').value) || 0;
        var f1Unit = document.getElementById('beat-f1-unit').value;
        var f2Unit = document.getElementById('beat-f2-unit').value;
        var f1 = f1Raw * (freqToHz[f1Unit] || 1);
        var f2 = f2Raw * (freqToHz[f2Unit] || 1);
        var fbeat = Math.abs(f1 - f2);
        return { f1: f1, f1raw: f1Raw, f1unit: f1Unit, f2: f2, f2raw: f2Raw, f2unit: f2Unit, fbeat: fbeat };
    }

    function getValuesEM() {
        var fRaw = parseFloat(document.getElementById('em-f').value) || 0;
        var fUnit = document.getElementById('em-f-unit').value;
        var f = fRaw * (freqToHz[fUnit] || 1);
        var lambda = c / f;
        return { f: f, fraw: fRaw, funit: fUnit, lambda: lambda, c: c };
    }

    function calcBasic() {
        var v = getValuesBasic();
        var el = document.getElementById('basic-v');
        if (el) el.textContent = formatSpeed(v.v);
        return v;
    }

    function calcStanding() {
        var v = getValuesStanding();
        var el = document.getElementById('stand-result');
        if (el) el.textContent = 'λ = ' + formatLambda(v.lambda) + ', f = ' + formatFreq(v.f);
        return v;
    }

    function calcSound() {
        var v = getValuesSound();
        var el = document.getElementById('sound-v');
        if (el) el.textContent = formatSpeed(v.v);
        return v;
    }

    function calcDoppler() {
        var v = getValuesDoppler();
        var el = document.getElementById('dop-fprime');
        if (el) el.textContent = formatFreq(v.fprime);
        return v;
    }

    function calcInterference() {
        var v = getValuesInterference();
        var el = document.getElementById('int-a');
        if (el) el.textContent = formatNum(v.A) + ' m';
        return v;
    }

    function calcBeats() {
        var v = getValuesBeats();
        var el = document.getElementById('beat-f');
        if (el) el.textContent = formatFreq(v.fbeat);
        return v;
    }

    function calcEM() {
        var v = getValuesEM();
        var el = document.getElementById('em-lambda');
        if (el) el.textContent = formatLambda(v.lambda);
        return v;
    }

    function buildStepsBasic(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Frequency <span class="highlight">f = ' + formatFreq(v.f) + '</span>, Wavelength <span class="highlight">λ = ' + formatLambda(v.lambda) + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">v = f λ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">v = ' + formatFreq(v.f) + ' × ' + formatLambda(v.lambda) + ' = ' + formatSpeed(v.v) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Wave speed </span><span class="step-result-value">v = ' + formatSpeed(v.v) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsStanding(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Length <span class="highlight">L = ' + formatNum(v.L) + ' m</span>, Harmonic <span class="highlight">n = ' + v.n + '</span>, Speed <span class="highlight">v = ' + formatSpeed(v.v) + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">λₙ = 2L / n, fₙ = n v / (2L)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">λ = 2 × ' + formatNum(v.L) + ' / ' + v.n + ' = ' + formatLambda(v.lambda) + '</div>'
            + '<div class="step-calc">f = ' + v.n + ' × ' + formatSpeed(v.v) + ' / (2 × ' + formatNum(v.L) + ') = ' + formatFreq(v.f) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Wavelength </span><span class="step-result-value">λ = ' + formatLambda(v.lambda) + '</span></div>'
            + '<div class="step-calc"><span class="step-result-label">Frequency </span><span class="step-result-value">f = ' + formatFreq(v.f) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsSound(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Temperature <span class="highlight">T = ' + formatNum(v.T) + ' K</span>, γ = 1.4, R = 8.314 J/(mol·K), M = 0.029 kg/mol</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">v = √(γ R T / M)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">v = √(1.4 × 8.314 × ' + formatNum(v.T) + ' / 0.029) = ' + formatSpeed(v.v) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Sound speed </span><span class="step-result-value">v = ' + formatSpeed(v.v) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsDoppler(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Source frequency <span class="highlight">f = ' + formatFreq(v.f) + '</span>, Wave speed <span class="highlight">v = ' + formatSpeed(v.v) + '</span>, Source speed <span class="highlight">v_s = ' + formatSpeed(Math.abs(v.vs)) + '</span>, Observer speed <span class="highlight">v_o = ' + formatSpeed(Math.abs(v.vo)) + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">f&prime; = f (v ± v₀) / (v ± v_s)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">f&prime; = ' + formatFreq(v.f) + ' × (' + formatSpeed(v.v) + ' ' + (v.vo >= 0 ? '+' : '−') + ' ' + formatSpeed(Math.abs(v.vo)) + ') / (' + formatSpeed(v.v) + ' ' + (v.vs >= 0 ? '−' : '+') + ' ' + formatSpeed(Math.abs(v.vs)) + ') = ' + formatFreq(v.fprime) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Observed frequency </span><span class="step-result-value">f&prime; = ' + formatFreq(v.fprime) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsInterference(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Amplitude 1 <span class="highlight">A₁ = ' + formatNum(v.a1) + ' m</span>, Amplitude 2 <span class="highlight">A₂ = ' + formatNum(v.a2) + ' m</span>, Phase difference <span class="highlight">δ = ' + formatNum(v.deltaraw) + ' ' + v.deltaunit + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">A = √(A₁² + A₂² + 2 A₁ A₂ cos δ)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">A = √(' + formatNum(v.a1) + '² + ' + formatNum(v.a2) + '² + 2 × ' + formatNum(v.a1) + ' × ' + formatNum(v.a2) + ' × cos(' + formatNum(v.deltaraw) + ')) = ' + formatNum(v.A) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Resultant amplitude </span><span class="step-result-value">A = ' + formatNum(v.A) + ' m</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsBeats(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Frequency 1 <span class="highlight">f₁ = ' + formatFreq(v.f1) + '</span>, Frequency 2 <span class="highlight">f₂ = ' + formatFreq(v.f2) + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">f_beat = |f₁ − f₂|</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">f_beat = |' + formatFreq(v.f1) + ' − ' + formatFreq(v.f2) + '| = ' + formatFreq(v.fbeat) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Beats frequency </span><span class="step-result-value">f_beat = ' + formatFreq(v.fbeat) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsEM(v) {
        var body = document.getElementById('wave-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given</div>'
            + '<div class="step-calc">Frequency <span class="highlight">f = ' + formatFreq(v.f) + '</span>, c = 3.00×10⁸ m/s</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">c = f λ → λ = c / f</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">λ = 3.00×10⁸ / ' + formatFreq(v.f) + ' = ' + formatLambda(v.lambda) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Wavelength </span><span class="step-result-value">λ = ' + formatLambda(v.lambda) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawBasicWaveViz(w, h, f, lambda, v) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        if (lambda <= 0 || f <= 0) {
            // Show placeholder when values are invalid
            ctx.fillStyle = '#6366f1';
            ctx.font = 'bold 16px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('v = f λ', w / 2, cy);
            return;
        }
        var numWaves = 2;
        var scaleX = (w - 40) / (numWaves * lambda);
        if (scaleX <= 0) scaleX = 1;
        var amplitude = 30;
        ctx.strokeStyle = '#6366f1';
        ctx.lineWidth = 3;
        ctx.beginPath();
        for (var x = 20; x < w - 20; x++) {
            var k = (2 * Math.PI) / lambda;
            var omega = 2 * Math.PI * f;
            var t = Date.now() / 1000;
            var y = cy + amplitude * Math.sin(k * (x - 20) / scaleX - omega * t);
            if (x === 20) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.fillStyle = '#6366f1';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('v = f λ', w / 2, 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('v = ' + formatSpeed(v), w / 2, h - 20);
    }

    function drawStandingWaveViz(w, h, L, n, lambda, f) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var startX = 30;
        var endX = w - 30;
        var cy = h / 2;
        if (lambda <= 0 || f <= 0 || L <= 0 || n <= 0) {
            ctx.fillStyle = '#8b5cf6';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('Standing Wave (n = ' + (n || 1) + ')', w / 2, cy);
            return;
        }
        var amplitude = 40;
        var t = Date.now() / 1000;
        var omega = 2 * Math.PI * f;
        var k = (2 * Math.PI) / lambda;
        ctx.strokeStyle = '#8b5cf6';
        ctx.lineWidth = 3;
        ctx.beginPath();
        for (var x = startX; x <= endX; x++) {
            var xNorm = (x - startX) / (endX - startX) * L;
            var y = cy + amplitude * Math.sin(k * xNorm) * Math.cos(omega * t);
            if (x === startX) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.fillStyle = '#dc2626';
        ctx.fillRect(startX - 5, cy - 3, 10, 6);
        ctx.fillRect(endX - 5, cy - 3, 10, 6);
        ctx.fillStyle = '#8b5cf6';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('n = ' + n + ' (λ = ' + formatLambda(lambda) + ')', w / 2, 30);
    }

    function drawDopplerViz(w, h, f, fprime, vs, vo) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cx = w / 2;
        var cy = h / 2;
        var sourceX = cx - 80;
        var obsX = cx + 80;
        ctx.fillStyle = '#ec4899';
        ctx.beginPath();
        ctx.arc(sourceX, cy, 15, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = '#6366f1';
        ctx.beginPath();
        ctx.arc(obsX, cy, 15, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#6366f1';
        ctx.lineWidth = 2;
        for (var i = 0; i < 5; i++) {
            var r = 20 + i * 15;
            ctx.beginPath();
            ctx.arc(sourceX, cy, r, 0, Math.PI * 2);
            ctx.stroke();
        }
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('f = ' + formatFreq(f || 0), sourceX, cy - 30);
        ctx.fillText('f\' = ' + formatFreq(fprime || 0), obsX, cy - 30);
    }

    function drawInterferenceViz(w, h, a1, a2, delta, A) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        if (a1 <= 0 && a2 <= 0) {
            ctx.fillStyle = '#6366f1';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('Interference Pattern', w / 2, cy);
            return;
        }
        var lambda = 100;
        var k = (2 * Math.PI) / lambda;
        var omega = 0.1;
        var t = Date.now() / 1000;
        ctx.strokeStyle = '#6366f1';
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (var x = 20; x < w - 20; x++) {
            var y1 = cy + (a1 || 0) * 10 * Math.sin(k * (x - 20) - omega * t);
            var y2 = cy + (a2 || 0) * 10 * Math.sin(k * (x - 20) - omega * t + (delta || 0));
            var y = cy + (y1 - cy) + (y2 - cy);
            if (x === 20) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.strokeStyle = '#8b5cf6';
        ctx.lineWidth = 3;
        ctx.beginPath();
        for (var x = 20; x < w - 20; x++) {
            var y = cy + (A || 0) * 10 * Math.sin(k * (x - 20) - omega * t + (delta || 0) / 2);
            if (x === 20) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.fillStyle = '#6366f1';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('A = ' + formatNum(A || 0) + ' m', w / 2, 30);
    }

    function drawBeatsViz(w, h, f1, f2, fbeat) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        if (f1 <= 0 || f2 <= 0) {
            ctx.fillStyle = '#ec4899';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('Beats: f₁ and f₂', w / 2, cy);
            return;
        }
        var t = Date.now() / 1000;
        ctx.strokeStyle = '#6366f1';
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (var x = 20; x < w - 20; x++) {
            var xNorm = (x - 20) / (w - 40);
            var y = cy + 30 * Math.sin(2 * Math.PI * f1 * xNorm * 0.01 - 2 * Math.PI * f1 * t) + 30 * Math.sin(2 * Math.PI * f2 * xNorm * 0.01 - 2 * Math.PI * f2 * t);
            if (x === 20) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.fillStyle = '#ec4899';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('f_beat = ' + formatFreq(fbeat), w / 2, 30);
    }

    function drawEMViz(w, h, f, lambda) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        if (lambda <= 0 || f <= 0) {
            ctx.fillStyle = '#ec4899';
            ctx.font = 'bold 16px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('c = f λ', w / 2, cy);
            return;
        }
        var numWaves = Math.max(1, Math.min(3, Math.floor((w - 40) / lambda)));
        var scaleX = (w - 40) / (numWaves * lambda);
        if (scaleX <= 0) scaleX = 1;
        var amplitude = 30;
        var t = Date.now() / 1000;
        ctx.strokeStyle = '#ec4899';
        ctx.lineWidth = 3;
        ctx.beginPath();
        for (var x = 20; x < w - 20; x++) {
            var k = (2 * Math.PI) / lambda;
            var omega = 2 * Math.PI * f;
            var y = cy + amplitude * Math.sin(k * (x - 20) / scaleX - omega * t);
            if (x === 20) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        }
        ctx.stroke();
        ctx.fillStyle = '#ec4899';
        ctx.font = 'bold 16px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('c = f λ', w / 2, 30);
        ctx.font = '14px Inter, sans-serif';
        ctx.fillText('λ = ' + formatLambda(lambda), w / 2, h - 20);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('wave-viz-container');
        var pills = document.getElementById('wave-viz-pills');
        if (!c || !canvas || !ctx) return;
        
        // Ensure container has dimensions
        var containerWidth = c.offsetWidth || 600;
        var containerHeight = c.offsetHeight || 300;
        canvas.width = containerWidth;
        canvas.height = containerHeight;
        var w = canvas.width;
        var h = canvas.height;
        
        // Use default demo values if inputs are zero/empty
        if (tab === 'basic') {
            var demoF = data.f || 100;
            var demoLambda = data.lambda || 3;
            var demoV = data.v || (demoF * demoLambda);
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">v = ' + formatSpeed(demoV) + '</span><span class="wave-viz-pill">f = ' + formatFreq(demoF) + '</span>';
            drawBasicWaveViz(w, h, demoF, demoLambda, demoV);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        } else if (tab === 'standing') {
            var demoL = data.L || 2;
            var demoN = data.n || 1;
            var demoLambda = data.lambda || (2 * demoL / demoN);
            var demoF = data.f || (demoN * 100 / (2 * demoL));
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">n = ' + demoN + '</span><span class="wave-viz-pill">λ = ' + formatLambda(demoLambda) + '</span>';
            drawStandingWaveViz(w, h, demoL, demoN, demoLambda, demoF);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        } else if (tab === 'sound') {
            var demoT = data.T || 300;
            var demoV = data.v || Math.sqrt(gamma_air * R * demoT / M_air);
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">v = ' + formatSpeed(demoV) + '</span><span class="wave-viz-pill">T = ' + formatNum(demoT) + ' K</span>';
            drawBasicWaveViz(w, h, 1000, demoV / 1000, demoV);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        } else if (tab === 'doppler') {
            var demoF = data.f || 1000;
            var demoFprime = data.fprime || demoF;
            var demoVs = data.vs || 0;
            var demoVo = data.vo || 0;
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">f&prime; = ' + formatFreq(demoFprime) + '</span><span class="wave-viz-pill">f = ' + formatFreq(demoF) + '</span>';
            drawDopplerViz(w, h, demoF, demoFprime, demoVs, demoVo);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        } else if (tab === 'interference') {
            var demoA1 = data.a1 || 1;
            var demoA2 = data.a2 || 1;
            var demoDelta = data.delta || 0;
            var demoA = data.A || Math.sqrt(demoA1 * demoA1 + demoA2 * demoA2 + 2 * demoA1 * demoA2 * Math.cos(demoDelta));
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">A = ' + formatNum(demoA) + ' m</span><span class="wave-viz-pill">δ = ' + formatNum(data.deltaraw || 0) + ' ' + (data.deltaunit || 'rad') + '</span>';
            drawInterferenceViz(w, h, demoA1, demoA2, demoDelta, demoA);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        } else if (tab === 'beats') {
            var demoF1 = data.f1 || 440;
            var demoF2 = data.f2 || 442;
            var demoFbeat = data.fbeat || Math.abs(demoF1 - demoF2);
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">f_beat = ' + formatFreq(demoFbeat) + '</span><span class="wave-viz-pill">f₁ = ' + formatFreq(demoF1) + '</span>';
            drawBeatsViz(w, h, demoF1, demoF2, demoFbeat);
            var demoData = { f1: demoF1, f2: demoF2, fbeat: demoFbeat };
            updateBeatsChart(demoData);
            document.getElementById('wave-chart-wrap').style.display = 'block';
        } else if (tab === 'em') {
            var demoF = data.f || 5e14;
            var demoLambda = data.lambda || (c / demoF);
            if (pills) pills.innerHTML = '<span class="wave-viz-pill">λ = ' + formatLambda(demoLambda) + '</span><span class="wave-viz-pill">f = ' + formatFreq(demoF) + '</span>';
            drawEMViz(w, h, demoF, demoLambda);
            document.getElementById('wave-chart-wrap').style.display = 'none';
        }
    }

    function updateBeatsChart(v) {
        var wrap = document.getElementById('wave-chart-wrap');
        var can = document.getElementById('wave-chart-canvas');
        if (typeof Chart === 'undefined' || !wrap || !can) return;
        var times = [];
        var wave1 = [];
        var wave2 = [];
        var beats = [];
        var maxT = 2 / Math.max(v.fbeat, 0.1);
        for (var t = 0; t <= maxT; t += maxT / 50) {
            times.push(t.toFixed(2) + ' s');
            var w1 = Math.sin(2 * Math.PI * v.f1 * t);
            var w2 = Math.sin(2 * Math.PI * v.f2 * t);
            wave1.push(w1);
            wave2.push(w2);
            beats.push(w1 + w2);
        }
        if (waveChart) waveChart.destroy();
        waveChart = new Chart(can.getContext('2d'), {
            type: 'line',
            data: {
                labels: times,
                datasets: [{
                    label: 'Wave 1 (f₁)',
                    data: wave1,
                    borderColor: '#6366f1',
                    backgroundColor: 'transparent',
                    borderWidth: 1,
                    pointRadius: 0
                }, {
                    label: 'Wave 2 (f₂)',
                    data: wave2,
                    borderColor: '#8b5cf6',
                    backgroundColor: 'transparent',
                    borderWidth: 1,
                    pointRadius: 0
                }, {
                    label: 'Resultant (beats)',
                    data: beats,
                    borderColor: '#ec4899',
                    backgroundColor: 'rgba(236, 72, 153, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    pointRadius: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Beats: f_beat = |f₁ − f₂| = ' + formatFreq(v.fbeat) }
                },
                scales: {
                    x: { title: { display: true, text: 'Time (s)' } },
                    y: { title: { display: true, text: 'Amplitude' }, min: -2.5, max: 2.5 }
                }
            }
        });
    }

    function runWaveFormulas() {
        var tab = getActiveTab();
        if (tab === 'basic') {
            var v = calcBasic();
            drawViz('basic', v);
            buildStepsBasic(v);
        } else if (tab === 'standing') {
            var v = calcStanding();
            drawViz('standing', v);
            buildStepsStanding(v);
        } else if (tab === 'sound') {
            var v = calcSound();
            drawViz('sound', v);
            buildStepsSound(v);
        } else if (tab === 'doppler') {
            var v = calcDoppler();
            drawViz('doppler', v);
            buildStepsDoppler(v);
        } else if (tab === 'interference') {
            var v = calcInterference();
            drawViz('interference', v);
            buildStepsInterference(v);
        } else if (tab === 'beats') {
            var v = calcBeats();
            drawViz('beats', v);
            buildStepsBeats(v);
        } else if (tab === 'em') {
            var v = calcEM();
            drawViz('em', v);
            buildStepsEM(v);
        }
    }
    window.runWaveFormulas = runWaveFormulas;

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('wave-steps-body');
        var toggle = document.getElementById('wave-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }
    window.toggleWaveSteps = toggleSteps;

    function switchWaveTab(tab, btn) {
        if (!tab) return;
        
        // Update tab states
        document.querySelectorAll('.wave-tab').forEach(function (b) { 
            b.classList.remove('active'); 
        });
        document.querySelectorAll('.wave-panel').forEach(function (p) { 
            p.classList.remove('active'); 
        });
        
        if (btn) btn.classList.add('active');
        var panel = document.getElementById('panel-' + tab);
        if (panel) {
            panel.classList.add('active');
        }
        
        // Update visualization
        setTimeout(function() {
            runWaveFormulas();
        }, 10);
    }
    window.switchWaveTab = switchWaveTab;

    function bindTabs() {
        var tabs = document.querySelectorAll('.wave-tab');
        if (tabs.length === 0) {
            // Retry if tabs not found yet
            setTimeout(bindTabs, 100);
            return;
        }
        
        tabs.forEach(function (btn) {
            // Add event listener (inline onclick already handles fallback)
            btn.addEventListener('click', function (e) {
                var tab = this.getAttribute('data-tab');
                switchWaveTab(tab, this);
            });
        });
    }

    function init() {
        // Initialize tabs first - this must work immediately
        bindTabs();
        
        // Initialize canvas
        canvas = document.getElementById('wave-viz-canvas');
        if (canvas) {
            ctx = canvas.getContext('2d');
        }
        
        // Ensure canvas is sized properly before first render
        function ensureCanvasSize() {
            var c = document.getElementById('wave-viz-container');
            if (c && canvas && ctx) {
                var w = Math.max(c.offsetWidth || 600, 400);
                var h = Math.max(c.offsetHeight || 300, 250);
                if (w > 0 && h > 0) {
                    canvas.width = w;
                    canvas.height = h;
                    // Force initial render
                    runWaveFormulas();
                    return true;
                }
            }
            return false;
        }
        
        // Try immediate initialization
        var initialized = false;
        if (ensureCanvasSize()) {
            initialized = true;
        } else {
            // Retry after a short delay if not ready
            setTimeout(function() {
                if (ensureCanvasSize()) {
                    initialized = true;
                } else {
                    // Final retry
                    setTimeout(function() {
                        ensureCanvasSize();
                        initialized = true;
                    }, 300);
                }
            }, 100);
        }
        
        // Animation loop - start after initial render
        setTimeout(function() {
            var animInterval = setInterval(function() {
                if (!canvas || !ctx) {
                    clearInterval(animInterval);
                    return;
                }
                var tab = getActiveTab();
                if (tab === 'basic' || tab === 'standing' || tab === 'sound' || tab === 'interference' || tab === 'beats' || tab === 'em') {
                    var data = null;
                    try {
                        if (tab === 'basic') data = getValuesBasic();
                        else if (tab === 'standing') data = getValuesStanding();
                        else if (tab === 'sound') data = getValuesSound();
                        else if (tab === 'interference') data = getValuesInterference();
                        else if (tab === 'beats') data = getValuesBeats();
                        else if (tab === 'em') data = getValuesEM();
                        if (data) drawViz(tab, data);
                    } catch (e) {
                        console.error('Error updating visualization:', e);
                    }
                }
            }, 50);
        }, 300);
    }

    // Initialize when DOM is ready
    function startInit() {
        try {
            init();
        } catch (e) {
            console.error('Error initializing wave formulas:', e);
            // Still try to bind tabs even if canvas fails
            setTimeout(bindTabs, 100);
        }
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startInit);
    } else {
        // DOM already ready
        startInit();
    }
})();
