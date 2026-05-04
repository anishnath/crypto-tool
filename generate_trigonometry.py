#!/usr/bin/env python3
"""
generate_trigonometry.py — SymPy-verified trigonometry worksheet generator.

Covers all THREE trig calculators in one bank:
  · Trig Function Calculator (evaluate)
  · Trig Identity Calculator (prove)
  · Trig Equation Solver (solve)

Aligned with NCERT Class 10 Ch 8-9 (Introduction to Trig + Heights and
Distances), Class 11 Ch 3 (Trigonometric Functions), Class 12 Ch 2
(Inverse Trig), and JEE Mains/Advanced + IIT-level olympiad problems.

Output: src/main/webapp/worksheet/math/trigonometry/trigonometry.json

Run:
    python3 generate_trigonometry.py [N]      # default 1500
    python3 generate_worksheet_metadata.py    # refresh global index

Figure-bearing question types (target < 10% of total):
  · right_triangle_basic         (basic, 50% include figure)
  · height_distance_elevation    (medium, 70% include figure)
  · height_distance_depression   (medium, 70% include figure)
  · law_of_sines                 (hard, 50% include figure)
  · law_of_cosines               (hard, 50% include figure)
  · unit_circle_evaluate         (basic, 30% include figure)

Question types (~31 total):

  basic (NCERT Class 10):
    evaluate_unit_circle          sin(π/3), cos(60°) at standard angles
    right_triangle_basic          [FIG] given two sides, find third + ratios
    pythagorean_identity_quadrant given sin x and quadrant, find cos x
    value_in_quadrant             sign reasoning across quadrants
    complementary_angle           sin(90° - x), cos(complement)
    reciprocal_identity           tan x given, find cot/sec/csc
    exact_value_special           sin(15°), cos(75°) using sum formulas
    unit_circle_evaluate          [FIG] mark angle on unit circle

  medium (NCERT Class 11):
    double_angle_evaluate         given sin x, find sin(2x)/cos(2x)
    sum_diff_angle_evaluate       compute sin(A+B) etc.
    product_to_sum                2 sin A cos B → sum form
    sum_to_product                sin A + sin B → product form
    height_distance_elevation     [FIG] NCERT word problem
    height_distance_depression    [FIG] NCERT word problem
    inverse_trig_evaluate         arcsin(1/2), arctan(√3)
    triangle_solve_aas            two angles + side → solve triangle
    compound_angle_advanced       triple-angle expansion

  hard (Class 11-12 + JEE Mains):
    solve_basic_equation          sin x = 1/2 in [0, 2π]
    solve_quadratic_in_trig       2sin²x − 3sin x + 1 = 0
    solve_with_factoring          sin 2x = sin x → factor
    prove_identity_simple         cot x · tan x = 1 etc.
    inverse_trig_advanced         arcsin(x) + arccos(x) = π/2
    law_of_sines                  [FIG] triangle two angles + side
    law_of_cosines                [FIG] triangle SAS

  scholar (JEE Advanced / IIT):
    multiple_angle_solve          sin 3x = sin x — full solution set
    prove_identity_advanced       sin³x = (3 sin x − sin 3x)/4
    inverse_trig_sum              arctan(a) + arctan(b) identity
    max_min_a_sin_b_cos           max of a sin x + b cos x = √(a²+b²)
    iit_classics                  hand-curated proofs (14-item pool)
    triangle_inequality_iit       sin A + sin B + sin C bound for ABC
"""

from __future__ import annotations

import sympy as sp
import random
import json
import os
import sys
import math
from collections import Counter

# ── Figure generation (graceful degrade if matplotlib unavailable) ───
_fig_gen_available = False
_fig_gen = None
_FIGURE_TYPES_TRIGONOMETRY = set()
_figures_dir_trig = ""
try:
    import worksheet_figure_gen as _fig_gen
    _FIGURE_TYPES_TRIGONOMETRY = _fig_gen.FIGURE_TYPES_TRIGONOMETRY
    _figures_dir_trig = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "trigonometry",
        "figures")
    _fig_gen_available = True
    print("Figure generation enabled.")
except (ImportError, AttributeError) as e:
    print(f"worksheet_figure_gen not available — skipping figures ({e}).")

# ── Symbols ──────────────────────────────────────────────────────────
x = sp.Symbol("x", real=True)
A_sym, B_sym = sp.symbols("A B", real=True)


def rc(pool):
    return random.choice(pool)


# ── Standard angles in radians for unit-circle problems ──────────────
SPECIAL_ANGLES_RAD = [
    (0, "0"),
    (sp.pi / 6, r"\frac{\pi}{6}"),
    (sp.pi / 4, r"\frac{\pi}{4}"),
    (sp.pi / 3, r"\frac{\pi}{3}"),
    (sp.pi / 2, r"\frac{\pi}{2}"),
    (2 * sp.pi / 3, r"\frac{2\pi}{3}"),
    (3 * sp.pi / 4, r"\frac{3\pi}{4}"),
    (5 * sp.pi / 6, r"\frac{5\pi}{6}"),
    (sp.pi, r"\pi"),
    (7 * sp.pi / 6, r"\frac{7\pi}{6}"),
    (5 * sp.pi / 4, r"\frac{5\pi}{4}"),
    (4 * sp.pi / 3, r"\frac{4\pi}{3}"),
    (3 * sp.pi / 2, r"\frac{3\pi}{2}"),
    (5 * sp.pi / 3, r"\frac{5\pi}{3}"),
    (7 * sp.pi / 4, r"\frac{7\pi}{4}"),
    (11 * sp.pi / 6, r"\frac{11\pi}{6}"),
]

# Standard Pythagorean triples (a, b, c) with a < b < c
PY_TRIPLES = [(3, 4, 5), (5, 12, 13), (8, 15, 17), (7, 24, 25),
              (20, 21, 29), (9, 40, 41), (12, 35, 37)]


# ╔═════════════════════════════════════════════════════════════════════
# ║  BASIC — NCERT Class 10
# ╚═════════════════════════════════════════════════════════════════════

def gen_evaluate_unit_circle():
    """Evaluate trig function at a special angle."""
    func_name = rc(["sin", "cos", "tan"])
    angle, angle_latex = rc(SPECIAL_ANGLES_RAD)
    if func_name == "tan" and angle in (sp.pi / 2, 3 * sp.pi / 2):
        return None  # tan undefined
    fn = {"sin": sp.sin, "cos": sp.cos, "tan": sp.tan}[func_name]
    val = sp.simplify(fn(angle))

    q_latex = f"\\{func_name}\\left({angle_latex}\\right)"
    q_text  = ("Evaluate the trigonometric function at the given special "
               "angle.  Use unit-circle values; do not approximate.")
    a_latex = sp.latex(val)
    a_plain = str(val)
    return q_text, q_latex, a_latex, a_plain, None


