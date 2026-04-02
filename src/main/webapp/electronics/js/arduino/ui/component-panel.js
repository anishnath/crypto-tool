/**
 * ComponentPanel — UI for adding/removing virtual components.
 *
 * Manages the lifecycle of wokwi-elements + their bindings:
 *   [+ Component] → pick type → pick pin → create element + binding → attach
 *   [×] → detach binding → remove element from DOM
 */

import { LedBinding } from '../bindings/led.js';
import { RgbLedBinding } from '../bindings/rgb-led.js';
import { ButtonBinding } from '../bindings/button.js';
import { PotBinding } from '../bindings/pot.js';
import { ServoBinding } from '../bindings/servo.js';
import { BuzzerBinding } from '../bindings/buzzer.js';
import { SlideSwitchBinding } from '../bindings/slide-switch.js';
import { PhotoresistorBinding } from '../bindings/photoresistor.js';
import { RelayBinding } from '../bindings/relay.js';
import { NeoPixelBinding } from '../bindings/neopixel.js';
import { SevenSegBinding } from '../bindings/seven-seg.js';
import { EncoderBinding } from '../bindings/encoder.js';
import { KeypadBinding } from '../bindings/keypad.js';
import { LcdBinding } from '../bindings/lcd.js';
import { OledBinding } from '../bindings/oled.js';
import { Dht22Binding } from '../bindings/dht22.js';
import { HcSr04Binding } from '../bindings/hcsr04.js';
import { AnalogSensorBinding } from '../bindings/analog-sensor.js';
import { PWM_PIN_SET } from '../pin-map.js';

/** Component type definitions */
const COMPONENT_TYPES = {
  led: {
    label: 'LED',
    tag: 'wokwi-led',
    group: 'Output',
    pins: 'digital',
    attrs: { color: 'red' },
    binding: LedBinding,
  },
  'led-green': {
    label: 'LED (green)',
    tag: 'wokwi-led',
    group: 'Output',
    pins: 'digital',
    attrs: { color: 'green' },
    binding: LedBinding,
  },
  'led-yellow': {
    label: 'LED (yellow)',
    tag: 'wokwi-led',
    group: 'Output',
    pins: 'digital',
    attrs: { color: 'yellow' },
    binding: LedBinding,
  },
  pushbutton: {
    label: 'Push Button',
    tag: 'wokwi-pushbutton',
    group: 'Input',
    pins: 'digital',
    attrs: { color: 'red' },
    binding: ButtonBinding,
  },
  potentiometer: {
    label: 'Potentiometer',
    tag: 'wokwi-potentiometer',
    group: 'Input',
    pins: 'analog',
    attrs: {},
    binding: PotBinding,
  },
  'slide-potentiometer': {
    label: 'Slide Pot',
    tag: 'wokwi-slide-potentiometer',
    group: 'Input',
    pins: 'analog',
    attrs: {},
    binding: PotBinding,
  },
  servo: {
    label: 'Servo',
    tag: 'wokwi-servo',
    group: 'Output',
    pins: 'servo',
    attrs: { horn: 'single' },
    binding: ServoBinding,
  },
  buzzer: {
    label: 'Buzzer',
    tag: 'wokwi-buzzer',
    group: 'Output',
    pins: 'digital',
    attrs: {},
    binding: BuzzerBinding,
  },
  relay: {
    label: 'Relay',
    tag: 'wokwi-ks2e-m-dc5',
    group: 'Output',
    pins: 'digital',
    attrs: {},
    binding: RelayBinding,
  },
  'slide-switch': {
    label: 'Slide Switch',
    tag: 'wokwi-slide-switch',
    group: 'Input',
    pins: 'digital',
    attrs: {},
    binding: SlideSwitchBinding,
  },
  photoresistor: {
    label: 'Light Sensor (LDR)',
    tag: 'wokwi-photoresistor-sensor',
    group: 'Sensors',
    pins: 'analog',
    attrs: {},
    binding: PhotoresistorBinding,
  },
  // ── New: components with existing bindings ──
  'rgb-led': {
    label: 'RGB LED',
    tag: 'wokwi-led',
    group: 'Output',
    pins: 'digital',
    attrs: { color: 'white', label: 'RGB' },
    binding: RgbLedBinding,
  },
  neopixel: {
    label: 'NeoPixel',
    tag: 'wokwi-neopixel',
    group: 'Output',
    pins: 'digital',
    attrs: {},
    binding: NeoPixelBinding,
  },
  '7segment': {
    label: '7-Segment',
    tag: 'wokwi-7segment',
    group: 'Displays',
    pins: 'digital',
    attrs: {},
    binding: SevenSegBinding,
  },
  encoder: {
    label: 'Rotary Encoder',
    tag: 'wokwi-ky-040',
    group: 'Input',
    pins: 'digital',
    attrs: {},
    binding: EncoderBinding,
  },
  keypad: {
    label: 'Keypad 4×4',
    tag: 'wokwi-membrane-keypad',
    group: 'Input',
    pins: 'digital',
    attrs: {},
    binding: KeypadBinding,
  },
  lcd: {
    label: 'LCD 16×2',
    tag: 'wokwi-lcd1602',
    group: 'Displays',
    pins: 'digital',
    attrs: {},
    binding: LcdBinding,
  },
  oled: {
    label: 'OLED SSD1306',
    tag: 'wokwi-ssd1306',
    group: 'Displays',
    pins: 'digital',
    attrs: {},
    binding: OledBinding,
  },
  dht22: {
    label: 'DHT22 Sensor',
    tag: 'wokwi-dht22',
    group: 'Sensors',
    pins: 'digital',
    attrs: {},
    binding: Dht22Binding,
  },
  hcsr04: {
    label: 'Ultrasonic HC-SR04',
    tag: 'wokwi-hc-sr04',
    group: 'Sensors',
    pins: 'digital',
    attrs: {},
    binding: HcSr04Binding,
  },
  'ntc-temp': {
    label: 'Temp Sensor (NTC)',
    tag: 'wokwi-ntc-temperature-sensor',
    group: 'Sensors',
    pins: 'analog',
    attrs: {},
    binding: AnalogSensorBinding,
  },
};

