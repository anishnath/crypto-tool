/**
 * Circuit Renderer — draw component symbols, wires, dots, posts
 *
 * All coordinates in grid units (1 unit = GRID_SIZE pixels).
 * The CircuitCanvas transform handles grid→screen conversion.
 */

import { getVoltageColor, getVoltageGradient } from './colors.js';

const G = 16;  // grid size in pixels (must match canvas.js GRID_SIZE)
const POST_RADIUS = 3;
const DOT_SIZE = 4;
const LEAD_WIDTH = 3;
const SHAPE_WIDTH = 2.5;

function isLightTheme() {
  return document.documentElement.getAttribute('data-theme') === 'light';
}
// Colors that adapt to theme
function labelColor() { return isLightTheme() ? '#374151' : '#aaa'; }
function wireColor() { return isLightTheme() ? '#475569' : '#e2e8f0'; }
function bodyStroke() { return isLightTheme() ? '#64748b' : '#94a3b8'; }
function postColor(sel) { return sel ? '#0891b2' : '#06b6d4'; }

/** Draw a thick line between two grid points, colored by voltage */
function drawLead(ctx, gx1, gy1, gx2, gy2, v1, v2) {
  const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
  ctx.strokeStyle = getVoltageGradient(ctx, x1, y1, x2, y2, v1, v2);
  ctx.lineWidth = LEAD_WIDTH;
  ctx.lineCap = 'round';
  ctx.beginPath();
  ctx.moveTo(x1, y1);
  ctx.lineTo(x2, y2);
  ctx.stroke();
}

/** Draw a post (terminal dot) */
function drawPost(ctx, gx, gy, selected) {
  const x = gx * G, y = gy * G;
  ctx.beginPath();
  ctx.arc(x, y, POST_RADIUS, 0, Math.PI * 2);
  ctx.fillStyle = postColor(selected);
  ctx.fill();
}

/** Draw text label near a component */
function drawLabel(ctx, gx, gy, text, offsetY = -8) {
  const x = gx * G, y = gy * G + offsetY;
  ctx.font = '10px monospace';
  ctx.fillStyle = labelColor();
  ctx.textAlign = 'center';
  ctx.fillText(text, x, y);
}

/** Format value with SI prefix */
function siFormat(val, unit) {
  const abs = Math.abs(val);
  if (abs >= 1e6) return (val / 1e6).toFixed(1) + 'M' + unit;
  if (abs >= 1e3) return (val / 1e3).toFixed(1) + 'k' + unit;
  if (abs >= 1) return val.toFixed(1) + unit;
  if (abs >= 1e-3) return (val * 1e3).toFixed(1) + 'm' + unit;
  if (abs >= 1e-6) return (val * 1e6).toFixed(1) + 'μ' + unit;
  if (abs >= 1e-9) return (val * 1e9).toFixed(1) + 'n' + unit;
  return val.toExponential(1) + unit;
}

// ═══════════════════════════════════════════
// Component drawing functions
// Each takes (ctx, elm, showValues, showDots, dotState)
// elm has: type, nodes (grid coords), volts[], current, params
// ═══════════════════════════════════════════

const DRAW = {};

/** Wire */
DRAW.wire = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  drawLead(ctx, gx1, gy1, gx2, gy2, elm.volts[0], elm.volts[1]);
};

/** Resistor — zigzag symbol */
DRAW.resistor = (ctx, elm, showValues) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
  const dx = x2 - x1, dy = y2 - y1;
  const len = Math.sqrt(dx * dx + dy * dy);
  if (len < 1) return;
  const ux = dx / len, uy = dy / len;  // unit vector along component
  const nx = -uy, ny = ux;             // normal (perpendicular)

  // Leads: first 25% and last 25%
  const leadFrac = 0.25;
  const lx1 = x1 + dx * leadFrac, ly1 = y1 + dy * leadFrac;
  const lx2 = x1 + dx * (1 - leadFrac), ly2 = y1 + dy * (1 - leadFrac);
  drawLead(ctx, gx1, gy1, lx1 / G, ly1 / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, lx2 / G, ly2 / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  // Zigzag body
  const bodyLen = len * 0.5;
  const zigs = 6;
  const zigW = 5;  // perpendicular width
  ctx.strokeStyle = getVoltageGradient(ctx, lx1, ly1, lx2, ly2, elm.volts[0], elm.volts[1]);
  ctx.lineWidth = SHAPE_WIDTH;
  ctx.lineJoin = 'round';
  ctx.beginPath();
  ctx.moveTo(lx1, ly1);
  for (let i = 0; i < zigs; i++) {
    const t = (i + 0.5) / zigs;
    const sign = (i % 2 === 0) ? 1 : -1;
    const px = lx1 + (lx2 - lx1) * t + nx * zigW * sign;
    const py = ly1 + (ly2 - ly1) * t + ny * zigW * sign;
    ctx.lineTo(px, py);
  }
  ctx.lineTo(lx2, ly2);
  ctx.stroke();

  if (showValues) drawLabel(ctx, (gx1 + gx2) / 2, (gy1 + gy2) / 2, siFormat(elm.resistance, 'Ω'));
};

