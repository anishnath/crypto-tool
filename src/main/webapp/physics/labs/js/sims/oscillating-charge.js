import { Charge, ELEMENTARY_CHARGE, potentialsAndFields } from '../pycharge/index.js';

function linspace(minValue, maxValue, count) {
  if (count <= 1) return [minValue];
  const step = (maxValue - minValue) / (count - 1);
  const result = new Array(count);
  for (let index = 0; index < count; index += 1) {
    result[index] = minValue + index * step;
  }
  return result;
}

function clamp(value, minValue, maxValue) {
  return Math.max(minValue, Math.min(maxValue, value));
}

function viridisColor(t) {
  const stops = [
    [68, 1, 84],
    [59, 82, 139],
    [33, 145, 140],
    [94, 201, 97],
    [253, 231, 37],
  ];
  const scaled = clamp(t, 0, 1) * (stops.length - 1);
  const idx = Math.floor(scaled);
  const frac = scaled - idx;
  const next = Math.min(idx + 1, stops.length - 1);
  return [
    Math.round(stops[idx][0] * (1 - frac) + stops[next][0] * frac),
    Math.round(stops[idx][1] * (1 - frac) + stops[next][1] * frac),
    Math.round(stops[idx][2] * (1 - frac) + stops[next][2] * frac),
  ];
}

