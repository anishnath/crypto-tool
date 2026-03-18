# Engine2D — Rigid Body Physics Plan

## What We Need

A 2D rigid body engine that handles:
- Polygon and circle shapes with mass, position, angle, velocity, angular velocity
- Polygon-polygon collision detection (SAT — Separating Axis Theorem)
- Polygon-wall collision
- Circle-polygon collision
- Contact point computation + impulse resolution
- Gravity, friction, restitution
- Joint constraints (for connected bodies)

## What We Already Have

| Component | Status |
|-----------|--------|
| Circle-circle collision | Done (`core/collision.js`) |
| Circle-wall collision | Done (`core/collision.js`) |
| Impulse resolution | Done (1D normal impulse) |
| ODE solver (RK4) | Done — for position/velocity integration |
| Canvas rendering | Done — needs polygon draw method |
| Drag interaction | Done — needs rotation support |

## What's New for Engine2D

```
physics/labs/js/
├── core/
│   ├── collision.js          ← extend: SAT, polygon-polygon, contact points
│   ├── rigid-body.js         ← NEW: RigidBody class (mass, inertia, shape, state)
│   └── contact-solver.js     ← NEW: resolve contacts with friction + restitution
│
├── canvas/
│   └── sim-canvas.js         ← extend: polygon() draw method
│
└── sims/
    ├── pile.js               ← stacking rigid bodies
    └── polygon-test.js       ← polygon collision playground
```

### Minimal Engine: ~300 lines across 3 files

---

## Phase 1: Core (rigid-body.js + SAT collision)

### rigid-body.js (~80 lines)

```javascript
class RigidBody {
  constructor(shape, mass, x, y, angle) {
    this.shape = shape;          // { type: 'polygon', vertices: [...] } or { type: 'circle', radius }
    this.mass = mass;
    this.inertia = computeInertia(shape, mass);
    this.x = x; this.y = y;     // center of mass
    this.angle = angle;          // rotation
    this.vx = 0; this.vy = 0;   // linear velocity
    this.omega = 0;              // angular velocity
  }

  // Get world-space vertices (rotated + translated)
  getWorldVertices() { ... }

  // Get velocity at a world point (includes angular contribution)
  velocityAt(px, py) { ... }
}
```

### SAT Collision Detection (~120 lines)

The **Separating Axis Theorem**: two convex polygons DON'T collide if there exists an axis (edge normal) where their projections don't overlap. If no separating axis exists → collision. The axis with minimum overlap gives the collision normal and penetration depth.

```javascript
function satTest(bodyA, bodyB) → { normal, depth, contacts[] } | null

function projectPolygon(vertices, axis) → { min, max }

function findContactPoints(bodyA, bodyB, normal) → [{ x, y }]
```

### Contact Solver (~100 lines)

For each contact point, compute and apply:
- Normal impulse (prevents penetration)
- Friction impulse (tangential, capped by Coulomb limit μ·j_normal)
- Position correction (push apart by penetration depth)

```javascript
function resolveContact(bodyA, bodyB, contact, e, mu) {
  // 1. Relative velocity at contact point
  // 2. Normal impulse: j = -(1+e)*v_rel·n / (1/mA + 1/mB + (rA×n)²/IA + (rB×n)²/IB)
  // 3. Friction impulse: j_t = min(j*mu, v_tangential / ...)
  // 4. Apply impulses to both bodies
}
```

---

## Phase 2: Sims

### Pile (~100 lines)
- N rigid body rectangles/polygons dropped onto a floor
- Gravity + ground contact + body-body stacking
- Drag any body, throw it
- Presets: stack of blocks, pyramid, random scatter

### Polygon Playground (~80 lines)
- User creates polygons (triangle, square, pentagon, hexagon)
- Bodies collide, rotate, bounce off walls
- Adjustable gravity, friction, restitution
- Educational: shows angular momentum, rotational KE

---

## Complexity Assessment

| Component | Lines | Difficulty |
|-----------|-------|-----------|
| RigidBody class | ~80 | Medium — inertia tensor for polygons |
| SAT collision | ~120 | Hard — edge cases, contact point computation |
| Contact solver | ~100 | Hard — friction + angular impulse math |
| sim-canvas polygon() | ~20 | Easy |
| Pile sim | ~100 | Medium |
| Polygon playground | ~80 | Medium |
| Tests | ~100 | Medium |
| **Total** | **~600** | **Hard** |

This is roughly **2x the complexity** of everything we've built so far for a single engine component. The SAT algorithm and contact solver are the hard parts — getting the edge cases right (parallel edges, vertex-vertex contacts, degenerate polygons) takes careful implementation.

---

## Alternative: Skip Engine2D, Ship What We Have

**14 sims across 5 physics domains is already a very strong launch.**

The Engine2D sims (Pile, Polygons) are visually fun but have **lower educational value** than what we've already built. Most physics courses don't teach SAT collision detection — it's a game physics topic.

What has higher ROI right now:
1. **labs/index.jsp** — hub page listing all 14 sims (drives internal traffic)
2. **Update physics/index.jsp** — add Labs section with cards
3. **tools-database.json** — add all 14 sims to site search
4. **Reddit posts** — drive external traffic
5. **Deploy and test** — get the sims live

## Recommendation

**Option A**: Build Engine2D now (~600 lines, 1-2 more sims)
**Option B**: Ship 14 sims, build Engine2D later as Phase 2

Engine2D is a weekend project on its own. The 14 sims we have are production-ready.
