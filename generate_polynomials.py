#!/usr/bin/env python3
"""
generate_polynomials.py
Practice problem bank for polynomial-calculator.jsp.

SymPy-as-source-of-truth — same strategy as generate_integrals.py /
generate_limits.py / generate_algebra_system_of_linear_equation.py:
  · Build the math symbolically with SymPy
  · Compute the answer with sp.expand / sp.factor / sp.div / sp.solve / sp.apart
  · Format LaTeX via sp.latex (no hand-rolled output)

Output: src/main/webapp/worksheet/math/algebra/polynomials.json

Difficulty tiers + 16 problem types follow the polynomial-calculator's
operation surface (Add / Subtract / Multiply / Divide / Expand / Factor /
Roots / Evaluate) plus the standard algebra-class fare around them.
"""

import sympy as sp
import json
import os
import random
from collections import Counter

random.seed(42)

x = sp.Symbol('x')
rc = random.choice
ri = random.randint


# ============================================================================
# Helpers
# ============================================================================

def poly_from_coeffs(coeffs, var=x):
    """coeffs[i] = coefficient of var**(len(coeffs)-1-i). Highest degree first."""
    n = len(coeffs) - 1
    return sum(c * var**(n - i) for i, c in enumerate(coeffs))


def random_poly(degree, lo=-5, hi=5, leading_min=1, var=x):
    """Random polynomial of exact degree `degree`, leading nonzero coefficient."""
    coeffs = []
    lc = rc([c for c in range(-hi, hi + 1) if abs(c) >= leading_min and c != 0])
    coeffs.append(lc)
    for _ in range(degree):
        coeffs.append(ri(lo, hi))
    return poly_from_coeffs(coeffs, var), coeffs


def random_factored_poly(roots, leading=1, var=x):
    """Build polynomial from roots: leading * (x-r1)(x-r2)...(x-rn)."""
    expr = sp.Integer(leading)
    for r in roots:
        expr = expr * (var - r)
    return sp.expand(expr)


def fmt_polynomial_latex(expr):
    """Standardize polynomial LaTeX. SymPy already does the right thing;
    this is the seam for any future tweaks (e.g. \\, spacing)."""
    return sp.latex(expr)


def fmt_plain(expr):
    """Plain-text polynomial — sympify-able representation."""
    return str(expr).replace('**', '^')


def fmt_linear_factor_text(c, var='x'):
    """Render (var − c) with correct sign in plain text. c=-4 → 'x + 4'."""
    if c == 0:
        return var
    return f"{var} - {c}" if c > 0 else f"{var} + {-c}"


def fmt_linear_factor_latex(c, var='x'):
    """LaTeX version of (var − c)."""
    if c == 0:
        return var
    return f"{var} - {c}" if c > 0 else f"{var} + {-c}"


# ============================================================================
# BASIC tier — addition, subtraction, evaluation, degree, like terms
# ============================================================================

def gen_add_polynomials():
    """Add two polynomials of degree 2-3."""
    deg1, deg2 = rc([2, 3]), rc([2, 3])
    p1, _ = random_poly(deg1)
    p2, _ = random_poly(deg2)
    result = sp.expand(p1 + p2)

    q_text = "Add the polynomials and simplify by combining like terms."
    q_latex = f"({fmt_polynomial_latex(p1)}) + ({fmt_polynomial_latex(p2)})"
    ans_latex = fmt_polynomial_latex(result)
    ans_plain = fmt_plain(result)
    return q_text, q_latex, ans_latex, ans_plain


def gen_subtract_polynomials():
    """Subtract one polynomial from another."""
    deg1, deg2 = rc([2, 3]), rc([2, 3])
    p1, _ = random_poly(deg1)
    p2, _ = random_poly(deg2)
    result = sp.expand(p1 - p2)

    q_text = "Subtract the second polynomial from the first."
    q_latex = f"({fmt_polynomial_latex(p1)}) - ({fmt_polynomial_latex(p2)})"
    ans_latex = fmt_polynomial_latex(result)
    ans_plain = fmt_plain(result)
    return q_text, q_latex, ans_latex, ans_plain


def gen_evaluate_polynomial():
    """Evaluate a polynomial at a small integer."""
    deg = rc([2, 3, 4])
    p, _ = random_poly(deg, lo=-4, hi=4)
    val = ri(-3, 4)
    result = p.subs(x, val)

    q_text = f"Evaluate the polynomial at x = {val}."
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}, \\quad P({val}) = ?"
    ans_latex = sp.latex(result)
    ans_plain = f"P({val}) = {result}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_identify_degree_lead_constant():
    """Read off degree, leading coefficient, and constant term."""
    deg = rc([2, 3, 4, 5])
    p, coeffs = random_poly(deg, lo=-6, hi=6)
    leading = coeffs[0]
    constant = coeffs[-1]

    q_text = "State the degree, leading coefficient, and constant term of the polynomial."
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    ans_latex = (
        f"\\text{{degree}} = {deg}, \\quad "
        f"\\text{{leading}} = {leading}, \\quad "
        f"\\text{{constant}} = {constant}"
    )
    ans_plain = f"degree = {deg}, leading = {leading}, constant = {constant}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_combine_like_terms():
    """Simplify a polynomial by combining like terms."""
    deg = rc([2, 3])
    # Build an unsimplified-looking polynomial: split each coefficient into
    # two random pieces so the displayed form has duplicate-power terms.
    p, coeffs = random_poly(deg, lo=-6, hi=6)
    # Build display by shuffling power groups and splitting some coefficients
    parts = []
    for i, c in enumerate(coeffs):
        power = deg - i
        if c != 0 and abs(c) > 1 and random.random() < 0.6:
            split = ri(-abs(c) - 2, abs(c) + 2)
            other = c - split
            parts.append((power, split))
            parts.append((power, other))
        else:
            parts.append((power, c))
    random.shuffle(parts)
    expr_unsimplified = sum(c * x**p for p, c in parts)
    # Sanity: re-expand should equal p
    if sp.simplify(sp.expand(expr_unsimplified) - p) != 0:
        return None
    # Build display string preserving the unsimplified order
    display_terms = []
    first = True
    for p_, c in parts:
        if c == 0:
            continue
        term = sp.latex(c * x**p_) if c > 0 or first else sp.latex(c * x**p_)
        if first:
            display_terms.append(term)
            first = False
        else:
            sign = "+" if c > 0 else ""
            display_terms.append(sign + " " + term)
    q_latex = " ".join(display_terms)

    q_text = "Combine like terms and write the polynomial in standard form."
    ans_latex = fmt_polynomial_latex(p)
    ans_plain = fmt_plain(p)
    return q_text, q_latex, ans_latex, ans_plain


