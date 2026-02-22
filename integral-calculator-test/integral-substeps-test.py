#!/usr/bin/env python3
"""
Test that rule_to_steps produces substeps for complex integrals.
Outputs: SUBSTEPS:json for each test (expr, step_count, step_titles).
Run: python integral-substeps-test.py
"""
import json
from sympy import *
from sympy.integrals.manualintegrate import (
    integral_steps, DontKnowRule,
    RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule,
    ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule
)

def _c(r): return getattr(r, "integrand", None) or getattr(r, "context", None)
def _s(r): return getattr(r, "variable", None) or getattr(r, "symbol", None)

def rule_to_steps(rule, v, st=None):
    if st is None: st = []
    if rule is None or isinstance(rule, DontKnowRule): return st
    vs = str(_s(rule) or v)
    res = None
    try:
        ctx = _c(rule); res = rule.eval() if hasattr(rule, "eval") else None
        if isinstance(rule, RewriteRule):
            st.append({"title": "Rewrite", "rule": "RewriteRule"})
            rule_to_steps(rule.substep, v, st)
        elif isinstance(rule, AddRule):
            st.append({"title": "Sum rule", "rule": "AddRule"})
            for s in rule.substeps: rule_to_steps(s, v, st)
            if res: st.append({"title": "Combine", "rule": "AddRule"})
        elif isinstance(rule, ConstantTimesRule):
            st.append({"title": "Constant factor", "rule": "ConstantTimesRule"})
            rule_to_steps(rule.substep, v, st)
            if res: st.append({"title": "Simplify", "rule": "ConstantTimesRule"})
        elif isinstance(rule, URule):
            st.append({"title": "u-Substitution", "rule": "URule"})
            rule_to_steps(rule.substep, v, st)
            if res: st.append({"title": "Back substitute", "rule": "URule"})
        elif isinstance(rule, ReciprocalRule):
            st.append({"title": "Reciprocal", "rule": "ReciprocalRule"})
        elif isinstance(rule, ArctanRule):
            st.append({"title": "Arctan", "rule": "ArctanRule"})
        elif isinstance(rule, PartsRule):
            st.append({"title": "Integration by parts", "rule": "PartsRule"})
            rule_to_steps(rule.v_step, v, st); rule_to_steps(rule.second_step, v, st)
            if res: st.append({"title": "Result", "rule": "PartsRule"})
        elif isinstance(rule, (ExpRule, PowerRule)):
            st.append({"title": "Exponential" if isinstance(rule, ExpRule) else "Power rule"})
        elif isinstance(rule, ConstantRule):
            st.append({"title": "Constant"})
        elif isinstance(rule, AlternativeRule):
            for a in rule.alternatives[:1]: rule_to_steps(a, v, st)
            if not st and res: st.append({"title": "Result"})
        else:
            if ctx and res: st.append({"title": type(rule).__name__.replace("Rule", "")})
    except Exception:
        if res: st.append({"title": "Result"})
    return st

# Expressions that should have multiple substeps
SUBSTEP_CASES = [
    ("1/(x**3+1)", "x", 15),      # Rewrite, AddRule, ConstantTimes, URule, Reciprocal, Arctan
    ("x*exp(x)", "x", 3),         # PartsRule, ExpRule
    ("x**2*log(x)", "x", 4),      # PartsRule
    ("sin(x)**2", "x", 3),         # RewriteRule, AddRule
    ("x*sin(x)", "x", 4),         # PartsRule, SinRule, CosRule
    ("1/(x**2+1)", "x", 1),       # ArctanRule - single step
    ("x**2", "x", 1),             # PowerRule - single step
]

if __name__ == "__main__":
    for expr_str, v, min_steps in SUBSTEP_CASES:
        v_sym = symbols(v)
        expr = sympify(expr_str)
        steps_rule = integral_steps(expr, v_sym)
        result = integrate(expr, v_sym) if steps_rule and not isinstance(steps_rule, DontKnowRule) else None
        st = rule_to_steps(steps_rule, v_sym) if steps_rule else []
        if not st and result:
            st = [{"title": "Result", "latex": r"\int " + str(latex(expr)) + r" \,d" + v + " = " + str(latex(result)) + r" + C"}]
        titles = [s.get("title", "") for s in st]
        out = {"expr": expr_str, "step_count": len(st), "min_expected": min_steps, "titles": titles}
        print("SUBSTEPS:" + json.dumps(out, separators=(",", ":")))
