"""
Vector Calculus Question Bank Generator — 18 types (Dawkins Ch 11–12)
Answers verified by SymPy.

Basic (6 types):
    vector_from_points, position_vector, vector_arithmetic,
    unit_vector, parallel_vectors, vector_endpoint

Medium (6 types):
    dot_product, angle_between_vectors, orthogonal_parallel_neither,
    vector_projection, direction_cosines, cross_product

Hard (6 types):
    vector_function_domain, vector_function_graph, line_segment_equation,
    vector_function_limit, vector_function_derivative, vector_function_integral
"""

import sympy as sp
import json
import random
import os

x, y, z, t = sp.symbols('x y z t')

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def rc(pool):
    return random.choice(pool)

NZ  = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5]
SML = [-3, -2, -1, 1, 2, 3]
POS = [1, 2, 3, 4, 5]

def fmt_ans(expr):
    lat = sp.latex(expr)
    return lat, str(expr)

def vec_latex(components, name=None):
    """Return \\langle c1, c2, ... \\rangle LaTeX."""
    inner = ", ".join(sp.latex(c) for c in components)
    if name:
        return f"\\mathbf{{{name}}} = \\langle {inner} \\rangle"
    return f"\\langle {inner} \\rangle"

def vec_plain(components):
    return "<" + ", ".join(str(c) for c in components) + ">"

def magnitude(components):
    return sp.sqrt(sum(c**2 for c in components))

def rand_vec(dim=3, pool=None):
    """Random integer vector of given dimension."""
    pool = pool or NZ
    return [rc(pool) for _ in range(dim)]

def rand_nonzero_vec(dim=3, pool=None):
    """Random vector that isn't the zero vector."""
    pool = pool or NZ
    for _ in range(50):
        v = [rc(pool) for _ in range(dim)]
        if any(c != 0 for c in v):
            return v
    return [1] + [0]*(dim-1)


# ===========================================================================
# BASIC GENERATORS (6 types)
# ===========================================================================

