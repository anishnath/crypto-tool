/**
 * Digital Components — JK Flip-Flop, Counter, Mux/Demux,
 * Shift Register, Half/Full Adder, Logic Input/Output, Monostable
 *
 * All digital components use voltage levels:
 *   HIGH = 5V, LOW = 0V, THRESHOLD = 2.5V
 *
 * Each outputs via voltage sources (enforced logic levels).
 */
import { CircuitElement } from '../element.js';

const V_HIGH = 5;
const V_LOW = 0;
const THRESHOLD = 2.5;
function isHigh(v) { return v > THRESHOLD; }

// ── JK Flip-Flop ──
// 4 terminals: J(0), CLK(1), K(2), Q(3)  [Q̄ not exposed for simplicity]
export class JKFlipFlop extends CircuitElement {
  constructor(nJ, nClk, nK, nQ) {
    super('jk-flipflop', nJ, nClk);
    this.nodes = [nJ, nClk, nK, nQ];
    this.volts = [0, 0, 0, 0];
    this._q = false;
    this._lastClk = false;
    this._outV = V_LOW;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[3], this.voltSource, 0);
  }

  doStep(mna) {
    const clk = isHigh(this.volts[1]);
    // Rising edge trigger
    if (clk && !this._lastClk) {
      const j = isHigh(this.volts[0]);
      const k = isHigh(this.volts[2]);
      if (j && k) this._q = !this._q;       // toggle
      else if (j) this._q = true;            // set
      else if (k) this._q = false;           // reset
      // else: hold
    }
    this._lastClk = clk;
    this._outV = this._q ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'JK Flip-Flop', Q: this._q }; }
}

// ── Counter (4-bit binary, rising edge) ──
// 3 terminals: CLK(0), Reset(1), Bit0_out(2)
// Outputs bit 0 only (chain counters for more bits)
export class Counter extends CircuitElement {
  constructor(nClk, nReset, nOut) {
    super('counter', nClk, nReset);
    this.nodes = [nClk, nReset, nOut];
    this.volts = [0, 0, 0];
    this._count = 0;
    this._lastClk = false;
    this._outV = V_LOW;
    this.modulus = 16; // count 0-15
  }

  getPostCount() { return 3; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[2], this.voltSource, 0);
  }

  doStep(mna) {
    // Reset
    if (isHigh(this.volts[1])) {
      this._count = 0;
    } else {
      const clk = isHigh(this.volts[0]);
      if (clk && !this._lastClk) {
        this._count = (this._count + 1) % this.modulus;
      }
      this._lastClk = clk;
    }
    this._outV = (this._count & 1) ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Counter', count: this._count }; }
}

// ── Multiplexer (2:1) ──
// 4 terminals: In0(0), In1(1), Select(2), Output(3)
export class Multiplexer extends CircuitElement {
  constructor(nIn0, nIn1, nSel, nOut) {
    super('mux', nIn0, nIn1);
    this.nodes = [nIn0, nIn1, nSel, nOut];
    this.volts = [0, 0, 0, 0];
    this._outV = V_LOW;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[3], this.voltSource, 0);
  }

  doStep(mna) {
    const sel = isHigh(this.volts[2]);
    this._outV = sel ? (isHigh(this.volts[1]) ? V_HIGH : V_LOW)
                     : (isHigh(this.volts[0]) ? V_HIGH : V_LOW);
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'MUX 2:1', select: isHigh(this.volts[2]) ? 1 : 0, output: this._outV }; }
}

// ── Demultiplexer (1:2) ──
// 4 terminals: Input(0), Select(1), Out0(2), Out1(3)
export class Demultiplexer extends CircuitElement {
  constructor(nIn, nSel, nOut0, nOut1) {
    super('demux', nIn, nSel);
    this.nodes = [nIn, nSel, nOut0, nOut1];
    this.volts = [0, 0, 0, 0];
    this._out0V = V_LOW;
    this._out1V = V_LOW;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[2], this.voltSource, 0);
    mna.stampVoltageSource(0, this.nodes[3], this.voltSource + 1, 0);
  }

  doStep(mna) {
    const inVal = isHigh(this.volts[0]);
    const sel = isHigh(this.volts[1]);
    this._out0V = (!sel && inVal) ? V_HIGH : V_LOW;
    this._out1V = (sel && inVal) ? V_HIGH : V_LOW;
    const N = mna.nodeCount - 1;
    mna.b[N + this.voltSource] = this._out0V;
    mna.b[N + this.voltSource + 1] = this._out1V;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'DEMUX 1:2', out0: this._out0V, out1: this._out1V }; }
}

// ── Shift Register (4-bit SIPO) ──
// 3 terminals: DataIn(0), CLK(1), Bit0_out(2)
export class ShiftRegister extends CircuitElement {
  constructor(nData, nClk, nOut) {
    super('shift-register', nData, nClk);
    this.nodes = [nData, nClk, nOut];
    this.volts = [0, 0, 0];
    this._bits = [false, false, false, false];
    this._lastClk = false;
    this._outV = V_LOW;
  }

  getPostCount() { return 3; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[2], this.voltSource, 0);
  }

  doStep(mna) {
    const clk = isHigh(this.volts[1]);
    if (clk && !this._lastClk) {
      // Shift right, new data enters at MSB
      for (let i = 0; i < this._bits.length - 1; i++) {
        this._bits[i] = this._bits[i + 1];
      }
      this._bits[this._bits.length - 1] = isHigh(this.volts[0]);
    }
    this._lastClk = clk;
    this._outV = this._bits[0] ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Shift Reg (4-bit)', bits: this._bits.map(b => b ? 1 : 0).join('') }; }
}