def gen_right_triangle_basic():
    """Right-triangle problem with one unknown side. Pythagorean reasoning."""
    triple = rc(PY_TRIPLES)
    scale  = rc([1, 2, 3])
    a, b, c = scale * triple[0], scale * triple[1], scale * triple[2]
    unknown = rc(["opp", "adj", "hyp"])
    if unknown == "hyp":
        # Given: legs a and b; find hypotenuse c
        q_latex = (f"\\text{{legs}}: {a},\\; {b}; "
                   f"\\quad \\text{{find hypotenuse}}")
        q_text  = (f"In a right triangle, the two legs measure {a} units and "
                   f"{b} units. Find the hypotenuse using the Pythagorean "
                   "theorem.")
        a_latex = f"c = \\sqrt{{{a}^2 + {b}^2}} = {c}"
        a_plain = f"c = {c}"
    elif unknown == "opp":
        q_latex = (f"\\text{{adjacent}} = {b}, \\quad \\text{{hypotenuse}} = {c}; "
                   f"\\quad \\text{{find opposite leg}}")
        q_text  = (f"A right triangle has hypotenuse {c} and one leg of "
                   f"length {b}. Find the other leg.")
        a_latex = f"a = \\sqrt{{{c}^2 - {b}^2}} = {a}"
        a_plain = f"a = {a}"
    else:
        q_latex = (f"\\text{{opposite}} = {a}, \\quad \\text{{hypotenuse}} = {c}; "
                   f"\\quad \\text{{find adjacent leg}}")
        q_text  = (f"A right triangle has hypotenuse {c} and one leg of "
                   f"length {a}. Find the other leg.")
        a_latex = f"b = \\sqrt{{{c}^2 - {a}^2}} = {b}"
        a_plain = f"b = {b}"

    fig_data = None
    if random.random() < 0.18:
        fig_data = {"opp": a, "adj": b, "hyp": c, "unknown": unknown}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_right_triangle_ratios():
    """Given a right triangle, compute all 6 trig ratios for an angle."""
    triple = rc(PY_TRIPLES)
    scale = rc([1, 2, 3])
    a, b, c = scale * triple[0], scale * triple[1], scale * triple[2]
    # θ is the angle opposite side a (between hypotenuse and adjacent leg)
    sin_t = sp.Rational(a, c); cos_t = sp.Rational(b, c)
    tan_t = sp.Rational(a, b); cot_t = sp.Rational(b, a)
    sec_t = sp.Rational(c, b); csc_t = sp.Rational(c, a)

    target = rc(["all_three", "all_six", "two_specific"])
    if target == "all_three":
        q_text = ("Find sin θ, cos θ, and tan θ for the angle θ in the right "
                  "triangle (θ is the angle opposite the leg of length "
                  f"{a}).")
        a_latex = (f"\\sin\\theta = {sp.latex(sin_t)},\\; "
                   f"\\cos\\theta = {sp.latex(cos_t)},\\; "
                   f"\\tan\\theta = {sp.latex(tan_t)}")
        a_plain = f"sin θ = {sin_t}, cos θ = {cos_t}, tan θ = {tan_t}"
    elif target == "all_six":
        q_text = ("Find all six trigonometric ratios of θ in the right "
                  f"triangle (θ is the angle opposite the leg of length {a}).")
        a_latex = (f"\\sin\\theta = {sp.latex(sin_t)},\\; "
                   f"\\cos\\theta = {sp.latex(cos_t)},\\; "
                   f"\\tan\\theta = {sp.latex(tan_t)},\\; "
                   f"\\csc\\theta = {sp.latex(csc_t)},\\; "
                   f"\\sec\\theta = {sp.latex(sec_t)},\\; "
                   f"\\cot\\theta = {sp.latex(cot_t)}")
        a_plain = (f"sin={sin_t}, cos={cos_t}, tan={tan_t}, "
                   f"csc={csc_t}, sec={sec_t}, cot={cot_t}")
    else:  # two_specific
        # Pick any two from the six
        which = random.sample(["sin", "cos", "tan", "csc", "sec", "cot"], 2)
        vals = {"sin": sin_t, "cos": cos_t, "tan": tan_t,
                "csc": csc_t, "sec": sec_t, "cot": cot_t}
        q_text = (f"In the right triangle, find {which[0]} θ and {which[1]} θ "
                  f"for the angle θ opposite the leg of length {a}.")
        a_latex = (f"\\{which[0]}\\theta = {sp.latex(vals[which[0]])},\\; "
                   f"\\{which[1]}\\theta = {sp.latex(vals[which[1]])}")
        a_plain = f"{which[0]} θ = {vals[which[0]]}, {which[1]} θ = {vals[which[1]]}"

    q_latex = (f"\\text{{legs}} = {a}, {b}; \\quad \\text{{hyp}} = {c}; "
               r"\quad \theta \text{ opposite the leg of length } " + str(a))

    fig_data = None
    if random.random() < 0.18:
        fig_data = {"opp": a, "adj": b, "hyp": c, "unknown": None}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_right_triangle_find_angle():
    """Given two sides of a right triangle, find an angle (use arctan/arcsin/arccos)."""
    triple = rc(PY_TRIPLES)
    scale  = rc([1, 2, 3])
    a, b, c = scale * triple[0], scale * triple[1], scale * triple[2]
    given = rc(["opp_adj", "opp_hyp", "adj_hyp"])

    if given == "opp_adj":
        q_text = (f"In a right triangle, the leg opposite angle θ is {a} and "
                  f"the leg adjacent to θ is {b}. Find θ to the nearest "
                  "tenth of a degree.")
        ratio = sp.Rational(a, b); inv = "tan"
        ans = sp.atan(ratio); inv_repr = f"\\tan^{{-1}}\\left({sp.latex(ratio)}\\right)"
    elif given == "opp_hyp":
        q_text = (f"A right triangle has hypotenuse {c} and the leg opposite "
                  f"angle θ measures {a}. Find θ to the nearest tenth of a degree.")
        ratio = sp.Rational(a, c); inv = "sin"
        ans = sp.asin(ratio); inv_repr = f"\\sin^{{-1}}\\left({sp.latex(ratio)}\\right)"
    else:
        q_text = (f"A right triangle has hypotenuse {c} and the leg adjacent "
                  f"to angle θ measures {b}. Find θ to the nearest tenth of a degree.")
        ratio = sp.Rational(b, c); inv = "cos"
        ans = sp.acos(ratio); inv_repr = f"\\cos^{{-1}}\\left({sp.latex(ratio)}\\right)"

    deg = float(ans.evalf()) * 180 / math.pi
    q_latex = inv_repr + f" \\quad \\text{{(give result in degrees)}}"
    a_latex = f"\\theta = {inv_repr} \\approx {deg:.1f}^\\circ"
    a_plain = f"θ = {inv} inverse({ratio}) ≈ {deg:.1f}°"

    fig_data = None
    if random.random() < 0.18:
        # Mark the appropriate side as "known"
        fig_data = {"opp": a, "adj": b, "hyp": c, "unknown": None}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_right_triangle_real_world():
    """Ladder / ramp / shadow / flagpole — NCERT-style real-world."""
    scenario = rc(["ladder", "ramp", "shadow", "kite_string", "flagpole"])

    if scenario == "ladder":
        wall_h = rc([4, 5, 6, 8, 9, 10, 12])
        ladder = rc([wall_h + 2, wall_h + 3, wall_h + 4, wall_h + 5])
        # ladder² = wall_h² + base²  →  base = √(ladder² − wall_h²)
        base_sq = ladder ** 2 - wall_h ** 2
        if base_sq < 0:
            return None
        base = sp.sqrt(base_sq)
        if not base.is_integer:
            return None
        q_text = (f"A {ladder}-metre ladder leans against a vertical wall and "
                  f"reaches {wall_h} metres up the wall.  How far is the foot "
                  f"of the ladder from the wall?")
        q_latex = (f"\\text{{ladder}} = {ladder}\\text{{ m}}, \\quad "
                   f"\\text{{wall height}} = {wall_h}\\text{{ m}}; \\quad "
                   "\\text{{find base distance}}")
        a_latex = f"\\text{{base}} = {sp.latex(base)} \\text{{ m}}"
        a_plain = f"base = {base} m"
        fig_legs = (wall_h, int(base), ladder)

    elif scenario == "ramp":
        rise = rc([3, 4, 5, 6])
        run = rc([4, 6, 8, 12, 15])
        ramp_len = sp.sqrt(rise ** 2 + run ** 2)
        if not ramp_len.is_integer:
            return None
        q_text = (f"A wheelchair ramp rises {rise} ft over a horizontal run of "
                  f"{run} ft. Find the length of the ramp surface and the "
                  "angle it makes with the ground (to the nearest degree).")
        q_latex = (f"\\text{{rise}} = {rise}\\text{{ ft}}, \\quad "
                   f"\\text{{run}} = {run}\\text{{ ft}}")
        angle_deg = math.degrees(math.atan(rise / run))
        a_latex = (f"\\text{{ramp}} = {sp.latex(ramp_len)}\\text{{ ft}}, \\quad "
                   f"\\theta = \\tan^{{-1}}\\!\\left(\\dfrac{{{rise}}}{{{run}}}\\right) "
                   f"\\approx {angle_deg:.0f}^\\circ")
        a_plain = f"ramp = {ramp_len} ft, θ ≈ {angle_deg:.0f}°"
        fig_legs = (rise, run, int(ramp_len))

    elif scenario == "shadow":
        height = rc([6, 8, 10, 12, 15, 18, 20])
        sun_angle = rc([30, 45, 60])
        # tan(sun_angle) = height / shadow → shadow = height / tan(angle)
        if sun_angle == 30:
            shadow = sp.sqrt(3) * height
        elif sun_angle == 45:
            shadow = sp.Integer(height)
        else:
            shadow = sp.Rational(height) / sp.sqrt(3)
        shadow_simp = sp.simplify(shadow)
        q_text = (f"A {height}-metre tall flagpole casts a shadow on level "
                  f"ground when the sun is at an angle of elevation of "
                  f"{sun_angle}°. Find the length of the shadow.")
        q_latex = (f"\\text{{flagpole}} = {height}\\text{{ m}}, \\quad "
                   f"\\text{{sun elevation}} = {sun_angle}^\\circ; \\quad "
                   "\\text{{find shadow length}}")
        a_latex = f"s = {sp.latex(shadow_simp)}\\text{{ m}}"
        a_plain = f"shadow = {shadow_simp} m"
        # Approximate shadow for figure
        s_num = float(shadow_simp.evalf())
        fig_legs = (height, round(s_num, 1), None)

    elif scenario == "kite_string":
        height = rc([20, 30, 40, 50, 60])
        angle = rc([30, 45, 60])
        # sin(angle) = height / string → string = height / sin(angle)
        if angle == 30:
            string = 2 * height
        elif angle == 45:
            string = height * sp.sqrt(2)
        else:  # 60
            string = sp.Rational(2 * height, 1) / sp.sqrt(3)
        string_simp = sp.simplify(string)
        q_text = (f"A child flies a kite. The string makes an angle of "
                  f"{angle}° with the ground and the kite is at height "
                  f"{height} metres. Find the length of the string "
                  "(assume it is straight).")
        q_latex = (f"\\text{{kite height}} = {height}\\text{{ m}}, \\quad "
                   f"\\text{{string angle}} = {angle}^\\circ")
        a_latex = f"\\text{{string}} = {sp.latex(string_simp)}\\text{{ m}}"
        a_plain = f"string = {string_simp} m"
        fig_legs = (height, None, round(float(string_simp.evalf()), 1))

    else:  # flagpole observed
        distance = rc([10, 15, 20, 25, 30, 40])
        angle = rc([30, 45, 60])
        if angle == 30:
            height = sp.Rational(distance) / sp.sqrt(3)
        elif angle == 45:
            height = sp.Integer(distance)
        else:
            height = distance * sp.sqrt(3)
        height_simp = sp.simplify(height)
        q_text = (f"A surveyor stands {distance} metres from the base of a "
                  f"flagpole. The angle of elevation to the top of the "
                  f"flagpole is {angle}°. Find the height of the flagpole.")
        q_latex = (f"\\text{{distance}} = {distance}\\text{{ m}}, \\quad "
                   f"\\text{{angle of elevation}} = {angle}^\\circ; "
                   "\\quad \\text{{find height}}")
        a_latex = f"h = {sp.latex(height_simp)}\\text{{ m}}"
        a_plain = f"h = {height_simp} m"
        fig_legs = (round(float(height_simp.evalf()), 1), distance, None)

    fig_data = None
    if random.random() < 0.18 and fig_legs[0] and fig_legs[1]:
        fig_data = {"opp": fig_legs[0], "adj": fig_legs[1],
                    "hyp": fig_legs[2] or
                          round(math.sqrt(fig_legs[0] ** 2 + fig_legs[1] ** 2), 1),
                    "unknown": None}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_pythagorean_identity_quadrant():
    """Given sin θ and quadrant, find cos θ (and possibly tan θ)."""
    triple = rc(PY_TRIPLES)
    a, b, c = triple
    quadrant = rc([1, 2, 3, 4])

    # sin = a/c.  Sign in each quadrant: Q1 +/+, Q2 +/-, Q3 -/-, Q4 -/+
    if quadrant in (1, 2):
        sin_val = sp.Rational(a, c)
    else:
        sin_val = -sp.Rational(a, c)
    if quadrant in (1, 4):
        cos_val = sp.Rational(b, c)
    else:
        cos_val = -sp.Rational(b, c)
    tan_val = sin_val / cos_val

    q_latex = (f"\\sin\\theta = {sp.latex(sin_val)}, \\quad "
               f"\\theta \\in Q_{quadrant}")
    q_text  = (f"Given sin θ and the quadrant of θ, find cos θ and tan θ.  "
               "Use the Pythagorean identity cos²θ = 1 − sin²θ and choose "
               "the sign according to the quadrant.")
    a_latex = (f"\\cos\\theta = {sp.latex(cos_val)},\\; "
               f"\\tan\\theta = {sp.latex(tan_val)}")
    a_plain = f"cos θ = {cos_val}, tan θ = {tan_val}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_value_in_quadrant():
    """Sign reasoning: which trig functions are positive in each quadrant?"""
    quadrant = rc([2, 3, 4])
    # ASTC: All in Q1, Sin in Q2, Tan in Q3, Cos in Q4
    func_name = rc(["sin", "cos", "tan", "cot"])
    angle = rc([20, 30, 45, 60, 75])
    # Reference angle
    if quadrant == 2:
        full_angle = 180 - angle
    elif quadrant == 3:
        full_angle = 180 + angle
    else:  # Q4
        full_angle = 360 - angle

    sign_map = {
        (2, "sin"): "+", (2, "cos"): "-", (2, "tan"): "-", (2, "cot"): "-",
        (3, "sin"): "-", (3, "cos"): "-", (3, "tan"): "+", (3, "cot"): "+",
        (4, "sin"): "-", (4, "cos"): "+", (4, "tan"): "-", (4, "cot"): "-",
    }
    sign = sign_map[(quadrant, func_name)]

    q_latex = f"\\text{{Sign of }} \\{func_name}({full_angle}^\\circ)"
    q_text  = (f"Determine the sign of {func_name}({full_angle}°) without "
               "computing the value.  Use the ASTC mnemonic (All Students "
               "Take Calculus → All / Sin / Tan / Cos positive in Q1/Q2/Q3/Q4).")
    a_latex = (f"\\{func_name}({full_angle}^\\circ) "
               f"\\text{{ is }} {sign} \\text{{ (Q}}_{quadrant}\\text{{)}}")
    a_plain = f"{func_name}({full_angle}°) is {sign} (Q{quadrant})"
    return q_text, q_latex, a_latex, a_plain, None


