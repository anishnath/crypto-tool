/**
 * ESP32C3Board — custom SVG board visual for ESP32-C3-DevKitM-1.
 *
 * Registers as <esp32c3-board> custom element with:
 *   - led8: boolean (LED_BUILTIN on GPIO8)
 *   - ledPower: boolean
 *   - pinInfo: array (pin coordinates for wire connections)
 *
 * Board layout based on ESP32-C3-DevKitM-1:
 *   - 2×15 header pins (left and right sides)
 *   - USB-C at bottom
 *   - RGB LED (WS2812) and boot/reset buttons
 *   - ESP32-C3-MINI-1 module
 */

const BOARD_WIDTH = 140;
const BOARD_HEIGHT = 280;
const PIN_SPACING = 10;
const LEFT_PIN_X = 8;
const RIGHT_PIN_X = BOARD_WIDTH - 8;
const FIRST_PIN_Y = 40;
const PINS_PER_SIDE = 15;

// Left side pins (top to bottom): 3V3, GND, GPIO0–GPIO10
const LEFT_LABELS = [
  '3V3', 'GND', 'GPIO0', 'GPIO1', 'GPIO2', 'GPIO3', 'GPIO4', 'GPIO5',
  'GPIO6', 'GPIO7', 'GPIO8', 'GPIO9', 'GPIO10', 'GND', '5V'
];

// Right side pins (top to bottom): GND, GPIO21–GPIO11 (descending), etc.
const RIGHT_LABELS = [
  'GND', 'GPIO21', 'GPIO20', 'GPIO19', 'GPIO18', 'RX', 'TX',
  'GND', 'GPIO11', 'GPIO12', 'GPIO13', 'GND', 'NC', 'NC', '5V'
];

class ESP32C3BoardElement extends HTMLElement {
  constructor() {
    super();
    this._led8 = false;
    this._ledPower = false;
    this.attachShadow({ mode: 'open' });
    this._render();
  }

  get led8() { return this._led8; }
  set led8(v) { this._led8 = v; this._updateLED(); }

  get ledPower() { return this._ledPower; }
  set ledPower(v) { this._ledPower = v; this._updatePower(); }

  get pinInfo() {
    const pins = [];

    // Left side pins
    for (let i = 0; i < PINS_PER_SIDE; i++) {
      const label = LEFT_LABELS[i];
      const signals = [];
      if (label === 'GND') signals.push({ type: 'power', signal: 'GND' });
      else if (label === '3V3') signals.push({ type: 'power', signal: '3.3V' });
      else if (label === '5V') signals.push({ type: 'power', signal: '5V' });
      pins.push({
        name: label,
        x: LEFT_PIN_X,
        y: FIRST_PIN_Y + i * PIN_SPACING,
        signals
      });
    }

    // Right side pins
    for (let i = 0; i < PINS_PER_SIDE; i++) {
      const label = RIGHT_LABELS[i];
      const signals = [];
      if (label === 'GND') signals.push({ type: 'power', signal: 'GND' });
      else if (label === '5V') signals.push({ type: 'power', signal: '5V' });
      else if (label === 'TX') signals.push({ type: 'usart', signal: 'TX' });
      else if (label === 'RX') signals.push({ type: 'usart', signal: 'RX' });
      pins.push({
        name: label,
        x: RIGHT_PIN_X,
        y: FIRST_PIN_Y + i * PIN_SPACING,
        signals
      });
    }

    return pins;
  }

