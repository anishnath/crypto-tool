/**
 * SimRunner — the animation loop that advances physics and notifies renderers.
 *
 * Decoupled from rendering: runner ticks physics, fires callbacks.
 * Canvases, graphs, etc. listen and render themselves.
 */
import { rk4, euler, midpoint } from './solver.js';
import { cloneState } from './state.js';

const SOLVERS = { rk4, euler, midpoint };

export class SimRunner {
  /**
   * @param {object} sim — sim definition object (evaluate, init, params, etc.)
   */
  constructor(sim) {
    this.sim = sim;
    this.params = {};
    this.state = null;
    this.initialState = null;
    this.solverName = 'rk4';
    this.dt = 1 / 120;       // physics timestep (fixed)
    this.speed = 1.0;         // playback multiplier
    this.playing = false;
    this.isDragging = false;
    this.rafId = null;
    this.lastTimestamp = null;
    this.accumulator = 0;

    // Callbacks
    this._onTick = [];       // called after each physics step: (state, params, time)
    this._onRender = [];     // called each animation frame: (state, params)

    // Init params from sim defaults
    this._initParams();
    this.reset();
  }

  _initParams() {
    const simParams = this.sim.params || {};
    for (const [key, def] of Object.entries(simParams)) {
      this.params[key] = def.value;
    }
  }

  /** Reset state to initial conditions using current params */
  reset() {
    const init = this.sim.init(this.params);
    this.state = Float64Array.from(init);
    this.initialState = Float64Array.from(init);
    this.accumulator = 0;
    this.lastTimestamp = null;
    this._notifyRender();
  }

  /** Set a single param by name */
  setParam(name, value) {
    this.params[name] = value;
  }

  /** Get current param value */
  getParam(name) {
    return this.params[name];
  }

  /** Apply a preset (partial params override + reset) */
  loadPreset(preset) {
    // Reset all to defaults first
    this._initParams();
    // Apply overrides
    if (preset.params) {
      for (const [k, v] of Object.entries(preset.params)) {
        this.params[k] = v;
      }
    }
    this.reset();
  }

  /** Set solver: 'rk4', 'euler', or 'midpoint' */
  setSolver(name) {
    if (SOLVERS[name]) this.solverName = name;
  }

  /** Set physics timestep */
  setDt(dt) {
    this.dt = Math.max(0.0001, Math.min(0.05, dt));
  }

  /** Set playback speed multiplier */
  setSpeed(s) {
    this.speed = Math.max(0.1, Math.min(8, s));
  }

  /** Register tick callback (after each physics step) */
  onTick(fn) { this._onTick.push(fn); }

  /** Register render callback (each animation frame) */
  onRender(fn) { this._onRender.push(fn); }

  play() {
    if (this.playing) return;
    this.playing = true;
    this.lastTimestamp = null;
    this.accumulator = 0;
    // Must go through RAF so _loop receives a valid DOMHighResTimeStamp.
    // Direct this._loop() passes undefined, corrupting accumulator to NaN.
    this.rafId = requestAnimationFrame((ts) => this._loop(ts));
  }

  pause() {
    this.playing = false;
    if (this.rafId) {
      cancelAnimationFrame(this.rafId);
      this.rafId = null;
    }
  }

  toggle() {
    this.playing ? this.pause() : this.play();
  }

  /** Advance one physics step (when paused) */
  step() {
    this._stepPhysics();
    this._notifyRender();
  }

  _loop(timestamp) {
    if (!this.playing) return;

    if (this.lastTimestamp !== null) {
      // Wall-clock delta in seconds, capped at 100ms to avoid spiral of death
      let wallDt = Math.min((timestamp - this.lastTimestamp) / 1000, 0.1);
      wallDt *= this.speed;
      this.accumulator += wallDt;

      // Fixed timestep loop — physics catches up to real time
      // Skip physics entirely while dragging — the user controls state,
      // and postStep (collisions, constraints) would fight the drag.
      const maxSteps = 20; // safety cap
      let steps = 0;
      while (this.accumulator >= this.dt && steps < maxSteps) {
        if (!this.isDragging) {
          this._stepPhysics();
        }
        this.accumulator -= this.dt;
        steps++;
      }
    }
    this.lastTimestamp = timestamp;

    this._notifyRender();
    this.rafId = requestAnimationFrame((ts) => this._loop(ts));
  }

  _stepPhysics() {
    const solver = SOLVERS[this.solverName];
    const evaluate = (vars, change, params) => {
      this.sim.evaluate(vars, change, params, this.isDragging);
    };
    solver(this.state, evaluate, this.dt, this.params);

    // Post-step hook (e.g., wall collisions)
    if (typeof this.sim.postStep === 'function') {
      this.sim.postStep(this.state, this.params);
    }

    // Notify tick listeners (graph data collection, etc.)
    for (const fn of this._onTick) {
      fn(this.state, this.params);
    }
  }

  _notifyRender() {
    for (const fn of this._onRender) {
      fn(this.state, this.params);
    }
  }

  /** Get current simulation time (convention: last element of state is time) */
  getTime() {
    if (!this.state) return 0;
    // Find time var index from sim.vars
    const vars = this.sim.vars;
    for (const v of Object.values(vars)) {
      if (v.index >= 0 && (v.symbol === 't' || v.label?.toLowerCase().includes('time'))) {
        return this.state[v.index];
      }
    }
    // Fallback: last element
    return this.state[this.state.length - 1];
  }

  destroy() {
    this.pause();
    this._onTick = [];
    this._onRender = [];
  }
}
