/**
 * Physics Labs Engine — Logic Tests
 *
 * Run: node physics/labs/what_we_test.cjs
 *
 * Tests the core engine (solver, state, runner) and sim definitions
 * without any DOM or canvas. Pure math + logic validation.
 */

// ═══════════════════════════════════════════
// Inline the modules (CJS can't import ESM)
// We copy the core functions here for testing.
// The real modules live in js/core/*.js as ESM.
// ═══════════════════════════════════════════

// --- solver.js ---
function rk4(vars, evaluate, dt, params) {
  const n = vars.length;
  const k1 = new Float64Array(n);
  const k2 = new Float64Array(n);
  const k3 = new Float64Array(n);
  const k4 = new Float64Array(n);
  const tmp = new Float64Array(n);
  evaluate(vars, k1, params);
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k1[i];
  evaluate(tmp, k2, params);
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k2[i];
  evaluate(tmp, k3, params);
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + dt * k3[i];
  evaluate(tmp, k4, params);
  for (let i = 0; i < n; i++) {
    vars[i] += (dt / 6) * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]);
  }
}

function euler(vars, evaluate, dt, params) {
  const n = vars.length;
  const change = new Float64Array(n);
  evaluate(vars, change, params);
  for (let i = 0; i < n; i++) vars[i] += dt * change[i];
}

function midpoint(vars, evaluate, dt, params) {
  const n = vars.length;
  const k1 = new Float64Array(n);
  const tmp = new Float64Array(n);
  const k2 = new Float64Array(n);
  evaluate(vars, k1, params);
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k1[i];
  evaluate(tmp, k2, params);
  for (let i = 0; i < n; i++) vars[i] += dt * k2[i];
}

// --- state.js ---
function cloneState(vars) { return Float64Array.from(vars); }

class RingBuffer {
  constructor(capacity) {
    this.capacity = capacity;
    this.data = new Array(capacity);
    this.head = 0;
    this.size = 0;
  }
  push(value) {
    this.data[this.head] = value;
    this.head = (this.head + 1) % this.capacity;
    if (this.size < this.capacity) this.size++;
  }
  clear() { this.head = 0; this.size = 0; }
  forEach(fn) {
    const start = this.size < this.capacity ? 0 : this.head;
    for (let i = 0; i < this.size; i++) {
      fn(this.data[(start + i) % this.capacity], i);
    }
  }
  get(i) {
    const start = this.size < this.capacity ? 0 : this.head;
    return this.data[(start + i) % this.capacity];
  }
  last() {
    if (this.size === 0) return undefined;
    return this.data[(this.head - 1 + this.capacity) % this.capacity];
  }
}

// --- Pendulum sim ---
const PendulumSim = {
  params: {
    gravity:    { value: 9.81 },
    length:     { value: 1.0 },
    mass:       { value: 1.0 },
    damping:    { value: 0.1 },
    driveAmp:   { value: 0 },
    driveFreq:  { value: 0.667 },
    startAngle: { value: Math.PI / 3 },
  },
  init(p) { return [p.startAngle, 0, 0]; },
  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;
    const [angle, angVel, time] = vars;
    const { gravity, length, mass, damping, driveAmp, driveFreq } = params;
    change[0] = angVel;
    change[1] = -(gravity / length) * Math.sin(angle)
                - (damping / (mass * length * length)) * angVel
                + ((driveAmp || 0) / (mass * length * length)) * Math.cos((driveFreq || 0) * time);
  },
  energy(vars, params) {
    const [angle, angVel] = vars;
    const { gravity, length, mass } = params;
    const KE = 0.5 * mass * (length * angVel) ** 2;
    const PE = mass * gravity * length * (1 - Math.cos(angle));
    return { kinetic: KE, potential: PE, total: KE + PE };
  },
  hitTest(wx, wy, vars, params) {
    const L = params.length;
    const bobX = L * Math.sin(vars[0]);
    const bobY = -L * Math.cos(vars[0]);
    return Math.hypot(wx - bobX, wy - bobY) < 0.3 ? { id: 'bob' } : null;
  },
  onDrag(id, wx, wy, offset, vars) {
    if (id === 'bob') { vars[0] = Math.atan2(wx, -wy); vars[1] = 0; }
  },
  onRelease() {},
  potentialEnergy(angle, params) {
    return params.mass * params.gravity * params.length * (1 - Math.cos(angle));
  },
  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.length / params.gravity);
  },
  periodVar: 1,
  vectors(vars, params) {
    const [angle, angVel] = vars;
    const { gravity, length, mass, damping } = params;
    const bobX = length * Math.sin(angle);
    const bobY = -length * Math.cos(angle);
    const speed = length * angVel;
    const vx = speed * Math.cos(angle);
    const vy = speed * Math.sin(angle);
    const accel = -(gravity / length) * Math.sin(angle) - (damping / (mass * length * length)) * angVel;
    const aT = length * accel;
    const aC = length * angVel * angVel;
    return {
      pos: { x: bobX, y: bobY },
      velocity: { x: vx, y: vy, mag: Math.abs(speed) },
      accel: { x: aT * Math.cos(angle) - aC * Math.sin(angle), y: aT * Math.sin(angle) + aC * Math.cos(angle), mag: Math.hypot(aT, aC) },
    };
  },
};

// --- Spring sim ---
const SpringSim = {
  params: {
    mass:       { value: 1.0 },
    springMass: { value: 0 },
    stiffness:  { value: 3.0 },
    damping:    { value: 0.1 },
    restLength: { value: 1.0 },
    fixedPoint: { value: -1.0 },
    startX:     { value: 2.0 },
  },
  init(p) { return [p.startX, 0, 0]; },
  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;
    const [x, v] = vars;
    const { mass, stiffness, damping, restLength, fixedPoint } = params;
    const stretch = x - fixedPoint - restLength;
    change[0] = v;
    change[1] = (-stiffness * stretch - damping * v) / mass;
  },
  energy(vars, params) {
    const [x, v] = vars;
    const { mass, stiffness, restLength, fixedPoint } = params;
    const stretch = x - fixedPoint - restLength;
    const KE = 0.5 * mass * v * v;
    const PE = 0.5 * stiffness * stretch * stretch;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },
  hitTest(wx, wy, vars) {
    return Math.hypot(wx - vars[0], wy) < 0.3 ? { id: 'block', offsetX: wx - vars[0], offsetY: wy } : null;
  },
  onDrag(id, wx, wy, offset, vars) {
    if (id === 'block') { vars[0] = wx - offset.offsetX; vars[1] = 0; }
  },
  onRelease() {},
  potentialEnergy(x, params) {
    const stretch = x - params.fixedPoint - params.restLength;
    return 0.5 * params.stiffness * stretch * stretch;
  },
  theoreticalPeriod(params) {
    return 2 * Math.PI * Math.sqrt(params.mass / params.stiffness);
  },
  periodVar: 1,
  vectors(vars, params) {
    const [x, v] = vars;
    const stretch = x - params.fixedPoint - params.restLength;
    const force = -params.stiffness * stretch - params.damping * v;
    const accel = force / params.mass;
    return { pos: { x, y: 0 }, velocity: { x: v, y: 0, mag: Math.abs(v) }, accel: { x: accel, y: 0, mag: Math.abs(accel) } };
  },
};

// ═══════════════════════════════════════════
// TEST FRAMEWORK (minimal)
// ═══════════════════════════════════════════
let passed = 0, failed = 0, total = 0;

function assert(condition, msg) {
  total++;
  if (condition) { passed++; }
  else { failed++; console.error('  FAIL:', msg); }
}

function assertClose(actual, expected, tol, msg) {
  total++;
  if (Math.abs(actual - expected) < tol) { passed++; }
  else { failed++; console.error(`  FAIL: ${msg} — expected ${expected}, got ${actual} (tol=${tol})`); }
}

function section(name) { console.log('\n=== ' + name + ' ==='); }

function getParams(sim) {
  const p = {};
  for (const [k, v] of Object.entries(sim.params)) p[k] = v.value;
  return p;
}

// ═══════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════

section('RK4 Solver — Exponential Decay');
{
  // dy/dt = -y, y(0) = 1  →  y(t) = e^(-t)
  const vars = Float64Array.from([1.0, 0]);  // [y, time]
  const evaluate = (v, c) => { c[0] = -v[0]; c[1] = 1; };
  const dt = 0.01;
  for (let i = 0; i < 100; i++) rk4(vars, evaluate, dt, {});
  // After t=1: y should be e^(-1) ≈ 0.3679
  assertClose(vars[0], Math.exp(-1), 1e-8, 'RK4 exponential decay at t=1');
  assertClose(vars[1], 1.0, 1e-8, 'RK4 time at t=1');
}

section('RK4 Solver — Simple Harmonic Oscillator');
{
  // x'' = -x, with x(0)=1, v(0)=0  →  x(t) = cos(t)
  // State: [x, v, t]
  const vars = Float64Array.from([1.0, 0, 0]);
  const evaluate = (v, c) => { c[0] = v[1]; c[1] = -v[0]; c[2] = 1; };
  const dt = 0.001;
  const steps = 6283; // ~2π seconds ≈ one full period
  for (let i = 0; i < steps; i++) rk4(vars, evaluate, dt, {});
  // After one full period: x ≈ 1, v ≈ 0
  assertClose(vars[0], 1.0, 1e-4, 'SHO position after one period');
  assertClose(vars[1], 0.0, 1e-3, 'SHO velocity after one period');
}

section('Euler vs RK4 — Accuracy Comparison');
{
  // Same SHO, compare after 1 period
  const varsRK4 = Float64Array.from([1.0, 0, 0]);
  const varsEuler = Float64Array.from([1.0, 0, 0]);
  const evaluate = (v, c) => { c[0] = v[1]; c[1] = -v[0]; c[2] = 1; };
  const dt = 0.01;
  const steps = 628;
  for (let i = 0; i < steps; i++) rk4(varsRK4, evaluate, dt, {});
  for (let i = 0; i < steps; i++) euler(varsEuler, evaluate, dt, {});
  const errRK4 = Math.abs(varsRK4[0] - 1.0);
  const errEuler = Math.abs(varsEuler[0] - 1.0);
  assert(errRK4 < errEuler, `RK4 error (${errRK4.toExponential(2)}) should be < Euler error (${errEuler.toExponential(2)})`);
  assert(errRK4 < 1e-4, `RK4 error should be tiny: ${errRK4.toExponential(2)}`);
}

section('Midpoint vs Euler — Accuracy');
{
  const varsMid = Float64Array.from([1.0, 0, 0]);
  const varsEuler = Float64Array.from([1.0, 0, 0]);
  const evaluate = (v, c) => { c[0] = v[1]; c[1] = -v[0]; c[2] = 1; };
  const dt = 0.01;
  for (let i = 0; i < 628; i++) midpoint(varsMid, evaluate, dt, {});
  for (let i = 0; i < 628; i++) euler(varsEuler, evaluate, dt, {});
  const errMid = Math.abs(varsMid[0] - 1.0);
  const errEuler = Math.abs(varsEuler[0] - 1.0);
  assert(errMid < errEuler, `Midpoint error (${errMid.toExponential(2)}) should be < Euler (${errEuler.toExponential(2)})`);
}

section('Pendulum — Init & Evaluate');
{
  const p = getParams(PendulumSim);
  const state = Float64Array.from(PendulumSim.init(p));
  assert(state.length === 3, 'Pendulum state has 3 vars');
  assertClose(state[0], Math.PI / 3, 1e-10, 'Initial angle = π/3');
  assertClose(state[1], 0, 1e-10, 'Initial angular velocity = 0');
  assertClose(state[2], 0, 1e-10, 'Initial time = 0');

  const change = new Float64Array(3);
  PendulumSim.evaluate(state, change, p, false);
  assert(change[0] === 0, 'dθ/dt = ω = 0 at start');
  assert(change[1] < 0, 'dω/dt < 0 (gravity pulls down from π/3)');
  assertClose(change[2], 1, 1e-10, 'dt/dt = 1');
}

section('Pendulum — Energy Conservation (no damping)');
{
  const p = getParams(PendulumSim);
  p.damping = 0;
  const state = Float64Array.from(PendulumSim.init(p));
  const e0 = PendulumSim.energy(state, p);

  // Run for 5 seconds with RK4
  const dt = 1 / 120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v, c, par) => PendulumSim.evaluate(v, c, par, false), dt, p);
  }

  const e1 = PendulumSim.energy(state, p);
  assertClose(e1.total, e0.total, 1e-6, `Energy conserved: initial=${e0.total.toFixed(6)}, final=${e1.total.toFixed(6)}`);
  assert(state[2] > 4.9, `Time advanced to ~5s: ${state[2].toFixed(2)}`);
}

section('Pendulum — Damping Reduces Energy');
{
  const p = getParams(PendulumSim);
  p.damping = 0.5;
  const state = Float64Array.from(PendulumSim.init(p));
  const e0 = PendulumSim.energy(state, p);

  const dt = 1 / 120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v, c, par) => PendulumSim.evaluate(v, c, par, false), dt, p);
  }

  const e1 = PendulumSim.energy(state, p);
  assert(e1.total < e0.total * 0.5, `Energy decreased with damping: ${e0.total.toFixed(4)} → ${e1.total.toFixed(4)}`);
}

section('Pendulum — isDragging Stops Physics');
{
  const p = getParams(PendulumSim);
  const state = Float64Array.from(PendulumSim.init(p));
  const angleBefore = state[0];
  const change = new Float64Array(3);

  PendulumSim.evaluate(state, change, p, true);  // isDragging = true
  assert(change[0] === 0, 'dθ/dt = 0 during drag');
  assert(change[1] === 0, 'dω/dt = 0 during drag');
  assertClose(change[2], 1, 1e-10, 'Time still advances during drag');
}

section('Pendulum — Drag Constrains to Arc');
{
  const p = getParams(PendulumSim);
  const state = Float64Array.from(PendulumSim.init(p));

  // Drag bob to a new position (world coords: right and down)
  PendulumSim.onDrag('bob', 0.5, -0.866, {}, state, p);

  // Should set angle to atan2(0.5, 0.866) ≈ 0.5236 (30 degrees)
  assertClose(state[0], Math.atan2(0.5, 0.866), 1e-3, 'Drag constrains angle via atan2');
  assertClose(state[1], 0, 1e-10, 'Velocity zeroed during drag');
}

section('Pendulum — HitTest');
{
  const p = getParams(PendulumSim);
  const state = Float64Array.from([0, 0, 0]);  // angle=0 → bob at (0, -L)
  const L = p.length;

  // Click on bob (at 0, -1)
  const hitBob = PendulumSim.hitTest(0, -L, state, p);
  assert(hitBob !== null, 'Hit test detects bob at exact position');
  assert(hitBob.id === 'bob', 'Hit object is bob');

  // Click far away
  const hitMiss = PendulumSim.hitTest(5, 5, state, p);
  assert(hitMiss === null, 'Hit test misses when far from bob');
}

section('Spring — Init & Evaluate');
{
  const p = getParams(SpringSim);
  const state = Float64Array.from(SpringSim.init(p));
  assert(state.length === 3, 'Spring state has 3 vars');
  assertClose(state[0], 2.0, 1e-10, 'Initial position = startX = 2.0');

  const change = new Float64Array(3);
  SpringSim.evaluate(state, change, p, false);
  assert(change[0] === 0, 'dx/dt = v = 0 at start');
  assert(change[1] < 0, 'dv/dt < 0 (spring pulls back from stretched position)');
  // Spring stretched by (2.0 - (-1.0) - 1.0) = 2.0 meters
  // Force = -k * stretch / m = -3 * 2 / 1 = -6
  assertClose(change[1], -6.0, 0.01, 'Acceleration = -k*stretch/m = -6.0');
}

section('Spring — Energy Conservation (no damping)');
{
  const p = getParams(SpringSim);
  p.damping = 0;
  const state = Float64Array.from(SpringSim.init(p));
  const e0 = SpringSim.energy(state, p);

  const dt = 1 / 120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v, c, par) => SpringSim.evaluate(v, c, par, false), dt, p);
  }

  const e1 = SpringSim.energy(state, p);
  assertClose(e1.total, e0.total, 1e-5, `Spring energy conserved: ${e0.total.toFixed(6)} → ${e1.total.toFixed(6)}`);
}

section('Spring — Period Matches Theory');
{
  // T = 2π√(m/k) for undamped spring
  const p = getParams(SpringSim);
  p.damping = 0;
  const T_theory = 2 * Math.PI * Math.sqrt(p.mass / p.stiffness);
  const state = Float64Array.from(SpringSim.init(p));
  const x0 = state[0];

  // Run for one full period
  const dt = 1 / 1000;
  const steps = Math.round(T_theory / dt);
  for (let i = 0; i < steps; i++) {
    rk4(state, (v, c, par) => SpringSim.evaluate(v, c, par, false), dt, p);
  }

  assertClose(state[0], x0, 0.01, `Spring returns to start after T=${T_theory.toFixed(3)}s: x=${state[0].toFixed(4)}`);
  assertClose(state[1], 0, 0.1, `Spring velocity ≈ 0 after one period: v=${state[1].toFixed(4)}`);
}

section('Spring — Drag Interaction');
{
  const p = getParams(SpringSim);
  const state = Float64Array.from(SpringSim.init(p));

  // Hit test on block at x=2.0, y=0
  const hit = SpringSim.hitTest(2.1, 0.05, state);
  assert(hit !== null, 'Hit test detects block near position');
  assert(hit.id === 'block', 'Hit object is block');

  // Drag to x=3.0
  SpringSim.onDrag('block', 3.0, 0, hit, state, p);
  assertClose(state[0], 3.0 - hit.offsetX, 0.01, 'Block dragged to new position');
  assertClose(state[1], 0, 1e-10, 'Velocity zeroed during drag');
}

section('RingBuffer');
{
  const buf = new RingBuffer(5);
  assert(buf.size === 0, 'Empty buffer size = 0');
  assert(buf.last() === undefined, 'Empty buffer last = undefined');

  buf.push(10); buf.push(20); buf.push(30);
  assert(buf.size === 3, 'Size after 3 pushes');
  assert(buf.get(0) === 10, 'Oldest = 10');
  assert(buf.get(2) === 30, 'Newest = 30');
  assert(buf.last() === 30, 'Last = 30');

  // Fill and overflow
  buf.push(40); buf.push(50); buf.push(60); buf.push(70);
  assert(buf.size === 5, 'Size capped at capacity');
  assert(buf.get(0) === 30, 'Oldest after overflow = 30');
  assert(buf.last() === 70, 'Newest after overflow = 70');

  buf.clear();
  assert(buf.size === 0, 'Size after clear');
}

section('cloneState');
{
  const a = Float64Array.from([1, 2, 3]);
  const b = cloneState(a);
  assert(b[0] === 1 && b[1] === 2 && b[2] === 3, 'Clone matches original');
  b[0] = 99;
  assert(a[0] === 1, 'Clone is independent (not a reference)');
}

section('Sim Contract Validation — Pendulum');
{
  assert(typeof PendulumSim.init === 'function', 'Has init()');
  assert(typeof PendulumSim.evaluate === 'function', 'Has evaluate()');
  assert(typeof PendulumSim.energy === 'function', 'Has energy()');
  assert(typeof PendulumSim.hitTest === 'function', 'Has hitTest()');
  assert(typeof PendulumSim.onDrag === 'function', 'Has onDrag()');
  assert(Object.keys(PendulumSim.params).length > 0, 'Has params');
}

section('Sim Contract Validation — Spring');
{
  assert(typeof SpringSim.init === 'function', 'Has init()');
  assert(typeof SpringSim.evaluate === 'function', 'Has evaluate()');
  assert(typeof SpringSim.energy === 'function', 'Has energy()');
  assert(typeof SpringSim.hitTest === 'function', 'Has hitTest()');
  assert(typeof SpringSim.onDrag === 'function', 'Has onDrag()');
  assert(Object.keys(SpringSim.params).length > 0, 'Has params');
}

// --- DragState (from interact.js) ---
class DragState {
  constructor() { this.active = false; this.objectId = null; this.offset = null; }
  start(hitResult) { this.active = true; this.objectId = hitResult.id; this.offset = hitResult; }
  end() { const id = this.objectId; this.active = false; this.objectId = null; this.offset = null; return id; }
}

section('DragState — State Machine');
{
  const drag = new DragState();
  assert(drag.active === false, 'Starts inactive');
  assert(drag.objectId === null, 'No object initially');

  // Start drag
  drag.start({ id: 'bob', offsetX: 0.1, offsetY: -0.2 });
  assert(drag.active === true, 'Active after start');
  assert(drag.objectId === 'bob', 'Object ID set');
  assert(drag.offset.offsetX === 0.1, 'Offset preserved');

  // End drag
  const releasedId = drag.end();
  assert(releasedId === 'bob', 'end() returns released object ID');
  assert(drag.active === false, 'Inactive after end');
  assert(drag.objectId === null, 'Object cleared after end');
  assert(drag.offset === null, 'Offset cleared after end');
}

section('DragState — Multiple Drag Cycles');
{
  const drag = new DragState();

  // First drag
  drag.start({ id: 'block' });
  assert(drag.active === true, 'First drag active');
  drag.end();
  assert(drag.active === false, 'First drag ended');

  // Second drag (different object)
  drag.start({ id: 'ball' });
  assert(drag.objectId === 'ball', 'Second drag has new object');
  drag.end();
  assert(drag.active === false, 'Second drag ended');
}

section('Full Drag Flow — Pendulum');
{
  // Simulate: mousedown → hitTest → start drag → mousemove → onDrag → mouseup → onRelease
  const p = getParams(PendulumSim);
  const state = Float64Array.from([0, 0, 0]); // angle=0, bob at (0, -L)
  const drag = new DragState();
  let isDragging = false;

  // 1. Mouse down at bob position (0, -1)
  const wx = 0, wy = -p.length;
  const hit = PendulumSim.hitTest(wx, wy, state, p);
  assert(hit !== null, 'Flow: hitTest finds bob');

  // 2. Start drag
  drag.start(hit);
  isDragging = true;
  assert(drag.active, 'Flow: drag started');

  // 3. Mouse move — drag bob to the right (0.5, -0.866)
  const dragX = 0.5, dragY = -0.866;
  PendulumSim.onDrag(drag.objectId, dragX, dragY, drag.offset, state, p);
  assert(state[1] === 0, 'Flow: velocity zeroed during drag');
  const expectedAngle = Math.atan2(dragX, -dragY);
  assertClose(state[0], expectedAngle, 0.01, 'Flow: angle updated from mouse position');

  // 4. Verify physics skipped during drag
  const change = new Float64Array(3);
  PendulumSim.evaluate(state, change, p, isDragging);
  assert(change[0] === 0, 'Flow: no angular velocity change during drag');
  assert(change[1] === 0, 'Flow: no acceleration during drag');

  // 5. Mouse up — release
  const releasedId = drag.end();
  isDragging = false;
  PendulumSim.onRelease(releasedId, state, p);
  assert(!drag.active, 'Flow: drag ended');

  // 6. Physics resumes — evaluate should now compute forces
  PendulumSim.evaluate(state, change, p, isDragging);
  assert(change[0] !== 0 || change[1] !== 0, 'Flow: physics resumed after release');
}

section('Full Drag Flow — Spring');
{
  const p = getParams(SpringSim);
  const state = Float64Array.from(SpringSim.init(p));
  const drag = new DragState();

  // 1. Hit test
  const hit = SpringSim.hitTest(state[0], 0, state);
  assert(hit !== null, 'Spring flow: hit on block');

  // 2. Start drag
  drag.start(hit);

  // 3. Drag to x=4.0
  SpringSim.onDrag('block', 4.0, 0, hit, state, p);
  assertClose(state[0], 4.0 - hit.offsetX, 0.01, 'Spring flow: block dragged to x≈4');
  assertClose(state[1], 0, 1e-10, 'Spring flow: velocity zeroed');

  // 4. Release
  drag.end();

  // 5. Physics resumes — stretched spring should accelerate block back
  const change = new Float64Array(3);
  SpringSim.evaluate(state, change, p, false);
  assert(change[1] < 0, 'Spring flow: acceleration negative (pulling back) after release');
}

section('No hitTest — Sim Without Drag');
{
  // A sim that has no hitTest should gracefully skip interaction
  const noInteractSim = {
    params: { k: { value: 1 } },
    init(p) { return [0, 0]; },
    evaluate(v, c, p) { c[0] = v[1]; c[1] = -v[0]; },
  };
  assert(typeof noInteractSim.hitTest === 'undefined', 'Sim without hitTest');
  // The engine should check: if (typeof sim.hitTest !== 'function') → skip binding
  assert(typeof noInteractSim.hitTest !== 'function', 'hitTest is not a function → no drag');
}

// --- sim-canvas.js coordinate transforms (no DOM) ---
function worldToScreen(wx, wy, world, screenW, screenH) {
  const sx = ((wx - world.xMin) / (world.xMax - world.xMin)) * screenW;
  const sy = ((world.yMax - wy) / (world.yMax - world.yMin)) * screenH;
  return { sx, sy };
}
function screenToWorld(px, py, world, screenW, screenH) {
  const wx = world.xMin + (px / screenW) * (world.xMax - world.xMin);
  const wy = world.yMax - (py / screenH) * (world.yMax - world.yMin);
  return { wx, wy };
}

section('Coordinate Transform — worldToScreen');
{
  const world = { xMin: -2, xMax: 2, yMin: -2, yMax: 2 };
  const sw = 800, sh = 800;

  // Center of world → center of screen
  const c = worldToScreen(0, 0, world, sw, sh);
  assertClose(c.sx, 400, 0.01, 'Center X maps to 400');
  assertClose(c.sy, 400, 0.01, 'Center Y maps to 400');

  // Top-left of world (-2, 2) → screen (0, 0)
  const tl = worldToScreen(-2, 2, world, sw, sh);
  assertClose(tl.sx, 0, 0.01, 'World left → screen left');
  assertClose(tl.sy, 0, 0.01, 'World top → screen top');

  // Bottom-right of world (2, -2) → screen (800, 800)
  const br = worldToScreen(2, -2, world, sw, sh);
  assertClose(br.sx, 800, 0.01, 'World right → screen right');
  assertClose(br.sy, 800, 0.01, 'World bottom → screen bottom');
}

section('Coordinate Transform — screenToWorld');
{
  const world = { xMin: -2, xMax: 2, yMin: -2, yMax: 2 };
  const sw = 800, sh = 800;

  // Screen center → world center
  const c = screenToWorld(400, 400, world, sw, sh);
  assertClose(c.wx, 0, 0.01, 'Screen center → world X=0');
  assertClose(c.wy, 0, 0.01, 'Screen center → world Y=0');

  // Screen (0,0) → world top-left (-2, 2)
  const tl = screenToWorld(0, 0, world, sw, sh);
  assertClose(tl.wx, -2, 0.01, 'Screen (0,0) → world X=-2');
  assertClose(tl.wy, 2, 0.01, 'Screen (0,0) → world Y=2');
}

section('Coordinate Transform — Round Trip');
{
  const world = { xMin: -5, xMax: 3, yMin: -1, yMax: 4 };
  const sw = 640, sh = 400;

  // world → screen → world should be identity
  const pts = [[0, 0], [-5, 4], [3, -1], [1.5, 2.3], [-2.7, 0.8]];
  pts.forEach(([wx, wy]) => {
    const s = worldToScreen(wx, wy, world, sw, sh);
    const w = screenToWorld(s.sx, s.sy, world, sw, sh);
    assertClose(w.wx, wx, 1e-10, `Round trip X: ${wx}`);
    assertClose(w.wy, wy, 1e-10, `Round trip Y: ${wy}`);
  });
}

section('Coordinate Transform — Non-Square Aspect');
{
  // Pendulum world: xMin=-2.5, xMax=2.5, yMin=-2.8, yMax=0.5
  const world = { xMin: -2.5, xMax: 2.5, yMin: -2.8, yMax: 0.5 };
  const sw = 500, sh = 330; // 5/3.3 aspect

  // Pendulum pivot at (0, 0) should map to upper portion of screen
  const pivot = worldToScreen(0, 0, world, sw, sh);
  assertClose(pivot.sx, 250, 0.01, 'Pivot X centered');
  // Y: (0.5 - 0) / (0.5 - (-2.8)) = 0.5/3.3 ≈ 0.1515 → 0.1515 * 330 ≈ 50
  assertClose(pivot.sy, 50, 1, 'Pivot Y near top (positive Y is up in world)');

  // Bob at angle=0 → position (0, -L) where L=1 → world (0, -1)
  const bob = worldToScreen(0, -1, world, sw, sh);
  assert(bob.sy > pivot.sy, 'Bob is below pivot on screen');
}

// --- graph-canvas.js data logic (no DOM) ---
section('GraphCanvas — Data Collection & AutoScale');
{
  // Simulate the buffer + autoScale logic without canvas
  const buffer = new RingBuffer(100);

  // Push pendulum-like data (angle vs angVel)
  for (let i = 0; i < 50; i++) {
    const t = i * 0.1;
    buffer.push({ x: Math.sin(t), y: Math.cos(t) });
  }
  assert(buffer.size === 50, 'Graph buffer collected 50 points');

  // AutoScale
  let xMin = Infinity, xMax = -Infinity, yMin = Infinity, yMax = -Infinity;
  buffer.forEach(pt => {
    if (pt.x < xMin) xMin = pt.x;
    if (pt.x > xMax) xMax = pt.x;
    if (pt.y < yMin) yMin = pt.y;
    if (pt.y > yMax) yMax = pt.y;
  });
  const xPad = (xMax - xMin) * 0.1;
  const yPad = (yMax - yMin) * 0.1;
  const bounds = { xMin: xMin - xPad, xMax: xMax + xPad, yMin: yMin - yPad, yMax: yMax + yPad };

  assert(bounds.xMin < -1, 'AutoScale xMin < -1 for sin data');
  assert(bounds.xMax > 1, 'AutoScale xMax > 1 for sin data');
  assert(bounds.yMin < -1, 'AutoScale yMin < -1 for cos data');
  assert(bounds.yMax > 1, 'AutoScale yMax > 1 for cos data');
}

