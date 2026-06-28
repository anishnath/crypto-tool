/**
 * Math AI chat — calculus solve/steps/graph (same engines as latex/editor Σ Solve).
 */
import {
  formatMathActionLabel,
  taskToDisplayLatex,
  taskToSolveLatex,
} from './math-action-extract.js';
import {
  appendEqSlot,
  createMathSlotEl,
  typesetMathSlots,
} from '../katex-render.js';

/** @typedef {'simple'|'steps'|'graph'} MathSolveMode */

function getIntegralCore() {
  return typeof IntegralCalculatorCore !== 'undefined'
    ? IntegralCalculatorCore
    : window.IntegralCalculatorCore;
}

function getDerivativeCore() {
  return typeof DerivativeCalculatorCore !== 'undefined'
    ? DerivativeCalculatorCore
    : window.DerivativeCalculatorCore;
}

function getLimitCore() {
  return typeof LimitCalculatorCore !== 'undefined'
    ? LimitCalculatorCore
    : window.LimitCalculatorCore;
}

/** @param {object} core */
async function solveFromCore(core, latex, withSteps) {
  if (!core?.solveFromLatex) {
    throw new Error('Calculator engine not loaded.');
  }
  const r = core.solveFromLatex(latex, { withSteps });
  return (r && typeof r.then === 'function') ? r : Promise.resolve(r);
}

function appendMethod(parent, method) {
  if (!method) return;
  const p = document.createElement('p');
  p.className = 'vca-math-result-method';
  p.textContent = method;
  parent.appendChild(p);
}

/**
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveIntegralTask(task, mode = 'simple') {
  const core = getIntegralCore();
  if (!core?.solveFromLatex) {
    return { ok: false, error: 'IntegralCalculatorCore not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);
  const withSteps = mode === 'steps';
  const r = await solveFromCore(core, problemLatex, withSteps);

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not solve.', mode, problemLatex };
  }

  let resultLatex = r.resultLatex || '';
  const isDef = !!(r.input && r.input.isDefinite);
  if (!isDef && resultLatex && !/\+\s*C\b/i.test(resultLatex)) {
    resultLatex += ' + C';
  }

  return {
    ok: true,
    mode,
    action: 'integral',
    resultLatex,
    method: r.method || 'Integration',
    steps: r.steps || [],
    input: r.input,
    result: r.result,
    problemLatex,
  };
}

/**
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveDerivativeTask(task, mode = 'simple') {
  const core = getDerivativeCore();
  if (!core?.solveFromLatex) {
    return { ok: false, error: 'DerivativeCalculatorCore not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);
  const withSteps = mode === 'steps';
  const r = await solveFromCore(core, problemLatex, withSteps);

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not differentiate.', mode, problemLatex };
  }

  return {
    ok: true,
    mode,
    action: 'derivative',
    resultLatex: r.resultLatex || '',
    method: r.method || 'Derivative',
    steps: r.steps || [],
    input: r.input,
    result: r.result,
    problemLatex,
  };
}

/**
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveLimitTask(task, mode = 'simple') {
  const core = getLimitCore();
  if (!core?.solveFromLatex) {
    return { ok: false, error: 'LimitCalculatorCore not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);
  const withSteps = mode === 'steps';
  const r = await solveFromCore(core, problemLatex, withSteps);

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not evaluate limit.', mode, problemLatex };
  }

  return {
    ok: true,
    mode,
    action: 'limit',
    resultLatex: r.resultLatex || '',
    method: r.method || 'Limit',
    steps: r.steps || [],
    input: r.input,
    result: r.result,
    problemLatex,
  };
}

/**
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {object} [shell]
 * @param {MathSolveMode} [mode]
 */
export async function computeTaskInChat(task, _shell, mode = 'simple') {
  const action = task?.action || 'integral';
  if (action === 'derivative') return solveDerivativeTask(task, mode);
  if (action === 'limit') return solveLimitTask(task, mode);
  return solveIntegralTask(task, mode);
}

