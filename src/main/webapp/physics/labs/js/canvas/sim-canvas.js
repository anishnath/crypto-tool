/**
 * SimCanvas — Simulation canvas with world-to-screen coordinate transform
 * and draw primitives (circle, line, spring, rod, arc, trail, grid, text, rect).
 *
 * Handles DPI scaling and responsive resizing.
 */

export class SimCanvas {
  /**
   * @param {HTMLCanvasElement} el
   * @param {{ xMin:number, xMax:number, yMin:number, yMax:number }} worldRect
   */
  constructor(el, worldRect) {
    this.el = el;
    this.ctx = el.getContext('2d');
    this.world = { ...worldRect };
    this.dpr = window.devicePixelRatio || 1;
    this.w = 0; // CSS pixels width
    this.h = 0;
    this._resizeObserver = null;
    this._resize();
    this._observeResize();
  }

  _observeResize() {
    if (typeof ResizeObserver !== 'undefined') {
      this._resizeObserver = new ResizeObserver(() => this._resize());
      this._resizeObserver.observe(this.el.parentElement || this.el);
    }
  }

  _resize() {
    const parent = this.el.parentElement;
    const cssW = parent ? parent.clientWidth : this.el.clientWidth;
    // Maintain aspect ratio from worldRect
    const worldW = this.world.xMax - this.world.xMin;
    const worldH = this.world.yMax - this.world.yMin;
    const aspect = worldW / worldH;
    let cssH = Math.round(cssW / aspect);

    // Respect container's min/max-height from CSS
    const parentH = parent ? parent.clientHeight : 0;
    if (parentH > 0 && parentH > cssH) cssH = parentH;
    // Cap to max-height if set
    const style = parent ? getComputedStyle(parent) : null;
    const maxH = style ? parseInt(style.maxHeight) : 0;
    if (maxH > 0 && cssH > maxH) cssH = maxH;

    this.w = cssW;
    this.h = cssH;
    this.el.style.width = cssW + 'px';
    this.el.style.height = cssH + 'px';
    this.el.width = Math.round(cssW * this.dpr);
    this.el.height = Math.round(cssH * this.dpr);
    this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
  }

  /** World coords → CSS pixel coords */
  toScreen(wx, wy) {
    const { xMin, xMax, yMin, yMax } = this.world;
    const sx = ((wx - xMin) / (xMax - xMin)) * this.w;
    const sy = ((yMax - wy) / (yMax - yMin)) * this.h;  // Y flipped
    return { sx, sy };
  }

  /** CSS pixel coords → world coords */
  toWorld(px, py) {
    const { xMin, xMax, yMin, yMax } = this.world;
    const wx = xMin + (px / this.w) * (xMax - xMin);
    const wy = yMax - (py / this.h) * (yMax - yMin);  // Y flipped
    return { wx, wy };
  }

  /** Scale world distance to screen pixels */
  scaleToScreen(worldDist) {
    return (worldDist / (this.world.xMax - this.world.xMin)) * this.w;
  }

  clear(bgColor) {
    this.ctx.fillStyle = bgColor || '#0E1420';
    this.ctx.fillRect(0, 0, this.w, this.h);
  }

  // ═══════ DRAW PRIMITIVES ═══════

  circle(wx, wy, wr, fill, stroke) {
    const { sx, sy } = this.toScreen(wx, wy);
    const sr = this.scaleToScreen(wr);
    this.ctx.beginPath();
    this.ctx.arc(sx, sy, Math.max(sr, 1), 0, Math.PI * 2);
    if (fill) { this.ctx.fillStyle = fill; this.ctx.fill(); }
    if (stroke) { this.ctx.strokeStyle = stroke; this.ctx.lineWidth = 1.5; this.ctx.stroke(); }
  }

  line(wx1, wy1, wx2, wy2, color, width) {
    const a = this.toScreen(wx1, wy1);
    const b = this.toScreen(wx2, wy2);
    this.ctx.beginPath();
    this.ctx.moveTo(a.sx, a.sy);
    this.ctx.lineTo(b.sx, b.sy);
    this.ctx.strokeStyle = color || '#94a3b8';
    this.ctx.lineWidth = width || 1.5;
    this.ctx.stroke();
  }

