#!/usr/bin/env python3
"""
generate_percentage.py — SymPy-verified percentage worksheet generator.

Aligned with NCERT Class 7 Ch 7 (Comparing Quantities — percentages,
profit and loss, simple interest), Class 8 Ch 8 (Comparing Quantities —
discount, tax, compound interest, percentage change), plus general
commercial-math problems and JEE-flavoured successive-percentage classics.

Output: src/main/webapp/worksheet/math/algebra/percentages.json

Run:
    python3 generate_percentage.py [N]      # default 1500
    python3 generate_worksheet_metadata.py  # refresh global index

Question types (22 total):

  basic (NCERT Class 6-7):
    pct_of_simple              25% of 200 = 50
    what_pct                   45 is what % of 180?
    pct_to_decimal_fraction    30% → 0.30 = 3/10
    decimal_to_pct             0.65 → 65%
    fraction_to_pct            3/4 → 75%
    pct_of_quantity_word       "5% of 200 students" framing

  medium (NCERT Class 7-8):
    increase_by                500 + 15% = 575
    decrease_by                800 − 20% = 640
    pct_change                 120 → 150 = +25%
    reverse_pct                $75 after 25% off → original $100
    discount_calc              MRP + discount% → SP
    tax_calc                   SP + tax% → final
    profit_loss_pct            CP, SP → profit/loss %
    ratio_to_pct               3:5 → 60% : 40%

  hard (NCERT Class 8 + commercial):
    chained_pct                start + multiple ± % steps
    compound_interest          A = P(1+r/100)^t  (NCERT Class 8 Ch 8)
    successive_discount        20% off then 10% off — single equivalent
    population_change          population over n years
    partnership_profit_share   ratio + profit split (NCERT Class 8)
    markup_markdown            store/retail commercial math

  scholar (JEE-flavour / commercial classics):
    successive_pct_proof       prove (1+a)(1+b) ≠ 1+a+b
    ncert_classic_word         multi-step NCERT word problem
"""

from __future__ import annotations

import sympy as sp
import random
import json
import os
import sys
from collections import Counter

SMALL_INT     = list(range(1, 10))


def rc(pool):
    return random.choice(pool)


def fmt_amount(value, currency=""):
    """Format an amount cleanly: integer if whole, else 2 decimals."""
    try:
        v = float(value)
    except Exception:
        return str(value)
    if abs(v - round(v)) < 1e-9:
        return f"{currency}{int(round(v))}"
    return f"{currency}{v:.2f}"


# ╔═════════════════════════════════════════════════════════════════════
# ║  BASIC — NCERT Class 6-7
# ╚═════════════════════════════════════════════════════════════════════

def gen_pct_of_simple():
    """X% of Y = (X/100) · Y, with clean integer answer."""
    pct = rc([10, 12, 15, 20, 25, 30, 40, 50, 60, 75, 80])
    base = rc([20, 40, 50, 60, 80, 100, 120, 150, 200, 250, 400, 500, 1000])
    if (pct * base) % 100 != 0:
        return None
    ans = pct * base // 100

    q_latex = f"{pct}\\% \\text{{ of }} {base}"
    q_text  = f"Find {pct}% of {base}.  Use Result = (X/100) · Y."
    a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {base} = {ans}"
    a_plain = f"({pct}/100) × {base} = {ans}"
    return q_text, q_latex, a_latex, a_plain


def gen_what_pct():
    """X is what percent of Y?  X / Y · 100"""
    # Plant clean integer percent answer
    pct = rc([10, 15, 20, 25, 30, 40, 50, 60, 75, 80])
    base = rc([20, 50, 80, 100, 120, 160, 200, 250, 400, 500])
    if (pct * base) % 100 != 0:
        return None
    x_v = pct * base // 100

    q_latex = f"{x_v} \\text{{ is what \\% of }} {base}?"
    q_text  = (f"What percent is {x_v} of {base}?  "
               "Use Percent = (X / Y) · 100.")
    a_latex = f"\\dfrac{{{x_v}}}{{{base}}} \\times 100 = {pct}\\%"
    a_plain = f"{x_v}/{base} × 100 = {pct}%"
    return q_text, q_latex, a_latex, a_plain


def gen_pct_to_decimal_fraction():
    """30% → 0.30 = 3/10"""
    pct = rc([5, 10, 12, 15, 20, 25, 30, 40, 50, 60, 75, 80, 90, 125, 150])
    decimal = sp.Rational(pct, 100)
    fraction = sp.Rational(pct, 100)
    fraction_simplified = sp.nsimplify(fraction)

    q_latex = f"{pct}\\%"
    q_text  = (f"Express {pct}% as both a decimal and a fraction in lowest "
               "terms.")
    dec_str = f"{float(decimal):g}"
    a_latex = (f"\\text{{decimal}} = {dec_str}, \\quad "
               f"\\text{{fraction}} = {sp.latex(fraction_simplified)}")
    a_plain = f"decimal = {dec_str}, fraction = {fraction_simplified}"
    return q_text, q_latex, a_latex, a_plain


def gen_decimal_to_pct():
    """0.65 → 65%"""
    decimal_pool = [0.05, 0.1, 0.12, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5, 0.6,
                    0.65, 0.75, 0.8, 0.85, 0.9, 1.0, 1.25, 1.5, 2.0]
    decimal = rc(decimal_pool)
    pct = decimal * 100
    pct_str = str(int(pct)) if pct == int(pct) else f"{pct:.2f}"

    q_latex = f"{decimal}"
    q_text  = (f"Express the decimal {decimal} as a percentage.")
    a_latex = f"{decimal} \\times 100 = {pct_str}\\%"
    a_plain = f"{decimal} × 100 = {pct_str}%"
    return q_text, q_latex, a_latex, a_plain


