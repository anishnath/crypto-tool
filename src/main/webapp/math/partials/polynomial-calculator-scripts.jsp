<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for polynomial-calculator.jsp.

    Shared infrastructure (KaTeX / nerdamer / MathLive / image-to-math /
    tool-utils / dark-mode / search / Plotly loader) is loaded separately
    by /math/partials/math-libs.jsp + /math/partials/math-input-setup.jsp
    — include this file BETWEEN them on the tool page.

    Load order inside this partial:
      1. polynomial-calculator-render  — KaTeX-formatted result HTML
      2. polynomial-calculator-graph   — Plotly polynomial plot
      3. polynomial-calculator-export  — Copy-LaTeX / Share / URL state
      4. polynomial-calculator-input-bridge — visible MathLive → hidden legacy
      5. polynomial-calculator-core    — DOM/UI controller
      6. wiring IIFE                   — operation pills, Q-field visibility,
                                          CTA click → bridge → core
      7. image-to-math init            — polynomial-specific extraction prompt
--%>

<%-- Worksheet engine (drives the modal launched from #poly-worksheet-btn). --%>
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>

<script src="<%=request.getContextPath()%>/js/polynomial-calculator-render.js"></script>
<script src="<%=request.getContextPath()%>/js/polynomial-calculator-graph.js"></script>
<script src="<%=request.getContextPath()%>/js/polynomial-calculator-export.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/polynomial-calculator-input-bridge.js"></script>
<script src="<%=request.getContextPath()%>/js/polynomial-calculator-core.js"></script>

<script>window.__POLY_CTX='<%=request.getContextPath()%>';</script>

<!-- ─── Visible MathLive CTA wiring ─── -->
<script>
(function () {
    'use strict';

    var Bridge = window.PolynomialInputBridge;
    if (!Bridge) return;

    // Force Visual as the default input mode for this page, regardless of
    // whatever 'ic.inputMode' was last set to on a sibling math tool. This
    // runs BEFORE math-input-setup.jsp's IIFE (which is included after this
    // partial), so its localStorage read picks up 'visual'.
    try { localStorage.setItem('ic.inputMode', 'visual'); } catch (e) {}

    var mf1       = document.getElementById('ic-mathfield');
    var mf2       = document.getElementById('ic-mathfield2');
    var exprIn1   = document.getElementById('ic-expr');
    var evalIn    = document.getElementById('poly-bridge-eval-x');
    var cta       = document.getElementById('poly-calculate-btn');
    var resetBtn  = document.getElementById('poly-reset-btn');
    var coreCalc  = document.getElementById('poly-calc-btn');     // legacy, hidden
    var warnEl    = document.getElementById('poly-calculate-warn');
    var qWrap     = document.getElementById('poly-q-wrap');
    var evalWrap  = document.getElementById('poly-eval-wrap');
    var varSelect = document.getElementById('poly-var');
    var evalVarLabel = document.getElementById('poly-eval-var');
    if (!cta || !coreCalc) return;

    // Variable selector reflects into the "Evaluate at <var>" label and into
    // each math-field's placeholder so users see the picked variable used
    // consistently. Core reads #poly-var.value directly.
    function applyVariable(v) {
        v = v || 'x';
        if (evalVarLabel) evalVarLabel.textContent = v;
        if (mf1) try { mf1.placeholder = v + '^3 + 2' + v + '^2 - 5' + v + ' + 3'; } catch (e) {}
        if (mf2) try { mf2.placeholder = v + '^2 - 4'; } catch (e) {}
        if (exprIn1) exprIn1.placeholder = 'e.g.  ' + v + '^3 + 2' + v + '^2 - 5' + v + ' + 3';
    }
    if (varSelect) {
        varSelect.addEventListener('change', function () { applyVariable(varSelect.value); });
        applyVariable(varSelect.value);
    }

    var BINARY_OPS = { add: 1, subtract: 1, multiply: 1, divide: 1 };
    var UNARY_OPS  = { factor: 1, roots: 1 };
    var EVAL_OP    = { evaluate: 1 };
    var currentMode = 'add';

    function setMode(mode) {
        currentMode = mode;
        document.querySelectorAll('.poly-bridge-op').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === mode);
            b.setAttribute('aria-checked', b.getAttribute('data-mode') === mode ? 'true' : 'false');
        });
        if (qWrap)    qWrap.style.display    = BINARY_OPS[mode] ? '' : 'none';
        if (evalWrap) evalWrap.style.display = EVAL_OP[mode]    ? '' : 'none';
        // Forward to the legacy hidden mode button so the core also tracks it.
        var coreBtn = document.querySelector('.poly-mode-btn[data-mode="' + mode + '"]');
        if (coreBtn) coreBtn.click();
        clearWarn();
        updateEnableState();
    }

    document.querySelectorAll('.poly-bridge-op').forEach(function (b) {
        b.addEventListener('click', function () { setMode(b.getAttribute('data-mode')); });
    });

    function readP1() { return exprIn1 ? (exprIn1.value || '').trim() : ''; }
    function readP2() {
        if (!mf2) return '';
        try { return (mf2.getValue('ascii-math') || '').trim(); } catch (e) { return ''; }
    }
    function readEvalX() { return evalIn ? (evalIn.value || '').trim() : ''; }

    function showWarn(msg) {
        if (!warnEl) return;
        warnEl.textContent = msg;
        warnEl.classList.remove('show');
        void warnEl.offsetWidth;
        warnEl.classList.add('show');
    }
    function clearWarn() { if (warnEl) { warnEl.classList.remove('show'); warnEl.textContent = ''; } }

    function updateEnableState() {
        var hasP1 = !!readP1();
        var ready = hasP1;
        if (BINARY_OPS[currentMode]) ready = ready && !!readP2();
        if (EVAL_OP[currentMode])    ready = ready && !!readEvalX();
        cta.classList.toggle('is-disabled', !ready);
        cta.setAttribute('aria-disabled', ready ? 'false' : 'true');
    }
    if (exprIn1) exprIn1.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    if (mf1)     mf1.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    if (mf2)     mf2.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    if (evalIn)  evalIn.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    setMode('add');

    // Busy lock + auto-scroll, mirrors limit/quadratic.
    var resultContent = document.getElementById('poly-result-content');
    var scrollTarget  = document.getElementById('poly-panel-result');
    var safetyTimer = null, observer = null;
    function unlock() {
        cta.classList.remove('is-busy');
        if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
        if (observer) { observer.disconnect(); observer = null; }
    }
    function lock() {
        if (cta.classList.contains('is-busy')) return false;
        cta.classList.add('is-busy');
        if ('MutationObserver' in window && resultContent) {
            observer = new MutationObserver(unlock);
            observer.observe(resultContent, { childList: true, subtree: true, characterData: true });
        }
        safetyTimer = setTimeout(unlock, 30000);
        return true;
    }

    cta.addEventListener('click', function (e) {
        if (cta.classList.contains('is-busy')) { e.preventDefault(); return; }

        var p1 = readP1();
        if (!p1) { showWarn('Type a polynomial first.'); return; }
        if (BINARY_OPS[currentMode] && !readP2()) {
            showWarn('Enter the second polynomial Q(' + (varSelect ? varSelect.value : 'x') + ').');
            return;
        }
        if (EVAL_OP[currentMode] && !readEvalX()) {
            showWarn('Enter a value for ' + (varSelect ? varSelect.value : 'x') + '.');
            return;
        }
        clearWarn();

        var resolved = Bridge.syncToLegacy({
            p1: p1,
            p2: readP2(),
            evalX: readEvalX(),
            mode: currentMode
        });
        // Equation detector fired? Surface a toast so the user understands
        // we treated "LHS = RHS" as "LHS - RHS = 0" before solving.
        if (resolved && resolved.rearranged && typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
            ToolUtils.showToast('Equation detected — rearranged to LHS − RHS = 0', 3000, 'info');
        }
        lock();
        coreCalc.click();
        if (scrollTarget && scrollTarget.scrollIntoView) {
            setTimeout(function () { scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 140);
        }
    });

    // Clear button — reset visible inputs and re-show empty-state chips.
    if (resetBtn) {
        resetBtn.addEventListener('click', function () {
            Bridge.clearAll();
            clearWarn();
            updateEnableState();
        });
    }

    // Empty-state example chips: data-* attrs carry p1 / p2 / mode / evalX.
    document.addEventListener('click', function (e) {
        if (!e.target || !e.target.closest) return;
        var chip = e.target.closest('.ic-example-chip');
        if (!chip) return;
        var ex = {
            p1: chip.getAttribute('data-p1') || '',
            p2: chip.getAttribute('data-p2') || '',
            evalX: chip.getAttribute('data-eval-x') || '',
            mode: chip.getAttribute('data-mode') || 'add'
        };
        Bridge.applyExample(ex);
        // applyExample → setMode (pill click) → setMode runs setMode handler →
        // updates currentMode and toggles Q/evalX visibility. Auto-solve next.
        setTimeout(function () {
            updateEnableState();
            if (!cta.classList.contains('is-disabled') && !cta.classList.contains('is-busy')) {
                cta.click();
            }
        }, 120);
    }, true);

    // FAQ accordion.
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
})();
</script>

