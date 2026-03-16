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
    //  $ KEY TRIGGER (on editor ready)
    //  Single $ → inline math, Double $$ → block math
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

            if (now - lastDollarTime < 400) {
                // Double $$ → block math
                e.preventDefault();
                lastDollarTime = 0;
                insertMathNode('mathBlock');
                return;
            }

            // First $ → wait to see if $$ follows
            e.preventDefault();
            lastDollarTime = now;
            setTimeout(function () {
                if (lastDollarTime === 0) return; // consumed by $$
                lastDollarTime = 0;
                insertMathNode('mathInline');
            }, 250);
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
