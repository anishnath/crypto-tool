/**
 * WireManager — creates, renders, and manages wires between pins.
 *
 * Wire creation flow:
 *   1. User clicks a pin dot (via PinOverlay) → startWire()
 *   2. Mouse moves → live preview line drawn
 *   3. User clicks another pin dot → finishWire()
 *   4. Orthogonal SVG path rendered between the two pins
 *
 * Wire data: { id, startComp, startPin, endComp, endPin, color, path }
 */

const WIRE_COLORS = {
  power: '#ef4444',
  gnd: '#374151',
  digital: '#22c55e',
  analog: '#3b82f6',
  default: '#06b6d4',
};

let wireIdCounter = 0;

export class WireManager {
  /**
   * @param {SVGElement} svgLayer - SVG element overlaid on the world div for wire rendering
   * @param {import('./pin-overlay.js').PinOverlay} pinOverlay
   */
  constructor(svgLayer, pinOverlay) {
    this.svgLayer = svgLayer;
    this.pinOverlay = pinOverlay;

    /** @type {Array<{id: string, startComp: string, startPin: string, endComp: string, endPin: string, color: string, pathEl: SVGPathElement}>} */
    this.wires = [];

    // In-progress wire state
    this._inProgress = null; // { startComp, startPin, startX, startY }
    this._previewLine = null;
    this._hoveredWireId = null;

    // Callbacks
    this._onSelectWire = null;
    /** Called after a wire is successfully created */
    this.onWireCreated = null;

    this._initPreview();
    this._initHover();
  }

  /** Is wire creation currently in progress? */
  get isCreating() { return this._inProgress !== null; }

  /** Set callback for wire selection */
  onSelectWire(fn) { this._onSelectWire = fn; }

  /** Start wire creation from a pin */
  startWire(componentId, pinName, worldX, worldY) {
    if (this._inProgress) {
      // Second click — finish the wire
      this.finishWire(componentId, pinName, worldX, worldY);
      return;
    }

    this._inProgress = {
      startComp: componentId,
      startPin: pinName,
      startX: worldX,
      startY: worldY,
    };

    // Show preview line
    this._previewLine.style.display = 'block';
    this._previewLine.setAttribute('x1', worldX);
    this._previewLine.setAttribute('y1', worldY);
    this._previewLine.setAttribute('x2', worldX);
    this._previewLine.setAttribute('y2', worldY);

    // Change cursor
    document.body.style.cursor = 'crosshair';
  }

  /** Finish wire creation at a second pin */
  finishWire(componentId, pinName, worldX, worldY) {
    if (!this._inProgress) return;

    // Don't connect a pin to itself
    if (this._inProgress.startComp === componentId && this._inProgress.startPin === pinName) {
      this.cancelWire();
      return;
    }

    const wire = {
      id: 'wire-' + (++wireIdCounter),
      startComp: this._inProgress.startComp,
      startPin: this._inProgress.startPin,
      endComp: componentId,
      endPin: pinName,
      color: WIRE_COLORS.default,
      pathEl: null,
    };

    // Render the wire
    wire.pathEl = this._renderWire(wire);
    this.wires.push(wire);

    this._clearInProgress();
    if (this.onWireCreated) this.onWireCreated(wire);
    return wire;
  }

  /** Cancel in-progress wire creation */
  cancelWire() {
    this._clearInProgress();
  }

  /** Update mouse position for in-progress preview */
  updatePreview(worldX, worldY) {
    if (!this._inProgress || !this._previewLine) return;
    this._previewLine.setAttribute('x2', worldX);
    this._previewLine.setAttribute('y2', worldY);
  }

  /** Remove a wire by id */
  removeWire(wireId) {
    const idx = this.wires.findIndex(w => w.id === wireId);
    if (idx < 0) return;
    const wire = this.wires[idx];
    if (wire.pathEl) wire.pathEl.remove();
    this.wires.splice(idx, 1);
  }

  /** Remove all wires attached to a component */
  removeWiresForComponent(componentId) {
    const matches = this.wires
      .filter(w => w.startComp === componentId || w.endComp === componentId)
      .map(w => w.id);
    for (const wireId of matches) this.removeWire(wireId);
  }

  /** Recompute geometry for a wire after component movement or overlay refresh */
  refreshWire(wire) {
    if (!wire || !wire.pathEl) return;
    const endpoints = this._resolveEndpoints(wire);
    if (!endpoints) {
      wire.pathEl.style.display = 'none';
      return;
    }
    wire.pathEl.style.display = '';
    wire.pathEl.setAttribute('d', this._buildPath(endpoints));
  }

  /** Recompute geometry for all wires */
  refreshAllWires() {
    for (const wire of this.wires) this.refreshWire(wire);
  }

