#!/usr/bin/env python3
"""
generate_quadratic.py — SymPy-verified quadratic worksheet generator.

Aligned with NCERT Class 10 Ch 4 (Quadratic Equations), Class 11 Ch 5
(Complex Numbers / quadratic with complex roots), and JEE Mains-Advanced
for higher tiers.  Replaces the prior inline 50-problem JS bank with a
proper SymPy-verified bank of ~1500 problems.

Output: src/main/webapp/worksheet/math/algebra/quadratic.json

Run:
    python3 generate_quadratic.py [N]      # default 1500
    python3 generate_worksheet_metadata.py # refresh global index

Question types (24 total):

  basic (NCERT Class 9-10):
    factor_simple             x² + 5x + 6 = 0  (lead = 1, integer roots)
    factor_with_lead          2x² + 7x + 3 = 0
    formula_real_roots        apply quadratic formula
    complete_square_simple    x² + 6x + 5 = 0  → (x+3)² = 4
    discriminant_compute      compute D for given coefs
    nature_of_roots           D > 0 / = 0 / < 0
    sum_product_roots         Vieta — find α+β, αβ without solving

  medium (NCERT Class 10-11):
    vertex_form_convert       y = x² − 4x + 1  →  (x−2)² − 3
    min_max_value             min/max of y at vertex
    write_from_roots          α, β given → quadratic
    write_from_vertex         vertex (h, k) + point given → quadratic
    word_age                  NCERT Ch 4 — age problems
    word_speed                speed/distance/time
    word_geometry             rectangle dimensions, Pythagorean
    word_consecutive_int      n(n+1) = 132 → find n
    complex_roots_explicit    D < 0 → x = (-b ± √|D|·i) / 2a

  hard (JEE Mains):
    parameter_real_roots      for what k does kx² + bx + c = 0 have real roots?
    parameter_equal_roots     find k for equal roots (D = 0)
    parameter_one_pos_one_neg sign of roots / coefficient
    common_root_two           two quadratics share a common root
    transform_roots           if α, β roots of P, find Q with α+1, β+1
    relation_alpha_beta       compute α² + β², α³ + β³, 1/α + 1/β

  scholar (JEE Advanced):
    biquadratic               ax^4 + bx^2 + c = 0 (substitution)
    quadratic_in_disguise     hidden via substitution
    high_power_roots          α^7 + β^7 from quadratic recursion
    putnam_classics           hand-curated theorems / olympiad
"""

from __future__ import annotations

import sympy as sp
import random
import json
import os
import sys
from collections import Counter

x   = sp.Symbol("x", real=True)
y   = sp.Symbol("y", real=True)
SMALL_INT     = list(range(-9, 10))
NONZERO_SMALL = [k for k in SMALL_INT if k != 0]


def rc(pool):
    return random.choice(pool)


def fmt_quadratic_lhs(A, B, C, var="x"):
    """Pretty-print Ax² + Bx + C = 0 (or with omitted/negative terms)."""
    parts = []
    # x² term
    if A == 1:
        parts.append(f"{var}^2")
    elif A == -1:
        parts.append(f"-{var}^2")
    else:
        parts.append(f"{A}{var}^2")
    # x term
    if B != 0:
        if B > 0:
            parts.append(f"+ {B}{var}" if B != 1 else f"+ {var}")
        else:
            parts.append(f"- {abs(B)}{var}" if B != -1 else f"- {var}")
    # constant
    if C != 0:
        parts.append(f"+ {C}" if C > 0 else f"- {abs(C)}")
    return " ".join(parts)


# ╔═════════════════════════════════════════════════════════════════════
# ║  BASIC — NCERT Class 9-10 introductory
# ╚═════════════════════════════════════════════════════════════════════

def gen_factor_simple():
    """x² + bx + c = 0 with distinct integer roots, lead = 1."""
    r1, r2 = sorted(random.sample([-7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7], 2))
    B = -(r1 + r2)
    C = r1 * r2
    expr = sp.expand((x - r1) * (x - r2))
    if expr.coeff(x ** 2) != 1:
        return None

    q_latex = fmt_quadratic_lhs(1, B, C) + " = 0"
    q_text  = ("Solve the quadratic equation by factoring (NCERT Class 10 "
               "Ch 4 method).  Express each step clearly.")
    a_latex = f"x = {r1} \\quad \\text{{or}} \\quad x = {r2}"
    a_plain = f"x = {r1} or x = {r2}"
    return q_text, q_latex, a_latex, a_plain


