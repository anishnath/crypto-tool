/**
 * RP2040Runner — wires rp2040js CPU + peripherals for Raspberry Pi Pico.
 *
 * Same public API as AVRRunner so bindings work unchanged:
 *   - addPinChangeListener(fn) / addPwmChangeListener(fn)
 *   - setPinState(pin, high)
 *   - setADCValue(channel, voltage)
 *   - onSerial callback
 *   - start() / pause() / stop() / reset()
 *   - speed property
 */

import { RP2040, GPIOPinState, ConsoleLogger, LogLevel }
  from 'https://unpkg.com/rp2040js@1.3.1/dist/esm/index.js';

import { bootromB1 } from './rp2040-bootrom.js';
import { LED_BUILTIN, GPIO_COUNT } from './rp2040-pin-map.js';

const F_CPU = 125_000_000; // 125 MHz
const CYCLE_NANOS = 1e9 / F_CPU; // ~8ns per cycle
const FPS = 60;
const CYCLES_PER_FRAME = Math.floor(F_CPU / FPS); // ~2,083,333

export class RP2040Runner {
  /**
   * @param {Uint8Array} flashImage - decoded UF2 flash image (from uf2-parser.js)
   */
  constructor(flashImage) {
    this._flashImage = flashImage; // store for reset
    this.mcu = new RP2040();
    this.mcu.logger = new ConsoleLogger(LogLevel.Error);

    // Load bootrom
    this.mcu.loadBootrom(bootromB1);

    // Load program into flash
    this.mcu.flash.set(flashImage, 0);

    // State
    this.running = false;
    this.speed = 1.0;
    this._frameId = null;
    this._pinChangeListeners = [];
    this._pwmChangeListeners = [];
    this._gpioUnsubs = [];

    /** @type {((char: string) => void) | null} */
    this.onSerial = null;

    // Wire UART0 (default Serial)
    this.mcu.uart[0].onByte = (value) => {
      if (this.onSerial) this.onSerial(String.fromCharCode(value));
    };

    // Wire SPI loopback (default)
    this.mcu.spi[0].onTransmit = (v) => this.mcu.spi[0].completeTransmit(v);
    this.mcu.spi[1].onTransmit = (v) => this.mcu.spi[1].completeTransmit(v);

    // Default ADC values (mid-range for 3.3V, 12-bit)
    for (let ch = 0; ch < 4; ch++) this.mcu.adc.channelValues[ch] = 2048;
    this.mcu.adc.channelValues[4] = 876; // internal temp sensor ~27°C

    // Patch PIO to use synchronous stepping
    for (const pio of this.mcu.pio) {
      pio.run = function() {
        if (this.runTimer) { clearTimeout(this.runTimer); this.runTimer = null; }
      };
    }

    // Setup GPIO listeners
    this._setupGPIO();
  }

  // ── Public API (same interface as AVRRunner) ──

  addPinChangeListener(fn) {
    this._pinChangeListeners.push(fn);
    return () => {
      const idx = this._pinChangeListeners.indexOf(fn);
      if (idx >= 0) this._pinChangeListeners.splice(idx, 1);
    };
  }

  addPwmChangeListener(fn) {
    this._pwmChangeListeners.push(fn);
    return () => {
      const idx = this._pwmChangeListeners.indexOf(fn);
      if (idx >= 0) this._pwmChangeListeners.splice(idx, 1);
    };
  }

  setPinState(pin, high) {
    if (pin < 0 || pin >= GPIO_COUNT || !this.mcu) return;
    const gpio = this.mcu.gpio[pin];
    if (gpio) {
      gpio.setInputValue(high);
    }
  }

  setADCValue(channel, voltage) {
    if (!this.mcu || channel < 0 || channel > 4) return;
    // RP2040 ADC: 12-bit, 3.3V reference
    const raw = Math.round((voltage / 3.3) * 4095);
    this.mcu.adc.channelValues[channel] = Math.max(0, Math.min(4095, raw));
  }

  start() {
    if (this.running) return;
    this.running = true;

    const execute = () => {
      if (!this.running || !this.mcu) return;

      const cyclesTarget = Math.floor(CYCLES_PER_FRAME * this.speed);
      const { core } = this.mcu;
      const clock = this.mcu.clock;

      try {
        let cyclesDone = 0;
        while (cyclesDone < cyclesTarget) {
          if (core.waiting) {
            // CPU is in WFI/WFE — advance clock to next alarm
            if (clock) {
              const jump = clock.nanosToNextAlarm;
              if (jump <= 0) {
                // No alarm pending — tick by one cycle to prevent deadlock
                clock.tick(CYCLE_NANOS);
                cyclesDone++;
                this._stepPIO();
                break;
              }
              const jumped = Math.ceil(jump / CYCLE_NANOS);
              clock.tick(jump);
              cyclesDone += jumped;
              this._stepPIO();
            } else {
              break;
            }
          } else {
            const cycles = core.executeInstruction();
            if (clock) clock.tick(cycles * CYCLE_NANOS);
            cyclesDone += cycles;
            // Step PIO
            this._stepPIO();
          }
        }
      } catch (err) {
        console.error('[RP2040] Simulation error:', err);
        this.stop();
        return;
      }

      this._frameId = requestAnimationFrame(execute);
    };

    this._frameId = requestAnimationFrame(execute);
  }

  pause() {
    this.running = false;
    if (this._frameId) {
      cancelAnimationFrame(this._frameId);
      this._frameId = null;
    }
  }

  stop() {
    this.pause();
    // Cleanup GPIO listeners
    for (const unsub of this._gpioUnsubs) unsub();
    this._gpioUnsubs = [];
  }

  reset() {
    if (!this.mcu || !this._flashImage) return;
    const wasRunning = this.running;
    this.pause();
    // rp2040js reset() wipes flash — reload from stored copy
    this.mcu.reset();
    this.mcu.loadBootrom(bootromB1);
    this.mcu.flash.set(this._flashImage, 0);
    // Re-setup GPIO listeners (cleared by reset)
    for (const unsub of this._gpioUnsubs) unsub();
    this._gpioUnsubs = [];
    this._setupGPIO();
    if (wasRunning) this.start();
  }

  // ── Internal ──

  _setupGPIO() {
    for (let i = 0; i < GPIO_COUNT; i++) {
      const gpio = this.mcu.gpio[i];
      if (!gpio) continue;
      const pin = i;

      const unsub = gpio.addListener((state) => {
        const high = (state === GPIOPinState.High);
        for (const fn of this._pinChangeListeners) fn(pin, high);
      });
      this._gpioUnsubs.push(unsub);
    }
  }

  _stepPIO() {
    if (!this.mcu) return;
    const pio = this.mcu.pio;
    if (pio[0] && !pio[0].stopped) pio[0].step();
    if (pio[1] && !pio[1].stopped) pio[1].step();
  }
}
