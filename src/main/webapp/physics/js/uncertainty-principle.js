/**
 * Heisenberg Uncertainty Principle - position-momentum and energy-time
 * Δx · Δp ≥ ℏ/2,  ΔE · Δt ≥ ℏ/2
 */
(function () {
    'use strict';

    var h = 6.626e-34;           // J·s
    var hbar = 1.054571817e-34;   // ℏ = h/(2π) J·s
    var half_hbar = hbar / 2;     // ℏ/2
    var eV_to_J = 1.602e-19;

    var lengthToM = { 'm': 1, 'nm': 1e-9, 'pm': 1e-12 };
    var timeToS = { 's': 1, 'ms': 1e-3, 'ns': 1e-9 };

    function getActiveTab() {
        var t = document.querySelector('.unc-tab.active');
        return t ? t.getAttribute('data-tab') : 'xp';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6) return x.toExponential(2);
        if (Math.abs(x) < 1e-15 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesXP() {
        var solve = document.getElementById('xp-solve').value;
        var dx_m, dp_kgms;
        if (solve === 'dp') {
            var dxRaw = parseFloat(document.getElementById('xp-dx').value) || 0;
            var dxUnit = document.getElementById('xp-dx-unit').value;
            dx_m = dxRaw * (lengthToM[dxUnit] || 1);
            if (dx_m <= 0) return { solve: 'dp', dx_m: 0, dp_min: Infinity };
            dp_kgms = half_hbar / dx_m;
            return { solve: 'dp', dx_m: dx_m, dxRaw: dxRaw, dxUnit: dxUnit, dp_min: dp_kgms };
        } else {
            var dpRaw = parseFloat(document.getElementById('xp-dp').value) || 0;
            dp_kgms = dpRaw;
            if (dp_kgms <= 0) return { solve: 'dx', dp_kgms: 0, dx_min: Infinity };
            dx_m = half_hbar / dp_kgms;
            return { solve: 'dx', dp_kgms: dp_kgms, dpRaw: dpRaw, dx_min: dx_m };
        }
    }

    function getValuesET() {
        var solve = document.getElementById('et-solve').value;
        var dt_s, de_J;
        if (solve === 'de') {
            var dtRaw = parseFloat(document.getElementById('et-dt').value) || 0;
            var dtUnit = document.getElementById('et-dt-unit').value;
            dt_s = dtRaw * (timeToS[dtUnit] || 1);
            if (dt_s <= 0) return { solve: 'de', dt_s: 0, de_min_J: Infinity, de_min_eV: Infinity };
            de_J = half_hbar / dt_s;
            return { solve: 'de', dt_s: dt_s, dtRaw: dtRaw, dtUnit: dtUnit, de_min_J: de_J, de_min_eV: de_J / eV_to_J };
        } else {
            var deRaw = parseFloat(document.getElementById('et-de').value) || 0;
            var deUnit = document.getElementById('et-de-unit').value;
            de_J = deUnit === 'eV' ? deRaw * eV_to_J : deRaw;
            if (de_J <= 0) return { solve: 'dt', de_J: 0, dt_min: Infinity };
            dt_s = half_hbar / de_J;
            return { solve: 'dt', de_J: de_J, deRaw: deRaw, deUnit: deUnit, dt_min: dt_s };
        }
    }

    function buildStepsXP(data) {
        var steps = [];
        if (data.solve === 'dp') {
            steps.push({ title: 'Minimum momentum uncertainty', formula: 'Δp ≥ ℏ/(2 Δx)', calc: 'Δp_min = ℏ/2 / Δx = ' + formatNum(half_hbar) + ' / ' + formatNum(data.dx_m) + ' = ' + formatNum(data.dp_min) + ' kg·m/s' });
        } else {
            steps.push({ title: 'Minimum position uncertainty', formula: 'Δx ≥ ℏ/(2 Δp)', calc: 'Δx_min = ℏ/2 / Δp = ' + formatNum(half_hbar) + ' / ' + formatNum(data.dp_kgms) + ' = ' + formatNum(data.dx_min) + ' m' });
        }
        return steps;
    }

    function buildStepsET(data) {
        var steps = [];
        if (data.solve === 'de') {
            steps.push({ title: 'Minimum energy uncertainty', formula: 'ΔE ≥ ℏ/(2 Δt)', calc: 'ΔE_min = ℏ/2 / Δt = ' + formatNum(half_hbar) + ' / ' + formatNum(data.dt_s) + ' = ' + formatNum(data.de_min_J) + ' J = ' + formatNum(data.de_min_eV) + ' eV' });
        } else {
            steps.push({ title: 'Minimum time uncertainty', formula: 'Δt ≥ ℏ/(2 ΔE)', calc: 'Δt_min = ℏ/2 / ΔE = ' + formatNum(half_hbar) + ' / ' + formatNum(data.de_J) + ' = ' + formatNum(data.dt_min) + ' s' });
        }
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('unc-steps-body');
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
        var placeholder = document.getElementById('unc-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'xp' && data) {
            if (data.solve === 'dp') html = 'Δx = ' + formatNum(data.dx_m) + ' m → Δp_min = <span class="highlight">' + formatNum(data.dp_min) + ' kg·m/s</span>';
            else html = 'Δp = ' + formatNum(data.dp_kgms) + ' kg·m/s → Δx_min = <span class="highlight">' + formatNum(data.dx_min) + ' m</span>';
        } else if (tab === 'et' && data) {
            if (data.solve === 'de') html = 'Δt = ' + formatNum(data.dt_s) + ' s → ΔE_min = <span class="highlight">' + formatNum(data.de_min_eV) + ' eV</span>';
            else html = 'ΔE = ' + formatNum(data.de_J) + ' J → Δt_min = <span class="highlight">' + formatNum(data.dt_min) + ' s</span>';
        } else html = 'Run a calculation to see result.';
        placeholder.innerHTML = html;
    }

    function runUncertainty() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'xp') {
            data = getValuesXP();
            resultEl = document.getElementById('xp-result');
            if (data.solve === 'dp') resultText = 'Δp_min = ' + formatNum(data.dp_min) + ' kg·m/s';
            else resultText = 'Δx_min = ' + formatNum(data.dx_min) + ' m';
            if (data.dp_min === Infinity || data.dx_min === Infinity) resultText = '—';
            steps = buildStepsXP(data);
        } else if (tab === 'et') {
            data = getValuesET();
            resultEl = document.getElementById('et-result');
            if (data.solve === 'de') resultText = 'ΔE_min = ' + formatNum(data.de_min_eV) + ' eV';
            else resultText = 'Δt_min = ' + formatNum(data.dt_min) + ' s';
            if (data.de_min_J === Infinity || data.dt_min === Infinity) resultText = '—';
            steps = buildStepsET(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchUncertaintyTab(tabId, btn) {
        var tabs = document.querySelectorAll('.unc-tab');
        var panels = document.querySelectorAll('.unc-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.unc-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');
        updateXPVisibility();
        updateETVisibility();
        runUncertainty();
    }

    function toggleUncertaintySteps() {
        var body = document.getElementById('unc-steps-body');
        var toggle = document.getElementById('unc-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    function updateXPVisibility() {
        var solve = document.getElementById('xp-solve').value;
        document.getElementById('xp-dx-section').style.display = solve === 'dp' ? 'block' : 'none';
        document.getElementById('xp-dp-section').style.display = solve === 'dx' ? 'block' : 'none';
    }

    function updateETVisibility() {
        var solve = document.getElementById('et-solve').value;
        document.getElementById('et-dt-section').style.display = solve === 'de' ? 'block' : 'none';
        document.getElementById('et-de-section').style.display = solve === 'dt' ? 'block' : 'none';
    }

    document.addEventListener('DOMContentLoaded', function () {
        var xpSolve = document.getElementById('xp-solve');
        if (xpSolve) xpSolve.addEventListener('change', updateXPVisibility);
        var etSolve = document.getElementById('et-solve');
        if (etSolve) etSolve.addEventListener('change', updateETVisibility);
        runUncertainty();
    });

    window.runUncertainty = runUncertainty;
    window.switchUncertaintyTab = switchUncertaintyTab;
    window.toggleUncertaintySteps = toggleUncertaintySteps;
})();
