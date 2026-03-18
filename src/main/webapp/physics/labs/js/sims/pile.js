/**
 * Pile — Stacking Rigid Bodies
 *
 * Drop polygon shapes onto a floor. They stack, tumble, collide.
 * Uses the Engine2D rigid body system with SAT collision detection.
 *
 * State: flat array — not ODE-based, uses its own integration loop.
 */

import { RigidBody, rectangleShape, regularPolygon } from '../core/rigid-body.js';
import { satTest, resolveRigidCollision, resolveRigidWall } from '../core/contact-solver.js';

const COLORS = ['#8B5CF6', '#06B6D4', '#EF4444', '#F59E0B', '#10B981', '#EC4899', '#3B82F6', '#A78BFA'];

export const PileSim = {
  name: 'Pile',
  slug: 'pile',
  category: 'Rigid Body',

  vars: {
    x1: { index: 0, label: 'x₁', symbol: 'x₁' },
    y1: { index: 1, label: 'y₁', symbol: 'y₁' },
    time: { index: -1, label: 'Time (s)', symbol: 't' },
  },
  varCount: 100, // placeholder

  params: {
    numBodies:    { value: 8, min: 3, max: 15, step: 1, label: 'Bodies', resetsState: true },
    gravity:      { value: 9.81, min: 0, max: 25, step: 0.5, label: 'Gravity', unit: 'm/s²' },
    restitution:  { value: 0.3, min: 0, max: 1, step: 0.05, label: 'Bounciness' },
    friction:     { value: 0.4, min: 0, max: 1, step: 0.05, label: 'Friction' },
    attract:      { value: 0, min: 0, max: 20, step: 0.5, label: 'Mutual Attract' },
    bodyType:     { value: 'mixed', type: 'choice', options: ['mixed', 'boxes', 'triangles', 'pentagons'], label: 'Shape Type' },
  },

  views: ['sim', 'energy'],

  graphDefaults: { time: ['x1', 'y1'] },

  worldRect: { xMin: -5, xMax: 5, yMin: -3, yMax: 3 },

  presets: [
    { name: 'Mixed Pile',   params: {} },
    { name: 'Box Stack',    params: { bodyType: 'boxes', numBodies: 10 } },
    { name: 'Triangles',    params: { bodyType: 'triangles', numBodies: 8 } },
    { name: 'Bouncy',       params: { restitution: 0.8, friction: 0.1 } },
    { name: 'Sticky',       params: { restitution: 0, friction: 0.8 } },
    { name: 'No Gravity',   params: { gravity: 0 } },
    { name: 'Attract',      params: { attract: 8, gravity: 0, numBodies: 6 } },
    { name: 'Attract+Grav', params: { attract: 5, gravity: 5, numBodies: 8 } },
  ],

  // Internal rigid body array
  _bodies: [],
  _time: 0,
  _walls: { xMin: -4.5, xMax: 4.5, yMin: -2.5, yMax: 100 },

  _makeShape(type, index) {
    if (type === 'boxes') return rectangleShape(0.5 + Math.random() * 0.3, 0.5 + Math.random() * 0.3);
    if (type === 'triangles') return regularPolygon(3, 0.4 + Math.random() * 0.2);
    if (type === 'pentagons') return regularPolygon(5, 0.35 + Math.random() * 0.15);
    // mixed
    const shapes = [
      () => rectangleShape(0.5 + Math.random() * 0.4, 0.4 + Math.random() * 0.3),
      () => regularPolygon(3, 0.35 + Math.random() * 0.2),
      () => regularPolygon(5, 0.3 + Math.random() * 0.15),
      () => regularPolygon(6, 0.3 + Math.random() * 0.1),
    ];
    return shapes[index % shapes.length]();
  },

  init(p) {
    const N = Math.round(p.numBodies);
    const bodies = [];

    // Arrange in a wide grid — more columns, fewer rows (landscape canvas)
    const cols = Math.min(N, Math.ceil(N / 2));
    for (let i = 0; i < N; i++) {
      const col = i % cols;
      const row = Math.floor(i / cols);
      const shape = this._makeShape(p.bodyType, i);
      bodies.push(new RigidBody({
        vertices: shape,
        mass: 1 + Math.random() * 2,
        x: (col - (cols - 1) / 2) * 1.0 + (Math.random() - 0.5) * 0.2,
        y: 1.5 + row * 1.0,
        angle: Math.random() * Math.PI * 0.5,
        color: COLORS[i % COLORS.length],
      }));
    }

    this._bodies = bodies;
    this._time = 0;

    // Build state array for graphs (x,y of each body + time)
    const state = new Array(N * 2 + 1).fill(0);
    for (let i = 0; i < N; i++) {
      state[i * 2] = bodies[i].x;
      state[i * 2 + 1] = bodies[i].y;
    }
    state[N * 2] = 0;
    return state;
  },

  // Dummy evaluate — physics happens in postStep
  evaluate(vars, change, params) {
    const N = Math.round(params.numBodies);
    for (let i = 0; i <= N * 2; i++) change[i] = 0;
    change[N * 2] = 1;
  },

  postStep(vars, params) {
    const bodies = this._bodies;
    if (!bodies || bodies.length === 0) return;

    const { gravity, restitution: e, friction: mu, attract } = params;
    const dt = 1 / 120;
    const substeps = 2;

    for (let sub = 0; sub < substeps; sub++) {
      // Mutual attraction (gravity-like force between bodies)
      if (attract > 0) {
        for (let i = 0; i < bodies.length; i++) {
          for (let j = i + 1; j < bodies.length; j++) {
            const a = bodies[i], b = bodies[j];
            if (a.isStatic || b.isStatic) continue;
            const dx = b.x - a.x, dy = b.y - a.y;
            const dist2 = dx * dx + dy * dy;
            if (dist2 < 0.1) continue;
            const dist = Math.sqrt(dist2);
            const force = attract * a.mass * b.mass / dist2;
            const fx = force * dx / dist, fy = force * dy / dist;
            a.vx += fx / a.mass * (dt / substeps);
            a.vy += fy / a.mass * (dt / substeps);
            b.vx -= fx / b.mass * (dt / substeps);
            b.vy -= fy / b.mass * (dt / substeps);
          }
        }
      }

      // Integrate
      for (const b of bodies) {
        b.integrate(dt / substeps, -gravity);
      }

      // Body-body collisions
      for (let i = 0; i < bodies.length; i++) {
        for (let j = i + 1; j < bodies.length; j++) {
          const collision = satTest(bodies[i].worldVertices(), bodies[j].worldVertices());
          if (collision) {
            resolveRigidCollision(bodies[i], bodies[j], collision, e, mu);
          }
        }
      }

      // Wall collisions
      for (const b of bodies) {
        resolveRigidWall(b, this._walls, e, mu);
      }

      // Damping (angular + linear) to prevent infinite spinning
      for (const b of bodies) {
        if (b.isStatic) continue;
        b.omega *= 0.999;
        b.vx *= 0.9995;
        b.vy *= 0.9995;
      }
    }

    this._time += dt;

    // Copy to runner state
    const N = bodies.length;
    for (let i = 0; i < N; i++) {
      vars[i * 2] = bodies[i].x;
      vars[i * 2 + 1] = bodies[i].y;
    }
    vars[N * 2] = this._time;
  },

  energy(vars, params) {
    const bodies = this._bodies;
    if (!bodies) return { kinetic: 0, potential: 0, total: 0 };
    let KE = 0, PE = 0;
    for (const b of bodies) {
      if (b.isStatic) continue;
      KE += 0.5 * b.mass * (b.vx * b.vx + b.vy * b.vy);
      KE += 0.5 * b.inertia * b.omega * b.omega;
      PE += b.mass * params.gravity * (b.y + 2.5);
    }
    return { kinetic: KE, potential: PE, total: KE + PE };
  },

  hitTest(wx, wy, vars, params) {
    const bodies = this._bodies;
    if (!bodies) return null;
    for (let i = bodies.length - 1; i >= 0; i--) {
      if (Math.hypot(wx - bodies[i].x, wy - bodies[i].y) < 0.6) {
        return { id: i, offsetX: wx - bodies[i].x, offsetY: wy - bodies[i].y };
      }
    }
    return null;
  },

  onDrag(id, wx, wy, offset, vars, params) {
    const b = this._bodies[id];
    if (!b) return;
    b.x = wx - offset.offsetX;
    b.y = wy - offset.offsetY;
    b.vx = 0; b.vy = 0; b.omega = 0;
  },
  onRelease() {},

  render(canvas, vars, params) {
    const bodies = this._bodies;
    if (!bodies) return;

    // Floor
    canvas.line(this._walls.xMin, this._walls.yMin, this._walls.xMax, this._walls.yMin, '#475569', 3);
    // Walls
    canvas.line(this._walls.xMin, this._walls.yMin, this._walls.xMin, 3, '#47556980', 1);
    canvas.line(this._walls.xMax, this._walls.yMin, this._walls.xMax, 3, '#47556980', 1);

    // Bodies
    for (const b of bodies) {
      const wv = b.worldVertices();
      canvas.polygon(wv, b.color + 'CC', b.color);
    }
  },

  info: `
    <h2>Pile — Rigid Body Stacking</h2>
    <p>Drop polygon shapes and watch them stack, tumble, and collide. This uses a <strong>2D rigid body physics engine</strong> with collision detection (SAT — Separating Axis Theorem), friction, and restitution.</p>

    <h3>How It Works</h3>
    <ul>
      <li><strong>Collision detection:</strong> SAT tests all pairs of edge normals to find the minimum overlap axis</li>
      <li><strong>Impulse resolution:</strong> Normal impulse prevents penetration, friction impulse prevents sliding</li>
      <li><strong>Rotational dynamics:</strong> Each body has mass, moment of inertia, and angular velocity</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Stack boxes:</strong> "Box Stack" preset — watch blocks settle into a stable pile</li>
      <li><strong>Bouncy:</strong> High restitution — bodies bounce off each other and the floor</li>
      <li><strong>Sticky:</strong> Zero restitution, high friction — bodies absorb impact and stick</li>
      <li><strong>Drag and throw:</strong> Grab any body and fling it into the pile</li>
      <li><strong>No gravity:</strong> Bodies float — collide them manually by dragging</li>
    </ol>

    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Game physics:</strong> Unity, Unreal, Box2D all use SAT + impulse-based solvers</li>
      <li><strong>Structural engineering:</strong> Analyzing how loads distribute through stacked elements</li>
      <li><strong>Robotics:</strong> Simulating how objects pile when dropped by a robot arm</li>
    </ul>
  `,
};
