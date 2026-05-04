#!/usr/bin/env python3
"""
generate_significant_figures.py — sig-fig & scientific-notation worksheet.

Covers all 5 modes of the sig-fig calculator (Calculate, Count, Round,
Scientific, Practice) and the standard chemistry / physics / lab-math
question types that students encounter in:
  · NCERT Class 8 (numbers, scientific notation)
  · Class 11-12 chemistry (significant figures in measurements)
  · NEET / IIT-JEE physics (units & dimensions chapter)
  · College gen-chem (precision, accuracy, error propagation)

Output: src/main/webapp/worksheet/math/numerics/significant_figures.json

Run:
    python3 generate_significant_figures.py [N]   # default 1500
    python3 generate_worksheet_metadata.py        # refresh global index

Question types (24 total):

  basic — counting & identifying:
    count_no_zeros              12345 → 5 sig figs
    count_with_decimal_zeros    12.30 → 4 (trailing zero after dec.)
    count_leading_zeros         0.0034 → 2 (leading zeros not sig)
    count_trapped_zeros         1002 → 4 (zeros between digits)
    count_scientific_notation   1.23×10⁵ → 3
    count_ambiguous             1200 → 2/3/4 — discuss + scientific form
    identify_more_precise       Which is more precise?

  medium — rounding & notation:
    round_to_n_sf               round 1234.5 to 3 sf → 1230
    round_with_carry            round 9.99 to 2 sf → 10. (carry)
    round_decimal_small         round 0.004567 to 2 sf → 0.0046
    decimal_to_scientific       340000 → 3.40×10⁵
    scientific_to_decimal       2.5×10⁻³ → 0.0025
    scientific_with_n_sf        write 1234 in scientific to 3 sf

  hard — arithmetic with sig-fig rules:
    add_subtract_dp             12.34 + 5.6 → 17.9 (1 dp rule)
    subtract_loss_precision     12.345 − 12.34 → 0.005 (1 sf only)
    multiply_div_sf             12.34 × 5.6 → 69 (2 sf)
    divide_with_rounding        100. / 7.0 → 14 (2 sf)
    density_calc                m / V with sig-fig rounding
    area_volume_calc            l × w (× h) with sig-fig rules
    speed_or_unit_calc          d / t — scientific lab-style

  scholar — chemistry / physics / IIT:
    exact_vs_measured           distinguish counted exact vs measured
    log_sig_figs                log(345) — only mantissa is sig
    molarity_calc               g → mol → M with sig figs
    multistep_chem              full lab-style multi-step chain
    relative_uncertainty        propagation of % error
"""

from __future__ import annotations

import math
import random
import json
import os
import sys
from collections import Counter
from decimal import Decimal, getcontext

getcontext().prec = 40


def rc(pool):
    return random.choice(pool)


def ordinal(n: int) -> str:
    """1 → 1st, 2 → 2nd, 3 → 3rd, 4 → 4th, etc."""
    if 11 <= (n % 100) <= 13:
        return f"{n}th"
    suffix = {1: "st", 2: "nd", 3: "rd"}.get(n % 10, "th")
    return f"{n}{suffix}"


# ╔═══════════════════════════════════════════════════════════════════════
# ║  HELPERS — sig-fig counting, rounding, scientific notation
# ╚═══════════════════════════════════════════════════════════════════════

def count_sig_figs(num_str: str) -> int:
    """Count sig figs in a numeric string.

    Rules implemented:
      1. All non-zero digits are significant.
      2. Zeros between non-zero digits (trapped) are significant.
      3. Leading zeros are NOT significant.
      4. Trailing zeros after a decimal point ARE significant.
      5. Trailing zeros in a whole number (no decimal) are AMBIGUOUS — by
         convention here we treat them as NOT significant for plain decimal
         input (caller must use scientific notation to disambiguate).
    """
    s = num_str.strip().lstrip("+-")
    if "e" in s or "E" in s:
        mant = s.split("e" if "e" in s else "E")[0]
        return count_sig_figs(mant)
    if "." in s:
        s_clean = s.lstrip("0")
        if s_clean.startswith("."):
            s_clean = s_clean[1:].lstrip("0")
        else:
            s_clean = s_clean.replace(".", "")
        return len(s_clean)
    s_stripped = s.lstrip("0").rstrip("0")
    return len(s_stripped) if s_stripped else 0


def round_to_sig_figs(value: float, n_sf: int) -> str:
    """Round value to n_sf significant figures and return as a string.

    Preserves trailing zeros where required (e.g. 10. for 9.99→2sf, 0.0050
    for 0.005003→2sf).
    """
    if value == 0:
        return "0." + "0" * (n_sf - 1) if n_sf > 1 else "0"
    sign = "-" if value < 0 else ""
    v = abs(value)
    exp10 = int(math.floor(math.log10(v)))
    factor = 10 ** (exp10 - n_sf + 1)
    rounded = round(v / factor) * factor
    if exp10 >= n_sf - 1:
        s = f"{rounded:.0f}"
        return sign + s
    decimals = (n_sf - 1) - exp10
    s = f"{rounded:.{decimals}f}"
    return sign + s


def to_scientific(value: float, n_sf: int) -> tuple[str, int]:
    """Return (mantissa_str, exponent) for value rounded to n_sf sig figs."""
    if value == 0:
        return ("0." + "0" * (n_sf - 1) if n_sf > 1 else "0", 0)
    sign = "-" if value < 0 else ""
    v = abs(value)
    exp10 = int(math.floor(math.log10(v)))
    mantissa = v / (10 ** exp10)
    factor = 10 ** -(n_sf - 1)
    mantissa_rounded = round(mantissa / factor) * factor
    if mantissa_rounded >= 10:
        mantissa_rounded /= 10
        exp10 += 1
    decimals = max(0, n_sf - 1)
    s = f"{mantissa_rounded:.{decimals}f}"
    return (sign + s, exp10)


def fmt_sci_latex(mantissa_str: str, exponent: int) -> str:
    if exponent == 0:
        return mantissa_str
    return f"{mantissa_str} \\times 10^{{{exponent}}}"


def fmt_sci_plain(mantissa_str: str, exponent: int) -> str:
    if exponent == 0:
        return mantissa_str
    return f"{mantissa_str} × 10^{exponent}"


# ╔═══════════════════════════════════════════════════════════════════════
# ║  BASIC — counting and identifying sig figs
# ╚═══════════════════════════════════════════════════════════════════════

