// ============================================================================
// TikZ Draw - Tool Handlers & Input
// ============================================================================

Object.assign(TikZDrawApp.prototype, {

    // ========================================================================
    // Rotation Helpers
    // ========================================================================

    calculateSelectionCenter(objects) {
        // Calculate center point from all unique coordinates in selection
        const coordSet = new Set();

        for (const obj of objects) {
            if (obj instanceof TikZCoordinate) {
                coordSet.add(obj);
            } else if (obj instanceof TikZRectangle || obj instanceof TikZGrid) {
                const tempObj = new Object();
                tempObj.x = (obj.xMin + obj.xMax) / 2;
                tempObj.y = (obj.yMin + obj.yMax) / 2;
                coordSet.add(tempObj);
            } else {
                const coordNames = this.getObjectCoordinates(obj);
                for (const coordName of coordNames) {
                    const coord = this.getCoordByName(coordName);
                    if (coord) coordSet.add(coord);
                }
            }
        }

        const coords = Array.from(coordSet);
        if (coords.length === 0) return null;

        const sumX = coords.reduce((sum, c) => sum + c.x, 0);
        const sumY = coords.reduce((sum, c) => sum + c.y, 0);

        return {
            x: sumX / coords.length,
            y: sumY / coords.length
        };
    },

    rotatePoint(px, py, cx, cy, angleRad) {
        // Rotate point (px, py) around center (cx, cy) by angleDeg degrees
        // const angleRad = angleDeg * Math.PI / 180;
        const cos = Math.cos(angleRad);
        const sin = Math.sin(angleRad);
        const dx = px - cx;
        const dy = py - cy;

        return {
            x: cx + dx * cos - dy * sin,
            y: cy + dx * sin + dy * cos
        };
    },

    rotatePoints(p1x, p1y, p2x, p2y, cx, cy, angleRad) {
        // Rotate the center of rectangle/grid around global center (cx, cy)
        // The rectangle/grid itself will also rotate around its own center
        const cos = Math.cos(angleRad);
        const sin = Math.sin(angleRad);

        // Calculate rectangle/grid center
        const rectCenterX = (p1x + p2x) / 2.0;
        const rectCenterY = (p1y + p2y) / 2.0;

        // Calculate half dimensions (stay constant)
        const halfWidth = (p2x - p1x) / 2.0;
        const halfHeight = (p2y - p1y) / 2.0;

        // Rotate the rectangle/grid center around the global rotation center
        const dx = rectCenterX - cx;
        const dy = rectCenterY - cy;
        const newCenterX = cx + dx * cos - dy * sin;
        const newCenterY = cy + dx * sin + dy * cos;

        return {
            xMin: Number((newCenterX - halfWidth).toFixed(2)),
            yMin: Number((newCenterY - halfHeight).toFixed(2)),
            xMax: Number((newCenterX + halfWidth).toFixed(2)),
            yMax: Number((newCenterY + halfHeight).toFixed(2))
        };
    },

    snapAngle(angle, snapInterval = 5) {
        // Snap angle to nearest snapInterval degrees
        return Math.round(angle / snapInterval) * snapInterval;
    },

    normalizeAngle(angle) {
        // Normalize angle to [0, 360)
        while (angle < 0) angle += 360;
        while (angle >= 360) angle -= 360;
        return angle;
    },

    // ========================================================================
    // Move Tool Helpers
    // ========================================================================

    getObjectCoordinates(obj) {
        // Get all coordinate names used by an object
        const coordNames = [];

        if (obj instanceof TikZCoordinate) {
            coordNames.push(obj.name);
        } else if (obj instanceof TikZSegment || obj instanceof TikZVector) {
            coordNames.push(obj.from, obj.to);
        } else if (obj instanceof TikZCircle) {
            coordNames.push(obj.center);
            if (obj.center2 && obj.center2 !== obj.center) {
                coordNames.push(obj.center2);
            }
        } else if (obj instanceof TikZArc) {
            coordNames.push(obj.center);
        } else if (obj instanceof TikZPath) {
            coordNames.push(...obj.points);
        } else if (obj instanceof TikZBezier) {
            coordNames.push(obj.from, obj.control1, obj.control2, obj.to);
        } else if (obj instanceof TikZLabel) {
            coordNames.push(obj.at);
        } else if (obj instanceof TikZImage) {
            coordNames.push(obj.at);
        }

        return coordNames;
    },

    isCoordinateShared(coordName, excludeObject) {
        // Check if a coordinate is used by any object other than excludeObject
        for (const obj of this.objects) {
            if (obj instanceof TikZCoordinate || obj === excludeObject) continue;

            const coordNames = this.getObjectCoordinates(obj);
            if (coordNames.includes(coordName)) {
                return true;
            }
        }
        return false;
    },

    cloneCoordinate(originalName) {
        // Clone a coordinate and return the new coordinate object
        const original = this.getCoordByName(originalName);
        if (!original) return null;

        // Create cloned coordinate
        const newName = this.generateUniqueName(originalName);
        const cloned = new TikZCoordinate(original.x, original.y, newName);
        cloned.showPoint = false; // Hidden by default
        cloned.label = ''; // No label
        cloned.color = original.color;
        cloned.pointSize = original.pointSize;
        cloned.anchor = original.anchor;

        return cloned;
    },

    updateObjectCoordinateReference(obj, oldName, newName) {
        // Update an object's coordinate reference from oldName to newName
        if (obj instanceof TikZSegment || obj instanceof TikZVector) {
            if (obj.from === oldName) obj.from = newName;
            if (obj.to === oldName) obj.to = newName;
        } else if (obj instanceof TikZCircle) {
            if (obj.center === oldName) obj.center = newName;
            if (obj.center2 === oldName) obj.center2 = newName;
        } else if (obj instanceof TikZArc) {
            if (obj.center === oldName) obj.center = newName;
        } else if (obj instanceof TikZPath) {
            obj.points = obj.points.map(p => p === oldName ? newName : p);
        } else if (obj instanceof TikZBezier) {
            if (obj.from === oldName) obj.from = newName;
            if (obj.control1 === oldName) obj.control1 = newName;
            if (obj.control2 === oldName) obj.control2 = newName;
            if (obj.to === oldName) obj.to = newName;
        } else if (obj instanceof TikZLabel) {
            if (obj.at === oldName) obj.at = newName;
        } else if (obj instanceof TikZImage) {
            if (obj.at === oldName) obj.at = newName;
        }
    },

    prepareObjectForMove(obj) {
        // Prepare an object for independent movement by cloning shared coordinates
        // Returns array of coordinate objects that will be moved

        // TikZRectangle and TikZGrid don't use coordinate references, return empty array
        // They are handled specially in the move handler
        if (obj instanceof TikZRectangle || obj instanceof TikZGrid) {
            return [];
        }

        // TikZCoordinate: move it directly - this naturally moves all objects referencing it
        if (obj instanceof TikZCoordinate) {
            return [obj];
        }

        const coordNames = this.getObjectCoordinates(obj);

        // Remove duplicates to avoid processing same coordinate twice
        const uniqueCoordNames = [...new Set(coordNames)];
        const coordsToMove = [];

        for (const coordName of uniqueCoordNames) {
            const coord = this.getCoordByName(coordName);
            const isShared = this.isCoordinateShared(coordName, obj);
            const isLocked = coord && coord.locked;

            if (isShared || isLocked) {
                // Coordinate is shared or locked - clone it so original stays in place
                const cloned = this.cloneCoordinate(coordName);
                if (cloned) {
                    // Add cloned coordinate to objects
                    this.objects.push(cloned);
                    // Update object to reference cloned coordinate
                    this.updateObjectCoordinateReference(obj, coordName, cloned.name);
                    coordsToMove.push(cloned);
                }
            } else {
                // Coordinate is not shared and not locked, move it directly
                if (coord) {
                    coordsToMove.push(coord);
                }
            }
        }

        return coordsToMove;
    },

    prepareMultipleObjectsForMove(objects) {
        // Prepare multiple objects for movement
        // Coordinates shared WITHIN the selection move together (no cloning)
        // Coordinates shared OUTSIDE the selection are cloned

        // Collect all unique coordinates used by the selection
        const allCoordNames = new Set();
        for (const obj of objects) {
            const coordNames = this.getObjectCoordinates(obj);
            coordNames.forEach(name => allCoordNames.add(name));
        }

        const coordsToMove = [];
        const coordMap = {}; // old name -> new name (for cloned coords)

        for (const coordName of allCoordNames) {
            // Check if this coordinate is used by objects OUTSIDE the selection
            const usedOutside = this.objects.some(obj => {
                // Skip if obj is a TikZCoordinate (point itself)
                if (obj instanceof TikZCoordinate) return false;
                // Skip if obj is in the selection
                if (objects.includes(obj)) return false;
                // Check if obj uses this coordinate
                const objCoords = this.getObjectCoordinates(obj);
                return objCoords.includes(coordName);
            });

            const coord = this.getCoordByName(coordName);
            const isLocked = coord && coord.locked;

            if (usedOutside || isLocked) {
                // Clone if used outside selection or if locked (so original stays in place)
                const cloned = this.cloneCoordinate(coordName);
                if (cloned) {
                    this.objects.push(cloned);
                    coordMap[coordName] = cloned.name;
                    coordsToMove.push(cloned);
                }
            } else {
                // Move the coordinate directly (not shared outside and not locked)
                if (coord) {
                    coordsToMove.push(coord);
                }
            }
        }

        // Update all selected objects to use the new coordinate references
        for (const obj of objects) {
            for (const [oldName, newName] of Object.entries(coordMap)) {
                this.updateObjectCoordinateReference(obj, oldName, newName);
            }
        }

        return coordsToMove;
    },

    generateCoordName() {
        const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        let index = 0;

        while (true) {
            let name;
            if (index < 26) {
                name = letters[index];
            } else {
                name = letters[Math.floor(index / 26) - 1] + letters[index % 26];
            }

            if (!this.getCoordByName(name)) return name;
            index++;
        }
    },

    // ========================================================================
    // Mouse Event Handlers
    // ========================================================================

    onMouseDown(e) {
        const rect = this.canvas.getBoundingClientRect();
        const sx = e.clientX - rect.left;
        const sy = e.clientY - rect.top;
        const world = this.screenToWorld(sx, sy);
        const snapped = { x: this.snapToGrid(world.x), y: this.snapToGrid(world.y) };
        const ctrl_click = (e.ctrlKey);

        // Middle mouse or space+left for panning
        if (e.button === 1 || (e.button === 0 && e.shiftKey && this.currentTool === 'select')) {
            this.isPanning = true;
            this.panStart = { x: sx, y: sy, viewX: this.viewX, viewY: this.viewY };
            return;
        }

        // Right click to cancel
        if (e.button === 2) {
            this.toolState = null;
            this.tempPoints = [];
            this.render();
            return;
        }

        // Left click actions based on tool
        if (e.button === 0) {
            this.handleToolClick(snapped, world, ctrl_click);
        }
    },

    onMouseMove(e) {
        const rect = this.canvas.getBoundingClientRect();
        const sx = e.clientX - rect.left;
        const sy = e.clientY - rect.top;
        const ctrl_click = (e.ctrlKey);

        // Store last mouse position for rotation feedback
        this.lastMouseX = sx;
        this.lastMouseY = sy;

        const world = this.screenToWorld(sx, sy);
        const snapped = { x: this.snapToGrid(world.x), y: this.snapToGrid(world.y) };

        // Store last snapped position for temp geometry redraw
        this.lastSnapped = snapped;

        // Update cursor position display
        document.getElementById('cursorPos').textContent = `(${snapped.x.toFixed(2)}, ${snapped.y.toFixed(2)})`;

        // Handle panning
        if (this.isPanning && this.panStart) {
            this.viewX = this.panStart.viewX + (sx - this.panStart.x);
            this.viewY = this.panStart.viewY + (sy - this.panStart.y);
            this.render();
            return;
        }

        // Handle box selection (drag-to-select with Select tool)
        if (this.boxSelectStart && this.currentTool === 'select') {
            // Check if mouse moved enough to start box selection
            const dx = Math.abs(world.x - this.boxSelectStart.x);
            const dy = Math.abs(world.y - this.boxSelectStart.y);
            if (dx > 0.1 || dy > 0.1) {
                this.isBoxSelecting = true;
            }

            if (this.isBoxSelecting) {
                this.boxSelectEnd = world;
                this.render();
                return;
            }
        }

        // Handle select-move (dragging objects in select mode)
        if (this.selectMoveStart && this.currentTool === 'select' && !this.isMoving) {
            const dx = Math.abs(world.x - this.selectMoveStart.x);
            const dy = Math.abs(world.y - this.selectMoveStart.y);
            if (dx > 0.1 || dy > 0.1) {
                // Started dragging - initiate move
                this.saveState();

                const obj = this.selectMoveObject;
                const clickedOnSelected = this.selectedObjects.includes(obj);

                if (clickedOnSelected && this.selectedObjects.length > 1) {
                    // Moving multiple selected objects
                    this.moveCoords = this.prepareMultipleObjectsForMove(this.selectedObjects);
                    this.moveObject = null;
                } else {
                    // Moving single object
                    this.moveCoords = this.prepareObjectForMove(obj);
                    this.moveObject = obj;
                }

                this.isMoving = true;
                this.moveStart = this.selectMoveStart;
                this.selectMoveStart = null;
                this.selectMoveObject = null;
            }
        }

        // Handle dragging selected object
        if (this.isDragging && this.dragObject && this.dragObject instanceof TikZCoordinate) {
            this.dragObject.x = snapped.x;
            this.dragObject.y = snapped.y;
            this.render();
            this.updatePropertiesPanelThrottled(); // Throttled to avoid DOM thrashing
            return;
        }

        // Handle moving object
        if (this.isMoving && this.moveStart) {
            this.canvas.style.cursor = 'grabbing';

            let dx = snapped.x - this.moveStart.x;
            let dy = snapped.y - this.moveStart.y;

            // Apply offset to all coordinates
            for (const coord of this.moveCoords) {
                coord.x = coord.x + dx - (this.lastMoveDelta?.dx || 0);
                coord.y = coord.y + dy - (this.lastMoveDelta?.dy || 0);
            }

            // handle Grids and rectangles separately
            if (!this.moveObject) {
                for (const obj of this.selectedObjects) {
                    if (obj instanceof TikZGrid || obj instanceof TikZRectangle) {
                        obj.xMin = Number((obj.xMin + dx - (this.lastMoveDelta?.dx || 0)).toFixed(2));
                        obj.yMin = Number((obj.yMin + dy - (this.lastMoveDelta?.dy || 0)).toFixed(2));
                        obj.xMax = Number((obj.xMax + dx - (this.lastMoveDelta?.dx || 0)).toFixed(2));
                        obj.yMax = Number((obj.yMax + dy - (this.lastMoveDelta?.dy || 0)).toFixed(2));
                    }
                }
            } else if (this.moveObject instanceof TikZGrid || this.moveObject instanceof TikZRectangle) {
                this.moveObject.xMin = Number((this.moveObject.xMin + dx - (this.lastMoveDelta?.dx || 0)).toFixed(2));
                this.moveObject.yMin = Number((this.moveObject.yMin + dy - (this.lastMoveDelta?.dy || 0)).toFixed(2));
                this.moveObject.xMax = Number((this.moveObject.xMax + dx - (this.lastMoveDelta?.dx || 0)).toFixed(2));
                this.moveObject.yMax = Number((this.moveObject.yMax + dy - (this.lastMoveDelta?.dy || 0)).toFixed(2));
            }

            this.lastMoveDelta = { dx, dy };
            this.render();
            this.updatePropertiesPanelThrottled(); // Throttled to avoid DOM thrashing
            return;
        }

        // Handle rotating object
        if (this.isRotating && this.rotateCenter) {
            this.canvas.style.cursor = 'crosshair';

            // Calculate current angle from center to mouse
            const dx = world.x - this.rotateCenter.x;
            const dy = world.y - this.rotateCenter.y;
            this.rotateCurrentAngle = Math.atan2(dy, dx) * 180 / Math.PI;

            // Calculate rotation angle (how much to rotate from original)
            let rotationAngle = (this.rotateCurrentAngle - this.rotateStartAngle);

            // Apply snapping unless Shift or Ctrl is held
            if (!e.shiftKey) {
                rotationAngle = this.snapAngle(rotationAngle, (ctrl_click ? 1 : 5));
            }

            // Rotate all coordinates to their new positions
            if (this.rotateOriginalPositions) {
                for (const item of this.rotateOriginalPositions) {
                    const rotated = this.rotatePoint(
                        item.x, item.y,
                        this.rotateCenter.x, this.rotateCenter.y,
                        rotationAngle * Math.PI / 180
                    );
                    item.coord.x = rotated.x;
                    item.coord.y = rotated.y;
                }
            }

            // Update arc rotation properties
            if (this.rotateArcs && this.rotateArcs.length > 0) {
                for (const item of this.rotateArcs) {
                    item.arc.startAngle = item.originalStartAngle + rotationAngle;
                    item.arc.endAngle = item.originalEndAngle + rotationAngle;
                }
            }

            // Update image rotation properties
            if (this.rotateImages && this.rotateImages.length > 0) {
                for (const item of this.rotateImages) {
                    item.image.rotation = item.originalRotation - rotationAngle;
                }
            }

            // Update label rotation properties
            if (this.rotateLabels && this.rotateLabels.length > 0) {
                for (const item of this.rotateLabels) {
                    item.label.rotation = item.originalRotation - rotationAngle;
                }
            }

            // Update embedded node rotation properties (for non-sloped labels on segments/vectors/paths)
            if (this.rotateEmbeddedNodes && this.rotateEmbeddedNodes.length > 0) {
                for (const item of this.rotateEmbeddedNodes) {
                    item.node.rotation = item.originalRotation - rotationAngle;
                }
            }

            // Update rectangle rotation properties
            if (this.rotateRectangles && this.rotateRectangles.length > 0) {
                for (const item of this.rotateRectangles) {
                    item.rect.rotation = item.originalRotation + rotationAngle;
                    // Use ORIGINAL bounds, not current bounds, to prevent compound rotation
                    const rotated = this.rotatePoints(
                        item.originalXMin, item.originalYMin,
                        item.originalXMax, item.originalYMax,
                        this.rotateCenter.x, this.rotateCenter.y,
                        rotationAngle * Math.PI / 180
                    );
                    item.rect.xMin = rotated.xMin;
                    item.rect.yMin = rotated.yMin;
                    item.rect.xMax = rotated.xMax;
                    item.rect.yMax = rotated.yMax;
                }
            }

            // Update grid rotation properties
            if (this.rotateGrids && this.rotateGrids.length > 0) {
                for (const item of this.rotateGrids) {
                    item.grid.rotation = item.originalRotation + rotationAngle;
                    // Use ORIGINAL bounds, not current bounds, to prevent compound rotation
                    const rotated = this.rotatePoints(
                        item.originalXMin, item.originalYMin,
                        item.originalXMax, item.originalYMax,
                        this.rotateCenter.x, this.rotateCenter.y,
                        rotationAngle * Math.PI / 180
                    );
                    item.grid.xMin = rotated.xMin;
                    item.grid.yMin = rotated.yMin;
                    item.grid.xMax = rotated.xMax;
                    item.grid.yMax = rotated.yMax;
                }
            }

            this.render();
            return;
        }

        // Update cursor in select mode based on what's under mouse
        this.updateCursor();

        // Update temp drawing for tools
        if (this.tempPoints.length > 0) {
            this.render();
            this.drawTempGeometry(snapped);
        }
    },

    onMouseUp(e) {
        // Handle box selection completion
        if (this.boxSelectStart) {
            const rect = this.canvas.getBoundingClientRect();
            const sx = e.clientX - rect.left;
            const sy = e.clientY - rect.top;
            const world = this.screenToWorld(sx, sy);

            if (this.isBoxSelecting) {
                // Dragged to select - select all objects in box
                this.selectObjectsInBox(this.boxSelectStart, world);
                this.isBoxSelecting = false;
            } else {
                // Just clicked on empty space without dragging - clear selection
                this.selectedObjects = [];
            }

            this.boxSelectStart = null;
            this.boxSelectEnd = null;
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
        }

        if (this.isPanning) {
            this.isPanning = false;
            this.panStart = null;
        }

        if (this.isDragging) {
            this.isDragging = false;
            this.dragObject = null;
            this.updateObjectList();
        }

        if (this.isMoving) {
            this.isMoving = false;
            this.moveObject = null;
            this.moveStart = null;
            this.moveCoords = [];
            this.lastMoveDelta = null;
            this.updateObjectList();
        }

        // Clean up select-move state (clicked but didn't drag)
        if (this.selectMoveStart) {
            this.selectMoveStart = null;
            this.selectMoveObject = null;
        }

        if (this.isRotating) {
            this.isRotating = false;
            this.rotateCenter = null;
            this.rotateStartAngle = null;
            this.rotateCoords = [];
            this.rotateOriginalPositions = [];
            this.rotateRectangles = [];
            this.rotateGrids = [];
            this.rotateArcs = [];
            this.rotateImages = [];
            this.rotateLabels = [];
            this.rotateEmbeddedNodes = [];
            this.updateObjectList();
        }
        this.updateCursor();
    },

    onWheel(e) {
        e.preventDefault();

        const rect = this.canvas.getBoundingClientRect();
        const sx = e.clientX - rect.left;
        const sy = e.clientY - rect.top;

        // Zoom centered on mouse position
        const worldBefore = this.screenToWorld(sx, sy);

        const zoomFactor = e.deltaY < 0 ? 1.1 : 0.9;
        this.zoom = Math.max(10, Math.min(200, this.zoom * zoomFactor));

        const worldAfter = this.screenToWorld(sx, sy);

        this.viewX += (worldAfter.x - worldBefore.x) * this.zoom;
        this.viewY -= (worldAfter.y - worldBefore.y) * this.zoom;

        document.getElementById('zoomLevel').textContent = Math.round(this.zoom * 2);
        this.render();
    },

    onKeyDown(e) {
        // Check if we're in an input field - if so, let default behavior happen
        const activeEl = document.activeElement;
        const isInputActive = activeEl && (
            activeEl.tagName === 'INPUT' ||
            activeEl.tagName === 'TEXTAREA' ||
            activeEl.tagName === 'SELECT' ||
            activeEl.isContentEditable
        );

        // Save ctrl/shift state
        this.ctrlKey = e.ctrlKey;
        this.shiftKey = e.shiftKey;

        // Tool shortcuts - only when not in input
        const toolKeys = {
            'v': 'select', 'm': 'move', 'o': 'rotate', 'p': 'point', 'l': 'line',
            'c': 'circle', 'r': 'arc', 'b': 'rect', 't': 'label',
            'h': 'path', 'q': 'bezier', 'g': 'grid', 'i': 'image'
        };

        if (!isInputActive && toolKeys[e.key.toLowerCase()] && !e.ctrlKey && !e.metaKey) {
            const tool = toolKeys[e.key.toLowerCase()];
            document.querySelector(`.tool[data-tool="${tool}"]`)?.click();
            return;
        }

        // Delete - only when not in input field
        if ((e.key === 'Delete' || e.key === 'Backspace') && this.selectedObjects.length > 0 && !isInputActive) {
            e.preventDefault();

            // Make a copy of the array since removeObject modifies selectedObjects
            const objectsToRemove = [...this.selectedObjects];

            // Remove all selected objects
            for (const obj of objectsToRemove) {
                this.removeObject(obj);
            }
            return;
        }

        // Arrow keys to nudge selected objects - only when not in input field
        if (!isInputActive && this.selectedObjects.length > 0 && ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
            e.preventDefault();

            // Nudge amount: 0.01 units with Shift (fine), 0.1 units without (normal)
            const nudgeAmount = (e.shiftKey || e.ctrlKey) ? 0.01 : 0.1;
            let dx = 0, dy = 0;

            switch(e.key) {
                case 'ArrowUp': dy = nudgeAmount; break;
                case 'ArrowDown': dy = -nudgeAmount; break;
                case 'ArrowLeft': dx = -nudgeAmount; break;
                case 'ArrowRight': dx = nudgeAmount; break;
            }

            // Save state for undo
            if (! this.inNudge) {
                this.saveState();
                this.inNudge = true;
            }

            // Collect all coordinates to nudge (avoiding duplicates), skipping locked objects
            const coordsToNudge = new Set();
            const objectsToNudge = this.selectedObjects.filter(obj => !obj.locked);
            if (objectsToNudge.length === 0) return;

            for (const obj of objectsToNudge) {
                if (obj instanceof TikZCoordinate) {
                    // Direct coordinate - skip if locked (can't nudge locked point directly)
                    if (!obj.locked) {
                        coordsToNudge.add(obj);
                    }
                } else if (obj instanceof TikZRectangle || obj instanceof TikZGrid) {
                    // TikZRectangle and TikZGrid store numeric coords, not coordinate references
                    // Nudge them directly
                    obj.xMin = Number((obj.xMin + dx).toFixed(2));
                    obj.xMax = Number((obj.xMax + dx).toFixed(2));
                    obj.yMin = Number((obj.yMin + dy).toFixed(2));
                    obj.yMax = Number((obj.yMax + dy).toFixed(2));
                } else {
                    // Get all coordinates used by this object
                    const coordNames = this.getObjectCoordinates(obj);
                    for (const coordName of coordNames) {
                        const coord = this.getCoordByName(coordName);
                        if (coord) {
                            if (coord.locked) {
                                // Clone the locked coordinate so original stays in place
                                const cloned = this.cloneCoordinate(coordName);
                                if (cloned) {
                                    this.objects.push(cloned);
                                    this.updateObjectCoordinateReference(obj, coordName, cloned.name);
                                    coordsToNudge.add(cloned);
                                }
                            } else {
                                coordsToNudge.add(coord);
                            }
                        }
                    }
                }
            }

            // Nudge all collected coordinates
            for (const coord of coordsToNudge) {
                coord.x += dx;
                coord.y += dy;
            }

            this.render();
            this.updatePropertiesPanel();
            this.updateObjectList();
            return;
        }

        // Escape
        if (e.key === 'Escape') {
            this.toolState = null;
            this.tempPoints = [];
            this.selectedObjects = [];
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
            return;
        }

        // Ctrl+S to save
        if (e.key === 's' && (e.ctrlKey || e.metaKey)) {
            e.preventDefault();
            this.saveProject();
            return;
        }

        // Ctrl+E to export
        if (e.key === 'e' && (e.ctrlKey || e.metaKey)) {
            e.preventDefault();
            this.showExport();
            return;
        }

        // Ctrl+Z to undo
        if (e.key === 'z' && (e.ctrlKey || e.metaKey) && !e.shiftKey) {
            e.preventDefault();
            this.undo();
            return;
        }

        // Ctrl+Shift+Z or Ctrl+Y to redo
        if (((e.key === 'z' || e.key === 'Z') && (e.ctrlKey || e.metaKey) && e.shiftKey) ||
            (e.key === 'y' && (e.ctrlKey || e.metaKey))) {
            e.preventDefault();
            this.redo();
            return;
        }

        // Ctrl+C to copy
        if (e.key === 'c' && (e.ctrlKey || e.metaKey) && !isInputActive && this.selectedObjects.length > 0) {
            e.preventDefault();
            this.copyObject();
            return;
        }

        // Ctrl+V to paste
        if (e.key === 'v' && (e.ctrlKey || e.metaKey) && !isInputActive) {
            e.preventDefault();
            this.pasteObject();
            return;
        }
    },

    onKeyUp(e) {
        // Save ctrl/shift state
        this.ctrlKey = e.ctrlKey;
        this.shiftKey = e.shiftKey;
    },

    // ========================================================================
    // Tool Handling
    // ========================================================================

    handleToolClick(snapped, world, ctrl_click) {
        switch (this.currentTool) {
            case 'select':
                this.handleSelectClick(world, ctrl_click);
                break;
            case 'move':
                this.handleMoveClick(world);
                break;
            case 'rotate':
                this.handleRotateClick(world);
                break;
            case 'point':
                this.handlePointClick(snapped);
                break;
            case 'line':
            case 'vector':
                this.handleLineClick(snapped);
                break;
            case 'circle':
                this.handleCircleClick(snapped);
                break;
            case 'arc':
                this.handleArcClick(snapped);
                break;
            case 'rect':
                this.handleRectClick(snapped);
                break;
            case 'label':
                this.handleLabelClick(snapped);
                break;
            case 'image':
                this.handleImageClick(snapped);
                break;
            case 'path':
                this.handlePathClick(snapped);
                break;
            case 'bezier':
                this.handleBezierClick(snapped);
                break;
            case 'grid':
                this.handleGridClick(snapped);
                break;
        }
    },

    handleSelectClick(world, ctrl_click) {
        let obj = this.findObjectAt(world.x, world.y);

        // Skip locked objects (treat as if clicking empty space)
        if (obj && obj.locked) obj = null;

        // Check if clicking on a control point of a selected bezier
        if (obj instanceof TikZCoordinate && this.selectedObjects.length === 1) {
            const selectedBezier = this.selectedObjects[0];
            if (selectedBezier instanceof TikZBezier) {
                if (obj.name === selectedBezier.control1 || obj.name === selectedBezier.control2) {
                    // Save state for undo before dragging
                    this.saveState();
                    // Start dragging the control point but keep bezier selected
                    this.isDragging = true;
                    this.dragObject = obj;
                    this.render();
                    return;
                }
            }
        }

        if (obj) {
            const wasAlreadySelected = this.selectedObjects.includes(obj);

            if (ctrl_click) {
                // Ctrl-click: toggle selection without starting move
                const index = this.selectedObjects.indexOf(obj);
                if (index >= 0) {
                    this.selectedObjects.splice(index, 1);
                } else {
                    this.selectedObjects.push(obj);
                }
            } else {
                // Regular click on object
                if (!wasAlreadySelected) {
                    // Clicking on unselected object - select only this one
                    this.selectedObjects = [obj];
                }
                // If already selected, keep current selection (for multi-move)

                // Prepare for potential move (actual move starts in onMouseMove if dragged)
                this.selectMoveStart = { x: world.x, y: world.y };
                this.selectMoveObject = obj;
                this.selectMoveWasSelected = wasAlreadySelected;
            }

            // Update UI
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
        } else {
            // Clicked on empty space - start box selection (actual selection happens on mouseup)
            if (!ctrl_click) {
                this.boxSelectStart = { x: world.x, y: world.y };
            }
        }
    },

    handleMoveClick(world) {
        let obj = this.findObjectAt(world.x, world.y);

        // Skip locked objects
        if (obj && obj.locked) obj = null;

        if (obj) {
            // Save state for undo
            this.saveState();

            // Check if clicked object is in current selection
            const clickedOnSelected = this.selectedObjects.includes(obj);

            if (clickedOnSelected && this.selectedObjects.length > 1) {
                // Moving multiple selected objects
                this.moveCoords = this.prepareMultipleObjectsForMove(this.selectedObjects);
                this.moveObject = null; // Track that we're moving multiple
                // Keep current selection
            } else {
                // Moving single object (either unselected or only selected one)
                this.moveCoords = this.prepareObjectForMove(obj);
                this.moveObject = obj;
                // Update selection to just this object
                this.selectedObjects = [obj];
            }

            this.isMoving = true;
            this.moveStart = { x: world.x, y: world.y };

            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
        }
    },

    handleRotateClick(world) {
        let obj = this.findObjectAt(world.x, world.y);

        // Skip locked objects
        if (obj && obj.locked) obj = null;

        if (obj || this.selectedObjects.length > 0) {
            // Save state for undo
            this.saveState();

            // Determine which objects to rotate
            let objectsToRotate;
            if (obj && this.selectedObjects.includes(obj) && this.selectedObjects.length > 1) {
                // Clicked on a selected object with multiple selected - rotate all
                objectsToRotate = this.selectedObjects;
            } else if (obj) {
                // Clicked on object (selected or not) - rotate just this one
                objectsToRotate = [obj];
                this.selectedObjects = [obj];
            } else {
                // Clicked empty space but have selection - rotate all selected
                objectsToRotate = this.selectedObjects;
            }

            // Arcs rotate around their center point by updating their rotation property as well as their coordinate.
            const arcs = objectsToRotate.filter(obj => obj instanceof TikZArc);
            const coordBasedObjects = objectsToRotate;

            // Store arcs and their original rotations
            this.rotateArcs = arcs.map(arc => ({
                arc: arc,
                originalStartAngle: arc.startAngle || 0,
                originalEndAngle: arc.endAngle || 0
            }));

            // Images rotate around their anchor point by updating their rotation property as well as their coordinate.
            const images = objectsToRotate.filter(obj => obj instanceof TikZImage);

            // Store images and their original rotations
            this.rotateImages = images.map(img => ({
                image: img,
                originalRotation: img.rotation || 0
            }));

            // Labels rotate around their anchor point by updating their rotation property as well as their coordinate.
            const labels = objectsToRotate.filter(obj => obj instanceof TikZLabel);

            // Store labels and their original rotations
            this.rotateLabels = labels.map(lbl => ({
                label: lbl,
                originalRotation: lbl.rotation || 0
            }));

            // Embedded nodes on segments/vectors/paths should also rotate (when not sloped)
            this.rotateEmbeddedNodes = [];
            for (const obj of objectsToRotate) {
                if (obj.nodes && obj.nodes.length > 0) {
                    for (const node of obj.nodes) {
                        if (!node.sloped) {
                            this.rotateEmbeddedNodes.push({
                                node: node,
                                originalRotation: node.rotation || 0
                            });
                        }
                    }
                }
            }

            // Rectangles rotate around their center point by calculating it from corner points.
            const rectangles = objectsToRotate.filter(obj => obj instanceof TikZRectangle);

            // Store rectangles and their original rotations and bounds
            this.rotateRectangles = rectangles.map(rect => ({
                rect: rect,
                originalRotation: rect.rotation || 0,
                originalXMin: rect.xMin,
                originalYMin: rect.yMin,
                originalXMax: rect.xMax,
                originalYMax: rect.yMax
            }));

            // Grids rotate around their center point by calculating it from corner points.
            const grids = objectsToRotate.filter(obj => obj instanceof TikZGrid);

            // Store grids and their original rotations and bounds
            this.rotateGrids = grids.map(grid => ({
                grid: grid,
                originalRotation: grid.rotation || 0,
                originalXMin: grid.xMin,
                originalYMin: grid.yMin,
                originalXMax: grid.xMax,
                originalYMax: grid.yMax
            }));

            // Clone shared coordinates before rotating (only for coordinate-based objects)
            // Collect all coordinate names used by selected objects (excluding images' anchors)
            const coordNamesInSelection = new Set();
            for (const rotObj of coordBasedObjects) {
                if (rotObj instanceof TikZCoordinate) {
                    coordNamesInSelection.add(rotObj.name);
                } else {
                    const coordNames = this.getObjectCoordinates(rotObj);
                    for (const coordName of coordNames) {
                        coordNamesInSelection.add(coordName);
                    }
                }
            }

            // Check each coordinate - if shared with non-selected objects OR locked, clone it
            for (const coordName of coordNamesInSelection) {
                const coord = this.getCoordByName(coordName);
                const isLocked = coord && coord.locked;

                // Check if this coordinate is used by any non-selected objects
                let sharedWithNonSelected = false;
                for (const otherObj of this.objects) {
                    if (otherObj instanceof TikZCoordinate) continue;
                    if (objectsToRotate.includes(otherObj)) continue; // Skip selected objects

                    const otherCoords = this.getObjectCoordinates(otherObj);
                    if (otherCoords.includes(coordName)) {
                        sharedWithNonSelected = true;
                        break;
                    }
                }

                if (sharedWithNonSelected || isLocked) {
                    // Clone this coordinate and update all selected objects to use the clone
                    const cloned = this.cloneCoordinate(coordName);
                    if (cloned) {
                        this.objects.push(cloned);
                        // Update all coordinate-based selected objects to reference the cloned coordinate
                        for (const rotObj of coordBasedObjects) {
                            if (rotObj instanceof TikZCoordinate) continue;
                            this.updateObjectCoordinateReference(rotObj, coordName, cloned.name);
                        }
                    }
                }
            }

            // Calculate center of rotation from all objects (including images)
            this.rotateCenter = this.calculateSelectionCenter(objectsToRotate);

            if (!this.rotateCenter && coordBasedObjects.length > 0) return; // No valid coordinates to rotate

            // For image-only rotation, use the image's anchor as center
            if (!this.rotateCenter && images.length > 0) {
                const imgCoord = this.getCoordByName(images[0].at);
                if (imgCoord) {
                    this.rotateCenter = { x: imgCoord.x, y: imgCoord.y };
                } else {
                    return;
                }
            }

            // Collect all unique coordinates to rotate (after cloning, only for coordinate-based objects)
            const coordSet = new Set();
            for (const rotObj of coordBasedObjects) {
                if (rotObj instanceof TikZCoordinate) {
                    coordSet.add(rotObj);
                } else {
                    const coordNames = this.getObjectCoordinates(rotObj);
                    for (const coordName of coordNames) {
                        const coord = this.getCoordByName(coordName);
                        if (coord) coordSet.add(coord);
                    }
                }
            }

            this.rotateCoords = Array.from(coordSet);

            // Store original positions for rotation calculation
            this.rotateOriginalPositions = this.rotateCoords.map(coord => ({
                coord: coord,
                x: coord.x,
                y: coord.y
            }));

            // Calculate starting angle from center to mouse
            const dx = world.x - this.rotateCenter.x;
            const dy = world.y - this.rotateCenter.y;
            this.rotateStartAngle = Math.atan2(dy, dx) * 180 / Math.PI;

            this.isRotating = true;

            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
        }
    },

    switchToSelectMode() {
        this.currentTool = 'select';
        this.toolState = null;
        document.querySelectorAll('.tool').forEach(b => b.classList.remove('active'));
        document.querySelector('.tool[data-tool="select"]').classList.add('active');
        this.updateCursor();
        this.updateStatusTip();
    },

    updateCursor() {
        const world = this.screenToWorld(this.lastMouseX, this.lastMouseY);
        const objUnderMouse = this.findObjectAt(world.x, world.y);

        if (this.currentTool !== 'move' && this.currentTool !== 'select') {
            this.canvas.style.cursor = 'crosshair';
        } else if (objUnderMouse && !objUnderMouse.locked && this.selectedObjects.includes(objUnderMouse)) {
            // Hovering over a selected object - show move cursor
            this.canvas.style.cursor = 'move';
        } else if (objUnderMouse && !objUnderMouse.locked) {
            // Hovering over an unselected object - show pointer
            this.canvas.style.cursor = 'pointer';
        } else {
            // Hovering over empty space - default cursor
            this.canvas.style.cursor = 'default';
        }
    },

    handlePointClick(snapped) {
        // Check for existing point
        const existing = this.findCoordNear(snapped.x, snapped.y, 0.1);
        if (existing) {
            this.selectedObjects = [existing];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
            this.render();
            return;
        }

        const coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
        coord.showPoint = true;
        this.addObject(coord);
        this.selectedObjects = [coord];
        this.switchToSelectMode();
        this.updatePropertiesPanel();
        this.updateObjectList();
        this.updateUndoRedoButtons();
        this.render();
    },

    handleLineClick(snapped) {
        // Try to find existing coordinate nearby
        let coord = this.findCoordNear(snapped.x, snapped.y);

        if (!coord) {
            // Create new coordinate
            coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
            this.addObject(coord);
        }

        this.tempPoints.push(coord.name);

        if (this.tempPoints.length === 2) {
            // Create line segment
            const obj = new TikZSegment(this.tempPoints[0], this.tempPoints[1]);
            this.addObject(obj);
            this.selectedObjects = [obj];
            this.tempPoints = [];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    handleCircleClick(snapped) {
        if (this.tempPoints.length === 0) {
            // First click: center
            let coord = this.findCoordNear(snapped.x, snapped.y);
            if (!coord) {
                coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
                this.addObject(coord);
            }
            this.tempPoints.push({ name: coord.name, x: coord.x, y: coord.y });
        } else {
            // Second click: radius point
            const center = this.tempPoints[0];
            const radius = Math.hypot(snapped.x - center.x, snapped.y - center.y);

            // Create a second center point at the same location (for potential ellipse)
            const center2 = new TikZCoordinate(center.x, center.y, this.generateCoordName());
            this.addObject(center2);

            const circle = new TikZCircle(center.name, Math.max(0.1, radius), center2.name);
            this.addObject(circle);
            this.selectedObjects = [circle];
            this.tempPoints = [];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    handleArcClick(snapped) {
        if (this.tempPoints.length === 0) {
            // First click: center
            let coord = this.findCoordNear(snapped.x, snapped.y);
            if (!coord) {
                coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
                this.addObject(coord);
            }
            this.tempPoints.push({ name: coord.name, x: coord.x, y: coord.y });
        } else if (this.tempPoints.length === 1) {
            // Second click: start angle and radius
            const center = this.tempPoints[0];
            const radius = Math.hypot(snapped.x - center.x, snapped.y - center.y);
            const startAngle = Math.atan2(snapped.y - center.y, snapped.x - center.x) * 180 / Math.PI;
            this.tempPoints.push({ radius, startAngle });
        } else {
            // Third click: end angle
            const center = this.tempPoints[0];
            const { radius, startAngle } = this.tempPoints[1];
            const endAngle = Math.atan2(snapped.y - center.y, snapped.x - center.x) * 180 / Math.PI;

            const arc = new TikZArc(center.name, radius, startAngle, endAngle);
            this.addObject(arc);
            this.selectedObjects = [arc];
            this.tempPoints = [];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    handleRectClick(snapped) {
        if (this.tempPoints.length === 0) {
            this.tempPoints.push({ x: snapped.x, y: snapped.y });
        } else {
            const p1 = this.tempPoints[0];
            const rect = new TikZRectangle(
                Math.min(p1.x, snapped.x),
                Math.min(p1.y, snapped.y),
                Math.max(p1.x, snapped.x),
                Math.max(p1.y, snapped.y)
            );
            this.addObject(rect);
            this.selectedObjects = [rect];
            this.tempPoints = [];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    handleLabelClick(snapped) {
        // Attach to nearest coordinate
        const coord = this.findCoordNear(snapped.x, snapped.y, 1.0);

        if (coord) {
            const label = new TikZLabel(coord.name, '$x$');
            this.addObject(label);
            this.selectedObjects = [label];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        } else {
            // Create coordinate first
            const newCoord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
            this.addObject(newCoord);
            const label = new TikZLabel(newCoord.name, '$x$');
            this.addObject(label);
            this.selectedObjects = [label];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    handleImageClick(snapped) {
        // Create or find coordinate at click position
        let coord = this.findCoordNear(snapped.x, snapped.y, 1.0);
        if (!coord) {
            coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
            this.addObject(coord);
        }

        // Open file picker
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/png,image/jpeg,image/jpg,image/svg+xml';

        input.addEventListener('change', e => {
            const file = e.target.files[0];
            if (file) {
                this.loadImageFile(file, coord.name);
            }
        });

        input.click();
    },

    loadImageFile(file, coordName) {
        // Validate file size (warn if > 5MB)
        if (file.size > 5 * 1024 * 1024) {
            const proceed = confirm(
                `This image is ${Number((file.size / 1024 / 1024).toFixed(1))}MB. ` +
                `Large images will increase project file size. Continue?`
            );
            if (!proceed) return;
        }

        const reader = new FileReader();
        reader.onload = event => {
            const dataUrl = event.target.result;

            // Load image to get natural dimensions
            const img = new Image();
            img.onload = () => {
                const aspect = img.naturalWidth / img.naturalHeight;

                // Create TikZImage object
                const tikzImg = new TikZImage(
                    coordName,
                    dataUrl,
                    file.name,
                    file.type
                );
                tikzImg.naturalAspect = aspect;
                tikzImg.cachedImage = img;

                this.saveState(); // For undo
                this.addObject(tikzImg);
                this.selectedObjects = [tikzImg];
                this.switchToSelectMode();
                this.updatePropertiesPanel();
                this.updateObjectList();
                this.updateUndoRedoButtons();
                this.render();

                this.showToast(`Image "${file.name}" added!`, 'success');
            };

            img.onerror = () => {
                this.showToast('Failed to load image', 'error');
            };

            img.src = dataUrl;
        };

        reader.onerror = () => {
            this.showToast('Failed to read image file', 'error');
        };

        reader.readAsDataURL(file);
    },

    handlePathClick(snapped) {
        let coord = this.findCoordNear(snapped.x, snapped.y);
        if (!coord) {
            coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
            this.addObject(coord);
        }

        // Check if closing the path (clicking first point again)
        if (this.tempPoints.length >= 3 && coord.name === this.tempPoints[0]) {
            const path = new TikZPath([...this.tempPoints]);
            path.closed = true;
            this.addObject(path);
            this.selectedObjects = [path];
            this.tempPoints = [];
            this.switchToSelectMode();
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        } else {
            this.tempPoints.push(coord.name);

            // Double-click or shift+click to finish open path
            if (this.tempPoints.length >= 2 && this.toolState === 'finishing') {
                const path = new TikZPath([...this.tempPoints]);
                this.addObject(path);
                this.selectedObjects = [path];
                this.tempPoints = [];
                this.toolState = null;
                this.switchToSelectMode();
                this.updatePropertiesPanel();
                this.updateObjectList();
                this.updateUndoRedoButtons();
            }
        }

        this.render();

        // Keep showing temp geometry after click
        if (this.tempPoints.length > 0) {
            this.drawTempGeometry(snapped);
        }
    },

    handleBezierClick(snapped) {
        let coord = this.findCoordNear(snapped.x, snapped.y);
        if (!coord) {
            coord = new TikZCoordinate(snapped.x, snapped.y, this.generateCoordName());
            this.addObject(coord);
        }

        this.tempPoints.push(coord.name);

        if (this.tempPoints.length === 2) {
            // Get start and end coordinates
            const fromCoord = this.getCoordByName(this.tempPoints[0]);
            const toCoord = this.getCoordByName(this.tempPoints[1]);

            if (fromCoord && toCoord) {
                // Calculate control points offset perpendicular to the line
                const dx = toCoord.x - fromCoord.x;
                const dy = toCoord.y - fromCoord.y;
                const len = Math.hypot(dx, dy);

                // Perpendicular offset (on one side of the line)
                const perpX = -dy / len * 0.4 * len;  // 40% of length as offset
                const perpY = dx / len * 0.4 * len;

                // Control point 1: 1/3 along the line, offset perpendicular
                const c1x = fromCoord.x + dx / 3 + perpX;
                const c1y = fromCoord.y + dy / 3 + perpY;

                // Control point 2: 2/3 along the line, offset perpendicular
                const c2x = fromCoord.x + 2 * dx / 3 + perpX;
                const c2y = fromCoord.y + 2 * dy / 3 + perpY;

                // Create control point coordinates (hidden by default)
                const ctrl1 = new TikZCoordinate(c1x, c1y, this.generateCoordName());
                ctrl1.showPoint = false;
                this.addObject(ctrl1);

                const ctrl2 = new TikZCoordinate(c2x, c2y, this.generateCoordName());
                ctrl2.showPoint = false;
                this.addObject(ctrl2);

                // Create the bezier curve
                const bezier = new TikZBezier(this.tempPoints[0], ctrl1.name, ctrl2.name, this.tempPoints[1]);
                this.addObject(bezier);
                this.selectedObjects = [bezier];
                this.tempPoints = [];
                this.switchToSelectMode();
                this.updatePropertiesPanel();
                this.updateObjectList();
                this.updateUndoRedoButtons();
            }
        }

        this.render();
    },

    handleGridClick(snapped) {
        if (this.tempPoints.length === 0) {
            this.tempPoints.push({ x: snapped.x, y: snapped.y });
        } else {
            const p1 = this.tempPoints[0];
            const grid = new TikZGrid(
                Math.min(p1.x, snapped.x),
                Math.min(p1.y, snapped.y),
                Math.max(p1.x, snapped.x),
                Math.max(p1.y, snapped.y)
            );
            this.addObject(grid);
            this.selectedObjects = [grid];
            this.switchToSelectMode();
            this.tempPoints = [];
            this.updatePropertiesPanel();
            this.updateObjectList();
            this.updateUndoRedoButtons();
        }

        this.render();
    },

    updateStatusTip() {
        const tips = {
            'select': 'Click to select, drag to move points • Arrow keys to nudge (Shift for fine control)',
            'move': 'Click an object to move it independently • Arrow keys to nudge (Shift for fine control)',
            'point': 'Click to place a point',
            'line': 'Click two points to create a line',
            'vector': 'Click two points to create a vector',
            'circle': 'Click center, then click to set radius',
            'arc': 'Click center, start point, then end point',
            'rect': 'Click two opposite corners',
            'label': 'Click near a point to add a label',
            'path': 'Click points, click first point to close',
            'bezier': 'Click start point, then end point. Drag control points to shape curve.',
            'grid': 'Click two corners for grid area',
            'image': 'Click to place image anchor point'
        };

        document.getElementById('statusTip').textContent = tips[this.currentTool] || '';
    }

});
