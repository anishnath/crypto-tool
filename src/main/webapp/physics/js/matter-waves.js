/**
 * Matter Waves (de Broglie) - λ = h/p, accelerated electron, relativistic, phase & group velocity
 */
(function () {
    'use strict';

    var h = 6.626e-34;      // J·s
    var c = 2.998e8;        // m/s
    var e = 1.602e-19;      // C
    var m_e = 9.109e-31;    // kg
    var m_p = 1.673e-27;    // kg
    var lambda_Ang_per_sqrtV = 12.27; // λ (Å) ≈ 12.27/√V for electron

    function getActiveTab() {
        var t = document.querySelector('.mw-tab.active');
        return t ? t.getAttribute('data-tab') : 'lambda';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6) return x.toExponential(2);
        if (Math.abs(x) < 1e-10 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesLambda() {
        var input = document.getElementById('lambda-input').value;
        var p_kgms;
        if (input === 'p') {
            var pRaw = parseFloat(document.getElementById('lambda-p').value) || 0;
            p_kgms = pRaw;
        } else {
            var mRaw = parseFloat(document.getElementById('lambda-m').value) || 0;
            var vRaw = parseFloat(document.getElementById('lambda-v').value) || 0;
            p_kgms = mRaw * vRaw;
        }
        if (p_kgms <= 0) return { p: 0, lambda_m: Infinity, lambda_Ang: Infinity };
        var lambda_m = h / p_kgms;
        var lambda_Ang = lambda_m * 1e10;
        return { p: p_kgms, lambda_m: lambda_m, lambda_Ang: lambda_Ang, input: input };
    }

    function getValuesAccelerated() {
        var vRaw = parseFloat(document.getElementById('accel-v').value) || 0;
        var vUnit = document.getElementById('accel-v-unit').value;
        var V = vUnit === 'kV' ? vRaw * 1000 : vRaw;
        if (V <= 0) return { V: 0, lambda_m: Infinity, lambda_Ang: Infinity };
        var lambda_m = h / Math.sqrt(2 * m_e * e * V);
        var lambda_Ang = lambda_m * 1e10;
        var approx_Ang = lambda_Ang_per_sqrtV / Math.sqrt(V);
        return { V: V, lambda_m: lambda_m, lambda_Ang: lambda_Ang, approx_Ang: approx_Ang };
    }

    function getValuesRelativistic() {
        var input = document.getElementById('rel-input').value;
        var massOpt = document.getElementById('rel-mass').value;
        var m0 = massOpt === 'proton' ? m_p : m_e;
        var gamma, v_ms;
        if (input === 'v') {
            var vRaw = parseFloat(document.getElementById('rel-v').value) || 0;
            var vUnit = document.getElementById('rel-v-unit').value;
            v_ms = vUnit === 'c' ? vRaw * c : vRaw;
            if (v_ms >= c) return { gamma: Infinity, lambda_m: 0, v: v_ms, m0: m0 };
            gamma = 1 / Math.sqrt(1 - (v_ms * v_ms) / (c * c));
        } else {
            gamma = parseFloat(document.getElementById('rel-gamma').value) || 1;
            if (gamma < 1) gamma = 1;
            var beta = Math.sqrt(1 - 1 / (gamma * gamma));
            v_ms = beta * c;
        }
        var K_rel = (gamma - 1) * m0 * c * c;
        if (K_rel <= 0) return { gamma: gamma, lambda_m: Infinity, lambda_Ang: Infinity, v: v_ms, m0: m0 };
        var lambda_m = h / Math.sqrt(2 * m0 * (gamma - 1) * c * c);
        var lambda_Ang = lambda_m * 1e10;
        return { gamma: gamma, v: v_ms, m0: m0, K_rel: K_rel, lambda_m: lambda_m, lambda_Ang: lambda_Ang, input: input };
    }

    function getValuesPhase() {
        var vRaw = parseFloat(document.getElementById('phase-v').value) || 0;
        var vUnit = document.getElementById('phase-v-unit').value;
        var v_ms = vUnit === 'c' ? vRaw * c : vRaw;
        if (v_ms <= 0) return { v: 0, v_phase: Infinity };
        var v_phase = (c * c) / v_ms;
        return { v: v_ms, v_phase: v_phase };
    }

    function getValuesGroup() {
        var vRaw = parseFloat(document.getElementById('group-v').value) || 0;
        var vUnit = document.getElementById('group-v-unit').value;
        var v_ms = vUnit === 'm/s' ? vRaw : vRaw;
        return { v_group: v_ms };
    }

    function buildStepsLambda(data) {
        var steps = [];
        steps.push({ title: 'de Broglie wavelength', formula: 'λ = h / p', calc: 'λ = (6.626×10⁻³⁴) / ' + formatNum(data.p) + ' = ' + formatNum(data.lambda_m) + ' m = ' + formatNum(data.lambda_Ang) + ' Å' });
        return steps;
    }

    function buildStepsAccelerated(data) {
        var steps = [];
        steps.push({ title: 'Wavelength (electron)', formula: 'λ = h / √(2 m e V)', calc: 'λ = h / √(2 × 9.109×10⁻³¹ × 1.602×10⁻¹⁹ × ' + formatNum(data.V) + ') = ' + formatNum(data.lambda_m) + ' m = ' + formatNum(data.lambda_Ang) + ' Å' });
        steps.push({ title: 'Approximation', formula: 'λ (Å) ≈ 12.27 / √V', calc: 'λ ≈ 12.27 / √' + formatNum(data.V) + ' = ' + formatNum(data.approx_Ang) + ' Å' });
        return steps;
    }

    function buildStepsRelativistic(data) {
        var steps = [];
        if (data.lambda_m === Infinity || data.K_rel <= 0) {
            steps.push({ title: 'Relativistic λ', formula: 'λ = h / √(2 m₀ c² (γ − 1))', calc: 'γ − 1 ≤ 0 or invalid; λ not defined.' });
            return steps;
        }
        steps.push({ title: 'Lorentz factor', formula: 'γ = 1/√(1 − v²/c²)', calc: 'γ = ' + formatNum(data.gamma) + ', v = ' + formatNum(data.v) + ' m/s' });
        steps.push({ title: 'Relativistic de Broglie λ', formula: 'λ = h / √(2 m₀ c² (γ − 1))', calc: 'λ = ' + formatNum(data.lambda_m) + ' m = ' + formatNum(data.lambda_Ang) + ' Å' });
        return steps;
    }

    function buildStepsPhase(data) {
        var steps = [];
        steps.push({ title: 'Phase velocity', formula: 'v_phase = c² / v', calc: 'v_phase = (2.998×10⁸)² / ' + formatNum(data.v) + ' = ' + formatNum(data.v_phase) + ' m/s' });
        return steps;
    }

    function buildStepsGroup(data) {
        var steps = [];
        steps.push({ title: 'Group velocity', formula: 'v_group = v (particle velocity)', calc: 'v_group = ' + formatNum(data.v_group) + ' m/s' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('mw-steps-body');
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

    function drawViz(tab, data) {
        var placeholder = document.getElementById('mw-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'lambda' && data && data.lambda_Ang != null)
            html = 'λ = h/p = <span class="highlight">' + formatNum(data.lambda_Ang) + ' Å</span>';
        else if (tab === 'accelerated' && data && data.lambda_Ang != null)
            html = 'V = ' + formatNum(data.V) + ' V → λ = <span class="highlight">' + formatNum(data.lambda_Ang) + ' Å</span> (λ ≈ 12.27/√V)';
        else if (tab === 'relativistic' && data && data.lambda_Ang != null && data.lambda_m !== Infinity)
            html = 'γ = ' + formatNum(data.gamma) + ' → λ = <span class="highlight">' + formatNum(data.lambda_Ang) + ' Å</span>';
        else if (tab === 'phase' && data && data.v_phase != null)
            html = 'v = ' + formatNum(data.v) + ' m/s → v_phase = c²/v = <span class="highlight">' + formatNum(data.v_phase) + ' m/s</span>';
        else if (tab === 'group' && data && data.v_group != null)
            html = 'v_group = v = <span class="highlight">' + formatNum(data.v_group) + ' m/s</span>';
        else
            html = 'Run a calculation to see result.';
        placeholder.innerHTML = html;
    }

    function runMatterWaves() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'lambda') {
            data = getValuesLambda();
            resultEl = document.getElementById('lambda-result');
            resultText = data.lambda_Ang < 1e10 ? formatNum(data.lambda_Ang) + ' Å' : formatNum(data.lambda_m) + ' m';
            if (data.p <= 0) resultText = '—';
            steps = buildStepsLambda(data);
        } else if (tab === 'accelerated') {
            data = getValuesAccelerated();
            resultEl = document.getElementById('accel-result');
            resultText = data.V > 0 ? formatNum(data.lambda_Ang) + ' Å' : '—';
            steps = buildStepsAccelerated(data);
        } else if (tab === 'relativistic') {
            data = getValuesRelativistic();
            resultEl = document.getElementById('rel-result');
            resultText = data.lambda_m != null && data.lambda_m !== Infinity ? formatNum(data.lambda_Ang) + ' Å' : '—';
            steps = buildStepsRelativistic(data);
        } else if (tab === 'phase') {
            data = getValuesPhase();
            resultEl = document.getElementById('phase-result');
            resultText = data.v > 0 ? formatNum(data.v_phase) + ' m/s' : '—';
            steps = buildStepsPhase(data);
        } else if (tab === 'group') {
            data = getValuesGroup();
            resultEl = document.getElementById('group-result');
            resultText = formatNum(data.v_group) + ' m/s';
            steps = buildStepsGroup(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchMatterWaveTab(tabId, btn) {
        var tabs = document.querySelectorAll('.mw-tab');
        var panels = document.querySelectorAll('.mw-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.mw-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');

        if (tabId === 'lambda') {
            var input = document.getElementById('lambda-input').value;
            document.getElementById('lambda-p-section').style.display = input === 'p' ? 'block' : 'none';
            document.getElementById('lambda-mv-section').style.display = input === 'mv' ? 'block' : 'none';
            document.getElementById('lambda-v-section').style.display = input === 'mv' ? 'block' : 'none';
        }
        if (tabId === 'relativistic') {
            var relInput = document.getElementById('rel-input').value;
            document.getElementById('rel-v-section').style.display = relInput === 'v' ? 'block' : 'none';
            document.getElementById('rel-gamma-section').style.display = relInput === 'gamma' ? 'block' : 'none';
        }
        runMatterWaves();
    }

    function toggleMatterWaveSteps() {
        var body = document.getElementById('mw-steps-body');
        var toggle = document.getElementById('mw-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        var lambdaInput = document.getElementById('lambda-input');
        if (lambdaInput) {
            lambdaInput.addEventListener('change', function () {
                var input = this.value;
                document.getElementById('lambda-p-section').style.display = input === 'p' ? 'block' : 'none';
                document.getElementById('lambda-mv-section').style.display = input === 'mv' ? 'block' : 'none';
                document.getElementById('lambda-v-section').style.display = input === 'mv' ? 'block' : 'none';
            });
        }
        var relInput = document.getElementById('rel-input');
        if (relInput) {
            relInput.addEventListener('change', function () {
                var input = this.value;
                document.getElementById('rel-v-section').style.display = input === 'v' ? 'block' : 'none';
                document.getElementById('rel-gamma-section').style.display = input === 'gamma' ? 'block' : 'none';
            });
        }
        runMatterWaves();
    });

    window.runMatterWaves = runMatterWaves;
    window.switchMatterWaveTab = switchMatterWaveTab;
    window.toggleMatterWaveSteps = toggleMatterWaveSteps;
})();
