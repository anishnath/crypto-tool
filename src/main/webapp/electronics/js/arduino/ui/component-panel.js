/**
 * ComponentPanel — UI for adding/removing virtual components.
 *
 * Manages the lifecycle of wokwi-elements + their bindings:
 *   [+ Component] → pick type → pick pin → create element + binding → attach
 *   [×] → detach binding → remove element from DOM
 */

import { LedBinding } from '../bindings/led.js';
import { ButtonBinding } from '../bindings/button.js';
import { PotBinding } from '../bindings/pot.js';
import { ServoBinding } from '../bindings/servo.js';
import { BuzzerBinding } from '../bindings/buzzer.js';
import { SlideSwitchBinding } from '../bindings/slide-switch.js';
import { PhotoresistorBinding } from '../bindings/photoresistor.js';
import { RelayBinding } from '../bindings/relay.js';
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
    const menu = document.createElement('div');
    menu.className = 'ard-add-menu';
    menu.style.cssText = `
      display:none; position:absolute; top:calc(100% + 4px); right:0;
      background:var(--ard-panel); border:1px solid var(--ard-border);
      border-radius:8px; padding:6px 0; min-width:180px; z-index:100;
      box-shadow:0 8px 24px rgba(0,0,0,.4);
    `;

    // Build grouped menu
    const groups = {};
    for (const [key, def] of Object.entries(COMPONENT_TYPES)) {
      if (!groups[def.group]) groups[def.group] = [];
      groups[def.group].push({ key, ...def });
    }

    for (const [group, items] of Object.entries(groups)) {
      const header = document.createElement('div');
      header.textContent = group;
      header.style.cssText = 'padding:4px 12px;font:600 10px "Sora",sans-serif;color:var(--ard-muted);text-transform:uppercase;letter-spacing:.05em;';
      menu.appendChild(header);

      for (const item of items) {
        const btn = document.createElement('button');
        btn.textContent = item.label;
        btn.style.cssText = `
          display:block; width:100%; text-align:left; padding:6px 12px;
          border:none; background:none; color:var(--ard-text);
          font:12px "DM Sans",sans-serif; cursor:pointer;
        `;
        btn.addEventListener('mouseenter', () => { btn.style.background = 'rgba(255,255,255,.06)'; });
        btn.addEventListener('mouseleave', () => { btn.style.background = 'none'; });
        btn.addEventListener('click', () => {
          menu.style.display = 'none';
          this._showPinPicker(item.key, item.pins);
        });
        menu.appendChild(btn);
      }
    }

    this._menuEl = menu;
  }

  _initAddBtn() {
    this.addBtn.style.position = 'relative';
    this.addBtn.appendChild(this._menuEl);

    this.addBtn.addEventListener('click', (e) => {
      if (this._menuEl.contains(e.target)) return; // click was inside menu itself
      const open = this._menuEl.style.display !== 'none';
      this._menuEl.style.display = open ? 'none' : 'block';
    });

    // Close on outside click
    document.addEventListener('click', (e) => {
      if (!this.addBtn.contains(e.target)) {
        this._menuEl.style.display = 'none';
      }
    });
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