  rod(wx1, wy1, wx2, wy2, color, width) {
    this.line(wx1, wy1, wx2, wy2, color || '#94a3b8', width || 2);
  }

  /** Zigzag spring between two world points */
  spring(wx1, wy1, wx2, wy2, coils, amplitude, color) {
    const a = this.toScreen(wx1, wy1);
    const b = this.toScreen(wx2, wy2);
    const dx = b.sx - a.sx;
    const dy = b.sy - a.sy;
    const len = Math.hypot(dx, dy);
    if (len < 1) return;
    const nx = dx / len, ny = dy / len; // direction
    const px = -ny, py = nx;            // perpendicular
    const amp = this.scaleToScreen(amplitude || 0.1);
    const n = coils || 10;

    this.ctx.beginPath();
    this.ctx.moveTo(a.sx, a.sy);
    for (let i = 1; i <= n * 2; i++) {
      const t = i / (n * 2 + 1);
      const x = a.sx + dx * t;
      const y = a.sy + dy * t;
      const side = (i % 2 === 1) ? 1 : -1;
      this.ctx.lineTo(x + px * amp * side, y + py * amp * side);
    }
    this.ctx.lineTo(b.sx, b.sy);
    this.ctx.strokeStyle = color || '#06B6D4';
    this.ctx.lineWidth = 1.5;
    this.ctx.stroke();
  }

  rect(wx, wy, ww, wh, fill, stroke) {
    const tl = this.toScreen(wx, wy + wh); // top-left in screen (Y flipped)
    const br = this.toScreen(wx + ww, wy);
    const sw = br.sx - tl.sx;
    const sh = br.sy - tl.sy;
    if (fill) { this.ctx.fillStyle = fill; this.ctx.fillRect(tl.sx, tl.sy, sw, sh); }
    if (stroke) {
      this.ctx.strokeStyle = stroke;
      this.ctx.lineWidth = 1.5;
      this.ctx.strokeRect(tl.sx, tl.sy, sw, sh);
    }
  }

  /** Draw a filled/stroked polygon from world-space vertices [[x,y], ...] */
  polygon(worldVerts, fill, stroke) {
    if (worldVerts.length < 3) return;
    this.ctx.beginPath();
    const first = this.toScreen(worldVerts[0][0], worldVerts[0][1]);
    this.ctx.moveTo(first.sx, first.sy);
    for (let i = 1; i < worldVerts.length; i++) {
      const p = this.toScreen(worldVerts[i][0], worldVerts[i][1]);
      this.ctx.lineTo(p.sx, p.sy);
    }
    this.ctx.closePath();
    if (fill) { this.ctx.fillStyle = fill; this.ctx.fill(); }
    if (stroke) { this.ctx.strokeStyle = stroke; this.ctx.lineWidth = 1.5; this.ctx.stroke(); }
  }

  arc(wcx, wcy, wr, startAngle, endAngle, color, width) {
    const { sx, sy } = this.toScreen(wcx, wcy);
    const sr = this.scaleToScreen(wr);
    this.ctx.beginPath();
    this.ctx.arc(sx, sy, sr, -endAngle, -startAngle); // flip for screen Y
    this.ctx.strokeStyle = color || '#64748b';
    this.ctx.lineWidth = width || 1;
    this.ctx.stroke();
  }

  /** Fading motion trail from array of {wx, wy} points */
  trail(points, color, maxLen) {
    const n = Math.min(points.length, maxLen || 60);
    if (n < 2) return;
    const start = points.length - n;
    for (let i = start + 1; i < points.length; i++) {
      const alpha = (i - start) / n;
      const a = this.toScreen(points[i - 1].wx, points[i - 1].wy);
      const b = this.toScreen(points[i].wx, points[i].wy);
      this.ctx.beginPath();
      this.ctx.moveTo(a.sx, a.sy);
      this.ctx.lineTo(b.sx, b.sy);
      this.ctx.strokeStyle = color || '#8B5CF6';
      this.ctx.globalAlpha = alpha * 0.6;
      this.ctx.lineWidth = 1.5;
      this.ctx.stroke();
    }
    this.ctx.globalAlpha = 1;
  }

