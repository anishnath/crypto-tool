/**
 * Exponent Calculator - Core Orchestration
 * State management, events, integration with Render/Export modules
 */
(function() {
'use strict';

var R = window.ExponentCalcRender;
var E = window.ExponentCalcExport;

// ==================== State ====================

var state = {
    mode: 'basic',        // basic, rules, simplify, alllaws
    base: 2,
    exp: 5,
    rule: 'product',
    ruleBase: 3, m: 4, n: 3,
    powerBase: 2, powerM: 3, powerN: 2,
    prodA: 2, prodB: 3, prodN: 2,
    specialBase: 5, specialExp: -3,
    fracM: 3, fracN: 2,
    simplifyType: 'combo1',
    simplifyA: 2, simplifyB: 3,
    compareBase: 2,
    compilerLoaded: false
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function val(id, fallback) {
    var el = $(id);
    if (!el) return fallback || 0;
    return parseFloat(el.value) || fallback || 0;
}

function intVal(id, fallback) {
    var el = $(id);
    if (!el) return fallback || 0;
    return parseInt(el.value) || fallback || 0;
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;

    var btns = document.querySelectorAll('.ec-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }

    var forms = document.querySelectorAll('.ec-mode-form');
    for (var j = 0; j < forms.length; j++) {
        forms[j].classList.toggle('active', forms[j].id === 'ec-form-' + mode);
    }

    updatePreview();
}

// ==================== Rule Input Visibility ====================

function updateRuleInputs() {
    var rule = ($('ec-rule-type') || {}).value || 'product';
    state.rule = rule;

    var groups = ['ec-rule-inputs-pq', 'ec-rule-inputs-power', 'ec-rule-inputs-prodpow', 'ec-rule-inputs-special'];
    for (var i = 0; i < groups.length; i++) {
        var el = $(groups[i]);
        if (el) el.style.display = 'none';
    }

    var fracDiv = $('ec-frac-inputs');
    var specExpDiv = $('ec-special-exp-group');

    if (rule === 'product' || rule === 'quotient') {
        var pq = $('ec-rule-inputs-pq');
        if (pq) pq.style.display = 'block';
    } else if (rule === 'power') {
        var pw = $('ec-rule-inputs-power');
        if (pw) pw.style.display = 'block';
    } else if (rule === 'product-power' || rule === 'quotient-power') {
        var pp = $('ec-rule-inputs-prodpow');
        if (pp) pp.style.display = 'block';
    } else {
        var sp = $('ec-rule-inputs-special');
        if (sp) sp.style.display = 'block';
        if (specExpDiv) specExpDiv.style.display = (rule === 'zero') ? 'none' : (rule === 'fractional' ? 'none' : 'block');
        if (fracDiv) fracDiv.style.display = (rule === 'fractional') ? 'block' : 'none';
    }

    updatePreview();
}

// ==================== Calculate ====================

function calculate() {
    var container = $('ec-result-content');
    if (!container) return;

    var empty = $('ec-empty-state');
    if (empty) empty.style.display = 'none';

    var actions = $('ec-result-actions');
    if (actions) actions.style.display = 'flex';

    if (state.mode === 'basic') {
        var base = val('ec-basic-base', 2);
        var exp = val('ec-basic-exp', 5);
        if (base === 0 && exp <= 0) { R.showError(container, '0 raised to 0 or negative powers is undefined.'); return; }
        state.base = base; state.exp = exp;
        R.renderBasicPower(container, base, exp);

    } else if (state.mode === 'rules') {
        var rule = state.rule;
        if (rule === 'product') {
            R.renderProductRule(container, val('ec-rule-base', 3), val('ec-rule-m', 4), val('ec-rule-n', 3));
        } else if (rule === 'quotient') {
            R.renderQuotientRule(container, val('ec-rule-base', 3), val('ec-rule-m', 4), val('ec-rule-n', 3));
        } else if (rule === 'power') {
            R.renderPowerRule(container, val('ec-power-base', 2), val('ec-power-m', 3), val('ec-power-n', 2));
        } else if (rule === 'product-power') {
            R.renderProductPower(container, val('ec-prod-a', 2), val('ec-prod-b', 3), val('ec-prod-n', 2));
        } else if (rule === 'quotient-power') {
            var b2 = val('ec-prod-b', 3);
            if (b2 === 0) { R.showError(container, 'Denominator cannot be zero.'); return; }
            R.renderQuotientPower(container, val('ec-prod-a', 2), b2, val('ec-prod-n', 2));
        } else if (rule === 'negative') {
            R.renderNegativeExp(container, val('ec-special-base', 5), val('ec-special-exp', -3));
        } else if (rule === 'zero') {
            var zBase = val('ec-special-base', 5);
            if (zBase === 0) { R.showError(container, '0^0 is undefined.'); return; }
            R.renderZeroExp(container, zBase);
        } else if (rule === 'fractional') {
            var fn = intVal('ec-frac-denom', 2);
            if (fn === 0) { R.showError(container, 'Denominator cannot be zero.'); return; }
            R.renderFractionalExp(container, val('ec-special-base', 5), intVal('ec-frac-num', 3), fn);
        }

    } else if (state.mode === 'simplify') {
        var sType = ($('ec-simplify-type') || {}).value || 'combo1';
        state.simplifyType = sType;
        R.renderSimplify(container, sType, val('ec-simplify-a', 2), val('ec-simplify-b', 3));

    } else if (state.mode === 'alllaws') {
        R.renderAllLaws(container, val('ec-compare-base', 2));
    }

    updateCompiler();
}

// ==================== Preview ====================

var previewTimer = null;
function updatePreview() {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(function() {
        var preview = $('ec-preview');
        if (!preview || !window.katex) return;

        var latex = '';
        if (state.mode === 'basic') {
            var b = val('ec-basic-base', 2);
            var e = val('ec-basic-exp', 5);
            latex = R.fmt(b) + '^{' + R.fmt(e) + '}';
        } else if (state.mode === 'rules') {
            var rule = state.rule;
            if (rule === 'product') latex = 'a^m \\times a^n = a^{m+n}';
            else if (rule === 'quotient') latex = '\\frac{a^m}{a^n} = a^{m-n}';
            else if (rule === 'power') latex = '(a^m)^n = a^{mn}';
            else if (rule === 'product-power') latex = '(ab)^n = a^n b^n';
            else if (rule === 'quotient-power') latex = '\\left(\\frac{a}{b}\\right)^n = \\frac{a^n}{b^n}';
            else if (rule === 'negative') latex = 'a^{-n} = \\frac{1}{a^n}';
            else if (rule === 'zero') latex = 'a^0 = 1';
            else if (rule === 'fractional') latex = 'a^{m/n} = \\sqrt[n]{a^m}';
        } else if (state.mode === 'simplify') {
            latex = '\\text{Simplify expression}';
        } else {
            latex = '\\text{All 8 Laws of Exponents}';
        }

        R.renderKaTeX(preview, latex, true);
    }, 100);
}

// ==================== Compiler ====================

function updateCompiler() {
    if (!state.compilerLoaded) return;
    var iframe = $('ec-compiler-iframe');
    var templateSelect = $('ec-compiler-template');
    if (!iframe || !templateSelect) return;

    var contextPath = '';
    var meta = document.querySelector('meta[name="context-path"]');
    if (meta) contextPath = meta.getAttribute('content') || '';

    var url = E.getCompilerUrl(templateSelect.value, state.base || 2, state.exp || 5, contextPath);
    iframe.src = url;
}

function loadCompiler() {
    if (state.compilerLoaded) return;
    state.compilerLoaded = true;
    updateCompiler();
}

// ==================== Examples ====================

function loadExample(name) {
    var examples = {
        'power-of-2':  { mode: 'basic', base: 2, exp: 10 },
        'negative':    { mode: 'basic', base: 3, exp: -2 },
        'fractional':  { mode: 'basic', base: 16, exp: 0.5 },
        'zero':        { mode: 'basic', base: 7, exp: 0 },
        'product':     { mode: 'rules', rule: 'product' },
        'quotient':    { mode: 'rules', rule: 'quotient' },
        'simplify1':   { mode: 'simplify', type: 'combo1' },
        'all-laws':    { mode: 'alllaws' }
    };

    var ex = examples[name];
    if (!ex) return;

    switchMode(ex.mode);

    if (ex.mode === 'basic') {
        var baseInput = $('ec-basic-base');
        var expInput = $('ec-basic-exp');
        if (baseInput) baseInput.value = ex.base;
        if (expInput) expInput.value = ex.exp;
    } else if (ex.mode === 'rules' && ex.rule) {
        var ruleSelect = $('ec-rule-type');
        if (ruleSelect) { ruleSelect.value = ex.rule; updateRuleInputs(); }
    } else if (ex.mode === 'simplify' && ex.type) {
        var sType = $('ec-simplify-type');
        if (sType) sType.value = ex.type;
    }

    calculate();
}

// ==================== Clear ====================

function clearAll() {
    var basicBase = $('ec-basic-base');
    var basicExp = $('ec-basic-exp');
    if (basicBase) basicBase.value = '2';
    if (basicExp) basicExp.value = '5';

    var content = $('ec-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="ec-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">a<sup>n</sup></div>' +
            '<h3>Enter values to calculate</h3>' +
            '<p>Master all 8 laws of exponents with step-by-step solutions.</p></div>';
    }

    var actions = $('ec-result-actions');
    if (actions) actions.style.display = 'none';

    switchMode('basic');
    updatePreview();
}

// ==================== URL State ====================

function loadFromURL() {
    var data = E.parseShareUrl();
    if (!data) return false;

    if (data.mode) switchMode(data.mode);
    if (data.mode === 'basic') {
        var baseInput = $('ec-basic-base');
        var expInput = $('ec-basic-exp');
        if (baseInput && data.b !== undefined) baseInput.value = data.b;
        if (expInput && data.e !== undefined) expInput.value = data.e;
    }
    calculate();
    return true;
}

// ==================== Initialization ====================

function init() {
    // Mode toggle
    var modeBtns = document.querySelectorAll('.ec-mode-btn');
    for (var i = 0; i < modeBtns.length; i++) {
        modeBtns[i].addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    }

    // Solve & Clear
    var solveBtn = $('ec-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    var clearBtn = $('ec-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Rule type change
    var ruleType = $('ec-rule-type');
    if (ruleType) ruleType.addEventListener('change', updateRuleInputs);

    // Simplify type change - toggle b visibility
    var simplifyType = $('ec-simplify-type');
    if (simplifyType) {
        simplifyType.addEventListener('change', function() {
            var bDiv = $('ec-simplify-b-group');
            if (bDiv) bDiv.style.display = this.value === 'combo3' ? 'block' : 'none';
        });
    }

    // Output tabs
    var tabs = document.querySelectorAll('.ec-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');
            var panels = document.querySelectorAll('.ec-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'ec-panel-' + panel);
            }
            if (panel === 'python' && !state.compilerLoaded) loadCompiler();
        });
    }

    // Input changes trigger preview
    var inputs = document.querySelectorAll('.ec-input');
    for (var p = 0; p < inputs.length; p++) {
        inputs[p].addEventListener('input', updatePreview);
    }

    // Enter key to calculate
    var allInputs = document.querySelectorAll('.ec-input');
    for (var q = 0; q < allInputs.length; q++) {
        allInputs[q].addEventListener('keydown', function(e) {
            if (e.key === 'Enter') calculate();
        });
    }

    // Action buttons
    var copyBtn = $('ec-copy-latex-btn');
    if (copyBtn) {
        copyBtn.addEventListener('click', function() {
            E.copyLatex(state.mode, { base: state.base, exp: state.exp, m: state.m, n: state.n });
        });
    }

    var shareBtn = $('ec-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Compiler template
    var compilerTemplate = $('ec-compiler-template');
    if (compilerTemplate) compilerTemplate.addEventListener('change', updateCompiler);

    // Example chips
    var chips = document.querySelectorAll('.ec-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    }

    // FAQ
    if (typeof window.toggleFaq === 'undefined') {
        window.toggleFaq = function(btn) {
            var item = btn.parentElement;
            var answer = item.querySelector('.faq-answer');
            var chevron = btn.querySelector('.faq-chevron');
            var isOpen = answer.style.maxHeight && answer.style.maxHeight !== '0px';
            answer.style.maxHeight = isOpen ? '0px' : answer.scrollHeight + 'px';
            answer.style.padding = isOpen ? '0 1rem' : '0.75rem 1rem';
            if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
        };
    }

    updatePreview();
    if (!loadFromURL()) {
        // default state
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
