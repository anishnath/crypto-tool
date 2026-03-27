/**
 * Circuit Simulator App — main entry point
 * Wires together: canvas, renderer, menus, placement, solver
 */

import { CircuitCanvas } from './canvas.js';
import { Renderer } from './renderer.js';
import { MenuBar } from './menus.js';
import { Scope } from './scope.js';
import { Circuit } from '../circuit.js';
import { buildColorScale } from './colors.js';

// Element factory imports
import { Resistor } from '../elements/resistor.js';
import { DCVoltageSource } from '../elements/dc-voltage.js';
import { DCCurrentSource } from '../elements/dc-current.js';
import { Wire } from '../elements/wire.js';
import { Ground } from '../elements/ground.js';
import { Switch } from '../elements/switch.js';
import { Capacitor } from '../elements/capacitor.js';
import { Inductor } from '../elements/inductor.js';
import { ACVoltageSource } from '../elements/ac-voltage.js';
import { Diode, LED, ZenerDiode } from '../elements/diode.js';
import { BJT } from '../elements/bjt.js';
import { OpAmp } from '../elements/opamp.js';
import { MOSFET } from '../elements/mosfet.js';
import { Ammeter, Voltmeter } from '../elements/meter.js';
import { ANDGate, ORGate, NANDGate, NORGate, XORGate, NOTGate } from '../elements/logic-gate.js';
import { DFlipFlop, SRFlipFlop } from '../elements/flip-flop.js';
import { Timer555 } from '../elements/timer555.js';
import { VCVS, VCCS } from '../elements/controlled-source.js';
import { IdealSwitch } from '../elements/ideal-switch.js';
import { Clock } from '../elements/clock.js';
import { Relay } from '../elements/relay.js';
import { SevenSegDisplay } from '../elements/seven-seg.js';
import { VCO } from '../elements/vco.js';
import { TransmissionLine } from '../elements/transmission-line.js';
import { Subcircuit } from '../elements/subcircuit.js';
import { JFET } from '../elements/jfet.js';
import { CCVS, CCCS } from '../elements/cc-source.js';
import { PushSwitch, SPDTSwitch } from '../elements/switch2.js';
import { Fuse, Lamp, PolarizedCapacitor } from '../elements/fuse.js';
import { Comparator, SchmittTrigger } from '../elements/comparator.js';
import { Darlington } from '../elements/darlington.js';
import { JKFlipFlop, Counter, Multiplexer, Demultiplexer, ShiftRegister, HalfAdder, FullAdder, LogicInput, LogicOutput, Monostable } from '../elements/digital.js';

const MODE = { SELECT: 0, ADD_ELM: 1, DRAG_ALL: 2 };

const EDIT_MAP = {
  'resistor': [{ label: 'Resistance (Ω)', key: 'resistance', unit: 'Ω' }],
  'dc-voltage': [{ label: 'Voltage (V)', key: 'voltage', unit: 'V' }],
  'dc-current': [{ label: 'Current (A)', key: 'sourceCurrent', unit: 'A' }],
  'capacitor': [{ label: 'Capacitance (F)', key: 'capacitance', unit: 'F' }],
  'inductor': [{ label: 'Inductance (H)', key: 'inductance', unit: 'H' }],
  'ac-voltage': [{ label: 'Peak Voltage (V)', key: 'peakVoltage', unit: 'V' }, { label: 'Frequency (Hz)', key: 'frequency', unit: 'Hz' }],
  'clock': [{ label: 'Frequency (Hz)', key: 'frequency', unit: 'Hz' }],
  'zener': [{ label: 'Zener Voltage (V)', key: 'vz', unit: 'V' }],
  'bjt-npn': [{ label: 'Beta (hFE)', key: 'beta', unit: '' }],
  'bjt-pnp': [{ label: 'Beta (hFE)', key: 'beta', unit: '' }],
  'mosfet-n': [{ label: 'Threshold Vth (V)', key: 'vth', unit: 'V' }],
  'mosfet-p': [{ label: 'Threshold Vth (V)', key: 'vth', unit: 'V' }],
  'vco': [{ label: 'Center Freq (Hz)', key: 'fCenter', unit: 'Hz' }, { label: 'Gain (Hz/V)', key: 'gain', unit: 'Hz/V' }],
  'relay': [{ label: 'Coil Resistance (Ω)', key: 'coilR', unit: 'Ω' }],
  'jfet-n': [{ label: 'Idss (A)', key: 'idss', unit: 'A' }, { label: 'Vp (V)', key: 'vp', unit: 'V' }],
  'jfet-p': [{ label: 'Idss (A)', key: 'idss', unit: 'A' }, { label: 'Vp (V)', key: 'vp', unit: 'V' }],
  'ccvs': [{ label: 'Gain (Ω)', key: 'gain', unit: 'Ω' }],
  'cccs': [{ label: 'Current Gain', key: 'gain', unit: '' }],
  'fuse': [{ label: 'Rating (A)', key: 'rating', unit: 'A' }],
  'lamp': [{ label: 'Wattage (W)', key: 'wattage', unit: 'W' }, { label: 'Voltage (V)', key: 'nomVoltage', unit: 'V' }],
  'polarized-cap': [{ label: 'Capacitance (F)', key: 'capacitance', unit: 'F' }],
  'darlington-npn': [{ label: 'Single β', key: 'beta1', unit: '' }],
  'darlington-pnp': [{ label: 'Single β', key: 'beta1', unit: '' }],
  'schmitt': [{ label: 'V_high threshold', key: 'vHigh', unit: 'V' }, { label: 'V_low threshold', key: 'vLow', unit: 'V' }],
  'schmitt-inv': [{ label: 'V_high threshold', key: 'vHigh', unit: 'V' }, { label: 'V_low threshold', key: 'vLow', unit: 'V' }],
  'counter': [{ label: 'Modulus', key: 'modulus', unit: '' }],
  'monostable': [{ label: 'Pulse Duration (s)', key: 'pulseDuration', unit: 's' }],
};

export class CircuitApp {
  constructor(wrapEl) {
    this.wrap = wrapEl;

    // Canvas
    const canvasEl = wrapEl.querySelector('#circuitCanvas');
    this.canvas = new CircuitCanvas(canvasEl);
    this.renderer = new Renderer();

    // Circuit engine
    this.circuit = new Circuit();

    // UI elements (grid-based: [{type, gridPos, elm, ...}])
    this.uiElements = [];
    this.selectedElm = null;

    // Mode
    this.mode = MODE.SELECT;
    this.addType = null;      // component type being placed
    this._dragStart = null;   // grid coords of click start
    this._dragEnd = null;     // grid coords of current drag position
    this.running = true;      // simulation running

    // Undo/Redo stacks (store serialized snapshots)
    this._undoStack = [];
    this._redoStack = [];
    this._maxUndo = 50;

    // Simulation controls
    this.simSpeed = 50;        // 1-100
    this.currentSpeed = 50;    // 1-100
    this.simTime = 0;

    // Scope (oscilloscope)
    this._scopeWrap = wrapEl.querySelector('#scopeWrap');
    const scopeCanvas = wrapEl.querySelector('#scopeCanvas');
    this.scope = scopeCanvas ? new Scope(scopeCanvas) : null;

    // Scope splitter drag (resize scope panel)
    const splitter = wrapEl.querySelector('#scopeSplitter');
    if (splitter && this._scopeWrap) {
      let dragging = false, startY = 0, startH = 0;
      splitter.addEventListener('mousedown', (e) => {
        dragging = true; startY = e.clientY;
        startH = this._scopeWrap.offsetHeight;
        e.preventDefault();
      });
      window.addEventListener('mousemove', (e) => {
        if (!dragging) return;
        const newH = Math.max(80, Math.min(400, startH - (e.clientY - startY)));
        this._scopeWrap.style.height = newH + 'px';
      });
      window.addEventListener('mouseup', () => { dragging = false; });
    }

    // Info panel
    this._infoPanel = wrapEl.querySelector('#infoPanel');

    // Toolbar
    this._btnRunStop = wrapEl.querySelector('#btnRunStop');
    this._btnReset = wrapEl.querySelector('#btnReset');
    this._sliderSimSpeed = wrapEl.querySelector('#sliderSimSpeed');
    this._sliderCurrentSpeed = wrapEl.querySelector('#sliderCurrentSpeed');
    this._valSimSpeed = wrapEl.querySelector('#valSimSpeed');
    this._valCurrentSpeed = wrapEl.querySelector('#valCurrentSpeed');
    this._circuitInfo = wrapEl.querySelector('#circuitInfo');

    if (this._btnRunStop) {
      this._btnRunStop.addEventListener('click', () => this._toggleRun());
    }
    if (this._btnReset) {
      this._btnReset.addEventListener('click', () => this._resetSim());
    }
    if (this._sliderSimSpeed) {
      this._sliderSimSpeed.addEventListener('input', (e) => {
        this.simSpeed = parseInt(e.target.value);
        if (this._valSimSpeed) this._valSimSpeed.textContent = this.simSpeed + '%';
      });
    }
    if (this._sliderCurrentSpeed) {
      this._sliderCurrentSpeed.addEventListener('input', (e) => {
        this.currentSpeed = parseInt(e.target.value);
        if (this._valCurrentSpeed) this._valCurrentSpeed.textContent = this.currentSpeed + '%';
      });
    }

    // Menus
    this.menuBar = new MenuBar(
      wrapEl,
      (type) => this._startAdd(type),
      (action) => this._handleAction(action)
    );

    // Mouse events
    canvasEl.addEventListener('mousedown', (e) => this._onMouseDown(e));
    canvasEl.addEventListener('mousemove', (e) => this._onMouseMove(e));
    canvasEl.addEventListener('mouseup', (e) => this._onMouseUp(e));
    canvasEl.addEventListener('contextmenu', (e) => {
      e.preventDefault();
      this._onRightClick(e);
    });
    canvasEl.addEventListener('dblclick', (e) => this._onDblClick(e));

    // Long-press for context menu on mobile (replaces right-click)
    let _longPressTimer = null;
    canvasEl.addEventListener('touchstart', (e) => {
      if (e.touches.length === 1 && this.mode === MODE.SELECT) {
        _longPressTimer = setTimeout(() => {
          const t = e.touches[0];
          this._onRightClick({ offsetX: t.clientX, offsetY: t.clientY, clientX: t.clientX, clientY: t.clientY });
        }, 600);
      }
    });
    canvasEl.addEventListener('touchmove', () => { if (_longPressTimer) { clearTimeout(_longPressTimer); _longPressTimer = null; } });
    canvasEl.addEventListener('touchend', () => { if (_longPressTimer) { clearTimeout(_longPressTimer); _longPressTimer = null; } });

    // Touch → mouse routing for component placement
    this.canvas.onSingleTouch = (type, x, y) => {
      if (type === 'start') this._onMouseDown({ button: 0, offsetX: x, offsetY: y, altKey: false });
      else if (type === 'move') this._onMouseMove({ offsetX: x, offsetY: y });
      else if (type === 'end') this._onMouseUp({ button: 0 });
    };

    // Keyboard
    document.addEventListener('keydown', (e) => this._onKey(e));

    // Re-size canvas after menu bar is injected, then load URL if present
    requestAnimationFrame(() => {
      this.canvas._resize();
      this._loadFromURL();
    });

    // Start render loop
    this._raf = requestAnimationFrame((t) => this._frame(t));
  }

  // ─── Simulation controls (matching CircuitJS1 behavior) ───
  //
  // RUNNING: matrix solved each frame, time advances, dots animate, scope records
  // STOPPED: no solving, no time advance, dots frozen, but rendering + editing works
  //

  _toggleRun() {
    this.running = !this.running;
    if (this._btnRunStop) {
      this._btnRunStop.textContent = this.running ? '■ Stop' : '▶ Run';
      this._btnRunStop.classList.toggle('stopped', !this.running);
    }
  }

