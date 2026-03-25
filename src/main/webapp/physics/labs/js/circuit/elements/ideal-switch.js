/**
 * Ideal Switch — Voltage-controlled ON/OFF
 *
 * 3 terminals: control (node[0]), terminal A (node[1]), terminal B (node[2])
 *
 * When V(control) > threshold: switch CLOSED (R = Ron ≈ 0.01Ω)
 * When V(control) < threshold: switch OPEN (R = Roff ≈ 1e8Ω)
 *
 * Used for power converters (buck/boost), sample-and-hold, etc.
 */
import { CircuitElement } from '../element.js';

export class IdealSwitch extends CircuitElement {
  constructor(nCtrl, nA, nB, opts = {}) {
    super('ideal-switch', nCtrl, nA);
    this.nodes = [nCtrl, nA, nB];
    this.volts = [0, 0, 0];
    this.threshold = opts.threshold || 2.5;
    this.ron = opts.ron || 0.01;
    this.roff = opts.roff || 1e8;
    this._closed = false;
  }

  getPostCount() { return 3; }

  stamp(mna) {
    // Stamp as variable resistor between A and B
    // Resistance depends on control voltage (from previous step)
    const r = this._closed ? this.ron : this.roff;
    mna.stampResistor(this.nodes[1], this.nodes[2], r);
  }

  doStep(mna) {
    const newClosed = this.volts[0] > this.threshold;
    if (newClosed !== this._closed) {
      this._closed = newClosed;
      // Resistance changed — need to re-stamp (handled by NR loop re-stamp)
    }
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }

  calculateCurrent() {
    const r = this._closed ? this.ron : this.roff;
    this.current = (this.volts[1] - this.volts[2]) / r;
  }

  isNonLinear() { return true; }  // resistance depends on voltage

  getInfo() {
    return {
      control: this.volts[0],
      vA: this.volts[1],
      vB: this.volts[2],
      closed: this._closed,
      current: this.current,
    };
  }
}
