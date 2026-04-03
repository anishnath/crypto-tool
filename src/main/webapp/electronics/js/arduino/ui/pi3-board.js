/**
 * Pi3Board — custom SVG board visual for Raspberry Pi 3B.
 *
 * Registers as <pi3-board> custom element with:
 *   - ledPower: boolean (PWR LED)
 *   - ledAct: boolean (ACT LED — SD card activity)
 *   - pinInfo: array (40-pin GPIO header coordinates)
 */

const PI_WIDTH = 170;
const PI_HEIGHT = 220;
const HEADER_X = 22;
const HEADER_Y = 25;
const PIN_SPACING = 7;
const PINS_PER_COL = 20;

// 40-pin GPIO header (BCM numbering on left, physical on right)
const PIN_LABELS_LEFT = [
  '3V3','GPIO2','GPIO3','GPIO4','GND','GPIO17','GPIO27','GPIO22',
  '3V3','GPIO10','GPIO9','GPIO25','GPIO11','GPIO8','GND','GPIO7',
  'DNC','GPIO5','GPIO6','GPIO13'
];
const PIN_LABELS_RIGHT = [
  '5V','5V','GND','GPIO14','GPIO15','GPIO18','GND','GPIO23',
  'GPIO24','GND','GPIO25','GPIO8','GPIO7','DNC','GND','GPIO12',
  'GND','GPIO16','GPIO20','GPIO21'
];

class Pi3BoardElement extends HTMLElement {
  constructor() {
    super();
    this._ledPower = false;
    this._ledAct = false;
    this.attachShadow({ mode: 'open' });
    this._render();
  }

  get ledPower() { return this._ledPower; }
  set ledPower(v) { this._ledPower = v; this._updateLEDs(); }
  get ledAct() { return this._ledAct; }
  set ledAct(v) { this._ledAct = v; this._updateLEDs(); }
  // Compat aliases
  get led1() { return this._ledAct; }
  set led1(v) { this.ledAct = v; }

  get pinInfo() {
    const pins = [];
    for (let i = 0; i < PINS_PER_COL; i++) {
      pins.push({ name: PIN_LABELS_LEFT[i], x: HEADER_X, y: HEADER_Y + i * PIN_SPACING, signals: [] });
      pins.push({ name: PIN_LABELS_RIGHT[i], x: HEADER_X + 14, y: HEADER_Y + i * PIN_SPACING, signals: [] });
    }
    return pins;
  }