/** DC Voltage Source — circle with +/− */
DRAW['dc-voltage'] = (ctx, elm, showValues) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = (gx1 + gx2) / 2 * G, cy = (gy1 + gy2) / 2 * G;
  const r = 10;

  // Leads
  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  // Circle
  ctx.strokeStyle = '#e2e8f0';
  ctx.lineWidth = SHAPE_WIDTH;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.stroke();

  // +/− labels
  const dx = gx2 - gx1, dy = gy2 - gy1;
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const ux = dx / len * 5, uy = dy / len * 5;
  ctx.font = 'bold 10px sans-serif';
  ctx.fillStyle = '#ef4444';
  ctx.textAlign = 'center';
  ctx.fillText('+', cx + ux, cy + uy + 3);
  ctx.fillStyle = '#3b82f6';
  ctx.fillText('−', cx - ux, cy - uy + 3);

  if (showValues) drawLabel(ctx, (gx1 + gx2) / 2, (gy1 + gy2) / 2, siFormat(elm.voltage, 'V'), -18);
};

/** DC Current Source — circle with arrow */
DRAW['dc-current'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = (gx1 + gx2) / 2 * G, cy = (gy1 + gy2) / 2 * G;
  const r = 10;

  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  ctx.strokeStyle = '#e2e8f0';
  ctx.lineWidth = SHAPE_WIDTH;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.stroke();

  // Arrow inside
  const dx = (gx2 - gx1), dy = (gy2 - gy1);
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const ax = dx / len * 6, ay = dy / len * 6;
  ctx.strokeStyle = '#fbbf24';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(cx - ax, cy - ay);
  ctx.lineTo(cx + ax, cy + ay);
  ctx.stroke();
};

/** Ground — three horizontal lines */
DRAW.ground = (ctx, elm) => {
  const [gx, gy] = elm.gridPos[0];
  const x = gx * G, y = gy * G;
  ctx.strokeStyle = '#64748b';
  ctx.lineWidth = 2;
  for (let i = 0; i < 3; i++) {
    const w = 8 - i * 2.5;
    const yy = y + i * 4;
    ctx.beginPath();
    ctx.moveTo(x - w, yy);
    ctx.lineTo(x + w, yy);
    ctx.stroke();
  }
};

