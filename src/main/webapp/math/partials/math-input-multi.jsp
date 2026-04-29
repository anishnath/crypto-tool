<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    math-input-multi.jsp — multi-pair Visual/Text math input.

    The original math-input-setup.jsp is hardcoded to ONE input pair
    by ID (#ic-mathfield + #ic-expr).  For tools like series-calculator
    (1 expression input + many scalar params) and vector-calculus
    (1 scalar OR 3 vector-component inputs depending on mode), we need
    to wire MULTIPLE math-field/text-input pairs, controlled by ONE
    Visual/Text toggle.

    MARKUP CONTRACT — each tool page that includes this file MUST:

      For every input the user can type a math expression into, wrap it
      in an .mml-pair element containing both the math-field AND the
      text input.  The math-field carries class .mml-mathfield and the
      text input carries class .mml-text.  Example:

        <div class="mml-pair">
            <math-field class="mml-mathfield"
                        smart-mode="on" smart-fence="on"
                        placeholder="\sin(x)/x"></math-field>
            <input type="text" class="mml-text tool-input tool-input-mono"
                   id="my-tool-expr-input"
                   placeholder="e.g. sin(x)/x">
        </div>

      Place ONE Visual/Text segment control with `data-mml-toggle`
      somewhere on the page:

        <div class="ic-input-mode-toggle" data-mml-toggle role="radiogroup">
            <button type="button" class="ic-input-mode-btn active"
                    data-input-mode="visual" role="radio">Visual</button>
            <button type="button" class="ic-input-mode-btn"
                    data-input-mode="text" role="radio">Text</button>
        </div>

      Mark the primary CTA button with `data-mml-submit` so Enter inside
      any math-field triggers it:

        <button id="my-tool-solve-btn" data-mml-submit>Solve</button>

    The IIFE handles the rest:
      · Sync each math-field ↔ its text input (both directions)
      · Hook each text input's .value setter so programmatic writes
        (palette buttons, example chips, image-scan results) mirror
        back into the math-field
      · One global Visual/Text mode shared across all pairs, persisted
        in localStorage as 'mml.inputMode'
      · Falls back to Text mode automatically when MathLive fails to
        load (offline / blocked CDN), and disables the Visual button
--%>

<!-- ── 1. MathLive ES module + calculus-first virtual keyboard ── -->
<%-- Imported only once per page; if math-input-setup.jsp is also on the
     page (it shouldn't be — pick one or the other), the second import
     is a no-op thanks to ES module caching. --%>
<script type="module">
    import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';
    if (window.MathfieldElement) {
        window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
        try { window.MathfieldElement.soundsDirectory = null; } catch (e) {}
    }
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

<!-- ── 2. Multi-pair sync IIFE ── -->
<script>
(function () {
    'use strict';

    var STORAGE_KEY = 'mml.inputMode';

    var pairEls = document.querySelectorAll('.mml-pair');
    if (!pairEls.length) return;

    var pairs = [];
    pairEls.forEach(function (pair) {
        var mf    = pair.querySelector('math-field, .mml-mathfield');
        var input = pair.querySelector('input.mml-text');
        if (!mf || !input) return;
        // Virtual-keyboard policy: don't auto-pop on focus.
        try { mf.setAttribute('math-virtual-keyboard-policy', 'manual'); } catch (e) {}
        try { mf.mathVirtualKeyboardPolicy = 'manual'; } catch (e) {}
        pairs.push({ pair: pair, mf: mf, input: input });
    });
    if (!pairs.length) return;

    var toggle = document.querySelector('[data-mml-toggle]');
    var submit = document.querySelector('[data-mml-submit]');

    // Native <input>.value setter — bypasses our hook so internal writes
    // (math-field → text mirror) don't recursively mirror back.
    var nativeInputValueSetter = (function () {
        try {
            var d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
            return d && typeof d.set === 'function' ? d.set : null;
        } catch (e) { return null; }
    })();
    function setInputRaw(input, v) {
        if (nativeInputValueSetter) nativeInputValueSetter.call(input, v);
        else input.value = v;
    }

    function getMode() {
        return pairs[0].pair.getAttribute('data-input-mode') || 'visual';
    }
    function setMode(mode) {
        if (mode !== 'visual' && mode !== 'text') mode = 'visual';
        pairs.forEach(function (p) { p.pair.setAttribute('data-input-mode', mode); });
        if (toggle) {
            toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
                var active = btn.getAttribute('data-input-mode') === mode;
                btn.classList.toggle('active', active);
                btn.setAttribute('aria-checked', active ? 'true' : 'false');
            });
        }
        try { localStorage.setItem(STORAGE_KEY, mode); } catch (e) {}
    }

    var initial = 'visual';
    try {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'text') initial = 'text';
    } catch (e) {}
    setMode(initial);

    function isAdvancedSympy(expr) {
        if (!expr) return false;
        if (/^\s*(Sum|Max|Min|Integral|Product|Rational)\s*\(/i.test(expr)) return true;
        if (/,\s*\([^)]*\)\s*$/.test(expr)) return true;
        return false;
    }

    function seedMathField(mf, expr) {
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

    if (toggle) {
        toggle.addEventListener('click', function (e) {
            var btn = e.target.closest('.ic-input-mode-btn');
            if (!btn || btn.disabled) return;
            var next = btn.getAttribute('data-input-mode');
            if (next === getMode()) return;

            if (next === 'visual') {
                // Try to seed every pair — if any one can't render, refuse.
                var allOk = true;
                pairs.forEach(function (p) {
                    if (!seedMathField(p.mf, p.input.value)) allOk = false;
                });
                if (!allOk) return;
                setMode('visual');
                try { pairs[0].mf.focus(); } catch (_) {}
            } else {
                setMode('text');
                pairs.forEach(function (p) {
                    p.input.dispatchEvent(new Event('input', { bubbles: true }));
                });
                try { pairs[0].input.focus(); } catch (_) {}
            }
        });
    }

    pairs.forEach(function (p) {
        // Programmatic writes to text input mirror into the math-field.
        // Captures palette button clicks, example chips, image-scan
        // results — anything that writes the input.value.
        if (nativeInputValueSetter) {
            try {
                var nativeGetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').get;
                Object.defineProperty(p.input, 'value', {
                    configurable: true,
                    enumerable: true,
                    get: function () { return nativeGetter.call(this); },
                    set: function (v) {
                        nativeInputValueSetter.call(this, v);
                        if (getMode() === 'visual') {
                            if (!seedMathField(p.mf, v)) setMode('text');
                        }
                    }
                });
            } catch (e) { /* non-fatal */ }
        }

        function wireOne() {
            try {
                p.mf.inlineShortcuts = Object.assign({}, p.mf.inlineShortcuts || {}, {
                    'atan': '\\arctan',
                    'asin': '\\arcsin',
                    'acos': '\\arccos',
                    'acot': '\\operatorname{arccot}',
                    'asec': '\\operatorname{arcsec}',
                    'acsc': '\\operatorname{arccsc}',
                    'exp':  'e^{#?}',
                    'abs':  '\\left|#?\\right|',
                    'cbrt': '\\sqrt[3]{#?}',
                    'oo':   '\\infty'
                });
            } catch (_) {}

            // Visual → Text mirror
            p.mf.addEventListener('input', function () {
                if (getMode() !== 'visual') return;
                var ascii = '';
                try { ascii = (p.mf.getValue('ascii-math') || '').trim(); } catch (_) {}
                if (p.input.value === ascii) return;
                setInputRaw(p.input, ascii);
                p.input.dispatchEvent(new Event('input', { bubbles: true }));
            });

            // Enter submits the page's primary CTA.
            p.mf.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    if (submit) submit.click();
                }
            });

            if (getMode() === 'visual' && p.input.value) {
                if (!seedMathField(p.mf, p.input.value)) setMode('text');
            }
        }

        if (window.customElements && customElements.get('math-field')) {
            wireOne();
        } else if (window.customElements && customElements.whenDefined) {
            customElements.whenDefined('math-field').then(wireOne).catch(function () {
                // MathLive failed to load — force Text mode + disable Visual button.
                setMode('text');
                if (p.mf && p.mf.parentNode) p.mf.parentNode.removeChild(p.mf);
                if (toggle) toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
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
    });
})();
</script>
