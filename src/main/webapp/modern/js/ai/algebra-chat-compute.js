/**
 * Algebra chat compute — delegates to AlgebraSolverCore (page engines).
 * Rendering and question cards live in math-chat-compute.js (unified Math AI).
 */
import { taskToDisplayLatex } from './algebra-action-extract.js';

/** @typedef {'simple'|'steps'} AlgebraSolveMode */

function getCore() {
  return typeof AlgebraSolverCore !== 'undefined'
    ? AlgebraSolverCore
    : window.AlgebraSolverCore;
}

/**
 * @param {object} task
 * @param {AlgebraSolveMode} mode
 */
export async function solveAlgebraTask(task, mode = 'simple') {
  const core = getCore();
  if (!core?.solveTask) {
    return { ok: false, error: 'Algebra engine not loaded.', mode, problemLatex: '' };
  }

  const withSteps = mode === 'steps';
  const r = await core.solveTask(task, { withSteps, mode });
  const problemLatex = taskToDisplayLatex(task);

  if (!r || !r.ok) {
    return { ok: false, error: r?.error || 'Could not solve.', mode, problemLatex };
  }

  return {
    ...r,
    ok: true,
    mode,
    action: task.action || r.action,
    problemLatex,
  };
}
