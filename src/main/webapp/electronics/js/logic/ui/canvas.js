/* ═══════════════════════════════════════════════════════════
   Logic Simulator — SVG Canvas Engine
   Pan, zoom, grid, component rendering, selection, interaction
   Multi-select: Ctrl+click, Ctrl+A, rubber-band drag
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const GRID = 8;
  const MIN_ZOOM = 0.25;
  const MAX_ZOOM = 4;
  const PORT_R = 5;
  const CLICK_THRESHOLD = 4;  // px — below this is a click, above is a drag

  function snap(v) { return Math.round(v / GRID) * GRID; }

  class Canvas {
    constructor(svgEl, circuit) {
      this.svg     = svgEl;
      this.circuit = circuit;
      this.zoom    = 1;
      this.panX    = 0;
      this.panY    = 0;

      /* Selection — Set of ids (components and/or wires) */
      this.selected   = new Set();
      this.placeType  = null;

      /* Drag state */
      this._drag      = null;   // { origins: Map<id,{x,y}>, startX, startY, moved }
      this._isPanning = false;
      this._panStart  = null;
      this._momentary = null;   // component being held (momentary button)

      /* Rubber-band selection */
      this._rubberBand = null;  // { startX, startY } world coords
      this._rbRect     = null;  // SVG rect element

      /* SVG layers */
      this.world     = this._g('lg-world');
      this.gridLayer = this._g('lg-grid');
      this.wireLayer = this._g('lg-wires');
      this.compLayer = this._g('lg-comps');
      this.portLayer = this._g('lg-ports');
      this.overlayLayer = this._g('lg-overlay');  // rubber-band, etc.
      this.world.appendChild(this.gridLayer);
      this.world.appendChild(this.wireLayer);
      this.world.appendChild(this.compLayer);
      this.world.appendChild(this.portLayer);
      this.world.appendChild(this.overlayLayer);
      this.svg.appendChild(this.world);

      this._drawGrid();
      this._bindEvents();
      this._attachCircuitListener(circuit);
    }

    /* Attach onChange listener to a circuit */
    _attachCircuitListener(c) {
      this._circuitListener = (type, data) => {
        if (type === 'removeComponent' && this._momentary && this._momentary.id === data) {
          this._momentary = null;
        }
        this.render();
      };
      c.onChange(this._circuitListener);
    }

    /* Switch to a different circuit (used by project tab switching) */
    setCircuit(c) {
      this.circuit = c;
      if (this.wireManager) this.wireManager.circuit = c;
      this.selected.clear();
      this._momentary = null;
      this._attachCircuitListener(c);
      this.render();
    }

    /* ── SVG helpers ── */
    _ns(tag) { return document.createElementNS('http://www.w3.org/2000/svg', tag); }
    _g(cls) { const g = this._ns('g'); if (cls) g.classList.add(cls); return g; }

    /* ── Grid ── */
    _drawGrid() {
      const defs = this._ns('defs');
      const pat = this._ns('pattern');
      pat.setAttribute('id', 'lg-grid-pattern');
      pat.setAttribute('width', GRID);
      pat.setAttribute('height', GRID);
      pat.setAttribute('patternUnits', 'userSpaceOnUse');
      const dot = this._ns('circle');
      dot.setAttribute('cx', GRID); dot.setAttribute('cy', GRID);
      dot.setAttribute('r', '0.8');
      dot.setAttribute('fill', 'var(--lg-grid-dot, #334155)');
      pat.appendChild(dot); defs.appendChild(pat);
      this.svg.insertBefore(defs, this.svg.firstChild);
      const rect = this._ns('rect');
      rect.setAttribute('width', '10000'); rect.setAttribute('height', '10000');
      rect.setAttribute('x', '-5000');     rect.setAttribute('y', '-5000');
      rect.setAttribute('fill', 'url(#lg-grid-pattern)');
      this.gridLayer.appendChild(rect);
    }

    /* ── Transform ── */
    _updateTransform() {
      this.world.setAttribute('transform',
        `translate(${this.panX},${this.panY}) scale(${this.zoom})`);
    }
    setZoom(z, cx, cy) {
      const nz = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, z));
      if (cx !== undefined) {
        this.panX = cx - (cx - this.panX) * (nz / this.zoom);
        this.panY = cy - (cy - this.panY) * (nz / this.zoom);
      }
      this.zoom = nz;
      this._updateTransform();
    }
    screenToWorld(sx, sy) {
      const r = this.svg.getBoundingClientRect();
      return { x: (sx - r.left - this.panX) / this.zoom,
               y: (sy - r.top  - this.panY) / this.zoom };
    }

    /* ── Events ── */
    _bindEvents() {
      const svg = this.svg;

      /* Wheel zoom */
      svg.addEventListener('wheel', e => {
        e.preventDefault();
        const f = e.deltaY > 0 ? 0.9 : 1.1;
        const r = svg.getBoundingClientRect();
        this.setZoom(this.zoom * f, e.clientX - r.left, e.clientY - r.top);
      }, { passive: false });

      /* ── Mouse down ── */
      svg.addEventListener('mousedown', e => {
        const w = this.screenToWorld(e.clientX, e.clientY);

        // Pan: middle-click or Alt+click
        if (e.button === 1 || (e.button === 0 && e.altKey)) {
          this._isPanning = true;
          this._panStart = { x: e.clientX - this.panX, y: e.clientY - this.panY };
          svg.style.cursor = 'grabbing';
          e.preventDefault(); return;
        }
        if (e.button !== 0) return;

        const isSim = this._isSimulating && this._isSimulating();

        // ── SIMULATE MODE: only allow input interaction ──
        if (isSim) {
          const compHit = this._hitComponent(w.x, w.y);
          if (compHit) {
            const comp = this.circuit.components.get(compHit);
            if (comp && comp.typeDef.onMouseDown) {
              comp.typeDef.onMouseDown(comp, this.circuit);
              this._momentary = comp;
              this.render();
              const onUp = () => {
                if (this._momentary) {
                  if (this._momentary.typeDef.onMouseUp)
                    this._momentary.typeDef.onMouseUp(this._momentary, this.circuit);
                  this._momentary = null;
                }
                window.removeEventListener('mouseup', onUp);
              };
              window.addEventListener('mouseup', onUp);
              return;
            }
            if (comp && comp.typeDef.onClick) {
              comp.typeDef.onClick(comp, this.circuit);
              this.render();
              return;
            }
          }
          return; // sim mode: no place, wire, select, drag
        }

        // ── EDIT MODE below ──

        // Place mode
        if (this.placeType) {
          const c = this.circuit.addComponent(this.placeType, snap(w.x), snap(w.y));
          this.select(c.id);
          if (!e.shiftKey) this.placeType = null;
          return;
        }

        // Port hit → wire creation
        const portHit = this._hitPort(w.x, w.y);
        if (portHit) {
          if (this.wireManager) this.wireManager.startWire(portHit.compId, portHit.portIdx, w);
          return;
        }

        // Component hit → select + start drag (edit mode only)
        const compHit = this._hitComponent(w.x, w.y);
        if (compHit) {
          // Ctrl+click toggles selection; plain click replaces
          if (e.ctrlKey || e.metaKey) {
            if (this.selected.has(compHit)) this.selected.delete(compHit);
            else this.selected.add(compHit);
          } else if (!this.selected.has(compHit)) {
            this.selected.clear();
            this.selected.add(compHit);
          }
          // Start drag for ALL selected components
          const origins = new Map();
          for (const id of this.selected) {
            const c = this.circuit.components.get(id);
            if (c) origins.set(id, { x: c.x, y: c.y });
          }
          this._drag = { origins, startWX: w.x, startWY: w.y, startSX: e.clientX, startSY: e.clientY, moved: false };
          this.render();
          return;
        }

        // Wire hit
        const wireHit = this._hitWire(w.x, w.y);
        if (wireHit) {
          if (e.ctrlKey || e.metaKey) {
            if (this.selected.has(wireHit)) this.selected.delete(wireHit);
            else this.selected.add(wireHit);
          } else {
            this.selected.clear();
            this.selected.add(wireHit);
          }
          this.render(); return;
        }

        // Empty space — start rubber-band (or deselect)
        if (!e.ctrlKey && !e.metaKey) this.selected.clear();
        this._rubberBand = { startX: w.x, startY: w.y };
        this.render();
      });

      /* ── Mouse move ── */
      svg.addEventListener('mousemove', e => {
        if (this._isPanning) {
          this.panX = e.clientX - this._panStart.x;
          this.panY = e.clientY - this._panStart.y;
          this._updateTransform(); return;
        }

        const w = this.screenToWorld(e.clientX, e.clientY);

        // Dragging selected components
        if (this._drag) {
          const dsx = e.clientX - this._drag.startSX;
          const dsy = e.clientY - this._drag.startSY;
          if (!this._drag.moved && Math.hypot(dsx, dsy) < CLICK_THRESHOLD) return;
          this._drag.moved = true;
          const dx = w.x - this._drag.startWX;
          const dy = w.y - this._drag.startWY;
          for (const [id, orig] of this._drag.origins) {
            const c = this.circuit.components.get(id);
            if (c) { c.x = snap(orig.x + dx); c.y = snap(orig.y + dy); }
          }
          this.render(); return;
        }

        // Rubber-band selection
        if (this._rubberBand) {
          this._drawRubberBand(this._rubberBand.startX, this._rubberBand.startY, w.x, w.y);
          return;
        }

        // Wire preview
        if (this.wireManager && this.wireManager.isDrawing) {
          this.wireManager.updatePreview(w);
          return;
        }

        // Cursor feedback based on hover target
        if (this.placeType) {
          svg.style.cursor = 'crosshair';
        } else if (this._hitPort(w.x, w.y)) {
          svg.style.cursor = 'crosshair';
        } else if (this._hitComponent(w.x, w.y)) {
          svg.style.cursor = 'grab';
        } else if (this._hitWire(w.x, w.y)) {
          svg.style.cursor = 'pointer';
        } else {
          svg.style.cursor = 'default';
        }
      });

      /* ── Mouse up ── */
      svg.addEventListener('mouseup', e => {
        if (this._isPanning) {
          this._isPanning = false;
          svg.style.cursor = this.placeType ? 'crosshair' : 'default';
          return;
        }

        // (Momentary button release is handled by window-level listener)

        // Finish drag
        if (this._drag) {
          // (Input pin toggles and button presses handled in simulate mode mousedown, not here)
          this._drag = null;
          this.circuit.propagate();
          return;
        }

        // Finish rubber-band
        if (this._rubberBand) {
          const w = this.screenToWorld(e.clientX, e.clientY);
          this._finishRubberBand(this._rubberBand.startX, this._rubberBand.startY, w.x, w.y);
          this._rubberBand = null;
          if (this._rbRect) { this._rbRect.remove(); this._rbRect = null; }
          this.render();
          return;
        }

        // Wire completion
        if (this.wireManager && this.wireManager.isDrawing && e.button === 0) {
          const w = this.screenToWorld(e.clientX, e.clientY);
          const ph = this._hitPort(w.x, w.y);
          if (ph) this.wireManager.finishWire(ph.compId, ph.portIdx);
        }
      });

      /* Click — wire completion handled in mouseup; click is for
         the rare case where mouseup didn't fire on a port but user
         clicked on one in a separate gesture. Guard prevents double-fire. */

      /* ── Keyboard ── */
      document.addEventListener('keydown', e => {
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
        const isSim = this._isSimulating && this._isSimulating();

        // Delete / Backspace (edit mode only)
        if (!isSim && (e.key === 'Delete' || e.key === 'Backspace')) {
          if (this.selected.size) {
            for (const id of [...this.selected]) {
              if (this.circuit.components.has(id)) this.circuit.removeComponent(id);
              else if (this.circuit.wires.has(id)) this.circuit.removeWire(id);
            }
            this.selected.clear();
            this.render();
          }
          e.preventDefault();
        }

        // Rotate (edit mode only)
        if (!isSim && (e.key === 'r' || e.key === 'R')) {
          for (const id of this.selected) {
            const c = this.circuit.components.get(id);
            if (c) c.rotate(90);
          }
          if (this.selected.size) this.circuit.propagate();
        }

        // Ctrl+A — select all (edit mode only)
        if (!isSim && (e.ctrlKey || e.metaKey) && e.key === 'a') {
          e.preventDefault();
          this.selected.clear();
          for (const id of this.circuit.components.keys()) this.selected.add(id);
          this.render();
        }

        // Escape
        if (e.key === 'Escape') {
          this.placeType = null;
          if (this.wireManager) this.wireManager.cancel();
          this.selected.clear();
          this.render();
          svg.style.cursor = 'default';
        }
      });
    }

    /* ── Rubber-band ── */
    _drawRubberBand(x1, y1, x2, y2) {
      if (!this._rbRect) {
        this._rbRect = this._ns('rect');
        this._rbRect.setAttribute('fill', 'var(--lg-accent-dim)');
        this._rbRect.setAttribute('stroke', 'var(--lg-accent)');
        this._rbRect.setAttribute('stroke-width', '0.5');
        this._rbRect.setAttribute('stroke-dasharray', '4 2');
        this.overlayLayer.appendChild(this._rbRect);
      }
      const rx = Math.min(x1, x2), ry = Math.min(y1, y2);
      const rw = Math.abs(x2 - x1), rh = Math.abs(y2 - y1);
      this._rbRect.setAttribute('x', rx);
      this._rbRect.setAttribute('y', ry);
      this._rbRect.setAttribute('width', rw);
      this._rbRect.setAttribute('height', rh);
    }

    _finishRubberBand(x1, y1, x2, y2) {
      const rx = Math.min(x1, x2), ry = Math.min(y1, y2);
      const rw = Math.abs(x2 - x1), rh = Math.abs(y2 - y1);
      if (rw < 5 && rh < 5) return; // too small — treat as click
      for (const c of this.circuit.components.values()) {
        if (c.x >= rx && c.x <= rx + rw && c.y >= ry && c.y <= ry + rh) {
          this.selected.add(c.id);
        }
      }
    }

    /* ── Hit testing ── */
    _hitPort(wx, wy) {
      const r = PORT_R + 4;
      for (const comp of this.circuit.components.values()) {
        for (let i = 0; i < comp.ports.length; i++) {
          const pos = comp.portPos(i);
          const dx = wx - pos.x, dy = wy - pos.y;
          if (dx * dx + dy * dy < r * r) return { compId: comp.id, portIdx: i };
        }
      }
      return null;
    }

    _hitComponent(wx, wy) {
      const HR = 28;
      let hit = null;
      // Iterate all — last match wins (topmost rendered component)
      for (const comp of this.circuit.components.values()) {
        if (Math.abs(wx - comp.x) < HR && Math.abs(wy - comp.y) < HR) hit = comp.id;
      }
      return hit;
    }

    _hitWire(wx, wy) {
      const TH = 6;
      for (const w of this.circuit.wires.values()) {
        const fc = this.circuit.components.get(w.fromCompId);
        const tc = this.circuit.components.get(w.toCompId);
        if (!fc || !tc) continue;
        const p1 = fc.portPos(w.fromPortIdx), p2 = tc.portPos(w.toPortIdx);
        const mx = (p1.x + p2.x) / 2;
        if (_ptSegDist(wx, wy, p1.x, p1.y, mx, p1.y) < TH) return w.id;
        if (_ptSegDist(wx, wy, mx, p1.y, mx, p2.y) < TH) return w.id;
        if (_ptSegDist(wx, wy, mx, p2.y, p2.x, p2.y) < TH) return w.id;
      }
      return null;
    }

    /* ── Selection helpers ── */
    select(id) {
      this.selected.clear();
      if (id) this.selected.add(id);
      this.render();
      if (this._onSelect) this._onSelect(id);
    }
    onSelect(fn) { this._onSelect = fn; }

    /* ── Place mode ── */
    startPlace(typeDef) { this.placeType = typeDef; this.svg.style.cursor = 'crosshair'; }
    cancelPlace() { this.placeType = null; this.svg.style.cursor = 'default'; }

    /* ── Render ── */
    render() {
      this.compLayer.innerHTML = '';
      this.portLayer.innerHTML = '';
      this.wireLayer.innerHTML = '';

      for (const w of this.circuit.wires.values()) this._renderWire(w);
      for (const comp of this.circuit.components.values()) this._renderComponent(comp);
      if (this.wireManager) this.wireManager.renderPreview();
    }

    _renderComponent(comp) {
      const g = this._ns('g');
      g.setAttribute('transform', `translate(${comp.x},${comp.y}) rotate(${comp.rotation})`);
      g.dataset.compId = comp.id;
      comp.typeDef.render(comp, { group: g, canvas: this });
      this.compLayer.appendChild(g);

      // Selection highlight — adapt size to component type
      if (this.selected.has(comp.id)) {
        const isPin = comp.type === 'INPUT' || comp.type === 'OUTPUT';
        const pad = 4;
        let bx, by, bw, bh;
        if (isPin) {
          bx = -16; by = -16; bw = 32; bh = 32;
        } else {
          const h = L.bodyH ? L.bodyH(comp.attrs) : 36;
          bx = -(L.BODY_W / 2 + L.PORT_EXT);
          by = -(h / 2);
          bw = L.BODY_W + L.PORT_EXT * 2;
          bh = h;
        }
        const rect = this._ns('rect');
        rect.setAttribute('x', bx - pad);
        rect.setAttribute('y', by - pad);
        rect.setAttribute('width', bw + pad * 2);
        rect.setAttribute('height', bh + pad * 2);
        rect.setAttribute('rx', 4);
        rect.setAttribute('fill', 'none');
        rect.setAttribute('stroke', 'var(--lg-accent)');
        rect.setAttribute('stroke-width', '1.5');
        rect.setAttribute('stroke-dasharray', '4 2');
        g.insertBefore(rect, g.firstChild);
      }

      // Port circles (absolute position)
      for (let i = 0; i < comp.ports.length; i++) {
        const pos = comp.portPos(i);
        const p = comp.ports[i];
        const c = this._ns('circle');
        c.setAttribute('cx', pos.x); c.setAttribute('cy', pos.y);
        c.setAttribute('r', PORT_R);
        c.setAttribute('fill', p.value.color());
        c.setAttribute('stroke', '#0f172a'); c.setAttribute('stroke-width', '1');
        c.classList.add('lg-port');
        this.portLayer.appendChild(c);
      }
    }

    _renderWire(w) {
      const fc = this.circuit.components.get(w.fromCompId);
      const tc = this.circuit.components.get(w.toCompId);
      if (!fc || !tc) return;
      const p1 = fc.portPos(w.fromPortIdx), p2 = tc.portPos(w.toPortIdx);
      const mx = Math.round((p1.x + p2.x) / 2);
      const path = this._ns('path');
      path.setAttribute('d', `M${p1.x},${p1.y} L${mx},${p1.y} L${mx},${p2.y} L${p2.x},${p2.y}`);
      path.setAttribute('fill', 'none');
      path.setAttribute('stroke', w.value.color());
      path.setAttribute('stroke-width', this.selected.has(w.id) ? '3.5' : '2.5');
      path.setAttribute('stroke-linecap', 'round');
      path.setAttribute('stroke-linejoin', 'round');
      if (this.selected.has(w.id)) {
        path.setAttribute('filter', 'drop-shadow(0 0 3px var(--lg-accent))');
      }
      this.wireLayer.appendChild(path);
    }

    /* ── Zoom controls ── */
    zoomIn()  { this.setZoom(this.zoom * 1.2); }
    zoomOut() { this.setZoom(this.zoom / 1.2); }
    zoomReset() { this.zoom = 1; this.panX = 0; this.panY = 0; this._updateTransform(); }
    fitContent() {
      if (!this.circuit.components.size) return;
      let mnX = Infinity, mnY = Infinity, mxX = -Infinity, mxY = -Infinity;
      for (const c of this.circuit.components.values()) {
        mnX = Math.min(mnX, c.x - 50); mnY = Math.min(mnY, c.y - 50);
        mxX = Math.max(mxX, c.x + 50); mxY = Math.max(mxY, c.y + 50);
      }
      const r = this.svg.getBoundingClientRect();
      const cw = mxX - mnX, ch = mxY - mnY;
      this.zoom = Math.min(r.width / cw, r.height / ch, 2) * 0.85;
      this.panX = (r.width  - cw * this.zoom) / 2 - mnX * this.zoom;
      this.panY = (r.height - ch * this.zoom) / 2 - mnY * this.zoom;
      this._updateTransform();
    }
  }

  function _ptSegDist(px, py, x1, y1, x2, y2) {
    const dx = x2 - x1, dy = y2 - y1, ls = dx * dx + dy * dy;
    if (ls === 0) return Math.hypot(px - x1, py - y1);
    const t = Math.max(0, Math.min(1, ((px - x1) * dx + (py - y1) * dy) / ls));
    return Math.hypot(px - (x1 + t * dx), py - (y1 + t * dy));
  }

  L.Canvas = Canvas;
  L.GRID   = GRID;
  L.PORT_R = PORT_R;
  L.snap   = snap;
})(window.LogicSim);
