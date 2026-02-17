// ============================================================================
// TikZ Draw - Object Model Classes
// ============================================================================

class TikZObject {
    constructor(type) {
        this.id = generateId(type);
        this.type = type;
        this.visible = true;
        this.expanded = false;
        this.locked = false;
    }

    toTikZ() { return ''; }
    getSubObjects() { return []; }
    getBounds() { return null; }
}

class TikZCoordinate extends TikZObject {
    constructor(x, y, name = null) {
        super('coord');
        this.x = x;
        this.y = y;
        this.name = name || this.id.replace('coord_', 'P');
        this.showPoint = false;
        this.pointSize = 2;
        this.color = 'black';
        this.label = '';
        this.anchor = 'above right';
    }

    toTikZ() {
        let code = `  \\coordinate (${this.name}) at (${this.x.toFixed(2)}, ${this.y.toFixed(2)});`;
        return code;
    }

    toTikZPoint() {
        if (!this.showPoint) return '';
        return `  \\fill[${this.color}] (${this.name}) circle (${this.pointSize}pt);`;
    }

    toTikZLabel() {
        if (!this.label) return '';
        return `  \\node[${this.anchor}, ${this.color}] at (${this.name}) {${this.label}};`;
    }

    getBounds() {
        return { x: this.x, y: this.y, width: 0, height: 0 };
    }
}

class TikZSegment extends TikZObject {
    constructor(fromCoord, toCoord) {
        super('line');
        this.from = fromCoord;
        this.to = toCoord;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.arrowEnd = 'none';
        this.arrowSize = 1.0;
        this.nodes = [];
        this.name = this.id.replace('line_', 'L');
    }

    toTikZ() {
        let opts = [];

        if (this.arrowEnd && this.arrowEnd !== 'none') {
            opts.push(this.arrowEnd);
            if (this.arrowSize !== 1.0) {
                const arrowType = this.arrowEnd.includes('latex') ? 'latex' : 'Stealth';
                opts.push(`>={${arrowType}[scale=${this.arrowSize}]}`);
            }
        }

        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle !== 'solid') opts.push(this.lineStyle);

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';
        let nodeStr = this.nodes.map(n => n.toTikZ()).join(' ');

        return `  \\draw${optStr} (${this.from}) --${nodeStr} (${this.to});`;
    }

    getSubObjects() {
        return [
            { type: 'ref', label: `(${this.from})`, ref: this.from },
            { type: 'segment', label: 'segment', parent: this },
            ...this.nodes.map(n => ({ type: 'node', label: `"${n.text}"`, node: n, parent: this })),
            { type: 'ref', label: `(${this.to})`, ref: this.to }
        ];
    }
}

class TikZVector extends TikZObject {
    constructor(fromCoord, toCoord) {
        super('vec');
        this.from = fromCoord;
        this.to = toCoord;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.arrowType = 'Stealth';
        this.arrowEnd = '-Stealth';
        this.arrowSize = 1.0;
        this.nodes = [];
        this.name = this.id.replace('vec_', 'V');
    }

    toTikZ() {
        let opts = [];

        opts.push(this.arrowEnd);

        if (this.arrowSize !== 1.0) {
            opts.push(`>={${this.arrowType}[scale=${this.arrowSize}]}`);
        }

        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle !== 'solid') opts.push(this.lineStyle);

        let optStr = `[${opts.join(', ')}]`;
        let nodeStr = this.nodes.map(n => n.toTikZ()).join(' ');

        return `  \\draw${optStr} (${this.from}) --${nodeStr} (${this.to});`;
    }

    getSubObjects() {
        return [
            { type: 'ref', label: `(${this.from})`, ref: this.from },
            { type: 'segment', label: 'vector', parent: this },
            ...this.nodes.map(n => ({ type: 'node', label: `"${n.text}"`, node: n, parent: this })),
            { type: 'ref', label: `(${this.to})`, ref: this.to }
        ];
    }
}

