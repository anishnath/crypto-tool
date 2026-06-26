/**
 * Paints the Rust permission layer (from OcOwnership.permissionModel) onto the
 * live Monaco editor — render-only, never touches the model (Run unaffected).
 *
 * This embedding does NOT render Monaco injected text (after/before decorations),
 * so we use only mechanisms that DO render here:
 *   - inline className decorations  -> permission use-sites (red if a required
 *     permission is missing) + borrow-region underlines; full R/W/O on hover.
 *   - glyph-margin marker + hover   -> per-line permission-change table.
 * Runtime L-step → source-line linking is handled in the pane (click a step).
 *
 *   var ov = OcOwnershipOverlay.create({ editor, monaco });
 *   ov.apply(analyzedCode, ownershipJson);  ov.setVisible(false);  ov.clear();
 *   ov.reveal(lineNumber);                  // jump+flash a line (from pane)
 *
 * Aquascope positions are 0-indexed; Monaco is 1-indexed.
 */
(function (global) {
    'use strict';

    function create(opts) {
        var editor = opts.editor;
        var monaco = opts.monaco;
        var decoIds = [];
        var model = null;
        var code = null;
        var visible = false;

        // config.editor can be stale/hidden (IDE recreates it on lang/file switch).
        // Resolve the live editor: content === analyzed snapshot, else first visible.
        function pickEditor() {
            try {
                var eds = (monaco.editor && monaco.editor.getEditors) ? monaco.editor.getEditors() : [];
                if (code != null) {
                    for (var i = 0; i < eds.length; i++) {
                        try { if (eds[i].getValue() === code) return eds[i]; } catch (e) { /* ignore */ }
                    }
                }
                for (var j = 0; j < eds.length; j++) {
                    var n = eds[j].getDomNode && eds[j].getDomNode();
                    if (n && n.offsetParent !== null) return eds[j];
                }
                if (eds.length) return eds[0];
            } catch (e) { /* ignore */ }
            return null;
        }

        function clearDecorations() {
            if (decoIds.length) { try { decoIds = editor.deltaDecorations(decoIds, []); } catch (e) { decoIds = []; } }
        }

        function permHover(b) {
            var rows = b.perms.map(function (p) {
                return '`' + p.c + '` ' + p.cls + ' — ' + (p.act ? 'held' : '**missing**');
            });
            return (b.missing ? '⚠ A required permission is missing here.\n\n' : '**Permissions required here**\n\n') +
                rows.join('  \n');
        }

        function build() {
            clearDecorations();
            if (!visible || !model) return;
            try { editor.updateOptions({ glyphMargin: true }); } catch (e) { /* ignore */ }

            var decos = [];
            // permission use-sites — underline (red if a required permission is
            // missing) + the R/W/O letters via afterContentClassName (CSS ::after
            // content; renders here, unlike Monaco injected text). Detail on hover.
            model.boundaries.forEach(function (b) {
                var line = b.line + 1, col = b.col + 1;
                decos.push({
                    range: new monaco.Range(line, col, line, col + 1),
                    options: {
                        inlineClassName: b.missing ? 'own-mark own-mark-missing' : 'own-mark',
                        hoverMessage: { value: permHover(b) }
                    }
                });
                b.perms.forEach(function (p, i) {
                    decos.push({
                        range: new monaco.Range(line, col, line, col),
                        options: {
                            afterContentClassName: 'own-a' + (i === 0 ? ' own-a-first' : '') +
                                ' own-a-' + p.cls + (p.act ? '' : '-miss')
                        }
                    });
                });
            });
            // borrow regions — blue underline
            model.borrows.forEach(function (r) {
                decos.push({
                    range: new monaco.Range(r.line + 1, r.startCol + 1, r.line + 1, r.endCol + 1),
                    options: { inlineClassName: 'own-mark-borrow' }
                });
            });
            // permission-change tables — glyph-margin ⊞; hover shows the table
            model.steps.forEach(function (s) {
                if (!s.md) return;
                decos.push({
                    range: new monaco.Range(s.line + 1, 1, s.line + 1, 1),
                    options: {
                        glyphMarginClassName: 'own-step-glyph',
                        glyphMarginHoverMessage: { value: s.md }
                    }
                });
            });

            decoIds = editor.deltaDecorations([], decos);
        }

        return {
            apply: function (analyzedCode, ownership) {
                code = analyzedCode;
                var picked = pickEditor();
                if (picked && picked !== editor) { clearDecorations(); editor = picked; }
                model = (global.OcOwnership && global.OcOwnership.permissionModel)
                    ? global.OcOwnership.permissionModel(ownership) : null;
                visible = !!model;
                build();
            },
            clear: function () { clearDecorations(); model = null; visible = false; },
            setVisible: function (v) { visible = !!v; if (visible) build(); else clearDecorations(); },
            isVisible: function () { return visible && !!model; },
            hasData: function () { return !!model; },
            analyzedCode: function () { return code; },
            reveal: function (line) {
                try {
                    var ed = pickEditor() || editor;
                    ed.revealLineInCenter(line);
                    var ids = ed.deltaDecorations([], [{
                        range: new monaco.Range(line, 1, line, 1),
                        options: { isWholeLine: true, className: 'own-flash' }
                    }]);
                    setTimeout(function () { try { ed.deltaDecorations(ids, []); } catch (e) { /* ignore */ } }, 1300);
                } catch (e) { /* ignore */ }
            }
        };
    }

    global.OcOwnershipOverlay = { create: create };
}(typeof window !== 'undefined' ? window : this));
