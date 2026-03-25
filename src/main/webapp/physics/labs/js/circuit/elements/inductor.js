/**
 * Inductor — Trapezoidal Companion Model
 *
 * Each timestep, replaced by Norton equivalent:
 *   Rc = 2L / dt               (companion resistance)
 *   Ic = Vdiff/Rc + I_prev     (trapezoidal history current)
 *
 * Stamps: resistor Rc ‖ current source Ic
 */
import { CircuitElement } from '../element.js';

export class Inductor extends CircuitElement {
  constructor(n1, n2, inductance = 1e-3) {
    super('inductor', n1, n2);
    this.inductance = inductance;
    this.compResistance = 0;
    this.curSourceValue = 0;
  }

  stamp(mna) {
    const dt = mna._dt || 5e-6;
    this.compResistance = 2 * this.inductance / dt;
    mna.stampResistor(this.nodes[0], this.nodes[1], this.compResistance);
  }

  startIteration() {
    if (this.compResistance === 0) return;  // guard before first stamp
    // Trapezoidal: Ic = Vdiff/Rc + I_prev
    const vd = this.getVoltageDiff();
    this.curSourceValue = vd / this.compResistance + this.current;
  }

  doStep(mna) {
    mna.stampCurrentSource(this.nodes[0], this.nodes[1], this.curSourceValue);
    return true;
  }

  calculateCurrent() {
    const vd = this.getVoltageDiff();
    this.current = vd / this.compResistance + this.curSourceValue;
  }

  getInfo() {
    const v = this.getVoltageDiff();
    return { voltage: v, current: this.current, inductance: this.inductance };
  }
}
