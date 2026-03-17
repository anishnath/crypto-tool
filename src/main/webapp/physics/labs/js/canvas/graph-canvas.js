/**
 * GraphCanvas — XY phase-space graph with auto-scale,
 * axis tick values, zero-crossing lines, current-point dot, and fading trail.
 */
import { RingBuffer } from '../core/state.js';
import { DirectionField } from './direction-field.js';

export class GraphCanvas {
  constructor(el, opts = {}) {
    this.el = el;
    this.ctx = el.getContext('2d');
    this.buffer = new RingBuffer(opts.capacity || 2000);
    this.xVar = opts.xVar || 0;
    this.yVar = opts.yVar || 1;
    this.xLabel = opts.xLabel || 'x';
    this.yLabel = opts.yLabel || 'y';
    this.lineColor = opts.lineColor || '#06B6D4';
    this.bounds = { xMin: -1, xMax: 1, yMin: -1, yMax: 1 };
    this.padding = 48;

    // Direction field (optional — set via setDirectionField)
    this.dirField = null;
    this._evaluate = null;
    this._params = null;
    this._varCount = 0;
  }

  /**
   * Enable direction field on this graph.
   * @param {function} evaluate — sim's evaluate(state, change, params)
   * @param {object} params — current sim params (updated via setParams)
   * @param {number} varCount — sim's state variable count
   * @param {object} opts — DirectionField options
   */
  setDirectionField(evaluate, params, varCount, opts = {}) {
    this._evaluate = evaluate;
    this._params = params;
    this._varCount = varCount;
    this.dirField = new DirectionField({
      xVar: this.xVar,
      yVar: this.yVar,
      ...opts,
    });
  }

  /** Update params reference (called when params change) */
  updateParams(params) {
    this._params = params;
  }

  setVars(xIdx, yIdx, xLabel, yLabel) {
    this.xVar = xIdx;
    this.yVar = yIdx;
    if (xLabel) this.xLabel = xLabel;
    if (yLabel) this.yLabel = yLabel;
    this.clear();
  }

  push(state) {
    this.buffer.push({ x: state[this.xVar], y: state[this.yVar] });
  }

  clear() { this.buffer.clear(); }

  autoScale() {
    if (this.buffer.size < 2) return;
    let xMin = Infinity, xMax = -Infinity, yMin = Infinity, yMax = -Infinity;
    this.buffer.forEach(pt => {
      if (pt.x < xMin) xMin = pt.x;
      if (pt.x > xMax) xMax = pt.x;
      if (pt.y < yMin) yMin = pt.y;
      if (pt.y > yMax) yMax = pt.y;
    });
    const xPad = (xMax - xMin) * 0.12 || 0.5;
    const yPad = (yMax - yMin) * 0.12 || 0.5;
    this.bounds = { xMin: xMin - xPad, xMax: xMax + xPad, yMin: yMin - yPad, yMax: yMax + yPad };
  }