class TikZCircle extends TikZObject {
    constructor(centerCoord, radius, center2Coord = null) {
        super('circle');
        this.center = centerCoord;
        this.center2 = center2Coord || centerCoord;
        this.radius = radius;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.fill = 'none';
        this.fillOpacity = 1.0;
        this.pattern = 'none';
        this.name = this.id.replace('circle_', 'C');
    }

    isEllipse(getCoordByName) {
        if (this.center === this.center2) return false;
        const c1 = getCoordByName(this.center);
        const c2 = getCoordByName(this.center2);
        if (!c1 || !c2) return false;
        const dist = Math.hypot(c2.x - c1.x, c2.y - c1.y);
        return dist > 0.001;
    }

    getEllipseParams(getCoordByName) {
        const c1 = getCoordByName(this.center);
        const c2 = getCoordByName(this.center2);
        if (!c1 || !c2) return null;

        const fociDist = Math.hypot(c2.x - c1.x, c2.y - c1.y);
        const c = fociDist / 2;
        const a = this.radius;
        const b = c >= a ? 0.1 : Math.sqrt(a * a - c * c);
        const cx = (c1.x + c2.x) / 2;
        const cy = (c1.y + c2.y) / 2;
        const rotation = Math.atan2(c2.y - c1.y, c2.x - c1.x);

        return { cx, cy, a, b, rotation, c };
    }

    toTikZ() {
        let opts = [];
        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle === 'dashed') opts.push('dashed');
        if (this.lineStyle === 'dotted') opts.push('dotted');

        let cmd = '\\draw';
        if (this.fill !== undefined && this.fill !== 'none') {
            if (this.pattern && this.pattern !== 'none') {
                opts.push(`pattern color=${this.fill}`);
            } else {
                opts.push(`fill=${this.fill}`);
            }
            if (this.fillOpacity < 1) opts.push(`fill opacity=${this.fillOpacity}`);
        }

        if (this.pattern && this.pattern !== 'none') {
            opts.push(`pattern=${this.pattern}`);
        }

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        if (this.center === this.center2) {
            return `  ${cmd}${optStr} (${this.center}) circle (${this.radius.toFixed(2)});`;
        }

        return `  % Ellipse with foci at (${this.center}) and (${this.center2}), a=${this.radius.toFixed(2)}\n  ${cmd}${optStr} (${this.center}) circle (${this.radius.toFixed(2)}); % TODO: Use ellipse syntax`;
    }

    toTikZWithCoords(getCoordByName) {
        let opts = [];
        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle === 'dashed') opts.push('dashed');
        if (this.lineStyle === 'dotted') opts.push('dotted');

        let cmd = '\\draw';
        if (this.fill !== undefined && this.fill !== 'none') {
            if (this.pattern && this.pattern !== 'none') {
                opts.push(`pattern color=${this.fill}`);
            } else {
                opts.push(`fill=${this.fill}`);
            }
            if (this.fillOpacity < 1) opts.push(`fill opacity=${this.fillOpacity}`);
        }

        if (this.pattern && this.pattern !== 'none') {
            opts.push(`pattern=${this.pattern}`);
        }

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        if (!this.isEllipse(getCoordByName)) {
            return `  ${cmd}${optStr} (${this.center}) circle (${this.radius.toFixed(2)});`;
        }

        const params = this.getEllipseParams(getCoordByName);
        if (!params) {
            return `  ${cmd}${optStr} (${this.center}) circle (${this.radius.toFixed(2)});`;
        }

        const rotationDeg = params.rotation * 180 / Math.PI;
        if (Math.abs(rotationDeg) > 0.1) {
            opts.push(`rotate=${rotationDeg.toFixed(1)}`);
            optStr = opts.length ? `[${opts.join(', ')}]` : '';
        }

        return `  ${cmd}${optStr} (${params.cx.toFixed(2)}, ${params.cy.toFixed(2)}) ellipse (${params.a.toFixed(2)} and ${params.b.toFixed(2)});`;
    }
}

