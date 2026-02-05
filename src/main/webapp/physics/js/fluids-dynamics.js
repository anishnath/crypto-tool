/**
 * Fluids Dynamics - calculators, Matter.js fluid flow particles, step-by-step
 * Continuity, Bernoulli, viscosity, flow rate, Reynolds number
 */
(function () {
    'use strict';

    var g = 9.81;
    var areaToM2 = { 'm²': 1, 'cm²': 0.0001 };
    var velocityToMs = { 'm/s': 1, 'cm/s': 0.01 };
    var pressureToPa = { 'Pa': 1, 'kPa': 1000 };
    var densityToKgM3 = { 'kg/m³': 1, 'g/cm³': 1000 };
    var distToM = { 'm': 1, 'cm': 0.01 };
    var viscosityToPas = { 'Pa·s': 1, 'cP': 0.001 };

    var canvas, ctx;
    var matterEngine = null;
    var matterRender = null;
    var flowParticles = [];
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.fluid-tab.active');
        return t ? t.getAttribute('data-tab') : 'continuity';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 2 : decimals;
        if (Math.abs(x) >= 1e6) return (x / 1e6).toFixed(decimals) + ' M';
        if (Math.abs(x) >= 1e3) return (x / 1e3).toFixed(decimals) + ' k';
        if (Math.abs(x) < 0.01 && x !== 0) return x.toExponential(2);
        return x.toFixed(decimals);
    }

    function formatPressure(P) {
        if (P >= 1e6) return (P / 1e6).toFixed(2) + ' MPa';
        if (P >= 1e3) return (P / 1e3).toFixed(2) + ' kPa';
        return formatNum(P) + ' Pa';
    }

    function formatVelocity(v) {
        return formatNum(v) + ' m/s';
    }

    function getValuesContinuity() {
        var a1Raw = parseFloat(document.getElementById('cont-a1').value) || 0;
        var a1Unit = document.getElementById('cont-a1-unit').value;
        var v1Raw = parseFloat(document.getElementById('cont-v1').value) || 0;
        var v1Unit = document.getElementById('cont-v1-unit').value;
        var a2Raw = parseFloat(document.getElementById('cont-a2').value) || 0;
        var a2Unit = document.getElementById('cont-a2-unit').value;
        var A1 = a1Raw * (areaToM2[a1Unit] || 1);
        var v1 = v1Raw * (velocityToMs[v1Unit] || 1);
        var A2 = a2Raw * (areaToM2[a2Unit] || 1);
        var v2 = A2 > 0 ? (A1 * v1) / A2 : 0;
        return { A1: A1, v1: v1, A2: A2, v2: v2 };
    }

    function getValuesBernoulli() {
        var p1Raw = parseFloat(document.getElementById('bern-p1').value) || 101325;
        var p1Unit = document.getElementById('bern-p1-unit').value;
        var v1Raw = parseFloat(document.getElementById('bern-v1').value) || 0;
        var v1Unit = document.getElementById('bern-v1-unit').value;
        var h1Raw = parseFloat(document.getElementById('bern-h1').value) || 0;
        var h1Unit = document.getElementById('bern-h1-unit').value;
        var v2Raw = parseFloat(document.getElementById('bern-v2').value) || 0;
        var v2Unit = document.getElementById('bern-v2-unit').value;
        var h2Raw = parseFloat(document.getElementById('bern-h2').value) || 0;
        var h2Unit = document.getElementById('bern-h2-unit').value;
        var rhoRaw = parseFloat(document.getElementById('bern-rho').value) || 1000;
        var rhoUnit = document.getElementById('bern-rho-unit').value;
        var P1 = p1Raw * (pressureToPa[p1Unit] || 1);
        var v1 = v1Raw * (velocityToMs[v1Unit] || 1);
        var h1 = h1Raw * (distToM[h1Unit] || 1);
        var v2 = v2Raw * (velocityToMs[v2Unit] || 1);
        var h2 = h2Raw * (distToM[h2Unit] || 1);
        var rho = rhoRaw * (densityToKgM3[rhoUnit] || 1);
        var P2 = P1 + 0.5 * rho * (v1 * v1 - v2 * v2) + rho * g * (h1 - h2);
        return { P1: P1, v1: v1, h1: h1, v2: v2, h2: h2, rho: rho, P2: P2 };
    }

    function getValuesViscosity() {
        var etaRaw = parseFloat(document.getElementById('vis-eta').value) || 0;
        var etaUnit = document.getElementById('vis-eta-unit').value;
        var rRaw = parseFloat(document.getElementById('vis-r').value) || 0;
        var rUnit = document.getElementById('vis-r-unit').value;
        var vRaw = parseFloat(document.getElementById('vis-v').value) || 0;
        var vUnit = document.getElementById('vis-v-unit').value;
        var eta = etaRaw * (viscosityToPas[etaUnit] || 1);
        var r = rRaw * (distToM[rUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var Fd = 6 * Math.PI * eta * r * v;
        return { eta: eta, r: r, v: v, Fd: Fd };
    }

    function getValuesFlowRate() {
        var rRaw = parseFloat(document.getElementById('flow-r').value) || 0;
        var rUnit = document.getElementById('flow-r-unit').value;
        var dpRaw = parseFloat(document.getElementById('flow-dp').value) || 0;
        var dpUnit = document.getElementById('flow-dp-unit').value;
        var etaRaw = parseFloat(document.getElementById('flow-eta').value) || 0;
        var etaUnit = document.getElementById('flow-eta-unit').value;
        var lRaw = parseFloat(document.getElementById('flow-l').value) || 0;
        var lUnit = document.getElementById('flow-l-unit').value;
        var r = rRaw * (distToM[rUnit] || 1);
        var dP = dpRaw * (pressureToPa[dpUnit] || 1);
        var eta = etaRaw * (viscosityToPas[etaUnit] || 1);
        var L = lRaw * (distToM[lUnit] || 1);
        var Q = (Math.PI * Math.pow(r, 4) * dP) / (8 * eta * L);
        return { r: r, dP: dP, eta: eta, L: L, Q: Q };
    }

    function getValuesReynolds() {
        var rhoRaw = parseFloat(document.getElementById('reyn-rho').value) || 1000;
        var rhoUnit = document.getElementById('reyn-rho-unit').value;
        var vRaw = parseFloat(document.getElementById('reyn-v').value) || 0;
        var vUnit = document.getElementById('reyn-v-unit').value;
        var dRaw = parseFloat(document.getElementById('reyn-d').value) || 0;
        var dUnit = document.getElementById('reyn-d-unit').value;
        var etaRaw = parseFloat(document.getElementById('reyn-eta').value) || 0;
        var etaUnit = document.getElementById('reyn-eta-unit').value;
        var rho = rhoRaw * (densityToKgM3[rhoUnit] || 1);
        var v = vRaw * (velocityToMs[vUnit] || 1);
        var D = dRaw * (distToM[dUnit] || 1);
        var eta = etaRaw * (viscosityToPas[etaUnit] || 1);
        var Re = eta > 0 ? (rho * v * D) / eta : 0;
        return { rho: rho, v: v, D: D, eta: eta, Re: Re };
    }

    function calcContinuity() {
        var v = getValuesContinuity();
        var el = document.getElementById('cont-result');
        if (el) el.textContent = formatVelocity(v.v2);
        return v;
    }

    function calcBernoulli() {
        var v = getValuesBernoulli();
        var el = document.getElementById('bern-result');
        if (el) el.textContent = formatPressure(v.P2);
        return v;
    }

    function calcViscosity() {
        var v = getValuesViscosity();
        var el = document.getElementById('vis-result');
        if (el) el.textContent = formatNum(v.Fd) + ' N';
        return v;
    }

    function calcFlowRate() {
        var v = getValuesFlowRate();
        var el = document.getElementById('flow-result');
        if (el) el.textContent = formatNum(v.Q) + ' m³/s';
        return v;
    }

    function calcReynolds() {
        var v = getValuesReynolds();
        var el = document.getElementById('reyn-result');
        if (el) el.textContent = formatNum(v.Re);
        return v;
    }

    function buildStepsContinuity(v) {
        var body = document.getElementById('fluid-dyn-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Area 1 <span class="highlight">A₁ = ' + formatNum(v.A1) + ' m²</span>, Velocity 1 <span class="highlight">v₁ = ' + formatVelocity(v.v1) + '</span>, Area 2 <span class="highlight">A₂ = ' + formatNum(v.A2) + ' m²</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (Continuity)</div>'
            + '<div class="step-formula">A₁ v₁ = A₂ v₂</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">v₂ = (A₁ v₁) / A₂ = (' + formatNum(v.A1) + ' × ' + formatNum(v.v1) + ') / ' + formatNum(v.A2) + ' = ' + formatNum(v.v2) + ' m/s</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Velocity 2 </span><span class="step-result-value">v₂ = ' + formatVelocity(v.v2) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsBernoulli(v) {
        var body = document.getElementById('fluid-dyn-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">P₁ = ' + formatPressure(v.P1) + ', v₁ = ' + formatVelocity(v.v1) + ', h₁ = ' + formatNum(v.h1) + ' m, v₂ = ' + formatVelocity(v.v2) + ', h₂ = ' + formatNum(v.h2) + ' m, ρ = ' + formatNum(v.rho) + ' kg/m³</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (Bernoulli)</div>'
            + '<div class="step-formula">P₁ + ½ρv₁² + ρgh₁ = P₂ + ½ρv₂² + ρgh₂</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P₂ = P₁ + ½ρ(v₁² − v₂²) + ρg(h₁ − h₂)<br>= ' + formatPressure(v.P1) + ' + 0.5 × ' + formatNum(v.rho) + ' × (' + formatNum(v.v1) + '² − ' + formatNum(v.v2) + '²) + ' + formatNum(v.rho) + ' × 9.81 × (' + formatNum(v.h1) + ' − ' + formatNum(v.h2) + ')</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Pressure 2 </span><span class="step-result-value">P₂ = ' + formatPressure(v.P2) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsViscosity(v) {
        var body = document.getElementById('fluid-dyn-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Viscosity <span class="highlight">η = ' + formatNum(v.eta) + ' Pa·s</span>, Radius <span class="highlight">r = ' + formatNum(v.r) + ' m</span>, Velocity <span class="highlight">v = ' + formatVelocity(v.v) + '</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (Stokes&apos; Law)</div>'
            + '<div class="step-formula">F_d = 6πη r v</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">F_d = 6 × π × ' + formatNum(v.eta) + ' × ' + formatNum(v.r) + ' × ' + formatNum(v.v) + ' = ' + formatNum(v.Fd) + ' N</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Drag Force </span><span class="step-result-value">F_d = ' + formatNum(v.Fd) + ' N</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsFlowRate(v) {
        var body = document.getElementById('fluid-dyn-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Radius <span class="highlight">r = ' + formatNum(v.r) + ' m</span>, Pressure difference <span class="highlight">ΔP = ' + formatPressure(v.dP) + '</span>, Viscosity <span class="highlight">η = ' + formatNum(v.eta) + ' Pa·s</span>, Length <span class="highlight">L = ' + formatNum(v.L) + ' m</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (Poiseuille&apos;s Law)</div>'
            + '<div class="step-formula">Q = (π r⁴ ΔP) / (8 η L)</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Q = (π × ' + formatNum(v.r) + '⁴ × ' + formatPressure(v.dP) + ') / (8 × ' + formatNum(v.eta) + ' × ' + formatNum(v.L) + ')</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Flow Rate </span><span class="step-result-value">Q = ' + formatNum(v.Q) + ' m³/s</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsReynolds(v) {
        var body = document.getElementById('fluid-dyn-steps-body');
        if (!body) return;
        var flowType = v.Re < 2000 ? 'Laminar' : (v.Re > 4000 ? 'Turbulent' : 'Transitional');
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Density <span class="highlight">ρ = ' + formatNum(v.rho) + ' kg/m³</span>, Velocity <span class="highlight">v = ' + formatVelocity(v.v) + '</span>, Diameter <span class="highlight">D = ' + formatNum(v.D) + ' m</span>, Viscosity <span class="highlight">η = ' + formatNum(v.eta) + ' Pa·s</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">Re = ρ v D / η</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">Re = (' + formatNum(v.rho) + ' × ' + formatNum(v.v) + ' × ' + formatNum(v.D) + ') / ' + formatNum(v.eta) + ' = ' + formatNum(v.Re) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Reynolds Number </span><span class="step-result-value">Re = ' + formatNum(v.Re) + ' (' + flowType + ')</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawContinuityViz(w, h, A1, v1, A2, v2) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw pipe with varying width (Venturi effect)
        var cy = h / 2;
        var pipeWide = Math.min(120, w * 0.3);
        var pipeNarrow = Math.min(60, w * 0.15);
        var x1 = w * 0.15;
        var x2 = w * 0.5;
        var x3 = w * 0.85;
        
        // Wide section (left)
        ctx.fillStyle = '#10b981';
        ctx.fillRect(x1, cy - pipeWide/2, x2 - x1, pipeWide);
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.strokeRect(x1, cy - pipeWide/2, x2 - x1, pipeWide);
        
        // Narrow section (right)
        ctx.fillRect(x2, cy - pipeNarrow/2, x3 - x2, pipeNarrow);
        ctx.strokeRect(x2, cy - pipeNarrow/2, x3 - x2, pipeNarrow);
        
        // Flow arrows
        ctx.strokeStyle = '#0f172a';
        ctx.fillStyle = '#0f172a';
        ctx.lineWidth = 2;
        // Left arrow (slower)
        var arrowLen1 = 20;
        ctx.beginPath();
        ctx.moveTo(x1 + 30, cy);
        ctx.lineTo(x1 + 30 + arrowLen1, cy);
        ctx.lineTo(x1 + 30 + arrowLen1 - 5, cy - 3);
        ctx.moveTo(x1 + 30 + arrowLen1, cy);
        ctx.lineTo(x1 + 30 + arrowLen1 - 5, cy + 3);
        ctx.stroke();
        // Right arrow (faster)
        var arrowLen2 = 40;
        ctx.beginPath();
        ctx.moveTo(x2 + 20, cy);
        ctx.lineTo(x2 + 20 + arrowLen2, cy);
        ctx.lineTo(x2 + 20 + arrowLen2 - 5, cy - 3);
        ctx.moveTo(x2 + 20 + arrowLen2, cy);
        ctx.lineTo(x2 + 20 + arrowLen2 - 5, cy + 3);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('A₁v₁ = A₂v₂', w / 2, 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('v₁ = ' + formatVelocity(v1), x1 + (x2 - x1)/2, cy - pipeWide/2 - 10);
        ctx.fillText('v₂ = ' + formatVelocity(v2), x2 + (x3 - x2)/2, cy - pipeNarrow/2 - 10);
    }

    function drawBernoulliViz(w, h, P1, P2, v1, v2) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw pipe with pressure indicators
        var cy = h / 2;
        var pipeH = 40;
        var x1 = w * 0.2;
        var x2 = w * 0.8;
        
        // Pipe
        ctx.fillStyle = '#10b981';
        ctx.fillRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.strokeRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        
        // Pressure bars (height represents pressure)
        var p1Height = Math.min(30, (P1 / 200000) * 30);
        var p2Height = Math.min(30, (P2 / 200000) * 30);
        
        ctx.fillStyle = '#dc2626';
        // P1 (left, higher)
        ctx.fillRect(x1 + 20, cy - pipeH/2 - p1Height - 5, 15, p1Height);
        // P2 (right, lower)
        ctx.fillRect(x2 - 35, cy - pipeH/2 - p2Height - 5, 15, p2Height);
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P + ½ρv² + ρgh = constant', w / 2, 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('P₁ = ' + formatPressure(P1), x1 + 27, cy - pipeH/2 - p1Height - 10);
        ctx.fillText('P₂ = ' + formatPressure(P2), x2 - 27, cy - pipeH/2 - p2Height - 10);
    }

    function initMatterFlow(w, h) {
        if (typeof Matter === 'undefined') return;
        
        var Engine = Matter.Engine;
        var Render = Matter.Render;
        var World = Matter.World;
        var Bodies = Matter.Bodies;
        
        matterEngine = Engine.create();
        matterEngine.world.gravity.y = 0;
        
        var container = document.getElementById('fluid-viz-container');
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
        
        // Create flow particles
        flowParticles = [];
        for (var i = 0; i < 20; i++) {
            var particle = Bodies.circle(w * 0.1 + (i % 10) * 30, h / 2 + (Math.random() - 0.5) * 20, 3, {
                render: { fillStyle: '#10b981' },
                frictionAir: 0.1
            });
            flowParticles.push(particle);
        }
        
        World.add(matterEngine.world, flowParticles);
        
        Matter.Runner.run(matterEngine);
        Matter.Render.run(matterRender);
    }

    function drawViscosityViz(w, h, Fd, eta, v) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw sphere with drag force arrow
        var cx = w / 2;
        var cy = h / 2;
        var radius = 30;
        
        // Sphere
        ctx.fillStyle = '#10b981';
        ctx.beginPath();
        ctx.arc(cx, cy, radius, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.stroke();
        
        // Drag force arrow (opposite to motion)
        ctx.strokeStyle = '#dc2626';
        ctx.fillStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(cx + radius, cy);
        ctx.lineTo(cx + radius + 40, cy);
        ctx.lineTo(cx + radius + 32, cy - 5);
        ctx.moveTo(cx + radius + 40, cy);
        ctx.lineTo(cx + radius + 32, cy + 5);
        ctx.stroke();
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('F_d = 6πηrv', w / 2, 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('F_d = ' + formatNum(Fd) + ' N', w / 2, h - 20);
    }

    function drawFlowRateViz(w, h, Q, r, dP) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw pipe with flow
        var cy = h / 2;
        var pipeH = Math.min(60, r * 2000);
        var x1 = w * 0.1;
        var x2 = w * 0.9;
        
        // Pipe
        ctx.fillStyle = '#10b981';
        ctx.fillRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.strokeRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        
        // Flow particles (animated)
        var t = Date.now() / 1000;
        ctx.fillStyle = '#0f172a';
        for (var i = 0; i < 8; i++) {
            var x = x1 + 20 + ((t * 50 + i * 40) % (x2 - x1 - 40));
            var y = cy + (Math.sin(t * 2 + i) * 5);
            ctx.beginPath();
            ctx.arc(x, y, 3, 0, Math.PI * 2);
            ctx.fill();
        }
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Q = (πr⁴ΔP)/(8ηL)', w / 2, 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('Q = ' + formatNum(Q) + ' m³/s', w / 2, h - 20);
    }

    function drawReynoldsViz(w, h, Re, rho, v, D) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw flow pattern based on Re
        var cy = h / 2;
        var pipeH = 60;
        var x1 = w * 0.1;
        var x2 = w * 0.9;
        
        // Pipe
        ctx.fillStyle = '#10b981';
        ctx.fillRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        ctx.strokeStyle = '#059669';
        ctx.lineWidth = 2;
        ctx.strokeRect(x1, cy - pipeH/2, x2 - x1, pipeH);
        
        // Flow lines (laminar vs turbulent)
        ctx.strokeStyle = '#0f172a';
        ctx.lineWidth = 2;
        if (Re < 2000) {
            // Laminar - straight lines
            for (var i = 0; i < 5; i++) {
                var y = cy - pipeH/2 + 10 + i * 10;
                ctx.beginPath();
                ctx.moveTo(x1 + 10, y);
                ctx.lineTo(x2 - 10, y);
                ctx.stroke();
            }
        } else {
            // Turbulent - wavy/chaotic lines
            var t = Date.now() / 1000;
            for (var i = 0; i < 5; i++) {
                var y = cy - pipeH/2 + 10 + i * 10;
                ctx.beginPath();
                ctx.moveTo(x1 + 10, y);
                for (var x = x1 + 10; x < x2 - 10; x += 5) {
                    var offset = Math.sin((x - x1) * 0.1 + t * 2 + i) * 3;
                    ctx.lineTo(x, y + offset);
                }
                ctx.stroke();
            }
        }
        
        // Labels
        var flowType = Re < 2000 ? 'Laminar' : (Re > 4000 ? 'Turbulent' : 'Transitional');
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Re = ' + formatNum(Re) + ' (' + flowType + ')', w / 2, 30);
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
        
        if (!matterEngine && typeof Matter !== 'undefined' && (tab === 'continuity' || tab === 'bernoulli')) {
            initMatterFlow(w, h);
        }
        
        if (tab === 'continuity') {
            var demoA1 = data.A1 || 0.01;
            var demoV1 = data.v1 || 2;
            var demoA2 = data.A2 || 0.005;
            var demoV2 = data.v2 || 4;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">v₁ = ' + formatVelocity(demoV1) + '</span><span class="fluid-viz-pill">v₂ = ' + formatVelocity(demoV2) + '</span>';
            drawContinuityViz(w, h, demoA1, demoV1, demoA2, demoV2);
        } else if (tab === 'bernoulli') {
            var demoP1 = data.P1 || 101325;
            var demoP2 = data.P2 || 87400;
            var demoV1 = data.v1 || 0;
            var demoV2 = data.v2 || 5;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">P₁ = ' + formatPressure(demoP1) + '</span><span class="fluid-viz-pill">P₂ = ' + formatPressure(demoP2) + '</span>';
            drawBernoulliViz(w, h, demoP1, demoP2, demoV1, demoV2);
        } else if (tab === 'viscosity') {
            var demoFd = data.Fd || 1.88e-5;
            var demoEta = data.eta || 0.001;
            var demoV = data.v || 0.1;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">F_d = ' + formatNum(demoFd) + ' N</span><span class="fluid-viz-pill">η = ' + formatNum(demoEta) + ' Pa·s</span>';
            drawViscosityViz(w, h, demoFd, demoEta, demoV);
        } else if (tab === 'flowrate') {
            var demoQ = data.Q || 3.93e-6;
            var demoR = data.r || 0.01;
            var demoDP = data.dP || 1000;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">Q = ' + formatNum(demoQ) + ' m³/s</span><span class="fluid-viz-pill">r = ' + formatNum(demoR) + ' m</span>';
            drawFlowRateViz(w, h, demoQ, demoR, demoDP);
        } else if (tab === 'reynolds') {
            var demoRe = data.Re || 20000;
            var demoRho = data.rho || 1000;
            var demoV = data.v || 1;
            var demoD = data.D || 0.02;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">Re = ' + formatNum(demoRe) + '</span><span class="fluid-viz-pill">v = ' + formatVelocity(demoV) + '</span>';
            drawReynoldsViz(w, h, demoRe, demoRho, demoV, demoD);
        }
    }

    function runFluidDynamics() {
        var tab = getActiveTab();
        if (tab === 'continuity') {
            var v = calcContinuity();
            drawViz('continuity', v);
            buildStepsContinuity(v);
        } else if (tab === 'bernoulli') {
            var v = calcBernoulli();
            drawViz('bernoulli', v);
            buildStepsBernoulli(v);
        } else if (tab === 'viscosity') {
            var v = calcViscosity();
            drawViz('viscosity', v);
            buildStepsViscosity(v);
        } else if (tab === 'flowrate') {
            var v = calcFlowRate();
            drawViz('flowrate', v);
            buildStepsFlowRate(v);
        } else if (tab === 'reynolds') {
            var v = calcReynolds();
            drawViz('reynolds', v);
            buildStepsReynolds(v);
        }
    }
    window.runFluidDynamics = runFluidDynamics;

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('fluid-dyn-steps-body');
        var toggle = document.getElementById('fluid-dyn-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }
    window.toggleFluidDynSteps = toggleSteps;

    function switchFluidDynTab(tab, btn) {
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
            runFluidDynamics();
        }, 10);
    }
    window.switchFluidDynTab = switchFluidDynTab;

    function bindTabs() {
        var tabs = document.querySelectorAll('.fluid-tab');
        if (tabs.length === 0) {
            setTimeout(bindTabs, 100);
            return;
        }
        
        tabs.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                switchFluidDynTab(tab, this);
            });
        });
    }

    function init() {
        bindTabs();
        
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
                    runFluidDynamics();
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
                        if (tab === 'continuity') data = getValuesContinuity();
                        else if (tab === 'bernoulli') data = getValuesBernoulli();
                        else if (tab === 'viscosity') data = getValuesViscosity();
                        else if (tab === 'flowrate') data = getValuesFlowRate();
                        else if (tab === 'reynolds') data = getValuesReynolds();
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
            console.error('Error initializing fluid dynamics:', e);
            setTimeout(bindTabs, 100);
        }
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startInit);
    } else {
        startInit();
    }
})();