# ============================================================================
# MEDIUM tier — multiplication, binomial powers, division, basic factor
# ============================================================================

def gen_multiply_polynomials():
    """Multiply two polynomials (FOIL through (linear)·(cubic))."""
    pattern = rc(['linear_linear', 'linear_quadratic', 'linear_cubic', 'quadratic_quadratic'])
    if pattern == 'linear_linear':
        p1, _ = random_poly(1, lo=-5, hi=5)
        p2, _ = random_poly(1, lo=-5, hi=5)
    elif pattern == 'linear_quadratic':
        p1, _ = random_poly(1, lo=-4, hi=4)
        p2, _ = random_poly(2, lo=-4, hi=4)
    elif pattern == 'linear_cubic':
        p1, _ = random_poly(1, lo=-3, hi=3)
        p2, _ = random_poly(3, lo=-3, hi=3)
    else:
        p1, _ = random_poly(2, lo=-3, hi=3)
        p2, _ = random_poly(2, lo=-3, hi=3)
    result = sp.expand(p1 * p2)

    q_text = "Multiply the polynomials and simplify."
    q_latex = f"({fmt_polynomial_latex(p1)})({fmt_polynomial_latex(p2)})"
    ans_latex = fmt_polynomial_latex(result)
    ans_plain = fmt_plain(result)
    return q_text, q_latex, ans_latex, ans_plain


def gen_expand_binomial_power():
    """Expand (a*x ± b)^n via binomial theorem."""
    n = rc([2, 2, 3, 3, 4])
    a = rc([1, 1, 2, 3])
    b = rc([-5, -4, -3, -2, 2, 3, 4, 5])
    base = a * x + b
    result = sp.expand(base ** n)

    q_text = f"Expand using the binomial theorem."
    q_latex = f"({fmt_polynomial_latex(base)})^{{{n}}}"
    ans_latex = fmt_polynomial_latex(result)
    ans_plain = fmt_plain(result)
    return q_text, q_latex, ans_latex, ans_plain


def gen_long_division():
    """Polynomial long division: degree-(2..4) divided by degree-(1..2)."""
    deg_q = rc([2, 3, 4])
    deg_d = rc([1, 1, 2])
    if deg_d >= deg_q:
        deg_d = 1
    # Build quotient and divisor with planted answer.
    quotient_deg = deg_q - deg_d
    # Pick clean quotient and divisor; actual dividend = q * d + r.
    quotient, _ = random_poly(quotient_deg, lo=-3, hi=3)
    divisor, _ = random_poly(deg_d, lo=-3, hi=3, leading_min=1)
    remainder, _ = random_poly(max(0, deg_d - 1), lo=-3, hi=3) if deg_d >= 1 else (sp.Integer(0), [0])
    # Make remainder strictly lower degree than divisor:
    if deg_d == 1:
        remainder = sp.Integer(ri(-3, 3))
    elif deg_d == 2:
        remainder, _ = random_poly(1, lo=-3, hi=3) if random.random() < 0.7 else (sp.Integer(ri(-3, 3)), [0])

    dividend = sp.expand(quotient * divisor + remainder)
    q_, r_ = sp.div(dividend, divisor, x)
    if sp.simplify(q_ - quotient) != 0 or sp.simplify(r_ - remainder) != 0:
        return None  # rare numerical edge — drop

    q_text = "Perform polynomial long division. Express the answer as quotient + remainder/divisor."
    q_latex = f"\\frac{{{fmt_polynomial_latex(dividend)}}}{{{fmt_polynomial_latex(divisor)}}}"
    if r_ == 0:
        ans_latex = fmt_polynomial_latex(quotient)
        ans_plain = f"quotient = {fmt_plain(quotient)}, remainder = 0"
    else:
        ans_latex = (f"{fmt_polynomial_latex(quotient)} + "
                     f"\\frac{{{fmt_polynomial_latex(r_)}}}{{{fmt_polynomial_latex(divisor)}}}")
        ans_plain = f"quotient = {fmt_plain(quotient)}, remainder = {fmt_plain(r_)}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_synthetic_division():
    """Synthetic division by (x - c) for small integer c."""
    deg = rc([3, 4])
    c = ri(-4, 4)
    if c == 0:
        c = 1
    quotient, _ = random_poly(deg - 1, lo=-3, hi=3)
    remainder = ri(-5, 5)
    divisor = x - c
    dividend = sp.expand(quotient * divisor + remainder)
    q_, r_ = sp.div(dividend, divisor, x)
    if sp.simplify(q_ - quotient) != 0 or sp.simplify(r_ - remainder) != 0:
        return None

    factor_str = fmt_linear_factor_text(c)
    q_text = f"Use synthetic division to divide by ({factor_str}) and state the quotient and remainder."
    q_latex = f"\\frac{{{fmt_polynomial_latex(dividend)}}}{{{fmt_linear_factor_latex(c)}}}"
    if r_ == 0:
        ans_latex = (f"\\text{{quotient}} = {fmt_polynomial_latex(quotient)}, "
                     f"\\quad \\text{{remainder}} = 0")
    else:
        ans_latex = (f"\\text{{quotient}} = {fmt_polynomial_latex(quotient)}, "
                     f"\\quad \\text{{remainder}} = {r_}")
    ans_plain = f"quotient = {fmt_plain(quotient)}, remainder = {r_}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_factor_quadratic():
    """Factor a monic or simple non-monic quadratic with integer roots."""
    r1, r2 = ri(-7, 7), ri(-7, 7)
    while r1 == r2:
        r2 = ri(-7, 7)
    a = rc([1, 1, 1, 2, 3])  # bias toward monic
    p = sp.expand(a * (x - r1) * (x - r2))
    factored = sp.factor(p)

    q_text = "Factor the quadratic completely."
    q_latex = fmt_polynomial_latex(p)
    ans_latex = fmt_polynomial_latex(factored)
    ans_plain = fmt_plain(factored)
    return q_text, q_latex, ans_latex, ans_plain


