#!/usr/bin/env python3.11
"""
POC v2 — feed RAW LaTeX from MathLive straight into sympy.parsing.latex.
No JS-side latexToAscii conversion needed.  This mirrors the
integral-calculator architecture (math/partials/integral-calculator-
scripts.jsp:478 → parseIntegralViaBackend) which already proves the
pattern works in production.

Inputs are the exact LaTeX strings MathLive emits — i.e. the same
strings the user reported as causing 500s before.  We send them
unchanged to parse_latex.

Run:   python3.11 sympy-latex-poc.py

If parse_latex accepts >= ~95 % of these, the right architecture for
trig is:
    MathLive → raw LaTeX → /OneCompilerFunctionality?action=execute
        → parse_latex → solveset / simplify / evaluate → JSON
... and the entire latexToAscii pipeline becomes dead code (or at most,
a fallback for environments where parse_latex isn't available).
"""
from __future__ import annotations

import re
import time

import sympy as sp
from sympy import (
    Symbol, sin, cos, tan, csc, sec, cot, asin, acos, atan,
    sinh, cosh, tanh, pi, sqrt, simplify, trigsimp, expand_trig,
    solveset, S, Eq, Equality, Unequality, Reals, oo,
    GreaterThan, LessThan, StrictGreaterThan, StrictLessThan,
)
from sympy.parsing.latex import parse_latex

x = Symbol("x", real=True)
y = Symbol("y", real=True)
A = Symbol("A", real=True)
B = Symbol("B", real=True)


def strip_sizing(latex: str) -> str:
    """Pre-pass — same trick the integral calculator uses.  parse_latex
    can't handle \\left( \\right) or \\Big* sizing decorations, so we
    drop them before parsing.  Nothing else is touched."""
    s = latex
    s = re.sub(r"\\left\s*([({\[|])", r"\1", s)
    s = re.sub(r"\\right\s*([)}\]|])", r"\1", s)
    s = re.sub(r"\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr|big|Big)\s*", "", s)
    return s


# parse_latex creates pi/e/infty as plain Symbols rather than the
# real SymPy constants — substitute back so simplify/evaluate work.
LATEX_CONST_MAP = {
    Symbol("pi"):     sp.pi,
    Symbol("Pi"):     sp.pi,
    Symbol("e"):      sp.E,
    Symbol("E"):      sp.E,
    Symbol("infty"):  sp.oo,
    Symbol("infinity"): sp.oo,
    Symbol("oo"):     sp.oo,
}


def try_parse(latex: str):
    """Mirror integral calc's two-pass parse_latex: default backend
    first, lark fallback for ambiguous grammars.  Then substitute the
    well-known constants parse_latex leaves as plain Symbols."""
    cleaned = strip_sizing(latex)
    try:
        node = parse_latex(cleaned)
    except Exception:
        node = parse_latex(cleaned, backend="lark")
    return node.subs(LATEX_CONST_MAP)


def pick_solve_var(parsed) -> Symbol:
    """Pick the variable to solve for from the parsed expression.
    Prefer 'x', else first remaining free symbol, else fall back."""
    free = parsed.free_symbols
    if not free:
        return Symbol("x", real=True)
    by_name = {str(s): s for s in free}
    return by_name.get("x", next(iter(free)))


def solve_trig(latex: str):
    """Equation / inequality / simplify / evaluate router.
    Decides the operation from the parsed sympy node type — no JS-side
    inspection of '=' or '>' needed."""
    parsed = try_parse(latex)

    # Equation → solveset over reals (returns ImageSet for periodic sols)
    if isinstance(parsed, Equality):
        var = pick_solve_var(parsed)
        return ("solve",
                solveset(parsed.lhs - parsed.rhs, var, domain=S.Reals))

    # Inequality → solveset gives Interval / Union of intervals
    if isinstance(parsed, (StrictGreaterThan, StrictLessThan,
                           GreaterThan, LessThan, Unequality)):
        var = pick_solve_var(parsed)
        return ("inequality",
                sp.solveset(parsed, var, domain=S.Reals))

    # Pure expression — try simplify / numeric evaluate
    if not parsed.free_symbols:
        # Constant expression — evaluate exactly
        return ("evaluate", sp.nsimplify(parsed,
                                          [pi, sqrt(2), sqrt(3), sqrt(5)],
                                          rational=False))
    # Symbolic expression — multi-strategy simplify
    candidates = [
        parsed,
        trigsimp(parsed),
        simplify(parsed),
        trigsimp(simplify(parsed)),
        simplify(expand_trig(parsed)),
        trigsimp(expand_trig(parsed)),
        sp.fu(parsed),
    ]
    best = min(candidates, key=lambda c: (sp.count_ops(c), len(str(c))))
    return ("simplify", best)


