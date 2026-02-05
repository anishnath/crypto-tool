/**
 * Units and Measurement - SI reference, unit converter, significant figures, order of magnitude
 */
(function () {
    'use strict';

    var eV_to_J = 1.602e-19;
    var angstrom_to_m = 1e-10;
    var fermi_to_m = 1e-15;
    var atm_to_Pa = 1.01325e5;
    var mmHg_to_Pa = 133.322;
    var u_to_kg = 1.66054e-27;

    var sigFigMode = 'count';

    function getActiveTab() {
        var t = document.querySelector('.um-tab.active');
        return t ? t.getAttribute('data-tab') : 'base';
    }

    function formatNum(x, decimals) {
        if (x === undefined || x === null || isNaN(x)) return '—';
        decimals = decimals === undefined ? 4 : decimals;
        if (x === 0) return '0';
        if (Math.abs(x) >= 1e6 || (Math.abs(x) < 1e-4 && Math.abs(x) > 0)) return x.toExponential(2);
        return Number(x.toFixed(decimals)).toString();
    }

    function parseNumberInput(str) {
        if (str == null || str === '') return NaN;
        str = String(str).trim().replace(/\s/g, '').replace(/×/g, '*').replace(/x\s*10\s*\^/gi, 'e').replace(/10\^/g, 'e');
        var num = parseFloat(str);
        if (!isNaN(num)) return num;
        var m = str.match(/^([+-]?\d*\.?\d+)\s*[eE]\s*([+-]?\d+)$/);
        if (m) return parseFloat(m[1]) * Math.pow(10, parseInt(m[2], 10));
        return NaN;
    }

    function countSignificantFigures(str) {
        if (str == null || str === '') return { count: 0, parsed: NaN, explanation: 'Empty input.' };
        str = String(str).trim();
        var num = parseNumberInput(str);
        if (isNaN(num)) return { count: 0, parsed: NaN, explanation: 'Could not parse number.' };
        if (num === 0) return { count: 1, parsed: 0, explanation: 'Zero: convention 1 significant figure.' };

        str = str.replace(/\s/g, '').replace(/,/g, '.').toLowerCase();
        var hasExp = /[eE]/.test(str);
        var expPart = '';
        if (hasExp) {
            var ei = str.search(/[eE]/);
            expPart = str.slice(ei);
            str = str.slice(0, ei);
        }
        var sign = (str.charAt(0) === '+' || str.charAt(0) === '-') ? str.charAt(0) : '';
        if (sign) str = str.slice(1);
        var decimalIndex = str.indexOf('.');
        var count = 0;
        var i;
        if (decimalIndex >= 0) {
            for (i = 0; i < str.length; i++) {
                if (str[i] === '.') continue;
                if (str[i] >= '1' && str[i] <= '9') count++;
                else if (str[i] === '0' && (i < decimalIndex ? count > 0 : true)) count++;
            }
        } else {
            var leading = true;
            for (i = 0; i < str.length; i++) {
                if (str[i] >= '1' && str[i] <= '9') { count++; leading = false; }
                else if (str[i] === '0' && !leading) count++;
            }
        }
        if (count === 0) count = 1;
        var explanation = 'Non-zero digits always count; zeros between non-zero count; leading zeros do not; trailing zeros after decimal count.';
        return { count: count, parsed: num, explanation: explanation };
    }

    function roundToSignificantFigures(num, n) {
        if (isNaN(num) || n < 1) return NaN;
        if (num === 0) return 0;
        var mag = Math.pow(10, Math.floor(Math.log10(Math.abs(num))) - (n - 1));
        return Math.round(num / mag) * mag;
    }

    function decimalPlacesFromString(str) {
        if (str == null || str === '') return 0;
        str = String(str).trim().replace(/,/g, '.');
        var eIdx = str.search(/[eE]/);
        if (eIdx >= 0) str = str.slice(0, eIdx);
        var i = str.indexOf('.');
        if (i < 0) return 0;
        return str.length - i - 1;
    }

    function roundToDecimalPlaces(num, dp) {
        if (isNaN(num) || dp < 0) return NaN;
        var mult = Math.pow(10, dp);
        return Math.round(num * mult) / mult;
    }

    function getOrderOfMagnitude(num) {
        if (num === 0 || isNaN(num) || !isFinite(num)) return { order: null, scientific: '', explanation: '' };
        var abs = Math.abs(num);
        var exp = Math.floor(Math.log10(abs));
        var a = num / Math.pow(10, exp);
        var scientific = formatNum(a, 2) + ' × 10' + (exp >= 0 ? '⁺' : '⁻') + Math.abs(exp);
        var explanation = 'Order of magnitude = power of 10 when written as a × 10ⁿ with 1 ≤ |a| < 10. Here order = ' + exp + '.';
        return { order: exp, scientific: scientific, explanation: explanation };
    }

    function runConverter() {
        var value = parseFloat(document.getElementById('um-conv-value').value);
        var type = document.getElementById('um-conv-type').value;
        var dir = document.getElementById('um-conv-dir').value;
        var resultEl = document.getElementById('um-conv-result');
        var labelEl = document.getElementById('um-conv-result-label');
        var stepsBody = document.getElementById('um-steps-body');
        if (isNaN(value)) { if (resultEl) resultEl.textContent = '—'; renderSteps(stepsBody, []); return; }

        var toSI = (dir === 'toSI');
        var factor = 1;
        var fromName = '', toName = '', result = 0, formula = '', stepText = '';
        switch (type) {
            case 'ev': factor = eV_to_J; fromName = 'eV'; toName = 'J'; formula = '1 eV = 1.602×10⁻¹⁹ J'; break;
            case 'length_ang': factor = angstrom_to_m; fromName = 'Å'; toName = 'm'; formula = '1 Å = 10⁻¹⁰ m'; break;
            case 'length_fm': factor = fermi_to_m; fromName = 'fm'; toName = 'm'; formula = '1 fm = 10⁻¹⁵ m'; break;
            case 'pressure_atm': factor = atm_to_Pa; fromName = 'atm'; toName = 'Pa'; formula = '1 atm = 1.01325×10⁵ Pa'; break;
            case 'pressure_torr': factor = mmHg_to_Pa; fromName = 'mmHg'; toName = 'Pa'; formula = '1 mmHg = 133.322 Pa'; break;
            case 'mass_u': factor = u_to_kg; fromName = 'u'; toName = 'kg'; formula = '1 u = 1.66054×10⁻²⁷ kg'; break;
            default: if (resultEl) resultEl.textContent = '—'; renderSteps(stepsBody, []); return;
        }
        if (toSI) {
            result = value * factor;
            stepText = value + ' ' + fromName + ' × (factor) = ' + formatNum(result) + ' ' + toName;
            if (labelEl) labelEl.textContent = fromName + ' → ' + toName;
            if (resultEl) resultEl.textContent = formatNum(result) + ' ' + toName;
        } else {
            result = value / factor;
            stepText = value + ' ' + toName + ' ÷ (factor) = ' + formatNum(result) + ' ' + fromName;
            if (labelEl) labelEl.textContent = toName + ' → ' + fromName;
            if (resultEl) resultEl.textContent = formatNum(result) + ' ' + fromName;
        }
        renderSteps(stepsBody, [{ title: 'Conversion', formula: formula, calc: stepText }]);
    }

    function runSigFig() {
        var resultEl = document.getElementById('um-sigfig-result');
        var labelEl = document.getElementById('um-sigfig-result-label');
        var stepsBody = document.getElementById('um-steps-body2');

        if (sigFigMode === 'count') {
            var inputStr = document.getElementById('um-sigfig-input').value;
            var res = countSignificantFigures(inputStr);
            if (labelEl) labelEl.textContent = 'Number of significant figures';
            if (resultEl) resultEl.textContent = res.count;
            renderSteps(stepsBody, [
                { title: 'Parsed number', formula: 'Value = ' + formatNum(res.parsed), calc: res.explanation }
            ]);
            return;
        }
        if (sigFigMode === 'round') {
            var inputStr = document.getElementById('um-sigfig-input').value;
            var n = parseInt(document.getElementById('um-sigfig-n').value, 10) || 3;
            var num = parseNumberInput(inputStr);
            if (isNaN(num)) { if (resultEl) resultEl.textContent = '—'; renderSteps(stepsBody, []); return; }
            var rounded = roundToSignificantFigures(num, n);
            if (labelEl) labelEl.textContent = 'Rounded to ' + n + ' significant figure(s)';
            if (resultEl) resultEl.textContent = formatNum(rounded);
            renderSteps(stepsBody, [
                { title: 'Round to n sig figs', formula: 'n = ' + n + ', value = ' + formatNum(num), calc: 'Result = ' + formatNum(rounded) }
            ]);
            return;
        }
        if (sigFigMode === 'addsub') {
            var a = parseNumberInput(document.getElementById('um-sigfig-a').value);
            var b = parseNumberInput(document.getElementById('um-sigfig-b').value);
            if (isNaN(a) || isNaN(b)) { if (resultEl) resultEl.textContent = '—'; renderSteps(stepsBody, []); return; }
            var dpA = decimalPlacesFromString(document.getElementById('um-sigfig-a').value);
            var dpB = decimalPlacesFromString(document.getElementById('um-sigfig-b').value);
            var dp = Math.min(dpA, dpB);
            var sum = roundToDecimalPlaces(a + b, dp);
            var diff = roundToDecimalPlaces(a - b, dp);
            if (labelEl) labelEl.textContent = 'Result (least decimal places = ' + dp + ')';
            if (resultEl) resultEl.textContent = 'A + B = ' + formatNum(sum) + ', A − B = ' + formatNum(diff);
            renderSteps(stepsBody, [
                { title: 'Add/Subtract', formula: 'A has ' + dpA + ' decimal place(s), B has ' + dpB + '. Use least = ' + dp + '.', calc: 'A + B = ' + formatNum(sum) + ', A − B = ' + formatNum(diff) }
            ]);
            return;
        }
        if (sigFigMode === 'muldiv') {
            var strA = document.getElementById('um-sigfig-mula').value;
            var strB = document.getElementById('um-sigfig-mulb').value;
            var a = parseNumberInput(strA);
            var b = parseNumberInput(strB);
            if (isNaN(a) || isNaN(b) || b === 0) { if (resultEl) resultEl.textContent = '—'; renderSteps(stepsBody, []); return; }
            var sfA = countSignificantFigures(strA).count;
            var sfB = countSignificantFigures(strB).count;
            var sf = Math.min(sfA, sfB);
            var product = roundToSignificantFigures(a * b, sf);
            var quotient = roundToSignificantFigures(a / b, sf);
            if (labelEl) labelEl.textContent = 'Result (least sig figs = ' + sf + ')';
            if (resultEl) resultEl.textContent = 'A × B = ' + formatNum(product) + ', A ÷ B = ' + formatNum(quotient);
            renderSteps(stepsBody, [
                { title: 'Multiply/Divide', formula: 'A has ' + sfA + ' sig fig(s), B has ' + sfB + '. Use least = ' + sf + '.', calc: 'A × B = ' + formatNum(product) + ', A ÷ B = ' + formatNum(quotient) }
            ]);
        }
    }

    function runOrderOfMagnitude() {
        var inputStr = document.getElementById('um-order-input').value;
        var num = parseNumberInput(inputStr);
        var resultEl = document.getElementById('um-order-result');
        var stepsBody = document.getElementById('um-steps-body3');
        var res = getOrderOfMagnitude(num);
        if (resultEl) resultEl.textContent = res.order !== null ? res.order : '—';
        renderSteps(stepsBody, res.order !== null ? [
            { title: 'Scientific notation', formula: res.scientific, calc: res.explanation }
        ] : [{ title: 'Order of magnitude', formula: '', calc: 'Enter a non-zero number.' }]);
    }

    function renderSteps(container, steps) {
        if (!container) return;
        container.innerHTML = '';
        steps.forEach(function (s, i) {
            var div = document.createElement('div');
            div.className = 'step-item';
            div.innerHTML = (s.title ? '<div class="step-title" style="font-weight:700;color:var(--text-primary);margin-bottom:0.5rem;">' + (i + 1) + '. ' + s.title + '</div>' : '') +
                (s.formula ? '<div class="step-formula">' + s.formula + '</div>' : '') +
                (s.calc ? '<div class="step-calc">' + s.calc + '</div>' : '');
            container.appendChild(div);
        });
    }

    function runUnitsMeasurement() {
        var tab = getActiveTab();
        if (tab === 'converter') runConverter();
        else if (tab === 'sigfig') runSigFig();
        else if (tab === 'order') runOrderOfMagnitude();
    }

    function switchUMTab(tabId, btn) {
        document.querySelectorAll('.um-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.um-panel').forEach(function (p) { p.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var tabBtn = document.querySelector('.um-tab[data-tab="' + tabId + '"]');
        if (tabBtn) tabBtn.classList.add('active');
        var panel = document.getElementById('panel-um-' + tabId);
        if (panel) panel.classList.add('active');
        runUnitsMeasurement();
    }

    function setSigFigMode(mode) {
        sigFigMode = mode;
        document.querySelectorAll('.um-sigfig-mode').forEach(function (b) { b.classList.toggle('active', b.getAttribute('data-mode') === mode); });
        document.getElementById('um-sigfig-n-section').style.display = mode === 'round' ? 'block' : 'none';
        document.getElementById('um-sigfig-input-section').style.display = (mode === 'count' || mode === 'round') ? 'block' : 'none';
        document.getElementById('um-sigfig-addsub-section').style.display = mode === 'addsub' ? 'block' : 'none';
        document.getElementById('um-sigfig-muldiv-section').style.display = mode === 'muldiv' ? 'block' : 'none';
        var labels = { count: 'Number (to count significant figures)', round: 'Number (to round)', addsub: '', muldiv: '' };
        var labelEl = document.getElementById('um-sigfig-label');
        if (labelEl && labels[mode]) labelEl.textContent = labels[mode];
        runSigFig();
    }

    function toggleUMSteps(which) {
        var id = (which === 'conv') ? ['um-steps-body', 'um-steps-toggle'] : (which === 'sigfig') ? ['um-steps-body2', 'um-steps-toggle2'] : ['um-steps-body3', 'um-steps-toggle3'];
        var body = document.getElementById(id[0]);
        var toggle = document.getElementById(id[1]);
        if (body && toggle) {
            body.classList.toggle('collapsed');
            toggle.textContent = body.classList.contains('collapsed') ? '▼ Show' : '▲ Hide';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        runConverter();
        runSigFig();
        runOrderOfMagnitude();
        document.getElementById('um-conv-value').addEventListener('input', function () { if (getActiveTab() === 'converter') runConverter(); });
        document.getElementById('um-conv-type').addEventListener('change', runConverter);
        document.getElementById('um-conv-dir').addEventListener('change', runConverter);
        document.getElementById('um-sigfig-input').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-sigfig-n').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-sigfig-a').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-sigfig-b').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-sigfig-mula').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-sigfig-mulb').addEventListener('input', function () { if (getActiveTab() === 'sigfig') runSigFig(); });
        document.getElementById('um-order-input').addEventListener('input', function () { if (getActiveTab() === 'order') runOrderOfMagnitude(); });
    });

    window.runUnitsMeasurement = runUnitsMeasurement;
    window.switchUMTab = switchUMTab;
    window.setSigFigMode = setSigFigMode;
    window.toggleUMSteps = toggleUMSteps;
})();