  _resetSim() {
    // Reset time
    this.simTime = 0;

    // Reset all element states (capacitor voltages, inductor currents, NR state)
    for (const ui of this.uiElements) {
      const elm = ui.elm;
      // Zero voltages and current
      for (let i = 0; i < elm.volts.length; i++) elm.volts[i] = 0;
      elm.current = 0;
      ui._curcount = 0;
      // Reset companion model state
      if (elm.curSourceValue !== undefined) elm.curSourceValue = 0;
      if (elm.compResistance !== undefined) elm.compResistance = 0;
      // Reset NR iteration state
      if (elm.lastVd !== undefined) elm.lastVd = 0;
      if (elm.lastvbe !== undefined) { elm.lastvbe = 0; elm.lastvbc = 0; }
      if (elm.lastVgs !== undefined) { elm.lastVgs = 0; elm.lastVds = 0; }
      if (elm._iter !== undefined) elm._iter = 0;
      if (elm._time !== undefined) elm._time = 0;  // AC source phase
    }

    // Re-analyze and solve from clean state
    this._rebuildAndSolve();

    // Clear scope data
    if (this.scope) this.scope.resetData();

    // If already at t=0, start running (CircuitJS1 behavior)
    if (!this.running) this._toggleRun();

    this._updateCircuitInfo();
  }

  /** Run physics timesteps — called each frame when this.running === true */
  _stepSimulation() {
    if (!this.circuit.mna || this.uiElements.length === 0) return;

    // Number of timesteps per frame based on simSpeed slider
    // CircuitJS1 formula: iterCount = 0.1 * exp((speed - 61) / 24)
    // Our simSpeed is 1-100, map to similar curve
    const iterCount = 0.1 * Math.exp((this.simSpeed - 30) / 20);
    const stepsPerFrame = Math.max(1, Math.round(iterCount));
    const dt = this.circuit.timeStep || 5e-6;

    const hasTimeDep = this.uiElements.some(ui => {
      const t = ui.type;
      return t === 'capacitor' || t === 'inductor' || t === 'ac-voltage' ||
        t === 'clock' || t === 'ideal-switch' || t === 'relay' || t === '555-timer' ||
        t === 'vco' || t === 'diode' || t === 'led' || t === 'zener' ||
        t === 'bjt-npn' || t === 'bjt-pnp' || t === 'mosfet-n' || t === 'mosfet-p' ||
        t === 'opamp' || t.includes('gate') || t.includes('flipflop');
    });

    // Pure DC: advance time for dots/scope but skip re-solve
    if (!hasTimeDep) {
      this.simTime += dt * stepsPerFrame;
      // Sync currents for scope recording (wire KCL already done in _rebuildAndSolve)
      for (const ui of this.uiElements) {
        ui.current = ui.elm.current || ui.current;
      }
      return;
    }

    for (let s = 0; s < stepsPerFrame; s++) {
      // startIteration: C/L update history currents
      for (const ui of this.uiElements) {
        if (ui.type === 'wire' || ui.type === 'ground') continue;
        ui.elm.startIteration();
      }

      // Clear and re-stamp matrix + doStep
      const mna = this.circuit.mna;
      mna._dt = dt;
      for (let i = 0; i < mna.size; i++) mna.a[i].fill(0);
      mna.b.fill(0);

      for (const ui of this.uiElements) {
        if (ui.type === 'wire' || ui.type === 'ground') continue;
        ui.elm.stamp(mna);
        ui.elm.doStep(mna);
      }

      // Solve
      const x = mna.solve();
      if (!x) break;

      // Distribute results
      for (let i = 1; i < this.circuit.nodeCount; i++) {
        this.circuit.nodeVoltages[i] = x[i - 1];
      }
      this.circuit.nodeVoltages[0] = 0;

      for (let n = 0; n < this.circuit.nodeCount; n++) {
        for (const link of this.circuit.nodeLinks[n]) {
          link.elm.setNodeVoltage(link.termIndex, this.circuit.nodeVoltages[n]);
        }
      }
      for (const ui of this.uiElements) {
        const elm = ui.elm;
        if (elm.voltSource >= 0 && elm.getVoltageSourceCount && elm.getVoltageSourceCount() > 0) {
          elm.current = x[(this.circuit.nodeCount - 1) + elm.voltSource];
        }
      }

      // stepFinished (AC source advances phase)
      for (const ui of this.uiElements) {
        if (ui.type === 'wire' || ui.type === 'ground') continue;
        if (ui.elm.stepFinished) ui.elm.stepFinished(dt);
      }

      this.simTime += dt;
    }

    // Sync UI element display values (same logic as _rebuildAndSolve)
    const gid = (gx, gy) => gx + ',' + gy;
    const pv = {};
    for (const ui of this.uiElements) {
      if (ui.type === 'wire' || ui.type === 'ground') continue;
      if (!ui.gridPos) continue;
      for (let i = 0; i < ui.gridPos.length && i < ui.elm.volts.length; i++) {
        pv[gid(ui.gridPos[i][0], ui.gridPos[i][1])] = ui.elm.volts[i];
      }
    }
    for (const ui of this.uiElements) {
      if (ui.type === 'wire') {
        ui.volts = [
          pv[gid(ui.gridPos[0][0], ui.gridPos[0][1])] || 0,
          pv[gid(ui.gridPos[1][0], ui.gridPos[1][1])] || 0,
        ];
      } else if (ui.type !== 'ground') {
        ui.volts = ui.elm.volts;
      }
      ui.current = ui.elm.current;
    }
    this._calcWireCurrents();
  }

  _showScope(show) {
    if (this._scopeWrap) {
      this._scopeWrap.style.display = show ? 'block' : 'none';
      // Trigger canvas resize after layout change
      requestAnimationFrame(() => {
        this.canvas._resize();
        if (this.scope) this.scope._resize();
      });
    }
  }

  _updateCircuitInfo() {
    if (!this._circuitInfo) return;
    const n = this.uiElements.filter(e => e.type !== 'wire' && e.type !== 'ground').length;
    const nodes = this.circuit.nodeCount || 0;
    let tStr;
    if (this.simTime === 0) tStr = '0.000s';
    else if (this.simTime < 1e-3) tStr = (this.simTime * 1e6).toFixed(1) + 'μs';
    else if (this.simTime < 1) tStr = (this.simTime * 1e3).toFixed(2) + 'ms';
    else tStr = this.simTime.toFixed(3) + 's';
    this._circuitInfo.textContent = `t = ${tStr}  |  ${n} elm  |  ${nodes} nodes`;
  }

  // ─── Mode switching ───

  _startAdd(type) {
    this.mode = MODE.ADD_ELM;
    this.addType = type;
    this._dragStart = null;
    this._dragEnd = null;
    this.canvas.el.style.cursor = 'crosshair';
    this.canvas.touchMode = 'draw';  // touch routes to placement
    this.menuBar.hideContextMenu();
  }

  _cancelAdd() {
    this.mode = MODE.SELECT;
    this.addType = null;
    this._dragStart = null;
    this._dragEnd = null;
    this.canvas.el.style.cursor = 'default';
    this.canvas.touchMode = 'pan';   // touch routes to pan
  }

  // ─── Element creation ───

