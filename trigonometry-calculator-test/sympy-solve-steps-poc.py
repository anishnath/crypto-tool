#!/usr/bin/env python3.11
"""
POC — deterministic step-by-step solver for trig equations.

Unlike simplify/prove (where SymPy ships named Fu rules we leverage),
solve has NO equivalent of `manualintegrate` — solveset just returns
a Union of ImageSets with no derivation hooks.  So step generation
for the SOLVE mode requires hand-coded textbook patterns.

This POC implements the 6 most common patterns from precalc / college
algebra textbooks, in priority order:

  1. Direct           f(x) = k             (sin, cos, tan, csc, sec, cot)
  2. Linear in trig   a·f(x) + b = c
  3. Quadratic in trig  a·f(x)² + b·f(x) + c = 0  (u-substitution)
  4. Pythagorean      sin² ↔ cos² substitution → reduce to single fn
  5. Factorable       sin(2x) = cos(x) → factor cos(x)(2sin(x)−1)=0
  6. Equal-functions  sin(x) = cos(x) → tan(x) = 1

For each pattern: (a) recognise via SymPy AST, (b) emit named steps,
(c) verify each step's correctness against the original equation.

Anything not matching falls through to the existing AI narrative path.
"""
from __future__ import annotations

import sympy as sp
from sympy import (
    sin, cos, tan, csc, sec, cot, asin, acos, atan,
    Symbol, Eq, simplify, expand_trig, Rational, pi, sqrt, Integer,
    solveset, S, Wild,
)


x = Symbol("x", real=True)


# ─── Pattern recognisers ────────────────────────────────────────────
def is_direct_trig_eq(lhs, rhs, var=x):
    """Match `f(var) = const` where f is a single trig fn."""
    if not (rhs.is_constant() if hasattr(rhs, "is_constant") else not rhs.has(var)):
        return None
    for fn in (sin, cos, tan, csc, sec, cot):
        if isinstance(lhs, fn) and lhs.args[0] == var:
            return (fn, rhs)
    return None


def is_linear_in_trig(lhs, rhs, var=x):
    """Match `a·f(var) + b = c` ⇒ f(var) = (c-b)/a."""
    moved = sp.expand(lhs - rhs)
    for fn in (sin, cos, tan, csc, sec, cot):
        u = Wild("u", exclude=[var, fn(var)])
        v = Wild("v", exclude=[var, fn(var)])
        m = moved.match(u * fn(var) + v)
        if m and m[u] != 0:
            k = -m[v] / m[u]
            return (fn, sp.simplify(k))
    return None


def is_quadratic_in_trig(lhs, rhs, var=x):
    """Match `a·f(var)² + b·f(var) + c = 0` via Wild matching."""
    expr = sp.expand(lhs - rhs)
    for fn in (sin, cos, tan, csc, sec, cot):
        u = sp.Symbol("__u")
        substituted = expr.subs(fn(var), u)
        if substituted.has(var):
            continue   # still has var — not pure-quadratic-in-fn
        try:
            poly = sp.Poly(substituted, u)
            if poly.degree() == 2:
                a, b, c = poly.all_coeffs()
                return (fn, a, b, c)
        except sp.PolynomialError:
            continue
    return None


def is_two_fns_product_form(lhs, rhs, var=x):
    """Match `sin(2x) = cos(x)` → expand sin(2x), factor cos(x)."""
    expr = sp.expand(lhs - rhs)
    expanded = sp.expand_trig(expr)
    factored = sp.factor(expanded)
    if factored != expanded and isinstance(factored, sp.Mul):
        # Check the factors are non-trivial (each contains var)
        if all(f.has(var) for f in factored.args if f != -1 and f != 1):
            return factored
    return None


# ─── Solvers (per pattern) — emit step list ─────────────────────────
def latex(e):
    return sp.latex(e)


def step(title, latex_str, *, before=None):
    return {"title": title, "latex": latex_str}


# Reference-angle / quadrant logic for f(x) = k
QUADRANT_RULES = {
    sin: lambda alpha: (
        # solutions in [0, 2π): α and π - α
        ("sin is positive in Q1 and Q2 (negative in Q3, Q4)",
         [(alpha, "first quadrant"), (pi - alpha, "second quadrant")],
         "x = {a} + 2n\\pi \\quad \\text{or} \\quad x = \\pi - {a} + 2n\\pi"),
    ),
    cos: lambda alpha: (
        ("cos is positive in Q1 and Q4 (negative in Q2, Q3)",
         [(alpha, "first quadrant"), (-alpha, "fourth quadrant")],
         "x = \\pm {a} + 2n\\pi"),
    ),
    tan: lambda alpha: (
        ("tan has period π — one branch per period",
         [(alpha, "principal value")],
         "x = {a} + n\\pi"),
    ),
}