  /** Background reference grid */
  grid(spacing, color, alpha) {
    const { xMin, xMax, yMin, yMax } = this.world;
    this.ctx.globalAlpha = alpha || 0.06;
    this.ctx.strokeStyle = color || '#ffffff';
    this.ctx.lineWidth = 0.5;
    const s = spacing || 1;

    for (let x = Math.ceil(xMin / s) * s; x <= xMax; x += s) {
      const a = this.toScreen(x, yMin);
      const b = this.toScreen(x, yMax);
      this.ctx.beginPath(); this.ctx.moveTo(a.sx, a.sy); this.ctx.lineTo(b.sx, b.sy); this.ctx.stroke();
    }
    for (let y = Math.ceil(yMin / s) * s; y <= yMax; y += s) {
      const a = this.toScreen(xMin, y);
      const b = this.toScreen(xMax, y);
      this.ctx.beginPath(); this.ctx.moveTo(a.sx, a.sy); this.ctx.lineTo(b.sx, b.sy); this.ctx.stroke();
    }
    this.ctx.globalAlpha = 1;
  }

  text(wx, wy, str, color, size) {
    const { sx, sy } = this.toScreen(wx, wy);
    this.ctx.font = (size || 12) + 'px "Fira Code", monospace';
    this.ctx.fillStyle = color || '#94a3b8';
    this.ctx.textAlign = 'left';
    this.ctx.textBaseline = 'middle';
    this.ctx.fillText(str, sx, sy);
  }

  /** Clock overlay — draws time in top-right corner in screen pixels */
  clockOverlay(timeSeconds, isDark) {
    const ctx = this.ctx;
    const label = timeSeconds.toFixed(1) + 's';
    const px = this.w - 12;
    const py = 16;
    ctx.font = '11px "Fira Code", monospace';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'top';
    // Background pill for readability in both themes
    const tw = ctx.measureText(label).width;
    ctx.fillStyle = isDark ? 'rgba(14,20,32,0.6)' : 'rgba(255,255,255,0.7)';
    ctx.beginPath();
    ctx.roundRect(px - tw - 8, py - 3, tw + 12, 18, 4);
    ctx.fill();
    ctx.fillStyle = isDark ? '#A78BFA' : '#6D28D9';
    ctx.fillText(label, px, py);
    ctx.textAlign = 'left'; // reset
  }

  /** Energy bar overlay — draws KE/PE/Total at bottom of sim canvas in screen pixels */
  energyOverlay(ke, pe, total, maxE, isDark) {
    const ctx = this.ctx;
    const barH = 12;
    const margin = 10;
    const barW = this.w - margin * 2;
    const y = this.h - barH - margin;
    const max = Math.max(maxE, 0.01);

    // Background strip
    ctx.fillStyle = isDark ? 'rgba(14,20,32,0.65)' : 'rgba(255,255,255,0.7)';
    ctx.fillRect(margin - 2, y - 3, barW + 4, barH + 6);

    // KE bar (red)
    const keW = (Math.max(0, ke) / max) * barW;
    ctx.fillStyle = '#EF4444';
    if (keW > 0) ctx.fillRect(margin, y, keW, barH);

    // PE bar (blue, stacked)
    const peW = (Math.max(0, pe) / max) * barW;
    ctx.fillStyle = '#3B82F6';
    if (peW > 0) ctx.fillRect(margin + keW, y, peW, barH);

    // Total outline (green)
    const totalW = (Math.max(0, total) / max) * barW;
    ctx.strokeStyle = '#10B981';
    ctx.lineWidth = 1;
    ctx.strokeRect(margin, y, totalW, barH);

    // Labels
    ctx.font = '9px "Fira Code", monospace';
    ctx.textBaseline = 'middle';
    ctx.textAlign = 'left';
    const ly = y + barH / 2;
    if (keW > 22) { ctx.fillStyle = '#fff'; ctx.fillText('KE', margin + 3, ly); }
    if (peW > 22) { ctx.fillStyle = '#fff'; ctx.fillText('PE', margin + keW + 3, ly); }
  }

