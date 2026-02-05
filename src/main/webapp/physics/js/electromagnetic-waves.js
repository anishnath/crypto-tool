(function () {
    'use strict';

    var emwChart = null;
    var MU0 = 4 * Math.PI * 1e-7;
    var EPS0 = 8.854187817e-12;
    var C = 1 / Math.sqrt(MU0 * EPS0);

    function formatSci(x, digits) {
        digits = digits || 3;
        if (!isFinite(x)) return '—';
        if (x === 0) return '0';
        var abs = Math.abs(x);
        if (abs >= 1e4 || abs <= 1e-3) return x.toExponential(digits);
        return x.toFixed(digits);
    }

    function initTabs() {
        var tabs = document.querySelectorAll('.emw-tab');
        var panels = document.querySelectorAll('.emw-panel');
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
                runEMW();
            });
        });
    }

    function calcBasics() {
        var mu = parseFloat(document.getElementById('emw-mu').value);
        var eps = parseFloat(document.getElementById('emw-eps').value);
        var E0 = parseFloat(document.getElementById('emw-E0').value);
        var B0 = parseFloat(document.getElementById('emw-B0').value);

        if (!isFinite(mu) || mu <= 0) mu = MU0;
        if (!isFinite(eps) || eps <= 0) eps = EPS0;
        if (!isFinite(E0)) E0 = 0;
        if (!isFinite(B0) || B0 <= 0) {
            // if only E0 is given, approximate B0 from vacuum relation
            if (E0 !== 0) {
                B0 = E0 / C;
            } else {
                B0 = 0;
            }
        }

        var c = C;
        var v = 1 / Math.sqrt(mu * eps);
        var ratio = (B0 !== 0) ? (E0 / B0) : NaN;

        var el = document.getElementById('emw-basics-result');
        if (el) {
            el.textContent =
                'c ≈ ' + formatSci(c) + ' m/s, ' +
                'v = ' + formatSci(v) + ' m/s, ' +
                'E₀/B₀ = ' + formatSci(ratio);
        }

        return {
            mu: mu,
            eps: eps,
            E0: E0,
            B0: B0,
            c: c,
            v: v,
            ratio: ratio
        };
    }

    function calcIntensity() {
        var E0 = parseFloat(document.getElementById('int-E0').value);
        var B0 = parseFloat(document.getElementById('int-B0').value);

        if (!isFinite(E0)) E0 = 0;
        if (!isFinite(B0) || B0 <= 0) {
            if (E0 !== 0) {
                B0 = E0 / C;
            } else {
                B0 = 0;
            }
        }

        var I = (E0 * E0) / (2 * MU0 * C);
        var uAvg = EPS0 * E0 * E0 / 2;

        var el = document.getElementById('emw-intensity-result');
        if (el) {
            el.textContent =
                'I = ' + formatSci(I) + ' W/m², ' +
                'u_avg = ' + formatSci(uAvg) + ' J/m³';
        }

        return {
            E0: E0,
            B0: B0,
            I: I,
            uAvg: uAvg
        };
    }

    function classifySpectrum(lambda, f) {
        var band = 'Unknown';

        // Prefer λ if given
        if (lambda && lambda > 0) {
            if (lambda > 1) band = 'Radio waves';
            else if (lambda > 1e-3) band = 'Microwaves';
            else if (lambda > 7e-7) band = 'Infrared';
            else if (lambda > 4e-7) band = 'Visible light';
            else if (lambda > 1e-8) band = 'Ultraviolet';
            else if (lambda > 1e-11) band = 'X-rays';
            else band = 'Gamma rays';
            return band;
        }

        // Otherwise use frequency
        if (!f || f <= 0) return band;
        if (f < 3e8) band = 'Radio waves';
        else if (f < 3e11) band = 'Microwaves';
        else if (f < 4.3e14) band = 'Infrared';
        else if (f < 7.5e14) band = 'Visible light';
        else if (f < 3e16) band = 'Ultraviolet';
        else if (f < 3e19) band = 'X-rays';
        else band = 'Gamma rays';
        return band;
    }

    function calcSpectrum() {
        var lambda = parseFloat(document.getElementById('spec-lambda').value);
        var fInput = parseFloat(document.getElementById('spec-f').value);
        var f;

        if (isFinite(lambda) && lambda > 0) {
            f = C / lambda;
        } else if (isFinite(fInput) && fInput > 0) {
            f = fInput;
            lambda = C / f;
        } else {
            lambda = NaN;
            f = NaN;
        }

        var band = classifySpectrum(lambda, f);

        var el = document.getElementById('emw-spectrum-result');
        if (el) {
            el.textContent =
                'Band = ' + band + ', f ≈ ' + formatSci(f) + ' Hz';
        }

        return {
            lambda: lambda,
            f: f,
            band: band
        };
    }

    function calcDisplacement() {
        var dEdt = parseFloat(document.getElementById('disp-dEdt').value);
        var area = parseFloat(document.getElementById('disp-area').value);
        if (!isFinite(dEdt)) dEdt = 0;
        if (!isFinite(area) || area < 0) area = 0;

        var Jd = EPS0 * dEdt;
        var Id = Jd * area;

        var el = document.getElementById('emw-displacement-result');
        if (el) {
            el.textContent =
                'J_d = ' + formatSci(Jd) + ' A/m², ' +
                'I_d = ' + formatSci(Id) + ' A';
        }

        return {
            dEdt: dEdt,
            area: area,
            Jd: Jd,
            Id: Id
        };
    }

    function calcRadiation() {
        var I = parseFloat(document.getElementById('rad-I').value);
        var area = parseFloat(document.getElementById('rad-area').value);
        var type = document.getElementById('rad-type').value;
        if (!isFinite(I)) I = 0;
        if (!isFinite(area) || area < 0) area = 0;

        var factor = (type === 'reflect') ? 2 : 1;
        var P = factor * I / C;
        var F = P * area;

        var el = document.getElementById('emw-radiation-result');
        if (el) {
            el.textContent =
                'P = ' + formatSci(P) + ' N/m², ' +
                'F = ' + formatSci(F) + ' N';
        }

        return {
            I: I,
            area: area,
            type: type,
            P: P,
            F: F
        };
    }

    function buildStepsBasics(v) {
        if (!v) return [];
        return [
            {
                title: 'Speed of light from μ₀ and ε₀',
                formula: 'c = 1 / √(μ₀ ε₀)',
                calc: 'Using μ₀ = 4π×10⁻⁷ H/m and ε₀ ≈ 8.85×10⁻¹² F/m ⇒ c ≈ ' + formatSci(v.c) + ' m/s'
            },
            {
                title: 'Speed in any medium',
                formula: 'v = 1 / √(μ ε)',
                calc: 'For μ = ' + formatSci(v.mu) + ' H/m and ε = ' + formatSci(v.eps) +
                    ' F/m ⇒ v = ' + formatSci(v.v) + ' m/s'
            },
            {
                title: 'Relation between E and B',
                formula: 'E = c B (vacuum) ⇒ E₀/B₀ = c',
                calc: 'With E₀ = ' + formatSci(v.E0) + ' V/m and B₀ = ' + formatSci(v.B0) +
                    ' T ⇒ E₀/B₀ = ' + formatSci(v.ratio) + ' m/s'
            }
        ];
    }

    function buildStepsIntensity(v) {
        if (!v) return [];
        return [
            {
                title: 'Write intensity formula',
                formula: 'I = E₀² / (2 μ₀ c) = c B₀² / (2 μ₀)',
                calc: 'Using E₀ = ' + formatSci(v.E0) + ' V/m ⇒ I = ' + formatSci(v.I) + ' W/m²'
            },
            {
                title: 'Average energy density',
                formula: 'u_avg = ε₀ E₀² / 2 = B₀² / (2 μ₀)',
                calc: 'u_avg = ' + formatSci(v.uAvg) + ' J/m³ for the same field amplitude'
            },
            {
                title: 'Electric and magnetic contributions',
                formula: 'u_E avg = u_B avg',
                calc: 'Energy is shared equally between electric and magnetic fields in an EM wave.'
            }
        ];
    }

    function buildStepsSpectrum(v) {
        if (!v) return [];
        return [
            {
                title: 'Relate λ and f in vacuum',
                formula: 'c = λ f',
                calc: 'Using c ≈ ' + formatSci(C) + ' m/s and λ = ' + formatSci(v.lambda) +
                    ' m ⇒ f = ' + formatSci(v.f) + ' Hz'
            },
            {
                title: 'Locate band in spectrum',
                formula: 'Radio → Microwave → IR → Visible → UV → X-ray → Gamma',
                calc: 'This λ or f lies in the region: ' + v.band + '.'
            }
        ];
    }

    function buildStepsDisplacement(v) {
        if (!v) return [];
        return [
            {
                title: 'Displacement current density',
                formula: 'J_d = ε₀ ∂E/∂t',
                calc: 'With ∂E/∂t = ' + formatSci(v.dEdt) + ' V/m·s, J_d = ' + formatSci(v.Jd) + ' A/m²'
            },
            {
                title: 'Total displacement current',
                formula: 'I_d = J_d × A = ε₀ dΦ_E/dt',
                calc: 'For area A = ' + formatSci(v.area) + ' m² ⇒ I_d = ' + formatSci(v.Id) + ' A'
            },
            {
                title: 'Ampere–Maxwell law',
                formula: '∮ B·dl = μ₀ (I + I_d)',
                calc: 'Displacement current term I_d makes Ampere’s law consistent for time-varying fields.'
            }
        ];
    }

    function buildStepsRadiation(v) {
        if (!v) return [];
        var typeText = v.type === 'reflect' ? 'perfect reflector (bounced light)' : 'perfect absorber (absorbed light)';
        return [
            {
                title: 'Radiation pressure from intensity',
                formula: 'P = I/c (absorber), P = 2I/c (reflector)',
                calc: 'For ' + typeText + ' with I = ' + formatSci(v.I) + ' W/m² ⇒ P = ' + formatSci(v.P) + ' N/m²'
            },
            {
                title: 'Force due to radiation',
                formula: 'F = P × A',
                calc: 'On area A = ' + formatSci(v.area) + ' m² ⇒ F = ' + formatSci(v.F) + ' N'
            },
            {
                title: 'Momentum transfer',
                formula: 'Δp = F Δt,  p_photon = h/λ',
                calc: 'Radiation pressure arises from momentum carried by photons and transferred to the surface.'
            }
        ];
    }

    function renderEMWSteps(steps) {
        var body = document.getElementById('emw-steps-body');
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

    function toggleEMWSteps() {
        var body = document.getElementById('emw-steps-body');
        var toggle = document.getElementById('emw-steps-toggle');
        if (!body || !toggle) return;
        var collapsed = body.classList.toggle('collapsed');
        toggle.textContent = collapsed ? '▼ Show' : '▲ Hide';
    }

    function setSimVisible(visible) {
        var panel = document.getElementById('emw-sim-panel');
        if (!panel) return;
        panel.style.display = visible ? 'block' : 'none';
    }

    function clearChart() {
        if (emwChart) {
            emwChart.destroy();
            emwChart = null;
        }
    }

    function updateBasicsChart(v) {
        var ctx = document.getElementById('emw-chart-canvas');
        if (!ctx || !v) return;

        var lambda = C / (5e14); // default visible-green if nothing else
        if (v.E0 && v.E0 !== 0) {
            // keep lambda fixed; visualization is qualitative, not strict to inputs
        }

        var k = 2 * Math.PI / lambda;
        var points = 200;
        var xs = [];
        var Evals = [];
        var Bvals = [];
        var L = lambda; // one wavelength range
        for (var i = 0; i <= points; i++) {
            var x = (L * i) / points;
            xs.push(x * 1e9); // in nm
            var phase = k * x;
            Evals.push(v.E0 * Math.sin(phase));
            Bvals.push(v.B0 * Math.sin(phase));
        }

        clearChart();

        emwChart = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: xs,
                datasets: [
                    {
                        label: 'E(x) [V/m]',
                        data: Evals,
                        borderColor: '#0ea5e9',
                        borderWidth: 2,
                        pointRadius: 0,
                        tension: 0.15
                    },
                    {
                        label: 'B(x) [T] (scaled)',
                        data: Bvals,
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
                        title: { display: true, text: 'x (nm, across one wavelength)' },
                        ticks: { maxTicksLimit: 6 }
                    },
                    y: {
                        title: { display: true, text: 'Electric field (V/m)' },
                        grid: { color: 'rgba(148,163,184,0.3)' }
                    },
                    y1: {
                        position: 'right',
                        title: { display: true, text: 'Magnetic field (T)' },
                        grid: { drawOnChartArea: false }
                    }
                },
                plugins: {
                    legend: { display: true }
                }
            }
        });
    }

    function updateSpectrumChart() {
        var ctx = document.getElementById('emw-chart-canvas');
        if (!ctx) return;

        var bands = ['Radio', 'Microwave', 'IR', 'Visible', 'UV', 'X-ray', 'Gamma'];
        var centerLogLambda = [
            Math.log10(10),         // ~10 m
            Math.log10(1e-2),       // 1 cm
            Math.log10(1e-4),       // 100 μm
            Math.log10(5.5e-7),     // visible
            Math.log10(1e-8),       // 10 nm
            Math.log10(1e-10),      // 0.1 nm
            Math.log10(1e-12)       // 0.01 nm
        ];

        clearChart();

        emwChart = new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: {
                labels: bands,
                datasets: [{
                    label: 'log₁₀(λ / m)',
                    data: centerLogLambda,
                    backgroundColor: [
                        '#0ea5e9',
                        '#22c55e',
                        '#f97316',
                        '#eab308',
                        '#6366f1',
                        '#a855f7',
                        '#ec4899'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        title: { display: true, text: 'log₁₀(λ / m)' },
                        grid: { color: 'rgba(148,163,184,0.3)' }
                    }
                },
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }

    function runEMW() {
        var active = document.querySelector('.emw-tab.active');
        if (!active) return;
        var tab = active.getAttribute('data-tab');
        var steps = [];

        if (tab === 'basics') {
            var vb = calcBasics();
            steps = buildStepsBasics(vb);
            setSimVisible(true);
            updateBasicsChart(vb);
        } else if (tab === 'intensity') {
            var vi = calcIntensity();
            steps = buildStepsIntensity(vi);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'spectrum') {
            var vs = calcSpectrum();
            steps = buildStepsSpectrum(vs);
            setSimVisible(true);
            updateSpectrumChart();
        } else if (tab === 'displacement') {
            var vd = calcDisplacement();
            steps = buildStepsDisplacement(vd);
            setSimVisible(false);
            clearChart();
        } else if (tab === 'radiation') {
            var vr = calcRadiation();
            steps = buildStepsRadiation(vr);
            setSimVisible(false);
            clearChart();
        }

        renderEMWSteps(steps);
    }

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        var body = document.getElementById('emw-steps-body');
        if (body) body.classList.add('collapsed');
        runEMW();
    });

    window.runEMW = runEMW;
    window.toggleEMWSteps = toggleEMWSteps;
})();

