/**
 * Special Relativity (basic) - Lorentz factor, length contraction, time dilation, momentum, energy, velocity addition
 */
(function () {
    'use strict';

    var c = 2.998e8;  // m/s
    var eV_per_J = 1 / 1.602e-19;

    function gamma(v_ms) {
        if (v_ms >= c) return Infinity;
        var b = v_ms / c;
        return 1 / Math.sqrt(1 - b * b);
    }

    function getActiveTab() {
        var t = document.querySelector('.rel-tab.active');
        return t ? t.getAttribute('data-tab') : 'gamma';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e15) return x.toExponential(2);
        if (Math.abs(x) < 1e-10 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesGamma() {
        var vRaw = parseFloat(document.getElementById('gamma-v').value) || 0;
        var vUnit = document.getElementById('gamma-v-unit').value;
        var v_ms = vUnit === 'c' ? vRaw * c : vRaw;
        if (v_ms < 0) v_ms = 0;
        var g = v_ms < c ? gamma(v_ms) : Infinity;
        return { v: v_ms, vFrac: v_ms / c, gamma: g };
    }

    function getValuesLength() {
        var L0 = parseFloat(document.getElementById('length-l0').value) || 0;
        var vFrac = parseFloat(document.getElementById('length-v').value) || 0;
        if (vFrac < 0) vFrac = 0;
        if (vFrac >= 1) vFrac = 0.9999;
        var v_ms = vFrac * c;
        var g = gamma(v_ms);
        var L = L0 / g;
        return { L0: L0, vFrac: vFrac, gamma: g, L: L };
    }

    function getValuesTime() {
        var dt0 = parseFloat(document.getElementById('time-t0').value) || 0;
        var vFrac = parseFloat(document.getElementById('time-v').value) || 0;
        if (vFrac < 0) vFrac = 0;
        if (vFrac >= 1) vFrac = 0.9999;
        var v_ms = vFrac * c;
        var g = gamma(v_ms);
        var dt = g * dt0;
        return { dt0: dt0, vFrac: vFrac, gamma: g, dt: dt };
    }

    function getValuesMomentum() {
        var m0 = parseFloat(document.getElementById('mom-m0').value) || 0;
        var vRaw = parseFloat(document.getElementById('mom-v').value) || 0;
        var vUnit = document.getElementById('mom-v-unit').value;
        var v_ms = vUnit === 'c' ? vRaw * c : vRaw;
        if (v_ms < 0) v_ms = 0;
        if (v_ms >= c) return { m0: m0, v: v_ms, gamma: Infinity, p: Infinity };
        var g = gamma(v_ms);
        var p = g * m0 * v_ms;
        return { m0: m0, v: v_ms, gamma: g, p: p };
    }

    function getValuesEnergy() {
        var m0 = parseFloat(document.getElementById('energy-m0').value) || 0;
        var vFrac = parseFloat(document.getElementById('energy-v').value) || 0;
        if (vFrac < 0) vFrac = 0;
        if (vFrac >= 1) vFrac = 0.9999;
        var v_ms = vFrac * c;
        var g = gamma(v_ms);
        var KE = (g - 1) * m0 * c * c;
        var E_total = g * m0 * c * c;
        var E_rest = m0 * c * c;
        return { m0: m0, vFrac: vFrac, gamma: g, KE: KE, E_total: E_total, E_rest: E_rest };
    }

    function getValuesVelocity() {
        var u = parseFloat(document.getElementById('vel-u').value) || 0;
        var v = parseFloat(document.getElementById('vel-v').value) || 0;
        // w/c = (u/c + v/c) / (1 + (u/c)(v/c)) = (u+v)/(1+uv) when u,v are in units of c
        var wFrac = (u + v) / (1 + u * v);
        if (wFrac > 0.9999) wFrac = 0.9999;
        if (wFrac < -0.9999) wFrac = -0.9999;
        return { u: u, v: v, wFrac: wFrac };
    }

    function buildStepsGamma(data) {
        var steps = [];
        steps.push({ title: 'Lorentz factor', formula: 'γ = 1 / √(1 − v²/c²)', calc: 'v/c = ' + formatNum(data.vFrac) + ' → γ = ' + formatNum(data.gamma) });
        return steps;
    }

    function buildStepsLength(data) {
        var steps = [];
        steps.push({ title: 'Length contraction', formula: 'L = L₀ / γ', calc: 'L = ' + formatNum(data.L0) + ' / ' + formatNum(data.gamma) + ' = ' + formatNum(data.L) + ' m' });
        return steps;
    }

    function buildStepsTime(data) {
        var steps = [];
        steps.push({ title: 'Time dilation', formula: 'Δt = γ Δt₀', calc: 'Δt = ' + formatNum(data.gamma) + ' × ' + formatNum(data.dt0) + ' = ' + formatNum(data.dt) + ' s' });
        return steps;
    }

    function buildStepsMomentum(data) {
        var steps = [];
        steps.push({ title: 'Relativistic momentum', formula: 'p = γ m₀ v', calc: 'p = ' + formatNum(data.gamma) + ' × ' + formatNum(data.m0) + ' × ' + formatNum(data.v) + ' = ' + formatNum(data.p) + ' kg·m/s' });
        return steps;
    }

    function buildStepsEnergy(data) {
        var steps = [];
        steps.push({ title: 'Kinetic energy', formula: 'KE = (γ − 1) m₀ c²', calc: 'KE = ' + formatNum(data.KE) + ' J = ' + formatNum(data.KE * eV_per_J * 1e-9) + ' GeV' });
        steps.push({ title: 'Total energy', formula: 'E = γ m₀ c²', calc: 'E = ' + formatNum(data.E_total) + ' J' });
        return steps;
    }

    function buildStepsVelocity(data) {
        var steps = [];
        steps.push({ title: 'Velocity addition', formula: 'w = (u + v) / (1 + u v / c²)', calc: 'w/c = (' + formatNum(data.u) + ' + ' + formatNum(data.v) + ') / (1 + ' + formatNum(data.u * data.v) + ') = ' + formatNum(data.wFrac) + ' c' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('rel-steps-body');
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
        var placeholder = document.getElementById('rel-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'gamma' && data) html = 'γ = <span class="highlight">' + formatNum(data.gamma) + '</span> (v/c = ' + formatNum(data.vFrac) + ')';
        else if (tab === 'length' && data) html = 'L = L₀/γ = <span class="highlight">' + formatNum(data.L) + ' m</span>';
        else if (tab === 'time' && data) html = 'Δt = γ Δt₀ = <span class="highlight">' + formatNum(data.dt) + ' s</span>';
        else if (tab === 'momentum' && data) html = 'p = <span class="highlight">' + formatNum(data.p) + ' kg·m/s</span>';
        else if (tab === 'energy' && data) html = 'KE = ' + formatNum(data.KE) + ' J, E = ' + formatNum(data.E_total) + ' J';
        else if (tab === 'velocity' && data) html = 'w = <span class="highlight">' + formatNum(data.wFrac) + ' c</span>';
        else html = 'Run a calculation to see result.';
        placeholder.innerHTML = html;
    }

    function runRelativity() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'gamma') {
            data = getValuesGamma();
            resultEl = document.getElementById('gamma-result');
            resultText = data.gamma === Infinity ? '∞' : formatNum(data.gamma);
            steps = buildStepsGamma(data);
        } else if (tab === 'length') {
            data = getValuesLength();
            resultEl = document.getElementById('length-result');
            resultText = formatNum(data.L) + ' m';
            steps = buildStepsLength(data);
        } else if (tab === 'time') {
            data = getValuesTime();
            resultEl = document.getElementById('time-result');
            resultText = formatNum(data.dt) + ' s';
            steps = buildStepsTime(data);
        } else if (tab === 'momentum') {
            data = getValuesMomentum();
            resultEl = document.getElementById('mom-result');
            resultText = data.p === Infinity ? '—' : formatNum(data.p) + ' kg·m/s';
            steps = buildStepsMomentum(data);
        } else if (tab === 'energy') {
            data = getValuesEnergy();
            resultEl = document.getElementById('energy-result');
            resultText = 'KE = ' + formatNum(data.KE) + ' J, E = ' + formatNum(data.E_total) + ' J';
            steps = buildStepsEnergy(data);
        } else if (tab === 'velocity') {
            data = getValuesVelocity();
            resultEl = document.getElementById('vel-result');
            resultText = formatNum(data.wFrac) + ' c';
            steps = buildStepsVelocity(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchRelativityTab(tabId, btn) {
        var tabs = document.querySelectorAll('.rel-tab');
        var panels = document.querySelectorAll('.rel-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.rel-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');
        runRelativity();
    }

    function toggleRelativitySteps() {
        var body = document.getElementById('rel-steps-body');
        var toggle = document.getElementById('rel-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        runRelativity();
    });

    window.runRelativity = runRelativity;
    window.switchRelativityTab = switchRelativityTab;
    window.toggleRelativitySteps = toggleRelativitySteps;
})();
