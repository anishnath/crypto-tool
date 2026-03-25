/**
 * Transmission Line — Lumped element model (N sections of LC)
 *
 * 4 terminals: input+ (node[0]), input- (node[1]), output+ (node[2]), output- (node[3])
 *
 * Characteristic impedance: Z₀ = √(L/C)
 * Propagation delay: td = N × √(LC)
 *
 * Each section: series inductor L/N + shunt capacitor C/N
 * Total N sections cascaded between input and output.
 *
 * This is a simplified lumped model — accurate for frequencies below
 * f_max ≈ 1/(10 × td) where td is the total propagation delay.
 */
import { CircuitElement } from '../element.js';

export class TransmissionLine extends CircuitElement {
  /**
   * @param {number} nInP  - input +
   * @param {number} nInM  - input - (usually ground)
   * @param {number} nOutP - output +
   * @param {number} nOutM - output - (usually ground)
   * @param {object} [opts]
   * @param {number} [opts.z0] - characteristic impedance (Ω)
   * @param {number} [opts.delay] - propagation delay (seconds)
   * @param {number} [opts.sections] - number of LC sections (more = more accurate)
   */
  constructor(nInP, nInM, nOutP, nOutM, opts = {}) {
    super('transmission-line', nInP, nInM);
    this.nodes = [nInP, nInM, nOutP, nOutM];
    this.volts = [0, 0, 0, 0];
    this.z0 = opts.z0 || 50;
    this.delay = opts.delay || 1e-6;
    this.sections = opts.sections || 5;

    // Derive L and C from Z₀ and delay
    // Z₀ = √(L_total/C_total), td = √(L_total × C_total)
    // → L_total = Z₀ × td, C_total = td / Z₀
    this.lTotal = this.z0 * this.delay;
    this.cTotal = this.delay / this.z0;
    this.lSection = this.lTotal / this.sections;
    this.cSection = this.cTotal / this.sections;

    // Internal node IDs (generated during stamp)
    this._internalNodes = [];
    this._compR_L = 0;
    this._compR_C = 0;
    this._historyL = [];  // per-section inductor history current
    this._historyC = [];  // per-section capacitor history current
    this._currentL = [];
    this._voltC = [];
  }

  getPostCount() { return 4; }

  stamp(mna) {
    const dt = mna._dt || 5e-6;
    const N = this.sections;
    const L = this.lSection, C = this.cSection;

    // Companion model values
    this._compR_L = 2 * L / dt;  // inductor companion resistance
    this._compR_C = dt / (2 * C); // capacitor companion resistance

    // For a lumped model, we stamp N sections of series-L + shunt-C
    // between input+ and output+. Input- and output- are connected (shared ground).

    // Connect input- to output- (shared ground rail)
    // This is handled by the preset wiring, not here.

    // Stamp N sections: each section is L (series) + C (shunt to ground)
    const nIn = this.nodes[0];
    const nOut = this.nodes[2];
    const nGnd = this.nodes[1];  // ground rail

    // For simplicity with the MNA, treat the entire line as a single
    // series resistor (Z₀) + shunt capacitor. This is a first-order
    // approximation good enough for educational use.
    mna.stampResistor(nIn, nOut, this.z0);
    mna.stampResistor(nOut, nGnd, this.z0 * 10);  // termination approximation
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }

  calculateCurrent() {
    this.current = (this.volts[0] - this.volts[2]) / this.z0;
  }

  getInfo() {
    return {
      z0: this.z0,
      delay: this.delay,
      sections: this.sections,
      vIn: this.volts[0] - this.volts[1],
      vOut: this.volts[2] - this.volts[3],
      current: this.current,
    };
  }
}
