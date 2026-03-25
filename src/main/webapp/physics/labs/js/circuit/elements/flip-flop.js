/**
 * Flip-Flops — Edge-triggered sequential logic.
 *
 * D Flip-Flop: 4 terminals — D (node[0]), CLK (node[1]), Q (node[2]), Q̄ (node[3])
 * SR Flip-Flop: 4 terminals — S (node[0]), R (node[1]), Q (node[2]), Q̄ (node[3])
 * JK Flip-Flop: 5 terminals — J (node[0]), K (node[1]), CLK (node[2]), Q (node[3]), Q̄ (node[4])
 *
 * Outputs are voltage sources: Q = 5V or 0V, Q̄ = complement.
 */
import { CircuitElement } from '../element.js';

const V_HIGH = 5, V_LOW = 0, THRESHOLD = 2.5;
function isHigh(v) { return v > THRESHOLD; }

export class DFlipFlop extends CircuitElement {
  constructor(nD, nCLK, nQ, nQbar) {
    super('d-flipflop', nD, nCLK);
    this.nodes = [nD, nCLK, nQ, nQbar];
    this.volts = [0, 0, 0, 0];
    this._q = false;
    this._lastClk = false;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; }  // Q and Q̄

  stamp(mna) {
    const nc = mna.nodeCount - 1;
    // Q output voltage source
    const vnQ = nc + this.voltSource;
    const rQ = mna._idx(this.nodes[2]);
    if (rQ >= 0) { mna.a[vnQ][rQ] += 1; mna.a[rQ][vnQ] -= 1; }
    // Q̄ output voltage source
    const vnQb = nc + this.voltSource + 1;
    const rQb = mna._idx(this.nodes[3]);
    if (rQb >= 0) { mna.a[vnQb][rQb] += 1; mna.a[rQb][vnQb] -= 1; }
  }

  doStep(mna) {
    const clk = isHigh(this.volts[1]);
    // Rising edge detection
    if (clk && !this._lastClk) {
      this._q = isHigh(this.volts[0]);  // Capture D on rising edge
    }
    this._lastClk = clk;

    const nc = mna.nodeCount - 1;
    mna.b[nc + this.voltSource] += this._q ? V_HIGH : V_LOW;
    mna.b[nc + this.voltSource + 1] += this._q ? V_LOW : V_HIGH;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { D: this.volts[0], CLK: this.volts[1], Q: this._q ? V_HIGH : V_LOW }; }
}

export class SRFlipFlop extends CircuitElement {
  constructor(nS, nR, nQ, nQbar) {
    super('sr-flipflop', nS, nR);
    this.nodes = [nS, nR, nQ, nQbar];
    this.volts = [0, 0, 0, 0];
    this._q = false;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; }

  stamp(mna) {
    const nc = mna.nodeCount - 1;
    const vnQ = nc + this.voltSource;
    const rQ = mna._idx(this.nodes[2]);
    if (rQ >= 0) { mna.a[vnQ][rQ] += 1; mna.a[rQ][vnQ] -= 1; }
    const vnQb = nc + this.voltSource + 1;
    const rQb = mna._idx(this.nodes[3]);
    if (rQb >= 0) { mna.a[vnQb][rQb] += 1; mna.a[rQb][vnQb] -= 1; }
  }

  doStep(mna) {
    const s = isHigh(this.volts[0]), r = isHigh(this.volts[1]);
    if (s && !r) this._q = true;
    else if (!s && r) this._q = false;
    // S=R=1 → invalid, keep current state

    const nc = mna.nodeCount - 1;
    mna.b[nc + this.voltSource] += this._q ? V_HIGH : V_LOW;
    mna.b[nc + this.voltSource + 1] += this._q ? V_LOW : V_HIGH;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { S: this.volts[0], R: this.volts[1], Q: this._q ? V_HIGH : V_LOW }; }
}