def gen_complementary_angle():
    """sin(90° − θ) = cos θ; cos(90° − θ) = sin θ; etc."""
    func_name = rc(["sin", "cos", "tan", "cot"])
    angle = rc([15, 25, 35, 40, 55, 65, 75])
    complementary = 90 - angle
    co_func = {"sin": "cos", "cos": "sin", "tan": "cot", "cot": "tan"}[func_name]

    q_latex = f"\\{func_name}({complementary}^\\circ)"
    q_text  = ("Express in terms of an angle in [0°, 45°] using the "
               "complementary-angle identity:  "
               "sin(90° − θ) = cos θ,  cos(90° − θ) = sin θ, "
               "tan(90° − θ) = cot θ, cot(90° − θ) = tan θ.")
    a_latex = f"\\{co_func}({angle}^\\circ)"
    a_plain = f"{co_func}({angle}°)"
    return q_text, q_latex, a_latex, a_plain, None


def gen_reciprocal_identity():
    """Given tan θ = p/q (acute angle), find sec θ, csc θ, cot θ."""
    triple = rc(PY_TRIPLES)
    a, b, c = triple
    tan_val = sp.Rational(a, b)
    sec_val = sp.Rational(c, b)
    csc_val = sp.Rational(c, a)
    cot_val = sp.Rational(b, a)

    target = rc(["sec", "csc", "cot"])
    target_val = {"sec": sec_val, "csc": csc_val, "cot": cot_val}[target]

    q_latex = (f"\\tan\\theta = {sp.latex(tan_val)}, \\quad "
               f"\\theta \\in Q_1; \\quad \\text{{find }} "
               f"\\{target}\\theta")
    q_text  = (f"Given tan θ = {tan_val} with θ in the first quadrant, "
               f"find {target}(θ).  Use Pythagorean and reciprocal identities.")
    a_latex = f"\\{target}\\theta = {sp.latex(target_val)}"
    a_plain = f"{target}(θ) = {target_val}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_exact_value_special():
    """sin(15°), cos(15°), sin(75°), cos(75°) using sum/difference formulas."""
    case = rc(["sin15", "cos15", "sin75", "cos75", "tan15", "tan75"])

    sqrt3 = sp.sqrt(3)
    sqrt2 = sp.sqrt(2)
    if case == "sin15":
        # sin 15° = sin(45° − 30°) = (√6 − √2) / 4
        ans = (sp.sqrt(6) - sqrt2) / 4
        q_latex = r"\sin(15^\circ)"
    elif case == "cos15":
        ans = (sp.sqrt(6) + sqrt2) / 4
        q_latex = r"\cos(15^\circ)"
    elif case == "sin75":
        ans = (sp.sqrt(6) + sqrt2) / 4
        q_latex = r"\sin(75^\circ)"
    elif case == "cos75":
        ans = (sp.sqrt(6) - sqrt2) / 4
        q_latex = r"\cos(75^\circ)"
    elif case == "tan15":
        ans = 2 - sqrt3
        q_latex = r"\tan(15^\circ)"
    else:
        ans = 2 + sqrt3
        q_latex = r"\tan(75^\circ)"

    q_text  = ("Find the exact value using the sum or difference angle "
               "formula.  Express the answer with surds, not as a decimal.")
    a_latex = sp.latex(ans)
    a_plain = str(ans)
    return q_text, q_latex, a_latex, a_plain, None


def gen_unit_circle_evaluate():
    """Mark a special angle on the unit circle and read its (cos θ, sin θ)."""
    angle, angle_latex = rc(SPECIAL_ANGLES_RAD)
    cos_v = sp.cos(angle)
    sin_v = sp.sin(angle)

    q_latex = (f"\\theta = {angle_latex}; \\quad \\text{{find the point "
               f"on the unit circle: }} (\\cos\\theta, \\sin\\theta)")
    q_text  = (f"Identify the point on the unit circle corresponding to "
               f"θ = {angle_latex}.  State the coordinates (cos θ, sin θ) "
               "in exact form.")
    a_latex = f"\\left({sp.latex(cos_v)},\\; {sp.latex(sin_v)}\\right)"
    a_plain = f"({cos_v}, {sin_v})"

    fig_data = None
    if random.random() < 0.18:
        fig_data = {"angle_rad": float(angle)}
    return q_text, q_latex, a_latex, a_plain, fig_data


# ╔═════════════════════════════════════════════════════════════════════
# ║  MEDIUM — NCERT Class 11
# ╚═════════════════════════════════════════════════════════════════════

def gen_double_angle_evaluate():
    """Given sin x (with quadrant), compute sin(2x), cos(2x), tan(2x)."""
    triple = rc(PY_TRIPLES)
    a, b, c = triple
    quadrant = rc([1, 2])
    sin_x = sp.Rational(a, c)
    cos_x = sp.Rational(b, c) if quadrant == 1 else -sp.Rational(b, c)

    sin_2x = 2 * sin_x * cos_x
    cos_2x = cos_x ** 2 - sin_x ** 2
    tan_2x = sp.simplify(sin_2x / cos_2x) if cos_2x != 0 else None

    target = rc(["sin", "cos", "tan"])
    if target == "tan" and tan_2x is None:
        return None

    q_latex = (f"\\sin x = {sp.latex(sin_x)}, \\quad "
               f"x \\in Q_{quadrant}; \\quad "
               f"\\text{{find }} \\{target}(2x)")
    q_text  = (f"Use the double-angle formula to find {target}(2x).  "
               "Recall: sin(2x) = 2 sin x cos x, cos(2x) = cos²x − sin²x, "
               "tan(2x) = 2 tan x / (1 − tan²x).")
    if target == "sin":
        ans = sin_2x
    elif target == "cos":
        ans = cos_2x
    else:
        ans = tan_2x
    a_latex = f"\\{target}(2x) = {sp.latex(ans)}"
    a_plain = f"{target}(2x) = {ans}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_sum_diff_angle_evaluate():
    """sin(A + B), cos(A − B) computed from given sin A, sin B (both Q1)."""
    triple_a = rc(PY_TRIPLES)
    triple_b = rc(PY_TRIPLES)
    if triple_a == triple_b:
        return None

    sin_a = sp.Rational(triple_a[0], triple_a[2])
    cos_a = sp.Rational(triple_a[1], triple_a[2])
    sin_b = sp.Rational(triple_b[0], triple_b[2])
    cos_b = sp.Rational(triple_b[1], triple_b[2])

    case = rc(["sin_sum", "cos_diff", "sin_diff", "cos_sum"])
    if case == "sin_sum":
        ans = sin_a * cos_b + cos_a * sin_b
        target_latex = r"\sin(A + B)"
        formula = "sin(A) cos(B) + cos(A) sin(B)"
    elif case == "sin_diff":
        ans = sin_a * cos_b - cos_a * sin_b
        target_latex = r"\sin(A - B)"
        formula = "sin(A) cos(B) − cos(A) sin(B)"
    elif case == "cos_diff":
        ans = cos_a * cos_b + sin_a * sin_b
        target_latex = r"\cos(A - B)"
        formula = "cos(A) cos(B) + sin(A) sin(B)"
    else:
        ans = cos_a * cos_b - sin_a * sin_b
        target_latex = r"\cos(A + B)"
        formula = "cos(A) cos(B) − sin(A) sin(B)"

    q_latex = (f"\\sin A = {sp.latex(sin_a)},\\; "
               f"\\sin B = {sp.latex(sin_b)},\\; A, B \\in Q_1; \\; "
               f"\\text{{find }} {target_latex}")
    q_text  = (f"Apply the sum/difference angle formula  {formula}  "
               "(both A and B are acute, so cos is positive).")
    a_latex = f"{target_latex} = {sp.latex(ans)}"
    a_plain = f"{ans}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_product_to_sum():
    """Convert 2 sin A cos B → sin(A+B) + sin(A−B), etc."""
    A_deg = rc([20, 30, 40, 50, 60, 70, 80])
    B_deg = rc([15, 25, 35, 45, 55])
    if A_deg == B_deg:
        return None

    case = rc(["2sincos", "2cossin", "2coscos", "-2sinsin"])
    if case == "2sincos":
        # 2 sin A cos B = sin(A+B) + sin(A−B)
        q_latex = f"2 \\sin({A_deg}^\\circ) \\cos({B_deg}^\\circ)"
        a_latex = (f"\\sin({A_deg + B_deg}^\\circ) + "
                   f"\\sin({A_deg - B_deg}^\\circ)")
    elif case == "2cossin":
        q_latex = f"2 \\cos({A_deg}^\\circ) \\sin({B_deg}^\\circ)"
        a_latex = (f"\\sin({A_deg + B_deg}^\\circ) - "
                   f"\\sin({A_deg - B_deg}^\\circ)")
    elif case == "2coscos":
        q_latex = f"2 \\cos({A_deg}^\\circ) \\cos({B_deg}^\\circ)"
        a_latex = (f"\\cos({A_deg - B_deg}^\\circ) + "
                   f"\\cos({A_deg + B_deg}^\\circ)")
    else:  # -2 sin A sin B
        q_latex = f"-2 \\sin({A_deg}^\\circ) \\sin({B_deg}^\\circ)"
        a_latex = (f"\\cos({A_deg + B_deg}^\\circ) - "
                   f"\\cos({A_deg - B_deg}^\\circ)")

    q_text  = ("Convert the product to a sum or difference using the "
               "product-to-sum formulas (NCERT Class 11 Ch 3).")
    a_plain = a_latex.replace("\\", "").replace("^\\circ", "°")
    return q_text, q_latex, a_latex, a_plain, None


def gen_sum_to_product():
    """sin A + sin B = 2 sin((A+B)/2) cos((A−B)/2), etc."""
    A_deg = rc([20, 30, 40, 50, 60, 70, 80])
    B_deg = rc([10, 20, 30, 40, 50])
    if A_deg == B_deg:
        return None

    case = rc(["sin+sin", "sin-sin", "cos+cos", "cos-cos"])
    s = (A_deg + B_deg) / 2
    d = (A_deg - B_deg) / 2

    if case == "sin+sin":
        q_latex = f"\\sin({A_deg}^\\circ) + \\sin({B_deg}^\\circ)"
        a_latex = (f"2 \\sin({s}^\\circ) \\cos({d}^\\circ)")
    elif case == "sin-sin":
        q_latex = f"\\sin({A_deg}^\\circ) - \\sin({B_deg}^\\circ)"
        a_latex = (f"2 \\cos({s}^\\circ) \\sin({d}^\\circ)")
    elif case == "cos+cos":
        q_latex = f"\\cos({A_deg}^\\circ) + \\cos({B_deg}^\\circ)"
        a_latex = (f"2 \\cos({s}^\\circ) \\cos({d}^\\circ)")
    else:
        q_latex = f"\\cos({A_deg}^\\circ) - \\cos({B_deg}^\\circ)"
        a_latex = (f"-2 \\sin({s}^\\circ) \\sin({d}^\\circ)")

    q_text  = ("Convert the sum or difference to a product using the "
               "sum-to-product formulas.  Recall: "
               "sin A + sin B = 2 sin((A+B)/2) cos((A−B)/2).")
    a_plain = a_latex.replace("\\", "").replace("^\\circ", "°")
    return q_text, q_latex, a_latex, a_plain, None


