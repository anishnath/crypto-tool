/**
 * Photoelectric Effect - K_max, V0, work function, photon energy, cut-off wavelength, de Broglie
 * hν = φ + K_max, K_max = e V0, φ = h ν0 = hc/λ0, E = hν = hc/λ, λ0(A) = 12400/φ(eV), λ = h/√(2m K_max)
 */
(function () {
    'use strict';

    var h = 6.626e-34;   // J·s
    var c = 2.998e8;     // m/s
    var e = 1.602e-19;   // C
    var m_e = 9.109e-31; // kg
    var hc_eV_nm = 1240; // hc in eV·nm (approx)
    var hc_eV_Ang = 12400; // hc in eV·Å

    var freqToHz = { 'Hz': 1, 'THz': 1e12 };
    var lambdaToM = { 'nm': 1e-9, 'Ang': 1e-10, 'm': 1 };

    function evToJ(x) { return x * e; }
    function jToEv(x) { return x / e; }

    function getActiveTab() {
        var t = document.querySelector('.photo-tab.active');
        return t ? t.getAttribute('data-tab') : 'kmax';
    }

    function formatNum(x, decimals) {
        if (x === 0) return '0';
        decimals = decimals === undefined ? 3 : decimals;
        if (Math.abs(x) >= 1e6) return x.toExponential(2);
        if (Math.abs(x) < 0.0001 && x !== 0) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function getValuesKmax() {
        var nuRaw = parseFloat(document.getElementById('kmax-nu').value) || 0;
        var nuUnit = document.getElementById('kmax-nu-unit').value;
        var phiRaw = parseFloat(document.getElementById('kmax-phi').value) || 0;
        var phiUnit = document.getElementById('kmax-phi-unit').value;
        var nu = nuRaw * (freqToHz[nuUnit] || 1);
        var phi_J = phiUnit === 'eV' ? evToJ(phiRaw) : phiRaw;
        var E_photon_J = h * nu;
        var K_max_J = Math.max(0, E_photon_J - phi_J);
        var K_max_eV = jToEv(K_max_J);
        return { nu: nu, nuRaw: nuRaw, nuUnit: nuUnit, phiRaw: phiRaw, phiUnit: phiUnit, phi_J: phi_J, E_photon_J: E_photon_J, K_max_J: K_max_J, K_max_eV: K_max_eV };
    }

    function getValuesV0() {
        var kmaxRaw = parseFloat(document.getElementById('v0-kmax').value) || 0;
        var kmaxUnit = document.getElementById('v0-kmax-unit').value;
        var K_max_J = kmaxUnit === 'eV' ? evToJ(kmaxRaw) : kmaxRaw;
        var V0 = K_max_J / e;
        return { kmaxRaw: kmaxRaw, kmaxUnit: kmaxUnit, K_max_J: K_max_J, V0: V0 };
    }

    function getValuesWorkfn() {
        var from = document.getElementById('workfn-from').value;
        var phi_J, nu0, lambda0_m, phi_eV;
        if (from === 'nu0') {
            var nu0Raw = parseFloat(document.getElementById('workfn-nu0').value) || 0;
            var nu0Unit = document.getElementById('workfn-nu0-unit').value;
            nu0 = nu0Raw * (freqToHz[nu0Unit] || 1);
            phi_J = h * nu0;
            lambda0_m = c / nu0;
        } else {
            var lamRaw = parseFloat(document.getElementById('workfn-lambda0').value) || 0;
            var lamUnit = document.getElementById('workfn-lambda0-unit').value;
            lambda0_m = lamRaw * (lambdaToM[lamUnit] || 1e-9);
            nu0 = c / lambda0_m;
            phi_J = h * c / lambda0_m;
        }
        phi_eV = jToEv(phi_J);
        return { from: from, nu0: nu0, lambda0_m: lambda0_m, phi_J: phi_J, phi_eV: phi_eV };
    }

    function getValuesPhoton() {
        var inputType = document.getElementById('photon-input-type').value;
        var E_J, nu, lambda_m;
        if (inputType === 'nu') {
            var nuRaw = parseFloat(document.getElementById('photon-nu').value) || 0;
            var nuUnit = document.getElementById('photon-nu-unit').value;
            nu = nuRaw * (freqToHz[nuUnit] || 1);
            E_J = h * nu;
            lambda_m = c / nu;
        } else {
            var lamRaw = parseFloat(document.getElementById('photon-lambda').value) || 0;
            var lamUnit = document.getElementById('photon-lambda-unit').value;
            lambda_m = lamRaw * (lambdaToM[lamUnit] || 1e-9);
            nu = c / lambda_m;
            E_J = h * c / lambda_m;
        }
        var E_eV = jToEv(E_J);
        return { inputType: inputType, nu: nu, lambda_m: lambda_m, E_J: E_J, E_eV: E_eV };
    }

    function getValuesCutoff() {
        var phi_eV = parseFloat(document.getElementById('cutoff-phi').value) || 0;
        if (phi_eV <= 0) return { phi_eV: 0, lambda0_Ang: Infinity };
        var lambda0_Ang = hc_eV_Ang / phi_eV;
        return { phi_eV: phi_eV, lambda0_Ang: lambda0_Ang };
    }

    function getValuesDebrog() {
        var kmaxRaw = parseFloat(document.getElementById('debrog-kmax').value) || 0;
        var kmaxUnit = document.getElementById('debrog-kmax-unit').value;
        var K_max_J = kmaxUnit === 'eV' ? evToJ(kmaxRaw) : kmaxRaw;
        if (K_max_J <= 0) return { K_max_J: 0, lambda_m: Infinity, lambda_Ang: Infinity };
        var lambda_m = h / Math.sqrt(2 * m_e * K_max_J);
        var lambda_Ang = lambda_m * 1e10;
        return { kmaxRaw: kmaxRaw, kmaxUnit: kmaxUnit, K_max_J: K_max_J, lambda_m: lambda_m, lambda_Ang: lambda_Ang };
    }

    function buildStepsKmax(data) {
        var steps = [];
        steps.push({ title: 'Photon energy', formula: 'E = h ν', calc: 'E = (6.626×10⁻³⁴) × ' + formatNum(data.nu) + ' = ' + formatNum(data.E_photon_J) + ' J = ' + formatNum(jToEv(data.E_photon_J)) + ' eV' });
        steps.push({ title: 'Work function in J', formula: 'φ = ' + (data.phiUnit === 'eV' ? data.phiRaw + ' eV' : data.phiRaw + ' J'), calc: 'φ = ' + formatNum(data.phi_J) + ' J' });
        steps.push({ title: 'K_max (Einstein)', formula: 'K_max = hν − φ', calc: 'K_max = ' + formatNum(data.E_photon_J) + ' − ' + formatNum(data.phi_J) + ' = ' + formatNum(data.K_max_J) + ' J = ' + formatNum(data.K_max_eV) + ' eV' });
        return steps;
    }

    function buildStepsV0(data) {
        var steps = [];
        steps.push({ title: 'Stopping potential', formula: 'K_max = e V₀ ⇒ V₀ = K_max / e', calc: 'V₀ = ' + formatNum(data.K_max_J) + ' / (1.602×10⁻¹⁹) = ' + formatNum(data.V0) + ' V' });
        return steps;
    }

    function buildStepsWorkfn(data) {
        var steps = [];
        if (data.from === 'nu0') {
            steps.push({ title: 'Work function from ν₀', formula: 'φ = h ν₀', calc: 'φ = (6.626×10⁻³⁴) × ' + formatNum(data.nu0) + ' = ' + formatNum(data.phi_J) + ' J = ' + formatNum(data.phi_eV) + ' eV' });
        } else {
            steps.push({ title: 'Work function from λ₀', formula: 'φ = hc / λ₀', calc: 'φ = hc / ' + formatNum(data.lambda0_m) + ' = ' + formatNum(data.phi_J) + ' J = ' + formatNum(data.phi_eV) + ' eV' });
        }
        return steps;
    }

    function buildStepsPhoton(data) {
        var steps = [];
        if (data.inputType === 'nu') {
            steps.push({ title: 'Photon energy', formula: 'E = h ν', calc: 'E = (6.626×10⁻³⁴) × ' + formatNum(data.nu) + ' = ' + formatNum(data.E_J) + ' J = ' + formatNum(data.E_eV) + ' eV' });
        } else {
            steps.push({ title: 'Photon energy', formula: 'E = hc / λ', calc: 'E = hc / ' + formatNum(data.lambda_m) + ' = ' + formatNum(data.E_J) + ' J = ' + formatNum(data.E_eV) + ' eV' });
        }
        return steps;
    }

    function buildStepsCutoff(data) {
        var steps = [];
        steps.push({ title: 'Cut-off wavelength', formula: 'λ₀ (Å) = 12400 / φ (eV)', calc: 'λ₀ = 12400 / ' + formatNum(data.phi_eV) + ' = ' + formatNum(data.lambda0_Ang) + ' Å' });
        return steps;
    }

    function buildStepsDebrog(data) {
        var steps = [];
        steps.push({ title: 'de Broglie wavelength', formula: 'λ = h / √(2m K_max)', calc: 'λ = (6.626×10⁻³⁴) / √(2 × 9.109×10⁻³¹ × ' + formatNum(data.K_max_J) + ') = ' + formatNum(data.lambda_m) + ' m = ' + formatNum(data.lambda_Ang) + ' Å' });
        return steps;
    }

    function renderSteps(steps) {
        var container = document.getElementById('photo-steps-body');
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
        var placeholder = document.getElementById('photo-viz-placeholder');
        if (!placeholder) return;
        var html = '';
        if (tab === 'kmax' && data && data.K_max_eV != null) {
            html = '<div style="padding:1rem;">' +
                '<div style="margin-bottom:0.5rem;"><strong>Photon energy</strong> (hν) → <span class="highlight">' + formatNum(jToEv(data.E_photon_J)) + ' eV</span></div>' +
                '<div style="margin-bottom:0.5rem;"><strong>Work function</strong> (φ) → ' + formatNum(data.phiRaw) + ' ' + data.phiUnit + '</div>' +
                '<div style="margin-bottom:0.5rem;"><strong>K_max</strong> = hν − φ → <span class="highlight">' + formatNum(data.K_max_eV) + ' eV</span></div>' +
                '</div>';
        } else if (tab === 'photon' && data && data.E_eV != null) {
            html = '<div style="padding:1rem;"><strong>Photon energy</strong> E = hν = hc/λ → <span class="highlight">' + formatNum(data.E_eV) + ' eV</span></div>';
        } else if (tab === 'cutoff' && data && data.lambda0_Ang != null) {
            html = '<div style="padding:1rem;">φ = ' + formatNum(data.phi_eV) + ' eV ⇒ <strong>λ₀</strong> = 12400/φ = <span class="highlight">' + formatNum(data.lambda0_Ang) + ' Å</span></div>';
        } else if (tab === 'debrog' && data && data.lambda_Ang != null) {
            html = '<div style="padding:1rem;">K_max → <strong>λ</strong> = h/√(2m K_max) = <span class="highlight">' + formatNum(data.lambda_Ang) + ' Å</span> (electron)</div>';
        } else {
            html = 'Run a calculation to see energy levels.';
        }
        placeholder.innerHTML = html;
    }

    function runPhotoelectric() {
        var tab = getActiveTab();
        var data = null;
        var steps = [];
        var resultEl = null;
        var resultText = '';

        if (tab === 'kmax') {
            data = getValuesKmax();
            resultEl = document.getElementById('kmax-result');
            resultText = formatNum(data.K_max_eV) + ' eV';
            if (data.K_max_eV <= 0) resultText = '0 (no emission)';
            steps = buildStepsKmax(data);
        } else if (tab === 'v0') {
            data = getValuesV0();
            resultEl = document.getElementById('v0-result');
            resultText = formatNum(data.V0) + ' V';
            steps = buildStepsV0(data);
        } else if (tab === 'workfn') {
            data = getValuesWorkfn();
            resultEl = document.getElementById('workfn-result');
            resultText = formatNum(data.phi_eV) + ' eV';
            steps = buildStepsWorkfn(data);
        } else if (tab === 'photon') {
            data = getValuesPhoton();
            resultEl = document.getElementById('photon-result');
            resultText = formatNum(data.E_eV) + ' eV';
            steps = buildStepsPhoton(data);
        } else if (tab === 'cutoff') {
            data = getValuesCutoff();
            resultEl = document.getElementById('cutoff-result');
            resultText = formatNum(data.lambda0_Ang) + ' Å';
            if (data.phi_eV <= 0) resultText = '—';
            steps = buildStepsCutoff(data);
        } else if (tab === 'debrog') {
            data = getValuesDebrog();
            resultEl = document.getElementById('debrog-result');
            resultText = formatNum(data.lambda_Ang) + ' Å';
            if (data.K_max_J <= 0) resultText = '—';
            steps = buildStepsDebrog(data);
        }

        if (resultEl) resultEl.textContent = resultText;
        renderSteps(steps);
        drawViz(tab, data);
    }

    function switchPhotoTab(tabId, btn) {
        var tabs = document.querySelectorAll('.photo-tab');
        var panels = document.querySelectorAll('.photo-panel');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.photo-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-' + tabId);
        if (panel) panel.classList.add('active');

        if (tabId === 'workfn') {
            var from = document.getElementById('workfn-from').value;
            document.getElementById('workfn-nu-section').style.display = from === 'nu0' ? 'block' : 'none';
            document.getElementById('workfn-lambda-section').style.display = from === 'lambda0' ? 'block' : 'none';
        }
        if (tabId === 'photon') {
            var inputType = document.getElementById('photon-input-type').value;
            document.getElementById('photon-nu-section').style.display = inputType === 'nu' ? 'block' : 'none';
            document.getElementById('photon-lambda-section').style.display = inputType === 'lambda' ? 'block' : 'none';
        }
        runPhotoelectric();
    }

    function togglePhotoSteps() {
        var body = document.getElementById('photo-steps-body');
        var toggle = document.getElementById('photo-steps-toggle');
        if (!body || !toggle) return;
        body.classList.toggle('collapsed');
        toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
    }

    document.addEventListener('DOMContentLoaded', function () {
        var workfnFrom = document.getElementById('workfn-from');
        if (workfnFrom) {
            workfnFrom.addEventListener('change', function () {
                var from = this.value;
                document.getElementById('workfn-nu-section').style.display = from === 'nu0' ? 'block' : 'none';
                document.getElementById('workfn-lambda-section').style.display = from === 'lambda0' ? 'block' : 'none';
            });
        }
        var photonInputType = document.getElementById('photon-input-type');
        if (photonInputType) {
            photonInputType.addEventListener('change', function () {
                var inputType = this.value;
                document.getElementById('photon-nu-section').style.display = inputType === 'nu' ? 'block' : 'none';
                document.getElementById('photon-lambda-section').style.display = inputType === 'lambda' ? 'block' : 'none';
            });
        }
        runPhotoelectric();
    });

    window.runPhotoelectric = runPhotoelectric;
    window.switchPhotoTab = switchPhotoTab;
    window.togglePhotoSteps = togglePhotoSteps;
})();
