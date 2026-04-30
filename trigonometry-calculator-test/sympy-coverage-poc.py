#!/usr/bin/env python3.11
"""
Quick POC — how much of the trig calculator workload can SymPy handle
deterministically, with no LLM in the loop?

Premise: the existing flow sends cleaned-ASCII expressions to a
Cloudflare LLM worker.  But for routine problems, SymPy is faster,
deterministic, and free.  This POC measures coverage:

  · For each input the student/teacher might type (post-latexToAscii),
    try SymPy first.  If SymPy returns a closed-form solution / a
    simplified expression / "no solution", count it as covered.
  · Report category-by-category coverage so we see where SymPy succeeds
    on its own and where the AI is genuinely earning its place.

Run:   python3.11 sympy-coverage-poc.py

Categories mirror the JS test suite (trig-input-sanitize-test.js).
"""
from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Callable

import sympy as sp
from sympy import (
    Symbol, sin, cos, tan, csc, sec, cot,
    sinh, cosh, tanh, asin, acos, atan,
    pi, sqrt, simplify, trigsimp, solveset, S, Interval, Eq, oo,
)
from sympy.parsing.sympy_parser import (
    parse_expr,
    standard_transformations,
    implicit_multiplication_application,
    convert_xor,
)


# ─── Parsing helper ─────────────────────────────────────────────────
# `implicit_multiplication_application` lets students write `2x` instead
# of `2*x`, and `convert_xor` accepts `^` as exponent (the calculator's
# native syntax) instead of `**`.
TRANSFORMS = standard_transformations + (
    implicit_multiplication_application,
    convert_xor,
)
LOCALS = {
    "sin": sin, "cos": cos, "tan": tan,
    "csc": csc, "sec": sec, "cot": cot,
    "sinh": sinh, "cosh": cosh, "tanh": tanh,
    "arcsin": asin, "arccos": acos, "arctan": atan,
    "asin": asin, "acos": acos, "atan": atan,
    "sqrt": sqrt, "pi": pi, "oo": oo,
}

x = Symbol("x", real=True)
LOCALS["x"] = x


def parse(expr: str):
    return parse_expr(
        expr,
        local_dict=LOCALS,
        transformations=TRANSFORMS,
        evaluate=True,
    )


# ─── Solvers ────────────────────────────────────────────────────────
def solve_equation(expr: str, var: Symbol = x):
    """`f(x) = g(x)` → solveset over reals."""
    if "=" not in expr:
        raise ValueError("Not an equation (no `=`)")
    lhs_s, rhs_s = expr.split("=", 1)
    lhs, rhs = parse(lhs_s), parse(rhs_s)
    return solveset(Eq(lhs, rhs), var, domain=S.Reals)


def solve_inequality(expr: str, var: Symbol = x):
    """`f(x) > g(x)` → solveset over reals."""
    for op in (">=", "<=", "!=", ">", "<"):
        if op in expr:
            lhs_s, rhs_s = expr.split(op, 1)
            lhs, rhs = parse(lhs_s), parse(rhs_s)
            relmap = {">=": sp.GreaterThan, "<=": sp.LessThan,
                      "!=": sp.Unequality, ">": sp.StrictGreaterThan,
                      "<": sp.StrictLessThan}
            return sp.solveset(relmap[op](lhs, rhs), var, domain=S.Reals)
    raise ValueError("Not an inequality")


def simplify_expr(expr: str):
    """Multi-strategy simplifier — tries several SymPy passes and
    returns the shortest result.  Catches forms that single-pass
    `trigsimp` misses (e.g. cos(2x)+sin(2x)*tan(x) needs expand_trig
    before trigsimp can collapse it to 1)."""
    e = parse(expr)
    candidates = [
        e,
        trigsimp(e),
        simplify(e),
        trigsimp(simplify(e)),
        simplify(sp.expand_trig(e)),
        trigsimp(sp.expand_trig(e)),
        sp.fu(e),                       # Fu's heuristic trig simplification
    ]
    # Return the candidate with the shortest string repr (a decent
    # proxy for "most simplified"); ties broken by node count.
    return min(candidates, key=lambda c: (sp.count_ops(c), len(str(c))))


def evaluate(expr: str, unit: str = "deg"):
    """Evaluate sin(45) / cos(pi/3) etc. — handles deg ↔ rad conversion."""
    e = parse(expr)
    if unit == "deg":
        # Walk the tree and replace any `func(x)` where x is a number with
        # `func(x * pi/180)` so SymPy interprets it as degrees.
        def to_rad(node):
            if isinstance(node, (sin, cos, tan, csc, sec, cot)):
                arg = node.args[0]
                if arg.is_number:
                    return node.func(arg * pi / 180)
            return node
        e = e.replace(lambda n: isinstance(n, (sin, cos, tan, csc, sec, cot)),
                      to_rad)
    return sp.nsimplify(e, [pi, sqrt(2), sqrt(3)], rational=False)


