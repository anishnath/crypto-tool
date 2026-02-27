"""
Limit Question Bank Generator — Full Curriculum Coverage
Answers verified by SymPy where applicable.

Section 2.1: Tangent Lines & Rates of Change
    secant_slope, tangent_line, avg_vs_instantaneous_rate

Section 2.2–2.5: Evaluating Limits
    direct_evaluation, rational_factoring, radical_rationalizing,
    one_sided_limit, trig_standard, exponential_standard,
    difference_quotient, lhopital_basic

Section 2.6–2.8: Infinite Limits & Limits at Infinity
    vertical_asymptote, rational_at_infinity, transcendental_at_infinity,
    radical_at_infinity

Section 2.9: Continuity
    piecewise_continuity, ivt_application, removable_discontinuity,
    continuity_unknown

Section 2.10: Formal Definition
    epsilon_delta

Advanced / Scholar:
    squeeze_theorem, lhopital_advanced, infinity_advanced,
    exponent_indeterminate, dne_absolute_value, absolute_value_limit
"""

import sympy as sp
import json
import random
import os
import sys

# Figure generation (optional — gracefully degrades if matplotlib unavailable)
_fig_gen_available = False
_fig_gen = None
_FIGURE_TYPES_LIMITS = set()
_figures_dir_limits = ""
try:
    import worksheet_figure_gen as _fig_gen
    _FIGURE_TYPES_LIMITS = _fig_gen.FIGURE_TYPES_LIMITS
    _figures_dir_limits = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "calculus",
        "figures", "limits")
    _fig_gen_available = True
    print("Figure generation enabled.")
except ImportError:
    print("worksheet_figure_gen not available — skipping figure generation.")

x, h, t, k_sym = sp.symbols('x h t k')

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

NZ  = [-4, -3, -2, -1, 1, 2, 3, 4]
POS = [1, 2, 3, 4]
SML = [-2, -1, 1, 2]

def rc(pool):
    return random.choice(pool)

def safe_limit(f, var, a, direction='+-'):
    """Evaluate a limit, returning None if it fails or is unevaluable."""
    try:
        L = sp.limit(f, var, a, dir=direction)
        if L.has(sp.zoo) or L == sp.nan or L.has(sp.Integral):
            return None
        return L
    except Exception:
        return None

def fmt_ans(L):
    """Format a limit result into (latex, plain) strings."""
    if L == sp.oo:
        return "\\infty", "Infinity"
    elif L == -sp.oo:
        return "-\\infty", "-Infinity"
    else:
        return sp.latex(L), str(L)

def fmt_dne():
    return "\\text{DNE}", "Does Not Exist"

# ---------------------------------------------------------------------------
# Section 2.1: Tangent Lines & Rates of Change
# ---------------------------------------------------------------------------

