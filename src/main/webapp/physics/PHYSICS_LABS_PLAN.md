# Physics Labs — Build Our Own Engine

## Philosophy
We build our own lightweight physics simulation engine in vanilla JS, **inspired by** myPhysicsLab's architecture (Apache 2.0 reference). We don't copy bundles or depend on their build system. We extract the **math and patterns**, write our own code, our own CSS, our own UX.

## Reference Project
- Source: `/Users/anish/junk/myphysicslab`
- GitHub: https://github.com/myphysicslab/myphysicslab
- License: Apache 2.0 (permissive — allows studying and reimplementation)
- What we take: **architectural patterns, physics equations, ODE solver approach**
- What we DON'T take: their JS bundles, build system, CSS, HTML templates

---

## Core Engine Architecture

### The Key Insight from myPhysicsLab

The entire engine is 3 decoupled layers:

```
Physics (evaluate)  →  Solver (RK4 step)  →  Renderer (canvas draw)
   "what are the          "advance time          "draw the
    forces?"               by dt"                 state"
```

Each simulation only defines ONE function: `evaluate(state) → derivatives`. Everything else is reusable infrastructure.

### Our Engine: `physics/labs/js/engine.js`

Single file, ~300 lines. No dependencies. No build step.

```javascript
// ═══════════════════════════════════════════
// 1. STATE — just a flat number array
// ═══════════════════════════════════════════
// state = [var0, var1, var2, ..., time]
// For pendulum: [angle, angularVelocity, time]
// For spring:   [x, velocity, time]
// For double pendulum: [θ1, ω1, θ2, ω2, time]

// ═══════════════════════════════════════════
// 2. SOLVER — Runge-Kutta 4 (the gold standard)
// ═══════════════════════════════════════════
// Input:  current state[], evaluate function, dt
// Output: next state[]
//
// Reference: myphysicslab/src/lab/model/RungeKutta.ts
// RK4 does 4 evaluations per step for 4th-order accuracy
// Pre-allocates temp arrays (k1,k2,k3,k4) — zero GC pressure

function rk4Step(vars, evaluate, dt) {
  const n = vars.length;
  const k1 = new Float64Array(n);
  const k2 = new Float64Array(n);
  const k3 = new Float64Array(n);
  const k4 = new Float64Array(n);
  const tmp = new Float64Array(n);

  evaluate(vars, k1);                                    // k1 = f(t, y)
  for (let i=0;i<n;i++) tmp[i] = vars[i] + 0.5*dt*k1[i];
  evaluate(tmp, k2);                                     // k2 = f(t+dt/2, y+dt/2*k1)
  for (let i=0;i<n;i++) tmp[i] = vars[i] + 0.5*dt*k2[i];
  evaluate(tmp, k3);                                     // k3 = f(t+dt/2, y+dt/2*k2)
  for (let i=0;i<n;i++) tmp[i] = vars[i] + dt*k3[i];
  evaluate(tmp, k4);                                     // k4 = f(t+dt, y+dt*k3)

  for (let i=0;i<n;i++)
    vars[i] += (dt/6) * (k1[i] + 2*k2[i] + 2*k3[i] + k4[i]);
}

// ═══════════════════════════════════════════
// 3. RENDERER — thin canvas wrapper
// ═══════════════════════════════════════════
// Handles: coordinate transform (world→screen), draw primitives
// Each sim provides a render(ctx, state, world) callback
//
// Reference: myphysicslab/src/lab/view/LabCanvas.ts, SimView.ts
// We simplify: no DisplayList, no CoordMap class — just functions

// ═══════════════════════════════════════════
// 4. SIM RUNNER — animation loop
// ═══════════════════════════════════════════
// requestAnimationFrame loop
// Steps physics N times per frame (fixed dt for stability)
// Calls render after stepping
// Handles play/pause/reset
```

### What Each Simulation Defines (the only custom code per sim)

```javascript
const PendulumSim = {
  name: 'Simple Pendulum',

  // State variable layout
  vars: { ANGLE: 0, ANGULAR_VEL: 1, TIME: 2 },

  // Tunable parameters
  params: {
    gravity:   { value: 9.8,  min: 0, max: 20,  step: 0.1, label: 'Gravity (m/s²)' },
    length:    { value: 1.0,  min: 0.1, max: 5,  step: 0.1, label: 'Length (m)' },
    mass:      { value: 1.0,  min: 0.1, max: 10, step: 0.1, label: 'Mass (kg)' },
    damping:   { value: 0.1,  min: 0, max: 2,    step: 0.01, label: 'Damping' },
    startAngle:{ value: Math.PI/4, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start Angle (rad)' },
  },

  // Initial state
  init(p) {
    return [p.startAngle, 0, 0];  // [angle, angVel, time]
  },

  // THE PHYSICS — this is the only "hard" part per sim
  // Reference: myphysicslab/src/sims/pendulum/PendulumSim.ts evaluate()
  evaluate(vars, change, params) {
    const [angle, angVel, time] = vars;
    const { gravity, length, mass, damping } = params;

    change[0] = angVel;                                        // dθ/dt = ω
    change[1] = -(gravity/length)*Math.sin(angle)              // α = -(g/L)sin(θ)
                - (damping/(mass*length*length))*angVel;       //     - (b/mL²)ω
    change[2] = 1;                                             // dt/dt = 1
  },

  // RENDERING — draw the pendulum
  render(ctx, vars, params, w, h) {
    const [angle] = vars;
    const L = params.length;
    const cx = w/2, cy = h*0.2;                  // pivot point
    const scale = Math.min(w, h) * 0.3 / L;
    const bx = cx + L*scale*Math.sin(angle);     // bob position
    const by = cy + L*scale*Math.cos(angle);

    // Rod
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(bx, by);
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.stroke();

    // Pivot
    ctx.beginPath();
    ctx.arc(cx, cy, 4, 0, Math.PI*2);
    ctx.fillStyle = '#64748b';
    ctx.fill();

    // Bob
    ctx.beginPath();
    ctx.arc(bx, by, 12*Math.sqrt(params.mass), 0, Math.PI*2);
    ctx.fillStyle = '#10b981';
    ctx.fill();
  },

  // Presets — curated starting points
  presets: [
    { name: 'Default',     params: {} },
    { name: 'Moon Gravity', params: { gravity: 1.6 } },
    { name: 'Zero Damping', params: { damping: 0 } },
    { name: 'Heavy Bob',    params: { mass: 5, damping: 0.3 } },
    { name: 'Long String',  params: { length: 3 } },
  ],

  // Energy calculations (for graphs)
  energy(vars, params) {
    const [angle, angVel] = vars;
    const { gravity, length, mass } = params;
    const KE = 0.5 * mass * (length*angVel)**2;
    const PE = mass * gravity * length * (1 - Math.cos(angle));
    return { kinetic: KE, potential: PE, total: KE + PE };
  }
};
```

**That's it.** ~60 lines defines a complete interactive simulation. The engine handles everything else.

---

## File Structure

```
physics/labs/
├── index.jsp                      # Labs hub page
├── pendulum.jsp                   # Each sim gets a JSP
├── double-pendulum.jsp
├── spring.jsp
├── billiards.jsp
├── newtons-cradle.jsp
├── roller-coaster.jsp
├── collide-blocks.jsp
├── string-wave.jsp
├── js/
│   ├── engine.js                  # OUR engine (~300 lines)
│   │                              #   - rk4Step()
│   │                              #   - SimRunner class (RAF loop, play/pause/reset)
│   │                              #   - CanvasRenderer (coord transform, draw helpers)
│   │                              #   - ControlBuilder (auto-generate sliders from params)
│   │                              #   - EnergyGraph (optional time-series graph)
│   │
│   ├── sims/                      # One file per simulation (~50-100 lines each)
│   │   ├── pendulum.js            #   - evaluate(), render(), params, presets
│   │   ├── double-pendulum.js
│   │   ├── spring.js
│   │   ├── spring-2d.js
│   │   ├── billiards.js
│   │   ├── newtons-cradle.js
│   │   ├── roller-coaster.js
│   │   ├── collide-blocks.js
│   │   ├── molecule.js
│   │   └── string-wave.js
│   │
│   └── collision.js               # Collision detection (for billiards, blocks)
│                                  #   Reference: myphysicslab/src/lab/engine2D/
│
└── css/
    └── labs.css                   # OUR CSS — dark/light, responsive, controls
```

---

## Modular Engine Architecture

### File Split (not one monolith — each module is independently useful)

```
physics/labs/js/
├── core/
│   ├── solver.js          # RK4 + Euler solvers (~40 lines)
│   ├── runner.js          # SimRunner: RAF loop, play/pause/reset/step (~80 lines)
│   ├── state.js           # State helpers: clone, lerp, energy tracking (~30 lines)
│   └── interact.js        # Mouse/touch drag interaction system (~100 lines)
│
├── canvas/
│   ├── sim-canvas.js      # Simulation canvas: world coords, draw primitives (~80 lines)
│   ├── graph-canvas.js    # XY graph: phase space, auto-scale, var selection (~100 lines)
│   ├── time-graph.js      # Time-series: rolling window, multi-line (~80 lines)
│   └── energy-bar.js      # Energy bar chart: KE/PE/Total stacked (~50 lines)
│
├── ui/
│   ├── controls.js        # Auto-generate sliders/checkboxes from sim.params (~60 lines)
│   ├── transport.js       # Play/Pause/Reset/Step + speed control (~40 lines)
│   ├── presets.js         # Preset buttons from sim.presets (~25 lines)
│   ├── tabs.js            # Tab switcher: Sim | Graph | Time | Energy (~50 lines)
│   └── var-picker.js      # Dropdown to pick which vars to graph (~30 lines)
│
├── lab.js                 # Orchestrator: wires modules together (~60 lines)
│                          # The ONLY file a JSP needs to import
│
├── sims/                  # One per simulation
│   ├── pendulum.js
│   ├── double-pendulum.js
│   └── ...
│
└── collision.js           # Shared collision math (for billiards, blocks) (~80 lines)
```

**Total shared engine: ~700 lines across 12 small files.**
Each sim: ~50-100 lines.

---

## Canvas Layout System

### Key Design: Sim + Graph Side-by-Side (not replacing)

Like the myPhysicsLab reference, selecting a graph tab does **NOT** hide the simulation. Instead, the sim canvas stays visible and a graph canvas appears **next to it**. This lets you see the simulation and its data simultaneously.

### Tab Behavior

| Tab | Layout | What Renders |
|-----|--------|-------------|
| **Sim** | Sim canvas full width | Sim only |
| **Phase** | Sim (left) + Phase graph (right) | Both |
| **Time** | Sim (left) + Time graph (right) | Both |
| **Energy** | Sim (left) + Energy chart (right) | Both |

### How It Works (CSS + JS)

**HTML structure in JSP:**
```html
<div class="lab-canvas-area" id="canvasArea">
  <!-- Sim canvas — always visible -->
  <div class="lab-canvas-wrap" id="simPanel">
    <canvas id="simCanvas"></canvas>
  </div>
  <!-- Graph panel — shown alongside sim when graph tab active -->
  <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
    <canvas id="graphCanvas"></canvas>          <!-- phase -->
    <canvas id="timeCanvas" style="display:none;"></canvas>   <!-- time -->
    <canvas id="energyCanvas" style="display:none;"></canvas> <!-- energy -->
  </div>
</div>
```

**CSS:**
- `.lab-canvas-area` = CSS grid, default `grid-template-columns: 1fr`
- `.lab-canvas-area.split` = `grid-template-columns: 1fr 1fr` (50/50 side-by-side)
- `.lab-graph-panel` hidden by default, shown when `.split` active
- On mobile (<768px): split stacks vertically (sim on top, graph below)

**JS (tabs.js):**
- Sim tab → remove `.split` class, hide graph panel
- Any graph tab → add `.split` class, show graph panel, toggle which canvas inside is visible
- Sim canvas **always renders** regardless of active tab

**JS (lab.js) render callback:**
- `sim.render(simCvs, state, params)` — called every frame, always
- `graphCvs.render()` — only when `activeTab === 'phase'`
- `timeCvs.render()` — only when `activeTab === 'time'`
- `energyCvs.render()` — only when `activeTab === 'energy'`

### When Creating a New Sim JSP

Always use this canvas structure. Pass `canvasArea` element to `createLab()`:

```javascript
const lab = createLab(MySim, {
  simCanvas:    document.getElementById('simCanvas'),
  graphCanvas:  document.getElementById('graphCanvas'),
  timeCanvas:   document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
  canvasArea:   document.getElementById('canvasArea'),  // ← required for split layout
  controls:     document.getElementById('controls'),
  transport:    document.getElementById('transport'),
  presets:      document.getElementById('presets'),
  tabs:         document.getElementById('labTabs'),
  varPicker:    document.getElementById('varPicker'),
});
```

### Overlays on Sim Canvas (always visible)

These draw directly onto the sim canvas in screen pixels:
- **Clock** — top-right corner, `simCvs.clockOverlay(time, isDark)`, background pill for readability in both themes
- **Energy bar** — bottom edge, `simCvs.energyOverlay(ke, pe, total, max, isDark)`, KE=red + PE=blue stacked bar with total=green outline

Both overlays adapt their colors/backgrounds based on `isDark` flag (derived from `bgMode`).

### Tab Configuration Per Sim

```javascript
const MySim = {
  views: ['sim', 'phase', 'time', 'energy'],  // which tabs to show
  graphDefaults: {
    phase: { x: 'angle', y: 'angularVel' },   // default XY for phase graph
    time:  ['angle', 'angularVel'],            // default lines for time graph
  },
};
```

Sims can opt out of views they don't need:

| Sim Type | Typical Views |
|----------|--------------|
| Pendulum, Spring | sim, phase, time, energy |
| Double Pendulum | sim, phase, time (chaotic — energy conserved but complex) |
| Billiards | sim, energy (no meaningful phase graph) |
| String Wave (PDE) | sim, time (wave amplitude over time) |
| Colliding Blocks | sim, time, energy (momentum + energy graphs) |

---

## Module Details

### core/solver.js (~40 lines)

```javascript
export function rk4(vars, evaluate, dt, params) { ... }
export function euler(vars, evaluate, dt, params) { ... }
```
- `rk4`: 4th-order Runge-Kutta — accurate, used by default
- `euler`: 1st-order — fast, for quick previews or simple sims
- Both mutate `vars` in-place, pre-allocate Float64Array buffers once

### core/runner.js (~80 lines)

```javascript
export class SimRunner {
  constructor(sim, opts)
  play() / pause() / toggle() / reset() / step()
  setSpeed(multiplier)    // 0.25x to 4x
  onTick(callback)        // called each physics step (for graph data collection)
  onRender(callback)      // called each animation frame
}
```
- Fixed physics dt (1/120s default), accumulator catches up to wall clock
- Decoupled from rendering — runner just advances state, notifies listeners
- Listeners (canvases, graphs) render themselves when notified

### core/interact.js (~100 lines) — THE GRAB-DRAG-RELEASE SYSTEM

This is what makes the sims feel alive. User grabs a mass, drags it, releases — physics takes over.

