/**
 * Circuit Scope — Oscilloscope panel below the circuit canvas
 *
 * Records voltage/current of selected elements over time.
 * Draws waveform traces in a bottom panel with auto-scaling Y axis.
 */

function _isLight() { return document.documentElement.getAttribute('data-theme') === 'light'; }
function _scopeBg() { return _isLight() ? '#f1f5f9' : '#0d1017'; }
function _scopeGrid() { return _isLight() ? '#cbd5e1' : '#1e2330'; }
function _scopeZero() { return _isLight() ? '#94a3b8' : '#3d4555'; }
function _scopeLabel() { return _isLight() ? '#475569' : '#64748b'; }
function _scopeLegend() { return _isLight() ? '#334155' : '#94a3b8'; }
function _scopeBorder() { return _isLight() ? '#e2e8f0' : '#2d3139'; }

const TRACE_COLORS = [
  '#06b6d4', '#f59e0b', '#22c55e', '#ef4444', '#a855f7',
  '#ec4899', '#14b8a6', '#f97316', '#6366f1', '#84cc16',
];

const MAX_POINTS = 2000;  // max data points per trace

export class Scope {
  constructor(canvasEl) {
    this.el = canvasEl;
    this.ctx = canvasEl.getContext('2d');
    this.dpr = window.devicePixelRatio || 1;
    this.w = 0;
    this.h = 0;
    this.traces = [];    // [{label, color, data:[], type:'voltage'|'current', uiElm}]
    this.visible = false;
    this._resize();
  }

  _resize() {
    if (!this.el.parentElement) return;
    const rect = this.el.parentElement.getBoundingClientRect();
    this.w = rect.width;
    this.h = rect.height;
    this.el.width = this.w * this.dpr;
    this.el.height = this.h * this.dpr;
    this.el.style.width = this.w + 'px';
    this.el.style.height = this.h + 'px';
  }

  /** Add a voltage trace for an element */
  addVoltageTrace(uiElm) {
    const idx = this.traces.length;
    this.traces.push({
      label: `V(${uiElm.type})`,
      color: TRACE_COLORS[idx % TRACE_COLORS.length],
      data: [],
      type: 'voltage',
      uiElm,
    });
    this.visible = true;
  }

  /** Add a current trace for an element */
  addCurrentTrace(uiElm) {
    const idx = this.traces.length;
    this.traces.push({
      label: `I(${uiElm.type})`,
      color: TRACE_COLORS[idx % TRACE_COLORS.length],
      data: [],
      type: 'current',
      uiElm,
    });
    this.visible = true;
  }

  /** Remove all traces for an element */
  removeTraces(uiElm) {
    this.traces = this.traces.filter(t => t.uiElm !== uiElm);
    if (this.traces.length === 0) this.visible = false;
  }

  /** Record data point (call each physics step) */
  record(simTime) {
    for (const trace of this.traces) {
      const elm = trace.uiElm;
      let val;
      if (trace.type === 'voltage') {
        val = (elm.volts[0] || 0) - (elm.volts[1] || 0);
      } else {
        val = elm.current || 0;
      }
      trace.data.push({ t: simTime, v: val });
      if (trace.data.length > MAX_POINTS) trace.data.shift();
    }
  }

  /** Clear all recorded data */
  resetData() {
    for (const trace of this.traces) trace.data = [];
  }

  /** Draw the scope */
  render() {
    if (!this.visible || this.traces.length === 0) return;
    this._resize();

    const ctx = this.ctx;
    const w = this.w, h = this.h;
    ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);

    // Background
    ctx.fillStyle = _scopeBg();
    ctx.fillRect(0, 0, w, h);

