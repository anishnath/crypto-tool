"""
Matrix Question Bank Generator — Linear Algebra Worksheet
Answers verified by SymPy where applicable.

Mirrors the structure of generate_limits.py / generate_derivatives.py /
generate_integrals.py: per-question-type generator returning a dict,
DIFFICULTY_TYPES mapping basic/medium/hard/scholar to type lists, a
GENERATORS dispatch, and a main loop with SymPy verification + dedup.

Coverage spans the 13 ops the unified Matrix Calculator supports:

  Section 1 — Basic arithmetic
    addition, subtraction, transpose, trace

  Section 2 — Determinant & inverse
    determinant (2x2, 3x3, 4x4, symbolic),
    inverse (2x2, 3x3, 4x4, singular detection)

  Section 3 — Multiplication & power
    multiplication (square + rectangular),
    power A^n (small + larger),
    identity / zero properties

  Section 4 — Rank, RREF, span
    rank, RREF / Gauss-Jordan

  Section 5 — Eigen / characteristic
    eigenvalues (real distinct, repeated),
    eigenvectors (real),
    characteristic polynomial

  Section 6 — Applications
    solve Ax = b via inverse,
    detect singularity / shape errors

Output: src/main/webapp/worksheet/math/linear-algebra/matrices.json
"""

import sympy as sp
import json
import random
import os
import sys

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

NZ  = [-3, -2, -1, 1, 2, 3]                     # nonzero small ints
SML = [-2, -1, 0, 1, 2]                         # small (signed) ints incl. zero
POS = [1, 2, 3, 4]                              # small positives
TINY = [-1, 0, 1, 2]                            # very small — use ONLY where
                                                #   arithmetic blows up otherwise
                                                #   (4×4 inverse, 4×4 char poly,
                                                #   high-power A^n, full p(A))
# Richer mid-range pool for routine 3×3 work — varied entries (no zero so
# matrices don't look sparse), arithmetic still tractable for hand work.
MID = [-3, -2, -1, 1, 2, 3]                     # alias of NZ, for readability
# Slightly wider with controlled zero density — for ops where the occasional
# zero is fine (rank/RREF practice especially benefits from some zeros).
MID_Z = [-3, -2, -1, 0, 1, 2, 3]                # ~14% zero density

# Rational pool for fraction-input questions.  Curated so denominators
# stay simple (2, 3, 4, 6) and numerators are small — keeps arithmetic
# tractable when students compute by hand.
FRAC_POOL = [
    sp.Rational(1, 2), sp.Rational(-1, 2),
    sp.Rational(1, 3), sp.Rational(-1, 3), sp.Rational(2, 3), sp.Rational(-2, 3),
    sp.Rational(1, 4), sp.Rational(-1, 4), sp.Rational(3, 4),
    sp.Rational(1, 6), sp.Rational(5, 6),
    sp.Integer(1), sp.Integer(-1), sp.Integer(2), sp.Integer(-2), sp.Integer(0),
]

def rc(pool):
    return random.choice(pool)

def rand_matrix(rows, cols, pool=None):
    """Random integer matrix with cells from `pool`."""
    if pool is None:
        pool = SML
    return sp.Matrix(rows, cols, lambda i, j: rc(pool))

def rand_invertible(n, pool=None, max_tries=50):
    """Random n×n integer matrix with non-zero determinant."""
    for _ in range(max_tries):
        M = rand_matrix(n, n, pool)
        if M.det() != 0:
            return M
    # Fall back to upper-triangular (always invertible if diag nonzero)
    M = rand_matrix(n, n, pool).as_mutable()
    for i in range(n):
        if M[i, i] == 0:
            M[i, i] = rc(NZ)
    return sp.ImmutableMatrix(M)

def rand_singular(n, pool=None, max_tries=80):
    """Random n×n integer matrix with det = 0 (one row is a copy/scale of another)."""
    if pool is None:
        pool = SML
    for _ in range(max_tries):
        M = rand_matrix(n, n, pool).as_mutable()
        # Force a linear dependency: row i = scalar * row j
        i, j = random.sample(range(n), 2)
        scalar = rc([-2, -1, 1, 2])
        for k in range(n):
            M[i, k] = scalar * M[j, k]
        if M.det() == 0:
            return sp.ImmutableMatrix(M)
    return None

def latex_matrix(M):
    """Force \\begin{pmatrix} formatting (consistent across the worksheet)."""
    return sp.latex(M, mat_str="pmatrix", mat_delim=None).replace("\\left[", "\\begin{pmatrix}").replace("\\right]", "\\end{pmatrix}").replace("\\begin{matrix}", "\\begin{pmatrix}").replace("\\end{matrix}", "\\end{pmatrix}")

def latex_pmatrix(M):
    """Cleaner: SymPy 1.10+ supports mat_str='pmatrix' via printer settings."""
    from sympy.printing.latex import LatexPrinter
    p = LatexPrinter({"mat_str": "pmatrix", "mat_delim": ""})
    return p.doprint(M)

def fmt_matrix(M):
    """Plain-text fallback: list-of-lists notation."""
    return str(M.tolist())

# ===========================================================================
# Section 1 — Basic arithmetic
# ===========================================================================

