/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Input / Output Pin Components
   Input:  user-toggleable, drives a value into the circuit
   Output: displays the computed value from the circuit
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE } = L;
  const Port = L.Port;

  const PIN_SIZE = 24;  // square size for pin visual
  const PORT_OFF = PIN_SIZE / 2 + 8;

  /* ── Input Pin ── */
  const INPUT_PIN = {
    type: 'INPUT',
    label: 'Input Pin',
    category: 'Wiring',
    defaultAttrs: { label: '', state: FALSE },
    createPorts() {
      // Single output port on the right
      return [ new Port('out', PORT_OFF, 0, 1) ];
    },
    compute(inputs, attrs) {
      return [ Value.of(attrs.state || FALSE) ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const s = PIN_SIZE;

      // Square body
      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      rect.setAttribute('x', -s / 2);
      rect.setAttribute('y', -s / 2);
      rect.setAttribute('width', s);
      rect.setAttribute('height', s);
      rect.setAttribute('rx', 4);
      rect.setAttribute('fill', comp.attrs.state === TRUE ? '#22c55e' : 'var(--lg-gate-fill, #1e293b)');
      rect.setAttribute('stroke', comp.attrs.state === TRUE ? '#16a34a' : 'var(--lg-gate-stroke, #94a3b8)');
      rect.setAttribute('stroke-width', '1.5');
      rect.classList.add('lg-clickable');
      g.appendChild(rect);

      // Value text
      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0);
      txt.setAttribute('y', 5);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', comp.attrs.state === TRUE ? '#fff' : 'var(--lg-text)');
      txt.setAttribute('font-size', '14');
      txt.setAttribute('font-weight', '600');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = comp.attrs.state === TRUE ? '1' : '0';
      txt.classList.add('lg-clickable');
      g.appendChild(txt);

      // Label below
      if (comp.attrs.label) {
        const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        lbl.setAttribute('x', 0);
        lbl.setAttribute('y', s / 2 + 14);
        lbl.setAttribute('text-anchor', 'middle');
        lbl.setAttribute('fill', 'var(--lg-muted)');
        lbl.setAttribute('font-size', '10');
        lbl.setAttribute('font-family', "'DM Sans', sans-serif");
        lbl.textContent = comp.attrs.label;
        g.appendChild(lbl);
      }
    },
    /* Toggle on click */
    onClick(comp, circuit) {
      comp.attrs.state = comp.attrs.state === TRUE ? FALSE : TRUE;
      circuit.propagate();
    }
  };

  /* ── Output Pin ── */
  const OUTPUT_PIN = {
    type: 'OUTPUT',
    label: 'Output Pin',
    category: 'Wiring',
    defaultAttrs: { label: '' },
    createPorts() {
      // Single input port on the left
      return [ new Port('in', -PORT_OFF, 0, 1) ];
    },
    compute(inputs) {
      // Just pass through — output shows whatever is on its input
      return [];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const s = PIN_SIZE;
      const val = comp.ports[0].value;

      // Circle body
      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      circle.setAttribute('cx', 0);
      circle.setAttribute('cy', 0);
      circle.setAttribute('r', s / 2);
      circle.setAttribute('fill', val.isTrue() ? '#22c55e' : val.isFalse() ? 'var(--lg-gate-fill, #1e293b)' : '#3b82f6');
      circle.setAttribute('stroke', val.isTrue() ? '#16a34a' : val.isFalse() ? 'var(--lg-gate-stroke, #94a3b8)' : '#2563eb');
      circle.setAttribute('stroke-width', '1.5');
      g.appendChild(circle);

      // Value text
      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0);
      txt.setAttribute('y', 5);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', val.isTrue() ? '#fff' : 'var(--lg-text)');
      txt.setAttribute('font-size', '14');
      txt.setAttribute('font-weight', '600');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = val.toString();
      g.appendChild(txt);

      // Label below
      if (comp.attrs.label) {
        const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        lbl.setAttribute('x', 0);
        lbl.setAttribute('y', s / 2 + 14);
        lbl.setAttribute('text-anchor', 'middle');
        lbl.setAttribute('fill', 'var(--lg-muted)');
        lbl.setAttribute('font-size', '10');
        lbl.setAttribute('font-family', "'DM Sans', sans-serif");
        lbl.textContent = comp.attrs.label;
        g.appendChild(lbl);
      }
    }
  };

  L.PIN_TYPES = { INPUT: INPUT_PIN, OUTPUT: OUTPUT_PIN };
})(window.LogicSim);
