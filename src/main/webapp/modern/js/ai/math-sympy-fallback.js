/**
 * Tier-3 fallback for the Math AI: when an in-browser core (nerdamer/JS) can't
 * solve a problem, escalate to SymPy via the OneCompiler backend — the same
 * endpoint the integral/ODE cores already use.
 *
 * Returns a result object shaped exactly like the sibling solve*Task functions
 * in math-chat-compute.js so the chat result card renders identically, with an
 * extra `source:'sympy'` marker so the UI can label it as engine-solved.
 *
 * Slice #1 covers the confirmed in-browser-only dead-ends that SymPy solves
 * cleanly with a single call: derivative and limit. Add more actions by
 * registering a builder in BUILDERS (each returns {code, finalize}).
 */

const FALLBACK_ACTIONS = new Set(['derivative', 'limit', 'quadratic', 'inequality', 'trig', 'statistics', 'logarithm', 'lagrangian']);

/** True if this action has a SymPy fallback builder. */
export function canSympyFallback(action) {
  return FALLBACK_ACTIONS.has(action);
}

function ctxPath() {
  if (typeof window === 'undefined') return '';
  return window.MATH_CALC_CTX ||
    window.INTEGRAL_CALC_CTX ||
    (window.CONFIG && window.CONFIG.ctx) ||
    (function () {
      const meta = document.querySelector && document.querySelector('meta[name="ctx"]');
      return meta && meta.content ? meta.content : '';
    })();
}

/** UTF-8-safe base64 so arbitrary expressions embed into the Python source without escaping. */
function b64(str) {
  return btoa(unescape(encodeURIComponent(String(str == null ? '' : str))));
}

/** Normalize common infinity/notation spellings to SymPy-parseable tokens. */
function normPoint(pt) {
  const s = String(pt == null ? '0' : pt).trim();
  if (!s) return '0';
  if (/^[+]?(inf(inity)?|∞|oo)$/i.test(s)) return 'oo';
  if (/^-(inf(inity)?|∞|oo)$/i.test(s)) return '-oo';
  return s;
}

/** Shared Python preamble: robust student-input parsing (^ as power, implicit mult) + a hard timeout. */
const PREAMBLE = [
  'from sympy import *',
  'from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application, convert_xor',
  'import json, signal, base64',
  '_TR = standard_transformations + (implicit_multiplication_application, convert_xor)',
  'def _P(s): return parse_expr(base64.b64decode(s).decode("utf-8"), transformations=_TR)',
  'def _PP(t): return parse_expr(t, transformations=_TR)',
  'def _b64(s): return base64.b64decode(s).decode("utf-8")',
  'def _sym(s):',
  '    s = base64.b64decode(s).decode("utf-8").strip()',
  '    return Symbol(s) if s else None',
  'def _t(sig, frm): raise TimeoutError',
  'signal.signal(signal.SIGALRM, _t)',
  'signal.alarm(10)',
  'try:',
].join('\n');

const TRAILER = [
  'except TimeoutError:',
  '    out = {"ok": False, "error": "Solver timed out (10s)"}',
  'except Exception as e:',
  '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}',
  'finally:',
  '    signal.alarm(0)',
  'print("RESULT:" + json.dumps(out))',
].join('\n');

/** Choose the variable: explicit if given, else the single free symbol, else x. */
const CHOOSE_VAR = [
  '    var = _sym("__VAR__")',
  '    if var is None:',
  '        _fs = sorted(expr.free_symbols, key=lambda z: z.name)',
  '        var = _fs[0] if len(_fs) == 1 else Symbol("x")',
].join('\n');

