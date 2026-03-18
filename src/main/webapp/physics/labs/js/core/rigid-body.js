/**
 * RigidBody — 2D rigid body with mass, inertia, position, angle, velocity.
 *
 * Supports polygon and circle shapes.
 * Pure data class — no rendering, no DOM.
 */

/**
 * Compute moment of inertia for a convex polygon about its centroid.
 * Formula: I = (m/6) * Σ(|cross(v_i, v_{i+1})| * (v_i·v_i + v_i·v_{i+1} + v_{i+1}·v_{i+1})) / Σ|cross|
 */
export function polygonInertia(vertices, mass) {
  let numerator = 0, denominator = 0;
  const n = vertices.length;
  for (let i = 0; i < n; i++) {
    const a = vertices[i], b = vertices[(i + 1) % n];
    const cross = Math.abs(a[0] * b[1] - a[1] * b[0]);
    const dot = a[0] * a[0] + a[0] * b[0] + b[0] * b[0] + a[1] * a[1] + a[1] * b[1] + b[1] * b[1];
    numerator += cross * dot;
    denominator += cross;
  }
  return denominator > 0 ? (mass / 6) * numerator / denominator : mass * 0.1;
}

/** Compute centroid of polygon */
export function polygonCentroid(vertices) {
  let cx = 0, cy = 0, area = 0;
  const n = vertices.length;
  for (let i = 0; i < n; i++) {
    const a = vertices[i], b = vertices[(i + 1) % n];
    const cross = a[0] * b[1] - b[0] * a[1];
    area += cross;
    cx += (a[0] + b[0]) * cross;
    cy += (a[1] + b[1]) * cross;
  }
  area /= 2;
  if (Math.abs(area) < 1e-10) return [0, 0];
  cx /= (6 * area);
  cy /= (6 * area);
  return [cx, cy];
}

/** Create a regular polygon (N sides) centered at origin */
export function regularPolygon(sides, radius) {
  const verts = [];
  for (let i = 0; i < sides; i++) {
    const angle = (2 * Math.PI * i) / sides - Math.PI / 2;
    verts.push([radius * Math.cos(angle), radius * Math.sin(angle)]);
  }
  return verts;
}

/** Create a rectangle centered at origin */
export function rectangleShape(w, h) {
  return [[-w/2, -h/2], [w/2, -h/2], [w/2, h/2], [-w/2, h/2]];
}

export class RigidBody {
  /**
   * @param {object} opts
   * @param {number[][]} opts.vertices — polygon vertices in local coords (centered at origin)
   * @param {number} opts.mass
   * @param {number} opts.x, opts.y — initial position
   * @param {number} opts.angle — initial rotation (rad)
   */
  constructor(opts) {
    this.vertices = opts.vertices; // local space
    this.mass = opts.mass || 1;
    this.inertia = opts.inertia || polygonInertia(this.vertices, this.mass);
    this.invMass = this.mass > 0 ? 1 / this.mass : 0;
    this.invInertia = this.inertia > 0 ? 1 / this.inertia : 0;
    this.x = opts.x || 0;
    this.y = opts.y || 0;
    this.angle = opts.angle || 0;
    this.vx = opts.vx || 0;
    this.vy = opts.vy || 0;
    this.omega = opts.omega || 0;
    this.isStatic = opts.isStatic || false;
    this.color = opts.color || '#8B5CF6';
    if (this.isStatic) {
      this.invMass = 0;
      this.invInertia = 0;
    }
  }

  /** Get vertices in world space (rotated + translated) */
  worldVertices() {
    const cos = Math.cos(this.angle), sin = Math.sin(this.angle);
    return this.vertices.map(([lx, ly]) => [
      this.x + lx * cos - ly * sin,
      this.y + lx * sin + ly * cos,
    ]);
  }

  /** Get velocity at a world-space point (includes angular contribution) */
  velocityAt(px, py) {
    const rx = px - this.x, ry = py - this.y;
    return {
      vx: this.vx - this.omega * ry,
      vy: this.vy + this.omega * rx,
    };
  }

  /** Apply impulse at a world-space point */
  applyImpulse(jx, jy, px, py) {
    this.vx += jx * this.invMass;
    this.vy += jy * this.invMass;
    const rx = px - this.x, ry = py - this.y;
    this.omega += (rx * jy - ry * jx) * this.invInertia;
  }

  /** Integrate position + angle by dt */
  integrate(dt, gravityY) {
    if (this.isStatic) return;
    this.vy += (gravityY || 0) * dt;
    this.x += this.vx * dt;
    this.y += this.vy * dt;
    this.angle += this.omega * dt;
  }
}