class TikZArc extends TikZObject {
    constructor(centerCoord, radius, startAngle, endAngle) {
        super('arc');
        this.center = centerCoord;
        this.radius = radius;
        this.startAngle = startAngle;
        this.endAngle = endAngle;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.arrowEnd = 'none';
        this.arrowSize = 1.0;
        this.name = this.id.replace('arc_', 'A');
    }

    toTikZ() {
        let opts = [];

        if (this.arrowEnd && this.arrowEnd !== 'none') {
            opts.push(this.arrowEnd);
            if (this.arrowSize !== 1.0) {
                const arrowType = this.arrowEnd.includes('latex') ? 'latex' : 'Stealth';
                opts.push(`>={${arrowType}[scale=${this.arrowSize}]}`);
            }
        }

        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle === 'dashed') opts.push('dashed');
        if (this.lineStyle === 'dotted') opts.push('dotted');

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        const startX = parseFloat(app.getCoordByName(this.center)?.x || 0) + this.radius * Math.cos(this.startAngle * Math.PI / 180);
        const startY = parseFloat(app.getCoordByName(this.center)?.y || 0) + this.radius * Math.sin(this.startAngle * Math.PI / 180);

        return `  \\draw${optStr} (${startX.toFixed(2)}, ${startY.toFixed(2)}) arc (${this.startAngle.toFixed(1)}:${this.endAngle.toFixed(1)}:${this.radius.toFixed(2)});`;
    }
}

class TikZRectangle extends TikZObject {
    constructor(xMin, yMin, xMax, yMax) {
        super('rect');
        this.xMin = xMin;
        this.yMin = yMin;
        this.xMax = xMax;
        this.yMax = yMax;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.fill = 'none';
        this.fillOpacity = 1.0;
        this.pattern = 'none';
        this.rotation = 0;
        this.name = this.id.replace('rect_', 'R');
    }

    toTikZ() {
        let opts = [];
        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle === 'dashed') opts.push('dashed');
        if (this.lineStyle === 'dotted') opts.push('dotted');
        if (this.rotation !== 0) {
            const cx = ((this.xMin + this.xMax) / 2).toFixed(2);
            const cy = ((this.yMin + this.yMax) / 2).toFixed(2);
            opts.push(`rotate around=\{${this.rotation.toFixed(1)}:(${cx},${cy})\}`);
        }

        let cmd = '\\draw';
        if (this.fill !== undefined && this.fill !== 'none') {
            if (this.pattern && this.pattern !== 'none') {
                opts.push(`pattern color=${this.fill}`);
            } else {
                opts.push(`fill=${this.fill}`);
            }
            if (this.fillOpacity < 1) opts.push(`fill opacity=${this.fillOpacity}`);
        }

        if (this.pattern && this.pattern !== 'none') {
            opts.push(`pattern=${this.pattern}`);
        }

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';
        return `  ${cmd}${optStr} (${this.xMin},${this.yMin}) rectangle (${this.xMax},${this.yMax});`;
    }
}

class TikZPath extends TikZObject {
    constructor(coords) {
        super('path');
        this.points = coords;
        this.closed = false;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.fill = 'none';
        this.fillOpacity = 1.0;
        this.pattern = 'none';
        this.nodes = [];
        this.name = this.id.replace('path_', 'P');
    }

    toTikZ() {
        let opts = [];
        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle === 'dashed') opts.push('dashed');
        if (this.lineStyle === 'dotted') opts.push('dotted');

        let cmd = '\\draw';
        if (this.fill !== undefined && this.fill !== 'none') {
            cmd = '\\filldraw';
            if (this.pattern && this.pattern !== 'none') {
                opts.push(`pattern color=${this.fill}`);
            } else {
                opts.push(`fill=${this.fill}`);
            }
            if (this.fillOpacity < 1) opts.push(`fill opacity=${this.fillOpacity}`);
        }

        if (this.pattern && this.pattern !== 'none') {
            opts.push(`pattern=${this.pattern}`);
        }

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        let pathParts = [];
        for (let i = 0; i < this.points.length; i++) {
            pathParts.push(`(${this.points[i]})`);

            if (i < this.points.length - 1) {
                pathParts.push('--');
                const segmentNodes = this.nodes.filter(n => n.segmentIndex === i);
                segmentNodes.forEach(node => {
                    pathParts.push(node.toTikZ());
                });
            }
        }