<!-- ─── Image-to-math scanner — polynomial extraction ─── -->
<script>
(function () {
    if (typeof ImageToMath === 'undefined') return;
    var CTX = window.__POLY_CTX || '';
    ImageToMath.init({
        buttonId: 'poly-image-btn',
        aiUrl: CTX + '/ai',
        toolName: 'Polynomial Calculator',
        extractionPrompt:
            'You are a math problem extractor for a polynomial calculator.\n' +
            'Given OCR text from a math image, extract polynomial problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "p1": the primary polynomial in LaTeX (e.g. "x^{3}+2x^{2}-5x+3")\n' +
            '  - "p2": (optional) the second polynomial in LaTeX (only for binary operations)\n' +
            '  - "mode": one of "add", "subtract", "multiply", "divide", "factor", "roots", "evaluate"\n' +
            '  - "evalX": (optional) the x-value if mode is "evaluate"\n' +
            '  - "display": full LaTeX of the problem for preview\n\n' +
            'Mode detection rules:\n' +
            '- Two polynomials with + → add\n' +
            '- Two polynomials with − → subtract\n' +
            '- Two polynomials with × or juxtaposition → multiply\n' +
            '- Two polynomials with ÷ or / or "long division" → divide\n' +
            '- "Factor", "factorize" or written in product form → factor (single polynomial)\n' +
            '- "Find roots", "= 0", "solve" → roots (single polynomial)\n' +
            '- "Evaluate at x = n", "P(n)" → evaluate (single polynomial + evalX)\n\n' +
            'Return ONLY valid JSON array, no markdown fences.\n' +
            'If no problems found, return [].',
        onSelect: function (problem) {
            if (!problem) return;
            var Bridge = window.PolynomialInputBridge;
            if (!Bridge) return;

            // Push LaTeX directly into MathLive — it'll mirror to ascii on its own.
            var mf1 = document.getElementById('ic-mathfield');
            var mf2 = document.getElementById('ic-mathfield2');
            if (mf1 && typeof mf1.setValue === 'function' && problem.p1) {
                try { mf1.setValue(problem.p1, { format: 'latex' }); } catch (e) {}
            }
            if (mf2 && typeof mf2.setValue === 'function' && problem.p2) {
                try { mf2.setValue(problem.p2, { format: 'latex' }); } catch (e) {}
            }
            // Mode pill click via the bridge example helper.
            var pill = document.querySelector('.poly-bridge-op[data-mode="' + (problem.mode || 'add') + '"]');
            if (pill) pill.click();

            var evalIn = document.getElementById('poly-bridge-eval-x');
            if (evalIn && problem.evalX != null) evalIn.value = String(problem.evalX);

            // Auto-solve once MathLive settles.
            setTimeout(function () {
                var cta = document.getElementById('poly-calculate-btn');
                if (cta && !cta.classList.contains('is-disabled')) cta.click();
            }, 350);
        }
    });
})();
</script>

<!-- ─── Worksheet button wiring — opens the WorksheetEngine modal with
        polynomials.json (1,500+ SymPy-verified problems across 26 types).
        Both the small toolbar button and the prominent CTA route here. ─── -->
<script>
(function () {
    function openPolynomialWorksheet() {
        if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
            if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
            }
            return;
        }
        window.WorksheetEngine.open({
            jsonUrl: 'worksheet/math/algebra/polynomials.json',
            title: 'Polynomial Operations',
            accentColor: '#15803d',     // math-studio emerald — matches the shell
            branding: '8gwifi.org',
            defaultCount: 20
        });
    }

    function whenReady(fn) {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', fn);
        } else { fn(); }
    }
    whenReady(function () {
        var ctaBtn     = document.getElementById('poly-worksheet-btn');
        var toolbarBtn = document.getElementById('poly-toolbar-worksheet-btn');
        if (ctaBtn)     ctaBtn.addEventListener('click', openPolynomialWorksheet);
        if (toolbarBtn) toolbarBtn.addEventListener('click', openPolynomialWorksheet);
    });
})();
</script>