# ─── Test runner ────────────────────────────────────────────────────
@dataclass
class Case:
    label: str
    expr: str
    solver: Callable[[str], object]
    expected_check: Callable[[object], bool] | None = None  # optional sanity check

@dataclass
class Result:
    case: Case
    output: object
    ok: bool
    elapsed_ms: float
    error: str | None = None


def run(case: Case) -> Result:
    t0 = time.perf_counter()
    try:
        out = case.solver(case.expr)
        ok = True
        if case.expected_check is not None:
            ok = case.expected_check(out)
        return Result(case, out, ok, (time.perf_counter() - t0) * 1000.0)
    except Exception as e:
        return Result(case, None, False, (time.perf_counter() - t0) * 1000.0, str(e))


# ─── Test cases — mirror the JS test suite categories ──────────────
# All inputs are POST-latexToAscii (the form the server actually sees
# today).  These are what students/teachers type into the trig calc.
CASES = [
    # ── EQUATIONS ──
    Case("eq: sin(x)=1/2",                          "sin(x)=1/2",                         solve_equation),
    Case("eq: cos(x)=sqrt(3)/2",                    "cos(x)=sqrt(3)/2",                   solve_equation),
    Case("eq: tan(x)=1",                            "tan(x)=1",                           solve_equation),
    Case("eq: tan(x)=sqrt(3)",                      "tan(x)=sqrt(3)",                     solve_equation),
    Case("eq: 2cos(x)^2-1=0",                       "2cos(x)^2-1=0",                      solve_equation),
    Case("eq: sin(2x)=cos(x)",                      "sin(2x)=cos(x)",                     solve_equation),
    Case("eq: sin(x)+cos(x)=1",                     "sin(x)+cos(x)=1",                    solve_equation),
    Case("eq: sin(x)^2+cos(x)^2=1 (identity)",      "sin(x)^2+cos(x)^2=1",                solve_equation),
    Case("eq: sin(x)=2 (no solution)",              "sin(x)=2",                           solve_equation),
    Case("eq: 2sin(x)*cos(x)=1/2",                  "2*sin(x)*cos(x)=1/2",                solve_equation),
    Case("eq: 4sin(x)^3-3sin(x)=sin(3x)",           "4*sin(x)^3-3*sin(x)=sin(3*x)",       solve_equation),
    Case("eq: tan(x)+cot(x)=2",                     "tan(x)+cot(x)=2",                    solve_equation),
    Case("eq: cos(2x)=1-2sin(x)^2 (identity)",      "cos(2x)=1-2*sin(x)^2",               solve_equation),

    # ── INEQUALITIES ──
    Case("ineq: sin(x)>1/2",                        "sin(x)>1/2",                         solve_inequality),
    Case("ineq: cos(x)<=0",                         "cos(x)<=0",                          solve_inequality),
    Case("ineq: tan(x)>=1",                         "tan(x)>=1",                          solve_inequality),
    Case("ineq: sin(x)>2 (no solution)",            "sin(x)>2",                           solve_inequality),
    Case("ineq: 2sin(x)+1>0",                       "2*sin(x)+1>0",                       solve_inequality),

    # ── SIMPLIFY ──
    Case("simp: sin(x)^2+cos(x)^2",                 "sin(x)^2+cos(x)^2",                  simplify_expr,
         expected_check=lambda r: r == 1),
    Case("simp: 1+tan(x)^2",                        "1+tan(x)^2",                         simplify_expr,
         expected_check=lambda r: simplify(r - sec(x)**2) == 0),
    Case("simp: sec(x)^2-1",                        "sec(x)^2-1",                         simplify_expr,
         expected_check=lambda r: simplify(r - tan(x)**2) == 0),
    Case("simp: 2sin(x)cos(x)",                     "2*sin(x)*cos(x)",                    simplify_expr,
         expected_check=lambda r: simplify(r - sin(2*x)) == 0),
    Case("simp: (sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)", "(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)",
         simplify_expr, expected_check=lambda r: simplify(r - 1) == 0),
    Case("simp: sin(x)^4+cos(x)^4",                 "sin(x)^4+cos(x)^4",                  simplify_expr),
    Case("simp: tan(x)^2-sin(x)^2 vs tan(x)^2 sin(x)^2",
         "tan(x)^2-sin(x)^2",                       simplify_expr,
         expected_check=lambda r: simplify(r - tan(x)**2 * sin(x)**2) == 0),
    Case("simp: (1-cos(2x))/sin(2x) vs tan(x)",
         "(1-cos(2*x))/sin(2*x)",                   simplify_expr,
         expected_check=lambda r: simplify(r - tan(x)) == 0),
    Case("simp: cos(2x)+sin(2x)*tan(x)",            "cos(2*x)+sin(2*x)*tan(x)",           simplify_expr,
         expected_check=lambda r: simplify(r - 1) == 0),

    # ── EVALUATE (special angles) ──
    Case("eval: sin(45°)=√2/2",                     "sin(45)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == sqrt(2)/2),
    Case("eval: cos(60°)=1/2",                      "cos(60)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == sp.Rational(1, 2)),
    Case("eval: tan(60°)=√3",                       "tan(60)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == sqrt(3)),
    Case("eval: sin(30°)=1/2",                      "sin(30)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == sp.Rational(1, 2)),
    Case("eval: cos(pi/3)=1/2",                     "cos(pi/3)",      lambda e: evaluate(e, "rad"),
         expected_check=lambda r: r == sp.Rational(1, 2)),
    Case("eval: tan(pi/4)=1",                       "tan(pi/4)",      lambda e: evaluate(e, "rad"),
         expected_check=lambda r: r == 1),
    Case("eval: sin(pi/6)=1/2",                     "sin(pi/6)",      lambda e: evaluate(e, "rad"),
         expected_check=lambda r: r == sp.Rational(1, 2)),
    Case("eval: csc(30°)=2",                        "csc(30)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == 2),
    Case("eval: sec(60°)=2",                        "sec(60)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == 2),
    Case("eval: cot(45°)=1",                        "cot(45)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == 1),
    Case("eval: sin(0)=0",                          "sin(0)",         lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == 0),
    Case("eval: sin(90°)=1",                        "sin(90)",        lambda e: evaluate(e, "deg"),
         expected_check=lambda r: r == 1),

    # ── COMPETITION-LEVEL (the gnarly ones) ──
    Case("comp: sin(20°)*sin(40°)*sin(80°)=√3/8",
         "sin(20)*sin(40)*sin(80)",                 lambda e: evaluate(e, "deg")),
    Case("comp: cos(20°)*cos(40°)*cos(80°)=1/8",
         "cos(20)*cos(40)*cos(80)",                 lambda e: evaluate(e, "deg")),
    Case("comp: arcsin(x)+arccos(x)=pi/2 (constant)",
         "asin(x)+acos(x)",                         simplify_expr,
         expected_check=lambda r: simplify(r - pi/2) == 0),
    Case("comp: sin^2(x)+sin^2(60+x)+sin^2(60-x) [deg]",
         "sin(x)^2+sin(pi/3+x)^2+sin(pi/3-x)^2",    simplify_expr,
         expected_check=lambda r: simplify(r - sp.Rational(3, 2)) == 0),

    # ── INVERSE / COMPOSED ──
    Case("inv: sin(arccos(x))",                     "sin(acos(x))",                       simplify_expr,
         expected_check=lambda r: simplify(r - sqrt(1 - x**2)) == 0),
    Case("inv: cos(arctan(x))",                     "cos(atan(x))",                       simplify_expr,
         expected_check=lambda r: simplify(r - 1/sqrt(1 + x**2)) == 0),

    # ── HYPERBOLIC IDENTITY ──
    Case("hyp: cosh(x)^2-sinh(x)^2=1",              "cosh(x)^2-sinh(x)^2",                simplify_expr,
         expected_check=lambda r: r == 1),

    # ── HALF / DOUBLE ANGLE (verify, not solve) ──
    Case("verify: cos(2x)=2cos(x)^2-1",             "cos(2*x)-(2*cos(x)^2-1)",            simplify_expr,
         expected_check=lambda r: r == 0),
    Case("verify: sin(2x)=2sin(x)cos(x)",           "sin(2*x)-2*sin(x)*cos(x)",           simplify_expr,
         expected_check=lambda r: r == 0),
]


# ─── Run & summarise ────────────────────────────────────────────────
def main() -> int:
    print("═" * 70)
    print(f" SymPy {sp.__version__} on Python {__import__('sys').version.split()[0]}")
    print(" Trig calculator coverage POC")
    print("═" * 70)

    by_kind: dict[str, list[Result]] = {}
    for c in CASES:
        kind = c.label.split(":", 1)[0].strip()
        by_kind.setdefault(kind, []).append(run(c))

    total_pass = total = 0
    total_ms = 0.0

    for kind, results in by_kind.items():
        print(f"\n── {kind.upper()} ──")
        kind_pass = sum(r.ok for r in results)
        for r in results:
            mark = "✓" if r.ok else "✗"
            out = r.error if r.error else _pretty(r.output)
            print(f"  {mark}  [{r.elapsed_ms:6.1f}ms]  {r.case.label}")
            print(f"           → {out}")
            total_ms += r.elapsed_ms
        print(f"  ── {kind_pass}/{len(results)} covered")
        total_pass += kind_pass
        total += len(results)

    print("\n" + "═" * 70)
    print(f"COVERAGE: {total_pass}/{total} cases ({total_pass/total*100:.0f}%)")
    print(f"TOTAL TIME: {total_ms:.0f}ms  (avg {total_ms/total:.0f}ms/case)")
    print("═" * 70)
    return 0 if total_pass == total else 1


def _pretty(o):
    if o is None:
        return "—"
    s = str(o)
    return s if len(s) < 90 else s[:87] + "…"


if __name__ == "__main__":
    raise SystemExit(main())
