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
            StarterKit.configure({ heading: { levels: [1, 2, 3] } }),
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