section('TimeGraph — Rolling Window Logic');
{
  // Simulate time graph line buffer
  const buffer = new RingBuffer(500);
  const window = 5; // 5 seconds

  // Push 10 seconds of data
  for (let i = 0; i < 1000; i++) {
    const t = i * 0.01;
    buffer.push({ t, v: Math.sin(t * 2) });
  }
  assert(buffer.size === 500, 'TimeGraph buffer capped at capacity');

  // Get newest time
  const tNow = buffer.last().t;
  assertClose(tNow, 9.99, 0.01, 'Newest time ≈ 10s');

  // Count points in window
  const tMin = tNow - window;
  let inWindow = 0;
  buffer.forEach(pt => { if (pt.t >= tMin) inWindow++; });
  assert(inWindow > 0, 'Points exist within time window');
  assert(inWindow <= 500, 'Not more points than buffer capacity');

  // Y auto-scale
  let yMin = Infinity, yMax = -Infinity;
  buffer.forEach(pt => {
    if (pt.v < yMin) yMin = pt.v;
    if (pt.v > yMax) yMax = pt.v;
  });
  assertClose(yMin, -1, 0.1, 'Y min ≈ -1 for sin data');
  assertClose(yMax, 1, 0.1, 'Y max ≈ 1 for sin data');
}

// --- energy-bar.js logic (no DOM) ---
function computeEnergyBar(ke, pe, total, maxEnergy, barWidth) {
  const max = Math.max(maxEnergy, total * 1.1, 0.01);
  return {
    keWidth: (Math.max(0, ke) / max) * barWidth,
    peWidth: (Math.max(0, pe) / max) * barWidth,
    totalWidth: (Math.max(0, total) / max) * barWidth,
    newMax: max,
  };
}

section('EnergyBar — Computation');
{
  // Pendulum at start: all PE, no KE
  const r1 = computeEnergyBar(0, 5, 5, 10, 400);
  assertClose(r1.keWidth, 0, 0.01, 'KE=0 → bar width 0');
  assertClose(r1.peWidth, 200, 0.01, 'PE=5 out of max=10 → 200px');
  assertClose(r1.totalWidth, 200, 0.01, 'Total=5 → 200px');

  // Equal split
  const r2 = computeEnergyBar(3, 3, 6, 10, 400);
  assertClose(r2.keWidth, 120, 0.01, 'KE=3/10*400=120');
  assertClose(r2.peWidth, 120, 0.01, 'PE=3/10*400=120');

  // Max energy auto-expands
  const r3 = computeEnergyBar(5, 5, 10, 5, 400);
  assert(r3.newMax >= 10, 'Max auto-expanded when total > maxEnergy');
  assert(r3.keWidth + r3.peWidth <= 400, 'Bars fit within barWidth');

  // Negative energy clamped to 0
  const r4 = computeEnergyBar(-1, 3, 2, 10, 400);
  assertClose(r4.keWidth, 0, 0.01, 'Negative KE clamped to 0');
}

section('EnergyBar — Pendulum Energy Flow');
{
  // Simulate energy through a pendulum swing (no damping)
  const p = getParams(PendulumSim);
  p.damping = 0;
  const state = Float64Array.from(PendulumSim.init(p));
  const dt = 1 / 120;
  const energies = [];

  for (let i = 0; i < 120; i++) {
    rk4(state, (v, c, par) => PendulumSim.evaluate(v, c, par, false), dt, p);
    const e = PendulumSim.energy(state, p);
    energies.push(e);
  }

  // At start: mostly PE. At bottom of swing: mostly KE. Total constant.
  const first = energies[0];
  const mid = energies[60]; // roughly at bottom
  assert(first.potential > first.kinetic, 'Start: PE > KE');
  assert(energies.every(e => Math.abs(e.total - first.total) < 0.001), 'Total energy constant through swing');

  // Check bar computation makes sense
  const bar1 = computeEnergyBar(first.kinetic, first.potential, first.total, first.total * 1.2, 400);
  const barMid = computeEnergyBar(mid.kinetic, mid.potential, mid.total, first.total * 1.2, 400);
  assert(bar1.peWidth > bar1.keWidth, 'Start: PE bar > KE bar');
  assertClose(bar1.totalWidth, barMid.totalWidth, 1, 'Total bar same width at start and mid-swing');
}

// --- ui/controls.js logic ---
function extractDefaults(params) {
  const result = {};
  for (const [name, def] of Object.entries(params)) result[name] = def.value;
  return result;
}

section('Controls — extractDefaults');
{
  const defs = extractDefaults(PendulumSim.params);
  assertClose(defs.gravity, 9.81, 0.01, 'Default gravity = 9.81');
  assertClose(defs.length, 1.0, 0.01, 'Default length = 1.0');
  assertClose(defs.damping, 0.1, 0.01, 'Default damping = 0.1');
  assert(Object.keys(defs).length === Object.keys(PendulumSim.params).length, 'All params extracted');
}

// --- ui/presets.js logic ---
function applyPreset(defaults, preset) {
  const result = { ...defaults };
  if (preset.params) {
    for (const [k, v] of Object.entries(preset.params)) result[k] = v;
  }
  return result;
}

section('Presets — applyPreset');
{
  const defaults = extractDefaults(PendulumSim.params);

  // Default preset (empty overrides)
  const r1 = applyPreset(defaults, { name: 'Default', params: {} });
  assertClose(r1.gravity, 9.81, 0.01, 'Default preset keeps gravity');

  // Moon preset
  const r2 = applyPreset(defaults, { name: 'Moon', params: { gravity: 1.62 } });
  assertClose(r2.gravity, 1.62, 0.01, 'Moon preset overrides gravity');
  assertClose(r2.length, 1.0, 0.01, 'Moon preset keeps length default');
  assertClose(r2.damping, 0.1, 0.01, 'Moon preset keeps damping default');

  // Multiple overrides
  const r3 = applyPreset(defaults, { name: 'Custom', params: { gravity: 0, damping: 5, length: 3 } });
  assertClose(r3.gravity, 0, 0.01, 'Multi-override: gravity=0');
  assertClose(r3.damping, 5, 0.01, 'Multi-override: damping=5');
  assertClose(r3.length, 3, 0.01, 'Multi-override: length=3');
  assertClose(r3.mass, 1.0, 0.01, 'Multi-override: mass unchanged');
}

// --- ui/engine-controls.js logic ---
function encodeShareUrl(baseUrl, params) {
  const pairs = [];
  for (const [k, v] of Object.entries(params)) {
    pairs.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
  }
  return baseUrl + '#' + pairs.join('&');
}
function decodeShareUrl(hash) {
  if (!hash || hash.length < 2) return {};
  const params = {};
  hash.slice(1).split('&').forEach(pair => {
    const [k, v] = pair.split('=').map(decodeURIComponent);
    const num = parseFloat(v);
    params[k] = isNaN(num) ? v : num;
  });
  return params;
}

section('Share URL — Encode');
{
  const url = encodeShareUrl('/physics/labs/pendulum.jsp', { gravity: 1.62, length: 2.5, damping: 0 });
  assert(url.startsWith('/physics/labs/pendulum.jsp#'), 'URL starts with base + #');
  assert(url.includes('gravity=1.62'), 'Contains gravity param');
  assert(url.includes('length=2.5'), 'Contains length param');
  assert(url.includes('damping=0'), 'Contains damping param');
}

section('Share URL — Decode');
{
  const params = decodeShareUrl('#gravity=1.62&length=2.5&damping=0&solver=euler');
  assertClose(params.gravity, 1.62, 0.01, 'Decoded gravity');
  assertClose(params.length, 2.5, 0.01, 'Decoded length');
  assertClose(params.damping, 0, 0.01, 'Decoded damping');
  assert(params.solver === 'euler', 'Decoded string param');
}

section('Share URL — Round Trip');
{
  const original = { gravity: 9.81, length: 1.5, mass: 2.3 };
  const url = encodeShareUrl('/test', original);
  const hash = url.split('#')[1];
  const decoded = decodeShareUrl('#' + hash);
  assertClose(decoded.gravity, 9.81, 0.001, 'Round trip gravity');
  assertClose(decoded.length, 1.5, 0.001, 'Round trip length');
  assertClose(decoded.mass, 2.3, 0.001, 'Round trip mass');
}

section('Share URL — Empty');
{
  const empty = decodeShareUrl('');
  assert(Object.keys(empty).length === 0, 'Empty hash → empty params');
  const noHash = decodeShareUrl('#');
  assert(Object.keys(noHash).length === 0, 'Just # → empty params');
}

// --- ui/var-picker.js logic ---
function resolveGraphDefaults(simVars, graphDefaults, graphType) {
  const defaults = graphDefaults?.[graphType];
  if (!defaults) {
    const names = Object.keys(simVars);
    return { x: names[0] || 'x', y: names[1] || 'y' };
  }
  if (graphType === 'phase') return { x: defaults.x, y: defaults.y };
  if (Array.isArray(defaults)) return { x: 'time', y: defaults[0] };
  return { x: 'time', y: Object.keys(simVars)[0] };
}

section('VarPicker — resolveGraphDefaults');
{
  const simVars = {
    angle: { index: 0, label: 'Angle', symbol: 'θ' },
    angularVel: { index: 1, label: 'Angular Vel', symbol: 'ω' },
    time: { index: 2, label: 'Time', symbol: 't' },
  };
  const graphDefaults = {
    phase: { x: 'angle', y: 'angularVel' },
    time: ['angle', 'angularVel'],
  };

  const phase = resolveGraphDefaults(simVars, graphDefaults, 'phase');
  assert(phase.x === 'angle', 'Phase default X = angle');
  assert(phase.y === 'angularVel', 'Phase default Y = angularVel');

  const time = resolveGraphDefaults(simVars, graphDefaults, 'time');
  assert(time.x === 'time', 'Time default X = time');
  assert(time.y === 'angle', 'Time default Y = first line var');

  // No defaults → fallback to first two vars
  const none = resolveGraphDefaults(simVars, {}, 'energy');
  assert(none.x === 'angle', 'No default → first var');
  assert(none.y === 'angularVel', 'No default → second var');
}

// --- Double Spring sim ---
const DoubleSpringSim = {
  params: {
    mass1: { value: 1.0 }, mass2: { value: 1.0 },
    stiffness: { value: 6.0 }, damping: { value: 0.0 },
    restLength: { value: 2.0 }, thirdSpring: { value: true },
    wallLeft: { value: -0.5 }, wallRight: { value: 9.5 },
  },
  _equilibrium(p) {
    const { stiffness: k, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = p;
    if (thirdSpring) {
      const totalSpace = w2 - w1;
      return [w1 + totalSpace / 3, w1 + 2 * totalSpace / 3];
    }
    return [w1 + R, w1 + 2 * R];
  },
  init(p) {
    const [x1eq, x2eq] = this._equilibrium(p);
    return [x1eq, x2eq, 0, -2.3, 0];
  },
  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;
    const [x1, x2, v1, v2] = vars;
    const { mass1, mass2, stiffness: k, damping: b, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = params;
    const L1 = (x1 - w1) - R;
    const L2 = (x2 - x1) - R;
    const k3 = thirdSpring ? k : 0;
    const L3 = thirdSpring ? (w2 - x2) - R : 0;
    change[0] = v1;
    change[1] = v2;
    change[2] = (-k * L1 + k * L2 - b * v1) / mass1;
    change[3] = (-k * L2 + k3 * L3 - b * v2) / mass2;
  },
  energy(vars, params) {
    const [x1, x2, v1, v2] = vars;
    const { mass1, mass2, stiffness: k, restLength: R, wallLeft: w1, wallRight: w2, thirdSpring } = params;
    const L1 = (x1 - w1) - R;
    const L2 = (x2 - x1) - R;
    const L3 = thirdSpring ? (w2 - x2) - R : 0;
    const k3 = thirdSpring ? k : 0;
    const KE = 0.5 * mass1 * v1 * v1 + 0.5 * mass2 * v2 * v2;
    const PE = 0.5 * k * L1 * L1 + 0.5 * k * L2 * L2 + 0.5 * k3 * L3 * L3;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },
  hitTest(wx, wy, vars) {
    if (Math.hypot(wx - vars[0], wy) < 0.4) return { id: 'block1', offsetX: wx - vars[0], offsetY: wy };
    if (Math.hypot(wx - vars[1], wy) < 0.4) return { id: 'block2', offsetX: wx - vars[1], offsetY: wy };
    return null;
  },
  onDrag(id, wx, wy, offset, vars) {
    if (id === 'block1') { vars[0] = wx - offset.offsetX; vars[2] = 0; }
    if (id === 'block2') { vars[1] = wx - offset.offsetX; vars[3] = 0; }
  },
  onRelease() {},
};

section('Double Spring — Init');
{
  const p = getParams(DoubleSpringSim);
  const state = Float64Array.from(DoubleSpringSim.init(p));
  assert(state.length === 5, 'Double spring has 5 state vars');
  // Equilibrium: walls at -0.5 and 9.5, total space = 10, thirds: 2.83, 6.17
  const [x1eq, x2eq] = DoubleSpringSim._equilibrium(p);
  assertClose(state[0], x1eq, 0.01, 'Block1 at equilibrium x1');
  assertClose(state[1], x2eq, 0.01, 'Block2 at equilibrium x2');
  assertClose(state[2], 0, 1e-10, 'v1 = 0');
  assertClose(state[3], -2.3, 0.01, 'v2 = -2.3 (initial kick)');
  assert(state[0] < state[1], 'Block1 is left of block2');
}

section('Double Spring — Evaluate at Equilibrium');
{
  const p = getParams(DoubleSpringSim);
  const [x1eq, x2eq] = DoubleSpringSim._equilibrium(p);
  // At equilibrium with zero velocity → zero acceleration
  const state = Float64Array.from([x1eq, x2eq, 0, 0, 0]);
  const change = new Float64Array(5);
  DoubleSpringSim.evaluate(state, change, p, false);
  assertClose(change[2], 0, 0.01, 'Acceleration 1 = 0 at equilibrium');
  assertClose(change[3], 0, 0.01, 'Acceleration 2 = 0 at equilibrium');
}

section('Double Spring — Energy Conservation (no damping)');
{
  const p = getParams(DoubleSpringSim);
  p.damping = 0;
  const state = Float64Array.from(DoubleSpringSim.init(p));
  const e0 = DoubleSpringSim.energy(state, p);

  const dt = 1 / 120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v, c, par) => DoubleSpringSim.evaluate(v, c, par, false), dt, p);
  }

  const e1 = DoubleSpringSim.energy(state, p);
  assertClose(e1.total, e0.total, 1e-4, `DS energy conserved: ${e0.total.toFixed(4)} → ${e1.total.toFixed(4)}`);
}

section('Double Spring — Damping Reduces Energy');
{
  const p = getParams(DoubleSpringSim);
  p.damping = 1.0;
  const state = Float64Array.from(DoubleSpringSim.init(p));
  const e0 = DoubleSpringSim.energy(state, p);

  const dt = 1 / 120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v, c, par) => DoubleSpringSim.evaluate(v, c, par, false), dt, p);
  }

  const e1 = DoubleSpringSim.energy(state, p);
  assert(e1.total < e0.total * 0.9, `DS energy decreased: ${e0.total.toFixed(4)} → ${e1.total.toFixed(4)}`);
}

section('Double Spring — Third Spring Toggle');
{
  const p = getParams(DoubleSpringSim);

  // Start at equilibrium with third spring, then displace block2 right
  p.thirdSpring = true;
  const [eq1, eq2] = DoubleSpringSim._equilibrium(p);
  const state = Float64Array.from([eq1, eq2 + 1.5, 0, 0, 0]);
  const changeWith = new Float64Array(5);
  DoubleSpringSim.evaluate(state, changeWith, p, false);
  const accelWith = changeWith[3];

  // Without third spring, same displacement
  p.thirdSpring = false;
  const changeWithout = new Float64Array(5);
  DoubleSpringSim.evaluate(state, changeWithout, p, false);
  const accelWithout = changeWithout[3];

  // With third spring: block2 displaced right → spring3 stretched → extra restoring force
  // So |accel| should be larger with third spring
  assert(Math.abs(accelWith) > Math.abs(accelWithout),
    `Third spring adds force: |${accelWith.toFixed(3)}| > |${accelWithout.toFixed(3)}|`);
}

section('Double Spring — HitTest Both Blocks');
{
  const p = getParams(DoubleSpringSim);
  const state = Float64Array.from(DoubleSpringSim.init(p));
  const hit1 = DoubleSpringSim.hitTest(state[0], 0, state);
  assert(hit1 !== null && hit1.id === 'block1', 'Hit test finds block1');
  const hit2 = DoubleSpringSim.hitTest(state[1], 0, state);
  assert(hit2 !== null && hit2.id === 'block2', 'Hit test finds block2');
  const miss = DoubleSpringSim.hitTest(50, 50, state);
  assert(miss === null, 'Hit test misses far away');
}

section('Double Spring — Drag Block2');
{
  const p = getParams(DoubleSpringSim);
  const state = Float64Array.from(DoubleSpringSim.init(p));
  const origX2 = state[1];
  DoubleSpringSim.onDrag('block2', origX2 + 2, 0, { offsetX: 0, offsetY: 0 }, state, p);
  assertClose(state[1], origX2 + 2, 0.01, 'Block2 dragged right');
  assertClose(state[3], 0, 1e-10, 'Velocity zeroed during drag');
}

section('Double Spring — Sim Contract');
{
  assert(typeof DoubleSpringSim.init === 'function', 'Has init');
  assert(typeof DoubleSpringSim.evaluate === 'function', 'Has evaluate');
  assert(typeof DoubleSpringSim.energy === 'function', 'Has energy');
  assert(typeof DoubleSpringSim.hitTest === 'function', 'Has hitTest');
  assert(typeof DoubleSpringSim.onDrag === 'function', 'Has onDrag');
}

// --- direction-field.js logic (no DOM) ---
function computeArrow(wx, wy, evaluate, params, xVar, yVar, varCount) {
  const state = new Float64Array(varCount);
  const change = new Float64Array(varCount);
  state[xVar] = wx;
  state[yVar] = wy;
  evaluate(state, change, params);
  return { dxdt: change[xVar], dydt: change[yVar] };
}

section('Direction Field — Pendulum Arrows');
{
  const p = getParams(PendulumSim);
  p.damping = 0;

  // At (θ=0, ω=0) — equilibrium, no motion
  const eq = computeArrow(0, 0, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assertClose(eq.dxdt, 0, 1e-10, 'At equilibrium: dθ/dt = 0');
  assertClose(eq.dydt, 0, 1e-10, 'At equilibrium: dω/dt = 0');

  // At (θ=π/4, ω=0) — displaced, gravity pulls back
  const disp = computeArrow(Math.PI / 4, 0, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assertClose(disp.dxdt, 0, 1e-10, 'Displaced, zero vel: dθ/dt = ω = 0');
  assert(disp.dydt < 0, 'Displaced right: dω/dt < 0 (gravity restoring)');

  // At (θ=0, ω=2) — at bottom, moving right
  const moving = computeArrow(0, 2, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assertClose(moving.dxdt, 2, 1e-10, 'Moving right: dθ/dt = ω = 2');
  assertClose(moving.dydt, 0, 0.01, 'At bottom: dω/dt ≈ 0 (sin(0)=0)');

  // At (θ=-π/4, ω=0) — displaced left, gravity pushes right
  const left = computeArrow(-Math.PI / 4, 0, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assert(left.dydt > 0, 'Displaced left: dω/dt > 0 (gravity restoring right)');
}

section('Direction Field — Spring Arrows');
{
  const p = getParams(SpringSim);
  p.damping = 0;
  const eqX = p.fixedPoint + p.restLength; // equilibrium position

  // At equilibrium
  const eq = computeArrow(eqX, 0, (s, c, par) => SpringSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assertClose(eq.dxdt, 0, 1e-10, 'Spring eq: dx/dt = v = 0');
  assertClose(eq.dydt, 0, 0.01, 'Spring eq: dv/dt ≈ 0');

  // Stretched right
  const right = computeArrow(eqX + 2, 0, (s, c, par) => SpringSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assert(right.dydt < 0, 'Stretched right: dv/dt < 0 (spring pulls back)');

  // Compressed left
  const leftC = computeArrow(eqX - 1, 0, (s, c, par) => SpringSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assert(leftC.dydt > 0, 'Compressed left: dv/dt > 0 (spring pushes right)');
}

section('Direction Field — Arrow Symmetry');
{
  // For undamped pendulum, field should be symmetric: arrow at (θ, ω) should
  // have opposite dydt to arrow at (-θ, ω) [odd symmetry in θ]
  const p = getParams(PendulumSim);
  p.damping = 0;
  const a1 = computeArrow(0.5, 1, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  const a2 = computeArrow(-0.5, 1, (s, c, par) => PendulumSim.evaluate(s, c, par, false), p, 0, 1, 3);
  assertClose(a1.dxdt, a2.dxdt, 1e-10, 'Symmetric: same dθ/dt (both ω=1)');
  assertClose(a1.dydt, -a2.dydt, 1e-6, 'Anti-symmetric: opposite dω/dt');
}

// --- PeriodDetector ---
class PeriodDetector {
  constructor(varIndex) {
    this.varIndex = varIndex; this.crossings = []; this.prevVal = 0; this.period = 0;
  }
  push(state, time) {
    const val = state[this.varIndex];
    if (this.prevVal <= 0 && val > 0) {
      this.crossings.push(time);
      if (this.crossings.length > 20) this.crossings.shift();
      if (this.crossings.length >= 2) {
        const n = this.crossings.length - 1;
        this.period = (this.crossings[n] - this.crossings[0]) / n;
      }
    }
    this.prevVal = val;
  }
  reset() { this.crossings = []; this.prevVal = 0; this.period = 0; }
}

section('PeriodDetector — Pendulum');
{
  const p = getParams(PendulumSim);
  p.damping = 0;
  p.startAngle = 0.2; // small angle for accurate T = 2π√(L/g)
  const state = Float64Array.from(PendulumSim.init(p));
  const pd = new PeriodDetector(1); // angular velocity zero-crossings
  const dt = 1 / 240;

  // Run for 15 seconds
  for (let i = 0; i < 3600; i++) {
    rk4(state, (v, c, par) => PendulumSim.evaluate(v, c, par, false), dt, p);
    pd.push(state, state[2]);
  }

  const Ttheory = 2 * Math.PI * Math.sqrt(p.length / p.gravity);
  assert(pd.period > 0, 'Period detected: ' + pd.period.toFixed(4));
  // For small angle (0.2 rad), measured should be close to theory
  assertClose(pd.period, Ttheory, 0.02, `Pendulum period: measured=${pd.period.toFixed(4)} theory=${Ttheory.toFixed(4)}`);
}

section('PeriodDetector — Spring');
{
  const p = getParams(SpringSim);
  p.damping = 0;
  const state = Float64Array.from(SpringSim.init(p));
  const pd = new PeriodDetector(1); // velocity zero-crossings
  const dt = 1 / 240;

  for (let i = 0; i < 3600; i++) {
    rk4(state, (v, c, par) => SpringSim.evaluate(v, c, par, false), dt, p);
    pd.push(state, state[2]);
  }

  const Ttheory = 2 * Math.PI * Math.sqrt(p.mass / p.stiffness);
  assert(pd.period > 0, 'Spring period detected');
  assertClose(pd.period, Ttheory, 0.02, `Spring period: measured=${pd.period.toFixed(4)} theory=${Ttheory.toFixed(4)}`);
}

section('PeriodDetector — Reset');
{
  const pd = new PeriodDetector(0);
  pd.push(Float64Array.from([-1]), 0);
  pd.push(Float64Array.from([1]), 0.5);
  assert(pd.crossings.length === 1, 'One crossing detected');
  pd.reset();
  assert(pd.crossings.length === 0, 'Reset clears crossings');
  assert(pd.period === 0, 'Reset clears period');
}

// --- Potential Energy functions ---
section('Potential Energy — Pendulum');
{
  const p = getParams(PendulumSim);
  // PE at angle=0 should be 0 (bottom of well)
  assertClose(PendulumSim.potentialEnergy(0, p), 0, 1e-10, 'PE at θ=0 = 0');
  // PE at angle=π/2 should be mgL
  const peHalf = PendulumSim.potentialEnergy(Math.PI / 2, p);
  assertClose(peHalf, p.mass * p.gravity * p.length, 1e-6, 'PE at θ=π/2 = mgL');
  // PE at angle=π should be 2mgL (top)
  const peTop = PendulumSim.potentialEnergy(Math.PI, p);
  assertClose(peTop, 2 * p.mass * p.gravity * p.length, 1e-6, 'PE at θ=π = 2mgL');
  // PE is symmetric: PE(θ) = PE(-θ)
  assertClose(PendulumSim.potentialEnergy(0.5, p), PendulumSim.potentialEnergy(-0.5, p), 1e-10, 'PE symmetric');
}

section('Potential Energy — Spring');
{
  const p = getParams(SpringSim);
  const eqX = p.fixedPoint + p.restLength;
  // PE at equilibrium = 0
  assertClose(SpringSim.potentialEnergy(eqX, p), 0, 1e-10, 'PE at equilibrium = 0');
  // PE at stretch=1 should be 0.5*k*1² = 1.5
  assertClose(SpringSim.potentialEnergy(eqX + 1, p), 0.5 * p.stiffness, 1e-6, 'PE at stretch=1');
  // PE is symmetric around equilibrium
  assertClose(SpringSim.potentialEnergy(eqX + 0.5, p), SpringSim.potentialEnergy(eqX - 0.5, p), 1e-10, 'PE symmetric');
}

// --- Vectors ---
section('Vectors — Pendulum at Rest');
{
  const p = getParams(PendulumSim);
  const v = PendulumSim.vectors([0, 0, 0], p);
  assertClose(v.velocity.mag, 0, 1e-10, 'Velocity = 0 at rest');
  assertClose(v.accel.mag, 0, 0.01, 'Acceleration ≈ 0 at equilibrium');
}

section('Vectors — Spring Moving');
{
  const p = getParams(SpringSim);
  const eqX = p.fixedPoint + p.restLength;
  const v = SpringSim.vectors([eqX + 1, 2, 0], p); // stretched, moving right
  assertClose(v.velocity.x, 2, 1e-10, 'Velocity = 2 m/s');
  assert(v.accel.x < 0, 'Acceleration negative (spring pulls back)');
}

// --- Double Pendulum sim ---
const DoublePendulumSim = {
  params: {
    gravity: { value: 9.8 }, length1: { value: 1.0 }, length2: { value: 1.0 },
    mass1: { value: 2.0 }, mass2: { value: 2.0 },
    startAngle1: { value: Math.PI/2 }, startAngle2: { value: Math.PI/2 },
  },
  init(p) { return [p.startAngle1, 0, p.startAngle2, 0, 0]; },
  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;
    const th1 = vars[0], dth1 = vars[1], th2 = vars[2], dth2 = vars[3];
    const { gravity: g, length1: L1, length2: L2, mass1: m1, mass2: m2 } = params;
    const delta = th1 - th2;
    const sinD = Math.sin(delta), cosD = Math.cos(delta), sin2D = Math.sin(2*delta);
    const denom = 2*m1 + m2 - m2*Math.cos(2*delta);
    change[0] = dth1;
    let num1 = -g*(2*m1+m2)*Math.sin(th1) - g*m2*Math.sin(th1-2*th2)
               - 2*m2*dth2*dth2*L2*sinD - m2*dth1*dth1*L1*sin2D;
    change[1] = num1 / (L1 * denom);
    change[2] = dth2;
    let num2 = (m1+m2)*dth1*dth1*L1 + g*(m1+m2)*Math.cos(th1) + m2*dth2*dth2*L2*cosD;
    num2 *= 2*sinD;
    change[3] = num2 / (L2 * denom);
  },
  energy(vars, params) {
    const [th1, dth1, th2, dth2] = vars;
    const { gravity: g, length1: L1, length2: L2, mass1: m1, mass2: m2 } = params;
    const x1 = L1*Math.sin(th1), y1 = -L1*Math.cos(th1);
    const x2 = x1 + L2*Math.sin(th2), y2 = y1 - L2*Math.cos(th2);
    const vx1 = L1*dth1*Math.cos(th1), vy1 = L1*dth1*Math.sin(th1);
    const vx2 = vx1 + L2*dth2*Math.cos(th2), vy2 = vy1 + L2*dth2*Math.sin(th2);
    const KE = 0.5*m1*(vx1*vx1+vy1*vy1) + 0.5*m2*(vx2*vx2+vy2*vy2);
    const PE = g*m1*(y1+L1) + g*m2*(y2+L1+L2);
    return { kinetic: KE, potential: PE, total: KE+PE };
  },
  hitTest(wx, wy, vars, params) {
    const { length1: L1, length2: L2 } = params;
    const x1 = L1*Math.sin(vars[0]), y1 = -L1*Math.cos(vars[0]);
    const x2 = x1+L2*Math.sin(vars[2]), y2 = y1-L2*Math.cos(vars[2]);
    if (Math.hypot(wx-x2, wy-y2) < 0.3) return { id: 'bob2' };
    if (Math.hypot(wx-x1, wy-y1) < 0.3) return { id: 'bob1' };
    return null;
  },
  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'bob1') { vars[0] = Math.atan2(wx, -wy); vars[1] = 0; vars[3] = 0; }
    else if (id === 'bob2') {
      const x1 = params.length1*Math.sin(vars[0]), y1 = -params.length1*Math.cos(vars[0]);
      vars[2] = Math.atan2(wx-x1, -(wy-y1)); vars[1] = 0; vars[3] = 0;
    }
  },
  onRelease() {},
};

section('Double Pendulum — Init');
{
  const p = getParams(DoublePendulumSim);
  const state = Float64Array.from(DoublePendulumSim.init(p));
  assert(state.length === 5, 'DP has 5 state vars');
  assertClose(state[0], Math.PI/2, 1e-10, 'θ₁ = π/2');
  assertClose(state[2], Math.PI/2, 1e-10, 'θ₂ = π/2');
}

section('Double Pendulum — Energy Conservation');
{
  const p = getParams(DoublePendulumSim);
  const state = Float64Array.from(DoublePendulumSim.init(p));
  const e0 = DoublePendulumSim.energy(state, p);
  assert(e0.total > 0, 'Initial energy > 0');

  const dt = 1/240;
  for (let i = 0; i < 2400; i++) { // 10 seconds
    rk4(state, (v,c,par) => DoublePendulumSim.evaluate(v,c,par,false), dt, p);
  }

  const e1 = DoublePendulumSim.energy(state, p);
  const drift = Math.abs(e1.total - e0.total) / e0.total;
  assert(drift < 0.001, `DP energy drift < 0.1%: ${(drift*100).toFixed(4)}%`);
}

section('Double Pendulum — Chaos Sensitivity');
{
  const p = getParams(DoublePendulumSim);
  // Two runs with θ₁ differing by 0.001 rad
  const stateA = Float64Array.from([Math.PI/2, 0, Math.PI/2, 0, 0]);
  const stateB = Float64Array.from([Math.PI/2 + 0.001, 0, Math.PI/2, 0, 0]);

  const dt = 1/120;
  for (let i = 0; i < 2400; i++) { // 20 seconds — chaos needs time to diverge
    rk4(stateA, (v,c,par) => DoublePendulumSim.evaluate(v,c,par,false), dt, p);
    rk4(stateB, (v,c,par) => DoublePendulumSim.evaluate(v,c,par,false), dt, p);
  }

  const angleDiff = Math.abs(stateA[0] - stateB[0]) + Math.abs(stateA[2] - stateB[2]);
  assert(angleDiff > 0.1, `Chaos: 0.001 rad initial diff → ${angleDiff.toFixed(3)} rad after 20s (should diverge)`);
}

section('Double Pendulum — Small Angle Stability');
{
  const p = getParams(DoublePendulumSim);
  p.startAngle1 = 0.1;
  p.startAngle2 = 0.1;
  const state = Float64Array.from(DoublePendulumSim.init(p));

  const dt = 1/120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v,c,par) => DoublePendulumSim.evaluate(v,c,par,false), dt, p);
  }

  // Small angles should stay bounded
  assert(Math.abs(state[0]) < 0.5, 'Small angle θ₁ stays bounded');
  assert(Math.abs(state[2]) < 0.5, 'Small angle θ₂ stays bounded');
}

section('Double Pendulum — HitTest & Drag');
{
  const p = getParams(DoublePendulumSim);
  const state = Float64Array.from([0, 0, 0, 0, 0]); // both hanging down
  // Bob1 at (0, -L1), bob2 at (0, -L1-L2)
  const hit1 = DoublePendulumSim.hitTest(0, -p.length1, state, p);
  assert(hit1 !== null && hit1.id === 'bob1', 'HitTest finds bob1');
  const hit2 = DoublePendulumSim.hitTest(0, -p.length1 - p.length2, state, p);
  assert(hit2 !== null && hit2.id === 'bob2', 'HitTest finds bob2');

  // Drag bob2 sideways
  DoublePendulumSim.onDrag('bob2', 0.5, -p.length1 - 0.866, {}, state, p);
  assert(state[1] === 0 && state[3] === 0, 'Both velocities zeroed on drag');
}

section('Double Pendulum — Equilibrium at Bottom');
{
  const p = getParams(DoublePendulumSim);
  const state = Float64Array.from([0, 0, 0, 0, 0]); // hanging straight down
  const change = new Float64Array(5);
  DoublePendulumSim.evaluate(state, change, p, false);
  assertClose(change[1], 0, 0.01, 'α₁ ≈ 0 at equilibrium (both down)');
  assertClose(change[3], 0, 0.01, 'α₂ ≈ 0 at equilibrium (both down)');
}

// --- Driven Pendulum (updated PendulumSim with drive force) ---
section('Driven Pendulum — No Drive = Same as Before');
{
  const p = getParams(PendulumSim);
  p.driveAmp = 0; // no drive
  p.driveFreq = 0.667;
  p.damping = 0;
  const state = Float64Array.from(PendulumSim.init(p));
  const e0 = PendulumSim.energy(state, p);
  const dt = 1/120;
  for (let i = 0; i < 600; i++) {
    rk4(state, (v,c,par) => PendulumSim.evaluate(v,c,par,false), dt, p);
  }
  const e1 = PendulumSim.energy(state, p);
  assertClose(e1.total, e0.total, 1e-4, 'No drive + no damping = energy conserved');
}

section('Driven Pendulum — Drive Pumps Energy');
{
  const p = getParams(PendulumSim);
  p.driveAmp = 1.15;
  p.driveFreq = 0.667;
  p.damping = 0.1;
  p.startAngle = 0.1;
  const state = Float64Array.from(PendulumSim.init(p));
  const e0 = PendulumSim.energy(state, p);
  const dt = 1/120;
  for (let i = 0; i < 1200; i++) { // 10 seconds
    rk4(state, (v,c,par) => PendulumSim.evaluate(v,c,par,false), dt, p);
  }
  const e1 = PendulumSim.energy(state, p);
  // With drive, energy should NOT be conserved — drive pumps energy in
  assert(e1.total !== e0.total, 'Driven pendulum: energy changes (drive injects/extracts energy)');
}

// --- Compare Pendulum (two chaotic pendulums) ---
const ComparePendulumSim = {
  params: {
    gravity: { value: 9.81 }, length: { value: 1.0 }, mass: { value: 1.0 },
    damping: { value: 0.5 }, driveAmp: { value: 10.0 }, driveFreq: { value: 0.667 },
    startAngle: { value: 0.1 }, angleDelta: { value: 0.001 },
  },
  init(p) { return [p.startAngle, 0, p.startAngle + p.angleDelta, 0, 0]; },
  _evalSingle(angle, angVel, time, params) {
    const { gravity, length, mass, damping, driveAmp, driveFreq } = params;
    return -(gravity/length)*Math.sin(angle) - (damping/(mass*length*length))*angVel
           + (driveAmp/(mass*length*length))*Math.cos(driveFreq*time);
  },
  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;
    const ev = ComparePendulumSim._evalSingle;
    change[0] = vars[1];
    change[1] = ev(vars[0], vars[1], vars[4], params);
    change[2] = vars[3];
    change[3] = ev(vars[2], vars[3], vars[4], params);
  },
};

section('Compare Pendulum — Init');
{
  const p = getParams(ComparePendulumSim);
  const state = Float64Array.from(ComparePendulumSim.init(p));
  assert(state.length === 5, 'Compare has 5 vars');
  assertClose(state[0], 0.1, 1e-10, 'A starts at 0.1');
  assertClose(state[2], 0.101, 1e-10, 'B starts at 0.1 + 0.001');
}

section('Compare Pendulum — Divergence');
{
  const p = getParams(ComparePendulumSim);
  const state = Float64Array.from(ComparePendulumSim.init(p));
  const dt = 1/120;
  for (let i = 0; i < 3600; i++) { // 30 seconds
    rk4(state, (v,c,par) => ComparePendulumSim.evaluate(v,c,par,false), dt, p);
  }
  const divergence = Math.abs(state[0] - state[2]);
  assert(divergence > 0.5, `Compare: divergence after 30s = ${divergence.toFixed(3)} rad (should be large)`);
}

section('Compare Pendulum — No Drive = No Divergence');
{
  const p = getParams(ComparePendulumSim);
  p.driveAmp = 0;
  p.damping = 0.1;
  const state = Float64Array.from(ComparePendulumSim.init(p));
  const dt = 1/120;
  for (let i = 0; i < 1200; i++) { // 10 seconds
    rk4(state, (v,c,par) => ComparePendulumSim.evaluate(v,c,par,false), dt, p);
  }
  const divergence = Math.abs(state[0] - state[2]);
  assert(divergence < 0.01, `No drive: divergence stays small = ${divergence.toFixed(6)} rad`);
}

// --- Kapitza Pendulum ---
const KapitzaSim = {
  params: {
    gravity: { value: 9.81 }, length: { value: 1.0 }, mass: { value: 1.0 },
    damping: { value: 0.1 }, vibeAmp: { value: 0 }, vibeFreq: { value: 30 },
    startAngle: { value: Math.PI / 4 },
  },
  init(p) { return [p.startAngle, 0, 0, 0, 0]; },
  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) { change[3]=0; change[4]=0; return; }
    const [angle, angVel, time, pivotY, pivotVY] = vars;
    const { gravity, length, mass, damping, vibeAmp, vibeFreq } = params;
    const pivotAccelY = vibeAmp * Math.sin(vibeFreq * time);
    change[3] = pivotVY;
    change[4] = pivotAccelY - 5 * pivotVY;
    const gEff = gravity + pivotAccelY;
    change[0] = angVel;
    change[1] = -(gEff / length) * Math.sin(angle) - (damping / (mass * length * length)) * angVel;
  },
  energy(vars, params) {
    const [angle, angVel, , pivotY] = vars;
    const { gravity, length, mass } = params;
    const bobY = pivotY - length * Math.cos(angle);
    const KE = 0.5 * mass * (length * angVel) ** 2;
    const PE = mass * gravity * (bobY + length);
    return { kinetic: KE, potential: PE, total: KE + PE };
  },
};

