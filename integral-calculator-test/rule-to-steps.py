#!/usr/bin/env python3
"""Generate step-by-step JSON from SymPy integral_steps. Used to build JSP snippet."""
import json
from sympy import *
from sympy.integrals.manualintegrate import (
    integral_steps, DontKnowRule,
    RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule,
    ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule
)

def _ctx(rule):
    return getattr(rule, 'integrand', None) or getattr(rule, 'context', None)

def _sym(rule):
    return getattr(rule, 'variable', None) or getattr(rule, 'symbol', None)

def rule_to_steps(rule, v, steps=None):
    if steps is None:
        steps = []
    if rule is None or isinstance(rule, DontKnowRule):
        return steps
    v_sym = _sym(rule)
    v_str = str(v_sym) if v_sym else str(v)
    try:
        ctx = _ctx(rule)
        res = rule.eval() if hasattr(rule, 'eval') else None
        if isinstance(rule, RewriteRule):
            steps.append({
                'title': 'Rewrite',
                'latex': r'\int ' + latex(ctx) + r' \,d' + v_str + r' = \int ' + latex(rule.rewritten) + r' \,d' + v_str,
                'rule': 'RewriteRule'
            })
            rule_to_steps(rule.substep, v, steps)
        elif isinstance(rule, AddRule):
            steps.append({
                'title': 'Sum rule',
                'latex': r'\int (f+g)\,d' + v_str + r' = \int f\,d' + v_str + r' + \int g\,d' + v_str
            })
            for s in rule.substeps:
                rule_to_steps(s, v, steps)
            if res:
                steps.append({'title': 'Combine', 'latex': '= ' + latex(res) + r' + C'})
        elif isinstance(rule, ConstantTimesRule):
            steps.append({
                'title': 'Constant factor',
                'latex': r'\int ' + latex(ctx) + r' \,d' + v_str + r' = ' + latex(rule.constant) + r' \int ' + latex(rule.other) + r' \,d' + v_str
            })
            rule_to_steps(rule.substep, v, steps)
            if res:
                steps.append({'title': 'Simplify', 'latex': '= ' + latex(res) + r' + C'})
        elif isinstance(rule, URule):
            steps.append({
                'title': 'u-Substitution',
                'latex': r'Let\ u = ' + latex(rule.u_func) + r',\quad \frac{du}{d' + v_str + r'} = ' + latex(rule.u_func.diff(v_sym))
            })
            rule_to_steps(rule.substep, v, steps)
            if res:
                steps.append({'title': 'Back substitute', 'latex': '= ' + latex(res) + r' + C'})
        elif isinstance(rule, ReciprocalRule):
            steps.append({
                'title': 'Reciprocal',
                'latex': r'\int \frac{1}{' + latex(rule.base) + r'} \,d' + v_str + r' = \ln|' + latex(rule.base) + r'| + C = ' + latex(res)
            })
        elif isinstance(rule, ArctanRule):
            steps.append({
                'title': 'Arctan',
                'latex': r'\int \frac{1}{' + latex(rule.a + rule.b*v_sym**2) + r' + ' + str(rule.c) + r'} \,d' + v_str + r' = ' + latex(res) + r' + C'
            })
        elif isinstance(rule, PartsRule):
            steps.append({
                'title': 'Integration by parts',
                'latex': r'\int u\,dv = uv - \int v\,du.\quad u=' + latex(rule.u) + r',\ dv=' + latex(rule.dv) + r'\,d' + v_str
            })
            rule_to_steps(rule.v_step, v, steps)
            rule_to_steps(rule.second_step, v, steps)
            if res:
                steps.append({'title': 'Result', 'latex': '= ' + latex(res) + r' + C'})
        elif isinstance(rule, ExpRule):
            steps.append({
                'title': 'Exponential',
                'latex': r'\int ' + latex(ctx) + r' \,d' + v_str + r' = ' + latex(res) + r' + C'
            })
        elif isinstance(rule, PowerRule):
            steps.append({
                'title': 'Power rule',
                'latex': r'\int ' + latex(ctx) + r' \,d' + v_str + r' = ' + latex(res) + r' + C'
            })
        elif isinstance(rule, ConstantRule):
            steps.append({
                'title': 'Constant',
                'latex': r'\int ' + latex(rule.constant) + r' \,d' + v_str + r' = ' + latex(res)
            })
        elif isinstance(rule, AlternativeRule):
            for alt in rule.alternatives[:1]:
                rule_to_steps(alt, v, steps)
            if not steps and res:
                steps.append({'title': 'Result', 'latex': '= ' + latex(res) + r' + C'})
        else:
            if ctx and res:
                steps.append({
                    'title': type(rule).__name__.replace('Rule', ''),
                    'latex': r'\int ' + latex(ctx) + r' \,d' + v_str + r' = ' + latex(res) + r' + C'
                })
    except Exception:
        if res:
            steps.append({'title': 'Result', 'latex': '= ' + latex(res) + r' + C'})
    return steps


if __name__ == '__main__':
    x = symbols('x')
    expr = 1/(x**3 + 1)
    steps_rule = integral_steps(expr, x)
    result = integrate(expr, x)
    st = rule_to_steps(steps_rule, x)
    if not st:
        st = [{'title': 'Result', 'latex': r'\int ' + latex(expr) + r' \,dx = ' + latex(result) + r' + C'}]
    print('STEPS:', json.dumps(st, separators=(',', ':')))
    print('RESULT=', latex(result))
    print('EXPR=', latex(expr))
