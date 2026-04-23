/**
 * Menu Bar + Right-Click Context Menu
 * Pure DOM menus (no framework), dark theme.
 */

const CIRCUITS_MENU = [
  { label: 'Basics', sub: [
    { label: "Ohm's Law", action: 'preset:ohms-law' },
    { label: 'Series Resistors', action: 'preset:series-resistors' },
    { label: 'Parallel Resistors', action: 'preset:parallel-resistors' },
    { label: 'Voltage Divider', action: 'preset:voltage-divider' },
    { label: 'Current Divider', action: 'preset:current-divider' },
    { label: 'Wheatstone Bridge', action: 'preset:wheatstone' },
    { label: 'Capacitor', action: 'preset:capacitor' },
    { label: 'Polarized Capacitor (RC)', action: 'preset:polarized-cap-demo' },
    { label: 'Inductor', action: 'preset:inductor' },
  ]},
  { label: 'AC Circuits', sub: [
    { label: 'RC Circuit (Charging)', action: 'preset:rc-circuit' },
    { label: 'RL Circuit', action: 'preset:rl-circuit' },
    { label: 'RLC Series Resonance', action: 'preset:rlc-series' },
    { label: 'Low-Pass RC Filter', action: 'preset:rc-lowpass' },
    { label: 'High-Pass RC Filter', action: 'preset:rc-highpass' },
    { label: 'LC Tank Oscillator', action: 'preset:lc-tank' },
    { label: 'Frequency Doubler', action: 'preset:freq-doubler' },
  ]},
  { label: 'Diodes', sub: [
    { label: 'Diode + Resistor', action: 'preset:diode-resistor' },
    { label: 'LED Circuit', action: 'preset:led-circuit' },
    { label: 'Zener Regulator', action: 'preset:zener-regulator' },
    { label: 'Half-Wave Rectifier', action: 'preset:half-wave-rectifier' },
    { label: 'Full-Wave Bridge Rectifier', action: 'preset:full-wave-rectifier' },
    { label: 'Voltage Doubler', action: 'preset:voltage-doubler' },
    { label: 'Peak Detector', action: 'preset:peak-detector' },
    { label: 'Diode Clamp', action: 'preset:diode-clamp' },
  ]},
  { label: 'Transistors', sub: [
    { label: 'Common Emitter Amplifier', action: 'preset:common-emitter' },
    { label: 'Emitter Follower', action: 'preset:emitter-follower' },
    { label: 'BJT Switch', action: 'preset:bjt-switch' },
    { label: 'Current Mirror', action: 'preset:current-mirror' },
    { label: 'Darlington Pair (discrete)', action: 'preset:darlington' },
    { label: 'Darlington (single component)', action: 'preset:darlington-native' },
    { label: 'Push-Pull Output', action: 'preset:push-pull' },
    { label: 'NMOS Switch', action: 'preset:nmos-switch' },
    { label: 'NMOS Inverter', action: 'preset:nmos-inverter' },
    { label: 'MOSFET Current Source', action: 'preset:mos-current-src' },
    { label: 'JFET Common-Source Amp', action: 'preset:jfet-amplifier' },
    { label: 'JFET Switch', action: 'preset:jfet-switch' },
  ]},
  { label: 'Op-Amps', sub: [
    { label: 'Inverting Amplifier', action: 'preset:inverting-opamp' },
    { label: 'Non-Inverting Amplifier', action: 'preset:noninverting-opamp' },
    { label: 'Voltage Follower', action: 'preset:voltage-follower' },
    { label: 'Summing Amplifier', action: 'preset:summing-amp' },
    { label: 'Difference Amplifier', action: 'preset:difference-amp' },
    { label: 'Integrator', action: 'preset:integrator' },
  ]},
  { label: 'Logic Gates', sub: [
    { label: 'AND Gate', action: 'preset:and-gate-demo' },
    { label: 'OR Gate', action: 'preset:or-gate-demo' },
    { label: 'NOT Gate (Inverter)', action: 'preset:not-gate-demo' },
    { label: 'NAND Gate', action: 'preset:nand-gate-demo' },
    { label: 'XOR Gate', action: 'preset:xor-gate-demo' },
    { label: 'Half Adder (gates)', action: 'preset:half-adder' },
    { label: 'Half Adder (component)', action: 'preset:half-adder-native' },
    { label: 'Full Adder', action: 'preset:full-adder-native' },
    { label: 'NAND SR Latch', action: 'preset:nand-sr-latch' },
    { label: 'Logic Input/Output', action: 'preset:logic-io-demo' },
  ]},
  { label: 'Sequential Logic', sub: [
    { label: 'D Flip-Flop', action: 'preset:d-flipflop-demo' },
    { label: 'SR Flip-Flop', action: 'preset:sr-flipflop-demo' },
    { label: 'JK Flip-Flop (toggle)', action: 'preset:jk-flipflop-demo' },
    { label: 'Counter (4-bit)', action: 'preset:counter-demo' },
    { label: 'Shift Register (4-bit)', action: 'preset:shift-register-demo' },
    { label: 'Multiplexer (2:1)', action: 'preset:mux-demo' },
  ]},
  { label: 'Controlled Sources', sub: [
    { label: 'VCVS (Voltage Gain)', action: 'preset:vcvs-demo' },
    { label: 'VCCS (Transconductance)', action: 'preset:vccs-demo' },
    { label: 'CCVS (Transresistance)', action: 'preset:ccvs-demo' },
    { label: 'CCCS (Current Gain)', action: 'preset:cccs-demo' },
  ]},
  { label: 'Power & Switching', sub: [
    { label: 'Relay Circuit', action: 'preset:relay-demo' },
    { label: 'Ideal Switch', action: 'preset:ideal-switch-demo' },
    { label: 'Push Switch + LED', action: 'preset:push-switch-demo' },
    { label: 'SPDT Switch', action: 'preset:spdt-switch-demo' },
    { label: 'Fuse Protection', action: 'preset:fuse-demo' },
    { label: 'Incandescent Lamp', action: 'preset:lamp-demo' },
  ]},
  { label: 'Passive Filters', sub: [
    { label: 'Band-Pass RC', action: 'preset:bandpass-rc' },
    { label: 'Notch Filter (Twin-T)', action: 'preset:notch-twint' },
    { label: 'RL Low-Pass', action: 'preset:rl-lowpass' },
    { label: 'RL High-Pass', action: 'preset:rl-highpass' },
  ]},
  { label: 'Active Filters', sub: [
    { label: 'Sallen-Key Low-Pass', action: 'preset:sk-lowpass' },
    { label: 'Sallen-Key High-Pass', action: 'preset:sk-highpass' },
    { label: 'Active Band-Pass', action: 'preset:active-bandpass' },
  ]},
  { label: 'Oscillators', sub: [
    { label: 'Wien Bridge', action: 'preset:wien-bridge' },
    { label: 'Phase Shift', action: 'preset:phase-shift-osc' },
    { label: 'Relaxation (UJT-style)', action: 'preset:relaxation-osc' },
    { label: 'Astable Multivibrator', action: 'preset:astable-multi' },
  ]},
  { label: 'Signal Generators', sub: [
    { label: 'Schmitt Trigger (op-amp)', action: 'preset:schmitt-trigger' },
    { label: 'Schmitt Trigger (native)', action: 'preset:schmitt-native' },
    { label: 'Comparator', action: 'preset:comparator-demo' },
    { label: 'Monostable (One-Shot)', action: 'preset:monostable-demo' },
    { label: 'LED Flasher', action: 'preset:led-flasher' },
    { label: 'Staircase Generator', action: 'preset:staircase-gen' },
  ]},
  { label: 'Power Circuits', sub: [
    { label: 'Voltage Tripler', action: 'preset:voltage-tripler' },
    { label: 'Current Source (BJT)', action: 'preset:bjt-current-src' },
    { label: 'Voltage Regulator (Zener)', action: 'preset:zener-reg-loaded' },
  ]},
  { label: 'Logic Families', sub: [
    { label: 'RTL NAND', action: 'preset:rtl-nand' },
    { label: 'CMOS Inverter', action: 'preset:cmos-inverter' },
    { label: 'CMOS NAND', action: 'preset:cmos-nand' },
  ]},
  { label: 'Classic Theorems', sub: [
    { label: 'Thevenin Equivalent', action: 'preset:thevenin' },
    { label: 'Norton Equivalent', action: 'preset:norton' },
    { label: 'Superposition', action: 'preset:superposition' },
    { label: 'Max Power Transfer', action: 'preset:max-power' },
  ]},
  { label: 'Complex Circuits', sub: [
    { label: '3-Stage BJT Amplifier (25 elements)', action: 'preset:multi-stage-amp' },
    { label: 'R-2R Ladder DAC (16 elements)', action: 'preset:r2r-dac' },
    { label: 'AC Power Supply (16 elements)', action: 'preset:power-supply' },
  ]},
  { label: 'Advanced', sub: [
    { label: 'VCO (Voltage-Controlled Osc)', action: 'preset:vco-demo' },
    { label: 'Transmission Line', action: 'preset:tline-demo' },
    { label: 'Transformer Step-Up', action: 'preset:transformer-up' },
    { label: 'Transformer Step-Down', action: 'preset:transformer-down' },
  ]},
];

