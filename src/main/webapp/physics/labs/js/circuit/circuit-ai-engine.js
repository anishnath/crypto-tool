/**
 * Shared netlist encode/decode helpers for circuit-simulator AI flows.
 */
import { parseNetlist } from './netlist.js';
import { repairCircuitTopology, validateCircuitTopology } from './circuit-topology.js';

/** First token of a netlist line — keep in sync with netlist.js KNOWN_TYPES. */
const NETLIST_FIRST_TOKEN_RE = /^(wire|ground|resistor|capacitor|polarized-cap|inductor|switch|push-switch|spdt-switch|fuse|lamp|dc-voltage|ac-voltage|dc-current|clock|led|diode|zener|bjt-npn|bjt-pnp|mosfet-n|mosfet-p|jfet-n|jfet-p|opamp|comparator|schmitt|schmitt-inv|555-timer|monostable|relay|and-gate|or-gate|nand-gate|nor-gate|xor-gate|not-gate|d-flipflop|sr-flipflop|jk-flipflop|counter|shift-register|mux|demux|half-adder|full-adder|logic-input|logic-output|transmission-line|vco|ideal-switch|vcvs|vccs|ccvs|cccs|ammeter|voltmeter|seven-seg|darlington-npn|darlington-pnp)$/;

export function isNetlistLine(line) {
  const firstToken = (line || '').trim().split(/\s+/)[0];
  return NETLIST_FIRST_TOKEN_RE.test(firstToken);
}

/**
 * Parse netlist text, optionally auto-repair topology, validate.
 * @param {string} text
 * @param {{ autoRepair?: boolean, validate?: boolean }} [opts]
 * @returns {{ elements: Array, repairs: string[], validation: { valid: boolean, errors: string[], warnings: string[] } }}
 */
export function netlistTextToElements(text, opts = {}) {
  const { autoRepair = true, validate = true } = opts;
  const { elements: parsed } = parseNetlist(text);
  let elements = parsed;
  let repairs = [];

  if (autoRepair) {
    const repaired = repairCircuitTopology(elements);
    elements = repaired.elements;
    repairs = repaired.repairs;
  }

  const validation = validate
    ? validateCircuitTopology(elements)
    : { valid: true, errors: [], warnings: [] };

  return { elements, repairs, validation };
}