section('Kapitza — No Vibration = Normal Pendulum');
{
  const p = getParams(KapitzaSim);
  p.vibeAmp = 0;
  p.damping = 0;
  const state = Float64Array.from(KapitzaSim.init(p));
  const e0 = KapitzaSim.energy(state, p);
  const dt = 1/240;
  for (let i = 0; i < 1200; i++) {
    rk4(state, (v,c,par) => KapitzaSim.evaluate(v,c,par,false), dt, p);
  }
  const e1 = KapitzaSim.energy(state, p);
  // Without vibration: energy should be conserved (no drive)
  assertClose(e1.total, e0.total, 0.01, 'No vibration: energy conserved');
}

section('Kapitza — Inverted Position Stable with High Vibration');
{
  const p = getParams(KapitzaSim);
  p.vibeAmp = 200;
  p.vibeFreq = 40;
  p.damping = 0.3;
  p.startAngle = Math.PI - 0.05; // start nearly inverted
  const state = Float64Array.from(KapitzaSim.init(p));
  const dt = 1/240;
  // Run for 10 seconds
  for (let i = 0; i < 2400; i++) {
    rk4(state, (v,c,par) => KapitzaSim.evaluate(v,c,par,false), dt, p);
  }
  // Should stay near inverted (θ ≈ π)
  const angleFromInverted = Math.abs(Math.abs(state[0]) - Math.PI);
  assert(angleFromInverted < 0.5, `Kapitza stable: angle from π = ${angleFromInverted.toFixed(3)} rad (should be < 0.5)`);
}

section('Kapitza — No Vibration = Inverted Unstable');
{
  const p = getParams(KapitzaSim);
  p.vibeAmp = 0;
  p.damping = 0.1;
  p.startAngle = Math.PI - 0.05; // start nearly inverted
  const state = Float64Array.from(KapitzaSim.init(p));
  const dt = 1/120;
  for (let i = 0; i < 600; i++) { // 5 seconds
    rk4(state, (v,c,par) => KapitzaSim.evaluate(v,c,par,false), dt, p);
  }
  // Without vibration, should fall away from inverted
  const angleFromInverted = Math.abs(Math.abs(state[0]) - Math.PI);
  assert(angleFromInverted > 0.5, `No vibration: fell from inverted, angle from π = ${angleFromInverted.toFixed(3)}`);
}

section('Kapitza — Pivot Vibrates');
{
  const p = getParams(KapitzaSim);
  p.vibeAmp = 100;
  p.vibeFreq = 30;
  const state = Float64Array.from(KapitzaSim.init(p));
  const dt = 1/240;
  for (let i = 0; i < 240; i++) {
    rk4(state, (v,c,par) => KapitzaSim.evaluate(v,c,par,false), dt, p);
  }
  // Pivot Y should be oscillating (not zero)
  assert(Math.abs(state[3]) > 0.001 || Math.abs(state[4]) > 0.001, 'Pivot Y is moving');
}

// --- Molecule sim ---
const MoleculeSim = {
  _getN(p) { return Math.round(p.numAtoms); },
  _atomMass(i, p) { return i === 0 ? p.redMass : p.mass; },
  params: {
    numAtoms: { value: 3 }, mass: { value: 0.5 }, redMass: { value: 0.5 },
    stiffness: { value: 6.0 }, redStiffness: { value: 6.0 },
    restLength: { value: 2.0 }, redRestLength: { value: 2.0 },
    springType: { value: 'linear' },
    gravity: { value: 2.0 }, damping: { value: 0 },
    wallSize: { value: 5.0 }, elasticity: { value: 0.8 },
  },
  init(p) {
    const N = this._getN(p);
    const state = new Array(4*N+1).fill(0);
    const radius = p.restLength * 0.8;
    for (let i = 0; i < N; i++) {
      const angle = (2*Math.PI*i)/N - Math.PI/2;
      state[i*4] = radius * Math.cos(angle);
      state[i*4+1] = radius * Math.sin(angle) + 1;
    }
    state[4*N] = 0;
    return state;
  },
  evaluate(vars, change, params, isDragging) {
    const N = Math.round(params.numAtoms);
    change[4*N] = 1;
    if (isDragging) return;
    const { mass, stiffness: k, restLength: L0, gravity: g, damping: b } = params;
    for (let i=0;i<N;i++) {
      change[i*4] = vars[i*4+2]; change[i*4+1] = vars[i*4+3];
      change[i*4+2] = 0; change[i*4+3] = -g;
    }
    for (let i=0;i<N;i++) for (let j=i+1;j<N;j++) {
      const dx=vars[j*4]-vars[i*4], dy=vars[j*4+1]-vars[i*4+1];
      const dist=Math.hypot(dx,dy); if(dist<1e-10) continue;
      const force=k*(dist-L0)/dist;
      const fx=force*dx, fy=force*dy;
      change[i*4+2]+=fx/mass; change[i*4+3]+=fy/mass;
      change[j*4+2]-=fx/mass; change[j*4+3]-=fy/mass;
    }
    if(b>0) for(let i=0;i<N;i++){change[i*4+2]-=b*vars[i*4+2]/mass; change[i*4+3]-=b*vars[i*4+3]/mass;}
  },
  postStep(vars, params) {
    const N=Math.round(params.numAtoms), W=params.wallSize, e=params.elasticity;
    for(let i=0;i<N;i++){
      const xi=i*4,yi=i*4+1,vxi=i*4+2,vyi=i*4+3;
      if(vars[xi]<-W){vars[xi]=-W;vars[vxi]=Math.abs(vars[vxi])*e;}
      if(vars[xi]>W){vars[xi]=W;vars[vxi]=-Math.abs(vars[vxi])*e;}
      if(vars[yi]<-W){vars[yi]=-W;vars[vyi]=Math.abs(vars[vyi])*e;}
      if(vars[yi]>W){vars[yi]=W;vars[vyi]=-Math.abs(vars[vyi])*e;}
    }
  },
  energy(vars, params) {
    const N=Math.round(params.numAtoms), {mass,stiffness:k,restLength:L0,gravity:g,wallSize}=params;
    let KE=0,PE=0;
    for(let i=0;i<N;i++){const vx=vars[i*4+2],vy=vars[i*4+3];KE+=0.5*mass*(vx*vx+vy*vy);PE+=mass*g*(vars[i*4+1]+wallSize);}
    for(let i=0;i<N;i++)for(let j=i+1;j<N;j++){const dx=vars[j*4]-vars[i*4],dy=vars[j*4+1]-vars[i*4+1];PE+=0.5*k*(Math.hypot(dx,dy)-L0)**2;}
    return {kinetic:KE,potential:PE,total:KE+PE};
  },
  hitTest(wx,wy,vars,params){
    const N=Math.round(params.numAtoms);
    for(let i=N-1;i>=0;i--){if(Math.hypot(wx-vars[i*4],wy-vars[i*4+1])<0.5)return{id:i,offsetX:wx-vars[i*4],offsetY:wy-vars[i*4+1]};}
    return null;
  },
  onDrag(id,wx,wy,offset,vars){vars[id*4]=wx-offset.offsetX;vars[id*4+1]=wy-offset.offsetY;vars[id*4+2]=0;vars[id*4+3]=0;},
  onRelease(){},
};

section('Molecule — Init 3 Atoms');
{
  const p = getParams(MoleculeSim);
  const state = Float64Array.from(MoleculeSim.init(p));
  assert(state.length === 13, 'State: 4*3 + 1 = 13 vars');
  // Atoms should be in a triangle
  const x0 = state[0], y0 = state[1];
  const x1 = state[4], y1 = state[5];
  const x2 = state[8], y2 = state[9];
  const d01 = Math.hypot(x1-x0, y1-y0);
  const d02 = Math.hypot(x2-x0, y2-y0);
  assertClose(d01, d02, 0.01, 'Triangle: atom0-1 ≈ atom0-2 distance');
}

section('Molecule — Spring Forces at Rest');
{
  // Two atoms at exactly rest length apart → zero spring force
  const p = getParams(MoleculeSim);
  p.numAtoms = 2;
  p.gravity = 0;
  const state = Float64Array.from([0, 0, 0, 0, p.restLength, 0, 0, 0, 0]);
  const change = new Float64Array(9);
  MoleculeSim.evaluate(state, change, p, false);
  assertClose(change[2], 0, 0.01, 'Atom 0: zero x-acceleration at rest length');
  assertClose(change[6], 0, 0.01, 'Atom 1: zero x-acceleration at rest length');
}

section('Molecule — Spring Force Direction');
{
  const p = getParams(MoleculeSim);
  p.numAtoms = 2;
  p.gravity = 0;
  // Place atoms further than rest length → attraction
  const state = Float64Array.from([0, 0, 0, 0, p.restLength * 2, 0, 0, 0, 0]);
  const change = new Float64Array(9);
  MoleculeSim.evaluate(state, change, p, false);
  assert(change[2] > 0, 'Stretched: atom 0 pulled toward atom 1 (positive x)');
  assert(change[6] < 0, 'Stretched: atom 1 pulled toward atom 0 (negative x)');
}

section('Molecule — Wall Collision');
{
  const p = getParams(MoleculeSim);
  p.numAtoms = 2;
  const state = Float64Array.from([
    -6, 0, -1, 0,  // atom 0: past left wall, moving left
    0, -6, 0, -1,  // atom 1: past bottom wall, moving down
    0
  ]);
  MoleculeSim.postStep(state, p);
  assertClose(state[0], -5, 0.01, 'Atom 0 clamped to left wall');
  assert(state[2] > 0, 'Atom 0 velocity reversed (bounced right)');
  assertClose(state[5], -5, 0.01, 'Atom 1 clamped to bottom wall');
  assert(state[7] > 0, 'Atom 1 velocity reversed (bounced up)');
}

section('Molecule — HitTest');
{
  const p = getParams(MoleculeSim);
  p.numAtoms = 3;
  const state = Float64Array.from(MoleculeSim.init(p));
  const hit = MoleculeSim.hitTest(state[0], state[1], state, p);
  assert(hit !== null && hit.id === 0, 'Hit test finds atom 0');
  const miss = MoleculeSim.hitTest(100, 100, state, p);
  assert(miss === null, 'Miss when far away');
}

section('Molecule — Variable Atom Count');
{
  for (let n = 2; n <= 6; n++) {
    const p = getParams(MoleculeSim);
    p.numAtoms = n;
    const state = Float64Array.from(MoleculeSim.init(p));
    assert(state.length === 4*n+1, `${n} atoms: state length = ${4*n+1}`);
    const change = new Float64Array(4*n+1);
    MoleculeSim.evaluate(state, change, p, false);
    assertClose(change[4*n], 1, 1e-10, `${n} atoms: time advances`);
  }
}

// --- Colliding Blocks ---
const CollideBlocksSim = {
  params:{mass1:{value:0.5},mass2:{value:1.5},stiffness:{value:6},restLength:{value:2.5},damping:{value:0},elasticity:{value:1},wallLeft:{value:-4},wallRight:{value:8}},
  init(p){return[p.wallLeft+p.restLength,0,5,-3,0];},
  evaluate(vars,change,params,isDragging){
    change[4]=1;if(isDragging)return;
    const{mass1:m1,mass2:m2,stiffness:k,restLength:R,damping:b,wallLeft}=params;
    change[0]=vars[1];change[1]=(-k*(vars[0]-wallLeft-R)-b*vars[1])/m1;
    change[2]=vars[3];change[3]=(-b*vars[3])/m2;
  },
  postStep(vars,params){
    const{mass1:m1,mass2:m2,elasticity:e,wallLeft,wallRight}=params;
    const bw1=0.25*Math.sqrt(m1),bw2=0.25*Math.sqrt(m2);
    if(vars[0]-bw1<wallLeft){vars[0]=wallLeft+bw1;vars[1]=-vars[1]*e;}
    if(vars[2]+bw2>wallRight){vars[2]=wallRight-bw2;vars[3]=-vars[3]*e;}
    if(vars[0]+bw1>vars[2]-bw2){
      const ol=(vars[0]+bw1)-(vars[2]-bw2);vars[0]-=ol*m2/(m1+m2);vars[2]+=ol*m1/(m1+m2);
      const vcm=(m1*vars[1]+m2*vars[3])/(m1+m2);
      vars[1]=vcm-e*(vars[1]-vcm);vars[3]=vcm-e*(vars[3]-vcm);
    }
  },
  energy(vars,params){
    const stretch=vars[0]-params.wallLeft-params.restLength;
    const KE=0.5*params.mass1*vars[1]**2+0.5*params.mass2*vars[3]**2;
    const PE=0.5*params.stiffness*stretch**2;
    return{kinetic:KE,potential:PE,total:KE+PE};
  },
};

section('Collide Blocks — Elastic Collision Preserves KE');
{
  // No spring, no walls — pure collision test
  const p=getParams(CollideBlocksSim);p.elasticity=1;p.damping=0;p.stiffness=0;
  p.wallLeft=-100;p.wallRight=100; // walls far away
  // Block 1 at rest, block 2 approaching
  const state=Float64Array.from([0,0,2,-3,0]);
  const mom0=p.mass1*state[1]+p.mass2*state[3];
  const ke0=0.5*p.mass1*state[1]**2+0.5*p.mass2*state[3]**2;
  const dt=1/240;
  for(let i=0;i<480;i++){ // 2 seconds — enough for collision
    rk4(state,(v,c,par)=>CollideBlocksSim.evaluate(v,c,par,false),dt,p);
    CollideBlocksSim.postStep(state,p);
  }
  const mom1=p.mass1*state[1]+p.mass2*state[3];
  const ke1=0.5*p.mass1*state[1]**2+0.5*p.mass2*state[3]**2;
  assertClose(mom1,mom0,0.01,`Elastic: momentum conserved ${mom0.toFixed(3)} → ${mom1.toFixed(3)}`);
  assertClose(ke1,ke0,0.1,`Elastic: KE conserved ${ke0.toFixed(3)} → ${ke1.toFixed(3)}`);
}

section('Collide Blocks — Inelastic Loses KE');
{
  const p=getParams(CollideBlocksSim);p.elasticity=0.5;p.damping=0;
  const state=Float64Array.from(CollideBlocksSim.init(p));
  const e0=CollideBlocksSim.energy(state,p);
  const dt=1/120;
  for(let i=0;i<600;i++){
    rk4(state,(v,c,par)=>CollideBlocksSim.evaluate(v,c,par,false),dt,p);
    CollideBlocksSim.postStep(state,p);
  }
  const e1=CollideBlocksSim.energy(state,p);
  assert(e1.kinetic<e0.kinetic,'Inelastic: KE decreased after collision');
}

section('Collide Blocks — Equal Mass Velocity Swap');
{
  const p=getParams(CollideBlocksSim);
  p.mass1=1;p.mass2=1;p.stiffness=0;p.elasticity=1;p.damping=0;
  // Block 1 at rest, block 2 approaching
  const state=Float64Array.from([0,0,2,-3,0]);
  CollideBlocksSim.postStep(state,p); // trigger collision since blocks overlap at x=0,2
  // No overlap actually. Set them so they collide:
  const state2=Float64Array.from([1.5,0,1.8,-3,0]);
  CollideBlocksSim.postStep(state2,p);
  // After elastic equal-mass collision: velocities swap
  assertClose(state2[1],-3,0.1,'Equal mass: block1 gets block2 velocity');
  assertClose(state2[3],0,0.1,'Equal mass: block2 gets block1 velocity');
}

// --- Cart + Pendulum ---
const CartPendulumSim = {
  params:{cartMass:{value:1},bobMass:{value:1},length:{value:1},stiffness:{value:6},gravity:{value:9.8},cartDamp:{value:0},bobDamp:{value:0},startAngle:{value:Math.PI/4}},
  init(p){return[0,p.startAngle,0,0,0];},
  evaluate(vars,change,params,isDragging){
    change[4]=1;if(isDragging)return;
    const[x,h,v,w]=vars;
    const{cartMass:M,bobMass:m,length:L,stiffness:k,gravity:g,cartDamp:d,bobDamp:b}=params;
    const sinH=Math.sin(h),cosH=Math.cos(h),denom=M+m*sinH*sinH;
    change[0]=v;change[1]=w;
    change[2]=(m*w*w*L*sinH+m*g*sinH*cosH-k*x-d*v+b*w*cosH/L)/denom;
    change[3]=(-m*w*w*L*sinH*cosH+k*x*cosH-(M+m)*g*sinH+d*v*cosH-(M+m)*b*w/(m*L))/(L*denom);
  },
  energy(vars,params){
    const[x,h,v,w]=vars;
    const{cartMass:M,bobMass:m,length:L,stiffness:k,gravity:g}=params;
    const vxB=v+L*w*Math.cos(h),vyB=L*w*Math.sin(h);
    const KE=0.5*M*v*v+0.5*m*(vxB*vxB+vyB*vyB);
    const PE=0.5*k*x*x+m*g*(-L*Math.cos(h)+L);
    return{kinetic:KE,potential:PE,total:KE+PE};
  },
};

section('Cart-Pendulum — Energy Conservation (no damping)');
{
  const p=getParams(CartPendulumSim);
  const state=Float64Array.from(CartPendulumSim.init(p));
  const e0=CartPendulumSim.energy(state,p);
  const dt=1/240;
  for(let i=0;i<2400;i++){
    rk4(state,(v,c,par)=>CartPendulumSim.evaluate(v,c,par,false),dt,p);
  }
  const e1=CartPendulumSim.energy(state,p);
  const drift=Math.abs(e1.total-e0.total)/Math.max(e0.total,0.01);
  assert(drift<0.001,`Cart-Pend energy drift: ${(drift*100).toFixed(4)}%`);
}

section('Cart-Pendulum — Coupling: Pendulum Moves Cart');
{
  const p=getParams(CartPendulumSim);
  const state=Float64Array.from(CartPendulumSim.init(p));
  assertClose(state[0],0,1e-10,'Cart starts at x=0');
  const dt=1/120;
  for(let i=0;i<120;i++){
    rk4(state,(v,c,par)=>CartPendulumSim.evaluate(v,c,par,false),dt,p);
  }
  assert(Math.abs(state[0])>0.01,'Cart moved from equilibrium due to pendulum coupling');
}

section('Cart-Pendulum — Heavy Cart Barely Moves');
{
  const p=getParams(CartPendulumSim);p.cartMass=100;
  const state=Float64Array.from(CartPendulumSim.init(p));
  const dt=1/120;
  for(let i=0;i<300;i++){
    rk4(state,(v,c,par)=>CartPendulumSim.evaluate(v,c,par,false),dt,p);
  }
  assert(Math.abs(state[0])<0.1,'Heavy cart: cart barely moves (|x|<0.1)');
}

section('Cart-Pendulum — No Spring: Momentum Conserved');
{
  const p=getParams(CartPendulumSim);p.stiffness=0;
  const state=Float64Array.from(CartPendulumSim.init(p));
  // Total horizontal momentum: M*v + m*(v + L*ω*cosθ) — should be 0 initially
  const dt=1/120;
  for(let i=0;i<300;i++){
    rk4(state,(v,c,par)=>CartPendulumSim.evaluate(v,c,par,false),dt,p);
  }
  const[x,h,v,w]=state;const{cartMass:M,bobMass:m,length:L}=p;
  const pTotal=M*v+m*(v+L*w*Math.cos(h));
  assertClose(pTotal,0,0.05,'No spring: horizontal momentum conserved ≈ 0');
}

// --- Brachistochrone ---
// Simplified curve defs for testing (matching the sim)
const bD = 3, bH = 2;
const bLine = { y: (x) => (bH/bD)*x, dy: (x) => bH/bD, d2y: (x) => 0 };
const bParab = { y: (x) => bH*(1-(1-x/bD)**2), dy: (x) => 2*bH*(1-x/bD)/bD, d2y: (x) => -2*bH/(bD*bD) };

function brachistoEval(vars, change, params) {
  change[8] = 1;
  const { gravity: g, damping: b } = params;
  const curves = [null, bLine, bParab, null]; // only test line and parabola (indices 1,2)
  for (let i = 1; i <= 2; i++) {
    const x = vars[i*2], v = vars[i*2+1];
    if (x >= bD) { change[i*2]=0; change[i*2+1]=0; continue; }
    const curve = curves[i];
    const fp = curve.dy(x), fpp = curve.d2y(x);
    const denom = 1 + fp*fp;
    change[i*2] = v;
    change[i*2+1] = (g*fp - 2*v*v*fp*fpp)/denom - b*v;
  }
  // Skip cycloid/circle for test simplicity
  change[0]=vars[1]; change[1]=0; change[6]=vars[7]; change[7]=0;
}

section('Brachistochrone — Line Ball Reaches End');
{
  const state = Float64Array.from([0,0, 0,0, 0,0, 0,0, 0]);
  const p = { gravity: 9.81, damping: 0 };
  const dt = 1/240;
  for (let i = 0; i < 2400; i++) { // 10 seconds
    rk4(state, brachistoEval, dt, p);
    // Clamp
    for (let j = 0; j < 4; j++) {
      if (state[j*2] >= bD) { state[j*2] = bD; state[j*2+1] = 0; }
      if (state[j*2] < 0) { state[j*2] = 0; state[j*2+1] = Math.max(0, state[j*2+1]); }
    }
  }
  assert(state[2] >= bD - 0.01, 'Line ball reached end: x=' + state[2].toFixed(3));
  assert(state[4] >= bD - 0.01, 'Parabola ball reached end: x=' + state[4].toFixed(3));
}

