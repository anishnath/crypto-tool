/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Display Components (Phase 5)
   7-Segment, Hex Display, LED Bar, Keyboard, TTY
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic } = L;
  const Port = L.Port;

  const PE = 8;

  /* ── 7-Segment Display ── */
  // Segment layout:  aaa
  //                 f   b
  //                  ggg
  //                 e   c
  //                  ddd  .dp
  const SEG_PATHS = {
    a: 'M4,0 L26,0 L23,3 L7,3 Z',
    b: 'M27,1 L27,13 L24,11 L24,4 Z',
    c: 'M27,15 L27,27 L24,24 L24,17 Z',
    d: 'M4,28 L26,28 L23,25 L7,25 Z',
    e: 'M3,15 L3,27 L6,24 L6,17 Z',
    f: 'M3,1 L3,13 L6,11 L6,4 Z',
    g: 'M4,14 L26,14 L23,12 L7,12 Z',
  };

  const SEVEN_SEG = {
    type: 'SEVEN_SEG',
    label: '7-Segment',
    category: 'Displays',
    defaultAttrs: {},
    createPorts() {
      // a, b, c, d, e, f, g → (no outputs)
      const ports = [];
      for (let i = 0; i < 7; i++)
        ports.push(new Port('in', -(15 + PE), -24 + i * 8, 1));
      return ports;
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;
      const segNames = ['a','b','c','d','e','f','g'];

      // Background
      const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bg.setAttribute('x', -2); bg.setAttribute('y', -4);
      bg.setAttribute('width', 34); bg.setAttribute('height', 36);
      bg.setAttribute('rx', 3);
      bg.setAttribute('fill', '#0f1117');
      bg.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bg.setAttribute('stroke-width', '1');
      g.appendChild(bg);

      // Segments
      segNames.forEach((name, i) => {
        const on = comp.ports[i].value.isTrue();
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', SEG_PATHS[name]);
        path.setAttribute('fill', on ? '#ef4444' : '#1a1d24');
        path.setAttribute('opacity', on ? '1' : '0.15');
        g.appendChild(path);
      });

      // Port stubs
      comp.ports.forEach(p => {
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', -15); line.setAttribute('y1', p.ry);
        line.setAttribute('x2', p.rx); line.setAttribute('y2', p.ry);
        line.setAttribute('stroke', p.value.color());
        line.setAttribute('stroke-width', '1.5');
        g.appendChild(line);
      });

      // Label
      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 15); lbl.setAttribute('y', 46);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '8');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = '7-SEG';
      g.appendChild(lbl);
    }
  };

  /* ── Hex Display (4-bit input → auto-decoded 7-segment) ── */
  const HEX_DECODE = [
    0x7E,0x30,0x6D,0x79,0x33,0x5B,0x5F,0x70, // 0-7
    0x7F,0x7B,0x77,0x1F,0x4E,0x3D,0x4F,0x47   // 8-F
  ];

  const HEX_DISPLAY = {
    type: 'HEX_DISPLAY',
    label: 'Hex Display',
    category: 'Displays',
    defaultAttrs: {},
    createPorts() {
      // D0, D1, D2, D3 → (no outputs)
      const ports = [];
      for (let i = 0; i < 4; i++)
        ports.push(new Port('in', -(15 + PE), -12 + i * 8, 1));
      return ports;
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;

      // Decode 4-bit input
      let val = 0, hasUnknown = false;
      for (let i = 0; i < 4; i++) {
        const s = comp.ports[i].value.get(0);
        if (s === UNKNOWN || s === ERROR) { hasUnknown = true; break; }
        if (s === TRUE) val |= (1 << i);
      }
      const segs = hasUnknown ? 0 : HEX_DECODE[val];

      // Background
      const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bg.setAttribute('x', -2); bg.setAttribute('y', -4);
      bg.setAttribute('width', 34); bg.setAttribute('height', 36);
      bg.setAttribute('rx', 3);
      bg.setAttribute('fill', '#0f1117');
      bg.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bg.setAttribute('stroke-width', '1');
      g.appendChild(bg);

      // Segments (same paths as 7-seg)
      ['a','b','c','d','e','f','g'].forEach((name, i) => {
        const on = !!(segs & (1 << (6 - i)));
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', SEG_PATHS[name]);
        path.setAttribute('fill', on ? '#22c55e' : '#1a1d24');
        path.setAttribute('opacity', on ? '1' : '0.15');
        g.appendChild(path);
      });

      // Hex value text
      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 15); txt.setAttribute('y', 46);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', hasUnknown ? '#3b82f6' : '#22c55e');
      txt.setAttribute('font-size', '10');
      txt.setAttribute('font-weight', '600');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = hasUnknown ? '?' : val.toString(16).toUpperCase();
      g.appendChild(txt);

      // Port stubs
      comp.ports.forEach(p => {
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', -15); line.setAttribute('y1', p.ry);
        line.setAttribute('x2', p.rx); line.setAttribute('y2', p.ry);
        line.setAttribute('stroke', p.value.color());
        line.setAttribute('stroke-width', '1.5');
        g.appendChild(line);
      });
    }
  };

  /* ── LED Bar Graph (8-bit) ── */
  const LED_BAR = {
    type: 'LED_BAR',
    label: 'LED Bar (8)',
    category: 'Displays',
    defaultAttrs: {},
    createPorts() {
      const ports = [];
      for (let i = 0; i < 8; i++)
        ports.push(new Port('in', -(12 + PE), -28 + i * 8, 1));
      return ports;
    },
    compute() { return []; },
    render(comp, ctx) {
      const g = ctx.group;
      const colors = ['#ef4444','#f97316','#eab308','#22c55e','#22c55e','#06b6d4','#3b82f6','#8b5cf6'];

      // Background
      const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bg.setAttribute('x', -6); bg.setAttribute('y', -32);
      bg.setAttribute('width', 18); bg.setAttribute('height', 64);
      bg.setAttribute('rx', 3);
      bg.setAttribute('fill', '#0f1117');
      bg.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bg.setAttribute('stroke-width', '1');
      g.appendChild(bg);

      // LEDs
      for (let i = 0; i < 8; i++) {
        const on = comp.ports[i].value.isTrue();
        const y = -28 + i * 8;
        const led = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
        led.setAttribute('x', -3); led.setAttribute('y', y - 2.5);
        led.setAttribute('width', 12); led.setAttribute('height', 5);
        led.setAttribute('rx', 1);
        led.setAttribute('fill', on ? colors[i] : '#1a1d24');
        led.setAttribute('opacity', on ? '1' : '0.2');
        g.appendChild(led);
      }

      // Port stubs
      comp.ports.forEach(p => {
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', -12); line.setAttribute('y1', p.ry);
        line.setAttribute('x2', p.rx); line.setAttribute('y2', p.ry);
        line.setAttribute('stroke', p.value.color());
        line.setAttribute('stroke-width', '1.5');
        g.appendChild(line);
      });
    }
  };

  /* ── Hex Keyboard (0-F output) ── */
  const KEYBOARD = {
    type: 'KEYBOARD',
    label: 'Hex Keypad',
    category: 'Displays',
    defaultAttrs: { _key: -1 },  // -1 = no key pressed
    createPorts() {
      // Outputs: D0, D1, D2, D3, VALID
      const ports = [];
      for (let i = 0; i < 5; i++)
        ports.push(new Port('out', 20 + PE, -16 + i * 8, 1));
      return ports;
    },
    compute(inputs, attrs) {
      const k = attrs._key;
      if (k < 0 || k > 15) {
        return [Value.of(FALSE), Value.of(FALSE), Value.of(FALSE), Value.of(FALSE), Value.of(FALSE)];
      }
      return [
        Value.of(k & 1 ? TRUE : FALSE),
        Value.of(k & 2 ? TRUE : FALSE),
        Value.of(k & 4 ? TRUE : FALSE),
        Value.of(k & 8 ? TRUE : FALSE),
        Value.of(TRUE),  // VALID
      ];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const keys = '0123456789ABCDEF';
      const pressed = comp.attrs._key;

      // Background
      const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bg.setAttribute('x', -26); bg.setAttribute('y', -26);
      bg.setAttribute('width', 52); bg.setAttribute('height', 52);
      bg.setAttribute('rx', 4);
      bg.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      bg.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bg.setAttribute('stroke-width', '1.5');
      g.appendChild(bg);

      // 4×4 key grid
      for (let row = 0; row < 4; row++) {
        for (let col = 0; col < 4; col++) {
          const idx = row * 4 + col;
          const kx = -22 + col * 11;
          const ky = -22 + row * 11;
          const isPressed = idx === pressed;

          const btn = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
          btn.setAttribute('x', kx); btn.setAttribute('y', ky);
          btn.setAttribute('width', 9); btn.setAttribute('height', 9);
          btn.setAttribute('rx', 1.5);
          btn.setAttribute('fill', isPressed ? 'var(--lg-accent)' : '#334155');
          btn.setAttribute('stroke', isPressed ? 'var(--lg-accent)' : '#475569');
          btn.setAttribute('stroke-width', '0.5');
          g.appendChild(btn);

          const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
          txt.setAttribute('x', kx + 4.5); txt.setAttribute('y', ky + 7);
          txt.setAttribute('text-anchor', 'middle');
          txt.setAttribute('fill', isPressed ? '#fff' : '#94a3b8');
          txt.setAttribute('font-size', '6');
          txt.setAttribute('font-weight', '600');
          txt.setAttribute('font-family', "'Fira Code', monospace");
          txt.textContent = keys[idx];
          g.appendChild(txt);
        }
      }

      // Port stubs + labels
      const labels = ['D0','D1','D2','D3','OK'];
      comp.ports.forEach((p, i) => {
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', 20); line.setAttribute('y1', p.ry);
        line.setAttribute('x2', p.rx); line.setAttribute('y2', p.ry);
        line.setAttribute('stroke', p.value.color());
        line.setAttribute('stroke-width', '1.5');
        g.appendChild(line);

        const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        lbl.setAttribute('x', 18); lbl.setAttribute('y', p.ry + 3);
        lbl.setAttribute('text-anchor', 'end');
        lbl.setAttribute('fill', 'var(--lg-muted)');
        lbl.setAttribute('font-size', '7');
        lbl.setAttribute('font-family', "'Fira Code', monospace");
        lbl.textContent = labels[i] || '';
        g.appendChild(lbl);
      });
    },
    onClick(comp, circuit) {
      const key = prompt('Enter hex key (0-F), or empty to clear:', '');
      if (key === null) return;
      if (key.trim() === '') { comp.attrs._key = -1; }
      else {
        const v = parseInt(key.trim(), 16);
        comp.attrs._key = (v >= 0 && v <= 15) ? v : -1;
      }
      circuit.propagate();
    }
  };

  /* ── TTY (8-bit ASCII + CLK → text display) ── */
  const TTY = {
    type: 'TTY',
    label: 'TTY Display',
    category: 'Displays',
    defaultAttrs: { _text: '', _prevClk: UNKNOWN },
    createPorts() {
      // D0-D6 (7-bit ASCII) + CLK → (no outputs)
      const ports = [];
      for (let i = 0; i < 7; i++)
        ports.push(new Port('in', -(30 + PE), -24 + i * 8, 1));
      ports.push(new Port('in', -(30 + PE), 32, 1)); // CLK
      return ports;
    },
    compute(inputs, attrs) {
      const clk = inputs[7];
      const prev = attrs._prevClk;
      const cur = clk.get(0);
      attrs._prevClk = cur;

      // Rising edge → capture ASCII
      if (prev === FALSE && cur === TRUE) {
        let code = 0;
        for (let i = 0; i < 7; i++) {
          if (inputs[i].get(0) === TRUE) code |= (1 << i);
        }
        if (code >= 32 && code < 127) {
          attrs._text = (attrs._text || '') + String.fromCharCode(code);
          // Limit to 64 chars
          if (attrs._text.length > 64) attrs._text = attrs._text.slice(-64);
        } else if (code === 10 || code === 13) {
          attrs._text = (attrs._text || '') + '\n';
        }
      }
      return [];
    },
    render(comp, ctx) {
      const g = ctx.group;
      const text = comp.attrs._text || '';

      // Screen background
      const bg = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bg.setAttribute('x', -24); bg.setAttribute('y', -30);
      bg.setAttribute('width', 60); bg.setAttribute('height', 68);
      bg.setAttribute('rx', 3);
      bg.setAttribute('fill', '#0a0e14');
      bg.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bg.setAttribute('stroke-width', '1');
      g.appendChild(bg);

      // Text content (wrap at ~10 chars per line, show last 4 lines)
      const lines = [];
      let line = '';
      for (const ch of text) {
        if (ch === '\n' || line.length >= 10) { lines.push(line); line = ch === '\n' ? '' : ch; }
        else line += ch;
      }
      if (line) lines.push(line);
      const visible = lines.slice(-4);

      visible.forEach((ln, i) => {
        const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        t.setAttribute('x', -20); t.setAttribute('y', -16 + i * 13);
        t.setAttribute('fill', '#22c55e');
        t.setAttribute('font-size', '9');
        t.setAttribute('font-family', "'Fira Code', monospace");
        t.textContent = ln;
        g.appendChild(t);
      });

      // Cursor — align with last text line (text y = -16 + i*13, font-size 9)
      const lastIdx = visible.length > 0 ? visible.length - 1 : 0;
      const cursorY = -25 + lastIdx * 13;
      const cursorX = -20 + ((visible.length ? visible[visible.length - 1].length : 0) * 5.4);
      const cursor = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      cursor.setAttribute('x', Math.min(cursorX, 30));
      cursor.setAttribute('y', cursorY);
      cursor.setAttribute('width', 5); cursor.setAttribute('height', 10);
      cursor.setAttribute('fill', '#22c55e');
      cursor.setAttribute('opacity', '0.6');
      g.appendChild(cursor);

      // Port stubs
      const labels = ['D0','D1','D2','D3','D4','D5','D6','CLK'];
      comp.ports.forEach((p, i) => {
        const line2 = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line2.setAttribute('x1', -30); line2.setAttribute('y1', p.ry);
        line2.setAttribute('x2', p.rx); line2.setAttribute('y2', p.ry);
        line2.setAttribute('stroke', p.value.color());
        line2.setAttribute('stroke-width', '1.5');
        g.appendChild(line2);
      });

      // CLK triangle
      const clkPort = comp.ports[7];
      const tri = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      tri.setAttribute('d', `M${-30},${clkPort.ry - 4} L${-24},${clkPort.ry} L${-30},${clkPort.ry + 4}`);
      tri.setAttribute('fill', 'none');
      tri.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      tri.setAttribute('stroke-width', '1');
      g.appendChild(tri);

      // Label
      const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      lbl.setAttribute('x', 6); lbl.setAttribute('y', 50);
      lbl.setAttribute('text-anchor', 'middle');
      lbl.setAttribute('fill', 'var(--lg-muted)');
      lbl.setAttribute('font-size', '8');
      lbl.setAttribute('font-family', "'DM Sans', sans-serif");
      lbl.textContent = 'TTY';
      g.appendChild(lbl);
    },
    onClick(comp, circuit) {
      comp.attrs._text = '';
      circuit.propagate();
    }
  };

  L.DISPLAY_TYPES = { SEVEN_SEG, HEX_DISPLAY, LED_BAR, KEYBOARD, TTY };
})(window.LogicSim);
