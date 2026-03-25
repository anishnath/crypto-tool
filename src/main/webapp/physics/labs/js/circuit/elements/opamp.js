/**
 * Ideal Op-Amp
 *
 * 3 terminals: non-inverting input (+, node[0]), inverting input (-, node[1]), output (node[2])
 *
 * Ideal behavior:
 *   - Infinite input impedance (no current into inputs)
 *   - V+ = V- (virtual short, enforced by high-gain VCVS)
 *   - Output can source/sink unlimited current
 *
 * Implementation: Voltage source at output whose voltage = gain * (V+ - V-)
 * With very high gain (1e6), this enforces V+ ≈ V- in feedback circuits.
 * The output voltage is clamped to rail voltages if specified.
 */
import { CircuitElement } from '../element.js';

export class OpAmp extends CircuitElement {
  /**
   * @param {number} nPlus  - non-inverting input (+)
   * @param {number} nMinus - inverting input (-)
   * @param {number} nOut   - output
   * @param {object} [opts]
   * @param {number} [opts.gain] - open-loop gain (default 1e6)
   * @param {number} [opts.vPlus] - positive rail voltage (default +15)
   * @param {number} [opts.vMinus] - negative rail voltage (default -15)
   */
  constructor(nPlus, nMinus, nOut, opts = {}) {
    super('opamp', nPlus, nMinus);
    this.nodes = [nPlus, nMinus, nOut];
    this.volts = [0, 0, 0];
    this.gain = opts.gain || 1e6;
    this.vRailPlus = opts.vPlus ?? 15;
    this.vRailMinus = opts.vMinus ?? -15;
    this.maxOut = this.vRailPlus;
    this.minOut = this.vRailMinus;
  }

  getPostCount() { return 3; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    // Stamped in doStep for rail clamping support
  }

  doStep(mna) {
    const vn = (mna.nodeCount - 1) + this.voltSource;
    const rP = mna._idx(this.nodes[0]), rM = mna._idx(this.nodes[1]), rO = mna._idx(this.nodes[2]);

    // Compute ideal output
    const vDiff = this.volts[0] - this.volts[1];
    const vIdeal = this.gain * vDiff;

    if (vIdeal >= this.minOut && vIdeal <= this.maxOut) {
      // Normal operation: V_out = gain*(V+ - V-)
      if (rO >= 0) mna.a[vn][rO] += 1;
      if (rP >= 0) mna.a[vn][rP] -= this.gain;
      if (rM >= 0) mna.a[vn][rM] += this.gain;
    } else {
      // Rail-clamped: V_out = rail voltage (constant)
      if (rO >= 0) mna.a[vn][rO] += 1;
      mna.b[vn] += (vIdeal > this.maxOut ? this.maxOut : this.minOut);
    }

    // Output current column
    if (rO >= 0) mna.a[rO][vn] -= 1;

    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    return {
      vPlus: this.volts[0],
      vMinus: this.volts[1],
      vOut: this.volts[2],
      vDiff: this.volts[0] - this.volts[1],
      current: this.current,
      gain: this.gain,
    };
  }
}
