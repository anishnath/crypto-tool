"""
Integral Question Bank Generator — Full Coverage
Answers verified by SymPy where applicable.

Indefinite:  Power Rule, Basic Trig & Exponential, Inverse Trig, Hyperbolic,
             Simplify-Then-Integrate, U-Substitution (6 inner variants),
             More Substitution Rule (§5.4 patterns), Integration by Parts (9),
             Tabular IBP, Cyclic IBP, Trig Integrals (sinⁿcosᵐ / tanⁿsecᵐ /
             cotⁿcscᵐ / product-to-sum), Trig Substitution (all 3 radicals),
             Partial Fractions (distinct/repeated/quadratic/improper),
             Completing the Square, Root/Rationalizing Substitution,
             Advanced Trig Combos, Antiderivative IVP, Second Antiderivative IVP

Definite:    Standard, U-Sub with bound transform, Integration by Parts,
             Piecewise Function, Absolute Value, Area Between Curves,
             Riemann Sums (Left / Right / Midpoint, given n),
             Numerical Approximation (Midpoint / Trapezoid / Simpson),
             Average Function Value, MVT for Integrals (find c),
             Volume Disk / Washer Method, Volume Shell Method,
             Improper Integrals, Comparison Test, Odd/Even Symmetry,
             Integral Properties (linearity & additivity),
             FTC Differentiation (basic + chain rule + reverse bounds),
             Scholar Special (Wallis / Gaussian / p-series)
"""

import sympy as sp
import json
import math
import random
import os
import sys

# Figure generation (optional — gracefully degrades if matplotlib unavailable)
_fig_gen_available = False
_fig_gen = None
_FIGURE_TYPES_INTEGRALS = set()
_figures_dir_integrals = ""
try:
    import worksheet_figure_gen as _fig_gen
    _FIGURE_TYPES_INTEGRALS = _fig_gen.FIGURE_TYPES_INTEGRALS
    _figures_dir_integrals = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "calculus",
        "figures", "integrals")
    _fig_gen_available = True
    print("Figure generation enabled.")
except ImportError:
    print("worksheet_figure_gen not available — skipping figure generation.")

x, t = sp.symbols('x t')

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def clean_latex(s: str) -> str:
    return s.replace(r"y{\left(x \right)}", "y").replace(r"\left(x\right)", "(x)")

def safe_integrate(expr, var=x):
    try:
        r = sp.integrate(expr, var)
        if r.has(sp.Integral):
            return None
        return r
    except Exception:
        return None

def safe_definite(expr, var, lo, hi):
    try:
        r = sp.integrate(expr, (var, lo, hi))
        if r.has(sp.Integral) or r.has(sp.zoo) or r.has(sp.nan):
            return None
        if not r.is_finite:
            return None
        return r
    except Exception:
        return None

def fmt_indef(expr):
    lat = clean_latex(sp.latex(expr))
    return lat + " + C", str(expr) + " + C"

def fmt_def(expr):
    return clean_latex(sp.latex(expr)), str(expr)

def rc(pool):
    return random.choice(pool)

NZ  = [-4,-3,-2,-1,1,2,3,4]
POS = [1,2,3,4]
SML = [-2,-1,1,2]

# ===========================================================================
# INDEFINITE INTEGRAL GENERATORS
# ===========================================================================

# ── Basic ──────────────────────────────────────────────────────────────────

def gen_power_rule():
    a, b, c_ = rc(NZ), rc(NZ), rc([-4,-3,-2,-1,0,1,2,3,4])
    v = rc(["poly","radical","neg_exp","mixed"])
    if v == "poly":
        n1, n2 = rc([1,2,3,4,5]), rc([1,2,3])
        expr = a*x**n1 + b*x**n2 + c_
    elif v == "radical":
        p = rc([sp.Rational(1,2), sp.Rational(1,3), sp.Rational(3,2)])
        expr = a*x**p + b*x
    elif v == "neg_exp":
        n = rc([-2,-3,-4])
        expr = a*x**n + b
    else:
        expr = a*x**3 + b*x**sp.Rational(1,2) + c_
    r = safe_integrate(expr)
    if r is None: return None
    q = f"Evaluate the indefinite integral: \\( \\int \\left({sp.latex(expr)}\\right) dx \\)."
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_basic_trig():
    a, b = rc(NZ), rc(NZ)
    funcs = [a*sp.sin(b*x), a*sp.cos(b*x), a*sp.sec(b*x)**2,
             a*sp.csc(b*x)**2, a*sp.sec(b*x)*sp.tan(b*x),
             a*sp.csc(b*x)*sp.cot(b*x), a*sp.tan(b*x), a*sp.cot(b*x)]
    expr = rc(funcs)
    r = safe_integrate(expr)
    if r is None: return None
    q = f"Evaluate the indefinite integral: \\( \\int {sp.latex(expr)} \\, dx \\)."
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_basic_exponential():
    a, b = rc(NZ), rc(NZ)
    if rc([True, False]):
        expr = a * sp.exp(b*x)
    else:
        base = rc([2, 3, 5, 10])
        expr = a * base**x
    r = safe_integrate(expr)
    if r is None: return None
    q = f"Evaluate the indefinite integral: \\( \\int {sp.latex(expr)} \\, dx \\)."
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_inverse_trig():
    a, b = rc(POS), rc(POS)
    funcs = [a/sp.sqrt(1-(b*x)**2), a/(1+(b*x)**2),
             a/sp.sqrt(b**2-x**2), a/(b**2+x**2)]
    expr = rc(funcs)
    r = safe_integrate(expr)
    if r is None: return None
    q = f"Evaluate the indefinite integral: \\( \\int {sp.latex(expr)} \\, dx \\)."
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_hyperbolic():
    a, b = rc(SML), rc(SML)
    funcs = [a*sp.sinh(b*x), a*sp.cosh(b*x), a*sp.tanh(b*x),
             a/sp.sqrt(x**2+b**2)]
    expr = rc(funcs)
    r = safe_integrate(expr)
    if r is None: return None
    q = f"Evaluate the indefinite integral: \\( \\int {sp.latex(expr)} \\, dx \\)."
    al, ap = fmt_indef(r)
    return q, expr, al, ap

# ── NEW: Simplify-Then-Integrate ───────────────────────────────────────────

