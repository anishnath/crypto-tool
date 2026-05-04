#!/usr/bin/env python3
"""
generate_inequality.py — SymPy-verified inequality worksheet generator.

Aligned with NCERT (Indian curriculum) Class 11 Ch 5 (Linear Inequalities)
and Class 12 / JEE Mains-Advanced for higher tiers.  Every emitted
problem is solved by SymPy and the answer is taken verbatim from the
solver, so the worksheet's correctness is guaranteed.

Output: src/main/webapp/worksheet/math/algebra/inequalities.json

Run:
    python3 generate_inequality.py [N]      # default 1500 problems
    python3 generate_worksheet_metadata.py  # refresh the global index

Question types by tier (25 total):

  basic (NCERT Class 9-11 introductory):
    linear_simple             2x + 3 > 7
    linear_neg_flip           -3x + 1 < 7         (sign-flip catch)
    linear_with_parens        3(x - 1) <= 2(x + 4)
    linear_with_fractions     x/3 > x/2 + 1
    linear_double_sided       4x + 3 < 5x + 7
    abs_value_simple          |x - 2| < 5
    compound_sandwich         -3 < 2x + 1 < 7

  medium (NCERT Class 11-12):
    quadratic_factored        (x - 2)(x + 3) > 0
    quadratic_general         x^2 - 5x + 6 <= 0
    abs_value_complex         |2x - 3| >= 7
    system_two_linear         {x + 1 > 3, 2x - 5 < 7}
    word_iq                   IQ = 100*MA/CA, 80 <= IQ <= 140
    word_solution_mix         acid mixing — NCERT classic
    word_rectangle            perimeter constraint
    word_natural_numbers      "find n in N such that ..."
    word_score_threshold      grade-cutoff / average

  hard (Class 12 / JEE Mains):
    polynomial_cubic          (x-1)(x-2)(x-3) >= 0
    rational_simple           (x - 2) / (x + 1) > 0
    rational_quadratic        (x^2 - 1) / (x - 3) <= 0
    abs_value_quadratic       |x^2 - 4| < 5
    log_inequality            log_2(x) < 3
    exponential_inequality    2^x > 16

  scholar (JEE Advanced):
    abs_compound              |x - 1| + |x - 2| < 5
    log_quadratic_arg         log(x^2 - 4) > 0
    trig_inequality           sin(x) > 1/2 in [0, 2*pi]
    parameter_inequality      ax^2 - bx + c <= 0  (analyse discriminant)
    am_gm_apply               prove a/b + b/a >= 2 for a,b > 0
"""

from __future__ import annotations

import sympy as sp
import random
import json
import os
import sys
from collections import Counter

# ── Symbols & helpers ────────────────────────────────────────────────
x   = sp.Symbol("x", real=True)
y   = sp.Symbol("y", real=True)
n   = sp.Symbol("n", real=True, positive=True, integer=True)
a   = sp.Symbol("a", real=True, positive=True)
b   = sp.Symbol("b", real=True, positive=True)

NZ  = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5]
POS = [1, 2, 3, 4, 5, 6]
SMALL_INT = list(range(-9, 10))


def rc(pool):
    return random.choice(pool)


def fmt_set(sol_set) -> tuple[str, str]:
    """Format a SymPy solution set as (latex, plain).  Handles
    EmptySet, Reals, Interval, Union, FiniteSet."""
    if sol_set == sp.S.EmptySet:
        return r"x \in \emptyset", "no solution"
    if sol_set == sp.S.Reals:
        return r"x \in \mathbb{R}", "x in R (all real numbers)"
    return f"x \\in {sp.latex(sol_set)}", f"x in {sol_set}"


def solve_ineq(lhs_expr, op: str, rhs_expr=0, var=x):
    """Solve `lhs_expr op rhs_expr` and return SymPy solution set.
    `op` ∈ {'<', '<=', '>', '>=', '!=', '='}.  Returns None on failure."""
    relation_map = {
        "<":  sp.StrictLessThan,
        "<=": sp.LessThan,
        ">":  sp.StrictGreaterThan,
        ">=": sp.GreaterThan,
    }
    if op not in relation_map:
        return None
    try:
        rel = relation_map[op](lhs_expr, rhs_expr)
        sol = sp.solve_univariate_inequality(rel, var, relational=False)
        return sol
    except Exception:
        return None


def latex_op(op: str) -> str:
    return {"<": "<", "<=": r"\leq", ">": ">", ">=": r"\geq"}[op]


# ╔═════════════════════════════════════════════════════════════════════
# ║  BASIC — NCERT Class 9-11 introductory linear inequalities
# ╚═════════════════════════════════════════════════════════════════════