const BUILDERS = {
  derivative(task) {
    const order = Number.isFinite(+task.order) && +task.order > 0 ? Math.floor(+task.order) : 1;
    const code = [
      PREAMBLE,
      `    expr = _P("${b64(task.expr)}")`,
      CHOOSE_VAR.replace('__VAR__', b64(task.variable || '')),
      `    res = simplify(diff(expr, var, ${order}))`,
      '    out = {"ok": True, "latex": latex(res), "text": str(res), "var": str(var), "expr_tex": latex(expr)}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode) {
        const steps = mode === 'steps'
          ? [
              { title: `Differentiate with respect to ${p.var}`, latex: `\\frac{d}{d${p.var}}\\left(${p.expr_tex}\\right)` },
              { title: 'Result', latex: p.latex },
            ]
          : [];
        return {
          action: 'derivative',
          resultLatex: p.latex,
          method: 'Derivative',
          steps,
          problemLatex: `\\frac{d}{d${p.var}}\\left(${p.expr_tex}\\right)`,
        };
      },
    };
  },

  limit(task) {
    const point = normPoint(task.point);
    const dir = task.direction === 'right' ? 'right' : task.direction === 'left' ? 'left' : 'two';
    const code = [
      PREAMBLE,
      `    expr = _P("${b64(task.expr)}")`,
      CHOOSE_VAR.replace('__VAR__', b64(task.variable || '')),
      `    pt = _P("${b64(point)}")`,
      `    _dir = "${dir}"`,
      '    if _dir == "right":',
      '        res = limit(expr, var, pt, "+")',
      '    elif _dir == "left":',
      '        res = limit(expr, var, pt, "-")',
      '    else:',
      '        try:',
      '            res = limit(expr, var, pt, "+-")',
      '        except Exception:',
      '            _lr = limit(expr, var, pt, "+"); _ll = limit(expr, var, pt, "-")',
      '            res = _lr if _lr == _ll else None',
      '    if res is None:',
      '        out = {"ok": False, "error": "Limit does not exist (left \\u2260 right)"}',
      '    else:',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "var": str(var), "pt": latex(pt), "expr_tex": latex(expr)}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode) {
        const arrow = dir === 'right' ? '^{+}' : dir === 'left' ? '^{-}' : '';
        const problemLatex = `\\lim_{${p.var} \\to ${p.pt}${arrow}} ${p.expr_tex}`;
        const steps = mode === 'steps'
          ? [{ title: 'Evaluate the limit', latex: problemLatex }, { title: 'Result', latex: p.latex }]
          : [];
        return { action: 'limit', resultLatex: p.latex, method: 'Limit', steps, problemLatex };
      },
    };
  },

  quadratic(task) {
    const src = task.expr || task.raw || task.equation || '';
    const code = [
      PREAMBLE,
      `    _eq = _b64("${b64(src)}")`,
      '    if "=" in _eq:',
      '        _l, _r = _eq.split("=", 1); _lhs, _rhs = _PP(_l), _PP(_r)',
      '    else:',
      '        _lhs, _rhs = _PP(_eq), Integer(0)',
      '    _diff = _lhs - _rhs',
      `    var = _sym("${b64(task.variable || '')}")`,
      '    if var is None:',
      '        _fs = sorted(_diff.free_symbols, key=lambda z: z.name); var = _fs[0] if _fs else Symbol("x")',
      '    _sols = solve(Eq(_lhs, _rhs), var, dict=False)',
      '    if not isinstance(_sols, (list, tuple)): _sols = [_sols]',
      '    _tex = ", ".join(latex(var) + " = " + latex(s) for s in _sols)',
      '    out = {"ok": True, "latex": _tex, "text": str(_sols), "has_sol": len(_sols) > 0, "expr_tex": latex(Eq(_lhs, _rhs))}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode) {
        const answer = p.has_sol ? p.latex : '\\text{No solution}';
        const steps = mode === 'steps'
          ? [{ title: 'Solve the equation', latex: p.expr_tex }, { title: 'Solution', latex: answer }]
          : [];
        return { action: 'quadratic', resultLatex: answer, method: 'Equation solver', steps, problemLatex: p.expr_tex };
      },
    };
  },

  inequality(task) {
    const src = task.expr || task.inequality || task.raw || '';
    const code = [
      PREAMBLE,
      `    _rel = _P("${b64(src)}")`,
      '    if not getattr(_rel, "is_Relational", False):',
      '        out = {"ok": False, "error": "Not an inequality"}',
      '    else:',
      '        _fs = sorted(_rel.free_symbols, key=lambda z: z.name)',
      `        var = _sym("${b64(task.variable || '')}") or (_fs[0] if _fs else Symbol("x"))`,
      '        _sol = solveset(_rel, var, domain=S.Reals)',
      '        out = {"ok": True, "latex": latex(_sol), "text": str(_sol), "expr_tex": latex(_rel)}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode) {
        const steps = mode === 'steps'
          ? [{ title: 'Solve the inequality', latex: p.expr_tex }, { title: 'Solution set', latex: p.latex }]
          : [];
        return { action: 'inequality', resultLatex: p.latex, method: 'Inequality solver', steps, problemLatex: p.expr_tex };
      },
    };
  },

  trig(task) {
    const mode = String(task.mode || 'evaluate');
    const code = [
      PREAMBLE,
      `    _raw = _b64("${b64(task.expr || task.raw || task.latex || '')}")`,
      `    _mode = "${mode}"; _unit = "${String(task.unit || '')}"`,
      '    if _unit[:3] == "deg":',
      '        out = {"ok": False, "error": "Degree-mode trig not supported in fallback"}',
      '    elif _mode in ("evaluate", "simplify"):',
      '        _e = _PP(_raw); res = simplify(_e)',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "expr_tex": latex(_e)}',
      '    elif _mode == "solve_equation":',
      '        if "=" in _raw:',
      '            _l, _r = _raw.split("=", 1); eqn = Eq(_PP(_l), _PP(_r))',
      '        else:',
      '            eqn = Eq(_PP(_raw), 0)',
      '        _fs = sorted(eqn.free_symbols, key=lambda z: z.name); var = _fs[0] if _fs else Symbol("x")',
      '        _sol = solveset(eqn, var, domain=S.Reals)',
      '        out = {"ok": True, "latex": latex(_sol), "text": str(_sol), "expr_tex": latex(eqn)}',
      '    else:',
      '        out = {"ok": False, "error": "Unsupported trig mode: " + _mode}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode2) {
        const steps = mode2 === 'steps'
          ? [{ title: 'Trigonometry', latex: p.expr_tex }, { title: 'Result', latex: p.latex }]
          : [];
        return { action: 'trig', resultLatex: p.latex, method: 'Trigonometry', steps, problemLatex: p.expr_tex };
      },
    };
  },

  statistics(task) {
    const mode = String(task.mode || 'descriptive');
    const mean = task.mean || task.mu || '';
    const sd = task.sd || task.sigma || task.stddev || '';
    const code = [
      PREAMBLE,
      '    import statistics as _sx',
      `    _mode = "${mode}"`,
      '    if _mode == "descriptive":',
      `        _d = [float(x) for x in _b64("${b64(task.data || '')}").replace(";", ",").split(",") if x.strip() != ""]`,
      '        if not _d: raise ValueError("no data")',
      '        _n = len(_d)',
      '        out = {"ok": True, "mode": "descriptive", "n": _n, "mean": _sx.mean(_d), "median": _sx.median(_d),',
      '               "pop_sd": _sx.pstdev(_d), "sample_sd": (_sx.stdev(_d) if _n > 1 else 0.0), "min": min(_d), "max": max(_d)}',
      '    elif _mode == "zscore":',
      `        _x = float(_PP(_b64("${b64(task.x || '')}")))`,
      `        _mu = float(_PP(_b64("${b64(mean)}")))`,
      `        _sd = float(_PP(_b64("${b64(sd)}")))`,
      '        out = {"ok": True, "mode": "zscore", "z": (_x - _mu) / _sd, "x": _x, "mu": _mu, "sd": _sd}',
      '    else:',
      '        out = {"ok": False, "error": "Unsupported statistics mode: " + _mode}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode2) {
        const r = (v) => (v == null ? '' : String(Math.round(Number(v) * 1e6) / 1e6));
        let resultLatex;
        let steps = [];
        if (p.mode === 'zscore') {
          resultLatex = `z=\\dfrac{${r(p.x)}-${r(p.mu)}}{${r(p.sd)}}=${r(p.z)}`;
        } else {
          resultLatex = `n=${p.n},\\; \\bar{x}=${r(p.mean)},\\; \\tilde{x}=${r(p.median)},\\; s=${r(p.sample_sd)},\\; \\sigma=${r(p.pop_sd)}`;
          if (mode2 === 'steps') {
            steps = [
              { title: 'Summary', latex: resultLatex },
              { title: 'Range', latex: `\\min=${r(p.min)},\\; \\max=${r(p.max)}` },
            ];
          }
        }
        return { action: 'statistics', resultLatex, method: 'Statistics (solver)', steps, problemLatex: '' };
      },
    };
  },

  logarithm(task) {
    const mode = String(task.mode || 'evaluate');
    const code = [
      PREAMBLE,
      `    _mode = "${mode}"`,
      `    _raw = _b64("${b64(task.expr || task.raw || '')}")`,
      '    if _mode == "expand":',
      '        _e = _PP(_raw); res = expand_log(_e, force=True)',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "expr_tex": latex(_e)}',
      '    elif _mode == "condense":',
      '        _e = _PP(_raw); res = logcombine(_e, force=True)',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "expr_tex": latex(_e)}',
      '    elif _mode == "simplify":',
      '        _e = _PP(_raw); res = logcombine(simplify(_e), force=True)',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "expr_tex": latex(_e)}',
      '    elif _mode == "solve":',
      '        if "=" in _raw:',
      '            _l, _r = _raw.split("=", 1); eqn = Eq(_PP(_l), _PP(_r))',
      '        else:',
      '            eqn = Eq(_PP(_raw), 0)',
      '        _fs = sorted(eqn.free_symbols, key=lambda z: z.name); var = _fs[0] if _fs else Symbol("x")',
      '        _sol = solve(eqn, var, dict=False)',
      '        if not isinstance(_sol, (list, tuple)): _sol = [_sol]',
      '        _tex = ", ".join(latex(var) + " = " + latex(s) for s in _sol)',
      '        out = {"ok": True, "latex": _tex, "text": str(_sol), "has_sol": len(_sol) > 0, "expr_tex": latex(eqn)}',
      '    else:',
      '        _e = _PP(_raw); res = simplify(_e)',
      '        try: res = nsimplify(res)',
      '        except Exception: pass',
      '        out = {"ok": True, "latex": latex(res), "text": str(res), "expr_tex": latex(_e)}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode2) {
        const label = { expand: 'Expand', condense: 'Condense', simplify: 'Simplify', solve: 'Solve', evaluate: 'Evaluate' }[mode] || 'Logarithm';
        const answer = mode === 'solve' ? (p.has_sol ? p.latex : '\\text{No solution}') : p.latex;
        const steps = mode2 === 'steps'
          ? [{ title: `${label} (logarithm)`, latex: p.expr_tex }, { title: 'Result', latex: answer }]
          : [];
        return { action: 'logarithm', resultLatex: answer, method: `Logarithm — ${label}`, steps, problemLatex: p.expr_tex };
      },
    };
  },

  lagrangian(task) {
    const code = [
      PREAMBLE,
      `    f = _P("${b64(task.objective || task.expr || '')}")`,
      `    _g = _P("${b64(task.constraint || '')}")`,
      `    _cv = _b64("${b64(task.constval || '')}")`,
      '    g0 = _g - (_PP(_cv) if _cv.strip() else 0)',
      `    _vs = [s.strip() for s in _b64("${b64(task.vars || '')}").split(",") if s.strip()]`,
      '    if not _vs: _vs = sorted({str(s) for s in (f.free_symbols | g0.free_symbols)})',
      '    vars = [Symbol(v) for v in _vs]',
      '    lam = Symbol("lambda_")',
      '    L = f - lam*g0',
      '    eqs = [diff(L, v) for v in vars] + [g0]',
      '    sols = solve(eqs, vars + [lam], dict=True)',
      '    pts = []',
      '    for s in sols:',
      '        try:',
      '            coords = ", ".join(latex(v) + "=" + latex(s.get(v)) for v in vars)',
      '            fval = simplify(f.subs(s))',
      '            pts.append("(" + coords + "):\\\\ f=" + latex(fval))',
      '        except Exception: pass',
      '    if not pts:',
      '        out = {"ok": False, "error": "No critical points found"}',
      '    else:',
      '        out = {"ok": True, "latex": ";\\\\quad ".join(pts), "text": str(sols), "obj_tex": latex(f), "g_tex": latex(g0)}',
      TRAILER,
    ].join('\n');
    return {
      code,
      finalize(p, mode2) {
        const problemLatex = `\\text{optimize } ${p.obj_tex} \\text{ s.t. } ${p.g_tex}=0`;
        const steps = mode2 === 'steps'
          ? [{ title: 'Lagrange conditions ∇f = λ∇g', latex: problemLatex }, { title: 'Critical points', latex: p.latex }]
          : [];
        return { action: 'lagrangian', resultLatex: p.latex, method: 'Lagrange multipliers', steps, problemLatex };
      },
    };
  },
};

