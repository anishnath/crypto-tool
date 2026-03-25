/**
 * Relay — Electromechanical switch controlled by coil current.
 *
 * 4 terminals: coil+ (node[0]), coil- (node[1]), switch_A (node[2]), switch_B (node[3])
 *
 * When coil current > threshold: switch CLOSED (low R between A and B)
 * Otherwise: switch OPEN (high R between A and B)
 * Coil modeled as a resistor (coil resistance).
 */
import { CircuitElement } from '../element.js';

export class Relay extends CircuitElement {
  constructor(nCoilP, nCoilM, nSwA, nSwB, opts = {}) {
    super('relay', nCoilP, nCoilM);
    this.nodes = [nCoilP, nCoilM, nSwA, nSwB];
    this.volts = [0, 0, 0, 0];
    this.coilR = opts.coilR || 500;
    this.threshold = opts.threshold || 0.01;  // 10mA to activate
    this.ron = 0.01;
    this.roff = 1e8;
    this._activated = false;
  }

  getPostCount() { return 4; }
  isNonLinear() { return true; }

  stamp(mna) {
    // Coil: resistor between node[0] and node[1]
    mna.stampResistor(this.nodes[0], this.nodes[1], this.coilR);
    // Switch: variable resistor between node[2] and node[3]
    const r = this._activated ? this.ron : this.roff;
    mna.stampResistor(this.nodes[2], this.nodes[3], r);
  }

  doStep(mna) {
    const coilI = Math.abs((this.volts[0] - this.volts[1]) / this.coilR);
    const newState = coilI > this.threshold;
    if (newState !== this._activated) {
      this._activated = newState;
    }
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    this.current = (this.volts[0] - this.volts[1]) / this.coilR;
  }

  getInfo() {
    return {
      coilV: this.volts[0] - this.volts[1],
      coilI: this.current,
      activated: this._activated,
      switchR: this._activated ? this.ron : this.roff,
    };
  }
}