def gen_count_no_zeros():
    """Plain integer or decimal with no zeros — direct count."""
    digits = rc([2, 3, 4, 5, 6, 7])
    nonzero = "123456789"
    s = "".join(random.choice(nonzero) for _ in range(digits))
    if rc([True, False]) and digits >= 3:
        cut = random.randint(1, digits - 1)
        s = s[:cut] + "." + s[cut:]
    sf = count_sig_figs(s)

    q_latex = s
    q_text = (f"How many significant figures does {s} have?  Apply Rule 1 "
              "(all non-zero digits are significant).")
    a_latex = (f"\\text{{Count: }} {s} \\rightarrow {sf} \\text{{ sig figs.}}")
    a_plain = f"{sf} sig fig{'s' if sf != 1 else ''}"
    return q_text, q_latex, a_latex, a_plain


def gen_count_with_decimal_zeros():
    """Trailing zeros AFTER a decimal point ARE significant."""
    integer_part = rc(["1", "2", "3", "5", "8", "12", "47", "100"])
    decimals = rc([1, 2, 3, 4])
    nonzero = "123456789"
    nz = random.randint(1, max(1, decimals - 1))
    body = "".join(random.choice(nonzero) for _ in range(nz))
    trailing = "0" * (decimals - nz)
    s = f"{integer_part}.{body}{trailing}"
    sf = count_sig_figs(s)

    q_latex = s
    q_text = (f"How many significant figures does {s} have?  Apply Rule 4 "
              "(trailing zeros after a decimal point ARE significant).")
    a_latex = (f"\\text{{In }} {s}, \\text{{ all digits including the "
               f"trailing zeros after the decimal point are significant: }} "
               f"{sf} \\text{{ sig figs.}}")
    a_plain = f"{sf} sig fig{'s' if sf != 1 else ''}"
    return q_text, q_latex, a_latex, a_plain


def gen_count_leading_zeros():
    """Leading zeros are NEVER significant."""
    leading = rc([1, 2, 3, 4, 5])
    nonzero = "123456789"
    body_len = rc([1, 2, 3, 4])
    body = "".join(random.choice(nonzero) for _ in range(body_len))
    s = "0." + ("0" * leading) + body
    sf = count_sig_figs(s)

    q_latex = s
    q_text = (f"How many significant figures does {s} have?  Apply Rule 3 "
              "(leading zeros — including the 0 before the decimal — are "
              "NOT significant).")
    a_latex = (f"\\text{{Strip leading zeros: }} {s} \\to {body}; \\; "
               f"\\text{{count}} = {sf}.")
    a_plain = f"{sf} sig fig{'s' if sf != 1 else ''}"
    return q_text, q_latex, a_latex, a_plain


def gen_count_trapped_zeros():
    """Zeros BETWEEN non-zero digits are significant."""
    nonzero = "123456789"
    n_zeros = rc([1, 2, 3])
    pre = random.choice(nonzero)
    post_len = rc([1, 2, 3])
    post = "".join(random.choice(nonzero) for _ in range(post_len))
    s = pre + ("0" * n_zeros) + post
    sf = count_sig_figs(s)

    q_latex = s
    q_text = (f"How many significant figures does {s} have?  Apply Rule 2 "
              "(zeros between non-zero digits are significant).")
    a_latex = (f"\\text{{All digits in }} {s} \\text{{ count, including "
               f"the trapped zero(s): }} {sf} \\text{{ sig figs.}}")
    a_plain = f"{sf} sig fig{'s' if sf != 1 else ''}"
    return q_text, q_latex, a_latex, a_plain


def gen_count_scientific_notation():
    """Sig figs in scientific notation = sig figs of the mantissa."""
    nonzero = "123456789"
    nz = rc([2, 3, 4])
    mant_int = random.choice(nonzero)
    mant_frac = "".join(random.choice(nonzero) for _ in range(nz - 1))
    if rc([True, False]):
        mant_frac = mant_frac[:-1] + "0"
    mantissa = f"{mant_int}.{mant_frac}"
    exp10 = rc([-6, -4, -3, -2, 2, 3, 4, 5, 6])
    s = f"{mantissa} \\times 10^{{{exp10}}}"
    sf = count_sig_figs(mantissa)

    q_latex = s
    q_text = (f"How many significant figures does the number "
              f"{mantissa} × 10^{exp10} have?  Only the mantissa contributes; "
              "the power of 10 sets the magnitude, not precision.")
    a_latex = (f"\\text{{Sig figs of }} {mantissa} = {sf}; \\; "
               f"\\text{{the }} \\times 10^{{{exp10}}} \\text{{ factor is "
               "ignored.}}")
    a_plain = f"{sf} sig fig{'s' if sf != 1 else ''}"
    return q_text, q_latex, a_latex, a_plain


def gen_count_ambiguous():
    """Whole numbers with trailing zeros (no decimal) are AMBIGUOUS."""
    nonzero = "123456789"
    nz = rc([1, 2])
    nz_part = "".join(random.choice(nonzero) for _ in range(nz))
    zeros = rc([2, 3, 4])
    s = nz_part + "0" * zeros

    min_sf = nz
    max_sf = len(s)
    s_with_dot = s + "."

    q_latex = s
    q_text = (f"The number {s} has trailing zeros without a decimal point, "
              "so its sig-fig count is AMBIGUOUS.  State the possible range "
              "and show how scientific notation would clarify the intended "
              "precision.")
    a_latex = (f"\\text{{Ambiguous range: }} {min_sf} \\le \\text{{sf}} \\le "
               f"{max_sf}.  \\text{{ Use scientific notation to disambiguate, "
               f"e.g. }} {nz_part}.{'0' * (min_sf - 1) if min_sf > 1 else ''} "
               f"\\times 10^{{{len(s) - 1 if nz == 1 else len(s) - 2}}} "
               f"({min_sf}\\text{{ sf}}), \\text{{ or write }} {s_with_dot} "
               f"\\text{{ to mean all }} {max_sf} \\text{{ sf are intended.}}")
    a_plain = (f"Ambiguous: {min_sf} to {max_sf} sig figs.  Use scientific "
               f"notation to clarify, or write {s_with_dot} for {max_sf} sf.")
    return q_text, q_latex, a_latex, a_plain


