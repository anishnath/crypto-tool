/**
 * Controlled Sources — Linear dependent sources
 *
 * VCVS: Voltage-Controlled Voltage Source — Vout = gain × Vin
 * VCCS: Voltage-Controlled Current Source — Iout = gm × Vin
 * CCVS: Current-Controlled Voltage Source — Vout = rm × Iin
 * CCCS: Current-Controlled Current Source — Iout = gain × Iin
 *
 * VCVS: 4 terminals — ctrl+(0), ctrl-(1), out+(2), out-(3)
 * VCCS: 4 terminals — ctrl+(0), ctrl-(1), out+(2), out-(3)
 */
import { CircuitElement } from '../element.js';

export class VCVS extends CircuitElement {
  constructor(nCP, nCM, nOP, nOM, gain = 1) {
    super('vcvs', nCP, nCM);
    this.nodes = [nCP, nCM, nOP, nOM];
    this.volts = [0, 0, 0, 0];
    this.gain = gain;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    const vn = (mna.nodeCount - 1) + this.voltSource;
    const rCP = mna._idx(this.nodes[0]), rCM = mna._idx(this.nodes[1]);
    const rOP = mna._idx(this.nodes[2]), rOM = mna._idx(this.nodes[3]);

    // KVL: V(out+) - V(out-) = gain × (V(ctrl+) - V(ctrl-))
    if (rOP >= 0) mna.a[vn][rOP] += 1;
    if (rOM >= 0) mna.a[vn][rOM] -= 1;
    if (rCP >= 0) mna.a[vn][rCP] -= this.gain;
    if (rCM >= 0) mna.a[vn][rCM] += this.gain;

    // Output current column
    if (rOP >= 0) mna.a[rOP][vn] -= 1;
    if (rOM >= 0) mna.a[rOM][vn] += 1;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() {
    const vCtrl = this.volts[0] - this.volts[1];
    const vOut = this.volts[2] - this.volts[3];
    return { vCtrl, vOut, gain: this.gain, current: this.current };
  }
}

export class VCCS extends CircuitElement {
  constructor(nCP, nCM, nOP, nOM, gm = 0.001) {
    super('vccs', nCP, nCM);
    this.nodes = [nCP, nCM, nOP, nOM];
    this.volts = [0, 0, 0, 0];
    this.gm = gm;  // transconductance (A/V)
  }

  getPostCount() { return 4; }

  stamp(mna) {
    const rCP = mna._idx(this.nodes[0]), rCM = mna._idx(this.nodes[1]);
    const rOP = mna._idx(this.nodes[2]), rOM = mna._idx(this.nodes[3]);

    // Iout = gm × (V(ctrl+) - V(ctrl-)), current from out+ to out-
    if (rOP >= 0 && rCP >= 0) mna.a[rOP][rCP] += this.gm;
    if (rOP >= 0 && rCM >= 0) mna.a[rOP][rCM] -= this.gm;
    if (rOM >= 0 && rCP >= 0) mna.a[rOM][rCP] -= this.gm;
    if (rOM >= 0 && rCM >= 0) mna.a[rOM][rCM] += this.gm;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    this.current = this.gm * (this.volts[0] - this.volts[1]);
  }
  getInfo() {
    return { vCtrl: this.volts[0] - this.volts[1], iOut: this.current, gm: this.gm };
  }
}
