#!/usr/bin/env python3
"""
Test that definite integral SymPy code produces EVAL_STEP with correct value.
Simulates: x^2 * exp(-x) from 0 to oo -> 2
Run: python integral-eval-step-test.py
"""
from sympy import *
from sympy.integrals.manualintegrate import integral_steps
import json

x = symbols('x')
expr = x**2 * exp(-x)
result = integrate(expr, (x, 0, oo))
antideriv = integrate(expr, x)
a_s, b_s = sympify('0'), sympify('oo')

def _ev(antideriv, var_sym, bound):
    if bound == oo: return limit(antideriv, var_sym, oo)
    if bound == -oo: return limit(antideriv, var_sym, -oo)
    return antideriv.subs(var_sym, bound)

v_u = _ev(antideriv, x, b_s)
v_l = _ev(antideriv, x, a_s)
a_tex = '\\infty' if a_s == oo else ('-\\infty' if a_s == -oo else latex(a_s))
b_tex = '\\infty' if b_s == oo else ('-\\infty' if b_s == -oo else latex(b_s))
ev_latex = r'\left[ ' + latex(antideriv) + r' \right]_{' + a_tex + '}^{' + b_tex + '} = ' + latex(v_u) + ' - (' + latex(v_l) + ') = ' + latex(result)
eval_step = {"title": "Evaluate at bounds", "latex": ev_latex}
out = "EVAL_STEP:" + json.dumps(eval_step)

assert result == 2, "Expected result 2, got %s" % result
assert "= 2" in ev_latex, "Eval step should end with = 2"
parsed = json.loads(out.replace("EVAL_STEP:", ""))
assert parsed["title"] == "Evaluate at bounds", "Wrong title"
assert "2" in parsed["latex"], "LaTeX should contain result 2"
print(out)
print("EVAL_STEP_OK")