// ── Half Adder ──
// 4 terminals: A(0), B(1), Sum(2), Carry(3)
export class HalfAdder extends CircuitElement {
  constructor(nA, nB, nSum, nCarry) {
    super('half-adder', nA, nB);
    this.nodes = [nA, nB, nSum, nCarry];
    this.volts = [0, 0, 0, 0];
    this._sumV = V_LOW;
    this._carryV = V_LOW;
  }

  getPostCount() { return 4; }
  getVoltageSourceCount() { return 2; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[2], this.voltSource, 0);
    mna.stampVoltageSource(0, this.nodes[3], this.voltSource + 1, 0);
  }

  doStep(mna) {
    const a = isHigh(this.volts[0]);
    const b = isHigh(this.volts[1]);
    this._sumV = (a !== b) ? V_HIGH : V_LOW;  // XOR
    this._carryV = (a && b) ? V_HIGH : V_LOW;  // AND
    const N = mna.nodeCount - 1;
    mna.b[N + this.voltSource] = this._sumV;
    mna.b[N + this.voltSource + 1] = this._carryV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Half Adder', sum: this._sumV > 2.5 ? 1 : 0, carry: this._carryV > 2.5 ? 1 : 0 }; }
}

// ── Full Adder ──
// 5 terminals: A(0), B(1), Cin(2), Sum(3), Cout(4)
export class FullAdder extends CircuitElement {
  constructor(nA, nB, nCin, nSum, nCout) {
    super('full-adder', nA, nB);
    this.nodes = [nA, nB, nCin, nSum, nCout];
    this.volts = [0, 0, 0, 0, 0];
    this._sumV = V_LOW;
    this._coutV = V_LOW;
  }

  getPostCount() { return 5; }
  getVoltageSourceCount() { return 2; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[3], this.voltSource, 0);
    mna.stampVoltageSource(0, this.nodes[4], this.voltSource + 1, 0);
  }

  doStep(mna) {
    const a = isHigh(this.volts[0]);
    const b = isHigh(this.volts[1]);
    const cin = isHigh(this.volts[2]);
    const bits = (a ? 1 : 0) + (b ? 1 : 0) + (cin ? 1 : 0);
    const sum = (bits % 2) === 1;
    const cout = bits >= 2;
    this._sumV = sum ? V_HIGH : V_LOW;
    this._coutV = cout ? V_HIGH : V_LOW;
    const N = mna.nodeCount - 1;
    mna.b[N + this.voltSource] = this._sumV;
    mna.b[N + this.voltSource + 1] = this._coutV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Full Adder', sum: this._sumV > 2.5 ? 1 : 0, cout: this._coutV > 2.5 ? 1 : 0 }; }
}

// ── Logic Input (fixed HIGH or LOW, toggleable) ──
// 1 terminal: output
export class LogicInput extends CircuitElement {
  constructor(n1) {
    super('logic-input', n1, n1);
    this.nodes = [n1];
    this.volts = [0];
    this._state = false;
    this._outV = V_LOW;
  }

  getPostCount() { return 1; }
  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[0], this.voltSource, 0);
  }

  doStep(mna) {
    this._outV = this._state ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  toggle() { this._state = !this._state; }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Logic Input', state: this._state ? 'HIGH' : 'LOW' }; }
}

// ── Logic Output (LED-like indicator) ──
// 1 terminal: input (very high impedance)
export class LogicOutput extends CircuitElement {
  constructor(n1) {
    super('logic-output', n1, n1);
    this.nodes = [n1];
    this.volts = [0];
    this._state = false;
  }

  getPostCount() { return 1; }

  stamp(mna) {
    // Very high impedance to ground (just for the node to exist in the matrix)
    mna.stampConductance(this.nodes[0], 0, 1e-12);
  }

  doStep(mna) {
    this._state = isHigh(this.volts[0]);
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() { this.current = 0; }
  getInfo() { return { type: 'Logic Output', state: this._state ? 'HIGH' : 'LOW' }; }
}

// ── Monostable (One-Shot) ──
// 3 terminals: Trigger(0), Output(1), Ground(implicit)
// Produces a fixed-duration pulse on rising edge of trigger
export class Monostable extends CircuitElement {
  constructor(nTrig, nOut, opts = {}) {
    super('monostable', nTrig, nOut);
    this.pulseDuration = opts.duration || 0.001; // 1ms default
    this._lastTrig = false;
    this._firing = false;
    this._fireEnd = 0;
    this._outV = V_LOW;
    this._time = 0;
  }

  getVoltageSourceCount() { return 1; }

  stamp(mna) {
    mna.stampVoltageSource(0, this.nodes[1], this.voltSource, 0);
  }

  doStep(mna) {
    this._time += mna.dt || 1 / 120;
    const trig = isHigh(this.volts[0]);

    // Rising edge trigger
    if (trig && !this._lastTrig && !this._firing) {
      this._firing = true;
      this._fireEnd = this._time + this.pulseDuration;
    }
    this._lastTrig = trig;

    if (this._firing && this._time >= this._fireEnd) {
      this._firing = false;
    }

    this._outV = this._firing ? V_HIGH : V_LOW;
    const vn = (mna.nodeCount - 1) + this.voltSource;
    mna.b[vn] = this._outV;
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}
  getInfo() { return { type: 'Monostable', firing: this._firing, duration: this.pulseDuration + 's' }; }
}