        if (this.closed) {
            pathParts.push('--');
            const closingNodes = this.nodes.filter(n => n.segmentIndex === this.points.length - 1);
            closingNodes.forEach(node => {
                pathParts.push(node.toTikZ());
            });
            pathParts.push('cycle');
        }

        let pathStr = pathParts.join(' ');

        return `  ${cmd}${optStr} ${pathStr};`;
    }

    getSubObjects() {
        let subs = [];
        this.points.forEach((p, i) => {
            subs.push({ type: 'ref', label: `(${p})`, ref: p });
            if (i < this.points.length - 1) {
                subs.push({ type: 'segment', label: `segment ${i+1}`, parent: this });
                const segmentNodes = this.nodes.filter(n => n.segmentIndex === i);
                segmentNodes.forEach(n => {
                    subs.push({ type: 'node', label: `"${n.text}"`, node: n, parent: this });
                });
            }
        });
        if (this.closed) {
            const closingIndex = this.points.length - 1;
            subs.push({ type: 'segment', label: 'closing segment', parent: this });
            const closingNodes = this.nodes.filter(n => n.segmentIndex === closingIndex);
            closingNodes.forEach(n => {
                subs.push({ type: 'node', label: `"${n.text}"`, node: n, parent: this });
            });
        }
        return subs;
    }
}

class TikZBezier extends TikZObject {
    constructor(fromCoord, control1Coord, control2Coord, toCoord) {
        super('bezier');
        this.from = fromCoord;
        this.control1 = control1Coord;
        this.control2 = control2Coord;
        this.to = toCoord;
        this.color = 'black';
        this.thickness = 'thin';
        this.lineStyle = 'solid';
        this.arrowEnd = 'none';
        this.arrowSize = 1.0;
        this.name = this.id.replace('bezier_', 'B');
    }

    toTikZ() {
        let opts = [];

        if (this.arrowEnd && this.arrowEnd !== 'none') {
            opts.push(this.arrowEnd);
            if (this.arrowSize !== 1.0) {
                const arrowType = this.arrowEnd.includes('latex') ? 'latex' : 'Stealth';
                opts.push(`>={${arrowType}[scale=${this.arrowSize}]}`);
            }
        }

        if (this.color !== 'black') opts.push(this.color);
        if (this.thickness !== 'thin') opts.push(this.thickness);
        if (this.lineStyle !== 'solid') opts.push(this.lineStyle);

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        const ctrl1 = app.getCoordByName(this.control1);
        const ctrl2 = app.getCoordByName(this.control2);
        if (ctrl1 && ctrl2) {
            const c1x = ctrl1.x.toFixed(2);
            const c1y = ctrl1.y.toFixed(2);
            const c2x = ctrl2.x.toFixed(2);
            const c2y = ctrl2.y.toFixed(2);
            return `  \\draw${optStr} (${this.from}) .. controls (${c1x}, ${c1y}) and (${c2x}, ${c2y}) .. (${this.to});`;
        }
        return `  \\draw${optStr} (${this.from}) -- (${this.to});`;
    }

    getSubObjects() {
        return [
            { type: 'ref', label: `(${this.from})`, ref: this.from },
            { type: 'control', label: `◇1 (${this.control1})`, ref: this.control1, parent: this, controlIndex: 1 },
            { type: 'control', label: `◇2 (${this.control2})`, ref: this.control2, parent: this, controlIndex: 2 },
            { type: 'ref', label: `(${this.to})`, ref: this.to }
        ];
    }
}

class TikZLabel extends TikZObject {
    constructor(atCoord, text) {
        super('label');
        this.at = atCoord;
        this.text = text;
        this.position = 'above';
        this.distance = 0;
        this.fontSize = 'normal';
        this.name = this.id.replace('label_', 'T');
        this.color = 'black';
        this.rotation = 0;
    }

