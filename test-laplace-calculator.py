#!/usr/bin/env python3
"""
Unit tests for Laplace Transform Calculator — SymPy code generation paths.
Simulates what students might type and verifies SymPy produces correct results.
"""
import sys
import json
import traceback

# ── SymPy imports (same as generated code) ──────────────────────────────
from sympy import (
    symbols, laplace_transform, inverse_laplace_transform, apart, simplify,
    latex, sin, cos, tan, exp, log, sqrt, pi, sinh, cosh, tanh,
    Heaviside, DiracDelta, factorial, oo, Rational, Abs, re
)
from sympy import Function, S

t = symbols("t", positive=True)
s = symbols("s")
a, w, n = symbols("a w n", positive=True)

passed = 0
failed = 0
errors = []

def test(name, fn):
    global passed, failed, errors
    try:
        fn()
        passed += 1
        print(f"  PASS  {name}")
    except Exception as e:
        failed += 1
        tb = traceback.format_exc()
        errors.append((name, str(e), tb))
        print(f"  FAIL  {name}: {e}")


# ═══════════════════════════════════════════════════════════════════════
#  FORWARD TRANSFORMS  L{f(t)} → F(s)
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Forward Laplace Transforms ══")

def fwd_unit_step():
    """Student types: 1"""
    f = S(1)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert F == 1/s, f"Expected 1/s, got {F}"
    assert a_conv == 0, f"Expected ROC=0, got {a_conv}"
test("fwd: L{1} = 1/s", fwd_unit_step)

def fwd_ramp():
    """Student types: t"""
    f = t
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert F == 1/s**2 or simplify(F - 1/s**2) == 0, f"Expected 1/s^2, got {F}"
test("fwd: L{t} = 1/s^2", fwd_ramp)

def fwd_t_squared():
    """Student types: t^2"""
    f = t**2
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 2/s**3) == 0, f"Expected 2/s^3, got {F}"
test("fwd: L{t^2} = 2/s^3", fwd_t_squared)

def fwd_t_cubed():
    """Student types: t^3"""
    f = t**3
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 6/s**4) == 0, f"Expected 6/s^4, got {F}"
test("fwd: L{t^3} = 6/s^4", fwd_t_cubed)

def fwd_exp_decay():
    """Student types: e^(-3*t)"""
    f = exp(-3*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 1/(s+3)) == 0, f"Expected 1/(s+3), got {F}"
test("fwd: L{e^(-3t)} = 1/(s+3)", fwd_exp_decay)

def fwd_sin():
    """Student types: sin(2*t)"""
    f = sin(2*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 2/(s**2 + 4)) == 0, f"Expected 2/(s^2+4), got {F}"
test("fwd: L{sin(2t)} = 2/(s^2+4)", fwd_sin)

def fwd_cos():
    """Student types: cos(5*t)"""
    f = cos(5*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - s/(s**2 + 25)) == 0, f"Expected s/(s^2+25), got {F}"
test("fwd: L{cos(5t)} = s/(s^2+25)", fwd_cos)

def fwd_t_exp():
    """Student types: t*e^(-t)  (first shifting)"""
    f = t*exp(-t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 1/(s+1)**2) == 0, f"Expected 1/(s+1)^2, got {F}"
test("fwd: L{t*e^(-t)} = 1/(s+1)^2", fwd_t_exp)

def fwd_t2_exp():
    """Student types: t^2*e^(-3*t)"""
    f = t**2 * exp(-3*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 2/(s+3)**3) == 0, f"Expected 2/(s+3)^3, got {F}"
test("fwd: L{t^2*e^(-3t)} = 2/(s+3)^3", fwd_t2_exp)

