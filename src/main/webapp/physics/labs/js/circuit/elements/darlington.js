/**
 * Darlington Pair — Two cascaded BJTs for very high current gain (β²)
 *
 * 3 terminals: Base (node[0]), Collector (node[1]), Emitter (node[2])
 *
 * Internally modeled as two BJTs:
 *   Q1: base=Base, collector=Collector, emitter→internal node
 *   Q2: base=internal, collector=Collector, emitter=Emitter
 *   Overall β_eff ≈ β₁ × β₂
 *
 * For simplicity we use a single-BJT model with β_eff = β² and
 * Vbe_on ≈ 1.2V (two diode drops).
 */
import { CircuitElement } from '../element.js';

const VT = 0.025865;

export class Darlington extends CircuitElement {
  constructor(nBase, nCollector, nEmitter, opts = {}) {
    super('darlington', nBase, nCollector);
    this.nodes = [nBase, nCollector, nEmitter];
    this.volts = [0, 0, 0];
    this.pnp = opts.pnp ? -1 : 1;
    this.beta1 = opts.beta || 100;
    this.beta = this.beta1 * this.beta1; // effective gain ≈ β²
    this.is = opts.is || 1e-13;
    this.br = 1;
    this.vt = VT;
    this.vcrit = this.vt * Math.log(this.vt / (Math.sqrt(2) * this.is));
    this.gmin = 1e-12;
    this.lastvbe = 0;
    this.lastvbc = 0;
    this.ic = 0;
    this.ib = 0;
    this.ie = 0;
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

  stamp(mna) {}

  doStep(mna) {
    const p = this.pnp;
    // Darlington: two series B-E junctions → shift Is to model ~1.2V turn-on
    // Use standard Vt but effective Is_eff = Is × exp(-0.6/Vt) to shift threshold by one diode drop
    const vt = this.vt;
    const isEff = this.is * Math.exp(-0.6 / vt); // threshold shifted by ~0.6V (second junction)
    let vbc = p * (this.volts[0] - this.volts[1]);
    let vbe = p * (this.volts[0] - this.volts[2]);

    vbe = this._limitStep(vbe, this.lastvbe);
    vbc = this._limitStep(vbc, this.lastvbc);
    this.lastvbe = vbe;
    this.lastvbc = vbc;

    const expBE = Math.exp(Math.min(vbe / vt, 40));
    const expBC = Math.exp(Math.min(vbc / vt, 40));
    const cbe = isEff * (expBE - 1);
    const cbc = isEff * (expBC - 1);

    const gbe = Math.max(isEff * expBE / vt, this.gmin);
    const gbc = Math.max(isEff * expBC / vt, this.gmin);
    const gm = Math.max(gbe - gbc, 0);
    const go = (gbc + cbc / this.br);
    const gpi = gbe / this.beta + gbc / this.br;

    const ceqbe = cbe - gbe * vbe;
    const ceqbc = cbc - gbc * vbc;

    const [nB, nC, nE] = this.nodes;
    // Same stamp pattern as standard BJT
    mna.stampMatrix(nC, nC, go + gm);
    mna.stampMatrix(nC, nB, -(gm + go));
    mna.stampMatrix(nC, nE, go);
    mna.stampMatrix(nB, nB, gpi);
    mna.stampMatrix(nB, nC, -gbc / this.br);
    mna.stampMatrix(nB, nE, -(gpi - gbc / this.br));
    mna.stampMatrix(nE, nE, gpi + go + gm);
    mna.stampMatrix(nE, nC, -(go));
    mna.stampMatrix(nE, nB, -(gpi + gm));

    const ibEq = p * (ceqbe / this.beta - ceqbc / this.br);
    const icEq = p * (ceqbe - ceqbc - ceqbc / this.br);
    mna.stampCurrentSource(nB, nE, -ibEq);
    mna.stampCurrentSource(nC, nE, -icEq);

    this.ic = p * (cbe - cbc) - cbc / this.br;
    this.ib = p * (cbe / this.beta + cbc / this.br);
    this.ie = -(this.ic + this.ib);

    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() { this.current = this.ic; }

  getInfo() {
    return {
      type: (this.pnp < 0 ? 'PNP' : 'NPN') + ' Darlington',
      β_eff: this.beta, Ic: this.ic, Ib: this.ib,
      Vbe: this.volts[0] - this.volts[2],
    };
  }
}
