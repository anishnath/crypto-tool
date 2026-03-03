"""
Derivative Question Bank Generator — Full Curriculum Coverage (40 types)
Answers verified by SymPy where applicable.

Basic (8 types):
    power_rule, constant_multiple, sum_difference,
    basic_trig, basic_exponential, basic_logarithmic,
    definition_of_derivative, derivative_interpretation

Medium (10 types):
    product_rule, quotient_rule, chain_rule_basic, chain_rule_trig,
    chain_rule_exponential, inverse_trig, hyperbolic, higher_order,
    tangent_line_eq, normal_line_eq

Hard (18 types):
    implicit_differentiation, logarithmic_differentiation,
    related_rates_setup, linear_approximation, critical_points,
    mean_value_theorem, lhopital_derivative, parametric_derivative,
    piecewise_differentiability, chain_rule_nested,
    rates_of_change, min_max_values, absolute_extrema,
    increasing_decreasing, concavity_inflection, optimization,
    differentials, newtons_method

Scholar (4 types):
    nth_derivative_pattern, inverse_function_derivative,
    vector_derivative, taylor_coefficient
"""

import sympy as sp
import json
import random
import os
import sys

# Figure generation (optional — gracefully degrades if matplotlib unavailable)
_fig_gen_available = False
_fig_gen = None
_FIGURE_TYPES_DERIVATIVES = set()
_figures_dir_derivatives = ""
try:
    import worksheet_figure_gen as _fig_gen
    _FIGURE_TYPES_DERIVATIVES = _fig_gen.FIGURE_TYPES_DERIVATIVES
    _figures_dir_derivatives = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "calculus",
        "figures", "derivatives")
    _fig_gen_available = True
    print("Figure generation enabled.")
except (ImportError, AttributeError):
    print("worksheet_figure_gen not available — skipping figure generation.")

x, t, y = sp.symbols('x t y')

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def rc(pool):
    return random.choice(pool)

NZ  = [-4, -3, -2, -1, 1, 2, 3, 4]
POS = [1, 2, 3, 4, 5]
SML = [-2, -1, 1, 2]
FRAC_EXP = [sp.Rational(1,2), sp.Rational(1,3), sp.Rational(2,3),
            sp.Rational(3,2), sp.Rational(-1,2), sp.Rational(-1,3)]

def safe_diff(expr, var=x, n=1):
    try:
        r = sp.diff(expr, var, n)
        if r.has(sp.zoo, sp.nan, sp.oo, sp.I):
            return None
        return r
    except Exception:
        return None

def fmt_ans(expr):
    lat = sp.latex(expr)
    return lat, str(expr)

def clean_latex(s):
    return s.replace(r"y{\left(x \right)}", "y").replace(r"\left(x\right)", "(x)")


# ===========================================================================
# BASIC GENERATORS (6 types)
# ===========================================================================

