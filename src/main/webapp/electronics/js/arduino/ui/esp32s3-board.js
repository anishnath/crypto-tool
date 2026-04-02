/**
 * ESP32S3Board — custom SVG board visual for ESP32-S3-DevKitC-1.
 *
 * Registers as <esp32s3-board> custom element with:
 *   - led48: boolean (LED_BUILTIN on GPIO48 — addressable RGB on most S3 boards)
 *   - ledPower: boolean
 *   - pinInfo: array (pin coordinates for wire connections)
 *
 * Board layout based on ESP32-S3-DevKitC-1:
 *   - 2×22 header pins (left and right sides)
 *   - USB-C at bottom
 *   - ESP32-S3-WROOM-1 module at top
 */

const S3_WIDTH = 140;
const S3_HEIGHT = 340;
const S3_PIN_SPACING = 10;
const S3_LEFT_X = 8;
const S3_RIGHT_X = S3_WIDTH - 8;
const S3_FIRST_Y = 50;
const S3_PINS_PER_SIDE = 22;

const S3_LEFT_LABELS = [
  '3V3', '3V3', 'RST', 'GPIO4', 'GPIO5', 'GPIO6', 'GPIO7', 'GPIO15',
  'GPIO16', 'GPIO17', 'GPIO18', 'GPIO8', 'GPIO3', 'GPIO46', 'GPIO9', 'GPIO10',
  'GPIO11', 'GPIO12', 'GPIO13', 'GPIO14', 'GND', '5V'
];

const S3_RIGHT_LABELS = [
  'GND', 'TX', 'RX', 'GPIO1', 'GPIO2', 'GPIO42', 'GPIO41', 'GPIO40',
  'GPIO39', 'GPIO38', 'GPIO37', 'GPIO36', 'GPIO35', 'GPIO0', 'GPIO45', 'GPIO48',
  'GPIO47', 'GPIO21', 'GPIO20', 'GPIO19', 'GND', '5V'
];

class ESP32S3BoardElement extends HTMLElement {
  constructor() {
    super();
    this._led48 = false;
    this._ledPower = false;
    this.attachShadow({ mode: 'open' });
    this._render();
  }

  get led48() { return this._led48; }
  set led48(v) { this._led48 = v; this._updateLED(); }
  // Alias for ESP32C3BoardBinding compatibility (uses led8)
  get led8() { return this._led48; }
  set led8(v) { this.led48 = v; }

  get ledPower() { return this._ledPower; }
  set ledPower(v) { this._ledPower = v; this._updatePower(); }

  get pinInfo() {
    const pins = [];
    for (let i = 0; i < S3_PINS_PER_SIDE; i++) {
      const label = S3_LEFT_LABELS[i];
      const signals = [];
      if (label === 'GND') signals.push({ type: 'power', signal: 'GND' });
      else if (label === '3V3') signals.push({ type: 'power', signal: '3.3V' });
      else if (label === '5V') signals.push({ type: 'power', signal: '5V' });
      pins.push({ name: label, x: S3_LEFT_X, y: S3_FIRST_Y + i * S3_PIN_SPACING, signals });
    }
    for (let i = 0; i < S3_PINS_PER_SIDE; i++) {
      const label = S3_RIGHT_LABELS[i];
      const signals = [];
      if (label === 'GND') signals.push({ type: 'power', signal: 'GND' });
      else if (label === '5V') signals.push({ type: 'power', signal: '5V' });
      else if (label === 'TX') signals.push({ type: 'usart', signal: 'TX' });
      else if (label === 'RX') signals.push({ type: 'usart', signal: 'RX' });
      pins.push({ name: label, x: S3_RIGHT_X, y: S3_FIRST_Y + i * S3_PIN_SPACING, signals });
    }
    return pins;
  }

