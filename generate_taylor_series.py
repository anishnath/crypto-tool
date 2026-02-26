import sympy as sp
import json
import random
import os

x, t = sp.symbols('x t')

def generate_random_function(difficulty, question_type="expansion"):
    c1 = random.choice([-3, -2, -1, 1, 2, 3])
    c2 = random.choice([-2, -1, 1, 2, 3])
    c3 = random.choice([1, 2, 3, 4]) 
    c4 = random.choice([0, 1, 2])
    c5 = random.choice([0, 1])
    
    a = 0
    n = 4
    
    if question_type == "binomial":
        # General Binomial Series (1 + x)^k where k is rational or negative integer
        p = random.choice([-3, -2, -1, 1, 2, 3, 5])
        q = random.choice([2, 3, 4]) if random.choice([True, False]) else 1
        while p == q: p += 1
        k = sp.Rational(p, q)
        f = c1 * (c3 + c2 * x)**k
        a = 0
        n = random.randint(3, 5)
        
    elif question_type == "limit":
        # Limits using Taylor Series (0/0 indeterminate forms)
        # We need a function that evaluates to 0 at the limit point (a=0)
        c6 = random.choice([2, 3, 4, 5])
        funcs = [
            (sp.sin(c2*x) - c2*x) / x**3,
            (sp.exp(c2*x) - 1 - c2*x) / x**2,
            (sp.cos(c2*x) - 1 + (c2**2 * x**2)/2) / x**4,
            ((sp.ln(1 + c2*x) - c2*x) / x**2) if c2 != 0 else sp.sin(x)/x,
            (sp.sin(x) - x + x**3/6) / x**5
        ]
        f = random.choice(funcs)
        a = 0
        n = 0 # Not used for limits
        
    elif question_type == "error_bound":
        # Lagrange Error Bound: Remainder for e^x, sin(x), cos(x)
        funcs = [sp.exp(x), sp.sin(x), sp.cos(x), sp.exp(-x)]
        f = random.choice(funcs)
        a = 0
        n = random.randint(2, 4)
        
    elif question_type == "integral_approx":
        # Approximating definite integrals using Taylor Polynomials
        funcs = [
            sp.exp(-x**2),
            sp.sin(x)/x,
            sp.cos(x**2),
            sp.sin(x**2),
            (sp.exp(x) - 1)/x,
            sp.ln(1 + x)/x
        ]
        f = random.choice(funcs)
        a = 0
        n = random.randint(3, 5)
        
    elif question_type == "nth_derivative":
        # Find the Nth derivative at x=0 without taking N derivatives
        # (Using the fact that f^(n)(0) = n! * c_n)
        p = random.choice([2, 3, 4])
        exponent = random.randint(5, 12)
        funcs = [
            (1 + c2 * x**p)**exponent,
            sp.exp(c2 * x**p),
            sp.sin(c2 * x**p),
            sp.cos(c2 * x**p),
            sp.ln(1 + c2 * x**p)
        ]
        f = random.choice(funcs)
        a = 0
        # Choose a derivative order n such that the coefficient represents a non-zero term
        # For sin(x^p), powers are p, 3p, 5p... so pick varying multiples
        if f.has(sp.sin):
            n = p * random.choice([1, 3, 5, 7])
        elif f.has(sp.cos):
            n = p * random.choice([2, 4, 6])
        else:
            n = p * random.randint(2, 6)
        
    elif difficulty == "basic":
        funcs = [
            c1 * sp.exp(c2 * x),
            c1 * sp.sin(c2 * x),
            c1 * sp.cos(c2 * x),
            c1 / (c3 - c2 * x),
            sp.ln(c3 + c2 * x),
            sp.sqrt(c3 + c2 * x),
            c1 * x**2 + c2 * x + c3,
            c1 * x**3 + c4 * x**2 + c2 * x + c5
        ]
        f = random.choice(funcs)
        if f.is_polynomial():
            a = random.choice([1, -1, 2, -2, 3])
            n = 5
        else:
            a = random.choice([0, 0, 0, 0, 1, -1])
            n = random.randint(3, 5)
            
    elif difficulty == "medium":
        funcs = [
            c1 * x * sp.exp(c2 * x),
            c1 * sp.exp(-x**2),
            c1 * sp.sin(x**2),
            c1 * x**2 * sp.cos(c2 * x),
            c1 * sp.ln(c3 - c2 * x),
            c1 * sp.sinh(c2 * x),
            c1 * sp.cosh(c2 * x),
            c1 / ((c3 - x)**2),
            x**4 + c1 * x**3 + c2 * x**2 + c3 * x - c4,
            c1 * x**5 + c2 * x**3 + c3 * x
        ]
        f = random.choice(funcs)
        if f.is_polynomial():
            a = random.choice([1, -1, 2, -2])
            n = 6
        else:
            a = random.choice([0, 0, 1, -1, 2, -2])
            n = random.randint(4, 6)
            
    elif difficulty == "hard":
        funcs = [
            c1 * sp.exp(c2 * x) * sp.sin(x),
            c1 * sp.exp(c2 * x) * sp.cos(x),
            c1 * sp.tan(x),
            c1 / sp.cos(x),
            c1 * x * sp.tan(x),
            c1 * sp.atan(x),
            c1 * sp.asin(x),
            sp.ln(c3 + c2 * x**2),
            sp.ln(sp.cos(x))
        ]
        f = random.choice(funcs)
        if f in [c1 * sp.tan(x), c1 / sp.cos(x), c1 * x * sp.tan(x), sp.ln(sp.cos(x))]:
            a = random.choice([0, sp.pi/4, sp.pi/3, sp.pi/6])
        elif f in [c1 * sp.exp(c2 * x) * sp.sin(x), c1 * sp.exp(c2 * x) * sp.cos(x)]:
            a = random.choice([0, sp.pi/4, sp.pi/2, sp.pi])
        else:
            a = random.choice([0, 1, -1, 2]) 
        n = random.randint(4, 6)
        
    else: # Scholar
        funcs = [
            sp.exp(sp.sin(x)),
            sp.sin(sp.sin(x)),
            sp.cos(sp.sin(x)),
            sp.ln(1 + sp.exp(x)),
            sp.sqrt(sp.cos(x)),
            sp.exp(c1*x) / (1 - x),
            1 / (1 - x - x**2),
            (c1 + c2*x) / (1 + x + x**2),
            sp.integrate(sp.sin(t)/t, (t, 0, x)),
            sp.integrate(sp.exp(-t**2), (t, 0, x)),
            sp.integrate(sp.cos(t**2), (t, 0, x)),
            x**x, 
            sp.atanh(x),
            sp.asinh(x),
            sp.exp(x) * sp.ln(1 + x),
            (sp.sin(x) / x) if x != 0 else 1
        ]
        f = random.choice(funcs)
        if f == x**x:
            a = random.choice([1, 2])
        elif f in [sp.sqrt(sp.cos(x)), sp.ln(1 + sp.exp(x)), sp.atanh(x), sp.asinh(x)]:
            a = 0
        elif f.has(sp.Integral):
            a = 0
        else:
            a = random.choice([0, 1, -1, sp.pi/4])
        n = random.randint(4, 7)
        if f == sp.exp(sp.sin(x)) or f == sp.cos(sp.sin(x)):
             n = random.randint(3, 5)
             
    return f, a, n

