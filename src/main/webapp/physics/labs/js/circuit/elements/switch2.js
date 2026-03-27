/**
 * Push Switch — Momentary contact (normally open, closed while clicked)
 * SPDT Switch — Single Pole Double Throw (3 terminals, toggles between two outputs)
 *
 * Push Switch: 2 terminals, acts as wire when pressed, open when released
 * SPDT: 3 terminals — common (node[0]), out A (node[1]), out B (node[2])
 *       In position A: common↔outA connected; In position B: common↔outB connected
 */
import { CircuitElement } from '../element.js';

const R_ON = 1e-3;   // very low resistance when closed
const R_OFF = 1e12;   // very high resistance when open

export class PushSwitch extends CircuitElement {
  constructor(n1, n2) {
    super('push-switch', n1, n2);
    this.closed = false;   // controlled by mouse click
    this.resistance = R_OFF;
  }

  stamp(mna) {
    this.resistance = this.closed ? R_ON : R_OFF;
    mna.stampConductance(this.nodes[0], this.nodes[1], 1 / this.resistance);
  }

  doStep(mna) {
    const r = this.closed ? R_ON : R_OFF;
    if (r !== this.resistance) {
      const oldG = 1 / this.resistance;
      const newG = 1 / r;
      mna.stampConductance(this.nodes[0], this.nodes[1], newG - oldG);
      this.resistance = r;
      return false; // state changed, need another NR pass
    }
    return true;
  }

  toggle() { this.closed = !this.closed; }
  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    this.current = (this.volts[0] - this.volts[1]) / this.resistance;
  }

  getInfo() { return { type: 'Push Switch', closed: this.closed }; }
}

export class SPDTSwitch extends CircuitElement {
  constructor(nCommon, nA, nB) {
    super('spdt-switch', nCommon, nA);
    this.nodes = [nCommon, nA, nB];
    this.volts = [0, 0, 0];
    this.position = 0; // 0 = connected to A, 1 = connected to B
  }

  getPostCount() { return 3; }

  stamp(mna) {
    const [nc, na, nb] = this.nodes;
    if (this.position === 0) {
      mna.stampConductance(nc, na, 1 / R_ON);
      mna.stampConductance(nc, nb, 1 / R_OFF);
    } else {
      mna.stampConductance(nc, na, 1 / R_OFF);
      mna.stampConductance(nc, nb, 1 / R_ON);
    }
  }

  toggle() { this.position = this.position === 0 ? 1 : 0; }
  setNodeVoltage(i, v) { this.volts[i] = v; }

  calculateCurrent() {
    const [nc, na, nb] = this.nodes;
    if (this.position === 0) {
      this.current = (this.volts[0] - this.volts[1]) / R_ON;
    } else {
      this.current = (this.volts[0] - this.volts[2]) / R_ON;
    }
  }

  getInfo() {
    return { type: 'SPDT Switch', position: this.position === 0 ? 'A' : 'B' };
  }
}