def gen_addition_2x2():
    A = rand_matrix(2, 2)
    B = rand_matrix(2, 2)
    C = A + B
    return {
        "type": "addition_2x2", "op": "add",
        "matrix_a": A, "matrix_b": B,
        "ans": C,
        "q_text": f"Compute \\(A + B\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_addition_3x3():
    A = rand_matrix(3, 3, MID)
    B = rand_matrix(3, 3, MID)
    C = A + B
    return {
        "type": "addition_3x3", "op": "add",
        "matrix_a": A, "matrix_b": B,
        "ans": C,
        "q_text": f"Compute \\(A + B\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_subtraction_2x2():
    A = rand_matrix(2, 2)
    B = rand_matrix(2, 2)
    C = A - B
    return {
        "type": "subtraction_2x2", "op": "subtract",
        "matrix_a": A, "matrix_b": B,
        "ans": C,
        "q_text": f"Compute \\(A - B\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_subtraction_3x3():
    A = rand_matrix(3, 3, MID)
    B = rand_matrix(3, 3, MID)
    C = A - B
    return {
        "type": "subtraction_3x3", "op": "subtract",
        "matrix_a": A, "matrix_b": B,
        "ans": C,
        "q_text": f"Compute \\(A - B\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_transpose_rectangular():
    rows, cols = rc([(2, 3), (3, 2), (2, 4), (4, 2), (3, 4)])
    A = rand_matrix(rows, cols)
    return {
        "type": "transpose_rectangular", "op": "transpose",
        "matrix_a": A, "ans": A.T,
        "q_text": f"Find the transpose \\(A^T\\) of \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_transpose_square():
    n = rc([2, 3])
    A = rand_matrix(n, n)
    return {
        "type": "transpose_square", "op": "transpose",
        "matrix_a": A, "ans": A.T,
        "q_text": f"Find the transpose \\(A^T\\) of \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_trace_2x2():
    A = rand_matrix(2, 2)
    tr = A.trace()
    return {
        "type": "trace_2x2", "op": "trace",
        "matrix_a": A, "ans": tr,
        "q_text": f"Find the trace \\(\\mathrm{{tr}}(A)\\) of \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_trace_3x3():
    A = rand_matrix(3, 3, MID_Z)
    tr = A.trace()
    return {
        "type": "trace_3x3", "op": "trace",
        "matrix_a": A, "ans": tr,
        "q_text": f"Find the trace \\(\\mathrm{{tr}}(A)\\) of \\(A = {latex_pmatrix(A)}\\)."
    }

# ===========================================================================
# Section 2 — Determinant & inverse
# ===========================================================================

def gen_determinant_2x2():
    A = rand_matrix(2, 2)
    return {
        "type": "determinant_2x2", "op": "determinant",
        "matrix_a": A, "ans": A.det(),
        "q_text": f"Compute \\(\\det(A)\\) for \\(A = {latex_pmatrix(A)}\\) using the rule \\(ad - bc\\)."
    }

def gen_determinant_3x3():
    A = rand_matrix(3, 3, MID)
    return {
        "type": "determinant_3x3", "op": "determinant",
        "matrix_a": A, "ans": A.det(),
        "q_text": f"Compute \\(\\det(A)\\) for \\(A = {latex_pmatrix(A)}\\) using cofactor expansion along row 1."
    }

def gen_determinant_4x4():
    # Slightly bumped from [-1, 0, 1, 2] — varied entries are fine for a
    # det computation (no inverse fractions to worry about); keeps the
    # 4×4 looking like a real exam matrix rather than a sparse 0/1 toy.
    A = rand_matrix(4, 4, [-2, -1, 0, 1, 2])
    return {
        "type": "determinant_4x4", "op": "determinant",
        "matrix_a": A, "ans": A.det(),
        "q_text": f"Compute \\(\\det(A)\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_determinant_symbolic_2x2():
    """det of [[1, a],[b, 1]] = 1 - ab — a classic textbook problem."""
    a, b = sp.symbols('a b')
    cases = [
        (sp.Matrix([[1, a], [b, 1]]),  1 - a*b),
        (sp.Matrix([[a, 1], [1, a]]),  a**2 - 1),
        (sp.Matrix([[a, b], [b, a]]),  a**2 - b**2),
        (sp.Matrix([[a, 0], [0, b]]),  a*b),
    ]
    A, ans = rc(cases)
    return {
        "type": "determinant_symbolic_2x2", "op": "determinant",
        "matrix_a": A, "ans": ans,
        "q_text": f"Compute \\(\\det(A)\\) for \\(A = {latex_pmatrix(A)}\\) and simplify the result."
    }

def gen_inverse_2x2():
    A = rand_invertible(2)
    return {
        "type": "inverse_2x2", "op": "inverse",
        "matrix_a": A, "ans": A.inv(),
        "q_text": f"Find \\(A^{{-1}}\\) for \\(A = {latex_pmatrix(A)}\\), or state that \\(A\\) is singular."
    }

def gen_inverse_3x3():
    A = rand_invertible(3, TINY)
    return {
        "type": "inverse_3x3", "op": "inverse",
        "matrix_a": A, "ans": A.inv(),
        "q_text": f"Find \\(A^{{-1}}\\) for \\(A = {latex_pmatrix(A)}\\) using the adjugate (cofactor) method."
    }

def gen_inverse_4x4():
    """Inverse of a 4x4 — kept simple via integer entries in [-1, 1]."""
    A = rand_invertible(4, [-1, 0, 1])
    try:
        Ainv = A.inv()
    except Exception:
        return None
    return {
        "type": "inverse_4x4", "op": "inverse",
        "matrix_a": A, "ans": Ainv,
        "q_text": f"Find \\(A^{{-1}}\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_inverse_singular_detect():
    """Singular matrix — student should recognize det = 0 and report no inverse."""
    n = rc([2, 3])
    A = rand_singular(n)
    if A is None:
        return None
    return {
        "type": "inverse_singular_detect", "op": "inverse",
        "matrix_a": A, "ans": "singular",
        "q_text": f"Decide whether \\(A = {latex_pmatrix(A)}\\) is invertible, and find \\(A^{{-1}}\\) if it is."
    }

# ===========================================================================
# Section 3 — Multiplication & power
# ===========================================================================

def gen_multiplication_2x2():
    A = rand_matrix(2, 2)
    B = rand_matrix(2, 2)
    return {
        "type": "multiplication_2x2", "op": "multiply",
        "matrix_a": A, "matrix_b": B, "ans": A * B,
        "q_text": f"Compute the matrix product \\(AB\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_multiplication_3x3():
    A = rand_matrix(3, 3, MID)
    B = rand_matrix(3, 3, MID)
    return {
        "type": "multiplication_3x3", "op": "multiply",
        "matrix_a": A, "matrix_b": B, "ans": A * B,
        "q_text": f"Compute the matrix product \\(AB\\) where \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\)."
    }

def gen_multiplication_rectangular():
    """A is m×n, B is n×p, result is m×p — students must check the inner-dim rule."""
    shapes = [
        ((2, 3), (3, 2)),
        ((3, 2), (2, 3)),
        ((2, 3), (3, 4)),
        ((3, 3), (3, 2)),
        ((2, 4), (4, 2)),
    ]
    sa, sb = rc(shapes)
    A = rand_matrix(*sa, pool=MID)
    B = rand_matrix(*sb, pool=MID)
    return {
        "type": "multiplication_rectangular", "op": "multiply",
        "matrix_a": A, "matrix_b": B, "ans": A * B,
        "q_text": (f"Compute the matrix product \\(AB\\) where "
                   f"\\(A = {latex_pmatrix(A)}\\) is \\({sa[0]} \\times {sa[1]}\\) and "
                   f"\\(B = {latex_pmatrix(B)}\\) is \\({sb[0]} \\times {sb[1]}\\). "
                   f"What is the shape of \\(AB\\)?")
    }

def gen_power_n2():
    """A² for a 2x2 matrix."""
    A = rand_matrix(2, 2)
    return {
        "type": "power_n2", "op": "power", "n": 2,
        "matrix_a": A, "ans": A ** 2,
        "q_text": f"Compute \\(A^2\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_power_n3():
    """A³ — entries up to ±3 keep coefficients in roughly the ±50 range."""
    A = rand_matrix(2, 2, MID)
    return {
        "type": "power_n3", "op": "power", "n": 3,
        "matrix_a": A, "ans": A ** 3,
        "q_text": f"Compute \\(A^3\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_power_higher():
    """Higher power — only generate when entries are tiny so the result fits."""
    A = rand_matrix(2, 2, [-1, 0, 1])
    n = rc([4, 5, 6])
    return {
        "type": "power_higher", "op": "power", "n": n,
        "matrix_a": A, "ans": A ** n,
        "q_text": f"Compute \\(A^{{{n}}}\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_power_diagonal():
    """A^n for a diagonal matrix — should leverage the diagonal property."""
    n_dim = rc([2, 3])
    diag = [rc(NZ) for _ in range(n_dim)]
    A = sp.diag(*diag)
    n = rc([3, 4, 5])
    return {
        "type": "power_diagonal", "op": "power", "n": n,
        "matrix_a": A, "ans": A ** n,
        "q_text": (f"Compute \\(A^{{{n}}}\\) for the diagonal matrix \\(A = {latex_pmatrix(A)}\\). "
                   f"(Hint: for diagonal matrices, raising to a power raises each diagonal entry.)")
    }

def gen_identity_property():
    """A · I = A — quick conceptual check."""
    n = rc([2, 3])
    A = rand_matrix(n, n)
    I = sp.eye(n)
    return {
        "type": "identity_property", "op": "multiply",
        "matrix_a": A, "matrix_b": I, "ans": A,
        "q_text": (f"Let \\(A = {latex_pmatrix(A)}\\) and let \\(I\\) be the \\({n}\\times{n}\\) identity matrix. "
                   f"Compute \\(A \\cdot I\\) and explain the result.")
    }

# ===========================================================================
# Section 4 — Rank & RREF
# ===========================================================================

def gen_rank_3x3():
    A = rand_matrix(3, 3, MID_Z)
    return {
        "type": "rank_3x3", "op": "rank",
        "matrix_a": A, "ans": A.rank(),
        "q_text": f"Find \\(\\mathrm{{rank}}(A)\\) for \\(A = {latex_pmatrix(A)}\\) by row-reducing to RREF."
    }

def gen_rank_rectangular():
    rows, cols = rc([(3, 4), (4, 3), (2, 4), (4, 2)])
    A = rand_matrix(rows, cols, MID_Z)
    return {
        "type": "rank_rectangular", "op": "rank",
        "matrix_a": A, "ans": A.rank(),
        "q_text": f"Find \\(\\mathrm{{rank}}(A)\\) for \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_rref_3x3():
    A = rand_matrix(3, 3, MID_Z)
    rref_mat, pivots = A.rref()
    return {
        "type": "rref_3x3", "op": "rref",
        "matrix_a": A, "ans": rref_mat,
        "q_text": f"Find the reduced row echelon form (RREF) of \\(A = {latex_pmatrix(A)}\\)."
    }

def gen_rref_3x4():
    """3x4 — typical augmented system shape."""
    A = rand_matrix(3, 4, MID_Z)
    rref_mat, _ = A.rref()
    return {
        "type": "rref_3x4", "op": "rref",
        "matrix_a": A, "ans": rref_mat,
        "q_text": (f"Apply Gauss-Jordan elimination to bring \\(A = {latex_pmatrix(A)}\\) "
                   f"into reduced row echelon form.")
    }

# ===========================================================================
# Section 5 — Eigen / characteristic
# ===========================================================================

def gen_eigenvalues_2x2_distinct():
    """Generate a 2x2 with two real distinct eigenvalues using A = P D P^{-1}
    structure — guarantees real distinct λ for the answer."""
    for _ in range(40):
        l1, l2 = rc([1, 2, 3, -1, -2]), rc([1, 2, 3, -1, -2])
        if l1 == l2:
            continue
        # Build a random invertible P with small integer entries
        P = rand_invertible(2, [-1, 0, 1])
        D = sp.diag(l1, l2)
        try:
            A = P * D * P.inv()
            if all(c.is_integer for c in A):
                return {
                    "type": "eigenvalues_2x2_distinct", "op": "eigenvalues",
                    "matrix_a": A, "ans": [l1, l2],
                    "q_text": f"Find all eigenvalues of \\(A = {latex_pmatrix(A)}\\)."
                }
        except Exception:
            continue
    return None

def gen_eigenvalues_2x2_general():
    """Random 2x2 — eigenvalues might be complex; only emit real cases."""
    for _ in range(40):
        A = rand_matrix(2, 2)
        eigs = list(A.eigenvals().items())
        if not eigs:
            continue
        if all(v.is_real for v, _ in eigs):
            vals = []
            for v, m in eigs:
                vals.extend([v] * m)
            return {
                "type": "eigenvalues_2x2_general", "op": "eigenvalues",
                "matrix_a": A, "ans": vals,
                "q_text": f"Find all eigenvalues of \\(A = {latex_pmatrix(A)}\\)."
            }
    return None

def gen_eigenvalues_3x3_diagonal():
    """3x3 diagonal — eigenvalues are the diagonal entries (easy)."""
    diag = [rc(NZ), rc(NZ), rc(NZ)]
    A = sp.diag(*diag)
    return {
        "type": "eigenvalues_3x3_diagonal", "op": "eigenvalues",
        "matrix_a": A, "ans": diag,
        "q_text": (f"Find all eigenvalues of the diagonal matrix \\(A = {latex_pmatrix(A)}\\). "
                   f"(For a diagonal matrix the eigenvalues are the diagonal entries.)")
    }

def gen_eigenvalues_3x3_triangular():
    """Upper-triangular 3x3 — eigenvalues are diagonal entries."""
    A = sp.zeros(3, 3).as_mutable()
    diag = [rc(NZ), rc(NZ), rc(NZ)]
    for i in range(3):
        A[i, i] = diag[i]
        for j in range(i+1, 3):
            A[i, j] = rc(SML)
    A = sp.ImmutableMatrix(A)
    return {
        "type": "eigenvalues_3x3_triangular", "op": "eigenvalues",
        "matrix_a": A, "ans": diag,
        "q_text": (f"Find all eigenvalues of the upper-triangular matrix \\(A = {latex_pmatrix(A)}\\). "
                   f"(For triangular matrices the eigenvalues are the diagonal entries.)")
    }

def gen_eigenvectors_2x2():
    """Use the diagonalisable construction so we always get a clean answer."""
    for _ in range(40):
        l1, l2 = rc([1, 2, 3, -1, -2]), rc([1, 2, 3, -1, -2])
        if l1 == l2:
            continue
        P = rand_invertible(2, [-1, 0, 1])
        D = sp.diag(l1, l2)
        try:
            A = P * D * P.inv()
            if not all(c.is_integer for c in A):
                continue
            vects = A.eigenvects()
            if not vects:
                continue
            return {
                "type": "eigenvectors_2x2", "op": "eigenvectors",
                "matrix_a": A, "ans": vects,
                "q_text": (f"Find all eigenvalues and a basis of eigenvectors for \\(A = {latex_pmatrix(A)}\\). "
                           f"For each eigenvalue \\(\\lambda\\), solve \\((A - \\lambda I)v = 0\\).")
            }
        except Exception:
            continue
    return None

def gen_charpoly_2x2():
    A = rand_matrix(2, 2)
    lam = sp.symbols('lambda')
    poly = A.charpoly(lam).as_expr()
    return {
        "type": "charpoly_2x2", "op": "charpoly",
        "matrix_a": A, "ans": poly,
        "q_text": (f"Find the characteristic polynomial \\(p(\\lambda) = \\det(A - \\lambda I)\\) "
                   f"for \\(A = {latex_pmatrix(A)}\\).")
    }

def gen_charpoly_3x3():
    A = rand_matrix(3, 3, MID)
    lam = sp.symbols('lambda')
    poly = A.charpoly(lam).as_expr()
    return {
        "type": "charpoly_3x3", "op": "charpoly",
        "matrix_a": A, "ans": poly,
        "q_text": (f"Find the characteristic polynomial \\(p(\\lambda) = \\det(A - \\lambda I)\\) "
                   f"for \\(A = {latex_pmatrix(A)}\\).")
    }

# ===========================================================================
# Section 6 — Applications
# ===========================================================================

def gen_solve_via_inverse():
    """Solve Ax = b by computing x = A^{-1} b."""
    n = rc([2, 3])
    for _ in range(20):
        A = rand_invertible(n, TINY)
        # Choose x with small integer entries, then compute b = A x so the
        # answer is clean integers.
        x = sp.Matrix(n, 1, [rc([-2, -1, 1, 2]) for _ in range(n)])
        b = A * x
        if all(abs(c) <= 10 for c in b):
            return {
                "type": "solve_via_inverse", "op": "system",
                "matrix_a": A, "matrix_b": b, "ans": x,
                "q_text": (f"Solve the linear system \\(A\\mathbf{{x}} = \\mathbf{{b}}\\) by computing "
                           f"\\(\\mathbf{{x}} = A^{{-1}}\\mathbf{{b}}\\), where "
                           f"\\(A = {latex_pmatrix(A)}\\) and \\(\\mathbf{{b}} = {latex_pmatrix(b)}\\).")
            }
    return None

def gen_shape_compatibility():
    """Conceptual: 'is AB defined? what shape?'"""
    sa = rc([(2, 3), (3, 2), (2, 4), (3, 3), (4, 2)])
    # Coin flip: pick B compatible with A or not
    if random.random() < 0.6:
        sb = (sa[1], rc([2, 3, 4]))
        compatible = True
    else:
        # Pick incompatible inner dim
        inner = rc([d for d in [2, 3, 4] if d != sa[1]])
        sb = (inner, rc([2, 3, 4]))
        compatible = False
    # answer_latex feeds straight into katex.render(...) — NO `\(...\)`
    # delimiters here.  Those belong in `question_text` (which goes
    # through renderInlineLatex); putting them on this field renders
    # them as literal text.
    if compatible:
        ans_text = (f"\\text{{Yes, defined.}}\\;\\; AB \\;\\text{{is}}\\; "
                    f"{sa[0]} \\times {sb[1]}")
        ans_plain = f"Yes, defined: AB is {sa[0]}x{sb[1]}"
    else:
        ans_text = (f"\\text{{Not defined: inner dimensions }} {sa[1]} "
                    f"\\;\\text{{ and }}\\; {sb[0]} \\;\\text{{ don't match.}}")
        ans_plain = (f"Not defined (inner dims {sa[1]} != {sb[0]})")
    return {
        "type": "shape_compatibility", "op": "multiply", "concept": True,
        "matrix_a_shape": sa, "matrix_b_shape": sb,
        "ans_text": ans_text, "ans_plain": ans_plain,
        "q_text": (f"\\(A\\) is a \\({sa[0]} \\times {sa[1]}\\) matrix and \\(B\\) is a "
                   f"\\({sb[0]} \\times {sb[1]}\\) matrix. Is the product \\(AB\\) defined? "
                   f"If so, what is its shape?")
    }


# ===========================================================================
# Section 7 — Fraction-input questions
# ===========================================================================
#
# Cells drawn from FRAC_POOL — students get practice with rational
# arithmetic in matrix operations.  All answers verified by SymPy so
# fractions stay in lowest terms.

def gen_determinant_2x2_fraction():
    A = rand_matrix(2, 2, FRAC_POOL)
    if A.det() == 0:
        return None  # avoid trivially-singular fluke
    return {
        "type": "determinant_2x2_fraction", "op": "determinant",
        "matrix_a": A, "ans": A.det(),
        "q_text": (f"Compute \\(\\det(A)\\) for \\(A = {latex_pmatrix(A)}\\). "
                   f"Express the result as a fraction in lowest terms.")
    }

def gen_addition_fraction():
    rows, cols = rc([(2, 2), (2, 3), (3, 2)])
    A = rand_matrix(rows, cols, FRAC_POOL)
    B = rand_matrix(rows, cols, FRAC_POOL)
    return {
        "type": "addition_fraction", "op": "add",
        "matrix_a": A, "matrix_b": B, "ans": A + B,
        "q_text": (f"Compute \\(A + B\\) where \\(A = {latex_pmatrix(A)}\\) and "
                   f"\\(B = {latex_pmatrix(B)}\\). Add corresponding entries and "
                   f"reduce each result to lowest terms.")
    }

def gen_multiplication_fraction():
    """At least one matrix has fraction cells — forces rational dot products."""
    sa, sb = rc([((2, 2), (2, 2)), ((2, 3), (3, 2)), ((2, 2), (2, 3))])
    A = rand_matrix(*sa, pool=FRAC_POOL)
    B = rand_matrix(*sb, pool=FRAC_POOL)
    return {
        "type": "multiplication_fraction", "op": "multiply",
        "matrix_a": A, "matrix_b": B, "ans": A * B,
        "q_text": (f"Compute the matrix product \\(AB\\) where \\(A = {latex_pmatrix(A)}\\) "
                   f"and \\(B = {latex_pmatrix(B)}\\). Reduce each entry to lowest terms.")
    }

def gen_inverse_2x2_fraction():
    """Inverse where the input matrix already has fractional entries —
    answer keeps fractions, sometimes simpler than the input."""
    for _ in range(30):
        A = rand_matrix(2, 2, FRAC_POOL)
        if A.det() != 0:
            return {
                "type": "inverse_2x2_fraction", "op": "inverse",
                "matrix_a": A, "ans": A.inv(),
                "q_text": (f"Find \\(A^{{-1}}\\) for \\(A = {latex_pmatrix(A)}\\). "
                           f"Express each entry of the inverse as a fraction in lowest terms.")
            }
    return None

def gen_power_diagonal_fraction():
    """Power of a diagonal matrix with fractional entries — the answer
    is just the diagonal raised to that power, but students must be
    comfortable with (1/2)^n etc."""
    n_dim = rc([2, 3])
    diag = []
    for _ in range(n_dim):
        diag.append(rc([sp.Rational(1, 2), sp.Rational(1, 3), sp.Rational(2, 3),
                        sp.Rational(3, 2), sp.Integer(2), sp.Integer(-1)]))
    A = sp.diag(*diag)
    n = rc([2, 3, 4])
    return {
        "type": "power_diagonal_fraction", "op": "power", "n": n,
        "matrix_a": A, "ans": A ** n,
        "q_text": (f"Compute \\(A^{{{n}}}\\) for the diagonal matrix \\(A = {latex_pmatrix(A)}\\). "
                   f"Express each entry of the result as a fraction in lowest terms.")
    }


# ===========================================================================
# Section 8 — Find-the-unknown (statement-style) questions
# ===========================================================================
#
# These mirror the kinds of problems that show up on linear-algebra exams:
# matrix entries contain a free symbol, and the student has to set up an
# equation (usually det = 0, det = k, eigenvalue condition, eigenvector
# condition, …) and solve.  All answers verified by SymPy.

def gen_find_a_singular_2x2():
    """Pick a 2×2 matrix with one symbolic entry, solve for the value
    that makes it singular (det = 0)."""
    a = sp.symbols('a')
    for _ in range(20):
        # Random concrete entries; one position holds the symbol `a`
        cells = [rc(NZ), rc(NZ), rc(NZ), rc(NZ)]
        pos = random.randint(0, 3)
        cells[pos] = a
        A = sp.Matrix(2, 2, cells)
        det_eq = A.det()
        sols = sp.solve(det_eq, a)
        # Need a unique simple solution (avoid empty sets and 2+ solutions)
        if len(sols) == 1 and sols[0].is_number:
            return {
                "type": "find_a_singular_2x2", "op": "find",
                "matrix_a": A, "ans": sols[0], "var": "a",
                "q_text": (f"Find the value of \\(a\\) for which the matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"is singular (i.e. \\(\\det(A) = 0\\)).")
            }
    return None

def gen_find_a_for_specific_det():
    """Set det(A) equal to a specified value k and solve for `a`."""
    a = sp.symbols('a')
    for _ in range(20):
        cells = [rc(NZ), rc(NZ), rc(NZ), rc(NZ)]
        pos = random.randint(0, 3)
        cells[pos] = a
        A = sp.Matrix(2, 2, cells)
        target = rc([1, -1, 2, -2, 5, -5, 6])
        sols = sp.solve(A.det() - target, a)
        if len(sols) == 1 and sols[0].is_number:
            return {
                "type": "find_a_for_specific_det", "op": "find",
                "matrix_a": A, "ans": sols[0], "var": "a", "target_det": target,
                "q_text": (f"Find the value of \\(a\\) such that \\(\\det(A) = {target}\\), "
                           f"where \\(A = {latex_pmatrix(A)}\\).")
            }
    return None

def gen_find_a_for_eigenvalue():
    """Force a specific λ to be an eigenvalue: det(A − λI) = 0 with `a`
    in one position, then solve."""
    a = sp.symbols('a')
    for _ in range(25):
        cells = [rc(NZ), rc(NZ), rc(NZ), rc(NZ)]
        pos = random.randint(0, 3)
        cells[pos] = a
        A = sp.Matrix(2, 2, cells)
        target_lam = rc([1, 2, 3, -1, -2])
        eq = (A - target_lam * sp.eye(2)).det()
        sols = sp.solve(eq, a)
        if len(sols) == 1 and sols[0].is_number:
            return {
                "type": "find_a_for_eigenvalue", "op": "find",
                "matrix_a": A, "ans": sols[0], "var": "a", "target_lambda": target_lam,
                "q_text": (f"For what value of \\(a\\) does the matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"have \\(\\lambda = {target_lam}\\) as an eigenvalue? "
                           f"(Set \\(\\det(A - \\lambda I) = 0\\) with the given \\(\\lambda\\) and solve.)")
            }
    return None

def gen_find_a_for_eigenvector():
    """Given a fixed vector v, find `a` so that v is an eigenvector of A.
    Condition: A·v parallel to v, equivalently (A·v)[0]·v[1] = (A·v)[1]·v[0]."""
    a = sp.symbols('a')
    for _ in range(25):
        # Pick a non-zero v with nice integer entries
        v = sp.Matrix(2, 1, [rc([1, 2, -1]), rc([1, 2, -1])])
        if v[0] == 0 and v[1] == 0:
            continue
        cells = [rc(NZ), rc(NZ), rc(NZ), rc(NZ)]
        pos = random.randint(0, 3)
        cells[pos] = a
        A = sp.Matrix(2, 2, cells)
        Av = A * v
        # Parallel-condition: Av[0]·v[1] − Av[1]·v[0] = 0
        eq = sp.simplify(Av[0] * v[1] - Av[1] * v[0])
        sols = sp.solve(eq, a)
        if len(sols) == 1 and sols[0].is_number:
            # Compute the corresponding eigenvalue for completeness
            A_concrete = A.subs(a, sols[0])
            Av_concrete = A_concrete * v
            # λ from any nonzero component
            if v[0] != 0:
                lam = sp.simplify(Av_concrete[0] / v[0])
            else:
                lam = sp.simplify(Av_concrete[1] / v[1])
            return {
                "type": "find_a_for_eigenvector", "op": "find",
                "matrix_a": A, "vector_v": v,
                "ans": sols[0], "var": "a", "eigenvalue": lam,
                "q_text": (f"Find the value of \\(a\\) such that \\(v = {latex_pmatrix(v)}\\) "
                           f"is an eigenvector of \\(A = {latex_pmatrix(A)}\\). "
                           f"(Use the condition that \\(Av\\) must be a scalar multiple of \\(v\\).)")
            }
    return None

def gen_for_what_k_invertible():
    """Range-style answer: 'A is invertible for all k except k = X'."""
    k = sp.symbols('k')
    for _ in range(20):
        cells = [rc(NZ), rc(NZ), rc(NZ), rc(NZ)]
        pos = random.randint(0, 3)
        cells[pos] = k
        A = sp.Matrix(2, 2, cells)
        bad_vals = sp.solve(A.det(), k)
        # Want exactly one finite "bad" value for a clean answer
        bad_finite = [v for v in bad_vals if v.is_number]
        if len(bad_finite) == 1:
            return {
                "type": "for_what_k_invertible", "op": "find",
                "matrix_a": A, "ans": bad_finite[0], "var": "k",
                "answer_kind": "all_except",
                "q_text": (f"For what values of \\(k\\) is the matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"invertible? (\\(A\\) is invertible iff \\(\\det(A) \\neq 0\\).)")
            }
    return None

def gen_find_ab_from_tr_det():
    """Two conditions in two unknowns: tr(A) = T and det(A) = D
    on a 2×2 matrix [[a, c1], [c2, b]] (or symmetric variants).
    Yields up to two (a, b) pairs from the resulting quadratic."""
    a, b = sp.symbols('a b')
    for _ in range(25):
        c1, c2 = rc(NZ), rc(NZ)
        # Two patterns: [[a, c1],[c2, b]]  or  [[a, c1],[c1, b]] (symmetric)
        if random.random() < 0.5:
            A = sp.Matrix([[a, c1], [c2, b]])
        else:
            c2 = c1
            A = sp.Matrix([[a, c1], [c1, b]])
        target_tr = rc([3, 4, 5, -1, 0, 1])
        target_det = rc([1, 2, -1, -2, 4, -4, 6])
        sols = sp.solve([A.trace() - target_tr, A.det() - target_det], [a, b])
        # Filter to pairs with finite real-number values
        real_pairs = []
        if isinstance(sols, list):
            for pair in sols:
                if isinstance(pair, dict):
                    av, bv = pair.get(a), pair.get(b)
                else:
                    av, bv = pair
                if av is None or bv is None:
                    continue
                if av.is_number and bv.is_number and av.is_real and bv.is_real:
                    real_pairs.append((av, bv))
        elif isinstance(sols, dict):
            av, bv = sols.get(a), sols.get(b)
            if av is not None and bv is not None and av.is_real and bv.is_real:
                real_pairs.append((av, bv))
        if len(real_pairs) >= 1:
            return {
                "type": "find_ab_from_tr_det", "op": "find",
                "matrix_a": A, "ans": real_pairs,
                "var": "(a, b)",
                "target_tr": target_tr, "target_det": target_det,
                "q_text": (f"Find all pairs \\((a, b)\\) such that the matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"has \\(\\mathrm{{tr}}(A) = {target_tr}\\) and \\(\\det(A) = {target_det}\\).")
            }
    return None


# ===========================================================================
# Section 9 — MIT 18.06 / IIT-JEE / GATE level advanced
# ===========================================================================
#
# These mirror the kinds of questions on the MIT 18.06 problem sets,
# the IIT-JEE Advanced linear-algebra section, and GATE engineering-
# math papers.  They go beyond 2×2 ceilings and use property/
# verification framings ("verify the Cayley-Hamilton theorem", "show
# tr A = sum of eigenvalues") in addition to raw computation.

def gen_determinant_5x5_triangular():
    """5×5 upper-triangular — det = product of diagonal.
    Tests whether the student spots the triangular shortcut instead of
    expanding 5! = 120 cofactors."""
    A = sp.zeros(5, 5).as_mutable()
    diag = []
    for i in range(5):
        d = rc([-3, -2, -1, 1, 2, 3])
        A[i, i] = d
        diag.append(d)
        for j in range(i + 1, 5):
            A[i, j] = rc(SML)
    A = sp.ImmutableMatrix(A)
    det_val = sp.Mul(*[sp.Integer(d) for d in diag])
    return {
        "type": "determinant_5x5_triangular", "op": "determinant",
        "matrix_a": A, "ans": det_val,
        "q_text": (f"Compute \\(\\det(A)\\) for the upper-triangular 5×5 matrix "
                   f"\\(A = {latex_pmatrix(A)}\\). "
                   f"(Hint: for triangular matrices, the determinant is the product of the diagonal entries.)")
    }

def gen_charpoly_4x4():
    """Degree-4 characteristic polynomial — typical IIT-JEE / GATE level.
    Slightly bumped pool — char-poly coefficients stay in a manageable
    range (~|100|) and the matrix looks like an exam problem, not a 0/1 toy."""
    A = rand_matrix(4, 4, [-2, -1, 0, 1, 2])
    lam = sp.symbols('lambda')
    poly = sp.expand(A.charpoly(lam).as_expr())
    return {
        "type": "charpoly_4x4", "op": "charpoly",
        "matrix_a": A, "ans": poly,
        "q_text": (f"Find the characteristic polynomial \\(p(\\lambda) = \\det(A - \\lambda I)\\) "
                   f"for the 4×4 matrix \\(A = {latex_pmatrix(A)}\\). "
                   f"Express the answer expanded in powers of \\(\\lambda\\).")
    }

def gen_determinant_4x4_symbolic():
    """4×4 with one symbolic entry — find det as a polynomial in `a`."""
    a = sp.symbols('a')
    for _ in range(15):
        cells = [[rc([-1, 0, 1]) for _ in range(4)] for _ in range(4)]
        i, j = random.randint(0, 3), random.randint(0, 3)
        cells[i][j] = a
        A = sp.Matrix(cells)
        det_expr = sp.expand(A.det())
        # Want a non-trivial polynomial in `a` (degree ≥ 1)
        if det_expr.has(a):
            return {
                "type": "determinant_4x4_symbolic", "op": "determinant",
                "matrix_a": A, "ans": det_expr,
                "q_text": (f"Find \\(\\det(A)\\) as a polynomial in \\(a\\) for the 4×4 matrix "
                           f"\\(A = {latex_pmatrix(A)}\\).")
            }
    return None

def gen_find_a_for_eigenvalue_3x3():
    """3×3 with one symbolic entry, force a target λ to be an eigenvalue."""
    a = sp.symbols('a')
    for _ in range(40):
        # Sparse / triangular structure for tractability
        cells = [
            [rc(NZ), rc(SML), rc(SML)],
            [0,       rc(NZ), rc(SML)],
            [0,       0,       rc(NZ)]
        ]
        pos = random.randint(0, 2)
        cells[pos][pos] = a   # put the symbol on the diagonal so eigenvalue cleanly depends on it
        A = sp.Matrix(cells)
        target_lam = rc([1, 2, 3, -1, -2])
        # det(A - λI) = 0 with chosen λ
        eq = (A - target_lam * sp.eye(3)).det()
        sols = sp.solve(eq, a)
        if len(sols) == 1 and sols[0].is_number:
            return {
                "type": "find_a_for_eigenvalue_3x3", "op": "find",
                "matrix_a": A, "ans": sols[0], "var": "a",
                "target_lambda": target_lam,
                "q_text": (f"For what value of \\(a\\) does the 3×3 matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"have \\(\\lambda = {target_lam}\\) as an eigenvalue?")
            }
    return None

def gen_find_a_b_singular_3x3():
    """3×3 with two symbolic entries, det = 0 — answer is a relation between
    a and b (not a single value).  Classic JEE 'find the relationship' problem."""
    a, b = sp.symbols('a b')
    for _ in range(25):
        cells = [
            [rc(NZ), rc(NZ), rc(NZ)],
            [rc(NZ), a,       rc(NZ)],
            [rc(NZ), rc(NZ), b]
        ]
        A = sp.Matrix(cells)
        det_expr = sp.expand(A.det())
        # Solve det = 0 for b in terms of a
        sols_b = sp.solve(det_expr, b)
        if not sols_b:
            continue
        sol = sols_b[0]
        if a in sol.free_symbols and len(sol.free_symbols) == 1:
            return {
                "type": "find_a_b_singular_3x3", "op": "find",
                "matrix_a": A, "ans": sol, "var": "b",
                "answer_kind": "relation",
                "q_text": (f"Find the relationship between \\(a\\) and \\(b\\) such that the 3×3 matrix "
                           f"\\(A = {latex_pmatrix(A)}\\) is singular. "
                           f"Express \\(b\\) in terms of \\(a\\).")
            }
    return None

def gen_find_k_for_rank_drop_3x3():
    """3×3 with k symbolic, find k that makes rank(A) < 3 (i.e. det = 0).
    Phrased to surface the rank/determinant connection."""
    k = sp.symbols('k')
    for _ in range(40):
        # Build with a row that becomes linearly dependent for some k
        r1 = [rc(NZ), rc(NZ), rc(NZ)]
        r2 = [rc(NZ), rc(NZ), rc(NZ)]
        # r3 = c1*r1 + c2*r2 + k*[extras] — dependence breaks at specific k
        c1, c2 = rc([-1, 1]), rc([-1, 1])
        extras = [rc(NZ), rc(SML), rc(SML)]
        r3 = [c1 * r1[i] + c2 * r2[i] + k * extras[i] for i in range(3)]
        A = sp.Matrix([r1, r2, r3])
        det_expr = sp.expand(A.det())
        sols = sp.solve(det_expr, k)
        # Want exactly one finite solution
        finite_sols = [s for s in sols if s.is_number]
        if len(finite_sols) == 1:
            return {
                "type": "find_k_for_rank_drop_3x3", "op": "find",
                "matrix_a": A, "ans": finite_sols[0], "var": "k",
                "q_text": (f"For what value of \\(k\\) does the 3×3 matrix \\(A = {latex_pmatrix(A)}\\) "
                           f"have \\(\\mathrm{{rank}}(A) < 3\\)? "
                           f"(Equivalently: for what \\(k\\) is \\(\\det(A) = 0\\)?)")
            }
    return None

def gen_verify_cayley_hamilton_2x2():
    """For a 2×2 A, p(λ) = λ² − (tr A)λ + det A.  Cayley-Hamilton says
    p(A) = A² − (tr A)A + (det A)I = 0.  Show the cancellation."""
    A = rand_matrix(2, 2)
    lam = sp.symbols('lambda')
    p_lam = sp.expand(A.charpoly(lam).as_expr())
    pA = A**2 - A.trace() * A + A.det() * sp.eye(2)  # should be zero
    A_sq = A**2
    ans = (
        "p(\\lambda) = " + sp.latex(p_lam) + " \\\\ "
        "A^2 = " + latex_pmatrix(A_sq) + " \\\\ "
        "p(A) = A^2 - (\\mathrm{tr}\\,A)\\,A + (\\det A)\\,I = "
        + latex_pmatrix(A_sq)
        + " - " + str(A.trace()) + "\\cdot " + latex_pmatrix(A)
        + " + (" + str(A.det()) + ")\\,I = "
        + latex_pmatrix(pA) + " = \\mathbf{0}"
    )
    return {
        "type": "verify_cayley_hamilton_2x2", "op": "verify",
        "matrix_a": A,
        "ans_text": ans, "ans_plain": "Verified: p(A) = 0",
        "q_text": (f"Verify the Cayley-Hamilton theorem for \\(A = {latex_pmatrix(A)}\\): "
                   f"compute the characteristic polynomial \\(p(\\lambda)\\) and show that "
                   f"\\(p(A) = \\mathbf{{0}}\\).")
    }

def gen_verify_cayley_hamilton_3x3():
    """Same idea for a 3×3 — sparse / TINY to keep arithmetic friendly."""
    A = rand_matrix(3, 3, TINY)
    lam = sp.symbols('lambda')
    p_lam = sp.expand(A.charpoly(lam).as_expr())
    # p(A) — substitute A into p(λ)
    coeffs = sp.Poly(p_lam, lam).all_coeffs()  # highest power first
    # p(A) = c0*A^3 + c1*A^2 + c2*A + c3*I
    pA = sp.zeros(3, 3)
    for k, c in enumerate(coeffs):
        power = len(coeffs) - 1 - k
        pA = pA + c * (A**power if power > 0 else sp.eye(3))
    pA = sp.simplify(pA)
    ans = (
        "p(\\lambda) = " + sp.latex(p_lam) + " \\\\ "
        "p(A) = " + latex_pmatrix(pA) + " = \\mathbf{0}"
    )
    return {
        "type": "verify_cayley_hamilton_3x3", "op": "verify",
        "matrix_a": A,
        "ans_text": ans, "ans_plain": "Verified: p(A) = 0",
        "q_text": (f"Verify the Cayley-Hamilton theorem for the 3×3 matrix \\(A = {latex_pmatrix(A)}\\): "
                   f"compute \\(p(\\lambda) = \\det(A - \\lambda I)\\), then show \\(p(A) = \\mathbf{{0}}\\).")
    }

def gen_verify_trace_sum_eigenvalues_3x3():
    """Triangular 3×3 has eigenvalues = diagonal.  Verify Σλ = tr A."""
    A = sp.zeros(3, 3).as_mutable()
    diag = [rc(NZ), rc(NZ), rc(NZ)]
    for i in range(3):
        A[i, i] = diag[i]
        for j in range(i + 1, 3):
            A[i, j] = rc(SML)
    A = sp.ImmutableMatrix(A)
    s = sum(diag)
    tr = A.trace()
    # Use sympy.Add(..., evaluate=False) so negative diagonal entries
    # render as `2 - 1 + 3` instead of `2 + -1 + 3`.
    diag_sum_unsim = sp.Add(*[sp.Integer(d) for d in diag], evaluate=False)
    sum_str = sp.latex(diag_sum_unsim)
    ans = (
        "\\mathrm{tr}\\,A = " + sum_str + " = " + sp.latex(tr) + " \\\\ "
        "\\sum \\lambda_i = " + sum_str + " = " + sp.latex(s) + " \\;\\;\\checkmark"
    )
    return {
        "type": "verify_trace_sum_eigenvalues_3x3", "op": "verify",
        "matrix_a": A,
        "ans_text": ans, "ans_plain": f"tr A = {tr}, sum of eigenvalues = {s}, equal",
        "q_text": (f"For the upper-triangular matrix \\(A = {latex_pmatrix(A)}\\), verify the identity "
                   f"\\(\\mathrm{{tr}}(A) = \\lambda_1 + \\lambda_2 + \\lambda_3\\) where the \\(\\lambda_i\\) "
                   f"are the eigenvalues of \\(A\\). "
                   f"(For triangular matrices the eigenvalues are the diagonal entries.)")
    }

def gen_verify_det_product_eigenvalues_3x3():
    """Triangular 3×3 has eigenvalues = diagonal.  Verify Πλ = det A."""
    A = sp.zeros(3, 3).as_mutable()
    diag = [rc(NZ), rc(NZ), rc(NZ)]
    for i in range(3):
        A[i, i] = diag[i]
        for j in range(i + 1, 3):
            A[i, j] = rc(SML)
    A = sp.ImmutableMatrix(A)
    prod = sp.Integer(1)
    for d in diag:
        prod *= d
    det_val = A.det()
    # Wrap negative diagonal entries in parentheses so the product
    # reads `(-2) \cdot 3 \cdot (-1)` instead of `-2 \cdot 3 \cdot -1`.
    def _wrap(d):
        return f"({sp.latex(d)})" if d < 0 else sp.latex(d)
    prod_str = " \\cdot ".join(_wrap(d) for d in diag)
    ans = (
        "\\det(A) = " + prod_str + " = " + sp.latex(det_val) + " \\\\ "
        "\\prod \\lambda_i = " + prod_str + " = " + sp.latex(prod) + " \\;\\;\\checkmark"
    )
    return {
        "type": "verify_det_product_eigenvalues_3x3", "op": "verify",
        "matrix_a": A,
        "ans_text": ans, "ans_plain": f"det A = {det_val}, product of eigenvalues = {prod}, equal",
        "q_text": (f"For the upper-triangular matrix \\(A = {latex_pmatrix(A)}\\), verify the identity "
                   f"\\(\\det(A) = \\lambda_1 \\lambda_2 \\lambda_3\\) where the \\(\\lambda_i\\) are the "
                   f"eigenvalues of \\(A\\).")
    }

def gen_verify_trace_cyclic_2x2():
    """Show tr(AB) = tr(BA) for two specific 2×2 matrices."""
    A = rand_matrix(2, 2)
    B = rand_matrix(2, 2)
    AB = A * B
    BA = B * A
    tAB = AB.trace()
    tBA = BA.trace()
    ans = (
        "AB = " + latex_pmatrix(AB) + ",\\quad \\mathrm{tr}(AB) = " + sp.latex(tAB) + " \\\\ "
        "BA = " + latex_pmatrix(BA) + ",\\quad \\mathrm{tr}(BA) = " + sp.latex(tBA) +
        " \\\\ \\therefore\\;\\; \\mathrm{tr}(AB) = \\mathrm{tr}(BA) \\;\\;\\checkmark"
    )
    return {
        "type": "verify_trace_cyclic_2x2", "op": "verify",
        "matrix_a": A, "matrix_b": B,
        "ans_text": ans, "ans_plain": f"tr(AB) = tr(BA) = {tAB}",
        "q_text": (f"Verify the cyclic property of trace, \\(\\mathrm{{tr}}(AB) = \\mathrm{{tr}}(BA)\\), "
                   f"for the matrices \\(A = {latex_pmatrix(A)}\\) and \\(B = {latex_pmatrix(B)}\\). "
                   f"Compute both \\(AB\\) and \\(BA\\) and compare their traces.")
    }

def gen_compute_high_power_via_ch_2x2():
    """A^n for n in [5..10] — phrased to nudge students toward
    Cayley-Hamilton (A² = trA·A − detA·I, then iterate)."""
    A = rand_matrix(2, 2)
    n = rc([5, 6, 7, 8, 10])
    An = A ** n
    return {
        "type": "compute_high_power_via_ch_2x2", "op": "power", "n": n,
        "matrix_a": A, "ans": An,
        "q_text": (f"Use the Cayley-Hamilton theorem to compute \\(A^{{{n}}}\\) for "
                   f"\\(A = {latex_pmatrix(A)}\\). "
                   f"(Hint: from \\(p(A) = 0\\) you get \\(A^2 = (\\mathrm{{tr}}\\,A)\\,A - (\\det A)\\,I\\); "
                   f"iterate this relation to bring \\(A^{{{n}}}\\) into the form \\(\\alpha A + \\beta I\\).)")
    }

def gen_classify_quadratic_form_2x2():
    """Classify Q(x, y) = ax² + bxy + cy² as positive/negative definite,
    semi-definite, or indefinite by inspecting the eigenvalues of the
    associated symmetric matrix."""
    for _ in range(40):
        a, b, c = rc([1, 2, -1, -2]), rc([-2, -1, 0, 1, 2]), rc([1, 2, -1, -2])
        Q = sp.Matrix([[a, sp.Rational(b, 2)], [sp.Rational(b, 2), c]])
        eigs = list(Q.eigenvals().keys())
        if not all(e.is_real for e in eigs):
            continue
        if any(e == 0 for e in eigs):
            continue  # skip semi-definite cases for cleaner classification
        positives = [e for e in eigs if e > 0]
        negatives = [e for e in eigs if e < 0]
        if len(positives) == 2:
            cls = "Positive definite"
        elif len(negatives) == 2:
            cls = "Negative definite"
        else:
            cls = "Indefinite"
        ans_text = (
            f"\\text{{Symmetric matrix }} Q = " + latex_pmatrix(Q) + "; \\\\ "
            f"\\text{{eigenvalues: }} " + ",\\;".join(sp.latex(e) for e in eigs) + "; \\\\ "
            f"\\text{{Classification: }} \\mathbf{{{cls}}}."
        )
        # Build human-readable polynomial string for the question
        terms = []
        if a != 0:
            terms.append(("" if a == 1 else ("-" if a == -1 else str(a))) + "x^2")
        if b != 0:
            sign = " + " if b > 0 else " - "
            mag = abs(b)
            terms.append(sign + ("" if mag == 1 else str(mag)) + "xy")
        if c != 0:
            sign = " + " if c > 0 else " - "
            mag = abs(c)
            terms.append(sign + ("" if mag == 1 else str(mag)) + "y^2")
        Q_str = "".join(terms).lstrip("+ ").strip()
        return {
            "type": "classify_quadratic_form_2x2", "op": "classify",
            "matrix_a": Q,
            "ans_text": ans_text, "ans_plain": cls,
            # NOTE: question_text is HTML-escaped by the worksheet engine,
            # so <strong>...</strong> tags render as literal text.  Use
            # plain ALL-CAPS for emphasis instead.
            "q_text": (f"Classify the quadratic form \\(Q(x, y) = {Q_str}\\) as "
                       f"POSITIVE DEFINITE, NEGATIVE DEFINITE, or INDEFINITE "
                       f"by examining the eigenvalues of the symmetric "
                       f"matrix \\(Q = {latex_pmatrix(Q)}\\) associated with it.")
        }
    return None

def gen_eigenvalues_4x4_block_diagonal():
    """4×4 block diagonal of two 2×2 blocks — eigenvalues are the union.
    Tests recognition of block-diagonal structure."""
    for _ in range(20):
        # Each block: real-eigenvalue 2×2 (use the diagonalisable construction)
        def real_eig_block():
            for _ in range(20):
                l1, l2 = rc([1, 2, 3, -1, -2]), rc([1, 2, 3, -1, -2])
                if l1 == l2:
                    continue
                P = rand_invertible(2, [-1, 0, 1])
                D = sp.diag(l1, l2)
                B = P * D * P.inv()
                if all(c.is_integer for c in B):
                    return B, [l1, l2]
            return None, None
        B1, eigs1 = real_eig_block()
        B2, eigs2 = real_eig_block()
        if B1 is None or B2 is None:
            continue
        # 4×4 block-diagonal
        A = sp.Matrix.zeros(4, 4).as_mutable()
        for i in range(2):
            for j in range(2):
                A[i, j] = B1[i, j]
                A[i + 2, j + 2] = B2[i, j]
        A = sp.ImmutableMatrix(A)
        all_eigs = sorted(eigs1 + eigs2)
        return {
            "type": "eigenvalues_4x4_block_diagonal", "op": "eigenvalues",
            "matrix_a": A, "ans": all_eigs,
            "q_text": (f"Find all eigenvalues of the 4×4 block-diagonal matrix "
                       f"\\(A = {latex_pmatrix(A)}\\). "
                       f"(Hint: the eigenvalues of a block-diagonal matrix are the union of the "
                       f"eigenvalues of its diagonal blocks.)")
        }
    return None


# ===========================================================================
# Difficulty → Type mapping
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "addition_2x2", "subtraction_2x2",
        "transpose_rectangular", "transpose_square",
        "trace_2x2", "trace_3x3",
        "determinant_2x2",
        "shape_compatibility",
    ],
    "medium": [
        "addition_3x3", "subtraction_3x3",
        "determinant_3x3",
        "inverse_2x2",
        "multiplication_2x2", "multiplication_rectangular",
        "rank_3x3", "rank_rectangular",
        "power_n2",
        "charpoly_2x2",
        "identity_property",
        # Fraction-input medium tier
        "addition_fraction",
        "determinant_2x2_fraction",
    ],
    "hard": [
        "determinant_4x4",
        "inverse_3x3", "inverse_singular_detect",
        "multiplication_3x3",
        "rref_3x3", "rref_3x4",
        "power_n3", "power_diagonal",
        "eigenvalues_2x2_distinct", "eigenvalues_2x2_general",
        "eigenvalues_3x3_diagonal", "eigenvalues_3x3_triangular",
        "charpoly_3x3",
        # Fraction-input hard tier
        "multiplication_fraction",
        "inverse_2x2_fraction",
        "power_diagonal_fraction",
        # Find-the-unknown hard tier (single condition)
        "find_a_singular_2x2",
        "find_a_for_specific_det",
        "for_what_k_invertible",
        # Section 9 — MIT/IIT-level hard tier
        "determinant_5x5_triangular",
        "verify_trace_sum_eigenvalues_3x3",
        "verify_det_product_eigenvalues_3x3",
        "verify_trace_cyclic_2x2",
        "verify_cayley_hamilton_2x2",
        "find_a_for_eigenvalue_3x3",
        "find_k_for_rank_drop_3x3",
    ],
    "scholar": [
        "inverse_4x4",
        "power_higher",
        "eigenvectors_2x2",
        "determinant_symbolic_2x2",
        "solve_via_inverse",
        # Find-the-unknown scholar tier (eigenvalue / eigenvector / two-condition)
        "find_a_for_eigenvalue",
        "find_a_for_eigenvector",
        "find_ab_from_tr_det",
        # Section 9 — MIT/IIT-level scholar tier
        "charpoly_4x4",
        "determinant_4x4_symbolic",
        "find_a_b_singular_3x3",
        "verify_cayley_hamilton_3x3",
        "compute_high_power_via_ch_2x2",
        "classify_quadratic_form_2x2",
        "eigenvalues_4x4_block_diagonal",
    ],
}

GENERATORS = {
    "addition_2x2":                 gen_addition_2x2,
    "addition_3x3":                 gen_addition_3x3,
    "subtraction_2x2":              gen_subtraction_2x2,
    "subtraction_3x3":              gen_subtraction_3x3,
    "transpose_rectangular":        gen_transpose_rectangular,
    "transpose_square":             gen_transpose_square,
    "trace_2x2":                    gen_trace_2x2,
    "trace_3x3":                    gen_trace_3x3,
    "determinant_2x2":              gen_determinant_2x2,
    "determinant_3x3":              gen_determinant_3x3,
    "determinant_4x4":              gen_determinant_4x4,
    "determinant_symbolic_2x2":     gen_determinant_symbolic_2x2,
    "inverse_2x2":                  gen_inverse_2x2,
    "inverse_3x3":                  gen_inverse_3x3,
    "inverse_4x4":                  gen_inverse_4x4,
    "inverse_singular_detect":      gen_inverse_singular_detect,
    "multiplication_2x2":           gen_multiplication_2x2,
    "multiplication_3x3":           gen_multiplication_3x3,
    "multiplication_rectangular":   gen_multiplication_rectangular,
    "power_n2":                     gen_power_n2,
    "power_n3":                     gen_power_n3,
    "power_higher":                 gen_power_higher,
    "power_diagonal":               gen_power_diagonal,
    "identity_property":            gen_identity_property,
    "rank_3x3":                     gen_rank_3x3,
    "rank_rectangular":             gen_rank_rectangular,
    "rref_3x3":                     gen_rref_3x3,
    "rref_3x4":                     gen_rref_3x4,
    "eigenvalues_2x2_distinct":     gen_eigenvalues_2x2_distinct,
    "eigenvalues_2x2_general":      gen_eigenvalues_2x2_general,
    "eigenvalues_3x3_diagonal":     gen_eigenvalues_3x3_diagonal,
    "eigenvalues_3x3_triangular":   gen_eigenvalues_3x3_triangular,
    "eigenvectors_2x2":             gen_eigenvectors_2x2,
    "charpoly_2x2":                 gen_charpoly_2x2,
    "charpoly_3x3":                 gen_charpoly_3x3,
    "solve_via_inverse":            gen_solve_via_inverse,
    "shape_compatibility":          gen_shape_compatibility,
    # Section 7 — fraction inputs
    "determinant_2x2_fraction":     gen_determinant_2x2_fraction,
    "addition_fraction":            gen_addition_fraction,
    "multiplication_fraction":      gen_multiplication_fraction,
    "inverse_2x2_fraction":         gen_inverse_2x2_fraction,
    "power_diagonal_fraction":      gen_power_diagonal_fraction,
    # Section 8 — find-the-unknown
    "find_a_singular_2x2":          gen_find_a_singular_2x2,
    "find_a_for_specific_det":      gen_find_a_for_specific_det,
    "find_a_for_eigenvalue":        gen_find_a_for_eigenvalue,
    "find_a_for_eigenvector":       gen_find_a_for_eigenvector,
    "for_what_k_invertible":        gen_for_what_k_invertible,
    "find_ab_from_tr_det":          gen_find_ab_from_tr_det,
    # Section 9 — MIT/IIT advanced
    "determinant_5x5_triangular":          gen_determinant_5x5_triangular,
    "charpoly_4x4":                        gen_charpoly_4x4,
    "determinant_4x4_symbolic":            gen_determinant_4x4_symbolic,
    "find_a_for_eigenvalue_3x3":           gen_find_a_for_eigenvalue_3x3,
    "find_a_b_singular_3x3":               gen_find_a_b_singular_3x3,
    "find_k_for_rank_drop_3x3":            gen_find_k_for_rank_drop_3x3,
    "verify_cayley_hamilton_2x2":          gen_verify_cayley_hamilton_2x2,
    "verify_cayley_hamilton_3x3":          gen_verify_cayley_hamilton_3x3,
    "verify_trace_sum_eigenvalues_3x3":    gen_verify_trace_sum_eigenvalues_3x3,
    "verify_det_product_eigenvalues_3x3":  gen_verify_det_product_eigenvalues_3x3,
    "verify_trace_cyclic_2x2":             gen_verify_trace_cyclic_2x2,
    "compute_high_power_via_ch_2x2":       gen_compute_high_power_via_ch_2x2,
    "classify_quadratic_form_2x2":         gen_classify_quadratic_form_2x2,
    "eigenvalues_4x4_block_diagonal":      gen_eigenvalues_4x4_block_diagonal,
}


# ===========================================================================
# Answer formatter — convert SymPy → (latex, plain)
# ===========================================================================

def format_answer(rec):
    """Build (answer_latex, answer_plain) from the generator's output dict.
    Handles multiple answer shapes: SymPy Matrix, scalar, list of eigenvalues,
    polynomial, eigenvector list-of-tuples, find-the-unknown solutions
    (single value, list of (a,b) pairs, or "all reals except X"),
    or pre-baked text (singular)."""
    ans = rec.get("ans")
    op = rec.get("op")

    # Pre-baked conceptual answers (shape_compatibility)
    if "ans_text" in rec:
        return rec["ans_text"], rec["ans_plain"]

    # Singular detection
    if isinstance(ans, str) and ans == "singular":
        return ("\\text{Singular: } \\det(A) = 0,\\; A^{-1} \\text{ does not exist}",
                "Singular (no inverse)")

    # Eigenvalues — list of values
    if op == "eigenvalues":
        latex_parts = [sp.latex(v) for v in ans]
        return (",\\; ".join(latex_parts), ", ".join(str(v) for v in ans))

    # Eigenvectors — list of (eigenvalue, mult, [vects])
    if op == "eigenvectors":
        parts = []
        plain_parts = []
        for v, mult, vects in ans:
            for vec in vects:
                parts.append(f"\\lambda = {sp.latex(v)}: \\; v = {latex_pmatrix(vec)}")
                plain_parts.append(f"lambda={v}: v={vec.tolist()}")
        return (" \\\\ ".join(parts), "; ".join(plain_parts))

    # Find-the-unknown — four sub-shapes:
    #   1. answer_kind="all_except"  → "k ∈ ℝ \ {bad}"
    #   2. answer_kind="relation"    → "b = expr-in-a" (multi-symbol relationship)
    #   3. ans is a list of (a,b) pairs (find_ab_from_tr_det)
    #   4. ans is a single sympy value (most "find a" cases)
    if op == "find":
        var = rec.get("var", "a")
        if rec.get("answer_kind") == "all_except":
            bad = sp.latex(ans)
            return (f"{var} \\in \\mathbb{{R}} \\setminus \\{{ {bad} \\}} "
                    f"\\quad \\text{{(all real numbers except }} {var} = {bad}\\text{{)}}",
                    f"All real {var} except {var} = {ans}")
        if rec.get("answer_kind") == "relation":
            # ans is a sympy expression containing other free symbols
            return (f"{var} = {sp.latex(ans)}", f"{var} = {ans}")
        if isinstance(ans, list) and ans and isinstance(ans[0], tuple):
            # list of (a, b) pairs
            pair_strs = [f"({sp.latex(av)},\\; {sp.latex(bv)})" for av, bv in ans]
            plain = "; ".join(f"({av}, {bv})" for av, bv in ans)
            sep = ",\\; "
            joined = sep.join(pair_strs)
            return (f"(a, b) \\in \\{{ {joined} \\}}", plain)
        # Single value — include the eigenvalue when present (find_a_for_eigenvector)
        ans_l = sp.latex(ans)
        extras = []
        if "eigenvalue" in rec:
            extras.append(f"\\text{{(corresponding eigenvalue }} \\lambda = {sp.latex(rec['eigenvalue'])}\\text{{)}}")
        if extras:
            return (f"{var} = {ans_l} \\quad " + " ".join(extras),
                    f"{var} = {ans}; lambda = {rec.get('eigenvalue')}")
        return f"{var} = {ans_l}", f"{var} = {ans}"

    # SymPy Matrix
    if isinstance(ans, sp.MatrixBase):
        return latex_pmatrix(ans), str(ans.tolist())

    # Scalar / polynomial / Add
    return sp.latex(ans), str(ans)


# ===========================================================================
# Main generation loop
# ===========================================================================

def generate_matrix_questions(num_questions):
    questions = []
    seen_signatures = set()
    attempts = 0
    max_attempts = num_questions * 50

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1

        # Difficulty distribution: 25% basic / 30% medium / 30% hard / 15% scholar
        rand_val = random.random()
        if   rand_val < 0.25: difficulty = "basic"
        elif rand_val < 0.55: difficulty = "medium"
        elif rand_val < 0.85: difficulty = "hard"
        else:                 difficulty = "scholar"

        q_type = rc(DIFFICULTY_TYPES[difficulty])
        gen_fn = GENERATORS.get(q_type)
        if gen_fn is None:
            continue

        try:
            rec = gen_fn()
            if rec is None:
                continue

            # Deduplication signature — use srepr where possible for stable hashing
            try:
                ma = rec.get("matrix_a")
                mb = rec.get("matrix_b")
                sig = (
                    rec["type"],
                    sp.srepr(ma) if ma is not None and isinstance(ma, sp.MatrixBase) else str(rec.get("matrix_a_shape", "")),
                    sp.srepr(mb) if mb is not None and isinstance(mb, sp.MatrixBase) else "",
                    rec.get("n", "")
                )
            except Exception:
                sig = (rec["type"], str(rec.get("matrix_a")), str(rec.get("matrix_b")))
            if sig in seen_signatures:
                continue

            ans_latex, ans_plain = format_answer(rec)
            if not ans_latex:
                continue

            entry = {
                "id": len(questions) + 1,
                "type": rec["type"],
                "difficulty": difficulty,
                "op": rec.get("op"),
                "question_text": rec["q_text"],
                "answer_latex": ans_latex,
                "answer_plain": ans_plain,
            }

            # Stash matrix LaTeX so the front-end can render the problem
            # without re-running SymPy.
            ma = rec.get("matrix_a")
            if isinstance(ma, sp.MatrixBase):
                entry["matrix_a_latex"] = latex_pmatrix(ma)
                entry["matrix_a_shape"] = list(ma.shape)
            mb = rec.get("matrix_b")
            if isinstance(mb, sp.MatrixBase):
                entry["matrix_b_latex"] = latex_pmatrix(mb)
                entry["matrix_b_shape"] = list(mb.shape)
            if rec.get("n") is not None:
                entry["n"] = rec["n"]

            questions.append(entry)
            seen_signatures.add(sig)

            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} matrix questions...")

        except Exception as e:
            # Silent — generators are best-effort, the main loop just retries
            pass

    return questions


if __name__ == "__main__":
    num = int(sys.argv[1]) if len(sys.argv) > 1 else 1500
    print(f"Generating {num} Matrix questions...")
    questions = generate_matrix_questions(num)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/linear-algebra"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/matrices.json"
    with open(output_file, "w") as f_out:
        json.dump({
            "topic": "Matrices",
            "description": (
                "Comprehensive Practice Worksheet for Matrices and Linear Algebra. "
                "Covers: addition, subtraction, transpose, trace, determinant (2x2 / 3x3 / 4x4 / symbolic), "
                "inverse (adjugate method, Gauss-Jordan, singular detection), matrix multiplication "
                "(square, rectangular, identity property), matrix power A^n (small and higher, diagonal), "
                "rank and reduced row echelon form, characteristic polynomial, eigenvalues "
                "(real distinct, repeated, diagonal, triangular), eigenvectors, and applications "
                "(solving Ax=b via inverse, shape compatibility checks)."
            ),
            "questions": questions
        }, f_out, separators=(',', ':'))

    # Stats
    from collections import Counter
    type_counts = Counter(q["type"] for q in questions)
    diff_counts = Counter(q["difficulty"] for q in questions)
    op_counts = Counter(q["op"] for q in questions)

    print(f"\nDone — {len(questions)} problems → {output_file}\n")
    print(f"By type ({len(type_counts)} types):")
    for t, c in type_counts.most_common():
        print(f"  {t}: {c}")
    print(f"\nBy difficulty:")
    for d, c in diff_counts.most_common():
        print(f"  {d}: {c}")
    print(f"\nBy op:")
    for o, c in op_counts.most_common():
        print(f"  {o}: {c}")
