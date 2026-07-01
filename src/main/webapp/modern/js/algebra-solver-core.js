/**
 * Algebra AI — thin input router. Parses structured tasks and delegates to
 * battle-tested page engines (no duplicate math here).
 *
 * Requires engines from math-ai-cores-engine.js (via math-calculus-cores.inc.jsp
 * or math-tool-engine-boot.inc.jsp):
 *   quadratic: QuadraticInputBridge + QuadraticSolverCore
 *   system:    SystemsSolverCore
 *   inequality: InequalitySolverCore
 *   polynomial: PolyCalcRender
 */
(function () {
  'use strict';

  function cleanExpr(s) {
    return String(s || '').trim().replace(/\s+/g, ' ').replace(/\*\*/g, '^');
  }

  function collectEquations(task) {
    if (Array.isArray(task.equations)) {
      return task.equations.map(String).map(function (s) { return s.trim(); }).filter(Boolean);
    }
    var eqs = [];
    for (var i = 1; i <= 8; i++) {
      var k = task['eq' + i] || task['equation' + i];
      if (k) eqs.push(String(k).trim());
    }
    if (!eqs.length && task.raw) {
      eqs = String(task.raw).split(/\n|;|\|/).map(function (s) { return s.trim(); }).filter(Boolean);
    }
    return eqs;
  }

  function polyOffDomRender(fn) {
    var box = document.createElement('div');
    var r = fn(box);
    if (!r) {
      var err = box.querySelector('.poly-error, .tool-error');
      return { ok: false, error: (err && err.textContent) || 'Polynomial computation failed.' };
    }
    var steps = [];
    box.querySelectorAll('.poly-step').forEach(function (step) {
      var titleEl = step.querySelector('.poly-step-desc');
      var mathEl = step.querySelector('.poly-step-math');
      steps.push({
        title: titleEl ? titleEl.textContent.replace(/\s+/g, ' ').trim() : 'Step',
        latex: mathEl ? (mathEl.getAttribute('data-latex') || mathEl.textContent || '') : '',
      });
    });
    return {
      ok: true,
      action: 'polynomial',
      resultText: r.resultText,
      resultLatex: r.resultTeX || r.resultText,
      method: 'Polynomial calculator (page engine)',
      steps: steps,
    };
  }

  function solveQuadraticTask(task, opts) {
    var core = window.QuadraticSolverCore;
    var raw = cleanExpr(task.raw || task.expr || task.equation || '');
    if (!raw) return { ok: false, error: 'Missing quadratic equation.' };

    if (core && typeof core.solveFromExpr === 'function') {
      var r = core.solveFromExpr(raw, { method: task.method });
      if (opts && opts.withSteps && r.ok && (!r.steps || !r.steps.length)) {
        r.steps = [{ title: 'Solution', latex: r.resultLatex || r.resultText || '' }];
      }
      return r;
    }

    var bridge = window.QuadraticInputBridge;
    if (bridge && typeof bridge.parse === 'function') {
      return { ok: false, error: 'QuadraticSolverCore not loaded (bridge only).' };
    }
    return { ok: false, error: 'Quadratic page engine not loaded.' };
  }

  function solveSystemTask(task, opts) {
    var eqs = collectEquations(task);
    if (eqs.length < 2) {
      return Promise.resolve({ ok: false, error: 'Need at least two equations (eq1, eq2, … or equations list).' });
    }
    var core = window.SystemsSolverCore;
    if (core && typeof core.solveFromEquations === 'function') {
      return core.solveFromEquations(eqs, {
        method: task.method || 'gaussian',
        withSteps: !!(opts && opts.withSteps),
      });
    }
    return Promise.resolve({ ok: false, error: 'Systems page engine not loaded.' });
  }

  function solveInequalityTask(task, opts) {
    var raw = cleanExpr(task.raw || task.expr || task.inequality || '');
    if (!raw) return { ok: false, error: 'Missing inequality.' };
    var v = String(task.variable || task.var || 'x').trim() || 'x';
    var core = window.InequalitySolverCore;
    if (core && typeof core.solveFromRaw === 'function') {
      return core.solveFromRaw(raw, v, { withSteps: !!(opts && opts.withSteps) });
    }
    return { ok: false, error: 'Inequality page engine not loaded.' };
  }

  function solvePolynomialTask(task, opts) {
    var R = window.PolyCalcRender;
    if (!R) return { ok: false, error: 'Polynomial page engine (PolyCalcRender) not loaded.' };

    var op = String(task.op || task.operation || 'factor').toLowerCase();
    var p = cleanExpr(task.p || task.p1 || task.poly || task.expr || '');
    var q = cleanExpr(task.q || task.p2 || '');
    var xVal = task.x != null ? String(task.x) : (task.evalX != null ? String(task.evalX) : '');
    if (!p) return { ok: false, error: 'Missing polynomial P(x) in p: field.' };

    var out;
    if (op === 'add') {
      if (!q) return { ok: false, error: 'Binary op needs q: (second polynomial).' };
      out = polyOffDomRender(function (box) { return R.renderAdd(box, p, q); });
    } else if (op === 'subtract') {
      if (!q) return { ok: false, error: 'Binary op needs q: (second polynomial).' };
      out = polyOffDomRender(function (box) { return R.renderSubtract(box, p, q); });
    } else if (op === 'multiply') {
      if (!q) return { ok: false, error: 'Binary op needs q: (second polynomial).' };
      out = polyOffDomRender(function (box) { return R.renderMultiply(box, p, q); });
    } else if (op === 'divide') {
      if (!q) return { ok: false, error: 'Binary op needs q: (second polynomial).' };
      out = polyOffDomRender(function (box) { return R.renderDivide(box, p, q); });
    } else if (op === 'factor') {
      out = polyOffDomRender(function (box) { return R.renderFactor(box, p); });
    } else if (op === 'roots' || op === 'root') {
      out = polyOffDomRender(function (box) { return R.renderRoots(box, p); });
    } else if (op === 'evaluate' || op === 'eval') {
      if (!xVal) return { ok: false, error: 'Evaluate needs x: (value).' };
      out = polyOffDomRender(function (box) { return R.renderEvaluate(box, p, xVal); });
    } else if (op === 'expand') {
      out = polyOffDomRender(function (box) { return R.renderExpand(box, p); });
    } else {
      return { ok: false, error: 'Unknown polynomial op: ' + op };
    }

    if (out.ok && opts && opts.withSteps && (!out.steps || !out.steps.length)) {
      out.steps = [{ title: op, latex: out.resultLatex || out.resultText || '' }];
    }
    out.input = { op: op, p: p, q: q || null, x: xVal || null };
    return out;
  }

  function solveTask(task, opts) {
    if (!task) return Promise.resolve({ ok: false, error: 'Empty task.' });
    var action = String(task.action || '').toLowerCase();
    opts = opts || {};
    var withSteps = !!(opts.withSteps || opts.mode === 'steps');

    if (action === 'quadratic') {
      return Promise.resolve(solveQuadraticTask(task, { withSteps: withSteps }));
    }
    if (action === 'system' || action === 'systems') {
      return solveSystemTask(task, { withSteps: withSteps });
    }
    if (action === 'inequality') {
      return Promise.resolve(solveInequalityTask(task, { withSteps: withSteps }));
    }
    if (action === 'polynomial') {
      return Promise.resolve(solvePolynomialTask(task, { withSteps: withSteps }));
    }
    return Promise.resolve({ ok: false, error: 'Unknown algebra action: ' + action });
  }

  if (typeof window !== 'undefined') {
    window.AlgebraSolverCore = {
      solveTask: solveTask,
      solveQuadraticTask: function (t, o) { return Promise.resolve(solveQuadraticTask(t, o)); },
      solveSystemTask: solveSystemTask,
      solveInequalityTask: function (t, o) { return Promise.resolve(solveInequalityTask(t, o)); },
      solvePolynomialTask: function (t, o) { return Promise.resolve(solvePolynomialTask(t, o)); },
    };
  }
})();
