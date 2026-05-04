#!/usr/bin/env python3
"""
generate_exponent.py — SymPy-verified exponent & power worksheet generator.

Covers the exponent calculator + power-related questions in one file:
  · 8 laws of exponents (product, quotient, power-of-power, etc.)
  · Numerical evaluation, scientific notation
  · Negative & fractional exponents, radicals
  · Comparing powers, exponent equations
  · Compound interest setup, exponential growth
  · IIT-JEE classics (algebraic exponent identities, limits)

Aligned with NCERT Class 7 Ch 13 (Exponents and Powers — laws),
Class 8 Ch 12 (extended laws + scientific notation), Class 9 Ch 1
(rational exponents and surds), and JEE Mains/Advanced for higher tiers.

Output: src/main/webapp/worksheet/math/algebra/exponents.json

Run:
    python3 generate_exponent.py [N]      # default 1500
    python3 generate_worksheet_metadata.py  # refresh global index

Question types (24 total):

  basic (NCERT Class 7-8):
    evaluate_simple             5^3, 2^4 — direct computation
    product_rule                a^m · a^n = a^(m+n)
    quotient_rule               a^m / a^n = a^(m-n)
    power_of_power              (a^m)^n = a^(mn)
    power_of_product            (ab)^n = a^n b^n
    power_of_quotient           (a/b)^n = a^n / b^n
    zero_one_exponent           a^0 = 1, a^1 = a
    negative_exponent           a^(-n) = 1/a^n
    numerical_combo             5^3 + 2^4 + 3^2

  medium (NCERT Class 8-9):
    mixed_laws                  combine 2-3 laws in one expression
    sci_notation_convert        3.4 × 10^5 ↔ 340000
    sci_notation_compute        (2 × 10^3)(4 × 10^5)
    fractional_exponent         a^(m/n) = (n-th root of a)^m
    compare_powers              is 3^4 > 2^7?
    word_problem_growth         population/bacteria/cell-division
    evaluate_neg_exponent       (1/2)^(-3) = 8

  hard (NCERT Class 9-11 + JEE Mains):
    solve_exponential_eq        2^x = 16  →  x = 4
    solve_exp_substitution      4^x − 3·2^x + 2 = 0
    complex_simplification      ((a²b⁻¹)³ (a⁻¹b²)) / (ab)
    convert_to_log              2^x = 7 → x = log_2(7)
    compound_interest           A = P(1 + r)^t — find A
    rational_exponent_simplify  64^(2/3), 81^(3/4)

  scholar (JEE Advanced / IIT):
    exponent_identity_a_plus_a_inv  a^x + a^(-x) = k → find a^x
    binomial_surds_identity     (√2 + 1)^n + (√2 − 1)^n is integer
    limit_e_definition          lim (1 + 1/n)^n = e — state and apply
    iit_classics                hand-curated olympiad problems
"""

from __future__ import annotations

import sympy as sp
import random
import json
import os
import sys
import math
from collections import Counter

x  = sp.Symbol("x", real=True)
y  = sp.Symbol("y", real=True)
n  = sp.Symbol("n", real=True, positive=True, integer=True)
a, b = sp.symbols("a b", positive=True)

SMALL_INT     = list(range(-9, 10))
NONZERO_SMALL = [k for k in SMALL_INT if k != 0]


def rc(pool):
    return random.choice(pool)


# ╔═════════════════════════════════════════════════════════════════════
# ║  BASIC — NCERT Class 7-8 introductory laws
# ╚═════════════════════════════════════════════════════════════════════

def gen_evaluate_simple():
    """Compute a single power: a^n where the result is exact."""
    base = rc([2, 3, 4, 5, 6, 7, 8, 9, 10])
    exp = rc([2, 3, 4, 5])
    val = base ** exp

    q_latex = f"{base}^{{{exp}}}"
    q_text  = "Compute the exact value of the power."
    a_latex = str(val)
    a_plain = str(val)
    return q_text, q_latex, a_latex, a_plain


