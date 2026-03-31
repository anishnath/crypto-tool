/**
 * LCD I2C Binding — connects <wokwi-lcd1602> via I2C (PCF8574 backpack).
 *
 * The PCF8574 I2C expander maps 8 bits to LCD pins:
 *   bit 0 = RS
 *   bit 1 = RW (always LOW for write)
 *   bit 2 = EN
 *   bit 3 = Backlight
 *   bit 4 = D4
 *   bit 5 = D5
 *   bit 6 = D6
 *   bit 7 = D7
 *
 * I2C address is typically 0x27 or 0x3F.
 *
 * This binding intercepts TWI writes to decode HD44780 commands.
 * Requires runner.twi (AVRTWI peripheral) — available but not yet
 * wired in runner.js for V1. This is a placeholder for I2C integration.
 */

export class LcdI2cBinding {
  /**
   * @param {HTMLElement} element - <wokwi-lcd1602> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} [address=0x27] - I2C address of the PCF8574
   */
  constructor(element, runner, address = 0x27) {
    this.element = element;
    this.runner = runner;
    this.address = address;

    // HD44780 state (same as lcd.js)
    this._ddram = new Uint8Array(128).fill(0x20);
    this._ddramAddr = 0;
    this._displayOn = false;
    this._cursorOn = false;
    this._blinkOn = false;
    this._entryIncrement = true;
    this._initialized = false;
    this._initCount = 0;
    this._nibbleState = 'high';
    this._highNibble = 0;
    this._lastEN = false;

    this._cleanup = null;
  }

  attach() {
    // TWI event handler — intercepts I2C writes to our address
    const twi = this.runner.twi;
    if (!twi) {
      console.warn('[LCD-I2C] TWI not available on runner — I2C LCD requires TWI peripheral');
      return;
    }

    const prevHandler = twi.eventHandler;
    let addressed = false;

    twi.eventHandler = {
      start: () => { addressed = false; return prevHandler?.start?.() ?? true; },
      stop: () => { addressed = false; return prevHandler?.stop?.(); },
      connectToSlave: (addr, write) => {
        if ((addr >> 1) === this.address) { addressed = true; return true; }
        return prevHandler?.connectToSlave?.(addr, write) ?? false;
      },
      writeByte: (value) => {
        if (addressed) this._processI2CByte(value);
        return prevHandler?.writeByte?.(value) ?? true;
      },
      readByte: () => prevHandler?.readByte?.() ?? 0xFF,
    };

    this._cleanup = () => {
      twi.eventHandler = prevHandler;
    };
  }

  detach() {
    if (this._cleanup) this._cleanup();
    this._cleanup = null;
    this.element.characters = new Uint8Array(32).fill(0x20);
  }

  _processI2CByte(value) {
    // Decode PCF8574 bit mapping
    const rs = !!(value & 0x01);
    const en = !!(value & 0x04);
    const d4 = !!(value & 0x10);
    const d5 = !!(value & 0x20);
    const d6 = !!(value & 0x40);
    const d7 = !!(value & 0x80);

    // Detect EN falling edge
    if (this._lastEN && !en) {
      const nibble = (d4 ? 1 : 0) | (d5 ? 2 : 0) | (d6 ? 4 : 0) | (d7 ? 8 : 0);

      if (!this._initialized) {
        this._initCount++;
        if (this._initCount >= 4) {
          this._initialized = true;
          this._nibbleState = 'high';
        }
      } else if (this._nibbleState === 'high') {
        this._highNibble = nibble << 4;
        this._nibbleState = 'low';
      } else {
        this._processByte(rs, this._highNibble | nibble);
        this._nibbleState = 'high';
      }
    }
    this._lastEN = en;
  }

  _processByte(rs, data) {
    if (!rs) {
      if (data & 0x80) { this._ddramAddr = data & 0x7F; }
      else if (data & 0x20) { this._initialized = true; }
      else if (data & 0x08) {
        this._displayOn = !!(data & 0x04);
        this._cursorOn  = !!(data & 0x02);
        this._blinkOn   = !!(data & 0x01);
      }
      else if (data & 0x04) { this._entryIncrement = !!(data & 0x02); }
      else if (data & 0x02) { this._ddramAddr = 0; }
      else if (data & 0x01) { this._ddram.fill(0x20); this._ddramAddr = 0; }
    } else {
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
      for (let col = 0; col < cols; col++) {
        chars[row * cols + col] = this._ddram[lineOffsets[row] + col];
      }
    }
    this.element.characters = chars;
    this.element.cursor = this._cursorOn;
    this.element.blink = this._blinkOn;
  }
}
