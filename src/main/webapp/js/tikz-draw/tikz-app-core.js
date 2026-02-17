// TikZ Draw - App Core

class TikZDrawApp {
    constructor() {
        this.canvas = document.getElementById('canvas');
        this.ctx = this.canvas.getContext('2d');
        this.container = document.getElementById('canvasContainer');

        // Key state
        this.ctrlKey = false;
        this.shiftKey = false;
        this.inNudge = false;

        // View state
        this.viewX = 0;
        this.viewY = 0;
        this.zoom = 50; // pixels per unit
        this.snapGrid = 0.25;

        // Tool state
        this.currentTool = 'select';
        this.toolState = null;
        this.tempPoints = [];

        // Object storage
        this.objects = [];
        this.selectedObjects = []; // Changed from selectedObject to support multi-select
        this.selectedSubIndex = -1;
        this.customColors = {};

        // Undo/Redo state
        this.undoStack = [];
        this.redoStack = [];
        this.maxHistory = 50;

        // Image data cache - stores base64 data separately to avoid duplication in undo stack
        // Key: imageId, Value: { imageData, filename, mimeType }
        this.imageDataCache = new Map();

        // LaTeX rendering cache
        this.latexCache = new Map(); // text -> {svg, width, height}
        this.latexRenderQueue = [];
        this.isRenderingLatex = false;

        // Render state
        this.isRendering = false;

        // Interaction state
        this.isDragging = false;
        this.dragStart = null;
        this.dragObject = null;
        this.isPanning = false;
        this.panStart = null;

        // Multi-select drag-to-select state
        this.isBoxSelecting = false;
        this.boxSelectStart = null;
        this.boxSelectEnd = null;

        // Select-move state (moving objects in select mode)
        this.selectMoveStart = null;
        this.selectMoveObject = null;

        // Move tool state
        this.isMoving = false;
        this.moveObject = null;
        this.moveStart = null;
        this.moveCoords = []; // Coordinates being moved

        // Rotate tool state
        this.isRotating = false;
        this.rotateCenter = null; // { x, y } - center point of rotation
        this.rotateStartAngle = null; // Starting angle from center to mouse
        this.rotateCurrentAngle = null; // Current angle from center to mouse
        this.rotateCoords = []; // Coordinates being rotated
        this.rotateOriginalPositions = []; // Original positions of coordinates
        this.rotateImages = []; // Images being rotated with original rotations
        this.rotateLabels = []; // Labels being rotated with original rotations
        this.rotateEmbeddedNodes = []; // Embedded nodes being rotated with original rotations
        this.rotateRectangles = []; // Rectangles being rotated with original deltas
        this.rotateGrids = []; // Grids being rotated with original deltas

        // Clipboard for copy/paste
        this.clipboard = null;

        // Unsaved changes tracking
        this.hasUnsavedChanges = false;

        // Throttling for expensive DOM updates during continuous operations (e.g., dragging)
        this._pendingPropertiesUpdate = false;
        this._pendingObjectListUpdate = false;
        this._throttleDelay = 50; // ms between DOM updates during drag

        // Initialize
        this.setupEventListeners();
        this.resize();
        this.render();
        this.updateUndoRedoButtons();

        // Wait for MathJax to be ready
        this.initMathJax();
    }

    // Throttled version of updatePropertiesPanel for use during continuous operations
    updatePropertiesPanelThrottled() {
        if (this._pendingPropertiesUpdate) return;
        this._pendingPropertiesUpdate = true;
        setTimeout(() => {
            this._pendingPropertiesUpdate = false;
            this.updatePropertiesPanel();
        }, this._throttleDelay);
    }

    // Throttled version of updateObjectList for use during continuous operations
    updateObjectListThrottled() {
        if (this._pendingObjectListUpdate) return;
        this._pendingObjectListUpdate = true;
        setTimeout(() => {
            this._pendingObjectListUpdate = false;
            this.updateObjectList();
        }, this._throttleDelay);
    }