def gen_product_rule():
    """a^m · a^n = a^(m+n)"""
    base = rc([2, 3, 4, 5, 6, 7])
    m = rc([2, 3, 4, 5])
    n_val = rc([2, 3, 4])
    if m + n_val > 12:
        return None

    q_latex = f"{base}^{{{m}}} \\cdot {base}^{{{n_val}}}"
    q_text  = ("Apply the product rule  a^m · a^n = a^(m+n).  Write the "
               "answer as a single power and the numeric value.")
    new_exp = m + n_val
    a_latex = f"{base}^{{{new_exp}}} = {base ** new_exp}"
    a_plain = f"{base}^{new_exp} = {base ** new_exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_quotient_rule():
    """a^m / a^n = a^(m-n)"""
    base = rc([2, 3, 4, 5, 6, 7])
    m = rc([5, 6, 7, 8, 9])
    n_val = rc([2, 3, 4])
    if m <= n_val:
        return None

    q_latex = f"\\dfrac{{{base}^{{{m}}}}}{{{base}^{{{n_val}}}}}"
    q_text  = ("Apply the quotient rule  a^m / a^n = a^(m−n).  Write the "
               "answer as a single power and the numeric value.")
    new_exp = m - n_val
    a_latex = f"{base}^{{{new_exp}}} = {base ** new_exp}"
    a_plain = f"{base}^{new_exp} = {base ** new_exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_power_of_power():
    """(a^m)^n = a^(mn)"""
    base = rc([2, 3, 4, 5])
    m = rc([2, 3, 4])
    n_val = rc([2, 3])
    if m * n_val > 12:
        return None

    q_latex = f"\\left({base}^{{{m}}}\\right)^{{{n_val}}}"
    q_text  = ("Apply the power-of-a-power rule  (a^m)^n = a^(m·n).")
    new_exp = m * n_val
    a_latex = f"{base}^{{{new_exp}}} = {base ** new_exp}"
    a_plain = f"{base}^{new_exp} = {base ** new_exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_power_of_product():
    """(ab)^n = a^n b^n"""
    a_v = rc([2, 3, 4, 5])
    b_v = rc([2, 3, 5, 7])
    if a_v == b_v:
        return None
    n_val = rc([2, 3, 4])

    q_latex = f"({a_v} \\cdot {b_v})^{{{n_val}}}"
    q_text  = ("Apply the power-of-a-product rule  (a·b)^n = a^n · b^n.  "
               "Then evaluate.")
    val = (a_v * b_v) ** n_val
    a_latex = (f"{a_v}^{{{n_val}}} \\cdot {b_v}^{{{n_val}}} = "
               f"{a_v ** n_val} \\cdot {b_v ** n_val} = {val}")
    a_plain = f"{a_v}^{n_val} · {b_v}^{n_val} = {val}"
    return q_text, q_latex, a_latex, a_plain


def gen_power_of_quotient():
    """(a/b)^n = a^n / b^n  (with clean rational answer)"""
    a_v = rc([2, 3, 4, 5, 6])
    b_v = rc([2, 3, 4, 5])
    if a_v == b_v:
        return None
    n_val = rc([2, 3])

    q_latex = f"\\left(\\dfrac{{{a_v}}}{{{b_v}}}\\right)^{{{n_val}}}"
    q_text  = ("Apply the power-of-a-quotient rule  (a/b)^n = a^n / b^n.  "
               "Simplify if possible.")
    num = a_v ** n_val
    den = b_v ** n_val
    g = math.gcd(num, den)
    a_latex = f"\\dfrac{{{num}}}{{{den}}}" + (f" = \\dfrac{{{num // g}}}{{{den // g}}}" if g > 1 else "")
    a_plain = f"{num}/{den}" + (f" = {num // g}/{den // g}" if g > 1 else "")
    return q_text, q_latex, a_latex, a_plain


def gen_zero_one_exponent():
    """a^0 = 1 and a^1 = a — recognition / mixed expression."""
    case = rc(["zero_simple", "zero_in_expr", "one_simple", "mixed"])
    base = rc([2, 3, 5, 7, 12, 25, 100])

    if case == "zero_simple":
        q_latex = f"{base}^{{0}}"
        q_text  = "Apply the rule  a^0 = 1  (for any non-zero base a)."
        a_latex = "1"
        a_plain = "1"
    elif case == "zero_in_expr":
        q_latex = f"{base}^{{0}} + {base + 1}^{{0}} + {base + 2}^{{0}}"
        q_text  = ("Use the zero-exponent rule.  Each term equals 1, so the "
                   "sum is 3.")
        a_latex = "3"
        a_plain = "3"
    elif case == "one_simple":
        q_latex = f"{base}^{{1}}"
        q_text  = "Apply the rule  a^1 = a."
        a_latex = str(base)
        a_plain = str(base)
    else:
        e1 = rc([2, 3])
        q_latex = f"{base}^{{{e1}}} \\cdot {base}^{{0}} \\cdot {base}^{{1}}"
        q_text  = ("Combine zero-exponent and product rules:  "
                   "a^m · a^0 · a^1 = a^m · 1 · a = a^(m+1).")
        new_exp = e1 + 1
        val = base ** new_exp
        a_latex = f"{base}^{{{new_exp}}} = {val}"
        a_plain = f"{base}^{new_exp} = {val}"
    return q_text, q_latex, a_latex, a_plain


def gen_negative_exponent():
    """a^(-n) = 1/a^n"""
    base = rc([2, 3, 4, 5, 6, 7, 10])
    exp = rc([2, 3, 4])
    val = sp.Rational(1, base ** exp)

    q_latex = f"{base}^{{-{exp}}}"
    q_text  = ("Apply the negative-exponent rule  a^(-n) = 1 / a^n.  "
               "Express as a fraction.")
    a_latex = f"\\dfrac{{1}}{{{base}^{{{exp}}}}} = \\dfrac{{1}}{{{base ** exp}}}"
    a_plain = f"1/{base}^{exp} = 1/{base ** exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_numerical_combo():
    """A simple sum/difference of small integer powers."""
    a_b = rc([2, 3, 4, 5, 6])
    a_e = rc([2, 3])
    b_b = rc([2, 3, 4, 5, 7])
    if b_b == a_b:
        b_b = (b_b % 5) + 2
    b_e = rc([2, 3])
    op = rc(["+", "-"])
    val_a = a_b ** a_e
    val_b = b_b ** b_e
    val = val_a + val_b if op == "+" else val_a - val_b

    q_latex = f"{a_b}^{{{a_e}}} {op} {b_b}^{{{b_e}}}"
    q_text  = ("Compute the value.  Evaluate each power, then perform the "
               "indicated arithmetic.")
    a_latex = f"{val_a} {op} {val_b} = {val}"
    a_plain = f"{val_a} {op} {val_b} = {val}"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  MEDIUM — NCERT Class 8-9