    toTikZ() {
        let opts = [this.position];
        if (this.color !== 'black') opts.push(`text=${this.color}`);
        if (this.fontSize !== 'normal') opts.push(`font=\\${this.fontSize}`);
        if (this.distance > 0) opts[0] = `${this.position}=${this.distance}pt`;
        if (this.rotation !== 0) opts.push(`rotate=-${this.rotation}`);

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';
        return `  \\node${optStr} at (${this.at}) {${this.text}};`;
    }
}

class TikZImage extends TikZObject {
    constructor(atCoord, imageData, filename, mimeType) {
        super('image');
        this.at = atCoord;
        this.imageData = imageData;
        this.filename = filename;
        this.mimeType = mimeType;
        this.width = 4.0;
        this.height = null;
        this.opacity = 1.0;
        this.anchor = 'center';
        this.rotation = 0;
        this.name = this.id.replace('image_', 'I');

        this.cachedImage = null;
        this.naturalAspect = 1.0;
    }

    toTikZ() {
        let opts = [];

        if (this.opacity < 1.0) {
            opts.push(`opacity=${this.opacity}`);
        }

        let optStr = opts.length ? `[${opts.join(', ')}]` : '';

        const heightStr = this.height
            ? `height=${this.height.toFixed(2)}cm`
            : '';
        const widthStr = `width=${this.width.toFixed(2)}cm`;
        let graphicsOpts = heightStr ? `${widthStr},${heightStr}` : widthStr;

        if (this.rotation !== 0) {
            graphicsOpts += `,angle=-${this.rotation.toFixed(1)}`;
        }

        return `  \\node${optStr} at (${this.at}.${this.anchor}) {\\includegraphics[${graphicsOpts}]{${this.filename}}};`;
    }

    getBounds() {
        const coord = app.getCoordByName(this.at);
        if (!coord) return null;

        const h = this.height || (this.width / this.naturalAspect);
        return { x: coord.x, y: coord.y, width: this.width, height: h };
    }
}

class TikZEmbeddedNode {
    constructor(text, position = 0.5, anchor = 'above') {
        this.text = text;
        this.position = position;
        this.anchor = anchor;
        this.fontSize = 'normal';
        this.color = '';
        this.sloped = false;
        this.rotation = 0;
    }

    toTikZ() {
        let opts = [this.anchor];
        if (this.sloped) opts.push('sloped');
        if (this.fontSize !== 'normal') opts.push(`font=\\${this.fontSize}`);
        if (this.color !== '') opts.push(`text=${this.color}`);
        if (!this.sloped && this.rotation !== 0) opts.push(`rotate=${-this.rotation}`);

        let posStr = '';
        if (this.position === 0.5) posStr = 'midway';
        else if (this.position === 0) posStr = 'at start';
        else if (this.position === 1) posStr = 'at end';
        else posStr = `pos=${this.position}`;
        opts.push(posStr);

        return ` node[${opts.join(', ')}] {${this.text}}`;
    }
}

class TikZGrid extends TikZObject {
    constructor(xMin, yMin, xMax, yMax) {
        super('grid');
        this.xMin = xMin;
        this.yMin = yMin;
        this.xMax = xMax;
        this.yMax = yMax;
        this.step = 1.0;
        this.color = 'lightgray';
        this.thickness = 'very thin';
        this.rotation = 0;
        this.name = this.id.replace('grid_', 'G');
    }

    toTikZ() {
        let opts = [];

        if (this.rotation !== 0) {
            const cx = ((this.xMin + this.xMax) / 2).toFixed(2);
            const cy = ((this.yMin + this.yMax) / 2).toFixed(2);
            opts.push(`, rotate around=\{${this.rotation.toFixed(1)}:(${cx},${cy})\}`);
        }

        return `  \\draw[step=${this.step}, ${this.color}, ${this.thickness}${opts.join(', ')}] (${this.xMin}, ${this.yMin}) grid (${this.xMax}, ${this.yMax});`;
    }
}