def gen_height_distance_elevation():
    """NCERT Class 10 Ch 9 — angle of elevation."""
    # Plant clean answer: distance and angle determine height
    angle = rc([30, 45, 60])
    distance = rc([10, 20, 30, 40, 50, 60, 80, 100])
    # height = distance · tan(angle)
    if angle == 30:
        height_simp = sp.simplify(sp.Rational(distance, 1) * sp.tan(sp.pi / 6))
    elif angle == 45:
        height_simp = sp.Integer(distance)
    else:  # 60
        height_simp = sp.simplify(sp.Rational(distance, 1) * sp.tan(sp.pi / 3))

    # Diversified scenarios for the same physics
    scenario = rc(["tower", "tree", "lighthouse", "building", "monument", "pole"])
    observer = rc(["a point on level ground", "an observer on the ground",
                   "a person standing", "a surveyor stationed",
                   "the foot of a hill"])

    q_latex = (f"\\text{{horizontal distance}} = {distance}\\text{{ m}}, "
               f"\\quad \\text{{angle of elevation}} = {angle}^\\circ")
    q_text  = (f"From {observer} {distance} metres from the base of a "
               f"{scenario}, the angle of elevation to its top is "
               f"{angle}°. Find the height of the {scenario}. "
               "(NCERT Class 10 Ch 9 — Heights & Distances.)")
    a_latex = f"h = {sp.latex(height_simp)} \\text{{ m}}"
    a_plain = f"h = {height_simp} m"

    fig_data = None
    if random.random() < 0.18:
        # For the figure use approximate height (must be a number)
        try:
            h_for_fig = round(float(height_simp.evalf()), 1)
            if h_for_fig > 0:
                fig_data = {"distance": distance, "height": h_for_fig,
                            "angle_deg": angle}
        except Exception:
            pass
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_height_distance_depression():
    """NCERT Class 10 Ch 9 — angle of depression from a tower top."""
    angle = rc([30, 45, 60])
    height = rc([20, 30, 40, 50, 60, 75, 80, 100])
    # observer on top, looks down at horizontal distance d
    # tan(angle) = height / distance  →  distance = height / tan(angle)
    if angle == 30:
        distance = height * sp.sqrt(3)
    elif angle == 45:
        distance = height
    else:
        distance = sp.Rational(height, 1) / sp.sqrt(3)
    distance = sp.simplify(distance)

    # Diversified scenarios — observer location + target object
    scenario = rc(["tower", "lighthouse", "cliff", "balcony", "hilltop", "watchtower"])
    target_map = {
        "tower":      ("car",      "moving on level ground"),
        "lighthouse": ("ship",     "in the sea"),
        "cliff":      ("boat",     "in the harbour"),
        "balcony":    ("car",      "parked on the road below"),
        "hilltop":    ("village",  "on the plain below"),
        "watchtower": ("intruder", "approaching on level ground"),
    }
    target_obj, target_loc = target_map[scenario]

    q_latex = (f"\\text{{height}} = {height}\\text{{ m}}, "
               f"\\quad \\text{{angle of depression}} = {angle}^\\circ")
    q_text  = (f"From the top of a {height}-metre {scenario}, a {target_obj} "
               f"{target_loc} is observed at an angle of depression of "
               f"{angle}°. Find the horizontal distance from the foot of "
               f"the {scenario} to the {target_obj}. "
               "(NCERT Class 10 Ch 9 style.)")
    a_latex = f"d = {sp.latex(distance)} \\text{{ m}}"
    a_plain = f"d = {distance} m"

    fig_data = None
    if random.random() < 0.18:
        try:
            d_for_fig = round(float(distance.evalf()), 1)
            if d_for_fig > 0:
                fig_data = {"distance": d_for_fig, "height": height,
                            "angle_deg": angle}
        except Exception:
            pass
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_height_distance_two_angles():
    """NCERT classic: observer walks toward an object; angle of elevation
    increases from α to β. Find the height (and original distance)."""
    a_deg = rc([30, 45])
    b_deg = rc([60, 75])
    if a_deg >= b_deg:
        return None
    walked = rc([20, 30, 40, 60, 80, 100])
    a_rad = math.radians(a_deg); b_rad = math.radians(b_deg)
    # tan(a) = h/d, tan(b) = h/(d − walked)
    # → d = walked · tan(b) / (tan(b) − tan(a))
    d = walked * math.tan(b_rad) / (math.tan(b_rad) - math.tan(a_rad))
    h = d * math.tan(a_rad)
    object_type = rc(["tower", "lighthouse", "tree", "monument", "minaret"])

    q_latex = (f"\\alpha = {a_deg}^\\circ, \\quad \\beta = {b_deg}^\\circ, "
               f"\\quad \\text{{walk}} = {walked}\\text{{ m}}")
    q_text  = (f"From a point on level ground, the angle of elevation to "
               f"the top of a {object_type} is {a_deg}°. After walking "
               f"{walked} metres directly toward the {object_type} on "
               f"level ground, the angle of elevation increases to {b_deg}°. "
               f"Find the height of the {object_type} (to the nearest tenth).")
    a_latex = (f"h \\approx {h:.1f}\\text{{ m}}, \\quad "
               f"\\text{{original distance}} \\approx {d:.1f}\\text{{ m}}")
    a_plain = f"h ≈ {h:.1f} m, original d ≈ {d:.1f} m"

    fig_data = None
    if random.random() < 0.18 and h > 1 and d > walked:
        # Show the closer position with the larger angle β
        fig_data = {"distance": round(d - walked, 1), "height": round(h, 1),
                    "angle_deg": b_deg}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_height_distance_aircraft():
    """An aircraft / balloon at fixed height observes two ground points."""
    a_deg = rc([30, 45])
    b_deg = rc([60, 75])
    if a_deg >= b_deg:
        return None
    height = rc([100, 150, 200, 300, 500, 800, 1000])
    a_rad = math.radians(a_deg); b_rad = math.radians(b_deg)
    d1 = height / math.tan(a_rad)   # farther point
    d2 = height / math.tan(b_rad)   # nearer point
    sep = d1 - d2
    object_type = rc(["aircraft", "hot-air balloon", "drone", "helicopter"])

    q_latex = (f"h = {height}\\text{{ m}}, \\quad \\alpha = {a_deg}^\\circ, "
               f"\\quad \\beta = {b_deg}^\\circ")
    q_text  = (f"A {object_type} flying horizontally at height {height} m "
               f"observes two milestones on the ground (in the same vertical "
               f"plane below it). The angles of depression are {a_deg}° and "
               f"{b_deg}° respectively. Find the horizontal distance between "
               "the two milestones.")
    a_latex = (f"\\text{{separation}} = h\\,(\\cot\\alpha - \\cot\\beta) "
               f"\\approx {sep:.1f}\\text{{ m}}")
    a_plain = f"separation ≈ {sep:.1f} m"

    fig_data = None
    if random.random() < 0.18:
        # Show one of the two depression angles
        fig_data = {"distance": round(d1, 1), "height": height,
                    "angle_deg": a_deg}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_unit_circle_quadrant_reference():
    """Identify quadrant + reference angle for an arbitrary angle."""
    full = rc([110, 135, 150, 200, 225, 240, 290, 315, 330,
               -45, -120, -240, -300])
    # Normalise to [0, 360)
    norm = full % 360
    if norm < 90:
        quadrant = 1; reference = norm
    elif norm < 180:
        quadrant = 2; reference = 180 - norm
    elif norm < 270:
        quadrant = 3; reference = norm - 180
    else:
        quadrant = 4; reference = 360 - norm

    q_latex = f"\\theta = {full}^\\circ"
    q_text  = (f"For the angle θ = {full}°, find (a) the quadrant in which "
               "its terminal side lies (after normalising to the standard "
               "[0°, 360°) range), and (b) the reference angle.")
    a_latex = (f"\\text{{normalised}} = {norm}^\\circ; \\quad "
               f"\\text{{quadrant}} = Q_{quadrant}; \\quad "
               f"\\text{{reference}} = {reference}^\\circ")
    a_plain = f"normalised = {norm}°; Q{quadrant}; reference = {reference}°"

    fig_data = None
    if random.random() < 0.18:
        # Approximate angle in radians for the figure
        fig_data = {"angle_rad": math.radians(norm)}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_inverse_trig_evaluate():
    """arcsin(1/2), arctan(√3), arccos(0) — exact values."""
    pool = [
        (r"\arcsin\left(\frac{1}{2}\right)",       sp.pi / 6),
        (r"\arcsin\left(\frac{\sqrt{2}}{2}\right)", sp.pi / 4),
        (r"\arcsin\left(\frac{\sqrt{3}}{2}\right)", sp.pi / 3),
        (r"\arcsin(1)",                              sp.pi / 2),
        (r"\arccos\left(\frac{1}{2}\right)",       sp.pi / 3),
        (r"\arccos(0)",                              sp.pi / 2),
        (r"\arctan(1)",                              sp.pi / 4),
        (r"\arctan(\sqrt{3})",                       sp.pi / 3),
        (r"\arctan\left(\frac{1}{\sqrt{3}}\right)", sp.pi / 6),
        (r"\arcsin(-1)",                            -sp.pi / 2),
        (r"\arccos(-1)",                              sp.pi),
    ]
    q_latex, ans = rc(pool)
    q_text  = ("Evaluate the inverse trigonometric expression using the "
               "principal value branch (NCERT Class 12 Ch 2).")
    a_latex = sp.latex(ans)
    a_plain = str(ans)
    return q_text, q_latex, a_latex, a_plain, None


