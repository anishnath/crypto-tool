<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Shared SymPy-via-OneCompiler backend for the trig calculator family
  (function / equation / identity).  Mirrors integral-calculator-
  scripts.jsp:478 (parseIntegralViaBackend) — we POST a small Python
  script to /OneCompilerFunctionality?action=execute, the script feeds
  the raw MathLive LaTeX into sympy.parsing.latex.parse_latex, and
  returns a JSON result on stdout.

  Why this exists:
    The trig controllers used to send LaTeX-flavoured input straight to
    the LLM via /CFExamMarkerFunctionality (CFExamMarker).  That works
    but is slow (1–3 s), costs tokens, and the LLM occasionally
    hallucinates the periodicity of the general solution.  SymPy
    handles ~98 % of the routine workload deterministically in 20–60 ms
    — so this layer slots BETWEEN the existing client-side regex
    shortcut and the LLM fallback.

  Architecture (per controller):
      1. trySolveSimple()           — instant, free, narrow regex
      2. TrigBackend.compute(...)   — SymPy via OneCompiler  ←  this file
      3. TC.callAI(...)             — LLM fallback (rare)

  Public API (window.TrigBackend.compute):
      compute({
        latex:    '\\sin(2x)=\\cos(x)',   // raw MathLive LaTeX (preferred)
        text:     'sin(2x)=cos(x)',       // plain-text fallback if no latex
        mode:     'solve_equation',        // solve_equation | solve_inequality
                                          //  | simplify | evaluate | prove
        unit:     'rad',                  // 'deg' | 'rad' (evaluate only)
        variable: 'x',                    // typically 'x'
        lhs:      '\\tan^2 x - \\sin^2 x',// prove mode
        rhs:      '\\tan^2 x \\sin^2 x',  // prove mode
        timeout_ms: 15000                 // optional, default 15 s
      }, function (res) {
        // res = {
        //   ok: true|false,
        //   kind: 'solve|inequality|simplify|evaluate|prove',
        //   answer_latex: '\\frac{\\pi}{6}+2n\\pi \\cup \\frac{5\\pi}{6}+2n\\pi',
        //   answer_str:   'Union(ImageSet(...), ImageSet(...))',
        //   steps: [{title, latex}, ...]   // optional, may be empty
        //   is_identity: true|false       // prove mode only
        //   counterexample: { x: '0.5', lhs: '0.25', rhs: '0.5' } | null
        //   error: '...' | undefined
        // }
      })

  No JS-side LaTeX-to-text conversion.  The Python script does its
  own minimal pre-pass (\left/\right/\Big*) — same as the integral
  calculator does (and for the same reason: parse_latex chokes on
  sizing decorations but handles everything else).
--%>

