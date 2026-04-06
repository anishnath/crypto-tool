/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Memory Components (Phase 3)
   SR, D, JK, T Flip-Flops + Register + Counter
   All edge-triggered on rising CLK with async CLR.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic } = L;
  const Port = L.Port;

  /* ── Geometry ── */
  const BW = 60;   // body width
  const PE = 8;    // port extension
  const LX = -(BW / 2 + PE);  // left port x
  const RX =  (BW / 2 + PE);  // right port x

  /* ── Rising edge detector (pass attrs directly) ── */
  function isRisingEdge(attrs, clkVal) {
    const prev = attrs._prevClk;
    const cur  = clkVal.get(0);
    attrs._prevClk = cur;
    return prev === FALSE && cur === TRUE;
  }

  /* ── Generic FF renderer ── */
  function renderFF(comp, ctx, label, leftLabels, rightLabels, clkIdx, opts) {
    const g = ctx.group;
    const nLeft  = leftLabels.length;
    const nRight = rightLabels.length;
    const rows = Math.max(nLeft, nRight);
    const h = Math.max(46, rows * 18 + 12);
    const hw = BW / 2, hh = h / 2;

    // Body
    const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('x', -hw); rect.setAttribute('y', -hh);
    rect.setAttribute('width', BW); rect.setAttribute('height', h);
    rect.setAttribute('rx', 3);
    rect.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
    rect.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
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

      // Stub line (local coords)
      const bodyEdge = isLeft ? -hw : hw;
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', bodyEdge); line.setAttribute('y1', p.ry);
      line.setAttribute('x2', p.rx);     line.setAttribute('y2', p.ry);
      line.setAttribute('stroke', p.value.color());
      line.setAttribute('stroke-width', '2');
      g.appendChild(line);

      // Clock triangle on CLK input
      if (isLeft && i === clkIdx) {
        const tri = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        const ty = p.ry;
        tri.setAttribute('d', `M${-hw},${ty - 5} L${-hw + 7},${ty} L${-hw},${ty + 5}`);
        tri.setAttribute('fill', 'none');
        tri.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
        tri.setAttribute('stroke-width', '1');
        g.appendChild(tri);
      }

      // Pin label inside body
      const ptxt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      ptxt.setAttribute('x', isLeft ? -hw + 8 : hw - 8);
      ptxt.setAttribute('y', p.ry + 3.5);
      ptxt.setAttribute('text-anchor', isLeft ? 'start' : 'end');
      ptxt.setAttribute('fill', 'var(--lg-muted)');
      ptxt.setAttribute('font-size', '8');
      ptxt.setAttribute('font-family', "'Fira Code', monospace");
      ptxt.textContent = plabel;
      g.appendChild(ptxt);
    });

    // Q output value display (skip for multi-bit components)
    const qPort = comp.outputPorts()[0];
    if (qPort && !(opts && opts.noQLabel)) {
      const vt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      vt.setAttribute('x', 0); vt.setAttribute('y', hh + 13);
      vt.setAttribute('text-anchor', 'middle');
      vt.setAttribute('fill', qPort.value.color());
      vt.setAttribute('font-size', '11');
      vt.setAttribute('font-weight', '600');
      vt.setAttribute('font-family', "'Fira Code', monospace");
      vt.textContent = 'Q=' + qPort.value.toString();
      g.appendChild(vt);
    }
  }

  /* ── Port layout helper ── */
  function ffPorts(nIn, nOut) {
    const ports = [];
    const hIn  = (nIn  - 1) * 16;
    const hOut = (nOut - 1) * 16;
    for (let i = 0; i < nIn; i++)
      ports.push(new Port('in',  LX, -hIn / 2 + i * 16, 1));
    for (let i = 0; i < nOut; i++)
      ports.push(new Port('out', RX, -hOut / 2 + i * 16, 1));
    return ports;
  }

  /* ═══════════ SR Flip-Flop ═══════════ */
  const SR_FF = {
    type: 'SR_FF',
    label: 'SR Flip-Flop',
    category: 'Memory',
    defaultAttrs: { _q: FALSE, _prevClk: UNKNOWN },
    createPorts() { return ffPorts(3, 2); },  // S, CLK, R → Q, Q̄
    compute(inputs, attrs) {
      const [s, clk, r] = inputs;
      if (isRisingEdge(attrs, clk)) {
        const sv = s.get(0), rv = r.get(0);
        if (sv === TRUE && rv === FALSE)      attrs._q = TRUE;
        else if (sv === FALSE && rv === TRUE)  attrs._q = FALSE;
        else if (sv === TRUE && rv === TRUE)   attrs._q = ERROR; // invalid
        // S=0,R=0 → hold
      }
      const q = attrs._q != null ? attrs._q : FALSE;
      return [Value.of(q), Value.of(Logic.not(q))];
    },
    render(comp, ctx) { renderFF(comp, ctx, 'SR', ['S','CLK','R'], ['Q','Q\u0305'], 1); }
  };

  /* ═══════════ D Flip-Flop ═══════════ */
  const D_FF = {
    type: 'D_FF',
    label: 'D Flip-Flop',
    category: 'Memory',
    defaultAttrs: { _q: FALSE, _prevClk: UNKNOWN },
    createPorts() { return ffPorts(3, 2); },  // D, CLK, CLR → Q, Q̄
    compute(inputs, attrs) {
      const [d, clk, clr] = inputs;
      const rising = isRisingEdge(attrs, clk); // always sample CLK
      if (clr.get(0) === TRUE) {
        attrs._q = FALSE;
      } else if (rising) {
        attrs._q = d.get(0) === TRUE ? TRUE : FALSE;
      }
      const q = attrs._q != null ? attrs._q : FALSE;
      return [Value.of(q), Value.of(Logic.not(q))];
    },
    render(comp, ctx) { renderFF(comp, ctx, 'D', ['D','CLK','CLR'], ['Q','Q\u0305'], 1); }
  };

  /* ═══════════ JK Flip-Flop ═══════════ */
  const JK_FF = {
    type: 'JK_FF',
    label: 'JK Flip-Flop',
    category: 'Memory',
    defaultAttrs: { _q: FALSE, _prevClk: UNKNOWN },
    createPorts() { return ffPorts(3, 2); },  // J, CLK, K → Q, Q̄
    compute(inputs, attrs) {
      const [j, clk, k] = inputs;
      if (isRisingEdge(attrs, clk)) {
        const jv = j.get(0), kv = k.get(0);
        const q = attrs._q || FALSE;
        if (jv === TRUE && kv === TRUE)        attrs._q = Logic.not(q); // toggle
        else if (jv === TRUE && kv === FALSE)   attrs._q = TRUE;         // set
        else if (jv === FALSE && kv === TRUE)   attrs._q = FALSE;        // reset
        // J=0,K=0 → hold
      }
      const q = attrs._q != null ? attrs._q : FALSE;
      return [Value.of(q), Value.of(Logic.not(q))];
    },
    render(comp, ctx) { renderFF(comp, ctx, 'JK', ['J','CLK','K'], ['Q','Q\u0305'], 1); }
  };

  /* ═══════════ T Flip-Flop ═══════════ */
  const T_FF = {
    type: 'T_FF',
    label: 'T Flip-Flop',
    category: 'Memory',
    defaultAttrs: { _q: FALSE, _prevClk: UNKNOWN },
    createPorts() { return ffPorts(2, 2); },  // T, CLK → Q, Q̄
    compute(inputs, attrs) {
      const [t, clk] = inputs;
      if (isRisingEdge(attrs, clk)) {
        if (t.get(0) === TRUE) {
          attrs._q = Logic.not(attrs._q || FALSE);  // toggle
        }
        // T=0 → hold
      }
      const q = attrs._q != null ? attrs._q : FALSE;
      return [Value.of(q), Value.of(Logic.not(q))];
    },
    render(comp, ctx) { renderFF(comp, ctx, 'T', ['T','CLK'], ['Q','Q\u0305'], 1); }
  };

  /* ═══════════ Register (4-bit, parallel load) ═══════════ */
  const REGISTER = {
    type: 'REGISTER',
    label: 'Register (4-bit)',
    category: 'Memory',
    defaultAttrs: { _val: 0, _prevClk: UNKNOWN },
    createPorts() {
      // D0-D3, CLK, CLR → Q0-Q3
      return ffPorts(6, 4);
    },
    compute(inputs, attrs) {
      const [d0, d1, d2, d3, clk, clr] = inputs;
      const rising = isRisingEdge(attrs, clk);
      if (clr.get(0) === TRUE) {
        attrs._val = 0;
      } else if (rising) {
        attrs._val =
          (d0.get(0) === TRUE ? 1 : 0) |
          (d1.get(0) === TRUE ? 2 : 0) |
          (d2.get(0) === TRUE ? 4 : 0) |
          (d3.get(0) === TRUE ? 8 : 0);
      }
      const v = attrs._val || 0;
      return [
        Value.of(v & 1 ? TRUE : FALSE),
        Value.of(v & 2 ? TRUE : FALSE),
        Value.of(v & 4 ? TRUE : FALSE),
        Value.of(v & 8 ? TRUE : FALSE),
      ];
    },
    render(comp, ctx) {
      renderFF(comp, ctx, 'REG', ['D0','D1','D2','D3','CLK','CLR'],
               ['Q0','Q1','Q2','Q3'], 4, { noQLabel: true });
      const g = ctx.group;
      const v = comp.attrs._val || 0;
      const vt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      vt.setAttribute('x', 0);
      vt.setAttribute('y', 60);
      vt.setAttribute('text-anchor', 'middle');
      vt.setAttribute('fill', 'var(--lg-accent)');
      vt.setAttribute('font-size', '10');
      vt.setAttribute('font-weight', '600');
      vt.setAttribute('font-family', "'Fira Code', monospace");
      vt.textContent = '0x' + v.toString(16).toUpperCase();
      g.appendChild(vt);
    }
  };

  /* ═══════════ Counter (4-bit, up, with enable) ═══════════ */
  const COUNTER = {
    type: 'COUNTER',
    label: 'Counter (4-bit)',
    category: 'Memory',
    defaultAttrs: { _val: 0, _prevClk: UNKNOWN },
    createPorts() {
      // CLK, EN, CLR → Q0-Q3, OVF
      return ffPorts(3, 5);
    },
    compute(inputs, attrs) {
      const [clk, en, clr] = inputs;
      const rising = isRisingEdge(attrs, clk);
      if (clr.get(0) === TRUE) {
        attrs._val = 0;
      } else if (rising) {
        if (en.get(0) !== FALSE) {  // enabled (HIGH or X treated as enabled)
          attrs._val = ((attrs._val || 0) + 1) & 0xF; // 0-15 wrap
        }
      }
      const v = attrs._val || 0;
      return [
        Value.of(v & 1 ? TRUE : FALSE),
        Value.of(v & 2 ? TRUE : FALSE),
        Value.of(v & 4 ? TRUE : FALSE),
        Value.of(v & 8 ? TRUE : FALSE),
        Value.of(v === 15 ? TRUE : FALSE),  // overflow
      ];
    },
    render(comp, ctx) {
      renderFF(comp, ctx, 'CTR', ['CLK','EN','CLR'],
               ['Q0','Q1','Q2','Q3','OVF'], 0, { noQLabel: true });
      const g = ctx.group;
      const v = comp.attrs._val || 0;
      const vt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      vt.setAttribute('x', 0);
      vt.setAttribute('y', 64);
      vt.setAttribute('text-anchor', 'middle');
      vt.setAttribute('fill', 'var(--lg-accent)');
      vt.setAttribute('font-size', '10');
      vt.setAttribute('font-weight', '600');
      vt.setAttribute('font-family', "'Fira Code', monospace");
      vt.textContent = v.toString(10) + ' (0x' + v.toString(16).toUpperCase() + ')';
      g.appendChild(vt);
    }
  };

  L.MEMORY_TYPES = {
    SR_FF, D_FF, JK_FF, T_FF, REGISTER, COUNTER
  };
})(window.LogicSim);
