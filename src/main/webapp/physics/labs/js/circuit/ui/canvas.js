/**
 * Circuit Grid Canvas — pan, zoom, snap, coordinate transforms
 * Supports: mouse wheel zoom, Alt/middle-click pan, touch pinch-zoom,
 * grid dots/lines, crosshair snap indicator, zoom-to-fit, selection box
 */

const GRID_SIZE = 16;
const MIN_ZOOM = 0.3;
const MAX_ZOOM = 5;
const CROSSHAIR_COLOR = 'rgba(6,182,212,0.3)';
const SELECT_BOX_COLOR = 'rgba(6,182,212,0.15)';
const SELECT_BOX_STROKE = 'rgba(6,182,212,0.6)';

// Theme-aware colors
const THEMES = {
  dark: { bg: '#111318', gridDot: '#2a2e36', gridLine: '#1a1d24', coordText: 'rgba(100,116,139,0.5)' },
  light: { bg: '#f8fafc', gridDot: '#cbd5e1', gridLine: '#e2e8f0', coordText: 'rgba(71,85,105,0.6)' },
};

function getTheme() {
  return document.documentElement.getAttribute('data-theme') === 'light' ? THEMES.light : THEMES.dark;
}

export class CircuitCanvas {
  constructor(canvasEl) {
    this.el = canvasEl;
    this.ctx = canvasEl.getContext('2d');
    this.dpr = window.devicePixelRatio || 1;

    // View transform
    this.zoom = 1.5;
    this.panX = 0;
    this.panY = 0;

    // State
    this._panning = false;
    this._panStartX = 0;
    this._panStartY = 0;

    // Mouse position (grid coords, for crosshair)
    this.mouseGX = 0;
    this.mouseGY = 0;
    this.showCrosshair = false;

    // Selection box
    this.selectBox = null;  // {x1, y1, x2, y2} in grid coords

    // Grid style
    this.gridStyle = 'dots';  // 'dots' | 'lines' | 'both'

    // Touch
    this._touches = [];
    this._pinchDist = 0;

    this._resize();
    window.addEventListener('resize', () => this._resize());
    canvasEl.addEventListener('wheel', (e) => this._onWheel(e), { passive: false });

    // Middle-click pan
    canvasEl.addEventListener('mousedown', (e) => {
      if (e.button === 1) { e.preventDefault(); this.startPan(e.offsetX, e.offsetY); }
    });
    canvasEl.addEventListener('mouseup', (e) => {
      if (e.button === 1) this.endPan();
    });

    // Touch events
    canvasEl.addEventListener('touchstart', (e) => this._onTouchStart(e), { passive: false });
    canvasEl.addEventListener('touchmove', (e) => this._onTouchMove(e), { passive: false });
    canvasEl.addEventListener('touchend', (e) => this._onTouchEnd(e));
  }

  _resize() {
    const rect = this.el.parentElement.getBoundingClientRect();
    this.w = rect.width;
    this.h = rect.height;
    this.el.width = this.w * this.dpr;
    this.el.height = this.h * this.dpr;
    this.el.style.width = this.w + 'px';
    this.el.style.height = this.h + 'px';
  }

  // ─── Zoom ───

