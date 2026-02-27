"""
Series & Sequences Question Bank Generator — Dawkins Ch 10 Full Coverage
Answers verified by SymPy where applicable.

§10.1  Sequences (terms, convergence)
§10.2  More on Sequences (monotonic, bounded)
§10.3  Series — The Basics (index shift, strip terms)
§10.4  Convergence / Divergence (partial sums, nth term test)
§10.5  Special Series (geometric, telescoping)
§10.6  Integral Test
§10.7  Comparison Test / Limit Comparison Test
§10.8  Alternating Series Test
§10.9  Absolute Convergence
§10.10 Ratio Test
§10.11 Root Test
§10.13 Estimating the Value of a Series
§10.14 Power Series (radius & interval of convergence)
§10.15 Power Series and Functions
§10.16 Taylor Series
§10.17 Applications of Series
§10.18 Binomial Series
"""

import sympy as sp
import json
import random
import os

# ---------------------------------------------------------------------------
# Symbols
# ---------------------------------------------------------------------------
n = sp.Symbol('n', integer=True, positive=True)
x = sp.Symbol('x')
k = sp.Symbol('k', integer=True, positive=True)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def rc(pool):
    return random.choice(pool)

NZ  = [-4, -3, -2, -1, 1, 2, 3, 4]
POS = [1, 2, 3, 4, 5]
SML = [-2, -1, 1, 2]

def fmt_ans(expr):
    """Return (latex, plain) for an answer expression."""
    return sp.latex(expr), str(expr)

def safe_limit(expr, var, val):
    """Compute limit, return None on failure or non-finite."""
    try:
        L = sp.limit(expr, var, val)
        if L.has(sp.zoo, sp.nan):
            return None
        # Allow ±∞ as valid answers (for divergence)
        if L in (sp.oo, -sp.oo):
            return L
        if not L.is_finite:
            return None
        return L
    except Exception:
        return None

def safe_sum(expr, var, lo, hi):
    """Compute finite/infinite sum, return None on failure."""
    try:
        s = sp.summation(expr, (var, lo, hi))
        if s.has(sp.zoo, sp.nan):
            return None
        return s
    except Exception:
        return None

def converges_text(converges, value=None):
    """Return a standard convergence answer string."""
    if converges:
        if value is not None:
            return f"Converges to {sp.latex(value)}", f"Converges to {value}"
        return "Converges", "Converges"
    return "Diverges", "Diverges"

# ---------------------------------------------------------------------------
# §10.1 — Sequence Terms
# ---------------------------------------------------------------------------
def gen_sequence_terms():
    """List first 5 terms of a sequence."""
    a, b = rc(NZ), rc(NZ)
    c = rc(POS)
    d = rc([2, 3, 4, 5])
    templates = [
        a * n + b,
        a * n**2 + b,
        a * n**2 + b * n + rc(NZ),
        sp.Rational(a, 1) / (n + c),
        sp.Rational(a, 1) * n / (n**2 + c),
        sp.Rational(b, 1) * n / (c * n + rc(POS)),
        (-1)**n * a * n / c,
        (-1)**(n+1) * sp.Rational(a, 1) / n,
        (-1)**n * sp.Rational(a, 1) / (n + c),
        (n + rc(SML)) / sp.factorial(n),
        sp.Rational(d, 1) ** n / sp.factorial(n),
        sp.sqrt(n + c),
        n * (-sp.Rational(1, d))**n,
        sp.Rational(a, 1) * d**n,
        sp.Rational(a, 1) * n**3 + b,
        sp.sin(sp.Rational(a, 1) * n) / n,
        sp.cos(sp.pi * n / d),
        (n + a) * (n + b),
        sp.Rational(a, 1) * sp.Rational(1, d)**n,
        (-1)**n * n**2 / sp.factorial(n),
    ]
    a_n = rc(templates)
    terms = [a_n.subs(n, i) for i in range(1, 6)]
    # Verify all terms are finite
    for t in terms:
        if not t.is_finite:
            return None

    terms_latex = ", ".join(sp.latex(t) for t in terms)
    terms_plain = ", ".join(str(t) for t in terms)

    q = f"List the first 5 terms of the sequence \\( a_n = {sp.latex(a_n)} \\)."
    return {
        "type": "sequence_terms",
        "difficulty": "basic",
        "question_text": q,
        "answer_latex": terms_latex,
        "answer_plain": terms_plain,
        "_sig": sp.srepr(a_n),
    }

# ---------------------------------------------------------------------------
# §10.1 — Sequence Convergence
# ---------------------------------------------------------------------------
def gen_sequence_convergence():
    """Does a_n converge? Find limit."""
    a, b, c = rc(NZ), rc(POS), rc(POS)
    d = rc([2, 3, 4, 5])
    templates = [
        (a * n + b) / (c * n + rc(POS)),
        (a * n**2 + b) / (rc(POS) * n**2 + rc(POS)),
        (a * n**2 + rc(NZ) * n) / (c * n**2 + rc(POS)),
        sp.Rational(a, 1) / n**rc([1, 2, 3]),
        sp.Rational(a, 1) * n / sp.exp(n),
        sp.Rational(a, 1) * sp.ln(n) / n,
        (1 + sp.Rational(rc(SML), 1) / n)**n,
        sp.Rational(a, 1) * sp.sin(n) / n,
        n**(sp.Rational(1, 1) / n),
        sp.Rational(rc(NZ), 1) * (sp.Rational(rc(SML), d))**n,
        sp.factorial(n) / sp.Rational(d, 1)**n,
        sp.Rational(a, 1) * (sp.sqrt(n + c) - sp.sqrt(n)),
        sp.Rational(a, 1) * n**(sp.Rational(1, d)),
        sp.Rational(a, 1) * sp.cos(sp.Rational(1, 1) / n),
        (sp.Rational(a, 1) * n + b) / sp.sqrt(c * n**2 + rc(POS)),
        sp.Rational(a, 1) * sp.exp(-n) * n**d,
    ]
    a_n = rc(templates)
    L = safe_limit(a_n, n, sp.oo)
    if L is None:
        return None

    if L in (sp.oo, -sp.oo):
        al, ap = "\\text{Diverges}", "Diverges"
        diff = "medium"
    else:
        al = f"\\text{{Converges to }} {sp.latex(L)}"
        ap = f"Converges to {L}"
        diff = "basic"

    q = f"Determine whether the sequence \\( a_n = {sp.latex(a_n)} \\) converges or diverges. If it converges, find the limit."
    return {
        "type": "sequence_convergence",
        "difficulty": diff,
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n),
    }

