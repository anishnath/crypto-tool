import { Charge, ELEMENTARY_CHARGE, PI, potentialsAndFields } from '../pycharge/index.js';

const MU_0 = 4 * Math.PI * 1e-7;

function clamp(value, minValue, maxValue) {
  return Math.max(minValue, Math.min(maxValue, value));
}

function linspace(minValue, maxValue, count) {
  if (count <= 1) return [minValue];
  const step = (maxValue - minValue) / (count - 1);
  const out = new Array(count);
  for (let i = 0; i < count; i += 1) out[i] = minValue + step * i;
  return out;
}

function blueRedColor(value) {
  const x = clamp(value, -1, 1);
  const t = (x + 1) * 0.5;
  const cool = [33, 102, 172];
  const center = [248, 248, 248];
  const warm = [178, 24, 43];
  let r;
  let g;
  let b;
  if (t <= 0.5) {
    const f = t / 0.5;
    r = Math.round(cool[0] * (1 - f) + center[0] * f);
    g = Math.round(cool[1] * (1 - f) + center[1] * f);
    b = Math.round(cool[2] * (1 - f) + center[2] * f);
  } else {
    const f = (t - 0.5) / 0.5;
    r = Math.round(center[0] * (1 - f) + warm[0] * f);
    g = Math.round(center[1] * (1 - f) + warm[1] * f);
    b = Math.round(center[2] * (1 - f) + warm[2] * f);
  }
  return [r, g, b];
}

function signedLogNormalize(value, maxAbs) {
  const scale = Math.max(maxAbs, 1e-30);
  const normalized = Math.abs(value) / scale;
  const mapped = Math.log10(1 + 999 * normalized) / 3;
  return Math.sign(value) * mapped;
}

function makeCircularPosition(radius, omega, phase) {
  return (timeValue) => [
    radius * Math.cos(omega * timeValue + phase),
    radius * Math.sin(omega * timeValue + phase),
    0,
  ];
}