**How myPhysicsLab does it (reference):**
- SimController captures mouse/touch events on canvas
- MouseTracker hit-tests all objects → finds nearest drag point
- Sim's `startDrag()` / `mouseDrag()` / `finishDrag()` update state vars directly
- ODE solver keeps running but `evaluate()` skips forces while `isDragging = true`
- On release: `isDragging = false`, physics resumes from where user left the object

**Our simplified version:**

```javascript
export class Interact {
  constructor(simCanvas, sim, runner)
  // Listens: mousedown/mousemove/mouseup + touchstart/touchmove/touchend on canvas
}
```

**Flow:**

```
mousedown on canvas
  → convert pixel → world coords (simCanvas.toWorld)
  → call sim.hitTest(worldX, worldY, state, params)
     returns: { objectId, offset } or null
  → if hit: set runner.isDragging = true
            store objectId + offset
            canvas cursor = 'grabbing'

mousemove (while dragging)
  → convert pixel → world
  → call sim.onDrag(objectId, worldX, worldY, offset, state, params)
     sim updates state vars directly (position = mouse - offset, velocity = 0)
  → runner still ticks (time advances) but evaluate() skips forces

mouseup
  → call sim.onRelease(objectId, state, params)
  → set runner.isDragging = false
  → canvas cursor = 'grab' or default
  → physics resumes naturally from current state
```

**What each sim defines (3 optional functions):**

```javascript
const SpringSim = {
  // ...

  // Hit test: is (x,y) near a draggable object?
  hitTest(wx, wy, state, params) {
    const blockX = state[0];  // block position
    const blockY = 0;
    const dist = Math.hypot(wx - blockX, wy - blockY);
    if (dist < 0.3) {  // 0.3 world units = hit radius
      return { id: 'block', offsetX: wx - blockX, offsetY: wy - blockY };
    }
    return null;  // nothing hit
  },

  // Drag: update state from mouse position
  onDrag(id, wx, wy, offset, state, params) {
    if (id === 'block') {
      state[0] = wx - offset.offsetX;  // position = mouse - click offset
      state[1] = 0;                     // zero velocity while dragging
    }
  },

  // Release: optional cleanup (usually nothing needed)
  onRelease(id, state, params) {
    // physics resumes automatically
  },
};
```

**Pendulum example (constrained to arc):**

```javascript
hitTest(wx, wy, state, params) {
  const angle = state[0];
  const L = params.length;
  const bobX = L * Math.sin(angle);
  const bobY = -L * Math.cos(angle);
  if (Math.hypot(wx - bobX, wy - bobY) < 0.3) {
    return { id: 'bob' };
  }
  return null;
},

onDrag(id, wx, wy, offset, state, params) {
  // Constrain to circular arc — convert cartesian to angle
  state[0] = Math.atan2(wx, -wy);   // angle from mouse position
  state[1] = 0;                       // zero angular velocity
},
```

**Key design decisions:**
- Sims that DON'T define `hitTest` → no drag interaction (graphs, waves, etc.)
- `isDragging` flag checked inside `evaluate()` → forces skipped, time still advances
- Touch events mirror mouse events (touchstart→mousedown, etc.)
- Cursor changes: default → `grab` on hover near object → `grabbing` while dragging
- Hover detection: optional `sim.hitTest` called on mousemove (no button) to change cursor

**Runner integration:**

```javascript
// Inside runner's tick loop:
if (this.isDragging) {
  // Still advance time but evaluate() will see isDragging and skip forces
  // This keeps graphs updating and time progressing
}
```

**Inside evaluate():**

```javascript
evaluate(vars, change, params) {
  change[TIME] = 1;
  if (this._isDragging) return;  // ← skip all force calculations
  change[X] = vars[V];
  change[V] = (-k * vars[X] - b * vars[V]) / mass;
}
```

But wait — the sim doesn't own `_isDragging`. The runner does. So we pass it:

```javascript
evaluate(vars, change, params, isDragging) {
  change[TIME_IDX] = 1;
  if (isDragging) return;
  // ... physics ...
}
```

Or simpler: `onDrag` already zeros velocity and sets position. The evaluate just computes derivatives from current state. If velocity is 0 and position is being overwritten each frame by `onDrag`, the solver's output gets overwritten anyway. So we don't even need the flag for simple sims — just let `onDrag` win.

**Simplest approach (no flag needed for most sims):**

```
Each frame:
  1. solver.step(state, evaluate, dt)  → state updated by physics
  2. if dragging: sim.onDrag(...)      → state overwritten by mouse
  3. render(state)                     → draws whatever state says
```

Physics runs, drag overwrites. Release → step 2 stops → physics output persists. Clean.

---

### canvas/sim-canvas.js (~80 lines)

```javascript
export class SimCanvas {
  constructor(canvasEl, worldRect)   // worldRect = {xMin,xMax,yMin,yMax}
  resize()                           // handles DPI + responsive
  clear(bgColor)
  toScreen(wx, wy)                   // world → pixel
  toWorld(px, py)                    // pixel → world (for mouse interaction)
  // Draw primitives
  circle(x, y, r, fill, stroke)
  line(x1,y1, x2,y2, color, width)
  spring(x1,y1, x2,y2, coils, amp, color)  // zigzag spring visual
  rod(x1,y1, x2,y2, color, width)
  arc(cx,cy, r, startAngle, endAngle, color)
  trail(points, color, maxLen)       // fading motion trail
  text(x, y, str, color, size)
  grid(spacing, color, alpha)        // background reference grid
}
```
- ResizeObserver for responsive sizing
- `devicePixelRatio` for crisp rendering
- World-to-screen transform baked into every draw call

### canvas/graph-canvas.js (~100 lines)

```javascript
export class GraphCanvas {
  constructor(canvasEl, opts)
  setVars(xVar, yVar)           // which state vars to plot
  push(state)                   // collect data point from current state
  clear()                       // reset data
  render()                      // draw axes + data line
  autoScale()                   // fit view to data bounds
}
```
- XY phase-space graph (e.g., angle vs angular velocity)
- Auto-scale with padding
- Axis labels from sim's var names
- Grid lines + tick marks
- Data stored in circular buffer (last N points)

### canvas/time-graph.js (~80 lines)

```javascript
export class TimeGraph {
  constructor(canvasEl, opts)
  addLine(varName, color)       // register a variable to track
  push(time, state)             // collect data
  clear()
  render()
  setWindow(seconds)            // rolling window width (default 10s)
}
```
- Time on X axis, selected vars on Y axis
- Multiple colored lines (e.g., angle=blue, velocity=red)
- Rolling window — old data scrolls off left edge
- Auto-scale Y axis

### canvas/energy-bar.js (~50 lines)

```javascript
export class EnergyBar {
  constructor(canvasEl)
  update(ke, pe, total)         // push latest energy values
  render()
}
```
- Stacked horizontal bars: KE (red), PE (blue), Total (green)
- Or stacked area chart over time
- Only shown if sim provides `energy()` function

### ui/tabs.js (~50 lines)

```javascript
export class TabSwitcher {
  constructor(containerEl, tabs)   // tabs = ['sim','phase','time','energy']
  onSwitch(callback)               // notify when tab changes
  setActive(tabName)
}
```
- Generates tab buttons from the sim's `views` array
- Shows/hides canvases by toggling CSS class
- Remembers last active tab in sessionStorage
- Shows var-picker dropdown only on graph/time tabs

### Two Types of Controls

**Type 1: Sim-specific params** — different per simulation, auto-generated from `sim.params`
```
Spring: mass, damping, spring stiffness, spring length, fixed point
Pendulum: mass, length, gravity, damping, drive amplitude
Billiards: elasticity, friction, ball count
```

**Type 2: Engine-level settings** — same for ALL sims, provided by the engine
```
Show Energy (checkbox)     → toggles energy bar overlay on canvas
Show Clock (checkbox)      → toggles time display on canvas
Pan-Zoom (toggle)          → switches mouse from drag-object to pan/zoom canvas
Time Step (slider)         → solver dt: 0.001 to 0.05
Time Rate (slider)         → playback speed: 0.25x to 4x
Solver (dropdown)          → RK4 / Euler / Midpoint
Background (dropdown)      → white / dark / grid / none
```

Both types render as a unified control panel but they're built by different modules.

---

### ui/controls.js (~70 lines) — Sim-Specific Params

```javascript
export function buildSimControls(sim, containerEl, onChange)
```
- Reads `sim.params` object
- For each param: renders `<label>`, `<input type="range">`, `<span>` (live value + unit)
- Number params → slider
- Boolean params → checkbox (e.g., `showTrail: { value: true, type: 'bool', label: 'Show Trail' }`)
- Choice params → dropdown (e.g., `shape: { value: 'circle', type: 'choice', options: ['circle','square'], label: 'Shape' }`)
- Calls `onChange(paramName, value)` on any input change
- Change instantly feeds into next `evaluate()` + `render()` — canvas updates live

### ui/engine-controls.js (~60 lines) — Shared Engine Settings

```javascript
export function buildEngineControls(containerEl, runner, simCanvas)
```
Auto-generates these controls (same for every sim):

| Control | Type | What It Does |
|---------|------|-------------|
| Show Energy | checkbox | Toggles energy bar overlay on sim canvas |
| Show Clock | checkbox | Draws time readout on canvas corner |
| Pan-Zoom | toggle btn | Switches mouse mode: drag-object ↔ pan/zoom canvas |
| Time Step | slider 0.001–0.05 | Physics solver `dt` — smaller = more accurate, slower |
| Time Rate | slider 0.25x–4x | Playback speed multiplier |
| Solver | dropdown | RK4 / Euler / Midpoint |
| Background | dropdown | White / Dark / Grid lines / Transparent |
| Share | button | Encodes current params + state to URL hash, copies link |

**Share URL encoding:**
```
/physics/labs/pendulum.jsp#g=9.8&L=2&d=0&a=1.2&v=0
```
On page load: if URL has hash → parse params → apply to sim → auto-play. This makes sims shareable — a teacher can set up a scenario and send the link to students.

### ui/transport.js (~40 lines) — Playback Controls

```javascript
export function buildTransport(containerEl, runner)
```
- Play/Pause toggle button (▶ / ⏸)
- Reset button (↺)
- Step — single frame advance (⏭)
- Keyboard: Space = play/pause, R = reset, → = step, +/- = speed

### ui/presets.js (~25 lines) — Quick Scenarios

```javascript
export function buildPresets(sim, containerEl, onSelect)
```
- Renders pill buttons from `sim.presets` array
- Click → applies param overrides → resets state → auto-plays
- Active preset highlighted
- "Custom" auto-selected when user manually changes any slider

### ui/var-picker.js (~30 lines) — Graph Axis Selection

```javascript
export function buildVarPicker(sim, containerEl, onPick)
```
- X axis dropdown: picks from sim's `vars` keys
- Y axis dropdown: same
- Only visible on Phase / Time graph tabs
- Defaults from `sim.graphDefaults`

---

### Control Panel Layout

```
┌─────────────────────────┐
│ ▶  ⏸  ↺  ⏭  [1x ▾]     │  ← transport.js
├─────────────────────────┤
│ ─── Parameters ───      │  ← controls.js (sim-specific)
│ Mass      [━━●━━━] 1.0  │
│ Damping   [●━━━━━] 0.1  │
│ Stiffness [━━━●━━] 3.0  │
│ Length    [━━●━━━] 1.0  │
│ Fixed Pt  [━━━●━━] 0.0  │
├─────────────────────────┤
│ ─── Presets ───         │  ← presets.js
│ [Default] [Stiff] [Soft]│
│ [Heavy] [No Damp]       │
├─────────────────────────┤
│ ─── Settings ───        │  ← engine-controls.js (shared)
│ ☑ Show Energy           │
│ ☑ Show Clock            │
│ ☐ Pan-Zoom Mode         │
│ Solver    [RK4 ▾]       │
│ Time Step [━━━●━] 0.02  │
│ Background [Grid ▾]     │
│ [📋 Share Link]          │
├─────────────────────────┤
│ ─── Graph Vars ───      │  ← var-picker.js (graph tabs only)
│ X: [position ▾]         │
│ Y: [velocity ▾]         │
└─────────────────────────┘
```

**Sections collapse/expand** — Parameters always open, Settings collapsed by default (power users open it), Graph Vars only shown on graph tabs.

---

## lab.js — The Orchestrator (~60 lines)

The **only import a JSP page needs**. Wires everything together.

```javascript
import { SimRunner } from './core/runner.js';
import { SimCanvas } from './canvas/sim-canvas.js';
import { GraphCanvas } from './canvas/graph-canvas.js';
import { TimeGraph } from './canvas/time-graph.js';
import { EnergyBar } from './canvas/energy-bar.js';
import { TabSwitcher } from './ui/tabs.js';
import { buildControls } from './ui/controls.js';
import { buildTransport } from './ui/transport.js';
import { buildPresets } from './ui/presets.js';
import { buildVarPicker } from './ui/var-picker.js';

export function createLab(sim, elements) {
  // elements = { simCanvas, graphCanvas, timeCanvas, energyCanvas,
  //              controls, transport, presets, tabs, varPicker }
  //
  // 1. Create runner from sim
  // 2. Create only the canvases the sim declares in views[]
  // 3. Build controls from sim.params
  // 4. Build transport (play/pause/reset)
  // 5. Build presets from sim.presets
  // 6. Build tabs from sim.views
  // 7. Wire: runner.onTick → push data to graphs
  //          runner.onRender → render active canvas
  //          tab switch → show/hide canvases, show/hide var-picker
  //          control change → runner.setParam()
  //          preset click → runner.loadPreset()
  //
  // Returns: { runner, destroy() }
}
```

### JSP Usage (dead simple)

```html
<script type="module">
  import { createLab } from './js/lab.js';
  import { PendulumSim } from './js/sims/pendulum.js';

  createLab(PendulumSim, {
    simCanvas:    document.getElementById('simCanvas'),
    graphCanvas:  document.getElementById('graphCanvas'),
    timeCanvas:   document.getElementById('timeCanvas'),
    energyCanvas: document.getElementById('energyCanvas'),
    controls:     document.getElementById('controls'),
    transport:    document.getElementById('transport'),
    presets:      document.getElementById('presets'),
    tabs:         document.getElementById('tabs'),
    varPicker:    document.getElementById('varPicker'),
  });
</script>
```

---

## UX & Visual Design

### Design Language: "Observatory"

Dark-first aesthetic inspired by scientific instruments — oscilloscopes, lab equipment control panels. Not a toy, not a textbook — a **real instrument** you happen to use in a browser.

**Color Palette:**
```
--lab-bg-deep:      #070B12        base background
--lab-bg-surface:   #0E1420        canvas background
--lab-bg-panel:     #131B2A        sidebar/control panels
--lab-border:       rgba(139, 92, 246, 0.12)   subtle violet borders
--lab-accent:       #8B5CF6        primary accent (violet — physics = purple)
--lab-accent-bright:#A78BFA        hover/active states
--lab-accent2:      #06B6D4        secondary (cyan — for energy, graphs)
--lab-sim-glow:     0 0 30px rgba(139, 92, 246, 0.15)   canvas border glow
--lab-text:         #E2E8F0        primary text
--lab-text-muted:   #64748B        labels, secondary
--lab-slider-track: #1E293B        slider background
--lab-slider-fill:  linear-gradient(90deg, #8B5CF6, #06B6D4)  active fill
```

Light mode: invert to white surfaces, keep accent colors.

