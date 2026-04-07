/**
 * Quadrotor Dynamics — Nonlinear 6-DOF Model
 *
 * 12-state nonlinear model derived from Newton-Euler equations.
 * State: [x, y, z, φ, θ, ψ, ẋ, ẏ, ż, p, q, r]
 *   (x,y,z)     = linear position in inertial frame
 *   (φ,θ,ψ)     = roll, pitch, yaw (Euler ZYX)
 *   (ẋ,ẏ,ż)     = linear velocity in inertial frame
 *   (p,q,r)      = angular velocity in body frame
 *
 * Linear dynamics (inertial frame):
 *   ξ̈ = [0,0,-g]ᵀ + R·[0,0,T/m]ᵀ
 *   where R = Rz(ψ)·Ry(θ)·Rx(φ) and T = k(u₁+u₂+u₃+u₄)
 *
 * Angular dynamics (body frame — Euler's equations):
 *   ṗ = ((Iyy−Izz)qr + τ_φ) / Ixx
 *   q̇ = ((Izz−Ixx)pr + τ_θ) / Iyy
 *   ṙ = ((Ixx−Iyy)pq + τ_ψ) / Izz
 *
 * Euler angle kinematics:
 *   φ̇ = p + sin(φ)tan(θ)q + cos(φ)tan(θ)r
 *   θ̇ = cos(φ)q − sin(φ)r
 *   ψ̇ = (sin(φ)q + cos(φ)r)/cos(θ)
 *
 * Control inputs u₁..u₄ = ω²ᵢ (squared rotor angular velocities).
 * Torques: τ_φ = lk(−u₂+u₄), τ_θ = lk(−u₁+u₃), τ_ψ = b(−u₁+u₂−u₃+u₄)
 *
 * Reference: Luukkonen (2011), "Modelling and control of quadcopter"
 */

