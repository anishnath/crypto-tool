#!/usr/bin/env python3
"""
PDE Question Bank Generator — Maximum Math Coverage
All answers verified by SymPy where applicable.
Covers: Heat, Wave, Laplace, Poisson, Transport, Schrodinger,
        Fourier Series, Eigenvalues, Green's Functions, Superposition,
        Maximum Principle, Well-posedness, Duhamel, Robin BC, etc.
"""
import sympy as sp
import json
import random
import os

x, y, t, s = sp.symbols('x y t s', real=True)
pi = sp.pi
x_sym = sp.Symbol('x')
n_sym = sp.Symbol('n', positive=True, integer=True)

# ============================================================
# Helper: safe SymPy Fourier coefficient computation
# ============================================================
def compute_fourier_sine_coeff(f_expr, Lv, nv):
    """Compute b_n = (2/L) * integral(f(x)*sin(n*pi*x/L), x, 0, L)"""
    bn = (2 / Lv) * sp.integrate(f_expr * sp.sin(nv * pi * x_sym / Lv), (x_sym, 0, Lv))
    return sp.simplify(bn)

def compute_fourier_cosine_coeff(f_expr, Lv, nv):
    """Compute a_n = (2/L) * integral(f(x)*cos(n*pi*x/L), x, 0, L)"""
    an = (2 / Lv) * sp.integrate(f_expr * sp.cos(nv * pi * x_sym / Lv), (x_sym, 0, Lv))
    return sp.simplify(an)


