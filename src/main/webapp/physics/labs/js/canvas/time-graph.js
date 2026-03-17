/**
 * TimeGraph — Rolling time-series graph with multiple lines,
 * axis tick values, zero line, legend, optional energy lines.
 */
import { RingBuffer } from '../core/state.js';

const LINE_COLORS = ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B', '#EF4444', '#EC4899'];

export class TimeGraph {
  constructor(el, opts = {}) {
    this.el = el;
    this.ctx = el.getContext('2d');
    this.lines = [];
    this.window = opts.window || 10;
    this.capacity = opts.capacity || 2000;
    this.padding = 48;
    this.yMin = -1;
    this.yMax = 1;
  }

  addLine(varIdx, label, color) {
    const idx = this.lines.length;
    this.lines.push({
      varIdx,
      label: label || 'var' + varIdx,
      color: color || LINE_COLORS[idx % LINE_COLORS.length],
      buffer: new RingBuffer(this.capacity),
      isEnergy: false,
    });
  }

  /** Add energy line — fed separately via pushEnergy() */
  addEnergyLine(key, label, color) {
    this.lines.push({
      varIdx: -1,
      energyKey: key,
      label: label || key,
      color: color,
      buffer: new RingBuffer(this.capacity),
      isEnergy: true,
    });
  }

  clearLines() { this.lines = []; }

  push(time, state) {
    for (const line of this.lines) {
      if (!line.isEnergy) {
        line.buffer.push({ t: time, v: state[line.varIdx] });
      }
    }
  }

  /** Push energy values separately */
  pushEnergy(time, energyObj) {
    for (const line of this.lines) {
      if (line.isEnergy && energyObj[line.energyKey] !== undefined) {
        line.buffer.push({ t: time, v: energyObj[line.energyKey] });
      }
    }
  }

  clear() {
    for (const line of this.lines) line.buffer.clear();
  }

  setWindow(seconds) { this.window = Math.max(1, seconds); }

  autoScaleY() {
    let yMin = Infinity, yMax = -Infinity;
    for (const line of this.lines) {
      line.buffer.forEach(pt => {
        if (pt.v < yMin) yMin = pt.v;
        if (pt.v > yMax) yMax = pt.v;
      });
    }
    if (yMin === Infinity) return;
    const pad = (yMax - yMin) * 0.12 || 0.5;
    this.yMin = yMin - pad;
    this.yMax = yMax + pad;
  }

  render() {
    const w = this.el.width, h = this.el.height;
    const ctx = this.ctx;
    const p = this.padding;
    const pw = w - p * 2, ph = h - p * 2;

    ctx.fillStyle = '#0E1420';
    ctx.fillRect(0, 0, w, h);

    if (this.lines.length === 0) return;

    // Current time from newest data
    let tNow = 0;
    for (const line of this.lines) {
      const last = line.buffer.last();
      if (last && last.t > tNow) tNow = last.t;
    }
    const tMin = tNow - this.window;

    this.autoScaleY();

    // Grid + tick values
    ctx.font = '9px "Fira Code", monospace';
    const xTicks = niceTicksRange(tMin, tNow, 5);
    const yTicks = niceTicksRange(this.yMin, this.yMax, 5);

    ctx.strokeStyle = 'rgba(255,255,255,0.05)';
    ctx.lineWidth = 0.5;
    for (const tx of xTicks) {
      const sx = p + ((tx - tMin) / this.window) * pw;
      ctx.beginPath(); ctx.moveTo(sx, p); ctx.lineTo(sx, p + ph); ctx.stroke();
      ctx.fillStyle = '#475569';
      ctx.textAlign = 'center';
      ctx.fillText(tx.toFixed(1) + 's', sx, p + ph + 14);
    }
    for (const ty of yTicks) {
      const sy = p + ((this.yMax - ty) / (this.yMax - this.yMin)) * ph;
      ctx.beginPath(); ctx.moveTo(p, sy); ctx.lineTo(p + pw, sy); ctx.stroke();
      ctx.fillStyle = '#475569';
      ctx.textAlign = 'right';
      ctx.fillText(formatTick(ty), p - 6, sy);
    }

    // Zero line (prominent)
    if (this.yMin < 0 && this.yMax > 0) {
      const zy = p + ((this.yMax - 0) / (this.yMax - this.yMin)) * ph;
      ctx.strokeStyle = 'rgba(255,255,255,0.15)';
      ctx.lineWidth = 1;
      ctx.setLineDash([4, 4]);
      ctx.beginPath(); ctx.moveTo(p, zy); ctx.lineTo(p + pw, zy); ctx.stroke();
      ctx.setLineDash([]);
    }

    // Draw each line
    for (const line of this.lines) {
      if (line.buffer.size < 2) continue;
      ctx.beginPath();
      ctx.strokeStyle = line.color;
      ctx.lineWidth = line.isEnergy ? 1.2 : 1.5;
      if (line.isEnergy) ctx.setLineDash([3, 2]);
      let first = true;
      let prevPt = null;
      line.buffer.forEach(pt => {
        if (pt.t < tMin) { prevPt = pt; return; }
        if (first && prevPt && prevPt.t < tMin) {
          const frac = (tMin - prevPt.t) / (pt.t - prevPt.t);
          const edgeV = prevPt.v + frac * (pt.v - prevPt.v);
          const edgeSy = p + ((this.yMax - edgeV) / (this.yMax - this.yMin)) * ph;
          ctx.moveTo(p, edgeSy);
          first = false;
        }
        const sx = p + ((pt.t - tMin) / this.window) * pw;
        const sy = p + ((this.yMax - pt.v) / (this.yMax - this.yMin)) * ph;
        if (first) { ctx.moveTo(sx, sy); first = false; }
        else ctx.lineTo(sx, sy);
        prevPt = pt;
      });
      ctx.stroke();
      ctx.setLineDash([]);
    }

    // "now" line
    ctx.strokeStyle = 'rgba(139,92,246,0.25)';
    ctx.lineWidth = 1;
    ctx.setLineDash([3, 3]);
    ctx.beginPath();
    ctx.moveTo(p + pw, p);
    ctx.lineTo(p + pw, p + ph);
    ctx.stroke();
    ctx.setLineDash([]);

    // Legend
    ctx.font = '9px "Fira Code", monospace';
    ctx.textBaseline = 'top';
    const legendY = p - 16;
    let legendX = p;
    for (const line of this.lines) {
      ctx.fillStyle = line.color;
      ctx.fillRect(legendX, legendY, 8, 8);
      ctx.fillStyle = '#94a3b8';
      ctx.textAlign = 'left';
      ctx.fillText(line.label, legendX + 11, legendY - 1);
      legendX += ctx.measureText(line.label).width + 24;
    }
  }
}

/** Generate nice tick values */
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