def gen_identify_more_precise():
    """Compare two measurements; the one with more sig figs is more precise."""
    a = rc(["12.5", "1.250", "0.0034", "12.345", "1.2 \\times 10^3",
            "1.20 \\times 10^3", "100.", "100", "0.500", "5.0",
            "0.0050", "0.00500"])
    b = rc(["12.5", "1.250", "0.0034", "12.345", "1.2 \\times 10^3",
            "1.20 \\times 10^3", "100.", "100", "0.500", "5.0",
            "0.0050", "0.00500"])
    if a == b:
        return None

    def clean(s):
        if "\\times 10^" in s:
            return s.replace("\\times 10^{", "e").replace("}", "")
        return s

    sf_a = count_sig_figs(clean(a))
    sf_b = count_sig_figs(clean(b))
    if sf_a == sf_b:
        return None
    winner = a if sf_a > sf_b else b
    sf_w = max(sf_a, sf_b)

    backslash_times = "\\times"
    a_pretty = a.replace(backslash_times, "×")
    b_pretty = b.replace(backslash_times, "×")
    q_latex = f"\\text{{Compare: }} {a} \\quad \\text{{vs}} \\quad {b}"
    q_text = (f"Which measurement is more precise (i.e., has more "
              f"significant figures)?  {a_pretty} or {b_pretty}?")
    a_latex = (f"{a}: {sf_a} \\text{{ sf}}; \\quad "
               f"{b}: {sf_b} \\text{{ sf}}; \\quad "
               f"\\text{{more precise: }} {winner} \\; ({sf_w} \\text{{ sf}}).")
    winner_pretty = winner.replace(backslash_times, "×")
    a_plain = f"{winner_pretty} ({sf_w} sf)"
    return q_text, q_latex, a_latex, a_plain


# ╔═══════════════════════════════════════════════════════════════════════
# ║  MEDIUM — rounding and scientific notation conversion
# ╚═══════════════════════════════════════════════════════════════════════

def gen_round_to_n_sf():
    """Round a number with extra digits to n_sf significant figures."""
    val_int = random.randint(100, 99999)
    decimal_part = random.randint(0, 999)
    value = float(f"{val_int}.{decimal_part:03d}")
    n_sf = rc([2, 3, 4])
    if n_sf >= count_sig_figs(str(value).rstrip("0").rstrip(".")):
        return None

    rounded = round_to_sig_figs(value, n_sf)
    q_latex = f"\\text{{round }} {value} \\text{{ to }} {n_sf} \\text{{ sf}}"
    q_text = (f"Round {value} to {n_sf} significant figures.  Identify the "
              f"{ordinal(n_sf)} sig fig, look at the next digit, and round "
              "up if it is 5 or greater.")
    a_latex = (f"{value} \\rightarrow {rounded} \\quad ({n_sf} "
               "\\text{{ sf}})")
    a_plain = f"{rounded}"
    return q_text, q_latex, a_latex, a_plain


def gen_round_with_carry():
    """Rounding causes a carry — e.g. 9.99 → 10. (note the trailing decimal)."""
    cases = [
        (9.99, 2, "10."),
        (99.5, 2, "100."),
        (9.95, 2, "10."),
        (199.6, 2, "200."),
        (0.0996, 2, "0.10"),
        (0.999, 2, "1.0"),
        (9.996, 3, "10.0"),
        (99.97, 3, "100."),
        (4.995, 3, "5.00"),
        (0.04996, 2, "0.050"),
    ]
    value, n_sf, expected = rc(cases)

    q_latex = f"\\text{{round }} {value} \\text{{ to }} {n_sf} \\text{{ sf}}"
    q_text = (f"Round {value} to {n_sf} significant figures.  Notice that "
              f"rounding the {ordinal(n_sf)} sig fig causes a carry into the "
              "next place — keep track of the trailing zeros so the answer "
              f"still shows {n_sf} sig figs.")
    a_latex = (f"{value} \\rightarrow {expected} \\quad ({n_sf} "
               "\\text{{ sf, the trailing zero(s) are required to show "
               "precision)}}")
    a_plain = f"{expected}"
    return q_text, q_latex, a_latex, a_plain


def gen_round_decimal_small():
    """Round a small decimal like 0.004567 to 2 sig figs."""
    leading = rc([2, 3, 4])
    nonzero = "123456789"
    body = "".join(random.choice(nonzero) for _ in range(rc([4, 5, 6])))
    s = "0." + ("0" * leading) + body
    value = float(s)
    n_sf = rc([2, 3])
    if n_sf >= len(body):
        return None

    rounded = round_to_sig_figs(value, n_sf)

    q_latex = f"\\text{{round }} {s} \\text{{ to }} {n_sf} \\text{{ sf}}"
    q_text = (f"Round {s} to {n_sf} significant figures.  Leading zeros do "
              "not count as sig figs — start counting from the first "
              "non-zero digit.")
    a_latex = (f"{s} \\rightarrow {rounded} \\quad ({n_sf} \\text{{ sf}})")
    a_plain = f"{rounded}"
    return q_text, q_latex, a_latex, a_plain


def gen_decimal_to_scientific():
    """Convert plain decimal to scientific notation, preserving sig figs."""
    cases = [
        (340000, 2, "3.4", 5),
        (340000, 3, "3.40", 5),
        (1234, 4, "1.234", 3),
        (0.000567, 3, "5.67", -4),
        (0.0034, 2, "3.4", -3),
        (98765, 3, "9.88", 4),
        (5400000, 2, "5.4", 6),
        (0.00012, 2, "1.2", -4),
        (1500, 2, "1.5", 3),
        (1500, 3, "1.50", 3),
        (60221, 4, "6.022", 4),
        (299792458, 4, "2.998", 8),
    ]
    val, n_sf, mantissa, exp10 = rc(cases)

    q_latex = f"\\text{{convert }} {val} \\text{{ to scientific ({n_sf} sf)}}"
    q_text = (f"Convert {val} to scientific notation with {n_sf} significant "
              "figures.  Move the decimal so exactly one non-zero digit is "
              "to the left of it, then count the shift to determine the "
              "exponent.")
    a_latex = (f"{val} = {fmt_sci_latex(mantissa, exp10)} \\quad "
               f"({n_sf} \\text{{ sf}})")
    a_plain = f"{fmt_sci_plain(mantissa, exp10)} ({n_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_scientific_to_decimal():
    """Convert scientific notation back to plain decimal."""
    cases = [
        ("2.5", -3, "0.0025"),
        ("1.20", 3, "1200"),
        ("3.40", 5, "340000"),
        ("4.56", -4, "0.000456"),
        ("9.0", 2, "900"),
        ("8.314", 0, "8.314"),
        ("6.022", 4, "60220"),
        ("1.602", -4, "0.0001602"),
        ("3.0", 8, "300000000"),
        ("1.5", -2, "0.015"),
    ]
    mantissa, exp10, plain = rc(cases)
    n_sf = count_sig_figs(mantissa)

    q_latex = f"{mantissa} \\times 10^{{{exp10}}} = ?"
    q_text = (f"Convert the scientific notation {mantissa} × 10^{exp10} to "
              f"a plain decimal.  Move the decimal point {abs(exp10)} place(s) "
              f"to the {'right' if exp10 > 0 else 'left'}, padding with "
              "zeros as needed.")
    a_latex = f"{mantissa} \\times 10^{{{exp10}}} = {plain}"
    a_plain = f"{plain} ({n_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_scientific_with_n_sf():
    """Express a given number in scientific notation rounded to n sig figs."""
    int_val = random.randint(1234, 999999)
    n_sf = rc([2, 3, 4])
    if n_sf >= len(str(int_val)):
        return None
    mant_str, exp10 = to_scientific(float(int_val), n_sf)

    q_latex = f"\\text{{express }} {int_val} \\text{{ to }} {n_sf} \\text{{ sf, scientific}}"
    q_text = (f"Express {int_val} in scientific notation rounded to {n_sf} "
              "significant figures.")
    a_latex = (f"{int_val} \\approx {fmt_sci_latex(mant_str, exp10)} "
               f"\\quad ({n_sf} \\text{{ sf}})")
    a_plain = f"{fmt_sci_plain(mant_str, exp10)} ({n_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