# ============================================================================
# HARD tier — special factoring, grouping, rational roots, build from roots
# ============================================================================

def gen_factor_special_pattern():
    """Difference of squares, sum/diff of cubes, perfect square trinomial."""
    pattern = rc(['diff_of_squares', 'sum_of_cubes', 'diff_of_cubes', 'perfect_square'])
    if pattern == 'diff_of_squares':
        a = ri(2, 8)
        b = ri(2, 8)
        if a == b:
            b += 1
        p = sp.expand((a * x)**2 - b**2)
        ctx = "Factor as a difference of squares."
    elif pattern == 'sum_of_cubes':
        a = ri(1, 4)
        b = ri(1, 4)
        p = sp.expand((a * x)**3 + b**3)
        ctx = "Factor as a sum of cubes (a³ + b³ = (a+b)(a²−ab+b²))."
    elif pattern == 'diff_of_cubes':
        a = ri(1, 4)
        b = ri(1, 4)
        p = sp.expand((a * x)**3 - b**3)
        ctx = "Factor as a difference of cubes (a³ − b³ = (a−b)(a²+ab+b²))."
    else:  # perfect_square
        a = ri(1, 5)
        b = rc([-5, -4, -3, -2, 2, 3, 4, 5])
        p = sp.expand((a * x + b)**2)
        ctx = "Factor as a perfect square trinomial."
    factored = sp.factor(p)

    q_text = ctx
    q_latex = fmt_polynomial_latex(p)
    ans_latex = fmt_polynomial_latex(factored)
    ans_plain = fmt_plain(factored)
    return q_text, q_latex, ans_latex, ans_plain


def gen_factor_grouping():
    """4-term polynomial factorable by grouping: ax³+bx²+cx+d where (ax²+c)(x+e)."""
    a = rc([1, 1, 2])
    b = rc([2, 3, 4, 5])
    c = ri(2, 6)
    d = b * c  # so grouping works: (a x³ + b x²) + (c x + b·c) → x²(ax+b) + c(x+b)·a... not always
    # Cleaner construction: (ax² + c)(x + b/a). Pick b multiple of a:
    a = rc([1, 2])
    e = ri(2, 5)
    f = ri(2, 6)
    g = ri(-5, -2) if random.random() < 0.5 else ri(2, 5)
    # Build (a*x² + e) * (x + f) and expand
    p = sp.expand((a * x**2 + e) * (x + f))
    # Or 4-term version with negatives: (ax³ + bx² + cx + d) where group splits cleanly
    # Use the simpler: factor by grouping as (a*x² + e)(x + f)
    factored = sp.factor(p)
    if factored == p or len(sp.Poly(p, x).all_coeffs()) < 4:
        return None  # not actually factorable as expected

    q_text = "Factor the polynomial completely by grouping."
    q_latex = fmt_polynomial_latex(p)
    ans_latex = fmt_polynomial_latex(factored)
    ans_plain = fmt_plain(factored)
    return q_text, q_latex, ans_latex, ans_plain


def gen_find_rational_roots():
    """Find all rational roots of a cubic / quartic via Rational Root Theorem."""
    deg = rc([3, 4])
    # Construct from rational roots; scale so coefficients are integers.
    if deg == 3:
        roots = sorted([ri(-4, 4) for _ in range(3)])
    else:
        roots = sorted([ri(-3, 3) for _ in range(4)])
    # Avoid trivial all-same roots
    if len(set(roots)) == 1:
        return None
    a = rc([1, 1, 2])
    p = a * sp.prod(x - r for r in roots)
    p_expanded = sp.expand(p)
    # Verify SymPy returns the same roots
    sym_roots = sp.solve(p_expanded, x)
    sym_roots_set = sorted([sp.nsimplify(r) for r in sym_roots if r.is_real])
    expected_set = sorted(set(roots))
    if [sp.simplify(r) for r in sym_roots_set] != [sp.simplify(sp.Integer(r)) for r in expected_set]:
        return None

    q_text = "Find all real roots using the Rational Root Theorem."
    q_latex = fmt_polynomial_latex(p_expanded)
    roots_unique = sorted(set(roots))
    ans_latex = ", \\quad ".join(f"x = {sp.latex(sp.Integer(r))}" for r in roots_unique)
    ans_plain = "x = " + ", ".join(str(r) for r in roots_unique)
    return q_text, q_latex, ans_latex, ans_plain


