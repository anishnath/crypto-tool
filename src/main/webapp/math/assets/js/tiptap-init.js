/**
 * tiptap-init.js — TipTap editor + live MathLive math nodes
 *
 * Architecture:
 *   - MathInline / MathBlock are atom TipTap nodes
 *   - Each node's NodeView creates a <math-field> (MathLive web component)
 *   - wireMathField() binds events: keydown, input, move-out
 *   - Empty math nodes are NOT auto-deleted (user deletes via Backspace)
 *   - Focus management: insertMathNode → setNodeSelection → selectNode → mf.focus()
 */

// Local bundle — all TipTap + ProseMirror deps in one file (no CDN version conflicts)
import {
    Editor, Node, mergeAttributes,
    StarterKit, Placeholder, Underline, TextAlign,
    Table, TableRow, TableCell, TableHeader
} from './tiptap-deps.js';

// MathLive — loaded as ESM (registers <math-field> custom element)
import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';

// =========================================================
//  HELPER: safely read LaTeX from a math-field
// =========================================================
function getLatex(mf) {
    try {
        return (mf.getValue ? mf.getValue() : mf.value) || '';
    } catch (_) {
        return mf.value || '';
    }
}

// =========================================================
//  Wire a <math-field> for live editing inside TipTap
// =========================================================
function wireMathField(mf, getPos, editorInstance, nodeTypeName, resultEl) {
    // -- Prevent TipTap from stealing keystrokes inside the math-field --
    mf.addEventListener('keydown', function (e) {
        e.stopPropagation();

        // Backspace/Delete on empty math-field → delete the node entirely
        if ((e.key === 'Backspace' || e.key === 'Delete') && !getLatex(mf).trim()) {
            e.preventDefault();
            var pos = getPos();
            if (typeof pos === 'number') {
                try {
                    var node = editorInstance.state.doc.nodeAt(pos);
                    if (node) {
                        // Move cursor before deleting so user has somewhere to land
                        var after = pos + node.nodeSize;
                        var docSize = editorInstance.state.doc.content.size;
                        if (after < docSize) {
                            editorInstance.chain().focus().setTextSelection(after).run();
                        } else if (pos > 0) {
                            editorInstance.chain().focus().setTextSelection(pos).run();
                        } else {
                            // Only node in doc — insert empty paragraph first
                            editorInstance.chain().focus()
                                .insertContentAt(0, { type: 'paragraph' })
                                .setTextSelection(1)
                                .run();
                        }
                        // Delete the math node
                        var tr = editorInstance.state.tr.delete(pos, pos + node.nodeSize);
                        editorInstance.view.dispatch(tr);
                    }
                } catch (_) {}
            }
            return;
        }

        // Shift+Enter → evaluate inline (append = result)
        if (e.key === 'Enter' && e.shiftKey) {
            e.preventDefault();
            if (window.MeCompute) window.MeCompute.evaluateInline(mf);
            return;
        }

        // Enter (outside a matrix) → exit math, move cursor after node
        if (e.key === 'Enter' && !e.shiftKey) {
            var val = getLatex(mf);
            if (!/\\begin\{/.test(val)) {
                e.preventDefault();
                moveCursorAfter(getPos, editorInstance);
            }
        }

        // Escape → exit math without deleting
        if (e.key === 'Escape') {
            e.preventDefault();
            moveCursorAfter(getPos, editorInstance);
        }
    });

    // -- Save LaTeX to TipTap node on every keystroke --
    mf.addEventListener('input', function () {
        var latex = getLatex(mf);
        var pos = getPos();
        if (typeof pos !== 'number') return;
        try {
            var node = editorInstance.state.doc.nodeAt(pos);
            if (!node || node.type.name !== nodeTypeName) return;
            if (node.attrs.latex === latex) return;
            editorInstance.view.dispatch(
                editorInstance.state.tr.setNodeMarkup(pos, undefined, { latex: latex })
            );
        } catch (_) {}

        // Auto-result for block math (Layer 1)
        if (resultEl && window.MeCompute) {
            window.MeCompute.updateAutoResult(latex, resultEl);
        }
    });

    // -- Inject compute actions into MathLive's native context menu --
    if (window.MeCompute && window.MeCompute.wireMenuItems) {
        window.MeCompute.wireMenuItems(mf);
    }

    // -- Virtual keyboard: auto-show on touch devices --
    mf.mathVirtualKeyboardPolicy = 'auto';

    // -- Arrow/tab out of math-field → return to TipTap --
    mf.addEventListener('move-out', function (e) {
        var direction = e.detail && e.detail.direction;
        var pos = getPos();
        if (typeof pos !== 'number') return;

        try {
            var resolved = editorInstance.state.doc.resolve(pos);
            var nodeAfter = resolved.nodeAfter;
            var after = pos + (nodeAfter ? nodeAfter.nodeSize : 1);
            var docSize = editorInstance.state.doc.content.size;

            if (direction === 'forward' || direction === 'downward') {
                if (after >= docSize) {
                    // No content after — insert a paragraph
                    editorInstance.chain().focus()
                        .insertContentAt(after, { type: 'paragraph' })
                        .setTextSelection(after + 1)
                        .run();
                } else {
                    editorInstance.chain().focus().setTextSelection(after).run();
                }
            } else {
                if (pos <= 0) {
                    // No content before — insert a paragraph at start
                    editorInstance.chain().focus()
                        .insertContentAt(0, { type: 'paragraph' })
                        .setTextSelection(1)
                        .run();
                } else {
                    editorInstance.chain().focus().setTextSelection(pos).run();
                }
            }
        } catch (_) {}
    });
}

// Move TipTap cursor to after the node at getPos().
// If the math node is the last block, insert an empty paragraph so
// the user always has somewhere to land.
function moveCursorAfter(getPos, editorInstance) {
    var pos = getPos();
    if (typeof pos !== 'number') return;
    try {
        var resolved = editorInstance.state.doc.resolve(pos);
        var nodeAfter = resolved.nodeAfter;
        if (!nodeAfter) return;
        var after = pos + nodeAfter.nodeSize;
        var docSize = editorInstance.state.doc.content.size;

        // If there is no content after this node (end of document),
        // insert an empty paragraph first so the cursor has a target.
        if (after >= docSize) {
            editorInstance.chain().focus()
                .insertContentAt(after, { type: 'paragraph' })
                .setTextSelection(after + 1)
                .run();
        } else {
            editorInstance.chain().focus().setTextSelection(after).run();
        }
    } catch (_) {}
}

// =========================================================
//  INLINE MATH NODE
// =========================================================
const MathInline = Node.create({
    name: 'mathInline',
    group: 'inline',
    inline: true,
    atom: true,

    addAttributes() {
        return { latex: { default: '' } };
    },

    parseHTML() {
        return [{
            tag: 'span.me-math-inline',
            getAttrs: el => ({ latex: el.getAttribute('data-latex') || '' })
        }];
    },

    renderHTML({ HTMLAttributes }) {
        return ['span', mergeAttributes({
            class: 'me-math-node me-math-inline',
            'data-latex': HTMLAttributes.latex,
            contenteditable: 'false'
        }), ['math-field', { class: 'me-mathfield-live' }, HTMLAttributes.latex]];
    },

    addNodeView() {
        return ({ node, getPos, editor: ed }) => {
            const dom = document.createElement('span');
            dom.className = 'me-math-node me-math-inline';
            dom.contentEditable = 'false';

            const mf = document.createElement('math-field');
            mf.className = 'me-mathfield-live';
            if (node.attrs.latex) mf.value = node.attrs.latex;
            dom.appendChild(mf);

            requestAnimationFrame(() => wireMathField(mf, getPos, ed, 'mathInline'));

            return {
                dom,
                update(updatedNode) {
                    if (updatedNode.type.name !== 'mathInline') return false;
                    var current = getLatex(mf);
                    if (current !== updatedNode.attrs.latex) {
                        mf.value = updatedNode.attrs.latex;
                    }
                    return true;
                },
                selectNode() {
                    dom.classList.add('me-math-selected');
                    // Notify compute.js — stopEvent blocks ProseMirror's
                    // onSelectionUpdate from firing on click, so we dispatch here
                    document.dispatchEvent(new CustomEvent('me:selection-changed', {
                        detail: { editor: ed }
                    }));
                    setTimeout(() => { try { mf.focus(); } catch (_) {} }, 30);
                },
                deselectNode() {
                    dom.classList.remove('me-math-selected');
                },
                stopEvent(event) {
                    return true;
                },
                ignoreMutation() { return true; },
                destroy() {}
            };
        };
    }
});

// =========================================================
//  BLOCK MATH NODE
// =========================================================
const MathBlock = Node.create({
    name: 'mathBlock',
    group: 'block',
    atom: true,

    addAttributes() {
        return { latex: { default: '' } };
    },

    parseHTML() {
        return [{
            tag: 'div.me-math-display',
            getAttrs: el => ({ latex: el.getAttribute('data-latex') || '' })
        }];
    },

    renderHTML({ HTMLAttributes }) {
        return ['div', mergeAttributes({
            class: 'me-math-node me-math-display',
            'data-latex': HTMLAttributes.latex,
            contenteditable: 'false'
        }), ['math-field', { class: 'me-mathfield-live' }, HTMLAttributes.latex]];
    },

    addNodeView() {
        return ({ node, getPos, editor: ed }) => {
            const dom = document.createElement('div');
            dom.className = 'me-math-node me-math-display';
            dom.contentEditable = 'false';

            const mf = document.createElement('math-field');
            mf.className = 'me-mathfield-live';
            if (node.attrs.latex) mf.value = node.attrs.latex;
            dom.appendChild(mf);

            // Delete button — visible on hover/select
            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'me-math-delete-btn';
            deleteBtn.innerHTML = '\u00d7';
            deleteBtn.setAttribute('title', 'Delete this math block');
            deleteBtn.setAttribute('aria-label', 'Delete math block');
            deleteBtn.setAttribute('type', 'button');
            deleteBtn.addEventListener('mousedown', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var pos = getPos();
                if (typeof pos !== 'number') return;
                try {
                    var n = ed.state.doc.nodeAt(pos);
                    if (!n) return;
                    var after = pos + n.nodeSize;
                    var docSize = ed.state.doc.content.size;
                    // Ensure there's somewhere for the cursor to go
                    if (pos <= 0 && after >= docSize) {
                        ed.chain().focus()
                            .insertContentAt(0, { type: 'paragraph' })
                            .setTextSelection(1)
                            .run();
                        // Re-get pos since doc changed
                        pos = 2; // paragraph took pos 0-1
                        n = ed.state.doc.nodeAt(pos);
                        if (n) {
                            ed.view.dispatch(ed.state.tr.delete(pos, pos + n.nodeSize));
                        }
                    } else {
                        if (after < docSize) {
                            ed.chain().focus().setTextSelection(after).run();
                        } else {
                            ed.chain().focus().setTextSelection(Math.max(0, pos)).run();
                        }
                        ed.view.dispatch(ed.state.tr.delete(pos, pos + n.nodeSize));
                    }
                } catch (_) {}
            });
            dom.appendChild(deleteBtn);

            // Auto-result element (Layer 1 — Compute Engine)
            const resultEl = document.createElement('div');
            resultEl.className = 'me-math-result';
            dom.appendChild(resultEl);

            requestAnimationFrame(() => wireMathField(mf, getPos, ed, 'mathBlock', resultEl));

            return {
                dom,
                update(updatedNode) {
                    if (updatedNode.type.name !== 'mathBlock') return false;
                    var current = getLatex(mf);
                    if (current !== updatedNode.attrs.latex) {
                        mf.value = updatedNode.attrs.latex;
                    }
                    return true;
                },
                selectNode() {
                    dom.classList.add('me-math-selected');
                    // Notify compute.js — stopEvent blocks ProseMirror's
                    // onSelectionUpdate from firing on click, so we dispatch here
                    document.dispatchEvent(new CustomEvent('me:selection-changed', {
                        detail: { editor: ed }
                    }));
                    setTimeout(() => { try { mf.focus(); } catch (_) {} }, 30);
                },
                deselectNode() {
                    dom.classList.remove('me-math-selected');
                },
                stopEvent() { return true; },
                ignoreMutation() { return true; },
                destroy() {}
            };
        };
    }
});