# ╔═══════════════════════════════════════════════════════════════════════
# ║  HARD — arithmetic with sig-fig rules
# ╚═══════════════════════════════════════════════════════════════════════

def _decimal_places(s: str) -> int:
    s = s.lstrip("+-")
    if "." in s:
        return len(s.split(".")[1])
    return 0


def gen_add_subtract_dp():
    """Addition / subtraction — answer keeps the FEWEST decimal places."""
    a = round(random.uniform(1, 100), rc([1, 2, 3]))
    b = round(random.uniform(0.1, 50), rc([1, 2, 3]))
    op = rc(["+", "-"])
    raw = a + b if op == "+" else a - b
    if raw <= 0:
        return None

    dp_a = _decimal_places(str(a))
    dp_b = _decimal_places(str(b))
    if dp_a == dp_b:
        return None
    keep_dp = min(dp_a, dp_b)
    rounded = f"{raw:.{keep_dp}f}"

    q_latex = f"{a} {op} {b}"
    q_text = (f"Compute {a} {op} {b} using the decimal-place rule for "
              f"addition/subtraction: the answer keeps the smallest number "
              "of decimal places among the inputs.")
    a_latex = (f"{a} {op} {b} = {raw} \\rightarrow {rounded} \\quad "
               f"\\text{{(rounded to }} {keep_dp} \\text{{ d.p., matching the "
               f"less precise input)}}")
    a_plain = f"{rounded} ({keep_dp} d.p.)"
    return q_text, q_latex, a_latex, a_plain


def gen_subtract_loss_precision():
    """Subtraction of close numbers — large loss of significant figures."""
    cases = [
        ("12.345", "12.34", 0.005, 1),
        ("100.34", "100.31", 0.03, 1),
        ("1.000", "0.998", 0.002, 1),
        ("23.456", "23.450", 0.006, 1),
        ("0.5234", "0.5230", 0.0004, 1),
        ("5.678", "5.674", 0.004, 1),
        ("99.987", "99.983", 0.004, 1),
    ]
    a, b, val, sf = rc(cases)

    q_latex = f"{a} - {b}"
    q_text = (f"Compute {a} − {b} and discuss the loss of significant "
              "figures: when nearly-equal numbers are subtracted, leading "
              "digits cancel, leaving only the trailing differences as "
              "significant.")
    a_latex = (f"{a} - {b} = {val:g}; \\; \\text{{result has only }} {sf} "
               "\\text{{ sig fig — many leading digits cancelled.}}")
    a_plain = f"{val:g} ({sf} sf — large loss of precision)"
    return q_text, q_latex, a_latex, a_plain