def gen_polynomial_from_roots():
    """Build the monic polynomial with given roots."""
    deg = rc([2, 3, 4])
    roots = []
    while len(roots) < deg:
        r = ri(-5, 5)
        if r not in roots:
            roots.append(r)
    p = sp.prod(x - r for r in roots)
    p_expanded = sp.expand(p)

    q_text = (f"Write the monic polynomial of degree {deg} with the given roots, "
              f"in standard form (expanded).")
    roots_latex = ", \\; ".join(str(r) for r in roots)
    q_latex = f"\\text{{roots}}: {roots_latex}"
    ans_latex = fmt_polynomial_latex(p_expanded)
    ans_plain = fmt_plain(p_expanded)
    return q_text, q_latex, ans_latex, ans_plain


def gen_remainder_factor_theorem():
    """Apply Remainder/Factor Theorem: P(c) = remainder; (x-c) divides P iff P(c)=0."""
    is_factor = rc([True, False])
    deg = rc([3, 4])
    # Pick c
    c = ri(-4, 4)
    if c == 0:
        c = 1
    if is_factor:
        # Construct so (x - c) IS a factor
        other_roots = [ri(-4, 4) for _ in range(deg - 1)]
        p = sp.expand(sp.prod([x - c] + [x - r for r in other_roots]))
    else:
        # Random poly, P(c) ≠ 0
        p, _ = random_poly(deg, lo=-3, hi=3)
        if p.subs(x, c) == 0:
            p += rc([1, -1])  # nudge

    rem = p.subs(x, c)
    factor_text = fmt_linear_factor_text(c)
    factor_latex = fmt_linear_factor_latex(c)

    q_text = (f"Use the Remainder Theorem to find P({c}). "
              f"Then state whether ({factor_text}) is a factor of P(x).")
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    is_fact = (rem == 0)
    if is_fact:
        ans_latex = (f"P({c}) = 0, \\quad \\text{{so }}({factor_latex}) "
                     f"\\text{{ IS a factor of }}P(x).")
        ans_plain = f"P({c}) = 0, ({factor_text}) IS a factor"
    else:
        ans_latex = (f"P({c}) = {sp.latex(rem)}, \\quad \\text{{so }}({factor_latex}) "
                     f"\\text{{ is NOT a factor of }}P(x).")
        ans_plain = f"P({c}) = {rem}, ({factor_text}) is NOT a factor"
    return q_text, q_latex, ans_latex, ans_plain


# ============================================================================
# SCHOLAR tier — high-degree factor, polynomial inequality, partial fractions
# ============================================================================

def gen_factor_high_degree():
    """Fully factor a degree-4 or degree-5 polynomial with rational roots."""
    deg = rc([4, 5])
    roots = []
    while len(roots) < deg:
        r = ri(-3, 3)
        if r not in roots and r != 0:
            roots.append(r)
        elif r not in roots:
            roots.append(r)
    p = sp.expand(sp.prod(x - r for r in roots))
    factored = sp.factor(p)

    q_text = f"Factor the degree-{deg} polynomial completely over the rationals."
    q_latex = fmt_polynomial_latex(p)
    ans_latex = fmt_polynomial_latex(factored)
    ans_plain = fmt_plain(factored)
    return q_text, q_latex, ans_latex, ans_plain


def gen_polynomial_inequality():
    """Solve P(x) > 0 (or < 0, ≥ 0, ≤ 0) using sign analysis."""
    deg = rc([2, 3])
    roots = sorted(set([ri(-4, 4) for _ in range(deg)]))
    if len(roots) != deg:
        return None
    a = rc([1, 1, 2])  # leading coefficient sign
    if random.random() < 0.5:
        a = -a
    p = a * sp.prod(x - r for r in roots)
    p_exp = sp.expand(p)
    op = rc(['>', '<', '>=', '<='])
    op_latex = {'>': '>', '<': '<', '>=': r'\geq', '<=': r'\leq'}[op]

    # Use SymPy to get the solution set
    sol_set = sp.solve_univariate_inequality(
        sp.Eq(0, 0).rewrite(sp.GreaterThan)  # placeholder — proper construction below
        if False else (eval(f"sp.S(p_exp) {op} 0", {"sp": sp, "p_exp": p_exp})),
        x, relational=False
    )
    # Convert SymPy interval/union to LaTeX
    try:
        ans_latex = sp.latex(sol_set)
    except Exception:
        return None
    ans_plain = str(sol_set)

    q_text = "Solve the polynomial inequality. Express the solution in interval notation."
    q_latex = f"{fmt_polynomial_latex(p_exp)} \\; {op_latex} \\; 0"
    return q_text, q_latex, ans_latex, ans_plain


def gen_partial_fractions():
    """Partial-fraction decomposition of a proper rational with linear / quadratic factors."""
    # Build denominator from 2-3 distinct linear factors
    pattern = rc(['two_linear', 'three_linear', 'linear_quadratic'])
    if pattern == 'two_linear':
        r1, r2 = ri(-4, 4), ri(-4, 4)
        while r1 == r2:
            r2 = ri(-4, 4)
        denom = sp.expand((x - r1) * (x - r2))
    elif pattern == 'three_linear':
        r1, r2, r3 = ri(-3, 3), ri(-3, 3), ri(-3, 3)
        if len({r1, r2, r3}) != 3:
            return None
        denom = sp.expand((x - r1) * (x - r2) * (x - r3))
    else:  # linear_quadratic (irreducible quadratic + linear)
        r1 = ri(-4, 4)
        a, b = ri(1, 3), ri(1, 5)  # x² + ax + b, ensure irreducible
        if a*a - 4*b >= 0:
            b = a*a // 4 + ri(1, 3)
        denom = sp.expand((x - r1) * (x**2 + a*x + b))

    # Numerator strictly lower degree
    denom_deg = sp.degree(denom, x)
    numer_deg = ri(0, max(0, denom_deg - 1))
    numer, _ = random_poly(numer_deg, lo=-5, hi=5) if numer_deg > 0 else (sp.Integer(ri(-5, 5)), [0])
    rational = numer / denom
    decomposed = sp.apart(rational, x)
    if decomposed == rational:
        return None  # SymPy couldn't decompose — rare

    q_text = "Decompose the rational expression into partial fractions."
    q_latex = f"\\frac{{{fmt_polynomial_latex(numer)}}}{{{fmt_polynomial_latex(denom)}}}"
    ans_latex = sp.latex(decomposed)
    ans_plain = fmt_plain(decomposed)
    return q_text, q_latex, ans_latex, ans_plain