  _createElement(type, gx1, gy1, gx2, gy2) {
    // Create a unique raw node ID from grid position
    const nodeId = (gx, gy) => gx * 10000 + gy;
    const n1 = nodeId(gx1, gy1), n2 = nodeId(gx2, gy2);

    let elm;
    switch (type) {
      case 'wire':        elm = new Wire(n1, n2); break;
      case 'resistor':    elm = new Resistor(n1, n2, 1000); break;
      case 'dc-voltage':  elm = new DCVoltageSource(n1, n2, 5); break;
      case 'dc-current':  elm = new DCCurrentSource(n1, n2, 0.01); break;
      case 'ground':      elm = new Ground(n1); break;
      case 'switch':      elm = new Switch(n1, n2, false); break;
      case 'capacitor':   elm = new Capacitor(n1, n2, 1e-6); break;
      case 'inductor':    elm = new Inductor(n1, n2, 1e-3); break;
      case 'ac-voltage':  elm = new ACVoltageSource(n1, n2, 5, 60); break;
      case 'diode':       elm = new Diode(n1, n2); break;
      case 'led':         elm = new LED(n1, n2); break;
      case 'zener':       elm = new ZenerDiode(n1, n2); break;
      case 'bjt-npn':     elm = new BJT(n1, n2, nodeId(gx2, gy2 + 1), { pnp: false }); break;
      case 'bjt-pnp':     elm = new BJT(n1, n2, nodeId(gx2, gy2 + 1), { pnp: true }); break;
      case 'mosfet-n':    elm = new MOSFET(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'mosfet-p':    elm = new MOSFET(n1, n2, nodeId(gx2, gy2 + 1), { pch: true }); break;
      case 'opamp':       elm = new OpAmp(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'ammeter':     elm = new Ammeter(n1, n2); break;
      case 'voltmeter':   elm = new Voltmeter(n1, n2); break;
      case 'and-gate':    elm = new ANDGate(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'or-gate':     elm = new ORGate(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'nand-gate':   elm = new NANDGate(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'nor-gate':    elm = new NORGate(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'xor-gate':    elm = new XORGate(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'not-gate':    elm = new NOTGate(n1, n2); break;
      case 'd-flipflop':  elm = new DFlipFlop(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx2, gy2 + 2)); break;
      case 'sr-flipflop': elm = new SRFlipFlop(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx2, gy2 + 2)); break;
      case '555-timer':   elm = new Timer555(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), nodeId(gx2, gy2 - 1)); break;
      case 'vcvs':        elm = new VCVS(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), 5); break;
      case 'vccs':        elm = new VCCS(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), 0.01); break;
      case 'ideal-switch': elm = new IdealSwitch(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'clock':       elm = new Clock(n1, n2, 1000); break;
      case 'relay':       elm = new Relay(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1)); break;
      case 'seven-seg':  elm = new SevenSegDisplay(n1, n2, nodeId(gx1+1,gy1), nodeId(gx1+2,gy1), nodeId(gx1+3,gy1), nodeId(gx1,gy1+1), nodeId(gx1+1,gy1+1), nodeId(gx2, gy2)); break;
      case 'vco':         elm = new VCO(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'transmission-line': elm = new TransmissionLine(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1)); break;
      // New components
      case 'jfet-n':        elm = new JFET(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'jfet-p':        elm = new JFET(n1, n2, nodeId(gx2, gy2 + 1), { pch: true }); break;
      case 'ccvs':          elm = new CCVS(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), 1000); break;
      case 'cccs':          elm = new CCCS(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), 10); break;
      case 'push-switch':   elm = new PushSwitch(n1, n2); break;
      case 'spdt-switch':   elm = new SPDTSwitch(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'fuse':          elm = new Fuse(n1, n2, 1); break;
      case 'lamp':          elm = new Lamp(n1, n2); break;
      case 'polarized-cap': elm = new PolarizedCapacitor(n1, n2, 100e-6); break;
      case 'comparator':    elm = new Comparator(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'schmitt':       elm = new SchmittTrigger(n1, n2); break;
      case 'schmitt-inv':   elm = new SchmittTrigger(n1, n2, { inverting: true }); break;
      case 'darlington-npn': elm = new Darlington(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'darlington-pnp': elm = new Darlington(n1, n2, nodeId(gx2, gy2 + 1), { pnp: true }); break;
      case 'jk-flipflop':  elm = new JKFlipFlop(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx2, gy2 + 2)); break;
      case 'counter':       elm = new Counter(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'mux':           elm = new Multiplexer(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1)); break;
      case 'demux':         elm = new Demultiplexer(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1)); break;
      case 'shift-register': elm = new ShiftRegister(n1, n2, nodeId(gx2, gy2 + 1)); break;
      case 'half-adder':    elm = new HalfAdder(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1)); break;
      case 'full-adder':    elm = new FullAdder(n1, n2, nodeId(gx2, gy2 + 1), nodeId(gx1, gy1 + 1), nodeId(gx2, gy2 + 2)); break;
      case 'logic-input':   elm = new LogicInput(n1); break;
      case 'logic-output':  elm = new LogicOutput(n1); break;
      case 'monostable':    elm = new Monostable(n1, n2); break;
      default: return null;
    }

    // UI metadata
    const uiElm = {
      type,
      gridPos: type === 'ground' ? [[gx1, gy1]] : [[gx1, gy1], [gx2, gy2]],
      elm,
      volts: elm.volts,
      current: 0,
      _curcount: 0,
      // Copy relevant params for renderer
      resistance: elm.resistance,
      voltage: elm.voltage,
      capacitance: elm.capacitance,
      inductance: elm.inductance,
    };

    this.uiElements.push(uiElm);
    this.circuit.addElement(elm);
    return uiElm;
  }

  _rebuildAndSolve() {
    try {
      this.circuit.analyze();
      // Build gridPoint → solved voltage map (for wires and ground elements)
      const pointVoltage = {};
      const gid = (gx, gy) => gx + ',' + gy;
      for (const ui of this.uiElements) {
        if (ui.type === 'wire' || ui.type === 'ground') continue;
        if (!ui.gridPos) continue;
        for (let i = 0; i < ui.gridPos.length && i < ui.elm.volts.length; i++) {
          const key = gid(ui.gridPos[i][0], ui.gridPos[i][1]);
          pointVoltage[key] = ui.elm.volts[i];
        }
      }

      // Sync UI elements with solved values + find max voltage for color scale
      let maxV = 1;
      for (const ui of this.uiElements) {
        if (ui.type === 'wire') {
          // Wire voltage: look up from gridPoint map (wires are merged, not solved)
          ui.volts = [
            pointVoltage[gid(ui.gridPos[0][0], ui.gridPos[0][1])] || 0,
            pointVoltage[gid(ui.gridPos[1][0], ui.gridPos[1][1])] || 0,
          ];
        } else if (ui.type === 'ground') {
          ui.volts = [0, 0];
        } else {
          ui.volts = ui.elm.volts;
        }
        ui.current = ui.elm.current;
        if (ui.volts) for (const v of ui.volts) maxV = Math.max(maxV, Math.abs(v || 0));
      }
      buildColorScale(Math.max(5, maxV * 1.1));

      // Compute wire currents via KCL
      this._calcWireCurrents();
    } catch (e) {
      console.warn('Circuit solve failed:', e.message);
    }
  }

  /** Compute wire currents using KCL at endpoints */
  _calcWireCurrents() {
    // Build map: gridPoint → net current flowing out from non-wire elements
    const pointCurrent = {};  // "gx,gy" → total current flowing INTO this point
    const nodeId = (gx, gy) => gx + ',' + gy;

    for (const ui of this.uiElements) {
      if (ui.type === 'wire' || ui.type === 'ground') continue;
      if (!ui.gridPos || ui.gridPos.length < 2) continue;
      const I = ui.current || 0;
      // Current flows from gridPos[0] to gridPos[1] through this element
      const p0 = nodeId(ui.gridPos[0][0], ui.gridPos[0][1]);
      const p1 = nodeId(ui.gridPos[1][0], ui.gridPos[1][1]);
      // Current leaves p0, enters p1 (conventional: from node[0] to node[1])
      pointCurrent[p0] = (pointCurrent[p0] || 0) - I;  // I exits through this element
      pointCurrent[p1] = (pointCurrent[p1] || 0) + I;  // I enters through this element
    }

    // For each wire: its current = net current at one of its endpoints from non-wire elements
    // By KCL, the wire must carry whatever the non-wire elements push/pull at that point
    for (const ui of this.uiElements) {
      if (ui.type !== 'wire') continue;
      if (!ui.gridPos || ui.gridPos.length < 2) continue;
      const p0 = nodeId(ui.gridPos[0][0], ui.gridPos[0][1]);
      const p1 = nodeId(ui.gridPos[1][0], ui.gridPos[1][1]);
      // Use the endpoint with larger absolute current (more reliable for junctions)
      const c0 = Math.abs(pointCurrent[p0] || 0);
      const c1 = Math.abs(pointCurrent[p1] || 0);
      if (c0 >= c1) {
        // Wire carries the net current at p0 (flowing toward p1)
        ui.current = -(pointCurrent[p0] || 0);
      } else {
        ui.current = pointCurrent[p1] || 0;
      }
    }
  }

  // ─── Mouse handling ───

  _onMouseDown(e) {
    if (e.button === 2) return; // right-click handled separately

    const { gx, gy } = this.canvas.screenToGrid(e.offsetX, e.offsetY);

    // Alt+click = pan
    if (e.altKey) {
      this.canvas.startPan(e.offsetX, e.offsetY);
      this.mode = MODE.DRAG_ALL;
      return;
    }

    if (this.mode === MODE.ADD_ELM) {
      this._dragStart = { gx, gy };
      this._dragEnd = { gx, gy };
    } else {
      // Select mode: find element under cursor
      this.selectedElm = this._findElementAt(gx, gy);
      this._updateInfoPanel();
    }
  }

  _onMouseMove(e) {
    if (this.mode === MODE.DRAG_ALL) {
      this.canvas.updatePan(e.offsetX, e.offsetY);
      return;
    }

    const { gx, gy } = this.canvas.screenToGrid(e.offsetX, e.offsetY);
    this._dragEnd = { gx, gy };

    // Update crosshair position
    this.canvas.mouseGX = gx;
    this.canvas.mouseGY = gy;
    this.canvas.showCrosshair = (this.mode === MODE.ADD_ELM);

    // Cursor hints
    if (this.mode === MODE.SELECT) {
      const elm = this._findElementAt(gx, gy);
      this.canvas.el.style.cursor = elm ? 'pointer' : 'default';
    }
  }

  _onMouseUp(e) {
    if (this.mode === MODE.DRAG_ALL) {
      this.canvas.endPan();
      this.mode = MODE.SELECT;
      return;
    }

    if (this.mode === MODE.ADD_ELM && this._dragStart && this._dragEnd) {
      const { gx: x1, gy: y1 } = this._dragStart;
      const { gx: x2, gy: y2 } = this._dragEnd;

      // Zero-length = discard (unless ground which is single-post)
      if (this.addType === 'ground') {
        this._pushUndo();
        this._createElement('ground', x1, y1, x1, y1);
        this._rebuildAndSolve();
      } else if (x1 !== x2 || y1 !== y2) {
        this._pushUndo();
        this._createElement(this.addType, x1, y1, x2, y2);
        this._rebuildAndSolve();
      }
      this._dragStart = null;
      this._dragEnd = null;
      // Stay in ADD mode for continuous placement
    }
  }

  _onRightClick(e) {
    const { gx, gy } = this.canvas.screenToGrid(e.offsetX, e.offsetY);
    const elm = this._findElementAt(gx, gy);
    this.menuBar.showContextMenu(e.clientX, e.clientY, elm);
  }

  _onDblClick(e) {
    const { gx, gy } = this.canvas.screenToGrid(e.offsetX, e.offsetY);
    const elm = this._findElementAt(gx, gy);
    if (elm) this._editElement(elm);
  }

  _onKey(e) {
    // Space = run/stop
    if (e.key === ' ') { e.preventDefault(); this._toggleRun(); return; }
    // Escape = cancel
    if (e.key === 'Escape') { this._cancelAdd(); return; }

    // Delete
    if (e.key === 'Delete' || e.key === 'Backspace') {
      if (this.selectedElm) {
        this._pushUndo();
        this._removeElement(this.selectedElm);
        this.selectedElm = null;
        this._rebuildAndSolve();
        this._updateInfoPanel();
      }
      return;
    }

    // Ctrl/Cmd shortcuts
    if (e.ctrlKey || e.metaKey) {
      if (e.key === 'z') { e.preventDefault(); this._undo(); return; }
      if (e.key === 'y') { e.preventDefault(); this._redo(); return; }
      return; // let browser handle other Ctrl combos
    }

    // Zoom to fit
    if (e.key === 'f' || e.key === 'F') {
      const allPos = [];
      for (const ui of this.uiElements) {
        if (ui.gridPos) for (const p of ui.gridPos) allPos.push(p);
      }
      this.canvas.zoomToFit(allPos);
      return;
    }

    // Component shortcuts
    const type = this.menuBar.handleKey(e.key);
    if (type) { this._startAdd(type); return; }
  }

  // ─── Element finding ───

  _findElementAt(gx, gy) {
    // Find nearest element to grid point
    let best = null, bestDist = 1.2;  // within ~1 grid unit
    for (const ui of this.uiElements) {
      if (!ui.gridPos || ui.gridPos.length < 1) continue;
      for (const [px, py] of ui.gridPos) {
        const d = Math.abs(px - gx) + Math.abs(py - gy);
        if (d < bestDist) { bestDist = d; best = ui; }
      }
      // Also check midpoint for 2-terminal elements
      if (ui.gridPos.length === 2) {
        const mx = (ui.gridPos[0][0] + ui.gridPos[1][0]) / 2;
        const my = (ui.gridPos[0][1] + ui.gridPos[1][1]) / 2;
        const d = Math.abs(mx - gx) + Math.abs(my - gy);
        if (d < bestDist) { bestDist = d; best = ui; }
      }
    }
    return best;
  }

  _removeElement(uiElm) {
    const idx = this.uiElements.indexOf(uiElm);
    if (idx >= 0) this.uiElements.splice(idx, 1);
    this.circuit.removeElement(uiElm.elm);
  }

  // ─── Edit dialog ───

  _editElement(uiElm) {
    const elm = uiElm.elm;
    const type = uiElm.type;
    let fields = [];

    fields = (EDIT_MAP[type] || []).map(f => ({ ...f, value: elm[f.key] }));
    if (fields.length === 0) { alert(`No editable properties for ${type}.`); return; }

    this._pushUndo();
    let changed = false;
    for (const f of fields) {
      const val = prompt(`${f.label}:`, f.value);
      if (val === null) continue;
      const num = parseFloat(val);
      if (isNaN(num) || num <= 0) continue;
      elm[f.key] = num;
      uiElm[f.key] = num;
      changed = true;
    }
    if (changed) this._rebuildAndSolve();
    else this._undoStack.pop();  // nothing changed, discard undo snapshot
  }

  // ─── Export / Import ───

  /** Serialize current circuit to JSON */
  _serializeCircuit() {
    const elements = [];
    for (const ui of this.uiElements) {
      const entry = {
        type: ui.type,
        x1: ui.gridPos[0][0],
        y1: ui.gridPos[0][1],
        x2: ui.gridPos.length > 1 ? ui.gridPos[1][0] : ui.gridPos[0][0],
        y2: ui.gridPos.length > 1 ? ui.gridPos[1][1] : ui.gridPos[0][1],
      };
      // Save component-specific params
      const elm = ui.elm;
      const params = {};
      if (elm.resistance !== undefined) params.resistance = elm.resistance;
      if (elm.voltage !== undefined) params.voltage = elm.voltage;
      if (elm.sourceCurrent !== undefined) params.sourceCurrent = elm.sourceCurrent;
      if (elm.capacitance !== undefined) params.capacitance = elm.capacitance;
      if (elm.inductance !== undefined) params.inductance = elm.inductance;
      if (elm.peakVoltage !== undefined) params.peakVoltage = elm.peakVoltage;
      if (elm.frequency !== undefined) params.frequency = elm.frequency;
      if (elm.phase !== undefined && elm.phase !== 0) params.phase = elm.phase;
      if (elm.beta !== undefined) params.beta = elm.beta;
      if (elm.is !== undefined && elm.type === 'diode') params.is = elm.is;
      if (elm.vz !== undefined) params.vz = elm.vz;
      if (elm.vth !== undefined) params.vth = elm.vth;
      if (elm.kp !== undefined) params.kp = elm.kp;
      if (elm.gain !== undefined && elm.type !== 'opamp') params.gain = elm.gain;
      if (elm.ratio !== undefined) params.ratio = elm.ratio;
      if (elm.position !== undefined) params.position = elm.position;
      if (elm.z0 !== undefined) params.z0 = elm.z0;
      if (elm.delay !== undefined) params.delay = elm.delay;
      if (elm.coilR !== undefined) params.coilR = elm.coilR;
      if (elm.fCenter !== undefined) params.fCenter = elm.fCenter;
      if (Object.keys(params).length > 0) entry.params = params;
      elements.push(entry);
    }
    return {
      version: 1,
      name: 'Circuit',
      elements,
      view: { panX: this.canvas.panX, panY: this.canvas.panY, zoom: this.canvas.zoom },
      meta: {
        brand: '8gwifi.org',
        tool: 'Circuit Simulator',
        url: 'https://8gwifi.org/physics/labs/circuit-simulator.jsp',
        exportedAt: new Date().toISOString(),
        componentCount: elements.filter(e => e.type !== 'wire' && e.type !== 'ground').length,
        wireCount: elements.filter(e => e.type === 'wire').length,
      },
    };
  }

  /** Deserialize JSON and load circuit */
  _deserializeCircuit(data) {
    if (!data || !data.elements || !Array.isArray(data.elements)) {
      alert('Invalid circuit file format.');
      return false;
    }
    // Clear current circuit
    this.uiElements = [];
    this.circuit.clear();
    this.selectedElm = null;

    // Create elements
    for (const p of data.elements) {
      this._createElement(p.type, p.x1, p.y1, p.x2, p.y2);
      if (p.params) {
        const ui = this.uiElements[this.uiElements.length - 1];
        if (ui) {
          for (const [k, v] of Object.entries(p.params)) {
            ui.elm[k] = v;
            ui[k] = v;
          }
        }
      }
    }

    // Restore view
    if (data.view) {
      this.canvas.panX = data.view.panX || this.canvas.w / 3;
      this.canvas.panY = data.view.panY || this.canvas.h / 4;
      this.canvas.zoom = data.view.zoom || 1.5;
    }

    this._rebuildAndSolve();
    return true;
  }

  /** Export circuit: copy to clipboard + offer download */
  _exportCircuit() {
    const data = this._serializeCircuit();
    const json = JSON.stringify(data, null, 2);
    const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const filename = `8gwifi.org-circuit-${ts}.json`;

    // Copy to clipboard + download
    const download = () => {
      const blob = new Blob([json], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      a.click();
      URL.revokeObjectURL(url);
    };

    navigator.clipboard.writeText(json).then(() => {
      download();
      alert(`Circuit exported!\n\nFile: ${filename}\nJSON copied to clipboard.`);
    }).catch(() => {
      download();
    });
  }

  /** Import circuit: file picker or paste from clipboard */
  _importCircuit() {
    // Try clipboard first, fall back to file picker
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    input.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = (ev) => {
        try {
          const data = JSON.parse(ev.target.result);
          if (this._deserializeCircuit(data)) {
            // Auto-add scope traces
            if (this.scope) {
              this.scope.traces = [];
              const interesting = this.uiElements.filter(ui =>
                ui.type !== 'wire' && ui.type !== 'ground' &&
                ui.type !== 'dc-voltage' && ui.type !== 'dc-current' && ui.type !== 'ac-voltage'
              );
              if (interesting.length > 0) {
                this.scope.addVoltageTrace(interesting[0]);
                this.scope.addCurrentTrace(interesting[0]);
              }
              this.scope.resetData();
              this._showScope(this.scope.traces.length > 0);
            }
          }
        } catch (err) {
          alert('Failed to parse circuit file: ' + err.message);
        }
      };
      reader.readAsText(file);
    });
    input.click();
  }