function evalAtPoint(exprStr, v, xVal) {
  try {
    const nd = typeof nerdamer !== 'undefined' ? nerdamer : window.nerdamer;
    if (!nd) return null;
    const scope = {};
    scope[v] = xVal;
    const val = parseFloat(nd(exprStr).evaluate(scope).text('decimals'));
    if (!Number.isFinite(val) || Math.abs(val) > 1e6) return null;
    return val;
  } catch (_) {
    return null;
  }
}

function evalBound(raw, core) {
  if (core?.evalBound) {
    const n = core.evalBound(raw);
    if (Number.isFinite(n)) return n;
  }
  const s = String(raw ?? '').trim();
  if (s === 'pi' || s === '\\pi') return Math.PI;
  if (s === '-pi' || s === '-\\pi') return -Math.PI;
  if (s === 'oo' || s === 'inf' || s === '\\infty') return Infinity;
  const p = parseFloat(s);
  return Number.isFinite(p) ? p : NaN;
}

function antiderivExpr(parsed) {
  try {
    const nd = typeof nerdamer !== 'undefined' ? nerdamer : window.nerdamer;
    if (!nd) return null;
    const intg = nd(`integrate(${parsed.bodyExpr}, ${parsed.variable})`);
    if (typeof intg.hasIntegral === 'function' && intg.hasIntegral()) return null;
    return intg.text();
  } catch (_) {
    return null;
  }
}

function plotlyLayout(v, isDark, height = 240) {
  return {
    margin: { t: 24, r: 12, b: 36, l: 44 },
    height,
    xaxis: {
      title: v,
      gridcolor: isDark ? '#334155' : '#e2e8f0',
      zerolinecolor: isDark ? '#475569' : '#cbd5e1',
      color: isDark ? '#cbd5e1' : '#475569',
    },
    yaxis: {
      gridcolor: isDark ? '#334155' : '#e2e8f0',
      zerolinecolor: isDark ? '#475569' : '#cbd5e1',
      color: isDark ? '#cbd5e1' : '#475569',
    },
    paper_bgcolor: isDark ? '#1e293b' : '#fff',
    plot_bgcolor: isDark ? '#1e293b' : '#fff',
    font: { family: 'Inter, sans-serif', size: 11, color: isDark ? '#cbd5e1' : '#475569' },
    legend: { x: 0, y: 1.1, orientation: 'h', font: { size: 10 } },
    showlegend: true,
  };
}

function ensurePlotly(plotEl, drawFn) {
  return new Promise((resolve) => {
    const loadFn = typeof loadPlotly === 'function' ? loadPlotly : null;
    if (loadFn && typeof Plotly === 'undefined') {
      loadFn(() => {
        if (!window.Plotly) { resolve(false); return; }
        drawFn();
        resolve(true);
      });
      return;
    }
    if (typeof Plotly === 'undefined') {
      resolve(false);
      return;
    }
    drawFn();
    resolve(true);
  });
}

function sampleCurve(expr, v, xMin, xMax, n = 500) {
  const xs = [];
  const ys = [];
  const step = (xMax - xMin) / n;
  for (let i = 0; i <= n; i++) {
    const xVal = xMin + i * step;
    xs.push(xVal);
    ys.push(evalAtPoint(expr, v, xVal));
  }
  return { xs, ys };
}

/**
 * @param {HTMLElement} plotEl
 * @param {object} parsed
 */