def gen_multiply_div_sf():
    """Multiplication or division — answer keeps the FEWEST sig figs."""
    a = round(random.uniform(1.5, 50), rc([2, 3, 4]))
    b = round(random.uniform(1.5, 20), rc([2, 3, 4]))
    op = rc(["×", "÷"])
    raw = a * b if op == "×" else a / b

    sf_a = count_sig_figs(str(a))
    sf_b = count_sig_figs(str(b))
    if sf_a == sf_b:
        return None
    keep_sf = min(sf_a, sf_b)
    rounded = round_to_sig_figs(raw, keep_sf)

    op_latex = "\\times" if op == "×" else "\\div"
    q_latex = f"{a} {op_latex} {b}"
    q_text = (f"Compute {a} {op} {b} using the sig-fig rule for "
              f"multiplication/division: the answer keeps the smallest "
              f"number of significant figures among the inputs.")
    a_latex = (f"{a} {op_latex} {b} = {raw:g} \\rightarrow {rounded} \\quad "
               f"({keep_sf} \\text{{ sf, matching the less precise input)}}")
    a_plain = f"{rounded} ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_divide_with_rounding():
    """Division producing a long decimal — round to fewest sf among inputs."""
    cases = [
        ("100.", "7.0", 100.0/7.0, 2),
        ("1234", "5.6", 1234.0/5.6, 2),
        ("2.50", "1.30", 2.50/1.30, 3),
        ("8.314", "3.0", 8.314/3.0, 2),
        ("123.45", "11", 123.45/11.0, 2),
        ("9.81", "2.0", 9.81/2.0, 2),
        ("760.0", "29.92", 760.0/29.92, 4),
    ]
    a, b, raw, keep_sf = rc(cases)
    rounded = round_to_sig_figs(raw, keep_sf)

    q_latex = f"\\dfrac{{{a}}}{{{b}}}"
    q_text = (f"Compute {a} ÷ {b} and round the result to the correct "
              "number of significant figures using the multiplication/"
              "division rule.")
    a_latex = (f"\\dfrac{{{a}}}{{{b}}} = {raw:.6f} \\rightarrow {rounded} "
               f"\\quad ({keep_sf} \\text{{ sf}})")
    a_plain = f"{rounded} ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_density_calc():
    """Density = m / V — apply division sig-fig rule."""
    masses = ["12.345", "5.62", "100.0", "8.314", "23.45", "1.250", "47.83"]
    vols = ["2.5", "10.00", "5.6", "3.20", "12", "1.50", "8.0"]
    m_str = rc(masses)
    v_str = rc(vols)
    m = float(m_str)
    v = float(v_str)
    if m / v < 0.001 or m / v > 1000:
        return None
    sf_m = count_sig_figs(m_str)
    sf_v = count_sig_figs(v_str)
    if sf_m == sf_v:
        return None
    keep_sf = min(sf_m, sf_v)
    raw = m / v
    rounded = round_to_sig_figs(raw, keep_sf)

    q_latex = (f"\\rho = \\dfrac{{m}}{{V}} = "
               f"\\dfrac{{{m_str} \\text{{ g}}}}{{{v_str} \\text{{ mL}}}}")
    q_text = (f"A sample has mass {m_str} g and volume {v_str} mL.  "
              "Compute the density (g/mL) and report it to the correct "
              "number of significant figures.")
    a_latex = (f"\\rho = \\dfrac{{{m_str}}}{{{v_str}}} = {raw:.6f} "
               f"\\text{{ g/mL}} \\rightarrow {rounded} \\text{{ g/mL}} "
               f"\\quad ({keep_sf} \\text{{ sf}})")
    a_plain = f"ρ = {rounded} g/mL ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_area_volume_calc():
    """Area or volume from L × W (× H) — multiplication sig-fig rule."""
    case = rc(["area", "volume"])
    if case == "area":
        l = rc(["12.34", "5.6", "8.20", "1.25", "47.8", "100.0", "3.14"])
        w = rc(["2.5", "11.2", "0.50", "8.35", "1.20", "100.0", "9.81"])
        if l == w:
            return None
        L = float(l)
        W = float(w)
        sf_l = count_sig_figs(l)
        sf_w = count_sig_figs(w)
        if sf_l == sf_w:
            return None
        keep_sf = min(sf_l, sf_w)
        raw = L * W
        rounded = round_to_sig_figs(raw, keep_sf)
        q_latex = f"A = L \\times W = {l} \\times {w} \\text{{ cm}}^2"
        q_text = (f"A rectangle has length {l} cm and width {w} cm.  "
                  "Compute its area and report to the correct number of "
                  "significant figures.")
        a_latex = (f"A = {l} \\times {w} = {raw:g} \\text{{ cm}}^2 "
                   f"\\rightarrow {rounded} \\text{{ cm}}^2 \\quad "
                   f"({keep_sf} \\text{{ sf}})")
        a_plain = f"A = {rounded} cm² ({keep_sf} sf)"
    else:
        l = rc(["12.34", "5.6", "8.20", "1.25", "10.00"])
        w = rc(["2.5", "0.50", "8.35", "1.20", "3.14"])
        h = rc(["1.25", "0.50", "8.35", "100.0", "9.81"])
        L, W, H = float(l), float(w), float(h)
        sf_l = count_sig_figs(l)
        sf_w = count_sig_figs(w)
        sf_h = count_sig_figs(h)
        keep_sf = min(sf_l, sf_w, sf_h)
        if max(sf_l, sf_w, sf_h) == keep_sf:
            return None
        raw = L * W * H
        rounded = round_to_sig_figs(raw, keep_sf)
        q_latex = f"V = L \\times W \\times H = {l} \\times {w} \\times {h} \\text{{ cm}}^3"
        q_text = (f"A box has dimensions {l} × {w} × {h} cm.  Compute its "
                  "volume and report to the correct number of significant "
                  "figures.")
        a_latex = (f"V = {raw:g} \\text{{ cm}}^3 \\rightarrow {rounded} "
                   f"\\text{{ cm}}^3 \\quad ({keep_sf} \\text{{ sf, "
                   f"matching the least precise input}})")
        a_plain = f"V = {rounded} cm³ ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_speed_or_unit_calc():
    """Speed = d/t — division sig-fig rule, with units."""
    dist = rc(["123.4", "5.62", "1500.0", "8.314", "100.0", "47.8"])
    time_s = rc(["2.5", "11", "60.00", "8.0", "10.0", "12.5"])
    d = float(dist)
    t = float(time_s)
    sf_d = count_sig_figs(dist)
    sf_t = count_sig_figs(time_s)
    if sf_d == sf_t:
        return None
    keep_sf = min(sf_d, sf_t)
    raw = d / t
    rounded = round_to_sig_figs(raw, keep_sf)

    q_latex = f"v = \\dfrac{{d}}{{t}} = \\dfrac{{{dist} \\text{{ m}}}}{{{time_s} \\text{{ s}}}}"
    q_text = (f"A car travels {dist} m in {time_s} s.  Compute the average "
              "speed v = d/t and report to the correct sig-fig precision.")
    a_latex = (f"v = \\dfrac{{{dist}}}{{{time_s}}} = {raw:.4f} \\text{{ m/s}} "
               f"\\rightarrow {rounded} \\text{{ m/s}} \\quad "
               f"({keep_sf} \\text{{ sf}})")
    a_plain = f"v = {rounded} m/s ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


# ╔═══════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — chemistry / physics / IIT / NEET
# ╚═══════════════════════════════════════════════════════════════════════

