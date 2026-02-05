(function () {
    'use strict';

    var acChart = null;

    function initTabs() {
        var tabs = document.querySelectorAll('.ac-tab');
        var panels = document.querySelectorAll('.ac-panel');
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
                // Re-run with new context to refresh results/chart
                runAC();
            });
        });
    }

    function formatSci(x, digits) {
        digits = digits || 3;
        if (!isFinite(x)) return '—';
        if (x === 0) return '0';
        var abs = Math.abs(x);
        if (abs >= 1e4 || abs <= 1e-3) return x.toExponential(digits);
        return x.toFixed(digits);
    }

    function degToRad(d) {
        return d * Math.PI / 180;
    }

    function calcBasics() {
        var V0 = parseFloat(document.getElementById('acb-V0').value);
        var f = parseFloat(document.getElementById('acb-f').value);
        var I0 = parseFloat(document.getElementById('acb-I0').value);
        var phiDeg = parseFloat(document.getElementById('acb-phi').value) || 0;
        var phi = degToRad(phiDeg);

        if (!isFinite(V0)) V0 = 0;
        if (!isFinite(I0)) I0 = 0;
        if (!isFinite(f) || f < 0) f = 0;

        var Vrms = V0 / Math.sqrt(2);
        var Irms = I0 / Math.sqrt(2);
        var VavgHalf = (2 * V0) / Math.PI;
        var omega = 2 * Math.PI * f;

        var el = document.getElementById('acb-result');
        if (el) {
            el.textContent =
                'V_rms = ' + formatSci(Vrms) + ' V, ' +
                'I_rms = ' + formatSci(Irms) + ' A, ' +
                'V_avg(half) = ' + formatSci(VavgHalf) + ' V';
        }

        return {
            V0: V0,
            I0: I0,
            f: f,
            omega: omega,
            phi: phi,
            Vrms: Vrms,
            Irms: Irms,
            VavgHalf: VavgHalf
        };
    }

    function calcPure() {
        var typeEl = document.getElementById('pure-type');
        if (!typeEl) return null;
        var type = typeEl.value;
        var Vrms = parseFloat(document.getElementById('pure-Vrms').value) || 0;
        var f = parseFloat(document.getElementById('pure-f').value) || 0;
        var val = parseFloat(document.getElementById('pure-value').value) || 0;

        var omega = 2 * Math.PI * f;
        var Z = 0;
        var phiDeg = 0;

        if (type === 'R') {
            Z = val;
            phiDeg = 0;
        } else if (type === 'L') {
            var XL = omega * val;
            Z = XL;
            phiDeg = 90;
        } else if (type === 'C') {
            var XC = (omega > 0 && val > 0) ? (1 / (omega * val)) : 0;
            Z = XC;
            phiDeg = -90;
        }

        var Irms = (Z > 0) ? Vrms / Z : 0;
        var cosPhi = Math.cos(degToRad(phiDeg));

        var el = document.getElementById('pure-result');
        if (el) {
            el.textContent =
                '|Z| = ' + formatSci(Z) + ' Ω, ' +
                'I_rms = ' + formatSci(Irms) + ' A, ' +
                'φ = ' + formatSci(phiDeg) + '°, ' +
                'cos φ = ' + formatSci(cosPhi);
        }

        return {
            type: type,
            Vrms: Vrms,
            f: f,
            omega: omega,
            value: val,
            Z: Z,
            phiDeg: phiDeg,
            Irms: Irms,
            cosPhi: cosPhi
        };
    }

    function calcSeries() {
        var R = parseFloat(document.getElementById('ser-R').value) || 0;
        var L = parseFloat(document.getElementById('ser-L').value) || 0;
        var C = parseFloat(document.getElementById('ser-C').value) || 0;
        var Vrms = parseFloat(document.getElementById('ser-Vrms').value) || 0;
        var f = parseFloat(document.getElementById('ser-f').value) || 0;

        var omega = 2 * Math.PI * f;
        var XL = omega * L;
        var XC = (omega > 0 && C > 0) ? (1 / (omega * C)) : 0;
        var diff = XL - XC;
        var Z = Math.sqrt(R * R + diff * diff);
        var Irms = (Z > 0) ? Vrms / Z : 0;
        var phi = Math.atan2(diff, R); // radians
        var phiDeg = phi * 180 / Math.PI;
        var cosPhi = Math.cos(phi);

        var omega0 = (L > 0 && C > 0) ? (1 / Math.sqrt(L * C)) : 0;
        var f0 = omega0 / (2 * Math.PI);
        var Q = (omega0 > 0 && R > 0) ? (omega0 * L / R) : 0;

        var el = document.getElementById('ser-result');
        if (el) {
            el.textContent =
                '|Z| = ' + formatSci(Z) + ' Ω, ' +
                'I_rms = ' + formatSci(Irms) + ' A, ' +
                'φ = ' + formatSci(phiDeg) + '°, ' +
                'cos φ = ' + formatSci(cosPhi) + ', ' +
                'f₀ = ' + formatSci(f0) + ' Hz, ' +
                'Q = ' + formatSci(Q);
        }

        return {
            R: R,
            L: L,
            C: C,
            Vrms: Vrms,
            f: f,
            omega: omega,
            XL: XL,
            XC: XC,
            Z: Z,
            Irms: Irms,
            phi: phi,
            phiDeg: phiDeg,
            cosPhi: cosPhi,
            omega0: omega0,
            f0: f0,
            Q: Q
        };
    }

    function calcPower() {
        var Vrms = parseFloat(document.getElementById('pow-Vrms').value) || 0;
        var Irms = parseFloat(document.getElementById('pow-Irms').value) || 0;
        var phiDeg = parseFloat(document.getElementById('pow-phi').value) || 0;
        var phi = degToRad(phiDeg);

        var cosPhi = Math.cos(phi);
        var sinPhi = Math.sin(phi);
        var P = Vrms * Irms * cosPhi;
        var S = Vrms * Irms;
        var Q = Vrms * Irms * sinPhi;

        var el = document.getElementById('pow-result');
        if (el) {
            el.textContent =
                'P = ' + formatSci(P) + ' W, ' +
                'S = ' + formatSci(S) + ' VA, ' +
                'Q = ' + formatSci(Q) + ' var, ' +
                'cos φ = ' + formatSci(cosPhi);
        }

        return {
            Vrms: Vrms,
            Irms: Irms,
            phiDeg: phiDeg,
            phi: phi,
            cosPhi: cosPhi,
            sinPhi: sinPhi,
            P: P,
            S: S,
            Q: Q
        };
    }

    function calcTransformer() {
        var Vp = parseFloat(document.getElementById('tr-Vp').value) || 0;
        var Np = parseFloat(document.getElementById('tr-Np').value) || 0;
        var Ns = parseFloat(document.getElementById('tr-Ns').value) || 0;
        var eta = parseFloat(document.getElementById('tr-eta').value) || 0;
        var Is = parseFloat(document.getElementById('tr-Is').value) || 0;

        var Vs = (Np > 0) ? Vp * (Ns / Np) : 0;
        var Ip = (Ns > 0) ? Is * (Ns / Np) : 0;
        var PpIdeal = Vp * Ip;
        var PsIdeal = Vs * Is;
        var PsEff = PsIdeal * (eta / 100);

        var el = document.getElementById('tr-result');
        if (el) {
            el.textContent =
                'V_s = ' + formatSci(Vs) + ' V, ' +
                'I_p ≈ ' + formatSci(Ip) + ' A, ' +
                'P_p (ideal) ≈ ' + formatSci(PpIdeal) + ' W, ' +
                'P_s (η-adjusted) ≈ ' + formatSci(PsEff) + ' W';
        }

        return {
            Vp: Vp,
            Np: Np,
            Ns: Ns,
            eta: eta,
            Is: Is,
            Vs: Vs,
            Ip: Ip,
            PpIdeal: PpIdeal,
            PsIdeal: PsIdeal,
            PsEff: PsEff
        };
    }

    function buildStepsBasics(v) {
        if (!v) return [];
        return [
            {
                title: 'Write AC voltage and current',
                formula: 'v = V₀ sin(ωt),  i = I₀ sin(ωt + φ)',
                calc: 'Using V₀ = ' + formatSci(v.V0) + ' V, I₀ = ' + formatSci(v.I0) +
                    ' A, f = ' + formatSci(v.f) + ' Hz ⇒ ω = 2πf = ' + formatSci(v.omega) + ' rad/s'
            },
            {
                title: 'Compute RMS values',
                formula: 'V_rms = V₀/√2,  I_rms = I₀/√2',
                calc: 'V_rms = ' + formatSci(v.Vrms) + ' V, I_rms = ' + formatSci(v.Irms) + ' A'
            },
            {
                title: 'Half‑cycle average',
                formula: 'V_avg(0→π) = 2V₀/π',
                calc: 'V_avg(half) = ' + formatSci(v.VavgHalf) + ' V'
            }
        ];
    }

    function buildStepsPure(v) {
        if (!v) return [];
        var desc = v.type === 'R' ? 'pure resistor (voltage and current in phase)'
            : v.type === 'L' ? 'pure inductor (voltage leads current by 90°)'
            : 'pure capacitor (current leads voltage by 90°)';
        return [
            {
                title: 'Reactance / impedance',
                formula: v.type === 'R' ? 'Z = R' : (v.type === 'L' ? 'X_L = ωL, Z = X_L' : 'X_C = 1/(ωC), Z = X_C'),
                calc: '|Z| = ' + formatSci(v.Z) + ' Ω at f = ' + formatSci(v.f) + ' Hz'
            },
            {
                title: 'Phase relation',
                formula: 'φ = 0° (R), +90° (L), −90° (C)',
                calc: 'φ = ' + formatSci(v.phiDeg) + '°, cos φ = ' + formatSci(v.cosPhi)
            },
            {
                title: 'Current from Ohm’s law in AC',
                formula: 'I_rms = V_rms / |Z|',
                calc: 'I_rms = ' + formatSci(v.Irms) + ' A for V_rms = ' + formatSci(v.Vrms) + ' V'
            },
            {
                title: 'Nature of power',
                formula: 'P = V_rms I_rms cos φ',
                calc: (v.type === 'R'
                    ? 'Resistor: real power consumed (heating).'
                    : 'Pure L or C: cos φ = 0 ⇒ average power ≈ 0 (only reactive).')
            }
        ];
    }

    function buildStepsSeries(v) {
        if (!v) return [];
        return [
            {
                title: 'Compute reactances',
                formula: 'X_L = ωL,  X_C = 1/(ωC)',
                calc: 'X_L = ' + formatSci(v.XL) + ' Ω, X_C = ' + formatSci(v.XC) + ' Ω at f = ' + formatSci(v.f) + ' Hz'
            },
            {
                title: 'Impedance and phase',
                formula: 'Z = √(R² + (X_L − X_C)²),  tan φ = (X_L − X_C)/R',
                calc: '|Z| = ' + formatSci(v.Z) + ' Ω, φ = ' + formatSci(v.phiDeg) + '°, cos φ = ' + formatSci(v.cosPhi)
            },
            {
                title: 'Current in series RLC',
                formula: 'I_rms = V_rms / |Z|',
                calc: 'I_rms = ' + formatSci(v.Irms) + ' A for V_rms = ' + formatSci(v.Vrms) + ' V'
            },
            {
                title: 'Resonant frequency and Q',
                formula: 'ω₀ = 1/√(LC),  f₀ = ω₀/2π,  Q = ω₀L/R',
                calc: 'f₀ = ' + formatSci(v.f0) + ' Hz, Q = ' + formatSci(v.Q)
            }
        ];
    }

    function buildStepsPower(v) {
        if (!v) return [];
        return [
            {
                title: 'Power factor',
                formula: 'cos φ = P / (V_rms I_rms)',
                calc: 'Given φ = ' + formatSci(v.phiDeg) + '°, cos φ = ' + formatSci(v.cosPhi) + ', sin φ = ' + formatSci(v.sinPhi)
            },
            {
                title: 'Average (real) power',
                formula: 'P = V_rms I_rms cos φ',
                calc: 'P = ' + formatSci(v.P) + ' W for V_rms = ' + formatSci(v.Vrms) + ' V and I_rms = ' + formatSci(v.Irms) + ' A'
            },
            {
                title: 'Apparent and reactive power',
                formula: 'S = V_rms I_rms,  Q = V_rms I_rms sin φ',
                calc: 'S = ' + formatSci(v.S) + ' VA, Q = ' + formatSci(v.Q) + ' var'
            },
            {
                title: 'Power triangle',
                formula: 'S² = P² + Q²',
                calc: 'Right triangle with S as hypotenuse, P (adjacent) and Q (opposite).'
            }
        ];
    }

    function buildStepsTransformer(v) {
        if (!v) return [];
        return [
            {
                title: 'Voltage transformation',
                formula: 'V_s / V_p = N_s / N_p',
                calc: 'V_s = ' + formatSci(v.Vs) + ' V from V_p = ' + formatSci(v.Vp) + ' V and N_s/N_p = ' +
                    formatSci(v.Ns) + '/' + formatSci(v.Np)
            },
            {
                title: 'Current transformation (ideal)',
                formula: 'I_p / I_s = N_s / N_p',
                calc: 'I_p ≈ ' + formatSci(v.Ip) + ' A for I_s = ' + formatSci(v.Is) + ' A'
            },
            {
                title: 'Power and efficiency',
                formula: 'P_p ≈ V_p I_p,  P_s ≈ η P_p',
                calc: 'P_p (ideal) ≈ ' + formatSci(v.PpIdeal) + ' W, P_s (η-adjusted) ≈ ' + formatSci(v.PsEff) + ' W for η = ' +
                    formatSci(v.eta) + ' %.'
            }
        ];
    }

    function renderACSteps(steps) {
        var body = document.getElementById('ac-steps-body');
        if (!body) return;
        if (!steps || !steps.length) {
            body.innerHTML = '<p style="margin:0; color: var(--text-secondary); font-size:0.9rem;">Run a calculation to see detailed steps here.</p>';
            return;
        }
        var html = steps.map(function (step, idx) {
            return '' +
                '<div class="step-item">' +
                '  <div class="step-title"><span class="step-number">' + (idx + 1) + '</span>' + step.title + '</div>' +
                '  <div class="step-formula">' + step.formula + '</div>' +
                '  <div class="step-calc">' + step.calc + '</div>' +
                '</div>';
        }).join('');
        body.innerHTML = html;
    }

    function toggleACSteps() {
        var body = document.getElementById('ac-steps-body');
        var toggle = document.getElementById('ac-steps-toggle');
        if (!body || !toggle) return;
        var collapsed = body.classList.toggle('collapsed');
        toggle.textContent = collapsed ? '▼ Show' : '▲ Hide';
    }

    function setSimVisible(visible) {
        var panel = document.getElementById('ac-sim-panel');
        if (!panel) return;
        panel.style.display = visible ? 'block' : 'none';
    }

    function updateBasicsChart(v) {
        var ctx = document.getElementById('ac-chart-canvas');
        if (!ctx || !v) return;

        var tMax = (v.f > 0) ? (2 / v.f) : 0.04; // ~2 cycles if possible
        var points = 200;
        var t = [];
        var vv = [];
        var ii = [];
        for (var i = 0; i <= points; i++) {
            var ti = (tMax * i) / points;
            t.push(ti * 1000); // ms
            vv.push(v.V0 * Math.sin(v.omega * ti));
            ii.push(v.I0 * Math.sin(v.omega * ti + v.phi));
        }

        if (acChart) {
            acChart.destroy();
        }

        acChart = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: t,
                datasets: [
                    {
                        label: 'v(t) [V]',
                        data: vv,
                        borderColor: '#0ea5e9',
                        borderWidth: 2,
                        pointRadius: 0,
                        tension: 0.15
                    },
                    {
                        label: 'i(t) [A]',
                        data: ii,
                        borderColor: '#7c3aed',
                        borderWidth: 2,
                        pointRadius: 0,
                        tension: 0.15,
                        yAxisID: 'y1'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                scales: {
                    x: {
                        title: { display: true, text: 't (ms)' },
                        ticks: { maxTicksLimit: 6 }
                    },
                    y: {
                        title: { display: true, text: 'Voltage (V)' },
                        grid: { color: 'rgba(148,163,184,0.3)' }
                    },
                    y1: {
                        position: 'right',
                        title: { display: true, text: 'Current (A)' },
                        grid: { drawOnChartArea: false }
                    }
                },
                plugins: {
                    legend: { display: true },
                    tooltip: { callbacks: {} }
                }
            }
        });
    }

    function updateSeriesChart(v) {
        var ctx = document.getElementById('ac-chart-canvas');
        if (!ctx || !v || !v.L || !v.C) {
            return;
        }

        var f0 = v.f0 || 0;
        if (f0 <= 0) return;

        var fMin = f0 / 10;
        var fMax = f0 * 10;
        var points = 150;
        var freqs = [];
        var currents = [];

        for (var i = 0; i <= points; i++) {
            var f = fMin * Math.pow(fMax / fMin, i / points);
            var omega = 2 * Math.PI * f;
            var XL = omega * v.L;
            var XC = (omega > 0 && v.C > 0) ? (1 / (omega * v.C)) : 0;
            var diff = XL - XC;
            var Z = Math.sqrt(v.R * v.R + diff * diff);
            var I = (Z > 0) ? v.Vrms / Z : 0;
            freqs.push(f);
            currents.push(I);
        }

        if (acChart) {
            acChart.destroy();
        }

        acChart = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: freqs,
                datasets: [{
                    label: 'I_rms vs frequency',
                    data: currents,
                    borderColor: '#0ea5e9',
                    borderWidth: 2,
                    pointRadius: 0,
                    tension: 0.1,
                    fill: true,
                    backgroundColor: 'rgba(14,165,233,0.12)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                scales: {
                    x: {
                        type: 'logarithmic',
                        title: { display: true, text: 'Frequency (Hz, log scale)' },
                        ticks: { maxTicksLimit: 6 }
                    },
                    y: {
                        title: { display: true, text: 'I_rms (A)' },
                        grid: { color: 'rgba(148,163,184,0.3)' }
                    }
                },
                plugins: {
                    legend: { display: true }
                }
            }
        });
    }

    function clearChart() {
        if (acChart) {
            acChart.destroy();
            acChart = null;
        }
    }

    function runAC() {
        var active = document.querySelector('.ac-tab.active');
        if (!active) return;
        var tab = active.getAttribute('data-tab');

        var steps = [];

        if (tab === 'basics') {
            var vb = calcBasics();
            steps = buildStepsBasics(vb);
            setSimVisible(true);
            updateBasicsChart(vb);
        } else if (tab === 'pure') {
            var vpure = calcPure();
            steps = buildStepsPure(vpure);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'series') {
            var vs = calcSeries();
            steps = buildStepsSeries(vs);
            setSimVisible(true);
            updateSeriesChart(vs);
        } else if (tab === 'power') {
            var vp = calcPower();
            steps = buildStepsPower(vp);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'transformer') {
            var vt = calcTransformer();
            steps = buildStepsTransformer(vt);
            setSimVisible(false);
            clearChart();
        }

        renderACSteps(steps);
    }

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        // Start with basics tab chart and collapsed steps
        var body = document.getElementById('ac-steps-body');
        if (body) body.classList.add('collapsed');
        runAC();
    });

    window.runAC = runAC;
    window.toggleACSteps = toggleACSteps;
})();

