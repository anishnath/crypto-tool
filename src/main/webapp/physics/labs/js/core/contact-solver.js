/**
 * Contact Solver — SAT collision detection + impulse resolution for convex polygons.
 *
 * Uses Separating Axis Theorem (SAT) for overlap detection,
 * then applies impulse with friction and restitution.
 */

/**
 * SAT collision test between two convex polygons.
 * @param {number[][]} vertsA — world-space vertices of body A
 * @param {number[][]} vertsB — world-space vertices of body B
 * @returns {{ normal: [nx,ny], depth: number } | null}
 */
export function satTest(vertsA, vertsB) {
  let minDepth = Infinity;
  let minNormal = null;

  // Precompute centroids (used to orient the collision normal from A→B)
  const cAx = vertsA.reduce((s, v) => s + v[0], 0) / vertsA.length;
  const cAy = vertsA.reduce((s, v) => s + v[1], 0) / vertsA.length;
  const cBx = vertsB.reduce((s, v) => s + v[0], 0) / vertsB.length;
  const cBy = vertsB.reduce((s, v) => s + v[1], 0) / vertsB.length;
  const abx = cBx - cAx, aby = cBy - cAy;

  // Test all edge normals from both polygons
  const allVerts = [vertsA, vertsB];
  for (let p = 0; p < 2; p++) {
    const verts = allVerts[p];
    const n = verts.length;
    for (let i = 0; i < n; i++) {
      const j = (i + 1) % n;
      const ex = verts[j][0] - verts[i][0];
      const ey = verts[j][1] - verts[i][1];
      const len = Math.hypot(ex, ey);
      if (len < 1e-10) continue;
      const nx = -ey / len, ny = ex / len;

      const projA = projectVertices(vertsA, nx, ny);
      const projB = projectVertices(vertsB, nx, ny);

      const overlap = Math.min(projA.max - projB.min, projB.max - projA.min);
      if (overlap <= 0) return null;

      if (overlap < minDepth) {
        minDepth = overlap;
        // Keep the actual edge normal, flip sign so it points from A to B
        if (abx * nx + aby * ny < 0) {
          minNormal = [-nx, -ny];
        } else {
          minNormal = [nx, ny];
        }
      }
    }
  }

  return minDepth < Infinity ? { normal: minNormal, depth: minDepth } : null;
}

/** Project vertices onto an axis, return min/max */
function projectVertices(verts, nx, ny) {
  let min = Infinity, max = -Infinity;
  for (const [x, y] of verts) {
    const proj = x * nx + y * ny;
    if (proj < min) min = proj;
    if (proj > max) max = proj;
  }
  return { min, max };
}

/**
 * Find the best contact point (deepest penetrating vertex of one body into the other).
 * Simplified: use the vertex of B closest to A's interior along the collision normal.
 */
export function findContact(vertsA, vertsB, normal) {
  const [nx, ny] = normal;
  // Find vertex of B most penetrated into A (smallest projection along normal)
  let bestDot = Infinity, bestPt = null;
  for (const [x, y] of vertsB) {
    const d = x * nx + y * ny;
    if (d < bestDot) { bestDot = d; bestPt = [x, y]; }
  }
  // Also check vertices of A most penetrated into B (along -normal)
  for (const [x, y] of vertsA) {
    const d = -(x * nx + y * ny);
    if (d < bestDot) { bestDot = d; bestPt = [x, y]; }
  }
  return bestPt || [0, 0];
}

/**
 * Resolve collision between two rigid bodies.
 *
 * @param {RigidBody} a
 * @param {RigidBody} b
 * @param {{ normal, depth }} collision — from satTest
 * @param {number} e — restitution (0-1)
 * @param {number} mu — friction coefficient
 */