export function renderIntegralGraphInChat(plotEl, parsed) {
  if (!plotEl || !parsed?.bodyExpr) return Promise.resolve(false);

  return ensurePlotly(plotEl, () => {
    const core = getIntegralCore();
    const v = parsed.variable || 'x';
    const expr = parsed.bodyExpr;
    const isDef = parsed.isDefinite;
    const antideriv = antiderivExpr(parsed);

    let xMin;
    let xMax;
    if (isDef && parsed.lower != null && parsed.upper != null) {
      const aNum = evalBound(parsed.lower, core);
      const bNum = evalBound(parsed.upper, core);
      const range = Math.abs(bNum - aNum) || 2;
      xMin = aNum - range * 0.5;
      xMax = bNum + range * 0.5;
    } else {
      xMin = -10;
      xMax = 10;
    }

    const { xs, ys: ysFx } = sampleCurve(expr, v, xMin, xMax);
    const ysAntideriv = antideriv ? sampleCurve(antideriv, v, xMin, xMax).ys : [];

    /** @type {object[]} */
    const traces = [{
      x: xs,
      y: ysFx,
      type: 'scatter',
      mode: 'lines',
      name: `f(${v})`,
      line: { color: '#4f46e5', width: 2.5 },
    }];

    if (!isDef && antideriv) {
      traces.push({
        x: xs,
        y: ysAntideriv,
        type: 'scatter',
        mode: 'lines',
        name: `F(${v})`,
        line: { color: '#10b981', width: 2, dash: 'dash' },
      });
    }

    if (isDef && parsed.lower != null && parsed.upper != null) {
      const aNum = evalBound(parsed.lower, core);
      const bNum = evalBound(parsed.upper, core);
      const fillXs = [];
      const fillYs = [];
      const fillN = 200;
      const fillStep = (bNum - aNum) / fillN;
      for (let j = 0; j <= fillN; j++) {
        const fx = aNum + j * fillStep;
        fillXs.push(fx);
        fillYs.push(evalAtPoint(expr, v, fx));
      }
      fillXs.push(bNum);
      fillYs.push(0);
      fillXs.push(aNum);
      fillYs.push(0);
      traces.push({
        x: fillXs,
        y: fillYs,
        type: 'scatter',
        mode: 'lines',
        fill: 'toself',
        fillcolor: 'rgba(79, 70, 229, 0.15)',
        line: { color: 'rgba(79, 70, 229, 0.3)', width: 0 },
        name: `Area [${parsed.lower}, ${parsed.upper}]`,
      });
    }

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.Plotly.newPlot(plotEl, traces, plotlyLayout(v, isDark), {
      responsive: true,
      displayModeBar: false,
    });
  });
}

/**
 * @param {HTMLElement} plotEl
 * @param {object} parsed
 * @param {object} [result]
 */
export function renderDerivativeGraphInChat(plotEl, parsed, result) {
  if (!plotEl || !parsed?.bodyExpr) return Promise.resolve(false);

  return ensurePlotly(plotEl, () => {
    const v = parsed.variable || 'x';
    const expr = parsed.bodyExpr;
    const derivExpr = result?.value || null;

    const xMin = -8;
    const xMax = 8;
    const { xs, ys: ysFx } = sampleCurve(expr, v, xMin, xMax);

    /** @type {object[]} */
    const traces = [{
      x: xs,
      y: ysFx,
      type: 'scatter',
      mode: 'lines',
      name: `f(${v})`,
      line: { color: '#4f46e5', width: 2.5 },
    }];

    if (derivExpr) {
      const { ys: ysDeriv } = sampleCurve(derivExpr, v, xMin, xMax);
      traces.push({
        x: xs,
        y: ysDeriv,
        type: 'scatter',
        mode: 'lines',
        name: `f'(${v})`,
        line: { color: '#f59e0b', width: 2, dash: 'dash' },
      });
    }

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.Plotly.newPlot(plotEl, traces, plotlyLayout(v, isDark), {
      responsive: true,
      displayModeBar: false,
    });
  });
}

/**
 * @param {HTMLElement} plotEl
 * @param {object} parsed
 * @param {object} [result]
 */