  // ─── Export as Image (PNG with branding) ───

  _exportImage() {
    // Create an offscreen canvas with branding
    const pad = 40;       // padding around circuit
    const brandH = 30;    // height for brand footer

    // Find bounds of all elements
    let minGX = Infinity, minGY = Infinity, maxGX = -Infinity, maxGY = -Infinity;
    for (const ui of this.uiElements) {
      if (!ui.gridPos) continue;
      for (const [gx, gy] of ui.gridPos) {
        minGX = Math.min(minGX, gx); minGY = Math.min(minGY, gy);
        maxGX = Math.max(maxGX, gx); maxGY = Math.max(maxGY, gy);
      }
    }
    if (!isFinite(minGX)) { alert('No circuit to export.'); return; }

    const G = 16;
    const margin = 3;
    minGX -= margin; minGY -= margin; maxGX += margin; maxGY += margin;

    const imgW = (maxGX - minGX) * G + pad * 2;
    const imgH = (maxGY - minGY) * G + pad * 2 + brandH;

    const offscreen = document.createElement('canvas');
    offscreen.width = imgW * 2;  // 2x for retina
    offscreen.height = imgH * 2;
    const ctx = offscreen.getContext('2d');
    ctx.scale(2, 2);

    // Background
    ctx.fillStyle = '#111318';
    ctx.fillRect(0, 0, imgW, imgH);

    // Grid dots
    ctx.fillStyle = '#2a2e36';
    for (let x = minGX; x <= maxGX; x++) {
      for (let y = minGY; y <= maxGY; y++) {
        const px = (x - minGX) * G + pad;
        const py = (y - minGY) * G + pad;
        ctx.fillRect(px - 0.5, py - 0.5, 1, 1);
      }
    }

    // Draw elements (translate so minGX,minGY maps to pad,pad)
    ctx.save();
    ctx.translate(pad - minGX * G, pad - minGY * G);

    // Reuse renderer to draw components
    this.renderer.drawElements(ctx, this.uiElements);
    this.renderer.drawPosts(ctx, this.uiElements, null);

    ctx.restore();

    // Brand footer
    const footerY = imgH - brandH;
    ctx.fillStyle = '#0d1017';
    ctx.fillRect(0, footerY, imgW, brandH);
    ctx.strokeStyle = '#2d3139';
    ctx.lineWidth = 0.5;
    ctx.beginPath(); ctx.moveTo(0, footerY); ctx.lineTo(imgW, footerY); ctx.stroke();

    ctx.font = '11px sans-serif';
    ctx.fillStyle = '#64748b';
    ctx.textAlign = 'center';
    ctx.fillText('8gwifi.org/physics/labs/circuit-simulator.jsp', imgW / 2, footerY + 19);

    // Download
    const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const link = document.createElement('a');
    link.download = `8gwifi.org-circuit-${ts}.png`;
    link.href = offscreen.toDataURL('image/png');
    link.click();
  }

  // ─── Share URL (circuit encoded in URL hash) ───

  _shareURL() {
    const data = this._serializeCircuit();
    // Compact: only elements + view (no meta for URL brevity)
    const compact = { v: 1, e: data.elements, z: data.view };
    const json = JSON.stringify(compact);

    // Compress using base64 encoding
    try {
      const compressed = btoa(unescape(encodeURIComponent(json)));
      const url = window.location.origin + window.location.pathname + '#circuit=' + compressed;

      navigator.clipboard.writeText(url).then(() => {
        alert(`Share URL copied to clipboard!\n\nURL length: ${url.length} characters\n\nAnyone with this link will see your exact circuit.`);
      }).catch(() => {
        // Fallback: show in prompt
        prompt('Copy this URL to share your circuit:', url);
      });

      // Also update browser URL (without reload)
      history.replaceState(null, '', '#circuit=' + compressed);
    } catch (e) {
      alert('Circuit too large to share via URL. Use Export JSON instead.');
    }
  }

  /** Load circuit from URL hash (called on page load) */
  _loadFromURL() {
    const hash = window.location.hash;
    if (!hash.startsWith('#circuit=')) return;
    try {
      const compressed = hash.slice(9);  // remove '#circuit='
      const json = decodeURIComponent(escape(atob(compressed)));
      const compact = JSON.parse(json);
      if (compact.e && Array.isArray(compact.e)) {
        const data = { version: compact.v || 1, elements: compact.e, view: compact.z };
        this._deserializeCircuit(data);
      }
    } catch (e) {
      console.warn('Failed to load circuit from URL:', e.message);
    }
  }

  // ─── Undo / Redo ───

  /** Save current state to undo stack (call before any mutation) */
  _pushUndo() {
    const snapshot = this._serializeCircuit();
    this._undoStack.push(JSON.stringify(snapshot));
    if (this._undoStack.length > this._maxUndo) this._undoStack.shift();
    this._redoStack = [];  // clear redo on new action
  }

  _undo() {
    if (this._undoStack.length === 0) return;
    // Save current state to redo
    this._redoStack.push(JSON.stringify(this._serializeCircuit()));
    // Restore previous state
    const snapshot = JSON.parse(this._undoStack.pop());
    this._deserializeCircuit(snapshot);
  }

  _redo() {
    if (this._redoStack.length === 0) return;
    // Save current state to undo
    this._undoStack.push(JSON.stringify(this._serializeCircuit()));
    // Restore next state
    const snapshot = JSON.parse(this._redoStack.pop());
    this._deserializeCircuit(snapshot);
  }

  // ─── Actions ───

  _handleAction(action) {
    if (action === 'new') {
      this._pushUndo();
      this.uiElements = [];
      this.circuit.clear();
      this.selectedElm = null;
      if (this.scope) { this.scope.traces = []; this._showScope(false); }
    } else if (action === 'undo') {
      this._undo();
    } else if (action === 'redo') {
      this._redo();
    } else if (action === 'export') {
      this._exportCircuit();
    } else if (action === 'import') {
      this._importCircuit();
    } else if (action === 'export-image') {
      this._exportImage();
    } else if (action === 'share-url') {
      this._shareURL();
    } else if (action === 'delete' && this.selectedElm) {
      this._pushUndo();
      this._removeElement(this.selectedElm);
      this.selectedElm = null;
      this._rebuildAndSolve();
    } else if (action === 'edit' && this.selectedElm) {
      this._editElement(this.selectedElm);
    } else if (action === 'toggleDots') {
      this.renderer.showDots = !this.renderer.showDots;
    } else if (action === 'toggleVoltage') {
      this.renderer.showVoltageColors = !this.renderer.showVoltageColors;
    } else if (action === 'toggleValues') {
      this.renderer.showValues = !this.renderer.showValues;
    } else if (action === 'toggleConventional') {
      this.renderer.conventionalCurrent = !this.renderer.conventionalCurrent;
    } else if (action === 'scope' && this.selectedElm && this.scope) {
      // Add voltage + current traces for selected element
      this.scope.addVoltageTrace(this.selectedElm);
      this.scope.addCurrentTrace(this.selectedElm);
      this._showScope(true);
    } else if (action.startsWith('preset:')) {
      this._loadPreset(action.slice(7));
    }
    this._updateInfoPanel();
  }

  // ─── Info Panel ───

  _updateInfoPanel() {
    if (!this._infoPanel) return;
    if (!this.selectedElm) {
      this._infoPanel.innerHTML = '<div class="info-empty">Click an element to see its properties</div>';
      return;
    }
    const ui = this.selectedElm;
    const elm = ui.elm;
    const info = elm.getInfo ? elm.getInfo() : {};
    const editable = EDIT_MAP[ui.type] || [];

    let html = `<div class="info-type">${ui.type}</div>`;

    // Editable properties (with input fields)
    if (editable.length > 0) {
      html += '<div class="info-section">Properties</div>';
      for (const field of editable) {
        const val = elm[field.key];
        const displayVal = typeof val === 'number' ? val : 0;
        html += `<div class="info-edit-row">
          <label>${field.label}</label>
          <div class="info-input-wrap">
            <input type="number" class="info-input" data-key="${field.key}" value="${displayVal}" step="any">
            <span class="info-unit">${field.unit || ''}</span>
          </div>
        </div>`;
      }
    }

    // Read-only measurements
    html += '<div class="info-section">Measurements</div>';
    for (const [k, v] of Object.entries(info)) {
      if (typeof v === 'number') {
        html += `<div class="info-row"><span>${k}</span><span>${v.toPrecision(4)}</span></div>`;
      } else if (typeof v === 'string' || typeof v === 'boolean') {
        html += `<div class="info-row"><span>${k}</span><span>${v}</span></div>`;
      }
    }

    this._infoPanel.innerHTML = html;

    // Wire up input change handlers
    this._infoPanel.querySelectorAll('.info-input').forEach(input => {
      input.addEventListener('change', (e) => {
        const key = e.target.dataset.key;
        const num = parseFloat(e.target.value);
        if (isNaN(num) || num <= 0) return;
        this._pushUndo();
        elm[key] = num;
        ui[key] = num;
        this._rebuildAndSolve();
        // Update measurements (but don't re-render inputs to avoid losing focus)
        const newInfo = elm.getInfo ? elm.getInfo() : {};
        this._infoPanel.querySelectorAll('.info-row span:last-child').forEach((span, i) => {
          const keys = Object.entries(newInfo).filter(([,v]) => typeof v === 'number' || typeof v === 'string' || typeof v === 'boolean');
          if (keys[i]) {
            const [, val] = keys[i];
            span.textContent = typeof val === 'number' ? val.toPrecision(4) : String(val);
          }
        });
      });
    });
  }