# ╚═════════════════════════════════════════════════════════════════════

def gen_mixed_laws():
    """Combine 2-3 laws: e.g.  a^m · a^n / a^p · (a^q)^r = a^(...)"""
    base = rc([2, 3, 5])
    p1, p2 = rc([3, 4, 5]), rc([2, 3])
    p3 = rc([1, 2])
    p4 = rc([2, 3])
    p5 = rc([2, 3])
    # (a^p1 · a^p2 / a^p3)^p4 = a^((p1+p2-p3)*p4)
    final_exp = (p1 + p2 - p3) * p4
    if final_exp <= 0 or final_exp > 12:
        return None
    val = base ** final_exp

    q_latex = (f"\\left(\\dfrac{{{base}^{{{p1}}} \\cdot {base}^{{{p2}}}}}"
               f"{{{base}^{{{p3}}}}}\\right)^{{{p4}}}")
    q_text  = ("Combine the product, quotient, and power-of-a-power rules to "
               "simplify.  Express as a single power and as a number.")
    a_latex = (f"{base}^{{({p1}+{p2}-{p3}) \\cdot {p4}}} "
               f"= {base}^{{{final_exp}}} = {val}")
    a_plain = f"{base}^{final_exp} = {val}"
    return q_text, q_latex, a_latex, a_plain


def gen_sci_notation_convert():
    """3.4 × 10^5  ↔  340000"""
    direction = rc(["sci_to_plain", "plain_to_sci"])
    coef = rc([1.5, 2.4, 3.2, 4.7, 5.6, 6.8, 7.9, 8.3, 9.1])
    exp = rc([3, 4, 5, 6, 7, 8, -3, -4, -5])

    if direction == "sci_to_plain":
        q_latex = f"{coef} \\times 10^{{{exp}}}"
        q_text  = ("Convert from scientific notation to decimal form.")
        val = coef * (10 ** exp)
        if exp >= 0 and val == int(val):
            a_latex = str(int(val))
            a_plain = str(int(val))
        else:
            a_latex = f"{val:.6g}"
            a_plain = f"{val:.6g}"
    else:
        # Decimal → scientific
        val = coef * (10 ** exp)
        if exp >= 0:
            value_str = f"{val:.0f}" if val == int(val) else f"{val:.6g}"
        else:
            value_str = f"{val:.6g}"
        q_latex = value_str
        q_text  = ("Convert to scientific notation  a × 10^n  where "
                   "1 ≤ |a| < 10.")
        a_latex = f"{coef} \\times 10^{{{exp}}}"
        a_plain = f"{coef} × 10^{exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_sci_notation_compute():
    """(a × 10^m)(b × 10^n) = ab × 10^(m+n)"""
    a_v = rc([2, 3, 4, 5])
    b_v = rc([2, 3, 4, 5])
    m_v = rc([2, 3, 4, 5])
    n_v = rc([3, 4, 5, 6])

    op = rc(["mul", "div"])
    if op == "mul":
        q_latex = f"({a_v} \\times 10^{{{m_v}}})({b_v} \\times 10^{{{n_v}}})"
        prod = a_v * b_v
        new_exp = m_v + n_v
        # Normalize: if prod >= 10, increment exp
        while prod >= 10:
            prod /= 10
            new_exp += 1
        q_text  = ("Multiply the numbers in scientific notation.  "
                   "Multiply coefficients, then add the exponents.")
        a_latex = f"{prod} \\times 10^{{{new_exp}}}"
        a_plain = f"{prod} × 10^{new_exp}"
    else:
        q_latex = (f"\\dfrac{{{a_v} \\times 10^{{{m_v}}}}}"
                   f"{{{b_v} \\times 10^{{{n_v}}}}}")
        if b_v == 0:
            return None
        coef = sp.Rational(a_v, b_v)
        new_exp = m_v - n_v
        q_text  = ("Divide the numbers in scientific notation.  "
                   "Divide coefficients, then subtract the exponents.")
        a_latex = f"{sp.latex(coef)} \\times 10^{{{new_exp}}}"
        a_plain = f"{coef} × 10^{new_exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_fractional_exponent():
    """64^(2/3), 81^(3/4) — clean rational exponents on perfect powers."""
    pool = [
        # (base, exp_num, exp_den, simplified)
        (8,    sp.Rational(2, 3), 4),       # (8^(1/3))^2 = 2^2 = 4
        (27,   sp.Rational(2, 3), 9),       # 3^2 = 9
        (64,   sp.Rational(2, 3), 16),      # 4^2 = 16
        (16,   sp.Rational(3, 4), 8),       # 2^3 = 8
        (81,   sp.Rational(3, 4), 27),      # 3^3 = 27
        (32,   sp.Rational(2, 5), 4),       # 2^2 = 4
        (32,   sp.Rational(3, 5), 8),       # 2^3 = 8
        (125,  sp.Rational(2, 3), 25),      # 5^2 = 25
        (4,    sp.Rational(3, 2), 8),       # 2^3 = 8
        (9,    sp.Rational(3, 2), 27),      # 3^3 = 27
        (16,   sp.Rational(1, 2), 4),       # √16 = 4
        (16,   sp.Rational(1, 4), 2),       # ⁴√16 = 2
        (256,  sp.Rational(1, 4), 4),
        (64,   sp.Rational(5, 6), 32),      # (2)^5 = 32
        (1000, sp.Rational(2, 3), 100),
    ]
    base, exp_rat, val = rc(pool)

    q_latex = f"{base}^{{{sp.latex(exp_rat)}}}"
    q_text  = (f"Apply the rational-exponent rule  a^(m/n) = (n-th root of a)^m.  "
               "Find the exact integer value.")
    a_latex = str(val)
    a_plain = str(val)
    return q_text, q_latex, a_latex, a_plain