  _onWheel(e) {
    e.preventDefault();
    const oldZoom = this.zoom;
    const factor = e.deltaY > 0 ? 0.92 : 1.08;
    this.zoom = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, this.zoom * factor));
    const mx = e.offsetX, my = e.offsetY;
    this.panX = mx - (mx - this.panX) * (this.zoom / oldZoom);
    this.panY = my - (my - this.panY) * (this.zoom / oldZoom);
  }

  /** Zoom to fit all elements within the viewport */
  zoomToFit(gridPositions) {
    if (!gridPositions || gridPositions.length === 0) {
      this.panX = this.w / 3;
      this.panY = this.h / 4;
      this.zoom = 1.5;
      return;
    }
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    for (const [gx, gy] of gridPositions) {
      minX = Math.min(minX, gx); minY = Math.min(minY, gy);
      maxX = Math.max(maxX, gx); maxY = Math.max(maxY, gy);
    }
    const margin = 4;
    minX -= margin; minY -= margin; maxX += margin; maxY += margin;

    const rangeX = (maxX - minX) * GRID_SIZE;
    const rangeY = (maxY - minY) * GRID_SIZE;
    if (rangeX < 1 || rangeY < 1) return;

    this.zoom = Math.min(this.w / rangeX, this.h / rangeY, MAX_ZOOM);
    this.zoom = Math.max(this.zoom, MIN_ZOOM);
    const cx = (minX + maxX) / 2 * GRID_SIZE;
    const cy = (minY + maxY) / 2 * GRID_SIZE;
    this.panX = this.w / 2 - cx * this.zoom;
    this.panY = this.h / 2 - cy * this.zoom;
  }

  // ─── Pan ───

  startPan(sx, sy) {
    this._panning = true;
    this._panStartX = sx - this.panX;
    this._panStartY = sy - this.panY;
    this.el.style.cursor = 'grabbing';
  }

  updatePan(sx, sy) {
    if (!this._panning) return;
    this.panX = sx - this._panStartX;
    this.panY = sy - this._panStartY;
  }

  endPan() {
    this._panning = false;
    this.el.style.cursor = '';
  }

  // ─── Touch (pinch zoom + two-finger pan) ───

  // Callback: set by app.js to route single-touch to placement/selection
  onSingleTouch = null;       // (type, x, y) => void — 'start'|'move'|'end'
  touchMode = 'pan';          // 'pan' | 'draw' — set by app.js based on mode

  _onTouchStart(e) {
    e.preventDefault();
    this._touches = [...e.touches];
    if (e.touches.length === 1) {
      const rect = this.el.getBoundingClientRect();
      const tx = e.touches[0].clientX - rect.left;
      const ty = e.touches[0].clientY - rect.top;
      if (this.touchMode === 'draw' && this.onSingleTouch) {
        // In draw mode: route to app for component placement
        this.onSingleTouch('start', tx, ty);
      } else {
        // In select/pan mode: pan the canvas
        this.startPan(tx, ty);
      }
    } else if (e.touches.length === 2) {
      const dx = e.touches[0].clientX - e.touches[1].clientX;
      const dy = e.touches[0].clientY - e.touches[1].clientY;
      this._pinchDist = Math.sqrt(dx * dx + dy * dy);
      this._pinchZoom = this.zoom;
      this._pinchPanX = this.panX;
      this._pinchPanY = this.panY;
      this._pinchCenterX = (e.touches[0].clientX + e.touches[1].clientX) / 2;
      this._pinchCenterY = (e.touches[0].clientY + e.touches[1].clientY) / 2;
    }
  }

  _onTouchMove(e) {
    e.preventDefault();
    if (e.touches.length === 1 && this.touchMode === 'draw' && this.onSingleTouch) {
      const rect = this.el.getBoundingClientRect();
      this.onSingleTouch('move', e.touches[0].clientX - rect.left, e.touches[0].clientY - rect.top);
      return;
    }
    if (e.touches.length === 2 && this._pinchDist > 0) {
      const dx = e.touches[0].clientX - e.touches[1].clientX;
      const dy = e.touches[0].clientY - e.touches[1].clientY;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const scale = dist / this._pinchDist;
      const newZoom = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, this._pinchZoom * scale));

      // Zoom toward pinch center
      const rect = this.el.getBoundingClientRect();
      const cx = (e.touches[0].clientX + e.touches[1].clientX) / 2 - rect.left;
      const cy = (e.touches[0].clientY + e.touches[1].clientY) / 2 - rect.top;
      this.panX = cx - (this._pinchCenterX - rect.left - this._pinchPanX) * (newZoom / this._pinchZoom);
      this.panY = cy - (this._pinchCenterY - rect.top - this._pinchPanY) * (newZoom / this._pinchZoom);
      this.zoom = newZoom;
    } else if (e.touches.length === 1 && this._panning) {
      this.updatePan(e.touches[0].clientX, e.touches[0].clientY);
    }
  }

  _onTouchEnd(e) {
    if (this.touchMode === 'draw' && this.onSingleTouch && e.touches.length === 0) {
      this.onSingleTouch('end', 0, 0);
    }
    this._touches = [...e.touches];
    if (e.touches.length === 0) {
      this._pinchDist = 0;
      this.endPan();
    }
  }

  // ─── Coordinate transforms ───

  screenToGrid(sx, sy) {
    const gx = (sx - this.panX) / (GRID_SIZE * this.zoom);
    const gy = (sy - this.panY) / (GRID_SIZE * this.zoom);
    return { gx: Math.round(gx), gy: Math.round(gy) };
  }

  gridToScreen(gx, gy) {
    return {
      sx: gx * GRID_SIZE * this.zoom + this.panX,
      sy: gy * GRID_SIZE * this.zoom + this.panY,
    };
  }

  get gridPx() { return GRID_SIZE * this.zoom; }

  // ─── Drawing ───

  beginFrame() {
    const ctx = this.ctx;
    this._theme = getTheme();
    ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    ctx.fillStyle = this._theme.bg;
    ctx.fillRect(0, 0, this.w, this.h);
    ctx.setTransform(
      this.dpr * this.zoom, 0, 0, this.dpr * this.zoom,
      this.dpr * this.panX, this.dpr * this.panY
    );
  }

  drawGrid() {
    const ctx = this.ctx;
    const gs = GRID_SIZE;
    const x0 = Math.floor(-this.panX / (gs * this.zoom)) - 1;
    const y0 = Math.floor(-this.panY / (gs * this.zoom)) - 1;
    const x1 = x0 + Math.ceil(this.w / (gs * this.zoom)) + 2;
    const y1 = y0 + Math.ceil(this.h / (gs * this.zoom)) + 2;

    const t = this._theme || getTheme();
    // Grid lines (every 4 grid units)
    if (this.gridStyle === 'lines' || this.gridStyle === 'both') {
      ctx.strokeStyle = t.gridLine;
      ctx.lineWidth = 0.5 / this.zoom;
      for (let x = x0; x <= x1; x++) {
        if (x % 4 !== 0) continue;
        ctx.beginPath(); ctx.moveTo(x * gs, y0 * gs); ctx.lineTo(x * gs, y1 * gs); ctx.stroke();
      }
      for (let y = y0; y <= y1; y++) {
        if (y % 4 !== 0) continue;
        ctx.beginPath(); ctx.moveTo(x0 * gs, y * gs); ctx.lineTo(x1 * gs, y * gs); ctx.stroke();
      }
    }

    // Grid dots
    if (this.gridStyle === 'dots' || this.gridStyle === 'both') {
      ctx.fillStyle = t.gridDot;
      const dotR = Math.max(0.5, 1 / this.zoom);
      for (let x = x0; x <= x1; x++) {
        for (let y = y0; y <= y1; y++) {
          ctx.fillRect(x * gs - dotR, y * gs - dotR, dotR * 2, dotR * 2);
        }
      }
    }

    // Origin marker (subtle)
    ctx.fillStyle = 'rgba(100,116,139,0.3)';
    ctx.fillRect(-1, -1, 2, 2);
  }

  /** Draw crosshair at snapped grid position (shows where component will land) */
  drawCrosshair() {
    if (!this.showCrosshair) return;
    const ctx = this.ctx;
    const gs = GRID_SIZE;
    const x = this.mouseGX * gs, y = this.mouseGY * gs;
    const len = gs * 0.8;

    ctx.strokeStyle = CROSSHAIR_COLOR;
    ctx.lineWidth = 1.5 / this.zoom;
    // Horizontal
    ctx.beginPath(); ctx.moveTo(x - len, y); ctx.lineTo(x + len, y); ctx.stroke();
    // Vertical
    ctx.beginPath(); ctx.moveTo(x, y - len); ctx.lineTo(x, y + len); ctx.stroke();
    // Center dot
    ctx.fillStyle = 'rgba(6,182,212,0.6)';
    ctx.beginPath(); ctx.arc(x, y, 2.5 / this.zoom, 0, Math.PI * 2); ctx.fill();
  }

  /** Draw selection rectangle */
  drawSelectBox() {
    if (!this.selectBox) return;
    const ctx = this.ctx;
    const gs = GRID_SIZE;
    const { x1, y1, x2, y2 } = this.selectBox;
    const sx = Math.min(x1, x2) * gs, sy = Math.min(y1, y2) * gs;
    const sw = Math.abs(x2 - x1) * gs, sh = Math.abs(y2 - y1) * gs;

    ctx.fillStyle = SELECT_BOX_COLOR;
    ctx.fillRect(sx, sy, sw, sh);
    ctx.strokeStyle = SELECT_BOX_STROKE;
    ctx.lineWidth = 1 / this.zoom;
    ctx.setLineDash([4 / this.zoom, 4 / this.zoom]);
    ctx.strokeRect(sx, sy, sw, sh);
    ctx.setLineDash([]);
  }

  /** Draw coordinate readout (bottom-left, in screen space) */
  drawCoordReadout() {
    const ctx = this.ctx;
    // Switch to screen space
    ctx.save();
    ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);

    const t = this._theme || getTheme();
    ctx.font = '10px monospace';
    ctx.fillStyle = t.coordText;
    ctx.textAlign = 'left';
    ctx.fillText(
      `(${this.mouseGX}, ${this.mouseGY})  zoom: ${(this.zoom * 100).toFixed(0)}%`,
      8, this.h - 8
    );
    ctx.restore();
  }

  endFrame() {}
}
