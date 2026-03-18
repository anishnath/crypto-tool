/**
 * Billiards — N balls on a 2D table with elastic collisions.
 *
 * Physics: free motion (no gravity) + friction + circle-circle elastic collision.
 * Ball i: x'' = -friction * vx, y'' = -friction * vy
 * Collision: impulse-based, coefficient of restitution e.
 *
 * State: [x1,y1,vx1,vy1, x2,y2,vx2,vy2, ..., time]
 */

import { resolveCircleCircle, applyCircleCollision, resolveCircleWall } from '../core/collision.js';

const BALL_COLORS = ['#ffffff', '#F59E0B', '#3B82F6', '#EF4444', '#8B5CF6', '#10B981', '#EC4899', '#06B6D4', '#000000'];

export const BilliardsSim = {
  name: 'Billiards',
  slug: 'billiards',
  category: 'Collisions',

  vars: {
    x1: { index: 0, label: 'x₁', symbol: 'x₁' },
    y1: { index: 1, label: 'y₁', symbol: 'y₁' },
    vx1:{ index: 2, label: 'vx₁', symbol: 'vx₁' },
    vy1:{ index: 3, label: 'vy₁', symbol: 'vy₁' },
    x2: { index: 4, label: 'x₂', symbol: 'x₂' },
    y2: { index: 5, label: 'y₂', symbol: 'y₂' },
    time: { index: -1, label: 'Time (s)', symbol: 't' },
  },

  varCount: 4 * 9 + 1, // max 9 balls

  params: {
    numBalls:   { value: 6, min: 2, max: 9, step: 1, label: 'Balls', resetsState: true },
    ballRadius: { value: 0.3, min: 0.1, max: 0.6, step: 0.05, label: 'Ball Radius', unit: 'm' },
    mass:       { value: 1.0, min: 0.1, max: 5, step: 0.1, label: 'Mass', unit: 'kg' },
    friction:   { value: 0.1, min: 0, max: 2, step: 0.01, label: 'Friction' },
    elasticity: { value: 0.95, min: 0, max: 1, step: 0.05, label: 'Elasticity (e)' },
    tableW:     { value: 5.0, hidden: true },
    tableH:     { value: 3.0, hidden: true },
  },

  views: ['sim', 'time', 'energy'],

  graphDefaults: {
    time: ['x1', 'y1'],
  },

  worldRect: { xMin: -5.5, xMax: 5.5, yMin: -3.5, yMax: 3.5 },

  presets: [
    { name: '6 Balls',      params: { numBalls: 6 } },
    { name: '3 Balls',      params: { numBalls: 3 } },
    { name: '9 Balls',      params: { numBalls: 9 } },
    { name: 'No Friction',  params: { friction: 0 } },
    { name: 'High Friction', params: { friction: 0.8 } },
    { name: 'Inelastic',    params: { elasticity: 0.5 } },
    { name: 'Big Balls',    params: { ballRadius: 0.5 } },
  ],

  _getN(params) { return Math.round(params.numBalls); },

  init(p) {
    const N = this._getN(p);
    const state = new Array(4 * N + 1).fill(0);

    // Place balls in triangle formation (like pool) on the right
    const r = p.ballRadius;
    const spacing = r * 2.2;
    let idx = 0;
    let row = 1, placed = 0;
    const startX = 1.5, startY = 0;

    // Cue ball (ball 0) on the left
    state[0] = -3;     // x
    state[1] = 0;      // y
    state[2] = 5;      // vx — shooting right
    state[3] = 0.2;    // vy — slight angle
    idx = 1;

    // Triangle formation
    for (let rowNum = 0; rowNum < N - 1 && idx < N; rowNum++) {
      for (let col = 0; col <= rowNum && idx < N; col++) {
        state[idx * 4] = startX + rowNum * spacing * 0.866;
        state[idx * 4 + 1] = startY + (col - rowNum / 2) * spacing;
        state[idx * 4 + 2] = 0;
        state[idx * 4 + 3] = 0;
        idx++;
      }
    }

    state[4 * N] = 0; // time
    return state;
  },

  evaluate(vars, change, params, isDragging) {
    const N = this._getN(params);
    change[4 * N] = 1;
    if (isDragging) return;

    const { friction: f } = params;

    for (let i = 0; i < N; i++) {
      const vx = vars[i * 4 + 2], vy = vars[i * 4 + 3];
      change[i * 4] = vx;
      change[i * 4 + 1] = vy;
      // Friction: decelerates proportional to velocity
      change[i * 4 + 2] = -f * vx;
      change[i * 4 + 3] = -f * vy;
    }
  },

  postStep(vars, params) {
    const N = this._getN(params);
    const { ballRadius: r, mass: m, elasticity: e, tableW, tableH } = params;
    const walls = { xMin: -tableW, xMax: tableW, yMin: -tableH, yMax: tableH };

    // Circle-circle collisions
    for (let i = 0; i < N; i++) {
      for (let j = i + 1; j < N; j++) {
        const i1 = i * 4, i2 = j * 4;
        const result = resolveCircleCircle(
          vars[i1], vars[i1 + 1], vars[i1 + 2], vars[i1 + 3], r, m,
          vars[i2], vars[i2 + 1], vars[i2 + 2], vars[i2 + 3], r, m,
          e
        );
        if (result) {
          applyCircleCollision(vars, i1, i2, m, m, result);
        }
      }
    }

    // Wall collisions
    for (let i = 0; i < N; i++) {
      resolveCircleWall(vars, i * 4, r, e, walls);
    }
  },

  energy(vars, params) {
    const N = this._getN(params);
    const m = params.mass;
    let KE = 0;
    for (let i = 0; i < N; i++) {
      const vx = vars[i * 4 + 2], vy = vars[i * 4 + 3];
      KE += 0.5 * m * (vx * vx + vy * vy);
    }
    return { kinetic: KE, potential: 0, total: KE };
  },

  hitTest(wx, wy, vars, params) {
    const N = this._getN(params);
    const r = params.ballRadius;
    for (let i = N - 1; i >= 0; i--) {
      if (Math.hypot(wx - vars[i * 4], wy - vars[i * 4 + 1]) < r + 0.2) {
        return { id: i, offsetX: wx - vars[i * 4], offsetY: wy - vars[i * 4 + 1] };
      }
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars) {
    vars[id * 4] = wx - offset.offsetX;
    vars[id * 4 + 1] = wy - offset.offsetY;
    vars[id * 4 + 2] = 0;
    vars[id * 4 + 3] = 0;
  },
  onRelease() {},

  render(canvas, vars, params) {
    const N = this._getN(params);
    const { ballRadius: r, tableW, tableH } = params;

    // Table felt (green area)
    canvas.rect(-tableW, -tableH, tableW * 2, tableH * 2, '#0a4a2e', null);

    // Table edges (brown)
    canvas.line(-tableW, -tableH, tableW, -tableH, '#8B4513', 3);
    canvas.line(-tableW, tableH, tableW, tableH, '#8B4513', 3);
    canvas.line(-tableW, -tableH, -tableW, tableH, '#8B4513', 3);
    canvas.line(tableW, -tableH, tableW, tableH, '#8B4513', 3);

    // Balls
    for (let i = 0; i < N; i++) {
      const bx = vars[i * 4], by = vars[i * 4 + 1];
      const color = BALL_COLORS[i % BALL_COLORS.length];
      canvas.circle(bx, by, r, color, '#ffffff30');
      // Number on ball
      canvas.text(bx - 0.05, by, String(i + 1), i === 0 ? '#333' : '#fff', 8);
    }

    // Total KE readout
    const e = this.energy(vars, params);
    canvas.text(canvas.world.xMin + 0.3, canvas.world.yMax - 0.2,
      'KE=' + e.kinetic.toFixed(2) + 'J', '#ffffff80', 9);
  },

  info: `
    <h2>Billiards — 2D Elastic Collisions</h2>
    <p>Balls colliding on a frictionless (or frictional) table. Each collision is resolved using <strong>impulse-based physics</strong> along the collision normal — the same math that powers every physics engine in video games.</p>

    <h3>Collision Physics</h3>
    <p>When two balls touch, the impulse along the line connecting their centers is:</p>
    <p><code>j = (1+e) · v_rel / (1/m₁ + 1/m₂)</code></p>
    <p>Where <code>v_rel</code> is the relative velocity along the collision normal and <code>e</code> is the coefficient of restitution.</p>
    <p>The tangential velocity (perpendicular to collision) is unchanged — this is why billiard shots can "spin" the ball.</p>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Break shot:</strong> Default — cue ball (white, #1) hits the triangle. Watch momentum and energy transfer</li>
      <li><strong>No friction:</strong> Balls never stop. Energy stays constant (watch the KE readout)</li>
      <li><strong>High friction:</strong> Balls slow rapidly. Observe the exponential velocity decay</li>
      <li><strong>Inelastic:</strong> Set elasticity=0.5 — balls lose KE on each collision, eventually cluster together</li>
      <li><strong>Drag a ball:</strong> Click and drag any ball to reposition it, then release</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Pool/snooker:</strong> Professional players intuitively calculate collision angles and momentum transfer</li>
      <li><strong>Molecular dynamics:</strong> Gas molecules collide like tiny billiard balls — this is the kinetic theory of gases</li>
      <li><strong>Video game physics:</strong> Every game engine (Unity, Unreal) uses the same impulse-based collision math</li>
      <li><strong>Particle accelerators:</strong> Proton-proton collisions at CERN follow the same conservation laws at quantum scale</li>
    </ul>
  `,
};
