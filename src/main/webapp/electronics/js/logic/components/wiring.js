/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Wiring Components
   Constant (0/1/X), Probe, Tunnel (source/target pair)
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN } = L;
  const Port = L.Port;

  /* ── Constant ── */
  const CONSTANT = {
    type: 'CONSTANT',
    label: 'Constant',
    category: 'Wiring',
    defaultAttrs: { value: TRUE },

    createPorts() {
      return [ new Port('out', 16, 0, 1) ];
    },
    compute(inputs, attrs) {
      return [ Value.of(attrs.value != null ? attrs.value : TRUE) ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const v = comp.attrs.value;
      const label = v === TRUE ? '1' : v === FALSE ? '0' : 'X';
      const color = v === TRUE ? '#22c55e' : v === FALSE ? '#64748b' : '#3b82f6';

      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      rect.setAttribute('x', -10); rect.setAttribute('y', -10);
      rect.setAttribute('width', 20); rect.setAttribute('height', 20);
      rect.setAttribute('rx', 3);
      rect.setAttribute('fill', color);
      rect.setAttribute('stroke', 'none');
      rect.classList.add('lg-clickable');
      g.appendChild(rect);

      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0); txt.setAttribute('y', 5);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', '#fff');
      txt.setAttribute('font-size', '13');
      txt.setAttribute('font-weight', '700');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = label;
      txt.classList.add('lg-clickable');
      g.appendChild(txt);
    },
    onClick(comp, circuit) {
      // Cycle: 1 → 0 → X → 1
      if (comp.attrs.value === TRUE) comp.attrs.value = FALSE;
      else if (comp.attrs.value === FALSE) comp.attrs.value = UNKNOWN;
      else comp.attrs.value = TRUE;
      circuit.propagate();
    }
  };

  /* ── Probe (value display) ── */
  const PROBE = {
    type: 'PROBE',
    label: 'Probe',
    category: 'Wiring',
    defaultAttrs: { label: '' },

    createPorts() {
      return [ new Port('in', -14, 0, 1) ];
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;
      const val = comp.ports[0].value;
      const label = val.toString();
      const color = val.color();

      // Diamond shape
      const diamond = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      diamond.setAttribute('d', 'M-8,0 L0,-8 L8,0 L0,8 Z');
      diamond.setAttribute('fill', color);
      diamond.setAttribute('stroke', 'none');
      diamond.setAttribute('opacity', '0.25');
      g.appendChild(diamond);

      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0); txt.setAttribute('y', 5);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', color);
      txt.setAttribute('font-size', '13');
      txt.setAttribute('font-weight', '700');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = label;
      g.appendChild(txt);

      if (comp.attrs.label) {
        const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        lbl.setAttribute('x', 0); lbl.setAttribute('y', -12);
        lbl.setAttribute('text-anchor', 'middle');
        lbl.setAttribute('fill', 'var(--lg-muted)');
        lbl.setAttribute('font-size', '9');
        lbl.setAttribute('font-family', "'DM Sans', sans-serif");
        lbl.textContent = comp.attrs.label;
        g.appendChild(lbl);
      }
    }
  };

  /* ── Pull Resistor (weak pull-up or pull-down) ── */
  // Outputs a weak signal that can be overridden by any active driver.
  // In our 1-bit simulator, it acts like a default value provider:
  // - Pull-up: outputs HIGH unless overridden
  // - Pull-down: outputs LOW unless overridden
  const PULL_RESISTOR = {
    type: 'PULL_RESISTOR',
    label: 'Pull Resistor',
    category: 'Wiring',
    defaultAttrs: { pullTo: 1 },  // 1 = pull-up (HIGH), 0 = pull-down (LOW)

    createPorts() {
      return [ new Port('out', 0, 16, 1) ];
    },

    compute(inputs, attrs) {
      return [ Value.of(attrs.pullTo ? TRUE : FALSE) ];
    },

    render(comp, ctx) {
      const g = ctx.group;
      const isPullUp = comp.attrs.pullTo !== 0;

      // Resistor zigzag symbol
      const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      path.setAttribute('d', isPullUp
        ? 'M0,-10 L0,-6 L-4,-4 L4,-1 L-4,2 L4,5 L-4,8 L0,10 L0,14'  // pull-up: power on top
        : 'M0,14 L0,10 L-4,8 L4,5 L-4,2 L4,-1 L-4,-4 L0,-6 L0,-10'  // pull-down: ground on top
      );
      path.setAttribute('fill', 'none');
      path.setAttribute('stroke', 'var(--lg-wire, #475569)');
      path.setAttribute('stroke-width', '1.5');
      path.setAttribute('stroke-linejoin', 'round');
      g.appendChild(path);

      // Power/ground symbol at top
      const sym = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      sym.setAttribute('x', 0);
      sym.setAttribute('y', isPullUp ? -14 : -14);
      sym.setAttribute('text-anchor', 'middle');
      sym.setAttribute('fill', isPullUp ? 'var(--lg-success, #22c55e)' : 'var(--lg-text-dim, #94a3b8)');
      sym.setAttribute('font-size', '10');
      sym.setAttribute('font-weight', '700');
      sym.setAttribute('font-family', "'Fira Code', monospace");
      sym.textContent = isPullUp ? 'VCC' : 'GND';
      sym.classList.add('lg-clickable');
      g.appendChild(sym);
    },

    onClick(comp, circuit) {
      // Toggle between pull-up and pull-down
      comp.attrs.pullTo = comp.attrs.pullTo ? 0 : 1;
      circuit.propagate();
    }
  };

  /* ── Tunnel Source (receives value, broadcasts by name) ── */
  const TUNNEL_SOURCE = {
    type: 'TUNNEL_SRC',
    label: 'Tunnel In',
    category: 'Wiring',
    defaultAttrs: { name: 'A' },
    isTunnelSource: true,

    createPorts() {
      return [ new Port('in', -18, 0, 1) ];
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;
      // Arrow pointing right (into tunnel)
      const arrow = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      arrow.setAttribute('d', 'M-10,-8 L6,-8 L12,0 L6,8 L-10,8 Z');
      arrow.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      arrow.setAttribute('stroke', 'var(--lg-accent)');
      arrow.setAttribute('stroke-width', '1');
      arrow.classList.add('lg-clickable');
      g.appendChild(arrow);

      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0); txt.setAttribute('y', 4);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', 'var(--lg-accent)');
      txt.setAttribute('font-size', '10');
      txt.setAttribute('font-weight', '600');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = comp.attrs.name || '?';
      txt.classList.add('lg-clickable');
      g.appendChild(txt);
    },
    onClick(comp, circuit) {
      const name = prompt('Tunnel name:', comp.attrs.name || 'A');
      if (name != null && name.trim()) {
        comp.attrs.name = name.trim();
        circuit.propagate();
      }
    }
  };

  /* ── Tunnel Target (outputs value from matching source) ── */
  const TUNNEL_TARGET = {
    type: 'TUNNEL_TGT',
    label: 'Tunnel Out',
    category: 'Wiring',
    defaultAttrs: { name: 'A' },
    isTunnelTarget: true,

    createPorts() {
      return [ new Port('out', 18, 0, 1) ];
    },
    compute(inputs, attrs) {
      // Value is injected by circuit.propagateTunnels()
      return [ Value.of(attrs._tunnelValue != null ? attrs._tunnelValue : L.UNKNOWN) ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      // Arrow pointing right (out of tunnel)
      const arrow = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      arrow.setAttribute('d', 'M-12,-8 L4,-8 L10,0 L4,8 L-12,8 Z');
      arrow.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      arrow.setAttribute('stroke', 'var(--lg-accent)');
      arrow.setAttribute('stroke-width', '1');
      arrow.classList.add('lg-clickable');
      g.appendChild(arrow);

      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', -1); txt.setAttribute('y', 4);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', 'var(--lg-accent)');
      txt.setAttribute('font-size', '10');
      txt.setAttribute('font-weight', '600');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = comp.attrs.name || '?';
      txt.classList.add('lg-clickable');
      g.appendChild(txt);
    },
    onClick(comp, circuit) {
      const name = prompt('Tunnel name:', comp.attrs.name || 'A');
      if (name != null && name.trim()) {
        comp.attrs.name = name.trim();
        circuit.propagate();
      }
    }
  };

  /* ── Splitter (fan-out / fan-in bus node) ── */
  // In our 1-bit simulator, a splitter acts as a distribution/collection node:
  // - Fan-out mode (default): 1 combined input → N split outputs (all carry same value)
  // - Fan-in mode: N split inputs → 1 combined output (OR of all inputs)
  // Configurable via attrs.fanout (2-8) and attrs.mode ('out' or 'in')
  const SPLITTER = {
    type: 'SPLITTER',
    label: 'Splitter',
    category: 'Wiring',
    defaultAttrs: { fanout: 2, mode: 'out' },

    createPorts(attrs) {
      const n = Math.max(2, Math.min(8, attrs.fanout || 2));
      const isOut = (attrs.mode !== 'in');
      const ports = [];

      if (isOut) {
        // Fan-out: 1 input (combined) → N outputs (split)
        ports.push(new Port('in', -20, 0, 1));  // combined input
        const totalH = (n - 1) * 14;
        for (let i = 0; i < n; i++) {
          ports.push(new Port('out', 20, -totalH / 2 + i * 14, 1));
        }
      } else {
        // Fan-in: N inputs (split) → 1 output (combined)
        const totalH = (n - 1) * 14;
        for (let i = 0; i < n; i++) {
          ports.push(new Port('in', -20, -totalH / 2 + i * 14, 1));
        }
        ports.push(new Port('out', 20, 0, 1));  // combined output
      }
      return ports;
    },

    compute(inputs, attrs) {
      const n = Math.max(2, Math.min(8, attrs.fanout || 2));
      const isOut = (attrs.mode !== 'in');

      if (isOut) {
        // Fan-out: replicate input to all outputs
        const val = inputs[0];
        const outputs = [];
        for (let i = 0; i < n; i++) outputs.push(val);
        return outputs;
      } else {
        // Fan-in: OR all inputs
        let result = inputs[0];
        for (let i = 1; i < inputs.length; i++) {
          const a = result.get(0), b = inputs[i].get(0);
          if (a === TRUE || b === TRUE) result = Value.of(TRUE);
          else if (a === UNKNOWN || b === UNKNOWN) result = Value.of(UNKNOWN);
          else result = Value.of(FALSE);
        }
        return [result];
      }
    },

    render(comp, ctx) {
      const g = ctx.group;
      const n = Math.max(2, Math.min(8, comp.attrs.fanout || 2));
      const isOut = (comp.attrs.mode !== 'in');
      const totalH = (n - 1) * 14;

      // Draw spine (vertical line)
      const spine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      spine.setAttribute('x1', 0);
      spine.setAttribute('y1', -totalH / 2);
      spine.setAttribute('x2', 0);
      spine.setAttribute('y2', totalH / 2);
      spine.setAttribute('stroke', 'var(--lg-wire, #475569)');
      spine.setAttribute('stroke-width', '2');
      g.appendChild(spine);

      // Draw combined port side (thicker line to body)
      const combX = isOut ? -20 : 20;
      const combLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      combLine.setAttribute('x1', combX);
      combLine.setAttribute('y1', 0);
      combLine.setAttribute('x2', 0);
      combLine.setAttribute('y2', 0);
      combLine.setAttribute('stroke', 'var(--lg-wire, #475569)');
      combLine.setAttribute('stroke-width', '3');
      g.appendChild(combLine);

      // Draw split lines
      const splitX = isOut ? 20 : -20;
      for (let i = 0; i < n; i++) {
        const y = -totalH / 2 + i * 14;
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', 0);
        line.setAttribute('y1', y);
        line.setAttribute('x2', splitX);
        line.setAttribute('y2', y);
        line.setAttribute('stroke', 'var(--lg-wire, #475569)');
        line.setAttribute('stroke-width', '1.5');
        g.appendChild(line);

        // Bit index label
        const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        txt.setAttribute('x', splitX > 0 ? splitX - 5 : splitX + 5);
        txt.setAttribute('y', y + 3);
        txt.setAttribute('text-anchor', splitX > 0 ? 'end' : 'start');
        txt.setAttribute('fill', 'var(--lg-text-dim, #94a3b8)');
        txt.setAttribute('font-size', '7');
        txt.setAttribute('font-family', "'Fira Code', monospace");
        txt.textContent = '' + i;
        g.appendChild(txt);
      }

      // Fanout label
      const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      label.setAttribute('x', 0);
      label.setAttribute('y', totalH / 2 + 12);
      label.setAttribute('text-anchor', 'middle');
      label.setAttribute('fill', 'var(--lg-text-dim, #94a3b8)');
      label.setAttribute('font-size', '8');
      label.setAttribute('font-family', "'Fira Code', monospace");
      label.textContent = n + '-bit';
      label.classList.add('lg-clickable');
      g.appendChild(label);
    },

    onClick(comp, circuit) {
      const n = prompt('Fan-out count (2-8):', comp.attrs.fanout || 2);
      if (n != null) {
        const val = Math.max(2, Math.min(8, parseInt(n) || 2));
        if (val !== comp.attrs.fanout) {
          // Remove and re-add with new fanout (ports change)
          const x = comp.x, y = comp.y;
          const attrs = Object.assign({}, comp.attrs, { fanout: val });
          circuit.removeComponent(comp.id);
          circuit.addComponent(SPLITTER, x, y, attrs);
        }
      }
    }
  };

  L.WIRING_TYPES = {
    CONSTANT: CONSTANT,
    PROBE: PROBE,
    TUNNEL_SRC: TUNNEL_SOURCE,
    TUNNEL_TGT: TUNNEL_TARGET,
    SPLITTER: SPLITTER,
    PULL_RESISTOR: PULL_RESISTOR
  };
})(window.LogicSim);
