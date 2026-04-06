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

  L.ARITH_TYPES = { ADDER, SUBTRACTOR, COMPARATOR, MUX, DEMUX, DECODER };
})(window.LogicSim);
