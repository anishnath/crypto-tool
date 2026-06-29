/**
 * ODE Solver — shared core (the SAME battle-tested SymPy backbone the page uses).
 *
 * This is the single source of truth for:
 *   · expression normalization (normalizeExpr) + Python conversion (exprToPython)
 *   · SymPy program generation (buildSympyCode)  — dsolve / classify_ode / checkodesol
 *   · stdout parsing (parseResult)
 *   · the OneCompiler round-trip (solve)
 *
 * Both ode-solver-calculator.js (the page UI) and the Generic Math AI chat call
 * into this module so the chat returns *exactly* what the page returns — no
 * second, weaker engine to keep in sync.
 *
 * Browser: window.ODECalculatorCore. Node: module.exports.
 */
'use strict';

var ODECalculatorCore = (function () {

    // ── Expression hygiene (verbatim from the page controller) ───────────────

    function exprToPython(expr) {
        var py = (expr || '').trim()
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    function normalizeExpr(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        var s = expr.trim();
        s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')
             .replace(/\u2074/g, '^4').replace(/\u2075/g, '^5')
             .replace(/\u2076/g, '^6').replace(/\u2077/g, '^7')
             .replace(/\u2078/g, '^8').replace(/\u2079/g, '^9')
             .replace(/\u2070/g, '^0').replace(/\u00b9/g, '^1')
             .replace(/\u03c0/g, 'pi')
             .replace(/\u221a/g, 'sqrt')
             .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
             .replace(/\u2212/g, '-')
             .replace(/\u00d7/g, '*');
        // LaTeX / MathLive leaks (\cdot already handled on page; \prime may reach core from chat)
        s = s.replace(/\\cdot/g, '*').replace(/\\times/g, '*').replace(/\\prime/g, "'");
        // y^(''), y^{''}, y^(\prime\prime) after prime→quote pass
        s = s.replace(/y\s*\^?\s*[\({]\s*('+\s*)+[\)}]/g, function (m) {
            var n = (m.match(/'/g) || []).length;
            if (n >= 5) return 'y5';
            if (n === 4) return 'y4';
            if (n === 3) return 'yppp';
            if (n === 2) return 'ypp';
            if (n === 1) return 'yp';
            return 'y';
        });
        s = s.replace(/y'{5}/g, 'y5').replace(/y'{4}/g, 'y4').replace(/y'{3}/g, 'yppp')
             .replace(/y'{2}/g, 'ypp').replace(/y'/g, 'yp');
        s = s.replace(/y\u2032\u2032\u2032\u2032\u2032/g, 'y5').replace(/y\u2032\u2032\u2032\u2032/g, 'y4')
             .replace(/y\u2032\u2032\u2032/g, 'yppp').replace(/y\u2032\u2032/g, 'ypp').replace(/y\u2032/g, 'yp');
        // Strip trailing "= 0" when user pastes a full homogeneous equation into the RHS field
        s = s.replace(/=\s*0+\s*$/g, '');
        // Collapse ^{...} / ^(...) exponent groups left by LaTeX (avoid y**{i} in Python)
        s = s.replace(/\^\s*\{([^{}]*)\}/g, '^($1)').replace(/\^\s*\(([^()]*)\)/g, '^($1)');
        var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt|asin|acos|atan|exp';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2*$3)');
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('([b-dB-Df-wF-W])(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(/(\d)([a-wA-W])/g, '$1*$2');
        s = s.replace(/\bln\(/g, 'log(');
        return s;
    }

    function pyEscape(s) {
        return String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"');
    }

    /**
     * Flip signs on a flat sum (2*yp+y → -2*yp-y).
     */
    function negateAdditiveTerms(s) {
        s = String(s || '').trim();
        if (!s || s === '0') return '0';
        var parts = [];
        var depth = 0;
        var cur = '';
        var op = 1;
        for (var i = 0; i < s.length; i++) {
            var c = s[i];
            if (c === '(') depth++;
            else if (c === ')') depth--;
            else if (depth === 0 && (c === '+' || c === '-')) {
                if (cur) parts.push({ sign: op, term: cur.trim() });
                op = c === '+' ? 1 : -1;
                cur = '';
                continue;
            }
            cur += c;
        }
        if (cur.trim()) parts.push({ sign: op, term: cur.trim() });
        var out = parts.map(function (p) {
            return (p.sign > 0 ? '-' : '+') + p.term;
        }).join('');
        return out.charAt(0) === '+' ? out.slice(1) : out;
    }

    /**
     * When the user pastes a homogeneous equation (y''+2y'+y=0) into the RHS
     * field, rewrite to isolated RHS form: y'' = -2y' - y  →  -2*yp-y
     */
    function homogEquationToRhs(s, order) {
        if (!s) return s;
        var heads = { 1: 'yp', 2: 'ypp', 3: 'yppp', 4: 'y4', 5: 'y5' };
        var head = heads[order];
        if (!head || s.indexOf(head) !== 0) return s;
        var rest = s.substring(head.length).trim();
        if (rest.charAt(0) === '+') rest = rest.substring(1).trim();
        if (!rest) return '0';
        return negateAdditiveTerms(rest);
    }

    /** Full ODE RHS pipeline: normalize → homog rewrite → Python. */
    function prepareOdeRhs(raw, order) {
        var s = normalizeExpr(String(raw || '').trim());
        if (/=\s*0+\s*$/.test(s)) s = s.replace(/=\s*0+\s*$/, '');
        if (order >= 2) s = homogEquationToRhs(s, order);
        return exprToPython(s);
    }

    /** Pedagogical step builders — run after solve, before STEPS output. */
    function buildSympyPedagogyStepsPy() {
        return [
            'def _ped_step(title, latex):',
            '    _pedagogy_steps.append({"title": title, "latex": latex})',
            '',
            'def _has_y(expr):',
            '    return expr.has(y(x))',
            '',
            'def _can_separate():',
            '    if not _has_y(rhs_expr):',
            '        return True',
            '    try:',
            '        ratio = simplify(rhs_expr / y(x))',
            '        return not _has_y(ratio)',
            '    except Exception:',
            '        return False',
            '',
            'def _separable_steps():',
            '    if not _has_y(rhs_expr):',
            '        _ped_step("Separate variables", r"dy = " + latex(rhs_expr) + r"\\,dx")',
            '        _int = integrate(rhs_expr, x)',
            '        _ped_step("Integrate both sides", r"y = \\int " + latex(rhs_expr) + r"\\,dx = " + latex(_int) + r" + C_1")',
            '        return',
            '    _ratio = simplify(rhs_expr / y(x))',
            '    _ped_step("Divide by y", latex(Eq(y(x).diff(x) / y(x), _ratio)))',
            '    _ped_step("Separate variables", r"\\frac{1}{y}\\,dy = " + latex(_ratio) + r"\\,dx")',
            '    _int = integrate(_ratio, x)',
            '    _ped_step("Integrate both sides", r"\\log|y| = " + latex(_int) + r" + C_1")',
            '',
            'def _linear_steps():',
            '    _p = Poly(rhs_expr, y(x))',
            '    if _p.degree() != 1:',
            '        return',
            '    _cs = _p.all_coeffs()',
            '    if len(_cs) != 2:',
            '        return',
            '    _a, _b = _cs',
            '    _P = -_a',
            '    _Q = _b',
            '    _mu = exp(integrate(_P, x))',
            '    _ped_step("Standard form", r"y\' + " + latex(_P) + r"\\,y = " + latex(_Q))',
            '    _ped_step("Integrating factor", r"\\mu(x) = e^{\\int " + latex(_P) + r"\\,dx} = " + latex(simplify(_mu)))',
            '    _ped_step("Multiply and integrate", r"\\mu y = \\int " + latex(simplify(_mu * _Q)) + r"\\,dx + C_1")',
            '',
            'def _exact_steps():',
            '    _linear_steps()',
            '',
            'def _homog_v_pedagogy_steps():',
            '    _ped_step("Substitution", r"v = \\frac{y}{x},\\quad y = vx")',
            '    if reduced_latex:',
            '        _ped_step("Reduced ODE in v", reduced_latex)',
            '    _ratio = None',
            '    try:',
            '        v = Function("v")',
            '        _rv = rhs_expr.subs(y(x), v(x) * x)',
            '        _ode_v = Eq(v(x) + x * Derivative(v(x), x), _rv)',
            '        _lhs = simplify(_ode_v.lhs - _rv)',
            '        if _has_y(_lhs):',
            '            pass',
            '        elif not _has_y(_rv):',
            '            _ped_step("Separate variables", r"\\frac{dv}{dx} = " + latex(simplify(_rv - v(x))))',
            '    except Exception:',
            '        pass',
            '    if sol is not None:',
            '        _ped_step("Back-substitute y = vx", latex(sol))',
            '',
            'def _const_coeff_homog_steps():',
            '    _r = symbols("r")',
            '    _a1 = expand(rhs_expr).coeff(y(x).diff(x))',
            '    _a0 = expand(rhs_expr).coeff(y(x))',
            '    if _a1 is None: _a1 = S.Zero',
            '    if _a0 is None: _a0 = S.Zero',
            '    _char = expand(_r**2 - _a1 * _r - _a0)',
            '    _roots = solve(_char, _r)',
            '    _ped_step("Assume y = e^{rx}", r"y = e^{rx}")',
            '    _ped_step("Characteristic equation", latex(Eq(_char, 0)))',
            '    _ped_step("Roots", r"r = " + latex(_roots))',
            '    if len(_roots) == 2 and all(r.is_real for r in _roots):',
            '        _ped_step("General solution", r"y = C_1 e^{" + latex(_roots[0]) + r"x} + C_2 e^{" + latex(_roots[1]) + r"x}")',
            '    elif len(_roots) == 2:',
            '        _ped_step("General solution (complex roots)", r"y = e^{\\alpha x}(C_1 \\cos\\beta x + C_2 \\sin\\beta x)")',
            '',
            'def _undetermined_coeff_steps():',
            '    _r = symbols("r")',
            '    _hom_rhs = expand(rhs_expr).subs(y(x), 0)',
            '    _a1 = expand(rhs_expr - _hom_rhs).coeff(y(x).diff(x)) if False else None',
            '    _hom = Eq(y(x).diff(x, 2), expand(rhs_expr).coeff(y(x).diff(x)) * y(x).diff(x) + expand(rhs_expr).coeff(y(x)) * y(x))',
            '    _a1 = expand(rhs_expr).coeff(y(x).diff(x)) or S.Zero',
            '    _a0 = expand(rhs_expr).coeff(y(x)) or S.Zero',
            '    _char = expand(_r**2 - _a1 * _r - _a0)',
            '    _roots = solve(_char, _r)',
            '    _ped_step("Homogeneous equation", r"y\'\' - " + latex(_a1) + r"y\' - " + latex(_a0) + r"y = 0")',
            '    _ped_step("Characteristic equation", latex(Eq(_char, 0)))',
            '    if _char == _r**2 + 1:',
            '        _ped_step("Homogeneous solution", r"y_h = C_1 \\cos x + C_2 \\sin x")',
            '    elif len(_roots) == 2 and all(rt.is_real for rt in _roots):',
            '        _ped_step("Homogeneous solution", r"y_h = C_1 e^{" + latex(_roots[0]) + r"x} + C_2 e^{" + latex(_roots[1]) + r"x}")',
            '    else:',
            '        _ped_step("Homogeneous solution", r"y_h = C_1 e^{r_1 x} + C_2 e^{r_2 x}")',
            '    _forcing = simplify(rhs_expr - (_a1 * y(x).diff(x) + _a0 * y(x)))',
            '    _ped_step("Forcing term", r"F(x) = " + latex(_forcing))',
            '    _ped_step("Particular solution (undetermined coefficients)", r"y_p \\text{ chosen to match } " + latex(_forcing))',
            '',
            'def _bernoulli_steps():',
            '    _n = None',
            '    for _pow in (5, 4, 3, 2):',
            '        if rhs_expr.has(y(x)**_pow):',
            '            _n = _pow',
            '            break',
            '    if _n is None:',
            '        return',
            '    _p = Poly(expand(rhs_expr), y(x))',
            '    _lin = _p.coeff_monomial(y(x))',
            '    _lead = _p.coeff_monomial(y(x)**_n)',
            '    _P = -simplify(_lin / (_n - 1) if _n != 1 else _lin)',
            '    _ped_step("Bernoulli form", r"y\' + P(x)y = Q(x)y^{" + str(_n) + r"}")',
            '    _ped_step("Substitution", r"v = y^{" + str(1 - _n) + r"},\\quad y = v^{\\frac{1}{" + str(1 - _n) + r"}}")',
            '    _ped_step("Linear equation in v", r"v\' + (1-" + str(_n) + r")P(x)v = (1-" + str(_n) + r")Q(x)")',
            '    if sol is not None:',
            '        _ped_step("Back-substitute for y", latex(sol))',
            '',
            'def _true_exact_steps():',
            '    try:',
            '        _ys = Symbol("y")',
            '        _rhs_s = rhs_expr.subs(y(x), _ys)',
            '        _num, _den = fraction(together(_rhs_s))',
            '        _M = simplify(-_num)',
            '        _N = simplify(_den)',
            '        _dM = simplify(diff(_M, _ys))',
            '        _dN = simplify(diff(_N, x))',
            '        _ped_step("Exact form", r"M\\,dx + N\\,dy = 0")',
            '        _ped_step("Identify M and N", r"M = " + latex(_M) + r",\\quad N = " + latex(_N))',
            '        _ped_step("Exactness check", r"\\frac{\\partial M}{\\partial y} = " + latex(_dM) + r",\\quad \\frac{\\partial N}{\\partial x} = " + latex(_dN))',
            '        if simplify(_dM - _dN) == 0:',
            '            _psi = integrate(_M, x)',
            '            _corr = integrate(_N - diff(_psi, _ys), _ys)',
            '            _F = simplify(_psi + _corr)',
            '            _ped_step("Potential function", latex(Eq(_F, Symbol("C_1"))))',
            '        if sol is not None:',
            '            _ped_step("General solution", latex(sol))',
            '    except Exception:',
            '        pass',
            '',
            'def _euler_steps():',
            '    _r = symbols("r")',
            '    _ped_step("Euler substitution", r"y = x^r \\quad (\\text{equivalently } x = e^t)")',
            '    try:',
            '        _yp = y(x).diff(x)',
            '        _ypp = y(x).diff(x, 2)',
            '        _stdeq = expand(x**2 * _ypp - x**2 * rhs_expr)',
            '        _a1 = simplify(_stdeq.coeff(_yp) / x) if _stdeq.has(_yp) else S.Zero',
            '        _a0 = simplify(_stdeq.coeff(y(x)))',
            '        _char = expand(_r * (_r - 1) + _a1 * _r + _a0)',
            '        _roots = solve(_char, _r)',
            '        _ped_step("Characteristic equation", latex(Eq(_char, 0)))',
            '        _ped_step("Roots", r"r = " + latex(_roots))',
            '        if len(_roots) == 2 and _roots[0] == _roots[1]:',
            '            _ped_step("General solution", r"y = x^{" + latex(_roots[0]) + r"}(C_1 + C_2 \\log x)")',
            '        elif len(_roots) == 2:',
            '            _ped_step("General solution", r"y = C_1 x^{" + latex(_roots[0]) + r"} + C_2 x^{" + latex(_roots[1]) + r"}")',
            '    except Exception:',
            '        pass',
            '',
            'def _vop_steps():',
            '    _a1 = expand(rhs_expr).coeff(y(x).diff(x)) or S.Zero',
            '    _a0 = expand(rhs_expr).coeff(y(x)) or S.Zero',
            '    _forcing = simplify(rhs_expr - _a1 * y(x).diff(x) - _a0 * y(x))',
            '    _hom = Eq(y(x).diff(x, 2) + (-_a1) * y(x).diff(x) + (-_a0) * y(x), 0)',
            '    _ped_step("Homogeneous equation", latex(_hom))',
            '    try:',
            '        _yh = dsolve(_hom, y(x))',
            '        _ped_step("Homogeneous solution", latex(_yh))',
            '    except Exception:',
            '        _ped_step("Homogeneous solution", r"y_h = C_1 y_1 + C_2 y_2")',
            '    _ped_step("Variation of parameters", r"y_p = y_1\\int\\frac{y_2 f}{W}\\,dx - y_2\\int\\frac{y_1 f}{W}\\,dx")',
            '    _ped_step("Forcing", r"f(x) = " + latex(_forcing))',
            '    if sol is not None:',
            '        _ped_step("General solution", latex(sol))',
            '',
            'def _infer_exact_from_rhs():',
            '    try:',
            '        _ys = Symbol("y")',
            '        _rhs_s = rhs_expr.subs(y(x), _ys)',
            '        _num, _den = fraction(together(_rhs_s))',
            '        return simplify(-_num), simplify(_den), simplify(diff(-_num, _ys) - diff(_den, x)) == 0',
            '    except Exception:',
            '        return None, None, False',
            '',
            'def _build_pedagogy_steps():',
            '    global _pedagogy_steps',
            '    if _pedagogy_steps:',
            '        return',
            '    _mu = str(method_used or "")',
            '    _cls = " ".join(classification or [])',
            '    try:',
            '        if "riccati" in _cls and _mu.startswith("Riccati"):',
            '            return',
            '        _M, _N, _ex = _infer_exact_from_rhs()',
            '        if _ex:',
            '            _true_exact_steps()',
            '            return',
            '        if "Bernoulli" in _cls or "Bernoulli" in _mu:',
            '            _bernoulli_steps()',
            '        elif "euler" in _cls or "euler" in _mu:',
            '            _euler_steps()',
            '        elif "variation_of_parameters" in _mu or "variation_of_parameters" in _cls:',
            '            _vop_steps()',
            '        elif _mu == "substitution v = y/x" or "homogeneous_coeff" in _cls:',
            '            _M, _N, _ex = _infer_exact_from_rhs()',
            '            if _ex:',
            '                _true_exact_steps()',
            '            else:',
            '                _homog_v_pedagogy_steps()',
            '        elif "1st_linear" in _mu or ("1st_linear" in _cls and not _can_separate()):',
            '            _linear_steps()',
            '        elif _mu == "separable" or (_can_separate() and "separable" in _cls):',
            '            _separable_steps()',
            '        elif "1st_exact" in _mu or "1st_exact" in _cls:',
            '            _true_exact_steps()',
            '        elif "nth_linear_constant_coeff_homogeneous" in _mu or (_mu == "factorable" and "nth_linear_constant_coeff_homogeneous" in _cls):',
            '            _const_coeff_homog_steps()',
            '        elif "undetermined_coefficients" in _mu:',
            '            _undetermined_coeff_steps()',
            '        elif _mu == "factorable" and "nth_linear_constant_coeff" in _cls:',
            '            _const_coeff_homog_steps()',
            '        else:',
            '            _M, _N, _ex = _infer_exact_from_rhs()',
            '            if _ex:',
            '                _true_exact_steps()',
            '    except Exception:',
            '        _pedagogy_steps = []',
            '',
        ].join('\n');
    }

    /**
     * SymPy ODE solver router: classify → bounded dsolve(hint) loop → manual
     * substitution fallback → scipy numerical IVP. Embedded in generated Python.
     * @param {{ x0: string, y0: string }} ic
     */
    function buildSympyOdeRouterPy(ic) {
        var x0 = (ic && ic.x0 != null && ic.x0 !== '') ? String(ic.x0) : '0';
        var y0 = (ic && ic.y0 != null && ic.y0 !== '') ? String(ic.y0) : '0';
        return [
            'import signal',
            '',
            'def _ode_alarm_handler(signum, frame):',
            '    raise TimeoutError("ODE solver timed out")',
            '',
            '_HINT_TIMEOUT = 6',
            '_SKIP_HINTS = {"lie_group", "1st_power_series", "2nd_power_series"}',
            '_SLOW_HINTS = {"1st_homogeneous_coeff_best", "1st_homogeneous_coeff_subs_indep_div_dep"}',
            '_PRIORITY_HINTS = (',
            '    "1st_homogeneous_coeff_subs_dep_div_indep",',
            '    "separable", "1st_exact", "1st_linear", "factorable",',
            '    "nth_linear_constant_coeff_homogeneous", "Bernoulli",',
            ')',
            '',
            'def _filter_hints(classification):',
            '    cls = list(classification or [])',
            '    seen = set()',
            '    ordered = []',
            '    for pref in _PRIORITY_HINTS:',
            '        if pref in cls and pref not in _SKIP_HINTS and pref not in _SLOW_HINTS:',
            '            seen.add(pref)',
            '            ordered.append(pref)',
            '    for h in cls:',
            '        if h in _SKIP_HINTS or h in _SLOW_HINTS or "Integral" in h or h.endswith("_best"):',
            '            continue',
            '        if h not in seen:',
            '            seen.add(h)',
            '            ordered.append(h)',
            '    for h in cls:',
            '        if h in _SKIP_HINTS or h in seen:',
            '            continue',
            '        if "Integral" in h:',
            '            continue',
            '        seen.add(h)',
            '        ordered.append(h)',
            '    return ordered[:6]',
            '',
            'def _with_alarm(seconds, fn):',
            '    try:',
            '        signal.signal(signal.SIGALRM, _ode_alarm_handler)',
            '        signal.alarm(int(seconds))',
            '        return fn()',
            '    finally:',
            '        signal.alarm(0)',
            '',
            'def _dsolve_hint(ode, func, hint, seconds=_HINT_TIMEOUT):',
            '    return _with_alarm(seconds, lambda: dsolve(ode, func, hint=hint))',
            '',
            'def _try_homogeneous_v_subs():',
            '    global sol, method_used, reduced_latex',
            '    v = Function("v")',
            '    rhs_v = rhs_expr.subs(y(x), v(x) * x)',
            '    ode_v = Eq(v(x) + x * Derivative(v(x), x), rhs_v)',
            '    reduced_latex = latex(ode_v)',
            '    sol_v = _dsolve_hint(ode_v, v(x), "separable")',
            '    sol = sol_v.subs(v(x), y(x) / x)',
            '    method_used = "substitution v = y/x"',
            '',
            'def _try_riccati_u_subs():',
            '    global sol, method_used, reduced_latex, analytical, numeric, _pedagogy_steps',
            '    u = Function("u")',
            '    sub_expr = -u(x).diff(x) / u(x)',
            '    dy_dx_sub = simplify(sub_expr.diff(x))',
            '    transformed = ode.subs({y(x).diff(x): dy_dx_sub, y(x): sub_expr})',
            '    linear_ode = Eq(simplify((transformed.lhs - transformed.rhs) * u(x)), 0)',
            '    reduced_latex = latex(linear_ode)',
            '    u_sol = _dsolve_hint(linear_ode, u(x), "2nd_power_series_ordinary")',
            '    u_expr = u_sol.rhs',
            '    y_expr = simplify(-u_expr.diff(x) / u_expr)',
            '    sol = Eq(y(x), y_expr)',
            '    method_used = "Riccati substitution y = -u\'/u"',
            '    analytical = True',
            '    numeric = False',
            '    _pedagogy_steps = [',
            '        {"title": "Substitution", "latex": "y(x) = -\\\\frac{u\'(x)}{u(x)}"},',
            '        {"title": "Substitute into ODE", "latex": latex(transformed)},',
            '        {"title": "Linear ODE in u", "latex": latex(linear_ode)},',
            '        {"title": "Solve for u(x)", "latex": latex(u_sol)},',
            '        {"title": "Back-substitute", "latex": latex(sol)},',
            '    ]',
            '',
            'sol = None',
            'method_used = None',
            'reduced_latex = None',
            '_pedagogy_steps = []',
            'analytical = True',
            'numeric = False',
            '_plot_x_num = []',
            '_plot_y_num = []',
            '',
            'try:',
            '    classification = classify_ode(ode, y(x))',
            '    cls_str = ", ".join(classification[:3]) if len(classification) > 3 else ", ".join(classification)',
            'except Exception:',
            '    classification = []',
            '    cls_str = "unknown"',
            '',
            'def _is_exact_rhs():',
            '    try:',
            '        _ys = Symbol("y")',
            '        _rhs_s = rhs_expr.subs(y(x), _ys)',
            '        _num, _den = fraction(together(_rhs_s))',
            '        return simplify(diff(-_num, _ys) - diff(_den, x)) == 0',
            '    except Exception:',
            '        return False',
            '',
            '# Fast path: exact equations before homogeneous substitution',
            'if sol is None and ("1st_exact" in cls_str or _is_exact_rhs()):',
            '    try:',
            '        sol = _dsolve_hint(ode, y(x), "1st_exact")',
            '        method_used = "1st_exact"',
            '    except Exception:',
            '        sol = None',
            '        method_used = None',
            '',
            '# Fast path: explicit substitution before slow hinted dsolve attempts',
            'if any("homogeneous_coeff" in str(h) for h in classification):',
            '    try:',
            '        _try_homogeneous_v_subs()',
            '    except Exception:',
            '        sol = None',
            '        method_used = None',
            '        reduced_latex = None',
            '',
            'if sol is None and any("riccati" in str(h) for h in classification):',
            '    try:',
            '        _try_riccati_u_subs()',
            '    except Exception:',
            '        sol = None',
            '        method_used = None',
            '        reduced_latex = None',
            '',
            'if sol is None:',
            '    for hint in _filter_hints(classification):',
            '        try:',
            '            sol = _dsolve_hint(ode, y(x), hint)',
            '            method_used = hint',
            '            break',
            '        except TimeoutError:',
            '            continue',
            '        except Exception:',
            '            continue',
            '',
            'if sol is None and any("homogeneous_coeff" in str(h) for h in classification):',
            '    try:',
            '        _try_homogeneous_v_subs()',
            '    except Exception:',
            '        pass',
            '',
            'if sol is None:',
            '    try:',
            '        from scipy.integrate import solve_ivp',
            '        from sympy import lambdify as _lambdify, Symbol as _Symbol',
            '        analytical = False',
            '        numeric = True',
            '        _x0 = float(' + x0 + ')',
            '        _y0 = float(' + y0 + ')',
            '        _yv = _Symbol("_yv")',
            '        _f = _lambdify((x, _yv), rhs_expr.subs(y(x), _yv), modules=["numpy"])',
            '        def _rhs(_t, _s):',
            '            return [_f(_t, _s[0])]',
            '        _iv = solve_ivp(_rhs, (_x0, _x0 + 8), [_y0], dense_output=True, max_step=0.08, rtol=1e-6)',
            '        _x_plot = np.linspace(_x0, _x0 + 8, 300)',
            '        _y_plot = np.clip(_iv.sol(_x_plot)[0], -50, 50)',
            '        _plot_x_num = _x_plot.tolist()',
            '        _plot_y_num = _y_plot.tolist()',
            '        method_used = "numerical (scipy solve_ivp)"',
            '    except Exception:',
            '        pass',
            '',
            'if sol is None and not numeric:',
            '    print("ERROR:No closed-form solution found for this ODE.")',
            '    import sys',
            '    sys.exit(0)',
            '',
        ].join('\n');
    }

    /** Apply first-order IC; handles list/branch solutions from dsolve. */
    function buildSympyFirstOrderIcPy(x0, y0) {
        return [
            'if analytical and sol is not None:',
            '    try:',
            '        C1 = symbols("C1")',
            '        _x0v = ' + x0 + '',
            '        _y0v = ' + y0 + '',
            '        _branches = []',
            '        if isinstance(sol, list):',
            '            _branches = list(sol)',
            '        elif isinstance(sol, Eq):',
            '            if isinstance(sol.rhs, (list, tuple, Set)):',
            '                _branches = [Eq(y(x), b) for b in sol.rhs]',
            '            else:',
            '                _branches = [sol]',
            '        else:',
            '            _branches = [Eq(y(x), sol)]',
            '        _picked = None',
            '        for _br in _branches:',
            '            _rhsb = _br.rhs if hasattr(_br, "rhs") else _br',
            '            if C1 not in _rhsb.free_symbols:',
            '                if abs(float(_rhsb.subs(x, _x0v)) - float(_y0v)) < 1e-6:',
            '                    _picked = Eq(y(x), _rhsb)',
            '                    break',
            '                continue',
            '            _c1 = solve(_rhsb.subs(x, _x0v) - _y0v, C1)',
            '            if not _c1:',
            '                continue',
            '            _cval = _c1[0]',
            '            if _cval.is_real is False:',
            '                continue',
            '            try:',
            '                if _cval.is_real and float(_cval) < 0 and _rhsb.has(sqrt):',
            '                    continue',
            '            except Exception:',
            '                pass',
            '            _picked = Eq(y(x), _rhsb.subs(C1, _cval))',
            '            break',
            '        if _picked is not None:',
            '            sol = _picked',
            '        elif _branches:',
            '            _br = _branches[-1]',
            '            _rhsb = _br.rhs if hasattr(_br, "rhs") else _br',
            '            if C1 in _rhsb.free_symbols:',
            '                _c1 = solve(_rhsb.subs(x, _x0v) - _y0v, C1)',
            '                if _c1:',
            '                    sol = Eq(y(x), _rhsb.subs(C1, _c1[0]))',
            '    except Exception:',
            '        pass',
            '',
        ].join('\n');
    }

    /** Apply two-point BVP on second-order solutions: y(x0)=y0, y(x1)=y1. */
    function buildSympyBvpPy(bvp) {
        if (!bvp || !bvp.has) return '';
        var x0 = (bvp.x0 != null && bvp.x0 !== '') ? String(bvp.x0) : '0';
        var x1 = (bvp.x1 != null && bvp.x1 !== '') ? String(bvp.x1) : '1';
        var y0 = (bvp.y0 != null && bvp.y0 !== '') ? String(bvp.y0) : '0';
        var y1 = (bvp.y1 != null && bvp.y1 !== '') ? String(bvp.y1) : '0';
        return [
            'if analytical and sol is not None:',
            '    try:',
            '        C1, C2 = symbols("C1 C2")',
            '        _rhs = sol.rhs if hasattr(sol, "rhs") else sol',
            '        _eqs = [',
            '            _rhs.subs(x, ' + x0 + ') - ' + y0 + ',',
            '            _rhs.subs(x, ' + x1 + ') - ' + y1 + ',',
            '        ]',
            '        _consts = solve(_eqs, [C1, C2])',
            '        if _consts:',
            '            sol = Eq(y(x), _rhs.subs(_consts))',
            '    except Exception:',
            '        pass',
            '',
        ].join('\n');
    }

    /** Shared output + plot tail for first/second order modes. */
    function buildSympyOdeOutputPy(opts) {
        var hasIC = !!opts.hasIC;
        var x0 = opts.x0 || '0';
        var y0 = opts.y0 || '0';
        var orderLine = opts.order ? ('print("ORDER:' + opts.order + '")\n') : '';
        var icStep = hasIC
            ? ('steps.append({"title": "Initial condition", "latex": "y(' + x0 + ') = ' + y0 + '"})\n')
            : '';
        var icSteps2 = opts.icSteps2 || '';
        var nConst = parseInt(opts.plotConstCount, 10) || 1;
        var plotConstLines = [];
        if (nConst > 1) {
            var cDecl = [];
            for (var pc = 1; pc <= nConst; pc++) cDecl.push('C' + pc);
            plotConstLines.push('        ' + cDecl.join(', ') + ' = symbols("' + cDecl.join(' ') + '")');
            for (var pj = 0; pj < nConst; pj++) {
                var cName = 'C' + (pj + 1);
                var defVal = pj === 0 ? '1' : '0';
                plotConstLines.push('        if ' + cName + ' in sol_rhs.free_symbols:');
                plotConstLines.push('            sol_rhs = sol_rhs.subs(' + cName + ', ' + defVal + ')');
            }
        } else {
            plotConstLines.push('        C1 = symbols("C1")');
            plotConstLines.push('        if C1 in sol_rhs.free_symbols:');
            plotConstLines.push('            sol_rhs = sol_rhs.subs(C1, 1)');
        }

        return [
            'try:',
            '    def _verify_solution(_ode, _sol):',
            '        if isinstance(_sol, list):',
            '            _checks = [_with_alarm(4, lambda s=_s: checkodesol(_ode, s)) for _s in _sol]',
            '            return all(c[0] if isinstance(c, tuple) else c for c in _checks)',
            '        _chk = _with_alarm(4, lambda: checkodesol(_ode, _sol))',
            '        return _chk[0] if isinstance(_chk, tuple) else _chk',
            '    if analytical and sol is not None:',
            '        verified = _verify_solution(ode, sol)',
            '    else:',
            '        verified = False',
            'except Exception:',
            '    verified = False',
            '',
            'if analytical and sol is not None:',
            '    print("RESULT:" + latex(sol))',
            '    print("TEXT:" + str(sol))',
            'else:',
            '    print("RESULT:\\\\text{Numerical solution (no closed form)}")',
            '    print("TEXT:Numerical solution via scipy.integrate.solve_ivp")',
            'print("CLASSIFY:" + cls_str)',
            'print("METHOD:" + (method_used or ""))',
            'print("VERIFIED:" + str(verified))',
            'print("ANALYTICAL:" + str(analytical))',
            'print("NUMERIC:" + str(numeric))',
            'print("ODE:" + latex(ode))',
            orderLine,
            'steps = []',
            'steps.append({"title": "Given ODE", "latex": latex(ode)})',
            'steps.append({"title": "Classification", "latex": "\\\\text{" + cls_str.replace("_", " ") + "}"})',
            '_build_pedagogy_steps()',
            '_skip_final = False',
            'if _pedagogy_steps:',
            '    _skip_final = any(s.get("title") in ("Back-substitute", "Back-substitute y = vx") for s in _pedagogy_steps)',
            '    _meth = str(method_used or "").replace("_", " ")',
            '    if _meth:',
            '        steps.append({"title": "Method", "latex": "\\\\text{" + _meth + "}"})',
            '    steps.extend(_pedagogy_steps)',
            'elif method_used:',
            '    steps.append({"title": "Method", "latex": "\\\\text{" + str(method_used).replace("_", " ") + "}"})',
            '    if reduced_latex:',
            '        steps.append({"title": "After substitution", "latex": reduced_latex})',
            icStep,
            icSteps2,
            'if analytical and sol is not None and not _skip_final:',
            '    steps.append({"title": "Solution", "latex": latex(sol)})',
            'elif numeric:',
            '    steps.append({"title": "Solution", "latex": "\\\\text{Numerical IVP solution (see plot)}"})',
            'steps.append({"title": "Verification", "latex": "\\\\text{Verified: " + ("True" if verified else "False") + "}"})',
            'print("STEPS:" + json.dumps(steps))',
            '',
            'try:',
            '    from sympy import lambdify',
            '    if numeric and _plot_x_num:',
            '        print("PLOT_X:" + json.dumps(_plot_x_num))',
            '        print("PLOT_Y:" + json.dumps(_plot_y_num))',
            '    elif analytical and sol is not None:',
            '        sol_rhs = sol.rhs if hasattr(sol, "rhs") else sol',
            plotConstLines.join('\n'),
            '        f_num = lambdify(x, sol_rhs, modules=["numpy"])',
            '        x_vals = np.linspace(-5, 5, 300)',
            '        y_vals = np.array([float(f_num(xi)) if np.isfinite(f_num(xi)) else float("nan") for xi in x_vals])',
            '        y_vals = np.clip(y_vals, -50, 50)',
            '        mask = np.isfinite(y_vals)',
            '        print("PLOT_X:" + json.dumps(x_vals[mask].tolist()))',
            '        print("PLOT_Y:" + json.dumps(y_vals[mask].tolist()))',
            '    else:',
            '        print("PLOT_X:[]")',
            '        print("PLOT_Y:[]")',
            'except Exception:',
            '    print("PLOT_X:[]")',
            '    print("PLOT_Y:[]")',
        ].join('\n');
    }

    // ── SymPy program generation (ported from the page's buildSympyCode) ─────

    /**
     * @param {object} spec
     * @param {'first'|'second'|'field'} spec.mode
     * @param {number} [spec.order]            highest derivative order (second mode, 2–5)
     * @param {string} spec.rhs                raw RHS string (UI/ASCII; normalized here)
     * @param {object} [spec.ic]               { has, x0, y0, dy0, extra:[v2,v3,…] }
     * @param {object} [spec.bvp]            { has, x0, x1, y0, y1 } two-point BVP (second mode)
     * @param {object} [spec.field]            { xmin,xmax,ymin,ymax, curve:{has,x0,y0} }
     * @returns {string} executable SymPy program
     */
    function buildSympyCode(spec) {
        var mode = spec.mode;
        var code = 'from sympy import *\nimport json, numpy as np\n\n';
        code += 'x = symbols("x")\n';
        code += 'y = Function("y")\n\n';

        if (mode === 'first') {
            var rhs = prepareOdeRhs(spec.rhs, 1);
            var ic = spec.ic || {};
            var hasIC = !!ic.has;
            var x0 = (ic.x0 != null && ic.x0 !== '') ? ic.x0 : '0';
            var y0 = (ic.y0 != null && ic.y0 !== '') ? ic.y0 : '0';

            code += '_ns = {"x": x, "y": y(x), "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "sinh": sinh, "cosh": cosh, "tanh": tanh, "Abs": Abs}\n';
            code += 'rhs_expr = eval("' + pyEscape(rhs) + '", {"__builtins__": {}}, _ns)\n';
            code += 'ode = Eq(y(x).diff(x), rhs_expr)\n\n';

            code += buildSympyOdeRouterPy({ x0: x0, y0: y0 }) + '\n';

            if (hasIC) {
                code += buildSympyFirstOrderIcPy(x0, y0);
            }

            code += buildSympyPedagogyStepsPy() + '\n';
            code += buildSympyOdeOutputPy({ hasIC: hasIC, x0: x0, y0: y0 }) + '\n';

        } else if (mode === 'second') {
            var n = parseInt(spec.order, 10) || 2;
            var rhs2 = prepareOdeRhs(spec.rhs, n);
            var ic2 = spec.ic || {};
            var bvp = spec.bvp || {};
            var hasBvp = !!bvp.has;
            var hasIC2 = !!ic2.has && !hasBvp;
            var sx0 = (ic2.x0 != null && ic2.x0 !== '') ? ic2.x0 : '0';
            var sy0 = (ic2.y0 != null && ic2.y0 !== '') ? ic2.y0 : '0';
            var dy0 = (ic2.dy0 != null && ic2.dy0 !== '') ? ic2.dy0 : '0';
            var extra = Array.isArray(ic2.extra) ? ic2.extra : [];
            var extraAt = function (i) { var v = extra[i - 2]; return (v != null && v !== '') ? v : '0'; };

            var nsEntries = '"x": x, "y": y(x), "yp": y(x).diff(x)';
            if (n >= 2) nsEntries += ', "ypp": y(x).diff(x, 2)';
            if (n >= 3) nsEntries += ', "yppp": y(x).diff(x, 3)';
            if (n >= 4) nsEntries += ', "y4": y(x).diff(x, 4)';
            if (n >= 5) nsEntries += ', "y5": y(x).diff(x, 5)';
            nsEntries += ', "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "sinh": sinh, "cosh": cosh, "tanh": tanh, "Abs": Abs';
            code += '_ns = {' + nsEntries + '}\n';
            code += 'rhs_expr = eval("' + pyEscape(rhs2) + '", {"__builtins__": {}}, _ns)\n';
            code += 'ode = Eq(y(x).diff(x, ' + n + '), rhs_expr)\n\n';

            code += buildSympyOdeRouterPy({ x0: sx0, y0: sy0 }) + '\n';

            if (hasBvp) {
                code += buildSympyBvpPy(bvp);
            } else if (hasIC2) {
                var cSyms = [];
                for (var ci = 1; ci <= n; ci++) cSyms.push('C' + ci);
                code += 'if analytical and sol is not None:\n';
                code += '    try:\n';
                code += '        ' + cSyms.join(', ') + ' = symbols("' + cSyms.join(' ') + '")\n';
                code += '        eq_ic = []\n';
                code += '        eq_ic.append(sol.rhs.subs(x, ' + sx0 + ') - ' + sy0 + ')\n';
                code += '        eq_ic.append(diff(sol.rhs, x).subs(x, ' + sx0 + ') - ' + dy0 + ')\n';
                for (var i2 = 2; i2 < n; i2++) {
                    code += '        eq_ic.append(diff(sol.rhs, x, ' + i2 + ').subs(x, ' + sx0 + ') - ' + extraAt(i2) + ')\n';
                }
                code += '        consts = solve(eq_ic, [' + cSyms.join(', ') + '])\n';
                code += '        if consts:\n';
                code += '            sol = Eq(y(x), sol.rhs.subs(consts))\n';
                code += '    except Exception:\n';
                code += '        pass\n\n';
            }

            var icLatexParts = ['y(' + sx0 + ') = ' + sy0, "y\\'(" + sx0 + ') = ' + dy0];
            for (var i3 = 2; i3 < n; i3++) {
                var val3 = extraAt(i3);
                if (i3 === 2) icLatexParts.push("y\\'\\'(" + sx0 + ') = ' + val3);
                else if (i3 === 3) icLatexParts.push("y\\'\\'\\'(" + sx0 + ') = ' + val3);
                else icLatexParts.push('y^{(' + i3 + ')}(' + sx0 + ') = ' + val3);
            }
            var icSteps2Line = '';
            if (hasBvp) {
                var bx0 = (bvp.x0 != null && bvp.x0 !== '') ? bvp.x0 : '0';
                var bx1 = (bvp.x1 != null && bvp.x1 !== '') ? bvp.x1 : '1';
                var by0 = (bvp.y0 != null && bvp.y0 !== '') ? bvp.y0 : '0';
                var by1 = (bvp.y1 != null && bvp.y1 !== '') ? bvp.y1 : '0';
                icSteps2Line = 'steps.append({"title": "Boundary conditions", "latex": "y(' + bx0 + ') = ' + by0 + ',\\\\; y(' + bx1 + ') = ' + by1 + '"})\n';
            } else if (hasIC2) {
                icSteps2Line = ('steps.append({"title": "Initial conditions", "latex": "' + icLatexParts.join(',\\\\; ') + '"})\n');
            }

            code += buildSympyPedagogyStepsPy() + '\n';
            code += buildSympyOdeOutputPy({
                hasIC: false,
                order: n,
                icSteps2: icSteps2Line,
                plotConstCount: n,
            }) + '\n';

        } else {
            var f = spec.field || {};
            var rhsF = prepareOdeRhs(spec.rhs, 1);
            var xmin = parseFloat(f.xmin); if (!isFinite(xmin)) xmin = -5;
            var xmax = parseFloat(f.xmax); if (!isFinite(xmax)) xmax = 5;
            var ymin = parseFloat(f.ymin); if (!isFinite(ymin)) ymin = -5;
            var ymax = parseFloat(f.ymax); if (!isFinite(ymax)) ymax = 5;
            var curve = f.curve || {};
            var hasCurve = !!curve.has;
            var cx0 = (curve.x0 != null && curve.x0 !== '') ? curve.x0 : '0';
            var cy0 = (curve.y0 != null && curve.y0 !== '') ? curve.y0 : '0';

            code += 'from sympy import Symbol\n';
            code += 'y_sym = Symbol("y")\n';
            code += '_ns = {"x": x, "y": y_sym, "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "Abs": Abs}\n';
            code += 'rhs_expr = eval("' + pyEscape(rhsF) + '", {"__builtins__": {}}, _ns)\n\n';

            code += 'f_num = lambdify((x, y_sym), rhs_expr, modules=["numpy"])\n\n';

            code += 'N = 20\n';
            code += 'x_grid = np.linspace(' + xmin + ', ' + xmax + ', N)\n';
            code += 'y_grid = np.linspace(' + ymin + ', ' + ymax + ', N)\n';
            code += 'X, Y = np.meshgrid(x_grid, y_grid)\n';
            code += 'try:\n';
            code += '    U = np.ones_like(X)\n';
            code += '    V = np.vectorize(lambda xi, yi: float(f_num(xi, yi)))(X, Y)\n';
            code += '    mag = np.sqrt(U**2 + V**2)\n';
            code += '    mag[mag == 0] = 1\n';
            code += '    U = U / mag\n';
            code += '    V = V / mag\n';
            code += '    V = np.clip(V, -10, 10)\n';
            code += '    U = np.clip(U, -10, 10)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';

            code += 'print("FIELD_X:" + json.dumps(X.flatten().tolist()))\n';
            code += 'print("FIELD_Y:" + json.dumps(Y.flatten().tolist()))\n';
            code += 'print("FIELD_U:" + json.dumps(U.flatten().tolist()))\n';
            code += 'print("FIELD_V:" + json.dumps(V.flatten().tolist()))\n';

            if (hasCurve) {
                code += '\n# Solution curve via Euler method\n';
                code += 'try:\n';
                code += '    cx0, cy0 = ' + cx0 + ', ' + cy0 + '\n';
                code += '    dt = 0.05\n';
                code += '    curve_x, curve_y = [cx0], [cy0]\n';
                code += '    xc, yc = cx0, cy0\n';
                code += '    for _ in range(200):\n';
                code += '        try:\n';
                code += '            s = float(f_num(xc, yc))\n';
                code += '            if not np.isfinite(s) or abs(s) > 1e6: break\n';
                code += '        except: break\n';
                code += '        xc += dt\n';
                code += '        yc += dt * s\n';
                code += '        if abs(yc) > 50 or xc > ' + xmax + ': break\n';
                code += '        curve_x.append(xc)\n';
                code += '        curve_y.append(yc)\n';
                code += '    xc, yc = cx0, cy0\n';
                code += '    bx, by = [], []\n';
                code += '    for _ in range(200):\n';
                code += '        try:\n';
                code += '            s = float(f_num(xc, yc))\n';
                code += '            if not np.isfinite(s) or abs(s) > 1e6: break\n';
                code += '        except: break\n';
                code += '        xc -= dt\n';
                code += '        yc -= dt * s\n';
                code += '        if abs(yc) > 50 or xc < ' + xmin + ': break\n';
                code += '        bx.insert(0, xc)\n';
                code += '        by.insert(0, yc)\n';
                code += '    curve_x = bx + curve_x\n';
                code += '    curve_y = by + curve_y\n';
                code += '    print("CURVE_X:" + json.dumps(curve_x))\n';
                code += '    print("CURVE_Y:" + json.dumps(curve_y))\n';
                code += 'except Exception as e:\n';
                code += '    pass\n';
            }

            code += '\nprint("RESULT:Direction field computed")\n';
            code += 'print("TEXT:dy/dx = ' + pyEscape(rhsF) + '")\n';
        }
        return code;
    }

    // ── stdout parsing (ported from the page's parseAndShowResult) ────────────

    function jsonArr(stdout, key) {
        var m = stdout.match(new RegExp(key + ':(\\[[\\s\\S]*?\\])(?=\\n|$)'));
        if (!m) return [];
        try { return JSON.parse(m[1]); } catch (e) { return []; }
    }

    function line(stdout, key) {
        var m = stdout.match(new RegExp(key + ':([^\\n]*)'));
        return m ? m[1].trim() : '';
    }

    function parseStepsJson(stdout) {
        var idx = stdout.indexOf('STEPS:');
        if (idx === -1) return [];
        var start = idx + 6;
        if (stdout.charAt(start) !== '[') return [];
        var depth = 0;
        var inStr = false;
        var esc = false;
        for (var i = start; i < stdout.length; i++) {
            var c = stdout.charAt(i);
            if (esc) { esc = false; continue; }
            if (c === '\\' && inStr) { esc = true; continue; }
            if (c === '"') { inStr = !inStr; continue; }
            if (!inStr) {
                if (c === '[') depth++;
                else if (c === ']') {
                    depth--;
                    if (depth === 0) {
                        try { return JSON.parse(stdout.slice(start, i + 1)); } catch (e) { return []; }
                    }
                }
            }
        }
        return [];
    }

    function parseVerified(stdout) {
        var raw = line(stdout, 'VERIFIED');
        if (raw === 'True' || raw === 'False') return raw === 'True';
        if (/^\(True,\s*\d+\)$/.test(raw)) return true;
        if (/^\(False,\s*\d+\)$/.test(raw)) return false;
        if (/^\[\(True,\s*\d+\)/.test(raw)) return true;
        return false;
    }

    /**
     * @param {'first'|'second'|'field'} mode
     * @param {string} stdout
     */
    function parseResult(mode, stdout) {
        stdout = String(stdout || '').trim();

        var errMatch = stdout.match(/ERROR:(.+)/);
        if (errMatch) return { ok: false, error: errMatch[1].trim(), mode: mode };
        if (!stdout) return { ok: false, error: 'Computation failed. Check your input.', mode: mode };

        if (mode === 'field') {
            return {
                ok: true,
                mode: 'field',
                text: line(stdout, 'TEXT'),
                resultLatex: line(stdout, 'RESULT'),
                field: {
                    x: jsonArr(stdout, 'FIELD_X'),
                    y: jsonArr(stdout, 'FIELD_Y'),
                    u: jsonArr(stdout, 'FIELD_U'),
                    v: jsonArr(stdout, 'FIELD_V'),
                    curveX: jsonArr(stdout, 'CURVE_X'),
                    curveY: jsonArr(stdout, 'CURVE_Y'),
                },
            };
        }

        var steps = parseStepsJson(stdout);

        var result = line(stdout, 'RESULT');
        return {
            ok: true,
            mode: mode,
            resultLatex: result,
            text: line(stdout, 'TEXT') || result,
            classification: line(stdout, 'CLASSIFY'),
            method: line(stdout, 'METHOD'),
            analytical: line(stdout, 'ANALYTICAL') !== 'False',
            numeric: line(stdout, 'NUMERIC') === 'True',
            verified: parseVerified(stdout),
            odeLatex: line(stdout, 'ODE'),
            order: parseInt(line(stdout, 'ORDER'), 10) || (mode === 'second' ? 2 : 1),
            steps: steps,
            plotX: jsonArr(stdout, 'PLOT_X'),
            plotY: jsonArr(stdout, 'PLOT_Y'),
        };
    }

    // ── OneCompiler round-trip (same endpoint the page hits) ──────────────────

    function resolveCtx(opts) {
        if (opts && opts.ctx != null) return opts.ctx;
        if (typeof window !== 'undefined') {
            if (window.ODE_CALC_CTX != null) return window.ODE_CALC_CTX;
            var meta = document.querySelector && document.querySelector('meta[name="ctx"]');
            if (meta && meta.content != null) return meta.content;
        }
        return '';
    }

    /**
     * Build → execute (OneCompiler / SymPy) → parse. Returns the same structured
     * object the page renders from.
     * @param {object} spec  see buildSympyCode
     * @param {object} [opts] { ctx, timeoutMs, signal }
     */
    function solve(spec, opts) {
        opts = opts || {};
        if (typeof fetch === 'undefined') {
            return Promise.resolve({ ok: false, error: 'Network unavailable for the ODE engine.', mode: spec && spec.mode });
        }
        var code = buildSympyCode(spec);
        var ctx = resolveCtx(opts);

        var controller = (typeof AbortController !== 'undefined') ? new AbortController() : null;
        var signal = opts.signal || (controller ? controller.signal : undefined);
        var timeoutId = controller ? setTimeout(function () { controller.abort(); }, opts.timeoutMs || 40000) : null;

        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: signal,
        })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (timeoutId) clearTimeout(timeoutId);
                var stdout = (data.Stdout || data.stdout || '').trim();
                var stderr = (data.Stderr || data.stderr || '').trim();
                if (!stdout && stderr) return { ok: false, error: stderr, mode: spec.mode };
                return parseResult(spec.mode, stdout);
            })
            .catch(function (err) {
                if (timeoutId) clearTimeout(timeoutId);
                return {
                    ok: false,
                    mode: spec.mode,
                    error: (err && err.name === 'AbortError') ? 'Request timed out' : (err && err.message ? err.message : String(err)),
                };
            });
    }

    /**
     * Convenience for the chat: map an extracted ODE task → spec → solve.
     * task = { rhs, order, ics:{x0,y0,dy0} }
     */
    function solveTask(task, opts) {
        var order = parseInt(task && task.order, 10) || 1;
        var ics = task && task.ics;
        var bvp = task && task.bvp;
        var spec = {
            mode: order >= 2 ? 'second' : 'first',
            order: order >= 2 ? order : undefined,
            rhs: task ? (task.rhs || task.expr || '') : '',
            ic: (bvp && bvp.has) ? { has: false } : (ics ? { has: true, x0: ics.x0, y0: ics.y0, dy0: ics.dy0, extra: ics.extra || [] } : { has: false }),
            bvp: (bvp && bvp.has) ? { has: true, x0: bvp.x0, x1: bvp.x1, y0: bvp.y0, y1: bvp.y1 } : { has: false },
        };
        return solve(spec, opts);
    }

    return {
        normalizeExpr: normalizeExpr,
        prepareOdeRhs: prepareOdeRhs,
        homogEquationToRhs: homogEquationToRhs,
        exprToPython: exprToPython,
        buildSympyCode: buildSympyCode,
        parseResult: parseResult,
        solve: solve,
        solveTask: solveTask,
    };
})();

if (typeof window !== 'undefined') window.ODECalculatorCore = ODECalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = ODECalculatorCore;
