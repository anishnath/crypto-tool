/**
 * VCO — Voltage-Controlled Oscillator
 *
 * 3 terminals: control voltage (node[0]), output (node[1]), ground ref (node[2])
 *
 * Output frequency = f_center + gain * (V_control - V_ref)
 * Output is a square wave voltage source.
 */
import { CircuitElement } from '../element.js';

export class VCO extends CircuitElement {
  constructor(nCtrl, nOut, nGnd, opts = {}) {
    super('vco', nCtrl, nOut);
    this.nodes = [nCtrl, nOut, nGnd];
    this.volts = [0, 0, 0];
    this.fCenter = opts.fCenter || 1000;   // center frequency (Hz)
    this.gain = opts.gain || 200;          // Hz per volt
    this.vRef = opts.vRef || 2.5;          // reference voltage
    this.vHigh = opts.vHigh || 5;
    this.vLow = opts.vLow || 0;
    this._phase = 0;
    this._outputHigh = false;
  }

  getPostCount() { return 3; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    // Output voltage source from ground to output
    mna.stampVoltageSource(this.nodes[2], this.nodes[1], this.voltSource, 0);
  }

  doStep(mna) {
    const vCtrl = this.volts[0] - this.volts[2];
    const freq = Math.max(1, this.fCenter + this.gain * (vCtrl - this.vRef));
    this._outputHigh = this._phase < 0.5;
    const v = this._outputHigh ? this.vHigh : this.vLow;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] += v;
    return true;
  }

  stepFinished(dt) {
    const vCtrl = this.volts[0] - this.volts[2];
    const freq = Math.max(1, this.fCenter + this.gain * (vCtrl - this.vRef));
    this._phase = (this._phase + freq * dt) % 1.0;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    const vCtrl = this.volts[0] - this.volts[2];
    const freq = Math.max(1, this.fCenter + this.gain * (vCtrl - this.vRef));
    return { vCtrl, frequency: freq, output: this._outputHigh ? 'HIGH' : 'LOW' };
  }
}