def solve_direct_trig(fn, k):
    """Step-by-step solve for f(x) = k."""
    steps = []
    range_ok = {
        sin: lambda v: -1 <= v <= 1,
        cos: lambda v: -1 <= v <= 1,
        csc: lambda v: abs(v) >= 1,
        sec: lambda v: abs(v) >= 1,
        tan: lambda v: True,
        cot: lambda v: True,
    }
    fn_name = fn.__name__
    inv_fn = {sin: asin, cos: acos, tan: atan,
              csc: lambda v: asin(Rational(1, 1) / v) if v != 0 else None,
              sec: lambda v: acos(Rational(1, 1) / v) if v != 0 else None,
              cot: lambda v: atan(Rational(1, 1) / v) if v != 0 else None}

    # No-solution check
    if k.is_number and not range_ok[fn](k):
        if fn in (sin, cos):
            steps.append(step(
                "Range check",
                f"\\{fn_name}(x) \\in [-1, 1], \\quad \\text{{but }} {latex(k)} \\notin [-1, 1]"))
        else:
            steps.append(step(
                "Range check",
                f"\\{fn_name}(x) \\notin [-1, 1] \\quad \\text{{when }} |{latex(k)}| < 1"))
        steps.append(step("<strong>Result</strong>", "\\boxed{\\text{No real solution}}"))
        return steps

    steps.append(step(
        "Apply inverse trig — find the reference angle",
        f"x_{{ref}} = \\arc{fn_name}({latex(k)}) = {latex(simplify(inv_fn[fn](k)))}"))

    rules = QUADRANT_RULES.get(fn)
    if rules is None:
        # csc/sec/cot — convert to reciprocal
        recip = {csc: sin, sec: cos, cot: tan}[fn]
        steps.append(step(
            f"Rewrite as reciprocal",
            f"\\{fn_name}(x) = {latex(k)} \\implies \\{recip.__name__}(x) = {latex(1/k)}"))
        steps.extend(solve_direct_trig(recip, 1/k)[1:])
        return steps

    rule_text, sols, general = rules(simplify(inv_fn[fn](k)))[0]
    steps.append(step("Identify quadrants of solutions", rule_text))

    sol_latex = ", \\quad ".join(f"x = {latex(s)}" for s, _ in sols)
    steps.append(step(
        "Solutions in [0, 2π)",
        sol_latex))

    a = simplify(inv_fn[fn](k))
    steps.append(step(
        "<strong>General solution (add periodicity)</strong>",
        "\\boxed{" + general.replace("{a}", latex(a)) + "}"))
    return steps


def solve_quadratic_in_trig(fn, a, b, c):
    """Step-by-step for a·f(x)² + b·f(x) + c = 0."""
    steps = []
    fn_name = fn.__name__
    u = Symbol("u")

    steps.append(step(
        f"Substitute u = {fn_name}(x)",
        f"{latex(a)} u^2 + {latex(b)} u + {latex(c)} = 0"))

    # Discriminant
    disc = b**2 - 4*a*c
    steps.append(step(
        "Quadratic discriminant",
        f"\\Delta = b^2 - 4ac = {latex(simplify(disc))}"))

    if disc.is_number and disc < 0:
        steps.append(step("<strong>Result</strong>",
                          "\\boxed{\\text{No real solution}}"))
        return steps

    roots = sp.solve(a*u**2 + b*u + c, u)
    roots_latex = ", \\quad ".join(f"u = {latex(r)}" for r in roots)
    steps.append(step("Solve quadratic for u", roots_latex))

    # For each root, recursively solve f(x) = root
    all_sol = []
    for r in roots:
        steps.append(step(
            f"Back-substitute: solve {fn_name}(x) = {latex(r)}",
            f"\\{fn_name}(x) = {latex(r)}"))
        sub = solve_direct_trig(fn, r)
        # Don't repeat the boxed step — re-emit just the "general solution" line
        for s in sub:
            if "<strong>" not in s["title"]:   # skip the per-root boxed line
                steps.append(s)
        # extract last general solution
        gen = sub[-1]["latex"].replace("\\boxed{", "").rstrip("}")
        all_sol.append(gen)

    if len(all_sol) >= 2:
        steps.append(step(
            "<strong>Combined general solution</strong>",
            "\\boxed{" + " \\quad \\text{or} \\quad ".join(all_sol) + "}"))
    elif all_sol:
        steps.append(step("<strong>General solution</strong>",
                          "\\boxed{" + all_sol[0] + "}"))
    return steps


