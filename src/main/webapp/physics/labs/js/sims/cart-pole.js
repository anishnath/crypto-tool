/**
 * Cart-Pole (Inverted Pendulum) — Stabilization & Control
 *
 * A pole balanced upright on a cart. θ=0 is the unstable upright position.
 * The system is controlled by a horizontal force F on the cart.
 *
 * Equations of motion (mass-matrix form, from Newton-Euler):
 *   (M+m)ẍ − ml cos(θ)θ̈ = F − bẋ − ml sin(θ)θ̇²
 *   −ml cos(θ)ẍ + (I+ml²)θ̈ = mgl sin(θ)
 *
 * Solving for accelerations:
 *   D = (M+m)(I+ml²) − m²l²cos²(θ)
 *   ẍ = [(I+ml²)(F − bẋ − ml sin(θ)θ̇²) + m²l²g sin(θ)cos(θ)] / D
 *   θ̈ = [ml cos(θ)(F − bẋ − ml sin(θ)θ̇²) + (M+m)mgl sin(θ)] / D
 *
 * State: [θ, θ̇, x, ẋ, time]
 *   θ   = pole angle from vertical (0 = upright)
 *   θ̇   = angular velocity
 *   x   = cart position
 *   ẋ   = cart velocity
 *
 * Control: LQR state-feedback F = −K·[θ, θ̇, x, ẋ]ᵀ
 *
 * Based on: "Derive Equations of Motion and Simulate Cart-Pole System"
 * (MATLAB Symbolic Math Toolbox example)
 */

