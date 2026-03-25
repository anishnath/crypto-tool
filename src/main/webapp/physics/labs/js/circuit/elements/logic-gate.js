/**
 * Logic Gates — Digital elements that output high/low based on inputs.
 *
 * All gates: 3 terminals — inputA (node[0]), inputB (node[1]), output (node[2])
 * NOT gate: 2 terminals — input (node[0]), output (node[1])
 *
 * Implementation: Each frame, read input voltages, compute output,
 * stamp a voltage source at the output to enforce the logic level.
 * Vhigh = 5V, Vlow = 0V. Threshold = 2.5V.
 */
import { CircuitElement } from '../element.js';

const V_HIGH = 5;
const V_LOW = 0;
const THRESHOLD = 2.5;

function isHigh(v) { return v > THRESHOLD; }

class LogicGate extends CircuitElement {
  constructor(type, n1, n2, nOut) {
    super(type, n1, n2);
    this.nodes = nOut !== undefined ? [n1, n2, nOut] : [n1, n2];
    this.volts = new Array(this.nodes.length).fill(0);
    this._outV = V_LOW;
  }

  getPostCount() { return this.nodes.length; }
  getVoltageSourceCount() { return 1; }

  /** Override in subclass: compute output from input voltages */
  _logic() { return false; }

  stamp(mna) {
    // Output voltage source referenced to ground (node 0).
    // Node 0 is excluded from matrix, so only output node is stamped.
    const nOut = this.nodes[this.nodes.length - 1];
    mna.stampVoltageSource(0, nOut, this.voltSource, 0);
  }

  doStep(mna) {
    this._outV = this._logic() ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] += this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    return {
      inputA: this.volts[0],
      inputB: this.volts.length > 2 ? this.volts[1] : undefined,
      output: this._outV,
      type: this.type,
    };
  }
}

export class ANDGate extends LogicGate {
  constructor(n1, n2, nOut) { super('and-gate', n1, n2, nOut); }
  _logic() { return isHigh(this.volts[0]) && isHigh(this.volts[1]); }
}

export class ORGate extends LogicGate {
  constructor(n1, n2, nOut) { super('or-gate', n1, n2, nOut); }
  _logic() { return isHigh(this.volts[0]) || isHigh(this.volts[1]); }
}

export class NANDGate extends LogicGate {
  constructor(n1, n2, nOut) { super('nand-gate', n1, n2, nOut); }
  _logic() { return !(isHigh(this.volts[0]) && isHigh(this.volts[1])); }
}

export class NORGate extends LogicGate {
  constructor(n1, n2, nOut) { super('nor-gate', n1, n2, nOut); }
  _logic() { return !(isHigh(this.volts[0]) || isHigh(this.volts[1])); }
}

export class XORGate extends LogicGate {
  constructor(n1, n2, nOut) { super('xor-gate', n1, n2, nOut); }
  _logic() { return isHigh(this.volts[0]) !== isHigh(this.volts[1]); }
}

export class NOTGate extends LogicGate {
  constructor(nIn, nOut) {
    super('not-gate', nIn, nOut);
    // NOT is 2-terminal: input=node[0], output=node[1]
  }
  getPostCount() { return 2; }
  _logic() { return !isHigh(this.volts[0]); }
}