def gen_vector_from_points():
    """Vector from A to B (2D/3D), magnitude, unit vector check."""
    dim = rc([2, 3])
    A = rand_vec(dim, SML)
    B = rand_vec(dim, SML)
    AB = [B[i] - A[i] for i in range(dim)]
    if all(c == 0 for c in AB):
        return None
    mag = magnitude(AB)
    mag_simplified = sp.simplify(mag)

    A_str = "(" + ", ".join(str(c) for c in A) + ")"
    B_str = "(" + ", ".join(str(c) for c in B) + ")"
    q_text = (f"Find the vector from \\( A{A_str} \\) to \\( B{B_str} \\) "
              f"and compute its magnitude.")
    ans_latex = f"\\vec{{AB}} = {vec_latex(AB)}, \\; \\|\\vec{{AB}}\\| = {sp.latex(mag_simplified)}"
    ans_plain = f"AB = {vec_plain(AB)}, |AB| = {mag_simplified}"
    sig = ("vector_from_points", tuple(A), tuple(B))
    return {"q_text": q_text, "type": "vector_from_points",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_position_vector():
    """Position vector for a point, compute magnitude."""
    dim = rc([2, 3])
    P = rand_nonzero_vec(dim, SML)
    mag = magnitude(P)
    mag_simplified = sp.simplify(mag)

    P_str = "(" + ", ".join(str(c) for c in P) + ")"
    q_text = (f"Write the position vector for the point \\( P{P_str} \\) "
              f"and find its magnitude.")
    ans_latex = f"\\vec{{OP}} = {vec_latex(P)}, \\; \\|\\vec{{OP}}\\| = {sp.latex(mag_simplified)}"
    ans_plain = f"OP = {vec_plain(P)}, |OP| = {mag_simplified}"
    sig = ("position_vector", tuple(P))
    return {"q_text": q_text, "type": "position_vector",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_arithmetic():
    """Scalar mult, addition/subtraction (e.g. 6a, 7b−2a, ‖c₁a+c₂b‖)."""
    dim = rc([2, 3])
    a_vec = rand_nonzero_vec(dim, SML)
    b_vec = rand_nonzero_vec(dim, SML)
    c1, c2 = rc(NZ), rc(NZ)

    result = [c1*a_vec[i] + c2*b_vec[i] for i in range(dim)]
    mag = magnitude(result)
    mag_simplified = sp.simplify(mag)

    a_lat = vec_latex(a_vec)
    b_lat = vec_latex(b_vec)
    op_str = f"{c1}\\mathbf{{a}} + {c2}\\mathbf{{b}}" if c2 >= 0 else f"{c1}\\mathbf{{a}} - {abs(c2)}\\mathbf{{b}}"
    q_text = (f"Given \\( \\mathbf{{a}} = {a_lat} \\) and \\( \\mathbf{{b}} = {b_lat} \\), "
              f"compute \\( {op_str} \\) and find its magnitude.")
    ans_latex = (f"{vec_latex(result)}, \\; "
                 f"\\|{op_str}\\| = {sp.latex(mag_simplified)}")
    ans_plain = f"{vec_plain(result)}, magnitude = {mag_simplified}"
    sig = ("vector_arithmetic", tuple(a_vec), tuple(b_vec), c1, c2)
    return {"q_text": q_text, "type": "vector_arithmetic",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_unit_vector():
    """Find unit vector in direction of given vector."""
    dim = rc([2, 3])
    v = rand_nonzero_vec(dim, SML)
    mag = magnitude(v)
    mag_simplified = sp.simplify(mag)
    unit = [sp.Rational(c, 1) / mag for c in v]
    unit_simplified = [sp.simplify(u) for u in unit]

    v_lat = vec_latex(v)
    q_text = f"Find the unit vector in the direction of \\( \\mathbf{{v}} = {v_lat} \\)."
    ans_latex = f"\\hat{{v}} = {vec_latex(unit_simplified)}"
    ans_plain = f"v_hat = {vec_plain(unit_simplified)}"
    sig = ("unit_vector", tuple(v))
    return {"q_text": q_text, "type": "unit_vector",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_parallel_vectors():
    """Determine if two vectors are parallel."""
    dim = rc([2, 3])
    a_vec = rand_nonzero_vec(dim, SML)
    is_parallel = random.random() < 0.5
    if is_parallel:
        k = rc([-3, -2, 2, 3])
        b_vec = [k * c for c in a_vec]
    else:
        b_vec = rand_nonzero_vec(dim, SML)
        # Make sure they are truly not parallel
        # Check if b = k*a for some k
        ratios = []
        for i in range(dim):
            if a_vec[i] != 0:
                ratios.append(sp.Rational(b_vec[i], a_vec[i]))
            elif b_vec[i] == 0:
                ratios.append(None)
            else:
                ratios.append("not_parallel")
        non_none = [r for r in ratios if r is not None]
        if len(non_none) > 0 and all(r == non_none[0] for r in non_none) and non_none[0] != "not_parallel":
            # Actually parallel by accident, flip a component
            b_vec[0] += 1

    a_lat = vec_latex(a_vec)
    b_lat = vec_latex(b_vec)
    q_text = (f"Determine whether \\( \\mathbf{{a}} = {a_lat} \\) and "
              f"\\( \\mathbf{{b}} = {b_lat} \\) are parallel.")

    # Verify with cross product (3D) or ratio check (2D)
    if dim == 3:
        cross = [
            a_vec[1]*b_vec[2] - a_vec[2]*b_vec[1],
            a_vec[2]*b_vec[0] - a_vec[0]*b_vec[2],
            a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0],
        ]
        actually_parallel = all(c == 0 for c in cross)
    else:
        actually_parallel = (a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0] == 0)

    if actually_parallel:
        ans_latex = "\\text{Yes, the vectors are parallel.}"
        ans_plain = "Yes, parallel"
    else:
        ans_latex = "\\text{No, the vectors are not parallel.}"
        ans_plain = "No, not parallel"

    sig = ("parallel_vectors", tuple(a_vec), tuple(b_vec))
    return {"q_text": q_text, "type": "parallel_vectors",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_endpoint():
    """Given start point + vector, find endpoint."""
    dim = rc([2, 3])
    start = rand_vec(dim, SML)
    v = rand_nonzero_vec(dim, SML)
    end = [start[i] + v[i] for i in range(dim)]

    start_str = "(" + ", ".join(str(c) for c in start) + ")"
    v_lat = vec_latex(v)
    end_str = "(" + ", ".join(str(c) for c in end) + ")"
    q_text = (f"A vector \\( \\mathbf{{v}} = {v_lat} \\) starts at the point "
              f"\\( P{start_str} \\). Find the terminal point.")
    ans_latex = f"Q = {end_str}"
    ans_plain = f"Q = {end_str}"
    sig = ("vector_endpoint", tuple(start), tuple(v))
    return {"q_text": q_text, "type": "vector_endpoint",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


# ===========================================================================
# MEDIUM GENERATORS (6 types)
# ===========================================================================

def gen_dot_product():
    """Compute a·b from components or from ‖a‖,‖b‖,θ."""
    variant = rc(["components", "components", "mag_angle"])
    if variant == "components":
        dim = rc([2, 3])
        a_vec = rand_nonzero_vec(dim, SML)
        b_vec = rand_nonzero_vec(dim, SML)
        dot = sum(a_vec[i]*b_vec[i] for i in range(dim))

        a_lat = vec_latex(a_vec)
        b_lat = vec_latex(b_vec)
        q_text = (f"Compute the dot product \\( \\mathbf{{a}} \\cdot \\mathbf{{b}} \\) where "
                  f"\\( \\mathbf{{a}} = {a_lat} \\) and \\( \\mathbf{{b}} = {b_lat} \\).")
        ans_latex = f"\\mathbf{{a}} \\cdot \\mathbf{{b}} = {sp.latex(sp.Integer(dot))}"
        ans_plain = f"a·b = {dot}"
        sig = ("dot_product_comp", tuple(a_vec), tuple(b_vec))
    else:
        mag_a = rc([2, 3, 4, 5])
        mag_b = rc([2, 3, 4, 5])
        angle_choices = [
            (sp.pi/6, "\\frac{\\pi}{6}"),
            (sp.pi/4, "\\frac{\\pi}{4}"),
            (sp.pi/3, "\\frac{\\pi}{3}"),
            (sp.pi/2, "\\frac{\\pi}{2}"),
            (2*sp.pi/3, "\\frac{2\\pi}{3}"),
        ]
        theta, theta_lat = rc(angle_choices)
        dot = sp.simplify(mag_a * mag_b * sp.cos(theta))

        q_text = (f"If \\( \\|\\mathbf{{a}}\\| = {mag_a} \\), \\( \\|\\mathbf{{b}}\\| = {mag_b} \\), "
                  f"and the angle between them is \\( \\theta = {theta_lat} \\), "
                  f"find \\( \\mathbf{{a}} \\cdot \\mathbf{{b}} \\).")
        ans_latex = f"\\mathbf{{a}} \\cdot \\mathbf{{b}} = {sp.latex(dot)}"
        ans_plain = f"a·b = {dot}"
        sig = ("dot_product_angle", mag_a, mag_b, str(theta))

    return {"q_text": q_text, "type": "dot_product",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_angle_between_vectors():
    """θ = arccos(a·b / (‖a‖‖b‖))."""
    dim = rc([2, 3])
    a_vec = rand_nonzero_vec(dim, SML)
    b_vec = rand_nonzero_vec(dim, SML)
    dot = sum(a_vec[i]*b_vec[i] for i in range(dim))
    mag_a = magnitude(a_vec)
    mag_b = magnitude(b_vec)
    try:
        cos_theta = sp.Rational(dot, 1) / (mag_a * mag_b)
        cos_simplified = sp.simplify(cos_theta)
        theta = sp.acos(cos_simplified)
        theta_simplified = sp.simplify(theta)
    except Exception:
        return None

    a_lat = vec_latex(a_vec)
    b_lat = vec_latex(b_vec)
    q_text = (f"Find the angle between \\( \\mathbf{{a}} = {a_lat} \\) and "
              f"\\( \\mathbf{{b}} = {b_lat} \\).")
    ans_latex = f"\\theta = {sp.latex(theta_simplified)}"
    ans_plain = f"theta = {theta_simplified}"
    sig = ("angle_between", tuple(a_vec), tuple(b_vec))
    return {"q_text": q_text, "type": "angle_between_vectors",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_orthogonal_parallel_neither():
    """Classify vector pair as orthogonal, parallel, or neither."""
    dim = rc([2, 3])
    choice = rc(["orthogonal", "parallel", "neither"])

    a_vec = rand_nonzero_vec(dim, SML)

    if choice == "parallel":
        k = rc([-3, -2, 2, 3])
        b_vec = [k * c for c in a_vec]
    elif choice == "orthogonal":
        if dim == 2:
            # Perpendicular in 2D: (a, b) -> (-b, a)
            b_vec = [-a_vec[1], a_vec[0]]
            k = rc([-2, -1, 1, 2])
            b_vec = [k*c for c in b_vec]
        else:
            # 3D: find orthogonal via cross with a random vector
            c_vec = rand_nonzero_vec(3, SML)
            b_vec = [
                a_vec[1]*c_vec[2] - a_vec[2]*c_vec[1],
                a_vec[2]*c_vec[0] - a_vec[0]*c_vec[2],
                a_vec[0]*c_vec[1] - a_vec[1]*c_vec[0],
            ]
            if all(c == 0 for c in b_vec):
                return None
    else:
        b_vec = rand_nonzero_vec(dim, SML)
        dot = sum(a_vec[i]*b_vec[i] for i in range(dim))
        if dot == 0:
            b_vec[0] += 1
        # Check not parallel
        if dim == 3:
            cross = [
                a_vec[1]*b_vec[2] - a_vec[2]*b_vec[1],
                a_vec[2]*b_vec[0] - a_vec[0]*b_vec[2],
                a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0],
            ]
            if all(c == 0 for c in cross):
                b_vec[0] += 1

    # Verify classification
    dot = sum(a_vec[i]*b_vec[i] for i in range(dim))
    if dim == 3:
        cross = [
            a_vec[1]*b_vec[2] - a_vec[2]*b_vec[1],
            a_vec[2]*b_vec[0] - a_vec[0]*b_vec[2],
            a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0],
        ]
        is_parallel = all(c == 0 for c in cross)
    else:
        is_parallel = (a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0] == 0)
    is_orthogonal = (dot == 0)

    if is_orthogonal:
        classification = "orthogonal"
    elif is_parallel:
        classification = "parallel"
    else:
        classification = "neither"

    a_lat = vec_latex(a_vec)
    b_lat = vec_latex(b_vec)
    q_text = (f"Determine whether \\( \\mathbf{{a}} = {a_lat} \\) and "
              f"\\( \\mathbf{{b}} = {b_lat} \\) are orthogonal, parallel, or neither.")
    ans_latex = f"\\text{{{classification.capitalize()}}}"
    ans_plain = classification.capitalize()
    sig = ("opn", tuple(a_vec), tuple(b_vec))
    return {"q_text": q_text, "type": "orthogonal_parallel_neither",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_projection():
    """proj_b(a) = (a·b / b·b)·b."""
    dim = rc([2, 3])
    a_vec = rand_nonzero_vec(dim, SML)
    b_vec = rand_nonzero_vec(dim, SML)
    dot_ab = sum(a_vec[i]*b_vec[i] for i in range(dim))
    dot_bb = sum(b_vec[i]**2 for i in range(dim))
    if dot_bb == 0:
        return None
    scalar = sp.Rational(dot_ab, dot_bb)
    proj = [sp.simplify(scalar * b_vec[i]) for i in range(dim)]

    a_lat = vec_latex(a_vec)
    b_lat = vec_latex(b_vec)
    q_text = (f"Find the vector projection of \\( \\mathbf{{a}} = {a_lat} \\) "
              f"onto \\( \\mathbf{{b}} = {b_lat} \\).")
    ans_latex = f"\\text{{proj}}_{{\\mathbf{{b}}}}\\mathbf{{a}} = {vec_latex(proj)}"
    ans_plain = f"proj_b(a) = {vec_plain(proj)}"
    sig = ("projection", tuple(a_vec), tuple(b_vec))
    return {"q_text": q_text, "type": "vector_projection",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_direction_cosines():
    """cos α, cos β, cos γ and the angles."""
    v = rand_nonzero_vec(3, SML)
    mag = magnitude(v)
    cos_a = sp.simplify(sp.Rational(v[0], 1) / mag)
    cos_b = sp.simplify(sp.Rational(v[1], 1) / mag)
    cos_g = sp.simplify(sp.Rational(v[2], 1) / mag)

    v_lat = vec_latex(v)
    q_text = (f"Find the direction cosines of "
              f"\\( \\mathbf{{v}} = {v_lat} \\).")
    ans_latex = (f"\\cos\\alpha = {sp.latex(cos_a)}, \\; "
                 f"\\cos\\beta = {sp.latex(cos_b)}, \\; "
                 f"\\cos\\gamma = {sp.latex(cos_g)}")
    ans_plain = f"cos(α) = {cos_a}, cos(β) = {cos_b}, cos(γ) = {cos_g}"
    sig = ("direction_cosines", tuple(v))
    return {"q_text": q_text, "type": "direction_cosines",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_cross_product():
    """v×w, normal to plane through 3 points, coplanarity."""
    variant = rc(["basic", "basic", "normal_plane"])
    if variant == "basic":
        a_vec = rand_nonzero_vec(3, SML)
        b_vec = rand_nonzero_vec(3, SML)
        cross = [
            a_vec[1]*b_vec[2] - a_vec[2]*b_vec[1],
            a_vec[2]*b_vec[0] - a_vec[0]*b_vec[2],
            a_vec[0]*b_vec[1] - a_vec[1]*b_vec[0],
        ]
        if all(c == 0 for c in cross):
            return None
        a_lat = vec_latex(a_vec)
        b_lat = vec_latex(b_vec)
        q_text = (f"Compute \\( \\mathbf{{a}} \\times \\mathbf{{b}} \\) where "
                  f"\\( \\mathbf{{a}} = {a_lat} \\) and \\( \\mathbf{{b}} = {b_lat} \\).")
        ans_latex = f"\\mathbf{{a}} \\times \\mathbf{{b}} = {vec_latex(cross)}"
        ans_plain = f"a × b = {vec_plain(cross)}"
        sig = ("cross_basic", tuple(a_vec), tuple(b_vec))
    else:
        # Normal to plane through 3 points
        P = rand_vec(3, SML)
        Q = rand_vec(3, SML)
        R = rand_vec(3, SML)
        PQ = [Q[i] - P[i] for i in range(3)]
        PR = [R[i] - P[i] for i in range(3)]
        normal = [
            PQ[1]*PR[2] - PQ[2]*PR[1],
            PQ[2]*PR[0] - PQ[0]*PR[2],
            PQ[0]*PR[1] - PQ[1]*PR[0],
        ]
        if all(c == 0 for c in normal):
            return None
        P_s = "(" + ", ".join(str(c) for c in P) + ")"
        Q_s = "(" + ", ".join(str(c) for c in Q) + ")"
        R_s = "(" + ", ".join(str(c) for c in R) + ")"
        q_text = (f"Find a normal vector to the plane through the points "
                  f"\\( P{P_s} \\), \\( Q{Q_s} \\), \\( R{R_s} \\).")
        ans_latex = f"\\mathbf{{n}} = {vec_latex(normal)}"
        ans_plain = f"n = {vec_plain(normal)}"
        sig = ("cross_normal", tuple(P), tuple(Q), tuple(R))

    return {"q_text": q_text, "type": "cross_product",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


# ===========================================================================
# HARD GENERATORS (6 types)
# ===========================================================================

def gen_vector_function_domain():
    """Domain of r(t) with ln, sqrt, 1/(t+c) components."""
    variant = rc(["sqrt_ln", "sqrt_frac", "ln_frac", "all_three"])

    if variant == "sqrt_ln":
        a = rc(POS)
        comp1 = sp.sqrt(a*t + rc(POS))
        comp2 = sp.log(rc(POS)*t + rc(POS))
        comp3 = t**2
        comps = [comp1, comp2, comp3]
    elif variant == "sqrt_frac":
        a = rc(POS)
        c = rc(NZ)
        comp1 = sp.sqrt(a - t)
        comp2 = 1 / (t + c)
        comp3 = t * rc(SML)
        comps = [comp1, comp2, comp3]
    elif variant == "ln_frac":
        c1, c2 = rc(POS), rc(NZ)
        comp1 = sp.log(t + c1)
        comp2 = 1 / (t + c2)
        comp3 = sp.exp(t)
        comps = [comp1, comp2, comp3]
    else:
        a = rc(POS)
        c = rc(NZ)
        comp1 = sp.sqrt(a*t + rc(POS))
        comp2 = sp.log(t + rc(POS))
        comp3 = 1 / (t + c)
        comps = [comp1, comp2, comp3]

    # Find domain using SymPy
    try:
        domains = []
        for comp in comps:
            dom = sp.calculus.util.continuous_domain(comp, t, sp.S.Reals)
            domains.append(dom)
        total_domain = domains[0]
        for d in domains[1:]:
            total_domain = total_domain.intersect(d)
        dom_latex = sp.latex(total_domain)
        dom_plain = str(total_domain)
    except Exception:
        return None

    if total_domain == sp.S.EmptySet:
        return None

    r_lat = vec_latex(comps)
    q_text = (f"Find the domain of the vector function "
              f"\\( \\mathbf{{r}}(t) = {r_lat} \\).")
    ans_latex = f"\\text{{Domain}} = {dom_latex}"
    ans_plain = f"Domain = {dom_plain}"
    sig = ("vf_domain", str(comps))
    return {"q_text": q_text, "type": "vector_function_domain",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_function_graph():
    """Identify parametric curve type (line, ellipse, parabola, helix)."""
    curve_type = rc(["line", "ellipse", "parabola", "helix"])

    if curve_type == "line":
        # r(t) = P + t*d
        P = rand_vec(3, SML)
        d = rand_nonzero_vec(3, SML)
        comps = [P[i] + d[i]*t for i in range(3)]
        description = "a line"
        P_lat = "(" + ", ".join(str(c) for c in P) + ")"
        d_lat = vec_latex(d)
        detail_latex = f"\\text{{passing through }} {P_lat} \\text{{ with direction }} {d_lat}"
        detail_plain = f"passing through {P_lat} with direction {vec_plain(d)}"
    elif curve_type == "ellipse":
        a, b = rc(POS), rc(POS)
        comps = [a*sp.cos(t), b*sp.sin(t), sp.Integer(0)]
        description = "an ellipse" if a != b else "a circle"
        detail_latex = f"\\text{{in the }} xy\\text{{-plane with semi-axes }} a={a},\\; b={b}"
        detail_plain = f"in the xy-plane with semi-axes a={a}, b={b}"
    elif curve_type == "parabola":
        a = rc(SML)
        comps = [t, a*t**2, sp.Integer(0)]
        description = "a parabola"
        detail_latex = f"y = {a}x^2 \\text{{ in the }} xy\\text{{-plane}}"
        detail_plain = f"y = {a}x^2 in the xy-plane"
    else:  # helix
        a, b = rc(POS), rc(POS)
        c = rc(SML)
        comps = [a*sp.cos(t), a*sp.sin(t), c*t]
        description = "a helix"
        detail_latex = f"\\text{{with radius }} {a} \\text{{ and pitch }} {abs(c)}"
        detail_plain = f"with radius {a} and pitch {abs(c)}"

    comp_latex = [sp.latex(c) for c in comps]
    r_lat = f"\\langle {', '.join(comp_latex)} \\rangle"
    q_text = (f"Identify the type of curve traced by "
              f"\\( \\mathbf{{r}}(t) = {r_lat} \\).")
    ans_latex = f"\\text{{The curve is {description}}}, \\; {detail_latex}"
    ans_plain = f"The curve is {description}, {detail_plain}"
    sig = ("vf_graph", curve_type, str(comps))
    return {"q_text": q_text, "type": "vector_function_graph",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_line_segment_equation():
    """r(t) = (1−t)P + tQ, t∈[0,1]."""
    dim = rc([2, 3])
    P = rand_vec(dim, SML)
    Q = rand_vec(dim, SML)
    if P == Q:
        return None
    comps = [(1-t)*P[i] + t*Q[i] for i in range(dim)]
    comps_simplified = [sp.expand(c) for c in comps]

    P_s = "(" + ", ".join(str(c) for c in P) + ")"
    Q_s = "(" + ", ".join(str(c) for c in Q) + ")"
    q_text = (f"Find the vector equation of the line segment from "
              f"\\( P{P_s} \\) to \\( Q{Q_s} \\).")
    comp_latex = [sp.latex(c) for c in comps_simplified]
    ans_latex = (f"\\mathbf{{r}}(t) = \\langle {', '.join(comp_latex)} \\rangle, "
                 f"\\; 0 \\le t \\le 1")
    ans_plain = f"r(t) = {vec_plain(comps_simplified)}, 0 <= t <= 1"
    sig = ("line_seg", tuple(P), tuple(Q))
    return {"q_text": q_text, "type": "line_segment_equation",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_function_limit():
    """lim(t→a) component-wise."""
    a_val = rc([0, 1, -1, 2])
    a_sp = sp.Integer(a_val)

    # Build components that have well-defined limits
    comp_builders = [
        lambda: rc(SML)*t**2 + rc(NZ)*t + rc(NZ),
        lambda: sp.sin(rc(SML)*t),
        lambda: sp.cos(rc(SML)*t),
        lambda: sp.exp(rc(SML)*t),
        lambda: rc(SML)*t + rc(NZ),
    ]
    # Special component: sin(t-a)/(t-a) -> 1 or (e^(t-a)-1)/(t-a) -> 1
    use_special = random.random() < 0.35 and a_val != 0

    comps = []
    for i in range(3):
        if i == 0 and use_special:
            if random.random() < 0.5:
                comps.append(sp.sin(t - a_sp) / (t - a_sp))
            else:
                comps.append((sp.exp(t - a_sp) - 1) / (t - a_sp))
        else:
            fn = rc(comp_builders)
            comps.append(fn())

    try:
        limits = []
        for comp in comps:
            lim = sp.limit(comp, t, a_sp)
            if lim.has(sp.zoo, sp.nan, sp.oo, -sp.oo):
                return None
            limits.append(sp.simplify(lim))
    except Exception:
        return None

    comp_latex = [sp.latex(c) for c in comps]
    r_lat = f"\\langle {', '.join(comp_latex)} \\rangle"
    q_text = (f"Evaluate \\( \\lim_{{t \\to {sp.latex(a_sp)}}} "
              f"\\mathbf{{r}}(t) \\) where "
              f"\\( \\mathbf{{r}}(t) = {r_lat} \\).")
    lim_latex = vec_latex(limits)
    ans_latex = f"\\lim_{{t \\to {sp.latex(a_sp)}}} \\mathbf{{r}}(t) = {lim_latex}"
    ans_plain = f"lim r(t) = {vec_plain(limits)}"
    sig = ("vf_limit", str(comps), a_val)
    return {"q_text": q_text, "type": "vector_function_limit",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_function_derivative():
    """r'(t) = ⟨f'(t), g'(t), h'(t)⟩."""
    a, b, c_ = rc(NZ), rc(NZ), rc(NZ)
    comp_opts = [
        a*t**rc([2, 3, 4]),
        b*sp.sin(rc(SML)*t),
        c_*sp.cos(rc(SML)*t),
        rc(NZ)*sp.exp(rc(SML)*t),
        a*sp.log(t + rc(POS)),
        b*t**2 + c_*t,
        rc(SML)*sp.tan(t),
        a*sp.sqrt(t + rc(POS)),
    ]
    comps = random.sample(comp_opts, 3)
    derivs = []
    for comp in comps:
        try:
            d = sp.diff(comp, t)
            d = sp.simplify(d)
            if d.has(sp.zoo, sp.nan):
                return None
            derivs.append(d)
        except Exception:
            return None

    comp_latex = [sp.latex(c) for c in comps]
    deriv_latex = [sp.latex(d) for d in derivs]
    r_lat = f"\\langle {', '.join(comp_latex)} \\rangle"
    q_text = (f"Find \\( \\mathbf{{r}}'(t) \\) where "
              f"\\( \\mathbf{{r}}(t) = {r_lat} \\).")
    ans_latex = f"\\mathbf{{r}}'(t) = \\langle {', '.join(deriv_latex)} \\rangle"
    ans_plain = f"r'(t) = <{', '.join(str(d) for d in derivs)}>"
    sig = ("vf_deriv", str(comps))
    return {"q_text": q_text, "type": "vector_function_derivative",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


def gen_vector_function_integral():
    """∫r(t)dt or ∫_a^b r(t)dt component-wise."""
    is_definite = random.random() < 0.5
    a_val = rc([0, 1])
    b_val = a_val + rc([1, 2, 3])

    comp_builders = [
        lambda: rc(NZ)*t**rc([1, 2, 3]),
        lambda: rc(SML)*sp.sin(rc(SML)*t),
        lambda: rc(SML)*sp.cos(rc(SML)*t),
        lambda: rc(SML)*sp.exp(t),
        lambda: rc(SML)*t + rc(NZ),
    ]

    comps = [rc(comp_builders)() for _ in range(3)]

    try:
        if is_definite:
            integrals = []
            for comp in comps:
                val = sp.integrate(comp, (t, a_val, b_val))
                val = sp.simplify(val)
                if val.has(sp.zoo, sp.nan):
                    return None
                integrals.append(val)
            int_latex = vec_latex(integrals)
            int_plain = vec_plain(integrals)
            q_prefix = (f"Evaluate \\( \\int_{{{a_val}}}^{{{b_val}}} "
                        f"\\mathbf{{r}}(t) \\, dt \\)")
        else:
            C = sp.Symbol('C')
            integrals = []
            for comp in comps:
                val = sp.integrate(comp, t)
                val = sp.simplify(val)
                if val.has(sp.zoo, sp.nan):
                    return None
                integrals.append(val)
            int_latex = (f"\\langle {', '.join(sp.latex(c) for c in integrals)} \\rangle "
                         f"+ \\mathbf{{C}}")
            int_plain = f"{vec_plain(integrals)} + C"
            q_prefix = f"Find \\( \\int \\mathbf{{r}}(t) \\, dt \\)"
    except Exception:
        return None

    comp_latex = [sp.latex(c) for c in comps]
    r_lat = f"\\langle {', '.join(comp_latex)} \\rangle"
    q_text = f"{q_prefix} where \\( \\mathbf{{r}}(t) = {r_lat} \\)."

    if is_definite:
        ans_latex = f"\\int_{{{a_val}}}^{{{b_val}}} \\mathbf{{r}}(t)\\,dt = {int_latex}"
    else:
        ans_latex = f"\\int \\mathbf{{r}}(t)\\,dt = {int_latex}"
    ans_plain = f"integral = {int_plain}"
    sig = ("vf_integral", str(comps), is_definite, a_val, b_val)
    return {"q_text": q_text, "type": "vector_function_integral",
            "ans_latex": ans_latex, "ans_plain": ans_plain, "sig": sig}


# ===========================================================================
# Type ↔ Difficulty mapping & Generator registry
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "vector_from_points", "position_vector", "vector_arithmetic",
        "unit_vector", "parallel_vectors", "vector_endpoint",
    ],
    "medium": [
        "dot_product", "angle_between_vectors", "orthogonal_parallel_neither",
        "vector_projection", "direction_cosines", "cross_product",
    ],
    "hard": [
        "vector_function_domain", "vector_function_graph",
        "line_segment_equation", "vector_function_limit",
        "vector_function_derivative", "vector_function_integral",
    ],
}

GENERATORS = {
    # Basic
    "vector_from_points":            gen_vector_from_points,
    "position_vector":               gen_position_vector,
    "vector_arithmetic":             gen_vector_arithmetic,
    "unit_vector":                   gen_unit_vector,
    "parallel_vectors":              gen_parallel_vectors,
    "vector_endpoint":               gen_vector_endpoint,
    # Medium
    "dot_product":                   gen_dot_product,
    "angle_between_vectors":         gen_angle_between_vectors,
    "orthogonal_parallel_neither":   gen_orthogonal_parallel_neither,
    "vector_projection":             gen_vector_projection,
    "direction_cosines":             gen_direction_cosines,
    "cross_product":                 gen_cross_product,
    # Hard
    "vector_function_domain":        gen_vector_function_domain,
    "vector_function_graph":         gen_vector_function_graph,
    "line_segment_equation":         gen_line_segment_equation,
    "vector_function_limit":         gen_vector_function_limit,
    "vector_function_derivative":    gen_vector_function_derivative,
    "vector_function_integral":      gen_vector_function_integral,
}


# ===========================================================================
# Main generation loop
# ===========================================================================

def generate_vector_calculus_questions(num_questions):
    questions = []
    seen_signatures = set()
    attempts = 0
    max_attempts = num_questions * 50

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1

        # Difficulty distribution: 35% basic, 35% medium, 30% hard
        rand_val = random.random()
        if   rand_val < 0.35: difficulty = "basic"
        elif rand_val < 0.70: difficulty = "medium"
        else:                 difficulty = "hard"

        q_type = rc(DIFFICULTY_TYPES[difficulty])
        gen_fn = GENERATORS.get(q_type)
        if gen_fn is None:
            continue

        try:
            rec = gen_fn()
            if rec is None:
                continue

            q_type    = rec["type"]
            ans_latex = rec["ans_latex"]
            ans_plain = rec["ans_plain"]
            q_text    = rec["q_text"]
            sig       = rec.get("sig")

            # Deduplication
            if sig and sig in seen_signatures:
                continue

            entry = {
                "id":              len(questions) + 1,
                "type":            q_type,
                "difficulty":      difficulty,
                "question_text":   q_text,
                "answer_latex":    ans_latex,
                "answer_plain":    ans_plain,
            }

            questions.append(entry)
            if sig:
                seen_signatures.add(sig)

            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} vector calculus questions...")

        except Exception:
            pass

    return questions


# ===========================================================================
# Entry point
# ===========================================================================

if __name__ == "__main__":
    print("Generating 1500 Vector Calculus questions...")
    questions = generate_vector_calculus_questions(1500)

    output_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "calculus")
    os.makedirs(output_dir, exist_ok=True)

    output_file = os.path.join(output_dir, "vector_calculus.json")
    with open(output_file, "w") as f_out:
        json.dump(
            {
                "topic": "Vector Calculus",
                "description": (
                    "Comprehensive Practice Worksheet Database for Vector Calculus "
                    "(18 types, Dawkins Ch 11-12). "
                    "Basic: Vector from Points, Position Vector, Vector Arithmetic, "
                    "Unit Vector, Parallel Vectors, Vector Endpoint. "
                    "Medium: Dot Product, Angle Between Vectors, "
                    "Orthogonal/Parallel/Neither, Vector Projection, "
                    "Direction Cosines, Cross Product. "
                    "Hard: Vector Function Domain, Vector Function Graph, "
                    "Line Segment Equation, Vector Function Limit, "
                    "Vector Function Derivative, Vector Function Integral."
                ),
                "questions": questions,
            },
            f_out,
            separators=(',', ':'),
        )

    # Print summary
    type_counts = {}
    diff_counts = {}
    for q in questions:
        type_counts[q["type"]] = type_counts.get(q["type"], 0) + 1
        diff_counts[q["difficulty"]] = diff_counts.get(q["difficulty"], 0) + 1

    print(f"\nDone! Generated {len(questions)} questions → {output_file}")
    print(f"\nBy difficulty:")
    for d in ["basic", "medium", "hard"]:
        print(f"  {d}: {diff_counts.get(d, 0)}")
    print(f"\nBy type:")
    for t_name in sorted(type_counts.keys()):
        print(f"  {t_name}: {type_counts[t_name]}")
