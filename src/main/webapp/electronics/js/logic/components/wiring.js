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

  L.WIRING_TYPES = {
    CONSTANT: CONSTANT,
    PROBE: PROBE,
    TUNNEL_SRC: TUNNEL_SOURCE,
    TUNNEL_TGT: TUNNEL_TARGET
  };
})(window.LogicSim);
