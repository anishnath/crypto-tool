/**
 * Colliding Blocks — 1D Elastic Collisions
 *
 * Two blocks on a track with a spring on block 1. Block-block and
 * block-wall collisions demonstrate momentum and energy conservation.
 *
 * Physics:
 *   Block 1: x₁'' = -(k/m₁)(x₁ - wall_L - R) - (b/m₁)v₁
 *   Block 2: x₂'' = -(b/m₂)v₂  (free, no spring)
 *   Collision: elastic — velocities reflected in center-of-mass frame
 *
 * Reference: myphysicslab/src/sims/springs/CollideBlocksSim.ts
 *
 * State: [x1, v1, x2, v2, time]
 */

export const CollideBlocksSim = {
  name: 'Colliding Blocks',
  slug: 'collide-blocks',
  category: 'Collisions',

  vars: {
    x1: { index: 0, label: 'Position 1 (m)',  symbol: 'x₁' },
    v1: { index: 1, label: 'Velocity 1 (m/s)',symbol: 'v₁' },
    x2: { index: 2, label: 'Position 2 (m)',  symbol: 'x₂' },
    v2: { index: 3, label: 'Velocity 2 (m/s)',symbol: 'v₂' },
    time: { index: 4, label: 'Time (s)',       symbol: 't' },
  },
  varCount: 5,

  params: {
    mass1:      { value: 0.5, min: 0.1, max: 10, step: 0.1, label: 'Mass 1',       unit: 'kg' },
    mass2:      { value: 1.5, min: 0.1, max: 10, step: 0.1, label: 'Mass 2',       unit: 'kg' },
    stiffness:  { value: 6.0, min: 0, max: 30,   step: 0.5, label: 'Spring k',     unit: 'N/m' },
    restLength: { value: 2.5, min: 0.5, max: 5,  step: 0.1, label: 'Rest Length',  unit: 'm' },
    damping:    { value: 0,   min: 0, max: 2,    step: 0.01,label: 'Damping' },
    elasticity: { value: 1.0, min: 0, max: 1,    step: 0.05,label: 'Elasticity (e)' },
    wallLeft:   { value: -4,  hidden: true },
    wallRight:  { value: 8,   hidden: true },
  },

  views: ['sim', 'phase', 'time', 'energy'],

  graphDefaults: {
    phase: { x: 'x1', y: 'v1' },
    time: ['v1', 'v2'],
  },

  worldRect: { xMin: -5, xMax: 9, yMin: -2, yMax: 2 },

  presets: [
    { name: 'Default',        params: {} },
    { name: 'Equal Mass',     params: { mass1: 1, mass2: 1 } },
    { name: 'Heavy vs Light', params: { mass1: 5, mass2: 0.5 } },
    { name: 'Light vs Heavy', params: { mass1: 0.5, mass2: 5 } },
    { name: 'Inelastic',      params: { elasticity: 0.5 } },
    { name: 'Perfectly Inelastic', params: { elasticity: 0 } },
    { name: 'No Spring',      params: { stiffness: 0 } },
  ],

  init(p) {
    // Block 1 at rest at spring equilibrium, block 2 approaching from right
    const x1eq = p.wallLeft + p.restLength;
    return [x1eq, 0, 5, -3, 0];
  },

  evaluate(vars, change, params, isDragging) {
    change[4] = 1;
    if (isDragging) return;

    const [x1, v1, x2, v2] = vars;
    const { mass1, mass2, stiffness: k, restLength: R, damping: b, wallLeft } = params;

    // Block 1: spring attached to left wall
    const stretch = x1 - wallLeft - R;
    change[0] = v1;
    change[1] = (-k * stretch - b * v1) / mass1;

    // Block 2: free (no spring, just damping)
    change[2] = v2;
    change[3] = (-b * v2) / mass2;
  },

  /** Handle collisions after each solver step */
  postStep(vars, params) {
    const { mass1: m1, mass2: m2, elasticity: e, wallLeft, wallRight } = params;
    // Half-widths match rendering: 0.25 * sqrt(mass)
    const bw1 = 0.25 * Math.sqrt(m1);
    const bw2 = 0.25 * Math.sqrt(m2);

    // Block 1 - left wall
    if (vars[0] - bw1 < wallLeft) {
      vars[0] = wallLeft + bw1;
      vars[1] = -vars[1] * e;
    }

    // Block 2 - right wall
    if (vars[2] + bw2 > wallRight) {
      vars[2] = wallRight - bw2;
      vars[3] = -vars[3] * e;
    }

    // Block-block collision (block 1 right edge hits block 2 left edge)
    if (vars[0] + bw1 > vars[2] - bw2) {
      // Mass-proportional separation (correct for momentum)
      const overlap = (vars[0] + bw1) - (vars[2] - bw2);
      vars[0] -= overlap * m2 / (m1 + m2);
      vars[2] += overlap * m1 / (m1 + m2);

      // Elastic collision with coefficient of restitution e
      const vcm = (m1 * vars[1] + m2 * vars[3]) / (m1 + m2);
      const v1rel = vars[1] - vcm;
      const v2rel = vars[3] - vcm;
      vars[1] = vcm - e * v1rel;
      vars[3] = vcm - e * v2rel;
    }
  },

  energy(vars, params) {
    const [x1, v1, x2, v2] = vars;
    const { mass1, mass2, stiffness: k, restLength: R, wallLeft } = params;
    const stretch = x1 - wallLeft - R;
    const KE = 0.5 * mass1 * v1 * v1 + 0.5 * mass2 * v2 * v2;
    const PE = 0.5 * k * stretch * stretch;
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  hitTest(wx, wy, vars, params) {
    if (Math.hypot(wx - vars[0], wy) < 0.5) return { id: 'block1', offsetX: wx - vars[0], offsetY: wy };
    if (Math.hypot(wx - vars[2], wy) < 0.5) return { id: 'block2', offsetX: wx - vars[2], offsetY: wy };
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    if (id === 'block1') { vars[0] = wx - offset.offsetX; vars[1] = 0; }
    if (id === 'block2') { vars[2] = wx - offset.offsetX; vars[3] = 0; }
  },
  onRelease() {},

  theoreticalPeriod(params) {
    if (params.stiffness <= 0) return 0;
    return 2 * Math.PI * Math.sqrt(params.mass1 / params.stiffness);
  },
  periodVar: 1,

  render(canvas, vars, params) {
    const [x1, , x2] = vars;
    const { wallLeft, wallRight, mass1, mass2 } = params;
    const bw1 = 0.25 * Math.sqrt(mass1), bw2 = 0.25 * Math.sqrt(mass2);

    // Walls
    canvas.rect(wallLeft - 0.15, -1, 0.15, 2, '#475569', null);
    canvas.rect(wallRight, -1, 0.15, 2, '#475569', null);

    // Spring (wall to block 1)
    canvas.spring(wallLeft, 0, x1 - bw1, 0, 12, 0.15, '#10B981');

    // Block 1 (violet)
    canvas.rect(x1 - bw1, -bw1, bw1 * 2, bw1 * 2, '#8B5CF6', '#A78BFA');
    canvas.text(x1, bw1 + 0.15, 'm₁', '#A78BFA', 9);

    // Block 2 (cyan)
    canvas.rect(x2 - bw2, -bw2, bw2 * 2, bw2 * 2, '#06B6D4', '#22D3EE');
    canvas.text(x2, bw2 + 0.15, 'm₂', '#22D3EE', 9);

    // Momentum readout
    const p1 = params.mass1 * vars[1], p2 = params.mass2 * vars[3];
    canvas.text(canvas.world.xMin + 0.3, canvas.world.yMax - 0.2,
      'p₁=' + p1.toFixed(2) + '  p₂=' + p2.toFixed(2) + '  Σp=' + (p1 + p2).toFixed(2),
      '#94a3b8', 9);
  },

  info: `
    <h2>Colliding Blocks — Momentum & Energy</h2>
    <p>Two blocks on a frictionless track. Block 1 is attached to a wall by a spring. Block 2 slides freely. When they collide, momentum is exchanged. This is the classic demonstration of <strong>conservation of momentum</strong>.</p>

    <h3>Collision Physics</h3>
    <p>During collision, the coefficient of restitution <code>e</code> determines energy transfer:</p>
    <ul>
      <li><strong>e = 1 (elastic):</strong> Total kinetic energy conserved. Velocities swap in equal-mass case</li>
      <li><strong>0 &lt; e &lt; 1 (inelastic):</strong> Some kinetic energy lost to "deformation"</li>
      <li><strong>e = 0 (perfectly inelastic):</strong> Blocks stick together, maximum KE loss. Momentum still conserved!</li>
    </ul>
    <p>Collision formula: <code>v₁' = v_cm - e·(v₁ - v_cm)</code> where <code>v_cm = (m₁v₁ + m₂v₂)/(m₁+m₂)</code></p>

    <h3>Momentum is Always Conserved</h3>
    <p>Watch the <strong>momentum readout</strong> (top of canvas): <code>Σp = m₁v₁ + m₂v₂</code> stays constant through every collision, even when e = 0. This is Newton's Third Law in action — the impulse on block 1 equals and opposite to the impulse on block 2.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Equal mass elastic:</strong> "Equal Mass" preset — block 2 hits block 1, block 2 stops dead, block 1 takes all the velocity. Complete energy transfer!</li>
      <li><strong>Heavy hits light:</strong> "Heavy vs Light" — heavy block barely slows down, light block flies away fast</li>
      <li><strong>Light hits heavy:</strong> "Light vs Heavy" — light block bounces back, heavy block barely moves</li>
      <li><strong>Inelastic:</strong> Set e=0.5 — blocks partially stick. Watch KE decrease on Energy tab while momentum (top readout) stays constant</li>
      <li><strong>Perfectly inelastic:</strong> e=0 — blocks move together after collision. Maximum KE loss, but Σp unchanged</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Newton's cradle:</strong> Chain of elastic collisions — momentum transfers through the line</li>
      <li><strong>Car crashes:</strong> Inelastic collisions — crumple zones absorb KE to protect passengers</li>
      <li><strong>Billiards:</strong> Nearly elastic collisions between pool balls</li>
      <li><strong>Particle physics:</strong> Proton-proton collisions at CERN follow the same conservation laws</li>
    </ul>
  `,
};
