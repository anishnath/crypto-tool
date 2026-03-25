/**
 * BJT Transistor — Simplified Ebers-Moll Model
 *
 * 3 terminals: Base (node[0]), Collector (node[1]), Emitter (node[2])
 *
 * Two junctions: B-E (forward) and B-C (reverse), each modeled as a diode.
 *
 * Key equations:
 *   cbe = Is * (exp(Vbe/Vt) - 1)        (B-E diode current)
 *   cbc = Is * (exp(Vbc/Vt) - 1)        (B-C diode current)
 *   Ic  = (cbe - cbc) - cbc/BR          (collector current)
 *   Ib  = cbe/beta + cbc/BR             (base current)
 *   Ie  = -(Ic + Ib)                    (emitter current)
 *
 * NPN: pnp = +1, PNP: pnp = -1 (flips voltage signs)
 *
 * Stamped as 3×3 admittance matrix + current vector each NR iteration.
 */
import { CircuitElement } from '../element.js';

const VT = 0.025865;

export class BJT extends CircuitElement {
  /**
   * @param {number} nBase
   * @param {number} nCollector
   * @param {number} nEmitter
   * @param {object} [opts]
   * @param {boolean} [opts.pnp] - true for PNP
   * @param {number} [opts.beta] - forward current gain (hFE)
   * @param {number} [opts.is] - saturation current
   */
  constructor(nBase, nCollector, nEmitter, opts = {}) {
    super('bjt', nBase, nCollector);
    this.nodes = [nBase, nCollector, nEmitter];
    this.volts = [0, 0, 0];
    this.pnp = opts.pnp ? -1 : 1;
    this.beta = opts.beta || 100;
    this.is = opts.is || 1e-13;
    this.br = opts.br || 1;        // reverse beta
    this.vt = VT;
    this.vcrit = this.vt * Math.log(this.vt / (Math.sqrt(2) * this.is));
    this.gmin = 1e-12;
    this.lastvbe = 0;
    this.lastvbc = 0;
    this.ic = 0;  // collector current
    this.ib = 0;  // base current
    this.ie = 0;  // emitter current
    this._iter = 0;
  }

  getPostCount() { return 3; }
  isNonLinear() { return true; }

  _limitStep(vnew, vold) {
    if (vnew > this.vcrit && Math.abs(vnew - vold) > 2 * this.vt) {
      if (vold > 0) {
        const arg = 1 + (vnew - vold) / this.vt;
        vnew = arg > 0 ? vold + this.vt * Math.log(arg) : this.vcrit;
      } else {
        vnew = this.vt * Math.log(vnew / this.vt);
      }
    }
    return vnew;
  }

  stamp(mna) { /* all stamping in doStep */ }

  doStep(mna) {
    this._iter++;
    const p = this.pnp;
    let vbc = p * (this.volts[0] - this.volts[1]);  // B-C
    let vbe = p * (this.volts[0] - this.volts[2]);  // B-E

    const dvbe = Math.abs(vbe - this.lastvbe);
    const dvbc = Math.abs(vbc - this.lastvbc);

    // Voltage limiting
    vbe = this._limitStep(vbe, this.lastvbe);
    vbc = this._limitStep(vbc, this.lastvbc);
    this.lastvbe = vbe;
    this.lastvbc = vbc;

    // Gmin stepping for convergence
    let gmin = this.gmin;
    if (this._iter > 50) gmin = Math.exp(-9 * Math.log(10) * (1 - this._iter / 300));

    // B-E junction
    let cbe, gbe;
    if (vbe > -5 * this.vt) {
      const ev = Math.exp(Math.min(vbe / this.vt, 500));
      cbe = this.is * (ev - 1) + gmin * vbe;
      gbe = this.is * ev / this.vt + gmin;
    } else {
      gbe = -this.is / vbe + gmin;
      cbe = gbe * vbe;
    }

    // B-C junction
    let cbc, gbc;
    if (vbc > -5 * this.vt) {
      const ev = Math.exp(Math.min(vbc / this.vt, 500));
      cbc = this.is * (ev - 1) + gmin * vbc;
      gbc = this.is * ev / this.vt + gmin;
    } else {
      gbc = -this.is / vbc + gmin;
      cbc = gbc * vbc;
    }

    // Terminal currents
    const cc = (cbe - cbc) - cbc / this.br;          // collector
    const cb = cbe / this.beta + cbc / this.br;      // base

    // Small-signal conductances
    const gpi = gbe / this.beta;   // base input conductance
    const gmu = gbc / this.br;     // feedback conductance
    const gm = Math.max(0, gbe - gmu);  // transconductance (clamped ≥ 0 for NR stability)
    const go = gbc;                 // output conductance (simplified)

    // Equivalent current sources
    const ceqbe = p * (cc + cb - vbe * (gm + go + gpi) + vbc * go);
    const ceqbc = p * (-cc + vbe * (gm + go) - vbc * (gmu + go));

    // Node indices: [0]=B, [1]=C, [2]=E
    const nB = this.nodes[0], nC = this.nodes[1], nE = this.nodes[2];

    // 3×3 admittance stamps
    mna.stampMatrix(nC, nC, gmu + go);
    mna.stampMatrix(nC, nB, -gmu + gm);
    mna.stampMatrix(nC, nE, -gm - go);

    mna.stampMatrix(nB, nB, gpi + gmu);
    mna.stampMatrix(nB, nE, -gpi);
    mna.stampMatrix(nB, nC, -gmu);

    mna.stampMatrix(nE, nB, -gpi - gm);
    mna.stampMatrix(nE, nC, -go);
    mna.stampMatrix(nE, nE, gpi + gm + go);

    // Current vector stamps
    mna.stampRHS(nB, -(ceqbe + ceqbc));
    mna.stampRHS(nC, ceqbc);
    mna.stampRHS(nE, ceqbe);

    // Store currents
    this.ic = p * cc;
    this.ib = p * cb;
    this.ie = p * (-cc - cb);

    return dvbe < 0.01 && dvbc < 0.01;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() { /* currents computed in doStep */ }

  getInfo() {
    return {
      vbe: this.pnp * (this.volts[0] - this.volts[2]),
      vbc: this.pnp * (this.volts[0] - this.volts[1]),
      vce: this.volts[1] - this.volts[2],
      ic: this.ic,
      ib: this.ib,
      ie: this.ie,
      beta: this.beta,
      type: this.pnp === 1 ? 'NPN' : 'PNP',
    };
  }
}
