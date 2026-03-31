/**
 * PicoBoard — custom SVG board visual for Raspberry Pi Pico.
 *
 * Registers as <pico-board> custom element with:
 *   - led25: boolean (LED_BUILTIN on GPIO25)
 *   - ledPower: boolean
 *   - pinInfo: array (pin coordinates for wire connections)
 */

const BOARD_WIDTH = 260;
const BOARD_HEIGHT = 55;
const PIN_SPACING = 10;
const PIN_COUNT_PER_SIDE = 20;

class PicoBoardElement extends HTMLElement {
  constructor() {
    super();
    this._led25 = false;
    this._ledPower = false;
    this.attachShadow({ mode: 'open' });
    this._render();
  }

  get led25() { return this._led25; }
  set led25(v) { this._led25 = v; this._updateLED(); }

  get ledPower() { return this._ledPower; }
  set ledPower(v) { this._ledPower = v; this._updatePower(); }

  get pinInfo() {
    const pins = [];
    // Top row: GP0–GP19 (left to right, pins spaced 10px apart)
    const topLabels = ['GP0','GP1','GND','GP2','GP3','GP4','GP5','GND','GP6','GP7',
                       'GP8','GP9','GND','GP10','GP11','GP12','GP13','GND','GP14','GP15'];
    for (let i = 0; i < PIN_COUNT_PER_SIDE; i++) {
      pins.push({ name: topLabels[i] || `TP${i}`, x: 20 + i * PIN_SPACING, y: 8, signals: [] });
    }
    // Bottom row: GP16–GP28, 3V3, VSYS, VBUS, etc. (left to right)
    const botLabels = ['GP16','GP17','GND','GP18','GP19','GP20','GP21','GND','GP22','RUN',
                       'GP26','GP27','GND','GP28','ADC_VREF','3V3','3V3_EN','GND','VSYS','VBUS'];
    for (let i = 0; i < PIN_COUNT_PER_SIDE; i++) {
      pins.push({ name: botLabels[i] || `BP${i}`, x: 20 + i * PIN_SPACING, y: BOARD_HEIGHT - 8, signals: [] });
    }
    // Debug header (3 pins on the right edge)
    pins.push({ name: 'SWCLK', x: BOARD_WIDTH, y: 15, signals: [] });
    pins.push({ name: 'GND', x: BOARD_WIDTH, y: 25, signals: [{ type: 'power', signal: 'GND' }] });
    pins.push({ name: 'SWDIO', x: BOARD_WIDTH, y: 35, signals: [] });
    return pins;
  }

  _render() {
    this.shadowRoot.innerHTML = `
      <style>
        :host { display: inline-block; }
        .board { font-family: 'DM Sans', sans-serif; }
        .pin-hole { fill: #1a1a2e; stroke: #ffd700; stroke-width: 0.5; }
        .led-circle { transition: fill 0.15s; }
      </style>
      <svg class="board" width="${BOARD_WIDTH}" height="${BOARD_HEIGHT}" viewBox="0 0 ${BOARD_WIDTH} ${BOARD_HEIGHT}">
        <!-- PCB body -->
        <rect x="0" y="5" width="${BOARD_WIDTH}" height="${BOARD_HEIGHT - 10}" rx="4"
              fill="#1a5c2a" stroke="#0d3b18" stroke-width="1"/>

        <!-- USB-C connector -->
        <rect x="-2" y="${BOARD_HEIGHT/2 - 6}" width="14" height="12" rx="2" fill="#888" stroke="#666"/>
        <rect x="0" y="${BOARD_HEIGHT/2 - 4}" width="10" height="8" rx="1.5" fill="#444"/>

        <!-- Chip -->
        <rect x="${BOARD_WIDTH/2 - 18}" y="${BOARD_HEIGHT/2 - 10}" width="36" height="20" rx="2" fill="#222" stroke="#444"/>
        <text x="${BOARD_WIDTH/2}" y="${BOARD_HEIGHT/2 + 1}" text-anchor="middle" fill="#aaa" font-size="5">RP2040</text>

        <!-- Label -->
        <text x="${BOARD_WIDTH - 50}" y="18" fill="#8fc" font-size="6" font-weight="bold">Raspberry Pi</text>
        <text x="${BOARD_WIDTH - 50}" y="26" fill="#8fc" font-size="8" font-weight="bold">Pico</text>

        <!-- Top row pin holes -->
        ${Array.from({length: PIN_COUNT_PER_SIDE}, (_, i) =>
          `<circle class="pin-hole" cx="${20 + i * PIN_SPACING}" cy="8" r="2.5"/>`
        ).join('')}

        <!-- Bottom row pin holes -->
        ${Array.from({length: PIN_COUNT_PER_SIDE}, (_, i) =>
          `<circle class="pin-hole" cx="${20 + i * PIN_SPACING}" cy="${BOARD_HEIGHT - 8}" r="2.5"/>`
        ).join('')}

        <!-- LED (GPIO25) -->
        <circle class="led-circle" id="led25" cx="${BOARD_WIDTH - 20}" cy="${BOARD_HEIGHT/2}" r="3"
                fill="${this._led25 ? '#22ff22' : '#1a3a1a'}" stroke="#333"/>
        <text x="${BOARD_WIDTH - 20}" y="${BOARD_HEIGHT/2 + 9}" text-anchor="middle" fill="#8fc" font-size="3.5">LED</text>

        <!-- Power LED -->
        <circle class="led-circle" id="ledPower" cx="20" cy="${BOARD_HEIGHT/2}" r="2"
                fill="${this._ledPower ? '#ff4444' : '#3a1a1a'}" stroke="#333"/>

        <!-- BOOTSEL button -->
        <rect x="${BOARD_WIDTH/2 - 5}" y="${BOARD_HEIGHT - 18}" width="10" height="6" rx="1" fill="#ddd" stroke="#999"/>
        <text x="${BOARD_WIDTH/2}" y="${BOARD_HEIGHT - 7}" text-anchor="middle" fill="#8fc" font-size="3">BOOTSEL</text>
      </svg>
    `;
  }

  _updateLED() {
    const el = this.shadowRoot?.getElementById('led25');
    if (el) el.setAttribute('fill', this._led25 ? '#22ff22' : '#1a3a1a');
  }

  _updatePower() {
    const el = this.shadowRoot?.getElementById('ledPower');
    if (el) el.setAttribute('fill', this._ledPower ? '#ff4444' : '#3a1a1a');
  }
}

// Register custom element
if (!customElements.get('pico-board')) {
  customElements.define('pico-board', PicoBoardElement);
}

export { PicoBoardElement };