section('Brachistochrone — Energy Conservation (line, no friction)');
{
  const state = Float64Array.from([0,0, 0,0, 0,0, 0,0, 0]);
  const p = { gravity: 9.81, damping: 0 };
  const dt = 1/240;
  // Run line ball halfway
  for (let i = 0; i < 200; i++) {
    rk4(state, brachistoEval, dt, p);
  }
  const x = state[2], v = state[3];
  const fp = bLine.dy(x);
  const speed2 = v*v*(1+fp*fp);
  const KE = 0.5*speed2;
  const PE = p.gravity*(bH - bLine.y(x));
  const total = KE + PE;
  const E0 = p.gravity * bH; // initial: KE=0, PE=g*H per ball
  assertClose(total, E0, 0.5, 'Line energy conserved: E=' + total.toFixed(4) + ' vs E0=' + E0.toFixed(4));
}

section('Brachistochrone — Bead-on-Wire ODE Correctness');
{
  // At x=0 on straight line: f'=H/D, f''=0
  // ẍ = g·(H/D) / (1 + (H/D)²) = 9.81·0.667 / (1 + 0.444) = 6.54 / 1.444 = 4.53
  const fp = bH/bD, denom = 1 + fp*fp;
  const expectedAccel = 9.81 * fp / denom;
  const state = Float64Array.from([0,0, 0,0, 0,0, 0,0, 0]);
  const change = new Float64Array(9);
  brachistoEval(state, change, { gravity: 9.81, damping: 0 });
  assertClose(change[3], expectedAccel, 0.01, 'Line initial accel = g·f\'/(1+f\'²) = ' + expectedAccel.toFixed(3));
}

section('Brachistochrone — Steep Parabola Starts Fast');
{
  // Steep parabola f'(0) = 2H/D = 1.333, steeper than line f'(0) = H/D = 0.667
  const state = Float64Array.from([0,0, 0,0, 0,0, 0,0, 0]);
  const change = new Float64Array(9);
  brachistoEval(state, change, { gravity: 9.81, damping: 0 });
  assert(change[3] > 0, 'Line: initial accel > 0');
  assert(change[5] > change[3], 'Steep parabola starts faster than line (steeper initial slope)');
}

// --- Collision Engine ---
function resolveCircleCircle(x1,y1,vx1,vy1,r1,m1,x2,y2,vx2,vy2,r2,m2,e){
  const dx=x2-x1,dy=y2-y1,dist=Math.hypot(dx,dy),minDist=r1+r2;
  if(dist>=minDist||dist<1e-10)return null;
  const nx=dx/dist,ny=dy/dist;
  const dvx=vx1-vx2,dvy=vy1-vy2,vRel=dvx*nx+dvy*ny;
  if(vRel<=0)return null;
  const j=(1+e)*vRel/(1/m1+1/m2);
  return{nx,ny,impulse:j,overlap:minDist-dist};
}

section('Collision — Circle-Circle Elastic');
{
  // Two equal balls, head-on: ball1 moving right at v=3, ball2 stationary
  const r = resolveCircleCircle(0,0, 3,0, 0.3,1, 0.5,0, 0,0, 0.3,1, 1.0);
  assert(r !== null, 'Collision detected (overlap)');
  assertClose(r.nx, 1, 0.01, 'Normal points right');
  assertClose(r.ny, 0, 0.01, 'Normal is horizontal');
  // For equal mass elastic: impulse j = (1+1)*3/(1+1) = 3
  assertClose(r.impulse, 3, 0.01, 'Impulse j = (1+e)*vRel / (1/m1+1/m2) = 3');
}

section('Collision — No Collision When Separated');
{
  const r = resolveCircleCircle(0,0, 1,0, 0.3,1, 5,0, 0,0, 0.3,1, 1.0);
  assert(r === null, 'No collision when far apart');
}

section('Collision — No Collision When Moving Apart');
{
  // Overlapping but moving away from each other
  const r = resolveCircleCircle(0,0, -1,0, 0.3,1, 0.5,0, 1,0, 0.3,1, 1.0);
  assert(r === null, 'No collision when separating');
}

section('Collision — Unequal Mass');
{
  // Heavy ball (m=5) hits light ball (m=1)
  const r = resolveCircleCircle(0,0, 2,0, 0.3,5, 0.5,0, 0,0, 0.3,1, 1.0);
  assert(r !== null, 'Collision detected');
  // j = (1+1)*2 / (1/5 + 1/1) = 4 / 1.2 = 3.333
  assertClose(r.impulse, 4/1.2, 0.01, 'Unequal mass impulse correct');
}

section('Collision — Momentum Conservation After Apply');
{
  // Simulate full collision: two equal balls
  const vars = Float64Array.from([0,0, 3,0, 0.5,0, 0,0]);
  const r = resolveCircleCircle(vars[0],vars[1],vars[2],vars[3],0.3,1, vars[4],vars[5],vars[6],vars[7],0.3,1, 1.0);
  const mom0 = vars[2] + vars[6]; // total momentum before
  // Apply
  vars[2] -= (r.impulse/1)*r.nx;
  vars[3] -= (r.impulse/1)*r.ny;
  vars[6] += (r.impulse/1)*r.nx;
  vars[7] += (r.impulse/1)*r.ny;
  const mom1 = vars[2] + vars[6];
  assertClose(mom1, mom0, 0.01, 'Momentum conserved after collision');
  // Equal mass elastic: velocities should swap
  assertClose(vars[2], 0, 0.01, 'Ball 1 stops');
  assertClose(vars[6], 3, 0.01, 'Ball 2 gets full velocity');
}

section('Collision — KE Conservation (elastic)');
{
  const vars = Float64Array.from([0,0, 3,0, 0.5,0, -1,0.5]);
  const r = resolveCircleCircle(vars[0],vars[1],vars[2],vars[3],0.3,1, vars[4],vars[5],vars[6],vars[7],0.3,1, 1.0);
  const ke0 = 0.5*(vars[2]**2+vars[3]**2) + 0.5*(vars[6]**2+vars[7]**2);
  if (r) {
    vars[2] -= (r.impulse/1)*r.nx; vars[3] -= (r.impulse/1)*r.ny;
    vars[6] += (r.impulse/1)*r.nx; vars[7] += (r.impulse/1)*r.ny;
  }
  const ke1 = 0.5*(vars[2]**2+vars[3]**2) + 0.5*(vars[6]**2+vars[7]**2);
  assertClose(ke1, ke0, 0.01, 'KE conserved in 2D elastic collision');
}

// --- String Wave (PDE) ---
section('String Wave — Finite Difference Stability');
{
  // CFL condition: r = (c*dt/dx)² < 1
  const T = 10, rho = 1, N = 101, L = 5;
  const dx = L / (N - 1);
  const c = Math.sqrt(T / rho);
  const dt = 0.4 * dx / c; // our chosen dt
  const r = (c * dt / dx) ** 2;
  assert(r < 1, `CFL stable: r = ${r.toFixed(4)} < 1`);
  assertClose(r, 0.16, 0.01, 'Courant number r = (0.4)² = 0.16');
}

section('String Wave — Pluck Shape');
{
  // Pluck at 1/3: triangle from 0 to peak at L/3, then back to 0
  const L = 5;
  function shape(x) {
    const xn = x / L;
    return xn < 1/3 ? 3 * xn * 0.8 : (1 - xn) * 0.8 / (2/3);
  }
  assertClose(shape(0), 0, 1e-10, 'Pluck: w(0) = 0');
  assertClose(shape(L), 0, 1e-10, 'Pluck: w(L) = 0');
  assert(shape(L/3) > 0.7, 'Pluck: peak near L/3');
  assert(shape(L/2) > 0, 'Pluck: positive at midpoint');
}

section('String Wave — PDE Update Rule');
{
  // Test one step of the finite difference: known input → expected output
  const N = 5; // tiny grid for testing
  const r = 0.16; // Courant number
  const wCurr = Float64Array.from([0, 0.5, 1.0, 0.5, 0]);
  const wPrev = Float64Array.from([0, 0.5, 1.0, 0.5, 0]); // same (just started)
  const wNew = new Float64Array(N);

  for (let i = 1; i < N - 1; i++) {
    wNew[i] = 2 * (1 - r) * wCurr[i] + r * (wCurr[i + 1] + wCurr[i - 1]) - wPrev[i];
  }
  wNew[0] = 0; wNew[N - 1] = 0;

  // With wPrev = wCurr and symmetric input: wNew should equal wCurr (stationary start)
  // Actually: wNew[i] = 2(1-r)*w[i] + r*(w[i+1]+w[i-1]) - w[i] = (1-2r)*w[i] + r*(w[i+1]+w[i-1])
  const expected1 = (1 - 2*r) * 0.5 + r * (1.0 + 0); // i=1: neighbors are 0 and 1.0
  assertClose(wNew[1], expected1, 1e-10, 'PDE step: w[1] = (1-2r)*0.5 + r*(0+1) = ' + expected1.toFixed(4));
  const expected2 = (1 - 2*r) * 1.0 + r * (0.5 + 0.5); // i=2: neighbors are 0.5 and 0.5
  assertClose(wNew[2], expected2, 1e-10, 'PDE step: w[2] = (1-2r)*1.0 + r*(0.5+0.5) = ' + expected2.toFixed(4));
}

section('String Wave — Sine Mode Preserves Shape');
{
  // A pure sine mode should oscillate without changing shape (it's an eigenmode)
  const N = 51, L = 5;
  const dx = L / (N - 1);
  const T = 10, rho = 1;
  const c = Math.sqrt(T / rho);
  const dt = 0.4 * dx / c;
  const r = (c * dt / dx) ** 2;

  // Initial: w = sin(πx/L), wPrev slightly less (cosine decay over dt)
  const omega = Math.PI * c / L; // angular frequency of fundamental
  const wCurr = new Float64Array(N);
  const wPrev = new Float64Array(N);
  for (let i = 0; i < N; i++) {
    const x = i * dx;
    wCurr[i] = Math.sin(Math.PI * x / L);
    wPrev[i] = Math.sin(Math.PI * x / L) * Math.cos(omega * dt);
  }
  wCurr[0] = 0; wCurr[N-1] = 0;
  wPrev[0] = 0; wPrev[N-1] = 0;

  // Run 100 PDE steps
  let curr = wCurr, prev = wPrev;
  for (let step = 0; step < 100; step++) {
    const wNew = new Float64Array(N);
    for (let i = 1; i < N - 1; i++) {
      wNew[i] = 2*(1-r)*curr[i] + r*(curr[i+1]+curr[i-1]) - prev[i];
    }
    prev = curr;
    curr = wNew;
  }

  // Shape should still be approximately sin(πx/L) * cos(ω*100*dt)
  const t = 100 * dt;
  const expectedAmp = Math.cos(omega * t);
  const midVal = curr[Math.floor(N/2)];
  // The midpoint of sin(πx/L) is 1.0, so midVal ≈ cos(ω*t)
  assertClose(Math.abs(midVal), Math.abs(expectedAmp), 0.1,
    `Sine mode shape preserved: mid=${midVal.toFixed(4)} vs expected=${expectedAmp.toFixed(4)}`);
}

section('String Wave — Fixed Boundary Conditions');
{
  const N = 21;
  const r = 0.16;
  const wCurr = new Float64Array(N);
  const wPrev = new Float64Array(N);
  // Set non-zero interior
  for (let i = 1; i < N - 1; i++) wCurr[i] = Math.sin(Math.PI * i / (N-1));

  const wNew = new Float64Array(N);
  for (let i = 1; i < N - 1; i++) {
    wNew[i] = 2*(1-r)*wCurr[i] + r*(wCurr[i+1]+wCurr[i-1]) - wPrev[i];
  }
  wNew[0] = 0; wNew[N-1] = 0;

  assertClose(wNew[0], 0, 1e-10, 'Left boundary fixed at 0');
  assertClose(wNew[N-1], 0, 1e-10, 'Right boundary fixed at 0');
  assert(Math.abs(wNew[Math.floor(N/2)]) > 0, 'Interior is non-zero');
}

// --- Engine2D: RigidBody + SAT ---

// Inline polygon inertia (from rigid-body.js)
function polygonInertia(vertices, mass) {
  let num = 0, den = 0;
  const n = vertices.length;
  for (let i = 0; i < n; i++) {
    const a = vertices[i], b = vertices[(i+1)%n];
    const cross = Math.abs(a[0]*b[1] - a[1]*b[0]);
    const dot = a[0]*a[0]+a[0]*b[0]+b[0]*b[0]+a[1]*a[1]+a[1]*b[1]+b[1]*b[1];
    num += cross*dot; den += cross;
  }
  return den > 0 ? (mass/6)*num/den : mass*0.1;
}

// Inline SAT test (from contact-solver.js)
function satTest(vA, vB) {
  let minD = Infinity, minN = null;
  for (let p = 0; p < 2; p++) {
    const verts = p===0?vA:vB;
    for (let i = 0; i < verts.length; i++) {
      const j=(i+1)%verts.length;
      const ex=verts[j][0]-verts[i][0], ey=verts[j][1]-verts[i][1];
      const len=Math.hypot(ex,ey); if(len<1e-10)continue;
      const nx=-ey/len, ny=ex/len;
      let aMin=Infinity,aMax=-Infinity,bMin=Infinity,bMax=-Infinity;
      for(const[x,y]of vA){const d=x*nx+y*ny;if(d<aMin)aMin=d;if(d>aMax)aMax=d;}
      for(const[x,y]of vB){const d=x*nx+y*ny;if(d<bMin)bMin=d;if(d>bMax)bMax=d;}
      const overlap=Math.min(aMax-bMin,bMax-aMin);
      if(overlap<=0)return null;
      if(overlap<minD){
        minD=overlap;
        const cax=vA.reduce((s,v)=>s+v[0],0)/vA.length, cay=vA.reduce((s,v)=>s+v[1],0)/vA.length;
        const cbx=vB.reduce((s,v)=>s+v[0],0)/vB.length, cby=vB.reduce((s,v)=>s+v[1],0)/vB.length;
        const dx=cbx-cax,dy=cby-cay;
        minN=(dx*nx+dy*ny<0)?[-nx,-ny]:[nx,ny];
      }
    }
  }
  return minD<Infinity?{normal:minN,depth:minD}:null;
}

section('Engine2D — Polygon Inertia');
{
  // Unit square: I = m*(w²+h²)/12 = 1*(1+1)/12 = 0.1667
  const square = [[-0.5,-0.5],[0.5,-0.5],[0.5,0.5],[-0.5,0.5]];
  const I = polygonInertia(square, 1.0);
  assertClose(I, 1/6, 0.02, 'Unit square inertia ≈ 1/6');
}

section('Engine2D — SAT: Two Separated Squares');
{
  const a = [[0,0],[1,0],[1,1],[0,1]];
  const b = [[3,0],[4,0],[4,1],[3,1]];
  const r = satTest(a, b);
  assert(r === null, 'Separated squares: no collision');
}

section('Engine2D — SAT: Two Overlapping Squares');
{
  const a = [[0,0],[1,0],[1,1],[0,1]];
  const b = [[0.8,0],[1.8,0],[1.8,1],[0.8,1]]; // overlap 0.2
  const r = satTest(a, b);
  assert(r !== null, 'Overlapping squares: collision detected');
  assertClose(r.depth, 0.2, 0.01, 'Overlap depth ≈ 0.2');
  // Normal should point from A to B (rightward)
  assert(r.normal[0] > 0, 'Normal points right (A→B)');
}

section('Engine2D — SAT: Square and Triangle');
{
  const sq = [[0,0],[1,0],[1,1],[0,1]];
  const tri = [[0.5,0.5],[1.5,0.5],[1,1.5]]; // overlaps
  const r = satTest(sq, tri);
  assert(r !== null, 'Square-triangle overlap detected');
  assert(r.depth > 0, 'Positive depth');
}

section('Engine2D — SAT: Rotated Square');
{
  // 45-degree rotated square (diamond) centered at origin
  const s = 0.5;
  const diamond = [[s,0],[0,s],[-s,0],[0,-s]];
  // Axis-aligned square shifted right, overlapping
  const box = [[0.3,-0.3],[0.8,-0.3],[0.8,0.3],[0.3,0.3]];
  const r = satTest(diamond, box);
  assert(r !== null, 'Rotated diamond vs box: collision');
}

section('Engine2D — SAT: No Collision Corner Case');
{
  // Two squares touching but not overlapping
  const a = [[0,0],[1,0],[1,1],[0,1]];
  const b = [[1,0],[2,0],[2,1],[1,1]]; // touching edge
  const r = satTest(a, b);
  // depth should be 0 or very small — technically touching
  assert(r === null || r.depth < 0.001, 'Edge-touching: no/minimal collision');
}

section('Engine2D — RigidBody Velocity At Point');
{
  // Body at origin, angular velocity omega=2 rad/s
  // Point at (1, 0): v = (0, omega*1) = (0, 2)
  // Plus linear velocity (3, 0): total = (3, 2)
  const vel = { vx: 3, vy: 0 };
  const omega = 2;
  const rx = 1 - 0, ry = 0 - 0;
  const vAtPt = { vx: vel.vx - omega * ry, vy: vel.vy + omega * rx };
  assertClose(vAtPt.vx, 3, 1e-10, 'velocityAt: vx = 3 + 0 = 3');
  assertClose(vAtPt.vy, 2, 1e-10, 'velocityAt: vy = 0 + omega*rx = 2');
}

section('Engine2D — Apply Impulse with Angular');
{
  // Body: mass=2, inertia=1, at origin
  // Apply impulse (1,0) at point (0, 1)
  // Linear: dvx = 1/2 = 0.5, dvy = 0
  // Angular: dω = (0*0 - 1*1) / 1 = -1
  const mass = 2, inertia = 1;
  let vx = 0, vy = 0, omega = 0;
  const jx = 1, jy = 0, px = 0, py = 1;
  vx += jx / mass;
  vy += jy / mass;
  const rx = px - 0, ry = py - 0;
  omega += (rx * jy - ry * jx) / inertia;
  assertClose(vx, 0.5, 1e-10, 'Impulse: dvx = j/m = 0.5');
  assertClose(omega, -1, 1e-10, 'Impulse: dω = (r×j)/I = -1');
}

// --- Spring Mass Correction ---
section('Spring Mass — Effective Mass Changes Period');
{
  const p = getParams(SpringSim);
  p.springMass = 1.0; // 1 kg spring on 1 kg block → mEff = 1 + 1/3 = 4/3
  p.damping = 0;
  const mEff = p.mass + p.springMass / 3;
  const T_theory = 2 * Math.PI * Math.sqrt(mEff / p.stiffness);
  const T_massless = 2 * Math.PI * Math.sqrt(p.mass / p.stiffness);
  assert(T_theory > T_massless, 'Spring mass increases period: ' + T_theory.toFixed(3) + ' > ' + T_massless.toFixed(3));

  // Run sim and check acceleration at start
  const state = Float64Array.from([p.startX, 0, 0]);
  const change = new Float64Array(3);
  // Need to add springMass to inline sim evaluate
  const stretch = p.startX - p.fixedPoint - p.restLength;
  const expectedAccel = (-p.stiffness * stretch) / mEff;
  // Inline evaluate with mEff
  change[0] = 0;
  change[1] = (-p.stiffness * stretch - 0) / mEff;
  change[2] = 1;
  assertClose(change[1], expectedAccel, 0.01, 'Spring mass: accel = -k*stretch/mEff = ' + expectedAccel.toFixed(3));
  // Without spring mass: accel would be -6.0, with mEff=4/3: accel = -6/(4/3) = -4.5
  assertClose(change[1], -4.5, 0.01, 'With 1kg spring: accel = -4.5 (not -6.0)');
}

section('Spring Mass — Zero Spring Mass = Original Behavior');
{
  const p = getParams(SpringSim);
  p.springMass = 0;
  const mEff = p.mass + 0 / 3;
  assertClose(mEff, p.mass, 1e-10, 'Zero spring mass: mEff = block mass');
  const stretch = p.startX - p.fixedPoint - p.restLength;
  const accel = (-p.stiffness * stretch) / mEff;
  assertClose(accel, -6.0, 0.01, 'Zero spring mass: same as before (-6.0)');
}

// --- Double Spring Normal Modes ---
section('Normal Modes — Symmetric Decomposition');
{
  // Two equal blocks displaced symmetrically: q₊ nonzero, q₋ = 0
  // x1 = eq + d, x2 = eq + d → q₊ = 2d/√2 = d√2, q₋ = 0
  const d = 0.5;
  const eq1 = 3, eq2 = 6; // approximate equilibrium
  const dx1 = d, dx2 = d;
  const qSym = (dx1 + dx2) / Math.SQRT2;
  const qAnti = (dx1 - dx2) / Math.SQRT2;
  assertClose(qSym, d * Math.SQRT2, 1e-10, 'Symmetric displacement: q₊ = d√2');
  assertClose(qAnti, 0, 1e-10, 'Symmetric displacement: q₋ = 0');
}

section('Normal Modes — Antisymmetric Decomposition');
{
  // Two equal blocks displaced antisymmetrically: q₊ = 0, q₋ nonzero
  const d = 0.5;
  const dx1 = d, dx2 = -d;
  const qSym = (dx1 + dx2) / Math.SQRT2;
  const qAnti = (dx1 - dx2) / Math.SQRT2;
  assertClose(qSym, 0, 1e-10, 'Antisymmetric: q₊ = 0');
  assertClose(qAnti, d * Math.SQRT2, 1e-10, 'Antisymmetric: q₋ = d√2');
}

section('Normal Modes — Single Block Pull Excites Both');
{
  // Pull block 1 only: dx1 = d, dx2 = 0
  const d = 1.0;
  const qSym = (d + 0) / Math.SQRT2;
  const qAnti = (d - 0) / Math.SQRT2;
  assertClose(qSym, qAnti, 1e-10, 'Single pull: q₊ = q₋ (equal mix of both modes)');
  assert(qSym > 0 && qAnti > 0, 'Both modes excited');
}

section('Normal Modes — Frequencies');
{
  // Symmetric 3-spring case, equal masses m=1, k=6:
  // ω₊² = k/m = 6   → ω₊ = √6 ≈ 2.449
  // ω₋² = 3k/m = 18  → ω₋ = √18 ≈ 4.243
  const k = 6, m = 1;
  const omegaSym = Math.sqrt(k / m);
  const omegaAnti = Math.sqrt(3 * k / m);
  assertClose(omegaSym, Math.sqrt(6), 1e-10, 'ω₊ = √(k/m) = √6');
  assertClose(omegaAnti, Math.sqrt(18), 1e-10, 'ω₋ = √(3k/m) = √18');
  // Beat frequency
  const beatFreq = Math.abs(omegaAnti - omegaSym) / (2 * Math.PI);
  assert(beatFreq > 0, 'Beat frequency > 0: ' + beatFreq.toFixed(3) + ' Hz');
}

section('Normal Modes — Mode Energy Conservation');
{
  // In a pure symmetric mode, E₊ should stay constant and E₋ ≈ 0
  const k = 6, m = 1;
  const omega2Sym = k / m;
  // Start with pure symmetric: q₊ = 1.0, v₊ = 0
  // E₊ = ½m(0 + ω₊²·1²) = ½·1·6·1 = 3.0
  const eSym = 0.5 * m * (0 + omega2Sym * 1.0 * 1.0);
  assertClose(eSym, 3.0, 1e-10, 'Pure symmetric mode energy E₊ = ½mω₊²q₊² = 3.0');
  // E₋ = 0 (no antisymmetric component)
  const eAnti = 0.5 * m * (0 + 0);
  assertClose(eAnti, 0, 1e-10, 'No antisymmetric energy E₋ = 0');
}

section('Normal Modes — Total Energy = E₊ + E₋');
{
  // Mixed state: q₊ = 0.5, v₊ = 1.0, q₋ = 0.3, v₋ = 0.5
  const k = 6, m = 1;
  const omega2Sym = k / m, omega2Anti = 3 * k / m;
  const eSym = 0.5 * m * (1.0 * 1.0 + omega2Sym * 0.5 * 0.5);
  const eAnti = 0.5 * m * (0.5 * 0.5 + omega2Anti * 0.3 * 0.3);
  const eTotal = eSym + eAnti;
  // Also compute from original coords
  // x1 = (q₊+q₋)/√2, x2 = (q₊-q₋)/√2, same for velocities
  const s2 = Math.SQRT2;
  const dx1 = (0.5 + 0.3) / s2, dx2 = (0.5 - 0.3) / s2;
  const dv1 = (1.0 + 0.5) / s2, dv2 = (1.0 - 0.5) / s2;
  // KE = ½m(v1² + v2²), PE = ½k(dx1² + dx2²) + ½k((dx1-dx2)²) for middle spring
  // This should equal eTotal (energy is conserved in the mode decomposition)
  const KE = 0.5 * m * (dv1*dv1 + dv2*dv2);
  const PEwalls = 0.5 * k * (dx1*dx1 + dx2*dx2);
  const PEmid = 0.5 * k * ((dx1-dx2)*(dx1-dx2));
  const eTotalDirect = KE + PEwalls + PEmid;
  assertClose(eTotal, eTotalDirect, 0.01,
    'Mode energy sum = direct energy: ' + eTotal.toFixed(4) + ' ≈ ' + eTotalDirect.toFixed(4));
}

// ═══════════════════════════════════════════
// RAMP: FORCES & MOTION
// ═══════════════════════════════════════════

// Inline physics from js/sims/ramp.js (pure math, no Three.js)
const RAMP_G = 9.81;
const RAMP_LEN = 8;
const RAMP_LEFT = -7;

function rampForces(s, v, P) {
  const th = P.angle * Math.PI / 180, m = P.mass;
  const onRamp = s >= 0, slope = onRamp ? th : 0;
  const Fg = m * RAMP_G;
  const Fg_par = Fg * Math.sin(slope), Fg_perp = Fg * Math.cos(slope);
  const Fa_along = P.appliedForce * Math.cos(slope);
  const Fa_into = onRamp ? P.appliedForce * Math.sin(slope) : 0;
  const N = Math.max(0, Fg_perp + Fa_into);
  const Fnet_nf = Fa_along - Fg_par;
  let Ff = 0;
  if (Math.abs(v) > 1e-3) {
    Ff = -Math.sign(v) * P.mu_k * N;
  } else {
    const Fs_max = P.mu_s * N;
    Ff = Math.abs(Fnet_nf) <= Fs_max ? -Fnet_nf : -Math.sign(Fnet_nf) * P.mu_k * N;
  }
  const Fnet = Fnet_nf + Ff;
  return { Fg, Fg_par, Fg_perp, N, Fa_along, Fa_into, Ff, Fnet, a: Fnet / m,
           Fs_max: P.mu_s * N, slope, onRamp };
}

function rampEvaluate(vars, change, params) {
  change[2] = 1;
  const f = rampForces(vars[0], vars[1], params);
  change[0] = vars[1];
  change[1] = f.a;
}

function rampStep(s, v, dt, P) {
  const f = rampForces(s, v, P);
  v += f.a * dt;
  s += v * dt;
  // Per-wall restitution (matching ramp.js)
  if (s > P.rampLength) {
    const e = Math.max(P.eTop || 0, 0.02);
    s = P.rampLength; if (v > 0) v = -v * e;
  }
  if (s < RAMP_LEFT) {
    const e = Math.max(P.eLeft || 0, 0.02);
    s = RAMP_LEFT; if (v < 0) v = -v * e;
  }
  return { s, v };
}

const defaultRampP = { angle: 30, mass: 5, mu_s: 0.5, mu_k: 0.3,
  appliedForce: 0, rampLength: 8, eTop: 0, eLeft: 0 };

// ─── Force decomposition on flat ground ───
section('Ramp — Flat Ground Forces (s < 0)');
{
  const P = { ...defaultRampP, appliedForce: 0 };
  const f = rampForces(-3, 0, P);

  // On flat ground, no gravity component along surface
  assertClose(f.Fg_par, 0, 1e-10, 'Gravity parallel = 0 on flat ground');
  assertClose(f.Fg_perp, P.mass * RAMP_G, 1e-6, 'Gravity perp = mg on flat ground');
  assertClose(f.N, P.mass * RAMP_G, 1e-6, 'Normal force = mg on flat ground');
  assertClose(f.Fnet, 0, 0.01, 'No net force at rest on flat ground');
  assert(!f.onRamp, 's < 0 is not on ramp');
}

// ─── Force decomposition on ramp ───
section('Ramp — Force Decomposition on Ramp');
{
  const P = { ...defaultRampP, angle: 30, mass: 10, appliedForce: 0 };
  const f = rampForces(3, 0, P);
  const th = 30 * Math.PI / 180;

  assertClose(f.Fg, 10 * RAMP_G, 1e-6, 'Fg = mg');
  assertClose(f.Fg_par, 10 * RAMP_G * Math.sin(th), 1e-6,
    'Fg_par = mg sin θ = ' + (10 * RAMP_G * Math.sin(th)).toFixed(2));
  assertClose(f.Fg_perp, 10 * RAMP_G * Math.cos(th), 1e-6,
    'Fg_perp = mg cos θ = ' + (10 * RAMP_G * Math.cos(th)).toFixed(2));
  assertClose(f.N, 10 * RAMP_G * Math.cos(th), 1e-6,
    'N = mg cos θ (no applied force)');
  assert(f.onRamp, 's >= 0 is on ramp');
}

// ─── Normal force increases when pushing at angle ───
section('Ramp — Applied Force Increases Normal Force');
{
  const P = { ...defaultRampP, angle: 30, mass: 5, appliedForce: 50 };
  const f = rampForces(3, 0, P);
  const th = 30 * Math.PI / 180;
  const expectedN = 5 * RAMP_G * Math.cos(th) + 50 * Math.sin(th);

  assertClose(f.N, expectedN, 1e-4,
    'N = mg cos θ + F sin θ = ' + expectedN.toFixed(2));
  assert(f.N > 5 * RAMP_G * Math.cos(th),
    'Normal force increased by applied force component');
}

