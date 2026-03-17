/**
 * EngineControls — shared settings for all sims.
 * Show energy, show clock, solver choice, time step, background, share.
 */

export function buildEngineControls(containerEl, runner, opts = {}) {
  const section = document.createElement('details');
  section.className = 'lab-engine-settings';
  const summary = document.createElement('summary');
  summary.textContent = 'Settings';
  section.appendChild(summary);

  const body = document.createElement('div');
  body.className = 'engine-body';

  // Show Energy checkbox
  const energyCb = makeCheckbox('Show Energy', opts.showEnergy !== false, v => {
    if (opts.onToggleEnergy) opts.onToggleEnergy(v);
  });
  body.appendChild(energyCb);

  // Show Clock checkbox
  const clockCb = makeCheckbox('Show Clock', opts.showClock !== false, v => {
    if (opts.onToggleClock) opts.onToggleClock(v);
  });
  body.appendChild(clockCb);

  // Show Vectors checkbox (only if sim supports it)
  if (opts.onToggleVectors) {
    const vecCb = makeCheckbox('Show Vectors', false, v => {
      opts.onToggleVectors(v);
    });
    body.appendChild(vecCb);
  }

  // Solver dropdown
  const solverRow = document.createElement('div');
  solverRow.className = 'engine-row';
  const solverLabel = document.createElement('span');
  solverLabel.textContent = 'Solver';
  solverLabel.className = 'param-label';
  const solverSel = document.createElement('select');
  solverSel.className = 'param-select';
  ['rk4', 'midpoint', 'euler'].forEach(s => {
    const o = document.createElement('option');
    o.value = s; o.textContent = s.toUpperCase();
    if (s === (runner.solverName || 'rk4')) o.selected = true;
    solverSel.appendChild(o);
  });
  solverSel.addEventListener('change', () => runner.setSolver(solverSel.value));
  solverRow.appendChild(solverLabel);
  solverRow.appendChild(solverSel);
  body.appendChild(solverRow);

  // Time Step slider
  const dtRow = makeSlider('Time Step', runner.dt, 0.001, 0.05, 0.001, v => runner.setDt(v));
  body.appendChild(dtRow);

  // Background dropdown
  const bgRow = document.createElement('div');
  bgRow.className = 'engine-row';
  const bgLabel = document.createElement('span');
  bgLabel.textContent = 'Background';
  bgLabel.className = 'param-label';
  const bgSel = document.createElement('select');
  bgSel.className = 'param-select';
  ['dark', 'grid', 'white'].forEach(b => {
    const o = document.createElement('option');
    o.value = b; o.textContent = b.charAt(0).toUpperCase() + b.slice(1);
    bgSel.appendChild(o);
  });
  bgSel.addEventListener('change', () => {
    if (opts.onBackground) opts.onBackground(bgSel.value);
  });
  bgRow.appendChild(bgLabel);
  bgRow.appendChild(bgSel);
  body.appendChild(bgRow);

  // Share button — uses ToolUtils from tool-utils.js if available
  const shareBtn = document.createElement('button');
  shareBtn.className = 'lab-share-btn';
  shareBtn.textContent = 'Share Link';
  shareBtn.addEventListener('click', () => {
    const params = {};
    const simParams = runner.params;
    for (const [k, v] of Object.entries(simParams)) params[k] = v;

    if (typeof ToolUtils !== 'undefined' && ToolUtils.generateShareUrl) {
      const url = ToolUtils.generateShareUrl(params, {
        toolName: opts.toolName || 'Physics Lab',
        showSupportPopup: true,
      });
      ToolUtils.copyToClipboard(url, {
        toastMessage: 'Share link copied!',
        showSupportPopup: true,
        toolName: opts.toolName || 'Physics Lab',
      });
    } else if (opts.onShare) {
      opts.onShare();
    }
  });
  body.appendChild(shareBtn);

  section.appendChild(body);
  containerEl.appendChild(section);
}

function makeCheckbox(label, initial, onChange) {
  const row = document.createElement('label');
  row.className = 'engine-check';
  const cb = document.createElement('input');
  cb.type = 'checkbox';
  cb.checked = initial;
  cb.addEventListener('change', () => onChange(cb.checked));
  row.appendChild(cb);
  row.appendChild(document.createTextNode(' ' + label));
  return row;
}

function makeSlider(label, initial, min, max, step, onChange) {
  const row = document.createElement('div');
  row.className = 'engine-row';
  const lbl = document.createElement('span');
  lbl.textContent = label;
  lbl.className = 'param-label';
  const val = document.createElement('span');
  val.className = 'param-value';
  val.textContent = initial.toFixed(3);
  const slider = document.createElement('input');
  slider.type = 'range'; slider.min = min; slider.max = max; slider.step = step; slider.value = initial;
  slider.className = 'param-slider';
  slider.addEventListener('input', () => {
    const v = parseFloat(slider.value);
    val.textContent = v.toFixed(3);
    onChange(v);
  });
  row.appendChild(lbl);
  row.appendChild(val);
  row.appendChild(slider);
  return row;
}

/**
 * Build share URL from current params.
 * Pure logic — testable without DOM.
 */
export function encodeShareUrl(baseUrl, params) {
  const pairs = [];
  for (const [k, v] of Object.entries(params)) {
    pairs.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
  }
  return baseUrl + '#' + pairs.join('&');
}

export function decodeShareUrl(hash) {
  if (!hash || hash.length < 2) return {};
  const params = {};
  hash.slice(1).split('&').forEach(pair => {
    const [k, v] = pair.split('=').map(decodeURIComponent);
    const num = parseFloat(v);
    params[k] = isNaN(num) ? v : num;
  });
  return params;
}