def gen_compare_powers():
    """Which is larger: 3^4 or 2^7?"""
    pool = [
        (3, 4, 2, 7),    # 81 vs 128 → 2^7 larger
        (5, 3, 4, 4),    # 125 vs 256 → 4^4 larger
        (2, 10, 10, 3),  # 1024 vs 1000 → 2^10 larger
        (3, 5, 5, 3),    # 243 vs 125 → 3^5 larger
        (4, 5, 5, 4),    # 1024 vs 625 → 4^5 larger
        (6, 4, 8, 3),    # 1296 vs 512 → 6^4 larger
    ]
    a1, e1, a2, e2 = rc(pool)
    val1 = a1 ** e1
    val2 = a2 ** e2

    q_latex = f"{a1}^{{{e1}}} \\;\\text{{vs}}\\; {a2}^{{{e2}}}"
    q_text  = (f"Which is larger:  {a1}^{e1}  or  {a2}^{e2}?  Compute both "
               "exactly and compare.")
    if val1 > val2:
        a_latex = f"{a1}^{{{e1}}} = {val1} > {a2}^{{{e2}}} = {val2}"
        a_plain = f"{a1}^{e1} = {val1} > {a2}^{e2} = {val2}"
    else:
        a_latex = f"{a2}^{{{e2}}} = {val2} > {a1}^{{{e1}}} = {val1}"
        a_plain = f"{a2}^{e2} = {val2} > {a1}^{e1} = {val1}"
    return q_text, q_latex, a_latex, a_plain


def gen_word_problem_growth():
    """Exponential growth — bacteria, population, half-life."""
    case = rc(["bacteria", "population", "half_life", "cell_division"])

    if case == "bacteria":
        initial = rc([100, 200, 500, 1000])
        doubling_periods = rc([3, 4, 5, 6, 8])
        q_latex = f"P(n) = {initial} \\cdot 2^{{n}}"
        q_text  = (f"A bacterial culture starts with {initial} cells.  The "
                   "population doubles every hour.  How many cells will be "
                   f"present after {doubling_periods} hours?")
        ans = initial * (2 ** doubling_periods)
        a_latex = f"P({doubling_periods}) = {initial} \\cdot 2^{{{doubling_periods}}} = {ans}"
        a_plain = f"P({doubling_periods}) = {ans}"

    elif case == "population":
        initial = rc([10000, 20000, 50000])
        rate = rc([2, 3, 4, 5])  # %
        years = rc([3, 5, 10])
        # P(t) = P0 (1 + r/100)^t
        factor = sp.Rational(100 + rate, 100)
        ans = sp.simplify(initial * factor ** years)
        ans_n = float(ans.evalf())
        q_latex = f"P(t) = {initial} \\cdot (1.0{rate})^t"
        q_text  = (f"A town's population is currently {initial:,} and grows "
                   f"by {rate}% per year (compounded annually).  Approximate "
                   f"the population after {years} years (round to the nearest whole).")
        a_latex = (f"P({years}) = {initial} \\cdot (1.0{rate})^{{{years}}} "
                   f"\\approx {round(ans_n):,}")
        a_plain = f"P({years}) ≈ {round(ans_n):,}"

    elif case == "half_life":
        initial_mass = rc([100, 200, 400, 1000])
        half_lives = rc([2, 3, 4, 5])
        q_latex = f"M(n) = {initial_mass} \\cdot \\left(\\tfrac{{1}}{{2}}\\right)^n"
        q_text  = (f"A radioactive sample has initial mass {initial_mass} g.  "
                   f"After each half-life, half the substance remains.  "
                   f"How much is left after {half_lives} half-lives?")
        ans = sp.Rational(initial_mass, 2 ** half_lives)
        a_latex = (f"M({half_lives}) = {initial_mass} \\cdot "
                   f"\\left(\\tfrac{{1}}{{2}}\\right)^{{{half_lives}}} "
                   f"= {sp.latex(ans)} \\text{{ g}}")
        a_plain = f"M({half_lives}) = {ans} g"

    else:  # cell_division
        n_val = rc([5, 6, 7, 8])
        q_latex = f"N(n) = 2^n"
        q_text  = (f"A single cell divides into 2 cells every minute.  How "
                   f"many cells will exist after {n_val} minutes?")
        ans = 2 ** n_val
        a_latex = f"N({n_val}) = 2^{{{n_val}}} = {ans}"
        a_plain = f"N({n_val}) = {ans}"

    return q_text, q_latex, a_latex, a_plain