/** Switch — gap or bridge */
DRAW['switch'] = DRAW['switch-open'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = (gx1 + gx2) / 2 * G, cy = (gy1 + gy2) / 2 * G;

  drawLead(ctx, gx1, gy1, cx / G - 0.2, cy / G, elm.volts[0], elm.volts[0]);

  // Open switch arm
  const dx = (gx2 - gx1), dy = (gy2 - gy1);
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const nx = -dy / len * 6, ny = dx / len * 6;
  ctx.strokeStyle = '#94a3b8';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(cx - 4, cy);
  ctx.lineTo(cx + nx, cy + ny);
  ctx.stroke();

  drawLead(ctx, cx / G + 0.2, cy / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  drawPost(ctx, cx / G - 0.2, cy / G, false);
  drawPost(ctx, cx / G + 0.2, cy / G, false);
};

/** Capacitor — two parallel lines */
DRAW.capacitor = (ctx, elm, showValues) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = (gx1 + gx2) / 2 * G, cy = (gy1 + gy2) / 2 * G;
  const dx = gx2 - gx1, dy = gy2 - gy1;
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const ux = dx / len, uy = dy / len;
  const nx = -uy * 7, ny = ux * 7;
  const gap = 3;

  drawLead(ctx, gx1, gy1, (cx - ux * gap) / G, (cy - uy * gap) / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, (cx + ux * gap) / G, (cy + uy * gap) / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  ctx.strokeStyle = getVoltageColor(elm.volts[0]);
  ctx.lineWidth = 2.5;
  ctx.beginPath();
  ctx.moveTo(cx - ux * gap + nx, cy - uy * gap + ny);
  ctx.lineTo(cx - ux * gap - nx, cy - uy * gap - ny);
  ctx.stroke();

  ctx.strokeStyle = getVoltageColor(elm.volts[1]);
  ctx.beginPath();
  ctx.moveTo(cx + ux * gap + nx, cy + uy * gap + ny);
  ctx.lineTo(cx + ux * gap - nx, cy + uy * gap - ny);
  ctx.stroke();

  if (showValues) drawLabel(ctx, (gx1 + gx2) / 2, (gy1 + gy2) / 2, siFormat(elm.capacitance, 'F'));
};

/** Diode — triangle + bar */
DRAW.diode = DRAW.led = DRAW.zener = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
  const cx = (x1 + x2) / 2, cy = (y1 + y2) / 2;
  const dx = x2 - x1, dy = y2 - y1;
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const ux = dx / len, uy = dy / len;
  const nx = -uy * 7, ny = ux * 7;
  const s = 6;

  drawLead(ctx, gx1, gy1, (cx - ux * s) / G, (cy - uy * s) / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, (cx + ux * s) / G, (cy + uy * s) / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  // Triangle (anode side)
  ctx.fillStyle = elm.type === 'led' ? '#22c55e' : getVoltageColor(elm.volts[0]);
  ctx.beginPath();
  ctx.moveTo(cx - ux * s + nx, cy - uy * s + ny);
  ctx.lineTo(cx - ux * s - nx, cy - uy * s - ny);
  ctx.lineTo(cx + ux * s, cy + uy * s);
  ctx.closePath();
  ctx.fill();

  // Bar (cathode side)
  ctx.strokeStyle = getVoltageColor(elm.volts[1]);
  ctx.lineWidth = 2.5;
  ctx.beginPath();
  ctx.moveTo(cx + ux * s + nx, cy + uy * s + ny);
  ctx.lineTo(cx + ux * s - nx, cy + uy * s - ny);
  ctx.stroke();
};

/** Inductor — coil bumps */
DRAW.inductor = (ctx, elm, showValues) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
  const dx = x2 - x1, dy = y2 - y1;
  const len = Math.sqrt(dx * dx + dy * dy) || 1;
  const ux = dx / len, uy = dy / len;
  const nx = -uy, ny = ux;
  const leadFrac = 0.2;

  drawLead(ctx, gx1, gy1, (x1 + dx * leadFrac) / G, (y1 + dy * leadFrac) / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, (x1 + dx * (1 - leadFrac)) / G, (y1 + dy * (1 - leadFrac)) / G, gx2, gy2, elm.volts[1], elm.volts[1]);

  // Coil bumps
  const coils = 4, bodyLen = len * 0.6;
  const startX = x1 + dx * leadFrac, startY = y1 + dy * leadFrac;
  ctx.strokeStyle = getVoltageGradient(ctx, startX, startY, startX + dx * 0.6, startY + dy * 0.6, elm.volts[0], elm.volts[1]);
  ctx.lineWidth = SHAPE_WIDTH;
  ctx.beginPath();
  ctx.moveTo(startX, startY);
  for (let i = 0; i < coils; i++) {
    const t1 = (i + 0.5) / coils;
    const px = startX + dx * 0.6 * t1;
    const py = startY + dy * 0.6 * t1;
    ctx.quadraticCurveTo(px + nx * 8, py + ny * 8, px + ux * bodyLen / coils * 0.5, py + uy * bodyLen / coils * 0.5);
  }
  ctx.stroke();

  if (showValues) drawLabel(ctx, (gx1 + gx2) / 2, (gy1 + gy2) / 2, siFormat(elm.inductance, 'H'));
};