    initMathJax() {
        // Check if MathJax is already loaded and ready
        if (window.MathJax && MathJax.startup && MathJax.startup.promise) {
            MathJax.startup.promise.then(() => {
                this.mathJaxReady = true;
                this.render();
            });
        } else {
            // MathJax config will set mathJaxReady when it loads
            setTimeout(() => {
                if (!this.mathJaxReady) {
                    this.initMathJax();
                }
            }, 200);
        }
    }

    // Render LaTeX text to an image for canvas drawing
    parseContour(text) {
        // Parse \contour{color}{text} and return {text, contourColor} or null
        // Handle both: \contour{color}{$math$} and $\contour{color}{math}$
        const contourMatch = text.match(/\\contour\{([^}]+)\}\{([^}]+)\}/);
        if (contourMatch) {
            let innerText = contourMatch[2];

            // Check if original text has outer $ delimiters but inner text doesn't
            const hasOuterMath = text.startsWith('$') && text.endsWith('$');
            const hasInnerMath = innerText.startsWith('$') && innerText.endsWith('$');

            // If math mode is on the outside, move it to the inside
            if (hasOuterMath && !hasInnerMath) {
                innerText = '$' + innerText + '$';
            }

            return {
                hasContour: true,
                contourColor: contourMatch[1],
                innerText: innerText,
                fullText: text
            };
        }
        return { hasContour: false, innerText: text, fullText: text };
    }

    getFontSizePixels(tikzFontSize) {
        const fontSizeMap = {
            'tiny': '10px',
            'scriptsize': '11px',
            'footnotesize': '12px',
            'small': '13px',
            'normalsize': '16px',
            'normal': '16px',
            'large': '18px',
            'Large': '20px',
            'LARGE': '22px',
            'huge': '24px',
            'Huge': '26px'
        };
        return fontSizeMap[tikzFontSize] || '16px';
    }

    async renderLatexToImage(text, color = 'black', fontSize = 'normal') {
        const cacheKey = `${text}::${color}::${fontSize}`;

        if (this.latexCache.has(cacheKey)) {
            return this.latexCache.get(cacheKey);
        }

        if (!this.mathJaxReady || !window.MathJax) {
            return null;
        }

        try {
            // Parse contour if present
            const contourInfo = this.parseContour(text);

            // For rendering, use the inner text (strip \contour{}{} wrapper)
            let renderText = contourInfo.innerText;

            // Replace custom colors
            for (const [name, hex] of Object.entries(this.customColors)) {
                renderText = renderText.replaceAll(`\{${name}\}`, `\{${hex}\}`);
            }

            // Create a temporary container
            const container = document.createElement('div');
            container.style.position = 'absolute';
            container.style.left = '-9999px';
            container.style.top = '0px';
            container.style.color = color;
            container.style.fontSize = this.getFontSizePixels(fontSize);
            container.style.fontFamily = 'serif';
            container.style.background = 'transparent';
            container.innerHTML = renderText;
            document.body.appendChild(container);

            await MathJax.typesetPromise([container]);

            const svg = container.querySelector('svg');

            if (svg) {
                const bbox = svg.getBoundingClientRect();
                const width = Math.max(Math.ceil(bbox.width), 10);
                const height = Math.max(Math.ceil(bbox.height), 10);

                // Clone SVG and inline all necessary defs
                const svgClone = svg.cloneNode(true);

                // Find and copy the MathJax global defs (glyph cache)
                const globalDefs = document.querySelector('#MJX-SVG-global-cache');
                if (globalDefs) {
                    let defs = svgClone.querySelector('defs');
                    if (!defs) {
                        defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
                        svgClone.insertBefore(defs, svgClone.firstChild);
                    }

                    const cachedDefs = globalDefs.querySelector('defs');
                    if (cachedDefs) {
                        cachedDefs.childNodes.forEach(node => {
                            defs.appendChild(node.cloneNode(true));
                        });
                    }
                }

                // Also copy defs from the SVG itself
                const svgDefs = svg.querySelector('defs');
                if (svgDefs) {
                    let defs = svgClone.querySelector('defs');
                    if (!defs) {
                        defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
                        svgClone.insertBefore(defs, svgClone.firstChild);
                    }
                    svgDefs.childNodes.forEach(node => {
                        if (!defs.querySelector('#' + node.id)) {
                            defs.appendChild(node.cloneNode(true));
                        }
                    });
                }

                // Set dimensions and namespaces
                svgClone.setAttribute('width', width + 'px');
                svgClone.setAttribute('height', height + 'px');
                svgClone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
                svgClone.setAttribute('xmlns:xlink', 'http://www.w3.org/1999/xlink');

                const viewBox = svg.getAttribute('viewBox');
                if (viewBox) {
                    svgClone.setAttribute('viewBox', viewBox);
                }

                // Apply color
                svgClone.style.color = color;
                svgClone.querySelectorAll('*').forEach(el => {
                    const fill = el.getAttribute('fill');
                    if (fill === 'currentColor') {
                        el.setAttribute('fill', color);
                    }
                });

                // Serialize and create data URL
                const svgString = new XMLSerializer().serializeToString(svgClone);
                const base64 = btoa(unescape(encodeURIComponent(svgString)));
                const dataUrl = 'data:image/svg+xml;base64,' + base64;

                // Load into image
                const svgImg = new Image();
                await new Promise((resolve, reject) => {
                    svgImg.onload = resolve;
                    svgImg.onerror = reject;
                    svgImg.src = dataUrl;
                });

                // Render to canvas at 2x scale for quality
                const scale = 2;
                const offscreen = document.createElement('canvas');
                offscreen.width = width * scale;
                offscreen.height = height * scale;
                const offCtx = offscreen.getContext('2d');
                // Explicitly clear with transparency
                offCtx.clearRect(0, 0, offscreen.width, offscreen.height);
                offCtx.scale(scale, scale);
                offCtx.drawImage(svgImg, 0, 0, width, height);

                // Create final PNG image
                const finalImg = new Image();
                await new Promise((resolve, reject) => {
                    finalImg.onload = resolve;
                    finalImg.onerror = reject;
                    finalImg.src = offscreen.toDataURL('image/png');
                });

                const result = {
                    img: finalImg,
                    width,
                    height,
                    hasContour: contourInfo.hasContour,
                    contourColor: contourInfo.hasContour ? contourInfo.contourColor : null
                };
                this.latexCache.set(cacheKey, result);

                document.body.removeChild(container);
                return result;
            } else {
                document.body.removeChild(container);
                return null;
            }
        } catch (err) {
            console.error('LaTeX render error:', err);
            return null;
        }
    }

    // Queue a LaTeX render and trigger re-render when done
    queueLatexRender(text, color = 'black', fontSize = 'normal') {
        const cacheKey = `${text}::${color}::${fontSize}`;
        if (this.latexCache.has(cacheKey)) return;

        if (!this.latexRenderQueue.some(q => q.key === cacheKey)) {
            this.latexRenderQueue.push({ text, color, fontSize, key: cacheKey });
            this.processLatexQueue();
        }
    }

    async processLatexQueue() {
        if (this.isRenderingLatex || this.latexRenderQueue.length === 0) return;

        this.isRenderingLatex = true;

        while (this.latexRenderQueue.length > 0) {
            const { text, color, fontSize } = this.latexRenderQueue.shift();
            await this.renderLatexToImage(text, color, fontSize);
        }

        this.isRenderingLatex = false;

        // Schedule a render on the next animation frame to avoid infinite loops
        // Only if we're not already in a render call
        if (!this.isRendering) {
            requestAnimationFrame(() => this.render());
        }
    }

    // ========================================================================
    // Setup
    // ========================================================================

    setupEventListeners() {
        // Window resize
        window.addEventListener('resize', () => this.resize());

        // Warn before leaving with unsaved changes
        window.addEventListener('beforeunload', (e) => {
            if (this.hasUnsavedChanges) {
                e.preventDefault();
                e.returnValue = '';
                return '';
            }
        });

        // Prevent page scroll when interacting with anything in the workspace.
        // Clicks on tools, buttons, canvas etc. must not scroll the page.
        const workspace = document.querySelector('.tikz-draw-workspace');
        workspace.addEventListener('mousedown', (e) => {
            // Only allow default for actual form inputs (so typing/selection works)
            const tag = e.target.tagName;
            if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;
            e.preventDefault();
        });

        // Tool buttons
        document.querySelectorAll('.tool').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.tool').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                this.currentTool = btn.dataset.tool;
                this.toolState = null;
                this.tempPoints = [];
                this.updateStatusTip();
                this.updateCursor();
                this.render();
            });
        });

        // Canvas events
        this.canvas.addEventListener('mousedown', e => this.onMouseDown(e));
        this.canvas.addEventListener('mousemove', e => this.onMouseMove(e));
        // Listen on document for mouseup so we catch it even if it happens on a modal
        document.addEventListener('mouseup', e => this.onMouseUp(e));
        // passive: false so preventDefault() stops page scroll
        this.canvas.addEventListener('wheel', e => this.onWheel(e), { passive: false });
        this.canvas.addEventListener('contextmenu', e => e.preventDefault());

        // Prevent page scroll when pointer is over the canvas
        this.container.addEventListener('wheel', e => e.preventDefault(), { passive: false });
        this.container.addEventListener('touchmove', e => e.preventDefault(), { passive: false });

        // Keyboard
        document.addEventListener('keydown', e => this.onKeyDown(e));
        document.addEventListener('keyup', e => this.onKeyUp(e));

        // Object list drag and drop
        this.setupDragDrop();

        // Properties modal drag
        this.setupPropertiesModalDrag();
    }

    resize() {
        const rect = this.container.getBoundingClientRect();
        this.canvas.width = rect.width;
        this.canvas.height = rect.height;

        // Center view if first time
        if (this.viewX === 0 && this.viewY === 0) {
            this.viewX = this.canvas.width / 2 - 5 * this.zoom;
            this.viewY = this.canvas.height / 2 + 5 * this.zoom;
        }

        this.render();
    }

    // ========================================================================
    // Coordinate Conversion
    // ========================================================================

    screenToWorld(sx, sy) {
        return {
            x: (sx - this.viewX) / this.zoom,
            y: (this.viewY - sy) / this.zoom
        };
    }

    worldToScreen(wx, wy) {
        return {
            x: wx * this.zoom + this.viewX,
            y: this.viewY - wy * this.zoom
        };
    }

    snapToGrid(val) {
        if (!this.ctrlKey) {
            return Math.round(val / this.snapGrid) * this.snapGrid;
        } else {
            return Number(Number(val).toFixed(2));
        }
    }

    // ========================================================================
    // Object Management
    // ========================================================================

    getObjectByName(name) {
        for (const obj of this.objects) {
            if (obj.name === name) {
                return obj;
            }
        }
        return null;
    }

    generateUniqueName(originalName) {
        // Generate unique name (A → A_1, A_1 → A_2, etc.)
        let baseName = originalName;
        let suffix = 1;

        // Extract base name and existing suffix
        const match = originalName.match(/^(.+)_(\d+)$/);
        if (match) {
            baseName = match[1];
            suffix = parseInt(match[2]) + 1;
        }

        // Find next available name
        let newName = `${baseName}_${suffix}`;
        while (this.getObjectByName(newName)) {
            suffix++;
            newName = `${baseName}_${suffix}`;
        }

        return newName;
    }

    addObject(obj) {
        // Save state for undo
        this.saveState();

        // Keep coordinates grouped at the top of the list
        if (obj instanceof TikZCoordinate && obj.showPoint === false && (!obj.label || obj.label.length == 0)) {
            // Find the last coordinate index
            let lastCoordIndex = -1;
            for (let i = 0; i < this.objects.length; i++) {
                if (this.objects[i] instanceof TikZCoordinate) {
                    lastCoordIndex = i;
                }
            }
            // Insert after last coordinate, or at beginning if no coordinates
            this.objects.splice(lastCoordIndex + 1, 0, obj);
        } else {
            this.objects.push(obj);
        }
        this.updateObjectList();
        this.updateObjectCount();
        this.render();
        return obj;
    }

    removeObject(obj) {
        // Save state for undo
        this.saveState();

        const idx = this.objects.indexOf(obj);
        if (idx >= 0) {
            // Find coordinates used by this object
            const coordsUsedByObject = this.getObjectCoordinates(obj);

            // Remove the object
            this.objects.splice(idx, 1);

            // Remove from selection if it was selected
            const selIdx = this.selectedObjects.indexOf(obj);
            if (selIdx >= 0) {
                this.selectedObjects.splice(selIdx, 1);
                this.updatePropertiesPanel();
            }

            // Delete coordinates that are now orphaned (only used by the deleted object)
            for (const coordName of coordsUsedByObject) {
                if (!this.isCoordinateShared(coordName, obj)) {
                    const coord = this.getCoordByName(coordName);
                    if (coord) {
                        const coordIdx = this.objects.indexOf(coord);
                        if (coordIdx >= 0) {
                            this.objects.splice(coordIdx, 1);
                            // Remove from selection if it was selected
                            const coordSelIdx = this.selectedObjects.indexOf(coord);
                            if (coordSelIdx >= 0) {
                                this.selectedObjects.splice(coordSelIdx, 1);
                            }
                        }
                    }
                }
            }

            this.updateObjectList();
            this.updateObjectCount();
            this.updateUndoRedoButtons();
            this.render();
        }
    }

    getCoordByName(name) {
        // Use cached lookup map for O(1) access instead of O(n) linear search
        if (!this._coordMap) {
            this._rebuildCoordMap();
        }
        return this._coordMap.get(name) || null;
    }

    // Rebuild the coordinate lookup map - call when coords are added/removed/renamed
    _rebuildCoordMap() {
        this._coordMap = new Map();
        for (const obj of this.objects) {
            if (obj instanceof TikZCoordinate) {
                this._coordMap.set(obj.name, obj);
            }
        }
    }

    // Invalidate coord map - call when any coord changes that would affect lookups
    _invalidateCoordMap() {
        this._coordMap = null;
    }

    findCoordNear(wx, wy, threshold = 0.3) {
        let closest = null;
        let closestDist = threshold;

        for (const obj of this.objects) {
            if (obj instanceof TikZCoordinate) {
                const dist = Math.hypot(obj.x - wx, obj.y - wy);
                if (dist < closestDist) {
                    closest = obj;
                    closestDist = dist;
                }
            }
        }

        return closest;
    }

    findObjectAt(wx, wy) {
        // Priority check: if a bezier is selected, check its control points first
        // This ensures control points are clickable even when grids are behind them
        if (this.selectedObjects.length === 1 && this.selectedObjects[0] instanceof TikZBezier) {
            const bezier = this.selectedObjects[0];
            const ctrl1 = this.getCoordByName(bezier.control1);
            const ctrl2 = this.getCoordByName(bezier.control2);
            if (ctrl1) {
                const dist = Math.hypot(ctrl1.x - wx, ctrl1.y - wy);
                if (dist < 0.3) return ctrl1; // Larger hit radius for better grabbing
            }
            if (ctrl2) {
                const dist = Math.hypot(ctrl2.x - wx, ctrl2.y - wy);
                if (dist < 0.3) return ctrl2;
            }
        }

        // Priority check: check all TikZCoordinates first so endpoints are easier to select
        for (let i = this.objects.length - 1; i >= 0; i--) {
            const obj = this.objects[i];
            if (obj instanceof TikZCoordinate) {
                const dist = Math.hypot(obj.x - wx, obj.y - wy);
                if (dist < 0.25) return obj;
            }
        }

        // Check other objects in reverse order (topmost first)
        for (let i = this.objects.length - 1; i >= 0; i--) {
            const obj = this.objects[i];

            if (obj instanceof TikZSegment || obj instanceof TikZVector) {
                const from = this.getCoordByName(obj.from);
                const to = this.getCoordByName(obj.to);
                if (from && to) {
                    const dist = this.pointToSegmentDist(wx, wy, from.x, from.y, to.x, to.y);
                    if (dist < 0.15) return obj;
                }
            }
            else if (obj instanceof TikZCircle) {
                const isEllipse = obj.isEllipse(this.getCoordByName.bind(this));
                if (isEllipse) {
                    // Check if point is inside ellipse
                    const params = obj.getEllipseParams(this.getCoordByName.bind(this));
                    if (params) {
                        // Transform point to ellipse's local coordinate system
                        const dx = wx - params.cx;
                        const dy = wy - params.cy;
                        // Rotate point by -rotation to align with ellipse axes
                        const cos = Math.cos(-params.rotation);
                        const sin = Math.sin(-params.rotation);
                        const localX = dx * cos - dy * sin;
                        const localY = dx * sin + dy * cos;
                        // Check if inside using ellipse equation: (x/a)² + (y/b)² <= 1
                        const normalized = (localX * localX) / (params.a * params.a) + (localY * localY) / (params.b * params.b);
                        if (normalized <= 1) return obj;
                    }
                } else {
                    const center = this.getCoordByName(obj.center);
                    if (center) {
                        const dist = Math.hypot(wx - center.x, wy - center.y);
                        // Click anywhere inside the circle (not just on edge)
                        if (dist <= obj.radius) return obj;
                    }
                }
            }
            else if (obj instanceof TikZArc) {
                const center = this.getCoordByName(obj.center);
                if (center) {
                    const dist = Math.hypot(wx - center.x, wy - center.y);
                    const angle = Math.atan2(wy - center.y, wx - center.x) * 180 / Math.PI;
                    let normAngle = angle < 0 ? angle + 360 : angle;
                    let startNorm = obj.startAngle < 0 ? obj.startAngle + 360 : obj.startAngle;
                    let endNorm = obj.endAngle < 0 ? obj.endAngle + 360 : obj.endAngle;

                    if (Math.abs(dist - obj.radius) < 0.15) {
                        // Check if angle is within arc
                        if (endNorm > startNorm) {
                            if (normAngle >= startNorm && normAngle <= endNorm) return obj;
                        } else {
                            if (normAngle >= startNorm || normAngle <= endNorm) return obj;
                        }
                    }
                }
            }
            else if (obj instanceof TikZRectangle) {
                // Click anywhere inside the rectangle
                if (wx >= obj.xMin && wx <= obj.xMax && wy >= obj.yMin && wy <= obj.yMax) {
                    return obj;
                }
            }
            else if (obj instanceof TikZBezier) {
                const from = this.getCoordByName(obj.from);
                const ctrl1 = this.getCoordByName(obj.control1);
                const ctrl2 = this.getCoordByName(obj.control2);
                const to = this.getCoordByName(obj.to);
                if (from && ctrl1 && ctrl2 && to) {
                    // Sample points along cubic bezier
                    for (let t = 0; t <= 1; t += 0.05) {
                        // Cubic bezier formula: B(t) = (1-t)^3*P0 + 3(1-t)^2*t*P1 + 3(1-t)*t^2*P2 + t^3*P3
                        const mt = 1 - t;
                        const px = mt*mt*mt*from.x + 3*mt*mt*t*ctrl1.x + 3*mt*t*t*ctrl2.x + t*t*t*to.x;
                        const py = mt*mt*mt*from.y + 3*mt*mt*t*ctrl1.y + 3*mt*t*t*ctrl2.y + t*t*t*to.y;
                        if (Math.hypot(wx - px, wy - py) < 0.15) return obj;
                    }
                }
            }
            else if (obj instanceof TikZPath) {
                if (obj.points.length < 2) continue;
                const coords = obj.points.map(p => this.getCoordByName(p)).filter(c => c);
                if (coords.length < 2) continue;

                // Check if point is on the path border
                for (let i = 0; i < coords.length - 1; i++) {
                    const dist = this.pointToSegmentDist(wx, wy, coords[i].x, coords[i].y,
                                                         coords[i+1].x, coords[i+1].y);
                    if (dist < 0.15) return obj;
                }

                if (coords.length >= 3) {
                    const dist = this.pointToSegmentDist(wx, wy,
                                                         coords[coords.length-1].x, coords[coords.length-1].y,
                                                         coords[0].x, coords[0].y);
                    if (dist < 0.15) return obj;

                    // Check if point is inside the polygon using ray casting
                    let inside = false;
                    for (let i = 0, j = coords.length - 1; i < coords.length; j = i++) {
                        const xi = coords[i].x, yi = coords[i].y;
                        const xj = coords[j].x, yj = coords[j].y;

                        const intersect = ((yi > wy) !== (yj > wy))
                            && (wx < (xj - xi) * (wy - yi) / (yj - yi) + xi);
                        if (intersect) inside = !inside;
                    }
                    if (inside) return obj;
                }
            }
            else if (obj instanceof TikZLabel) {
                const at = this.getCoordByName(obj.at);
                if (at) {
                    // Rough hit test for label
                    const dist = Math.hypot(wx - at.x, wy - at.y);
                    if (dist < 0.5) return obj;
                }
            }
            else if (obj instanceof TikZImage) {
                const at = this.getCoordByName(obj.at);
                if (at) {
                    // Hit test for image - check if inside image bounds
                    const bounds = obj.getBounds();
                    if (bounds) {
                        const h = obj.height || (obj.width / obj.naturalAspect);
                        const anchor = obj.anchor || 'center';

                        // Calculate actual bounds based on anchor
                        let minX = bounds.x;
                        let maxX = bounds.x + obj.width;
                        let minY = bounds.y;
                        let maxY = bounds.y + h;

                        // Adjust based on anchor
                        if (anchor.includes('east')) {
                            minX = bounds.x - obj.width;
                            maxX = bounds.x;
                        } else if (!anchor.includes('west')) {
                            minX = bounds.x - obj.width / 2;
                            maxX = bounds.x + obj.width / 2;
                        }

                        if (anchor.includes('north')) {
                            minY = bounds.y - h;
                            maxY = bounds.y;
                        } else if (anchor.includes('south')) {
                            minY = bounds.y;
                            maxY = bounds.y + h;
                        } else {
                            minY = bounds.y - h / 2;
                            maxY = bounds.y + h / 2;
                        }

                        if (wx >= minX && wx <= maxX && wy >= minY && wy <= maxY) {
                            return obj;
                        }
                    }
                }
            }
            else if (obj instanceof TikZGrid) {
                // Grid is selectable but low priority
                if (wx >= obj.xMin && wx <= obj.xMax && wy >= obj.yMin && wy <= obj.yMax) {
                    return obj;
                }
            }
        }

        return null;
    }

    pointToSegmentDist(px, py, x1, y1, x2, y2) {
        const dx = x2 - x1;
        const dy = y2 - y1;
        const len2 = dx*dx + dy*dy;

        if (len2 === 0) return Math.hypot(px - x1, py - y1);

        let t = ((px - x1) * dx + (py - y1) * dy) / len2;
        t = Math.max(0, Math.min(1, t));

        const closestX = x1 + t * dx;
        const closestY = y1 + t * dy;

        return Math.hypot(px - closestX, py - closestY);
    }
}
