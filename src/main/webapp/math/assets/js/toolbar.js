/**
 * toolbar.js — Wire all toolbar buttons to TipTap commands + active state sync
 * TipTap-based Math Editor
 */
(function () {
    'use strict';

    // =========================================================
    //  SYNC TOOLBAR ACTIVE STATE
    // =========================================================
    function syncToolbarState() {
        var editor = window.MeEditor;
        if (!editor) return;

        var stateMap = {
            'Bold':            function () { return editor.isActive('bold'); },
            'Italic':          function () { return editor.isActive('italic'); },
            'Underline':       function () { return editor.isActive('underline'); },
            'Strikethrough':   function () { return editor.isActive('strike'); },
            'Bullet List':     function () { return editor.isActive('bulletList'); },
            'Numbered List':   function () { return editor.isActive('orderedList'); },
            'Align Left':      function () { return editor.isActive({ textAlign: 'left' }); },
            'Align Center':    function () { return editor.isActive({ textAlign: 'center' }); },
            'Align Right':     function () { return editor.isActive({ textAlign: 'right' }); },
            'Blockquote':      function () { return editor.isActive('blockquote'); },
            'Heading 1':       function () { return editor.isActive('heading', { level: 1 }); },
            'Heading 2':       function () { return editor.isActive('heading', { level: 2 }); },
            'Heading 3':       function () { return editor.isActive('heading', { level: 3 }); }
        };

        Object.keys(stateMap).forEach(function (title) {
            var btn = document.querySelector('.me-toolbar-btn[title="' + title + '"]');
            if (!btn) return;
            try { btn.classList.toggle('active', stateMap[title]()); } catch (e) {}
        });
    }

    // =========================================================
    //  WIRE BUTTONS (on editor ready)
    // =========================================================
    function wireButtons() {
        var editor = window.MeEditor;
        if (!editor) return;

        var buttonActions = {
            'Bold':            function () { editor.chain().focus().toggleBold().run(); },
            'Italic':          function () { editor.chain().focus().toggleItalic().run(); },
            'Underline':       function () { editor.chain().focus().toggleUnderline().run(); },
            'Strikethrough':   function () { editor.chain().focus().toggleStrike().run(); },
            'Heading 1':       function () { editor.chain().focus().toggleHeading({ level: 1 }).run(); },
            'Heading 2':       function () { editor.chain().focus().toggleHeading({ level: 2 }).run(); },
            'Heading 3':       function () { editor.chain().focus().toggleHeading({ level: 3 }).run(); },
            'Bullet List':     function () { editor.chain().focus().toggleBulletList().run(); },
            'Numbered List':   function () { editor.chain().focus().toggleOrderedList().run(); },
            'Blockquote':      function () { editor.chain().focus().toggleBlockquote().run(); },
            'Align Left':      function () { editor.chain().focus().setTextAlign('left').run(); },
            'Align Center':    function () { editor.chain().focus().setTextAlign('center').run(); },
            'Align Right':     function () { editor.chain().focus().setTextAlign('right').run(); },
            'Horizontal Rule': function () { editor.chain().focus().setHorizontalRule().run(); },
            'Insert Code Block': function () { editor.chain().focus().toggleCodeBlock().run(); },
            'Insert Table':    function () { editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run(); },
            'Page Break':      function () { editor.chain().focus().setHorizontalRule().run(); },
            'Insert Display Math': function () { if (window.MeMath) MeMath.insertBlock(); },
            'Insert Inline Math':  function () { if (window.MeMath) MeMath.insertInline(); }
        };

        Object.keys(buttonActions).forEach(function (title) {
            var btn = document.querySelector('.me-toolbar-btn[title="' + title + '"]') ||
                      document.querySelector('.me-toolbar-btn-math[title="' + title + '"]');
            if (!btn) return;
            btn.addEventListener('mousedown', function (e) { e.preventDefault(); });
            btn.addEventListener('click', function (e) {
                e.preventDefault();
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
                var reader = new FileReader();
                reader.onload = function (ev) {
                    var dataUrl = ev.target.result;
                    editor.chain().focus().insertContent({
                        type: 'image',
                        attrs: { src: dataUrl, alt: file.name, width: 560 }
                    }).run();
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
