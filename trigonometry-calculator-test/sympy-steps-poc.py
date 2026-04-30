#!/usr/bin/env python3.11
"""
POC — generate human-readable step-by-step trig solutions WITHOUT an
LLM, by leveraging SymPy's 24 named Fu transformation rules.

Each rule (TR1, TR2, TR5, …) is a single named identity application.
The strategy:

  1. Try every rule on the current expression.
  2. Keep the one that reduces a complexity metric (L() = count of
     trig functions, or count_ops, etc.) the most.
  3. Record the applied rule's friendly name as a step.
  4. Repeat until no rule helps.

For PROVE mode: instead of minimizing complexity, minimize distance to
the target (RHS).  Stop when LHS == RHS.

This POC's purpose: demonstrate how much pedagogical step-by-step we
can produce deterministically before falling back to AI for narration.
"""
from __future__ import annotations

import importlib
import sympy as sp
from sympy import sin, cos, tan, cot, sec, csc, simplify, trigsimp

F = importlib.import_module("sympy.simplify.fu")

# ─── Friendly names for SymPy's Fu rules ────────────────────────────
# Sourced from the rule docstrings; phrased for a high-school /
# precalc audience.
RULE_LABEL = {
    "TR1":   "Convert sec → 1/cos and csc → 1/sin",
    "TR2":   "Convert tan → sin/cos and cot → cos/sin",
    "TR2i":  "Combine sin/cos ratios into tan or cot",
    "TR3":   "Apply induced formulas (e.g. sin(-x) = -sin(x))",
    "TR4":   "Substitute special-angle values",
    "TR5":   "Apply Pythagorean identity: sin²(x) → 1 - cos²(x)",
    "TR6":   "Apply Pythagorean identity: cos²(x) → 1 - sin²(x)",
    "TR7":   "Lower the power of cos²(x) using cos(2x)",
    "TR8":   "Convert products to sums (product-to-sum)",
    "TR9":   "Convert sums to products (sum-to-product)",
    "TR10":  "Expand sum/difference angle formulas",
    "TR10i": "Combine sums of products into a single angle",
    "TR11":  "Expand double-angle formulas (sin(2x), cos(2x), tan(2x))",
    "TR12":  "Separate sums in tangent",
    "TR12i": "Combine tangent arguments",
    "TR13":  "Combine products of tangent or cotangent",
    "TR14":  "Factor powers of sin and cos identities",
    "TR15":  "Convert sin(x)⁻² → 1 + cot²(x)",
    "TR16":  "Convert cos(x)⁻² → 1 + tan²(x)",
    "TR22":  "Convert tan²(x) → sec²(x) - 1 (and cot²(x) → csc²(x) - 1)",
    "TR111": "Convert reciprocal powers (e.g. f(x)⁻ⁿ → g(x)ⁿ)",
    "TRpower": "Lower powers of sin/cos via reduction formulas",
    "TRmorrie": "Apply Morrie's identity (cos product chain)",
}
RULES = [(n, getattr(F, n)) for n in RULE_LABEL]


# ─── Complexity metric ──────────────────────────────────────────────
def cost(e):
    """Lower is simpler.  L() counts trig functions, count_ops counts
    the AST-level operations.  We use both as a tiebreaker."""
    try:
        return (F.L(e), sp.count_ops(e), len(str(e)))
    except Exception:
        return (10**6, 10**6, len(str(e)))


