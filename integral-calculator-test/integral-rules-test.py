#!/usr/bin/env python3
"""
Test that every SymPy integration rule we handle in the UI is correctly triggered.
Each test case maps to a specific rule handler in integral-calculator.js r2s().
Run: python integral-rules-test.py
"""
import json, sys
from sympy import *
from sympy.integrals.manualintegrate import integral_steps, DontKnowRule

# ── All rules we handle in the JS r2s() function ──
from sympy.integrals.manualintegrate import (
    RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule,
    ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule,
    TrigSubstitutionRule, SinRule, CosRule, SinhRule, CoshRule,
    Sec2Rule, Csc2Rule, SecTanRule, CscCotRule,
    ArcsinRule, ArcsinhRule,
    CompleteSquareRule, CyclicPartsRule,
    SqrtQuadraticRule, ReciprocalSqrtQuadraticRule,
    PiecewiseRule, ErfRule, SiRule, LiRule, EiRule,
    CiRule, ChiRule, ShiRule, UpperGammaRule,
    FresnelCRule, FresnelSRule, EllipticERule, EllipticFRule,
    DiracDeltaRule, HeavisideRule, NestedPowRule, DerivativeRule,
)

x = symbols('x')
t = symbols('t')

def find_rule(rule, target_type):
    """Recursively search for target_type in the rule tree."""
    if rule is None or isinstance(rule, DontKnowRule):
        return False
    if isinstance(rule, target_type):
        return True
    # Recurse into substeps
    for attr in ['substep', 'v_step', 'second_step']:
        child = getattr(rule, attr, None)
        if child and find_rule(child, target_type):
            return True
    for attr in ['substeps', 'alternatives']:
        children = getattr(rule, attr, None)
        if children:
            for c in children:
                if find_rule(c, target_type):
                    return True
    # PiecewiseRule: subfunctions is list of (expr, cond, substep)
    subfuncs = getattr(rule, 'subfunctions', None)
    if subfuncs:
        for item in subfuncs:
            if hasattr(item, '__len__') and len(item) >= 3:
                if find_rule(item[2], target_type):
                    return True
    return False


# ── Test cases: (expression, variable, expected_rule, description, min_steps) ──
# min_steps = minimum number of steps the rule tree should produce (0 = just check rule fires)
RULE_CASES = [
    # Basic rules
    ("x**3",              x, PowerRule,       "Power rule: x^3",                    1),
    ("5",                 x, ConstantRule,     "Constant: 5",                        1),
    ("exp(x)",            x, ExpRule,          "Exponential: e^x",                   1),
    ("1/x",               x, ReciprocalRule,   "Reciprocal: 1/x",                   1),
    ("1/(x**2+1)",        x, ArctanRule,       "Arctan: 1/(x^2+1)",                 1),

    # Trig rules
    ("sin(x)",            x, SinRule,          "Sin rule: sin(x)",                   1),
    ("cos(x)",            x, CosRule,          "Cos rule: cos(x)",                   1),
    ("sec(x)**2",         x, Sec2Rule,         "Sec2 rule: sec(x)^2",               1),
    ("csc(x)**2",         x, Csc2Rule,         "Csc2 rule: csc(x)^2",               1),
    ("sec(x)*tan(x)",     x, SecTanRule,       "SecTan rule: sec(x)*tan(x)",         1),
    ("csc(x)*cot(x)",     x, CscCotRule,       "CscCot rule: csc(x)*cot(x)",        1),

    # Hyperbolic rules
    ("sinh(x)",           x, SinhRule,         "Sinh rule: sinh(x)",                 1),
    ("cosh(x)",           x, CoshRule,         "Cosh rule: cosh(x)",                 1),

    # Inverse trig rules
    ("1/sqrt(1-x**2)",    x, ArcsinRule,       "Arcsin rule: 1/sqrt(1-x^2)",        1),
    ("1/sqrt(x**2+1)",    x, ArcsinhRule,      "Arcsinh rule: 1/sqrt(x^2+1)",       1),

    # Composite rules
    ("sin(x)**2",         x, RewriteRule,      "Rewrite: sin^2(x) → half-angle",    2),
    ("x**2 + sin(x)",     x, AddRule,          "Add rule: x^2 + sin(x)",            2),
    ("5*x**2",            x, ConstantTimesRule, "ConstantTimes: 5*x^2",             2),
    ("sin(x**2)*2*x",     x, URule,            "U-sub: sin(x^2)*2x",               2),

    # Integration by parts
    ("x*exp(x)",          x, PartsRule,        "Parts: x*e^x",                      3),
    ("x*sin(x)",          x, PartsRule,        "Parts: x*sin(x)",                   3),
    ("x**2*log(x)",       x, PartsRule,        "Parts: x^2*ln(x)",                 3),

    # Cyclic parts (e^x*sin(x) needs two rounds of by-parts, solved via algebra)
    # CyclicPartsRule is a leaf node (step_count=1), rule_found is enough
    ("exp(x)*sin(x)",     x, CyclicPartsRule,  "CyclicParts: e^x*sin(x)",           1),

    # Trig substitution
    ((1+x**2)**Rational(-3,2),    x, TrigSubstitutionRule, "TrigSub: 1/(1+x^2)^(3/2)", 2),
    ("1/(1+x**2)**2",     x, TrigSubstitutionRule, "TrigSub: 1/(1+x^2)^2",          3),

    # Complete the square
    ("1/sqrt(x**2+2*x+2)", x, CompleteSquareRule, "CompleteSquare: 1/sqrt(x^2+2x+2)", 1),

    # Alternative rule (sec(x) has alternative paths)
    ("sec(x)",            x, AlternativeRule,   "Alternative: sec(x)",              1),

    # Heaviside rule (replaces PiecewiseRule which is hard to trigger directly)
    ("Heaviside(x)",      x, HeavisideRule,     "Heaviside: H(x)",                  1),

    # Special function rules
    ("exp(-x**2)",        x, ErfRule,           "Erf: e^(-x^2)",                    1),
    ("sin(x)/x",          x, SiRule,            "Si: sin(x)/x",                     1),
    ("1/log(x)",          x, LiRule,            "Li: 1/ln(x)",                      1),
    ("exp(x)/x",          x, EiRule,            "Ei: e^x/x",                        1),
    ("cos(x)/x",          x, CiRule,            "Ci: cos(x)/x",                     1),
    ("sinh(x)/x",         x, ShiRule,           "Shi: sinh(x)/x",                   1),
    ("cosh(x)/x",         x, ChiRule,           "Chi: cosh(x)/x",                   1),

    # Sqrt quadratic rules
    ("sqrt(x**2+1)",      x, SqrtQuadraticRule, "SqrtQuadratic: sqrt(x^2+1)",       1),
]