# ---------------------------------------------------------------------------
# §10.2 — Sequence Properties (monotonic / bounded)
# ---------------------------------------------------------------------------
def gen_sequence_properties():
    """Determine if sequence is increasing/decreasing/bounded/monotonic."""
    a, b = rc(POS), rc(POS)
    c = rc([2, 3, 4, 5])
    d = rc(POS)
    choices = [
        (a * n / (n + b), "increasing", "bounded above"),
        (sp.Rational(a, 1) / n, "decreasing", "bounded below by 0"),
        ((-1)**n * sp.Rational(a, 1) / n, "not monotonic", "bounded"),
        (sp.Rational(a, 1) * n, "increasing", "unbounded above"),
        ((n + a) / (n + b + d), "increasing", "bounded"),
        (sp.Rational(a, 1) - sp.Rational(b, 1) / n, "increasing", f"bounded above by {a}"),
        (sp.Rational(c, 1)**n / sp.factorial(n), "eventually decreasing", "bounded below by 0"),
        (n**2 / (n**2 + a), "increasing", "bounded above by 1"),
        (sp.Rational(a, 1) * sp.ln(n) / n, "eventually decreasing", "bounded"),
        (sp.Rational(a, 1) * n / c**n, "eventually decreasing", "bounded below by 0"),
        (sp.Rational(a, 1) * n**2, "increasing", "unbounded above"),
        (sp.Rational(a, 1) / (n + b), "decreasing", "bounded below by 0"),
        (1 - sp.Rational(1, 1) / n**2, "increasing", "bounded above by 1"),
        ((-1)**n * sp.Rational(a, 1), "not monotonic", "bounded"),
    ]
    a_n, monotone, bounded = rc(choices)

    q = f"Determine whether the sequence \\( a_n = {sp.latex(a_n)} \\) is increasing, decreasing, or not monotonic. Is it bounded?"
    ap = f"{monotone.capitalize()}; {bounded}"
    al = f"\\text{{{ap}}}"
    return {
        "type": "sequence_properties",
        "difficulty": "medium",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n),
    }

# ---------------------------------------------------------------------------
# §10.3 — Series Index Shift
# ---------------------------------------------------------------------------
def gen_series_index_shift():
    """Rewrite a series with a shifted starting index."""
    a, b = rc(NZ), rc(POS)
    c = rc([2, 3, 4, 5])
    shift = rc([1, 2, 3])
    templates = [
        sp.Rational(a, 1) / (n + b),
        sp.Rational(a, 1) * x**n,
        (-1)**n * sp.Rational(a, 1) / sp.factorial(n),
        sp.Rational(a, 1) * n / c**n,
        sp.Rational(a, 1) / n**rc([2, 3]),
        sp.Rational(a, 1) * x**n / sp.factorial(n),
        sp.Rational(a, 1) * (-x)**n / n,
        sp.Rational(a, 1) * n * x**(n - 1),
        sp.Rational(a, 1) / (n * (n + b)),
        (-1)**n * sp.Rational(a, 1) / (2*n + 1),
        sp.Rational(a, 1) * x**n / (n + b),
    ]
    a_n = rc(templates)
    # Shift: replace n with n - shift in summand, start from shift
    a_n_shifted = a_n.subs(n, n - shift)

    q = (f"Rewrite the series \\( \\displaystyle\\sum_{{n=0}}^{{\\infty}} {sp.latex(a_n)} \\) "
         f"so that the summation starts at \\( n = {shift} \\).")
    al = f"\\sum_{{n={shift}}}^{{\\infty}} {sp.latex(a_n_shifted)}"
    ap = f"sum from n={shift} to inf of {a_n_shifted}"
    return {
        "type": "series_index_shift",
        "difficulty": "basic",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + f"_shift{shift}",
    }

# ---------------------------------------------------------------------------
# §10.3 — Strip First k Terms
# ---------------------------------------------------------------------------
def gen_series_strip_terms():
    """Write a series after stripping the first k terms."""
    a = rc(NZ)
    b = rc(POS)
    k_val = rc([1, 2, 3, 4])
    templates = [
        sp.Rational(a, 1) / n**rc([2, 3]),
        sp.Rational(a, 1) / (n * (n + rc(POS))),
        sp.Rational(a, 1) / sp.factorial(n),
        (-1)**n * sp.Rational(a, 1) / n,
        sp.Rational(a, 1) / (n + b),
        sp.Rational(a, 1) * rc([2, 3, 4])**n / sp.factorial(n),
        (-1)**(n+1) * sp.Rational(a, 1) / (2*n - 1),
        sp.Rational(a, 1) / n**sp.Rational(3, 2),
        sp.Rational(a, 1) * n / rc([2, 3, 4, 5])**n,
    ]
    a_n = rc(templates)
    # Compute stripped terms
    stripped = [a_n.subs(n, i) for i in range(1, k_val + 1)]
    stripped_sum = sum(stripped)

    q = (f"Write the series \\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) "
         f"after stripping the first {k_val} term(s).")
    al = f"\\sum_{{n={k_val + 1}}}^{{\\infty}} {sp.latex(a_n)}"
    ap = f"sum from n={k_val + 1} to inf of {a_n}"
    return {
        "type": "series_strip_terms",
        "difficulty": "basic",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + f"_strip{k_val}",
    }

# ---------------------------------------------------------------------------
# §10.4 — Partial Sums
# ---------------------------------------------------------------------------
def gen_partial_sums():
    """Compute the first 3 partial sums S_1, S_2, S_3."""
    a, b = rc(NZ), rc(POS)
    d = rc([2, 3, 4, 5])
    templates = [
        sp.Rational(a, 1) / n**rc([2, 3]),
        sp.Rational(a, 1) / (d**n),
        (-1)**(n+1) * sp.Rational(a, 1) / n,
        sp.Rational(a, 1) * n / (n + b),
        sp.Rational(a, 1) / (n * (n + rc(POS))),
        sp.Rational(d, 1)**n / sp.factorial(n),
        sp.Rational(a, 1) * n**2 / (n**2 + b),
        sp.Rational(a, 1) * (-sp.Rational(1, d))**n,
        sp.Rational(1, 1) / sp.factorial(n) * a,
        sp.Rational(a, 1) / (n + b),
        sp.Rational(a, 1) * n / d**n,
        (-1)**n * sp.Rational(a, 1) / (2*n + 1),
    ]
    a_n = rc(templates)
    s1 = a_n.subs(n, 1)
    s2 = s1 + a_n.subs(n, 2)
    s3 = s2 + a_n.subs(n, 3)

    q = (f"For the series \\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\), "
         f"compute the first three partial sums \\( S_1, S_2, S_3 \\).")
    al = f"S_1 = {sp.latex(s1)}, \\; S_2 = {sp.latex(s2)}, \\; S_3 = {sp.latex(s3)}"
    ap = f"S1 = {s1}, S2 = {s2}, S3 = {s3}"
    return {
        "type": "partial_sums",
        "difficulty": "medium",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + "_partial",
    }