export function initCurrentCoilLab({
  fieldCanvas,
  axisCanvas,
  histCanvas,
  tabsContainer,
  controls,
  stats,
  chargesInput,
  radiusInput,
  omegaInput,
  gridInput,
  extentInput,
  speedInput,
  probeInput,
  playButton,
  recomputeButton,
  insightBox,
  probePyEl,
  probeBiotEl,
  probeErrEl,
  centerBzEl,
  matchBadgeEl,
  cursorBzEl,
  guideLineEl,
}) {
  const fieldCtx = fieldCanvas.getContext('2d');
  const axisCtx = axisCanvas.getContext('2d');
  const histCtx = histCanvas.getContext('2d');
  const heatCanvas = document.createElement('canvas');
  const heatCtx = heatCanvas.getContext('2d');

  const state = {
    numCharges: Number(chargesInput.value),
    radiusCm: Number(radiusInput.value),
    omegaE8: Number(omegaInput.value),
    gridCount: Number(gridInput.value),
    extentMul: Number(extentInput.value),
    speed: Number(speedInput.value),
    probeZMul: Number(probeInput.value),
    running: true,
    t: 0,
    lastTimeMs: 0,
    fieldAt: null,
    bzGrid: null,
    maxAbsBz: 1,
    zAxis: [],
    bPy: [],
    bBiot: [],
    mouse: { inside: false, x: 0, y: 0, bz: null },
    recomputeTimer: null,
    frameId: null,
  };

  function setLabel(role, value) {
    controls.querySelector(`[data-role="${role}"]`).textContent = value;
  }

  function updateLabels() {
    setLabel('charges-value', `${state.numCharges}`);
    setLabel('radius-value', `${state.radiusCm.toFixed(2)} cm`);
    setLabel('omega-value', `${state.omegaE8.toFixed(2)} ×10⁸`);
    setLabel('grid-value', `${state.gridCount}`);
    setLabel('extent-value', `${state.extentMul.toFixed(2)}R`);
    setLabel('speed-value', `${state.speed.toFixed(2)}×`);
    setLabel('probe-value', `${state.probeZMul.toFixed(2)}R`);
  }

  function syncInputsFromState() {
    chargesInput.value = String(state.numCharges);
    radiusInput.value = String(state.radiusCm);
    omegaInput.value = String(state.omegaE8);
    gridInput.value = String(state.gridCount);
    extentInput.value = String(state.extentMul);
    speedInput.value = String(state.speed);
    probeInput.value = String(state.probeZMul);
  }

  function worldRadius() {
    return state.radiusCm * 1e-2;
  }

  function worldExtent() {
    return state.extentMul * worldRadius();
  }

  function currentOmega() {
    return state.omegaE8 * 1e8;
  }

  function rebuildModel() {
    const radius = worldRadius();
    const omega = currentOmega();
    const charges = [];
    for (let i = 0; i < state.numCharges; i += 1) {
      const phase = (2 * PI * i) / state.numCharges;
      charges.push(new Charge(makeCircularPosition(radius, omega, phase), ELEMENTARY_CHARGE));
    }
    state.fieldAt = potentialsAndFields(charges);
  }

  function resizeCanvases() {
    const dpr = devicePixelRatio || 1;
    const fieldRect = fieldCanvas.getBoundingClientRect();
    const axisRect = axisCanvas.getBoundingClientRect();
    const histRect = histCanvas.getBoundingClientRect();
    fieldCanvas.width = Math.max(500, Math.floor(fieldRect.width * dpr));
    fieldCanvas.height = Math.max(500, Math.floor(fieldRect.height * dpr));
    axisCanvas.width = Math.max(500, Math.floor(axisRect.width * dpr));
    axisCanvas.height = Math.max(300, Math.floor(axisRect.height * dpr));
    histCanvas.width = Math.max(500, Math.floor(histRect.width * dpr));
    histCanvas.height = Math.max(300, Math.floor(histRect.height * dpr));
  }

  function computeBzGrid() {
    const extent = worldExtent();
    const grid = linspace(-extent, extent, state.gridCount);
    const flatX = [];
    const flatY = [];
    const flatZ = [];
    const flatT = [];
    for (let yi = 0; yi < grid.length; yi += 1) {
      for (let xi = 0; xi < grid.length; xi += 1) {
        flatX.push(grid[xi]);
        flatY.push(grid[yi]);
        flatZ.push(0);
        flatT.push(0);
      }
    }
    const values = state.fieldAt(flatX, flatY, flatZ, flatT);
    const bz = new Float64Array(flatX.length);
    let maxAbs = 1e-30;
    for (let i = 0; i < values.length; i += 1) {
      const value = values[i].magnetic[2];
      bz[i] = value;
      maxAbs = Math.max(maxAbs, Math.abs(value));
    }
    state.bzGrid = { grid, bz };
    state.maxAbsBz = maxAbs;
  }

  function computeAxisComparison() {
    const radius = worldRadius();
    const omega = currentOmega();
    const zAxis = linspace(-5 * radius, 5 * radius, 240);
    const xAxis = new Array(zAxis.length).fill(0);
    const yAxis = new Array(zAxis.length).fill(0);
    const tAxis = new Array(zAxis.length).fill(0);
    const values = state.fieldAt(xAxis, yAxis, zAxis, tAxis);
    const py = values.map((q) => q.magnetic[2]);

    const current = (state.numCharges * ELEMENTARY_CHARGE * omega) / (2 * PI);
    const biot = zAxis.map((z) => (MU_0 * current * radius * radius) / (2 * (z * z + radius * radius) ** 1.5));

    state.zAxis = zAxis;
    state.bPy = py;
    state.bBiot = biot;
  }

  function recomputeFields() {
    updateLabels();
    rebuildModel();
    computeBzGrid();
    computeAxisComparison();
  }

  function scheduleRecompute(delayMs = 180) {
    if (state.recomputeTimer) clearTimeout(state.recomputeTimer);
    state.recomputeTimer = setTimeout(() => {
      recomputeFields();
      render();
      state.recomputeTimer = null;
    }, delayMs);
  }

  function interpolateSeries(xArray, yArray, xValue) {
    if (xArray.length === 0) return 0;
    if (xValue <= xArray[0]) return yArray[0];
    if (xValue >= xArray[xArray.length - 1]) return yArray[yArray.length - 1];
    for (let i = 0; i < xArray.length - 1; i += 1) {
      const left = xArray[i];
      const right = xArray[i + 1];
      if (xValue >= left && xValue <= right) {
        const f = (xValue - left) / (right - left);
        return yArray[i] * (1 - f) + yArray[i + 1] * f;
      }
    }
    return yArray[yArray.length - 1];
  }

  function updateNarrativeWidgets() {
    const radius = worldRadius();
    const probeZ = state.probeZMul * radius;
    const pyVal = interpolateSeries(state.zAxis, state.bPy, probeZ);
    const biotVal = interpolateSeries(state.zAxis, state.bBiot, probeZ);
    const relErr = Math.abs(pyVal - biotVal) / (Math.abs(biotVal) + 1e-30);

    const centerIndex = Math.floor(state.bzGrid.bz.length / 2);
    const centerBz = state.bzGrid.bz[centerIndex] || 0;

    probePyEl.textContent = `PyCharge Bz: ${pyVal.toExponential(3)} T`;
    probeBiotEl.textContent = `Biot-Savart Bz: ${biotVal.toExponential(3)} T`;
    probeErrEl.textContent = `Relative error: ${(relErr * 100).toFixed(2)}%`;
    centerBzEl.textContent = `Center Bz: ${centerBz.toExponential(3)} T`;
    matchBadgeEl.classList.remove('good');

    if (relErr < 0.05) {
      insightBox.textContent = 'Excellent match: discrete moving charges closely reproduce Biot-Savart on-axis behavior.';
      matchBadgeEl.textContent = 'Match quality: Excellent';
      matchBadgeEl.classList.add('good');
      guideLineEl.textContent = 'Try Coarse Charges now to feel discretization artifacts, then return to Smooth Ring.';
    } else if (relErr < 0.15) {
      insightBox.textContent = 'Good match with visible discretization effects. Try increasing charge count for smoother agreement.';
      matchBadgeEl.textContent = 'Match quality: Good';
      guideLineEl.textContent = 'Increase Discrete Charges or reduce probe distance to improve agreement.';
    } else {
      insightBox.textContent = 'Noticeable mismatch. Explore how more charges and moderate radius improve agreement with Biot-Savart.';
      matchBadgeEl.textContent = 'Match quality: Developing';
      guideLineEl.textContent = 'Use Smooth Ring preset and compare the probe marker on the axis plot.';
    }

    if (state.mouse.inside && state.mouse.bz !== null) {
      cursorBzEl.textContent = `Cursor Bz: ${state.mouse.bz.toExponential(3)} T`;
    } else {
      cursorBzEl.textContent = 'Cursor Bz: --';
    }
  }

  function applyPreset(name) {
    if (name === 'intro') {
      state.numCharges = 30;
      state.radiusCm = 1.0;
      state.omegaE8 = 1.0;
      state.gridCount = 101;
      state.extentMul = 1.5;
      state.speed = 1.0;
      state.probeZMul = 0.0;
    } else if (name === 'strong') {
      state.numCharges = 48;
      state.radiusCm = 1.2;
      state.omegaE8 = 2.2;
      state.gridCount = 111;
      state.extentMul = 1.6;
      state.speed = 1.2;
      state.probeZMul = 0.0;
    } else if (name === 'smooth') {
      state.numCharges = 76;
      state.radiusCm = 1.0;
      state.omegaE8 = 1.0;
      state.gridCount = 141;
      state.extentMul = 1.4;
      state.speed = 0.9;
      state.probeZMul = 1.0;
    } else if (name === 'coarse') {
      state.numCharges = 10;
      state.radiusCm = 1.0;
      state.omegaE8 = 1.0;
      state.gridCount = 71;
      state.extentMul = 1.8;
      state.speed = 1.0;
      state.probeZMul = 0.0;
    }

    syncInputsFromState();
    recomputeFields();
    render();
  }

  function getFieldPlotRect() {
    const left = 58;
    const right = fieldCanvas.width - 86;
    const top = 36;
    const bottom = fieldCanvas.height - 52;
    return {
      left,
      right,
      top,
      bottom,
      width: right - left,
      height: bottom - top,
      colorbarLeft: right + 18,
      colorbarWidth: 14,
    };
  }

  function worldToFieldCanvas(x, y) {
    const extent = worldExtent();
    const rect = getFieldPlotRect();
    const nx = (x + extent) / (2 * extent);
    const ny = (y + extent) / (2 * extent);
    return [rect.left + nx * rect.width, rect.bottom - ny * rect.height];
  }

  function formatAxisTick(value) {
    if (Math.abs(value) < 1e-12) return '0.000';
    return value.toFixed(3);
  }

  function drawHeatmap() {
    const { grid, bz } = state.bzGrid;
    heatCanvas.width = grid.length;
    heatCanvas.height = grid.length;
    const image = heatCtx.createImageData(grid.length, grid.length);

    for (let yi = 0; yi < grid.length; yi += 1) {
      for (let xi = 0; xi < grid.length; xi += 1) {
        const idx = yi * grid.length + xi;
        const normalized = signedLogNormalize(bz[idx], state.maxAbsBz);
        const [r, g, b] = blueRedColor(normalized);
        const fy = grid.length - 1 - yi;
        const p = (fy * grid.length + xi) * 4;
        image.data[p] = r;
        image.data[p + 1] = g;
        image.data[p + 2] = b;
        image.data[p + 3] = 255;
      }
    }
    heatCtx.putImageData(image, 0, 0);
    fieldCtx.imageSmoothingEnabled = false;
    const rect = getFieldPlotRect();
    fieldCtx.save();
    fieldCtx.beginPath();
    fieldCtx.rect(rect.left, rect.top, rect.width, rect.height);
    fieldCtx.clip();
    fieldCtx.drawImage(heatCanvas, rect.left, rect.top, rect.width, rect.height);
    fieldCtx.restore();
  }

  function estimateBzAtWorld(xWorld, yWorld) {
    const { grid, bz } = state.bzGrid;
    const extent = worldExtent();
    const u = ((xWorld + extent) / (2 * extent)) * (grid.length - 1);
    const v = ((yWorld + extent) / (2 * extent)) * (grid.length - 1);
    const i0 = clamp(Math.floor(u), 0, grid.length - 1);
    const j0 = clamp(Math.floor(v), 0, grid.length - 1);
    const i1 = clamp(i0 + 1, 0, grid.length - 1);
    const j1 = clamp(j0 + 1, 0, grid.length - 1);
    const fu = u - i0;
    const fv = v - j0;
    const q00 = bz[j0 * grid.length + i0];
    const q10 = bz[j0 * grid.length + i1];
    const q01 = bz[j1 * grid.length + i0];
    const q11 = bz[j1 * grid.length + i1];
    const top = q00 * (1 - fu) + q10 * fu;
    const bottom = q01 * (1 - fu) + q11 * fu;
    return top * (1 - fv) + bottom * fv;
  }

  function drawCoilOverlay() {
    const radius = worldRadius();
    const omega = currentOmega();

    const [cx, cy] = worldToFieldCanvas(0, 0);
    const [rx] = worldToFieldCanvas(radius, 0);
    const pixelRadius = Math.abs(rx - cx);

    const clipRect = getFieldPlotRect();
    fieldCtx.save();
    fieldCtx.beginPath();
    fieldCtx.rect(clipRect.left, clipRect.top, clipRect.width, clipRect.height);
    fieldCtx.clip();

    fieldCtx.strokeStyle = 'rgba(255,255,255,0.9)';
    fieldCtx.lineWidth = 1.3 * (devicePixelRatio || 1);
    fieldCtx.beginPath();
    fieldCtx.arc(cx, cy, pixelRadius, 0, Math.PI * 2);
    fieldCtx.stroke();

    for (let i = 0; i < state.numCharges; i += 1) {
      const phase = (2 * PI * i) / state.numCharges;
      const x = radius * Math.cos(omega * state.t + phase);
      const y = radius * Math.sin(omega * state.t + phase);
      const [px, py] = worldToFieldCanvas(x, y);
      fieldCtx.fillStyle = '#f97316';
      fieldCtx.beginPath();
      fieldCtx.arc(px, py, 2.3 * (devicePixelRatio || 1), 0, Math.PI * 2);
      fieldCtx.fill();
    }

    fieldCtx.fillStyle = 'rgba(9,18,35,0.72)';
    fieldCtx.fillRect(10, 10, 310, 54);
    fieldCtx.fillStyle = '#E2E8F0';
    fieldCtx.font = `${12 * (devicePixelRatio || 1)}px DM Sans`;
    fieldCtx.fillText('Heatmap: Bz in coil plane (x-y) at z=0', 18, 30);
    fieldCtx.fillText('Blue < 0, Red > 0', 18, 50);

    if (state.mouse.inside) {
      const [mx, my] = worldToFieldCanvas(state.mouse.x, state.mouse.y);
      fieldCtx.strokeStyle = 'rgba(255,255,255,0.6)';
      fieldCtx.lineWidth = 1;
      fieldCtx.beginPath();
      fieldCtx.moveTo(mx, 0);
      fieldCtx.lineTo(mx, fieldCanvas.height);
      fieldCtx.moveTo(0, my);
      fieldCtx.lineTo(fieldCanvas.width, my);
      fieldCtx.stroke();
    }

    fieldCtx.restore();

    drawFieldAxes();
  }

  function drawFieldAxes() {
    const extent = worldExtent();
    const tickValues = [-extent, -extent / 2, 0, extent / 2, extent];
    const rect = getFieldPlotRect();
    const { left, right, top, bottom } = rect;

    fieldCtx.save();
    fieldCtx.strokeStyle = 'rgba(203,213,225,0.8)';
    fieldCtx.lineWidth = 1;
    fieldCtx.strokeRect(left, top, right - left, bottom - top);

    fieldCtx.fillStyle = 'rgba(226,232,240,0.95)';
    fieldCtx.font = `${11 * (devicePixelRatio || 1)}px DM Sans`;

    const sx = (x) => left + ((x + extent) / (2 * extent)) * (right - left);
    const sy = (y) => bottom - ((y + extent) / (2 * extent)) * (bottom - top);

    for (const value of tickValues) {
      const x = sx(value);
      const y = sy(value);

      fieldCtx.beginPath();
      fieldCtx.moveTo(x, bottom);
      fieldCtx.lineTo(x, bottom + 6);
      fieldCtx.moveTo(left - 6, y);
      fieldCtx.lineTo(left, y);
      fieldCtx.stroke();

      fieldCtx.fillText(formatAxisTick(value), x - 16, bottom + 20);
      fieldCtx.fillText(formatAxisTick(value), left - 40, y + 4);
    }

    const barTop = top;
    const barBottom = bottom;
    const gradient = fieldCtx.createLinearGradient(0, barBottom, 0, barTop);
    gradient.addColorStop(0, 'rgb(0,90,170)');
    gradient.addColorStop(0.5, 'rgb(120,120,120)');
    gradient.addColorStop(1, 'rgb(190,25,40)');
    fieldCtx.fillStyle = gradient;
    fieldCtx.fillRect(rect.colorbarLeft, barTop, rect.colorbarWidth, barBottom - barTop);
    fieldCtx.strokeStyle = 'rgba(203,213,225,0.8)';
    fieldCtx.strokeRect(rect.colorbarLeft, barTop, rect.colorbarWidth, barBottom - barTop);

    fieldCtx.fillStyle = 'rgba(226,232,240,0.9)';
    fieldCtx.fillText(`${state.maxAbsBz.toExponential(1)}`, rect.colorbarLeft + 20, barTop + 4);
    fieldCtx.fillText('0', rect.colorbarLeft + 20, (barTop + barBottom) / 2 + 4);
    fieldCtx.fillText(`${(-state.maxAbsBz).toExponential(1)}`, rect.colorbarLeft + 20, barBottom + 4);
    fieldCtx.fillText('Magnetic Field (T)', rect.colorbarLeft - 6, top - 12);

    fieldCtx.textAlign = 'center';
    fieldCtx.font = `${13 * (devicePixelRatio || 1)}px Sora`;
    fieldCtx.fillText('Magnetic Field (Z-component)', (left + right) / 2, 20);
    fieldCtx.textAlign = 'left';

    fieldCtx.fillText('x (m)', (left + right) / 2 - 14, fieldCanvas.height - 8);
    fieldCtx.save();
    fieldCtx.translate(14, (top + bottom) / 2);
    fieldCtx.rotate(-Math.PI / 2);
    fieldCtx.fillText('y (m)', 0, 0);
    fieldCtx.restore();
    fieldCtx.restore();
  }

  function drawAxisPlot() {
    axisCtx.clearRect(0, 0, axisCanvas.width, axisCanvas.height);

    const margin = { left: 60, right: 24, top: 18, bottom: 40 };
    const w = axisCanvas.width - margin.left - margin.right;
    const h = axisCanvas.height - margin.top - margin.bottom;
    const xMin = state.zAxis[0];
    const xMax = state.zAxis[state.zAxis.length - 1];
    const allY = state.bPy.concat(state.bBiot);
    const yMax = Math.max(...allY.map((v) => Math.abs(v))) || 1;
    const yMin = -yMax;

    const sx = (x) => margin.left + ((x - xMin) / (xMax - xMin)) * w;
    const sy = (y) => margin.top + ((yMax - y) / (yMax - yMin)) * h;

    axisCtx.strokeStyle = 'rgba(148,163,184,0.5)';
    axisCtx.lineWidth = 1;
    axisCtx.beginPath();
    axisCtx.moveTo(margin.left, sy(0));
    axisCtx.lineTo(margin.left + w, sy(0));
    axisCtx.moveTo(sx(0), margin.top);
    axisCtx.lineTo(sx(0), margin.top + h);
    axisCtx.stroke();

    function drawLine(series, color) {
      axisCtx.strokeStyle = color;
      axisCtx.lineWidth = 2;
      axisCtx.beginPath();
      for (let i = 0; i < state.zAxis.length; i += 1) {
        const px = sx(state.zAxis[i]);
        const py = sy(series[i]);
        if (i === 0) axisCtx.moveTo(px, py);
        else axisCtx.lineTo(px, py);
      }
      axisCtx.stroke();
    }

    drawLine(state.bPy, '#22d3ee');
    drawLine(state.bBiot, '#f59e0b');

    const probeZ = state.probeZMul * worldRadius();
    const pyProbe = interpolateSeries(state.zAxis, state.bPy, probeZ);
    axisCtx.fillStyle = '#34d399';
    axisCtx.beginPath();
    axisCtx.arc(sx(probeZ), sy(pyProbe), 4, 0, Math.PI * 2);
    axisCtx.fill();

    axisCtx.fillStyle = '#cbd5e1';
    axisCtx.font = `${12 * (devicePixelRatio || 1)}px DM Sans`;
    axisCtx.fillText('z-axis comparison: PyCharge (cyan) vs Biot-Savart (amber)', margin.left, 14);
    axisCtx.fillText('z (m)', margin.left + w / 2 - 10, axisCanvas.height - 8);
    axisCtx.save();
    axisCtx.translate(12, margin.top + h / 2);
    axisCtx.rotate(-Math.PI / 2);
    axisCtx.fillText('Bz (T)', 0, 0);
    axisCtx.restore();
  }

  function drawHistograms() {
    histCtx.clearRect(0, 0, histCanvas.width, histCanvas.height);
    const values = Array.from(state.bzGrid.bz);
    if (values.length === 0) return;

    const midGap = 20;
    const topRect = { left: 56, right: histCanvas.width - 20, top: 24, bottom: histCanvas.height / 2 - midGap };
    const bottomRect = { left: 56, right: histCanvas.width - 20, top: histCanvas.height / 2 + 20, bottom: histCanvas.height - 34 };

    const bins = 36;
    const minB = -state.maxAbsBz;
    const maxB = state.maxAbsBz;
    const histSigned = new Array(bins).fill(0);
    const histAbs = new Array(bins).fill(0);
    const maxAbsObserved = Math.max(...values.map((v) => Math.abs(v)), 1e-30);

    for (const value of values) {
      const tSigned = clamp((value - minB) / (maxB - minB), 0, 1);
      const idxS = Math.min(bins - 1, Math.floor(tSigned * bins));
      histSigned[idxS] += 1;

      const tAbs = clamp(Math.abs(value) / maxAbsObserved, 0, 1);
      const idxA = Math.min(bins - 1, Math.floor(tAbs * bins));
      histAbs[idxA] += 1;
    }

    function drawOneHistogram(rect, data, title, signed) {
      const width = rect.right - rect.left;
      const height = rect.bottom - rect.top;
      const maxCount = Math.max(...data, 1);
      const barWidth = width / data.length;

      histCtx.strokeStyle = 'rgba(203,213,225,0.65)';
      histCtx.strokeRect(rect.left, rect.top, width, height);
      histCtx.fillStyle = 'rgba(226,232,240,0.92)';
      histCtx.font = `${12 * (devicePixelRatio || 1)}px DM Sans`;
      histCtx.fillText(title, rect.left, rect.top - 6);

      for (let i = 0; i < data.length; i += 1) {
        const frac = data[i] / maxCount;
        const bh = frac * (height - 4);
        const x = rect.left + i * barWidth;
        const y = rect.bottom - bh;
        if (signed) {
          const center = (i + 0.5) / data.length;
          const color = blueRedColor(center * 2 - 1);
          histCtx.fillStyle = `rgba(${color[0]},${color[1]},${color[2]},0.85)`;
        } else {
          histCtx.fillStyle = 'rgba(34,211,238,0.85)';
        }
        histCtx.fillRect(x + 1, y, Math.max(1, barWidth - 2), bh);
      }

      histCtx.fillStyle = 'rgba(148,163,184,0.92)';
      histCtx.font = `${10 * (devicePixelRatio || 1)}px DM Sans`;
      if (signed) {
        histCtx.fillText(minB.toExponential(1), rect.left, rect.bottom + 13);
        histCtx.fillText('0', rect.left + width / 2 - 4, rect.bottom + 13);
        histCtx.fillText(maxB.toExponential(1), rect.right - 50, rect.bottom + 13);
      } else {
        histCtx.fillText('0', rect.left, rect.bottom + 13);
        histCtx.fillText(maxAbsObserved.toExponential(1), rect.right - 50, rect.bottom + 13);
      }
    }

    drawOneHistogram(topRect, histSigned, 'Histogram 1: Signed Bz distribution', true);
    drawOneHistogram(bottomRect, histAbs, 'Histogram 2: |Bz| magnitude distribution', false);
  }

  function render() {
    if (!state.bzGrid) return;
    fieldCtx.clearRect(0, 0, fieldCanvas.width, fieldCanvas.height);
    drawHeatmap();
    drawCoilOverlay();
    drawAxisPlot();
    drawHistograms();
    updateNarrativeWidgets();
    stats.textContent = `N=${state.numCharges} • R=${state.radiusCm.toFixed(2)} cm • ω=${state.omegaE8.toFixed(2)}×10⁸ rad/s`;
  }

  function tick(nowMs) {
    if (!state.lastTimeMs) state.lastTimeMs = nowMs;
    const dt = Math.min(0.05, (nowMs - state.lastTimeMs) / 1000);
    state.lastTimeMs = nowMs;
    if (state.running) state.t += dt * state.speed;
    render();
    state.frameId = requestAnimationFrame(tick);
  }

  chargesInput.addEventListener('input', () => {
    state.numCharges = Number(chargesInput.value);
    updateLabels();
    scheduleRecompute();
  });
  radiusInput.addEventListener('input', () => {
    state.radiusCm = Number(radiusInput.value);
    updateLabels();
    scheduleRecompute();
  });
  omegaInput.addEventListener('input', () => {
    state.omegaE8 = Number(omegaInput.value);
    updateLabels();
    scheduleRecompute();
  });
  gridInput.addEventListener('input', () => {
    state.gridCount = Number(gridInput.value);
    updateLabels();
    scheduleRecompute();
  });
  extentInput.addEventListener('input', () => {
    state.extentMul = Number(extentInput.value);
    updateLabels();
    scheduleRecompute();
  });
  speedInput.addEventListener('input', () => {
    state.speed = Number(speedInput.value);
    updateLabels();
  });
  probeInput.addEventListener('input', () => {
    state.probeZMul = Number(probeInput.value);
    updateLabels();
    render();
  });

  controls.querySelectorAll('[data-preset]').forEach((button) => {
    button.addEventListener('click', () => applyPreset(button.dataset.preset));
  });

  recomputeButton.addEventListener('click', () => {
    recomputeFields();
    render();
  });

  playButton.addEventListener('click', () => {
    state.running = !state.running;
    playButton.textContent = state.running ? 'Pause' : 'Play';
  });

  if (tabsContainer) {
    const tabs = tabsContainer.querySelectorAll('[data-view]');
    const panelRoot = fieldCanvas.closest('.lab-canvas-area');
    const panels = panelRoot ? panelRoot.querySelectorAll('.tab-panel') : [];
    tabs.forEach((tab) => {
      tab.addEventListener('click', () => {
        const view = tab.dataset.view;
        tabs.forEach((button) => button.classList.remove('active'));
        tab.classList.add('active');
        panels.forEach((panel) => {
          panel.classList.toggle('active', panel.dataset.panel === view);
        });
        setTimeout(() => {
          resizeCanvases();
          render();
        }, 20);
      });
    });
  }

  function onFieldPointerMove(clientX, clientY) {
    const rect = fieldCanvas.getBoundingClientRect();
    const px = clientX - rect.left;
    const py = clientY - rect.top;
    if (px < 0 || py < 0 || px > rect.width || py > rect.height) {
      state.mouse.inside = false;
      return;
    }
    const plot = getFieldPlotRect();
    const nx = px / rect.width;
    const ny = py / rect.height;
    const canvasX = nx * fieldCanvas.width;
    const canvasY = ny * fieldCanvas.height;
    if (canvasX < plot.left || canvasX > plot.right || canvasY < plot.top || canvasY > plot.bottom) {
      state.mouse.inside = false;
      state.mouse.bz = null;
      return;
    }
    const extent = worldExtent();
    const xWorld = ((canvasX - plot.left) / plot.width) * (2 * extent) - extent;
    const yWorld = (1 - (canvasY - plot.top) / plot.height) * (2 * extent) - extent;
    state.mouse.inside = true;
    state.mouse.x = xWorld;
    state.mouse.y = yWorld;
    state.mouse.bz = state.bzGrid ? estimateBzAtWorld(xWorld, yWorld) : null;
  }

  fieldCanvas.addEventListener('mousemove', (event) => onFieldPointerMove(event.clientX, event.clientY));
  fieldCanvas.addEventListener('mouseleave', () => {
    state.mouse.inside = false;
    state.mouse.bz = null;
  });
  fieldCanvas.addEventListener(
    'touchmove',
    (event) => {
      const touch = event.touches[0];
      if (touch) onFieldPointerMove(touch.clientX, touch.clientY);
    },
    { passive: true },
  );

  window.addEventListener('resize', () => {
    resizeCanvases();
    render();
  });

  resizeCanvases();
  recomputeFields();
  render();
  state.frameId = requestAnimationFrame(tick);

  return {
    destroy() {
      if (state.frameId) cancelAnimationFrame(state.frameId);
    },
  };
}
