/**
 * Presets — pill buttons from sim.presets array.
 */

/**
 * @param {Array} presets — sim.presets [{name, params}]
 * @param {HTMLElement} containerEl
 * @param {function} onSelect — (preset, index) => void
 */
export function buildPresets(presets, containerEl, onSelect) {
  if (!presets || presets.length === 0) return { setActive() {} };

  const wrap = document.createElement('div');
  wrap.className = 'lab-presets';

  const buttons = [];

  presets.forEach((preset, i) => {
    const btn = document.createElement('button');
    btn.className = 'preset-btn' + (i === 0 ? ' active' : '');
    btn.textContent = preset.name;
    btn.addEventListener('click', () => {
      buttons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      onSelect(preset, i);
    });
    wrap.appendChild(btn);
    buttons.push(btn);
  });

  containerEl.appendChild(wrap);

  return {
    setActive(index) {
      buttons.forEach((b, i) => b.classList.toggle('active', i === index));
    },
    clearActive() {
      buttons.forEach(b => b.classList.remove('active'));
    },
  };
}

/**
 * Apply a preset to params object — merges defaults with overrides.
 * Pure logic — testable without DOM.
 */
export function applyPreset(defaults, preset) {
  const result = { ...defaults };
  if (preset.params) {
    for (const [k, v] of Object.entries(preset.params)) {
      result[k] = v;
    }
  }
  return result;
}