  /** Draw velocity and acceleration vectors at a point */
  vectorsOverlay(vectors, isDark) {
    if (!vectors) return;
    const { pos, velocity, accel } = vectors;
    const scale = 0.12; // world units per m/s or m/s²

    // Velocity arrow (green)
    if (velocity.mag > 0.01) {
      this._drawArrow(
        pos.x, pos.y,
        pos.x + velocity.x * scale,
        pos.y + velocity.y * scale,
        '#10B981', 2
      );
    }

    // Acceleration arrow (orange)
    if (accel.mag > 0.01) {
      this._drawArrow(
        pos.x, pos.y,
        pos.x + accel.x * scale,
        pos.y + accel.y * scale,
        '#F59E0B', 2
      );
    }
  }

  /** Draw arrow from world (x1,y1) to (x2,y2) */
  _drawArrow(wx1, wy1, wx2, wy2, color, width) {
    const a = this.toScreen(wx1, wy1);
    const b = this.toScreen(wx2, wy2);
    const dx = b.sx - a.sx, dy = b.sy - a.sy;
    const len = Math.hypot(dx, dy);
    if (len < 2) return;

    const ctx = this.ctx;
    ctx.strokeStyle = color;
    ctx.lineWidth = width || 2;
    ctx.beginPath();
    ctx.moveTo(a.sx, a.sy);
    ctx.lineTo(b.sx, b.sy);
    ctx.stroke();

    // Arrowhead
    const headLen = Math.min(len * 0.3, 10);
    const angle = Math.atan2(dy, dx);
    ctx.beginPath();
    ctx.moveTo(b.sx, b.sy);
    ctx.lineTo(b.sx - headLen * Math.cos(angle - 0.4), b.sy - headLen * Math.sin(angle - 0.4));
    ctx.moveTo(b.sx, b.sy);
    ctx.lineTo(b.sx - headLen * Math.cos(angle + 0.4), b.sy - headLen * Math.sin(angle + 0.4));
    ctx.stroke();
  }

  /** Period/frequency readout overlay (top-left corner) */
  periodOverlay(period, theoreticalPeriod, isDark) {
    const ctx = this.ctx;
    const lines = [];
    if (period > 0) lines.push('T meas = ' + period.toFixed(3) + 's');
    if (theoreticalPeriod > 0) lines.push('T theory = ' + theoreticalPeriod.toFixed(3) + 's');
    if (period > 0) lines.push('f = ' + (1 / period).toFixed(2) + ' Hz');

    if (lines.length === 0) return;

    ctx.font = '10px "Fira Code", monospace';
    const maxW = Math.max(...lines.map(l => ctx.measureText(l).width));
    const boxW = maxW + 14;
    const boxH = lines.length * 14 + 8;

    // Background pill
    ctx.fillStyle = isDark ? 'rgba(14,20,32,0.7)' : 'rgba(255,255,255,0.8)';
    ctx.beginPath();
    ctx.roundRect(8, 8, boxW, boxH, 4);
    ctx.fill();

    ctx.fillStyle = isDark ? '#A78BFA' : '#6D28D9';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'top';
    lines.forEach((line, i) => {
      ctx.fillText(line, 15, 13 + i * 14);
    });
  }

  destroy() {
    if (this._resizeObserver) this._resizeObserver.disconnect();
  }
}

/**
 * Standalone coordinate transform functions (testable without DOM).
 */
export function worldToScreen(wx, wy, world, screenW, screenH) {
  const sx = ((wx - world.xMin) / (world.xMax - world.xMin)) * screenW;
  const sy = ((world.yMax - wy) / (world.yMax - world.yMin)) * screenH;
  return { sx, sy };
}

export function screenToWorld(px, py, world, screenW, screenH) {
  const wx = world.xMin + (px / screenW) * (world.xMax - world.xMin);
  const wy = world.yMax - (py / screenH) * (world.yMax - world.yMin);
  return { wx, wy };
}
