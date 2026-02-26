import sympy as sp
import json
import random
import os

x, h, k_sym = sp.symbols('x h k')

def generate_limit_function(difficulty):
    c1 = random.choice([-3, -2, -1, 1, 2, 3])
    c2 = random.choice([-2, -1, 1, 2, 3])
    c3 = random.choice([1, 2, 3])
    
    question_type = "standard"
    a = 0  # Limit approached point
    dir_limit = '+-'
    limit_var = x
    ans_override = None
    
    if difficulty == "basic":
        if random.random() < 0.2:
            # One-sided Asymptote limits
            a = random.choice([1, 2, -1, -2])
            f = (c1 * x + c2) / (x - a)
            dir_limit = random.choice(['+', '-'])
            question_type = "one_sided_asymptote"
        else:
            # Direct evaluation limits, continuous everywhere at the point
            # OR very simple rational functions with removable discontinuities
            a = random.choice([-2, -1, 0, 1, 2])
            funcs = [
                c1 * x**2 + c2 * x + c3,
                c1 * sp.exp(c2 * x),
                sp.sin(c1 * x),
                (sp.sqrt(x + abs(c1)) + c2) / (x + c3), # Direct evaluation with radical
                (x**2 - a**2) / (x - a) if a != 0 else (x**2 + c1*x) / x,
                (c1 * x + c2) / (x + c3)
            ]
            f = random.choice(funcs)
            
            # Make sure we don't accidentally divide by 0 for basic limits where it isn't the point
            val = f.subs(x, a)
            if val == sp.oo or val == -sp.oo or val == sp.nan:
               f = c1 * x**2 + c2 * x + c3

    elif difficulty == "medium":
        if random.random() < 0.2:
            # Difference Quotient
            base_f = random.choice([c1*x**2 + c2*x, c1/x, sp.sqrt(x + abs(c3))])
            f = (base_f.subs(x, x+h) - base_f) / h
            a = 0
            limit_var = h
            question_type = "difference_quotient"
        else:
            # Indeterminate forms 0/0 or oo/oo needing L'Hopital once or algebraic manipulation
            a = random.choice([0, 1, -1, sp.pi/4, sp.oo])
            
            if a == sp.oo:
                funcs = [
                    (c1 * x**2 + c2) / (c3 * x**2 + 1),  # Same degree
                    (c1 * x + c2) / (c3 * x**2 + 1),      # Bottom heavy
                    (c1 * x**3) / (c2 * x**2 + x + 1)     # Top heavy
                ]
                question_type = "infinity"
            elif a == 0:
                funcs = [
                    sp.sin(c1 * x) / (c2 * x),
                    (1 - sp.cos(c1 * x)) / x,
                    (sp.exp(c1 * x) - 1) / (c2 * x),
                    (sp.sqrt(1 + c1 * x) - 1) / x
                ]
                question_type = "lhopital"
            else:
                # Rationalizing or factoring
                funcs = [
                    (sp.sqrt(x) - sp.sqrt(a)) / (x - a) if a > 0 else (x**3 - a**3)/(x - a),
                    (sp.sqrt(x**2 + c1**2) - sp.sqrt(a**2 + c1**2)) / (x**2 - a**2) if a != 0 else (sp.exp(x)-1)/x,
                    (1/x - 1/a) / (x - a) if a != 0 else sp.sin(x)/x,
                    ((x - a)*(x - c1)) / (x - a), # Quadratic factoring (x^2 + ..) / (x - a)
                    ((x - a)*(x - c1)) / ((x - a)*(x - c2)) if c1 != c2 else x/a # Factoring top and bottom
                ]
            f = random.choice(funcs)
            
    elif difficulty == "hard":
        if random.random() < 0.15:
            # Squeeze Theorem
            a = 0
            f = x**2 * sp.sin(c1 / x) if random.random() < 0.5 else x**2 * sp.cos(c1 / x)
            question_type = "squeeze_theorem"
            
        elif random.random() < 0.15:
            # Continuity Unknown
            a = random.choice([1, 2, 3, -1, -2, -3])
            c_val = a * random.choice([1, 2, 3, -1, -2])
            k_val = a + c_val // a
            f = (x**2 - k_sym*x + c_val) / (x - a)
            ans_override = k_val
            question_type = "continuity_unknown"
            
        else:
            # Advanced L'Hopital (multiple times), complex conjugate tricks, or tricky limits at infinity
            a = random.choice([0, sp.oo, -sp.oo, sp.pi/2])
            
            if a == sp.oo or a == -sp.oo:
                funcs = [
                    sp.sqrt(x**2 + c1 * x) - x if a == sp.oo else sp.sqrt(x**2 + c1*x) + x,
                    x * sp.sin(c1 / x),
                    (1 + c1 / x)**x  # e trick
                ]
                question_type = "infinity_advanced"
            elif a == 0:
                funcs = [
                    (sp.sin(c1 * x) - c1 * x) / x**3,
                    (x - sp.sin(x)) / (x - sp.tan(x)),
                    (sp.exp(x) - 1 - x - x**2/2) / x**3,
                    1 / sp.sin(x) - 1 / x
                ]
                question_type = "lhopital_advanced"
            elif a == sp.pi/2:
                funcs = [
                    (sp.pi/2 - x) * sp.tan(x),
                    sp.cos(x) / (x - sp.pi/2),
                    (sp.sin(x) + sp.sqrt(sp.sin(x)**2 + c1*sp.cos(x)**2)) / (c2*sp.cos(x)**2)
                ]
            f = random.choice(funcs)
            
            # Add absolute value limits which Do Not Exist (DNE) for 'hard' tier
            if question_type == "standard" and random.random() < 0.2:
                 a = random.choice([1, 2, -1, -2])
                 f = sp.Abs(x - a) / ((x - a)*(x - c2)) if a != c2 else sp.Abs(x - a) / (x**2 - a**2)
                 question_type = "dne_absolute_value"
            
    else: # Scholar / Advanced Calculus
        # Hard limits involving exponents changing forms (1^oo, 0^0, oo^0)
        a = random.choice([0, sp.oo, 1])
        
        if a == 0:
            funcs = [
                (sp.cos(x))**(1/x**2),            # 1^oo
                x**x,                             # 0^0 (for x->0+)
                (sp.sin(x)/x)**(1/x**2)           # Using Taylor to prove 1^oo
            ]
        elif a == sp.oo:
            funcs = [
                x**(1/x),                         # oo^0
                (1 + c1/x + c2/x**2)**x,          # Advanced e approximation
                x * (sp.ln(x + 1) - sp.ln(x))
            ]
        elif a == 1:
            funcs = [
                x**(1/(1-x))                      # 1^oo
            ]
            
        f = random.choice(funcs)
        if f == x**x:
            dir_limit = '+'
        question_type = "exponent_indeterminate"

    return {
        "f": f,
        "a": a,
        "type": question_type,
        "dir": dir_limit,
        "var": limit_var,
        "ans": ans_override
    }

