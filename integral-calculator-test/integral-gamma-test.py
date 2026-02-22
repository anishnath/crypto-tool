#!/usr/bin/env python3
"""
Test that the EXACT SymPy code the JSP generates for the gamma integral works.
Simulates: x**(n-1)*exp(-x), (x, 0, oo) -> gamma(n)
Run: python integral-gamma-test.py
"""
from sympy import *
from sympy.integrals.manualintegrate import integral_steps

# Exact code the JSP generates for x^(n-1)*e^(-x) with bounds 0, oo
sym_decl = "n, x = symbols('n x', positive=True)"
py_expr = "x**(n-1)*exp(-x)"
v, a, b = "x", "0", "oo"

code = """
from sympy import *
from sympy.integrals.manualintegrate import integral_steps
""" + sym_decl + """
expr = """ + py_expr + """
try:
    steps = integral_steps(expr, """ + v + """)
except:
    steps = None
result = integrate(expr, (""" + v + ", " + a + ", " + b + """))
antideriv = integrate(expr, """ + v + """)
print('LATEX:' + latex(result))
print('TEXT:' + str(result))
print('EXPR:' + latex(expr))
print('RULES:' + (str(steps) if steps else ''))
print('ANTIDERIV:' + (latex(antideriv) if antideriv and not isinstance(antideriv, Integral) else ''))
try:
    print('NUMERIC:' + str(float(result)))
except:
    print('NUMERIC:NaN')
"""

if __name__ == "__main__":
    exec(code)
    # Validate: result should be gamma(n), no "Integral(" in TEXT
    n, x = symbols('n x', positive=True)
    expr = x**(n-1)*exp(-x)
    result = integrate(expr, (x, 0, oo))
    assert result == gamma(n), "Expected gamma(n), got %s" % result
    text = str(result)
    assert "Integral(" not in text, "Result should not contain unevaluated Integral"
    print("\nGAMMA_OK: result is gamma(n)")
