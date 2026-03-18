/**
 * Vibrating String — Wave Equation PDE
 *
 * Solves the 1D wave equation using finite differences:
 *   ∂²w/∂t² = c² · ∂²w/∂x²  where c = √(T/ρ)
 *
 * Discretization (leapfrog / Verlet):
 *   w[i]^(n+1) = 2(1-r)w[i]^n + r(w[i+1]^n + w[i-1]^n) - w[i]^(n-1)
 *   where r = (c·dt/dx)² is the Courant number
 *
 * This does NOT use the ODE engine (RK4). It has its own time-stepping.
 * The sim runner just calls our custom advance() method.
 *
 * Reference: myphysicslab/src/sims/pde/StringSim.ts
 *
 * State: flat array [w0, w1, ..., wN, time] — displacements + time
 */

export const StringWaveSim = {
  name: 'Vibrating String',
  slug: 'string-wave',
  category: 'Waves',

  // Vars — we'll expose a few sample points for graphing
  vars: {
    wMid:   { index: -2, label: 'w(L/2)',   symbol: 'w_mid' },   // set dynamically
    wQuart: { index: -2, label: 'w(L/4)',   symbol: 'w_¼' },
    time:   { index: -1, label: 'Time (s)', symbol: 't' },
  },
  varCount: 203, // 201 points + time + 1 spare

  params: {
    tension:   { value: 10,  min: 1, max: 50,  step: 1,   label: 'Tension (T)',    unit: 'N' },
    density:   { value: 1,   min: 0.1, max: 5, step: 0.1, label: 'Density (ρ)',   unit: 'kg/m' },
    damping:   { value: 0,   min: 0, max: 5,   step: 0.1, label: 'Damping' },
    numPoints: { value: 101, min: 31, max: 201, step: 10,  label: 'Grid Points', resetsState: true },
    length:    { value: 5,   min: 2, max: 10,  step: 0.5, label: 'String Length',  unit: 'm' },
    shape:     { value: 'pluck', type: 'choice', options: ['pluck', 'sine', 'sine2', 'pulse'], label: 'Initial Shape' },
  },

  views: ['sim', 'time', 'energy'],

  graphDefaults: {
    time: ['wMid', 'wQuart'],
  },

  worldRect: { xMin: -0.3, xMax: 5.3, yMin: -1.5, yMax: 1.5 },

  presets: [
    { name: 'Pluck',       params: { shape: 'pluck' } },
    { name: 'Sine (1st)',  params: { shape: 'sine' } },
    { name: 'Sine (2nd)',  params: { shape: 'sine2' } },
    { name: 'Pulse',       params: { shape: 'pulse' } },
    { name: 'High Tension',params: { tension: 40 } },
    { name: 'Heavy String', params: { density: 3 } },
    { name: 'Damped',      params: { damping: 2 } },
  ],

  // Internal state — NOT the runner's state array (PDE has its own stepping)
  _wCurr: null,  // displacement at time n
  _wPrev: null,  // displacement at time n-1
  _time: 0,
  _N: 0,

  /** Shape functions for initial displacement */
  _shape(x, L, type) {
    const xn = x / L; // normalized [0,1]
    if (type === 'pluck') {
      // Triangle pluck at 1/3
      return xn < 1/3 ? 3 * xn * 0.8 : (1 - xn) * 0.8 / (2/3);
    }
    if (type === 'sine') return Math.sin(Math.PI * xn) * 0.8;
    if (type === 'sine2') return Math.sin(2 * Math.PI * xn) * 0.6;
    if (type === 'pulse') {
      const center = 0.3, width = 0.1;
      return Math.exp(-(((xn - center) / width) ** 2)) * 0.8;
    }
    return 0;
  },

  init(p) {
    const N = Math.round(p.numPoints);
    const L = p.length;
    const dx = L / (N - 1);
    const c = Math.sqrt(p.tension / p.density);
    const dt = 0.4 * dx / c; // CFL-safe timestep

    // Current displacement: from shape
    const wCurr = new Float64Array(N);
    for (let i = 1; i < N - 1; i++) {
      wCurr[i] = this._shape(i * dx, L, p.shape);
    }
    // Fixed endpoints
    wCurr[0] = 0;
    wCurr[N - 1] = 0;

    // Previous displacement: first step from wave equation
    const r = (c * dt / dx) ** 2;
    const wPrev = new Float64Array(N);
    for (let i = 1; i < N - 1; i++) {
      wPrev[i] = (1 - r) * wCurr[i] + 0.5 * r * (wCurr[i + 1] + wCurr[i - 1]);
    }

    // Store internal state
    this._wCurr = wCurr;
    this._wPrev = wPrev;
    this._time = 0;
    this._N = N;

    // Build runner state array (for graphs + readout)
    const state = new Array(N + 1).fill(0);
    for (let i = 0; i < N; i++) state[i] = wCurr[i];
    state[N] = 0; // time

    // Set dynamic var indices for graphing
    this.vars.wMid.index = Math.floor(N / 2);
    this.vars.wQuart.index = Math.floor(N / 4);

    return state;
  },

  /**
   * Custom evaluate — the runner calls this but we ignore it for physics.
   * Instead, we use postStep to do the actual PDE time-stepping.
   */
  evaluate(vars, change, params, isDragging) {
    // Just advance time — the PDE stepping happens in postStep
    const N = Math.round(params.numPoints);
    for (let i = 0; i <= N; i++) change[i] = 0;
    change[N] = 1; // time advances
  },

  /** The actual PDE time-stepping (called after each solver step) */
  postStep(vars, params) {
    if (!this._wCurr || !this._wPrev) return;

    const N = this._N;
    const L = params.length;
    const dx = L / (N - 1);
    const c = Math.sqrt(params.tension / params.density);
    const dt = 0.4 * dx / c;
    const r = (c * dt / dx) ** 2;
    const { damping, density } = params;

    // Multiple PDE substeps per frame for accuracy
    const substeps = 4;
    for (let step = 0; step < substeps; step++) {
      const wNew = new Float64Array(N);

      // Finite difference update
      for (let i = 1; i < N - 1; i++) {
        wNew[i] = 2 * (1 - r) * this._wCurr[i]
                  + r * (this._wCurr[i + 1] + this._wCurr[i - 1])
                  - this._wPrev[i];
        // Damping
        if (damping > 0) {
          wNew[i] -= (damping / density) * (this._wCurr[i] - this._wPrev[i]);
        }
      }
      // Fixed endpoints
      wNew[0] = 0;
      wNew[N - 1] = 0;

      // Rotate arrays
      this._wPrev = this._wCurr;
      this._wCurr = wNew;
      this._time += dt;
    }

    // Copy to runner state (for graphs)
    for (let i = 0; i < N; i++) vars[i] = this._wCurr[i];
    vars[N] = this._time;
  },

  energy(vars, params) {
    if (!this._wCurr || !this._wPrev) return { kinetic: 0, potential: 0, total: 0 };

    const N = this._N;
    const L = params.length;
    const dx = L / (N - 1);
    const c = Math.sqrt(params.tension / params.density);
    const dt = 0.4 * dx / c;

    let KE = 0, PE = 0;
    for (let i = 1; i < N - 1; i++) {
      // KE: ½ρ (∂w/∂t)² dx
      const vel = (this._wCurr[i] - this._wPrev[i]) / dt;
      KE += 0.5 * params.density * vel * vel * dx;
      // PE: ½T (∂w/∂x)² dx
      const slope = (this._wCurr[i + 1] - this._wCurr[i - 1]) / (2 * dx);
      PE += 0.5 * params.tension * slope * slope * dx;
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // No drag for wave sim — could add plucking later
  hitTest() { return null; },

  render(canvas, vars, params) {
    if (!this._wCurr) return;

    const N = this._N;
    const L = params.length;
    const dx = L / (N - 1);

    // Fixed endpoints
    canvas.circle(0, 0, 0.04, '#475569', null);
    canvas.circle(L, 0, 0.04, '#475569', null);

    // String
    for (let i = 0; i < N - 1; i++) {
      const x0 = i * dx, x1 = (i + 1) * dx;
      const y0 = this._wCurr[i], y1 = this._wCurr[i + 1];
      // Color based on displacement
      const amp = Math.abs(y0 + y1) / 2;
      const intensity = Math.min(1, amp * 3);
      const r = Math.round(139 + intensity * 60);
      const g = Math.round(92 + intensity * 40);
      const b = Math.round(246);
      canvas.line(x0, y0, x1, y1, `rgb(${r},${g},${b})`, 2);
    }

    // Equilibrium line
    canvas.line(0, 0, L, 0, '#ffffff10', 0.5);

    // Wave speed readout
    const c = Math.sqrt(params.tension / params.density);
    canvas.text(canvas.world.xMax - 1.5, canvas.world.yMax - 0.15,
      'c = ' + c.toFixed(2) + ' m/s', '#64748b80', 9);
  },

  info: `
    <h2>Vibrating String — The Wave Equation</h2>
    <p>A string fixed at both ends, vibrating under tension. This is governed by the <strong>wave equation</strong> — one of the most important PDEs in physics. The same equation describes sound, light, seismic waves, and quantum mechanics.</p>

    <h3>The Wave Equation</h3>
    <p><code>∂²w/∂t² = c² · ∂²w/∂x²</code></p>
    <p>Where <code>c = √(T/ρ)</code> is the wave speed, <code>T</code> is tension, and <code>ρ</code> is linear density.</p>
    <p>Higher tension → faster waves. Heavier string → slower waves. Guitar players tune strings by adjusting tension!</p>

    <h3>Standing Waves & Harmonics</h3>
    <p>A string of length L has natural frequencies:</p>
    <p><code>f_n = n · c / (2L)</code> for n = 1, 2, 3, ...</p>
    <ul>
      <li><strong>1st harmonic (fundamental):</strong> "Sine" preset — one half-wave fits the string. f₁ = c/(2L)</li>
      <li><strong>2nd harmonic:</strong> "Sine 2nd" preset — full wavelength fits. f₂ = c/L = 2f₁</li>
      <li><strong>Plucked string:</strong> Contains ALL harmonics — the shape decomposes into a Fourier series of sines</li>
    </ul>

    <h3>Numerical Method</h3>
    <p>We solve the PDE using <strong>finite differences</strong> (leapfrog / Verlet method):</p>
    <p><code>w[i]^(n+1) = 2(1-r)·w[i]^n + r·(w[i+1]^n + w[i-1]^n) - w[i]^(n-1)</code></p>
    <p>Where <code>r = (c·Δt/Δx)²</code> is the Courant number. Stability requires r &lt; 1 (CFL condition).</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Pluck vs Sine:</strong> Compare "Pluck" (triangle) vs "Sine" — the sine keeps its shape (it's a normal mode), the pluck decomposes into multiple modes</li>
      <li><strong>Watch the pulse:</strong> "Pulse" preset — a narrow bump travels along the string, reflects off the ends (inverted!), and bounces back</li>
      <li><strong>Increase tension:</strong> Wave moves faster (c = √(T/ρ)). The frequency increases — higher pitch</li>
      <li><strong>Heavier string:</strong> Increase density — wave slows down. Lower pitch. This is why bass guitar strings are thick</li>
      <li><strong>Add damping:</strong> Amplitude decays over time — like a guitar string fading out</li>
      <li><strong>Time graph:</strong> Switch to Time tab — see the midpoint oscillation. Sine shape gives a clean sinusoid, pluck gives complex waveform</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Musical instruments:</strong> Guitar, piano, violin strings — pitch = f₁ = √(T/ρ)/(2L)</li>
      <li><strong>Seismology:</strong> Earthquake waves follow the same equation through the Earth's crust</li>
      <li><strong>Electromagnetic waves:</strong> Maxwell's equations reduce to the wave equation — this is how radio, light, and WiFi propagate</li>
      <li><strong>Quantum mechanics:</strong> The Schrödinger equation is a wave equation — electron standing waves explain atomic orbitals</li>
    </ul>
  `,
};