  /** Find wire near a world coordinate (for click/hover detection) */
  findWireAt(worldX, worldY, threshold = 8) {
    for (const wire of this.wires) {
      // Simple midpoint distance check for each segment
      const mx = (wire.startX + wire.endX) / 2;
      const my = (wire.startY + wire.endY) / 2;

      // Check distance to the 3 segments of an orthogonal path
      if (this._distToOrthoPath(worldX, worldY, wire) < threshold) {
        return wire;
      }
    }
    return null;
  }

  /** Highlight a wire on hover */
  setHovered(wireId) {
    if (this._hoveredWireId === wireId) return;
    // Un-hover previous
    if (this._hoveredWireId) {
      const prev = this.wires.find(w => w.id === this._hoveredWireId);
      if (prev && prev.pathEl) {
        prev.pathEl.setAttribute('stroke-width', '2.5');
        prev.pathEl.setAttribute('opacity', '1');
      }
    }
    this._hoveredWireId = wireId;
    if (wireId) {
      const wire = this.wires.find(w => w.id === wireId);
      if (wire && wire.pathEl) {
        wire.pathEl.setAttribute('stroke-width', '4');
        wire.pathEl.setAttribute('opacity', '0.9');
      }
    }
  }

  /** Clear all wires */
  clear() {
    for (const w of this.wires) { if (w.pathEl) w.pathEl.remove(); }
    this.wires = [];
    this._clearInProgress();
  }

  // ── Internal ──

  _renderWire(wire) {
    const { color } = wire;

    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('stroke', color);
    path.setAttribute('stroke-width', '3');
    path.setAttribute('fill', 'none');
    path.setAttribute('stroke-linecap', 'round');
    path.setAttribute('stroke-linejoin', 'round');
    path.setAttribute('filter', 'drop-shadow(0 0 2px rgba(0,0,0,0.5))');
    path.style.pointerEvents = 'stroke';
    path.style.cursor = 'pointer';
    path.dataset.wireId = wire.id;

    // Click to select
    path.addEventListener('mousedown', (e) => {
      e.stopPropagation();
      if (this._onSelectWire) this._onSelectWire(wire.id);
    });

    // Double-click to delete
    path.addEventListener('dblclick', (e) => {
      e.stopPropagation();
      this.removeWire(wire.id);
    });

    this.svgLayer.appendChild(path);
    wire.pathEl = path;
    this.refreshWire(wire);
    return path;
  }

  _distToOrthoPath(px, py, wire) {
    const endpoints = this._resolveEndpoints(wire);
    if (!endpoints) return Infinity;
    const { startX, startY, endX, endY } = endpoints;
    const midX = (startX + endX) / 2;

    // 3 segments: (startX,startY)→(midX,startY), (midX,startY)→(midX,endY), (midX,endY)→(endX,endY)
    return Math.min(
      this._distToSegment(px, py, startX, startY, midX, startY),
      this._distToSegment(px, py, midX, startY, midX, endY),
      this._distToSegment(px, py, midX, endY, endX, endY),
    );
  }

  _distToSegment(px, py, x1, y1, x2, y2) {
    const dx = x2 - x1, dy = y2 - y1;
    const len2 = dx * dx + dy * dy;
    if (len2 === 0) return Math.hypot(px - x1, py - y1);
    let t = ((px - x1) * dx + (py - y1) * dy) / len2;
    t = Math.max(0, Math.min(1, t));
    return Math.hypot(px - (x1 + t * dx), py - (y1 + t * dy));
  }

  _initPreview() {
    this._previewLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    this._previewLine.setAttribute('stroke', '#22d3ee');
    this._previewLine.setAttribute('stroke-width', '3');
    this._previewLine.setAttribute('stroke-dasharray', '8 4');
    this._previewLine.setAttribute('opacity', '0.9');
    this._previewLine.style.display = 'none';
    this._previewLine.style.pointerEvents = 'none';
    this.svgLayer.appendChild(this._previewLine);
  }

  _initHover() {
    // Wire hover is handled by individual path mouseenter/mouseleave
    this.svgLayer.addEventListener('mouseover', (e) => {
      const wireId = e.target.dataset?.wireId;
      if (wireId) this.setHovered(wireId);
    });
    this.svgLayer.addEventListener('mouseout', (e) => {
      const wireId = e.target.dataset?.wireId;
      if (wireId) this.setHovered(null);
    });
  }

  _clearInProgress() {
    this._inProgress = null;
    if (this._previewLine) this._previewLine.style.display = 'none';
    document.body.style.cursor = '';
  }

  _resolveEndpoints(wire) {
    const start = this.pinOverlay.getPinPosition(wire.startComp, wire.startPin);
    const end = this.pinOverlay.getPinPosition(wire.endComp, wire.endPin);
    if (!start || !end) return null;
    return {
      startX: start.x,
      startY: start.y,
      endX: end.x,
      endY: end.y,
    };
  }

  _buildPath({ startX, startY, endX, endY }) {
    const midX = (startX + endX) / 2;
    return `M ${startX} ${startY} L ${midX} ${startY} L ${midX} ${endY} L ${endX} ${endY}`;
  }
}