# ============================================================================
# Extended generators — added to cover parametric, word-context, and
# scholar-tier patterns from the IIT/MIT-style problem set:
#   · find k for factor / find k for common factor
#   · word problems (area, volume, consecutive integers)
#   · double-root factoring with multiplicity
#   · radical-root monic polynomials (1 ± √2 conjugate pairs)
#   · multi-divisibility parameter problems (P divisible by (x−a) AND (x−b))
#   · Vieta symmetric functions (Σαᵢ², etc.)
#   · nature-of-roots discriminant analysis (3 distinct real roots)
# Each uses SymPy as the source-of-truth — same strategy as the rest.
# ============================================================================

def gen_find_k_for_factor():
    """Find k so that (x − c) is a factor of a parametric polynomial.

    Strategy: build P(x) from CLEAN integer roots first, then replace one
    coefficient with the symbol k and ask the student to recover it.
    Guarantees the "other roots" are also clean integers.
    """
    k_sym = sp.Symbol('k')
    deg = rc([3, 3, 4])

    # Pick clean distinct integer roots. The factor (x − c) is one of them.
    while True:
        roots = []
        while len(roots) < deg:
            r = ri(-4, 4)
            if r not in roots:
                roots.append(r)
        if 0 not in roots:  # avoid weird "x" factor
            break
    c = roots[0]
    other_roots = roots[1:]
    leading = rc([1, 1, 2])
    p_full = sp.expand(leading * sp.prod(x - r for r in roots))

    # Express as sum of c_i * x^(deg-i), then sub one coefficient with k.
    poly_obj = sp.Poly(p_full, x)
    int_coeffs = [int(c) for c in poly_obj.all_coeffs()]
    # Replace coefficient at slot s (1..deg) with k_sym; remember its true value.
    slot = ri(1, deg)
    real_k = int_coeffs[slot]
    p_with_k_terms = []
    for i, coef in enumerate(int_coeffs):
        power = deg - i
        if i == slot:
            p_with_k_terms.append(k_sym * x**power if power > 0 else k_sym)
        else:
            p_with_k_terms.append(coef * x**power)
    p_param = sum(p_with_k_terms)

    # Verify: solving P(c) = 0 for k should give back real_k.
    sols = sp.solve(sp.Eq(p_param.subs(x, c), 0), k_sym)
    if not sols or sp.simplify(sols[0] - real_k) != 0:
        return None

    factor_text = fmt_linear_factor_text(c)
    factor_latex = fmt_linear_factor_latex(c)
    q_text = (f"Find the value of k for which ({factor_text}) is a factor of P(x). "
              f"Then list the remaining roots.")
    q_latex = f"P(x) = {fmt_polynomial_latex(p_param)}"
    sep = ", \\; "
    roots_str = sep.join(f"x = {r}" for r in other_roots)
    ans_latex = (f"k = {real_k}, \\quad \\text{{remaining roots: }} {roots_str}")
    ans_plain = (f"k = {real_k}; remaining roots: " +
                 ", ".join(f"x = {r}" for r in other_roots))
    return q_text, q_latex, ans_latex, ans_plain


def gen_common_factor_param():
    """Two polynomials share a common linear factor — find the parameter k."""
    k_sym = sp.Symbol('k')
    common_root = ri(-4, 4)
    if common_root == 0:
        common_root = 1

    # First poly: parametric — has k in the constant term so that P(common_root) = 0 → k = ...
    a_p, b_p, c_p = rc([1, 1, 2]), rc([-4, -3, -2, -1, 1, 2, 3, 4]), rc([-4, -3, -2, -1, 1, 2, 3, 4])
    p_with_k = a_p * x**3 + b_p * x**2 + c_p * x + k_sym
    sol_for_k = sp.solve(sp.Eq(p_with_k.subs(x, common_root), 0), k_sym)
    if not sol_for_k:
        return None
    k_val = sol_for_k[0]

    # Second poly: a quadratic with common_root as one of its roots
    other_root = ri(-4, 4)
    while other_root == common_root:
        other_root = ri(-4, 4)
    q_poly = sp.expand((x - common_root) * (x - other_root))

    q_text = ("The polynomials P(x) and Q(x) below share a common linear factor. "
              "Find k and identify the common factor.")
    q_latex = (f"P(x) = {fmt_polynomial_latex(p_with_k)}, \\quad "
               f"Q(x) = {fmt_polynomial_latex(q_poly)}")
    factor_text = fmt_linear_factor_text(common_root)
    factor_latex = fmt_linear_factor_latex(common_root)
    ans_latex = (f"k = {sp.latex(k_val)}, \\quad \\text{{common factor: }} "
                 f"({factor_latex})")
    ans_plain = f"k = {k_val}, common factor: ({factor_text})"
    return q_text, q_latex, ans_latex, ans_plain