# ─── Step generator (simplify mode) ─────────────────────────────────
def simplify_with_steps(expr, max_steps=12, lookahead=2):
    """Greedy + bounded BFS.  At each step, search up to `lookahead`
    rules deep for the chain that reduces cost the most, then apply
    just the FIRST rule of that chain (so each visible step is one
    named identity).  Falls back to simplify+trigsimp for the
    closing step if no single rule helps."""
    steps = []
    current = expr
    for _ in range(max_steps):
        baseline = cost(current)
        best = None  # (rule_name, after_one_step, best_eventual_cost)
        # BFS up to `lookahead` deep — track only the first rule applied
        frontier = [(current, None, [])]    # (expr, first_rule_name, history)
        for _depth in range(lookahead):
            next_frontier = []
            for state, first_rule, hist in frontier:
                for name, rule in RULES:
                    if name in hist:
                        continue
                    try:
                        cand = rule(state)
                    except Exception:
                        continue
                    if cand == state:
                        continue
                    c = cost(cand)
                    fr = first_rule or name
                    after_first = cand if first_rule is None else None
                    # Track cost of the eventual end of this chain
                    candidate_record = (fr, after_first, c, cand, hist + [name])
                    next_frontier.append(candidate_record)
                    if c < baseline and (best is None or c < best[2]):
                        # Recover the after-one-step expr from the chain
                        if after_first is not None:
                            best = (fr, cand, c)
            # Continue exploring from the new frontier
            # Cost is a tuple (L, count_ops, len); compare by sum of
            # first two components against baseline so we allow modest
            # short-term blow-ups (a Pythagorean substitution often
            # increases cost briefly before the next rule collapses it).
            def _budget(c): return c[0] + c[1]
            limit = _budget(baseline) + 4
            frontier = [(rec[3], rec[0], rec[4]) for rec in next_frontier
                        if _budget(cost(rec[3])) <= limit]
        if best is None:
            # No single Fu rule reduces (even with lookahead).  One last
            # shot: simplify+trigsimp combined (cross-rule synergy SymPy
            # finds via its own internal heuristics).
            combined = trigsimp(simplify(current))
            if cost(combined) < baseline:
                steps.append({
                    "rule": "simplify+trigsimp",
                    "label": "Combine and simplify",
                    "before": current, "after": combined,
                })
                current = combined
            break
        name, after, _ = best
        steps.append({
            "rule": name,
            "label": RULE_LABEL[name],
            "before": current,
            "after": after,
        })
        current = after
    return current, steps


# ─── Step generator (prove mode) ────────────────────────────────────
def prove_with_steps(lhs, rhs, max_steps=15):
    """Transform LHS into RHS by applying Fu rules.  Strategy: minimise
    `cost(LHS - RHS)` at each step.  Always attempt rule application
    even when the identity is "obvious" to SymPy (`simplify(LHS-RHS)==0`
    immediately) — pedagogically empty steps are useless to a student."""
    def gap(e):
        return cost(simplify(e - rhs))

    is_id = (simplify(lhs - rhs) == 0)
    steps = []
    seen = {str(lhs)}      # block cycles (e.g. TR10/TR8 ping-pong)
    current = lhs
    for _ in range(max_steps):
        # Stop once we've literally typed RHS, not just "equivalent"
        if str(current) == str(rhs) or current == rhs:
            return True, current, steps
        baseline = gap(current)
        # Pick the rule that BOTH (a) reduces our distance to RHS, AND
        # (b) doesn't blow up trig-fn count too much.  Allowing modest
        # cost increases lets identities fire that need a temporary
        # expansion before the simplification can close.
        best = None
        for name, rule in RULES:
            try:
                cand = rule(current)
            except Exception:
                continue
            if cand == current or str(cand) in seen:
                continue
            g = gap(cand)
            if g <= baseline and (best is None or g < best[2]):
                best = (name, cand, g)
        if best is None:
            break
        name, after, _ = best
        # Stop if the rule didn't make progress AND we're already at zero
        if simplify(after - rhs) == 0 and gap(current) == (0, 0, len(str(0))):
            steps.append({
                "rule": name, "label": RULE_LABEL[name],
                "before": current, "after": after,
            })
            return True, after, steps
        steps.append({
            "rule": name, "label": RULE_LABEL[name],
            "before": current, "after": after,
        })
        seen.add(str(after))
        current = after
        if simplify(current - rhs) == 0 and str(current) == str(rhs):
            return True, current, steps

    # Last-shot global simplify to close the gap
    final = trigsimp(simplify(current))
    if simplify(final - rhs) == 0:
        if final != current:
            steps.append({
                "rule": "simplify+trigsimp",
                "label": "Combine and simplify to canonical form",
                "before": current, "after": final,
            })
        return True, final, steps
    # Fall back: identity may be true but we can't show steps
    if is_id:
        return True, current, steps
    return False, current, steps


# ─── Demo ───────────────────────────────────────────────────────────
def fmt(e):
    return sp.pretty(e, use_unicode=False).replace("\n", " ↵ ")[:90]


def demo_simplify(expr_str):
    print(f"\n══ SIMPLIFY: {expr_str} ══")
    expr = sp.sympify(expr_str)
    final, steps = simplify_with_steps(expr)
    print(f"  Initial: {expr}")
    if not steps:
        print("  (no rule applied — already simplest form)")
    for i, s in enumerate(steps, 1):
        print(f"  Step {i}: {s['label']}  ({s['rule']})")
        print(f"            → {s['after']}")
    print(f"  Final:   {final}")


