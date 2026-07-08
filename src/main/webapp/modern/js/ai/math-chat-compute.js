/**
 * Math AI chat — calculus solve/steps/graph (same engines as latex/editor Σ Solve).
 */
import {
  formatMathActionLabel,
  taskToDisplayLatex,
  taskToSolveLatex,
  ALGEBRA_ACTIONS,
} from './math-action-extract.js';
import {
  appendEqSlot,
  createMathSlotEl,
  prepareLatexForKatex,
  typesetMathSlots,
} from '../katex-render.js';
import { solveAlgebraTask } from './algebra-chat-compute.js';

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

function getOdeCore() {
  return typeof ODECalculatorCore !== 'undefined'
    ? ODECalculatorCore
    : window.ODECalculatorCore;
}

function getPdeCore() {
  return typeof PDECalculatorCore !== 'undefined'
    ? PDECalculatorCore
    : window.PDECalculatorCore;
}

function getVcCore() {
  return typeof VCCalculatorCore !== 'undefined'
    ? VCCalculatorCore
    : window.VCCalculatorCore;
}

function getMatrixCore() {
  return typeof MatrixCalculatorCore !== 'undefined'
    ? MatrixCalculatorCore
    : window.MatrixCalculatorCore;
}

function getVectorDiscreteCore() {
  return typeof VectorDiscreteCore !== 'undefined'
    ? VectorDiscreteCore
    : window.VectorDiscreteCore;
}

function getBodeCore() {
  return typeof BodeCalculatorCore !== 'undefined'
    ? BodeCalculatorCore
    : window.BodeCalculatorCore;
}

function getLaplaceCore() {
  return typeof LaplaceCalculatorCore !== 'undefined'
    ? LaplaceCalculatorCore
    : window.LaplaceCalculatorCore;
}

function getZTransformCore() {
  return typeof ZTransformCalculatorCore !== 'undefined'
    ? ZTransformCalculatorCore
    : window.ZTransformCalculatorCore;
}

function getTrigCore() {
  return typeof TrigChatCore !== 'undefined'
    ? TrigChatCore
    : window.TrigChatCore;
}

function getStatisticsCore() {
  return typeof StatisticsChatCore !== 'undefined'
    ? StatisticsChatCore
    : window.StatisticsChatCore;
}

/** @param {import('./math-action-extract.js').MathActionTask} task */
function matrixCanVisualize(task) {
  const core = getMatrixCore();
  if (!core?.parseTask) return false;
  if (typeof core.canVisualizeTask === 'function') return core.canVisualizeTask(task);
  const parsed = core.parseTask(task);
  if (!parsed) return false;
  if (typeof core.canVisualize === 'function') {
    return core.canVisualize(parsed.op, parsed.cellsA, parsed.cellsB);
  }
  if (typeof core.canVisualize2D === 'function') return core.canVisualize2D(parsed);
  return false;
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
 * Solve an ODE in-chat by calling the SAME SymPy backbone the ODE page uses
 * (ODECalculatorCore.solveTask → build SymPy → /OneCompilerFunctionality →
 * parse). Returns exactly what the page returns — no second engine.
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveOdeTask(task, mode = 'simple') {
  const core = getOdeCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'ODE engine (ODECalculatorCore) not loaded.', mode, problemLatex: '' };
  }
  if (!task?.rhs && !task?.expr) {
    return { ok: false, error: 'No differential equation provided.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);

  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'ODE solve failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not solve this ODE.', mode, problemLatex };
  }

  const cls = r.classification ? r.classification.split(',')[0].trim().replace(/_/g, ' ') : '';
  const method = cls ? cls : 'Symbolic ODE solver';

  return {
    ok: true,
    mode,
    action: 'ode',
    resultLatex: r.resultLatex || '',
    method,
    steps: r.steps || [],
    input: {
      variable: 'x',
      plotX: r.plotX || [],
      plotY: r.plotY || [],
      verified: r.verified,
    },
    result: { value: r.resultLatex || '', verified: r.verified },
    problemLatex,
  };
}