def gen_factor_with_lead():
    """ax² + bx + c = 0 with rational roots and a ∈ {2, 3, 4}."""
    A = rc([2, 3, 4])
    # Pick two distinct rational roots of the form p/A and q/A with p, q integer
    p = rc([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
    q = rc([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
    if p == q:
        return None

    # Quadratic with roots p/A and q (mixed: one rational, one integer)
    # Build: A*(x - p/A)(x - q) = (Ax - p)(x - q)
    expr = sp.expand((A * x - p) * (x - q))
    A_check = expr.coeff(x ** 2)
    B = int(expr.coeff(x, 1))
    C = int(expr.coeff(x, 0))
    if A_check != A:
        return None

    q_latex = fmt_quadratic_lhs(A, B, C) + " = 0"
    q_text  = ("Solve by factoring with leading coefficient.  Use the "
               "splitting-the-middle-term method (NCERT Ch 4).")
    sols = [sp.Rational(p, A), sp.Integer(q)]
    a_latex = " \\quad \\text{or} \\quad ".join([f"x = {sp.latex(s)}" for s in sols])
    a_plain = "  or  ".join([f"x = {s}" for s in sols])
    return q_text, q_latex, a_latex, a_plain


def gen_formula_real_roots():
    """Apply the quadratic formula.  Plant integer/rational roots so the
    answer is clean."""
    A = rc([1, 1, 2, 3])
    r1, r2 = random.sample([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5], 2)
    expr = sp.expand(A * (x - r1) * (x - r2))
    B = int(expr.coeff(x, 1))
    C = int(expr.coeff(x, 0))

    D = B ** 2 - 4 * A * C
    if D < 0:
        return None

    q_latex = fmt_quadratic_lhs(A, B, C) + " = 0"
    q_text  = ("Solve using the quadratic formula  x = (−b ± √(b² − 4ac)) / (2a). "
               "Show the substitution and the value of the discriminant.")
    sols = sorted([sp.Rational(r1), sp.Rational(r2)])
    a_latex = " \\quad \\text{or} \\quad ".join([f"x = {sp.latex(s)}" for s in sols])
    a_plain = "  or  ".join([f"x = {s}" for s in sols])
    return q_text, q_latex, a_latex, a_plain


def gen_complete_square_simple():
    """x² + bx + c = 0 with even b for clean (x + b/2)² form."""
    h = rc([-4, -3, -2, -1, 1, 2, 3, 4])  # vertex x-coord
    k = rc([-9, -4, -1, 1, 4, 9])         # discriminant-style number under root
    if k == 0:
        return None

    # Want: (x − h)² = k, expand: x² − 2hx + h² − k = 0
    B = -2 * h
    C = h ** 2 - k
    if k > 0:
        sols = [h + sp.sqrt(k), h - sp.sqrt(k)]
    else:  # k < 0 → no real roots; skip for "complete square SIMPLE"
        return None

    q_latex = fmt_quadratic_lhs(1, B, C) + " = 0"
    q_text  = ("Solve by completing the square.  Rewrite the equation in "
               "the form (x − h)² = k, then take square roots.")
    a_latex = " \\quad \\text{or} \\quad ".join([f"x = {sp.latex(s)}" for s in sols])
    a_plain = "  or  ".join([f"x = {s}" for s in sols])
    return q_text, q_latex, a_latex, a_plain


def gen_discriminant_compute():
    """Compute the discriminant D = b² − 4ac for given coefficients."""
    A = rc([1, 2, 3, 4, 5])
    B = rc(SMALL_INT)
    C = rc(SMALL_INT)
    D = B ** 2 - 4 * A * C

    q_latex = (f"\\text{{For }} {fmt_quadratic_lhs(A, B, C)} = 0, "
               f"\\text{{ compute the discriminant.}}")
    q_text  = ("Find the discriminant D = b² − 4ac of the quadratic equation, "
               "and state the nature of the roots.")
    nature = ("two distinct real roots" if D > 0 else
              "one repeated real root"   if D == 0 else
              "two complex conjugate roots (no real solutions)")
    a_latex = f"D = {D};\\; \\text{{{nature}}}"
    a_plain = f"D = {D}; {nature}"
    return q_text, q_latex, a_latex, a_plain


def gen_nature_of_roots():
    """Just classify nature without computing D."""
    case = rc(["distinct", "repeated", "complex"])
    A = rc([1, 2, 3])
    if case == "distinct":
        # D > 0 — pick rational roots
        r1, r2 = random.sample([-4, -3, -2, -1, 1, 2, 3, 4], 2)
        expr = sp.expand(A * (x - r1) * (x - r2))
    elif case == "repeated":
        r = rc([-3, -2, -1, 1, 2, 3])
        expr = sp.expand(A * (x - r) ** 2)
    else:  # complex
        # x² + bx + c with D < 0: pick c large
        B = rc([1, 2, 3, 4, 5])
        C = rc([5, 6, 7, 8, 9, 10, 12])
        expr = A * x ** 2 + B * x + C

    A_co = int(expr.coeff(x ** 2))
    B_co = int(expr.coeff(x, 1))
    C_co = int(expr.coeff(x, 0))
    D = B_co ** 2 - 4 * A_co * C_co
    nature = ("two distinct real roots (D > 0)"        if D > 0 else
              "one repeated real root (D = 0)"         if D == 0 else
              "two complex conjugate roots (D < 0)")

    q_latex = fmt_quadratic_lhs(A_co, B_co, C_co) + " = 0"
    q_text  = ("Without solving, state the nature of the roots using the "
               "discriminant D = b² − 4ac.")
    a_latex = f"D = {D};\\; \\text{{{nature}}}"
    a_plain = f"D = {D}; {nature}"
    return q_text, q_latex, a_latex, a_plain


def gen_sum_product_roots():
    """Vieta's: find α+β and αβ without solving."""
    A = rc([1, 2, 3])
    B = rc(NONZERO_SMALL)
    C = rc(NONZERO_SMALL)

    sum_roots  = sp.Rational(-B, A)
    prod_roots = sp.Rational(C, A)

    q_latex = (f"\\text{{For }} {fmt_quadratic_lhs(A, B, C)} = 0 "
               f"\\text{{ with roots }} \\alpha, \\beta:")
    q_text  = ("Apply Vieta's formulas to find α + β and αβ WITHOUT "
               "solving the quadratic.")
    a_latex = (f"\\alpha + \\beta = {sp.latex(sum_roots)}, \\quad "
               f"\\alpha \\beta = {sp.latex(prod_roots)}")
    a_plain = f"alpha + beta = {sum_roots}, alpha*beta = {prod_roots}"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  MEDIUM — NCERT Class 10-11 + JEE Mains
# ╚═════════════════════════════════════════════════════════════════════

def gen_vertex_form_convert():
    """y = ax² + bx + c  →  y = a(x − h)² + k"""
    A = rc([1, 1, 2, -1, -2])
    h = rc([-3, -2, -1, 1, 2, 3])
    k = rc([-5, -3, -1, 1, 3, 5])
    # standard form: A(x − h)² + k = Ax² − 2Ahx + (Ah² + k)
    B = -2 * A * h
    C = A * h ** 2 + k

    q_latex = f"y = {fmt_quadratic_lhs(A, B, C)}"
    q_text  = ("Rewrite the quadratic in vertex form  y = a(x − h)² + k  "
               "by completing the square.  State the vertex (h, k) and "
               "the axis of symmetry.")
    a_latex = (f"y = {A}(x - {h})^2 + {k}; \\quad "
               f"\\text{{vertex }} ({h}, {k}); \\quad "
               f"\\text{{axis }} x = {h}")
    a_plain = f"y = {A}(x - {h})^2 + {k}; vertex ({h}, {k}); axis x = {h}"
    return q_text, q_latex, a_latex, a_plain


def gen_min_max_value():
    """Find min/max value of a quadratic and the x at which it occurs."""
    A = rc([1, 2, -1, -2, 3])
    h = rc([-4, -3, -2, -1, 1, 2, 3, 4])
    k = rc([-7, -5, -3, -1, 1, 3, 5, 7])

    B = -2 * A * h
    C = A * h ** 2 + k
    is_min = A > 0

    q_latex = f"f(x) = {fmt_quadratic_lhs(A, B, C)}"
    q_text  = ("Find the " + ("minimum" if is_min else "maximum") +
               " value of f(x) and the value of x at which it occurs.")
    a_latex = (f"f({h}) = {k} \\quad ({'minimum' if is_min else 'maximum'})")
    a_plain = f"f({h}) = {k} ({'min' if is_min else 'max'})"
    return q_text, q_latex, a_latex, a_plain


def gen_write_from_roots():
    """Given α and β, write the quadratic with leading coefficient 1."""
    r1, r2 = random.sample([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5], 2)
    sum_r  = r1 + r2
    prod_r = r1 * r2

    q_latex = (f"\\alpha = {r1}, \\quad \\beta = {r2}")
    q_text  = ("Find the quadratic equation (with leading coefficient 1) "
               "whose roots are α and β.  Use Vieta:  "
               "x² − (α + β)x + αβ = 0.")
    a_latex = fmt_quadratic_lhs(1, -sum_r, prod_r) + " = 0"
    a_plain = f"x² − {sum_r}x + {prod_r} = 0"
    return q_text, q_latex, a_latex, a_plain


def gen_write_from_vertex():
    """Given vertex (h, k) and a point (x0, y0), write the quadratic."""
    h = rc([-3, -2, -1, 1, 2, 3])
    k = rc([-4, -3, -2, -1, 1, 2, 3, 4])
    x0 = h + rc([-3, -2, -1, 1, 2, 3])
    # Pick A so y0 is integer
    A = rc([1, 2, -1, -2])
    y0 = A * (x0 - h) ** 2 + k

    q_latex = (f"\\text{{vertex }} ({h}, {k}), \\quad "
               f"\\text{{point on parabola }} ({x0}, {y0})")
    q_text  = ("Find the equation of the parabola with the given vertex "
               "and passing through the given point.  Use the form "
               "y = a(x − h)² + k and solve for a.")
    a_latex = f"y = {A}(x - {h})^2 + {k}"
    a_plain = f"y = {A}(x - {h})^2 + {k}"
    return q_text, q_latex, a_latex, a_plain


def gen_word_age():
    """NCERT Class 10 Ch 4 — age word problems."""
    case = rc(["sum_squares", "product_after_years", "father_son"])
    if case == "sum_squares":
        # Two siblings, ages a and b, a > b, a − b = d, a² + b² = S
        b_age = rc([3, 4, 5, 6, 7, 8])
        d = rc([3, 4, 5, 6, 7])
        a_age = b_age + d
        S = a_age ** 2 + b_age ** 2

        q_latex = (f"a = b + {d}, \\quad a^2 + b^2 = {S}")
        q_text  = (f"The difference between two children's ages is {d} years. "
                   f"The sum of the squares of their ages is {S}. "
                   "Find their ages (NCERT Class 10 style).")
        a_latex = f"\\text{{ages: }} {a_age} \\text{{ and }} {b_age}"
        a_plain = f"ages: {a_age} and {b_age}"
        return q_text, q_latex, a_latex, a_plain

    elif case == "product_after_years":
        present = rc([10, 12, 14, 15, 16, 18, 20, 22, 25])
        years   = rc([3, 4, 5, 6, 7])
        # Product of (present) and (present + years)
        prod = present * (present + years)
        q_latex = f"x(x + {years}) = {prod}"
        q_text  = (f"A girl's present age multiplied by her age {years} years "
                   f"hence equals {prod}.  Find her present age.")
        a_latex = f"x = {present}"
        a_plain = f"x = {present}"
        return q_text, q_latex, a_latex, a_plain

    else:  # father_son
        son_age = rc([5, 6, 7, 8, 10, 12])
        father_age = son_age * rc([4, 5, 6])
        years_later = rc([2, 3, 4, 5])
        # son+years, father+years; father+years = K * (son+years) for clean K
        # build product equation: (father + years) * (son + years) = product
        product = (father_age + years_later) * (son_age + years_later)

        q_latex = (f"\\text{{son age}} = s, \\quad \\text{{father age}} = {father_age}, "
                   f"\\quad (s + {years_later})(\\text{{father}} + {years_later}) = {product}")
        q_text  = (f"A father is currently {father_age} years old.  In {years_later} "
                   "years, the product of his age and his son's age (also in "
                   f"{years_later} years) will be {product}.  Find the son's "
                   "current age.")
        a_latex = f"\\text{{son}} = {son_age} \\text{{ years}}"
        a_plain = f"son = {son_age} years"
        return q_text, q_latex, a_latex, a_plain


def gen_word_speed():
    """NCERT speed/distance/time word problem."""
    distance = rc([60, 90, 120, 150, 180, 200, 240, 300, 360])
    speed_diff = rc([5, 10, 15, 20])
    # Time at speed v: distance/v.  Time at speed (v+diff): distance/(v+diff).
    # Difference in times = some clean value → one equation in v.
    # Plant clean answer: v ∈ {30, 40, 45, 50, 60, 80}
    v = rc([30, 40, 45, 50, 60, 80])
    if distance % v != 0 or distance % (v + speed_diff) != 0:
        return None
    time_diff = sp.Rational(distance, v) - sp.Rational(distance, v + speed_diff)
    if time_diff <= 0:
        return None

    q_latex = (f"\\frac{{{distance}}}{{v}} - \\frac{{{distance}}}{{v + {speed_diff}}} "
               f"= {sp.latex(time_diff)}")
    q_text  = (f"A train travels {distance} km. If its speed had been "
               f"{speed_diff} km/h faster, the journey would have taken "
               f"{sp.latex(time_diff)} hour(s) less.  Find the original speed.")
    a_latex = f"v = {v} \\text{{ km/h}}"
    a_plain = f"v = {v} km/h"
    return q_text, q_latex, a_latex, a_plain


def gen_word_geometry():
    """Rectangle with area + perimeter constraint, or Pythagorean triple."""
    case = rc(["rect_area", "pythag", "diagonal"])

    if case == "rect_area":
        # length = width + offset, area = product
        width = rc([4, 5, 6, 7, 8, 9, 10, 12])
        offset = rc([2, 3, 4, 5, 6])
        length = width + offset
        area = width * length

        q_latex = f"L = W + {offset}, \\quad L \\cdot W = {area}"
        q_text  = (f"The length of a rectangle exceeds its width by {offset} m. "
                   f"If the area is {area} m², find the dimensions.")
        a_latex = f"W = {width}, \\quad L = {length} \\text{{ (m)}}"
        a_plain = f"W = {width}, L = {length} (m)"
        return q_text, q_latex, a_latex, a_plain

    elif case == "pythag":
        # a, b, c forming Pythagorean triple, a^2 + b^2 = c^2
        # Standard primitives: (3,4,5), (5,12,13), (8,15,17), (7,24,25), (20,21,29)
        triple = rc([(3, 4, 5), (5, 12, 13), (8, 15, 17), (7, 24, 25)])
        scale  = rc([1, 2, 3])
        a, b, c = (scale * triple[0], scale * triple[1], scale * triple[2])
        # Frame as: hypotenuse = c, one leg − other leg = (a − b) (assume a < b)
        diff = b - a

        q_latex = (f"\\text{{hypotenuse}} = {c}, \\quad "
                   f"\\text{{difference of legs}} = {diff}")
        q_text  = (f"A right triangle has hypotenuse of length {c} units, and "
                   f"the difference of its two legs is {diff} units.  Find "
                   f"the lengths of the legs.")
        a_latex = f"\\text{{legs: }} {a} \\text{{ and }} {b}"
        a_plain = f"legs: {a} and {b}"
        return q_text, q_latex, a_latex, a_plain

    else:  # diagonal of square = side + 2 etc.  (less common)
        return None


def gen_word_consecutive_int():
    """Two consecutive (positive) integers whose product is given."""
    n_val = rc([10, 11, 12, 13, 14, 15, 16, 18, 20, 22, 25])
    prod  = n_val * (n_val + 1)

    q_latex = f"n(n + 1) = {prod}"
    q_text  = (f"The product of two consecutive positive integers is {prod}. "
               "Find the integers.")
    a_latex = f"n = {n_val}, \\; n + 1 = {n_val + 1}"
    a_plain = f"n = {n_val}, n+1 = {n_val + 1}"
    return q_text, q_latex, a_latex, a_plain


def gen_complex_roots_explicit():
    """ax² + bx + c = 0 with D < 0 — express roots using i."""
    A = rc([1, 1, 2])
    B = rc([1, 2, 3, 4, 5, -1, -2, -3, -4, -5])
    C = rc([3, 4, 5, 6, 7, 8, 9, 10])

    D = B ** 2 - 4 * A * C
    if D >= 0:
        return None

    q_latex = fmt_quadratic_lhs(A, B, C) + " = 0"
    q_text  = ("Solve over the complex numbers using the quadratic formula. "
               "Express the roots in the form  α ± βi.  (NCERT Class 11 Ch 5)")
    real_part = sp.Rational(-B, 2 * A)
    imag_mag  = sp.sqrt(-D) / (2 * A)
    imag_mag  = sp.nsimplify(imag_mag)
    a_latex = (f"x = {sp.latex(real_part)} \\pm {sp.latex(imag_mag)}\\,i")
    a_plain = f"x = {real_part} ± {imag_mag}*i"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  HARD — JEE Mains
# ╚═════════════════════════════════════════════════════════════════════

def gen_parameter_real_roots():
    """For what k does kx² + bx + c = 0 have real roots?"""
    B = rc([3, 4, 5, 6, 7, 8])
    C = rc([1, 2, 3, 4])
    # D = B² - 4kC ≥ 0  ⇔  k ≤ B²/(4C)
    threshold = sp.Rational(B ** 2, 4 * C)

    q_latex = f"k x^2 + {B} x + {C} = 0"
    q_text  = ("For what values of the parameter k does the equation have "
               "real roots?  Use D ≥ 0.  Note: k ≠ 0 for it to be a quadratic.")
    a_latex = (f"k \\leq {sp.latex(threshold)}, \\quad k \\neq 0")
    a_plain = f"k <= {threshold}, k != 0"
    return q_text, q_latex, a_latex, a_plain


def gen_parameter_equal_roots():
    """Find k for equal roots (D = 0)."""
    B = rc([4, 6, 8, 10, 12])
    C = rc([1, 2, 3, 4, 5])
    # x² + Bx + Ck = 0; for equal roots: B² = 4Ck → k = B²/(4C)
    k_val = sp.Rational(B ** 2, 4 * C)

    c_str = "k" if C == 1 else f"{C} k"
    q_latex = f"x^2 + {B} x + {c_str} = 0"
    q_text  = ("Find the value of the parameter k for which the equation "
               "has equal (repeated) roots.  Use D = 0.")
    a_latex = f"k = {sp.latex(k_val)}"
    a_plain = f"k = {k_val}"
    return q_text, q_latex, a_latex, a_plain


def gen_parameter_one_pos_one_neg():
    """For what k does the quadratic have roots of opposite signs?"""
    B = rc([1, 2, 3, 4, 5])
    # x² + Bx + (k - 1) = 0; roots opposite signs ⇔ product < 0 ⇔ (k - 1)/1 < 0 ⇔ k < 1
    threshold = 1
    shift = rc([1, 2, 3, 4])

    # Build: x² + Bx + (k - shift) = 0; roots opposite signs ⇔ k - shift < 0 ⇔ k < shift
    q_latex = f"x^2 + {B} x + (k - {shift}) = 0"
    q_text  = ("For what values of the parameter k does the equation have "
               "two roots of opposite signs?  Use Vieta's: αβ < 0.")
    a_latex = f"k < {shift}"
    a_plain = f"k < {shift}"
    return q_text, q_latex, a_latex, a_plain


def gen_common_root_two():
    """Two quadratics share a common root α; find α and an unknown."""
    # P1: x² + bx + c with roots p, q
    # P2: x² + B*x + C with one root = q (common)
    p, q = random.sample([-4, -3, -2, -1, 1, 2, 3, 4], 2)
    r = rc([-3, -2, -1, 1, 2, 3])  # second root of P2
    if r == q or r == p:
        return None

    b1 = -(p + q); c1 = p * q
    b2 = -(q + r); c2 = q * r

    q_latex = (f"P_1: x^2 + {b1} x + {c1} = 0, \\quad "
               f"P_2: x^2 + {b2} x + {c2} = 0")
    q_text  = ("Two quadratic equations are given.  Find the common root α, "
               "and the other root of each equation.")
    a_latex = (f"\\alpha = {q}; \\; "
               f"\\text{{other root of }} P_1 = {p}, \\; "
               f"\\text{{other root of }} P_2 = {r}")
    a_plain = f"α = {q}; P1 other root = {p}, P2 other root = {r}"
    return q_text, q_latex, a_latex, a_plain


def gen_transform_roots():
    """If α, β are roots of P, find quadratic with α + s, β + s as roots."""
    r1, r2 = sorted(random.sample([-4, -3, -2, -1, 1, 2, 3, 4], 2))
    s = rc([1, 2, 3, -1, -2, -3])

    B = -(r1 + r2)
    C = r1 * r2
    # New roots: r1 + s, r2 + s
    new_sum = (r1 + s) + (r2 + s)
    new_prod = (r1 + s) * (r2 + s)

    q_latex = (f"\\alpha, \\beta \\text{{ are roots of }} "
               f"x^2 + {B} x + {C} = 0; \\; "
               f"\\text{{find quadratic whose roots are }} \\alpha + {s}, \\beta + {s}")
    q_text  = ("If α and β are the roots of the given quadratic, find the "
               "new quadratic equation whose roots are α + s and β + s.  "
               "Use Vieta on the new sum and product.")
    a_latex = fmt_quadratic_lhs(1, -new_sum, new_prod) + " = 0"
    a_plain = f"x² − ({new_sum})x + {new_prod} = 0"
    return q_text, q_latex, a_latex, a_plain


def gen_relation_alpha_beta():
    """Compute α² + β², α³ + β³, 1/α + 1/β etc. without solving."""
    r1, r2 = sorted(random.sample([-4, -3, -2, -1, 1, 2, 3, 4], 2))
    B = -(r1 + r2)
    C = r1 * r2
    if C == 0:
        return None

    target = rc(["sum_squares", "sum_cubes", "reciprocal_sum"])
    s = -B  # α + β
    p = C   # αβ

    if target == "sum_squares":
        ans = s ** 2 - 2 * p
        q_latex = (f"\\alpha, \\beta \\text{{ are roots of }} "
                   f"{fmt_quadratic_lhs(1, B, C)} = 0; \\; "
                   "\\text{find } \\alpha^2 + \\beta^2.")
        q_text  = ("Use Vieta + identity α² + β² = (α + β)² − 2αβ.")
        a_latex = f"\\alpha^2 + \\beta^2 = {ans}"
        a_plain = f"α² + β² = {ans}"
    elif target == "sum_cubes":
        ans = s ** 3 - 3 * p * s
        q_latex = (f"\\alpha, \\beta \\text{{ are roots of }} "
                   f"{fmt_quadratic_lhs(1, B, C)} = 0; \\; "
                   "\\text{find } \\alpha^3 + \\beta^3.")
        q_text  = ("Use the identity α³ + β³ = (α + β)³ − 3αβ(α + β).")
        a_latex = f"\\alpha^3 + \\beta^3 = {ans}"
        a_plain = f"α³ + β³ = {ans}"
    else:  # reciprocal sum
        ans = sp.Rational(s, p)
        q_latex = (f"\\alpha, \\beta \\text{{ are roots of }} "
                   f"{fmt_quadratic_lhs(1, B, C)} = 0; \\; "
                   "\\text{find } \\frac{1}{\\alpha} + \\frac{1}{\\beta}.")
        q_text  = ("Use 1/α + 1/β = (α + β) / (αβ).")
        a_latex = (f"\\dfrac{{1}}{{\\alpha}} + \\dfrac{{1}}{{\\beta}} = "
                   f"{sp.latex(ans)}")
        a_plain = f"1/α + 1/β = {ans}"

    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — JEE Advanced
# ╚═════════════════════════════════════════════════════════════════════

def gen_biquadratic():
    """ax^4 + bx^2 + c = 0 — substitution u = x²"""
    # Plant clean roots in u: r1, r2 ≥ 0 so x is real
    candidates = sorted(random.sample([1, 4, 9, 16, 25], 2))
    r1, r2 = candidates
    B = -(r1 + r2)
    C = r1 * r2

    q_latex = f"x^4 {('+ ' + str(B)) if B >= 0 else ('- ' + str(abs(B)))} x^2 {('+ ' + str(C)) if C >= 0 else ('- ' + str(abs(C)))} = 0"
    q_text  = ("Solve the biquadratic equation by substituting u = x².  "
               "List all real roots.")
    sols = sorted([-sp.sqrt(r1), sp.sqrt(r1), -sp.sqrt(r2), sp.sqrt(r2)],
                  key=lambda s: float(s.evalf()))
    a_latex = ", ".join([f"x = {sp.latex(s)}" for s in sols])
    a_plain = ", ".join([f"x = {s}" for s in sols])
    return q_text, q_latex, a_latex, a_plain


def gen_quadratic_in_disguise():
    """JEE: equation that becomes quadratic after substitution.
       Example: 4^x − 5·2^x + 4 = 0   →   u² − 5u + 4 = 0  with u = 2^x."""
    base = rc([2, 3])
    # u² − Bu + C = 0 with positive integer roots u1, u2 (so x is defined)
    u1, u2 = sorted(random.sample([1, 2, 4, 8, 9, 16, 27], 2))
    B = u1 + u2
    C = u1 * u2

    q_latex = f"{base}^{{2x}} - {B} \\cdot {base}^x + {C} = 0"
    q_text  = ("(JEE-style) Solve the equation by substituting u = "
               f"{base}^x.  Both u-roots must be positive (since {base}^x > 0).")
    sols = []
    for u in [u1, u2]:
        sols.append(sp.log(u, base))
    sols_simplified = [sp.nsimplify(s) for s in sols]
    a_latex = ", ".join([f"x = {sp.latex(s)}" for s in sols_simplified])
    a_plain = ", ".join([f"x = {s}" for s in sols_simplified])
    return q_text, q_latex, a_latex, a_plain


def gen_high_power_roots():
    """Compute α^n + β^n using recursion S_n = (α+β)·S_(n-1) − αβ·S_(n-2)."""
    # Pick simple integer-root quadratic so α, β small
    r1, r2 = random.sample([-3, -2, -1, 1, 2, 3], 2)
    B = -(r1 + r2)
    C = r1 * r2

    # Compute α^n + β^n for small n (4, 5, or 6)
    n_val = rc([4, 5, 6])
    s_arr = [2, -B]  # S_0 = 2, S_1 = α + β = -B
    for k in range(2, n_val + 1):
        s_arr.append((-B) * s_arr[k - 1] - C * s_arr[k - 2])
    target = s_arr[n_val]

    q_latex = (f"\\alpha, \\beta \\text{{ are roots of }} "
               f"{fmt_quadratic_lhs(1, B, C)} = 0; \\quad "
               f"\\text{{find }} \\alpha^{n_val} + \\beta^{n_val}.")
    q_text  = ("(JEE Advanced) Use Newton's identity / recursion: "
               "S_k = (α+β)·S_(k−1) − αβ·S_(k−2)  with  S_0 = 2, "
               "S_1 = α + β.")
    a_latex = f"\\alpha^{n_val} + \\beta^{n_val} = {target}"
    a_plain = f"α^{n_val} + β^{n_val} = {target}"
    return q_text, q_latex, a_latex, a_plain


def gen_putnam_classics():
    """Hand-curated olympiad-level theorems involving quadratics."""
    pool = [
        {
            "q_latex": (r"\alpha, \beta \text{ are roots of } "
                        r"x^2 - (a-2) x - a - 1 = 0. \quad "
                        r"\text{Find the minimum value of } \alpha^2 + \beta^2 "
                        r"\text{ over all real } a."),
            "q_text":  ("(JEE Advanced) Using Vieta and (α+β)² − 2αβ, find "
                        "the minimum value of α² + β² where α and β are roots "
                        "of the given parametrised quadratic."),
            "a_latex": (r"\alpha^2 + \beta^2 = (a-2)^2 + 2(a+1) "
                        r"= a^2 - 2a + 6 = (a-1)^2 + 5; "
                        r"\quad \min = 5 \text{ at } a = 1."),
            "a_plain": "min = 5 at a = 1.",
        },
        {
            "q_latex": (r"\text{If both roots of } "
                        r"x^2 - 2 a x + a^2 - 1 = 0 \text{ lie in } "
                        r"(-2, 4), \text{ find the range of } a."),
            "q_text":  ("(JEE Mains) Find the range of parameter a such that "
                        "both roots of the quadratic lie in the open interval "
                        "(−2, 4).  Use the conditions: f(−2) > 0, f(4) > 0, "
                        "discriminant > 0, vertex x-coord in (−2, 4)."),
            "a_latex": (r"\text{Roots are } a-1 \text{ and } a+1; \; "
                        r"\text{both in } (-2, 4) \Rightarrow -1 < a < 3."),
            "a_plain": "Roots: a-1, a+1; both in (-2,4) ⇒ -1 < a < 3.",
        },
        {
            "q_latex": (r"\text{If } x^2 + p x + q = 0 \text{ has roots } "
                        r"\alpha, \beta \text{ and } \alpha^4 + \beta^4 = 18, "
                        r"\alpha + \beta = 2, \text{ find } p \text{ and } q."),
            "q_text":  ("Use Vieta + Newton's identities to find p and q "
                        "given α + β = 2 and α⁴ + β⁴ = 18."),
            "a_latex": (r"S_2 = 4 - 2q; \; S_4 = S_2^2 - 2q^2 "
                        r"= (4-2q)^2 - 2q^2 = 18 "
                        r"\Rightarrow 2q^2 - 16q - 2 = 0 "
                        r"\Rightarrow q = 4 \pm 3\sqrt{2}; \; p = -2."),
            "a_plain": "p = -2; q = 4 ± 3√2.",
        },
        {
            "q_latex": (r"\text{Show that the equation } "
                        r"x^2 + (k - 3) x + k = 0 \text{ has no real roots "
                        r"if } 1 < k < 9."),
            "q_text":  ("Prove that for 1 < k < 9, the discriminant is "
                        "negative, so the equation has no real roots."),
            "a_latex": (r"D = (k-3)^2 - 4k = k^2 - 10k + 9 = (k-1)(k-9); "
                        r"\; D < 0 \iff 1 < k < 9. \; \blacksquare"),
            "a_plain": "D = (k-1)(k-9) < 0 for k in (1, 9).",
        },
        {
            "q_latex": (r"\text{Let } \alpha, \beta \text{ be roots of } "
                        r"x^2 - 6 x + 1 = 0. \text{ Find } "
                        r"\frac{1}{\alpha^3} + \frac{1}{\beta^3}."),
            "q_text":  ("Use 1/α + 1/β = (α + β)/(αβ) and the identity "
                        "for cubes."),
            "a_latex": (r"\alpha + \beta = 6, \; \alpha\beta = 1; \; "
                        r"\frac{1}{\alpha} + \frac{1}{\beta} = 6; \; "
                        r"\frac{1}{\alpha^3} + \frac{1}{\beta^3} "
                        r"= 6^3 - 3 \cdot 1 \cdot 6 = 216 - 18 = 198."),
            "a_plain": "1/α³ + 1/β³ = 198.",
        },
        {
            "q_latex": (r"\text{If } a, b, c \text{ are sides of a triangle, "
                        r"prove that the equation } "
                        r"a^2 x^2 + (b^2 + a^2 - c^2) x + b^2 = 0 "
                        r"\text{ has no real roots.}"),
            "q_text":  ("(IIT-JEE classic) Use the law of cosines: "
                        "b² + a² − c² = 2ab cos C.  Then show D < 0."),
            "a_latex": (r"D = (b^2 + a^2 - c^2)^2 - 4 a^2 b^2 "
                        r"= (2 a b \cos C)^2 - 4 a^2 b^2 "
                        r"= 4 a^2 b^2 (\cos^2 C - 1) "
                        r"= -4 a^2 b^2 \sin^2 C \leq 0 \text{ "
                        r"(strict < 0 for a non-degenerate triangle)}."),
            "a_plain": "D = -4a²b² sin²C ≤ 0; no real roots.",
        },
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


# ╔═════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "factor_simple",
        "factor_with_lead",
        "formula_real_roots",
        "complete_square_simple",
        "discriminant_compute",
        "nature_of_roots",
        "sum_product_roots",
    ],
    "medium": [
        "vertex_form_convert",
        "min_max_value",
        "write_from_roots",
        "write_from_vertex",
        "word_age",
        "word_speed",
        "word_geometry",
        "word_consecutive_int",
        "complex_roots_explicit",
    ],
    "hard": [
        "parameter_real_roots",
        "parameter_equal_roots",
        "parameter_one_pos_one_neg",
        "common_root_two",
        "transform_roots",
        "relation_alpha_beta",
    ],
    "scholar": [
        "biquadratic",
        "quadratic_in_disguise",
        "high_power_roots",
        "putnam_classics",
    ],
}


def call_generator(q_type):
    generators = {
        "factor_simple":             gen_factor_simple,
        "factor_with_lead":          gen_factor_with_lead,
        "formula_real_roots":        gen_formula_real_roots,
        "complete_square_simple":    gen_complete_square_simple,
        "discriminant_compute":      gen_discriminant_compute,
        "nature_of_roots":           gen_nature_of_roots,
        "sum_product_roots":         gen_sum_product_roots,
        "vertex_form_convert":       gen_vertex_form_convert,
        "min_max_value":             gen_min_max_value,
        "write_from_roots":          gen_write_from_roots,
        "write_from_vertex":         gen_write_from_vertex,
        "word_age":                  gen_word_age,
        "word_speed":                gen_word_speed,
        "word_geometry":             gen_word_geometry,
        "word_consecutive_int":      gen_word_consecutive_int,
        "complex_roots_explicit":    gen_complex_roots_explicit,
        "parameter_real_roots":      gen_parameter_real_roots,
        "parameter_equal_roots":     gen_parameter_equal_roots,
        "parameter_one_pos_one_neg": gen_parameter_one_pos_one_neg,
        "common_root_two":           gen_common_root_two,
        "transform_roots":           gen_transform_roots,
        "relation_alpha_beta":       gen_relation_alpha_beta,
        "biquadratic":               gen_biquadratic,
        "quadratic_in_disguise":     gen_quadratic_in_disguise,
        "high_power_roots":          gen_high_power_roots,
        "putnam_classics":           gen_putnam_classics,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain = res
    return {
        "q_text": q_text, "q_latex": q_latex,
        "ans_latex": ans_latex, "ans_plain": ans_plain,
    }


def generate_quadratic_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.30:
            diff = "basic"
        elif rv < 0.55:
            diff = "medium"
        elif rv < 0.82:
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

    qs = generate_quadratic_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "quadratic.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Quadratic Equations",
            "description": ("NCERT Class 10 Ch 4 + Class 11 + JEE Mains/Advanced "
                            "quadratic equations: factoring, formula, "
                            "completing the square, discriminant analysis, "
                            "Vieta's identities, parameter problems, "
                            "transformed roots, biquadratic, and JEE-style "
                            "olympiad classics."),
            "questions": qs,
        }, f, separators=(",", ":"))

    print(f"Generated {len(qs)} quadratic problems → {out_path}")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        print(f"  {t:30s}  {c:>4}")