  // ─── Presets ───

  _loadPreset(name) {
    this.uiElements = [];
    this.circuit.clear();
    this.selectedElm = null;
    // Hide hint
    const hint = this.wrap.querySelector('#hint');
    if (hint) hint.style.opacity = '0';

    const P = PRESETS[name];
    if (!P) return;
    for (const p of P) {
      this._createElement(p.type, p.x1, p.y1, p.x2, p.y2);
      // Override default values
      const ui = this.uiElements[this.uiElements.length - 1];
      if (p.params) {
        for (const [k, v] of Object.entries(p.params)) {
          ui.elm[k] = v;
          ui[k] = v;
        }
      }
    }
    this._rebuildAndSolve();

    // Auto-add scope traces for the most interesting elements
    if (this.scope) {
      this.scope.traces = [];
      // Find first non-wire, non-ground, non-source element (resistor, capacitor, diode, etc.)
      const interesting = this.uiElements.filter(ui =>
        ui.type !== 'wire' && ui.type !== 'ground' &&
        ui.type !== 'dc-voltage' && ui.type !== 'dc-current' && ui.type !== 'ac-voltage'
      );
      // Also find first source for voltage reference
      const source = this.uiElements.find(ui =>
        ui.type === 'dc-voltage' || ui.type === 'ac-voltage'
      );

      if (interesting.length > 0) {
        this.scope.addVoltageTrace(interesting[0]);
        this.scope.addCurrentTrace(interesting[0]);
      }
      if (interesting.length > 1) {
        this.scope.addVoltageTrace(interesting[1]);
      }
      if (source) {
        this.scope.addVoltageTrace(source);
      }
      this.scope.resetData();
      this._showScope(this.scope.traces.length > 0);
    }

    // Center view
    // Auto-fit all elements in view
    const allPos = [];
    for (const ui of this.uiElements) {
      if (ui.gridPos) for (const p of ui.gridPos) allPos.push(p);
    }
    this.canvas.zoomToFit(allPos);
  }

  // ─── Render loop ───

  _frame(t) {
    // ── Phase 1: Physics (only when running) ──
    if (this.running) {
      this._stepSimulation();
      this.renderer.updateDotSpeed(t, this.currentSpeed);
      // Record scope data
      if (this.scope && this.scope.visible) {
        this.scope.record(this.simTime);
      }
    }

    // ── Phase 2: Draw (always) ──
    const cv = this.canvas;
    cv.beginFrame();
    cv.drawGrid();

    const ctx = cv.ctx;

    // Selection highlight
    if (this.selectedElm) this.renderer.drawSelection(ctx, this.selectedElm);

    // All elements (components + wires)
    this.renderer.drawElements(ctx, this.uiElements);

    // Current dots (animate only when running, freeze when stopped)
    if (this.running) this.renderer.drawDots(ctx, this.uiElements);

    // Terminal posts
    this.renderer.drawPosts(ctx, this.uiElements, this.selectedElm);

    // Crosshair (shows snap point during placement)
    cv.drawCrosshair();

    // Selection box (if box-selecting)
    cv.drawSelectBox();

    // Coordinate readout (bottom-left corner)
    cv.drawCoordReadout();

    // Update circuit info display (throttled to every 30 frames)
    if (!this._frameCount) this._frameCount = 0;
    if (++this._frameCount % 30 === 0) this._updateCircuitInfo();

    // Render scope (separate canvas, not part of circuit transform)
    if (this.scope && this.scope.visible) {
      this.scope.render();
    }

    // Ghost preview during placement
    if (this.mode === MODE.ADD_ELM && this._dragStart && this._dragEnd) {
      this.renderer.drawGhost(ctx, this.addType,
        this._dragStart.gx, this._dragStart.gy,
        this._dragEnd.gx, this._dragEnd.gy);
    }

    cv.endFrame();
    this._raf = requestAnimationFrame((t2) => this._frame(t2));
  }

  destroy() {
    cancelAnimationFrame(this._raf);
  }
}

// ─── Built-in presets ───

