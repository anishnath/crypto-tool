/**
 * AC Voltage Source
 * V(t) = Vpeak * sin(2π * freq * t + phase)
 * Uses a voltage source row in the matrix, updated each timestep.
 */
import { CircuitElement } from '../element.js';

export class ACVoltageSource extends CircuitElement {
  constructor(nNeg, nPos, peakVoltage = 5, frequency = 60, phase = 0) {
    super('ac-voltage', nNeg, nPos);
    this.peakVoltage = peakVoltage;
    this.frequency = frequency;
    this.phase = phase;
    this._time = 0;
  }

  getVoltageSourceCount() { return 1; }

  /** Voltage at current time */
  getVoltageAtTime(t) {
    return this.peakVoltage * Math.sin(2 * Math.PI * this.frequency * t + this.phase);
  }

  stamp(mna) {
    // Stamp voltage source structure (KVL row + current cols)
    // Voltage value goes on RHS, updated each step
    const vn = (mna.nodeCount - 1) + this.voltSource;
    const rn = mna._idx(this.nodes[0]), rp = mna._idx(this.nodes[1]);
    if (rp >= 0) mna.a[vn][rp] += 1;
    if (rn >= 0) mna.a[vn][rn] -= 1;
    if (rp >= 0) mna.a[rp][vn] -= 1;
    if (rn >= 0) mna.a[rn][vn] += 1;
    // RHS set during doStep
  }

  doStep(mna) {
    const v = this.getVoltageAtTime(this._time);
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] += v;
    return true;
  }

  stepFinished(dt) {
    this._time += dt;
  }

  getInfo() {
    const v = this.getVoltageAtTime(this._time);
    return { voltage: v, current: this.current, peakVoltage: this.peakVoltage, frequency: this.frequency };
  }
}
