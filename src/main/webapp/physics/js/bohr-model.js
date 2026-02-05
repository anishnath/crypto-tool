/**
 * Bohr Model (Atomic Structure) - radius, velocity, energy, transition, Rydberg, angular momentum
 * Matter.js orbit visualization: nucleus + electron on circular constraint
 */
(function () {
    'use strict';

    var r1_Ang = 0.529;           // Bohr radius for H (Å), r_n = r1 * n² / Z
    var v1_ms = 2.19e6;           // v_n = v1 * Z / n (m/s) for H-like
    var E1_eV = 13.6;             // |E1| = 13.6 eV, E_n = -13.6 Z²/n² eV
    var R_m = 1.097e7;            // Rydberg constant (m⁻¹)
    var h = 6.626e-34;            // J·s
    var c = 2.998e8;              // m/s
    var e_J = 1.602e-19;          // C, for eV to J: E_J = E_eV * e_J
    var hbar = 1.055e-34;         // ℏ = h/(2π) J·s

    var matterEngine = null;
    var matterRender = null;
    var nucleusBody = null;
    var electronBody = null;
    var orbitConstraint = null;

    function getActiveTab() {
        var t = document.querySelector('.bohr-tab.active');
        return t ? t.getAttribute('data-tab') : 'radius';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6) return x.toExponential(2);
        if (Math.abs(x) < 0.0001 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesRadius() {
        var n = parseInt(document.getElementById('radius-n').value) || 1;
        var Z = parseInt(document.getElementById('radius-z').value) || 1;
        if (n < 1) n = 1;
        if (Z < 1) Z = 1;
        var r_Ang = (r1_Ang * n * n) / Z;
        var r_m = r_Ang * 1e-10;
        return { n: n, Z: Z, r_Ang: r_Ang, r_m: r_m };
    }

    function getValuesVelocity() {
        var n = parseInt(document.getElementById('velocity-n').value) || 1;
        var Z = parseInt(document.getElementById('velocity-z').value) || 1;
        if (n < 1) n = 1;
        if (Z < 1) Z = 1;
        var v_ms = (v1_ms * Z) / n;
        return { n: n, Z: Z, v_ms: v_ms };
    }

    function getValuesEnergy() {
        var n = parseInt(document.getElementById('energy-n').value) || 1;
        var Z = parseInt(document.getElementById('energy-z').value) || 1;
        if (n < 1) n = 1;
        if (Z < 1) Z = 1;
        var E_eV = -(E1_eV * Z * Z) / (n * n);
        return { n: n, Z: Z, E_eV: E_eV };
    }

    function getValuesTransition() {
        var n2 = parseInt(document.getElementById('trans-n2').value) || 2;
        var n1 = parseInt(document.getElementById('trans-n1').value) || 1;
        var Z = parseInt(document.getElementById('trans-z').value) || 1;
        if (n1 < 1) n1 = 1;
        if (n2 < 1) n2 = 1;
        if (n2 <= n1) { n2 = n1 + 1; }
        if (Z < 1) Z = 1;
        var dE_eV = E1_eV * Z * Z * (1 / (n1 * n1) - 1 / (n2 * n2));
        if (dE_eV <= 0) return { n1: n1, n2: n2, Z: Z, dE_eV: 0, lambda_m: Infinity, nu_Hz: 0 };
        var dE_J = dE_eV * e_J;
        var lambda_m = (h * c) / dE_J;
        var nu_Hz = dE_J / h;
        var lambda_nm = lambda_m * 1e9;
        return { n1: n1, n2: n2, Z: Z, dE_eV: dE_eV, dE_J: dE_J, lambda_m: lambda_m, lambda_nm: lambda_nm, nu_Hz: nu_Hz };
    }

    function getValuesRydberg() {
        var n1 = parseInt(document.getElementById('ryd-n1').value) || 2;
        var n2 = parseInt(document.getElementById('ryd-n2').value) || 4;
        var Z = parseInt(document.getElementById('ryd-z').value) || 1;
        if (n1 < 1) n1 = 1;
        if (n2 < 1) n2 = 1;
        if (n2 <= n1) n2 = n1 + 1;
        if (Z < 1) Z = 1;
        var one_over_lambda = R_m * Z * Z * (1 / (n1 * n1) - 1 / (n2 * n2));
        var lambda_m = one_over_lambda > 0 ? 1 / one_over_lambda : Infinity;
        var lambda_nm = lambda_m * 1e9;
        return { n1: n1, n2: n2, Z: Z, one_over_lambda: one_over_lambda, lambda_m: lambda_m, lambda_nm: lambda_nm };
    }

    function getValuesAngular() {
        var n = parseInt(document.getElementById('angular-n').value) || 1;
        if (n < 1) n = 1;
        var L = n * hbar;
        return { n: n, L: L };
    }

    function buildStepsRadius(data) {
        var steps = [];
        steps.push({ title: 'Radius of nth orbit', formula: 'rₙ = 0.529 n² / Z Å (hydrogen-like)', calc: 'rₙ = 0.529 × ' + data.n + '² / ' + data.Z + ' = ' + formatNum(data.r_Ang) + ' Å = ' + formatNum(data.r_m) + ' m' });
        return steps;
    }

    function buildStepsVelocity(data) {
        var steps = [];
        steps.push({ title: 'Velocity of electron', formula: 'vₙ = (2.19×10⁶ × Z / n) m/s', calc: 'vₙ = 2.19×10⁶ × ' + data.Z + ' / ' + data.n + ' = ' + formatNum(data.v_ms) + ' m/s' });
        return steps;
    }

    function buildStepsEnergy(data) {
        var steps = [];
        steps.push({ title: 'Energy of nth orbit', formula: 'Eₙ = −13.6 Z² / n² eV', calc: 'Eₙ = −13.6 × ' + data.Z + '² / ' + data.n + '² = ' + formatNum(data.E_eV) + ' eV' });
        return steps;
    }

    function buildStepsTransition(data) {
        var steps = [];
        if (data.dE_eV <= 0) {
            steps.push({ title: 'Transition', formula: 'ΔE = 13.6 Z² (1/n₁² − 1/n₂²) eV', calc: 'Need n₂ > n₁ for emission.' });
            return steps;
        }
        steps.push({ title: 'Energy difference', formula: 'ΔE = 13.6 Z² (1/n₁² − 1/n₂²) eV', calc: 'ΔE = 13.6 × ' + data.Z + '² × (1/' + data.n1 + '² − 1/' + data.n2 + '²) = ' + formatNum(data.dE_eV) + ' eV' });
        steps.push({ title: 'Wavelength', formula: 'λ = hc / ΔE', calc: 'λ = ' + formatNum(data.lambda_m) + ' m = ' + formatNum(data.lambda_nm) + ' nm' });
        steps.push({ title: 'Frequency', formula: 'ν = ΔE / h', calc: 'ν = ' + formatNum(data.nu_Hz) + ' Hz' });
        return steps;
    }

    function buildStepsRydberg(data) {
        var steps = [];
        steps.push({ title: 'Rydberg formula', formula: '1/λ = R Z² (1/n₁² − 1/n₂²)', calc: '1/λ = 1.097×10⁷ × ' + data.Z + '² × (1/' + data.n1 + '² − 1/' + data.n2 + '²) = ' + formatNum(data.one_over_lambda) + ' m⁻¹' });
        steps.push({ title: 'Wavelength', formula: 'λ = 1 / (1/λ)', calc: 'λ = ' + formatNum(data.lambda_nm) + ' nm' });
        return steps;
    }

    function buildStepsAngular(data) {
        var steps = [];
        steps.push({ title: 'Angular momentum', formula: 'L = n ℏ = n h / (2π)', calc: 'L = ' + data.n + ' × 1.055×10⁻³⁴ = ' + formatNum(data.L) + ' J·s' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('bohr-steps-body');
        if (!container) return;
        container.innerHTML = '';
        steps.forEach(function (s, i) {
            var div = document.createElement('div');
            div.className = 'step-item';
            div.innerHTML = '<div class="step-title"><span class="step-number">' + (i + 1) + '</span>' + s.title + '</div>' +
                (s.formula ? '<div class="step-formula">' + s.formula + '</div>' : '') +
                (s.calc ? '<div class="step-calc">' + s.calc + '</div>' : '');
            container.appendChild(div);
        });
    }

    function seriesName(n1) {
        if (n1 === 1) return 'Lyman';
        if (n1 === 2) return 'Balmer';
        if (n1 === 3) return 'Paschen';
        if (n1 === 4) return 'Brackett';
        if (n1 === 5) return 'Pfund';
        return 'n₁=' + n1;
    }

    function getVizParams(tab) {
        var n = 1, Z = 1;
        if (tab === 'radius') { var r = getValuesRadius(); n = r.n; Z = r.Z; }
        else if (tab === 'velocity') { var v = getValuesVelocity(); n = v.n; Z = v.Z; }
        else if (tab === 'energy') { var e = getValuesEnergy(); n = e.n; Z = e.Z; }
        else if (tab === 'transition') { var t = getValuesTransition(); n = t.n2; Z = t.Z; }
        else if (tab === 'rydberg') { var ry = getValuesRydberg(); n = ry.n2; Z = ry.Z; }
        else if (tab === 'angular') { var a = getValuesAngular(); n = a.n; Z = 1; }
        var r_Ang = (r1_Ang * n * n) / Z;
        return { n: n, Z: Z, r_Ang: r_Ang };
    }

    function initBohrMatter(w, h) {
        if (typeof Matter === 'undefined') return;
        var Engine = Matter.Engine;
        var Render = Matter.Render;
        var World = Matter.World;
        var Bodies = Matter.Bodies;

        matterEngine = Engine.create();
        matterEngine.world.gravity.y = 0;

        var canvas = document.getElementById('bohr-viz-canvas');
        if (!canvas) return;

        // Use logical dimensions for Matter.js (not scaled by pixel ratio)
        matterRender = Render.create({
            canvas: canvas,
            engine: matterEngine,
            options: {
                width: w,
                height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: 1 // Let CSS handle scaling
            }
        });

        var cx = w / 2;
        var cy = h / 2;
        var size = Math.min(w, h);
        var nucleusRadius = Math.max(8, size * 0.04);
        nucleusBody = Bodies.circle(cx, cy, nucleusRadius, {
            isStatic: true,
            render: { fillStyle: '#059669', strokeStyle: '#047857', lineWidth: 2 }
        });
        World.add(matterEngine.world, nucleusBody);

        Matter.Runner.run(matterEngine);
        Matter.Render.run(matterRender);
    }

    function updateBohrOrbit(r_Ang, w, h) {
        if (typeof Matter === 'undefined') return;
        var World = Matter.World;
        var Bodies = Matter.Bodies;
        var Constraint = Matter.Constraint;
        var Body = Matter.Body;

        var cx = w / 2;
        var cy = h / 2;
        var size = Math.min(w, h);
        var maxRadiusPx = size * 0.38;
        var radiusPx = Math.min(maxRadiusPx * Math.min(r_Ang / 5, 1), maxRadiusPx);
        if (radiusPx < 12) radiusPx = 12;

        if (!matterEngine || !matterRender) {
            initBohrMatter(w, h);
            if (!matterEngine) return;
        }

        // Update Matter.js render to match canvas dimensions
        if (matterRender) {
            matterRender.options.width = w;
            matterRender.options.height = h;
            matterRender.bounds.min.x = 0;
            matterRender.bounds.min.y = 0;
            matterRender.bounds.max.x = w;
            matterRender.bounds.max.y = h;
        }
        if (nucleusBody) Matter.Body.setPosition(nucleusBody, { x: cx, y: cy });

        if (orbitConstraint) {
            World.remove(matterEngine.world, orbitConstraint);
            orbitConstraint = null;
        }
        if (electronBody) {
            World.remove(matterEngine.world, electronBody);
            electronBody = null;
        }

        var electronRadius = Math.max(6, size * 0.028);
        electronBody = Bodies.circle(cx + radiusPx, cy, electronRadius, {
            density: 0.001,
            friction: 0,
            frictionAir: 0,
            restitution: 0,
            render: { fillStyle: '#2563eb', strokeStyle: '#1d4ed8', lineWidth: 2 }
        });

        orbitConstraint = Constraint.create({
            pointA: { x: cx, y: cy },
            bodyB: electronBody,
            length: radiusPx,
            stiffness: 1,
            damping: 0
        });

        var tangentialSpeed = (2 * Math.PI * radiusPx) / 2.5;
        Body.setVelocity(electronBody, { x: 0, y: -tangentialSpeed });

        World.add(matterEngine.world, [electronBody, orbitConstraint]);
    }

    function drawViz(tab, data) {
        var container = document.getElementById('bohr-viz-container');
        var canvas = document.getElementById('bohr-viz-canvas');
        var placeholder = document.getElementById('bohr-viz-placeholder');
        if (!container) return;

        // Get actual inner dimensions of container
        var w = Math.max(200, container.clientWidth || 400);
        var h = Math.max(180, container.clientHeight || 280);

        if (canvas) {
            // Set canvas internal buffer dimensions (CSS handles display size)
            canvas.width = w;
            canvas.height = h;
            canvas.style.display = 'none';
        }
        if (placeholder) placeholder.style.display = 'flex';

        var html = '';
        if (tab === 'radius' && data) html = 'rₙ = <span class="highlight">' + formatNum(data.r_Ang) + ' Å</span> (n=' + data.n + ', Z=' + data.Z + ')';
        else if (tab === 'velocity' && data) html = 'vₙ = <span class="highlight">' + formatNum(data.v_ms) + ' m/s</span>';
        else if (tab === 'energy' && data) html = 'Eₙ = <span class="highlight">' + formatNum(data.E_eV) + ' eV</span>';
        else if (tab === 'transition' && data && data.dE_eV > 0) html = 'ΔE = ' + formatNum(data.dE_eV) + ' eV, λ = ' + formatNum(data.lambda_nm) + ' nm';
        else if (tab === 'rydberg' && data) html = '1/λ = ' + formatNum(data.one_over_lambda) + ' m⁻¹, λ = ' + formatNum(data.lambda_nm) + ' nm (' + seriesName(data.n1) + ')';
        else if (tab === 'angular' && data) html = 'L = n ℏ = <span class="highlight">' + formatNum(data.L) + ' J·s</span>';
        if (placeholder) placeholder.innerHTML = html || 'Run a calculation to see result.';

        var vizParams = getVizParams(tab);
        if (vizParams && vizParams.r_Ang > 0 && typeof Matter !== 'undefined') {
            updateBohrOrbit(vizParams.r_Ang, w, h);
            if (canvas) canvas.style.display = 'block';
            if (placeholder) placeholder.style.display = 'none';
        }
    }

    function runBohrModel() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'radius') {
            data = getValuesRadius();
            resultEl = document.getElementById('radius-result');
            resultText = formatNum(data.r_Ang) + ' Å';
            steps = buildStepsRadius(data);
        } else if (tab === 'velocity') {
            data = getValuesVelocity();
            resultEl = document.getElementById('velocity-result');
            resultText = formatNum(data.v_ms) + ' m/s';
            steps = buildStepsVelocity(data);
        } else if (tab === 'energy') {
            data = getValuesEnergy();
            resultEl = document.getElementById('energy-result');
            resultText = formatNum(data.E_eV) + ' eV';
            steps = buildStepsEnergy(data);
        } else if (tab === 'transition') {
            data = getValuesTransition();
            resultEl = document.getElementById('trans-result');
            if (data.dE_eV > 0) resultText = 'ΔE = ' + formatNum(data.dE_eV) + ' eV, λ = ' + formatNum(data.lambda_nm) + ' nm';
            else resultText = 'Set n₂ > n₁ for emission.';
            steps = buildStepsTransition(data);
        } else if (tab === 'rydberg') {
            data = getValuesRydberg();
            resultEl = document.getElementById('ryd-result');
            resultText = '1/λ = ' + formatNum(data.one_over_lambda) + ' m⁻¹, λ = ' + formatNum(data.lambda_nm) + ' nm';
            steps = buildStepsRydberg(data);
        } else if (tab === 'angular') {
            data = getValuesAngular();
            resultEl = document.getElementById('angular-result');
            resultText = formatNum(data.L) + ' J·s';
            steps = buildStepsAngular(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchBohrTab(tabId, btn) {
        var tabs = document.querySelectorAll('.bohr-tab');
        var panels = document.querySelectorAll('.bohr-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.bohr-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');
        runBohrModel();
    }

    function toggleBohrSteps() {
        var body = document.getElementById('bohr-steps-body');
        var toggle = document.getElementById('bohr-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        runBohrModel();
        document.querySelectorAll('.number-input').forEach(function (inp) { inp.addEventListener('input', runBohrModel); });
        window.addEventListener('resize', function () { runBohrModel(); });
    });

    window.runBohrModel = runBohrModel;
    window.switchBohrTab = switchBohrTab;
    window.toggleBohrSteps = toggleBohrSteps;
})();
