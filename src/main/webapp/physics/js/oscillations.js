(function () {
    'use strict';

    var shmChart = null;
    var matterEngine = null;
    var matterRender = null;
    var matterRunner = null;
    var shmMass = null;
    var shmAnchor = null;
    var shmSpring = null;

    function initTabs() {
        var tabs = document.querySelectorAll('.shm-tab');
        var panels = document.querySelectorAll('.shm-panel');
        if (!tabs.length) return;

        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                var id = tab.getAttribute('data-tab');
                tabs.forEach(function (t) { t.classList.remove('active'); });
                panels.forEach(function (p) {
                    p.classList.remove('active');
                    if (p.id === 'panel-' + id) {
                        p.classList.add('active');
                    }
                });
                tab.classList.add('active');
            });
        });
    }

    function calcBasics() {
        var A = parseFloat(document.getElementById('shm-A').value) || 0;
        var omega = parseFloat(document.getElementById('shm-omega').value) || 0;
        var t = parseFloat(document.getElementById('shm-t').value) || 0;
        var phi = parseFloat(document.getElementById('shm-phi').value) || 0;
        var arg = omega * t + phi;
        var x = A * Math.sin(arg);
        var v = A * omega * Math.cos(arg);
        var a = -omega * omega * x;
        var el = document.getElementById('shm-basics-result');
        if (el) {
            el.textContent =
                'x = ' + x.toFixed(4) + ' m, ' +
                'v = ' + v.toFixed(4) + ' m/s, ' +
                'a = ' + a.toFixed(4) + ' m/s²';
        }
        return { A: A, omega: omega, t: t, phi: phi, x: x, v: v, a: a };
    }

    function calcEnergy() {
        var m = parseFloat(document.getElementById('shm-m').value) || 0;
        var k = parseFloat(document.getElementById('shm-k').value) || 0;
        var A = parseFloat(document.getElementById('shm-A-energy').value) || 0;
        var x = parseFloat(document.getElementById('shm-x-energy').value) || 0;
        var E = 0.5 * k * A * A;
        var PE = 0.5 * k * x * x;
        var KE = E - PE;
        var el = document.getElementById('shm-energy-result');
        if (el) {
            el.textContent =
                'E = ' + E.toFixed(3) + ' J, ' +
                'KE = ' + KE.toFixed(3) + ' J, ' +
                'PE = ' + PE.toFixed(3) + ' J';
        }
        return { m: m, k: k, A: A, x: x, E: E, KE: KE, PE: PE };
    }

    function calcSystems() {
        var m = parseFloat(document.getElementById('sys-m').value) || 0;
        var k = parseFloat(document.getElementById('sys-k').value) || 0;
        var L = parseFloat(document.getElementById('sys-L').value) || 0;
        var g = parseFloat(document.getElementById('sys-g').value) || 9.8;
        var T_spring = (m > 0 && k > 0) ? 2 * Math.PI * Math.sqrt(m / k) : 0;
        var T_pend = (L > 0 && g > 0) ? 2 * Math.PI * Math.sqrt(L / g) : 0;
        var el = document.getElementById('shm-systems-result');
        if (el) {
            el.textContent =
                'T_spring = ' + T_spring.toFixed(3) + ' s, ' +
                'T_pendulum = ' + T_pend.toFixed(3) + ' s';
        }
        return { m: m, k: k, L: L, g: g, T_spring: T_spring, T_pendulum: T_pend };
    }

    function buildStepsBasics(v) {
        var steps = [];
        steps.push({
            title: 'Write SHM equation',
            formula: 'x(t) = A sin(ωt + φ)',
            calc: 'x(t) = ' + v.A + ' · sin(' + v.omega + '·' + v.t + ' + ' + v.phi + ')'
        });
        steps.push({
            title: 'Compute argument',
            formula: 'θ = ωt + φ',
            calc: 'θ = ' + v.omega + '·' + v.t + ' + ' + v.phi + ' = ' + (v.omega * v.t + v.phi).toFixed(4) + ' rad'
        });
        steps.push({
            title: 'Displacement, velocity, acceleration',
            formula: 'x = A sin θ,  v = Aω cos θ,  a = −ω²x',
            calc: 'x = ' + v.x.toFixed(4) + ' m,  v = ' + v.v.toFixed(4) + ' m/s,  a = ' + v.a.toFixed(4) + ' m/s²'
        });
        return steps;
    }

    function buildStepsEnergy(v) {
        var steps = [];
        steps.push({
            title: 'Total energy in SHM',
            formula: 'E = ½kA²',
            calc: 'E = ½ · ' + v.k + ' · ' + v.A + '² = ' + v.E.toFixed(3) + ' J'
        });
        steps.push({
            title: 'Potential energy at position x',
            formula: 'PE = ½kx²',
            calc: 'PE = ½ · ' + v.k + ' · ' + v.x + '² = ' + v.PE.toFixed(3) + ' J'
        });
        steps.push({
            title: 'Kinetic energy',
            formula: 'KE = E − PE',
            calc: 'KE = ' + v.E.toFixed(3) + ' − ' + v.PE.toFixed(3) + ' = ' + v.KE.toFixed(3) + ' J'
        });
        return steps;
    }

    function buildStepsSystems(v) {
        var steps = [];
        if (v.m > 0 && v.k > 0) {
            steps.push({
                title: 'Mass–spring time period',
                formula: 'T = 2π √(m/k)',
                calc: 'T_spring = 2π √(' + v.m + '/' + v.k + ') = ' + v.T_spring.toFixed(3) + ' s'
            });
        }
        if (v.L > 0 && v.g > 0) {
            steps.push({
                title: 'Simple pendulum time period (small angle)',
                formula: 'T = 2π √(L/g)',
                calc: 'T_pendulum = 2π √(' + v.L + '/' + v.g + ') = ' + v.T_pendulum.toFixed(3) + ' s'
            });
        }
        return steps;
    }

    function renderOscSteps(steps) {
        var container = document.getElementById('osc-steps-body');
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

    function calcDamped() {
        var m = parseFloat(document.getElementById('damp-m').value) || 0;
        var k = parseFloat(document.getElementById('damp-k').value) || 0;
        var b = parseFloat(document.getElementById('damp-b').value) || 0;
        var omega0 = (m > 0 && k > 0) ? Math.sqrt(k / m) : 0;
        var beta = (m > 0) ? b / (2 * m) : 0;
        var classification = 'undetermined';
        var omegaPrime = 0;
        var Tprime = 0;
        var Q = 0;
        if (omega0 > 0) {
            if (beta < omega0) {
                classification = 'under-damped';
                omegaPrime = Math.sqrt(Math.max(omega0 * omega0 - beta * beta, 0));
                Tprime = omegaPrime > 0 ? (2 * Math.PI / omegaPrime) : 0;
                Q = beta > 0 ? omega0 / (2 * beta) : Infinity;
            } else if (Math.abs(beta - omega0) < 1e-6) {
                classification = 'critically damped';
            } else {
                classification = 'over-damped';
            }
        }
        var el = document.getElementById('shm-damped-result');
        if (el) {
            if (omega0 <= 0) {
                el.textContent = 'Please enter positive m and k.';
            } else if (classification === 'under-damped') {
                el.textContent =
                    'ω₀ = ' + omega0.toFixed(3) + ' rad/s, ' +
                    'ω\' = ' + omegaPrime.toFixed(3) + ' rad/s, ' +
                    'T\' = ' + Tprime.toFixed(3) + ' s, ' +
                    'Q = ' + (Q === Infinity ? '∞' : Q.toFixed(2)) +
                    ' (' + classification + ')';
            } else {
                el.textContent =
                    'ω₀ = ' + omega0.toFixed(3) + ' rad/s, ' +
                    'β = ' + beta.toFixed(3) + ' s⁻¹ (' + classification + ')';
            }
        }
        return { m: m, k: k, b: b, omega0: omega0, beta: beta, omegaPrime: omegaPrime, Tprime: Tprime, Q: Q, classification: classification };
    }

    function calcForced() {
        var m = parseFloat(document.getElementById('force-m').value) || 0;
        var k = parseFloat(document.getElementById('force-k').value) || 0;
        var b = parseFloat(document.getElementById('force-b').value) || 0;
        var F0 = parseFloat(document.getElementById('force-F0').value) || 0;
        var omegaD = parseFloat(document.getElementById('force-omega-d').value) || 0;
        var omega0 = (m > 0 && k > 0) ? Math.sqrt(k / m) : 0;
        var beta = (m > 0) ? b / (2 * m) : 0;
        var A = 0;
        if (m > 0 && omega0 > 0 && omegaD > 0) {
            var num = F0 / m;
            var denom = Math.sqrt(
                Math.pow(omega0 * omega0 - omegaD * omegaD, 2) +
                Math.pow(2 * beta * omegaD, 2)
            );
            if (denom > 0) {
                A = num / denom;
            }
        }
        var nearRes = (omega0 > 0 && omegaD > 0) ? (Math.abs(omegaD - omega0) / omega0 < 0.05) : false;
        var el = document.getElementById('shm-forced-result');
        if (el) {
            if (m <= 0 || k <= 0 || omegaD <= 0) {
                el.textContent = 'Please enter positive m, k and ω_d.';
            } else {
                var fD = omegaD / (2 * Math.PI);
                el.textContent =
                    'A_ss ≈ ' + A.toFixed(4) + ' m (ω₀ = ' + omega0.toFixed(3) +
                    ' rad/s, ω_d = ' + omegaD.toFixed(3) + ' rad/s, f_d ≈ ' + fD.toFixed(2) + ' Hz' +
                    (nearRes ? ', near resonance)' : ')');
            }
        }
        return { m: m, k: k, b: b, F0: F0, omegaD: omegaD, omega0: omega0, beta: beta, A: A, nearRes: nearRes };
    }

    function buildStepsDamped(v) {
        var steps = [];
        if (v.omega0 <= 0) {
            steps.push({
                title: 'Check parameters',
                formula: 'ω₀ = √(k/m)',
                calc: 'Need m > 0 and k > 0.'
            });
            return steps;
        }
        steps.push({
            title: 'Natural frequency',
            formula: 'ω₀ = √(k/m)',
            calc: 'ω₀ = √(' + v.k + '/' + v.m + ') = ' + v.omega0.toFixed(3) + ' rad/s'
        });
        steps.push({
            title: 'Damping constant',
            formula: 'β = b / (2m)',
            calc: 'β = ' + v.b + '/(2×' + v.m + ') = ' + v.beta.toFixed(3) + ' s⁻¹'
        });
        if (v.classification === 'under-damped') {
            steps.push({
                title: 'Damped frequency',
                formula: 'ω\' = √(ω₀² − β²)',
                calc: 'ω\' = √(' + v.omega0.toFixed(3) + '² − ' + v.beta.toFixed(3) + '²) ≈ ' + v.omegaPrime.toFixed(3) + ' rad/s'
            });
            steps.push({
                title: 'Damped period & quality factor',
                formula: 'T\' = 2π / ω\',  Q = ω₀ / (2β)',
                calc: 'T\' ≈ ' + v.Tprime.toFixed(3) + ' s,  Q ≈ ' + (v.Q === Infinity ? '∞' : v.Q.toFixed(2))
            });
        } else {
            steps.push({
                title: 'Damping regime',
                formula: 'Compare β with ω₀',
                calc: 'β ' + (v.beta > v.omega0 ? '>' : '≈') + ' ω₀ → ' + v.classification
            });
        }
        return steps;
    }

    function buildStepsForced(v) {
        var steps = [];
        if (v.omega0 <= 0 || v.omegaD <= 0) {
            steps.push({
                title: 'Check parameters',
                formula: 'ω₀ = √(k/m),  A = (F₀/m) / √((ω₀² − ω_d²)² + (2βω_d)²)',
                calc: 'Need m > 0, k > 0, ω_d > 0.'
            });
            return steps;
        }
        steps.push({
            title: 'Natural & driving frequencies',
            formula: 'ω₀ = √(k/m),  ω_d = driving frequency',
            calc: 'ω₀ = ' + v.omega0.toFixed(3) + ' rad/s,  ω_d = ' + v.omegaD.toFixed(3) + ' rad/s'
        });
        steps.push({
            title: 'Damping constant',
            formula: 'β = b / (2m)',
            calc: 'β = ' + v.b + '/(2×' + v.m + ') = ' + v.beta.toFixed(3) + ' s⁻¹'
        });
        steps.push({
            title: 'Steady-state amplitude',
            formula: 'A = (F₀/m) / √((ω₀² − ω_d²)² + (2βω_d)²)',
            calc: 'A_ss ≈ ' + v.A.toFixed(4) + ' m'
        });
        steps.push({
            title: 'Resonance check',
            formula: 'Resonance when ω_d ≈ ω₀ (light damping)',
            calc: v.nearRes ? 'ω_d is close to ω₀ → near resonance.' : 'ω_d is not very close to ω₀.'
        });
        return steps;
    }

    function initShmMatter() {
        if (typeof Matter === 'undefined') return;
        if (matterEngine) return;
        var Engine = Matter.Engine;
        var Render = Matter.Render;
        var World = Matter.World;
        var Bodies = Matter.Bodies;
        var Runner = Matter.Runner;

        var canvas = document.getElementById('shm-viz-canvas');
        if (!canvas) return;

        matterEngine = Engine.create();
        matterEngine.world.gravity.y = 0;

        var w = canvas.clientWidth || 600;
        var h = canvas.clientHeight || 260;

        matterRender = Render.create({
            canvas: canvas,
            engine: matterEngine,
            options: {
                width: w,
                height: h,
                wireframes: false,
                background: 'transparent',
                pixelRatio: 1
            }
        });

        var wall = Bodies.rectangle(40, h / 2, 20, 120, {
            isStatic: true,
            render: { fillStyle: '#0f172a' }
        });
        shmMass = Bodies.rectangle(200, h / 2, 60, 40, {
            render: { fillStyle: '#6366f1' }
        });
        shmAnchor = Bodies.circle(80, h / 2, 4, {
            isStatic: true,
            render: { fillStyle: '#111827' }
        });

        shmSpring = Matter.Constraint.create({
            bodyA: shmAnchor,
            bodyB: shmMass,
            stiffness: 0.02,
            damping: 0.02,
            render: { strokeStyle: '#ec4899', lineWidth: 3 }
        });

        World.add(matterEngine.world, [wall, shmAnchor, shmMass, shmSpring]);

        matterRunner = Runner.create();
        Runner.run(matterRunner, matterEngine);
        Render.run(matterRender);
    }

    function updateShmViz(v) {
        if (!matterEngine || !shmMass || typeof Matter === 'undefined') return;
        var Body = Matter.Body;
        var A = Math.abs(v.A || 0);
        var omega = v.omega || 0;
        var phi = v.phi || 0;
        var now = performance && performance.now ? performance.now() / 1000 : 0;
        var t = now % (omega > 0 ? (2 * Math.PI / omega) : 1);
        var xNorm = Math.sin(omega * t + phi); // -1 .. 1
        var baseX = 200;
        var ampPx = Math.min(80, 40 + A * 200);
        var targetX = baseX + ampPx * xNorm;
        Body.setPosition(shmMass, { x: targetX, y: shmMass.position.y });

        var pills = document.getElementById('shm-viz-pills');
        if (pills) {
            pills.innerHTML =
                '<div class="shm-viz-pill">A = ' + A.toFixed(2) + ' m</div>' +
                (omega > 0 ? '<div class="shm-viz-pill">ω = ' + omega.toFixed(2) + ' rad/s</div>' : '');
        }
    }

    function updateShmChartBasics(v) {
        var canvas = document.getElementById('shm-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        var labels = [];
        var xs = [];
        var vs = [];
        var as = [];
        var omega = v.omega || 0;
        var A = v.A || 0;
        var phi = v.phi || 0;
        if (omega <= 0 || A === 0) {
            if (shmChart) {
                shmChart.destroy();
                shmChart = null;
            }
            return;
        }
        var T = 2 * Math.PI / omega;
        var maxT = 2 * T;
        var steps = 80;
        for (var i = 0; i <= steps; i++) {
            var t = (maxT * i) / steps;
            var arg = omega * t + phi;
            var x = A * Math.sin(arg);
            var vel = A * omega * Math.cos(arg);
            var acc = -omega * omega * x;
            labels.push(t.toFixed(2));
            xs.push(x);
            vs.push(vel);
            as.push(acc);
        }
        if (shmChart) {
            shmChart.destroy();
        }
        shmChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'x(t) (m)',
                        data: xs,
                        borderColor: '#6366f1',
                        backgroundColor: 'transparent',
                        borderWidth: 2,
                        pointRadius: 0
                    },
                    {
                        label: 'v(t) (m/s)',
                        data: vs,
                        borderColor: '#22c55e',
                        backgroundColor: 'transparent',
                        borderWidth: 1,
                        pointRadius: 0
                    },
                    {
                        label: 'a(t) (m/s²)',
                        data: as,
                        borderColor: '#ec4899',
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
                    title: { display: true, text: 'SHM: x(t), v(t), a(t)' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 't (s)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'Value' }
                    }
                }
            }
        });
        updateShmViz(v);
    }

    function updateDampedChart(v) {
        var canvas = document.getElementById('shm-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (v.omega0 <= 0 || v.classification !== 'under-damped') {
            if (shmChart) {
                shmChart.destroy();
                shmChart = null;
            }
            return;
        }
        var labels = [];
        var undamped = [];
        var damped = [];
        var A = 1;
        var T0 = 2 * Math.PI / v.omega0;
        var maxT = 5 * T0;
        var steps = 100;
        for (var i = 0; i <= steps; i++) {
            var t = (maxT * i) / steps;
            var x0 = A * Math.sin(v.omega0 * t);
            var xd = A * Math.exp(-v.beta * t) * Math.sin(v.omegaPrime * t);
            labels.push(t.toFixed(2));
            undamped.push(x0);
            damped.push(xd);
        }
        if (shmChart) shmChart.destroy();
        shmChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Undamped x(t)',
                        data: undamped,
                        borderColor: '#6366f1',
                        backgroundColor: 'transparent',
                        borderWidth: 1,
                        pointRadius: 0
                    },
                    {
                        label: 'Damped x(t)',
                        data: damped,
                        borderColor: '#ec4899',
                        backgroundColor: 'rgba(236,72,153,0.08)',
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
                    title: { display: true, text: 'Damped vs undamped SHM (A = 1)' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 't (s)' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'x (arbitrary units)' }
                    }
                }
            }
        });
    }

    function updateForcedChart(v) {
        var canvas = document.getElementById('shm-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') return;
        if (v.omega0 <= 0 || v.m <= 0) {
            if (shmChart) {
                shmChart.destroy();
                shmChart = null;
            }
            return;
        }
        var labels = [];
        var amps = [];
        var Auser = v.A;
        var labelsUser = [];
        var ampsUser = [];
        var beta = v.beta;
        var omega0 = v.omega0;
        var F0 = v.F0;
        var m = v.m;
        var omegaMin = 0.2 * omega0;
        var omegaMax = 1.8 * omega0;
        var steps = 120;
        for (var i = 0; i <= steps; i++) {
            var omegaD = omegaMin + (omegaMax - omegaMin) * (i / steps);
            var num = F0 / m;
            var denom = Math.sqrt(
                Math.pow(omega0 * omega0 - omegaD * omegaD, 2) +
                Math.pow(2 * beta * omegaD, 2)
            );
            var A = denom > 0 ? num / denom : 0;
            labels.push((omegaD / omega0).toFixed(2));
            amps.push(A);
        }
        if (v.omegaD > 0) {
            labelsUser.push((v.omegaD / omega0).toFixed(2));
            ampsUser.push(Auser);
        }
        if (shmChart) shmChart.destroy();
        shmChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'A(ω_d)',
                        data: amps,
                        borderColor: '#22c55e',
                        backgroundColor: 'rgba(34,197,94,0.08)',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: true
                    },
                    {
                        label: 'Your ω_d',
                        data: ampsUser,
                        borderColor: '#ef4444',
                        backgroundColor: '#ef4444',
                        borderWidth: 0,
                        pointRadius: 4,
                        showLine: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true },
                    title: { display: true, text: 'Driven SHM: amplitude vs ω_d/ω₀' }
                },
                scales: {
                    x: {
                        title: { display: true, text: 'ω_d / ω₀' },
                        ticks: { maxTicksLimit: 8 }
                    },
                    y: {
                        title: { display: true, text: 'Steady-state amplitude (m)' }
                    }
                }
            }
        });
    }

    function setVizVisible(mode) {
        var panel = document.querySelector('.simulation-panel');
        var viz = document.getElementById('shm-viz-container');
        var chartWrap = document.getElementById('shm-chart-canvas') && document.getElementById('shm-chart-canvas').parentElement;
        if (mode === 'basics') {
            if (panel) panel.style.display = '';
            if (viz) viz.style.display = '';
            if (chartWrap) chartWrap.style.display = '';
        } else if (mode === 'chart') {
            if (panel) panel.style.display = '';
            if (viz) viz.style.display = 'none';
            if (chartWrap) chartWrap.style.display = '';
        } else {
            if (panel) panel.style.display = 'none';
        }
    }

    function runOscillations() {
        var active = document.querySelector('.shm-tab.active');
        var tab = active ? active.getAttribute('data-tab') : 'basics';
        var vals, steps;
        if (tab === 'basics') {
            setVizVisible('basics');
            vals = calcBasics();
            steps = buildStepsBasics(vals);
            renderOscSteps(steps);
            updateShmChartBasics(vals);
        } else if (tab === 'energy') {
            setVizVisible('none');
            vals = calcEnergy();
            steps = buildStepsEnergy(vals);
            renderOscSteps(steps);
        } else if (tab === 'systems') {
            setVizVisible('none');
            vals = calcSystems();
            steps = buildStepsSystems(vals);
            renderOscSteps(steps);
        } else if (tab === 'damped') {
            setVizVisible('chart');
            vals = calcDamped();
            steps = buildStepsDamped(vals);
            renderOscSteps(steps);
            updateDampedChart(vals);
        } else if (tab === 'forced') {
            setVizVisible('chart');
            vals = calcForced();
            steps = buildStepsForced(vals);
            renderOscSteps(steps);
            updateForcedChart(vals);
        }
    }

    function toggleOscSteps() {
        var body = document.getElementById('osc-steps-body');
        var toggle = document.getElementById('osc-steps-toggle');
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

    window.runOscillations = runOscillations;
    window.toggleOscSteps = toggleOscSteps;

    document.addEventListener('DOMContentLoaded', function () {
        initShmMatter();
        initTabs();
        var v = calcBasics();
        if (v) {
            renderOscSteps(buildStepsBasics(v));
            updateShmChartBasics(v);
        }
        setVizVisible('basics');
    });
})();