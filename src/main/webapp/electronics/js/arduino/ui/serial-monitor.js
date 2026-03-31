/**
 * SerialMonitor — connects AVRRunner USART to a terminal panel.
 *
 * Handles:
 *  - TX output: USART byte → append to terminal
 *  - RX input: user types → feed bytes into USART receive buffer
 *  - Auto-scroll, line trimming, clear
 *  - Baud rate display (read from USART config on start)
 */

const MAX_CHARS = 50000;
const TRIM_TO   = 25000;

export class SerialMonitor {
  /**
   * @param {HTMLElement} outputEl - element for terminal text output
   * @param {HTMLInputElement} inputEl - text input for sending data (optional)
   * @param {HTMLElement} sendBtn - send button (optional)
   * @param {HTMLElement} clearBtn - clear button (optional)
   * @param {HTMLElement} baudEl - element to display baud rate (optional)
   */
  constructor(outputEl, { inputEl = null, sendBtn = null, clearBtn = null, baudEl = null } = {}) {
    this.outputEl = outputEl;
    this.inputEl = inputEl;
    this.sendBtn = sendBtn;
    this.clearBtn = clearBtn;
    this.baudEl = baudEl;

    this._runner = null;
    this._cleanups = [];
  }

  /**
   * Attach to a runner's USART
   * @param {import('../runner.js').AVRRunner} runner
   */
  attach(runner) {
    this._runner = runner;

    // TX: USART byte → terminal
    runner.onSerial = (char) => this._appendChar(char);

    // Baud rate display
    if (this.baudEl && runner.usart) {
      const updateBaud = () => {
        const baud = runner.usart.baudRate;
        if (baud > 0) this.baudEl.textContent = baud + ' baud';
      };
      runner.usart.onConfigurationChange = updateBaud;
      this._cleanups.push(() => { runner.usart.onConfigurationChange = null; });
    }

    // RX: user input → USART
    if (this.inputEl && this.sendBtn) {
      const onSend = () => {
        const text = this.inputEl.value;
        if (!text || !runner.usart) return;
        for (let i = 0; i < text.length; i++) {
          runner.usart.writeByte(text.charCodeAt(i));
        }
        runner.usart.writeByte(10); // newline
        this.inputEl.value = '';
      };

      this.sendBtn.addEventListener('click', onSend);
      const onKey = (e) => { if (e.key === 'Enter') onSend(); };
      this.inputEl.addEventListener('keydown', onKey);

      this._cleanups.push(() => {
        this.sendBtn.removeEventListener('click', onSend);
        this.inputEl.removeEventListener('keydown', onKey);
      });
    }

    // Clear button
    if (this.clearBtn) {
      const onClear = () => this.clear();
      this.clearBtn.addEventListener('click', onClear);
      this._cleanups.push(() => this.clearBtn.removeEventListener('click', onClear));
    }
  }

  /** Detach from runner */
  detach() {
    if (this._runner) this._runner.onSerial = null;
    this._runner = null;
    for (const fn of this._cleanups) fn();
    this._cleanups = [];
  }

  /** Clear terminal output */
  clear() {
    this.outputEl.textContent = '';
  }

  // ── Internal ──

  _appendChar(char) {
    this.outputEl.textContent += char;

    // Trim if too long
    if (this.outputEl.textContent.length > MAX_CHARS) {
      this.outputEl.textContent = this.outputEl.textContent.slice(-TRIM_TO);
    }

    // Auto-scroll
    this.outputEl.scrollTop = this.outputEl.scrollHeight;
  }
}
