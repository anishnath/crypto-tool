/**
 * Nuclear Physics - radius, mass defect, binding energy, decay, Q-value
 */
(function () {
    'use strict';

    var MeV_per_u = 931.5;       // BE = Δm × 931.5 MeV/u
    var m_p_u = 1.007276;        // proton mass (u)
    var m_n_u = 1.008665;        // neutron mass (u)
    var ln2 = 0.693147;          // ln(2)

    var timeToSeconds = { 's': 1, 'min': 60, 'h': 3600, 'd': 86400, 'y': 365.25 * 86400 };

    function getActiveTab() {
        var t = document.querySelector('.nuc-tab.active');
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
        var A = parseInt(document.getElementById('radius-a').value) || 1;
        if (A < 1) A = 1;
        var R0 = parseFloat(document.getElementById('radius-r0').value) || 1.2;
        var R_fm = R0 * Math.pow(A, 1 / 3);
        return { A: A, R0: R0, R_fm: R_fm };
    }

    function getValuesMassDefect() {
        var Z = parseInt(document.getElementById('md-z').value) || 0;
        var A = parseInt(document.getElementById('md-a').value) || 1;
        var M = parseFloat(document.getElementById('md-m').value) || 0;
        if (A < Z) A = Z;
        var sum_nucleons = Z * m_p_u + (A - Z) * m_n_u;
        var dm_u = sum_nucleons - M;
        return { Z: Z, A: A, M: M, sum_nucleons: sum_nucleons, dm_u: dm_u };
    }

    function getValuesBinding() {
        var dm = parseFloat(document.getElementById('be-dm').value) || 0;
        var A = parseInt(document.getElementById('be-a').value) || 1;
        if (A < 1) A = 1;
        var BE_MeV = dm * MeV_per_u;
        var BE_per_A = A > 0 ? BE_MeV / A : 0;
        return { dm: dm, A: A, BE_MeV: BE_MeV, BE_per_A: BE_per_A };
    }

    function getValuesDecay() {
        var T_half_raw = parseFloat(document.getElementById('decay-t').value) || 0;
        var T_unit = document.getElementById('decay-t-unit').value;
        var N0 = parseFloat(document.getElementById('decay-n0').value) || 0;
        var t_raw = parseFloat(document.getElementById('decay-elapsed').value) || 0;
        var t_unit = document.getElementById('decay-elapsed-unit').value;
        var T_s = T_half_raw * (timeToSeconds[T_unit] || 1);
        var t_s = t_raw * (timeToSeconds[t_unit] || 1);
        if (T_s <= 0) return { lambda: 0, T_s: 0, t_s: t_s, N0: N0, N: N0, A: 0 };
        var lambda = ln2 / T_s;
        var N = N0 * Math.exp(-lambda * t_s);
        var A_Bq = lambda * N;
        var A0_Bq = lambda * N0;
        return { T_s: T_s, T_unit: T_unit, T_half_raw: T_half_raw, lambda: lambda, t_s: t_s, t_raw: t_raw, t_unit: t_unit, N0: N0, N: N, A_Bq: A_Bq, A0_Bq: A0_Bq };
    }

    function getValuesQvalue() {
        var m_react = parseFloat(document.getElementById('qv-mreact').value) || 0;
        var m_prod = parseFloat(document.getElementById('qv-mprod').value) || 0;
        var dm_u = m_react - m_prod;
        var Q_MeV = dm_u * MeV_per_u;
        return { m_react: m_react, m_prod: m_prod, dm_u: dm_u, Q_MeV: Q_MeV };
    }

    function buildStepsRadius(data) {
        var steps = [];
        steps.push({ title: 'Nuclear radius', formula: 'R = R₀ A^(1/3)', calc: 'R = ' + data.R0 + ' × ' + data.A + '^(1/3) = ' + formatNum(data.R_fm) + ' fm' });
        return steps;
    }

    function buildStepsMassDefect(data) {
        var steps = [];
        steps.push({ title: 'Sum of nucleons', formula: 'Z m_p + (A−Z) m_n', calc: data.Z + '×1.007276 + ' + (data.A - data.Z) + '×1.008665 = ' + formatNum(data.sum_nucleons) + ' u' });
        steps.push({ title: 'Mass defect', formula: 'Δm = sum − M_nucleus', calc: 'Δm = ' + formatNum(data.sum_nucleons) + ' − ' + formatNum(data.M) + ' = ' + formatNum(data.dm_u) + ' u' });
        return steps;
    }

    function buildStepsBinding(data) {
        var steps = [];
        steps.push({ title: 'Binding energy', formula: 'BE = Δm × 931.5 MeV/u', calc: 'BE = ' + formatNum(data.dm) + ' × 931.5 = ' + formatNum(data.BE_MeV) + ' MeV' });
        steps.push({ title: 'BE per nucleon', formula: 'BE/A', calc: 'BE/A = ' + formatNum(data.BE_MeV) + ' / ' + data.A + ' = ' + formatNum(data.BE_per_A) + ' MeV/nucleon' });
        return steps;
    }

    function buildStepsDecay(data) {
        var steps = [];
        steps.push({ title: 'Decay constant', formula: 'λ = 0.693 / T₁/₂', calc: 'λ = 0.693 / ' + formatNum(data.T_s) + ' s = ' + formatNum(data.lambda) + ' s⁻¹' });
        steps.push({ title: 'Nuclei remaining', formula: 'N = N₀ e^(−λt)', calc: 'N = ' + formatNum(data.N0) + ' × e^(−' + formatNum(data.lambda) + ' × ' + formatNum(data.t_s) + ') = ' + formatNum(data.N) + '' });
        steps.push({ title: 'Activity', formula: 'A = λ N', calc: 'A = ' + formatNum(data.lambda) + ' × ' + formatNum(data.N) + ' = ' + formatNum(data.A_Bq) + ' Bq' });
        return steps;
    }

    function buildStepsQvalue(data) {
        var steps = [];
        steps.push({ title: 'Mass difference', formula: 'Δm = m_reactants − m_products', calc: 'Δm = ' + formatNum(data.m_react) + ' − ' + formatNum(data.m_prod) + ' = ' + formatNum(data.dm_u) + ' u' });
        steps.push({ title: 'Q-value', formula: 'Q = Δm × 931.5 MeV/u', calc: 'Q = ' + formatNum(data.dm_u) + ' × 931.5 = ' + formatNum(data.Q_MeV) + ' MeV' + (data.Q_MeV > 0 ? ' (exoergic)' : (data.Q_MeV < 0 ? ' (endoergic)' : '')) });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('nuc-steps-body');
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
        var placeholder = document.getElementById('nuc-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'radius' && data) html = 'R = <span class="highlight">' + formatNum(data.R_fm) + ' fm</span> (A=' + data.A + ', R₀=' + data.R0 + ' fm)';
        else if (tab === 'massdefect' && data) html = 'Δm = <span class="highlight">' + formatNum(data.dm_u) + ' u</span>';
        else if (tab === 'binding' && data) html = 'BE = ' + formatNum(data.BE_MeV) + ' MeV, BE/A = <span class="highlight">' + formatNum(data.BE_per_A) + ' MeV/nucleon</span>';
        else if (tab === 'decay' && data) html = 'λ = ' + formatNum(data.lambda) + ' s⁻¹, N = ' + formatNum(data.N) + ', A = ' + formatNum(data.A_Bq) + ' Bq';
        else if (tab === 'qvalue' && data) html = 'Q = <span class="highlight">' + formatNum(data.Q_MeV) + ' MeV</span>' + (data.Q_MeV > 0 ? ' (exoergic)' : '');
        else html = 'Run a calculation to see result.';
        placeholder.innerHTML = html;
    }

    function runNuclearPhysics() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'radius') {
            data = getValuesRadius();
            resultEl = document.getElementById('radius-result');
            resultText = formatNum(data.R_fm) + ' fm';
            steps = buildStepsRadius(data);
        } else if (tab === 'massdefect') {
            data = getValuesMassDefect();
            resultEl = document.getElementById('md-result');
            resultText = formatNum(data.dm_u) + ' u';
            steps = buildStepsMassDefect(data);
        } else if (tab === 'binding') {
            data = getValuesBinding();
            resultEl = document.getElementById('be-result');
            resultText = formatNum(data.BE_MeV) + ' MeV, ' + formatNum(data.BE_per_A) + ' MeV/nucleon';
            steps = buildStepsBinding(data);
        } else if (tab === 'decay') {
            data = getValuesDecay();
            resultEl = document.getElementById('decay-result');
            resultText = 'λ = ' + formatNum(data.lambda) + ' s⁻¹, N = ' + formatNum(data.N) + ', A = ' + formatNum(data.A_Bq) + ' Bq';
            steps = buildStepsDecay(data);
        } else if (tab === 'qvalue') {
            data = getValuesQvalue();
            resultEl = document.getElementById('qv-result');
            resultText = formatNum(data.Q_MeV) + ' MeV' + (data.Q_MeV > 0 ? ' (exoergic)' : (data.Q_MeV < 0 ? ' (endoergic)' : ''));
            steps = buildStepsQvalue(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchNuclearTab(tabId, btn) {
        var tabs = document.querySelectorAll('.nuc-tab');
        var panels = document.querySelectorAll('.nuc-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.nuc-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');
        runNuclearPhysics();
    }

    function toggleNuclearSteps() {
        var body = document.getElementById('nuc-steps-body');
        var toggle = document.getElementById('nuc-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        runNuclearPhysics();
    });

    window.runNuclearPhysics = runNuclearPhysics;
    window.switchNuclearTab = switchNuclearTab;
    window.toggleNuclearSteps = toggleNuclearSteps;
})();