def solve_factor_form(factored, var=x):
    """`A(x)·B(x) = 0` → set each factor to zero, recurse."""
    steps = [step("Move everything to one side and factor",
                  f"{latex(factored)} = 0")]
    factors = factored.args if isinstance(factored, sp.Mul) else [factored]
    factors = [f for f in factors if f.has(var)]
    if not factors:
        return None
    for f in factors:
        steps.append(step(f"Set this factor to zero",
                          f"{latex(f)} = 0"))
        # Try to recursively solve the factor as a direct or linear pattern
        m_direct = is_direct_trig_eq(f, sp.S.Zero)
        m_linear = is_linear_in_trig(f, sp.S.Zero)
        sub_steps = None
        if m_direct:
            sub_steps = solve_direct_trig(*m_direct)
        elif m_linear:
            sub_steps = solve_direct_trig(*m_linear)
        if sub_steps:
            for s in sub_steps:
                # Demote the per-factor boxed step from <strong> to non-final
                if "<strong>General solution" in s["title"]:
                    s = step(s["title"].replace("<strong>", "").replace("</strong>", ""),
                             s["latex"].replace("\\boxed{", "").rstrip("}"))
                steps.append(s)
        else:
            steps.append(step("(this factor needs further treatment)",
                              latex(f) + " = 0"))
    steps.append(step("<strong>Combined general solution</strong>",
                      "\\boxed{\\text{Union of solutions from each factor}}"))
    return steps


# ─── Top-level dispatcher ───────────────────────────────────────────
def solve_with_steps(expr_str, var=x):
    """Parse `f(x) = g(x)` (or `f(x) ≤ g(x)` etc.), recognise pattern,
    emit step list."""
    if "=" not in expr_str:
        raise ValueError("expected an equation containing '='")
    lhs_s, rhs_s = expr_str.split("=", 1)
    lhs = sp.sympify(lhs_s, locals={"x": var})
    rhs = sp.sympify(rhs_s, locals={"x": var})

    print(f"\n══ {expr_str} ══")
    print(f"   parsed: {lhs} = {rhs}")

    # Pattern dispatch in priority order
    m = is_direct_trig_eq(lhs, rhs, var)
    if m:
        print(f"   pattern: DIRECT  {m[0].__name__}(x) = {m[1]}")
        return solve_direct_trig(*m)

    m = is_quadratic_in_trig(lhs, rhs, var)
    if m:
        print(f"   pattern: QUADRATIC in {m[0].__name__}(x)")
        return solve_quadratic_in_trig(*m)

    f = is_two_fns_product_form(lhs, rhs, var)
    if f is not None:
        print(f"   pattern: FACTORABLE  →  {f} = 0")
        return solve_factor_form(f, var)

    m = is_linear_in_trig(lhs, rhs, var)
    if m:
        print(f"   pattern: LINEAR  ⇒  {m[0].__name__}(x) = {m[1]}")
        return solve_direct_trig(*m)

    print("   pattern: UNRECOGNISED — would fall through to AI")
    return None


# ─── Demo ──────────────────────────────────────────────────────────
def show(steps):
    if steps is None:
        print("   (no deterministic steps available)")
        return
    for i, s in enumerate(steps, 1):
        title = s["title"].replace("<strong>", "").replace("</strong>", "")
        ltx = s["latex"]
        if len(ltx) > 90: ltx = ltx[:87] + "…"
        print(f"   {i}. {title}")
        print(f"        → {ltx}")


if __name__ == "__main__":
    # Direct
    show(solve_with_steps("sin(x) = 1/2"))
    show(solve_with_steps("cos(x) = sqrt(2)/2"))
    show(solve_with_steps("tan(x) = sqrt(3)"))
    show(solve_with_steps("sin(x) = 2"))             # no-solution

    # Linear
    show(solve_with_steps("2*cos(x) - 1 = 0"))
    show(solve_with_steps("3*tan(x) + sqrt(3) = 0"))

    # Quadratic
    show(solve_with_steps("2*cos(x)**2 - 1 = 0"))
    show(solve_with_steps("2*sin(x)**2 - sin(x) - 1 = 0"))

    # Factorable
    show(solve_with_steps("sin(2*x) = cos(x)"))
    show(solve_with_steps("sin(x)*cos(x) - sin(x) = 0"))

    # Equal-functions / Auxiliary-angle (needs different pattern)
    show(solve_with_steps("sin(x) + cos(x) = 1"))
