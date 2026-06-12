/**
 * Topology validation + auto-repair for AI / import netlists.
 * Uses the same grid-node model as app.js (nodeId = gx * 10000 + gy).
 */

const SOURCE_TYPES = new Set(['dc-voltage', 'ac-voltage', 'dc-current', 'clock']);
const VOLTAGE_SOURCE_TYPES = new Set(['dc-voltage', 'ac-voltage']);

const HIDDEN_Y_PLUS_1 = new Set([
  'bjt-npn', 'bjt-pnp', 'darlington-npn', 'darlington-pnp',
  'mosfet-n', 'mosfet-p', 'jfet-n', 'jfet-p',
  'opamp', 'comparator',
  'and-gate', 'or-gate', 'nand-gate', 'nor-gate', 'xor-gate',
  'counter', 'shift-register', 'relay', 'ideal-switch', 'vco',
]);

const EXTRA_TERMINALS = {
  'd-flipflop': (x1, y1, x2, y2) => [[x2, y2 + 1], [x2, y2 + 2]],
  'sr-flipflop': (x1, y1, x2, y2) => [[x2, y2 + 1], [x2, y2 + 2]],
  'jk-flipflop': (x1, y1, x2, y2) => [[x2, y2 + 1], [x2, y2 + 2]],
  'mux': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1], [x2, y2 + 2]],
  'demux': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1], [x2, y2 + 2]],
  'half-adder': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1], [x2, y2 + 2]],
  'full-adder': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1], [x2, y2 + 2]],
  '555-timer': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1], [x2, y2 - 1]],
  'spdt-switch': (x1, y1, x2, y2) => [[x2, y2 + 1]],
  'relay': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
  'vcvs': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
  'vccs': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
  'ccvs': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
  'cccs': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
  'transmission-line': (x1, y1, x2, y2) => [[x1, y1 + 1], [x2, y2 + 1]],
};

function nodeId(gx, gy) {
  return gx * 10000 + gy;
}

function ptKey(gx, gy) {
  return gx + ',' + gy;
}

/** Grid terminals for one element descriptor (matches app.js _createElement). */
export function getElementTerminals(el) {
  if (!el?.type) return [];
  const x1 = el.x1 ?? 0;
  const y1 = el.y1 ?? 0;
  const x2 = el.x2 ?? x1;
  const y2 = el.y2 ?? y1;

  if (el.type === 'ground' || el.type === 'logic-input' || el.type === 'logic-output') {
    return [[x1, y1]];
  }
  if (el.type === 'not-gate' || el.type === 'schmitt' || el.type === 'schmitt-inv' || el.type === 'monostable') {
    return [[x1, y1], [x2, y2]];
  }

  const pts = [[x1, y1], [x2, y2]];
  if (HIDDEN_Y_PLUS_1.has(el.type)) {
    pts.push([x2, y2 + 1]);
  }
  const extra = EXTRA_TERMINALS[el.type];
  if (extra) pts.push(...extra(x1, y1, x2, y2));

  return pts;
}

class UnionFind {
  constructor() {
    this.parent = new Map();
  }

  find(n) {
    if (!this.parent.has(n)) this.parent.set(n, n);
    let p = this.parent.get(n);
    while (p !== this.parent.get(p)) {
      p = this.parent.get(p);
      this.parent.set(n, p);
    }
    this.parent.set(n, p);
    return p;
  }

  union(a, b) {
    const ra = this.find(a);
    const rb = this.find(b);
    if (ra !== rb) this.parent.set(rb, ra);
  }

  connected(a, b) {
    return this.find(a) === this.find(b);
  }
}

/** Build union-find over grid nodes (wires + shared coordinates). */
export function buildConnectivity(elements) {
  const uf = new UnionFind();
  const coordToNode = new Map();
  const nodeCoords = new Map();

  for (const el of elements) {
    for (const [gx, gy] of getElementTerminals(el)) {
      const id = nodeId(gx, gy);
      coordToNode.set(ptKey(gx, gy), id);
      nodeCoords.set(id, [gx, gy]);
      uf.find(id);
    }
  }

  // Same grid coordinate → same electrical node
  const byCoord = new Map();
  for (const [key, id] of coordToNode) {
    if (!byCoord.has(key)) byCoord.set(key, id);
    else uf.union(byCoord.get(key), id);
  }

  for (const el of elements) {
    if (el.type !== 'wire') continue;
    const a = nodeId(el.x1, el.y1);
    const b = nodeId(el.x2, el.y2);
    uf.find(a);
    uf.find(b);
    uf.union(a, b);
  }

  return { uf, nodeCoords, coordToNode };
}

