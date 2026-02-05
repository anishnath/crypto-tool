/**
 * Solids Elasticity - calculators, Matter.js spring animations, step-by-step
 * Stress, strain, Young's modulus, bulk modulus, shear modulus, Poisson ratio, elastic energy
 */
(function () {
    'use strict';

    var forceToN = { 'N': 1, 'kN': 1000 };
    var areaToM2 = { 'm²': 1, 'cm²': 0.0001, 'mm²': 0.000001 };
    var distToM = { 'm': 1, 'cm': 0.01, 'mm': 0.001 };
    var pressureToPa = { 'Pa': 1, 'kPa': 1000, 'MPa': 1000000, 'GPa': 1000000000 };
    var volumeToM3 = { 'm³': 1, 'cm³': 0.000001 };

    var canvas, ctx;
    var matterEngine = null;
    var matterRender = null;
    var matterRunner = null;
    var springBody = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.elastic-tab.active');
        return t ? t.getAttribute('data-tab') : 'stress';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e9) return (x / 1e9).toFixed(decimals) + ' G';
        if (Math.abs(x) >= 1e6) return (x / 1e6).toFixed(decimals) + ' M';
        if (Math.abs(x) >= 1e3) return (x / 1e3).toFixed(decimals) + ' k';
        if (Math.abs(x) < 0.01 && x !== 0) return x.toExponential(2);
        return x.toFixed(decimals);
    }

    function formatStress(sigma) {
        if (sigma >= 1e9) return (sigma / 1e9).toFixed(2) + ' GPa';
        if (sigma >= 1e6) return (sigma / 1e6).toFixed(2) + ' MPa';
        if (sigma >= 1e3) return (sigma / 1e3).toFixed(2) + ' kPa';
        return formatNum(sigma) + ' Pa';
    }

    function formatModulus(m) {
        if (m >= 1e9) return (m / 1e9).toFixed(2) + ' GPa';
        if (m >= 1e6) return (m / 1e6).toFixed(2) + ' MPa';
        return formatNum(m) + ' Pa';
    }

    function getValuesStress() {
        var fRaw = parseFloat(document.getElementById('stress-f').value) || 0;
        var fUnit = document.getElementById('stress-f-unit').value;
        var aRaw = parseFloat(document.getElementById('stress-a').value) || 0;
        var aUnit = document.getElementById('stress-a-unit').value;
        var F = fRaw * (forceToN[fUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var sigma = A > 0 ? F / A : 0;
        return { F: F, Fraw: fRaw, Funit: fUnit, A: A, Araw: aRaw, Aunit: aUnit, sigma: sigma };
    }

    function getValuesStrain() {
        var dlRaw = parseFloat(document.getElementById('strain-dl').value) || 0;
        var dlUnit = document.getElementById('strain-dl-unit').value;
        var l0Raw = parseFloat(document.getElementById('strain-l0').value) || 0;
        var l0Unit = document.getElementById('strain-l0-unit').value;
        var dL = dlRaw * (distToM[dlUnit] || 1);
        var L0 = l0Raw * (distToM[l0Unit] || 1);
        var epsilon = L0 > 0 ? dL / L0 : 0;
        return { dL: dL, dLraw: dlRaw, dLunit: dlUnit, L0: L0, L0raw: l0Raw, L0unit: l0Unit, epsilon: epsilon };
    }

    function getValuesYoung() {
        var fRaw = parseFloat(document.getElementById('young-f').value) || 0;
        var fUnit = document.getElementById('young-f-unit').value;
        var aRaw = parseFloat(document.getElementById('young-a').value) || 0;
        var aUnit = document.getElementById('young-a-unit').value;
        var dlRaw = parseFloat(document.getElementById('young-dl').value) || 0;
        var dlUnit = document.getElementById('young-dl-unit').value;
        var l0Raw = parseFloat(document.getElementById('young-l0').value) || 0;
        var l0Unit = document.getElementById('young-l0-unit').value;
        var F = fRaw * (forceToN[fUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var dL = dlRaw * (distToM[dlUnit] || 1);
        var L0 = l0Raw * (distToM[l0Unit] || 1);
        var sigma = A > 0 ? F / A : 0;
        var epsilon = L0 > 0 ? dL / L0 : 0;
        var Y = epsilon > 0 ? sigma / epsilon : 0;
        return { F: F, A: A, dL: dL, L0: L0, sigma: sigma, epsilon: epsilon, Y: Y };
    }

    function getValuesBulk() {
        var dpRaw = parseFloat(document.getElementById('bulk-dp').value) || 0;
        var dpUnit = document.getElementById('bulk-dp-unit').value;
        var dvRaw = parseFloat(document.getElementById('bulk-dv').value) || 0;
        var dvUnit = document.getElementById('bulk-dv-unit').value;
        var v0Raw = parseFloat(document.getElementById('bulk-v0').value) || 0;
        var v0Unit = document.getElementById('bulk-v0-unit').value;
        var dP = dpRaw * (pressureToPa[dpUnit] || 1);
        var dV = dvRaw * (volumeToM3[dvUnit] || 1);
        var V0 = v0Raw * (volumeToM3[v0Unit] || 1);
        var epsilonV = V0 > 0 ? dV / V0 : 0;
        var B = epsilonV > 0 ? -dP / epsilonV : 0;
        return { dP: dP, dV: dV, V0: V0, epsilonV: epsilonV, B: B };
    }

    function getValuesShear() {
        var fRaw = parseFloat(document.getElementById('shear-f').value) || 0;
        var fUnit = document.getElementById('shear-f-unit').value;
        var aRaw = parseFloat(document.getElementById('shear-a').value) || 0;
        var aUnit = document.getElementById('shear-a-unit').value;
        var dxRaw = parseFloat(document.getElementById('shear-dx').value) || 0;
        var dxUnit = document.getElementById('shear-dx-unit').value;
        var lRaw = parseFloat(document.getElementById('shear-l').value) || 0;
        var lUnit = document.getElementById('shear-l-unit').value;
        var F = fRaw * (forceToN[fUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var dX = dxRaw * (distToM[dxUnit] || 1);
        var L = lRaw * (distToM[lUnit] || 1);
        var tau = A > 0 ? F / A : 0;
        var gamma = L > 0 ? dX / L : 0;
        var G = gamma > 0 ? tau / gamma : 0;
        return { F: F, A: A, dX: dX, L: L, tau: tau, gamma: gamma, G: G };
    }

    function getValuesPoisson() {
        var ddRaw = parseFloat(document.getElementById('poisson-dd').value) || 0;
        var ddUnit = document.getElementById('poisson-dd-unit').value;
        var d0Raw = parseFloat(document.getElementById('poisson-d0').value) || 0;
        var d0Unit = document.getElementById('poisson-d0-unit').value;
        var dlRaw = parseFloat(document.getElementById('poisson-dl').value) || 0;
        var dlUnit = document.getElementById('poisson-dl-unit').value;
        var l0Raw = parseFloat(document.getElementById('poisson-l0').value) || 0;
        var l0Unit = document.getElementById('poisson-l0-unit').value;
        var dD = ddRaw * (distToM[ddUnit] || 1);
        var D0 = d0Raw * (distToM[d0Unit] || 1);
        var dL = dlRaw * (distToM[dlUnit] || 1);
        var L0 = l0Raw * (distToM[l0Unit] || 1);
        var epsilonLat = D0 > 0 ? dD / D0 : 0;
        var epsilonLong = L0 > 0 ? dL / L0 : 0;
        var nu = epsilonLong > 0 ? -epsilonLat / epsilonLong : 0;
        return { dD: dD, D0: D0, dL: dL, L0: L0, epsilonLat: epsilonLat, epsilonLong: epsilonLong, nu: nu };
    }

    function getValuesEnergy() {
        var yRaw = parseFloat(document.getElementById('energy-y').value) || 0;
        var yUnit = document.getElementById('energy-y-unit').value;
        var aRaw = parseFloat(document.getElementById('energy-a').value) || 0;
        var aUnit = document.getElementById('energy-a-unit').value;
        var dlRaw = parseFloat(document.getElementById('energy-dl').value) || 0;
        var dlUnit = document.getElementById('energy-dl-unit').value;
        var l0Raw = parseFloat(document.getElementById('energy-l0').value) || 0;
        var l0Unit = document.getElementById('energy-l0-unit').value;
        var Y = yRaw * (pressureToPa[yUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var dL = dlRaw * (distToM[dlUnit] || 1);
        var L0 = l0Raw * (distToM[l0Unit] || 1);
        var U = (L0 > 0 && dL > 0) ? 0.5 * Y * A * (dL * dL) / L0 : 0;
        return { Y: Y, A: A, dL: dL, L0: L0, U: U };
    }

    function calcStress() {
        var v = getValuesStress();
        var el = document.getElementById('stress-result');
        if (el) el.textContent = formatStress(v.sigma);
        return v;
    }

    function calcStrain() {
        var v = getValuesStrain();
        var el = document.getElementById('strain-result');
        if (el) el.textContent = formatNum(v.epsilon);
        return v;
    }

    function calcYoung() {
        var v = getValuesYoung();
        var el = document.getElementById('young-result');
        if (el) el.textContent = formatModulus(v.Y);
        return v;
    }

    function calcBulk() {
        var v = getValuesBulk();
        var el = document.getElementById('bulk-result');
        if (el) el.textContent = formatModulus(v.B);
        return v;
    }

    function calcShear() {
        var v = getValuesShear();
        var el = document.getElementById('shear-result');
        if (el) el.textContent = formatModulus(v.G);
        return v;
    }

    function calcPoisson() {
        var v = getValuesPoisson();
        var el = document.getElementById('poisson-result');
        if (el) el.textContent = formatNum(v.nu);
        return v;
    }

    function calcEnergy() {
        var v = getValuesEnergy();
        var el = document.getElementById('energy-result');
        if (el) el.textContent = formatNum(v.U) + ' J';
        return v;
    }

    function buildStepsStress(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force <span class="highlight">F = ' + formatNum(v.F) + ' N</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">σ = F / A</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">σ = ' + formatNum(v.F) + ' / ' + formatNum(v.A) + ' = ' + formatNum(v.sigma) + ' Pa</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Stress </span><span class="step-result-value">σ = ' + formatStress(v.sigma) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsStrain(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Change in length <span class="highlight">ΔL = ' + formatNum(v.dL) + ' m</span>, Original length <span class="highlight">L₀ = ' + formatNum(v.L0) + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">ε = ΔL / L₀</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">ε = ' + formatNum(v.dL) + ' / ' + formatNum(v.L0) + ' = ' + formatNum(v.epsilon) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Strain </span><span class="step-result-value">ε = ' + formatNum(v.epsilon) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsYoung(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force <span class="highlight">F = ' + formatNum(v.F) + ' N</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span>, ΔL = ' + formatNum(v.dL) + ' m, L₀ = ' + formatNum(v.L0) + ' m</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Stress & Strain</div>'
            + '<div class="step-calc">σ = F/A = ' + formatNum(v.F) + ' / ' + formatNum(v.A) + ' = ' + formatStress(v.sigma) + '<br>ε = ΔL/L₀ = ' + formatNum(v.dL) + ' / ' + formatNum(v.L0) + ' = ' + formatNum(v.epsilon) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">Y = σ / ε</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Young&apos;s Modulus </span><span class="step-result-value">Y = ' + formatModulus(v.Y) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsBulk(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Pressure change <span class="highlight">ΔP = ' + formatNum(v.dP) + ' Pa</span>, Volume change <span class="highlight">ΔV = ' + formatNum(v.dV) + ' m³</span>, Original volume <span class="highlight">V₀ = ' + formatNum(v.V0) + ' m³</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Volumetric Strain</div>'
            + '<div class="step-calc">ε_v = ΔV/V₀ = ' + formatNum(v.dV) + ' / ' + formatNum(v.V0) + ' = ' + formatNum(v.epsilonV) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">B = -ΔP / ε_v</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Bulk Modulus </span><span class="step-result-value">B = ' + formatModulus(v.B) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsShear(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force <span class="highlight">F = ' + formatNum(v.F) + ' N</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span>, Shear displacement <span class="highlight">Δx = ' + formatNum(v.dX) + ' m</span>, Length <span class="highlight">L = ' + formatNum(v.L) + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Shear Stress & Strain</div>'
            + '<div class="step-calc">τ = F/A = ' + formatNum(v.F) + ' / ' + formatNum(v.A) + ' = ' + formatStress(v.tau) + '<br>γ = Δx/L = ' + formatNum(v.dX) + ' / ' + formatNum(v.L) + ' = ' + formatNum(v.gamma) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">G = τ / γ</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Shear Modulus </span><span class="step-result-value">G = ' + formatModulus(v.G) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPoisson(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Lateral change <span class="highlight">Δd = ' + formatNum(v.dD) + ' m</span>, Original diameter <span class="highlight">d₀ = ' + formatNum(v.D0) + ' m</span>, Longitudinal change <span class="highlight">ΔL = ' + formatNum(v.dL) + ' m</span>, Original length <span class="highlight">L₀ = ' + formatNum(v.L0) + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Strains</div>'
            + '<div class="step-calc">ε_lateral = Δd/d₀ = ' + formatNum(v.dD) + ' / ' + formatNum(v.D0) + ' = ' + formatNum(v.epsilonLat) + '<br>ε_longitudinal = ΔL/L₀ = ' + formatNum(v.dL) + ' / ' + formatNum(v.L0) + ' = ' + formatNum(v.epsilonLong) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">ν = -ε_lateral / ε_longitudinal</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Poisson&apos;s Ratio </span><span class="step-result-value">ν = ' + formatNum(v.nu) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsEnergy(v) {
        var body = document.getElementById('elastic-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Young&apos;s modulus <span class="highlight">Y = ' + formatModulus(v.Y) + '</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span>, Change in length <span class="highlight">ΔL = ' + formatNum(v.dL) + ' m</span>, Original length <span class="highlight">L₀ = ' + formatNum(v.L0) + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">U = ½ Y A (ΔL)² / L₀</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">U = 0.5 × ' + formatModulus(v.Y) + ' × ' + formatNum(v.A) + ' × (' + formatNum(v.dL) + ')² / ' + formatNum(v.L0) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Elastic Energy </span><span class="step-result-value">U = ' + formatNum(v.U) + ' J</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawStressViz(w, h, sigma, F, A) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        var barWidth = Math.min(200, w * 0.4);
        var barHeight = 40;
        var x = (w - barWidth) / 2;
        var y = cy - barHeight / 2;
        
        // Draw rod/bar
        ctx.fillStyle = '#3b82f6';
        ctx.fillRect(x, y, barWidth, barHeight);
        ctx.strokeStyle = '#1e40af';
        ctx.lineWidth = 2;
        ctx.strokeRect(x, y, barWidth, barHeight);
        
        // Draw force arrows
        var arrowLen = 30;
        ctx.strokeStyle = '#dc2626';
        ctx.fillStyle = '#dc2626';
        ctx.lineWidth = 3;
        // Left arrow (pulling)
        ctx.beginPath();
        ctx.moveTo(x - 20, cy);
        ctx.lineTo(x - 20 - arrowLen, cy);
        ctx.lineTo(x - 20 - arrowLen + 8, cy - 5);
        ctx.moveTo(x - 20 - arrowLen, cy);
        ctx.lineTo(x - 20 - arrowLen + 8, cy + 5);
        ctx.stroke();
        // Right arrow (pulling)
        ctx.beginPath();
        ctx.moveTo(x + barWidth + 20, cy);
        ctx.lineTo(x + barWidth + 20 + arrowLen, cy);
        ctx.lineTo(x + barWidth + 20 + arrowLen - 8, cy - 5);
        ctx.moveTo(x + barWidth + 20 + arrowLen, cy);
        ctx.lineTo(x + barWidth + 20 + arrowLen - 8, cy + 5);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('σ = ' + formatStress(sigma), w / 2, y - 10);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('F = ' + formatNum(F) + ' N', w / 2, h - 20);
    }

    function drawStrainViz(w, h, epsilon, dL, L0) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        var origLen = Math.min(300, w * 0.6);
        var stretch = origLen * epsilon;
        var newLen = origLen + stretch;
        var x = (w - newLen) / 2;
        
        // Original length (dashed)
        ctx.strokeStyle = '#94a3b8';
        ctx.lineWidth = 3;
        ctx.setLineDash([5, 5]);
        ctx.beginPath();
        ctx.moveTo(x, cy);
        ctx.lineTo(x + origLen, cy);
        ctx.stroke();
        ctx.setLineDash([]);
        
        // New length (solid)
        ctx.strokeStyle = '#3b82f6';
        ctx.lineWidth = 4;
        ctx.beginPath();
        ctx.moveTo(x, cy);
        ctx.lineTo(x + newLen, cy);
        ctx.stroke();
        
        // Markers
        ctx.fillStyle = '#6366f1';
        ctx.beginPath();
        ctx.arc(x, cy, 5, 0, Math.PI * 2);
        ctx.fill();
        ctx.beginPath();
        ctx.arc(x + newLen, cy, 5, 0, Math.PI * 2);
        ctx.fill();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('ε = ' + formatNum(epsilon), w / 2, cy - 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('ΔL = ' + formatNum(dL) + ' m', w / 2, h - 20);
    }

    function drawYoungViz(w, h, Y, sigma, epsilon) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Use Matter.js for spring visualization
        if (typeof Matter !== 'undefined' && matterEngine) {
            drawMatterSpring(w, h, epsilon);
        } else {
            // Fallback canvas visualization
            var cy = h / 2;
            var springLen = Math.min(250, w * 0.5);
            var x = (w - springLen) / 2;
            var coils = 8;
            var amplitude = 15;
            var stretch = springLen * epsilon;
            var newLen = springLen + stretch;
            
            ctx.strokeStyle = '#3b82f6';
            ctx.lineWidth = 3;
            ctx.beginPath();
            for (var i = 0; i <= coils; i++) {
                var t = i / coils;
                var px = x + t * newLen;
                var py = cy + amplitude * Math.sin(t * Math.PI * coils);
                if (i === 0) ctx.moveTo(px, py);
                else ctx.lineTo(px, py);
            }
            ctx.stroke();
            
            ctx.fillStyle = '#0f172a';
            ctx.font = 'bold 14px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('Y = ' + formatModulus(Y), w / 2, 30);
        }
    }

    function drawMatterSpring(w, h, strain) {
        if (!matterEngine || !springBody) return;
        
        // Update spring stiffness based on strain
        var targetLength = 200 + strain * 1000;
        Matter.Body.setPosition(springBody, { x: w / 2, y: h / 2 });
        
        // Render Matter.js world
        if (matterRender) {
            Matter.Render.world(matterRender);
        }
    }

    function initMatter(w, h) {
        if (typeof Matter === 'undefined') return;
        
        var Engine = Matter.Engine;
        var Render = Matter.Render;
        var World = Matter.World;
        var Bodies = Matter.Bodies;
        var Constraint = Matter.Constraint;
        var Mouse = Matter.Mouse;
        var MouseConstraint = Matter.MouseConstraint;
        
        matterEngine = Engine.create();
        matterEngine.world.gravity.y = 0;
        
        var container = document.getElementById('elastic-viz-container');
        if (!container) return;
        
        matterRender = Render.create({
            canvas: canvas,
            engine: matterEngine,
            options: {
                width: w,
                height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: window.devicePixelRatio || 1
            }
        });
        
        // Create spring body (rectangle that can stretch)
        springBody = Bodies.rectangle(w / 2, h / 2, 200, 20, {
            render: { fillStyle: '#3b82f6' }
        });
        
        World.add(matterEngine.world, [springBody]);
        
        Matter.Runner.run(matterEngine);
        Matter.Render.run(matterRender);
    }

    function drawViz(tab, data) {
        var c = document.getElementById('elastic-viz-container');
        var pills = document.getElementById('elastic-viz-pills');
        if (!c || !canvas || !ctx) return;
        
        var containerWidth = c.offsetWidth || 600;
        var containerHeight = c.offsetHeight || 300;
        canvas.width = containerWidth;
        canvas.height = containerHeight;
        var w = canvas.width;
        var h = canvas.height;
        
        if (!matterEngine && typeof Matter !== 'undefined') {
            initMatter(w, h);
        }
        
        if (tab === 'stress') {
            var demoF = data.F || 1000;
            var demoA = data.A || 0.001;
            var demoSigma = data.sigma || (demoF / demoA);
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">σ = ' + formatStress(demoSigma) + '</span><span class="elastic-viz-pill">F = ' + formatNum(demoF) + ' N</span>';
            drawStressViz(w, h, demoSigma, demoF, demoA);
        } else if (tab === 'strain') {
            var demoEpsilon = data.epsilon || 0.001;
            var demoDL = data.dL || 0.001;
            var demoL0 = data.L0 || 1;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">ε = ' + formatNum(demoEpsilon) + '</span><span class="elastic-viz-pill">ΔL = ' + formatNum(demoDL) + ' m</span>';
            drawStrainViz(w, h, demoEpsilon, demoDL, demoL0);
        } else if (tab === 'young') {
            var demoY = data.Y || 200e9;
            var demoSigma = data.sigma || 1e6;
            var demoEpsilon = data.epsilon || 0.001;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">Y = ' + formatModulus(demoY) + '</span><span class="elastic-viz-pill">ε = ' + formatNum(demoEpsilon) + '</span>';
            drawYoungViz(w, h, demoY, demoSigma, demoEpsilon);
        } else if (tab === 'bulk') {
            var demoB = data.B || 1e9;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">B = ' + formatModulus(demoB) + '</span>';
            drawStressViz(w, h, demoB, 1000, 0.001);
        } else if (tab === 'shear') {
            var demoG = data.G || 1e9;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">G = ' + formatModulus(demoG) + '</span>';
            drawStrainViz(w, h, 0.001, 0.001, 1);
        } else if (tab === 'poisson') {
            var demoNu = data.nu || 0.3;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">ν = ' + formatNum(demoNu) + '</span>';
            drawStrainViz(w, h, 0.001, 0.001, 1);
        } else if (tab === 'energy') {
            var demoU = data.U || 0.1;
            if (pills) pills.innerHTML = '<span class="elastic-viz-pill">U = ' + formatNum(demoU) + ' J</span>';
            drawStrainViz(w, h, 0.001, 0.001, 1);
        }
    }

    function runElasticity() {
        var tab = getActiveTab();
        if (tab === 'stress') {
            var v = calcStress();
            drawViz('stress', v);
            buildStepsStress(v);
        } else if (tab === 'strain') {
            var v = calcStrain();
            drawViz('strain', v);
            buildStepsStrain(v);
        } else if (tab === 'young') {
            var v = calcYoung();
            drawViz('young', v);
            buildStepsYoung(v);
        } else if (tab === 'bulk') {
            var v = calcBulk();
            drawViz('bulk', v);
            buildStepsBulk(v);
        } else if (tab === 'shear') {
            var v = calcShear();
            drawViz('shear', v);
            buildStepsShear(v);
        } else if (tab === 'poisson') {
            var v = calcPoisson();
            drawViz('poisson', v);
            buildStepsPoisson(v);
        } else if (tab === 'energy') {
            var v = calcEnergy();
            drawViz('energy', v);
            buildStepsEnergy(v);
        }
    }
    window.runElasticity = runElasticity;

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('elastic-steps-body');
        var toggle = document.getElementById('elastic-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }
    window.toggleElasticSteps = toggleSteps;

    function switchElasticTab(tab, btn) {
        if (!tab) return;
        
        document.querySelectorAll('.elastic-tab').forEach(function (b) { 
            b.classList.remove('active'); 
        });
        document.querySelectorAll('.elastic-panel').forEach(function (p) { 
            p.classList.remove('active'); 
        });
        
        if (btn) btn.classList.add('active');
        var panel = document.getElementById('panel-' + tab);
        if (panel) {
            panel.classList.add('active');
        }
        
        setTimeout(function() {
            runElasticity();
        }, 10);
    }
    window.switchElasticTab = switchElasticTab;

    function bindTabs() {
        var tabs = document.querySelectorAll('.elastic-tab');
        if (tabs.length === 0) {
            setTimeout(bindTabs, 100);
            return;
        }
        
        tabs.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                switchElasticTab(tab, this);
            });
        });
    }

    function init() {
        bindTabs();
        
        canvas = document.getElementById('elastic-viz-canvas');
        if (canvas) {
            ctx = canvas.getContext('2d');
        }
        
        function ensureCanvasSize() {
            var c = document.getElementById('elastic-viz-container');
            if (c && canvas && ctx) {
                var w = Math.max(c.offsetWidth || 600, 400);
                var h = Math.max(c.offsetHeight || 300, 250);
                if (w > 0 && h > 0) {
                    canvas.width = w;
                    canvas.height = h;
                    runElasticity();
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
                        if (tab === 'stress') data = getValuesStress();
                        else if (tab === 'strain') data = getValuesStrain();
                        else if (tab === 'young') data = getValuesYoung();
                        else if (tab === 'bulk') data = getValuesBulk();
                        else if (tab === 'shear') data = getValuesShear();
                        else if (tab === 'poisson') data = getValuesPoisson();
                        else if (tab === 'energy') data = getValuesEnergy();
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
            console.error('Error initializing elasticity:', e);
            setTimeout(bindTabs, 100);
        }
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startInit);
    } else {
        startInit();
    }
})();