// =========================================================
//  IMAGE NODE — graph images, uploads; supports resize handle
//  When selected, shows bottom-right resize grip to drag and resize
// =========================================================
const MeImage = Node.create({
    name: 'image',
    group: 'block',
    draggable: true,
    atom: true,

    addAttributes() {
        return {
            src:    { default: null },
            alt:    { default: null },
            title:  { default: null },
            width:  { default: 560 },  // px; user can resize via drag handle
            layout: { default: 'block' }  // 'block' = full row, 'inline' = side by side
        };
    },

    parseHTML() {
        return [{
            tag: 'img[src]',
            getAttrs: el => ({
                src: el.getAttribute('src'),
                alt: el.getAttribute('alt') || null,
                title: el.getAttribute('title') || null,
                width: parseInt(el.getAttribute('data-width') || el.style.width || '560', 10) || 560,
                layout: el.getAttribute('data-layout') || 'block'
            })
        }];
    },

    renderHTML({ HTMLAttributes }) {
        var w = HTMLAttributes.width || 560;
        var layout = HTMLAttributes.layout || 'block';
        var displayStyle = layout === 'inline' ? 'display:inline-block;vertical-align:top;margin:4px 8px 4px 0;' : '';
        return ['img', mergeAttributes({
            class: 'me-graph-image' + (layout === 'inline' ? ' me-image-inline' : ''),
            'data-width': String(w),
            'data-layout': layout,
            style: 'width:' + w + 'px;height:auto;' + displayStyle
        }, {
            src: HTMLAttributes.src,
            alt: HTMLAttributes.alt,
            title: HTMLAttributes.title
        })];
    },

    addCommands() {
        return {
            setImage: (attrs) => ({ commands }) => {
                return commands.insertContent({ type: this.name, attrs });
            }
        };
    },

    addNodeView() {
        return ({ node, getPos, editor: ed }) => {
            var wrapper = document.createElement('div');
            var layout = node.attrs.layout || 'block';
            wrapper.className = 'me-image-wrapper' + (layout === 'inline' ? ' me-image-wrapper-inline' : '');
            if (layout === 'inline') {
                wrapper.style.display = 'inline-block';
                wrapper.style.verticalAlign = 'top';
                wrapper.style.margin = '4px 8px 4px 0';
            }

            var img = document.createElement('img');
            img.className = 'me-graph-image';
            img.src = node.attrs.src || '';
            if (node.attrs.alt) img.alt = node.attrs.alt;
            if (node.attrs.title) img.title = node.attrs.title;
            var w = node.attrs.width || 560;
            img.style.width = w + 'px';
            img.style.height = 'auto';
            img.draggable = true;
            wrapper.appendChild(img);

            // Layout toggle button (block ↔ inline)
            var layoutBtn = document.createElement('button');
            layoutBtn.className = 'me-image-layout-btn';
            layoutBtn.innerHTML = layout === 'inline' ? '\u2B1C' : '\u25A3';  // □ or ⬜
            layoutBtn.title = layout === 'inline' ? 'Full width' : 'Side by side';
            layoutBtn.setAttribute('type', 'button');
            layoutBtn.addEventListener('mousedown', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var pos = getPos();
                if (typeof pos !== 'number') return;
                var newLayout = (node.attrs.layout || 'block') === 'block' ? 'inline' : 'block';
                ed.view.dispatch(ed.state.tr.setNodeMarkup(pos, undefined, {
                    src: node.attrs.src,
                    alt: node.attrs.alt,
                    title: node.attrs.title,
                    width: newLayout === 'inline' ? Math.min(node.attrs.width || 560, 300) : node.attrs.width || 560,
                    layout: newLayout
                }));
            });
            wrapper.appendChild(layoutBtn);

            var handle = document.createElement('div');
            handle.className = 'me-image-resize-handle';
            handle.innerHTML = '\u2198';  // ↘
            handle.title = 'Drag to resize';
            handle.setAttribute('aria-label', 'Resize image');
            wrapper.appendChild(handle);

            wrapper.addEventListener('mouseenter', function () {
                handle.classList.add('me-image-handle-visible');
            });
            wrapper.addEventListener('mouseleave', function () {
                if (!wrapper.classList.contains('me-image-selected')) {
                    handle.classList.remove('me-image-handle-visible');
                }
            });

            var onResizeStart = function (e) {
                e.preventDefault();
                e.stopPropagation();
                var isTouch = e.type === 'touchstart';
                var startX = isTouch ? e.touches[0].clientX : e.clientX;
                var startW = parseInt(img.style.width, 10) || 560;
                var minW = 120, maxW = 960;

                function onMove(ev) {
                    var cx = ev.type === 'touchmove' ? ev.touches[0].clientX : ev.clientX;
                    var dx = cx - startX;
                    var newW = Math.max(minW, Math.min(maxW, startW + dx));
                    img.style.width = newW + 'px';
                }
                function onUp() {
                    document.removeEventListener('mousemove', onMove);
                    document.removeEventListener('mouseup', onUp);
                    document.removeEventListener('touchmove', onMove);
                    document.removeEventListener('touchend', onUp);
                    var pos = getPos();
                    if (typeof pos !== 'number') return;
                    var newW = parseInt(img.style.width, 10) || 560;
                    ed.view.dispatch(ed.state.tr.setNodeMarkup(pos, undefined, {
                        src: node.attrs.src,
                        alt: node.attrs.alt,
                        title: node.attrs.title,
                        width: newW
                    }));
                }
                document.addEventListener('mousemove', onMove);
                document.addEventListener('mouseup', onUp);
                document.addEventListener('touchmove', onMove, { passive: false });
                document.addEventListener('touchend', onUp);
            };
            handle.addEventListener('mousedown', onResizeStart);
            handle.addEventListener('touchstart', onResizeStart, { passive: false });
            // Touch-friendly: make handle visible on touch devices
            handle.style.minWidth = '44px';
            handle.style.minHeight = '44px';

            return {
                dom: wrapper,
                update(updatedNode) {
                    if (updatedNode.type.name !== 'image') return false;
                    if (updatedNode.attrs.src) img.src = updatedNode.attrs.src;
                    if (updatedNode.attrs.alt) img.alt = updatedNode.attrs.alt;
                    if (updatedNode.attrs.title) img.title = updatedNode.attrs.title;
                    var nw = updatedNode.attrs.width || 560;
                    img.style.width = nw + 'px';
                    // Update layout
                    var nl = updatedNode.attrs.layout || 'block';
                    wrapper.className = 'me-image-wrapper' + (nl === 'inline' ? ' me-image-wrapper-inline' : '');
                    wrapper.style.display = nl === 'inline' ? 'inline-block' : '';
                    wrapper.style.verticalAlign = nl === 'inline' ? 'top' : '';
                    wrapper.style.margin = nl === 'inline' ? '4px 8px 4px 0' : '';
                    layoutBtn.innerHTML = nl === 'inline' ? '\u2B1C' : '\u25A3';
                    layoutBtn.title = nl === 'inline' ? 'Full width' : 'Side by side';
                    return true;
                },
                selectNode() {
                    wrapper.classList.add('me-image-selected');
                    handle.classList.add('me-image-handle-visible');
                },
                deselectNode() {
                    wrapper.classList.remove('me-image-selected');
                    handle.classList.remove('me-image-handle-visible');
                },
                stopEvent(ev) {
                    return ev.target === handle;
                },
                ignoreMutation() { return true; },
                destroy() {}
            };
        };
    }
});

