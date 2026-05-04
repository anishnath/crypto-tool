#!/usr/bin/env python3
"""
sympy-cases-test.py — exercises the SymPy power-engine template embedded
in logarithm-calculator.jsp directly against a local SymPy install.

The JSP carries a `<script type="text/x-python" id="lc-sympy-template">`
block whose source contains %MODE%, %VAR%, %RAW_B64% placeholders.  The
JS code wraps it in fetch() to /OneCompilerFunctionality.  This test
extracts the same template, substitutes placeholders for each case, and
exec()s it in-process — verifying the math correctness without needing
a server.

Run:  python3 sympy-cases-test.py
      (or `npm run test:sympy` from this directory)

Requirements:  Python 3.8+, sympy (any modern version)
"""
import re
import sys
import io
import json
import base64
import contextlib
import os

JSP_PATH = os.path.normpath(
    os.path.join(os.path.dirname(__file__),
                 '..', 'src', 'main', 'webapp', 'logarithm-calculator.jsp'))


def extract_template():
    """Pull the Python source out of the JSP <script type="text/x-python">."""
    with open(JSP_PATH, encoding='utf-8') as f:
        s = f.read()
    m = re.search(
        r'<script type="text/x-python" id="lc-sympy-template">(.*?)</script>',
        s, re.DOTALL)
    if not m:
        sys.exit('FATAL: SymPy template not found in JSP')
    return m.group(1).strip()


TEMPLATE = extract_template()


def run(mode, raw, var='x'):
    """Substitute placeholders and exec the template, returning stdout."""
    code = (TEMPLATE
            .replace('%MODE%', mode)
            .replace('%VAR%', var)
            .replace('%RAW_B64%', base64.b64encode(raw.encode()).decode()))
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        try:
            exec(code, {})
        except SystemExit:
            pass
        except Exception as ex:
            return f'EXC:{type(ex).__name__}:{ex}'
    return buf.getvalue().strip()


def parse(out):
    """Pull RESULT / EXTRANEOUS / NOSOL / ERROR from stdout into a dict."""
    rec = {'result': None, 'extraneous': [], 'nosol': False, 'error': None}
    for line in out.splitlines():
        if line.startswith('RESULT:'):
            try:
                rec['result'] = json.loads(line[len('RESULT:'):])
            except json.JSONDecodeError as e:
                rec['error'] = f'bad-result-json: {e}'
        elif line.startswith('EXTRANEOUS:'):
            try:
                rec['extraneous'] = json.loads(line[len('EXTRANEOUS:'):])
            except json.JSONDecodeError as e:
                rec['error'] = f'bad-extraneous-json: {e}'
        elif line.startswith('NOSOL'):
            rec['nosol'] = True
        elif line.startswith('ERROR:'):
            rec['error'] = line[len('ERROR:'):]
    return rec


# ─── Test infrastructure ─────────────────────────────────────────────
_pass, _fail = 0, 0
failures = []


def case(label, mode, raw, *, var='x', expect_plain=None,
         expect_method=None, expect_nosol=False, expect_extraneous_count=None,
         expect_error=None, expect_no_error=True):
    """One test case.  Set the expectations relevant to the mode."""
    global _pass, _fail
    out = run(mode, raw, var)
    rec = parse(out)

    fails = []
    if expect_error is not None:
        if rec['error'] is None or expect_error not in rec['error']:
            fails.append(f"expected error containing {expect_error!r}, got {rec['error']!r}")
    elif expect_no_error and rec['error']:
        fails.append(f"unexpected error: {rec['error']}")

    if expect_nosol:
        if not rec['nosol']:
            fails.append(f"expected NOSOL, got result={rec['result']}")
    if expect_plain is not None:
        if not rec['result'] or rec['result'].get('plain') != expect_plain:
            fails.append(f"expected plain={expect_plain!r}, got {rec['result']!r}")
    if expect_method is not None:
        if not rec['result'] or expect_method not in rec['result'].get('method', ''):
            fails.append(f"expected method containing {expect_method!r}, got {rec['result']!r}")
    if expect_extraneous_count is not None:
        if len(rec['extraneous']) != expect_extraneous_count:
            fails.append(f"expected {expect_extraneous_count} extraneous, got {len(rec['extraneous'])}: {rec['extraneous']}")

    if fails:
        _fail += 1
        failures.append((label, fails, rec))
        print(f"  ✗  {label}")
        for f in fails:
            print(f"      {f}")
    else:
        _pass += 1
        print(f"  ✓  {label}")