/** BJT Transistor — circle with B/C/E */
DRAW['bjt-npn'] = DRAW['bjt-pnp'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  // B=(gx1,gy1), C=(gx2,gy2), E=(gx2,gy2+1)
  const bx = gx1 * G, by = gy1 * G;
  const cx = gx2 * G, cy = gy2 * G;
  const ex = gx2 * G, ey = (gy2 + 1) * G;
  const mx = (bx + cx) / 2, my = (by + cy + ey) / 3;  // center of transistor

  // Leads to terminals
  drawLead(ctx, gx1, gy1, mx / G, my / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, mx / G, my / G - 0.3, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  drawLead(ctx, mx / G, my / G + 0.3, gx2, gy2 + 1, elm.volts[1] || 0, elm.volts[1] || 0);

  // Circle
  const r = 12;
  ctx.strokeStyle = '#94a3b8';
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.arc(mx, my, r, 0, Math.PI * 2);
  ctx.stroke();

  // Base line (vertical bar)
  ctx.strokeStyle = '#e2e8f0';
  ctx.lineWidth = 2.5;
  ctx.beginPath();
  ctx.moveTo(mx - 2, my - 7);
  ctx.lineTo(mx - 2, my + 7);
  ctx.stroke();

  // Collector line (top-right)
  ctx.beginPath();
  ctx.moveTo(mx - 2, my - 4);
  ctx.lineTo(mx + 6, my - 8);
  ctx.stroke();

  // Emitter line (bottom-right) with arrow
  ctx.beginPath();
  ctx.moveTo(mx - 2, my + 4);
  ctx.lineTo(mx + 6, my + 8);
  ctx.stroke();

  // Arrow on emitter (NPN: outward, PNP: inward)
  const isPNP = elm.type === 'bjt-pnp';
  ctx.fillStyle = '#e2e8f0';
  ctx.beginPath();
  if (!isPNP) {
    ctx.moveTo(mx + 6, my + 8);
    ctx.lineTo(mx + 2, my + 5);
    ctx.lineTo(mx + 4, my + 10);
  } else {
    ctx.moveTo(mx - 2, my + 4);
    ctx.lineTo(mx + 2, my + 7);
    ctx.lineTo(mx, my + 2);
  }
  ctx.fill();

  // Labels
  ctx.font = '8px monospace';
  ctx.fillStyle = '#64748b';
  ctx.textAlign = 'center';
  ctx.fillText('B', bx + 6, by - 4);
  ctx.fillText('C', cx - 6, cy - 4);
  ctx.fillText('E', ex - 6, ey + 10);
};

/** MOSFET — gate/drain/source */
DRAW['mosfet-n'] = DRAW['mosfet-p'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const gateX = gx1 * G, gateY = gy1 * G;
  const drainX = gx2 * G, drainY = gy2 * G;
  const srcX = gx2 * G, srcY = (gy2 + 1) * G;
  const mx = (gateX + drainX) / 2, my = (drainY + srcY) / 2;

  // Leads
  drawLead(ctx, gx1, gy1, mx / G - 0.3, my / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, mx / G + 0.2, my / G - 0.4, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  drawLead(ctx, mx / G + 0.2, my / G + 0.4, gx2, gy2 + 1, elm.volts[1] || 0, elm.volts[1] || 0);

  // Body
  const r = 12;
  ctx.strokeStyle = '#94a3b8';
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.arc(mx, my, r, 0, Math.PI * 2);
  ctx.stroke();

  // Gate line (vertical, left side with gap)
  ctx.strokeStyle = '#e2e8f0';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(mx - 5, my - 7);
  ctx.lineTo(mx - 5, my + 7);
  ctx.stroke();

  // Channel lines (3 dashes, right of gate)
  for (let i = -1; i <= 1; i++) {
    ctx.beginPath();
    ctx.moveTo(mx - 1, my + i * 5);
    ctx.lineTo(mx + 6, my + i * 5);
    ctx.stroke();
  }

  // Labels
  ctx.font = '8px monospace';
  ctx.fillStyle = '#64748b';
  ctx.textAlign = 'center';
  ctx.fillText('G', gateX + 6, gateY - 4);
  ctx.fillText('D', drainX - 6, drainY - 4);
  ctx.fillText('S', srcX - 6, srcY + 10);
};

/** Op-Amp — triangle */
DRAW.opamp = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  // V+=(gx1,gy1), V-=(gx2,gy2), Out=(gx2,gy2+1)
  const px = gx1 * G, py = gy1 * G;   // non-inverting (+)
  const mx = gx2 * G, my = gy2 * G;   // inverting (-)
  const ox = gx2 * G, oy = (gy2 + 1) * G; // output
  const cx = (px + mx) / 2 + 8, cy = (py + oy) / 2;

  // Leads
  drawLead(ctx, gx1, gy1, (cx - 12) / G, py / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, gx2, gy2, (cx - 12) / G, my / G, elm.volts[1] || 0, elm.volts[1] || 0);
  drawLead(ctx, (cx + 14) / G, cy / G, gx2, gy2 + 1, elm.volts[1] || 0, elm.volts[1] || 0);

  // Triangle body
  ctx.strokeStyle = '#e2e8f0';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(cx - 14, cy - 16);
  ctx.lineTo(cx + 14, cy);
  ctx.lineTo(cx - 14, cy + 16);
  ctx.closePath();
  ctx.stroke();

  // +/- labels inside
  ctx.font = 'bold 10px sans-serif';
  ctx.textAlign = 'center';
  ctx.fillStyle = '#22c55e';
  ctx.fillText('+', cx - 8, py < my ? cy - 6 : cy + 10);
  ctx.fillStyle = '#ef4444';
  ctx.fillText('−', cx - 8, py < my ? cy + 10 : cy - 6);
};

/** Logic Gate — generic shape: flat left, curved/pointed right */
function drawGateShape(ctx, elm, label, bodyColor = '#475569') {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;

  // Leads
  drawLead(ctx, gx1, gy1, cx / G - 0.5, cy / G - 0.3, elm.volts[0], elm.volts[0]);
  drawLead(ctx, gx2, gy2, cx / G - 0.5, cy / G + 0.3, elm.volts[1] || 0, elm.volts[1] || 0);
  if (elm.gridPos.length > 2) {
    const [gx3, gy3] = elm.gridPos[2];
    drawLead(ctx, cx / G + 0.7, cy / G, gx3, gy3, 0, 0);
  }

  // Body (rectangle with rounded right)
  ctx.fillStyle = bodyColor;
  ctx.strokeStyle = '#94a3b8';
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.moveTo(cx - 8, cy - 10);
  ctx.lineTo(cx + 4, cy - 10);
  ctx.quadraticCurveTo(cx + 14, cy, cx + 4, cy + 10);
  ctx.lineTo(cx - 8, cy + 10);
  ctx.closePath();
  ctx.fill(); ctx.stroke();

  // Label
  ctx.font = 'bold 8px sans-serif';
  ctx.fillStyle = '#e2e8f0';
  ctx.textAlign = 'center';
  ctx.fillText(label, cx - 1, cy + 3);

  // Input dots
  ctx.fillStyle = '#06b6d4';
  ctx.beginPath(); ctx.arc(cx - 8, cy - 5, 2, 0, Math.PI * 2); ctx.fill();
  ctx.beginPath(); ctx.arc(cx - 8, cy + 5, 2, 0, Math.PI * 2); ctx.fill();
  // Output dot
  ctx.beginPath(); ctx.arc(cx + 10, cy, 2, 0, Math.PI * 2); ctx.fill();
}

DRAW['and-gate'] = (ctx, elm) => drawGateShape(ctx, elm, 'AND', '#1e3a5f');
DRAW['or-gate'] = (ctx, elm) => drawGateShape(ctx, elm, 'OR', '#1e3a5f');
DRAW['nand-gate'] = (ctx, elm) => drawGateShape(ctx, elm, 'NAND', '#3b1f2b');
DRAW['nor-gate'] = (ctx, elm) => drawGateShape(ctx, elm, 'NOR', '#3b1f2b');
DRAW['xor-gate'] = (ctx, elm) => drawGateShape(ctx, elm, 'XOR', '#1a3a2a');
DRAW['not-gate'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  drawLead(ctx, gx1, gy1, cx / G - 0.4, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G + 0.6, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  // Triangle
  ctx.fillStyle = '#1e3a5f'; ctx.strokeStyle = '#94a3b8'; ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.moveTo(cx - 7, cy - 8); ctx.lineTo(cx + 7, cy); ctx.lineTo(cx - 7, cy + 8); ctx.closePath();
  ctx.fill(); ctx.stroke();
  // Bubble
  ctx.beginPath(); ctx.arc(cx + 9, cy, 3, 0, Math.PI * 2);
  ctx.fillStyle = '#0d1017'; ctx.fill(); ctx.stroke();
};

/** Flip-Flop — rectangle with pin labels */
function drawFlipFlop(ctx, elm, label, pins) {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  const w = 20, h = 24;

  // Body
  ctx.fillStyle = '#2d1f4e'; ctx.strokeStyle = '#94a3b8'; ctx.lineWidth = 1.5;
  ctx.fillRect(cx - w, cy - h, w * 2, h * 2);
  ctx.strokeRect(cx - w, cy - h, w * 2, h * 2);

  // Label
  ctx.font = 'bold 9px sans-serif'; ctx.fillStyle = '#c4b5fd'; ctx.textAlign = 'center';
  ctx.fillText(label, cx, cy - h + 10);

  // Pin labels
  ctx.font = '7px monospace'; ctx.fillStyle = '#94a3b8';
  ctx.textAlign = 'left'; ctx.fillText(pins[0] || '', cx - w + 3, cy - 4);
  ctx.fillText(pins[1] || '', cx - w + 3, cy + 8);
  ctx.textAlign = 'right'; ctx.fillText('Q', cx + w - 3, cy - 4);
  ctx.fillText('Q̄', cx + w - 3, cy + 8);

  // Terminal dots
  for (const [gx, gy] of elm.gridPos) {
    ctx.fillStyle = '#06b6d4';
    ctx.beginPath(); ctx.arc(gx * G, gy * G, 2.5, 0, Math.PI * 2); ctx.fill();
  }
}

DRAW['d-flipflop'] = (ctx, elm) => drawFlipFlop(ctx, elm, 'D-FF', ['D', 'CLK']);
DRAW['sr-flipflop'] = (ctx, elm) => drawFlipFlop(ctx, elm, 'SR-FF', ['S', 'R']);

/** 555 Timer — IC package */
DRAW['555-timer'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0];
  const cx = gx1 * G + 16, cy = gy1 * G + 16;
  const w = 24, h = 28;

  ctx.fillStyle = '#1a1a2e'; ctx.strokeStyle = '#94a3b8'; ctx.lineWidth = 1.5;
  ctx.fillRect(cx - w, cy - h, w * 2, h * 2);
  ctx.strokeRect(cx - w, cy - h, w * 2, h * 2);

  // Notch
  ctx.beginPath(); ctx.arc(cx, cy - h, 4, 0, Math.PI); ctx.stroke();

  ctx.font = 'bold 9px sans-serif'; ctx.fillStyle = '#f59e0b'; ctx.textAlign = 'center';
  ctx.fillText('555', cx, cy + 3);

  ctx.font = '6px monospace'; ctx.fillStyle = '#64748b';
  ctx.textAlign = 'left';
  ctx.fillText('GND', cx - w + 2, cy - h + 10);
  ctx.fillText('TRG', cx - w + 2, cy - 2);
  ctx.textAlign = 'right';
  ctx.fillText('VCC', cx + w - 2, cy - h + 10);
  ctx.fillText('OUT', cx + w - 2, cy - 2);
};

/** VCVS / VCCS — diamond shape */
DRAW.vcvs = DRAW.vccs = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  const s = 10;

  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);

  ctx.strokeStyle = '#f59e0b'; ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(cx, cy - s); ctx.lineTo(cx + s, cy);
  ctx.lineTo(cx, cy + s); ctx.lineTo(cx - s, cy); ctx.closePath();
  ctx.stroke();

  ctx.font = '8px monospace'; ctx.fillStyle = '#f59e0b'; ctx.textAlign = 'center';
  ctx.fillText(elm.type === 'vcvs' ? 'E' : 'G', cx, cy + 3);
};

