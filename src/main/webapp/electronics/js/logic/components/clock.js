/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Clock Source
   Auto-toggling output with configurable period.
   Click to start/stop. Double-click to manually tick once.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE } = L;
  const Port = L.Port;
  const SIZE = 24;
  const PORT_OFF = SIZE / 2 + 8;

  const CLOCK = {
    type: 'CLOCK',
    label: 'Clock',
    category: 'Wiring',
    defaultAttrs: { state: FALSE, running: false, period: 500 },

    createPorts() {
      return [ new Port('out', PORT_OFF, 0, 1) ];
    },

    compute(inputs, attrs) {
      return [ Value.of(attrs.state || FALSE) ];
    },

    render(comp, ctx) {
      const g = ctx.group;
      const s = SIZE;
      const running = comp.attrs.running;

      // Body
      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      rect.setAttribute('x', -s / 2); rect.setAttribute('y', -s / 2);
      rect.setAttribute('width', s);   rect.setAttribute('height', s);
      rect.setAttribute('rx', 4);
      rect.setAttribute('fill', running ? '#7c3aed' : 'var(--lg-gate-fill, #1e293b)');
      rect.setAttribute('stroke', running ? '#6d28d9' : 'var(--lg-gate-stroke, #94a3b8)');
      rect.setAttribute('stroke-width', '1.5');
      rect.classList.add('lg-clickable');
      g.appendChild(rect);

      // Clock wave icon
      const wave = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      const w = 6, h = 5;
      wave.setAttribute('d', `M${-w},-1 L${-w},${-h} L0,${-h} L0,${h} L${w},${h} L${w},-1`);
      wave.setAttribute('fill', 'none');
      wave.setAttribute('stroke', running ? '#fff' : 'var(--lg-text)');
      wave.setAttribute('stroke-width', '1.5');
      wave.setAttribute('stroke-linecap', 'round');
      wave.setAttribute('stroke-linejoin', 'round');
      g.appendChild(wave);

      // Label
      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 0); lbl.setAttribute('y', s / 2 + 13);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '9');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = running ? comp.attrs.period + 'ms' : 'CLK';
      g.appendChild(lbl);
    },

    onClick(comp, circuit) {
      if (comp._clockInterval) {
        clearInterval(comp._clockInterval);
        comp._clockInterval = null;
        comp.attrs.running = false;
      } else {
        comp.attrs.running = true;
        comp._clockInterval = setInterval(() => {
          comp.attrs.state = comp.attrs.state === TRUE ? FALSE : TRUE;
          circuit.propagate();
        }, comp.attrs.period || 500);
      }
      circuit.propagate();
    },

    dispose(comp) {
      if (comp._clockInterval) {
        clearInterval(comp._clockInterval);
        comp._clockInterval = null;
      }
      comp.attrs.running = false;
    }
  };

  L.CLOCK_TYPE = CLOCK;
})(window.LogicSim);