def fwd_damped_sin():
    """Student types: e^(-t)*sin(t)"""
    f = exp(-t)*sin(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    expected = 1/((s+1)**2 + 1)
    assert simplify(F - expected) == 0, f"Expected {expected}, got {F}"
test("fwd: L{e^(-t)sin(t)} = 1/((s+1)^2+1)", fwd_damped_sin)

def fwd_damped_cos():
    """Student types: e^(-2*t)*cos(3*t)"""
    f = exp(-2*t)*cos(3*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    expected = (s+2)/((s+2)**2 + 9)
    assert simplify(F - expected) == 0, f"Expected {expected}, got {F}"
test("fwd: L{e^(-2t)cos(3t)} = (s+2)/((s+2)^2+9)", fwd_damped_cos)

def fwd_sinh():
    """Student types: sinh(t)"""
    f = sinh(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 1/(s**2 - 1)) == 0, f"Expected 1/(s^2-1), got {F}"
test("fwd: L{sinh(t)} = 1/(s^2-1)", fwd_sinh)

def fwd_cosh():
    """Student types: cosh(t)"""
    f = cosh(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - s/(s**2 - 1)) == 0, f"Expected s/(s^2-1), got {F}"
test("fwd: L{cosh(t)} = s/(s^2-1)", fwd_cosh)

def fwd_t_sin():
    """Student types: t*sin(t)  (frequency derivative)"""
    f = t*sin(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    expected = 2*s/(s**2 + 1)**2
    assert simplify(F - expected) == 0, f"Expected {expected}, got {F}"
test("fwd: L{t*sin(t)} = 2s/(s^2+1)^2", fwd_t_sin)

def fwd_heaviside():
    """Student types: Heaviside(t-2)"""
    f = Heaviside(t - 2)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    expected = exp(-2*s)/s
    assert simplify(F - expected) == 0, f"Expected {expected}, got {F}"
test("fwd: L{Heaviside(t-2)} = e^(-2s)/s", fwd_heaviside)

def fwd_dirac():
    """Student types: DiracDelta(t) — needs t without positive=True"""
    t_dd = symbols("t")  # no positive=True, so DiracDelta(t) isn't auto-simplified to 0
    f = DiracDelta(t_dd)
    F, a_conv, cond = laplace_transform(f, t_dd, s)
    F = simplify(F)
    assert F == 1, f"Expected 1, got {F}"
test("fwd: L{delta(t)} = 1", fwd_dirac)

def fwd_exp_positive():
    """Student types: e^(2*t) — growing exponential"""
    f = exp(2*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 1/(s - 2)) == 0, f"Expected 1/(s-2), got {F}"
test("fwd: L{e^(2t)} = 1/(s-2)", fwd_exp_positive)

def fwd_sqrt_t():
    """Student types: sqrt(t) — fractional power"""
    f = sqrt(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    # L{sqrt(t)} = sqrt(pi)/(2*s^(3/2))
    assert F != 0, f"Should produce a non-zero result, got {F}"
    tex = latex(F)
    assert tex, f"Should produce valid LaTeX, got empty"
test("fwd: L{sqrt(t)} produces result", fwd_sqrt_t)


# ═══════════════════════════════════════════════════════════════════════
#  INVERSE TRANSFORMS  L⁻¹{F(s)} → f(t)
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Inverse Laplace Transforms ══")

def inv_1_over_s():
    """Student types: 1/s"""
    F_raw = 1/s
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    assert f == Heaviside(t) or simplify(f - Heaviside(t)) == 0 or f == 1, \
        f"Expected Heaviside(t) or 1, got {f}"
test("inv: L^-1{1/s} = theta(t)", inv_1_over_s)

def inv_1_over_s2():
    """Student types: 1/s^2"""
    F_raw = 1/s**2
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    assert simplify(f - t*Heaviside(t)) == 0 or simplify(f - t) == 0, \
        f"Expected t*theta(t) or t, got {f}"
test("inv: L^-1{1/s^2} = t*theta(t)", inv_1_over_s2)

def inv_1_over_s3():
    """Student types: 1/s^3"""
    F_raw = 1/s**3
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    # L^-1{1/s^3} = t^2/2 * theta(t)
    test_val = simplify(f.subs(Heaviside(t), 1) - t**2/2)
    assert test_val == 0, f"Expected t^2/2, got {f}"
test("inv: L^-1{1/s^3} = t^2/2", inv_1_over_s3)

def inv_exp_decay():
    """Student types: 1/(s+3)"""
    F_raw = 1/(s+3)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - exp(-3*t))
    assert test_val == 0, f"Expected e^(-3t), got {f}"
test("inv: L^-1{1/(s+3)} = e^(-3t)", inv_exp_decay)

def inv_sin():
    """Student types: 1/(s^2+4)"""
    F_raw = 1/(s**2 + 4)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - sin(2*t)/2)
    assert test_val == 0, f"Expected sin(2t)/2, got {f}"
test("inv: L^-1{1/(s^2+4)} = sin(2t)/2", inv_sin)

def inv_cos():
    """Student types: s/(s^2+9)"""
    F_raw = s/(s**2 + 9)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - cos(3*t))
    assert test_val == 0, f"Expected cos(3t), got {f}"
test("inv: L^-1{s/(s^2+9)} = cos(3t)", inv_cos)

def inv_first_shifting():
    """Student types: 1/(s+1)^2"""
    F_raw = 1/(s+1)**2
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - t*exp(-t))
    assert test_val == 0, f"Expected t*e^(-t), got {f}"
