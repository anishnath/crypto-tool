/**
 * EnergyBar — Stacked area chart showing KE, PE, Total energy over time.
 * X-axis = time (rolling window). KE = red area, PE = blue stacked on top, Total = green line.
 */
import { RingBuffer } from '../core/state.js';

export class EnergyBar {
  constructor(el, opts = {}) {
    this.el = el;
    this.ctx = el.getContext('2d');
    this.buffer = new RingBuffer(opts.capacity || 1000);
    this.window = opts.window || 10;
    this.padding = 40;
    this.maxEnergy = 0.01;
    this.keColor = opts.keColor || '#EF4444';
    this.peColor = opts.peColor || '#3B82F6';
    this.totalColor = opts.totalColor || '#10B981';
    // Keep latest values for sim-canvas overlay
    this.ke = 0;
    this.pe = 0;
    this.total = 0;
  }

  update(ke, pe, total) {
    this.ke = Math.max(0, ke);
    this.pe = Math.max(0, pe);
    this.total = Math.max(0, total);
    this.maxEnergy = Math.max(this.maxEnergy, total * 1.15, 0.01);
  }

  pushTime(time, ke, pe, total) {
    this.buffer.push({ t: time, ke: Math.max(0, ke), pe: Math.max(0, pe), total: Math.max(0, total) });
    this.update(ke, pe, total);
  }

  reset() {
    this.maxEnergy = 0.01;
    this.buffer.clear();
  }

  render() {
    const w = this.el.width, h = this.el.height;
    const ctx = this.ctx;
    const p = this.padding;
    const pw = w - p * 2, ph = h - p * 2;

    ctx.fillStyle = '#0E1420';
    ctx.fillRect(0, 0, w, h);

    if (this.buffer.size < 2) {
      ctx.fillStyle = '#475569';
      ctx.font = '11px "Fira Code", monospace';
      ctx.textAlign = 'center';
      ctx.fillText('Collecting energy data...', w / 2, h / 2);
      return;
    }

    // Time range
    const last = this.buffer.last();
    const tNow = last ? last.t : 0;
    const tMin = tNow - this.window;

    // Auto-scale Y from buffer
    let yMax = 0.01;
    this.buffer.forEach(pt => {
      if (pt.total > yMax) yMax = pt.total;
    });
    yMax *= 1.15;

    // Grid + ticks
    ctx.font = '9px "Fira Code", monospace';
    const yTicks = niceTicksRange(0, yMax, 4);
    ctx.strokeStyle = 'rgba(255,255,255,0.05)';
    ctx.lineWidth = 0.5;
    for (const ty of yTicks) {
      const sy = p + ((yMax - ty) / yMax) * ph;
      ctx.beginPath(); ctx.moveTo(p, sy); ctx.lineTo(p + pw, sy); ctx.stroke();
      ctx.fillStyle = '#475569';
      ctx.textAlign = 'right';
      ctx.fillText(formatTick(ty), p - 6, sy + 3);
    }

    // Collect visible points
    const pts = [];
    this.buffer.forEach(pt => {
      if (pt.t >= tMin) pts.push(pt);
    });
    if (pts.length < 2) return;

    function toX(t) { return p + ((t - tMin) / (tNow - tMin + 0.001)) * pw; }
    function toY(v) { return p + ((yMax - v) / yMax) * ph; }

    // KE filled area (bottom)
    ctx.beginPath();
    ctx.moveTo(toX(pts[0].t), toY(0));
    for (const pt of pts) ctx.lineTo(toX(pt.t), toY(pt.ke));
    ctx.lineTo(toX(pts[pts.length - 1].t), toY(0));
    ctx.closePath();
    ctx.fillStyle = this.keColor + '40'; // 25% alpha
    ctx.fill();
    ctx.strokeStyle = this.keColor;
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (let i = 0; i < pts.length; i++) {
      const sx = toX(pts[i].t), sy = toY(pts[i].ke);
      i === 0 ? ctx.moveTo(sx, sy) : ctx.lineTo(sx, sy);
    }
    ctx.stroke();

    // PE filled area (stacked on top of KE)
    ctx.beginPath();
    ctx.moveTo(toX(pts[0].t), toY(pts[0].ke));
    for (const pt of pts) ctx.lineTo(toX(pt.t), toY(pt.ke + pt.pe));
    for (let i = pts.length - 1; i >= 0; i--) ctx.lineTo(toX(pts[i].t), toY(pts[i].ke));
    ctx.closePath();
    ctx.fillStyle = this.peColor + '40';
    ctx.fill();
    ctx.strokeStyle = this.peColor;
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (let i = 0; i < pts.length; i++) {
      const sx = toX(pts[i].t), sy = toY(pts[i].ke + pts[i].pe);
      i === 0 ? ctx.moveTo(sx, sy) : ctx.lineTo(sx, sy);
    }
    ctx.stroke();

    // Total energy line (green, on top)
    ctx.strokeStyle = this.totalColor;
    ctx.lineWidth = 2;
    ctx.beginPath();
    for (let i = 0; i < pts.length; i++) {
      const sx = toX(pts[i].t), sy = toY(pts[i].total);
      i === 0 ? ctx.moveTo(sx, sy) : ctx.lineTo(sx, sy);
    }
    ctx.stroke();

    // Legend (top-left)
    ctx.font = '9px "Fira Code", monospace';
    ctx.textAlign = 'left';
    const ly = p - 12;
    const items = [
      { label: 'KE', color: this.keColor },
      { label: 'PE', color: this.peColor },
      { label: 'Total', color: this.totalColor },
    ];
    let lx = p;
    for (const item of items) {
      ctx.fillStyle = item.color;
      ctx.fillRect(lx, ly, 8, 8);
      ctx.fillStyle = '#94a3b8';
      ctx.fillText(item.label, lx + 11, ly + 7);
      lx += ctx.measureText(item.label).width + 24;
    }

    // Y-axis label
    ctx.fillStyle = '#94a3b8';
    ctx.font = '10px "Fira Code", monospace';
    ctx.save();
    ctx.translate(10, p + ph / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.textAlign = 'center';
    ctx.fillText('Energy (J)', 0, 0);
    ctx.restore();
  }
}

function niceTicksRange(min, max, targetCount) {
  const range = max - min;
  if (range <= 0) return [min];
  const rough = range / targetCount;
  const mag = Math.pow(10, Math.floor(Math.log10(rough)));
  const norm = rough / mag;
  let step;
  if (norm < 1.5) step = 1 * mag;
  else if (norm < 3.5) step = 2 * mag;
  else if (norm < 7.5) step = 5 * mag;
  else step = 10 * mag;
  const ticks = [];
  const start = Math.ceil(min / step) * step;
  for (let t = start; t <= max; t += step) ticks.push(t);
  return ticks;
}

function formatTick(v) {
  if (Math.abs(v) < 1e-10) return '0';
  if (Math.abs(v) >= 100) return v.toFixed(0);
  if (Math.abs(v) >= 1) return v.toFixed(1);
  return v.toFixed(2);
}

/**
 * Standalone energy computation (testable without DOM).
 */
export function computeEnergyBar(ke, pe, total, maxEnergy, barWidth) {
  const max = Math.max(maxEnergy, total * 1.1, 0.01);
  return {
    keWidth: (Math.max(0, ke) / max) * barWidth,
    peWidth: (Math.max(0, pe) / max) * barWidth,
    totalWidth: (Math.max(0, total) / max) * barWidth,
    newMax: max,
  };
}
