/**
 * editor-core.js — Stats, zoom, outline, keyboard shortcuts, panel tabs
 * TipTap-based Math Editor
 */
(function () {
    'use strict';

    var titleInput  = document.querySelector('.me-doc-title-input');
    var statWords   = document.getElementById('stat-words');
    var statChars   = document.getElementById('stat-chars');
    var statMath    = document.getElementById('stat-math');
    var zoomInBtn   = document.getElementById('zoom-in');
    var zoomOutBtn  = document.getElementById('zoom-out');
    var zoomLabel   = document.getElementById('zoom-label');
    var canvasEl    = document.querySelector('.me-canvas');

    // =========================================================
    //  HELPERS
    // =========================================================
    function getDocId() {
        var params = new URLSearchParams(window.location.search);
        return params.get('id') || 'default';
    }

    // =========================================================
    //  LIVE STATS
    // =========================================================
    function updateStats() {
        var editor = window.MeEditor;
        if (!editor) return;

        var text = editor.getText() || '';
        var trimmed = text.trim();
        var words = trimmed ? trimmed.split(/\s+/).length : 0;
        var chars = trimmed.length;

        // Count math nodes from the JSON doc
        var mathCount = 0;
        function countMath(node) {
            if (node.type === 'mathInline' || node.type === 'mathBlock') mathCount++;
            if (node.content) node.content.forEach(countMath);
        }
        try { countMath(editor.getJSON()); } catch (e) {}

        if (statWords) statWords.textContent = words;
        if (statChars) statChars.textContent = chars;
        if (statMath)  statMath.textContent  = mathCount;
    }

    // =========================================================
    //  OUTLINE PANEL
    // =========================================================
    function updateOutline() {
        var tree = document.querySelector('.me-outline-tree');
        if (!tree) return;
        var pm = document.querySelector('.me-canvas .ProseMirror');
        if (!pm) {
            // Editor not yet rendered — clear hardcoded placeholders
            tree.innerHTML = '<div class="me-outline-empty">Add headings to see document outline</div>';
            return;
        }
        var headings = pm.querySelectorAll('h1, h2, h3');
        tree.innerHTML = '';
        if (headings.length === 0) {
            tree.innerHTML = '<div class="me-outline-empty">Add headings to see document outline</div>';
            return;
        }
        headings.forEach(function (h) {
            var level = parseInt(h.tagName.charAt(1), 10);
            var a = document.createElement('a');
            a.className = 'me-outline-item level-' + level;
            a.href = '#';
            a.textContent = h.textContent || 'Untitled';
            a.addEventListener('click', function (e) {
                e.preventDefault();
                h.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });
            tree.appendChild(a);
        });
    }

    // Debounced version for use on content-changed (avoids full DOM rebuild every keystroke)
    var _outlineTimer = null;
    function updateOutlineDebounced() {
        if (_outlineTimer) clearTimeout(_outlineTimer);
        _outlineTimer = setTimeout(updateOutline, 500);
    }

    // =========================================================
    //  ZOOM CONTROL
    // =========================================================
    var ZOOM_STEPS = [75, 90, 100, 110, 125, 150];
    var currentZoomIndex = 2;

    var docId = getDocId();
    var savedZoom = localStorage.getItem('me_zoom_' + docId);
    if (savedZoom) {
        var idx = ZOOM_STEPS.indexOf(parseInt(savedZoom, 10));
        if (idx !== -1) { currentZoomIndex = idx; applyZoom(); }
    }

    function applyZoom() {
        if (!canvasEl) return;
        var pct = ZOOM_STEPS[currentZoomIndex];
        canvasEl.style.transform = 'scale(' + (pct / 100) + ')';
        canvasEl.style.transformOrigin = 'top center';
        if (zoomLabel) zoomLabel.textContent = pct + '%';
        localStorage.setItem('me_zoom_' + docId, pct);
    }

    function zoomIn()    { if (currentZoomIndex < ZOOM_STEPS.length - 1) { currentZoomIndex++; applyZoom(); } }
    function zoomOut()   { if (currentZoomIndex > 0) { currentZoomIndex--; applyZoom(); } }
    function zoomReset() { currentZoomIndex = 2; applyZoom(); }

    if (zoomInBtn)  zoomInBtn.addEventListener('click', zoomIn);
    if (zoomOutBtn) zoomOutBtn.addEventListener('click', zoomOut);

    // =========================================================
    //  KEYBOARD SHORTCUTS
    // =========================================================
    document.addEventListener('keydown', function (e) {
        var ctrl = e.ctrlKey || e.metaKey;
        if (!ctrl) return;
        var editor = window.MeEditor;
        if (!editor) return;

        switch (e.key.toLowerCase()) {
            case 'b':
                e.preventDefault();
                editor.chain().focus().toggleBold().run();
                break;
            case 'i':
                e.preventDefault();
                editor.chain().focus().toggleItalic().run();
                break;
            case 'u':
                e.preventDefault();
                editor.chain().focus().toggleUnderline().run();
                break;
            case 'm':
                e.preventDefault();
                if (e.shiftKey) {
                    if (window.MeMath) MeMath.insertInline();
                } else {
                    if (window.MeMath) MeMath.insertBlock();
                }
                break;
            case 's':
                e.preventDefault();
                if (window.MeAutosave) MeAutosave.save();
                break;
            case '/':
                e.preventDefault();
                if (window.MeSlashMenu) MeSlashMenu.toggle();
                break;
            case '=': case '+':
                e.preventDefault(); zoomIn(); break;
            case '-':
                e.preventDefault(); zoomOut(); break;
            case '0':
                e.preventDefault(); zoomReset(); break;
        }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            if (window.MeSlashMenu) MeSlashMenu.close();
        }
    });

    // =========================================================
    //  DOCUMENT TITLE
    // =========================================================
    if (titleInput) {
        titleInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); titleInput.blur(); }
        });
        titleInput.addEventListener('blur', function () {
            if (window.MeAutosave) MeAutosave.save();
        });
        titleInput.addEventListener('focus', function () { titleInput.select(); });
    }

    // =========================================================
    //  EXPORT DROPDOWN
    // =========================================================
    var exportBtn = document.querySelector('.me-btn-export');
    var exportMenu = document.querySelector('.me-export-menu');
    if (exportBtn && exportMenu) {
        exportBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            exportMenu.classList.toggle('show');
        });
        document.addEventListener('click', function () {
            exportMenu.classList.remove('show');
        });
    }

    // Panel tab switching (Outline only; Comments/History removed)

    // =========================================================
    //  LISTEN FOR EDITOR EVENTS
    // =========================================================

    // Clear hardcoded outline placeholders immediately at script load (prevents flash)
    updateOutline();

    document.addEventListener('me:editor-ready', function () {
        updateStats();
        updateOutline();
    });

    document.addEventListener('me:content-changed', function () {
        updateStats();
        updateOutlineDebounced();
    });

    document.addEventListener('me:selection-changed', function () {
        if (window.MeToolbar) MeToolbar.sync();
    });

    // =========================================================
    //  BACK BUTTON — guard against unsaved changes
    // =========================================================
    var backBtn = document.querySelector('.me-back-btn');
    if (backBtn) {
        backBtn.addEventListener('click', function (e) {
            var dirty = window.MeAutosave && window.MeAutosave.dirtyForApi;
            if (dirty) {
                e.preventDefault();
                var leave = confirm('You have unsaved changes. Save before leaving?');
                if (leave) {
                    // Attempt to save, then navigate
                    if (window.MeAutosave && window.MeAutosave.save) {
                        var dest = backBtn.getAttribute('href') || backBtn.closest('a')?.getAttribute('href');
                        Promise.resolve(window.MeAutosave.save()).then(function () {
                            window.location.href = dest || 'dashboard.jsp';
                        }).catch(function () {
                            window.location.href = dest || 'dashboard.jsp';
                        });
                    } else {
                        window.location.href = backBtn.getAttribute('href') || 'dashboard.jsp';
                    }
                }
                // If user clicked cancel in confirm dialog, stay on page
            }
        });
    }

    // =========================================================
    //  AUTO-RESULT TOGGLE
    // =========================================================
    var autoResultCheckbox = document.getElementById('auto-result-toggle');
    if (autoResultCheckbox) {
        // Restore saved preference
        var savedPref = localStorage.getItem('me_auto_result');
        if (savedPref === 'off') autoResultCheckbox.checked = false;

        autoResultCheckbox.addEventListener('change', function () {
            if (window.MeCompute) {
                MeCompute.setAutoResultEnabled(autoResultCheckbox.checked);
            }
        });
    }

    // =========================================================
    //  EXPOSE GLOBALLY
    // =========================================================
    window.MeEditorCore = {
        getDocId: getDocId,
        updateStats: updateStats,
        updateOutline: updateOutline
    };

    window.MeStats = { update: updateStats };

})();
