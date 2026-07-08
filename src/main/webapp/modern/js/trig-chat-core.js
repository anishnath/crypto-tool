/**
 * Trigonometry chat engine — SymPy via TrigBackend + client quadrant/coterminal.
 * Requires TrigCommon, TrigGraph, TrigBackend (loaded by trig calculator pages).
 */
(function trigChatCoreModule() {
  'use strict';

  const TRIG_MODES = new Set([
    'evaluate', 'quadrant', 'coterminal',
    'solve_equation', 'solve', 'solve_inequality', 'inequality', 'simplify', 'prove',
  ]);

  function TC() { return typeof window !== 'undefined' ? window.TrigCommon : null; }
  function G() { return typeof window !== 'undefined' ? window.TrigGraph : null; }
  function backend() { return typeof window !== 'undefined' ? window.TrigBackend : null; }

  function normalizeMode(raw) {
    let m = String(raw || 'evaluate').toLowerCase().replace(/\s+/g, '_');
    if (m === 'solve' || m === 'equation') m = 'solve_equation';
    if (m === 'inequality' || m === 'solve_ineq') m = 'solve_inequality';
    if (m === 'identity' || m === 'verify') m = 'prove';
    return TRIG_MODES.has(m) ? m : 'evaluate';
  }

  function backendMode(mode) {
    if (mode === 'solve') return 'solve_equation';
    if (mode === 'inequality') return 'solve_inequality';
    if (mode === 'quadrant' || mode === 'coterminal') return mode;
    return mode;
  }

  function parseAngle(expr, unit) {
    const tc = TC();
    if (!tc) return NaN;
    expr = String(expr || '').trim().replace(/°/g, '').replace(/\s+/g, '');
    const num = parseFloat(expr);
    if (!isNaN(num) && /^-?[\d.]+$/.test(expr)) {
      return unit === 'deg' ? num : tc.radToDeg(num);
    }
    if (/pi/i.test(expr)) {
      const piExpr = expr.replace(/pi/gi, String(Math.PI)).replace(/\^/g, '**');
      try {
        const val = new Function('return ' + piExpr)(); // eslint-disable-line no-new-func
        if (isFinite(val)) return tc.radToDeg(val);
      } catch (_) { /* ignore */ }
    }
    return num;
  }

  function parseTrigFunction(expr) {
    const match = String(expr || '').trim().match(/^(sin|cos|tan|csc|sec|cot)\s*\(\s*(.+)\s*\)$/i);
    if (!match) return null;
    return { func: match[1].toLowerCase(), angle: match[2] };
  }

  function computeBackend(opts) {
    const B = backend();
    if (!B?.compute) {
      return Promise.resolve({ ok: false, error: 'Trig engine (TrigBackend) not loaded.' });
    }
    return new Promise((resolve) => {
      B.compute(opts, resolve);
    });
  }

  function mapBackendSteps(steps) {
    if (!Array.isArray(steps)) return [];
    return steps.map((s) => ({
      title: s.label || s.rule || 'Step',
      latex: s.after_latex || s.before_latex || '',
    }));
  }

  function solveQuadrant(task) {
    const tc = TC();
    if (!tc) return { ok: false, error: 'TrigCommon not loaded.' };
    const expr = String(task.expr || task.text || task.raw || '').trim();
    const unit = String(task.unit || 'deg').toLowerCase() === 'rad' ? 'rad' : 'deg';
    const angleDeg = parseAngle(expr, unit);
    if (!Number.isFinite(angleDeg)) {
      return { ok: false, error: 'Could not parse angle: ' + expr };
    }
    const normDeg = tc.normalizeAngleDeg(angleDeg);
    const quadrant = tc.getQuadrant(angleDeg);
    const refAngle = tc.getReferenceAngle(angleDeg);
    const angleLatex = unit === 'deg' ? normDeg + '^\\circ' : expr.replace(/pi/gi, '\\pi');
    const resultLatex = `Q${quadrant},\\; \\text{ref}=${refAngle}^\\circ,\\; \\theta=${angleLatex}`;
    const steps = [
      { title: 'Normalize to [0°, 360°)', latex: `${angleDeg}^\\circ \\to ${normDeg}^\\circ` },
      { title: 'Quadrant', latex: `${normDeg}^\\circ \\text{ is in Quadrant ${quadrant}}` },
      { title: 'Reference angle', latex: `${refAngle}^\\circ` },
    ];
    return {
      ok: true,
      kind: 'quadrant',
      resultLatex,
      method: 'Quadrant analysis',
      steps,
      graphInput: {
        graphType: 'unitCircle',
        plotOptions: { angles: [normDeg], highlightQuadrant: quadrant, showRefAngle: true },
      },
    };
  }

  function solveCoterminal(task) {
    const tc = TC();
    if (!tc) return { ok: false, error: 'TrigCommon not loaded.' };
    const expr = String(task.expr || task.text || task.raw || '').trim();
    const unit = String(task.unit || 'deg').toLowerCase() === 'rad' ? 'rad' : 'deg';
    const angleDeg = parseAngle(expr, unit);
    if (!Number.isFinite(angleDeg)) {
      return { ok: false, error: 'Could not parse angle: ' + expr };
    }
    const normDeg = tc.normalizeAngleDeg(angleDeg);
    const pos = [];
    const neg = [];
    for (let n = 1; n <= 3; n++) { pos.push(normDeg + 360 * n); neg.push(normDeg - 360 * n); }
    const resultLatex = `${normDeg}^\\circ + 360^\\circ n,\\; n \\in \\mathbb{Z}`;
    const steps = [
      { title: 'Normalize', latex: `${angleDeg}^\\circ \\equiv ${normDeg}^\\circ` },
      { title: 'Formula', latex: `\\theta_{co} = ${normDeg}^\\circ + 360^\\circ \\cdot n` },
      { title: 'Examples (n = 1,2,3)', latex: pos.map((a) => a + '^\\circ').join(',\\; ') },
    ];
    return {
      ok: true,
      kind: 'coterminal',
      resultLatex,
      method: 'Coterminal angles',
      steps,
      graphInput: {
        graphType: 'unitCircle',
        plotOptions: { angles: [normDeg], showCoterminals: true, coterminals: pos.concat(neg) },
      },
    };
  }

  function buildEvaluateGraph(task, res) {
    const expr = String(task.expr || task.text || '').trim();
    const unit = String(task.unit || 'deg').toLowerCase() === 'rad' ? 'rad' : 'deg';
    const parsed = parseTrigFunction(expr);
    const tc = TC();
    if (parsed && tc) {
      const angleDeg = parseAngle(parsed.angle, unit);
      if (Number.isFinite(angleDeg)) {
        const angleRad = tc.degToRad(angleDeg);
        let y = 0;
        const fn = parsed.func;
        if (fn === 'sin') y = Math.sin(angleRad);
        else if (fn === 'cos') y = Math.cos(angleRad);
        else if (fn === 'tan') y = Math.tan(angleRad);
        else if (fn === 'csc') y = 1 / Math.sin(angleRad);
        else if (fn === 'sec') y = 1 / Math.cos(angleRad);
        else if (fn === 'cot') y = 1 / Math.tan(angleRad);
        return {
          graphType: 'function',
          plotOptions: {
            functions: [{ expr: fn + '(x)', label: fn + '(x)' }],
            solutions: [{ x: angleRad, y, label: expr }],
          },
        };
      }
    }
    const plotExpr = expr.replace(/\^/g, '**');
    if (plotExpr) {
      return {
        graphType: 'function',
        plotOptions: { functions: [{ expr: plotExpr, label: expr }] },
      };
    }
    return null;
  }

  function buildEquationGraph(task) {
    const expr = String(task.expr || task.text || task.raw || '').trim();
    const parts = expr.split('=');
    const funcs = [{ expr: parts[0].trim().replace(/\^/g, '**'), label: 'LHS' }];
    if (parts.length > 1) {
      funcs.push({ expr: parts[1].trim().replace(/\^/g, '**'), label: 'RHS' });
    }
    return { graphType: 'function', plotOptions: { functions: funcs } };
  }

  function buildProveGraph(task) {
    const lhs = String(task.lhs || '').trim().replace(/\^/g, '**');
    const rhs = String(task.rhs || '').trim().replace(/\^/g, '**');
    if (!lhs || !rhs) return null;
    return {
      graphType: 'function',
      plotOptions: {
        functions: [
          { expr: lhs, label: 'LHS' },
          { expr: rhs, label: 'RHS' },
        ],
      },
    };
  }

  function buildSimplifyGraph(task, simplified) {
    const orig = String(task.expr || task.text || '').trim();
    const simp = String(simplified || orig).trim();
    if (!orig) return null;
    return {
      graphType: 'function',
      plotOptions: {
        functions: [
          { expr: orig.replace(/\^/g, '**'), label: 'Original' },
          { expr: simp.replace(/\^/g, '**'), label: 'Simplified' },
        ],
      },
    };
  }

  function canGraphTask(task) {
    const mode = normalizeMode(task.mode);
    if (mode === 'quadrant' || mode === 'coterminal') return true;
    if (mode === 'prove') return !!(task.lhs && task.rhs);
    return !!(task.expr || task.text || task.raw || task.latex);
  }

  async function solveTask(task, options) {
    const withSteps = !!(options && options.withSteps);
    const wantGraph = options && options.mode === 'graph';
    const mode = normalizeMode(task.mode);
    const unit = String(task.unit || 'deg').toLowerCase() === 'rad' ? 'rad' : 'deg';
    const expr = String(task.expr || task.text || task.raw || '').trim();
    const latex = String(task.latex || '').trim();
    const variable = String(task.variable || 'x').trim() || 'x';

    if (mode === 'quadrant') {
      const r = solveQuadrant(task);
      if (!r.ok) return r;
      return {
        ok: true,
        action: 'trig',
        kind: r.kind,
        resultLatex: r.resultLatex,
        method: r.method,
        steps: withSteps ? r.steps : [],
        input: wantGraph ? r.graphInput : undefined,
      };
    }

    if (mode === 'coterminal') {
      const r = solveCoterminal(task);
      if (!r.ok) return r;
      return {
        ok: true,
        action: 'trig',
        kind: r.kind,
        resultLatex: r.resultLatex,
        method: r.method,
        steps: withSteps ? r.steps : [],
        input: wantGraph ? r.graphInput : undefined,
      };
    }

    const bMode = backendMode(mode);
    const opts = {
      mode: bMode === 'solve_equation' ? 'solve_equation' : bMode,
      unit,
      variable,
      timeout_ms: 15000,
    };

    if (mode === 'prove') {
      opts.lhs = latex || task.lhs || '';
      opts.rhs = task.rhs || '';
      if (!opts.lhs && task.lhs) opts.lhs = task.lhs;
      opts.text = expr;
    } else {
      if (latex) opts.latex = latex;
      opts.text = expr;
    }

    if (!opts.text && !opts.latex && !(opts.lhs && opts.rhs)) {
      return { ok: false, error: 'Empty trig input.' };
    }

    const res = await computeBackend(opts);
    if (!res || !res.ok) {
      return { ok: false, error: (res && res.error) || 'Trig computation failed.' };
    }

    let resultLatex = res.answer_latex || res.answer_str || '';
    if (mode === 'prove') {
      if (res.is_identity) {
        resultLatex = '\\text{Identity verified: } ' + (res.answer_latex || 'LHS = RHS');
      } else {
        resultLatex = '\\text{Not an identity}';
        if (res.counterexample) {
          resultLatex += `\\; (x=${res.counterexample.x})`;
        }
      }
    }

    const steps = withSteps ? mapBackendSteps(res.steps) : [];
    let graphInput = null;
    if (wantGraph && canGraphTask(task)) {
      if (mode === 'prove') graphInput = buildProveGraph(task);
      else if (mode === 'solve_equation' || mode === 'solve_inequality') graphInput = buildEquationGraph(task);
      else if (mode === 'simplify') graphInput = buildSimplifyGraph(task, res.answer_str || res.answer_latex);
      else if (mode === 'evaluate') graphInput = buildEvaluateGraph(task, res);
    }

    return {
      ok: true,
      action: 'trig',
      kind: res.kind || mode,
      resultLatex,
      method: 'Trigonometry',
      steps,
      isIdentity: res.is_identity,
      input: graphInput || undefined,
    };
  }

  function renderGraphInChat(plotEl, input) {
    const graph = G();
    if (!plotEl || !input || !graph) {
      if (plotEl) {
        plotEl.innerHTML = '<p class="vca-math-result-method">Graph module not loaded.</p>';
      }
      return Promise.resolve(false);
    }

    const id = plotEl.id || ('trig-chat-plot-' + Date.now());
    if (!plotEl.id) plotEl.id = id;
    plotEl.style.minHeight = '280px';
    plotEl.style.width = '100%';

    return new Promise((resolve) => {
      const done = () => {
        try {
          if (input.graphType === 'unitCircle' && graph.renderUnitCircle) {
            graph.renderUnitCircle(id, input.plotOptions || {});
          } else if (graph.renderFunctionPlot) {
            graph.renderFunctionPlot(id, input.plotOptions || {});
          } else {
            resolve(false);
            return;
          }
          resolve(true);
        } catch (_) {
          resolve(false);
        }
      };

      if (typeof graph.loadPlotly === 'function') graph.loadPlotly(done);
      else if (typeof window.loadPlotly === 'function') window.loadPlotly(done);
      else done();
    });
  }

  window.TrigChatCore = {
    solveTask,
    canGraphTask,
    renderGraphInChat,
    normalizeMode,
  };
})();