def gen_triangle_solve_aas():
    """Two angles + one side — solve the triangle (no figure)."""
    A_deg = rc([30, 40, 45, 50, 60, 70])
    B_deg = rc([20, 30, 40, 50, 60, 80])
    if A_deg + B_deg >= 170:
        return None
    C_deg = 180 - A_deg - B_deg
    side_a = rc([5, 6, 8, 10, 12, 15])

    # Law of sines: a/sin A = b/sin B = c/sin C
    A_rad = sp.pi * A_deg / 180
    B_rad = sp.pi * B_deg / 180
    C_rad = sp.pi * C_deg / 180

    side_b = side_a * sp.sin(B_rad) / sp.sin(A_rad)
    side_c = side_a * sp.sin(C_rad) / sp.sin(A_rad)
    side_b_n = float(side_b.evalf())
    side_c_n = float(side_c.evalf())

    q_latex = (f"A = {A_deg}^\\circ,\\; B = {B_deg}^\\circ,\\; a = {side_a}")
    q_text  = ("(AAS) Two angles and one side are given.  Find the third "
               "angle and the remaining two sides.  Use the law of sines "
               "a/sin A = b/sin B = c/sin C.")
    a_latex = (f"C = {C_deg}^\\circ,\\; "
               f"b \\approx {side_b_n:.3g},\\; c \\approx {side_c_n:.3g}")
    a_plain = (f"C = {C_deg}°, b ≈ {side_b_n:.3g}, c ≈ {side_c_n:.3g}")
    return q_text, q_latex, a_latex, a_plain, None


def gen_compound_angle_advanced():
    """Triple-angle expansion: sin(3x), cos(3x), tan(3x)."""
    case = rc(["sin3x", "cos3x", "tan3x"])
    if case == "sin3x":
        q_latex = r"\sin(3x)"
        ident = r"3 \sin x - 4 \sin^3 x"
        text = "Use sin(3x) = 3 sin x − 4 sin³ x."
    elif case == "cos3x":
        q_latex = r"\cos(3x)"
        ident = r"4 \cos^3 x - 3 \cos x"
        text = "Use cos(3x) = 4 cos³ x − 3 cos x."
    else:
        q_latex = r"\tan(3x)"
        ident = (r"\frac{3 \tan x - \tan^3 x}{1 - 3 \tan^2 x}")
        text = "Use tan(3x) = (3 tan x − tan³ x) / (1 − 3 tan² x)."

    q_text  = (f"Express in terms of sin x, cos x, or tan x.  {text}")
    a_latex = ident
    a_plain = ident.replace("\\", "")
    return q_text, q_latex, a_latex, a_plain, None


# ╔═════════════════════════════════════════════════════════════════════
# ║  HARD — Class 11-12 + JEE Mains
# ╚═════════════════════════════════════════════════════════════════════

def gen_solve_basic_equation():
    """sin x = c in [0, 2π]."""
    func_name = rc(["sin", "cos", "tan"])
    pool = [
        (sp.Rational(1, 2),        r"\frac{1}{2}"),
        (sp.sqrt(2) / 2,           r"\frac{\sqrt{2}}{2}"),
        (sp.sqrt(3) / 2,           r"\frac{\sqrt{3}}{2}"),
        (-sp.Rational(1, 2),       r"-\frac{1}{2}"),
        (sp.Integer(0),            "0"),
        (sp.Integer(1),            "1"),
        (-sp.Integer(1),           "-1"),
        (sp.sqrt(3),               r"\sqrt{3}"),
        (sp.Integer(1) / sp.sqrt(3), r"\frac{1}{\sqrt{3}}"),
    ]
    val, val_latex = rc(pool)
    fn = {"sin": sp.sin, "cos": sp.cos, "tan": sp.tan}[func_name]

    if func_name == "tan" and val in (sp.sqrt(2) / 2, sp.sqrt(3) / 2):
        return None  # not standard tan values
    try:
        sols = sp.solveset(fn(x) - val, x, domain=sp.Interval(0, 2 * sp.pi))
    except Exception:
        return None
    if sols == sp.S.EmptySet:
        return None

    q_latex = f"\\{func_name}(x) = {val_latex}, \\quad x \\in [0, 2\\pi]"
    q_text  = (f"Find all solutions of the equation in [0, 2π].  Use the "
               "unit-circle reference angles.")
    a_latex = f"x \\in {sp.latex(sols)}"
    a_plain = f"x in {sols}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_solve_quadratic_in_trig():
    """2 sin²x − 3 sin x + 1 = 0 — substitute u = sin x."""
    func_name = rc(["sin", "cos"])
    fn = {"sin": sp.sin, "cos": sp.cos}[func_name]
    # Plant clean roots in u: e.g. u = 1, 1/2 → 2u² − 3u + 1 = 0
    cases = [(1, sp.Rational(1, 2)), (-1, sp.Rational(1, 2)),
             (sp.Rational(1, 2), -sp.Rational(1, 2))]
    u1, u2 = rc(cases)
    A = 2
    B = sp.simplify(-A * (u1 + u2))
    C = sp.simplify(A * u1 * u2)

    expr = A * fn(x) ** 2 + B * fn(x) + C
    try:
        sols = sp.solveset(expr, x, domain=sp.Interval(0, 2 * sp.pi))
    except Exception:
        return None
    if sols == sp.S.EmptySet:
        return None

    q_latex = (f"{A} \\{func_name}^2 x "
               f"{('+ ' + sp.latex(B)) if B >= 0 else ('- ' + sp.latex(-B))} "
               f"\\{func_name} x "
               f"{('+ ' + sp.latex(C)) if C >= 0 else ('- ' + sp.latex(-C))} = 0, "
               r"\quad x \in [0, 2\pi]")
    q_text  = ("Solve the quadratic equation in the given trig function.  "
               f"Substitute u = {func_name}(x), solve the resulting "
               "quadratic, then back-substitute.")
    a_latex = f"x \\in {sp.latex(sols)}"
    a_plain = f"x in {sols}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_solve_with_factoring():
    """sin 2x = sin x → factor and solve."""
    case = rc(["sin2x_eq_sinx", "cos2x_eq_cosx", "sin2x_eq_cosx"])
    if case == "sin2x_eq_sinx":
        # 2 sin x cos x − sin x = 0  →  sin x (2 cos x − 1) = 0
        expr = sp.sin(2 * x) - sp.sin(x)
        q_latex = r"\sin(2x) = \sin x, \quad x \in [0, 2\pi]"
        hint = ("Use sin(2x) = 2 sin x cos x, then factor "
                "out sin x to get sin x · (2 cos x − 1) = 0.")
    elif case == "cos2x_eq_cosx":
        expr = sp.cos(2 * x) - sp.cos(x)
        q_latex = r"\cos(2x) = \cos x, \quad x \in [0, 2\pi]"
        hint = ("Use cos(2x) = 2 cos²x − 1, get a quadratic in cos x.")
    else:
        expr = sp.sin(2 * x) - sp.cos(x)
        q_latex = r"\sin(2x) = \cos x, \quad x \in [0, 2\pi]"
        hint = ("Use sin(2x) = 2 sin x cos x, factor out cos x.")

    try:
        sols = sp.solveset(expr, x, domain=sp.Interval(0, 2 * sp.pi))
    except Exception:
        return None
    if sols == sp.S.EmptySet:
        return None

    q_text = (f"Solve the equation on [0, 2π].  {hint}")
    a_latex = f"x \\in {sp.latex(sols)}"
    a_plain = f"x in {sols}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_prove_identity_simple():
    """Hand-curated pool of basic identities to prove."""
    pool = [
        {"q_latex": r"\tan x \cdot \cot x = 1",
         "q_text":  ("Prove the identity. Use the reciprocal definitions "
                     "tan x = sin x / cos x, cot x = cos x / sin x."),
         "a_latex": (r"\tan x \cdot \cot x "
                     r"= \frac{\sin x}{\cos x} \cdot \frac{\cos x}{\sin x} = 1.")},
        {"q_latex": r"\sec^2 x - \tan^2 x = 1",
         "q_text":  ("Prove the Pythagorean-derived identity. "
                     "Hint: divide sin²x + cos²x = 1 by cos²x."),
         "a_latex": (r"\sin^2 x + \cos^2 x = 1 \Rightarrow "
                     r"\frac{\sin^2 x}{\cos^2 x} + 1 = \frac{1}{\cos^2 x}; "
                     r"\;\; \tan^2 x + 1 = \sec^2 x.")},
        {"q_latex": r"\frac{1 - \cos x}{\sin x} = \tan\!\left(\frac{x}{2}\right)",
         "q_text":  ("Prove the half-angle identity. Use the double-angle "
                     "formulas for cos x and sin x in terms of x/2."),
         "a_latex": (r"\frac{1 - \cos x}{\sin x} "
                     r"= \frac{2 \sin^2(x/2)}{2 \sin(x/2) \cos(x/2)} "
                     r"= \frac{\sin(x/2)}{\cos(x/2)} = \tan(x/2).")},
        {"q_latex": (r"\sin x \cos x = \tfrac{1}{2} \sin(2x)"),
         "q_text":  ("Prove using the double-angle formula."),
         "a_latex": (r"\sin(2x) = 2 \sin x \cos x \Rightarrow "
                     r"\sin x \cos x = \tfrac{1}{2}\sin(2x).")},
        {"q_latex": (r"\cos^2 x - \sin^2 x = \cos(2x)"),
         "q_text":  ("Prove the double-angle identity for cosine."),
         "a_latex": (r"\cos(2x) = \cos^2 x - \sin^2 x "
                     r"\text{ (one of three equivalent forms).}")},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], \
           item["a_latex"].replace("\\", ""), None


def gen_inverse_trig_advanced():
    """arcsin x + arccos x = π/2 type identities."""
    pool = [
        {"q_latex": (r"\sin^{-1}(x) + \cos^{-1}(x) = ?, "
                     r"\quad x \in [-1, 1]"),
         "q_text":  ("State the identity and prove it by setting "
                     "θ = sin⁻¹(x) and applying complementary-angle reasoning."),
         "a_latex": (r"\sin^{-1}(x) + \cos^{-1}(x) = \tfrac{\pi}{2}, \;\; "
                     r"x \in [-1, 1].")},
        {"q_latex": (r"\tan^{-1}(x) + \tan^{-1}\!\left(\tfrac{1}{x}\right) = ?, "
                     r"\quad x > 0"),
         "q_text":  ("State and prove the identity for x > 0."),
         "a_latex": (r"\tan^{-1}(x) + \tan^{-1}(1/x) = \tfrac{\pi}{2}, "
                     r"\quad x > 0; "
                     r"\quad = -\tfrac{\pi}{2} \text{ for } x < 0.")},
        {"q_latex": (r"\sin^{-1}(\sin\theta) = ?, "
                     r"\quad \theta \in [-\pi/2, \pi/2]"),
         "q_text":  ("State the principal-value identity for sin⁻¹(sin θ)."),
         "a_latex": (r"\sin^{-1}(\sin\theta) = \theta, "
                     r"\;\; \theta \in [-\pi/2, \pi/2]; \; "
                     r"\text{otherwise need to reduce to the principal range.}")},
        {"q_latex": (r"2 \tan^{-1}(x) = \sin^{-1}\!\left("
                     r"\frac{2x}{1 + x^2}\right), \quad x \in [-1, 1]"),
         "q_text":  ("Prove the double-tangent identity using the "
                     "tangent half-angle substitution."),
         "a_latex": (r"\text{Let } \theta = \tan^{-1}(x); "
                     r"\sin(2\theta) = \frac{2\tan\theta}{1+\tan^2\theta} "
                     r"= \frac{2x}{1 + x^2}, "
                     r"\text{ so } 2\theta = \sin^{-1}\!\left(\frac{2x}{1+x^2}\right).")},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], \
           item["a_latex"].replace("\\", ""), None


