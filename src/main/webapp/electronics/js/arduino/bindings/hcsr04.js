/**
 * HC-SR04 Ultrasonic Sensor Binding — connects <wokwi-hc-sr04> to AVRRunner.
 *
 * Protocol:
 *   1. MCU sends 10µs HIGH pulse on TRIG pin
 *   2. Sensor sends ECHO pin HIGH for duration proportional to distance
 *      duration_µs = distance_cm × 58
 *
 * We detect the TRIG pulse (rising then falling edge on TRIG pin),
 * then after a brief delay, pulse ECHO HIGH for the appropriate duration.
 *
 * User adjusts distance via a slider/property on the element.
 */

const CPU_HZ = 16_000_000;

export class HcSr04Binding {
  /**
   * @param {HTMLElement} element - <wokwi-hc-sr04>
   * @param {import('../runner.js').AVRRunner} runner
   * @param {{trig: number, echo: number}} pins
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.trigPin = pins.trig;
    this.echoPin = pins.echo;
    this.distanceCm = 20; // default distance
    this._trigHigh = false;
    this._cleanups = [];
  }

  attach() {
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin !== this.trigPin) return;

      if (high) {
        this._trigHigh = true;
      } else if (this._trigHigh) {
        // Falling edge of TRIG — send echo pulse
        this._trigHigh = false;
        this._sendEchoPulse();
      }
    });

    this._cleanups = [unsub];
  }

  /** Set simulated distance in cm */
  setDistance(cm) {
    this.distanceCm = Math.max(2, Math.min(400, cm));
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }

  _sendEchoPulse() {
    // Echo duration: distance_cm × 58 µs
    const durationUs = this.distanceCm * 58;
    const durationCycles = Math.round(durationUs * (CPU_HZ / 1_000_000));

    // Small delay before echo (sensor processing time ~450µs)
    const delayCycles = Math.round(450 * (CPU_HZ / 1_000_000));

    // Use setTimeout to schedule the echo pulse asynchronously
    // (avr8js doesn't expose cycle-accurate scheduling externally)
    const delayMs = 450 / 1000; // 0.45ms
    const pulseMs = durationUs / 1000;

    setTimeout(() => {
      this.runner.setPinState(this.echoPin, true);
      setTimeout(() => {
        this.runner.setPinState(this.echoPin, false);
      }, pulseMs);
    }, delayMs);
  }
}