def demo_prove(lhs_str, rhs_str):
    print(f"\n══ PROVE: {lhs_str}  =  {rhs_str} ══")
    x = sp.symbols("x", real=True)
    lhs = sp.sympify(lhs_str, locals={"x": x})
    rhs = sp.sympify(rhs_str, locals={"x": x})
    ok, final, steps = prove_with_steps(lhs, rhs)
    print(f"  LHS: {lhs}")
    for i, s in enumerate(steps, 1):
        print(f"  Step {i}: {s['label']}  ({s['rule']})")
        print(f"            → {s['after']}")
    print(f"  RHS: {rhs}")
    print(f"  ⇒ {'IDENTITY VERIFIED ✓' if ok else 'COULD NOT REACH RHS ✗'}")


if __name__ == "__main__":
    print("\n" + "═" * 70)
    print(" EXTENDED BATTERY — diverse student/teacher inputs")
    print("═" * 70)

    # ── SIMPLIFY: textbook reductions ──
    demo_simplify("sin(x)**2 + cos(x)**2")
    demo_simplify("(1 - cos(2*x))/sin(2*x)")
    demo_simplify("tan(x) + cot(x)")
    demo_simplify("(sin(x)**4 - cos(x)**4)/(sin(x)**2 - cos(x)**2)")
    demo_simplify("cos(2*x) + sin(2*x)*tan(x)")
    demo_simplify("sin(x)**4 + cos(x)**4")
    demo_simplify("2*sin(x)*cos(x)")
    demo_simplify("sin(x)/cos(x)")
    demo_simplify("sec(x)*cos(x)")
    demo_simplify("(1 + cos(x))*(1 - cos(x))")
    demo_simplify("(sin(x) + cos(x))**2")
    demo_simplify("sec(x)**2 - tan(x)**2")
    demo_simplify("csc(x)**2 - cot(x)**2")
    demo_simplify("1/(1 - sin(x)) + 1/(1 + sin(x))")
    demo_simplify("cos(2*x) + 2*sin(x)**2")
    demo_simplify("sin(x)*cos(y) + cos(x)*sin(y)")
    demo_simplify("(tan(x) - sin(x))/(tan(x) + sin(x))")
    demo_simplify("(sin(x) + sin(3*x))/(cos(x) + cos(3*x))")
    demo_simplify("sin(x)**3 + sin(x)*cos(x)**2")
    demo_simplify("4*sin(x)*cos(x)**3 - 4*sin(x)**3*cos(x)")

    # ── PROVE: classic textbook identities ──
    demo_prove("sin(x)**2 + cos(x)**2", "1")
    demo_prove("1 + tan(x)**2", "sec(x)**2")
    demo_prove("1 + cot(x)**2", "csc(x)**2")
    demo_prove("sec(x)**2 - tan(x)**2", "1")
    demo_prove("sin(2*x)", "2*sin(x)*cos(x)")
    demo_prove("cos(2*x)", "1 - 2*sin(x)**2")
    demo_prove("cos(2*x)", "2*cos(x)**2 - 1")
    demo_prove("cos(2*x)", "cos(x)**2 - sin(x)**2")
    demo_prove("(1 - cos(2*x))/sin(2*x)", "tan(x)")
    demo_prove("tan(x)**2 - sin(x)**2", "tan(x)**2 * sin(x)**2")
    demo_prove("(sin(x) + cos(x))**2", "1 + sin(2*x)")
    demo_prove("(sin(x) - cos(x))**2", "1 - sin(2*x)")
    demo_prove("sin(3*x)", "3*sin(x) - 4*sin(x)**3")
    demo_prove("cos(3*x)", "4*cos(x)**3 - 3*cos(x)")
    demo_prove("(1 + tan(x))*(1 - tan(x))", "1 - tan(x)**2")
    demo_prove("sec(x) - tan(x)*sin(x)", "cos(x)")
    demo_prove("sin(x+y)", "sin(x)*cos(y) + cos(x)*sin(y)")
    demo_prove("cos(x+y)", "cos(x)*cos(y) - sin(x)*sin(y)")

    # ── FALSE identities — must correctly reject ──
    print("\n  ── FALSE IDENTITIES (must report ✗) ──")
    demo_prove("sin(x+y)", "sin(x) + sin(y)")
    demo_prove("tan(x+y)", "tan(x) + tan(y)")
    demo_prove("cos(x)", "1 - x**2/2")
    demo_prove("sin(2*x)", "2*sin(x)")