/** Ideal Switch — with control arrow */
DRAW['ideal-switch'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;

  // Control lead (from gridPos[0])
  drawLead(ctx, gx1, gy1, cx / G, (cy - 8) / G, elm.volts[0], elm.volts[0]);

  // Switch terminals
  drawLead(ctx, cx / G - 0.5, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  if (elm.gridPos.length > 2) {
    drawLead(ctx, cx / G + 0.5, cy / G, elm.gridPos[2][0], elm.gridPos[2][1], 0, 0);
  }

  // Switch body
  ctx.strokeStyle = '#94a3b8'; ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(cx - 6, cy); ctx.lineTo(cx + 6, cy - 6);
  ctx.stroke();

  // Arrow from control
  ctx.strokeStyle = '#f59e0b'; ctx.lineWidth = 1;
  ctx.beginPath(); ctx.moveTo(cx, cy - 8); ctx.lineTo(cx, cy - 3); ctx.stroke();
  ctx.fillStyle = '#f59e0b';
  ctx.beginPath(); ctx.moveTo(cx - 2, cy - 4); ctx.lineTo(cx + 2, cy - 4); ctx.lineTo(cx, cy - 1); ctx.fill();

  // Posts
  ctx.fillStyle = '#06b6d4';
  ctx.beginPath(); ctx.arc(cx - 6, cy, 2.5, 0, Math.PI * 2); ctx.fill();
  ctx.beginPath(); ctx.arc(cx + 6, cy, 2.5, 0, Math.PI * 2); ctx.fill();
};

/** Clock Source — square wave icon */
DRAW['clock'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);

  ctx.strokeStyle = '#e2e8f0'; ctx.lineWidth = 1.5;
  ctx.beginPath(); ctx.arc(cx, cy, 10, 0, Math.PI * 2); ctx.stroke();

  // Square wave inside
  ctx.strokeStyle = '#22c55e'; ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.moveTo(cx - 6, cy + 3); ctx.lineTo(cx - 6, cy - 3);
  ctx.lineTo(cx - 2, cy - 3); ctx.lineTo(cx - 2, cy + 3);
  ctx.lineTo(cx + 2, cy + 3); ctx.lineTo(cx + 2, cy - 3);
  ctx.lineTo(cx + 6, cy - 3); ctx.lineTo(cx + 6, cy + 3);
  ctx.stroke();
};