**Typography:**
```
Headings:  'Sora', sans-serif       (same as molecule-draw — cohesive)
Body:      'DM Sans', sans-serif
Data/Code: 'Fira Code', monospace   (param values, equations, graph labels)
```

**Fonts loaded once** — shared with molecule-draw. Same Google Fonts import.

---

### The Canvas — Hero of the Page

The simulation canvas is the **centerpiece**. Everything else serves it.

**Canvas rendering style:**
- Dark background (#0E1420) — objects pop against it
- Objects have subtle glow/shadow (e.g., pendulum bob has a soft violet halo)
- Springs rendered as coiled zigzag with thickness proportional to tension
- Rods rendered with slight 3D effect (gradient fill)
- Motion trails: fading ghost positions (last 20 frames, decreasing opacity)
- Grid: subtle dotted lines, only when "Grid" background is selected
- Time readout: top-right corner, monospace, semi-transparent
- Energy bar: bottom overlay, thin stacked bar (KE=red, PE=blue, Total=green)
- Grab cursor: hand icon when hovering near draggable objects
- Objects slightly scale up on hover (1.05x) as affordance for "you can grab this"

**Canvas border:**
- 1px border with `--lab-border` color
- On hover/interaction: border glows violet (`--lab-sim-glow`)
- Rounded corners (10px)

**Canvas aspect ratios** (sim can override in `worldRect`):
- Default: 4:3 (landscape)
- Pendulums: 3:4 (portrait — vertical swing)
- Billiards: 16:9 (wide table)
- Spring: 5:2 (wide horizontal)

---

### Tab Bar Design

Not generic browser tabs — styled as an instrument mode selector.

```
  ┌──────┐┌───────┐┌──────┐┌────────┐
  │● Sim ││ Phase ││ Time ││ Energy │
  └──────┘└───────┘└──────┘└────────┘
```

- Pill-shaped buttons, horizontal row above canvas
- Active tab: solid violet background, white text
- Inactive: transparent, muted text, violet on hover
- Small colored dot on each: Sim=violet, Phase=cyan, Time=green, Energy=amber
- Smooth transition: canvas crossfades between views (opacity 0→1, 150ms)
- Tab count adapts: if sim only declares `['sim','time']`, only 2 tabs render

---

### Sidebar (Control Panel)

**Width:** 280px fixed on desktop. Full-width stacked on mobile.

**Visual design:**
- Glass panel: `backdrop-filter: blur(12px)`, semi-transparent dark background
- Subtle left border glow when sim is running
- Sections separated by thin lines with section labels (uppercase, tiny, muted)

**Slider design (custom — not browser default):**
```
 Gravity                   9.81 m/s²
 [━━━━━━━━━━━━━●━━━━━━━]
      gradient fill ↑     ↑ thumb (circle, violet, glow on drag)
```
- Track: dark (#1E293B), rounded
- Fill: gradient from violet to cyan (left to right)
- Thumb: 14px circle, violet, white border, box-shadow glow on hover/drag
- Value display: right-aligned, monospace font, with unit
- Label: left-aligned, regular weight

**Checkbox design:**
```
 ☑ Show Energy     ☐ Pan-Zoom
```
- Custom styled: rounded square, violet fill when checked, animated checkmark

**Transport buttons:**
```
 [ ▶ ]  [ ⏸ ]  [ ↺ ]  [ ⏭ ]     1.0x
```
- Rounded rect buttons, icon-only
- Play: filled violet when playing, outlined when paused
- Speed: small dropdown or segmented control (0.25x | 0.5x | 1x | 2x | 4x)
- Keyboard hints shown as tiny `kbd` badges on hover: `Space`, `R`, `→`

**Preset buttons:**
```
 ─── Try These ───
 [Default] [Moon Gravity] [Zero Damping]
 [Stiff Spring] [Heavy Mass]
```
- Pill-shaped, outlined, compact
- Active preset: solid violet fill
- "Custom" auto-appears when user manually tweaks a slider
- Click: smooth param interpolation (200ms lerp for visual smoothness)

---

### Graph Canvases

**Phase Graph (XY):**
- Dark background, thin grid lines (dotted, very subtle)
- Data line: cyan, 2px, with glow
- Axis labels: monospace, positioned outside plot area
- Auto-scale with 10% padding
- Crosshair cursor on hover, shows coordinates in tooltip

**Time Graph (rolling):**
- Multiple colored lines (each variable gets a color from a palette)
- Time scrolls left to right, old data exits left edge
- Y-axis auto-scales
- Legend: small colored dots + var names below graph
- Thin vertical "now" line at right edge

**Energy Bar:**
- Thin horizontal stacked bar at bottom of sim canvas (overlay, not separate tab)
- KE = warm red, PE = cool blue, Total = green outline
- Labels only shown on hover
- Animates smoothly as values change

---

### Desktop Layout

```
┌──────────────────────────────────────────────────────────────────┐
│  Nav Header (from project)                                        │
├──────────────────────────────────────────────────────────────────┤
│  [Hero Ad — 970x90]                                               │
│  Home / Physics / Labs / Simple Pendulum                          │
│                                                                    │
│  ┌─ Canvas Area (flex: 1) ───────────────────┐ ┌─ Sidebar 280px ┐│
│  │                                           │ │                 ││
│  │  [● Sim] [Phase] [Time] [Energy]          │ │ [▶][⏸][↺][⏭]   ││
│  │  ┌─────────────────────────────────────┐  │ │ Speed: [1x ▾]  ││
│  │  │                                     │  │ │                 ││
│  │  │                                     │  │ │ ── Parameters ──││
│  │  │        SIMULATION CANVAS            │  │ │ Mass     ●━ 1.0 ││
│  │  │        (or graph, based on tab)     │  │ │ Damping  ●━ 0.1 ││
│  │  │                                     │  │ │ Stiffness━● 3.0 ││
│  │  │        grab objects with mouse      │  │ │ Length   ━● 1.0 ││
│  │  │        drag to interact             │  │ │                 ││
│  │  │                                     │  │ │ ── Try These ── ││
│  │  │  ┌─ energy bar overlay ──────────┐  │  │ │ [Default]       ││
│  │  │  │ KE ████░░ PE ░░░████ Total ━━ │  │  │ │ [Stiff] [Soft]  ││
│  │  │  └───────────────────────────────┘  │  │ │ [Heavy]         ││
│  │  │                           12.4s  ⏱  │  │ │                 ││
│  │  └─────────────────────────────────────┘  │ │ ── Settings ─── ││
│  │                                           │ │ ☑ Show Energy   ││
│  └───────────────────────────────────────────┘ │ ☑ Show Clock    ││
│                                                 │ Solver [RK4 ▾]  ││
│  ┌─ How It Works ─────────────────────────────┐ │ [📋 Share Link] ││
│  │ The simple harmonic oscillator...           │ │                 ││
│  │ F = -kx - bv                                │ │ ── Graph Vars ─││
│  │ The equation of motion is...                │ │ X: [pos ▾]     ││
│  └─────────────────────────────────────────────┘ │ Y: [vel ▾]     ││
│                                                 └─────────────────┘│
│  Also try → Pendulum · Double Spring · Molecule                    │
│  [Below-content Ad — 728x90]                                       │
├──────────────────────────────────────────────────────────────────┤
│  [Sticky Footer Ad]                                                │
└──────────────────────────────────────────────────────────────────┘
```

**Key desktop details:**
- Canvas area takes all remaining width (flex: 1)
- Sidebar fixed 280px, scrolls independently if controls overflow
- Canvas maintains aspect ratio within its container
- Energy bar overlays bottom of sim canvas (semi-transparent)
- Clock overlays top-right corner of sim canvas
- "How It Works" section below canvas, full width

---

### Mobile Layout (<768px)

```
┌─────────────────────────┐
│ Nav                      │
│ [Hero Ad — 320x50]       │
│ Home / Physics / Labs /  │
│ Simple Spring             │
│                          │
│ [●Sim][Phase][Time][Ener]│  ← horizontal scroll, pills
│ ┌─────────────────────┐  │
│ │                     │  │
│ │  CANVAS (full-w)    │  │  ← 4:3 aspect, touch-drag works
│ │  grab & drag mass   │  │
│ │                     │  │
│ │  ▸ energy bar ━━━━  │  │
│ └─────────────────────┘  │
│                          │
│ [▶] [⏸] [↺] [⏭] [1x▾]  │  ← transport row, sticky
│                          │
│ ▸ Parameters             │  ← collapsible, open by default
│   Mass     [━━━●━━] 1.0 │
│   Damping  [━●━━━━] 0.1 │
│   Stiffness[━━━●━━] 3.0 │
│                          │
│ ▸ Try These              │  ← collapsible, open
│   [Default][Stiff][Soft] │
│   [Heavy] [No Damp]      │
│                          │
│ ▸ Settings               │  ← collapsible, closed
│   ☑ Energy  ☑ Clock      │
│   Solver [RK4 ▾]         │
│   [📋 Share]              │
│                          │
│ ▸ How It Works           │  ← collapsible
│   F = -kx explains...    │
│                          │
│ Also try → Pendulum ...  │
│ [Ad — 320x100]           │
│ [Sticky Footer]          │
└─────────────────────────┘
```

**Key mobile details:**
- Canvas full width, touch drag for interaction
- Transport bar sticky (stays visible while scrolling controls)
- All sections below canvas are collapsible `<details>` elements
- Parameters open by default, Settings closed by default
- Tab pills scroll horizontally if they overflow
- Presets wrap into 2-row grid

---

### Micro-Interactions & Polish

**On sim load:**
- Canvas fades in (opacity 0→1, 300ms)
- Controls slide in from right (translateX 20px→0, staggered 50ms each)
- Preset buttons pop in (scale 0.9→1, staggered)

**On param change:**
- Slider thumb pulses (scale 1→1.2→1, 150ms)
- Value display flashes accent color briefly
- Canvas: if showing a static frame (paused), re-renders immediately

**On preset click:**
- Active preset glows
- Params animate to new values (slider thumbs slide smoothly, 200ms)
- Canvas resets with a brief flash (white overlay 0→0.1→0 opacity, 100ms)

**On drag interaction:**
- Object scales up slightly when grabbed (1.0→1.08)
- Subtle "pickup" shadow appears
- Motion trail clears on grab, starts fresh on release
- Satisfying: dragging a pendulum to the top and releasing → watching it swing

**On tab switch:**
- Active canvas fades in, inactive fades out (crossfade, 150ms)
- Graph data starts collecting immediately (even if not visible)
- Switching back to Sim tab: no jank, state preserved

**Canvas hover:**
- When mouse is near a draggable object: cursor changes to `grab`
- Object gets a subtle highlight ring (2px accent color, pulsing)
- Tooltip: "Drag to interact" (shown once, then stored in sessionStorage)

**Share link:**
- Click → URL encoded with all current params → copied to clipboard
- Toast notification: "Link copied — share this simulation setup"
- Opening shared URL: params auto-apply, sim auto-plays

---

### Accessibility

- All sliders have `aria-label`, `aria-valuemin`, `aria-valuemax`, `aria-valuenow`
- Transport buttons have `aria-label` ("Play simulation", "Pause", "Reset")
- Tab role="tablist", each tab role="tab", canvas panels role="tabpanel"
- Keyboard: Tab through controls, Space to play/pause, arrow keys to adjust focused slider
- Reduced motion: `prefers-reduced-motion` → disable motion trails, skip entry animations
- Canvas has `aria-label="Physics simulation: {sim.name}. Use mouse to drag objects."`

---

### Dark / Light Mode

Both themes follow the same layout. CSS variables switch:

| Token | Dark | Light |
|-------|------|-------|
| bg-deep | #070B12 | #F0F4F8 |
| bg-surface | #0E1420 | #FFFFFF |
| bg-panel | #131B2A | #F8FAFC |
| border | violet 12% | violet 15% |
| text | #E2E8F0 | #1E293B |
| canvas bg | #0E1420 | #FFFFFF |
| grid lines | rgba(255,255,255,0.04) | rgba(0,0,0,0.06) |
| object colors | bright (glow on dark) | saturated (crisp on white) |

Toggle in header (same pattern as molecule-draw). Persisted to localStorage.

---

## Sim Definition Contract (Updated)

```javascript
const MySim = {
  // Identity
  name: 'Simple Pendulum',
  slug: 'pendulum',
  category: 'Mechanics',

  // State layout — index-based for RK4 performance
  vars: {
    angle:      { index: 0, label: 'Angle (rad)',    symbol: 'θ' },
    angularVel: { index: 1, label: 'Angular Vel',    symbol: 'ω' },
    time:       { index: 2, label: 'Time (s)',        symbol: 't' },
  },
  varCount: 3,

  // Tunable parameters — auto-generates sliders
  params: {
    gravity:    { value: 9.8, min: 0, max: 20,   step: 0.1, label: 'Gravity', unit: 'm/s²' },
    length:     { value: 1.0, min: 0.1, max: 5,  step: 0.1, label: 'Length',  unit: 'm' },
    mass:       { value: 1.0, min: 0.1, max: 10, step: 0.1, label: 'Mass',    unit: 'kg' },
    damping:    { value: 0.1, min: 0, max: 2,    step: 0.01,label: 'Damping'  },
  },

  // Which canvas views this sim supports
  views: ['sim', 'phase', 'time', 'energy'],

  // Default graph axis mapping
  graphDefaults: {
    phase: { x: 'angle', y: 'angularVel' },
    time:  ['angle', 'angularVel'],
  },

  // World coordinate rect for sim canvas
  worldRect: { xMin: -2.5, xMax: 2.5, yMin: -2.5, yMax: 0.5 },

  // Presets
  presets: [
    { name: 'Default',      params: {} },
    { name: 'Moon Gravity', params: { gravity: 1.6 } },
    { name: 'Zero Damping', params: { damping: 0 } },
    { name: 'Long Pendulum',params: { length: 3 } },
  ],

  // Required functions
  init(p)                       { return [Math.PI/4, 0, 0]; },
  evaluate(vars, change, p)     { /* physics ODEs */ },
  render(canvas, vars, p)       { /* draw to SimCanvas */ },

  // Optional functions
  energy(vars, p)               { return { kinetic, potential, total }; },

  // Drag interaction (optional — omit for non-interactive sims like waves)
  hitTest(wx, wy, vars, p)      { /* return {id, offsetX, offsetY} or null */ },
  onDrag(id, wx, wy, off, vars, p) { /* update vars from mouse position */ },
  onRelease(id, vars, p)        { /* cleanup if needed */ },

  // Educational content (HTML)
  info: `<h2>The Simple Pendulum</h2><p>...</p>`,
};
```

**Key additions vs old plan:**
- `hitTest/onDrag/onRelease` — sim declares its own drag interaction logic
- `views[]` — sim declares which tabs to show
- `graphDefaults` — default axis mapping for phase/time graphs
- `worldRect` — coordinate bounds for sim canvas
- `vars` is now richer — includes label + symbol for graph axis labels
- `render()` receives a `SimCanvas` object (not raw ctx) for draw helpers

---

## Sim Definition Contract

Every sim file exports ONE object:

```javascript
// physics/labs/js/sims/pendulum.js
const PendulumSim = {
  name:       'Simple Pendulum',
  slug:       'pendulum',
  category:   'Mechanics',
  description:'...',

  // State layout
  vars: { ANGLE: 0, ANGULAR_VEL: 1, TIME: 2 },
  varCount: 3,

  // Parameters with UI metadata
  params: { ... },

  // Functions
  init(params) → initialState[],
  evaluate(state[], change[], params) → void,
  render(ctx, state[], params, width, height) → void,

  // Optional
  energy(state[], params) → { kinetic, potential, total },
  presets: [...],
  info: 'HTML string explaining the physics',
};
```

---

## Where to Find the Physics Equations

For each sim, the reference evaluate() function is in myPhysicsLab:

| Our Sim | Reference File | Key Equations |
|---------|---------------|---------------|
| pendulum | `src/sims/pendulum/PendulumSim.ts` | α = -(g/L)sin(θ) - bω/mL² |
| double-pendulum | `src/sims/pendulum/DoublePendulumSim.ts` | Lagrangian mechanics, 2 coupled 2nd-order ODEs |
| spring | `src/sims/springs/SingleSpringSim.ts` | F = -kx - bv |
| spring-2d | `src/sims/springs/Spring2DSim.ts` | 2D spring with gravity |
| billiards | `src/sims/engine2D/BilliardsApp.ts` | Elastic collision, momentum conservation |
| newtons-cradle | `src/sims/engine2D/NewtonsCradleApp.ts` | Chain of elastic collisions |
| roller-coaster | `src/sims/roller/RollerSingleSim.ts` | Constrained motion on curve, energy conservation |
| collide-blocks | `src/sims/springs/CollideBlocksSim.ts` | 1D elastic/inelastic collision |
| molecule | `src/sims/springs/Molecule3Sim.ts` | N-body spring forces |
| string-wave | `src/sims/pde/StringSim.ts` | Wave equation PDE, finite difference |

**Process for each sim:**
1. Open the reference `*Sim.ts` file
2. Find the `evaluate()` method
3. Extract the physics math (usually 5-20 lines)
4. Write our own `evaluate()` using that math
5. Write our own `render()` (simple canvas drawing)
6. Define params and presets

---

## JSP Template (Minimal — One Per Sim)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="{{TITLE}} — Interactive Physics Simulation" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="{{DESCRIPTION}}" />
    <jsp:param name="toolUrl" value="physics/labs/{{SLUG}}.jsp" />
    <jsp:param name="toolKeywords" value="{{KEYWORDS}}" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="{{TEACHES}}" />
</jsp:include>
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">
</head>
<body>
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="lab-wrap">
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>{{TITLE}}</span>
  </nav>

  <h1 class="lab-title">{{TITLE}}</h1>

  <div class="lab-grid">
    <div class="lab-canvas-wrap">
      <canvas id="simCanvas"></canvas>
    </div>
    <div class="lab-sidebar">
      <div id="controls"></div>
      <details open>
        <summary>Energy</summary>
        <canvas id="energyCanvas" height="120"></canvas>
      </details>
    </div>
  </div>

  <section class="lab-info" id="labInfo"></section>

  <div class="lab-related">
    Also try &rarr;
    <!-- cross-links filled per sim -->
  </div>
</div>

<script src="js/engine.js?v=<%=v%>"></script>
<script src="js/sims/{{SIM_FILE}}.js?v=<%=v%>"></script>
<script>
  const runner = new SimRunner(
    document.getElementById('simCanvas'),
    {{SIM_OBJECT}},
    document.getElementById('controls'),
    document.getElementById('energyCanvas')
  );
  runner.play();
  document.getElementById('labInfo').innerHTML = {{SIM_OBJECT}}.info || '';
</script>

<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
```

**8 placeholders per sim.** Copy, find-replace, done.

---

## How to Add a New Sim (Step-by-Step)

### 1. Find the physics
- Open `myphysicslab/src/sims/<category>/<Name>Sim.ts`
- Find `evaluate()` method — extract the math
- Note what parameters it uses (gravity, mass, length, stiffness, etc.)

### 2. Create the sim file
```bash
touch physics/labs/js/sims/my-new-sim.js
```
Fill in the contract:
```javascript
const MyNewSim = {
  name: '...',
  vars: { ... },
  varCount: N,
  params: { ... },           // auto-generates sliders
  init(p) { return [...]; },
  evaluate(s, c, p) { ... }, // THE PHYSICS from step 1
  render(ctx, s, p, w, h) { ... },
  presets: [ ... ],
  energy(s, p) { ... },      // optional
  info: `<h2>How It Works</h2><p>...</p>`,
};
```

### 3. Create the JSP
- Copy any existing lab JSP
- Replace 8 placeholders (TITLE, SLUG, SIM_FILE, SIM_OBJECT, etc.)

### 4. Update indexes
- Add card to `physics/labs/index.jsp`
- Add to `tools-database.json`
- Add cross-links

### 5. Test
- Browser → verify canvas animates
- Sliders → verify params update live
- Presets → verify state changes
- Mobile → verify responsive
- Dark mode → verify colors

---

## Progress Tracker

### Status Legend
- [x] Done
- [~] In progress
- [ ] Not started

---

### Phase 0: Engine Core (must complete before any sim ships)

- [x] **core/solver.js** — RK4, Euler, Midpoint solvers (68 lines)
- [x] **core/state.js** — cloneState, zeroArray, lerpState, RingBuffer (67 lines)
- [x] **core/runner.js** — SimRunner: RAF loop, play/pause/reset/step, speed, solver swap (156 lines)
- [x] **core/interact.js** — Mouse/touch drag: DragState + bindInteraction (113 lines)
- [x] **canvas/sim-canvas.js** — World-to-screen transform, draw primitives, DPI, resize (215 lines)
- [x] **canvas/graph-canvas.js** — XY phase-space graph, auto-scale, data buffer (95 lines)
- [x] **canvas/time-graph.js** — Rolling time-series, multi-line, auto-scale Y (117 lines)
- [x] **canvas/energy-bar.js** — KE/PE/Total stacked bar + computeEnergyBar helper (78 lines)
- [x] **ui/tabs.js** — Tab switcher: Sim / Phase / Time / Energy (66 lines)
- [x] **ui/controls.js** — Auto-generate sliders/checkboxes + extractDefaults (105 lines)
- [x] **ui/engine-controls.js** — Shared settings + encodeShareUrl/decodeShareUrl (118 lines)
- [x] **ui/transport.js** — Play/Pause/Reset/Step + speed + keyboard (82 lines)
- [x] **ui/presets.js** — Preset pill buttons + applyPreset (55 lines)
- [x] **ui/var-picker.js** — Graph axis dropdown + resolveGraphDefaults (72 lines)
- [x] **lab.js** — Orchestrator: wires all modules, single entry point (192 lines)
- [x] **css/labs.css** — Full Observatory theme, dark/light, responsive, animations (340 lines)

### Phase 0: Testing

- [x] **what_we_test.cjs** — 165 tests, all passing
  - [x] RK4: exponential decay (1e-8), SHO full period, accuracy vs Euler/Midpoint
  - [x] Pendulum: init, evaluate, energy conservation, damping, isDragging, drag arc, hitTest
  - [x] Spring: init, evaluate (F=-kx), energy conservation, period=2π√(m/k), drag
  - [x] RingBuffer: push, overflow, wrap, clear
  - [x] cloneState: independence
  - [x] Sim contract validation: both sims

---

### Phase 1: First 2 Sims (validate full stack end-to-end)

**Sim definitions (physics logic):**
- [x] **sims/pendulum.js** — evaluate, energy, hitTest, onDrag, render, presets (128 lines)
- [x] **sims/spring.js** — evaluate, energy, hitTest, onDrag, render, presets (123 lines)

**JSP pages:**
- [x] **pendulum.jsp** — first lab page, validates entire pipeline
- [x] **spring.jsp** — second page, validates reuse

**Integration:**
- [ ] labs/index.jsp — hub page listing all labs
- [ ] Update physics/index.jsp — add Labs section
- [ ] Add to tools-database.json
- [ ] Cross-links between labs
- [ ] SEO (seo-tool-page.jsp) for each lab
- [ ] Ads (hero + below-content + sticky footer)
- [ ] Analytics include

---

### Phase 2: Next 4 Sims

- [x] **sims/double-spring.js** — Coupled oscillators, 2 blocks, 3 springs, normal modes (186 tests)
- [x] **double-spring.jsp** — Full page with nav, ads, SEO, cross-links
- [x] **sims/double-pendulum.js** — Lagrangian ODEs, chaos sensitivity, both bobs draggable
- [x] **sims/compare-pendulum.js** — Two driven pendulums, butterfly effect, divergence readout
- [x] **pendulum.js updated** — added drive amplitude/frequency params + chaotic preset
- [x] **Motion trail** — fading ghost trail on pendulum + double pendulum sim canvas
- [x] **Time graph cleaned** — removed energy lines (Energy tab handles that)
- [x] **sims/kapitza-pendulum.js** — Vibrating pivot, Kapitza inverted stability, parametric resonance (241 tests)
- [x] **kapitza-pendulum.jsp** — Full page with all views including Well tab
- [x] **sims/molecule.js** — N-body 2D spring network, 2-6 atoms, wall collisions, drag any atom (263 tests)
- [x] **molecule.jsp** — Full page
- [x] **core/runner.js** — added postStep hook for wall collisions
- [x] **sims/collide-blocks.js** — Elastic/inelastic collision, momentum readout, coefficient of restitution
- [x] **sims/cart-pendulum.js** — Coupled cart-pendulum, Lagrangian ODEs, spring+pendulum interaction
- [x] **sims/brachistochrone.js** — 4-ball race on cycloid/line/parabola/circle, path constraint ODE
- [x] **core/collision.js** — Circle-circle + circle-wall collision detection + elastic impulse resolution
- [x] **sims/billiards.js** — N balls on 2D table, triangle formation, friction, elastic/inelastic
- [x] **sims/newtons-cradle.js** — N pendulum bobs with elastic chain collisions (291 tests)
- [x] **ui/data-tools.js** — Export CSV, Screenshot (composites visible canvases), Live Readout
- [x] **sims/string-wave.js** — Wave equation PDE, finite differences, 4 initial shapes, harmonics
- [x] **core/rigid-body.js** — RigidBody class, polygon inertia, centroid, shape generators
- [x] **core/contact-solver.js** — SAT collision detection, impulse with friction + restitution, wall collision
- [x] **canvas/sim-canvas.js** — added polygon() draw method
- [x] **sims/pile.js** — Stacking rigid bodies, mixed shapes, drag & throw
- [x] **Spring mass correction** — m_eff = m + m_spring/3 added to Spring + Double Spring (321 tests)
- [x] **labs/index.jsp** — Hub page with SVG icons, 6 category sections, SEO + ads
- [x] **physics/index.jsp** — Updated: Labs featured first, 12 pill links, hero stats updated
- [x] **sitemap.xml** — 16 new URLs added (15 sims + hub)
- [x] **tools-database.json** — 16 new entries (totalTools: 417)
- [x] **Reddit posts** — Short + long versions, self-promo safe, comment reply templates
- [x] **Demo recorder** — record-physics-labs-demo.js + record-spring-demo.js

### Phase 4: Future (Traffic-Dependent)

Wait for traffic data from the 15 labs launch, then decide:

- [ ] **Projectile Motion** — easy build (~60 lines), high search volume, uses existing ODE engine
- [ ] **Energy Skate Park** — user-drawn track, extension of brachistochrone path constraint
- [ ] **Circuit Simulator** — new domain (graph-based Kirchhoff solver), high demand, big project
- [ ] **PhET integration** — iframe embed only (GPL blocks code reuse). Low priority unless traffic justifies
- [ ] **More Engine2D sims** — Polygon playground, gear mechanisms
- [ ] **3D sims** — WebGL-based, major new engine. Only if 2D labs prove traffic
- [ ] **sims/string-wave.js** — PDE wave equation, finite difference method
- [ ] **sims/spring-2d.js** — 2D spring with gravity (adds y-axis)
- [ ] JSP pages for each
- [ ] Update hub + cross-links

### Phase 3: Expand

- [ ] Newton's Cradle (collision chain)
- [ ] Roller Coaster (constrained motion on curve)
- [ ] Molecule 3-body (spring network)
- [ ] Cart + Pendulum (coupled system)
- [ ] Billiards (2D collision detection)

### Phase 4: Polish

- [ ] Share URL encoding (params → URL hash → auto-load)
- [ ] Fullscreen canvas mode
- [ ] Screenshot/export canvas as PNG
- [ ] Mobile touch gestures (pinch-zoom on canvas)
- [ ] Reduced-motion support
- [ ] Reddit post for physics labs

---

### What's Next (in order)

1. ~~core/interact.js~~ DONE
2. ~~canvas/sim-canvas.js~~ DONE
3. ~~canvas/graph-canvas.js + time-graph.js + energy-bar.js~~ DONE
4. ~~ui/*.js — all 6 modules~~ DONE
5. ~~lab.js — orchestrator~~ DONE
6. ~~css/labs.css~~ DONE (340 lines, Observatory theme)
7. ~~pendulum.jsp~~ DONE (full SEO, FAQs, cross-links)
8. ~~spring.jsp~~ DONE (validates reuse — different sim, same engine)
9. **Browser test** — deploy and verify both sims end-to-end
10. **labs/index.jsp** — hub page listing all labs
11. **Update physics/index.jsp** — add Labs section with cards
12. **tools-database.json** — add both labs
13. **Phase 2 sims** — double-pendulum, collide-blocks, string-wave, spring-2d

---

## Reference Quick-Links

| Need | Where to Look |
|------|---------------|
| Physics equations | `myphysicslab/src/sims/<category>/<Name>Sim.ts` → `evaluate()` |
| RK4 algorithm | `myphysicslab/src/lab/model/RungeKutta.ts` |
| Canvas rendering | `myphysicslab/src/lab/view/LabCanvas.ts` |
| Coordinate transform | `myphysicslab/src/lab/view/CoordMap.ts` |
| Energy calculations | Inside each `*Sim.ts` → look for `getEnergyInfo()` |
| Collision detection | `myphysicslab/src/lab/engine2D/ImpulseSim.ts` |
| Spring drawing | `myphysicslab/src/lab/view/DisplaySpring.ts` |
| Parameter names | Open any `*Sim.ts` → look for `addParameter()` calls |

---

## Three.js 3D Simulations — New Engine Layer

### Why Three.js?

Some physics concepts are better taught with a 3D scene than a 2D canvas. The **Ramp: Forces & Motion** sim was the first to use this approach. Three.js gives us:

- **Perspective depth** — students see the ramp as a real physical structure, not a flat diagram
- **Orbit camera** — view the scene from any angle, understand spatial relationships
- **3D force arrows** (cylinder + cone) — more visible and intuitive than 2D line arrows
- **Shadows and lighting** — visual realism that makes the sim feel like a lab
- **Sprite labels** — text that always faces the camera, readable from any angle
- **Material/color feedback** — objects change appearance when hovered, walls flash on impact

### Architecture: Hybrid Three.js + Engine Modules

Three.js sims are **standalone** — they do NOT use `createLab()`. But they import individual engine modules for graphs and tabs:

```
Three.js Sim (e.g., ramp.js)
├── THREE.Scene, Camera, Renderer, OrbitControls   ← Three.js (CDN)
├── Custom physics (forces function + Euler step)  ← inline in sim
├── TabSwitcher                                     ← from ui/tabs.js
├── TimeGraph                                       ← from canvas/time-graph.js
├── EnergyBar                                       ← from canvas/energy-bar.js
├── Custom controls (built programmatically)        ← uses labs.css classes
└── Custom interaction (Raycaster + drag)           ← Three.js pointer events
```

### JSP Setup for Three.js Sims

```html
<!-- Import map for Three.js (in <head>) -->
<script type="importmap">
{ "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.170.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.170.0/examples/jsm/"
} }
</script>

<!-- Standard lab layout with simContainer instead of <canvas> -->
<div class="lab-canvas-wrap" id="simPanel">
  <div id="simContainer"></div>               <!-- Three.js renders here -->
</div>
<div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
  <canvas id="timeCanvas"></canvas>           <!-- Engine TimeGraph -->
  <canvas id="energyCanvas"></canvas>         <!-- Engine EnergyBar -->
</div>
```

### Module Export Pattern

```javascript
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { TabSwitcher } from '../ui/tabs.js';
import { TimeGraph } from '../canvas/time-graph.js';
import { EnergyBar } from '../canvas/energy-bar.js';

export function createRampSim(elements) {
  // elements = { simContainer, sidebar, forceBar, readout, tabs, canvasArea,
  //              timeCanvas, energyCanvas }
  //
  // Returns: { reset, destroy }
}
```

### Three.js Scene Checklist (for new 3D sims)

When building a new Three.js sim, include:

| Component | Purpose | Implementation |
|-----------|---------|---------------|
| **Scene + Fog** | Sky-colored background with depth fade | `scene.background`, `scene.fog` |
| **Camera** | Perspective, responsive FOV | `PerspectiveCamera`, FOV adapts to viewport width |
| **OrbitControls** | User can rotate/zoom | Damping enabled, polar angle capped |
| **Lighting** | Ambient + directional with shadows | `AmbientLight` + `DirectionalLight` with shadow map |
| **Ground plane** | Reference surface | `PlaneGeometry` with grass material + surface overlay |
| **Ruler/grid** | Distance reference | Tick marks, metre labels, base markers |
| **Object meshes** | The physics objects | `BoxGeometry`/etc with `MeshLambertMaterial`, edge wireframes |
| **Force arrows** | 3D cylinder + cone | `make3DArrow(color)` → Group with shaft + head, scaled per frame |
| **Sprite labels** | Always-facing text | `makeSprite(text, color, fontSize)` → 512×128 canvas texture |
| **Distance labels** | Live position/distance readout | `updateSpriteText()` redraws canvas each frame |
| **Motion trail** | Path history dots | `SphereGeometry` dots, fade over time, cleared on reset |
| **Kinematic arrows** | Velocity (green) + acceleration (amber) | Scaled per frame, only visible when moving |
| **Wall flash** | Impact feedback | `emissive` glow on hit, fades over 0.25s |
| **Hover highlight** | Draggable affordance | `emissive` glow + cursor change on hover |
| **Raycaster interaction** | Click-drag objects | `hitTest()` → `pointerdown/move/up` handlers |

### Physics Pattern for Three.js Sims

Three.js sims use **simple Euler integration** (not RK4) because:
1. The physics is typically 1D (along a path) — simpler than multi-body ODE systems
2. 120 Hz fixed timestep is sufficient for accuracy
3. No need for the full SimRunner machinery

```javascript
const DT = 1 / 120;

function step(dt) {
  const f = forces(s, v, P);           // compute all forces
  frictionHeat += |Ff| * |v| * dt;     // accumulate friction heat
  workApplied  += Fa * v * dt;         // accumulate applied work
  v += f.a * dt;                       // Euler velocity update
  s += v * dt;                         // Euler position update
  // Wall collisions with per-wall restitution
  // Energy bookkeeping for wall impact losses
}
```

For **graph data**, the step function feeds the engine's TimeGraph and EnergyBar:

```javascript
timeGraph.push(t, new Float64Array([s, v, a, Fnet]));
energyChart.pushTime(t, KE, PE, KE + PE + frictionHeat);
//                                        ↑ total stays flat when no applied force
```

### Control Pattern for Three.js Sims

Controls are built programmatically using labs.css classes (not the engine's auto-generator):

```javascript
// Uses these CSS classes from labs.css:
// .lab-transport + .transport-btn     — play/pause/reset/step
// .lab-params + .param-row            — slider container
// .param-header + .param-label        — label + value display
// .param-slider                       — range input
// .param-check                        — checkbox
// .param-select                       — dropdown
// .lab-presets + .preset-btn          — preset pill buttons
```

A central `syncAll()` function syncs ALL controls ↔ state bidirectionally:
- Param sliders (angle, mass, μs, μk, rampLength, eTop, eLeft)
- Checkboxes (showForces, showValues, showDecomp)
- Force controls (sidebar slider + quick buttons + below-canvas bar + number input)
- Object dropdown
- Surface button highlights

### Object & Surface Catalogs

Three.js sims can define catalogs of selectable objects and surface materials:

```javascript
const OBJECTS = {
  crate_sm:  { label: 'Small Crate',  mass: 5,   mu_s: 0.50, mu_k: 0.30, color: 0xD4881C, edge: 0x8A5010 },
  piano:     { label: 'Piano',        mass: 250, mu_s: 0.55, mu_k: 0.35, color: 0x1A1A1A, edge: 0x444444 },
  // ... each has distinct 3D color + physics properties
};

const SURFACES = {
  wood:   { label: 'Wood',   color: 0xC07828, grain: 0xA06010, mu_s: null, mu_k: null },  // uses object's μ
  ice:    { label: 'Ice',    color: 0xAADDEE, grain: 0x88BBCC, mu_s: 0.03, mu_k: 0.01 },  // overrides μ
  // ... affects both ramp AND ground visuals + physics
};
```

Selecting an object → changes crate color/size, sets mass + friction, syncs sliders.
Selecting a surface → changes ramp + ground color, optionally overrides friction.
Manually changing mass/friction slider → auto-switches to "Custom" object.

### Energy Tracking (Friction Heat)

Three.js sims track accumulated friction heat so the energy chart shows true conservation:

```
Energy chart:
  Red area  = KE (kinetic)
  Blue area = PE (potential, stacked on KE)
  Green line = KE + PE + Heat = Total (stays FLAT with no applied force)
  Gap between blue top and green line = friction heat loss
```

This is the key insight: energy doesn't disappear — it converts to heat. The green line staying flat proves conservation.

### Testing Three.js Sim Physics

The physics function is **pure math** (no Three.js dependency) and is inlined into `what_we_test.cjs`:

```javascript
// In what_we_test.cjs — copy the forces() function, test it directly:
function rampForces(s, v, P) { /* ... exact copy from ramp.js ... */ }

section('Ramp — Frictionless: a = g sin θ');
{
  const f = rampForces(3, 0.01, { mu_s: 0, mu_k: 0, mass: 1, angle: 30 });
  assertClose(f.a, -G * Math.sin(30° in rad), 0.01, 'a = g sin θ');
}
```

**Current ramp tests: 20 test sections, all passing (379/379 total assertions).**

### Ramp Sim — Complete Feature List

| Feature | Status |
|---------|--------|
| Three.js 3D scene (sky, grass, shadows, fog) | ✅ |
| Ramp plank with surface-colored grain lines | ✅ |
| Ramp support triangle (side panels + cross braces) | ✅ |
| Brick walls (top + left) with mortar lines | ✅ |
| Crate with edge wireframe, color per object type | ✅ |
| 7 object presets (crate, fridge, piano, person, ice block, custom) | ✅ |
| 4 surface materials (wood, ice, rubber, metal) | ✅ |
| Surface applies to BOTH ramp and ground visually | ✅ |
| Per-wall restitution (eTop, eLeft: 0=brick to 1=elastic) | ✅ |
| Wall-hit flash effect (emissive glow, 0.25s fade) | ✅ |
| Click-drag crate to apply force (release = force 0) | ✅ |
| Click-drag ramp to change angle | ✅ |
| Hover highlight on crate + ramp | ✅ |
| 3D force arrows (gravity, normal, applied, friction, mg decomposition) | ✅ |
| 3D velocity arrow (green) + acceleration arrow (amber) | ✅ |
| Sprite labels on all arrows | ✅ |
| Motion trail (fading dots showing path history) | ✅ |
| Metre ruler with tick marks and base marker | ✅ |
| Live distance labels (position, to-ramp, to-wall) | ✅ |
| Angle arc + height dashed line + labels | ✅ |
| Tabs: Sim / Time / Energy (via engine TabSwitcher) | ✅ |
| Time graph: 4 lines (position, velocity, acceleration, net force) | ✅ |
| Energy chart: KE + PE + friction heat (total = conservation line) | ✅ |
| Accumulated friction heat tracking | ✅ |
| Wall collision energy loss tracking | ✅ |
| Applied force: sidebar slider + quick buttons + below-canvas bar + number input + drag | ✅ |
| All 5 force inputs stay bidirectionally synced | ✅ |
| 8 scenario presets (Frictionless, Critical θ, Ice Hockey, Pinball, etc.) | ✅ |
| Play/Pause/Reset/Step with keyboard shortcuts (Space/R/→) | ✅ |
| Presets auto-play on selection | ✅ |
| Responsive camera (FOV adapts to viewport width) | ✅ |
| Responsive HTML legends (clamp-based font/dot sizing) | ✅ |
| aria-labels on all sliders | ✅ |
| 20 physics test sections (379 assertions) | ✅ |

### What Sims Should Use Three.js vs 2D Canvas?

| Use Three.js when... | Use 2D Canvas engine when... |
|-----------------------|------------------------------|
| Scene has spatial depth (ramps, 3D objects) | Motion is in a plane (pendulum, spring) |
| Students benefit from viewing from different angles | Fixed viewpoint is sufficient |
| Objects have real-world appearance (crates, walls, surfaces) | Objects are abstract (bobs, blocks, graphs) |
| Force decomposition needs 3D perspective | Phase space / time graphs are the main view |
| The "will it reach?" experiment needs visual scale | Precise ODE integration matters (chaos, resonance) |

Most sims should stay with the 2D canvas engine. Three.js is for sims where **spatial understanding** is the learning goal.

### Potential Future Three.js Sims

| Sim | Why Three.js? |
|-----|---------------|
| **Projectile Motion** | 3D trajectory arc, range/height visible from multiple angles |
| **Pulley System** | Ropes, pulleys, weights hanging in 3D space |
| **Roller Coaster** | Track with loops, banked curves — energy conservation in 3D |
| **Atwood Machine** | Two masses + pulley — spatial layout helps understanding |
| **Collision Table** | Billiard-style 2D collisions rendered as a 3D table |
| **Resonance** | See the spring stretch dramatically at resonance, driver mechanism visible in 3D |
| **Inclined Plane Pulley** | Two masses, incline, rope over pulley — spatial layout essential for understanding |

---

## Inclined Plane Pulley — Two Masses (Three.js PLAN)

### The Physics

Two masses connected by a rope over a frictionless pulley:
- **m₁** (brown) sits on an inclined plane at angle θ with friction μ
- **m₂** (green) hangs vertically off the edge

The rope is **inextensible** — both masses share the same acceleration magnitude `|a|` and the rope has uniform tension `T`.

```
        ╭─○─╮  pulley (frictionless, massless)
        │   │
   m₁ ──┘   │
  ╱ on ramp  │
 ╱ θ         m₂  (hanging)
╱____________╱
```

### Equations (from the problem statement)

**When m₂ pulls m₁ uphill** (a > 0, the common case):

```
a = g · (m₂ − μ·m₁·cosθ − m₁·sinθ) / (m₁ + m₂)

T = m₁·m₂·g · (1 + μ·cosθ + sinθ) / (m₁ + m₂)
```

**When m₁ slides downhill** (gravity wins, m₂ goes up):

```
a = g · (m₁·sinθ − μ·m₁·cosθ − m₂) / (m₁ + m₂)     ← friction now opposes downhill

T = m₁·m₂·g · (1 − sinθ + μ·cosθ) / (m₁ + m₂)
```

**Equilibrium (no motion) when:**
```
m₁·(sinθ − μ·cosθ)  ≤  m₂  ≤  m₁·(sinθ + μ·cosθ)
```

This is the "dead zone" where static friction holds everything in place.

**Key insight**: The friction term `μ·m₁·cosθ` flips sign depending on direction. This is what students get wrong most often.

### State Variables

```javascript
// s = distance m₁ has moved along the ramp (positive = uphill)
// v = velocity along ramp (positive = uphill = m₂ going down)
// Constraint: when m₁ moves +s uphill, m₂ moves −s downward

state = { s: 0, v: 0, t: 0 }
```

### Physics Function

```javascript
function accel(s, v, P) {
  const th = P.angle * Math.PI / 180;
  const m1 = P.m1, m2 = P.m2, mu = P.mu;
  const g = 9.81;

  const gravPull = m2 * g;                           // m₂ pulling down
  const gravRamp = m1 * g * Math.sin(th);            // m₁ gravity along ramp (downhill)
  const normal = m1 * g * Math.cos(th);              // normal force on m₁

  // Net force without friction (positive = m₂ wins, m₁ goes uphill)
  const Fnet_nf = gravPull - gravRamp;

  // Friction
  const moving = Math.abs(v) > 1e-3;
  let Ff = 0;
  if (moving) {
    Ff = mu * normal * Math.sign(v);  // opposes velocity direction
    // If v > 0 (uphill), friction acts downhill (+Ff opposing)
    // If v < 0 (downhill), friction acts uphill (−Ff opposing)
  } else {
    const Fs_max = P.mu_s * normal;   // static friction
    if (Math.abs(Fnet_nf) <= Fs_max) {
      return { a: 0, T: /* ... */, Ff: -Fnet_nf, equilibrium: true };
    }
    Ff = mu * normal * Math.sign(Fnet_nf);  // kinetic kicks in
  }

  const Fnet = Fnet_nf - Ff;         // subtract friction (it always opposes net motion tendency)
  const a = Fnet / (m1 + m2);        // shared acceleration (rope constraint)

  // Tension: T = m₂·(g − a) when m₂ descends, or T = m₂·(g + a) when m₂ ascends
  const T = m2 * (g - a);            // from m₂'s free body diagram

  return { a, T, Ff, Fnet, equilibrium: false };
}
```

### Three.js Scene

```
Camera view (3/4 perspective):

         ╭──○──╮   ← pulley wheel (cylinder, rotates!)
    rope─┘     │
   m₁ ╱       │ rope
  ╱╱╱╱╱       │
 ╱╱╱╱╱ ramp   ■ m₂  ← hanging mass (green)
╱╱╱╱╱ θ       │
─────────     ─── ground
```

**Scene elements:**

| Element | Geometry | Behavior |
|---------|----------|----------|
| **Inclined plane** | Wedge (ExtrudeGeometry), wood-textured | Angle changes with slider. Support triangle underneath. |
| **m₁ (ramp mass)** | BoxGeometry, brown, edge wireframe | Slides along ramp surface. Size scales with mass. |
| **m₂ (hanging mass)** | BoxGeometry, green, edge wireframe | Moves vertically. Constrained: when m₁ goes up, m₂ goes down. |
| **Pulley** | CylinderGeometry at top of ramp | **Rotates** proportional to rope movement — visual feedback. |
| **Rope** | THREE.Line from m₁ → over pulley → down to m₂ | Updates each frame. Taut (straight lines). |
| **Force arrows on m₁** | 3D arrows | Weight (mg), Normal (N), Friction (f), Tension (T along ramp) |
| **Force arrows on m₂** | 3D arrows | Weight (m₂g down), Tension (T up) |
| **FBD labels** | Sprites | Force names + values on each arrow |
| **Ground** | PlaneGeometry, green grass | Reference surface |
| **Angle arc** | Line at base of ramp | Shows θ with label |
| **Height marker** | Dashed vertical from pulley | h = L·sinθ |

### Interactive Features

| Interaction | How |
|-------------|-----|
| **Drag m₁ along ramp** | Click + drag → set position, physics pauses for that mass |
| **Drag m₂ vertically** | Click + drag → coupled: m₁ moves opposite direction |
| **Drag ramp edge** | Click ramp surface + drag up/down → change angle |
| **Release any mass** | Physics resumes from current position with v = 0 |

**Key UX**: dragging m₂ down should visually pull m₁ up the ramp (and vice versa). The rope stays taut.

### Parameters

| Param | Range | Default | Unit |
|-------|-------|---------|------|
| m₁ (ramp mass) | 0.5 – 20 | 5 | kg |
| m₂ (hanging mass) | 0.5 – 20 | 3 | kg |
| Ramp angle θ | 0 – 60 | 30 | ° |
| μ (kinetic friction) | 0 – 1.0 | 0.3 | |
| μs (static friction) | 0 – 1.5 | 0.4 | |
| Ramp length | 3 – 10 | 6 | m |
| Rope length | auto | auto | (inextensible) |

### Derived Values (shown in readout)

```
a = 1.23 m/s²  |  T = 24.5 N  |  v = 2.1 m/s  |  friction = 12.7 N (kinetic)
N = 42.5 N  |  m₂g = 29.4 N  |  m₁g sinθ = 24.5 N
● m₂ PULLING m₁ UPHILL  (or)  ● EQUILIBRIUM — static friction holds
```

### Graph Tabs

| Tab | What it shows |
|-----|---------------|
| **Sim** | 3D scene full width |
| **Time** | Position, velocity, acceleration vs time (TimeGraph) |
| **Energy** | KE (both masses) + PE (both) + friction heat. Total − heat = constant. |
| **Forces** | Bar chart or time plot: T, m₁g sinθ, friction, N, m₂g |

### Presets

| Preset | Settings | What it teaches |
|--------|----------|-----------------|
| **Default** | m₁=5, m₂=3, θ=30°, μ=0.3 | m₂ pulls m₁ uphill |
| **Balanced** | m₁=5, m₂=m₁(sinθ+μcosθ) | Exact equilibrium boundary — any nudge starts motion |
| **Frictionless** | μ=0, θ=30° | Pure Atwood on incline — a = g(m₂−m₁sinθ)/(m₁+m₂) |
| **Heavy Hanging** | m₁=2, m₂=10 | m₂ dominates, fast uphill pull |
| **Heavy on Ramp** | m₁=15, m₂=3 | m₁ slides downhill, m₂ goes up |
| **Steep & Icy** | θ=50°, μ=0.02 | Gravity dominates, m₁ slides down fast |
| **High Friction** | μ=0.8, θ=20° | System barely moves — friction eats all the force |
| **Equal Masses** | m₁=m₂=5, θ=30° | Who wins? Depends on θ and μ! |

### Educational Content

**Learning Goals:**
1. Apply Newton's 2nd law to a two-body system with a constraint (rope)
2. Understand that tension is the same throughout an ideal rope
3. Correctly decompose forces on an inclined plane
4. Determine when a system accelerates vs stays in equilibrium
5. See how friction direction depends on motion direction (the sign flip!)
6. Use free body diagrams for each mass separately, then combine
7. Verify energy conservation: KE₁ + KE₂ + PE₁ + PE₂ + friction heat = constant

**The "aha" moments:**
1. **Friction flips**: Change m₂ so the system reverses direction. Watch friction arrow flip on m₁. Students always get this sign wrong on paper.
2. **Dead zone**: Set up near equilibrium. There's a RANGE of m₂ where nothing moves. This is static friction's adjustable nature.
3. **Equal masses on 30° ramp**: If m₁ = m₂ and θ = 30°, does m₂ win? Only if sinθ < 1 (always true), so m₂ always pulls m₁ uphill with equal masses on < 90° incline. Surprising to students.
4. **Tension ≠ weight**: T ≠ m₂g (it's less, because m₂ is accelerating down). This is the #1 mistake in Atwood problems.

### Physics Tests to Write

```javascript
// Frictionless Atwood: a = g(m₂ − m₁sinθ)/(m₁+m₂)
section('Pulley — Frictionless Acceleration');

// Tension: T = m₁m₂g(1+sinθ)/(m₁+m₂) when μ=0
section('Pulley — Frictionless Tension');

// Equilibrium zone: m₁(sinθ−μcosθ) ≤ m₂ ≤ m₁(sinθ+μcosθ)
section('Pulley — Equilibrium Dead Zone');

// Energy conservation: KE₁+KE₂+PE changes = friction work
section('Pulley — Energy Conservation with Friction');

// Equal masses, 30° ramp, no friction: a = g(1−sin30°)/2 = g/4
section('Pulley — Equal Masses Special Case');

// Friction reversal: system reverses, friction flips sign
section('Pulley — Friction Direction Reversal');

// Tension < m₂g always (when system accelerates with m₂ going down)
section('Pulley — Tension Less Than m₂g');

// At equilibrium: a=0, T = m₂g (rope just holds m₂ stationary)
section('Pulley — At Equilibrium T = m₂g');
```

### Implementation Order

```
Phase 1: Physics + 3D scene
  - pulley.js: acceleration function, RK4 integration
  - Scene: ramp wedge, two mass blocks, pulley cylinder, rope line
  - Position constraint: s_m1 + s_m2 = constant
  - Boundary: masses stop at ramp ends

Phase 2: Force visualization
  - Force arrows on each mass (3D cylinder+cone)
  - FBD labels (sprites)
  - Friction direction indicator
  - Equilibrium/motion status in readout

Phase 3: Controls + graphs
  - m₁, m₂, angle, friction sliders
  - Time graph (position, velocity, acceleration)
  - Energy graph (KE₁, KE₂, PE₁, PE₂, friction heat)
  - Presets

Phase 4: Interaction + polish
  - Drag m₁ or m₂ (coupled via rope constraint)
  - Drag ramp to change angle
  - Pulley wheel rotation animation
  - Motion trail on both masses
  - Share link encoding

Phase 5: Tests
  - All 8 test sections above
  - Verify against analytical formulas
  - Energy conservation check
```

### File Structure

```
physics/labs/
├── pulley.jsp                    # JSP page
├── js/sims/pulley.js             # Three.js sim (~700 lines)
```

---

## Center of Mass: Person on Floating Raft (Three.js PLAN)

### The Physics

A person (mass mₚ) walks on a raft (mass mᵣ) floating on water.
No external horizontal forces → **center of mass stays fixed**.

```
mₚ · xₚ + mᵣ · xᵣ = constant = (mₚ + mᵣ) · x_cm
```

When the person walks right by Δxₚ, the raft drifts left by:
```
Δxᵣ = −(mₚ / mᵣ) · Δxₚ
```

The person's position in the world frame:
```
x_person_world = xᵣ + x_person_on_raft
```

### State

```javascript
// personPos = position of person on the raft (0 = center, +right, −left)
// raftX     = world position of raft center
// Constraint: mₚ·(raftX + personPos) + mᵣ·raftX = constant
//           → raftX = x_cm_initial − mₚ·personPos / (mₚ + mᵣ)
```

No ODE needed — the raft position is computed directly from the constraint at every frame. The person walks at a constant speed, the raft responds instantly (water has no friction in the ideal case). For realism we can add water drag.

### Three.js Scene

```
Side view:

  ~~~~~~~~~~~~~~~~~~~~~ water surface ~~~~~~~~~~~~~~~~~~~~~
        ┌──────────────────────────┐
        │         RAFT             │ ← floats on water
        │    🧍                    │ ← person walks left/right
        └──────────────────────────┘
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ── CM marker (triangle/diamond on water surface, stays fixed) ──
```

**Scene elements:**

| Element | Geometry | Behavior |
|---------|----------|----------|
| **Water** | PlaneGeometry, blue, semi-transparent | Static, with subtle wave animation (vertex displacement) |
| **Raft** | BoxGeometry, wood-colored | Floats on water surface. Drifts left/right as person walks. |
| **Person** | Simple stick figure or capsule | Walks left/right on the raft at constant speed. Reverses at raft edges. |
| **CM marker** | Small diamond/cone on water surface | FIXED position — shows center of mass doesn't move |
| **CM line** | Dashed vertical line from CM marker up | Visual reference |
| **Person position arrow** | Arrow from raft center to person | Shows xₚ on raft |
| **Raft drift arrow** | Arrow showing raft displacement from initial | Shows Δxᵣ |
| **Mass labels** | Sprites | Show mₚ, mᵣ, x_cm |

### What Makes This Educational

1. **CM stays put** — the triangle on the water never moves, even though both person and raft move. This is the "aha".
2. **Mass ratio matters** — heavy raft barely moves. Light raft moves a lot. Student adjusts the ratio and sees the effect.
3. **Person walks back** — raft returns to original position. Total displacement of CM = 0 always.
4. **Momentum conservation** — if person jumps off the raft, raft keeps drifting. This shows impulse.

### Parameters

| Param | Range | Default | Unit |
|-------|-------|---------|------|
| Person mass (mₚ) | 30 – 150 | 70 | kg |
| Raft mass (mᵣ) | 50 – 500 | 200 | kg |
| Walk speed | 0.5 – 3 | 1.0 | m/s |
| Raft length | 3 – 10 | 6 | m |
| Water drag | 0 – 1 | 0 | (0 = ideal, 1 = high drag) |
| Show CM | checkbox | on | |
| Show arrows | checkbox | on | |

### Presets

| Preset | Settings | What it teaches |
|--------|----------|-----------------|
| **Default** | mₚ=70, mᵣ=200 | Raft drifts noticeably |
| **Equal Masses** | mₚ=100, mᵣ=100 | Raft moves as much as person — symmetric! |
| **Heavy Raft** | mₚ=70, mᵣ=500 | Raft barely moves — like walking on solid ground |
| **Light Raft** | mₚ=100, mᵣ=50 | Raft moves MORE than person — surprising! |
| **Walk and Jump** | person walks to edge then "jumps off" (velocity impulse) | Raft keeps drifting after person leaves |

### Graph Tabs

| Tab | What it shows |
|-----|---------------|
| **Sim** | 3D scene |
| **Time** | x_person, x_raft, x_cm vs time. CM line is flat. |
| **Momentum** | p_person, p_raft, p_total vs time. Total = 0 always. |

### Learning Goals

1. Explain why the center of mass of an isolated system doesn't move.
2. Predict which direction the raft moves when the person walks.
3. Calculate the raft displacement given person displacement and mass ratio.
4. Explain why a heavier raft moves less.
5. Relate this to Newton's 3rd law (person pushes raft backward, raft pushes person forward).
6. Apply to real-world: astronaut in space station, recoil, ice skating pairs.

### Physics Tests

```javascript
section('Raft — CM Conservation');
// mₚ·xₚ_world + mᵣ·xᵣ = constant at all times

section('Raft — Raft Displacement = −(mₚ/mᵣ)·Δxₚ');
// Person walks 2m right → raft moves −(70/200)·2 = −0.7m left

section('Raft — Equal Masses: Raft and Person Move Same Distance');
// mₚ = mᵣ = 100: person walks 1m → raft moves −1m

section('Raft — Heavy Raft Barely Moves');
// mᵣ = 500: raft moves −(70/500)·2 = −0.28m

section('Raft — Total Momentum = 0');
// mₚ·vₚ + mᵣ·vᵣ = 0 at all times (no external forces)

section('Raft — Person Returns: Raft Returns to Start');
// Person walks to edge and back → raft returns to x=0

section('Raft — Water Drag Breaks CM Conservation');
// With drag > 0, CM drifts slightly — shows it's an approximation
```

### Implementation Order

```
Phase 1: Physics + scene
  - raft-cm.js: constraint equation, raft position from person position
  - Scene: water plane, raft box, person (capsule or stick figure), CM marker
  - Person walk animation (constant speed, reverses at edges)

Phase 2: Visuals
  - Water wave animation (vertex displacement)
  - Raft bobbing slightly
  - Person walking animation (leg movement?)
  - CM marker (fixed diamond + dashed line)
  - Position arrows

Phase 3: Controls + graphs
  - Mass sliders, speed slider, drag slider
  - Time graph (positions)
  - Momentum graph
  - Presets

Phase 4: Polish
  - Walk/pause/reset transport
  - Drag person to position
  - Water drag mode
  - Share link
```

---

## States of Matter — Molecular Dynamics (Three.js PLAN)

### Overview

A 2D container of particles interacting via Lennard-Jones potential. Students see molecules form a solid (ordered grid), liquid (close but mobile), or gas (spread out, fast). Add/remove heat to drive phase transitions. Adjust volume. Watch a P-T diagram respond in real time.

This is a **molecular dynamics (MD) simulation** — the most computationally intensive sim we've built. Each particle has position + velocity, and forces are computed from pair interactions every timestep.

### The Physics: Lennard-Jones Potential

```
V(r) = 4ε [ (σ/r)¹² − (σ/r)⁶ ]
```

| Symbol | Meaning | Default |
|--------|---------|---------|
| `ε` | Depth of potential well (bond strength) | 1.0 (dimensionless units) |
| `σ` | Distance where V=0 (particle diameter) | 1.0 |
| `r` | Distance between two particles | computed |

**Force from LJ potential:**
```
F(r) = 24ε/r [ 2(σ/r)¹² − (σ/r)⁶ ]
```
- `r < σ`: strong repulsion (particles overlap)
- `r ≈ 1.12σ`: equilibrium (minimum energy, F=0)
- `r > 1.12σ`: weak attraction (pulls particles together)
- `r > 2.5σ`: effectively zero (cutoff distance)

### State

```javascript
// N particles in a 2D box
// Each particle: { x, y, vx, vy }
// Box: width W, height H (adjustable volume)
// Temperature: controlled by velocity rescaling (thermostat)
```

### What the Student Sees

**Three.js scene (top-down 2D view rendered in 3D):**

```
┌──────────────────────────────┐
│  ○ ○ ○ ○ ○ ○ ○ ○  ← solid  │  ← particles in a box
│  ○ ○ ○ ○ ○ ○ ○ ○            │
│  ○ ○ ○ ○ ○ ○ ○ ○            │
│                              │
│   ← piston (adjustable) →   │
└──────────────────────────────┘
```

**Solid**: Particles in a regular lattice, vibrating in place
**Liquid**: Particles close together, flowing, no fixed positions
**Gas**: Particles spread out, fast, bouncing off walls

### Molecule Types

| Type | ε (well depth) | σ (size) | Behavior |
|------|---------------|----------|----------|
| Neon | 0.5 | 0.9 | Weak bonds, gas at room temp |
| Argon | 1.0 | 1.0 | Default, shows all phases |
| Oxygen | 1.2 | 1.1 | Diatomic (2 bonded atoms) |
| Water | 2.0 | 1.0 | Strong hydrogen bonds, high boiling point |

### Tabs / Views

| Tab | What It Shows |
|-----|---------------|
| **Sim** | The particle box — molecules moving, phase visible |
| **P-T Diagram** | Pressure vs Temperature plot with current state marked, phase boundaries drawn |
| **LJ Potential** | The V(r) curve with current average r marked — shows attractive/repulsive regions |
| **Energy** | KE (red) + PE (blue) + Total (green) vs time |

### The P-T Diagram (Key Educational Feature)

```
  Pressure
  │
  │         ╱ solid
  │   solid╱
  │       ╱── triple point
  │      ╱  ╲
  │  liquid   ╲ gas
  │             ╲
  │              ╲── critical point
  │    gas
  └──────────────────── Temperature

  ● = current state (moves in real time!)
```

The student adjusts temperature (add/remove heat) and volume (move piston), and the dot moves on the P-T diagram. Crossing a phase boundary → the particles visibly change state.

### The LJ Potential Graph

```
  V(r)
  │
  │╲
  │ ╲          ← repulsive wall (r < σ)
  │  ╲
  │   ╲───── ← equilibrium (r ≈ 1.12σ, V = -ε)
  │    ╱
  │   ╱     ← attractive well
  │──╱──────── V = 0
  │
  └──────────── r
       σ  r_eq

  ● = average nearest-neighbor distance (moves with temperature)
```

### Parameters

| Param | Range | Default | What It Controls |
|-------|-------|---------|-----------------|
| Temperature | 0.01 – 5.0 | 0.5 | Kinetic energy of particles (thermostat) |
| Volume (piston) | 0.3 – 1.0 | 0.7 | Box width (compressed → high pressure) |
| Molecule type | Neon/Argon/O₂/Water | Argon | Sets ε and σ |
| Number of particles | 20 – 200 | 50 | More particles = better statistics |
| ε (epsilon) | 0.1 – 5.0 | 1.0 | Bond strength (manual override) |
| σ (sigma) | 0.5 – 2.0 | 1.0 | Particle size (manual override) |
| Heat rate | slider | 0 | Add/remove heat continuously |
| Gravity | 0 – 1 | 0 | Optional downward force (shows sedimentation) |

### Presets

| Preset | Settings | What It Shows |
|--------|----------|---------------|
| **Solid** | T=0.1, compressed | Particles in lattice, vibrating |
| **Liquid** | T=0.5, medium volume | Flowing but cohesive |
| **Gas** | T=2.0, expanded | Fast particles, no structure |
| **Melting** | T starts low, ramps up | Watch solid → liquid transition |
| **Boiling** | T starts medium, ramps up | Watch liquid → gas transition |
| **Critical Point** | T≈1.3, V≈0.5 | Near critical point — density fluctuations |
| **Weak Bonds (Neon)** | Low ε | Gas even at low temperature |
| **Strong Bonds (Water)** | High ε | Liquid persists at high temperature |

### Learning Goals → Features

| Learning Goal | Feature |
|---------------|---------|
| Molecular model for solid/liquid/gas | Visual: lattice (solid), flowing (liquid), spread (gas) |
| Phase changes | Heat slider drives transitions, P-T diagram dot crosses boundaries |
| Heating/cooling changes molecules | Temperature slider + visual speed/spacing changes |
| Volume affects T, P, state | Piston slider → see pressure change, state change |
| P-T diagram | Custom canvas with phase boundaries + live state dot |
| Interatomic potential graphs | LJ potential curve with current avg distance marked |
| Forces from potential | Arrow on LJ graph showing F = -dV/dr at current r |
| LJ parameters (ε, σ) meaning | ε slider → well depth changes on graph. σ slider → zero-crossing shifts. |

### MD Algorithm

```javascript
// Velocity Verlet integration (energy-conserving, better than Euler)
for each particle i:
  // Half-step velocity
  vx[i] += 0.5 * fx[i] / m * dt;
  vy[i] += 0.5 * fy[i] / m * dt;
  // Full-step position
  x[i] += vx[i] * dt;
  y[i] += vy[i] * dt;

// Compute new forces from LJ potential
computeForces();  // O(N²) pair interactions

for each particle i:
  // Complete velocity step
  vx[i] += 0.5 * fx[i] / m * dt;
  vy[i] += 0.5 * fy[i] / m * dt;

// Thermostat: rescale velocities to target temperature
if (thermostatActive) {
  const currentT = computeTemperature();
  const scale = Math.sqrt(targetT / currentT);
  for each particle: vx[i] *= scale; vy[i] *= scale;
}

// Wall collisions (elastic)
for each particle:
  if (x < σ/2) { x = σ/2; vx = -vx; }
  if (x > W - σ/2) { x = W - σ/2; vx = -vx; }
  // same for y
```

### Force Computation (LJ)

```javascript
function computeForces() {
  // Reset forces
  for (let i = 0; i < N; i++) { fx[i] = 0; fy[i] = 0; }

  PE = 0;
  const rc = 2.5 * sigma;  // cutoff distance

  for (let i = 0; i < N - 1; i++) {
    for (let j = i + 1; j < N; j++) {
      const dx = x[j] - x[i], dy = y[j] - y[i];
      const r2 = dx * dx + dy * dy;
      if (r2 > rc * rc) continue;  // skip distant pairs

      const r2inv = sigma * sigma / r2;
      const r6inv = r2inv * r2inv * r2inv;
      const r12inv = r6inv * r6inv;

      // Force magnitude: F = 24ε/r² [ 2(σ/r)¹² − (σ/r)⁶ ] · r̂
      const fMag = 24 * epsilon * (2 * r12inv - r6inv) / r2;

      fx[i] -= fMag * dx;  fy[i] -= fMag * dy;
      fx[j] += fMag * dx;  fy[j] += fMag * dy;

      PE += 4 * epsilon * (r12inv - r6inv);
    }
  }
}
```

### Performance Considerations

- **N² force computation**: With 50 particles = 1225 pairs per step. At 120 steps/sec = 147,000 force calcs/sec. Fast enough for JS.
- **200 particles**: 19,900 pairs × 120 = 2.4M calcs/sec. Still manageable with cutoff.
- **Cell list optimization**: For N > 100, divide box into cells and only check neighboring cells. Reduces to ~O(N).
- **Three.js rendering**: Use InstancedMesh for particles (one draw call for all spheres). Very efficient.

### Three.js Scene Elements

| Element | Geometry | Details |
|---------|----------|---------|
| **Box walls** | LineSegments | Visible container boundary |
| **Piston** | BoxGeometry (right wall, moveable) | Drag to change volume |
| **Particles** | InstancedMesh (SphereGeometry) | One mesh, N instances. Color = speed (blue=slow, red=fast) |
| **Bonds** | Lines between close pairs | Shows molecular bonds in solid/liquid |
| **Heat source/sink** | Glowing bar at bottom of box | Red = heating, blue = cooling, gray = off. Brightness pulses with heat rate. Particles near it speed up (heating) or slow down (cooling). |
| **Thermometer** | Vertical bar on left side | Colored fill (blue→green→red) shows T. Scale labeled with phase transition marks. |
| **Flame/snowflake icon** | Next to heat bar | Flame when heating, snowflake when cooling — instant visual clarity |
| **Heat arrows** | Small animated arrows rising from heat bar | Shows energy flowing into the system |

### Particle Coloring (Speed → Color)

```
Slow (cold) → Blue (#3B82F6)
Medium → Green (#22C55E)
Fast (hot) → Red (#EF4444)
```

This gives instant visual feedback — in a solid, all particles are blue. In a gas, many are red. The color distribution IS the Maxwell-Boltzmann distribution.

### Physics Tests

```javascript
section('MD — LJ Force at Equilibrium r=2^(1/6)σ: F=0');
section('MD — LJ Force Repulsive at r<σ');
section('MD — LJ Force Attractive at r>σ');
section('MD — Temperature from KE: T = 2*KE/(N*kB)');
section('MD — Energy Conservation (no thermostat)');
section('MD — Ideal Gas Law: PV ≈ NkBT at high T');
section('MD — Thermostat Maintains Target Temperature');
section('MD — Velocity Verlet is Time-Reversible');
section('MD — Wall Pressure from Momentum Transfer');
```

### Implementation Order

```
Phase 1: MD engine (pure JS, no rendering)
  - Particle arrays (x, y, vx, vy, fx, fy)
  - LJ force computation with cutoff
  - Velocity Verlet integration
  - Wall collisions (elastic)
  - Temperature computation
  - Thermostat (velocity rescaling)
  - All physics tests passing

Phase 2: Three.js scene
  - InstancedMesh for particles (color by speed)
  - Box walls
  - Piston (draggable)
  - Heat slider visual indicator

Phase 3: Graphs
  - P-T diagram (custom canvas) with phase boundaries
  - LJ potential curve (custom canvas) with current avg r
  - Energy graph (TimeGraph: KE, PE, Total)
  - Time graph (Temperature, Pressure vs time)

Phase 4: Controls + presets
  - Temperature, volume, molecule type, N particles
  - ε and σ manual sliders
  - Heat rate slider
  - Phase presets (solid/liquid/gas/melting/boiling)
  - Settings panel

Phase 5: Polish
  - Particle bonds (lines between close pairs)
  - Speed-based coloring (Maxwell-Boltzmann visual)
  - Gravity option
  - Molecule-specific behavior (diatomic O₂, hydrogen bonds)
  - Share link
```

---

## Resonance Simulation — Three.js (PLAN)

### The Physics: Driven Damped Harmonic Oscillator

```
m·x'' + b·x' + k·x = F₀·cos(ω_d·t)
```

| Symbol | Meaning |
|--------|---------|
| `x` | Displacement from equilibrium |
| `m` | Mass of the oscillator |
| `b` | Damping coefficient |
| `k` | Spring stiffness |
| `F₀` | Drive force amplitude |
| `ω_d` | Drive (forcing) frequency |
| `ω₀ = √(k/m)` | **Natural frequency** — the frequency the system "wants" to oscillate at |

**Steady-state solution** (after transient dies out):

```
A(ω_d) = (F₀/m) / √( (ω₀² - ω_d²)² + (2γω_d)² )     where γ = b/(2m)

φ(ω_d) = arctan( 2γω_d / (ω₀² - ω_d²) )
```

**At resonance** (`ω_d ≈ ω₀`): amplitude peaks, phase crosses −90°.

**Resonance frequency** (exact peak): `ω_r = √(ω₀² − 2γ²)` (shifts slightly below ω₀ with damping).

### State Variables

```javascript
// State: [x, v, time]
// x = displacement of mass from equilibrium
// v = velocity of mass

evaluate(vars, change, params) {
  const [x, v, t] = vars;
  const { mass, stiffness, damping, driveAmp, driveFreq } = params;
  const omega0sq = stiffness / mass;
  const gamma = damping / (2 * mass);
  const drive = driveAmp * Math.cos(driveFreq * t);

  change[0] = v;                                    // dx/dt = v
  change[1] = -omega0sq * x - 2 * gamma * v + drive / mass;  // dv/dt
  change[2] = 1;                                    // dt/dt = 1
}
```

### Learning Goals → Features

| Learning Goal | Sim Feature |
|---------------|-------------|
| **Explain conditions for resonance** | Frequency response curve shows peak when ω_d = ω₀. Student drags ω_d slider and watches amplitude explode. |
| **Variables affecting natural frequency** | Sliders for mass (m) and stiffness (k). Changing either shifts the resonance peak on the frequency curve. `ω₀ = √(k/m)` shown live. |
| **Driving vs natural frequency** | Two separate sliders. ω₀ shown as a vertical dashed line on the frequency curve. ω_d shown as a moving dot on the curve. |
| **Transient vs steady-state** | Time graph shows initial wild oscillation (transient) that gradually settles into smooth sinusoidal (steady-state). A "transient zone" shaded region fades away. |
| **Variables affecting transient duration** | Damping slider. Low damping → long transient (takes many cycles to settle). High damping → short transient. Student measures the settling time. |
| **Phase relationship** | Phase graph (φ vs ω_d) shown alongside amplitude graph. Below resonance: phase ≈ 0 (in sync). At resonance: phase = −90° (quarter cycle lag). Above resonance: phase → −180° (anti-phase). Color-coded on the 3D spring. |
| **Real-world examples** | Presets: "Wine glass" (high Q, narrow peak), "Car suspension" (critically damped), "Tacoma Narrows" (catastrophic resonance), "Tuning fork" (sharp resonance), "Earthquake building" (structural resonance). |

### Three.js Scene Design

```
Side view of the 3D scene:

    ┌──────────┐
    │  DRIVER  │  ← oscillating platform (moves up/down at ω_d)
    │  MOTOR   │
    └──┤    ├──┘
       │╲╱╲╱│    ← spring (stretches/compresses, coils visible)
       │╱╲╱╲│
       │╲╱╲╱│
    ┌──┴────┴──┐
    │   MASS   │  ← block (bobs up/down, amplitude depends on resonance)
    └──────────┘
         ↕
    ← equilibrium reference line (dashed) →
         ↕
    ← amplitude markers (current A shown) →

    ─────────────────── ground reference
```

**3D elements:**

| Element | Geometry | Behavior |
|---------|----------|----------|
| **Support frame** | BoxGeometry bracket, mounted to "ceiling" | Static — anchor point |
| **Driver platform** | BoxGeometry, attached to frame | Oscillates vertically at `y₀ · cos(ω_d · t)`. Visible motor arm/crank. |
| **Spring** | Custom coil (parametric helix or zigzag) | Stretches between driver and mass. Coil spacing changes with extension. Color shifts red when stretched, blue when compressed. |
| **Mass block** | BoxGeometry with edge wireframe | Bobs vertically. Size scales with mass parameter. Color from object catalog. |
| **Equilibrium line** | Dashed horizontal line | Fixed at natural rest position. Shows how far the mass deviates. |
| **Amplitude marker** | Two horizontal lines (±A) | Track the current steady-state amplitude. Pulse when near resonance. |
| **Phase indicator** | Arc between driver position and mass position | Visual angle showing phase lag. Fills −90° at resonance. |
| **Ground/base** | PlaneGeometry | Reference surface with grid |

**The spring is the visual hero.** At resonance it stretches dramatically — the student can *see* the energy being pumped in. Away from resonance, the spring barely moves.

### Camera

```javascript
camera.position.set(4, 3, 8);     // 3/4 view, spring visible from the side
orbit.target.set(0, -1, 0);       // centered on the mass equilibrium
```

### Graph Tabs (5 views)

| Tab | Graph Type | What It Shows |
|-----|-----------|---------------|
| **Sim** | 3D scene only | Full-width Three.js view |
| **Time** | TimeGraph | x(t) displacement — shows transient → steady-state. Driver signal as faint overlay. |
| **Frequency** | Custom canvas | **Amplitude response curve**: A vs ω_d. Current ω_d marked with vertical line + dot. Resonance peak labeled. Multiple damping curves overlaid (toggle). |
| **Phase** | Custom canvas | **Phase response curve**: φ vs ω_d. Shows the −90° crossover at resonance. Color-coded: green (in-phase) → yellow (−90°) → red (anti-phase). |
| **Energy** | EnergyBar | KE + PE + dissipated. At resonance, the average energy is max. Dissipation rate = power input from driver. |

### The Frequency Response Graph — The Key Educational View

This is the **star feature** — not a standard TimeGraph but a custom canvas showing the resonance curve.

```
  Amplitude
  │
  │           ╱╲        ← resonance peak
  │          ╱  ╲
  │    ─────╱    ╲───── ← low damping (sharp peak, high Q)
  │   ╱──────────────╲  ← medium damping
  │  ╱────────────────╲ ← high damping (flat, broad)
  │╱                    ╲
  └──────────┼──────────── ω_d
             ω₀
             ↑
        natural frequency (dashed vertical line)

  ● = current driving frequency (draggable!)
```

**Interactive**: the student can **click and drag the dot** on the resonance curve to change ω_d. The 3D scene updates in real-time. Dragging through the resonance peak → the 3D mass starts bouncing wildly.

**Multi-curve overlay**: toggle checkboxes to show curves for different damping values simultaneously. This teaches why damping broadens and lowers the peak.

**Analytical curves** drawn from the exact formula:
```javascript
function amplitudeResponse(omega_d, omega0, gamma, F0, m) {
  const denom = Math.sqrt((omega0*omega0 - omega_d*omega_d)**2 + (2*gamma*omega_d)**2);
  return (F0 / m) / denom;
}
```

### The Phase Graph

```
  Phase (°)
    0° ─────────╲
                  ╲
  −90° ─ ─ ─ ─ ─ ─●─ ─ ─ ─ ─   ← exactly −90° at resonance
                    ╲
 −180° ──────────────╲─────────
  └──────────────┼──────────── ω_d
                 ω₀
```

Color-coded background: green zone (0° to −45°) → yellow zone (−45° to −135°) → red zone (−135° to −180°). The student sees the phase "flip" as they sweep through resonance.

### Parameters

| Param | Range | Default | Unit | What It Teaches |
|-------|-------|---------|------|-----------------|
| Mass (m) | 0.1 – 10 | 1.0 | kg | Changes ω₀ = √(k/m). Heavier → lower natural freq |
| Stiffness (k) | 0.5 – 50 | 10 | N/m | Changes ω₀. Stiffer → higher natural freq |
| Damping (b) | 0 – 5 | 0.5 | Ns/m | Controls peak height and width. 0 = infinite amplitude at resonance |
| Drive Amplitude (F₀) | 0 – 20 | 5 | N | Scales the whole response curve proportionally |
| Drive Frequency (ω_d) | 0.1 – 10 | 2.0 | rad/s | **THE main control.** Sweeping this through ω₀ = key learning moment |
| Drive Frequency (via graph drag) | same | same | | Click the resonance curve to set ω_d interactively |
| Show Transient | checkbox | on | | When off, skip to steady-state instantly (analytical solution) |

**Derived values shown in readout:**
```
ω₀ = 3.16 rad/s  |  f₀ = 0.503 Hz  |  T₀ = 1.99 s  |  Q = 3.16
ω_d = 3.00 rad/s |  A_steady = 2.4 m  |  φ = −72°  |  transient settling...
```

### Presets (Real-World Scenarios)

| Preset | Settings | What It Teaches |
|--------|----------|-----------------|
| **Default** | m=1, k=10, b=0.5, F₀=5, ω_d=ω₀ | Resonance right away — "whoa, it's huge!" |
| **Sweep** | Same but ω_d starts at 0.5 and auto-sweeps to 6 | Watch amplitude grow → peak → shrink. The "aha" moment. |
| **No Damping** | b=0, ω_d=ω₀ | Amplitude grows without bound! (Capped visually.) Shows why damping matters. |
| **Heavy Damping** | b=4 | Barely resonates. Flat response curve. Like a car shock absorber. |
| **Wine Glass** | High k, very low b (Q≈50) | Extremely sharp resonance peak. Singer hits the right frequency → glass shatters. |
| **Tacoma Narrows** | Moderate Q, ω_d slowly approaching ω₀ | Dramatic amplitude growth. Bridge analogy — catastrophic resonance. |
| **Earthquake** | Random drive (not pure cosine but noise filtered around ω₀) | Shows that even broadband forcing near ω₀ causes resonance. Building sway. |
| **Tuning Fork** | Very high Q, very low damping | Nearly pure tone. Rings for a long time. Narrow peak. |
| **Off-Resonance** | ω_d = 2·ω₀ | Almost no response. Same force, wrong frequency. |

### Special Feature: Frequency Sweep Mode

A **"Sweep"** button slowly ramps ω_d from 0 to 2·ω₀ over ~20 seconds while the sim runs. The student watches:

1. Low ω_d: mass barely moves (far below resonance)
2. ω_d approaches ω₀: amplitude grows
3. ω_d = ω₀: **maximum amplitude** — spring stretches dramatically, mass oscillates wildly
4. ω_d passes ω₀: amplitude drops, phase flips
5. High ω_d: mass barely moves again (far above resonance)

On the frequency response graph, a dot traces along the curve in real-time during the sweep.

### Special Feature: Transient → Steady-State Visualization

When drive starts (or ω_d changes):

1. **Transient phase**: The response is a mess — natural frequency and driving frequency both present, beating pattern visible
2. **Settling**: Exponential decay of the transient component (rate = γ = b/2m)
3. **Steady-state**: Pure sinusoidal at the driving frequency

On the time graph, the transient zone is highlighted with a fading orange background. A label shows "Transient" → "Settling..." → "Steady-state ✓". The duration depends on damping — student can increase damping and watch the transient zone shrink.

### Phase Visualization on the 3D Scene

The 3D scene shows phase lag visually:

```
Driver:  ↕ (oscillating at top)
Mass:    ↕ (oscillating at bottom, LAGGING by φ)
```

Two colored dots:
- **Green dot** tracks the driver position vertically
- **Purple dot** tracks the mass position vertically
- An **arc** between them shows the phase angle
- At resonance: the arc is exactly 90° (quarter cycle)
- Below resonance: nearly in sync (small arc)
- Above resonance: nearly anti-phase (arc ≈ 180°)

### Q Factor (Quality Factor)

```
Q = ω₀ / (2γ) = √(km) / b
```

The Q factor is shown in the readout and on the frequency response curve:
- **High Q** (>10): sharp tall peak, narrow bandwidth, long ring time
- **Low Q** (<1): broad flat curve, heavily damped, quick settling
- **Q = 0.5**: critically damped — no oscillation at all

The resonance curve width at half-max = ω₀/Q. This is labeled on the graph.

### Energy at Resonance

At steady-state resonance, the driver pumps energy in at exactly the rate that damping dissipates it:

```
Power_input = Power_dissipated = b · ω_d² · A² / 2
```

The energy graph shows:
- KE and PE oscillating in anti-phase (like a regular oscillator)
- But the **average total energy** is maximal at resonance
- The dissipation rate (shown as a dashed line) matches the input rate

### File Structure

```
physics/labs/
├── resonance.jsp                    # JSP page
├── js/sims/resonance.js             # Three.js sim (standalone, ~800 lines)
├── js/canvas/freq-response.js       # Custom frequency response graph (NEW module)
└── js/canvas/phase-response.js      # Custom phase response graph (NEW module)
```

The frequency and phase response graphs are **new canvas modules** (not TimeGraph or EnergyBar). They plot analytical curves and overlay the current operating point.

### Implementation Order

```
Phase 1: Physics + 3D scene
  - resonance.js: evaluate function, Euler integration
  - Three.js scene: frame, driver, spring, mass, ground
  - Spring coil rendering (parametric helix or zigzag)
  - Driver animation (platform oscillates)
  - Mass response (physics-driven position)

Phase 2: Controls + basic graphs
  - Sidebar: mass, stiffness, damping, drive amp, drive freq sliders
  - Time graph tab (displacement vs time)
  - Energy graph tab (KE/PE/dissipated)
  - Readout (ω₀, Q, A_steady, phase)

Phase 3: Frequency & phase response graphs (the star features)
  - freq-response.js: analytical resonance curve
  - phase-response.js: analytical phase curve
  - Draggable operating point on frequency curve → sets ω_d
  - Multi-damping overlay toggle
  - Q and bandwidth labels

Phase 4: Polish + special features
  - Frequency sweep mode (auto-ramp ω_d)
  - Transient highlighting on time graph
  - Phase arc visualization on 3D scene
  - Spring color shift (stretch=red, compress=blue)
  - Real-world presets (wine glass, Tacoma Narrows, etc.)

Phase 5: Tests
  - Analytical steady-state amplitude vs numerical simulation
  - Phase angle verification at ω₀
  - Energy conservation check
  - Q factor = ω₀/(2γ) matches measured bandwidth
  - Transient decay rate = γ
```

### Key Mathematical Tests to Write

```javascript
section('Resonance — Natural Frequency');
// ω₀ = √(k/m). With k=10, m=1: ω₀ = √10 ≈ 3.162
// Simulate with no drive, verify period = 2π/ω₀

section('Resonance — Amplitude at Resonance');
// A(ω₀) = F₀ / (2mγω₀) = F₀ / (b·ω₀)
// With F₀=5, b=0.5, ω₀=√10: A = 5/(0.5·√10) ≈ 3.16
// Run sim to steady state, measure amplitude

section('Resonance — Phase at ω₀ = −90°');
// At resonance, displacement lags driving force by exactly π/2
// Measure phase in steady state

section('Resonance — Off-Resonance Amplitude');
// At ω_d = 2ω₀, amplitude should be much smaller
// A(2ω₀) from formula ≈ 0.37 (with same params)

section('Resonance — Transient Decay Rate');
// Transient envelope decays as exp(−γt) where γ = b/(2m)
// Measure envelope after N cycles, compare to exp(−γ·N·T)

section('Resonance — Energy Balance at Steady State');
// Average KE = Average PE (virial theorem for SHM)
// Power in from driver = power dissipated by damping

section('Resonance — Q Factor');
// Q = ω₀/(2γ). Verify: Q matches the number of cycles to decay to 1/e in free oscillation
```

---

## Future: Matter.js Playground Sims (Rigid Body)

> **Status**: PLANNED — not started. Low priority. Build when the core engine sims are complete.

### Why Matter.js?

Our custom engine (Verlet/RK4 + evaluate pattern) is perfect for **equation-driven** sims where students need to see the math: pendulums, springs, waves, molecular dynamics. But some physics topics are about **rigid body collisions, structural mechanics, and mechanisms** — topics where the educational value is in *seeing what happens*, not deriving the ODE. Matter.js (2D rigid body engine, MIT license) handles these well.

### Reference
- Demo: `/Users/anish/junk/matterjs-physics-demo` (bouncing balls + accelerometer)
- Library: `matter-js` v0.19+ via CDN (`https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js`)
- License: MIT

### When to use Matter.js vs our engine

| Use Matter.js | Use our engine |
|---------------|---------------|
| Many rigid bodies colliding | Few bodies with known equations |
| Structural failure / breakage | ODE-based motion (pendulum, spring) |
| User-built contraptions | Molecular / particle simulations |
| Mechanisms (gears, linkages) | Wave physics, E&M |
| The lesson is "what happens" | The lesson is "why it happens (the equation)" |

### Candidate Sims

#### 1. Rube Goldberg / Chain Reaction Builder
- **Concept**: Students drag-and-drop parts (ramps, dominoes, seesaws, balls, buckets, springs, fans) onto a canvas and build a chain reaction machine. Press play → watch it unfold.
- **Physics taught**: Energy transfer, momentum, mechanical advantage, friction
- **Matter.js value**: Handles all rigid body collisions, constraints, composite bodies
- **Interaction**: Drag parts from a palette, rotate/resize, connect with joints. Play/pause/reset.
- **Presets**: "Domino Rally", "Ball Run", "Egg Drop Challenge"

#### 2. Bridge Builder / Structural Load Test
- **Concept**: Build a bridge from beams and joints. Apply a load (truck drives across). See which beams are in tension (blue) vs compression (red). Overload → beams snap.
- **Physics taught**: Structural mechanics, tension/compression, load distribution, failure modes
- **Matter.js value**: Constraints as beams, breaking threshold on constraint force
- **Interaction**: Click to place joints, drag between joints to add beams. Slider for load weight.
- **Presets**: "Simple Truss", "Suspension", "Cantilever"

#### 3. Stacking & Balance
- **Concept**: Stack blocks of different shapes/masses. Find center of mass. Tip the platform. Which stack survives?
- **Physics taught**: Center of mass, torque, equilibrium, friction
- **Matter.js value**: Realistic stacking with friction, toppling
- **Interaction**: Drag shapes onto a platform. Tilt slider. "Earthquake" button (random shake).
- **Presets**: "Pyramid", "Tall Tower", "Arch", "Balancing Act"

#### 4. Simple Machines Sandbox
- **Concept**: Levers, pulleys (visual), wedges, wheel-and-axle, inclined planes — all as draggable rigid bodies. Attach weights, see mechanical advantage in action.
- **Physics taught**: Mechanical advantage, work, IMA vs AMA, efficiency
- **Matter.js value**: Constraints for pivots, composite bodies for wheels
- **Interaction**: Drag fulcrum position, attach masses, measure force needed
- **Presets**: "Class 1 Lever", "Wheel and Axle", "Wedge Split"

#### 5. Projectile Destruction (Angry Birds style)
- **Concept**: Launch a projectile at a structure. Structure collapses realistically.
- **Physics taught**: Projectile motion, momentum transfer, structural integrity
- **Matter.js value**: Realistic debris, structural collapse
- **Interaction**: Drag slingshot, aim angle/power, launch. Build your own target.
- **Presets**: "Tower", "Wall", "Bridge Target"

### Integration Pattern

Matter.js sims would use a **different JSP template** than the engine sims, since they don't use our evaluate/render pattern:

```
physics/labs/
  js/
    sims/           ← our engine sims (pendulum.js, spring.js, etc.)
    playground/     ← Matter.js sims (rube-goldberg.js, bridge.js, etc.)
  rube-goldberg.jsp
  bridge-builder.jsp
```

Each Matter.js sim would still use `labs.css` for consistent styling, and include the same nav/breadcrumb/footer. The canvas setup differs: Matter.js creates its own `Render` canvas, so the JSP provides a container div instead of a `<canvas>` element.

### Accelerometer Support
The reference demo shows accelerometer-based gravity (tilt phone → gravity direction changes). This is a great feature for ALL Matter.js playground sims — especially stacking and Rube Goldberg. Implementation:
```js
window.addEventListener('deviceorientation', (e) => {
  engine.world.gravity.x = e.gamma * scale;
  engine.world.gravity.y = e.beta * scale;
});
```
With iOS permission request for `DeviceOrientationEvent.requestPermission()`.

### Priority Order
1. **Rube Goldberg** — highest engagement, most shareable, showcases Matter.js best
2. **Stacking & Balance** — simple to build, strong physics concept
3. **Bridge Builder** — moderate complexity, great educational value
4. **Simple Machines** — fills a curriculum gap
5. **Projectile Destruction** — fun but less educational
