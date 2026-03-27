/**
 * JFET — Junction Field-Effect Transistor (N-channel and P-channel)
 *
 * 3 terminals: Gate (node[0]), Drain (node[1]), Source (node[2])
 *
 * Simplified Shichman-Hodges model:
 *   Cutoff:     Vgs < Vp  → Id = 0
 *   Linear:     Vds < Vgs - Vp → Id = β[2(Vgs-Vp)Vds - Vds²](1+λVds)
 *   Saturation: Vds ≥ Vgs - Vp → Id = β(Vgs-Vp)²(1+λVds)
 *
 * N-channel: Vp < 0 (normally on, pinch off at negative Vgs)
 * P-channel: flip all voltage signs
 */
import { CircuitElement } from '../element.js';

const VT = 0.025865;

export class JFET extends CircuitElement {
  constructor(nGate, nDrain, nSource, opts = {}) {
    super('jfet', nGate, nDrain);
    this.nodes = [nGate, nDrain, nSource];
    this.volts = [0, 0, 0];
    this.pch = opts.pch ? -1 : 1;       // +1 N-ch, -1 P-ch
    this.idss = opts.idss || 0.01;       // max drain current (A) at Vgs=0
    this.vp = opts.vp || -3;             // pinch-off voltage (negative for N-ch)
    this.lambda = opts.lambda || 0.01;   // channel-length modulation
    this.beta = this.idss / (this.vp * this.vp);
    this.gmin = 1e-12;
    this._lastVgs = 0;
    this._lastVds = 0;
    this.ids = 0;
  }

  getPostCount() { return 3; }
  isNonLinear() { return true; }

  stamp(mna) { /* all in doStep */ }

  doStep(mna) {
    const p = this.pch;
    let vgs = p * (this.volts[0] - this.volts[2]);
    let vds = p * (this.volts[1] - this.volts[2]);

    // Voltage limiting
    if (Math.abs(vgs - this._lastVgs) > 0.5) vgs = this._lastVgs + 0.5 * Math.sign(vgs - this._lastVgs);
    if (Math.abs(vds - this._lastVds) > 0.5) vds = this._lastVds + 0.5 * Math.sign(vds - this._lastVds);
    this._lastVgs = vgs;
    this._lastVds = vds;

    const vpo = -this.vp; // positive pinch-off magnitude
    let id, gds, gm;

    if (vgs <= -vpo) {
      // Cutoff
      id = 0;
      gm = 0;
      gds = this.gmin;
    } else if (vds < vgs + vpo) {
      // Linear (triode)
      id = this.beta * (2 * (vgs + vpo) * vds - vds * vds) * (1 + this.lambda * vds);
      gm = 2 * this.beta * vds * (1 + this.lambda * vds);
      gds = this.beta * (2 * (vgs + vpo) - 2 * vds) * (1 + this.lambda * vds)
            + this.beta * (2 * (vgs + vpo) * vds - vds * vds) * this.lambda;
    } else {
      // Saturation
      const vov = vgs + vpo;
      id = this.beta * vov * vov * (1 + this.lambda * vds);
      gm = 2 * this.beta * vov * (1 + this.lambda * vds);
      gds = this.beta * vov * vov * this.lambda;
    }

    gds = Math.max(gds, this.gmin);

    // Check convergence against previous iteration's drain current
    const prevId = this.ids;
    this.ids = p * id;

    // Stamp as linearized: I_d = id0 + gm*(vgs-vgs0) + gds*(vds-vds0)
    // Equivalent current source: ieq = id - gm*vgs - gds*vds
    const ieq = id - gm * vgs - gds * vds;

    const [nG, nD, nS] = this.nodes;
    // gm: G→S controls D→S current
    mna.stampMatrix(nD, nG, p * gm);
    mna.stampMatrix(nD, nS, -(p * gm));
    mna.stampMatrix(nS, nG, -(p * gm));
    mna.stampMatrix(nS, nS, p * gm);

    // gds: D→S conductance
    mna.stampConductance(nD, nS, gds);

    // Current source
    mna.stampCurrentSource(nD, nS, p * ieq);

    // Gate leakage (very high impedance to ground for convergence)
    mna.stampConductance(nG, nS, this.gmin);

    return Math.abs(p * id - prevId) < 1e-6;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() { this.current = this.ids; }

  getInfo() {
    const vgs = this.volts[0] - this.volts[2];
    const vds = this.volts[1] - this.volts[2];
    return { type: this.pch < 0 ? 'P-JFET' : 'N-JFET', Vgs: vgs, Vds: vds, Id: this.ids };
  }
}