const DIGITAL_PINS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
const ANALOG_PINS = ['A0', 'A1', 'A2', 'A3', 'A4', 'A5'];
const SERVO_PINS = [9, 10]; // Timer1 OCR1A/OCR1B

export class ComponentPanel {
  /**
   * @param {HTMLElement} componentsArea - container for wokwi-elements
   * @param {HTMLElement} addBtn - the [+ Component] button
   * @param {import('./canvas.js').SimulatorCanvas} [canvas] - optional canvas for drag positioning
   */
  constructor(componentsArea, addBtn, canvas = null) {
    this.componentsArea = componentsArea;
    this.addBtn = addBtn;
    this.canvas = canvas;
    this.runner = null;
    /** @type {((comp: object) => void) | null} */
    this.onComponentAdded = null;
    /** @type {((compId: string) => void) | null} */
    this.onComponentRemoved = null;

    /** @type {Array<{id: string, type: string, pin: string|number, element: HTMLElement, binding: object, wrapper: HTMLElement}>} */
    this.components = [];

    this._nextId = 1;
    this._menuEl = null;

    this._initMenu();
    this._initAddBtn();
  }

  /** Set the runner (call after compile & run) */
  setRunner(runner) {
    this.runner = runner;
    // Re-attach all existing bindings to new runner
    for (const comp of this.components) {
      if (comp.binding) comp.binding.detach();
      const Cls = COMPONENT_TYPES[comp.type]?.binding;
      if (Cls && runner) {
        comp.binding = new Cls(comp.element, runner, comp.pin);
        comp.binding.attach();
      }
    }
  }

  /** Detach all bindings (call on stop) */
  detachAll() {
    for (const comp of this.components) {
      if (comp.binding) comp.binding.detach();
      comp.binding = null;
    }
    this.runner = null;
  }

  /** Add a component */
  add(typeKey, pin) {
    const def = COMPONENT_TYPES[typeKey];
    if (!def) return null;

    const id = 'comp-' + this._nextId++;

    // Create wokwi-element
    const el = document.createElement(def.tag);
    el.id = id;
    for (const [k, v] of Object.entries(def.attrs)) {
      el.setAttribute(k, v);
    }

    // Wrapper with label and remove button
    const wrapper = document.createElement('div');
    wrapper.className = 'ard-component-item';
    wrapper.dataset.compId = id;

    wrapper.appendChild(el);

    const labelRow = document.createElement('div');
    labelRow.style.cssText = 'display:flex;align-items:center;gap:4px;';

    const label = document.createElement('span');
    label.className = 'ard-component-label';
    label.textContent = def.label + ' \u2190 ' + pin;
    labelRow.appendChild(label);

    const removeBtn = document.createElement('button');
    removeBtn.textContent = '\u00D7';
    removeBtn.style.cssText = 'border:none;background:none;color:var(--ard-muted);cursor:pointer;font-size:14px;padding:0 2px;';
    removeBtn.title = 'Remove';
    removeBtn.addEventListener('click', () => this.remove(id));
    labelRow.appendChild(removeBtn);

    wrapper.appendChild(labelRow);
    this.componentsArea.appendChild(wrapper);

    // Position via canvas (drag-enabled) or fallback to flow
    if (this.canvas) {
      this.canvas.makeDraggable(wrapper);
      this.canvas.placeNearBoard(wrapper, this.components.length);
    }

    // Create binding
    let binding = null;
    if (this.runner && def.binding) {
      binding = new def.binding(el, this.runner, pin);
      binding.attach();
    }

    const comp = { id, type: typeKey, pin, element: el, binding, wrapper };
    this.components.push(comp);
    if (this.onComponentAdded) this.onComponentAdded(comp);
    return comp;
  }