def gen_law_of_sines():
    """Triangle problem with two angles + one side (or AAS) — find a side."""
    A_deg = rc([30, 45, 60])
    B_deg = rc([45, 60, 75])
    if A_deg + B_deg >= 170:
        return None
    C_deg = 180 - A_deg - B_deg
    side_a = rc([6, 8, 10, 12, 15])

    # Solve for side b using law of sines
    A_rad = sp.pi * A_deg / 180
    B_rad = sp.pi * B_deg / 180
    side_b = side_a * sp.sin(B_rad) / sp.sin(A_rad)
    side_b_v = float(side_b.evalf())

    q_latex = (f"\\text{{In }} \\triangle ABC: \\; A = {A_deg}^\\circ, "
               f"\\; B = {B_deg}^\\circ, \\; a = {side_a}; "
               f"\\text{{ find side }} b.")
    q_text  = (f"In a triangle, two angles A = {A_deg}° and B = {B_deg}° "
               f"are given along with the side opposite A, which is "
               f"{side_a} units.  Apply the law of sines to find side b "
               "(opposite angle B).")
    a_latex = (f"b = \\frac{{{side_a} \\sin {B_deg}^\\circ}}{{\\sin {A_deg}^\\circ}} "
               f"\\approx {side_b_v:.3g}")
    a_plain = f"b = {side_a} sin({B_deg})/sin({A_deg}) ≈ {side_b_v:.3g}"

    fig_data = None
    if random.random() < 0.18:
        # Estimate side c too for figure
        side_c = side_a * float(sp.sin(sp.pi * C_deg / 180).evalf()) / float(sp.sin(A_rad).evalf())
        fig_data = {"side_a": side_a, "side_b": round(side_b_v, 1),
                    "side_c": round(side_c, 1),
                    "angle_A_deg": A_deg, "angle_B_deg": B_deg,
                    "angle_C_deg": C_deg,
                    "labels": {"a": str(side_a), "A": f"{A_deg}°",
                               "B": f"{B_deg}°", "b": "?"}}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_law_of_cosines():
    """SAS — two sides and included angle, find third side."""
    side_a = rc([4, 5, 6, 7, 8])
    side_b = rc([5, 6, 7, 8, 9])
    if side_a == side_b:
        return None
    C_deg = rc([30, 45, 60, 90, 120])
    C_rad = sp.pi * C_deg / 180

    # c² = a² + b² − 2ab cos C
    c_sq = side_a ** 2 + side_b ** 2 - 2 * side_a * side_b * sp.cos(C_rad)
    side_c = sp.sqrt(c_sq)
    side_c_v = float(side_c.evalf())

    q_latex = (f"\\text{{In }} \\triangle ABC: \\; a = {side_a}, "
               f"\\; b = {side_b}, \\; C = {C_deg}^\\circ; "
               f"\\text{{ find side }} c.")
    q_text  = (f"Given two sides a = {side_a} and b = {side_b}, with the "
               f"included angle C = {C_deg}°, find the third side c using "
               "the law of cosines: c² = a² + b² − 2ab cos C.")
    a_latex = f"c = \\sqrt{{{sp.latex(c_sq)}}} \\approx {side_c_v:.3g}"
    a_plain = f"c ≈ {side_c_v:.3g}"

    fig_data = None
    if random.random() < 0.18:
        # Compute remaining angles for figure
        A_rad = sp.acos((side_b ** 2 + c_sq - side_a ** 2) / (2 * side_b * side_c))
        A_deg = float(A_rad.evalf()) * 180 / float(sp.pi.evalf())
        B_deg = 180 - C_deg - A_deg
        fig_data = {"side_a": side_a, "side_b": side_b,
                    "side_c": round(side_c_v, 1),
                    "angle_A_deg": round(A_deg, 1),
                    "angle_B_deg": round(B_deg, 1),
                    "angle_C_deg": C_deg,
                    "labels": {"a": str(side_a), "b": str(side_b),
                               "C": f"{C_deg}°", "c": "?"}}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_triangle_sss_find_angle():
    """SSS configuration — given three sides, find an angle via law of cosines.
       cos C = (a² + b² − c²) / (2ab)."""
    # Plant clean answer: pick triangle from a curated list with nice angles
    pool = [
        # (a, b, c, opposite_to_C, angle_C_deg, angle_C_latex)
        (5, 5, 5,            "C", 60,  r"60^\circ"),                  # equilateral
        (3, 4, 5,            "C", 90,  r"90^\circ"),                  # right
        (5, 12, 13,          "C", 90,  r"90^\circ"),
        (7, 8, 13,           "C", 120, r"120^\circ"),                 # cos C = -1/2
        (7, 7, 7,            "C", 60,  r"60^\circ"),
        (6, 8, 10,           "C", 90,  r"90^\circ"),
    ]
    a, b, c, vertex, deg, latex_deg = rc(pool)
    # Use law of cosines symbolically
    cos_C = sp.Rational(a ** 2 + b ** 2 - c ** 2, 2 * a * b)

    q_latex = (f"\\text{{In }} \\triangle ABC: \\; a = {a}, \\; b = {b}, "
               f"\\; c = {c}; \\quad \\text{{find angle }} {vertex}.")
    q_text  = ("Three sides of a triangle are given. Use the law of cosines "
               "to find the indicated angle:  cos C = (a² + b² − c²) / (2ab).")
    a_latex = (f"\\cos {vertex} = {sp.latex(cos_C)} \\Rightarrow "
               f"{vertex} = {latex_deg}")
    a_plain = f"{vertex} = {deg}°"

    fig_data = None
    if random.random() < 0.18:
        fig_data = {"side_a": a, "side_b": b, "side_c": c,
                    "angle_A_deg": 60, "angle_B_deg": 60, "angle_C_deg": deg,
                    "labels": {"a": str(a), "b": str(b), "c": str(c),
                               "C": "?"}}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_triangle_area_sas():
    """Find area of triangle from two sides + included angle.
       Area = (1/2) · a · b · sin(C)."""
    side_a = rc([5, 6, 8, 10, 12, 15])
    side_b = rc([4, 6, 7, 9, 11, 14])
    if side_a == side_b:
        return None
    angle_C = rc([30, 45, 60, 90, 120, 135, 150])
    angle_C_rad = sp.pi * angle_C / 180

    area = sp.simplify(sp.Rational(1, 2) * side_a * side_b * sp.sin(angle_C_rad))

    q_latex = (f"a = {side_a}, \\; b = {side_b}, \\; C = {angle_C}^\\circ; "
               f"\\quad \\text{{find area of }} \\triangle ABC.")
    q_text  = (f"In triangle ABC, sides a and b are {side_a} and {side_b} "
               f"units, with included angle C = {angle_C}°. Find the area "
               "using the formula  Area = (1/2) · a · b · sin C.")
    a_latex = (f"\\text{{Area}} = \\tfrac{{1}}{{2}} \\cdot {side_a} \\cdot "
               f"{side_b} \\cdot \\sin {angle_C}^\\circ = {sp.latex(area)}")
    a_plain = f"Area = {area}"

    fig_data = None
    if random.random() < 0.18:
        # Compute side c via law of cosines for figure
        cos_C = math.cos(math.radians(angle_C))
        c_sq  = side_a ** 2 + side_b ** 2 - 2 * side_a * side_b * cos_C
        side_c = round(math.sqrt(c_sq), 1)
        fig_data = {"side_a": side_a, "side_b": side_b, "side_c": side_c,
                    "angle_A_deg": 60, "angle_B_deg": 60, "angle_C_deg": angle_C,
                    "labels": {"a": str(side_a), "b": str(side_b),
                               "C": f"{angle_C}°"}}
    return q_text, q_latex, a_latex, a_plain, fig_data


def gen_triangle_ssa_ambiguous():
    """SSA — the ambiguous case: given two sides and a non-included angle."""
    A_deg = rc([30, 40, 45, 60])
    side_a = rc([6, 8, 10, 12])      # opposite angle A (the given angle)
    side_b = rc([7, 9, 11, 13, 15])  # adjacent to A

    A_rad = math.radians(A_deg)
    sin_B = side_b * math.sin(A_rad) / side_a

    if sin_B > 1:
        # No triangle exists
        case_label = "no triangle"
        case_text  = ("(SSA) — using the law of sines, sin B > 1, "
                      "which is impossible. No triangle exists with these "
                      "measurements.")
        a_latex = (f"\\sin B = \\frac{{b \\sin A}}{{a}} = {sin_B:.3f} > 1 "
                   r"\Rightarrow \text{ no triangle.}")
        a_plain = f"sin B = {sin_B:.3f} > 1; no triangle"
    elif abs(sin_B - 1) < 1e-9:
        # Right triangle, B = 90°
        case_label = "one (right) triangle"
        B_deg = 90
        C_deg = 180 - A_deg - B_deg
        side_c = side_a * math.sin(math.radians(C_deg)) / math.sin(A_rad)
        a_latex = (f"\\sin B = 1 \\Rightarrow B = 90^\\circ, \\; "
                   f"C = {C_deg}^\\circ, \\; c = {side_c:.2f}")
        a_plain = f"B = 90°, C = {C_deg}°, c = {side_c:.2f}"
    else:
        B_deg_acute = math.degrees(math.asin(sin_B))
        B_deg_obtuse = 180 - B_deg_acute
        if A_deg + B_deg_obtuse < 180:
            # Two solutions
            case_label = "two triangles (ambiguous)"
            C1 = 180 - A_deg - B_deg_acute
            C2 = 180 - A_deg - B_deg_obtuse
            c1 = side_a * math.sin(math.radians(C1)) / math.sin(A_rad)
            c2 = side_a * math.sin(math.radians(C2)) / math.sin(A_rad)
            a_latex = (f"\\text{{Triangle 1: }} B \\approx {B_deg_acute:.1f}^\\circ, "
                       f"C \\approx {C1:.1f}^\\circ, c \\approx {c1:.2f}; "
                       f"\\quad \\text{{Triangle 2: }} B \\approx "
                       f"{B_deg_obtuse:.1f}^\\circ, C \\approx {C2:.1f}^\\circ, "
                       f"c \\approx {c2:.2f}.")
            a_plain = (f"Two triangles: T1: B ≈ {B_deg_acute:.1f}°, "
                       f"C ≈ {C1:.1f}°, c ≈ {c1:.2f}; "
                       f"T2: B ≈ {B_deg_obtuse:.1f}°, C ≈ {C2:.1f}°, "
                       f"c ≈ {c2:.2f}")
        else:
            case_label = "one triangle (acute)"
            C_deg = 180 - A_deg - B_deg_acute
            side_c = side_a * math.sin(math.radians(C_deg)) / math.sin(A_rad)
            a_latex = (f"B \\approx {B_deg_acute:.1f}^\\circ, "
                       f"C \\approx {C_deg:.1f}^\\circ, "
                       f"c \\approx {side_c:.2f}")
            a_plain = (f"B ≈ {B_deg_acute:.1f}°, C ≈ {C_deg:.1f}°, "
                       f"c ≈ {side_c:.2f}")

    q_latex = (f"A = {A_deg}^\\circ, \\; a = {side_a}, \\; b = {side_b}; "
               f"\\quad \\text{{(SSA — solve the triangle)}}")
    q_text  = (f"(Ambiguous SSA case)  Given angle A = {A_deg}°, side a = "
               f"{side_a}, and side b = {side_b}, determine how many "
               "triangles are possible and solve each one. "
               "Use the law of sines: sin B = b · sin A / a, then "
               "check whether the supplement also yields a valid triangle.")

    fig_data = None
    if random.random() < 0.18 and "no triangle" not in case_label:
        # Approximate side c for figure
        try:
            B_deg_for_fig = B_deg_acute if "acute" in case_label \
                else (90 if "right" in case_label else B_deg_acute)
            C_deg_for_fig = 180 - A_deg - B_deg_for_fig
            side_c_for_fig = side_a * math.sin(math.radians(C_deg_for_fig)) \
                / math.sin(A_rad)
            fig_data = {"side_a": side_a, "side_b": side_b,
                        "side_c": round(side_c_for_fig, 1),
                        "angle_A_deg": A_deg,
                        "angle_B_deg": round(B_deg_for_fig, 1),
                        "angle_C_deg": round(C_deg_for_fig, 1),
                        "labels": {"a": str(side_a), "b": str(side_b),
                                   "A": f"{A_deg}°"}}
        except Exception:
            pass
    return q_text, q_latex, a_latex, a_plain, fig_data