  _render() {
    const pinHolesLeft = Array.from({ length: PINS_PER_SIDE }, (_, i) =>
      `<circle class="pin-hole" cx="${LEFT_PIN_X}" cy="${FIRST_PIN_Y + i * PIN_SPACING}" r="2.5"/>
       <text x="${LEFT_PIN_X + 7}" y="${FIRST_PIN_Y + i * PIN_SPACING + 1.5}" fill="#9ca3af" font-size="3.5" text-anchor="start">${LEFT_LABELS[i]}</text>`
    ).join('');

    const pinHolesRight = Array.from({ length: PINS_PER_SIDE }, (_, i) =>
      `<circle class="pin-hole" cx="${RIGHT_PIN_X}" cy="${FIRST_PIN_Y + i * PIN_SPACING}" r="2.5"/>
       <text x="${RIGHT_PIN_X - 7}" y="${FIRST_PIN_Y + i * PIN_SPACING + 1.5}" fill="#9ca3af" font-size="3.5" text-anchor="end">${RIGHT_LABELS[i]}</text>`
    ).join('');

    this.shadowRoot.innerHTML = `
      <style>
        :host { display: inline-block; }
        .board { font-family: 'DM Sans', sans-serif; }
        .pin-hole { fill: #1a1a2e; stroke: #e2b04a; stroke-width: 0.5; }
        .led-circle { transition: fill 0.15s; }
      </style>
      <svg class="board" width="${BOARD_WIDTH}" height="${BOARD_HEIGHT}" viewBox="0 0 ${BOARD_WIDTH} ${BOARD_HEIGHT}">
        <!-- PCB body -->
        <rect x="3" y="3" width="${BOARD_WIDTH - 6}" height="${BOARD_HEIGHT - 6}" rx="4"
              fill="#1a1a2e" stroke="#2d2d44" stroke-width="1"/>

        <!-- ESP32-C3-MINI-1 module (silver can) -->
        <rect x="${BOARD_WIDTH / 2 - 18}" y="8" width="36" height="30" rx="2"
              fill="#c0c0c0" stroke="#999"/>
        <rect x="${BOARD_WIDTH / 2 - 15}" y="11" width="30" height="20" rx="1"
              fill="#888" stroke="#777"/>
        <text x="${BOARD_WIDTH / 2}" y="22" text-anchor="middle" fill="#333" font-size="4" font-weight="bold">ESP32-C3</text>
        <text x="${BOARD_WIDTH / 2}" y="27" text-anchor="middle" fill="#444" font-size="3">MINI-1</text>

        <!-- Antenna area (PCB trace) -->
        <rect x="${BOARD_WIDTH / 2 - 8}" y="3" width="16" height="7" rx="1"
              fill="none" stroke="#ffd700" stroke-width="0.5" stroke-dasharray="1,1"/>

        <!-- USB-C connector at bottom -->
        <rect x="${BOARD_WIDTH / 2 - 8}" y="${BOARD_HEIGHT - 10}" width="16" height="10" rx="2"
              fill="#888" stroke="#666"/>
        <rect x="${BOARD_WIDTH / 2 - 6}" y="${BOARD_HEIGHT - 8}" width="12" height="7" rx="1.5"
              fill="#444"/>

        <!-- Board label -->
        <text x="${BOARD_WIDTH / 2}" y="${BOARD_HEIGHT - 16}" text-anchor="middle"
              fill="#6366f1" font-size="5" font-weight="bold">ESP32-C3</text>
        <text x="${BOARD_WIDTH / 2}" y="${BOARD_HEIGHT - 11}" text-anchor="middle"
              fill="#818cf8" font-size="3.5">DevKitM-1</text>

        <!-- Left pin holes with labels -->
        ${pinHolesLeft}

        <!-- Right pin holes with labels -->
        ${pinHolesRight}

        <!-- Built-in LED (GPIO8) — addressable RGB, shown as single dot -->
        <circle class="led-circle" id="led8" cx="${BOARD_WIDTH - 22}" cy="18" r="3"
                fill="${this._led8 ? '#22ff22' : '#1a2a1a'}" stroke="#333"/>
        <text x="${BOARD_WIDTH - 22}" y="25" text-anchor="middle" fill="#6366f1" font-size="3">LED</text>

        <!-- Power LED -->
        <circle class="led-circle" id="ledPower" cx="22" cy="18" r="2"
                fill="${this._ledPower ? '#ff4444' : '#3a1a1a'}" stroke="#333"/>
        <text x="22" y="25" text-anchor="middle" fill="#6366f1" font-size="2.5">PWR</text>

        <!-- BOOT button -->
        <rect x="22" y="${BOARD_HEIGHT - 30}" width="12" height="6" rx="1" fill="#ddd" stroke="#999"/>
        <text x="28" y="${BOARD_HEIGHT - 22}" text-anchor="middle" fill="#818cf8" font-size="3">BOOT</text>

        <!-- RST button -->
        <rect x="${BOARD_WIDTH - 34}" y="${BOARD_HEIGHT - 30}" width="12" height="6" rx="1" fill="#ddd" stroke="#999"/>
        <text x="${BOARD_WIDTH - 28}" y="${BOARD_HEIGHT - 22}" text-anchor="middle" fill="#818cf8" font-size="3">RST</text>
      </svg>
    `;
  }

  _updateLED() {
    const el = this.shadowRoot?.getElementById('led8');
    if (el) el.setAttribute('fill', this._led8 ? '#22ff22' : '#1a2a1a');
  }

  _updatePower() {
    const el = this.shadowRoot?.getElementById('ledPower');
    if (el) el.setAttribute('fill', this._ledPower ? '#ff4444' : '#3a1a1a');
  }
}

// Register custom element
if (!customElements.get('esp32c3-board')) {
  customElements.define('esp32c3-board', ESP32C3BoardElement);
}

export { ESP32C3BoardElement };