def gen_polynomial_word_context():
    """Word problems where a polynomial models area / volume / consecutive numbers."""
    context = rc(['area', 'volume', 'consecutive_even'])

    if context == 'area':
        # Rectangle area = (x + a)(x + b), ask to factor for length × width.
        a, b = ri(2, 9), ri(2, 9)
        if a == b:
            b += 1
        area_poly = sp.expand((x + a) * (x + b))
        q_text = (f"The area of a rectangle, in square units, is "
                  f"A(x) = {fmt_plain(area_poly)}. Factor A(x) to find expressions "
                  f"for the possible length and width (in terms of x).")
        q_latex = f"A(x) = {fmt_polynomial_latex(area_poly)}"
        factored = sp.factor(area_poly)
        ans_latex = (f"\\text{{length}} \\times \\text{{width}} = "
                     f"{fmt_polynomial_latex(factored)}")
        ans_plain = f"(x+{a})(x+{b})"
        return q_text, q_latex, ans_latex, ans_plain

    if context == 'volume':
        # Box volume V(x) = product of three (x+a)(x+b)(x+c) for some integer roots.
        roots = sorted(set(ri(-4, 4) for _ in range(3)))
        if len(roots) != 3:
            return None
        # Encourage at least one positive root (positive integer dimension)
        if not any(r >= 0 for r in roots):
            roots[-1] = abs(roots[-1])
        vol = sp.expand(sp.prod(x - r for r in roots))
        q_text = (f"A rectangular box has volume V(x) = {fmt_plain(vol)} cubic units. "
                  f"Factor V(x) and list any positive integer roots (where V(x) = 0).")
        q_latex = f"V(x) = {fmt_polynomial_latex(vol)}"
        factored = sp.factor(vol)
        pos_roots = [r for r in roots if r > 0]
        if pos_roots:
            sep = ", \\; "
            roots_inline = sep.join(str(r) for r in pos_roots)
            ans_latex = (f"V(x) = {fmt_polynomial_latex(factored)}, \\quad "
                         f"\\text{{positive roots: }} x = {roots_inline}")
            ans_plain = f"V(x) = {fmt_plain(factored)}, positive roots: {pos_roots}"
        else:
            ans_latex = (f"V(x) = {fmt_polynomial_latex(factored)}, \\quad "
                         f"\\text{{no positive integer roots}}")
            ans_plain = f"V(x) = {fmt_plain(factored)}, no positive integer roots"
        return q_text, q_latex, ans_latex, ans_plain

    # consecutive_even: x(x+2) = N → solve quadratic
    pair = rc([(8, 10), (10, 12), (12, 14), (14, 16), (16, 18)])
    n1, n2 = pair
    product = n1 * n2
    eq_text = f"x(x + 2) = {product}"
    q_text = (f"The product of two consecutive even integers is {product}. If the "
              f"smaller integer is x, write the equation and solve it. Verify "
              f"with Vieta's formulas (sum and product of roots).")
    q_latex = f"x(x + 2) = {product}"
    # Solve x² + 2x − product = 0
    roots = sp.solve(x*(x + 2) - product, x)
    real_roots = sorted([r for r in roots if r.is_real], key=float)
    sum_roots = -2  # by Vieta: −(coeff of x)/leading = −2/1
    prod_roots = -product
    ans_latex = (f"\\text{{roots}}: x = {sp.latex(real_roots[0])}, "
                 f"x = {sp.latex(real_roots[-1])}; \\quad "
                 f"\\text{{Vieta: }} \\sum x = {sum_roots}, \\; \\prod x = {prod_roots}")
    ans_plain = f"x = {real_roots[0]} or {real_roots[-1]}; sum={sum_roots}, product={prod_roots}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_double_root_factor():
    """Polynomial with a known double root — factor completely."""
    deg = rc([3, 4])
    double_r = ri(-3, 3)
    if double_r == 0:
        double_r = 1
    other_roots = []
    while len(other_roots) < deg - 2:
        r = ri(-4, 4)
        if r != double_r and r not in other_roots:
            other_roots.append(r)
    p = sp.expand(((x - double_r)**2) * sp.prod(x - r for r in other_roots))

    q_text = (f"Given that x = {double_r} is a double root, factor the polynomial "
              f"completely and list all roots with multiplicities.")
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    factored = sp.factor(p)
    roots_desc = [(double_r, 2)] + [(r, 1) for r in other_roots]
    roots_text = ", \\quad ".join(
        f"x = {r} \\;(\\text{{mult.}}\\, {m})" for r, m in sorted(roots_desc)
    )
    ans_latex = f"P(x) = {fmt_polynomial_latex(factored)}; \\quad {roots_text}"
    ans_plain = (f"P(x) = {fmt_plain(factored)}; roots: " +
                 ", ".join(f"x={r} (mult {m})" for r, m in sorted(roots_desc)))
    return q_text, q_latex, ans_latex, ans_plain


