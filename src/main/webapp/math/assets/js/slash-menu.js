/**
 * slash-menu.js — Slash command menu (/ at start of empty line)
 * TipTap-based Math Editor
 */
(function () {
    'use strict';

    // =========================================================
    //  MENU ITEMS
    // =========================================================
    var MENU_ITEMS = [
        { icon: '&#x2211;',  label: 'Math Block',    shortcut: 'Ctrl+M',       action: 'mathBlock'    },
        { icon: '&#x221A;',  label: 'Inline Math',   shortcut: 'Ctrl+Shift+M', action: 'inlineMath'   },
        { icon: 'T',          label: 'Text',          shortcut: '',             action: 'paragraph'    },
        { icon: 'H1',         label: 'Heading 1',     shortcut: '',             action: 'h1'           },
        { icon: 'H2',         label: 'Heading 2',     shortcut: '',             action: 'h2'           },
        { icon: 'H3',         label: 'Heading 3',     shortcut: '',             action: 'h3'           },
        { icon: '&#x2261;',  label: 'Bullet List',   shortcut: '',             action: 'bulletList'   },
        { icon: '1.',         label: 'Numbered List', shortcut: '',             action: 'numberedList' },
        { icon: '&lt;/&gt;', label: 'Code Block',    shortcut: '',             action: 'codeBlock'    },
        { icon: '&#x229E;',  label: 'Table',         shortcut: '3x3',          action: 'table'        },
        { icon: '&#x201C;',  label: 'Blockquote',    shortcut: '',             action: 'blockquote'   },
        { icon: '&#x2014;',  label: 'Divider',       shortcut: '',             action: 'divider'      },
        { icon: '&#x270F;',  label: 'Drawing',       shortcut: '',             action: 'drawing'      }
    ];

    // =========================================================
    //  BUILD MENU DOM
    // =========================================================
    var menu = document.createElement('div');
    menu.className = 'me-slash-menu';
    menu.setAttribute('role', 'listbox');
    menu.style.display = 'none';
    document.body.appendChild(menu);

    MENU_ITEMS.forEach(function (item, idx) {
        var el = document.createElement('div');
        el.className = 'me-slash-item';
        el.setAttribute('role', 'option');
        el.setAttribute('data-index', idx);
        el.innerHTML =
            '<span class="me-slash-icon">' + item.icon + '</span>' +
            '<span class="me-slash-label">' + item.label + '</span>' +
            (item.shortcut ? '<span class="me-slash-shortcut">' + item.shortcut + '</span>' : '');
        el.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            executeItem(idx);
        });
        el.addEventListener('mouseenter', function () { setSelected(idx); });
        menu.appendChild(el);
    });

    var menuItems = menu.querySelectorAll('.me-slash-item');
    var selectedIndex = 0;
    var isOpen = false;

    // =========================================================
    //  SHOW / HIDE / POSITION
    // =========================================================
    function show() {
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount) return;
        var rect = sel.getRangeAt(0).getBoundingClientRect();
        var top = rect.bottom || rect.top;
        var left = rect.left;

        if (!top) {
            var node = sel.getRangeAt(0).startContainer;
            if (node.nodeType === Node.ELEMENT_NODE) {
                var elRect = node.getBoundingClientRect();
                top = elRect.bottom;
                left = elRect.left;
            }
        }

        menu.style.position = 'fixed';
        menu.style.top = (top + 4) + 'px';
        menu.style.left = Math.max(8, left) + 'px';
        menu.style.display = '';
        isOpen = true;
        selectedIndex = 0;
        updateSelected();

        requestAnimationFrame(function () {
            var menuRect = menu.getBoundingClientRect();
            if (menuRect.bottom > window.innerHeight) {
                menu.style.top = (top - menuRect.height - 8) + 'px';
            }
            if (menuRect.right > window.innerWidth) {
                menu.style.left = (window.innerWidth - menuRect.width - 8) + 'px';
            }
        });
    }

    function close() {
        menu.style.display = 'none';
        isOpen = false;
        menuItems.forEach(function (el) { el.style.display = ''; });
    }

    function toggle() {
        if (isOpen) { close(); return; }
        show();
    }

    // =========================================================
    //  NAVIGATION
    // =========================================================
    function setSelected(idx) {
        selectedIndex = idx;
        updateSelected();
    }

    function updateSelected() {
        var visible = getVisibleItems();
        menuItems.forEach(function (el) { el.classList.remove('selected'); });
        if (visible[selectedIndex]) {
            visible[selectedIndex].classList.add('selected');
            visible[selectedIndex].scrollIntoView({ block: 'nearest' });
        }
    }

    function getVisibleItems() {
        var arr = [];
        menuItems.forEach(function (el) {
            if (el.style.display !== 'none') arr.push(el);
        });
        return arr;
    }

    // =========================================================
    //  / TRIGGER + KEYBOARD NAV (on editor ready)
    // =========================================================
    document.addEventListener('me:editor-ready', function () {
        var editorEl = document.querySelector('.me-canvas .ProseMirror');
        if (!editorEl) return;

        editorEl.addEventListener('keydown', function (e) {
            if (isOpen) {
                var visible = getVisibleItems();
                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    selectedIndex = (selectedIndex + 1) % visible.length;
                    updateSelected();
                    return;
                }
                if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    selectedIndex = (selectedIndex - 1 + visible.length) % visible.length;
                    updateSelected();
                    return;
                }
                if (e.key === 'Enter') {
                    e.preventDefault();
                    var visibleItem = visible[selectedIndex];
                    if (visibleItem) {
                        executeItem(parseInt(visibleItem.getAttribute('data-index'), 10));
                    }
                    return;
                }
                if (e.key === 'Escape') {
                    e.preventDefault();
                    close();
                    return;
                }
                return;
            }

            // Detect / at start of empty block
            if (e.key === '/') {
                var editor = window.MeEditor;
                if (!editor) return;
                var { $from } = editor.state.selection;
                var isAtStart = $from.parentOffset === 0;
                var isEmpty = $from.parent.textContent === '';
                if (isAtStart && isEmpty) {
                    e.preventDefault();
                    show();
                }
            }
        });
    });

    // Close on outside click
    document.addEventListener('mousedown', function (e) {
        if (isOpen && !menu.contains(e.target)) close();
    });

    // =========================================================
    //  EXECUTE ITEM
    // =========================================================
    function executeItem(idx) {
        var item = MENU_ITEMS[idx];
        if (!item) return;
        close();

        var editor = window.MeEditor;
        if (!editor) return;

        switch (item.action) {
            case 'mathBlock':
                if (window.MeMath) MeMath.insertBlock();
                break;
            case 'inlineMath':
                if (window.MeMath) MeMath.insertInline();
                break;
            case 'paragraph':
                editor.chain().focus().setParagraph().run();
                break;
            case 'h1':
                editor.chain().focus().toggleHeading({ level: 1 }).run();
                break;
            case 'h2':
                editor.chain().focus().toggleHeading({ level: 2 }).run();
                break;
            case 'h3':
                editor.chain().focus().toggleHeading({ level: 3 }).run();
                break;
            case 'bulletList':
                editor.chain().focus().toggleBulletList().run();
                break;
            case 'numberedList':
                editor.chain().focus().toggleOrderedList().run();
                break;
            case 'codeBlock':
                editor.chain().focus().toggleCodeBlock().run();
                break;
            case 'table':
                editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run();
                break;
            case 'blockquote':
                editor.chain().focus().toggleBlockquote().run();
                break;
            case 'divider':
                editor.chain().focus().setHorizontalRule().run();
                break;
            case 'drawing':
                if (window.MeDrawing) {
                    window.MeDrawing.open(function (imageData, canvasJson) {
                        editor.chain().focus().insertContent({
                            type: 'drawingBlock',
                            attrs: { imageData: imageData, canvasJson: canvasJson }
                        }).run();
                    });
                }
                break;
        }

        if (window.MeToolbar) MeToolbar.sync();
        if (window.MeStats) MeStats.update();
        if (window.MeEditorCore) MeEditorCore.updateOutline();
    }

    // =========================================================
    //  EXPOSE GLOBALLY
    // =========================================================
    window.MeSlashMenu = {
        close: close,
        toggle: toggle,
        isOpen: function () { return isOpen; }
    };

})();
