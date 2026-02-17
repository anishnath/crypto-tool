// ============================================================================
// TikZ Draw - Canvas Renderer
// ============================================================================

Object.assign(TikZDrawApp.prototype, {

    render() {
        // Prevent recursive render calls
        if (this.isRendering) return;

        this.isRendering = true;

        // Invalidate coord lookup cache so it rebuilds with fresh data
        this._invalidateCoordMap();

        try {
            const ctx = this.ctx;
            const w = this.canvas.width;
            const h = this.canvas.height;

            // Clear with light gray background (matches canvas container)
            ctx.fillStyle = '#eeeef0';
            ctx.fillRect(0, 0, w, h);

            // Draw background grid
            this.drawBackgroundGrid();

            // Draw axes
            this.drawAxes();

            // Draw all objects
            for (const obj of this.objects) {
                this.drawObject(obj);
            }

            // Draw selection highlights for all selected objects
            for (const obj of this.selectedObjects) {
                this.drawSelectionHighlight(obj);
            }

            // Draw rotation visual feedback
            if (this.isRotating && this.rotateCenter) {
                this.drawRotationFeedback();
            }

            // Draw box selection rectangle
            if (this.isBoxSelecting && this.boxSelectStart && this.boxSelectEnd) {
                this.drawSelectionBox(this.boxSelectStart, this.boxSelectEnd);
            }

            // Draw temp geometry for in-progress tool operations
            // This ensures temp lines are visible even after async re-renders (e.g., LaTeX caching)
            if (this.tempPoints.length > 0 && this.lastSnapped) {
                this.drawTempGeometry(this.lastSnapped);
            }
        } finally {
            this.isRendering = false;
        }
    },

    drawBackgroundGrid() {
        const ctx = this.ctx;

        // Calculate visible range
        const topLeft = this.screenToWorld(0, 0);
        const bottomRight = this.screenToWorld(this.canvas.width, this.canvas.height);

        // Dot grid pattern (like Texpile) — dots at every 0.5 unit
        const dotStep = 0.5;
        const startX = Math.floor(topLeft.x / dotStep) * dotStep;
        const endX = Math.ceil(bottomRight.x / dotStep) * dotStep;
        const startY = Math.floor(bottomRight.y / dotStep) * dotStep;
        const endY = Math.ceil(topLeft.y / dotStep) * dotStep;

        for (let x = startX; x <= endX; x += dotStep) {
            for (let y = startY; y <= endY; y += dotStep) {
                const sp = this.worldToScreen(x, y);
                const isMainGrid = (Math.abs(x % 1) < 0.01) && (Math.abs(y % 1) < 0.01);

                ctx.fillStyle = isMainGrid ? 'rgba(0,0,0,0.18)' : 'rgba(0,0,0,0.08)';
                ctx.beginPath();
                ctx.arc(sp.x, sp.y, isMainGrid ? 1.5 : 0.8, 0, Math.PI * 2);
                ctx.fill();
            }
        }
    },

    drawAxes() {
        const ctx = this.ctx;
        const origin = this.worldToScreen(0, 0);

        ctx.strokeStyle = 'rgba(0,0,0,0.15)';
        ctx.lineWidth = 1;

        // X axis
        ctx.beginPath();
        ctx.moveTo(0, origin.y);
        ctx.lineTo(this.canvas.width, origin.y);
        ctx.stroke();

        // Y axis
        ctx.beginPath();
        ctx.moveTo(origin.x, 0);
        ctx.lineTo(origin.x, this.canvas.height);
        ctx.stroke();

        // Axis labels
        ctx.fillStyle = '#a1a1aa';
        ctx.font = '11px -apple-system, BlinkMacSystemFont, sans-serif';
        ctx.fillText('x', this.canvas.width - 15, origin.y - 5);
        ctx.fillText('y', origin.x + 5, 15);
    },

    drawObject(obj) {
        const ctx = this.ctx;

        if (obj instanceof TikZImage) {
            this.drawImage(obj);
        }
        else if (obj instanceof TikZGrid) {
            this.drawGrid(obj);
        }
        else if (obj instanceof TikZCoordinate) {
            this.drawCoordinate(obj);
        }
        else if (obj instanceof TikZSegment) {
            this.drawSegment(obj);
        }
        else if (obj instanceof TikZVector) {
            this.drawVector(obj);
        }
        else if (obj instanceof TikZCircle) {
            this.drawCircle(obj);
        }
        else if (obj instanceof TikZArc) {
            this.drawArc(obj);
        }
        else if (obj instanceof TikZRectangle) {
            this.drawRectangle(obj);
        }
        else if (obj instanceof TikZPath) {
            this.drawPath(obj);
        }
        else if (obj instanceof TikZBezier) {
            this.drawBezier(obj);
        }
        else if (obj instanceof TikZLabel) {
            const at = this.getCoordByName(obj.at);
            if (at) this.drawLabel(obj, at.x, at.y, (obj.rotation || 0) * Math.PI / 180);
        }
    },

    getColor(colorName) {
        return TIKZ_COLORS[colorName] || this.customColors[colorName] || colorName;
    },

    getThickness(thicknessName) {
        return (THICKNESS_VALUES[thicknessName] || 1) * Math.max(1, this.zoom / 50);
    },

    drawCoordinate(coord) {
        const ctx = this.ctx;
        const pos = this.worldToScreen(coord.x, coord.y);

        if (coord.showPoint) {
            const size = coord.pointSize * Math.max(1, this.zoom / 50);
            ctx.fillStyle = this.getColor(coord.color);
            ctx.beginPath();
            ctx.arc(pos.x, pos.y, size, 0, Math.PI * 2);
            ctx.fill();
        }

        // Draw coordinate name (editor reference, gray)
        ctx.fillStyle = '#a1a1aa';
        ctx.font = '10px sans-serif';
        const nameOffset = coord.showPoint ? (coord.pointSize * Math.max(1, this.zoom / 50) + 3) : 3;
        ctx.fillText(coord.name, pos.x + nameOffset, pos.y - 3);

        // Draw exported label if set (rendered with LaTeX)
        if (coord.label) {
            return this.drawLabel(coord, coord.x, coord.y);
        }
    },

    drawSegment(seg) {
        const from = this.getCoordByName(seg.from);
        const to = this.getCoordByName(seg.to);
        if (!from || !to) return;

        const ctx = this.ctx;
        const p1 = this.worldToScreen(from.x, from.y);
        const p2 = this.worldToScreen(to.x, to.y);

        ctx.strokeStyle = this.getColor(seg.color);
        ctx.fillStyle = this.getColor(seg.color);
        ctx.lineWidth = this.getThickness(seg.thickness);
        ctx.setLineDash(this.getLineDash(seg.lineStyle));

        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        ctx.stroke();
        ctx.setLineDash([]);

        // Draw arrowheads if specified
        if (seg.arrowEnd && seg.arrowEnd !== 'none') {
            const angle = Math.atan2(p2.y - p1.y, p2.x - p1.x);
            const arrowSize = 10 * (seg.arrowSize || 1.0) * Math.max(1, this.zoom / 50);
            const arrows = this.parseArrowSpec(seg.arrowEnd);
            if (arrows.end) {
                this.drawArrowhead(p2.x, p2.y, angle, arrowSize);
            }
            if (arrows.start) {
                this.drawArrowhead(p1.x, p1.y, angle + Math.PI, arrowSize);
            }
        }

        // Draw embedded nodes AFTER the line
        // Calculate line angle for sloped labels (in screen coordinates, Y is inverted)
        let lineAngle = -Math.atan2(to.y - from.y, to.x - from.x);
        // Normalize angle to keep text readable (not upside down)
        if (lineAngle > Math.PI / 2) lineAngle -= Math.PI;
        if (lineAngle < -Math.PI / 2) lineAngle += Math.PI;

        for (const node of seg.nodes) {
            const t = node.position;
            const nx = from.x + t * (to.x - from.x);
            const ny = from.y + t * (to.y - from.y);
            const angle = node.sloped ? lineAngle : (node.rotation || 0) * Math.PI / 180;
            this.drawLabel(node, nx, ny, angle);
        }
    },

    parseArrowSpec(arrowEnd) {
        // Parse arrow specification to determine start/end arrows
        const hasEnd = arrowEnd.endsWith('Stealth') || arrowEnd.endsWith('latex') || arrowEnd.endsWith('>');
        const hasStart = arrowEnd.startsWith('Stealth') || arrowEnd.startsWith('latex') || arrowEnd.startsWith('<');
        return { start: hasStart, end: hasEnd };
    },

    getLineDash(style) {
        switch (style) {
            case 'dashed': return [8, 4];
            case 'dotted': return [2, 3];
            case 'dashdotted': return [8, 3, 2, 3];
            case 'dashdotdotted': return [8, 3, 2, 3, 2, 3];
            case 'loosely dashed': return [8, 8];
            case 'densely dashed': return [4, 2];
            case 'loosely dotted': return [2, 6];
            case 'densely dotted': return [2, 1];
            case 'loosely dashdotted': return [8, 6, 2, 6];
            case 'densely dashdotted': return [4, 2, 2, 2];
            default: return [];
        }
    },

    drawStar(ctx, cx, cy, outerRadius, innerRadius, points) {
        let angle = Math.PI / 2 * 3; // Start from the top (12 o'clock position)
        let step = Math.PI / points; // Angle between points

        ctx.beginPath();
        // Move to the first outer point
        ctx.moveTo(cx + Math.cos(angle) * outerRadius, cy + Math.sin(angle) * outerRadius);

        for (let i = 0; i < points; i++) {
            // Outer point
            ctx.lineTo(cx + Math.cos(angle) * outerRadius, cy + Math.sin(angle) * outerRadius);
            angle += step;

            // Inner point
            ctx.lineTo(cx + Math.cos(angle) * innerRadius, cy + Math.sin(angle) * innerRadius);
            angle += step;
        }

        ctx.closePath();
        ctx.fill(); // Fill the star with the current fillStyle
    },

    createCanvasPattern(patternName, fillColor = '#808080') {
        if (patternName === 'none') return null;

        // Create a small canvas for the pattern
        const patternCanvas = document.createElement('canvas');
        const patternSize = 21;
        patternCanvas.width = patternSize;
        patternCanvas.height = patternSize;
        const pCtx = patternCanvas.getContext('2d');

        pCtx.strokeStyle = fillColor;
        pCtx.fillStyle = fillColor;
        pCtx.lineWidth = 1;

        switch (patternName) {
            case 'horizontal lines':
                pCtx.beginPath();
                pCtx.moveTo(0, 11);
                pCtx.lineTo(21, 11);
                pCtx.moveTo(0, 1);
                pCtx.lineTo(21, 1);
                pCtx.stroke();
                break;
            case 'vertical lines':
                pCtx.beginPath();
                pCtx.moveTo(1, 0);
                pCtx.lineTo(1, 21);
                pCtx.moveTo(11, 0);
                pCtx.lineTo(11, 21);
                pCtx.stroke();
                break;
            case 'north east lines':
                pCtx.beginPath();
                pCtx.moveTo(0, 21);
                pCtx.lineTo(21, 0);
                pCtx.moveTo(0, 10);
                pCtx.lineTo(10, 0);
                pCtx.moveTo(21, 10);
                pCtx.lineTo(10, 21);
                pCtx.stroke();
                break;
            case 'north west lines':
                pCtx.beginPath();
                pCtx.moveTo(0, 0);
                pCtx.lineTo(21, 21);
                pCtx.moveTo(0, 10);
                pCtx.lineTo(10, 21);
                pCtx.moveTo(10, 0);
                pCtx.lineTo(21, 10);
                pCtx.stroke();
                break;
            case 'grid':
                pCtx.beginPath();
                pCtx.moveTo(5, 0);
                pCtx.lineTo(5, 21);
                pCtx.moveTo(10, 0);
                pCtx.lineTo(10, 21);
                pCtx.moveTo(15, 0);
                pCtx.lineTo(15, 21);
                pCtx.moveTo(20, 0);
                pCtx.lineTo(20, 21);
                pCtx.moveTo(0, 5);
                pCtx.lineTo(21, 5);
                pCtx.moveTo(0, 10);
                pCtx.lineTo(21, 10);
                pCtx.moveTo(0, 15);
                pCtx.lineTo(21, 15);
                pCtx.moveTo(0, 20);
                pCtx.lineTo(21, 20);
                pCtx.stroke();
                break;
            case 'crosshatch':
                pCtx.beginPath();
                pCtx.moveTo(0, 0);
                pCtx.lineTo(21, 20);
                pCtx.moveTo(0, 21);
                pCtx.lineTo(20, 0);
                pCtx.moveTo(10, 0);
                pCtx.lineTo(21, 11);
                pCtx.moveTo(0, 11);
                pCtx.lineTo(11, 21);
                pCtx.moveTo(10, 0);
                pCtx.lineTo(0, 10);
                pCtx.moveTo(21, 11);
                pCtx.lineTo(11, 21);
                pCtx.stroke();
                break;
            case 'dots':
                pCtx.beginPath();
                pCtx.moveTo(5, 5);
                pCtx.arc(5, 5, 1, 0, Math.PI * 2);
                pCtx.moveTo(5, 15);
                pCtx.arc(5, 15, 1, 0, Math.PI * 2);
                pCtx.moveTo(15, 5);
                pCtx.arc(15, 5, 1, 0, Math.PI * 2);
                pCtx.moveTo(15, 15);
                pCtx.arc(15, 15, 1, 0, Math.PI * 2);
                pCtx.fill();
                break;
            case 'crosshatch dots':
                pCtx.beginPath();
                pCtx.moveTo(0, 0);
                pCtx.arc(0, 0, 1, 0, Math.PI * 2);
                pCtx.moveTo(21, 0);
                pCtx.arc(21, 0, 1, 0, Math.PI * 2);
                pCtx.moveTo(0, 21);
                pCtx.arc(0, 21, 1, 0, Math.PI * 2);
                pCtx.moveTo(21, 21);
                pCtx.arc(21, 21, 1, 0, Math.PI * 2);

                pCtx.moveTo(4, 10);
                pCtx.arc(4, 10, 1, 0, Math.PI * 2);
                pCtx.moveTo(16, 10);
                pCtx.arc(16, 10, 1, 0, Math.PI * 2);
                pCtx.moveTo(10, 4);
                pCtx.arc(10, 4, 1, 0, Math.PI * 2);
                pCtx.moveTo(10, 16);
                pCtx.arc(10, 16, 1, 0, Math.PI * 2);
                pCtx.fill();
                break;
            case 'fivepointed stars':
                this.drawStar(pCtx, 10, 10, 7, 3, 5);
                break;
            case 'sixpointed stars':
                this.drawStar(pCtx, 10, 10, 7, 3, 6);
                break;
            case 'bricks':
                pCtx.beginPath();
                pCtx.moveTo(0, 0);
                pCtx.lineTo(21, 0);
                pCtx.moveTo(0, 11);
                pCtx.lineTo(21, 11);
                pCtx.moveTo(6, 0);
                pCtx.lineTo(6, 11)
                pCtx.moveTo(14, 11);
                pCtx.lineTo(14, 21)
                pCtx.stroke();
                break;
            case 'checkerboard':
                pCtx.beginPath();
                pCtx.rect(0, 0, 10, 10);
                pCtx.rect(10, 10, 10, 10);
                pCtx.fill();
                break;
            default:
                return null;
        }

        return this.ctx.createPattern(patternCanvas, 'repeat');
    },

    drawVector(vec) {
        const from = this.getCoordByName(vec.from);
        const to = this.getCoordByName(vec.to);
        if (!from || !to) return;

        const ctx = this.ctx;
        const p1 = this.worldToScreen(from.x, from.y);
        const p2 = this.worldToScreen(to.x, to.y);

        ctx.strokeStyle = this.getColor(vec.color);
        ctx.fillStyle = this.getColor(vec.color);
        ctx.lineWidth = this.getThickness(vec.thickness);
        ctx.setLineDash(this.getLineDash(vec.lineStyle));

        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        ctx.stroke();
        ctx.setLineDash([]);

        // Draw arrowheads based on arrowEnd setting
        const angle = Math.atan2(p2.y - p1.y, p2.x - p1.x);
        const arrowSize = 10 * vec.arrowSize * Math.max(1, this.zoom / 50);

        const hasEndArrow = vec.arrowEnd.includes('Stealth') || vec.arrowEnd.includes('latex') || vec.arrowEnd === '->' || vec.arrowEnd === '<->';
        const hasStartArrow = vec.arrowEnd.startsWith('Stealth') || vec.arrowEnd.startsWith('latex') || vec.arrowEnd === '<-' || vec.arrowEnd === '<->';
        const hasBothArrows = vec.arrowEnd.includes('-') && vec.arrowEnd.split('-').filter(s => s).length === 2;

        if (hasBothArrows || (hasEndArrow && !vec.arrowEnd.startsWith('Stealth') && !vec.arrowEnd.startsWith('latex') && !vec.arrowEnd.startsWith('<'))) {
            this.drawArrowhead(p2.x, p2.y, angle, arrowSize);
        }
        if (hasBothArrows || hasStartArrow) {
            this.drawArrowhead(p1.x, p1.y, angle + Math.PI, arrowSize);
        }
        if (!hasBothArrows && (vec.arrowEnd === '-Stealth' || vec.arrowEnd === '-latex' || vec.arrowEnd === '->')) {
            this.drawArrowhead(p2.x, p2.y, angle, arrowSize);
        }

        // Draw embedded nodes AFTER the line and arrowheads
        // Calculate line angle for sloped labels (in screen coordinates, Y is inverted)
        let lineAngle = -Math.atan2(to.y - from.y, to.x - from.x);
        // Normalize angle to keep text readable (not upside down)
        if (lineAngle > Math.PI / 2) lineAngle -= Math.PI;
        if (lineAngle < -Math.PI / 2) lineAngle += Math.PI;

        for (const node of vec.nodes) {
            const t = node.position;
            const nx = from.x + t * (to.x - from.x);
            const ny = from.y + t * (to.y - from.y);
            const nodeAngle = node.sloped ? lineAngle : (node.rotation || 0) * Math.PI / 180;
            this.drawLabel(node, nx, ny, nodeAngle);
        }
    },

    drawArrowhead(x, y, angle, size) {
        const ctx = this.ctx;
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x - size * Math.cos(angle - 0.4), y - size * Math.sin(angle - 0.4));
        ctx.lineTo(x - size * 0.6 * Math.cos(angle), y - size * 0.6 * Math.sin(angle));
        ctx.lineTo(x - size * Math.cos(angle + 0.4), y - size * Math.sin(angle + 0.4));
        ctx.closePath();
        ctx.fill();
    },

    drawCircle(circle) {
        const center = this.getCoordByName(circle.center);
        if (!center) return;

        const ctx = this.ctx;

        // Check if this is an ellipse
        const isEllipse = circle.isEllipse(this.getCoordByName.bind(this));

        if (isEllipse) {
            const params = circle.getEllipseParams(this.getCoordByName.bind(this));
            if (!params) return;

            const centerPos = this.worldToScreen(params.cx, params.cy);
            const a = params.a * this.zoom; // Semi-major axis in screen coords
            const b = params.b * this.zoom; // Semi-minor axis in screen coords
            // Note: canvas y is inverted, so negate rotation
            const rotation = -params.rotation;

            if (circle.fill !== 'none') {
                if (circle.pattern && circle.pattern !== 'none') {
                    const pattern = this.createCanvasPattern(circle.pattern, this.getColor(circle.fill));
                    ctx.fillStyle = pattern || this.getColor(circle.fill);
                } else {
                    ctx.fillStyle = this.getColor(circle.fill);
                }
                ctx.globalAlpha = circle.fillOpacity;
                ctx.beginPath();
                ctx.ellipse(centerPos.x, centerPos.y, a, b, rotation, 0, Math.PI * 2);
                ctx.fill();
                ctx.globalAlpha = 1;
            }

            ctx.strokeStyle = this.getColor(circle.color);
            ctx.lineWidth = this.getThickness(circle.thickness);
            ctx.setLineDash(this.getLineDash(circle.lineStyle));

            ctx.beginPath();
            ctx.ellipse(centerPos.x, centerPos.y, a, b, rotation, 0, Math.PI * 2);
            ctx.stroke();
            ctx.setLineDash([]);
        } else {
            // Regular circle
            const pos = this.worldToScreen(center.x, center.y);
            const radius = circle.radius * this.zoom;

            if (circle.fill !== 'none') {
                if (circle.pattern && circle.pattern !== 'none') {
                    const pattern = this.createCanvasPattern(circle.pattern, this.getColor(circle.fill));
                    ctx.fillStyle = pattern || this.getColor(circle.fill);
                } else {
                    ctx.fillStyle = this.getColor(circle.fill);
                }
                ctx.globalAlpha = circle.fillOpacity;
                ctx.beginPath();
                ctx.arc(pos.x, pos.y, radius, 0, Math.PI * 2);
                ctx.fill();
                ctx.globalAlpha = 1;
            }

            ctx.strokeStyle = this.getColor(circle.color);
            ctx.lineWidth = this.getThickness(circle.thickness);
            ctx.setLineDash(this.getLineDash(circle.lineStyle));

            ctx.beginPath();
            ctx.arc(pos.x, pos.y, radius, 0, Math.PI * 2);
            ctx.stroke();
            ctx.setLineDash([]);
        }
    },

    drawArc(arc) {
        const center = this.getCoordByName(arc.center);
        if (!center) return;

        const ctx = this.ctx;
        const pos = this.worldToScreen(center.x, center.y);
        const radius = arc.radius * this.zoom;

        ctx.strokeStyle = this.getColor(arc.color);
        ctx.fillStyle = this.getColor(arc.color);
        ctx.lineWidth = this.getThickness(arc.thickness);
        ctx.setLineDash(this.getLineDash(arc.lineStyle));

        // Convert angles (canvas y is inverted)
        const startRad = -arc.startAngle * Math.PI / 180;
        const endRad = -arc.endAngle * Math.PI / 180;

        ctx.beginPath();
        ctx.arc(pos.x, pos.y, radius, startRad, endRad, true);
        ctx.stroke();
        ctx.setLineDash([]);

        // Draw arrowheads if specified
        if (arc.arrowEnd && arc.arrowEnd !== 'none') {
            const arrowSize = 10 * (arc.arrowSize || 1.0) * Math.max(1, this.zoom / 50);
            const arrows = this.parseArrowSpec(arc.arrowEnd);

            // Calculate positions and tangent angles at arc endpoints
            const startX = pos.x + radius * Math.cos(startRad);
            const startY = pos.y + radius * Math.sin(startRad);
            const endX = pos.x + radius * Math.cos(endRad);
            const endY = pos.y + radius * Math.sin(endRad);

            // Tangent angle is perpendicular to radius (90 degrees offset)
            // For clockwise arc (true), start tangent points "backward" and end tangent points "forward"
            if (arrows.end) {
                const endTangent = endRad + Math.PI / 2; // Tangent at end, pointing in arc direction
                this.drawArrowhead(endX, endY, endTangent, arrowSize);
            }
            if (arrows.start) {
                const startTangent = startRad - Math.PI / 2; // Tangent at start, pointing opposite
                this.drawArrowhead(startX, startY, startTangent, arrowSize);
            }
        }
    },

    drawRectangle(rect) {
        const ctx = this.ctx;
        const p1 = this.worldToScreen(rect.xMin, rect.yMin);
        const p2 = this.worldToScreen(rect.xMax, rect.yMax);

        const x = Math.min(p1.x, p2.x);
        const y = Math.min(p1.y, p2.y);
        const w = Math.abs(p2.x - p1.x);
        const h = Math.abs(p2.y - p1.y);

        // Calculate center in screen coordinates
        const cx = x + w / 2;
        const cy = y + h / 2;

        ctx.save();

        // Apply rotation if needed
        if (rect.rotation && rect.rotation !== 0) {
            // Rotate around the rectangle's center
            ctx.translate(cx, cy);
            ctx.rotate(-(rect.rotation * Math.PI) / 180);
            ctx.translate(-cx, -cy);
        }

        if (rect.fill !== 'none') {
            // Use pattern if specified, otherwise use solid fill
            if (rect.pattern && rect.pattern !== 'none') {
                const pattern = this.createCanvasPattern(rect.pattern, this.getColor(rect.fill));
                if (pattern) {
                    // don't rotate the pattern with the object
                    if (rect.rotation && rect.rotation !== 0) {
                        const patternTransform = new DOMMatrix().rotate(rect.rotation);

                        // Set the transform on the pattern
                        pattern.setTransform(patternTransform);
                    }
                    ctx.fillStyle = pattern;
                } else {
                    ctx.fillStyle = this.getColor(rect.fill);
                }
            } else {
                ctx.fillStyle = this.getColor(rect.fill);
            }

            ctx.globalAlpha = rect.fillOpacity;
            ctx.fillRect(x, y, w, h);
            ctx.globalAlpha = 1;
        }

        ctx.strokeStyle = this.getColor(rect.color);
        ctx.lineWidth = this.getThickness(rect.thickness);
        ctx.setLineDash(this.getLineDash(rect.lineStyle));

        ctx.strokeRect(x, y, w, h);
        ctx.setLineDash([]);
        ctx.restore();
    },

    drawPath(path) {
        if (path.points.length < 2) return;

        const ctx = this.ctx;
        const points = path.points.map(p => this.getCoordByName(p)).filter(p => p);
        if (points.length < 2) return;

        const screenPoints = points.map(p => this.worldToScreen(p.x, p.y));

        if (path.fill !== 'none') {
            // Use pattern if specified, otherwise use solid fill
            if (path.pattern && path.pattern !== 'none') {
                const pattern = this.createCanvasPattern(path.pattern, this.getColor(path.fill));
                if (pattern) {
                    // don't rotate the pattern with the object
                    if (path.rotation && path.rotation !== 0) {
                        const patternTransform = new DOMMatrix().rotate(path.rotation);

                        // Set the transform on the pattern
                        pattern.setTransform(patternTransform);
                    }
                    ctx.fillStyle = pattern;
                } else {
                    ctx.fillStyle = this.getColor(path.fill);
                }
            } else {
                ctx.fillStyle = this.getColor(path.fill);
            }
            ctx.globalAlpha = path.fillOpacity;
            ctx.beginPath();
            ctx.moveTo(screenPoints[0].x, screenPoints[0].y);
            for (let i = 1; i < screenPoints.length; i++) {
                ctx.lineTo(screenPoints[i].x, screenPoints[i].y);
            }
            ctx.closePath();
            ctx.fill();
            ctx.globalAlpha = 1;
        }

        ctx.strokeStyle = this.getColor(path.color);
        ctx.lineWidth = this.getThickness(path.thickness);
        ctx.setLineDash(this.getLineDash(path.lineStyle));

        ctx.beginPath();
        ctx.moveTo(screenPoints[0].x, screenPoints[0].y);
        for (let i = 1; i < screenPoints.length; i++) {
            ctx.lineTo(screenPoints[i].x, screenPoints[i].y);
        }
        if (path.closed) ctx.closePath();
        ctx.stroke();
        ctx.setLineDash([]);

        // Draw embedded nodes on each segment
        for (let i = 0; i < points.length - 1; i++) {
            const segmentNodes = path.nodes.filter(n => n.segmentIndex === i);
            // Calculate segment angle for sloped labels
            let segAngle = -Math.atan2(points[i+1].y - points[i].y, points[i+1].x - points[i].x);
            // Normalize angle to keep text readable
            if (segAngle > Math.PI / 2) segAngle -= Math.PI;
            if (segAngle < -Math.PI / 2) segAngle += Math.PI;

            for (const node of segmentNodes) {
                const t = node.position;
                const nx = points[i].x + t * (points[i+1].x - points[i].x);
                const ny = points[i].y + t * (points[i+1].y - points[i].y);
                const angle = node.sloped ? segAngle : (node.rotation || 0) * Math.PI / 180;
                this.drawLabel(node, nx, ny, angle);
            }
        }

        // Draw embedded nodes on closing segment if path is closed
        if (path.closed && points.length > 2) {
            const closingIndex = points.length - 1;
            const closingNodes = path.nodes.filter(n => n.segmentIndex === closingIndex);
            // Calculate closing segment angle
            let closingAngle = -Math.atan2(points[0].y - points[closingIndex].y, points[0].x - points[closingIndex].x);
            if (closingAngle > Math.PI / 2) closingAngle -= Math.PI;
            if (closingAngle < -Math.PI / 2) closingAngle += Math.PI;

            for (const node of closingNodes) {
                const t = node.position;
                const nx = points[closingIndex].x + t * (points[0].x - points[closingIndex].x);
                const ny = points[closingIndex].y + t * (points[0].y - points[closingIndex].y);
                const angle = node.sloped ? closingAngle : (node.rotation || 0) * Math.PI / 180;
                this.drawLabel(node, nx, ny, angle);
            }
        }
    },

    drawBezier(bezier) {
        const from = this.getCoordByName(bezier.from);
        const ctrl1 = this.getCoordByName(bezier.control1);
        const ctrl2 = this.getCoordByName(bezier.control2);
        const to = this.getCoordByName(bezier.to);
        if (!from || !ctrl1 || !ctrl2 || !to) return;

        const ctx = this.ctx;
        const p1 = this.worldToScreen(from.x, from.y);
        const pc1 = this.worldToScreen(ctrl1.x, ctrl1.y);
        const pc2 = this.worldToScreen(ctrl2.x, ctrl2.y);
        const p2 = this.worldToScreen(to.x, to.y);

        ctx.strokeStyle = this.getColor(bezier.color);
        ctx.fillStyle = this.getColor(bezier.color);
        ctx.lineWidth = this.getThickness(bezier.thickness);
        ctx.setLineDash(this.getLineDash(bezier.lineStyle));

        // Draw cubic bezier with two control points
        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.bezierCurveTo(pc1.x, pc1.y, pc2.x, pc2.y, p2.x, p2.y);
        ctx.stroke();
        ctx.setLineDash([]);

        // Draw arrowheads if specified
        if (bezier.arrowEnd && bezier.arrowEnd !== 'none') {
            const arrowSize = 10 * (bezier.arrowSize || 1.0) * Math.max(1, this.zoom / 50);
            const arrows = this.parseArrowSpec(bezier.arrowEnd);

            // Calculate tangent angles at endpoints
            // At start: tangent direction is towards control1
            const startAngle = Math.atan2(pc1.y - p1.y, pc1.x - p1.x);
            // At end: tangent direction is from control2 towards end
            const endAngle = Math.atan2(p2.y - pc2.y, p2.x - pc2.x);

            if (arrows.end) {
                this.drawArrowhead(p2.x, p2.y, endAngle, arrowSize);
            }
            if (arrows.start) {
                this.drawArrowhead(p1.x, p1.y, startAngle + Math.PI, arrowSize);
            }
        }

        // Draw control handles if selected
        if (this.selectedObjects.length === 1 && this.selectedObjects[0] === bezier) {
            ctx.strokeStyle = 'rgba(0,0,0,0.25)';
            ctx.lineWidth = 1;
            ctx.setLineDash([4, 4]);
            // Line from start to control1
            ctx.beginPath();
            ctx.moveTo(p1.x, p1.y);
            ctx.lineTo(pc1.x, pc1.y);
            ctx.stroke();
            // Line from control2 to end
            ctx.beginPath();
            ctx.moveTo(pc2.x, pc2.y);
            ctx.lineTo(p2.x, p2.y);
            ctx.stroke();
            // Line between control points
            ctx.strokeStyle = 'rgba(0,0,0,0.15)';
            ctx.beginPath();
            ctx.moveTo(pc1.x, pc1.y);
            ctx.lineTo(pc2.x, pc2.y);
            ctx.stroke();
            ctx.setLineDash([]);

            // Control point 1 marker
            ctx.strokeStyle = this.getColor(bezier.color);
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(pc1.x, pc1.y, 6, 0, Math.PI * 2);
            ctx.stroke();

            // Control point 2 marker
            ctx.beginPath();
            ctx.arc(pc2.x, pc2.y, 6, 0, Math.PI * 2);
            ctx.stroke();
        }
    },

    drawGrid(grid) {
        const ctx = this.ctx;
        const p1 = this.worldToScreen(grid.xMin, grid.yMax);
        const p2 = this.worldToScreen(grid.xMax, grid.yMin);

        const x = Math.min(p1.x, p2.x);
        const y = Math.min(p1.y, p2.y);
        const w = Math.abs(p2.x - p1.x);
        const h = Math.abs(p2.y - p1.y);

        // Calculate center in screen coordinates
        const cx = x + w / 2;
        const cy = y + h / 2;

        ctx.save();

        // Apply rotation if needed
        if (grid.rotation && grid.rotation !== 0) {
            // Rotate around the grid's center
            ctx.translate(cx, cy);
            ctx.rotate(-(grid.rotation * Math.PI) / 180);
            ctx.translate(-cx, -cy);
        }

        ctx.strokeStyle = this.getColor(grid.color);
        ctx.lineWidth = this.getThickness(grid.thickness);

        const stepScreen = grid.step * this.zoom;

        ctx.beginPath();
        for (let x = grid.xMin; x <= grid.xMax; x += grid.step) {
            const sx = this.worldToScreen(x, 0).x;
            ctx.moveTo(sx, p1.y);
            ctx.lineTo(sx, p2.y);
        }
        for (let y = grid.yMin; y <= grid.yMax; y += grid.step) {
            const sy = this.worldToScreen(0, y).y;
            ctx.moveTo(p1.x, sy);
            ctx.lineTo(p2.x, sy);
        }
        ctx.stroke();

        ctx.restore();
    },

    drawImage(imgObj) {
        const coord = this.getCoordByName(imgObj.at);
        if (!coord) return;

        // Ensure image is loaded into cache
        if (!imgObj.cachedImage && imgObj.imageData) {
            const img = new Image();
            img.onload = () => {
                imgObj.cachedImage = img;
                imgObj.naturalAspect = img.naturalWidth / img.naturalHeight;
                this.render(); // Re-render once loaded
            };
            img.src = imgObj.imageData;
            return; // Skip this frame, will render next time
        }

        if (!imgObj.cachedImage) return;

        const ctx = this.ctx;
        const pos = this.worldToScreen(coord.x, coord.y);

        // Calculate dimensions in screen space
        const width = imgObj.width * this.zoom;
        const height = imgObj.height
            ? imgObj.height * this.zoom
            : width / imgObj.naturalAspect;

        // Calculate anchor offset
        let offsetX = 0, offsetY = 0;
        const anchor = imgObj.anchor || 'center';

        // Horizontal anchor
        if (anchor.includes('east')) offsetX = -width;
        else if (!anchor.includes('west')) offsetX = -width / 2; // center

        // Vertical anchor (note: canvas Y is inverted)
        if (anchor.includes('north')) offsetY = 0;
        else if (anchor.includes('south')) offsetY = -height;
        else offsetY = -height / 2; // center

        // Draw with opacity and rotation
        ctx.save();
        ctx.globalAlpha = imgObj.opacity;

        // Apply rotation if needed
        if (imgObj.rotation && imgObj.rotation !== 0) {
            // Translate to anchor point, rotate, then translate back
            ctx.translate(pos.x, pos.y);
            ctx.rotate((imgObj.rotation * Math.PI) / 180); // Convert degrees to radians
            ctx.translate(-pos.x, -pos.y);
        }

        ctx.drawImage(
            imgObj.cachedImage,
            pos.x + offsetX,
            pos.y + offsetY,
            width,
            height
        );
        ctx.restore();
    },

    drawLabel(node, wx, wy, angle = 0) {
        const ctx = this.ctx;
        const pos = this.worldToScreen(wx, wy);
        const color = this.getColor(node.color || 'black');
        const fontSize = node.fontSize || 'normal';
        const text = node.text ? node.text : node.label;
        const anchor = node.anchor ? node.anchor : (node.position ? node.position : node.labelPosition);

        // Calculate offset based on anchor position
        let offsetX = 0, offsetY = 0;
        const offset = 15;

        if (anchor.includes('above')) offsetY = -offset;
        if (anchor.includes('below')) offsetY = offset;

        // Try to get cached LaTeX render
        const cacheKey = `${text}::${color}::${fontSize}`;
        const cached = this.latexCache.get(cacheKey);

        // Save context for rotation
        ctx.save();

        // Translate to the label position and apply rotation if needed
        if (angle !== 0) {
            ctx.translate(pos.x, pos.y);
            ctx.rotate(angle);
            // Now draw relative to origin (0, 0)
        }

        const drawPosX = angle !== 0 ? 0 : pos.x;
        const drawPosY = angle !== 0 ? 0 : pos.y;

        if (cached && cached.img && cached.img.complete && cached.img.naturalWidth > 0) {
            // Draw rendered LaTeX image
            const drawX = drawPosX + (anchor.includes('right') ? 5 : (anchor.includes('left') ? (- cached.width  * (this.zoom / 50) - 5) : (- cached.width * (this.zoom / 50) / 2)));
            const drawY = drawPosY + offsetY - cached.height * (this.zoom / 50) / 2;

            // Draw contour stroke if present
            if (cached.hasContour && cached.contourColor) {
                const contourColor = this.getColor(cached.contourColor);
                // Work at image resolution (2x) for proper stroke scaling
                const imageScale = cached.img.naturalWidth / cached.width * (this.zoom / 50);
                const strokeWidth = 0.8 * imageScale;

                // Create temporary canvas at image resolution
                const tempCanvas = document.createElement('canvas');
                const imgWidth = cached.img.naturalWidth;
                const imgHeight = cached.img.naturalHeight;
                tempCanvas.width = imgWidth + strokeWidth * 4;
                tempCanvas.height = imgHeight + strokeWidth * 4;
                const tempCtx = tempCanvas.getContext('2d');

                // Draw the image multiple times offset to create stroke effect
                const contourOffset = strokeWidth;
                tempCtx.globalCompositeOperation = 'source-over';

                // Draw stroke in 8 directions
                for (let dx = -contourOffset; dx <= contourOffset; dx++) {
                    for (let dy = -contourOffset; dy <= contourOffset; dy++) {
                        if (dx !== 0 || dy !== 0) {
                            tempCtx.drawImage(cached.img, contourOffset * 2 + dx, contourOffset * 2 + dy);
                        }
                    }
                }

                // Flood fill the stroked area with contour color
                tempCtx.globalCompositeOperation = 'source-in';
                tempCtx.fillStyle = contourColor;
                tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

                // Draw the filled stroke to main canvas (will scale back to display size)
                const displayOffset = contourOffset * 2 / imageScale;
                ctx.drawImage(tempCanvas, drawX - displayOffset, drawY - displayOffset,
                             cached.width + displayOffset * 2, cached.height + displayOffset * 2);
            }

            ctx.drawImage(cached.img, drawX, drawY, cached.width * (this.zoom / 50), cached.height * (this.zoom / 50));
        } else {
            // Queue for rendering and show plain text as fallback
            this.queueLatexRender(text, color, fontSize);

            ctx.fillStyle = color;
            ctx.font = this.getFontSizePixels(fontSize) + ' serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.fillText(text, drawPosX + offsetX, drawPosY + offsetY);
        }

        ctx.restore();
    },

    drawSelectionHighlight(obj) {
        const ctx = this.ctx;
        // Use different color when in move mode
        ctx.strokeStyle = this.isMoving ? '#22c55e' : '#3478f6'; // Green for moving, blue for selected
        ctx.lineWidth = this.isMoving ? 3 : 2;
        ctx.setLineDash([4, 4]);

        if (obj instanceof TikZCoordinate) {
            const pos = this.worldToScreen(obj.x, obj.y);
            ctx.beginPath();
            ctx.arc(pos.x, pos.y, 12, 0, Math.PI * 2);
            ctx.stroke();
        }
        else if (obj instanceof TikZSegment || obj instanceof TikZVector) {
            const from = this.getCoordByName(obj.from);
            const to = this.getCoordByName(obj.to);
            if (from && to) {
                const p1 = this.worldToScreen(from.x, from.y);
                const p2 = this.worldToScreen(to.x, to.y);
                ctx.lineWidth = 6;
                ctx.globalAlpha = 0.3;
                ctx.beginPath();
                ctx.moveTo(p1.x, p1.y);
                ctx.lineTo(p2.x, p2.y);
                ctx.stroke();
                ctx.globalAlpha = 1;
            }
        }
        else if (obj instanceof TikZCircle) {
            const isEllipse = obj.isEllipse(this.getCoordByName.bind(this));
            if (isEllipse) {
                const params = obj.getEllipseParams(this.getCoordByName.bind(this));
                if (params) {
                    const centerPos = this.worldToScreen(params.cx, params.cy);
                    const a = params.a * this.zoom + 4;
                    const b = params.b * this.zoom + 4;
                    ctx.beginPath();
                    ctx.ellipse(centerPos.x, centerPos.y, a, b, -params.rotation, 0, Math.PI * 2);
                    ctx.stroke();
                }
            } else {
                const center = this.getCoordByName(obj.center);
                if (center) {
                    const pos = this.worldToScreen(center.x, center.y);
                    ctx.beginPath();
                    ctx.arc(pos.x, pos.y, obj.radius * this.zoom + 4, 0, Math.PI * 2);
                    ctx.stroke();
                }
            }
        }
        else if (obj instanceof TikZRectangle) {
            const p1 = this.worldToScreen(obj.xMin, obj.yMin);
            const p2 = this.worldToScreen(obj.xMax, obj.yMax);
            const x = Math.min(p1.x, p2.x) - 4;
            const y = Math.min(p1.y, p2.y) - 4;
            const w = Math.abs(p2.x - p1.x) + 8;
            const h = Math.abs(p2.y - p1.y) + 8;

            // Calculate center in screen coordinates
            const cx = x + w / 2;
            const cy = y + h / 2;

            ctx.save();

            // Apply rotation if needed
            if (obj.rotation && obj.rotation !== 0) {
                // Rotate around the rectangle's center
                ctx.translate(cx, cy);
                ctx.rotate(-(obj.rotation * Math.PI) / 180);
                ctx.translate(-cx, -cy);
            }

            ctx.beginPath();
            ctx.rect(x, y, w, h);
            ctx.stroke();
            ctx.restore();
        }
        else if (obj instanceof TikZArc) {
            const center = this.getCoordByName(obj.center);
            if (center) {
                const pos = this.worldToScreen(center.x, center.y);
                const radius = obj.radius * this.zoom + 4;
                const startRad = -obj.startAngle * Math.PI / 180;
                const endRad = -obj.endAngle * Math.PI / 180;
                ctx.beginPath();
                ctx.arc(pos.x, pos.y, radius, startRad, endRad, true);
                ctx.stroke();
            }
        }
        else if (obj instanceof TikZPath) {
            const coords = obj.points.map(p => this.getCoordByName(p)).filter(c => c);
            if (coords.length >= 2) {
                const screenPoints = coords.map(c => this.worldToScreen(c.x, c.y));
                ctx.beginPath();
                ctx.moveTo(screenPoints[0].x, screenPoints[0].y);
                for (let i = 1; i < screenPoints.length; i++) {
                    ctx.lineTo(screenPoints[i].x, screenPoints[i].y);
                }
                if (obj.closed) {
                    ctx.closePath();
                }
                ctx.stroke();
            }
        }
        else if (obj instanceof TikZBezier) {
            const from = this.getCoordByName(obj.from);
            const ctrl1 = this.getCoordByName(obj.control1);
            const ctrl2 = this.getCoordByName(obj.control2);
            const to = this.getCoordByName(obj.to);
            if (from && ctrl1 && ctrl2 && to) {
                const p1 = this.worldToScreen(from.x, from.y);
                const pc1 = this.worldToScreen(ctrl1.x, ctrl1.y);
                const pc2 = this.worldToScreen(ctrl2.x, ctrl2.y);
                const p2 = this.worldToScreen(to.x, to.y);
                ctx.beginPath();
                ctx.moveTo(p1.x, p1.y);
                ctx.bezierCurveTo(pc1.x, pc1.y, pc2.x, pc2.y, p2.x, p2.y);
                ctx.stroke();
            }
        }
        else if (obj instanceof TikZLabel) {
            const coord = this.getCoordByName(obj.at);
            if (coord) {
                const pos = this.worldToScreen(coord.x, coord.y);
                ctx.beginPath();
                ctx.arc(pos.x, pos.y, 12, 0, Math.PI * 2);
                ctx.stroke();
            }
        }
        else if (obj instanceof TikZImage) {
            const coord = this.getCoordByName(obj.at);
            if (coord) {
                const pos = this.worldToScreen(coord.x, coord.y);
                const width = obj.width * this.zoom;
                const height = obj.height ? obj.height * this.zoom : width / obj.naturalAspect;
                const anchor = obj.anchor || 'center';

                // Calculate offset based on anchor
                let offsetX = 0, offsetY = 0;
                if (anchor.includes('east')) offsetX = -width;
                else if (!anchor.includes('west')) offsetX = -width / 2;

                if (anchor.includes('north')) offsetY = 0;
                else if (anchor.includes('south')) offsetY = -height;
                else offsetY = -height / 2;

                ctx.save();

                // Apply rotation if needed
                if (obj.rotation && obj.rotation !== 0) {
                    // Translate to anchor point, rotate, then translate back
                    ctx.translate(pos.x, pos.y);
                    ctx.rotate((obj.rotation * Math.PI) / 180); // Convert degrees to radians
                    ctx.translate(-pos.x, -pos.y);
                }

                // Draw dashed rectangle around image
                ctx.beginPath();
                ctx.rect(pos.x + offsetX - 4, pos.y + offsetY - 4, width + 8, height + 8);
                ctx.stroke();
                ctx.restore();
            }
        }
        else if (obj instanceof TikZGrid) {
            const p1 = this.worldToScreen(obj.xMin, obj.yMin);
            const p2 = this.worldToScreen(obj.xMax, obj.yMax);
            const x = Math.min(p1.x, p2.x) - 4;
            const y = Math.min(p1.y, p2.y) - 4;
            const w = Math.abs(p2.x - p1.x) + 8;
            const h = Math.abs(p2.y - p1.y) + 8;

            // Calculate center in screen coordinates
            const cx = x + w / 2;
            const cy = y + h / 2;

            ctx.save();

            // Apply rotation if needed
            if (obj.rotation && obj.rotation !== 0) {
                // Rotate around the rectangle's center
                ctx.translate(cx, cy);
                ctx.rotate(-(obj.rotation * Math.PI) / 180);
                ctx.translate(-cx, -cy);
            }

            ctx.beginPath();
            ctx.rect(x, y, w, h);
            ctx.stroke();
            ctx.restore();
        }

        ctx.setLineDash([]);
    },

    drawSelectionBox(start, end) {
        const ctx = this.ctx;
        const p1 = this.worldToScreen(start.x, start.y);
        const p2 = this.worldToScreen(end.x, end.y);

        const minX = Math.min(p1.x, p2.x);
        const minY = Math.min(p1.y, p2.y);
        const width = Math.abs(p2.x - p1.x);
        const height = Math.abs(p2.y - p1.y);

        // Draw semi-transparent fill
        ctx.fillStyle = 'rgba(52, 120, 246, 0.08)';
        ctx.fillRect(minX, minY, width, height);

        // Draw dashed border
        ctx.strokeStyle = '#3478f6';
        ctx.lineWidth = 2;
        ctx.setLineDash([4, 4]);
        ctx.strokeRect(minX, minY, width, height);
        ctx.setLineDash([]);
    },

    drawRotationFeedback() {
        // Draw visual feedback during rotation: center point, arc, angle display, guide lines
        const ctx = this.ctx;
        const centerPos = this.worldToScreen(this.rotateCenter.x, this.rotateCenter.y);

        // Get current mouse position
        const rect = this.canvas.getBoundingClientRect();
        const mouseX = this.lastMouseX || rect.width / 2;
        const mouseY = this.lastMouseY || rect.height / 2;
        const world = this.screenToWorld(mouseX, mouseY);

        // Calculate current angle
        const dx = world.x - this.rotateCenter.x;
        const dy = world.y - this.rotateCenter.y;
        this.rotateCurrentAngle = Math.atan2(dy, dx) * 180 / Math.PI;

        // Calculate rotation angle
        let rotationAngle = this.rotateCurrentAngle - this.rotateStartAngle;

        // Normalize to [-180, 180]
        while (rotationAngle > 180) rotationAngle -= 360;
        while (rotationAngle < -180) rotationAngle += 360;

        // Apply snapping for display (matches actual rotation)
        const displayAngle = this.snapAngle(rotationAngle, (this.ctrlKey ? 1 : 5));

        // Draw center point
        ctx.fillStyle = '#f59e0b';
        ctx.beginPath();
        ctx.arc(centerPos.x, centerPos.y, 5, 0, Math.PI * 2);
        ctx.fill();

        // Draw circle at a reasonable radius
        const radius = 60; // pixels

        // Draw guide line from center to start angle
        const startAngleRad = -this.rotateStartAngle * Math.PI / 180;
        ctx.strokeStyle = '#22c55e';
        ctx.lineWidth = 2;
        ctx.setLineDash([4, 4]);
        ctx.beginPath();
        ctx.moveTo(centerPos.x, centerPos.y);
        ctx.lineTo(
            centerPos.x + radius * Math.cos(startAngleRad),
            centerPos.y + radius * Math.sin(startAngleRad)
        );
        ctx.stroke();

        // Draw guide line from center to current angle
        const currentAngleRad = -this.rotateCurrentAngle * Math.PI / 180;
        ctx.strokeStyle = '#3478f6';
        ctx.beginPath();
        ctx.moveTo(centerPos.x, centerPos.y);
        ctx.lineTo(
            centerPos.x + radius * Math.cos(currentAngleRad),
            centerPos.y + radius * Math.sin(currentAngleRad)
        );
        ctx.stroke();

        // Draw arc showing rotation angle
        ctx.strokeStyle = '#f59e0b';
        ctx.lineWidth = 3;
        ctx.setLineDash([]);
        ctx.beginPath();
        ctx.arc(centerPos.x, centerPos.y, radius * 0.7, startAngleRad, currentAngleRad, rotationAngle < 0);
        ctx.stroke();

        // Display rotation angle near center
        ctx.save();
        // ctx.fillStyle = '#f59e0b';
        ctx.fillStyle = '#000';
        ctx.font = 'bold 16px sans-serif';
        const angleText = `${displayAngle.toFixed(1)}°`;
        ctx.fillText(angleText, centerPos.x + 15, centerPos.y - 15);
        ctx.restore();

        ctx.setLineDash([]);
    },

    selectObjectsInBox(start, end) {
        const minX = Math.min(start.x, end.x);
        const maxX = Math.max(start.x, end.x);
        const minY = Math.min(start.y, end.y);
        const maxY = Math.max(start.y, end.y);

        // Clear existing selection (Option A behavior)
        this.selectedObjects = [];

        // Select all objects that are inside or intersect the box (skip locked objects)
        for (const obj of this.objects) {
            if (!obj.locked && this.isObjectInBox(obj, minX, maxX, minY, maxY)) {
                this.selectedObjects.push(obj);
            }
        }
    },

    isObjectInBox(obj, minX, maxX, minY, maxY) {
        // Check if object is inside the selection box
        if (obj instanceof TikZCoordinate) {
            return obj.x >= minX && obj.x <= maxX && obj.y >= minY && obj.y <= maxY;
        }
        else if (obj instanceof TikZSegment || obj instanceof TikZVector) {
            const from = this.getCoordByName(obj.from);
            const to = this.getCoordByName(obj.to);
            if (from && to) {
                // Select if either endpoint is in box
                return (from.x >= minX && from.x <= maxX && from.y >= minY && from.y <= maxY) ||
                       (to.x >= minX && to.x <= maxX && to.y >= minY && to.y <= maxY);
            }
        }
        else if (obj instanceof TikZCircle) {
            const isEllipse = obj.isEllipse(this.getCoordByName.bind(this));
            if (isEllipse) {
                // For ellipse, select if the ellipse center (midpoint of foci) is in box
                const params = obj.getEllipseParams(this.getCoordByName.bind(this));
                if (params) {
                    return params.cx >= minX && params.cx <= maxX && params.cy >= minY && params.cy <= maxY;
                }
            } else {
                const center = this.getCoordByName(obj.center);
                if (center) {
                    // Select if center is in box
                    return center.x >= minX && center.x <= maxX && center.y >= minY && center.y <= maxY;
                }
            }
        }
        else if (obj instanceof TikZRectangle) {
            return (obj.xMin >= minX && obj.xMin <= maxX && obj.yMin >= minY && obj.yMin <= maxY) &&
                   (obj.xMax >= minX && obj.xMax <= maxX && obj.yMax >= minY && obj.yMax <= maxY);
        }
        else if (obj instanceof TikZPath) {
            // Select if any point is in box
            for (const pointName of obj.points) {
                const coord = this.getCoordByName(pointName);
                if (coord && coord.x >= minX && coord.x <= maxX && coord.y >= minY && coord.y <= maxY) {
                    return true;
                }
            }
        }
        else if (obj instanceof TikZArc) {
            const center = this.getCoordByName(obj.center);
            if (center) {
                return center.x >= minX && center.x <= maxX && center.y >= minY && center.y <= maxY;
            }
        }
        else if (obj instanceof TikZBezier) {
            const from = this.getCoordByName(obj.from);
            const to = this.getCoordByName(obj.to);
            if (from && to) {
                return (from.x >= minX && from.x <= maxX && from.y >= minY && from.y <= maxY) ||
                       (to.x >= minX && to.x <= maxX && to.y >= minY && to.y <= maxY);
            }
        }
        else if (obj instanceof TikZLabel) {
            const at = this.getCoordByName(obj.at);
            if (at) {
                return at.x >= minX && at.x <= maxX && at.y >= minY && at.y <= maxY;
            }
        }
        else if (obj instanceof TikZImage) {
            const at = this.getCoordByName(obj.at);
            if (at) {
                return at.x >= minX && at.x <= maxX && at.y >= minY && at.y <= maxY;
            }
        }
        else if (obj instanceof TikZGrid) {
            return (obj.xMin >= minX && obj.xMin <= maxX && obj.yMin >= minY && obj.yMin <= maxY) &&
                   (obj.xMax >= minX && obj.xMax <= maxX && obj.yMax >= minY && obj.yMax <= maxY);
        }
        return false;
    },

    drawTempGeometry(snapped) {
        const ctx = this.ctx;
        ctx.strokeStyle = '#3478f6';
        ctx.fillStyle = '#3478f6';
        ctx.lineWidth = 2;
        ctx.setLineDash([4, 4]);

        if (this.currentTool === 'line' || this.currentTool === 'vector') {
            if (this.tempPoints.length === 1) {
                const from = this.getCoordByName(this.tempPoints[0]);
                if (from) {
                    const p1 = this.worldToScreen(from.x, from.y);
                    const p2 = this.worldToScreen(snapped.x, snapped.y);
                    ctx.beginPath();
                    ctx.moveTo(p1.x, p1.y);
                    ctx.lineTo(p2.x, p2.y);
                    ctx.stroke();
                }
            }
        }
        else if (this.currentTool === 'circle') {
            if (this.tempPoints.length === 1) {
                const center = this.tempPoints[0];
                const pos = this.worldToScreen(center.x, center.y);
                const radius = Math.hypot(snapped.x - center.x, snapped.y - center.y) * this.zoom;
                ctx.beginPath();
                ctx.arc(pos.x, pos.y, radius, 0, Math.PI * 2);
                ctx.stroke();
            }
        }
        else if (this.currentTool === 'arc') {
            if (this.tempPoints.length >= 1) {
                const center = this.tempPoints[0];
                const pos = this.worldToScreen(center.x, center.y);

                if (this.tempPoints.length === 1) {
                    // Drawing radius/start angle
                    const radius = Math.hypot(snapped.x - center.x, snapped.y - center.y) * this.zoom;
                    const startAngle = Math.atan2(snapped.y - center.y, snapped.x - center.x) * 180 / Math.PI;

                    ctx.beginPath();
                    ctx.arc(pos.x, pos.y, radius, 0, Math.PI * 2);
                    ctx.stroke();

                    // Display start angle near cursor
                    const cursorPos = this.worldToScreen(snapped.x, snapped.y);
                    ctx.save();
                    ctx.fillStyle = '#3478f6';
                    ctx.font = 'bold 14px sans-serif';
                    ctx.fillText(`${startAngle.toFixed(1)}°`, cursorPos.x + 15, cursorPos.y - 10);
                    ctx.restore();
                } else {
                    // Drawing end angle
                    const { radius, startAngle } = this.tempPoints[1];
                    const endAngle = Math.atan2(snapped.y - center.y, snapped.x - center.x) * 180 / Math.PI;
                    const r = radius * this.zoom;

                    // Calculate swept angle
                    let sweptAngle = endAngle - startAngle;
                    // Normalize to [0, 360]
                    while (sweptAngle < 0) sweptAngle += 360;
                    while (sweptAngle > 360) sweptAngle -= 360;

                    ctx.beginPath();
                    ctx.arc(pos.x, pos.y, r, -startAngle * Math.PI / 180, -endAngle * Math.PI / 180, true);
                    ctx.stroke();

                    // Display angles near cursor
                    const cursorPos = this.worldToScreen(snapped.x, snapped.y);
                    ctx.save();
                    ctx.fillStyle = '#3478f6';
                    ctx.font = 'bold 14px sans-serif';
                    ctx.fillText(`${endAngle.toFixed(1)}°`, cursorPos.x + 15, cursorPos.y - 25);
                    ctx.fillStyle = '#22c55e';
                    ctx.fillText(`Δ ${sweptAngle.toFixed(1)}°`, cursorPos.x + 15, cursorPos.y - 10);
                    ctx.restore();
                }
            }
        }
        else if (this.currentTool === 'rect') {
            if (this.tempPoints.length === 1) {
                const p1 = this.worldToScreen(this.tempPoints[0].x, this.tempPoints[0].y);
                const p2 = this.worldToScreen(snapped.x, snapped.y);
                ctx.strokeRect(
                    Math.min(p1.x, p2.x), Math.min(p1.y, p2.y),
                    Math.abs(p2.x - p1.x), Math.abs(p2.y - p1.y)
                );
            }
        }
        else if (this.currentTool === 'path') {
            if (this.tempPoints.length >= 1) {
                ctx.beginPath();
                for (let i = 0; i < this.tempPoints.length; i++) {
                    const coord = this.getCoordByName(this.tempPoints[i]);
                    if (coord) {
                        const p = this.worldToScreen(coord.x, coord.y);
                        if (i === 0) ctx.moveTo(p.x, p.y);
                        else ctx.lineTo(p.x, p.y);
                    }
                }
                const p = this.worldToScreen(snapped.x, snapped.y);
                ctx.lineTo(p.x, p.y);
                ctx.stroke();
            }
        }
        else if (this.currentTool === 'bezier') {
            if (this.tempPoints.length === 1) {
                // Drawing line from start to end point preview
                const from = this.getCoordByName(this.tempPoints[0]);
                if (from) {
                    const p1 = this.worldToScreen(from.x, from.y);
                    const p2 = this.worldToScreen(snapped.x, snapped.y);
                    ctx.beginPath();
                    ctx.moveTo(p1.x, p1.y);
                    ctx.lineTo(p2.x, p2.y);
                    ctx.stroke();
                }
            }
        }
        else if (this.currentTool === 'grid') {
            if (this.tempPoints.length === 1) {
                const p1 = this.worldToScreen(this.tempPoints[0].x, this.tempPoints[0].y);
                const p2 = this.worldToScreen(snapped.x, snapped.y);
                ctx.strokeRect(
                    Math.min(p1.x, p2.x), Math.min(p1.y, p2.y),
                    Math.abs(p2.x - p1.x), Math.abs(p2.y - p1.y)
                );
            }
        }

        ctx.setLineDash([]);
    }

});