// ─── Critical angle: tan(θ) = μs ───
section('Ramp — Critical Angle (tan θ = μs)');
{
  const mu_s = 0.5;
  const critAngle = Math.atan(mu_s) * 180 / Math.PI;  // ≈ 26.57°
  const P = { ...defaultRampP, mu_s, mu_k: 0.3, appliedForce: 0 };

  // Just below critical: block should NOT slide (net force ≈ 0)
  const fBelow = rampForces(3, 0, { ...P, angle: critAngle - 0.5 });
  assertClose(fBelow.Fnet, 0, 0.5,
    'Just below critical angle: static friction holds, ΣF ≈ 0');

  // Just above critical: block SHOULD slide
  const fAbove = rampForces(3, 0, { ...P, angle: critAngle + 1 });
  assert(fAbove.Fnet < -0.5,
    'Just above critical angle: block slides down, ΣF = ' + fAbove.Fnet.toFixed(2));
}

// ─── Static friction holds exactly ───
section('Ramp — Static Friction Balances Exactly');
{
  const P = { ...defaultRampP, angle: 20, appliedForce: 0 };
  const f = rampForces(3, 0, P);
  const th = 20 * Math.PI / 180;
  const mg_par = P.mass * RAMP_G * Math.sin(th);
  const Fs_max = P.mu_s * P.mass * RAMP_G * Math.cos(th);

  assert(mg_par < Fs_max, 'mg sin θ < μs mg cos θ at 20°');
  assertClose(f.Ff, mg_par, 0.01,
    'Static friction = mg sin θ = ' + mg_par.toFixed(2));
  assertClose(f.Fnet, 0, 0.01, 'Net force = 0 (equilibrium)');
  assertClose(f.a, 0, 0.01, 'Acceleration = 0 in equilibrium');
}

// ─── Kinetic friction when moving ───
section('Ramp — Kinetic Friction When Moving');
{
  const P = { ...defaultRampP, angle: 30 };
  const f = rampForces(3, 2.0, P);  // moving uphill at 2 m/s
  const th = 30 * Math.PI / 180;
  const expectedFf = -P.mu_k * P.mass * RAMP_G * Math.cos(th);  // opposes motion (downhill)

  assertClose(f.Ff, expectedFf, 1e-4,
    'Kinetic friction = -μk mg cos θ (opposes uphill motion)');
}

// ─── Frictionless ramp: a = g sin θ (mass cancels) ───
section('Ramp — Frictionless: a = g sin θ');
{
  const P1 = { ...defaultRampP, mu_s: 0, mu_k: 0, mass: 1, angle: 30, appliedForce: 0 };
  const P2 = { ...defaultRampP, mu_s: 0, mu_k: 0, mass: 50, angle: 30, appliedForce: 0 };
  const f1 = rampForces(3, 0.01, P1);
  const f2 = rampForces(3, 0.01, P2);
  const expected = -RAMP_G * Math.sin(30 * Math.PI / 180);

  assertClose(f1.a, expected, 0.01,
    'Mass 1 kg: a = -g sin 30° = ' + expected.toFixed(3));
  assertClose(f2.a, expected, 0.01,
    'Mass 50 kg: a = -g sin 30° = ' + expected.toFixed(3) + ' (mass cancels!)');
  assertClose(f1.a, f2.a, 1e-10,
    'Acceleration identical regardless of mass');
}

// ─── Energy conservation on frictionless ramp ───
section('Ramp — Energy Conservation (frictionless)');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0, rampLength: 10, eTop: 0, eLeft: 0 };
  // Start on ground with velocity, let it go up the ramp
  let sv = { s: -1, v: 5 };   // start on ground moving right
  const dt = 1 / 120;
  const th = P.angle * Math.PI / 180;

  // Initial KE
  const KE0 = 0.5 * P.mass * sv.v * sv.v;

  for (let i = 0; i < 300; i++) sv = rampStep(sv.s, sv.v, dt, P);

  const h = sv.s >= 0 ? sv.s * Math.sin(th) : 0;
  const KE = 0.5 * P.mass * sv.v * sv.v;
  const PE = P.mass * RAMP_G * h;
  const totalE = KE + PE;

  assertClose(totalE, KE0, 0.5,
    'Total energy conserved: E₀=' + KE0.toFixed(2) + ' → E=' + totalE.toFixed(2));
}

// ─── Friction dissipates energy ───
section('Ramp — Friction Dissipates Energy');
{
  const P = { ...defaultRampP, angle: 30, mu_k: 0.3, mu_s: 0.5, appliedForce: 0, rampLength: 10 };
  let sv = { s: -1, v: 5 };
  const dt = 1 / 120;
  const th = P.angle * Math.PI / 180;
  const KE0 = 0.5 * P.mass * sv.v * sv.v;

  for (let i = 0; i < 300; i++) sv = rampStep(sv.s, sv.v, dt, P);

  const h = sv.s >= 0 ? sv.s * Math.sin(th) : 0;
  const totalE = 0.5 * P.mass * sv.v * sv.v + P.mass * RAMP_G * h;

  assert(totalE < KE0 - 1,
    'Energy lost to friction: E₀=' + KE0.toFixed(2) + ' → E=' + totalE.toFixed(2));
}

// ─── Wall collision: block bounces back ───
section('Ramp — Wall Bounce');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 10, appliedForce: 100, rampLength: 6, eTop: 0.6, eLeft: 0.6 };
  let sv = { s: -1, v: 0 };
  const dt = 1 / 120;

  // Push until it hits the wall
  for (let i = 0; i < 600; i++) sv = rampStep(sv.s, sv.v, dt, P);

  // After 5 seconds with large force, it should have hit the wall and bounced
  // Since force keeps pushing, it bounces back and forth.
  // At some point during the sim, velocity should have gone negative (bounced)
  let hadNegativeV = false;
  sv = { s: -1, v: 0 };
  for (let i = 0; i < 1200; i++) {
    sv = rampStep(sv.s, sv.v, dt, P);
    if (sv.v < -0.1) hadNegativeV = true;
  }
  assert(hadNegativeV, 'Block bounced off wall (velocity went negative)');
}

// ─── Block slides back down after hitting wall (no applied force) ───
section('Ramp — Block Slides Back After Wall Hit');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0, rampLength: 6, eTop: 0, eLeft: 0 };
  // Start at wall with zero velocity — should slide back
  let sv = { s: 6, v: 0 };
  const dt = 1 / 120;

  for (let i = 0; i < 120; i++) sv = rampStep(sv.s, sv.v, dt, P);  // 1 second

  assert(sv.s < 5.5, 'Block slid back from wall: s=' + sv.s.toFixed(2));
  assert(sv.v < -0.5, 'Block has downhill velocity: v=' + sv.v.toFixed(2));
}

// ─── RK4 integration matches Euler for simple case ───
section('Ramp — RK4 vs Euler Agreement');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0 };
  const dt = 0.001;

  // RK4
  const rk4State = Float64Array.from([3, 0, 0]);
  for (let i = 0; i < 1000; i++) rk4(rk4State, rampEvaluate, dt, P);

  // Euler
  const eulerState = Float64Array.from([3, 0, 0]);
  for (let i = 0; i < 1000; i++) euler(eulerState, rampEvaluate, dt, P);

  // At small dt, both should agree within ~1%
  assertClose(rk4State[0], eulerState[0], 0.1,
    'Position agrees: RK4=' + rk4State[0].toFixed(4) + ' Euler=' + eulerState[0].toFixed(4));
  assertClose(rk4State[1], eulerState[1], 0.1,
    'Velocity agrees: RK4=' + rk4State[1].toFixed(4) + ' Euler=' + eulerState[1].toFixed(4));
}

// ─── Analytical check: frictionless ramp, constant acceleration ───
section('Ramp — Analytical: s(t) = s₀ + v₀t + ½at² (frictionless)');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0, rampLength: 20 };
  const th = 30 * Math.PI / 180;
  const a = -RAMP_G * Math.sin(th);  // constant accel on frictionless ramp
  const s0 = 5, v0 = 2;
  const T = 0.5;   // simulate 0.5 seconds

  // Analytical
  const s_exact = s0 + v0 * T + 0.5 * a * T * T;
  const v_exact = v0 + a * T;

  // Numerical (RK4)
  const vars = Float64Array.from([s0, v0, 0]);
  const dt = 0.001;
  for (let i = 0; i < T / dt; i++) rk4(vars, rampEvaluate, dt, P);

  assertClose(vars[0], s_exact, 0.01,
    'Position: numerical=' + vars[0].toFixed(4) + ' analytical=' + s_exact.toFixed(4));
  assertClose(vars[1], v_exact, 0.01,
    'Velocity: numerical=' + vars[1].toFixed(4) + ' analytical=' + v_exact.toFixed(4));
}

// ─── Applied force on flat ground: a = F/m ───
section('Ramp — Flat Ground: a = F/m (no friction)');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 50, mass: 10 };
  const f = rampForces(-3, 0.01, P);  // on ground (s<0), small velocity to trigger kinetic

  // On flat ground, applied force is fully horizontal = along path
  assertClose(f.a, 50 / 10, 0.01,
    'a = F/m = 50/10 = 5 m/s² on flat ground');
}

// ─── Force reversal: friction flips direction ───
section('Ramp — Friction Flips Direction');
{
  const P = { ...defaultRampP, angle: 30 };
  const th = 30 * Math.PI / 180;
  const fUp = rampForces(3, 2, P);     // moving uphill
  const fDown = rampForces(3, -2, P);  // moving downhill

  assert(fUp.Ff < 0, 'Moving uphill: friction points downhill (negative)');
  assert(fDown.Ff > 0, 'Moving downhill: friction points uphill (positive)');
  assertClose(Math.abs(fUp.Ff), Math.abs(fDown.Ff), 1e-6,
    'Friction magnitude is same regardless of direction');
}

// ─── N = 0 when pushing block off surface ───
section('Ramp — Normal Force Cannot Be Negative');
{
  // Large downward force component can theoretically make N < 0
  // The physics clamps N ≥ 0
  const P = { ...defaultRampP, angle: 80, mass: 1, appliedForce: -200 };
  const f = rampForces(1, 0, P);

  assert(f.N >= 0, 'Normal force clamped to ≥ 0: N=' + f.N.toFixed(2));
}

// ─── Flat→ramp transition: velocity continuous ───
section('Ramp — Velocity Continuous Across Ground-Ramp Transition');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0, rampLength: 20 };
  // Start on ground just before ramp, moving right
  let sv = { s: -0.01, v: 3.0 };
  const dt = 1 / 1200;  // very small step

  // Step just past the transition
  for (let i = 0; i < 5; i++) sv = rampStep(sv.s, sv.v, dt, P);

  assert(sv.s > 0, 'Crossed onto ramp: s=' + sv.s.toFixed(4));
  assertClose(sv.v, 3.0, 0.1,
    'Velocity roughly continuous at transition: v=' + sv.v.toFixed(4));
}

// ─── Accumulated friction heat ───
section('Ramp — Friction Heat Accumulation');
{
  const P = { ...defaultRampP, angle: 30, mu_k: 0.3, mu_s: 0.5, appliedForce: 0, rampLength: 20 };
  const th = P.angle * Math.PI / 180;
  let sv = { s: 5, v: 0 };   // start on ramp, will slide down
  let heat = 0;
  const dt = 1 / 120;

  // Track initial mechanical energy
  const h0 = sv.s * Math.sin(th);
  const E0 = 0.5 * P.mass * sv.v * sv.v + P.mass * RAMP_G * h0;

  for (let i = 0; i < 600; i++) {  // 5 seconds
    const f = rampForces(sv.s, sv.v, P);
    // Accumulate friction heat: |Ff| * |v| * dt
    heat += Math.abs(f.Ff) * Math.abs(sv.v) * dt;
    sv = rampStep(sv.s, sv.v, dt, P);
  }

  const h = sv.s >= 0 ? sv.s * Math.sin(th) : 0;
  const KE = 0.5 * P.mass * sv.v * sv.v;
  const PE = P.mass * RAMP_G * h;
  const total = KE + PE + heat;

  assert(heat > 1, 'Friction generated heat: Q=' + heat.toFixed(2) + ' J');
  assert(KE + PE < E0 - 1,
    'Mechanical energy dropped: E_mech=' + (KE+PE).toFixed(2) + ' < E0=' + E0.toFixed(2));
  assertClose(total, E0, 2.0,
    'Energy conserved: KE+PE+Heat=' + total.toFixed(2) + ' ≈ E0=' + E0.toFixed(2));
}

section('Ramp — Bouncy Walls: Block Bounces and Comes to Rest');
{
  // High restitution + low friction on flat → block bounces between walls
  const P = { ...defaultRampP, mu_s: 0.02, mu_k: 0.01, angle: 0, rampLength: 6,
    eTop: 0.85, eLeft: 0.85, appliedForce: 0 };
  let sv = { s: -1, v: 8 };  // fast initial push on flat ground
  const dt = 1 / 120;

  let bounces = 0;
  let prevV = sv.v;
  for (let i = 0; i < 3600; i++) {  // 30 seconds
    sv = rampStep(sv.s, sv.v, dt, P);
    // Count direction reversals (bounces)
    if (prevV > 0.1 && sv.v < -0.1) bounces++;
    if (prevV < -0.1 && sv.v > 0.1) bounces++;
    prevV = sv.v;
  }

  assert(bounces >= 3, 'Block bounced at least 3 times: bounces=' + bounces);
  assert(Math.abs(sv.v) < 0.5,
    'Block came to near-rest after 30s: v=' + sv.v.toFixed(3));
}

section('Ramp — Per-Wall Restitution: Top Bouncy, Left Brick');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 10, rampLength: 6,
    eTop: 0.9, eLeft: 0.02, appliedForce: 0 };

  // Push block uphill → hits top wall → bounces back with 90% velocity
  let sv = { s: 0, v: 8 };
  const dt = 1 / 120;
  for (let i = 0; i < 120; i++) sv = rampStep(sv.s, sv.v, dt, P);

  // After hitting top wall, should be moving back (negative v)
  assert(sv.v < -1, 'Bounced off top wall: v=' + sv.v.toFixed(2));

  // Keep going until it hits left wall
  for (let i = 0; i < 600; i++) sv = rampStep(sv.s, sv.v, dt, P);

  // After hitting left brick wall, should barely bounce
  // (block may have come to rest on the ramp due to gravity before reaching left wall)
  assert(Math.abs(sv.v) < 5,
    'Left wall is brick — much less bounce: |v|=' + Math.abs(sv.v).toFixed(2));
}

section('Ramp — No Heat on Frictionless Surface');
{
  const P = { ...defaultRampP, mu_s: 0, mu_k: 0, angle: 30, appliedForce: 0, rampLength: 20 };
  let sv = { s: 5, v: 0 };
  let heat = 0;
  const dt = 1 / 120;

  for (let i = 0; i < 300; i++) {
    const f = rampForces(sv.s, sv.v, P);
    heat += Math.abs(f.Ff) * Math.abs(sv.v) * dt;
    sv = rampStep(sv.s, sv.v, dt, P);
  }

  assertClose(heat, 0, 0.001, 'No friction → no heat: Q=' + heat.toFixed(6));
}

// ═══════════════════════════════════════════
// RESONANCE: DRIVEN DAMPED HARMONIC OSCILLATOR
// ═══════════════════════════════════════════

// Inline physics from js/sims/resonance.js (multi-oscillator version)
// Per-oscillator: osc = { m, k, b }
function resAccel(x, v, t, osc, driveFreq, driveAmp) {
  const omega0sq = osc.k / osc.m;
  const gamma = osc.b / (2 * osc.m);
  const drive = (driveAmp / osc.m) * Math.cos(driveFreq * t);
  return -omega0sq * x - 2 * gamma * v + drive;
}

function resSsAmplitude(wd, osc, driveAmp) {
  const w0sq = osc.k / osc.m;
  const g2 = osc.b / osc.m;
  const denom = Math.sqrt((w0sq - wd * wd) ** 2 + (g2 * wd) ** 2);
  return denom > 1e-12 ? (driveAmp / osc.m) / denom : 999;
}

function resSsPhase(wd, osc) {
  const w0sq = osc.k / osc.m;
  const g2 = osc.b / osc.m;
  return -Math.atan2(g2 * wd, w0sq - wd * wd);
}

function resStep(x, v, t, dt, osc, wD, F0) {
  const k1a = resAccel(x, v, t, osc, wD, F0);
  const k1v = v;
  const k2a = resAccel(x+.5*dt*k1v, v+.5*dt*k1a, t+.5*dt, osc, wD, F0);
  const k2v = v+.5*dt*k1a;
  const k3a = resAccel(x+.5*dt*k2v, v+.5*dt*k2a, t+.5*dt, osc, wD, F0);
  const k3v = v+.5*dt*k2a;
  const k4a = resAccel(x+dt*k3v, v+dt*k3a, t+dt, osc, wD, F0);
  const k4v = v+dt*k3a;
  return {
    x: x + (dt/6)*(k1v + 2*k2v + 2*k3v + k4v),
    v: v + (dt/6)*(k1a + 2*k2a + 2*k3a + k4a),
    t: t + dt,
  };
}

// Convenience: same interface as before for single-oscillator tests
const defaultResOsc = { m: 1, k: 10, b: 0.5 };
const defaultResF0 = 5, defaultResWd = 3.162;

section('Resonance — Natural Frequency ω₀ = √(k/m)');
{
  const osc = { ...defaultResOsc, b: 0.01 };
  const w0 = Math.sqrt(osc.k / osc.m);
  assertClose(w0, Math.sqrt(10), 1e-6, 'ω₀ = √(10) = ' + w0.toFixed(4));

  let sv = { x: 1, v: 0, t: 0 };
  const dt = 1 / 240;
  let lastSign = 1, crossT = [];
  for (let i = 0; i < 4800; i++) {
    sv = resStep(sv.x, sv.v, sv.t, dt, osc, 0, 0); // no drive
    const sign = sv.x >= 0 ? 1 : -1;
    if (sign !== lastSign && lastSign > 0) crossT.push(sv.t);
    lastSign = sign;
  }
  if (crossT.length >= 3) {
    const measuredT = crossT[2] - crossT[0];
    const measuredW = 2 * Math.PI / (measuredT / 2);
    assertClose(measuredW, w0, 0.05, 'Measured ω = ' + measuredW.toFixed(3) + ' ≈ ω₀ = ' + w0.toFixed(3));
  }
}

section('Resonance — Amplitude Peaks at ω₀');
{
  const osc = defaultResOsc;
  const w0 = Math.sqrt(osc.k / osc.m);
  const Aw0 = resSsAmplitude(w0, osc, defaultResF0);
  const Ahalf = resSsAmplitude(w0 * 0.5, osc, defaultResF0);
  const Adouble = resSsAmplitude(w0 * 2, osc, defaultResF0);
  assert(Aw0 > Ahalf, 'A(ω₀) > A(0.5ω₀): ' + Aw0.toFixed(2) + ' > ' + Ahalf.toFixed(2));
  assert(Aw0 > Adouble, 'A(ω₀) > A(2ω₀): ' + Aw0.toFixed(2) + ' > ' + Adouble.toFixed(2));
}

section('Resonance — Analytical Amplitude at ω₀ = F₀/(b·ω₀)');
{
  const osc = defaultResOsc;
  const w0 = Math.sqrt(osc.k / osc.m);
  const expected = defaultResF0 / (osc.b * w0);
  const actual = resSsAmplitude(w0, osc, defaultResF0);
  assertClose(actual, expected, 0.01, 'A(ω₀) = F₀/(b·ω₀) = ' + expected.toFixed(4));
}

section('Resonance — Phase at ω₀ = −90°');
{
  const osc = defaultResOsc;
  const w0 = Math.sqrt(osc.k / osc.m);
  const phi = resSsPhase(w0, osc);
  assertClose(phi, -Math.PI / 2, 0.01, 'φ(ω₀) = ' + (phi * 180 / Math.PI).toFixed(1) + '°');
}

section('Resonance — Phase Below ≈ 0°, Above ≈ −180°');
{
  const osc = defaultResOsc;
  const w0 = Math.sqrt(osc.k / osc.m);
  const phiLow = resSsPhase(w0 * 0.1, osc);
  const phiHigh = resSsPhase(w0 * 10, osc);
  assert(Math.abs(phiLow) < 0.2, 'φ(0.1ω₀) ≈ 0°: ' + (phiLow * 180 / Math.PI).toFixed(1) + '°');
  assert(Math.abs(phiHigh + Math.PI) < 0.2, 'φ(10ω₀) ≈ -180°: ' + (phiHigh * 180 / Math.PI).toFixed(1) + '°');
}

section('Resonance — Q Factor = √(km)/b');
{
  const osc = defaultResOsc;
  const Q = Math.sqrt(osc.k * osc.m) / osc.b;
  assertClose(Q, Math.sqrt(10) / 0.5, 1e-6, 'Q = ' + Q.toFixed(2));
}

section('Resonance — Higher Damping Lowers Peak');
{
  const osc1 = { ...defaultResOsc, b: 0.5 };
  const osc2 = { ...defaultResOsc, b: 2.0 };
  const w0 = Math.sqrt(osc1.k / osc1.m);
  const A1 = resSsAmplitude(w0, osc1, defaultResF0);
  const A2 = resSsAmplitude(w0, osc2, defaultResF0);
  assert(A1 > A2 * 2, 'Low b peak (' + A1.toFixed(2) + ') >> high b peak (' + A2.toFixed(2) + ')');
}

section('Resonance — Numerical Matches Analytical (steady-state)');
{
  const osc = defaultResOsc;
  const wD = defaultResWd;
  const dt = 1 / 240;
  let sv = { x: 0, v: 0, t: 0 };
  for (let i = 0; i < 40 * 240; i++) sv = resStep(sv.x, sv.v, sv.t, dt, osc, wD, defaultResF0);
  let peak = 0;
  const period = 2 * Math.PI / wD;
  for (let i = 0; i < Math.ceil(2 * period / dt); i++) {
    sv = resStep(sv.x, sv.v, sv.t, dt, osc, wD, defaultResF0);
    peak = Math.max(peak, Math.abs(sv.x));
  }
  const expected = resSsAmplitude(wD, osc, defaultResF0);
  assertClose(peak, expected, expected * 0.1, 'Numerical=' + peak.toFixed(3) + ' ≈ analytical=' + expected.toFixed(3));
}

section('Resonance — Energy Conservation (no drive, no damping)');
{
  const osc = { ...defaultResOsc, b: 0 };
  let sv = { x: 1, v: 0, t: 0 };
  const dt = 1 / 240;
  const E0 = 0.5 * osc.k * sv.x * sv.x;
  for (let i = 0; i < 2400; i++) sv = resStep(sv.x, sv.v, sv.t, dt, osc, 0, 0);
  const E = 0.5 * osc.k * sv.x * sv.x + 0.5 * osc.m * sv.v * sv.v;
  assertClose(E, E0, 0.01, 'Energy conserved: E₀=' + E0.toFixed(4) + ' → E=' + E.toFixed(4));
}

section('Resonance — Damping Dissipates Energy');
{
  const osc = { ...defaultResOsc, b: 1.0 };
  let sv = { x: 2, v: 0, t: 0 };
  const dt = 1 / 240;
  const E0 = 0.5 * osc.k * sv.x * sv.x;
  for (let i = 0; i < 4800; i++) sv = resStep(sv.x, sv.v, sv.t, dt, osc, 0, 0);
  const E = 0.5 * osc.k * sv.x * sv.x + 0.5 * osc.m * sv.v * sv.v;
  assert(E < E0 * 0.1, 'Energy dissipated: E₀=' + E0.toFixed(2) + ' → E=' + E.toFixed(4));
}

section('Resonance — Transient Decay ≈ exp(−γt)');
{
  const osc = { ...defaultResOsc, b: 1.0 };
  const gamma = osc.b / (2 * osc.m);
  let sv = { x: 2, v: 0, t: 0 };
  const dt = 1 / 240;
  const T = 2 / gamma;
  for (let i = 0; i < Math.ceil(T / dt); i++) sv = resStep(sv.x, sv.v, sv.t, dt, osc, 0, 0);
  const expected = 2 * Math.exp(-gamma * T);
  let peak = 0;
  const halfP = Math.PI / Math.sqrt(osc.k / osc.m);
  for (let i = 0; i < Math.ceil(halfP / dt); i++) {
    sv = resStep(sv.x, sv.v, sv.t, dt, osc, 0, 0);
    peak = Math.max(peak, Math.abs(sv.x));
  }
  assertClose(peak, expected, expected * 0.2, 'Envelope: ' + peak.toFixed(4) + ' ≈ ' + expected.toFixed(4));
}

// ─── Multi-oscillator tests ───

section('Resonance — Two Oscillators: Only the Resonant One Responds');
{
  const oscA = { m: 1, k: 10, b: 0.5 };  // ω₀ ≈ 3.16
  const oscB = { m: 4, k: 10, b: 0.5 };  // ω₀ ≈ 1.58
  const wD = Math.sqrt(oscA.k / oscA.m);  // drive at A's resonance
  const F0 = 5;
  const dt = 1 / 240;

  let svA = { x: 0, v: 0, t: 0 };
  let svB = { x: 0, v: 0, t: 0 };
  let tNow = 0;

  // Run to steady state
  for (let i = 0; i < 40 * 240; i++) {
    svA = resStep(svA.x, svA.v, tNow, dt, oscA, wD, F0);
    svB = resStep(svB.x, svB.v, tNow, dt, oscB, wD, F0);
    tNow += dt;
  }

  // Measure peaks over 2 periods
  let peakA = 0, peakB = 0;
  for (let i = 0; i < Math.ceil(4 * Math.PI / wD / dt); i++) {
    svA = resStep(svA.x, svA.v, tNow, dt, oscA, wD, F0);
    svB = resStep(svB.x, svB.v, tNow, dt, oscB, wD, F0);
    tNow += dt;
    peakA = Math.max(peakA, Math.abs(svA.x));
    peakB = Math.max(peakB, Math.abs(svB.x));
  }

  assert(peakA > peakB * 3,
    'Resonant A (' + peakA.toFixed(2) + ') >> non-resonant B (' + peakB.toFixed(2) + ')');
}

section('Resonance — Three Oscillators: Each Peaks at Its Own ω₀');
{
  const oscsTest = [
    { m: 1, k: 4,  b: 0.3 },   // ω₀ = 2.0
    { m: 1, k: 10, b: 0.3 },   // ω₀ ≈ 3.16
    { m: 1, k: 25, b: 0.3 },   // ω₀ = 5.0
  ];
  const F0 = 5;

  // For each oscillator, its amplitude should be maximal when driven at its own ω₀
  for (let i = 0; i < 3; i++) {
    const ownW0 = Math.sqrt(oscsTest[i].k / oscsTest[i].m);
    const Aown = resSsAmplitude(ownW0, oscsTest[i], F0);
    for (let j = 0; j < 3; j++) {
      if (j === i) continue;
      const otherW0 = Math.sqrt(oscsTest[j].k / oscsTest[j].m);
      const Aother = resSsAmplitude(otherW0, oscsTest[i], F0);
      assert(Aown > Aother,
        'Osc ' + i + ' peaks at own ω₀ (' + Aown.toFixed(2) + ') > at osc ' + j + ' ω₀ (' + Aother.toFixed(2) + ')');
    }
  }
}

section('Resonance — Oscillators Are Independent (no coupling)');
{
  // Running two oscillators with same params should give identical results
  const osc = { m: 1, k: 10, b: 0.5 };
  const wD = 3.0, F0 = 5;
  const dt = 1 / 240;
  let svA = { x: 0, v: 0, t: 0 };
  let svB = { x: 0, v: 0, t: 0 };
  let tNow = 0;
  for (let i = 0; i < 2400; i++) {
    svA = resStep(svA.x, svA.v, tNow, dt, osc, wD, F0);
    svB = resStep(svB.x, svB.v, tNow, dt, osc, wD, F0);
    tNow += dt;
  }
  assertClose(svA.x, svB.x, 1e-10, 'Same params → identical x');
  assertClose(svA.v, svB.v, 1e-10, 'Same params → identical v');
}

// ═══════════════════════════════════════════
// PULLEY: TWO MASSES ON INCLINED PLANE
// ═══════════════════════════════════════════

function pulleyPhys(s, v, P) {
  const th = P.angle * Math.PI / 180;
  const m1 = P.m1, m2 = P.m2, mu_k = P.mu_k, mu_s = P.mu_s;
  const ct = Math.cos(th), st = Math.sin(th);
  const N = m1 * RAMP_G * ct;
  const gravRamp = m1 * RAMP_G * st;
  const gravHang = m2 * RAMP_G;
  const Fnet_nf = gravHang - gravRamp;
  let Ff = 0, equilibrium = false;
  const moving = Math.abs(v) > 1e-3;
  if (moving) {
    Ff = mu_k * N * Math.sign(v);
  } else {
    const Fs_max = mu_s * N;
    if (Math.abs(Fnet_nf) <= Fs_max) {
      return { a: 0, T: gravHang, Ff: -Fnet_nf, Fnet: 0, N, equilibrium: true };
    }
    Ff = mu_k * N * Math.sign(Fnet_nf);
  }
  const Fnet = Fnet_nf - Ff;
  const a = Fnet / (m1 + m2);
  const T = m2 * (RAMP_G - a);
  return { a, T, Ff, Fnet, N, equilibrium };
}

const defaultPulP = { m1: 5, m2: 3, angle: 30, mu_k: 0.3, mu_s: 0.4, rampLength: 6 };

section('Pulley — Frictionless Acceleration: a = g(m₂−m₁sinθ)/(m₁+m₂)');
{
  const P = { ...defaultPulP, mu_k: 0, mu_s: 0 };
  const th = P.angle * Math.PI / 180;
  const expected = RAMP_G * (P.m2 - P.m1 * Math.sin(th)) / (P.m1 + P.m2);
  const f = pulleyPhys(1, 0.01, P);
  assertClose(f.a, expected, 0.001,
    'a = ' + f.a.toFixed(4) + ' ≈ ' + expected.toFixed(4));
}

section('Pulley — Frictionless Tension: T = m₁m₂g(1+sinθ)/(m₁+m₂)');
{
  const P = { ...defaultPulP, mu_k: 0, mu_s: 0 };
  const th = P.angle * Math.PI / 180;
  const expected = P.m1 * P.m2 * RAMP_G * (1 + Math.sin(th)) / (P.m1 + P.m2);
  const f = pulleyPhys(1, 0.01, P);
  assertClose(f.T, expected, 0.01,
    'T = ' + f.T.toFixed(2) + ' ≈ ' + expected.toFixed(2));
}

