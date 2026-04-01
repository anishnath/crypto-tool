/**
 * AVRRunner — wires avr8js CPU + peripherals for ATmega328p (Arduino Uno).
 *
 * Usage:
 *   import { AVRRunner } from './runner.js';
 *   const runner = new AVRRunner(hexString);
 *   runner.onSerial = (char) => console.log(char);
 *   runner.start();
 */

import {
  CPU, avrInstruction,
  AVRIOPort, portBConfig, portCConfig, portDConfig,
  AVRTimer, timer0Config, timer1Config, timer2Config,
  AVRUSART, usart0Config,
  AVRADC, adcConfig,
  PinState,
} from 'https://unpkg.com/avr8js@0.21.0/dist/esm/index.js';

import { hexToProgMem } from './hex-parser.js';
import { PIN_MAP, PWM_PINS } from './pin-map.js';

const CPU_HZ = 16_000_000;
const MAX_DELTA_MS = 50;

export class AVRRunner {
  constructor(hexString) {
    const progMem = hexToProgMem(hexString);

    // Pad to 16K words (32KB flash, ATmega328p)
    const fullProg = new Uint16Array(16384);
    fullProg.set(progMem);

    this.cpu = new CPU(fullProg, 8192);

    // GPIO ports
    this.portB = new AVRIOPort(this.cpu, portBConfig);
    this.portC = new AVRIOPort(this.cpu, portCConfig);
    this.portD = new AVRIOPort(this.cpu, portDConfig);

    // Timers (required for delay(), millis(), PWM)
    this.timer0 = new AVRTimer(this.cpu, timer0Config);
    this.timer1 = new AVRTimer(this.cpu, timer1Config);
    this.timer2 = new AVRTimer(this.cpu, timer2Config);

    // USART (Serial)
    this.usart = new AVRUSART(this.cpu, usart0Config, CPU_HZ);
    this.usart.onByteTransmit = (value) => {
      if (this.onSerial) this.onSerial(String.fromCharCode(value));
    };

    // ADC (analogRead)
    this.adc = new AVRADC(this.cpu, adcConfig);

    // AVR: 5V reference, 10-bit ADC
    this.vRef = 5.0;

    // State
    this.running = false;
    this.speed = 1.0;
    this._frameId = null;
    this._lastTimestamp = 0;
    this._lastPortValues = { B: 0, C: 0, D: 0 };
    this._lastOcr = new Array(PWM_PINS.length).fill(0);

    // Listener arrays (replaces single callback slots — safe for any detach order)
    this._pinChangeListeners = [];
    this._pwmChangeListeners = [];

    // Legacy single callback (for serial monitor)
    /** @type {((char: string) => void) | null} */
    this.onSerial = null;

    this._setupPortListeners();
  }

  /** Add a pin change listener. Returns unsubscribe function. */
  addPinChangeListener(fn) {
    this._pinChangeListeners.push(fn);
    return () => {
      const idx = this._pinChangeListeners.indexOf(fn);
      if (idx >= 0) this._pinChangeListeners.splice(idx, 1);
    };
  }

  /** Add a PWM change listener. Returns unsubscribe function. */
  addPwmChangeListener(fn) {
    this._pwmChangeListeners.push(fn);
    return () => {
      const idx = this._pwmChangeListeners.indexOf(fn);
      if (idx >= 0) this._pwmChangeListeners.splice(idx, 1);
    };
  }

  /** Map port name to AVRIOPort instance */
  getPort(name) {
    if (name === 'portB') return this.portB;
    if (name === 'portC') return this.portC;
    if (name === 'portD') return this.portD;
    return null;
  }

  /**
   * Set an external pin state (e.g. button press → pull LOW)
   * @param {number} arduinoPin - Arduino pin number (0–19)
   * @param {boolean} high - true for HIGH, false for LOW
   */
  setPinState(arduinoPin, high) {
    const mapping = PIN_MAP[arduinoPin];
    if (!mapping) return;
    const port = this.getPort(mapping.port);
    if (!port) return;
    port.setPin(mapping.bit, high);
  }

  /**
   * Set ADC channel value (e.g. potentiometer)
   * @param {number} channel - ADC channel 0–5
   * @param {number} value - 0.0 to 5.0 (volts)
   */
  setADCValue(channel, value) {
    if (this.adc && this.adc.channelValues) {
      this.adc.channelValues[channel] = value;
    }
  }

  /** Start the simulation loop */
  start() {
    if (this.running) return;
    this.running = true;
    this._lastTimestamp = 0;

    const execute = (timestamp) => {
      if (!this.running) return;

      if (this._lastTimestamp === 0) {
        this._lastTimestamp = timestamp;
        this._frameId = requestAnimationFrame(execute);
        return;
      }

      const rawDelta = timestamp - this._lastTimestamp;
      const deltaMs = Math.min(rawDelta, MAX_DELTA_MS);
      this._lastTimestamp = timestamp;

      const cyclesToRun = Math.floor((CPU_HZ / 1000) * deltaMs * this.speed);

      try {
        for (let i = 0; i < cyclesToRun; i++) {
          avrInstruction(this.cpu);
          this.cpu.tick();
        }
        this._pollPwm();
      } catch (err) {
        console.error('AVR simulation error:', err);
        this.stop();
        return;
      }

      this._frameId = requestAnimationFrame(execute);
    };

    this._frameId = requestAnimationFrame(execute);
  }

  /** Pause simulation (preserves state) */
  pause() {
    this.running = false;
    if (this._frameId) {
      cancelAnimationFrame(this._frameId);
      this._frameId = null;
    }
  }

  /** Stop and reset CPU */
  stop() {
    this.pause();
    if (this.cpu) this.cpu.reset();
    this._lastPortValues = { B: 0, C: 0, D: 0 };
    this._lastOcr.fill(0);
  }

  /** Reset CPU without stopping the loop */
  reset() {
    if (this.cpu) this.cpu.reset();
  }

  // ── Internal ──

  _setupPortListeners() {
    const track = (port, portLetter, basePin) => {
      port.addListener((value, oldValue) => {
        if (value === this._lastPortValues[portLetter]) return;
        const changed = value ^ this._lastPortValues[portLetter];
        this._lastPortValues[portLetter] = value;

        if (this._pinChangeListeners.length === 0) return;
        for (let bit = 0; bit < 8; bit++) {
          if (changed & (1 << bit)) {
            const pin = basePin + bit;
            const high = !!(value & (1 << bit));
            for (const fn of this._pinChangeListeners) fn(pin, high);
          }
        }
      });
    };

    track(this.portD, 'D', 0);   // D0–D7
    track(this.portB, 'B', 8);   // D8–D13
    track(this.portC, 'C', 14);  // A0–A5
  }

  /** Poll OCR registers for PWM duty cycle changes */
  _pollPwm() {
    if (this._pwmChangeListeners.length === 0) return;
    for (let i = 0; i < PWM_PINS.length; i++) {
      const { pin, ocrAddr } = PWM_PINS[i];
      const duty = this.cpu.data[ocrAddr];
      if (duty !== this._lastOcr[i]) {
        this._lastOcr[i] = duty;
        for (const fn of this._pwmChangeListeners) fn(pin, duty);
      }
    }
  }
}

export { PinState };