// =========================================================
//  DRAWING BLOCK NODE
//  Stores canvas JSON for re-editing + PNG for display.
//  Double-click to re-open the Fabric.js drawing editor.
//  Supports resize handle (same as image node).
// =========================================================
const DrawingBlock = Node.create({
    name: 'drawingBlock',
    group: 'block',
    draggable: true,
    atom: true,

    addAttributes() {
        return {
            imageData:  { default: null },   // PNG data URL
            canvasJson: { default: null },   // Fabric.js JSON
            width:      { default: 560 }     // px; resizable via drag handle
        };
    },

    parseHTML() {
        return [{
            tag: 'div.me-drawing-block',
            getAttrs: el => ({
                imageData:  el.querySelector('img')?.src || null,
                canvasJson: el.getAttribute('data-canvas-json') || null,
                width:      parseInt(el.getAttribute('data-width') || el.querySelector('img')?.style?.width || '560', 10) || 560
            })
        }];
    },

    renderHTML({ HTMLAttributes }) {
        const attrs = mergeAttributes({
            class: 'me-drawing-block',
            'data-canvas-json': HTMLAttributes.canvasJson || '',
            'data-width': String(HTMLAttributes.width || 560),
            contenteditable: 'false',
        });
        if (HTMLAttributes.imageData) {
            return ['div', attrs, ['img', { src: HTMLAttributes.imageData, class: 'me-drawing-image', style: 'width:' + (HTMLAttributes.width || 560) + 'px;' }]];
        }
        return ['div', attrs, ['span', { class: 'me-drawing-placeholder' }, 'Drawing']];
    },

    addCommands() {
        return {
            insertDrawing: (attrs) => ({ commands }) => {
                return commands.insertContent({ type: this.name, attrs });
            }
        };
    },

    addNodeView() {
        return ({ node, getPos, editor: ed }) => {
            const dom = document.createElement('div');
            dom.className = 'me-drawing-block';
            dom.contentEditable = 'false';

            const img = document.createElement('img');
            img.className = 'me-drawing-image';
            if (node.attrs.imageData) {
                img.src = node.attrs.imageData;
            }
            var w = node.attrs.width || 560;
            img.style.width = w + 'px';
            img.style.height = 'auto';
            img.style.maxWidth = '100%';
            dom.appendChild(img);

            const handle = document.createElement('div');
            handle.className = 'me-image-resize-handle me-drawing-resize-handle';
            handle.innerHTML = '\u2198';
            handle.title = 'Drag to resize';
            handle.setAttribute('aria-label', 'Resize drawing');
            dom.appendChild(handle);

            dom.addEventListener('mouseenter', function () {
                handle.classList.add('me-image-handle-visible');
            });
            dom.addEventListener('mouseleave', function () {
                if (!dom.classList.contains('me-drawing-selected')) {
                    handle.classList.remove('me-image-handle-visible');
                }
            });

            var onDrawingResizeStart = function (e) {
                e.preventDefault();
                e.stopPropagation();
                var isTouch = e.type === 'touchstart';
                var startX = isTouch ? e.touches[0].clientX : e.clientX;
                var startW = parseInt(img.style.width, 10) || 560;
                var minW = 120, maxW = 960;
                function onMove(ev) {
                    var cx = ev.type === 'touchmove' ? ev.touches[0].clientX : ev.clientX;
                    var dx = cx - startX;
                    var newW = Math.max(minW, Math.min(maxW, startW + dx));
                    img.style.width = newW + 'px';
                }
                function onUp() {
                    document.removeEventListener('mousemove', onMove);
                    document.removeEventListener('mouseup', onUp);
                    document.removeEventListener('touchmove', onMove);
                    document.removeEventListener('touchend', onUp);
                    var pos = getPos();
                    if (typeof pos !== 'number') return;
                    var newW = parseInt(img.style.width, 10) || 560;
                    ed.view.dispatch(ed.state.tr.setNodeMarkup(pos, undefined, {
                        imageData: node.attrs.imageData,
                        canvasJson: node.attrs.canvasJson,
                        width: newW
                    }));
                }
                document.addEventListener('mousemove', onMove);
                document.addEventListener('mouseup', onUp);
                document.addEventListener('touchmove', onMove, { passive: false });
                document.addEventListener('touchend', onUp);
            };
            handle.addEventListener('mousedown', onDrawingResizeStart);
            handle.addEventListener('touchstart', onDrawingResizeStart, { passive: false });
            // Touch-friendly: make handle visible on touch devices
            handle.style.minWidth = '44px';
            handle.style.minHeight = '44px';

            // Overlay hint
            const hint = document.createElement('div');
            hint.className = 'me-drawing-hint';
            hint.textContent = 'Double-click to edit drawing';
            dom.appendChild(hint);

            // Double-click to re-edit
            dom.addEventListener('dblclick', function (e) {
                if (e.target === handle) return;
                e.preventDefault();
                e.stopPropagation();
                if (!window.MeDrawing) return;
                window.MeDrawing.open(
                    function (imageData, canvasJson) {
                        var pos = getPos();
                        if (typeof pos !== 'number') return;
                        ed.view.dispatch(
                            ed.state.tr.setNodeMarkup(pos, undefined, {
                                imageData: imageData,
                                canvasJson: canvasJson,
                                width: node.attrs.width || 560
                            })
                        );
                    },
                    node.attrs.canvasJson,
                    node.attrs.imageData
                );
            });

            return {
                dom,
                update(updatedNode) {
                    if (updatedNode.type.name !== 'drawingBlock') return false;
                    if (updatedNode.attrs.imageData) {
                        img.src = updatedNode.attrs.imageData;
                    }
                    var nw = updatedNode.attrs.width || 560;
                    img.style.width = nw + 'px';
                    return true;
                },
                selectNode() {
                    dom.classList.add('me-drawing-selected');
                    handle.classList.add('me-image-handle-visible');
                },
                deselectNode() {
                    dom.classList.remove('me-drawing-selected');
                    handle.classList.remove('me-image-handle-visible');
                },
                stopEvent(ev) { return ev.target === handle; },
                ignoreMutation() { return true; },
                destroy() {}
            };
        };
    }
});