# ─── Tests ───────────────────────────────────────────────────────────
print('═══ Expand mode (SymPy expand_log, force=True) ═══')
case('expand: log(x²y) → 2log(x)+log(y)',
     'expand', 'log(x^2*y)',
     expect_plain='2*log(x) + log(y)',
     expect_method='Expand')

case('expand: log(x/y) → log(x) - log(y)',
     'expand', 'log(x/y)',
     expect_plain='log(x) - log(y)',
     expect_method='Expand')

case('expand: log(x³) → 3·log(x)',
     'expand', 'log(x^3)',
     expect_plain='3*log(x)',
     expect_method='Expand')

case('expand: equation rejected with error',
     'expand', 'log(x) = 5',
     expect_error='Expand mode does not accept equations')


print('\n═══ Condense mode (SymPy logcombine, force=True) ═══')
case('condense: log(x) + log(y) → log(xy)',
     'condense', 'log(x) + log(y)',
     expect_plain='log(x*y)',
     expect_method='Condense')

case('condense: 2·log(x) + log(y) → log(x²y)',
     'condense', '2*log(x) + log(y)',
     expect_plain='log(x**2*y)',
     expect_method='Condense')

case('condense: log(x) - log(y) → log(x/y)',
     'condense', 'log(x) - log(y)',
     expect_plain='log(x/y)',
     expect_method='Condense')


print('\n═══ Simplify mode ═══')
case('simplify: log(e²) → 2  (e→E substitution)',
     'simplify', 'log(e^2)',
     expect_plain='2',
     expect_method='Simplify')

case('simplify: log(e) → 1',
     'simplify', 'log(e)',
     expect_plain='1',
     expect_method='Simplify')

case('simplify: log10(1000) → 3',
     'simplify', 'log10(1000)',
     expect_plain='3',
     expect_method='Simplify')


print('\n═══ Evaluate mode ═══')
case('evaluate: log2(8) → 3',
     'evaluate', 'log2(8)',
     expect_plain='3',
     expect_method='Evaluate')

case('evaluate: log10(100) → 2',
     'evaluate', 'log10(100)',
     expect_plain='2',
     expect_method='Evaluate')

case('evaluate: log(e^3) → 3',
     'evaluate', 'log(e^3)',
     expect_plain='3',
     expect_method='Evaluate')


print('\n═══ Solve mode ═══')
case('solve: log2(x) = 5 → x = 32',
     'solve', 'log2(x) = 5',
     expect_plain='x = 32',
     expect_method='Solve')

case('solve: log10(x) = 3 → x = 1000',
     'solve', 'log10(x) = 3',
     expect_plain='x = 1000',
     expect_method='Solve')

case('solve: log(x) = 2 → x = exp(2)',
     'solve', 'log(x) = 2',
     expect_plain='x = exp(2)',
     expect_method='Solve')

case('solve: log(x-1) = 0 → x = 2',
     'solve', 'log(x-1) = 0',
     expect_plain='x = 2',
     expect_method='Solve')

case('solve: log2(x+2) - log2(x) = 2 → x = 2/3',
     'solve', 'log2(x+2) - log2(x) = 2',
     expect_plain='x = 2/3',
     expect_method='Solve')

case('solve: log(x²) = 2 → x = ±e (both valid since x² > 0)',
     'solve', 'log(x^2) = 2',
     expect_plain='x = -E  or  x = E',
     expect_method='Solve')


print('\n═══ Domain filter (extraneous-root rejection) ═══')
# These are the highest-impact tests — they verify that solutions which
# would make any log() argument ≤ 0 are reported as extraneous, not
# silently included as today's nerdamer-only path does.
case('domain: log(x) + log(x-2) = log(3) → x = 3 (rejects x = -1)',
     'solve', 'log(x) + log(x-2) = log(3)',
     expect_plain='x = 3',
     expect_method='Solve')

case('domain: log(x) + log(x-1) = log(2) → x = 2 (rejects x = -1)',
     'solve', 'log(x) + log(x-1) = log(2)',
     expect_plain='x = 2',
     expect_method='Solve')

case('domain: log(x-2) + log(x+1) = log(4) → x = 3',
     'solve', 'log(x-2) + log(x+1) = log(4)',
     expect_plain='x = 3',
     expect_method='Solve')


print('\n═══ Edge cases ═══')
case('mixed: log_2 and ln in same expression',
     'expand', 'ln(x) + log2(y)',
     expect_method='Expand')  # plain form depends on SymPy's representation

