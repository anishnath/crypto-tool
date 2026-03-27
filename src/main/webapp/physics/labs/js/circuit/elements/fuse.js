/**
 * Fuse — Blows (open circuit) when current exceeds rating
 * Lamp — Resistive load whose resistance increases with temperature (incandescent model)
 * Polarized Capacitor — Same as capacitor but with polarity indication
 */
import { CircuitElement } from '../element.js';

export class Fuse extends CircuitElement {
  /**
   * @param {number} n1
   * @param {number} n2
   * @param {number} rating - current rating in Amps
   */
  constructor(n1, n2, rating = 1) {
    super('fuse', n1, n2);
    this.rating = rating;
    this.blown = false;
    this.resistance = 0.01; // very low resistance when intact
  }

  stamp(mna) {
    const r = this.blown ? 1e12 : this.resistance;
    mna.stampConductance(this.nodes[0], this.nodes[1], 1 / r);
  }

  doStep(mna) {
    if (!this.blown) {
      const i = Math.abs((this.volts[0] - this.volts[1]) / this.resistance);
      if (i > this.rating) {
        this.blown = true;
        // Re-stamp: remove intact conductance, add open-circuit
        const oldG = 1 / this.resistance;
        const newG = 1 / 1e12;
        mna.stampConductance(this.nodes[0], this.nodes[1], newG - oldG);
        return false; // force another NR iteration
      }
    }
    return true;
  }

  reset() { this.blown = false; }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    const r = this.blown ? 1e12 : this.resistance;
    this.current = (this.volts[0] - this.volts[1]) / r;
  }

  getInfo() { return { type: 'Fuse', rating: this.rating + 'A', blown: this.blown }; }
}

export class Lamp extends CircuitElement {
  /**
   * Incandescent lamp: R increases with temperature.
   * R(T) ≈ R_cold × (T/T_room)^0.8 approximately.
   * Simplified: R = R_nom × (1 + α × |P|/P_nom) where P is power dissipated.
   */
  constructor(n1, n2, wattage = 60, voltage = 120) {
    super('lamp', n1, n2);
    this.wattage = wattage;
    this.nomVoltage = voltage;
    this.resistance = voltage * voltage / wattage; // hot resistance
    this.coldResistance = this.resistance / 10;     // cold is ~10x lower
    this._currentR = this.coldResistance;
    this.brightness = 0;
  }

  isNonLinear() { return true; }

  stamp(mna) {
    mna.stampConductance(this.nodes[0], this.nodes[1], 1 / this._currentR);
  }

  doStep(mna) {
    const v = this.volts[0] - this.volts[1];
    const p = v * v / this._currentR;
    const pNom = this.wattage;
    // Resistance increases with power dissipation
    const ratio = Math.min(p / pNom, 1);
    const newR = this.coldResistance + (this.resistance - this.coldResistance) * ratio;
    const rClamped = Math.max(newR, 1);

    const converged = Math.abs(rClamped - this._currentR) / (rClamped + 1) < 0.001;
    this._currentR = rClamped;
    this.brightness = Math.min(1, p / pNom);

    // Re-stamp
    mna.stampConductance(this.nodes[0], this.nodes[1], 1 / this._currentR);
    return converged;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    this.current = (this.volts[0] - this.volts[1]) / this._currentR;
  }

  getInfo() {
    return { type: 'Lamp', wattage: this.wattage, brightness: (this.brightness * 100).toFixed(0) + '%',
             resistance: this._currentR.toFixed(1) + 'Ω' };
  }
}

export class PolarizedCapacitor extends CircuitElement {
  /**
   * Same as regular capacitor but with polarity marking.
   * Negative voltage is flagged (real electrolytics can fail with reverse polarity).
   */
  constructor(n1, n2, capacitance = 100e-6) {
    super('polarized-cap', n1, n2);
    this.capacitance = capacitance;
    this.compResistance = 0;
    this.compCurrent = 0;
    this.curSourceValue = 0;
    this.reverseWarning = false;
  }

  getVoltageSourceCount() { return 0; }

  startIteration() {
    if (this.compResistance === 0) return; // first step
    const v = this.volts[0] - this.volts[1];
    this.curSourceValue = -v / this.compResistance - this.compCurrent;
    this.reverseWarning = v < -0.5;
  }

  stamp(mna) {
    const dt = mna.dt || 1 / 120;
    this.compResistance = dt / (2 * this.capacitance);
    if (this.compResistance <= 0 || !isFinite(this.compResistance)) {
      this.compResistance = 1e8;
    }
    mna.stampConductance(this.nodes[0], this.nodes[1], 1 / this.compResistance);
  }

  doStep(mna) {
    mna.stampCurrentSource(this.nodes[0], this.nodes[1], this.curSourceValue);
    return true;
  }

  setNodeVoltage(i, v) { this.volts[i] = v; }
  calculateCurrent() {
    const v = this.volts[0] - this.volts[1];
    this.current = this.curSourceValue + v / this.compResistance;
  }

  getInfo() {
    return { type: 'Polarized Cap', capacitance: this.capacitance,
             reverse: this.reverseWarning ? '⚠ REVERSE!' : 'OK' };
  }
}