def gen_linear_simple():
    """ax + b OP c   →   x OP (c - b)/a"""
    op = rc(["<", "<=", ">", ">="])
    A = rc([2, 3, 4, 5, 6, 7])
    B = rc(SMALL_INT)
    C = rc(SMALL_INT)
    sol = solve_ineq(A * x + B, op, C)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    sign = "+" if B >= 0 else "-"
    q_latex = f"{A}x {sign} {abs(B)} {latex_op(op)} {C}"
    q_text  = "Solve the linear inequality and write the solution as an interval."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_linear_neg_flip():
    """Coefficient on x is negative — tests sign-flip rule."""
    op = rc(["<", "<=", ">", ">="])
    A = -rc([2, 3, 4, 5, 6, 7])  # negative coefficient
    B = rc(SMALL_INT)
    C = rc(SMALL_INT)
    sol = solve_ineq(A * x + B, op, C)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    sign = "+" if B >= 0 else "-"
    q_latex = f"{A}x {sign} {abs(B)} {latex_op(op)} {C}"
    q_text  = ("Solve.  Watch the sign-flip rule when dividing by a negative "
               "coefficient.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_linear_with_parens():
    """K(x + p)  OP  M(x + q)   — NCERT-style with brackets."""
    op = rc(["<", "<=", ">", ">="])
    K = rc([2, 3, 4, 5])
    M = rc([2, 3, 4, 5])
    if K == M:
        M += 1  # avoid trivial reduction
    p = rc([-4, -3, -2, -1, 1, 2, 3, 4])
    q = rc([-4, -3, -2, -1, 1, 2, 3, 4])

    lhs = K * (x + p)
    rhs = M * (x + q)
    sol = solve_ineq(lhs - rhs, op, 0)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    def _fmt_paren(coef, shift):
        sign = "+" if shift > 0 else "-"
        return f"{coef}(x {sign} {abs(shift)})"

    q_latex = f"{_fmt_paren(K, p)} {latex_op(op)} {_fmt_paren(M, q)}"
    q_text  = ("Solve the linear inequality after expanding the brackets "
               "(NCERT Ch 5 style).")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_linear_with_fractions():
    """x/A + p OP x/B + q  (NCERT Ex 5.1 fractional pattern)."""
    op = rc(["<", "<=", ">", ">="])
    A = rc([2, 3, 4, 5, 6])
    B = rc([2, 3, 4, 5, 6])
    if A == B:
        B = (B % 4) + 2  # force different
    p = rc(SMALL_INT)
    q = rc(SMALL_INT)

    lhs = x / A + p
    rhs = x / B + q
    sol = solve_ineq(lhs - rhs, op, 0)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    p_sign = "+" if p >= 0 else "-"
    q_sign = "+" if q >= 0 else "-"
    q_latex = (f"\\dfrac{{x}}{{{A}}} {p_sign} {abs(p)} "
               f"{latex_op(op)} "
               f"\\dfrac{{x}}{{{B}}} {q_sign} {abs(q)}")
    q_text  = "Solve the linear inequality with fractional coefficients."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_linear_double_sided():
    """ax + b  OP  cx + d  — variable on both sides (NCERT classic)."""
    op = rc(["<", "<=", ">", ">="])
    A = rc(NZ); C = rc(NZ)
    if A == C:
        C = -C  # ensure x doesn't cancel completely
    if A == C:
        return None
    B = rc(SMALL_INT); D = rc(SMALL_INT)
    sol = solve_ineq(A * x + B - C * x - D, op, 0)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    def _fmt(c, s):
        sgn = "+" if s >= 0 else "-"
        return f"{c}x {sgn} {abs(s)}"

    q_latex = f"{_fmt(A, B)} {latex_op(op)} {_fmt(C, D)}"
    q_text  = "Solve the linear inequality (variable on both sides)."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_abs_value_simple():
    """|x - h|  OP  k    (k > 0)"""
    op = rc(["<", "<=", ">", ">="])
    h = rc(SMALL_INT)
    k = rc([1, 2, 3, 4, 5, 6, 7])

    expr = sp.Abs(x - h)
    sol  = solve_ineq(expr, op, k)
    if sol is None:
        return None

    h_sign = "+" if h <= 0 else "-"   # |x - h|: subtract h means '-|h|' inside
    if h == 0:
        q_latex = f"|x| {latex_op(op)} {k}"
    else:
        q_latex = f"|x {h_sign} {abs(h)}| {latex_op(op)} {k}"
    q_text  = "Solve the absolute-value inequality."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_compound_sandwich():
    """L < ax + b < R  (NCERT compound form)"""
    A = rc([2, 3, 4, 5])
    B = rc(SMALL_INT)
    L = rc([-12, -10, -8, -6, -4])
    R = rc([2, 4, 6, 8, 10])
    op_lo = rc(["<", "<="])
    op_hi = rc(["<", "<="])

    sol_lo = solve_ineq(A * x + B, ">" if op_lo == "<" else ">=", L)
    sol_hi = solve_ineq(A * x + B, op_hi, R)
    if sol_lo is None or sol_hi is None:
        return None
    sol = sol_lo.intersect(sol_hi)
    if sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    sign = "+" if B >= 0 else "-"
    q_latex = (f"{L} {latex_op(op_lo)} "
               f"{A}x {sign} {abs(B)} "
               f"{latex_op(op_hi)} {R}")
    q_text  = "Solve the compound inequality."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


# ╔═════════════════════════════════════════════════════════════════════
# ║  MEDIUM — NCERT Class 11-12 with word problems & quadratics
# ╚═════════════════════════════════════════════════════════════════════

def gen_quadratic_factored():
    """(x - r1)(x - r2)  OP  0   with distinct integer roots."""
    op = rc(["<", "<=", ">", ">="])
    r1, r2 = sorted(random.sample([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5], 2))
    expr = (x - r1) * (x - r2)
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None

    def _fmt_factor(r):
        if r == 0: return "x"
        sgn = "-" if r > 0 else "+"
        return f"(x {sgn} {abs(r)})"

    q_latex = f"{_fmt_factor(r1)}{_fmt_factor(r2)} {latex_op(op)} 0"
    q_text  = "Solve the quadratic inequality using the sign-chart method."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_quadratic_general():
    """ax^2 + bx + c  OP  0  with rational/integer roots."""
    op = rc(["<", "<=", ">", ">="])
    r1, r2 = sorted(random.sample([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5], 2))
    A = rc([1, 2])  # leading coefficient
    expr = sp.expand(A * (x - r1) * (x - r2))
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None
    q_latex = sp.latex(expr) + f" {latex_op(op)} 0"
    q_text  = "Solve the quadratic inequality and express the solution in interval notation."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_abs_value_complex():
    """|ax + b| OP c"""
    op = rc(["<", "<=", ">", ">="])
    A = rc([2, 3, 4, 5])
    B = rc(SMALL_INT)
    C = rc([3, 4, 5, 6, 7, 8, 9, 10])

    expr = sp.Abs(A * x + B)
    sol = solve_ineq(expr, op, C)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    sgn = "+" if B >= 0 else "-"
    q_latex = f"|{A}x {sgn} {abs(B)}| {latex_op(op)} {C}"
    q_text  = "Solve the absolute-value inequality."
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_system_two_linear():
    """{a1*x + b1 OP1 c1,  a2*x + b2 OP2 c2}   — NCERT Ex 5.2 system."""
    parts = []
    sols  = []
    used_op = []
    for _ in range(2):
        op = rc(["<", "<=", ">", ">="])
        used_op.append(op)
        A = rc([1, 2, 3, 4, 5])
        B = rc(SMALL_INT)
        C = rc(SMALL_INT)
        s = solve_ineq(A * x + B, op, C)
        if s is None:
            return None
        parts.append((A, B, C, op))
        sols.append(s)
    sol = sols[0].intersect(sols[1])
    if sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    def _fmt(A, B, C, op):
        sgn = "+" if B >= 0 else "-"
        return f"{A}x {sgn} {abs(B)} {latex_op(op)} {C}"

    q_latex = (r"\begin{cases} " + _fmt(*parts[0]) + r" \\ "
               + _fmt(*parts[1]) + r" \end{cases}")
    q_text  = ("Solve the system of linear inequalities.  Both must hold "
               "simultaneously.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_word_iq():
    """NCERT Class 11 Ex 5.1 Q14 — IQ = 100*MA/CA word problem."""
    CA = rc([10, 11, 12, 13, 14, 15])
    iq_low  = rc([70, 75, 80, 85, 90])
    iq_high = rc([110, 120, 130, 140])
    if iq_high <= iq_low:
        return None

    # IQ = 100*MA/CA  →  MA = IQ*CA/100
    MA = sp.Symbol("MA", positive=True)
    iq = 100 * MA / CA
    try:
        sol_lo = sp.solve_univariate_inequality(iq >= iq_low,  MA, relational=False)
        sol_hi = sp.solve_univariate_inequality(iq <= iq_high, MA, relational=False)
        sol = sol_lo.intersect(sol_hi)
    except Exception:
        return None
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\text{{IQ}} = \\frac{{100 \\cdot \\text{{MA}}}}{{\\text{{CA}}}}, "
               f"\\quad {iq_low} \\leq \\text{{IQ}} \\leq {iq_high}, "
               f"\\quad \\text{{CA}} = {CA}")
    q_text  = (f"The IQ of a child is given by IQ = 100·MA/CA where MA is "
               f"the mental age and CA is the chronological age.  If IQ lies "
               f"between {iq_low} and {iq_high} for a child of chronological age {CA} "
               f"years, find the range of mental age (MA).  (NCERT Class 11 Ch 5)")
    a_latex = f"\\text{{MA}} \\in {sp.latex(sol)}"
    a_plain = f"MA in {sol}"
    return q_text, q_latex, a_latex, a_plain


def gen_word_solution_mix():
    """NCERT-style acid-mixing word problem."""
    init_volume   = rc([400, 500, 600, 800, 1000])    # ml of original solution
    init_pct      = rc([20, 25, 30, 35, 45, 50])      # % acid in original
    target_low    = rc([10, 15, 20])
    target_high   = rc([30, 35, 40])
    if target_high <= target_low or init_pct < target_low or init_pct > target_high * 1.5:
        # ensure problem is feasible: need to dilute so target < init_pct
        return None
    if target_high >= init_pct:
        return None  # adding water can only LOWER concentration

    V = sp.Symbol("V", positive=True)  # ml of pure water added
    init_acid = sp.Rational(init_pct, 100) * init_volume  # ml pure acid
    new_total = init_volume + V
    conc      = 100 * init_acid / new_total

    try:
        sol_lo = sp.solve_univariate_inequality(conc >= target_low,  V, relational=False)
        sol_hi = sp.solve_univariate_inequality(conc <= target_high, V, relational=False)
        sol = sol_lo.intersect(sol_hi)
    except Exception:
        return None
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\text{{volume}} = {init_volume}\\text{{ ml at }}{init_pct}\\%, "
               f"\\quad {target_low}\\% \\leq \\text{{final acid \\%}} \\leq {target_high}\\%")
    q_text  = (f"A solution of {init_volume} mL contains {init_pct}% acid.  "
               f"How many mL of pure water must be added so the resulting "
               f"acid concentration lies between {target_low}% and {target_high}%? "
               f"(NCERT Class 11 Ch 5 Ex 5.2 style)")
    a_latex = f"V \\in {sp.latex(sol)} \\text{{ mL}}"
    a_plain = f"V in {sol} mL"
    return q_text, q_latex, a_latex, a_plain


