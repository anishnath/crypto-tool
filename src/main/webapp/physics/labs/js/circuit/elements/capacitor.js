/**
 * Capacitor — Trapezoidal Companion Model
 *
 * Each timestep, replaced by Norton equivalent:
 *   Rc = dt / (2C)              (companion resistance)
 *   Ic = -Vdiff/Rc - I_prev    (trapezoidal history current)
 *
 * Stamps: resistor Rc ‖ current source Ic
 */
import { CircuitElement } from '../element.js';

export class Capacitor extends CircuitElement {
  constructor(n1, n2, capacitance = 1e-6) {
    super('capacitor', n1, n2);
    this.capacitance = capacitance;
    this.compResistance = 0;   // companion R, set during stamp
    this.curSourceValue = 0;   // history current source
  }

  stamp(mna) {
    const dt = mna._dt || 5e-6;
    this.compResistance = dt / (2 * this.capacitance);
    mna.stampResistor(this.nodes[0], this.nodes[1], this.compResistance);
  }

  startIteration() {
    if (this.compResistance === 0) return;  // guard before first stamp
    // Trapezoidal: Ic = -Vdiff/Rc - I_prev
    const vd = this.getVoltageDiff();
    this.curSourceValue = -vd / this.compResistance - this.current;
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
    return { voltage: v, current: this.current, capacitance: this.capacitance };
  }
}