export const QuadrotorSim = {
  name: 'Quadrotor',
  slug: 'quadrotor',
  category: 'Mechanics',

  vars: {
    x:     { index: 0,  label: 'x Position (m)',       symbol: 'x' },
    y:     { index: 1,  label: 'y Position (m)',       symbol: 'y' },
    z:     { index: 2,  label: 'Altitude (m)',         symbol: 'z' },
    phi:   { index: 3,  label: 'Roll φ (rad)',         symbol: 'φ' },
    theta: { index: 4,  label: 'Pitch θ (rad)',        symbol: 'θ' },
    psi:   { index: 5,  label: 'Yaw ψ (rad)',          symbol: 'ψ' },
    xdot:  { index: 6,  label: 'Velocity ẋ (m/s)',     symbol: 'ẋ' },
    ydot:  { index: 7,  label: 'Velocity ẏ (m/s)',     symbol: 'ẏ' },
    zdot:  { index: 8,  label: 'Climb Rate ż (m/s)',   symbol: 'ż' },
    p:     { index: 9,  label: 'Roll Rate p (rad/s)',  symbol: 'p' },
    q:     { index: 10, label: 'Pitch Rate q (rad/s)', symbol: 'q' },
    r:     { index: 11, label: 'Yaw Rate r (rad/s)',   symbol: 'r' },
    time:  { index: 12, label: 'Time (s)',             symbol: 't' },
  },
  varCount: 13,

  params: {
    mass:      { value: 2.0,  min: 0.5, max: 5,   step: 0.1,  label: 'Mass m',          unit: 'kg' },
    armLen:    { value: 0.25, min: 0.1, max: 0.5,  step: 0.05, label: 'Arm Length l',    unit: 'm' },
    Ixx:       { value: 1.2,  min: 0.3, max: 3,    step: 0.1,  label: 'Ixx',             unit: 'kg·m²' },
    Iyy:       { value: 1.2,  min: 0.3, max: 3,    step: 0.1,  label: 'Iyy',             unit: 'kg·m²' },
    Izz:       { value: 2.3,  min: 0.5, max: 5,    step: 0.1,  label: 'Izz',             unit: 'kg·m²' },
    liftK:     { value: 1.0,  min: 0.5, max: 2,    step: 0.1,  label: 'Lift Constant k', unit: '' },
    dragB:     { value: 0.2,  min: 0.05, max: 1,   step: 0.05, label: 'Drag Constant b', unit: '' },
    targetZ:   { value: 5.0,  min: 0,   max: 10,   step: 0.5,  label: 'Target Altitude', unit: 'm' },
    targetX:   { value: 0,    min: -5,  max: 5,    step: 0.5,  label: 'Target X',        unit: 'm' },
    ctrlGain:  { value: 1.0,  min: 0,   max: 3,    step: 0.1,  label: 'Controller Gain', unit: '' },
    windX:     { value: 0,    min: -3,  max: 3,    step: 0.1,  label: 'Wind Force X',    unit: 'N' },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'z', y: 'zdot' },
    time: ['z', 'theta', 'phi'],
  },

  worldRect: { xMin: -6, xMax: 6, yMin: -1, yMax: 11 },

  presets: [
    { name: 'Default Hover',           params: {} },
    { name: 'Move Right (X=3)',        params: { targetX: 3 } },
    { name: 'Move Left (X=-3)',        params: { targetX: -3 } },
    { name: 'High Altitude (Z=9)',     params: { targetZ: 9 } },
    { name: 'Heavy (m=4kg)',           params: { mass: 4 } },
    { name: 'Light (m=0.8kg)',         params: { mass: 0.8 } },
    { name: 'Wind Gust (2N)',          params: { windX: 2 } },
    { name: 'Weak Controller',         params: { ctrlGain: 0.3 } },
    { name: 'No Controller (freefall)',params: { ctrlGain: 0, targetZ: 5 } },
    { name: 'Aggressive Controller',   params: { ctrlGain: 2.5 } },
  ],

  _G: 9.81,

  /** Cascaded PD controller → rotor commands u1..u4 */
  _controller(vars, params) {
    const [x, y, z, phi, theta, psi, xd, yd, zd, p, q, r] = vars;
    const { mass: m, armLen: l, liftK: k, dragB: b, targetZ, targetX, ctrlGain: G } = params;
    const g = this._G;

    if (G < 0.001) {
      // No controller — hover thrust only
      const uHover = m * g / (4 * k);
      return [uHover, uHover, uHover, uHover];
    }

    // Altitude PD
    const Kpz = 12 * G, Kdz = 10 * G;
    const Fz = m * g + Kpz * (targetZ - z) - Kdz * zd;

    // Position → desired pitch (outer loop)
    const Kpx = 0.8 * G, Kdx = 1.2 * G;
    const thetaDes = Math.max(-0.4, Math.min(0.4,
      (Kpx * (targetX - x) - Kdx * xd) / g));

    // Attitude PD (inner loop)
    const Kpa = 24 * G, Kda = 10 * G;
    const tauPhi   = Kpa * (0 - phi)     - Kda * p;
    const tauTheta = Kpa * (thetaDes - theta) - Kda * q;
    const tauPsi   = 10 * G * (0 - psi)  - 5 * G * r;

    // Mixer: thrust + torques → individual rotors
    const F = Math.max(0, Fz);
    const u1 = F / (4 * k) - tauTheta / (2 * l * k) - tauPsi / (4 * b);
    const u2 = F / (4 * k) - tauPhi / (2 * l * k)   + tauPsi / (4 * b);
    const u3 = F / (4 * k) + tauTheta / (2 * l * k) - tauPsi / (4 * b);
    const u4 = F / (4 * k) + tauPhi / (2 * l * k)   + tauPsi / (4 * b);

    return [Math.max(0, u1), Math.max(0, u2), Math.max(0, u3), Math.max(0, u4)];
  },

  // Store last control for rendering
  _lastU: [4.9, 4.9, 4.9, 4.9],

  init() {
    return [0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[12] = 1;
    if (isDragging) { for (let i = 0; i < 12; i++) change[i] = 0; return; }

    const [x, y, z, phi, theta, psi, xd, yd, zd, p, q, r] = vars;
    const { mass: m, armLen: l, Ixx, Iyy, Izz, liftK: k, dragB: b, windX } = params;
    const g = 9.81;

    // Control inputs
    const u = this._controller(vars, params);
    this._lastU = u;
    const [u1, u2, u3, u4] = u;

    // Total thrust and torques
    const T = k * (u1 + u2 + u3 + u4);
    const tauPhi   = l * k * (-u2 + u4);
    const tauTheta = l * k * (-u1 + u3);
    const tauPsi   = b * (-u1 + u2 - u3 + u4);

    // Trig
    const cphi = Math.cos(phi), sphi = Math.sin(phi);
    const cth = Math.cos(theta), sth = Math.sin(theta);
    const cpsi = Math.cos(psi), spsi = Math.sin(psi);

    // Position derivatives
    change[0] = xd;
    change[1] = yd;
    change[2] = zd;

    // Euler angle kinematics (body rates → Euler rates)
    const tth = Math.abs(cth) > 1e-6 ? sth / cth : sth * 1e6;
    change[3] = p + sphi * tth * q + cphi * tth * r;
    change[4] = cphi * q - sphi * r;
    change[5] = Math.abs(cth) > 1e-6 ? (sphi * q + cphi * r) / cth : 0;

    // Linear acceleration: ξ̈ = -g·ẑ + R·[0,0,T/m]ᵀ + wind
    change[6] = (cpsi * sth * cphi + spsi * sphi) * T / m + windX / m;
    change[7] = (spsi * sth * cphi - cpsi * sphi) * T / m;
    change[8] = -g + cth * cphi * T / m;

    // Angular acceleration (Euler's equations in body frame)
    change[9]  = ((Iyy - Izz) * q * r + tauPhi) / Ixx;
    change[10] = ((Izz - Ixx) * p * r + tauTheta) / Iyy;
    change[11] = ((Ixx - Iyy) * p * q + tauPsi) / Izz;
  },

  postStep(vars) {
    // Ground constraint
    if (vars[2] < 0) {
      vars[2] = 0;
      if (vars[8] < 0) vars[8] = 0;
    }
    // Clamp angles to avoid gimbal lock region
    vars[4] = Math.max(-1.4, Math.min(1.4, vars[4])); // pitch
  },

  energy(vars, params) {
    const [x, y, z, phi, theta, psi, xd, yd, zd, p, q, r] = vars;
    const { mass: m, Ixx, Iyy, Izz } = params;
    const KE = 0.5 * m * (xd * xd + yd * yd + zd * zd)
             + 0.5 * (Ixx * p * p + Iyy * q * q + Izz * r * r);
    const PE = m * 9.81 * z;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  theoreticalPeriod() { return Infinity; },

  hitTest(wx, wy, vars, params) {
    // Drag the target crosshair
    const tx = params.targetX, tz = params.targetZ;
    if (Math.hypot(wx - tx, wy - tz) < 0.5) {
      return { id: 'target', offX: wx - tx, offZ: wy - tz };
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'target') {
      params.targetX = Math.max(-5, Math.min(5, wx - offset.offX));
      params.targetZ = Math.max(0.5, Math.min(10, wy - offset.offZ));
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [x, y, z, phi, theta, psi, xd, yd, zd] = vars;
    const { armLen: l, targetZ, targetX, mass: m, liftK: k } = params;
    const u = this._lastU;

    // Visual scaling: arm length scaled up for visibility
    const VIS = 3.2; // visual arm scale

    // ── Ground ──
    canvas.line(-6, 0, 6, 0, '#334155', 2);
    for (let gx = -6; gx < 6; gx += 0.4) {
      canvas.line(gx, 0, gx - 0.15, -0.15, '#1E293B', 1);
    }

    // ── Target crosshair ──
    canvas.line(targetX - 0.3, targetZ, targetX + 0.3, targetZ, '#22C55E', 1.5);
    canvas.line(targetX, targetZ - 0.3, targetX, targetZ + 0.3, '#22C55E', 1.5);
    canvas.circle(targetX, targetZ, 0.2, null, '#22C55E');
    canvas.text(targetX + 0.4, targetZ + 0.3, 'Target', '#22C55E', 7);

    // ── Target altitude line (dashed) ──
    for (let dx = -6; dx < 6; dx += 0.6) {
      canvas.line(dx, targetZ, dx + 0.3, targetZ, 'rgba(34,197,94,0.15)', 1);
    }

    // ── Quadrotor body ── (side view: x-z plane)
    const sth = Math.sin(theta), cth = Math.cos(theta);
    const armVx = l * VIS * cth;
    const armVz = l * VIS * sth;

    // Body arms (front-back along pitch axis)
    // Rotor 1 (front): +x body direction
    const r1x = x + armVx, r1z = z + armVz;
    // Rotor 3 (back): -x body direction
    const r3x = x - armVx, r3z = z - armVz;

    // Body cross-arm (left-right, perpendicular to view — draw shorter)
    const sphi_vis = Math.sin(phi);
    const r2x = x, r2z = z + l * VIS * 0.3 * sphi_vis;
    const r4x = x, r4z = z - l * VIS * 0.3 * sphi_vis;

    // Draw body arms
    canvas.line(r1x, r1z, r3x, r3z, '#94A3B8', 3); // front-back
    canvas.line(r2x, r2z + l * VIS * 0.15, r4x, r4z - l * VIS * 0.15, '#64748B', 2); // left-right (thin, perspective)

    // Center of mass
    canvas.circle(x, z, 0.12, '#8B5CF6', '#A78BFA');

    // ── Rotors ──
    const rotorR = 0.15;
    // Thrust direction in inertial frame (body z-axis projected to x-z)
    const thrustDx = -sth;
    const thrustDz = cth;

    // Rotor 1 (front)
    const t1 = Math.sqrt(Math.max(0, u[0])) * 0.06;
    canvas.circle(r1x, r1z, rotorR, '#475569', '#64748B');
    if (t1 > 0.01) canvas.line(r1x, r1z, r1x + thrustDx * t1, r1z + thrustDz * t1, '#F59E0B', 2);

    // Rotor 3 (back)
    const t3 = Math.sqrt(Math.max(0, u[2])) * 0.06;
    canvas.circle(r3x, r3z, rotorR, '#475569', '#64748B');
    if (t3 > 0.01) canvas.line(r3x, r3z, r3x + thrustDx * t3, r3z + thrustDz * t3, '#F59E0B', 2);

    // Rotor 2 (right — shown at center, perspective)
    const t2 = Math.sqrt(Math.max(0, u[1])) * 0.06;
    canvas.circle(r2x, r2z + l * VIS * 0.15, rotorR * 0.6, '#475569', '#64748B');
    if (t2 > 0.01) canvas.line(r2x, r2z + l * VIS * 0.15, r2x + thrustDx * t2 * 0.5, r2z + l * VIS * 0.15 + thrustDz * t2 * 0.5, '#F59E0B', 1.5);

    // Rotor 4 (left)
    const t4 = Math.sqrt(Math.max(0, u[3])) * 0.06;
    canvas.circle(r4x, r4z - l * VIS * 0.15, rotorR * 0.6, '#475569', '#64748B');
    if (t4 > 0.01) canvas.line(r4x, r4z - l * VIS * 0.15, r4x + thrustDx * t4 * 0.5, r4z - l * VIS * 0.15 + thrustDz * t4 * 0.5, '#F59E0B', 1.5);

    // ── Rotor labels ──
    canvas.text(r1x + 0.15, r1z + 0.2, '1', '#64748B', 6);
    canvas.text(r3x - 0.3, r3z + 0.2, '3', '#64748B', 6);

    // ── Weight arrow ──
    const wLen = 0.4;
    canvas.line(x, z, x, z - wLen, '#EF4444', 2);
    canvas.line(x, z - wLen, x - 0.06, z - wLen + 0.08, '#EF4444', 1.5);
    canvas.line(x, z - wLen, x + 0.06, z - wLen + 0.08, '#EF4444', 1.5);
    canvas.text(x + 0.12, z - wLen * 0.5, 'mg', '#EF4444', 6);

    // ── Total thrust arrow ──
    const T = k * (u[0] + u[1] + u[2] + u[3]);
    const tScale = T / (m * 9.81) * 0.4;
    if (tScale > 0.01) {
      canvas.line(x, z, x + thrustDx * tScale, z + thrustDz * tScale, '#22C55E', 2.5);
      const tx2 = x + thrustDx * tScale, tz2 = z + thrustDz * tScale;
      canvas.line(tx2, tz2, tx2 - thrustDx * 0.08 + thrustDz * 0.05, tz2 - thrustDz * 0.08 - thrustDx * 0.05, '#22C55E', 1.5);
      canvas.line(tx2, tz2, tx2 - thrustDx * 0.08 - thrustDz * 0.05, tz2 - thrustDz * 0.08 + thrustDx * 0.05, '#22C55E', 1.5);
      canvas.text(x + thrustDx * tScale + 0.15, z + thrustDz * tScale, 'T', '#22C55E', 6);
    }

    // ── Readouts ──
    const angleDeg = (a) => (a * 180 / Math.PI).toFixed(1);
    canvas.text(-5.8, 10.5, 'z = ' + z.toFixed(2) + ' m', '#94A3B8', 9);
    canvas.text(-5.8, 10.1, 'ż = ' + zd.toFixed(2) + ' m/s', '#64748B', 8);
    canvas.text(-5.8, 9.7, 'x = ' + x.toFixed(2) + ' m', '#94A3B8', 8);

    canvas.text(-1.5, 10.5, 'φ = ' + angleDeg(phi) + '°', '#06B6D4', 8);
    canvas.text(-1.5, 10.1, 'θ = ' + angleDeg(theta) + '°', '#06B6D4', 8);
    canvas.text(-1.5, 9.7, 'ψ = ' + angleDeg(psi) + '°', '#06B6D4', 8);

    canvas.text(2.5, 10.5, 'u₁=' + u[0].toFixed(1) + '  u₂=' + u[1].toFixed(1), '#F59E0B', 7);
    canvas.text(2.5, 10.1, 'u₃=' + u[2].toFixed(1) + '  u₄=' + u[3].toFixed(1), '#F59E0B', 7);
    canvas.text(2.5, 9.7, 'T = ' + T.toFixed(1) + ' N  (mg=' + (m * 9.81).toFixed(1) + ')', '#64748B', 7);

    // ── Altitude scale ──
    for (let h = 1; h <= 10; h++) {
      canvas.line(5.5, h, 5.7, h, '#334155', 1);
      canvas.text(5.8, h, h + '', '#475569', 6);
    }
  },

  info: `
    <h2>Quadrotor Dynamics — 6-DOF Nonlinear Model</h2>
    <p>A quadrotor with four rotors in a square formation, controlled by adjusting individual rotor speeds.
    The 12-state nonlinear model is derived from Newton-Euler equations, following the standard formulation
    used in nonlinear model predictive control (NMPC).</p>

    <h3>12 State Variables</h3>
    <ul>
      <li><strong>(x, y, z):</strong> Position in the inertial (world) frame. z is altitude.</li>
      <li><strong>(φ, θ, ψ):</strong> Roll, pitch, yaw angles (Euler ZYX convention).</li>
      <li><strong>(ẋ, ẏ, ż):</strong> Linear velocities in the inertial frame.</li>
      <li><strong>(p, q, r):</strong> Angular velocities in the body frame.</li>
    </ul>

    <h3>How Control Works</h3>
    <p>The four rotors produce thrust and torques:</p>
    <ul>
      <li><strong>Total thrust T = k(u₁+u₂+u₃+u₄)</strong> — controls altitude. For hover: T = mg.</li>
      <li><strong>Roll τ_φ = lk(−u₂+u₄)</strong> — differential thrust between left/right rotors tilts the quadrotor sideways.</li>
      <li><strong>Pitch τ_θ = lk(−u₁+u₃)</strong> — differential thrust between front/back rotors tilts forward/backward.</li>
      <li><strong>Yaw τ_ψ = b(−u₁+u₂−u₃+u₄)</strong> — reaction torques from opposite-spinning rotor pairs control heading.</li>
    </ul>
    <p>To move horizontally, the quadrotor <strong>tilts</strong> — the thrust vector gains a horizontal component. This is why pitch and position are coupled.</p>

    <h3>Linear Dynamics</h3>
    <p><code>ξ̈ = [0,0,−g]ᵀ + R·[0,0,T/m]ᵀ</code></p>
    <p>where R is the ZYX rotation matrix. The <span style="color:#22C55E">green thrust arrow</span> shows the thrust direction. The <span style="color:#EF4444">red arrow</span> shows gravity.</p>

    <h3>Angular Dynamics (Euler's Equations)</h3>
    <p><code>ṗ = ((Iyy−Izz)qr + τ_φ)/Ixx</code></p>
    <p><code>q̇ = ((Izz−Ixx)pr + τ_θ)/Iyy</code></p>
    <p><code>ṙ = ((Ixx−Iyy)pq + τ_ψ)/Izz</code></p>
    <p>The cross-coupling terms (Iyy−Izz)qr etc. are <strong>gyroscopic effects</strong> — angular momentum in one axis
    creates torques in another when the body is rotating.</p>

    <h3>Cascaded PD Controller</h3>
    <p>The built-in controller uses two loops:</p>
    <ul>
      <li><strong>Outer loop:</strong> Position error → desired pitch/roll angles</li>
      <li><strong>Inner loop:</strong> Attitude error → rotor commands</li>
    </ul>
    <p>The "Controller Gain" slider scales all PD gains. At 0, no control (pure freefall).
    At 1, nominal. Above 1, aggressive (faster response but may oscillate).</p>

    <h3>Try These</h3>
    <ol>
      <li><strong>Drag the target:</strong> Click and drag the green crosshair to command the quadrotor to a new position.</li>
      <li><strong>Wind disturbance:</strong> Set Wind Force to 2N and watch the controller compensate by tilting into the wind.</li>
      <li><strong>No controller:</strong> Set Controller Gain to 0 — the quadrotor hovers briefly then drifts and falls.</li>
      <li><strong>Heavy quadrotor:</strong> Increase mass to 4kg — the controller works harder (larger thrust) and responds slower.</li>
      <li><strong>Phase plot (z vs ż):</strong> Watch the altitude spiral into the target — underdamped approach visible as the spiral converges.</li>
      <li><strong>Aggressive gains:</strong> Set Controller Gain to 2.5 — faster response but visible oscillation in pitch.</li>
    </ol>

    <h3>Parameters</h3>
    <table style="font-size:0.85em;">
      <tr><td>m = 2 kg</td><td>Quadrotor mass</td></tr>
      <tr><td>l = 0.25 m</td><td>Arm length (center to rotor)</td></tr>
      <tr><td>Ixx = Iyy = 1.2 kg·m²</td><td>Roll/pitch inertia</td></tr>
      <tr><td>Izz = 2.3 kg·m²</td><td>Yaw inertia</td></tr>
      <tr><td>k = 1</td><td>Lift constant (thrust per ω²)</td></tr>
      <tr><td>b = 0.2</td><td>Drag constant (yaw torque per ω²)</td></tr>
      <tr><td>g = 9.81 m/s²</td><td>Gravity</td></tr>
    </table>
  `,
};
