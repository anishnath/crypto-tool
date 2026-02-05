(function () {
    'use strict';

    var K = 8.9875517923e9; // Coulomb's constant (approx 9e9)
    var EPS0 = 8.854e-12;
    var esChart = null;

    function initTabs() {
        var tabs = document.querySelectorAll('.es-tab');
        var panels = document.querySelectorAll('.es-panel');
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
        if (abs >= 1e4 || abs <= 1e-3) {
            return x.toExponential(digits);
        }
        return x.toFixed(digits);
    }

    function calcCoulomb() {
        var q1 = parseFloat(document.getElementById('coulomb-q1').value) || 0;
        var q2 = parseFloat(document.getElementById('coulomb-q2').value) || 0;
        var r = parseFloat(document.getElementById('coulomb-r').value) || 0;
        var F = 0;
        var E = 0;
        if (r > 0) {
            F = K * q1 * q2 / (r * r);
            E = K * q1 / (r * r);
        }
        var el = document.getElementById('es-coulomb-result');
        if (el) {
            el.textContent = 'F = ' + formatSci(F) + ' N,  E at q₂ due to q₁ = ' + formatSci(E) + ' N/C';
        }
        return { q1: q1, q2: q2, r: r, F: F, E: E };
    }

    function calcField() {
        var cfg = document.getElementById('field-config').value;
        var p1 = parseFloat(document.getElementById('field-param1').value) || 0;
        var p2 = parseFloat(document.getElementById('field-param2').value) || 0;
        var p3 = parseFloat(document.getElementById('field-param3').value) || 0;
        var E = 0;
        if (cfg === 'line') {
            var lambda = p1;
            var r = p2;
            if (r > 0) E = lambda / (2 * Math.PI * EPS0 * r);
        } else if (cfg === 'sheet') {
            var sigma = p1;
            E = sigma / (2 * EPS0);
        } else if (cfg === 'parallel') {
            var sigma2 = p1;
            E = sigma2 / EPS0;
        } else if (cfg === 'sphere-out') {
            var Q = p1;
            var rout = p2;
            if (rout > 0) E = K * Q / (rout * rout);
        } else if (cfg === 'sphere-in') {
            var Qin = p1;
            var rIn = p2;
            var R = p3;
            if (R > 0 && rIn <= R && rIn >= 0) {
                E = K * Qin * rIn / (R * R * R);
            } else if (rIn > R && rIn > 0) {
                E = K * Qin / (rIn * rIn);
            }
        }
        var el = document.getElementById('es-field-result');
        if (el) {
            el.textContent = 'E = ' + formatSci(E) + ' N/C';
        }
        return { cfg: cfg, p1: p1, p2: p2, p3: p3, E: E };
    }

    function calcPotential() {
        var q = parseFloat(document.getElementById('pot-q').value) || 0;
        var r = parseFloat(document.getElementById('pot-r').value) || 0;
        var qtest = parseFloat(document.getElementById('pot-test-q').value) || 0;
        var V = 0;
        if (r > 0) {
            V = K * q / r;
        }
        var U = qtest * V;
        var el = document.getElementById('es-potential-result');
        if (el) {
            el.textContent = 'V = ' + formatSci(V) + ' V,  U = ' + formatSci(U) + ' J';
        }
        return { q: q, r: r, qtest: qtest, V: V, U: U };
    }

    function calcCapacitor() {
        var A = parseFloat(document.getElementById('cap-A').value) || 0;
        var d = parseFloat(document.getElementById('cap-d').value) || 0;
        var kappa = parseFloat(document.getElementById('cap-kappa').value) || 1;
        var V = parseFloat(document.getElementById('cap-V').value) || 0;
        var C = 0;
        if (d > 0) {
            C = kappa * EPS0 * A / d;
        }
        var U = 0.5 * C * V * V;
        var el = document.getElementById('es-capacitor-result');
        if (el) {
            el.textContent = 'C = ' + formatSci(C) + ' F,  U = ' + formatSci(U) + ' J';
        }
        return { A: A, d: d, kappa: kappa, V: V, C: C, U: U };
    }

    function buildStepsCoulomb(v) {
        var steps = [];
        steps.push({
            title: 'Apply Coulomb’s law',
            formula: 'F = k q₁ q₂ / r²',
            calc: 'F = (9×10⁹) × (' + v.q1 + ') × (' + v.q2 + ') / (' + v.r + ')² ≈ ' + formatSci(v.F) + ' N'
        });
        steps.push({
            title: 'Electric field at q₂ due to q₁',
            formula: 'E = F / q₂ = k q₁ / r²',
            calc: 'E = ' + formatSci(v.E) + ' N/C'
        });
        return steps;
    }

    function buildStepsField(v) {
        var steps = [];
        if (v.cfg === 'line') {
            steps.push({
                title: 'Infinite line charge',
                formula: 'E = λ / (2πε₀ r)',
                calc: 'E = ' + v.p1 + ' / (2π × 8.854×10⁻¹² × ' + v.p2 + ') ≈ ' + formatSci(v.E) + ' N/C'
            });
        } else if (v.cfg === 'sheet') {
            steps.push({
                title: 'Infinite sheet',
                formula: 'E = σ / (2ε₀)',
                calc: 'E = ' + v.p1 + ' / (2 × 8.854×10⁻¹²) ≈ ' + formatSci(v.E) + ' N/C'
            });
        } else if (v.cfg === 'parallel') {
            steps.push({
                title: 'Two parallel sheets',
                formula: 'E = σ / ε₀ (between)',
                calc: 'E = ' + v.p1 + ' / (8.854×10⁻¹²) ≈ ' + formatSci(v.E) + ' N/C'
            });
        } else if (v.cfg === 'sphere-out') {
            steps.push({
                title: 'Field outside charged sphere/shell',
                formula: 'E = kQ / r²',
                calc: 'E = (9×10⁹ × ' + v.p1 + ')/(' + v.p2 + ')² ≈ ' + formatSci(v.E) + ' N/C'
            });
        } else if (v.cfg === 'sphere-in') {
            steps.push({
                title: 'Uniformly charged solid sphere (inside)',
                formula: 'E = kQr/R³ (r ≤ R) or kQ/r² (r ≥ R)',
                calc: 'E ≈ ' + formatSci(v.E) + ' N/C using appropriate case for r and R'
            });
        }
        return steps;
    }

    function buildStepsPotential(v) {
        var steps = [];
        steps.push({
            title: 'Potential due to point charge',
            formula: 'V = kq / r (V(∞) = 0)',
            calc: 'V = (9×10⁹ × ' + v.q + ')/(' + v.r + ') ≈ ' + formatSci(v.V) + ' V'
        });
        steps.push({
            title: 'Potential energy of test charge',
            formula: 'U = qV',
            calc: 'U = ' + v.qtest + ' × ' + formatSci(v.V) + ' ≈ ' + formatSci(v.U) + ' J'
        });
        return steps;
    }

    function buildStepsCapacitor(v) {
        var steps = [];
        steps.push({
            title: 'Capacitance of parallel plate capacitor',
            formula: 'C = κ ε₀ A / d',
            calc: 'C = ' + v.kappa + ' × 8.854×10⁻¹² × ' + v.A + ' / ' + v.d + ' ≈ ' + formatSci(v.C) + ' F'
        });
        steps.push({
            title: 'Energy stored in capacitor',
            formula: 'U = ½ C V²',
            calc: 'U = ½ × ' + formatSci(v.C) + ' × ' + v.V + '² ≈ ' + formatSci(v.U) + ' J'
        });
        return steps;
    }

    function renderEsSteps(steps) {
        var container = document.getElementById('es-steps-body');
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

    function updateCoulombChart(v) {
        var canvas = document.getElementById('es-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.r <= 0) {
            if (esChart) {
                esChart.destroy();
                esChart = null;
            }
            return;
        }
        var labels = [];
        var forces = [];
        var fields = [];
        var rMin = v.r / 5 > 0 ? v.r / 5 : 0.01;
        var rMax = v.r * 3;
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var r = rMin + (rMax - rMin) * (i / steps);
            var F = K * v.q1 * v.q2 / (r * r);
            var E = K * v.q1 / (r * r);
            labels.push(r.toFixed(2));
            forces.push(F);
            fields.push(E);
        }
        if (esChart) esChart.destroy();
        esChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Force |F(r)|',
                        data: forces,
                        borderColor: '#2563eb',
                        backgroundColor: 'transparent',
                        borderWidth: 2,
                        pointRadius: 0
                    },
                    {
                        label: 'Field |E(r)| at q₂ due to q₁',
                        data: fields,
                        borderColor: '#7c3aed',
                        backgroundColor: 'transparent',
                        borderWidth: 1,
                        pointRadius: 0
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Coulomb: F(r), E(r) vs distance' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 'r (m)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'Magnitude (SI units)' }
                    }
                }
            }
        });
    }

    function updateFieldChart(v) {
        var canvas = document.getElementById('es-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v) return;
        var labels = [];
        var fields = [];
        var cfg = v.cfg;
        var steps = 60;
        if (cfg === 'line' || cfg === 'sphere-out' || cfg === 'sphere-in') {
            var rMin = 0.01;
            var rMax = Math.max(0.1, v.p2 || 1);
            for (var i = 0; i <= steps; i++) {
                var r = rMin + (rMax - rMin) * (i / steps);
                var E = 0;
                if (cfg === 'line') {
                    E = v.p1 / (2 * Math.PI * EPS0 * r);
                } else if (cfg === 'sphere-out') {
                    E = K * v.p1 / (r * r);
                } else if (cfg === 'sphere-in') {
                    if (v.p3 > 0 && r <= v.p3) {
                        E = K * v.p1 * r / (v.p3 * v.p3 * v.p3);
                    } else {
                        E = K * v.p1 / (r * r);
                    }
                }
                labels.push(r.toFixed(2));
                fields.push(E);
            }
        } else {
            // For sheet / parallel, show constant field vs r index
            for (var j = 0; j <= steps; j++) {
                labels.push(j.toString());
                fields.push(v.E);
            }
        }
        if (esChart) esChart.destroy();
        esChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'E(r)',
                        data: fields,
                        borderColor: '#16a34a',
                        backgroundColor: 'rgba(22,163,74,0.08)',
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
                    title: { display: true, text: 'Electric field vs distance / index' }
                },
                scales: {
                    x: {
                        title: { display: true, text: (cfg === 'sheet' || cfg === 'parallel') ? 'Position index' : 'r (m)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'E (N/C)' }
                    }
                }
            }
        });
    }

    function updatePotentialChart(v) {
        var canvas = document.getElementById('es-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.r <= 0) {
            if (esChart) {
                esChart.destroy();
                esChart = null;
            }
            return;
        }
        var labels = [];
        var Vvals = [];
        var rMin = v.r / 5 > 0 ? v.r / 5 : 0.01;
        var rMax = v.r * 3;
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var r = rMin + (rMax - rMin) * (i / steps);
            var V = K * v.q / r;
            labels.push(r.toFixed(2));
            Vvals.push(V);
        }
        if (esChart) esChart.destroy();
        esChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'V(r)',
                        data: Vvals,
                        borderColor: '#f97316',
                        backgroundColor: 'rgba(249,115,22,0.08)',
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
                    title: { display: true, text: 'Potential V(r) for a point charge' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 'r (m)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'V (volts)' }
                    }
                }
            }
        });
    }

    function updateCapacitorChart(v) {
        var canvas = document.getElementById('es-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (!v || v.C <= 0) {
            if (esChart) {
                esChart.destroy();
                esChart = null;
            }
            return;
        }
        var labels = [];
        var Uvals = [];
        var Vmin = 0;
        var Vmax = Math.max(v.V, 1);
        var steps = 60;
        for (var i = 0; i <= steps; i++) {
            var Vnow = Vmin + (Vmax - Vmin) * (i / steps);
            var U = 0.5 * v.C * Vnow * Vnow;
            labels.push(Vnow.toFixed(1));
            Uvals.push(U);
        }
        if (esChart) esChart.destroy();
        esChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'U(V) = ½CV²',
                        data: Uvals,
                        borderColor: '#dc2626',
                        backgroundColor: 'rgba(220,38,38,0.08)',
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
                    title: { display: true, text: 'Energy in capacitor vs voltage' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 'V (volts)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'U (J)' }
                    }
                }
            }
        });
    }

    function runElectrostatics() {
        var active = document.querySelector('.es-tab.active');
        var tab = active ? active.getAttribute('data-tab') : 'coulomb';
        var vals, steps;
        if (tab === 'coulomb') {
            vals = calcCoulomb();
            steps = buildStepsCoulomb(vals);
            updateCoulombChart(vals);
        } else if (tab === 'field') {
            vals = calcField();
            steps = buildStepsField(vals);
            updateFieldChart(vals);
        } else if (tab === 'potential') {
            vals = calcPotential();
            steps = buildStepsPotential(vals);
            updatePotentialChart(vals);
        } else if (tab === 'capacitor') {
            vals = calcCapacitor();
            steps = buildStepsCapacitor(vals);
            updateCapacitorChart(vals);
        }
        if (steps) renderEsSteps(steps);
    }

    function toggleEsSteps() {
        var body = document.getElementById('es-steps-body');
        var toggle = document.getElementById('es-steps-toggle');
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

    window.runElectrostatics = runElectrostatics;
    window.toggleEsSteps = toggleEsSteps;

    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        var initial = calcCoulomb();
        renderEsSteps(buildStepsCoulomb(initial));
        updateCoulombChart(initial);
    });
})();