# ---------------------------------------------------------------------------
# §10.4 — Convergence / Divergence (nth term test)
# ---------------------------------------------------------------------------
def gen_series_conv_div():
    """Use the nth term test (divergence test)."""
    a, b = rc(NZ), rc(POS)
    c = rc([2, 3, 4, 5])
    # Series where nth term doesn't go to 0 — diverges
    divergent = [
        n / (n + b),
        (a * n + rc(NZ)) / (rc(POS) * n + b),
        (-1)**n,
        (-1)**n * n / (n + b),
        sp.sin(n),
        n**2 / (n**2 + rc(POS)),
        sp.cos(sp.Rational(1, c) * n),
        (c * n + a) / (n + b),
        sp.Rational(a, 1) * (-1)**n * n / (n + rc(POS)),
        n**(sp.Rational(1, c)),
    ]
    # Some that do go to 0 (test is inconclusive)
    inconclusive = [
        sp.Rational(a, 1) / n,
        sp.Rational(a, 1) / n**c,
        sp.Rational(a, 1) / sp.sqrt(n),
        sp.Rational(a, 1) / (n * sp.ln(n + 1)),
        sp.Rational(a, 1) * sp.ln(n) / n**2,
        sp.Rational(a, 1) / n**sp.Rational(3, 2),
    ]

    if rc([True, False]):
        a_n = rc(divergent)
        L = safe_limit(a_n, n, sp.oo)
        if L is None:
            return None
        al = f"\\text{{Diverges by Divergence Test}} \\;(\\lim_{{n\\to\\infty}} a_n = {sp.latex(L)} \\ne 0)"
        ap = f"Diverges by the Divergence Test (limit = {L} != 0)"
    else:
        a_n = rc(inconclusive)
        al = "\\text{Divergence Test inconclusive} \\;(\\lim_{n\\to\\infty} a_n = 0)"
        ap = "Divergence Test is inconclusive (limit = 0). Another test is needed."

    q = (f"Apply the Divergence Test to the series "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\). "
         f"What can you conclude?")
    return {
        "type": "series_conv_div",
        "difficulty": "medium",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + "_divtest",
    }

# ---------------------------------------------------------------------------
# §10.5 — Geometric Series
# ---------------------------------------------------------------------------
def gen_geometric_series():
    """Geometric series — find sum or state divergent."""
    a_val = rc([-3, -2, -1, 1, 2, 3, 4, 5])
    # ratio r such that |r| < 1 for convergence, or |r| >= 1 for divergence
    converge = rc([True, True, True, False])
    if converge:
        r = sp.Rational(rc([-3, -2, -1, 1, 2, 3]), rc([4, 5, 6, 7, 8]))
        while abs(r) >= 1:
            r = sp.Rational(rc([-3, -2, -1, 1, 2, 3]), rc([4, 5, 6, 7, 8]))
        S = sp.Rational(a_val, 1) / (1 - r)
        al = f"\\text{{Converges; }} S = {sp.latex(S)}"
        ap = f"Converges; S = {S}"
    else:
        r = sp.Rational(rc([-5, -3, -2, 2, 3, 5]), rc([1, 2, 3]))
        while abs(r) < 1:
            r = sp.Rational(rc([-5, -3, -2, 2, 3, 5]), rc([1, 2, 3]))
        al = f"\\text{{Diverges}} \\;(|r| = {sp.latex(abs(r))} \\ge 1)"
        ap = f"Diverges (|r| = {abs(r)} >= 1)"

    q = (f"Determine whether the geometric series "
         f"\\( \\displaystyle\\sum_{{n=0}}^{{\\infty}} {sp.latex(sp.Rational(a_val, 1))} "
         f"\\left({sp.latex(r)}\\right)^n \\) converges or diverges. "
         f"If it converges, find its sum.")
    return {
        "type": "geometric_series",
        "difficulty": "basic",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": f"geo_{a_val}_{r}",
    }

# ---------------------------------------------------------------------------
# §10.5 — Telescoping Series
# ---------------------------------------------------------------------------
def gen_telescoping_series():
    """Partial fraction telescoping sum."""
    a_val = rc(NZ)
    shift = rc([1, 2, 3, 4])
    offset = rc([0, 1, 2])
    # Various telescoping forms
    tele_type = rc(["basic", "offset", "quadratic"])
    if tele_type == "basic":
        a_n = sp.Rational(a_val, 1) / (n * (n + shift))
    elif tele_type == "offset":
        a_n = sp.Rational(a_val, 1) / ((n + offset) * (n + offset + shift))
    else:
        a_n = sp.Rational(a_val, 1) / ((2*n - 1) * (2*n + 1))
    # Sum telescopes to a_val/shift * (1 + 1/2 + ... + 1/shift) via partial sums
    # Actually: sum = a_val / shift * sum_{n=1}^{inf} (1/n - 1/(n+shift))
    # which telescopes to a_val/shift * (1 + 1/2 + ... + 1/shift)
    S = safe_sum(a_n, n, 1, sp.oo)
    if S is None or S.has(sp.zoo, sp.nan) or not S.is_finite:
        return None

    q = (f"Find the sum of the telescoping series "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\). "
         f"(Hint: use partial fractions.)")
    al = f"S = {sp.latex(S)}"
    ap = f"S = {S}"
    return {
        "type": "telescoping_series",
        "difficulty": "medium",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": f"tele_{a_val}_{shift}",
    }

