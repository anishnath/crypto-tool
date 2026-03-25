/**
 * Clock Source — Outputs a square wave (alternating HIGH/LOW).
 * 2 terminals: output (node[0]), ground ref (node[1])
 * Output is a voltage source toggling between V_HIGH and V_LOW at given frequency.
 */
import { CircuitElement } from '../element.js';

export class Clock extends CircuitElement {
  constructor(nOut, nGnd, frequency = 1000) {
    super('clock', nOut, nGnd);
    this.frequency = frequency;
    this.vHigh = 5;
    this.vLow = 0;
    this._time = 0;
    this._outputHigh = false;
  }

  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    const vn = (mna.nodeCount - 1) + this.voltSource;
    const rO = mna._idx(this.nodes[0]), rG = mna._idx(this.nodes[1]);
    if (rO >= 0) mna.a[vn][rO] += 1;
    if (rG >= 0) mna.a[vn][rG] -= 1;
    if (rO >= 0) mna.a[rO][vn] -= 1;
    if (rG >= 0) mna.a[rG][vn] += 1;
  }

  doStep(mna) {
    this._outputHigh = (this._time * this.frequency * 2) % 2 < 1;
    const v = this._outputHigh ? this.vHigh : this.vLow;
    mna.b[(mna.nodeCount - 1) + this.voltSource] += v;
    return true;
  }

  stepFinished(dt) { this._time += dt; }
  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { frequency: this.frequency, output: this._outputHigh ? 'HIGH' : 'LOW' }; }
}