export function resolveRigidCollision(a, b, collision, e, mu) {
  const { normal, depth } = collision;
  const [nx, ny] = normal;

  // Find contact point
  const contact = findContact(a.worldVertices(), b.worldVertices(), normal);
  const [cx, cy] = contact;

  // Separate bodies (position correction)
  const totalInvMass = a.invMass + b.invMass;
  if (totalInvMass > 0) {
    const correction = depth / totalInvMass * 0.8; // 80% correction to avoid jitter
    a.x -= nx * correction * a.invMass;
    a.y -= ny * correction * a.invMass;
    b.x += nx * correction * b.invMass;
    b.y += ny * correction * b.invMass;
  }

  // Relative velocity at contact point
  const va = a.velocityAt(cx, cy);
  const vb = b.velocityAt(cx, cy);
  const relVx = va.vx - vb.vx;
  const relVy = va.vy - vb.vy;
  const vRelN = relVx * nx + relVy * ny;

  // Only resolve if approaching
  if (vRelN <= 0) return;

  // Moment arms
  const raX = cx - a.x, raY = cy - a.y;
  const rbX = cx - b.x, rbY = cy - b.y;
  const raCrossN = raX * ny - raY * nx;
  const rbCrossN = rbX * ny - rbY * nx;

  // Normal impulse denominator (includes rotational terms)
  const denom = totalInvMass + raCrossN * raCrossN * a.invInertia + rbCrossN * rbCrossN * b.invInertia;
  if (denom < 1e-10) return;

  // Normal impulse magnitude
  const jN = (1 + e) * vRelN / denom;

  // Apply normal impulse
  a.applyImpulse(-jN * nx, -jN * ny, cx, cy);
  b.applyImpulse(jN * nx, jN * ny, cx, cy);

  // Friction impulse (tangential)
  if (mu > 0) {
    const tx = relVx - vRelN * nx;
    const ty = relVy - vRelN * ny;
    const tLen = Math.hypot(tx, ty);
    if (tLen > 1e-6) {
      const tnx = tx / tLen, tny = ty / tLen;
      const raCrossT = raX * tny - raY * tnx;
      const rbCrossT = rbX * tny - rbY * tnx;
      const denomT = totalInvMass + raCrossT * raCrossT * a.invInertia + rbCrossT * rbCrossT * b.invInertia;
      let jT = tLen / denomT;
      // Coulomb friction: clamp tangential impulse
      jT = Math.min(jT, jN * mu);
      a.applyImpulse(-jT * tnx, -jT * tny, cx, cy);
      b.applyImpulse(jT * tnx, jT * tny, cx, cy);
    }
  }
}

/**
 * Resolve collision between a rigid body and an axis-aligned wall.
 */
export function resolveRigidWall(body, walls, e, mu) {
  if (body.isStatic) return;

  // Check each wall independently. Find the deepest penetrating vertex per wall
  // and apply ONE impulse at that contact point (avoids double-impulse bug).
  const wallChecks = [
    { axis: 'x', dir:  1, limit: walls.xMin, sign: -1 }, // left wall: vx < xMin
    { axis: 'x', dir: -1, limit: walls.xMax, sign:  1 }, // right wall: vx > xMax
    { axis: 'y', dir:  1, limit: walls.yMin, sign: -1 }, // floor: vy < yMin
    { axis: 'y', dir: -1, limit: walls.yMax, sign:  1 }, // ceiling: vy > yMax
  ];

  for (const wall of wallChecks) {
    const verts = body.worldVertices();
    let deepestPen = 0, deepestVert = null;

    for (const [vx, vy] of verts) {
      const val = wall.axis === 'x' ? vx : vy;
      const pen = wall.sign * (val - wall.limit);
      if (pen > deepestPen) {
        deepestPen = pen;
        deepestVert = [vx, vy];
      }
    }

    if (deepestPen > 0 && deepestVert) {
      const nx = wall.axis === 'x' ? wall.dir : 0;
      const ny = wall.axis === 'y' ? wall.dir : 0;

      // Position correction
      body.x += nx * deepestPen * 0.8;
      body.y += ny * deepestPen * 0.8;

      // Impulse at deepest vertex
      const [cvx, cvy] = deepestVert;
      const v = body.velocityAt(cvx, cvy);
      const vn = v.vx * nx + v.vy * ny;
      if (vn < 0) {
        const rx = cvx - body.x, ry = cvy - body.y;
        const rCrossN = rx * ny - ry * nx;
        const denom = body.invMass + rCrossN * rCrossN * body.invInertia;
        if (denom > 1e-10) {
          const j = -(1 + e) * vn / denom;
          body.applyImpulse(j * nx, j * ny, cvx, cvy);
        }
      }
    }
  }
}