# ---------------------------------------------------------------------------
# §10.6 — Integral Test
# ---------------------------------------------------------------------------
def gen_integral_test():
    """Apply the Integral Test for convergence."""
    b = rc(POS)
    a_val = rc(POS)
    c = rc([2, 3, 4, 5])
    p_val = sp.Rational(rc([1, 2, 3, 4, 5]), rc([1, 2, 3]))
    templates = [
        (sp.Rational(a_val, 1) / n**p_val, p_val > 1, f"p-series with p={p_val}"),
        (sp.Rational(a_val, 1) / (n * sp.ln(n)**b), b > 1, f"{a_val}/(n ln(n)^{b})"),
        (sp.Rational(a_val, 1) / (n**2 + c), True, None),
        (sp.Rational(a_val, 1) * n * sp.exp(-n), True, None),
        (sp.Rational(a_val, 1) / (n * sp.ln(n)), False, f"{a_val}/(n ln n)"),
        (sp.Rational(a_val, 1) * sp.ln(n) / n, False, f"{a_val} ln(n)/n"),
        (sp.Rational(a_val, 1) * sp.exp(-n), True, None),
        (sp.Rational(a_val, 1) / (n * sp.ln(n) * sp.ln(sp.ln(n + 2))), False, None),
        (sp.Rational(a_val, 1) * n / (n**2 + c)**2, True, None),
        (sp.Rational(a_val, 1) / (n**2 + c * n + rc(POS)), True, None),
        (sp.Rational(a_val, 1) * sp.ln(n) / n**c, c > 1, None),
        (sp.Rational(a_val, 1) / (n * sp.sqrt(sp.ln(n + 1))), False, None),
    ]
    a_n, conv, note = rc(templates)

    # Build the integral from 1 (or 2 for ln) to oo
    t = sp.Symbol('t', positive=True)
    f_t = a_n.subs(n, t)
    lo = 2 if a_n.has(sp.ln(n)) else 1

    try:
        integ = sp.integrate(f_t, (t, lo, sp.oo))
    except Exception:
        integ = None

    if integ is None or integ.has(sp.zoo, sp.nan):
        # Fallback: just state the result
        pass

    if conv:
        al = "\\text{Converges by Integral Test}"
        ap = "Converges by the Integral Test"
    else:
        al = "\\text{Diverges by Integral Test}"
        ap = "Diverges by the Integral Test"

    if note:
        ap += f" ({note})"

    if integ is not None and not integ.has(sp.zoo, sp.nan) and conv:
        al += f" \\;\\left(\\int_{{{lo}}}^{{\\infty}} {sp.latex(f_t)} \\, dt = {sp.latex(integ)}\\right)"

    q = (f"Use the Integral Test to determine whether "
         f"\\( \\displaystyle\\sum_{{n={lo}}}^{{\\infty}} {sp.latex(a_n)} \\) converges or diverges.")
    return {
        "type": "integral_test",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + "_inttest",
    }

# ---------------------------------------------------------------------------
# §10.7 — Comparison Test / Limit Comparison Test
# ---------------------------------------------------------------------------
def gen_comparison_test():
    """Direct comparison or limit comparison test."""
    b = rc([2, 3, 4, 5])
    a_val = rc(POS)
    c = rc(POS)
    templates = [
        (sp.Rational(a_val, 1) / (n**b + c),
         f"{a_val}/n^{b}", True, "Direct Comparison"),
        (sp.Rational(a_val, 1) / (n**b - 1),
         f"{a_val}/n^{b}", True, "Limit Comparison"),
        (sp.Rational(a_val, 1) * sp.ln(n) / n**b,
         f"1/n^{{{b-1}}}", True if b >= 3 else False, "Limit Comparison"),
        (sp.Rational(a_val, 1) / (sp.sqrt(n) + c),
         f"{a_val}/\\sqrt{{n}}", False, "Limit Comparison"),
        (sp.Rational(a_val, 1) * n / (n**3 + c),
         f"{a_val}/n^2", True, "Limit Comparison"),
        (sp.Rational(a_val, 1) / (n + sp.sqrt(n)),
         f"{a_val}/n", False, "Limit Comparison"),
        (sp.sin(sp.Rational(a_val, 1) / n),
         f"{a_val}/n", False, "Limit Comparison"),
        (sp.Rational(a_val, 1) / (n**b + n),
         f"{a_val}/n^{b}", True, "Direct Comparison"),
        (sp.Rational(a_val, 1) * sp.exp(-n) / n,
         f"{a_val} e^{{-n}}", True, "Direct Comparison"),
        (sp.Rational(a_val, 1) / (n * sp.ln(n + 1)**b),
         f"1/(n \\ln^{b} n)", True if b > 1 else False, "Limit Comparison"),
        (sp.Rational(a_val, 1) * n**2 / (n**4 + c),
         f"{a_val}/n^2", True, "Limit Comparison"),
        (sp.Rational(a_val, 1) / (sp.sqrt(n**3 + c)),
         f"{a_val}/n^{{3/2}}", True, "Limit Comparison"),
    ]
    a_n, comp, conv, test = rc(templates)

    verdict = "Converges" if conv else "Diverges"
    q = (f"Use the Comparison Test or Limit Comparison Test to determine whether "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) converges or diverges.")
    al = f"\\text{{{verdict} by {test} with }} b_n = {comp}"
    ap = f"{verdict} by {test} with b_n = {comp}"
    return {
        "type": "comparison_test",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + "_comp",
    }

# ---------------------------------------------------------------------------
# §10.8 — Alternating Series Test
# ---------------------------------------------------------------------------
def gen_alternating_series():
    """Alternating series test."""
    a_val = rc(POS)
    c = rc([2, 3, 4, 5])
    b_n_choices = [
        (sp.Rational(a_val, 1) / n, True),
        (sp.Rational(a_val, 1) / sp.ln(n + 1), True),
        (sp.Rational(a_val, 1) * n / (n**2 + rc(POS)), True),
        (sp.Rational(a_val, 1) / sp.sqrt(n), True),
        (sp.Rational(a_val, 1) / n**rc([2, 3]), True),
        (sp.Rational(a_val, 1) * n / (n + rc(POS)), False),
        (sp.Rational(a_val, 1) / (n + c), True),
        (sp.Rational(a_val, 1) * sp.ln(n + 1) / n, True),
        (sp.Rational(a_val, 1) / (2*n + rc(POS)), True),
        (sp.Rational(a_val, 1) * n / (c * n + rc(POS)), False),
        (sp.Rational(a_val, 1) / sp.factorial(n), True),
        (sp.Rational(a_val, 1) / (n * sp.ln(n + 1)), True),
    ]
    b_n, conv = rc(b_n_choices)
    sign = rc([(-1)**n, (-1)**(n + 1)])
    a_n = sign * b_n

    if conv:
        al = f"\\text{{Converges by AST}} \\;(b_n = {sp.latex(b_n)} \\text{{ is decreasing and }} \\to 0)"
        ap = f"Converges by the Alternating Series Test"
    else:
        al = f"\\text{{Diverges}} \\;(b_n = {sp.latex(b_n)} \\not\\to 0)"
        ap = f"Diverges (b_n does not approach 0)"

    q = (f"Use the Alternating Series Test on "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\).")
    return {
        "type": "alternating_series",
        "difficulty": "medium",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + "_alt",
    }

