import sympy as sp
import json
import random
import os

x, t, s = sp.symbols('x t s')
f = sp.Function('y')(x)
func_x = sp.Function('x')(t)
func_y = sp.Function('y')(t)

def safe_dsolve(eq, func, ics=None):
    if ics:
        return sp.dsolve(eq, func, ics=ics)
    return sp.dsolve(eq, func)

def safe_dsolve_system(eqs):
    return sp.dsolve(eqs)

def generate_ode_questions(num_questions):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = num_questions * 10
    
    types = [
        "separable", 
        "first_order_linear", 
        "second_order_homogeneous", 
        "second_order_nonhomogeneous",
        "initial_value_problem",
        "bernoulli",
        "cauchy_euler",
        "exact_equation",
        "laplace",
        "systems",
        "euler_method",
        "power_series",
        "autonomous_equilibrium",
        "homogeneous_substitution",
        "third_order_homogeneous",
        "fourth_order_beam"
    ]
    
    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1
        
        c1 = random.choice([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
        c2 = random.choice([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
        c3 = random.choice([1, 2, 3, 4, 5])
        c4 = random.choice([-4, -3, -2, -1, 1, 2, 3, 4])
        
        diff_val = random.random()
        if diff_val < 0.25:
            difficulty = "basic"
            q_type = random.choice(["separable", "autonomous_equilibrium"])
        elif diff_val < 0.50:
            difficulty = "medium"
            q_type = random.choice(["first_order_linear", "second_order_homogeneous", "initial_value_problem"])
        elif diff_val < 0.75:
            difficulty = "hard"
            q_type = random.choice(["second_order_nonhomogeneous", "exact_equation", "euler_method", "homogeneous_substitution"])
        else:
            difficulty = "scholar"
            q_type = random.choice(["laplace", "systems", "power_series", "bernoulli", "cauchy_euler", "third_order_homogeneous", "fourth_order_beam"])
        
        q_text = ""
        ans_latex = ""
        ans_plain = ""
        
        try:
            if q_type == "laplace":
                difficulty = "scholar"
                funcs = [c1*t**c3, c1*sp.exp(c2*t), c1*sp.sin(c2*t), c1*t*sp.exp(c2*t)]
                expr = random.choice(funcs)
                ans = sp.laplace_transform(expr, t, s, noconds=True)
                q_text = f"Find the Laplace Transform \\( \\mathscr{{L}}\\{{ {sp.latex(expr)} \\}} \\)."
                ans_latex = sp.latex(ans)
                ans_plain = str(ans)
                
            elif q_type == "euler_method":
                difficulty = "hard"
                x0 = random.choice([0, 1])
                y0 = random.choice([-1, 1, 2])
                h = random.choice([0.1, 0.2, 0.5])
                # y1 = y0 + h * f(x0, y0)
                y1 = y0 + h * (c1*x0 + c2*y0)
                q_text = f"Use Euler's Method with a step size of \\( h = {h} \\) to approximate \\( y({round(x0+h, 1)}) \\) given the initial value problem \\( y' = {c1}x {'+' if c2>0 else ''} {c2}y, \\; y({x0}) = {y0} \\)."
                ans_latex = sp.latex(round(y1, 2))
                ans_plain = str(round(y1, 2))
            
            elif q_type == "exact_equation":
                difficulty = "hard"
                # F(x,y) = a x^2 y + b x y^2 + c x + d y 
                a = random.choice([-2, -1, 1, 2])
                b = random.choice([-2, -1, 1, 2])
                c = random.choice([-2, 1, 2])
                d = random.choice([-2, 1, 2])
                M = a*2*x*f + b*f**2 + c
                N = a*x**2 + b*2*x*f + d
                y_sym = sp.Symbol('y')
                F_expr = a*x**2 * y_sym + b*x * y_sym**2 + c*x + d*y_sym
                q_text = f"Solve the exact differential equation: \\( ({sp.latex(M.subs(f, y_sym))})dx + ({sp.latex(N.subs(f, y_sym))})dy = 0 \\)."
                ans_latex = sp.latex(F_expr) + " = C"
                ans_plain = str(F_expr) + " = C"
                
            elif q_type == "power_series":
                difficulty = "scholar"
                # y'' + a y' + b y = 0
                a = random.choice([-2, 1, 2])
                b = random.choice([-2, 1, 2])
                y0 = random.choice([1, 2])
                y1 = random.choice([-1, 1])
                y2_fact2 = -a*y1 - b*y0
                q_text = f"Find the first three non-zero terms of the Maclaurin series solution (power series centered at \\( x=0 \\)) for the initial value problem: \\( y'' {'+' if a>0 else ''} {a}y' {'+' if b>0 else ''} {b}y = 0 \\) with \\( y(0)={y0}, \\; y'(0)={y1} \\)."
                expr = y0 + y1*x + sp.Rational(y2_fact2, 2)*x**2
                ans_latex = sp.latex(expr)
                ans_plain = str(expr)
                
            elif q_type == "systems":
                difficulty = "scholar"
                a = random.choice([-2, 1, 2])
                b = random.choice([-2, 1, 2])
                c = random.choice([-2, 1, 2])
                d = random.choice([-2, 1, 2])
                # Ensure it's not parallel/degenerate and has Real Eigenvalues to prevent SymPy freezing
                if a*d == b*c or (a-d)**2 + 4*b*c <= 0:
                    continue
                eqs = [sp.Eq(func_x.diff(t), a*func_x + b*func_y), sp.Eq(func_y.diff(t), c*func_x + d*func_y)]
                sol = safe_dsolve_system(eqs)
                q_text = f"Solve the linear system of ordinary differential equations: \\( \\frac{{dx}}{{dt}} = {a}x {'+' if b>0 else ''} {b}y \\) and \\( \\frac{{dy}}{{dt}} = {c}x {'+' if d>0 else ''} {d}y \\)."
                ans_latex = sp.latex(sol).replace(r"x{\left(t \right)}", "x(t)").replace(r"y{\left(t \right)}", "y(t)")
                ans_plain = str(sol)

            elif q_type == "autonomous_equilibrium":
                difficulty = "basic"
                # y' = A(y - r1)(y - r2) 
                # Determine stability
                r1 = random.choice([-3, -2, -1, 0, 1])
                r2 = random.choice([r1+1, r1+2, r1+3, r1+4])
                A = random.choice([-2, -1, 1, 2])
                y_sym = sp.Symbol('y')
                expr = A * (y_sym - r1) * (y_sym - r2)
                
                # Stability logic for quadratics:
                if A < 0:
                    # Opens down: y < r1 (negative), r1 < y < r2 (positive), y > r2 (negative)
                    # r1: arrows go away from it (unstable)
                    # r2: arrows point towards it (stable)
                    ans_str = f"y = {r1} (Unstable), \\quad y = {r2} (Stable)"
                    ans_plain_str = f"y={r1} (Unstable), y={r2} (Stable)"
                else:
                    # Opens up
                    ans_str = f"y = {r1} (Stable), \\quad y = {r2} (Unstable)"
                    ans_plain_str = f"y={r1} (Stable), y={r2} (Unstable)"
                    
                q_text = f"Consider the autonomous differential equation: \\( \\frac{{dy}}{{dt}} = {sp.latex(expr.expand())} \\). Identify all equilibrium solutions and classify their stability (Stable, Unstable, or Semi-Stable)."
                ans_latex = ans_str
                ans_plain = ans_plain_str

            else:
                # Standard symp dsolve evaluations
                ics = None
                if q_type == "separable":
                    rhs = random.choice([c1 * f * x, c1 * f / x if c2 != 0 else c1 * f, sp.exp(c2 * x) / f, c1 * x**2 * f**2, (c1*x+c2)*sp.exp(f)])
                    eq = sp.Eq(f.diff(x), rhs)
                elif q_type == "first_order_linear":
                    p_type = random.choice([1, 2, 3])
                    if p_type == 1:
                        P, Q = c1, random.choice([c2*sp.exp(c4*x), c2*x**2 + c3, c2*sp.sin(c3*x)])
                    elif p_type == 2:
                        P, Q = c1/x, random.choice([c2*x**c3, c2*x**2 + c4, c3*x])
                    else:
                        P, Q = c1*x, random.choice([c2*x*sp.exp(-c1*x**2/2), c3*x**3*sp.exp(-c1*x**2/2)])
                    eq = sp.Eq(f.diff(x) + P*f, Q)
                elif q_type == "second_order_homogeneous":
                    r1 = random.choice([-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5])
                    r2 = random.choice([-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5])
                    b = -(r1 + r2)
                    c = r1 * r2
                    eq = sp.Eq(f.diff(x, 2) + b*f.diff(x) + c*f, 0)
                elif q_type == "second_order_nonhomogeneous":
                    r1, r2 = random.choice([1, 2, 3]), random.choice([-1, -2, -3])
                    b, c_val = -(r1+r2), r1*r2
                    Q = random.choice([c1*x**2 + c2, c1*sp.exp(c4*x), c2*sp.sin(x)])
                    eq = sp.Eq(f.diff(x, 2) + b*f.diff(x) + c_val*f, Q)
                elif q_type == "initial_value_problem":
                    P = random.choice([c1, c1*x**c3])
                    Q = random.choice([c2, c2*x])
                    eq = sp.Eq(f.diff(x) + P*f, Q)
                    ics_x = 0
                    ics_y = random.choice([-4, -3, -2, -1, 0, 1, 2, 3, 4])
                    ics = {f.subs(x, ics_x): ics_y}
                elif q_type == "bernoulli":
                    n = random.choice([2, 3, -1, -2])
                    P = random.choice([c1, c1/x if c1!=0 else 1])
                    Q = random.choice([c2, c2*x])
                    eq = sp.Eq(f.diff(x) + P*f, Q*f**n)
                elif q_type == "cauchy_euler":
                    r1 = random.choice([-4, -3, -2, -1, 1, 2, 3, 4])
                    r2 = random.choice([-4, -3, -2, -1, 1, 2, 3, 4])
                    b = -(r1 + r2) + 1
                    c_val = r1 * r2
                    eq = sp.Eq(x**2 * f.diff(x, 2) + b * x * f.diff(x) + c_val * f, 0)
                elif q_type == "homogeneous_substitution":
                    eq = sp.Eq(f.diff(x), (f/x) + c1*(f/x)**random.choice([2, 3]))
                elif q_type == "third_order_homogeneous":
                    r1, r2, r3 = random.choice([-3, -2, -1, 1, 2, 3]), random.choice([-3, -2, -1, 1, 2, 3]), random.choice([-3, -2, -1, 1, 2, 3])
                    A = -(r1 + r2 + r3)
                    B = (r1*r2 + r2*r3 + r1*r3)
                    C = -(r1 * r2 * r3)
                    eq = sp.Eq(f.diff(x, 3) + A*f.diff(x, 2) + B*f.diff(x) + C*f, 0)
                elif q_type == "fourth_order_beam":
                    EI = random.choice([1, 2, c1]) if c1 > 0 else 1
                    q_x = random.choice([c1*x**2 + c2*x, c3*x, c1*sp.sin(x)])
                    eq = sp.Eq(EI * f.diff(x, 4), q_x)

                sol = safe_dsolve(eq, f, ics=ics)
                    
                if isinstance(sol, list):
                    sol = sol[0]
                if not sol or sol.rhs.has(sp.Integral) or getattr(sol.rhs, 'has', lambda x: False)(sp.zoo) or getattr(sol.rhs, 'has', lambda x: False)(sp.nan):
                    continue
                    
                eq_latex = sp.latex(eq).replace(r"y{\left(x \right)}", "y").replace(r"\frac{d^{4}}{d x^{4}} y", r"\frac{d^4 y}{dx^4}").replace(r"\frac{d^{3}}{d x^{3}} y", r"\frac{d^3 y}{dx^3}").replace(r"\frac{d^{2}}{d x^{2}} y", r"\frac{d^2 y}{dx^2}").replace(r"\frac{d}{d x} y", r"\frac{dy}{dx}")
                ans_latex = sp.latex(sol).replace(r"y{\left(x \right)}", "y")
                ans_plain = str(sol).replace("y(x)", "y")
                
                if q_type == "initial_value_problem":
                    q_text = f"Solve the Initial Value Problem: \\( {eq_latex} \\) subject to \\( y({ics_x})={ics_y} \\)."
                else:
                    q_text = f"Find the general solution to the differential equation: \\( {eq_latex} \\)."
                    
            if not ans_latex or not ans_plain:
                continue
                
            sig = q_text + ans_plain
            if sig in seen: continue
            seen.add(sig)
            
            questions.append({
                "id": len(questions) + 1,
                "type": q_type,
                "difficulty": difficulty,
                "question_text": q_text,
                "answer_latex": ans_latex,
                "answer_plain": ans_plain
            })
            
            if len(questions) % 100 == 0:
                print(f"Generated {len(questions)} ODE questions safely...")
                
        except Exception as e:
            pass

    return questions

if __name__ == "__main__":
    print("Generating 2000 Ultimate ODE questions...")
    questions = generate_ode_questions(2000)
    
    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)
    
    output_file = f"{output_dir}/ode.json"
    with open(output_file, "w") as f_out:
         json.dump({
             "topic": "Ordinary Differential Equations",
             "description": "Comprehensive Practice Worksheet Database for ODEs. Includes Exact Equations, Laplace Transforms, Euler's Method, Power Series, Euler-Cauchy, Bernoulli, Homogeneous Substitutions, and Systems.",
             "questions": questions
         }, f_out, separators=(',', ':'))
         
    print(f"Generated {len(questions)} ODE problems in {output_file}")