// =========================================================
//  RUNNABLE CODE BLOCK NODE
//  Replaces StarterKit's codeBlock with an executable version.
//  Uses contentDOM so code text remains editable by TipTap.
//  Header bar (language picker, run button) and output panel
//  are pure DOM decorations — not part of the document model.
// =========================================================

// Helper: populate <select> with language options
function populateLangSelect(select, currentLang) {
    var fallback = ['plaintext', 'python', 'javascript', 'java', 'c', 'cpp',
                    'csharp', 'rust', 'go', 'typescript', 'bash', 'ruby', 'php',
                    'swift', 'kotlin', 'r', 'haskell', 'lua', 'perl', 'scala', 'sql'];
    fallback.forEach(function (lang) {
        var opt = document.createElement('option');
        opt.value = lang;
        opt.textContent = lang;
        if (lang === currentLang) opt.selected = true;
        select.appendChild(opt);
    });
    // Hydrate with real server list when available
    if (window.MeCodeRunner) {
        window.MeCodeRunner.getLanguages().then(function (langs) {
            if (!langs || !langs.length) return;
            var current = select.value;
            select.innerHTML = '';
            langs.forEach(function (name) {
                var opt = document.createElement('option');
                opt.value = name;
                opt.textContent = name;
                if (name === current) opt.selected = true;
                select.appendChild(opt);
            });
            // Ensure current language is still present even if not in server list
            if (current && !select.querySelector('option[value="' + current + '"]')) {
                var opt = document.createElement('option');
                opt.value = current;
                opt.textContent = current;
                opt.selected = true;
                select.prepend(opt);
            }
        });
    }
}

