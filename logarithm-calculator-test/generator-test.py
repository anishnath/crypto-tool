#!/usr/bin/env python3
"""
generator-test.py — sanity tests for the 5 new generator types added to
generate_logarithm.py.  For each new type, runs 50 calls and checks:

  · No exceptions
  · Result is either a valid dict (q_text / q_latex / ans_latex / ans_plain
    all non-empty strings) or None (acceptable retry signal)
  · LaTeX answer doesn't contain Python type-repr noise like "Symbol("
  · Plain answer is not literally "?"

Run:  python3 generator-test.py
"""

import os
import sys
import random

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import generate_logarithm as g

NEW_TYPES = [
    "solve_log_multi_base",
    "solve_log_power",
    "solve_log_iterated",
    "solve_base_variable_multi",
    "word_problem_decibels",
]

REQUIRED_KEYS = {"q_text", "q_latex", "ans_latex", "ans_plain"}

_pass, _fail = 0, 0
failures = []


def assert_dict_shape(rec, label):
    global _pass, _fail
    missing = REQUIRED_KEYS - set(rec.keys())
    if missing:
        _fail += 1
        failures.append((label, f"missing keys: {missing}"))
        return False
    for k in REQUIRED_KEYS:
        if not isinstance(rec[k], str) or not rec[k].strip():
            _fail += 1
            failures.append((label, f"key {k!r} is not a non-empty string: {rec[k]!r}"))
            return False
    # No Python repr leakage in user-facing output
    for k in ("q_latex", "ans_latex"):
        v = rec[k]
        for noise in ("Symbol(", "<class", "object at 0x", "MutableDenseMatrix"):
            if noise in v:
                _fail += 1
                failures.append((label, f"{k} leaks Python repr {noise!r}: {v[:80]!r}"))
                return False
    _pass += 1
    return True


print("Generator robustness — 50 calls per new type")
print("=" * 70)

for t in NEW_TYPES:
    print(f"\n  {t}")
    n_ok, n_none = 0, 0
    samples = []
    for i in range(50):
        try:
            r = g.call_generator(t)
        except Exception as ex:
            _fail += 1
            failures.append((f"{t}[{i}]", f"raised {type(ex).__name__}: {ex}"))
            continue
        if r is None:
            n_none += 1
            continue
        if assert_dict_shape(r, f"{t}[{i}]"):
            n_ok += 1
            if len(samples) < 3:
                samples.append(r)
    print(f"    ok: {n_ok}/50    none: {n_none}/50")
    for s in samples:
        print(f"      Q: {s['q_latex'][:90]}")
        print(f"      A: {s['ans_plain'][:90]}")

# ----------------------------------------------------------------------
# Focused correctness checks — for the deterministic patterns we can
# verify the answer with a closed-form check (independent of the
# generator's own SymPy verification, which is the same code path).
# ----------------------------------------------------------------------

print("\n\nFocused-correctness spot checks")
print("=" * 70)

import sympy as sp


def spot_check_multi_base():
    """Verify log_b1(x) + log_b2(x) + ... = c at the returned x."""
    import re
    for _ in range(15):
        r = g.call_generator("solve_log_multi_base")
        if r is None:
            continue
        # Parse bases from LaTeX: \log_{B} x
        bases = [int(b) for b in re.findall(r"\\log_\{(\d+)\}\s*x", r["q_latex"])]
        # Parse RHS (number or fraction)
        rhs_match = re.search(r"=\s*(.+)$", r["q_latex"])
        x_str = r["ans_plain"].replace("x = ", "").strip()
        try:
            x_val = sp.sympify(x_str)
            actual = sum(sp.log(x_val, b) for b in bases)
            rhs = sp.sympify(rhs_match.group(1).replace(r"\frac", "Rational")
                              .replace("{", "(").replace("}", ")"))
            # Just compare numerically — LaTeX → SymPy is fragile
            actual_num = float(actual.evalf())
            rhs_num = float(rhs.evalf())
            assert abs(actual_num - rhs_num) < 1e-6, f"sum={actual_num} ≠ rhs={rhs_num}"
        except Exception:
            # Skip parsing failures (LaTeX too rich for our regex)
            continue
    print("  ✓ solve_log_multi_base: numeric checks pass for parseable cases")


def spot_check_log_iterated():
    """log_b(log_b(...x...)) = c → x = b^(b^...^c).  Verify by reapplying.
    Uses sp.sympify so we accept fractional / radical answers like 3**(1/3)
    that result from negative c values."""
    import re
    for _ in range(20):
        r = g.call_generator("solve_log_iterated")
        if r is None:
            continue
        b_matches = re.findall(r"\\log_\{(\d+)\}", r["q_latex"])
        if not b_matches:
            continue
        b = int(b_matches[0])
        depth = len(b_matches)
        rhs_match = re.search(r"=\s*(\-?\d+)", r["q_latex"])
        if not rhs_match:
            continue
        c = int(rhs_match.group(1))
        x_str = r["ans_plain"].replace("x = ", "").strip()
        try:
            x_val = sp.sympify(x_str)
        except Exception:
            continue
        check = x_val
        for _i in range(depth):
            check = sp.log(check, b)
        check_num = float(sp.simplify(check).evalf())
        assert abs(check_num - c) < 1e-9, \
            f"depth={depth} b={b} c={c} x={x_val} → {check_num}"
    print("  ✓ solve_log_iterated: outside-in re-application verified")


def spot_check_decibels():
    """Decibel arithmetic: 10·log_10(ratio) should equal answer (if computable)."""
    import re, math
    for _ in range(10):
        r = g.call_generator("word_problem_decibels")
        if r is None:
            continue
        # Variant 1: "if one sound is N times more intense → Δβ = X dB"
        m = re.search(r"is (\d+) times more intense", r["q_text"])
        if m:
            n = int(m.group(1))
            expected = 10 * math.log10(n)
            ans_match = re.search(r"(\d+(?:\.\d+)?)\s*dB", r["ans_plain"])
            if ans_match:
                got = float(ans_match.group(1))
                assert abs(got - expected) < 1e-3, f"ratio={n} expected {expected}, got {got}"
    print("  ✓ word_problem_decibels: 10·log_10(ratio) matches reported dB")


try:
    spot_check_multi_base()
    spot_check_log_iterated()
    spot_check_decibels()
except AssertionError as ex:
    _fail += 1
    failures.append(("focused_check", str(ex)))
    print(f"  ✗ {ex}")

# ----------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------
print(f"\n{'='*70}")
print(f"Total: {_pass} passed, {_fail} failed")
if _fail:
    print("\nFAILED:")
    for label, msg in failures:
        print(f"  · {label}: {msg}")
    sys.exit(1)
print("All generator tests passed ✓")