def generate_pde_questions(num_questions):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = num_questions * 15

    # ---------- type pools per difficulty ----------
    basic_types = [
        "heat_classify", "wave_classify", "pde_classify",
        "bc_identify", "linearity_check", "order_identify",
        "homogeneous_check", "superposition_basic"
    ]
    medium_types = [
        "heat_separation", "wave_separation", "transport_solve",
        "laplace_rectangular", "fourier_sine_coeff", "fourier_cosine_coeff",
        "heat_steady_state", "wave_dalembert",
        "wave_initial_velocity", "heat_robin_separation",
        "superposition_combine", "orthogonality_check",
        "poisson_1d_particular"
    ]
    hard_types = [
        "heat_fourier_full", "wave_fourier_full",
        "poisson_source_bc", "heat_neumann_eigenvalues",
        "wave_energy_conservation", "transport_characteristics",
        "laplace_polar", "heat_rod_insulated",
        "fourier_convergence", "maximum_principle",
        "heat_decay_rate", "laplace_annulus",
        "heat_half_range_expansion"
    ]
    scholar_types = [
        "schrodinger_infinite_well", "heat_nonhomogeneous_steady",
        "wave_forced_resonance", "green_function_1d",
        "eigenvalue_sturm_liouville", "stability_cfl",
        "poisson_disk_radial", "duhamel_principle",
        "wellposedness", "wave_reflection_transmission",
        "heat_nonhomogeneous_duhamel", "laplace_3d_separation",
        "uniqueness_energy_argument", "biharmonic_decompose"
    ]

    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1

        c1 = random.choice(list(range(-8, 0)) + list(range(1, 9)))
        c2 = random.choice(list(range(-6, 0)) + list(range(1, 7)))
        c3 = random.choice(list(range(1, 8)))

        diff_val = random.random()
        if diff_val < 0.20:
            difficulty = "basic"
            q_type = random.choice(basic_types)
        elif diff_val < 0.45:
            difficulty = "medium"
            q_type = random.choice(medium_types)
        elif diff_val < 0.75:
            difficulty = "hard"
            q_type = random.choice(hard_types)
        else:
            difficulty = "scholar"
            q_type = random.choice(scholar_types)

        q_text = ""
        ans_latex = ""
        ans_plain = ""

        try:
            # ==========================================================================
            #  BASIC (20%)
            # ==========================================================================

            if q_type == "heat_classify":
                alpha = random.choice(list(range(1, 10)) + [sp.Rational(1,2), sp.Rational(1,4), sp.Rational(3,2)])
                variant = random.choice(["1D", "2D", "reaction"])
                if variant == "1D":
                    q_text = (
                        f"Classify the PDE \\( \\frac{{\\partial u}}{{\\partial t}} "
                        f"= {sp.latex(alpha)} \\frac{{\\partial^2 u}}{{\\partial x^2}} \\). "
                        f"State whether it is parabolic, hyperbolic, or elliptic."
                    )
                elif variant == "2D":
                    q_text = (
                        f"Classify the PDE \\( u_t = {sp.latex(alpha)} (u_{{xx}} + u_{{yy}}) \\). "
                        f"State the type."
                    )
                else:
                    rv = random.choice([1, 2, 3])
                    q_text = (
                        f"Classify the PDE \\( u_t = {sp.latex(alpha)} u_{{xx}} - {rv} u \\). "
                        f"State the type (reaction-diffusion)."
                    )
                ans_latex = f"\\text{{Parabolic (heat/diffusion equation, }} k = {sp.latex(alpha)}\\text{{)}}"
                ans_plain = f"Parabolic (heat/diffusion equation, k = {alpha})"

            elif q_type == "wave_classify":
                cv = random.choice(list(range(1, 8)) + [sp.Rational(1,2), sp.Rational(3,2)])
                variant = random.choice(["standard", "damped", "string"])
                if variant == "standard":
                    q_text = (
                        f"Classify the PDE \\( u_{{tt}} = {sp.latex(cv**2)} u_{{xx}} \\). "
                        f"State the type and wave speed."
                    )
                    ans_latex = f"\\text{{Hyperbolic (wave equation, }} c = {sp.latex(cv)}\\text{{)}}"
                    ans_plain = f"Hyperbolic (wave equation, c = {cv})"
                elif variant == "damped":
                    bv = random.choice([1, 2, 3, 4, 5])
                    q_text = (
                        f"Classify \\( u_{{tt}} + {bv} u_t = {sp.latex(cv**2)} u_{{xx}} \\). "
                        f"State the type and identify the damping coefficient."
                    )
                    ans_latex = f"\\text{{Hyperbolic (damped wave, }} c = {sp.latex(cv)}, \\beta = {bv}\\text{{)}}"
                    ans_plain = f"Hyperbolic (damped wave, c = {cv}, damping = {bv})"
                else:
                    tension = random.choice([1, 2, 4, 9, 16])
                    density = random.choice([1, 2, 4])
                    c_val = sp.sqrt(sp.Rational(tension, density))
                    q_text = (
                        f"A string has tension T = {tension} and linear density \\( \\rho = {density} \\). "
                        f"Write the wave equation and find the wave speed \\( c = \\sqrt{{T/\\rho}} \\)."
                    )
                    ans_latex = f"u_{{tt}} = {sp.latex(sp.Rational(tension,density))} u_{{xx}}, \\quad c = {sp.latex(c_val)}"
                    ans_plain = f"u_tt = {sp.Rational(tension,density)} u_xx, c = {c_val}"

            elif q_type == "pde_classify":
                A = random.choice(list(range(1, 8)))
                B = random.choice(list(range(0, 6)))
                C = random.choice(list(range(1, 8)))
                disc = B**2 - A*C
                if disc < 0:
                    pde_type = "Elliptic"
                elif disc == 0:
                    pde_type = "Parabolic"
                else:
                    pde_type = "Hyperbolic"
                b_term = f"+ {2*B}u_{{xy}} " if B > 0 else ""
                q_text = (
                    f"Classify \\( {A}u_{{xx}} {b_term}+ {C}u_{{yy}} = 0 \\). "
                    f"Compute \\( B^2 - AC \\) and state the type."
                )
                ans_latex = f"B^2 - AC = {B**2} - {A*C} = {disc}. \\; \\text{{{pde_type}}}"
                ans_plain = f"B^2 - AC = {B**2} - {A*C} = {disc}. {pde_type}"

            elif q_type == "bc_identify":
                h_val = random.choice([1, 2, 3, 5, 10])
                T_val = random.choice([0, 10, 20, 50, 100])
                flux = random.choice([-3, -2, -1, 1, 2, 3])
                bc_types = [
                    (f"u(0,t) = {T_val}", "Dirichlet", f"fixed value ({T_val}) at the boundary"),
                    ("u_x(0,t) = 0", "Neumann", "zero flux / insulated boundary"),
                    (f"u_x(L,t) + {h_val} u(L,t) = 0", "Robin (mixed)", "convective boundary condition"),
                    ("u(0,t) = u(L,t)", "Periodic", "periodic boundary condition"),
                    (f"u_x(0,t) = {flux}", "Neumann", f"prescribed flux of {flux} at the boundary"),
                    (f"u(0,t) = 0, \\; u(L,t) = {T_val}", "Dirichlet", f"fixed endpoints (0 and {T_val})"),
                    (f"{h_val} u(0,t) - u_x(0,t) = 0", "Robin (mixed)", "Robin condition at left end"),
                ]
                bc = random.choice(bc_types)
                q_text = (
                    f"Identify and classify the boundary condition: \\( {bc[0]} \\). "
                    f"Name the type."
                )
                ans_latex = f"\\textbf{{{bc[1]}.}} \\; \\text{{{bc[2]}}}"
                ans_plain = f"{bc[1]}: {bc[2]}"

            elif q_type == "linearity_check":
                a, b = abs(c1), abs(c2)
                cases = [
                    (f"u_t = {a} u_{{xx}}", True, "coefficients don't depend on $u$"),
                    (f"u_t = u \\cdot u_{{xx}}", False, "$u$ multiplies $u_{{xx}}$"),
                    (f"u_t = u_{{xx}} + u^{random.choice([2,3,4])}", False, "contains $u^n$ nonlinear term"),
                    (f"u_{{tt}} = {a} u_{{xx}}", True, "constant coefficient wave equation"),
                    (f"u_t = {a} u_{{xx}} + {b}\\sin(x)", True, "source depends only on $x$"),
                    (f"u_t = (u_x)^2", False, "square of first derivative"),
                    (f"u_t = {a} u_{{xx}} + {b} u", True, "linear reaction-diffusion"),
                    (f"u_t = u_{{xx}} + u \\cdot u_x", False, "$u$ multiplies $u_x$ (Burgers-type)"),
                    (f"{a} u_{{xx}} + {b} u_{{yy}} = 0", True, "Laplace/Helmholtz type"),
                    (f"u_t = {a} u_{{xx}} - {b} u^3", False, "cubic reaction term"),
                    (f"u_{{tt}} + {a} u_t = {b} u_{{xx}}", True, "damped wave equation"),
                    (f"u_t = \\nabla \\cdot (u \\nabla u)", False, "diffusion coefficient depends on $u$"),
                    (f"u_{{xx}} + u_{{yy}} + {a} u = 0", True, "Helmholtz equation, linear"),
                    (f"u_t = {a} u_{{xx}} + e^u", False, "exponential nonlinearity in $u$"),
                ]
                case = random.choice(cases)
                linear_str = "Linear" if case[1] else "Nonlinear"
                q_text = (
                    f"Is the PDE \\( {case[0]} \\) linear or nonlinear? Justify."
                )
                ans_latex = f"\\textbf{{{linear_str}.}} \\; {case[2]}"
                ans_plain = f"{linear_str}: {case[2]}"

            elif q_type == "order_identify":
                cases = [
                    (f"u_t = {abs(c1)} u_{{xx}}", 2, "second-order", "highest derivative is $u_{xx}$"),
                    (f"u_t + {abs(c1)} u_x = 0", 1, "first-order", "highest derivative is $u_x$ or $u_t$"),
                    (f"u_{{tt}} = {abs(c1)} u_{{xx}}", 2, "second-order", "$u_{tt}$ and $u_{xx}$ both order 2"),
                    (f"u_{{xxx}} + u_t = 0", 3, "third-order", "highest derivative is $u_{xxx}$ (KdV-type)"),
                    (f"\\nabla^4 u = 0", 4, "fourth-order", "biharmonic equation"),
                    (f"u_{{xxxx}} + u_{{tt}} = 0", 4, "fourth-order", "beam/plate equation"),
                    (f"u_{{xxy}} + u_{{yy}} = 0", 3, "third-order", "mixed partial $u_{xxy}$ is order 3"),
                ]
                case = random.choice(cases)
                q_text = (
                    f"What is the order of the PDE \\( {case[0]} \\)? Explain."
                )
                ans_latex = f"\\text{{Order {case[1]}: {case[2]}}} \\quad ({case[3]})"
                ans_plain = f"Order {case[1]}: {case[2]} ({case[3]})"

            elif q_type == "homogeneous_check":
                a, b = abs(c1), abs(c2)
                cases = [
                    (f"u_t = {a} u_{{xx}}", True, "no free term (source)"),
                    (f"u_t = {a} u_{{xx}} + {b}", False, f"constant source term {b}"),
                    (f"u_{{tt}} = {a} u_{{xx}}", True, "no forcing function"),
                    (f"u_{{xx}} + u_{{yy}} = {b} \\sin(x)", False, "source f(x) = sin(x)"),
                    (f"u_{{xx}} + u_{{yy}} = 0", True, "Laplace equation, homogeneous"),
                    (f"u_t + {a} u_x = {b} e^x", False, f"source term {b}e^x"),
                    (f"u_{{tt}} + {a} u = 0", True, "no external forcing"),
                    (f"u_{{xx}} + u_{{yy}} + {a} u = 0", True, "Helmholtz equation, homogeneous (all terms involve u)"),
                ]
                case = random.choice(cases)
                hom_str = "Homogeneous" if case[1] else "Nonhomogeneous"
                q_text = (
                    f"Is the PDE \\( {case[0]} \\) homogeneous or nonhomogeneous?"
                )
                ans_latex = f"\\textbf{{{hom_str}.}} \\; \\text{{{case[2]}}}"
                ans_plain = f"{hom_str}: {case[2]}"

            elif q_type == "superposition_basic":
                kv = random.choice([1, 2, 3, 4, 5])
                Lv = random.choice([1, sp.pi, 2])
                n1 = random.choice([1, 2])
                n2 = random.choice([3, 4, 5])
                a1 = random.choice([1, 2, 3])
                a2 = random.choice([1, 2, 3])
                lam1 = (n1 * pi / Lv)**2
                lam2 = (n2 * pi / Lv)**2
                q_text = (
                    f"If \\( u_1 = {a1} \\sin\\left(\\frac{{{n1}\\pi x}}{{{sp.latex(Lv)}}}\\right) e^{{-{kv} \\cdot {sp.latex(lam1)} \\cdot t}} \\) "
                    f"and \\( u_2 = {a2} \\sin\\left(\\frac{{{n2}\\pi x}}{{{sp.latex(Lv)}}}\\right) e^{{-{kv} \\cdot {sp.latex(lam2)} \\cdot t}} \\) "
                    f"are both solutions of \\( u_t = {kv} u_{{xx}} \\), "
                    f"is \\( u = u_1 + u_2 \\) also a solution? Why?"
                )
                ans_latex = (
                    f"\\text{{Yes. The heat equation is linear and homogeneous, so the superposition principle applies: }}"
                    f"u = u_1 + u_2 \\text{{ is also a solution.}}"
                )
                ans_plain = "Yes. The heat equation is linear and homogeneous, so superposition applies: u = u_1 + u_2 is also a solution."

            # ==========================================================================
            #  MEDIUM (25%)
            # ==========================================================================

            elif q_type == "heat_separation":
                kv = random.choice([1, 2, 3, 4, 5, 6, sp.Rational(1,2), sp.Rational(1,4)])
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                lambda_n = (nv * pi / Lv)**2
                T_decay = sp.exp(-kv * lambda_n * t)
                X_n = sp.sin(nv * pi * x / Lv)

                q_text = (
                    f"Using separation of variables, find the n={nv} mode of the heat equation "
                    f"\\( u_t = {sp.latex(kv)} u_{{xx}} \\) on \\( (0, {sp.latex(Lv)}) \\) with "
                    f"Dirichlet BCs \\( u(0,t)=0,\\; u({sp.latex(Lv)},t)=0 \\)."
                )
                sol = X_n * T_decay
                ans_latex = f"u_{nv}(x,t) = B_{nv} {sp.latex(sol)}"
                ans_plain = f"u_{nv}(x,t) = B_{nv} * {sol}"

            elif q_type == "wave_separation":
                cv = random.choice([1, 2, 3, 4, 5, sp.Rational(1,2)])
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                omega_n = nv * pi * cv / Lv
                X_n = sp.sin(nv * pi * x / Lv)

                q_text = (
                    f"Find the n={nv} normal mode of \\( u_{{tt}} = {sp.latex(cv**2)} u_{{xx}} \\) "
                    f"on \\( (0, {sp.latex(Lv)}) \\) with fixed endpoints."
                )
                ans_latex = (
                    f"u_{nv} = {sp.latex(X_n)}"
                    f"\\left(A_{nv}\\cos {sp.latex(omega_n)} t + B_{nv}\\sin {sp.latex(omega_n)} t\\right)"
                )
                ans_plain = f"u_{nv} = sin({nv}*pi*x/{Lv})*(A*cos({omega_n}*t) + B*sin({omega_n}*t))"

            elif q_type == "transport_solve":
                cv = random.choice(list(range(-5, 0)) + list(range(1, 6)))
                freq = random.choice([1, 2, 3])
                ic_choices = [
                    (f"\\sin({freq}x)", sp.sin(freq*(x - cv*t))),
                    (f"e^{{-x^2}}", sp.exp(-(x - cv*t)**2)),
                    (f"\\cos({freq}x)", sp.cos(freq*(x - cv*t))),
                    (f"x^2", (x - cv*t)**2),
                ]
                ic = random.choice(ic_choices)
                q_text = (
                    f"Solve \\( u_t + {cv} u_x = 0 \\) with \\( u(x,0) = {ic[0]} \\)."
                )
                ans_latex = f"u(x,t) = {sp.latex(ic[1])}"
                ans_plain = f"u(x,t) = {ic[1]}"

            elif q_type == "laplace_rectangular":
                Lx = random.choice([1, 2, 3, sp.pi, 2*sp.pi])
                Ly = random.choice([1, 2, 3, sp.pi, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                X_n = sp.sin(nv * pi * x / Lx)
                lambda_n = nv * pi / Lx
                Y_n = sp.sinh(lambda_n * y) / sp.sinh(lambda_n * Ly)

                q_text = (
                    f"Find the n={nv} term for Laplace's equation "
                    f"\\( u_{{xx}} + u_{{yy}} = 0 \\) on \\( (0,{sp.latex(Lx)}) \\times (0,{sp.latex(Ly)}) \\) "
                    f"with \\( u(0,y)=u({sp.latex(Lx)},y)=u(x,0)=0 \\)."
                )
                ans_latex = f"u_{nv} = B_{nv} {sp.latex(X_n)} \\cdot {sp.latex(Y_n)}"
                ans_plain = f"u_{nv} = B_{nv} * sin({nv}*pi*x/{Lx}) * sinh({lambda_n}*y)/sinh({lambda_n}*{Ly})"

            elif q_type == "fourier_sine_coeff":
                Lv = random.choice([1, sp.pi, 2, 3, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                funcs = [
                    ("x", x_sym),
                    ("x^2", x_sym**2),
                    (f"{sp.latex(Lv)} - x", Lv - x_sym),
                    ("1", sp.Integer(1)),
                    (f"x({sp.latex(Lv)} - x)", x_sym*(Lv - x_sym)),
                ]
                fc = random.choice(funcs)
                bn = compute_fourier_sine_coeff(fc[1], Lv, nv)

                q_text = (
                    f"Compute the Fourier sine coefficient \\( b_{{{nv}}} \\) for "
                    f"\\( f(x) = {fc[0]} \\) on \\( [0, {sp.latex(Lv)}] \\)."
                )
                ans_latex = f"b_{{{nv}}} = {sp.latex(bn)}"
                ans_plain = f"b_{nv} = {bn}"

            elif q_type == "fourier_cosine_coeff":
                Lv = random.choice([1, sp.pi, 2, 3, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                funcs = [
                    ("x", x_sym),
                    ("x^2", x_sym**2),
                    ("1", sp.Integer(1)),
                    (f"{sp.latex(Lv)} - x", Lv - x_sym),
                ]
                fc = random.choice(funcs)
                an = compute_fourier_cosine_coeff(fc[1], Lv, nv)

                q_text = (
                    f"Compute the Fourier cosine coefficient \\( a_{{{nv}}} \\) for "
                    f"\\( f(x) = {fc[0]} \\) on \\( [0, {sp.latex(Lv)}] \\)."
                )
                ans_latex = f"a_{{{nv}}} = {sp.latex(an)}"
                ans_plain = f"a_{nv} = {an}"

            elif q_type == "heat_steady_state":
                u0 = random.choice(list(range(0, 101, 5)))
                uL = random.choice(list(range(0, 101, 5)))
                while u0 == uL:
                    uL = random.choice(list(range(0, 101, 5)))
                Lv = random.choice([1, 2, 3, 4, 5, 10, 20])
                slope = sp.Rational(uL - u0, Lv)
                sol = u0 + slope * x_sym
                q_text = (
                    f"Find the steady-state solution \\( u(x) \\) for a rod of length {Lv} "
                    f"with \\( u(0) = {u0},\\; u({Lv}) = {uL} \\). (Solve \\( u_{{xx}} = 0 \\).)"
                )
                ans_latex = f"u(x) = {sp.latex(sol)}"
                ans_plain = f"u(x) = {sol}"

            elif q_type == "wave_dalembert":
                cv = random.choice([1, 2, 3, 4, 5])
                funcs = [
                    (f"e^{{-x^2}}", sp.exp(-x**2)),
                    (f"\\frac{{1}}{{1+x^2}}", 1/(1+x**2)),
                    (f"\\cos(x)", sp.cos(x)),
                    (f"e^{{-|x|}}", sp.exp(-sp.Abs(x))),
                ]
                fc = random.choice(funcs)
                f_plus = fc[1].subs(x, x + cv*t)
                f_minus = fc[1].subs(x, x - cv*t)
                sol = sp.Rational(1, 2) * (f_plus + f_minus)

                q_text = (
                    f"Using d'Alembert's formula, solve \\( u_{{tt}} = {cv**2} u_{{xx}} \\) on "
                    f"\\( (-\\infty, \\infty) \\) with \\( u(x,0) = {fc[0]},\\; u_t(x,0) = 0 \\)."
                )
                ans_latex = f"u(x,t) = {sp.latex(sol)}"
                ans_plain = f"u(x,t) = {sol}"

            elif q_type == "wave_initial_velocity":
                cv = random.choice([1, 2, 3, 4, 5])
                funcs = [
                    (f"\\sin(x)", sp.sin(x)),
                    (f"e^{{-x^2}}", sp.exp(-x**2)),
                    (f"x e^{{-x^2}}", x * sp.exp(-x**2)),
                ]
                gc = random.choice(funcs)
                # d'Alembert with f=0, g given: u = 1/(2c) * integral(g, x-ct..x+ct)
                xi = sp.Symbol('xi')
                integral_val = sp.integrate(gc[1].subs(x, xi), (xi, x - cv*t, x + cv*t))
                sol = sp.simplify(integral_val / (2*cv))

                q_text = (
                    f"Solve \\( u_{{tt}} = {cv**2} u_{{xx}} \\) on \\( (-\\infty, \\infty) \\) with "
                    f"\\( u(x,0) = 0,\\; u_t(x,0) = {gc[0]} \\). Use d'Alembert's formula."
                )
                ans_latex = f"u(x,t) = {sp.latex(sol)}"
                ans_plain = f"u(x,t) = {sol}"

            elif q_type == "heat_robin_separation":
                kv = random.choice([1, 2, 3])
                hv = random.choice([1, 2, 3, 5])
                Lv = random.choice([1, sp.pi])
                q_text = (
                    f"For \\( u_t = {kv} u_{{xx}} \\) on \\( (0, {sp.latex(Lv)}) \\) with Robin BCs "
                    f"\\( u(0,t) = 0,\\; u_x({sp.latex(Lv)},t) + {hv} u({sp.latex(Lv)},t) = 0 \\), "
                    f"write the eigenvalue equation that \\( \\lambda \\) must satisfy."
                )
                ans_latex = (
                    f"\\sqrt{{\\lambda}} \\cos(\\sqrt{{\\lambda}} \\cdot {sp.latex(Lv)}) "
                    f"+ {hv} \\sin(\\sqrt{{\\lambda}} \\cdot {sp.latex(Lv)}) = 0, "
                    f"\\quad \\text{{i.e. }} \\tan(\\sqrt{{\\lambda}} \\cdot {sp.latex(Lv)}) "
                    f"= -\\frac{{\\sqrt{{\\lambda}}}}{{{hv}}}"
                )
                ans_plain = f"sqrt(lambda)*cos(sqrt(lambda)*{Lv}) + {hv}*sin(sqrt(lambda)*{Lv}) = 0"

            elif q_type == "superposition_combine":
                kv = random.choice([1, 2, 3])
                Lv = sp.pi
                # Two-mode solution
                n1, n2 = 1, random.choice([2, 3, 4])
                a1 = random.choice([1, 2, 3, 4, 5])
                a2 = random.choice([1, 2, 3, 4, 5])
                u1 = a1 * sp.sin(n1*x) * sp.exp(-kv*n1**2*t)
                u2 = a2 * sp.sin(n2*x) * sp.exp(-kv*n2**2*t)
                ic = a1*sp.sin(n1*x_sym) + a2*sp.sin(n2*x_sym)

                q_text = (
                    f"Solve \\( u_t = {kv} u_{{xx}} \\) on \\( (0, \\pi) \\) with "
                    f"\\( u(0,t) = u(\\pi,t) = 0 \\) and \\( u(x,0) = {sp.latex(ic)} \\)."
                )
                ans_latex = f"u(x,t) = {sp.latex(u1 + u2)}"
                ans_plain = f"u(x,t) = {u1 + u2}"

            elif q_type == "orthogonality_check":
                Lv = random.choice([1, sp.pi, 2])
                m = random.choice([1, 2, 3])
                nv = random.choice([4, 5, 6])
                # Verify orthogonality
                integral = sp.integrate(
                    sp.sin(m * pi * x_sym / Lv) * sp.sin(nv * pi * x_sym / Lv),
                    (x_sym, 0, Lv)
                )
                integral_simplified = sp.simplify(integral)

                q_text = (
                    f"Verify orthogonality: compute "
                    f"\\( \\int_0^{{{sp.latex(Lv)}}} \\sin\\left(\\frac{{{m}\\pi x}}{{{sp.latex(Lv)}}}\\right) "
                    f"\\sin\\left(\\frac{{{nv}\\pi x}}{{{sp.latex(Lv)}}}\\right) dx \\) for m={m}, n={nv}."
                )
                ans_latex = f"{sp.latex(integral_simplified)} \\quad (= 0 \\text{{ since }} m \\neq n)"
                ans_plain = f"{integral_simplified} (= 0 since m != n)"

            elif q_type == "poisson_1d_particular":
                # u_xx = f(x), integrate twice with SymPy verification
                source_funcs = [
                    (f"{c1}", sp.Integer(c1)),
                    (f"{c1}x", c1*x_sym),
                    (f"{c1}x^2", c1*x_sym**2),
                    (f"\\sin(x)", sp.sin(x_sym)),
                    (f"e^x", sp.exp(x_sym)),
                    (f"{c1}\\cos({c3}x)", c1*sp.cos(c3*x_sym)),
                ]
                sc = random.choice(source_funcs)
                u_p = sp.integrate(sp.integrate(sc[1], x_sym), x_sym)
                # Verify: u_p'' should equal sc[1]
                verify = sp.simplify(sp.diff(u_p, x_sym, 2) - sc[1])
                if verify != 0:
                    continue

                q_text = (
                    f"Find a particular solution \\( u_p(x) \\) to \\( u_{{xx}} = {sc[0]} \\)."
                )
                ans_latex = f"u_p(x) = {sp.latex(u_p)} + C_1 x + C_2"
                ans_plain = f"u_p(x) = {u_p} + C1*x + C2"

            # ==========================================================================
            #  HARD (30%)
            # ==========================================================================

            elif q_type == "heat_fourier_full":
                kv = random.choice([1, 2, 3, 4, 5])
                Lv = sp.pi
                ic_funcs = [
                    ("x(\\pi - x)", x_sym * (pi - x_sym)),
                    ("x", x_sym),
                    ("\\pi - x", pi - x_sym),
                    ("1", sp.Integer(1)),
                ]
                ic = random.choice(ic_funcs)
                bn = compute_fourier_sine_coeff(ic[1], Lv, n_sym)

                q_text = (
                    f"Solve \\( u_t = {kv} u_{{xx}} \\) on \\( (0,\\pi) \\) with "
                    f"\\( u(0,t)=u(\\pi,t)=0 \\) and \\( u(x,0) = {ic[0]} \\). "
                    f"Find the Fourier coefficient \\( b_n \\) and write the series solution."
                )
                ans_latex = (
                    f"b_n = {sp.latex(bn)}, \\quad "
                    f"u(x,t) = \\sum_{{n=1}}^{{\\infty}} b_n \\sin(nx) e^{{-{kv}n^2 t}}"
                )
                ans_plain = f"b_n = {bn}, u(x,t) = sum(b_n*sin(n*x)*exp(-{kv}*n^2*t), n=1..inf)"

            elif q_type == "wave_fourier_full":
                cv = random.choice([1, 2, 3, 4, 5])
                Lv = sp.pi
                ic_funcs = [
                    ("x(\\pi - x)", x_sym * (pi - x_sym)),
                    ("\\sin(2x)", sp.sin(2*x_sym)),
                ]
                ic = random.choice(ic_funcs)
                bn = compute_fourier_sine_coeff(ic[1], Lv, n_sym)

                q_text = (
                    f"Solve the wave equation \\( u_{{tt}} = {cv**2} u_{{xx}} \\) on \\( (0,\\pi) \\) "
                    f"with \\( u(0,t)=u(\\pi,t)=0 \\), \\( u(x,0) = {ic[0]} \\), \\( u_t(x,0)=0 \\). "
                    f"Find \\( b_n \\)."
                )
                ans_latex = (
                    f"b_n = {sp.latex(bn)}, \\quad "
                    f"u = \\sum_{{n=1}}^{{\\infty}} b_n \\sin(nx) \\cos({cv}nt)"
                )
                ans_plain = f"b_n = {bn}, u = sum(b_n*sin(n*x)*cos({cv}*n*t), n=1..inf)"

            elif q_type == "poisson_source_bc":
                # 1D Poisson with specific BCs — SymPy verified
                sv = random.choice(list(range(-5, 0)) + list(range(1, 6)))
                u0 = random.choice([0, 1, 2, 5])
                uL = random.choice([0, 1, 2, 5])
                Lv = random.choice([1, 2, 3, sp.pi])
                # u_xx = sv, u(0)=u0, u(Lv)=uL
                # General: u = sv/2 * x^2 + Ax + B, B=u0, A=(uL-u0-sv*Lv^2/2)/Lv
                B_val = u0
                A_val = (uL - u0 - sp.Rational(sv, 2)*Lv**2) / Lv
                sol = sp.Rational(sv, 2)*x_sym**2 + A_val*x_sym + B_val
                sol = sp.simplify(sol)
                # Verify
                verify = sp.simplify(sp.diff(sol, x_sym, 2) - sv)
                if verify != 0:
                    continue
                v0 = sol.subs(x_sym, 0)
                vL = sol.subs(x_sym, Lv)
                if sp.simplify(v0 - u0) != 0 or sp.simplify(vL - uL) != 0:
                    continue

                q_text = (
                    f"Solve \\( u_{{xx}} = {sv} \\) on \\( (0, {sp.latex(Lv)}) \\) "
                    f"with \\( u(0) = {u0},\\; u({sp.latex(Lv)}) = {uL} \\)."
                )
                ans_latex = f"u(x) = {sp.latex(sol)}"
                ans_plain = f"u(x) = {sol}"

            elif q_type == "heat_neumann_eigenvalues":
                kv = random.choice([1, 2, 3, 4, 5, sp.Rational(1,2)])
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi])

                q_text = (
                    f"Find the eigenvalues and eigenfunctions for \\( u_t = {sp.latex(kv)} u_{{xx}} \\) "
                    f"on \\( (0, {sp.latex(Lv)}) \\) with Neumann BCs \\( u_x(0,t)=u_x({sp.latex(Lv)},t)=0 \\)."
                )
                ans_latex = (
                    f"\\lambda_n = \\left(\\frac{{n\\pi}}{{{sp.latex(Lv)}}}\\right)^2,\\; "
                    f"X_n = \\cos\\left(\\frac{{n\\pi x}}{{{sp.latex(Lv)}}}\\right),\\; n=0,1,2,\\ldots"
                )
                ans_plain = f"lambda_n = (n*pi/{Lv})^2, X_n = cos(n*pi*x/{Lv}), n=0,1,2,..."

            elif q_type == "wave_energy_conservation":
                cv = random.choice([1, 2, 3, 4, 5])
                Lv = random.choice([sp.pi, 1, 2, 3, 2*sp.pi])
                rho = random.choice([1, 2])
                T_val = cv**2 * rho
                q_text = (
                    f"For \\( {rho} u_{{tt}} = {T_val} u_{{xx}} \\) on \\( [0, {sp.latex(Lv)}] \\) with fixed endpoints, "
                    f"write the energy \\( E(t) \\) and prove \\( dE/dt = 0 \\)."
                )
                ans_latex = (
                    f"E(t) = \\frac{{1}}{{2}}\\int_0^{{{sp.latex(Lv)}}} "
                    f"\\left[{rho} u_t^2 + {T_val} u_x^2\\right]dx,\\; \\frac{{dE}}{{dt}}=0"
                )
                ans_plain = f"E(t) = (1/2)*integral({rho}*u_t^2 + {T_val}*u_x^2, 0..{Lv}), dE/dt=0"

            elif q_type == "transport_characteristics":
                a = random.choice(list(range(-6, 0)) + list(range(1, 7)))
                b = random.choice(list(range(-5, 0)) + list(range(1, 6)))
                q_text = (
                    f"Find the characteristics of \\( u_t + {a} u_x = {b} u \\) "
                    f"and solve with \\( u(x,0) = f(x) \\)."
                )
                ans_latex = (
                    f"\\frac{{dx}}{{dt}} = {a} \\Rightarrow x = {a}t + x_0,\\; "
                    f"u(x,t) = f(x-{a}t)\\, e^{{{b}t}}"
                )
                ans_plain = f"dx/dt={a} => x={a}t+x_0, u(x,t) = f(x-{a}t)*exp({b}t)"

            elif q_type == "laplace_polar":
                nv = random.choice([1, 2, 3, 4, 5])
                R = random.choice([1, 2, 3, 4, 5])
                trig = random.choice(["cos", "sin"])
                trig_fn = "\\cos" if trig == "cos" else "\\sin"

                q_text = (
                    f"Solve \\( \\nabla^2 u = 0 \\) inside a disk of radius {R} "
                    f"with \\( u({R},\\theta) = {trig_fn}({nv}\\theta) \\)."
                )
                if R == 1:
                    ans_latex = f"u(r,\\theta) = r^{{{nv}}} {trig_fn}({nv}\\theta)"
                    ans_plain = f"u(r,theta) = r^{nv} * {trig}({nv}*theta)"
                else:
                    ans_latex = f"u(r,\\theta) = \\left(\\frac{{r}}{{{R}}}\\right)^{{{nv}}} {trig_fn}({nv}\\theta)"
                    ans_plain = f"u(r,theta) = (r/{R})^{nv} * {trig}({nv}*theta)"

            elif q_type == "heat_rod_insulated":
                kv = random.choice([1, 2, 3, 4, 5, sp.Rational(1,2)])
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi])
                nv = random.choice([1, 2, 3, 4, 5])
                lambda_n = (nv * pi / Lv)**2
                decay = sp.exp(-kv * lambda_n * t)
                mode = sp.cos(nv * pi * x / Lv)

                q_text = (
                    f"Solve \\( u_t = {sp.latex(kv)} u_{{xx}} \\) on \\( (0, {sp.latex(Lv)}) \\) "
                    f"with insulated ends and \\( u(x,0) = \\cos\\left(\\frac{{{nv}\\pi x}}{{{sp.latex(Lv)}}}\\right) \\)."
                )
                ans_latex = f"u(x,t) = {sp.latex(mode)} \\cdot {sp.latex(decay)}"
                ans_plain = f"u(x,t) = cos({nv}*pi*x/{Lv}) * exp(-{kv}*{lambda_n}*t)"

            elif q_type == "fourier_convergence":
                f_type = random.choice(["step", "sawtooth", "triangle"])
                if f_type == "step":
                    q_text = (
                        f"The Fourier sine series of the step function "
                        f"\\( f(x) = 1 \\) on \\( (0, \\pi) \\) converges to what value at \\( x = 0 \\) and \\( x = \\pi \\)? "
                        f"What does it converge to at interior points?"
                    )
                    ans_latex = (
                        "\\text{At } x=0, \\pi: \\text{ converges to } 0 \\text{ (average of limits).} "
                        "\\text{ At interior points: converges to } f(x) = 1."
                    )
                    ans_plain = "At x=0,pi: converges to 0 (average). Interior: converges to f(x)=1."
                elif f_type == "sawtooth":
                    q_text = (
                        f"The Fourier series of \\( f(x) = x \\) on \\( (-\\pi, \\pi) \\) has a jump at \\( x = \\pm\\pi \\). "
                        f"What does the series converge to at \\( x = \\pi \\)? State the relevant theorem."
                    )
                    ans_latex = (
                        "\\text{By Dirichlet's theorem: } \\frac{f(\\pi^-) + f(-\\pi^+)}{2} = \\frac{\\pi + (-\\pi)}{2} = 0."
                    )
                    ans_plain = "Dirichlet's theorem: (f(pi-) + f(-pi+))/2 = (pi + (-pi))/2 = 0."
                else:
                    q_text = (
                        f"Does the Fourier series of a continuous, piecewise smooth function on \\( [0, L] \\) "
                        f"converge uniformly? State the theorem and its conditions."
                    )
                    ans_latex = (
                        "\\text{Yes, if } f \\text{ is continuous and piecewise smooth on } [0,L] \\text{ and BCs match, "
                        "the Fourier series converges uniformly to } f(x)."
                    )
                    ans_plain = "Yes, if f is continuous and piecewise smooth and BCs match, uniform convergence holds."

            elif q_type == "maximum_principle":
                kv = random.choice([1, 2, 3, 4, 5])
                Lv = random.choice([1, 2, sp.pi])
                T_max = random.choice([1, 2, 5, 10])
                u_max = random.choice([10, 20, 50, 100])
                q_text = (
                    f"Let \\( u \\) satisfy \\( u_t = {kv} u_{{xx}} \\) on "
                    f"\\( (0,{sp.latex(Lv)}) \\times (0,{T_max}) \\). The maximum of "
                    f"\\( u \\) on the boundary data is {u_max}. "
                    f"What does the maximum principle guarantee about \\( u \\) in the interior?"
                )
                ans_latex = (
                    f"\\text{{By the maximum principle, }} \\max_{{\\overline{{\\Omega}}}} u "
                    f"\\text{{ is attained on the parabolic boundary (initial/lateral). "
                    f"Hence }} u(x,t) \\leq {u_max} \\text{{ for all interior points.}}"
                )
                ans_plain = f"Maximum principle: u(x,t) <= {u_max} in the interior. Max attained on parabolic boundary."

            elif q_type == "heat_decay_rate":
                kv = random.choice([1, 2, 3, 4, 5])
                Lv = random.choice([1, 2, sp.pi])
                lam1 = (pi / Lv)**2
                q_text = (
                    f"For \\( u_t = {kv} u_{{xx}} \\) on \\( (0, {sp.latex(Lv)}) \\) with Dirichlet BCs, "
                    f"what is the dominant decay rate as \\( t \\to \\infty \\)? "
                    f"Which mode decays slowest?"
                )
                ans_latex = (
                    f"\\text{{The }} n=1 \\text{{ mode decays slowest: }} "
                    f"e^{{-{kv} \\cdot {sp.latex(lam1)} \\cdot t}} = e^{{-{sp.latex(kv * lam1)} t}}. "
                    f"\\text{{ Decay rate}} = {sp.latex(kv * lam1)}."
                )
                ans_plain = f"n=1 mode is slowest: exp(-{kv*lam1}*t). Decay rate = {kv*lam1}"

            elif q_type == "laplace_annulus":
                R1 = random.choice([1, 2])
                R2 = random.choice([R1+1, R1+2, R1+3])
                T1 = random.choice([0, 10, 50, 100])
                T2 = random.choice([0, 10, 50, 100])
                while T1 == T2:
                    T2 = random.choice([0, 10, 50, 100])
                # Radially symmetric: u = A*ln(r) + B
                # u(R1) = T1, u(R2) = T2
                A_val = sp.Rational(T2 - T1, 1) / sp.log(sp.Rational(R2, R1))
                B_val = T1 - A_val * sp.log(R1)
                r = sp.Symbol('r', positive=True)
                sol = sp.simplify(A_val * sp.log(r) + B_val)

                q_text = (
                    f"Solve Laplace's equation \\( \\nabla^2 u = 0 \\) in the annulus "
                    f"\\( {R1} < r < {R2} \\) with \\( u({R1}) = {T1},\\; u({R2}) = {T2} \\). "
                    f"(Radially symmetric case.)"
                )
                ans_latex = f"u(r) = {sp.latex(sol)}"
                ans_plain = f"u(r) = {sol}"

            elif q_type == "heat_half_range_expansion":
                Lv = sp.pi
                nv = random.choice([1, 2, 3, 4, 5])
                # half-range cosine expansion of x on [0, pi]
                a0 = (2/pi) * sp.integrate(x_sym, (x_sym, 0, pi)) / 2
                an = compute_fourier_cosine_coeff(x_sym, pi, nv)

                q_text = (
                    f"Find the half-range Fourier cosine expansion coefficient \\( a_{{{nv}}} \\) "
                    f"for \\( f(x) = x \\) on \\( [0, \\pi] \\). Also find \\( a_0/2 \\)."
                )
                ans_latex = f"a_0/2 = {sp.latex(sp.simplify(a0))},\\; a_{{{nv}}} = {sp.latex(an)}"
                ans_plain = f"a_0/2 = {sp.simplify(a0)}, a_{nv} = {an}"

            # ==========================================================================
            #  SCHOLAR (25%)
            # ==========================================================================

            elif q_type == "schrodinger_infinite_well":
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi, sp.Rational(1,2)])
                nv = random.choice([1, 2, 3, 4, 5])
                norm = sp.sqrt(2/Lv)

                q_text = (
                    f"Find the energy eigenvalues \\( E_n \\) and normalized eigenfunctions for "
                    f"a particle in an infinite square well of width \\( {sp.latex(Lv)} \\)."
                )
                ans_latex = (
                    f"E_n = \\frac{{n^2\\pi^2\\hbar^2}}{{2m({sp.latex(Lv)})^2}},\\; "
                    f"\\psi_n = {sp.latex(norm)}\\sin\\left(\\frac{{n\\pi x}}{{{sp.latex(Lv)}}}\\right)"
                )
                ans_plain = f"E_n = n^2*pi^2*hbar^2/(2m*{Lv}^2), psi_n = sqrt(2/{Lv})*sin(n*pi*x/{Lv})"

            elif q_type == "heat_nonhomogeneous_steady":
                kv = random.choice([1, 2, 3, 4, 5])
                sv = random.choice([1, 2, 3, 4, 5, 6])
                Lv = sp.pi
                C_val = sp.Rational(sv, 2*kv) * pi
                u_s = sp.Rational(-sv, 2*kv) * x_sym**2 + C_val * x_sym
                u_s = sp.simplify(u_s)

                q_text = (
                    f"Find the steady-state solution for \\( u_t = {kv} u_{{xx}} + {sv} \\) "
                    f"on \\( (0,\\pi) \\) with \\( u(0,t)=u(\\pi,t)=0 \\)."
                )
                ans_latex = f"u_s(x) = {sp.latex(u_s)}"
                ans_plain = f"u_s(x) = {u_s}"

            elif q_type == "wave_forced_resonance":
                cv = random.choice([1, 2, 3, 4, 5])
                Lv = random.choice([1, sp.pi])
                nv = random.choice([1, 2, 3])
                omega_n = nv * pi * cv / Lv

                q_text = (
                    f"Find the resonance frequencies for \\( u_{{tt}} = {cv**2} u_{{xx}} + F_0 \\sin(\\omega t)\\sin\\left(\\frac{{{nv}\\pi x}}{{{sp.latex(Lv)}}}\\right) \\) "
                    f"on \\( [0, {sp.latex(Lv)}] \\) with fixed endpoints."
                )
                ans_latex = (
                    f"\\omega_{{n}} = \\frac{{{cv} n\\pi}}{{{sp.latex(Lv)}}},\\; "
                    f"\\text{{resonance when }} \\omega = {sp.latex(omega_n)}"
                )
                ans_plain = f"omega_n = {cv}*n*pi/{Lv}, resonance when omega = {omega_n}"

            elif q_type == "green_function_1d":
                Lv = random.choice([1, 2, 3, 4, 5, sp.pi, 2*sp.pi])
                q_text = (
                    f"Find Green's function \\( G(x,\\xi) \\) for \\( u_{{xx}} = f(x) \\) "
                    f"on \\( [0, {sp.latex(Lv)}] \\) with \\( u(0)=u({sp.latex(Lv)})=0 \\)."
                )
                ans_latex = (
                    f"G(x,\\xi) = \\begin{{cases}} "
                    f"\\frac{{x({sp.latex(Lv)}-\\xi)}}{{{sp.latex(Lv)}}} & x \\leq \\xi \\\\ "
                    f"\\frac{{\\xi({sp.latex(Lv)}-x)}}{{{sp.latex(Lv)}}} & x > \\xi \\end{{cases}}"
                )
                ans_plain = f"G(x,xi) = x*({Lv}-xi)/{Lv} for x<=xi, xi*({Lv}-x)/{Lv} for x>xi"

            elif q_type == "eigenvalue_sturm_liouville":
                bc_type = random.choice(["dirichlet", "neumann", "mixed", "periodic"])
                Lv = random.choice([1, 2, 3, sp.pi, 2*sp.pi, sp.Rational(1,2)])

                if bc_type == "dirichlet":
                    q_text = (
                        f"Solve \\( X'' + \\lambda X = 0 \\) on \\( [0, {sp.latex(Lv)}] \\) "
                        f"with \\( X(0)=X({sp.latex(Lv)})=0 \\)."
                    )
                    ans_latex = (
                        f"\\lambda_n = \\left(\\frac{{n\\pi}}{{{sp.latex(Lv)}}}\\right)^2,\\; "
                        f"X_n = \\sin\\left(\\frac{{n\\pi x}}{{{sp.latex(Lv)}}}\\right),\\; n=1,2,\\ldots"
                    )
                    ans_plain = f"lambda_n=(n*pi/{Lv})^2, X_n=sin(n*pi*x/{Lv}), n=1,2,..."
                elif bc_type == "neumann":
                    q_text = (
                        f"Solve \\( X'' + \\lambda X = 0 \\) on \\( [0, {sp.latex(Lv)}] \\) "
                        f"with \\( X'(0)=X'({sp.latex(Lv)})=0 \\)."
                    )
                    ans_latex = (
                        f"\\lambda_0=0, X_0=1;\\; "
                        f"\\lambda_n=(n\\pi/{sp.latex(Lv)})^2,\\; "
                        f"X_n=\\cos(n\\pi x/{sp.latex(Lv)}),\\; n=1,2,\\ldots"
                    )
                    ans_plain = f"lambda_0=0,X_0=1; lambda_n=(n*pi/{Lv})^2, X_n=cos(n*pi*x/{Lv}), n=1,2,..."
                elif bc_type == "mixed":
                    q_text = (
                        f"Solve \\( X'' + \\lambda X = 0 \\) on \\( [0, {sp.latex(Lv)}] \\) "
                        f"with \\( X(0)=0,\\; X'({sp.latex(Lv)})=0 \\)."
                    )
                    ans_latex = (
                        f"\\lambda_n = \\left(\\frac{{(2n-1)\\pi}}{{2\\cdot{sp.latex(Lv)}}}\\right)^2,\\; "
                        f"X_n = \\sin\\left(\\frac{{(2n-1)\\pi x}}{{2\\cdot{sp.latex(Lv)}}}\\right),\\; n=1,2,\\ldots"
                    )
                    ans_plain = f"lambda_n=((2n-1)*pi/(2*{Lv}))^2, X_n=sin((2n-1)*pi*x/(2*{Lv})), n=1,2,..."
                else:  # periodic
                    q_text = (
                        f"Solve \\( X'' + \\lambda X = 0 \\) on \\( [0, {sp.latex(Lv)}] \\) "
                        f"with periodic BCs \\( X(0)=X({sp.latex(Lv)}),\\; X'(0)=X'({sp.latex(Lv)}) \\)."
                    )
                    ans_latex = (
                        f"\\lambda_0=0, X_0=1;\\; "
                        f"\\lambda_n=(2n\\pi/{sp.latex(Lv)})^2,\\; "
                        f"X_n=\\cos(2n\\pi x/{sp.latex(Lv)})\\text{{ and }}\\sin(2n\\pi x/{sp.latex(Lv)}),\\; n=1,2,\\ldots"
                    )
                    ans_plain = f"lambda_0=0; lambda_n=(2n*pi/{Lv})^2, X_n=cos and sin(2n*pi*x/{Lv}), n=1,2,..."

            elif q_type == "stability_cfl":
                scheme = random.choice(["heat_explicit", "wave_explicit", "heat_implicit"])
                if scheme == "heat_explicit":
                    kv = random.choice([1, 2, 3, 4, 5, 0.5, 0.25, 6, 8, 10])
                    dx = random.choice([0.01, 0.02, 0.05, 0.1, 0.2, 0.25, 0.5])
                    dt_stable = round(dx**2 / (2 * kv), 8)
                    dt_test = round(random.choice([0.3, 0.5, 0.7, 0.8, 1.0, 1.2, 1.5, 2.0]) * dt_stable, 8)
                    r = round(kv * dt_test / dx**2, 4)
                    stable = "Stable" if r <= 0.5 else "Unstable"
                    q_text = (
                        f"For explicit FTCS on \\( u_t = {kv} u_{{xx}} \\) with "
                        f"\\( \\Delta x = {dx},\\; \\Delta t = {dt_test} \\): "
                        f"compute \\( r = k\\Delta t/\\Delta x^2 \\) and check stability."
                    )
                    ans_latex = f"r = {r}. \\; \\text{{{stable}}} \\; (r \\leq 0.5 \\text{{ required}})"
                    ans_plain = f"r = {r}. {stable} (r <= 0.5 required)"
                elif scheme == "wave_explicit":
                    cv = random.choice([1, 2, 3, 4, 5, 0.5, 1.5])
                    dx = random.choice([0.01, 0.02, 0.05, 0.1, 0.2, 0.25, 0.5])
                    dt_stable = round(dx / cv, 8)
                    dt_test = round(random.choice([0.3, 0.5, 0.7, 0.8, 1.0, 1.2, 1.5, 2.0]) * dt_stable, 8)
                    C_num = round(cv * dt_test / dx, 4)
                    stable = "Stable" if C_num <= 1.0 else "Unstable"
                    q_text = (
                        f"For explicit scheme on \\( u_{{tt}} = {cv**2} u_{{xx}} \\) with "
                        f"\\( \\Delta x = {dx},\\; \\Delta t = {dt_test} \\): "
                        f"compute Courant number \\( C = c\\Delta t/\\Delta x \\)."
                    )
                    ans_latex = f"C = {C_num}. \\; \\text{{{stable}}} \\; (C \\leq 1 \\text{{ required by CFL}})"
                    ans_plain = f"C = {C_num}. {stable} (C <= 1 required)"
                else:  # heat_implicit
                    kv = random.choice([1, 2, 3, 5, 10])
                    dx = random.choice([0.01, 0.05, 0.1, 0.2])
                    dt = random.choice([0.001, 0.01, 0.05, 0.1])
                    r = round(kv * dt / dx**2, 4)
                    q_text = (
                        f"For the implicit (backward Euler) scheme on \\( u_t = {kv} u_{{xx}} \\) with "
                        f"\\( \\Delta x = {dx},\\; \\Delta t = {dt} \\): "
                        f"compute \\( r \\) and state if the scheme is stable."
                    )
                    ans_latex = f"r = {r}. \\; \\text{{Unconditionally stable (implicit scheme, stable for all }} r > 0\\text{{).}}"
                    ans_plain = f"r = {r}. Unconditionally stable (implicit scheme, stable for all r > 0)."

            elif q_type == "poisson_disk_radial":
                R = random.choice([1, 2, 3, 4, 5])
                nv = random.choice([0, 1, 2])
                if nv == 0:
                    sol_r = sp.Rational(c1, 4) * (sp.Symbol('r')**2 - R**2)
                    q_text = (
                        f"Solve \\( \\nabla^2 u = {c1} \\) in a disk of radius {R} "
                        f"with \\( u({R})=0 \\). (Radially symmetric.)"
                    )
                    ans_latex = f"u(r) = {sp.latex(sol_r)}"
                    ans_plain = f"u(r) = {sol_r}"
                else:
                    q_text = (
                        f"State the mean value property: if \\( \\nabla^2 u = 0 \\) in a disk of radius {R}, "
                        f"express \\( u(0,0) \\) as a boundary integral."
                    )
                    ans_latex = f"u(0,0) = \\frac{{1}}{{2\\pi}}\\int_0^{{2\\pi}} u({R},\\theta)\\,d\\theta"
                    ans_plain = f"u(0,0) = (1/(2*pi))*integral(u({R},theta), 0..2*pi)"

            elif q_type == "duhamel_principle":
                kv = random.choice([1, 2, 3])
                Lv = sp.pi
                source_type = random.choice(["general", "specific"])
                if source_type == "general":
                    q_text = (
                        f"State Duhamel's principle for \\( u_t = {kv} u_{{xx}} + F(x,t) \\) "
                        f"on \\( (0,\\pi) \\) with \\( u(0,t)=u(\\pi,t)=0,\\; u(x,0)=0 \\). "
                        f"Express the solution as an integral involving the homogeneous solution operator."
                    )
                    ans_latex = (
                        f"u(x,t) = \\int_0^t S(t-\\tau) F(x,\\tau)\\,d\\tau "
                        f"= \\int_0^t \\sum_{{n=1}}^{{\\infty}} F_n(\\tau) \\sin(nx) e^{{-{kv}n^2(t-\\tau)}} d\\tau"
                    )
                    ans_plain = f"u(x,t) = integral_0^t sum(F_n(tau)*sin(nx)*exp(-{kv}*n^2*(t-tau)), n=1..inf) dtau"
                else:
                    sv = random.choice([1, 2, 3])
                    nv = random.choice([1, 2, 3])
                    q_text = (
                        f"Using Duhamel's principle, solve \\( u_t = {kv} u_{{xx}} + {sv}\\sin({nv}x) \\) "
                        f"on \\( (0,\\pi) \\) with \\( u(0,t)=u(\\pi,t)=0,\\; u(x,0)=0 \\)."
                    )
                    coeff = sp.Rational(sv, kv * nv**2)
                    ans_latex = (
                        f"u(x,t) = {sp.latex(coeff)}\\sin({nv}x)\\left(1 - e^{{-{kv*nv**2}t}}\\right)"
                    )
                    ans_plain = f"u(x,t) = {coeff}*sin({nv}x)*(1-exp(-{kv*nv**2}t))"

            elif q_type == "wellposedness":
                pde_choices = [
                    ("heat", f"u_t = {abs(c1)} u_{{xx}}", "forward heat equation", True,
                     "Hadamard well-posed: existence (Fourier series), uniqueness (energy method), continuous dependence (maximum principle)"),
                    ("backward_heat", f"u_t = -{abs(c1)} u_{{xx}}", "backward heat equation", False,
                     "Ill-posed: solutions exist but continuous dependence fails. Small perturbations in data cause exponential growth."),
                    ("wave", f"u_{{tt}} = {abs(c1)} u_{{xx}}", "wave equation", True,
                     "Hadamard well-posed: d'Alembert gives existence and uniqueness; energy conservation gives stability."),
                    ("laplace", f"u_{{xx}} + u_{{yy}} = 0", "Laplace equation with Dirichlet BCs", True,
                     "Well-posed for Dirichlet BCs on bounded domains: existence, uniqueness (maximum principle), continuous dependence."),
                ]
                pde = random.choice(pde_choices)
                wp_str = "well-posed" if pde[3] else "ill-posed"
                q_text = (
                    f"Is the {pde[2]} \\( {pde[1]} \\) well-posed in the sense of Hadamard? "
                    f"State the three conditions and explain."
                )
                wp_label = "\\textbf{Well-posed.}" if pde[3] else "\\textbf{Ill-posed.}"
                ans_latex = f"{wp_label} \\; \\text{{{pde[4]}}}"
                ans_plain = f"{'Well-posed' if pde[3] else 'Ill-posed'}. {pde[4]}"

            elif q_type == "wave_reflection_transmission":
                c1_val = random.choice([1, 2, 3, 4])
                c2_val = random.choice([1, 2, 3, 4])
                while c1_val == c2_val:
                    c2_val = random.choice([1, 2, 3, 4])
                R = sp.Rational(c2_val - c1_val, c2_val + c1_val)
                T_coeff = sp.Rational(2 * c2_val, c2_val + c1_val)
                q_text = (
                    f"A wave travels from medium 1 (speed \\( c_1 = {c1_val} \\)) into medium 2 "
                    f"(speed \\( c_2 = {c2_val} \\)). Find the reflection coefficient \\( R \\) "
                    f"and transmission coefficient \\( T \\)."
                )
                ans_latex = (
                    f"R = \\frac{{c_2 - c_1}}{{c_2 + c_1}} = {sp.latex(R)},\\quad "
                    f"T = \\frac{{2c_2}}{{c_2 + c_1}} = {sp.latex(T_coeff)}"
                )
                ans_plain = f"R = (c2-c1)/(c2+c1) = {R}, T = 2*c2/(c2+c1) = {T_coeff}"

            elif q_type == "heat_nonhomogeneous_duhamel":
                kv = random.choice([1, 2, 3])
                nv = random.choice([1, 2, 3])
                amp = random.choice([1, 2, 3, 4, 5])
                Lv = sp.pi
                lam = kv * nv**2
                coeff = sp.Rational(amp, lam)

                q_text = (
                    f"Solve \\( u_t = {kv} u_{{xx}} + {amp}\\sin({nv}x) \\) on \\( (0,\\pi) \\) "
                    f"with \\( u(0,t)=u(\\pi,t)=0 \\) and \\( u(x,0) = 0 \\)."
                )
                ans_latex = (
                    f"u(x,t) = {sp.latex(coeff)}\\sin({nv}x)(1 - e^{{-{lam}t}})"
                )
                ans_plain = f"u(x,t) = {coeff}*sin({nv}x)*(1-exp(-{lam}*t))"

            elif q_type == "laplace_3d_separation":
                Lx = random.choice([1, sp.pi])
                Ly = random.choice([1, sp.pi])
                n1 = random.choice([1, 2, 3])
                n2 = random.choice([1, 2, 3])
                gamma = sp.sqrt((n1*pi/Lx)**2 + (n2*pi/Ly)**2)

                q_text = (
                    f"For the 3D Laplace equation \\( u_{{xx}} + u_{{yy}} + u_{{zz}} = 0 \\) on "
                    f"\\( (0,{sp.latex(Lx)})\\times(0,{sp.latex(Ly)})\\times(0,H) \\) with "
                    f"\\( u=0 \\) on the lateral sides, find the (m={n1}, n={n2}) mode in z."
                )
                ans_latex = (
                    f"u_{{m,n}} = \\sin\\left(\\frac{{{n1}\\pi x}}{{{sp.latex(Lx)}}}\\right)"
                    f"\\sin\\left(\\frac{{{n2}\\pi y}}{{{sp.latex(Ly)}}}\\right)"
                    f"\\left(A\\cosh {sp.latex(gamma)} z + B\\sinh {sp.latex(gamma)} z\\right)"
                )
                ans_plain = f"u = sin({n1}*pi*x/{Lx})*sin({n2}*pi*y/{Ly})*(A*cosh({gamma}z)+B*sinh({gamma}z))"

            elif q_type == "uniqueness_energy_argument":
                eq_type = random.choice(["heat", "wave"])
                kv = random.choice([1, 2, 3])
                Lv = random.choice([1, sp.pi])
                if eq_type == "heat":
                    q_text = (
                        f"Prove uniqueness for \\( u_t = {kv} u_{{xx}} \\) on \\( (0,{sp.latex(Lv)}) \\) "
                        f"with Dirichlet BCs using the energy method. "
                        f"Define \\( E(t) = \\int_0^{{{sp.latex(Lv)}}} w^2 dx \\) where \\( w = u_1 - u_2 \\)."
                    )
                    ans_latex = (
                        f"\\frac{{dE}}{{dt}} = 2\\int w \\cdot w_t\\,dx = 2{kv}\\int w\\cdot w_{{xx}}\\,dx "
                        f"= -2{kv}\\int w_x^2\\,dx \\leq 0. \\; E(0)=0 \\Rightarrow E(t)=0 \\Rightarrow w=0."
                    )
                    ans_plain = f"dE/dt = -2*{kv}*integral(w_x^2) <= 0. E(0)=0 => E(t)=0 => w=0, so unique."
                else:
                    q_text = (
                        f"Prove uniqueness for \\( u_{{tt}} = {kv**2} u_{{xx}} \\) on \\( (0,{sp.latex(Lv)}) \\) "
                        f"with fixed endpoints using energy conservation. "
                        f"Let \\( w = u_1 - u_2 \\) with zero IC and BCs."
                    )
                    ans_latex = (
                        f"E(t) = \\frac{{1}}{{2}}\\int(w_t^2 + {kv**2} w_x^2)dx = \\text{{const}} = E(0) = 0 "
                        f"\\Rightarrow w_t = w_x = 0 \\Rightarrow w = 0."
                    )
                    ans_plain = f"E(t)=(1/2)*integral(w_t^2+{kv**2}*w_x^2)=const=E(0)=0 => w=0, unique."

            elif q_type == "biharmonic_decompose":
                Lv = random.choice([1, 2, sp.pi])
                q_text = (
                    f"Decompose \\( \\nabla^4 u = f(x,y) \\) on a domain \\( \\Omega \\) "
                    f"into a system of two second-order equations. "
                    f"What are the auxiliary variable and the coupled system?"
                )
                ans_latex = (
                    "\\text{Let } v = \\nabla^2 u. \\text{ Then: } "
                    "\\nabla^2 v = f(x,y) \\text{ and } \\nabla^2 u = v. "
                    "\\text{ Two coupled Poisson equations.}"
                )
                ans_plain = "Let v = nabla^2(u). Then nabla^2(v) = f and nabla^2(u) = v. Two coupled Poisson equations."

            # ------ guard ------
            if not ans_latex or not ans_plain:
                continue

            sig = q_text + ans_plain
            if sig in seen:
                continue
            seen.add(sig)

            questions.append({
                "id": len(questions) + 1,
                "type": q_type,
                "difficulty": difficulty,
                "question_text": q_text,
                "answer_latex": ans_latex,
                "answer_plain": ans_plain
            })

            if len(questions) % 200 == 0:
                print(f"  Generated {len(questions)} / {num_questions} ...")

        except Exception as e:
            pass

    return questions


if __name__ == "__main__":
    print("Generating 2000 PDE questions (max math coverage)...")
    questions = generate_pde_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/pde.json"
    with open(output_file, "w") as f_out:
        json.dump({
            "topic": "Partial Differential Equations",
            "description": "Comprehensive PDE Practice Worksheet. Covers Heat, Wave, Laplace, Poisson, Transport, Schrodinger equations. Separation of variables, Fourier sine/cosine series, eigenvalue problems, Green's functions, d'Alembert, Duhamel's principle, maximum principle, CFL stability, well-posedness, superposition, and more.",
            "questions": questions
        }, f_out, separators=(',', ':'))

    from collections import Counter
    types = Counter(q["type"] for q in questions)
    diffs = Counter(q["difficulty"] for q in questions)
    print(f"\nGenerated {len(questions)} PDE problems → {output_file}")
    print(f"\nBy type ({len(types)} types):")
    for t, c in types.most_common():
        print(f"  {t}: {c}")
    print(f"\nBy difficulty:")
    for d, c in diffs.most_common():
        print(f"  {d}: {c}")
