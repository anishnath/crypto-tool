/**
 * DirectionField — draws arrows on phase-space graph showing ODE flow.
 *
 * At each grid point (x, y) in phase space, calls sim.evaluate() to get
 * (dx/dt, dy/dt), then draws a short arrow in that direction.
 *
 * This reveals the phase portrait: where the system flows, fixed points,
 * separatrices, and attractors — all at a glance.
 *
 * Reference: myphysicslab/src/lab/graph/VectorGraph.ts
 */

export class DirectionField {
  /**
   * @param {object} opts
   * @param {number} opts.gridSize — grid points per axis (default 12)
   * @param {string} opts.arrowColor — arrow line color
   * @param {string} opts.dotColor — grid point dot color
   * @param {number} opts.xVar — state index for x-axis variable
   * @param {number} opts.yVar — state index for y-axis variable
   * @param {boolean} opts.scaleBySpeed — arrow length proportional to speed (default false = fixed length)
   */
  constructor(opts = {}) {
    this.gridSize = opts.gridSize || 12;
    this.arrowColor = opts.arrowColor || '#3B82F6';
    this.dotColor = opts.dotColor || '#EF444480';
    this.xVar = opts.xVar ?? 0;
    this.yVar = opts.yVar ?? 1;
    this.scaleBySpeed = opts.scaleBySpeed || false;
    this.enabled = true;
  }

  /**
   * Render the direction field onto a graph canvas context.
   *
   * @param {CanvasRenderingContext2D} ctx
   * @param {{ xMin, xMax, yMin, yMax }} bounds — current graph bounds
   * @param {number} padding — graph padding in pixels
   * @param {number} plotW — plot width in pixels
   * @param {number} plotH — plot height in pixels
   * @param {function} evaluate — (state, change, params) => void
   * @param {object} params — current sim params
   * @param {number} varCount — total state variable count
   */
  render(ctx, bounds, padding, plotW, plotH, evaluate, params, varCount) {
    if (!this.enabled) return;

    const { xMin, xMax, yMin, yMax } = bounds;
    const n = this.gridSize;
    const dx = (xMax - xMin) / (n + 1);
    const dy = (yMax - yMin) / (n + 1);
    const arrowLen = Math.min(plotW, plotH) / (n * 2.2); // fixed arrow length in pixels

    const state = new Float64Array(varCount);
    const change = new Float64Array(varCount);

    for (let i = 1; i <= n; i++) {
      for (let j = 1; j <= n; j++) {
        const wx = xMin + i * dx;
        const wy = yMin + j * dy;

        // Set up state at this grid point
        state.fill(0);
        state[this.xVar] = wx;
        state[this.yVar] = wy;

        // Evaluate derivatives at this point
        change.fill(0);
        evaluate(state, change, params);

        const dxdt = change[this.xVar];
        const dydt = change[this.yVar];

        // Screen coordinates of grid point
        const sx = padding + ((wx - xMin) / (xMax - xMin)) * plotW;
        const sy = padding + ((yMax - wy) / (yMax - yMin)) * plotH;

        // Dot at grid point
        ctx.beginPath();
        ctx.arc(sx, sy, 1.5, 0, Math.PI * 2);
        ctx.fillStyle = this.dotColor;
        ctx.fill();

        // Arrow direction
        const speed = Math.hypot(dxdt, dydt);
        if (speed < 1e-10) continue; // skip zero-velocity points

        // Normalize direction
        const nx = dxdt / speed;
        const ny = dydt / speed;

        // Arrow length — optionally scale by speed
        let len = arrowLen;
        if (this.scaleBySpeed) {
          const maxSpeed = Math.sqrt((xMax - xMin) ** 2 + (yMax - yMin) ** 2) * 2;
          len = arrowLen * 0.3 + arrowLen * 0.7 * Math.min(speed / maxSpeed, 1);
        }

        // Convert direction to screen (flip Y)
        const screenDx = nx * len;
        const screenDy = -ny * len; // Y flipped in screen coords

        // Draw arrow line
        const x1 = sx - screenDx * 0.4;
        const y1 = sy - screenDy * 0.4;
        const x2 = sx + screenDx * 0.6;
        const y2 = sy + screenDy * 0.6;

        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.strokeStyle = this.arrowColor;
        ctx.lineWidth = 1;
        ctx.globalAlpha = 0.6;
        ctx.stroke();

        // Arrowhead
        const headLen = len * 0.25;
        const angle = Math.atan2(y2 - y1, x2 - x1);
        ctx.beginPath();
        ctx.moveTo(x2, y2);
        ctx.lineTo(
          x2 - headLen * Math.cos(angle - 0.4),
          y2 - headLen * Math.sin(angle - 0.4)
        );
        ctx.moveTo(x2, y2);
        ctx.lineTo(
          x2 - headLen * Math.cos(angle + 0.4),
          y2 - headLen * Math.sin(angle + 0.4)
        );
        ctx.stroke();
        ctx.globalAlpha = 1;
      }
    }
  }
}

/**
 * Pure logic: compute arrow at a single grid point (testable without DOM).
 */
export function computeArrow(wx, wy, evaluate, params, xVar, yVar, varCount) {
  const state = new Float64Array(varCount);
  const change = new Float64Array(varCount);
  state[xVar] = wx;
  state[yVar] = wy;
  evaluate(state, change, params);
  return { dxdt: change[xVar], dydt: change[yVar] };
}