export function renderLimitGraphInChat(plotEl, parsed, result) {
  if (!plotEl || !parsed?.bodyExpr) return Promise.resolve(false);

  return ensurePlotly(plotEl, () => {
    const core = getLimitCore();
    const v = parsed.variable || 'x';
    const expr = parsed.bodyExpr;
    const a = evalBound(parsed.pointStr, core);
    const center = Number.isFinite(a) ? a : 0;
    const span = Math.abs(center) > 5 ? Math.abs(center) * 0.4 : 2;
    const xMin = center - span * 2;
    const xMax = center + span * 2;
    const { xs, ys } = sampleCurve(expr, v, xMin, xMax);

    /** @type {object[]} */
    const traces = [{
      x: xs,
      y: ys,
      type: 'scatter',
      mode: 'lines',
      name: `f(${v})`,
      line: { color: '#4f46e5', width: 2.5 },
    }];

    if (Number.isFinite(a)) {
      traces.push({
        x: [a, a],
        y: [null, null],
        type: 'scatter',
        mode: 'lines',
        name: `${v} → ${parsed.pointStr}`,
        line: { color: '#ef4444', width: 2, dash: 'dot' },
        xaxis: 'x',
        yaxis: 'y',
      });
    }

    const limitVal = result?.value;
    if (limitVal != null && Number.isFinite(Number(limitVal))) {
      const y = Number(limitVal);
      traces.push({
        x: [xMin, xMax],
        y: [y, y],
        type: 'scatter',
        mode: 'lines',
        name: 'limit',
        line: { color: '#10b981', width: 2, dash: 'dash' },
      });
    }

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.Plotly.newPlot(plotEl, traces, plotlyLayout(v, isDark), {
      responsive: true,
      displayModeBar: false,
    });
  });
}

function escapeHtml(s) {
  return String(s ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function chipActionsForTask(task) {
  const action = task?.action || 'integral';
  if (action === 'derivative') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Differentiate (same as Σ Solve)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step derivative' },
      { mode: 'graph', label: 'Show graph', title: 'Plot f(x) and f\'(x)' },
    ];
  }
  if (action === 'limit') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Evaluate limit (same as Σ Solve)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step limit' },
      { mode: 'graph', label: 'Show graph', title: 'Plot f(x) near the limit point' },
    ];
  }
  return [
    { mode: 'simple', label: 'Solve', title: 'Compute the integral (same as Σ Solve)' },
    { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step solution' },
    { mode: 'graph', label: 'Show graph', title: 'Plot f(x) with shaded area or antiderivative' },
  ];
}

/**
 * @param {HTMLElement} card
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {object} result
 */
export async function renderChatResultCard(card, task, result) {
  card.classList.remove('is-computing');
  card.classList.add(result.ok ? 'is-ok' : 'is-error');

  const body = card.querySelector('.vca-math-result-body');
  if (!body) return;

  if (!result.ok) {
    body.innerHTML = `<p class="vca-math-result-error">${escapeHtml(result.error || 'Computation failed')}</p>`;
    return;
  }

  const problem = taskToDisplayLatex(task);
  const answer = result.resultLatex || '';

  body.replaceChildren();

  if (result.mode === 'graph') {
    appendEqSlot(body, problem);
    appendMethod(body, result.method);
    const graph = document.createElement('div');
    graph.className = 'vca-math-graph';
    graph.dataset.mathGraph = '1';
    body.appendChild(graph);
    if (answer) appendEqSlot(body, `${problem} = ${answer}`, 'vca-math-eq-answer');
  } else if (result.mode === 'steps' && Array.isArray(result.steps) && result.steps.length > 0) {
    appendEqSlot(body, problem);
    appendMethod(body, result.method);
    const ol = document.createElement('ol');
    ol.className = 'vca-math-steps-list';
    result.steps.forEach((s) => {
      const li = document.createElement('li');
      const title = document.createElement('span');
      title.className = 'vca-math-step-title';
      title.textContent = s.title || 'Step';
      const math = document.createElement('div');
      math.className = 'vca-math-step-math';
      math.appendChild(createMathSlotEl(s.latex || '', true));
      li.appendChild(title);
      li.appendChild(math);
      ol.appendChild(li);
    });
    body.appendChild(ol);
    appendEqSlot(body, `${problem} = ${answer}`, 'vca-math-eq-answer');
  } else {
    appendEqSlot(body, `${problem} = ${answer}`);
    appendMethod(body, result.method);
  }

  await typesetMathSlots(body);

  if (result.mode === 'graph' && result.input) {
    const plotEl = body.querySelector('.vca-math-graph');
    if (plotEl) {
      const action = task.action || result.action || 'integral';
      if (action === 'derivative') void renderDerivativeGraphInChat(plotEl, result.input, result.result);
      else if (action === 'limit') void renderLimitGraphInChat(plotEl, result.input, result.result);
      else void renderIntegralGraphInChat(plotEl, result.input);
    }
  }
}