// Default filenames per language
function defaultFileName(lang, index) {
    var names = {
        'java': 'Main.java', 'python': 'main.py', 'javascript': 'index.js',
        'typescript': 'index.ts', 'c': 'main.c', 'cpp': 'main.cpp',
        'csharp': 'Program.cs', 'go': 'main.go', 'rust': 'main.rs',
        'ruby': 'main.rb', 'php': 'main.php', 'swift': 'main.swift',
        'kotlin': 'Main.kt', 'scala': 'Main.scala', 'bash': 'script.sh',
        'r': 'main.R', 'lua': 'main.lua', 'haskell': 'Main.hs', 'perl': 'main.pl'
    };
    if (index === 0) return names[lang] || 'main.txt';
    var ext = (names[lang] || 'main.txt').split('.').pop();
    return 'file' + index + '.' + ext;
}

const RunnableCodeBlock = Node.create({
    name: 'runnableCodeBlock',
    group: 'block',
    content: 'text*',
    marks: '',
    code: true,
    defining: true,

    addAttributes() {
        return {
            language: {
                default: 'plaintext',
                parseHTML: el => el.getAttribute('data-language') || 'plaintext'
            },
            // Extra files stored as JSON string: [{"name":"Helper.java","content":"..."}]
            // The main file (index 0) content lives in contentDOM, not here.
            files: {
                default: '[]',
                parseHTML: el => el.getAttribute('data-files') || '[]'
            },
            // Name of the main file (index 0)
            mainFileName: {
                default: '',
                parseHTML: el => el.getAttribute('data-main-file') || ''
            }
        };
    },

    parseHTML() {
        return [
            {
                tag: 'div.me-rcb',
                preserveWhitespace: 'full',
                getAttrs: el => ({
                    language: el.getAttribute('data-language') || 'plaintext',
                    files: el.getAttribute('data-files') || '[]',
                    mainFileName: el.getAttribute('data-main-file') || ''
                }),
                contentElement: 'code'
            },
            // Backward compat: StarterKit's <pre><code>
            {
                tag: 'pre',
                preserveWhitespace: 'full',
                getAttrs: el => {
                    var code = el.querySelector('code');
                    if (!code) return false;
                    var cls = code.className || '';
                    var match = cls.match(/language-(\w+)/);
                    return { language: match ? match[1] : 'plaintext', files: '[]', mainFileName: '' };
                },
                contentElement: 'code'
            }
        ];
    },

    renderHTML({ HTMLAttributes }) {
        var attrs = {
            class: 'me-rcb',
            'data-language': HTMLAttributes.language || 'plaintext'
        };
        if (HTMLAttributes.files && HTMLAttributes.files !== '[]') {
            attrs['data-files'] = HTMLAttributes.files;
        }
        if (HTMLAttributes.mainFileName) {
            attrs['data-main-file'] = HTMLAttributes.mainFileName;
        }
        return ['div', mergeAttributes(attrs), ['pre', ['code', { spellcheck: 'false' }, 0]]];
    },

    addCommands() {
        return {
            setRunnableCodeBlock: (attrs) => ({ commands }) => {
                return commands.setNode(this.name, attrs || {});
            },
            toggleRunnableCodeBlock: (attrs) => ({ commands }) => {
                return commands.toggleNode(this.name, 'paragraph', attrs || {});
            }
        };
    },

    addKeyboardShortcuts() {
        return {
            'Tab': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                return editor.commands.insertContent('\t');
            },
            'Shift-Tab': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                return true;
            },
            'Mod-Enter': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                var { from } = editor.state.selection;
                document.dispatchEvent(new CustomEvent('me:run-code-block', { detail: { from: from } }));
                return true;
            },
            // Enter on an empty trailing line → exit code block, create paragraph below
            'Enter': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                var { $from, empty } = editor.state.selection;
                if (!empty) return false;
                var text = $from.parent.textContent;
                var offset = $from.parentOffset;
                // Check: cursor at end AND last char before cursor is a newline (empty trailing line)
                if (offset === text.length && offset > 0 && text.charAt(offset - 1) === '\n') {
                    // Delete the trailing newline and insert a paragraph after the block
                    var afterBlock = $from.after();
                    return editor.chain()
                        .deleteRange({ from: $from.pos - 1, to: $from.pos })
                        .insertContentAt(afterBlock - 1, { type: 'paragraph' })
                        .focus()
                        .run();
                }
                return false; // let ProseMirror insert a normal newline
            },
            // ArrowDown on the last line → move cursor to the node below
            'ArrowDown': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                var { $from } = editor.state.selection;
                var text = $from.parent.textContent;
                var textAfterCursor = text.slice($from.parentOffset);
                // If no newline after cursor, we're on the last line
                if (!textAfterCursor.includes('\n')) {
                    var afterBlock = $from.after();
                    var docSize = editor.state.doc.content.size;
                    if (afterBlock < docSize) {
                        editor.commands.setTextSelection(afterBlock);
                        return true;
                    }
                    // At end of document — create a paragraph
                    return editor.chain()
                        .insertContentAt(afterBlock, { type: 'paragraph' })
                        .setTextSelection(afterBlock + 1)
                        .run();
                }
                return false;
            },
            'Backspace': ({ editor }) => {
                if (!editor.isActive('runnableCodeBlock')) return false;
                var { $from } = editor.state.selection;
                if ($from.parentOffset > 0) return false;
                var parentContent = $from.parent.textContent;
                if (parentContent.length > 0) return false;
                return editor.commands.toggleNode('runnableCodeBlock', 'paragraph');
            }
        };
    },

    addNodeView() {
        return ({ node, getPos, editor: ed }) => {
            // ── State: files array ──────────────────────────────────
            // files[0] is the main file (content in contentDOM)
            // files[1..n] are extra files (content in this array)
            var lang = node.attrs.language || 'plaintext';
            var mainName = node.attrs.mainFileName || defaultFileName(lang, 0);
            var extraFiles = [];
            try { extraFiles = JSON.parse(node.attrs.files || '[]'); } catch (_) {}
            // Full files model: [{name, content}] — index 0 content is always from contentDOM
            var files = [{ name: mainName, content: '' }].concat(extraFiles);
            var activeTab = 0;

            // ── Outer wrapper ───────────────────────────────────────
            const dom = document.createElement('div');
            dom.className = 'me-rcb';
            dom.setAttribute('data-language', lang);

            // ── Header bar ──────────────────────────────────────────
            const header = document.createElement('div');
            header.className = 'me-rcb-header';
            header.contentEditable = 'false';

            const langSelect = document.createElement('select');
            langSelect.className = 'me-rcb-lang-select';
            langSelect.setAttribute('aria-label', 'Select language');
            populateLangSelect(langSelect, lang);

            langSelect.addEventListener('change', function (e) {
                e.stopPropagation();
                var newLang = langSelect.value;
                dom.setAttribute('data-language', newLang);
                // Update main file name if still default
                var oldDefault = defaultFileName(lang, 0);
                if (files[0].name === oldDefault) {
                    files[0].name = defaultFileName(newLang, 0);
                    renderTabs();
                }
                lang = newLang;
                persistAttrs();
            });

            const stdinBtn = document.createElement('button');
            stdinBtn.type = 'button';
            stdinBtn.className = 'me-rcb-stdin-btn';
            stdinBtn.title = 'Toggle stdin input';
            stdinBtn.textContent = 'stdin';

            const runBtn = document.createElement('button');
            runBtn.type = 'button';
            runBtn.className = 'me-rcb-run-btn';
            runBtn.innerHTML = '&#x25B6; Run';
            runBtn.setAttribute('aria-label', 'Run code');

            header.appendChild(langSelect);
            header.appendChild(stdinBtn);
            header.appendChild(runBtn);
            dom.appendChild(header);

            // ── File tabs bar ───────────────────────────────────────
            const tabBar = document.createElement('div');
            tabBar.className = 'me-rcb-tabs';
            tabBar.contentEditable = 'false';
            dom.appendChild(tabBar);

            // ── Pre + Code (contentDOM — main file) ─────────────────
            const pre = document.createElement('pre');
            pre.className = 'me-rcb-pre';
            const code = document.createElement('code');
            code.className = 'me-rcb-code';
            code.setAttribute('spellcheck', 'false');
            pre.appendChild(code);
            dom.appendChild(pre);

            // ── Extra file editor (textarea, shown when tab > 0) ────
            const extraEditor = document.createElement('div');
            extraEditor.className = 'me-rcb-extra-editor';
            extraEditor.style.display = 'none';
            extraEditor.contentEditable = 'false';
            const extraArea = document.createElement('textarea');
            extraArea.className = 'me-rcb-extra-area';
            extraArea.setAttribute('spellcheck', 'false');
            extraArea.addEventListener('keydown', function (e) {
                e.stopPropagation();
                // Tab key inserts a real tab
                if (e.key === 'Tab' && !e.shiftKey) {
                    e.preventDefault();
                    var start = extraArea.selectionStart;
                    var end = extraArea.selectionEnd;
                    extraArea.value = extraArea.value.substring(0, start) + '\t' + extraArea.value.substring(end);
                    extraArea.selectionStart = extraArea.selectionEnd = start + 1;
                }
            });
            extraArea.addEventListener('input', function () {
                if (activeTab > 0 && files[activeTab]) {
                    files[activeTab].content = extraArea.value;
                    persistAttrs();
                }
            });
            extraEditor.appendChild(extraArea);
            dom.appendChild(extraEditor);

            // ── Stdin panel ─────────────────────────────────────────
            const stdinPanel = document.createElement('div');
            stdinPanel.className = 'me-rcb-stdin-panel';
            stdinPanel.style.display = 'none';
            stdinPanel.contentEditable = 'false';
            const stdinArea = document.createElement('textarea');
            stdinArea.className = 'me-rcb-stdin-area';
            stdinArea.placeholder = 'Program input (stdin)';
            stdinArea.rows = 3;
            stdinArea.addEventListener('keydown', e => e.stopPropagation());
            stdinPanel.appendChild(stdinArea);
            dom.appendChild(stdinPanel);

            // ── Output panel ────────────────────────────────────────
            const outputPanel = document.createElement('div');
            outputPanel.className = 'me-rcb-output';
            outputPanel.style.display = 'none';
            outputPanel.contentEditable = 'false';
            dom.appendChild(outputPanel);

            // ── Persist attributes to TipTap document model ─────────
            function persistAttrs() {
                var pos = getPos();
                if (typeof pos !== 'number') return;
                var extraOnly = files.slice(1).map(function (f) {
                    return { name: f.name, content: f.content };
                });
                ed.view.dispatch(
                    ed.state.tr.setNodeMarkup(pos, undefined, {
                        language: langSelect.value || 'plaintext',
                        files: JSON.stringify(extraOnly),
                        mainFileName: files[0].name
                    })
                );
            }

            // ── Tab rendering ───────────────────────────────────────
            function renderTabs() {
                tabBar.innerHTML = '';
                // Only show tab bar if there are multiple files
                if (files.length <= 1) {
                    tabBar.style.display = 'none';
                    return;
                }
                tabBar.style.display = 'flex';

                files.forEach(function (file, idx) {
                    var tab = document.createElement('div');
                    tab.className = 'me-rcb-tab' + (idx === activeTab ? ' active' : '');

                    var nameSpan = document.createElement('span');
                    nameSpan.className = 'me-rcb-tab-name';
                    nameSpan.textContent = file.name;
                    tab.appendChild(nameSpan);

                    // Double-click to rename
                    nameSpan.addEventListener('dblclick', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        startRename(idx, nameSpan);
                    });

                    // Close button (not on main file)
                    if (idx > 0) {
                        var closeBtn = document.createElement('button');
                        closeBtn.className = 'me-rcb-tab-close';
                        closeBtn.type = 'button';
                        closeBtn.innerHTML = '&times;';
                        closeBtn.title = 'Remove file';
                        closeBtn.addEventListener('mousedown', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            removeFile(idx);
                        });
                        tab.appendChild(closeBtn);
                    }

                    // Click to switch tab
                    tab.addEventListener('mousedown', function (e) {
                        if (e.target === closeBtn) return;
                        e.preventDefault();
                        e.stopPropagation();
                        switchTab(idx);
                    });

                    tabBar.appendChild(tab);
                });

                // Add file button
                var addBtn = document.createElement('button');
                addBtn.className = 'me-rcb-tab-add';
                addBtn.type = 'button';
                addBtn.innerHTML = '+';
                addBtn.title = 'Add file';
                addBtn.addEventListener('mousedown', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    addFile();
                });
                tabBar.appendChild(addBtn);
            }

            // ── Tab switching ───────────────────────────────────────
            function switchTab(idx) {
                if (idx === activeTab) return;
                // Save current extra file content
                if (activeTab > 0 && files[activeTab]) {
                    files[activeTab].content = extraArea.value;
                }
                activeTab = idx;
                if (idx === 0) {
                    // Show contentDOM (main file), hide extra editor
                    pre.style.display = '';
                    extraEditor.style.display = 'none';
                    ed.commands.focus();
                } else {
                    // Hide contentDOM, show extra editor
                    pre.style.display = 'none';
                    extraEditor.style.display = 'block';
                    extraArea.value = files[idx].content || '';
                    extraArea.focus();
                }
                renderTabs();
            }

            // ── Add file ────────────────────────────────────────────
            function addFile() {
                var name = defaultFileName(langSelect.value || lang, files.length);
                files.push({ name: name, content: '' });
                persistAttrs();
                switchTab(files.length - 1);
            }

            // ── Remove file ─────────────────────────────────────────
            function removeFile(idx) {
                if (idx <= 0 || idx >= files.length) return;
                files.splice(idx, 1);
                if (activeTab >= idx) {
                    activeTab = Math.max(0, activeTab - 1);
                }
                // If we were viewing the removed file, switch back
                if (activeTab === 0) {
                    pre.style.display = '';
                    extraEditor.style.display = 'none';
                } else {
                    extraArea.value = files[activeTab].content || '';
                }
                persistAttrs();
                renderTabs();
            }

            // ── Rename file ─────────────────────────────────────────
            function startRename(idx, nameSpan) {
                var input = document.createElement('input');
                input.type = 'text';
                input.className = 'me-rcb-tab-rename';
                input.value = files[idx].name;
                input.addEventListener('keydown', function (e) {
                    e.stopPropagation();
                    if (e.key === 'Enter') { finishRename(); }
                    if (e.key === 'Escape') { cancelRename(); }
                });
                input.addEventListener('blur', finishRename);

                nameSpan.textContent = '';
                nameSpan.appendChild(input);
                input.focus();
                input.select();

                var done = false;
                function finishRename() {
                    if (done) return;
                    done = true;
                    var newName = input.value.trim();
                    if (newName && newName !== files[idx].name) {
                        // Check for duplicates
                        var dup = files.some(function (f, i) { return i !== idx && f.name === newName; });
                        if (!dup) files[idx].name = newName;
                    }
                    nameSpan.textContent = files[idx].name;
                    persistAttrs();
                }
                function cancelRename() {
                    if (done) return;
                    done = true;
                    nameSpan.textContent = files[idx].name;
                }
            }

            // ── Stdin toggle ────────────────────────────────────────
            stdinBtn.addEventListener('mousedown', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var open = stdinPanel.style.display !== 'none';
                stdinPanel.style.display = open ? 'none' : 'block';
                stdinBtn.classList.toggle('active', !open);
                if (!open) stdinArea.focus();
            });

            // ── Gather all files for execution ──────────────────────
            function gatherFiles() {
                // Always read main file from contentDOM
                var mainContent = code.textContent || '';
                var result = [{ name: files[0].name, content: mainContent }];
                for (var i = 1; i < files.length; i++) {
                    // If this is the active extra tab, read from textarea
                    var content = (i === activeTab) ? extraArea.value : files[i].content;
                    result.push({ name: files[i].name, content: content });
                }
                return result;
            }

            // ── Run logic ───────────────────────────────────────────
            function doRun() {
                if (runBtn.disabled) return;
                if (!window.MeCodeRunner) return;
                var curLang = dom.getAttribute('data-language') || 'plaintext';
                var allFiles = gatherFiles();
                var hasContent = allFiles.some(function (f) { return f.content.trim(); });
                if (!hasContent) return;
                var stdin = stdinPanel.style.display !== 'none' ? (stdinArea.value || '') : '';
                runBtn.disabled = true;
                runBtn.innerHTML = '&#x23F3; Running...';
                window.MeCodeRunner.run(curLang, allFiles, stdin, outputPanel).then(function () {
                    runBtn.disabled = false;
                    runBtn.innerHTML = '&#x25B6; Run';
                }).catch(function () {
                    runBtn.disabled = false;
                    runBtn.innerHTML = '&#x25B6; Run';
                });
            }

            runBtn.addEventListener('mousedown', function (e) {
                e.preventDefault();
                e.stopPropagation();
                doRun();
            });

            // Ctrl/Cmd+Enter handler
            function onRunShortcut(e) {
                var cursorFrom = e.detail && e.detail.from;
                if (typeof cursorFrom !== 'number') return;
                var pos = getPos();
                if (typeof pos !== 'number') return;
                var n = ed.state.doc.nodeAt(pos);
                if (n && cursorFrom > pos && cursorFrom <= pos + n.nodeSize) {
                    doRun();
                }
            }
            document.addEventListener('me:run-code-block', onRunShortcut);

            // ── Auto-detect language (debounced, with loop guard) ───
            var detectTimer = null;
            var isAutoDetecting = false;
            var codeObserver = new MutationObserver(function () {
                if (isAutoDetecting) return;
                clearTimeout(detectTimer);
                detectTimer = setTimeout(function () {
                    if (!window.MeCodeRunner) return;
                    var text = code.textContent || '';
                    if (text.trim().length < 10) return;
                    var detected = window.MeCodeRunner.detectLanguage(text);
                    if (detected && detected !== langSelect.value && langSelect.value === 'plaintext') {
                        langSelect.value = detected;
                        if (langSelect.value !== detected) return;
                        dom.setAttribute('data-language', detected);
                        // Update main filename if default
                        var oldDefault = defaultFileName('plaintext', 0);
                        if (files[0].name === oldDefault || files[0].name === 'main.txt') {
                            files[0].name = defaultFileName(detected, 0);
                            renderTabs();
                        }
                        lang = detected;
                        var pos = getPos();
                        if (typeof pos === 'number') {
                            isAutoDetecting = true;
                            persistAttrs();
                            isAutoDetecting = false;
                        }
                    }
                }, 1000);
            });
            codeObserver.observe(code, { childList: true, subtree: true, characterData: true });

            // ── Initial tab bar render ──────────────────────────────
            renderTabs();

            // ── Show + button in header when single file ────────────
            // (tab bar is hidden for single file, so we need an add button in the header)
            const headerAddBtn = document.createElement('button');
            headerAddBtn.type = 'button';
            headerAddBtn.className = 'me-rcb-add-file-btn';
            headerAddBtn.innerHTML = '+ File';
            headerAddBtn.title = 'Add a file';
            headerAddBtn.addEventListener('mousedown', function (e) {
                e.preventDefault();
                e.stopPropagation();
                addFile();
            });
            // Insert before stdin button
            header.insertBefore(headerAddBtn, stdinBtn);

            return {
                dom,
                contentDOM: code,

                update(updatedNode) {
                    if (updatedNode.type.name !== 'runnableCodeBlock') return false;
                    var newLang = updatedNode.attrs.language || 'plaintext';
                    if (newLang !== langSelect.value) {
                        langSelect.value = newLang;
                        dom.setAttribute('data-language', newLang);
                    }
                    // Sync extra files from attrs (e.g., on undo/redo)
                    try {
                        var newExtra = JSON.parse(updatedNode.attrs.files || '[]');
                        var newMain = updatedNode.attrs.mainFileName || files[0].name;
                        files = [{ name: newMain, content: '' }].concat(newExtra);
                        if (activeTab >= files.length) {
                            activeTab = 0;
                            pre.style.display = '';
                            extraEditor.style.display = 'none';
                        }
                        if (activeTab > 0) {
                            extraArea.value = files[activeTab].content || '';
                        }
                        renderTabs();
                    } catch (_) {}
                    return true;
                },

                selectNode() {
                    dom.classList.add('me-rcb-selected');
                },

                deselectNode() {
                    dom.classList.remove('me-rcb-selected');
                },

                stopEvent(event) {
                    var target = event.target;
                    return header.contains(target) ||
                           tabBar.contains(target) ||
                           extraEditor.contains(target) ||
                           outputPanel.contains(target) ||
                           stdinPanel.contains(target);
                },

                ignoreMutation(mutation) {
                    return mutation.target !== code && !code.contains(mutation.target);
                },

                destroy() {
                    codeObserver.disconnect();
                    clearTimeout(detectTimer);
                    document.removeEventListener('me:run-code-block', onRunShortcut);
                }
            };
        };
    }
});

