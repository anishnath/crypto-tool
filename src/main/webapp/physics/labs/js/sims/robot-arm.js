/**
 * Two-Link Robot Arm — Forward & Inverse Kinematics
 *
 * Forward kinematics:
 *   XE = L1·cos(θ1) + L2·cos(θ1+θ2)
 *   YE = L1·sin(θ1) + L2·sin(θ1+θ2)
 *
 * Inverse kinematics (analytical):
 *   cos(θ2) = (XE²+YE²-L1²-L2²) / (2·L1·L2)
 *   θ2 = atan2(±√(1-cos²θ2), cosθ2)   [elbow up / elbow down]
 *   θ1 = atan2(YE,XE) - atan2(L2·sinθ2, L1+L2·cosθ2)
 *
 * Jacobian:
 *   J = [[-L1·sinθ1 - L2·sin(θ1+θ2), -L2·sin(θ1+θ2)],
 *        [ L1·cosθ1 + L2·cos(θ1+θ2),  L2·cos(θ1+θ2)]]
 *   det(J) = L1·L2·sin(θ2)   → singularity at θ2=0,π
 *
 * Motion control: dθ/dt = J⁻¹ · K · (target - end_effector)
 *
 * State: [θ1, θ2, time, XE, YE, detJ]
 */

export const RobotArmSim = {
  name: 'Two-Link Robot Arm',
  slug: 'robot-arm',
  category: 'Mechanics',

  vars: {
    theta1: { index: 0, label: 'Joint 1 Angle θ₁ (rad)',  symbol: 'θ₁' },
    theta2: { index: 1, label: 'Joint 2 Angle θ₂ (rad)',  symbol: 'θ₂' },
    time:   { index: 2, label: 'Time (s)',                 symbol: 't' },
    xe:     { index: 3, label: 'End Effector X (m)',       symbol: 'XE' },
    ye:     { index: 4, label: 'End Effector Y (m)',       symbol: 'YE' },
    detJ:   { index: 5, label: 'det(J)',                   symbol: '|J|' },
  },
  varCount: 6,

  params: {
    L1:       { value: 1.0, min: 0.3, max: 2,  step: 0.1, label: 'Link 1 Length L₁', unit: 'm' },
    L2:       { value: 0.5, min: 0.2, max: 1.5,step: 0.1, label: 'Link 2 Length L₂', unit: 'm' },
    targetX:  { value: 1.0, min: -2,  max: 2,  step: 0.05,label: 'Target X',         unit: 'm' },
    targetY:  { value: 0.8, min: -2,  max: 2,  step: 0.05,label: 'Target Y',         unit: 'm' },
    gain:     { value: 5,   min: 1,   max: 20, step: 1,   label: 'Control Gain K',   unit: '' },
    elbowSign:{ value: 1,   min: -1,  max: 1,  step: 2,   label: 'Elbow (1=up −1=dn)',unit: '' },
    trajMode: { value: 0,   min: 0,   max: 2,  step: 1,   label: 'Traj (0=drag 1=circle 2=fig8)', unit: '' },
    showGhost:{ value: true, type: 'bool', label: 'Show Alternate Solution' },
  },

  views: ['sim', 'phase', 'time'],

  graphDefaults: {
    phase: { x: 'xe', y: 'ye' },
    time: ['theta1', 'theta2', 'detJ'],
  },

  worldRect: { xMin: -2.2, xMax: 2.2, yMin: -1.8, yMax: 2.2 },

  presets: [
    { name: 'Default',                    params: {} },
    { name: 'Equal Links (L1=L2=1)',      params: { L1: 1, L2: 1, targetX: 1.2, targetY: 1 } },
    { name: 'Near Singularity (straight)',params: { targetX: 1.45, targetY: 0.2 } },
    { name: 'Folded (near inner limit)',  params: { targetX: 0.3, targetY: 0.3 } },
    { name: 'Circle Trajectory',          params: { trajMode: 1 } },
    { name: 'Figure-8 Trajectory',        params: { trajMode: 2 } },
    { name: 'Elbow Down',                 params: { elbowSign: -1 } },
    { name: 'Long Reach (L1=1.5,L2=1)',   params: { L1: 1.5, L2: 1, targetX: 1.5, targetY: 1.5 } },
  ],

  /** Forward kinematics: angles → end effector */
  _fk(theta1, theta2, L1, L2) {
    return [
      L1 * Math.cos(theta1) + L2 * Math.cos(theta1 + theta2),
      L1 * Math.sin(theta1) + L2 * Math.sin(theta1 + theta2),
    ];
  },

  /** Analytical inverse kinematics: end effector → angles */
  _ik(tx, ty, L1, L2, elbowSign) {
    const r2 = tx * tx + ty * ty;
    const r = Math.sqrt(r2);
    const rMax = L1 + L2, rMin = Math.abs(L1 - L2);
    // Clamp to reachable workspace
    if (r > rMax || r < rMin) {
      // Project onto workspace boundary (just inside)
      const rClamp = Math.max(rMin + 0.001, Math.min(rMax - 0.001, r));
      const scale = rClamp / (r || 1);
      tx *= scale; ty *= scale;
    }
    const r2c = tx * tx + ty * ty;
    let cosT2 = (r2c - L1 * L1 - L2 * L2) / (2 * L1 * L2);
    cosT2 = Math.max(-1, Math.min(1, cosT2));
    const sinT2 = elbowSign * Math.sqrt(Math.max(0, 1 - cosT2 * cosT2));
    const theta2 = Math.atan2(sinT2, cosT2);
    const theta1 = Math.atan2(ty, tx) - Math.atan2(L2 * sinT2, L1 + L2 * cosT2);
    return [theta1, theta2];
  },

  /** Compute effective target based on trajectory mode */
  _target(t, params) {
    const { targetX, targetY, trajMode, L1, L2 } = params;
    if (trajMode === 1) {
      // Circle: center at (0.7, 0.7), radius 0.3
      const r = 0.3, cx = 0.7, cy = 0.7, w = 2 * Math.PI / 5;
      return [cx + r * Math.cos(w * t), cy + r * Math.sin(w * t)];
    } else if (trajMode === 2) {
      // Figure-8
      const w = 2 * Math.PI / 6;
      return [0.7 + 0.4 * Math.sin(w * t), 0.5 + 0.3 * Math.sin(2 * w * t)];
    }
    return [targetX, targetY];
  },

  init(params) {
    const th1 = Math.PI / 4, th2 = -Math.PI / 4;
    const L1 = params?.L1 ?? 1, L2 = params?.L2 ?? 0.5;
    const [xe, ye] = this._fk(th1, th2, L1, L2);
    const det = L1 * L2 * Math.sin(th2);
    return [th1, th2, 0, xe, ye, det];
  },

  evaluate(vars, change, params, isDragging) {
    change[2] = 1; // time
    change[3] = 0; change[4] = 0; change[5] = 0; // derived in postStep
    if (isDragging) { change[0] = 0; change[1] = 0; return; }

    const [theta1, theta2, t] = vars;
    const { L1, L2, gain } = params;

    // Current end effector
    const [xe, ye] = this._fk(theta1, theta2, L1, L2);

    // Target
    const [tx, ty] = this._target(t, params);

    // Error
    const ex = tx - xe, ey = ty - ye;

    // Jacobian
    const s1 = Math.sin(theta1), c1 = Math.cos(theta1);
    const s12 = Math.sin(theta1 + theta2), c12 = Math.cos(theta1 + theta2);
    const J11 = -L1 * s1 - L2 * s12;
    const J12 = -L2 * s12;
    const J21 = L1 * c1 + L2 * c12;
    const J22 = L2 * c12;

    // Damped inverse: floor |det| to avoid singularity blowup
    let det = J11 * J22 - J12 * J21; // = L1*L2*sin(θ2)
    const minDet = 0.01;
    if (Math.abs(det) < minDet) det = det < 0 ? -minDet : minDet;

    // Joint velocities: ω = J⁻¹ · K · error
    const w1 = gain * (J22 * ex - J12 * ey) / det;
    const w2 = gain * (-J21 * ex + J11 * ey) / det;

    // Clamp to prevent wild spinning
    const maxW = 8;
    change[0] = Math.max(-maxW, Math.min(maxW, w1));
    change[1] = Math.max(-maxW, Math.min(maxW, w2));
  },

  postStep(vars, params) {
    const { L1, L2 } = params;
    const [xe, ye] = this._fk(vars[0], vars[1], L1, L2);
    vars[3] = xe;
    vars[4] = ye;
    vars[5] = L1 * L2 * Math.sin(vars[1]); // det(J)
  },

  energy() { return { kinetic: 0, potential: 0, total: 0 }; },
  theoreticalPeriod() { return Infinity; },

  hitTest(wx, wy, vars, params) {
    const { L1, L2 } = params;
    const [th1, th2] = vars;
    // Target checked first (so it's always draggable even when EE has converged)
    const [tx, ty] = this._target(vars[2], params);
    if (Math.hypot(wx - tx, wy - ty) < 0.2) return { id: 'target' };
    // End effector (smaller radius to avoid overlap with target)
    const [ex, ey] = this._fk(th1, th2, L1, L2);
    if (Math.hypot(wx - ex, wy - ey) < 0.12) return { id: 'ee' };
    // Elbow
    const elbX = L1 * Math.cos(th1), elbY = L1 * Math.sin(th1);
    if (Math.hypot(wx - elbX, wy - elbY) < 0.15) return { id: 'elbow' };
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    if (id === 'target') {
      params.targetX = wx;
      params.targetY = wy;
      params.trajMode = 0; // switch to drag mode
    } else if (id === 'ee') {
      // Direct IK snap
      const [th1, th2] = this._ik(wx, wy, params.L1, params.L2, params.elbowSign);
      vars[0] = th1;
      vars[1] = th2;
      params.targetX = wx;
      params.targetY = wy;
      params.trajMode = 0;
    } else if (id === 'elbow') {
      // Drag elbow → set θ1 only
      vars[0] = Math.atan2(wy, wx);
    }
  },

  onRelease() {},

  render(canvas, vars, params) {
    const [theta1, theta2, t] = vars;
    const { L1, L2, showGhost, elbowSign } = params;

    // Joint positions
    const elbX = L1 * Math.cos(theta1);
    const elbY = L1 * Math.sin(theta1);
    const [eeX, eeY] = this._fk(theta1, theta2, L1, L2);

    // Target
    const [tx, ty] = this._target(t, params);

    // ── Workspace boundary ──
    const rMax = L1 + L2, rMin = Math.abs(L1 - L2);
    // Outer boundary
    for (let i = 0; i < 64; i++) {
      const a1 = (2 * Math.PI * i) / 64;
      const a2 = (2 * Math.PI * (i + 1)) / 64;
      canvas.line(rMax * Math.cos(a1), rMax * Math.sin(a1),
                  rMax * Math.cos(a2), rMax * Math.sin(a2), '#1E293B', 1);
    }
    // Inner boundary (if L1 ≠ L2)
    if (rMin > 0.05) {
      for (let i = 0; i < 48; i++) {
        if (i % 2) continue;
        const a1 = (2 * Math.PI * i) / 48;
        const a2 = (2 * Math.PI * (i + 1)) / 48;
        canvas.line(rMin * Math.cos(a1), rMin * Math.sin(a1),
                    rMin * Math.cos(a2), rMin * Math.sin(a2), '#1E293B', 0.8);
      }
    }

    // ── Axes ──
    canvas.line(-2, 0, 2, 0, '#1E293B', 0.8);
    canvas.line(0, -1.5, 0, 2, '#1E293B', 0.8);

    // ── Ghost arm (alternate IK solution) ──
    if (showGhost) {
      const [gth1, gth2] = this._ik(eeX, eeY, L1, L2, -elbowSign);
      const gElbX = L1 * Math.cos(gth1), gElbY = L1 * Math.sin(gth1);
      const [geeX, geeY] = this._fk(gth1, gth2, L1, L2);
      canvas.line(0, 0, gElbX, gElbY, 'rgba(139,92,246,0.2)', 3);
      canvas.line(gElbX, gElbY, geeX, geeY, 'rgba(6,182,212,0.2)', 3);
      canvas.circle(gElbX, gElbY, 0.06, 'rgba(148,163,184,0.2)', null);
      canvas.circle(geeX, geeY, 0.06, 'rgba(148,163,184,0.2)', null);
    }

    // ── Target ──
    canvas.line(tx - 0.12, ty, tx + 0.12, ty, '#22C55E', 2);
    canvas.line(tx, ty - 0.12, tx, ty + 0.12, '#22C55E', 2);
    canvas.circle(tx, ty, 0.08, null, '#22C55E');

    // ── Arm links ──
    // Link 1 (base to elbow)
    canvas.line(0, 0, elbX, elbY, '#8B5CF6', 4);
    // Link 2 (elbow to end effector)
    canvas.line(elbX, elbY, eeX, eeY, '#06B6D4', 4);

    // ── Joints ──
    // Base (fixed)
    canvas.circle(0, 0, 0.08, '#475569', '#94A3B8');
    canvas.line(-0.1, -0.12, 0.1, -0.12, '#475569', 2); // ground indicator
    // Elbow
    canvas.circle(elbX, elbY, 0.06, '#94A3B8', '#CBD5E1');
    // End effector
    canvas.circle(eeX, eeY, 0.07, '#F59E0B', '#FCD34D');

    // ── Angle arcs ──
    // θ1: from x-axis to link 1
    if (Math.abs(theta1) > 0.03) {
      const arcR = 0.35;
      canvas.arc(0, 0, arcR, Math.min(0, theta1), Math.max(0, theta1), '#8B5CF6', 1.5);
      const labelA = theta1 / 2;
      canvas.text(arcR * 1.1 * Math.cos(labelA), arcR * 1.1 * Math.sin(labelA), 'θ₁', '#8B5CF6', 10);
    }
    // θ2: from link 1 direction to link 2
    if (Math.abs(theta2) > 0.05) {
      const arcR2 = 0.25;
      const base = theta1;
      canvas.arc(elbX, elbY, arcR2, Math.min(base, base + theta2), Math.max(base, base + theta2), '#06B6D4', 1.5);
      const labelA2 = theta1 + theta2 / 2;
      canvas.text(elbX + arcR2 * 1.2 * Math.cos(labelA2), elbY + arcR2 * 1.2 * Math.sin(labelA2), 'θ₂', '#06B6D4', 9);
    }

    // ── Jacobian singularity indicator ──
    const detJ = L1 * L2 * Math.sin(theta2);
    const singularity = Math.abs(detJ) < 0.05;
    if (singularity) {
      canvas.text(eeX + 0.15, eeY + 0.15, 'SINGULARITY', '#EF4444', 10);
    }

    // ── Readouts ──
    const deg1 = (theta1 * 180 / Math.PI).toFixed(1);
    const deg2 = (theta2 * 180 / Math.PI).toFixed(1);
    canvas.text(-2.1, 2.05, 'θ₁ = ' + deg1 + '°', '#8B5CF6', 12);
    canvas.text(-2.1, 1.8, 'θ₂ = ' + deg2 + '°', '#06B6D4', 12);
    canvas.text(-2.1, 1.55, 'EE = (' + eeX.toFixed(2) + ', ' + eeY.toFixed(2) + ')', '#94A3B8', 10);
    canvas.text(-2.1, 1.35, 'det(J) = ' + detJ.toFixed(3), singularity ? '#EF4444' : '#64748B', 10);

    // Target info
    const dist = Math.hypot(tx - eeX, ty - eeY);
    canvas.text(0.8, 2.05, 'Target (' + tx.toFixed(2) + ', ' + ty.toFixed(2) + ')', '#22C55E', 10);
    canvas.text(0.8, 1.8, 'Error: ' + (dist * 1000).toFixed(1) + ' mm', dist < 0.01 ? '#22C55E' : '#F59E0B', 10);

    const trajLabels = ['Drag', 'Circle', 'Figure-8'];
    canvas.text(0.8, 1.55, 'Mode: ' + trajLabels[Math.round(params.trajMode)], '#64748B', 9);
  },

  info: `
    <h2>Two-Link Robot Arm — Forward & Inverse Kinematics</h2>
    <p>A planar two-link robot arm demonstrating the core concepts of robot kinematics.
    The arm consists of two rigid links connected by revolute joints, with the base fixed at the origin.</p>

    <h3>Forward Kinematics</h3>
    <p>Given joint angles (θ₁, θ₂), the end effector position is:</p>
    <p><code>XE = L₁·cos(θ₁) + L₂·cos(θ₁+θ₂)</code></p>
    <p><code>YE = L₁·sin(θ₁) + L₂·sin(θ₁+θ₂)</code></p>

    <h3>Inverse Kinematics</h3>
    <p>Given a target (XE, YE), the joint angles are found analytically:</p>
    <p><code>cos(θ₂) = (XE²+YE²−L₁²−L₂²) / (2·L₁·L₂)</code></p>
    <p><code>θ₂ = atan2(±√(1−cos²θ₂), cos θ₂)</code></p>
    <p><code>θ₁ = atan2(YE,XE) − atan2(L₂·sin θ₂, L₁+L₂·cos θ₂)</code></p>
    <p>The ± sign gives <strong>two solutions</strong>: elbow-up and elbow-down. The ghost arm shows the alternate solution.</p>

    <h3>System Jacobian</h3>
    <p>The Jacobian relates joint velocities to end-effector velocity:</p>
    <pre style="font-size:0.85em;">
    [ẊE]         [−L₁sinθ₁−L₂sin(θ₁+θ₂)  −L₂sin(θ₁+θ₂)] [θ̇₁]
    [ẎE] = J · = [ L₁cosθ₁+L₂cos(θ₁+θ₂)   L₂cos(θ₁+θ₂)] [θ̇₂]</pre>
    <p><strong>det(J) = L₁·L₂·sin(θ₂)</strong></p>
    <p>When θ₂ = 0 or π, det(J) = 0 → <strong style="color:#EF4444;">singularity</strong>. The arm is fully extended or folded,
    and certain end-effector velocities become impossible.</p>

    <h3>Velocity Control</h3>
    <p>The arm moves toward the target using Jacobian-based velocity control:</p>
    <p><code>[θ̇₁, θ̇₂]ᵀ = J⁻¹ · K · (target − end_effector)</code></p>
    <p>The gain K controls how quickly the arm converges. Near singularities, the inverse is damped to prevent wild joint motions.</p>

    <h3>Workspace</h3>
    <ul>
      <li><strong>Outer boundary</strong> (solid circle): radius L₁+L₂ — maximum reach</li>
      <li><strong>Inner boundary</strong> (dashed circle): radius |L₁−L₂| — unreachable hole when L₁ ≠ L₂</li>
    </ul>

    <h3>Try These</h3>
    <ol>
      <li><strong>Drag the target</strong> (green crosshair) and watch the arm follow via Jacobian control.</li>
      <li><strong>Drag the end effector</strong> (yellow dot) for instant IK snapping.</li>
      <li><strong>Near singularity:</strong> Move the target to the workspace boundary. Watch det(J) → 0 and the arm slow down.</li>
      <li><strong>Elbow flip:</strong> Set Elbow = −1 to see the alternate IK solution. The ghost arm shows the other one.</li>
      <li><strong>Circle trajectory:</strong> Set Traj = 1. Watch the arm smoothly trace a circle, with joint angles changing continuously.</li>
      <li><strong>Figure-8:</strong> Set Traj = 2. Observe how the arm handles the complex path, especially near singularities.</li>
      <li><strong>Phase plot:</strong> Switch to Phase tab (XE vs YE) to see the end effector trace in Cartesian space.</li>
      <li><strong>Equal links:</strong> Set L₁ = L₂ = 1. The inner hole vanishes — the arm can reach the origin.</li>
    </ol>
  `,
};