def generate_limit_questions(num_questions):
    questions = []
    seen_signatures = set()
    attempts = 0
    max_attempts = num_questions * 50
    
    while len(questions) < num_questions and attempts < max_attempts:
        attempts += 1
        
        # Determine difficulty distribution
        rand_val = random.random()
        difficulty = "basic"
        
        if rand_val < 0.25:
            difficulty = "basic"
        elif rand_val < 0.55:
            difficulty = "medium"
        elif rand_val < 0.85:
            difficulty = "hard"
        else:
            difficulty = "scholar"
            
        data = generate_limit_function(difficulty)
        f = data["f"]
        a = data["a"]
        question_type = data["type"]
        dir_limit = data["dir"]
        limit_var = data["var"]
        ans_override = data["ans"]

        signature = f"{sp.srepr(f)}_{sp.srepr(a)}_{dir_limit}_{limit_var}"
        if signature in seen_signatures:
            continue
            
        try:
            f_latex = sp.latex(f)
            
            ans_latex = ""
            ans_plain = ""
            
            if ans_override is not None:
                ans_latex = sp.latex(ans_override)
                ans_plain = str(ans_override)
            else:
                # Evaluate using Sympy's limit engine
                try:
                    L = sp.limit(f, limit_var, a, dir=dir_limit)
                    # Skip un-evaluable limits or complex infinities
                    if L.has(sp.zoo) or L == sp.nan:
                        continue
                    ans_latex = sp.latex(L)
                    ans_plain = str(L)
                    
                    # If evaluating to Infinity, format it nicely
                    if L == sp.oo:
                        ans_latex = "\\infty"
                        ans_plain = "Infinity"
                    elif L == -sp.oo:
                        ans_latex = "-\\infty"
                        ans_plain = "-Infinity"
                except ValueError as ve:
                    if "does not exist" in str(ve).lower():
                        ans_latex = "\\text{DNE}"
                        ans_plain = "Does Not Exist"
                    else:
                        continue

            # Format the question text gracefully
            a_latex = sp.latex(a)
            var_latex = sp.latex(limit_var)
            
            if question_type == "continuity_unknown":
                q_text = f"Find the numerical value of the constant \\( k \\) that makes the limit exist: \\( \\lim_{{{var_latex} \\to {a_latex}}} \\left({f_latex}\\right) \\)"
            else:
                if dir_limit == '+':
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}^+}} \\left({f_latex}\\right) \\)"
                elif dir_limit == '-':
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}^-}} \\left({f_latex}\\right) \\)"
                else:
                    q_text = f"Evaluate the limit: \\( \\lim_{{{var_latex} \\to {a_latex}}} \\left({f_latex}\\right) \\)"

            question = {
                "id": len(questions) + 1,
                "type": question_type,
                "difficulty": difficulty,
                "function_latex": f_latex,
                "point_latex": a_latex,
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
    print("Generating 2000 Limit questions...")
    questions = generate_limit_questions(2000)

    output_dir = "/Users/anish/git/crypto-tool/src/main/webapp/worksheet/math/calculus"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/limits.json"
    with open(output_file, "w") as f:
        json.dump({
            "topic": "Limits",
            "description": "Comprehensive Practice Worksheet Database for Limits. Includes Difference Quotient, Squeeze Theorem, One-Sided Asymptotes, and Unknown Parameter Continuity.",
            "questions": questions
        }, f, separators=(',', ':'))
        
    print(f"Successfully generated {len(questions)} unique limits questions in {output_file}")