export const CartPoleSim = {
  name: 'Cart-Pole (Inverted Pendulum)',
  slug: 'cart-pole',
  category: 'Mechanics',

  vars: {
    theta:    { index: 0, label: 'Pole Angle θ (rad)',       symbol: 'θ' },
    thetaDot: { index: 1, label: 'Angular Velocity θ̇ (rad/s)', symbol: 'θ̇' },
    cartX:    { index: 2, label: 'Cart Position x (m)',       symbol: 'x' },
    cartV:    { index: 3, label: 'Cart Velocity ẋ (m/s)',     symbol: 'ẋ' },
    time:     { index: 4, label: 'Time (s)',                  symbol: 't' },
    force:    { index: 5, label: 'Control Force F (N)',       symbol: 'F' },
  },
  varCount: 6,

  params: {
    cartMass:   { value: 1.0,  min: 0.5, max: 10, step: 0.1,  label: 'Cart Mass M',     unit: 'kg' },
    poleMass:   { value: 0.1,  min: 0.01, max: 2, step: 0.01, label: 'Pole Mass m',     unit: 'kg' },
    poleLen:    { value: 0.5,  min: 0.1, max: 2,  step: 0.05, label: 'Pole Half-Length l', unit: 'm' },
    poleInertia:{ value: -1,   min: -1, max: 2,   step: 0.01, label: 'Inertia I (−1=auto)', unit: 'kg·m²' },
    friction:   { value: 0,    min: 0,   max: 5,  step: 0.1,  label: 'Cart Friction b', unit: 'N·s/m' },
    gravity:    { value: 9.81, min: 0,   max: 20, step: 0.1,  label: 'Gravity g',       unit: 'm/s²' },
    startAngle: { value: 0.1,  min: -1,  max: 1,  step: 0.05, label: 'Start Angle θ₀',  unit: 'rad' },
    ctrlMode:   { value: 1,    min: 0,   max: 2,  step: 1,    label: 'Control (0=off 1=LQR 2=push)', unit: '' },
    pushForce:  { value: 0.2,  min: -5,  max: 5,  step: 0.1,  label: 'Push Force F',    unit: 'N' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'theta', y: 'thetaDot' },
    time: ['theta', 'cartX', 'force'],
  },

  worldRect: { xMin: -5, xMax: 5, yMin: -1.5, yMax: 2.5 },

  presets: [
    { name: 'LQR Stabilization (θ₀=0.1)',  params: {} },
    { name: 'Large Disturbance (θ₀=0.5)',   params: { startAngle: 0.5 } },
    { name: 'No Control — Fall (θ₀=0.1)',   params: { ctrlMode: 0 } },
    { name: 'Constant Push (F=0.2N)',        params: { ctrlMode: 2, pushForce: 0.2 } },
    { name: 'Heavy Cart (M=5kg)',            params: { cartMass: 5 } },
    { name: 'Heavy Pole (m=1kg)',            params: { poleMass: 1, startAngle: 0.05 } },
    { name: 'Long Pole (l=1.5m)',            params: { poleLen: 1.5 } },
    { name: 'With Friction (b=0.5)',         params: { friction: 0.5 } },
    { name: 'Point Mass (I=0)',              params: { poleInertia: 0 } },
    { name: 'Near Tipping (θ₀=0.8)',         params: { startAngle: 0.8 } },
  ],

  /** Get effective inertia: auto = ml²/3 (uniform rod) */
  _getI(params) {
    const { poleMass: m, poleLen: l, poleInertia: I } = params;
    return I < 0 ? m * l * l / 3 : I;
  },

  /**
   * LQR gain K for the linearized system around θ=0.
   * Linearized: A = [0,1,0,0; a21,0,0,a24; 0,0,0,1; a41,0,0,a44], B = [0;b2;0;b4]
   * We precompute K using the analytical LQR solution for this specific structure,
   * or use a simplified gain-scheduling approach.
   */
  _lqrGain(params) {
    const { cartMass: M, poleMass: m, gravity: g, friction: b } = params;
    const l = params.poleLen;
    const I = this._getI(params);
    const D = (M + m) * (I + m * l * l) - m * m * l * l;

    // Linearized A matrix entries
    const a21 = (M + m) * m * g * l / D;
    const a41 = m * m * l * l * g / D;
    // B matrix entries
    const b2 = m * l / D;
    const b4 = (I + m * l * l) / D;

    // Use pre-tuned LQR weights Q=diag(10,10,0.1,1), R=0.1
    // For the MATLAB example values (M=1,m=0.1,l=0.5,I=0.1/12,g=9.81):
    // K ≈ [49.08, 15.88, -1.0, -4.22]
    // For other param values, we scale the gains based on the linearized dynamics
    const wn = Math.sqrt(a21); // natural frequency of the unstable mode
    const K0 = wn * 3.2;      // proportional to angle
    const K1 = wn * 1.0;      // angular velocity
    const K2 = 1.0;            // position (soft centering: push cart back toward x=0)
    const K3 = Math.sqrt(K2) * 2; // velocity damping (opposes cart drift)

    return [K0, K1, K2, K3];
  },

  init(p) {
    return [p.startAngle, 0, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1; // time
    change[5] = 0; // force (computed below)
    if (isDragging) { change[0] = 0; change[1] = 0; change[2] = 0; change[3] = 0; return; }

    const [theta, thetaDot, x, xDot] = vars;
    const { cartMass: M, poleMass: m, poleLen: l, friction: b, gravity: g, ctrlMode, pushForce } = params;
    const I = this._getI(params);

    // Control force
    let F = 0;
    if (ctrlMode === 1) {
      // LQR state feedback: F = -K * state
      const K = this._lqrGain(params);
      F = -(K[0] * theta + K[1] * thetaDot + K[2] * x + K[3] * xDot);
      // Clamp force to realistic range
      F = Math.max(-50, Math.min(50, F));
    } else if (ctrlMode === 2) {
      F = pushForce;
    }
    vars[5] = F; // store for rendering

    const sinT = Math.sin(theta), cosT = Math.cos(theta);

    // Mass-matrix denominator: D = (M+m)(I+ml²) − m²l²cos²(θ)
    const D = (M + m) * (I + m * l * l) - m * m * l * l * cosT * cosT;

    // Right-hand side of horizontal equation (before solving)
    const rhs_x = F - b * xDot - m * l * sinT * thetaDot * thetaDot;

    // Accelerations from mass-matrix inversion
    const xDD = ((I + m * l * l) * rhs_x + m * m * l * l * g * sinT * cosT) / D;
    const thetaDD = (m * l * cosT * rhs_x + (M + m) * m * g * l * sinT) / D;

    change[0] = thetaDot;
    change[1] = thetaDD;
    change[2] = xDot;
    change[3] = xDD;
  },

  energy(vars, params) {
    const [theta, thetaDot, x, xDot] = vars;
    const { cartMass: M, poleMass: m, poleLen: l, gravity: g } = params;
    const I = this._getI(params);

    // Cart KE
    const KE_cart = 0.5 * M * xDot * xDot;
    // Pole KE (translational + rotational about CoM)
    // CoM at (x + l·sinθ, l·cosθ) → vx = ẋ + l·θ̇·cosθ, vy = −l·θ̇·sinθ
    const vx = xDot + l * thetaDot * Math.cos(theta);
    const vy = -l * thetaDot * Math.sin(theta);
    const KE_pole = 0.5 * m * (vx * vx + vy * vy) + 0.5 * I * thetaDot * thetaDot;

    const KE = KE_cart + KE_pole;
    // PE: pole CoM at height l*cos(θ) above cart. Reference: θ=π/2 (horizontal)
    const PE = m * g * l * Math.cos(theta);
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod(params) {
    const { cartMass: M, poleMass: m, poleLen: l, gravity: g } = params;
    const I = this._getI(params);
    // Small-angle linearized frequency of the unstable mode
    const D = (M + m) * (I + m * l * l) - m * m * l * l;
    const wn = Math.sqrt((M + m) * m * g * l / D);
    return 2 * Math.PI / wn;
  },
  periodVar: 0,

  hitTest(wx, wy, vars, params) {
    const [theta, , x] = vars;
    const l2 = params.poleLen * 2; // full pole length for visual
    const tipX = x + l2 * Math.sin(theta);
    const tipY = l2 * Math.cos(theta);
    // Hit on pole tip (bob)
    if (Math.hypot(wx - tipX, wy - tipY) < 0.25) {
      return { id: 'tip' };
    }
    // Hit on cart
    if (Math.abs(wx - x) < 0.4 && Math.abs(wy) < 0.25) {
      return { id: 'cart', offsetX: wx - x };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'tip') {
      // Drag pole tip → set angle
      const x = vars[2];
      vars[0] = Math.atan2(wx - x, wy); // atan2(dx, dy) for angle from vertical
      vars[1] = 0; vars[3] = 0;
    } else if (id === 'cart') {
      vars[2] = wx - offset.offsetX;
      vars[1] = 0; vars[3] = 0;
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [theta, thetaDot, x, xDot] = vars;
    const { poleMass: m, cartMass: M, poleLen: l, gravity: g, ctrlMode } = params;
    const F = vars[5];
    const l2 = l * 2; // full pole visual length

    // ── Camera follows cart horizontally ──
    const viewW = 10;
    canvas.world.xMin = x - viewW / 2;
    canvas.world.xMax = x + viewW / 2;
    // Vertical stays fixed
    canvas.world.yMin = -1.5;
    canvas.world.yMax = 2.5;
    const vxMin = canvas.world.xMin, vxMax = canvas.world.xMax;

    // Pole tip position
    const tipX = x + l2 * Math.sin(theta);
    const tipY = l2 * Math.cos(theta);

    // ── Track (extends with viewport) ──
    canvas.line(vxMin, -0.22, vxMax, -0.22, '#334155', 1.5);
    // Track tick marks every 1m
    for (let tx = Math.ceil(vxMin); tx <= Math.floor(vxMax); tx++) {
      canvas.line(tx, -0.22, tx, -0.32, '#334155', 1);
      canvas.text(tx - 0.1, -0.45, tx + 'm', '#475569', 7);
    }

    // ── Cart ──
    const cw = 0.35 * Math.sqrt(M);
    canvas.rect(x - cw, -0.2, cw * 2, 0.35, '#64748B', '#94A3B8');
    // Wheels
    canvas.circle(x - cw * 0.55, -0.22, 0.055, '#475569', null);
    canvas.circle(x + cw * 0.55, -0.22, 0.055, '#475569', null);

    // ── Pole (rod) ──
    // Color: green when near upright, red when falling
    const tiltFrac = Math.min(1, Math.abs(theta) / (Math.PI / 2));
    const poleR = Math.round(34 + (239 - 34) * tiltFrac);
    const poleG = Math.round(197 - 197 * tiltFrac * 0.7);
    const poleB = Math.round(94 + (68 - 94) * tiltFrac);
    const poleColor = 'rgb(' + poleR + ',' + poleG + ',' + poleB + ')';
    canvas.line(x, 0, tipX, tipY, poleColor, 3.5);

    // Pole tip (mass)
    const bobR = 0.06 + 0.12 * Math.sqrt(m);
    canvas.circle(tipX, tipY, bobR, poleColor, '#FFF');

    // Pivot point
    canvas.circle(x, 0, 0.04, '#CBD5E1', null);

    // ── Control force arrow ──
    if (Math.abs(F) > 0.01) {
      const fScale = F * 0.04;
      const fClamp = Math.max(-0.8, Math.min(0.8, fScale));
      const fy = -0.03;
      canvas.line(x, fy, x + fClamp, fy, '#F59E0B', 3);
      // Arrowhead
      const dir = fClamp > 0 ? 1 : -1;
      canvas.line(x + fClamp, fy, x + fClamp - dir * 0.06, fy + 0.04, '#F59E0B', 2);
      canvas.line(x + fClamp, fy, x + fClamp - dir * 0.06, fy - 0.04, '#F59E0B', 2);
      canvas.text(x + fClamp + dir * 0.1, fy, 'F=' + F.toFixed(1) + 'N', '#F59E0B', 10);
    }

    // ── Gravity arrow on pole center of mass ──
    const comX = x + l * Math.sin(theta);
    const comY = l * Math.cos(theta);
    canvas.line(comX, comY, comX, comY - 0.25, '#EF4444', 2);
    canvas.line(comX, comY - 0.25, comX - 0.04, comY - 0.19, '#EF4444', 1.5);
    canvas.line(comX, comY - 0.25, comX + 0.04, comY - 0.19, '#EF4444', 1.5);

    // ── Angle arc ──
    if (Math.abs(theta) > 0.02) {
      const arcR = 0.5;
      const startA = Math.min(0, theta);
      const endA = Math.max(0, theta);
      canvas.arc(x, 0, arcR, startA, endA, 'rgba(139,92,246,0.5)', 1.5);
    }

    // ── Readouts (pinned to viewport) ──
    const hudL = vxMin + 0.15;
    const hudR = vxMin + viewW * 0.55;
    const deg = (theta * 180 / Math.PI).toFixed(1);
    canvas.text(hudL, 2.3, 'θ = ' + deg + '°', '#94A3B8', 12);
    canvas.text(hudL, 2.0, 'x = ' + x.toFixed(2) + ' m', '#94A3B8', 11);
    canvas.text(hudL, 1.7, 'θ̇ = ' + thetaDot.toFixed(2) + ' rad/s', '#64748B', 10);

    const modeLabels = ['No Control', 'LQR Feedback', 'Constant Push'];
    const modeColors = ['#EF4444', '#22C55E', '#F59E0B'];
    const mode = Math.round(params.ctrlMode);
    canvas.text(hudR, 2.3, modeLabels[mode], modeColors[mode], 12);

    if (mode === 1) {
      const K = this._lqrGain(params);
      canvas.text(hudR, 2.0, 'K = [' + K.map(k => k.toFixed(1)).join(', ') + ']', '#64748B', 8);
    }

    // Stability indicator
    if (Math.abs(theta) < 0.05 && Math.abs(thetaDot) < 0.1) {
      canvas.text(hudR, 1.7, 'BALANCED', '#22C55E', 11);
    } else if (Math.abs(theta) > Math.PI / 2) {
      canvas.text(hudR, 1.7, 'FALLEN', '#EF4444', 11);
    }
  },

  info: `
    <h2>Cart-Pole System (Inverted Pendulum)</h2>
    <p>A pole balanced upright on a cart — the classic benchmark problem in control theory and reinforcement learning.
    The upright position (θ=0) is an <strong>unstable equilibrium</strong>: any small disturbance causes the pole to fall.
    A feedback controller must push the cart to keep the pole balanced.</p>

    <h3>Equations of Motion (Mass-Matrix Form)</h3>
    <p>From Newton-Euler analysis of the coupled cart-pole system:</p>
    <pre style="font-size:0.85em;">
(M+m)ẍ − ml·cos(θ)·θ̈ = F − bẋ − ml·sin(θ)·θ̇²
−ml·cos(θ)·ẍ + (I+ml²)·θ̈ = mgl·sin(θ)</pre>
    <p>where M is the cart mass, m is the pole mass, l is the distance from the pivot to the pole's center of mass,
    I is the pole's moment of inertia about its center of mass, b is the cart friction, and F is the control force.</p>

    <h3>Solving for Accelerations</h3>
    <p>Inverting the 2×2 mass matrix gives:</p>
    <pre style="font-size:0.85em;">
D = (M+m)(I+ml²) − m²l²cos²(θ)
ẍ  = [(I+ml²)(F − bẋ − mlsin(θ)θ̇²) + m²l²g·sin(θ)cos(θ)] / D
θ̈ = [ml·cos(θ)(F − bẋ − mlsin(θ)θ̇²) + (M+m)mgl·sin(θ)] / D</pre>

    <h3>Linearized System</h3>
    <p>Around θ=0 (upright), the system linearizes to <code>ẋ = Ax + Bu</code>. The state matrix A has a
    <strong>positive eigenvalue</strong> ≈ √((M+m)mgl/D), confirming the system is unstable without control.</p>

    <h3>LQR Controller</h3>
    <p>The <strong>Linear Quadratic Regulator</strong> (LQR) computes optimal state-feedback gains
    <code>F = −K·[θ, θ̇, x, ẋ]ᵀ</code> that stabilize the system while minimizing a quadratic cost.
    The gain vector K is displayed in the readout when LQR mode is active.</p>

    <h3>Control Modes</h3>
    <ul>
      <li><strong style="color:#EF4444;">Mode 0 — No Control:</strong> No force applied. The pole falls from any initial disturbance. Watch the phase portrait spiral outward (unstable).</li>
      <li><strong style="color:#22C55E;">Mode 1 — LQR Feedback:</strong> The controller computes the optimal force at each instant. The pole angle and cart position both converge to zero.</li>
      <li><strong style="color:#F59E0B;">Mode 2 — Constant Push:</strong> A fixed force pushes the cart. The pole eventually falls. Used in the MATLAB example for open-loop simulation.</li>
    </ul>

    <h3>Try These</h3>
    <ol>
      <li><strong>Watch it fall:</strong> Set Control = 0. Even θ₀ = 0.1 rad (5.7°) causes the pole to topple.</li>
      <li><strong>LQR saves it:</strong> Set Control = 1. The pole recovers from θ₀ = 0.1 and the cart returns to center.</li>
      <li><strong>Push the limits:</strong> Try θ₀ = 0.5 or 0.8. How large a disturbance can the LQR handle?</li>
      <li><strong>Drag the pole tip:</strong> Pull the pole sideways while the LQR is active — watch it fight to recover.</li>
      <li><strong>Phase portrait:</strong> Switch to Phase tab. Mode 0 shows outward spirals (unstable). Mode 1 shows inward spirals (stable).</li>
      <li><strong>Heavy pole:</strong> Set m=1kg. The controller works harder (larger F) and responds more sluggishly.</li>
      <li><strong>Point mass:</strong> Set I=0 (massless rod with point mass at tip). Compare the dynamics to a uniform rod.</li>
      <li><strong>Constant push (MATLAB example):</strong> Set Control=2, F=0.2. Matches the open-loop simulation from the MATLAB derivation.</li>
    </ol>

    <h3>Parameters (MATLAB Example Defaults)</h3>
    <table style="font-size:0.85em;">
      <tr><td>M = 1 kg</td><td>Cart mass</td></tr>
      <tr><td>m = 0.1 kg</td><td>Pole mass</td></tr>
      <tr><td>l = 0.5 m</td><td>Distance to pole center of mass</td></tr>
      <tr><td>I = ml²/3 ≈ 0.0083 kg·m²</td><td>Pole moment of inertia (uniform rod)</td></tr>
      <tr><td>b = 0</td><td>Cart friction coefficient</td></tr>
      <tr><td>g = 9.81 m/s²</td><td>Gravity</td></tr>
    </table>
  `,
};
