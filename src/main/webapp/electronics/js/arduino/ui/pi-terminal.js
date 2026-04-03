/**
 * PiTerminal — xterm.js wrapper for Raspberry Pi Linux console.
 *
 * Replaces the serial monitor when a Pi board is active.
 * - SSE serial_output events → xterm.write()
 * - Keyboard input → POST /api/arduino/simulate/pi/input
 *
 * Usage:
 *   const term = new PiTerminal(containerEl);
 *   term.open();
 *   term.write('Linux 6.6.51 raspberrypi ttyAMA0\n\nraspberrypi login: ');
 *   term.onInput = (data) => sendToQemu(data);
 *   term.close();
 */

export class PiTerminal {
  /**
   * @param {HTMLElement} container - element to mount xterm.js into
   */
  constructor(container) {
    this.container = container;
    this.term = null;
    this._onInput = null;
    this._opened = false;
  }

  /** Set callback for user keyboard input */
  set onInput(fn) { this._onInput = fn; }

  /** Open the terminal */
  open() {
    if (this._opened) return;
    if (typeof Terminal === 'undefined') {
      console.warn('[PiTerminal] xterm.js not loaded');
      this.container.innerHTML = '<div style="padding:16px;color:#ef4444;font:13px monospace;">'
        + 'Terminal failed to load (xterm.js unavailable).<br>Try refreshing the page.</div>';
      return;
    }

    this.container.innerHTML = '';

    this.term = new Terminal({
      theme: {
        background: '#111318',
        foreground: '#e2e8f0',
        cursor: '#06b6d4',
        cursorAccent: '#111318',
        selectionBackground: '#334155',
        black: '#1e293b',
        red: '#ef4444',
        green: '#22c55e',
        yellow: '#eab308',
        blue: '#3b82f6',
        magenta: '#a855f7',
        cyan: '#06b6d4',
        white: '#e2e8f0',
        brightBlack: '#475569',
        brightRed: '#f87171',
        brightGreen: '#4ade80',
        brightYellow: '#facc15',
        brightBlue: '#60a5fa',
        brightMagenta: '#c084fc',
        brightCyan: '#22d3ee',
        brightWhite: '#f8fafc',
      },
      fontFamily: '"Fira Code", "Cascadia Code", Menlo, monospace',
      fontSize: 13,
      lineHeight: 1.2,
      cursorBlink: true,
      cursorStyle: 'block',
      scrollback: 5000,
      convertEol: true,
    });

    this.term.open(this.container);
    this.term.focus();
    this._opened = true;

    // Welcome message
    this.term.writeln('\x1b[36m── Raspberry Pi 3B Terminal ──\x1b[0m');
    this.term.writeln('\x1b[90mWaiting for Pi to boot...\x1b[0m');
    this.term.writeln('');

    // Wire keyboard input
    this.term.onData((data) => {
      if (this._onInput) this._onInput(data);
    });
  }

  /** Write data to the terminal (from SSE serial_output) */
  write(data) {
    if (this.term) this.term.write(data);
  }

  /** Clear the terminal */
  clear() {
    if (this.term) {
      this.term.clear();
      this.term.reset();
    }
  }

  /** Close and dispose the terminal */
  close() {
    if (this.term) {
      this.term.dispose();
      this.term = null;
    }
    this.container.innerHTML = '';
    this._opened = false;
  }

  /** Focus the terminal */
  focus() {
    if (this.term) this.term.focus();
  }

  /** Resize to fit container */
  fit() {
    // Basic fit — xterm.js FitAddon is separate, so we do manual calc
    if (!this.term || !this.container) return;
    const dims = this.container.getBoundingClientRect();
    if (dims.width === 0 || dims.height === 0) return;
    const cols = Math.floor(dims.width / 7.8); // approximate char width
    const rows = Math.floor(dims.height / 17);  // approximate line height
    if (cols > 0 && rows > 0) {
      this.term.resize(cols, rows);
    }
  }
}