/** Relay — coil + switch */
DRAW['relay'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);

  // Coil box
  ctx.strokeStyle = '#94a3b8'; ctx.lineWidth = 1.5;
  ctx.strokeRect(cx - 10, cy - 8, 20, 16);
  // Coil symbol inside
  ctx.beginPath();
  for (let i = 0; i < 3; i++) {
    ctx.moveTo(cx - 5 + i * 5, cy - 4);
    ctx.quadraticCurveTo(cx - 2.5 + i * 5, cy - 8, cx + i * 5, cy - 4);
  }
  ctx.stroke();

  ctx.font = '7px monospace'; ctx.fillStyle = '#64748b'; ctx.textAlign = 'center';
  ctx.fillText('RELAY', cx, cy + 5);
};

/** VCO — circle with frequency label */
DRAW.vco = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  drawLead(ctx, gx1, gy1, cx / G, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);

  ctx.strokeStyle = '#22c55e'; ctx.lineWidth = 1.5;
  ctx.beginPath(); ctx.arc(cx, cy, 12, 0, Math.PI * 2); ctx.stroke();
  // Sine wave inside
  ctx.beginPath();
  for (let i = -8; i <= 8; i++) {
    const x = cx + i, y = cy + Math.sin(i * 0.8) * 4;
    i === -8 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
  }
  ctx.stroke();
  ctx.font = '7px monospace'; ctx.fillStyle = '#22c55e'; ctx.textAlign = 'center';
  ctx.fillText('VCO', cx, cy + 18);
};

