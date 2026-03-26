#!/usr/bin/env python3
"""
Test definite integrals: SymPy integrate with bounds + steps from integral_steps.
Outputs: DEFinite:json for each case. Run: python integral-definite-test.py
"""
import json, signal
from sympy import *
from sympy.integrals.manualintegrate import integral_steps, DontKnowRule

class TimeoutError(Exception):
    pass

def _timeout_handler(signum, frame):
    raise TimeoutError("integration timed out")

def integrate_with_timeout(expr, bounds, timeout_sec=30):
    """Call integrate() with a timeout to avoid hanging on hard integrals."""
    old = signal.signal(signal.SIGALRM, _timeout_handler)
    signal.alarm(timeout_sec)
    try:
        return integrate(expr, bounds)
    except TimeoutError:
        return None
    finally:
        signal.alarm(0)
        signal.signal(signal.SIGALRM, old)

# (expr, v, a, b, expected_approx) — extra symbols (e.g. n) must be declared
DEFINITE_CASES = [
    ("x**2", "x", 0, 1, 1/3),
    ("sin(x)", "x", 0, "pi", 2),
    ("exp(x)", "x", 0, 1, None),  # e-1, we'll check > 1
    ("1/x", "x", 1, "E", 1),
    ("x**2", "x", 1, 0, -1/3),  # reversed bounds
    ("x**(n-1)*exp(-x)", "x", 0, "oo", None),  # gamma(n) — symbolic result
    ("coth(log(x**Rational(3,2)))", "x", 2, 3, None),  # coth(ln(x^(3/2))) — SymPy returns unevaluated Integral
    ("coth(x)", "x", 1, 2, None),  # hyperbolic cotangent definite integral
    ("csch(x)", "x", 1, 2, None),  # hyperbolic cosecant definite integral
    ("sech(x)", "x", 0, 1, None),  # hyperbolic secant definite integral
    ("1/(1+x**4)", "x", 0, 1, None),  # DontKnowRule but integrate() solves
    ("x/((x**3 + 1)*sqrt(x**2 + x + 1))", "x", 0, 1, 0.2672385245),  # elliptic-type, no symbolic — numeric only via scipy
    # --- MIT Integration Bee 2026 qualifying (PDF definite integrals) ---
    # #1: ∫_{-π}^π sin^2025·cos^2026 — huge exponents timeout in CI; same symmetry → 0 with low-power proxy
    ("sin(x)**3*cos(x)**4", "x", "-pi", "pi", 0),
    # #3: ∫_0^{2026} {⌊x⌋/3} dx — unevaluated Integral but .evalf() → 512 (Bee answer)
    ("Mod(floor(x)/3, 1)", "x", 0, 2026, 512.0),
    # #8: ∫_0^{1/2} Σ_{n=2}^∞ x^n/n! dx = ∫_0^{1/2} (e^x - x - 1) dx = -13/8 + e^(1/2)
    ("exp(x)-x-1", "x", 0, "1/2", 0.023721270700128146),
    # #11: ∫_{-1}^1 max(0, √(1−x²)−½) dx = −√3/4 + π/3
    ("Max(0, sqrt(1-x**2)-Rational(1,2))", "x", -1, 1, 0.6141848493043784),
    # #17: ∫_{-∞}^∞ e^{-x²}/(1+e^{2x}) dx — omit: SymPy .evalf() is non-real; use manual / other CAS
    # #20: ∫_0^{π/2} nested cos² — unevaluated Integral; numeric .evalf() ≈ π/4
    ("cos(pi/2*cos(pi/2*cos(x)**2)**2)**2", "x", 0, "pi/2", 0.785398163397448),
]

def get_extra_symbols(expr_str, v):
    """Match JSP getExtraSymbols: ids not in KNOWN and not v."""
    import re
    KNOWN = ['exp', 'log', 'sin', 'cos', 'tan', 'sec', 'csc', 'cot', 'sinh', 'cosh', 'tanh', 'coth', 'csch', 'sech', 'sqrt', 'asin', 'acos', 'atan', 'pi', 'floor', 'ceiling', 'Mod', 'Max', 'Min', 'Abs']
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
        result = integrate_with_timeout(expr, (v_sym, a_sym, b_sym))
        antideriv = integrate_with_timeout(expr, v_sym) if steps_rule else None
        try:
            if result is None:
                numeric = None
            elif result.is_number:
                numeric = float(result)
            else:
                numeric = float(result.evalf()) if result else None
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