def gen_exact_vs_measured():
    """Distinguish counted exact numbers vs measured (sig-fig limited)."""
    pool = [
        {"q_latex": (r"\text{There are exactly } 12 \text{ eggs in a dozen.  "
                     r"How many sig figs does the } 12 \text{ contribute "
                     r"when used in a calculation?}"),
         "q_text":  ("Decide whether '12 eggs in a dozen' should be treated "
                     "as an exact (counted) value or a measured value, and "
                     "explain how that affects the sig-fig analysis."),
         "a_latex": (r"\text{Exact (counted, by definition).  Treated as "
                     r"having } \infty \text{ sig figs and does NOT limit "
                     "the precision of any calculation it appears in.}"),
         "a_plain": "Exact — infinite sig figs, does not limit precision."},

        {"q_latex": (r"\text{The class has } 35 \text{ students.  Is this an "
                     r"exact or a measured number?}"),
         "q_text":  ("Decide whether the class size of 35 is exact or "
                     "measured, and explain the implication for sig figs."),
         "a_latex": (r"\text{Counted } \Rightarrow \text{ exact, infinite "
                     r"sig figs.}"),
         "a_plain": "Exact — counted, infinite sig figs."},

        {"q_latex": (r"\text{The mass of a sample is measured as } 12.34 "
                     r"\text{ g.  How many sig figs?}"),
         "q_text":  ("Identify whether the mass 12.34 g is exact or measured "
                     "and state the sig-fig count."),
         "a_latex": (r"\text{Measured } \Rightarrow \text{ 4 sig figs (the "
                     r"precision of the balance limits the figure).}"),
         "a_plain": "Measured — 4 sig figs."},

        {"q_latex": (r"\text{Convert } 12 \text{ inches per foot — exact or "
                     r"measured?}"),
         "q_text":  ("Conversion factor 12 in/ft — is this exact or "
                     "measured?  How does it affect sig-fig analysis?"),
         "a_latex": (r"\text{Defined } \Rightarrow \text{ exact, infinite "
                     r"sig figs (does not limit precision).}"),
         "a_plain": "Exact (definition) — infinite sig figs."},

        {"q_latex": (r"\text{The speed of light } c = 299{,}792{,}458 "
                     r"\text{ m/s.  Sig figs?}"),
         "q_text":  ("Decide whether the speed of light c = 299,792,458 m/s "
                     "is exact or measured, and explain why."),
         "a_latex": (r"\text{Defined exactly since 1983 (SI definition of "
                     r"the metre).  Treated as exact — infinite sig figs.}"),
         "a_plain": "Exact (defined) — infinite sig figs."},

        {"q_latex": (r"\text{The mole: } N_A = 6.02214076 \times 10^{23} "
                     r"\text{ /mol.  Sig figs?}"),
         "q_text":  ("Identify whether Avogadro's number is exact or measured "
                     "as of the 2019 SI redefinition."),
         "a_latex": (r"\text{Exact (SI 2019).  Defined value, infinite sig "
                     "figs.}"),
         "a_plain": "Exact (SI 2019 redefinition) — infinite sig figs."},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


def gen_log_sig_figs():
    """Sig-fig rule for logs: digits after the decimal = sig figs of arg.

    Parametric: pick a mantissa, exponent, and round log(value) to match
    the sig-fig count of the input.
    """
    nonzero = "123456789"
    n_sf = rc([2, 3, 4])
    mant_int = random.choice(nonzero)
    mant_frac = "".join(random.choice("0123456789") for _ in range(n_sf - 1))
    if rc([True, False]) and mant_frac and mant_frac[-1] != "0":
        mant_frac = mant_frac[:-1] + "0"
    mantissa = float(f"{mant_int}.{mant_frac}") if mant_frac else float(mant_int)
    mantissa_str = f"{mant_int}.{mant_frac}" if mant_frac else mant_int
    exp10 = rc([-19, -10, -8, -5, -4, -3, -2, 0, 2, 3, 5, 8, 12, 18, 23])
    if exp10 == 0:
        value = mantissa
        arg_pretty = mantissa_str
        arg_latex = mantissa_str
    else:
        value = mantissa * (10 ** exp10)
        arg_pretty = f"{mantissa_str} × 10^{exp10}"
        arg_latex = f"{mantissa_str} \\times 10^{{{exp10}}}"

    log_val = math.log10(value)
    log_str = f"{log_val:.{n_sf}f}"
    why = (f"Mantissa has {n_sf} sf → keep {n_sf} digit{'s' if n_sf != 1 else ''} "
           "after the decimal in log.")

    q_latex = f"\\log({arg_latex})"
    q_text = (f"Compute log({arg_pretty}) and apply the sig-fig rule for "
              "logarithms: ONLY the digits after the decimal point in the "
              "result count as sig figs (the characteristic — digits before "
              "the decimal — depends on the magnitude, not the precision of "
              "the argument).")
    a_latex = (f"\\log({arg_latex}) = {log_str}; \\quad \\text{{rule: }} "
               f"{why} \\; \\Rightarrow {n_sf} \\text{{ digit"
               f"{'s' if n_sf != 1 else ''} after the decimal.}}")
    a_plain = f"{log_str} ({n_sf} digit{'s' if n_sf != 1 else ''} after decimal — log sig-fig rule)"
    return q_text, q_latex, a_latex, a_plain


def gen_molarity_calc():
    """Multi-step: g → mol → M, with sig-fig tracking through the chain."""
    pool = [
        {"compound": "NaCl",  "MW": "58.44", "sf_mw": 4,
         "g":   "5.0", "sf_g": 2,   "vol_L": "0.250", "sf_v": 3,
         "moles": "0.0856", "M": "0.34"},
        {"compound": "KCl",  "MW": "74.55", "sf_mw": 4,
         "g":   "12.34", "sf_g": 4, "vol_L": "0.500", "sf_v": 3,
         "moles": "0.1655", "M": "0.331"},
        {"compound": "H₂SO₄", "MW": "98.08", "sf_mw": 4,
         "g":   "9.806", "sf_g": 4, "vol_L": "1.000", "sf_v": 4,
         "moles": "0.1000", "M": "0.1000"},
        {"compound": "NaOH", "MW": "40.00", "sf_mw": 4,
         "g":   "8.00", "sf_g": 3,  "vol_L": "0.250", "sf_v": 3,
         "moles": "0.200", "M": "0.800"},
        {"compound": "CaCl₂", "MW": "110.98", "sf_mw": 5,
         "g":   "23.4", "sf_g": 3, "vol_L": "0.50", "sf_v": 2,
         "moles": "0.211", "M": "0.42"},
    ]
    p = rc(pool)
    keep_sf = min(p["sf_g"], p["sf_mw"], p["sf_v"])

    q_latex = (f"M = \\dfrac{{n}}{{V}} = "
               f"\\dfrac{{m / \\text{{MW}}}}{{V}}")
    q_text = (f"Dissolve {p['g']} g of {p['compound']} (MW = {p['MW']} g/mol) "
              f"in enough water to make {p['vol_L']} L of solution.  "
              "Compute the molarity M = n/V and report with the correct "
              "number of significant figures (the chain of operations means "
              "the answer is limited by the LEAST precise input).")
    a_latex = (f"n = \\dfrac{{{p['g']}}}{{{p['MW']}}} = {p['moles']} "
               f"\\text{{ mol}}; \\quad "
               f"M = \\dfrac{{{p['moles']}}}{{{p['vol_L']}}} = {p['M']} "
               f"\\text{{ M}} \\quad ({keep_sf} \\text{{ sf}})")
    a_plain = f"M = {p['M']} mol/L ({keep_sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_multistep_chem():
    """Multi-step chemistry/physics calc with sig-fig tracking."""
    pool = [
        {
            "q_latex": (r"\text{A } 12.34 \text{ g sample of metal is heated; "
                        r"its volume rises from } 25.0 \text{ to } 28.5 "
                        r"\text{ mL.  Find the density.}"),
            "q_text":  ("A metal sample with mass 12.34 g causes a water-"
                        "level rise from 25.0 mL to 28.5 mL.  Find ΔV, then "
                        "compute the density and round per sig-fig rules."),
            "a_latex": (r"\Delta V = 28.5 - 25.0 = 3.5 \text{ mL (1 d.p., "
                        r"2 sf); } \rho = \dfrac{12.34}{3.5} = 3.5 "
                        r"\text{ g/mL} \quad (\text{2 sf, limited by } "
                        r"\Delta V)."),
            "a_plain": "ρ = 3.5 g/mL (2 sf, limited by ΔV = 3.5 mL)"
        },
        {
            "q_latex": (r"\text{Compute } (1.25 \times 10^3)(2.0 \times 10^{-2}) "
                        r" / (3.50 \times 10^1) \text{ with proper sig figs.}"),
            "q_text":  ("Evaluate (1.25×10³)(2.0×10⁻²) / (3.50×10¹) and "
                        "report to the correct sig-fig precision.  All "
                        "operations are × or ÷, so the answer keeps the "
                        "fewest sig figs among the inputs."),
            "a_latex": (r"\text{numerator: } 1.25 \times 2.0 \times 10^{1} "
                        r"= 2.5 \times 10^{1}; \; "
                        r"\text{result: } \dfrac{2.5 \times 10^1}{3.50 "
                        r"\times 10^1} = 0.71 \quad (\text{2 sf, limited "
                        r"by } 2.0)."),
            "a_plain": "0.71 (2 sf, limited by 2.0×10⁻²)"
        },
        {
            "q_latex": (r"\text{Compute the perimeter and area of a "
                        r"rectangle: } 12.34 \text{ cm} \times 0.50 "
                        r"\text{ cm.  Apply both sig-fig rules.}"),
            "q_text":  ("A rectangle is 12.34 cm by 0.50 cm.  Compute the "
                        "perimeter (use the addition decimal-place rule) "
                        "AND the area (use the multiplication sig-fig "
                        "rule).  Report each to the correct precision."),
            "a_latex": (r"P = 2(12.34 + 0.50) = 2 \cdot 12.84 = 25.68 "
                        r"\rightarrow 25.68 \text{ cm (2 d.p.); } "
                        r"A = 12.34 \cdot 0.50 = 6.17 \rightarrow 6.2 "
                        r"\text{ cm}^2 \quad (\text{2 sf}, \text{ limited "
                        r"by } 0.50)."),
            "a_plain": "P = 25.68 cm (2 dp); A = 6.2 cm² (2 sf)"
        },
        {
            "q_latex": (r"\text{Speed of sound: } v = \sqrt{1.40 \cdot 8.314 "
                        r"\cdot 298 / 0.029}.  \text{ Find } v \text{ to "
                        r"correct sig figs.}"),
            "q_text":  ("Compute the speed of sound v = √(γRT/M) with "
                        "γ = 1.40, R = 8.314 J/(mol·K), T = 298 K, "
                        "M = 0.029 kg/mol.  Report v to the correct sig-fig "
                        "precision."),
            "a_latex": (r"v = \sqrt{(1.40)(8.314)(298)/0.029} \approx "
                        r"\sqrt{1.197 \times 10^5} \approx 346 \text{ m/s} "
                        r"\quad (\text{3 sf, limited by } 298)."),
            "a_plain": "v ≈ 346 m/s (3 sf, limited by T = 298 K)"
        },
        {
            "q_latex": (r"\text{Find the pH of a } 1.5 \times 10^{-3} \text{ "
                        r"M HCl solution with correct sig figs.}"),
            "q_text":  ("Compute the pH = -log[H⁺] of a 1.5×10⁻³ M HCl "
                        "solution.  Apply the LOG sig-fig rule: digits "
                        "after the decimal in the pH match the sig figs "
                        "of the concentration."),
            "a_latex": (r"\text{pH} = -\log(1.5 \times 10^{-3}) = 2.82 "
                        r"\quad (\text{2 sf in concentration} \Rightarrow "
                        r"2 \text{ digits after decimal in pH}).") ,
            "a_plain": "pH = 2.82 (2 digits after decimal — log sig-fig rule)"
        },
        {
            "q_latex": (r"\text{An object accelerates from } 5.00 \text{ to } "
                        r"15.34 \text{ m/s in } 2.0 \text{ s.  Find } a."),
            "q_text":  ("An object's velocity changes from 5.00 m/s to "
                        "15.34 m/s in 2.0 s.  Compute Δv (subtraction → "
                        "decimal-place rule) and a = Δv/Δt (division → "
                        "sig-fig rule).  Report both."),
            "a_latex": (r"\Delta v = 15.34 - 5.00 = 10.34 \text{ m/s} "
                        r"\;(2 \text{ d.p., 4 sf}); \; "
                        r"a = \dfrac{10.34}{2.0} = 5.2 \text{ m/s}^2 \quad "
                        r"(\text{2 sf, limited by } 2.0)."),
            "a_plain": "Δv = 10.34 m/s (4 sf); a = 5.2 m/s² (2 sf)"
        },
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


def gen_ph_calc():
    """pH = -log[H+] — applies the log sig-fig rule (digits after decimal
    in pH equal sig figs in concentration).  Common scholar pH problem."""
    nonzero = "123456789"
    n_sf = rc([2, 3])
    mant_int = random.choice(nonzero)
    mant_frac = "".join(random.choice("0123456789") for _ in range(n_sf - 1))
    mant_str = f"{mant_int}.{mant_frac}" if mant_frac else mant_int
    mant = float(mant_str)
    exp10 = rc([-1, -2, -3, -4, -5, -6, -7])
    conc = mant * (10 ** exp10)
    ph = -math.log10(conc)
    ph_str = f"{ph:.{n_sf}f}"
    species = rc(["HCl", "HNO3", "HClO4", "HBr", "HI"])

    q_latex = (f"\\text{{[H}}^+\\text{{]}} = {mant_str} \\times 10^{{{exp10}}} "
               f"\\text{{ M}}; \\; \\text{{find pH}}")
    q_text = (f"A {species} solution has [H⁺] = {mant_str} × 10^{exp10} M.  "
              "Compute the pH = -log[H⁺] and report it with the correct "
              "number of significant figures.  Apply the log sig-fig rule: "
              "the number of digits after the decimal in the pH equals the "
              "sig-fig count of the concentration.")
    a_latex = (f"\\text{{pH}} = -\\log({mant_str} \\times 10^{{{exp10}}}) "
               f"= {ph_str} \\quad ({n_sf} \\text{{ digit"
               f"{'s' if n_sf != 1 else ''} after the decimal, matching "
               f"{n_sf} sf in concentration}})")
    a_plain = f"pH = {ph_str} ({n_sf} digit{'s' if n_sf != 1 else ''} after decimal — log rule)"
    return q_text, q_latex, a_latex, a_plain


def gen_unit_conversion_sf():
    """Unit conversion preserves sig figs of the measured value (the
    conversion factor is exact)."""
    cases = [
        ("12.34 cm", "m", 0.1234, "12.34 cm × (1 m / 100 cm) = 0.1234 m", 4),
        ("5.6 km", "m", 5600, "5.6 km × (1000 m / 1 km) = 5600 m → 5.6 × 10³ m", 2),
        ("0.0250 L", "mL", 25.0, "0.0250 L × (1000 mL / 1 L) = 25.0 mL", 3),
        ("750. mL", "L", 0.750, "750. mL × (1 L / 1000 mL) = 0.750 L", 3),
        ("8.314 J/(mol·K)", "kJ/(mol·K)", 0.008314,
         "8.314 J × (1 kJ / 1000 J) = 0.008314 kJ/(mol·K)", 4),
        ("1.50 kg", "g", 1500, "1.50 kg × (1000 g / 1 kg) = 1500 g → 1.50 × 10³ g", 3),
        ("3.00 × 10⁸ m/s", "km/s", 300000, "3.00 × 10⁸ m × (1 km / 1000 m) = 3.00 × 10⁵ km/s", 3),
        ("0.5000 mol", "mmol", 500.0, "0.5000 mol × (1000 mmol / 1 mol) = 500.0 mmol", 4),
    ]
    src, target, _val, work, sf = rc(cases)

    q_latex = f"\\text{{convert }} {src} \\text{{ to }} {target}"
    q_text = (f"Convert {src} to {target}, preserving the correct number of "
              "significant figures.  Note that exact conversion factors "
              "(e.g. 1 m = 100 cm by definition) do NOT limit the precision "
              "— only the measured value's sig figs do.")
    a_latex = f"{work} \\quad ({sf} \\text{{ sf preserved}})"
    a_plain = f"{work.split('=')[-1].strip()} ({sf} sf)"
    return q_text, q_latex, a_latex, a_plain


def gen_relative_uncertainty():
    """Propagate relative uncertainty through × or ÷."""
    cases = [
        ("m = 12.34 ± 0.05 g", "V = 5.6 ± 0.1 mL", "ρ = m/V",
         0.41, 2.2, 0.05/12.34, 0.1/5.6,
         "δρ/ρ = δm/m + δV/V = 0.0041 + 0.0179 = 0.0220 (≈ 2.2%); "
         "ρ = 12.34/5.6 = 2.2 g/mL ± 0.05 g/mL (1 d.p., limited by V)."),

        ("L = 1.25 ± 0.01 m", "W = 0.50 ± 0.01 m", "A = L·W",
         2.8, 5.0, 0.01/1.25, 0.01/0.50,
         "δA/A = 0.008 + 0.020 = 0.028 (2.8%); A = 0.625 m² → 0.63 m² ± 0.02 m²."),

        ("d = 100.0 ± 0.5 m", "t = 9.85 ± 0.05 s", "v = d/t",
         1.0, 1.0, 0.5/100.0, 0.05/9.85,
         "δv/v = 0.005 + 0.005 = 0.010 (1.0%); v = 10.15 m/s → 10.2 m/s ± 0.1 m/s."),
    ]
    case = rc(cases)
    a, b, formula, _pct1, _pct2, frac1, frac2, summary = case
    pct = (frac1 + frac2) * 100

    q_latex = f"\\text{{{a}}}; \\; \\text{{{b}}}; \\; {formula}"
    q_text = (f"Given {a} and {b}, compute {formula} and propagate the "
              "relative uncertainty: for multiplication or division, "
              "δQ/Q ≈ δa/a + δb/b.  Report the result with absolute and "
              "percent uncertainty.")
    a_latex = (f"\\delta_a/a = {frac1:.4f}, \\; \\delta_b/b = {frac2:.4f}; "
               f"\\; \\text{{combined}} \\approx {pct:.1f}\\%. \\; "
               f"\\text{{Final: }} {summary.split(';')[-1].strip()}")
    a_plain = f"{summary}"
    return q_text, q_latex, a_latex, a_plain


# ╔═══════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═══════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "count_no_zeros",
        "count_with_decimal_zeros",
        "count_leading_zeros",
        "count_trapped_zeros",
        "count_scientific_notation",
        "count_ambiguous",
        "identify_more_precise",
    ],
    "medium": [
        "round_to_n_sf",
        "round_with_carry",
        "round_decimal_small",
        "decimal_to_scientific",
        "scientific_to_decimal",
        "scientific_with_n_sf",
    ],
    "hard": [
        "add_subtract_dp",
        "subtract_loss_precision",
        "multiply_div_sf",
        "divide_with_rounding",
        "density_calc",
        "area_volume_calc",
        "speed_or_unit_calc",
    ],
    "scholar": [
        "exact_vs_measured",
        "log_sig_figs",
        "ph_calc",
        "unit_conversion_sf",
        "molarity_calc",
        "multistep_chem",
        "relative_uncertainty",
    ],
}


