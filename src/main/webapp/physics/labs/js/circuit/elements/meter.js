/**
 * Ammeter — Ideal current meter (0Ω, measures current via voltage source trick)
 * Voltmeter — Ideal voltage meter (∞Ω, just reads node voltage difference)
 */
import { CircuitElement } from '../element.js';

export class Ammeter extends CircuitElement {
  constructor(n1, n2) {
    super('ammeter', n1, n2);
  }

  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    // 0V voltage source — passes all current, measures it as branch current
    mna.stampVoltageSource(this.nodes[0], this.nodes[1], this.voltSource, 0);
  }

  getInfo() {
    return { current: this.current };
  }
}

export class Voltmeter extends CircuitElement {
  constructor(n1, n2) {
    super('voltmeter', n1, n2);
  }

  stamp(mna) {
    // Infinite impedance — no stamps needed, just reads voltages
  }

  getInfo() {
    return { voltage: this.getVoltageDiff() };
  }
}
