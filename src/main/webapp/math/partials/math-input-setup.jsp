<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    math-input-setup.jsp — shared MathLive visual math input + mode toggle.

    Two shared pieces every math tool wanting a Visual/Text input toggle
    needs:
      1. MathLive ES-module import + calculus-first "Calc" virtual keyboard.
         The <math-field> custom element is registered globally, so any
         tool that drops a <math-field> into the DOM gets it.
      2. A ~200-line IIFE that keeps <math-field> ↔ <input> in sync, handles
         the Visual/Text mode toggle, and auto-switches to Text when the
         ascii-math parser would mangle the expression (SymPy Sum(...),
         Max(...) etc.).

    MARKUP CONTRACT — every tool page that includes this file MUST expose
    these element IDs (shared across all math tools):

        #ic-expr              — plain text <input> (the canonical value)
        #ic-mathfield         — <math-field> visual input
        #ic-expr-wrap         — wrapper around both inputs
        #ic-input-mode-toggle — segment control with .ic-input-mode-btn
                                children (data-input-mode="visual" / "text")

    The Enter-to-submit binding looks up the primary CTA by the class
    `.ic-hero-cta` (see `math-studio.css`) — make sure your tool's primary
    button carries that class.  The `ic-` prefix is historical (came from
    integral-calculator) — it's now the shared math-input contract.

    Usage — place at the END of <body>, AFTER math-libs.jsp and the tool's
    own scripts partial:

        <jsp:include page="/math/partials/math-libs.jsp" />
        <jsp:include page="/math/partials/<tool>-calculator-scripts.jsp" />
        <jsp:include page="/math/partials/math-input-setup.jsp" />
--%>

<!-- ── 1. MathLive ES module + calculus-first virtual keyboard ── -->
<script type="module">
    import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';
    if (window.MathfieldElement) {
        window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
        try { window.MathfieldElement.soundsDirectory = null; } catch (e) {}
    }

    /*
     * Calc keyboard — 4 rows × 10 keycaps tuned for calculus integrands:
     *   Row 1:  vars (x y t n) · constants (pi e ∞) · nav (← → ⌫)
     *   Row 2:  digits 1-5 · + − · / · frac · x^n
     *   Row 3:  digits 6-9,0 · ( ) · x² · √ · 1/x · undo
     *   Row 4:  sin cos tan · ln log e^x · arctan arcsin arccos · ↵
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

<!-- ── 2. Mode-toggle IIFE — syncs <math-field> ↔ <input>, handles
        Visual/Text toggle, seeds math-field from programmatic writes,
        falls back to Text mode when the expression can't render. ── -->
<script>
(function () {
    'use strict';

    var mf        = document.getElementById('ic-mathfield');
    var exprInput = document.getElementById('ic-expr');
    var wrap      = document.getElementById('ic-expr-wrap');
    var toggle    = document.getElementById('ic-input-mode-toggle');
    if (!mf || !exprInput || !toggle) return;

    // Virtual-keyboard policy: "manual" — keyboard does NOT auto-open on
    // focus.  Users summon it via the explicit toggle in the math-field's
    // own chrome (the small keyboard glyph at the right edge), which is
    // less intrusive on desktop typing and clearer for touch users.
    // Set BOTH the attribute (observed by MathLive) AND the property
    // (newer API) so we work across MathLive minor versions.
    mf.setAttribute('math-virtual-keyboard-policy', 'manual');
    try { mf.mathVirtualKeyboardPolicy = 'manual'; } catch (e) {}

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

    var initial = 'visual';
    try {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'text') initial = 'text';
    } catch (e) {}
    setMode(initial);

    // SymPy-style constructs that have no visual math representation.
    function isAdvancedSympy(expr) {
        if (!expr) return false;
        if (/^\s*(Sum|Max|Min|Integral|Product|Rational)\s*\(/i.test(expr)) return true;
        if (/,\s*\([^)]*\)\s*$/.test(expr)) return true;
        return false;
    }

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
            if (!seedMathField(exprInput.value)) return; // can't render — refuse
            setMode('visual');
            try { mf.focus(); } catch (_) {}
        } else {
            setMode('text');
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
            try { exprInput.focus(); } catch (_) {}
        }
    });

    // ---------- Programmatic #ic-expr writes mirror into math-field ----------
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

    // ---------- Wire once the <math-field> custom element upgrades ----------
    function wire() {
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

        // Visual → Text (one-way, native-setter bypass + dispatch 'input')
        mf.addEventListener('input', function () {
            if (getMode() !== 'visual') return;
            var ascii = '';
            try { ascii = (mf.getValue('ascii-math') || '').trim(); } catch (_) {}
            if (exprInput.value === ascii) return;
            setExprRaw(ascii);
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
        });

        // Enter submits the tool's primary CTA.  We query by `.ic-hero-cta`
        // (shared class across every math tool) so this works regardless of
        // the button's tool-specific id (`ic-integrate-btn`, `ic-differentiate-btn`...).
        mf.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                var cta = document.querySelector('.ic-hero-cta');
                if (cta) cta.click();
            }
        });

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
