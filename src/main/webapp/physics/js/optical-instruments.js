/**
 * Optical Instruments - simple/compound microscope, astronomical/Galilean telescope, resolving power
 */
(function () {
    'use strict';

    var D_default = 25; // least distance of distinct vision, cm

    function getActiveTab() {
        var t = document.querySelector('.optinst-tab.active');
        return t ? t.getAttribute('data-tab') : 'simple';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && x !== 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesSimple() {
        var D = parseFloat(document.getElementById('optinst-D').value) || D_default;
        var f = parseFloat(document.getElementById('optinst-f-simple').value);
        var mode = (document.querySelector('.optinst-mode-simple:checked') || {}).value || 'normal';
        if (isNaN(f) || f <= 0) return { D: D, f: f, m: NaN, mode: mode };
        var m = mode === 'normal' ? 1 + D / f : D / f;
        return { D: D, f: f, m: m, mode: mode };
    }

    function getValuesCompound() {
        var L = parseFloat(document.getElementById('optinst-L').value);
        var fo = parseFloat(document.getElementById('optinst-fo').value);
        var fe = parseFloat(document.getElementById('optinst-fe').value);
        var D = parseFloat(document.getElementById('optinst-D-comp').value) || D_default;
        if (isNaN(L) || isNaN(fo) || isNaN(fe) || fo <= 0 || fe <= 0) return { L: L, fo: fo, fe: fe, D: D, mo: NaN, me: NaN, m: NaN };
        var mo = L / fo;
        var me = 1 + D / fe;
        var m = mo * me;
        return { L: L, fo: fo, fe: fe, D: D, mo: mo, me: me, m: m };
    }

    function getValuesAstronomical() {
        var fo = parseFloat(document.getElementById('optinst-fo-ast').value);
        var fe = parseFloat(document.getElementById('optinst-fe-ast').value);
        if (isNaN(fo) || isNaN(fe) || fe <= 0) return { fo: fo, fe: fe, m: NaN };
        var m = fo / fe;
        return { fo: fo, fe: fe, m: m };
    }

    function getValuesGalilean() {
        var fo = parseFloat(document.getElementById('optinst-fo-gal').value);
        var fe = parseFloat(document.getElementById('optinst-fe-gal').value);
        if (isNaN(fo) || isNaN(fe) || fe <= 0) return { fo: fo, fe: fe, m: NaN };
        var m = fo / Math.abs(fe);
        return { fo: fo, fe: fe, m: m };
    }

    function getValuesRPTelescope() {
        var D = parseFloat(document.getElementById('optinst-D-rp').value);
        var DUnit = document.getElementById('optinst-D-unit-rp').value || 'm';
        var lambda = parseFloat(document.getElementById('optinst-lambda-rp').value);
        var lambdaUnit = document.getElementById('optinst-lambda-unit-rp').value || 'nm';
        var Dm = D * (DUnit === 'cm' ? 0.01 : 1);
        var lambdaM = lambda * (lambdaUnit === 'nm' ? 1e-9 : lambdaUnit === 'Å' ? 1e-10 : 1);
        if (isNaN(D) || isNaN(lambda) || D <= 0 || lambdaM <= 0) return { D: D, Dm: Dm, lambda: lambdaM, RP: NaN };
        var RP = Dm / (1.22 * lambdaM);
        return { D: D, Dm: Dm, lambda: lambdaM, RP: RP };
    }

    function getValuesRPMicroscope() {
        var n = parseFloat(document.getElementById('optinst-n-rp').value);
        var thetaDeg = parseFloat(document.getElementById('optinst-theta-rp').value);
        var lambda = parseFloat(document.getElementById('optinst-lambda-mic').value);
        var lambdaUnit = document.getElementById('optinst-lambda-unit-mic').value || 'nm';
        var lambdaM = lambda * (lambdaUnit === 'nm' ? 1e-9 : lambdaUnit === 'Å' ? 1e-10 : 1);
        if (isNaN(n) || isNaN(thetaDeg) || isNaN(lambda) || lambdaM <= 0) return { n: n, theta: thetaDeg * Math.PI / 180, lambda: lambdaM, thetaDeg: thetaDeg, RP: NaN };
        var theta = thetaDeg * Math.PI / 180;
        var RP = (2 * n * Math.sin(theta)) / lambdaM;
        return { n: n, theta: theta, thetaDeg: thetaDeg, lambda: lambdaM, RP: RP };
    }

    function buildStepsSimple(data) {
        var formula = data.mode === 'normal' ? 'm = 1 + D/f' : 'm = D/f (image at ∞)';
        var calc = data.mode === 'normal' ? 'm = 1 + ' + formatNum(data.D) + '/' + formatNum(data.f) + ' = ' + formatNum(data.m) : 'm = ' + formatNum(data.D) + '/' + formatNum(data.f) + ' = ' + formatNum(data.m);
        return [{ title: 'Simple microscope', formula: formula, calc: calc }];
    }

    function buildStepsCompound(data) {
        return [
            { title: 'Objective magnification', formula: 'm_o = L / f_o', calc: 'm_o = ' + formatNum(data.L) + ' / ' + formatNum(data.fo) + ' = ' + formatNum(data.mo) },
            { title: 'Eyepiece magnification', formula: 'm_e = 1 + D/f_e', calc: 'm_e = 1 + ' + formatNum(data.D) + '/' + formatNum(data.fe) + ' = ' + formatNum(data.me) },
            { title: 'Total magnification', formula: 'm = m_o × m_e', calc: 'm = ' + formatNum(data.mo) + ' × ' + formatNum(data.me) + ' = ' + formatNum(data.m) }
        ];
    }

    function buildStepsAstronomical(data) {
        return [{ title: 'Astronomical telescope', formula: 'm = f_o / f_e', calc: 'm = ' + formatNum(data.fo) + ' / ' + formatNum(data.fe) + ' = ' + formatNum(data.m) }];
    }

    function buildStepsGalilean(data) {
        return [{ title: 'Galilean telescope', formula: 'm = f_o / |f_e|', calc: 'm = ' + formatNum(data.fo) + ' / ' + formatNum(Math.abs(data.fe)) + ' = ' + formatNum(data.m) }];
    }

    function buildStepsRPTelescope(data) {
        return [{ title: 'Resolving power (telescope)', formula: 'RP = D / (1.22 λ)', calc: 'RP = ' + formatNum(data.Dm) + ' m / (1.22 × ' + formatNum(data.lambda) + ' m) = ' + formatNum(data.RP) }];
    }

    function buildStepsRPMicroscope(data) {
        return [{ title: 'Resolving power (microscope)', formula: 'RP = 2n sin θ / λ', calc: 'RP = 2×' + formatNum(data.n) + '×sin(' + formatNum(data.thetaDeg) + '°) / λ = ' + formatNum(data.RP) }];
    }

    function renderSteps(steps) {
        var container = document.getElementById('optinst-steps-body');
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

    function runOptInstruments() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'simple') {
            data = getValuesSimple();
            resultEl = document.getElementById('optinst-simple-result');
            resultText = isNaN(data.m) ? '—' : 'm = ' + formatNum(data.m, 3);
            steps = buildStepsSimple(data);
        } else if (tab === 'compound') {
            data = getValuesCompound();
            resultEl = document.getElementById('optinst-compound-result');
            resultText = isNaN(data.m) ? '—' : 'm = ' + formatNum(data.m, 2);
            steps = buildStepsCompound(data);
        } else if (tab === 'astronomical') {
            data = getValuesAstronomical();
            resultEl = document.getElementById('optinst-astronomical-result');
            resultText = isNaN(data.m) ? '—' : 'm = ' + formatNum(data.m, 2);
            steps = buildStepsAstronomical(data);
        } else if (tab === 'galilean') {
            data = getValuesGalilean();
            resultEl = document.getElementById('optinst-galilean-result');
            resultText = isNaN(data.m) ? '—' : 'm = ' + formatNum(data.m, 2);
            steps = buildStepsGalilean(data);
        } else if (tab === 'rp-telescope') {
            data = getValuesRPTelescope();
            resultEl = document.getElementById('optinst-rp-telescope-result');
            resultText = isNaN(data.RP) ? '—' : 'RP = ' + formatNum(data.RP, 2);
            steps = buildStepsRPTelescope(data);
        } else if (tab === 'rp-microscope') {
            data = getValuesRPMicroscope();
            resultEl = document.getElementById('optinst-rp-microscope-result');
            resultText = isNaN(data.RP) ? '—' : 'RP = ' + formatNum(data.RP, 2);
            steps = buildStepsRPMicroscope(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps || []);
    }

    function switchOptInstTab(tabId, btn) {
        document.querySelectorAll('.optinst-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.optinst-panel').forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.optinst-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-optinst-' + tabId);
        if (panel) panel.classList.add('active');
        runOptInstruments();
    }

    function toggleOptInstSteps() {
        var body = document.getElementById('optinst-steps-body');
        var toggle = document.getElementById('optinst-steps-toggle');
        if (body && toggle) {
            body.classList.toggle('collapsed');
            toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        runOptInstruments();
        document.querySelectorAll('.optinst-number-input').forEach(function (inp) { inp.addEventListener('input', runOptInstruments); });
        document.querySelectorAll('.optinst-unit-select').forEach(function (sel) { sel.addEventListener('change', runOptInstruments); });
        document.querySelectorAll('.optinst-mode-simple').forEach(function (r) { r.addEventListener('change', runOptInstruments); });
    });

    window.runOptInstruments = runOptInstruments;
    window.switchOptInstTab = switchOptInstTab;
    window.toggleOptInstSteps = toggleOptInstSteps;
})();