def gen_fraction_to_pct():
    """3/4 → 75%"""
    pool = [
        (sp.Rational(1, 2), 50),  (sp.Rational(1, 4), 25),
        (sp.Rational(3, 4), 75),  (sp.Rational(1, 5), 20),
        (sp.Rational(2, 5), 40),  (sp.Rational(3, 5), 60),
        (sp.Rational(4, 5), 80),  (sp.Rational(1, 8), 12.5),
        (sp.Rational(3, 8), 37.5),(sp.Rational(5, 8), 62.5),
        (sp.Rational(1, 10), 10), (sp.Rational(7, 10), 70),
        (sp.Rational(9, 10), 90), (sp.Rational(1, 20), 5),
    ]
    frac, pct = rc(pool)
    pct_str = str(int(pct)) if pct == int(pct) else f"{pct}"

    q_latex = sp.latex(frac)
    q_text  = (f"Express the fraction as a percentage.")
    a_latex = f"{sp.latex(frac)} \\times 100 = {pct_str}\\%"
    a_plain = f"{frac} × 100 = {pct_str}%"
    return q_text, q_latex, a_latex, a_plain


def gen_pct_of_quantity_word():
    """'5% of 200 students' word framing — NCERT classic."""
    case = rc(["students_class", "marks_exam", "voters_election",
               "salt_solution", "rupees_savings", "fruits_basket"])

    if case == "students_class":
        n = rc([200, 240, 250, 300, 360, 400, 500])
        pct = rc([5, 8, 10, 15, 20, 25, 30, 40])
        if (pct * n) % 100 != 0:
            return None
        ans = pct * n // 100
        category = rc(["girls", "boys", "students who passed",
                       "students who joined the science club"])
        q_latex = f"{pct}\\% \\text{{ of }} {n} \\text{{ students}}"
        q_text  = (f"In a school of {n} students, {pct}% are {category}. "
                   f"How many students are {category}?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {n} = {ans}"
        a_plain = f"{ans} students"
        return q_text, q_latex, a_latex, a_plain

    elif case == "marks_exam":
        total = rc([200, 250, 300, 400, 500, 600])
        pct = rc([35, 40, 45, 60, 65, 70, 75, 80])
        if (pct * total) % 100 != 0:
            return None
        marks = pct * total // 100
        q_latex = f"{pct}\\% \\text{{ of }} {total} \\text{{ marks}}"
        q_text  = (f"A student scored {pct}% in an exam with maximum marks "
                   f"{total}.  How many marks did the student score?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {total} = {marks}"
        a_plain = f"{marks} marks"
        return q_text, q_latex, a_latex, a_plain

    elif case == "voters_election":
        n = rc([5000, 8000, 10000, 12000, 25000])
        pct = rc([45, 52, 55, 60, 65, 70])
        if (pct * n) % 100 != 0:
            return None
        votes = pct * n // 100
        q_latex = f"{pct}\\% \\text{{ of }} {n}"
        q_text  = (f"In an election, a candidate received {pct}% of the "
                   f"{n:,} votes cast.  How many votes did the candidate "
                   "receive?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {n} = {votes:,}"
        a_plain = f"{votes:,} votes"
        return q_text, q_latex, a_latex, a_plain

    elif case == "salt_solution":
        sol_kg = rc([200, 250, 400, 500, 800])
        pct = rc([5, 8, 10, 12, 15, 20])
        if (pct * sol_kg) % 100 != 0:
            return None
        salt = pct * sol_kg // 100
        q_latex = f"{pct}\\% \\text{{ of }} {sol_kg}\\text{{ g}}"
        q_text  = (f"A solution of {sol_kg} grams contains {pct}% salt.  "
                   "How many grams of salt are in the solution?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {sol_kg} = {salt} \\text{{ g}}"
        a_plain = f"{salt} g of salt"
        return q_text, q_latex, a_latex, a_plain

    elif case == "rupees_savings":
        amount = rc([20000, 25000, 40000, 50000, 75000, 100000])
        pct = rc([10, 12, 15, 20, 25, 30])
        if (pct * amount) % 100 != 0:
            return None
        saved = pct * amount // 100
        q_latex = f"{pct}\\% \\text{{ of }} \\text{{₹}}{amount:,}"
        q_text  = (f"A person earns ₹{amount:,} per month and saves {pct}% "
                   "of it.  How much does the person save each month?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {amount} = ₹{saved:,}"
        a_plain = f"₹{saved:,}"
        return q_text, q_latex, a_latex, a_plain

    else:  # fruits_basket
        n = rc([60, 80, 100, 120, 150, 200])
        pct = rc([15, 20, 25, 30, 40])
        if (pct * n) % 100 != 0:
            return None
        rotten = pct * n // 100
        q_latex = f"{pct}\\% \\text{{ of }} {n} \\text{{ fruits}}"
        q_text  = (f"A basket has {n} fruits, of which {pct}% are rotten.  "
                   "How many rotten fruits are there?")
        a_latex = f"\\dfrac{{{pct}}}{{100}} \\times {n} = {rotten}"
        a_plain = f"{rotten} fruits"
        return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  MEDIUM — NCERT Class 7-8
# ╚═════════════════════════════════════════════════════════════════════

def gen_increase_by():
    """Y + X% — find new value."""
    pct = rc([5, 8, 10, 12, 15, 20, 25, 30, 40, 50])
    base = rc([200, 250, 400, 500, 750, 800, 1000, 1500, 2000])
    if (pct * base) % 100 != 0:
        return None
    increase = pct * base // 100
    new_val = base + increase

    q_latex = f"{base} + {pct}\\%"
    q_text  = (f"Increase {base} by {pct}%.  Compute the new value using "
               "Result = Y · (1 + X/100).")
    a_latex = (f"{base} \\times \\left(1 + \\dfrac{{{pct}}}{{100}}\\right) "
               f"= {base} + {increase} = {new_val}")
    a_plain = f"{base} + {increase} = {new_val}"
    return q_text, q_latex, a_latex, a_plain


def gen_decrease_by():
    """Y − X% — find new value."""
    pct = rc([5, 8, 10, 12, 15, 20, 25, 30, 40])
    base = rc([200, 250, 400, 500, 750, 800, 1000, 1500, 2000])
    if (pct * base) % 100 != 0:
        return None
    decrease = pct * base // 100
    new_val = base - decrease

    q_latex = f"{base} - {pct}\\%"
    q_text  = (f"Decrease {base} by {pct}%.  Compute the new value using "
               "Result = Y · (1 − X/100).")
    a_latex = (f"{base} \\times \\left(1 - \\dfrac{{{pct}}}{{100}}\\right) "
               f"= {base} - {decrease} = {new_val}")
    a_plain = f"{base} - {decrease} = {new_val}"
    return q_text, q_latex, a_latex, a_plain


def gen_pct_change():
    """A → B — percentage change.  Sign indicates increase or decrease."""
    pool = [
        (100, 125),  (120, 150),  (200, 250),  (250, 300),
        (400, 500),  (200, 240),  (500, 750),  (1000, 1200),
        # decreases
        (500, 400),  (200, 160),  (1000, 750),  (250, 200),
        (400, 320),  (300, 270),  (160, 100),
    ]
    a_v, b_v = rc(pool)
    change = b_v - a_v
    pct_change = sp.Rational(change * 100, a_v)
    pct_change_simp = sp.nsimplify(pct_change)
    direction = "increase" if change > 0 else "decrease"

    q_latex = f"{a_v} \\to {b_v}"
    q_text  = (f"Calculate the percentage change going from {a_v} to {b_v}. "
               "Use  % change = ((B − A) / A) · 100.")
    a_latex = (f"\\dfrac{{{b_v} - {a_v}}}{{{a_v}}} \\times 100 = "
               f"{sp.latex(pct_change_simp)}\\% \\text{{ ({direction})}}")
    a_plain = f"{pct_change_simp}% {direction}"
    return q_text, q_latex, a_latex, a_plain


def gen_reverse_pct():
    """Final price + discount % → find original price."""
    orig = rc([100, 200, 300, 400, 500, 800, 1000, 1500, 2000, 5000])
    disc = rc([10, 15, 20, 25, 30, 40, 50])
    final = orig * (100 - disc) // 100
    if final * 100 % (100 - disc) != 0:
        return None  # ensure clean

    q_latex = (f"\\text{{Final price}} = ₹{final}, \\quad "
               f"\\text{{discount}} = {disc}\\%; \\quad "
               "\\text{{find original price}}")
    q_text  = (f"After a {disc}% discount, an item is sold for ₹{final}. "
               "Find the original price.  Use Original = Final / (1 − D/100).")
    a_latex = (f"\\text{{Original}} = \\dfrac{{{final}}}{{1 - {disc}/100}} "
               f"= \\dfrac{{{final}}}{{{(100 - disc) / 100:g}}} = ₹{orig}")
    a_plain = f"original = ₹{orig}"
    return q_text, q_latex, a_latex, a_plain


def gen_discount_calc():
    """MRP + discount % → SP (sale price)."""
    mrp = rc([500, 800, 1000, 1200, 1500, 2000, 2500, 4000, 5000])
    disc = rc([5, 10, 15, 20, 25, 30, 40])
    if (mrp * disc) % 100 != 0:
        return None
    saving = mrp * disc // 100
    sp_price = mrp - saving

    q_latex = (f"\\text{{MRP}} = ₹{mrp}, \\quad \\text{{discount}} = {disc}\\%")
    q_text  = (f"An item has a marked price of ₹{mrp:,} and a discount of "
               f"{disc}%.  Find the discount amount and the selling price (SP).")
    a_latex = (f"\\text{{Discount}} = \\dfrac{{{disc}}}{{100}} \\times {mrp} "
               f"= ₹{saving}; \\quad \\text{{SP}} = {mrp} - {saving} = ₹{sp_price}")
    a_plain = f"discount = ₹{saving}, SP = ₹{sp_price}"
    return q_text, q_latex, a_latex, a_plain


def gen_tax_calc():
    """SP + tax % → final amount."""
    sp_price = rc([500, 800, 1000, 1200, 1500, 2000, 2500])
    tax = rc([5, 8, 10, 12, 15, 18])
    if (sp_price * tax) % 100 != 0:
        return None
    tax_amount = sp_price * tax // 100
    total = sp_price + tax_amount

    q_latex = (f"\\text{{SP}} = ₹{sp_price}, \\quad \\text{{GST/tax}} = {tax}\\%")
    q_text  = (f"An item has a selling price of ₹{sp_price:,}.  Adding a "
               f"{tax}% GST/tax, find the total amount paid by the customer.")
    a_latex = (f"\\text{{Tax}} = \\dfrac{{{tax}}}{{100}} \\times {sp_price} "
               f"= ₹{tax_amount}; \\quad \\text{{Total}} = "
               f"{sp_price} + {tax_amount} = ₹{total}")
    a_plain = f"tax = ₹{tax_amount}, total = ₹{total}"
    return q_text, q_latex, a_latex, a_plain


def gen_profit_loss_pct():
    """Cost + sell → profit/loss %."""
    cp = rc([200, 250, 400, 500, 800, 1000, 1500, 2000, 5000])
    pct = rc([5, 10, 12, 15, 20, 25, 30, 40, 50])
    is_profit = rc([True, False])
    if (cp * pct) % 100 != 0:
        return None
    delta = cp * pct // 100
    sp_price = cp + delta if is_profit else cp - delta

    q_latex = (f"\\text{{CP}} = ₹{cp}, \\quad \\text{{SP}} = ₹{sp_price}")
    q_text  = (f"An article was bought for ₹{cp:,} and sold for ₹{sp_price:,}. "
               "Find the profit (or loss) percentage.  Use "
               "Profit% = (Profit / CP) · 100.")
    if is_profit:
        a_latex = (f"\\text{{Profit}} = ₹{delta}; \\quad "
                   f"\\text{{Profit\\%}} = \\dfrac{{{delta}}}{{{cp}}} "
                   f"\\times 100 = {pct}\\%")
        a_plain = f"profit = ₹{delta}, profit% = {pct}%"
    else:
        a_latex = (f"\\text{{Loss}} = ₹{delta}; \\quad "
                   f"\\text{{Loss\\%}} = \\dfrac{{{delta}}}{{{cp}}} "
                   f"\\times 100 = {pct}\\%")
        a_plain = f"loss = ₹{delta}, loss% = {pct}%"
    return q_text, q_latex, a_latex, a_plain


def gen_ratio_to_pct():
    """3:5 → 60% : 40%   (or 3-part ratios for older NCERT problems).

    Only emit ratios whose totals divide 100 cleanly so percentages stay
    integer / one-decimal — no ugly 400/11% fractions in answers.
    """
    case = rc(["two_part", "three_part"])
    if case == "two_part":
        # totals in {2, 4, 5, 10, 20, 25} → all divide 100 cleanly
        pairs = [(1, 1), (1, 3), (3, 1), (1, 4), (4, 1), (2, 3), (3, 2),
                 (1, 9), (9, 1), (3, 7), (7, 3), (1, 19), (19, 1),
                 (3, 17), (7, 13), (1, 24), (3, 22), (7, 18), (11, 14)]
        a, b = rc(pairs)
        total = a + b
        pa = sp.Rational(a * 100, total)
        pb = sp.Rational(b * 100, total)
        q_latex = f"{a} : {b}"
        q_text  = (f"Express the ratio {a} : {b} as percentages of the "
                   "total.")
        a_latex = (f"\\dfrac{{{a}}}{{{total}}} \\times 100 = "
                   f"{sp.latex(pa)}\\%, \\; "
                   f"\\dfrac{{{b}}}{{{total}}} \\times 100 = "
                   f"{sp.latex(pb)}\\%")
        a_plain = f"{pa}%, {pb}%"
    else:
        # all triples sum to 10 or 20 → clean integer percentages
        triples = [(1, 3, 6), (2, 3, 5), (1, 4, 5), (3, 3, 4),
                   (2, 2, 6), (1, 2, 7), (3, 7, 10), (4, 6, 10),
                   (2, 8, 10), (5, 7, 8), (1, 9, 10)]
        a, b, c = rc(triples)
        total = a + b + c
        pa = sp.Rational(a * 100, total)
        pb = sp.Rational(b * 100, total)
        pc = sp.Rational(c * 100, total)
        q_latex = f"{a} : {b} : {c}"
        q_text  = (f"Express the ratio {a} : {b} : {c} as percentages.")
        a_latex = (f"{sp.latex(pa)}\\%, \\; {sp.latex(pb)}\\%, \\; "
                   f"{sp.latex(pc)}\\%")
        a_plain = f"{pa}%, {pb}%, {pc}%"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  HARD — NCERT Class 8 + commercial math
# ╚═════════════════════════════════════════════════════════════════════

def gen_chained_pct():
    """Apply 2-3 ± % steps in sequence to a starting value."""
    n_steps = rc([2, 3])
    start = rc([1000, 2000, 5000, 10000])
    steps = []
    val = start
    for _ in range(n_steps):
        sign = rc(["+", "-"])
        pct = rc([10, 15, 20, 25, 30])
        steps.append((sign, pct))
        if sign == "+":
            val = val * (100 + pct) // 100
        else:
            val = val * (100 - pct) // 100
    if val * 100 % 100 != 0:
        return None

    step_strs = ", ".join([f"{s}{p}\\%" for s, p in steps])
    step_strs_plain = ", ".join([f"{s}{p}%" for s, p in steps])
    q_latex = (f"\\text{{start}} = {start}, \\text{{ apply: }} {step_strs}")
    q_text  = (f"Starting at {start}, apply these percentage changes in "
               f"sequence: {step_strs_plain}.  Each step applies to the "
               "running total, NOT the original starting value.  Find the "
               "final value.")
    a_latex = f"\\text{{final}} = {val}"
    a_plain = f"final = {val}"
    return q_text, q_latex, a_latex, a_plain


def gen_compound_interest():
    """A = P(1 + r/100)^t  (NCERT Class 8 Ch 8)."""
    P = rc([1000, 2000, 5000, 10000, 20000, 50000])
    r = rc([4, 5, 6, 8, 10, 12])
    t = rc([2, 3, 4, 5])

    factor = sp.Rational(100 + r, 100)
    A = sp.simplify(P * factor ** t)
    A_n = float(A.evalf())
    interest = A_n - P

    q_latex = (f"P = ₹{P}, \\; r = {r}\\%, \\; t = {t} \\text{{ years}}")
    q_text  = (f"₹{P:,} is invested at {r}% per annum compound interest "
               f"for {t} years.  Find the amount A and the compound "
               "interest CI.  Formula: A = P(1 + r/100)^t.")
    a_latex = (f"A = {P} \\times \\left(1 + \\tfrac{{{r}}}{{100}}\\right)^{{{t}}} "
               f"\\approx ₹{A_n:,.2f}; \\quad "
               f"\\text{{CI}} = A - P \\approx ₹{interest:,.2f}")
    a_plain = f"A ≈ ₹{A_n:,.2f}, CI ≈ ₹{interest:,.2f}"
    return q_text, q_latex, a_latex, a_plain


def gen_successive_discount():
    """Two discounts of a%, b% in succession ≠ (a+b)%."""
    a_pct = rc([10, 15, 20, 25])
    b_pct = rc([5, 10, 15, 20])
    if a_pct == b_pct:
        return None
    # equivalent single discount = a + b - ab/100
    equiv = a_pct + b_pct - sp.Rational(a_pct * b_pct, 100)
    equiv_n = float(equiv)

    mrp = rc([1000, 1500, 2000, 2500, 5000])
    final_factor = sp.Rational((100 - a_pct) * (100 - b_pct), 10000)
    final = sp.simplify(mrp * final_factor)
    final_n = float(final)

    q_latex = (f"\\text{{MRP}} = ₹{mrp}, \\quad "
               f"\\text{{discounts: }} {a_pct}\\% \\text{{ then }} {b_pct}\\%")
    q_text  = (f"An item with marked price ₹{mrp:,} is offered with two "
               f"successive discounts: first {a_pct}% off, then {b_pct}% off "
               "the new price.  Find the equivalent single discount % and "
               "the final selling price.")
    a_latex = (f"\\text{{Equivalent}} = a + b - \\dfrac{{ab}}{{100}} "
               f"= {a_pct} + {b_pct} - \\dfrac{{{a_pct}\\cdot{b_pct}}}{{100}} "
               f"= {equiv_n:g}\\%; \\; "
               f"\\text{{SP}} = ₹{final_n:,.2f}")
    a_plain = f"equivalent = {equiv_n:g}%, SP = ₹{final_n:,.2f}"
    return q_text, q_latex, a_latex, a_plain


def gen_population_change():
    """Population grows or shrinks by r% per year for n years."""
    P = rc([10000, 25000, 50000, 80000, 100000, 250000])
    r = rc([2, 3, 4, 5, 6, 8, 10])
    t = rc([2, 3, 5, 10])
    direction = rc(["increase", "decrease"])
    if direction == "increase":
        factor = sp.Rational(100 + r, 100)
    else:
        factor = sp.Rational(100 - r, 100)

    new_pop = sp.simplify(P * factor ** t)
    new_pop_n = float(new_pop.evalf())

    q_latex = (f"P_0 = {P:,}, \\; r = {r}\\% \\text{{ ({direction})}}, "
               f"\\; t = {t} \\text{{ years}}")
    q_text  = (f"A town's population is currently {P:,}.  It "
               f"{'grows' if direction == 'increase' else 'shrinks'} by "
               f"{r}% each year (compounded annually).  Find the population "
               f"after {t} years (round to the nearest whole number).")
    sign = "+" if direction == "increase" else "-"
    a_latex = (f"P({t}) = {P} \\times \\left(1 {sign} \\tfrac{{{r}}}{{100}}\\right)^{{{t}}} "
               f"\\approx {round(new_pop_n):,}")
    a_plain = f"P({t}) ≈ {round(new_pop_n):,}"
    return q_text, q_latex, a_latex, a_plain


def gen_partnership_profit_share():
    """Two/three partners invest in given ratio; total profit P; find each share."""
    n_partners = rc([2, 3])
    if n_partners == 2:
        a, b = random.sample([2, 3, 4, 5, 7, 8], 2)
        total = a + b
        P = rc([10000, 12000, 15000, 20000, 30000])
        if P % total != 0:
            return None
        share_a = P * a // total
        share_b = P * b // total
        q_latex = (f"A : B = {a} : {b}, \\quad \\text{{profit}} = ₹{P:,}")
        q_text  = (f"Two partners A and B share profits in the ratio "
                   f"{a} : {b}.  If the total profit is ₹{P:,}, find each "
                   "partner's share.")
        a_latex = (f"A = ₹{share_a}, \\; B = ₹{share_b}")
        a_plain = f"A = ₹{share_a}, B = ₹{share_b}"
    else:
        triple = rc([(2, 3, 5), (1, 2, 3), (3, 4, 5), (2, 5, 8), (1, 3, 6)])
        a, b, c = triple
        total = a + b + c
        P = rc([12000, 18000, 24000, 30000, 60000])
        if P % total != 0:
            return None
        sa = P * a // total; sb = P * b // total; sc = P * c // total
        q_latex = (f"A : B : C = {a} : {b} : {c}, \\; \\text{{profit}} = ₹{P:,}")
        q_text  = (f"Three partners share profits in the ratio "
                   f"{a} : {b} : {c}.  If the total profit is ₹{P:,}, "
                   "find each partner's share.")
        a_latex = f"A = ₹{sa}, \\; B = ₹{sb}, \\; C = ₹{sc}"
        a_plain = f"A = ₹{sa}, B = ₹{sb}, C = ₹{sc}"
    return q_text, q_latex, a_latex, a_plain


def gen_markup_markdown():
    """Cost price → markup% → MRP → markdown% → SP.  Find profit %."""
    cp = rc([400, 500, 800, 1000, 1500, 2000])
    markup = rc([20, 25, 30, 40, 50])
    markdown = rc([5, 10, 15, 20])
    if (cp * (100 + markup)) % 100 != 0:
        return None
    mrp = cp * (100 + markup) // 100
    if (mrp * (100 - markdown)) % 100 != 0:
        return None
    sp_price = mrp * (100 - markdown) // 100
    profit = sp_price - cp
    profit_pct = sp.Rational(profit * 100, cp)

    q_latex = (f"\\text{{CP}} = ₹{cp}, \\; \\text{{markup}} = {markup}\\%, "
               f"\\; \\text{{markdown}} = {markdown}\\%")
    q_text  = (f"A retailer buys an item for ₹{cp:,}, marks it up by "
               f"{markup}% to set the MRP, then offers a {markdown}% "
               "discount during a sale.  Find the final selling price and "
               "the profit percentage.")
    a_latex = (f"\\text{{MRP}} = ₹{mrp}; \\; \\text{{SP}} = ₹{sp_price}; \\; "
               f"\\text{{Profit \\%}} = "
               f"\\dfrac{{{sp_price} - {cp}}}{{{cp}}} \\times 100 "
               f"= {sp.latex(profit_pct)}\\%")
    a_plain = f"MRP = ₹{mrp}, SP = ₹{sp_price}, profit% = {profit_pct}%"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  SCHOLAR — JEE-flavour / commercial classics
# ╚═════════════════════════════════════════════════════════════════════

def gen_successive_pct_proof():
    """Prove (1+a)(1+b) ≠ 1+a+b for a, b ∈ ℝ.  Net change vs sum."""
    pool = [
        {"q_latex": (r"\text{Show that two successive increases of } 20\% "
                     r"\text{ each do NOT amount to a } 40\% "
                     r"\text{ increase.}"),
         "q_text":  ("Compute the net % change of two successive 20% "
                     "increases applied to a starting value of 100. "
                     "Compare with a single 40% increase."),
         "a_latex": (r"100 \xrightarrow{+20\%} 120 \xrightarrow{+20\%} 144; "
                     r"\quad \text{net change} = 44\% \neq 40\%; "
                     r"\quad \text{difference comes from the } "
                     r"\frac{ab}{100} = \frac{20 \cdot 20}{100} = 4\% "
                     r"\text{ cross term.}"),
         "a_plain": "144 (44% net), not 140 (40%); cross term ab/100 = 4%."},

        {"q_latex": (r"\text{An increase of } 20\% \text{ followed by a "
                     r"decrease of } 20\% \text{ — find the net change.}"),
         "q_text":  ("Apply the two changes in sequence to a starting "
                     "value of 100, and explain why the result is NOT 100 "
                     "(no net change)."),
         "a_latex": (r"100 \xrightarrow{+20\%} 120 \xrightarrow{-20\%} 96; "
                     r"\quad \text{net change} = -4\%; "
                     r"\quad \text{the second } 20\% \text{ is applied to } "
                     r"120, \text{ not to } 100, \text{ so the cuts are "
                     r"unequal.}"),
         "a_plain": "Net = 96, a 4% decrease (not 0%)."},

        {"q_latex": (r"\text{An increase of } 25\% \text{ followed by what "
                     r"\% decrease will return to the original value?}"),
         "q_text":  ("Find the % decrease required after a 25% increase to "
                     "return to the original value."),
         "a_latex": (r"\text{Need } (1 + 0.25)(1 - x) = 1; \; "
                     r"1 - x = \tfrac{1}{1.25} = 0.8; \; "
                     r"x = 20\%."),
         "a_plain": "20% decrease."},

        {"q_latex": (r"\text{If a number increases by } 20\% \text{ and then "
                     r"the result decreases by } 25\%, \text{ what is the "
                     r"net change?}"),
         "q_text":  ("Compute the net % change."),
         "a_latex": (r"\text{Factor} = (1.20)(0.75) = 0.90; "
                     r"\quad \text{net change} = -10\% \text{ (10\% decrease).}"),
         "a_plain": "Net = -10% (10% decrease)."},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


def gen_ncert_classic_word():
    """Multi-step NCERT Class 8 word problems."""
    pool = [
        {
            "q_latex": (r"\text{An article is sold for } ₹1000 \text{ at a "
                        r"profit of } 25\%. \text{ At what price should it "
                        r"have been sold to make a profit of } 50\%?"),
            "q_text":  ("(NCERT Class 8) A two-step problem: first find CP "
                        "from the given SP and profit %, then compute the new "
                        "SP for the desired profit %."),
            "a_latex": (r"\text{CP} = \tfrac{1000}{1.25} = ₹800; \; "
                        r"\text{New SP} = 800 \times 1.50 = ₹1200."),
            "a_plain": "New SP = ₹1200"},
        {
            "q_latex": (r"\text{A shopkeeper marks his goods at } 40\% "
                        r"\text{ above CP and gives a discount of } 10\%. "
                        r"\text{ Find his profit \%.}"),
            "q_text":  ("Compute the overall profit% considering markup and "
                        "discount."),
            "a_latex": (r"\text{Factor} = 1.40 \times (1 - 0.10) = 1.40 "
                        r"\times 0.90 = 1.26; \; \text{profit \%} = 26\%."),
            "a_plain": "26%"},
        {
            "q_latex": (r"\text{The price of a TV is reduced by } 20\%. "
                        r"\text{ By what \% must the new price be increased "
                        r"to restore the original price?}"),
            "q_text":  ("Solve for the % increase needed to undo a 20% "
                        "decrease."),
            "a_latex": (r"\text{If new} = 0.8 \times \text{orig}, \text{ "
                        r"need to multiply by } \tfrac{1}{0.8} = 1.25; "
                        r"\quad \text{i.e. a } 25\% \text{ increase.}"),
            "a_plain": "25% increase"},
        {
            "q_latex": (r"\text{A man's salary is increased by } 20\% \text{ "
                        r"and then decreased by } 20\%. \text{ Find the net "
                        r"\% change in his salary.}"),
            "q_text":  ("Apply 20% increase then 20% decrease and find the "
                        "net change."),
            "a_latex": (r"(1.2)(0.8) = 0.96 \Rightarrow 4\% \text{ "
                        r"decrease (not } 0\%\text{).}"),
            "a_plain": "4% decrease"},
        {
            "q_latex": (r"\text{If } 5\% \text{ of } x = 25\% \text{ of } y, "
                        r"\text{ what is the ratio } x : y?"),
            "q_text":  ("Use the equation 0.05 x = 0.25 y to find x/y."),
            "a_latex": (r"\dfrac{x}{y} = \dfrac{0.25}{0.05} = 5; "
                        r"\quad x : y = 5 : 1."),
            "a_plain": "x : y = 5 : 1"},
        {
            "q_latex": (r"\text{A worker's pay is reduced by } 20\%. "
                        r"\text{ Later it is increased by } 20\%. "
                        r"\text{ What is the percentage change?}"),
            "q_text":  ("Apply 20% decrease, then 20% increase, find net."),
            "a_latex": (r"(0.8)(1.2) = 0.96 \Rightarrow 4\% \text{ decrease.}"),
            "a_plain": "4% decrease"},
        {
            "q_latex": (r"\text{In a class of } 60 \text{ students, } 40\% "
                        r"\text{ are girls. If } 5 \text{ more boys join, "
                        r"what is the new \% of girls?}"),
            "q_text":  ("Find original girls, then re-compute % with new total."),
            "a_latex": (r"\text{Girls} = 24; \text{ Boys} = 36 + 5 = 41; "
                        r"\text{ new total} = 65; \; "
                        r"\text{new \% girls} = \dfrac{24}{65} \times 100 "
                        r"\approx 36.92\%."),
            "a_plain": "≈ 36.92%"},
    ]
    item = rc(pool)
    return item["q_text"], item["q_latex"], item["a_latex"], item["a_plain"]


def gen_alligation_mixture():
    """Mix two solutions of pcts a%, b% to obtain a target solution of c%.

    Use the rule of alligation: ratio of qty(a) : qty(b) = (b - c) : (c - a).
    A staple JEE / SSC commercial-math classic.
    """
    triples = [
        # (low%, high%, target%)  — must satisfy low < target < high
        (10, 30, 20), (15, 30, 25), (20, 50, 30), (10, 40, 25),
        (5, 25, 15), (12, 30, 24), (20, 60, 35), (15, 45, 30),
        (8, 20, 12), (25, 75, 40), (10, 50, 30), (20, 40, 28),
        (10, 60, 30), (30, 70, 50), (5, 45, 25), (16, 32, 24),
    ]
    a_pct, b_pct, c_pct = rc(triples)
    total_qty = rc([60, 80, 100, 120, 150, 200])
    label = rc(["milk", "salt", "alcohol", "acid", "sugar"])
    units = rc(["litres", "kg"])

    qty_a_num = (b_pct - c_pct)
    qty_b_num = (c_pct - a_pct)
    ratio_sum = qty_a_num + qty_b_num
    qty_a = sp.Rational(total_qty * qty_a_num, ratio_sum)
    qty_b = sp.Rational(total_qty * qty_b_num, ratio_sum)

    q_latex = (f"\\text{{mix }} {a_pct}\\% \\text{{ + }} {b_pct}\\% "
               f"\\rightarrow {c_pct}\\%, \\; \\text{{total}} = {total_qty}")
    q_text = (f"A {a_pct}% {label} solution is to be mixed with a {b_pct}% "
              f"{label} solution to make {total_qty} {units} of a {c_pct}% "
              f"{label} solution.  Using alligation, find the quantity of "
              "each.")
    a_latex = (f"\\text{{Ratio}} = (b - c) : (c - a) = "
               f"({b_pct} - {c_pct}) : ({c_pct} - {a_pct}) = "
               f"{qty_a_num} : {qty_b_num}; \\; "
               f"\\text{{qty}}_a = {sp.latex(qty_a)} \\;{units}, \\; "
               f"\\text{{qty}}_b = {sp.latex(qty_b)} \\;{units}.")
    a_plain = (f"qty({a_pct}%) = {float(qty_a):g} {units}, "
               f"qty({b_pct}%) = {float(qty_b):g} {units}")
    return q_text, q_latex, a_latex, a_plain


def gen_pct_word_equation():
    """Solve a % equation: a% of X = b% of Y → ratio X:Y."""
    a_pct = rc([5, 8, 10, 12, 15, 20, 25, 30, 40])
    b_pct = rc([5, 8, 10, 12, 15, 20, 25, 30, 40, 50, 75])
    if a_pct == b_pct:
        return None
    ratio = sp.Rational(b_pct, a_pct)
    p, q = ratio.p, ratio.q

    q_latex = f"{a_pct}\\% \\text{{ of }} x = {b_pct}\\% \\text{{ of }} y"
    q_text = (f"Given {a_pct}% of x equals {b_pct}% of y, find the ratio "
              "x : y in lowest terms.")
    a_latex = (f"\\dfrac{{x}}{{y}} = \\dfrac{{{b_pct}}}{{{a_pct}}} "
               f"= {sp.latex(ratio)}; \\quad x : y = {p} : {q}.")
    a_plain = f"x : y = {p} : {q}"
    return q_text, q_latex, a_latex, a_plain


def gen_required_markup_for_profit():
    """How much above CP should an item be marked so that after a d% discount
    the seller still makes a p% profit on CP?"""
    cp = rc([200, 400, 500, 800, 1000, 1500, 2000])
    d = rc([5, 10, 15, 20, 25])
    p = rc([10, 15, 20, 25, 30, 40])
    # MP × (1 - d/100) = CP × (1 + p/100)
    factor = sp.Rational(100 + p, 100 - d)
    mp = sp.simplify(cp * factor)
    markup_pct = sp.simplify((mp - cp) * 100 / cp)

    q_latex = (f"\\text{{CP}} = ₹{cp}, \\; \\text{{discount}} = {d}\\%, \\; "
               f"\\text{{required profit}} = {p}\\%")
    q_text = (f"A shopkeeper buys an article for ₹{cp:,} and wants to make a "
              f"profit of {p}% on the cost price even after offering a "
              f"discount of {d}% on the marked price.  Find the marked price "
              "and the required markup percent over CP.")
    a_latex = (f"\\text{{MP}} \\times (1 - \\tfrac{{{d}}}{{100}}) = "
               f"\\text{{CP}} \\times (1 + \\tfrac{{{p}}}{{100}}); \\; "
               f"\\text{{MP}} = {cp} \\times \\dfrac{{{100 + p}}}{{{100 - d}}} "
               f"= ₹{float(mp):,.2f}; \\; "
               f"\\text{{markup}} = {sp.latex(markup_pct)}\\%.")
    a_plain = (f"MP = ₹{float(mp):,.2f}, markup over CP = "
               f"{float(markup_pct):.2f}%")
    return q_text, q_latex, a_latex, a_plain


def gen_two_pct_change_unknown():
    """Salary first changes by a%, then by b%, net is c%; given two of {a, b,
    c} solve for the third (parametric variant of the classic 'find b')."""
    a_pct = rc([10, 15, 20, 25, 30, 40, 50])
    sign_a = rc(["+", "-"])
    b_pct = rc([5, 10, 12, 15, 20, 25])
    sign_b = rc(["+", "-"])

    fa = sp.Rational(100 + a_pct, 100) if sign_a == "+" else sp.Rational(100 - a_pct, 100)
    fb = sp.Rational(100 + b_pct, 100) if sign_b == "+" else sp.Rational(100 - b_pct, 100)
    net = sp.simplify((fa * fb - 1) * 100)

    q_latex = (f"x \\xrightarrow{{{sign_a}{a_pct}\\%}} y "
               f"\\xrightarrow{{{sign_b}{b_pct}\\%}} z; \\; "
               r"\text{find net \% change}")
    q_text = (f"A value first changes by {sign_a}{a_pct}%, then the result "
              f"changes by {sign_b}{b_pct}%.  Find the net percentage change "
              "applied to the original value.")
    direction = "increase" if net > 0 else ("decrease" if net < 0 else "unchanged")
    a_latex = (f"\\text{{factor}} = ({sp.latex(fa)})({sp.latex(fb)}) = "
               f"{sp.latex(fa * fb)}; \\; "
               f"\\text{{net}} = {sp.latex(net)}\\% \\text{{ ({direction})}}.")
    a_plain = f"net = {float(net):g}% ({direction})"
    return q_text, q_latex, a_latex, a_plain


def gen_population_density_pct():
    """Multi-variable % problem: if length increases by a% and breadth
    decreases by b%, find the % change in the area (NCERT JEE classic)."""
    quantity = rc(["rectangle area", "cuboid volume", "circle area"])
    if quantity == "rectangle area":
        a = rc([10, 15, 20, 25, 30, 40, 50])
        b = rc([10, 15, 20, 25, 30])
        sign_b = rc(["+", "-"])
        fb = sp.Rational(100 + b, 100) if sign_b == "+" else sp.Rational(100 - b, 100)
        fa = sp.Rational(100 + a, 100)
        net = sp.simplify((fa * fb - 1) * 100)
        q_text = (f"The length of a rectangle increases by {a}% while the "
                  f"breadth {'increases' if sign_b == '+' else 'decreases'} "
                  f"by {b}%.  Find the percentage change in the area.")
        q_latex = (f"L \\to L(1 + \\tfrac{{{a}}}{{100}}); \\; "
                   f"B \\to B(1 {sign_b} \\tfrac{{{b}}}{{100}})")
        a_latex = (f"\\text{{Area factor}} = ({sp.latex(fa)})({sp.latex(fb)}) "
                   f"= {sp.latex(fa * fb)}; \\; "
                   f"\\text{{change}} = {sp.latex(net)}\\%.")
    elif quantity == "cuboid volume":
        a = rc([10, 20, 25, 50])
        # all three sides scale by same a%
        fa = sp.Rational(100 + a, 100)
        net = sp.simplify((fa**3 - 1) * 100)
        q_text = (f"Each side of a cube increases by {a}%.  Find the "
                  "percentage change in its volume.")
        q_latex = f"s \\to s(1 + \\tfrac{{{a}}}{{100}})"
        a_latex = (f"\\text{{V factor}} = ({sp.latex(fa)})^3 "
                   f"= {sp.latex(fa**3)}; \\; "
                   f"\\text{{change}} = {sp.latex(net)}\\%.")
    else:  # circle area
        a = rc([10, 20, 25, 30, 40, 50])
        sign_a = rc(["+", "-"])
        fa = sp.Rational(100 + a, 100) if sign_a == "+" else sp.Rational(100 - a, 100)
        net = sp.simplify((fa**2 - 1) * 100)
        q_text = (f"The radius of a circle "
                  f"{'increases' if sign_a == '+' else 'decreases'} by {a}%.  "
                  "Find the percentage change in its area.")
        q_latex = f"r \\to r(1 {sign_a} \\tfrac{{{a}}}{{100}})"
        a_latex = (f"\\text{{Area factor}} = ({sp.latex(fa)})^2 "
                   f"= {sp.latex(fa**2)}; \\; "
                   f"\\text{{change}} = {sp.latex(net)}\\%.")
    direction = "increase" if net > 0 else ("decrease" if net < 0 else "no change")
    a_plain = f"{float(net):g}% ({direction})"
    return q_text, q_latex, a_latex, a_plain


# ╔═════════════════════════════════════════════════════════════════════
# ║  DISPATCHER
# ╚═════════════════════════════════════════════════════════════════════

DIFFICULTY_TYPES = {
    "basic": [
        "pct_of_simple",
        "what_pct",
        "pct_to_decimal_fraction",
        "decimal_to_pct",
        "fraction_to_pct",
        "pct_of_quantity_word",
    ],
    "medium": [
        "increase_by",
        "decrease_by",
        "pct_change",
        "reverse_pct",
        "discount_calc",
        "tax_calc",
        "profit_loss_pct",
        "ratio_to_pct",
    ],
    "hard": [
        "chained_pct",
        "compound_interest",
        "successive_discount",
        "population_change",
        "partnership_profit_share",
        "markup_markdown",
    ],
    "scholar": [
        "successive_pct_proof",
        "ncert_classic_word",
        "alligation_mixture",
        "pct_word_equation",
        "required_markup_for_profit",
        "two_pct_change_unknown",
        "geometry_pct_change",
    ],
}


def call_generator(q_type):
    generators = {
        "pct_of_simple":            gen_pct_of_simple,
        "what_pct":                 gen_what_pct,
        "pct_to_decimal_fraction":  gen_pct_to_decimal_fraction,
        "decimal_to_pct":           gen_decimal_to_pct,
        "fraction_to_pct":          gen_fraction_to_pct,
        "pct_of_quantity_word":     gen_pct_of_quantity_word,
        "increase_by":              gen_increase_by,
        "decrease_by":              gen_decrease_by,
        "pct_change":               gen_pct_change,
        "reverse_pct":              gen_reverse_pct,
        "discount_calc":            gen_discount_calc,
        "tax_calc":                 gen_tax_calc,
        "profit_loss_pct":          gen_profit_loss_pct,
        "ratio_to_pct":             gen_ratio_to_pct,
        "chained_pct":              gen_chained_pct,
        "compound_interest":        gen_compound_interest,
        "successive_discount":      gen_successive_discount,
        "population_change":        gen_population_change,
        "partnership_profit_share": gen_partnership_profit_share,
        "markup_markdown":          gen_markup_markdown,
        "successive_pct_proof":     gen_successive_pct_proof,
        "ncert_classic_word":       gen_ncert_classic_word,
        "alligation_mixture":       gen_alligation_mixture,
        "pct_word_equation":        gen_pct_word_equation,
        "required_markup_for_profit": gen_required_markup_for_profit,
        "two_pct_change_unknown":   gen_two_pct_change_unknown,
        "geometry_pct_change":      gen_population_density_pct,
    }
    if q_type not in generators:
        return None
    res = generators[q_type]()
    if res is None:
        return None
    q_text, q_latex, ans_latex, ans_plain = res
    return {"q_text": q_text, "q_latex": q_latex,
            "ans_latex": ans_latex, "ans_plain": ans_plain}


def generate_pct_questions(n_target):
    questions = []
    seen = set()
    fail_streak = 0

    while len(questions) < n_target:
        rv = random.random()
        if rv < 0.32:
            diff = "basic"
        elif rv < 0.62:
            diff = "medium"
        elif rv < 0.92:
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

    qs = generate_pct_questions(n_target)

    out_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "percentages.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Percentages",
            "description": ("NCERT Class 7 Ch 7 + Class 8 Ch 8 (Comparing "
                            "Quantities) percentages, ratios, percent change, "
                            "profit/loss, discount, tax, compound interest, "
                            "successive discounts, partnership profit share, "
                            "and markup/markdown commercial-math problems."),
            "questions": qs,
        }, f, separators=(",", ":"))

    print(f"Generated {len(qs)} percentage problems → {out_path}")

    types_h = Counter(q["type"] for q in qs)
    diffs_h = Counter(q["difficulty"] for q in qs)
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard", "scholar"]:
        print(f"  {d:8s}  {diffs_h.get(d, 0):>4}")
    print(f"\nBy type:")
    for t, c in sorted(types_h.items(), key=lambda kv: -kv[1]):
        print(f"  {t:30s}  {c:>4}")