case('mode validation: solve without `=`',
     'solve', 'log(8)',
     # No equation → falls through to evaluate
     expect_method='Evaluate')

case('mode validation: simplify on equation rejected',
     'simplify', 'log(x) = 1',
     expect_error='Simplify mode does not accept equations')

case('mode validation: condense on equation rejected',
     'condense', 'log(x) = 1',
     expect_error='Condense mode does not accept equations')


print('\n═══ Rewrite mode (Fix #1: exponential ↔ logarithmic) ═══')
# Easy-#4 from the user's audit list.
case('rewrite: 5^3 = 125 → log_5(125) = 3',
     'rewrite', '5^3 = 125',
     expect_plain='log_5(125) = 3',
     expect_method='exponential')

case('rewrite: log_5(125) = 3 → 5**(3) = 125',
     'rewrite', 'log_5(125) = 3',
     expect_plain='5**(3) = 125',
     expect_method='log')

case('rewrite: 2^10 = 1024 → log_2(1024) = 10',
     'rewrite', '2^10 = 1024',
     expect_plain='log_2(1024) = 10',
     expect_method='exponential')

case('rewrite: requires equation',
     'rewrite', 'log(x)',
     expect_error='Rewrite mode needs an equation')


print('\n═══ Variable-base solving (Fix #6: free-form variable input) ═══')
# Hard-#13 — solving for the BASE k.  Previously blocked by the
# select#lc-var dropdown that only allowed x/y/t.
case('var=k: log_k(8) + log_k(27) = 5  →  k = 6^(3/5)',
     'solve', 'logb(8, k) + logb(27, k) = 5', var='k',
     expect_plain='k = 6**(3/5)',
     expect_method='Solve')

case('var=n: log_2(n) = 8  →  n = 256',
     'solve', 'log2(n) = 8', var='n',
     expect_plain='n = 256',
     expect_method='Solve')


print('\n═══ Recursion guard (Fix #2: graceful failure on JEE-style nested logs) ═══')
# Scholar-#24 — previously crashed with raw RecursionError.
case('JEE: x^(log_5 x) + x^(log_5(5/x)) = 25 → graceful error',
     'solve', 'x^(log5(x)) + x^(log5(5/x)) = 25',
     expect_error='too deeply nested')


print('\n═══ Lambert-W numeric companion (Fix #4) ═══')
# Hard-#14 — previously returned `LambertW(...)/log(2)` only.  Now
# accompanied by `numeric` field with a decimal approximation.
def case_with_numeric(label, mode, raw, var, expect_numeric_substring):
    global _pass, _fail
    out = run(mode, raw, var)
    rec = parse(out)
    if not rec.get('result'):
        _fail += 1
        failures.append((label, [f'no result: {rec}'], rec))
        print(f'  ✗  {label}\n      no result: {rec}')
        return
    numeric = rec['result'].get('numeric')
    if not numeric or expect_numeric_substring not in numeric:
        _fail += 1
        failures.append((label, [f'expected numeric containing {expect_numeric_substring!r}, got {numeric!r}'], rec))
        print(f'  ✗  {label}\n      expected numeric ~{expect_numeric_substring}, got {numeric!r}')
        return
    _pass += 1
    print(f'  ✓  {label}  (numeric = {numeric})')

case_with_numeric('LambertW: 2^x · 3^(log_3 x) = 72  →  x ≈ 4.12',
    'solve', '2^x * 3^(log3(x)) = 72', 'x', '4.1')


print('\n═══ Symbolic-base cleanup (Fix #5) ═══')
# Basic-#7 — previously returned `log((c**4)**(1/log(b)))` — clean math
# but unreadable display.  Cleanup post-processor unwinds it to
# `4*log(c)/log(b)`.
case('symbolic-base simplify: log_b(a²c³) - 2·log_b(a) + log_b(c)  →  4·log(c)/log(b)',
     'simplify', 'logb(a^2*c^3, b) - 2*logb(a, b) + logb(c, b)',
     expect_plain='4*log(c)/log(b)',
     expect_method='Simplify')