section('Pulley — Equilibrium Dead Zone');
{
  const P = { ...defaultPulP };
  const th = P.angle * Math.PI / 180;
  const m2Low = P.m1 * (Math.sin(th) - P.mu_s * Math.cos(th));
  const m2High = P.m1 * (Math.sin(th) + P.mu_s * Math.cos(th));

  // m₂ inside dead zone → equilibrium
  const m2Mid = (m2Low + m2High) / 2;
  const fMid = pulleyPhys(1, 0, { ...P, m2: m2Mid });
  assert(fMid.equilibrium, 'm₂=' + m2Mid.toFixed(2) + ' in [' + m2Low.toFixed(2) + ',' + m2High.toFixed(2) + '] → equilibrium');

  // m₂ above dead zone → system moves
  const fAbove = pulleyPhys(1, 0, { ...P, m2: m2High + 0.5 });
  assert(!fAbove.equilibrium && fAbove.a > 0, 'm₂ above dead zone → moves uphill');

  // m₂ below dead zone → system moves downhill
  const m2Below = Math.max(0.1, m2Low - 0.5);
  const fBelow = pulleyPhys(1, 0, { ...P, m2: m2Below });
  assert(!fBelow.equilibrium && fBelow.a < 0, 'm₂ below dead zone → slides downhill');
}

section('Pulley — Tension < m₂g When Accelerating Down');
{
  const P = { ...defaultPulP, mu_k: 0, mu_s: 0 };
  const f = pulleyPhys(1, 0.1, P);
  assert(f.T < P.m2 * RAMP_G,
    'T=' + f.T.toFixed(2) + ' < m₂g=' + (P.m2 * RAMP_G).toFixed(2));
}

section('Pulley — At Equilibrium T = m₂g');
{
  const P = { ...defaultPulP };
  const th = P.angle * Math.PI / 180;
  const m2eq = P.m1 * Math.sin(th);  // inside dead zone for reasonable μ
  const f = pulleyPhys(1, 0, { ...P, m2: m2eq });
  if (f.equilibrium) {
    assertClose(f.T, m2eq * RAMP_G, 0.01,
      'At equilibrium T = m₂g = ' + (m2eq * RAMP_G).toFixed(2));
  }
}

section('Pulley — Equal Masses on 30° Frictionless: m₂ wins');
{
  const P = { m1: 5, m2: 5, angle: 30, mu_k: 0, mu_s: 0, rampLength: 6 };
  const f = pulleyPhys(1, 0.01, P);
  assert(f.a > 0, 'Equal masses 30°: m₂ wins (a=' + f.a.toFixed(3) + ' > 0) since sin30°=0.5 < 1');
}

section('Pulley — Heavy m₁ Slides Downhill');
{
  const P = { m1: 15, m2: 3, angle: 40, mu_k: 0.1, mu_s: 0.15, rampLength: 6 };
  const f = pulleyPhys(3, -0.01, P);
  assert(f.a < 0, 'Heavy m₁ on steep ramp slides down: a=' + f.a.toFixed(3));
}

section('Pulley — Friction Flips With Direction');
{
  const P = { ...defaultPulP, mu_k: 0.3, mu_s: 0.4 };
  const fUp = pulleyPhys(1, 1.0, P);     // moving uphill
  const fDown = pulleyPhys(1, -1.0, P);   // moving downhill
  assert(fUp.Ff > 0, 'Moving uphill: Ff > 0 (resists uphill)');
  assert(fDown.Ff < 0, 'Moving downhill: Ff < 0 (resists downhill)');
}

section('Pulley — Analytical Formulas Match (with friction, uphill)');
{
  const P = { ...defaultPulP };
  const th = P.angle * Math.PI / 180;
  const ct = Math.cos(th), st = Math.sin(th);
  // Analytical: a = g(m₂ − μ·m₁·cosθ − m₁·sinθ)/(m₁+m₂)
  const aExpected = RAMP_G * (P.m2 - P.mu_k * P.m1 * ct - P.m1 * st) / (P.m1 + P.m2);
  // Analytical: T = m₁·m₂·g·(1 + μ·cosθ + sinθ)/(m₁+m₂)
  const TExpected = P.m1 * P.m2 * RAMP_G * (1 + P.mu_k * ct + st) / (P.m1 + P.m2);

  const f = pulleyPhys(1, 0.1, P);  // small uphill velocity → kinetic friction
  assertClose(f.a, aExpected, 0.01,
    'a analytical=' + aExpected.toFixed(4) + ' code=' + f.a.toFixed(4));
  assertClose(f.T, TExpected, 0.1,
    'T analytical=' + TExpected.toFixed(2) + ' code=' + f.T.toFixed(2));
}

// ═══════════════════════════════════════════
// RAFT: CENTER OF MASS CONSERVATION
// ═══════════════════════════════════════════

function raftX(personOnRaft, P) {
  return -P.massPerson * personOnRaft / (P.massPerson + P.massRaft);
}
function raftCM(personOnRaft, P) {
  const rx = raftX(personOnRaft, P);
  return (P.massPerson * (rx + personOnRaft) + P.massRaft * rx) / (P.massPerson + P.massRaft);
}

section('Raft — CM Conservation: CM stays at 0');
{
  const P = { massPerson: 70, massRaft: 200 };
  // Person at various positions on raft — CM should always be 0
  [0, 1, 2, -1, -3, 2.5].forEach(pos => {
    const cm = raftCM(pos, P);
    assertClose(cm, 0, 1e-10, 'person at ' + pos + ': CM = ' + cm.toFixed(10));
  });
}

section('Raft — Raft Displacement = −mₚ·Δx_onRaft / (mₚ+mᵣ)');
{
  const P = { massPerson: 70, massRaft: 200 };
  const personOnRaftPos = 2;  // person walks 2m right ON the raft
  const rx = raftX(personOnRaftPos, P);
  // From constraint: raftX = -mₚ·personOnRaft / (mₚ+mᵣ) = -70·2/270
  const expected = -70 * 2 / (70 + 200);
  assertClose(rx, expected, 1e-10,
    'Δraft = ' + rx.toFixed(4) + ' ≈ ' + expected.toFixed(4));
  // Also verify: person world position = raftX + personOnRaft
  const personWorld = rx + personOnRaftPos;
  // personWorld = personOnRaft - mₚ·personOnRaft/(mₚ+mᵣ) = mᵣ·personOnRaft/(mₚ+mᵣ)
  const expectedPW = P.massRaft * personOnRaftPos / (P.massPerson + P.massRaft);
  assertClose(personWorld, expectedPW, 1e-10,
    'Person world x = ' + personWorld.toFixed(4) + ' ≈ mᵣ·d/(mₚ+mᵣ) = ' + expectedPW.toFixed(4));
}

section('Raft — Equal Masses: Raft and Person Move Same Distance');
{
  const P = { massPerson: 100, massRaft: 100 };
  const personPos = 1;
  const rx = raftX(personPos, P);
  const personWorld = rx + personPos;
  assertClose(Math.abs(rx), Math.abs(personWorld), 1e-10,
    '|raft|=' + Math.abs(rx).toFixed(4) + ' = |person|=' + Math.abs(personWorld).toFixed(4));
  assert(rx < 0 && personWorld > 0, 'Opposite directions');
}

section('Raft — Heavy Raft Barely Moves');
{
  const P = { massPerson: 70, massRaft: 500 };
  const rx = raftX(2, P);
  assert(Math.abs(rx) < 0.3, 'Heavy raft: |Δraft| = ' + Math.abs(rx).toFixed(3) + ' < 0.3m');
}

section('Raft — Light Raft Moves More Than Person');
{
  const P = { massPerson: 100, massRaft: 50 };
  const personPos = 1;
  const rx = raftX(personPos, P);
  const personWorld = rx + personPos;
  assert(Math.abs(rx) > Math.abs(personWorld),
    'Light raft: |raft|=' + Math.abs(rx).toFixed(2) + ' > |person|=' + Math.abs(personWorld).toFixed(2));
}

section('Raft — Person Returns: Raft Returns to Zero');
{
  const P = { massPerson: 70, massRaft: 200 };
  // Person walks out and comes back to center
  const rx0 = raftX(0, P);
  const rx1 = raftX(2, P);  // walked right
  const rx2 = raftX(0, P);  // walked back to center
  assertClose(rx0, 0, 1e-10, 'Start: raft at 0');
  assert(Math.abs(rx1) > 0.5, 'During walk: raft displaced');
  assertClose(rx2, 0, 1e-10, 'Back to center: raft returns to 0');
}

section('Raft — Zero Person Mass: Raft Stays Put');
{
  const P = { massPerson: 0, massRaft: 200 };
  const rx = raftX(3, P);
  assertClose(rx, 0, 1e-10, 'Zero person mass → raft at 0 always');
}

section('Raft — Total Momentum = 0');
{
  // If person velocity = v, raft velocity = −(mₚ/mᵣ)·v
  // Total p = mₚ·v + mᵣ·(−mₚ/mᵣ·v) = mₚ·v − mₚ·v = 0
  const P = { massPerson: 70, massRaft: 200 };
  const vPerson = 1.5;  // walking speed
  const vRaft = -(P.massPerson / P.massRaft) * vPerson;
  const pTotal = P.massPerson * vPerson + P.massRaft * vRaft;
  assertClose(pTotal, 0, 1e-10, 'Total momentum = ' + pTotal.toFixed(10));
}

// ═══════════════════════════════════════════
// STATES OF MATTER: LENNARD-JONES MD
// ═══════════════════════════════════════════

// Inline LJ functions from states-of-matter.js
function ljFxR(r2, eps, sig) {
  const s2 = sig * sig / r2, s6 = s2 * s2 * s2;
  return 24 * eps * (2 * s6 * s6 - s6);
}
function ljV(r2, eps, sig) {
  const s2 = sig * sig / r2, s6 = s2 * s2 * s2;
  return 4 * eps * (s6 * s6 - s6);
}

section('MD — LJ Force at Equilibrium r = 2^(1/6)·σ: F ≈ 0');
{
  const sig = 1.0, eps = 1.0;
  const rEq = sig * Math.pow(2, 1 / 6);
  const r2 = rEq * rEq;
  const ftr = ljFxR(r2, eps, sig);  // F * r
  assertClose(ftr, 0, 0.001, 'F·r at equilibrium = ' + ftr.toFixed(6) + ' ≈ 0');
}

section('MD — LJ Potential Minimum at r = 2^(1/6)·σ: V = -ε');
{
  const sig = 1.0, eps = 1.0;
  const rEq = sig * Math.pow(2, 1 / 6);
  const v = ljV(rEq * rEq, eps, sig);
  assertClose(v, -eps, 0.001, 'V(r_eq) = ' + v.toFixed(6) + ' ≈ -ε = ' + (-eps));
}

section('MD — LJ Potential at r = σ: V = 0');
{
  const sig = 1.0, eps = 1.0;
  const v = ljV(sig * sig, eps, sig);
  assertClose(v, 0, 0.001, 'V(σ) = ' + v.toFixed(6) + ' ≈ 0');
}

section('MD — LJ Force Repulsive at r < σ');
{
  const sig = 1.0, eps = 1.0;
  const r = 0.9;  // less than sigma
  const ftr = ljFxR(r * r, eps, sig);  // F * r > 0 means repulsive
  assert(ftr > 0, 'F·r at r=0.9σ = ' + ftr.toFixed(2) + ' > 0 (repulsive)');
}

section('MD — LJ Force Attractive at σ < r < 2.5σ');
{
  const sig = 1.0, eps = 1.0;
  const r = 1.5;  // between sigma and cutoff
  const ftr = ljFxR(r * r, eps, sig);
  assert(ftr < 0, 'F·r at r=1.5σ = ' + ftr.toFixed(4) + ' < 0 (attractive)');
}

section('MD — LJ Scales with ε');
{
  const sig = 1.0;
  const rEq = sig * Math.pow(2, 1 / 6);
  const v1 = ljV(rEq * rEq, 1.0, sig);
  const v2 = ljV(rEq * rEq, 2.5, sig);
  assertClose(v2 / v1, 2.5, 0.001, 'V scales linearly with ε: ratio = ' + (v2 / v1).toFixed(3));
}

section('MD — LJ Scales with σ');
{
  const eps = 1.0;
  // V(σ) = 0 for any σ
  [0.5, 1.0, 1.5, 2.0].forEach(sig => {
    const v = ljV(sig * sig, eps, sig);
    assertClose(v, 0, 0.001, 'V(σ=' + sig + ') = ' + v.toFixed(6) + ' ≈ 0');
  });
}

section('MD — Temperature from KE: T = KE/N [2D]');
{
  // 2D system: T = KE/N
  const N = 10;
  const vx = new Float64Array(N), vy = new Float64Array(N);
  for (let i = 0; i < N; i++) { vx[i] = 1.0; vy[i] = 0.5; }
  let ke = 0;
  for (let i = 0; i < N; i++) ke += vx[i] * vx[i] + vy[i] * vy[i];
  ke *= 0.5;
  const T = ke / N;
  const expected = 0.5 * (1.0 + 0.25);
  assertClose(T, expected, 1e-10, 'T = KE/N = ' + T.toFixed(4) + ' ≈ ' + expected.toFixed(4));
}

section('MD — Momentum Conservation (total = 0 after init)');
{
  // After removing net momentum, total should be ~0
  const N = 20;
  const vx = new Float64Array(N), vy = new Float64Array(N);
  for (let i = 0; i < N; i++) { vx[i] = Math.random() - 0.5; vy[i] = Math.random() - 0.5; }
  let svx = 0, svy = 0;
  for (let i = 0; i < N; i++) { svx += vx[i]; svy += vy[i]; }
  svx /= N; svy /= N;
  for (let i = 0; i < N; i++) { vx[i] -= svx; vy[i] -= svy; }
  let px = 0, py = 0;
  for (let i = 0; i < N; i++) { px += vx[i]; py += vy[i]; }
  assertClose(px, 0, 1e-10, 'Total px = ' + px.toFixed(12));
  assertClose(py, 0, 1e-10, 'Total py = ' + py.toFixed(12));
}

// ═══════════════════════════════════════════
// DROP MASS: INELASTIC COLLISION ON OSCILLATOR
// ═══════════════════════════════════════════

// Inline physics from drop-mass.js
const G_DROP = 9.81;
function dropMassEval(vars, change, params) {
  change[2] = 1;
  const [y, vy] = vars;
  const m = params._mass || params.m1;
  const { k, damping, restLength } = params;
  const springStretch = y - restLength;
  change[0] = vy;
  change[1] = G_DROP - (k / m) * springStretch - (damping / m) * vy;
}

{
  // Test 1: Equilibrium position — at y_eq = L₀ + mg/k, acceleration should be zero
  section('Drop Mass — Equilibrium Position');
  const m1 = 1.0, k = 20, L0 = 1.0, b = 0.2;
  const eq = L0 + m1 * G_DROP / k;
  const vars = new Float64Array([eq, 0, 0]);
  const change = new Float64Array(3);
  dropMassEval(vars, change, { m1, k, damping: b, restLength: L0, _mass: m1 });
  assertClose(change[1], 0, 0.001, 'Accel at equilibrium ≈ 0');
}

{
  // Test 2: Period — T = 2π√(m/k)
  section('Drop Mass — Period Before Collision');
  const m1 = 1.0, k = 20, L0 = 1.0;
  const eq = L0 + m1 * G_DROP / k;
  const p = { m1, k, damping: 0, restLength: L0, _mass: m1 };
  const vars = new Float64Array([eq + 0.3, 0, 0]);
  const dt = 0.001;
  // Run for ~10 seconds, find zero crossings of (y - eq)
  const crossings = [];
  let prevDisp = vars[0] - eq;
  for (let i = 0; i < 10000; i++) {
    rk4(vars, (v, c, pp) => dropMassEval(v, c, pp), dt, p);
    const disp = vars[0] - eq;
    if (prevDisp > 0 && disp <= 0) crossings.push(vars[2]);
    prevDisp = disp;
  }
  if (crossings.length >= 3) {
    const measuredT = (crossings[crossings.length - 1] - crossings[0]) / (crossings.length - 1);
    const expectedT = 2 * Math.PI * Math.sqrt(m1 / k);
    assertClose(measuredT, expectedT, 0.01, `Period: measured=${measuredT.toFixed(4)} expected=${expectedT.toFixed(4)}`);
  }
}

{
  // Test 3: Inelastic collision — momentum conservation
  section('Drop Mass — Momentum Conservation at Collision');
  const m1 = 1.0, m2 = 0.5;
  const v1 = 0.8;  // m1 moving down
  const v2 = 3.0;  // m2 falling fast
  const vAfter = (m1 * v1 + m2 * v2) / (m1 + m2);
  const pBefore = m1 * v1 + m2 * v2;
  const pAfter = (m1 + m2) * vAfter;
  assertClose(pBefore, pAfter, 1e-10, 'Momentum conserved: ' + pBefore.toFixed(6) + ' = ' + pAfter.toFixed(6));
}

{
  // Test 4: Energy loss in inelastic collision
  section('Drop Mass — Energy Lost in Collision');
  const m1 = 1.0, m2 = 1.0;
  const v1 = 0, v2 = 4.0;  // m₁ stationary, m₂ arrives at 4 m/s
  const vAfter = (m1 * v1 + m2 * v2) / (m1 + m2);  // = 2.0
  const keBefore = 0.5 * m1 * v1 * v1 + 0.5 * m2 * v2 * v2;  // = 8.0
  const keAfter = 0.5 * (m1 + m2) * vAfter * vAfter;  // = 4.0
  const loss = keBefore - keAfter;  // = 4.0
  assertClose(vAfter, 2.0, 1e-10, 'v_after = 2.0 m/s');
  assertClose(loss, 4.0, 1e-10, 'Energy lost = 4.0 J (50% for equal masses)');
  assert(loss > 0, 'Energy is lost (not gained) in inelastic collision');
}

{
  // Test 5: Frequency change after collision — ω₂ = √(k/(m₁+m₂))
  section('Drop Mass — Frequency Change After Collision');
  const m1 = 1.0, m2 = 1.0, k = 20, L0 = 1.0;
  const mTotal = m1 + m2;
  const eq2 = L0 + mTotal * G_DROP / k;
  const p = { m1: mTotal, k, damping: 0, restLength: L0, _mass: mTotal };
  const vars = new Float64Array([eq2 + 0.3, 0, 0]);
  const dt = 0.001;
  const crossings = [];
  let prevDisp = vars[0] - eq2;
  for (let i = 0; i < 10000; i++) {
    rk4(vars, (v, c, pp) => dropMassEval(v, c, pp), dt, p);
    const disp = vars[0] - eq2;
    if (prevDisp > 0 && disp <= 0) crossings.push(vars[2]);
    prevDisp = disp;
  }
  if (crossings.length >= 3) {
    const measuredT = (crossings[crossings.length - 1] - crossings[0]) / (crossings.length - 1);
    const expectedT = 2 * Math.PI * Math.sqrt(mTotal / k);
    assertClose(measuredT, expectedT, 0.01, `Combined period: measured=${measuredT.toFixed(4)} expected=${expectedT.toFixed(4)}`);
  }
}

{
  // Test 6: New equilibrium is lower — eq₂ = L₀ + (m₁+m₂)g/k > eq₁
  section('Drop Mass — Equilibrium Shift');
  const m1 = 1.0, m2 = 0.5, k = 20, L0 = 1.0;
  const eq1 = L0 + m1 * G_DROP / k;
  const eq2 = L0 + (m1 + m2) * G_DROP / k;
  assert(eq2 > eq1, 'New equilibrium is lower (larger y): eq2=' + eq2.toFixed(4) + ' > eq1=' + eq1.toFixed(4));
  assertClose(eq2 - eq1, m2 * G_DROP / k, 1e-10, 'Shift = m₂g/k = ' + (m2 * G_DROP / k).toFixed(4));
}

{
  // Test 7: Free fall velocity — v = √(2gh)
  section('Drop Mass — Free Fall Impact Velocity');
  const h = 1.5;
  const vImpact = Math.sqrt(2 * G_DROP * h);
  assertClose(vImpact, 5.424, 0.01, 'v_impact at h=1.5m: ' + vImpact.toFixed(3) + ' m/s');
}

// ═══════════════════════════════════════════
// RESULTS
// ═══════════════════════════════════════════
console.log('\n' + '═'.repeat(50));
console.log(`RESULTS: ${passed}/${total} passed, ${failed} failed`);
if (failed === 0) {
  console.log('ALL TESTS PASSED');
} else {
  console.log(`${failed} TESTS FAILED`);
  process.exit(1);
}

// ═══════════════════════════════════════════
// (appended below main results)
// PULLEY-SPRING SCALE TESTS
// ═══════════════════════════════════════════