def gen_power_rule():
    """d/dx(c*x^n), integer and rational exponents."""
    c = rc(NZ)
    use_frac = random.random() < 0.35
    if use_frac:
        n = rc(FRAC_EXP)
    else:
        n = rc([-3, -2, -1, 2, 3, 4, 5, 6])
    f = c * x**n
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "power_rule",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_constant_multiple():
    """d/dx(c*f(x)) for basic trig/exp."""
    c = rc(NZ)
    a = rc(SML)
    base_funcs = [
        (sp.sin(a*x), "trig"),
        (sp.cos(a*x), "trig"),
        (sp.exp(a*x), "exp"),
        (sp.tan(x), "trig"),
    ]
    bf, _ = rc(base_funcs)
    f = c * bf
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "constant_multiple",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_sum_difference():
    """d/dx(f ± g ± h), 3–4 simple terms."""
    num_terms = rc([3, 4])
    terms = []
    for _ in range(num_terms):
        c = rc(NZ)
        n = rc([1, 2, 3, 4, 5])
        terms.append(c * x**n)
    f = sum(terms)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.expand(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "sum_difference",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_basic_trig():
    """d/dx(sin/cos/tan/sec/csc/cot)."""
    a = rc(SML)
    trig_fns = [sp.sin, sp.cos, sp.tan, sp.sec, sp.csc, sp.cot]
    fn = rc(trig_fns)
    f = fn(a * x)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "basic_trig",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_basic_exponential():
    """d/dx(e^(ax)), d/dx(a^x)."""
    a = rc(SML)
    if random.random() < 0.6:
        f = sp.exp(a * x)
    else:
        base = rc([2, 3, 5, 10])
        f = base**x
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "basic_exponential",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_basic_logarithmic():
    """d/dx(ln(ax)), d/dx(log_a(x))."""
    a = rc([2, 3, 4, 5])
    if random.random() < 0.5:
        f = sp.log(a * x)
    else:
        base = rc([2, 3, 5, 10])
        f = sp.log(x, base)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "basic_logarithmic",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_definition_of_derivative():
    """Compute f'(a) using the limit definition: lim(h->0)[f(a+h)-f(a)]/h."""
    h = sp.Symbol('h')
    c = rc(NZ)
    n = rc([2, 3])
    f = c * x**n + rc(NZ) * x + rc(NZ)
    a_val = rc([-2, -1, 0, 1, 2, 3])
    d = safe_diff(f)
    if d is None:
        return None
    try:
        ans_val = sp.simplify(d.subs(x, a_val))
        if not ans_val.is_finite:
            return None
    except Exception:
        return None
    ans_latex, ans_plain = fmt_ans(ans_val)
    f_latex = sp.latex(f)
    q_text = (f"Using the limit definition of the derivative, find "
              f"\\( f'({a_val}) \\) for \\( f(x) = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "definition_of_derivative",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_derivative_interpretation():
    """Word-problem framing: velocity at a time, or slope of tangent."""
    c = rc(NZ)
    n = rc([2, 3])
    a_val = rc([1, 2, 3, 4])
    variant = rc(["velocity", "slope"])
    if variant == "velocity":
        f = c * t**n + rc(NZ) * t + rc(NZ)
        d = safe_diff(f, t)
        if d is None:
            return None
        try:
            ans_val = sp.simplify(d.subs(t, a_val))
            if not ans_val.is_finite:
                return None
        except Exception:
            return None
        ans_latex, ans_plain = fmt_ans(ans_val)
        f_latex = sp.latex(f)
        q_text = (f"A particle moves along a line with position "
                  f"\\( s(t) = {f_latex} \\). "
                  f"Find the instantaneous velocity at \\( t = {a_val} \\)")
        return {"q_text": q_text, "f": f, "a": a_val,
                "type": "derivative_interpretation",
                "dir": "+-", "var": t, "ans_latex": ans_latex, "ans_plain": ans_plain}
    else:
        f = c * x**n + rc(NZ) * x + rc(NZ)
        d = safe_diff(f)
        if d is None:
            return None
        try:
            ans_val = sp.simplify(d.subs(x, a_val))
            if not ans_val.is_finite:
                return None
        except Exception:
            return None
        ans_latex, ans_plain = fmt_ans(ans_val)
        f_latex = sp.latex(f)
        q_text = (f"Find the slope of the tangent line to "
                  f"\\( f(x) = {f_latex} \\) at \\( x = {a_val} \\)")
        return {"q_text": q_text, "f": f, "a": a_val,
                "type": "derivative_interpretation",
                "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


# ===========================================================================
# MEDIUM GENERATORS (10 types)
# ===========================================================================

def gen_product_rule():
    """d/dx(f·g), two non-trivial factors."""
    a, b = rc(NZ), rc(NZ)
    n = rc([2, 3])
    factor_pairs = [
        (a*x**n, sp.sin(b*x)),
        (a*x**n, sp.exp(b*x)),
        (a*x**n, sp.log(x)),
        (sp.sin(a*x), sp.cos(b*x)),
        (sp.exp(a*x), sp.sin(b*x)),
        (a*x**n, sp.cos(b*x)),
    ]
    f1, f2 = rc(factor_pairs)
    f = f1 * f2
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "product_rule",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_quotient_rule():
    """d/dx(f/g), rational combos."""
    a, b = rc(NZ), rc(NZ)
    n = rc([2, 3])
    pairs = [
        (a*x**n, x + b),
        (sp.sin(a*x), x**n + b),
        (a*x + 1, sp.cos(x) + 2),
        (sp.exp(a*x), x**2 + 1),
        (x**2 + a*x, x**n + b),
    ]
    num, den = rc(pairs)
    f = num / den
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "quotient_rule",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_chain_rule_basic():
    """d/dx((g(x))^n), polynomial inside power."""
    a, b = rc(NZ), rc(NZ)
    n = rc([2, 3, 4, 5])
    inner = a*x + b
    if random.random() < 0.4:
        inner = x**2 + a*x + b
    f = inner**n
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.expand(d) if n <= 3 else sp.factor(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "chain_rule_basic",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_chain_rule_trig():
    """d/dx(trig(g(x)))."""
    a, b = rc(NZ), rc(SML)
    n = rc([2, 3])
    inner_fns = [a*x**n, a*x**2 + b*x, a*x + b]
    inner = rc(inner_fns)
    trig = rc([sp.sin, sp.cos, sp.tan])
    f = trig(inner)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "chain_rule_trig",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_chain_rule_exponential():
    """d/dx(e^{g(x)})."""
    a, b = rc(NZ), rc(SML)
    inner_fns = [a*x**2, a*x**2 + b*x, a*sp.sin(x), a*x + b*x**2]
    inner = rc(inner_fns)
    f = sp.exp(inner)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "chain_rule_exponential",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_inverse_trig():
    """d/dx(arcsin/arccos/arctan(g(x)))."""
    a = rc(SML)
    inv_fns = [sp.asin, sp.acos, sp.atan]
    fn = rc(inv_fns)
    inner_opts = [a*x, x**2, a*x**2]
    inner = rc(inner_opts)
    f = fn(inner)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "inverse_trig",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_hyperbolic():
    """d/dx(sinh/cosh/tanh(g(x)))."""
    a = rc(SML)
    hyp_fns = [sp.sinh, sp.cosh, sp.tanh]
    fn = rc(hyp_fns)
    inner_opts = [a*x, x**2, a*x**2, a*x + 1]
    inner = rc(inner_opts)
    f = fn(inner)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "hyperbolic",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_higher_order():
    """Find f''(x) or f'''(x)."""
    a, b, c_ = rc(NZ), rc(NZ), rc(NZ)
    order = rc([2, 3])
    f_opts = [
        a*x**5 + b*x**3 + c_*x,
        a*x**4 + b*x**2 + c_,
        a*sp.sin(b*x),
        a*sp.exp(b*x),
        a*x**3 * sp.sin(x),
    ]
    f = rc(f_opts)
    d = safe_diff(f, x, order)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    order_str = {2: "second", 3: "third"}[order]
    f_latex = sp.latex(f)
    q_text = (f"Find the {order_str} derivative of "
              f"\\( f(x) = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": None, "type": "higher_order",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_tangent_line_eq():
    """Find the equation of the tangent line at x = a."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    coeffs = [rc(NZ) for _ in range(rc([3, 4]))]
    f = sum(c * x**i for i, c in enumerate(coeffs))
    d = safe_diff(f)
    if d is None:
        return None
    try:
        f_a = f.subs(x, a_val)
        m = d.subs(x, a_val)
        if not f_a.is_finite or not m.is_finite:
            return None
    except Exception:
        return None
    tangent = m * (x - a_val) + f_a
    tangent = sp.expand(tangent)
    ans_latex = "y = " + sp.latex(tangent)
    ans_plain = "y = " + str(tangent)
    f_latex = sp.latex(f)
    q_text = (f"Find the equation of the tangent line to "
              f"\\( f(x) = {f_latex} \\) at \\( x = {a_val} \\)")
    return {"q_text": q_text, "f": f, "a": a_val, "type": "tangent_line_eq",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_normal_line_eq():
    """Find the equation of the normal line at x = a."""
    a_val = rc([-2, -1, 1, 2, 3])
    coeffs = [rc(NZ) for _ in range(rc([3, 4]))]
    f = sum(c * x**i for i, c in enumerate(coeffs))
    d = safe_diff(f)
    if d is None:
        return None
    try:
        f_a = f.subs(x, a_val)
        m = d.subs(x, a_val)
        if not f_a.is_finite or not m.is_finite or m == 0:
            return None
    except Exception:
        return None
    normal_slope = -1 / m
    normal = normal_slope * (x - a_val) + f_a
    normal = sp.simplify(normal)
    ans_latex = "y = " + sp.latex(normal)
    ans_plain = "y = " + str(normal)
    f_latex = sp.latex(f)
    q_text = (f"Find the equation of the normal line to "
              f"\\( f(x) = {f_latex} \\) at \\( x = {a_val} \\)")
    return {"q_text": q_text, "f": f, "a": a_val, "type": "normal_line_eq",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


# ===========================================================================
# HARD GENERATORS (10 types)
# ===========================================================================

def gen_implicit_differentiation():
    """x^2 + y^2 = r^2 style, find dy/dx."""
    y_sym = sp.Function('y')(x)
    r = rc([1, 2, 3, 4, 5])
    patterns = [
        (x**2 + y_sym**2 - r**2, f"x^{{2}} + y^{{2}} = {r**2}"),
        (x**2 * y_sym + y_sym**3 - rc(POS), None),
        (sp.sin(x) + sp.cos(y_sym) - rc(SML), None),
        (x * y_sym - sp.exp(x + y_sym), None),
        (x**3 + y_sym**3 - rc(POS) * x * y_sym, None),
    ]
    eq_expr, custom_eq = rc(patterns)
    try:
        dydx = -sp.diff(eq_expr, x) / sp.diff(eq_expr, y_sym)
        dydx = sp.simplify(dydx)
        # Replace y(x) with y in latex
        dydx_sub = dydx.subs(y_sym, sp.Symbol('y'))
        ans_latex = clean_latex(sp.latex(dydx_sub))
        ans_plain = str(dydx_sub)
    except Exception:
        return None

    eq_latex = custom_eq or clean_latex(sp.latex(sp.Eq(eq_expr, 0)))
    q_text = (f"Use implicit differentiation to find \\( \\frac{{dy}}{{dx}} \\) "
              f"given \\( {eq_latex} \\)")
    return {"q_text": q_text, "f": eq_expr, "a": None,
            "type": "implicit_differentiation",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_logarithmic_differentiation():
    """y = x^x, y = (fg)^(1/n) style."""
    patterns = []

    # y = x^x
    a = rc(POS)
    patterns.append((x**(a*x), f"{sp.latex(x**(a*x))}"))

    # y = x^(sin x)
    patterns.append((x**sp.sin(x), f"{sp.latex(x**sp.sin(x))}"))

    # y = (product)^(1/n)
    n = rc([2, 3])
    b = rc(POS)
    patterns.append(((x**2 + b)**sp.Rational(1, n) * (x + 1)**sp.Rational(1, n),
                     None))

    f, custom_latex = rc(patterns)
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    f_latex = custom_latex or sp.latex(f)
    q_text = (f"Use logarithmic differentiation to find the derivative of "
              f"\\( y = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": None,
            "type": "logarithmic_differentiation",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_related_rates_setup():
    """Given rate equation, find dy/dt."""
    t_sym = sp.Symbol('t')
    x_t = sp.Function('x')(t_sym)
    y_t = sp.Function('y')(t_sym)

    a = rc(POS)
    patterns = [
        # x^2 + y^2 = r^2
        (x_t**2 + y_t**2 - a**2,
         f"x^2 + y^2 = {a**2}",
         "If \\( \\frac{{dx}}{{dt}} = {rate} \\) when \\( x = {xval} \\) and \\( y = {yval} \\), find \\( \\frac{{dy}}{{dt}} \\)"),
    ]
    eq_expr, eq_str, template = rc(patterns)
    # Differentiate w.r.t. t
    try:
        d_eq = sp.diff(eq_expr, t_sym)
    except Exception:
        return None

    # Pick concrete values
    xval = rc([1, 2, 3])
    rate = rc([-2, -1, 1, 2, 3])
    try:
        yval_sq = a**2 - xval**2
        if yval_sq <= 0:
            return None
        yval = sp.sqrt(yval_sq)
    except Exception:
        return None

    # Solve for dy/dt
    dy_dt = sp.Symbol("dy_dt")
    dx_dt = sp.Symbol("dx_dt")
    try:
        d_eq_sub = d_eq.subs(sp.Derivative(x_t, t_sym), dx_dt)
        d_eq_sub = d_eq_sub.subs(sp.Derivative(y_t, t_sym), dy_dt)
        d_eq_sub = d_eq_sub.subs(x_t, xval).subs(y_t, yval)
        d_eq_sub = d_eq_sub.subs(dx_dt, rate)
        sol = sp.solve(d_eq_sub, dy_dt)
        if not sol:
            return None
        ans = sp.simplify(sol[0])
    except Exception:
        return None

    ans_latex, ans_plain = fmt_ans(ans)
    q_text = template.format(rate=rate, xval=xval, yval=sp.latex(yval))
    q_text = f"Given \\( {eq_str} \\). {q_text}"
    return {"q_text": q_text, "f": eq_expr, "a": None,
            "type": "related_rates_setup",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_linear_approximation():
    """L(x) = f(a) + f'(a)(x - a)."""
    a_val = rc([0, 1, sp.pi/6, sp.pi/4, sp.pi/3, sp.pi/2])
    f_opts = [
        sp.sin(x), sp.cos(x), sp.exp(x), sp.sqrt(x + 1),
        sp.log(x + 1), sp.tan(x),
    ]
    f = rc(f_opts)
    d = safe_diff(f)
    if d is None:
        return None
    try:
        f_a = sp.simplify(f.subs(x, a_val))
        d_a = sp.simplify(d.subs(x, a_val))
        if not f_a.is_finite or not d_a.is_finite:
            return None
    except Exception:
        return None
    L = f_a + d_a * (x - a_val)
    L = sp.expand(L)
    ans_latex = "L(x) = " + sp.latex(L)
    ans_plain = "L(x) = " + str(L)
    f_latex = sp.latex(f)
    a_latex = sp.latex(a_val)
    q_text = (f"Find the linear approximation \\( L(x) \\) of "
              f"\\( f(x) = {f_latex} \\) at \\( a = {a_latex} \\)")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "linear_approximation",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_critical_points():
    """Find f'(x) = 0, classify."""
    a, b, c_ = rc(NZ), rc(NZ), rc(NZ)
    # Ensure a polynomial with real critical points
    f = a*x**3 + b*x**2 + c_*x + rc(NZ)
    d = safe_diff(f)
    if d is None:
        return None
    try:
        crits = sp.solve(d, x)
        # Filter to real solutions
        crits = [c for c in crits if c.is_real]
        if not crits:
            return None
    except Exception:
        return None
    d2 = safe_diff(f, x, 2)
    classifications = []
    for c in crits:
        try:
            d2_val = d2.subs(x, c)
            if d2_val > 0:
                classifications.append(f"x = {sp.latex(c)} \\text{{ (local min)}}")
            elif d2_val < 0:
                classifications.append(f"x = {sp.latex(c)} \\text{{ (local max)}}")
            else:
                classifications.append(f"x = {sp.latex(c)} \\text{{ (inflection)}}")
        except Exception:
            classifications.append(f"x = {sp.latex(c)}")

    ans_latex = ", \\; ".join(classifications)
    ans_plain = ", ".join(str(c) for c in crits)
    f_latex = sp.latex(f)
    q_text = (f"Find and classify the critical points of "
              f"\\( f(x) = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": None, "type": "critical_points",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_mean_value_theorem():
    """Verify MVT on [a, b], find c."""
    a_val = rc([-2, -1, 0, 1])
    b_val = a_val + rc([1, 2, 3, 4])
    coeff = [rc(NZ) for _ in range(rc([3, 4]))]
    f = sum(c * x**i for i, c in enumerate(coeff))
    try:
        fa = f.subs(x, a_val)
        fb = f.subs(x, b_val)
        avg_slope = (fb - fa) / (b_val - a_val)
    except Exception:
        return None
    d = safe_diff(f)
    if d is None:
        return None
    try:
        c_vals = sp.solve(d - avg_slope, x)
        # Filter c in (a, b)
        c_vals = [c for c in c_vals if c.is_real and a_val < c < b_val]
        if not c_vals:
            return None
    except Exception:
        return None
    ans_parts = [sp.latex(c) for c in c_vals]
    ans_latex = "c = " + (", ".join(ans_parts))
    ans_plain = ", ".join(str(c) for c in c_vals)
    f_latex = sp.latex(f)
    q_text = (f"Verify the Mean Value Theorem for \\( f(x) = {f_latex} \\) "
              f"on \\([{a_val}, {b_val}]\\) and find the value(s) of \\( c \\)")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "mean_value_theorem",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_lhopital_derivative():
    """Use derivatives to evaluate a 0/0 limit."""
    a_val = rc([0, 1, -1])
    num_choices = [
        (sp.sin(x - a_val), a_val),
        (sp.exp(x - a_val) - 1, a_val),
        (x**2 - a_val**2, a_val),
        (sp.log(x) - sp.log(a_val), a_val) if a_val > 0 else None,
    ]
    num_choices = [n for n in num_choices if n is not None]
    num_expr, _ = rc(num_choices)

    den_opts = [x - a_val, sp.sin(x - a_val), sp.tan(x - a_val)]
    den_expr = rc(den_opts)

    # Check it's 0/0
    try:
        n0 = num_expr.subs(x, a_val)
        d0 = den_expr.subs(x, a_val)
        if n0 != 0 or d0 != 0:
            return None
    except Exception:
        return None

    try:
        result = sp.limit(num_expr / den_expr, x, a_val)
        if result.has(sp.zoo, sp.nan):
            return None
    except Exception:
        return None

    ans_latex, ans_plain = fmt_ans(result)
    f_latex = sp.latex(num_expr / den_expr)
    a_latex = sp.latex(a_val)
    q_text = (f"Use L'H\\^opital's Rule to evaluate "
              f"\\( \\lim_{{x \\to {a_latex}}} {f_latex} \\)")
    return {"q_text": q_text, "f": num_expr / den_expr, "a": a_val,
            "type": "lhopital_derivative",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_parametric_derivative():
    """dy/dx = (dy/dt)/(dx/dt)."""
    t_sym = sp.Symbol('t')
    a, b = rc(NZ), rc(NZ)
    n = rc([2, 3])
    xt_opts = [a*t_sym**n, a*sp.cos(t_sym), a*t_sym + b*t_sym**2]
    yt_opts = [b*t_sym**n, b*sp.sin(t_sym), a*t_sym**2 + b*t_sym]
    xt = rc(xt_opts)
    yt = rc(yt_opts)
    try:
        dx_dt = sp.diff(xt, t_sym)
        dy_dt = sp.diff(yt, t_sym)
        if dx_dt == 0:
            return None
        dydx = sp.simplify(dy_dt / dx_dt)
    except Exception:
        return None
    ans_latex, ans_plain = fmt_ans(dydx)
    xt_latex = sp.latex(xt)
    yt_latex = sp.latex(yt)
    q_text = (f"Find \\( \\frac{{dy}}{{dx}} \\) given the parametric equations "
              f"\\( x = {xt_latex}, \\; y = {yt_latex} \\)")
    return {"q_text": q_text, "f": yt, "a": None,
            "type": "parametric_derivative",
            "dir": "+-", "var": t_sym, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_piecewise_differentiability():
    """Is f differentiable at the join point?"""
    a_val = rc([0, 1, -1, 2])
    c1, c2 = rc(NZ), rc(NZ)
    n = rc([2, 3])

    # Left piece: polynomial
    left = c1 * x**n + c2 * x
    # Ensure continuity at a_val
    left_val = left.subs(x, a_val)

    # Right piece: linear ax + b chosen to be continuous
    m = rc(NZ)
    b_val = left_val - m * a_val
    right = m * x + b_val

    # Check differentiability
    left_deriv = sp.diff(left, x).subs(x, a_val)
    right_deriv = m
    is_diff = (left_deriv == right_deriv)

    f_left_latex = sp.latex(left)
    f_right_latex = sp.latex(right)
    q_text = (f"Determine if the piecewise function is differentiable at \\( x = {a_val} \\):"
              f" \\( f(x) = \\begin{{cases}} {f_left_latex} & x \\le {a_val} \\\\ "
              f"{f_right_latex} & x > {a_val} \\end{{cases}} \\)")

    if is_diff:
        ans_latex = f"\\text{{Yes, differentiable. }} f'({a_val}) = {sp.latex(left_deriv)}"
        ans_plain = f"Yes, f'({a_val}) = {left_deriv}"
    else:
        ans_latex = (f"\\text{{Not differentiable. Left derivative}} = {sp.latex(left_deriv)}"
                     f", \\text{{right derivative}} = {right_deriv}")
        ans_plain = f"No, left={left_deriv}, right={right_deriv}"

    return {"q_text": q_text, "f": left, "a": a_val,
            "type": "piecewise_differentiability",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_chain_rule_nested():
    """Triple-nested compositions."""
    a, b = rc(SML), rc(SML)
    outer_fns = [sp.sin, sp.cos, sp.exp]
    mid_fns = [sp.sin, sp.cos, sp.sqrt, lambda u: u**2]
    o1 = rc(outer_fns)
    m1 = rc(mid_fns)
    inner = a*x + b
    f = o1(m1(inner))
    d = safe_diff(f)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    return {"q_text": None, "f": f, "a": None, "type": "chain_rule_nested",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_rates_of_change():
    """Velocity/acceleration or marginal cost word problems."""
    variant = rc(["physics", "physics", "business"])
    if variant == "physics":
        a_, b_, c_, d_ = rc(NZ), rc(NZ), rc(NZ), rc(NZ)
        f = a_ * t**3 + b_ * t**2 + c_ * t + d_
        t_val = rc([1, 2, 3])
        v = safe_diff(f, t)
        a_func = safe_diff(f, t, 2)
        if v is None or a_func is None:
            return None
        try:
            v_val = sp.simplify(v.subs(t, t_val))
            a_val_num = sp.simplify(a_func.subs(t, t_val))
            if not v_val.is_finite or not a_val_num.is_finite:
                return None
        except Exception:
            return None
        ans_latex = f"v({t_val}) = {sp.latex(v_val)}, \\; a({t_val}) = {sp.latex(a_val_num)}"
        ans_plain = f"v({t_val}) = {v_val}, a({t_val}) = {a_val_num}"
        f_latex = sp.latex(f)
        q_text = (f"A particle has position \\( s(t) = {f_latex} \\). "
                  f"Find the velocity and acceleration at \\( t = {t_val} \\)")
        return {"q_text": q_text, "f": f, "a": t_val,
                "type": "rates_of_change",
                "dir": "+-", "var": t, "ans_latex": ans_latex, "ans_plain": ans_plain}
    else:
        # Marginal cost: C(x) polynomial, find C'(x0)
        a_, b_, c_ = rc(POS), rc(NZ), rc(POS)
        f = a_ * x**2 + b_ * x + c_
        x_val = rc([10, 20, 50, 100])
        d = safe_diff(f)
        if d is None:
            return None
        try:
            mc = sp.simplify(d.subs(x, x_val))
            if not mc.is_finite:
                return None
        except Exception:
            return None
        ans_latex, ans_plain = fmt_ans(mc)
        f_latex = sp.latex(f)
        q_text = (f"The cost function is \\( C(x) = {f_latex} \\). "
                  f"Find the marginal cost when \\( x = {x_val} \\) units are produced")
        return {"q_text": q_text, "f": f, "a": x_val,
                "type": "rates_of_change",
                "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_min_max_values():
    """Find absolute min/max of f on closed interval [a,b]."""
    a_coeff, b_coeff, c_coeff = rc(NZ), rc(NZ), rc(NZ)
    f = a_coeff * x**3 + b_coeff * x**2 + c_coeff * x + rc(NZ)
    d = safe_diff(f)
    if d is None:
        return None
    a_val = rc([-3, -2, -1, 0])
    b_val = a_val + rc([2, 3, 4, 5])
    try:
        crits = sp.solve(d, x)
        crits = [c for c in crits if c.is_real and a_val < c < b_val]
    except Exception:
        return None
    eval_pts = [a_val] + crits + [b_val]
    try:
        vals = [(pt, sp.simplify(f.subs(x, pt))) for pt in eval_pts]
        vals = [(pt, v) for pt, v in vals if v.is_finite]
        if not vals:
            return None
        min_pt = min(vals, key=lambda pv: float(pv[1]))
        max_pt = max(vals, key=lambda pv: float(pv[1]))
    except Exception:
        return None
    ans_latex = (f"\\text{{Min}} = {sp.latex(min_pt[1])}, \\; "
                 f"\\text{{Max}} = {sp.latex(max_pt[1])}")
    ans_plain = f"Min = {min_pt[1]}, Max = {max_pt[1]}"
    f_latex = sp.latex(f)
    q_text = (f"Find the absolute minimum and maximum values of "
              f"\\( f(x) = {f_latex} \\) on \\([{a_val}, {b_val}]\\)")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "min_max_values",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_absolute_extrema():
    """Find absolute extrema with both x-locations and y-values."""
    a_coeff, b_coeff = rc(NZ), rc(NZ)
    c_coeff = rc(NZ)
    f = a_coeff * x**4 + b_coeff * x**2 + c_coeff * x + rc(NZ)
    d = safe_diff(f)
    if d is None:
        return None
    a_val = rc([-2, -1, 0])
    b_val = a_val + rc([2, 3, 4])
    try:
        crits = sp.solve(d, x)
        crits = [c for c in crits if c.is_real and a_val < c < b_val]
    except Exception:
        return None
    eval_pts = [a_val] + crits + [b_val]
    try:
        vals = [(pt, sp.simplify(f.subs(x, pt))) for pt in eval_pts]
        vals = [(pt, v) for pt, v in vals if v.is_finite and v.is_real]
        if not vals:
            return None
        min_pt = min(vals, key=lambda pv: float(pv[1]))
        max_pt = max(vals, key=lambda pv: float(pv[1]))
    except Exception:
        return None
    ans_latex = (f"\\text{{Abs min: }} f({sp.latex(min_pt[0])}) = {sp.latex(min_pt[1])}, \\; "
                 f"\\text{{Abs max: }} f({sp.latex(max_pt[0])}) = {sp.latex(max_pt[1])}")
    ans_plain = (f"Abs min: f({min_pt[0]}) = {min_pt[1]}, "
                 f"Abs max: f({max_pt[0]}) = {max_pt[1]}")
    f_latex = sp.latex(f)
    q_text = (f"Find the absolute extrema of "
              f"\\( f(x) = {f_latex} \\) on \\([{a_val}, {b_val}]\\), "
              f"giving both the x-values and y-values")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "absolute_extrema",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_increasing_decreasing():
    """Find intervals where f is increasing/decreasing using first derivative."""
    a_coeff = rc(NZ)
    b_coeff = rc(NZ)
    c_coeff = rc(NZ)
    f = a_coeff * x**3 + b_coeff * x**2 + c_coeff * x + rc(NZ)
    d = safe_diff(f)
    if d is None:
        return None
    try:
        crits = sp.solve(d, x)
        crits = sorted([c for c in crits if c.is_real], key=float)
        if len(crits) < 1:
            return None
    except Exception:
        return None

    # Build intervals and test sign of f'
    boundaries = [sp.S.NegativeInfinity] + crits + [sp.S.Infinity]
    inc_intervals = []
    dec_intervals = []
    for i in range(len(boundaries) - 1):
        left, right = boundaries[i], boundaries[i + 1]
        # Pick test point
        if left == sp.S.NegativeInfinity:
            test = float(right) - 1
        elif right == sp.S.Infinity:
            test = float(left) + 1
        else:
            test = (float(left) + float(right)) / 2
        try:
            sign_val = float(d.subs(x, test))
        except Exception:
            return None
        left_str = f"-\\infty" if left == sp.S.NegativeInfinity else sp.latex(left)
        right_str = f"\\infty" if right == sp.S.Infinity else sp.latex(right)
        interval_str = f"({left_str}, {right_str})"
        left_plain = "-inf" if left == sp.S.NegativeInfinity else str(left)
        right_plain = "inf" if right == sp.S.Infinity else str(right)
        interval_plain = f"({left_plain}, {right_plain})"
        if sign_val > 0:
            inc_intervals.append((interval_str, interval_plain))
        elif sign_val < 0:
            dec_intervals.append((interval_str, interval_plain))

    if not inc_intervals and not dec_intervals:
        return None

    parts_latex = []
    parts_plain = []
    if inc_intervals:
        parts_latex.append("\\text{Increasing on } " + ", ".join(i[0] for i in inc_intervals))
        parts_plain.append("Increasing on " + ", ".join(i[1] for i in inc_intervals))
    if dec_intervals:
        parts_latex.append("\\text{Decreasing on } " + ", ".join(i[0] for i in dec_intervals))
        parts_plain.append("Decreasing on " + ", ".join(i[1] for i in dec_intervals))

    ans_latex = "; \\; ".join(parts_latex)
    ans_plain = "; ".join(parts_plain)
    f_latex = sp.latex(f)
    q_text = (f"Find the intervals where \\( f(x) = {f_latex} \\) "
              f"is increasing and where it is decreasing")
    return {"q_text": q_text, "f": f, "a": None,
            "type": "increasing_decreasing",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_concavity_inflection():
    """Find concavity intervals and inflection points using f''(x)."""
    a_coeff = rc(NZ)
    b_coeff = rc(NZ)
    c_coeff = rc(NZ)
    # Use degree 3 or 4 polynomial
    if random.random() < 0.5:
        f = a_coeff * x**3 + b_coeff * x**2 + c_coeff * x + rc(NZ)
    else:
        f = rc(NZ) * x**4 + a_coeff * x**3 + b_coeff * x**2 + c_coeff * x + rc(NZ)
    d2 = safe_diff(f, x, 2)
    if d2 is None:
        return None
    try:
        inflections = sp.solve(d2, x)
        inflections = sorted([c for c in inflections if c.is_real], key=float)
    except Exception:
        return None
    if not inflections:
        return None

    # Build intervals and test sign of f''
    boundaries = [sp.S.NegativeInfinity] + inflections + [sp.S.Infinity]
    cu_intervals = []
    cd_intervals = []
    for i in range(len(boundaries) - 1):
        left, right = boundaries[i], boundaries[i + 1]
        if left == sp.S.NegativeInfinity:
            test = float(right) - 1
        elif right == sp.S.Infinity:
            test = float(left) + 1
        else:
            test = (float(left) + float(right)) / 2
        try:
            sign_val = float(d2.subs(x, test))
        except Exception:
            return None
        left_str = f"-\\infty" if left == sp.S.NegativeInfinity else sp.latex(left)
        right_str = f"\\infty" if right == sp.S.Infinity else sp.latex(right)
        interval_str = f"({left_str}, {right_str})"
        if sign_val > 0:
            cu_intervals.append(interval_str)
        elif sign_val < 0:
            cd_intervals.append(interval_str)

    infl_latex = ", ".join(f"x = {sp.latex(ip)}" for ip in inflections)
    parts = []
    if cu_intervals:
        parts.append("\\text{Concave up on } " + ", ".join(cu_intervals))
    if cd_intervals:
        parts.append("\\text{Concave down on } " + ", ".join(cd_intervals))
    parts.append(f"\\text{{Inflection at }} {infl_latex}")

    ans_latex = "; \\; ".join(parts)
    ans_plain = (f"Inflection points: {', '.join(f'x = {ip}' for ip in inflections)}")
    f_latex = sp.latex(f)
    q_text = (f"Find the intervals of concavity and inflection points of "
              f"\\( f(x) = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": None,
            "type": "concavity_inflection",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_optimization():
    """Applied optimization: maximize area/volume given constraint."""
    variant = rc(["fence", "box", "cylinder"])

    if variant == "fence":
        # Fence 3 sides with P meters, maximize area A = x(P - 2x)/2
        P = rc([100, 120, 200, 240, 300, 400])
        # A(x) = x*(P - 2x) for a rectangular area with one side against wall
        # A = P*x - 2*x^2, A'=0 => x = P/4, max area = P^2/8
        f = P * x - 2 * x**2
        d = safe_diff(f)
        if d is None:
            return None
        try:
            crits = sp.solve(d, x)
            crits = [c for c in crits if c.is_real and c > 0]
            if not crits:
                return None
            opt_x = crits[0]
            max_area = sp.simplify(f.subs(x, opt_x))
        except Exception:
            return None
        ans_latex = (f"x = {sp.latex(opt_x)}, \\; "
                     f"\\text{{Max area}} = {sp.latex(max_area)}")
        ans_plain = f"x = {opt_x}, Max area = {max_area}"
        q_text = (f"A farmer has {P} meters of fencing to enclose a rectangular area "
                  f"against a barn wall (3 sides of fencing). "
                  f"Find the dimensions that maximize the enclosed area")
        return {"q_text": q_text, "f": f, "a": None,
                "type": "optimization",
                "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}

    elif variant == "box":
        # Open-top box from sheet W x W, cut corners of size x
        W = rc([10, 12, 16, 20, 24])
        # V = x(W - 2x)^2
        f = x * (W - 2*x)**2
        f = sp.expand(f)
        d = safe_diff(f)
        if d is None:
            return None
        try:
            crits = sp.solve(d, x)
            crits = [c for c in crits if c.is_real and 0 < c < sp.Rational(W, 2)]
            if not crits:
                return None
            # Pick the critical point giving a max (smaller x for open box)
            vals = [(c, sp.simplify(f.subs(x, c))) for c in crits]
            opt = max(vals, key=lambda pv: float(pv[1]))
            opt_x, max_vol = opt
        except Exception:
            return None
        ans_latex = (f"x = {sp.latex(opt_x)}, \\; "
                     f"\\text{{Max volume}} = {sp.latex(max_vol)}")
        ans_plain = f"x = {opt_x}, Max volume = {max_vol}"
        q_text = (f"An open-top box is made from a {W} \\times {W} sheet by cutting "
                  f"squares of side \\( x \\) from each corner. "
                  f"Find \\( x \\) that maximizes the volume")
        return {"q_text": q_text, "f": f, "a": None,
                "type": "optimization",
                "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}

    else:
        # Minimize surface area of cylinder with fixed volume V
        r = sp.Symbol('r', positive=True)
        V = rc([100, 200, 500, 1000])
        # V = pi*r^2*h => h = V/(pi*r^2)
        # SA = 2*pi*r^2 + 2*pi*r*h = 2*pi*r^2 + 2V/r
        SA = 2 * sp.pi * r**2 + 2 * V / r
        d = sp.diff(SA, r)
        try:
            crits = sp.solve(d, r)
            crits = [c for c in crits if c.is_real and c > 0]
            if not crits:
                return None
            opt_r = crits[0]
            opt_r_simplified = sp.simplify(opt_r)
            h_val = sp.simplify(V / (sp.pi * opt_r**2))
        except Exception:
            return None
        ans_latex = (f"r = {sp.latex(opt_r_simplified)}, \\; "
                     f"h = {sp.latex(sp.simplify(h_val))}")
        ans_plain = f"r = {opt_r_simplified}, h = {sp.simplify(h_val)}"
        q_text = (f"A closed cylindrical can must hold {V} cubic units. "
                  f"Find the radius \\( r \\) and height \\( h \\) that "
                  f"minimize the total surface area")
        return {"q_text": q_text, "f": SA, "a": None,
                "type": "optimization",
                "dir": "+-", "var": r, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_differentials():
    """Compute dy given y=f(x), x=a, dx=delta_x."""
    a_val = rc([-1, 0, 1, 2, 3, 4])
    dx_val = rc([sp.Rational(1, 10), sp.Rational(1, 100),
                 sp.Rational(-1, 10), sp.Rational(1, 2)])
    f_opts = [
        x**2 + rc(NZ) * x,
        rc(NZ) * x**3 + rc(NZ) * x,
        sp.sqrt(x + rc(POS)),
        sp.sin(x),
        sp.exp(x),
        sp.log(x + rc(POS)),
    ]
    f = rc(f_opts)
    d = safe_diff(f)
    if d is None:
        return None
    try:
        d_at_a = sp.simplify(d.subs(x, a_val))
        if not d_at_a.is_finite:
            return None
        dy = sp.simplify(d_at_a * dx_val)
    except Exception:
        return None
    ans_latex = f"dy = {sp.latex(dy)}"
    ans_plain = f"dy = {dy}"
    f_latex = sp.latex(f)
    q_text = (f"If \\( y = {f_latex} \\), find \\( dy \\) when "
              f"\\( x = {a_val} \\) and \\( dx = {sp.latex(dx_val)} \\)")
    return {"q_text": q_text, "f": f, "a": a_val,
            "type": "differentials",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_newtons_method():
    """Apply 2 iterations of Newton's method: x_{n+1} = x_n - f(x_n)/f'(x_n)."""
    # Build a function with a known root nearby
    variant = rc(["poly", "trig_mix"])
    if variant == "poly":
        a_, b_, c_ = rc(NZ), rc(NZ), rc(NZ)
        f = x**3 + a_ * x + b_
    else:
        f = sp.cos(x) - x
    d = safe_diff(f)
    if d is None:
        return None
    x0 = rc([sp.Rational(1, 1), sp.Rational(2, 1), sp.Rational(-1, 1),
             sp.Rational(3, 2)])
    try:
        f0 = f.subs(x, x0)
        d0 = d.subs(x, x0)
        if d0 == 0:
            return None
        x1 = sp.simplify(x0 - f0 / d0)
        f1 = f.subs(x, x1)
        d1 = d.subs(x, x1)
        if d1 == 0:
            return None
        x2 = sp.simplify(x1 - f1 / d1)
        # Round to 6 decimal places for display
        x2_float = float(x2)
        x2_rounded = round(x2_float, 6)
    except Exception:
        return None
    ans_latex = f"x_2 \\approx {x2_rounded}"
    ans_plain = f"x2 ≈ {x2_rounded}"
    f_latex = sp.latex(f)
    q_text = (f"Use Newton's method with \\( x_0 = {sp.latex(x0)} \\) to "
              f"approximate a root of \\( f(x) = {f_latex} \\). "
              f"Find \\( x_2 \\) (two iterations)")
    return {"q_text": q_text, "f": f, "a": x0,
            "type": "newtons_method",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


# ===========================================================================
# SCHOLAR GENERATORS (4 types)
# ===========================================================================

def gen_nth_derivative_pattern():
    """Find d^n/dx^n for sin(ax), e^(ax)."""
    a = rc(SML)
    n = rc([4, 5, 6, 7, 8, 10, 12])
    if random.random() < 0.5:
        f = sp.sin(a * x)
    else:
        f = sp.exp(a * x)
    d = safe_diff(f, x, n)
    if d is None:
        return None
    d = sp.simplify(d)
    ans_latex, ans_plain = fmt_ans(d)
    f_latex = sp.latex(f)
    q_text = (f"Find the {n}th derivative of \\( f(x) = {f_latex} \\)")
    return {"q_text": q_text, "f": f, "a": None,
            "type": "nth_derivative_pattern",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_inverse_function_derivative():
    """(f^{-1})'(y) = 1/f'(x)."""
    a, b = rc(POS), rc(NZ)
    f_opts = [
        a*x**3 + b,
        a*x + b*x**3,
        sp.exp(a*x),
    ]
    f = rc(f_opts)
    d = safe_diff(f)
    if d is None:
        return None

    # Pick an x-value where f'(x) != 0
    x0 = rc([0, 1, -1, 2])
    try:
        y0 = f.subs(x, x0)
        d_x0 = d.subs(x, x0)
        if d_x0 == 0 or not d_x0.is_finite:
            return None
        inv_deriv = sp.simplify(1 / d_x0)
    except Exception:
        return None

    ans_latex, ans_plain = fmt_ans(inv_deriv)
    f_latex = sp.latex(f)
    q_text = (f"If \\( f(x) = {f_latex} \\), find \\( (f^{{-1}})'({sp.latex(y0)}) \\)")
    return {"q_text": q_text, "f": f, "a": x0,
            "type": "inverse_function_derivative",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_vector_derivative():
    """d/dt <f(t), g(t), h(t)>."""
    t_sym = sp.Symbol('t')
    a, b, c_ = rc(NZ), rc(NZ), rc(NZ)
    comp_opts = [
        a*t_sym**2, b*sp.sin(t_sym), c_*sp.exp(t_sym),
        a*t_sym**3, b*sp.cos(t_sym), c_*t_sym,
        a*sp.log(t_sym + 1), b*t_sym**2 + c_*t_sym,
    ]
    comps = random.sample(comp_opts, 3)
    derivs = []
    for comp in comps:
        d = safe_diff(comp, t_sym)
        if d is None:
            return None
        derivs.append(sp.simplify(d))

    comp_latex = [sp.latex(c) for c in comps]
    deriv_latex = [sp.latex(d) for d in derivs]
    ans_latex = f"\\langle {', '.join(deriv_latex)} \\rangle"
    ans_plain = f"<{', '.join(str(d) for d in derivs)}>"
    q_text = (f"Find the derivative of the vector function "
              f"\\( \\mathbf{{r}}(t) = \\langle {', '.join(comp_latex)} \\rangle \\)")
    return {"q_text": q_text, "f": comps[0], "a": None,
            "type": "vector_derivative",
            "dir": "+-", "var": t_sym, "ans_latex": ans_latex, "ans_plain": ans_plain}


def gen_taylor_coefficient():
    """f^(n)(0)/n!"""
    a = rc(SML)
    n = rc([3, 4, 5, 6])
    f_opts = [
        sp.exp(a*x), sp.sin(a*x), sp.cos(a*x),
        1/(1 - a*x), sp.log(1 + a*x),
    ]
    f = rc(f_opts)
    try:
        d_n = sp.diff(f, x, n)
        val = sp.simplify(d_n.subs(x, 0))
        coeff = sp.simplify(val / sp.factorial(n))
        if not coeff.is_finite:
            return None
    except Exception:
        return None

    ans_latex, ans_plain = fmt_ans(coeff)
    f_latex = sp.latex(f)
    q_text = (f"Find the coefficient of \\( x^{n} \\) in the Maclaurin series of "
              f"\\( f(x) = {f_latex} \\) (i.e., compute \\( f^{{({n})}}(0)/{n}! \\))")
    return {"q_text": q_text, "f": f, "a": 0,
            "type": "taylor_coefficient",
            "dir": "+-", "var": x, "ans_latex": ans_latex, "ans_plain": ans_plain}


# ===========================================================================
# Type ↔ Difficulty mapping & Generator registry
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "power_rule", "constant_multiple", "sum_difference",
        "basic_trig", "basic_exponential", "basic_logarithmic",
        "definition_of_derivative", "derivative_interpretation",
    ],
    "medium": [
        "product_rule", "quotient_rule", "chain_rule_basic",
        "chain_rule_trig", "chain_rule_exponential", "inverse_trig",
        "hyperbolic", "higher_order", "tangent_line_eq", "normal_line_eq",
    ],
    "hard": [
        "implicit_differentiation", "logarithmic_differentiation",
        "related_rates_setup", "linear_approximation", "critical_points",
        "mean_value_theorem", "lhopital_derivative", "parametric_derivative",
        "piecewise_differentiability", "chain_rule_nested",
        "rates_of_change", "min_max_values", "absolute_extrema",
        "increasing_decreasing", "concavity_inflection", "optimization",
        "differentials", "newtons_method",
    ],
    "scholar": [
        "nth_derivative_pattern", "inverse_function_derivative",
        "vector_derivative", "taylor_coefficient",
    ],
}

GENERATORS = {
    # Basic
    "power_rule":                gen_power_rule,
    "constant_multiple":         gen_constant_multiple,
    "sum_difference":            gen_sum_difference,
    "basic_trig":                gen_basic_trig,
    "basic_exponential":         gen_basic_exponential,
    "basic_logarithmic":         gen_basic_logarithmic,
    "definition_of_derivative":  gen_definition_of_derivative,
    "derivative_interpretation": gen_derivative_interpretation,
    # Medium
    "product_rule":              gen_product_rule,
    "quotient_rule":             gen_quotient_rule,
    "chain_rule_basic":          gen_chain_rule_basic,
    "chain_rule_trig":           gen_chain_rule_trig,
    "chain_rule_exponential":    gen_chain_rule_exponential,
    "inverse_trig":              gen_inverse_trig,
    "hyperbolic":                gen_hyperbolic,
    "higher_order":              gen_higher_order,
    "tangent_line_eq":           gen_tangent_line_eq,
    "normal_line_eq":            gen_normal_line_eq,
    # Hard
    "implicit_differentiation":  gen_implicit_differentiation,
    "logarithmic_differentiation": gen_logarithmic_differentiation,
    "related_rates_setup":       gen_related_rates_setup,
    "linear_approximation":      gen_linear_approximation,
    "critical_points":           gen_critical_points,
    "mean_value_theorem":        gen_mean_value_theorem,
    "lhopital_derivative":       gen_lhopital_derivative,
    "parametric_derivative":     gen_parametric_derivative,
    "piecewise_differentiability": gen_piecewise_differentiability,
    "chain_rule_nested":         gen_chain_rule_nested,
    "rates_of_change":           gen_rates_of_change,
    "min_max_values":            gen_min_max_values,
    "absolute_extrema":          gen_absolute_extrema,
    "increasing_decreasing":     gen_increasing_decreasing,
    "concavity_inflection":      gen_concavity_inflection,
    "optimization":              gen_optimization,
    "differentials":             gen_differentials,
    "newtons_method":            gen_newtons_method,
    # Scholar
    "nth_derivative_pattern":    gen_nth_derivative_pattern,
    "inverse_function_derivative": gen_inverse_function_derivative,
    "vector_derivative":         gen_vector_derivative,
    "taylor_coefficient":        gen_taylor_coefficient,
}

# ===========================================================================
# Main generation loop
# ===========================================================================

def generate_derivative_questions(num_questions):
    questions = []
    seen_signatures = set()
    attempts = 0
    max_attempts = num_questions * 50

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1

        # Difficulty distribution: 25% basic, 30% medium, 30% hard, 15% scholar
        rand_val = random.random()
        if   rand_val < 0.25: difficulty = "basic"
        elif rand_val < 0.55: difficulty = "medium"
        elif rand_val < 0.85: difficulty = "hard"
        else:                 difficulty = "scholar"

        q_type = rc(DIFFICULTY_TYPES[difficulty])
        gen_fn = GENERATORS.get(q_type)
        if gen_fn is None:
            continue

        try:
            rec = gen_fn()
            if rec is None:
                continue

            f         = rec["f"]
            a_val     = rec["a"]
            q_type    = rec["type"]
            ans_latex = rec["ans_latex"]
            ans_plain = rec["ans_plain"]
            q_text    = rec.get("q_text")
            diff_var  = rec.get("var", x)

            # Deduplication
            try:
                sig = (sp.srepr(f), sp.srepr(a_val) if a_val is not None else "_",
                       str(diff_var), q_type)
            except Exception:
                sig = (str(f)[:120], str(a_val), q_type)
            if sig in seen_signatures:
                continue

            # If no custom question text, build standard format
            if q_text is None:
                f_latex = sp.latex(f)
                q_text = (f"Find the derivative: "
                          f"\\( \\frac{{d}}{{dx}}\\left({f_latex}\\right) \\)")

            entry = {
                "id":              len(questions) + 1,
                "type":            q_type,
                "difficulty":      difficulty,
                "point_latex":     sp.latex(a_val) if a_val is not None else "",
                "question_text":   q_text,
                "answer_latex":    ans_latex,
                "answer_plain":    ans_plain,
            }

            # Generate SVG figure if applicable
            if _fig_gen_available and q_type in _FIGURE_TYPES_DERIVATIVES:
                try:
                    fig_path = _fig_gen.generate_figure_for_derivative(
                        q_type, rec, entry["id"], _figures_dir_derivatives)
                    if fig_path:
                        entry["figure_svg"] = fig_path
                except Exception:
                    pass

            questions.append(entry)
            seen_signatures.add(sig)

            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} derivative questions...")

        except Exception:
            pass

    return questions


# ===========================================================================
# Entry point
# ===========================================================================

if __name__ == "__main__":
    print("Generating 2000 Derivative questions...")
    questions = generate_derivative_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/derivatives.json"
    with open(output_file, "w") as f_out:
        json.dump(
            {
                "topic": "Derivatives",
                "description": (
                    "Comprehensive Practice Worksheet Database for Derivatives (40 types). "
                    "Basic: Power Rule, Constant Multiple, Sum/Difference, "
                    "Trig, Exponential, Logarithmic, Limit Definition, Interpretation. "
                    "Medium: Product Rule, Quotient Rule, Chain Rule (basic/trig/exp), "
                    "Inverse Trig, Hyperbolic, Higher Order, Tangent/Normal Line. "
                    "Hard: Implicit Differentiation, Logarithmic Differentiation, "
                    "Related Rates, Linear Approximation, Critical Points, "
                    "Mean Value Theorem, L'Hopital, Parametric, Piecewise, "
                    "Nested Chain Rule, Rates of Change, Min/Max Values, "
                    "Absolute Extrema, Increasing/Decreasing, Concavity/Inflection, "
                    "Optimization, Differentials, Newton's Method. "
                    "Scholar: nth Derivative Patterns, Inverse Function Derivative, "
                    "Vector Derivatives, Taylor Coefficients."
                ),
                "questions": questions,
            },
            f_out,
            separators=(',', ':'),
        )

    from collections import Counter
    types = Counter(q["type"] for q in questions)
    diffs = Counter(q["difficulty"] for q in questions)
    print(f"\nDone — {len(questions)} problems → {output_file}")
    print(f"\nBy type ({len(types)} types):")
    for tp, cnt in types.most_common():
        print(f"  {tp}: {cnt}")
    print(f"\nBy difficulty:")
    for d, cnt in diffs.most_common():
        print(f"  {d}: {cnt}")
