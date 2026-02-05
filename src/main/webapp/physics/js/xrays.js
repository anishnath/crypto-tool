/**
 * X-Rays - cut-off wavelength, Moseley's law, Kα line energy
 */
(function () {
    'use strict';

    var hc_eV_Ang = 12400;   // hc in eV·Å, λ_min (Å) = 12400 / V (V in volts)
    var E_Kalpha_coeff = 13.6 * (1 / 1 - 1 / 4);  // 13.6 * (1/1² - 1/2²) = 10.2 eV

    function getActiveTab() {
        var t = document.querySelector('.xray-tab.active');
        return t ? t.getAttribute('data-tab') : 'cutoff';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e9) return x.toExponential(2);
        if (Math.abs(x) < 0.0001 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesCutoff() {
        var vRaw = parseFloat(document.getElementById('cutoff-v').value) || 0;
        var vUnit = document.getElementById('cutoff-v-unit').value;
        var V_volts = vUnit === 'kV' ? vRaw * 1000 : vRaw;
        if (V_volts <= 0) return { V: 0, lambda_Ang: Infinity };
        var lambda_Ang = hc_eV_Ang / V_volts;
        return { V: V_volts, vRaw: vRaw, vUnit: vUnit, lambda_Ang: lambda_Ang };
    }

    function getValuesMoseley() {
        var Z = parseFloat(document.getElementById('moseley-z').value) || 1;
        var b = parseFloat(document.getElementById('moseley-b').value) || 1;
        var a_times_1e7 = parseFloat(document.getElementById('moseley-a').value) || 4.96;
        var a = a_times_1e7 * 1e7;  // a in √Hz
        var zMinusB = Z - b;
        if (zMinusB <= 0) return { Z: Z, b: b, a: a, sqrt_nu: 0, nu: 0 };
        var sqrt_nu = a * zMinusB;
        var nu = sqrt_nu * sqrt_nu;
        return { Z: Z, b: b, a: a, a_times_1e7: a_times_1e7, sqrt_nu: sqrt_nu, nu: nu };
    }

    function getValuesKalpha() {
        var Z = parseInt(document.getElementById('kalpha-z').value) || 2;
        if (Z < 2) Z = 2;
        var E_eV = E_Kalpha_coeff * (Z - 1) * (Z - 1);
        return { Z: Z, E_eV: E_eV };
    }

    function buildStepsCutoff(data) {
        var steps = [];
        steps.push({ title: 'Cut-off wavelength', formula: 'λ_min = hc/(eV) = 12400/V (Å)', calc: 'λ_min = 12400 / ' + formatNum(data.V) + ' = ' + formatNum(data.lambda_Ang) + ' Å' });
        return steps;
    }

    function buildStepsMoseley(data) {
        var steps = [];
        if (data.Z - data.b <= 0) {
            steps.push({ title: "Moseley's law", formula: '√ν = a (Z − b)', calc: 'Z − b must be positive.' });
            return steps;
        }
        steps.push({ title: "Moseley's law", formula: '√ν = a (Z − b)', calc: '√ν = ' + formatNum(data.a) + ' × (' + data.Z + ' − ' + data.b + ') = ' + formatNum(data.sqrt_nu) + ' √Hz' });
        steps.push({ title: 'Frequency', formula: 'ν = (√ν)²', calc: 'ν = ' + formatNum(data.nu) + ' Hz' });
        return steps;
    }

    function buildStepsKalpha(data) {
        var steps = [];
        steps.push({ title: 'Kα line energy', formula: 'E = 13.6 (Z−1)² (1/1² − 1/2²) eV = 10.2 (Z−1)² eV', calc: 'E = 10.2 × (' + data.Z + ' − 1)² = ' + formatNum(data.E_eV) + ' eV' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('xray-steps-body');
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
        var placeholder = document.getElementById('xray-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'cutoff' && data && data.lambda_Ang != null) html = 'λ_min = <span class="highlight">' + formatNum(data.lambda_Ang) + ' Å</span> (V = ' + formatNum(data.V) + ' V)';
        else if (tab === 'moseley' && data && data.nu != null) html = '√ν = ' + formatNum(data.sqrt_nu) + ' √Hz, ν = <span class="highlight">' + formatNum(data.nu) + ' Hz</span>';
        else if (tab === 'kalpha' && data) html = 'Kα energy = <span class="highlight">' + formatNum(data.E_eV) + ' eV</span>';
        else html = 'Run a calculation to see result.';
        placeholder.innerHTML = html;
    }

    function runXrays() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'cutoff') {
            data = getValuesCutoff();
            resultEl = document.getElementById('cutoff-result');
            resultText = data.V > 0 ? formatNum(data.lambda_Ang) + ' Å' : '—';
            steps = buildStepsCutoff(data);
        } else if (tab === 'moseley') {
            data = getValuesMoseley();
            resultEl = document.getElementById('moseley-result');
            resultText = data.nu > 0 ? '√ν = ' + formatNum(data.sqrt_nu) + ' √Hz, ν = ' + formatNum(data.nu) + ' Hz' : '—';
            steps = buildStepsMoseley(data);
        } else if (tab === 'kalpha') {
            data = getValuesKalpha();
            resultEl = document.getElementById('kalpha-result');
            resultText = formatNum(data.E_eV) + ' eV';
            steps = buildStepsKalpha(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchXrayTab(tabId, btn) {
        var tabs = document.querySelectorAll('.xray-tab');
        var panels = document.querySelectorAll('.xray-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.xray-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');
        runXrays();
    }

    function toggleXraySteps() {
        var body = document.getElementById('xray-steps-body');
        var toggle = document.getElementById('xray-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        runXrays();
    });

    window.runXrays = runXrays;
    window.switchXrayTab = switchXrayTab;
    window.toggleXraySteps = toggleXraySteps;
})();
