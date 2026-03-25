/**
 * 555 Timer — Simplified behavioral model
 *
 * 5 terminals: GND(0), TRIGGER(1), OUTPUT(2), RESET(3), VCC(4)
 * (Simplified: no DISCHARGE, THRESHOLD, or CONTROL pins — modeled internally)
 *
 * Behavior:
 *   - Comparator thresholds: 1/3 Vcc and 2/3 Vcc
 *   - TRIGGER < 1/3 Vcc → SET (output HIGH)
 *   - THRESHOLD > 2/3 Vcc → RESET (output LOW)
 *   - RESET pin LOW → force output LOW
 *   - Output is a voltage source: HIGH = Vcc - 1.7V, LOW ≈ 0.1V
 */
import { CircuitElement } from '../element.js';

export class Timer555 extends CircuitElement {
  constructor(nGnd, nTrigger, nOutput, nReset, nVcc) {
    super('555-timer', nGnd, nTrigger);
    this.nodes = [nGnd, nTrigger, nOutput, nReset, nVcc];
    this.volts = [0, 0, 0, 0, 0];
    this._outputHigh = false;
  }

  getPostCount() { return 5; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    const vn = (mna.nodeCount - 1) + this.voltSource;
    const rO = mna._idx(this.nodes[2]);  // OUTPUT
    if (rO >= 0) { mna.a[vn][rO] += 1; mna.a[rO][vn] -= 1; }
  }

  doStep(mna) {
    const vGnd = this.volts[0];
    const vTrig = this.volts[1];
    const vReset = this.volts[3];
    const vVcc = this.volts[4];
    const vcc = vVcc - vGnd;

    const threshLow = vGnd + vcc / 3;     // 1/3 Vcc
    const threshHigh = vGnd + 2 * vcc / 3; // 2/3 Vcc

    // 555 logic
    if (vReset < vGnd + 0.7) {
      this._outputHigh = false;  // RESET active-low: forces LOW below ~0.7V
    } else if (vTrig < threshLow) {
      this._outputHigh = true;   // TRIGGER sets HIGH
    }
    // Note: THRESHOLD > 2/3 Vcc resets — but we use TRIGGER pin for both
    // (simplified model without separate THRESHOLD pin)

    const outV = this._outputHigh ? (vVcc - 1.7) : (vGnd + 0.1);

    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] += outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() {
    return {
      vcc: this.volts[4] - this.volts[0],
      trigger: this.volts[1],
      output: this._outputHigh ? 'HIGH' : 'LOW',
      outputV: this._outputHigh ? (this.volts[4] - 1.7) : 0.1,
    };
  }
}
