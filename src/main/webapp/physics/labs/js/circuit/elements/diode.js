/**
 * Diode — Newton-Raphson Linearization
 *
 * Shockley equation: I(Vd) = Is * (exp(Vd / (n*Vt)) - 1)
 *
 * Each NR sub-iteration, linearize at operating point Vd:
 *   Geq = dI/dVd = Is * exp(Vd/(n*Vt)) / (n*Vt) + gmin
 *   Nc  = I(Vd) - Geq * Vd   (Norton current for tangent line)
 *
 * Stamp: conductance Geq + current source Nc
 *
 * Voltage limiting prevents divergence when step > 2*n*Vt.
 */
import { CircuitElement } from '../element.js';

const VT = 0.025865;            // thermal voltage kT/q at 27°C
const CONVERGE_THRESH = 0.01;   // V
const DEFAULT_IS = 1.7143e-7;   // saturation current (A)
const DEFAULT_N = 2;            // emission coefficient

export class Diode extends CircuitElement {
  /**
   * @param {number} nAnode - anode node
   * @param {number} nCathode - cathode node
   * @param {object} [opts]
   * @param {number} [opts.is] - saturation current
   * @param {number} [opts.n]  - emission coefficient
   */
  constructor(nAnode, nCathode, opts = {}) {
    super('diode', nAnode, nCathode);
    this.is = opts.is || DEFAULT_IS;
    this.n = opts.n || DEFAULT_N;
    this.vscale = this.n * VT;
    this.vdcoef = 1 / this.vscale;
    this.vcrit = this.vscale * Math.log(this.vscale / (Math.sqrt(2) * this.is));
    this.gmin = this.is * 0.01;
    this.lastVd = 0;  // previous iteration voltage
  }

  isNonLinear() { return true; }

  /** Voltage limiting — prevent exponential blowup */
  _limitStep(vnew, vold) {
    if (vnew > this.vcrit && Math.abs(vnew - vold) > 2 * this.vscale) {
      if (vold > 0) {
        const arg = 1 + (vnew - vold) / this.vscale;
        vnew = arg > 0 ? vold + this.vscale * Math.log(arg) : this.vcrit;
      } else {
        vnew = this.vscale * Math.log(vnew / this.vscale);
      }
    } else if (vnew < 0 && Math.abs(vnew - vold) > 2 * this.vscale) {
      // Large negative step — limit
      vnew = vold > 0 ? -0.01 : vold - this.vscale;
    }
    return vnew;
  }

  stamp(mna) {
    // NR elements stamp during doStep, not here
    // But we still need the matrix structure to exist
  }

  doStep(mna) {
    let vd = this.volts[0] - this.volts[1];

    // Voltage limiting
    vd = this._limitStep(vd, this.lastVd);
    const dv = Math.abs(vd - this.lastVd);
    this.lastVd = vd;

    // Shockley equation
    const ev = Math.exp(Math.min(vd * this.vdcoef, 500));  // cap to prevent Infinity
    const id = this.is * (ev - 1);

    // Linearization: Geq and Norton current
    const geq = this.is * ev * this.vdcoef + this.gmin;
    const nc = id - geq * vd;

    // Stamp linearized conductance + current source
    const n0 = this.nodes[0], n1 = this.nodes[1];
    mna.stampConductance(n0, n1, geq);
    mna.stampCurrentSource(n0, n1, nc);

    // Convergence check
    return dv < CONVERGE_THRESH;
  }

  calculateCurrent() {
    const vd = this.getVoltageDiff();
    const ev = Math.exp(Math.min(vd * this.vdcoef, 500));
    this.current = this.is * (ev - 1);
  }

  getInfo() {
    const vd = this.getVoltageDiff();
    return {
      voltage: vd,
      current: this.current,
      power: vd * this.current,
      is: this.is,
      n: this.n,
    };
  }
}

/**
 * LED — Diode with a visual light indicator
 * Same physics as diode, different default parameters.
 */