def gen_simplify_then_integrate():
    """
    Expand products or simplify rational/trig expressions before integrating.
    Mirrors: (t²-1)(4+3t), √z(z²-1/(4z)), (z⁸-6z⁵+…)/z⁴,
             csc(θ)[sin(θ)+csc(θ)], (t³-eᵗ-4)/eᵗ
    """
    v = rc(["product_poly","rational_poly","radical_quotient",
            "trig_csc_expand","trig_sec_expand","exp_quotient"])
    a, b = rc(NZ), rc(SML)

    if v == "product_poly":
        c2, d2, e2 = rc(NZ), rc([-3,-2,0,1,2,3]), rc([-2,-1,0,1,2])
        expr = (a*x + b) * (c2*x**2 + d2*x + e2)
    elif v == "rational_poly":
        n = rc([1,2,3])
        cf = [rc(NZ) for _ in range(4)]
        num = cf[0]*x**4 + cf[1]*x**3 + cf[2]*x**2 + cf[3]*x
        expr = num / x**n
    elif v == "radical_quotient":
        expr = (a*x**3 + abs(b)*sp.sqrt(x)) / sp.sqrt(x)
    elif v == "trig_csc_expand":
        k = rc([1,2])
        expr = sp.csc(k*x) * (sp.sin(k*x) + sp.csc(k*x))
    elif v == "trig_sec_expand":
        k = rc([1,2])
        expr = sp.sec(k*x) * (sp.cos(k*x) + sp.sec(k*x))
    else:
        expr = (x**3 - sp.exp(x) - abs(b)) / sp.exp(x)

    simplified = sp.simplify(expr)
    r = safe_integrate(simplified)
    if r is None: return None
    q = (f"Simplify the integrand first, then evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

# ── NEW: Antiderivative IVP ────────────────────────────────────────────────

def gen_antiderivative_ivp():
    """Given f′(x) and f(a) = b, find f(x)."""
    a, b = rc(NZ), rc(SML)
    ic_x = rc([0,1,-1,2])
    ic_y = rc(list(range(-6,7)))
    v = rc(["poly","exp_trig","poly_exp"])

    if v == "poly":
        fp = a*x**rc([2,3,4,5,6,7,8]) + b*x**rc([1,2,3,4]) + rc(NZ)
    elif v == "exp_trig":
        fp = a*sp.exp(b*x) + rc(SML)*sp.sin(x)
    else:
        fp = a*x**3 + rc(SML)*sp.exp(rc([-1,1])*x) + rc(SML)

    anti = safe_integrate(fp)
    if anti is None: return None
    C = sp.Symbol('C')
    C_vals = sp.solve(anti.subs(x, ic_x) + C - ic_y, C)
    if not C_vals: return None
    f_exact = sp.simplify(anti + C_vals[0])
    q = (f"Determine \\( f(x) \\) given that "
         f"\\( f'(x) = {sp.latex(fp)} \\) and \\( f({ic_x}) = {ic_y} \\).")
    return q, fp, sp.latex(f_exact), str(f_exact)

# ── NEW: Second Antiderivative IVP ─────────────────────────────────────────

def gen_second_antideriv_ivp():
    """Given f″(x) and two ICs (f′(x₀) and f(x₀)), find f(x)."""
    a, b = rc(NZ), rc(SML)
    x0  = rc([0,1])
    h0  = rc(list(range(-4,5)))
    hp0 = rc(list(range(-4,5)))
    v = rc(["poly","cos"])

    if v == "poly":
        fpp = a*x**rc([2,3,4]) + b
    else:
        fpp = a*sp.cos(rc(POS)*x) + b*x

    fp = safe_integrate(fpp)
    if fp is None: return None
    C1 = sp.Symbol('C1')
    C1_vals = sp.solve(fp.subs(x, x0) + C1 - hp0, C1)
    if not C1_vals: return None
    fp_full = fp + C1_vals[0]

    f = safe_integrate(fp_full)
    if f is None: return None
    C2 = sp.Symbol('C2')
    C2_vals = sp.solve(f.subs(x, x0) + C2 - h0, C2)
    if not C2_vals: return None
    f_exact = sp.simplify(f + C2_vals[0])

    q = (f"Determine \\( h(x) \\) given that "
         f"\\( h''(x) = {sp.latex(fpp)} \\), "
         f"\\( h'({x0}) = {hp0} \\), and \\( h({x0}) = {h0} \\).")
    return q, fpp, sp.latex(f_exact), str(f_exact)

# ── Medium ─────────────────────────────────────────────────────────────────

def gen_u_substitution():
    a, b = rc(NZ), rc(NZ)
    n = rc([2,3,4])
    v = rc(["poly_power","exp_inner","trig_inner","sqrt_poly","log_poly","inv_poly"])
    if v == "poly_power":
        inner = a*x**2 + b
        expr = inner**(n-1) * sp.diff(inner, x)
    elif v == "exp_inner":
        inner = a*x**2 + b
        expr = sp.diff(inner, x) * sp.exp(inner)
    elif v == "trig_inner":
        inner = a*x**2 + b
        fn = sp.sin if rc([True,False]) else sp.cos
        expr = sp.diff(inner, x) * fn(inner)
    elif v == "sqrt_poly":
        inner = a*x + b
        expr = sp.diff(inner, x) * sp.sqrt(inner)
    elif v == "log_poly":
        inner = a*x**2 + abs(b)+1
        expr = sp.diff(inner, x) / inner
    else:
        inner = a*x + b
        expr = sp.diff(inner, x) / inner**2
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use u-substitution to evaluate: "
         f"\\( \\int {sp.latex(sp.simplify(expr))} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_more_substitution():
    """
    §5.4 patterns: multi-term same inner, sec²·e^tan, csc·cot / denom,
    rational whose numerator ~ derivative of denom, arctan/arcsin via sub.
    """
    a, b = rc(POS), rc(NZ)
    v = rc(["sec2_exp_tan","rational_deriv","multi_term_same_inner",
            "arctan_form","arcsin_form"])
    if v == "sec2_exp_tan":
        k = rc([1,2])
        inner = rc([1,2,3]) + sp.tan(k*x)
        expr = sp.sec(k*x)**2 * sp.exp(inner)
    elif v == "rational_deriv":
        c1, c2, c3 = rc(POS), rc(POS), rc(NZ)
        denom = c1*x**2 + c2*x + abs(c3)+1
        expr = sp.diff(denom, x) / (2*denom)
    elif v == "multi_term_same_inner":
        k = rc(POS)
        inner = k*x + rc(POS)
        A, B = rc(POS), rc(POS)
        expr = A*sp.sqrt(inner) + B*inner**rc([3,4,5])
    elif v == "arctan_form":
        a2 = rc([1,2,3,4,5,7])
        expr = rc(POS) / (a2**2 + x**2)
    else:
        a2, b2 = rc(POS), rc([1,2,3])
        expr = rc(POS) / sp.sqrt(max(a2,4) - (b2*x)**2)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Evaluate using an appropriate substitution: "
         f"\\( \\int {sp.latex(sp.simplify(expr))} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_integration_by_parts():
    a, b = rc(SML), rc(SML)
    v = rc(["x_exp","x_sin","x_cos","x2_exp","x_ln","x2_sin","arctan","arcsin","ln_only"])
    if v == "x_exp":    expr = a*x*sp.exp(b*x)
    elif v == "x_sin":  expr = a*x*sp.sin(b*x)
    elif v == "x_cos":  expr = a*x*sp.cos(b*x)
    elif v == "x2_exp": expr = a*x**2*sp.exp(b*x)
    elif v == "x_ln":   expr = a*x**rc([1,2])*sp.ln(x)
    elif v == "x2_sin": expr = a*x**2*sp.sin(b*x)
    elif v == "arctan":  expr = a*sp.atan(b*x)
    elif v == "arcsin":  expr = a*sp.asin(x)
    else:               expr = a*sp.ln(abs(b)*x)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use integration by parts to evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_tabular_ibp():
    n = rc([2,3])
    a, b = rc(SML), rc(SML)
    v = rc(["x_n_exp","x_n_sin","x_n_cos"])
    if v == "x_n_exp": expr = x**n * sp.exp(a*x)
    elif v == "x_n_sin":expr = x**n * sp.sin(b*x)
    else:               expr = x**n * sp.cos(b*x)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use tabular (repeated) integration by parts to evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_cyclic_ibp():
    a, b = rc(SML), rc(SML)
    fn = sp.sin if rc([True,False]) else sp.cos
    expr = sp.exp(a*x) * fn(b*x)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Apply integration by parts twice (cyclic method) to evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(sp.simplify(r))
    return q, expr, al, ap

# ── Hard ───────────────────────────────────────────────────────────────────

def gen_trig_integral():
    """sinⁿcosᵐ, tanⁿsecᵐ, cotⁿcscᵐ, product-to-sum."""
    v = rc(["sin_cos_odd","sin_cos_even","tan_sec","cot_csc","product_sum"])
    a = rc([1,2,3])
    if v == "sin_cos_odd":
        n, m = rc([3,5]), rc([0,1,2,4])
        expr = sp.sin(a*x)**n * sp.cos(a*x)**m
    elif v == "sin_cos_even":
        n, m = rc([2,4]), rc([2,4])
        expr = sp.sin(x)**n * sp.cos(x)**m
    elif v == "tan_sec":
        sub = rc(["tan3","tan_sec2","sec3","tan2_sec","tan3_sec4"])
        if sub == "tan3":       expr = sp.tan(a*x)**3
        elif sub == "tan_sec2": expr = sp.tan(a*x)*sp.sec(a*x)**2
        elif sub == "sec3":     expr = sp.sec(a*x)**3
        elif sub == "tan2_sec": expr = sp.tan(a*x)**2*sp.sec(a*x)
        else:                   expr = sp.tan(a*x)**3*sp.sec(a*x)**4
    elif v == "cot_csc":
        n, m = rc([2,3,4]), rc([2,3,4])
        expr = sp.cot(a*x)**n * sp.csc(a*x)**m
    else:
        m_, n_ = rc([1,2,3]), rc([1,2,3])
        expr = sp.sin(m_*x) * sp.cos(n_*x)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Evaluate the trigonometric integral: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(sp.simplify(r))
    return q, expr, al, ap

def gen_advanced_trig_combo():
    """
    Trig integrals that need simplification first.
    e.g. ∫(2+7sin³z)/cos²z dz, ∫[9sin⁵-2cos³]csc⁴ dx (§7.2 problems).
    """
    v = rc(["mixed_over_cos2","mixed_over_sin2","high_power"])
    a = rc([1,2,3])
    if v == "mixed_over_cos2":
        n1, n2 = rc(POS), rc(POS)
        expr = (n1 + n2*sp.sin(a*x)**3) / sp.cos(a*x)**2
    elif v == "mixed_over_sin2":
        n1, n2 = rc(POS), rc(POS)
        expr = (n1 + n2*sp.cos(a*x)**3) / sp.sin(a*x)**2
    else:
        n, m = rc([5,6,7,8]), rc([3,4,5])
        expr = sp.cos(x)**n * sp.sin(x)**m
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Simplify then evaluate the trigonometric integral: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(sp.simplify(r))
    return q, expr, al, ap

def gen_trig_substitution():
    a = rc([1,2,3,4,5])
    v = rc(["sin_sub","tan_sub","sec_sub"])
    if v == "sin_sub":
        n = rc([sp.Rational(1,2), sp.Rational(3,2)])
        expr = (a**2 - x**2)**n
    elif v == "tan_sub":
        n = rc([sp.Rational(1,2), -sp.Rational(1,2)])
        expr = rc([1,2]) * (a**2 + x**2)**n
    else:
        n = rc([sp.Rational(1,2), sp.Rational(3,2)])
        expr = (x**2 - a**2)**n
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use trigonometric substitution to evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

def gen_partial_fractions():
    v = rc(["distinct_linear","repeated_linear","linear_quadratic","improper_rational"])
    if v == "distinct_linear":
        r1, r2 = rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3])
        while r1 == r2: r2 = rc([-3,-2,-1,1,2,3])
        expr = (rc(NZ)*x + rc(SML)) / ((x-r1)*(x-r2))
    elif v == "repeated_linear":
        r1 = rc([-2,-1,1,2])
        expr = (rc(POS)*x + rc(NZ)) / (x-r1)**2
    elif v == "linear_quadratic":
        aa, bb, rr = rc(POS), rc(POS), rc([-2,-1,1,2])
        expr = (aa*x**2+bb) / ((x-rr)*(x**2+rc(POS)))
    else:
        a_, b_ = rc(POS), rc([1,2])
        expr = (x**3 + a_) / (x**2 - b_**2)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use partial fractions to evaluate: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(sp.simplify(r))
    return q, expr, al, ap

