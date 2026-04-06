/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Gate Components
   AND, OR, NOT, NAND, NOR, XOR, XNOR, Buffer
   ANSI/IEEE standard symbols rendered in SVG
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic } = L;
  const Port = L.Port;

  /* ── Gate geometry constants ── */
  const BODY_W   = 50;   // gate body width
  const PORT_GAP = 16;   // spacing between input ports
  const PORT_EXT = 8;    // port stub length beyond body
  const BUBBLE_R = 5;    // negation bubble radius

  /* ── Helpers ── */
  function inputPositions(n) {
    const totalH = (n - 1) * PORT_GAP;
    const ports = [];
    for (let i = 0; i < n; i++) {
      ports.push({ x: -(BODY_W / 2 + PORT_EXT), y: -totalH / 2 + i * PORT_GAP });
    }
    return ports;
  }

  function makeCreatePorts(numInputKey) {
    return function (attrs) {
      const n = attrs[numInputKey] || 2;
      const ins = inputPositions(n);
      const ports = ins.map(p => new Port('in', p.x, p.y, 1));
      ports.push(new Port('out', BODY_W / 2 + PORT_EXT, 0, 1));
      return ports;
    };
  }

  function makeCreatePortsNot() {
    return function () {
      return [
        new Port('in',  -(BODY_W / 2 + PORT_EXT), 0, 1),
        new Port('out',  (BODY_W / 2 + PORT_EXT), 0, 1)
      ];
    };
  }

  /* ── SVG Path builders ── */
  // All paths drawn with body centered at (0,0), facing right.
  // Body width = BODY_W (50), height adapts to input count.

  function bodyH(attrs) {
    const n = (attrs && attrs.inputs) || 2;
    return Math.max(36, (n - 1) * PORT_GAP + 20);
  }

  const Shapes = {
    AND(h) {
      const hw = BODY_W / 2, hh = h / 2;
      // Flat left, elliptical arc right — peak at x=hw
      const r = Math.min(hh, hw);
      const ax = hw - r;  // arc start x
      return `M${-hw},${-hh} L${ax},${-hh} A${r},${hh} 0 0,1 ${ax},${hh} L${-hw},${hh} Z`;
    },
    OR(h) {
      const hw = BODY_W / 2, hh = h / 2;
      // Concave left, convex right — peak at x=hw
      return `M${-hw},${-hh} Q${-hw + 14},0 ${-hw},${hh}` +
             ` Q${0},${hh} ${hw},0` +
             ` Q${0},${-hh} ${-hw},${-hh}`;
    },
    XOR(h) {
      const hw = BODY_W / 2, hh = h / 2;
      const orPath = `M${-hw},${-hh} Q${-hw + 14},0 ${-hw},${hh}` +
                     ` Q${0},${hh} ${hw},0` +
                     ` Q${0},${-hh} ${-hw},${-hh}`;
      const extraCurve = `M${-hw - 5},${-hh} Q${-hw + 9},0 ${-hw - 5},${hh}`;
      return orPath + ' ' + extraCurve;
    },
    NOT(h) {
      const hw = BODY_W / 2, hh = h / 2;
      // Triangle tip at (hw - BUBBLE_R*2, 0) then bubble fills to hw
      const tip = hw - BUBBLE_R * 2;
      return `M${-hw},${-hh} L${tip},0 L${-hw},${hh} Z`;
    },
    BUFFER(h) {
      const hw = BODY_W / 2, hh = h / 2;
      return `M${-hw},${-hh} L${hw},0 L${-hw},${hh} Z`;
    }
  };

  /* ── Render helpers for canvas ── */
  function renderGateSVG(comp, ctx) {
    // ctx = { createSVG, group } — called by canvas renderer
    const attrs = comp.attrs;
    const h = bodyH(attrs);
    const g = ctx.group;

    // Body path
    let shapeFn;
    const t = comp.type;
    if (t === 'AND' || t === 'NAND')       shapeFn = Shapes.AND;
    else if (t === 'OR' || t === 'NOR')    shapeFn = Shapes.OR;
    else if (t === 'XOR' || t === 'XNOR')  shapeFn = Shapes.XOR;
    else if (t === 'NOT')                   shapeFn = Shapes.NOT;
    else                                    shapeFn = Shapes.BUFFER;

    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', shapeFn(h));
    path.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
    path.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
    path.setAttribute('stroke-width', '1.5');
    g.appendChild(path);

    // Negation bubble for NAND, NOR, XNOR, NOT
    if (t === 'NAND' || t === 'NOR' || t === 'XNOR' || t === 'NOT') {
      const bx = (t === 'NOT') ? BODY_W / 2 - BUBBLE_R : BODY_W / 2;
      const bubble = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      bubble.setAttribute('cx', bx);
      bubble.setAttribute('cy', 0);
      bubble.setAttribute('r', BUBBLE_R);
      bubble.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
      bubble.setAttribute('stroke', 'var(--lg-gate-stroke, #94a3b8)');
      bubble.setAttribute('stroke-width', '1.5');
      g.appendChild(bubble);
    }

    // Port stubs (short lines from body edge to port position)
    // NOTE: these are LOCAL coordinates (g has translate+rotate)
    comp.ports.forEach((p, i) => {
      const bodyEdgeX = (p.dir === 'in') ? -(BODY_W / 2) : (BODY_W / 2);
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', bodyEdgeX);
      line.setAttribute('y1', p.ry);
      line.setAttribute('x2', p.rx);
      line.setAttribute('y2', p.ry);
      line.setAttribute('stroke', p.value.color());
      line.setAttribute('stroke-width', '2');
      g.appendChild(line);
    });

    // Label
    const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    label.setAttribute('x', 0);
    label.setAttribute('y', h / 2 + 14);
    label.setAttribute('text-anchor', 'middle');
    label.setAttribute('fill', 'var(--lg-muted)');
    label.setAttribute('font-size', '10');
    label.setAttribute('font-family', "'DM Sans', sans-serif");
    label.textContent = comp.type;
    g.appendChild(label);
  }

  /* ── Compute functions ── */
  function computeAND(inputs) {
    let result = TRUE;
    for (const v of inputs) result = Logic.and(result, v.get(0));
    return [Value.of(result)];
  }
  function computeOR(inputs) {
    let result = FALSE;
    for (const v of inputs) result = Logic.or(result, v.get(0));
    return [Value.of(result)];
  }
  function computeNOT(inputs)  { return [Value.of(Logic.not(inputs[0].get(0)))]; }
  function computeNAND(inputs) {
    let result = TRUE;
    for (const v of inputs) result = Logic.and(result, v.get(0));
    return [Value.of(Logic.not(result))];
  }
  function computeNOR(inputs) {
    let result = FALSE;
    for (const v of inputs) result = Logic.or(result, v.get(0));
    return [Value.of(Logic.not(result))];
  }
  function computeXOR(inputs) {
    let result = FALSE;
    for (const v of inputs) result = Logic.xor(result, v.get(0));
    return [Value.of(result)];
  }
  function computeXNOR(inputs) {
    let result = FALSE;
    for (const v of inputs) result = Logic.xor(result, v.get(0));
    return [Value.of(Logic.not(result))];
  }
  function computeBUFFER(inputs) { return [inputs[0]]; }

  /* ── Gate Type Definitions ── */
  const GATE_TYPES = {
    AND:    { type: 'AND',    label: 'AND Gate',    category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeAND,    render: renderGateSVG },
    OR:     { type: 'OR',     label: 'OR Gate',     category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeOR,     render: renderGateSVG },
    NOT:    { type: 'NOT',    label: 'NOT Gate',    category: 'Gates', defaultAttrs: {},            createPorts: makeCreatePortsNot(),      compute: computeNOT,    render: renderGateSVG },
    NAND:   { type: 'NAND',   label: 'NAND Gate',   category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeNAND,   render: renderGateSVG },
    NOR:    { type: 'NOR',    label: 'NOR Gate',    category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeNOR,    render: renderGateSVG },
    XOR:    { type: 'XOR',    label: 'XOR Gate',    category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeXOR,    render: renderGateSVG },
    XNOR:   { type: 'XNOR',   label: 'XNOR Gate',  category: 'Gates', defaultAttrs: { inputs: 2 }, createPorts: makeCreatePorts('inputs'), compute: computeXNOR,   render: renderGateSVG },
    BUFFER: { type: 'BUFFER', label: 'Buffer',      category: 'Gates', defaultAttrs: {},            createPorts: makeCreatePortsNot(),      compute: computeBUFFER, render: renderGateSVG },
  };

  L.GATE_TYPES = GATE_TYPES;
  L.Shapes     = Shapes;
  L.bodyH      = bodyH;
  L.BODY_W     = BODY_W;
  L.PORT_EXT   = PORT_EXT;
  L.BUBBLE_R   = BUBBLE_R;
})(window.LogicSim);
