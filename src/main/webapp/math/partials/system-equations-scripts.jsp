<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Tool-specific scripts for system-equations-solver.jsp.

    Shared infrastructure (KaTeX / nerdamer core+Algebra+Calculus / Plotly
    loader / tool-utils / dark-mode / search / image-to-math) is loaded by
    /math/partials/math-libs.jsp. This partial adds Solve.js + the legacy
    systems-solver-{render,graph,export,core}.js + worksheet-engine plus
    the math-studio shell wiring (chip handler → loadExample, AI scan,
    busy-lock on the CTA).

    The legacy core's _makeEqRow has been patched to render <math-field>
    rows (with hidden .sy-eq-input twins for backwards-compat). So once
    math-input-setup.jsp imports MathLive, the equation rows upgrade
    automatically with no extra wiring needed here.
--%>
<% String _v = String.valueOf(System.currentTimeMillis()); %>

<!-- nerdamer Solve plugin (math-libs ships core + Algebra + Calculus only) -->
<script defer src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.min.js"></script>

<!-- Worksheet engine (shared with limit-calculator) -->
<script defer src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=_v%>"></script>

<!-- systems-solver pipeline: render → graph → export → core (defer keeps
     order, runs after DOMContentLoaded so MathLive is registered first
     when math-input-setup.jsp runs without defer). -->
<script defer src="<%=request.getContextPath()%>/js/systems-solver-render.js?v=<%=_v%>"></script>
<script defer src="<%=request.getContextPath()%>/js/systems-solver-graph.js?v=<%=_v%>"></script>
<script defer src="<%=request.getContextPath()%>/js/systems-solver-export.js?v=<%=_v%>"></script>
<script>window.SYSTEMS_SOLVER_CTX = "<%=request.getContextPath()%>";</script>
<script defer src="<%=request.getContextPath()%>/js/systems-solver-core.js?v=<%=_v%>"></script>

<!-- ─── math-studio shell wiring: chip auto-solve + busy lock + FAQ ─── -->
<script>
(function () {
    'use strict';

    function whenReady(fn) {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', fn);
        } else { fn(); }
    }

    whenReady(function () {
        // ── Empty-state chips → core.loadExample(eqs) ────────────────────
        // Each chip has data-eqs="eq1|eq2[|eq3]" — pipe-separated equations.
        // We call SystemsSolverCore.loadExample which sets state, re-renders
        // (now MathLive) rows, and triggers the solve.
        document.addEventListener('click', function (e) {
            if (!e.target || !e.target.closest) return;
            var chip = e.target.closest('.ic-example-chip');
            if (!chip) return;
            var eqsAttr = chip.getAttribute('data-eqs');
            if (!eqsAttr) return;
            var eqs = eqsAttr.split('|').map(function (s) { return s.trim(); }).filter(Boolean);
            if (!eqs.length) return;
            var core = window.SystemsSolverCore;
            if (core && typeof core.loadExample === 'function') {
                core.loadExample(eqs);
            }
        }, true);

        // ── CTA enable-state ─────────────────────────────────────────────
        // Disabled when ALL equation rows are empty.
        var solveBtn = document.getElementById('sy-solve-btn');
        function readAllEqs() {
            return Array.prototype.map.call(
                document.querySelectorAll('.sy-eq-input'),
                function (el) { return (el.value || '').trim(); }
            );
        }
        function updateEnableState() {
            if (!solveBtn) return;
            var anyHasContent = readAllEqs().some(function (s) { return !!s; });
            solveBtn.classList.toggle('is-disabled', !anyHasContent);
            solveBtn.setAttribute('aria-disabled', anyHasContent ? 'false' : 'true');
        }
        // Listen at document level since math-fields are added/removed dynamically.
        document.addEventListener('input', function (e) {
            if (e.target && e.target.tagName === 'MATH-FIELD') updateEnableState();
            if (e.target && e.target.classList && e.target.classList.contains('sy-eq-input')) updateEnableState();
        }, true);
        // Initial pass after a tick (give the core time to render rows).
        setTimeout(updateEnableState, 200);

        // ── Busy lock + auto-scroll on Solve ─────────────────────────────
        var resultContent = document.getElementById('sy-result-content');
        var scrollTarget  = document.getElementById('sy-panel-result');
        var safetyTimer = null, observer = null;
        function unlock() {
            if (solveBtn) solveBtn.classList.remove('is-busy');
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
            if (observer) { observer.disconnect(); observer = null; }
        }
        function lock() {
            if (!solveBtn || solveBtn.classList.contains('is-busy')) return false;
            solveBtn.classList.add('is-busy');
            if ('MutationObserver' in window && resultContent) {
                observer = new MutationObserver(unlock);
                observer.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            safetyTimer = setTimeout(unlock, 30000);
            return true;
        }
        if (solveBtn) {
            solveBtn.addEventListener('click', function () {
                lock();
                if (scrollTarget && scrollTarget.scrollIntoView) {
                    setTimeout(function () { scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 140);
                }
            });
        }

        // ── Method pills (visible) → forward to legacy method buttons ────
        // The legacy core wires .sy-method-btn clicks. Our pills carry the
        // same class so the core's handlers fire directly.

        // ── Clear button: reset to default 2-equation system ─────────────
        var clearBtn = document.getElementById('sy-clear-btn');
        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                var core = window.SystemsSolverCore;
                if (core && typeof core.loadExample === 'function') {
                    core.loadExample(['', '']);
                    setTimeout(updateEnableState, 50);
                }
                // Clear result panel back to empty state.
                var emptyState = document.getElementById('sy-empty-state');
                if (resultContent && emptyState && !resultContent.contains(emptyState)) {
                    resultContent.innerHTML = '';
                    resultContent.appendChild(emptyState);
                }
            });
        }

        // ── FAQ accordion (math-studio shell convention) ─────────────────
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () {
                q.closest('.ms-faq-item').classList.toggle('open');
            });
        });
    });
})();
</script>

<!-- ─── Image-to-math scanner — system-of-equations extraction prompt ─── -->
<script>
(function () {
    if (typeof ImageToMath === 'undefined') return;
    var CTX = '<%=request.getContextPath()%>';
    ImageToMath.init({
        buttonId: 'sy-image-btn',
        aiUrl: CTX + '/ai',
        toolName: 'System of Equations Solver',
        extractionPrompt:
            'You are a math problem extractor for a system of equations solver.\n' +
            'Given OCR text from a math image, extract systems of equations.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "eqs": an array of equation strings (2 or 3 equations)\n' +
            '  - "display": a LaTeX string for preview (e.g. "\\\\begin{cases}...\\\\end{cases}")\n\n' +
            'Format rules for each equation in "eqs":\n' +
            '  - Plain text with = (e.g. "2x + 3y = 8")\n' +
            '  - Use ^ for powers: "x^2 + y^2 = 25"\n' +
            '  - Use * for explicit multiplication only when required ("x*y = 6"); 2x is fine\n' +
            '  - Variables: x, y, z (use 2 vars for a 2x2 system, 3 vars for 3x3)\n\n' +
            'Return ONLY valid JSON array, no markdown fences. Empty array if none found.',
        onSelect: function (problem) {
            if (!problem || !problem.eqs || !Array.isArray(problem.eqs)) return;
            var core = window.SystemsSolverCore;
            if (core && typeof core.loadExample === 'function') {
                core.loadExample(problem.eqs.map(String));
            }
        }
    });
})();
</script>