def gen_radical_root_polynomial():
    """Build monic polynomial with conjugate-pair radical roots — Scholar 2."""
    # Pick a + √b and a − √b conjugate pair, plus 1-2 rational roots
    a = ri(-3, 3)
    b = rc([2, 3, 5, 6, 7, 10])
    rational_root1 = ri(-4, 4)
    use_double = rc([True, False])
    if use_double:
        # Conjugate pair + double rational root → degree 4
        roots_for_construction = [a + sp.sqrt(b), a - sp.sqrt(b),
                                  rational_root1, rational_root1]
        descr_roots = (f"1 \\pm \\sqrt{{{b}}}".replace('1', str(a) if a != 1 else '1') +
                       f", \\; x = {rational_root1} \\;(\\text{{multiplicity 2}})")
        # Cleaner: build the description string manually
        if a == 0:
            radical_pair = f"\\pm \\sqrt{{{b}}}"
        elif a > 0:
            radical_pair = f"{a} \\pm \\sqrt{{{b}}}"
        else:
            radical_pair = f"{a} \\pm \\sqrt{{{b}}}"
        descr_roots = (f"x = {radical_pair}, \\; "
                       f"x = {rational_root1} \\;(\\text{{multiplicity 2}})")
    else:
        # Conjugate pair + 2 distinct rational roots → degree 4
        rational_root2 = ri(-4, 4)
        while rational_root2 == rational_root1:
            rational_root2 = ri(-4, 4)
        roots_for_construction = [a + sp.sqrt(b), a - sp.sqrt(b),
                                  rational_root1, rational_root2]
        if a == 0:
            radical_pair = f"\\pm \\sqrt{{{b}}}"
        else:
            radical_pair = f"{a} \\pm \\sqrt{{{b}}}"
        descr_roots = (f"x = {radical_pair}, \\; x = {rational_root1}, "
                       f"\\; x = {rational_root2}")

    p = sp.expand(sp.prod(x - r for r in roots_for_construction))
    # Verify coefficients are rational (integer) — radical conjugate pairs guarantee this
    poly_obj = sp.Poly(p, x)
    if not all(coeff.is_rational for coeff in poly_obj.all_coeffs()):
        return None

    q_text = ("Form the monic polynomial of minimal degree (with rational "
              "coefficients) having the given roots. Expand fully.")
    q_latex = f"\\text{{roots: }} {descr_roots}"
    ans_latex = fmt_polynomial_latex(p)
    ans_plain = fmt_plain(p)
    return q_text, q_latex, ans_latex, ans_plain


def gen_multi_divisibility_params():
    """Find a, b such that P(x) is divisible by both (x−c1) AND (x−c2)."""
    a_sym, b_sym = sp.symbols('a b')
    # Build P(x) = x³ + a x² + b x + d with two unknowns a, b
    d = rc([-12, -6, -4, 6, 12])  # constant term
    c1, c2 = rc([1, 2, 3, -1, -2, -3]), rc([1, 2, 3, -1, -2, -3])
    while c1 == c2:
        c2 = rc([1, 2, 3, -1, -2, -3])

    p = x**3 + a_sym * x**2 + b_sym * x + d
    # Two equations: P(c1) = 0, P(c2) = 0
    eqs = [p.subs(x, c1), p.subs(x, c2)]
    sols = sp.solve(eqs, [a_sym, b_sym])
    if not sols or a_sym not in sols or b_sym not in sols:
        return None
    a_val, b_val = sols[a_sym], sols[b_sym]
    if not (a_val.is_rational and b_val.is_rational):
        return None

    # Substitute back, find third root
    p_full = p.subs([(a_sym, a_val), (b_sym, b_val)])
    all_roots = sp.solve(p_full, x)
    third_roots = [r for r in all_roots if sp.simplify(r - c1) != 0
                   and sp.simplify(r - c2) != 0]
    third = third_roots[0] if third_roots else None

    factor1 = fmt_linear_factor_text(c1)
    factor2 = fmt_linear_factor_text(c2)
    q_text = (f"Find a and b such that P(x) is divisible by both "
              f"({factor1}) and ({factor2}). Then state the third root.")
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    if third is not None:
        ans_latex = (f"a = {sp.latex(a_val)}, \\; b = {sp.latex(b_val)}, "
                     f"\\quad \\text{{third root: }} x = {sp.latex(third)}")
        ans_plain = f"a = {a_val}, b = {b_val}, third root x = {third}"
    else:
        ans_latex = f"a = {sp.latex(a_val)}, \\; b = {sp.latex(b_val)}"
        ans_plain = f"a = {a_val}, b = {b_val}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_vieta_symmetric_functions():
    """Compute Σαᵢ² (or Σαᵢ³, ΣαᵢαⱼΣ etc.) using Vieta's formulas only."""
    deg = rc([3, 4])
    if deg == 3:
        # P(x) = x³ + a x² + b x + c. Roots α, β, γ.
        # α + β + γ = -a, αβ + αγ + βγ = b, αβγ = -c.
        a, b, c = ri(-5, 5), ri(-6, 6), ri(-8, 8)
        p = x**3 + a * x**2 + b * x + c
        sum_sq = sp.expand((-a)**2 - 2 * b)  # α²+β²+γ² = (Σα)² - 2Σαβ
        target_text = r"\alpha^2 + \beta^2 + \gamma^2"
        ans_latex = f"{target_text} = (-a)^2 - 2b = {a}^2 - 2({b}) = {sum_sq}"
        ans_plain = f"α²+β²+γ² = a²-2b = {sum_sq}"
    else:
        # P(x) = x⁴ + a x³ + b x² + c x + d. Roots α, β, γ, δ.
        # Σα = -a, Σαβ = b. Σα² = (Σα)² - 2(Σαβ) = a² - 2b.
        a, b, c, d = ri(-5, 5), ri(-6, 6), ri(-6, 6), ri(-8, 8)
        p = x**4 + a * x**3 + b * x**2 + c * x + d
        sum_sq = a*a - 2*b
        target_text = r"\alpha^2 + \beta^2 + \gamma^2 + \delta^2"
        ans_latex = f"{target_text} = a^2 - 2b = {a}^2 - 2({b}) = {sum_sq}"
        ans_plain = f"α²+β²+γ²+δ² = a²-2b = {sum_sq}"

    q_text = (f"Without solving the polynomial, use Vieta's formulas to express "
              f"{target_text.replace(chr(92), '')} in terms of the coefficients, "
              f"and evaluate.")
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    return q_text, q_latex, ans_latex, ans_plain


