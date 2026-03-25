/**
 * Voltage-to-Color Mapping
 * 32-step scale: red(-V) → gray(0V) → green(+V)
 */

const SCALE_COUNT = 32;
let voltageRange = 5;  // ±5V by default
const colorScale = new Array(SCALE_COUNT);

function lerp(a, b, t) { return a + (b - a) * t; }
function rgb(r, g, b) { return `rgb(${r|0},${g|0},${b|0})`; }

/** Build the color scale */
export function buildColorScale(range) {
  voltageRange = range || 5;
  const light = document.documentElement.getAttribute('data-theme') === 'light';
  const mid = light ? 140 : 80;  // midpoint gray (brighter for light theme)
  for (let i = 0; i < SCALE_COUNT; i++) {
    const t = i * 2 / SCALE_COUNT - 1;  // -1 to +1
    if (t < 0) {
      const a = -t;
      colorScale[i] = rgb(lerp(mid, 220, a), lerp(mid, 40, a), lerp(mid, 40, a));
    } else {
      const a = t;
      colorScale[i] = rgb(lerp(mid, 30, a), lerp(mid, 210, a), lerp(mid, 50, a));
    }
  }
}

/** Get color for a voltage value */
export function getVoltageColor(v) {
  const idx = Math.round((v + voltageRange) * (SCALE_COUNT - 1) / (2 * voltageRange));
  return colorScale[Math.max(0, Math.min(SCALE_COUNT - 1, idx))] || '#555';
}

/** Get a CSS linear gradient string between two voltages */
export function getVoltageGradient(ctx, x1, y1, x2, y2, v1, v2) {
  const grad = ctx.createLinearGradient(x1, y1, x2, y2);
  grad.addColorStop(0, getVoltageColor(v1));
  grad.addColorStop(1, getVoltageColor(v2));
  return grad;
}

// Initialize
buildColorScale(5);
