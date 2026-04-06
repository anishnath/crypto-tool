/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Wire Manager
   Click-to-click wire creation with orthogonal routing
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  class WireManager {
    constructor(canvas) {
      this.canvas    = canvas;
      this.circuit   = canvas.circuit;
      this.isDrawing = false;
      this._from     = null;   // { compId, portIdx }
      this._preview  = null;   // SVG path element
      this._cursor   = null;   // { x, y } world coords
    }

    startWire(compId, portIdx, worldPos) {
      this._from = { compId, portIdx };
      this._cursor = worldPos;
      this.isDrawing = true;
      this.canvas.svg.style.cursor = 'crosshair';
    }

    updatePreview(worldPos) {
      this._cursor = worldPos;
      this.renderPreview();
    }

    finishWire(toCompId, toPortIdx) {
      if (!this.isDrawing || !this._from) return;

      // Don't connect to same component/port
      if (this._from.compId === toCompId && this._from.portIdx === toPortIdx) {
        this.cancel();
        return;
      }

      const wire = this.circuit.addWire(
        this._from.compId, this._from.portIdx,
        toCompId, toPortIdx
      );

      if (!wire) {
        // Failed — maybe same direction or already connected
        console.warn('Wire connection failed');
      }

      this._cleanup();
    }

    cancel() {
      this._cleanup();
    }

    _cleanup() {
      this.isDrawing = false;
      this._from = null;
      this._cursor = null;
      if (this._preview) {
        this._preview.remove();
        this._preview = null;
      }
      this.canvas.svg.style.cursor = 'default';
      this.canvas.render();
    }

    renderPreview() {
      // Remove old preview
      if (this._preview) {
        this._preview.remove();
        this._preview = null;
      }

      if (!this.isDrawing || !this._from || !this._cursor) return;

      const fromComp = this.circuit.components.get(this._from.compId);
      if (!fromComp) return;
      const p1 = fromComp.portPos(this._from.portIdx);
      const p2 = this._cursor;
      const midX = Math.round((p1.x + p2.x) / 2);

      const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      path.setAttribute('d', `M${p1.x},${p1.y} L${midX},${p1.y} L${midX},${p2.y} L${p2.x},${p2.y}`);
      path.setAttribute('fill', 'none');
      path.setAttribute('stroke', 'var(--lg-accent)');
      path.setAttribute('stroke-width', '2');
      path.setAttribute('stroke-dasharray', '6 3');
      path.setAttribute('opacity', '0.7');
      path.classList.add('lg-wire-preview');
      this.canvas.wireLayer.appendChild(path);
      this._preview = path;
    }
  }

  L.WireManager = WireManager;
})(window.LogicSim);
