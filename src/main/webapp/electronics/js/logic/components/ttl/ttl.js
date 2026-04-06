/* ═══════════════════════════════════════════════════════════
   Logic Simulator — TTL 7400-Series IC Library (Phase 10)
   DIP package factory + basic gates + advanced ICs.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic } = L;
  const Port = L.Port;

  /* ── DIP Geometry ── */
  const DIP_W    = 60;    // body width
  const PIN_SP   = 12;    // pin spacing vertical
  const PE       = 10;    // port extension from body
  const LX       = -(DIP_W / 2 + PE);
  const RX       = (DIP_W / 2 + PE);

  /* ══════════════════════════════════════
     DIP Package Factory
     Creates component types for N-pin DIPs.
     ══════════════════════════════════════ */

  function createDIP(spec) {
    const { name, partNo, pins, pinDefs, computeFn, category } = spec;
    const halfPins = pins / 2;
    const bodyH    = (halfPins - 1) * PIN_SP + 16;
    const _pinInputMap = buildPinInputMap(pinDefs, pins);

    return {
      type: 'TTL_' + partNo,
      label: partNo,
      category: category || 'TTL',
      defaultAttrs: spec.defaultAttrs || {},

      createPorts() {
        const ports = [];
        // Left side: pin 1 (top) to pin N/2 (bottom)
        for (let i = 0; i < halfPins; i++) {
          const pinNum = i + 1;
          const def = pinDefs[pinNum];
          const dir = (def && def.dir) || 'in';
          ports.push(new Port(dir, LX, -(bodyH / 2) + 8 + i * PIN_SP, 1));
        }
        // Right side: pin N (top) to pin N/2+1 (bottom)
        for (let i = 0; i < halfPins; i++) {
          const pinNum = pins - i;
          const def = pinDefs[pinNum];
          const dir = (def && def.dir) || 'in';
          ports.push(new Port(dir, RX, -(bodyH / 2) + 8 + i * PIN_SP, 1));
        }
        return ports;
      },

      compute(inputs, attrs) {
        return computeFn(inputs, attrs, _pinInputMap);
      },

      render(comp, ctx) {
        _renderDIP(comp, ctx, spec);
      }
    };
  }

  /* Pin number → port index mapping */
  function pinToPort(pinNum, totalPins) {
    const half = totalPins / 2;
    if (pinNum <= half) return pinNum - 1;               // left side
    return half + (totalPins - pinNum);                   // right side
  }
  function portToPin(portIdx, totalPins) {
    const half = totalPins / 2;
    if (portIdx < half) return portIdx + 1;               // left side
    return totalPins - (portIdx - half);                   // right side
  }

  /* Build a pin→inputIndex map (accounting for skipped output ports).
     circuit.js passes compute() only the input port values, NOT all ports. */
  function buildPinInputMap(pinDefs, totalPins) {
    const map = {};
    let inputIdx = 0;
    for (let portIdx = 0; portIdx < totalPins; portIdx++) {
      const pin = portToPin(portIdx, totalPins);
      const def = pinDefs[pin];
      if (!def || def.dir !== 'out') {
        map[pin] = inputIdx++;
      }
    }
    return map;
  }

  /* Read pin value from inputs array using the pin→inputIndex map */
  function pinVal(inputs, pinNum, pinInputMap) {
    const idx = pinInputMap[pinNum];
    if (idx === undefined) return UNKNOWN;
    return inputs[idx] ? inputs[idx].get(0) : UNKNOWN;
  }

  /* Build output array: returns values ONLY for output ports, in port order.
     The circuit propagation expects compute() to return [outPort0, outPort1, ...]. */
  function makeOutputs(totalPins, pinDefs, outMap) {
    const result = [];
    for (let i = 0; i < totalPins; i++) {
      const pin = portToPin(i, totalPins);
      const def = pinDefs[pin];
      if (def && def.dir === 'out') {
        result.push(Value.of(outMap[pin] !== undefined ? outMap[pin] : FALSE));
      }
      // Skip input ports — they are not in the output array
    }
    return result;
  }

  /* ── DIP Renderer ── */
  function _renderDIP(comp, ctx, spec) {
    const g = ctx.group;
    const { pins, pinDefs, partNo, name } = spec;
    const halfPins = pins / 2;
    const bodyH = (halfPins - 1) * PIN_SP + 16;
    const hw = DIP_W / 2, hh = bodyH / 2;

    // Body
    const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('x', -hw); rect.setAttribute('y', -hh);
    rect.setAttribute('width', DIP_W); rect.setAttribute('height', bodyH);
    rect.setAttribute('rx', 2);
    rect.setAttribute('fill', '#1a1a2e');
    rect.setAttribute('stroke', '#4a4a6a');
    rect.setAttribute('stroke-width', '1.5');
    g.appendChild(rect);

    // Notch at top
    const notch = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    notch.setAttribute('d', `M-6,${-hh} A6,6 0 0,1 6,${-hh}`);
    notch.setAttribute('fill', '#0f0f1e');
    notch.setAttribute('stroke', '#4a4a6a');
    notch.setAttribute('stroke-width', '1');
    g.appendChild(notch);

    // Pin 1 dot
    const dot = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    dot.setAttribute('cx', -hw + 8); dot.setAttribute('cy', -hh + 10);
    dot.setAttribute('r', 2);
    dot.setAttribute('fill', '#6a6a8a');
    g.appendChild(dot);

    // Part number label
    const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    lbl.setAttribute('x', 0); lbl.setAttribute('y', 3);
    lbl.setAttribute('text-anchor', 'middle');
    lbl.setAttribute('fill', '#8a8aaa');
    lbl.setAttribute('font-size', '9');
    lbl.setAttribute('font-weight', '600');
    lbl.setAttribute('font-family', "'Fira Code', monospace");
    lbl.textContent = partNo;
    g.appendChild(lbl);

    // Name below
    const nameLbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    nameLbl.setAttribute('x', 0); nameLbl.setAttribute('y', hh + 12);
    nameLbl.setAttribute('text-anchor', 'middle');
    nameLbl.setAttribute('fill', 'var(--lg-muted)');
    nameLbl.setAttribute('font-size', '7');
    nameLbl.setAttribute('font-family', "'DM Sans', sans-serif");
    nameLbl.textContent = name;
    g.appendChild(nameLbl);

    // Pin stubs + numbers
    comp.ports.forEach((p, portIdx) => {
      const pin = portToPin(portIdx, pins);
      const def = pinDefs[pin];
      const isLeft = portIdx < halfPins;
      const bodyEdge = isLeft ? -hw : hw;

      // Stub line
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', bodyEdge); line.setAttribute('y1', p.ry);
      line.setAttribute('x2', p.rx);     line.setAttribute('y2', p.ry);
      line.setAttribute('stroke', p.value.color());
      line.setAttribute('stroke-width', '1.5');
      g.appendChild(line);

      // Pin number
      const numTxt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      numTxt.setAttribute('x', isLeft ? -hw + 4 : hw - 4);
      numTxt.setAttribute('y', p.ry + 3);
      numTxt.setAttribute('text-anchor', isLeft ? 'start' : 'end');
      numTxt.setAttribute('fill', '#6a6a8a');
      numTxt.setAttribute('font-size', '6');
      numTxt.setAttribute('font-family', "'Fira Code', monospace");
      numTxt.textContent = pin;
      g.appendChild(numTxt);
    });
  }

  /* ══════════════════════════════════════
     BASIC QUAD GATE ICs (14-pin)
     Standard pinout: 4 gates, pin 7=GND, pin 14=VCC
     Gate 1: 1,2→3  Gate 2: 4,5→6  Gate 3: 9,10→8  Gate 4: 12,13→11
     ══════════════════════════════════════ */

  const QUAD_GATE_PINS = {
    1:{dir:'in',label:'1A'}, 2:{dir:'in',label:'1B'}, 3:{dir:'out',label:'1Y'},
    4:{dir:'in',label:'2A'}, 5:{dir:'in',label:'2B'}, 6:{dir:'out',label:'2Y'},
    7:{dir:'in',label:'GND'}, // power
    8:{dir:'out',label:'3Y'}, 9:{dir:'in',label:'3A'}, 10:{dir:'in',label:'3B'},
    11:{dir:'out',label:'4Y'}, 12:{dir:'in',label:'4A'}, 13:{dir:'in',label:'4B'},
    14:{dir:'in',label:'VCC'}  // power
  };

  function quadGateCompute(fn, pinMap, gateList) {
    const pd = pinMap || QUAD_GATE_PINS;
    const gl = gateList || [
      { a: 1, b: 2, y: 3 },
      { a: 4, b: 5, y: 6 },
      { a: 9, b: 10, y: 8 },
      { a: 12, b: 13, y: 11 }
    ];
    return function(inputs, attrs, pim) {
      const out = {};
      for (const g of gl) {
        out[g.y] = fn(pinVal(inputs, g.a, pim), pinVal(inputs, g.b, pim));
      }
      return makeOutputs(14, pd, out);
    };
  }

  /* 7404 Hex Inverter — different pinout */
  const HEX_INV_PINS = {
    1:{dir:'in',label:'1A'}, 2:{dir:'out',label:'1Y'},
    3:{dir:'in',label:'2A'}, 4:{dir:'out',label:'2Y'},
    5:{dir:'in',label:'3A'}, 6:{dir:'out',label:'3Y'},
    7:{dir:'in',label:'GND'},
    8:{dir:'out',label:'4Y'}, 9:{dir:'in',label:'4A'},
    10:{dir:'out',label:'5Y'}, 11:{dir:'in',label:'5A'},
    12:{dir:'out',label:'6Y'}, 13:{dir:'in',label:'6A'},
    14:{dir:'in',label:'VCC'}
  };

  /* ══════════════════════════════════════
     IC Definitions
     ══════════════════════════════════════ */

  const TTL_7400 = createDIP({
    partNo: '7400', name: 'Quad NAND', pins: 14, pinDefs: QUAD_GATE_PINS,
    computeFn: quadGateCompute((a, b) => Logic.not(Logic.and(a, b)))
  });

  /* 7402 has a unique pinout: outputs on pins 1,4,10,13 */
  const NOR_GATE_PINS = {
    1:{dir:'out',label:'1Y'}, 2:{dir:'in',label:'1A'}, 3:{dir:'in',label:'1B'},
    4:{dir:'out',label:'2Y'}, 5:{dir:'in',label:'2A'}, 6:{dir:'in',label:'2B'},
    7:{dir:'in',label:'GND'},
    8:{dir:'in',label:'3A'}, 9:{dir:'in',label:'3B'}, 10:{dir:'out',label:'3Y'},
    11:{dir:'in',label:'4A'}, 12:{dir:'in',label:'4B'}, 13:{dir:'out',label:'4Y'},
    14:{dir:'in',label:'VCC'}
  };

  const TTL_7402 = createDIP({
    partNo: '7402', name: 'Quad NOR', pins: 14, pinDefs: NOR_GATE_PINS,
    computeFn: quadGateCompute((a, b) => Logic.not(Logic.or(a, b)), NOR_GATE_PINS, [
      { a: 2, b: 3, y: 1 },
      { a: 5, b: 6, y: 4 },
      { a: 8, b: 9, y: 10 },
      { a: 11, b: 12, y: 13 }
    ])
  });

  const TTL_7404 = createDIP({
    partNo: '7404', name: 'Hex Inverter', pins: 14, pinDefs: HEX_INV_PINS,
    computeFn: function(inputs, attrs, pim) {
      const gates = [
        { a: 1, y: 2 }, { a: 3, y: 4 }, { a: 5, y: 6 },
        { a: 9, y: 8 }, { a: 11, y: 10 }, { a: 13, y: 12 }
      ];
      const out = {};
      for (const g of gates) out[g.y] = Logic.not(pinVal(inputs, g.a, pim));
      return makeOutputs(14, HEX_INV_PINS, out);
    }
  });

  const TTL_7408 = createDIP({
    partNo: '7408', name: 'Quad AND', pins: 14, pinDefs: QUAD_GATE_PINS,
    computeFn: quadGateCompute((a, b) => Logic.and(a, b))
  });

  const TTL_7432 = createDIP({
    partNo: '7432', name: 'Quad OR', pins: 14, pinDefs: QUAD_GATE_PINS,
    computeFn: quadGateCompute((a, b) => Logic.or(a, b))
  });

  const TTL_7486 = createDIP({
    partNo: '7486', name: 'Quad XOR', pins: 14, pinDefs: QUAD_GATE_PINS,
    computeFn: quadGateCompute((a, b) => Logic.xor(a, b))
  });

  /* ══════════════════════════════════════
     7474 — Dual D Flip-Flop (14-pin)
     Pin: 1=CLR1, 2=D1, 3=CLK1, 4=SET1, 5=Q1, 6=Q1', 7=GND
          14=VCC, 13=CLR2, 12=D2, 11=CLK2, 10=SET2, 9=Q2, 8=Q2'
     CLR/SET active LOW
     ══════════════════════════════════════ */
  const PINS_7474 = {
    1:{dir:'in',label:'CLR1'}, 2:{dir:'in',label:'D1'}, 3:{dir:'in',label:'CLK1'},
    4:{dir:'in',label:'SET1'}, 5:{dir:'out',label:'Q1'}, 6:{dir:'out',label:'Q1\''},
    7:{dir:'in',label:'GND'},
    8:{dir:'out',label:'Q2\''}, 9:{dir:'out',label:'Q2'}, 10:{dir:'in',label:'SET2'},
    11:{dir:'in',label:'CLK2'}, 12:{dir:'in',label:'D2'}, 13:{dir:'in',label:'CLR2'},
    14:{dir:'in',label:'VCC'}
  };

  const TTL_7474 = createDIP({
    partNo: '7474', name: 'Dual D-FF', pins: 14, pinDefs: PINS_7474,
    defaultAttrs: { _q1: FALSE, _q2: FALSE, _prevClk1: UNKNOWN, _prevClk2: UNKNOWN },
    computeFn: function(inputs, attrs, pim) {
      // FF1
      const clr1 = pinVal(inputs, 1, pim), d1 = pinVal(inputs, 2, pim);
      const clk1 = pinVal(inputs, 3, pim), set1 = pinVal(inputs, 4, pim);
      const rising1 = (attrs._prevClk1 === FALSE && clk1 === TRUE);
      attrs._prevClk1 = clk1;

      if (clr1 === FALSE)       attrs._q1 = FALSE;
      else if (set1 === FALSE)  attrs._q1 = TRUE;
      else if (rising1)         attrs._q1 = d1 === TRUE ? TRUE : FALSE;

      // FF2
      const clr2 = pinVal(inputs, 13, pim), d2 = pinVal(inputs, 12, pim);
      const clk2 = pinVal(inputs, 11, pim), set2 = pinVal(inputs, 10, pim);
      const rising2 = (attrs._prevClk2 === FALSE && clk2 === TRUE);
      attrs._prevClk2 = clk2;

      if (clr2 === FALSE)       attrs._q2 = FALSE;
      else if (set2 === FALSE)  attrs._q2 = TRUE;
      else if (rising2)         attrs._q2 = d2 === TRUE ? TRUE : FALSE;

      const q1 = attrs._q1 || FALSE, q2 = attrs._q2 || FALSE;
      const out = {};
      out[5] = q1; out[6] = Logic.not(q1);
      out[9] = q2; out[8] = Logic.not(q2);
      return makeOutputs(14, PINS_7474, out);
    }
  });

  /* ══════════════════════════════════════
     7447 — BCD to 7-Segment Decoder (16-pin)
     Pin: 1=B, 2=C, 3=LT', 4=BI'/RBO', 5=RBI', 6=D, 7=A, 8=GND
          16=VCC, 15=f, 14=g, 13=a, 12=b, 11=c, 10=d, 9=e
     Outputs active LOW
     ══════════════════════════════════════ */
  const PINS_7447 = {
    1:{dir:'in',label:'B'}, 2:{dir:'in',label:'C'}, 3:{dir:'in',label:'LT\''},
    4:{dir:'in',label:'BI\''}, 5:{dir:'in',label:'RBI\''}, 6:{dir:'in',label:'D'}, 7:{dir:'in',label:'A'},
    8:{dir:'in',label:'GND'},
    9:{dir:'out',label:'e'}, 10:{dir:'out',label:'d'}, 11:{dir:'out',label:'c'},
    12:{dir:'out',label:'b'}, 13:{dir:'out',label:'a'}, 14:{dir:'out',label:'g'}, 15:{dir:'out',label:'f'},
    16:{dir:'in',label:'VCC'}
  };

  // Standard 7-seg decode (active LOW outputs): 0=ON, 1=OFF
  const SEG_TABLE = [
    0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78, // 0-7
    0x00,0x10,0x08,0x03,0x46,0x21,0x06,0x0E   // 8-15
  ];

  const TTL_7447 = createDIP({
    partNo: '7447', name: 'BCD→7Seg', pins: 16, pinDefs: PINS_7447,
    computeFn: function(inputs, attrs, pim) {
      const a = pinVal(inputs, 7, pim), b = pinVal(inputs, 1, pim);
      const c = pinVal(inputs, 2, pim), d = pinVal(inputs, 6, pim);
      if (a === UNKNOWN || b === UNKNOWN || c === UNKNOWN || d === UNKNOWN) {
        const out = {}; [9,10,11,12,13,14,15].forEach(p => { out[p] = TRUE; });
        return makeOutputs(16, PINS_7447, out);
      }
      const val = (a === TRUE ? 1 : 0) | (b === TRUE ? 2 : 0) | (c === TRUE ? 4 : 0) | (d === TRUE ? 8 : 0);
      const segs = SEG_TABLE[val];
      const out = {};
      out[13] = (segs >> 0) & 1 ? TRUE : FALSE;
      out[12] = (segs >> 1) & 1 ? TRUE : FALSE;
      out[11] = (segs >> 2) & 1 ? TRUE : FALSE;
      out[10] = (segs >> 3) & 1 ? TRUE : FALSE;
      out[9]  = (segs >> 4) & 1 ? TRUE : FALSE;
      out[15] = (segs >> 5) & 1 ? TRUE : FALSE;
      out[14] = (segs >> 6) & 1 ? TRUE : FALSE;
      return makeOutputs(16, PINS_7447, out);
    }
  });

  /* ══════════════════════════════════════
     74138 — 3-to-8 Line Decoder (16-pin)
     Pin: 1=A, 2=B, 3=C, 4=G2A', 5=G2B', 6=G1,
          7=Y7', 8=GND, 9=Y6', 10=Y5', 11=Y4',
          12=Y3', 13=Y2', 14=Y1', 15=Y0', 16=VCC
     Outputs active LOW, Enable: G1=H, G2A'=L, G2B'=L
     ══════════════════════════════════════ */
  const PINS_74138 = {
    1:{dir:'in',label:'A'}, 2:{dir:'in',label:'B'}, 3:{dir:'in',label:'C'},
    4:{dir:'in',label:'G2A\''}, 5:{dir:'in',label:'G2B\''}, 6:{dir:'in',label:'G1'},
    7:{dir:'out',label:'Y7\''}, 8:{dir:'in',label:'GND'},
    9:{dir:'out',label:'Y6\''}, 10:{dir:'out',label:'Y5\''}, 11:{dir:'out',label:'Y4\''},
    12:{dir:'out',label:'Y3\''}, 13:{dir:'out',label:'Y2\''}, 14:{dir:'out',label:'Y1\''},
    15:{dir:'out',label:'Y0\''}, 16:{dir:'in',label:'VCC'}
  };

  const TTL_74138 = createDIP({
    partNo: '74138', name: '3:8 Decoder', pins: 16, pinDefs: PINS_74138,
    computeFn: function(inputs, attrs, pim) {
      const a = pinVal(inputs, 1, pim), b = pinVal(inputs, 2, pim), c = pinVal(inputs, 3, pim);
      const g2a = pinVal(inputs, 4, pim), g2b = pinVal(inputs, 5, pim), g1 = pinVal(inputs, 6, pim);

      const out = {};
      const yPins = [15, 14, 13, 12, 11, 10, 9, 7];

      const enabled = (g1 === TRUE && g2a === FALSE && g2b === FALSE);
      if (!enabled) {
        yPins.forEach(p => { out[p] = TRUE; });
      } else {
        const addr = (a === TRUE ? 1 : 0) | (b === TRUE ? 2 : 0) | (c === TRUE ? 4 : 0);
        yPins.forEach((p, i) => { out[p] = (i === addr) ? FALSE : TRUE; });
      }
      return makeOutputs(16, PINS_74138, out);
    }
  });

  /* ── Export all TTL types ── */
  L.TTL_TYPES = {
    TTL_7400: TTL_7400,
    TTL_7402: TTL_7402,
    TTL_7404: TTL_7404,
    TTL_7408: TTL_7408,
    TTL_7432: TTL_7432,
    TTL_7486: TTL_7486,
    TTL_7474: TTL_7474,
    TTL_7447: TTL_7447,
    TTL_74138: TTL_74138
  };

  L.TTL = { pinToPort, portToPin, pinVal, makeOutputs, createDIP };
})(window.LogicSim);
