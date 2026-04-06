/* ═══════════════════════════════════════════════════════════
   Logic Simulator — I/O Components
   LED (visual output), Button (momentary), Switch (toggle)
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE } = L;
  const Port = L.Port;

  /* ── LED ── */
  const LED = {
    type: 'LED',
    label: 'LED',
    category: 'I/O',
    defaultAttrs: { color: '#22c55e' },

    createPorts() {
      return [ new Port('in', -16, 0, 1) ];
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;
      const val = comp.ports[0].value;
      const on = val.isTrue();
      const c = comp.attrs.color || '#22c55e';

      // Glow
      if (on) {
        const glow = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
        glow.setAttribute('cx', 0); glow.setAttribute('cy', 0);
        glow.setAttribute('r', 14);
        glow.setAttribute('fill', c);
        glow.setAttribute('opacity', '0.2');
        g.appendChild(glow);
      }

      // Body
      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      circle.setAttribute('cx', 0); circle.setAttribute('cy', 0);
      circle.setAttribute('r', 9);
      circle.setAttribute('fill', on ? c : 'var(--lg-gate-fill, #1e293b)');
      circle.setAttribute('stroke', on ? c : 'var(--lg-gate-stroke, #94a3b8)');
      circle.setAttribute('stroke-width', '1.5');
      g.appendChild(circle);

      // Label
      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 0); lbl.setAttribute('y', 22);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '9');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = 'LED';
      g.appendChild(lbl);
    }
  };

  /* ── Button (momentary — HIGH while pressed) ── */
  const BUTTON = {
    type: 'BUTTON',
    label: 'Button',
    category: 'I/O',
    defaultAttrs: { state: FALSE },

    createPorts() {
      return [ new Port('out', 18, 0, 1) ];
    },
    compute(inputs, attrs) {
      return [ Value.of(attrs.state || FALSE) ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const pressed = comp.attrs.state === TRUE;

      // Outer housing
      const outer = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      outer.setAttribute('x', -11); outer.setAttribute('y', -11);
      outer.setAttribute('width', 22); outer.setAttribute('height', 22);
      outer.setAttribute('rx', 3);
      outer.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      outer.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      outer.setAttribute('stroke-width', '1.5');
      g.appendChild(outer);

      // Inner button cap
      const cap = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      cap.setAttribute('cx', 0); cap.setAttribute('cy', 0);
      cap.setAttribute('r', 7);
      cap.setAttribute('fill', pressed ? '#ef4444' : '#64748b');
      cap.setAttribute('stroke', pressed ? '#dc2626' : '#475569');
      cap.setAttribute('stroke-width', '1');
      cap.classList.add('lg-clickable');
      g.appendChild(cap);

      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 0); lbl.setAttribute('y', 24);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '9');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = 'BTN';
      g.appendChild(lbl);
    },

    /* Momentary: HIGH on press, LOW on release */
    onMouseDown(comp, circuit) {
      comp.attrs.state = TRUE;
      circuit.propagate();
    },
    onMouseUp(comp, circuit) {
      comp.attrs.state = FALSE;
      circuit.propagate();
    }
  };

  /* ── Switch (toggle on click) ── */
  const SWITCH = {
    type: 'SWITCH',
    label: 'Switch',
    category: 'I/O',
    defaultAttrs: { state: FALSE },

    createPorts() {
      return [ new Port('out', 20, 0, 1) ];
    },
    compute(inputs, attrs) {
      return [ Value.of(attrs.state || FALSE) ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const on = comp.attrs.state === TRUE;

      // Track
      const track = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      track.setAttribute('x', -14); track.setAttribute('y', -7);
      track.setAttribute('width', 28); track.setAttribute('height', 14);
      track.setAttribute('rx', 7);
      track.setAttribute('fill', on ? '#22c55e' : '#334155');
      track.setAttribute('stroke', on ? '#16a34a' : '#475569');
      track.setAttribute('stroke-width', '1');
      track.classList.add('lg-clickable');
      g.appendChild(track);

      // Knob
      const knob = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      knob.setAttribute('cx', on ? 7 : -7);
      knob.setAttribute('cy', 0);
      knob.setAttribute('r', 5);
      knob.setAttribute('fill', '#fff');
      knob.classList.add('lg-clickable');
      g.appendChild(knob);

      // Label
      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 0); lbl.setAttribute('y', 20);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '9');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = on ? 'ON' : 'OFF';
      g.appendChild(lbl);
    },

    onClick(comp, circuit) {
      comp.attrs.state = comp.attrs.state === TRUE ? FALSE : TRUE;
      circuit.propagate();
    }
  };

  L.IO_TYPES = { LED, BUTTON, SWITCH };
})(window.LogicSim);
