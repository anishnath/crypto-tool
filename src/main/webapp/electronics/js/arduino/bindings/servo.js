/**
 * Servo Binding — connects <wokwi-servo> to AVRRunner.
 *
 * Arduino Servo.h uses Timer1 to generate 50Hz PWM with variable pulse width:
 *   544µs  → 0°
 *   1472µs → 90°
 *   2400µs → 180°
 *
 * Approach: poll OCR1A/OCR1B + ICR1 registers each frame to compute pulse width,
 * then map to angle. This works because Servo.h uses Timer1 in Fast PWM mode
 * (mode 14) with ICR1 as TOP, and OCR1A/B setting the pulse width.
 *
 * Servo typically goes on pin 9 (OCR1A) or pin 10 (OCR1B).
 */

const CPU_HZ = 16_000_000;
const MIN_PULSE_US = 544;
const MAX_PULSE_US = 2400;

// Timer1 register addresses (ATmega328p)
const TCCR1B = 0x81;
const ICR1L  = 0x86;
const ICR1H  = 0x87;
const OCR1AL = 0x88;
const OCR1AH = 0x89;
const OCR1BL = 0x8A;
const OCR1BH = 0x8B;

const PRESCALER_TABLE = { 1: 1, 2: 8, 3: 64, 4: 256, 5: 1024 };

export class ServoBinding {
  /**
   * @param {HTMLElement} element - <wokwi-servo> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} pin - Arduino pin (9 or 10 for Timer1)
   */
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._rafId = null;
  }

  attach() {
    const poll = () => {
      this._rafId = requestAnimationFrame(poll);

      const cpu = this.runner.cpu;
      if (!cpu) return;

      // Read Timer1 prescaler from TCCR1B[2:0]
      const tccr1b = cpu.data[TCCR1B] || 0;
      const csField = tccr1b & 0x07;
      const prescaler = PRESCALER_TABLE[csField];
      if (!prescaler) return; // timer stopped

      // Read ICR1 (TOP value for Fast PWM mode 14)
      const icr1 = (cpu.data[ICR1L] || 0) | ((cpu.data[ICR1H] || 0) << 8);
      if (icr1 === 0) return;

      // Read OCR1A or OCR1B depending on pin
      let ocr;
      if (this.pin === 9) {
        ocr = (cpu.data[OCR1AL] || 0) | ((cpu.data[OCR1AH] || 0) << 8);
      } else if (this.pin === 10) {
        ocr = (cpu.data[OCR1BL] || 0) | ((cpu.data[OCR1BH] || 0) << 8);
      } else {
        return;
      }

      // Convert OCR ticks to pulse width in microseconds
      // pulseUs = (OCR + 1) × prescaler / (F_CPU / 1_000_000)
      const pulseUs = ((ocr + 1) * prescaler) / (CPU_HZ / 1_000_000);

      // Ignore out-of-range values (timer not configured for servo)
      if (pulseUs < 300 || pulseUs > 3000) return;

      // Map pulse width to angle: 544µs→0°, 2400µs→180°
      const angle = ((pulseUs - MIN_PULSE_US) / (MAX_PULSE_US - MIN_PULSE_US)) * 180;
      this.element.angle = Math.max(0, Math.min(180, Math.round(angle)));
    };

    this._rafId = requestAnimationFrame(poll);
  }

  detach() {
    if (this._rafId !== null) {
      cancelAnimationFrame(this._rafId);
      this._rafId = null;
    }
    this.element.angle = 0;
  }
}