<script>
(function () {
    'use strict';

    var CTX = (typeof window.TRIG_CALC_CTX === 'string')
        ? window.TRIG_CALC_CTX
        : ((document.querySelector('meta[name="context-path"]') || {}).content || '');

    // ─────────────────────────────────────────────────────────────────
    //  Python script template — built per request because the LaTeX
    //  payload is interpolated into a raw triple-quoted Python literal.
    // ─────────────────────────────────────────────────────────────────
    function buildPythonScript(opts) {
        function pyEsc(s) {
            return String(s == null ? '' : s).replace(/"""/g, '\\"\\"\\"');
        }

        var mode = opts.mode || 'simplify';
        var unit = opts.unit || 'rad';
        var variable = opts.variable || 'x';

        // For prove mode we ship LHS + RHS.  For everything else, the
        // single `latex` (or `text` fallback) is the whole problem.
        var primary = pyEsc(opts.latex || opts.text || '');
        var lhs = pyEsc(opts.lhs || '');
        var rhs = pyEsc(opts.rhs || '');

        return [
            'import json, re',
            'from sympy.parsing.latex import parse_latex',
            'from sympy.parsing.sympy_parser import (',
            '    parse_expr, standard_transformations,',
            '    implicit_multiplication_application, convert_xor)',
            'import sympy as sp',
            'from sympy import (',
            '    Symbol, Equality, Unequality, GreaterThan, LessThan,',
            '    StrictGreaterThan, StrictLessThan, S, Reals, EmptySet,',
            '    pi, sqrt, simplify, trigsimp, expand_trig, solveset,',
            '    sin, cos, tan, csc, sec, cot, asin, acos, atan, oo, Rational, Integer)',
            '',
            'MODE = ' + JSON.stringify(mode),
            'UNIT = ' + JSON.stringify(unit),
            'VAR_NAME = ' + JSON.stringify(variable),
            'PRIMARY = r"""' + primary + '"""',
            'LHS_RAW = r"""' + lhs + '"""',
            'RHS_RAW = r"""' + rhs + '"""',
            '',
            '# Sizing commands parse_latex cannot handle',
            'def strip_sizing(s):',
            '    s = re.sub(r"\\\\left\\s*([({\\[|])", r"\\1", s)',
            '    s = re.sub(r"\\\\right\\s*([)}\\]|])", r"\\1", s)',
            '    s = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr|big|Big)\\s*", "", s)',
            '    return s',
            '',
            '# parse_latex leaves pi / e / infty as plain Symbols — substitute back',
            'CONST_MAP = {',
            '    Symbol("pi"): pi, Symbol("Pi"): pi,',
            '    Symbol("e"): sp.E, Symbol("E"): sp.E,',
            '    Symbol("infty"): oo, Symbol("infinity"): oo, Symbol("oo"): oo,',
            '}',
            '',
            'TXT_TRANSFORMS = standard_transformations + (',
            '    sp.parsing.sympy_parser.function_exponentiation,',
            '    implicit_multiplication_application, convert_xor)',
            'TXT_LOCALS = {',
            '    "sin": sin, "cos": cos, "tan": tan,',
            '    "csc": csc, "sec": sec, "cot": cot,',
            '    "arcsin": asin, "arccos": acos, "arctan": atan,',
            '    "asin": asin, "acos": acos, "atan": atan,',
            '    "sqrt": sqrt, "pi": pi, "oo": oo, "E": sp.E,',
            '}',
            '',
            'REL_OPS = ["<=", ">=", "!=", "<", ">", "="]',
            '',
            'def parse_text(raw):',
            '    # Plain-text path (no backslashes) — split on relop',
            '    # first since parse_expr does not handle = or',
            '    # inequalities, then sympify each side with',
            '    # implicit-mul + locals.',
            '    for op in REL_OPS:',
            '        idx = raw.find(op)',
            '        if idx >= 0:',
            '            lhs = raw[:idx]',
            '            rhs = raw[idx+len(op):]',
            '            L = parse_expr(lhs, local_dict=TXT_LOCALS,',
            '                           transformations=TXT_TRANSFORMS,',
            '                           evaluate=True)',
            '            R = parse_expr(rhs, local_dict=TXT_LOCALS,',
            '                           transformations=TXT_TRANSFORMS,',
            '                           evaluate=True)',
            '            if op == "=":  return Equality(L, R)',
            '            if op == "<=": return LessThan(L, R)',
            '            if op == ">=": return GreaterThan(L, R)',
            '            if op == "!=": return Unequality(L, R)',
            '            if op == "<":  return StrictLessThan(L, R)',
            '            if op == ">":  return StrictGreaterThan(L, R)',
            '    return parse_expr(raw, local_dict=TXT_LOCALS,',
            '                      transformations=TXT_TRANSFORMS, evaluate=True)',
            '',
            'def parse_one(raw):',
            '    """Route LaTeX inputs through parse_latex; plain text',
            '       (no backslash) through parse_expr.  parse_latex',
            '       SILENTLY misparses bare ASCII (e.g. "sin(45)" →',
            '       s*i*n*45) so a backslash-presence check is mandatory."""',
            '    if not raw:',
            '        return None',
            '    looks_latex = ("\\\\" in raw)',
            '    if looks_latex:',
            '        cleaned = strip_sizing(raw)',
            '        try:',
            '            node = parse_latex(cleaned)',
            '        except Exception:',
            '            try:',
            '                node = parse_latex(cleaned, backend="lark")',
            '            except Exception:',
            '                node = parse_text(raw)',
            '    else:',
            '        node = parse_text(raw)',
            '    if hasattr(node, "data") and node.data == "_ambig":',
            '        node = node.children[0]',
            '    return node.subs(CONST_MAP) if hasattr(node, "subs") else node',
            '',
            'def pick_var(node):',
            '    if not hasattr(node, "free_symbols") or not node.free_symbols:',
            '        return Symbol(VAR_NAME, real=True)',
            '    by_name = {str(s): s for s in node.free_symbols}',
            '    return by_name.get(VAR_NAME, next(iter(node.free_symbols)))',
            '',
            'def best_simplify(e):',
            '    cands = [e, trigsimp(e), simplify(e), trigsimp(simplify(e)),',
            '             simplify(expand_trig(e)), trigsimp(expand_trig(e)), sp.fu(e)]',
            '    return min(cands, key=lambda c: (sp.count_ops(c), len(str(c))))',
            '',
            '# ── Step generator using SymPy\'s named Fu transformation rules ──',
            '# Each TR* rule represents one named precalc identity.  Greedy +',
            '# bounded BFS picks the rule that reduces a complexity metric',
            '# the most.  Cycle detection prevents oscillation between',
            '# inverse rules (e.g. TR8 ↔ TR9 product↔sum).',
            'import importlib',
            'try:',
            '    _FU = importlib.import_module("sympy.simplify.fu")',
            'except Exception:',
            '    _FU = None',
            '',
            'STEP_RULES = [',
            '    ("TR1",   "Convert sec → 1/cos and csc → 1/sin"),',
            '    ("TR2",   "Convert tan → sin/cos and cot → cos/sin"),',
            '    ("TR2i",  "Combine sin/cos ratios into tan or cot"),',
            '    ("TR3",   "Apply induced formulas (sin(-x) = -sin(x), etc.)"),',
            '    ("TR4",   "Substitute special-angle values"),',
            '    ("TR5",   "Apply Pythagorean identity: sin²(x) → 1 - cos²(x)"),',
            '    ("TR6",   "Apply Pythagorean identity: cos²(x) → 1 - sin²(x)"),',
            '    ("TR7",   "Lower the power of cos²(x) using cos(2x)"),',
            '    ("TR8",   "Convert products to sums (product-to-sum)"),',
            '    ("TR9",   "Convert sums to products (sum-to-product)"),',
            '    ("TR10",  "Expand sum/difference angle formulas"),',
            '    ("TR10i", "Combine sums of products into a single angle"),',
            '    ("TR11",  "Expand double-angle formulas"),',
            '    ("TR12",  "Separate sums in tangent"),',
            '    ("TR12i", "Combine tangent arguments"),',
            '    ("TR13",  "Combine products of tangent or cotangent"),',
            '    ("TR14",  "Factor powers of sin and cos identities"),',
            '    ("TR15",  "Convert sin(x)⁻² → 1 + cot²(x)"),',
            '    ("TR16",  "Convert cos(x)⁻² → 1 + tan²(x)"),',
            '    ("TR22",  "Convert tan²(x) → sec²(x) - 1"),',
            '    ("TR111", "Convert reciprocal powers"),',
            '    ("TRpower", "Lower powers of sin/cos via reduction formulas"),',
            '    ("TRmorrie", "Apply Morrie\'s identity"),',
            ']',
            '',
            'def _step_cost(e):',
            '    try: return (_FU.L(e), sp.count_ops(e), len(str(e)))',
            '    except Exception: return (10**6, 10**6, len(str(e)))',
            '',
            'def simplify_with_steps(expr, max_steps=10):',
            '    """Greedy step-by-step simplification using named Fu rules."""',
            '    if _FU is None: return best_simplify(expr), []',
            '    steps = []',
            '    seen = {str(expr)}',
            '    current = expr',
            '    for _ in range(max_steps):',
            '        baseline = _step_cost(current)',
            '        best = None',
            '        for name, label in STEP_RULES:',
            '            rule = getattr(_FU, name, None)',
            '            if rule is None: continue',
            '            try: cand = rule(current)',
            '            except Exception: continue',
            '            if cand == current or str(cand) in seen: continue',
            '            c = _step_cost(cand)',
            '            if c < baseline and (best is None or c < best[3]):',
            '                best = (name, label, cand, c)',
            '        if best is None:',
            '            combined = trigsimp(simplify(current))',
            '            if _step_cost(combined) < baseline and combined != current:',
            '                steps.append({"rule": "combine", "label": "Combine and simplify",',
            '                              "before": current, "after": combined})',
            '                current = combined',
            '            break',
            '        name, label, after, _ = best',
            '        steps.append({"rule": name, "label": label,',
            '                      "before": current, "after": after})',
            '        seen.add(str(after))',
            '        current = after',
            '    return current, steps',
            '',
            'def prove_with_steps(lhs, rhs, max_steps=12):',
            '    """Transform LHS → RHS using named Fu rules; minimise',
            '       distance to RHS at each step."""',
            '    if _FU is None:',
            '        return (simplify(lhs - rhs) == 0), lhs, []',
            '    def gap(e): return _step_cost(simplify(e - rhs))',
            '    is_id_quick = (simplify(lhs - rhs) == 0)',
            '    steps = []',
            '    seen = {str(lhs)}',
            '    current = lhs',
            '    for _ in range(max_steps):',
            '        if str(current) == str(rhs) or current == rhs:',
            '            return True, current, steps',
            '        baseline = gap(current)',
            '        best = None',
            '        for name, label in STEP_RULES:',
            '            rule = getattr(_FU, name, None)',
            '            if rule is None: continue',
            '            try: cand = rule(current)',
            '            except Exception: continue',
            '            if cand == current or str(cand) in seen: continue',
            '            g = gap(cand)',
            '            if g <= baseline and (best is None or g < best[3]):',
            '                best = (name, label, cand, g)',
            '        if best is None: break',
            '        name, label, after, _ = best',
            '        steps.append({"rule": name, "label": label,',
            '                      "before": current, "after": after})',
            '        seen.add(str(after))',
            '        current = after',
            '        if simplify(current - rhs) == 0 and str(current) == str(rhs):',
            '            return True, current, steps',
            '    final = trigsimp(simplify(current))',
            '    if simplify(final - rhs) == 0:',
            '        if final != current:',
            '            steps.append({"rule": "combine",',
            '                          "label": "Combine and simplify to canonical form",',
            '                          "before": current, "after": final})',
            '        return True, final, steps',
            '    if is_id_quick:',
            '        return True, current, steps',
            '    return False, current, steps',
            '',
            'def steps_to_json(steps):',
            '    return [{"rule": s["rule"], "label": s["label"],',
            '             "before_latex": sp.latex(s["before"]),',
            '             "after_latex":  sp.latex(s["after"])} for s in steps]',
            '',
            'def to_latex(e):',
            '    try: return sp.latex(e)',
            '    except Exception: return str(e)',
            '',
            'def fmt_solveset(sset):',
            '    """Format an equation/inequality solveset as readable LaTeX."""',
            '    if sset == EmptySet:',
            '        return "\\\\text{No solution}"',
            '    if sset == Reals:',
            '        return "\\\\text{All real numbers (identity)}"',
            '    return sp.latex(sset)',
            '',
            'def deg_to_rad(node):',
            '    """When unit=deg, wrap numeric trig args in *pi/180."""',
            '    if not isinstance(node, sp.Expr):',
            '        return node',
            '    trig_funcs = (sin, cos, tan, csc, sec, cot)',
            '    def _conv(n):',
            '        if isinstance(n, trig_funcs):',
            '            arg = n.args[0]',
            '            if arg.is_number:',
            '                return n.func(arg * pi / 180)',
            '        return n',
            '    return node.replace(lambda n: isinstance(n, trig_funcs), _conv)',
            '',
            'out = {"ok": False, "kind": MODE}',
            'try:',
            '    if MODE == "prove":',
            '        # Identity prover — simplify (LHS - RHS) and check zero',
            '        L = parse_one(LHS_RAW)',
            '        R = parse_one(RHS_RAW)',
            '        if L is None or R is None:',
            '            raise ValueError("LHS or RHS empty")',
            '        diff = best_simplify(L - R)',
            '        is_id = (diff == 0)',
            '        # Generate named derivation steps via Fu rules',
            '        prove_ok, _, prove_steps = prove_with_steps(L, R)',
            '        out.update(ok=True, kind="prove", is_identity=bool(is_id),',
            '                   answer_latex=to_latex(L) + " = " + to_latex(R),',
            '                   steps=steps_to_json(prove_steps) if is_id else [],',
            '                   counterexample=None)',
            '        if not is_id:',
            '            # Find a numerical counterexample by sampling',
            '            for sample in [Rational(1,4), Rational(1,3), Rational(1,2),',
            '                           pi/6, pi/4, pi/3, 1, 2]:',
            '                free = (L-R).free_symbols',
            '                if not free: break',
            '                v = next(iter(free))',
            '                lv = sp.simplify(L.subs(v, sample))',
            '                rv = sp.simplify(R.subs(v, sample))',
            '                if lv != rv and lv.is_finite is not False and rv.is_finite is not False:',
            '                    out["counterexample"] = {',
            '                        "x": str(sample), "lhs": str(lv), "rhs": str(rv)}',
            '                    break',
            '    else:',
            '        node = parse_one(PRIMARY)',
            '        if node is None:',
            '            raise ValueError("empty input")',
            '',
            '        if isinstance(node, Equality):',
            '            v = pick_var(node)',
            '            sset = solveset(node.lhs - node.rhs, v, domain=S.Reals)',
            '            out.update(ok=True, kind="solve",',
            '                       answer_latex=fmt_solveset(sset),',
            '                       answer_str=str(sset))',
            '        elif isinstance(node, (StrictGreaterThan, StrictLessThan,',
            '                               GreaterThan, LessThan, Unequality)):',
            '            v = pick_var(node)',
            '            sset = sp.solveset(node, v, domain=S.Reals)',
            '            out.update(ok=True, kind="inequality",',
            '                       answer_latex=fmt_solveset(sset),',
            '                       answer_str=str(sset))',
            '        elif MODE == "evaluate" and not node.free_symbols:',
            '            ev = deg_to_rad(node) if UNIT == "deg" else node',
            '            # Generate named derivation steps via Fu rules,',
            '            # then pick the cleanest closed-form answer:',
            '            #   simplify    — sin*cos products (sin³·sin → √3/8)',
            '            #   trigsimp/fu — alternative trig reductions',
            '            #   nsimplify   — closed-form recovery from float;',
            '            #     basis sqrt(2), sqrt(3) (no sqrt(5)) keeps',
            '            #     output simple — pentagonal angles are rare.',
            '            _, eval_steps = simplify_with_steps(ev)',
            '            cands = []',
            '            for fn in (simplify, trigsimp, sp.fu):',
            '                try: cands.append(fn(ev))',
            '                except Exception: pass',
            '            try:',
            '                cands.append(sp.nsimplify(ev, [pi, sqrt(2), sqrt(3)],',
            '                                          rational=False))',
            '            except Exception: pass',
            '            cands.append(ev)',
            '            ans = min(cands, key=lambda c: (sp.count_ops(c), len(str(c))))',
            '            out.update(ok=True, kind="evaluate",',
            '                       answer_latex=to_latex(ans),',
            '                       answer_str=str(ans),',
            '                       steps=steps_to_json(eval_steps))',
            '        else:',
            '            ans, simp_steps = simplify_with_steps(node)',
            '            # Final canonical pass for a guaranteed-clean answer',
            '            ans = best_simplify(ans)',
            '            out.update(ok=True, kind="simplify",',
            '                       answer_latex=to_latex(ans),',
            '                       answer_str=str(ans),',
            '                       steps=steps_to_json(simp_steps))',
            'except Exception as e:',
            '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e),',
            '           "kind": MODE}',
            '',
            'print("RESULT:" + json.dumps(out))',
            ''
        ].join('\n');
    }

    // ─────────────────────────────────────────────────────────────────
    //  POST + result extraction.  Matches the existing
    //  parseIntegralViaBackend contract (RESULT:{...} on stdout).
    // ─────────────────────────────────────────────────────────────────
    function compute(opts, callback) {
        opts = opts || {};
        if (typeof callback !== 'function') return;
        if (!opts.latex && !opts.text && !(opts.lhs && opts.rhs)) {
            callback({ ok: false, error: 'empty input' });
            return;
        }

        var code = buildPythonScript(opts);
        var timeoutMs = opts.timeout_ms || 15000;
        var done = false;

        var controller = ('AbortController' in window) ? new AbortController() : null;
        var timer = setTimeout(function () {
            if (done) return;
            done = true;
            if (controller) try { controller.abort(); } catch (_) {}
            callback({ ok: false, error: 'timeout' });
        }, timeoutMs);

        fetch(CTX + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller ? controller.signal : undefined
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (done) return;
            done = true; clearTimeout(timer);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var m = stdout.match(/RESULT:(\{[\s\S]*\})/);
            if (!m) {
                callback({ ok: false, error: 'no backend response',
                           stderr: data.Stderr || data.stderr || '' });
                return;
            }
            try { callback(JSON.parse(m[1])); }
            catch (e) { callback({ ok: false, error: 'bad backend JSON' }); }
        })
        .catch(function (err) {
            if (done) return;
            done = true; clearTimeout(timer);
            callback({ ok: false, error: (err && err.message) || 'network error' });
        });
    }

    // Read the math-field LaTeX out of an .mml-pair (math-input-multi.jsp
    // contract).  Convenience helper for controllers that need to grab
    // the raw LaTeX rather than the mirrored ASCII text input.
    function readLatex(pairOrInputId) {
        var pair = (typeof pairOrInputId === 'string')
            ? document.getElementById(pairOrInputId)
            : pairOrInputId;
        if (!pair) return '';
        if (!pair.classList || !pair.classList.contains('mml-pair')) {
            // Maybe they passed the text input — walk up to the pair
            pair = pair.closest && pair.closest('.mml-pair');
            if (!pair) return '';
        }
        var mf = pair.querySelector('math-field, .mml-mathfield');
        if (!mf || typeof mf.getValue !== 'function') return '';
        try { return (mf.getValue('latex') || '').trim(); }
        catch (_) { return ''; }
    }

    window.TrigBackend = {
        compute: compute,
        readLatex: readLatex,
        // Expose the script builder for debugging / testing
        _buildScript: buildPythonScript
    };
})();
</script>
