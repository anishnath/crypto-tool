/**
 * PotentialWell — Plots PE as a function of position with a rolling dot.
 *
 * The classic "ball in a potential well" visualization.
 * Shows PE curve, total energy line, current position dot, and turning points.
 *
 * Each sim provides: potentialEnergy(position, params) → PE value
 * and specifies which state var is the "position" for the well.
 */

export class PotentialWell {
  constructor(el, opts = {}) {
    this.el = el;
    this.ctx = el.getContext('2d');
    this.padding = 48;
    this.posVar = opts.posVar ?? 0;     // state index for position axis
    this.posLabel = opts.posLabel || 'x';
    this.peColor = opts.peColor || '#3B82F6';
    this.totalColor = opts.totalColor || '#10B981';
    this.dotColor = opts.dotColor || '#F59E0B';
    this.posRange = opts.posRange || { min: -Math.PI, max: Math.PI };
    this.resolution = opts.resolution || 200; // number of curve sample points
  }

  /**
   * @param {function} peFn — (position, params) => PE value
   * @param {Float64Array} state — current sim state
   * @param {object} params — current params
   * @param {object} energyNow — { kinetic, potential, total } current values
   */
  render(peFn, state, params, energyNow) {
    const w = this.el.width, h = this.el.height;
    const ctx = this.ctx;
    const p = this.padding;
    const pw = w - p * 2, ph = h - p * 2;

    // Background
    ctx.fillStyle = '#0E1420';
    ctx.fillRect(0, 0, w, h);

    if (!peFn) return;

    const { min: xMin, max: xMax } = this.posRange;
    const currentPos = state[this.posVar];

    // Sample PE curve
    const points = [];
    let peMin = Infinity, peMax = -Infinity;
    for (let i = 0; i <= this.resolution; i++) {
      const x = xMin + (i / this.resolution) * (xMax - xMin);
      const pe = peFn(x, params);
      points.push({ x, pe });
      if (pe < peMin) peMin = pe;
      if (pe > peMax) peMax = pe;
    }

    // Y range: include total energy + some padding
    const totalE = energyNow ? energyNow.total : peMax;
    const yMax = Math.max(peMax, totalE) * 1.15;
    const yMin = Math.min(peMin, 0) - (yMax - Math.min(peMin, 0)) * 0.05;

    function toSx(x) { return p + ((x - xMin) / (xMax - xMin)) * pw; }
    function toSy(y) { return p + ((yMax - y) / (yMax - yMin)) * ph; }

    // Grid + ticks
    ctx.font = '9px "Fira Code", monospace';
    const xTicks = niceTicksRange(xMin, xMax, 5);
    const yTicks = niceTicksRange(yMin, yMax, 4);

    ctx.strokeStyle = 'rgba(255,255,255,0.05)';
    ctx.lineWidth = 0.5;
    for (const tx of xTicks) {
      ctx.beginPath(); ctx.moveTo(toSx(tx), p); ctx.lineTo(toSx(tx), p + ph); ctx.stroke();
      ctx.fillStyle = '#475569'; ctx.textAlign = 'center';
      ctx.fillText(formatTick(tx), toSx(tx), p + ph + 14);
    }
    for (const ty of yTicks) {
      ctx.beginPath(); ctx.moveTo(p, toSy(ty)); ctx.lineTo(p + pw, toSy(ty)); ctx.stroke();
      ctx.fillStyle = '#475569'; ctx.textAlign = 'right';
      ctx.fillText(formatTick(ty), p - 6, toSy(ty) + 3);
    }

    // Zero line
    if (yMin < 0 && yMax > 0) {
      ctx.strokeStyle = 'rgba(255,255,255,0.12)';
      ctx.lineWidth = 0.5;
      ctx.setLineDash([4, 4]);
      ctx.beginPath(); ctx.moveTo(p, toSy(0)); ctx.lineTo(p + pw, toSy(0)); ctx.stroke();
      ctx.setLineDash([]);
    }

    // PE curve — filled area
    ctx.beginPath();
    ctx.moveTo(toSx(points[0].x), toSy(0));
    for (const pt of points) ctx.lineTo(toSx(pt.x), toSy(pt.pe));
    ctx.lineTo(toSx(points[points.length - 1].x), toSy(0));
    ctx.closePath();
    ctx.fillStyle = this.peColor + '18'; // very subtle fill
    ctx.fill();

    // PE curve — line
    ctx.beginPath();
    for (let i = 0; i < points.length; i++) {
      const sx = toSx(points[i].x), sy = toSy(points[i].pe);
      i === 0 ? ctx.moveTo(sx, sy) : ctx.lineTo(sx, sy);
    }
    ctx.strokeStyle = this.peColor;
    ctx.lineWidth = 2;
    ctx.stroke();

    // Total energy line (horizontal)
    if (energyNow) {
      const teSy = toSy(energyNow.total);
      ctx.strokeStyle = this.totalColor;
      ctx.lineWidth = 1.5;
      ctx.setLineDash([6, 3]);
      ctx.beginPath();
      ctx.moveTo(p, teSy);
      ctx.lineTo(p + pw, teSy);
      ctx.stroke();
      ctx.setLineDash([]);

      // "Total E" label
      ctx.fillStyle = this.totalColor;
      ctx.font = '9px "Fira Code", monospace';
      ctx.textAlign = 'left';
      ctx.fillText('E total = ' + energyNow.total.toFixed(2), p + 4, teSy - 6);

      // Turning points (where PE = Total E)
      for (let i = 1; i < points.length; i++) {
        const prev = points[i - 1], curr = points[i];
        if ((prev.pe - energyNow.total) * (curr.pe - energyNow.total) < 0) {
          // Interpolate crossing
          const frac = (energyNow.total - prev.pe) / (curr.pe - prev.pe);
          const tx = prev.x + frac * (curr.x - prev.x);
          const sx = toSx(tx), sy = toSy(energyNow.total);
          // Vertical dashed line at turning point
          ctx.strokeStyle = '#F59E0B40';
          ctx.lineWidth = 1;
          ctx.setLineDash([2, 2]);
          ctx.beginPath(); ctx.moveTo(sx, p); ctx.lineTo(sx, p + ph); ctx.stroke();
          ctx.setLineDash([]);
          // Small triangle marker
          ctx.fillStyle = '#F59E0B';
          ctx.beginPath();
          ctx.moveTo(sx, sy - 4); ctx.lineTo(sx - 3, sy + 3); ctx.lineTo(sx + 3, sy + 3);
          ctx.closePath(); ctx.fill();
        }
      }
    }

    // Current position dot on PE curve
    const currentPE = peFn(currentPos, params);
    const dotSx = toSx(currentPos);
    const dotSy = toSy(currentPE);

    // Vertical line from dot to total energy (shows KE visually)
    if (energyNow) {
      const teSy = toSy(energyNow.total);
      ctx.strokeStyle = '#EF444460';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(dotSx, dotSy);
      ctx.lineTo(dotSx, teSy);
      ctx.stroke();
      // KE label on the red segment
      const midY = (dotSy + teSy) / 2;
      if (Math.abs(dotSy - teSy) > 20) {
        ctx.fillStyle = '#EF4444';
        ctx.font = '8px "Fira Code", monospace';
        ctx.textAlign = 'left';
        ctx.fillText('KE', dotSx + 4, midY);
      }
    }

    // Glow
    ctx.beginPath();
    ctx.arc(dotSx, dotSy, 10, 0, Math.PI * 2);
    ctx.fillStyle = this.dotColor + '25';
    ctx.fill();
    // Dot
    ctx.beginPath();
    ctx.arc(dotSx, dotSy, 5, 0, Math.PI * 2);
    ctx.fillStyle = this.dotColor;
    ctx.fill();
    ctx.strokeStyle = '#fff';
    ctx.lineWidth = 1;
    ctx.stroke();

    // Axis labels
    ctx.fillStyle = '#94a3b8';
    ctx.font = '11px "Fira Code", monospace';
    ctx.textAlign = 'center';
    ctx.fillText(this.posLabel, p + pw / 2, h - 4);
    ctx.save();
    ctx.translate(10, p + ph / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.fillText('PE (J)', 0, 0);
    ctx.restore();

    // Legend
    ctx.font = '9px "Fira Code", monospace';
    ctx.textAlign = 'left';
    const ly = p - 12;
    ctx.fillStyle = this.peColor; ctx.fillRect(p, ly, 8, 8);
    ctx.fillStyle = '#94a3b8'; ctx.fillText('PE curve', p + 11, ly + 7);
    ctx.fillStyle = this.totalColor; ctx.fillRect(p + 75, ly, 8, 8);
    ctx.fillStyle = '#94a3b8'; ctx.fillText('Total E', p + 86, ly + 7);
    ctx.fillStyle = '#EF4444'; ctx.fillRect(p + 145, ly, 8, 8);
    ctx.fillStyle = '#94a3b8'; ctx.fillText('KE gap', p + 156, ly + 7);
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
  for (let t = Math.ceil(min / step) * step; t <= max; t += step) ticks.push(t);
  return ticks;
}

function formatTick(v) {
  if (Math.abs(v) < 1e-10) return '0';
  if (Math.abs(v) >= 100) return v.toFixed(0);
  if (Math.abs(v) >= 1) return v.toFixed(1);
  return v.toFixed(2);
}