  /** Clear all components from the canvas */
  clearAll() {
    const ids = this.components.map(c => c.id);
    for (const id of ids) this.remove(id);
  }

  /**
   * Load components from a preset definition.
   * @param {Array<{type: string, pin: string|number, x?: number, y?: number, attrs?: object}>} presetComponents
   */
  loadPreset(presetComponents) {
    this.clearAll();
    if (!presetComponents || !presetComponents.length) return;

    for (let i = 0; i < presetComponents.length; i++) {
      const pc = presetComponents[i];
      const comp = this.add(pc.type, pc.pin);
      if (comp && this.canvas && pc.x != null && pc.y != null) {
        this.canvas.setComponentPosition(comp.wrapper, pc.x, pc.y);
      }
      // Apply extra attrs
      if (comp && pc.attrs) {
        for (const [k, v] of Object.entries(pc.attrs)) {
          comp.element.setAttribute(k, v);
        }
      }
    }
  }

  /** Remove a component by id */
  remove(id) {
    const idx = this.components.findIndex(c => c.id === id);
    if (idx < 0) return;

    const comp = this.components[idx];
    if (comp.binding) comp.binding.detach();
    if (this.onComponentRemoved) this.onComponentRemoved(comp.id);
    comp.wrapper.remove();
    this.components.splice(idx, 1);
  }

  // ── Internal ──