test("inv: L^-1{1/(s+1)^2} = t*e^(-t)", inv_first_shifting)

def inv_partial_fractions():
    """Student types: 1/((s+1)*(s+2)) — needs partial fractions"""
    F_raw = 1/((s+1)*(s+2))
    F_pf = apart(F_raw, s)
    # Verify partial fractions works
    assert F_pf != F_raw, f"Expected partial fractions to decompose, got {F_pf}"
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    expected = exp(-t) - exp(-2*t)
    test_val = simplify(f.subs(Heaviside(t), 1) - expected)
    assert test_val == 0, f"Expected e^(-t) - e^(-2t), got {f}"
test("inv: L^-1{1/((s+1)(s+2))} with partial fractions", inv_partial_fractions)

def inv_completing_square():
    """Student types: (2*s+3)/(s^2+4*s+13)"""
    F_raw = (2*s+3)/(s**2+4*s+13)
    F_pf = apart(F_raw, s)
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    assert f != 0, f"Should produce non-zero result, got {f}"
    tex = latex(f)
    assert tex, f"Should produce valid LaTeX"
test("inv: L^-1{(2s+3)/(s^2+4s+13)} (completing square)", inv_completing_square)

def inv_damped_cos():
    """Student types: s/(s^2+2*s+5)"""
    F_raw = s/(s**2+2*s+5)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    assert f != 0, f"Should produce non-zero result, got {f}"
test("inv: L^-1{s/(s^2+2s+5)} (damped cosine)", inv_damped_cos)

def inv_1_minus_exp():
    """Student types: 1/(s*(s+1))"""
    F_raw = 1/(s*(s+1))
    F_pf = apart(F_raw, s)
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    expected = 1 - exp(-t)
    test_val = simplify(f.subs(Heaviside(t), 1) - expected)
    assert test_val == 0, f"Expected 1-e^(-t), got {f}"
test("inv: L^-1{1/(s(s+1))} = 1-e^(-t)", inv_1_minus_exp)

def inv_poly_plus_exp():
    """Student types: (s+1)/(s^2*(s+2))"""
    F_raw = (s+1)/(s**2*(s+2))
    F_pf = apart(F_raw, s)
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    assert f != 0, f"Should produce non-zero result, got {f}"
test("inv: L^-1{(s+1)/(s^2(s+2))}", inv_poly_plus_exp)

def inv_s2_plus_1():
    """Student types: 1/(s^2+1)"""
    F_raw = 1/(s**2+1)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - sin(t))
    assert test_val == 0, f"Expected sin(t), got {f}"
test("inv: L^-1{1/(s^2+1)} = sin(t)", inv_s2_plus_1)

def inv_three_poles():
    """Student types: 1/((s+1)*(s+3)) — two distinct real poles"""
    F_raw = 1/((s+1)*(s+3))
    F_pf = apart(F_raw, s)
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    expected = (exp(-t) - exp(-3*t))/2
    test_val = simplify(f.subs(Heaviside(t), 1) - expected)
    assert test_val == 0, f"Expected (e^(-t)-e^(-3t))/2, got {f}"
test("inv: L^-1{1/((s+1)(s+3))}", inv_three_poles)


# ═══════════════════════════════════════════════════════════════════════
#  STUDENT TYPO / EDGE CASE TESTING
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Student Input Edge Cases ══")

def student_implicit_multiply():
    """Student might forget * between coefficient and variable: '3t' → normalizeExpr handles"""
    # After normalizeExpr: '3*t' → exprToPython: '3*t'
    f = 3*t
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 3/s**2) == 0, f"Expected 3/s^2, got {F}"
test("student: 3t (implicit multiply) → 3/s^2", student_implicit_multiply)