  _render() {
    const pinHolesLeft = Array.from({ length: S3_PINS_PER_SIDE }, (_, i) =>
      `<circle class="pin-hole" cx="${S3_LEFT_X}" cy="${S3_FIRST_Y + i * S3_PIN_SPACING}" r="2.5"/>
       <text x="${S3_LEFT_X + 7}" y="${S3_FIRST_Y + i * S3_PIN_SPACING + 1.5}" fill="#9ca3af" font-size="3.5" text-anchor="start">${S3_LEFT_LABELS[i]}</text>`
    ).join('');

    const pinHolesRight = Array.from({ length: S3_PINS_PER_SIDE }, (_, i) =>
      `<circle class="pin-hole" cx="${S3_RIGHT_X}" cy="${S3_FIRST_Y + i * S3_PIN_SPACING}" r="2.5"/>
       <text x="${S3_RIGHT_X - 7}" y="${S3_FIRST_Y + i * S3_PIN_SPACING + 1.5}" fill="#9ca3af" font-size="3.5" text-anchor="end">${S3_RIGHT_LABELS[i]}</text>`
    ).join('');

    this.shadowRoot.innerHTML = `
      <style>
        :host { display: inline-block; }
        .board { font-family: 'DM Sans', sans-serif; }
        .pin-hole { fill: #1a1a2e; stroke: #e2b04a; stroke-width: 0.5; }
        .led-circle { transition: fill 0.15s; }
      </style>
      <svg class="board" width="${S3_WIDTH}" height="${S3_HEIGHT}" viewBox="0 0 ${S3_WIDTH} ${S3_HEIGHT}">
        <!-- PCB body -->
        <rect x="3" y="3" width="${S3_WIDTH - 6}" height="${S3_HEIGHT - 6}" rx="4"
              fill="#1a1a2e" stroke="#2d2d44" stroke-width="1"/>

        <!-- ESP32-S3-WROOM-1 module -->
        <rect x="${S3_WIDTH / 2 - 20}" y="8" width="40" height="34" rx="2"
              fill="#c0c0c0" stroke="#999"/>
        <rect x="${S3_WIDTH / 2 - 17}" y="11" width="34" height="24" rx="1"
              fill="#888" stroke="#777"/>
        <text x="${S3_WIDTH / 2}" y="24" text-anchor="middle" fill="#333" font-size="4" font-weight="bold">ESP32-S3</text>
        <text x="${S3_WIDTH / 2}" y="30" text-anchor="middle" fill="#444" font-size="3">WROOM-1</text>

        <!-- Antenna trace -->
        <rect x="${S3_WIDTH / 2 - 8}" y="3" width="16" height="7" rx="1"
              fill="none" stroke="#ffd700" stroke-width="0.5" stroke-dasharray="1,1"/>

        <!-- USB-C connector -->
        <rect x="${S3_WIDTH / 2 - 8}" y="${S3_HEIGHT - 10}" width="16" height="10" rx="2"
              fill="#888" stroke="#666"/>
        <rect x="${S3_WIDTH / 2 - 6}" y="${S3_HEIGHT - 8}" width="12" height="7" rx="1.5"
              fill="#444"/>

        <!-- Board label -->
        <text x="${S3_WIDTH / 2}" y="${S3_HEIGHT - 18}" text-anchor="middle"
              fill="#8b5cf6" font-size="5" font-weight="bold">ESP32-S3</text>
        <text x="${S3_WIDTH / 2}" y="${S3_HEIGHT - 12}" text-anchor="middle"
              fill="#a78bfa" font-size="3.5">DevKitC-1</text>

        <!-- Pin holes -->
        ${pinHolesLeft}
        ${pinHolesRight}

        <!-- RGB LED (GPIO48) -->
        <circle class="led-circle" id="led48" cx="${S3_WIDTH - 22}" cy="22" r="3"
                fill="${this._led48 ? '#22ff22' : '#1a2a1a'}" stroke="#333"/>
        <text x="${S3_WIDTH - 22}" y="29" text-anchor="middle" fill="#8b5cf6" font-size="3">RGB</text>

        <!-- Power LED -->
        <circle class="led-circle" id="ledPower" cx="22" cy="22" r="2"
                fill="${this._ledPower ? '#ff4444' : '#3a1a1a'}" stroke="#333"/>
        <text x="22" y="29" text-anchor="middle" fill="#8b5cf6" font-size="2.5">PWR</text>

        <!-- BOOT button -->
        <rect x="22" y="${S3_HEIGHT - 32}" width="12" height="6" rx="1" fill="#ddd" stroke="#999"/>
        <text x="28" y="${S3_HEIGHT - 24}" text-anchor="middle" fill="#a78bfa" font-size="3">BOOT</text>

        <!-- RST button -->
        <rect x="${S3_WIDTH - 34}" y="${S3_HEIGHT - 32}" width="12" height="6" rx="1" fill="#ddd" stroke="#999"/>
        <text x="${S3_WIDTH - 28}" y="${S3_HEIGHT - 24}" text-anchor="middle" fill="#a78bfa" font-size="3">RST</text>
      </svg>
    `;
  }

  _updateLED() {
    const el = this.shadowRoot?.getElementById('led48');
    if (el) el.setAttribute('fill', this._led48 ? '#22ff22' : '#1a2a1a');
  }

  _updatePower() {
    const el = this.shadowRoot?.getElementById('ledPower');
    if (el) el.setAttribute('fill', this._ledPower ? '#ff4444' : '#3a1a1a');
  }
}

if (!customElements.get('esp32s3-board')) {
  customElements.define('esp32s3-board', ESP32S3BoardElement);
}

export { ESP32S3BoardElement };