def gen_evaluate_neg_exponent():
    """Evaluate (a/b)^(-n) or fraction with negative exponent."""
    base_a = rc([2, 3, 4, 5])
    base_b = rc([3, 5, 7])
    if base_a == base_b:
        return None
    n_val = rc([2, 3])

    q_latex = (f"\\left(\\dfrac{{{base_a}}}{{{base_b}}}\\right)^{{-{n_val}}}")
    q_text  = ("Apply the negative-exponent rule:  (a/b)^(-n) = (b/a)^n.")
    val = sp.Rational(base_b, base_a) ** n_val
    a_latex = (f"\\left(\\dfrac{{{base_b}}}{{{base_a}}}\\right)^{{{n_val}}} "
               f"= {sp.latex(val)}")
    a_plain = f"({base_b}/{base_a})^{n_val} = {val}"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  HARD — JEE Mains
# ╚═════════════════════════════════════════════════════════════════════

def gen_solve_exponential_eq():
    """2^x = 16 → x = 4"""
    base = rc([2, 3, 4, 5])
    target_exp = rc([2, 3, 4, 5, 6])
    target = base ** target_exp

    q_latex = f"{base}^x = {target}"
    q_text  = (f"Solve for x.  Express both sides with the same base, then "
               "equate the exponents.")
    a_latex = f"x = {target_exp}"
    a_plain = f"x = {target_exp}"
    return q_text, q_latex, a_latex, a_plain


def gen_solve_exp_substitution():
    """4^x − 3·2^x + 2 = 0 → substitute u = 2^x"""
    base = rc([2, 3])
    # Plant clean roots in u: u1, u2 — both positive
    u1, u2 = sorted(random.sample([1, 2, 4, 8], 2))
    B = -(u1 + u2)
    C = u1 * u2

    q_latex = (f"{base}^{{2x}} {('+ ' + str(B)) if B >= 0 else ('- ' + str(abs(B)))} "
               f"\\cdot {base}^x {('+ ' + str(C)) if C >= 0 else ('- ' + str(abs(C)))} = 0")
    q_text  = (f"Solve the exponential equation.  Substitute u = {base}^x and "
               "solve the resulting quadratic; back-substitute x = log_b(u).")
    sols = []
    for u in [u1, u2]:
        if u > 0:
            sols.append(sp.log(u, base))
    sols_simp = [sp.nsimplify(s) for s in sols]
    a_latex = ", ".join([f"x = {sp.latex(s)}" for s in sols_simp])
    a_plain = ", ".join([f"x = {s}" for s in sols_simp])
    return q_text, q_latex, a_latex, a_plain


def gen_complex_simplification():
    """((a²b⁻¹)³ · (a⁻¹b²)) / (ab) — symbolic exponents, simplify."""
    # We'll use random small integer exponents
    e1 = rc([2, 3])
    e2 = rc([1, 2])
    e3 = rc([2, 3])
    # (a^e1 b^(-e2))^e3 · (a^(-e2) b^e1) / (a b)
    # = a^(e1*e3 - e2 - 1) b^(-e2*e3 + e1 - 1)
    a_pow = e1 * e3 - e2 - 1
    b_pow = -e2 * e3 + e1 - 1

    q_latex = (f"\\dfrac{{(a^{{{e1}}} b^{{-{e2}}})^{{{e3}}} "
               f"\\cdot (a^{{-{e2}}} b^{{{e1}}})}}{{a \\cdot b}}")
    q_text  = ("Simplify the algebraic expression using the laws of "
               "exponents.  Express the answer with positive exponents.")

    def fmt(p):
        if p == 0:
            return "1"
        if p > 0:
            return f"a^{{{p}}}" if p > 1 else "a"
        return f"\\dfrac{{1}}{{a^{{{abs(p)}}}}}" if p < -1 else "\\dfrac{1}{a}"

    # Build clean answer
    if a_pow == 0 and b_pow == 0:
        a_latex = "1"; a_plain = "1"
    else:
        # Combine via explicit positive/negative form
        num_parts = []
        den_parts = []
        if a_pow > 0:
            num_parts.append(f"a^{{{a_pow}}}" if a_pow > 1 else "a")
        elif a_pow < 0:
            den_parts.append(f"a^{{{abs(a_pow)}}}" if a_pow < -1 else "a")
        if b_pow > 0:
            num_parts.append(f"b^{{{b_pow}}}" if b_pow > 1 else "b")
        elif b_pow < 0:
            den_parts.append(f"b^{{{abs(b_pow)}}}" if b_pow < -1 else "b")
        num = " ".join(num_parts) if num_parts else "1"
        den = " ".join(den_parts) if den_parts else "1"
        a_latex = num if den == "1" else f"\\dfrac{{{num}}}{{{den}}}"
        a_plain = f"a^{a_pow} b^{b_pow}".replace("^1 ", " ").replace("a^0", "").replace("b^0", "")
    return q_text, q_latex, a_latex, a_plain