function wireEndpoints(el) {
  return [
    nodeId(el.x1, el.y1),
    nodeId(el.x2, el.y2),
  ];
}

function normalizeWire(a, b) {
  return a <= b ? [a, b] : [b, a];
}

function hasWireBetween(elements, n1, n2) {
  for (const el of elements) {
    if (el.type !== 'wire') continue;
    const [a, b] = wireEndpoints(el);
    if (normalizeWire(a, b)[0] === normalizeWire(n1, n2)[0]
      && normalizeWire(a, b)[1] === normalizeWire(n1, n2)[1]) {
      return true;
    }
  }
  return false;
}

function addWireIfNeeded(elements, uf, x1, y1, x2, y2, repairs) {
  const a = nodeId(x1, y1);
  const b = nodeId(x2, y2);
  if (uf.connected(a, b)) return;
  if (hasWireBetween(elements, a, b)) return;
  elements.push({ type: 'wire', x1, y1, x2, y2, params: {} });
  uf.union(a, b);
  repairs.push(`Added wire (${x1},${y1})–(${x2},${y2})`);
}

function bboxOf(elements) {
  let minX = Infinity;
  let minY = Infinity;
  let maxX = -Infinity;
  let maxY = -Infinity;
  for (const el of elements) {
    for (const [gx, gy] of getElementTerminals(el)) {
      minX = Math.min(minX, gx);
      minY = Math.min(minY, gy);
      maxX = Math.max(maxX, gx);
      maxY = Math.max(maxY, gy);
    }
  }
  if (!Number.isFinite(minX)) return { minX: 0, minY: 0, maxX: 0, maxY: 0 };
  return { minX, minY, maxX, maxY };
}

/**
 * @param {Array} elements
 * @returns {{ valid: boolean, errors: string[], warnings: string[] }}
 */
export function validateCircuitTopology(elements) {
  const errors = [];
  const warnings = [];

  if (!elements?.length) {
    return { valid: false, errors: ['Circuit is empty.'], warnings };
  }

  const { uf } = buildConnectivity(elements);

  const hasSource = elements.some((e) => SOURCE_TYPES.has(e.type));
  const grounds = elements.filter((e) => e.type === 'ground');
  if (!hasSource) errors.push('Missing power source (dc-voltage, ac-voltage, dc-current, or clock).');
  if (!grounds.length) errors.push('Missing ground reference.');

  // Voltage source shorted by parallel wire
  for (const el of elements) {
    if (!VOLTAGE_SOURCE_TYPES.has(el.type)) continue;
    const neg = nodeId(el.x1, el.y1);
    const pos = nodeId(el.x2, el.y2);
    if (hasWireBetween(elements, neg, pos)) {
      errors.push('Wire shorts a voltage source (+ and − on the same segment).');
    }
  }

  // Source loop + ground reference connectivity
  let groundRoot = null;
  for (const g of grounds) {
    groundRoot = uf.find(nodeId(g.x1, g.y1));
    break;
  }

  const hotRoots = new Set();
  for (const el of elements) {
    if (!VOLTAGE_SOURCE_TYPES.has(el.type)) continue;
    const neg = uf.find(nodeId(el.x1, el.y1));
    const pos = uf.find(nodeId(el.x2, el.y2));
    if (neg === pos) {
      errors.push('Voltage source + and − terminals are not separated (shorted net).');
    } else {
      hotRoots.add(pos);
      hotRoots.add(neg);
    }
  }

  if (groundRoot != null && hotRoots.size) {
    let groundLinked = false;
    for (const hr of hotRoots) {
      if (hr === groundRoot) { groundLinked = true; break; }
    }
    if (!groundLinked) {
      errors.push('Ground is not connected to the power loop — add return wires to the bottom rail.');
    }
  }

  // Dangling terminals (degree-1) on non-trivial components
  const termCount = new Map();
  for (const el of elements) {
    if (el.type === 'wire' || el.type === 'ground') continue;
    for (const [gx, gy] of getElementTerminals(el)) {
      const id = uf.find(nodeId(gx, gy));
      termCount.set(id, (termCount.get(id) || 0) + 1);
    }
  }
  for (const el of elements) {
    if (el.type === 'wire' || el.type === 'ground' || SOURCE_TYPES.has(el.type)) continue;
    for (const [gx, gy] of getElementTerminals(el)) {
      const id = uf.find(nodeId(gx, gy));
      if (termCount.get(id) === 1) {
        warnings.push(`Floating node at (${gx},${gy}) on ${el.type} — may not simulate.`);
      }
    }
  }

  // Hidden terminals on 3-terminal devices
  for (const el of elements) {
    if (!HIDDEN_Y_PLUS_1.has(el.type)) continue;
    const hx = el.x2;
    const hy = (el.y2 ?? el.y1) + 1;
    const hid = uf.find(nodeId(hx, hy));
    if (termCount.get(hid) === 1) {
      warnings.push(`${el.type} hidden terminal at (${hx},${hy}) is not wired.`);
    }
  }

  return { valid: errors.length === 0, errors, warnings };
}