def get_radius_of_convergence(f, a):
    """Attempt to find the radius of convergence by finding the distance to the nearest singularity in the complex plane."""
    try:
        # For standard functions, we can deduce it
        if f.is_polynomial(): return sp.oo
        if f.has(sp.exp, sp.sin, sp.cos, sp.sinh, sp.cosh) and not f.has(sp.ln, sp.tan, sp.asin, sp.acos, sp.atan, 1/x): 
            return sp.oo
        
        # Try to find singularities (poles)
        singularities = sp.solve(1/f, x)
        if f.has(sp.ln):
            # Find zeros of the argument of ln
            for arg in f.args:
                if isinstance(arg, sp.log):
                    singularities.extend(sp.solve(arg.args[0], x))
        
        if not singularities:
            return None # Cannot confidently determine programmatically
            
        distances = [abs(s - a).evalf() for s in singularities if s.is_number]
        if distances:
            r = min(distances)
            return sp.nsimplify(r)
    except:
        pass
    return None

def generate_questions(num_questions):
    questions = []
    seen_signatures = set() 
    
    attempts = 0
    max_attempts = num_questions * 50 
    
    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1
        
        # Determine question type/difficulty
        rand_val = random.random()
        question_type = "expansion"
        difficulty = "basic"
        
        if rand_val < 0.10: # 10% chance
            question_type = "limit"
            difficulty = "scholar"
        elif rand_val < 0.20: # 10% chance
            question_type = "error_bound"
            difficulty = "hard"
        elif rand_val < 0.30: # 10% chance
            question_type = "binomial"
            difficulty = "medium"
        elif rand_val < 0.40: # 10% chance
            question_type = "integral_approx"
            difficulty = "scholar"
        elif rand_val < 0.50: # 10% chance
            question_type = "nth_derivative"
            difficulty = "scholar"
        else: # 50% chance
            # Standard expansions breakdown
            num_exp = len([q for q in questions if q.get("type") == "expansion"])
            total_exp = num_questions * 0.50
            if num_exp >= total_exp * 0.25: difficulty = "medium"
            if num_exp >= total_exp * 0.50: difficulty = "hard"
            if num_exp >= total_exp * 0.75: difficulty = "scholar"

        f, a, n = generate_random_function(difficulty, question_type)
        
        signature = f"{sp.srepr(f)}_{sp.srepr(a)}_{n}_{question_type}"
        if signature in seen_signatures:
            continue
            
        try:
            f_latex = sp.latex(f)
            
            if question_type == "limit":
                # Evaluate Limit
                L = sp.limit(f, x, a)
                if not L.is_finite: continue
                
                q_text = f"Evaluate the limit using Taylor/Maclaurin series: \\( \\lim_{{x \\to {sp.latex(a)}}} \\left({f_latex}\\right) \\)"
                ans_latex = sp.latex(L)
                ans_plain = str(L)
                
            elif question_type == "error_bound":
                # Error bound calculation
                eval_point = random.choice([0.1, 0.2, 0.5, -0.1, -0.2])
                c_symbol = sp.Symbol('c')
                n_der = sp.diff(f, x, n+1) # (n+1)th derivative
                
                # Maximize derivative on interval [0, eval_point]
                # For sin/cos/exp, the max is usually at the endpoint or 1 for trig
                if f.has(sp.sin) or f.has(sp.cos):
                    max_M = 1
                else:
                    max_M = abs(n_der.subs(x, max(0, eval_point)))
                    
                remainder_bound = (max_M / sp.factorial(n+1)) * abs(eval_point - a)**(n+1)
                
                q_text = f"Use the Maclaurin polynomial of degree {n} for \\( f(x) = {f_latex} \\) to approximate \\( f({eval_point}) \\). What is the maximum Lagrange error bound for this approximation?"
                ans_latex = f"R_{{{n}}}({eval_point}) \\le {sp.latex(remainder_bound.evalf(5))}"
                ans_plain = str(remainder_bound.evalf(5))
                
            elif question_type == "integral_approx":
                # Integral approximation calculation
                b_bound = random.choice([0.1, 0.5, 1])
                
                # Check effectively evaluatable limit around 0 for x->0 indeterminate
                val = sp.limit(f, x, 0)
                if not val.is_finite: continue
                
                f_series = sp.series(f, x, 0, n).removeO()
                if f_series == f and not f.is_polynomial(): continue
                
                integral_approx = sp.integrate(f_series, (x, 0, b_bound))
                
                q_text = f"Integrate the Maclaurin polynomial of degree {n-1} for \\( f(x) = {f_latex} \\) to approximate the definite integral \\( \\int_{{0}}^{{{sp.latex(b_bound)}}} {f_latex} \\, dx \\)."
                ans_latex = sp.latex(integral_approx.evalf(5)) if not integral_approx.has(sp.log, sp.exp, sp.sin) else sp.latex(integral_approx)
                ans_plain = str(integral_approx.evalf(5)) if not integral_approx.has(sp.log, sp.exp, sp.sin) else str(integral_approx)
                
            elif question_type == "nth_derivative":
                # Nth derivative calculation using Maclaurin coefficient
                term_coeff = sp.series(f, x, 0, n + 1).coeff(x, n)
                ans_val = term_coeff * sp.factorial(n)
                
                if ans_val == 0 or not ans_val.is_finite: continue
                
                # Suffix formatting for the derivative order
                if n % 10 == 1 and n != 11: suffix = "st"
                elif n % 10 == 2 and n != 12: suffix = "nd"
                elif n % 10 == 3 and n != 13: suffix = "rd"
                else: suffix = "th"
                
                q_text = f"Use Maclaurin series to find the {n}{suffix} derivative of \\( f(x) = {f_latex} \\) evaluated at \\( x = 0 \\). That is, find \\( f^{{({n})}}(0) \\)."
                ans_latex = sp.latex(ans_val)
                ans_plain = str(ans_val)
                
            else:
                # Standard Expansion or Binomial
                if f.has(sp.Integral) and not question_type == "binomial":
                    val = getattr(f.subs(x, a), 'doit', lambda: 1)()
                else:
                    if f.has(sp.sin, sp.cos, sp.tan, sp.exp, sp.ln):
                         val = f.subs(x, a).evalf()
                    else:
                         val = f.subs(x, a)
                    
                if not getattr(val, "is_real", True) or not getattr(val, "is_finite", True):
                    continue
                    
                series_exp = sp.series(f, x, a, n).removeO()
                if series_exp == f and (f.is_polynomial() or not f.has(sp.Integral)):
                    continue
                    
                if a == 0:
                    q_text = f"Find the Maclaurin polynomial of degree {n-1} approximating the given function \\( f(x) = {f_latex} \\)."
                else:
                    q_text = f"Find the Taylor polynomial of degree {n-1} approximating the given function \\( f(x) = {f_latex} \\) centered at \\( a = {sp.latex(a)} \\)."
                
                ans_latex = sp.latex(series_exp)
                ans_plain = str(series_exp)
                
                # 30% chance to also ask for the Radius of Convergence
                if question_type == "expansion" and random.random() < 0.3:
                    R = get_radius_of_convergence(f, a)
                    if R is not None:
                        q_text += " Also find the Radius of Convergence \\( R \\)."
                        ans_latex += f" \\quad ; \\quad R = {sp.latex(R)}"
                        ans_plain += f" ; R = {R}"

            question = {
                "id": len(questions) + 1,
                "type": question_type,
                "difficulty": difficulty,
                "function_latex": f_latex,
                "center_latex": sp.latex(a),
                "order": n - 1 if question_type in ["expansion", "binomial"] else None,
                "question_text": q_text,
                "answer_latex": ans_latex,
                "answer_plain": ans_plain
            }
            questions.append(question)
            seen_signatures.add(signature)
        except Exception as e:
            pass
            
    return questions

if __name__ == "__main__":
    print("Generating 2000 comprehensive questions for the Ultimate Math Database...")
    questions = generate_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/taylor_series.json"
    with open(output_file, "w") as f:
        json.dump({
            "topic": "Taylor Series",
            "description": "The Ultimate Practice Worksheet Database based on LibreTexts standards. Includes Taylor Polynomials, Integral Approximations, Nth Derivatives, Binomial Series, Limits, Error Bounds, and Radius of Convergence.",
            "questions": questions
        }, f, separators=(',', ':'))
        
    print(f"Successfully generated {len(questions)} unique questions in {output_file}")
