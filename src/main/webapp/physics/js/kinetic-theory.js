(function () {
    'use strict';

    var ktgChart = null;
    var R = 8.314;
    var kB = 1.380649e-23;
    var NA = 6.02214076e23;

    function formatSci(x, digits) {
        digits = digits || 3;
        if (!isFinite(x)) return '—';
        if (x === 0) return '0';
        var abs = Math.abs(x);
        if (abs >= 1e4 || abs <= 1e-3) return x.toExponential(digits);
        return x.toFixed(digits);
    }

    function initTabs() {
        var tabs = document.querySelectorAll('.ktg-tab');
        var panels = document.querySelectorAll('.ktg-panel');
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
                runKTG();
            });
        });
    }

    function calcSpeeds() {
        var T = parseFloat(document.getElementById('ktg-T').value);
        var M = parseFloat(document.getElementById('ktg-M').value);
        if (!isFinite(T) || T <= 0) T = 300;
        if (!isFinite(M) || M <= 0) M = 0.028;

        var v_rms = Math.sqrt(3 * R * T / M);
        var v_avg = Math.sqrt(8 * R * T / (Math.PI * M));
        var v_mp = Math.sqrt(2 * R * T / M);
        var KE_avg = 1.5 * kB * T; // per molecule
        var KE_mole = 1.5 * R * T; // per mole

        var el = document.getElementById('ktg-speeds-result');
        if (el) {
            el.textContent =
                'v_mp = ' + formatSci(v_mp) + ' m/s, ' +
                'v_avg = ' + formatSci(v_avg) + ' m/s, ' +
                'v_rms = ' + formatSci(v_rms) + ' m/s';
        }

        return {
            T: T,
            M: M,
            v_rms: v_rms,
            v_avg: v_avg,
            v_mp: v_mp,
            KE_avg: KE_avg,
            KE_mole: KE_mole
        };
    }

    function calcPressure() {
        var n = parseFloat(document.getElementById('ktg-n').value);
        var V = parseFloat(document.getElementById('ktg-V').value);
        var T = parseFloat(document.getElementById('ktg-Tp').value);
        var M = parseFloat(document.getElementById('ktg-Mp').value);

        if (!isFinite(n) || n <= 0) n = 1;
        if (!isFinite(V) || V <= 0) V = 0.024;
        if (!isFinite(T) || T <= 0) T = 300;
        if (!isFinite(M) || M <= 0) M = 0.028;

        var N = n * NA;
        var m = M / NA;
        var v_rms = Math.sqrt(3 * R * T / M);

        var P_kin = (1 / 3) * (N / V) * m * v_rms * v_rms;
        var P_ideal = n * R * T / V;

        var el = document.getElementById('ktg-pressure-result');
        if (el) {
            el.textContent =
                'P_kinetic = ' + formatSci(P_kin) + ' Pa, ' +
                'P_ideal = ' + formatSci(P_ideal) + ' Pa';
        }

        return {
            n: n,
            V: V,
            T: T,
            M: M,
            N: N,
            m: m,
            v_rms: v_rms,
            P_kin: P_kin,
            P_ideal: P_ideal
        };
    }

    function gasTypeParams(type) {
        if (type === 'mono') {
            return { f: 3 };
        } else if (type === 'dia') {
            return { f: 5 };
        } else if (type === 'dia-high') {
            return { f: 7 };
        }
        return { f: 6 }; // polyatomic non-linear
    }

    function calcDof() {
        var type = document.getElementById('ktg-gastype').value;
        var T = parseFloat(document.getElementById('ktg-Td').value);
        var n = parseFloat(document.getElementById('ktg-nd').value);
        if (!isFinite(T) || T <= 0) T = 300;
        if (!isFinite(n) || n <= 0) n = 1;

        var params = gasTypeParams(type);
        var f = params.f;
        var Cv = 0.5 * f * R;
        var Cp = Cv + R;
        var gamma = Cp / Cv;
        var U = 0.5 * f * n * R * T;

        var el = document.getElementById('ktg-dof-result');
        if (el) {
            el.textContent =
                'U = ' + formatSci(U) + ' J, ' +
                'C_v = ' + formatSci(Cv) + ' J/mol·K, ' +
                'C_p = ' + formatSci(Cp) + ' J/mol·K, ' +
                'γ = ' + formatSci(gamma);
        }

        return {
            type: type,
            f: f,
            T: T,
            n: n,
            Cv: Cv,
            Cp: Cp,
            gamma: gamma,
            U: U
        };
    }

    function calcMfp() {
        var T = parseFloat(document.getElementById('ktg-Tm').value);
        var P = parseFloat(document.getElementById('ktg-Pm').value);
        var d = parseFloat(document.getElementById('ktg-d').value);
        if (!isFinite(T) || T <= 0) T = 300;
        if (!isFinite(P) || P <= 0) P = 1.01e5;
        if (!isFinite(d) || d <= 0) d = 3e-10;

        var lambda = (kB * T) / (Math.sqrt(2) * Math.PI * d * d * P);

        // approximate v_avg using air-like molar mass 0.029 kg/mol for visualization
        var Mvis = 0.029;
        var v_avg = Math.sqrt(8 * R * T / (Math.PI * Mvis));
        var Z = v_avg / lambda;

        var el = document.getElementById('ktg-mfp-result');
        if (el) {
            el.textContent =
                'λ = ' + formatSci(lambda) + ' m, ' +
                'Z = ' + formatSci(Z) + ' s⁻¹';
        }

        return {
            T: T,
            P: P,
            d: d,
            lambda: lambda,
            v_avg: v_avg,
            Z: Z
        };
    }

    function calcGraham() {
        var M1 = parseFloat(document.getElementById('ktg-M1').value);
        var M2 = parseFloat(document.getElementById('ktg-M2').value);
        if (!isFinite(M1) || M1 <= 0) M1 = 0.028;
        if (!isFinite(M2) || M2 <= 0) M2 = 0.032;

        var rRatio = Math.sqrt(M2 / M1);
        var tRatio = Math.sqrt(M1 / M2);

        var el = document.getElementById('ktg-graham-result');
        if (el) {
            el.textContent =
                'r₁/r₂ = ' + formatSci(rRatio) + ', ' +
                't₁/t₂ = ' + formatSci(tRatio);
        }

        return {
            M1: M1,
            M2: M2,
            rRatio: rRatio,
            tRatio: tRatio
        };
    }

    function buildStepsSpeeds(v) {
        if (!v) return [];
        return [
            {
                title: 'Relate speeds to temperature',
                formula: 'v_rms = √(3RT/M), v_avg = √(8RT/(πM)), v_mp = √(2RT/M)',
                calc: 'For T = ' + formatSci(v.T) + ' K and M = ' + formatSci(v.M) +
                    ' kg/mol ⇒ v_mp = ' + formatSci(v.v_mp) + ' m/s, v_avg = ' + formatSci(v.v_avg) +
                    ' m/s, v_rms = ' + formatSci(v.v_rms) + ' m/s.'
            },
            {
                title: 'Check speed ratios',
                formula: 'v_mp : v_avg : v_rms ≈ 1 : 1.128 : 1.224',
                calc: 'Numerically, v_avg/v_mp ≈ ' + formatSci(v.v_avg / v.v_mp) +
                    ', v_rms/v_mp ≈ ' + formatSci(v.v_rms / v.v_mp) + '.'
            },
            {
                title: 'Kinetic energy-temperature relation',
                formula: 'K.E_avg = (3/2)kT, K.E_mole = (3/2)RT',
                calc: 'Per molecule: K.E_avg = ' + formatSci(v.KE_avg) + ' J, per mole: K.E = ' +
                    formatSci(v.KE_mole) + ' J/mol at this temperature.'
            }
        ];
    }

    function buildStepsPressure(v) {
        if (!v) return [];
        return [
            {
                title: 'Compute rms speed',
                formula: 'v_rms = √(3RT/M)',
                calc: 'v_rms = ' + formatSci(v.v_rms) + ' m/s for T = ' + formatSci(v.T) +
                    ' K and M = ' + formatSci(v.M) + ' kg/mol.'
            },
            {
                title: 'Kinetic theory pressure',
                formula: 'P = (1/3)(N/V)m v_rms²',
                calc: 'With N = nN_A = ' + formatSci(v.N) + ', V = ' + formatSci(v.V) +
                    ' m³ and m = M/N_A ⇒ P_kinetic = ' + formatSci(v.P_kin) + ' Pa.'
            },
            {
                title: 'Compare with ideal gas law',
                formula: 'P = nRT/V',
                calc: 'Ideal gas gives P_ideal = ' + formatSci(v.P_ideal) +
                    ' Pa. For an ideal gas these match (differences only from rounding).'
            }
        ];
    }

    function buildStepsDof(v) {
        if (!v) return [];
        var label = v.type === 'mono' ? 'Monatomic'
            : v.type === 'dia' ? 'Diatomic (room T)'
            : v.type === 'dia-high' ? 'Diatomic (high T)'
            : 'Polyatomic (non-linear)';
        return [
            {
                title: 'Identify degrees of freedom',
                formula: 'f = 3 (mono), 5 (dia), 7 (dia high), 6 (poly non-linear)',
                calc: label + ' gas ⇒ f = ' + v.f + '.'
            },
            {
                title: 'Internal energy from equipartition',
                formula: 'U = (f/2) nRT',
                calc: 'For n = ' + formatSci(v.n) + ' mol and T = ' + formatSci(v.T) +
                    ' K ⇒ U = ' + formatSci(v.U) + ' J.'
            },
            {
                title: 'Heat capacities and γ',
                formula: 'C_v = (f/2)R, C_p = C_v + R, γ = C_p/C_v',
                calc: 'C_v = ' + formatSci(v.Cv) + ' J/mol·K, C_p = ' + formatSci(v.Cp) +
                    ' J/mol·K, γ = ' + formatSci(v.gamma) + '.'
            }
        ];
    }

    function buildStepsMfp(v) {
        if (!v) return [];
        return [
            {
                title: 'Mean free path formula',
                formula: 'λ = (kT)/(√2 π d² P)',
                calc: 'For T = ' + formatSci(v.T) + ' K, P = ' + formatSci(v.P) +
                    ' Pa and d = ' + formatSci(v.d) + ' m ⇒ λ = ' + formatSci(v.lambda) + ' m.'
            },
            {
                title: 'Collision frequency',
                formula: 'Z = v_avg/λ',
                calc: 'With v_avg ≈ ' + formatSci(v.v_avg) +
                    ' m/s ⇒ Z = ' + formatSci(v.Z) + ' s⁻¹ (collisions per second per molecule).'
            },
            {
                title: 'Physical meaning',
                formula: 'Short λ ⇒ frequent collisions',
                calc: 'A very small λ (e.g., ~10⁻⁷ m for air at STP) explains gas diffusion and viscosity.'
            }
        ];
    }

    function buildStepsGraham(v) {
        if (!v) return [];
        return [
            {
                title: 'Graham’s law of diffusion/effusion',
                formula: 'r₁/r₂ = √(M₂/M₁)',
                calc: 'For M₁ = ' + formatSci(v.M1) + ' kg/mol and M₂ = ' + formatSci(v.M2) +
                    ' kg/mol ⇒ r₁/r₂ = ' + formatSci(v.rRatio) +
                    ' (gas 1 diffuses this many times faster than gas 2).'
            },
            {
                title: 'Time of effusion',
                formula: 't₁/t₂ = √(M₁/M₂)',
                calc: 'Time ratio t₁/t₂ = ' + formatSci(v.tRatio) + ' (heavier gas takes longer).'
            }
        ];
    }

    function renderKTGSteps(steps) {
        var body = document.getElementById('ktg-steps-body');
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

    function toggleKTGSteps() {
        var body = document.getElementById('ktg-steps-body');
        var toggle = document.getElementById('ktg-steps-toggle');
        if (!body || !toggle) return;
        var collapsed = body.classList.toggle('collapsed');
        toggle.textContent = collapsed ? '▼ Show' : '▲ Hide';
    }

    function setSimVisible(visible) {
        var panel = document.getElementById('ktg-sim-panel');
        if (!panel) return;
        panel.style.display = visible ? 'block' : 'none';
    }

    function clearChart() {
        if (ktgChart) {
            ktgChart.destroy();
            ktgChart = null;
        }
    }

    function updateSpeedsChart(v) {
        var ctx = document.getElementById('ktg-chart-canvas');
        if (!ctx || !v) return;

        // Maxwell-Boltzmann speed distribution (shape only)
        var m = v.M / NA;
        var a = m / (2 * kB * v.T);

        var vmax = 3 * v.v_rms;
        var points = 200;
        var speeds = [];
        var dist = [];
        for (var i = 0; i <= points; i++) {
            var u = (vmax * i) / points;
            speeds.push(u);
            var f = 4 * Math.PI * Math.pow(a / Math.PI, 1.5) * u * u * Math.exp(-a * u * u);
            dist.push(f);
        }

        clearChart();

        ktgChart = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: speeds,
                datasets: [{
                    label: 'Maxwell speed distribution (relative)',
                    data: dist,
                    borderColor: '#22c55e',
                    borderWidth: 2,
                    pointRadius: 0,
                    tension: 0.15,
                    fill: true,
                    backgroundColor: 'rgba(34,197,94,0.15)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                scales: {
                    x: {
                        title: { display: true, text: 'Speed v (m/s)' },
                        ticks: { maxTicksLimit: 6 }
                    },
                    y: {
                        title: { display: true, text: 'Relative probability f(v)' },
                        grid: { color: 'rgba(148,163,184,0.3)' }
                    }
                },
                plugins: {
                    legend: { display: true }
                }
            }
        });
    }

    function runKTG() {
        var active = document.querySelector('.ktg-tab.active');
        if (!active) return;
        var tab = active.getAttribute('data-tab');
        var steps = [];

        if (tab === 'speeds') {
            var vs = calcSpeeds();
            steps = buildStepsSpeeds(vs);
            setSimVisible(true);
            updateSpeedsChart(vs);
        } else if (tab === 'pressure') {
            var vp = calcPressure();
            steps = buildStepsPressure(vp);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'dof') {
            var vd = calcDof();
            steps = buildStepsDof(vd);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'mfp') {
            var vm = calcMfp();
            steps = buildStepsMfp(vm);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'graham') {
            var vg = calcGraham();
            steps = buildStepsGraham(vg);
            setSimVisible(false);
            clearChart();
        }

        renderKTGSteps(steps);
    }

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        var body = document.getElementById('ktg-steps-body');
        if (body) body.classList.add('collapsed');
        runKTG();
    });

    window.runKTG = runKTG;
    window.toggleKTGSteps = toggleKTGSteps;
})();