const DRAW_MENU = [
  { label: 'Add Wire', key: 'w', type: 'wire' },
  { label: 'Add Ground', key: 'g', type: 'ground' },
  { divider: true },
  { label: 'Passive Components', sub: [
    { label: 'Resistor', key: 'r', type: 'resistor' },
    { label: 'Capacitor', key: 'c', type: 'capacitor' },
    { label: 'Polarized Capacitor', type: 'polarized-cap' },
    { label: 'Inductor', key: 'l', type: 'inductor' },
    { label: 'Switch', key: 's', type: 'switch' },
    { label: 'Push Switch (momentary)', type: 'push-switch' },
    { label: 'SPDT Switch', type: 'spdt-switch' },
    { label: 'Fuse', type: 'fuse' },
    { label: 'Lamp (incandescent)', type: 'lamp' },
    { label: 'Transmission Line', type: 'transmission-line' },
  ]},
  { label: 'Inputs and Sources', sub: [
    { label: 'DC Voltage Source', key: 'v', type: 'dc-voltage' },
    { label: 'DC Current Source', key: 'i', type: 'dc-current' },
    { label: 'AC Voltage Source', key: 'a', type: 'ac-voltage' },
    { label: 'Clock (Square Wave)', key: 'k', type: 'clock' },
    { label: 'VCO (Voltage-Controlled Osc)', type: 'vco' },
    { divider: true },
    { label: 'VCVS (Voltage → Voltage)', type: 'vcvs' },
    { label: 'VCCS (Voltage → Current)', type: 'vccs' },
    { label: 'CCVS (Current → Voltage)', type: 'ccvs' },
    { label: 'CCCS (Current → Current)', type: 'cccs' },
  ]},
  { label: 'Outputs and Labels', sub: [
    { label: 'Ammeter', type: 'ammeter' },
    { label: 'Voltmeter', type: 'voltmeter' },
    { label: 'LED', type: 'led' },
    { label: '7-Segment Display', type: 'seven-seg' },
    { label: 'Logic Input (toggleable)', type: 'logic-input' },
    { label: 'Logic Output (indicator)', type: 'logic-output' },
  ]},
  { label: 'Active Components', sub: [
    { label: 'Diode', key: 'd', type: 'diode' },
    { label: 'Zener Diode', type: 'zener' },
    { divider: true },
    { label: 'NPN Transistor (BJT)', key: 't', type: 'bjt-npn' },
    { label: 'PNP Transistor (BJT)', type: 'bjt-pnp' },
    { label: 'NPN Darlington', type: 'darlington-npn' },
    { label: 'PNP Darlington', type: 'darlington-pnp' },
    { divider: true },
    { label: 'N-Channel MOSFET', type: 'mosfet-n' },
    { label: 'P-Channel MOSFET', type: 'mosfet-p' },
    { label: 'N-Channel JFET', type: 'jfet-n' },
    { label: 'P-Channel JFET', type: 'jfet-p' },
    { divider: true },
    { label: 'SCR/Thyristor', type: 'ideal-switch' },
  ]},
  { label: 'Active Building Blocks', sub: [
    { label: 'Op-Amp (Ideal)', key: 'o', type: 'opamp' },
    { label: 'Comparator', type: 'comparator' },
    { label: 'Schmitt Trigger', type: 'schmitt' },
    { label: 'Schmitt Trigger (Inverting)', type: 'schmitt-inv' },
    { label: '555 Timer', type: '555-timer' },
    { label: 'Monostable (One-Shot)', type: 'monostable' },
    { label: 'Relay', type: 'relay' },
  ]},
  { label: 'Logic Gates', sub: [
    { label: 'AND Gate', type: 'and-gate' },
    { label: 'OR Gate', type: 'or-gate' },
    { label: 'NOT Gate (Inverter)', type: 'not-gate' },
    { label: 'NAND Gate', type: 'nand-gate' },
    { label: 'NOR Gate', type: 'nor-gate' },
    { label: 'XOR Gate', type: 'xor-gate' },
  ]},
  { label: 'Digital Chips', sub: [
    { label: 'D Flip-Flop', type: 'd-flipflop' },
    { label: 'SR Flip-Flop', type: 'sr-flipflop' },
    { label: 'JK Flip-Flop', type: 'jk-flipflop' },
    { divider: true },
    { label: 'Counter (4-bit)', type: 'counter' },
    { label: 'Shift Register (4-bit)', type: 'shift-register' },
    { divider: true },
    { label: 'Multiplexer (2:1)', type: 'mux' },
    { label: 'Demultiplexer (1:2)', type: 'demux' },
    { divider: true },
    { label: 'Half Adder', type: 'half-adder' },
    { label: 'Full Adder', type: 'full-adder' },
  ]},
];