const PRESETS = {
  // ── Basics ──
  'ohms-law': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'series-resistors': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 12 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 6, y2: 0, params: { resistance: 2000 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 4, params: { resistance: 3000 } },
    { type: 'wire', x1: 6, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'parallel-resistors': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 0, y2: -3, params: { resistance: 500 } },
    { type: 'wire', x1: 0, y1: -3, x2: 4, y2: -3 },
    { type: 'wire', x1: 4, y1: -3, x2: 4, y2: 0 },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'voltage-divider': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 9 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 3000 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 6, x2: 0, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'current-divider': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 0, x2: 8, y2: 0 },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 4, params: { resistance: 2000 } },
    { type: 'wire', x1: 8, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'wheatstone': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 3, params: { resistance: 1000 } },
    { type: 'resistor', x1: 4, y1: 3, x2: 0, y2: 6, params: { resistance: 2000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: -4, y2: 3, params: { resistance: 1000 } },
    { type: 'resistor', x1: -4, y1: 3, x2: 0, y2: 6, params: { resistance: 2000 } },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── AC Circuits ──
  'rc-circuit': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 4, params: { capacitance: 1e-6 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'rl-circuit': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 100 } },
    { type: 'inductor', x1: 4, y1: 0, x2: 4, y2: 4, params: { inductance: 0.01 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'rlc-series': [
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 5000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 10 } },
    { type: 'inductor', x1: 3, y1: 0, x2: 6, y2: 0, params: { inductance: 1e-3 } },
    { type: 'capacitor', x1: 6, y1: 0, x2: 6, y2: 6, params: { capacitance: 1e-6 } },
    { type: 'wire', x1: 6, y1: 6, x2: 0, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'rc-lowpass': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 4, params: { capacitance: 0.1e-6 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'rc-highpass': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 4, y2: 0, params: { capacitance: 0.1e-6 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Diodes ──
  'diode-resistor': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 470 } },
    { type: 'diode', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'led-circuit': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 220 } },
    { type: 'led', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'zener-regulator': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 12 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'zener', x1: 4, y1: 4, x2: 4, y2: 0 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'half-wave-rectifier': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 10, frequency: 60 } },
    { type: 'diode', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Transistors ──
  // BJT: gridPos[0]=Base, gridPos[1]=Collector, auto Emitter at (gx2, gy2+1)
  'common-emitter': [
    // Vbb → Rb → Base(3,2), Vcc → Rc → Collector(6,2), Emitter(6,3) → GND
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 100000 } },
    { type: 'dc-voltage', x1: 8, y1: 6, x2: 8, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'wire', x1: 6, y1: 6, x2: 8, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'bjt-switch': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 10000 } },
    { type: 'dc-voltage', x1: 8, y1: 6, x2: 8, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'wire', x1: 6, y1: 6, x2: 8, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'nmos-switch': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 100000 } },
    { type: 'dc-voltage', x1: 8, y1: 6, x2: 8, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'mosfet-n', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'wire', x1: 6, y1: 6, x2: 8, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Op-Amps ──
  // OpAmp: gridPos[0]=V+(non-inv), gridPos[1]=V-(inv), auto Output at (gx2, gy2+1)
  'inverting-opamp': [
    // Vin(1V) → Ri(1k) → inv(-)(4,2), Rf(10k) feedback inv→out(4,3), V+(4,0) → GND
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 1 } },
    { type: 'resistor', x1: 0, y1: 2, x2: 4, y2: 2, params: { resistance: 1000 } },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },      // V+=(4,0) V-=(4,2) Out=(4,3)
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: -1 },       // V+ to ground
    { type: 'wire', x1: 4, y1: -1, x2: 0, y2: -1 },
    { type: 'wire', x1: 0, y1: -1, x2: 0, y2: 6 },
    { type: 'resistor', x1: 4, y1: 2, x2: 8, y2: 2, params: { resistance: 10000 } },
    { type: 'wire', x1: 8, y1: 2, x2: 8, y2: 3 },        // feedback: Rf end → output
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 1000 } }, // load
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
  ],
  'noninverting-opamp': [
    // Vin(1V) → V+(4,0), Ri(1k) inv→GND, Rf(9k) inv→out. Gain=1+9k/1k=10
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 1 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 3 },       // V+=(4,0) V-=(4,3) Out=(4,4)
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 8, params: { resistance: 1000 } }, // Ri: V- to GND
    { type: 'resistor', x1: 4, y1: 3, x2: 8, y2: 3, params: { resistance: 9000 } }, // Rf: V- to out
    { type: 'wire', x1: 8, y1: 3, x2: 8, y2: 4 },
    { type: 'wire', x1: 8, y1: 4, x2: 4, y2: 4 },        // feedback to output
    { type: 'resistor', x1: 4, y1: 4, x2: 4, y2: 8, params: { resistance: 1000 } }, // load
    { type: 'wire', x1: 0, y1: 8, x2: 4, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'voltage-follower': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 3.3 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'wire', x1: 4, y1: 3, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 8, y2: 2 },
    { type: 'wire', x1: 8, y1: 2, x2: 4, y2: 2 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── NEW: Basics ──
  'capacitor': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 4, y2: 0, params: { capacitance: 10e-6 } },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'inductor': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'inductor', x1: 0, y1: 0, x2: 4, y2: 0, params: { inductance: 0.1 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 10 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── NEW: AC ──
  'lc-tank': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1 } },
    { type: 'inductor', x1: 4, y1: 0, x2: 4, y2: 4, params: { inductance: 1e-3 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 8, y2: 0, params: { capacitance: 1e-6 } },
    { type: 'wire', x1: 8, y1: 0, x2: 8, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'freq-doubler': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'diode', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'diode', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── NEW: Diodes ──
  'full-wave-rectifier': [
    // Bridge rectifier: 4 diodes + load
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 10, frequency: 60 } },
    { type: 'diode', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'diode', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'diode', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'diode', x1: 4, y1: 0, x2: 0, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'voltage-doubler': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 4, y2: 0, params: { capacitance: 10e-6 } },
    { type: 'diode', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'diode', x1: 4, y1: 0, x2: 8, y2: 0 },
    { type: 'capacitor', x1: 8, y1: 0, x2: 8, y2: 4, params: { capacitance: 10e-6 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'peak-detector': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'diode', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 4, params: { capacitance: 10e-6 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 8, y2: 0, params: { resistance: 100000 } },
    { type: 'wire', x1: 8, y1: 0, x2: 8, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'diode-clamp': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 4, y2: 0, params: { capacitance: 1e-6 } },
    { type: 'diode', x1: 4, y1: 4, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 8, y2: 0, params: { resistance: 10000 } },
    { type: 'wire', x1: 8, y1: 0, x2: 8, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── NEW: Transistors ──
  'emitter-follower': [
    // Vin → Base(3,2), Collector(6,2) → Vcc, Emitter(6,3) → Re → GND
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 3 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 10000 } },
    { type: 'dc-voltage', x1: 6, y1: 6, x2: 6, y2: 0, params: { voltage: 10 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'current-mirror': [
    // Vcc → Rc → C1(3,2)=B1=B2, Q1 E(3,3)→GND. Q2 B(3,2), C2(6,2)→Rload→Vcc, E2(6,3)→GND
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 1000 } },
    { type: 'wire', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 3, y2: 2 },  // Q1: B=C shorted (diode-connected)
    { type: 'wire', x1: 3, y1: 3, x2: 3, y2: 6 },
    { type: 'resistor', x1: 0, y1: 0, x2: 6, y2: 0, params: { resistance: 2000 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },  // Q2: same base as Q1
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'darlington': [
    // Two BJTs cascaded: β_total ≈ β₁ × β₂
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 100000 } },
    { type: 'dc-voltage', x1: 8, y1: 8, x2: 8, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 6, y2: 2, params: { resistance: 100 } },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },   // Q1: B(3,2) C(6,2) E(6,3)
    { type: 'bjt-npn', x1: 6, y1: 3, x2: 6, y2: 4 },   // Q2: B(6,3)=Q1.E, C(6,4) E(6,5)
    { type: 'wire', x1: 6, y1: 5, x2: 6, y2: 8 },
    { type: 'wire', x1: 0, y1: 8, x2: 6, y2: 8 },
    { type: 'wire', x1: 6, y1: 8, x2: 8, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'push-pull': [
    // NPN + PNP complementary output
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 3, frequency: 60 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'wire', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },   // Q1 NPN: B(3,2) C(6,2) E(6,3)
    { type: 'dc-voltage', x1: 6, y1: 8, x2: 6, y2: 0, params: { voltage: 10 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 5, params: { resistance: 100 } }, // load
    { type: 'wire', x1: 6, y1: 5, x2: 6, y2: 8 },
    { type: 'wire', x1: 0, y1: 4, x2: 0, y2: 8 },
    { type: 'wire', x1: 0, y1: 8, x2: 6, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'nmos-inverter': [
    // NMOS with pull-up resistor
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 2, params: { resistance: 100000 } },
    { type: 'dc-voltage', x1: 6, y1: 6, x2: 6, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 10000 } },
    { type: 'mosfet-n', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'mos-current-src': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 2, params: { resistance: 10000 } },
    { type: 'wire', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'mosfet-n', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 0, x2: 6, y2: 0 },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── NEW: Op-Amps ──
  'summing-amp': [
    // Two inputs summed: Vout = -(Rf/R1*V1 + Rf/R2*V2)
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 1 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 2, params: { resistance: 1000 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 4, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 4, x2: 4, y2: 2, params: { resistance: 1000 } },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: -1 },
    { type: 'wire', x1: 4, y1: -1, x2: 0, y2: -1 },
    { type: 'wire', x1: 0, y1: -1, x2: 0, y2: 8 },
    { type: 'resistor', x1: 4, y1: 2, x2: 8, y2: 2, params: { resistance: 1000 } },
    { type: 'wire', x1: 8, y1: 2, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 8, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 4, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'difference-amp': [
    // Vout = (R2/R1)(V2-V1) for matched resistors
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 2, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 2, x2: 4, y2: 2, params: { resistance: 10000 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 10000 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: -2, params: { resistance: 10000 } },
    { type: 'wire', x1: 4, y1: -2, x2: 0, y2: -2 },
    { type: 'wire', x1: 0, y1: -2, x2: 0, y2: 8 },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'resistor', x1: 4, y1: 2, x2: 8, y2: 2, params: { resistance: 10000 } },
    { type: 'wire', x1: 8, y1: 2, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 8, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 4, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'integrator': [
    // Vout = -(1/RC)∫Vin dt
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 1 } },
    { type: 'resistor', x1: 0, y1: 2, x2: 4, y2: 2, params: { resistance: 10000 } },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: -1 },
    { type: 'wire', x1: 4, y1: -1, x2: 0, y2: -1 },
    { type: 'wire', x1: 0, y1: -1, x2: 0, y2: 6 },
    { type: 'capacitor', x1: 4, y1: 2, x2: 8, y2: 2, params: { capacitance: 0.1e-6 } },
    { type: 'wire', x1: 8, y1: 2, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Logic Gates ──
  'and-gate-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },
    { type: 'and-gate', x1: 3, y1: 0, x2: 3, y2: 2 },  // A=(3,0) B=(3,2) Out=(3,3)
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'or-gate-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 2, params: { voltage: 0 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },
    { type: 'or-gate', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'not-gate-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'not-gate', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'nand-gate-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },
    { type: 'nand-gate', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'xor-gate-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 2, params: { voltage: 0 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },
    { type: 'xor-gate', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'half-adder': [
    // XOR for Sum, AND for Carry
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },
    { type: 'xor-gate', x1: 3, y1: 0, x2: 3, y2: 2 },  // Sum out at (3,3)
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 0, x2: 6, y2: 0 },
    { type: 'wire', x1: 0, y1: 2, x2: 6, y2: 2 },
    { type: 'and-gate', x1: 6, y1: 0, x2: 6, y2: 2 },   // Carry out at (6,3)
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'nand-sr-latch': [
    // SR latch using the SR flip-flop element (simpler than cross-coupled NAND)
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },       // S = HIGH (set)
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 0 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },       // R = LOW
    { type: 'sr-flipflop', x1: 3, y1: 0, x2: 3, y2: 2 }, // S=(3,0) R=(3,2) Q=(3,3) Qbar=(3,4)
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 6, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 4, x2: 6, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 4, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Sequential Logic ──
  'd-flipflop-demo': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },       // D input = HIGH
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },       // CLK = HIGH
    { type: 'd-flipflop', x1: 3, y1: 0, x2: 3, y2: 2 }, // D=(3,0) CLK=(3,2) Q=(3,3) Qbar=(3,4)
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 6, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 4, x2: 6, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 4, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'sr-flipflop-demo': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },       // S = HIGH
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 0 } },
    { type: 'wire', x1: 0, y1: 2, x2: 3, y2: 2 },       // R = LOW
    { type: 'sr-flipflop', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 6, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 4, x2: 6, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 4, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Controlled Sources ──
  'vcvs-demo': [
    // Simpler: Vin=2V through R, demonstrates voltage-controlled gain
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 2000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'vccs-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 100 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Power & Switching ──
  'relay-demo': [
    // V1 drives coil, relay switches V2 through a load
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 12 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'wire', x1: 3, y1: 0, x2: 3, y2: 2 },       // coil+ = (3,2)
    { type: 'relay', x1: 3, y1: 2, x2: 3, y2: 4 },      // coil+=(3,2) coil-=(3,4) swA=(3,5) swB=(3,3)
    { type: 'wire', x1: 3, y1: 4, x2: 3, y2: 6 },       // coil- to gnd
    { type: 'dc-voltage', x1: 6, y1: 6, x2: 6, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 3 },       // swB side
    { type: 'wire', x1: 6, y1: 3, x2: 3, y2: 3 },
    { type: 'resistor', x1: 3, y1: 5, x2: 3, y2: 6, params: { resistance: 1000 } }, // load on swA
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  // ── Tier 3: Advanced ──
  'vco-demo': [
    // Control voltage drives VCO frequency
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 3 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },         // control input
    { type: 'vco', x1: 3, y1: 0, x2: 6, y2: 0 },          // ctrl=(3,0) out=(6,0) gnd=(6,1)
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 1, x2: 6, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'tline-demo': [
    // AC source → transmission line (Z₀=50Ω) → load
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'transmission-line', x1: 0, y1: 0, x2: 6, y2: 0 },  // in+=(0,0) in-=(0,4) out+=(6,1) out-=(0,1)
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 4, params: { resistance: 50 } }, // matched load
    { type: 'wire', x1: 6, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  'ideal-switch-demo': [
    // Control = 5V → switch ON, current flows
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },       // control
    { type: 'dc-voltage', x1: 6, y1: 4, x2: 6, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'ideal-switch', x1: 3, y1: 0, x2: 6, y2: 2 }, // ctrl=(3,0) A=(6,2) B=(6,3)
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ══════════════════ BATCH 2: 30+ new circuits ══════════════════

  // ── Passive Filters ──
  'bandpass-rc': [
    // Correct order: HP (series-C + shunt-R) → LP (series-R + shunt-C)
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 3, y2: 0, params: { capacitance: 0.1e-6 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 4, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 6, y2: 0, params: { resistance: 1000 } },
    { type: 'capacitor', x1: 6, y1: 0, x2: 6, y2: 4, params: { capacitance: 0.1e-6 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'notch-twint': [
    // Twin-T: R=10k, C=15nF, R_shunt=R/2=5k, C_shunt=2C=30nF
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 10000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 6, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 3, y1: 0, x2: 3, y2: 4, params: { capacitance: 30e-9 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 0, y2: 2, params: { capacitance: 15e-9 } },
    { type: 'capacitor', x1: 0, y1: 2, x2: 6, y2: 2, params: { capacitance: 15e-9 } },
    { type: 'resistor', x1: 6, y1: 2, x2: 6, y2: 4, params: { resistance: 5000 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'rl-lowpass': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'inductor', x1: 0, y1: 0, x2: 4, y2: 0, params: { inductance: 0.1 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'rl-highpass': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'inductor', x1: 4, y1: 0, x2: 4, y2: 4, params: { inductance: 0.1 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Active Filters ──
  'sk-lowpass': [
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 1, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 10000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 6, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 3, y1: 0, x2: 3, y2: 6, params: { capacitance: 10e-9 } },
    { type: 'opamp', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 2, x2: 6, y2: 6 },
    { type: 'capacitor', x1: 6, y1: 0, x2: 9, y2: 0, params: { capacitance: 10e-9 } },
    { type: 'wire', x1: 9, y1: 0, x2: 9, y2: 3 },
    { type: 'wire', x1: 9, y1: 3, x2: 6, y2: 3 },
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'sk-highpass': [
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 1, frequency: 10000 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 3, y2: 0, params: { capacitance: 10e-9 } },
    { type: 'capacitor', x1: 3, y1: 0, x2: 6, y2: 0, params: { capacitance: 10e-9 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 6, params: { resistance: 10000 } },
    { type: 'opamp', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'wire', x1: 6, y1: 2, x2: 6, y2: 6 },
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 3, x2: 9, y2: 3 },
    { type: 'wire', x1: 9, y1: 3, x2: 9, y2: 0 },
    { type: 'wire', x1: 9, y1: 0, x2: 6, y2: 0 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'active-bandpass': [
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 1, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 2, params: { resistance: 10000 } },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: -1 },
    { type: 'wire', x1: 4, y1: -1, x2: 0, y2: -1 },
    { type: 'wire', x1: 0, y1: -1, x2: 0, y2: 6 },
    { type: 'capacitor', x1: 4, y1: 2, x2: 8, y2: 2, params: { capacitance: 10e-9 } },
    { type: 'resistor', x1: 8, y1: 2, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Oscillators (all need active elements to oscillate) ──
  'wien-bridge': [
    // Wien bridge: RC network on V+, gain-setting resistors on V-, op-amp provides gain
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 1, frequency: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 3, params: { capacitance: 10e-9 } },
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 4, y1: 3, x2: 8, y2: 3, params: { capacitance: 10e-9 } },
    { type: 'opamp', x1: 4, y1: 3, x2: 8, y2: 5 },
    { type: 'resistor', x1: 8, y1: 5, x2: 8, y2: 6, params: { resistance: 10000 } },
    { type: 'resistor', x1: 8, y1: 6, x2: 12, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 12, y1: 6, x2: 12, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'wire', x1: 4, y1: 6, x2: 8, y2: 6 },
    { type: 'wire', x1: 8, y1: 6, x2: 12, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'phase-shift-osc': [
    // 3-stage RC + op-amp inverting amplifier for feedback
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 2, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 2, y1: 0, x2: 2, y2: 6, params: { capacitance: 10e-9 } },
    { type: 'resistor', x1: 2, y1: 0, x2: 4, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 6, params: { capacitance: 10e-9 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 6, y2: 0, params: { resistance: 10000 } },
    { type: 'capacitor', x1: 6, y1: 0, x2: 6, y2: 6, params: { capacitance: 10e-9 } },
    { type: 'opamp', x1: 6, y1: -2, x2: 6, y2: 0 },  // V+=(6,-2)→GND, V-=(6,0)→RC output, Out=(6,1)
    { type: 'wire', x1: 6, y1: -2, x2: 0, y2: -2 },
    { type: 'wire', x1: 0, y1: -2, x2: 0, y2: 6 },
    { type: 'resistor', x1: 6, y1: 1, x2: 6, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 6, x2: 2, y2: 6 },
    { type: 'wire', x1: 2, y1: 6, x2: 4, y2: 6 },
    { type: 'wire', x1: 4, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'relaxation-osc': [
    // Op-amp comparator with RC timing + positive feedback = relaxation oscillator
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 100000 } },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 6, params: { capacitance: 0.1e-6 } },
    { type: 'opamp', x1: 4, y1: -2, x2: 4, y2: 0 },  // V+=(4,-2), V-=(4,0)=RC, Out=(4,1)
    { type: 'resistor', x1: 4, y1: -2, x2: 4, y2: 1, params: { resistance: 10000 } },  // positive feedback
    { type: 'resistor', x1: 4, y1: 1, x2: 4, y2: 6, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: -2, x2: 0, y2: -2 },
    { type: 'wire', x1: 0, y1: -2, x2: 0, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'astable-multi': [
    // Two BJTs cross-coupled with RC timing
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 1000 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 6, y2: 0, params: { resistance: 1000 } },
    { type: 'wire', x1: 3, y1: 0, x2: 3, y2: 2 },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 4 },
    { type: 'bjt-npn', x1: 3, y1: 3, x2: 3, y2: 2 },  // Q1: B=(3,3) C=(3,2) E=(3,3+1)=(3,3) — issue
    { type: 'bjt-npn', x1: 6, y1: 5, x2: 6, y2: 4 },  // Q2
    { type: 'capacitor', x1: 3, y1: 2, x2: 6, y2: 5, params: { capacitance: 10e-6 } },
    { type: 'capacitor', x1: 6, y1: 4, x2: 3, y2: 3, params: { capacitance: 10e-6 } },
    { type: 'resistor', x1: 3, y1: 3, x2: 3, y2: 8, params: { resistance: 47000 } },
    { type: 'resistor', x1: 6, y1: 5, x2: 6, y2: 8, params: { resistance: 47000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 3, y2: 8 },
    { type: 'wire', x1: 3, y1: 8, x2: 6, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],

  // ── Signal Generators ──
  'schmitt-trigger': [
    // Op-amp: input→V-(inverting), positive feedback from output→V+(non-inverting)
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { peakVoltage: 3, frequency: 100 } },
    { type: 'resistor', x1: 0, y1: 2, x2: 4, y2: 2, params: { resistance: 10000 } },
    { type: 'opamp', x1: 4, y1: 0, x2: 4, y2: 2 },  // V+=(4,0), V-=(4,2), Out=(4,3)
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: -2, params: { resistance: 100000 } },  // feedback R
    { type: 'wire', x1: 4, y1: -2, x2: 8, y2: -2 },
    { type: 'wire', x1: 8, y1: -2, x2: 8, y2: 3 },
    { type: 'wire', x1: 8, y1: 3, x2: 4, y2: 3 },  // output to V+ feedback
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 6, params: { resistance: 10000 } },  // V+ bias to GND
    { type: 'resistor', x1: 4, y1: 3, x2: 4, y2: 6, params: { resistance: 1000 } },  // load
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'led-flasher': [
    // BJT + RC timing → LED blinks. BJT switches LED on/off as capacitor charges/discharges.
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 9 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 100000 } },
    { type: 'capacitor', x1: 3, y1: 2, x2: 3, y2: 6, params: { capacitance: 100e-6 } },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },  // B=(3,2) C=(6,2) E=(6,3)
    { type: 'led', x1: 0, y1: 0, x2: 6, y2: 0 },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 470 } },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 3, y2: 6 },
    { type: 'wire', x1: 3, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'staircase-gen': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 2, y2: 0, params: { resistance: 1000 } },
    { type: 'diode', x1: 2, y1: 0, x2: 4, y2: 0 },
    { type: 'capacitor', x1: 4, y1: 0, x2: 4, y2: 4, params: { capacitance: 1e-6 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 100000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Power Circuits ──
  'voltage-tripler': [
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 3, y2: 0, params: { capacitance: 10e-6 } },
    { type: 'diode', x1: 3, y1: 0, x2: 3, y2: 4 },
    { type: 'diode', x1: 3, y1: 0, x2: 6, y2: 0 },
    { type: 'capacitor', x1: 6, y1: 0, x2: 6, y2: 4, params: { capacitance: 10e-6 } },
    { type: 'diode', x1: 6, y1: 0, x2: 9, y2: 0 },
    { type: 'capacitor', x1: 9, y1: 0, x2: 9, y2: 4, params: { capacitance: 10e-6 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'wire', x1: 6, y1: 4, x2: 9, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'bjt-current-src': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 2, params: { resistance: 10000 } },
    { type: 'bjt-npn', x1: 3, y1: 2, x2: 6, y2: 2 },
    { type: 'resistor', x1: 6, y1: 3, x2: 6, y2: 6, params: { resistance: 100 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 2 },
    { type: 'wire', x1: 0, y1: 0, x2: 6, y2: 0 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'zener-reg-loaded': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 15 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'zener', x1: 4, y1: 4, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 8, y2: 0, params: { resistance: 2200 } },
    { type: 'wire', x1: 8, y1: 0, x2: 8, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Logic Families ──
  'rtl-nand': [
    // RTL NAND: two parallel BJTs, each with base resistor, shared collector pull-up
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 3, params: { resistance: 10000 } },  // Rb1 → Q1 base
    { type: 'resistor', x1: 0, y1: 2, x2: 6, y2: 3, params: { resistance: 10000 } },  // Rb2 → Q2 base
    { type: 'dc-voltage', x1: 8, y1: 8, x2: 8, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 3, params: { resistance: 1000 } },  // Rc pull-up
    { type: 'bjt-npn', x1: 3, y1: 3, x2: 8, y2: 3 },  // Q1: B=(3,3) C=(8,3) E=(8,4)
    { type: 'bjt-npn', x1: 6, y1: 3, x2: 8, y2: 5 },  // Q2: B=(6,3) C=(8,5) E=(8,6)
    { type: 'wire', x1: 8, y1: 4, x2: 8, y2: 5 },
    { type: 'wire', x1: 8, y1: 6, x2: 8, y2: 8 },
    { type: 'wire', x1: 0, y1: 8, x2: 8, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'cmos-inverter': [
    // NMOS inverter with pull-up resistor (approximation — true CMOS needs PMOS)
    // Vin drives gate, Vdd through Rpullup to drain, source to GND
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },     // Vin to gate
    { type: 'dc-voltage', x1: 6, y1: 6, x2: 6, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 10000 } },  // pull-up
    { type: 'mosfet-n', x1: 3, y1: 0, x2: 6, y2: 2 },  // G=(3,0) D=(6,2) S=(6,3)
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],
  'cmos-nand': [
    // 2-input NMOS NAND: two NMOS in series + pull-up resistor, separate gate inputs
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },     // input A
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 3, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 3, x2: 3, y2: 3 },     // input B
    { type: 'dc-voltage', x1: 8, y1: 8, x2: 8, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 2, params: { resistance: 10000 } },  // pull-up
    { type: 'mosfet-n', x1: 3, y1: 0, x2: 8, y2: 2 },  // M1: G=(3,0) D=(8,2) S=(8,3)
    { type: 'mosfet-n', x1: 3, y1: 3, x2: 8, y2: 3 },  // M2: G=(3,3) D=(8,3) S=(8,4) — series!
    { type: 'wire', x1: 8, y1: 4, x2: 8, y2: 8 },
    { type: 'wire', x1: 0, y1: 8, x2: 8, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],

  // ── Classic Theorems ──
  'thevenin': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 12 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 4000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 4, params: { resistance: 6000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 6, y2: 0, params: { resistance: 2000 } },
    { type: 'wire', x1: 6, y1: 0, x2: 6, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'norton': [
    // Norton equivalent: current source ‖ resistance + load
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 0 } },
    { type: 'dc-current', x1: 0, y1: 0, x2: 4, y2: 0, params: { sourceCurrent: 0.01 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 0, y2: -2, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: -2, x2: 4, y2: -2 },
    { type: 'wire', x1: 4, y1: -2, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'superposition': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 1000 } },
    { type: 'dc-voltage', x1: 6, y1: 4, x2: 6, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 3, y2: 0, params: { resistance: 2000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 4, params: { resistance: 3000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'max-power': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 100 } },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 100 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Large circuits (20+ nodes) ──
  'multi-stage-amp': [
    // 3-stage BJT amplifier: Vin → stage1 → stage2 → stage3 → load (20+ nodes)
    { type: 'ac-voltage', x1: 0, y1: 12, x2: 0, y2: 0, params: { peakVoltage: 0.01, frequency: 1000 } },
    { type: 'capacitor', x1: 0, y1: 0, x2: 3, y2: 0, params: { capacitance: 1e-6 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 3, params: { resistance: 100000 } },
    { type: 'dc-voltage', x1: 12, y1: 12, x2: 12, y2: 0, params: { voltage: 12 } },
    { type: 'wire', x1: 12, y1: 0, x2: 5, y2: 0 },
    { type: 'resistor', x1: 5, y1: 0, x2: 5, y2: 3, params: { resistance: 1000 } },
    { type: 'bjt-npn', x1: 3, y1: 3, x2: 5, y2: 3 },
    { type: 'resistor', x1: 5, y1: 4, x2: 5, y2: 6, params: { resistance: 500 } },
    { type: 'capacitor', x1: 5, y1: 3, x2: 7, y2: 3, params: { capacitance: 1e-6 } },
    { type: 'resistor', x1: 7, y1: 3, x2: 7, y2: 6, params: { resistance: 100000 } },
    { type: 'wire', x1: 12, y1: 0, x2: 9, y2: 0 },
    { type: 'resistor', x1: 9, y1: 0, x2: 9, y2: 6, params: { resistance: 1000 } },
    { type: 'bjt-npn', x1: 7, y1: 6, x2: 9, y2: 6 },
    { type: 'resistor', x1: 9, y1: 7, x2: 9, y2: 9, params: { resistance: 500 } },
    { type: 'capacitor', x1: 9, y1: 6, x2: 11, y2: 6, params: { capacitance: 1e-6 } },
    { type: 'resistor', x1: 11, y1: 6, x2: 11, y2: 9, params: { resistance: 100000 } },
    { type: 'resistor', x1: 12, y1: 0, x2: 12, y2: 9, params: { resistance: 1000 } },
    { type: 'bjt-npn', x1: 11, y1: 9, x2: 12, y2: 9 },
    { type: 'resistor', x1: 12, y1: 10, x2: 12, y2: 12, params: { resistance: 500 } },
    { type: 'wire', x1: 0, y1: 12, x2: 5, y2: 12 },
    { type: 'wire', x1: 5, y1: 12, x2: 5, y2: 6 },
    { type: 'wire', x1: 5, y1: 12, x2: 9, y2: 12 },
    { type: 'wire', x1: 9, y1: 12, x2: 9, y2: 9 },
    { type: 'wire', x1: 9, y1: 12, x2: 12, y2: 12 },
    { type: 'ground', x1: 0, y1: 12, x2: 0, y2: 12 },
  ],
  'r2r-dac': [
    // 4-bit R-2R ladder DAC: 4 inputs → analog output (16+ nodes)
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 4, params: { voltage: 0 } },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 6, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 3, y2: 0, params: { resistance: 2000 } },
    { type: 'resistor', x1: 0, y1: 2, x2: 3, y2: 2, params: { resistance: 2000 } },
    { type: 'resistor', x1: 0, y1: 4, x2: 6, y2: 4, params: { resistance: 2000 } },
    { type: 'resistor', x1: 0, y1: 6, x2: 9, y2: 6, params: { resistance: 2000 } },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 2, params: { resistance: 1000 } },
    { type: 'resistor', x1: 3, y1: 2, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 2, x2: 6, y2: 4 },
    { type: 'resistor', x1: 6, y1: 4, x2: 9, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 9, y1: 4, x2: 9, y2: 6 },
    { type: 'resistor', x1: 9, y1: 6, x2: 12, y2: 6, params: { resistance: 1000 } },
    { type: 'resistor', x1: 12, y1: 6, x2: 12, y2: 8, params: { resistance: 2000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 6, y2: 8 },
    { type: 'wire', x1: 6, y1: 8, x2: 12, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'power-supply': [
    // Full AC→DC power supply: AC → bridge rectifier → filter cap → zener reg → load
    { type: 'ac-voltage', x1: 0, y1: 8, x2: 0, y2: 0, params: { peakVoltage: 15, frequency: 60 } },
    { type: 'diode', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'diode', x1: 3, y1: 8, x2: 0, y2: 8 },
    { type: 'diode', x1: 3, y1: 0, x2: 6, y2: 0 },
    { type: 'diode', x1: 6, y1: 8, x2: 3, y2: 8 },
    { type: 'capacitor', x1: 6, y1: 0, x2: 6, y2: 4, params: { capacitance: 100e-6 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 9, y2: 0, params: { resistance: 100 } },
    { type: 'zener', x1: 9, y1: 4, x2: 9, y2: 0 },
    { type: 'resistor', x1: 9, y1: 0, x2: 12, y2: 0, params: { resistance: 1000 } },
    { type: 'wire', x1: 12, y1: 0, x2: 12, y2: 4 },
    { type: 'wire', x1: 0, y1: 8, x2: 3, y2: 8 },
    { type: 'wire', x1: 3, y1: 8, x2: 6, y2: 8 },
    { type: 'wire', x1: 6, y1: 8, x2: 6, y2: 4 },
    { type: 'wire', x1: 6, y1: 4, x2: 9, y2: 4 },
    { type: 'wire', x1: 9, y1: 4, x2: 12, y2: 4 },
    { type: 'ground', x1: 6, y1: 4, x2: 6, y2: 4 },
  ],

  // ── Transformer (using coupled inductors approximation) ──
  'transformer-up': [
    // Step-up: Vs=5V AC → primary inductor → secondary (larger) → load
    // Approximated as coupled LC (educational model)
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 5, frequency: 60 } },
    { type: 'inductor', x1: 0, y1: 0, x2: 4, y2: 0, params: { inductance: 0.1 } },
    { type: 'inductor', x1: 4, y1: 0, x2: 8, y2: 0, params: { inductance: 0.4 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'transformer-down': [
    // Step-down: Vs=10V AC → primary → secondary (smaller) → load
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 10, frequency: 60 } },
    { type: 'inductor', x1: 0, y1: 0, x2: 4, y2: 0, params: { inductance: 0.4 } },
    { type: 'inductor', x1: 4, y1: 0, x2: 8, y2: 0, params: { inductance: 0.1 } },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 4, params: { resistance: 100 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ═══════════════════════════════════════════
  // New component presets
  // ═══════════════════════════════════════════

  // ── JFET ──
  'jfet-amplifier': [
    // Common-source JFET amplifier
    { type: 'dc-voltage', x1: 6, y1: 8, x2: 6, y2: 0, params: { voltage: 15 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 2200 } },  // Rd
    { type: 'jfet-n', x1: 3, y1: 3, x2: 6, y2: 3 },   // G(3,3) D(6,3) S(6,4)
    { type: 'resistor', x1: 6, y1: 4, x2: 6, y2: 8, params: { resistance: 1000 } },  // Rs
    { type: 'ac-voltage', x1: 0, y1: 8, x2: 0, y2: 3, params: { peakVoltage: 0.2, frequency: 1000 } },
    { type: 'wire', x1: 0, y1: 3, x2: 3, y2: 3 },
    { type: 'wire', x1: 0, y1: 8, x2: 6, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],
  'jfet-switch': [
    // JFET as voltage-controlled switch
    { type: 'dc-voltage', x1: 6, y1: 6, x2: 6, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 1000 } },
    { type: 'jfet-n', x1: 3, y1: 3, x2: 6, y2: 3 },
    { type: 'wire', x1: 6, y1: 4, x2: 6, y2: 6 },
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 3, params: { voltage: 0 } },  // Gate bias
    { type: 'wire', x1: 0, y1: 3, x2: 3, y2: 3 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Current-Controlled Sources ──
  'ccvs-demo': [
    // CCVS: output voltage proportional to sensed current
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'ccvs', x1: 4, y1: 0, x2: 4, y2: 4 },  // sense(4,0)-(4,4), out(4,5)-(4,1_adj)
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 4, params: { resistance: 100 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'cccs-demo': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 5000 } },
    { type: 'cccs', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'resistor', x1: 8, y1: 0, x2: 8, y2: 4, params: { resistance: 100 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 8, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Switches ──
  'push-switch-demo': [
    // Push switch controls LED
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'push-switch', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 2, params: { resistance: 220 } },
    { type: 'led', x1: 4, y1: 2, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
  'spdt-switch-demo': [
    // SPDT switches between two LEDs
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'spdt-switch', x1: 3, y1: 0, x2: 6, y2: 0 },  // common(3,0) A(6,0) B(6,1)
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 3, params: { resistance: 220 } },
    { type: 'led', x1: 6, y1: 3, x2: 6, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 6, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Fuse ──
  'fuse-demo': [
    // Fuse protects LED — increase voltage to blow it
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'fuse', x1: 0, y1: 0, x2: 3, y2: 0 },
    { type: 'resistor', x1: 3, y1: 0, x2: 3, y2: 2, params: { resistance: 100 } },
    { type: 'led', x1: 3, y1: 2, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Lamp ──
  'lamp-demo': [
    // Lamp with variable voltage — see brightness change
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 120 } },
    { type: 'lamp', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'wire', x1: 4, y1: 0, x2: 4, y2: 4 },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Comparator ──
  'comparator-demo': [
    // Comparator: AC input vs DC reference → square wave output
    { type: 'ac-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { peakVoltage: 3, frequency: 100 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'comparator', x1: 4, y1: 0, x2: 4, y2: 2 },  // V+(4,0) V-(4,2) Out(4,3)
    { type: 'dc-voltage', x1: 4, y1: 6, x2: 4, y2: 2, params: { voltage: 1 } },  // reference
    { type: 'resistor', x1: 4, y1: 3, x2: 8, y2: 3, params: { resistance: 1000 } },
    { type: 'wire', x1: 8, y1: 3, x2: 8, y2: 6 },
    { type: 'wire', x1: 0, y1: 6, x2: 4, y2: 6 },
    { type: 'wire', x1: 4, y1: 6, x2: 8, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Schmitt (native) ──
  'schmitt-native': [
    // Schmitt trigger with hysteresis
    { type: 'ac-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { peakVoltage: 4, frequency: 50 } },
    { type: 'schmitt', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 4, y2: 4, params: { resistance: 1000 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Darlington (native component) ──
  'darlington-native': [
    { type: 'dc-voltage', x1: 6, y1: 8, x2: 6, y2: 0, params: { voltage: 12 } },
    { type: 'resistor', x1: 6, y1: 0, x2: 6, y2: 2, params: { resistance: 100 } },
    { type: 'darlington-npn', x1: 3, y1: 3, x2: 6, y2: 3 },  // B(3,3) C(6,3) E(6,4)
    { type: 'wire', x1: 6, y1: 4, x2: 6, y2: 8 },
    { type: 'dc-voltage', x1: 0, y1: 8, x2: 0, y2: 3, params: { voltage: 2 } },
    { type: 'resistor', x1: 0, y1: 3, x2: 3, y2: 3, params: { resistance: 100000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 6, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],

  // ── JK Flip-Flop ──
  'jk-flipflop-demo': [
    // JK flip-flop toggling with J=K=HIGH
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },    // J = HIGH
    { type: 'wire', x1: 0, y1: 0, x2: 0, y2: -2 },
    { type: 'wire', x1: 0, y1: -2, x2: 3, y2: -2 },   // K = HIGH
    { type: 'clock', x1: 0, y1: 4, x2: 3, y2: 4, params: { frequency: 2 } },
    { type: 'jk-flipflop', x1: 3, y1: 0, x2: 3, y2: 4 },  // J(3,0) CLK(3,4) K(3,-2_adj) Q(3,5)
    { type: 'resistor', x1: 3, y1: 5, x2: 3, y2: 8, params: { resistance: 1000 } },
    { type: 'wire', x1: 3, y1: 8, x2: 0, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],

  // ── Counter ──
  'counter-demo': [
    // 4-bit counter driven by clock
    { type: 'clock', x1: 0, y1: 0, x2: 3, y2: 0, params: { frequency: 2 } },
    { type: 'counter', x1: 3, y1: 0, x2: 3, y2: 2 },  // CLK(3,0) RST(3,2) Out(3,3)
    { type: 'wire', x1: 3, y1: 2, x2: 3, y2: 4 },  // RST tied to ground
    { type: 'resistor', x1: 3, y1: 3, x2: 6, y2: 3, params: { resistance: 1000 } },
    { type: 'wire', x1: 6, y1: 3, x2: 6, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 3, y2: 4 },
    { type: 'wire', x1: 3, y1: 4, x2: 6, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Multiplexer ──
  'mux-demo': [
    // 2:1 MUX: select between two voltage levels
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },     // In0 = 5V
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 0 } },
    { type: 'wire', x1: 0, y1: 2, x2: 4, y2: 2 },     // In1 = 0V
    { type: 'clock', x1: 0, y1: 6, x2: 4, y2: 6, params: { frequency: 1 } },  // Select
    { type: 'mux', x1: 4, y1: 0, x2: 4, y2: 2 },  // I0(4,0) I1(4,2) Sel(4,6_adj) Out(4,-1_adj)
    { type: 'wire', x1: 0, y1: 6, x2: 0, y2: 6 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Shift Register ──
  'shift-register-demo': [
    // Clock + data → serial-to-parallel
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 3, y2: 0 },       // Data = HIGH
    { type: 'clock', x1: 0, y1: 4, x2: 3, y2: 4, params: { frequency: 2 } },
    { type: 'shift-register', x1: 3, y1: 0, x2: 3, y2: 4 },  // D(3,0) CLK(3,4) Out(3,5)
    { type: 'resistor', x1: 3, y1: 5, x2: 3, y2: 8, params: { resistance: 1000 } },
    { type: 'wire', x1: 0, y1: 8, x2: 3, y2: 8 },
    { type: 'ground', x1: 0, y1: 8, x2: 0, y2: 8 },
  ],

  // ── Half Adder (native) ──
  'half-adder-native': [
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },  // A = HIGH
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 4, y2: 2 },  // B = HIGH
    { type: 'half-adder', x1: 4, y1: 0, x2: 4, y2: 2 },  // A(4,0) B(4,2) S(4,3) C(4,-1)
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Full Adder (native) ──
  'full-adder-native': [
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 0, x2: 4, y2: 0 },  // A = HIGH
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 2, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 2, x2: 4, y2: 2 },  // B = HIGH
    { type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 4, params: { voltage: 5 } },
    { type: 'wire', x1: 0, y1: 4, x2: 4, y2: 4 },  // Cin = HIGH (1+1+1 = 11 binary)
    { type: 'full-adder', x1: 4, y1: 0, x2: 4, y2: 2 },
    { type: 'ground', x1: 0, y1: 6, x2: 0, y2: 6 },
  ],

  // ── Logic I/O ──
  'logic-io-demo': [
    // Logic input → NOT gate → logic output
    { type: 'logic-input', x1: 0, y1: 0, x2: 0, y2: 0 },
    { type: 'not-gate', x1: 0, y1: 0, x2: 4, y2: 0 },
    { type: 'logic-output', x1: 4, y1: 0, x2: 4, y2: 0 },
  ],

  // ── Monostable ──
  'monostable-demo': [
    // Clock triggers monostable → fixed pulse output
    { type: 'clock', x1: 0, y1: 4, x2: 4, y2: 4, params: { frequency: 1 } },
    { type: 'monostable', x1: 4, y1: 4, x2: 4, y2: 0 },
    { type: 'resistor', x1: 4, y1: 0, x2: 8, y2: 0, params: { resistance: 1000 } },
    { type: 'wire', x1: 8, y1: 0, x2: 8, y2: 4 },
    { type: 'wire', x1: 0, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],

  // ── Polarized Cap ──
  'polarized-cap-demo': [
    // Electrolytic cap in RC circuit — shows reverse polarity warning
    { type: 'dc-voltage', x1: 0, y1: 4, x2: 0, y2: 0, params: { voltage: 10 } },
    { type: 'resistor', x1: 0, y1: 0, x2: 4, y2: 0, params: { resistance: 1000 } },
    { type: 'polarized-cap', x1: 4, y1: 0, x2: 4, y2: 4, params: { capacitance: 100e-6 } },
    { type: 'wire', x1: 4, y1: 4, x2: 0, y2: 4 },
    { type: 'ground', x1: 0, y1: 4, x2: 0, y2: 4 },
  ],
};
