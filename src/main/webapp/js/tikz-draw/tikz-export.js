// ============================================================================
// TikZ Draw - Export, Save/Load, Undo/Redo
// ============================================================================

Object.assign(TikZDrawApp.prototype, {

    // ========================================================================
    // TikZ Export
    // ========================================================================

    showExport() {
        const code = this.generateTikZ();
        document.getElementById('exportCode').value = code;
        document.getElementById('exportModal').classList.add('visible');
    },

    closeExport() {
        document.getElementById('exportModal').classList.remove('visible');
    },

    copyExport() {
        const textarea = document.getElementById('exportCode');
        textarea.select();
        document.execCommand('copy');
        this.showToast('Copied to clipboard!', 'success');
    },

    copyCodeToClipboard() {
        const code = document.getElementById('tikzCodeOutput').textContent;
        if (navigator.clipboard) {
            navigator.clipboard.writeText(code).then(() => {
                this.showToast('Copied to clipboard!', 'success');
            });
        } else {
            // Fallback
            const ta = document.createElement('textarea');
            ta.value = code;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            this.showToast('Copied to clipboard!', 'success');
        }
    },

    downloadExport() {
        const code = document.getElementById('exportCode').value;
        const blob = new Blob([code], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'tikz-drawing.tex';
        a.click();
        URL.revokeObjectURL(url);
    },


    generateTikZ() {
        let lines = [];

        // Check if any objects use patterns
        const usesPatterns = this.objects.some(o =>
            (o instanceof TikZCircle || o instanceof TikZRectangle || o instanceof TikZPath) &&
            o.pattern && o.pattern !== 'none'
        );

        // Add note about patterns library if needed
        if (usesPatterns) {
            lines.push('% NOTE: This drawing uses patterns. Add the following to your preamble:');
            lines.push('% \\usetikzlibrary{patterns}');
            lines.push('');
        }

        // Check if any objects use images
        const usesImages = this.objects.some(o => o instanceof TikZImage);

        // Add note about graphicx package if needed
        if (usesImages) {
            lines.push('% NOTE: This drawing uses images. Add the following to your preamble:');
            lines.push('% \\usepackage{graphicx}');
            lines.push('% NOTE: Image files must be in the same directory or provide full path');
            lines.push('');
        }

        // Preamble
        lines.push('\\begin{tikzpicture}[scale=1]');

        // Custom colors
        for (const [name, hex] of Object.entries(this.customColors)) {
            const rgb = this.hexToRgb(hex);
            if (rgb) {
                lines.push(`  \\definecolor{${name}}{RGB}{${rgb.r},${rgb.g},${rgb.b}}`);
            }
        }

        if (Object.keys(this.customColors).length > 0) lines.push('');

        // Separate objects by type for clean output
        const coords = this.objects.filter(o => o instanceof TikZCoordinate);
        const visibleCoords = coords.filter(o => o.showPoint);
        const labeledCoords = coords.filter(o => (o.label.length > 0));
        const others = this.objects.filter(o => !coords.includes(o)).concat(visibleCoords).concat(labeledCoords);

        // Coordinates
        if (coords.length > 0) {
            lines.push('  % Coordinates');
            coords.forEach(c => {
                // Ignore unused invisible coordinates
                if (c.label.length > 0 || c.showPoint || this.isCoordinateShared(c.name, c)) {
                    lines.push(c.toTikZ());
                }
            });
            lines.push('');
        }

        // Other objects in order
        if (others.length > 0) {
            lines.push('  % Drawing');
            others.forEach(o => {
                if (visibleCoords.includes(o)) {
                    lines.push(o.toTikZPoint());
                }
                if (labeledCoords.includes(o)) {
                    lines.push(o.toTikZLabel());
                }
                if (!coords.includes(o)) {
                    // Use toTikZWithCoords for circles to handle ellipses properly
                    if (o instanceof TikZCircle && o.toTikZWithCoords) {
                        lines.push(o.toTikZWithCoords(this.getCoordByName.bind(this)));
                    } else {
                        lines.push(o.toTikZ());
                    }
                }
            });
        }

        lines.push('\\end{tikzpicture}');

        return lines.join('\n');
    },

    // ========================================================================
    // Save/Load
    // ========================================================================

    saveProject() {
        const data = {
            version: '1.0',
            viewX: this.viewX,
            viewY: this.viewY,
            zoom: this.zoom,
            customColors: this.customColors,
            objects: this.objects.map(o => this.serializeObject(o, true)) // true = include full image data
        };

        const json = JSON.stringify(data, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        if (!this.saveFile(blob)) {
            // Prompt for filename
            let filename = prompt('Enter filename:', 'tikz-drawing');
            if (!filename) return; // User cancelled

            // Ensure .json extension
            filename = filename.trim();
            if (!filename.endsWith('.json')) {
                filename += '.json';
            }

            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = filename;
            a.click();
            URL.revokeObjectURL(url);
        }
        this.hasUnsavedChanges = false;
    },

    async saveFile(blob) {
      try {
        // Define picker options (suggested name, file types, etc.)
        const pickerOptions = {
          suggestedName: 'tikz-project.json',
          types: [{
            description: 'Tikz-draw file',
            accept: {
              'application/json': ['.json'],
            },
          }],
        };

        // Open the file picker and get a file handle
        const fileHandle = await window.showSaveFilePicker(pickerOptions);

        // Create a writable stream to the file
        const writableFileStream = await fileHandle.createWritable();

        // Write the content to the file
        await writableFileStream.write(blob);

        // Close the file
        await writableFileStream.close();
        return true;
      } catch (err) {
        return false;
      }
    },

    serializeObject(obj, forFile = false) {
        const data = { type: obj.constructor.name, id: obj.id, locked: obj.locked || false };

        if (obj instanceof TikZCoordinate) {
            data.x = obj.x;
            data.y = obj.y;
            data.name = obj.name;
            data.showPoint = obj.showPoint;
            data.pointSize = obj.pointSize;
            data.color = obj.color;
            data.label = obj.label;
            data.anchor = obj.anchor;
            data.expanded = obj.expanded;
        } else if (obj instanceof TikZSegment) {
            data.from = obj.from;
            data.to = obj.to;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.arrowEnd = obj.arrowEnd;
            data.arrowSize = obj.arrowSize;
            data.nodes = obj.nodes.map(n => ({
                text: n.text,
                position: n.position,
                anchor: n.anchor,
                fontSize: n.fontSize,
                color: n.color,
                sloped: n.sloped,
                rotation: n.rotation
            }));
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZVector) {
            data.from = obj.from;
            data.to = obj.to;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.arrowType = obj.arrowType;
            data.arrowEnd = obj.arrowEnd;
            data.arrowSize = obj.arrowSize;
            data.nodes = obj.nodes.map(n => ({
                text: n.text,
                position: n.position,
                anchor: n.anchor,
                fontSize: n.fontSize,
                color: n.color,
                sloped: n.sloped,
                rotation: n.rotation
            }));
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZCircle) {
            data.center = obj.center;
            data.center2 = obj.center2;
            data.radius = obj.radius;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.fill = obj.fill;
            data.fillOpacity = obj.fillOpacity;
            data.pattern = obj.pattern;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZArc) {
            data.center = obj.center;
            data.radius = obj.radius;
            data.startAngle = obj.startAngle;
            data.endAngle = obj.endAngle;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.arrowEnd = obj.arrowEnd;
            data.arrowSize = obj.arrowSize;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZRectangle) {
            data.xMin = obj.xMin;
            data.yMin = obj.yMin;
            data.xMax = obj.xMax;
            data.yMax = obj.yMax;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.fill = obj.fill;
            data.fillOpacity = obj.fillOpacity;
            data.pattern = obj.pattern;
            data.rotation = obj.rotation;
            data.rotationCenter = obj.rotationCenter;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZPath) {
            data.points = [...obj.points];
            data.closed = obj.closed;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.fill = obj.fill;
            data.fillOpacity = obj.fillOpacity;
            data.pattern = obj.pattern;
            data.nodes = obj.nodes.map(n => ({
                text: n.text,
                position: n.position,
                anchor: n.anchor,
                fontSize: n.fontSize,
                color: n.color,
                segmentIndex: n.segmentIndex,
                sloped: n.sloped,
                rotation: n.rotation
            }));
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZBezier) {
            data.from = obj.from;
            data.control1 = obj.control1;
            data.control2 = obj.control2;
            data.to = obj.to;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.lineStyle = obj.lineStyle;
            data.arrowEnd = obj.arrowEnd;
            data.arrowSize = obj.arrowSize;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZLabel) {
            data.at = obj.at;
            data.text = obj.text;
            data.position = obj.position;
            data.distance = obj.distance;
            data.fontSize = obj.fontSize;
            data.color = obj.color;
            data.rotation = obj.rotation;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZImage) {
            data.at = obj.at;
            if (forFile) {
                // For file save: include full image data
                data.imageData = obj.imageData;
            } else {
                // For undo/redo: store image data in cache to avoid duplication
                if (obj.imageData && !this.imageDataCache.has(obj.id)) {
                    this.imageDataCache.set(obj.id, {
                        imageData: obj.imageData,
                        filename: obj.filename,
                        mimeType: obj.mimeType
                    });
                }
                // Only store reference flag, not actual data
                data.imageDataCached = true;
            }
            data.filename = obj.filename;
            data.mimeType = obj.mimeType;
            data.width = obj.width;
            data.height = obj.height;
            data.opacity = obj.opacity;
            data.anchor = obj.anchor;
            data.rotation = obj.rotation;
            data.naturalAspect = obj.naturalAspect;
            data.expanded = obj.expanded;
            data.name = obj.name;
        } else if (obj instanceof TikZGrid) {
            data.xMin = obj.xMin;
            data.yMin = obj.yMin;
            data.xMax = obj.xMax;
            data.yMax = obj.yMax;
            data.step = obj.step;
            data.color = obj.color;
            data.thickness = obj.thickness;
            data.expanded = obj.expanded;
            data.name = obj.name;
        }

        return data;
    },

    loadProject() {
        // Warn if there are unsaved changes
        if (this.hasUnsavedChanges) {
            if (!confirm('You have unsaved changes. Do you want to continue and lose your changes?')) {
                return;
            }
        }

        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';

        input.addEventListener('change', e => {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = event => {
                    try {
                        const data = JSON.parse(event.target.result);
                        this.loadProjectData(data);
                    } catch (err) {
                        this.showToast('Error loading project: ' + err.message, 'error');
                    }
                };
                reader.onerror = () => {
                    this.showToast('Error reading file', 'error');
                };
                reader.readAsText(file);
            }
        });

        input.click();
    },

    loadProjectData(data) {
        if (!data || typeof data !== 'object') {
            this.showToast('Invalid project file format', 'error');
            return;
        }

        if (!data.objects || !Array.isArray(data.objects)) {
            this.showToast('Invalid project file: no objects found', 'error');
            return;
        }

        // Save state for undo (so user can undo the file load)
        this.saveState();

        // Reset
        this.objects = [];
        this.selectedObjects = [];
        this.latexCache.clear();
        this.imageDataCache.clear(); // Clear image cache to free memory
        // Note: undo/redo stacks are preserved so user can undo the file load
        objectIdCounter = 0;

        // Load settings
        if (data.viewX !== undefined) this.viewX = data.viewX;
        if (data.viewY !== undefined) this.viewY = data.viewY;
        if (data.zoom !== undefined) this.zoom = data.zoom;
        if (data.customColors) this.customColors = data.customColors;

        // Load objects
        for (const objData of data.objects) {
            const obj = this.deserializeObject(objData);
            if (obj) {
                this.objects.push(obj);
                // Update objectIdCounter to avoid ID collisions
                const idNum = parseInt(obj.id.split('_')[1]) || 0;
                if (idNum >= objectIdCounter) {
                    objectIdCounter = idNum + 1;
                }
            }
        }

        this.updateObjectList();
        this.updatePropertiesPanel();
        this.updateUndoRedoButtons();
        this.render();

        // Update zoom display
        document.getElementById('zoomLevel').textContent = Math.round(this.zoom * 2);

        // Loading a file starts fresh - no unsaved changes
        this.hasUnsavedChanges = false;
    },

    deserializeObject(data) {
        let obj;

        try {
            switch (data.type) {
                case 'TikZCoordinate':
                    obj = new TikZCoordinate(data.x, data.y, data.name);
                    obj.showPoint = data.showPoint;
                    obj.pointSize = data.pointSize;
                    obj.color = data.color;
                    obj.label = data.label || '';
                    obj.anchor = data.anchor || 'above right';
                    break;
                case 'TikZSegment':
                    obj = new TikZSegment(data.from, data.to);
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.arrowEnd = data.arrowEnd || 'none';
                    obj.arrowSize = data.arrowSize || 1.0;
                    if (data.nodes) {
                        obj.nodes = data.nodes.map(n => {
                            const node = new TikZEmbeddedNode(n.text, n.position, n.anchor);
                            node.fontSize = n.fontSize || 'normal';
                            node.color = n.color || 'black';
                            node.sloped = n.sloped || false;
                            node.rotation = n.rotation || 0;
                            return node;
                        });
                    }
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZVector':
                    // Convert old TikZVector to TikZSegment with arrows
                    obj = new TikZSegment(data.from, data.to);
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.arrowEnd = data.arrowEnd || '-Stealth';
                    obj.arrowSize = data.arrowSize || 1.0;
                    if (data.nodes) {
                        obj.nodes = data.nodes.map(n => {
                            const node = new TikZEmbeddedNode(n.text, n.position, n.anchor);
                            node.fontSize = n.fontSize || 'normal';
                            node.color = n.color || 'black';
                            node.sloped = n.sloped || false;
                            node.rotation = n.rotation || 0;
                            return node;
                        });
                    }
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZCircle':
                    obj = new TikZCircle(data.center, data.radius, data.center2 || data.center);
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.fill = data.fill;
                    obj.fillOpacity = data.fillOpacity;
                    obj.pattern = data.pattern || 'none';
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZArc':
                    obj = new TikZArc(data.center, data.radius, data.startAngle, data.endAngle);
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.arrowEnd = data.arrowEnd || 'none';
                    obj.arrowSize = data.arrowSize || 1.0;
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZRectangle':
                    // convert old style coordinates to new point values
                    if (data.corner1 && data.corner2) {
                        const p1 = this.getCoordByName(data.corner1);
                        const p2 = this.getCoordByName(data.corner2);
                        if (p1 && p2) {
                            obj = new TikZRectangle(Math.min(p1.x,p2.x), Math.min(p1.y,p2.y), Math.max(p1.x,p2.x), Math.max(p1.y,p2.y));
                        } else {
                            console.log('Cannot convert old rectangle to new format');
                            return null;
                        }
                    } else {
                        obj = new TikZRectangle(data.xMin, data.yMin, data.xMax, data.yMax);
                    }
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.fill = data.fill;
                    obj.fillOpacity = data.fillOpacity;
                    obj.pattern = data.pattern || 'none';
                    obj.rotation = data.rotation || 0;
                    obj.rotationCenter = data.rotationCenter || null;
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZPath':
                    obj = new TikZPath(data.points || []);
                    obj.closed = data.closed;
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.fill = data.fill;
                    obj.fillOpacity = data.fillOpacity;
                    obj.pattern = data.pattern || 'none';
                    if (data.nodes) {
                        obj.nodes = data.nodes.map(n => {
                            const node = new TikZEmbeddedNode(n.text, n.position, n.anchor);
                            node.fontSize = n.fontSize || 'normal';
                            node.color = n.color || 'black';
                            node.segmentIndex = n.segmentIndex;
                            node.sloped = n.sloped || false;
                            node.rotation = n.rotation || 0;
                            return node;
                        });
                    }
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZBezier':
                    // Support both old format (single control) and new format (two controls)
                    if (data.control1 && data.control2) {
                        obj = new TikZBezier(data.from, data.control1, data.control2, data.to);
                    } else if (data.control) {
                        // Old format: duplicate the single control point
                        obj = new TikZBezier(data.from, data.control, data.control, data.to);
                    } else {
                        console.log('Invalid bezier data');
                        return null;
                    }
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.lineStyle = data.lineStyle;
                    obj.arrowEnd = data.arrowEnd || 'none';
                    obj.arrowSize = data.arrowSize || 1.0;
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZLabel':
                    obj = new TikZLabel(data.at, data.text);
                    obj.position = data.position;
                    obj.distance = data.distance;
                    obj.fontSize = data.fontSize;
                    obj.color = data.color;
                    obj.rotation = data.rotation || 0;
                    obj.name = data.name || obj.name;
                    break;
                case 'TikZImage':
                    // Restore image data from cache if available (undo/redo case)
                    let imageData = data.imageData;
                    let filename = data.filename;
                    let mimeType = data.mimeType;
                    if (data.imageDataCached && data.id && this.imageDataCache.has(data.id)) {
                        const cached = this.imageDataCache.get(data.id);
                        imageData = cached.imageData;
                        filename = cached.filename || filename;
                        mimeType = cached.mimeType || mimeType;
                    }
                    obj = new TikZImage(data.at, imageData, filename, mimeType);
                    obj.width = data.width;
                    obj.height = data.height;
                    obj.opacity = data.opacity;
                    obj.anchor = data.anchor || 'center';
                    obj.rotation = data.rotation || 0;
                    obj.naturalAspect = data.naturalAspect || 1.0;
                    obj.name = data.name || obj.name;
                    // cachedImage will be loaded lazily on first render
                    break;
                case 'TikZGrid':
                    obj = new TikZGrid(data.xMin, data.yMin, data.xMax, data.yMax);
                    obj.step = data.step;
                    obj.color = data.color;
                    obj.thickness = data.thickness;
                    obj.name = data.name || obj.name;
                    break;
                default:
                    console.warn('Unknown object type:', data.type);
                    return null;
            }

            if (obj) {
                obj.id = data.id || obj.id;
                obj.expanded = data.expanded || false;
                obj.locked = data.locked || false;
            }
        } catch (err) {
            console.error('Error deserializing object:', data, err);
            return null;
        }

        return obj;
    },

    // ========================================================================
    // Undo/Redo
    // ========================================================================

    saveState() {
        // Don't save if we're in the middle of a multi-step tool operation
        if (this.tempPoints.length > 0) return;

        // Limit history size
        let needsCleanup = false;
        if (this.undoStack.length >= this.maxHistory) {
            this.undoStack.shift();
            needsCleanup = true;
        }

        // Deep copy current state (capture hasUnsavedChanges before we set it to true)
        const state = {
            objects: this.objects.map(o => this.serializeObject(o)),
            selectedIds: this.selectedObjects.map(o => o.id),
            customColors: { ...this.customColors },
            hasUnsavedChanges: this.hasUnsavedChanges
        };

        this.undoStack.push(state);

        // Clear redo stack when new action taken
        if (this.redoStack.length > 0) {
            this.redoStack = [];
            needsCleanup = true;
        }

        // Clean up image cache if we discarded states
        if (needsCleanup) {
            this.cleanupImageCache();
        }

        this.inNudge = false; // Keeps from saving sequential nudges
        this.hasUnsavedChanges = true;

        this.updateUndoRedoButtons();

        // Auto-update code panel if visible
        const codePanel = document.getElementById('codePanel');
        if (codePanel && !codePanel.classList.contains('collapsed')) {
            const codeOutput = document.getElementById('tikzCodeOutput');
            if (codeOutput) codeOutput.textContent = this.generateTikZ();
        }
    },

    undo() {
        if (this.undoStack.length === 0) return;

        // Save current state to redo stack
        const currentState = {
            objects: this.objects.map(o => this.serializeObject(o)),
            selectedIds: this.selectedObjects.map(o => o.id),
            customColors: { ...this.customColors },
            hasUnsavedChanges: this.hasUnsavedChanges
        };
        this.redoStack.push(currentState);

        // Restore previous state
        const previousState = this.undoStack.pop();
        this.loadState(previousState);

        this.updateUndoRedoButtons();
    },

    redo() {
        if (this.redoStack.length === 0) return;

        // Save current to undo
        const currentState = {
            objects: this.objects.map(o => this.serializeObject(o)),
            selectedIds: this.selectedObjects.map(o => o.id),
            customColors: { ...this.customColors },
            hasUnsavedChanges: this.hasUnsavedChanges
        };
        this.undoStack.push(currentState);

        // Restore from redo stack
        const nextState = this.redoStack.pop();
        this.loadState(nextState);

        this.updateUndoRedoButtons();
    },

    loadState(state) {
        // Reconstruct objects from serialized data
        this.objects = state.objects.map(data => this.deserializeObject(data)).filter(o => o !== null);

        // Restore custom colors
        this.customColors = { ...state.customColors };

        // Restore selection
        this.selectedObjects = this.objects.filter(o => state.selectedIds && state.selectedIds.includes(o.id));
        this.selectedSubIndex = -1;

        // Restore unsaved changes flag
        if (state.hasUnsavedChanges !== undefined) {
            this.hasUnsavedChanges = state.hasUnsavedChanges;
        }

        this.render();
        this.updatePropertiesPanel();
        this.updateObjectList();
        this.updateUndoRedoButtons();
    },

    // Clean up image cache by removing entries for images no longer in any state
    cleanupImageCache() {
        if (this.imageDataCache.size === 0) return;

        // Collect all image IDs that are still referenced
        const referencedIds = new Set();

        // From current objects
        for (const obj of this.objects) {
            if (obj instanceof TikZImage) {
                referencedIds.add(obj.id);
            }
        }

        // From undo stack
        for (const state of this.undoStack) {
            for (const data of state.objects) {
                if (data.type === 'TikZImage' && data.id) {
                    referencedIds.add(data.id);
                }
            }
        }

        // From redo stack
        for (const state of this.redoStack) {
            for (const data of state.objects) {
                if (data.type === 'TikZImage' && data.id) {
                    referencedIds.add(data.id);
                }
            }
        }

        // Remove unreferenced entries from cache
        for (const id of this.imageDataCache.keys()) {
            if (!referencedIds.has(id)) {
                this.imageDataCache.delete(id);
            }
        }
    },

    // ========================================================================
    // Copy/Paste
    // ========================================================================

    copyObject() {
        if (this.selectedObjects.length === 0) return;

        // Serialize all selected objects with full data (true = include image data)
        // since pasted objects will have new IDs and won't match the cache
        this.clipboard = {
            objects: this.selectedObjects.map(obj => this.serializeObject(obj, true)),
            count: this.selectedObjects.length
        };

        if (this.selectedObjects.length === 1) {
            this.showToast('Copied '+TYPE_NAMES[this.selectedObjects[0].type]+'!', 'success');
        } else {
            this.showToast('Copied '+this.selectedObjects.length+' objects!', 'success');
        }

        // Update button states (enables Paste button)
        this.updateUndoRedoButtons();
    },

    pasteObject() {
        if (!this.clipboard) return;

        // Save state for undo
        this.saveState();

        // Offset for pasted objects (0.5 units right and up)
        const offset = { x: 0.5, y: 0.5 };

        // Handle both old format (single object) and new format (multiple objects)
        const clipboardData = this.clipboard.objects ? this.clipboard.objects : [this.clipboard];

        // Map to store old coordinate names -> new coordinate names
        const coordMap = {};

        // Track which clipboard items are TikZCoordinates (by their name)
        const clipboardCoordinateNames = new Set();

        // First pass: collect ALL unique coordinates used by ALL objects
        const allCoordNames = new Set();
        for (const objData of clipboardData) {
            const tempObj = this.deserializeObject(objData);
            if (tempObj) {
                // Track TikZCoordinates in the clipboard
                if (tempObj instanceof TikZCoordinate) {
                    clipboardCoordinateNames.add(tempObj.name);
                }
                const coordNames = this.getObjectCoordinates(tempObj);
                coordNames.forEach(name => allCoordNames.add(name));
            }
        }

        // Create new coordinates for all coordinates used by the group
        // This ensures shared coordinates within the group remain shared
        const newObjects = [];
        for (const oldCoordName of allCoordNames) {
            const oldCoord = this.getCoordByName(oldCoordName);
            if (oldCoord) {
                // Create new coordinate with offset
                const newCoordName = this.generateCoordName();
                const newCoord = new TikZCoordinate(
                    oldCoord.x + offset.x,
                    oldCoord.y + offset.y,
                    newCoordName
                );

                // Copy coordinate properties
                newCoord.showPoint = oldCoord.showPoint;
                newCoord.pointSize = oldCoord.pointSize;
                newCoord.color = oldCoord.color;
                newCoord.label = oldCoord.label;
                newCoord.anchor = oldCoord.anchor;

                this.objects.push(newCoord);
                this._invalidateCoordMap(); // Invalidate cache so generateCoordName sees the new coord
                coordMap[oldCoordName] = newCoordName;

                // If this was a TikZCoordinate in the clipboard, add to newObjects for selection
                if (clipboardCoordinateNames.has(oldCoordName)) {
                    newObjects.push(newCoord);
                }
            }
        }

        // Second pass: deserialize all NON-COORDINATE objects and update their coordinate references
        for (const objData of clipboardData) {
            // Skip TikZCoordinates - they were already handled in the first pass
            if (objData.type === 'TikZCoordinate') {
                continue;
            }

            const newObj = this.deserializeObject(objData);
            if (newObj) {
                // generate new name and id
                newObj.name = this.generateUniqueName(newObj.name);
                newObj.id = generateId(newObj.type);

                // Update coordinate references in the new object
                for (const [oldName, newName] of Object.entries(coordMap)) {
                    this.updateObjectCoordinateReference(newObj, oldName, newName);
                }

                // For Grids and Rectangles update their corner points
                if (newObj instanceof TikZGrid || newObj instanceof TikZRectangle) {
                    newObj.xMin += offset.x;
                    newObj.yMin += offset.y;
                    newObj.xMax += offset.x;
                    newObj.yMax += offset.y;
                }

                this.objects.push(newObj);
                newObjects.push(newObj);
            }
        }

        // Select all pasted objects
        this.selectedObjects = newObjects;

        this.render();
        this.updatePropertiesPanel();
        this.updateObjectList();

        if (newObjects.length === 1) {
            this.showToast('Pasted '+TYPE_NAMES[newObjects[0].type]+'!', 'success');
        } else {
            this.showToast('Pasted '+newObjects.length+' objects!', 'success');
        }
    },

    updateUndoRedoButtons() {
        // Cache button references on first call for performance
        if (!this._undoBtn) {
            this._undoBtn = document.getElementById('undoBtn');
            this._redoBtn = document.getElementById('redoBtn');
            this._copyBtn = document.getElementById('copyBtn');
            this._pasteBtn = document.getElementById('pasteBtn');
        }

        if (this._undoBtn) {
            this._undoBtn.disabled = this.undoStack.length === 0;
        }
        if (this._redoBtn) {
            this._redoBtn.disabled = this.redoStack.length === 0;
        }
        if (this._copyBtn) {
            // Enable copy when any objects are selected
            this._copyBtn.disabled = this.selectedObjects.length === 0;
        }
        if (this._pasteBtn) {
            this._pasteBtn.disabled = !this.clipboard;
        }
    }
});