/**
 * Solve a PDE in-chat via the same NumPy/SymPy backbone as the PDE Solver page.
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solvePdeTask(task, mode = 'simple') {
  const core = getPdeCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'PDE engine (PDECalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);

  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'PDE solve failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not solve this PDE.', mode, problemLatex };
  }

  const steps = mode === 'steps' ? (r.steps || []) : [];
  const pdeMode = String(task.mode || r.mode || 'heat').toLowerCase();

  if (mode === 'graph' && !r.surface) {
    return {
      ok: false,
      error: pdeMode === 'linear1'
        ? 'No contour plot for 1st-order linear PDE (analytical solution only).'
        : 'No surface data returned for this PDE — try numeric modes (heat, wave, Laplace, Poisson).',
      mode,
      problemLatex,
    };
  }

  return {
    ok: true,
    mode,
    action: 'pde',
    resultLatex: r.resultLatex || r.text || '',
    method: r.method || 'Finite Difference',
    steps,
    verified: r.verified,
    meta: r.meta || {},
    result: { value: r.resultLatex || r.text || '', verified: r.verified },
    problemLatex,
    input: mode === 'graph' && r.surface
      ? { surface: r.surface, pdeMode }
      : undefined,
  };
}

/**
 * Solve gradient / divergence / curl in-chat via the same SymPy backbone as the VC page.
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveVectorCalculusTask(task, mode = 'simple') {
  const core = getVcCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Vector calculus engine (VCCalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);

  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'Vector calculus solve failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this vector calculus problem.', mode, problemLatex };
  }

  const vcMode = String(r.mode || task.mode || 'gradient').toLowerCase();
  const steps = mode === 'steps' ? (r.steps || []) : [];

  if (mode === 'graph') {
    if (vcMode === 'divergence') {
      return {
        ok: false,
        error: '3D vector field graph is available for gradient and curl only (divergence is a scalar).',
        mode,
        problemLatex,
      };
    }
    if (!Array.isArray(r.plotData) || r.plotData.length === 0) {
      return {
        ok: false,
        error: 'Could not sample the vector field for a 3D plot. Try a simpler expression.',
        mode,
        problemLatex,
      };
    }
  }

  return {
    ok: true,
    mode,
    action: 'vectorCalculus',
    resultLatex: r.resultLatex || '',
    method: r.method || 'Symbolic vector calculus solver',
    steps,
    input: { plotData: r.plotData || [], vcMode },
    result: { value: r.resultLatex || '' },
    problemLatex,
  };
}

/**
 * Solve matrix ops in-chat via MatrixCalculatorCore (same SymPy engine as the page).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveMatrixTask(task, mode = 'simple') {
  const core = getMatrixCore();
  if (!core?.solveTask && !core?.solveFromLatex) {
    return { ok: false, error: 'Matrix engine (MatrixCalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToSolveLatex(task);

  if (mode === 'graph') {
    if (!core.buildPlotlyPlot || !core.canVisualizeTask) {
      return {
        ok: false,
        error: 'Matrix visualization module not loaded.',
        mode,
        problemLatex,
      };
    }
    if (!core.canVisualizeTask(task)) {
      return {
        ok: false,
        error: 'Visualization needs 2×2 or 3×3 numeric matrices on det, inverse, transpose, eigenvectors (2D only), power, multiply, add, or subtract.',
        mode,
        problemLatex,
      };
    }
    const plot = core.buildPlotlyPlot(task);
    if (!plot) {
      return {
        ok: false,
        error: 'Could not build matrix visualization for this problem.',
        mode,
        problemLatex,
      };
    }
    return {
      ok: true,
      mode: 'graph',
      action: 'matrix',
      resultLatex: '',
      method: 'Geometric visualization',
      steps: [],
      input: plot,
      result: {},
      problemLatex,
    };
  }

  const withSteps = mode === 'steps';

  let r;
  try {
    r = core.solveTask
      ? await core.solveTask(task, { withSteps, mode })
      : await solveFromCore(core, problemLatex, withSteps);
  } catch (err) {
    return { ok: false, error: err?.message || 'Matrix solve failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this matrix problem.', mode, problemLatex };
  }

  const steps = withSteps
    ? (r.sympySteps || r.steps || []).map((s) => ({
      title: s.title || 'Step',
      latex: s.latex || '',
    }))
    : [];

  return {
    ok: true,
    mode,
    action: 'matrix',
    resultLatex: r.resultLatex || '',
    method: r.method || r.opLabel || 'Matrix solver',
    steps,
    input: r.input || null,
    result: { value: r.value || r.resultText || r.resultLatex || '' },
    problemLatex,
  };
}

/**
 * Discrete vector ops in-chat (dot, cross, magnitude, projection, …).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveVectorTask(task, mode = 'simple') {
  const core = getVectorDiscreteCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Vector engine (VectorDiscreteCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  const withSteps = mode === 'steps';

  let r;
  try {
    r = core.solveTask(task, { withSteps, mode });
  } catch (err) {
    return { ok: false, error: err?.message || 'Vector computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this vector problem.', mode, problemLatex };
  }

  const steps = withSteps
    ? (r.steps || []).map((s) => ({
      title: s.title || 'Step',
      latex: s.latex || '',
    }))
    : [];

  return {
    ok: true,
    mode,
    action: 'vector',
    resultLatex: r.resultLatex || '',
    method: r.method || r.opLabel || 'Vector calculator',
    steps,
    input: r.input || null,
    result: { value: r.value, type: r.type },
    problemLatex,
  };
}

/**
 * Bode plot in-chat via BodeCalculatorCore (same SymPy backbone as the page).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveBodeTask(task, mode = 'simple') {
  const core = getBodeCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Bode engine (BodeCalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'Bode computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this Bode plot.', mode, problemLatex };
  }

  const steps = mode === 'steps' ? (r.steps || []) : [];
  const resultLatex = r.resultLatex ? `H(s) = ${r.resultLatex}` : '';

  return {
    ok: true,
    mode,
    action: 'bode',
    resultLatex,
    resultText: r.resultText || '',
    method: 'Bode plot',
    steps,
    zeros: r.zeros || [],
    poles: r.poles || [],
    input: mode === 'graph' ? { w: r.plotW, mag: r.plotMag, phase: r.plotPhase } : undefined,
    result: { value: resultLatex },
    problemLatex,
  };
}

/**
 * Laplace transform in-chat via LaplaceCalculatorCore (same SymPy backbone as the page).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveLaplaceTask(task, mode = 'simple') {
  const core = getLaplaceCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Laplace engine (LaplaceCalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  const transformMode = String(task.mode || task.laplaceMode || 'forward').toLowerCase();
  const isInverse = /inverse|ilaplace|inv/.test(transformMode);

  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'Laplace computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this Laplace transform.', mode, problemLatex };
  }

  const steps = mode === 'steps' ? (r.steps || []) : [];
  const symbol = isInverse ? '\\mathcal{L}^{-1}\\{F(s)\\}' : '\\mathcal{L}\\{f(t)\\}';
  const resultLatex = r.resultLatex ? `${symbol} = ${r.resultLatex}` : '';

  return {
    ok: true,
    mode,
    action: 'laplace',
    resultLatex,
    resultText: r.resultText || '',
    method: isInverse ? 'Inverse Laplace transform' : 'Forward Laplace transform',
    steps,
    convergence: r.convergence || null,
    transformMode: isInverse ? 'inverse' : 'forward',
    input: mode === 'graph' && Array.isArray(r.plotX) && r.plotX.length
      ? { x: r.plotX, y: r.plotY }
      : undefined,
    result: { value: resultLatex },
    problemLatex,
  };
}

/**
 * Z-transform in-chat via ZTransformCalculatorCore (same SymPy backbone as the page).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveZTransformTask(task, mode = 'simple') {
  const core = getZTransformCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Z-transform engine (ZTransformCalculatorCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  const transformMode = String(task.mode || task.zTransformMode || 'forward').toLowerCase();
  const isInverse = /inverse|iz|inv/.test(transformMode);

  let r;
  try {
    r = await core.solveTask(task);
  } catch (err) {
    return { ok: false, error: err?.message || 'Z-transform computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this Z-transform.', mode, problemLatex };
  }

  const steps = mode === 'steps' ? (r.steps || []) : [];
  const symbol = isInverse ? '\\mathcal{Z}^{-1}\\{X(z)\\}' : '\\mathcal{Z}\\{x[n]\\}';
  const resultLatex = r.resultLatex ? `${symbol} = ${r.resultLatex}` : '';

  return {
    ok: true,
    mode,
    action: 'ztransform',
    resultLatex,
    resultText: r.resultText || '',
    method: isInverse ? 'Inverse Z-transform' : 'Forward Z-transform',
    steps,
    convergence: r.convergence || null,
    transformMode: isInverse ? 'inverse' : 'forward',
    input: mode === 'graph' && Array.isArray(r.plotX) && r.plotX.length
      ? { x: r.plotX, y: r.plotY }
      : undefined,
    result: { value: resultLatex },
    problemLatex,
  };
}

/**
 * Trigonometry in-chat via TrigBackend + TrigGraph (same engines as trig calculator pages).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveTrigTask(task, mode = 'simple') {
  const core = getTrigCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Trig engine (TrigChatCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  const withSteps = mode === 'steps';

  if (mode === 'graph' && core.canGraphTask && !core.canGraphTask(task)) {
    return {
      ok: false,
      error: 'No graph available for this trig problem.',
      mode,
      problemLatex,
    };
  }

  let r;
  try {
    r = await core.solveTask(task, { withSteps, mode });
  } catch (err) {
    return { ok: false, error: err?.message || 'Trig computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this trig problem.', mode, problemLatex };
  }

  const steps = withSteps
    ? (r.steps || []).map((s) => ({
      title: s.title || 'Step',
      latex: s.latex || '',
    }))
    : [];

  return {
    ok: true,
    mode,
    action: 'trig',
    resultLatex: r.resultLatex || '',
    method: r.method || 'Trigonometry',
    steps,
    input: mode === 'graph' ? r.input : undefined,
    result: { value: r.resultLatex || '' },
    problemLatex,
  };
}

/**
 * Statistics in-chat via StatisticsChatCore + StatsCommon (same engines as stats pages).
 * @param {import('./math-action-extract.js').MathActionTask} task
 * @param {MathSolveMode} mode
 */
export async function solveStatisticsTask(task, mode = 'simple') {
  const core = getStatisticsCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Statistics engine (StatisticsChatCore) not loaded.', mode, problemLatex: '' };
  }

  const problemLatex = taskToDisplayLatex(task);
  const withSteps = mode === 'steps';

  if (mode === 'graph' && core.canGraphTask && !core.canGraphTask(task)) {
    return {
      ok: false,
      error: 'No graph available for this statistics problem.',
      mode,
      problemLatex,
    };
  }

  let r;
  try {
    r = await core.solveTask(task, { withSteps, mode });
  } catch (err) {
    return { ok: false, error: err?.message || 'Statistics computation failed.', mode, problemLatex };
  }

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not compute this statistics problem.', mode, problemLatex };
  }

  const steps = withSteps
    ? (r.steps || []).map((s) => ({
      title: s.title || 'Step',
      latex: s.latex || '',
    }))
    : [];

  return {
    ok: true,
    mode,
    action: 'statistics',
    resultLatex: r.resultLatex || '',
    resultText: r.resultText || '',
    method: r.method || 'Statistics engine',
    steps,
    input: mode === 'graph' ? r.input : undefined,
    result: { value: r.resultLatex || '' },
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
  if (action === 'ode') return solveOdeTask(task, mode);
  if (action === 'pde') return solvePdeTask(task, mode);
  if (action === 'vectorCalculus') return solveVectorCalculusTask(task, mode);
  if (action === 'vector') return solveVectorTask(task, mode);
  if (action === 'matrix') return solveMatrixTask(task, mode);
  if (action === 'bode') return solveBodeTask(task, mode);
  if (action === 'laplace') return solveLaplaceTask(task, mode);
  if (action === 'ztransform') return solveZTransformTask(task, mode);
  if (action === 'trig') return solveTrigTask(task, mode);
  if (action === 'statistics') return solveStatisticsTask(task, mode);
  if (ALGEBRA_ACTIONS.includes(action)) return solveAlgebraTask(task, mode);
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
    const tryDraw = () => {
      if (typeof window.Plotly === 'undefined') {
        resolve(false);
        return;
      }
      drawFn();
      resolve(true);
    };

    if (typeof window.Plotly !== 'undefined') {
      tryDraw();
      return;
    }

    const loadFn = typeof window.loadPlotly === 'function'
      ? window.loadPlotly
      : (window.VecCalcGraph && typeof window.VecCalcGraph.loadPlotly === 'function'
        ? window.VecCalcGraph.loadPlotly
        : null);

    if (loadFn) {
      loadFn(() => tryDraw());
      return;
    }

    const s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = () => tryDraw();
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });
}

