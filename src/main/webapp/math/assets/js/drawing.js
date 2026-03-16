/**
 * drawing.js — Fabric.js math drawing canvas (Mathcha-style)
 *
 * Features:
 *   - Grid with snap, toggle, adjustable size
 *   - Math text boxes (MathLive <math-field> on canvas)
 *   - Connected arrows between objects (commutative diagrams)
 *   - Lines: straight, curved (quadratic Bezier), dashed
 *   - Arrows: straight, curved, double-headed
 *   - Shapes: rect, square, circle, ellipse, triangle, regular polygon (n-sides)
 *   - Arc / angle marker for geometry
 *   - Coordinate axes with labels, number line
 *   - Function curves: wave/sine, quadratic, cubic
 *   - Braces, springs, rulers
 *   - Rotation, z-order, undo/redo, color, width, fill, border style
 */
(function () {
    'use strict';

    // ── State ────────────────────────────────────────────────
    var canvas = null;
    var modal = null;
    var activeTool = 'select';
    var strokeColor = '#1e293b';
    var fillColor = 'transparent';
    var strokeWidth = 2;
    var undoStack = [];
    var redoStack = [];
    var isRestoring = false;
    var onSaveCallback = null;

    // Shape drawing state
    var isDrawingShape = false;
    var shapeOrigin = null;
    var activeShape = null;

    // Grid state
    var gridVisible = true;
    var gridSize = 40;
    var snapToGrid = true;

    // Connected arrow state
    var connSourceObj = null;

    // Regular polygon sides
    var polygonSides = 6;

    // Freeform polygon: click to add vertices
    var freeformPoints = [];
    var freeformPreviewLine = null;
    var freeformLastClick = 0;
    var freeformLastPoint = null;

    // Suppress state saves during drag-draw
    var suppressSave = false;

    // Resize observer (cleaned up on close)
    var resizeObserver = null;

    // ── Constants ────────────────────────────────────────────
    var COLORS = [
        '#1e293b', '#ef4444', '#f97316', '#eab308', '#22c55e',
        '#3b82f6', '#8b5cf6', '#ec4899', '#ffffff', '#64748b'
    ];
    var WIDTHS = [1, 2, 3, 5, 8];

    // ── Tool Definitions ─────────────────────────────────────
    var TOOL_GROUPS = [
        {
            label: 'Tools',
            tools: [
                { id: 'select',    icon: '\u271B',     label: 'Select / Move' },
                { id: 'draw',      icon: '\u270F',     label: 'Freehand Pencil' },
                { id: 'eraser',    icon: '\u232B',     label: 'Eraser' },
            ]
        },
        {
            label: 'Text',
            tools: [
                { id: 'text',      icon: 'T',          label: 'Text Label' },
                { id: 'mathtext',  icon: '\u03A3',     label: 'Math Formula Box' },
            ]
        },
        {
            label: 'Lines',
            tools: [
                { id: 'line',       icon: '\u2571',    label: 'Straight Line' },
                { id: 'dashed',     icon: '\u2504',    label: 'Dashed Line' },
                { id: 'curve',      icon: '\u223F',    label: 'Curved Line' },
                { id: 'arrow',      icon: '\u2192',    label: 'Arrow' },
                { id: 'dblarrow',   icon: '\u2194',    label: 'Double Arrow' },
                { id: 'curvearrow', icon: '\u21B7',    label: 'Curved Arrow' },
                { id: 'connect',    icon: '\u21CC',    label: 'Connect (drag between objects)' },
            ]
        },
        {
            label: 'Shapes',
            tools: [
                { id: 'rect',      icon: '\u25AD',     label: 'Rectangle' },
                { id: 'square',    icon: '\u25A1',     label: 'Square' },
                { id: 'circle',    icon: '\u25CB',     label: 'Circle' },
                { id: 'ellipse',   icon: '\u2B2D',     label: 'Ellipse' },
                { id: 'triangle',  icon: '\u25B3',     label: 'Triangle' },
                { id: 'polygon',   icon: '\u2B21',     label: 'Regular Polygon' },
            ]
        },
        {
            label: 'Math',
            tools: [
                { id: 'axes',       icon: '\u2295',    label: 'Cartesian Axes' },
                { id: 'numberline', icon: '\u21A6',    label: 'Number Line' },
                { id: 'angle',      icon: '\u2220',    label: 'Angle Arc' },
                { id: 'rightangle', icon: '\u221F',    label: 'Right Angle' },
                { id: 'arc',        icon: '\u2322',    label: 'Arc / Segment' },
                { id: 'brace',      icon: '\u23DE',    label: 'Brace' },
                { id: 'congruence', icon: '\u2243',    label: 'Congruent Segments (tick marks)' },
                { id: 'unitcircle', icon: '\u25CB',    label: 'Unit Circle (with angles)' },
                { id: 'tangent',    icon: '\u2312',    label: 'Tangent Line (calculus)' },
                { id: 'hyperbola',  icon: '\u224C',    label: 'Hyperbola' },
                { id: 'exponential', icon: '\u212F',   label: 'Exponential Curve (e^x)' },
                { id: 'wave',       icon: '\u223C',    label: 'Sine Wave' },
                { id: 'parabola',   icon: '\u222A',    label: 'Parabola (Quadratic)' },
                { id: 'cubic',      icon: '\u223E',    label: 'Cubic Curve' },
                { id: 'spring',     icon: '\u299A',    label: 'Spring' },
                { id: 'parallel',   icon: '\u2225',    label: 'Parallel Lines' },
                { id: 'ruler',      icon: '\u{1F4CF}', label: 'Ruler' },
            ]
        },
        {
            label: 'Custom',
            tools: [
                { id: 'freeform',   icon: '\u2726',    label: 'Freeform Polygon (click vertices)' },
                { id: 'polyline',   icon: '\u27A4',    label: 'Custom Path (click points, open)' },
            ]
        },
    ];

    // ══════════════════════════════════════════════════════════
    //  MODAL BUILD
    // ══════════════════════════════════════════════════════════
    function ensureModal() {
        if (!modal) {
            modal = document.createElement('div');
            modal.className = 'me-draw-overlay';
            modal.setAttribute('tabindex', '0');
            document.body.appendChild(modal);
        }
        // Rebuild inner HTML each time so the <canvas> element is fresh
        modal.innerHTML = buildHTML();
        wireEvents();
    }

    function buildHTML() {
        var h = '';

        // ─── Top toolbar ───
        h += '<div class="me-draw-toolbar">';
        TOOL_GROUPS.forEach(function (g) {
            h += '<div class="me-draw-tool-group">';
            h += '<span class="me-draw-group-label">' + g.label + '</span>';
            g.tools.forEach(function (t) {
                h += '<button class="me-draw-tool" data-tool="' + t.id + '" title="' + t.label + '">' + t.icon + '</button>';
            });
            h += '</div>';
        });
        // Polygon sides
        h += '<div class="me-draw-tool-group me-draw-poly-sides" style="display:none">';
        h += '<span class="me-draw-group-label">Sides</span>';
        h += '<button class="me-draw-poly-dec" title="Fewer sides">&minus;</button>';
        h += '<span class="me-draw-poly-count">' + polygonSides + '</span>';
        h += '<button class="me-draw-poly-inc" title="More sides">+</button>';
        h += '</div>';
        h += '</div>';

        // ─── Settings bar ───
        h += '<div class="me-draw-settings-bar">';
        // Grid
        h += '<div class="me-draw-tool-group">';
        h += '<span class="me-draw-group-label">Grid</span>';
        h += '<button class="me-draw-grid-toggle' + (gridVisible ? ' active' : '') + '" title="Toggle grid">\u25A6</button>';
        h += '<button class="me-draw-snap-toggle' + (snapToGrid ? ' active' : '') + '" title="Snap to grid">\u2A02</button>';
        h += '<input type="range" class="me-draw-grid-size" min="10" max="80" value="' + gridSize + '" title="Grid size">';
        h += '</div>';
        // Colors
        h += '<div class="me-draw-tool-group">';
        h += '<span class="me-draw-group-label">Color</span>';
        COLORS.forEach(function (c) {
            h += '<button class="me-draw-color' + (c === strokeColor ? ' active' : '') + '" data-color="' + c + '" title="' + c + '" style="background:' + c + ';"></button>';
        });
        h += '</div>';
        // Width
        h += '<div class="me-draw-tool-group">';
        h += '<span class="me-draw-group-label">Width</span>';
        WIDTHS.forEach(function (w) {
            h += '<button class="me-draw-width' + (w === strokeWidth ? ' active' : '') + '" data-width="' + w + '" title="' + w + 'px">';
            h += '<span style="width:' + Math.min(w * 3, 20) + 'px;height:' + Math.min(w, 6) + 'px;background:currentColor;display:inline-block;border-radius:2px;vertical-align:middle"></span>';
            h += '</button>';
        });
        h += '</div>';
        // Style
        h += '<div class="me-draw-tool-group">';
        h += '<span class="me-draw-group-label">Style</span>';
        h += '<button class="me-draw-fill-toggle' + (fillColor !== 'transparent' ? ' active' : '') + '" title="Toggle fill">Fill</button>';
        h += '<select class="me-draw-dash-style" title="Border style">';
        h += '<option value="solid">Solid</option><option value="dashed">Dashed</option><option value="dotted">Dotted</option>';
        h += '</select>';
        h += '</div>';
        // Actions
        h += '<div class="me-draw-tool-group me-draw-actions">';
        h += '<button class="me-draw-undo" title="Undo (Ctrl+Z)">\u21B6</button>';
        h += '<button class="me-draw-redo" title="Redo (Ctrl+Y)">\u21B7</button>';
        h += '<button class="me-draw-delete" title="Delete selected">\u2716</button>';
        h += '<button class="me-draw-zfront" title="Bring to front">\u2B06</button>';
        h += '<button class="me-draw-zback" title="Send to back">\u2B07</button>';
        h += '<button class="me-draw-clear" title="Clear all">\u{1F5D1}</button>';
        h += '</div>';
        h += '</div>';

        // ─── Canvas ───
        h += '<div class="me-draw-canvas-wrap"><canvas id="me-draw-canvas"></canvas></div>';

        // ─── Footer ───
        h += '<div class="me-draw-footer">';
        h += '<span class="me-draw-status">Draw diagrams: use presets or create your own with Freeform Polygon. Grid helps align.</span>';
        h += '<div>';
        h += '<button class="me-draw-cancel">Cancel</button>';
        h += '<button class="me-draw-done" id="me-draw-done-btn" title="Add something to the canvas first">Insert Drawing</button>';
        h += '</div></div>';
        return h;
    }

    // ══════════════════════════════════════════════════════════
    //  WIRE EVENTS
    // ══════════════════════════════════════════════════════════
    function wireEvents() {
        modal.querySelectorAll('.me-draw-tool').forEach(function (btn) {
            btn.addEventListener('click', function () { setTool(btn.dataset.tool); });
        });
        modal.querySelectorAll('.me-draw-color').forEach(function (btn) {
            btn.addEventListener('click', function () { setStrokeColor(btn.dataset.color); });
        });
        modal.querySelectorAll('.me-draw-width').forEach(function (btn) {
            btn.addEventListener('click', function () { setStrokeWidth(parseInt(btn.dataset.width, 10)); });
        });
        modal.querySelector('.me-draw-fill-toggle').addEventListener('click', toggleFill);
        modal.querySelector('.me-draw-dash-style').addEventListener('change', function () {
            var obj = canvas && canvas.getActiveObject();
            if (obj) { obj.set('strokeDashArray', dashArrayFor(this.value)); canvas.requestRenderAll(); }
        });
        modal.querySelector('.me-draw-grid-toggle').addEventListener('click', toggleGrid);
        modal.querySelector('.me-draw-snap-toggle').addEventListener('click', toggleSnap);
        modal.querySelector('.me-draw-grid-size').addEventListener('input', function () {
            gridSize = parseInt(this.value, 10);
            renderGrid();
        });
        modal.querySelector('.me-draw-poly-dec').addEventListener('click', function () {
            if (polygonSides > 3) { polygonSides--; modal.querySelector('.me-draw-poly-count').textContent = polygonSides; }
        });
        modal.querySelector('.me-draw-poly-inc').addEventListener('click', function () {
            if (polygonSides < 20) { polygonSides++; modal.querySelector('.me-draw-poly-count').textContent = polygonSides; }
        });
        modal.querySelector('.me-draw-undo').addEventListener('click', undo);
        modal.querySelector('.me-draw-redo').addEventListener('click', redo);
        modal.querySelector('.me-draw-delete').addEventListener('click', deleteSelected);
        modal.querySelector('.me-draw-zfront').addEventListener('click', function () {
            var o = canvas && canvas.getActiveObject();
            if (o) { canvas.bringToFront(o); canvas.requestRenderAll(); }
        });
        modal.querySelector('.me-draw-zback').addEventListener('click', function () {
            var o = canvas && canvas.getActiveObject();
            if (o) { canvas.sendToBack(o); canvas.requestRenderAll(); }
        });
        modal.querySelector('.me-draw-clear').addEventListener('click', clearCanvas);
        modal.querySelector('.me-draw-done').addEventListener('click', onDone);
        modal.querySelector('.me-draw-cancel').addEventListener('click', onCancel);

        // Keyboard — only when NOT editing text inside canvas
        modal.addEventListener('keydown', function (e) {
            // If user is editing an IText inside the canvas, let fabric handle it
            if (canvas) {
                var ao = canvas.getActiveObject();
                if (ao && ao.isEditing) return;
            }
            if (e.key === 'Escape') {
                if (connSourceObj) {
                    try { connSourceObj.set('shadow', null); } catch (_) {}
                    connSourceObj = null;
                    canvas.requestRenderAll();
                    status('Connect cancelled. Click first object, then second.');
                    return;
                }
                if ((activeTool === 'freeform' || activeTool === 'polyline') && freeformPoints.length > 0) {
                    cancelFreeform();
                    return;
                }
                onCancel();
                return;
            }
            if (e.key === 'Enter' && (activeTool === 'freeform' || activeTool === 'polyline') && freeformPoints.length >= 2) {
                e.preventDefault();
                finishFreeform();
                return;
            }
            if ((e.ctrlKey || e.metaKey) && e.key === 'z' && !e.shiftKey) { e.preventDefault(); undo(); }
            if ((e.ctrlKey || e.metaKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey))) { e.preventDefault(); redo(); }
            if (e.key === 'Delete' || e.key === 'Backspace') { e.preventDefault(); deleteSelected(); }
        });
    }

    // ══════════════════════════════════════════════════════════
    //  HELPERS
    // ══════════════════════════════════════════════════════════
    function dashArrayFor(style) {
        if (style === 'dashed') return [10, 6];
        if (style === 'dotted') return [3, 4];
        return null;
    }

    function snap(v) {
        return snapToGrid ? Math.round(v / gridSize) * gridSize : v;
    }

    function status(msg) {
        var el = modal && modal.querySelector('.me-draw-status');
        if (el) el.textContent = msg;
    }

    // Enable/disable Insert Drawing based on canvas content
    function updateDoneButton() {
        var btn = modal && modal.querySelector('.me-draw-done');
        if (!btn || !canvas) return;
        var hasContent = canvas.getObjects && canvas.getObjects().length > 0;
        btn.disabled = !hasContent;
        btn.title = hasContent ? 'Insert drawing into document' : 'Add a shape, line, or text first';
        btn.classList.toggle('me-draw-done-disabled', !hasContent);
    }

    // ══════════════════════════════════════════════════════════
    //  GRID — drawn directly on canvas background, NOT as objects
    //  This avoids grid polluting toJSON/undo/redo/export
    // ══════════════════════════════════════════════════════════
    function renderGrid() {
        if (!canvas) return;
        var ctx = canvas.getContext();  // lower canvas context (background)
        // We use the afterRender event instead
        canvas.requestRenderAll();
    }

    function drawGridOnCanvas(ctx) {
        if (!gridVisible) return;
        var w = canvas.getWidth(), h = canvas.getHeight();
        ctx.save();
        ctx.strokeStyle = '#e2e8f0';
        ctx.lineWidth = 0.5;
        ctx.beginPath();
        for (var x = 0; x <= w; x += gridSize) {
            ctx.moveTo(x, 0);
            ctx.lineTo(x, h);
        }
        for (var y = 0; y <= h; y += gridSize) {
            ctx.moveTo(0, y);
            ctx.lineTo(w, y);
        }
        ctx.stroke();
        ctx.restore();
    }

    function toggleGrid() {
        gridVisible = !gridVisible;
        modal.querySelector('.me-draw-grid-toggle').classList.toggle('active', gridVisible);
        canvas.requestRenderAll();
    }

    function toggleSnap() {
        snapToGrid = !snapToGrid;
        modal.querySelector('.me-draw-snap-toggle').classList.toggle('active', snapToGrid);
    }

    // ══════════════════════════════════════════════════════════
    //  INIT CANVAS
    // ══════════════════════════════════════════════════════════
    function initCanvas() {
        var wrap = modal.querySelector('.me-draw-canvas-wrap');
        var w = wrap.clientWidth - 4;
        var h = wrap.clientHeight - 4;

        canvas = new fabric.Canvas('me-draw-canvas', {
            width: w, height: h,
            backgroundColor: '#ffffff',
            selection: true,
            preserveObjectStacking: true,
        });

        // Draw grid on the lower canvas (below objects, not part of object tree)
        canvas.on('after:render', function () {
            drawGridOnCanvas(canvas.getContext());
        });

        canvas.on('mouse:down', onMouseDown);
        canvas.on('mouse:move', onMouseMove);
        canvas.on('mouse:up', onMouseUp);

        // Save state (debounced to avoid flood during drag-draw)
        canvas.on('object:added', function () {
            if (!suppressSave) saveState();
            updateDoneButton();
        });
        canvas.on('object:modified', function () { if (!suppressSave) saveState(); });
        canvas.on('object:removed', function () {
            if (!suppressSave) saveState();
            updateDoneButton();
        });

        // Snap on move
        canvas.on('object:moving', function (e) {
            if (!snapToGrid) return;
            e.target.set({ left: snap(e.target.left), top: snap(e.target.top) });
        });

        undoStack = [];
        redoStack = [];
        saveState();
        setTool('select');
        updateDoneButton();
    }

    // ══════════════════════════════════════════════════════════
    //  TOOL SWITCHING
    // ══════════════════════════════════════════════════════════
    function setTool(tool) {
        activeTool = tool;
        if (!canvas) return;
        canvas.isDrawingMode = false;
        canvas.selection = true;
        canvas.defaultCursor = 'default';
        canvas.hoverCursor = 'move';
        isDrawingShape = false;
        connSourceObj = null;
        cancelFreeform();

        modal.querySelectorAll('.me-draw-tool').forEach(function (btn) {
            btn.classList.toggle('active', btn.dataset.tool === tool);
        });

        var polySec = modal.querySelector('.me-draw-poly-sides');
        if (polySec) polySec.style.display = tool === 'polygon' ? '' : 'none';

        var dragTools = ['line','dashed','arrow','dblarrow','curve','curvearrow','rect','square','circle','ellipse','triangle','polygon','arc'];

        if (tool === 'draw') {
            canvas.isDrawingMode = true;
            canvas.freeDrawingBrush = new fabric.PencilBrush(canvas);
            canvas.freeDrawingBrush.color = strokeColor;
            canvas.freeDrawingBrush.width = strokeWidth;
            status('Draw freehand. Change color and width in the bar above.');
        } else if (tool === 'eraser') {
            canvas.isDrawingMode = true;
            canvas.freeDrawingBrush = new fabric.PencilBrush(canvas);
            canvas.freeDrawingBrush.color = '#ffffff';
            canvas.freeDrawingBrush.width = strokeWidth * 5;
            status('Draw over areas to cover them with white');
        } else if (dragTools.indexOf(tool) >= 0) {
            canvas.selection = false;
            canvas.defaultCursor = 'crosshair';
            canvas.hoverCursor = 'crosshair';
            status('Click and drag to draw ' + tool);
        } else if (tool === 'text') {
            canvas.defaultCursor = 'text';
            status('Click to add a label. Double-click to edit later.');
        } else if (tool === 'mathtext') {
            canvas.defaultCursor = 'text';
            status('Click to add a math formula. Double-click to edit LaTeX.');
        } else if (tool === 'connect') {
            canvas.selection = false;
            canvas.defaultCursor = 'crosshair';
            canvas.hoverCursor = 'pointer';
            status('Connect shapes with arrows: click first object, then the second. Press Esc to cancel.');
        } else if (tool === 'freeform') {
            canvas.selection = false;
            canvas.defaultCursor = 'crosshair';
            canvas.hoverCursor = 'crosshair';
            status('Click to add vertices. Double-click or click first point to close. Esc to cancel.');
        } else if (tool === 'polyline') {
            canvas.selection = false;
            canvas.defaultCursor = 'crosshair';
            canvas.hoverCursor = 'crosshair';
            status('Click to add points. Double-click or Enter to finish (open path). Esc to cancel.');
        } else if (tool === 'select') {
            status('Select objects to move or edit. Double-click text to change it.');
        } else {
            // One-click math inserts
            insertMathObject(tool);
            setTool('select');
        }
    }

    // ── Color / Width / Fill ─────────────────────────────────
    function setStrokeColor(color) {
        strokeColor = color;
        modal.querySelectorAll('.me-draw-color').forEach(function (btn) {
            btn.classList.toggle('active', btn.dataset.color === color);
        });
        if (canvas && canvas.isDrawingMode && canvas.freeDrawingBrush) {
            canvas.freeDrawingBrush.color = color;
        }
        var obj = canvas && canvas.getActiveObject();
        if (obj) { obj.set('stroke', color); canvas.requestRenderAll(); }
    }

    function setStrokeWidth(w) {
        strokeWidth = w;
        modal.querySelectorAll('.me-draw-width').forEach(function (btn) {
            btn.classList.toggle('active', parseInt(btn.dataset.width, 10) === w);
        });
        if (canvas && canvas.isDrawingMode && canvas.freeDrawingBrush) {
            canvas.freeDrawingBrush.width = w;
        }
        var obj = canvas && canvas.getActiveObject();
        if (obj) { obj.set('strokeWidth', w); canvas.requestRenderAll(); }
    }

    function toggleFill() {
        var btn = modal.querySelector('.me-draw-fill-toggle');
        if (fillColor === 'transparent') {
            fillColor = strokeColor;
            btn.classList.add('active');
        } else {
            fillColor = 'transparent';
            btn.classList.remove('active');
        }
        var obj = canvas && canvas.getActiveObject();
        if (obj && obj.type !== 'line' && obj.type !== 'path') {
            obj.set('fill', fillColor);
            canvas.requestRenderAll();
        }
    }

    // ══════════════════════════════════════════════════════════
    //  MOUSE HANDLERS
    // ══════════════════════════════════════════════════════════
    function onMouseDown(opt) {
        if (activeTool === 'select' || activeTool === 'draw' || activeTool === 'eraser') return;

        var pointer = canvas.getPointer(opt.e);
        var px = snap(pointer.x), py = snap(pointer.y);

        // ── Text label ──
        if (activeTool === 'text') {
            var text = new fabric.IText('Label', {
                left: px, top: py,
                fontFamily: 'Inter, Arial, sans-serif',
                fontSize: 18, fill: strokeColor, editable: true,
            });
            canvas.add(text);
            canvas.setActiveObject(text);
            text.enterEditing();
            setTool('select');
            return;
        }

        // ── Math formula box ──
        if (activeTool === 'mathtext') {
            insertMathTextBox(px, py);
            setTool('select');
            return;
        }

        // ── Connect mode ──
        if (activeTool === 'connect') {
            handleConnect(opt);
            return;
        }

        // ── Freeform polygon / Polyline ──
        if (activeTool === 'freeform' || activeTool === 'polyline') {
            handleFreeformClick(px, py);
            return;
        }

        // ── Drag-draw shapes ──
        var dragTools = ['line','dashed','arrow','dblarrow','curve','curvearrow','rect','square','circle','ellipse','triangle','polygon','arc'];
        if (dragTools.indexOf(activeTool) < 0) return;

        isDrawingShape = true;
        suppressSave = true;  // Don't flood undo during drag
        shapeOrigin = { x: px, y: py };
        activeShape = createInitialShape(activeTool, px, py);
        if (activeShape) canvas.add(activeShape);
    }

    function onMouseMove(opt) {
        // Freeform / polyline preview line
        if ((activeTool === 'freeform' || activeTool === 'polyline') && freeformPoints.length > 0) {
            var pointer = canvas.getPointer(opt.e);
            var px = snap(pointer.x), py = snap(pointer.y);
            updateFreeformPreview(px, py);
            return;
        }
        if (!isDrawingShape || !activeShape) return;
        var pointer = canvas.getPointer(opt.e);
        var px = snap(pointer.x), py = snap(pointer.y);
        var ox = shapeOrigin.x, oy = shapeOrigin.y;
        var dx = px - ox, dy = py - oy;

        switch (activeTool) {
            case 'line': case 'dashed': case 'arrow': case 'dblarrow': case 'curve': case 'curvearrow':
                activeShape.set({ x2: px, y2: py });
                break;
            case 'rect':
                activeShape.set({
                    left: Math.min(ox, px), top: Math.min(oy, py),
                    width: Math.abs(dx), height: Math.abs(dy),
                });
                break;
            case 'square':
                var side = Math.max(Math.abs(dx), Math.abs(dy));
                activeShape.set({
                    left: dx < 0 ? ox - side : ox,
                    top: dy < 0 ? oy - side : oy,
                    width: side, height: side,
                });
                break;
            case 'circle':
                var r = Math.sqrt(dx * dx + dy * dy) / 2;
                activeShape.set({
                    left: (ox + px) / 2 - r, top: (oy + py) / 2 - r, radius: r,
                });
                break;
            case 'ellipse':
                activeShape.set({
                    left: Math.min(ox, px), top: Math.min(oy, py),
                    rx: Math.abs(dx) / 2, ry: Math.abs(dy) / 2,
                });
                break;
            case 'triangle':
                activeShape.set({
                    left: Math.min(ox, px), top: Math.min(oy, py),
                    width: Math.abs(dx), height: Math.abs(dy),
                });
                break;
            case 'polygon':
                var rad = Math.sqrt(dx * dx + dy * dy) / 2;
                var cx = (ox + px) / 2, cy = (oy + py) / 2;
                canvas.remove(activeShape);
                activeShape = createRegularPolygon(cx, cy, rad, polygonSides);
                activeShape.set({ selectable: false, evented: false });
                canvas.add(activeShape);
                break;
            case 'arc':
                canvas.remove(activeShape);
                activeShape = createArcShape(ox, oy, px, py);
                activeShape.set({ selectable: false, evented: false });
                canvas.add(activeShape);
                break;
        }
        canvas.requestRenderAll();
    }

    function onMouseUp(opt) {
        if (!isDrawingShape || !activeShape) return;
        isDrawingShape = false;
        suppressSave = false;

        var pointer = canvas.getPointer(opt.e);
        var px = snap(pointer.x), py = snap(pointer.y);

        // Replace temp lines with final arrow/curve groups
        if (activeTool === 'arrow' || activeTool === 'dblarrow') {
            canvas.remove(activeShape);
            activeShape = createArrow(shapeOrigin.x, shapeOrigin.y, px, py, activeTool === 'dblarrow');
            canvas.add(activeShape);
        } else if (activeTool === 'curvearrow') {
            canvas.remove(activeShape);
            activeShape = createCurvedArrow(shapeOrigin.x, shapeOrigin.y, px, py);
            canvas.add(activeShape);
        } else if (activeTool === 'curve') {
            canvas.remove(activeShape);
            activeShape = createCurveLine(shapeOrigin.x, shapeOrigin.y, px, py);
            canvas.add(activeShape);
        }

        activeShape.set({ selectable: true, evented: true });
        canvas.setActiveObject(activeShape);
        activeShape = null;
        saveState();  // Single save after shape is finalized
        canvas.requestRenderAll();
    }

    // ── Create initial shape for drag ────────────────────────
    function createInitialShape(tool, x, y) {
        var base = { stroke: strokeColor, strokeWidth: strokeWidth, selectable: false, evented: false };

        switch (tool) {
            case 'line':
                return new fabric.Line([x, y, x, y], base);
            case 'dashed':
                return new fabric.Line([x, y, x, y], Object.assign({}, base, { strokeDashArray: [10, 6] }));
            case 'arrow': case 'dblarrow': case 'curvearrow': case 'curve':
                return new fabric.Line([x, y, x, y], base);
            case 'rect': case 'square':
                return new fabric.Rect(Object.assign({}, base, { left: x, top: y, width: 0, height: 0, fill: fillColor }));
            case 'circle':
                return new fabric.Circle(Object.assign({}, base, { left: x, top: y, radius: 0, fill: fillColor }));
            case 'ellipse':
                return new fabric.Ellipse(Object.assign({}, base, { left: x, top: y, rx: 0, ry: 0, fill: fillColor }));
            case 'triangle':
                return new fabric.Triangle(Object.assign({}, base, { left: x, top: y, width: 0, height: 0, fill: fillColor }));
            case 'polygon':
                return createRegularPolygon(x, y, 0, polygonSides);
            case 'arc':
                return createArcShape(x, y, x, y);
        }
        return null;
    }

    // ══════════════════════════════════════════════════════════
    //  SHAPE FACTORIES
    // ══════════════════════════════════════════════════════════

    function createArrow(x1, y1, x2, y2, dbl) {
        var angle = Math.atan2(y2 - y1, x2 - x1);
        var objects = [
            new fabric.Line([x1, y1, x2, y2], { stroke: strokeColor, strokeWidth: strokeWidth }),
            makeArrowHead(x2, y2, angle),
        ];
        if (dbl) objects.push(makeArrowHead(x1, y1, angle + Math.PI));
        return new fabric.Group(objects, { selectable: true, evented: true });
    }

    function makeArrowHead(x, y, angle) {
        var len = 14;
        return new fabric.Polygon([
            { x: x, y: y },
            { x: x - len * Math.cos(angle - Math.PI / 6), y: y - len * Math.sin(angle - Math.PI / 6) },
            { x: x - len * Math.cos(angle + Math.PI / 6), y: y - len * Math.sin(angle + Math.PI / 6) },
        ], { fill: strokeColor, stroke: strokeColor, strokeWidth: 1 });
    }

    function createCurveLine(x1, y1, x2, y2) {
        var mx = (x1 + x2) / 2;
        var my = Math.min(y1, y2) - Math.abs(y2 - y1) * 0.3 - 30;
        return new fabric.Path('M ' + x1 + ' ' + y1 + ' Q ' + mx + ' ' + my + ' ' + x2 + ' ' + y2, {
            stroke: strokeColor, strokeWidth: strokeWidth, fill: '',
        });
    }

    function createCurvedArrow(x1, y1, x2, y2) {
        var mx = (x1 + x2) / 2;
        var my = Math.min(y1, y2) - Math.abs(y2 - y1) * 0.3 - 30;
        var curve = new fabric.Path('M ' + x1 + ' ' + y1 + ' Q ' + mx + ' ' + my + ' ' + x2 + ' ' + y2, {
            stroke: strokeColor, strokeWidth: strokeWidth, fill: '',
        });
        var t = 0.95;
        var bx = (1 - t) * (1 - t) * x1 + 2 * (1 - t) * t * mx + t * t * x2;
        var by = (1 - t) * (1 - t) * y1 + 2 * (1 - t) * t * my + t * t * y2;
        var head = makeArrowHead(x2, y2, Math.atan2(y2 - by, x2 - bx));
        return new fabric.Group([curve, head], { selectable: true, evented: true });
    }

    function createRegularPolygon(cx, cy, radius, sides) {
        var points = [];
        for (var i = 0; i < sides; i++) {
            var a = (2 * Math.PI * i / sides) - Math.PI / 2;
            points.push({ x: cx + radius * Math.cos(a), y: cy + radius * Math.sin(a) });
        }
        return new fabric.Polygon(points, {
            fill: fillColor, stroke: strokeColor, strokeWidth: strokeWidth,
        });
    }

    function createArcShape(cx, cy, ex, ey) {
        var r = Math.max(5, Math.sqrt((ex - cx) * (ex - cx) + (ey - cy) * (ey - cy)));
        var endAngle = Math.atan2(ey - cy, ex - cx);
        if (endAngle < 0) endAngle += 2 * Math.PI;
        if (endAngle < 0.1) endAngle = Math.PI * 0.75;
        var pts = [];
        for (var i = 0; i <= 30; i++) {
            var a = endAngle * i / 30;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx + r * Math.cos(a)) + ' ' + (cy - r * Math.sin(a)));
        }
        return new fabric.Path(pts.join(''), {
            stroke: strokeColor, strokeWidth: strokeWidth, fill: '',
        });
    }

    // ── Connect mode ─────────────────────────────────────────
    function handleConnect(opt) {
        var target = opt.target;  // Fabric.js sets this on the event

        if (!connSourceObj) {
            if (target) {
                connSourceObj = target;
                target.set('shadow', new fabric.Shadow({ color: '#3b82f6', blur: 8 }));
                canvas.requestRenderAll();
                status('Now click the target object');
            } else {
                status('Click on an object first');
            }
        } else {
            if (target && target !== connSourceObj) {
                var src = connSourceObj.getCenterPoint();
                var dst = target.getCenterPoint();
                var arrow = createArrow(src.x, src.y, dst.x, dst.y, false);
                canvas.add(arrow);
                canvas.sendToBack(arrow);
            }
            // Clean up source highlight
            try { connSourceObj.set('shadow', null); } catch (_) {}
            connSourceObj = null;
            canvas.requestRenderAll();
            status('Click first object, then click second to connect');
        }
    }

    // ── Freeform polygon ─────────────────────────────────────
    function cancelFreeform() {
        freeformPoints = [];
        if (freeformPreviewLine && canvas) {
            canvas.remove(freeformPreviewLine);
            freeformPreviewLine = null;
        }
        canvas && canvas.requestRenderAll();
    }

    function updateFreeformPreview(px, py) {
        if (freeformPoints.length === 0) return;
        var last = freeformPoints[freeformPoints.length - 1];
        if (freeformPreviewLine) canvas.remove(freeformPreviewLine);
        freeformPreviewLine = new fabric.Line([last.x, last.y, px, py], {
            stroke: strokeColor, strokeWidth: strokeWidth,
            strokeDashArray: [6, 4], selectable: false, evented: false
        });
        canvas.add(freeformPreviewLine);
        canvas.sendToBack(freeformPreviewLine);
        canvas.requestRenderAll();
    }

    function handleFreeformClick(px, py) {
        var CLOSE_THRESHOLD = 15;
        var now = Date.now();
        var isDoubleClick = (now - freeformLastClick < 400) && freeformLastPoint &&
            Math.abs(px - freeformLastPoint.x) < 10 && Math.abs(py - freeformLastPoint.y) < 10;
        freeformLastClick = now;
        freeformLastPoint = { x: px, y: py };

        var isPolyline = activeTool === 'polyline';
        var minPts = isPolyline ? 2 : 3;

        if (isDoubleClick && freeformPoints.length >= minPts) {
            finishFreeform();
            return;
        }
        if (!isPolyline && freeformPoints.length >= 3) {
            var first = freeformPoints[0];
            var dist = Math.sqrt((px - first.x) * (px - first.x) + (py - first.y) * (py - first.y));
            if (dist < CLOSE_THRESHOLD) {
                finishFreeform();
                return;
            }
        }
        freeformPoints.push({ x: px, y: py });
        if (freeformPoints.length === 1) {
            status(isPolyline ? 'Click to add more points. Double-click or Enter to finish.' : 'Click to add more vertices. Double-click or click first point to close.');
        }
    }

    function finishFreeform() {
        var isPolyline = activeTool === 'polyline';
        var minPts = isPolyline ? 2 : 3;
        if (freeformPoints.length < minPts) {
            cancelFreeform();
            setTool('select');
            return;
        }
        if (freeformPreviewLine) {
            canvas.remove(freeformPreviewLine);
            freeformPreviewLine = null;
        }
        var pts = freeformPoints.map(function (p) { return { x: p.x, y: p.y }; });
        var shape = isPolyline
            ? new fabric.Polyline(pts, { stroke: strokeColor, strokeWidth: strokeWidth, fill: '', selectable: true, evented: true })
            : new fabric.Polygon(pts, { fill: fillColor, stroke: strokeColor, strokeWidth: strokeWidth, selectable: true, evented: true });
        canvas.add(shape);
        canvas.setActiveObject(shape);
        freeformPoints = [];
        saveState();
        updateDoneButton();
        setTool('select');
        status('Select objects to move or edit.');
        canvas.requestRenderAll();
    }

    // ══════════════════════════════════════════════════════════
    //  MATH OBJECT ONE-CLICK INSERTS
    // ══════════════════════════════════════════════════════════
    function insertMathObject(type) {
        var cx = canvas.getWidth() / 2, cy = canvas.getHeight() / 2;
        var fn = {
            axes: insertAxes, numberline: insertNumberLine,
            angle: insertAngle, rightangle: insertRightAngle,
            brace: insertBrace, congruence: insertCongruence,
            unitcircle: insertUnitCircle, tangent: insertTangent,
            hyperbola: insertHyperbola, exponential: insertExponential,
            wave: insertWave, parabola: insertParabola, cubic: insertCubic,
            spring: insertSpring, parallel: insertParallelLines,
            ruler: insertRuler,
        }[type];
        if (fn) fn(cx, cy);
    }

    // ── Math Text Box ────────────────────────────────────────
    function insertMathTextBox(x, y) {
        var border = new fabric.Rect({
            width: 140, height: 40,
            fill: 'rgba(219,234,254,0.3)',
            stroke: '#93c5fd', strokeWidth: 1.5, rx: 6, ry: 6,
        });
        var label = new fabric.IText('x^2 + y^2 = r^2', {
            fontFamily: 'KaTeX_Math, Times New Roman, serif',
            fontSize: 16, fontStyle: 'italic', fill: strokeColor,
            originX: 'center', originY: 'center', editable: true,
        });
        var group = new fabric.Group([border, label], {
            left: x, top: y, selectable: true, subTargetCheck: true,
        });
        group._mathBox = true;
        canvas.add(group);
        canvas.setActiveObject(group);

        group.on('mousedblclick', function () { openMathInput(group, label); });
        canvas.requestRenderAll();
    }

    function openMathInput(group, label) {
        // Remove any existing floating input
        var existing = document.querySelector('.me-draw-math-input');
        if (existing) existing.remove();

        var wrap = document.createElement('div');
        wrap.className = 'me-draw-math-input';

        // Position near the group on screen
        var canvasEl = canvas.getElement();
        var rect = canvasEl.getBoundingClientRect();
        var cpt = group.getCenterPoint();
        wrap.style.left = Math.max(10, rect.left + cpt.x - 120) + 'px';
        wrap.style.top = Math.max(10, rect.top + cpt.y - 60) + 'px';

        wrap.innerHTML = '<math-field class="me-draw-mf" style="min-width:200px;font-size:18px;">' +
            (label.text || '') + '</math-field>' +
            '<button class="me-draw-math-ok">OK</button>';
        document.body.appendChild(wrap);

        var mf = wrap.querySelector('math-field');
        setTimeout(function () { try { mf.focus(); } catch (_) {} }, 100);

        function finish() {
            var latex = '';
            try { latex = mf.getValue ? mf.getValue() : mf.value; } catch (_) { latex = mf.value || ''; }
            label.set('text', latex || 'formula');
            var tw = Math.max(label.width + 30, 60);
            var th = Math.max(label.height + 16, 30);
            group.item(0).set({ width: tw, height: th });
            group.addWithUpdate();
            canvas.requestRenderAll();
            wrap.remove();
        }

        wrap.querySelector('.me-draw-math-ok').addEventListener('click', finish);
        mf.addEventListener('keydown', function (e) {
            e.stopPropagation();
            if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); finish(); }
            if (e.key === 'Escape') { wrap.remove(); }
        });
    }

    // ── Cartesian Axes ───────────────────────────────────────
    function insertAxes(cx, cy) {
        var size = 180, unit = size / 4, objects = [];
        // Grid lines
        for (var i = -4; i <= 4; i++) {
            if (i === 0) continue;
            objects.push(new fabric.Line([cx + i * unit, cy - size, cx + i * unit, cy + size], { stroke: '#e2e8f0', strokeWidth: 0.5 }));
            objects.push(new fabric.Line([cx - size, cy + i * unit, cx + size, cy + i * unit], { stroke: '#e2e8f0', strokeWidth: 0.5 }));
        }
        objects.push(new fabric.Line([cx - size - 10, cy, cx + size + 10, cy], { stroke: '#1e293b', strokeWidth: 2 }));
        objects.push(new fabric.Line([cx, cy - size - 10, cx, cy + size + 10], { stroke: '#1e293b', strokeWidth: 2 }));
        objects.push(makeArrowHead(cx + size + 10, cy, 0));
        objects.push(makeArrowHead(cx, cy - size - 10, -Math.PI / 2));
        objects.push(new fabric.Text('x', { left: cx + size + 16, top: cy - 12, fontSize: 15, fontFamily: 'serif', fontStyle: 'italic', fill: '#1e293b' }));
        objects.push(new fabric.Text('y', { left: cx + 8, top: cy - size - 22, fontSize: 15, fontFamily: 'serif', fontStyle: 'italic', fill: '#1e293b' }));
        objects.push(new fabric.Text('O', { left: cx - 16, top: cy + 4, fontSize: 12, fontFamily: 'serif', fontStyle: 'italic', fill: '#94a3b8' }));
        for (var j = -3; j <= 3; j++) {
            if (j === 0) continue;
            var tx = cx + j * unit;
            objects.push(new fabric.Line([tx, cy - 4, tx, cy + 4], { stroke: '#1e293b', strokeWidth: 1 }));
            objects.push(new fabric.Text(String(j), { left: tx - 4, top: cy + 8, fontSize: 10, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
            var ty = cy + j * unit;
            objects.push(new fabric.Line([cx - 4, ty, cx + 4, ty], { stroke: '#1e293b', strokeWidth: 1 }));
            objects.push(new fabric.Text(String(-j), { left: cx + 8, top: ty - 6, fontSize: 10, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
        }
        addGroup(objects);
    }

    function insertNumberLine(cx, cy) {
        var len = 360, start = cx - len / 2, objects = [];
        objects.push(new fabric.Line([start, cy, start + len, cy], { stroke: strokeColor, strokeWidth: 2 }));
        objects.push(makeArrowHead(start + len, cy, 0));
        objects.push(makeArrowHead(start, cy, Math.PI));
        var spacing = (len - 40) / 8;
        for (var i = 0; i < 9; i++) {
            var x = start + 20 + i * spacing, val = -4 + i;
            objects.push(new fabric.Line([x, cy - (val === 0 ? 10 : 6), x, cy + (val === 0 ? 10 : 6)], {
                stroke: strokeColor, strokeWidth: val === 0 ? 2 : 1 }));
            objects.push(new fabric.Text(String(val), { left: x - 4, top: cy + 14, fontSize: 11, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
        }
        addGroup(objects);
    }

    function insertAngle(cx, cy) {
        var r = 70, deg = 45, rad = deg * Math.PI / 180, objects = [];
        objects.push(new fabric.Line([cx, cy, cx + r * 1.8, cy], { stroke: strokeColor, strokeWidth: strokeWidth }));
        objects.push(new fabric.Line([cx, cy, cx + r * 1.8 * Math.cos(rad), cy - r * 1.8 * Math.sin(rad)], { stroke: strokeColor, strokeWidth: strokeWidth }));
        var arcR = r * 0.55, pts = [];
        for (var i = 0; i <= 24; i++) {
            var a = (deg * i / 24) * Math.PI / 180;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx + arcR * Math.cos(a)) + ' ' + (cy - arcR * Math.sin(a)));
        }
        objects.push(new fabric.Path(pts.join(''), { stroke: '#3b82f6', strokeWidth: 1.5, fill: '' }));
        var mid = rad / 2;
        objects.push(new fabric.Text(deg + '\u00B0', {
            left: cx + (arcR + 16) * Math.cos(mid) - 8, top: cy - (arcR + 16) * Math.sin(mid) - 8,
            fontSize: 14, fontFamily: 'Inter, sans-serif', fill: '#3b82f6',
        }));
        addGroup(objects);
    }

    function insertRightAngle(cx, cy) {
        var s = 25, objects = [];
        objects.push(new fabric.Line([cx, cy, cx + 100, cy], { stroke: strokeColor, strokeWidth: strokeWidth }));
        objects.push(new fabric.Line([cx, cy, cx, cy - 100], { stroke: strokeColor, strokeWidth: strokeWidth }));
        objects.push(new fabric.Polyline([{ x: cx + s, y: cy }, { x: cx + s, y: cy - s }, { x: cx, y: cy - s }], {
            stroke: '#3b82f6', strokeWidth: 1.5, fill: '' }));
        addGroup(objects);
    }

    function insertBrace(cx, cy) {
        var w = 200, h = 25;
        var d = 'M ' + (cx - w / 2) + ' ' + cy
            + ' Q ' + (cx - w / 4) + ' ' + cy + ' ' + (cx - w / 4) + ' ' + (cy - h)
            + ' Q ' + (cx - w / 4) + ' ' + (cy - h * 2) + ' ' + cx + ' ' + (cy - h * 2)
            + ' Q ' + (cx + w / 4) + ' ' + (cy - h * 2) + ' ' + (cx + w / 4) + ' ' + (cy - h)
            + ' Q ' + (cx + w / 4) + ' ' + cy + ' ' + (cx + w / 2) + ' ' + cy;
        canvas.add(new fabric.Path(d, { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        canvas.requestRenderAll();
    }

    function insertCongruence(cx, cy) {
        var len = 120, tickLen = 10, objects = [];
        objects.push(new fabric.Line([cx - len / 2, cy, cx + len / 2, cy], { stroke: strokeColor, strokeWidth: strokeWidth }));
        for (var i = -1; i <= 1; i += 2) {
            var tx = cx + i * len / 4;
            objects.push(new fabric.Line([tx, cy, tx - tickLen * 0.7, cy - tickLen], { stroke: strokeColor, strokeWidth: strokeWidth }));
            objects.push(new fabric.Line([tx, cy, tx + tickLen * 0.7, cy - tickLen], { stroke: strokeColor, strokeWidth: strokeWidth }));
        }
        addGroup(objects);
    }

    function insertUnitCircle(cx, cy) {
        var r = 90, objects = [];
        objects.push(new fabric.Circle({ left: cx - r, top: cy - r, radius: r, stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Line([cx - r - 8, cy, cx + r + 8, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx, cy - r - 8, cx, cy + r + 8], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        var angles = [
            { deg: 0, x: 1, y: 0 },
            { deg: 30, x: 0.866, y: -0.5 },
            { deg: 45, x: 0.707, y: -0.707 },
            { deg: 60, x: 0.5, y: -0.866 },
            { deg: 90, x: 0, y: -1 },
            { deg: 120, x: -0.5, y: -0.866 },
            { deg: 135, x: -0.707, y: -0.707 },
            { deg: 150, x: -0.866, y: -0.5 },
            { deg: 180, x: -1, y: 0 },
            { deg: 210, x: -0.866, y: 0.5 },
            { deg: 225, x: -0.707, y: 0.707 },
            { deg: 270, x: 0, y: 1 },
            { deg: 315, x: 0.707, y: 0.707 },
        ];
        angles.forEach(function (a) {
            var lx = cx + (r + 14) * a.x, ly = cy - (r + 14) * a.y;
            objects.push(new fabric.Line([cx + r * 0.92 * a.x, cy - r * 0.92 * a.y, cx + r * 1.08 * a.x, cy - r * 1.08 * a.y], { stroke: strokeColor, strokeWidth: 1.2 }));
            objects.push(new fabric.Text(a.deg + '\u00B0', { left: lx - 5, top: ly - 5, fontSize: 9, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
        });
        objects.push(new fabric.Text('(1,0)', { left: cx + r + 4, top: cy - 5, fontSize: 9, fontFamily: 'Inter, sans-serif', fill: '#3b82f6' }));
        objects.push(new fabric.Text('(0,1)', { left: cx - 22, top: cy - r - 12, fontSize: 9, fontFamily: 'Inter, sans-serif', fill: '#3b82f6' }));
        addGroup(objects);
    }

    function insertTangent(cx, cy) {
        var w = 200, objects = [], pts = [];
        for (var i = 0; i <= 60; i++) {
            var t = (i / 60) * 2 - 0.5;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx + t * w) + ' ' + (cy - (1 - t * t) * 80));
        }
        objects.push(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Line([cx - w / 2 - 10, cy, cx + w / 2 + 10, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx - 60, cy - 80, cx + 60, cy - 80], { stroke: '#22c55e', strokeWidth: 2 }));
        objects.push(new fabric.Text('tangent', { left: cx + 65, top: cy - 88, fontSize: 11, fontFamily: 'Inter, sans-serif', fill: '#22c55e' }));
        objects.push(new fabric.Text(' parabola', { left: cx - 35, top: cy - 100, fontSize: 10, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
        addGroup(objects);
    }

    function insertHyperbola(cx, cy) {
        var scale = 60, objects = [], pts1 = [], pts2 = [];
        for (var i = 0; i <= 50; i++) {
            var t = 0.3 + (i / 50) * 2.5;
            var x = scale * t;
            var y = scale * Math.sqrt(t * t - 1);
            if (y === y) {
                pts1.push((i === 0 ? 'M ' : ' L ') + (cx + x) + ' ' + (cy - y));
                pts2.push((i === 0 ? 'M ' : ' L ') + (cx + x) + ' ' + (cy + y));
            }
        }
        for (var j = 50; j >= 0; j--) {
            var t = 0.3 + (j / 50) * 2.5;
            var x = -scale * t;
            var y = scale * Math.sqrt(t * t - 1);
            if (y === y) {
                pts1.push(' L ' + (cx + x) + ' ' + (cy - y));
                pts2.push(' L ' + (cx + x) + ' ' + (cy + y));
            }
        }
        objects.push(new fabric.Path(pts1.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Path(pts2.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Line([cx - scale * 2.5 - 10, cy, cx + scale * 2.5 + 10, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx, cy - scale * 2.5 - 10, cx, cy + scale * 2.5 + 10], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        addGroup(objects);
    }

    function insertExponential(cx, cy) {
        var scaleX = 45, scaleY = 35, objects = [], pts = [];
        for (var i = 0; i <= 70; i++) {
            var t = (i / 70) * 2.5 - 0.3;
            var x = cx + t * scaleX;
            var y = cy - Math.exp(t) * scaleY;
            pts.push((pts.length === 0 ? 'M ' : ' L ') + x + ' ' + y);
        }
        objects.push(new fabric.Line([cx - scaleX - 15, cy, cx + scaleX * 2.5 + 15, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx, cy + 40, cx, cy - 200], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Text('e^x', { left: cx + scaleX * 2.2 - 12, top: cy - Math.exp(2.2) * scaleY - 8, fontSize: 12, fontFamily: 'serif', fontStyle: 'italic', fill: strokeColor }));
        objects.push(new fabric.Text('(0,1)', { left: cx - 32, top: cy - scaleY + 4, fontSize: 10, fontFamily: 'Inter, sans-serif', fill: '#3b82f6' }));
        addGroup(objects);
    }

    function insertWave(cx, cy) {
        var w = 300, objects = [], pts = [];
        for (var i = 0; i <= 100; i++) {
            var t = i / 100, x = cx - w / 2 + t * w, y = cy - 50 * Math.sin(2 * Math.PI * 2 * t);
            pts.push((i === 0 ? 'M ' : ' L ') + x + ' ' + y);
        }
        objects.push(new fabric.Line([cx - w / 2 - 20, cy, cx + w / 2 + 20, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        addGroup(objects);
    }

    function insertParabola(cx, cy) {
        var w = 250, objects = [], pts = [];
        for (var i = 0; i <= 80; i++) {
            var t = (i / 80) * 2 - 1;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx + t * w / 2) + ' ' + (cy - (1 - t * t) * 100));
        }
        objects.push(new fabric.Line([cx, cy + 20, cx, cy - 120], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx - w / 2 - 10, cy, cx + w / 2 + 10, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        objects.push(new fabric.Text('vertex', { left: cx + 6, top: cy - 112, fontSize: 10, fontFamily: 'Inter, sans-serif', fill: '#64748b' }));
        addGroup(objects);
    }

    function insertCubic(cx, cy) {
        var w = 280, objects = [], pts = [];
        for (var i = 0; i <= 80; i++) {
            var t = (i / 80) * 2 - 1;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx + t * w / 2) + ' ' + (cy - t * t * t * 80));
        }
        objects.push(new fabric.Line([cx - w / 2 - 10, cy, cx + w / 2 + 10, cy], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Line([cx, cy + 100, cx, cy - 100], { stroke: '#94a3b8', strokeWidth: 1, strokeDashArray: [4, 4] }));
        objects.push(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        addGroup(objects);
    }

    function insertSpring(cx, cy) {
        var w = 250, pts = [];
        for (var i = 0; i <= 200; i++) {
            var t = i / 200;
            pts.push((i === 0 ? 'M ' : ' L ') + (cx - w / 2 + t * w) + ' ' + (cy + 15 * Math.sin(2 * Math.PI * 8 * t)));
        }
        canvas.add(new fabric.Path(pts.join(''), { stroke: strokeColor, strokeWidth: strokeWidth, fill: '' }));
        canvas.requestRenderAll();
    }

    function insertParallelLines(cx, cy) {
        var len = 200, gap = 60, objects = [];
        objects.push(new fabric.Line([cx - len / 2, cy - gap / 2, cx + len / 2, cy - gap / 2], { stroke: strokeColor, strokeWidth: strokeWidth }));
        objects.push(new fabric.Line([cx - len / 2, cy + gap / 2, cx + len / 2, cy + gap / 2], { stroke: strokeColor, strokeWidth: strokeWidth }));
        [-1, 1].forEach(function (dir) {
            var ay = cy + dir * gap / 2;
            objects.push(new fabric.Path('M ' + (cx - 5) + ' ' + (ay - 8) + ' L ' + cx + ' ' + ay + ' L ' + (cx + 5) + ' ' + (ay - 8), {
                stroke: '#3b82f6', strokeWidth: 1.5, fill: '' }));
        });
        addGroup(objects);
    }

    function insertRuler(cx, cy) {
        var len = 300, unit = 30, objects = [];
        objects.push(new fabric.Rect({ left: cx - len / 2, top: cy - 12, width: len, height: 24, fill: 'rgba(250,204,21,0.15)', stroke: '#eab308', strokeWidth: 1, rx: 2, ry: 2 }));
        for (var i = 0; i <= len / unit; i++) {
            var x = cx - len / 2 + i * unit, big = i % 2 === 0;
            objects.push(new fabric.Line([x, cy - (big ? 10 : 5), x, cy + (big ? 10 : 5)], { stroke: '#92400e', strokeWidth: big ? 1.5 : 0.8 }));
            if (big) objects.push(new fabric.Text(String(i / 2), { left: x - 3, top: cy + 13, fontSize: 9, fontFamily: 'Inter, sans-serif', fill: '#92400e' }));
        }
        addGroup(objects);
    }

    function addGroup(objects) {
        var group = new fabric.Group(objects, { selectable: true, evented: true });
        canvas.add(group);
        canvas.setActiveObject(group);
        canvas.requestRenderAll();
    }

    // ══════════════════════════════════════════════════════════
    //  UNDO / REDO
    // ══════════════════════════════════════════════════════════
    function saveState() {
        if (isRestoring || suppressSave) return;
        undoStack.push(JSON.stringify(canvas.toJSON()));
        redoStack.length = 0;
        if (undoStack.length > 50) undoStack.shift();
    }

    function undo() {
        if (undoStack.length <= 1) return;
        redoStack.push(undoStack.pop());
        isRestoring = true;
        canvas.loadFromJSON(undoStack[undoStack.length - 1], function () {
            canvas.renderAll();
            isRestoring = false;
        });
    }

    function redo() {
        if (redoStack.length === 0) return;
        var next = redoStack.pop();
        undoStack.push(next);
        isRestoring = true;
        canvas.loadFromJSON(next, function () {
            canvas.renderAll();
            isRestoring = false;
        });
    }

    // ── Delete / Clear ───────────────────────────────────────
    function deleteSelected() {
        if (!canvas) return;
        var active = canvas.getActiveObject();
        if (!active) return;
        if (active.type === 'activeselection' || active.type === 'activeSelection') {
            active.forEachObject(function (obj) { canvas.remove(obj); });
            canvas.discardActiveObject();
        } else {
            canvas.remove(active);
        }
        canvas.requestRenderAll();
    }

    function clearCanvas() {
        if (!canvas) return;
        if (canvas.getObjects().length === 0) return;
        if (!confirm('Clear all objects? You can still undo (Ctrl+Z) if you insert by mistake.')) return;
        canvas.clear();
        canvas.backgroundColor = '#ffffff';
        canvas.requestRenderAll();
        updateDoneButton();
    }

    // ══════════════════════════════════════════════════════════
    //  DONE / CANCEL
    // ══════════════════════════════════════════════════════════
    function onDone() {
        if (!canvas) return;
        if (canvas.getObjects().length === 0) return; // Guard: button should be disabled

        // Temporarily hide grid for clean export
        var wasGridVisible = gridVisible;
        gridVisible = false;
        canvas.requestRenderAll();

        // Use setTimeout to let the re-render complete before export
        setTimeout(function () {
            var imageData = canvas.toDataURL({ format: 'png', multiplier: 2 });
            var jsonData = JSON.stringify(canvas.toJSON());

            gridVisible = wasGridVisible;
            closeModal();
            if (onSaveCallback) onSaveCallback(imageData, jsonData);
        }, 50);
    }

    function onCancel() {
        closeModal();
        onSaveCallback = null;
    }

    function closeModal() {
        var mi = document.querySelector('.me-draw-math-input');
        if (mi) mi.remove();

        if (resizeObserver) {
            try { resizeObserver.disconnect(); } catch (_) {}
            resizeObserver = null;
        }
        if (canvas) {
            canvas.dispose();
            canvas = null;
        }
        if (modal) modal.style.display = 'none';
        connSourceObj = null;
    }

    // ══════════════════════════════════════════════════════════
    //  PUBLIC API
    //  open(callback, existingJson, existingImageData)
    //  When editing: pass canvasJson + imageData. If canvasJson missing but imageData exists,
    //  loads image as background so user can add elements on top.
    // ══════════════════════════════════════════════════════════
    function open(callback, existingJson, existingImageData) {
        ensureModal();
        onSaveCallback = callback;
        modal.style.display = 'flex';
        modal.focus();

        requestAnimationFrame(function () {
            initCanvas();
            setupResizeObserver();
            if (existingJson) {
                try {
                    isRestoring = true;
                    canvas.loadFromJSON(existingJson, function () {
                        canvas.renderAll();
                        isRestoring = false;
                        undoStack = [];
                        redoStack = [];
                        saveState();
                        updateDoneButton();
                    });
                } catch (e) {
                    isRestoring = false;
                }
            } else if (existingImageData) {
                // Vector data lost (e.g. exported to PNG). Load image as background.
                fabric.Image.fromURL(existingImageData, function (img) {
                    if (!img || !canvas) return;
                    var scale = Math.min(canvas.getWidth() / img.width, canvas.getHeight() / img.height, 1);
                    img.set({
                        scaleX: scale, scaleY: scale,
                        left: (canvas.getWidth() - img.width * scale) / 2,
                        top: (canvas.getHeight() - img.height * scale) / 2,
                        selectable: false, evented: false,
                        excludeFromExport: false
                    });
                    canvas.add(img);
                    canvas.sendToBack(img);
                    saveState();
                    updateDoneButton();
                    status('Original image loaded. Add shapes or text on top.');
                }, { crossOrigin: 'anonymous' });
            }
        });
    }

    function setupResizeObserver() {
        if (resizeObserver) {
            try { resizeObserver.disconnect(); } catch (_) {}
            resizeObserver = null;
        }
        var wrap = modal && modal.querySelector('.me-draw-canvas-wrap');
        if (!wrap || !canvas) return;
        resizeObserver = new ResizeObserver(function () {
            var w = wrap.clientWidth - 4;
            var h = wrap.clientHeight - 4;
            if (w > 0 && h > 0) {
                canvas.setDimensions({ width: w, height: h });
                canvas.requestRenderAll();
            }
        });
        resizeObserver.observe(wrap);
    }

    window.MeDrawing = { open: open };
})();