  render() {
    const w = this.el.width, h = this.el.height;
    const ctx = this.ctx;
    const p = this.padding;
    const pw = w - p * 2, ph = h - p * 2;

    if (this.buffer.size > 1) this.autoScale();
    const { xMin, xMax, yMin, yMax } = this.bounds;

    // Background
    ctx.fillStyle = '#0E1420';
    ctx.fillRect(0, 0, w, h);

    // Grid + tick values
    ctx.font = '9px "Fira Code", monospace';
    ctx.textBaseline = 'middle';
    const xTicks = niceTicksRange(xMin, xMax, 5);
    const yTicks = niceTicksRange(yMin, yMax, 5);

    // Grid lines
    ctx.strokeStyle = 'rgba(255,255,255,0.05)';
    ctx.lineWidth = 0.5;
    for (const tx of xTicks) {
      const sx = p + ((tx - xMin) / (xMax - xMin)) * pw;
      ctx.beginPath(); ctx.moveTo(sx, p); ctx.lineTo(sx, p + ph); ctx.stroke();
      // Tick label
      ctx.fillStyle = '#475569';
      ctx.textAlign = 'center';
      ctx.fillText(formatTick(tx), sx, p + ph + 14);
    }
    for (const ty of yTicks) {
      const sy = p + ((yMax - ty) / (yMax - yMin)) * ph;
      ctx.beginPath(); ctx.moveTo(p, sy); ctx.lineTo(p + pw, sy); ctx.stroke();
      ctx.fillStyle = '#475569';
      ctx.textAlign = 'right';
      ctx.fillText(formatTick(ty), p - 6, sy);
    }

    // Zero-crossing lines (prominent)
    ctx.strokeStyle = 'rgba(255,255,255,0.15)';
    ctx.lineWidth = 1;
    ctx.setLineDash([4, 4]);
    if (xMin < 0 && xMax > 0) {
      const zx = p + ((0 - xMin) / (xMax - xMin)) * pw;
      ctx.beginPath(); ctx.moveTo(zx, p); ctx.lineTo(zx, p + ph); ctx.stroke();
    }
    if (yMin < 0 && yMax > 0) {
      const zy = p + ((yMax - 0) / (yMax - yMin)) * ph;
      ctx.beginPath(); ctx.moveTo(p, zy); ctx.lineTo(p + pw, zy); ctx.stroke();
    }
    ctx.setLineDash([]);

    // Direction field (rendered behind the trajectory)
    if (this.dirField && this._evaluate) {
      this.dirField.xVar = this.xVar;
      this.dirField.yVar = this.yVar;
      this.dirField.render(ctx, this.bounds, p, pw, ph, this._evaluate, this._params, this._varCount);
    }

    // Data trail with fade
    if (this.buffer.size > 1) {
      const n = this.buffer.size;
      const fadeStart = Math.max(0, n - 200); // last 200 points get full brightness

      for (let i = 1; i < n; i++) {
        const pt0 = this.buffer.get(i - 1);
        const pt1 = this.buffer.get(i);
        const sx0 = p + ((pt0.x - xMin) / (xMax - xMin)) * pw;
        const sy0 = p + ((yMax - pt0.y) / (yMax - yMin)) * ph;
        const sx1 = p + ((pt1.x - xMin) / (xMax - xMin)) * pw;
        const sy1 = p + ((yMax - pt1.y) / (yMax - yMin)) * ph;

        // Fade: older segments dimmer
        const age = i < fadeStart ? 0.15 : 0.15 + 0.85 * ((i - fadeStart) / (n - fadeStart));
        ctx.globalAlpha = age;
        ctx.strokeStyle = this.lineColor;
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        ctx.moveTo(sx0, sy0);
        ctx.lineTo(sx1, sy1);
        ctx.stroke();
      }
      ctx.globalAlpha = 1;

      // Current point dot
      const last = this.buffer.last();
      if (last) {
        const cx = p + ((last.x - xMin) / (xMax - xMin)) * pw;
        const cy = p + ((yMax - last.y) / (yMax - yMin)) * ph;
        // Glow
        ctx.beginPath();
        ctx.arc(cx, cy, 8, 0, Math.PI * 2);
        ctx.fillStyle = this.lineColor + '30';
        ctx.fill();
        // Dot
        ctx.beginPath();
        ctx.arc(cx, cy, 4, 0, Math.PI * 2);
        ctx.fillStyle = this.lineColor;
        ctx.fill();
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 1;
        ctx.stroke();
      }
    }

    // Axis labels
    ctx.globalAlpha = 1;
    ctx.fillStyle = '#94a3b8';
    ctx.font = '11px "Fira Code", monospace';
    ctx.textAlign = 'center';
    ctx.fillText(this.xLabel, p + pw / 2, h - 4);
    ctx.save();
    ctx.translate(10, p + ph / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.fillText(this.yLabel, 0, 0);
    ctx.restore();
  }
}

/** Generate nice tick values for a given range */
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
  for (let t = start; t <= max; t += step) {
    ticks.push(t);
  }
  return ticks;
}

function formatTick(v) {
  if (Math.abs(v) < 1e-10) return '0';
  if (Math.abs(v) >= 100) return v.toFixed(0);
  if (Math.abs(v) >= 1) return v.toFixed(1);
  return v.toFixed(2);
}
