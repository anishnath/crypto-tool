/**
 * Fluids Statics - calculators, Matter.js floating objects, step-by-step
 * Pressure, hydrostatic pressure, buoyant force, apparent weight, Pascal's law
 */
(function () {
    'use strict';

    var g = 9.81;
    var forceToN = { 'N': 1, 'kN': 1000 };
    var areaToM2 = { 'm²': 1, 'cm²': 0.0001 };
    var pressureToPa = { 'Pa': 1, 'kPa': 1000 };
    var densityToKgM3 = { 'kg/m³': 1, 'g/cm³': 1000 };
    var distToM = { 'm': 1, 'cm': 0.01 };
    var volumeToM3 = { 'm³': 1, 'cm³': 0.000001, 'L': 0.001 };
    var massToKg = { 'kg': 1, 'g': 0.001 };

    var canvas, ctx;
    var matterEngine = null;
    var matterRender = null;
    var floatingBody = null;
    var stepsExpanded = false;

    function getActiveTab() {
        var t = document.querySelector('.fluid-tab.active');
        return t ? t.getAttribute('data-tab') : 'pressure';
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

    function getValuesPressure() {
        var fRaw = parseFloat(document.getElementById('press-f').value) || 0;
        var fUnit = document.getElementById('press-f-unit').value;
        var aRaw = parseFloat(document.getElementById('press-a').value) || 0;
        var aUnit = document.getElementById('press-a-unit').value;
        var F = fRaw * (forceToN[fUnit] || 1);
        var A = aRaw * (areaToM2[aUnit] || 1);
        var P = A > 0 ? F / A : 0;
        return { F: F, A: A, P: P };
    }

    function getValuesHydrostatic() {
        var p0Raw = parseFloat(document.getElementById('hydro-p0').value) || 101325;
        var p0Unit = document.getElementById('hydro-p0-unit').value;
        var rhoRaw = parseFloat(document.getElementById('hydro-rho').value) || 1000;
        var rhoUnit = document.getElementById('hydro-rho-unit').value;
        var hRaw = parseFloat(document.getElementById('hydro-h').value) || 0;
        var hUnit = document.getElementById('hydro-h-unit').value;
        var P0 = p0Raw * (pressureToPa[p0Unit] || 1);
        var rho = rhoRaw * (densityToKgM3[rhoUnit] || 1);
        var h = hRaw * (distToM[hUnit] || 1);
        var P = P0 + rho * g * h;
        return { P0: P0, rho: rho, h: h, P: P };
    }

    function getValuesBuoyant() {
        var rhoRaw = parseFloat(document.getElementById('buoy-rho').value) || 1000;
        var rhoUnit = document.getElementById('buoy-rho-unit').value;
        var vRaw = parseFloat(document.getElementById('buoy-v').value) || 0;
        var vUnit = document.getElementById('buoy-v-unit').value;
        var rhoFluid = rhoRaw * (densityToKgM3[rhoUnit] || 1);
        var Vsub = vRaw * (volumeToM3[vUnit] || 1);
        var Fb = rhoFluid * Vsub * g;
        return { rhoFluid: rhoFluid, Vsub: Vsub, Fb: Fb };
    }

    function getValuesApparent() {
        var mRaw = parseFloat(document.getElementById('app-m').value) || 0;
        var mUnit = document.getElementById('app-m-unit').value;
        var rhoRaw = parseFloat(document.getElementById('app-rho').value) || 1000;
        var rhoUnit = document.getElementById('app-rho-unit').value;
        var vRaw = parseFloat(document.getElementById('app-v').value) || 0;
        var vUnit = document.getElementById('app-v-unit').value;
        var m = mRaw * (massToKg[mUnit] || 1);
        var rhoFluid = rhoRaw * (densityToKgM3[rhoUnit] || 1);
        var V = vRaw * (volumeToM3[vUnit] || 1);
        var W = m * g;
        var Fb = rhoFluid * V * g;
        var Wapp = W - Fb;
        return { m: m, rhoFluid: rhoFluid, V: V, W: W, Fb: Fb, Wapp: Wapp };
    }

    function getValuesPascal() {
        var f1Raw = parseFloat(document.getElementById('pascal-f1').value) || 0;
        var f1Unit = document.getElementById('pascal-f1-unit').value;
        var a1Raw = parseFloat(document.getElementById('pascal-a1').value) || 0;
        var a1Unit = document.getElementById('pascal-a1-unit').value;
        var a2Raw = parseFloat(document.getElementById('pascal-a2').value) || 0;
        var a2Unit = document.getElementById('pascal-a2-unit').value;
        var F1 = f1Raw * (forceToN[f1Unit] || 1);
        var A1 = a1Raw * (areaToM2[a1Unit] || 1);
        var A2 = a2Raw * (areaToM2[a2Unit] || 1);
        var P = A1 > 0 ? F1 / A1 : 0;
        var F2 = P * A2;
        return { F1: F1, A1: A1, A2: A2, P: P, F2: F2 };
    }

    function calcPressure() {
        var v = getValuesPressure();
        var el = document.getElementById('press-result');
        if (el) el.textContent = formatPressure(v.P);
        return v;
    }

    function calcHydrostatic() {
        var v = getValuesHydrostatic();
        var el = document.getElementById('hydro-result');
        if (el) el.textContent = formatPressure(v.P);
        return v;
    }

    function calcBuoyant() {
        var v = getValuesBuoyant();
        var el = document.getElementById('buoy-result');
        if (el) el.textContent = formatNum(v.Fb) + ' N';
        return v;
    }

    function calcApparent() {
        var v = getValuesApparent();
        var el = document.getElementById('app-result');
        if (el) el.textContent = formatNum(v.Wapp) + ' N';
        return v;
    }

    function calcPascal() {
        var v = getValuesPascal();
        var el = document.getElementById('pascal-result');
        if (el) el.textContent = formatNum(v.F2) + ' N';
        return v;
    }

    function buildStepsPressure(v) {
        var body = document.getElementById('fluid-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force <span class="highlight">F = ' + formatNum(v.F) + ' N</span>, Area <span class="highlight">A = ' + formatNum(v.A) + ' m²</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">P = F / A</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P = ' + formatNum(v.F) + ' / ' + formatNum(v.A) + ' = ' + formatNum(v.P) + ' Pa</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Pressure </span><span class="step-result-value">P = ' + formatPressure(v.P) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsHydrostatic(v) {
        var body = document.getElementById('fluid-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">P₀ = ' + formatPressure(v.P0) + ', ρ = ' + formatNum(v.rho) + ' kg/m³, h = ' + formatNum(v.h) + ' m, g = 9.81 m/s²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula</div>'
            + '<div class="step-formula">P = P₀ + ρ g h</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">P = ' + formatPressure(v.P0) + ' + ' + formatNum(v.rho) + ' × 9.81 × ' + formatNum(v.h) + ' = ' + formatPressure(v.P) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Hydrostatic Pressure </span><span class="step-result-value">P = ' + formatPressure(v.P) + '</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsBuoyant(v) {
        var body = document.getElementById('fluid-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Fluid density <span class="highlight">ρ_fluid = ' + formatNum(v.rhoFluid) + ' kg/m³</span>, Submerged volume <span class="highlight">V_sub = ' + formatNum(v.Vsub) + ' m³</span>, g = 9.81 m/s²</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Formula (Archimedes)</div>'
            + '<div class="step-formula">F_b = ρ_fluid V_sub g</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Substitute</div>'
            + '<div class="step-calc">F_b = ' + formatNum(v.rhoFluid) + ' × ' + formatNum(v.Vsub) + ' × 9.81 = ' + formatNum(v.Fb) + ' N</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Buoyant Force </span><span class="step-result-value">F_b = ' + formatNum(v.Fb) + ' N</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsApparent(v) {
        var body = document.getElementById('fluid-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Mass <span class="highlight">m = ' + formatNum(v.m) + ' kg</span>, Fluid density <span class="highlight">ρ_fluid = ' + formatNum(v.rhoFluid) + ' kg/m³</span>, Volume <span class="highlight">V = ' + formatNum(v.V) + ' m³</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Weight & Buoyant Force</div>'
            + '<div class="step-calc">W = mg = ' + formatNum(v.m) + ' × 9.81 = ' + formatNum(v.W) + ' N<br>F_b = ρ_fluid V g = ' + formatNum(v.rhoFluid) + ' × ' + formatNum(v.V) + ' × 9.81 = ' + formatNum(v.Fb) + ' N</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula</div>'
            + '<div class="step-formula">W_app = W − F_b</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Apparent Weight </span><span class="step-result-value">W_app = ' + formatNum(v.Wapp) + ' N</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function buildStepsPascal(v) {
        var body = document.getElementById('fluid-steps-body');
        if (!body) return;
        var html = ''
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">1</span>Given (SI)</div>'
            + '<div class="step-calc">Force 1 <span class="highlight">F₁ = ' + formatNum(v.F1) + ' N</span>, Area 1 <span class="highlight">A₁ = ' + formatNum(v.A1) + ' m²</span>, Area 2 <span class="highlight">A₂ = ' + formatNum(v.A2) + ' m²</span></div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">2</span>Calculate Pressure</div>'
            + '<div class="step-calc">P = F₁/A₁ = ' + formatNum(v.F1) + ' / ' + formatNum(v.A1) + ' = ' + formatPressure(v.P) + '</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">3</span>Formula (Pascal&apos;s Law)</div>'
            + '<div class="step-formula">F₂ = P × A₂</div>'
            + '</div>'
            + '<div class="step-item">'
            + '<div class="step-title"><span class="step-number">4</span>Result</div>'
            + '<div class="step-calc"><span class="step-result-label">Force 2 </span><span class="step-result-value">F₂ = ' + formatNum(v.F2) + ' N</span></div>'
            + '</div>';
        body.innerHTML = html;
    }

    function drawPressureViz(w, h, P, F, A) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        var cy = h / 2;
        var barWidth = Math.min(150, w * 0.3);
        var barHeight = 60;
        var x = (w - barWidth) / 2;
        var y = cy - barHeight / 2;
        
        ctx.fillStyle = '#0ea5e9';
        ctx.fillRect(x, y, barWidth, barHeight);
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 2;
        ctx.strokeRect(x, y, barWidth, barHeight);
        
        // Force arrow down
        ctx.strokeStyle = '#dc2626';
        ctx.fillStyle = '#dc2626';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(w / 2, y - 20);
        ctx.lineTo(w / 2, y);
        ctx.lineTo(w / 2 - 8, y - 12);
        ctx.moveTo(w / 2, y);
        ctx.lineTo(w / 2 + 8, y - 12);
        ctx.stroke();
        
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P = ' + formatPressure(P), w / 2, y - 35);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('F = ' + formatNum(F) + ' N', w / 2, h - 20);
    }

    function drawHydrostaticViz(w, h, P, hDepth, rho) {
        if (!ctx || w <= 0 || h <= 0) return;
        ctx.clearRect(0, 0, w, h);
        
        // Draw fluid container
        var containerX = w * 0.2;
        var containerW = w * 0.6;
        var containerH = h * 0.7;
        var containerY = h - containerH - 20;
        
        // Fluid fill
        var fillH = Math.min(containerH, hDepth * 50);
        ctx.fillStyle = '#0ea5e9';
        ctx.fillRect(containerX, containerY + containerH - fillH, containerW, fillH);
        
        // Container walls
        ctx.strokeStyle = '#334155';
        ctx.lineWidth = 3;
        ctx.strokeRect(containerX, containerY, containerW, containerH);
        
        // Depth marker
        var depthY = containerY + containerH - fillH;
        ctx.strokeStyle = '#dc2626';
        ctx.lineWidth = 2;
        ctx.setLineDash([5, 5]);
        ctx.beginPath();
        ctx.moveTo(containerX - 10, depthY);
        ctx.lineTo(containerX + containerW + 10, depthY);
        ctx.stroke();
        ctx.setLineDash([]);
        
        // Labels
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('P = ' + formatPressure(P), w / 2, 30);
        ctx.font = '12px Inter, sans-serif';
        ctx.fillText('h = ' + formatNum(hDepth) + ' m', containerX + containerW + 30, depthY);
    }

    function initMatter(w, h) {
        if (typeof Matter === 'undefined') return;
        
        var Engine = Matter.Engine;
        var Render = Matter.Render;
        var World = Matter.World;
        var Bodies = Matter.Bodies;
        
        matterEngine = Engine.create();
        matterEngine.world.gravity.y = 0.5;
        
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
        
        // Create floating object
        floatingBody = Bodies.rectangle(w / 2, h / 3, 60, 60, {
            density: 0.5,
            render: { fillStyle: '#0ea5e9' }
        });
        
        // Create fluid surface (static body)
        var fluidSurface = Bodies.rectangle(w / 2, h * 0.6, w, 20, {
            isStatic: true,
            render: { fillStyle: '#06b6d4', opacity: 0.7 }
        });
        
        World.add(matterEngine.world, [floatingBody, fluidSurface]);
        
        Matter.Runner.run(matterEngine);
        Matter.Render.run(matterRender);
    }

    function drawBuoyantViz(w, h, Fb, rhoFluid, Vsub) {
        if (!ctx || w <= 0 || h <= 0) return;
        
        if (!matterEngine && typeof Matter !== 'undefined') {
            initMatter(w, h);
        }
        
        // Canvas overlay for labels
        ctx.clearRect(0, 0, w, h);
        
        // Draw fluid
        var fluidY = h * 0.6;
        ctx.fillStyle = 'rgba(14,165,233,0.3)';
        ctx.fillRect(0, fluidY, w, h - fluidY);
        
        // Draw floating object
        var objX = w / 2;
        var objY = h / 3;
        var objSize = 60;
        ctx.fillStyle = '#0ea5e9';
        ctx.fillRect(objX - objSize/2, objY - objSize/2, objSize, objSize);
        ctx.strokeStyle = '#0284c7';
        ctx.lineWidth = 2;
        ctx.strokeRect(objX - objSize/2, objY - objSize/2, objSize, objSize);
        
        // Buoyant force arrow
        ctx.strokeStyle = '#10b981';
        ctx.fillStyle = '#10b981';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(objX, objY + objSize/2);
        ctx.lineTo(objX, objY + objSize/2 + 40);
        ctx.lineTo(objX - 8, objY + objSize/2 + 32);
        ctx.moveTo(objX, objY + objSize/2 + 40);
        ctx.lineTo(objX + 8, objY + objSize/2 + 32);
        ctx.stroke();
        
        ctx.fillStyle = '#0f172a';
        ctx.font = 'bold 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('F_b = ' + formatNum(Fb) + ' N', w / 2, 30);
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
        
        if (tab === 'pressure') {
            var demoF = data.F || 1000;
            var demoA = data.A || 0.01;
            var demoP = data.P || (demoF / demoA);
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">P = ' + formatPressure(demoP) + '</span><span class="fluid-viz-pill">F = ' + formatNum(demoF) + ' N</span>';
            drawPressureViz(w, h, demoP, demoF, demoA);
        } else if (tab === 'hydrostatic') {
            var demoP = data.P || 199300;
            var demoH = data.h || 10;
            var demoRho = data.rho || 1000;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">P = ' + formatPressure(demoP) + '</span><span class="fluid-viz-pill">h = ' + formatNum(demoH) + ' m</span>';
            drawHydrostaticViz(w, h, demoP, demoH, demoRho);
        } else if (tab === 'buoyant') {
            var demoFb = data.Fb || 9.81;
            var demoRho = data.rhoFluid || 1000;
            var demoV = data.Vsub || 0.001;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">F_b = ' + formatNum(demoFb) + ' N</span><span class="fluid-viz-pill">ρ = ' + formatNum(demoRho) + ' kg/m³</span>';
            drawBuoyantViz(w, h, demoFb, demoRho, demoV);
        } else if (tab === 'apparent') {
            var demoWapp = data.Wapp || 0;
            var demoFb = data.Fb || 9.81;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">W_app = ' + formatNum(demoWapp) + ' N</span><span class="fluid-viz-pill">F_b = ' + formatNum(demoFb) + ' N</span>';
            drawBuoyantViz(w, h, demoFb, data.rhoFluid || 1000, data.V || 0.001);
        } else if (tab === 'pascal') {
            var demoF2 = data.F2 || 10000;
            var demoP = data.P || 100000;
            if (pills) pills.innerHTML = '<span class="fluid-viz-pill">F₂ = ' + formatNum(demoF2) + ' N</span><span class="fluid-viz-pill">P = ' + formatPressure(demoP) + '</span>';
            drawPressureViz(w, h, demoP, demoF2, data.A2 || 0.1);
        }
    }

    function runFluidStatics() {
        var tab = getActiveTab();
        if (tab === 'pressure') {
            var v = calcPressure();
            drawViz('pressure', v);
            buildStepsPressure(v);
        } else if (tab === 'hydrostatic') {
            var v = calcHydrostatic();
            drawViz('hydrostatic', v);
            buildStepsHydrostatic(v);
        } else if (tab === 'buoyant') {
            var v = calcBuoyant();
            drawViz('buoyant', v);
            buildStepsBuoyant(v);
        } else if (tab === 'apparent') {
            var v = calcApparent();
            drawViz('apparent', v);
            buildStepsApparent(v);
        } else if (tab === 'pascal') {
            var v = calcPascal();
            drawViz('pascal', v);
            buildStepsPascal(v);
        }
    }
    window.runFluidStatics = runFluidStatics;

    function toggleSteps() {
        stepsExpanded = !stepsExpanded;
        var body = document.getElementById('fluid-steps-body');
        var toggle = document.getElementById('fluid-steps-toggle');
        if (body) body.classList.toggle('collapsed', !stepsExpanded);
        if (toggle) toggle.textContent = stepsExpanded ? '▲ Hide' : '▼ Show';
    }
    window.toggleFluidSteps = toggleSteps;

    function switchFluidTab(tab, btn) {
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
            runFluidStatics();
        }, 10);
    }
    window.switchFluidTab = switchFluidTab;

    function bindTabs() {
        var tabs = document.querySelectorAll('.fluid-tab');
        if (tabs.length === 0) {
            setTimeout(bindTabs, 100);
            return;
        }
        
        tabs.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tab = this.getAttribute('data-tab');
                switchFluidTab(tab, this);
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
                    runFluidStatics();
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
                        if (tab === 'pressure') data = getValuesPressure();
                        else if (tab === 'hydrostatic') data = getValuesHydrostatic();
                        else if (tab === 'buoyant') data = getValuesBuoyant();
                        else if (tab === 'apparent') data = getValuesApparent();
                        else if (tab === 'pascal') data = getValuesPascal();
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
            console.error('Error initializing fluid statics:', e);
            setTimeout(bindTabs, 100);
        }
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startInit);
    } else {
        startInit();
    }
})();
