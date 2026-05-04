<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for quadratic-solver.jsp.

    Shared infrastructure (KaTeX / nerdamer / MathLive / image-to-math /
    tool-utils / dark-mode / search / Plotly loader) is loaded separately
    by /math/partials/math-libs.jsp + /math/partials/math-input-setup.jsp
    — include this file BETWEEN them on the tool page.

    Load order inside this partial:
      1. quadratic-solver-render   — KaTeX-formatted result + steps HTML
      2. quadratic-solver-graph    — Plotly parabola + horizontal parabola
      3. quadratic-solver-export   — Copy-LaTeX / Share / URL state
      4. quadratic-solver-input-bridge — MathLive → legacy coefficient adapter
      5. quadratic-solver-core     — DOM/UI controller (state + solve flow)
      6. wiring IIFE               — connects MathLive CTA to bridge → core
      7. image-to-math init        — quadratic-specific extraction prompt
--%>

<!-- Suppress core's 300ms demo-solve so the user sees the empty state. -->
<script>window.__QS_BRIDGE_NO_AUTOSOLVE = true;</script>

<!-- Render / Graph / Export / Bridge / Core (load order matters: render
     and bridge must be present before core's init binds handlers). -->
<script src="<%=request.getContextPath()%>/js/quadratic-solver-render.js"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-graph.js"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-export.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/quadratic-solver-input-bridge.js"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-core.js"></script>

<!-- Context for image-scan AI endpoint. -->
<script>window.__QS_CTX='<%=request.getContextPath()%>';</script>

<!-- ─── MathLive CTA wiring ─── -->
<script>
(function () {
    'use strict';

    var Bridge = window.QuadraticInputBridge;
    if (!Bridge) return;

    var exprInput = document.getElementById('ic-expr');
    var mathField = document.getElementById('ic-mathfield');
    var cta       = document.getElementById('qs-calculate-btn');
    var coreSolve = document.getElementById('qs-solve-btn');     // legacy, hidden
    var warnEl    = document.getElementById('qs-calculate-warn');
    var methodSel = document.getElementById('qs-method');
    var methodWrap = methodSel ? methodSel.closest('.tool-form-group') : null;
    if (!cta || !coreSolve) return;
    // Visible #qs-method IS the legacy method element — core reads it
    // directly, so no mirroring is needed.

    // Method dropdown only applies to standard equations. Hide it when the
    // parsed form is inequality or horizontal (where the core ignores it).
    function applyMethodVisibility(form) {
        if (!methodWrap) return;
        methodWrap.style.display = (form === 'standard') ? '' : 'none';
    }

    function currentExpr() { return exprInput ? (exprInput.value || '').trim() : ''; }

    function showWarn(msg) {
        if (!warnEl) return;
        warnEl.textContent = msg;
        warnEl.classList.remove('show');
        void warnEl.offsetWidth;
        warnEl.classList.add('show');
    }
    function clearWarn() {
        if (warnEl) { warnEl.classList.remove('show'); warnEl.textContent = ''; }
    }

    function updateEnableState() {
        var ready = !!currentExpr();
        cta.classList.toggle('is-disabled', !ready);
        cta.setAttribute('aria-disabled', ready ? 'false' : 'true');
    }
    if (exprInput) exprInput.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    if (mathField) mathField.addEventListener('input', function () { clearWarn(); updateEnableState(); });
    updateEnableState();

    // Busy lock + auto-scroll (mirrors limit-calculator.jsp pattern).
    var resultContent = document.getElementById('qs-result-content');
    var scrollTarget  = document.getElementById('qs-panel-result');
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

        var expr = currentExpr();
        if (!expr) { showWarn('Type an equation first.'); return; }

        var parsed = Bridge.parse(expr);
        if (!parsed || parsed.error) {
            showWarn(parsed && parsed.error ? parsed.error : 'Couldn\'t parse the equation.');
            return;
        }
        clearWarn();

        // Push parsed coefficients into the legacy hidden inputs and
        // switch the core's form-type — then trigger its solve.
        Bridge.applyToLegacyState(parsed);
        applyMethodVisibility(parsed.form);
        lock();
        coreSolve.click();
        if (scrollTarget && scrollTarget.scrollIntoView) {
            setTimeout(function () { scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 140);
        }
    });

    // Examples — each chip carries data-equation; clicking seeds MathLive
    // AND auto-solves so the experience is one-click from the empty state.
    document.addEventListener('click', function (e) {
        if (!e.target || !e.target.closest) return;
        var chip = e.target.closest('.ic-example-chip');
        if (!chip) return;
        var eq = chip.getAttribute('data-equation');
        if (!eq) return;
        Bridge.applyExample(eq);
        setTimeout(function () {
            updateEnableState();
            if (!cta.classList.contains('is-disabled') && !cta.classList.contains('is-busy')) {
                cta.click();
            }
        }, 100);
    }, true);

    // FAQ accordion — limit-calculator pattern.
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
})();
</script>

<!-- ─── Image-to-math scanner init — quadratic-specific prompt ─── -->
<script>
(function () {
    if (typeof ImageToMath === 'undefined') return;
    var QS_CTX = window.__QS_CTX || '';
    ImageToMath.init({
        buttonId: 'qs-image-btn',
        aiUrl: QS_CTX + '/ai',
        toolName: 'Quadratic Solver',
        extractionPrompt:
            'You are a math problem extractor for a quadratic equation solver.\n' +
            'Given OCR text from a math image, extract ALL quadratic equations or inequalities.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "latex": the equation in LaTeX (e.g. "x^{2}+5x+6=0", "(x-2)(x+3)<0", "x=y^{2}-4y+2")\n' +
            '  - "display": same as latex (used to preview the problem)\n\n' +
            'CRITICAL RULES:\n' +
            '- Always include the relation (= 0, <, >, ≤, ≥) in the LaTeX.\n' +
            '- For factored forms keep them factored.\n' +
            '- For horizontal parabolas use "x = ...y..." form.\n' +
            '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
            '- If no problems found, return []\n\n' +
            'Example:\n' +
            'Input: "Solve x squared minus 5x plus 6 equals zero"\n' +
            'Output: [{"latex":"x^{2}-5x+6=0","display":"x^{2}-5x+6=0"}]',
        onSelect: function (problem) {
            var latex = problem && (problem.latex || problem.display);
            if (!latex) return;
            // Push LaTeX into MathLive — its input event triggers
            // math-input-setup.jsp's mirror, which writes ascii-math
            // into #ic-expr. The bridge then reads from #ic-expr.
            var mf = document.getElementById('ic-mathfield');
            if (mf && typeof mf.setValue === 'function') {
                try { mf.setValue(latex, { format: 'latex' }); } catch (e) {}
            } else {
                // MathLive didn't load — drop straight into #ic-expr.
                var ex = document.getElementById('ic-expr');
                if (ex) {
                    ex.value = latex;
                    ex.dispatchEvent(new Event('input', { bubbles: true }));
                }
            }
            // Auto-solve after MathLive settles. 300ms covers slow devices.
            setTimeout(function () {
                var cta = document.getElementById('qs-calculate-btn');
                if (cta && !cta.classList.contains('is-disabled')) cta.click();
            }, 300);
        }
    });
})();
</script>