print('\n═══ Symbolic-parameter solve (Fix #7) ═══')
# Scholar-#19 — previously NOSOL because the domain filter rejected all
# parameter-dependent candidates.  With parameter-aware filter, returns
# the cubic roots in terms of `a`.
def case_param(label, mode, raw, var, expect_substring):
    global _pass, _fail
    out = run(mode, raw, var)
    rec = parse(out)
    if not rec.get('result'):
        _fail += 1
        failures.append((label, [f'no result: {rec}'], rec))
        print(f'  ✗  {label}\n      no result: {rec}')
        return
    plain = rec['result'].get('plain', '')
    if expect_substring not in plain:
        _fail += 1
        failures.append((label, [f'expected plain to contain {expect_substring!r}, got {plain!r}'], rec))
        print(f'  ✗  {label}')
        return
    _pass += 1
    print(f'  ✓  {label}')

case_param('parameter `a`: log_a(x²-5x+6) + log_a(x-1) = 2  →  x in terms of a',
    'solve', 'logb(x^2-5*x+6, a) + logb(x-1, a) = 2', 'x', 'a')


print('\n═══ Systems of log equations (Fix #12: closes the last open audit gap) ═══')
# Hard-#12 — the original audit problem.  log_3(x) + log_3(y) = 4 means
# xy = 81; log_3(x/y) = 2 means x/y = 9; so x = 27, y = 3.
case('system: log_3(x)+log_3(y)=4 ; log_3(x/y)=2  →  (x=27, y=3)',
     'solve', 'log3(x) + log3(y) = 4 ; log3(x/y) = 2', var='x,y',
     expect_plain='(x = 27, y = 3)',
     expect_method='Solve System')

# Newline separator works equivalently
case('system newline separator: same problem with \\n instead of ;',
     'solve', 'log3(x) + log3(y) = 4\nlog3(x/y) = 2', var='x,y',
     expect_plain='(x = 27, y = 3)',
     expect_method='Solve System')

# Two solutions — log + linear, both valid
case('system mixed: ln(x)+ln(y)=ln(6) ; x+y=5  →  (2,3) or (3,2)',
     'solve', 'ln(x)+ln(y)=ln(6) ; x+y=5', var='x,y',
     expect_plain='(x = 2, y = 3)  or  (x = 3, y = 2)',
     expect_method='Solve System')

# Inconsistent system — NOSOL
case('system inconsistent: log(x)+log(y)=2 ; log(x)+log(y)=5  →  NOSOL',
     'solve', 'log(x)+log(y)=2 ; log(x)+log(y)=5', var='x,y',
     expect_nosol=True)

# Error: system without variable spec
case('system error: missing var spec',
     'solve', 'log(x)+log(y)=4 ; x=y', var='',
     expect_error='requires variables')


print('\n═══ Friendly redirect for Solve-mode no-`=` symbolic input (chip-failure fix) ═══')
# When a user clicked the `log(x²y)` example chip while still in the
# default Solve mode, the old TypeError was raw and confusing.  Now the
# Python emits a helpful redirect.
case('solve no-=, log expr → friendly redirect to Expand/Condense/Simplify',
     'solve', 'log(x^2*y)',
     expect_error='switch to Expand, Condense, or Simplify')

case('solve no-=, plain expr → friendly redirect (no log mention)',
     'solve', 'x^2 + 1',
     expect_error='Got expression only')


print('\n═══ Every example chip works in its assigned mode (regression set) ═══')
# Each chip in the JSP carries a data-mode attribute.  These cases mirror
# every chip exactly so future chip changes are caught by the test suite.
for label, raw, mode, var, expect_plain in [
    ('chip ln(x)=2 (solve)',                                   'ln(x)=2',                          'solve',    'x',   'x = exp(2)'),
    ('chip log10(x)=3 (solve)',                                'log10(x)=3',                       'solve',    'x',   'x = 1000'),
    ('chip log2(8) (evaluate)',                                'log2(8)',                          'evaluate', 'x',   '3'),
    ('chip log(x)+log(y) (condense)',                          'log(x)+log(y)',                    'condense', 'x',   'log(x*y)'),
    ('chip log(x^2*y) (expand)',                               'log(x^2*y)',                       'expand',   'x',   '2*log(x) + log(y)'),
    ('chip 2log(x)-log(y) (condense)',                         '2*log(x)-log(y)',                  'condense', 'x',   'log(x**2/y)'),
    ('chip log(e^2) (simplify)',                               'log(e^2)',                         'simplify', 'x',   '2'),
    ('chip log_3(x+2)-log_3(x)=2 (solve)',                     'log3(x+2)-log3(x)=2',              'solve',    'x',   'x = 1/4'),
    ('chip system log_3(x)+log_3(y)=4;log_3(x/y)=2 (solve)',   'log3(x)+log3(y)=4 ; log3(x/y)=2',  'solve',    'x,y', '(x = 27, y = 3)'),
    ('chip 5^3=125 (rewrite)',                                 '5^3 = 125',                        'rewrite',  'x',   'log_5(125) = 3'),
]:
    case(label, mode, raw, var=var, expect_plain=expect_plain)