/** Transmission Line — parallel lines */
DRAW['transmission-line'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  drawLead(ctx, gx1, gy1, (gx1 + 1) , gy1, elm.volts[0], elm.volts[0]);
  drawLead(ctx, (gx2 - 1), gy2, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  const x1 = (gx1 + 1) * G, x2 = (gx2 - 1) * G;
  const cy = gy1 * G;
  ctx.strokeStyle = '#f59e0b'; ctx.lineWidth = 2;
  ctx.beginPath(); ctx.moveTo(x1, cy - 3); ctx.lineTo(x2, cy - 3); ctx.stroke();
  ctx.beginPath(); ctx.moveTo(x1, cy + 3); ctx.lineTo(x2, cy + 3); ctx.stroke();
  ctx.font = '7px monospace'; ctx.fillStyle = '#f59e0b'; ctx.textAlign = 'center';
  ctx.fillText('Z₀=' + (elm.z0 || 50) + 'Ω', (x1 + x2) / 2, cy + 14);
};

/** Subcircuit — box with name */
DRAW.subcircuit = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
  const cx = ((gx1 + gx2) / 2) * G, cy = ((gy1 + gy2) / 2) * G;
  drawLead(ctx, gx1, gy1, cx / G - 0.5, cy / G, elm.volts[0], elm.volts[0]);
  drawLead(ctx, cx / G + 0.5, cy / G, gx2, gy2, elm.volts[1] || 0, elm.volts[1] || 0);
  ctx.strokeStyle = '#8b5cf6'; ctx.lineWidth = 1.5;
  ctx.strokeRect(cx - 14, cy - 10, 28, 20);
  ctx.font = '8px sans-serif'; ctx.fillStyle = '#c4b5fd'; ctx.textAlign = 'center';
  ctx.fillText(elm.subName || 'SUB', cx, cy + 3);
};

/** 7-Segment Display — shows lit segments */
DRAW['seven-seg'] = (ctx, elm) => {
  const [gx1, gy1] = elm.gridPos[0];
  const cx = gx1 * G + 16, cy = gy1 * G + 20;
  const segs = elm.segments || [false,false,false,false,false,false,false];
  const ON = '#ef4444', OFF = '#1e1e2e';
  const w = 12, h = 10, t = 3;

  // Background
  ctx.fillStyle = '#0a0a14';
  ctx.fillRect(cx - 10, cy - 14, 24, 36);
  ctx.strokeStyle = '#2d3139'; ctx.lineWidth = 1;
  ctx.strokeRect(cx - 10, cy - 14, 24, 36);

  // a (top horizontal)
  ctx.fillStyle = segs[0] ? ON : OFF;
  ctx.fillRect(cx - 5, cy - 12, w, t);
  // b (top-right vertical)
  ctx.fillStyle = segs[1] ? ON : OFF;
  ctx.fillRect(cx + 6, cy - 10, t, h);
  // c (bottom-right vertical)
  ctx.fillStyle = segs[2] ? ON : OFF;
  ctx.fillRect(cx + 6, cy + 2, t, h);
  // d (bottom horizontal)
  ctx.fillStyle = segs[3] ? ON : OFF;
  ctx.fillRect(cx - 5, cy + 12, w, t);
  // e (bottom-left vertical)
  ctx.fillStyle = segs[4] ? ON : OFF;
  ctx.fillRect(cx - 6, cy + 2, t, h);
  // f (top-left vertical)
  ctx.fillStyle = segs[5] ? ON : OFF;
  ctx.fillRect(cx - 6, cy - 10, t, h);
  // g (middle horizontal)
  ctx.fillStyle = segs[6] ? ON : OFF;
  ctx.fillRect(cx - 5, cy, w, t);
};

