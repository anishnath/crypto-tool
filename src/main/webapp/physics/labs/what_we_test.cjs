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
    startAngle: { value: Math.PI / 3 },
  },
  init(p) { return [p.startAngle, 0, 0]; },
  evaluate(vars, change, params, isDragging) {
    change[2] = 1;
    if (isDragging) return;
    const [angle, angVel] = vars;
    const { gravity, length, mass, damping } = params;
    change[0] = angVel;
    change[1] = -(gravity / length) * Math.sin(angle) - (damping / (mass * length * length)) * angVel;
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