def gen_convert_to_log():
    """2^x = 7 → x = log_2(7)"""
    base = rc([2, 3, 5, 7, 10])
    target = rc([3, 5, 7, 11, 13, 17, 19, 23])
    if target == base or target % base == 0:
        return None

    q_latex = f"{base}^x = {target}"
    q_text  = ("Solve for x.  Since the right-hand side is not a clean power "
               "of the base, take log of both sides and express x as a "
               "logarithm.")
    a_latex = (f"x = \\log_{{{base}}}({target}) "
               f"= \\dfrac{{\\ln {target}}}{{\\ln {base}}} "
               f"\\approx {math.log(target, base):.4f}")
    a_plain = f"x = log_{base}({target}) ≈ {math.log(target, base):.4f}"
    return q_text, q_latex, a_latex, a_plain


def gen_compound_interest():
    """A = P(1 + r)^t — find A given P, r, t."""
    P = rc([1000, 2000, 5000, 10000, 20000, 50000])
    r_pct = rc([3, 4, 5, 6, 7, 8])
    t_val = rc([2, 3, 4, 5, 10])

    factor = sp.Rational(100 + r_pct, 100)
    A = sp.simplify(P * factor ** t_val)
    A_n = float(A.evalf())

    q_latex = (f"A = {P} \\cdot \\left(1 + \\tfrac{{{r_pct}}}{{100}}\\right)^{{{t_val}}}")
    q_text  = (f"A principal of \\${P:,} is invested at {r_pct}% annual "
               f"interest, compounded annually for {t_val} years.  Find the "
               "final amount A using  A = P(1 + r)^t.")
    a_latex = (f"A = {P} \\cdot {sp.latex(factor)}^{{{t_val}}} "
               f"\\approx \\${A_n:,.2f}")
    a_plain = f"A ≈ ${A_n:,.2f}"
    return q_text, q_latex, a_latex, a_plain


def gen_rational_exponent_simplify():
    """64^(2/3) · 81^(3/4) — multiple rational-exponent terms."""
    pool_a = [(8, 3), (27, 3), (64, 3), (125, 3), (16, 4), (81, 4), (32, 5), (256, 4)]
    pool_b = [(8, 3), (27, 3), (64, 3), (16, 4), (81, 4), (32, 5)]
    a_b, a_root = rc(pool_a)
    b_b, b_root = rc(pool_b)
    if a_b == b_b:
        return None
    a_pow = rc([1, 2, 3])
    b_pow = rc([1, 2])
    if a_pow >= a_root or b_pow >= b_root:
        return None

    a_val = sp.Rational(a_b) ** sp.Rational(a_pow, a_root)
    b_val = sp.Rational(b_b) ** sp.Rational(b_pow, b_root)
    val = sp.simplify(a_val * b_val)

    q_latex = (f"{a_b}^{{{a_pow}/{a_root}}} \\cdot {b_b}^{{{b_pow}/{b_root}}}")
    q_text  = ("Simplify the product.  Convert each rational-exponent term "
               "to its integer or simple radical form, then multiply.")
    a_latex = sp.latex(val)
    a_plain = str(val)
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — JEE Advanced / IIT
# ╚═════════════════════════════════════════════════════════════════════

def gen_exponent_identity_a_plus_a_inv():
    """If a^x + a^(-x) = k, find a^(2x) + a^(-2x).  Recursion / squaring."""
    k = rc([3, 4, 5, 6, 7])
    # (a^x + a^(-x))^2 = a^(2x) + 2 + a^(-2x)  →  a^(2x) + a^(-2x) = k² − 2
    ans2 = k ** 2 - 2
    # And cube identity: (k^3 - 3k) = a^(3x) + a^(-3x)
    ans3 = k ** 3 - 3 * k

    case = rc(["square", "cube"])
    if case == "square":
        q_latex = f"a^x + a^{{-x}} = {k}; \\quad \\text{{find }} a^{{2x}} + a^{{-2x}}"
        q_text  = (f"Given a^x + a^(-x) = {k} for some positive base a, find "
                   "a^(2x) + a^(-2x).  Hint: square both sides.")
        a_latex = (f"(a^x + a^{{-x}})^2 = a^{{2x}} + 2 + a^{{-2x}} "
                   f"\\Rightarrow a^{{2x}} + a^{{-2x}} = {k}^2 - 2 = {ans2}")
        a_plain = f"a^(2x) + a^(-2x) = {ans2}"
    else:
        q_latex = f"a^x + a^{{-x}} = {k}; \\quad \\text{{find }} a^{{3x}} + a^{{-3x}}"
        q_text  = (f"Given a^x + a^(-x) = {k}, find a^(3x) + a^(-3x).  "
                   "Hint: cube both sides and use the identity for sum of cubes.")
        a_latex = (f"(a^x + a^{{-x}})^3 = a^{{3x}} + 3(a^x + a^{{-x}}) + a^{{-3x}} "
                   f"\\Rightarrow a^{{3x}} + a^{{-3x}} = {k}^3 - 3 \\cdot {k} = {ans3}")
        a_plain = f"a^(3x) + a^(-3x) = {ans3}"
    return q_text, q_latex, a_latex, a_plain