const CONTEXT_MENU_ELEMENT = [
  { label: 'Edit...', action: 'edit' },
  { label: 'View in Scope', action: 'scope' },
  { divider: true },
  { label: 'Delete', action: 'delete', shortcut: 'Del' },
];

export class MenuBar {
  /**
   * @param {HTMLElement} container - element to append menu bar into
   * @param {function} onSelectComponent - callback(type) when user picks a component
   * @param {function} onAction - callback(action, elm) for context menu actions
   */
  constructor(container, onSelectComponent, onAction) {
    this._onSelect = onSelectComponent;
    this._onAction = onAction;
    this._activePopup = null;
    this._keyMap = {};

    this._bar = document.createElement('div');
    this._bar.className = 'circuit-menu-bar';
    container.prepend(this._bar);

    // Build top-level menus
    this._addTopMenu('File', [
      { label: 'New Blank Circuit', action: 'new' },
      { divider: true },
      { label: 'Export Circuit (JSON)', action: 'export' },
      { label: 'Import Circuit (JSON)', action: 'import' },
      { label: 'Export Circuit (Netlist)', action: 'export-netlist' },
      { label: 'Import Circuit (Netlist)', action: 'import-netlist' },
      { divider: true },
      { label: 'Export as Image (PNG)', action: 'export-image' },
      { label: 'Share Circuit (URL)', action: 'share-url' },
    ]);
    this._addTopMenu('Edit', [
      { label: 'Undo', action: 'undo', shortcut: 'Ctrl+Z' },
      { label: 'Redo', action: 'redo', shortcut: 'Ctrl+Y' },
      { divider: true },
      { label: 'Delete', action: 'delete', shortcut: 'Del' },
    ]);
    this._addTopMenu('Draw', DRAW_MENU);
    this._addTopMenu('Circuits', CIRCUITS_MENU);
    this._addTopMenu('Options', [
      { label: '☑ Show Current Dots', action: 'toggleDots', toggle: true },
      { label: '☑ Show Voltage Colors', action: 'toggleVoltage', toggle: true },
      { label: '☑ Show Values', action: 'toggleValues', toggle: true },
      { label: '☐ Conventional Current', action: 'toggleConventional', toggle: true },
      { divider: true },
      { label: '☐ Show Scope/Graph', action: 'toggleScope', toggle: true },
    ]);
    this._addActionButton('🤖 AI', 'toggleAI');

    // Build key map from Draw menu
    this._buildKeyMap(DRAW_MENU);

    // Context menu container
    this._ctxMenu = document.createElement('div');
    this._ctxMenu.className = 'circuit-ctx-menu';
    this._ctxMenu.style.display = 'none';
    document.body.appendChild(this._ctxMenu);

    // Close on outside click
    document.addEventListener('mousedown', (e) => {
      if (!this._ctxMenu.contains(e.target)) this.hideContextMenu();
      if (this._activePopup && !this._activePopup.contains(e.target) &&
          !this._bar.contains(e.target)) this._closePopup();
    });
  }