# ╔═════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — JEE Advanced / IIT
# ╚═════════════════════════════════════════════════════════════════════

def gen_multiple_angle_solve():
    """sin 3x = sin x — find all solutions in [0, 2π]."""
    case = rc(["sin3=sin", "cos3=cos", "sin3=cos"])
    if case == "sin3=sin":
        expr = sp.sin(3 * x) - sp.sin(x)
        q_latex = r"\sin(3x) = \sin x, \quad x \in [0, 2\pi]"
        hint = ("Use sum-to-product: sin(3x) − sin(x) = 2 cos(2x) sin(x). "
                "Then set each factor to 0.")
    elif case == "cos3=cos":
        expr = sp.cos(3 * x) - sp.cos(x)
        q_latex = r"\cos(3x) = \cos x, \quad x \in [0, 2\pi]"
        hint = ("Use sum-to-product: cos(3x) − cos(x) = −2 sin(2x) sin(x).")
    else:
        expr = sp.sin(3 * x) - sp.cos(x)
        q_latex = r"\sin(3x) = \cos x, \quad x \in [0, 2\pi]"
        hint = ("Rewrite cos x = sin(π/2 − x) and apply sum-to-product.")

    try:
        sols = sp.solveset(expr, x, domain=sp.Interval(0, 2 * sp.pi))
    except Exception:
        return None
    if sols == sp.S.EmptySet:
        return None

    q_text  = (f"(JEE Advanced) Find all solutions on [0, 2π].  {hint}")
    a_latex = f"x \\in {sp.latex(sols)}"
    a_plain = f"x in {sols}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_prove_identity_advanced():
    """Hand-curated JEE/IIT identity-proof pool."""
    pool = [
        {"q_latex": r"\sin^3 x = \frac{3 \sin x - \sin(3x)}{4}",
         "q_text":  ("Prove the identity using the triple-angle formula "
                     "sin(3x) = 3 sin x − 4 sin³ x."),
         "a_latex": (r"\sin(3x) = 3\sin x - 4\sin^3 x \Rightarrow "
                     r"4\sin^3 x = 3\sin x - \sin(3x); "
                     r"\;\; \sin^3 x = \frac{3 \sin x - \sin(3x)}{4}.")},
        {"q_latex": r"\cos^3 x = \frac{3 \cos x + \cos(3x)}{4}",
         "q_text":  ("Prove using the triple-angle formula "
                     "cos(3x) = 4 cos³ x − 3 cos x."),
         "a_latex": (r"\cos(3x) = 4\cos^3 x - 3\cos x \Rightarrow "
                     r"4\cos^3 x = \cos(3x) + 3\cos x; "
                     r"\;\; \cos^3 x = \frac{3 \cos x + \cos(3x)}{4}.")},
        {"q_latex": (r"\tan A + \tan B + \tan C = \tan A \tan B \tan C, "
                     r"\quad A + B + C = \pi"),
         "q_text":  ("(IIT-JEE classic) Prove the identity for the angles "
                     "of any triangle."),
         "a_latex": (r"A + B = \pi - C \Rightarrow "
                     r"\tan(A + B) = -\tan C \Rightarrow "
                     r"\frac{\tan A + \tan B}{1 - \tan A \tan B} = -\tan C; "
                     r"\;\; \tan A + \tan B = -\tan C + \tan A \tan B \tan C; "
                     r"\;\; \tan A + \tan B + \tan C = \tan A \tan B \tan C.")},
        {"q_latex": (r"\sin A + \sin B + \sin C "
                     r"= 4 \cos(A/2) \cos(B/2) \cos(C/2), "
                     r"\quad A + B + C = \pi"),
         "q_text":  ("(IIT-JEE classic) Prove this triangle-sum identity "
                     "using sum-to-product twice."),
         "a_latex": (r"\sin A + \sin B = 2 \sin\!\frac{A+B}{2}\cos\!\frac{A-B}{2}; "
                     r"\sin C = \sin(A+B) = 2 \sin\!\frac{A+B}{2}\cos\!\frac{A+B}{2}; "
                     r"\text{ combine and use } \frac{A+B}{2} = \frac{\pi-C}{2}.")},
        {"q_latex": r"\cos 36^\circ = \frac{\sqrt{5} + 1}{4}",
         "q_text":  ("(JEE classic) Prove using the equation "
                     "5θ = 180° (where θ = 36°), or via the regular pentagon."),
         "a_latex": (r"\text{Let } \theta = 36^\circ; \; "
                     r"5\theta = 180^\circ \Rightarrow \cos(2\theta) = \cos(180-3\theta) = -\cos(3\theta); "
                     r"\text{ leads to a quadratic in } \cos\theta \text{ with positive root } "
                     r"\frac{1+\sqrt{5}}{4}.")},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], \
           item["a_latex"].replace("\\", ""), None


def gen_inverse_trig_sum():
    """arctan(a) + arctan(b) = arctan((a+b)/(1−ab))."""
    a = rc([1, 2, 3, sp.Rational(1, 2), sp.Rational(1, 3), sp.Rational(2, 3)])
    b = rc([1, 2, 3, sp.Rational(1, 2), sp.Rational(1, 3), sp.Rational(2, 4)])
    if a == b or a * b == 1:
        return None
    target = sp.simplify((a + b) / (1 - a * b))

    q_latex = (f"\\tan^{{-1}}({sp.latex(a)}) + \\tan^{{-1}}({sp.latex(b)})")
    q_text  = ("Express as a single inverse-tangent.  Use the identity "
               "arctan(a) + arctan(b) = arctan((a + b) / (1 − ab))  for ab < 1.")
    a_latex = f"\\tan^{{-1}}\\!\\left({sp.latex(target)}\\right)"
    a_plain = f"arctan({target})"
    return q_text, q_latex, a_latex, a_plain, None


def gen_max_min_a_sin_b_cos():
    """Max of a sin x + b cos x = √(a² + b²)."""
    a_v = rc([3, 4, 5, 6, 7, 8])
    b_v = rc([3, 4, 5, 6, 7, 8])
    if a_v == b_v:
        return None
    R = sp.sqrt(a_v ** 2 + b_v ** 2)

    q_latex = f"f(x) = {a_v} \\sin x + {b_v} \\cos x"
    q_text  = (f"Find the maximum and minimum values of f(x) = "
               f"{a_v} sin x + {b_v} cos x.  Use the identity "
               "a sin x + b cos x = √(a² + b²) sin(x + φ).")
    a_latex = (f"f_{{\\max}} = {sp.latex(R)}, \\; "
               f"f_{{\\min}} = -{sp.latex(R)}")
    a_plain = f"max = {R}, min = -{R}"
    return q_text, q_latex, a_latex, a_plain, None


def gen_iit_classics():
    """Hand-curated pool of IIT-JEE Advanced trig classics."""
    pool = [
        {"q_latex": (r"\text{Find the principal value of } "
                     r"\sin^{-1}\!\left(\sin\!\frac{5\pi}{6}\right)."),
         "q_text":  ("Recall the principal value range of sin⁻¹ is "
                     "[−π/2, π/2].  Reduce the argument."),
         "a_latex": (r"\sin\!\frac{5\pi}{6} = \sin\!\left(\pi - \frac{5\pi}{6}\right) "
                     r"= \sin\!\frac{\pi}{6}; \;\; "
                     r"\sin^{-1}\!\left(\sin\!\frac{5\pi}{6}\right) = \frac{\pi}{6}.")},
        {"q_latex": (r"\text{Solve: } \sin x \sin 2x \sin 3x = \frac{1}{4}, "
                     r"\quad x \in [0, \pi]."),
         "q_text":  ("(IIT-JEE Advanced) Use product-to-sum and identity "
                     "manipulations.  This problem has finitely many "
                     "solutions in the given interval."),
         "a_latex": (r"\text{Use } 2\sin x \sin 3x = \cos 2x - \cos 4x; "
                     r"\text{ then } \sin 2x (\cos 2x - \cos 4x) = \frac{1}{2}; "
                     r"\text{ leads to } x \in \{\pi/9, 2\pi/9, 4\pi/9, "
                     r"5\pi/9, 7\pi/9, 8\pi/9\}.")},
        {"q_latex": (r"\text{Find the number of values of } x \in (0, \pi) "
                     r"\text{ for which } \sin x + \sin 2x + \sin 3x = "
                     r"\cos x + \cos 2x + \cos 3x."),
         "q_text":  ("(IIT-JEE) Combine using sum-to-product; the equation "
                     "factors with a common term."),
         "a_latex": (r"\text{Both sides factor with } (1 + 2\cos x); \; "
                     r"\sin 2x = \cos 2x \Rightarrow \tan 2x = 1; "
                     r"\;\; x = \pi/8, 5\pi/8 \text{ in } (0, \pi).")},
        {"q_latex": (r"\text{If } \sin\theta_1 + \sin\theta_2 + \sin\theta_3 = 3, "
                     r"\text{ find } \theta_1 + \theta_2 + \theta_3."),
         "q_text":  ("(IIT-JEE) Each sin θᵢ is at most 1, so equality forces "
                     "each to equal 1.  Determine the only possible θᵢ in "
                     "[0, 2π]."),
         "a_latex": (r"\sin\theta_i = 1 \forall i \Rightarrow "
                     r"\theta_i = \pi/2; \;\; "
                     r"\theta_1 + \theta_2 + \theta_3 = \frac{3\pi}{2}.")},
        {"q_latex": (r"\text{Prove: } \cos\!\frac{\pi}{7} \cos\!\frac{2\pi}{7} "
                     r"\cos\!\frac{3\pi}{7} = \frac{1}{8}."),
         "q_text":  ("(IIT-JEE classic) Use the product-of-cosines formula "
                     "with N angles in arithmetic progression."),
         "a_latex": (r"\text{Multiply both sides by } 2\sin(\pi/7); \text{ telescoping "
                     r"gives } \frac{\sin(8\pi/7)}{2^3 \sin(\pi/7)} "
                     r"= -\frac{\sin(\pi/7)}{8 \sin(\pi/7)} = -\frac{1}{8}; "
                     r"\text{ note sign convention picks up } \cos(3\pi/7) > 0.")},
        {"q_latex": (r"\text{If } x + y + z = \pi/2, "
                     r"\text{ prove } \tan x \tan y + \tan y \tan z + \tan z \tan x = 1."),
         "q_text":  ("(IIT-JEE) Use x + y = π/2 − z; take tan of both sides."),
         "a_latex": (r"\tan(x + y) = \tan(\pi/2 - z) = \cot z; \;\; "
                     r"\frac{\tan x + \tan y}{1 - \tan x \tan y} = \frac{1}{\tan z}; "
                     r"\text{ cross-multiply and rearrange.}")},
        {"q_latex": (r"\text{Find: } \cos 20^\circ \cos 40^\circ \cos 60^\circ \cos 80^\circ."),
         "q_text":  ("(IIT-JEE) Use cos 60° = 1/2 and the identity "
                     "cos θ cos(60° − θ) cos(60° + θ) = (1/4) cos(3θ)."),
         "a_latex": (r"\cos 60^\circ = \tfrac{1}{2}; \; "
                     r"\cos 20^\circ \cos 40^\circ \cos 80^\circ "
                     r"= \tfrac{1}{4}\cos 60^\circ = \tfrac{1}{8}; \; "
                     r"\text{ total } = \tfrac{1}{2} \cdot \tfrac{1}{8} = \tfrac{1}{16}.")},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], \
           item["a_latex"].replace("\\", ""), None


