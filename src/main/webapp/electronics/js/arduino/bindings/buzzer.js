/**
 * Buzzer Binding — connects <wokwi-buzzer> to AVRRunner via Web Audio API.
 *
 * Arduino tone() uses Timer2 in CTC or Fast PWM mode to toggle a pin.
 * f = F_CPU / (2 × prescaler × (OCR2A + 1))
 */

const CPU_HZ = 16_000_000;
const OCR2A  = 0xB3;
const TCCR2A = 0xB0;
const TCCR2B = 0xB1;
const PRESCALER_TABLE = { 1: 1, 2: 8, 3: 32, 4: 64, 5: 128, 6: 256, 7: 1024 };

export class BuzzerBinding {
  constructor(element, runner, pin) {
    this.element = element;
    this.runner = runner;
    this.pin = pin;
    this._audioCtx = null;
    this._oscillator = null;
    this._gainNode = null;
    this._rafId = null;
    this._lastFreq = 0;
    this._pinHigh = false;
    this._cleanups = [];
  }

  attach() {
    // Track pin state
    const unsub = this.runner.addPinChangeListener((pin, high) => {
      if (pin === this.pin) this._pinHigh = high;
    });
    this._cleanups.push(unsub);

    const poll = () => {
      this._rafId = requestAnimationFrame(poll);
      const cpu = this.runner.cpu;
      if (!cpu) return;

      // Check pin is being toggled by timer (COM2x bits set)
      const tccr2a = cpu.data[TCCR2A] || 0;
      const tccr2b = cpu.data[TCCR2B] || 0;

      // Check COM2A0 or COM2B0 toggle mode is active
      const com2a = (tccr2a >> 6) & 0x03;
      const com2b = (tccr2a >> 4) & 0x03;
      const toggleActive = (com2a === 1) || (com2b === 1); // toggle on compare match

      if (!toggleActive) {
        this._stopSound();
        return;
      }

      const csField = tccr2b & 0x07;
      const prescaler = PRESCALER_TABLE[csField];
      const ocr2a = cpu.data[OCR2A] || 0;

      // Accept CTC (WGM=2) or Fast PWM (WGM=3) — tone() may use either
      const wgm = (tccr2a & 0x03) | ((tccr2b & 0x08) >> 1);
      const validMode = (wgm === 2 || wgm === 3);

      if (!prescaler || ocr2a === 0 || !validMode) {
        this._stopSound();
        return;
      }

      const freq = CPU_HZ / (2 * prescaler * (ocr2a + 1));

      if (freq < 20 || freq > 20000) {
        this._stopSound();
        return;
      }

      if (Math.abs(freq - this._lastFreq) > 1) {
        this._startSound(freq);
        this._lastFreq = freq;
      }
    };

    this._rafId = requestAnimationFrame(poll);
  }

  detach() {
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
    this._stopSound();
    if (this._rafId !== null) {
      cancelAnimationFrame(this._rafId);
      this._rafId = null;
    }
    if (this._audioCtx) {
      this._audioCtx.close();
      this._audioCtx = null;
    }
  }

  _startSound(freq) {
    if (!this._audioCtx) {
      this._audioCtx = new (window.AudioContext || window.webkitAudioContext)();
      this._gainNode = this._audioCtx.createGain();
      this._gainNode.gain.value = 0.05;
      this._gainNode.connect(this._audioCtx.destination);
    }
    if (this._oscillator) {
      this._oscillator.frequency.value = freq;
    } else {
      this._oscillator = this._audioCtx.createOscillator();
      this._oscillator.type = 'square';
      this._oscillator.frequency.value = freq;
      this._oscillator.connect(this._gainNode);
      this._oscillator.start();
    }
    this.element.hasSignal = true;
  }

  _stopSound() {
    if (this._oscillator) {
      this._oscillator.stop();
      this._oscillator.disconnect();
      this._oscillator = null;
    }
    this._lastFreq = 0;
    if (this.element) this.element.hasSignal = false;
  }
}
