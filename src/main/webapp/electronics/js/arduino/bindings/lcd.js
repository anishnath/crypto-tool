/**
 * LCD 16×2 Binding (4-bit GPIO mode) — connects <wokwi-lcd1602> to AVRRunner.
 *
 * HD44780 controller protocol in 4-bit mode:
 *  - RS pin: LOW = command, HIGH = data
 *  - EN pin: falling edge latches data
 *  - D4–D7: 4-bit data bus (high nibble first, then low nibble)
 *
 * Standard Arduino LiquidCrystal wiring:
 *   LiquidCrystal lcd(RS, EN, D4, D5, D6, D7);
 *   e.g. LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
 */

export class LcdBinding {
  /**
   * @param {HTMLElement} element - <wokwi-lcd1602> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {object} pins - { rs, en, d4, d5, d6, d7 } Arduino pin numbers
   */
  constructor(element, runner, pins) {
    this.element = element;
    this.runner = runner;
    this.pins = pins; // { rs: 12, en: 11, d4: 5, d5: 4, d6: 3, d7: 2 }
    this._prevOnPin = null;

    // HD44780 state
    this._ddram = new Uint8Array(128).fill(0x20); // display data RAM (space-filled)
    this._ddramAddr = 0;
    this._displayOn = false;
    this._cursorOn = false;
    this._blinkOn = false;
    this._entryIncrement = true;
    this._initialized = false;
    this._initCount = 0;
    this._nibbleState = 'high'; // 'high' or 'low'
    this._highNibble = 0;

    // Pin states
    this._rs = false;
    this._en = false;
    this._d4 = false;
    this._d5 = false;
    this._d6 = false;
    this._d7 = false;
  }

  attach() {
    const pinToHandler = {};
    pinToHandler[this.pins.rs] = (h) => { this._rs = h; };
    pinToHandler[this.pins.d4] = (h) => { this._d4 = h; };
    pinToHandler[this.pins.d5] = (h) => { this._d5 = h; };
    pinToHandler[this.pins.d6] = (h) => { this._d6 = h; };
    pinToHandler[this.pins.d7] = (h) => { this._d7 = h; };
    pinToHandler[this.pins.en] = (h) => {
      const wasHigh = this._en;
      this._en = h;
      if (wasHigh && !h) this._onEnableFallingEdge(); // latch on falling edge
    };

    const prevOnPin = this.runner.onPinChange;
    this._prevOnPin = prevOnPin;

    this.runner.onPinChange = (pin, high) => {
      if (prevOnPin) prevOnPin(pin, high);
      const handler = pinToHandler[pin];
      if (handler) handler(high);
    };
  }

  detach() {
    this.runner.onPinChange = this._prevOnPin;
    this.element.characters = new Uint8Array(32).fill(0x20);
  }

  _onEnableFallingEdge() {
    const nibble =
      (this._d4 ? 0x01 : 0) |
      (this._d5 ? 0x02 : 0) |
      (this._d6 ? 0x04 : 0) |
      (this._d7 ? 0x08 : 0);

    if (!this._initialized) {
      this._initCount++;
      // Init complete when RS=LOW and nibble=0x02 (switch to 4-bit mode),
      // or after 4 EN pulses as fallback
      if ((this._initCount >= 3 && !this._rs && nibble === 0x02) || this._initCount >= 4) {
        this._initialized = true;
        this._nibbleState = 'high';
      }
      return;
    }

    if (this._nibbleState === 'high') {
      this._highNibble = nibble << 4;
      this._nibbleState = 'low';
    } else {
      this._processByte(this._rs, this._highNibble | nibble);
      this._nibbleState = 'high';
    }
  }

  _processByte(rs, data) {
    if (!rs) {
      // Command
      if (data & 0x80) {
        this._ddramAddr = data & 0x7F;
      } else if (data & 0x40) {
        // CGRAM address — not implemented
      } else if (data & 0x20) {
        this._initialized = true; // function set
      } else if (data & 0x10) {
        // cursor/display shift
        const rl = (data >> 2) & 1;
        this._ddramAddr = (this._ddramAddr + (rl ? 1 : -1)) & 0x7F;
      } else if (data & 0x08) {
        this._displayOn = !!(data & 0x04);
        this._cursorOn  = !!(data & 0x02);
        this._blinkOn   = !!(data & 0x01);
      } else if (data & 0x04) {
        this._entryIncrement = !!(data & 0x02);
      } else if (data & 0x02) {
        this._ddramAddr = 0; // return home
      } else if (data & 0x01) {
        this._ddram.fill(0x20); // clear display
        this._ddramAddr = 0;
      }
    } else {
      // Data — write character to DDRAM
      this._ddram[this._ddramAddr & 0x7F] = data;
      this._ddramAddr = this._entryIncrement
        ? (this._ddramAddr + 1) & 0x7F
        : (this._ddramAddr - 1) & 0x7F;
    }
    this._refreshDisplay();
  }

  _refreshDisplay() {
    const cols = 16, rows = 2;
    const lineOffsets = [0x00, 0x40];

    if (!this._displayOn) {
      this.element.characters = new Uint8Array(cols * rows).fill(0x20);
      return;
    }

    const chars = new Uint8Array(cols * rows);
    for (let row = 0; row < rows; row++) {
      const offset = lineOffsets[row];
      for (let col = 0; col < cols; col++) {
        chars[row * cols + col] = this._ddram[offset + col];
      }
    }
    this.element.characters = chars;
    this.element.cursor = this._cursorOn;
    this.element.blink = this._blinkOn;
  }
}