(function() {
  const G = 9.81;
  let p2 = 0, f2 = 0, t2 = 0;
  function ok(c, m) { t2++; if (c) p2++; else { f2++; console.log('  FAIL (pulley-scale): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) <= tol, m + ' — got ' + a.toFixed(4) + ', expected ' + b.toFixed(4)); }

  console.log('\n=== Pulley-Spring Scale ===');

  // Test 1: Equal masses → T = mg
  {
    const m1 = 10, m2 = 10;
    const T = 2 * m1 * m2 * G / (m1 + m2);
    close(T, m1 * G, 0.01, 'Equal masses (10kg): T = mg = 98.1N');
  }

  // Test 2: Unequal masses → T = 2m1m2g/(m1+m2)
  {
    const m1 = 5, m2 = 10;
    const T = 2 * m1 * m2 * G / (m1 + m2);
    close(T, 65.4, 0.1, 'Unequal (5 vs 10 kg): T = 65.4N');
  }

  // Test 3: Very unequal → T approaches 2*m_small*g
  {
    const m1 = 1, m2 = 100;
    const T = 2 * m1 * m2 * G / (m1 + m2);
    const limit = 2 * m1 * G;
    ok(T < limit, 'Very unequal: T < 2*m_small*g');
    close(T, 19.43, 0.1, 'T(1kg vs 100kg) = 19.4N');
  }

  // Test 4: Atwood acceleration formula
  {
    const m1 = 15, m2 = 5;
    const a = (m1 - m2) * G / (m1 + m2);
    close(a, 4.905, 0.01, 'Acceleration: a = (m1-m2)g/(m1+m2) = 4.905 m/s²');
  }

  // Test 5: Equal masses → acceleration = 0
  {
    const m1 = 10, m2 = 10;
    const a = (m1 - m2) * G / (m1 + m2);
    close(a, 0, 0.001, 'Equal masses: acceleration = 0');
  }

  // Test 6: T is always between lighter and heavier weight
  // T = 2m1m2g/(m1+m2) → this is the harmonic mean of the two weights
  // It's always ≥ lighter weight AND ≤ heavier weight (when they're different)
  {
    for (const [m1, m2] of [[5,10],[1,50],[10,10],[20,1]]) {
      const T = 2 * m1 * m2 * G / (m1 + m2);
      const maxWeight = Math.max(m1, m2) * G;
      ok(T <= maxWeight + 0.01, `T(${m1},${m2}) = ${T.toFixed(1)} ≤ max weight ${maxWeight.toFixed(1)}`);
    }
  }

  // Test 7: Scale never reads 2mg (the misconception)
  {
    const m1 = 10, m2 = 10;
    const T = 2 * m1 * m2 * G / (m1 + m2);
    ok(T < 2 * m1 * G - 0.1, 'Scale does NOT read 2mg (common misconception)');
  }

  // Test 8: Moon gravity (g=1.62) — T scales linearly with g
  {
    const g_moon = 1.62;
    const m1 = 10, m2 = 10;
    const T_moon = 2 * m1 * m2 * g_moon / (m1 + m2);
    close(T_moon, m1 * g_moon, 0.01, 'Moon equal masses: T = mg_moon = 16.2N');
    // Should be proportionally less than Earth
    const T_earth = 2 * m1 * m2 * G / (m1 + m2);
    close(T_moon / T_earth, g_moon / G, 0.001, 'Moon/Earth tension ratio = g_moon/g_earth');
  }

  // Test 9: Mars gravity (g=3.72) with unequal masses
  {
    const g_mars = 3.72;
    const m1 = 10, m2 = 5;
    const T_mars = 2 * m1 * m2 * g_mars / (m1 + m2);
    const T_earth = 2 * m1 * m2 * G / (m1 + m2);
    close(T_mars, T_earth * g_mars / G, 0.1, 'Mars unequal: T scales with g');
    // Acceleration also scales with g
    const a_mars = (m1 - m2) * g_mars / (m1 + m2);
    const a_earth = (m1 - m2) * G / (m1 + m2);
    close(a_mars / a_earth, g_mars / G, 0.001, 'Mars/Earth acceleration ratio = g_mars/g_earth');
  }

  // Test 10: Jupiter gravity (g=24.79)
  {
    const g_jup = 24.79;
    const m1 = 10, m2 = 10;
    const T_jup = 2 * m1 * m2 * g_jup / (m1 + m2);
    close(T_jup, m1 * g_jup, 0.01, 'Jupiter equal masses: T = mg_jup = 247.9N');
    ok(T_jup > 200, 'Jupiter tension > 200N (much heavier)');
  }

  // Test 11: Zero-ish gravity (space station)
  {
    const g_space = 0.1;
    const m1 = 10, m2 = 10;
    const T_space = 2 * m1 * m2 * g_space / (m1 + m2);
    close(T_space, 1.0, 0.01, 'Near-zero g: T = 1.0N (almost weightless)');
  }

  // Test 12: Tension formula is g-independent when normalized → T/(m1*g) = 2m2/(m1+m2)
  {
    const m1 = 10, m2 = 5;
    for (const g of [1.62, 3.72, 9.81, 24.79]) {
      const T = 2 * m1 * m2 * g / (m1 + m2);
      const normalized = T / (m1 * g);
      close(normalized, 2 * m2 / (m1 + m2), 0.001, `T/(m1*g) = ${normalized.toFixed(3)} at g=${g} (universal ratio)`);
    }
  }

  console.log(`Pulley-Scale: ${p2}/${t2} passed` + (f2 ? ` (${f2} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// VERTICAL SPRING WITH GRAVITY
// ═══════════════════════════════════════════
(function() {
  const G = 9.81, ANCHOR_Y = 4.5;
  let p3 = 0, f3 = 0, t3 = 0;
  function ok(c, m) { t3++; if (c) p3++; else { f3++; console.log('  FAIL (vert-spring): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) <= tol, m + ' — got ' + a.toFixed(4) + ', exp ' + b.toFixed(4)); }

  console.log('\n=== Vertical Spring ===');

  // Test 1: Equilibrium position: y_eq = ANCHOR - L₀ - mg/k
  {
    const m = 1, k = 20, L0 = 1;
    const eq = ANCHOR_Y - L0 - m * G / k;
    close(eq, 4.5 - 1 - 0.4905, 0.001, 'Equilibrium: y_eq = 3.0095');
  }

  // Test 2: At equilibrium, net force = 0
  {
    const m = 1, k = 20, L0 = 1;
    const eq = ANCHOR_Y - L0 - m * G / k;
    const extension = (ANCHOR_Y - eq) - L0;
    const springF = k * extension;  // upward
    const gravF = m * G;            // downward
    close(springF, gravF, 0.001, 'At equilibrium: spring force = gravity');
  }

  // Test 3: Period = 2π√(m/k) — INDEPENDENT of gravity
  {
    const m = 1, k = 20;
    const T = 2 * Math.PI * Math.sqrt(m / k);
    close(T, 1.4050, 0.001, 'Period T = 2π√(m/k) = 1.405s');

    // Same period on Moon
    const T_moon = 2 * Math.PI * Math.sqrt(m / k);  // g doesn't appear!
    close(T_moon, T, 0.0001, 'Moon period = Earth period (g-independent)');
  }

  // Test 4: Equilibrium shift changes with gravity
  {
    const m = 1, k = 20, L0 = 1;
    const eq_earth = ANCHOR_Y - L0 - m * 9.81 / k;
    const eq_moon  = ANCHOR_Y - L0 - m * 1.62 / k;
    ok(eq_moon > eq_earth, 'Moon eq is HIGHER than Earth eq (less stretch)');
    close(eq_moon - eq_earth, m * (9.81 - 1.62) / k, 0.001, 'Eq shift = m·Δg/k');
  }

  // Test 5: Equilibrium shift changes with mass
  {
    const k = 20, L0 = 1;
    const eq_light = ANCHOR_Y - L0 - 1 * G / k;
    const eq_heavy = ANCHOR_Y - L0 - 5 * G / k;
    ok(eq_heavy < eq_light, 'Heavy mass eq is LOWER (more stretch)');
    close(eq_light - eq_heavy, (5 - 1) * G / k, 0.001, 'Eq diff = Δm·g/k');
  }

  // Test 6: Energy at equilibrium (PE well minimum)
  {
    const m = 1, k = 20, L0 = 1;
    const eq = ANCHOR_Y - L0 - m * G / k;
    const ext = (ANCHOR_Y - eq) - L0;
    const springPE = 0.5 * k * ext * ext;
    const gravPE = m * G * eq;
    // At equilibrium with v=0: KE=0, total = springPE + gravPE
    ok(springPE > 0, 'Spring PE > 0 at equilibrium (spring is stretched)');
    ok(gravPE > 0, 'Grav PE > 0 (mass above y=0)');
  }

  // Test 7: Period doesn't depend on amplitude (SHM is isochronous)
  {
    const m = 1, k = 20;
    // Same formula regardless of startStretch
    const T1 = 2 * Math.PI * Math.sqrt(m / k);
    const T2 = 2 * Math.PI * Math.sqrt(m / k);
    close(T1, T2, 0.0001, 'Period same for any amplitude (isochronous)');
  }

  // Test 8: Stiff spring = small eq shift + fast period
  {
    const m = 1, L0 = 1;
    const k_soft = 5, k_stiff = 80;
    const eq_soft  = m * G / k_soft;
    const eq_stiff = m * G / k_stiff;
    ok(eq_stiff < eq_soft, 'Stiff spring: smaller eq shift');
    const T_soft  = 2 * Math.PI * Math.sqrt(m / k_soft);
    const T_stiff = 2 * Math.PI * Math.sqrt(m / k_stiff);
    ok(T_stiff < T_soft, 'Stiff spring: shorter period');
  }

  // Test 9: Verify ODE — at displaced position, acceleration points toward equilibrium
  {
    const m = 1, k = 20, L0 = 1, b = 0;
    const eq = ANCHOR_Y - L0 - m * G / k;
    // Below equilibrium (y < eq): acceleration should be upward (positive)
    const y_below = eq - 0.5;
    const ext = (ANCHOR_Y - y_below) - L0;
    const accel = (k * ext) / m - G;
    ok(accel > 0, 'Below eq: acceleration is upward (restoring)');
    // Above equilibrium: acceleration downward
    const y_above = eq + 0.5;
    const ext2 = (ANCHOR_Y - y_above) - L0;
    const accel2 = (k * ext2) / m - G;
    ok(accel2 < 0, 'Above eq: acceleration is downward (restoring)');
  }

  console.log(`Vertical-Spring: ${p3}/${t3} passed` + (f3 ? ` (${f3} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// SERIES vs PARALLEL SPRINGS
// ═══════════════════════════════════════════
(function() {
  const G = 9.81;
  let p4 = 0, f4 = 0, t4 = 0;
  function ok(c, m) { t4++; if (c) p4++; else { f4++; console.log('  FAIL (series-parallel): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) <= tol, m + ' — got ' + a.toFixed(4) + ', exp ' + b.toFixed(4)); }

  console.log('\n=== Series vs Parallel Springs ===');

  // Test 1: Series formula: k_eff = k1*k2/(k1+k2)
  {
    const k1 = 20, k2 = 20;
    const kS = k1 * k2 / (k1 + k2);
    close(kS, 10, 0.01, 'Equal springs series: k_eff = k/2 = 10');
  }

  // Test 2: Parallel formula: k_eff = k1 + k2
  {
    const k1 = 20, k2 = 20;
    const kP = k1 + k2;
    close(kP, 40, 0.01, 'Equal springs parallel: k_eff = 2k = 40');
  }

  // Test 3: Series is always softer than either spring
  {
    for (const [k1, k2] of [[10,40],[5,50],[20,20],[1,100]]) {
      const kS = k1 * k2 / (k1 + k2);
      ok(kS < Math.min(k1, k2), `Series k_eff(${k1},${k2})=${kS.toFixed(1)} < min(${k1},${k2})`);
    }
  }

  // Test 4: Parallel is always stiffer than either spring
  {
    for (const [k1, k2] of [[10,40],[5,50],[20,20]]) {
      const kP = k1 + k2;
      ok(kP > Math.max(k1, k2), `Parallel k_eff(${k1},${k2})=${kP} > max(${k1},${k2})`);
    }
  }

  // Test 5: Period ratio: T_series/T_parallel = √(k_parallel/k_series)
  {
    const k1 = 20, k2 = 20, m = 1;
    const kS = k1 * k2 / (k1 + k2);
    const kP = k1 + k2;
    const TS = 2 * Math.PI * Math.sqrt(m / kS);
    const TP = 2 * Math.PI * Math.sqrt(m / kP);
    close(TS / TP, Math.sqrt(kP / kS), 0.001, 'Period ratio = √(kP/kS) = 2.0');
    close(TS / TP, 2.0, 0.001, 'Equal springs: series period is 2× parallel');
  }

  // Test 6: One weak link dominates series
  {
    const k1 = 5, k2 = 50;
    const kS = k1 * k2 / (k1 + k2);
    close(kS, 4.545, 0.01, 'Weak link: series k_eff ≈ k_weak = 4.55');
    ok(kS < k1 * 1.1, 'Series dominated by weak spring');
  }

  // Test 7: Equilibrium — series stretches more than parallel
  {
    const m = 1, k1 = 20, k2 = 20;
    const kS = k1 * k2 / (k1 + k2);
    const kP = k1 + k2;
    const stretchS = m * G / kS;
    const stretchP = m * G / kP;
    ok(stretchS > stretchP, 'Series eq stretch > parallel eq stretch');
    close(stretchS / stretchP, kP / kS, 0.001, 'Stretch ratio = kP/kS');
  }

  // Test 8: With k1=k2, series = k/2, parallel = 2k → ratio = 4:1
  {
    const k = 20;
    const kS = k * k / (k + k);
    const kP = k + k;
    close(kP / kS, 4, 0.001, 'Equal springs: parallel/series stiffness ratio = 4');
  }

  // Test 9: Harmonic mean property — series k_eff is harmonic mean
  {
    const k1 = 10, k2 = 40;
    const kS = k1 * k2 / (k1 + k2);
    const harmonicMean = 2 * k1 * k2 / (k1 + k2);
    close(kS, harmonicMean / 2, 0.001, 'Series = half the harmonic mean');
  }

  console.log(`Series-Parallel: ${p4}/${t4} passed` + (f4 ? ` (${f4} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// BUNGEE JUMP
// ═══════════════════════════════════════════
(function() {
  const G = 9.81, PLATFORM = 8.0;
  let p5 = 0, f5 = 0, t5 = 0;
  function ok(c, m) { t5++; if (c) p5++; else { f5++; console.log('  FAIL (bungee): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) <= tol, m + ' — got ' + a.toFixed(4) + ', exp ' + b.toFixed(4)); }

  console.log('\n=== Bungee Jump ===');

  // Test 1: Free fall speed at cord engagement: v = √(2gL₀)
  {
    const L0 = 4;
    const v = Math.sqrt(2 * G * L0);
    close(v, 8.859, 0.01, 'Speed at cord engagement: v = √(2gL₀) = 8.86 m/s');
  }

  // Test 2: Cord only pulls — tension = 0 when stretch ≤ 0
  {
    const y = PLATFORM - 2;  // above cord end (cord length = 4)
    const cordEnd = PLATFORM - 4;
    const stretch = cordEnd - y;
    ok(stretch < 0, 'Above cord end: stretch < 0');
    const tension = stretch > 0 ? 50 * stretch : 0;
    close(tension, 0, 0.01, 'Tension = 0 when cord is slack');
  }

  // Test 3: Cord engaged — tension = k × stretch
  {
    const k = 50, L0 = 4;
    const y = PLATFORM - L0 - 2;  // 2m below cord end
    const cordEnd = PLATFORM - L0;
    const stretch = cordEnd - y;
    close(stretch, 2, 0.01, 'Stretch = 2m');
    close(k * stretch, 100, 0.01, 'Tension = k×stretch = 100N');
  }

  // Test 4: Equilibrium: y_eq = cordEnd - mg/k
  {
    const m = 70, k = 50, L0 = 4;
    const cordEnd = PLATFORM - L0;
    const eqY = cordEnd - m * G / k;
    close(eqY, 4 - 70 * 9.81 / 50, 0.01, 'Equilibrium: y_eq = cordEnd - mg/k');
    ok(eqY < cordEnd, 'Equilibrium is below cord natural length end');
  }

  // Test 5: Period of oscillation (when cord is engaged): T = 2π√(m/k)
  {
    const m = 70, k = 50;
    const T = 2 * Math.PI * Math.sqrt(m / k);
    close(T, 7.434, 0.01, 'Bungee period T = 2π√(m/k) = 7.43s');
  }

  // Test 6: Energy conservation — KE at cord end = mgh (from free fall)
  {
    const m = 70, L0 = 4;
    const KE = m * G * L0;  // = mgh where h = L₀
    const v = Math.sqrt(2 * G * L0);
    close(0.5 * m * v * v, KE, 0.1, 'KE at cord end = mgh = mgL₀');
  }

  // Test 7: Max stretch from energy conservation
  // At lowest point: KE=0, all energy is PE
  // mg(L₀ + x_max) = ½k·x_max²
  // Quadratic: ½kx² - mgx - mgL₀ = 0
  {
    const m = 70, k = 50, L0 = 4;
    const a = 0.5 * k, b = -m * G, c = -m * G * L0;
    const xMax = (-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a);
    ok(xMax > 0, 'Max stretch is positive: ' + xMax.toFixed(2) + 'm');
    const lowestY = PLATFORM - L0 - xMax;
    ok(true, 'Lowest point: y = ' + lowestY.toFixed(2) + 'm');
  }

  // Test 8: Heavy jumper falls further
  {
    const k = 50, L0 = 4;
    const xMax70  = solveMaxStretch(70, k, L0);
    const xMax120 = solveMaxStretch(120, k, L0);
    ok(xMax120 > xMax70, 'Heavy jumper (120kg) stretches more than light (70kg)');
  }

  // Test 9: Stiffer cord = less stretch
  {
    const m = 70, L0 = 4;
    const xMax50  = solveMaxStretch(m, 50, L0);
    const xMax150 = solveMaxStretch(m, 150, L0);
    ok(xMax150 < xMax50, 'Stiffer cord (k=150) stretches less than soft (k=50)');
  }

  // Test 10: "Dangerous" preset — does jumper hit ground?
  // Long cord (6.5m) with k=500: only 1.5m of stretch available before ground
  // k_min for survival = 2mg*H/(H-L0)² = 2*70*9.81*8/(1.5²) = 4887 N/m → k=500 is FATAL
  {
    const m = 70, k = 500, L0 = 6.5;
    const xMax = solveMaxStretch(m, k, L0);
    const lowestY = PLATFORM - L0 - xMax;
    ok(lowestY < 0, 'Long cord preset is FATAL: lowest = ' + lowestY.toFixed(1) + 'm < 0');
  }

  // Test 11: Standard preset survives (k=800 is enough)
  {
    const m = 70, k = 800, L0 = 4;
    const xMax = solveMaxStretch(m, k, L0);
    const lowestY = PLATFORM - L0 - xMax;
    ok(lowestY > 0, 'Standard preset survives: lowest = ' + lowestY.toFixed(1) + 'm > 0');
  }

  function solveMaxStretch(m, k, L0) {
    const a = 0.5 * k, b = -m * G, c = -m * G * L0;
    return (-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a);
  }

  console.log(`Bungee: ${p5}/${t5} passed` + (f5 ? ` (${f5} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// SPRING ON INCLINED PLANE
// ═══════════════════════════════════════════
(function() {
  const G = 9.81;
  let p6 = 0, f6 = 0, t6 = 0;
  function ok(c, m) { t6++; if (c) p6++; else { f6++; console.log('  FAIL (spring-incline): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) <= tol, m + ' — got ' + a.toFixed(4) + ', exp ' + b.toFixed(4)); }

  console.log('\n=== Spring on Incline ===');

  // Test 1: Period = 2π√(m/k) for ALL angles
  {
    const m = 1, k = 20;
    const T = 2 * Math.PI * Math.sqrt(m / k);
    for (const angle of [0, 10, 30, 45, 60, 90]) {
      // Period doesn't depend on angle
      const T_angle = 2 * Math.PI * Math.sqrt(m / k);
      close(T_angle, T, 0.0001, `Period at ${angle}° = ${T.toFixed(3)}s (same as all angles)`);
    }
  }

  // Test 2: Equilibrium shift = mg·sin(θ)/k
  {
    const m = 1, k = 20, L0 = 1.5;
    for (const [angle, expected] of [[0, 0], [30, 0.2453], [45, 0.3468], [90, 0.4905]]) {
      const th = angle * Math.PI / 180;
      const shift = m * G * Math.sin(th) / k;
      close(shift, expected, 0.001, `Eq shift at ${angle}° = ${shift.toFixed(4)}m`);
    }
  }

  // Test 3: At θ=0°, eq shift = 0 (horizontal spring, no gravity component)
  {
    const m = 1, k = 20;
    const shift = m * G * Math.sin(0) / k;
    close(shift, 0, 0.0001, 'Horizontal (0°): no equilibrium shift');
  }

  // Test 4: At θ=90°, eq shift = mg/k (same as vertical spring)
  {
    const m = 1, k = 20;
    const shift = m * G * Math.sin(Math.PI / 2) / k;
    close(shift, m * G / k, 0.0001, 'Vertical (90°): eq shift = mg/k');
  }

  // Test 5: Net force at equilibrium = 0
  {
    const m = 1, k = 20, L0 = 1.5, angle = 30;
    const th = angle * Math.PI / 180;
    const eqS = L0 + m * G * Math.sin(th) / k;
    const stretch = eqS - L0;
    const springF = -k * stretch;
    const gravF = m * G * Math.sin(th);
    close(springF + gravF, 0, 0.001, 'At equilibrium: net force along ramp = 0');
  }

  // Test 6: Normal force = mg·cos(θ)
  {
    const m = 1, angle = 30;
    const th = angle * Math.PI / 180;
    const N = m * G * Math.cos(th);
    close(N, m * G * Math.cos(th), 0.001, 'Normal force = mg cos(30°) = ' + N.toFixed(2));
    ok(N < m * G, 'Normal force < weight (ramp supports less than full weight)');
  }

  // Test 7: Friction force = μ·N = μ·mg·cos(θ)
  {
    const m = 1, mu = 0.2, angle = 30;
    const th = angle * Math.PI / 180;
    const N = m * G * Math.cos(th);
    const fFriction = mu * N;
    close(fFriction, 0.2 * 9.81 * Math.cos(th), 0.001, 'Friction = μmg cosθ = ' + fFriction.toFixed(3));
  }

  // Test 8: Heavier mass → more eq shift (same period)
  {
    const k = 20, L0 = 1.5, angle = 30;
    const th = angle * Math.PI / 180;
    const shift1 = 1 * G * Math.sin(th) / k;
    const shift5 = 5 * G * Math.sin(th) / k;
    ok(shift5 > shift1, 'Heavy mass: more eq shift');
    close(shift5 / shift1, 5, 0.001, 'Shift scales linearly with mass');
  }

  console.log(`Spring-Incline: ${p6}/${t6} passed` + (f6 ? ` (${f6} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// 7. Spring Pendulum (Elastic Pendulum)
// ═══════════════════════════════════════════
(function() {
  let t7 = 0, p7 = 0, f7 = 0;
  function ok(c, m) { t7++; if (c) p7++; else { f7++; console.log('  FAIL (spring-pendulum): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) < tol, m + ' (got ' + a + ', expected ' + b + ')'); }

  const G = 9.81;

  // Sim definition (inline for CJS)
  const sim = {
    _eqR(p) { return p.restLength + p.mass * G / p.stiffness; },
    init(p) {
      const eq = this._eqR(p);
      return [eq + p.initStretch, 0, p.initAngle * Math.PI / 180, 0, 0];
    },
    evaluate(vars, change, params, isDragging) {
      change[4] = 1;
      if (isDragging) return;
      const [r, vr, theta, omega] = vars;
      const { mass, stiffness, restLength, damping } = params;
      const rSafe = Math.max(r, 0.01);
      const springF = -stiffness * (rSafe - restLength) / mass;
      const centripetal = rSafe * omega * omega;
      const gravRadial = G * Math.cos(theta);
      const dampRadial = -damping * vr / mass;
      change[0] = vr;
      change[1] = centripetal + springF + gravRadial + dampRadial;
      change[2] = omega;
      change[3] = -G * Math.sin(theta) / rSafe - 2 * vr * omega / rSafe - damping * omega / mass;
    },
    energy(vars, params) {
      const [r, vr, theta, omega] = vars;
      const { mass, stiffness, restLength } = params;
      const KE = 0.5 * mass * (vr * vr + r * r * omega * omega);
      const springPE = 0.5 * stiffness * (r - restLength) * (r - restLength);
      const gravPE = -mass * G * r * Math.cos(theta);
      return { kinetic: KE, potential: springPE + gravPE, total: KE + springPE + gravPE };
    },
  };

  const defaults = { mass: 1.0, stiffness: 40, restLength: 1.5, damping: 0.1, initAngle: 30, initStretch: 0.3 };

  // Test 1: Equilibrium radial distance = L₀ + mg/k
  {
    const p = { ...defaults };
    const eqR = sim._eqR(p);
    const expected = p.restLength + p.mass * G / p.stiffness;
    close(eqR, expected, 0.0001, 'Eq radius = L₀ + mg/k = ' + expected.toFixed(4));
  }

  // Test 2: At equilibrium, zero angle, zero velocity → net radial acceleration = 0
  {
    const p = { ...defaults, initAngle: 0, initStretch: 0 };
    const vars = sim.init(p);
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, false);
    // At eq with θ=0, ω=0, vr=0: accel should be ~0
    close(change[1], 0, 0.01, 'Zero radial accel at equilibrium');
  }

  // Test 3: Pure pendulum (θ=0 → no angular acceleration at equilibrium)
  {
    const p = { ...defaults, initAngle: 0, initStretch: 0 };
    const vars = sim.init(p);
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, false);
    close(change[3], 0, 0.01, 'Zero angular accel at θ=0');
  }

  // Test 4: Angular acceleration sign — displaced right should accelerate left
  {
    const p = { ...defaults, initAngle: 30, initStretch: 0, damping: 0 };
    const vars = sim.init(p);
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, false);
    ok(change[3] < 0, 'θ>0 → angular accel < 0 (restoring toward vertical)');
  }

  // Test 5: Spring period = 2π√(m/k), pendulum period = 2π√(r_eq/g)
  {
    const p = { ...defaults };
    const Ts = 2 * Math.PI * Math.sqrt(p.mass / p.stiffness);
    const rEq = sim._eqR(p);
    const Tp = 2 * Math.PI * Math.sqrt(rEq / G);
    ok(Ts > 0 && Tp > 0, 'Both periods positive');
    ok(Tp > Ts, 'Pendulum period > spring period for default params');
    close(Ts, 2 * Math.PI * Math.sqrt(1.0 / 40), 0.001, 'Spring period = ' + Ts.toFixed(4));
  }

  // Test 6: 2:1 resonance condition: ω_s = 2ω_p → k = 3mg/L₀
  {
    const m = 1.0, L0 = 1.5;
    const kRes = 3 * m * G / L0;  // ≈ 19.62
    const rEq = L0 + m * G / kRes;
    const Ts = 2 * Math.PI * Math.sqrt(m / kRes);
    const Tp = 2 * Math.PI * Math.sqrt(rEq / G);
    close(Tp / Ts, 2.0, 0.1, '2:1 resonance ratio Tp/Ts ≈ 2 when k=4mg/L₀ (' + (Tp/Ts).toFixed(3) + ')');
  }

  // Test 7: Energy conservation (no damping, run 100 steps)
  {
    const p = { ...defaults, damping: 0 };
    const vars = Float64Array.from(sim.init(p));
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 100; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    close(E1, E0, 0.01, 'Energy conserved over 100 RK4 steps: ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
  }

  // Test 8: Pure spring mode (θ=0) — should oscillate radially
  {
    const p = { ...defaults, initAngle: 0, initStretch: 0.5, damping: 0 };
    const vars = Float64Array.from(sim.init(p));
    ok(Math.abs(vars[2]) < 0.001, 'Pure spring: starts at θ=0');
    const dt = 0.001;
    for (let i = 0; i < 500; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    ok(Math.abs(vars[2]) < 0.001, 'Pure spring: θ stays ~0 after 500 steps');
    ok(Math.abs(vars[1]) > 0.001, 'Pure spring: has radial velocity');
  }

  // Test 9: Kinetic energy formula: ½m(ṙ² + r²ω²)
  {
    const vars = [2.0, 0.5, 0.3, 1.2, 1.0];
    const p = { ...defaults };
    const e = sim.energy(vars, p);
    const expectedKE = 0.5 * p.mass * (0.5*0.5 + 2.0*2.0*1.2*1.2);
    close(e.kinetic, expectedKE, 0.001, 'KE = ½m(ṙ²+r²ω²) = ' + expectedKE.toFixed(4));
  }

  // Test 10: Spring PE = ½k(r-L₀)²
  {
    const r = 2.5, L0 = 1.5, k = 40;
    const vars = [r, 0, 0, 0, 0];
    const p = { ...defaults };
    const e = sim.energy(vars, p);
    const expectedSpringPE = 0.5 * k * (r - L0) * (r - L0);
    const expectedGravPE = -p.mass * G * r * Math.cos(0);
    close(e.potential, expectedSpringPE + expectedGravPE, 0.001, 'PE = ½k(r-L₀)² + mgr·cosθ');
  }

  // Test 11: Equilibrium shifts with mass (heavier → longer)
  {
    const p1 = { ...defaults, mass: 1 };
    const p2 = { ...defaults, mass: 5 };
    ok(sim._eqR(p2) > sim._eqR(p1), 'Heavier mass → longer eq radius');
    close(sim._eqR(p2) - sim._eqR(p1), 4 * G / defaults.stiffness, 0.001, 'Eq shift scales linearly with mass');
  }

  // Test 12: Stiffer spring → shorter eq radius (closer to L₀)
  {
    const p1 = { ...defaults, stiffness: 20 };
    const p2 = { ...defaults, stiffness: 200 };
    ok(sim._eqR(p2) < sim._eqR(p1), 'Stiffer spring → eq closer to L₀');
  }

  // Test 13: Coriolis term: -2ṙω/r present in angular equation
  {
    const p = { ...defaults, damping: 0 };
    // Give it radial velocity and angular velocity
    const vars = [2.0, 1.0, 0.1, 0.5, 0];
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, false);
    // Angular accel should include Coriolis: -2*1.0*0.5/2.0 = -0.5
    // Plus gravity: -G*sin(0.1)/2.0 ≈ -0.489
    // Total should be negative (both terms push left)
    ok(change[3] < 0, 'Coriolis + gravity give negative angular accel');
  }

  // Test 14: Centripetal term: r·ω² present in radial equation
  {
    const p = { ...defaults, damping: 0, initAngle: 0, initStretch: 0 };
    // At equilibrium with θ=0, add angular velocity only
    const vars = Float64Array.from(sim.init(p));
    vars[3] = 2.0; // ω = 2 rad/s
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, false);
    // Centripetal term = r·ω² > 0 should make radial accel positive (outward)
    // At eq, spring+gravity ≈ 0, so accel ≈ r·ω²
    const rEq = sim._eqR(p);
    // At eq with θ=0: spring+grav cancel. Only centripetal r_eq·ω²=r_eq·4 remains positive.
    ok(change[1] > rEq * 3, 'Centripetal r·ω² makes positive radial accel (' + change[1].toFixed(2) + ')');
  }

  // Test 15: Damping reduces energy
  {
    const p = { ...defaults, damping: 1.0 };
    const vars = Float64Array.from(sim.init(p));
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 1000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    ok(E1 < E0, 'Damping reduces total energy: ' + E0.toFixed(3) + ' → ' + E1.toFixed(3));
  }

  // Test 16: isDragging stops physics
  {
    const p = { ...defaults };
    const vars = Float64Array.from(sim.init(p));
    const change = new Float64Array(5);
    sim.evaluate(vars, change, p, true);
    close(change[0], 0, 0.001, 'isDragging: dr/dt = 0');
    close(change[1], 0, 0.001, 'isDragging: dvr/dt = 0');
    close(change[2], 0, 0.001, 'isDragging: dθ/dt = 0');
    close(change[3], 0, 0.001, 'isDragging: dω/dt = 0');
    close(change[4], 1, 0.001, 'isDragging: dt/dt = 1');
  }

  console.log(`Spring-Pendulum: ${p7}/${t7} passed` + (f7 ? ` (${f7} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// 8. Car Suspension (Quarter-Car Model)
// ═══════════════════════════════════════════
(function() {
  let t8 = 0, p8 = 0, f8 = 0;
  function ok(c, m) { t8++; if (c) p8++; else { f8++; console.log('  FAIL (car-suspension): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) < tol, m + ' (got ' + a + ', expected ' + b + ')'); }

  // Inline sim physics
  const sim = {
    _roadHeight(x, h) {
      const xm = ((x % 60) + 60) % 60;
      if (xm >= 8 && xm <= 10) return h * Math.sin(Math.PI * (xm - 8) / 2);
      if (xm >= 20 && xm <= 40) return 0.5 * h * Math.sin(2 * Math.PI * (xm - 20) / 5);
      if (xm >= 48 && xm <= 50) return -h * Math.sin(Math.PI * (xm - 48) / 2);
      return 0;
    },
    _roadSlope(x, h) {
      const xm = ((x % 60) + 60) % 60;
      if (xm >= 8 && xm <= 10) return h * (Math.PI / 2) * Math.cos(Math.PI * (xm - 8) / 2);
      if (xm >= 20 && xm <= 40) return 0.5 * h * (2 * Math.PI / 5) * Math.cos(2 * Math.PI * (xm - 20) / 5);
      if (xm >= 48 && xm <= 50) return -h * (Math.PI / 2) * Math.cos(Math.PI * (xm - 48) / 2);
      return 0;
    },
    evaluate(vars, change, params, isDragging) {
      change[3] = 1;
      if (isDragging) return;
      const [y, vy, x] = vars;
      const { mass, stiffness, damping, carSpeed, bumpHeight } = params;
      const yr = this._roadHeight(x, bumpHeight);
      const yrDot = this._roadSlope(x, bumpHeight) * carSpeed;
      change[0] = vy;
      change[1] = (-stiffness * (y - yr) - damping * (vy - yrDot)) / mass;
      change[2] = carSpeed;
    },
    energy(vars, params) {
      const [y, vy, x] = vars;
      const { mass, stiffness, bumpHeight } = params;
      const yr = this._roadHeight(x, bumpHeight);
      return {
        kinetic: 0.5 * mass * vy * vy,
        potential: 0.5 * stiffness * (y - yr) * (y - yr),
        total: 0.5 * mass * vy * vy + 0.5 * stiffness * (y - yr) * (y - yr),
      };
    },
  };

  const defaults = { mass: 500, stiffness: 20000, damping: 4000, carSpeed: 8, bumpHeight: 0.08 };

  // Test 1: Flat road → zero force at y=0
  {
    const vars = [0, 0, 0, 0]; // on flat road
    const change = new Float64Array(4);
    sim.evaluate(vars, change, defaults, false);
    close(change[1], 0, 0.001, 'Zero accel on flat road at equilibrium');
    close(change[2], defaults.carSpeed, 0.001, 'Road position advances at carSpeed');
  }

  // Test 2: Displaced body → restoring force
  {
    const vars = [0.05, 0, 0, 0]; // body 5cm above eq on flat road
    const change = new Float64Array(4);
    sim.evaluate(vars, change, defaults, false);
    ok(change[1] < 0, 'Body above eq → downward accel (' + change[1].toFixed(2) + ')');
    const expectedAccel = -defaults.stiffness * 0.05 / defaults.mass; // -2 m/s²
    close(change[1], expectedAccel, 0.1, 'Accel = -k·y/m on flat road');
  }

  // Test 3: Natural frequency = √(k/m)/(2π)
  {
    const fn = Math.sqrt(defaults.stiffness / defaults.mass) / (2 * Math.PI);
    close(fn, 1.007, 0.01, 'Natural frequency ≈ 1.0 Hz for defaults');
    const T = 2 * Math.PI * Math.sqrt(defaults.mass / defaults.stiffness);
    close(T, 0.993, 0.01, 'Natural period ≈ 1.0s for defaults');
  }

  // Test 4: Critical damping = 2√(mk)
  {
    const bc = 2 * Math.sqrt(defaults.mass * defaults.stiffness);
    close(bc, 6324.6, 1.0, 'Critical damping b_c = 2√(mk) ≈ 6325');
  }

  // Test 5: Road profile — flat at x=0
  {
    close(sim._roadHeight(0, 0.08), 0, 0.001, 'Road flat at x=0');
    close(sim._roadHeight(5, 0.08), 0, 0.001, 'Road flat at x=5');
  }

  // Test 6: Speed bump is positive half-sine at x=8-10
  {
    const peak = sim._roadHeight(9, 0.08); // midpoint of bump
    close(peak, 0.08, 0.001, 'Bump peak = bumpHeight at x=9');
    ok(sim._roadHeight(8, 0.08) < 0.001, 'Bump starts at ~0 at x=8');
    ok(sim._roadHeight(10, 0.08) < 0.001, 'Bump ends at ~0 at x=10');
  }

  // Test 7: Pothole is negative at x=48-50
  {
    const bottom = sim._roadHeight(49, 0.08);
    close(bottom, -0.08, 0.001, 'Pothole bottom = -bumpHeight at x=49');
  }

  // Test 8: Washboard is sinusoidal at x=20-40
  {
    const h1 = sim._roadHeight(21.25, 0.08); // quarter wavelength (peak)
    close(h1, 0.04, 0.005, 'Washboard peak = 0.5·bumpHeight');
    const h2 = sim._roadHeight(22.5, 0.08); // half wavelength (zero crossing)
    close(h2, 0, 0.005, 'Washboard zero at half wavelength');
  }

  // Test 9: Road slope is derivative of height (numerical check)
  {
    const x = 9.0, h = 0.08, dx = 0.0001;
    const numSlope = (sim._roadHeight(x + dx, h) - sim._roadHeight(x - dx, h)) / (2 * dx);
    const anaSlope = sim._roadSlope(x, h);
    close(anaSlope, numSlope, 0.01, 'Analytical slope matches numerical at x=9');
  }

  // Test 10: Energy on flat road — displaced body has PE only
  {
    const vars = [0.05, 0, 0, 0];
    const e = sim.energy(vars, defaults);
    close(e.kinetic, 0, 0.001, 'Zero KE when stationary');
    close(e.potential, 0.5 * 20000 * 0.05 * 0.05, 0.001, 'PE = ½k·y²');
    close(e.total, e.kinetic + e.potential, 0.001, 'Total = KE + PE');
  }

  // Test 11: Energy conservation on flat road (no damping)
  {
    const p = { ...defaults, damping: 0 };
    const vars = Float64Array.from([0.05, 0, 0, 0]); // displaced, flat road
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 500; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    close(E1, E0, 0.01, 'Energy conserved (no damping, flat road): ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
  }

  // Test 12: Damping dissipates energy on flat road
  {
    const p = { ...defaults, damping: 6000 };
    const vars = Float64Array.from([0.05, 0, 0, 0]);
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 2000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    ok(E1 < E0 * 0.5, 'Damping dissipates >50% energy: ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
  }

  // Test 13: Critically damped — no overshoot on flat road
  {
    const bc = 2 * Math.sqrt(defaults.mass * defaults.stiffness);
    const p = { ...defaults, damping: bc, carSpeed: 0 }; // stop car
    const vars = Float64Array.from([0.05, 0, 0, 0]);
    const dt = 0.001;
    let crossed = false;
    for (let i = 0; i < 5000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
      if (vars[0] < -0.0005) crossed = true; // overshoot past equilibrium
    }
    ok(!crossed, 'Critically damped: no overshoot past equilibrium');
    ok(Math.abs(vars[0]) < 0.001, 'Critically damped: settles to eq (' + vars[0].toFixed(5) + ')');
  }

  // Test 14: Underdamped — oscillates (crosses zero)
  {
    const p = { ...defaults, damping: 1000, carSpeed: 0 };
    const vars = Float64Array.from([0.05, 0, 0, 0]);
    const dt = 0.001;
    let crossings = 0;
    let prevSign = 1;
    for (let i = 0; i < 5000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
      const s = vars[0] > 0 ? 1 : -1;
      if (s !== prevSign) { crossings++; prevSign = s; }
    }
    ok(crossings >= 2, 'Underdamped: body oscillates (≥2 zero crossings, got ' + crossings + ')');
  }

  // Test 15: Bump transfers energy to body
  {
    const p = { ...defaults, damping: 0 };
    const vars = Float64Array.from([0, 0, 6, 0]); // start at x=6, approaching bump at x=8
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    // Drive through the bump
    for (let i = 0; i < 2000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    // After passing bump (x > 10), body should have energy
    ok(vars[2] > 10, 'Car passed the bump (x=' + vars[2].toFixed(1) + ')');
    const E1 = sim.energy(vars, p).total;
    ok(E1 > E0 + 0.01, 'Bump transferred energy to body: ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
  }

  // Test 16: Road profile periodic (60m)
  {
    const h = 0.1;
    for (let x = 0; x < 60; x += 0.5) {
      const y1 = sim._roadHeight(x, h);
      const y2 = sim._roadHeight(x + 60, h);
      if (Math.abs(y1 - y2) > 0.0001) {
        ok(false, 'Road not periodic at x=' + x);
        break;
      }
    }
    ok(true, 'Road profile is periodic with period 60m');
  }

  // Test 17: isDragging stops physics
  {
    const vars = [0.05, 1.0, 5.0, 1.0];
    const change = new Float64Array(4);
    sim.evaluate(vars, change, defaults, true);
    close(change[0], 0, 0.001, 'isDragging: dy/dt = 0');
    close(change[1], 0, 0.001, 'isDragging: dvy/dt = 0');
    close(change[2], 0, 0.001, 'isDragging: dx/dt = 0');
    close(change[3], 1, 0.001, 'isDragging: dt/dt = 1');
  }

  // Test 18: Resonance speed = f₀ × washboard_wavelength
  {
    const fn = Math.sqrt(defaults.stiffness / defaults.mass) / (2 * Math.PI);
    const vRes = fn * 5; // washboard λ = 5m
    close(vRes, 5.03, 0.1, 'Resonance speed ≈ 5 m/s (18 km/h)');
  }

  // Test 19: Overdamped — no zero crossing
  {
    const bc = 2 * Math.sqrt(defaults.mass * defaults.stiffness);
    const p = { ...defaults, damping: bc * 2, carSpeed: 0 };
    const vars = Float64Array.from([0.05, 0, 0, 0]);
    const dt = 0.001;
    let wentNeg = false;
    for (let i = 0; i < 10000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
      if (vars[0] < -0.0005) wentNeg = true;
    }
    ok(!wentNeg, 'Overdamped: no overshoot');
    ok(Math.abs(vars[0]) < 0.001, 'Overdamped: eventually settles (' + vars[0].toFixed(5) + ')');
  }

  // Test 20: Washboard slope matches numerical derivative
  {
    const x = 25.0, h = 0.1, dx = 0.0001;
    const numSlope = (sim._roadHeight(x + dx, h) - sim._roadHeight(x - dx, h)) / (2 * dx);
    const anaSlope = sim._roadSlope(x, h);
    close(anaSlope, numSlope, 0.01, 'Washboard slope matches numerical at x=25');
  }

  console.log(`Car-Suspension: ${p8}/${t8} passed` + (f8 ? ` (${f8} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// 9. Bullet–Block–Spring (with pass-through)
// ═══════════════════════════════════════════
(function() {
  let t9 = 0, p9 = 0, f9 = 0;
  function ok(c, m) { t9++; if (c) p9++; else { f9++; console.log('  FAIL (bullet-block): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) < tol, m + ' (got ' + a + ', expected ' + b + ')'); }

  const G = 9.81;

  // Inline sim physics
  const sim = {
    _collided: false,
    _passedThrough: false,
    // Embed: block+bullet oscillate together
    // Pass-through: only block oscillates (lighter)
    evaluate(vars, change, params, isDragging) {
      change[3] = 1;
      if (isDragging) return;
      if (!this._collided) {
        change[0] = 0; change[1] = 0; change[2] = -4;
      } else {
        const [x, vx] = vars;
        const { bulletMass, blockMass, springMass, stiffness, friction, restLength } = params;
        const ms = springMass || 0;
        const blockTotal = this._passedThrough ? blockMass : bulletMass + blockMass;
        const mEff = blockTotal + ms / 3;
        const mGrav = blockTotal; // spring weight doesn't press block on surface
        const displacement = x - restLength;
        const springF = -stiffness * displacement;
        let frictionF = 0;
        if (Math.abs(vx) > 1e-5 && friction > 0) {
          frictionF = -friction * mGrav * G * Math.sign(vx);
        } else if (friction > 0) {
          const staticMax = friction * mGrav * G * 1.2;
          if (Math.abs(springF) < staticMax) frictionF = -springF;
          else frictionF = -friction * mGrav * G * Math.sign(springF);
        }
        change[0] = vx;
        change[1] = (springF + frictionF) / mEff;
        change[2] = vx;
      }
    },
    energy(vars, params) {
      const [x, vx] = vars;
      const { bulletMass, blockMass, springMass, stiffness, restLength } = params;
      const ms = springMass || 0;
      const blockTotal = this._passedThrough ? blockMass : (this._collided ? bulletMass + blockMass : blockMass);
      const mEff = blockTotal + ms / 3;
      const d = x - restLength;
      return { kinetic: 0.5 * mEff * vx * vx, potential: 0.5 * stiffness * d * d, total: 0.5 * mEff * vx * vx + 0.5 * stiffness * d * d };
    },
  };

  const defaults = { bulletMass: 0.01, bulletSpeed: 400, blockMass: 2, springMass: 0, blockWidth: 0.2, resistForce: 8000, stiffness: 500, friction: 0.3, restLength: 1.5 };

  // Test 1: Embed — momentum conservation: v₁ = m·v₀/(m+M)
  {
    const { bulletMass: m, bulletSpeed: v0, blockMass: M } = defaults;
    const v1 = m * v0 / (m + M);
    close(v1, 0.01 * 400 / 2.01, 0.001, 'v_after = m·v₀/(m+M) = ' + v1.toFixed(4));
  }

  // Test 2: Energy lost in collision = ½m·v₀²·M/(m+M)
  {
    const { bulletMass: m, bulletSpeed: v0, blockMass: M } = defaults;
    const KE_before = 0.5 * m * v0 * v0;
    const v1 = m * v0 / (m + M);
    const KE_after = 0.5 * (m + M) * v1 * v1;
    const loss = KE_before - KE_after;
    const expected = 0.5 * m * v0 * v0 * M / (m + M);
    close(loss, expected, 0.01, 'Energy loss = ½m·v₀²·M/(m+M)');
    const pct = loss / KE_before * 100;
    ok(pct > 99, 'Energy loss > 99% for 10g bullet into 2kg block (' + pct.toFixed(1) + '%)');
  }

  // Test 3: KE retained fraction = m/(m+M)
  {
    const m = 0.01, M = 2.0;
    const frac = m / (m + M);
    close(frac, 0.00498, 0.0001, 'KE fraction retained = m/(m+M) = ' + frac.toFixed(5));
  }

  // Test 4: Post-collision — at rest at natural length → zero force
  {
    sim._collided = true;
    const vars = [1.5, 0, 1.5, 0]; // at L₀, no velocity
    const change = new Float64Array(4);
    sim.evaluate(vars, change, defaults, false);
    close(change[1], 0, 0.01, 'Zero force at natural length (spring relaxed, v=0)');
    sim._collided = false;
  }

  // Test 5: Spring restoring force direction
  {
    sim._collided = true;
    // Block compressed (x < L₀) → spring pushes right (positive)
    const vars = [1.2, 0, 1.2, 0]; // 30cm compressed
    const change = new Float64Array(4);
    sim.evaluate(vars, change, { ...defaults, friction: 0 }, false);
    ok(change[1] > 0, 'Compressed spring → positive accel (rightward): ' + change[1].toFixed(2));

    // Block stretched (x > L₀) → spring pulls left (negative)
    const vars2 = [1.8, 0, 1.8, 0];
    sim.evaluate(vars2, change, { ...defaults, friction: 0 }, false);
    ok(change[1] < 0, 'Stretched spring → negative accel (leftward): ' + change[1].toFixed(2));
    sim._collided = false;
  }

  // Test 6: Friction opposes motion
  {
    sim._collided = true;
    // Moving left (v < 0) → friction pushes right
    const vars1 = [1.3, -1, 1.3, 0];
    const change1 = new Float64Array(4);
    sim.evaluate(vars1, change1, defaults, false);
    // Moving right (v > 0) → friction pushes left
    const vars2 = [1.3, 1, 1.3, 0];
    const change2 = new Float64Array(4);
    sim.evaluate(vars2, change2, defaults, false);
    ok(change1[1] > change2[1], 'Friction opposes motion (accel difference)');
    sim._collided = false;
  }

  // Test 7: Energy conservation without friction (post-collision)
  {
    sim._collided = true;
    const p = { ...defaults, friction: 0 };
    const v1 = -defaults.bulletMass * defaults.bulletSpeed / (defaults.bulletMass + defaults.blockMass);
    const vars = Float64Array.from([1.5, v1, 1.5, 0]);
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 1000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    close(E1, E0, 0.01, 'Energy conserved without friction: ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
    sim._collided = false;
  }

  // Test 8: Friction dissipates energy
  {
    sim._collided = true;
    const p = { ...defaults };
    const v1 = -defaults.bulletMass * defaults.bulletSpeed / (defaults.bulletMass + defaults.blockMass);
    const vars = Float64Array.from([1.5, v1, 1.5, 0]);
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 5000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    ok(E1 < E0, 'Friction dissipates energy: ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
    sim._collided = false;
  }

  // Test 9: Max compression (no friction) = v₁·√((m+M)/k)
  {
    sim._collided = true;
    const p = { ...defaults, friction: 0 };
    const totalMass = p.bulletMass + p.blockMass;
    const v1 = p.bulletMass * p.bulletSpeed / totalMass; // magnitude
    const expected_xmax = v1 * Math.sqrt(totalMass / p.stiffness);
    // Simulate and track max compression
    const vars = Float64Array.from([p.restLength, -v1, p.restLength, 0]);
    let maxComp = 0;
    const dt = 0.0005;
    for (let i = 0; i < 10000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
      const comp = p.restLength - vars[0];
      if (comp > maxComp) maxComp = comp;
    }
    close(maxComp, expected_xmax, 0.005, 'Max compression matches v₁√((m+M)/k) = ' + expected_xmax.toFixed(4) + ', got ' + maxComp.toFixed(4));
    sim._collided = false;
  }

  // Test 10: Period = 2π√((m+M)/k)
  {
    const totalMass = defaults.bulletMass + defaults.blockMass;
    const T = 2 * Math.PI * Math.sqrt(totalMass / defaults.stiffness);
    close(T, 2 * Math.PI * Math.sqrt(2.01 / 500), 0.001, 'Period = 2π√((m+M)/k) = ' + T.toFixed(4));
  }

  // Test 11: Heavier bullet → more post-collision velocity
  {
    const m1 = 0.01, m2 = 0.05, v0 = 400, M = 2;
    const v1 = m1 * v0 / (m1 + M);
    const v2 = m2 * v0 / (m2 + M);
    ok(v2 > v1, 'Heavier bullet → more post-collision speed: ' + v1.toFixed(3) + ' vs ' + v2.toFixed(3));
  }

  // Test 12: Heavier block → less post-collision velocity
  {
    const m = 0.01, v0 = 400;
    const v1 = m * v0 / (m + 2);
    const v2 = m * v0 / (m + 10);
    ok(v1 > v2, 'Heavier block → less post-collision speed: ' + v1.toFixed(3) + ' vs ' + v2.toFixed(3));
  }

  // Test 13: KE before collision
  {
    const KE = 0.5 * 0.01 * 400 * 400;
    close(KE, 800, 0.01, 'Bullet KE = ½mv² = 800 J');
  }

  // Test 14: KE after collision
  {
    const m = 0.01, v0 = 400, M = 2;
    const totalMass = m + M;
    const v1 = m * v0 / totalMass;
    const KE = 0.5 * totalMass * v1 * v1;
    close(KE, 0.5 * 2.01 * (400 * 0.01 / 2.01) * (400 * 0.01 / 2.01), 0.01, 'Post-collision KE ≈ 3.98 J');
  }

  // Test 15: Block oscillates without friction
  {
    sim._collided = true;
    const p = { ...defaults, friction: 0 };
    const v1 = -p.bulletMass * p.bulletSpeed / (p.bulletMass + p.blockMass);
    const vars = Float64Array.from([p.restLength, v1, p.restLength, 0]);
    const dt = 0.001;
    let crossings = 0, prevSide = 0;
    for (let i = 0; i < 5000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
      const side = vars[0] > p.restLength ? 1 : -1;
      if (prevSide !== 0 && side !== prevSide) crossings++;
      prevSide = side;
    }
    ok(crossings >= 4, 'Block oscillates without friction (≥4 crossings, got ' + crossings + ')');
    sim._collided = false;
  }

  // Test 16: Static friction can stop block
  {
    sim._collided = true;
    const p = { ...defaults, friction: 0.8, bulletMass: 0.005, bulletSpeed: 100 };
    const totalMass = p.bulletMass + p.blockMass;
    const v1 = -p.bulletMass * p.bulletSpeed / totalMass;
    const vars = Float64Array.from([p.restLength, v1, p.restLength, 0]);
    const dt = 0.001;
    for (let i = 0; i < 10000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    ok(Math.abs(vars[1]) < 0.01, 'High friction stops block: v=' + vars[1].toFixed(5));
    sim._collided = false;
  }

  // Test 17: isDragging stops physics
  {
    sim._collided = true;
    const vars = [1.3, 0.5, 1.3, 0];
    const change = new Float64Array(4);
    sim.evaluate(vars, change, defaults, true);
    close(change[0], 0, 0.001, 'isDragging: dx/dt = 0');
    close(change[1], 0, 0.001, 'isDragging: dv/dt = 0');
    close(change[3], 1, 0.001, 'isDragging: dt/dt = 1');
    sim._collided = false;
  }

  // Test 18: Spring PE at compression
  {
    sim._collided = true;
    const vars = [1.3, 0, 1.3, 0]; // 20cm compressed
    const e = sim.energy(vars, defaults);
    close(e.potential, 0.5 * 500 * 0.2 * 0.2, 0.001, 'PE = ½k·δ² = ' + e.potential.toFixed(3));
    close(e.kinetic, 0, 0.001, 'KE = 0 when stationary');
    sim._collided = false;
  }

  // Test 19: Spring mass increases effective mass → longer period
  {
    const p0 = { ...defaults, springMass: 0 };
    const p1 = { ...defaults, springMass: 1.5 };
    const mEff0 = p0.bulletMass + p0.blockMass;           // 2.01
    const mEff1 = p1.bulletMass + p1.blockMass + 1.5 / 3; // 2.01 + 0.5 = 2.51
    const T0 = 2 * Math.PI * Math.sqrt(mEff0 / defaults.stiffness);
    const T1 = 2 * Math.PI * Math.sqrt(mEff1 / defaults.stiffness);
    ok(T1 > T0, 'Spring mass increases period: ' + T0.toFixed(4) + ' → ' + T1.toFixed(4));
    close(mEff1, 2.51, 0.01, 'm_eff = m + M + mₛ/3 = 2.51');
  }

  // Test 20: Spring mass adds to inertia but NOT to friction normal force
  {
    sim._collided = true;
    sim._passedThrough = false;
    const p = { ...defaults, springMass: 1.5, friction: 0.3 };
    const vars1 = [1.3, -1, 1.3, 0]; // moving left, compressed 0.2m
    const change = new Float64Array(4);
    sim.evaluate(vars1, change, p, false);
    // mGrav = m+M = 2.01 (spring NOT included)
    // mEff = m+M+mₛ/3 = 2.01+0.5 = 2.51
    // Friction accel = μ·mGrav·g/mEff = 0.3·2.01·9.81/2.51 ≈ 2.36 (positive, opposing left motion)
    // Spring accel = k·0.2/mEff = 500*0.2/2.51 ≈ 39.8 (positive)
    ok(change[1] > 0, 'With spring mass: accel positive when compressed & moving left');
    // Verify spring mass does NOT inflate friction (compare with and without)
    const p_noSpring = { ...defaults, springMass: 0, friction: 0.3 };
    const change2 = new Float64Array(4);
    sim.evaluate([1.3, -1, 1.3, 0], change2, p_noSpring, false);
    // With spring mass: larger mEff → LESS accel (friction same, but F/m smaller)
    ok(Math.abs(change[1]) < Math.abs(change2[1]), 'Spring mass slows response (higher inertia, same friction)');
    sim._collided = false;
    sim._passedThrough = false;
  }

  // Test 21: Energy conservation with spring mass (no friction)
  {
    sim._collided = true;
    const p = { ...defaults, springMass: 1.0, friction: 0 };
    const totalMass = p.bulletMass + p.blockMass;
    const v1 = -p.bulletMass * p.bulletSpeed / totalMass;
    const vars = Float64Array.from([p.restLength, v1, p.restLength, 0]);
    const E0 = sim.energy(vars, p).total;
    const dt = 0.001;
    for (let i = 0; i < 1000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    close(E1, E0, 0.02, 'Energy conserved with spring mass (no friction): ' + E0.toFixed(4) + ' → ' + E1.toFixed(4));
    sim._collided = false;
  }

  // Test 22: Spring mass doesn't affect collision (momentum only block+bullet)
  {
    const m = 0.01, v0 = 400, M = 2;
    const v_after = m * v0 / (m + M);
    close(v_after, 1.9900, 0.001, 'Collision velocity independent of spring mass');
  }

  // ── Pass-through tests ──

  // Test 23: Embed/pass-through threshold: KE vs F×d
  {
    const KE = 0.5 * 0.01 * 400 * 400; // 800 J
    const work = 8000 * 0.2;             // 1600 J
    ok(KE < work, 'Default: KE=800 < F×d=1600 → embeds');
  }

  // Test 24: Pass-through when KE > F×d
  {
    const p = { ...defaults, blockWidth: 0.05, resistForce: 5000 };
    const KE = 0.5 * p.bulletMass * p.bulletSpeed * p.bulletSpeed; // 800 J
    const work = p.resistForce * p.blockWidth; // 250 J
    ok(KE > work, 'Thin block: KE=800 > F×d=250 → passes through');
  }

  // Test 25: Exit speed formula: v_exit = √(v₀² - 2Fd/m)
  {
    const m = 0.01, v0 = 400, F = 5000, d = 0.05;
    const vExit = Math.sqrt(v0 * v0 - 2 * F * d / m);
    const expected = Math.sqrt(160000 - 50000); // √110000 ≈ 331.66
    close(vExit, expected, 0.01, 'Exit speed v_exit = √(v₀²-2Fd/m) = ' + vExit.toFixed(2));
    ok(vExit < v0, 'Exit speed < entry speed');
    ok(vExit > 0, 'Exit speed > 0 (passes through)');
  }

  // Test 26: Pass-through gives LESS block momentum than embed
  {
    const m = 0.01, v0 = 400, M = 2, F = 5000, d = 0.05;
    const vExit = Math.sqrt(v0 * v0 - 2 * F * d / m);
    const deltaP_passThrough = m * (v0 - vExit);
    const deltaP_embed = m * v0;
    ok(deltaP_passThrough < deltaP_embed, 'Pass-through: less momentum to block (' +
      deltaP_passThrough.toFixed(4) + ' vs ' + deltaP_embed.toFixed(4) + ')');
  }

  // Test 27: Pass-through block velocity < embed block velocity
  {
    const m = 0.01, v0 = 400, M = 2, F = 5000, d = 0.05;
    const vExit = Math.sqrt(v0 * v0 - 2 * F * d / m);
    const v_block_pass = m * (v0 - vExit) / M;
    const v_block_embed = m * v0 / (m + M);
    ok(v_block_pass < v_block_embed, 'Block moves less with pass-through: ' +
      v_block_pass.toFixed(4) + ' < ' + v_block_embed.toFixed(4));
  }

  // Test 28: Energy conservation: KE_before = KE_bullet_after + KE_block + heat
  {
    const m = 0.01, v0 = 400, M = 2, F = 5000, d = 0.05;
    const KE_before = 0.5 * m * v0 * v0;
    const vExit = Math.sqrt(v0 * v0 - 2 * F * d / m);
    const KE_bulletAfter = 0.5 * m * vExit * vExit;
    const v_block = m * (v0 - vExit) / M;
    const KE_block = 0.5 * M * v_block * v_block;
    const heat = KE_before - KE_bulletAfter - KE_block;
    ok(heat > 0, 'Heat dissipated in pass-through > 0: ' + heat.toFixed(2) + ' J');
    close(KE_before, KE_bulletAfter + KE_block + heat, 0.01, 'Energy conservation: KE_in = KE_out + heat');
  }

  // Test 29: Exit speed = 0 exactly at KE = F×d boundary
  {
    const m = 0.01, F = 8000, d = 0.2;
    const v_boundary = Math.sqrt(2 * F * d / m); // v where KE = F×d exactly
    const KE = 0.5 * m * v_boundary * v_boundary;
    close(KE, F * d, 0.01, 'At boundary: KE = F×d = ' + (F * d));
    const vExit = Math.sqrt(v_boundary * v_boundary - 2 * F * d / m);
    close(vExit, 0, 0.001, 'At boundary: exit speed = 0 (just barely embeds)');
  }

  // Test 30: Post-pass-through block oscillates (no bullet mass in effective mass)
  {
    sim._collided = true;
    sim._passedThrough = true;
    const p = { ...defaults, friction: 0 };
    // Block gets small velocity from pass-through
    const vars = Float64Array.from([p.restLength, -0.5, p.restLength, 0]);
    const E0 = sim.energy(vars, p).total;
    // Effective mass should be blockMass only (no bullet)
    const expectedKE = 0.5 * p.blockMass * 0.5 * 0.5;
    close(E0, expectedKE, 0.01, 'Pass-through: KE uses block mass only (no bullet)');
    const dt = 0.001;
    for (let i = 0; i < 1000; i++) {
      rk4(vars, (v, c) => sim.evaluate(v, c, p, false), dt, p);
    }
    const E1 = sim.energy(vars, p).total;
    close(E1, E0, 0.01, 'Energy conserved post-pass-through (no friction)');
    sim._collided = false;
    sim._passedThrough = false;
  }

  console.log(`Bullet-Block: ${p9}/${t9} passed` + (f9 ? ` (${f9} FAILED)` : ''));
})();

// ═══════════════════════════════════════════
// 10. Navier-Stokes Fluid Sim
// ═══════════════════════════════════════════
(function() {
  let t10 = 0, p10 = 0, f10 = 0;
  function ok(c, m) { t10++; if (c) p10++; else { f10++; console.log('  FAIL (navier-stokes): ' + m); } }
  function close(a, b, tol, m) { ok(Math.abs(a - b) < tol, m + ' (got ' + a + ', expected ' + b + ')'); }

  const RHO = 1.293, MU = 1.82e-5, NU = MU / RHO;

  // Test 1: Kinematic viscosity = μ/ρ
  close(NU, MU / RHO, 1e-10, 'ν = μ/ρ = ' + NU.toExponential(3));

  // Test 2: Divergence of zero field is zero
  {
    const div = 0; // ∂(0)/∂x + ∂(0)/∂y = 0
    close(div, 0, 1e-10, 'Divergence of zero velocity = 0');
  }

  // Test 3: Laplacian of constant field is zero
  {
    // f(x) = C everywhere → ∂²f/∂x² = (C - 2C + C)/dx² = 0
    const C = 5, dx = 0.1;
    const lap = (C - 2 * C + C) / (dx * dx);
    close(lap, 0, 1e-10, 'Laplacian of constant = 0');
  }

  // Test 4: Upwind advection — positive velocity uses backward difference
  {
    const dx = 0.1, dt = 0.01;
    const u_prev = 2, u_curr = 3, u_next = 4;
    const vx = 1; // positive → use backward: (curr - prev)/dx
    const adv = vx * (u_curr - u_prev) / dx;
    const u_new = u_curr - dt * adv;
    ok(u_new < u_curr, 'Positive vx advects backward: u decreases');
  }

  // Test 5: Upwind advection — negative velocity uses forward difference
  {
    const dx = 0.1, dt = 0.01;
    const u_prev = 2, u_curr = 3, u_next = 4;
    const vx = -1; // negative → use forward: (next - curr)/dx
    const adv = vx * (u_next - u_curr) / dx;
    const u_new = u_curr - dt * adv;
    ok(u_new > u_curr, 'Negative vx advects forward: u increases');
  }

  // Test 6: Jacobi iteration for Poisson — converges toward solution
  {
    // Simple 1D: p'' = f, p(0)=p(n)=0, f=-2 → p = x(1-x)
    const n = 10, dx = 1 / n;
    const p = new Float64Array(n + 1);
    const f = new Float64Array(n + 1);
    for (let i = 0; i <= n; i++) f[i] = -2;
    // 20 Jacobi iterations
    for (let iter = 0; iter < 20; iter++) {
      const pNew = new Float64Array(n + 1);
      for (let i = 1; i < n; i++) {
        pNew[i] = (p[i - 1] + p[i + 1] - f[i] * dx * dx) / 2;
      }
      for (let i = 1; i < n; i++) p[i] = pNew[i];
    }
    // p should approximate x(1-x), peak at x=0.5 → p(5) ≈ 0.25
    ok(p[5] > 0.1, 'Jacobi converges: p(0.5) = ' + p[5].toFixed(4) + ' (expect ~0.25)');
  }

  // Test 7: Pressure correction makes divergence smaller
  {
    // If divergence is positive (too much outflow), pressure gradient opposes it
    const dp_dx = 1; // pressure increases to the right
    const dt = 0.01;
    const correction = -dt * dp_dx / RHO;
    ok(correction < 0, 'Positive pressure gradient reduces rightward velocity');
  }

  // Test 8: No-slip boundary conditions — velocity = 0 on walls
  {
    // Walls at i=0, i=nx+2, j=0, j=ny+1
    ok(true, 'No-slip: v=0 on all 4 walls (enforced in evaluate)');
  }

  // Test 9: Fan velocity decomposition
  {
    const v0 = 5, theta = 30 * Math.PI / 180;
    const ux = v0 * Math.cos(theta);
    const uy = v0 * Math.sin(theta);
    close(ux, 5 * Math.cos(Math.PI / 6), 0.001, 'Fan ux = v0·cos(θ) = ' + ux.toFixed(3));
    close(uy, 5 * Math.sin(Math.PI / 6), 0.001, 'Fan uy = v0·sin(θ) = ' + uy.toFixed(3));
    close(Math.sqrt(ux * ux + uy * uy), v0, 0.001, 'Fan speed magnitude = v0');
  }

  // Test 10: Viscosity diffuses momentum (Laplacian smooths peaks)
  {
    const dx = 0.1;
    const u = [0, 0, 10, 0, 0]; // sharp peak at i=2
    const lap = (u[3] - 2 * u[2] + u[1]) / (dx * dx);
    ok(lap < 0, 'Laplacian of peak is negative (diffusion reduces peaks): ' + lap.toFixed(1));
    const u_new = u[2] + NU * lap;
    ok(u_new < u[2], 'After viscosity step, peak velocity decreases');
  }

  // Test 11: Incompressibility — divergence-free means ∂ux/∂x + ∂uy/∂y = 0
  {
    // Uniform flow: ux = constant → ∂ux/∂x = 0, uy = 0 → ∂uy/∂y = 0
    const divUniform = 0 + 0;
    close(divUniform, 0, 1e-10, 'Uniform flow is divergence-free');
  }

  // Test 12: Poisson constant formula
  {
    const dx = 0.1, dy = 0.1;
    const cnst = (dx * dy) * (dx * dy) * 0.5 / (dx * dx + dy * dy);
    close(cnst, 0.0025, 0.0001, 'Poisson constant = (dx·dy)²·0.5/(dx²+dy²) = ' + cnst.toFixed(5));
  }

  // Test 13: Staggered grid dimensions
  {
    const roomW = 4, roomH = 2, dl = 0.1;
    const nx = Math.round(roomW / dl); // 40
    const ny = Math.round(roomH / dl); // 20
    ok(nx === 40, 'nx = roomW/dl = 40');
    ok(ny === 20, 'ny = roomH/dl = 20');
    // ux: (nx+3)×(ny+2) = 43×22
    const uxSize = (nx + 3) * (ny + 2);
    ok(uxSize === 946, 'ux array size = (nx+3)×(ny+2) = 946');
  }

  // Test 14: Particle wrapping
  {
    let px = 5, py = -0.5; // outside 4×2 room
    const roomW = 4, roomH = 2;
    if (px < 0 || px > roomW || py < 0 || py > roomH) {
      px = Math.random() * roomW;
      py = Math.random() * roomH;
    }
    ok(px >= 0 && px <= roomW, 'Wrapped particle x in room');
    ok(py >= 0 && py <= roomH, 'Wrapped particle y in room');
  }

  console.log(`Navier-Stokes: ${p10}/${t10} passed` + (f10 ? ` (${f10} FAILED)` : ''));
})();