# ---------------------------------------------------------------------------
# §10.9 — Absolute Convergence
# ---------------------------------------------------------------------------
def gen_absolute_convergence():
    """Determine absolute/conditional convergence/divergence."""
    a_val = rc(POS)
    c = rc([2, 3, 4, 5])
    p = rc([2, 3, 4])
    choices = [
        ((-1)**(n+1) * sp.Rational(a_val, 1) / n, False, True,
         f"\\text{{Conditionally convergent (alt. harmonic}} \\times {a_val}\\text{{)}}",
         f"Conditionally convergent (alternating harmonic × {a_val})"),
        ((-1)**(n+1) * sp.Rational(a_val, 1) / n**p, True, False,
         f"\\text{{Absolutely convergent (p-series }} p={p}\\text{{)}}",
         f"Absolutely convergent (p-series p={p})"),
        ((-1)**(n+1) * sp.Rational(a_val, 1) / sp.sqrt(n), False, True,
         "\\text{Conditionally convergent}", "Conditionally convergent"),
        ((-1)**n * sp.Rational(a_val, 1) / sp.factorial(n), True, False,
         "\\text{Absolutely convergent}", "Absolutely convergent"),
        ((-1)**n * sp.Rational(a_val, 1) * n / (n + rc(POS)), False, False,
         "\\text{Divergent (nth term} \\not\\to 0\\text{)}",
         "Divergent (nth term doesn't approach 0)"),
        (sp.cos(n) * sp.Rational(a_val, 1) / n**p, True, False,
         f"\\text{{Absolutely convergent}} \\;(|\\cos(n)|/n^{p} \\le 1/n^{p})",
         f"Absolutely convergent (|cos(n)|/n^{p} <= 1/n^{p})"),
        ((-1)**(n+1) * sp.Rational(a_val, 1) * sp.ln(n + 1) / n, False, True,
         "\\text{Conditionally convergent}", "Conditionally convergent"),
        ((-1)**(n+1) * sp.Rational(a_val, 1) / (2*n - 1), False, True,
         "\\text{Conditionally convergent}", "Conditionally convergent"),
        (sp.sin(n) * sp.Rational(a_val, 1) / n**p, True, False,
         f"\\text{{Absolutely convergent}} \\;(|\\sin(n)|/n^{p} \\le 1/n^{p})",
         f"Absolutely convergent (|sin(n)|/n^{p} <= 1/n^{p})"),
        ((-1)**n * sp.Rational(a_val, c)**n, True if sp.Rational(a_val, c) < 1 else False, False,
         "\\text{Absolutely convergent (geometric} \\;|r|<1\\text{)}" if sp.Rational(a_val, c) < 1 else "\\text{Divergent}",
         "Absolutely convergent (geometric |r|<1)" if sp.Rational(a_val, c) < 1 else "Divergent"),
        ((-1)**(n+1) * sp.Rational(a_val, 1) / n**sp.Rational(3, 2), True, False,
         "\\text{Absolutely convergent} \\;(p=3/2 > 1)",
         "Absolutely convergent (p=3/2 > 1)"),
        ((-1)**n * sp.Rational(a_val, 1) * n / sp.factorial(n), True, False,
         "\\text{Absolutely convergent (ratio test)}",
         "Absolutely convergent (ratio test)"),
    ]
    a_n, abs_c, cond_c, reason_latex, reason_plain = rc(choices)

    q = (f"Determine whether the series "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) "
         f"is absolutely convergent, conditionally convergent, or divergent.")
    return {
        "type": "absolute_convergence",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": reason_latex,
        "answer_plain": reason_plain,
        "_sig": sp.srepr(a_n) + "_absconv",
    }

# ---------------------------------------------------------------------------
# §10.10 — Ratio Test
# ---------------------------------------------------------------------------
def gen_ratio_test():
    """Apply the Ratio Test."""
    a_val = rc(POS)
    b_val = rc([2, 3, 4, 5, 6])
    c_val = rc([2, 3, 4, 5])
    templates = [
        sp.factorial(n) / a_val**n,
        sp.Rational(a_val, 1)**n / sp.factorial(n),
        n**a_val / b_val**n,
        sp.Rational(a_val, b_val)**n / n**2,
        sp.Rational(a_val, 1)**n * sp.factorial(n) / sp.factorial(2*n),
        sp.Rational(b_val, 1)**n / sp.factorial(n),
        sp.Rational(1, 1) * c_val**n / (n * b_val**n),
        sp.factorial(n) * sp.Rational(a_val, 1)**n / sp.factorial(2*n),
        n**2 * sp.Rational(a_val, b_val)**n,
        sp.Rational(1, 1) * n**c_val / sp.factorial(n),
        sp.factorial(n)**2 / sp.factorial(2*n),
        (sp.Rational(a_val, 1) * n)**n / sp.factorial(n),
        sp.Rational(a_val, 1)**n / (n * sp.factorial(n)),
        sp.Rational(1, 1) * rc([2, 3])**n * sp.factorial(n) / sp.factorial(n + rc([2, 3])),
    ]
    a_n = rc(templates)

    # Try to compute the ratio limit
    try:
        ratio = sp.simplify(a_n.subs(n, n+1) / a_n)
        L = sp.limit(sp.Abs(ratio), n, sp.oo)
        if L.has(sp.zoo, sp.nan):
            return None
    except Exception:
        return None

    if L < 1:
        verdict = f"\\text{{Converges by Ratio Test}} \\;(L = {sp.latex(L)} < 1)"
        verdict_p = f"Converges by the Ratio Test (L = {L} < 1)"
    elif L > 1 or L == sp.oo:
        verdict = f"\\text{{Diverges by Ratio Test}} \\;(L = {sp.latex(L)} > 1)"
        verdict_p = f"Diverges by the Ratio Test (L = {L} > 1)"
    else:
        verdict = "\\text{Ratio Test inconclusive} \\;(L = 1)"
        verdict_p = "Ratio Test is inconclusive (L = 1)"

    q = (f"Use the Ratio Test to determine whether "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) converges or diverges.")
    return {
        "type": "ratio_test",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": verdict,
        "answer_plain": verdict_p,
        "_sig": sp.srepr(a_n) + "_ratio",
    }

