/**
 * Navier-Stokes Fluid Simulator — 2D Incompressible Flow
 *
 * Simulates air flow in a room with a fan using the full
 * incompressible Navier-Stokes equations:
 *
 *   ∂u/∂t + (u·∇)u = -∇p/ρ + ν∇²u
 *   ∇·u = 0
 *
 * Solver: Fractional-step (operator splitting)
 *   1. Advection (upwind finite differences)
 *   2. Viscosity (central Laplacian)
 *   3. Pressure (Jacobi iterative Poisson solver)
 *   4. Velocity correction (pressure gradient)
 *
 * Grid: Arakawa C-type staggered grid
 *   - ux offset in x, uy offset in y, pressure at cell centers
 *
 * State: stores entire velocity + pressure fields internally.
 * The "vars" array exposed to the lab engine is a thin proxy:
 *   [maxSpeed, avgSpeed, time]
 *
 * Rendering: draws directly on the sim canvas —
 *   arrows (quiver) or particles, colored by speed.
 */

const RHO = 1.293;       // air density (kg/m³)
const MU  = 1.82e-5;     // dynamic viscosity (Pa·s)
const NU  = MU / RHO;    // kinematic viscosity

export const NavierStokesSim = {
  name: 'Fluid Flow (Navier-Stokes)',
  slug: 'navier-stokes',
  category: 'Fluids',

  vars: {
    maxSpeed: { index: 0, label: 'Max speed (m/s)',  symbol: 'v_max' },
    avgSpeed: { index: 1, label: 'Avg speed (m/s)',  symbol: 'v_avg' },
    time:     { index: 2, label: 'Time (s)',          symbol: 't' },
  },
  varCount: 3,

  params: {
    fanSpeed:  { value: 5,   min: 0.5, max: 20,  step: 0.5, label: 'Fan Speed',    unit: 'm/s' },
    fanAngle:  { value: 0,   min: -80, max: 80,   step: 5,   label: 'Fan Angle',    unit: '°' },
    roomW:     { value: 4.0, min: 2,   max: 8,    step: 0.5, label: 'Room Width',   unit: 'm' },
    roomH:     { value: 2.0, min: 1,   max: 4,    step: 0.5, label: 'Room Height',  unit: 'm' },
    viscosity: { value: 1.0, min: 0.1, max: 10,   step: 0.1, label: 'Viscosity ×',  unit: '' },
    showMode:  { value: 0,   min: 0,   max: 1,    step: 1,   label: 'View (0=arrows 1=particles)', unit: '' },
  },

  views: ['sim', 'time'],
  graphDefaults: { time: ['maxSpeed', 'avgSpeed'] },

  worldRect: { xMin: 0, xMax: 4, yMin: 0, yMax: 2 },

  presets: [
    { name: 'Gentle Breeze',       params: { fanSpeed: 3, fanAngle: 0 } },
    { name: 'Strong Jet',          params: { fanSpeed: 15, fanAngle: 0 } },
    { name: 'Angled Down (30°)',   params: { fanSpeed: 8, fanAngle: -30 } },
    { name: 'Angled Up (45°)',     params: { fanSpeed: 8, fanAngle: 45 } },
    { name: 'High Viscosity',      params: { fanSpeed: 10, viscosity: 5 } },
    { name: 'Low Viscosity',       params: { fanSpeed: 10, viscosity: 0.2 } },
    { name: 'Wide Room',           params: { roomW: 8, roomH: 3, fanSpeed: 10 } },
  ],

  // ── Internal fluid state ──
  _nx: 0, _ny: 0,
  _dx: 0.1, _dy: 0.1,
  _dt: 0.02,
  _ux: null, _uy: null, _p: null,
  _particles: null,
  _initialized: false,

  _initField(p) {
    this._dx = 0.1;
    this._dy = 0.1;
    this._nx = Math.round(p.roomW / this._dx);
    this._ny = Math.round(p.roomH / this._dy);
    const nx = this._nx, ny = this._ny;

    // Staggered grid: ux has (nx+3)×(ny+2), uy has (nx+2)×(ny+3)
    this._ux = new Float64Array((nx + 3) * (ny + 2));
    this._uy = new Float64Array((nx + 2) * (ny + 3));
    this._p  = new Float64Array((nx + 2) * (ny + 2));

    // Particles for visualization
    this._particles = [];
    for (let i = 0; i < 2000; i++) {
      this._particles.push({
        x: Math.random() * p.roomW,
        y: Math.random() * p.roomH,
      });
    }
    this._initialized = true;
  },

  // Array access helpers (row-major)
  _uxIdx(i, j) { return i * (this._ny + 2) + j; },
  _uyIdx(i, j) { return i * (this._ny + 3) + j; },
  _pIdx(i, j)  { return i * (this._ny + 2) + j; },

  _getUx(i, j) { return this._ux[this._uxIdx(i, j)]; },
  _setUx(i, j, v) { this._ux[this._uxIdx(i, j)] = v; },
  _getUy(i, j) { return this._uy[this._uyIdx(i, j)]; },
  _setUy(i, j, v) { this._uy[this._uyIdx(i, j)] = v; },
  _getP(i, j)  { return this._p[this._pIdx(i, j)]; },
  _setP(i, j, v) { this._p[this._pIdx(i, j)] = v; },

  init(p) {
    this._initField(p);
    this._maxV = 0;
    this._avgV = 0;
    return [0, 0, 0];
  },

  // NS has its own internal time integration; evaluate only advances the clock
  evaluate(vars, change, params, isDragging) {
    change[2] = 1; // dt/dt = 1
    // Stats are set directly by _stepNS via postStep
    change[0] = (this._maxV - vars[0]) * 10;
    change[1] = (this._avgV - vars[1]) * 10;
  },

  // Called once per committed timestep — runs the actual NS solver
  postStep(vars, params) {
    if (!this._initialized) this._initField(params);
    this._stepNS(params);
  },

  /** Run one full Navier-Stokes timestep */
  _stepNS(params) {
    const nx = this._nx, ny = this._ny;
    const dx = this._dx, dy = this._dy;
    const nu = NU * params.viscosity;
    const v0 = params.fanSpeed;
    const theta = params.fanAngle * Math.PI / 180;

    // Adaptive CFL: dt ≤ 0.5 * dx / max_velocity
    const dt = Math.min(this._dt, 0.4 * dx / Math.max(this._maxV, 1));

    // Helper to read from a Float64Array with ux/uy indexing
    const uxA = this._ux, uyA = this._uy;
    const uxI = (i, j) => i * (ny + 2) + j;
    const uyI = (i, j) => i * (ny + 3) + j;

    // ── Step 0: Boundary conditions (no-slip walls) + fan ──
    this._applyBoundary(nx, ny, v0, theta);

    // ── Step 1: Advection (upwind) ──
    const ux_ast = new Float64Array(uxA.length);
    const uy_ast = new Float64Array(uyA.length);

    for (let i = 1; i < nx + 2; i++) {
      for (let j = 1; j < ny + 1; j++) {
        const vx = uxA[uxI(i, j)];
        const vy = (uyA[uyI(i, j)] + uyA[uyI(i - 1, j)] + uyA[uyI(i, j + 1)] + uyA[uyI(i - 1, j + 1)]) / 4;
        const advX = vx >= 0 ? vx * (uxA[uxI(i, j)] - uxA[uxI(i - 1, j)]) / dx
                              : vx * (uxA[uxI(i + 1, j)] - uxA[uxI(i, j)]) / dx;
        const advY = vy >= 0 ? vy * (uxA[uxI(i, j)] - uxA[uxI(i, j - 1)]) / dy
                              : vy * (uxA[uxI(i, j + 1)] - uxA[uxI(i, j)]) / dy;
        ux_ast[uxI(i, j)] = uxA[uxI(i, j)] - dt * (advX + advY);
      }
    }
    for (let i = 1; i < nx + 1; i++) {
      for (let j = 1; j < ny + 2; j++) {
        const vx = (uxA[uxI(i, j)] + uxA[uxI(i, j - 1)] + uxA[uxI(i + 1, j)] + uxA[uxI(i + 1, j - 1)]) / 4;
        const vy = uyA[uyI(i, j)];
        const advX = vx >= 0 ? vx * (uyA[uyI(i, j)] - uyA[uyI(i - 1, j)]) / dx
                              : vx * (uyA[uyI(i + 1, j)] - uyA[uyI(i, j)]) / dx;
        const advY = vy >= 0 ? vy * (uyA[uyI(i, j)] - uyA[uyI(i, j - 1)]) / dy
                              : vy * (uyA[uyI(i, j + 1)] - uyA[uyI(i, j)]) / dy;
        uy_ast[uyI(i, j)] = uyA[uyI(i, j)] - dt * (advX + advY);
      }
    }

    // ── Step 2: Viscosity (Laplacian of ux_ast, NOT old ux) ──
    for (let i = 1; i < nx + 2; i++) {
      for (let j = 1; j < ny + 1; j++) {
        const idx = uxI(i, j);
        const lap = (ux_ast[uxI(i + 1, j)] - 2 * ux_ast[idx] + ux_ast[uxI(i - 1, j)]) / (dx * dx)
                  + (ux_ast[uxI(i, j + 1)] - 2 * ux_ast[idx] + ux_ast[uxI(i, j - 1)]) / (dy * dy);
        ux_ast[idx] += nu * lap;
      }
    }
    for (let i = 1; i < nx + 1; i++) {
      for (let j = 1; j < ny + 2; j++) {
        const idx = uyI(i, j);
        const lap = (uy_ast[uyI(i + 1, j)] - 2 * uy_ast[idx] + uy_ast[uyI(i - 1, j)]) / (dx * dx)
                  + (uy_ast[uyI(i, j + 1)] - 2 * uy_ast[idx] + uy_ast[uyI(i, j - 1)]) / (dy * dy);
        uy_ast[idx] += nu * lap;
      }
    }

    // ── Step 3: Poisson pressure solve (Jacobi) ──
    const pNy = ny + 2;
    const pI = (i, j) => i * pNy + j;
    const div = new Float64Array((nx + 2) * pNy);
    for (let i = 0; i < nx + 1; i++) {
      for (let j = 0; j < ny + 1; j++) {
        // RHS includes RHO for correct pressure dimensions
        div[pI(i, j)] = RHO * ((ux_ast[uxI(i + 1, j)] - ux_ast[uxI(i, j)]) / dx
                              + (uy_ast[uyI(i, j + 1)] - uy_ast[uyI(i, j)]) / dy) / dt;
      }
    }

    const cnst = (dx * dy) * (dx * dy) * 0.5 / (dx * dx + dy * dy);
    const pArr = this._p;
    const pNew = new Float64Array(pArr.length);
    for (let iter = 0; iter < 50; iter++) {
      for (let i = 1; i < nx + 1; i++) {
        for (let j = 1; j < ny + 1; j++) {
          pNew[pI(i, j)] = (
            (pArr[pI(i + 1, j)] + pArr[pI(i - 1, j)]) / (dx * dx) +
            (pArr[pI(i, j + 1)] + pArr[pI(i, j - 1)]) / (dy * dy) -
            div[pI(i, j)]
          ) * cnst;
        }
      }
      pArr.set(pNew);
    }

    // ── Step 4: Velocity correction ──
    for (let i = 1; i < nx + 2; i++) {
      for (let j = 1; j < ny + 1; j++) {
        uxA[uxI(i, j)] = ux_ast[uxI(i, j)] - (pArr[pI(i, j)] - pArr[pI(i - 1, j)]) * dt / (dx * RHO);
      }
    }
    for (let i = 1; i < nx + 1; i++) {
      for (let j = 1; j < ny + 2; j++) {
        uyA[uyI(i, j)] = uy_ast[uyI(i, j)] - (pArr[pI(i, j)] - pArr[pI(i, j - 1)]) * dt / (dy * RHO);
      }
    }

    // ── Step 5: Re-apply boundary conditions after correction ──
    this._applyBoundary(nx, ny, v0, theta);

    // ── Update particles (bilinear interpolation) ──
    if (this._particles) {
      for (const pt of this._particles) {
        const fx = pt.x / dx, fy = pt.y / dy;
        const ci = Math.max(1, Math.min(nx - 1, Math.floor(fx) + 1));
        const cj = Math.max(1, Math.min(ny - 1, Math.floor(fy) + 1));
        const tx = fx - (ci - 1), ty = fy - (cj - 1);
        // Bilinear interpolation of cell-centered velocity
        const vx00 = (uxA[uxI(ci, cj)] + uxA[uxI(ci + 1, cj)]) / 2;
        const vx10 = (uxA[uxI(ci + 1, cj)] + uxA[uxI(ci + 2, cj)]) / 2;
        const vx01 = (uxA[uxI(ci, cj + 1)] + uxA[uxI(ci + 1, cj + 1)]) / 2;
        const vx11 = (uxA[uxI(ci + 1, cj + 1)] + uxA[uxI(ci + 2, cj + 1)]) / 2;
        const vx = vx00 * (1 - tx) * (1 - ty) + vx10 * tx * (1 - ty) + vx01 * (1 - tx) * ty + vx11 * tx * ty;
        const vy00 = (uyA[uyI(ci, cj)] + uyA[uyI(ci, cj + 1)]) / 2;
        const vy10 = (uyA[uyI(ci + 1, cj)] + uyA[uyI(ci + 1, cj + 1)]) / 2;
        const vy01 = (uyA[uyI(ci, cj + 1)] + uyA[uyI(ci, cj + 2)]) / 2;
        const vy11 = (uyA[uyI(ci + 1, cj + 1)] + uyA[uyI(ci + 1, cj + 2)]) / 2;
        const vy = vy00 * (1 - tx) * (1 - ty) + vy10 * tx * (1 - ty) + vy01 * (1 - tx) * ty + vy11 * tx * ty;
        pt.x += vx * dt;
        pt.y += vy * dt;
        if (pt.x < 0.01 || pt.x > params.roomW - 0.01 || pt.y < 0.01 || pt.y > params.roomH - 0.01) {
          pt.x = Math.random() * params.roomW * 0.9 + params.roomW * 0.05;
          pt.y = Math.random() * params.roomH * 0.9 + params.roomH * 0.05;
        }
      }
    }

    // ── Compute stats ──
    let maxV = 0, sumV = 0, cnt = 0;
    for (let i = 1; i < nx + 1; i++) {
      for (let j = 1; j < ny + 1; j++) {
        const vxc = (uxA[uxI(i, j)] + uxA[uxI(i + 1, j)]) / 2;
        const vyc = (uyA[uyI(i, j)] + uyA[uyI(i, j + 1)]) / 2;
        const spd = Math.sqrt(vxc * vxc + vyc * vyc);
        if (spd > maxV) maxV = spd;
        sumV += spd;
        cnt++;
      }
    }
    this._maxV = maxV;
    this._avgV = cnt > 0 ? sumV / cnt : 0;
  },

  /** Apply no-slip walls + fan boundary conditions */
  _applyBoundary(nx, ny, v0, theta) {
    // Walls: ux = 0 on all boundaries
    for (let i = 0; i < nx + 3; i++) { this._setUx(i, 0, 0); this._setUx(i, ny + 1, 0); }
    for (let j = 0; j < ny + 2; j++) { this._setUx(0, j, 0); this._setUx(1, j, 0); this._setUx(nx + 1, j, 0); this._setUx(nx + 2, j, 0); }
    // Walls: uy = 0 on all boundaries
    for (let j = 0; j < ny + 3; j++) { this._setUy(0, j, 0); this._setUy(nx + 1, j, 0); }
    for (let i = 0; i < nx + 2; i++) { this._setUy(i, 0, 0); this._setUy(i, 1, 0); this._setUy(i, ny + 1, 0); this._setUy(i, ny + 2, 0); }
    // Fan: left wall, middle cells
    const fanY1 = Math.floor(ny * 0.35);
    const fanY2 = Math.ceil(ny * 0.65);
    for (let j = fanY1; j <= fanY2; j++) {
      this._setUx(1, j, v0 * Math.cos(theta));
      this._setUy(1, j, v0 * Math.sin(theta)); // Fix: i=1 not i=0
    }
  },

  energy(vars) {
    return { kinetic: vars[0], potential: 0, total: vars[0] };
  },

  hitTest() { return null; },
  onDrag() {},
  onRelease() {},

  render(canvas, vars, params) {
    if (!this._initialized) return;
    const nx = this._nx, ny = this._ny;
    const dx = this._dx, dy = this._dy;
    const rw = params.roomW, rh = params.roomH;
    const showParticles = params.showMode >= 0.5;

    // ── Room outline ──
    canvas.line(0, 0, rw, 0, '#475569', 2);
    canvas.line(rw, 0, rw, rh, '#475569', 2);
    canvas.line(rw, rh, 0, rh, '#475569', 2);
    canvas.line(0, rh, 0, 0, '#475569', 2);

    // ── Fan indicator ──
    const fanY1 = rh * 0.35, fanY2 = rh * 0.65;
    canvas.line(-0.05, fanY1, -0.05, fanY2, '#06B6D4', 4);
    const theta = params.fanAngle * Math.PI / 180;
    const aLen = 0.3;
    const fanMidY = (fanY1 + fanY2) / 2;
    canvas.line(0, fanMidY, aLen * Math.cos(theta), fanMidY + aLen * Math.sin(theta), '#22C55E', 2);

    if (showParticles) {
      // ── Particle view (simple nearest-cell for render only — bilinear used for advection) ──
      if (this._particles) {
        const maxSpd = Math.max(vars[0], 0.1);
        for (const pt of this._particles) {
          const ci = Math.max(1, Math.min(nx, Math.floor(pt.x / dx) + 1));
          const cj = Math.max(1, Math.min(ny, Math.floor(pt.y / dy) + 1));
          const vx = (this._getUx(ci, cj) + this._getUx(ci + 1, cj)) / 2;
          const vy = (this._getUy(ci, cj) + this._getUy(ci, cj + 1)) / 2;
          const t = Math.min(1, Math.sqrt(vx * vx + vy * vy) / maxSpd);
          const r = Math.floor(t < 0.5 ? 0 : (t - 0.5) * 2 * 255);
          const g = Math.floor(t < 0.5 ? t * 2 * 255 : (1 - t) * 2 * 255);
          const b = Math.floor(t < 0.5 ? 255 - t * 2 * 255 : 0);
          canvas.circle(pt.x, pt.y, 0.02, `rgb(${r},${g},${b})`, null);
        }
      }
    } else {
      // ── Arrow (quiver) view ──
      const step = 2; // sample every 2 cells
      const maxSpd = Math.max(vars[0], 0.1);
      const arrowScale = dx * step * 0.8;
      for (let i = 1; i < nx + 1; i += step) {
        for (let j = 1; j < ny + 1; j += step) {
          const cx = (i - 0.5) * dx;
          const cy = (j - 0.5) * dy;
          const vx = (this._getUx(i, j) + this._getUx(i + 1, j)) / 2;
          const vy = (this._getUy(i, j) + this._getUy(i, j + 1)) / 2;
          const spd = Math.sqrt(vx * vx + vy * vy);
          if (spd < 0.01) continue;

          const t = Math.min(1, spd / maxSpd);
          const r = Math.floor(t < 0.5 ? 0 : (t - 0.5) * 2 * 255);
          const g = Math.floor(t < 0.5 ? t * 2 * 255 : (1 - t) * 2 * 255);
          const b = Math.floor(t < 0.5 ? 255 - t * 2 * 255 : 0);
          const col = `rgb(${r},${g},${b})`;

          const scale = arrowScale / maxSpd;
          canvas.line(cx, cy, cx + vx * scale, cy + vy * scale, col, 1.5);
        }
      }
    }

    // ── Info text ──
    canvas.text(rw / 2, rh + 0.15, 'v_max = ' + vars[0].toFixed(2) + ' m/s', '#94A3B8', 9);
    canvas.text(rw / 2, rh + 0.35, 'Fan: ' + params.fanSpeed + ' m/s @ ' + params.fanAngle + '°', '#06B6D4', 9);

    // Fan label
    canvas.text(-0.25, fanMidY, 'FAN', '#06B6D4', 8);
  },

  info: `
    <h2>Fluid Flow — Navier-Stokes Simulator</h2>
    <p>Simulates incompressible air flow in a 2D room. A fan on the left wall injects air, and the Navier-Stokes equations govern how the fluid moves, recirculates, and dissipates.</p>

    <h3>The Equations</h3>
    <p><strong>Momentum:</strong> <code>∂u/∂t + (u·∇)u = −∇p/ρ + ν∇²u</code></p>
    <p><strong>Continuity:</strong> <code>∇·u = 0</code> (incompressible)</p>
    <p>Three forces compete: <strong>advection</strong> (flow carries itself), <strong>pressure</strong> (pushes from high to low), and <strong>viscosity</strong> (friction slows everything down).</p>

    <h3>Solver</h3>
    <p>Uses the <strong>fractional-step method</strong> (operator splitting):</p>
    <ol>
      <li><strong>Advection:</strong> Upwind finite differences transport velocity</li>
      <li><strong>Viscosity:</strong> Central Laplacian adds diffusion</li>
      <li><strong>Pressure:</strong> Jacobi iterative Poisson solver enforces ∇·u = 0</li>
      <li><strong>Correction:</strong> Subtract pressure gradient from velocity</li>
    </ol>

    <h3>Try These</h3>
    <ol>
      <li><strong>Gentle Breeze:</strong> Watch the flow develop slowly, recirculation forms at the far wall.</li>
      <li><strong>Strong Jet:</strong> High-speed jet hits the right wall and creates strong vortices.</li>
      <li><strong>Angled Down:</strong> Fan tilted downward — flow hugs the floor then rises at the far wall.</li>
      <li><strong>High Viscosity:</strong> Flow is sluggish, barely reaches the far wall. Like honey.</li>
      <li><strong>Low Viscosity:</strong> Nearly inviscid — sharp features, faster flow.</li>
      <li><strong>Switch to Particles:</strong> Set View mode to 1 to see particle traces — shows streamlines.</li>
    </ol>

    <h3>What to Notice</h3>
    <ul>
      <li>Recirculation zones form where the jet hits walls</li>
      <li>Higher viscosity = smoother, slower flow</li>
      <li>Fan angle changes the entire flow pattern</li>
      <li>Pressure drives flow from high to low pressure regions</li>
    </ul>
  `,
};
