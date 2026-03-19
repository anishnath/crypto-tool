/**
 * Double Pendulum — Chaotic System
 *
 * Two pendulums linked end-to-end. Famous for sensitive dependence on initial
 * conditions — tiny changes in starting angle produce wildly different motion.
 *
 * Lagrangian-derived coupled ODEs:
 *
 *          -g(2m₁+m₂)sinθ₁ - gm₂sin(θ₁-2θ₂) - 2m₂ω₂²L₂sin(θ₁-θ₂) - m₂ω₁²L₁sin(2(θ₁-θ₂))
 * α₁ =  ──────────────────────────────────────────────────────────────────────────────────────────
 *                              L₁(2m₁ + m₂ - m₂cos(2(θ₁-θ₂)))
 *
 *          2sin(θ₁-θ₂) [(m₁+m₂)ω₁²L₁ + g(m₁+m₂)cosθ₁ + m₂ω₂²L₂cos(θ₁-θ₂)]
 * α₂ =  ──────────────────────────────────────────────────────────────────────────
 *                              L₂(2m₁ + m₂ - m₂cos(2(θ₁-θ₂)))
 *
 *
 * State: [θ₁, ω₁, θ₂, ω₂, time]
 */

export const DoublePendulumSim = {
  name: 'Double Pendulum',
  slug: 'double-pendulum',
  category: 'Chaos',

  vars: {
    theta1:  { index: 0, label: 'Angle 1 (rad)',    symbol: 'θ₁' },
    omega1:  { index: 1, label: 'Angular Vel 1',    symbol: 'ω₁' },
    theta2:  { index: 2, label: 'Angle 2 (rad)',    symbol: 'θ₂' },
    omega2:  { index: 3, label: 'Angular Vel 2',    symbol: 'ω₂' },
    time:    { index: 4, label: 'Time (s)',          symbol: 't' },
    x2:      { index: 5, label: 'Bob 2 x (m)',      symbol: 'x₂' },
    y2:      { index: 6, label: 'Bob 2 y (m)',      symbol: 'y₂' },
    speed2:  { index: 7, label: 'Bob 2 Speed',      symbol: '|v₂|' },
  },
  varCount: 8,

  params: {
    gravity:  { value: 9.8,  min: 0, max: 25,   step: 0.1,  label: 'Gravity',    unit: 'm/s²' },
    length1:  { value: 1.0,  min: 0.2, max: 3,  step: 0.1,  label: 'Length 1',   unit: 'm' },
    length2:  { value: 1.0,  min: 0.2, max: 3,  step: 0.1,  label: 'Length 2',   unit: 'm' },
    mass1:    { value: 2.0,  min: 0.1, max: 10, step: 0.1,  label: 'Mass 1',     unit: 'kg' },
    mass2:    { value: 2.0,  min: 0.1, max: 10, step: 0.1,  label: 'Mass 2',     unit: 'kg' },
    startAngle1: { value: Math.PI / 2, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start θ₁', unit: 'rad' },
    startAngle2: { value: Math.PI / 2, min: -Math.PI, max: Math.PI, step: 0.05, label: 'Start θ₂', unit: 'rad' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'theta1', y: 'omega1' },
    time: ['x2', 'y2', 'speed2'],
  },

  worldRect: { xMin: -3, xMax: 3, yMin: -3.5, yMax: 1 },

  presets: [
    { name: 'Default',         params: {} },
    { name: 'Small Angle',     params: { startAngle1: 0.3, startAngle2: 0.3 } },
    { name: 'Full Flip',       params: { startAngle1: Math.PI * 0.95, startAngle2: Math.PI * 0.95 } },
    { name: 'Asymmetric',      params: { startAngle1: Math.PI / 2, startAngle2: 0 } },
    { name: 'Heavy Top',       params: { mass1: 8, mass2: 1 } },
    { name: 'Heavy Bottom',    params: { mass1: 1, mass2: 8 } },
    { name: 'Long + Short',    params: { length1: 2.0, length2: 0.5 } },
    { name: 'Chaos Demo',      params: { startAngle1: Math.PI * 0.99, startAngle2: Math.PI * 0.99 } },
  ],

  init(p) {
    const { length1: L1, length2: L2 } = p;
    const x2 = L1 * Math.sin(p.startAngle1) + L2 * Math.sin(p.startAngle2);
    const y2 = -L1 * Math.cos(p.startAngle1) - L2 * Math.cos(p.startAngle2);
    return [p.startAngle1, 0, p.startAngle2, 0, 0, x2, y2, 0];
  },

  /** Compute bob2 Cartesian position and speed after each step */
  postStep(vars, params) {
    const { length1: L1, length2: L2 } = params;
    const [th1, dth1, th2, dth2] = vars;
    const x1 = L1 * Math.sin(th1);
    const y1 = -L1 * Math.cos(th1);
    vars[5] = x1 + L2 * Math.sin(th2);
    vars[6] = y1 - L2 * Math.cos(th2);
    // Speed of bob2
    const vx2 = L1 * dth1 * Math.cos(th1) + L2 * dth2 * Math.cos(th2);
    const vy2 = L1 * dth1 * Math.sin(th1) + L2 * dth2 * Math.sin(th2);
    vars[7] = Math.hypot(vx2, vy2);
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1; // time
    change[5] = 0; change[6] = 0; change[7] = 0; // computed in postStep
    if (isDragging) return;

    const th1 = vars[0], dth1 = vars[1];
    const th2 = vars[2], dth2 = vars[3];
    const { gravity: g, length1: L1, length2: L2, mass1: m1, mass2: m2 } = params;

    const delta = th1 - th2;
    const sinD = Math.sin(delta);
    const cosD = Math.cos(delta);
    const sin2D = Math.sin(2 * delta);
    const denom = 2 * m1 + m2 - m2 * Math.cos(2 * delta);

    // dθ₁/dt = ω₁
    change[0] = dth1;

    // α₁ (angular acceleration of pendulum 1)
    let num1 = -g * (2 * m1 + m2) * Math.sin(th1);
    num1 -= g * m2 * Math.sin(th1 - 2 * th2);
    num1 -= 2 * m2 * dth2 * dth2 * L2 * sinD;
    num1 -= m2 * dth1 * dth1 * L1 * sin2D;
    change[1] = num1 / (L1 * denom);

    // dθ₂/dt = ω₂
    change[2] = dth2;

    // α₂ (angular acceleration of pendulum 2)
    let num2 = (m1 + m2) * dth1 * dth1 * L1;
    num2 += g * (m1 + m2) * Math.cos(th1);
    num2 += m2 * dth2 * dth2 * L2 * cosD;
    num2 *= 2 * sinD;
    change[3] = num2 / (L2 * denom);
  },

  energy(vars, params) {
    const [th1, dth1, th2, dth2] = vars;
    const { gravity: g, length1: L1, length2: L2, mass1: m1, mass2: m2 } = params;

    // Positions
    const x1 = L1 * Math.sin(th1);
    const y1 = -L1 * Math.cos(th1);
    const x2 = x1 + L2 * Math.sin(th2);
    const y2 = y1 - L2 * Math.cos(th2);

    // Velocities
    const vx1 = L1 * dth1 * Math.cos(th1);
    const vy1 = L1 * dth1 * Math.sin(th1);
    const vx2 = vx1 + L2 * dth2 * Math.cos(th2);
    const vy2 = vy1 + L2 * dth2 * Math.sin(th2);

    const KE = 0.5 * m1 * (vx1 * vx1 + vy1 * vy1) + 0.5 * m2 * (vx2 * vx2 + vy2 * vy2);
    // PE reference: both bobs hanging straight down
    const PE = g * m1 * (y1 + L1) + g * m2 * (y2 + L1 + L2);

    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  // --- Drag ---

  hitTest(wx, wy, vars, params) {
    const { length1: L1, length2: L2 } = params;
    const [th1, , th2] = vars;
    const x1 = L1 * Math.sin(th1);
    const y1 = -L1 * Math.cos(th1);
    const x2 = x1 + L2 * Math.sin(th2);
    const y2 = y1 - L2 * Math.cos(th2);

    if (Math.hypot(wx - x2, wy - y2) < 0.3) return { id: 'bob2' };
    if (Math.hypot(wx - x1, wy - y1) < 0.3) return { id: 'bob1' };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    const { length1: L1 } = params;
    if (id === 'bob1') {
      vars[0] = Math.atan2(wx, -wy);
      vars[1] = 0; vars[3] = 0;
    } else if (id === 'bob2') {
      const x1 = L1 * Math.sin(vars[0]);
      const y1 = -L1 * Math.cos(vars[0]);
      vars[2] = Math.atan2(wx - x1, -(wy - y1));
      vars[1] = 0; vars[3] = 0;
    }
  },

  onRelease() {},

  // Trail point: second bob position (the chaotic one)
  trailPoint(vars, params) {
    const { length1: L1, length2: L2 } = params;
    const x1 = L1 * Math.sin(vars[0]);
    const y1 = -L1 * Math.cos(vars[0]);
    return { wx: x1 + L2 * Math.sin(vars[2]), wy: y1 - L2 * Math.cos(vars[2]) };
  },

  // --- Vectors ---

  vectors(vars, params) {
    const [th1, dth1, th2, dth2] = vars;
    const { length1: L1, length2: L2 } = params;
    const x1 = L1 * Math.sin(th1);
    const y1 = -L1 * Math.cos(th1);
    const x2 = x1 + L2 * Math.sin(th2);
    const y2 = y1 - L2 * Math.cos(th2);
    const vx2 = L1 * dth1 * Math.cos(th1) + L2 * dth2 * Math.cos(th2);
    const vy2 = L1 * dth1 * Math.sin(th1) + L2 * dth2 * Math.sin(th2);
    return {
      pos: { x: x2, y: y2 },
      velocity: { x: vx2, y: vy2, mag: Math.hypot(vx2, vy2) },
      accel: { x: 0, y: 0, mag: 0 }, // complex to compute, skip for now
    };
  },

  // --- Rendering ---

  render(canvas, vars, params) {
    const [th1, , th2] = vars;
    const { length1: L1, length2: L2, mass1: m1, mass2: m2 } = params;

    const pivotX = 0, pivotY = 0;
    const x1 = pivotX + L1 * Math.sin(th1);
    const y1 = pivotY - L1 * Math.cos(th1);
    const x2 = x1 + L2 * Math.sin(th2);
    const y2 = y1 - L2 * Math.cos(th2);

    // Rods
    canvas.line(pivotX, pivotY, x1, y1, '#94a3b8', 2);
    canvas.line(x1, y1, x2, y2, '#94a3b8', 2);

    // Pivot
    canvas.circle(pivotX, pivotY, 0.04, '#475569', '#64748b');

    // Bob 1 (violet)
    canvas.circle(x1, y1, 0.08 * Math.sqrt(m1), '#8B5CF6', '#A78BFA');

    // Bob 2 (cyan)
    canvas.circle(x2, y2, 0.08 * Math.sqrt(m2), '#06B6D4', '#22D3EE');
  },

  info: `
    <h2>The Double Pendulum — Chaos in Action</h2>
    <p>Two pendulums linked end-to-end — one of the simplest systems that exhibits <strong>chaotic behavior</strong>. Tiny differences in starting conditions lead to completely different trajectories over time.</p>

    <h3>Equations of Motion</h3>
    <p>Derived from the Lagrangian (T - V), the coupled ODEs are:</p>
    <p><code>α₁ = [-g(2m₁+m₂)sinθ₁ - gm₂sin(θ₁-2θ₂) - 2m₂ω₂²L₂sin(θ₁-θ₂) - m₂ω₁²L₁sin(2(θ₁-θ₂))] / [L₁(2m₁+m₂-m₂cos(2(θ₁-θ₂)))]</code></p>
    <p><code>α₂ = [2sin(θ₁-θ₂)((m₁+m₂)ω₁²L₁ + g(m₁+m₂)cosθ₁ + m₂ω₂²L₂cos(θ₁-θ₂))] / [L₂(2m₁+m₂-m₂cos(2(θ₁-θ₂)))]</code></p>
    <p>These are nonlinear, coupled, and have no closed-form solution — they must be solved numerically (we use RK4).</p>

    <h3>What Makes It Chaotic</h3>
    <ul>
      <li><strong>Sensitive dependence:</strong> Change the starting angle by 0.001 rad → after a few seconds, the motion is completely different</li>
      <li><strong>Non-periodic:</strong> Unlike a single pendulum, the motion never exactly repeats</li>
      <li><strong>Energy is still conserved:</strong> Despite the wild motion, total energy (KE + PE) stays constant — switch to the Energy tab to verify</li>
      <li><strong>Deterministic chaos:</strong> The equations are perfectly predictable step-by-step, yet long-term prediction is impossible due to compounding errors</li>
    </ul>

    <h3>Phase Space</h3>
    <p>Switch to the <strong>Phase tab</strong> and watch θ₁ vs ω₁:</p>
    <ul>
      <li><strong>Small angles:</strong> Nearly periodic orbits (quasi-regular)</li>
      <li><strong>Large angles:</strong> Phase space fills erratically — the signature of chaos</li>
      <li>Use the var-picker to view θ₂ vs ω₂, or θ₁ vs θ₂ (configuration space)</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Chaos sensitivity:</strong> Run "Default" for 10s. Reset. Change Start θ₁ by just 0.01 rad. Run again — the motion quickly diverges</li>
      <li><strong>Small angle = nearly periodic:</strong> Try "Small Angle" preset — both pendulums oscillate smoothly, almost like two normal modes</li>
      <li><strong>Full flip chaos:</strong> Try "Full Flip" — the pendulums wildly rotate over the top, pure chaos</li>
      <li><strong>Heavy top vs heavy bottom:</strong> Compare the two presets — mass distribution dramatically changes the dynamics</li>
      <li><strong>Energy conservation in chaos:</strong> Switch to Energy tab during wild motion — the green Total line stays flat despite the apparent randomness</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Weather prediction:</strong> The atmosphere is a chaotic system — small measurement errors grow exponentially, limiting forecasts to ~10 days</li>
      <li><strong>Robotic arms:</strong> Multi-jointed robots face the same coupling equations — understanding these dynamics is essential for control</li>
      <li><strong>Molecular dynamics:</strong> Chains of atoms in polymers exhibit chaotic vibrational modes</li>
      <li><strong>Financial markets:</strong> Some market models use chaotic differential equations to explain unpredictable price movements</li>
    </ul>
  `,
};