/**
 * Insert missing source/ground and closing wires (left-rail + bottom-rail pattern).
 * @param {Array} elements
 * @returns {{ elements: Array, repairs: string[], warnings: string[] }}
 */
export function repairCircuitTopology(elements) {
  const repairs = [];
  const out = elements.map((e) => ({ ...e, params: { ...(e.params || {}) } }));
  let { uf } = buildConnectivity(out);

  const box = bboxOf(out);
  const leftRailX = box.minX;
  const topRailY = box.minY;
  const bottomRailY = Math.max(box.maxY + 2, topRailY + 2);

  const hasSource = out.some((e) => SOURCE_TYPES.has(e.type));
  const hasGround = out.some((e) => e.type === 'ground');

  if (!hasSource) {
    out.unshift({
      type: 'dc-voltage',
      x1: leftRailX,
      y1: bottomRailY,
      x2: leftRailX,
      y2: topRailY,
      params: { voltage: 5 },
    });
    repairs.push(`Added 5 V dc-voltage on left rail (${leftRailX},${topRailY})–(${leftRailX},${bottomRailY}).`);
    ({ uf } = buildConnectivity(out));
  }

  if (!hasGround) {
    out.push({
      type: 'ground',
      x1: leftRailX,
      y1: bottomRailY,
      x2: leftRailX,
      y2: bottomRailY,
      params: {},
    });
    repairs.push(`Added ground at (${leftRailX},${bottomRailY}).`);
    ({ uf } = buildConnectivity(out));
  }

  // Wire any load terminal not yet on the ground net → bottom rail, then bus the rail
  const groundEl = out.find((e) => e.type === 'ground');
  const groundNode = groundEl ? nodeId(groundEl.x1, groundEl.y1) : nodeId(leftRailX, bottomRailY);
  let gnd = uf.find(groundNode);

  const sourcePlusKeys = new Set();
  for (const el of out) {
    if (VOLTAGE_SOURCE_TYPES.has(el.type)) {
      sourcePlusKeys.add(ptKey(el.x2, el.y2));
    }
  }

  for (const el of out) {
    if (el.type === 'wire' || el.type === 'ground') continue;
    if (VOLTAGE_SOURCE_TYPES.has(el.type)) continue;
    for (const [gx, gy] of getElementTerminals(el)) {
      if (sourcePlusKeys.has(ptKey(gx, gy))) continue;
      const nid = uf.find(nodeId(gx, gy));
      if (!uf.connected(nid, gnd)) {
        addWireIfNeeded(out, uf, gx, gy, gx, bottomRailY, repairs);
        ({ uf } = buildConnectivity(out));
        gnd = uf.find(groundNode);
      }
    }
  }

  // Do not wire source + to bottom rail (that shorts the battery). Source −
  // should already sit on the ground node when we placed both on the left rail.

  // Horizontal bottom-rail bus from left rail to rightmost column
  const busRightX = Math.max(box.maxX, leftRailX);
  for (let x = leftRailX + 1; x <= busRightX; x++) {
    if (!uf.connected(uf.find(nodeId(x, bottomRailY)), gnd)) {
      addWireIfNeeded(out, uf, x - 1, bottomRailY, x, bottomRailY, repairs);
      ({ uf } = buildConnectivity(out));
      gnd = uf.find(groundNode);
    }
  }

  // Tie source − to ground if still separate
  for (const el of out) {
    if (!VOLTAGE_SOURCE_TYPES.has(el.type)) continue;
    if (!uf.connected(uf.find(nodeId(el.x1, el.y1)), gnd)) {
      addWireIfNeeded(out, uf, el.x1, el.y1, groundEl.x1, groundEl.y1, repairs);
      ({ uf } = buildConnectivity(out));
    }
  }

  const validation = validateCircuitTopology(out);
  return { elements: out, repairs, warnings: validation.warnings };
}