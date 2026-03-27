/**
 * Comparator — outputs HIGH when V+ > V-, LOW otherwise
 * Schmitt Trigger — comparator with hysteresis
 *
 * 3 terminals: V+ (node[0]), V- (node[1]), Output (node[2])
 * Output is a voltage source: V_HIGH (5V) or V_LOW (0V)
 */
import { CircuitElement } from '../element.js';

const V_HIGH = 5;
const V_LOW = 0;

export class Comparator extends CircuitElement {
  constructor(nPlus, nMinus, nOut) {
    super('comparator', nPlus, nMinus);
    this.nodes = [nPlus, nMinus, nOut];
    this.volts = [0, 0, 0];
    this._outV = V_LOW;
  }

  getPostCount() { return 3; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[2], this.voltSource, 0);
  }

  doStep(mna) {
    const vDiff = this.volts[0] - this.volts[1];
    this._outV = vDiff > 0 ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    return { type: 'Comparator', 'V+': this.volts[0], 'V-': this.volts[1], output: this._outV };
  }
}

export class SchmittTrigger extends CircuitElement {
  /**
   * @param {number} nIn - input
   * @param {number} nOut - output
   * @param {object} opts
   * @param {number} opts.vHigh - upper threshold (default 3.3V)
   * @param {number} opts.vLow - lower threshold (default 1.7V)
   * @param {boolean} opts.inverting - if true, output is inverted
   */
  constructor(nIn, nOut, opts = {}) {
    super('schmitt', nIn, nOut);
    this.vHigh = opts.vHigh || 3.3;
    this.vLow = opts.vLow || 1.7;
    this.inverting = opts.inverting || false;
    this._state = false; // false = low output, true = high output
    this._outV = V_LOW;
  }

  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[1], this.voltSource, 0);
  }

  doStep(mna) {
    const vin = this.volts[0];
    if (!this._state && vin > this.vHigh) this._state = true;
    else if (this._state && vin < this.vLow) this._state = false;

    const logicOut = this.inverting ? !this._state : this._state;
    this._outV = logicOut ? V_HIGH : V_LOW;

    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    return {
      type: this.inverting ? 'Schmitt (Inv)' : 'Schmitt Trigger',
      input: this.volts[0], output: this._outV,
      thresholds: this.vLow + '/' + this.vHigh + 'V',
    };
  }
}