def gen_secant_slope():
    """Secant slope estimation: m_PQ = (f(x)-f(a))/(x-a)."""
    a_val = rc([1, 2, 3, -1, -2])
    c1, c2, c3 = rc(NZ), rc(NZ), rc(POS)
    funcs = [
        (c1*x**2 + c2*x + c3, "polynomial"),
        (sp.sqrt(x + c3),      "radical"),
        (c1*sp.sin(x) + c2,    "trig"),
        (c1*sp.exp(x/c3),      "exponential"),
        (sp.Rational(c1, 1) / (x + c3), "rational"),
    ]
    expr, label = rc(funcs)
    # Ensure a_val is in domain
    try:
        fa = expr.subs(x, a_val)
        if not fa.is_finite:
            expr = c1*x**2 + c2*x + c3
            fa = expr.subs(x, a_val)
    except Exception:
        expr = c1*x**2 + c2*x + c3
        fa = expr.subs(x, a_val)

    # Pick a nearby point for secant
    x_val = a_val + rc([sp.Rational(1,10), sp.Rational(1,2), 1, sp.Rational(-1,2)])
    try:
        fx = expr.subs(x, x_val)
        if not fx.is_finite:
            return None
    except Exception:
        return None

    slope = sp.Rational(fx - fa, x_val - a_val) if (fx - fa).is_rational and (x_val - a_val).is_rational else (fx - fa) / (x_val - a_val)
    slope = sp.simplify(slope)

    q = (f"Let \\( f(x) = {sp.latex(expr)} \\). "
         f"Compute the slope of the secant line between "
         f"\\( x = {sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)} \\) and "
         f"\\( x = {sp.latex(x_val)} \\).")
    al, ap = sp.latex(slope), str(slope)
    return {"q_text": q, "f": expr, "a": a_val, "type": "secant_slope",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_tangent_line():
    """Tangent line equation via limit definition: y - f(a) = m_tan(x - a)."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    c1, c2, c3 = rc(SML), rc(SML), rc(POS)
    funcs = [
        c1*x**2 + c2*x + c3,
        c1*x**3 + c2,
        sp.Rational(c1, 1) * sp.sqrt(x + c3 + abs(a_val) + 1),
    ]
    expr = rc(funcs)
    try:
        fa = sp.simplify(expr.subs(x, a_val))
        deriv = sp.diff(expr, x)
        m = sp.simplify(deriv.subs(x, a_val))
        if not fa.is_finite or not m.is_finite:
            return None
    except Exception:
        return None

    # y = m(x-a) + fa
    line_expr = sp.expand(m*(x - a_val) + fa)
    q = (f"Find the equation of the tangent line to \\( f(x) = {sp.latex(expr)} \\) "
         f"at \\( x = {sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)} \\). "
         f"Express in slope-intercept form \\( y = mx + b \\).")
    al = f"y = {sp.latex(line_expr)}"
    ap = f"y = {line_expr}"
    return {"q_text": q, "f": expr, "a": a_val, "type": "tangent_line",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_avg_vs_instantaneous_rate():
    """Average rate on [a,b] and instantaneous rate at a point."""
    a_val = rc([0, 1, 2])
    b_val = a_val + rc([1, 2, 3])
    c1, c2, c3 = rc(SML), rc(NZ), rc(POS)

    # Use t as the variable for "rate of change" context
    funcs = [
        (c1*t**2 + c2*t + c3, "position"),
        (-sp.Rational(1,2)*c3*t**2 + c2*t + 10, "height"),
        (c3*sp.exp(sp.Rational(c1, 2)*t), "population"),
    ]
    expr, context = rc(funcs)
    try:
        fa = sp.simplify(expr.subs(t, a_val))
        fb = sp.simplify(expr.subs(t, b_val))
        if not fa.is_finite or not fb.is_finite:
            return None
    except Exception:
        return None

    avg_rate = sp.simplify((fb - fa) / (b_val - a_val))

    sub = rc(["avg", "inst"])
    if sub == "avg":
        q = (f"Let \\( s(t) = {sp.latex(expr)} \\). "
             f"Find the average rate of change on "
             f"\\( [{sp.latex(sp.Integer(a_val))}, {sp.latex(sp.Integer(b_val))}] \\).")
        al, ap = sp.latex(avg_rate), str(avg_rate)
    else:
        pt = rc([a_val, b_val])
        deriv = sp.diff(expr, t)
        inst = sp.simplify(deriv.subs(t, pt))
        if not inst.is_finite:
            return None
        q = (f"Let \\( s(t) = {sp.latex(expr)} \\). "
             f"Find the instantaneous rate of change at "
             f"\\( t = {sp.latex(sp.Integer(pt))} \\).")
        al, ap = sp.latex(inst), str(inst)

    return {"q_text": q, "f": expr, "a": a_val, "type": "avg_vs_instantaneous_rate",
            "dir": "+-", "var": t, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Section 2.2–2.5: Evaluating Limits
# ---------------------------------------------------------------------------

def gen_direct_evaluation():
    """Direct substitution — continuous function at the point."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    c1, c2, c3 = rc(NZ), rc(NZ), rc(POS)
    funcs = [
        c1*x**2 + c2*x + c3,
        c1*sp.exp(c2*x),
        sp.sin(c1*x) + c2,
        sp.cos(c1*x) * c2,
        (c1*x + c2) / (x + c3 + abs(a_val) + 1),  # avoid div by zero
        sp.sqrt(x**2 + c3),
    ]
    f = rc(funcs)
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(L)
    return {"q_text": None, "f": f, "a": a_val, "type": "direct_evaluation",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_rational_factoring():
    """0/0 indeterminate resolved by factoring: (x-a) cancels."""
    a_val = rc([-3, -2, -1, 1, 2, 3])
    r2 = rc([v for v in NZ if v != a_val])
    c = rc(POS)
    sub = rc(["quadratic_linear", "quadratic_quadratic", "cubic_linear"])
    if sub == "quadratic_linear":
        numer = sp.expand(c * (x - a_val) * (x - r2))
        denom = sp.expand(x - a_val)
    elif sub == "quadratic_quadratic":
        r3 = rc([v for v in NZ if v != a_val])
        numer = sp.expand((x - a_val) * (x - r2))
        denom = sp.expand((x - a_val) * (x - r3))
    else:
        r2b = rc([v for v in NZ if v != a_val])
        numer = sp.expand((x - a_val) * (x - r2) * (x - r2b))
        denom = sp.expand(x - a_val)
    f = numer / denom
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(L)
    return {"q_text": None, "f": f, "a": a_val, "type": "rational_factoring",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_radical_rationalizing():
    """Limits requiring multiply by conjugate: (sqrt(g(x)) - c) / h(x)."""
    a_val = rc([0, 1, 2, 3, 4])
    c1 = rc(POS)
    sub = rc(["sqrt_minus", "sqrt_diff", "sqrt_plus_over"])
    if sub == "sqrt_minus":
        # (sqrt(x+c1) - sqrt(a+c1)) / (x - a)
        val_at_a = sp.sqrt(a_val + c1)
        f = (sp.sqrt(x + c1) - val_at_a) / (x - a_val)
    elif sub == "sqrt_diff":
        # (sqrt(x) - sqrt(a)) / (x - a)  for a > 0
        if a_val <= 0:
            a_val = rc([1, 2, 4])
        f = (sp.sqrt(x) - sp.sqrt(a_val)) / (x - a_val)
    else:
        # (x - a) / (sqrt(x+c1) - sqrt(a+c1))
        f = (x - a_val) / (sp.sqrt(x + c1) - sp.sqrt(a_val + c1))
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "radical_rationalizing",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_one_sided_limit():
    """One-sided limits where left and right may differ or one may be ±∞."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    c1, c2 = rc(NZ), rc(NZ)
    direction = rc(['+', '-'])

    sub = rc(["rational_pole", "abs_value", "sqrt_boundary", "piecewise_simple"])
    if sub == "rational_pole":
        f = (c1*x + c2) / (x - a_val)
    elif sub == "abs_value":
        f = sp.Abs(x - a_val) / (x - a_val)
    elif sub == "sqrt_boundary":
        # sqrt(x - a) from the right only
        direction = '+'
        f = sp.sqrt(x - a_val) / (x - a_val + 1)
    else:
        # floor/ceiling style: different expression each side
        if direction == '+':
            f = c1*x + c2 + 1
        else:
            f = c1*x**2 + c2

    L = safe_limit(f, x, a_val, direction)
    if L is None:
        return None
    al, ap = fmt_ans(L)
    q_dir = "^+" if direction == '+' else "^-"
    q = (f"Evaluate the one-sided limit: \\( \\lim_{{x \\to {sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)}{q_dir}}} "
         f"\\left({sp.latex(f)}\\right) \\)")
    return {"q_text": q, "f": f, "a": a_val, "type": "one_sided_limit",
            "dir": direction, "var": x, "ans_latex": al, "ans_plain": ap}


def gen_trig_standard():
    """Standard trig limits: sin(ax)/bx, (1-cos(ax))/x, tan(ax)/bx, etc."""
    c1, c2 = rc(SML), rc(SML)
    if c2 == 0: c2 = 1
    sub = rc(["sin_over_x", "one_minus_cos", "tan_over_x", "sin_over_sin", "x_over_sin"])
    if sub == "sin_over_x":
        f = sp.sin(c1*x) / (c2*x)
    elif sub == "one_minus_cos":
        f = (1 - sp.cos(c1*x)) / x
    elif sub == "tan_over_x":
        f = sp.tan(c1*x) / (c2*x)
    elif sub == "sin_over_sin":
        f = sp.sin(c1*x) / sp.sin(c2*x)
    else:
        f = (c2*x) / sp.sin(c1*x)
    L = safe_limit(f, x, 0)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": 0, "type": "trig_standard",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_exponential_standard():
    """Exponential/log limits at 0 or ∞: (e^(ax)-1)/bx, ln-based, etc."""
    c1, c2 = rc(SML), rc(SML)
    if c2 == 0: c2 = 1
    sub = rc(["exp_minus_1", "ln_1_plus", "exp_ratio", "log_over_power"])
    if sub == "exp_minus_1":
        f = (sp.exp(c1*x) - 1) / (c2*x)
        a_val = 0
    elif sub == "ln_1_plus":
        f = sp.ln(1 + c1*x) / (c2*x)
        a_val = 0
    elif sub == "exp_ratio":
        f = sp.exp(c1*x) / sp.exp(c2*x)
        a_val = sp.oo
    else:
        n = rc([1, 2, 3])
        f = sp.ln(x) / x**n
        a_val = sp.oo
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "exponential_standard",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_difference_quotient():
    """Difference quotient: lim_{h->0} (f(a+h)-f(a))/h."""
    a_val = rc([-1, 0, 1, 2, 3])
    c1, c2, c3 = rc(SML), rc(NZ), rc(POS)
    funcs = [
        c1*x**2 + c2*x,
        c1*x**3,
        sp.Rational(c1, 1) / x if a_val != 0 else c1*x**2,
        sp.sqrt(x + c3),
        c1*sp.sin(x),
    ]
    base_f = rc(funcs)
    f = (base_f.subs(x, a_val + h) - base_f.subs(x, a_val)) / h
    f = sp.simplify(f)
    L = safe_limit(f, h, 0)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    q = (f"Evaluate the difference quotient limit: "
         f"\\( \\lim_{{h \\to 0}} \\frac{{f({sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)}+h) - f({sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)})}}{{h}} \\) "
         f"where \\( f(x) = {sp.latex(base_f)} \\).")
    return {"q_text": q, "f": f, "a": 0, "type": "difference_quotient",
            "dir": "+-", "var": h, "ans_latex": al, "ans_plain": ap}


def gen_lhopital_basic():
    """L'Hôpital once: 0/0 or ∞/∞ at a point."""
    c1, c2 = rc(SML), rc(SML)
    if c2 == 0: c2 = 1
    sub = rc(["zero_zero_trig", "zero_zero_exp", "inf_inf"])
    if sub == "zero_zero_trig":
        a_val = 0
        f = rc([
            (sp.sin(c1*x) - c1*x*sp.cos(c1*x)) / (x - sp.sin(x)),
            (sp.tan(c1*x) - sp.sin(c1*x)) / x**3,
            (sp.asin(c1*x)) / (c2*x),
            (sp.atan(c1*x)) / (c2*x),
        ])
    elif sub == "zero_zero_exp":
        a_val = 0
        f = rc([
            (sp.exp(c1*x) - 1 - c1*x) / x**2,
            x * sp.ln(x),  # 0·(-∞) form, rewrite as ln(x)/(1/x)
        ])
        if f == x * sp.ln(x):
            a_val = 0
            # need direction from right
            L = safe_limit(f, x, a_val, '+')
            if L is None:
                return None
            al, ap = fmt_ans(sp.simplify(L))
            q = f"Evaluate the limit: \\( \\lim_{{x \\to 0^+}} {sp.latex(f)} \\)"
            return {"q_text": q, "f": f, "a": a_val, "type": "lhopital_basic",
                    "dir": "+", "var": x, "ans_latex": al, "ans_plain": ap}
    else:
        a_val = sp.oo
        n1, n2 = rc([1, 2, 3]), rc([1, 2, 3])
        f = rc([
            x**n1 / sp.exp(x),
            sp.ln(x)**n1 / x**n2,
            x**n1 / sp.ln(x)**n2 if n2 > 0 else x / sp.exp(x),
        ])

    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "lhopital_basic",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Section 2.6–2.8: Infinite Limits & Limits at Infinity
# ---------------------------------------------------------------------------

def gen_vertical_asymptote():
    """Limits at vertical asymptotes: lim_{x->a} c/(x-a)^n = ±∞."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    c1 = rc(NZ)
    n = rc([1, 2, 3])
    direction = rc(['+', '-'])

    sub = rc(["simple_pole", "rational_pole", "log_pole"])
    if sub == "simple_pole":
        f = sp.Rational(c1, 1) / (x - a_val)**n
    elif sub == "rational_pole":
        c2 = rc(NZ)
        f = (c1*x + c2) / ((x - a_val) * (x + rc(POS)))
    else:
        # ln(|x - a|)
        f = sp.ln(sp.Abs(x - a_val))
        direction = '+'

    L = safe_limit(f, x, a_val, direction)
    if L is None:
        return None
    al, ap = fmt_ans(L)
    q_dir = "^+" if direction == '+' else "^-"
    q = (f"Evaluate the limit: \\( \\lim_{{x \\to {sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)}{q_dir}}} "
         f"\\left({sp.latex(f)}\\right) \\)")
    return {"q_text": q, "f": f, "a": a_val, "type": "vertical_asymptote",
            "dir": direction, "var": x, "ans_latex": al, "ans_plain": ap}


def gen_rational_at_infinity():
    """Rational functions as x -> ±∞: leading coefficient comparison."""
    c1, c2, c3, c4 = rc(NZ), rc(NZ), rc(NZ), rc(NZ)
    direction = rc(['+-'])  # for oo we use +-
    a_val = rc([sp.oo, -sp.oo])

    sub = rc(["same_degree", "top_heavy", "bottom_heavy", "with_radical"])
    if sub == "same_degree":
        n = rc([1, 2, 3])
        f = (c1*x**n + c2*x**(n-1) + 1) / (c3*x**n + c4)
    elif sub == "top_heavy":
        f = (c1*x**3 + c2) / (c3*x**2 + c4*x + 1)
    elif sub == "bottom_heavy":
        f = (c1*x + c2) / (c3*x**2 + c4*x + 1)
    else:
        # sqrt(ax^2 + b) / (cx + d) ~ |a|^{1/2}/c
        a_coeff = rc(POS)
        f = sp.sqrt(a_coeff*x**2 + rc(NZ)) / (c3*x + c4)

    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "rational_at_infinity",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_transcendental_at_infinity():
    """Transcendental limits at ∞: e^{g(x)}, ln(g(x)), mixed."""
    c1 = rc(NZ)
    c2 = rc(POS)
    a_val = sp.oo

    sub = rc(["exp_dominates", "log_slow", "exp_decay", "mixed_exp_poly",
              "arctan_inf", "exp_difference"])
    if sub == "exp_dominates":
        f = sp.exp(c1*x) / (x**rc([2, 3, 4]) + 1)
    elif sub == "log_slow":
        f = sp.ln(x**c2 + 1) / x
    elif sub == "exp_decay":
        f = x**rc([2, 3]) * sp.exp(-x)
    elif sub == "mixed_exp_poly":
        f = (sp.exp(x) + x**2) / (sp.exp(x) - x)
    elif sub == "arctan_inf":
        f = sp.atan(c1*x)
    else:
        # e^x - e^{x-a}
        f = sp.exp(x) - sp.exp(x - c2)

    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "transcendental_at_infinity",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_radical_at_infinity():
    """Limits with radicals at infinity: sqrt(x^2+ax) - x, etc."""
    c1 = rc(NZ)
    a_val = rc([sp.oo, -sp.oo])

    sub = rc(["sqrt_minus_x", "sqrt_diff", "nested_sqrt"])
    if sub == "sqrt_minus_x":
        f = sp.sqrt(x**2 + c1*x) - x if a_val == sp.oo else sp.sqrt(x**2 + c1*x) + x
    elif sub == "sqrt_diff":
        c2 = rc(POS)
        f = sp.sqrt(x + c1) - sp.sqrt(x + c2)
        a_val = sp.oo
    else:
        f = sp.sqrt(sp.sqrt(x**4 + c1*x**2) - x**2)
        a_val = sp.oo

    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "radical_at_infinity",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Section 2.9: Continuity
# ---------------------------------------------------------------------------

def gen_piecewise_continuity():
    """Find k so that a piecewise function is continuous at x = a."""
    a_val = rc([-1, 0, 1, 2, 3])
    c1, c2, c3 = rc(NZ), rc(NZ), rc(POS)

    sub = rc(["poly_poly", "trig_poly", "exp_poly"])
    if sub == "poly_poly":
        left_expr = c1*x**2 + c2*x + k_sym
        right_expr = c3*x + rc(NZ)
    elif sub == "trig_poly":
        left_expr = k_sym * sp.sin(x - a_val) / (x - a_val) if a_val != 0 else k_sym * sp.sin(x) / x
        right_expr = c1*x + c3
        # Left limit as x->a is k (since sin(u)/u -> 1)
    else:
        left_expr = k_sym * sp.exp(x - a_val)
        right_expr = c1*x**2 + c2

    # For continuity: lim_{x->a-} left = lim_{x->a+} right = f(a)
    right_val = right_expr.subs(x, a_val)
    if not right_val.is_finite:
        return None

    # Solve for k: left_limit = right_val
    try:
        left_lim = sp.limit(left_expr, x, a_val, '-')
        k_solutions = sp.solve(left_lim - right_val, k_sym)
        if not k_solutions:
            return None
        k_val = k_solutions[0]
        if not sp.simplify(k_val).is_finite:
            return None
    except Exception:
        return None

    left_disp = sp.latex(left_expr)
    right_disp = sp.latex(right_expr)
    a_disp = sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)
    q = (f"Find the value of \\( k \\) that makes the function continuous at "
         f"\\( x = {a_disp} \\): "
         f"\\( f(x) = \\begin{{cases}} {left_disp} & x < {a_disp} "
         f"\\\\ {right_disp} & x \\ge {a_disp} \\end{{cases}} \\)")
    al = sp.latex(sp.simplify(k_val))
    ap = str(sp.simplify(k_val))
    return {"q_text": q, "f": left_expr, "a": a_val, "type": "piecewise_continuity",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_ivt_application():
    """IVT: show a root exists on [a,b] or find guaranteed interval."""
    a_val = rc([0, 1, -1, 2])
    b_val = a_val + rc([1, 2, 3])
    c1, c2 = rc(NZ), rc(NZ)

    funcs = [
        x**3 + c1*x + c2,
        sp.cos(x) - x + c2,
        sp.exp(x) + c1*x - 3,
        x**2 + c1*x + c2,
    ]
    expr = rc(funcs)
    try:
        fa = sp.simplify(expr.subs(x, a_val))
        fb = sp.simplify(expr.subs(x, b_val))
        if not fa.is_finite or not fb.is_finite:
            return None
        # Need sign change for IVT to guarantee root
        if fa * fb >= 0:
            return None
    except Exception:
        return None

    a_disp = sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)
    b_disp = sp.latex(sp.Integer(b_val) if isinstance(b_val, int) else b_val)
    q = (f"Let \\( f(x) = {sp.latex(expr)} \\). "
         f"Show that by the Intermediate Value Theorem, "
         f"\\( f \\) has at least one root on \\( [{a_disp}, {b_disp}] \\). "
         f"Compute \\( f({a_disp}) \\) and \\( f({b_disp}) \\).")
    al = (f"f({a_disp}) = {sp.latex(fa)},\\; f({b_disp}) = {sp.latex(fb)}"
         "\\text{ (sign change} \\Rightarrow \\text{root exists)}")
    ap = f"f({a_val}) = {fa}, f({b_val}) = {fb}, sign change => root exists by IVT"
    return {"q_text": q, "f": expr, "a": a_val, "type": "ivt_application",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_removable_discontinuity():
    """Identify removable discontinuity and find the limit."""
    a_val = rc([-3, -2, -1, 1, 2, 3])
    c1 = rc(NZ)
    r2 = rc([v for v in NZ if v != a_val])

    sub = rc(["rational", "trig_sinc"])
    if sub == "rational":
        numer = sp.expand((x - a_val) * (c1*x + r2))
        denom = sp.expand(x - a_val)
        f = numer / denom
    else:
        # sin(x-a)/(x-a) has removable discontinuity at a
        f = sp.sin(x - a_val) / (x - a_val)

    L = safe_limit(f, x, a_val)
    if L is None:
        return None

    a_disp = sp.latex(sp.Integer(a_val) if isinstance(a_val, int) else a_val)
    q = (f"The function \\( f(x) = {sp.latex(f)} \\) has a removable discontinuity at "
         f"\\( x = {a_disp} \\). Find the value that makes \\( f \\) continuous there.")
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": q, "f": f, "a": a_val, "type": "removable_discontinuity",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_continuity_unknown():
    """Find k so limit exists: (x^2 - kx + c) / (x - a)."""
    a_val = rc([1, 2, 3, -1, -2, -3])
    c_val = a_val * rc([1, 2, 3, -1, -2])
    k_val = a_val + c_val // a_val
    f = (x**2 - k_sym*x + c_val) / (x - a_val)
    q = (f"Find the numerical value of the constant \\( k \\) that makes the limit exist: "
         f"\\( \\lim_{{x \\to {sp.latex(sp.Integer(a_val))}}} \\left({sp.latex(f)}\\right) \\)")
    al = sp.latex(sp.Integer(k_val))
    ap = str(k_val)
    return {"q_text": q, "f": f, "a": a_val, "type": "continuity_unknown",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Section 2.10: Formal Definition (ε-δ)
# ---------------------------------------------------------------------------

def gen_epsilon_delta():
    """ε-δ proof: find δ in terms of ε for a linear or simple function."""
    a_val = rc([-2, -1, 0, 1, 2, 3])
    c1 = rc(NZ)
    c2 = rc(NZ)

    sub = rc(["linear", "quadratic_at_point", "sqrt_bound"])
    if sub == "linear":
        # f(x) = c1*x + c2, L = c1*a + c2, |f(x)-L| = |c1||x-a| < ε  =>  δ = ε/|c1|
        f_expr = c1*x + c2
        L_val = c1*a_val + c2
        delta_expr = sp.Symbol('varepsilon') / abs(c1)
        q = (f"Using the \\( \\varepsilon\\text{{-}}\\delta \\) definition, prove that "
             f"\\( \\lim_{{x \\to {sp.latex(sp.Integer(a_val))}}} ({sp.latex(f_expr)}) = {sp.latex(sp.Integer(L_val))} \\). "
             f"Find \\( \\delta \\) in terms of \\( \\varepsilon \\).")
        al = f"\\delta = \\frac{{\\varepsilon}}{{{abs(c1)}}}"
        ap = f"delta = epsilon / {abs(c1)}"
    elif sub == "quadratic_at_point":
        # f(x) = x^2 at x=a, restrict |x-a| < 1 first, then δ = min(1, ε/(2|a|+1))
        f_expr = x**2
        L_val = a_val**2
        q = (f"Using the \\( \\varepsilon\\text{{-}}\\delta \\) definition, prove that "
             f"\\( \\lim_{{x \\to {sp.latex(sp.Integer(a_val))}}} x^2 = {sp.latex(sp.Integer(L_val))} \\). "
             f"Find \\( \\delta \\) in terms of \\( \\varepsilon \\).")
        bound = 2*abs(a_val) + 1
        al = f"\\delta = \\min\\left(1,\\; \\frac{{\\varepsilon}}{{{bound}}}\\right)"
        ap = f"delta = min(1, epsilon / {bound})"
    else:
        # f(x) = sqrt(x) at x = a (a>0)
        a_val = rc([1, 4, 9])
        sqrt_a = int(a_val**0.5)
        f_expr = sp.sqrt(x)
        q = (f"Using the \\( \\varepsilon\\text{{-}}\\delta \\) definition, prove that "
             f"\\( \\lim_{{x \\to {a_val}}} \\sqrt{{x}} = {sqrt_a} \\). "
             f"Find \\( \\delta \\) in terms of \\( \\varepsilon \\).")
        al = f"\\delta = \\min\\left({sqrt_a}\\varepsilon,\\; {sqrt_a}^2\\right) = {sqrt_a}\\varepsilon \\text{{ (for small }} \\varepsilon\\text{{)}}"
        ap = f"delta = {sqrt_a} * epsilon (for small epsilon)"

    return {"q_text": q, "f": f_expr, "a": a_val, "type": "epsilon_delta",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Advanced / Scholar
# ---------------------------------------------------------------------------

def gen_squeeze_theorem():
    """Squeeze theorem: x^n sin(c/x) or x^n cos(c/x) -> 0."""
    c1 = rc(NZ)
    n = rc([2, 3])
    f = x**n * rc([sp.sin(c1/x), sp.cos(c1/x)])
    L = safe_limit(f, x, 0)
    if L is None:
        return None
    q = (f"Use the Squeeze Theorem to evaluate: "
         f"\\( \\lim_{{x \\to 0}} {sp.latex(f)} \\)")
    al, ap = fmt_ans(L)
    return {"q_text": q, "f": f, "a": 0, "type": "squeeze_theorem",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_lhopital_advanced():
    """L'Hôpital requiring 2+ applications or algebraic rewriting."""
    c1 = rc(SML)
    a_val = rc([0, sp.oo, sp.pi/2])

    if a_val == 0:
        funcs = [
            (sp.sin(c1*x) - c1*x) / x**3,
            (x - sp.sin(x)) / (x - sp.tan(x)),
            (sp.exp(x) - 1 - x - x**2/2) / x**3,
            1/sp.sin(x) - 1/x,
            (sp.cos(x) - 1 + x**2/2) / x**4,
        ]
    elif a_val == sp.oo:
        funcs = [
            x * sp.sin(c1/x),
            (1 + c1/x)**x,
            x * (sp.ln(x + 1) - sp.ln(x)),
            (x**2 + 1)**(sp.Rational(1, 2)) - x,
        ]
    else:  # pi/2
        funcs = [
            (sp.pi/2 - x) * sp.tan(x),
            sp.cos(x) / (x - sp.pi/2),
        ]
    f = rc(funcs)
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "lhopital_advanced",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_infinity_advanced():
    """Hard limits at infinity: conjugate tricks, (1+1/n)^n style."""
    c1, c2 = rc(NZ), rc(NZ)
    a_val = rc([sp.oo, -sp.oo])

    funcs = [
        sp.sqrt(x**2 + c1*x) - x if a_val == sp.oo else sp.sqrt(x**2 + c1*x) + x,
        (1 + c1/x)**x,
        (1 + c1/x + c2/x**2)**x,
        sp.Rational(c1, 1) * x * (sp.exp(1/x) - 1),
    ]
    f = rc(funcs)
    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "infinity_advanced",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_exponent_indeterminate():
    """Indeterminate exponent forms: 1^∞, 0^0, ∞^0."""
    a_val = rc([0, sp.oo, 1])
    c1 = rc(SML)
    c2 = rc(POS)
    direction = '+-'

    if a_val == 0:
        funcs = [
            (sp.cos(x))**(1/x**2),
            x**x,
            (sp.sin(x)/x)**(1/x**2),
            (1 + c1*x)**(1/x),
            x**(sp.sin(x)),
        ]
        f = rc(funcs)
        if f == x**x or f == x**(sp.sin(x)):
            direction = '+'
    elif a_val == sp.oo:
        funcs = [
            x**(1/x),
            (1 + c1/x + c2/x**2)**x,
            x**(c1/sp.ln(x)),
        ]
        f = rc(funcs)
    else:  # a = 1
        funcs = [
            x**(1/(1-x)),
            x**(sp.Rational(1, 1)/(x - 1)),
            (2 - x)**(sp.tan(sp.pi*x/2)),
        ]
        f = rc(funcs)

    L = safe_limit(f, x, a_val, direction)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "exponent_indeterminate",
            "dir": direction, "var": x, "ans_latex": al, "ans_plain": ap}


# ---------------------------------------------------------------------------
# Graph Reading Questions — helpers
# ---------------------------------------------------------------------------

_Y_POOL = list(range(-5, 8))  # [-5, 7]

def _pick_y(used):
    """Pick an unused integer y-value from _Y_POOL."""
    avail = [v for v in _Y_POOL if v not in used]
    if not avail:
        avail = _Y_POOL  # fallback: allow repeats
    y = random.choice(avail)
    used.add(y)
    return y


def _fit_segment(lo, hi, y_lo, y_hi, kind=None):
    """Return a sympy expression (in x) that hits (lo, y_lo) and (hi, y_hi).
    kind: 'linear' or 'quadratic'. If None, randomly chosen (70/30)."""
    if kind is None:
        kind = 'linear' if random.random() < 0.70 else 'quadratic'
    if kind == 'linear' or lo == hi:
        # y = mx + b  through the two points
        if hi == lo:
            return sp.Integer(y_lo)
        m = sp.Rational(y_hi - y_lo, hi - lo)
        b = sp.Rational(y_lo) - m * lo
        return sp.simplify(m * x + b)
    else:
        # y = a*x^2 + b*x + c — pick a random nonzero 'a', solve for b, c
        a_coeff = sp.Rational(random.choice([-1, 1]), random.choice([1, 2]))
        # y_lo = a*lo^2 + b*lo + c
        # y_hi = a*hi^2 + b*hi + c
        # Two equations, two unknowns (b, c)
        b_sym, c_sym = sp.symbols('_b _c')
        eqs = [
            a_coeff * lo**2 + b_sym * lo + c_sym - y_lo,
            a_coeff * hi**2 + b_sym * hi + c_sym - y_hi,
        ]
        sol = sp.solve(eqs, [b_sym, c_sym])
        if not sol:
            # Fallback to linear
            return _fit_segment(lo, hi, y_lo, y_hi, kind='linear')
        return sp.simplify(a_coeff * x**2 + sol[b_sym] * x + sol[c_sym])


def _build_graph_def():
    """Build a random piecewise graph definition with 2-4 special join points."""
    domain = (-4, 6)
    n_joins = random.randint(2, 4)
    interior = list(range(domain[0] + 1, domain[1]))  # -3..5
    joins = sorted(random.sample(interior, n_joins))

    used_y = set()
    # Assign feature types
    feature_weights = ['jump'] * 35 + ['removable'] * 25 + ['continuous'] * 25 + ['infinite'] * 15
    features = [random.choice(feature_weights) for _ in joins]
    # Guarantee at least one non-continuous
    if all(f == 'continuous' for f in features):
        features[random.randint(0, len(features) - 1)] = random.choice(['jump', 'removable'])

    # Build special points and determine y-values at each boundary
    # boundary_y[i] = (y_left_limit, y_right_limit, f_val) at joins[i]
    special_points = []
    boundary_y = []

    for i, (jx, feat) in enumerate(zip(joins, features)):
        if feat == 'jump':
            y_left = _pick_y(used_y)
            y_right = _pick_y(used_y)
            f_val = random.choice([y_left, y_right])
            sp_info = {
                "x": jx, "f_val": f_val,
                "lim_left": y_left, "lim_right": y_right,
                "lim_both": None, "disc_type": "jump",
            }
        elif feat == 'removable':
            y_lim = _pick_y(used_y)
            f_val = _pick_y(used_y)  # different from limit
            sp_info = {
                "x": jx, "f_val": f_val,
                "lim_left": y_lim, "lim_right": y_lim,
                "lim_both": y_lim, "disc_type": "removable",
            }
        elif feat == 'continuous':
            y_val = _pick_y(used_y)
            sp_info = {
                "x": jx, "f_val": y_val,
                "lim_left": y_val, "lim_right": y_val,
                "lim_both": y_val, "disc_type": "continuous",
            }
        else:  # infinite
            f_val = None
            sp_info = {
                "x": jx, "f_val": None,
                "lim_left": None, "lim_right": None,
                "lim_both": None, "disc_type": "infinite",
            }

        special_points.append(sp_info)
        boundary_y.append(sp_info)

    # Build segment list
    # Boundaries: domain[0], joins[0], joins[1], ..., joins[-1], domain[1]
    edges = [domain[0]] + joins + [domain[1]]
    segments = []
    isolated_points = []

    # We need y-values at each edge (left-endpoint of next segment)
    # For domain endpoints, pick a y
    y_at_domain_start = _pick_y(used_y)

    # Determine y-value for the right side of each edge
    # edge_right_y[i] = y-value of the curve as we START the segment [edges[i], edges[i+1]]
    # edge_left_y[i+1] = y-value of the curve as we END the segment [edges[i], edges[i+1]]

    for seg_idx in range(len(edges) - 1):
        seg_lo = edges[seg_idx]
        seg_hi = edges[seg_idx + 1]

        # Determine y at start of this segment
        if seg_idx == 0:
            y_start = y_at_domain_start
        else:
            sp_info = special_points[seg_idx - 1]
            if sp_info["disc_type"] == "infinite":
                # Segment starts after asymptote — pick arbitrary y
                y_start = _pick_y(used_y)
            else:
                y_start = sp_info["lim_right"]

        # Determine y at end of this segment
        if seg_idx == len(edges) - 2:
            y_end = _pick_y(used_y)
        else:
            sp_info = special_points[seg_idx]
            if sp_info["disc_type"] == "infinite":
                y_end = _pick_y(used_y)
            else:
                y_end = sp_info["lim_left"]

        # For infinite type at either end, use a rational pole expression
        left_is_inf = (seg_idx > 0 and
                       special_points[seg_idx - 1]["disc_type"] == "infinite")
        right_is_inf = (seg_idx < len(special_points) and
                        special_points[seg_idx]["disc_type"] == "infinite"
                        if seg_idx < len(special_points) else False)

        if left_is_inf or right_is_inf:
            # Use a simple rational form: c/(x - pole) + offset
            if right_is_inf:
                pole = seg_hi
                sign = random.choice([-1, 1])
                expr = sp.Rational(sign, 1) / (x - pole) + y_start
            else:
                pole = seg_lo
                sign = random.choice([-1, 1])
                expr = sp.Rational(sign, 1) / (x - pole) + y_end
        else:
            expr = _fit_segment(seg_lo, seg_hi, y_start, y_end)

        # Determine open/closed for endpoints
        left_open = False
        right_open = True  # default: right-open for interior joins

        if seg_idx == 0:
            left_open = False
        else:
            sp_info = special_points[seg_idx - 1]
            if sp_info["disc_type"] == "infinite":
                left_open = True
            elif sp_info["disc_type"] == "jump":
                # f_val is defined — if it equals this side's limit, closed
                left_open = (sp_info["f_val"] != sp_info["lim_right"])
            elif sp_info["disc_type"] == "removable":
                # The limit point is open; isolated point has the f_val
                left_open = True
            else:  # continuous
                left_open = False

        if seg_idx == len(edges) - 2:
            right_open = False
        else:
            sp_info = special_points[seg_idx]
            if sp_info["disc_type"] == "infinite":
                right_open = True
            elif sp_info["disc_type"] == "jump":
                right_open = (sp_info["f_val"] != sp_info["lim_left"])
            elif sp_info["disc_type"] == "removable":
                right_open = True
            else:  # continuous
                right_open = False

        segments.append({
            "expr": expr,
            "interval": (seg_lo, seg_hi),
            "left_open": left_open,
            "right_open": right_open,
        })

    # Build isolated points for removable discontinuities and jump-defined values
    for sp_info in special_points:
        if sp_info["disc_type"] == "removable" and sp_info["f_val"] is not None:
            isolated_points.append({"x": sp_info["x"], "y": sp_info["f_val"]})
        elif sp_info["disc_type"] == "jump":
            # The f_val might already be represented by a closed endpoint
            # Only add isolated point if f_val differs from both limits
            # (it always equals one side, so one endpoint is closed — no isolated point needed)
            pass

    return {
        "domain": domain,
        "segments": segments,
        "isolated_points": isolated_points,
        "special_points": special_points,
    }


def _fmt_limit_val(val):
    """Format a limit value for LaTeX. None→DNE, ±oo→∞."""
    if val is None:
        return "\\text{DNE}", "DNE"
    if val == sp.oo or val == float('inf'):
        return "\\infty", "Infinity"
    if val == -sp.oo or val == float('-inf'):
        return "-\\infty", "-Infinity"
    return str(val), str(val)


# ---------------------------------------------------------------------------
# Graph Reading Question Generators
# ---------------------------------------------------------------------------

def gen_graph_limits_simple():
    """Given a graph, find f(a) and lim x→a for each marked point."""
    gd = _build_graph_def()
    # Only include non-continuous special points (and 1 continuous for contrast)
    pts = [sp for sp in gd["special_points"] if sp["disc_type"] != "infinite"]
    if not pts:
        return None

    point_labels = ", ".join(str(sp["x"]) for sp in pts)
    q_text = (
        "The graph of \\( f(x) \\) is given below. "
        "For each value of \\( a \\), determine \\( f(a) \\) and "
        "\\( \\displaystyle\\lim_{x \\to a} f(x) \\)."
    )

    # Build answer table
    rows = []
    plain_parts = []
    for sp_info in pts:
        a = sp_info["x"]
        fv_l, fv_p = _fmt_limit_val(sp_info["f_val"])
        lim_l, lim_p = _fmt_limit_val(sp_info["lim_both"])
        rows.append(f"{a} & {fv_l} & {lim_l}")
        plain_parts.append(f"x={a}: f({a})={fv_p}, lim={lim_p}")

    ans_latex = (
        "\\displaystyle \\begin{array}{c|cc}\n"
        "a & f(a) & \\lim \\\\ \\hline\n"
        + " \\\\\n".join(rows) +
        "\n\\end{array}"
    )
    ans_plain = " | ".join(plain_parts)

    return {
        "q_text": q_text,
        "f": sp.Symbol('f'),  # placeholder
        "a": pts[0]["x"],
        "type": "graph_limits_simple",
        "dir": "+-",
        "var": x,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "graph_def": gd,
        "point_labels": point_labels,
    }


def gen_graph_limits_full():
    """Given a graph, find f(a), lim⁻, lim⁺, lim for each marked point."""
    gd = _build_graph_def()
    pts = [sp for sp in gd["special_points"] if sp["disc_type"] != "infinite"]
    if not pts:
        return None

    point_labels = ", ".join(str(sp["x"]) for sp in pts)
    q_text = (
        "The graph of \\( f(x) \\) is given below. "
        "For each marked value \\( a \\), determine \\( f(a) \\), "
        "\\( \\lim_{x \\to a^-} f(x) \\), "
        "\\( \\lim_{x \\to a^+} f(x) \\), and "
        "\\( \\lim_{x \\to a} f(x) \\)."
    )

    rows = []
    plain_parts = []
    for sp_info in pts:
        a = sp_info["x"]
        fv_l, fv_p = _fmt_limit_val(sp_info["f_val"])
        ll_l, ll_p = _fmt_limit_val(sp_info["lim_left"])
        lr_l, lr_p = _fmt_limit_val(sp_info["lim_right"])
        lb_l, lb_p = _fmt_limit_val(sp_info["lim_both"])
        rows.append(f"{a} & {fv_l} & {ll_l} & {lr_l} & {lb_l}")
        plain_parts.append(
            f"x={a}: f({a})={fv_p}, lim-={ll_p}, lim+={lr_p}, lim={lb_p}"
        )

    ans_latex = (
        "\\displaystyle \\begin{array}{c|cccc}\n"
        "a & f(a) & \\lim^{-} & \\lim^{+} & \\lim \\\\ \\hline\n"
        + " \\\\\n".join(rows) +
        "\n\\end{array}"
    )
    ans_plain = " | ".join(plain_parts)

    return {
        "q_text": q_text,
        "f": sp.Symbol('f'),
        "a": pts[0]["x"],
        "type": "graph_limits_full",
        "dir": "+-",
        "var": x,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "graph_def": gd,
        "point_labels": point_labels,
    }


def gen_graph_discontinuity():
    """Given a graph, list all discontinuities and classify each."""
    gd = _build_graph_def()
    non_cont = [sp for sp in gd["special_points"]
                if sp["disc_type"] != "continuous"]
    if not non_cont:
        return None

    point_labels = ", ".join(str(sp["x"]) for sp in gd["special_points"])
    q_text = (
        "The graph of \\( f(x) \\) is given below. "
        "Identify all points of discontinuity and classify each as "
        "removable, jump, or infinite."
    )

    parts_latex = []
    parts_plain = []
    for sp_info in non_cont:
        dtype = sp_info["disc_type"]
        parts_latex.append(f"x = {sp_info['x']} \\text{{ ({dtype})}}")
        parts_plain.append(f"x={sp_info['x']} ({dtype})")

    ans_latex = ",\\quad ".join(parts_latex)
    ans_plain = ", ".join(parts_plain)

    return {
        "q_text": q_text,
        "f": sp.Symbol('f'),
        "a": non_cont[0]["x"],
        "type": "graph_discontinuity",
        "dir": "+-",
        "var": x,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "graph_def": gd,
        "point_labels": point_labels,
    }


def gen_dne_absolute_value():
    """Absolute value limits that do not exist (left ≠ right)."""
    a_val = rc([-2, -1, 0, 1, 2])
    c1 = rc(NZ)

    sub = rc(["abs_over_linear", "abs_over_product"])
    if sub == "abs_over_linear":
        f = sp.Abs(x - a_val) / (x - a_val)
    else:
        c2 = rc([v for v in NZ if v != a_val])
        f = sp.Abs(x - a_val) / ((x - a_val) * (x - c2))

    L_plus = safe_limit(f, x, a_val, '+')
    L_minus = safe_limit(f, x, a_val, '-')
    if L_plus is None or L_minus is None:
        return None
    if L_plus == L_minus:
        return None  # Not DNE, skip

    al, ap = fmt_dne()
    return {"q_text": None, "f": f, "a": a_val, "type": "dne_absolute_value",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


def gen_absolute_value_limit():
    """Absolute value limits that DO exist."""
    a_val = rc([-2, -1, 0, 1, 2])
    c1, c2 = rc(NZ), rc(POS)

    sub = rc(["abs_quadratic", "abs_over_abs"])
    if sub == "abs_quadratic":
        f = sp.Abs(x - a_val) * (x + c1)
    else:
        # |x^2 - a^2| / |x - a| = |x + a|
        f = sp.Abs(x**2 - a_val**2) / sp.Abs(x - a_val) if a_val != 0 else sp.Abs(x**2 + c1*x) / sp.Abs(x)

    L = safe_limit(f, x, a_val)
    if L is None:
        return None
    al, ap = fmt_ans(sp.simplify(L))
    return {"q_text": None, "f": f, "a": a_val, "type": "absolute_value_limit",
            "dir": "+-", "var": x, "ans_latex": al, "ans_plain": ap}


# ===========================================================================
# Difficulty → Type mapping
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "direct_evaluation", "rational_factoring",
        "one_sided_limit", "secant_slope", "trig_standard",
    ],
    "medium": [
        "radical_rationalizing", "difference_quotient",
        "tangent_line", "avg_vs_instantaneous_rate",
        "exponential_standard", "lhopital_basic",
        "rational_at_infinity", "removable_discontinuity",
        "graph_limits_simple",
    ],
    "hard": [
        "vertical_asymptote", "transcendental_at_infinity",
        "radical_at_infinity", "piecewise_continuity",
        "ivt_application", "continuity_unknown",
        "squeeze_theorem", "lhopital_advanced",
        "dne_absolute_value", "absolute_value_limit",
        "graph_limits_full", "graph_discontinuity",
    ],
    "scholar": [
        "infinity_advanced", "exponent_indeterminate",
        "epsilon_delta",
    ],
}

GENERATORS = {
    # Section 2.1
    "secant_slope":                gen_secant_slope,
    "tangent_line":                gen_tangent_line,
    "avg_vs_instantaneous_rate":   gen_avg_vs_instantaneous_rate,
    # Section 2.2–2.5
    "direct_evaluation":           gen_direct_evaluation,
    "rational_factoring":          gen_rational_factoring,
    "radical_rationalizing":       gen_radical_rationalizing,
    "one_sided_limit":             gen_one_sided_limit,
    "trig_standard":               gen_trig_standard,
    "exponential_standard":        gen_exponential_standard,
    "difference_quotient":         gen_difference_quotient,
    "lhopital_basic":              gen_lhopital_basic,
    # Section 2.6–2.8
    "vertical_asymptote":          gen_vertical_asymptote,
    "rational_at_infinity":        gen_rational_at_infinity,
    "transcendental_at_infinity":  gen_transcendental_at_infinity,
    "radical_at_infinity":         gen_radical_at_infinity,
    # Section 2.9
    "piecewise_continuity":        gen_piecewise_continuity,
    "ivt_application":             gen_ivt_application,
    "removable_discontinuity":     gen_removable_discontinuity,
    "continuity_unknown":          gen_continuity_unknown,
    # Section 2.10
    "epsilon_delta":               gen_epsilon_delta,
    # Advanced
    "squeeze_theorem":             gen_squeeze_theorem,
    "lhopital_advanced":           gen_lhopital_advanced,
    "infinity_advanced":           gen_infinity_advanced,
    "exponent_indeterminate":      gen_exponent_indeterminate,
    "dne_absolute_value":          gen_dne_absolute_value,
    "absolute_value_limit":        gen_absolute_value_limit,
    # Graph Reading
    "graph_limits_simple":         gen_graph_limits_simple,
    "graph_limits_full":           gen_graph_limits_full,
    "graph_discontinuity":         gen_graph_discontinuity,
}

# ===========================================================================
# Main generation loop
# ===========================================================================

def generate_limit_questions(num_questions):
    questions = []
    seen_signatures = set()
    attempts = 0
    max_attempts = num_questions * 50

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1

        # Difficulty distribution
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
            dir_limit = rec["dir"]
            limit_var = rec["var"]
            ans_latex = rec["ans_latex"]
            ans_plain = rec["ans_plain"]
            q_text    = rec.get("q_text")

            # Deduplication
            try:
                sig = (sp.srepr(f), sp.srepr(a_val) if a_val is not None else "_",
                       dir_limit, str(limit_var), q_type)
            except Exception:
                sig = (str(f)[:120], str(a_val), q_type)
            if sig in seen_signatures:
                continue

            # If no custom question text, build standard format
            if q_text is None:
                f_latex = sp.latex(f)
                a_latex = sp.latex(a_val)
                var_latex = sp.latex(limit_var)
                if dir_limit == '+':
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}^+}} \\left({f_latex}\\right) \\)"
                elif dir_limit == '-':
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}^-}} \\left({f_latex}\\right) \\)"
                else:
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}}} \\left({f_latex}\\right) \\)"

            # Compute sympy limit for verification if ans not already set
            if not ans_latex:
                try:
                    L = sp.limit(f, limit_var, a_val, dir=dir_limit)
                    if L.has(sp.zoo) or L == sp.nan:
                        continue
                    ans_latex, ans_plain = fmt_ans(L)
                except ValueError as ve:
                    if "does not exist" in str(ve).lower():
                        ans_latex, ans_plain = fmt_dne()
                    else:
                        continue

            # Graph reading questions have special fields
            is_graph = q_type in ("graph_limits_simple",
                                  "graph_limits_full",
                                  "graph_discontinuity")

            entry = {
                "id":              len(questions) + 1,
                "type":            q_type,
                "difficulty":      difficulty,
                "function_latex":  "\\text{(see graph)}" if is_graph else sp.latex(f),
                "point_latex":     rec.get("point_labels", sp.latex(a_val)),
                "question_text":   q_text,
                "answer_latex":    ans_latex,
                "answer_plain":    ans_plain,
            }

            # Generate SVG figure if applicable
            if _fig_gen_available and q_type in _FIGURE_TYPES_LIMITS:
                try:
                    fig_path = _fig_gen.generate_figure_for_limit(
                        q_type, rec, entry["id"], _figures_dir_limits)
                    if fig_path:
                        entry["figure_svg"] = fig_path
                except Exception:
                    pass

            questions.append(entry)
            seen_signatures.add(sig)

            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} limit questions...")

        except Exception:
            pass

    return questions


if __name__ == "__main__":
    print("Generating 2000 Limit questions...")
    questions = generate_limit_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/limits.json"
    with open(output_file, "w") as f_out:
        json.dump({
            "topic": "Limits",
            "description": "Comprehensive Practice Worksheet for Limits. Covers: secant slopes, tangent lines, rates of change, factoring, rationalizing, one-sided limits, trig limits, L'Hopital's Rule, infinite limits, limits at infinity, piecewise continuity, IVT, epsilon-delta proofs, squeeze theorem, indeterminate exponent forms, and DNE limits.",
            "questions": questions
        }, f_out, separators=(',', ':'))

    # Stats
    from collections import Counter
    type_counts = Counter(q["type"] for q in questions)
    diff_counts = Counter(q["difficulty"] for q in questions)

    print(f"\nDone — {len(questions)} problems → {output_file}\n")
    print(f"By type ({len(type_counts)} types):")
    for t, c in type_counts.most_common():
        print(f"  {t}: {c}")
    print(f"\nBy difficulty:")
    for d, c in diff_counts.most_common():
        print(f"  {d}: {c}")