export class LED extends Diode {
  constructor(nAnode, nCathode, opts = {}) {
    super(nAnode, nCathode, {
      is: opts.is || 2.3e-9,   // typical LED Is
      n: opts.n || 1.8,
      ...opts,
    });
    this.type = 'led';
    this.color = opts.color || 'red';
  }

  /** Brightness 0..1 based on forward current */
  getBrightness() {
    return Math.min(1, Math.max(0, this.current / 0.02));  // 20mA = full brightness
  }

  getInfo() {
    return { ...super.getInfo(), brightness: this.getBrightness(), color: this.color };
  }
}

/**
 * Zener Diode — Normal diode forward + breakdown in reverse
 * Forward: standard Shockley. Reverse beyond Vz: conducts.
 */
export class ZenerDiode extends CircuitElement {
  constructor(nAnode, nCathode, opts = {}) {
    super('zener', nAnode, nCathode);
    this.vz = opts.vz || 5.1;          // Zener breakdown voltage
    this.is = opts.is || DEFAULT_IS;
    this.n = opts.n || DEFAULT_N;
    this.vscale = this.n * VT;
    this.vdcoef = 1 / this.vscale;
    this.vcrit = this.vscale * Math.log(this.vscale / (Math.sqrt(2) * this.is));
    this.gmin = this.is * 0.01;
    this.izs = opts.izs || 1e-6;       // Zener knee current
    this.lastVd = 0;
  }

  isNonLinear() { return true; }

  /** Voltage limiting — prevents exponential blowup in both directions */
  _limitStep(vnew, vold) {
    // Forward limiting (same as standard diode)
    if (vnew > this.vcrit && Math.abs(vnew - vold) > 2 * this.vscale) {
      if (vold > 0) {
        const arg = 1 + (vnew - vold) / this.vscale;
        vnew = arg > 0 ? vold + this.vscale * Math.log(arg) : this.vcrit;
      } else {
        vnew = this.vscale * Math.log(vnew / this.vscale);
      }
    }
    // Reverse limiting (breakdown region)
    if (vnew < -(this.vz + 2 * this.vscale) && Math.abs(vnew - vold) > 2 * this.vscale) {
      vnew = vold - this.vscale;
    }
    return vnew;
  }

  stamp(mna) {}

  doStep(mna) {
    let vd = this.volts[0] - this.volts[1];
    vd = this._limitStep(vd, this.lastVd);  // voltage limiting
    const dv = Math.abs(vd - this.lastVd);
    this.lastVd = vd;

    let geq, nc;

    if (vd >= -0.5) {
      // Forward: standard Shockley
      const ev = Math.exp(Math.min(vd * this.vdcoef, 500));
      const id = this.is * (ev - 1);
      geq = this.is * ev * this.vdcoef + this.gmin;
      nc = id - geq * vd;
    } else if (vd < -this.vz) {
      // Reverse breakdown: Zener conducts
      const vr = -(vd + this.vz);  // how far past breakdown
      const evr = Math.exp(Math.min(vr * this.vdcoef, 500));
      const ir = this.izs * (evr - 1);
      geq = this.izs * evr * this.vdcoef + this.gmin;
      // Current flows cathode→anode in breakdown (negative convention)
      const id_total = -ir - this.is;
      nc = id_total - geq * vd;
    } else {
      // Reverse (before breakdown): tiny leakage
      geq = this.gmin;
      nc = -this.is - geq * vd;
    }

    mna.stampConductance(this.nodes[0], this.nodes[1], geq);
    mna.stampCurrentSource(this.nodes[0], this.nodes[1], nc);

    return dv < CONVERGE_THRESH;
  }

  calculateCurrent() {
    const vd = this.getVoltageDiff();
    if (vd >= -0.5) {
      this.current = this.is * (Math.exp(Math.min(vd * this.vdcoef, 500)) - 1);
    } else if (vd < -this.vz) {
      const vr = -(vd + this.vz);
      this.current = -(this.izs * (Math.exp(Math.min(vr * this.vdcoef, 500)) - 1)) - this.is;
    } else {
      this.current = -this.is;
    }
  }

  getInfo() {
    const vd = this.getVoltageDiff();
    return { voltage: vd, current: this.current, vz: this.vz };
  }
}