// ═══════════════════════════════════════════
// Main render function
// ═══════════════════════════════════════════

export class Renderer {
  constructor() {
    this.showValues = true;
    this.showDots = true;
    this.showVoltageColors = true;
    this.conventionalCurrent = true;
    this.currentMult = 0;
    this._lastFrameTime = 0;
  }

  /** Update currentMult based on frame timing */
  updateDotSpeed(currentTime, speedFactor = 50) {
    const dt = this._lastFrameTime ? currentTime - this._lastFrameTime : 16;
    this._lastFrameTime = currentTime;
    this.currentMult = 1.7 * dt * Math.exp(speedFactor / 3.5 - 14.2);
    if (!this.conventionalCurrent) this.currentMult = -this.currentMult;
  }

  /** Draw all elements */
  drawElements(ctx, elements) {
    for (const elm of elements) {
      const drawFn = DRAW[elm.type];
      if (drawFn) drawFn(ctx, elm, this.showValues);
    }
  }

  /** Draw current dots on all elements */
  drawDots(ctx, elements) {
    if (!this.showDots) return;
    ctx.fillStyle = this.conventionalCurrent ? '#fbbf24' : '#22d3ee';

    for (const elm of elements) {
      if (!elm.gridPos || elm.gridPos.length < 2) continue;
      // Advance dot position
      if (elm._curcount === undefined) elm._curcount = 0;
      const cadd = (elm.current || 0) * this.currentMult;
      if (Math.abs(cadd) < 1e-6) { elm._curcount = 0; continue; }  // no current → reset dots
      elm._curcount = (elm._curcount + (cadd % 8)) % 16;
      if (Math.abs(elm._curcount) < 0.001) continue;

      const [gx1, gy1] = elm.gridPos[0], [gx2, gy2] = elm.gridPos[1];
      const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
      const dx = x2 - x1, dy = y2 - y1;
      const dn = Math.sqrt(dx * dx + dy * dy);
      if (dn < 1) continue;

      const spacing = 16;
      let pos = ((elm._curcount % spacing) + spacing) % spacing;
      while (pos < dn) {
        const px = x1 + dx * pos / dn;
        const py = y1 + dy * pos / dn;
        ctx.fillRect(px - DOT_SIZE / 2, py - DOT_SIZE / 2, DOT_SIZE, DOT_SIZE);
        pos += spacing;
      }
    }
  }

  /** Draw post dots at all terminals */
  drawPosts(ctx, elements, selectedElm) {
    for (const elm of elements) {
      if (!elm.gridPos) continue;
      const isSel = elm === selectedElm;
      for (const [gx, gy] of elm.gridPos) {
        drawPost(ctx, gx, gy, isSel);
      }
    }
  }

  /** Draw selection highlight */
  drawSelection(ctx, elm) {
    if (!elm || !elm.gridPos) return;
    const [gx1, gy1] = elm.gridPos[0];
    const [gx2, gy2] = elm.gridPos[elm.gridPos.length - 1];
    const x1 = gx1 * G, y1 = gy1 * G, x2 = gx2 * G, y2 = gy2 * G;
    ctx.strokeStyle = 'rgba(34,211,238,0.4)';
    ctx.lineWidth = 8;
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
  }

  /** Draw ghost preview during placement */
  drawGhost(ctx, type, gx1, gy1, gx2, gy2) {
    ctx.globalAlpha = 0.5;
    const fakeElm = {
      type, gridPos: [[gx1, gy1], [gx2, gy2]],
      volts: [0, 0], current: 0, resistance: 1000, voltage: 5,
      capacitance: 1e-6, inductance: 1e-3,
    };
    const drawFn = DRAW[type];
    if (drawFn) drawFn(ctx, fakeElm, false);
    ctx.globalAlpha = 1;
  }
}
