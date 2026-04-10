/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Arithmetic Components (Phase 4)
   Adder, Subtractor, Comparator + MUX, DEMUX, Decoder
   All use 1-bit ports; users chain for multi-bit.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic } = L;
  const Port = L.Port;

  /* ── Geometry ── */
  const BW = 60, PE = 8;
  const LX = -(BW / 2 + PE), RX = (BW / 2 + PE);

  /* ── Port layout helper (same as memory.js) ── */
  function blockPorts(nIn, nOut) {
    const ports = [];
    const hIn  = (nIn  - 1) * 16;
    const hOut = (nOut - 1) * 16;
    for (let i = 0; i < nIn; i++)
      ports.push(new Port('in', LX, -hIn / 2 + i * 16, 1));
    for (let i = 0; i < nOut; i++)
      ports.push(new Port('out', RX, -hOut / 2 + i * 16, 1));
    return ports;
  }

  /* ── Generic block renderer ── */
  function renderBlock(comp, ctx, label, leftLabels, rightLabels, opts) {
    const g = ctx.group;
    const rows = Math.max(leftLabels.length, rightLabels.length);
    const h = Math.max(46, rows * 16 + 14);
    const hw = BW / 2, hh = h / 2;

    // Body
    const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('x', -hw); rect.setAttribute('y', -hh);
    rect.setAttribute('width', BW); rect.setAttribute('height', h);
    rect.setAttribute('rx', 3);
    rect.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
    rect.setAttribute('stroke', (opts && opts.stroke) || 'var(--lg-gate-stroke, #94a3b8)');
    rect.setAttribute('stroke-width', '1.5');
    g.appendChild(rect);

    // Center label
    const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    txt.setAttribute('x', 0); txt.setAttribute('y', 4);
    txt.setAttribute('text-anchor', 'middle');
    txt.setAttribute('fill', 'var(--lg-muted)');
    txt.setAttribute('font-size', '9');
    txt.setAttribute('font-weight', '600');
    txt.setAttribute('font-family', "'DM Sans', sans-serif");
    txt.textContent = label;
    g.appendChild(txt);

    // Port stubs + labels
    comp.ports.forEach((p, i) => {
      const isLeft = p.dir === 'in';
      const labels = isLeft ? leftLabels : rightLabels;
      const idx = isLeft ? i : i - leftLabels.length;
      const plabel = labels[idx] || '';

      const bodyEdge = isLeft ? -hw : hw;
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', bodyEdge); line.setAttribute('y1', p.ry);
      line.setAttribute('x2', p.rx);     line.setAttribute('y2', p.ry);
      line.setAttribute('stroke', p.value.color());
      line.setAttribute('stroke-width', '2');
      g.appendChild(line);

      const ptxt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      ptxt.setAttribute('x', isLeft ? -hw + 6 : hw - 6);
      ptxt.setAttribute('y', p.ry + 3.5);
      ptxt.setAttribute('text-anchor', isLeft ? 'start' : 'end');
      ptxt.setAttribute('fill', 'var(--lg-muted)');
      ptxt.setAttribute('font-size', '8');
      ptxt.setAttribute('font-family', "'Fira Code', monospace");
      ptxt.textContent = plabel;
      g.appendChild(ptxt);
    });
  }

  /* Helper: known-bit extract (only for comparator where X/E is handled separately) */
  function bit(v) { return v.get(0) === TRUE ? 1 : 0; }
  function bv(n)  { return Value.of(n ? TRUE : FALSE); }

  /* ═══════════ Full Adder (4-state: propagates X/E) ═══════════ */
  const ADDER = {
    type: 'ADDER',
    label: 'Full Adder',
    category: 'Arithmetic',
    defaultAttrs: {},
    createPorts() { return blockPorts(3, 2); }, // A, B, Cin → S, Cout
    compute(inputs) {
      const [a, b, cin] = inputs;
      const sum  = a.xor(b).xor(cin);
      const cout = a.and(b).or(b.and(cin)).or(a.and(cin));
      return [sum, cout];
    },
    render(comp, ctx) { renderBlock(comp, ctx, 'ADD', ['A','B','Cin'], ['S','Cout']); }
  };

  /* ═══════════ Full Subtractor (4-state: propagates X/E) ═══════════ */
  const SUBTRACTOR = {
    type: 'SUBTRACTOR',
    label: 'Full Subtractor',
    category: 'Arithmetic',
    defaultAttrs: {},
    createPorts() { return blockPorts(3, 2); }, // A, B, Bin → D, Bout
    compute(inputs) {
      const [a, b, bin] = inputs;
      const diff = a.xor(b).xor(bin);
      const notA = a.not();
      const bout = notA.and(b).or(a.xor(b).not().and(bin));
      return [diff, bout];
    },
    render(comp, ctx) { renderBlock(comp, ctx, 'SUB', ['A','B','Bin'], ['D','Bout']); }
  };

  /* ═══════════ Comparator (1-bit with cascade) ═══════════ */
  const COMPARATOR = {
    type: 'COMPARATOR',
    label: 'Comparator',
    category: 'Arithmetic',
    defaultAttrs: {},
    createPorts() { return blockPorts(2, 3); }, // A, B → A>B, A=B, A<B
    compute(inputs) {
      const a = bit(inputs[0]), b = bit(inputs[1]);
      return [bv(a > b), bv(a === b), bv(a < b)];
    },
    render(comp, ctx) { renderBlock(comp, ctx, 'CMP', ['A','B'], ['A>B','A=B','A<B']); }
  };

  /* ═══════════ 2:1 Multiplexer ═══════════ */
  const MUX = {
    type: 'MUX',
    label: '2:1 MUX',
    category: 'Plexers',
    defaultAttrs: {},
    createPorts() { return blockPorts(3, 1); }, // D0, D1, SEL → Y
    compute(inputs) {
      const sel = inputs[2].get(0);
      if (sel === UNKNOWN || sel === ERROR) return [Value.of(sel)];
      return [sel === TRUE ? inputs[1] : inputs[0]];
    },
    render(comp, ctx) {
      renderBlock(comp, ctx, 'MUX', ['D0','D1','SEL'], ['Y']);
      // Trapezoid shape over the rect
      const g = ctx.group;
      const hw = BW / 2;
      const trap = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      trap.setAttribute('x', 0); trap.setAttribute('y', -18);
      trap.setAttribute('text-anchor', 'middle');
      trap.setAttribute('fill', 'var(--lg-muted)');
      trap.setAttribute('font-size', '7');
      trap.setAttribute('font-family', "'Fira Code', monospace");
      const selState = comp.ports[2].value.get(0);
      const selStr = selState === TRUE ? '1\u2192D1' : selState === FALSE ? '0\u2192D0'
                   : selState === ERROR ? 'ERR' : '?';
      trap.textContent = 'SEL=' + selStr;
      g.appendChild(trap);
    }
  };

  /* ═══════════ 1:2 Demultiplexer ═══════════ */
  const DEMUX = {
    type: 'DEMUX',
    label: '1:2 DEMUX',
    category: 'Plexers',
    defaultAttrs: {},
    createPorts() { return blockPorts(2, 2); }, // D, SEL → Y0, Y1
    compute(inputs) {
      const d = inputs[0], sel = inputs[1].get(0);
      if (sel === UNKNOWN || sel === ERROR) return [Value.X, Value.X];
      if (sel === FALSE) return [d, Value.of(FALSE)];
      return [Value.of(FALSE), d];
    },
    render(comp, ctx) { renderBlock(comp, ctx, 'DEMUX', ['D','SEL'], ['Y0','Y1']); }
  };

  /* ═══════════ 2:4 Decoder ═══════════ */
  const DECODER = {
    type: 'DECODER',
    label: '2:4 Decoder',
    category: 'Plexers',
    defaultAttrs: {},
    createPorts() { return blockPorts(2, 4); }, // A0, A1 → Y0, Y1, Y2, Y3
    compute(inputs) {
      const a0 = inputs[0].get(0), a1 = inputs[1].get(0);
      if (a0 === UNKNOWN || a0 === ERROR || a1 === UNKNOWN || a1 === ERROR) {
        return [Value.X, Value.X, Value.X, Value.X];
      }
      const addr = (a0 === TRUE ? 1 : 0) | (a1 === TRUE ? 2 : 0);
      return [bv(addr === 0), bv(addr === 1), bv(addr === 2), bv(addr === 3)];
    },
    render(comp, ctx) { renderBlock(comp, ctx, 'DEC', ['A0','A1'], ['Y0','Y1','Y2','Y3']); }
  };

  /* ═══════════ LUT (Lookup Table) — FPGA primitive ═══════════ */
  // N-input, 1-output configurable truth table.
  // The truth table is stored as a bitmask in attrs.table (integer).
  // For N inputs, the table has 2^N bits. Bit i = output when input = i.
  // Example: 2-input AND = table 0b1000 = 8 (only row 11 outputs 1)
  const LUT = {
    type: 'LUT',
    label: 'LUT',
    category: 'Arithmetic',
    defaultAttrs: { inputs: 2, table: 8 },  // default: 2-input AND

    createPorts(attrs) {
      const n = Math.max(1, Math.min(6, attrs.inputs || 2));
      const ports = [];
      const totalH = (n - 1) * 14;
      for (let i = 0; i < n; i++) {
        ports.push(new Port('in', -24, -totalH / 2 + i * 14, 1));
      }
      ports.push(new Port('out', 24, 0, 1));
      return ports;
    },

    compute(inputs, attrs) {
      const n = inputs.length;
      let addr = 0;
      let hasUnknown = false;
      for (let i = 0; i < n; i++) {
        const v = inputs[i].get(0);
        if (v === UNKNOWN || v === ERROR) { hasUnknown = true; break; }
        if (v === TRUE) addr |= (1 << i);
      }
      if (hasUnknown) return [Value.of(UNKNOWN)];
      const table = attrs.table || 0;
      const bit = (table >> addr) & 1;
      return [Value.of(bit ? TRUE : FALSE)];
    },

    render(comp, ctx) {
      const g = ctx.group;
      const n = Math.max(1, Math.min(6, comp.attrs.inputs || 2));
      const totalH = Math.max(30, (n - 1) * 14 + 20);

      // Box
      const box = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      box.setAttribute('x', -18); box.setAttribute('y', -totalH / 2);
      box.setAttribute('width', 36); box.setAttribute('height', totalH);
      box.setAttribute('rx', 3);
      box.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      box.setAttribute('stroke', 'var(--lg-accent)');
      box.setAttribute('stroke-width', '1.5');
      g.appendChild(box);

      // LUT label
      const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      txt.setAttribute('x', 0); txt.setAttribute('y', -2);
      txt.setAttribute('text-anchor', 'middle');
      txt.setAttribute('fill', 'var(--lg-accent)');
      txt.setAttribute('font-size', '9');
      txt.setAttribute('font-weight', '700');
      txt.setAttribute('font-family', "'Fira Code', monospace");
      txt.textContent = 'LUT';
      txt.classList.add('lg-clickable');
      g.appendChild(txt);

      // Size label
      const sz = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      sz.setAttribute('x', 0); sz.setAttribute('y', 9);
      sz.setAttribute('text-anchor', 'middle');
      sz.setAttribute('fill', 'var(--lg-text-dim)');
      sz.setAttribute('font-size', '7');
      sz.setAttribute('font-family', "'Fira Code', monospace");
      sz.textContent = n + '→1';
      g.appendChild(sz);

      // Table hex value
      const hex = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      hex.setAttribute('x', 0); hex.setAttribute('y', totalH / 2 + 10);
      hex.setAttribute('text-anchor', 'middle');
      hex.setAttribute('fill', 'var(--lg-text-dim)');
      hex.setAttribute('font-size', '7');
      hex.setAttribute('font-family', "'Fira Code', monospace");
      hex.textContent = '0x' + (comp.attrs.table || 0).toString(16).toUpperCase();
      g.appendChild(hex);
    },

    onClick(comp, circuit) {
      const n = comp.attrs.inputs || 2;
      const maxVal = (1 << (1 << n)) - 1;
      const current = comp.attrs.table || 0;
      const input = prompt(
        'LUT truth table (' + n + ' inputs, ' + (1 << n) + ' rows)\n' +
        'Enter as hex (0x..) or decimal.\n' +
        'Each bit = output for that input combination.\n' +
        'Examples: AND=' + (1 << ((1 << n) - 1)) + ', OR=' + (maxVal - 1) + '\n' +
        'Current: 0x' + current.toString(16).toUpperCase() + ' (' + current + ')',
        '0x' + current.toString(16).toUpperCase()
      );
      if (input != null) {
        let val = input.trim().toLowerCase().startsWith('0x')
          ? parseInt(input.trim(), 16)
          : parseInt(input.trim());
        if (!isNaN(val)) {
          comp.attrs.table = val & maxVal;
          circuit.propagate();
        }
      }
    }
  };

  L.ARITH_TYPES = { ADDER, SUBTRACTOR, COMPARATOR, MUX, DEMUX, DECODER, LUT };
})(window.LogicSim);
