(function () {
    'use strict';

    var E_CHARGE = 1.602e-19;
    var ceChart = null;

    function initTabs() {
        var tabs = document.querySelectorAll('.ce-tab');
        var panels = document.querySelectorAll('.ce-panel');
        if (!tabs.length) return;
        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                var id = tab.getAttribute('data-tab');
                tabs.forEach(function (t) { t.classList.remove('active'); });
                panels.forEach(function (p) {
                    p.classList.remove('active');
                    if (p.id === 'panel-' + id) p.classList.add('active');
                });
                tab.classList.add('active');
            });
        });
    }

    function formatSci(x, digits) {
        digits = digits || 3;
        if (x === 0) return '0';
        var abs = Math.abs(x);
        if (abs >= 1e4 || abs <= 1e-3) return x.toExponential(digits);
        return x.toFixed(digits);
    }

    function calcBasics() {
        var Q = parseFloat(document.getElementById('ce-Q').value) || 0;
        var t = parseFloat(document.getElementById('ce-t').value) || 0;
        var A = parseFloat(document.getElementById('ce-A').value) || 0;
        var n = parseFloat(document.getElementById('ce-n').value) || 0;
        var R = parseFloat(document.getElementById('ce-R').value) || 0;
        var L = parseFloat(document.getElementById('ce-L').value) || 0;
        var Aw = parseFloat(document.getElementById('ce-A-wire').value) || 0;

        var I = t > 0 ? Q / t : 0;
        var J = (A > 0) ? I / A : 0;
        var vd = (n > 0 && A > 0) ? I / (n * E_CHARGE * A) : 0;
        var rho = (Aw > 0 && L > 0) ? (R * Aw / L) : 0;
        var sigma = rho !== 0 ? 1 / rho : 0;

        var el = document.getElementById('ce-basics-result');
        if (el) {
            el.textContent =
                'I = ' + formatSci(I) + ' A, ' +
                'J = ' + formatSci(J) + ' A/m², ' +
                'v_d = ' + formatSci(vd) + ' m/s, ' +
                'ρ = ' + formatSci(rho) + ' Ω·m, ' +
                'σ = ' + formatSci(sigma) + ' S/m';
        }
        return { Q: Q, t: t, A: A, n: n, I: I, J: J, vd: vd, R: R, L: L, Aw: Aw, rho: rho, sigma: sigma };
    }

    function calcOhm() {
        var V = parseFloat(document.getElementById('ohm-V').value);
        var I = parseFloat(document.getElementById('ohm-I').value);
        var R = parseFloat(document.getElementById('ohm-R').value);

        var rho = parseFloat(document.getElementById('ohm-rho').value) || 0;
        var L = parseFloat(document.getElementById('ohm-L').value) || 0;
        var Aw = parseFloat(document.getElementById('ohm-Awire').value) || 0;

        var R0 = parseFloat(document.getElementById('ohm-R0').value) || 0;
        var alpha = parseFloat(document.getElementById('ohm-alpha').value) || 0;
        var dT = parseFloat(document.getElementById('ohm-dT').value) || 0;

        // Solve Ohm's law: if one is NaN, compute it from the other two
        if (!isFinite(V) && isFinite(I) && isFinite(R)) V = I * R;
        else if (!isFinite(I) && isFinite(V) && isFinite(R) && R !== 0) I = V / R;
        else if (!isFinite(R) && isFinite(V) && isFinite(I) && I !== 0) R = V / I;

        var Rwire = (rho > 0 && L > 0 && Aw > 0) ? (rho * L / Aw) : 0;
        var Rtemp = R0 * (1 + alpha * dT);

        var el = document.getElementById('ce-ohm-result');
        if (el) {
            el.textContent =
                'V = ' + formatSci(V || 0) + ' V, ' +
                'I = ' + formatSci(I || 0) + ' A, ' +
                'R = ' + formatSci(R || 0) + ' Ω, ' +
                'R_wire = ' + formatSci(Rwire) + ' Ω, ' +
                'R(T) = ' + formatSci(Rtemp) + ' Ω';
        }
        return { V: V, I: I, R: R, rho: rho, L: L, Aw: Aw, Rwire: Rwire, R0: R0, alpha: alpha, dT: dT, Rtemp: Rtemp };
    }

    function calcCells() {
        var eps = parseFloat(document.getElementById('cell-eps').value) || 0;
        var r = parseFloat(document.getElementById('cell-r').value) || 0;
        var R = parseFloat(document.getElementById('cell-R').value) || 0;

        var I = (R + r) > 0 ? eps / (R + r) : 0;
        var Vterm = eps - I * r;
        var Pload = I * I * R;

        var n = parseFloat(document.getElementById('cell-n').value) || 0;
        var eps2 = parseFloat(document.getElementById('cell-eps2').value) || 0;
        var r2 = parseFloat(document.getElementById('cell-r2').value) || 0;
        var Rload2 = parseFloat(document.getElementById('cell-Rload2').value) || 0;
        var mode = document.getElementById('cell-mode').value;

        var epsEq = 0;
        var rEq = 0;
        if (mode === 'series') {
            epsEq = n * eps2;
            rEq = n * r2;
        } else {
            epsEq = eps2;
            rEq = (n > 0) ? (r2 / n) : 0;
        }
        var Ibatt = (Rload2 + rEq) > 0 ? epsEq / (Rload2 + rEq) : 0;

        var el = document.getElementById('ce-cells-result');
        if (el) {
            el.textContent =
                'Single: I = ' + formatSci(I) + ' A, V_term = ' + formatSci(Vterm) + ' V, P_load = ' + formatSci(Pload) + ' W; ' +
                'Battery: ε_eq = ' + formatSci(epsEq) + ' V, r_eq = ' + formatSci(rEq) + ' Ω, I_batt = ' + formatSci(Ibatt) + ' A';
        }
        return { eps: eps, r: r, R: R, I: I, Vterm: Vterm, Pload: Pload, n: n, epsEq: epsEq, rEq: rEq, Ibatt: Ibatt, mode: mode };
    }

    function calcBridge() {
        var P = parseFloat(document.getElementById('bridge-P').value) || 0;
        var Q = parseFloat(document.getElementById('bridge-Q').value) || 0;
        var R = parseFloat(document.getElementById('bridge-R').value) || 0;
        var S = (P > 0) ? (Q * R / P) : 0;

        var Rk = parseFloat(document.getElementById('mb-R').value) || 0;
        var l1 = parseFloat(document.getElementById('mb-l1').value) || 0;
        var l2 = parseFloat(document.getElementById('mb-l2').value) || 0;
        var X = (l1 > 0) ? Rk * (l2 / l1) : 0;

        var L = parseFloat(document.getElementById('pot-L').value) || 0;
        var Vdrive = parseFloat(document.getElementById('pot-Vdrive').value) || 0;
        var k = (L > 0) ? (Vdrive / L) : 0;
        var pl1 = parseFloat(document.getElementById('pot-l1').value) || 0;
        var pl2 = parseFloat(document.getElementById('pot-l2').value) || 0;
        var Rext = parseFloat(document.getElementById('pot-Rext').value) || 0;
        var epsRatio = (pl2 > 0) ? (pl1 / pl2) : 0;
        var rInternal = (pl2 > 0) ? Rext * (pl1 - pl2) / pl2 : 0;

        var el = document.getElementById('ce-bridge-result');
        if (el) {
            el.textContent =
                'S = ' + formatSci(S) + ' Ω, X = ' + formatSci(X) + ' Ω, k = ' + formatSci(k) + ' V/cm, ' +
                'ε₁/ε₂ = ' + formatSci(epsRatio) + ', r = ' + formatSci(rInternal) + ' Ω';
        }
        return { P: P, Q: Q, R: R, S: S, Rk: Rk, l1: l1, l2: l2, X: X, L: L, Vdrive: Vdrive, k: k, pl1: pl1, pl2: pl2, Rext: Rext, epsRatio: epsRatio, rInternal: rInternal };
    }

    function calcHeating() {
        var I = parseFloat(document.getElementById('heat-I').value) || 0;
        var R = parseFloat(document.getElementById('heat-R').value) || 0;
        var t = parseFloat(document.getElementById('heat-t').value) || 0;
        var H = I * I * R * t;

        var Rrc = parseFloat(document.getElementById('rc-R').value) || 0;
        var Crc = parseFloat(document.getElementById('rc-C').value) || 0;
        var tau = Rrc * Crc;

        var times = [1, 2, 3, 5];
        var charging = [];
        var discharging = [];
        times.forEach(function (k) {
            var x = k * tau;
            var ch = 1 - Math.exp(-k);
            var dis = Math.exp(-k);
            charging.push({ t: x, frac: ch });
            discharging.push({ t: x, frac: dis });
        });

        var el = document.getElementById('ce-heating-result');
        if (el) {
            var text = 'H = ' + formatSci(H) + ' J, τ = ' + formatSci(tau) + ' s; ' +
                'Charging V_C/ε at t = τ,2τ,3τ,5τ ≈ ' +
                charging.map(function (c, idx) { return (times[idx] + 'τ:' + formatSci(c.frac, 3)); }).join(', ') +
                '; Discharging V/V₀ ≈ ' +
                discharging.map(function (c, idx) { return (times[idx] + 'τ:' + formatSci(c.frac, 3)); }).join(', ');
            el.textContent = text;
        }
        return { I: I, R: R, t: t, H: H, Rrc: Rrc, Crc: Crc, tau: tau, charging: charging, discharging: discharging };
    }

    function buildStepsBasics(v) {
        var steps = [];
        steps.push({
            title: 'Current from charge and time',
            formula: 'I = Q / t',
            calc: 'I = ' + v.Q + ' C / ' + v.t + ' s = ' + formatSci(v.I) + ' A'
        });
        steps.push({
            title: 'Current density and drift velocity',
            formula: 'J = I/A,  I = n e A v_d',
            calc: 'J = ' + formatSci(v.J) + ' A/m²,  v_d = ' + formatSci(v.vd) + ' m/s'
        });
        steps.push({
            title: 'Resistivity and conductivity',
            formula: 'R = ρL/A ⇒ ρ = R A/L,  σ = 1/ρ',
            calc: 'ρ = ' + formatSci(v.rho) + ' Ω·m,  σ = ' + formatSci(v.sigma) + ' S/m'
        });
        return steps;
    }

    function buildStepsOhm(v) {
        var steps = [];
        steps.push({
            title: 'Ohm’s law',
            formula: 'V = I R',
            calc: 'V = ' + formatSci(v.V || 0) + ' V, I = ' + formatSci(v.I || 0) + ' A, R = ' + formatSci(v.R || 0) + ' Ω'
        });
        steps.push({
            title: 'Wire resistance',
            formula: 'R = ρL/A',
            calc: 'R_wire = ' + formatSci(v.Rwire) + ' Ω from ρ, L, A'
        });
        steps.push({
            title: 'Temperature dependence',
            formula: 'R = R₀ (1 + αΔT)',
            calc: 'R(T) = ' + formatSci(v.Rtemp) + ' Ω'
        });
        return steps;
    }

    function buildStepsCells(v) {
        var steps = [];
        steps.push({
            title: 'Current in circuit with internal resistance',
            formula: 'I = ε / (R + r),  V_term = ε − I r',
            calc: 'I = ' + formatSci(v.I) + ' A, V_term = ' + formatSci(v.Vterm) + ' V'
        });
        steps.push({
            title: 'Power delivered to load',
            formula: 'P_load = I² R',
            calc: 'P_load = ' + formatSci(v.Pload) + ' W (max when R = r)'
        });
        steps.push({
            title: 'Equivalent EMF and resistance of battery',
            formula: 'Series: ε_eq = nε, r_eq = nr; Parallel: ε_eq = ε, r_eq = r/n',
            calc: 'ε_eq = ' + formatSci(v.epsEq) + ' V, r_eq = ' + formatSci(v.rEq) + ' Ω, I_batt = ' + formatSci(v.Ibatt) + ' A'
        });
        return steps;
    }

    function buildStepsBridge(v) {
        var steps = [];
        steps.push({
            title: 'Balanced Wheatstone bridge',
            formula: 'P/Q = R/S',
            calc: 'S = Q R / P = ' + formatSci(v.S) + ' Ω'
        });
        steps.push({
            title: 'Meter bridge',
            formula: 'R / X = l₁ / l₂',
            calc: 'X = ' + formatSci(v.X) + ' Ω'
        });
        steps.push({
            title: 'Potentiometer potential gradient',
            formula: 'k = V/L',
            calc: 'k = ' + formatSci(v.k) + ' V/cm'
        });
        steps.push({
            title: 'Comparison of two cells',
            formula: 'ε₁ / ε₂ = l₁ / l₂',
            calc: 'ε₁/ε₂ = ' + formatSci(v.epsRatio)
        });
        steps.push({
            title: 'Internal resistance of cell',
            formula: 'r = R (l₁ − l₂) / l₂',
            calc: 'r = ' + formatSci(v.rInternal) + ' Ω'
        });
        return steps;
    }

    function buildStepsHeating(v) {
        var steps = [];
        steps.push({
            title: 'Joule heating',
            formula: 'H = I² R t',
            calc: 'H = ' + formatSci(v.H) + ' J'
        });
        steps.push({
            title: 'RC time constant',
            formula: 'τ = R C',
            calc: 'τ = ' + formatSci(v.tau) + ' s'
        });
        steps.push({
            title: 'Charging at t = τ, 2τ, 3τ, 5τ',
            formula: 'V_C = ε(1 − e^{−t/τ})',
            calc: v.charging.map(function (c, idx) {
                return (['τ','2τ','3τ','5τ'][idx] + ': ' + formatSci(c.frac, 3));
            }).join(', ')
        });
        steps.push({
            title: 'Discharging at t = τ, 2τ, 3τ, 5τ',
            formula: 'V = V₀ e^{−t/τ}',
            calc: v.discharging.map(function (c, idx) {
                return (['τ','2τ','3τ','5τ'][idx] + ': ' + formatSci(c.frac, 3));
            }).join(', ')
        });
        return steps;
    }

    function updateBasicsChart(v) {
        var canvas = document.getElementById('ce-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.Q === 0) {
            if (ceChart) { ceChart.destroy(); ceChart = null; }
            return;
        }
        var labels = [];
        var Ivals = [];
        var tMin = 0.1;
        var tMax = Math.max(v.t || 1, 5);
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var t = tMin + (tMax - tMin) * (i / steps);
            var I = v.Q / t;
            labels.push(t.toFixed(2));
            Ivals.push(I);
        }
        if (ceChart) ceChart.destroy();
        ceChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'I(t) = Q/t',
                    data: Ivals,
                    borderColor: '#0ea5e9',
                    backgroundColor: 'rgba(14,165,233,0.08)',
                    borderWidth: 2,
                    pointRadius: 0,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Current vs time for fixed Q' }
                },
                scales: {
                    x: { title: { display: true, text: 't (s)' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'I (A)' } }
                }
            }
        });
    }

    function updateOhmChart(v) {
        var canvas = document.getElementById('ce-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || !v.R || v.R <= 0) {
            if (ceChart) { ceChart.destroy(); ceChart = null; }
            return;
        }
        var labels = [];
        var Ivals = [];
        var Vmax = v.V && v.V > 0 ? v.V * 1.5 : 20;
        var steps = 40;
        for (var i = 0; i <= steps; i++) {
            var V = Vmax * (i / steps);
            var I = V / v.R;
            labels.push(V.toFixed(1));
            Ivals.push(I);
        }
        if (ceChart) ceChart.destroy();
        ceChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'I(V) for R = ' + formatSci(v.R) + ' Ω',
                    data: Ivals,
                    borderColor: '#22c55e',
                    backgroundColor: 'rgba(34,197,94,0.08)',
                    borderWidth: 2,
                    pointRadius: 0,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Ohm’s law I–V curve' }
                },
                scales: {
                    x: { title: { display: true, text: 'V (volts)' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'I (A)' } }
                }
            }
        });
    }

    function updateCellsChart(v) {
        var canvas = document.getElementById('ce-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.eps <= 0 || v.r < 0) {
            if (ceChart) { ceChart.destroy(); ceChart = null; }
            return;
        }
        var labels = [];
        var Pvals = [];
        var Rmin = 0.1;
        var Rmax = Math.max(v.R || 10, 10 * (v.r || 1));
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var R = Rmin + (Rmax - Rmin) * (i / steps);
            var I = v.eps / (R + v.r);
            var P = I * I * R;
            labels.push(R.toFixed(1));
            Pvals.push(P);
        }
        if (ceChart) ceChart.destroy();
        ceChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'P_load(R)',
                    data: Pvals,
                    borderColor: '#f97316',
                    backgroundColor: 'rgba(249,115,22,0.08)',
                    borderWidth: 2,
                    pointRadius: 0,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Power delivered vs load resistance' }
                },
                scales: {
                    x: { title: { display: true, text: 'R (Ω)' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'P_load (W)' } }
                }
            }
        });
    }

    function updateHeatingChart(v) {
        var canvas = document.getElementById('ce-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.tau <= 0) {
            if (ceChart) { ceChart.destroy(); ceChart = null; }
            return;
        }
        var labels = [];
        var chargeCurve = [];
        var dischargeCurve = [];
        var steps = 80;
        var tMax = 5 * v.tau;
        for (var i = 0; i <= steps; i++) {
            var t = tMax * (i / steps);
            var ch = 1 - Math.exp(-t / v.tau);
            var dis = Math.exp(-t / v.tau);
            labels.push((t / v.tau).toFixed(2) + ' τ');
            chargeCurve.push(ch);
            dischargeCurve.push(dis);
        }
        if (ceChart) ceChart.destroy();
        ceChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Charging V_C/ε',
                        data: chargeCurve,
                        borderColor: '#0ea5e9',
                        backgroundColor: 'rgba(14,165,233,0.08)',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: true
                    },
                    {
                        label: 'Discharging V/V₀',
                        data: dischargeCurve,
                        borderColor: '#ef4444',
                        backgroundColor: 'rgba(239,68,68,0.08)',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: true
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'RC charging and discharging (normalized)' }
                },
                scales: {
                    x: { title: { display: true, text: 't/τ' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'Normalized voltage' }, min: 0, max: 1 }
                }
            }
        });
    }

    function renderCurrentSteps(steps) {
        var container = document.getElementById('ce-steps-body');
        if (!container) return;
        container.innerHTML = '';
        steps.forEach(function (s, i) {
            var div = document.createElement('div');
            div.className = 'step-item';
            div.innerHTML =
                '<div class="step-title"><span class="step-number">' + (i + 1) + '</span>' + s.title + '</div>' +
                (s.formula ? '<div class="step-formula">' + s.formula + '</div>' : '') +
                (s.calc ? '<div class="step-calc">' + s.calc + '</div>' : '');
            container.appendChild(div);
        });
    }

    function runCurrent() {
        var active = document.querySelector('.ce-tab.active');
        var tab = active ? active.getAttribute('data-tab') : 'basics';
        var vals, steps;
        if (tab === 'basics') {
            vals = calcBasics();
            steps = buildStepsBasics(vals);
            updateBasicsChart(vals);
        } else if (tab === 'ohm') {
            vals = calcOhm();
            steps = buildStepsOhm(vals);
            updateOhmChart(vals);
        } else if (tab === 'cells') {
            vals = calcCells();
            steps = buildStepsCells(vals);
            updateCellsChart(vals);
        } else if (tab === 'bridge') {
            vals = calcBridge();
            steps = buildStepsBridge(vals);
            if (ceChart) { ceChart.destroy(); ceChart = null; }
        } else if (tab === 'heating') {
            vals = calcHeating();
            steps = buildStepsHeating(vals);
            updateHeatingChart(vals);
        }
        if (steps) renderCurrentSteps(steps);
    }

    function toggleCurrentSteps() {
        var body = document.getElementById('ce-steps-body');
        var toggle = document.getElementById('ce-steps-toggle');
        if (!body || !toggle) return;
        var collapsed = body.classList.contains('collapsed');
        if (collapsed) {
            body.classList.remove('collapsed');
            toggle.textContent = '▲ Hide';
        } else {
            body.classList.add('collapsed');
            toggle.textContent = '▼ Show';
        }
    }

    window.runCurrent = runCurrent;
    window.toggleCurrentSteps = toggleCurrentSteps;

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        var initial = calcBasics();
        renderCurrentSteps(buildStepsBasics(initial));
        updateBasicsChart(initial);
    });
})();

