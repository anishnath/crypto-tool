<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Shared scripts for integral-calculator pages.
  Extracted verbatim from integral-calculator.jsp:653-1536 so the original
  page and integral-calculator2.jsp load IDENTICAL tool behavior.
  Expects the following DOM IDs to exist upstream: #ic-expr, #ic-mathfield,
  #ic-expr-wrap, #ic-input-mode-toggle, #ic-image-btn, plus the full tool card.
--%>
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<!-- Nerdamer -->
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js"></script>

<!-- Plotly (deferred until graph tab clicked) -->
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
<script>window.INTEGRAL_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator.js"></script>

<!-- MathLive visual math input.

     Data model (deliberately minimal):
       * #ic-expr is the ONE canonical buffer read by the solver, chips,
         autocomplete, URL loader, image-scan and share.
       * The <math-field> is a visual editor that, in Visual mode, writes
         one-way into #ic-expr on every input (via MathLive's native
         `ascii-math` format — which is already our calculator's dialect:
         sin(x), sqrt(x), ^, *, /, pi, implicit multiplication).
       * No bidirectional sync, no loop-guards, no custom LaTeX regex.
       * Programmatic writes to #ic-expr (chips/URL/scan) are mirrored into
         the math-field via a value-setter hook that calls MathLive's own
         ascii-math parser. If that parse fails (e.g. SymPy Sum(...)), we
         auto-switch to Text mode so the user still sees their expression. -->
<script type="module">
    import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';
    if (window.MathfieldElement) {
        window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
        try { window.MathfieldElement.soundsDirectory = null; } catch (e) {}
    }

    /*
     * Calculus-first virtual keyboard.
     *
     * The default MathLive keyboards are great for general math input, but a
     * student writing an integrand spends ~all their time in a narrow alphabet:
     * variables, constants (pi / e / infinity), powers, fractions, roots, a
     * handful of trig/log/exp functions, and parentheses. So we define a "Calc"
     * layer up front and relegate the stock `numeric` / `symbols` / `greek`
     * layouts to the layer switcher for the long tail.
     *
     * Layout shape (4 rows × 10 keycaps, following MathLive's row-size advice):
     *   Row 1:  vars (x y t n) · constants (pi e ∞) · nav (← → ⌫)
     *   Row 2:  digits 1-5 · + − · / · frac · x^n
     *   Row 3:  digits 6-9,0 · ( ) · x² · √ · 1/x · undo
     *   Row 4:  sin cos tan · ln log e^x · arctan arcsin arccos · ↵
     *
     * Long-press variants pack the related-but-rare symbols in without
     * cluttering the primary surface (x → a,b,u,v,θ; sin → sinh,csc; √ → ∛,ⁿ√;
     * ∞ → -∞,0⁺,0⁻; + → ±,∓; e^x → e^-x, a^x; etc.). This mirrors how the stock
     * MathLive layouts hide depth behind long-press.
     */
    if (window.mathVirtualKeyboard) {
        window.mathVirtualKeyboard.layouts = [
            {
                label: 'Calc',
                tooltip: 'Calculus integrands',
                rows: [
                    [
                        { latex: 'x', variants: ['a', 'b', 'u', 'v', 'r', 's', '\\theta'] },
                        { latex: 'y', variants: ['z'] },
                        { latex: 't', variants: ['\\tau'] },
                        { latex: 'n', variants: ['m', 'k', 'p', 'q'] },
                        { latex: '\\pi', variants: ['\\Pi'] },
                        { latex: 'e', variants: ['\\mathrm{e}'] },
                        { latex: '\\infty', variants: ['-\\infty', '0^{+}', '0^{-}'] },
                        '[left]', '[right]', '[backspace]'
                    ],
                    [
                        '[1]', '[2]', '[3]', '[4]', '[5]',
                        { latex: '+', variants: ['\\pm', '\\mp'] },
                        { latex: '-', variants: ['\\mp', '\\pm'] },
                        { latex: '\\cdot', variants: ['\\times', '*'] },
                        { class: 'small', latex: '\\frac{#@}{#?}',
                          variants: [{ latex: '\\frac{#?}{#?}' }, { latex: '#@/#?' }] },
                        { class: 'small', latex: '#@^{#?}', label: 'x<sup>n</sup>',
                          variants: ['#@^{-1}', '#@^{1/2}'] }
                    ],
                    [
                        '[6]', '[7]', '[8]', '[9]', '[0]',
                        '[(]', '[)]',
                        { latex: '#@^{2}', label: 'x<sup>2</sup>',
                          variants: ['#@^{3}', '#@^{-1}', '#@^{1/2}'] },
                        { latex: '\\sqrt{#@}', label: '&radic;',
                          variants: ['\\sqrt[3]{#@}', '\\sqrt[#?]{#@}'] },
                        { class: 'small', latex: '\\frac{1}{#?}', label: '1/x',
                          variants: ['\\frac{1}{#?^{2}}', '\\frac{#?}{#?+1}'] }
                    ],
                    [
                        { latex: '\\sin', variants: ['\\sinh', '\\csc', '\\operatorname{csch}'] },
                        { latex: '\\cos', variants: ['\\cosh', '\\sec', '\\operatorname{sech}'] },
                        { latex: '\\tan', variants: ['\\tanh', '\\cot', '\\coth'] },
                        { latex: '\\ln', variants: ['\\log_{#?}'] },
                        { latex: '\\log' },
                        { class: 'small', latex: 'e^{#?}', label: 'e<sup>x</sup>',
                          variants: ['e^{-#?}', 'a^{#?}', 'e^{-#?^{2}}'] },
                        { latex: '\\arctan', variants: ['\\operatorname{arccot}'] },
                        { latex: '\\arcsin', variants: ['\\operatorname{arccsc}'] },
                        { latex: '\\arccos', variants: ['\\operatorname{arcsec}'] },
                        '[return]'
                    ]
                ]
            },
            'numeric',
            'symbols',
            'greek'
        ];
    }