  _getPresets() {
    return [
      { label: 'Voltage Divider', action: 'preset:voltage-divider' },
      { label: 'Wheatstone Bridge', action: 'preset:wheatstone' },
      { label: 'RC Circuit', action: 'preset:rc-circuit' },
      { label: 'Diode Rectifier', action: 'preset:diode-rectifier' },
      { label: 'Common Emitter', action: 'preset:common-emitter' },
      { label: 'Inverting Op-Amp', action: 'preset:inverting-opamp' },
    ];
  }

  _addActionButton(label, action) {
    const btn = document.createElement('div');
    btn.className = 'circuit-menu-btn circuit-menu-ai';
    btn.textContent = label;
    this._bar.appendChild(btn);
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      this._closePopup();
      this._onAction(action);
    });
  }

  _addTopMenu(label, items) {
    const btn = document.createElement('div');
    btn.className = 'circuit-menu-btn';
    btn.textContent = label;
    this._bar.appendChild(btn);

    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      this._closePopup();
      const popup = this._buildPopup(items);
      const rect = btn.getBoundingClientRect();
      popup.style.left = rect.left + 'px';
      popup.style.top = rect.bottom + 'px';
      document.body.appendChild(popup);
      this._activePopup = popup;
    });
  }

  _buildPopup(items, parentRight = false) {
    const popup = document.createElement('div');
    popup.className = 'circuit-menu-popup';

    for (const item of items) {
      if (item.divider) {
        const hr = document.createElement('div');
        hr.className = 'circuit-menu-divider';
        popup.appendChild(hr);
        continue;
      }

      const row = document.createElement('div');
      row.className = 'circuit-menu-item';

      let labelText = item.label;
      if (item.key) labelText += `  [${item.key}]`;

      const labelSpan = document.createElement('span');
      labelSpan.textContent = labelText;
      row.appendChild(labelSpan);

      if (item.shortcut) {
        const sc = document.createElement('span');
        sc.className = 'circuit-menu-shortcut';
        sc.textContent = item.shortcut;
        row.appendChild(sc);
      }

      if (item.sub) {
        const arrow = document.createElement('span');
        arrow.textContent = '▸';
        arrow.style.marginLeft = 'auto';
        row.appendChild(arrow);

        row.addEventListener('mouseenter', () => {
          // Remove other submenus
          popup.querySelectorAll('.circuit-menu-popup').forEach(p => p.remove());
          const sub = this._buildPopup(item.sub, true);
          const rect = row.getBoundingClientRect();
          sub.style.left = rect.right + 'px';
          sub.style.top = rect.top + 'px';
          popup.appendChild(sub);
        });
      } else {
        row.addEventListener('click', (e) => {
          e.stopPropagation();
          this._closePopup();
          this.hideContextMenu();
          if (item.type) this._onSelect(item.type);
          else if (item.action) {
            this._onAction(item.action);
            // Toggle checkmark for toggle items
            if (item.toggle) {
              const txt = row.textContent;
              if (txt.startsWith('☑')) item.label = '☐' + txt.slice(1);
              else if (txt.startsWith('☐')) item.label = '☑' + txt.slice(1);
              row.textContent = item.label;
            }
          }
        });
      }

      popup.appendChild(row);
    }

    return popup;
  }

  _closePopup() {
    if (this._activePopup) {
      this._activePopup.remove();
      this._activePopup = null;
    }
  }

  _buildKeyMap(items) {
    for (const item of items) {
      if (item.key) this._keyMap[item.key] = item.type;
      if (item.sub) this._buildKeyMap(item.sub);
    }
  }

  /** Handle keyboard shortcut. Returns component type or null. */
  handleKey(key) {
    return this._keyMap[key] || null;
  }

  /** Show context menu for an element */
  showContextMenu(x, y, elm) {
    const items = elm ? CONTEXT_MENU_ELEMENT : DRAW_MENU;
    this._ctxMenu.innerHTML = '';
    const popup = this._buildPopup(items);
    popup.style.position = 'relative';
    popup.style.left = '0';
    popup.style.top = '0';
    this._ctxMenu.appendChild(popup);
    this._ctxMenu.style.display = 'block';
    this._ctxMenu.style.left = x + 'px';
    this._ctxMenu.style.top = y + 'px';
    this._ctxMenu._elm = elm;
  }

  hideContextMenu() {
    this._ctxMenu.style.display = 'none';
  }
}
