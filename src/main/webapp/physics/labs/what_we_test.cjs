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