</script>

<script>
(function () {
    'use strict';

    var mf        = document.getElementById('ic-mathfield');
    var exprInput = document.getElementById('ic-expr');
    var wrap      = document.getElementById('ic-expr-wrap');
    var toggle    = document.getElementById('ic-input-mode-toggle');
    if (!mf || !exprInput || !toggle) return;

    var STORAGE_KEY = 'ic.inputMode';
    var cardBody = wrap.closest('.tool-card-body') || wrap.parentNode;

    // Native <input>.value setter — used to bypass our own property hook
    // when mirroring math-field → #ic-expr (so we don't re-enter the hook).
    var nativeInputValueSetter = (function () {
        try {
            var d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
            return d && typeof d.set === 'function' ? d.set : null;
        } catch (e) { return null; }
    })();
    function setExprRaw(v) {
        if (nativeInputValueSetter) nativeInputValueSetter.call(exprInput, v);
        else exprInput.value = v;
    }

    // ---------- Mode control ----------
    function getMode() { return wrap.getAttribute('data-input-mode') || 'visual'; }
    function setMode(mode) {
        if (mode !== 'visual' && mode !== 'text') mode = 'visual';
        wrap.setAttribute('data-input-mode', mode);
        if (cardBody) cardBody.setAttribute('data-input-mode', mode);
        toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
            var active = btn.getAttribute('data-input-mode') === mode;
            btn.classList.toggle('active', active);
            btn.setAttribute('aria-checked', active ? 'true' : 'false');
        });
        try { localStorage.setItem(STORAGE_KEY, mode); } catch (e) {}
    }

    // Initial mode (default visual; migrate legacy 'both').
    var initial = 'visual';
    try {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'text') initial = 'text';
    } catch (e) {}
    setMode(initial);

    // SymPy-style constructs that have no visual math representation.
    // Fast-reject these before handing them to MathLive — its ascii-math
    // parser will otherwise happily emit unreadable garbage.
    function isAdvancedSympy(expr) {
        if (!expr) return false;
        if (/^\s*(Sum|Max|Min|Integral|Product|Rational)\s*\(/i.test(expr)) return true;
        if (/,\s*\([^)]*\)\s*$/.test(expr)) return true;
        return false;
    }

    // Seed the math-field from a calculator-format expression via MathLive's
    // own ascii-math parser. Returns true on success, false if the expression
    // cannot be meaningfully represented visually (caller should switch to Text).
    function seedMathField(expr) {
        expr = (expr == null ? '' : String(expr)).trim();
        if (!expr) {
            try { mf.setValue('', { silenceNotifications: true }); } catch (_) {}
            return true;
        }
        if (isAdvancedSympy(expr)) return false;
        if (typeof mf.setValue !== 'function') return false;
        try {
            mf.setValue(expr, { format: 'ascii-math', silenceNotifications: true });
            var back = '';
            try { back = (mf.getValue('ascii-math') || '').trim(); } catch (_) {}
            return !!back;
        } catch (_) {
            try { mf.setValue('', { silenceNotifications: true }); } catch (_) {}
            return false;
        }
    }

    // ---------- Mode toggle click ----------
    toggle.addEventListener('click', function (e) {
        var btn = e.target.closest('.ic-input-mode-btn');
        if (!btn || btn.disabled) return;
        var next = btn.getAttribute('data-input-mode');
        if (next === getMode()) return;

        if (next === 'visual') {
            if (!seedMathField(exprInput.value)) {
                // Can't render (e.g. SymPy Sum) — refuse the switch.
                return;
            }
            setMode('visual');
            try { mf.focus(); } catch (_) {}
        } else {
            // #ic-expr is already current (unidirectional flow). Just flip.
            setMode('text');
            // Nudge the preview & autocomplete once.
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
            try { exprInput.focus(); } catch (_) {}
        }
    });

    // ---------- Programmatic #ic-expr writes mirror into math-field ----------
    // Chips, URL loader, image-scan, autocomplete-accept all do
    //   exprInput.value = '...';
    // We hook the setter to seed the math-field when in Visual mode.
    // No dispatchEvent here: that's the caller's job.
    (function hookExprSetter() {
        if (!nativeInputValueSetter) return;
        try {
            var nativeGetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').get;
            Object.defineProperty(exprInput, 'value', {
                configurable: true,
                enumerable: true,
                get: function () { return nativeGetter.call(this); },
                set: function (v) {
                    nativeInputValueSetter.call(this, v);
                    if (getMode() === 'visual') {
                        if (!seedMathField(v)) setMode('text');
                    }
                }
            });
        } catch (e) { /* non-fatal */ }
    })();

    // ---------- Wire events once the <math-field> custom element upgrades ----------
    function wire() {
        // Calculus-focused inline shortcuts layered on top of MathLive's
        // defaults. MathLive already ships `pi`, `oo`, `inf`, `int`, `sum`,
        // `sin`/`cos`/`tan`, `sqrt`, `lim`, Greek letters, etc. — we only add
        // what calculus students actually reach for and the defaults miss:
        //   • "atan", "asin", "acos", "acot", "asec", "acsc"  → arc-trig
        //     aliases (matches our normalizeExpr()'s `arcsin`→`asin` rewrite
        //     and what students typically type)
        //   • "exp" → e^{…}
        //   • "abs" → |…|
        //   • "cbrt" → ∛
        //   • "dx", "dt", "dy", "du", "dn" → upright differential (visual
        //     cue for students who paste a full integral and include the
        //     differential — the doIntegrate() pre-pass then extracts it)
        try {
            mf.inlineShortcuts = Object.assign({}, mf.inlineShortcuts || {}, {
                'atan':  '\\arctan',
                'asin':  '\\arcsin',
                'acos':  '\\arccos',
                'acot':  '\\operatorname{arccot}',
                'asec':  '\\operatorname{arcsec}',
                'acsc':  '\\operatorname{arccsc}',
                'exp':   'e^{#?}',
                'abs':   '\\left|#?\\right|',
                'cbrt':  '\\sqrt[3]{#?}',
                'dx':    '\\,\\mathrm{d}x',
                'dt':    '\\,\\mathrm{d}t',
                'dy':    '\\,\\mathrm{d}y',
                'du':    '\\,\\mathrm{d}u',
                'dn':    '\\,\\mathrm{d}n'
            });
        } catch (_) { /* MathLive version without inlineShortcuts setter */ }

        // Visual -> Text, one-way. Use the NATIVE setter + dispatch 'input'
        // so every downstream listener (preview, autocomplete, ...) sees it
        // exactly once, without re-entering our value-setter hook.
        mf.addEventListener('input', function () {
            if (getMode() !== 'visual') return;
            var ascii = '';
            try { ascii = (mf.getValue('ascii-math') || '').trim(); } catch (_) {}
            if (exprInput.value === ascii) return;
            setExprRaw(ascii);
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
        });

        // Enter submits.
        mf.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                var btn = document.getElementById('ic-integrate-btn');
                if (btn) btn.click();
            }
        });

        // Seed from any pre-existing text (URL param, server-rendered value).
        if (getMode() === 'visual' && exprInput.value) {
            if (!seedMathField(exprInput.value)) setMode('text');
        }
    }

    if (window.customElements && customElements.get('math-field')) {
        wire();
    } else if (window.customElements && customElements.whenDefined) {
        customElements.whenDefined('math-field').then(wire).catch(function () {
            // MathLive failed to load — force Text mode, disable Visual button.
            setMode('text');
            if (mf && mf.parentNode) mf.parentNode.removeChild(mf);
            toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
                if (btn.getAttribute('data-input-mode') === 'visual') {
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor = 'not-allowed';
                    btn.title = 'Visual math input failed to load';
                }
            });
        });
    } else {
        setMode('text');
    }
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/image-to-math.js"></script>
<script>
    ImageToMath.init({
        buttonId: 'ic-image-btn',
        aiUrl: (window.INTEGRAL_CALC_CTX || '') + '/ai',
        toolName: 'Integral Calculator',
        extractionPrompt:
            'You are a math problem extractor for an integral calculator.\n' +
            'Given OCR text from a math image, extract ALL integration problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "latex": the integrand ONLY in LaTeX (NOT the full integral, just f(x)). Examples: "x^{2}", "\\sin(x)", "\\frac{1}{x}", "x e^{x}"\n' +
            '  - "variable": the integration variable (default "x")\n' +
            '  - "type": "definite" or "indefinite"\n' +
            '  - "lower": lower bound in LaTeX (only if definite, e.g. "0", "1", "\\pi", "\\infty")\n' +
            '  - "upper": upper bound in LaTeX (only if definite)\n' +
            '  - "display": the full integral in LaTeX for display (e.g. "\\int_0^1 x^{2} dx")\n\n' +
            'CRITICAL RULES:\n' +
            '- Extract ONLY the problems to solve, NOT the solutions.\n' +
            '- "latex" must be ONLY the integrand (the function being integrated), NOT the \\int or dx part.\n' +
            '- Keep LaTeX notation as-is: \\frac, \\sin, \\cos, \\sqrt, \\ln, \\pi, \\infty, ^{}, _{}.\n' +
            '- Do NOT convert to calculator format. Return raw LaTeX.\n' +
            '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
            '- If no problems found, return []\n\n' +
            'Example:\n' +
            'Input: "Evaluate: $\\int_{0}^{1} x^{2} dx$ and $\\int \\sin(x) dx$"\n' +
            'Output: [{"latex":"x^{2}","variable":"x","type":"definite","lower":"0","upper":"1","display":"\\\\int_{0}^{1} x^{2} dx"},{"latex":"\\\\sin(x)","variable":"x","type":"indefinite","display":"\\\\int \\\\sin(x) dx"}]',
        onSelect: function (problem) {
            // Convert LaTeX integrand → calculator expression
            var expr = latexToCalcExpr(problem.latex || problem.expr || '');
            var lower = latexToCalcExpr(problem.lower || '');
            var upper = latexToCalcExpr(problem.upper || '');

            // Fill expression
            var exprInput = document.getElementById('ic-expr');
            if (exprInput && expr) {
                exprInput.value = expr;
                exprInput.dispatchEvent(new Event('input', { bubbles: true }));
            }

            // Set mode
            if (problem.type === 'definite') {
                var defBtn = document.querySelector('.ic-mode-btn[data-mode="definite"]');
                if (defBtn) defBtn.click();
                var lowerInput = document.getElementById('ic-lower');
                var upperInput = document.getElementById('ic-upper');
                if (lowerInput && lower) lowerInput.value = lower;
                if (upperInput && upper) upperInput.value = upper;
            } else {
                var indefBtn = document.querySelector('.ic-mode-btn[data-mode="indefinite"]');
                if (indefBtn) indefBtn.click();
            }

            // Set variable
            if (problem.variable && problem.variable !== 'x') {
                var varSelect = document.getElementById('ic-var');
                if (varSelect) varSelect.value = problem.variable;
            }

            // Auto-trigger integration
            setTimeout(function () {
                var intBtn = document.getElementById('ic-integrate-btn');
                if (intBtn) intBtn.click();
            }, 300);
        },
        onSolveAll: function (problems) {
            batchSolveIntegrals(problems);
        }
    });

    // ═══════════════════════════════════════════════════════════
    // Batch Solve — solves multiple integrals via SymPy and
    // displays results in a modal. No UI input required.
    // ═══════════════════════════════════════════════════════════

    function batchSolveIntegrals(problems) {
        var ic = window.IC;
        if (!ic) return;

        // Build the results modal
        var existing = document.getElementById('itm-results-overlay');
        if (existing) existing.remove();

        var ov = document.createElement('div');
        ov.id = 'itm-results-overlay';
        ov.className = 'itm-results-overlay';
        ov.innerHTML =
            '<div class="itm-results-modal">' +
            '  <div class="itm-results-header">' +
            '    <span class="itm-results-title">Solving ' + problems.length + ' Problem' + (problems.length > 1 ? 's' : '') + '</span>' +
            '    <button class="itm-close" id="itm-results-close">&times;</button>' +
            '  </div>' +
            '  <div class="itm-results-body" id="itm-results-body"></div>' +
            '  <div class="itm-results-footer">' +
            '    <button class="itm-btn" id="itm-results-done">Close</button>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(ov);
        ov.style.display = 'flex';
        document.body.style.overflow = 'hidden';

        var closeResults = function () {
            ov.style.display = 'none';
            document.body.style.overflow = '';
            ov.remove();
        };
        document.getElementById('itm-results-close').addEventListener('click', closeResults);
        document.getElementById('itm-results-done').addEventListener('click', closeResults);
        ov.addEventListener('click', function (e) { if (e.target === ov) closeResults(); });

        var body = document.getElementById('itm-results-body');

        // Render cards (all pending)
        problems.forEach(function (p, i) {
            var display = p.display || p.latex || p.expr || '';
            var card = document.createElement('div');
            card.className = 'itm-result-card';
            card.id = 'itm-rc-' + i;
            card.innerHTML =
                '<div class="itm-result-card-header">' +
                '  <span class="itm-result-num">' + (i + 1) + '</span>' +
                '  <span class="itm-result-problem" id="itm-rp-' + i + '">' + ic.escapeHtml(display) + '</span>' +
                '  <span class="itm-result-status pending" id="itm-rs-' + i + '">Pending</span>' +
                '</div>' +
                '<div class="itm-result-card-body" id="itm-rb-' + i + '"></div>';
            body.appendChild(card);

            // Try KaTeX for the problem display
            if (window.katex) {
                try {
                    katex.render(display, document.getElementById('itm-rp-' + i), { throwOnError: false, displayMode: false });
                } catch (e) { /* keep text */ }
            }
        });

        // Solve sequentially
        solveNext(problems, 0, ic);
    }

    function solveNext(problems, idx, ic) {
        if (idx >= problems.length) return;

        var p = problems[idx];
        var card = document.getElementById('itm-rc-' + idx);
        var status = document.getElementById('itm-rs-' + idx);
        var bodyEl = document.getElementById('itm-rb-' + idx);

        // Mark solving
        card.className = 'itm-result-card solving';
        status.className = 'itm-result-status solving';
        status.textContent = 'Solving...';
        bodyEl.innerHTML = '<div class="itm-spinner"></div>';

        // Scroll card into view
        card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

        // We now send raw LaTeX to SymPy's parse_latex(backend='lark') and let
        // it derive the expr / variable / bounds / definite-ness. No more
        // client-side latexToCalcExpr → nerdamerToPython → boundToSympy chain
        // for the batch path. One authoritative LaTeX parser.
        //
        // Prefer p.display (full integral LaTeX from the AI). If the AI didn't
        // emit it, synthesise one from (latex, lower, upper, variable, type).
        var displayLatex = p.display;
        if (!displayLatex) {
            var _v = p.variable || 'x';
            var _l = p.latex || p.expr || 'x';
            if (p.type === 'definite' && p.lower != null && p.upper != null) {
                displayLatex = '\\int_{' + p.lower + '}^{' + p.upper + '} ' + _l + '\\, d' + _v;
            } else {
                displayLatex = '\\int ' + _l + '\\, d' + _v;
            }
        }
        var isDefinite = p.type === 'definite' && p.lower != null && p.upper != null;
        // Escape closing triple-quote for the Python raw-string literal.
        var pyLiteral = displayLatex.replace(/"""/g, '\\"\\"\\"');

        var code = ic.buildR2sPreamble(!isDefinite) +
            'from sympy.parsing.latex import parse_latex\n' +
            'import re, signal\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            '# Clean LaTeX for parse_latex: strip sizing commands it cannot handle\n' +
            'LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", LATEX)\n' +
            'try:\n' +
            '    parsed = parse_latex(LATEX)\n' +
            'except Exception:\n' +
            '    try:\n' +
            '        parsed = parse_latex(LATEX, backend="lark")\n' +
            '    except Exception as e:\n' +
            '        raise ValueError("Could not parse LaTeX: " + str(e)[:80])\n' +
            'if getattr(parsed, "data", None) == "_ambig":\n' +
            '    cands = [c for c in parsed.children if isinstance(c, Integral)]\n' +
            '    parsed = cands[0] if cands else parsed.children[0]\n' +
            'if not isinstance(parsed, Integral):\n' +
            '    raise ValueError("Not a full integral expression")\n' +
            'expr = simplify(parsed.function)\n' +
            '# parse_latex treats e as Symbol; replace with Euler number E\n' +
            'expr = expr.subs(Symbol("e"), E)\n' +
            'limits = parsed.limits[0]\n' +
            'v = limits[0]\n' +
            'is_def = len(limits) == 3\n' +
            'try:\n' +
            '    if expr.has(Sum):\n' +
            '        expr = expr.doit(deep=True)\n' +
            'except Exception:\n' +
            '    pass\n' +
            'try:\n    _s_obj = integral_steps(expr, v)\nexcept:\n    _s_obj = None\n' +
            'def _timeout(s, f): raise TimeoutError\n' +
            'signal.signal(signal.SIGALRM, _timeout)\n' +
            'signal.alarm(10)\n' +
            'try:\n' +
            '    antideriv = integrate(expr, v)\n' +
            'except (TimeoutError, Exception):\n' +
            '    antideriv = Integral(expr, v)\n' +
            'finally:\n' +
            '    signal.alarm(0)\n' +
            'if is_def:\n' +
            '    a = limits[1]; b = limits[2]\n' +
            '    if isinstance(antideriv, Integral):\n' +
            '        result = Integral(expr, (v, a, b))\n' +
            '        print("LATEX:" + latex(result))\n' +
            '        print("TEXT:" + str(result))\n' +
            '        print("ANTIDERIV:")\n' +
            '        try:\n' +
            '            from scipy.integrate import quad as _quad\n' +
            '            from math import isfinite as _isf\n' +
            '            _f = lambdify(v, expr, "numpy")\n' +
            '            _val, _err = _quad(_f, float(a), float(b), limit=100)\n' +
            '            if not _isf(_val) or (abs(_val) > 1e-10 and abs(_err/_val) > 0.01):\n' +
            '                raise ValueError("divergent")\n' +
            '            print("NUMERIC:" + str(_val))\n' +
            '        except:\n' +
            '            print("NUMERIC:NaN")\n' +
            '        print("STEPS:" + json.dumps([\n' +
            '            {"title":"Integral","latex":"\\\\int_{"+latex(a)+"}^{"+latex(b)+"} "+latex(expr)+"\\\\,d"+str(v)},\n' +
            '            {"title":"No closed-form antiderivative","latex":"\\\\text{Evaluated numerically}"}\n' +
            '        ]))\n' +
            '    else:\n' +
            '        result = integrate(expr, (v, a, b))\n' +
            '        print("LATEX:" + latex(result))\n' +
            '        print("TEXT:" + str(result))\n' +
            '        print("ANTIDERIV:" + latex(antideriv))\n' +
            '        try:\n' +
            '            print("NUMERIC:" + str(float(result)))\n' +
            '        except:\n' +
            '            print("NUMERIC:NaN")\n' +
            '        st = []\n' +
            '        if _s_obj and not isinstance(_s_obj, DontKnowRule):\n' +
            '            st = r2s(_s_obj, v)\n' +
            '        if not st:\n' +
            '            st.append({"title":"Antiderivative","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)+" = "+latex(antideriv)+" + C"})\n' +
            '        try:\n' +
            '            def _ev(bound):\n' +
            '                if bound == oo: return limit(antideriv, v, oo)\n' +
            '                if bound == -oo: return limit(antideriv, v, -oo)\n' +
            '                return antideriv.subs(v, bound)\n' +
            '            v_u = _ev(b); v_l = _ev(a)\n' +
            '            a_tex = "\\\\infty" if a == oo else ("-\\\\infty" if a == -oo else latex(a))\n' +
            '            b_tex = "\\\\infty" if b == oo else ("-\\\\infty" if b == -oo else latex(b))\n' +
            '            ev_latex = r"\\left[ " + latex(antideriv) + r" \\right]_{" + a_tex + "}^{" + b_tex + "} = " + latex(v_u) + " - (" + latex(v_l) + ") = " + latex(result)\n' +
            '            st.append({"title":"Evaluate at bounds","latex":ev_latex})\n' +
            '        except:\n' +
            '            st.append({"title":"Evaluate at bounds","latex":"\\\\left["+latex(antideriv)+"\\\\right]_{"+latex(a)+"}^{"+latex(b)+"} = "+latex(result)})\n' +
            '        print("STEPS:" + json.dumps(st))\n' +
            'else:\n' +
            '    result = antideriv\n' +
            '    print("LATEX:" + latex(result))\n' +
            '    print("TEXT:" + str(result))\n' +
            '    st = []\n' +
            '    if not isinstance(result, Integral) and not result.has(Integral):\n' +
            '        if _s_obj and not isinstance(_s_obj, DontKnowRule):\n' +
            '            st = r2s(_s_obj, v)\n' +
            '        if not st:\n' +
            '            st.append({"title":"Result","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)+" = "+latex(result)+" + C"})\n' +
            '    elif isinstance(result, Integral) or result.has(Integral):\n' +
            '        st.append({"title":"Identify the integral","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)})\n' +
            '        st.append({"title":"Conclusion","latex":"\\\\text{This integral cannot be expressed using elementary functions.}"})\n' +
            '    print("STEPS:" + json.dumps(st))\n';

        fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();

            if (!stdout && stderr) throw new Error(stderr.split('\n').pop() || 'Solver error');
            if (!stdout) throw new Error('No result from solver');

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            var numericMatch = stdout.match(/NUMERIC:([^\n]*)/);
            var antiderivMatch = stdout.match(/ANTIDERIV:([^\n]*)/);
            var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?:\n|$)/);
            var resultTeX = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultTeX;
            var antiderivLatex = antiderivMatch ? antiderivMatch[1].trim() : '';
            var hasNumeric = numericMatch && numericMatch[1].trim() !== 'NaN' && numericMatch[1].trim() !== '';

            // Check for unevaluated Integral — allow through if we have numeric value
            if (resultTeX.indexOf('Integral') !== -1 && !hasNumeric) {
                throw new Error('Could not solve this integral');
            }

            // Build result HTML
            var html = '';
            if (isDefinite) {
                var numVal = numericMatch ? parseFloat(numericMatch[1].trim()) : NaN;
                html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
                html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';
                if (isFinite(numVal)) {
                    html += '<div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.25rem;">&asymp; ' + ic.escapeHtml(numVal.toFixed(6)) + '</div>';
                }
            } else {
                html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
                html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';
            }

            // Steps toggle
            var steps = [];
            if (stepsMatch) { try { steps = JSON.parse(stepsMatch[1]); } catch (e) {} }
            if (steps.length) {
                html += '<button class="itm-result-steps-btn" data-steps-idx="' + idx + '">Show Steps</button>';
                html += '<div class="itm-result-steps-area" id="itm-rsa-' + idx + '">';
                steps.forEach(function (s) {
                    html += '<div class="itm-result-step"><div class="itm-result-step-title">' + ic.escapeHtml(s.title) + '</div><div id="itm-rst-' + idx + '-' + Math.random().toString(36).substr(2, 5) + '" data-step-katex="' + ic.escapeHtml(s.latex).replace(/"/g, '&quot;') + '"></div></div>';
                });
                html += '</div>';
            }

            bodyEl.innerHTML = html;

            // KaTeX render
            if (window.katex) {
                var integralEl = document.getElementById('itm-ri-' + idx);
                var answerEl = document.getElementById('itm-ra-' + idx);
                if (integralEl) {
                    try {
                        var integralTeX = isDefinite
                            ? '\\int_{' + (latexToCalcExpr(p.lower)||'0') + '}^{' + (latexToCalcExpr(p.upper)||'1') + '} ' + ic.exprToLatex(expr) + ' \\, d' + v
                            : '\\int ' + ic.exprToLatex(expr) + ' \\, d' + v;
                        katex.render(integralTeX, integralEl, { throwOnError: false, displayMode: false });
                    } catch (e) {}
                }
                if (answerEl) {
                    try {
                        var ansTeX = isDefinite ? resultTeX : resultTeX + ' + C';
                        katex.render('= ' + ic.prepareLatexForKatex(ansTeX), answerEl, { throwOnError: false, displayMode: true });
                    } catch (e) { answerEl.textContent = '= ' + resultText; }
                }
                // Render step equations (normalize \\cmd → \cmd for KaTeX)
                bodyEl.querySelectorAll('[data-step-katex]').forEach(function (el) {
                    var raw = el.getAttribute('data-step-katex');
                    var tex = ic.prepareLatexForKatex(raw);
                    try { katex.render(tex, el, { throwOnError: false, displayMode: true }); }
                    catch (e) { el.textContent = raw; }
                });
            }

            // Wire steps toggle
            var stepsBtn = bodyEl.querySelector('[data-steps-idx="' + idx + '"]');
            if (stepsBtn) {
                stepsBtn.addEventListener('click', function () {
                    var area = document.getElementById('itm-rsa-' + idx);
                    if (area) {
                        area.classList.toggle('open');
                        stepsBtn.textContent = area.classList.contains('open') ? 'Hide Steps' : 'Show Steps';
                    }
                });
            }

            // Mark done
            card.className = 'itm-result-card solved';
            status.className = 'itm-result-status done';
            status.textContent = 'Solved';
        })
        .catch(function (err) {
            card.className = 'itm-result-card error';
            status.className = 'itm-result-status fail';
            status.textContent = 'Failed';
            bodyEl.innerHTML = '<div class="itm-result-error-msg">' + ic.escapeHtml(err.message) + '</div>';
        })
        .finally(function () {
            // Solve next
            solveNext(problems, idx + 1, ic);
        });
    }

    /**
     * Convert LaTeX → calculator expression.
     *
     * We no longer maintain a hand-rolled regex pipeline. MathLive (already
     * loaded on the page) ships a battle-tested LaTeX parser that can re-emit
     * its AST as AsciiMath, which is exactly the dialect our calculator
     * speaks. We use an off-screen read-only <math-field> as a thin adapter:
     *
     *     LaTeX  --(mf.setValue, format:'latex')-->  MathLive AST
     *     calc-expr  <--(mf.getValue, 'ascii-math')--+
     *
     * Then normalizeExpr canonicalises implicit multiplication, shorthand
     * forms, and the infty→Infinity mapping.
     *
     * Called from the image-scan flow (onSelect, batchSolveIntegrals) and
     * the batch KaTeX render for bounds. Gracefully degrades to a tiny
     * string-strip if MathLive hasn't upgraded yet (rare — ESM loads in <head>).
     */
    var _latexParserMF = null;
    function latexToCalcExpr(latex) {
        if (!latex || typeof latex !== 'string') return '';
        var tex = latex.trim();
        if (!tex) return '';

        if (!(window.customElements && customElements.get('math-field'))) {
            // Pre-upgrade fallback: cover the handful of symbols most AI
            // extractions emit for plain bounds ("0", "1", "\\pi", "\\infty").
            return tex.replace(/\\pi\b/g, 'pi')
                      .replace(/\\(?:infty|infinity)\b/g, 'Infinity')
                      .replace(/[{}\\]/g, '');
        }

        try {
            if (!_latexParserMF) {
                _latexParserMF = document.createElement('math-field');
                _latexParserMF.setAttribute('read-only', '');
                _latexParserMF.style.cssText =
                    'position:absolute;left:-9999px;top:-9999px;width:1px;height:1px;' +
                    'visibility:hidden;pointer-events:none;opacity:0;';
                document.body.appendChild(_latexParserMF);
            }
            _latexParserMF.setValue(tex, { format: 'latex', silenceNotifications: true });
            var ascii = '';
            try { ascii = (_latexParserMF.getValue('ascii-math') || '').trim(); } catch (_) {}
            if (!ascii) return '';

            if (typeof IntegralCalculatorCore !== 'undefined' && IntegralCalculatorCore.normalizeExpr) {
                ascii = IntegralCalculatorCore.normalizeExpr(ascii);
            }
            return ascii;
        } catch (_) {
            return '';
        }
    }

    /**
     * Parse a full-integral LaTeX or AsciiMath expression via the backend.
     *
     * No client-side regex. The backend runs SymPy's parse_latex(backend='lark')
     * which is the authoritative reference implementation — whatever shape the
     * user pastes (textbook LaTeX, MathLive export with \differentialD, ASCII
     * "int_0^10 ... dx"), if SymPy can parse it, we can use it.
     *
     * Callback receives { ok, integrand, variable, is_definite, lower?, upper? }
     * on success, or { ok: false, error } on parse failure. Integrand and bounds
     * are returned in calculator-friendly plain-text form (** → ^, so the
     * existing Nerdamer / normalizeExpr path consumes them unchanged).
     */
    function parseIntegralViaBackend(raw, callback) {
        var s = (raw || '').trim();
        if (!s) { callback({ ok: false, error: 'empty input' }); return; }

        // Escape for a Python raw-triple-quoted string literal. The only char
        // we have to fear is a closing triple-quote sequence, which SymPy's
        // integrand alphabet essentially never contains, but guard anyway.
        var pyLiteral = s.replace(/"""/g, '\\"\\"\\"');

        var code =
            'import json, re, sys\n' +
            'from sympy.parsing.latex import parse_latex\n' +
            'from sympy import Integral\n' +
            '\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            '# Strip sizing commands parse_latex cannot handle\n' +
            'LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", LATEX)\n' +
            'out = {"ok": False}\n' +
            'try:\n' +
            '    try:\n' +
            '        parsed = parse_latex(LATEX)\n' +
            '    except Exception:\n' +
            '        parsed = parse_latex(LATEX, backend="lark")\n' +
            '    # lark can return a Tree(_ambig, [option1, option2, ...]) when\n' +
            '    # the grammar is ambiguous (e.g. f(x) could be call-or-product).\n' +
            '    # Pick the first Integral child if present, else the first child.\n' +
            '    if getattr(parsed, "data", None) == "_ambig":\n' +
            '        cands = [c for c in parsed.children if isinstance(c, Integral)]\n' +
            '        parsed = cands[0] if cands else parsed.children[0]\n' +
            '    if not isinstance(parsed, Integral):\n' +
            '        out["error"] = "Not a full integral expression"\n' +
            '    else:\n' +
            '        expr = parsed.function.subs(Symbol("e"), E)\n' +
            '        limits = parsed.limits[0]\n' +
            '        # SymPy str() uses **, Python-style; calculator uses ^.\n' +
            '        def asc(s): return str(s).replace("**", "^")\n' +
            '        out = {\n' +
            '            "ok": True,\n' +
            '            "integrand": asc(expr),\n' +
            '            "variable": str(limits[0]),\n' +
            '            "is_definite": len(limits) == 3,\n' +
            '        }\n' +
            '        if len(limits) == 3:\n' +
            '            out["lower"] = asc(limits[1])\n' +
            '            out["upper"] = asc(limits[2])\n' +
            'except Exception as e:\n' +
            '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}\n' +
            'print("RESULT:" + json.dumps(out))\n';

        fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var m = stdout.match(/RESULT:(\{[\s\S]*\})/);
            if (!m) {
                callback({ ok: false, error: 'no backend response' });
                return;
            }
            try { callback(JSON.parse(m[1])); }
            catch (e) { callback({ ok: false, error: 'bad backend JSON' }); }
        })
        .catch(function (err) {
            callback({ ok: false, error: err.message || 'network error' });
        });
    }

    // Shape detector: "is this a full integral the user wants us to solve?"
    // Intentionally minimal — we don't PARSE here, just decide whether to
    // route the request to the backend parse_latex. Any shape this gate
    // misses stays on the normal (typed-integrand) path, which is fine.
    function looksLikeLatexIntegral(s) {
        if (!s || typeof s !== 'string') return false;
        return /\\int\b/.test(s)                 // LaTeX \int
            || /^\s*int(?=[_^\s(]|$)/i.test(s);  // AsciiMath int, int_, int^, int(
    }

    if (window.IC) {
        window.IC.parseIntegralViaBackend = parseIntegralViaBackend;
        window.IC.looksLikeLatexIntegral = looksLikeLatexIntegral;
    }
</script>