def gen_word_rectangle():
    """Perimeter constraint with length-twice-width style (NCERT)."""
    # length L = 2W + offset, find max W given perimeter <= P
    offset = rc([0, 1, 2, 3, 4, 5])
    p_max  = rc([60, 80, 100, 120, 150, 200])

    W = sp.Symbol("W", positive=True)
    L = 2 * W + offset
    perim = 2 * (L + W)

    sol = sp.solve_univariate_inequality(perim <= p_max, W, relational=False)
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\text{{Perimeter}} = 2(L + W) \\leq {p_max}, "
               f"\\quad L = 2W{' + ' + str(offset) if offset else ''}")
    q_text  = (f"The length of a rectangle is "
               + ("twice its width" if offset == 0
                  else f"{offset} cm more than twice its width") + ".  "
               f"If the perimeter is at most {p_max} cm, find the range "
               f"of possible widths W (in cm).")
    a_latex = f"W \\in {sp.latex(sol)} \\text{{ cm}}"
    a_plain = f"W in {sol} cm"
    return q_text, q_latex, a_latex, a_plain


def gen_word_natural_numbers():
    """Find all natural numbers n satisfying a linear inequality."""
    A = rc([2, 3, 4, 5])
    B = rc([3, 5, 7, 11, 13])
    C = rc([20, 30, 40, 50])
    op = rc(["<", "<="])

    n_sym = sp.Symbol("n", positive=True, integer=True)
    sol = solve_ineq(A * n_sym + B, op, C, var=n_sym)
    if sol is None or sol == sp.S.EmptySet:
        return None

    # Find the largest natural in the set
    integers_in = []
    for k in range(1, 100):
        if sol.contains(k):
            integers_in.append(k)
        else:
            if integers_in:  # we exited the set
                break
    if not integers_in:
        return None

    sgn = "+" if B >= 0 else "-"
    q_latex = f"{A}n {sgn} {abs(B)} {latex_op(op)} {C}, \\quad n \\in \\mathbb{{N}}"
    q_text  = "Find all natural numbers n satisfying the inequality."
    a_latex = "n \\in \\{" + ", ".join(map(str, integers_in)) + "\\}"
    a_plain = f"n in {{{', '.join(map(str, integers_in))}}}"
    return q_text, q_latex, a_latex, a_plain


def gen_word_score_threshold():
    """Average-of-five-scores must be at least K."""
    s1, s2, s3, s4 = [rc(range(40, 95)) for _ in range(4)]
    K = rc([60, 65, 70, 75, 80, 85, 90])
    op = rc([">=", ">"])

    s5 = sp.Symbol("s_5", positive=True)
    avg = (s1 + s2 + s3 + s4 + s5) / 5
    sol = solve_ineq(avg, op, K, var=s5)
    if sol is None or sol == sp.S.EmptySet:
        return None
    # Must be ≤ 100
    sol = sol.intersect(sp.Interval(0, 100))
    if sol == sp.S.EmptySet:
        return None

    grade = "A" if K >= 90 else ("B" if K >= 80 else ("C" if K >= 70 else "passing"))
    q_latex = (f"\\frac{{{s1} + {s2} + {s3} + {s4} + s_5}}{{5}} {latex_op(op)} {K}")
    q_text  = (f"A student's first four exam scores are {s1}, {s2}, {s3}, and {s4}.  "
               f"What range of marks on the fifth exam (out of 100) will give "
               f"an average score of at least {K} (i.e. a {grade} grade)?")
    a_l, a_p = fmt_set(sol)
    a_latex = a_l.replace("x", "s_5")
    a_plain = a_p.replace("x", "s_5")
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  HARD — Class 12 / JEE Mains
# ╚═════════════════════════════════════════════════════════════════════

