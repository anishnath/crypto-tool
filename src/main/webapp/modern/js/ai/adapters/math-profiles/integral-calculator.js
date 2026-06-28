/**
 * Integral Calculator page — apply integral tasks to on-page UI (optional sync).
 * Generic Math AI shell lives in generic-calculus.js.
 */
import { formatMathActionLabel } from '../../math-action-extract.js';

function $(id) {
  return document.getElementById(id);
}

function setIntegralMode(mode) {
  const target = mode === 'definite' ? 'definite' : 'indefinite';
  const btn = document.querySelector(`.ic-mode-btn[data-mode="${target}"]`);
  if (btn) btn.click();
}

function setVariable(v) {
  const sel = $('ic-var');
  if (!sel || !v) return;
  if (sel.querySelector(`option[value="${v}"]`)) sel.value = v;
}

function ensureTextInputMode() {
  const textBtn = document.querySelector('.ic-input-mode-btn[data-input-mode="text"]');
  if (textBtn && !textBtn.classList.contains('active')) textBtn.click();
}

function dispatchExprInput(exprInput) {
  if (!exprInput) return;
  exprInput.dispatchEvent(new Event('input', { bubbles: true }));
}

/**
 * Wait for #ic-result-content to change after integrate click.
 * @param {number} [timeoutMs]
 */
function waitForIntegralResult(timeoutMs) {
  const el = $('ic-result-content');
  const btn = $('ic-integrate-btn');
  if (!el || !btn) {
    return Promise.resolve({ applied: false, error: 'Calculator UI not ready.' });
  }

  const startHtml = el.innerHTML;
  const startBusy = btn.classList.contains('is-busy');

  return new Promise((resolve, reject) => {
    let settled = false;
    const finish = (payload) => {
      if (settled) return;
      settled = true;
      obs.disconnect();
      clearTimeout(timer);
      resolve(payload);
    };

    const obs = new MutationObserver(() => {
      const empty = $('ic-empty-state');
      const stillEmpty = empty && empty.offsetParent !== null;
      if (stillEmpty && el.innerHTML === startHtml) return;
      if (el.innerHTML !== startHtml) {
        const snap = typeof window.icGetContext === 'function' ? window.icGetContext() : null;
        finish({
          applied: true,
          resultSummary: snap?.resultSummary || el.innerText.trim().slice(0, 2000),
        });
      }
    });

    obs.observe(el, { childList: true, subtree: true, characterData: true });

    const timer = setTimeout(() => {
      if (settled) return;
      settled = true;
      obs.disconnect();
      if (!startBusy && !btn.classList.contains('is-busy')) {
        reject(new Error('Integration timed out — try again or simplify the input.'));
      } else {
        reject(new Error('Integration timed out.'));
      }
    }, timeoutMs || 45000);
  });
}

/**
 * @param {import('../../math-action-extract.js').MathActionTask} task
 */
export async function icApplyIntegralTask(task) {
  const exprInput = $('ic-expr');
  const lowerInput = $('ic-lower');
  const upperInput = $('ic-upper');
  const integrateBtn = $('ic-integrate-btn');

  if (!exprInput || !integrateBtn) {
    return { applied: false, error: 'Integral calculator not ready.' };
  }

  if (integrateBtn.classList.contains('is-busy')) {
    return { applied: false, error: 'Calculator is busy — wait for the current integral to finish.' };
  }

  ensureTextInputMode();

  if (task.raw) {
    exprInput.value = task.raw.trim();
  } else if (task.integrand) {
    const v = task.variable || 'x';
    if (task.mode === 'definite' && task.lower != null && task.upper != null) {
      exprInput.value = `${task.integrand.trim()}, (${v}, ${task.lower}, ${task.upper})`;
    } else {
      exprInput.value = task.integrand.trim();
    }
  } else {
    return { applied: false, error: 'No integrand or raw expression in task.' };
  }

  dispatchExprInput(exprInput);

  if (task.raw && typeof window.IC?.looksLikeLatexIntegral === 'function'
      && window.IC.looksLikeLatexIntegral(exprInput.value)) {
    setVariable(task.variable || 'x');
  } else {
    setVariable(task.variable || 'x');
    setIntegralMode(task.mode === 'definite' ? 'definite' : 'indefinite');
    if (task.mode === 'definite') {
      if (lowerInput && task.lower != null) lowerInput.value = String(task.lower);
      if (upperInput && task.upper != null) upperInput.value = String(task.upper);
    }
  }

  if (integrateBtn.classList.contains('is-disabled')) {
    return { applied: false, error: 'Could not enable Integrate — check the expression.' };
  }

  const waitPromise = waitForIntegralResult();
  integrateBtn.click();

  try {
    return await waitPromise;
  } catch (err) {
    return { applied: false, error: err?.message || 'Integration failed.' };
  }
}

export { formatMathActionLabel };