  _render() {
    const gpioHoles = Array.from({ length: PINS_PER_COL }, (_, i) => `
      <circle cx="${HEADER_X}" cy="${HEADER_Y + i * PIN_SPACING}" r="1.8" fill="#1a1a2e" stroke="#d4a843" stroke-width="0.4"/>
      <circle cx="${HEADER_X + 14}" cy="${HEADER_Y + i * PIN_SPACING}" r="1.8" fill="#1a1a2e" stroke="#d4a843" stroke-width="0.4"/>
    `).join('');

    this.shadowRoot.innerHTML = `
      <style>
        :host { display: inline-block; }
        .board { font-family: 'DM Sans', sans-serif; }
        .led-circle { transition: fill 0.15s; }
      </style>
      <svg class="board" width="${PI_WIDTH}" height="${PI_HEIGHT}" viewBox="0 0 ${PI_WIDTH} ${PI_HEIGHT}">
        <!-- PCB (green, rounded corners, mounting holes) -->
        <rect x="2" y="2" width="${PI_WIDTH - 4}" height="${PI_HEIGHT - 4}" rx="4" fill="#1a6b3a" stroke="#0d4a22" stroke-width="1"/>

        <!-- Mounting holes -->
        <circle cx="8" cy="8" r="3" fill="none" stroke="#ccc" stroke-width="0.5"/>
        <circle cx="${PI_WIDTH - 8}" cy="8" r="3" fill="none" stroke="#ccc" stroke-width="0.5"/>
        <circle cx="8" cy="${PI_HEIGHT - 8}" r="3" fill="none" stroke="#ccc" stroke-width="0.5"/>
        <circle cx="${PI_WIDTH - 8}" cy="${PI_HEIGHT - 8}" r="3" fill="none" stroke="#ccc" stroke-width="0.5"/>

        <!-- SoC (Broadcom BCM2837) -->
        <rect x="${PI_WIDTH / 2 - 12}" y="85" width="24" height="24" rx="2" fill="#333" stroke="#555"/>
        <text x="${PI_WIDTH / 2}" y="98" text-anchor="middle" fill="#888" font-size="3.5">BCM2837</text>

        <!-- RAM chip -->
        <rect x="${PI_WIDTH / 2 - 8}" y="65" width="16" height="10" rx="1" fill="#222" stroke="#444"/>
        <text x="${PI_WIDTH / 2}" y="72" text-anchor="middle" fill="#777" font-size="2.5">1GB RAM</text>

        <!-- 40-pin GPIO header -->
        <rect x="${HEADER_X - 4}" y="${HEADER_Y - 4}" width="22" height="${PINS_PER_COL * PIN_SPACING + 2}" rx="1" fill="#222" stroke="#444"/>
        ${gpioHoles}
        <text x="${HEADER_X + 7}" y="${HEADER_Y - 7}" text-anchor="middle" fill="#8fc" font-size="3">GPIO</text>

        <!-- USB ports (right edge) -->
        <rect x="${PI_WIDTH - 14}" y="120" width="14" height="16" rx="1" fill="#888" stroke="#666"/>
        <rect x="${PI_WIDTH - 14}" y="140" width="14" height="16" rx="1" fill="#888" stroke="#666"/>
        <text x="${PI_WIDTH - 7}" y="117" text-anchor="middle" fill="#8fc" font-size="2.5">USB</text>

        <!-- Ethernet port -->
        <rect x="${PI_WIDTH - 14}" y="165" width="14" height="18" rx="1" fill="#999" stroke="#777"/>
        <text x="${PI_WIDTH - 7}" y="162" text-anchor="middle" fill="#8fc" font-size="2.5">ETH</text>

        <!-- Micro USB power (bottom) -->
        <rect x="10" y="${PI_HEIGHT - 8}" width="12" height="8" rx="1.5" fill="#888" stroke="#666"/>
        <text x="16" y="${PI_HEIGHT - 10}" text-anchor="middle" fill="#8fc" font-size="2.5">PWR</text>

        <!-- HDMI -->
        <rect x="35" y="${PI_HEIGHT - 8}" width="14" height="8" rx="1" fill="#777" stroke="#555"/>
        <text x="42" y="${PI_HEIGHT - 10}" text-anchor="middle" fill="#8fc" font-size="2.5">HDMI</text>

        <!-- 3.5mm audio jack -->
        <circle cx="${PI_WIDTH - 20}" cy="${PI_HEIGHT - 4}" r="4" fill="#444" stroke="#333"/>
        <text x="${PI_WIDTH - 20}" y="${PI_HEIGHT - 11}" text-anchor="middle" fill="#8fc" font-size="2.5">AV</text>

        <!-- CSI camera connector -->
        <rect x="65" y="50" width="20" height="4" rx="0.5" fill="#555" stroke="#444"/>
        <text x="75" y="48" text-anchor="middle" fill="#8fc" font-size="2">CAM</text>

        <!-- DSI display connector -->
        <rect x="65" y="115" width="20" height="4" rx="0.5" fill="#555" stroke="#444"/>
        <text x="75" y="113" text-anchor="middle" fill="#8fc" font-size="2">DSI</text>

        <!-- SD card slot (bottom left edge) -->
        <rect x="-2" y="170" width="8" height="14" rx="1" fill="#aaa" stroke="#888"/>
        <text x="3" y="168" text-anchor="middle" fill="#8fc" font-size="2.5">SD</text>

        <!-- Board labels -->
        <text x="${PI_WIDTH / 2}" y="18" text-anchor="middle" fill="#8fc" font-size="6" font-weight="bold">Raspberry Pi</text>
        <text x="${PI_WIDTH / 2}" y="26" text-anchor="middle" fill="#6ddb90" font-size="4">3 Model B</text>

        <!-- Power LED (red) -->
        <circle class="led-circle" id="ledPower" cx="${PI_WIDTH - 30}" cy="12" r="2"
                fill="${this._ledPower ? '#ff4444' : '#3a1a1a'}" stroke="#333"/>
        <text x="${PI_WIDTH - 30}" y="18" text-anchor="middle" fill="#8fc" font-size="2.5">PWR</text>

        <!-- Activity LED (green) -->
        <circle class="led-circle" id="ledAct" cx="${PI_WIDTH - 40}" cy="12" r="2"
                fill="${this._ledAct ? '#22ff22' : '#1a3a1a'}" stroke="#333"/>
        <text x="${PI_WIDTH - 40}" y="18" text-anchor="middle" fill="#8fc" font-size="2.5">ACT</text>
      </svg>
    `;
  }

  _updateLEDs() {
    const pwr = this.shadowRoot?.getElementById('ledPower');
    if (pwr) pwr.setAttribute('fill', this._ledPower ? '#ff4444' : '#3a1a1a');
    const act = this.shadowRoot?.getElementById('ledAct');
    if (act) act.setAttribute('fill', this._ledAct ? '#22ff22' : '#1a3a1a');
  }
}

if (!customElements.get('pi3-board')) {
  customElements.define('pi3-board', Pi3BoardElement);
}

export { Pi3BoardElement };