/** POST a Python program to the OneCompiler backend and parse the RESULT: line. */
async function runSympy(code) {
  const url = ctxPath() + '/OneCompilerFunctionality?action=execute';
  const resp = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ language: 'python', version: '3.10', code }),
  });
  const data = await resp.json();
  const stdout = (data.Stdout || data.stdout || '').trim();
  const m = stdout.match(/RESULT:(\{[\s\S]*\})/);
  if (!m) return { ok: false, error: 'SymPy gave no result' };
  let parsed;
  try { parsed = JSON.parse(m[1]); } catch { return { ok: false, error: 'SymPy returned bad data' }; }
  return parsed;
}

/**
 * Escalate a failed task to SymPy. Returns a solve*Task-shaped object
 * ({ ok, mode, action, resultLatex, method, steps, problemLatex, source }) or
 * { ok:false } if no builder / the backend also can't solve it.
 */
// Which task field carries the problem input, per action — used to skip empty tasks.
const SOURCE_FIELDS = {
  derivative: ['expr'],
  limit: ['expr'],
  quadratic: ['expr', 'raw', 'equation'],
  inequality: ['expr', 'inequality', 'raw'],
  trig: ['expr', 'raw', 'latex'],
  statistics: ['data', 'x'],
  logarithm: ['expr', 'raw'],
  lagrangian: ['objective', 'expr', 'constraint'],
};

export async function solveViaSympyFallback(task, mode = 'simple') {
  if (!task || !canSympyFallback(task.action)) return { ok: false, error: 'No SymPy fallback for this action.' };
  const hasInput = (SOURCE_FIELDS[task.action] || ['expr'])
    .some((f) => task[f] != null && String(task[f]).trim() !== '');
  if (!hasInput) return { ok: false, error: 'No input to solve.' };

  const builder = BUILDERS[task.action](task);
  let parsed;
  try {
    parsed = await runSympy(builder.code);
  } catch (err) {
    return { ok: false, error: 'SymPy network error: ' + (err && err.message || err) };
  }
  if (!parsed || !parsed.ok) return { ok: false, error: parsed?.error || 'SymPy could not solve it.' };

  return {
    ok: true,
    mode,
    ...builder.finalize(parsed, mode),
    source: 'sympy',
  };
}