# ─── Test cases — RAW LaTeX as MathLive would emit ─────────────────
# These are the exact strings the user reported as 500s, plus the
# broader student/teacher suite.
CASES = [
    # ── User's original 4 reports ──
    (r"\sin\left(2x\right)=\cos\left(x\right)",                                    "user 1"),
    (r"2\cos\left(x\right)^2-1=0",                                                 "user 2"),
    (r"\sin\left(x\right)>\frac{1}{2}",                                            "user 3"),
    (r"\frac{\sin\left(x\right)^4-\cos\left(x\right)^4}"
     r"{\sin\left(x\right)^2-\cos\left(x\right)^2}",                               "user 4"),

    # ── Equations ──
    (r"\sin\left(x\right)=\frac{1}{2}",                                            "eq sin=1/2"),
    (r"\cos\left(x\right)=\frac{\sqrt{3}}{2}",                                     "eq cos=√3/2"),
    (r"\tan\left(x\right)=\sqrt{3}",                                               "eq tan=√3"),
    (r"\sin\left(x\right)+\cos\left(x\right)=1",                                   "eq sin+cos=1"),
    (r"\sin\left(x\right)=2",                                                      "eq no-solution"),
    (r"\sin^2\left(x\right)+\cos^2\left(x\right)=1",                               "eq pythagorean"),

    # ── Inequalities ──
    (r"\cos\left(x\right)\le 0",                                                   "ineq cos≤0"),
    (r"\tan\left(x\right)\ge 1",                                                   "ineq tan≥1"),
    (r"\sin\left(x\right)>2",                                                      "ineq no-solution"),

    # ── Simplification ──
    (r"\sin^2\left(x\right)+\cos^2\left(x\right)",                                 "simp pyth"),
    (r"1+\tan^2\left(x\right)",                                                    "simp 1+tan²"),
    (r"2\sin\left(x\right)\cos\left(x\right)",                                     "simp 2sincos"),
    (r"\frac{1-\cos\left(2x\right)}{\sin\left(2x\right)}",                         "simp half-angle"),
    (r"\cos\left(2x\right)+\sin\left(2x\right)\tan\left(x\right)",                 "simp double-angle"),

    # ── Evaluate (constant expressions) ──
    (r"\sin\left(\frac{\pi}{6}\right)",                                            "eval sin(π/6)"),
    (r"\cos\left(\frac{\pi}{3}\right)",                                            "eval cos(π/3)"),
    (r"\tan\left(\frac{\pi}{4}\right)",                                            "eval tan(π/4)"),
    (r"\sin\left(\frac{2\pi}{3}\right)",                                           "eval sin(2π/3)"),
    (r"\sqrt{3}/2",                                                                 "eval √3/2"),
    (r"\frac{\sqrt{2}}{2}",                                                        "eval √2/2"),

    # ── Composed inverse trig ──
    (r"\sin\left(\arccos\left(x\right)\right)",                                    "inv sin(arccos x)"),
    (r"\cos\left(\arctan\left(x\right)\right)",                                    "inv cos(arctan x)"),

    # ── Higher-degree polynomials (triple angle) ──
    (r"4\sin^3\left(x\right)-3\sin\left(x\right)",                                 "triple sin(3x)"),
    (r"4\cos^3\left(x\right)-3\cos\left(x\right)",                                 "triple cos(3x)"),

    # ── Hyperbolic ──
    (r"\cosh^2\left(x\right)-\sinh^2\left(x\right)",                               "hyperbolic"),

    # ── The smart-mode mangle case (with my MathLive shortcut, this
    #    shouldn't happen anymore — but if it did, parse_latex would
    #    correctly read \in as set-membership and reject it.) ──
    # (Skipped — handled at the MathLive layer via inlineShortcuts.)
]


# ─── Run & summarise ───────────────────────────────────────────────
def main() -> int:
    print("═" * 72)
    print(f"  parse_latex POC — SymPy {sp.__version__} on Py {sp.__version__}")
    print("  Architecture: raw LaTeX → parse_latex → solveset/simplify")
    print("═" * 72)

    results = []
    total_ms = 0.0

    for latex, label in CASES:
        t0 = time.perf_counter()
        try:
            kind, out = solve_trig(latex)
            ok = True
            err = None
        except Exception as e:
            kind, out, ok, err = "—", None, False, type(e).__name__ + ": " + str(e)
        elapsed = (time.perf_counter() - t0) * 1000.0
        total_ms += elapsed
        results.append((label, latex, kind, out, ok, err, elapsed))

    # Print
    pass_count = sum(1 for r in results if r[4])
    for label, latex, kind, out, ok, err, ms in results:
        mark = "✓" if ok else "✗"
        print(f"  {mark}  [{ms:6.1f}ms] {kind:>10}  {label}")
        print(f"           in:  {latex}")
        print(f"           out: {err if err else _short(out)}")

    print("\n" + "═" * 72)
    print(f"COVERAGE: {pass_count}/{len(results)} ({pass_count/len(results)*100:.0f}%)")
    print(f"TOTAL: {total_ms:.0f}ms  (avg {total_ms/len(results):.1f}ms/case)")
    print("═" * 72)
    return 0 if pass_count == len(results) else 1


def _short(o):
    if o is None:
        return "—"
    s = str(o)
    return s if len(s) < 90 else s[:87] + "…"


if __name__ == "__main__":
    raise SystemExit(main())