def student_e_power():
    """Student types: e^(-t) using exp()"""
    f = exp(-t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    assert simplify(F - 1/(s+1)) == 0, f"Expected 1/(s+1), got {F}"
test("student: e^(-t) → 1/(s+1)", student_e_power)

def student_compound_expr():
    """Student types: 3*t^2 + 2*sin(t) — linearity test"""
    f = 3*t**2 + 2*sin(t)
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    expected = 6/s**3 + 2/(s**2+1)
    assert simplify(F - expected) == 0, f"Expected {expected}, got {F}"
test("student: 3t^2 + 2sin(t) (linearity)", student_compound_expr)

def student_negative_exp_inv():
    """Student types: 1/(s-2) for inverse — growing exponential"""
    F_raw = 1/(s-2)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - exp(2*t))
    assert test_val == 0, f"Expected e^(2t), got {f}"
test("student: L^-1{1/(s-2)} = e^(2t)", student_negative_exp_inv)

def student_higher_order_pole():
    """Student types: 1/(s+1)^3 for inverse"""
    F_raw = 1/(s+1)**3
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    expected = t**2 * exp(-t) / 2
    test_val = simplify(f.subs(Heaviside(t), 1) - expected)
    assert test_val == 0, f"Expected t^2*e^(-t)/2, got {f}"
test("student: L^-1{1/(s+1)^3} = t^2*e^(-t)/2", student_higher_order_pole)

def student_constant_numerator():
    """Student types: 5/s for inverse"""
    F_raw = 5/s
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    test_val = simplify(f.subs(Heaviside(t), 1) - 5)
    assert test_val == 0, f"Expected 5, got {f}"
test("student: L^-1{5/s} = 5", student_constant_numerator)

def student_complex_poles():
    """Student types: (s+2)/(s^2+4*s+8) — complex conjugate poles"""
    F_raw = (s+2)/(s**2+4*s+8)
    f = inverse_laplace_transform(F_raw, s, t, noconds=True)
    f = simplify(f)
    assert f != 0, f"Should produce non-zero result"
    # Should contain e^(-2t)*cos(2t) form
    tex = latex(f)
    assert tex, f"Should produce valid LaTeX"
test("student: L^-1{(s+2)/(s^2+4s+8)} (complex poles)", student_complex_poles)

def student_four_poles():
    """Student types: 1/(s*(s+1)*(s+2)) — 3 distinct poles"""
    F_raw = 1/(s*(s+1)*(s+2))
    F_pf = apart(F_raw, s)
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    assert f != 0, f"Should produce non-zero result"
test("student: L^-1{1/(s(s+1)(s+2))} (3 poles)", student_four_poles)


# ═══════════════════════════════════════════════════════════════════════
#  STEPS / LATEX OUTPUT VALIDATION
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Steps & LaTeX Output ══")

def steps_forward_latex():
    """Verify forward transform produces valid steps JSON"""
    f = t**2
    F, a_conv, cond = laplace_transform(f, t, s)
    F = simplify(F)
    steps = []
    steps.append({"title": "Given function", "latex": "f(t) = " + latex(f)})
    steps.append({"title": "Apply Laplace transform", "latex": "F(s) = " + latex(F)})
    steps.append({"title": "Final result", "latex": r"\boxed{\mathcal{L}\{" + latex(f) + r"\} = " + latex(F) + r"}"})
    json_str = json.dumps(steps)
    parsed = json.loads(json_str)
    assert len(parsed) == 3, f"Expected 3 steps, got {len(parsed)}"
    assert "2" in parsed[0]["latex"], f"Step should contain t^2"
test("steps: forward produces valid JSON steps", steps_forward_latex)

def steps_inverse_partial_fractions():
    """Verify inverse with partial fractions shows decomposition step"""
    F_raw = 1/((s+1)*(s+2))
    F_pf = apart(F_raw, s)
    assert F_pf != F_raw, "Partial fractions should decompose"
    f = inverse_laplace_transform(F_pf, s, t, noconds=True)
    f = simplify(f)
    steps = []
    steps.append({"title": "Given F(s)", "latex": "F(s) = " + latex(F_raw)})
    if F_pf != F_raw:
        steps.append({"title": "Partial fraction decomposition", "latex": "F(s) = " + latex(F_pf)})
    steps.append({"title": "Apply inverse Laplace transform", "latex": latex(f)})
    json_str = json.dumps(steps)
    parsed = json.loads(json_str)
    assert len(parsed) == 3, f"Expected 3 steps (with PF), got {len(parsed)}"
    assert "Partial" in parsed[1]["title"], "Should have partial fractions step"
test("steps: inverse with partial fractions", steps_inverse_partial_fractions)