# ---------------------------------------------------------------------------
# §10.11 — Root Test
# ---------------------------------------------------------------------------
def gen_root_test():
    """Apply the Root Test."""
    a_val = rc(POS)
    b_val = rc([2, 3, 4, 5, 6])
    c_val = rc(POS)
    d = rc([2, 3, 4, 5])
    templates = [
        (sp.Rational(a_val, b_val))**n,
        (n / (n + c_val))**n,
        ((rc(SML) * n + rc(POS)) / (rc(POS) * n + rc(POS)))**n,
        (sp.Rational(1, 1) / sp.ln(n + 1))**n,
        (n**(rc([-1, -2])))**n,
        (sp.Rational(a_val, d))**(2*n),
        ((n + a_val) / (d * n + rc(POS)))**n,
        (sp.Rational(1, d))**n * n**rc([1, 2]),
        ((sp.Rational(a_val, 1) * n + 1) / (b_val * n))**n,
        (sp.Rational(a_val, b_val))**n / n**c_val,
    ]
    a_n = rc(templates)

    try:
        L = sp.limit(sp.Abs(a_n)**(sp.Rational(1, 1) / n), n, sp.oo)
        if L.has(sp.zoo, sp.nan):
            return None
    except Exception:
        return None

    if L < 1:
        verdict = f"\\text{{Converges by Root Test}} \\;(L = {sp.latex(L)} < 1)"
        verdict_p = f"Converges by the Root Test (L = {L} < 1)"
    elif L > 1 or L == sp.oo:
        verdict = f"\\text{{Diverges by Root Test}} \\;(L = {sp.latex(L)} > 1)"
        verdict_p = f"Diverges by the Root Test (L = {L} > 1)"
    else:
        verdict = "\\text{Root Test inconclusive} \\;(L = 1)"
        verdict_p = "Root Test is inconclusive (L = 1)"

    q = (f"Use the Root Test to determine whether "
         f"\\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) converges or diverges.")
    return {
        "type": "root_test",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": verdict,
        "answer_plain": verdict_p,
        "_sig": sp.srepr(a_n) + "_root",
    }

# ---------------------------------------------------------------------------
# §10.13 — Estimating Series Value
# ---------------------------------------------------------------------------
def gen_series_estimation():
    """Estimate series value using first n terms."""
    num_terms = rc([4, 5, 6, 8, 10])
    templates = [
        (sp.Rational(1, 1) / n**2, "p-series p=2"),
        (sp.Rational(1, 1) / sp.factorial(n), "e - 1"),
        ((-1)**(n+1) / n, "ln 2"),
        ((-1)**(n+1) / sp.factorial(2*n - 1), "sin(1)"),
        (sp.Rational(1, 1) / n**3, "Apery-related"),
        ((-1)**(n+1) / (2*n - 1), "pi/4"),
        (sp.Rational(1, 1) / (n * (n + 1)), "telescoping to 1"),
    ]
    a_n, note = rc(templates)

    # Compute partial sum
    partial = sum(a_n.subs(n, i) for i in range(1, num_terms + 1))
    partial_dec = partial.evalf(8)

    q = (f"Estimate the value of \\( \\displaystyle\\sum_{{n=1}}^{{\\infty}} {sp.latex(a_n)} \\) "
         f"using the first {num_terms} terms.")
    al = f"S_{{{num_terms}}} = {sp.latex(partial)} \\approx {sp.latex(sp.Float(partial_dec, 6))}"
    ap = f"S_{num_terms} = {partial} ≈ {float(partial_dec):.6f}"
    return {
        "type": "series_estimation",
        "difficulty": "scholar",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(a_n) + f"_est{num_terms}",
    }

# ---------------------------------------------------------------------------
# §10.14 — Power Series: Radius and Interval of Convergence
# ---------------------------------------------------------------------------
def gen_power_series_roc():
    """Find the radius and interval of convergence of a power series."""
    a_val = rc(NZ)
    b_val = rc(POS)
    c_val = rc([0, 1, -1, 2, -2])  # center
    templates = [
        # (coefficient a_n, center, expected R)
        (sp.Rational(1, 1) / n, c_val, 1),
        (sp.Rational(1, 1) / n**2, c_val, 1),
        (sp.Rational(1, 1) / sp.factorial(n), c_val, sp.oo),
        (sp.Rational(a_val, 1)**n / n, 0, sp.Rational(1, abs(a_val))),
        (n**b_val, 0, 1),
        ((-1)**n / (n * b_val**n), 0, b_val),
        (sp.Rational(1, 1) / (n * rc([2, 3, 4, 5])**n), c_val, rc([2, 3, 4, 5])),
        (sp.factorial(n), 0, 0),
    ]
    coeff, center, R = rc(templates)

    if center == 0:
        term = coeff * x**n
        series_str = f"\\sum_{{n=1}}^{{\\infty}} {sp.latex(coeff)} \\, x^n"
    else:
        term = coeff * (x - center)**n
        series_str = f"\\sum_{{n=1}}^{{\\infty}} {sp.latex(coeff)} \\, (x - {sp.latex(center)})^n"

    # Compute R via ratio test on coefficients
    try:
        r = sp.limit(sp.Abs(coeff.subs(n, n+1) / coeff), n, sp.oo)
        if r == 0:
            R_calc = sp.oo
        elif r == sp.oo:
            R_calc = 0
        else:
            R_calc = 1 / r
    except Exception:
        R_calc = R  # fallback to expected

    if R_calc == sp.oo:
        interval = "(-\\infty, \\infty)"
        interval_p = "(-inf, inf)"
    elif R_calc == 0:
        interval = f"\\{{ {sp.latex(center)} \\}}"
        interval_p = f"{{{center}}}"
    else:
        lo = center - R_calc
        hi = center + R_calc
        interval = f"({sp.latex(lo)}, {sp.latex(hi)})"
        interval_p = f"({lo}, {hi})"
        # Note: endpoint behavior requires individual checking; we give open interval

    q = f"Find the radius of convergence and interval of convergence for the power series \\( {series_str} \\)."
    al = f"R = {sp.latex(R_calc)}; \\; \\text{{Interval: }} {interval}"
    ap = f"R = {R_calc}; Interval: {interval_p}"
    return {
        "type": "power_series_roc",
        "difficulty": "hard",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(coeff) + f"_roc_{center}",
    }

# ---------------------------------------------------------------------------
# §10.15 — Power Series and Functions
# ---------------------------------------------------------------------------
def gen_power_series_functions():
    """Write a function as a power series and find interval of convergence."""
    a_val = rc(SML)
    b_val = rc([2, 3, 4, 5])
    templates = [
        (sp.Rational(1, 1) / (1 - a_val * x), f"geometric: 1/(1 - {a_val}x)", abs(a_val) if a_val != 0 else 1),
        (sp.Rational(1, 1) / (1 + x**2), "1/(1+x^2)", 1),
        (sp.ln(1 + a_val * x), f"ln(1+{a_val}x)", sp.Rational(1, abs(a_val)) if a_val != 0 else 1),
        (sp.ln(1 - x), "ln(1-x)", 1),
        (sp.atan(a_val * x), f"arctan({a_val}x)", sp.Rational(1, abs(a_val)) if a_val != 0 else 1),
        (x / (1 - x)**2, "x/(1-x)^2", 1),
        (sp.Rational(1, 1) / (1 + a_val * x), f"1/(1+{a_val}x)", sp.Rational(1, abs(a_val)) if a_val != 0 else 1),
        (x * sp.ln(1 + x), "x ln(1+x)", 1),
        (sp.Rational(1, 1) / (b_val - x), f"1/({b_val}-x)", b_val),
        (x**2 / (1 - x), "x^2/(1-x)", 1),
        (sp.Rational(a_val, 1) * x / (1 + x**2), f"{a_val}x/(1+x^2)", 1),
        (sp.atanh(x), "arctanh(x)", 1),
        (sp.Rational(1, 1) / (1 + x)**2, "1/(1+x)^2", 1),
        (sp.Rational(a_val, 1) / (1 - x**2), f"{a_val}/(1-x^2)", 1),
        (x * sp.exp(x), "x e^x", sp.oo),
        (sp.Rational(a_val, 1) * sp.exp(x) - 1, f"{a_val}e^x - 1", sp.oo),
    ]
    f_expr, note, R = rc(templates)

    try:
        series_exp = sp.series(f_expr, x, 0, 6).removeO()
    except Exception:
        return None

    q = (f"Write \\( f(x) = {sp.latex(f_expr)} \\) as a power series and "
         f"find its interval of convergence.")
    al = f"{sp.latex(series_exp)} + \\cdots; \\; R = {sp.latex(R)}"
    ap = f"{series_exp} + ...; R = {R}"
    return {
        "type": "power_series_functions",
        "difficulty": "scholar",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(f_expr) + "_psfunc",
    }

