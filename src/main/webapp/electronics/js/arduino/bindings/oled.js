/**
 * OLED SSD1306 Binding — connects <wokwi-ssd1306> via I2C.
 *
 * SSD1306 is a 128×64 OLED driven over I2C (address 0x3C or 0x3D).
 * The Adafruit SSD1306 library sends:
 *   - Control byte 0x00 = command stream follows
 *   - Control byte 0x40 = data stream follows (pixel data)
 *
 * Pixel data is organized in 8 pages × 128 columns.
 * Each byte is a vertical strip of 8 pixels (LSB = top).
 *
 * This is a placeholder that captures GDDRAM writes and pushes
 * the pixel buffer to the wokwi-ssd1306 element.
 */

const WIDTH = 128;
const HEIGHT = 64;
const PAGES = HEIGHT / 8;

export class OledBinding {
  /**
   * @param {HTMLElement} element - <wokwi-ssd1306> element
   * @param {import('../runner.js').AVRRunner} runner
   * @param {number} [address=0x3C] - I2C address
   */
  constructor(element, runner, address = 0x3C) {
    this.element = element;
    this.runner = runner;
    this.address = address;

    this._gddram = new Uint8Array(PAGES * WIDTH); // 1024 bytes
    this._pageAddr = 0;
    this._colAddr = 0;
    this._colStart = 0;
    this._colEnd = WIDTH - 1;
    this._pageStart = 0;
    this._pageEnd = PAGES - 1;
    this._isData = false;
    this._cmdBuf = [];    // buffer for multi-byte commands
    this._cmdExpect = 0;  // bytes remaining for current command
    this._cleanup = null;
  }

  attach() {
    const twi = this.runner.twi;
    if (!twi) {
      console.warn('[OLED] TWI not available — SSD1306 requires I2C');
      return;
    }

    const prevHandler = twi.eventHandler;
    let addressed = false;

    twi.eventHandler = {
      start: () => { addressed = false; return prevHandler?.start?.() ?? true; },
      stop: () => {
        if (addressed) this._flush();
        addressed = false;
        return prevHandler?.stop?.();
      },
      connectToSlave: (addr, write) => {
        if ((addr >> 1) === this.address) {
          addressed = true;
          this._isData = false;
          return true;
        }
        return prevHandler?.connectToSlave?.(addr, write) ?? false;
      },
      writeByte: (value) => {
        if (addressed) {
          this._onByte(value);
          return true;
        }
        return prevHandler?.writeByte?.(value) ?? true;
      },
      readByte: () => prevHandler?.readByte?.() ?? 0xFF,
    };

    this._cleanup = () => { twi.eventHandler = prevHandler; };
  }

  detach() {
    if (this._cleanup) this._cleanup();
    this._cleanup = null;
  }

  _onByte(value) {
    if (!this._isData) {
      // Control byte: 0x00 = commands follow, 0x40 = data follows
      if (value === 0x40) {
        this._isData = true;
        return;
      } else if (value === 0x00) {
        this._isData = false;
        return;
      }
      // Command byte
      this._processCommand(value);
      return;
    }

    // Data byte — write to GDDRAM
    const idx = this._pageAddr * WIDTH + this._colAddr;
    if (idx < this._gddram.length) {
      this._gddram[idx] = value;
    }
    this._colAddr++;
    if (this._colAddr > this._colEnd) {
      this._colAddr = this._colStart;
      this._pageAddr++;
      if (this._pageAddr > this._pageEnd) {
        this._pageAddr = this._pageStart;
      }
    }
  }

  _processCommand(cmd) {
    // Multi-byte command continuation
    if (this._cmdExpect > 0) {
      this._cmdBuf.push(cmd);
      this._cmdExpect--;
      if (this._cmdExpect === 0) {
        this._executeMultiByteCmd();
      }
      return;
    }

    // Set page start address (0xB0–0xB7)
    if (cmd >= 0xB0 && cmd <= 0xB7) {
      this._pageAddr = cmd - 0xB0;
      return;
    }
    // Set lower column address (0x00–0x0F)
    if (cmd <= 0x0F) {
      this._colAddr = (this._colAddr & 0xF0) | cmd;
      return;
    }
    // Set higher column address (0x10–0x1F)
    if (cmd >= 0x10 && cmd <= 0x1F) {
      this._colAddr = (this._colAddr & 0x0F) | ((cmd & 0x0F) << 4);
      return;
    }
    // Set column address range (0x21 + startCol + endCol)
    if (cmd === 0x21) {
      this._cmdBuf = [cmd];
      this._cmdExpect = 2;
      return;
    }
    // Set page address range (0x22 + startPage + endPage)
    if (cmd === 0x22) {
      this._cmdBuf = [cmd];
      this._cmdExpect = 2;
      return;
    }
    // All other commands silently accepted
  }

  _executeMultiByteCmd() {
    const cmd = this._cmdBuf[0];
    if (cmd === 0x21 && this._cmdBuf.length === 3) {
      this._colStart = this._cmdBuf[1] & 0x7F;
      this._colEnd = this._cmdBuf[2] & 0x7F;
      this._colAddr = this._colStart;
    } else if (cmd === 0x22 && this._cmdBuf.length === 3) {
      this._pageStart = this._cmdBuf[1] & 0x07;
      this._pageEnd = this._cmdBuf[2] & 0x07;
      this._pageAddr = this._pageStart;
    }
    this._cmdBuf = [];
  }

  _flush() {
    // Convert page-based GDDRAM to ImageData for wokwi-ssd1306
    // The element accepts .imageData as a Uint8ClampedArray (RGBA)
    const imageData = new Uint8ClampedArray(WIDTH * HEIGHT * 4);

    for (let page = 0; page < PAGES; page++) {
      for (let col = 0; col < WIDTH; col++) {
        const byte = this._gddram[page * WIDTH + col];
        for (let bit = 0; bit < 8; bit++) {
          const y = page * 8 + bit;
          const x = col;
          const pixel = (byte >> bit) & 1;
          const idx = (y * WIDTH + x) * 4;
          const val = pixel ? 255 : 0;
          imageData[idx]     = val; // R
          imageData[idx + 1] = val; // G
          imageData[idx + 2] = val; // B
          imageData[idx + 3] = 255; // A
        }
      }
    }

    this.element.imageData = imageData;
  }
}