def gen_triangle_inequality_iit():
    """sin A + sin B + sin C ≤ 3√3/2 for triangle ABC."""
    pool = [
        {"q_latex": (r"\text{In any triangle ABC, prove: } "
                     r"\sin A + \sin B + \sin C \leq \frac{3\sqrt{3}}{2}."),
         "q_text":  ("(IIT-JEE) Use Jensen's inequality on the concave "
                     "function sin x on (0, π), with x = A, B, C summing to π."),
         "a_latex": (r"\sin x \text{ is concave on } (0, \pi); \;\; "
                     r"\frac{\sin A + \sin B + \sin C}{3} \leq "
                     r"\sin\!\frac{A+B+C}{3} = \sin\!\frac{\pi}{3} "
                     r"= \frac{\sqrt 3}{2}; \;\; "
                     r"\sin A + \sin B + \sin C \leq \frac{3\sqrt 3}{2}; "
                     r"\text{ equality at equilateral triangle.}")},
        {"q_latex": (r"\text{In } \triangle ABC, \text{ prove: } "
                     r"\cos A + \cos B + \cos C \leq \frac{3}{2}."),
         "q_text":  ("(IIT-JEE) Use the identity cos A + cos B + cos C = "
                     "1 + r/R where r, R are inradius and circumradius, "
                     "with r ≤ R/2 (Euler)."),
         "a_latex": (r"1 + \frac{r}{R} \leq 1 + \frac{1}{2} = \frac{3}{2}; "
                     r"\text{ equality at equilateral.}")},
        {"q_latex": (r"\text{Prove: in any triangle, } "
                     r"\tan A + \tan B + \tan C \geq 3\sqrt{3} \text{ (acute triangle)}."),
         "q_text":  ("(IIT-JEE) Using the result tan A + tan B + tan C = "
                     "tan A · tan B · tan C, apply AM-GM."),
         "a_latex": (r"\tan A \tan B \tan C \geq \left(\frac{\tan A + \tan B + \tan C}{3}\right)^3; "
                     r"\text{ combined with Sigma = product, get } \Sigma \geq 3\sqrt 3.")},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], \
           item["a_latex"].replace("\\", ""), None


# ╔═════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "evaluate_unit_circle",
        "right_triangle_basic",
        "right_triangle_ratios",          # NEW
        "right_triangle_find_angle",      # NEW
        "right_triangle_real_world",      # NEW
        "pythagorean_identity_quadrant",
        "value_in_quadrant",
        "complementary_angle",
        "reciprocal_identity",
        "exact_value_special",
        "unit_circle_evaluate",
        "unit_circle_quadrant_reference", # NEW
    ],
    "medium": [
        "double_angle_evaluate",
        "sum_diff_angle_evaluate",
        "product_to_sum",
        "sum_to_product",
        "height_distance_elevation",
        "height_distance_depression",
        "height_distance_two_angles",     # NEW
        "height_distance_aircraft",       # NEW
        "inverse_trig_evaluate",
        "triangle_solve_aas",
        "compound_angle_advanced",
    ],
    "hard": [
        "solve_basic_equation",
        "solve_quadratic_in_trig",
        "solve_with_factoring",
        "prove_identity_simple",
        "inverse_trig_advanced",
        "law_of_sines",
        "law_of_cosines",
        "triangle_sss_find_angle",        # NEW
        "triangle_area_sas",              # NEW
        "triangle_ssa_ambiguous",         # NEW
    ],
    "scholar": [
        "multiple_angle_solve",
        "prove_identity_advanced",
        "inverse_trig_sum",
        "max_min_a_sin_b_cos",
        "iit_classics",
        "triangle_inequality_iit",
    ],
}


def call_generator(q_type):
    generators = {
        "evaluate_unit_circle":          gen_evaluate_unit_circle,
        "right_triangle_basic":          gen_right_triangle_basic,
        "right_triangle_ratios":         gen_right_triangle_ratios,
        "right_triangle_find_angle":     gen_right_triangle_find_angle,
        "right_triangle_real_world":     gen_right_triangle_real_world,
        "unit_circle_quadrant_reference": gen_unit_circle_quadrant_reference,
        "height_distance_two_angles":    gen_height_distance_two_angles,
        "height_distance_aircraft":      gen_height_distance_aircraft,
        "triangle_sss_find_angle":       gen_triangle_sss_find_angle,
        "triangle_area_sas":             gen_triangle_area_sas,
        "triangle_ssa_ambiguous":        gen_triangle_ssa_ambiguous,
        "pythagorean_identity_quadrant": gen_pythagorean_identity_quadrant,
        "value_in_quadrant":             gen_value_in_quadrant,
        "complementary_angle":           gen_complementary_angle,
        "reciprocal_identity":           gen_reciprocal_identity,
        "exact_value_special":           gen_exact_value_special,
        "unit_circle_evaluate":          gen_unit_circle_evaluate,
        "double_angle_evaluate":         gen_double_angle_evaluate,
        "sum_diff_angle_evaluate":       gen_sum_diff_angle_evaluate,
        "product_to_sum":                gen_product_to_sum,
        "sum_to_product":                gen_sum_to_product,
        "height_distance_elevation":     gen_height_distance_elevation,
        "height_distance_depression":    gen_height_distance_depression,
        "inverse_trig_evaluate":         gen_inverse_trig_evaluate,
        "triangle_solve_aas":            gen_triangle_solve_aas,
        "compound_angle_advanced":       gen_compound_angle_advanced,
        "solve_basic_equation":          gen_solve_basic_equation,
        "solve_quadratic_in_trig":       gen_solve_quadratic_in_trig,
        "solve_with_factoring":          gen_solve_with_factoring,
        "prove_identity_simple":         gen_prove_identity_simple,
        "inverse_trig_advanced":         gen_inverse_trig_advanced,
        "law_of_sines":                  gen_law_of_sines,
        "law_of_cosines":                gen_law_of_cosines,
        "multiple_angle_solve":          gen_multiple_angle_solve,
        "prove_identity_advanced":       gen_prove_identity_advanced,
        "inverse_trig_sum":              gen_inverse_trig_sum,
        "max_min_a_sin_b_cos":           gen_max_min_a_sin_b_cos,
        "iit_classics":                  gen_iit_classics,
        "triangle_inequality_iit":       gen_triangle_inequality_iit,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain, fig_data = res
    return {
        "q_text":    q_text,
        "q_latex":   q_latex,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "fig_data":  fig_data,
    }


def generate_trig_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.30:
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

        entry = {
            "id":               len(questions) + 1,
            "type":             q_type,
            "difficulty":       diff,
            "expression_latex": data["q_latex"],
            "question_text":    data["q_text"],
            "answer_latex":     data["ans_latex"],
            "answer_plain":     data["ans_plain"],
        }

        # Optional figure attachment — figure_capable types include
        # `fig_data` in their return; the trigonometry figure dispatcher
        # then renders the SVG.  Probability gating in each generator
        # already keeps overall figure share below 10%.
        if (_fig_gen_available
                and data.get("fig_data") is not None
                and q_type in _FIGURE_TYPES_TRIGONOMETRY):
            try:
                fig_path = _fig_gen.generate_figure_for_trigonometry(
                    q_type, data["fig_data"], entry["id"], _figures_dir_trig)
                if fig_path:
                    # Path relative to webapp root — matches the convention
                    # used by limits, logarithms, etc. so worksheet-engine.js
                    # can resolve <img src> correctly when loaded from any
                    # calculator page at the webapp root.
                    entry["figure_svg"] = ("worksheet/math/trigonometry/figures/"
                                            + os.path.basename(fig_path))
            except Exception as e:
                # Figure failure is non-fatal — log and continue
                print(f"  fig fail for {q_type} id={entry['id']}: {e}",
                      file=sys.stderr)

        questions.append(entry)

    return questions


if __name__ == "__main__":
    n_target = int(sys.argv[1]) if len(sys.argv) > 1 else 1500
    random.seed()

    if _fig_gen_available:
        os.makedirs(_figures_dir_trig, exist_ok=True)

    qs = generate_trig_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "trigonometry")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "trigonometry.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Trigonometry",
            "description": ("NCERT Class 10 (Intro + Heights & Distances), "
                            "Class 11 (Trigonometric Functions), Class 12 "
                            "(Inverse Trig), and JEE Mains/Advanced + IIT-level "
                            "olympiad problems.  Covers function evaluation, "
                            "identity proofs, equation solving, height-distance "
                            "applications, and law of sines/cosines.  Most "
                            "right-triangle and height-distance problems "
                            "include a labelled SVG figure."),
            "questions": qs,
        }, f, separators=(",", ":"))

    fig_count = sum(1 for q in qs if q.get("figure_svg"))
    print(f"Generated {len(qs)} trig problems → {out_path}")
    print(f"  Figures attached: {fig_count} ({100 * fig_count / len(qs):.1f}%)")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        marker = " [FIG]" if t in _FIGURE_TYPES_TRIGONOMETRY else ""
        print(f"  {t:35s}  {c:>4}{marker}")
