/**
 * Collision — Circle-circle and circle-wall collision detection + impulse resolution.
 *
 * Used by billiards (2D table) and Newton's cradle (1D chain).
 * All functions are pure — no state, no DOM.
 */

/**
 * Detect and resolve circle-circle collision.
 * Modifies positions (separation) and velocities (impulse) in-place.
 *
 * @param {number} x1,y1 — center of circle 1
 * @param {number} vx1,vy1 — velocity of circle 1
 * @param {number} r1,m1 — radius and mass of circle 1
 * @param {number} x2,y2,vx2,vy2,r2,m2 — same for circle 2
 * @param {number} e — coefficient of restitution (1 = elastic)
 * @returns {object|null} — { nx, ny, impulse } if collision occurred, null otherwise
 */
export function resolveCircleCircle(
  x1, y1, vx1, vy1, r1, m1,
  x2, y2, vx2, vy2, r2, m2,
  e
) {
  const dx = x2 - x1;
  const dy = y2 - y1;
  const dist = Math.hypot(dx, dy);
  const minDist = r1 + r2;

  if (dist >= minDist || dist < 1e-10) return null;

  // Collision normal (from 1 to 2)
  const nx = dx / dist;
  const ny = dy / dist;

  // Relative velocity along collision normal
  const dvx = vx1 - vx2;
  const dvy = vy1 - vy2;
  const vRel = dvx * nx + dvy * ny;

  // Only resolve if objects are approaching
  if (vRel <= 0) return null;

  // Impulse magnitude (1D collision along normal)
  const j = (1 + e) * vRel / (1 / m1 + 1 / m2);

  return { nx, ny, impulse: j, overlap: minDist - dist };
}

/**
 * Apply collision result to two circles' state arrays.
 *
 * @param {Float64Array} vars — state array
 * @param {number} i1 — index offset for circle 1 (x at i1, y at i1+1, vx at i1+2, vy at i1+3)
 * @param {number} i2 — index offset for circle 2
 * @param {number} m1,m2 — masses
 * @param {object} result — from resolveCircleCircle
 */
export function applyCircleCollision(vars, i1, i2, m1, m2, result) {
  const { nx, ny, impulse: j, overlap } = result;

  // Separate overlapping circles (mass-proportional)
  const totalM = m1 + m2;
  vars[i1]     -= nx * overlap * m2 / totalM;
  vars[i1 + 1] -= ny * overlap * m2 / totalM;
  vars[i2]     += nx * overlap * m1 / totalM;
  vars[i2 + 1] += ny * overlap * m1 / totalM;

  // Apply impulse to velocities
  vars[i1 + 2] -= (j / m1) * nx;
  vars[i1 + 3] -= (j / m1) * ny;
  vars[i2 + 2] += (j / m2) * nx;
  vars[i2 + 3] += (j / m2) * ny;
}

/**
 * Resolve circle-wall collision (axis-aligned rectangular boundary).
 *
 * @param {Float64Array} vars — state array
 * @param {number} idx — index offset (x at idx, y at idx+1, vx at idx+2, vy at idx+3)
 * @param {number} r — circle radius
 * @param {number} e — wall elasticity
 * @param {{ xMin, xMax, yMin, yMax }} walls — boundary rectangle
 */
export function resolveCircleWall(vars, idx, r, e, walls) {
  const x = idx, y = idx + 1, vx = idx + 2, vy = idx + 3;

  if (vars[x] - r < walls.xMin) {
    vars[x] = walls.xMin + r;
    vars[vx] = Math.abs(vars[vx]) * e;
  }
  if (vars[x] + r > walls.xMax) {
    vars[x] = walls.xMax - r;
    vars[vx] = -Math.abs(vars[vx]) * e;
  }
  if (vars[y] - r < walls.yMin) {
    vars[y] = walls.yMin + r;
    vars[vy] = Math.abs(vars[vy]) * e;
  }
  if (vars[y] + r > walls.yMax) {
    vars[y] = walls.yMax - r;
    vars[vy] = -Math.abs(vars[vy]) * e;
  }
}
