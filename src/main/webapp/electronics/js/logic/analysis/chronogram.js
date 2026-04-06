/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Timing Diagram (Chronogram) — Phase 7
   Records signal changes over time, renders waveforms in a
   panel below or beside the canvas.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR } = L;

  /* ═══════════ Signal Recorder ═══════════ */
  class SignalRecorder {
    constructor(circuit) {
      this.circuit   = circuit;
      this.signals   = new Map(); // id → { name, history: [{ tick, value }] }
      this.tick      = 0;
      this.recording = false;
      this.maxTicks  = 500;
      this._watched  = [];  // [{ id, name, portIdx, getValue }]
    }

    /* Add a signal to watch */
    watch(compId, name, portIdx) {
      const key = compId + ':' + portIdx;
      if (this.signals.has(key)) return;
      this.signals.set(key, { name, history: [] });
      this._watched.push({
        id: key, compId, name, portIdx,
        getValue: () => {
          const comp = this.circuit.components.get(compId);
          if (!comp || !comp.ports[portIdx]) return UNKNOWN;
          return comp.ports[portIdx].value.get(0);
        }
      });
    }

    /* Auto-watch all INPUT and OUTPUT pins */
    watchAllPins() {
      for (const comp of this.circuit.components.values()) {
        if (comp.type === 'INPUT') {
          const name = comp.attrs.label || comp.id;
          this.watch(comp.id, name, 0);
        } else if (comp.type === 'OUTPUT') {
          const name = comp.attrs.label || comp.id;
          this.watch(comp.id, name, 0);
        }
      }
    }

    /* Remove all watches and clear history */
    clear() {
      this.signals.clear();
      this._watched = [];
      this.tick = 0;
    }

    /* Sample current values — call after each propagation */
    sample() {
      if (!this.recording) return;
      this.tick++;
      for (const w of this._watched) {
        const sig = this.signals.get(w.id);
        if (!sig) continue;
        const val = w.getValue();
        const hist = sig.history;
        // Only record on change (RLE compression)
        if (hist.length === 0 || hist[hist.length - 1].value !== val) {
          hist.push({ tick: this.tick, value: val });
        }
        // Trim old
        if (hist.length > this.maxTicks) hist.splice(0, hist.length - this.maxTicks);
      }
    }

    start() {
      this.recording = true;
      // Take initial snapshot
      for (const w of this._watched) {
        const sig = this.signals.get(w.id);
        if (sig && sig.history.length === 0) {
          sig.history.push({ tick: this.tick, value: w.getValue() });
        }
      }
    }

    stop() { this.recording = false; }

    reset() {
      this.tick = 0;
      this.signals.clear();
      this._watched = [];
    }

    /* Get ordered signal list */
    getSignals() {
      const list = [];
      for (const [id, sig] of this.signals) {
        list.push({ id, name: sig.name, history: sig.history });
      }
      return list;
    }
  }

  /* ═══════════ Chronogram Renderer ═══════════ */
  class ChronogramRenderer {
    constructor(container) {
      this.container = container;
      this.zoom      = 4;    // pixels per tick
      this.sigHeight = 28;   // height per signal
      this.scrollX   = 0;
    }

    render(recorder) {
      const signals = recorder.getSignals();
      if (signals.length === 0) {
        this.container.innerHTML = '<div style="color:var(--lg-muted);padding:12px;font-size:12px;">No signals. Click <b>Record</b> to start, then toggle inputs or run a clock.</div>';
        return;
      }

      const maxTick = recorder.tick;
      const visibleWidth = this.container.clientWidth - 80;
      const totalWidth = Math.max(maxTick * this.zoom, visibleWidth);

      let html = '<div class="lg-chrono-wrap">';

      // Signal labels (left column)
      html += '<div class="lg-chrono-labels">';
      signals.forEach(s => {
        html += '<div class="lg-chrono-label" style="height:' + this.sigHeight + 'px;">' + _esc(s.name) + '</div>';
      });
      html += '</div>';

      // Waveforms (right scrollable area)
      html += '<div class="lg-chrono-waves" id="chronoWaves" style="overflow-x:auto;">';
      html += '<svg width="' + totalWidth + '" height="' + (signals.length * this.sigHeight) + '" xmlns="http://www.w3.org/2000/svg">';

      // Grid lines every 10 ticks
      for (let t = 0; t <= maxTick; t += 10) {
        const x = t * this.zoom;
        html += '<line x1="' + x + '" y1="0" x2="' + x + '" y2="' + (signals.length * this.sigHeight) + '" stroke="var(--lg-border)" stroke-width="0.5" stroke-dasharray="2 2"/>';
        if (t % 50 === 0) {
          html += '<text x="' + (x + 2) + '" y="10" fill="var(--lg-muted)" font-size="8" font-family="\'Fira Code\',monospace">' + t + '</text>';
        }
      }

      // Waveforms
      signals.forEach((sig, si) => {
        const y0 = si * this.sigHeight;
        const yHigh = y0 + 4;
        const yLow  = y0 + this.sigHeight - 4;
        const yMid  = y0 + this.sigHeight / 2;

        html += '<line x1="0" y1="' + (y0 + this.sigHeight) + '" x2="' + totalWidth + '" y2="' + (y0 + this.sigHeight) + '" stroke="var(--lg-border)" stroke-width="0.5"/>';

        if (sig.history.length > 0) {
          const hist = sig.history;

          // Per-segment coloring: each value segment gets its own color
          // Build segment paths for each history entry with its own color
          for (let i = 0; i < hist.length; i++) {
            const sx = hist[i].tick * this.zoom;
            const snx = (i + 1 < hist.length) ? hist[i + 1].tick * this.zoom : maxTick * this.zoom;
            const val = hist[i].value;
            let sy;
            if (val === TRUE) sy = yHigh; else if (val === FALSE) sy = yLow; else sy = yMid;
            // Vertical transition from previous level + horizontal segment
            let segD = '';
            if (i === 0) {
              segD = 'M' + sx + ',' + sy + ' L' + snx + ',' + sy;
            } else {
              const px = sx; // transition point
              segD = 'M' + px + ',' + sy + ' L' + snx + ',' + sy;
            }
            html += '<path d="' + segD + '" fill="none" stroke="' + _sigColor(val) + '" stroke-width="1.5"/>';
          }
          // Vertical transition lines (drawn separately for crispness)
          for (let i = 1; i < hist.length; i++) {
            const tx = hist[i].tick * this.zoom;
            const prevVal = hist[i - 1].value;
            const curVal = hist[i].value;
            let py = prevVal === TRUE ? yHigh : prevVal === FALSE ? yLow : yMid;
            let cy = curVal === TRUE ? yHigh : curVal === FALSE ? yLow : yMid;
            if (py !== cy) {
              html += '<line x1="' + tx + '" y1="' + py + '" x2="' + tx + '" y2="' + cy + '" stroke="' + _sigColor(curVal) + '" stroke-width="1.5"/>';
            }
          }

          // Unknown/error hatching
          for (let i = 0; i < hist.length; i++) {
            const val = hist[i].value;
            if (val === UNKNOWN || val === ERROR) {
              const x1 = hist[i].tick * this.zoom;
              const x2 = (i + 1 < hist.length) ? hist[i + 1].tick * this.zoom : maxTick * this.zoom;
              html += '<rect x="' + x1 + '" y="' + (yHigh - 1) + '" width="' + (x2 - x1) + '" height="' + (yLow - yHigh + 2) + '" fill="' + (val === ERROR ? 'rgba(239,68,68,.1)' : 'rgba(59,130,246,.08)') + '"/>';
            }
          }
        }
      });

      html += '</svg></div></div>';

      this.container.innerHTML = html;

      // Auto-scroll to right
      const waves = document.getElementById('chronoWaves');
      if (waves) waves.scrollLeft = waves.scrollWidth;
    }
  }

  function _sigColor(val) {
    if (val === TRUE)  return '#22c55e';
    if (val === FALSE) return '#64748b';
    if (val === ERROR) return '#ef4444';
    return '#3b82f6';
  }

  function _esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;'); }

  L.SignalRecorder      = SignalRecorder;
  L.ChronogramRenderer  = ChronogramRenderer;
})(window.LogicSim);