print('\n═══ STEPS line — pedagogical step-trace emitter ═══')
# Each call to the SymPy template should emit a STEPS:json line alongside
# RESULT (when steps are available).  Tests verify shape + key contents.

def parse_steps(out):
    """Return the list of step dicts emitted by the Python template."""
    for line in out.splitlines():
        if line.startswith('STEPS:'):
            try:
                return json.loads(line[len('STEPS:'):])
            except json.JSONDecodeError:
                return None
    return None

def case_steps(label, mode, raw, *, var='x',
               expect_min_count=1, expect_rule_substring=None):
    global _pass, _fail
    out = run(mode, raw, var)
    steps = parse_steps(out)
    if steps is None:
        _fail += 1
        failures.append((label, [f'no STEPS line in output: {out[:120]!r}'], None))
        print(f'  ✗  {label}\n      no STEPS line emitted')
        return
    if len(steps) < expect_min_count:
        _fail += 1
        failures.append((label, [f'expected ≥{expect_min_count} steps, got {len(steps)}'], None))
        print(f'  ✗  {label} — only {len(steps)} step(s)')
        return
    # Each step must have rule, label, before_latex, after_latex keys
    required = {"rule", "label", "before_latex", "after_latex"}
    for i, s in enumerate(steps):
        missing = required - set(s.keys())
        if missing:
            _fail += 1
            failures.append((label, [f'step[{i}] missing keys: {missing}'], None))
            print(f'  ✗  {label} — step {i} missing {missing}')
            return
    if expect_rule_substring:
        all_rules = " ".join(s.get('rule', '') for s in steps)
        if expect_rule_substring not in all_rules:
            _fail += 1
            failures.append((label, [f"expected rule substring {expect_rule_substring!r} in {all_rules!r}"], None))
            print(f'  ✗  {label} — expected rule containing {expect_rule_substring!r}')
            return
    _pass += 1
    print(f'  ✓  {label}  ({len(steps)} step(s))')


# Expand mode steps
case_steps('expand log(x²·y/z) → STEPS with quotient/product/power',
    'expand', 'log(x^2*y/z)', expect_min_count=1, expect_rule_substring='LR_')
case_steps('expand log(x³) → STEPS with power rule',
    'expand', 'log(x^3)', expect_min_count=1, expect_rule_substring='LR_power')
case_steps('expand log(xy) → STEPS with product rule',
    'expand', 'log(x*y)', expect_min_count=1, expect_rule_substring='LR_product')

# Condense mode steps
case_steps('condense 2·log(x)+log(y) → STEPS with combine',
    'condense', '2*log(x) + log(y)', expect_min_count=1, expect_rule_substring='LR_inverse')
case_steps('condense log(x)-log(y) → STEPS with combine',
    'condense', 'log(x) - log(y)', expect_min_count=1, expect_rule_substring='LR_inverse')

# Solve mode steps (multi-step trace)
case_steps('solve log(x)+log(x-2)=log(3) → ≥2 steps with domain check',
    'solve', 'log(x)+log(x-2)=log(3)', expect_min_count=2,
    expect_rule_substring='LR_solve')
case_steps('solve log_2(x)=5 → ≥2 steps',
    'solve', 'log2(x) = 5', expect_min_count=2,
    expect_rule_substring='LR_solve')

# Rewrite mode steps (always 2-step trace)
case_steps('rewrite 5³=125 → 2 steps (identify → apply definition)',
    'rewrite', '5^3 = 125', expect_min_count=2,
    expect_rule_substring='LR_log_form')
case_steps('rewrite log_5(125)=3 → 2 steps',
    'rewrite', 'log_5(125) = 3', expect_min_count=2,
    expect_rule_substring='LR_exp_form')


# ─── Summary ─────────────────────────────────────────────────────────
print('\n═══ Summary ═══')
print(f'Total: {_pass} passed, {_fail} failed')
if _fail:
    print('\nFAILED CASES:')
    for label, fails, rec in failures:
        print(f'  • {label}')
        for f in fails:
            print(f'      {f}')
        print(f'      raw record: {rec}')
    sys.exit(1)
print('All Python/SymPy tests passed ✓')