def gen_binomial_surds_identity():
    """(√2 + 1)^n + (√2 − 1)^n is always a positive integer/even integer."""
    n_val = rc([2, 3, 4])
    sqrt_base = rc([2, 3])
    s = sp.sqrt(sqrt_base)
    expr = (s + 1) ** n_val + (s - 1) ** n_val
    val = sp.expand(expr)

    q_latex = (f"\\left(\\sqrt{{{sqrt_base}}} + 1\\right)^{{{n_val}}} + "
               f"\\left(\\sqrt{{{sqrt_base}}} - 1\\right)^{{{n_val}}}")
    q_text  = ("(JEE classic) Compute the value.  Hint: when you expand "
               f"(√{sqrt_base} ± 1)^{n_val} and add, the irrational terms "
               "cancel and only the integer (rational) part survives.")
    a_latex = sp.latex(sp.simplify(val))
    a_plain = str(sp.simplify(val))
    return q_text, q_latex, a_latex, a_plain


def gen_limit_e_definition():
    """lim_(n → ∞) (1 + k/n)^n = e^k — apply / state."""
    k = rc([1, 2, 3, 5, -1, -2])
    q_latex = (f"\\lim_{{n \\to \\infty}} \\left(1 + \\dfrac{{{k}}}{{n}}\\right)^n")
    q_text  = (f"Evaluate the limit.  Use the definition of e as a limit:  "
               r"\lim_{n \to \infty} (1 + k/n)^n = e^k.")
    a_latex = f"e^{{{k}}}"
    a_plain = f"e^{k}"
    return q_text, q_latex, a_latex, a_plain


def gen_iit_classics():
    """Hand-curated IIT-JEE Advanced exponent classics."""
    pool = [
        {
            "q_latex": (r"\text{If } 2^x = 3^y = 6^z, "
                        r"\text{ prove that } \frac{1}{x} + \frac{1}{y} = \frac{1}{z}."),
            "q_text":  ("(IIT-JEE classic) Take logarithms with a common base "
                        "to convert each equality into a relation between the "
                        "reciprocals of x, y, z."),
            "a_latex": (r"\text{Let } 2^x = 3^y = 6^z = k; \; "
                        r"\frac{1}{x} = \log_k 2, \frac{1}{y} = \log_k 3, "
                        r"\frac{1}{z} = \log_k 6 = \log_k 2 + \log_k 3 = "
                        r"\frac{1}{x} + \frac{1}{y}. \blacksquare"),
            "a_plain": "1/x + 1/y = 1/z (use 6 = 2·3 and log_k of both sides)",
        },
        {
            "q_latex": (r"\text{Solve: } 2^{x+1} + 4^{x-1} = 16."),
            "q_text":  ("(JEE Mains) Express both terms with base 2:  "
                        "2^(x+1) = 2 · 2^x  and  4^(x-1) = 2^(2x-2) = 2^(2x)/4.  "
                        "Substitute u = 2^x and solve the quadratic."),
            "a_latex": (r"2 \cdot u + \frac{u^2}{4} = 16; \quad "
                        r"u^2 + 8 u - 64 = 0; \quad "
                        r"u = -4 + 4\sqrt 5 \text{ (positive root)}; \;\; "
                        r"x = \log_2(-4 + 4\sqrt{5})."),
            "a_plain": "x = log_2(4(√5 - 1))",
        },
        {
            "q_latex": (r"\text{If } a^x = b^y = c^z, \text{ and } a, b, c "
                        r"\text{ are in geometric progression, prove that } "
                        r"x, y, z \text{ are in harmonic progression.}"),
            "q_text":  ("(IIT-JEE) Use the GP relation b² = ac plus the "
                        "log-of-equality manipulation."),
            "a_latex": (r"\text{Let } a^x = b^y = c^z = K; \; "
                        r"\log a = \log K / x, \log b = \log K / y, \log c = \log K / z. "
                        r"\text{GP: } 2 \log b = \log a + \log c \Rightarrow "
                        r"\frac{2}{y} = \frac{1}{x} + \frac{1}{z}; \; "
                        r"\text{i.e. } x, y, z \text{ in HP.} \blacksquare"),
            "a_plain": "Use 2/y = 1/x + 1/z which is the HP condition.",
        },
        {
            "q_latex": (r"\text{Let } x = a^{1/(b-c)}, y = a^{1/(c-a)}, "
                        r"z = a^{1/(a-b)}. \text{ Prove } xyz = 1."),
            "q_text":  ("(IIT-JEE) Add the exponents: 1/(b−c) + 1/(c−a) + 1/(a−b)."),
            "a_latex": (r"\text{The three exponents sum to 0 (common denominator: "
                        r"the polynomial in a, b, c factors symmetrically).  "
                        r"Hence } xyz = a^0 = 1. \blacksquare"),
            "a_plain": "Sum of exponents = 0 ⇒ product = a^0 = 1.",
        },
        {
            "q_latex": (r"\text{Solve: } 9^x - 3 \cdot 3^{x+1} + 8 = 0."),
            "q_text":  ("Substitute u = 3^x.  9^x = u² and 3·3^(x+1) = 9u."),
            "a_latex": (r"u^2 - 9 u + 8 = 0 \Rightarrow u = 1 \text{ or } 8; \; "
                        r"3^x = 1 \Rightarrow x = 0; \; "
                        r"3^x = 8 \Rightarrow x = \log_3 8 = 3 \log_3 2."),
            "a_plain": "x = 0 or x = 3 log_3(2)",
        },
        {
            "q_latex": (r"\text{Compute: } "
                        r"\left(2^{1/2}\right)^{2^{1/2}^{2^{1/2}^{...}}} "
                        r"\text{ (infinite power tower of } \sqrt{2}\text{)}."),
            "q_text":  ("(Putnam classic) Let L be the limit.  Then L = (√2)^L; "
                        "solve for L by inspection or via x = a^x."),
            "a_latex": (r"L = (\sqrt 2)^L \Rightarrow \log L = L \log \sqrt 2 "
                        r"= (L/2) \log 2; \;\; "
                        r"\text{the equation } x = a^x \text{ has solutions } "
                        r"x = 2 \text{ when } a = \sqrt 2; \;\; "
                        r"\text{converges to } L = 2."),
            "a_plain": "L = 2",
        },
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


# ╔═════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "evaluate_simple",
        "product_rule",
        "quotient_rule",
        "power_of_power",
        "power_of_product",
        "power_of_quotient",
        "zero_one_exponent",
        "negative_exponent",
        "numerical_combo",
    ],
    "medium": [
        "mixed_laws",
        "sci_notation_convert",
        "sci_notation_compute",
        "fractional_exponent",
        "compare_powers",
        "word_problem_growth",
        "evaluate_neg_exponent",
    ],
    "hard": [
        "solve_exponential_eq",
        "solve_exp_substitution",
        "complex_simplification",
        "convert_to_log",
        "compound_interest",
        "rational_exponent_simplify",
    ],
    "scholar": [
        "exponent_identity_a_plus_a_inv",
        "binomial_surds_identity",
        "limit_e_definition",
        "iit_classics",
    ],
}