// =========================================================
//  INITIAL CONTENT — blank document (single empty paragraph)
// =========================================================
const INITIAL_CONTENT = '<p></p>';

// =========================================================
//  CREATE EDITOR
// =========================================================
window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
window.MathfieldElement.soundsDirectory = null;

const editorEl = document.querySelector('.me-canvas');
if (editorEl) {
    editorEl.innerHTML = '';
    editorEl.removeAttribute('contenteditable');

    const editor = new Editor({
        element: editorEl,
        extensions: [
            StarterKit.configure({ heading: { levels: [1, 2, 3] }, codeBlock: false }),
            Placeholder.configure({
                placeholder: ({ node, pos }) =>
                    pos === 0 ? "Start typing, press '/' for commands, or $ for math..." : '',
                showOnlyWhenEditable: true,
                showOnlyCurrent: false,
            }),
            Underline,
            TextAlign.configure({ types: ['heading', 'paragraph'] }),
            Table.configure({ resizable: false }),
            TableRow,
            TableCell,
            TableHeader,
            MeImage,
            DrawingBlock,
            RunnableCodeBlock,
            MathInline,
            MathBlock
        ],
        content: INITIAL_CONTENT,
        editorProps: {
            attributes: { spellcheck: 'true' }
        },
        onUpdate({ editor: e }) {
            document.dispatchEvent(new CustomEvent('me:content-changed', { detail: { editor: e } }));
        },
        onSelectionUpdate({ editor: e }) {
            document.dispatchEvent(new CustomEvent('me:selection-changed', { detail: { editor: e } }));
        }
    });

    window.MeEditor = editor;
    document.dispatchEvent(new Event('me:editor-ready'));
}