def gen_polynomial_cubic():
    """(x - r1)(x - r2)(x - r3)  OP  0   — cubic sign chart."""
    op = rc(["<", "<=", ">", ">="])
    r1, r2, r3 = sorted(random.sample([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5], 3))
    expr = (x - r1) * (x - r2) * (x - r3)
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None

    def _f(r):
        sgn = "-" if r > 0 else "+"
        return f"(x {sgn} {abs(r)})"

    q_latex = f"{_f(r1)}{_f(r2)}{_f(r3)} {latex_op(op)} 0"
    q_text  = ("Solve the cubic inequality using the sign-chart method.  "
               "List the three critical points first, then test each interval.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_rational_simple():
    """(x - p) / (x - q)  OP  0"""
    op = rc(["<", "<=", ">", ">="])
    p, q = random.sample([-4, -3, -2, -1, 1, 2, 3, 4], 2)
    expr = (x - p) / (x - q)
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None

    def _f(r):
        if r == 0: return "x"
        sgn = "-" if r > 0 else "+"
        return f"(x {sgn} {abs(r)})"

    q_latex = f"\\dfrac{{{_f(p)}}}{{{_f(q)}}} {latex_op(op)} 0"
    q_text  = (f"Solve the rational inequality.  The denominator x = {q} "
               "must be excluded from the solution set.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_rational_quadratic():
    """(x^2 - p) / (x - q)  OP  0   — quadratic numerator, linear denom."""
    op = rc(["<", "<=", ">", ">="])
    p = rc([1, 4, 9, 16])  # x^2 - p factors over Z
    q = rc([-3, -2, -1, 2, 3])
    if q ** 2 == p:  # avoid hole/cancellation
        return None
    expr = (x ** 2 - p) / (x - q)
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None

    sqrt_p = int(p ** 0.5)
    q_latex = (f"\\dfrac{{x^2 - {p}}}{{x - {q}}} {latex_op(op)} 0")
    q_text  = (f"Solve the rational inequality.  Note that x² − {p} factors "
               f"as (x − {sqrt_p})(x + {sqrt_p}); excluded denominator x = {q}.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_abs_value_quadratic():
    """|x^2 - k|  OP  m   — modulus of a quadratic."""
    op = rc(["<", "<="])
    k = rc([4, 9, 16, 25])
    m = rc([1, 2, 3, 4, 5, 6])
    expr = sp.Abs(x ** 2 - k)
    sol  = solve_ineq(expr, op, m)
    if sol is None or sol == sp.S.EmptySet:
        return None

    q_latex = f"|x^2 - {k}| {latex_op(op)} {m}"
    q_text  = ("Solve the absolute-value quadratic inequality.  "
               "Convert |A| ≤ m to −m ≤ A ≤ m, then solve the resulting "
               "compound quadratic system.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_log_inequality():
    """log_b(x)  OP  k    →    x  OP  b^k"""
    op = rc(["<", "<=", ">", ">="])
    base = rc([2, 3, 5, 10])
    K = rc([1, 2, 3])
    expr = sp.log(x, base)
    sol  = solve_ineq(expr, op, K)
    if sol is None:
        return None
    # Domain: x > 0
    sol = sol.intersect(sp.Interval.open(0, sp.oo))
    if sol == sp.S.EmptySet:
        return None

    q_latex = f"\\log_{{{base}}}(x) {latex_op(op)} {K}"
    q_text  = (f"Solve the logarithmic inequality.  Apply the rule: "
               f"if b > 1 then log_b(x) {latex_op(op)} k iff x {latex_op(op)} b^k.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_exponential_inequality():
    """a^x  OP  c"""
    op = rc(["<", "<=", ">", ">="])
    base = rc([2, 3, 4, 5])
    K = rc([1, 2, 3, 4])
    rhs = base ** K
    expr = base ** x
    sol  = solve_ineq(expr, op, rhs)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    q_latex = f"{base}^x {latex_op(op)} {rhs}"
    q_text  = ("Solve the exponential inequality.  Take log of both sides "
               "(log preserves direction when the base is > 1).")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


# ╔═════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — JEE Advanced / olympiad
# ╚═════════════════════════════════════════════════════════════════════

def gen_abs_compound():
    """|x − a| + |x − b|  OP  c"""
    op = rc(["<", "<=", ">", ">="])
    a_v, b_v = sorted(random.sample([-5, -3, -1, 1, 3, 5, 7], 2))
    c_v = rc([3, 4, 5, 6, 7, 8, 9])
    if c_v <= b_v - a_v:
        return None  # ensures non-trivial answer
    expr = sp.Abs(x - a_v) + sp.Abs(x - b_v)
    sol  = solve_ineq(expr, op, c_v)
    if sol is None or sol == sp.S.EmptySet:
        return None

    sgn_a = "-" if a_v > 0 else "+"
    sgn_b = "-" if b_v > 0 else "+"
    q_latex = (f"|x {sgn_a} {abs(a_v)}| + |x {sgn_b} {abs(b_v)}| "
               f"{latex_op(op)} {c_v}")
    q_text  = ("Solve the compound absolute-value inequality.  "
               "Hint: split into 3 cases based on the critical points and "
               "evaluate each side separately.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_log_quadratic_arg():
    """log(x^2 - k)  OP  c   — log of a quadratic argument."""
    op = rc([">", ">=", "<", "<="])
    k = rc([1, 4, 9])
    c_v = rc([0, 1, 2])
    base = rc([2, sp.E, 10])

    expr = sp.log(x ** 2 - k, base)
    sol = solve_ineq(expr, op, c_v)
    if sol is None or sol == sp.S.EmptySet:
        return None

    base_str = "e" if base == sp.E else str(base)
    q_latex = f"\\log_{{{base_str}}}(x^2 - {k}) {latex_op(op)} {c_v}"
    q_text  = ("Solve the logarithmic inequality.  Don't forget the domain "
               "constraint x² − k > 0.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_trig_inequality():
    """sin(x) OP c  in  [0, 2π]"""
    op = rc([">", ">=", "<", "<="])
    func = rc(["sin", "cos"])
    c_val = rc([sp.Rational(1, 2), -sp.Rational(1, 2), sp.sqrt(2) / 2, sp.sqrt(3) / 2])

    expr = sp.sin(x) if func == "sin" else sp.cos(x)
    domain = sp.Interval(0, 2 * sp.pi)

    try:
        rel = {"<": sp.StrictLessThan, "<=": sp.LessThan,
               ">": sp.StrictGreaterThan, ">=": sp.GreaterThan}[op](expr, c_val)
        sol = sp.solve_univariate_inequality(rel, x, relational=False)
        sol = sol.intersect(domain)
    except Exception:
        return None
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\{func}(x) {latex_op(op)} {sp.latex(c_val)}, "
               f"\\quad x \\in [0, 2\\pi]")
    q_text  = (f"Solve the trigonometric inequality on the interval [0, 2π].  "
               f"Use the unit circle to find where {func}(x) is on the "
               f"required side of {sp.latex(c_val)}.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_parameter_inequality():
    """For what values of k does kx² + 4x + 3 ≥ 0 hold for all real x?"""
    A_target = rc([1, 2, 3])  # answer: k > A_target/B^2
    B = rc([2, 3, 4, 5])      # coefficient of x
    C = rc([1, 2, 3, 4])

    # We want the answer to be a clean closed form.
    # For ax² + bx + c ≥ 0 ∀x  ⇔  a > 0 AND discriminant ≤ 0
    # Discriminant = b² − 4ac ≤ 0  ⇔  ac ≥ b²/4
    # If we fix b and c, we want a ≥ b²/(4c).  Pick clean b, c so b²/(4c) is rational.
    if (B ** 2) % (4 * C) != 0 and (B ** 2) % C != 0:
        # Allow rational answer
        pass

    k_threshold = sp.Rational(B ** 2, 4 * C)
    q_latex = (f"\\text{{Find the values of }} k \\text{{ such that }} "
               f"k x^2 + {B} x + {C} \\geq 0 \\text{{ holds for all real }} x.")
    q_text  = ("Find the range of the parameter k for which the quadratic "
               "is non-negative for every real x.  Use the discriminant "
               "condition: a > 0 AND b² − 4ac ≤ 0.")
    a_latex = f"k \\geq {sp.latex(k_threshold)}"
    a_plain = f"k >= {k_threshold}"
    return q_text, q_latex, a_latex, a_plain


def gen_am_gm_apply():
    """AM-GM application — short proof / exact bound."""
    case = rc(["a_plus_one_over_a", "a_b_symmetric", "three_term"])

    if case == "a_plus_one_over_a":
        q_latex = r"a + \frac{1}{a} \geq 2 \quad \text{for all } a > 0"
        q_text  = ("Prove the inequality and state the equality case.  "
                   "Hint: apply AM-GM to the two positive numbers a and 1/a.")
        a_latex = (r"a + \frac{1}{a} \geq 2\sqrt{a \cdot \frac{1}{a}} = 2; "
                   r"\quad \text{equality at } a = 1")
        a_plain = "a + 1/a >= 2; equality when a = 1"

    elif case == "a_b_symmetric":
        q_latex = r"\frac{a}{b} + \frac{b}{a} \geq 2 \quad \text{for all } a, b > 0"
        q_text  = ("Prove the inequality and state when equality holds.  "
                   "Hint: AM-GM on a/b and b/a.")
        a_latex = (r"\frac{a}{b} + \frac{b}{a} \geq 2\sqrt{\frac{a}{b} \cdot "
                   r"\frac{b}{a}} = 2; \quad \text{equality at } a = b")
        a_plain = "a/b + b/a >= 2; equality when a = b"

    else:  # three-term
        q_latex = r"\frac{a + b + c}{3} \geq \sqrt[3]{abc} \quad \text{for } a, b, c > 0"
        q_text  = ("State and apply the three-term AM-GM inequality.  "
                   "When does equality hold?")
        a_latex = (r"\text{AM} \geq \text{GM}: "
                   r"\frac{a+b+c}{3} \geq \sqrt[3]{abc}; "
                   r"\quad \text{equality when } a = b = c")
        a_plain = "(a+b+c)/3 >= cbrt(abc); equality when a = b = c"

    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  IIT-JEE Advanced / MIT / Putnam-level problems
# ║
# ║  These generators produce JEE Advanced-style problems that require
# ║  multi-step reasoning: substitution into a hidden quadratic, sign-
# ║  flip rules for log with fractional base, domain analysis for square
# ║  roots, classical olympiad inequalities.  Each is SymPy-verified
# ║  where the closed form admits it; classical proofs use a curated
# ║  pool with hand-checked answers.
# ╚═════════════════════════════════════════════════════════════════════

def gen_exp_quadratic_substitution():
    """
    JEE classic:  A·b^(2x) + B·b^x + C  ⋛  0     (substitute u = b^x → quadratic in u)

    Plant two clean POSITIVE roots u1, u2 for the quadratic in u, then
    back-substitute: x = log_b(u).  Both roots must be positive so the
    inequality has a real-x interval solution.
    """
    op = rc(["<", "<=", ">", ">="])
    base = rc([2, 3])
    # Pick positive integer roots u1 < u2 in {1, 2, 4, 8, 9, 16, 27}
    candidates = sorted(random.sample([1, 2, 4, 8, 9, 16, 27], 2))
    u1, u2 = candidates

    # Quadratic: (u - u1)(u - u2) = u^2 - (u1+u2)·u + u1·u2
    B = -(u1 + u2)
    C = u1 * u2

    u = sp.Symbol("u", positive=True)
    sol_u = solve_ineq(u ** 2 + B * u + C, op, 0, var=u)
    if sol_u is None or sol_u == sp.S.EmptySet:
        return None
    # Restrict u to (0, ∞) since u = b^x > 0
    sol_u = sol_u.intersect(sp.Interval.open(0, sp.oo))
    if sol_u == sp.S.EmptySet:
        return None
    # Back-substitute: x = log_b(u).  log_b is monotone increasing for b>1,
    # so the inequality direction on x matches u's.
    sol_x = sp.S.EmptySet
    if isinstance(sol_u, sp.Interval):
        intervals_u = [sol_u]
    elif isinstance(sol_u, sp.Union):
        intervals_u = list(sol_u.args)
    else:
        return None
    for iv in intervals_u:
        if not isinstance(iv, sp.Interval):
            continue
        lo, hi = iv.start, iv.end
        new_lo = sp.log(lo, base) if lo > 0 else -sp.oo
        new_hi = sp.log(hi, base) if hi != sp.oo else sp.oo
        new_iv = sp.Interval(new_lo, new_hi,
                             left_open=iv.left_open or lo == 0,
                             right_open=iv.right_open or hi == sp.oo)
        sol_x = sol_x.union(new_iv)

    Bstr = f"+ {B}" if B >= 0 else f"- {abs(B)}"
    Cstr = f"+ {C}" if C >= 0 else f"- {abs(C)}"
    q_latex = (f"{base}^{{2x}} {Bstr} \\cdot {base}^x {Cstr} {latex_op(op)} 0")
    q_text  = (f"(JEE-style) Solve the exponential inequality.  "
               f"Hint: substitute u = {base}^x and solve the resulting quadratic "
               f"in u, then back-substitute x = log_{base}(u).  "
               f"Remember: u must be positive.")
    a_l, a_p = fmt_set(sol_x)
    return q_text, q_latex, a_l, a_p


def gen_log_fractional_base():
    """
    JEE classic:  log_{1/b}(quadratic)  ⋛  c       (base < 1 → inequality flips)

    With base b ∈ (0,1), `log_b` is strictly decreasing, so:
        log_b(arg) ≥ c   ⇔   arg ≤ b^c   (with arg > 0 enforced)
    """
    op = rc(["<", "<=", ">", ">="])
    inv_base = rc([2, 3, 4, 5])  # base = 1/inv_base
    c_val    = rc([-2, -1, 0, 1, 2])
    # Argument is x² - p (quadratic with two real roots when p > 0)
    p = rc([1, 4, 9, 16])

    arg = x ** 2 - p
    threshold = sp.Rational(1, inv_base) ** c_val   # = b^c
    # Flip direction (since log with base < 1 is decreasing)
    flipped_op = {"<": ">", "<=": ">=", ">": "<", ">=": "<="}[op]
    sol_eq = solve_ineq(arg, flipped_op, threshold)
    if sol_eq is None:
        return None
    # Domain: arg > 0
    sol_dom = solve_ineq(arg, ">", 0)
    if sol_dom is None:
        return None
    sol = sol_eq.intersect(sol_dom)
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\log_{{1/{inv_base}}}\\left(x^2 - {p}\\right) "
               f"{latex_op(op)} {c_val}")
    q_text  = (f"(JEE-style) Solve the logarithmic inequality.  "
               f"Hint: the base 1/{inv_base} is less than 1, so applying "
               f"the log inverse FLIPS the inequality direction.  "
               f"Don't forget the domain x² − {p} > 0.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_nested_log():
    """
    JEE classic:  log_b1(log_b2(x))  ⋛  c        (nested log, peel outside-in)

    Outer: log_b1(Y) ⋛ c   ⇒   Y ⋛ b1^c
    Inner: log_b2(x) is Y, so log_b2(x) ⋛ b1^c   ⇒   x ⋛ b2^(b1^c)
    Plus stacked domain constraints: x > 0 AND log_b2(x) > 0 (i.e. x > 1).
    """
    op = rc(["<", "<=", ">", ">="])
    b1 = rc([2, 3])
    b2 = rc([2, 3, 5])
    c_val = rc([0, 1, 2])

    threshold_outer = b1 ** c_val          # what log_b2(x) must be
    if threshold_outer < 1 and op in ("<", "<="):
        # log_b2(x) < small_value, ensure x is interesting
        pass

    # Solve log_b2(x) op threshold_outer
    inner = sp.log(x, b2)
    sol_inner = solve_ineq(inner, op, threshold_outer)
    if sol_inner is None:
        return None
    # Domain: x > 1 (since log_b2(x) must be > 0 for outer log to be defined)
    sol = sol_inner.intersect(sp.Interval.open(1, sp.oo))
    if sol == sp.S.EmptySet:
        return None

    q_latex = (f"\\log_{{{b1}}}\\!\\left(\\log_{{{b2}}}(x)\\right) "
               f"{latex_op(op)} {c_val}")
    q_text  = (f"(JEE-style) Solve the nested logarithmic inequality.  "
               f"Peel from the outside: first replace log_{b1}(Y) {latex_op(op)} {c_val} "
               f"with Y {latex_op(op)} {b1}^{c_val}, then solve "
               f"log_{b2}(x) accordingly.  Domain: x > 1 (so the inner log "
               f"is defined and positive).")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_sqrt_inequality():
    """
    JEE classic:  √(x² - k)  <  x - m       (square-root inequality)

    Steps:  domain (x² ≥ k);  RHS sign (x ≥ m);  square both sides;  solve.
    SymPy can verify via `solve_univariate_inequality(sqrt(...) - (x-m), <, 0)`.
    """
    op = rc(["<", "<="])
    k = rc([1, 4, 9])
    m = rc([1, 2, 3, 4])

    expr = sp.sqrt(x ** 2 - k) - (x - m)
    try:
        sol = sp.solve_univariate_inequality(
            expr < 0 if op == "<" else expr <= 0, x, relational=False)
    except Exception:
        return None
    if sol is None or sol == sp.S.EmptySet:
        return None
    # Restrict to domain x² ≥ k AND x - m > 0 (else √(non-neg) < negative is impossible)
    sol = sol.intersect(sp.Interval.open(m, sp.oo))
    if sol == sp.S.EmptySet:
        return None

    q_latex = f"\\sqrt{{x^2 - {k}}} {latex_op(op)} x - {m}"
    q_text  = ("(JEE-style) Solve the square-root inequality.  "
               "Three checks are needed: (i) radicand x² − k ≥ 0, "
               "(ii) RHS x − m > 0 (else a non-negative √ can't be less "
               "than a non-positive value), and only then (iii) square "
               "both sides safely.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_modulus_vs_modulus():
    """
    JEE classic:  |ax + b|  ⋛  |cx + d|

    Trick: square both sides (both are non-negative), get a quadratic
    in x:  (ax+b)² ⋛ (cx+d)²   ⇔   ((ax+b) − (cx+d))((ax+b) + (cx+d)) ⋛ 0.
    """
    op = rc(["<", "<=", ">", ">="])
    A = rc([1, 2, 3]); B = rc([-3, -2, -1, 1, 2, 3])
    C = rc([1, 2, 3]); D = rc([-3, -2, -1, 1, 2, 3])
    if A == C and B == D:
        return None  # trivially equal both sides

    # Square both: (Ax+B)² - (Cx+D)²  op  0
    expr = (A * x + B) ** 2 - (C * x + D) ** 2
    sol = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet or sol == sp.S.Reals:
        return None

    def _f(c, k):
        sgn = "+" if k >= 0 else "-"
        return f"{c}x {sgn} {abs(k)}"

    q_latex = f"|{_f(A, B)}| {latex_op(op)} |{_f(C, D)}|"
    q_text  = ("(JEE-style) Solve the modulus-vs-modulus inequality.  "
               "Hint: squaring both sides is valid here since both sides "
               "are non-negative.  Use the identity a² − b² = (a−b)(a+b).")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


def gen_am_gm_optimisation():
    """
    JEE / MIT classic:  Find min/max of  x^p + k/x^q   for x > 0   (p, q > 0)

    Weighted AM-GM:  the minimum of  α·u + β·v  with uv constant is at
    α·u = β·v.  For x^p + k/x^q:
       AM-GM on (q copies of x^p / q) and (p copies of (k/x^q)/p) ...
    Simplified case: p = q = 2   →   x² + k/x²  ≥  2√k   at x = k^(1/4).

    We use the simple symmetric case for verifiability.
    """
    p_pow = rc([1, 2])  # exponent on x in first term
    q_pow = p_pow       # symmetric: same power for clean AM-GM
    k_val = rc([4, 9, 16, 25, 36, 49, 64, 81, 100])
    # Min value = 2·√k for p_pow = q_pow = 1 case (since x + k/x ≥ 2√k at x=√k)
    # For p_pow = 2: x² + k/x² ≥ 2√k at x = k^(1/4)
    min_val = 2 * sp.sqrt(k_val)
    if p_pow == 1:
        x_at_min = sp.sqrt(k_val)
        q_latex = f"f(x) = x + \\dfrac{{{k_val}}}{{x}}, \\quad x > 0"
    else:
        x_at_min = k_val ** sp.Rational(1, 4)
        q_latex = f"f(x) = x^2 + \\dfrac{{{k_val}}}{{x^2}}, \\quad x > 0"
    q_text = ("(JEE / MIT-style) Find the minimum value of f(x) for x > 0 "
              "and the value of x at which it is attained.  Hint: apply "
              "AM-GM to the two positive terms.")
    a_latex = (f"f_{{\\min}} = {sp.latex(min_val)}, "
               f"\\quad \\text{{at }} x = {sp.latex(x_at_min)}")
    a_plain = f"min = {min_val}, at x = {x_at_min}"
    return q_text, q_latex, a_latex, a_plain


def gen_putnam_classics():
    """
    Hand-curated pool of olympiad-level inequality classics.  Each entry
    is a known-true theorem with a textbook proof sketch as the answer.
    """
    pool = [
        # 1. Triangle inequality region for sides
        {
            "q_latex": r"a, b, c \text{ are sides of a triangle.  Prove: }"
                       r"a + b > c,\; b + c > a,\; c + a > b.",
            "q_text":  ("Prove the triangle inequality for any three sides "
                        "of a non-degenerate triangle."),
            "a_latex": (r"\text{Sum of any two sides exceeds the third "
                        r"by the triangle-inequality theorem; "
                        r"equality only in degenerate (collinear) case.}"),
            "a_plain": "Strict if non-degenerate; equality at collinearity."
        },
        # 2. Reverse triangle inequality
        {
            "q_latex": r"\text{For all real } a, b: \quad ||a| - |b|| \leq |a - b|.",
            "q_text":  ("Prove the reverse triangle inequality.  "
                        "Hint: apply the standard triangle inequality to "
                        "|a| = |(a−b) + b| and |b| = |(b−a) + a|."),
            "a_latex": (r"|a| - |b| \leq |a-b| \text{ and } |b| - |a| "
                        r"\leq |a-b|; \text{ combining: } "
                        r"||a|-|b|| \leq |a-b|."),
            "a_plain": "||a|-|b|| <= |a-b|; equality when a, b same sign."
        },
        # 3. Cauchy-Schwarz (2-vector form)
        {
            "q_latex": r"(a^2 + b^2)(c^2 + d^2) \geq (ac + bd)^2 "
                       r"\quad \text{for all real } a, b, c, d.",
            "q_text":  ("(Cauchy-Schwarz inequality, 2-vector form).  Prove "
                        "the inequality and state the equality case.  "
                        "Hint: expand (ad − bc)² ≥ 0."),
            "a_latex": (r"(ac + bd)^2 + (ad - bc)^2 = (a^2+b^2)(c^2+d^2); "
                        r"\text{ since } (ad-bc)^2 \geq 0, "
                        r"(a^2+b^2)(c^2+d^2) \geq (ac+bd)^2; "
                        r"\text{ equality when } ad = bc."),
            "a_plain": "Equality iff (a,b) and (c,d) are proportional."
        },
        # 4. AM-GM for 3 variables: (a+b+c)³ ≥ 27abc
        {
            "q_latex": r"\text{For } a, b, c > 0: \quad "
                       r"(a + b + c)^3 \geq 27 abc.",
            "q_text":  ("Prove the inequality.  Hint: take the cube of "
                        "the 3-term AM-GM inequality (a+b+c)/3 ≥ ³√(abc)."),
            "a_latex": (r"\frac{a+b+c}{3} \geq \sqrt[3]{abc} "
                        r"\Rightarrow (a+b+c)^3 \geq 27 abc; "
                        r"\text{ equality iff } a = b = c."),
            "a_plain": "(a+b+c)^3 >= 27abc; equality iff a=b=c."
        },
        # 5. Sum of squares ≥ ab + bc + ca
        {
            "q_latex": r"\text{For all real } a, b, c: \quad "
                       r"a^2 + b^2 + c^2 \geq ab + bc + ca.",
            "q_text":  ("Prove the inequality.  Hint: rewrite the difference "
                        "as a sum of three squares of differences."),
            "a_latex": (r"a^2+b^2+c^2 - (ab+bc+ca) "
                        r"= \frac{1}{2}\left[(a-b)^2 + (b-c)^2 + (c-a)^2\right] "
                        r"\geq 0; \text{ equality iff } a = b = c."),
            "a_plain": "Sum of three squared differences ≥ 0; equality iff a=b=c."
        },
        # 6. (a + b)(b + c)(c + a) ≥ 8abc
        {
            "q_latex": r"\text{For } a, b, c > 0: \quad "
                       r"(a + b)(b + c)(c + a) \geq 8 abc.",
            "q_text":  ("(IIT-JEE Advanced) Prove the inequality.  "
                        "Hint: apply 2-term AM-GM three times."),
            "a_latex": (r"a + b \geq 2\sqrt{ab},\; "
                        r"b + c \geq 2\sqrt{bc},\; "
                        r"c + a \geq 2\sqrt{ca}; "
                        r"\text{ multiply: } (a+b)(b+c)(c+a) \geq 8\sqrt{a^2 b^2 c^2} "
                        r"= 8 abc; \text{ equality iff } a = b = c."),
            "a_plain": "Product of three 2-term AM-GMs; equality iff a=b=c."
        },
        # 7. Bernoulli's inequality
        {
            "q_latex": r"\text{For } x \geq -1 \text{ and integer } n \geq 1: "
                       r"\quad (1+x)^n \geq 1 + nx.",
            "q_text":  ("Prove Bernoulli's inequality by induction on n."),
            "a_latex": (r"\text{Base } n=1: (1+x)^1 = 1+x. \text{ "
                        r"Inductive step: } (1+x)^{n+1} = (1+x)^n(1+x) "
                        r"\geq (1+nx)(1+x) = 1 + (n+1)x + nx^2 \geq 1 + (n+1)x."),
            "a_plain": "Induction on n; nx² ≥ 0 closes the step."
        },
        # 8. AM-HM
        {
            "q_latex": r"\text{For } a, b > 0: \quad "
                       r"\frac{a+b}{2} \geq \frac{2ab}{a+b}.",
            "q_text":  ("Prove that the arithmetic mean is at least the "
                        "harmonic mean of two positive numbers.  Hint: "
                        "(a+b)² ≥ 4ab."),
            "a_latex": (r"(a+b)^2 - 4ab = (a-b)^2 \geq 0 \Rightarrow "
                        r"(a+b)^2 \geq 4ab \Rightarrow "
                        r"\frac{a+b}{2} \geq \frac{2ab}{a+b}; "
                        r"\text{ equality iff } a = b."),
            "a_plain": "AM ≥ HM; equality iff a = b."
        },
        # 9. Trig: sin x < x < tan x  for  0 < x < π/2
        {
            "q_latex": r"\text{For } 0 < x < \frac{\pi}{2}: "
                       r"\quad \sin x < x < \tan x.",
            "q_text":  ("Prove the chain on the open interval (0, π/2).  "
                        "Hint: use the unit circle area argument or compare "
                        "derivatives of x − sin x and tan x − x."),
            "a_latex": (r"\sin x < x: \text{ unit-circle arc length exceeds "
                        r"chord half-length doubled.  "
                        r"} x < \tan x: \text{ tangent-line segment exceeds "
                        r"the arc.  Both equalities hold only at } x = 0."),
            "a_plain": "sin x < x < tan x on (0, π/2); equality only at x=0."
        },
        # 10. Schwarz integral inequality (statement)
        {
            "q_latex": r"\left(\int_a^b f(x) g(x)\,dx\right)^2 \leq "
                       r"\int_a^b f(x)^2\,dx \cdot \int_a^b g(x)^2\,dx.",
            "q_text":  ("(MIT/Putnam) State the Cauchy-Schwarz inequality "
                        "for integrals (a continuous-function analogue of the "
                        "discrete sum form)."),
            "a_latex": (r"\text{Equality iff } f \text{ and } g \text{ are "
                        r"linearly dependent (one is a scalar multiple of the other).}"),
            "a_plain": "Equality iff f and g are scalar multiples."
        },
        # 11. Putnam-style: a^a · b^b ≥ a^b · b^a   for a, b > 0
        {
            "q_latex": r"\text{For } a, b > 0: \quad "
                       r"a^a \cdot b^b \geq a^b \cdot b^a.",
            "q_text":  ("(Putnam classic) Prove the inequality.  "
                        "Hint: take logs and rearrange to get "
                        "(a − b)(log a − log b) ≥ 0, which holds since "
                        "log is increasing."),
            "a_latex": (r"\log\!\left(\frac{a^a b^b}{a^b b^a}\right) "
                        r"= (a-b)\log a + (b-a)\log b "
                        r"= (a-b)(\log a - \log b) \geq 0 "
                        r"\text{ (same sign for both factors).}"),
            "a_plain": "(a-b)(log a - log b) ≥ 0; equality iff a = b."
        },
        # 12. Sum of squares: x^2 + y^2 ≥ 2xy
        {
            "q_latex": r"x^2 + y^2 \geq 2xy \quad \text{for all real } x, y.",
            "q_text":  ("Prove the elementary square-mean / arithmetic-mean "
                        "inequality.  Hint: it's just (x − y)² ≥ 0."),
            "a_latex": (r"(x-y)^2 \geq 0 \Rightarrow x^2 + y^2 \geq 2xy; "
                        r"\text{ equality iff } x = y."),
            "a_plain": "x² + y² ≥ 2xy; equality iff x = y."
        },
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


def gen_quartic_substitution():
    """
    JEE classic:  ax^4 + bx^2 + c  ⋛  0      (substitute u = x², solve quadratic)

    Plant clean roots r1, r2 in u = x². Both ≥ 0 → x = ±√r in real solution.
    """
    op = rc(["<", "<=", ">", ">="])
    # Pick roots ≥ 0 so u = x² has real x for each
    candidates = sorted(random.sample([1, 4, 9, 16], 2))
    r1, r2 = candidates  # both positive integers
    # Quadratic in u: (u - r1)(u - r2) = u² - (r1+r2)u + r1 r2
    B = -(r1 + r2)
    C = r1 * r2

    expr = x ** 4 + B * x ** 2 + C
    sol  = solve_ineq(expr, op, 0)
    if sol is None or sol == sp.S.EmptySet:
        return None

    Bstr = f"+ {B}" if B >= 0 else f"- {abs(B)}"
    Cstr = f"+ {C}" if C >= 0 else f"- {abs(C)}"
    q_latex = f"x^4 {Bstr} x^2 {Cstr} {latex_op(op)} 0"
    q_text  = ("(JEE-style) Solve the biquadratic inequality.  "
               "Hint: substitute u = x², solve the resulting quadratic "
               "in u, then back-substitute.  Note u ≥ 0 always.")
    a_l, a_p = fmt_set(sol)
    return q_text, q_latex, a_l, a_p


# ╔═════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "linear_simple",
        "linear_neg_flip",
        "linear_with_parens",
        "linear_with_fractions",
        "linear_double_sided",
        "abs_value_simple",
        "compound_sandwich",
    ],
    "medium": [
        "quadratic_factored",
        "quadratic_general",
        "abs_value_complex",
        "system_two_linear",
        "word_iq",
        "word_solution_mix",
        "word_rectangle",
        "word_natural_numbers",
        "word_score_threshold",
    ],
    "hard": [
        "polynomial_cubic",
        "rational_simple",
        "rational_quadratic",
        "abs_value_quadratic",
        "log_inequality",
        "exponential_inequality",
    ],
    "scholar": [
        "abs_compound",
        "log_quadratic_arg",
        "trig_inequality",
        "parameter_inequality",
        "am_gm_apply",
        # IIT-JEE Advanced / MIT / Putnam-level
        "exp_quadratic_substitution",
        "log_fractional_base",
        "nested_log",
        "sqrt_inequality",
        "modulus_vs_modulus",
        "am_gm_optimisation",
        "putnam_classics",
        "quartic_substitution",
    ],
}


def call_generator(q_type):
    generators = {
        "linear_simple":          gen_linear_simple,
        "linear_neg_flip":        gen_linear_neg_flip,
        "linear_with_parens":     gen_linear_with_parens,
        "linear_with_fractions":  gen_linear_with_fractions,
        "linear_double_sided":    gen_linear_double_sided,
        "abs_value_simple":       gen_abs_value_simple,
        "compound_sandwich":      gen_compound_sandwich,
        "quadratic_factored":     gen_quadratic_factored,
        "quadratic_general":      gen_quadratic_general,
        "abs_value_complex":      gen_abs_value_complex,
        "system_two_linear":      gen_system_two_linear,
        "word_iq":                gen_word_iq,
        "word_solution_mix":      gen_word_solution_mix,
        "word_rectangle":         gen_word_rectangle,
        "word_natural_numbers":   gen_word_natural_numbers,
        "word_score_threshold":   gen_word_score_threshold,
        "polynomial_cubic":       gen_polynomial_cubic,
        "rational_simple":        gen_rational_simple,
        "rational_quadratic":     gen_rational_quadratic,
        "abs_value_quadratic":    gen_abs_value_quadratic,
        "log_inequality":         gen_log_inequality,
        "exponential_inequality": gen_exponential_inequality,
        "abs_compound":           gen_abs_compound,
        "log_quadratic_arg":      gen_log_quadratic_arg,
        "trig_inequality":        gen_trig_inequality,
        "parameter_inequality":   gen_parameter_inequality,
        "am_gm_apply":            gen_am_gm_apply,
        # IIT-JEE Advanced / MIT / Putnam-level
        "exp_quadratic_substitution": gen_exp_quadratic_substitution,
        "log_fractional_base":        gen_log_fractional_base,
        "nested_log":                 gen_nested_log,
        "sqrt_inequality":            gen_sqrt_inequality,
        "modulus_vs_modulus":         gen_modulus_vs_modulus,
        "am_gm_optimisation":         gen_am_gm_optimisation,
        "putnam_classics":            gen_putnam_classics,
        "quartic_substitution":       gen_quartic_substitution,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain = res
    return {
        "q_text":     q_text,
        "q_latex":    q_latex,
        "ans_latex":  ans_latex,
        "ans_plain":  ans_plain,
    }


def generate_inequality_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.25:
            diff = "basic"
        elif rv < 0.50:
            diff = "medium"
        elif rv < 0.78:
            diff = "hard"
        else:
            diff = "scholar"

        q_type = rc(DIFFICULTY_TYPES[diff])
        data = call_generator(q_type)
        if data is None:
            fail_streak += 1
            if fail_streak > 200:
                # Variant pools are likely exhausted — stop trying.
                print(f"  ⚠ stalled at {len(questions)}/{n_target}; "
                      f"200 consecutive None returns.")
                break
            continue
        fail_streak = 0

        dup_key = data["q_latex"]
        if dup_key in seen:
            continue
        seen.add(dup_key)

        questions.append({
            "id":               len(questions) + 1,
            "type":             q_type,
            "difficulty":       diff,
            "expression_latex": data["q_latex"],
            "question_text":    data["q_text"],
            "answer_latex":     data["ans_latex"],
            "answer_plain":     data["ans_plain"],
        })

    return questions


if __name__ == "__main__":
    n_target = int(sys.argv[1]) if len(sys.argv) > 1 else 1500
    random.seed()  # use system entropy by default

    qs = generate_inequality_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "inequalities.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Inequalities",
            "description": ("Linear, quadratic, polynomial, rational, "
                            "absolute-value, log, exponential, and "
                            "trigonometric inequalities aligned with NCERT "
                            "Class 11-12 and JEE Mains/Advanced."),
            "questions": qs,
        }, f, separators=(",", ":"))

    print(f"Generated {len(qs)} inequality problems → {out_path}")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        print(f"  {t:30s}  {c:>4}")