def call_generator(q_type):
    generators = {
        "count_no_zeros":            gen_count_no_zeros,
        "count_with_decimal_zeros":  gen_count_with_decimal_zeros,
        "count_leading_zeros":       gen_count_leading_zeros,
        "count_trapped_zeros":       gen_count_trapped_zeros,
        "count_scientific_notation": gen_count_scientific_notation,
        "count_ambiguous":           gen_count_ambiguous,
        "identify_more_precise":     gen_identify_more_precise,
        "round_to_n_sf":             gen_round_to_n_sf,
        "round_with_carry":          gen_round_with_carry,
        "round_decimal_small":       gen_round_decimal_small,
        "decimal_to_scientific":     gen_decimal_to_scientific,
        "scientific_to_decimal":     gen_scientific_to_decimal,
        "scientific_with_n_sf":      gen_scientific_with_n_sf,
        "add_subtract_dp":           gen_add_subtract_dp,
        "subtract_loss_precision":   gen_subtract_loss_precision,
        "multiply_div_sf":           gen_multiply_div_sf,
        "divide_with_rounding":      gen_divide_with_rounding,
        "density_calc":              gen_density_calc,
        "area_volume_calc":          gen_area_volume_calc,
        "speed_or_unit_calc":        gen_speed_or_unit_calc,
        "exact_vs_measured":         gen_exact_vs_measured,
        "log_sig_figs":              gen_log_sig_figs,
        "ph_calc":                   gen_ph_calc,
        "unit_conversion_sf":        gen_unit_conversion_sf,
        "molarity_calc":             gen_molarity_calc,
        "multistep_chem":            gen_multistep_chem,
        "relative_uncertainty":      gen_relative_uncertainty,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain = res
    return {"q_text": q_text, "q_latex": q_latex,
            "ans_latex": ans_latex, "ans_plain": ans_plain}


def generate_sigfig_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.28:
            diff = "basic"
        elif rv < 0.56:
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

        dup = data["q_latex"] + "::" + data["q_text"][:60]
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

    qs = generate_sigfig_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "numerics")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "significant_figures.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Significant Figures & Scientific Notation",
            "description": ("NCERT Class 8 (numbers, scientific notation), "
                            "Class 11 chemistry & physics (significant "
                            "figures in measurements, error analysis), "
                            "and JEE/NEET-style multi-step lab problems.  "
                            "Covers all 5 sig-fig rules, decimal-place rule "
                            "for +/-, sig-fig rule for ×/÷, log sig-fig "
                            "rule, scientific notation conversion, and "
                            "uncertainty propagation."),
            "questions": qs,
        }, f, separators=(",", ":"))

    print(f"Generated {len(qs)} sig-fig problems → {out_path}")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        print(f"  {t:35s}  {c:>4}")
