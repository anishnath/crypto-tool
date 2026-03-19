/**
 * mathlive-init.js — $ trigger + math insertion API
 * TipTap-based Math Editor with live MathLive editing
 *
 * This file handles:
 *   - Single $ → insert inline math node + focus it
 *   - Double $$ → insert block math node + focus it
 *   - Global MeMath API (used by toolbar.js, slash-menu.js, editor-core.js)
 */
(function () {
    'use strict';

    function insertMathNode(type) {
        var editor = window.MeEditor;
        if (!editor) return;

        // Insert the math node
        editor.chain().focus().insertContent({ type: type, attrs: { latex: '' } }).run();

        // After insertContent of an atom, cursor is right after it.
        // Walk backward to find the just-inserted node and set NodeSelection on it.
        // NodeSelection triggers the NodeView's selectNode() → mf.focus()
        var doc = editor.state.doc;
        var pos = editor.state.selection.from;
        for (var p = pos - 1; p >= Math.max(0, pos - 10); p--) {
            var node = doc.nodeAt(p);
            if (node && node.type.name === type) {
                editor.commands.setNodeSelection(p);
                return;
            }
        }
    }

    // =========================================================
    //  INLINE HINT: "$ again for display math" (MAJOR 1.2/3.2)
    // =========================================================
    function showDollarHint() {
        // Remove any existing hint
        var existing = document.querySelector('.me-dollar-hint');
        if (existing) existing.remove();

        var sel = window.getSelection();
        if (!sel || !sel.rangeCount) return;
        var rect = sel.getRangeAt(0).getBoundingClientRect();
        if (!rect.top && !rect.bottom) return;

        var hint = document.createElement('span');
        hint.className = 'me-dollar-hint';
        hint.textContent = '$ again for display math';
        hint.style.cssText = 'position:fixed;z-index:9999;pointer-events:none;' +
            'padding:2px 8px;font-size:11px;color:#6b7280;background:#f3f4f6;' +
            'border:1px solid #e5e7eb;border-radius:4px;white-space:nowrap;' +
            'opacity:1;transition:opacity 0.15s;';
        hint.style.top = (rect.top - 24) + 'px';
        hint.style.left = rect.left + 'px';
        document.body.appendChild(hint);

        setTimeout(function () {
            hint.style.opacity = '0';
            setTimeout(function () { if (hint.parentNode) hint.remove(); }, 150);
        }, 350);
    }

    function removeDollarHint() {
        var hint = document.querySelector('.me-dollar-hint');
        if (hint) hint.remove();
    }

    // =========================================================
    //  SHIFT+ENTER HINT (MAJOR 1.4)
    // =========================================================
    var MATH_HINT_MAX_SHOWS = 5;
    var MATH_HINT_KEY = 'me_math_hint_count';

    function showMathBlockHint(mathFieldEl) {
        var count = parseInt(localStorage.getItem(MATH_HINT_KEY) || '0', 10);
        if (count >= MATH_HINT_MAX_SHOWS) return;

        // Don't show if one already visible
        if (document.querySelector('.me-math-eval-hint')) return;

        var rect = mathFieldEl.getBoundingClientRect();
        if (!rect.bottom) return;

        var hint = document.createElement('div');
        hint.className = 'me-math-eval-hint';
        hint.textContent = 'Shift+Enter to evaluate \u2022 Enter to exit';
        hint.style.cssText = 'position:fixed;z-index:9999;pointer-events:none;' +
            'padding:3px 10px;font-size:11px;color:#6b7280;background:#f9fafb;' +
            'border:1px solid #e5e7eb;border-radius:4px;white-space:nowrap;' +
            'opacity:1;transition:opacity 0.3s;';
        hint.style.top = (rect.bottom + 4) + 'px';
        hint.style.left = rect.left + 'px';
        document.body.appendChild(hint);

        localStorage.setItem(MATH_HINT_KEY, String(count + 1));

        setTimeout(function () {
            hint.style.opacity = '0';
            setTimeout(function () { if (hint.parentNode) hint.remove(); }, 300);
        }, 3000);
    }

    // =========================================================
    //  $ KEY TRIGGER (on editor ready)
    //  Single $ → inline math, Double $$ → block math
    //  Timings: 500ms double-$ window, 350ms single-$ commit (MAJOR 1.2/3.2)
    // =========================================================
    document.addEventListener('me:editor-ready', function () {
        var editor = window.MeEditor;
        if (!editor) return;

        var lastDollarTime = 0;
        var editorEl = document.querySelector('.me-canvas .ProseMirror');
        if (!editorEl) return;

        editorEl.addEventListener('keydown', function (e) {
            if (e.key !== '$') return;
            // Don't trigger inside math-field elements
            if (e.target.closest && e.target.closest('math-field')) return;

            var now = Date.now();

            if (now - lastDollarTime < 500) {
                // Double $$ → block math
                e.preventDefault();
                lastDollarTime = 0;
                removeDollarHint();
                insertMathNode('mathBlock');
                return;
            }

            // First $ → wait to see if $$ follows
            e.preventDefault();
            lastDollarTime = now;
            showDollarHint();
            setTimeout(function () {
                if (lastDollarTime === 0) return; // consumed by $$
                lastDollarTime = 0;
                removeDollarHint();
                insertMathNode('mathInline');
            }, 350);
        });

        // Shift+Enter hint on math-field focus (MAJOR 1.4)
        editorEl.addEventListener('focusin', function (e) {
            var mf = e.target.closest && e.target.closest('math-field');
            if (mf) {
                requestAnimationFrame(function () { showMathBlockHint(mf); });
            }
        });
    });

    // =========================================================
    //  EXPOSE GLOBAL API
    // =========================================================
    window.MeMath = {
        insertBlock:  function () { insertMathNode('mathBlock'); },
        insertInline: function () { insertMathNode('mathInline'); }
    };

})();
