/**
 * Newton's Cradle — Pendulum Chain with Elastic Collisions
 *
 * N pendulum bobs hanging side-by-side. Each bob swings independently
 * as a simple pendulum. When adjacent bobs collide, elastic impulse
 * transfers through the chain — the classic desktop toy.
 *
 * Physics:
 *   Between collisions: θ_i'' = -(g/L)sin(θ_i) - b*ω_i
 *   At collision: elastic 1D impulse along the horizontal (tangent at bottom)
 *
 * State: [θ₁,ω₁, θ₂,ω₂, ..., θ_N,ω_N, time]
 */

import { resolveCircleCircle, applyCircleCollision } from '../core/collision.js';

export const NewtonsCradleSim = {
  name: "Newton's Cradle",
  slug: 'newtons-cradle',
  category: 'Collisions',

  vars: {
    theta1: { index: 0, label: 'Angle 1', symbol: 'θ₁' },
    omega1: { index: 1, label: 'Ang Vel 1', symbol: 'ω₁' },
    theta2: { index: 2, label: 'Angle 2', symbol: 'θ₂' },
    omega2: { index: 3, label: 'Ang Vel 2', symbol: 'ω₂' },
    time: { index: -1, label: 'Time (s)', symbol: 't' },
  },

  varCount: 2 * 7 + 1, // max 7 bobs

  params: {
    numBobs:    { value: 5, min: 2, max: 7, step: 1, label: 'Bobs', resetsState: true },
    gravity:    { value: 9.81, min: 1, max: 25, step: 0.1, label: 'Gravity', unit: 'm/s²' },
    length:     { value: 2.0, min: 0.5, max: 4, step: 0.1, label: 'Rod Length', unit: 'm' },
    bobRadius:  { value: 0.2, min: 0.1, max: 0.4, step: 0.05, label: 'Bob Radius', unit: 'm' },
    mass:       { value: 1.0, min: 0.1, max: 5, step: 0.1, label: 'Mass', unit: 'kg' },
    damping:    { value: 0.0, min: 0, max: 1, step: 0.01, label: 'Damping' },
    elasticity: { value: 1.0, min: 0.5, max: 1, step: 0.01, label: 'Elasticity' },
    liftBobs:   { value: 1, min: 1, max: 3, step: 1, label: 'Lift Bobs' },
    liftAngle:  { value: 0.5, min: 0.1, max: 1.2, step: 0.05, label: 'Lift Angle', unit: 'rad' },
  },

  views: ['sim', 'time', 'energy'],

  graphDefaults: {
    time: ['theta1', 'theta2'],
  },

  worldRect: { xMin: -3, xMax: 3, yMin: -3.5, yMax: 0.5 },

  presets: [
    { name: '1 Ball Lift',   params: { liftBobs: 1, liftAngle: 0.5 } },
    { name: '2 Ball Lift',   params: { liftBobs: 2, liftAngle: 0.5 } },
    { name: '3 Ball Lift',   params: { liftBobs: 3, liftAngle: 0.5, numBobs: 7 } },
    { name: 'No Damping',    params: { damping: 0 } },
    { name: 'Some Damping',  params: { damping: 0.05 } },
    { name: 'Inelastic',     params: { elasticity: 0.85 } },
    { name: '3 Bobs',        params: { numBobs: 3, liftBobs: 1 } },
  ],

  _getN(params) { return Math.round(params.numBobs); },

  init(p) {
    const N = this._getN(p);
    const state = new Array(2 * N + 1).fill(0);
    // Lift the first liftBobs to liftAngle
    const lift = Math.min(Math.round(p.liftBobs), N - 1);
    for (let i = 0; i < lift; i++) {
      state[i * 2] = -p.liftAngle; // negative angle = left side
    }
    state[2 * N] = 0; // time
    return state;
  },

  evaluate(vars, change, params, isDragging) {
    const N = this._getN(params);
    change[2 * N] = 1;
    if (isDragging) return;

    const { gravity: g, length: L, damping: b } = params;

    for (let i = 0; i < N; i++) {
      const angle = vars[i * 2];
      const omega = vars[i * 2 + 1];
      change[i * 2] = omega;
      change[i * 2 + 1] = -(g / L) * Math.sin(angle) - b * omega;
    }
  },

  /** Collision detection between adjacent bobs */
  postStep(vars, params) {
    const N = this._getN(params);
    const { length: L, bobRadius: r, mass: m, elasticity: e } = params;

    // Bob spacing (horizontal distance between pivot points)
    const spacing = r * 2.05;

    for (let i = 0; i < N - 1; i++) {
      // Convert angles to bob positions
      const pivotX_i = (i - (N - 1) / 2) * spacing;
      const pivotX_j = (i + 1 - (N - 1) / 2) * spacing;

      const bx_i = pivotX_i + L * Math.sin(vars[i * 2]);
      const by_i = -L * Math.cos(vars[i * 2]);
      const bx_j = pivotX_j + L * Math.sin(vars[(i + 1) * 2]);
      const by_j = -L * Math.cos(vars[(i + 1) * 2]);

      const dist = Math.hypot(bx_j - bx_i, by_j - by_i);

      if (dist < r * 2) {
        // Collision! Convert angular velocities to linear, resolve, convert back
        const vx_i = L * vars[i * 2 + 1] * Math.cos(vars[i * 2]);
        const vy_i = L * vars[i * 2 + 1] * Math.sin(vars[i * 2]);
        const vx_j = L * vars[(i + 1) * 2 + 1] * Math.cos(vars[(i + 1) * 2]);
        const vy_j = L * vars[(i + 1) * 2 + 1] * Math.sin(vars[(i + 1) * 2]);

        const result = resolveCircleCircle(
          bx_i, by_i, vx_i, vy_i, r, m,
          bx_j, by_j, vx_j, vy_j, r, m,
          e
        );

        if (result) {
          // Apply impulse to linear velocities
          const newVx_i = vx_i - (result.impulse / m) * result.nx;
          const newVy_i = vy_i - (result.impulse / m) * result.ny;
          const newVx_j = vx_j + (result.impulse / m) * result.nx;
          const newVy_j = vy_j + (result.impulse / m) * result.ny;

          // Convert back to angular velocity: ω = (v_tangential) / L
          // v_tangential = vx*cos(θ) + vy*sin(θ)
          vars[i * 2 + 1] = (newVx_i * Math.cos(vars[i * 2]) + newVy_i * Math.sin(vars[i * 2])) / L;
          vars[(i + 1) * 2 + 1] = (newVx_j * Math.cos(vars[(i + 1) * 2]) + newVy_j * Math.sin(vars[(i + 1) * 2])) / L;

          // Separate bobs by nudging angles apart
          const overlap = r * 2 - dist;
          if (overlap > 0) {
            vars[i * 2] -= overlap * 0.3 / L;
            vars[(i + 1) * 2] += overlap * 0.3 / L;
          }
        }
      }
    }
  },

  energy(vars, params) {
    const N = this._getN(params);
    const { gravity: g, length: L, mass: m } = params;
    let KE = 0, PE = 0;
    for (let i = 0; i < N; i++) {
      const omega = vars[i * 2 + 1];
      const angle = vars[i * 2];
      KE += 0.5 * m * (L * omega) ** 2;
      PE += m * g * L * (1 - Math.cos(angle));
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  hitTest(wx, wy, vars, params) {
    const N = this._getN(params);
    const { length: L, bobRadius: r } = params;
    const spacing = r * 2.05;

    for (let i = N - 1; i >= 0; i--) {
      const px = (i - (N - 1) / 2) * spacing;
      const bx = px + L * Math.sin(vars[i * 2]);
      const by = -L * Math.cos(vars[i * 2]);
      if (Math.hypot(wx - bx, wy - by) < r + 0.15) {
        return { id: i };
      }
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    const N = this._getN(params);
    const { bobRadius: r } = params;
    const spacing = r * 2.05;
    const px = (id - (N - 1) / 2) * spacing;
    vars[id * 2] = Math.atan2(wx - px, -wy);
    vars[id * 2 + 1] = 0;
  },
  onRelease() {},

  render(canvas, vars, params) {
    const N = this._getN(params);
    const { length: L, bobRadius: r } = params;
    const spacing = r * 2.05;

    // Frame (top bar)
    const frameLeft = -(N / 2) * spacing - 0.5;
    const frameRight = (N / 2) * spacing + 0.5;
    canvas.line(frameLeft, 0, frameRight, 0, '#475569', 3);

    // Rods and bobs
    for (let i = 0; i < N; i++) {
      const px = (i - (N - 1) / 2) * spacing;
      const angle = vars[i * 2];
      const bx = px + L * Math.sin(angle);
      const by = -L * Math.cos(angle);

      // Rod
      canvas.line(px, 0, bx, by, '#94a3b8', 1.5);

      // Bob (silver metallic look)
      canvas.circle(bx, by, r, '#C0C0C0', '#E8E8E8');
    }
  },

  info: `
    <h2>Newton's Cradle — Momentum Chain</h2>
    <p>The classic desktop toy: lift one ball, release it, and the ball on the opposite end swings out while the middle balls stay still. This demonstrates <strong>conservation of both momentum and kinetic energy</strong> simultaneously.</p>

    <h3>How It Works</h3>
    <p>Each ball is a simple pendulum. When the falling ball hits the chain, an elastic collision propagates through the chain at the speed of sound in the material. Because the collision is elastic (e ≈ 1) and all masses are equal:</p>
    <ul>
      <li>Lift 1 ball → 1 ball swings out the other side</li>
      <li>Lift 2 balls → 2 balls swing out</li>
      <li>Lift 3 balls → 3 balls swing out</li>
    </ul>
    <p>This is the ONLY solution that conserves both momentum AND kinetic energy simultaneously.</p>

    <h3>Why Not 2 Balls at Half Speed?</h3>
    <p>If 1 ball hits with momentum p, couldn't 2 balls leave at p/2 each? Momentum is conserved: p = 2·(p/2). But check KE: ½mv² vs 2·½m·(v/2)² = ½·½mv² — only HALF the KE! The elastic constraint forces exactly N balls to leave at the same speed.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>1 ball lift:</strong> Classic — 1 in, 1 out. Energy and momentum both conserved</li>
      <li><strong>2 ball lift:</strong> 2 in, 2 out. The middle balls barely move</li>
      <li><strong>Add damping:</strong> Set damping=0.05 — the oscillation slowly decays as real cradles do</li>
      <li><strong>Inelastic:</strong> Set elasticity=0.85 — after a few swings, all balls move together (energy dissipated)</li>
      <li><strong>Drag a middle ball:</strong> Pull a middle ball sideways — complex coupled dynamics</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Shock absorbers:</strong> Momentum transfer through chains of components</li>
      <li><strong>Acoustic waves:</strong> Sound propagates through solids as chains of elastic collisions between atoms</li>
      <li><strong>Demolition balls:</strong> Wrecking balls transfer momentum to buildings on impact</li>
    </ul>
  `,
};
