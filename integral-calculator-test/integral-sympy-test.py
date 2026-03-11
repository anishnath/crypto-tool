#!/usr/bin/env python3
"""
Test SymPy integral_steps output format (RESULT=, EXPR=, RULES=).
Validates all integrands from integral-test.js. Run: python integral-sympy-test.py
"""
from sympy import *
from sympy.integrals.manualintegrate import integral_steps, DontKnowRule

# All integrands from integral-test.js (nerdamer format → SymPy/Python format)
# Skip non-elementary: 1/ln(x), e^(x^2), sin(x)/x
INTEGRANDS = [
    ("x**2", "x"),
    ("x**3", "x"),
    ("sin(x)", "x"),
    ("cos(x)", "x"),
    ("exp(x)", "x"),
    ("1/x", "x"),
    ("sec(x)**2", "x"),
    ("sin(3*x)", "x"),
    ("x**2 + 3*x", "x"),
    ("log(x)", "x"),
    ("1/(x**2 + 1)", "x"),
    ("sqrt(x)", "x"),
    ("sin(x)*cos(x)", "x"),
    ("x*exp(x)", "x"),
    ("x*sin(x)", "x"),
    ("x*cos(x)", "x"),
    ("x*log(x)", "x"),
    ("2*x*exp(x)", "x"),
    ("x*exp(2*x)", "x"),
    ("x*exp(-x)", "x"),
    ("sin(x)**2", "x"),
    ("cos(x)**2", "x"),
    ("tan(x)", "x"),
    ("sin(2*x)", "x"),
    ("cos(5*x)", "x"),
    ("sec(x)*tan(x)", "x"),
    ("x**2*exp(x)", "x"),
    ("x**2*log(x)", "x"),
    ("exp(-x)", "x"),
    ("exp(2*x)", "x"),
    ("sinh(x)", "x"),
    ("cosh(x)", "x"),
    ("tanh(x)", "x"),
    ("1/sqrt(x)", "x"),
    ("x/sqrt(x**2 + 1)", "x"),
    ("x/(x**2 + 1)", "x"),
    ("1/(x**2 - 1)", "x"),
    ("(x**2 + 1)**2", "x"),
    ("(2*x + 3)**3", "x"),
    ("exp(x)*sin(x)", "x"),
    ("exp(x)*cos(x)", "x"),
    ("1/sqrt(1 - x**2)", "x"),
    ("csc(x)**2", "x"),
    ("log(x)/x", "x"),
    ("3*x**2 + 2*x - 5", "x"),
    ("1", "x"),
    ("x", "x"),
    ("2*x", "x"),
    ("x**0", "x"),
    ("x**(-2)", "x"),
    ("sin(3*x) + cos(2*x)", "x"),
    ("1/(x**3 + 1)", "x"),
    # Variable t
    ("sin(t)", "t"),
    ("sin(3*t)", "t"),
    # All UI variables: y, z, u, v, w, r, s, theta, k, m, n, p, q
    ("y**2", "y"),
    ("sin(y)", "y"),
    ("z**2", "z"),
    ("cos(z)", "z"),
    ("u**2", "u"),
    ("exp(u)", "u"),
    ("v**2", "v"),
    ("1/v", "v"),
    ("w**2", "w"),
    ("tan(w)", "w"),
    ("r**2", "r"),
    ("sqrt(r)", "r"),
    ("s**2", "s"),
    ("sec(s)**2", "s"),
    ("theta**2", "theta"),
    ("sin(theta)", "theta"),
    ("k**2", "k"),
    ("k**3", "k"),
    ("m**2", "m"),
    ("log(m)", "m"),
    ("n**2", "n"),
    ("1/(n**2 + 1)", "n"),
    ("p**2", "p"),
    ("exp(-p)", "p"),
    ("q**2", "q"),
    ("cosh(q)", "q"),
    # Hyperbolic: coth, csch, sech
    ("coth(x)", "x"),
    ("csch(x)", "x"),
    ("sech(x)", "x"),
    ("coth(log(x**Rational(3,2)))", "x"),  # coth composed with ln — SymPy may not resolve
    ("1/(1+x**4)", "x"),  # DontKnowRule but integrate() solves — tests apart() fallback
    ("x/((x**3 + 1)*sqrt(x**2 + x + 1))", "x"),  # elliptic-type, no elementary form, apart() crashes on sqrt
    ("exp(sqrt(x + 2))", "x"),  # e^sqrt(x+2) — u-substitution: 2*sqrt(x+2)*exp(sqrt(x+2)) - 2*exp(sqrt(x+2))
]


def run_integral(expr_str, v="x"):
    """Same logic as integral-calculator.jsp sends to OneCompiler."""
    import signal
    v_sym = symbols(v)
    expr = sympify(expr_str)
    steps = integral_steps(expr, v_sym)
    if steps and not isinstance(steps, DontKnowRule):
        result = integrate(expr, v_sym)
    else:
        # DontKnowRule fallback: try integrate() with timeout (matches JS code)
        class _TO(Exception): pass
        def _th(s, f): raise _TO()
        old = signal.signal(signal.SIGALRM, _th)
        signal.alarm(10)
        try:
            result = integrate(expr, v_sym)
        except _TO:
            result = None
        finally:
            signal.alarm(0)
            signal.signal(signal.SIGALRM, old)
        if result and (isinstance(result, Integral) or result.has(Integral)):
            result = None
    print("RESULT=" + (latex(result) if result else ""))
    print("EXPR=" + latex(expr))
    print("RULES=" + (str(steps) if steps else ""))
    return result is not None and steps is not None


if __name__ == "__main__":
    ok_count = 0
    for i, (expr, v) in enumerate(INTEGRANDS):
        print("=== Test {}: {} ===".format(i + 1, expr))
        try:
            if run_integral(expr, v):
                ok_count += 1
        except Exception as e:
            print("RESULT=")
            print("EXPR=")
            print("RULES=")
            print("# ERROR:", str(e)[:80])
        print()
    print("# Valid:", ok_count, "/", len(INTEGRANDS))