export function initOscillatingChargeLab({
  canvas,
  controls,
  stats,
  amplitudeInput,
  omegaInput,
  limitInput,
  gridInput,
  strideInput,
  speedInput,
  playButton,
  resetButton,
}) {
  const context = canvas.getContext('2d');
  const heatCanvas = document.createElement('canvas');
  const heatContext = heatCanvas.getContext('2d');

  const state = {
    amplitudeNm: Number(amplitudeInput.value),
    omegaE16: Number(omegaInput.value),
    limitNm: Number(limitInput.value),
    gridCount: Number(gridInput.value),
    stride: Number(strideInput.value),
    speed: Number(speedInput.value),
    running: true,
    elapsedPhysicalTime: 0,
    period: 1,
    fieldAt: null,
    xCoords: [],
    yCoords: [],
    flatX: [],
    flatY: [],
    flatZ: [],
    frameRequestId: null,
    lastWallTime: 0,
  };

  function updateControlLabels() {
    controls.querySelector('[data-role="amplitude-value"]').textContent = `${state.amplitudeNm.toFixed(2)} nm`;
    controls.querySelector('[data-role="omega-value"]').textContent = `${state.omegaE16.toFixed(2)} ×10¹⁶`;
    controls.querySelector('[data-role="limit-value"]').textContent = `${state.limitNm.toFixed(0)} nm`;
    controls.querySelector('[data-role="grid-value"]').textContent = `${state.gridCount}`;
    controls.querySelector('[data-role="stride-value"]').textContent = `${state.stride}`;
    controls.querySelector('[data-role="speed-value"]').textContent = `${state.speed.toFixed(2)}×`;
  }

  function rebuildChargeModel() {
    const amplitudeMeters = state.amplitudeNm * 1e-9;
    const omega = state.omegaE16 * 1e16;
    state.period = (2 * Math.PI) / Math.max(omega, 1e-9);

    const oscillatingCharge = new Charge(
      (timeValue) => [amplitudeMeters * Math.cos(omega * timeValue), 0, 0],
      ELEMENTARY_CHARGE,
    );

    state.fieldAt = potentialsAndFields([oscillatingCharge]);
  }

  function rebuildGrid() {
    const limitMeters = state.limitNm * 1e-9;
    state.xCoords = linspace(-limitMeters, limitMeters, state.gridCount);
    state.yCoords = linspace(-limitMeters, limitMeters, state.gridCount);
    state.flatX = [];
    state.flatY = [];
    state.flatZ = [];

    for (let yi = 0; yi < state.gridCount; yi += 1) {
      for (let xi = 0; xi < state.gridCount; xi += 1) {
        state.flatX.push(state.xCoords[xi]);
        state.flatY.push(state.yCoords[yi]);
        state.flatZ.push(0);
      }
    }

    heatCanvas.width = state.gridCount;
    heatCanvas.height = state.gridCount;
  }

  function resizeCanvas() {
    const rect = canvas.getBoundingClientRect();
    canvas.width = Math.max(480, Math.floor(rect.width * devicePixelRatio));
    canvas.height = Math.max(480, Math.floor(rect.height * devicePixelRatio));
  }

  function worldToCanvas(x, y, width, height) {
    const limitMeters = state.limitNm * 1e-9;
    const nx = (x + limitMeters) / (2 * limitMeters);
    const ny = (y + limitMeters) / (2 * limitMeters);
    return [nx * width, (1 - ny) * height];
  }

  function computeFieldFrame(timeValue) {
    const times = new Array(state.flatX.length).fill(timeValue);
    const values = state.fieldAt(state.flatX, state.flatY, state.flatZ, times);

    const magnitudes = new Float32Array(state.flatX.length);
    const directions = new Array(state.flatX.length);

    for (let index = 0; index < values.length; index += 1) {
      const electric = values[index].electric;
      const ex = electric[0];
      const ey = electric[1];
      const ez = electric[2];
      const mag = Math.sqrt(ex * ex + ey * ey + ez * ez);
      magnitudes[index] = clamp(mag, 1e4, 1e9);

      const inv = mag > 1e-18 ? 1 / mag : 0;
      directions[index] = [ex * inv, ey * inv];
    }

    return { magnitudes, directions };
  }

  function drawHeatmap(magnitudes) {
    const image = heatContext.createImageData(state.gridCount, state.gridCount);
    const logMin = Math.log10(1e4);
    const logMax = Math.log10(1e9);

    for (let yi = 0; yi < state.gridCount; yi += 1) {
      for (let xi = 0; xi < state.gridCount; xi += 1) {
        const srcIndex = yi * state.gridCount + xi;
        const mag = magnitudes[srcIndex];
        const normalized = (Math.log10(mag) - logMin) / (logMax - logMin);
        const [r, g, b] = viridisColor(normalized);

        const flippedY = state.gridCount - 1 - yi;
        const pixel = (flippedY * state.gridCount + xi) * 4;
        image.data[pixel] = r;
        image.data[pixel + 1] = g;
        image.data[pixel + 2] = b;
        image.data[pixel + 3] = 255;
      }
    }

    heatContext.putImageData(image, 0, 0);
  }

  function drawFrame(fieldFrame) {
    const width = canvas.width;
    const height = canvas.height;
    context.clearRect(0, 0, width, height);
    context.imageSmoothingEnabled = false;

    drawHeatmap(fieldFrame.magnitudes);
    context.drawImage(heatCanvas, 0, 0, width, height);

    context.lineWidth = 1.2 * devicePixelRatio;
    context.strokeStyle = 'rgba(255,255,255,0.8)';

    const stride = Math.max(1, state.stride);
    for (let yi = 0; yi < state.gridCount; yi += stride) {
      for (let xi = 0; xi < state.gridCount; xi += stride) {
        const idx = yi * state.gridCount + xi;
        const dir = fieldFrame.directions[idx];
        const [cx, cy] = worldToCanvas(state.xCoords[xi], state.yCoords[yi], width, height);
        const arrowScale = 8 * devicePixelRatio;
        const tx = cx + dir[0] * arrowScale;
        const ty = cy - dir[1] * arrowScale;

        context.beginPath();
        context.moveTo(cx, cy);
        context.lineTo(tx, ty);
        context.stroke();
      }
    }

    const amplitudeMeters = state.amplitudeNm * 1e-9;
    const omega = state.omegaE16 * 1e16;
    const chargeX = amplitudeMeters * Math.cos(omega * state.elapsedPhysicalTime);
    const [chargeCx, chargeCy] = worldToCanvas(chargeX, 0, width, height);
    context.fillStyle = '#ef4444';
    context.beginPath();
    context.arc(chargeCx, chargeCy, 5 * devicePixelRatio, 0, Math.PI * 2);
    context.fill();

    context.fillStyle = 'rgba(10,18,36,0.7)';
    context.fillRect(10 * devicePixelRatio, 10 * devicePixelRatio, 260 * devicePixelRatio, 72 * devicePixelRatio);
    context.fillStyle = '#e2e8f0';
    context.font = `${12 * devicePixelRatio}px DM Sans`;
    context.fillText(
      `t = ${(state.elapsedPhysicalTime * 1e15).toFixed(2)} fs`,
      18 * devicePixelRatio,
      32 * devicePixelRatio,
    );
    context.fillText(
      `charge x = ${(chargeX * 1e9).toFixed(3)} nm`,
      18 * devicePixelRatio,
      52 * devicePixelRatio,
    );
    context.fillText(
      `|E| log scale [1e4, 1e9]`,
      18 * devicePixelRatio,
      72 * devicePixelRatio,
    );

    stats.textContent = `Period ${(state.period * 1e15).toFixed(2)} fs • Grid ${state.gridCount}×${state.gridCount} • Quiver step ${state.stride}`;
  }

  function animationStep(nowMs) {
    if (!state.lastWallTime) state.lastWallTime = nowMs;
    const dt = Math.min(0.05, (nowMs - state.lastWallTime) / 1000);
    state.lastWallTime = nowMs;

    if (state.running) {
      state.elapsedPhysicalTime += dt * state.speed * state.period;
      while (state.elapsedPhysicalTime >= state.period) state.elapsedPhysicalTime -= state.period;
    }

    try {
      const frame = computeFieldFrame(state.elapsedPhysicalTime);
      drawFrame(frame);
    } catch (error) {
      stats.textContent = `Computation warning: ${error.message}`;
    }

    state.frameRequestId = requestAnimationFrame(animationStep);
  }

  function rebuildAll() {
    updateControlLabels();
    rebuildChargeModel();
    rebuildGrid();
  }

  amplitudeInput.addEventListener('input', () => {
    state.amplitudeNm = Number(amplitudeInput.value);
    rebuildAll();
  });
  omegaInput.addEventListener('input', () => {
    state.omegaE16 = Number(omegaInput.value);
    rebuildAll();
  });
  limitInput.addEventListener('input', () => {
    state.limitNm = Number(limitInput.value);
    rebuildAll();
  });
  gridInput.addEventListener('input', () => {
    state.gridCount = Number(gridInput.value);
    rebuildAll();
  });
  strideInput.addEventListener('input', () => {
    state.stride = Number(strideInput.value);
    updateControlLabels();
  });
  speedInput.addEventListener('input', () => {
    state.speed = Number(speedInput.value);
    updateControlLabels();
  });

  playButton.addEventListener('click', () => {
    state.running = !state.running;
    playButton.textContent = state.running ? 'Pause' : 'Play';
  });

  resetButton.addEventListener('click', () => {
    state.elapsedPhysicalTime = 0;
    state.lastWallTime = 0;
  });

  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();
  rebuildAll();
  state.frameRequestId = requestAnimationFrame(animationStep);

  return {
    destroy() {
      if (state.frameRequestId) cancelAnimationFrame(state.frameRequestId);
    },
  };
}