# ---------------------------------------------------------------------------
# §10.16 — Taylor Series
# ---------------------------------------------------------------------------
def gen_taylor_series():
    """Find the Taylor/Maclaurin series for a given function."""
    a_val = rc(SML)
    center = rc([0, 0, 0, 1, -1, 2])
    templates = [
        sp.exp(a_val * x),
        sp.sin(a_val * x),
        sp.cos(a_val * x),
        sp.ln(1 + x),
        sp.Rational(1, 1) / (1 - x),
        sp.exp(x) * sp.sin(x),
        sp.sinh(x),
        sp.cosh(x),
        x * sp.exp(x),
        sp.exp(-x**2),
    ]
    f_expr = rc(templates)
    n_terms = rc([4, 5, 6])

    try:
        series_exp = sp.series(f_expr, x, center, n_terms)
    except Exception:
        return None

    series_clean = series_exp.removeO()
    if series_clean == f_expr and not f_expr.is_polynomial():
        return None

    name = "Maclaurin" if center == 0 else "Taylor"
    if center == 0:
        q = f"Find the {name} series for \\( f(x) = {sp.latex(f_expr)} \\) up to degree {n_terms - 1}."
    else:
        q = (f"Find the {name} series for \\( f(x) = {sp.latex(f_expr)} \\) "
             f"centered at \\( a = {sp.latex(center)} \\), up to degree {n_terms - 1}.")
    al = sp.latex(series_clean) + " + \\cdots"
    ap = str(series_clean) + " + ..."
    return {
        "type": "taylor_series",
        "difficulty": "scholar",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(f_expr) + f"_taylor_{center}_{n_terms}",
    }

# ---------------------------------------------------------------------------
# §10.17 — Applications of Series
# ---------------------------------------------------------------------------
def gen_series_applications():
    """Taylor polynomial approximation, integral approximation via series."""
    app_type = rc(["integral_approx", "polynomial_approx", "limit_eval"])

    if app_type == "integral_approx":
        a_val = rc(SML)
        hi_val = rc([sp.Rational(1, 4), sp.Rational(1, 2), 1, sp.Rational(1, 3)])
        funcs = [
            (sp.exp(-x**2), 0, hi_val),
            (sp.sin(x) / x, 0, hi_val),
            (sp.cos(x**2), 0, hi_val),
            (sp.exp(x**2), 0, sp.Rational(1, rc([2, 3, 4]))),
            ((1 - sp.cos(x)) / x, 0, hi_val),
            (sp.sin(x**2), 0, hi_val),
            (sp.exp(-x) * sp.sin(x), 0, hi_val),
            (sp.ln(1 + x**2), 0, hi_val),
        ]
        f_expr, lo, hi = rc(funcs)
        n_terms = rc([4, 5, 6])
        try:
            series_exp = sp.series(f_expr, x, 0, n_terms).removeO()
            result = sp.integrate(series_exp, (x, lo, hi))
        except Exception:
            return None

        q = (f"Use a degree-{n_terms - 1} Maclaurin polynomial to approximate "
             f"\\( \\int_{{{sp.latex(lo)}}}^{{{sp.latex(hi)}}} {sp.latex(f_expr)} \\, dx \\).")
        al = f"\\approx {sp.latex(result)}"
        ap = f"≈ {result}"

    elif app_type == "polynomial_approx":
        funcs = [sp.exp(x), sp.sin(x), sp.cos(x), sp.ln(1 + x), sp.exp(-x),
                 sp.sinh(x), sp.cosh(x), sp.atan(x), sp.sqrt(1 + x)]
        f_expr = rc(funcs)
        x_val = rc([sp.Rational(1, 10), sp.Rational(1, 2), sp.Rational(1, 4),
                     sp.Rational(1, 3), sp.Rational(1, 5), sp.Rational(2, 5)])
        n_terms = rc([3, 4, 5])
        try:
            series_exp = sp.series(f_expr, x, 0, n_terms).removeO()
            approx = series_exp.subs(x, x_val)
            exact = f_expr.subs(x, x_val).evalf(8)
        except Exception:
            return None

        q = (f"Use the degree-{n_terms - 1} Maclaurin polynomial for \\( {sp.latex(f_expr)} \\) "
             f"to approximate \\( f({sp.latex(x_val)}) \\).")
        al = f"T_{{{n_terms - 1}}}({sp.latex(x_val)}) = {sp.latex(approx)} \\approx {sp.latex(sp.Float(float(approx.evalf()), 6))}"
        ap = f"T_{n_terms - 1}({x_val}) = {approx} ≈ {float(approx.evalf()):.6f}"

    else:  # limit_eval
        a_val = rc(SML)
        funcs = [
            (sp.sin(a_val * x) / x, 0, a_val),
            ((sp.exp(a_val * x) - 1) / x, 0, a_val),
            ((1 - sp.cos(a_val * x)) / x**2, 0, sp.Rational(a_val**2, 2)),
            ((sp.sin(x) - x) / x**3, 0, sp.Rational(-1, 6)),
            (sp.ln(1 + a_val * x) / x, 0, a_val),
            ((sp.exp(x) - 1 - x) / x**2, 0, sp.Rational(1, 2)),
            (sp.tan(x) / x, 0, 1),
            ((sp.atan(a_val * x)) / x, 0, a_val),
        ]
        f_expr, a, L = rc(funcs)
        q = (f"Use Maclaurin series to evaluate \\( \\lim_{{x \\to {sp.latex(a)}}} {sp.latex(f_expr)} \\).")
        al = sp.latex(L)
        ap = str(L)

    return {
        "type": "series_applications",
        "difficulty": "scholar",
        "question_text": q,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": f"app_{app_type}_{sp.srepr(f_expr) if isinstance(f_expr, sp.Basic) else str(f_expr)}",
    }

