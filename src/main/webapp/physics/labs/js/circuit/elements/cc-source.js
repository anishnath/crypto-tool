/**
 * Current-Controlled Sources: CCVS and CCCS
 *
 * CCVS: Output voltage = gain × sensing current
 * CCCS: Output current = gain × sensing current
 *
 * 4 terminals:
 *   node[0], node[1] = sensing branch (current flows n0→n1)
 *   node[2], node[3] = output branch
 *
 * The sensing branch is a 0V voltage source (ammeter) to measure current.
 * CCVS output is a dependent voltage source.
 * CCCS output is a dependent current source.
 */
import { CircuitElement } from '../element.js';

export class CCVS extends CircuitElement {
  /**
   * @param {number} nSenseP - sense positive terminal
   * @param {number} nSenseN - sense negative terminal
   * @param {number} nOutP - output positive terminal
   * @param {number} nOutN - output negative terminal
   * @param {number} gain - transresistance (Ω): V_out = gain × I_sense
   */
  constructor(nSenseP, nSenseN, nOutP, nOutN, gain = 1000) {
    super('ccvs', nSenseP, nSenseN);
    this.nodes = [nSenseP, nSenseN, nOutP, nOutN];
    this.volts = [0, 0, 0, 0];
    this.gain = gain;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; } // sense ammeter + output voltage source

  stamp(mna) {
    const [n0, n1, n2, n3] = this.nodes;
    const vs0 = this.voltSource;     // sense branch (0V source)
    const vs1 = this.voltSource + 1; // output voltage source

    // Sense branch: 0V source across n0-n1 (acts as ammeter)
    mna.stampVoltageSource(n0, n1, vs0, 0);

    // Output branch: voltage source across n2-n3
    // V_out = gain × I_sense
    // The current variable for sense is at row (nodeCount-1 + vs0)
    mna.stampVoltageSource(n2, n3, vs1, 0);

    // Couple: V_out = gain × I_sense
    // Row for vs1: V(n2) - V(n3) = gain × I_sense
    // I_sense is variable index (nodeCount-1 + vs0)
    const N = mna.nodeCount - 1;
    const rowOut = N + vs1;
    const colSense = N + vs0;
    mna.A[rowOut][colSense] -= this.gain;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    // Current through output
    this.current = 0; // set by solver via voltage source current
  }

  getInfo() {
    return { type: 'CCVS', gain: this.gain, unit: 'Ω' };
  }
}

export class CCCS extends CircuitElement {
  /**
   * @param {number} nSenseP - sense positive terminal
   * @param {number} nSenseN - sense negative terminal
   * @param {number} nOutP - output positive terminal
   * @param {number} nOutN - output negative terminal
   * @param {number} gain - current gain (dimensionless): I_out = gain × I_sense
   */
  constructor(nSenseP, nSenseN, nOutP, nOutN, gain = 10) {
    super('cccs', nSenseP, nSenseN);
    this.nodes = [nSenseP, nSenseN, nOutP, nOutN];
    this.volts = [0, 0, 0, 0];
    this.gain = gain;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 1; } // sense ammeter only

  stamp(mna) {
    const [n0, n1, n2, n3] = this.nodes;
    const vs0 = this.voltSource; // sense branch (0V source)

    // Sense branch: 0V source across n0-n1 (acts as ammeter)
    mna.stampVoltageSource(n0, n1, vs0, 0);

    // Output: current source I_out = gain × I_sense
    // I_sense is the current through vs0, variable index (nodeCount-1 + vs0)
    const N = mna.nodeCount - 1;
    const colSense = N + vs0;

    // Stamp: I at n2 += gain × I_sense, I at n3 -= gain × I_sense
    if (n2 > 0) mna.A[n2][colSense] += this.gain;
    if (n3 > 0) mna.A[n3][colSense] -= this.gain;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() { this.current = 0; }

  getInfo() {
    return { type: 'CCCS', gain: this.gain, unit: '' };
  }
}
