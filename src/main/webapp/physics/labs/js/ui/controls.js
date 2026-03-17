/**
 * Controls — auto-generate sliders, checkboxes, dropdowns from sim.params.
 */

/**
 * Build sim-specific parameter controls.
 * @param {object} params — sim.params definition
 * @param {HTMLElement} containerEl
 * @param {function} onChange — (paramName, value) => void
 */
export function buildSimControls(params, containerEl, onChange) {
  const section = document.createElement('div');
  section.className = 'lab-params';

  for (const [name, def] of Object.entries(params)) {
    // Skip non-UI params (like startAngle which is only used in init)
    if (def.hidden) continue;

    const row = document.createElement('div');
    row.className = 'param-row';

    if (def.type === 'bool') {
      // Checkbox
      const label = document.createElement('label');
      label.className = 'param-check';
      const cb = document.createElement('input');
      cb.type = 'checkbox';
      cb.checked = !!def.value;
      cb.addEventListener('change', () => onChange(name, cb.checked));
      label.appendChild(cb);
      label.appendChild(document.createTextNode(' ' + def.label));
      row.appendChild(label);
    } else if (def.type === 'choice' && def.options) {
      // Dropdown
      const label = document.createElement('label');
      label.className = 'param-label';
      label.textContent = def.label;
      const sel = document.createElement('select');
      sel.className = 'param-select';
      def.options.forEach(opt => {
        const o = document.createElement('option');
        o.value = opt;
        o.textContent = opt;
        if (opt === def.value) o.selected = true;
        sel.appendChild(o);
      });
      sel.addEventListener('change', () => onChange(name, sel.value));
      row.appendChild(label);
      row.appendChild(sel);
    } else {
      // Slider (default)
      const label = document.createElement('div');
      label.className = 'param-header';
      const nameSpan = document.createElement('span');
      nameSpan.className = 'param-label';
      nameSpan.textContent = def.label || name;
      const valueSpan = document.createElement('span');
      valueSpan.className = 'param-value';
      valueSpan.textContent = formatValue(def.value, def.step) + (def.unit ? ' ' + def.unit : '');
      label.appendChild(nameSpan);
      label.appendChild(valueSpan);

      const slider = document.createElement('input');
      slider.type = 'range';
      slider.className = 'param-slider';
      slider.min = def.min;
      slider.max = def.max;
      slider.step = def.step || 0.01;
      slider.value = def.value;
      slider.addEventListener('input', () => {
        const v = parseFloat(slider.value);
        valueSpan.textContent = formatValue(v, def.step) + (def.unit ? ' ' + def.unit : '');
        onChange(name, v);
      });

      row.appendChild(label);
      row.appendChild(slider);
      row.dataset.param = name;
      row.dataset.slider = '';
    }
    section.appendChild(row);
  }
  containerEl.appendChild(section);

  // Return updater so presets can sync slider positions
  return {
    updateSliders(currentParams) {
      section.querySelectorAll('[data-param]').forEach(row => {
        const name = row.dataset.param;
        const slider = row.querySelector('input[type="range"]');
        const valueSpan = row.querySelector('.param-value');
        const def = params[name];
        if (slider && currentParams[name] !== undefined) {
          slider.value = currentParams[name];
          if (valueSpan && def) {
            valueSpan.textContent = formatValue(currentParams[name], def.step) + (def.unit ? ' ' + def.unit : '');
          }
        }
      });
    }
  };
}

function formatValue(v, step) {
  if (step && step >= 1) return Math.round(v).toString();
  if (step && step >= 0.1) return v.toFixed(1);
  return v.toFixed(2);
}

/**
 * Pure logic: extract default param values from sim.params definition.
 * Testable without DOM.
 */
export function extractDefaults(params) {
  const result = {};
  for (const [name, def] of Object.entries(params)) {
    result[name] = def.value;
  }
  return result;
}
