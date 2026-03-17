/**
 * VarPicker — dropdown to select which variables to plot on graph axes.
 */

/**
 * @param {object} simVars — sim.vars definition {name: {index, label, symbol}}
 * @param {HTMLElement} containerEl
 * @param {object} defaults — { x: 'varName', y: 'varName' }
 * @param {function} onPick — (xIdx, yIdx, xLabel, yLabel) => void
 */
export function buildVarPicker(simVars, containerEl, defaults, onPick) {
  const wrap = document.createElement('div');
  wrap.className = 'lab-var-picker';

  const varNames = Object.keys(simVars);

  const xSel = makeDropdown('X:', varNames, simVars, defaults.x);
  const ySel = makeDropdown('Y:', varNames, simVars, defaults.y);

  function emit() {
    const xName = xSel.select.value;
    const yName = ySel.select.value;
    const xDef = simVars[xName];
    const yDef = simVars[yName];
    onPick(xDef.index, yDef.index, xDef.symbol || xDef.label, yDef.symbol || yDef.label);
  }

  xSel.select.addEventListener('change', emit);
  ySel.select.addEventListener('change', emit);

  wrap.appendChild(xSel.row);
  wrap.appendChild(ySel.row);
  containerEl.appendChild(wrap);
}

function makeDropdown(label, varNames, simVars, defaultName) {
  const row = document.createElement('div');
  row.className = 'picker-row';
  const lbl = document.createElement('span');
  lbl.className = 'picker-label';
  lbl.textContent = label;
  const select = document.createElement('select');
  select.className = 'picker-select';
  varNames.forEach(name => {
    const def = simVars[name];
    const o = document.createElement('option');
    o.value = name;
    o.textContent = (def.symbol || '') + ' ' + def.label;
    if (name === defaultName) o.selected = true;
    select.appendChild(o);
  });
  row.appendChild(lbl);
  row.appendChild(select);
  return { row, select };
}

/**
 * Resolve default graph vars from sim definition.
 * Pure logic — testable without DOM.
 */
export function resolveGraphDefaults(simVars, graphDefaults, graphType) {
  const defaults = graphDefaults?.[graphType];
  if (!defaults) {
    const names = Object.keys(simVars);
    return { x: names[0] || 'x', y: names[1] || 'y' };
  }
  if (graphType === 'phase') return { x: defaults.x, y: defaults.y };
  // For time graph: return first two line vars
  if (Array.isArray(defaults)) return { x: 'time', y: defaults[0] };
  return { x: 'time', y: Object.keys(simVars)[0] };
}