def gen_nature_of_roots_param():
    """Find values of k for which a parametric cubic has 3 distinct real roots.

    Strategy: pick a cubic P(x) = x³ + a x² + k x + c (parameter k in linear
    coefficient), compute the discriminant Δ(k) symbolically, ask: 'find the
    range of k for which Δ > 0 (three distinct real roots).'
    """
    k_sym = sp.Symbol('k', real=True)
    a = rc([-3, -2, 0, 2, 3])
    c = rc([-3, -2, -1, 1, 2, 3])
    p = x**3 + a * x**2 + k_sym * x + c

    # Cubic discriminant: Δ = 18abcd − 4b³d + b²c² − 4ac³ − 27a²d² (where ax³+bx²+cx+d)
    # For our monic cubic with leading 1, the discriminant in k is a polynomial.
    disc = sp.discriminant(p, x)
    disc_expanded = sp.expand(disc)
    # Solve disc > 0
    try:
        sol_set = sp.solve_univariate_inequality(disc_expanded > 0, k_sym, relational=False)
        ans_latex = sp.latex(sol_set)
        ans_plain = str(sol_set)
    except Exception:
        return None

    q_text = ("Determine the range of k for which the polynomial has three "
              "distinct real roots, using the discriminant.")
    q_latex = f"P(x) = {fmt_polynomial_latex(p)}"
    return q_text, q_latex, ans_latex, ans_plain


# ============================================================================
# Dispatcher
# ============================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "add_polynomials",
        "subtract_polynomials",
        "evaluate_polynomial",
        "identify_degree_lead_constant",
        "combine_like_terms",
    ],
    "medium": [
        "multiply_polynomials",
        "expand_binomial_power",
        "long_division",
        "synthetic_division",
        "factor_quadratic",
        "polynomial_word_context",
    ],
    "hard": [
        "factor_special_pattern",
        "factor_grouping",
        "find_rational_roots",
        "polynomial_from_roots",
        "remainder_factor_theorem",
        "find_k_for_factor",
        "common_factor_param",
    ],
    "scholar": [
        "factor_high_degree",
        "polynomial_inequality",
        "partial_fractions",
        "double_root_factor",
        "radical_root_polynomial",
        "multi_divisibility_params",
        "vieta_symmetric_functions",
        "nature_of_roots_param",
    ],
}


def call_generator(q_type):
    generators = {
        "add_polynomials":            gen_add_polynomials,
        "subtract_polynomials":       gen_subtract_polynomials,
        "evaluate_polynomial":        gen_evaluate_polynomial,
        "identify_degree_lead_constant": gen_identify_degree_lead_constant,
        "combine_like_terms":         gen_combine_like_terms,
        "multiply_polynomials":       gen_multiply_polynomials,
        "expand_binomial_power":      gen_expand_binomial_power,
        "long_division":              gen_long_division,
        "synthetic_division":         gen_synthetic_division,
        "factor_quadratic":           gen_factor_quadratic,
        "factor_special_pattern":     gen_factor_special_pattern,
        "factor_grouping":            gen_factor_grouping,
        "find_rational_roots":        gen_find_rational_roots,
        "polynomial_from_roots":      gen_polynomial_from_roots,
        "remainder_factor_theorem":   gen_remainder_factor_theorem,
        "factor_high_degree":         gen_factor_high_degree,
        "polynomial_inequality":      gen_polynomial_inequality,
        "partial_fractions":          gen_partial_fractions,

        # Extended generators (parametric, word, scholar)
        "find_k_for_factor":          gen_find_k_for_factor,
        "common_factor_param":        gen_common_factor_param,
        "polynomial_word_context":    gen_polynomial_word_context,
        "double_root_factor":         gen_double_root_factor,
        "radical_root_polynomial":    gen_radical_root_polynomial,
        "multi_divisibility_params":  gen_multi_divisibility_params,
        "vieta_symmetric_functions":  gen_vieta_symmetric_functions,
        "nature_of_roots_param":      gen_nature_of_roots_param,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    if isinstance(res, dict):
        return res
    q_text, q_latex, ans_latex, ans_plain = res
    return {"q_text": q_text, "q_latex": q_latex, "ans_latex": ans_latex, "ans_plain": ans_plain}


def generate_polynomial_questions(n_target):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = n_target * 60
    while len(questions) < n_target and attempts < max_attempts:
        attempts += 1
        rv = random.random()
        if rv < 0.25:
            diff = "basic"
        elif rv < 0.55:
            diff = "medium"
        elif rv < 0.85:
            diff = "hard"
        else:
            diff = "scholar"
        q_type = rc(DIFFICULTY_TYPES[diff])
        data = call_generator(q_type)
        if data is None:
            continue
        dup_key = data["q_latex"]
        if dup_key in seen:
            continue
        seen.add(dup_key)
        questions.append({
            "id": len(questions) + 1,
            "type": q_type,
            "difficulty": diff,
            "expression_latex": data["q_latex"],
            "question_text": data["q_text"],
            "answer_latex": data["ans_latex"],
            "answer_plain": data["ans_plain"],
        })
    return questions


# ============================================================================
# Main
# ============================================================================

if __name__ == "__main__":
    qs = generate_polynomial_questions(1500)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra"
    )
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "polynomials.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Polynomial Operations",
            "description": (
                "Practice problems for the polynomial calculator: arithmetic, expansion, "
                "factoring, division, root finding, and inequalities. SymPy-verified."
            ),
            "questions": qs,
        }, f, separators=(',', ':'))

    print(f"Generated {len(qs)} polynomial questions → {out_path}")
    diffs = Counter(q["difficulty"] for q in qs)
    types = Counter(q["type"] for q in qs)
    print("\nBy difficulty:")
    for d, c in diffs.most_common():
        print(f"  {d}: {c}")
    print(f"\nBy type ({len(types)} types):")
    for t, c in types.most_common():
        print(f"  {t}: {c}")