def gen_completing_square():
    a_ = rc(POS)
    b_ = rc(NZ)
    c_min = b_**2 // (4*a_) + 1
    c_ = rc(list(range(c_min, c_min+4)))
    quad = a_*x**2 + b_*x + c_
    v = rc(["inv_quad","inv_sqrt_quad"])
    expr = 1/quad if v == "inv_quad" else 1/sp.sqrt(quad)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Evaluate by completing the square: "
         f"\\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(r)
    return q, expr, al, ap

# ── NEW: Root / Rationalizing Substitution ─────────────────────────────────

def gen_root_substitution():
    """
    ∫ c/(b + √(ax+d)) dx  or  ∫ (x+c)/√(ax+d) dx  (§7.5 style).
    Substitution u = √(ax+d) clears the radical.
    """
    a_ = rc(POS)
    d_ = rc(POS) + rc(POS)          # keep inner positive
    c_ = rc(SML)
    b_ = rc(SML)
    inner = a_*x + d_
    v = rc(["inv_root_sum","poly_over_root","x_times_root"])
    if v == "inv_root_sum":
        safe_b = b_ if b_ != 0 else 1
        expr = c_ / (safe_b + sp.sqrt(inner))
    elif v == "poly_over_root":
        expr = (x + c_) / sp.sqrt(inner)
    else:
        expr = x * sp.sqrt(inner)
    r = safe_integrate(expr)
    if r is None: return None
    q = (f"Use the substitution \\( u = \\sqrt{{{sp.latex(inner)}}} \\) "
         f"to evaluate: \\( \\int {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_indef(sp.simplify(r))
    return q, expr, al, ap

# ===========================================================================
# DEFINITE INTEGRAL GENERATORS
# ===========================================================================

# ── Medium ─────────────────────────────────────────────────────────────────

def gen_definite_standard():
    a_, b_ = rc(NZ), rc(SML)
    v = rc(["poly","trig","exp"])
    if v == "poly":
        n = rc([1,2,3,4])
        lo, hi = sorted(random.sample(range(-3,4), 2))
        expr = a_*x**n + b_
    elif v == "trig":
        lo_c = [0, sp.pi/6, sp.pi/4, sp.pi/3]
        hi_c = [sp.pi/2, sp.pi, 2*sp.pi/3]
        lo, hi = rc(lo_c), rc(hi_c)
        while hi <= lo: lo, hi = rc(lo_c), rc(hi_c)
        expr = a_ * rc([sp.sin, sp.cos])(x)
    else:
        lo, hi = 0, rc([1,2])
        expr = a_*sp.exp(b_*x)
    r = safe_definite(expr, x, lo, hi)
    if r is None: return None
    q = (f"Evaluate the definite integral: "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_def(sp.simplify(r))
    return q, expr, al, ap, lo, hi

def gen_definite_u_sub():
    a_, b_ = rc(POS), rc([1,2])
    v = rc(["poly_exp","poly_trig","poly_sqrt"])
    if v == "poly_exp":
        inner = a_*x**2 + b_
        expr = 2*a_*x*sp.exp(inner)
        lo, hi = 0, 1
    elif v == "poly_trig":
        inner = a_*x**2
        expr = 2*a_*x*sp.sin(inner)
        lo, hi = 0, sp.sqrt(sp.pi/(2*a_))
    else:
        inner = a_*x + b_
        expr = sp.sqrt(inner)*a_
        lo, hi = 0, 1
    r = safe_definite(expr, x, lo, hi)
    if r is None: return None
    q = (f"Use u-substitution to evaluate: "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(sp.simplify(expr))} \\, dx \\).")
    al, ap = fmt_def(sp.simplify(r))
    return q, expr, al, ap, lo, hi

def gen_definite_by_parts():
    a_, b_ = rc([1,2]), rc(SML)
    v = rc(["x_exp","x_sin","x_cos","x_ln"])
    lo, hi = 0, 1
    if v == "x_exp":  expr = a_*x*sp.exp(b_*x)
    elif v == "x_sin":expr = a_*x*sp.sin(b_*x)
    elif v == "x_cos":expr = a_*x*sp.cos(b_*x)
    else:             lo, hi, expr = 1, sp.E, a_*sp.ln(x)
    r = safe_definite(expr, x, lo, hi)
    if r is None: return None
    q = (f"Use integration by parts to evaluate: "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_def(sp.simplify(r))
    return q, expr, al, ap, lo, hi

# ── NEW: Piecewise Definite ─────────────────────────────────────────────────

def gen_piecewise_definite():
    """∫ piecewise function over interval crossing the split point."""
    split = rc([0,1,-1,2])
    a_, b_ = rc(SML), rc(SML)
    v = rc(["linear_quad","exp_linear","linear_const"])
    if v == "linear_quad":
        g_above = a_*x + b_
        g_below = b_ - a_*x**2
    elif v == "exp_linear":
        g_above = a_*x
        g_below = b_*sp.exp(x)
    else:
        g_above = a_*x**2
        g_below = b_*x + rc(SML)
    lo = split - rc([1,2])
    hi = split + rc([1,2,3])
    p1 = safe_definite(g_below, x, lo, split)
    p2 = safe_definite(g_above, x, split, hi)
    if p1 is None or p2 is None: return None
    result = sp.simplify(p1+p2)
    g1l, g2l = sp.latex(g_above), sp.latex(g_below)
    q = (f"Evaluate \\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} f(x)\\,dx \\) where "
         f"\\( f(x) = \\begin{{cases}} {g1l} & x > {split} \\\\ "
         f"{g2l} & x \\le {split} \\end{{cases}} \\).")
    al, ap = fmt_def(result)
    return q, g_above, al, ap, lo, hi

# ── NEW: Absolute Value Definite ────────────────────────────────────────────

def gen_absolute_value_definite():
    """∫|f(x)|dx over interval containing the sign change."""
    v = rc(["linear_abs","quadratic_abs"])
    if v == "linear_abs":
        a_, b_ = rc(POS), rc(NZ)
        inner = a_*x + b_
        zero = sp.Rational(-b_, a_)
        ext = rc([1,2,3])
        lo, hi = zero - ext, zero + ext
        p1 = safe_definite(-inner, x, lo, zero)
        p2 = safe_definite(inner,  x, zero, hi)
        if p1 is None or p2 is None: return None
        result = sp.simplify(p1+p2)
        inner_lat = sp.latex(inner)
    else:
        a_ = rc([1,2,3])
        inner = x**2 - a_**2
        lo, hi = -a_-1, a_+1
        p1 = safe_definite(inner,   x, lo,    -a_)
        p2 = safe_definite(-inner,  x, -a_,   a_)
        p3 = safe_definite(inner,   x, a_,    hi)
        if any(p is None for p in [p1,p2,p3]): return None
        result = sp.simplify(p1+p2+p3)
        inner_lat = sp.latex(inner)
    q = (f"Evaluate the definite integral: "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} \\left|{inner_lat}\\right| \\, dx \\).")
    al, ap = fmt_def(result)
    return q, inner, al, ap, lo, hi

# ── NEW: Average Function Value ─────────────────────────────────────────────

def gen_average_value():
    """f_avg = 1/(b-a) ∫ₐᵇ f(x) dx."""
    a_, b_ = rc(NZ), rc(SML)
    v = rc(["poly","trig","exp","mixed"])
    if v == "poly":
        lo, hi = rc([0,1,-1]), rc([2,3,4])
        while hi <= lo: hi = rc([2,3,4])
        expr = a_*x**rc([2,3]) + b_*x
    elif v == "trig":
        lo, hi = 0, sp.pi
        expr = a_*sp.sin(x)
    elif v == "exp":
        lo, hi = 0, 1
        expr = a_*sp.exp(b_*x)
    else:
        lo, hi = -1, 1
        expr = a_*x**2 + b_
    r = safe_definite(expr, x, lo, hi)
    if r is None: return None
    f_avg = sp.simplify(r / (hi - lo))
    q = (f"Find the average value of \\( f(x) = {sp.latex(expr)} \\) "
         f"on the interval \\( [{sp.latex(lo)},\\, {sp.latex(hi)}] \\).")
    al, ap = fmt_def(f_avg)
    return q, expr, al, ap, lo, hi

# ── NEW: MVT for Integrals ──────────────────────────────────────────────────

def gen_mvt_integral():
    """Find c in [a,b] where f(c) = f_avg."""
    a_ = rc(POS)
    lo, hi = 0, rc([1,2,3])
    v = rc(["poly2","poly3","linear"])
    if v == "poly2":  expr = a_*x**2
    elif v == "poly3":expr = a_*x**3
    else:             expr = a_*x + rc(SML)
    r = safe_definite(expr, x, lo, hi)
    if r is None: return None
    f_avg = sp.simplify(r / (hi - lo))
    c_vals = sp.solve(expr - f_avg, x)
    c_real = [cv for cv in c_vals
              if cv.is_real and float(lo) <= float(cv.evalf()) <= float(hi)]
    if not c_real: return None
    c_ans = sp.simplify(c_real[0])
    q = (f"For \\( f(x) = {sp.latex(expr)} \\) on \\( [{sp.latex(lo)}, {sp.latex(hi)}] \\), "
         f"find the average value \\( f_{{avg}} \\) and the value(s) of \\( c \\) "
         f"guaranteed by the MVT for Integrals.")
    al = f"f_{{avg}} = {sp.latex(f_avg)},\\quad c = {sp.latex(c_ans)}"
    ap = f"f_avg = {f_avg}, c = {c_ans}"
    return q, expr, al, ap, lo, hi

# ── NEW: Riemann Sums ───────────────────────────────────────────────────────

def gen_riemann_sum():
    """Left / Right / Midpoint Riemann sum with explicit n."""
    n = rc([4,6])
    method = rc(["right","left","midpoint"])
    a_, b_ = rc([1,2]), rc([-2,-1,0,1,2])
    v = rc(["poly","trig","radical"])
    if v == "poly":
        expr = a_*x**rc([2,3]) + b_
        lo, hi = 0.0, float(rc([2,3,4]))
    elif v == "trig":
        expr = sp.sin(x)
        lo, hi = 0.0, math.pi
    else:
        expr = sp.sqrt(x) + b_
        lo, hi = 0.0, float(rc([1,4,9]))
    dx = (hi - lo) / n
    try:
        f_lam = sp.lambdify(x, expr, 'math')
        if method == "right":
            pts = [lo+i*dx for i in range(1,n+1)]; label = "right endpoints"
        elif method == "left":
            pts = [lo+i*dx for i in range(0,n)];   label = "left endpoints"
        else:
            pts = [lo+(i+0.5)*dx for i in range(n)]; label = "midpoints"
        approx = round(dx * sum(f_lam(p) for p in pts), 4)
    except Exception:
        return None
    # Human-readable bounds
    def _lat(v_): return "\\pi" if abs(v_ - math.pi) < 1e-9 else sp.latex(sp.nsimplify(v_))
    q = (f"Approximate \\( \\int_{{{_lat(lo)}}}^{{{_lat(hi)}}} {sp.latex(expr)}\\,dx \\) "
         f"using a Riemann sum with \\( n = {n} \\) subintervals and the {label}.")
    return q, expr, str(approx), str(approx), lo, hi

# ── NEW: Numerical Approximation ────────────────────────────────────────────

def gen_numerical_approx():
    """Midpoint / Trapezoid / Simpson's Rule."""
    n = rc([4,6,8])
    method = rc(["midpoint","trapezoid","simpson"])
    if method == "simpson" and n % 2 != 0:
        n += 1
    data = rc([
        (1/(x**3+1),            1.0, 7.0),
        (sp.sqrt(sp.exp(-x**2)+1), -1.0, 2.0),
        (sp.cos(1+sp.sqrt(x)),  0.0, 4.0),
        (sp.exp(-x**2),         0.0, 1.0),
        (sp.ln(1+x)/x,          0.0, 1.0),
    ])
    expr, lo_val, hi_val = data
    dx = (hi_val - lo_val) / n
    try:
        f_lam = sp.lambdify(x, expr, 'math')
        pts = [lo_val + i*dx for i in range(n+1)]
        vals = [f_lam(p) for p in pts]
        if method == "midpoint":
            mid_v = [f_lam(lo_val+(i+0.5)*dx) for i in range(n)]
            approx = dx * sum(mid_v); rule = "Midpoint Rule"
        elif method == "trapezoid":
            approx = dx/2*(vals[0]+2*sum(vals[1:-1])+vals[-1]); rule = "Trapezoid Rule"
        else:
            coeff = [1]+[4 if i%2==1 else 2 for i in range(1,n)]+[1]
            approx = dx/3*sum(c*v for c,v in zip(coeff,vals)); rule = "Simpson's Rule"
        approx = round(approx, 6)
    except Exception:
        return None
    lo_l = sp.latex(sp.nsimplify(lo_val, rational=False))
    hi_l = sp.latex(sp.nsimplify(hi_val, rational=False))
    q = (f"Use the {rule} with \\( n = {n} \\) to approximate "
         f"\\( \\int_{{{lo_l}}}^{{{hi_l}}} {sp.latex(expr)} \\, dx \\).")
    return q, expr, str(approx), str(approx), lo_val, hi_val

# ── NEW: Integral Properties ────────────────────────────────────────────────

def gen_integral_properties():
    """Linearity, additivity, flip bounds, odd/even symmetry."""
    a_val = rc([-2,-1,0,1,2,3])
    b_val = a_val + rc([2,3,4,5,6])
    A = rc(list(range(-8,0)) + list(range(1,9)))
    B = rc(list(range(-8,0)) + list(range(1,9)))
    c_, d_ = rc(NZ), rc(NZ)
    v = rc(["linear_combo","flip_bounds","additivity","odd_symmetry","even_symmetry"])

    if v == "linear_combo":
        ans = c_*A + d_*B
        sign = "+" if d_ > 0 else ""
        q = (f"Given \\( \\int_{{{a_val}}}^{{{b_val}}} f(x)\\,dx = {A} \\) and "
             f"\\( \\int_{{{a_val}}}^{{{b_val}}} g(x)\\,dx = {B} \\), "
             f"determine \\( \\int_{{{a_val}}}^{{{b_val}}} [{c_}f(x) {sign}{d_}g(x)]\\,dx \\).")
        return q, None, sp.latex(ans), str(ans), a_val, b_val

    elif v == "flip_bounds":
        ans = -A
        q = (f"Given \\( \\int_{{{a_val}}}^{{{b_val}}} f(x)\\,dx = {A} \\), "
             f"determine \\( \\int_{{{b_val}}}^{{{a_val}}} f(x)\\,dx \\).")
        return q, None, sp.latex(ans), str(ans), a_val, b_val

    elif v == "additivity":
        c_pt = a_val + rc([1,2])
        X, Y = rc(NZ), rc(NZ)
        ans = X + Y
        q = (f"Given \\( \\int_{{{a_val}}}^{{{c_pt}}} f(x)\\,dx = {X} \\) and "
             f"\\( \\int_{{{c_pt}}}^{{{b_val}}} f(x)\\,dx = {Y} \\), "
             f"determine \\( \\int_{{{a_val}}}^{{{b_val}}} f(x)\\,dx \\).")
        return q, None, sp.latex(ans), str(ans), a_val, b_val

    elif v == "odd_symmetry":
        a_sym = rc([1,2,3])
        n_ = rc([1,3,5])
        coeff_ = rc(NZ)
        func_l = f"{coeff_}x^{{{n_}}}"
        q = (f"Without computing, find \\( \\int_{{-{a_sym}}}^{{{a_sym}}} {func_l} \\, dx \\) "
             f"by identifying whether the integrand is odd or even.")
        return q, None, "0", "0", -a_sym, a_sym

    else:  # even_symmetry
        a_sym = rc([1,2,3])
        coeff_ = rc(POS)
        n_ = rc([2,4])
        expr = coeff_*x**n_
        r = safe_definite(2*expr, x, 0, a_sym)
        if r is None: return None
        func_l = f"{coeff_}x^{{{n_}}}"
        q = (f"Use even-function symmetry to evaluate "
             f"\\( \\int_{{-{a_sym}}}^{{{a_sym}}} {func_l} \\, dx \\).")
        al, ap = fmt_def(r)
        return q, None, al, ap, -a_sym, a_sym

# ── NEW: FTC Differentiation ────────────────────────────────────────────────

def gen_ftc_differentiation():
    """d/dx[∫ₐˣ f(t) dt], chain rule, and reverse-bound variants."""
    funcs_t = [sp.cos(t**2), sp.sqrt(t**2+4), sp.exp(-t**2),
               t**2*sp.cos(t), sp.ln(t**2+1), sp.sin(t)*sp.exp(-t)]
    f_t = rc(funcs_t)
    a_const = rc([0,1,2,-1])
    v = rc(["basic","chain_upper","reverse_lower"])
    a_l = sp.latex(a_const)
    f_l = sp.latex(f_t)

    if v == "basic":
        ans = f_t.subs(t, x)
        q = (f"Use the Fundamental Theorem of Calculus to differentiate: "
             f"\\( \\dfrac{{d}}{{dx}} \\int_{{{a_l}}}^{{x}} {f_l} \\, dt \\).")
    elif v == "chain_upper":
        g_x = rc([sp.sin(x), x**2, sp.sqrt(x), 3*x+1, x**3])
        ans = f_t.subs(t, g_x) * sp.diff(g_x, x)
        g_l = sp.latex(g_x)
        q = (f"Differentiate using FTC and the Chain Rule: "
             f"\\( \\dfrac{{d}}{{dx}} \\int_{{{a_l}}}^{{{g_l}}} {f_l} \\, dt \\).")
    else:  # reverse lower
        g_x = rc([x**2, 2*x, x+1])
        ans = -f_t.subs(t, g_x) * sp.diff(g_x, x)
        g_l = sp.latex(g_x)
        a_top = sp.latex(a_const + rc([1,2,3]))
        q = (f"Differentiate (variable is the lower bound): "
             f"\\( \\dfrac{{d}}{{dx}} \\int_{{{g_l}}}^{{{a_top}}} {f_l} \\, dt \\).")

    ans_s = sp.simplify(ans)
    return q, f_t, sp.latex(ans_s), str(ans_s)

# ── Hard – Area & Volume ────────────────────────────────────────────────────

def gen_area_between_curves():
    """Area between two curves — Dawkins Ch 6.2 style (~12 variants)."""
    variants = [
        "poly_poly", "trig_zero", "sqrt_quadratic",
        "poly_above_xaxis", "linear_vs_quadratic", "rational_linear",
        "exp_with_bounds", "two_parabolas", "sqrt_vs_poly",
        "parabola_line", "trig_poly", "two_trig",
    ]
    v = rc(variants)
    a_, b_ = rc(POS), rc([1, 2])

    if v == "poly_poly":
        f1 = a_*x - x**2
        f2 = b_*x**2 - a_*x
        ints = sorted([p for p in sp.solve(f1 - f2, x) if p.is_real])
        if len(ints) < 2: return None
        lo, hi = ints[0], ints[-1]

    elif v == "trig_zero":
        f1, f2 = sp.sin(x), sp.Integer(0)
        lo, hi = sp.Integer(0), sp.pi

    elif v == "sqrt_quadratic":
        f1, f2 = sp.sqrt(x), x**2
        lo, hi = sp.Integer(0), sp.Integer(1)

    elif v == "poly_above_xaxis":
        # Area below f(x) = c + bx - ax^2 and above x-axis (roots as bounds)
        c_ = rc([1, 2, 3])
        f1 = c_ + a_*x - x**2
        f2 = sp.Integer(0)
        roots = sorted([r for r in sp.solve(f1, x) if r.is_real])
        if len(roots) < 2: return None
        lo, hi = roots[0], roots[-1]

    elif v == "linear_vs_quadratic":
        # y = mx + b  vs  y = ax^2, given intersection bounds
        m_ = rc([1, 2, 3])
        f1 = m_*x + rc([0, 1])
        f2 = rc([1, 2])*x**2
        ints = sorted([p for p in sp.solve(f1 - f2, x) if p.is_real])
        if len(ints) < 2: return None
        lo, hi = ints[0], ints[-1]

    elif v == "rational_linear":
        # y = k/x  vs  y = 0  on [1, c]
        k_ = rc([1, 2, 3, 4])
        c_ = rc([2, 3, 4, 5])
        f1 = sp.Rational(k_) / x
        f2 = sp.Integer(0)
        lo, hi = sp.Integer(1), sp.Integer(c_)

    elif v == "exp_with_bounds":
        # y = e^(-kx)  vs y = 0  on [0, b]
        k_ = rc([1, 2])
        b_val = rc([1, 2, 3])
        f1 = sp.exp(-k_*x)
        f2 = sp.Integer(0)
        lo, hi = sp.Integer(0), sp.Integer(b_val)

    elif v == "two_parabolas":
        # y = a - x^2  vs  y = x^2 - b  (symmetric about y-axis)
        a2 = rc([1, 2, 3, 4])
        b2 = rc([0, 1, 2])
        f1 = a2 - x**2
        f2 = x**2 - b2
        ints = sorted([p for p in sp.solve(f1 - f2, x) if p.is_real])
        if len(ints) < 2: return None
        lo, hi = ints[0], ints[-1]

    elif v == "sqrt_vs_poly":
        # y = sqrt(a*x)  vs  y = b*x^2  (generalized coefficients)
        a2 = rc([1, 2, 4])
        b2 = rc([1, 2])
        f1 = sp.sqrt(a2*x)
        f2 = b2*x**2
        ints = sorted([p for p in sp.solve(f1 - f2, x) if p.is_real and p >= 0])
        if len(ints) < 2: return None
        lo, hi = ints[0], ints[-1]

    elif v == "parabola_line":
        # y = x^2 + c  vs  y = mx + d
        c_ = rc([-2, -1, 0, 1, 2])
        m_ = rc([1, 2, 3])
        d_ = rc([0, 1, 2, 3])
        f1 = m_*x + d_
        f2 = x**2 + c_
        ints = sorted([p for p in sp.solve(f1 - f2, x) if p.is_real])
        if len(ints) < 2: return None
        lo, hi = ints[0], ints[-1]

    elif v == "trig_poly":
        # y = sin(x)  vs  y = x(pi - x) scaled — on [0, pi]
        # Actually: y = cos(x) vs y = 0 on [-pi/2, pi/2] (simpler)
        f1 = sp.cos(x)
        f2 = sp.Integer(0)
        lo, hi = -sp.pi/2, sp.pi/2

    elif v == "two_trig":
        # y = sin(x) vs y = cos(x) on [0, pi/2] — classic
        f1 = sp.sin(x)
        f2 = sp.cos(x)
        lo, hi = sp.Integer(0), sp.pi / 2

    else:
        return None

    # Compute the area
    r = safe_definite(sp.Abs(f1 - f2), x, lo, hi)
    if r is None:
        r = safe_definite(f1 - f2, x, lo, hi)
        if r is None: return None
        r = sp.Abs(r)
    q = (f"Find the area of the region enclosed between "
         f"\\( f(x)={sp.latex(f1)} \\) and \\( g(x)={sp.latex(f2)} \\) "
         f"on \\( [{sp.latex(lo)},\\, {sp.latex(hi)}] \\).")
    al, ap = fmt_def(sp.simplify(r))
    return q, f1 - f2, al, ap, lo, hi, f1, f2

def gen_volume_disk_washer():
    """Volume using disk or washer method (§6.3 style)."""
    v = rc(["disk_x","disk_y","washer_x"])
    if v == "disk_x":
        configs = [
            (sp.sqrt(x),        0,             rc([1,4,9])),
            (rc([1,2])*x,       0,             rc([1,2,3])),
            (x**2,              0,             rc([1,2])),
        ]
        f_x, lo, hi = rc(configs)
        integrand = sp.pi * f_x**2
        r = safe_definite(integrand, x, lo, hi)
        if r is None: return None
        q = (f"Find the volume of the solid obtained by rotating "
             f"\\( y = {sp.latex(f_x)} \\) on \\( [{sp.latex(lo)},\\, {sp.latex(hi)}] \\) "
             f"about the \\( x \\)-axis (disk method).")
    elif v == "disk_y":
        hi_y = rc([1,4,9])
        integrand = sp.pi * x
        r = safe_definite(integrand, x, 0, hi_y)
        if r is None: return None
        lo = 0
        q = (f"Find the volume of the solid obtained by rotating \\( y=x^2 \\) "
             f"about the \\( y \\)-axis using the disk method "
             f"(integrate with respect to \\( y \\) from \\( 0 \\) to \\( {hi_y} \\)).")
        hi = hi_y
    else:   # washer
        R = rc([2,3,4])
        r_inner = rc([1,2])
        while r_inner >= R: r_inner = rc([1,2])
        lo, hi = 0, rc([1,2,3])
        integrand = sp.pi*(R**2 - r_inner**2)
        r = safe_definite(integrand, x, lo, hi)
        if r is None: return None
        q = (f"Use the washer method to find the volume of the solid obtained "
             f"by rotating the region between \\( y={R} \\) and \\( y={r_inner} \\) "
             f"on \\( [{lo},\\, {hi}] \\) about the \\( x \\)-axis.")
    al, ap = fmt_def(sp.simplify(r))
    return q, integrand, al, ap, lo, hi

# ── Scholar ─────────────────────────────────────────────────────────────────

def gen_volume_shell():
    """Volume using shell/cylinder method (§6.4 style)."""
    v = rc(["shell_y_axis","shell_x_axis"])
    a_ = rc([1,2])
    if v == "shell_y_axis":
        configs = [
            (x**2,       0, a_),
            (sp.exp(-x), 0, 1),
            (x*(a_-x),   0, a_),
        ]
        f_x, lo, hi = rc(configs)
        integrand = 2*sp.pi*x*f_x
        r = safe_definite(integrand, x, lo, hi)
        if r is None: return None
        q = (f"Use the shell method to find the volume of the solid obtained "
             f"by rotating \\( y = {sp.latex(f_x)} \\) on "
             f"\\( [{sp.latex(lo)},\\, {sp.latex(hi)}] \\) about the \\( y \\)-axis.")
    else:
        hi_y = sp.sqrt(a_)
        integrand = 2*sp.pi*x*(a_ - x**2)
        lo, hi = 0, hi_y
        r = safe_definite(integrand, x, lo, hi)
        if r is None: return None
        q = (f"Use the shell method to find the volume of the solid obtained "
             f"by rotating the region bounded by \\( y=\\sqrt{{x}} \\), "
             f"\\( x={a_} \\), \\( y=0 \\) about the \\( x \\)-axis.")
    al, ap = fmt_def(sp.simplify(r))
    return q, integrand, al, ap, lo, hi

def gen_reduction_formula():
    n = rc([3,4,5,6])
    fn = sp.sin if rc([True,False]) else sp.cos
    expr = fn(x)**n
    v = rc(["indefinite","definite"])
    if v == "indefinite":
        r = safe_integrate(expr)
        if r is None: return (None,"indefinite")
        q = f"Apply the reduction formula to evaluate: \\( \\int {sp.latex(expr)} \\, dx \\)."
        al, ap = fmt_indef(r)
        return (q, expr, al, ap), "indefinite"
    else:
        lo, hi = 0, sp.pi/2
        r = safe_definite(expr, x, lo, hi)
        if r is None: return (None,"definite")
        q = (f"Apply the Wallis-type reduction formula to evaluate: "
             f"\\( \\int_{{0}}^{{\\pi/2}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(r))
        return (q, expr, al, ap, lo, hi), "definite"

def gen_improper_integral():
    v = rc(["inf_exp","inf_power","inf_inv_quad","disc_sqrt","disc_rational"])
    a_ = rc(POS)
    if v == "inf_exp":
        k = rc([-3,-2,-1])
        expr, lo, hi = a_*sp.exp(k*x), 0, sp.oo
    elif v == "inf_power":
        p = rc([2,3,4])
        expr, lo, hi = a_/x**p, 1, sp.oo
    elif v == "inf_inv_quad":
        b_ = rc(POS)
        expr, lo, hi = a_/(x**2+b_**2), 0, sp.oo
    elif v == "disc_sqrt":
        expr, lo, hi = a_/sp.sqrt(x), 0, 1
    else:
        b_ = rc([1,2])
        p = sp.Rational(1, rc([2,3]))
        expr, lo, hi = a_/(x-b_)**p, b_, b_+2
    r = safe_definite(expr, x, lo, hi)
    if r is None or not r.is_finite: return None
    q = (f"Determine whether the improper integral converges or diverges. "
         f"If convergent, find its value: "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
    al, ap = fmt_def(sp.simplify(r))
    return q, expr, al, ap, lo, hi

# ── NEW: Comparison Test ────────────────────────────────────────────────────

def gen_comparison_test():
    """Convergence / divergence via comparison test (§7.9 style)."""
    v = rc(["conv1","conv2","conv3","div1","div2","div3"])
    if v == "conv1":
        expr, lo, hi = 1/(x**3+1), 1, sp.oo
        verdict, compare = "Converges", "\\frac{1}{x^3}"
        reason = ("\\frac{1}{x^3+1} \\le \\frac{1}{x^3}"
                  "\\text{ and }\\int_1^\\infty x^{-3}\\,dx\\text{ converges }(p=3>1)")
    elif v == "conv2":
        expr, lo, hi = sp.exp(-x**2), 0, sp.oo
        verdict, compare = "Converges", "e^{-x}"
        reason = ("e^{-x^2} \\le e^{-x}\\text{ for }x\\ge 1"
                  "\\text{ and }\\int_1^\\infty e^{-x}\\,dx\\text{ converges.}")
    elif v == "conv3":
        expr, lo, hi = (x+1)/(x**4+2), 1, sp.oo
        verdict, compare = "Converges", "\\frac{2}{x^3}"
        reason = ("\\frac{x+1}{x^4+2}\\le\\frac{2}{x^3}\\text{ for large }x"
                  "\\text{, p-series }p=3>1\\text{ converges.}")
    elif v == "div1":
        expr, lo, hi = 1/(sp.sqrt(x)+1), 1, sp.oo
        verdict, compare = "Diverges", "\\frac{1}{2\\sqrt{x}}"
        reason = ("\\frac{1}{\\sqrt{x}+1}\\ge\\frac{1}{2\\sqrt{x}}"
                  "\\text{ and }\\int_1^\\infty x^{-1/2}\\,dx\\text{ diverges }(p=\\tfrac{1}{2}\\le 1)")
    elif v == "div2":
        expr, lo, hi = sp.ln(x)/x, 1, sp.oo
        verdict, compare = "Diverges", "\\frac{1}{x}"
        reason = ("\\frac{\\ln x}{x}\\ge\\frac{1}{x}\\text{ for }x\\ge e"
                  "\\text{ and the harmonic integral diverges.}")
    else:
        expr, lo, hi = 1/(x**2+sp.sin(x)**2+1), 1, sp.oo
        verdict, compare = "Converges", "\\frac{1}{x^2}"
        reason = ("\\text{integrand }\\le \\frac{1}{x^2}\\text{ and }\\int_1^\\infty x^{-2}\\,dx\\text{ converges.}")
    q = (f"Use the Comparison Test to determine if "
         f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\) "
         f"converges or diverges.")
    al = f"\\mathbf{{{verdict}}}\\text{{ — compare to }}{compare}\\text{{: }}{reason}"
    ap = f"{verdict} (compare to {compare})"
    return q, expr, al, ap, lo, hi

def gen_scholar_special():
    variants = [
        "wallis_even","wallis_odd","gaussian","p_series",
        "log_power_arctan", "log_trig_product", "nested_arctan_radical",
        "elliptic_gamma", "param_hyperbolic", "dirichlet_integral",
        "frullani", "log_sin_series",
    ]
    v = rc(variants)

    # --- Classic Wallis & p-series (original) ---
    if v == "wallis_even":
        n = rc([4,6,8]); expr, lo, hi = sp.sin(x)**n, 0, sp.pi/2
        r = safe_definite(expr, x, lo, hi)
        if r is None: return None
        q = (f"Evaluate using reduction or special-value techniques: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(r))
        return q, expr, al, ap, lo, hi
    elif v == "wallis_odd":
        n = rc([3,5,7]); expr, lo, hi = sp.cos(x)**n, 0, sp.pi/2
        r = safe_definite(expr, x, lo, hi)
        if r is None: return None
        q = (f"Evaluate using reduction or special-value techniques: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(r))
        return q, expr, al, ap, lo, hi
    elif v == "gaussian":
        expr, lo, hi = sp.exp(-x**2), 0, sp.oo
        result = sp.sqrt(sp.pi)/2
        q = (f"Evaluate the Gaussian integral: "
             f"\\( \\int_{{0}}^{{\\infty}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(result)
        return q, expr, al, ap, lo, hi
    elif v == "p_series":
        p = rc([2,3]); expr, lo, hi = 1/x**p, 1, sp.oo
        r = safe_definite(expr, x, lo, hi)
        if r is None: return None
        q = (f"Evaluate using reduction or special-value techniques: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(r))
        return q, expr, al, ap, lo, hi

    # --- Exotic: log-power / arctan integrals ---
    elif v == "log_power_arctan":
        # ∫₀¹ log(x)⁴/(1+x²) dx = 5π⁵/64
        n = rc([2, 4])
        expr = sp.log(x)**n / (1 + x**2)
        lo, hi = 0, 1
        r = safe_definite(expr, x, lo, hi)
        if r is None:
            # Known closed forms
            result = {2: sp.pi**3 / 16, 4: 5*sp.pi**5 / 64}[n]
            r = result
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{0}}^{{1}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(r))
        return q, expr, al, ap, lo, hi

    # --- Exotic: log-trig product ---
    elif v == "log_trig_product":
        # ∫₀^{π/2} ln(2sin(x/2))·ln(2cos(x/2)) dx = -π³/48
        # Use alternate form: ∫₀^{π/2} ln(sin x) · ln(cos x) dx = π/2·ln²2 - π³/48
        sub = rc(["sin_cos", "sin_sq"])
        if sub == "sin_cos":
            expr = sp.log(sp.sin(x)) * sp.log(sp.cos(x))
            lo, hi = 0, sp.pi/2
            result = sp.pi*sp.log(2)**2/2 - sp.pi**3/48
        else:
            # ∫₀^{π/2} ln(sin x)² dx = π/2·ln²2 + π³/24
            expr = sp.log(sp.sin(x))**2
            lo, hi = 0, sp.pi/2
            result = sp.pi*sp.log(2)**2/2 + sp.pi**3/24
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(result))
        return q, expr, al, ap, lo, hi

    # --- Exotic: nested arctan / radical ---
    elif v == "nested_arctan_radical":
        # ∫₀¹ arctan(√(2+x²))/((1+x²)√(2+x²)) dx = 5π²/96
        expr = sp.atan(sp.sqrt(2 + x**2)) / ((1 + x**2) * sp.sqrt(2 + x**2))
        lo, hi = 0, 1
        result = 5*sp.pi**2/96
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{0}}^{{1}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(result)
        return q, expr, al, ap, lo, hi

    # --- Exotic: elliptic / Gamma function ---
    elif v == "elliptic_gamma":
        sub = rc(["lemniscate", "beta_half"])
        if sub == "lemniscate":
            # 8∫₀¹ 1/√(1-x⁴) dx = (2π)^{3/2} / Γ(3/4)²
            expr = 1/sp.sqrt(1 - x**4)
            lo, hi = 0, 1
            result = (2*sp.pi)**sp.Rational(3,2) / (8 * sp.gamma(sp.Rational(3,4))**2)
            q = (f"Evaluate \\( 8\\int_{{0}}^{{1}} {sp.latex(expr)} \\, dx \\) "
                 f"in terms of the Gamma function.")
            al = f"\\frac{{(2\\pi)^{{3/2}}}}{{\\Gamma(3/4)^2}}"
            ap = "(2*pi)**(3/2) / gamma(3/4)**2"
        else:
            # ∫₀^∞ x^{1/2} e^{-x} dx = Γ(3/2) = √π/2
            expr = sp.sqrt(x) * sp.exp(-x)
            lo, hi = 0, sp.oo
            result = sp.sqrt(sp.pi)/2
            q = (f"Evaluate \\( \\int_{{0}}^{{\\infty}} {sp.latex(expr)} \\, dx \\) "
                 f"using the Gamma function.")
            al, ap = fmt_def(result)
        return q, expr, al, ap, lo, hi

    # --- Exotic: parametric hyperbolic ---
    elif v == "param_hyperbolic":
        # ∫₀^∞ sech(x) dx = π/2
        # ∫₀^∞ x·sech(x) dx = π²/4 · C  (Catalan) — use simpler variant
        sub = rc(["sech", "tanh_log"])
        if sub == "sech":
            expr = 1/sp.cosh(x)
            lo, hi = 0, sp.oo
            result = sp.pi/2
        else:
            # ∫₀^∞ x/(e^x + 1) dx = π²/12
            expr = x/(sp.exp(x) + 1)
            lo, hi = 0, sp.oo
            result = sp.pi**2/12
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(result)
        return q, expr, al, ap, lo, hi

    # --- Exotic: Dirichlet integral ---
    elif v == "dirichlet_integral":
        # ∫₀^∞ sin(x)/x dx = π/2
        sub = rc(["sinc", "sinc_sq"])
        if sub == "sinc":
            expr = sp.sin(x)/x
            lo, hi = 0, sp.oo
            result = sp.pi/2
        else:
            # ∫₀^∞ sin²(x)/x² dx = π/2
            expr = sp.sin(x)**2/x**2
            lo, hi = 0, sp.oo
            result = sp.pi/2
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(result)
        return q, expr, al, ap, lo, hi

    # --- Exotic: Frullani integral ---
    elif v == "frullani":
        # ∫₀^∞ (e^{-ax} - e^{-bx})/x dx = ln(b/a) for a,b>0
        a_val, b_val = rc([1,2,3]), rc([4,5,6])
        a_sym, b_sym = sp.Integer(a_val), sp.Integer(b_val)
        expr = (sp.exp(-a_sym*x) - sp.exp(-b_sym*x)) / x
        lo, hi = 0, sp.oo
        result = sp.log(b_sym/a_sym)
        q = (f"Evaluate the Frullani integral: "
             f"\\( \\int_{{0}}^{{\\infty}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(result))
        return q, expr, al, ap, lo, hi

    # --- Exotic: log-sin series type ---
    elif v == "log_sin_series":
        # ∫₀^{π/2} ln(sin x) dx = -π/2 · ln 2
        # ∫₀^{π/2} ln(cos x) dx = -π/2 · ln 2
        # ∫₀^{π/2} x·ln(sin x) dx = 7ζ(3)/16 - π²/4·ln2  — too complex, use simpler
        sub = rc(["log_sin", "log_cos", "log_tan"])
        if sub == "log_sin":
            expr = sp.log(sp.sin(x))
            lo, hi = 0, sp.pi/2
            result = -sp.pi*sp.log(2)/2
        elif sub == "log_cos":
            expr = sp.log(sp.cos(x))
            lo, hi = 0, sp.pi/2
            result = -sp.pi*sp.log(2)/2
        else:
            # ∫₀^{π/4} ln(tan x) dx = -G (Catalan's constant)
            expr = sp.log(sp.tan(x))
            lo, hi = 0, sp.pi/4
            result = -sp.Catalan
        q = (f"Evaluate the integral: "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(expr)} \\, dx \\).")
        al, ap = fmt_def(sp.simplify(result))
        return q, expr, al, ap, lo, hi

# ===========================================================================
# Difficulty → Type mapping
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "power_rule", "basic_trig", "basic_exponential",
        "inverse_trig", "hyperbolic", "simplify_then_integrate",
    ],
    "medium": [
        "u_substitution", "more_substitution",
        "integration_by_parts", "definite_standard",
        "definite_u_sub", "antiderivative_ivp",
        "ftc_differentiation", "integral_properties",
        "average_value", "riemann_sum",
    ],
    "hard": [
        "trig_integral", "advanced_trig_combo",
        "trig_substitution", "partial_fractions",
        "completing_square", "tabular_ibp", "cyclic_ibp",
        "definite_by_parts", "piecewise_definite",
        "absolute_value_definite", "area_between_curves",
        "root_substitution", "second_antideriv_ivp",
        "mvt_integral", "volume_disk_washer",
    ],
    "scholar": [
        "reduction_formula", "improper_integral",
        "comparison_test", "numerical_approx",
        "volume_shell", "scholar_special",
    ],
}

# ===========================================================================
# Dispatcher
# ===========================================================================

def call_generator(q_type):
    is_definite = False
    lo = hi = None
    q_text = ans_latex = ans_plain = ""
    integrand_expr = None

    # ── Indefinite (no bounds) ──
    simple_indef = {
        "power_rule":           gen_power_rule,
        "basic_trig":           gen_basic_trig,
        "basic_exponential":    gen_basic_exponential,
        "inverse_trig":         gen_inverse_trig,
        "hyperbolic":           gen_hyperbolic,
        "simplify_then_integrate": gen_simplify_then_integrate,
        "antiderivative_ivp":   gen_antiderivative_ivp,
        "second_antideriv_ivp": gen_second_antideriv_ivp,
        "u_substitution":       gen_u_substitution,
        "more_substitution":    gen_more_substitution,
        "integration_by_parts": gen_integration_by_parts,
        "tabular_ibp":          gen_tabular_ibp,
        "cyclic_ibp":           gen_cyclic_ibp,
        "trig_integral":        gen_trig_integral,
        "advanced_trig_combo":  gen_advanced_trig_combo,
        "trig_substitution":    gen_trig_substitution,
        "partial_fractions":    gen_partial_fractions,
        "completing_square":    gen_completing_square,
        "root_substitution":    gen_root_substitution,
        "ftc_differentiation":  gen_ftc_differentiation,   # returns (q,expr,al,ap)
    }
    if q_type in simple_indef:
        res = simple_indef[q_type]()
        if res is None: return None
        q_text, integrand_expr, ans_latex, ans_plain = res
        return {"q_text": q_text, "integrand_expr": integrand_expr,
                "ans_latex": ans_latex, "ans_plain": ans_plain,
                "is_definite": False, "lo": None, "hi": None}

    # ── Definite ──
    integrand_f = None
    integrand_g = None

    def _pack(res):
        nonlocal q_text, integrand_expr, ans_latex, ans_plain, lo, hi, is_definite
        nonlocal integrand_f, integrand_g
        if res is None: return False
        if len(res) == 8:
            q_text, integrand_expr, ans_latex, ans_plain, lo, hi, integrand_f, integrand_g = res
        else:
            q_text, integrand_expr, ans_latex, ans_plain, lo, hi = res
        is_definite = True
        return True

    if q_type == "integral_properties":
        res = gen_integral_properties()
        if res is None: return None
        q_text, integrand_expr, ans_latex, ans_plain, lo, hi = res
        is_definite = True

    elif q_type == "definite_standard":    _pack(gen_definite_standard())
    elif q_type == "definite_u_sub":       _pack(gen_definite_u_sub())
    elif q_type == "definite_by_parts":    _pack(gen_definite_by_parts())
    elif q_type == "piecewise_definite":   _pack(gen_piecewise_definite())
    elif q_type == "absolute_value_definite": _pack(gen_absolute_value_definite())
    elif q_type == "average_value":        _pack(gen_average_value())
    elif q_type == "mvt_integral":         _pack(gen_mvt_integral())
    elif q_type == "riemann_sum":          _pack(gen_riemann_sum())
    elif q_type == "numerical_approx":     _pack(gen_numerical_approx())
    elif q_type == "area_between_curves":  _pack(gen_area_between_curves())
    elif q_type == "volume_disk_washer":   _pack(gen_volume_disk_washer())
    elif q_type == "volume_shell":         _pack(gen_volume_shell())
    elif q_type == "improper_integral":    _pack(gen_improper_integral())
    elif q_type == "comparison_test":      _pack(gen_comparison_test())
    elif q_type == "scholar_special":      _pack(gen_scholar_special())

    elif q_type == "reduction_formula":
        res, kind = gen_reduction_formula()
        if res is None: return None
        if kind == "indefinite":
            q_text, integrand_expr, ans_latex, ans_plain = res
        else:
            q_text, integrand_expr, ans_latex, ans_plain, lo, hi = res
            is_definite = True

    if not q_text or not ans_latex or not ans_plain:
        return None

    rec = {"q_text": q_text, "integrand_expr": integrand_expr,
           "ans_latex": ans_latex, "ans_plain": ans_plain,
           "is_definite": is_definite, "lo": lo, "hi": hi}
    if integrand_f is not None:
        rec["integrand_f"] = integrand_f
    if integrand_g is not None:
        rec["integrand_g"] = integrand_g
    return rec

# ===========================================================================
# Main generation loop
# ===========================================================================

def generate_integral_questions(num_questions: int):
    questions = []
    seen: set = set()
    attempts = 0
    max_attempts = num_questions * 20

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1
        rv = random.random()
        if   rv < 0.25: difficulty = "basic"
        elif rv < 0.55: difficulty = "medium"
        elif rv < 0.85: difficulty = "hard"
        else:           difficulty = "scholar"

        q_type = rc(DIFFICULTY_TYPES[difficulty])

        try:
            rec = call_generator(q_type)
            if rec is None: continue

            q_text    = rec["q_text"]
            expr      = rec["integrand_expr"]
            ans_latex = rec["ans_latex"]
            ans_plain = rec["ans_plain"]
            is_def    = rec["is_definite"]
            lo        = rec["lo"]
            hi        = rec["hi"]

            # Deduplication key
            if expr is not None:
                sig = (sp.srepr(expr),
                       sp.srepr(lo) if lo is not None else "_",
                       sp.srepr(hi) if hi is not None else "_",
                       q_type)
            else:
                sig = (q_text[:120], q_type)
            if sig in seen: continue
            seen.add(sig)

            entry = {
                "id":              len(questions) + 1,
                "type":            q_type,
                "difficulty":      difficulty,
                "is_definite":     is_def,
                "integrand_latex": sp.latex(expr) if expr is not None else "",
                "question_text":   q_text,
                "answer_latex":    ans_latex,
                "answer_plain":    ans_plain,
            }
            if is_def and lo is not None:
                try:
                    entry["lower_bound"] = sp.latex(lo)
                    entry["upper_bound"] = sp.latex(hi)
                except Exception:
                    entry["lower_bound"] = str(lo)
                    entry["upper_bound"] = str(hi)

            # Generate SVG figure if applicable
            if _fig_gen_available and q_type in _FIGURE_TYPES_INTEGRALS:
                try:
                    fig_path = _fig_gen.generate_figure_for_integral(
                        q_type, rec, entry["id"], _figures_dir_integrals)
                    if fig_path:
                        entry["figure_svg"] = fig_path
                except Exception:
                    pass

            questions.append(entry)
            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} integral questions…")

        except Exception:
            pass

    return questions

# ===========================================================================
# Entry point
# ===========================================================================

if __name__ == "__main__":
    print("Generating 2000 Integral questions…")
    questions = generate_integral_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/integrals.json"
    with open(output_file, "w") as f_out:
        json.dump(
            {
                "topic": "Integrals",
                "description": (
                    "Comprehensive Practice Worksheet Database for Integration. "
                    "Indefinite: Power Rule, Trig, Exponential, Inverse Trig, Hyperbolic, "
                    "Simplify-Then-Integrate, U-Substitution (6 variants), More Substitution (§5.4), "
                    "Integration by Parts (9 patterns), Tabular IBP, Cyclic IBP, "
                    "Trig Integrals (sinⁿcosᵐ / tanⁿsecᵐ / cotⁿcscᵐ / product-to-sum), "
                    "Trig Substitution, Partial Fractions, Completing the Square, "
                    "Root/Rationalizing Substitution, Advanced Trig Combos, "
                    "Antiderivative IVP, Second Antiderivative IVP. "
                    "Definite: Standard, U-Sub, By Parts, Piecewise, Absolute Value, "
                    "Area Between Curves, Riemann Sums (L/R/Midpoint), "
                    "Numerical Approx (Midpoint/Trapezoid/Simpson), Average Value, "
                    "MVT for Integrals, Volume Disk/Washer, Volume Shell, "
                    "Improper Integrals, Comparison Test, Integral Properties, "
                    "FTC Differentiation, Scholar Special."
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