def latex_output_valid():
    """Verify LaTeX output for various transforms"""
    test_cases = [
        (t**2, "forward"),
        (exp(-3*t)*sin(2*t), "forward"),
        (sinh(t), "forward"),
    ]
    for f_expr, mode in test_cases:
        F, _, _ = laplace_transform(f_expr, t, s)
        F = simplify(F)
        tex = latex(F)
        assert len(tex) > 0, f"Empty LaTeX for {f_expr}"
        assert "\\" in tex or tex.isdigit() or "/" in tex, f"Doesn't look like LaTeX: {tex}"
test("latex: output is valid for multiple transforms", latex_output_valid)


# ═══════════════════════════════════════════════════════════════════════
#  GRAPH DATA (PLOT_X, PLOT_Y)
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Graph Data Generation ══")

def graph_forward_sin():
    """Verify plot data generation for sin(2t)"""
    import numpy as np
    from sympy import lambdify
    f = sin(2*t)
    f_num = lambdify(t, f, "numpy")
    t_vals = np.linspace(0, 10, 200)
    y_vals = f_num(t_vals)
    assert len(t_vals) == 200, f"Expected 200 points"
    assert len(y_vals) == 200, f"Expected 200 y values"
    assert all(np.isfinite(y_vals)), "All values should be finite"
    assert max(abs(y_vals)) <= 1.01, f"sin(2t) should be bounded by 1"
test("graph: sin(2t) produces 200 finite points", graph_forward_sin)

def graph_inverse_exp():
    """Verify plot data for e^(-t)"""
    import numpy as np
    from sympy import lambdify
    f = exp(-t)
    f_num = lambdify(t, f, "numpy")
    t_vals = np.linspace(0, 10, 200)
    y_vals = f_num(t_vals)
    assert y_vals[0] > 0.99, f"f(0) should be ~1, got {y_vals[0]}"
    assert y_vals[-1] < 0.001, f"f(10) should be ~0, got {y_vals[-1]}"
test("graph: e^(-t) decays from 1 to ~0", graph_inverse_exp)

def graph_heaviside():
    """Verify plot handles Heaviside function"""
    import numpy as np
    from sympy import lambdify
    f = Heaviside(t - 2)
    f_num = lambdify(t, f, modules=["numpy", {"Heaviside": lambda x: np.heaviside(x, 0.5)}])
    t_vals = np.linspace(0, 10, 200)
    y_vals = np.array([float(f_num(ti)) for ti in t_vals])
    assert all(np.isfinite(y_vals)), "All Heaviside values should be finite"
    # Before t=2 should be 0, after should be 1
    assert y_vals[0] == 0.0, f"f(0) should be 0"
    assert y_vals[-1] == 1.0, f"f(10) should be 1"
test("graph: Heaviside(t-2) renders correctly", graph_heaviside)


# ═══════════════════════════════════════════════════════════════════════
#  CONVERGENCE (ROC) VERIFICATION
# ═══════════════════════════════════════════════════════════════════════
print("\n══ Region of Convergence ══")

def roc_exp_decay():
    """L{e^(-3t)} has ROC Re(s) > -3"""
    f = exp(-3*t)
    F, a_conv, cond = laplace_transform(f, t, s)
    assert a_conv == -3, f"Expected ROC=-3, got {a_conv}"
test("roc: L{e^(-3t)} → Re(s) > -3", roc_exp_decay)

def roc_unit():
    """L{1} has ROC Re(s) > 0"""
    F, a_conv, cond = laplace_transform(S(1), t, s)
    assert a_conv == 0, f"Expected ROC=0, got {a_conv}"
test("roc: L{1} → Re(s) > 0", roc_unit)

def roc_growing():
    """L{e^(2t)} has ROC Re(s) > 2"""
    F, a_conv, cond = laplace_transform(exp(2*t), t, s)
    assert a_conv == 2, f"Expected ROC=2, got {a_conv}"
test("roc: L{e^(2t)} → Re(s) > 2", roc_growing)


# ═══════════════════════════════════════════════════════════════════════
#  SUMMARY
# ═══════════════════════════════════════════════════════════════════════
print(f"\n{'='*60}")
print(f"  TOTAL: {passed + failed}   PASSED: {passed}   FAILED: {failed}")
print(f"{'='*60}")

if errors:
    print("\nFailed tests:")
    for name, err, tb in errors:
        print(f"\n  {name}")
        print(f"    Error: {err}")

sys.exit(0 if failed == 0 else 1)