/**
 * Unit square / unit cube overlay (same as Matrix Calculator Visualize tab).
 * @param {HTMLElement} plotEl
 * @param {{ traces?: object[], layout?: object, caption?: string, dim?: number }} input
 */
export function renderMatrixGraphInChat(plotEl, input) {
  if (!plotEl || !Array.isArray(input?.traces) || input.traces.length === 0) {
    return Promise.resolve(false);
  }

  return ensurePlotly(plotEl, () => {
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const core = getMatrixCore();
    const layout = core?.applyMatrixPlotDarkTheme
      ? core.applyMatrixPlotDarkTheme(input.layout, isDark)
      : input.layout;

    plotEl.style.minHeight = input.dim === 3 ? '320px' : '280px';

    if (input.caption) {
      const cap = document.createElement('p');
      cap.className = 'vca-math-result-method';
      cap.textContent = input.caption;
      plotEl.appendChild(cap);
    }

    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas';
    chart.style.minHeight = input.dim === 3 ? '280px' : '240px';
    plotEl.appendChild(chart);

    window.Plotly.newPlot(chart, input.traces, layout, {
      responsive: true,
      displayModeBar: false,
      displaylogo: false,
    });
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

const LAGRANGIAN_PLOT_LABELS = {
  trajectory: 'q(t) trajectory',
  phase: 'Phase portrait',
  energy: 'Energy vs time',
  potential: 'Potential well',
};

/** Taller in-chat plots for Lagrangian mechanics (phase portraits, q(t), energy). */
const LAGRANGIAN_CHAT_GRAPH_MIN_PX = 420;

/** Keep custom DOM in assistant bubbles — do not call _finalizeAssistantBubble (it wipes body). */
function finishInjectedAssistantBubble(assistant, bubble, body) {
  bubble.removeAttribute('aria-busy');
  assistant.onAssistantRender?.(body, bubble, '');
  assistant._scroll?.();
}

/**
 * Lagrangian mechanics page plot in chat (same Plotly spec as Plots tab).
 * @param {HTMLElement} plotEl
 * @param {{ traces?: object[], layout?: object }} spec
 */
export function renderLagrangianGraphInChat(plotEl, spec) {
  if (!plotEl || !Array.isArray(spec?.traces) || !spec.traces.length) {
    if (plotEl) {
      plotEl.innerHTML = '<p class="vca-math-result-method">No plot data available. Compute on the Lagrangian page first.</p>';
    }
    return Promise.resolve(false);
  }

  return ensurePlotly(plotEl, () => {
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas lm-chat-plot-canvas';
    chart.style.minHeight = `${LAGRANGIAN_CHAT_GRAPH_MIN_PX}px`;
    plotEl.style.minHeight = `${LAGRANGIAN_CHAT_GRAPH_MIN_PX}px`;
    plotEl.appendChild(chart);
    const layout = {
      ...(spec.layout || {}),
      height: LAGRANGIAN_CHAT_GRAPH_MIN_PX,
      autosize: true,
    };
    window.Plotly.newPlot(chart, spec.traces, layout, {
      responsive: true,
      displayModeBar: true,
      modeBarButtonsToRemove: ['lasso2d', 'select2d'],
      displaylogo: false,
    });
  });
}

/**
 * Inject a page RK45 plot into the Math AI chat (no LLM round-trip).
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 * @param {'trajectory'|'phase'|'energy'|'potential'} plotType
 */
export function injectLagrangianPagePlot(assistant, plotType) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const type = plotType || 'trajectory';
  const label = LAGRANGIAN_PLOT_LABELS[type] || 'Lagrangian plot';
  const ctx = typeof window.lmGetPlotContext === 'function' ? window.lmGetPlotContext() : null;

  assistant._appendBubble('user', `Show ${label} from page results`);

  if (!ctx?.hasPlot || typeof window.lmBuildPlotSpec !== 'function') {
    assistant._appendBubble('assistant', 'Compute a system on the Lagrangian calculator first, then use the plot chips.');
    return;
  }

  const spec = window.lmBuildPlotSpec(type, ctx.data);
  if (!spec?.traces?.length) {
    assistant._appendBubble('assistant', `No data available for the ${label} view for this system.`);
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lm-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = label;
  const plotWrap = document.createElement('div');
  plotWrap.className = 'vca-math-graph lm-chat-plot-wrap';
  plotWrap.style.minHeight = `${LAGRANGIAN_CHAT_GRAPH_MIN_PX}px`;
  const method = document.createElement('p');
  method.className = 'vca-math-result-method';
  method.textContent = 'Same RK45 data as the page Plots tab';
  card.appendChild(head);
  card.appendChild(plotWrap);
  card.appendChild(method);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void renderLagrangianGraphInChat(plotWrap, spec);
}

/**
 * Inject Hamiltonian tab content into Math AI chat (H, Hamilton's eqs, conservation).
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLagrangianPageHamiltonian(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = typeof window.lmGetHamiltonianContext === 'function' ? window.lmGetHamiltonianContext() : null;
  assistant._appendBubble('user', 'Show Hamiltonian mechanics from page results');

  if (!ctx?.hasHamiltonian) {
    assistant._appendBubble('assistant', 'Compute a system on the Lagrangian calculator first, then use Show Hamiltonian.');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lm-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = 'Hamiltonian Mechanics';

  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  const hLabel = document.createElement('p');
  hLabel.className = 'vca-math-result-method';
  hLabel.textContent = 'Hamiltonian';
  cardBody.appendChild(hLabel);
  const hWrap = document.createElement('div');
  hWrap.className = 'vca-math-eq';
  hWrap.appendChild(createMathSlotEl(`H = ${prepareLatexForKatex(ctx.hamiltonian)}`, true));
  cardBody.appendChild(hWrap);

  if (Array.isArray(ctx.hamEqs) && ctx.hamEqs.length) {
    const eqLabel = document.createElement('p');
    eqLabel.className = 'vca-math-result-method';
    eqLabel.textContent = "Hamilton's equations";
    cardBody.appendChild(eqLabel);
    ctx.hamEqs.forEach((eq) => {
      const q = eq?.q || 'q';
      const wrap = document.createElement('div');
      wrap.className = 'vca-math-eq';
      const latex = `\\dot{${q}} = ${prepareLatexForKatex(eq.qdot || '')}, \\quad \\dot{p}_{${q}} = ${prepareLatexForKatex(eq.pdot || '')}`;
      wrap.appendChild(createMathSlotEl(latex, true));
      cardBody.appendChild(wrap);
    });
  }

  if (Array.isArray(ctx.momenta) && ctx.momenta.length) {
    const pLabel = document.createElement('p');
    pLabel.className = 'vca-math-result-method';
    pLabel.textContent = 'Conjugate momenta';
    cardBody.appendChild(pLabel);
    ctx.momenta.forEach((p, i) => {
      const wrap = document.createElement('div');
      wrap.className = 'vca-math-eq';
      wrap.appendChild(createMathSlotEl(prepareLatexForKatex(p), true));
      cardBody.appendChild(wrap);
    });
  }

  if (Array.isArray(ctx.conservation) && ctx.conservation.length) {
    const bits = ctx.conservation.map((c) => {
      let s = `${c.conserved || 'quantity'} conserved`;
      if (c.type === 'cyclic' && c.coord) s += ` (${c.coord} cyclic)`;
      if (c.type === 'time_invariant') s += ' (time-invariant)';
      return s;
    });
    const cLabel = document.createElement('p');
    cLabel.className = 'vca-math-result-method';
    cLabel.textContent = `Conservation laws: ${bits.join('; ')}`;
    cardBody.appendChild(cLabel);
  }

  const method = document.createElement('p');
  method.className = 'vca-math-result-method';
  method.textContent = 'Same symbolic output as the page Hamiltonian tab';
  cardBody.appendChild(method);

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

function appendLatexBlock(container, label, latex, displayMode = true) {
  if (label) {
    const p = document.createElement('p');
    p.className = 'vca-math-result-method';
    p.textContent = label;
    container.appendChild(p);
  }
  const wrap = document.createElement('div');
  wrap.className = 'vca-math-eq';
  wrap.appendChild(createMathSlotEl(latex, displayMode));
  container.appendChild(wrap);
}

/**
 * Inject Euler–Lagrange results (L, EOMs, momenta, conservation) into chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLagrangianPageResults(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = typeof window.lmGetMechanicsContext === 'function' ? window.lmGetMechanicsContext() : null;
  assistant._appendBubble('user', 'Show Lagrangian & equations of motion');

  if (!ctx?.hasResults) {
    assistant._appendBubble('assistant', 'Click **Compute** on the page first, or use a preset chip (e.g. Simple pendulum).');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lm-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = 'Lagrangian & Equations of Motion';
  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  appendLatexBlock(cardBody, 'Lagrangian', `L = ${prepareLatexForKatex(ctx.lagrangian)}`);

  if (Array.isArray(ctx.eoms) && ctx.eoms.length) {
    const eomLabel = document.createElement('p');
    eomLabel.className = 'vca-math-result-method';
    eomLabel.textContent = 'Euler–Lagrange equations';
    cardBody.appendChild(eomLabel);
    ctx.eoms.forEach((eom, i) => {
      appendLatexBlock(cardBody, null, `${prepareLatexForKatex(eom)} = 0`);
    });
  }

  if (Array.isArray(ctx.momenta) && ctx.momenta.length) {
    const pLabel = document.createElement('p');
    pLabel.className = 'vca-math-result-method';
    pLabel.textContent = 'Conjugate momenta';
    cardBody.appendChild(pLabel);
    ctx.momenta.forEach((p) => {
      appendLatexBlock(cardBody, null, prepareLatexForKatex(p));
    });
  }

  if (ctx.hamiltonian) {
    appendLatexBlock(cardBody, 'Hamiltonian', `H = ${prepareLatexForKatex(ctx.hamiltonian)}`);
  }

  if (Array.isArray(ctx.conservation) && ctx.conservation.length) {
    const bits = ctx.conservation.map((c) => {
      let s = `${c.conserved || 'quantity'} conserved`;
      if (c.type === 'cyclic' && c.coord) s += ` (${c.coord} cyclic)`;
      if (c.type === 'time_invariant') s += ' (time-invariant)';
      return s;
    });
    const cLabel = document.createElement('p');
    cLabel.className = 'vca-math-result-method';
    cLabel.textContent = `Conservation: ${bits.join('; ')}`;
    cardBody.appendChild(cLabel);
  }

  const method = document.createElement('p');
  method.className = 'vca-math-result-method';
  method.textContent = 'Same step-by-step result as the page';
  cardBody.appendChild(method);

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

/**
 * Inject symbolic derivation steps (∂L/∂q, d/dt ∂L/∂q̇, EOM) into chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLagrangianDerivationSteps(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = typeof window.lmGetMechanicsContext === 'function' ? window.lmGetMechanicsContext() : null;
  assistant._appendBubble('user', 'Show Euler–Lagrange derivation steps');

  const steps = ctx?.steps?.length ? ctx.steps : null;
  if (!steps?.length) {
    assistant._appendBubble('assistant', 'Compute a system first — derivation steps appear after **Compute**.');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lm-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = `Derivation Steps (${steps.length})`;
  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  steps.forEach((step, i) => {
    const title = step?.title || `Step ${i + 1}`;
    appendLatexBlock(cardBody, title, prepareLatexForKatex(step.latex || ''));
  });

  const method = document.createElement('p');
  method.className = 'vca-math-result-method';
  method.textContent = 'Same steps as **Show Derivation Steps** on the page';
  cardBody.appendChild(method);

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

async function runLagrangianPreset(assistant, presetKey, label) {
  if (!assistant || typeof window.lmApplyPreset !== 'function' || typeof window.lmRunCompute !== 'function') return;
  assistant._appendBubble('user', `Run ${label}`);
  const status = assistant._appendBubble('assistant', `Loading ${label} and computing…`);
  try {
    if (!window.lmApplyPreset(presetKey)) throw new Error(`Unknown preset: ${label}`);
    await window.lmRunCompute();
    status.bubble?.remove();
    assistant._renderQuickActions?.();
    injectLagrangianPageResults(assistant);
  } catch (err) {
    status.bubble?.remove();
    assistant._appendBubble('assistant', err?.message || `Could not compute ${label}.`);
  }
  assistant._scroll?.();
}

/**
 * Lagrangian-focused quick actions — direct page results first, no generic math tutor chips.
 */
/** Taller in-chat plots for logarithm LHS/RHS graphs. */
const LOG_CHAT_GRAPH_MIN_PX = 420;

/**
 * Logarithm page plot in chat (same Plotly spec as Graph tab).
 * @param {HTMLElement} plotEl
 * @param {{ traces?: object[], layout?: object }} spec
 */
export function renderLogGraphInChat(plotEl, spec) {
  if (!plotEl || !Array.isArray(spec?.traces) || !spec.traces.length) {
    if (plotEl) {
      plotEl.innerHTML = '<p class="vca-math-result-method">No graph data. Solve a log equation on the page first (mode Solve with =).</p>';
    }
    return Promise.resolve(false);
  }

  return ensurePlotly(plotEl, () => {
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas lc-chat-plot-canvas';
    chart.style.minHeight = `${LOG_CHAT_GRAPH_MIN_PX}px`;
    plotEl.style.minHeight = `${LOG_CHAT_GRAPH_MIN_PX}px`;
    plotEl.appendChild(chart);
    const layout = {
      ...(spec.layout || {}),
      height: LOG_CHAT_GRAPH_MIN_PX,
      autosize: true,
    };
    window.Plotly.newPlot(chart, spec.traces, layout, {
      responsive: true,
      displayModeBar: true,
      modeBarButtonsToRemove: ['lasso2d', 'select2d'],
      displaylogo: false,
    });
  });
}

function readLogResultContext() {
  if (typeof window.lcGetResultContext === 'function') return window.lcGetResultContext();
  if (typeof window.lcGetContext === 'function') return window.lcGetContext();
  return null;
}

function appendLogStepBlock(container, step, index) {
  const row = document.createElement('div');
  row.className = 'vca-math-step-row';
  row.style.cssText = 'display:flex;gap:0.65rem;align-items:flex-start;margin:0.65rem 0;';

  const num = document.createElement('span');
  num.textContent = String(index + 1);
  num.style.cssText = 'flex-shrink:0;width:22px;height:22px;border-radius:50%;background:#15803d;color:#fff;font-size:0.7rem;font-weight:700;display:flex;align-items:center;justify-content:center;';

  const body = document.createElement('div');
  body.style.flex = '1';
  body.style.minWidth = '0';

  if (step.label || step.rule) {
    const title = document.createElement('p');
    title.className = 'vca-math-result-method';
    title.textContent = step.label || step.rule;
    body.appendChild(title);
  }
  if (step.before_latex) {
    appendLatexBlock(body, null, prepareLatexForKatex(step.before_latex));
  }
  const after = step.after_latex || step.latex || '';
  if (after) {
    appendLatexBlock(body, null, prepareLatexForKatex(after));
  }

  row.appendChild(num);
  row.appendChild(body);
  container.appendChild(row);
}

/**
 * Inject page solve result (KaTeX + method + extraneous) into Math AI chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLogarithmPageResults(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = readLogResultContext();
  assistant._appendBubble('user', 'Show logarithm result from page');

  if (!ctx?.hasResult) {
    assistant._appendBubble('assistant', 'Enter a problem and click **Solve** on the page, or use a ▶ example chip.');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lc-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = `Logarithm — ${ctx.mode || 'solve'}`;
  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  if (ctx.expr) {
    const inLabel = document.createElement('p');
    inLabel.className = 'vca-math-result-method';
    inLabel.textContent = 'Problem';
    cardBody.appendChild(inLabel);
    appendLatexBlock(cardBody, null, prepareLatexForKatex(ctx.expr));
  }

  const resLatex = ctx.resultLatex || ctx.result || '';
  if (resLatex) {
    appendLatexBlock(cardBody, 'Result', prepareLatexForKatex(resLatex));
  }

  if (ctx.numeric != null && ctx.numeric !== '') {
    const num = document.createElement('p');
    num.className = 'vca-math-result-method';
    num.textContent = `Numeric: ${ctx.numeric}`;
    cardBody.appendChild(num);
  }

  if (ctx.method) {
    const method = document.createElement('p');
    method.className = 'vca-math-result-method';
    method.textContent = `${ctx.method}${ctx.solvedBy ? ` (${ctx.solvedBy})` : ''}`;
    cardBody.appendChild(method);
  }

  if (Array.isArray(ctx.extraneous) && ctx.extraneous.length) {
    const exLabel = document.createElement('p');
    exLabel.className = 'vca-math-result-method';
    exLabel.textContent = 'Extraneous (rejected — log argument ≤ 0)';
    cardBody.appendChild(exLabel);
    ctx.extraneous.forEach((ex) => {
      appendLatexBlock(cardBody, null, prepareLatexForKatex(ex));
    });
  }

  const foot = document.createElement('p');
  foot.className = 'vca-math-result-method';
  foot.textContent = 'Same engine output as the page Result panel';
  cardBody.appendChild(foot);

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

/**
 * Inject SymPy / CAS step trace into chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLogarithmSteps(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = readLogResultContext();
  assistant._appendBubble('user', 'Show step-by-step log rules');

  const steps = Array.isArray(ctx?.steps) ? ctx.steps : [];
  if (!steps.length) {
    assistant._appendBubble('assistant', 'No rule-annotated steps for this result. Try Expand, Condense, or Solve with the CAS engine, or use **Show Steps** on the page.');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lc-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = 'Step-by-step (log rules)';
  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  steps.forEach((step, i) => appendLogStepBlock(cardBody, step, i));

  const foot = document.createElement('p');
  foot.className = 'vca-math-result-method';
  foot.textContent = 'Same trace as the page **Show Steps** button';
  cardBody.appendChild(foot);

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

/**
 * Inject LHS/RHS log equation graph into chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLogarithmGraph(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const plotCtx = typeof window.lcGetPlotContext === 'function' ? window.lcGetPlotContext() : null;
  assistant._appendBubble('user', 'Show log equation graph from page');

  if (!plotCtx?.hasPlot || typeof window.lcBuildPlotSpec !== 'function') {
    assistant._appendBubble('assistant', 'Graphs appear for **Solve** mode equations (with =). Solve an equation on the page first, then use this chip.');
    return;
  }

  const spec = window.lcBuildPlotSpec(plotCtx.data);
  if (!spec?.traces?.length) {
    assistant._appendBubble('assistant', 'Could not build a plot for this expression. Check the variable and domain.');
    return;
  }

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lc-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = 'Log equation graph';
  const plotWrap = document.createElement('div');
  plotWrap.className = 'vca-math-graph lc-chat-plot-wrap';
  plotWrap.style.minHeight = `${LOG_CHAT_GRAPH_MIN_PX}px`;
  const method = document.createElement('p');
  method.className = 'vca-math-result-method';
  method.textContent = 'Same LHS/RHS curves as the page Graph tab — intersections are solutions';
  card.appendChild(head);
  card.appendChild(plotWrap);
  card.appendChild(method);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void renderLogGraphInChat(plotWrap, spec);
}

/**
 * Inject domain restrictions for log arguments in the current problem.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 */
export function injectLogarithmDomain(assistant) {
  if (!assistant || typeof assistant._appendBubble !== 'function') return;

  const ctx = readLogResultContext();
  assistant._appendBubble('user', 'Explain log domain for this problem');

  const expr = String(ctx?.expr || '').trim();
  if (!expr) {
    assistant._appendBubble('assistant', 'Enter a logarithm problem on the page first.');
    return;
  }

  const args = typeof window.lcCollectLogArguments === 'function'
    ? window.lcCollectLogArguments(expr)
    : [];

  const { bubble, body } = assistant._appendBubble('assistant', '');
  const card = document.createElement('div');
  card.className = 'vca-math-result-card lc-chat-result-card';
  const head = document.createElement('div');
  head.className = 'vca-math-result-head';
  head.textContent = 'Domain (log arguments > 0)';
  const cardBody = document.createElement('div');
  cardBody.className = 'vca-math-result-body';

  const intro = document.createElement('p');
  intro.className = 'vca-math-result-method';
  intro.textContent = 'Every log ln(u) or log_b(u) requires u > 0. Reject any candidate solution that makes an argument zero or negative.';
  cardBody.appendChild(intro);

  if (args.length) {
    args.forEach((arg) => {
      appendLatexBlock(cardBody, 'Require', `${prepareLatexForKatex(arg)} > 0`);
    });
  } else {
    const note = document.createElement('p');
    note.className = 'vca-math-result-method';
    note.textContent = 'No log(...) sub-expressions detected — numeric evaluation may still need a positive domain.';
    cardBody.appendChild(note);
  }

  card.appendChild(head);
  card.appendChild(cardBody);
  body.appendChild(card);
  finishInjectedAssistantBubble(assistant, bubble, body);
  void typesetMathSlots(cardBody);
}

/**
 * Run page example + solve, then inject result into chat.
 * @param {import('../vibe-coding-assistant.js').ToolAiAssistant} assistant
 * @param {string} expr
 * @param {string} mode
 * @param {string|null} vars
 * @param {string} label
 */
export async function runLogarithmExample(assistant, expr, mode, vars, label) {
  if (!assistant) return;
  assistant._appendBubble('user', `▶ ${label}`);

  if (typeof window.lcApplyExample !== 'function' || typeof window.lcRunSolve !== 'function') {
    assistant._appendBubble('assistant', 'Page solver not ready — refresh and try again.');
    return;
  }

  const status = assistant._appendBubble('assistant', 'Solving on the page…');
  try {
    window.lcApplyExample(expr, mode, vars);
    await window.lcRunSolve();
    status.bubble?.remove();
    injectLogarithmPageResults(assistant);
  } catch (err) {
    status.bubble?.remove();
    assistant._appendBubble('assistant', err?.message || `Could not solve: ${label}`);
  }
  assistant._scroll?.();
}

/**
 * Logarithm-focused quick actions — direct page results, mode-aware examples.
 */
export function buildLogarithmQuickActions() {
  const ctx = readLogResultContext();
  const hasPlot = !!(ctx?.hasPlot && ctx?.mode === 'solve');

  if (ctx?.hasResult) {
    const chips = [
      { label: 'Result', onClick: (a) => injectLogarithmPageResults(a) },
      { label: 'Steps', onClick: (a) => injectLogarithmSteps(a) },
      { label: 'Domain', onClick: (a) => injectLogarithmDomain(a) },
    ];
    if (hasPlot) {
      chips.push({ label: 'Log graph', onClick: (a) => injectLogarithmGraph(a) });
    }
    if (Array.isArray(ctx.extraneous) && ctx.extraneous.length) {
      chips.push({ label: 'Extraneous', onClick: (a) => injectLogarithmPageResults(a) });
    }
    return chips;
  }

  return [
    { label: '▶ ln(x)=2', onClick: (a) => runLogarithmExample(a, 'ln(x)=2', 'solve', null, 'Solve ln(x)=2') },
    { label: '▶ log₂(x)=5', onClick: (a) => runLogarithmExample(a, 'log2(x)=5', 'solve', null, 'Solve log₂(x)=5') },
    { label: '▶ Expand ln(x²y)', onClick: (a) => runLogarithmExample(a, 'log(x^2*y)', 'expand', null, 'Expand ln(x²y)') },
    { label: '▶ Condense 2ln(x)−ln(y)', onClick: (a) => runLogarithmExample(a, '2*log(x)-log(y)', 'condense', null, 'Condense 2·ln(x)−ln(y)') },
    { label: '▶ Evaluate log₂(8)', onClick: (a) => runLogarithmExample(a, 'log2(8)', 'evaluate', null, 'Evaluate log₂(8)') },
    { label: '▶ Product rule', onClick: (a) => runLogarithmExample(a, 'log(x*y)', 'expand', null, 'Expand ln(xy) — product rule') },
  ];
}

export function buildLagrangianQuickActions() {
  const mech = typeof window.lmGetMechanicsContext === 'function' ? window.lmGetMechanicsContext() : null;
  const plot = typeof window.lmGetPlotContext === 'function' ? window.lmGetPlotContext() : null;

  if (mech?.hasResults) {
    const chips = [
      { label: 'EOMs & L', onClick: (a) => injectLagrangianPageResults(a) },
      { label: 'Derivation steps', onClick: (a) => injectLagrangianDerivationSteps(a) },
      { label: 'Hamiltonian', onClick: (a) => injectLagrangianPageHamiltonian(a) },
    ];
    if (plot?.hasPlot) {
      chips.push(
        { label: 'q(t) plot', onClick: (a) => injectLagrangianPagePlot(a, 'trajectory') },
        { label: 'Phase portrait', onClick: (a) => injectLagrangianPagePlot(a, 'phase') },
        { label: 'Energy plot', onClick: (a) => injectLagrangianPagePlot(a, 'energy') },
        { label: 'Potential well', onClick: (a) => injectLagrangianPagePlot(a, 'potential') },
      );
    }
    return chips;
  }

  return [
    { label: '▶ Simple pendulum', onClick: (a) => runLagrangianPreset(a, 'simple_pendulum', 'simple pendulum') },
    { label: '▶ Double pendulum', onClick: (a) => runLagrangianPreset(a, 'double_pendulum', 'double pendulum') },
    { label: '▶ Spring–mass', onClick: (a) => runLagrangianPreset(a, 'spring_mass', 'spring–mass oscillator') },
    { label: '▶ Atwood machine', onClick: (a) => runLagrangianPreset(a, 'atwood', 'Atwood machine') },
  ];
}

/**
 * Plot the ODE solution curve y(x) using the SymPy-sampled PLOT_X/PLOT_Y
 * arrays returned by the engine (general solutions use C=1; IVPs use the
 * fitted constants — exactly like the page's Graph tab).
 * @param {HTMLElement} plotEl
 * @param {object} parsed
 */
export function renderOdeGraphInChat(plotEl, parsed) {
  if (!plotEl) return Promise.resolve(false);
  const xs = parsed?.plotX;
  const ys = parsed?.plotY;
  if (!Array.isArray(xs) || !xs.length || !Array.isArray(ys) || !ys.length) {
    plotEl.innerHTML = '<p class="vca-math-result-method">No solution curve available to plot for this equation.</p>';
    return Promise.resolve(false);
  }

  return ensurePlotly(plotEl, () => {
    const v = parsed.variable || 'x';
    const traces = [{
      x: xs,
      y: ys,
      type: 'scatter',
      mode: 'lines',
      name: `y(${v})`,
      line: { color: '#4f46e5', width: 2.5 },
    }];

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.Plotly.newPlot(plotEl, traces, plotlyLayout(v, isDark), {
      responsive: true,
      displayModeBar: false,
    });
  });
}

/**
 * Dual-subplot Bode magnitude & phase (same engine output as the page Graph tab).
 * @param {HTMLElement} plotEl
 * @param {{ w?: number[], mag?: number[], phase?: number[] }} input
 */
export function renderBodeGraphInChat(plotEl, input) {
  if (!plotEl || !Array.isArray(input?.w) || !input.w.length || !Array.isArray(input?.mag) || !input.mag.length) {
    if (plotEl) {
      plotEl.innerHTML = '<p class="vca-math-result-method">No Bode plot data available for this transfer function.</p>';
    }
    return Promise.resolve(false);
  }

  const loadPlotly = () => new Promise((resolve) => {
    if (window.Plotly) { resolve(true); return; }
    if (typeof window.loadPlotly === 'function') {
      window.loadPlotly(() => resolve(!!window.Plotly));
      return;
    }
    const s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = () => resolve(!!window.Plotly);
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });

  return loadPlotly().then((ok) => {
    if (!ok || !window.Plotly) return false;
    const core = getBodeCore();
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const layout = core?.bodePlotLayout
      ? core.bodePlotLayout(isDark)
      : { margin: { t: 28, r: 16, b: 44, l: 56 }, height: 420 };
    const traces = core?.buildPlotTraces
      ? core.buildPlotTraces(input)
      : [
          { x: input.w, y: input.mag, type: 'scatter', mode: 'lines', line: { color: '#dc2626', width: 2.5 } },
          { x: input.w, y: input.phase, type: 'scatter', mode: 'lines', line: { color: '#2563eb', width: 2.5 } },
        ];
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas';
    chart.style.minHeight = '420px';
    plotEl.appendChild(chart);
    window.Plotly.newPlot(chart, traces, layout, {
      responsive: true,
      displayModeBar: false,
      displaylogo: false,
    });
    return true;
  });
}

/**
 * Time-domain f(t) plot after Laplace transform (same engine output as the page Graph tab).
 * @param {HTMLElement} plotEl
 * @param {{ x?: number[], y?: number[] }} input
 */
export function renderLaplaceGraphInChat(plotEl, input) {
  if (!plotEl || !Array.isArray(input?.x) || !input.x.length || !Array.isArray(input?.y) || !input.y.length) {
    if (plotEl) {
      plotEl.innerHTML = '<p class="vca-math-result-method">No time-domain plot available for this transform.</p>';
    }
    return Promise.resolve(false);
  }

  const loadPlotly = () => new Promise((resolve) => {
    if (window.Plotly) { resolve(true); return; }
    if (typeof window.loadPlotly === 'function') {
      window.loadPlotly(() => resolve(!!window.Plotly));
      return;
    }
    const s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = () => resolve(!!window.Plotly);
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });

  return loadPlotly().then((ok) => {
    if (!ok || !window.Plotly) return false;
    const core = getLaplaceCore();
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const layout = core?.timePlotLayout
      ? core.timePlotLayout(isDark)
      : { margin: { t: 28, r: 16, b: 44, l: 56 }, height: 320 };
    const traces = core?.buildPlotTraces
      ? core.buildPlotTraces(input)
      : [{
          x: input.x,
          y: input.y,
          type: 'scatter',
          mode: 'lines',
          line: { color: '#0891b2', width: 2.5 },
          name: 'f(t)',
        }];
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas';
    chart.style.minHeight = '320px';
    plotEl.appendChild(chart);
    window.Plotly.newPlot(chart, traces, layout, {
      responsive: true,
      displayModeBar: false,
      displaylogo: false,
    });
    return true;
  });
}

/**
 * Discrete stem plot after Z-transform (same engine output as the page Graph tab).
 * @param {HTMLElement} plotEl
 * @param {{ x?: number[], y?: number[] }} input
 */
export function renderZTransformGraphInChat(plotEl, input) {
  if (!plotEl || !Array.isArray(input?.x) || !input.x.length || !Array.isArray(input?.y) || !input.y.length) {
    if (plotEl) {
      plotEl.innerHTML = '<p class="vca-math-result-method">No stem plot available for this transform.</p>';
    }
    return Promise.resolve(false);
  }

  const loadPlotly = () => new Promise((resolve) => {
    if (window.Plotly) { resolve(true); return; }
    if (typeof window.loadPlotly === 'function') {
      window.loadPlotly(() => resolve(!!window.Plotly));
      return;
    }
    const s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = () => resolve(!!window.Plotly);
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });

  return loadPlotly().then((ok) => {
    if (!ok || !window.Plotly) return false;
    const core = getZTransformCore();
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const stem = core?.buildStemPlot ? core.buildStemPlot(input) : null;
    const layout = core?.stemPlotLayout
      ? Object.assign({}, core.stemPlotLayout(isDark), stem ? stem.layoutExtras : {})
      : { margin: { t: 28, r: 16, b: 44, l: 56 }, height: 320 };
    const traces = stem?.traces || [{
      x: input.x,
      y: input.y,
      type: 'scatter',
      mode: 'markers',
      marker: { color: '#059669', size: 8, line: { color: '#047857', width: 1.5 } },
      name: 'x[n]',
    }];
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas';
    chart.style.minHeight = '320px';
    plotEl.appendChild(chart);
    window.Plotly.newPlot(chart, traces, layout, {
      responsive: true,
      displayModeBar: false,
      displaylogo: false,
    });
    return true;
  });
}

/** Plot trig function or unit circle in chat (same Plotly module as trig calculator pages). */
export function renderTrigGraphInChat(plotEl, input) {
  const core = getTrigCore();
  if (core?.renderGraphInChat) {
    return core.renderGraphInChat(plotEl, input);
  }
  if (plotEl) {
    plotEl.innerHTML = '<p class="vca-math-result-method">Trig graph module not loaded.</p>';
  }
  return Promise.resolve(false);
}

/** Histogram or normal curve in chat (StatsGraph + StatisticsChatCore). */
export function renderStatisticsGraphInChat(plotEl, input) {
  const core = getStatisticsCore();
  if (core?.renderGraphInChat) {
    return core.renderGraphInChat(plotEl, input);
  }
  if (plotEl) {
    plotEl.innerHTML = '<p class="vca-math-result-method">Statistics graph module not loaded.</p>';
  }
  return Promise.resolve(false);
}

/** PDE contour heatmap in chat (same SURFACE data as the page Graph tab). */
export function renderPdeGraphInChat(plotEl, input) {
  const surface = input?.surface;
  if (!plotEl || !surface?.z) {
    if (plotEl) plotEl.innerHTML = '<p class="vca-math-result-method">No contour plot available for this PDE.</p>';
    return Promise.resolve(false);
  }

  const loadPlotly = () => new Promise((resolve) => {
    if (window.Plotly) { resolve(true); return; }
    if (typeof window.loadPlotly === 'function') {
      window.loadPlotly(() => resolve(!!window.Plotly));
      return;
    }
    const s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = () => resolve(!!window.Plotly);
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });

  return loadPlotly().then((ok) => {
    if (!ok || !window.Plotly) return false;
    const pdeMode = String(input.pdeMode || 'heat').toLowerCase();
    const isXY = pdeMode === 'laplace' || pdeMode === 'poisson';
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const bgColor = isDark ? '#1e293b' : '#ffffff';
    const textColor = isDark ? '#cbd5e1' : '#1e293b';
    const xArr = Array.isArray(surface.x[0]) ? surface.x[0] : surface.x;
    const yArr = surface.y && Array.isArray(surface.y[0])
      ? surface.y.map((r) => r[0])
      : surface.y;

    plotEl.style.minHeight = '320px';
    plotEl.innerHTML = '';
    const chart = document.createElement('div');
    chart.className = 'vca-math-graph-canvas';
    chart.style.minHeight = '320px';
    plotEl.appendChild(chart);

    window.Plotly.newPlot(chart, [{
      z: surface.z,
      x: xArr,
      y: yArr || xArr,
      type: 'heatmap',
      colorscale: 'Viridis',
      showscale: true,
    }], {
      margin: { t: 36, r: 16, b: 48, l: 56 },
      height: 320,
      paper_bgcolor: bgColor,
      plot_bgcolor: bgColor,
      xaxis: { title: 'x', color: textColor },
      yaxis: { title: isXY ? 'y' : 't', color: textColor },
      font: { color: textColor, family: 'Inter, sans-serif', size: 11 },
    }, { responsive: true, displayModeBar: false, displaylogo: false });
    return true;
  });
}

/**
 * 3D cone plot of a gradient or curl vector field (same sampling as the VC page).
 * @param {HTMLElement} plotEl
 * @param {{ plotData?: number[][], vcMode?: string }} input
 */
export function renderVectorCalculusGraphInChat(plotEl, input) {
  const data = input?.plotData;
  if (!plotEl || !Array.isArray(data) || data.length === 0) return Promise.resolve(false);

  return ensurePlotly(plotEl, () => {
    const xs = [];
    const ys = [];
    const zs = [];
    const us = [];
    const vs = [];
    const ws = [];
    for (let i = 0; i < data.length; i++) {
      const p = data[i];
      xs.push(p[0]);
      ys.push(p[1]);
      zs.push(p[2]);
      us.push(p[3]);
      vs.push(p[4]);
      ws.push(p[5]);
    }

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    plotEl.style.minHeight = '320px';

    const core = typeof VCCalculatorCore !== 'undefined' ? VCCalculatorCore : window.VCCalculatorCore;
    const trace = core?.buildPlotlyConeTrace
      ? core.buildPlotlyConeTrace(xs, ys, zs, us, vs, ws, { isDark, colorbarFontSize: 10 })
      : {
          type: 'cone',
          x: xs,
          y: ys,
          z: zs,
          u: us,
          v: vs,
          w: ws,
          colorscale: 'Portland',
          sizemode: 'scaled',
          sizeref: 0.45,
          anchor: 'tail',
          showscale: true,
          colorbar: {
            title: 'Magnitude',
            tickfont: { color: isDark ? '#cbd5e1' : '#475569', size: 10 },
            titlefont: { color: isDark ? '#cbd5e1' : '#475569', size: 10 },
          },
        };

    const layout = {
      margin: { t: 28, r: 8, b: 8, l: 8 },
      height: 320,
      scene: {
        xaxis: {
          title: 'x',
          gridcolor: isDark ? '#334155' : '#e2e8f0',
          color: isDark ? '#cbd5e1' : '#475569',
        },
        yaxis: {
          title: 'y',
          gridcolor: isDark ? '#334155' : '#e2e8f0',
          color: isDark ? '#cbd5e1' : '#475569',
        },
        zaxis: {
          title: 'z',
          gridcolor: isDark ? '#334155' : '#e2e8f0',
          color: isDark ? '#cbd5e1' : '#475569',
        },
        bgcolor: isDark ? '#1e293b' : '#fff',
      },
      paper_bgcolor: isDark ? '#1e293b' : '#fff',
      font: { family: 'Inter, sans-serif', size: 11, color: isDark ? '#cbd5e1' : '#475569' },
    };

    window.Plotly.newPlot(plotEl, [trace], layout, {
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
  if (action === 'ode') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Solve the differential equation' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step solution' },
      { mode: 'graph', label: 'Show graph', title: 'Plot the solution curve y(x)' },
    ];
  }
  if (action === 'pde') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Numerical/analytical PDE solve (same as page)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step breakdown' },
      { mode: 'graph', label: 'Show graph', title: 'Contour heatmap of u(x,t) or u(x,y) (numeric PDEs)' },
    ];
  }
  if (action === 'vectorCalculus') {
    const chips = [
      { mode: 'simple', label: 'Solve', title: 'Compute ∇ / ∇· / ∇× (same as page)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step partial derivatives' },
    ];
    const vcMode = String(task?.mode || 'gradient').toLowerCase();
    if (vcMode === 'gradient' || vcMode === 'curl') {
      chips.push({
        mode: 'graph',
        label: 'Show 3D graph',
        title: 'Plot vector field cones (same as page 3D Graph tab)',
      });
    }
    return chips;
  }
  if (action === 'vector') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Compute the vector operation (same as page Calculate)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step vector solution' },
    ];
  }
  if (action === 'matrix') {
    const chips = [
      { mode: 'simple', label: 'Solve', title: 'Compute the matrix operation (same as page Calculate)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step matrix solution' },
    ];
    if (matrixCanVisualize(task)) {
      chips.push({
        mode: 'graph',
        label: 'Show graph',
        title: 'Unit square/cube overlay (same as page Visualize tab)',
      });
    }
    return chips;
  }
  if (action === 'bode') {
    return [
      { mode: 'simple', label: 'Solve', title: 'Compute H(s), zeros & poles (same Bode engine)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step Bode analysis' },
      { mode: 'graph', label: 'Show Bode plot', title: 'Magnitude & phase diagrams in chat' },
    ];
  }
  if (action === 'laplace') {
    const isInverse = /inverse|ilaplace|inv/.test(String(task?.mode || task?.laplaceMode || ''));
    return [
      { mode: 'simple', label: 'Solve', title: isInverse ? 'Compute inverse Laplace (same page engine)' : 'Compute forward Laplace (same page engine)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step Laplace transform' },
      { mode: 'graph', label: 'Show graph', title: 'Plot f(t) in the time domain' },
    ];
  }
  if (action === 'ztransform') {
    const isInverse = /inverse|iz|inv/.test(String(task?.mode || task?.zTransformMode || ''));
    return [
      { mode: 'simple', label: 'Solve', title: isInverse ? 'Compute inverse Z-transform (same page engine)' : 'Compute forward Z-transform (same page engine)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step Z-transform' },
      { mode: 'graph', label: 'Show graph', title: 'Plot x[n] stem diagram' },
    ];
  }
  if (action === 'trig') {
    const chips = [
      { mode: 'simple', label: 'Solve', title: 'Compute (same engine as the page Calculate/Solve)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step trig solution' },
    ];
    const core = getTrigCore();
    if (!core?.canGraphTask || core.canGraphTask(task)) {
      chips.push({
        mode: 'graph',
        label: 'Show graph',
        title: 'Plot function graph or unit circle (same as page Graph tab)',
      });
    }
    return chips;
  }
  if (action === 'statistics') {
    const chips = [
      { mode: 'simple', label: 'Solve', title: 'Compute statistics (same engine as stats pages)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step statistics breakdown' },
    ];
    const core = getStatisticsCore();
    if (!core?.canGraphTask || core.canGraphTask(task)) {
      chips.push({
        mode: 'graph',
        label: 'Show graph',
        title: 'Histogram or normal curve in chat',
      });
    }
    return chips;
  }
  if (ALGEBRA_ACTIONS.includes(action)) {
    return [
      { mode: 'simple', label: 'Solve', title: 'Compute answer (same engine as page calculator)' },
      { mode: 'steps', label: 'Solve with steps', title: 'Step-by-step solution in chat' },
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
  const answer = result.resultLatex || result.resultText || '';
  const action = task.action || result.action;
  const isOde = action === 'ode';
  const isPde = action === 'pde';
  const isVc = action === 'vectorCalculus';
  const isVector = action === 'vector';
  const isBode = action === 'bode';
  const isLaplace = action === 'laplace';
  const isZTransform = action === 'ztransform';
  const isTrig = action === 'trig';
  const isStatistics = action === 'statistics';
  const isAlgebraInterval = action === 'inequality'
    || (action === 'quadratic' && /[<>=]|\\in|\\emptyset|cup|∪/.test(answer));
  const isAlgebraSystem = action === 'system';
  const fuseAnswer = !isOde && !isPde && !isVc && !isVector && !isBode && !isLaplace && !isZTransform && !isTrig && !isStatistics && !isAlgebraInterval && !isAlgebraSystem;
  const answerEq = fuseAnswer ? `${problem} = ${answer}` : answer;

  body.replaceChildren();

  if (result.mode === 'graph') {
    appendEqSlot(body, problem);
    appendMethod(body, result.method);
    const graph = document.createElement('div');
    graph.className = 'vca-math-graph';
    graph.dataset.mathGraph = '1';
    body.appendChild(graph);
    if (answer) appendEqSlot(body, answerEq, 'vca-math-eq-answer');
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
    if (answer) {
      const ansLatex = fuseAnswer ? `${problem} = ${answer}` : (isAlgebraSystem || isAlgebraInterval ? `\\text{Solution: }${answer}` : answer);
      appendEqSlot(body, ansLatex, 'vca-math-eq-answer');
    }
  } else if (isOde || isPde) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    appendMethod(body, result.method);
    if (isPde && result.meta && (result.meta.STABLE || result.meta.CFL || result.meta.R)) {
      const metaBits = [];
      if (result.meta.R) metaBits.push(`r = ${result.meta.R}`);
      if (result.meta.CFL) metaBits.push(`CFL = ${result.meta.CFL}`);
      if (result.meta.STABLE === 'True') metaBits.push('stable');
      else if (result.meta.STABLE === 'False') metaBits.push('unstable');
      if (metaBits.length) {
        const p = document.createElement('p');
        p.className = 'vca-math-result-method';
        p.textContent = metaBits.join(' · ');
        body.appendChild(p);
      }
    }
  } else if (isAlgebraInterval || isAlgebraSystem) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, `\\text{Solution: }${answer}`, 'vca-math-eq-answer');
    appendMethod(body, result.method);
  } else if (isBode) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    if (Array.isArray(result.zeros) && result.zeros.length) {
      const p = document.createElement('p');
      p.className = 'vca-math-result-method';
      p.textContent = `Zeros: ${result.zeros.join(', ')}`;
      body.appendChild(p);
    }
    if (Array.isArray(result.poles) && result.poles.length) {
      const p = document.createElement('p');
      p.className = 'vca-math-result-method';
      p.textContent = `Poles: ${result.poles.join(', ')}`;
      body.appendChild(p);
    }
    appendMethod(body, result.method);
  } else if (isLaplace) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    if (result.convergence && result.convergence !== 'True' && result.convergence !== 'None' && result.transformMode !== 'inverse') {
      const p = document.createElement('p');
      p.className = 'vca-math-result-method';
      p.textContent = `ROC: Re(s) > ${result.convergence}`;
      body.appendChild(p);
    }
    appendMethod(body, result.method);
  } else if (isZTransform) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    if (result.convergence && result.convergence !== 'True' && result.convergence !== 'None' && result.transformMode !== 'inverse') {
      const p = document.createElement('p');
      p.className = 'vca-math-result-method';
      p.textContent = `ROC: ${result.convergence}`;
      body.appendChild(p);
    }
    appendMethod(body, result.method);
  } else if (isTrig) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    appendMethod(body, result.method);
  } else if (isStatistics) {
    appendEqSlot(body, problem);
    if (answer) appendEqSlot(body, answer, 'vca-math-eq-answer');
    if (result.resultText) {
      const p = document.createElement('p');
      p.className = 'vca-math-result-method';
      p.style.whiteSpace = 'pre-line';
      p.textContent = result.resultText;
      body.appendChild(p);
    }
    appendMethod(body, result.method);
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
      else if (action === 'ode') void renderOdeGraphInChat(plotEl, result.input);
      else if (action === 'vectorCalculus') void renderVectorCalculusGraphInChat(plotEl, result.input);
      else if (action === 'matrix') void renderMatrixGraphInChat(plotEl, result.input);
      else if (action === 'bode') void renderBodeGraphInChat(plotEl, result.input);
      else if (action === 'laplace') void renderLaplaceGraphInChat(plotEl, result.input);
      else if (action === 'pde') void renderPdeGraphInChat(plotEl, result.input);
      else if (action === 'ztransform') void renderZTransformGraphInChat(plotEl, result.input);
      else if (action === 'trig') void renderTrigGraphInChat(plotEl, result.input);
      else if (action === 'statistics') void renderStatisticsGraphInChat(plotEl, result.input);
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