    // Border top
    ctx.strokeStyle = _scopeBorder();
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, 0.5);
    ctx.lineTo(w, 0.5);
    ctx.stroke();

    const margin = { left: 55, right: 10, top: 20, bottom: 20 };
    const plotW = w - margin.left - margin.right;
    const plotH = h - margin.top - margin.bottom;
    if (plotW < 10 || plotH < 10) return;

    // Find time range and Y range across all traces
    let tMin = Infinity, tMax = -Infinity;
    let yMin = Infinity, yMax = -Infinity;
    for (const trace of this.traces) {
      if (trace.data.length === 0) continue;
      tMin = Math.min(tMin, trace.data[0].t);
      tMax = Math.max(tMax, trace.data[trace.data.length - 1].t);
      for (const pt of trace.data) {
        yMin = Math.min(yMin, pt.v);
        yMax = Math.max(yMax, pt.v);
      }
    }

    if (!isFinite(tMin) || tMin === tMax) { tMax = tMin + 0.001; }
    if (yMin === yMax) { yMin -= 1; yMax += 1; }
    // Add 10% padding to Y
    const yPad = (yMax - yMin) * 0.1 || 0.5;
    yMin -= yPad;
    yMax += yPad;

    // Grid lines
    ctx.strokeStyle = _scopeGrid();
    ctx.lineWidth = 0.5;
    // Horizontal grid (5 lines)
    for (let i = 0; i <= 4; i++) {
      const y = margin.top + plotH * i / 4;
      ctx.beginPath(); ctx.moveTo(margin.left, y); ctx.lineTo(margin.left + plotW, y); ctx.stroke();
    }
    // Vertical grid (8 lines)
    for (let i = 0; i <= 8; i++) {
      const x = margin.left + plotW * i / 8;
      ctx.beginPath(); ctx.moveTo(x, margin.top); ctx.lineTo(x, margin.top + plotH); ctx.stroke();
    }

    // Zero line (if visible)
    if (yMin < 0 && yMax > 0) {
      const y0 = margin.top + plotH * (1 - (0 - yMin) / (yMax - yMin));
      ctx.strokeStyle = _scopeZero();
      ctx.lineWidth = 1;
      ctx.beginPath(); ctx.moveTo(margin.left, y0); ctx.lineTo(margin.left + plotW, y0); ctx.stroke();
    }

    // Y-axis labels
    ctx.font = '10px monospace';
    ctx.fillStyle = _scopeLabel();
    ctx.textAlign = 'right';
    for (let i = 0; i <= 4; i++) {
      const val = yMax - (yMax - yMin) * i / 4;
      const y = margin.top + plotH * i / 4;
      ctx.fillText(this._formatVal(val), margin.left - 4, y + 3);
    }

    // X-axis labels (time)
    ctx.textAlign = 'center';
    for (let i = 0; i <= 4; i++) {
      const t = tMin + (tMax - tMin) * i / 4;
      const x = margin.left + plotW * i / 4;
      ctx.fillText(this._formatTime(t), x, margin.top + plotH + 14);
    }

    // Draw traces
    for (const trace of this.traces) {
      if (trace.data.length < 2) continue;
      ctx.strokeStyle = trace.color;
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      let first = true;
      for (const pt of trace.data) {
        const x = margin.left + plotW * (pt.t - tMin) / (tMax - tMin);
        const y = margin.top + plotH * (1 - (pt.v - yMin) / (yMax - yMin));
        if (first) { ctx.moveTo(x, y); first = false; }
        else ctx.lineTo(x, y);
      }
      ctx.stroke();
    }

    // Legend (top-left)
    ctx.font = '11px monospace';
    let lx = margin.left + 6, ly = margin.top + 12;
    for (const trace of this.traces) {
      ctx.fillStyle = trace.color;
      ctx.fillRect(lx, ly - 8, 10, 3);
      ctx.fillStyle = _scopeLegend();
      ctx.textAlign = 'left';
      const lastVal = trace.data.length > 0 ? trace.data[trace.data.length - 1].v : 0;
      ctx.fillText(`${trace.label} = ${this._formatVal(lastVal)}`, lx + 14, ly);
      ly += 14;
    }
  }

  _formatVal(v) {
    const abs = Math.abs(v);
    if (abs >= 1000) return (v / 1000).toFixed(1) + 'k';
    if (abs >= 1) return v.toFixed(2);
    if (abs >= 1e-3) return (v * 1000).toFixed(1) + 'm';
    if (abs >= 1e-6) return (v * 1e6).toFixed(1) + 'μ';
    return v.toExponential(1);
  }

  _formatTime(t) {
    if (t === 0) return '0';
    const abs = Math.abs(t);
    if (abs >= 1) return t.toFixed(2) + 's';
    if (abs >= 1e-3) return (t * 1e3).toFixed(1) + 'ms';
    if (abs >= 1e-6) return (t * 1e6).toFixed(0) + 'μs';
    return t.toExponential(1) + 's';
  }
}
