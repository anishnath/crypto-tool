/**
 * MOSFET — Simplified Level-1 SPICE Model
 *
 * 3 terminals: Gate (node[0]), Drain (node[1]), Source (node[2])
 *
 * N-channel (nch=true):
 *   Cutoff:     Vgs < Vth           → Id = 0
 *   Linear:     Vgs > Vth, Vds < Vgs-Vth  → Id = Kp*((Vgs-Vth)*Vds - Vds²/2)
 *   Saturation: Vgs > Vth, Vds >= Vgs-Vth → Id = Kp/2*(Vgs-Vth)²*(1+lambda*Vds)
 *
 * P-channel: flip signs (nch=false)
 *
 * Stamped via NR linearization: conductance gds + transconductance gm + current source
 */
import { CircuitElement } from '../element.js';

export class MOSFET extends CircuitElement {
  /**
   * @param {number} nGate
   * @param {number} nDrain
   * @param {number} nSource
   * @param {object} [opts]
   * @param {boolean} [opts.pch] - true for P-channel
   * @param {number} [opts.vth] - threshold voltage
   * @param {number} [opts.kp] - transconductance parameter (A/V²)
   * @param {number} [opts.lambda] - channel-length modulation
   */
  constructor(nGate, nDrain, nSource, opts = {}) {
    super('mosfet', nGate, nDrain);
    this.nodes = [nGate, nDrain, nSource];
    this.volts = [0, 0, 0];
    this.pch = opts.pch ? -1 : 1;   // +1 for NMOS, -1 for PMOS
    this.vth = opts.vth || 1.5;
    this.kp = opts.kp || 0.02;      // 20 mA/V²
    this.lambda = opts.lambda || 0;  // channel-length modulation
    this.lastVgs = 0;
    this.lastVds = 0;
    this._iter = 0;
  }

  getPostCount() { return 3; }
  isNonLinear() { return true; }

  stamp(mna) { /* NR stamps in doStep */ }

  doStep(mna) {
    this._iter++;
    const p = this.pch;
    let vgs = p * (this.volts[0] - this.volts[2]);  // G-S
    let vds = p * (this.volts[1] - this.volts[2]);  // D-S

    const dvgs = Math.abs(vgs - this.lastVgs);
    const dvds = Math.abs(vds - this.lastVds);
    this.lastVgs = vgs;
    this.lastVds = vds;

    // Gmin for numerical stability
    let gmin = 1e-12;
    if (this._iter > 50) gmin = Math.exp(-9 * Math.log(10) * (1 - this._iter / 300));

    let id, gm, gds;
    const vov = vgs - this.vth;  // overdrive voltage

    if (vov <= 0) {
      // Cutoff
      id = 0;
      gm = 0;
      gds = gmin;
    } else if (vds < vov) {
      // Linear (triode) region
      id = this.kp * (vov * vds - vds * vds / 2);
      gm = this.kp * vds;
      gds = this.kp * (vov - vds) + gmin;
    } else {
      // Saturation
      id = this.kp / 2 * vov * vov * (1 + this.lambda * vds);
      gm = this.kp * vov * (1 + this.lambda * vds);
      gds = this.kp / 2 * vov * vov * this.lambda + gmin;
    }

    // Norton equivalent current
    const ids = p * id;
    const ceq = ids - gm * vgs - gds * vds;

    const nG = this.nodes[0], nD = this.nodes[1], nS = this.nodes[2];

    // Admittance stamps (gate draws no current in ideal MOSFET)
    // Drain current: Id = gm*Vgs + gds*Vds + ceq
    mna.stampMatrix(nD, nD, gds);
    mna.stampMatrix(nD, nS, -gds - gm);
    mna.stampMatrix(nD, nG, gm);

    mna.stampMatrix(nS, nS, gds + gm);
    mna.stampMatrix(nS, nD, -gds);
    mna.stampMatrix(nS, nG, -gm);

    // Current source
    mna.stampRHS(nD, -p * ceq);
    mna.stampRHS(nS, p * ceq);

    this.current = ids;  // drain current

    return dvgs < 0.01 && dvds < 0.01;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {}

  getInfo() {
    const p = this.pch;
    return {
      vgs: p * (this.volts[0] - this.volts[2]),
      vds: p * (this.volts[1] - this.volts[2]),
      id: this.current,
      type: p === 1 ? 'NMOS' : 'PMOS',
      vth: this.vth,
    };
  }
}
