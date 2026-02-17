// ============================================================================
// TikZ Draw - Panels (Properties, Object List, Color Picker, Toast)
// ============================================================================

Object.assign(TikZDrawApp.prototype, {

    // ========================================================================
    // Properties Panel
    // ========================================================================

    updatePropertiesPanel() {
        const section = document.getElementById('propertiesSection');
        const panel = document.getElementById('propertiesPanel');
        const title = document.getElementById('propertiesTitle');

        // Only show for single selection
        if (this.selectedObjects.length !== 1) {
            section.style.display = 'none';
            return;
        }

        // Show properties section
        section.style.display = '';
        const obj = this.selectedObjects[0];
        let html = '';

        // Special handling for circles that are ellipses
        let typeName = TYPE_NAMES[obj.type] || obj.type;
        if (obj instanceof TikZCircle && obj.isEllipse(this.getCoordByName.bind(this))) {
            typeName = 'Ellipse';
        }

        html += `<div class="property-row">
            <span class="property-label">Type:</span>
            <span style="color:#3478f6;font-weight:500;">${typeName}</span>
        </div>`;

        // Type-specific properties
        if (obj instanceof TikZCoordinate) {
            html += this.renderCoordProperties(obj);
        } else if (obj instanceof TikZSegment) {
            html += this.renderSegmentProperties(obj);
        } else if (obj instanceof TikZVector) {
            html += this.renderVectorProperties(obj);
        } else if (obj instanceof TikZCircle) {
            html += this.renderCircleProperties(obj);
        } else if (obj instanceof TikZArc) {
            html += this.renderArcProperties(obj);
        } else if (obj instanceof TikZRectangle) {
            html += this.renderRectProperties(obj);
        } else if (obj instanceof TikZPath) {
            html += this.renderPathProperties(obj);
        } else if (obj instanceof TikZBezier) {
            html += this.renderBezierProperties(obj);
        } else if (obj instanceof TikZLabel) {
            html += this.renderLabelProperties(obj);
        } else if (obj instanceof TikZImage) {
            html += this.renderImageProperties(obj);
        } else if (obj instanceof TikZGrid) {
            html += this.renderGridProperties(obj);
        }

        panel.innerHTML = html;

        // Set up event listeners
        this.setupPropertyListeners();

        // Update label preview if this is a label
        if (obj instanceof TikZLabel) {
            this.updateLabelPreview();
        }
    },

    renderColorSelect(currentColor, propertyName) {
        let options = (propertyName == 'fill') ? [`<option value="none" ${currentColor === "none" ? 'selected' : ''}>none</option>`] : [];
        options += Object.keys(TIKZ_COLORS).map(c =>
            `<option value="${c}" ${currentColor === c ? 'selected' : ''}>${c}</option>`
        ).join('');

        if (Object.keys(this.customColors).length > 0) {
            options += '<option disabled>── custom ──</option>';
            options += Object.keys(this.customColors).map(c =>
                `<option value="${c}" ${currentColor === c ? 'selected' : ''}>${c}</option>`
            ).join('');
        }

        const hex = this.getColor(currentColor);

        return `<div class="color-row">
            <div class="color-swatch" style="background:${hex};"></div>
            <select data-prop="${propertyName}">${options}</select>
            <button class="btn-small" onclick="app.openColorPicker('${propertyName}')" title="Add custom color">+</button>
        </div>`;
    },

    renderThicknessSelect(currentThickness, propertyName) {
        const options = Object.keys(THICKNESS_VALUES).map(t =>
            `<option value="${t}" ${currentThickness === t ? 'selected' : ''}>${t}</option>`
        ).join('');
        return `<select data-prop="${propertyName}">${options}</select>`;
    },

    renderLineStyleSelect(currentStyle, propertyName) {
        const styles = [
            'solid', 'dashed', 'dotted', 'dashdotted', 'dashdotdotted',
            'loosely dashed', 'densely dashed',
            'loosely dotted', 'densely dotted',
            'loosely dashdotted', 'densely dashdotted'
        ];
        const options = styles.map(s =>
            `<option value="${s}" ${currentStyle === s ? 'selected' : ''}>${s}</option>`
        ).join('');
        return `<select data-prop="${propertyName}">${options}</select>`;
    },

    renderFontSizeSelect(currentSize, propertyName) {
        const sizes = [
            'tiny', 'scriptsize', 'footnotesize', 'small', 'normal',
            'large', 'Large', 'LARGE', 'huge', 'Huge'
        ];
        const options = sizes.map(s =>
            `<option value="${s}" ${currentSize === s ? 'selected' : ''}>${s}</option>`
        ).join('');
        return `<select data-prop="${propertyName}">${options}</select>`;
    },

    renderPatternSelect(currentPattern, propertyName) {
        const options = Object.keys(TIKZ_PATTERNS).map(p =>
            `<option value="${p}" ${currentPattern === p ? 'selected' : ''}>${TIKZ_PATTERNS[p]}</option>`
        ).join('');
        return `<select data-prop="${propertyName}">${options}</select>`;
    },

    renderCoordSelect(currentCoord, propertyName, exclude = []) {
        const coords = this.objects.filter(o => o instanceof TikZCoordinate && !exclude.includes(o.name));
        const options = coords.map(c =>
            `<option value="${c.name}" ${currentCoord === c.name ? 'selected' : ''}>${c.name}</option>`
        ).join('');
        return `<select data-prop="${propertyName}">${options}</select>`;
    },

    renderCoordProperties(coord) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${coord.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Position:</span>
                <div class="property-input coord-inputs">
                    <input type="number" step="0.25" data-prop="x" value="${coord.x.toFixed(2)}">
                    <input type="number" step="0.25" data-prop="y" value="${coord.y.toFixed(2)}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Show:</span>
                <div class="property-input checkbox-row">
                    <input type="checkbox" data-prop="showPoint" ${coord.showPoint ? 'checked' : ''}>
                    <span>Visible point</span>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(coord.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Size:</span>
                <div class="property-input"><input type="number" min="1" max="10" data-prop="pointSize" value="${coord.pointSize}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Label:</span>
                <div class="property-input"><input type="text" data-prop="label" value="${coord.label || ''}" placeholder="e.g. $P_1$"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Label Pos:</span>
                <div class="property-input">
                    <select data-prop="anchor">
                        <option value="above" ${coord.anchor === 'above' ? 'selected' : ''}>above</option>
                        <option value="below" ${coord.anchor === 'below' ? 'selected' : ''}>below</option>
                        <option value="left" ${coord.anchor === 'left' ? 'selected' : ''}>left</option>
                        <option value="right" ${coord.anchor === 'right' ? 'selected' : ''}>right</option>
                        <option value="above left" ${coord.anchor === 'above left' ? 'selected' : ''}>above left</option>
                        <option value="above right" ${coord.anchor === 'above right' ? 'selected' : ''}>above right</option>
                        <option value="below left" ${coord.anchor === 'below left' ? 'selected' : ''}>below left</option>
                        <option value="below right" ${coord.anchor === 'below right' ? 'selected' : ''}>below right</option>
                    </select>
                </div>
            </div>
        `;
    },

    renderSegmentProperties(seg) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${seg.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">From:</span>
                <div class="property-input">${this.renderCoordSelect(seg.from, 'from', [seg.to])}</div>
            </div>
            <div class="property-row">
                <span class="property-label">To:</span>
                <div class="property-input">${this.renderCoordSelect(seg.to, 'to', [seg.from])}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(seg.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(seg.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(seg.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Arrow:</span>
                <div class="property-input">${this.renderArrowSelect(seg.arrowEnd || 'none', 'arrowEnd')}</div>
            </div>
            <div class="property-row" ${(seg.arrowEnd && seg.arrowEnd !== 'none') ? '' : 'style="display:none"'}>
                <span class="property-label">Arrow Size:</span>
                <div class="property-input"><input type="number" step="0.1" min="0.3" max="3" data-prop="arrowSize" value="${seg.arrowSize || 1.0}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Labels:</span>
                <div class="property-input">
                    <button class="btn" onclick="app.addEmbeddedNode()" style="width:100%;">+ Add Label</button>
                </div>
            </div>
        `;
    },

    renderArrowSelect(value, prop) {
        return `
            <select data-prop="${prop}">
                <option value="none" ${value === 'none' ? 'selected' : ''}>None</option>
                <option value="-Stealth" ${value === '-Stealth' ? 'selected' : ''}>→ End</option>
                <option value="Stealth-" ${value === 'Stealth-' ? 'selected' : ''}>← Start</option>
                <option value="Stealth-Stealth" ${value === 'Stealth-Stealth' ? 'selected' : ''}>↔ Both</option>
                <option value="->" ${value === '->' ? 'selected' : ''}>-> End (simple)</option>
                <option value="<-" ${value === '<-' ? 'selected' : ''}>← Start (simple)</option>
                <option value="<->" ${value === '<->' ? 'selected' : ''}>↔ Both (simple)</option>
                <option value="-latex" ${value === '-latex' ? 'selected' : ''}>-latex End</option>
                <option value="latex-" ${value === 'latex-' ? 'selected' : ''}>latex- Start</option>
                <option value="latex-latex" ${value === 'latex-latex' ? 'selected' : ''}>latex-latex Both</option>
            </select>
        `;
    },

    renderVectorProperties(vec) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${vec.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">From:</span>
                <div class="property-input">${this.renderCoordSelect(vec.from, 'from', [vec.to])}</div>
            </div>
            <div class="property-row">
                <span class="property-label">To:</span>
                <div class="property-input">${this.renderCoordSelect(vec.to, 'to', [vec.from])}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(vec.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(vec.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(vec.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Arrow:</span>
                <div class="property-input">
                    <select data-prop="arrowEnd">
                        <option value="-Stealth" ${vec.arrowEnd === '-Stealth' ? 'selected' : ''}>-Stealth (end)</option>
                        <option value="Stealth-" ${vec.arrowEnd === 'Stealth-' ? 'selected' : ''}>Stealth- (start)</option>
                        <option value="Stealth-Stealth" ${vec.arrowEnd === 'Stealth-Stealth' ? 'selected' : ''}>Stealth-Stealth (both)</option>
                        <option value="->" ${vec.arrowEnd === '->' ? 'selected' : ''}>-> (end)</option>
                        <option value="<-" ${vec.arrowEnd === '<-' ? 'selected' : ''}>← (start)</option>
                        <option value="<->" ${vec.arrowEnd === '<->' ? 'selected' : ''}>↔ (both)</option>
                        <option value="-latex" ${vec.arrowEnd === '-latex' ? 'selected' : ''}>-latex</option>
                        <option value="latex-" ${vec.arrowEnd === 'latex-' ? 'selected' : ''}>latex-</option>
                        <option value="latex-latex" ${vec.arrowEnd === 'latex-latex' ? 'selected' : ''}>latex-latex</option>
                    </select>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Arrow Size:</span>
                <div class="property-input"><input type="number" step="0.1" min="0.3" max="3" data-prop="arrowSize" value="${vec.arrowSize}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Labels:</span>
                <div class="property-input">
                    <button class="btn" onclick="app.addEmbeddedNode()" style="width:100%;">+ Add Label</button>
                </div>
            </div>
        `;
    },

    renderCircleProperties(circle) {
        const isEllipse = circle.isEllipse(this.getCoordByName.bind(this));
        const shapeLabel = isEllipse ? 'Ellipse' : 'Circle';
        const radiusLabel = isEllipse ? 'Semi-major:' : 'Radius:';

        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${circle.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Foci:</span>
                <div class="property-input" style="display:flex;gap:4px;">
                    ${this.renderCoordSelect(circle.center, 'center')}
                    ${this.renderCoordSelect(circle.center2, 'center2')}
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">${radiusLabel}</span>
                <div class="property-input"><input type="number" step="0.1" min="0.1" data-prop="radius" value="${circle.radius.toFixed(2)}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(circle.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(circle.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(circle.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Fill:</span>
                <div class="property-input">${this.renderColorSelect(circle.fill, 'fill')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Opacity:</span>
                <div class="property-input"><input type="number" step="0.1" min="0" max="1" data-prop="fillOpacity" value="${circle.fillOpacity}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Pattern:</span>
                <div class="property-input">${this.renderPatternSelect(circle.pattern, 'pattern')}</div>
            </div>
        `;
    },

    renderArcProperties(arc) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${arc.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Center:</span>
                <div class="property-input">${this.renderCoordSelect(arc.center, 'center')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Radius:</span>
                <div class="property-input"><input type="number" step="0.1" min="0.1" data-prop="radius" value="${arc.radius.toFixed(2)}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Start °:</span>
                <div class="property-input"><input type="number" step="5" data-prop="startAngle" value="${arc.startAngle.toFixed(1)}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">End °:</span>
                <div class="property-input"><input type="number" step="5" data-prop="endAngle" value="${arc.endAngle.toFixed(1)}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(arc.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(arc.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(arc.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Arrow:</span>
                <div class="property-input">${this.renderArrowSelect(arc.arrowEnd || 'none', 'arrowEnd')}</div>
            </div>
            <div class="property-row" ${(arc.arrowEnd && arc.arrowEnd !== 'none') ? '' : 'style="display:none"'}>
                <span class="property-label">Arrow Size:</span>
                <div class="property-input"><input type="number" step="0.1" min="0.3" max="3" data-prop="arrowSize" value="${arc.arrowSize || 1.0}"></div>
            </div>
        `;
    },

    renderRectProperties(rect) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${rect.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">X Range:</span>
                <div class="property-input coord-inputs">
                    <input type="number" step="1" data-prop="xMin" value="${rect.xMin}">
                    <input type="number" step="1" data-prop="xMax" value="${rect.xMax}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Y Range:</span>
                <div class="property-input coord-inputs">
                    <input type="number" step="1" data-prop="yMin" value="${rect.yMin}">
                    <input type="number" step="1" data-prop="yMax" value="${rect.yMax}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(rect.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(rect.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(rect.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Fill:</span>
                <div class="property-input">${this.renderColorSelect(rect.fill, 'fill')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Opacity:</span>
                <div class="property-input"><input type="number" step="0.1" min="0" max="1" data-prop="fillOpacity" value="${rect.fillOpacity}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Pattern:</span>
                <div class="property-input">${this.renderPatternSelect(rect.pattern, 'pattern')}</div>
            </div>
        `;
    },

    renderPathProperties(path) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${path.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Points:</span>
                <div class="property-input"><span style="color:#888;">${path.points.join(' → ')}</span></div>
            </div>
            <div class="property-row">
                <span class="property-label">Closed:</span>
                <div class="property-input checkbox-row">
                    <input type="checkbox" data-prop="closed" ${path.closed ? 'checked' : ''}>
                    <span>Close path</span>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(path.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(path.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(path.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Fill:</span>
                <div class="property-input">${this.renderColorSelect(path.fill, 'fill')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Opacity:</span>
                <div class="property-input"><input type="number" step="0.1" min="0" max="1" data-prop="fillOpacity" value="${path.fillOpacity}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Pattern:</span>
                <div class="property-input">${this.renderPatternSelect(path.pattern, 'pattern')}</div>
            </div>
        `;
    },

    renderBezierProperties(bezier) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${bezier.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">From:</span>
                <div class="property-input">${this.renderCoordSelect(bezier.from, 'from')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Control 1:</span>
                <div class="property-input">${this.renderCoordSelect(bezier.control1, 'control1')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Control 2:</span>
                <div class="property-input">${this.renderCoordSelect(bezier.control2, 'control2')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">To:</span>
                <div class="property-input">${this.renderCoordSelect(bezier.to, 'to')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(bezier.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Thickness:</span>
                <div class="property-input">${this.renderThicknessSelect(bezier.thickness, 'thickness')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Style:</span>
                <div class="property-input">${this.renderLineStyleSelect(bezier.lineStyle, 'lineStyle')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Arrow:</span>
                <div class="property-input">${this.renderArrowSelect(bezier.arrowEnd || 'none', 'arrowEnd')}</div>
            </div>
            <div class="property-row" ${(bezier.arrowEnd && bezier.arrowEnd !== 'none') ? '' : 'style="display:none"'}>
                <span class="property-label">Arrow Size:</span>
                <div class="property-input"><input type="number" step="0.1" min="0.3" max="3" data-prop="arrowSize" value="${bezier.arrowSize || 1.0}"></div>
            </div>
        `;
    },

    renderLabelProperties(label) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${label.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">At:</span>
                <div class="property-input">${this.renderCoordSelect(label.at, 'at')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Text:</span>
                <div class="property-input"><textarea data-prop="text">${label.text}</textarea></div>
            </div>
            <div class="property-row">
                <span class="property-label">Preview:</span>
                <div class="property-input" style="min-height:40px;display:flex;align-items:center;justify-content:center;background:#1e1e1e;border:1px solid #3e3e3e;border-radius:3px;padding:8px;">
                    <div id="labelPreview" style="color:${this.getColor(label.color)};font-family:serif;">Loading...</div>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Position:</span>
                <div class="property-input">
                    <select data-prop="position">
                        <option value="above" ${label.position === 'above' ? 'selected' : ''}>above</option>
                        <option value="below" ${label.position === 'below' ? 'selected' : ''}>below</option>
                        <option value="left" ${label.position === 'left' ? 'selected' : ''}>left</option>
                        <option value="right" ${label.position === 'right' ? 'selected' : ''}>right</option>
                        <option value="above left" ${label.position === 'above left' ? 'selected' : ''}>above left</option>
                        <option value="above right" ${label.position === 'above right' ? 'selected' : ''}>above right</option>
                        <option value="below left" ${label.position === 'below left' ? 'selected' : ''}>below left</option>
                        <option value="below right" ${label.position === 'below right' ? 'selected' : ''}>below right</option>
                    </select>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Font Size:</span>
                <div class="property-input">${this.renderFontSizeSelect(label.fontSize || 'normal', 'fontSize')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(label.color, 'color')}</div>
            </div>
            <div class="property-row">
                <span class="property-label">Rotation:</span>
                <div class="property-input">
                    <input type="number" step="5" data-prop="rotation" value="${label.rotation || 0}"> deg
                </div>
            </div>
        `;
    },

    renderImageProperties(img) {
        const aspectLocked = img.height === null;
        const displayHeight = img.height || (img.width / img.naturalAspect);

        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input">
                    <input type="text" data-prop="name" value="${img.name}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">At:</span>
                <div class="property-input">
                    ${this.renderCoordSelect(img.at, 'at')}
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Filename:</span>
                <div class="property-input">
                    <input type="text" data-prop="filename" value="${img.filename}" placeholder="image.png">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Width:</span>
                <div class="property-input">
                    <input type="number" step="0.1" min="0.1" data-prop="width"
                           value="${img.width.toFixed(2)}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Height:</span>
                <div class="property-input">
                    <input type="number" step="0.1" min="0.1" data-prop="height"
                           id="imageHeight"
                           value="${displayHeight.toFixed(2)}"
                           ${aspectLocked ? 'disabled' : ''}>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label"></span>
                <div class="property-input">
                    <label style="font-size:11px;cursor:pointer;user-select:none;">
                        <input type="checkbox" id="lockAspect"
                               ${aspectLocked ? 'checked' : ''}>
                        Lock aspect ratio
                    </label>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Opacity:</span>
                <div class="property-input">
                    <input type="range" min="0" max="1" step="0.05"
                           data-prop="opacity" value="${img.opacity}" id="opacitySlider">
                    <div style="text-align:center;font-size:10px;color:#888;" id="opacityValue">
                        ${Math.round(img.opacity * 100)}%
                    </div>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Anchor:</span>
                <div class="property-input">
                    <select data-prop="anchor">
                        <option value="south west" ${img.anchor === 'south west' ? 'selected' : ''}>south west</option>
                        <option value="south" ${img.anchor === 'south' ? 'selected' : ''}>south</option>
                        <option value="south east" ${img.anchor === 'south east' ? 'selected' : ''}>south east</option>
                        <option value="west" ${img.anchor === 'west' ? 'selected' : ''}>west</option>
                        <option value="center" ${img.anchor === 'center' ? 'selected' : ''}>center</option>
                        <option value="east" ${img.anchor === 'east' ? 'selected' : ''}>east</option>
                        <option value="north west" ${img.anchor === 'north west' ? 'selected' : ''}>north west</option>
                        <option value="north" ${img.anchor === 'north' ? 'selected' : ''}>north</option>
                        <option value="north east" ${img.anchor === 'north east' ? 'selected' : ''}>north east</option>
                    </select>
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Preview:</span>
                <div class="property-input" style="text-align:center;">
                    <img src="${img.imageData}" style="max-width:100%;max-height:100px;border:1px solid #404040;border-radius:3px;">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Size:</span>
                <div class="property-input" style="font-size:10px;color:#888;">
                    ${img.cachedImage ? `${img.cachedImage.naturalWidth}×${img.cachedImage.naturalHeight}px` : 'Loading...'}
                    <br>
                    ~${(img.imageData.length / 1024).toFixed(1)}KB in project
                </div>
            </div>
        `;
    },

    renderGridProperties(grid) {
        return `
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input"><input type="text" data-prop="name" value="${grid.name}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">X Range:</span>
                <div class="property-input coord-inputs">
                    <input type="number" step="1" data-prop="xMin" value="${grid.xMin}">
                    <input type="number" step="1" data-prop="xMax" value="${grid.xMax}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Y Range:</span>
                <div class="property-input coord-inputs">
                    <input type="number" step="1" data-prop="yMin" value="${grid.yMin}">
                    <input type="number" step="1" data-prop="yMax" value="${grid.yMax}">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Step:</span>
                <div class="property-input"><input type="number" step="0.5" min="0.1" data-prop="step" value="${grid.step}"></div>
            </div>
            <div class="property-row">
                <span class="property-label">Color:</span>
                <div class="property-input">${this.renderColorSelect(grid.color, 'color')}</div>
            </div>
        `;
    },

    setupPropertyListeners() {
        const panel = document.getElementById('propertiesPanel');

        // Input/select changes
        panel.querySelectorAll('input, select, textarea').forEach(el => {
            el.addEventListener('change', () => {
                this.handlePropertyChange(el);

                // Update color swatch if this is a color select
                if (el.tagName === 'SELECT' && el.parentElement.classList.contains('color-row')) {
                    const swatch = el.parentElement.querySelector('.color-swatch');
                    if (swatch) {
                        const colorName = el.value;
                        const hex = this.getColor(colorName);
                        swatch.style.background = hex;
                    }
                }

                // Update label preview if relevant property changed
                if (this.selectedObjects.length === 1 && this.selectedObjects[0] instanceof TikZLabel &&
                    (el.dataset.prop === 'text' || el.dataset.prop === 'label' || el.dataset.prop === 'fontSize' || el.dataset.prop === 'color')) {
                    this.updateLabelPreview();
                }
            });
            el.addEventListener('input', () => {
                if (el.tagName === 'TEXTAREA') {
                    this.handlePropertyChange(el);
                    // Update label preview on text input
                    if (this.selectedObjects.length === 1 && this.selectedObjects[0] instanceof TikZLabel) {
                        this.updateLabelPreview();
                    }
                }
            });
        });

        // Special handling for image aspect ratio lock
        const lockAspect = panel.querySelector('#lockAspect');
        if (lockAspect) {
            lockAspect.addEventListener('change', e => {
                const img = this.selectedObjects[0];
                if (img instanceof TikZImage) {
                    this.saveState();
                    if (e.target.checked) {
                        img.height = null; // Auto-calculate
                    } else {
                        img.height = img.width / img.naturalAspect; // Lock current
                    }
                    this.updatePropertiesPanel();
                    this.render();
                }
            });
        }

        // Update height when width changes (if aspect locked)
        const widthInput = panel.querySelector('[data-prop="width"]');
        if (widthInput && this.selectedObjects.length === 1 && this.selectedObjects[0] instanceof TikZImage) {
            widthInput.addEventListener('input', () => {
                const img = this.selectedObjects[0];
                if (img.height === null) {
                    const heightInput = panel.querySelector('#imageHeight');
                    if (heightInput) {
                        const newHeight = parseFloat(widthInput.value) / img.naturalAspect;
                        heightInput.value = newHeight.toFixed(2);
                    }
                }
            });
        }

        // Update opacity display
        const opacitySlider = panel.querySelector('#opacitySlider');
        if (opacitySlider) {
            opacitySlider.addEventListener('input', () => {
                const opacityValue = panel.querySelector('#opacityValue');
                if (opacityValue) {
                    opacityValue.textContent = Math.round(parseFloat(opacitySlider.value) * 100) + '%';
                }
            });
        }
    },

    async updateLabelPreview() {
        const previewDiv = document.getElementById('labelPreview');
        if (!previewDiv || this.selectedObjects.length !== 1 || !(this.selectedObjects[0] instanceof TikZLabel)) return;

        const label = this.selectedObjects[0];
        const text = label.text;
        const color = this.getColor(label.color);
        const fontSize = label.fontSize || 'normal';

        // Show loading state
        previewDiv.innerHTML = 'Rendering...';
        previewDiv.style.color = color;

        // Queue LaTeX render
        this.queueLatexRender(text, color, fontSize);

        // Wait a bit for MathJax to process, then update preview
        setTimeout(() => {
            const cacheKey = `${text}::${color}::${fontSize}`;
            const cached = this.latexCache.get(cacheKey);

            if (cached && cached.img && cached.img.complete && cached.img.naturalWidth > 0) {
                // Clear and show image
                previewDiv.innerHTML = '';
                const img = document.createElement('img');
                img.src = cached.img.src;
                img.style.maxWidth = '100%';
                img.style.height = 'auto';
                previewDiv.appendChild(img);
            } else {
                // Fallback to text
                previewDiv.textContent = text;
                previewDiv.style.fontSize = this.getFontSizePixels(fontSize);
            }
        }, 500);
    },

    handlePropertyChange(el) {
        if (this.selectedObjects.length !== 1) return;
        const selectedObj = this.selectedObjects[0];

        const prop = el.dataset.prop;
        if (!prop) return;

        let value = el.type === 'checkbox' ? el.checked : el.value;
        if (el.type === 'number') value = parseFloat(value);

        // Save state for undo (but not on every keystroke for textarea)
        // Only save on 'change' events, not 'input' events
        if (el.tagName !== 'TEXTAREA' || el.dataset.lastSaved !== value) {
            this.saveState();
            if (el.tagName === 'TEXTAREA') {
                el.dataset.lastSaved = value;
            }
        }

        // Clear LaTeX cache if text-related property changed
        if (prop === 'text' || prop === 'label' || prop === 'fontSize') {
            // Remove old cached version
            const oldText = selectedObj['text'] || selectedObj['label'];
            if (oldText) {
                // Clear any cached renders for the old text
                for (const key of this.latexCache.keys()) {
                    if (key.startsWith(oldText + '::')) {
                        this.latexCache.delete(key);
                    }
                }
            }
        }

        // Handle name change
        if (prop === 'name') {
            const oldName = selectedObj.name;
            const newName = value;

            if (this.getObjectByName(value)) {
                this.showToast('Error: Name already used by another object.', 'error');
                el.value = oldName;
                return;
            }

            if (selectedObj instanceof TikZCoordinate) {
                // Update all references to this coordinate
                this.objects.forEach(obj => {
                    if (obj.from === oldName) obj.from = newName;
                    if (obj.to === oldName) obj.to = newName;
                    if (obj.center === oldName) obj.center = newName;
                    if (obj.control1 === oldName) obj.control1 = newName;
                    if (obj.control2 === oldName) obj.control2 = newName;
                    if (obj.at === oldName) obj.at = newName;
                    if (obj.points) {
                        obj.points = obj.points.map(p => p === oldName ? newName : p);
                    }
                });
            }
        }

        selectedObj[prop] = value;
        this.render();
        this.updateObjectList();
    },

    addEmbeddedNode() {
        if (this.selectedObjects.length !== 1 || !this.selectedObjects[0].nodes) {
            return;
        }

        // Save state for undo
        this.saveState();

        const node = new TikZEmbeddedNode('label', 0.5, 'above');
        this.selectedObjects[0].nodes.push(node);
        // this.render();
        this.updateObjectList();

        // Open editor for the new node
        this.openNodeEditor(this.selectedObjects[0], node);
    },

    openNodeEditor(parentObj, node) {
        this.editingNodeParent = parentObj;
        this.editingNode = node;

        // Get modal first and make it visible immediately
        const modal = document.getElementById('nodeEditorModal');
        if (!modal) {
            console.error('FATAL: Modal not found!');
            this.showToast('Error: Unable to open label editor.', 'error');
            return;
        }

        // Make modal visible
        modal.classList.add('visible');

        try {
            // Populate modal fields
            const nodeTextEl = document.getElementById('nodeText');
            if (nodeTextEl) nodeTextEl.value = node.text;

            const nodePositionEl = document.getElementById('nodePosition');
            if (nodePositionEl) nodePositionEl.value = node.position;

            const nodePosValueEl = document.getElementById('nodePosValue');
            if (nodePosValueEl) nodePosValueEl.textContent = node.position;

            const nodeAnchorEl = document.getElementById('nodeAnchor');
            if (nodeAnchorEl) nodeAnchorEl.value = node.anchor;

            const nodeFontSizeEl = document.getElementById('nodeFontSize');
            if (nodeFontSizeEl) nodeFontSizeEl.value = node.fontSize;

            // Populate color dropdown
            const colorSelect = document.getElementById('nodeColor');
            if (colorSelect) {
                // Clear existing options first
                colorSelect.innerHTML = '';

                // Add TIKZ_COLORS
                for (const colorName of Object.keys(TIKZ_COLORS)) {
                    const option = document.createElement('option');
                    option.value = colorName;
                    option.textContent = colorName;
                    if (node.color === colorName) option.selected = true;
                    colorSelect.appendChild(option);
                }

                // Add custom colors if any
                if (Object.keys(this.customColors).length > 0) {
                    const separator = document.createElement('option');
                    separator.disabled = true;
                    separator.textContent = '── custom ──';
                    colorSelect.appendChild(separator);

                    for (const colorName of Object.keys(this.customColors)) {
                        const option = document.createElement('option');
                        option.value = colorName;
                        option.textContent = colorName;
                        if (node.color === colorName) option.selected = true;
                        colorSelect.appendChild(option);
                    }
                }
            }

            // Populate sloped checkbox
            const nodeSlopedEl = document.getElementById('nodeSloped');
            if (nodeSlopedEl) nodeSlopedEl.checked = node.sloped || false;

            const nodeRotationEl = document.getElementById('nodeRotation');
            if (nodeRotationEl) nodeRotationEl.value = node.rotation || 0;

            // Show/hide rotation row based on sloped state
            const nodeRotationRow = document.getElementById('nodeRotationRow');
            if (nodeRotationRow) nodeRotationRow.style.display = node.sloped ? 'none' : 'flex';

            // Set up event listeners
            const textInput = document.getElementById('nodeText');
            if (textInput) {
                textInput.oninput = () => this.updateNodePreview();
            }

            const posInput = document.getElementById('nodePosition');
            if (posInput) {
                posInput.oninput = (e) => {
                    const posVal = document.getElementById('nodePosValue');
                    if (posVal) posVal.textContent = e.target.value;
                };
            }

            // Update preview
            this.updateNodePreview();
        } catch (err) {
            console.error('Error populating modal:', err);
        }
    },

    updateNodePreview() {
        const text = document.getElementById('nodeText').value;
        const preview = document.getElementById('nodeLatexPreview');
        if (preview) {
            preview.innerHTML = text;
            if (window.MathJax && MathJax.typesetPromise && this.mathJaxReady) {
                // Add timeout protection to prevent hanging
                const timeout = new Promise((_, reject) =>
                    setTimeout(() => reject(new Error('MathJax timeout')), 2000)
                );

                Promise.race([
                    MathJax.typesetPromise([preview]),
                    timeout
                ]).catch(err => {
                    console.warn('MathJax preview error:', err.message);
                    // Continue anyway - text is already in the preview element
                });
            }
        }
    },

    closeNodeEditor() {
        // Remove empty labels when closing
        if (this.editingNode && this.editingNodeParent && this.editingNode.text.length == 0) {
            const idx = this.editingNodeParent.nodes.indexOf(this.editingNode);
            if (idx >= 0) {
                this.editingNodeParent.nodes.splice(idx, 1);
            }
            this.updateObjectList();
        }

        document.getElementById('nodeEditorModal').classList.remove('visible');
        this.editingNode = null;
        this.editingNodeParent = null;
    },

    closePropertiesPanel() {
        document.getElementById('propertiesSection').style.display = 'none';
        this.selectedObjects = [];
        this.updateObjectList();
        this.render();
    },

    // Keep old name as alias for any remaining references
    closePropertiesModal() {
        this.closePropertiesPanel();
    },

    setupPropertiesModalDrag() {
        const panel = document.getElementById('propertiesSection');
        const header = panel.querySelector('.canvas-properties-header');
        if (!header) return;

        let isDragging = false;
        let startX, startY, startLeft, startTop;

        header.addEventListener('mousedown', (e) => {
            if (e.target.classList.contains('panel-close-btn')) return;
            isDragging = true;
            const rect = panel.getBoundingClientRect();
            const containerRect = panel.parentElement.getBoundingClientRect();
            startX = e.clientX;
            startY = e.clientY;
            startLeft = rect.left - containerRect.left;
            startTop = rect.top - containerRect.top;
            // Switch to left/top positioning
            panel.style.left = startLeft + 'px';
            panel.style.top = startTop + 'px';
            panel.style.right = 'auto';
            e.preventDefault();
        });

        header.addEventListener('dblclick', (e) => {
            if (e.target.classList.contains('panel-close-btn')) return;
            // Reset to default top-right position
            panel.style.left = '';
            panel.style.top = '12px';
            panel.style.right = '12px';
        });

        document.addEventListener('mousemove', (e) => {
            if (!isDragging) return;
            const containerRect = panel.parentElement.getBoundingClientRect();
            const dx = e.clientX - startX;
            const dy = e.clientY - startY;
            let newLeft = startLeft + dx;
            let newTop = startTop + dy;
            // Constrain within canvas container
            newLeft = Math.max(0, Math.min(newLeft, containerRect.width - panel.offsetWidth));
            newTop = Math.max(0, Math.min(newTop, containerRect.height - panel.offsetHeight));
            panel.style.left = newLeft + 'px';
            panel.style.top = newTop + 'px';
        });

        document.addEventListener('mouseup', () => {
            isDragging = false;
        });
    },

    resetPropertiesModalPosition() {
        const panel = document.getElementById('propertiesSection');
        panel.style.left = '';
        panel.style.top = '12px';
        panel.style.right = '12px';
    },

    saveNode() {
        if (!this.editingNode) return;

        // Save state for undo
        this.saveState();

        // Clear old cached render (all variations of text/color/fontSize)
        const oldText = this.editingNode.text;
        for (const key of this.latexCache.keys()) {
            if (key.startsWith(oldText + '::')) {
                this.latexCache.delete(key);
            }
        }

        this.editingNode.text = document.getElementById('nodeText').value;
        this.editingNode.position = parseFloat(document.getElementById('nodePosition').value);
        this.editingNode.anchor = document.getElementById('nodeAnchor').value;
        this.editingNode.fontSize = document.getElementById('nodeFontSize').value;
        this.editingNode.color = document.getElementById('nodeColor').value;
        this.editingNode.sloped = document.getElementById('nodeSloped').checked;
        this.editingNode.rotation = parseFloat(document.getElementById('nodeRotation').value) || 0;

        this.closeNodeEditor();
        this.render();
        this.updateObjectList();
    },

    deleteNode() {
        if (!this.editingNode || !this.editingNodeParent) return;

        // Save state for undo
        this.saveState();

        const idx = this.editingNodeParent.nodes.indexOf(this.editingNode);
        if (idx >= 0) {
            this.editingNodeParent.nodes.splice(idx, 1);
        }

        this.closeNodeEditor();
        this.render();
        this.updateObjectList();
    },

    // ========================================================================
    // Object List
    // ========================================================================

    updateObjectList() {
        const list = document.getElementById('objectList');
        const hideInvisiblePoints = document.getElementById('hideInvisiblePoints').checked;
        const removeUnusedPoints = document.getElementById('removeUnusedPoints').checked;
        let html = '';
        let lastObjectSelected = null;

        // Remove unused coordinates if checkbox is checked
        if (removeUnusedPoints) {
            // Build set of used coordinate names
            const usedCoords = new Set();
            for (const obj of this.objects) {
                if (obj instanceof TikZSegment || obj instanceof TikZVector) {
                    usedCoords.add(obj.from);
                    usedCoords.add(obj.to);
                } else if (obj instanceof TikZCircle || obj instanceof TikZArc) {
                    usedCoords.add(obj.center);
                } else if (obj instanceof TikZPath) {
                    obj.points.forEach(p => usedCoords.add(p));
                } else if (obj instanceof TikZBezier) {
                    usedCoords.add(obj.from);
                    usedCoords.add(obj.control1);
                    usedCoords.add(obj.control2);
                    usedCoords.add(obj.to);
                } else if (obj instanceof TikZLabel || obj instanceof TikZImage) {
                    usedCoords.add(obj.at);
                }
            }
            // Also preserve coordinates being used in temporary path/line creation
            for (const name of this.tempPoints) {
                if (typeof name === 'string') {
                    usedCoords.add(name);
                }
            }
            // Remove unused coordinates (not visible, no label, not referenced)
            const toRemove = this.objects.filter(obj =>
                obj instanceof TikZCoordinate && !obj.showPoint && obj.label.length == 0 && !usedCoords.has(obj.name)
            );
            if (toRemove.length > 0) {
                this.saveState();
                for (const obj of toRemove) {
                    const idx = this.objects.indexOf(obj);
                    if (idx !== -1) {
                        this.objects.splice(idx, 1);
                    }
                    // Remove from selection if selected
                    const selIdx = this.selectedObjects.indexOf(obj);
                    if (selIdx !== -1) {
                        this.selectedObjects.splice(selIdx, 1);
                    }
                }
                // Uncheck the checkbox after removal
                document.getElementById('removeUnusedPoints').checked = false;
                this.render();
            }
        }

        // Sort objects for display: invisible coordinates first, then others in original order
        // A coordinate is "visible" if showPoint is true OR it has a label
        const isVisibleOrLabeled = (o) => o.showPoint === true || (o.label && o.label.length > 0);
        const invisibleCoords = this.objects.filter(o => o instanceof TikZCoordinate && !isVisibleOrLabeled(o));
        const otherObjects = this.objects.filter(o => !(o instanceof TikZCoordinate) || isVisibleOrLabeled(o));
        const displayOrder = [...invisibleCoords, ...otherObjects];

        for (const obj of displayOrder) {
            const isSelected = this.selectedObjects.includes(obj);
            const icon = this.getObjectIcon(obj);
            const name = this.getObjectDisplayName(obj);
            const hasSubObjects = typeof obj.getSubObjects === 'function' && obj.getSubObjects().length > 0;

            let hide = false;
            if (hideInvisiblePoints && obj instanceof TikZCoordinate && !obj.showPoint && obj.label.length == 0) {
                hide = true;
            }

            if (!hide) {
                html += `<div class="object-item ${isSelected ? 'selected' : ''} ${hasSubObjects ? 'compound' : ''} ${obj.locked ? 'locked' : ''}"
                             data-id="${obj.id}" draggable="${obj.locked ? 'false' : 'true'}">
                    <span class="lock-btn ${obj.locked ? 'locked' : ''}" onclick="event.stopPropagation(); app.toggleLock('${obj.id}')" title="${obj.locked ? 'Unlock' : 'Lock'}">${obj.locked ? ' &#x1F510; ' : ' &#x1F513; ' }</span>
                    <span class="drag-handle">⠿</span>
                    <span class="expand-btn" onclick="event.stopPropagation(); app.toggleExpand('${obj.id}')">${hasSubObjects ? (obj.expanded ? '▼' : '◢') : ''}</span>
                    <span class="obj-icon">${icon}</span>
                    <span class="obj-name">${name}</span>
                </div>`;
            }

            if (isSelected) {
                lastObjectSelected = obj;
            }

            // Render subobjects if expanded
            if (hasSubObjects && obj.expanded) {
                const subs = obj.getSubObjects();
                for (let i = 0; i < subs.length; i++) {
                    const sub = subs[i];
                    const subSelected = isSelected && this.selectedSubIndex === i;
                    html += `<div class="object-item subobject ${subSelected ? 'selected' : ''}"
                                 data-id="${obj.id}" data-sub="${i}">
                        <span class="obj-icon">${this.getSubIcon(sub.type)}</span>
                        <span class="obj-name">${sub.label}</span>
                    </div>`;
                }
            }
        }

        list.innerHTML = html;
        this.updateObjectCount();

        // make sure selected item(s) are in view within the object list only
        if (lastObjectSelected) {
            const element = document.querySelector('[data-id="' + lastObjectSelected.id + '"]');
            if (element && list) {
                // Scroll only the object list container, never the page
                const listRect = list.getBoundingClientRect();
                const elRect = element.getBoundingClientRect();
                if (elRect.top < listRect.top) {
                    list.scrollTop -= (listRect.top - elRect.top);
                } else if (elRect.bottom > listRect.bottom) {
                    list.scrollTop += (elRect.bottom - listRect.bottom);
                }
            }
        }
    },

    getObjectIcon(obj) {
        if (obj instanceof TikZCoordinate) return '•';
        if (obj instanceof TikZSegment) return '─';
        if (obj instanceof TikZVector) return '→';
        if (obj instanceof TikZCircle) {
            // Show ellipse icon if it's an ellipse
            if (obj.isEllipse(this.getCoordByName.bind(this))) return '⬭';
            return '○';
        }
        if (obj instanceof TikZArc) return '⌒';
        if (obj instanceof TikZRectangle) return '□';
        if (obj instanceof TikZPath) return '⟋';
        if (obj instanceof TikZBezier) return '∿';
        if (obj instanceof TikZLabel) return 'A';
        if (obj instanceof TikZImage) return '🖼';
        if (obj instanceof TikZGrid) return '#';
        return '?';
    },

    getSubIcon(type) {
        switch (type) {
            case 'ref': return '•';
            case 'segment': return '─';
            case 'node': return '"';
            case 'control': return '◇';
            default: return '·';
        }
    },

    getObjectDisplayName(obj) {
        if (obj instanceof TikZCoordinate) return `${obj.name} (${obj.x.toFixed(2)}, ${obj.y.toFixed(2)})`;
        if (obj instanceof TikZSegment) return `${obj.name} (${obj.from} → ${obj.to})`;
        if (obj instanceof TikZVector) return `${obj.name} (${obj.from} → ${obj.to})`;
        if (obj instanceof TikZCircle) {
            const isEllipse = obj.isEllipse(this.getCoordByName.bind(this));
            if (isEllipse) {
                return `${obj.name} (ellipse, a=${obj.radius.toFixed(2)})`;
            }
            return `${obj.name} (${obj.center}, r=${obj.radius.toFixed(2)})`;
        }
        if (obj instanceof TikZArc) return `${obj.name} (${obj.center}, ${obj.startAngle.toFixed(1)}°-${obj.endAngle.toFixed(1)}°)`;
        if (obj instanceof TikZRectangle) return `${obj.name} (${obj.xMin},${obj.yMin}) - (${obj.xMax},${obj.yMax})`;
        if (obj instanceof TikZPath) return `${obj.name} (${obj.points.length} points)`;
        if (obj instanceof TikZBezier) return `${obj.name} (${obj.from} ~ ${obj.to})`;
        if (obj instanceof TikZLabel) return `${obj.name} ("${obj.text}" at ${obj.at})`;
        if (obj instanceof TikZImage) return `${obj.name} (${obj.filename} at ${obj.at})`;
        if (obj instanceof TikZGrid) return `${obj.name} (${obj.xMin},${obj.yMin}) - (${obj.xMax},${obj.yMax})`;
        return obj.id;
    },

    toggleExpand(id) {
        const obj = this.objects.find(o => o.id === id);
        if (obj) {
            obj.expanded = !obj.expanded;
            this.updateObjectList();
        }
    },

    toggleLock(id) {
        const obj = this.objects.find(o => o.id === id);
        if (obj) {
            this.saveState();
            const newLockState = !obj.locked;
            obj.locked = newLockState;

            // Also lock/unlock referenced coordinates
            if (!(obj instanceof TikZCoordinate)) {
                const coordNames = this.getObjectCoordinates(obj);
                for (const coordName of coordNames) {
                    const coord = this.getCoordByName(coordName);
                    if (coord) {
                        if (newLockState) {
                            // Locking: lock the coordinate
                            coord.locked = true;
                        } else {
                            // Unlocking: only unlock if no other locked object uses this coord
                            const isUsedByOtherLocked = this.objects.some(other =>
                                other !== obj &&
                                other.locked &&
                                !(other instanceof TikZCoordinate) &&
                                this.getObjectCoordinates(other).includes(coordName)
                            );
                            if (!isUsedByOtherLocked) {
                                coord.locked = false;
                            }
                        }
                    }
                }
            }

            // If locking, deselect the object and its coordinates
            if (newLockState) {
                const selIdx = this.selectedObjects.indexOf(obj);
                if (selIdx !== -1) {
                    this.selectedObjects.splice(selIdx, 1);
                }
                // Also deselect any coordinates that were just locked
                if (!(obj instanceof TikZCoordinate)) {
                    const coordNames = this.getObjectCoordinates(obj);
                    for (const coordName of coordNames) {
                        const coord = this.getCoordByName(coordName);
                        if (coord) {
                            const coordSelIdx = this.selectedObjects.indexOf(coord);
                            if (coordSelIdx !== -1) {
                                this.selectedObjects.splice(coordSelIdx, 1);
                            }
                        }
                    }
                }
            }
            this.updateObjectList();
            this.updatePropertiesPanel();
            this.render();
        }
    },

    updateObjectCount() {
        document.getElementById('objectCount').textContent = this.objects.length;
    },

    setupDragDrop() {
        const list = document.getElementById('objectList');

        let draggedId = null;

        // Click handler for object list items
        list.addEventListener('click', e => {
            // Ignore clicks on expand button or lock button (they have their own handlers)
            if (e.target.closest('.expand-btn')) return;
            if (e.target.closest('.lock-btn')) return;

            const item = e.target.closest('.object-item');
            if (!item) return;

            const objId = item.dataset.id;
            const subIndex = item.dataset.sub;

            const obj = this.objects.find(o => o.id === objId);
            if (!obj) return;

            // Don't allow selecting locked objects
            if (obj.locked) return;

            // If clicking a subobject (embedded label)
            if (subIndex !== undefined) {
                const subIdx = parseInt(subIndex);
                const subs = obj.getSubObjects();
                const sub = subs[subIdx];

                if (sub && sub.type === 'node') {
                    // Clicking embedded label - open editor for this label
                    this.selectedObjects = [obj];
                    this.updatePropertiesPanel();
                    this.updateObjectList();
                    this.render();

                    // Use setTimeout to ensure modal opens after UI updates
                    setTimeout(() => {
                        this.openNodeEditor(obj, sub.node);
                    }, 50);
                    return;
                } else if (sub && sub.type === 'segment') {
                    // Clicking on segment - open label editor
                    this.selectedObjects = [obj];
                    this.updatePropertiesPanel();
                    this.updateObjectList();
                    this.render();

                    // Auto-open label editor for segments/vectors/paths
                    // Use type property instead of instanceof since it's more reliable
                    const hasLabels = (obj.type === 'line' || obj.type === 'vec' || obj.type === 'path');

                    if (hasLabels && obj.nodes !== undefined) {
                        setTimeout(() => {
                            // For paths, determine which segment was clicked
                            let segmentIndex = -1;
                            if (obj.type === 'path') {
                                // Count how many segments come before this one in getSubObjects
                                const subs = obj.getSubObjects();
                                for (let i = 0; i <= subIdx; i++) {
                                    if (subs[i] && subs[i].type === 'segment') {
                                        segmentIndex++;
                                    }
                                }
                            }

                            // For paths, check if this specific segment already has a label
                            let nodeToEdit = null;
                            if (obj.type === 'path' && segmentIndex >= 0) {
                                nodeToEdit = obj.nodes.find(n => n.segmentIndex === segmentIndex);
                            } else if (obj.type === 'line' || obj.type === 'vec') {
                                // For regular segments/vectors, use first node
                                nodeToEdit = obj.nodes.length > 0 ? obj.nodes[0] : null;
                            }

                            if (nodeToEdit) {
                                // Open editor for existing label on this segment
                                this.openNodeEditor(obj, nodeToEdit);
                            } else {
                                // Create and open editor for new label
                                const node = new TikZEmbeddedNode('', 0.5, 'above');
                                // For paths, store which segment this label is on
                                if (obj.type === 'path' && segmentIndex >= 0) {
                                    node.segmentIndex = segmentIndex;
                                }
                                if (!obj.nodes) obj.nodes = [];
                                obj.nodes.push(node);
                                this.updateObjectList();
                                this.openNodeEditor(obj, node);
                            }
                        }, 50);
                    }
                    return;
                } else if (sub && sub.type === 'ref') {
                    // Select the referenced coordinate
                    const refCoord = this.getCoordByName(sub.ref);
                    if (refCoord) {
                        // Ctrl+click for multi-select
                        if (e.ctrlKey || e.metaKey) {
                            const index = this.selectedObjects.indexOf(refCoord);
                            if (index >= 0) {
                                // Already selected, deselect it
                                this.selectedObjects.splice(index, 1);
                            } else {
                                // Not selected, add to selection
                                this.selectedObjects.push(refCoord);
                            }
                        } else {
                            // Normal click - replace selection
                            this.selectedObjects = [refCoord];
                        }
                        this.updatePropertiesPanel();
                        this.updateObjectList();
                        this.updateUndoRedoButtons();
                        this.render();
                    }
                    return;
                }
            } else {
                // Clicking main object
                // Ctrl+click for multi-select
                if (e.ctrlKey || e.metaKey) {
                    const index = this.selectedObjects.indexOf(obj);
                    if (index >= 0) {
                        // Already selected, deselect it
                        this.selectedObjects.splice(index, 1);
                    } else {
                        // Not selected, add to selection
                        this.selectedObjects.push(obj);
                    }
                } else {
                    // Normal click - replace selection
                    this.selectedObjects = [obj];
                }
                this.updatePropertiesPanel();
                this.updateObjectList();
                this.updateUndoRedoButtons();
                this.render();
            }
        });

        list.addEventListener('dragstart', e => {
            const item = e.target.closest('.object-item');
            if (item) {
                draggedId = item.dataset.id;
                item.classList.add('dragging');
            }
        });

        list.addEventListener('dragend', e => {
            const item = e.target.closest('.object-item');
            if (item) item.classList.remove('dragging');
            list.querySelectorAll('.object-item').forEach(el => el.classList.remove('drag-over'));
        });

        list.addEventListener('dragover', e => {
            e.preventDefault();
            const item = e.target.closest('.object-item');
            if (item && !item.classList.contains('dragging')) {
                list.querySelectorAll('.object-item').forEach(el => el.classList.remove('drag-over'));
                item.classList.add('drag-over');
            }
        });

        list.addEventListener('drop', e => {
            e.preventDefault();
            const targetItem = e.target.closest('.object-item');
            if (targetItem && draggedId) {
                const targetId = targetItem.dataset.id;
                if (draggedId !== targetId) {
                    this.reorderObjects(draggedId, targetId);
                }
            }
            list.querySelectorAll('.object-item').forEach(el => el.classList.remove('drag-over'));
        });
    },

    reorderObjects(draggedId, targetId) {
        const draggedIdx = this.objects.findIndex(o => o.id === draggedId);
        const targetIdx = this.objects.findIndex(o => o.id === targetId);

        if (draggedIdx >= 0 && targetIdx >= 0) {
            // Save state for undo
            this.saveState();

            const [dragged] = this.objects.splice(draggedIdx, 1);
            this.objects.splice(targetIdx, 0, dragged);
            this.updateObjectList();
            this.render();
        }
    },

    // ========================================================================
    // Color Picker
    // ========================================================================

    openColorPicker(forProperty) {
        this.colorPickerProperty = forProperty;
        document.getElementById('colorPickerModal').classList.add('visible');
        this.initColorPicker();
    },

    closeColorPicker() {
        document.getElementById('colorPickerModal').classList.remove('visible');
    },

    initColorPicker() {
        const area = document.getElementById('colorPickerArea');
        const hueSlider = document.getElementById('hueSlider');

        this.pickerHue = 0;
        this.pickerSat = 1;
        this.pickerVal = 1;

        this.updateColorPickerDisplay();

        // Area mouse handling
        let draggingArea = false;
        area.addEventListener('mousedown', e => {
            draggingArea = true;
            this.handleAreaClick(e);
        });

        document.addEventListener('mousemove', e => {
            if (draggingArea) this.handleAreaClick(e);
        });

        document.addEventListener('mouseup', () => draggingArea = false);

        // Hue slider
        let draggingHue = false;
        hueSlider.addEventListener('mousedown', e => {
            draggingHue = true;
            this.handleHueClick(e);
        });

        document.addEventListener('mousemove', e => {
            if (draggingHue) this.handleHueClick(e);
        });

        document.addEventListener('mouseup', () => draggingHue = false);

        // RGB inputs
        ['colorR', 'colorG', 'colorB'].forEach(id => {
            document.getElementById(id).addEventListener('input', () => this.updateFromRGB());
        });

        document.getElementById('colorHex').addEventListener('input', () => this.updateFromHex());
    },

    handleAreaClick(e) {
        const area = document.getElementById('colorPickerArea');
        const rect = area.getBoundingClientRect();
        this.pickerSat = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
        this.pickerVal = Math.max(0, Math.min(1, 1 - (e.clientY - rect.top) / rect.height));
        this.updateColorPickerDisplay();
    },

    handleHueClick(e) {
        const slider = document.getElementById('hueSlider');
        const rect = slider.getBoundingClientRect();
        this.pickerHue = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
        this.updateColorPickerDisplay();
    },

    updateColorPickerDisplay() {
        const rgb = this.hsvToRgb(this.pickerHue, this.pickerSat, this.pickerVal);
        const hex = this.rgbToHex(rgb.r, rgb.g, rgb.b);

        // Update inputs
        document.getElementById('colorR').value = rgb.r;
        document.getElementById('colorG').value = rgb.g;
        document.getElementById('colorB').value = rgb.b;
        document.getElementById('colorHex').value = hex;

        // Update preview
        document.getElementById('colorPreview').style.background = hex;

        // Update cursors
        const areaCursor = document.getElementById('colorPickerCursor');
        areaCursor.style.left = (this.pickerSat * 100) + '%';
        areaCursor.style.top = ((1 - this.pickerVal) * 100) + '%';

        const hueCursor = document.getElementById('hueCursor');
        hueCursor.style.left = (this.pickerHue * 100) + '%';

        // Update area background
        const hueColor = this.hsvToRgb(this.pickerHue, 1, 1);
        const area = document.getElementById('colorPickerArea');
        area.style.background = `linear-gradient(to top, #000, transparent),
                                  linear-gradient(to right, #fff, ${this.rgbToHex(hueColor.r, hueColor.g, hueColor.b)})`;
    },

    updateFromRGB() {
        const r = parseInt(document.getElementById('colorR').value) || 0;
        const g = parseInt(document.getElementById('colorG').value) || 0;
        const b = parseInt(document.getElementById('colorB').value) || 0;

        const hsv = this.rgbToHsv(r, g, b);
        this.pickerHue = hsv.h;
        this.pickerSat = hsv.s;
        this.pickerVal = hsv.v;

        this.updateColorPickerDisplay();
    },

    updateFromHex() {
        const hex = document.getElementById('colorHex').value;
        const rgb = this.hexToRgb(hex);
        if (rgb) {
            const hsv = this.rgbToHsv(rgb.r, rgb.g, rgb.b);
            this.pickerHue = hsv.h;
            this.pickerSat = hsv.s;
            this.pickerVal = hsv.v;
            this.updateColorPickerDisplay();
        }
    },

    hsvToRgb(h, s, v) {
        let r, g, b;
        const i = Math.floor(h * 6);
        const f = h * 6 - i;
        const p = v * (1 - s);
        const q = v * (1 - f * s);
        const t = v * (1 - (1 - f) * s);

        switch (i % 6) {
            case 0: r = v; g = t; b = p; break;
            case 1: r = q; g = v; b = p; break;
            case 2: r = p; g = v; b = t; break;
            case 3: r = p; g = q; b = v; break;
            case 4: r = t; g = p; b = v; break;
            case 5: r = v; g = p; b = q; break;
        }

        return { r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255) };
    },

    rgbToHsv(r, g, b) {
        r /= 255; g /= 255; b /= 255;
        const max = Math.max(r, g, b), min = Math.min(r, g, b);
        let h, s, v = max;
        const d = max - min;
        s = max === 0 ? 0 : d / max;

        if (max === min) {
            h = 0;
        } else {
            switch (max) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }
            h /= 6;
        }

        return { h, s, v };
    },

    rgbToHex(r, g, b) {
        return '#' + [r, g, b].map(x => x.toString(16).padStart(2, '0')).join('').toUpperCase();
    },

    hexToRgb(hex) {
        const match = hex.match(/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i);
        return match ? {
            r: parseInt(match[1], 16),
            g: parseInt(match[2], 16),
            b: parseInt(match[3], 16)
        } : null;
    },

    addCustomColor(originalName) {
        const name = document.getElementById('colorName').value.trim();
        const hex = document.getElementById('colorHex').value;

        if (!name || !/^[a-zA-Z][a-zA-Z0-9]*$/.test(name)) {
            this.showToast('Please enter a valid color name (letters and numbers, starting with a letter)', 'error');
            return;
        }

        if (TIKZ_COLORS[name] || this.customColors[name]) {
            this.showToast('A color with this name already exists', 'error');
            return;
        }

        // Save state for undo
        this.saveState();

        this.customColors[name] = hex;

        // Set the newly created color on the selected object
        if (this.selectedObjects.length === 1 && this.colorPickerProperty) {
            this.selectedObjects[0][this.colorPickerProperty] = name;
        }

        this.closeColorPicker();
        this.updatePropertiesPanel();
        this.updateObjectList();
    },

    // ========================================================================
    // Toast Notifications
    // ========================================================================

    showToast(message, type = 'info', duration = 2000) {
        // Remove any existing toast
        const existingToast = document.querySelector('.toast');
        if (existingToast) {
            existingToast.remove();
        }

        // Create new toast
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        document.body.appendChild(toast);

        // Trigger show animation
        setTimeout(() => toast.classList.add('show'), 10);

        // Auto-hide after duration
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }
});