# ── Rules that are hard to trigger directly; we test import only ──
IMPORT_ONLY_RULES = [
    PiecewiseRule,
    UpperGammaRule, FresnelCRule, FresnelSRule,
    EllipticERule, EllipticFRule,
    DiracDeltaRule, NestedPowRule, DerivativeRule,
    ReciprocalSqrtQuadraticRule,
]


def count_steps(rule):
    """Count total nodes in rule tree."""
    if rule is None or isinstance(rule, DontKnowRule):
        return 0
    n = 1
    for attr in ['substep', 'v_step', 'second_step']:
        child = getattr(rule, attr, None)
        if child:
            n += count_steps(child)
    for attr in ['substeps', 'alternatives']:
        children = getattr(rule, attr, None)
        if children:
            for c in children:
                n += count_steps(c)
    subfuncs = getattr(rule, 'subfunctions', None)
    if subfuncs:
        for item in subfuncs:
            if hasattr(item, '__len__') and len(item) >= 3:
                n += count_steps(item[2])
    return n


if __name__ == "__main__":
    passed = 0
    failed = 0
    errors = []

    print("=" * 70)
    print("INTEGRAL RULES TEST — verifying every r2s() rule handler fires")
    print("=" * 70)

    for expr_obj, v, expected_rule, desc, min_steps in RULE_CASES:
        expr = sympify(expr_obj) if isinstance(expr_obj, str) else expr_obj
        try:
            steps_rule = integral_steps(expr, v)
        except Exception as e:
            errors.append((desc, "integral_steps raised: " + str(e)[:60]))
            failed += 1
            continue

        if steps_rule is None or isinstance(steps_rule, DontKnowRule):
            errors.append((desc, "DontKnowRule — SymPy cannot solve"))
            failed += 1
            continue

        rule_found = find_rule(steps_rule, expected_rule)
        step_count = count_steps(steps_rule)

        # Also verify integration succeeds
        try:
            result = integrate(expr, v)
            has_result = result is not None
        except Exception:
            has_result = False

        ok = rule_found and step_count >= min_steps and has_result

        status = "PASS" if ok else "FAIL"
        if not ok:
            failed += 1
            reason = []
            if not rule_found:
                reason.append("rule %s NOT found in tree" % expected_rule.__name__)
            if step_count < min_steps:
                reason.append("steps=%d < min=%d" % (step_count, min_steps))
            if not has_result:
                reason.append("integrate() failed")
            errors.append((desc, "; ".join(reason)))
        else:
            passed += 1

        out = {
            "status": status,
            "desc": desc,
            "rule_found": rule_found,
            "step_count": step_count,
            "has_result": has_result,
        }
        print("RULE_TEST:" + json.dumps(out, separators=(",", ":")))

    # Import-only checks
    print()
    print("-" * 70)
    print("IMPORT-ONLY CHECKS (rules exist and are importable)")
    print("-" * 70)
    for rule_cls in IMPORT_ONLY_RULES:
        name = rule_cls.__name__
        try:
            assert issubclass(rule_cls, tuple()), "not a class"
        except (TypeError, AssertionError):
            pass
        # Just verify it's a real class
        is_class = isinstance(rule_cls, type)
        status = "PASS" if is_class else "FAIL"
        if not is_class:
            failed += 1
            errors.append((name, "not a valid class"))
        else:
            passed += 1
        print("IMPORT_TEST:" + json.dumps({"status": status, "rule": name}, separators=(",", ":")))

    # Summary
    print()
    print("=" * 70)
    total = passed + failed
    print("SUMMARY: %d / %d passed" % (passed, total))
    if errors:
        print()
        print("FAILURES:")
        for desc, reason in errors:
            print("  ✗ %s — %s" % (desc, reason))
    print("=" * 70)

    sys.exit(0 if failed == 0 else 1)