  _initMenu() {
    // ── Slide-in component catalog panel ──
    const overlay = document.createElement('div');
    overlay.className = 'ard-comp-overlay';
    overlay.style.cssText = `
      display:none; position:fixed; inset:0; z-index:200;
      background:rgba(0,0,0,.4); backdrop-filter:blur(2px);
      opacity:0; transition:opacity .2s ease;
    `;

    const panel = document.createElement('div');
    panel.className = 'ard-comp-panel';
    panel.style.cssText = `
      position:absolute; top:0; right:0; bottom:0; width:320px;
      background:var(--ard-panel-deep, var(--ard-panel));
      border-left:1px solid var(--ard-border);
      box-shadow:-8px 0 32px rgba(0,0,0,.5);
      transform:translateX(100%); transition:transform .25s cubic-bezier(.4,0,.2,1);
      display:flex; flex-direction:column; overflow:hidden;
    `;

    // Header
    const header = document.createElement('div');
    header.style.cssText = `
      display:flex; align-items:center; justify-content:space-between;
      padding:14px 16px; border-bottom:1px solid var(--ard-border);
      flex-shrink:0;
    `;
    const title = document.createElement('span');
    title.textContent = 'Components';
    title.style.cssText = 'font:600 14px "Sora",sans-serif; color:var(--ard-text); letter-spacing:-.02em;';
    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&times;';
    closeBtn.style.cssText = `
      border:none; background:none; color:var(--ard-muted); font-size:20px;
      cursor:pointer; padding:0 4px; line-height:1; border-radius:4px;
      transition:color .15s, background .15s;
    `;
    closeBtn.addEventListener('mouseenter', () => { closeBtn.style.color = 'var(--ard-text)'; closeBtn.style.background = 'rgba(255,255,255,.08)'; });
    closeBtn.addEventListener('mouseleave', () => { closeBtn.style.color = 'var(--ard-muted)'; closeBtn.style.background = 'none'; });
    closeBtn.addEventListener('click', () => this._closePanel());
    header.appendChild(title);
    header.appendChild(closeBtn);
    panel.appendChild(header);

    // Scrollable body
    const body = document.createElement('div');
    body.style.cssText = 'flex:1; overflow-y:auto; padding:12px;';

    // Build grouped cards
    const groups = {};
    const groupOrder = ['Output', 'Input', 'Sensors', 'Displays'];
    for (const [key, def] of Object.entries(COMPONENT_TYPES)) {
      if (!groups[def.group]) groups[def.group] = [];
      groups[def.group].push({ key, ...def });
    }

    for (const groupName of groupOrder) {
      const items = groups[groupName];
      if (!items) continue;

      // Category header (collapsible)
      const catHeader = document.createElement('div');
      catHeader.style.cssText = `
        display:flex; align-items:center; gap:6px; padding:8px 4px 6px;
        cursor:pointer; user-select:none;
      `;
      const arrow = document.createElement('span');
      arrow.textContent = '\u25BE';
      arrow.style.cssText = 'color:var(--ard-muted); font-size:10px; transition:transform .2s;';
      const catLabel = document.createElement('span');
      catLabel.textContent = groupName;
      catLabel.style.cssText = 'font:600 11px "Sora",sans-serif; color:var(--ard-muted); text-transform:uppercase; letter-spacing:.06em;';
      catHeader.appendChild(arrow);
      catHeader.appendChild(catLabel);

      const grid = document.createElement('div');
      grid.style.cssText = `
        display:grid; grid-template-columns:repeat(3, 1fr); gap:8px;
        padding-bottom:12px; transition:max-height .25s ease, opacity .2s ease;
        overflow:hidden;
      `;

      catHeader.addEventListener('click', () => {
        const collapsed = grid.style.display === 'none';
        grid.style.display = collapsed ? 'grid' : 'none';
        arrow.style.transform = collapsed ? '' : 'rotate(-90deg)';
      });

      for (const item of items) {
        const card = document.createElement('div');
        card.style.cssText = `
          display:flex; flex-direction:column; align-items:center; gap:4px;
          padding:10px 4px 8px; border-radius:8px; cursor:pointer;
          border:1px solid transparent;
          background:rgba(255,255,255,.02);
          transition:all .15s ease;
        `;

        // Preview container — clips the wokwi element to a fixed box
        const previewBox = document.createElement('div');
        previewBox.style.cssText = `
          width:72px; height:52px; overflow:hidden; display:flex;
          align-items:center; justify-content:center;
          pointer-events:none; border-radius:4px;
        `;

        // Render live wokwi element at small scale
        const el = document.createElement(item.tag);
        if (item.attrs) for (const [k, v] of Object.entries(item.attrs)) el.setAttribute(k, v);
        el.style.cssText = 'transform:scale(0.35); transform-origin:center center; pointer-events:none;';
        previewBox.appendChild(el);
        card.appendChild(previewBox);

        // Label
        const nameLabel = document.createElement('span');
        nameLabel.textContent = item.label;
        nameLabel.style.cssText = `
          font:500 10px "DM Sans",sans-serif; color:var(--ard-text);
          text-align:center; line-height:1.2; max-width:80px;
          overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
        `;
        card.appendChild(nameLabel);

        // Hover effect
        card.addEventListener('mouseenter', () => {
          card.style.background = 'rgba(255,255,255,.06)';
          card.style.borderColor = 'var(--ard-border)';
          card.style.transform = 'translateY(-1px)';
        });
        card.addEventListener('mouseleave', () => {
          card.style.background = 'rgba(255,255,255,.02)';
          card.style.borderColor = 'transparent';
          card.style.transform = '';
        });

        // Click → close panel + show pin picker
        card.addEventListener('click', () => {
          this._closePanel();
          this._showPinPicker(item.key, item.pins);
        });

        grid.appendChild(card);
      }

      body.appendChild(catHeader);
      body.appendChild(grid);
    }

    panel.appendChild(body);
    overlay.appendChild(panel);
    document.body.appendChild(overlay);

    // Click overlay (outside panel) to close
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) this._closePanel();
    });

    this._overlayEl = overlay;
    this._panelEl = panel;
  }

  _openPanel() {
    this._overlayEl.style.display = 'block';
    requestAnimationFrame(() => {
      this._overlayEl.style.opacity = '1';
      this._panelEl.style.transform = 'translateX(0)';
    });
  }

  _closePanel() {
    this._panelEl.style.transform = 'translateX(100%)';
    this._overlayEl.style.opacity = '0';
    setTimeout(() => { this._overlayEl.style.display = 'none'; }, 250);
  }

  _initAddBtn() {
    this.addBtn.addEventListener('click', () => this._openPanel());
  }

  _showPinPicker(typeKey, pinType) {
    const pins = pinType === 'analog' ? ANALOG_PINS : pinType === 'servo' ? SERVO_PINS : DIGITAL_PINS;
    const pin = prompt('Select pin for ' + COMPONENT_TYPES[typeKey].label + ':\n\nAvailable: ' + pins.join(', '));
    if (pin === null) return;

    const resolved = pinType === 'analog' ? pin.toUpperCase() : parseInt(pin, 10);
    if (pinType === 'analog' && !ANALOG_PINS.includes(resolved)) {
      alert('Invalid analog pin. Choose from: ' + ANALOG_PINS.join(', '));
      return;
    }
    const validDigital = pinType === 'servo' ? SERVO_PINS : DIGITAL_PINS;
    if ((pinType === 'digital' || pinType === 'servo') && !validDigital.includes(resolved)) {
      alert('Invalid pin. Choose from: ' + validDigital.join(', '));
      return;
    }

    this.add(typeKey, resolved);
  }
}
