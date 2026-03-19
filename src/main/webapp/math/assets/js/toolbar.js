/**
 * toolbar.js — Wire all toolbar buttons to TipTap commands + active state sync
 * TipTap-based Math Editor
 */
(function () {
    'use strict';

    // =========================================================
    //  SYNC TOOLBAR ACTIVE STATE + DISABLED STATE
    // =========================================================
    function syncToolbarState() {
        var editor = window.MeEditor;
        if (!editor) return;

        var stateMap = {
            'Bold (Ctrl+B)':            function () { return editor.isActive('bold'); },
            'Italic (Ctrl+I)':          function () { return editor.isActive('italic'); },
            'Underline (Ctrl+U)':       function () { return editor.isActive('underline'); },
            'Strikethrough (Ctrl+Shift+S)': function () { return editor.isActive('strike'); },
            'Bullet List':     function () { return editor.isActive('bulletList'); },
            'Numbered List':   function () { return editor.isActive('orderedList'); },
            'Align Left':      function () { return editor.isActive({ textAlign: 'left' }); },
            'Align Center':    function () { return editor.isActive({ textAlign: 'center' }); },
            'Align Right':     function () { return editor.isActive({ textAlign: 'right' }); },
            'Blockquote (Ctrl+Shift+B)': function () { return editor.isActive('blockquote'); },
            'Heading 1':       function () { return editor.isActive('heading', { level: 1 }); },
            'Heading 2':       function () { return editor.isActive('heading', { level: 2 }); },
            'Heading 3':       function () { return editor.isActive('heading', { level: 3 }); }
        };

        // Map of button titles to their can() checks
        var canMap = {
            'Bold (Ctrl+B)':            function () { return editor.can().toggleBold(); },
            'Italic (Ctrl+I)':          function () { return editor.can().toggleItalic(); },
            'Underline (Ctrl+U)':       function () { return editor.can().toggleUnderline(); },
            'Strikethrough (Ctrl+Shift+S)': function () { return editor.can().toggleStrike(); },
            'Heading 1':       function () { return editor.can().toggleHeading({ level: 1 }); },
            'Heading 2':       function () { return editor.can().toggleHeading({ level: 2 }); },
            'Heading 3':       function () { return editor.can().toggleHeading({ level: 3 }); },
            'Bullet List':     function () { return editor.can().toggleBulletList(); },
            'Numbered List':   function () { return editor.can().toggleOrderedList(); },
            'Blockquote (Ctrl+Shift+B)': function () { return editor.can().toggleBlockquote(); },
            'Align Left':      function () { return editor.can().setTextAlign('left'); },
            'Align Center':    function () { return editor.can().setTextAlign('center'); },
            'Align Right':     function () { return editor.can().setTextAlign('right'); },
            'Horizontal Rule': function () { return editor.can().setHorizontalRule(); },
            'Insert Code Block': function () { return editor.can().toggleCodeBlock(); },
            'Insert Table':    function () { return editor.can().insertTable({ rows: 3, cols: 3, withHeaderRow: true }); },
            'Page Break':      function () { return true; },
            'Insert Display Math (Ctrl+M)': function () { return true; },
            'Insert Inline Math (Ctrl+Shift+M)': function () { return true; },
            'Insert Image':    function () { return true; },
            'Insert Diagram':  function () { return true; },
            'Insert Drawing':  function () { return true; }
        };

        // Sync active states
        Object.keys(stateMap).forEach(function (title) {
            var btn = document.querySelector('.me-toolbar-btn[title="' + title + '"]');
            if (!btn) return;
            try { btn.classList.toggle('active', stateMap[title]()); } catch (e) {}
        });

        // Sync disabled states
        Object.keys(canMap).forEach(function (title) {
            var btn = document.querySelector('.me-toolbar-btn[title="' + title + '"]') ||
                      document.querySelector('.me-toolbar-btn-math[title="' + title + '"]');
            if (!btn) return;
            try {
                var canDo = canMap[title]();
                btn.classList.toggle('disabled', !canDo);
                btn.disabled = !canDo;
            } catch (e) {}
        });

        // Sync table context toolbar visibility
        syncTableToolbar(editor);
    }

    // =========================================================
    //  TABLE CONTEXT TOOLBAR
    // =========================================================
    function syncTableToolbar(editor) {
        var toolbar = document.getElementById('me-table-context-toolbar');
        if (!toolbar) return;
        var inTable = editor.isActive('table');
        toolbar.style.display = inTable ? 'flex' : 'none';
    }

    function createTableToolbar() {
        var toolbar = document.createElement('div');
        toolbar.id = 'me-table-context-toolbar';
        toolbar.className = 'me-table-context-toolbar';
        toolbar.style.display = 'none';
        toolbar.innerHTML =
            '<span class="me-table-context-label">Table:</span>' +
            '<button type="button" class="me-toolbar-btn me-table-ctx-btn" data-table-action="addRowAfter" title="Add Row Below">+ Row</button>' +
            '<button type="button" class="me-toolbar-btn me-table-ctx-btn" data-table-action="addColumnAfter" title="Add Column Right">+ Col</button>' +
            '<button type="button" class="me-toolbar-btn me-table-ctx-btn" data-table-action="deleteRow" title="Delete Row">&minus; Row</button>' +
            '<button type="button" class="me-toolbar-btn me-table-ctx-btn" data-table-action="deleteColumn" title="Delete Column">&minus; Col</button>' +
            '<button type="button" class="me-toolbar-btn me-table-ctx-btn me-table-ctx-btn-danger" data-table-action="deleteTable" title="Delete Table">Delete Table</button>';

        // Insert after the main toolbar
        var mainToolbar = document.querySelector('.me-toolbar');
        if (mainToolbar && mainToolbar.parentNode) {
            mainToolbar.parentNode.insertBefore(toolbar, mainToolbar.nextSibling);
        }

        return toolbar;
    }

    function wireTableToolbar(editor) {
        var toolbar = createTableToolbar();
        if (!toolbar) return;

        var actionMap = {
            'addRowAfter':    function () { editor.chain().focus().addRowAfter().run(); },
            'addColumnAfter': function () { editor.chain().focus().addColumnAfter().run(); },
            'deleteRow':      function () { editor.chain().focus().deleteRow().run(); },
            'deleteColumn':   function () { editor.chain().focus().deleteColumn().run(); },
            'deleteTable':    function () { editor.chain().focus().deleteTable().run(); }
        };

        var buttons = toolbar.querySelectorAll('[data-table-action]');
        for (var i = 0; i < buttons.length; i++) {
            (function (btn) {
                var action = btn.getAttribute('data-table-action');
                btn.addEventListener('mousedown', function (e) { e.preventDefault(); });
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    if (actionMap[action]) actionMap[action]();
                    syncToolbarState();
                });
            })(buttons[i]);
        }
    }

    // =========================================================
    //  IMAGE COMPRESSION HELPER
    // =========================================================
    function compressImage(dataUrl, maxWidth, quality, callback) {
        var img = new Image();
        img.onload = function () {
            var canvas = document.createElement('canvas');
            var w = img.width;
            var h = img.height;
            if (w > maxWidth) {
                h = Math.round(h * (maxWidth / w));
                w = maxWidth;
            }
            canvas.width = w;
            canvas.height = h;
            var ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0, w, h);
            callback(canvas.toDataURL('image/jpeg', quality));
        };
        img.onerror = function () {
            callback(dataUrl); // fallback to original on error
        };
        img.src = dataUrl;
    }

    // =========================================================
    //  WIRE BUTTONS (on editor ready)
    // =========================================================
    function wireButtons() {
        var editor = window.MeEditor;
        if (!editor) return;

        var MAX_IMAGE_SIZE = 2 * 1024 * 1024;       // 2 MB hard limit
        var COMPRESS_THRESHOLD = 1 * 1024 * 1024;    // 1 MB — compress above this

        var buttonActions = {
            'Bold (Ctrl+B)':            function () { editor.chain().focus().toggleBold().run(); },
            'Italic (Ctrl+I)':          function () { editor.chain().focus().toggleItalic().run(); },
            'Underline (Ctrl+U)':       function () { editor.chain().focus().toggleUnderline().run(); },
            'Strikethrough (Ctrl+Shift+S)': function () { editor.chain().focus().toggleStrike().run(); },
            'Heading 1':       function () { editor.chain().focus().toggleHeading({ level: 1 }).run(); },
            'Heading 2':       function () { editor.chain().focus().toggleHeading({ level: 2 }).run(); },
            'Heading 3':       function () { editor.chain().focus().toggleHeading({ level: 3 }).run(); },
            'Bullet List':     function () { editor.chain().focus().toggleBulletList().run(); },
            'Numbered List':   function () { editor.chain().focus().toggleOrderedList().run(); },
            'Blockquote (Ctrl+Shift+B)': function () { editor.chain().focus().toggleBlockquote().run(); },
            'Align Left':      function () { editor.chain().focus().setTextAlign('left').run(); },
            'Align Center':    function () { editor.chain().focus().setTextAlign('center').run(); },
            'Align Right':     function () { editor.chain().focus().setTextAlign('right').run(); },
            'Horizontal Rule': function () { editor.chain().focus().setHorizontalRule().run(); },
            'Insert Code Block': function () { editor.chain().focus().toggleCodeBlock().run(); },
            'Insert Table':    function () { editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run(); },
            'Page Break':      function () {
                editor.chain().focus().insertContent('<div class="me-page-break"></div>').run();
            },
            'Insert Display Math (Ctrl+M)': function () { if (window.MeMath) MeMath.insertBlock(); },
            'Insert Inline Math (Ctrl+Shift+M)':  function () { if (window.MeMath) MeMath.insertInline(); }
        };

        Object.keys(buttonActions).forEach(function (title) {
            var btn = document.querySelector('.me-toolbar-btn[title="' + title + '"]') ||
                      document.querySelector('.me-toolbar-btn-math[title="' + title + '"]');
            if (!btn) return;
            btn.addEventListener('mousedown', function (e) { e.preventDefault(); });
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                if (btn.disabled) return;
                buttonActions[title]();
                syncToolbarState();
                if (window.MeEditorCore) MeEditorCore.updateOutline();
            });
        });

        // Insert Image — file picker, inserts real image node (resizable)
        var imageBtn = document.querySelector('.me-toolbar-btn[title="Insert Image"]');
        if (imageBtn) {
            var imageInput = document.createElement('input');
            imageInput.type = 'file';
            imageInput.accept = 'image/png,image/jpeg,image/jpg,image/gif,image/webp';
            imageInput.style.display = 'none';
            document.body.appendChild(imageInput);

            imageBtn.addEventListener('mousedown', function (e) { e.preventDefault(); });
            imageBtn.addEventListener('click', function (e) {
                e.preventDefault();
                imageInput.value = '';
                imageInput.click();
            });

            imageInput.addEventListener('change', function (e) {
                var file = e.target.files && e.target.files[0];
                if (!file) return;

                // CRITICAL 4.4: File size check — reject files over 2 MB
                if (file.size > MAX_IMAGE_SIZE) {
                    alert('Image is too large (max 2 MB). Please choose a smaller image or compress it first.');
                    return;
                }

                var reader = new FileReader();
                reader.onload = function (ev) {
                    var dataUrl = ev.target.result;

                    // Compress via canvas if file exceeds 1 MB
                    if (file.size > COMPRESS_THRESHOLD) {
                        compressImage(dataUrl, 1920, 0.8, function (compressed) {
                            editor.chain().focus().insertContent({
                                type: 'image',
                                attrs: { src: compressed, alt: file.name, width: 560 }
                            }).run();
                        });
                    } else {
                        editor.chain().focus().insertContent({
                            type: 'image',
                            attrs: { src: dataUrl, alt: file.name, width: 560 }
                        }).run();
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        // Drawing / Diagram — opens Fabric.js canvas modal
        var diagramBtn = document.querySelector('.me-toolbar-btn[title="Insert Diagram"]') ||
                         document.querySelector('.me-toolbar-btn[title="Insert Drawing"]');
        if (diagramBtn) {
            diagramBtn.addEventListener('mousedown', function (e) { e.preventDefault(); });
            diagramBtn.addEventListener('click', function (e) {
                e.preventDefault();
                if (!window.MeDrawing) return;
                window.MeDrawing.open(function (imageData, canvasJson) {
                    editor.chain().focus().insertContent({
                        type: 'drawingBlock',
                        attrs: { imageData: imageData, canvasJson: canvasJson }
                    }).run();
                });
            });
        }

        // Wire table context toolbar (MAJOR 4.5)
        wireTableToolbar(editor);

        // Listen to selection changes for toolbar sync
        editor.on('selectionUpdate', syncToolbarState);
        editor.on('transaction', syncToolbarState);
    }

    // =========================================================
    //  INIT ON EDITOR READY
    // =========================================================
    document.addEventListener('me:editor-ready', wireButtons);

    // =========================================================
    //  EXPOSE GLOBALLY
    // =========================================================
    window.MeToolbar = {
        sync: syncToolbarState
    };

})();
