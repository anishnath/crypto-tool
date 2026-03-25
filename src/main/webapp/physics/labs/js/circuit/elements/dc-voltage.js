/**
 * DC Voltage Source
 * Adds an extra matrix row to enforce V(nPos) - V(nNeg) = voltage.
 * Convention: current flows from nNeg (node[0]) to nPos (node[1]) inside the source.
 */
import { CircuitElement } from '../element.js';

export class DCVoltageSource extends CircuitElement {
  constructor(nNeg, nPos, voltage = 5) {
    super('dc-voltage', nNeg, nPos);
    this.voltage = voltage;
  }

  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(this.nodes[0], this.nodes[1], this.voltSource, this.voltage);
  }

  getInfo() {
    return { voltage: this.voltage, current: this.current, power: this.voltage * this.current };
  }
}