/**
 * Calculus question card — KaTeX problem + Solve / Steps / Graph chips.
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {number} index
 * @param {object} shell
 */
export function createCalculusQuestionCard(task, index, shell) {
  const card = document.createElement('div');
  card.className = 'vca-math-result-card is-question';
  card.dataset.mathTaskIndex = String(index);
  card.dataset.mathAction = task.action || 'integral';

  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = formatMathActionLabel(task, index);

  const body = document.createElement('div');
  body.className = 'vca-math-result-body';

  const problemLatex = taskToDisplayLatex(task);
  body.replaceChildren();
  const probWrap = document.createElement('div');
  probWrap.className = 'vca-math-eq vca-math-problem';
  probWrap.appendChild(createMathSlotEl(problemLatex, true));
  body.appendChild(probWrap);
  void typesetMathSlots(body);

  const chips = document.createElement('div');
  chips.className = 'vca-math-solve-chips';
  chips.setAttribute('role', 'group');
  chips.setAttribute('aria-label', 'Solve options');

  chipActionsForTask(task).forEach(({ mode, label, title }) => {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'vca-math-solve-chip';
    btn.dataset.mathMode = mode;
    btn.textContent = label;
    btn.title = title;

    btn.addEventListener('click', async () => {
      if (card.classList.contains('is-computing')) return;
      card.classList.add('is-computing');
      chips.querySelectorAll('button').forEach((b) => { b.disabled = true; });
      btn.classList.add('is-active');

      const status = document.createElement('p');
      status.className = 'vca-math-result-status';
      status.textContent = mode === 'graph' ? 'Computing & plotting…' : 'Solving…';
      body.appendChild(status);

      try {
        const result = typeof shell?.computeInChat === 'function'
          ? await shell.computeInChat(task, mode)
          : await computeTaskInChat(task, null, mode);
        status.remove();
        await renderChatResultCard(card, task, result);
        if (typeof window.mathShell === 'object') {
          const prev = Array.isArray(window.mathShell.lastChatResults)
            ? window.mathShell.lastChatResults
            : [];
          window.mathShell.lastChatResults = prev.concat([{ task, result }]).slice(-12);
        }
      } catch (err) {
        status.remove();
        await renderChatResultCard(card, task, {
          ok: false,
          error: err?.message || 'Solve failed',
          mode,
        });
      } finally {
        card.classList.remove('is-computing');
        chips.querySelectorAll('button').forEach((b) => { b.disabled = false; });
      }
    });

    chips.appendChild(btn);
  });

  card.appendChild(head);
  card.appendChild(body);
  card.appendChild(chips);
  return card;
}

/** @deprecated use createCalculusQuestionCard */
export function createIntegralQuestionCard(task, index, shell) {
  return createCalculusQuestionCard(task, index, shell);
}

/** @deprecated use createCalculusQuestionCard */
export function createComputingCard(task, index) {
  return createCalculusQuestionCard(task, index, {});
}

export { taskToDisplayLatex, taskToSolveLatex };
