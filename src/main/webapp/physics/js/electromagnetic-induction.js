(function () {
    'use strict';

    var emiChart = null;

    function initTabs() {
        var tabs = document.querySelectorAll('.emi-tab');
        var panels = document.querySelectorAll('.emi-panel');
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

    function degToRad(deg) {
        return (deg * Math.PI) / 180;
    }

    // ---- Calculators ----

    function calcFaraday() {
        var B = parseFloat(document.getElementById('emi-B').value) || 0;
        var A = parseFloat(document.getElementById('emi-A').value) || 0;
        var thetaDeg = parseFloat(document.getElementById('emi-theta').value) || 0;
        var N = parseFloat(document.getElementById('emi-N').value) || 0;
        var dPhi = parseFloat(document.getElementById('emi-dPhi').value) || 0;
        var dt = parseFloat(document.getElementById('emi-dt').value) || 0;

        var theta = degToRad(thetaDeg);
        var phi = B * A * Math.cos(theta);
        var phiTotal = N * phi;
        var eps = (dt > 0) ? -(N * dPhi) / dt : 0;

        var el = document.getElementById('emi-faraday-result');
        if (el) {
            el.textContent =
                'Φ_B = ' + formatSci(phi) + ' Wb, Φ_total = ' + formatSci(phiTotal) + ' Wb, ε = ' + formatSci(eps) + ' V';
        }
        return { B: B, A: A, thetaDeg: thetaDeg, N: N, phi: phi, phiTotal: phiTotal, dPhi: dPhi, dt: dt, eps: eps };
    }

    function calcMotional() {
        var B = parseFloat(document.getElementById('mot-B').value) || 0;
        var l = parseFloat(document.getElementById('mot-l').value) || 0;
        var v = parseFloat(document.getElementById('mot-v').value) || 0;
        var R = parseFloat(document.getElementById('mot-R').value) || 0;

        var epsRod = B * l * v;
        var I = (R > 0) ? epsRod / R : 0;

        var Brot = parseFloat(document.getElementById('mot-Brot').value) || 0;
        var L = parseFloat(document.getElementById('mot-L').value) || 0;
        var omega = parseFloat(document.getElementById('mot-omega').value) || 0;

        var epsRot = 0.5 * Brot * omega * L * L;

        var el = document.getElementById('emi-motional-result');
        if (el) {
            el.textContent =
                'ε_rod = ' + formatSci(epsRod) + ' V, I = ' + formatSci(I) + ' A, ε_rot = ' + formatSci(epsRot) + ' V';
        }
        return { B: B, l: l, v: v, R: R, epsRod: epsRod, I: I, Brot: Brot, L: L, omega: omega, epsRot: epsRot };
    }

    function calcSelf() {
        var L = parseFloat(document.getElementById('self-L').value) || 0;
        var I = parseFloat(document.getElementById('self-I').value) || 0;
        var dI = parseFloat(document.getElementById('self-dI').value) || 0;

        var eps = -L * dI;
        var U = 0.5 * L * I * I;

        var mu0 = parseFloat(document.getElementById('self-mu0').value) || 0;
        var n = parseFloat(document.getElementById('self-n').value) || 0;
        var A = parseFloat(document.getElementById('self-A').value) || 0;
        var l = parseFloat(document.getElementById('self-l').value) || 0;
        var Lsol = mu0 * n * n * A * l;

        var el = document.getElementById('emi-self-result');
        if (el) {
            el.textContent =
                'ε = ' + formatSci(eps) + ' V, U = ' + formatSci(U) + ' J, L_solenoid = ' + formatSci(Lsol) + ' H';
        }
        return { L: L, I: I, dI: dI, eps: eps, U: U, mu0: mu0, n: n, A: A, l: l, Lsol: Lsol };
    }

    function calcMutual() {
        var L1 = parseFloat(document.getElementById('mut-L1').value) || 0;
        var L2 = parseFloat(document.getElementById('mut-L2').value) || 0;
        var k = parseFloat(document.getElementById('mut-k').value) || 0;
        var dI1 = parseFloat(document.getElementById('mut-dI').value) || 0;
        var M = (L1 > 0 && L2 > 0) ? k * Math.sqrt(L1 * L2) : 0;
        var eps2 = -M * dI1;

        var el = document.getElementById('emi-mutual-result');
        if (el) {
            el.textContent = 'M = ' + formatSci(M) + ' H, ε₂ = ' + formatSci(eps2) + ' V';
        }
        return { L1: L1, L2: L2, k: k, dI1: dI1, M: M, eps2: eps2 };
    }

    function calcAC() {
        var f = parseFloat(document.getElementById('ac-f').value) || 0;
        var R = parseFloat(document.getElementById('ac-R').value) || 0;
        var L = parseFloat(document.getElementById('ac-L').value) || 0;
        var C = parseFloat(document.getElementById('ac-C').value) || 0;
        var w = 2 * Math.PI * f;
        var XL = w * L;
        var XC = (w > 0 && C > 0) ? 1 / (w * C) : 0;
        var Z = Math.sqrt(R * R + Math.pow(XL - XC, 2));

        var el = document.getElementById('emi-ac-result');
        if (el) {
            el.textContent =
                'X_L = ' + formatSci(XL) + ' Ω, X_C = ' + formatSci(XC) + ' Ω, |Z_RLC| = ' + formatSci(Z) + ' Ω';
        }
        return { f: f, R: R, L: L, C: C, w: w, XL: XL, XC: XC, Z: Z };
    }

    function calcTransients() {
        var eps = parseFloat(document.getElementById('lr-eps').value) || 0;
        var L = parseFloat(document.getElementById('lr-L').value) || 0;
        var R = parseFloat(document.getElementById('lr-R').value) || 0;
        var t = parseFloat(document.getElementById('lr-t').value) || 0;
        var tauL = (R > 0) ? L / R : 0;
        var Imax = (R > 0) ? eps / R : 0;
        var ILR = (tauL > 0) ? Imax * (1 - Math.exp(-t / tauL)) : 0;

        var Lc = parseFloat(document.getElementById('lc-L').value) || 0;
        var Cc = parseFloat(document.getElementById('lc-C').value) || 0;
        var wLC = (Lc > 0 && Cc > 0) ? 1 / Math.sqrt(Lc * Cc) : 0;
        var TLC = (wLC > 0) ? (2 * Math.PI / wLC) : 0;

        var el = document.getElementById('emi-transient-result');
        if (el) {
            el.textContent =
                'LR: I(t) = ' + formatSci(ILR) + ' A, τ_L = ' + formatSci(tauL) + ' s; ' +
                'LC: ω = ' + formatSci(wLC) + ' rad/s, T = ' + formatSci(TLC) + ' s';
        }
        return { eps: eps, L: L, R: R, t: t, tauL: tauL, Imax: Imax, ILR: ILR, Lc: Lc, Cc: Cc, wLC: wLC, TLC: TLC };
    }

    // ---- Steps builders ----

    function buildStepsFaraday(v) {
        var steps = [];
        steps.push({
            title: 'Magnetic flux through one turn',
            formula: 'Φ_B = B A cos θ',
            calc: 'Φ_B = ' + v.B + ' × ' + v.A + ' × cos(' + v.thetaDeg + '°) ≈ ' + formatSci(v.phi) + ' Wb'
        });
        steps.push({
            title: 'Total flux for N turns',
            formula: 'Φ_total = N Φ_B',
            calc: 'Φ_total = ' + v.N + ' × ' + formatSci(v.phi) + ' ≈ ' + formatSci(v.phiTotal) + ' Wb'
        });
        steps.push({
            title: 'Induced emf (Faraday + Lenz)',
            formula: 'ε = −N ΔΦ/Δt',
            calc: 'ε = −' + v.N + ' × ' + v.dPhi + ' / ' + v.dt + ' ≈ ' + formatSci(v.eps) + ' V'
        });
        return steps;
    }

    function buildStepsMotional(v) {
        var steps = [];
        steps.push({
            title: 'Sliding rod emf',
            formula: 'ε = B ℓ v',
            calc: 'ε_rod = ' + v.B + ' × ' + v.l + ' × ' + v.v + ' = ' + formatSci(v.epsRod) + ' V'
        });
        steps.push({
            title: 'Current in closed circuit',
            formula: 'I = ε / R',
            calc: 'I = ' + formatSci(v.epsRod) + ' / ' + v.R + ' ≈ ' + formatSci(v.I) + ' A'
        });
        steps.push({
            title: 'Rotating rod/disk emf',
            formula: 'ε = ½ B ω L² (rod) or ½ B ω R² (disk)',
            calc: 'ε_rot ≈ ' + formatSci(v.epsRot) + ' V for B = ' + v.Brot + ', ω = ' + v.omega + ', L/R = ' + v.L
        });
        return steps;
    }

    function buildStepsSelf(v) {
        var steps = [];
        steps.push({
            title: 'Self-inductance emf',
            formula: 'ε = −L dI/dt',
            calc: 'ε = −' + v.L + ' × ' + v.dI + ' = ' + formatSci(v.eps) + ' V'
        });
        steps.push({
            title: 'Energy stored in inductor',
            formula: 'U = ½ L I²',
            calc: 'U = ½ × ' + v.L + ' × ' + v.I + '² = ' + formatSci(v.U) + ' J'
        });
        steps.push({
            title: 'Solenoid inductance',
            formula: 'L = μ₀ n² A l',
            calc: 'L_solenoid = ' + formatSci(v.Lsol) + ' H using μ₀, n, A, l'
        });
        return steps;
    }

    function buildStepsMutual(v) {
        var steps = [];
        steps.push({
            title: 'Mutual inductance',
            formula: 'M = k√(L₁L₂)',
            calc: 'M = ' + v.k + ' × √(' + v.L1 + ' × ' + v.L2 + ') ≈ ' + formatSci(v.M) + ' H'
        });
        steps.push({
            title: 'Induced emf in secondary',
            formula: 'ε₂ = −M dI₁/dt',
            calc: 'ε₂ = −' + formatSci(v.M) + ' × ' + v.dI1 + ' ≈ ' + formatSci(v.eps2) + ' V'
        });
        return steps;
    }

    function buildStepsAC(v) {
        var steps = [];
        steps.push({
            title: 'Angular frequency',
            formula: 'ω = 2π f',
            calc: 'ω = 2π × ' + v.f + ' ≈ ' + formatSci(v.w) + ' rad/s'
        });
        steps.push({
            title: 'Inductive and capacitive reactance',
            formula: 'X_L = ωL,  X_C = 1/(ωC)',
            calc: 'X_L = ' + formatSci(v.XL) + ' Ω, X_C = ' + formatSci(v.XC) + ' Ω'
        });
        steps.push({
            title: 'Series RLC impedance',
            formula: '|Z| = √(R² + (X_L − X_C)²)',
            calc: '|Z_RLC| = ' + formatSci(v.Z) + ' Ω'
        });
        return steps;
    }

    function buildStepsTransients(v) {
        var steps = [];
        steps.push({
            title: 'LR time constant and current',
            formula: 'τ_L = L/R,  I(t) = (ε/R)(1 − e^{−t/τ_L})',
            calc: 'τ_L = ' + formatSci(v.tauL) + ' s, I(t) ≈ ' + formatSci(v.ILR) + ' A'
        });
        steps.push({
            title: 'LC oscillation frequency',
            formula: 'ω = 1/√(LC),  T = 2π√(LC)',
            calc: 'ω = ' + formatSci(v.wLC) + ' rad/s, T = ' + formatSci(v.TLC) + ' s'
        });
        return steps;
    }

    function renderEMISteps(steps) {
        var container = document.getElementById('emi-steps-body');
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

    // ---- Charts ----

    function updateFaradayChart(v) {
        var canvas = document.getElementById('emi-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        var labels = [];
        var phiVals = [];
        for (var deg = 0; deg <= 180; deg += 5) {
            var phi = v.B * v.A * Math.cos(degToRad(deg));
            labels.push(deg.toString());
            phiVals.push(phi);
        }
        if (emiChart) emiChart.destroy();
        emiChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Φ_B(θ) = BA cos θ',
                    data: phiVals,
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79,70,229,0.08)',
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
                    title: { display: true, text: 'Flux vs angle for B, A' }
                },
                scales: {
                    x: { title: { display: true, text: 'θ (degrees)' }, ticks: { maxTicksLimit: 10 } },
                    y: { title: { display: true, text: 'Φ_B (Wb)' } }
                }
            }
        });
    }

    function updateMotionalChart(v) {
        var canvas = document.getElementById('emi-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        var labels = [];
        var epsVals = [];
        var vMax = Math.max(v.v || 1, 10);
        var steps = 50;
        for (var i = 0; i <= steps; i++) {
            var vel = vMax * (i / steps);
            var eps = v.B * v.l * vel;
            labels.push(vel.toFixed(1));
            epsVals.push(eps);
        }
        if (emiChart) emiChart.destroy();
        emiChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'ε(v) = Bℓv',
                    data: epsVals,
                    borderColor: '#ec4899',
                    backgroundColor: 'rgba(236,72,153,0.08)',
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
                    title: { display: true, text: 'Motional emf vs speed (rod)' }
                },
                scales: {
                    x: { title: { display: true, text: 'v (m/s)' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'ε (V)' } }
                }
            }
        });
    }

    function updateACChart(v) {
        var canvas = document.getElementById('emi-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        var labels = [];
        var XLs = [];
        var XCs = [];
        var fMin = 1;
        var fMax = Math.max(v.f || 50, 500);
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var f = fMin + (fMax - fMin) * (i / steps);
            var w = 2 * Math.PI * f;
            var XL = w * v.L;
            var XC = (w > 0 && v.C > 0) ? 1 / (w * v.C) : 0;
            labels.push(f.toFixed(0));
            XLs.push(XL);
            XCs.push(XC);
        }
        if (emiChart) emiChart.destroy();
        emiChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'X_L(f)',
                        data: XLs,
                        borderColor: '#4f46e5',
                        backgroundColor: 'rgba(79,70,229,0.08)',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: false
                    },
                    {
                        label: 'X_C(f)',
                        data: XCs,
                        borderColor: '#22c55e',
                        backgroundColor: 'rgba(34,197,94,0.08)',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Inductive and capacitive reactance vs frequency' }
                },
                scales: {
                    x: { title: { display: true, text: 'f (Hz)' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'Reactance (Ω)' } }
                }
            }
        });
    }

    function updateTransientsChart(v) {
        var canvas = document.getElementById('emi-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.tauL <= 0) {
            if (emiChart) { emiChart.destroy(); emiChart = null; }
            return;
        }
        var labels = [];
        var Ivals = [];
        var tMax = 5 * v.tauL;
        var steps = 80;
        for (var i = 0; i <= steps; i++) {
            var t = tMax * (i / steps);
            var I = v.Imax * (1 - Math.exp(-t / v.tauL));
            labels.push((t / v.tauL).toFixed(2) + ' τ_L');
            Ivals.push(I);
        }
        if (emiChart) emiChart.destroy();
        emiChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'LR current growth I(t)',
                    data: Ivals,
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
                    title: { display: true, text: 'LR circuit current vs time (normalized by τ_L)' }
                },
                scales: {
                    x: { title: { display: true, text: 't/τ_L' }, ticks: { maxTicksLimit: 8 } },
                    y: { title: { display: true, text: 'I(t) (A)' } }
                }
            }
        });
    }

    // ---- Orchestrator ----

    function runEMI() {
        var active = document.querySelector('.emi-tab.active');
        var tab = active ? active.getAttribute('data-tab') : 'faraday';
        var vals, steps;
        if (tab === 'faraday') {
            vals = calcFaraday();
            steps = buildStepsFaraday(vals);
            updateFaradayChart(vals);
        } else if (tab === 'motional') {
            vals = calcMotional();
            steps = buildStepsMotional(vals);
            updateMotionalChart(vals);
        } else if (tab === 'self') {
            vals = calcSelf();
            steps = buildStepsSelf(vals);
            if (emiChart) { emiChart.destroy(); emiChart = null; }
        } else if (tab === 'mutual') {
            vals = calcMutual();
            steps = buildStepsMutual(vals);
            if (emiChart) { emiChart.destroy(); emiChart = null; }
        } else if (tab === 'ac') {
            vals = calcAC();
            steps = buildStepsAC(vals);
            updateACChart(vals);
        } else if (tab === 'transients') {
            vals = calcTransients();
            steps = buildStepsTransients(vals);
            updateTransientsChart(vals);
        }
        if (steps) renderEMISteps(steps);
    }

    function toggleEMISteps() {
        var body = document.getElementById('emi-steps-body');
        var toggle = document.getElementById('emi-steps-toggle');
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

    window.runEMI = runEMI;
    window.toggleEMISteps = toggleEMISteps;

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        var initial = calcFaraday();
        renderEMISteps(buildStepsFaraday(initial));
        updateFaradayChart(initial);
    });
})();