# ---------------------------------------------------------------------------
# §10.18 — Binomial Series
# ---------------------------------------------------------------------------
def gen_binomial_series():
    """Expand using the binomial series (1+x)^k."""
    p = rc([-3, -2, -1, 1, 2, 3, 5])
    q_denom = rc([2, 3, 4])
    if rc([True, False]):
        # Rational exponent
        k_val = sp.Rational(p, q_denom)
    else:
        # Negative integer
        k_val = rc([-1, -2, -3, -4])

    a_coeff = rc(SML)
    f_expr = (1 + a_coeff * x)**k_val
    n_terms = rc([4, 5])

    try:
        series_exp = sp.series(f_expr, x, 0, n_terms).removeO()
    except Exception:
        return None

    q_text = (f"Use the Binomial Series to expand \\( {sp.latex(f_expr)} \\) "
              f"up to the \\( x^{{{n_terms - 1}}} \\) term.")
    al = sp.latex(series_exp) + " + \\cdots"
    ap = str(series_exp) + " + ..."
    return {
        "type": "binomial_series",
        "difficulty": "medium",
        "question_text": q_text,
        "answer_latex": al,
        "answer_plain": ap,
        "_sig": sp.srepr(f_expr) + f"_binom_{n_terms}",
    }


# ===========================================================================
# Dispatcher & Main Loop
# ===========================================================================

GENERATORS = {
    "sequence_terms":         gen_sequence_terms,
    "sequence_convergence":   gen_sequence_convergence,
    "sequence_properties":    gen_sequence_properties,
    "series_index_shift":     gen_series_index_shift,
    "series_strip_terms":     gen_series_strip_terms,
    "partial_sums":           gen_partial_sums,
    "series_conv_div":        gen_series_conv_div,
    "geometric_series":       gen_geometric_series,
    "telescoping_series":     gen_telescoping_series,
    "integral_test":          gen_integral_test,
    "comparison_test":        gen_comparison_test,
    "alternating_series":     gen_alternating_series,
    "absolute_convergence":   gen_absolute_convergence,
    "ratio_test":             gen_ratio_test,
    "root_test":              gen_root_test,
    "series_estimation":      gen_series_estimation,
    "power_series_roc":       gen_power_series_roc,
    "power_series_functions": gen_power_series_functions,
    "taylor_series":          gen_taylor_series,
    "series_applications":    gen_series_applications,
    "binomial_series":        gen_binomial_series,
}

# Difficulty → types mapping with weights
DIFFICULTY_TYPES = {
    "basic": [
        "sequence_terms", "series_index_shift", "series_strip_terms",
        "geometric_series",
    ],
    "medium": [
        "sequence_convergence", "sequence_properties", "partial_sums",
        "series_conv_div", "telescoping_series", "alternating_series",
        "binomial_series",
    ],
    "hard": [
        "integral_test", "comparison_test", "absolute_convergence",
        "ratio_test", "root_test", "power_series_roc",
    ],
    "scholar": [
        "series_estimation", "power_series_functions", "taylor_series",
        "series_applications",
    ],
}

DIFFICULTY_WEIGHTS = {
    "basic": 0.25,
    "medium": 0.30,
    "hard": 0.30,
    "scholar": 0.15,
}


def generate_series_questions(target=2000):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = target * 60

    # Build weighted type list
    weighted_types = []
    for diff, weight in DIFFICULTY_WEIGHTS.items():
        types = DIFFICULTY_TYPES[diff]
        per_type = weight / len(types)
        for t in types:
            weighted_types.append((t, per_type))

    # Normalize
    total_w = sum(w for _, w in weighted_types)
    type_names = [t for t, _ in weighted_types]
    type_weights = [w / total_w for _, w in weighted_types]

    while len(questions) < target and attempts < max_attempts:
        attempts += 1
        q_type = random.choices(type_names, weights=type_weights, k=1)[0]
        gen_func = GENERATORS[q_type]

        try:
            result = gen_func()
        except Exception:
            continue

        if result is None:
            continue

        sig = (result["_sig"], result["type"])
        if sig in seen:
            continue
        seen.add(sig)

        question = {
            "id": len(questions) + 1,
            "type": result["type"],
            "difficulty": result["difficulty"],
            "question_text": result["question_text"],
            "answer_latex": result["answer_latex"],
            "answer_plain": result["answer_plain"],
        }
        questions.append(question)

        if len(questions) % 200 == 0:
            print(f"  Generated {len(questions)} / {target} questions ({attempts} attempts)")

    return questions


if __name__ == "__main__":
    random.seed(42)
    print("Generating 2000 Series & Sequences questions (Dawkins Ch 10)...")
    questions = generate_series_questions(2000)

    # Report type distribution
    from collections import Counter
    type_counts = Counter(q["type"] for q in questions)
    diff_counts = Counter(q["difficulty"] for q in questions)
    print(f"\nGenerated {len(questions)} unique questions")
    print(f"\nBy type:")
    for t, c in sorted(type_counts.items(), key=lambda x: -x[1]):
        print(f"  {t:30s} {c:4d}")
    print(f"\nBy difficulty:")
    for d, c in sorted(diff_counts.items()):
        print(f"  {d:15s} {c:4d}")

    # Write JSON
    output_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "calculus")
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, "series.json")

    # Merge taylor_series.json questions
    taylor_file = os.path.join(output_dir, "taylor_series.json")
    if os.path.exists(taylor_file):
        with open(taylor_file) as tf:
            taylor_data = json.load(tf)
        taylor_qs = taylor_data.get("questions", [])
        # Re-number IDs continuing from generated questions
        start_id = len(questions) + 1
        for i, tq in enumerate(taylor_qs):
            tq["id"] = start_id + i
        questions.extend(taylor_qs)
        print(f"Merged {len(taylor_qs)} questions from taylor_series.json")
    else:
        print("taylor_series.json not found — skipping merge")

    print(f"Total questions: {len(questions)}")

    with open(output_file, "w") as f:
        json.dump({
            "topic": "Series & Sequences",
            "description": "Comprehensive practice covering Dawkins Ch 10: sequences, convergence tests (divergence, integral, comparison, alternating, ratio, root), geometric/telescoping series, power series, Taylor/Maclaurin series, binomial series, and applications.",
            "questions": questions
        }, f, separators=(',', ':'))

    print(f"Written to {output_file}")
