/**
 * Shared netlist encode/decode helpers for circuit-simulator AI flows.
 */
import { parseNetlist } from './netlist.js';

/** First token of a netlist line — keep in sync with netlist.js KNOWN_TYPES. */
const NETLIST_FIRST_TOKEN_RE = /^(wire|ground|resistor|capacitor|polarized-cap|inductor|switch|push-switch|spdt-switch|fuse|lamp|dc-voltage|ac-voltage|dc-current|clock|led|diode|zener|bjt-npn|bjt-pnp|mosfet-n|mosfet-p|jfet-n|jfet-p|opamp|comparator|schmitt|schmitt-inv|555-timer|monostable|relay|and-gate|or-gate|nand-gate|nor-gate|xor-gate|not-gate|d-flipflop|sr-flipflop|jk-flipflop|counter|shift-register|mux|demux|half-adder|full-adder|logic-input|logic-output|transmission-line|vco|ideal-switch|vcvs|vccs|ccvs|cccs|ammeter|voltmeter|seven-seg|darlington-npn|darlington-pnp)$/;

export function isNetlistLine(line) {
  const firstToken = (line || '').trim().split(/\s+/)[0];
  return NETLIST_FIRST_TOKEN_RE.test(firstToken);
}

export function ensureSourceAndGround(elements) {
  const out = [...elements];
  const types = out.map((e) => e.type);
  if (!types.some((t) => ['dc-voltage', 'ac-voltage', 'dc-current', 'clock'].includes(t))) {
    out.unshift({ type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } });
  }
  if (!types.includes('ground')) {
    let maxY = 0;
    for (const e of out) {
      maxY = Math.max(maxY, e.y1 || 0, e.y2 || 0);
    }
    out.push({ type: 'ground', x1: 0, y1: maxY, x2: 0, y2: maxY });
  }
  return out;
}

/**
 * Parse netlist text into simulator elements.
 * @param {string} text
 * @param {{ autoSourceGround?: boolean }} [opts]
 */
export function netlistTextToElements(text, opts = {}) {
  const { autoSourceGround = true } = opts;
  const { elements } = parseNetlist(text);
  return autoSourceGround ? ensureSourceAndGround(elements) : elements;
}