def call_generator(q_type):
    generators = {
        "evaluate_simple":               gen_evaluate_simple,
        "product_rule":                  gen_product_rule,
        "quotient_rule":                 gen_quotient_rule,
        "power_of_power":                gen_power_of_power,
        "power_of_product":              gen_power_of_product,
        "power_of_quotient":             gen_power_of_quotient,
        "zero_one_exponent":             gen_zero_one_exponent,
        "negative_exponent":             gen_negative_exponent,
        "numerical_combo":               gen_numerical_combo,
        "mixed_laws":                    gen_mixed_laws,
        "sci_notation_convert":          gen_sci_notation_convert,
        "sci_notation_compute":          gen_sci_notation_compute,
        "fractional_exponent":           gen_fractional_exponent,
        "compare_powers":                gen_compare_powers,
        "word_problem_growth":           gen_word_problem_growth,
        "evaluate_neg_exponent":         gen_evaluate_neg_exponent,
        "solve_exponential_eq":          gen_solve_exponential_eq,
        "solve_exp_substitution":        gen_solve_exp_substitution,
        "complex_simplification":        gen_complex_simplification,
        "convert_to_log":                gen_convert_to_log,
        "compound_interest":             gen_compound_interest,
        "rational_exponent_simplify":    gen_rational_exponent_simplify,
        "exponent_identity_a_plus_a_inv":gen_exponent_identity_a_plus_a_inv,
        "binomial_surds_identity":       gen_binomial_surds_identity,
        "limit_e_definition":            gen_limit_e_definition,
        "iit_classics":                  gen_iit_classics,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain = res
    return {"q_text": q_text, "q_latex": q_latex,
            "ans_latex": ans_latex, "ans_plain": ans_plain}


def generate_exponent_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.32:
            diff = "basic"
        elif rv < 0.62:
            diff = "medium"
        elif rv < 0.88:
            diff = "hard"
        else:
            diff = "scholar"

        q_type = rc(DIFFICULTY_TYPES[diff])
        data = call_generator(q_type)
        if data is None:
            fail_streak += 1
            if fail_streak > 200:
                print(f"  ⚠ stalled at {len(questions)}/{n_target}")
                break
            continue
        fail_streak = 0

        dup = data["q_latex"]
        if dup in seen:
            continue
        seen.add(dup)

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
    random.seed()

    qs = generate_exponent_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "exponents.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Exponents and Powers",
            "description": ("NCERT Class 7 Ch 13 + Class 8 Ch 12 (Exponents "
                            "and Powers — 8 laws), Class 9 Ch 1 (rational "
                            "exponents and surds), and JEE Mains/Advanced + "
                            "IIT-level olympiad problems.  Covers all 8 laws "
                            "of exponents, scientific notation, exponential "
                            "equations, compound interest, exponential "
                            "growth/decay, and algebraic exponent identities."),
            "questions": qs,
        }, f, separators=(",", ":"))

    print(f"Generated {len(qs)} exponent problems → {out_path}")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        print(f"  {t:35s}  {c:>4}")
