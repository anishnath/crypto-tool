#!/usr/bin/env python3
"""
Test definite integrals: SymPy integrate with bounds + steps from integral_steps.
Outputs: DEFinite:json for each case. Run: python integral-definite-test.py
"""
import json
from sympy import *
from sympy.integrals.manualintegrate import integral_steps, DontKnowRule

# (expr, v, a, b, expected_approx) — extra symbols (e.g. n) must be declared
DEFINITE_CASES = [
    ("x**2", "x", 0, 1, 1/3),
    ("sin(x)", "x", 0, "pi", 2),
    ("exp(x)", "x", 0, 1, None),  # e-1, we'll check > 1
    ("1/x", "x", 1, "E", 1),
    ("x**2", "x", 1, 0, -1/3),  # reversed bounds
    ("x**(n-1)*exp(-x)", "x", 0, "oo", None),  # gamma(n) — symbolic result
]

def get_extra_symbols(expr_str, v):
    """Match JSP getExtraSymbols: ids not in KNOWN and not v."""
    import re
    KNOWN = ['exp', 'log', 'sin', 'cos', 'tan', 'sec', 'csc', 'cot', 'sinh', 'cosh', 'tanh', 'sqrt', 'asin', 'acos', 'atan', 'pi']
    seen = set()
    for m in re.finditer(r'\b([a-z][a-z]*)\b', expr_str):
        w = m.group(1)
        if w in KNOWN or w == v:
            continue
        seen.add(w)
    return sorted(seen)

if __name__ == "__main__":
    for expr_str, v, a, b, expected in DEFINITE_CASES:
        extra = get_extra_symbols(expr_str, v)
        sym_names = ' '.join(extra + [v])
        syms = symbols(sym_names)
        v_sym = syms[-1] if hasattr(syms, '__len__') and len(syms) > 1 else syms
        expr = sympify(expr_str)
        a_sym = sympify(str(a))
        b_sym = sympify(str(b))
        steps_rule = integral_steps(expr, v_sym)
        result = integrate(expr, (v_sym, a_sym, b_sym))
        antideriv = integrate(expr, v_sym) if steps_rule else None
        try:
            numeric = float(result) if result.is_number else (float(result.evalf()) if result else None)
        except (TypeError, ValueError):
            numeric = None  # e.g. gamma(n) stays symbolic
        has_steps = steps_rule is not None and not isinstance(steps_rule, DontKnowRule)
        out = {
            "expr": expr_str,
            "a": str(a),
            "b": str(b),
            "numeric": numeric,
            "expected_approx": expected,
            "has_antideriv": antideriv is not None,
            "has_steps": has_steps,
        }
        print("DEFinite:" + json.dumps(out, separators=(",", ":")))
