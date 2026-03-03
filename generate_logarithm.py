import sympy as sp
import json
import random
import os
import sys
import math

# Figure generation (optional — gracefully degrades if matplotlib unavailable)
_fig_gen_available = False
_fig_gen = None
_FIGURE_TYPES_LOGARITHMS = set()
_figures_dir_logarithms = ""
try:
    import worksheet_figure_gen as _fig_gen
    _FIGURE_TYPES_LOGARITHMS = _fig_gen.FIGURE_TYPES_LOGARITHMS
    _figures_dir_logarithms = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "src", "main", "webapp", "worksheet", "math", "algebra",
        "figures", "logarithms")
    _fig_gen_available = True
    print("Figure generation enabled.")
except (ImportError, AttributeError):
    print("worksheet_figure_gen not available — skipping figure generation.")

x, y, z, w, t = sp.symbols('x y z w t', real=True, positive=True)

def rc(pool):
    return random.choice(pool)

NZ = [-5,-4,-3,-2,-1,1,2,3,4,5]
POS = [1,2,3,4,5,6]

# ===========================================================================
# HELPERS
# ===========================================================================

def clean_latex(s: str) -> str:
    return s.replace(r"\left(x\right)", "(x)")

# ===========================================================================
# BASIC GENERATORS
# ===========================================================================

def gen_evaluate_basic():
    """Evaluate log_b(x) forms"""
    base = rc([2, 3, 4, 5, 6, 7, 8, 9, 10])
    v = rc(["integer", "fraction", "radical", "1_or_base"])
    
    if v == "integer":
        exp = rc([2, 3, 4])
        val = base**exp
        q_latex = f"\\log_{{{base}}}({val})"
        ans = sp.Integer(exp)
    elif v == "fraction":
        exp = rc([-1, -2, -3])
        val = base**abs(exp)
        q_latex = f"\\log_{{{base}}}\\left(\\frac{{1}}{{{val}}}\\right)"
        ans = sp.Integer(exp)
    elif v == "radical":
        root = rc([2, 3, 4])
        exp_num = rc([1, 2, 3])
        if root == 2:
            r_str = f"\\sqrt{{{base**exp_num}}}"
        else:
            r_str = f"\\sqrt[{root}]{{{base**exp_num}}}"
        q_latex = f"\\log_{{{base}}}\\left({r_str}\\right)"
        ans = sp.Rational(exp_num, root)
    else:
        if rc([True, False]):
            q_latex = f"\\log_{{{base}}}(1)"
            ans = sp.Integer(0)
        else:
            q_latex = f"\\log_{{{base}}}({base})"
            ans = sp.Integer(1)
            
    q_text = rc([
        "Evaluate the following logarithmic expression exactly.",
        "Find the exact value of the logarithm without using a calculator.",
        "Determine the value of the following logarithmic expression.",
        "Simplify the logarithm to an exact number."
    ])
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_rewrite_exp_to_log():
    """Rewrite exponential as log"""
    a = rc([2, 3, 4, 5, 10, 'e'])
    if a == 'e':
        base_str = "e"
    else:
        base_str = str(a)
    
    b = rc([2, 3, -2, -3, "x", "y"])
    if a == 'e' and isinstance(b, int):
        c = sp.exp(b)
    elif isinstance(b, int):
        c = a**b
    else:
        c = sp.symbols('c')

    if b in ["x", "y"]:
        b_sym = sp.symbols(b)
        c_str = "c"
    else:
        b_sym = b
        c_str = str(c)
        if hasattr(c, "evalf") and not c.is_integer:
            if a == 'e':
                c_str = f"e^{{{b}}}" # we keep it symbolic or show value
            else:
                c_str = f"\\frac{{1}}{{{a**abs(b)}}}" if b<0 else str(c)

    q_latex = f"{base_str}^{{{b_sym}}} = {c_str}"
    
    if a == 'e':
        ans_latex = f"\\ln({c_str}) = {b_sym}"
        ans_plain = f"ln({c_str}) = {b_sym}"
    else:
        ans_latex = f"\\log_{{{base_str}}}({c_str}) = {b_sym}"
        ans_plain = f"log_{base_str}({c_str}) = {b_sym}"

    q_text = rc([
        "Rewrite the following exponential equation in logarithmic form.",
        "Convert the given exponential statement into an equivalent logarithmic equation.",
        "Express the following equation using logarithms."
    ])
    
    return q_text, q_latex, ans_latex, ans_plain

def gen_rewrite_log_to_exp():
    """Rewrite log as exponential"""
    a = rc([2, 3, 4, 5, 10, 'e'])
    b = rc([2, 3, "x"])
    c = rc([2, 3, "y"])
    
    if a == 'e':
        q_latex = f"\\ln({b}) = {c}"
        ans_latex = f"e^{{{c}}} = {b}"
        ans_plain = f"e^{c} = {b}"
    else:
        q_latex = f"\\log_{{{a}}}({b}) = {c}"
        ans_latex = f"{a}^{{{c}}} = {b}"
        ans_plain = f"{a}^{c} = {b}"
        
    q_text = rc([
        "Rewrite the following logarithmic equation in exponential form.",
        "Convert the given logarithmic statement into an equivalent exponential equation.",
        "Express the following equation using exponents instead of logarithms."
    ])
    return q_text, q_latex, ans_latex, ans_plain

def gen_domain_log():
    """Find the domain of a log function"""
    # use local x so no conflicts with global positive=True assumption
    local_x = sp.Symbol('x', real=True)
    a = rc([1, 2, 3, -1, -2, -3])
    c = rc(NZ)
    base = rc([2, 3, 10, 'e'])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    
    inner = a*local_x + c
    func_latex = f"f(x) = {log_str}({sp.latex(inner)})"
    
    # a*x + c > 0 => ax > -c
    root_val = sp.Rational(-c, a)
    if a > 0:
        ans_latex = f"\\left({sp.latex(root_val)}, \\infty\\right)"
        ans_plain = f"({root_val}, oo)"
    else:
        ans_latex = f"\\left(-\\infty, {sp.latex(root_val)}\\right)"
        ans_plain = f"(-oo, {root_val})"
        
    q_text = rc([
        "Find the domain of the logarithmic function.",
        "Determine the domain of the following function.",
        "Find all valid values of \\( x \\) for the function."
    ])
    return q_text, func_latex, ans_latex, ans_plain

def gen_inverse_properties():
    """Evaluate b^(log_b(x)) or log_b(b^x)"""
    v = rc(["exp_log", "log_exp", "exp_log_coeff", "log_exp_coeff"])
    base = rc([2, 3, 5, 10, 'e'])
    val = rc([2, 3, 5, 7, "x", "y"])
    
    if v == "exp_log":
        if base == 'e': q_latex = f"e^{{\\ln({val})}}"
        else: q_latex = f"{base}^{{\\log_{{{base}}}({val})}}"
        ans = val
    elif v == "log_exp":
        if base == 'e': q_latex = f"\\ln(e^{{{val}}})"
        else: q_latex = f"\\log_{{{base}}}({base}^{{{val}}})"
        ans = val
    elif v == "exp_log_coeff":
        c = rc([2, 3])
        if val in ["x", "y"]:
            if base == 'e': q_latex = f"e^{{{c}\\ln({val})}}"
            else: q_latex = f"{base}^{{{c}\\log_{{{base}}}({val})}}"
            ans = f"{val}^{c}"
        else:
            if base == 'e': q_latex = f"e^{{{c}\\ln({val})}}"
            else: q_latex = f"{base}^{{{c}\\log_{{{base}}}({val})}}"
            ans = val**c
    else:
        c = rc([2, 3, 4])
        if base == 'e': q_latex = f"\\ln\\left(\\frac{{1}}{{e^{{{c}}}}}\\right)"
        else: q_latex = f"\\log_{{{base}}}\\left(\\frac{{1}}{{{base}^{{{c}}}}}\\right)"
        ans = -c

    q_text = rc([
        "Simplify the expression using inverse properties of logarithms.",
        "Evaluate the expression."
    ])
    
    if isinstance(ans, str): return q_text, q_latex, ans, ans
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_estimate_log():
    """Estimate which two integers a log falls between"""
    base = rc([2, 3, 4, 5])
    low_exp = rc([1, 2, 3])
    high_exp = low_exp + 1
    
    low_val = base**low_exp
    high_val = base**high_exp
    
    val = random.randint(low_val + 1, high_val - 1)
    
    q_latex = f"\\log_{{{base}}}({val})"
    ans_latex = f"\\text{{Between }} {low_exp} \\text{{ and }} {high_exp}"
    ans_text = f"Between {low_exp} and {high_exp}"
    
    q_text = "Between which two consecutive integers does the logarithm lie?"
    return q_text, q_latex, ans_latex, ans_text

def gen_graph_log_function():
    """Draw the graph of f(x) = A log_b (C x + D) + E"""
    local_x = sp.Symbol('x', real=True)
    a = rc([1, -1, 2, -2])
    b = rc([2, 3, 10, 'e'])
    c = rc([1, -1, 2, -2])
    d = rc([-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5])
    e = rc([-3, -2, -1, 0, 1, 2, 3])
    
    log_str = "\\ln" if b == 'e' else "\\log" if b == 10 else f"\\log_{{{b}}}"
    
    inner = c*local_x + d if d != 0 else c*local_x
    if c == 1 and d == 0: inner_str = "x"
    elif c == -1 and d == 0: inner_str = "-x"
    else: inner_str = sp.latex(inner)
        
    if a == 1: func = f"{log_str}({inner_str})"
    elif a == -1: func = f"-{log_str}({inner_str})"
    else: func = f"{a}{log_str}({inner_str})"
        
    if e > 0: q_latex = f"f(x) = {func} + {e}"
    elif e < 0: q_latex = f"f(x) = {func} - {abs(e)}"
    else: q_latex = f"f(x) = {func}"

    asy = sp.Rational(-d, c) if c != 0 else 0
    
    ans_latex = f"\\text{{Graph with vertical asymptote }} x = {sp.latex(asy)}"
    ans_plain = f"Graph with vertical asymptote x = {asy}"
    
    q_text = "Draw the graph of the logarithmic function and analyze it completely (find domain, vertical asymptote, and intercepts)."
    
    expr = None
    if b == 'e':
        expr = a * sp.ln(inner) + e
    else:
        expr = a * sp.log(inner, b) + e
        
    return {
        "q_text": q_text,
        "q_latex": q_latex,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "f": expr,
        "asy": asy,
        "dir": "+" if c > 0 else "-"
    }

# ===========================================================================
# MEDIUM GENERATORS
# ===========================================================================

def gen_expand_log_simple():
    """Basic expansion: log(xy), log(x/y), log(x^n)"""
    v = rc(["product", "quotient", "power"])
    base = rc([2, 3, 5, 10, 'e'])
    log_func = sp.ln if base == 'e' else lambda t: sp.log(t, base)
    
    if v == "product":
        expr = x * y
        ans = log_func(x) + log_func(y)
    elif v == "quotient":
        expr = x / y
        ans = log_func(x) - log_func(y)
    elif v == "power":
        n = rc([2, 3, 4, 5])
        expr = x**n
        ans = n * log_func(x)
        
    if base == 'e':
        q_latex = f"\\ln\\left({sp.latex(expr)}\\right)"
    else:
        q_latex = f"\\log_{{{base}}}\\left({sp.latex(expr)}\\right)"
        
    q_text = rc([
        "Use the properties of logarithms to expand the expression.",
        "Expand the given logarithmic expression into a sum, difference, or multiple of logarithms.",
        "Write the expression as a sum and/or difference of individual logarithms."
    ])
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_expand_log_complex():
    """Expand complex: log(x^A y^B / (z^C w^D)) and radicals"""
    base = rc([2, 3, 10, 'e'])
    p_x = rc([1, 2, 3, sp.Rational(1,2), sp.Rational(1,3)])
    p_y = rc([1, 2, 3])
    p_z = rc([1, 2])
    p_w = rc([0, 1, 2])
    
    def p_latex(sy, p):
        if p == 1: return sp.latex(sy)
        if p == sp.Rational(1,2): return f"\\sqrt{{{sp.latex(sy)}}}"
        if p == sp.Rational(1,3): return f"\\sqrt[3]{{{sp.latex(sy)}}}"
        return f"{sp.latex(sy)}^{{{p}}}"
        
    num = p_latex(x, p_x) + (p_latex(y, p_y) if p_y else "")
    den = p_latex(z, p_z) + (p_latex(w, p_w) if p_w else "")
    
    if den:
        inner_latex = f"\\frac{{{num}}}{{{den}}}"
    else:
        inner_latex = f"{num}"
        
    if base == 'e':
        q_latex = f"\\ln\\left({inner_latex}\\right)"
        ans = p_x*sp.ln(x) + p_y*sp.ln(y) - p_z*sp.ln(z) - p_w*sp.ln(w)
    else:
        q_latex = f"\\log_{{{base}}}\\left({inner_latex}\\right)"
        ans = p_x*sp.log(x, base) + p_y*sp.log(y, base) - p_z*sp.log(z, base) - p_w*sp.log(w, base)
        
    q_text = rc([
        "Expand the logarithmic expression completely.",
        "Use logarithmic properties to write the expression as a sum/difference of logarithms with no exponents inside.",
        "Fully expand the given logarithm."
    ])
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_condense_log_complex():
    """Condense A log(x) + B log(y) - C log(z) - D log(w)"""
    base = rc([2, 3, 10, 'e'])
    A = rc([1, 2, 3, sp.Rational(1,2)])
    B = rc([1, 2, 3])
    C = rc([1, 2])
    D = rc([0, 1])
    
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    
    def term_l(coeff, sy, sign="+"):
        if coeff == 0: return ""
        c_str = ""
        if coeff != 1:
            c_str = sp.latex(coeff)
        return f"{sign} {c_str}{log_str}({sp.latex(sy)})"
        
    q_latex = term_l(A, x, "") + " " + term_l(B, y, "+") + " " + term_l(C, z, "-")
    if D > 0:
        q_latex += " " + term_l(D, w, "-")
        
    if q_latex.startswith("+ "): q_latex = q_latex[2:]
    
    inner = (x**A * y**B) / (z**C * w**D) if D > 0 else (x**A * y**B) / (z**C)
    if base == 'e':
        ans = sp.ln(inner)
    else:
        ans = sp.log(inner, base)
        
    q_text = rc([
        "Condense the expression into a single logarithm.",
        "Write the given logarithmic sum and difference as a single logarithm.",
        "Combine the expression into one logarithmic term."
    ])
    return q_text, q_latex.strip(), sp.latex(ans), str(ans)
    
def gen_change_of_base():
    """Change of base formula"""
    old_base = rc([2, 3, 4, 5, 7, 8, 9])
    val = rc([11, 13, 15, 17, 20, 100])
    new_base = rc(['e', 10, 2])
    while new_base == old_base:
        new_base = rc(['e', 10, 2])
        
    q_latex = f"\\log_{{{old_base}}}({val})"
    
    if new_base == 'e':
        ans_latex = f"\\frac{{\\ln({val})}}{{\\ln({old_base})}}"
        ans_plain = f"ln({val})/ln({old_base})"
        target_str = "natural logarithms (base \\( e \\))"
    elif new_base == 10:
        ans_latex = f"\\frac{{\\log_{{10}}({val})}}{{\\log_{{10}}({old_base})}}"
        ans_plain = f"log_10({val})/log_10({old_base})"
        target_str = "common logarithms (base \\( 10 \\))"
    else:
        ans_latex = f"\\frac{{\\log_{{{new_base}}}({val})}}{{\\log_{{{new_base}}}({old_base})}}"
        ans_plain = f"log_{new_base}({val})/log_{new_base}({old_base})"
        target_str = f"logarithms with base \\( {new_base} \\)"
        
    q_text = rc([
        f"Use the change-of-base formula to rewrite the expression in terms of {target_str}.",
        f"Rewrite the given logarithm using {target_str} via the change-of-base property.",
        f"Convert the logarithm to base \\( {sp.latex(new_base) if new_base != 'e' else 'e'} \\)."
    ])
    return q_text, q_latex, ans_latex, ans_plain

def gen_express_in_terms_of():
    """Given log(A)=u, log(B)=v, find log(A^n / B^m)"""
    base = rc([2, 3, 5, 10])
    var1 = sp.Symbol('u')
    var2 = sp.Symbol('v')
    
    A = rc([2, 3, 4])
    B = rc([2, 3])
    op = rc(["product", "quotient", "radical"])
    
    if op == "product":
        q_latex = f"\\log_{{{base}}}(x^{{{A}}} y^{{{B}}})"
        ans = A*var1 + B*var2
    elif op == "quotient":
        q_latex = f"\\log_{{{base}}}\\left(\\frac{{x^{{{A}}}}}{{y^{{{B}}}}}\\right)"
        ans = A*var1 - B*var2
    else:
        q_latex = f"\\log_{{{base}}}\\left(\\sqrt{{{x} y^{A}}}\\right)"
        ans = sp.Rational(1,2)*var1 + sp.Rational(A,2)*var2
        
    q_text = f"Given that $\\log_{{{base}}}(x) = u$ and $\\log_{{{base}}}(y) = v$, express the following in terms of $u$ and $v$:"
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_combine_constants():
    """Condense C + log_b(x)"""
    base = rc([2, 3, 4, 10, 'e'])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    c = rc([1, 2, 3])
    sign = rc(["+", "-"])
    
    local_x = sp.Symbol('x', positive=True)
    
    if sign == "+":
        q_latex = f"{c} + {log_str}(x)"
        ans_inner = (sp.exp(c) if base == 'e' else base**c) * local_x
    else:
        q_latex = f"{c} - {log_str}(x)"
        ans_inner = (sp.exp(c) if base == 'e' else base**c) / local_x
        
    ans = sp.ln(ans_inner) if base == 'e' else sp.log(ans_inner, base)
    q_text = "Condense the expression into a single logarithm. (Hint: Convert the constant into a logarithm first)."
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_graphing_features():
    """Find features of a logarithmic graph"""
    local_x = sp.Symbol('x', real=True)
    a = rc([1, 2, 3])
    if rc([True, False]): a = -a
    b = rc([2, 3, 4, 10, 'e'])
    c = rc([1, 2, 3])
    d = rc([1, 2, 3, 4])
    k = rc([-3, -2, -1, 1, 2, 3])
    
    log_str = "\\ln" if b == 'e' else f"\\log_{{{b}}}"
    arg = c*local_x - d
    
    sign_k = "+" if k > 0 else "-"
    func_latex = f"f(x) = {a}{log_str}({sp.latex(arg)}) {sign_k} {abs(k)}"
    q_latex = func_latex
    
    # Asymptote x = d/c
    asy = sp.Rational(d, c)
    # x-intercept where f(x) = 0 => a*log_b(cx - d) = -k => log_b(cx-d) = -k/a => cx-d = b^(-k/a)
    if b == 'e':
        x_int = sp.simplify((sp.exp(sp.Rational(-k, a)) + d) / c)
    else:
        # To avoid sympy simplifying 10^(-k/a) weirdly, we just keep it exact
        x_int = (b**(sp.Rational(-k, a)) + d) / c
        if not hasattr(x_int, "evalf"):
            x_int = sp.Rational(d, c) + sp.simplify(b**(sp.Rational(-k, a)) / c)
            
    ans_latex = f"\\text{{Asymptote: }} x = {sp.latex(asy)}, \\quad \\text{{x-intercept: }} x = {sp.latex(x_int)}"
    ans_plain = f"Asymptote: x = {asy}, x-int: x = {x_int}"
    q_text = "Find the vertical asymptote and x-intercept of the logarithmic function."
    
    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# HARD GENERATORS
# ===========================================================================

def gen_solve_log_single():
    """Solve log_b(ax+c) = d"""
    local_x = sp.Symbol('x', real=True)
    base = rc([2, 3, 4, 5, 10])
    d = rc([1, 2, 3])
    a = rc(NZ)
    c = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    
    if base == 'e':
        q_latex = f"\\ln({sp.latex(a*local_x + c)}) = {d}"
        ans = (sp.exp(d) - c) / a
    else:
        q_latex = f"\\log_{{{base}}}({sp.latex(a*local_x + c)}) = {d}"
        ans = sp.Rational(base**d - c, a)
        
    q_text = rc([
        "Solve the logarithmic equation for \\( x \\).",
        "Find the exact solution for \\( x \\).",
        "Determine the value of \\( x \\) that satisfies the equation."
    ])
    return q_text, q_latex, f"x = {sp.latex(ans)}", f"x = {ans}"

def gen_solve_log_multi():
    """Solve log_b(x+A) + log_b(x+B) = C"""
    local_x = sp.Symbol('x', real=True)
    base = rc([2, 3, 4, 10])
    C = rc([1, 2, 3])
    val = base**C
    
    sol = rc([1, 2, 3, 4, 5, 6])
    
    factors = []
    for i in range(1, int(math.sqrt(val)) + 1):
        if val % i == 0:
            factors.append((i, val//i))
            
    if not factors: return None
    
    f1, f2 = rc(factors)
    # f1 = sol + A, f2 = sol + B
    A = f1 - sol
    B = f2 - sol
    
    q_latex = f"\\log_{{{base}}}({sp.latex(local_x+A)}) + \\log_{{{base}}}({sp.latex(local_x+B)}) = {C}"
        
    q_text = rc([
        "Solve the logarithmic equation exactly. Check for extraneous solutions.",
        "Combine the logarithms and solve for \\( x \\), ensuring the solution is in the domain.",
        "Find all valid solutions for \\( x \\) in the given equation."
    ])
    return q_text, q_latex, f"x = {sol}", f"x = {sol}"

def gen_solve_log_both_sides():
    """Solve log_b(ax+c) = log_b(dx+f)"""
    local_x = sp.Symbol('x', real=True)
    base = rc([2, 3, 5, 10, 'e'])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    
    a = rc([1,2,3,4])
    d = rc([1,2,3,4])
    while a == d: d = rc([1,2,3,4])
    c = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    f = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    
    root = sp.Rational(f-c, a-d)
    
    if a*root + c <= 0 or d*root + f <= 0:
        ans_latex = "\\text{No solution}"
        ans_plain = "No solution"
    else:
        ans_latex = f"x = {sp.latex(root)}"
        ans_plain = f"x = {root}"
        
    q_latex = f"{log_str}({sp.latex(a*local_x + c)}) = {log_str}({sp.latex(d*local_x + f)})"
    
    q_text = rc([
        "Solve the equation. Be sure to identify any extraneous solutions.",
        "Equate the arguments of the logarithms to solve for \\( x \\).",
        "Find the solution(s) to the logarithmic equation."
    ])
    return q_text, q_latex, ans_latex, ans_plain

def gen_solve_exp_simple():
    """Solve a^(bx+c) = a^(dx+f)"""
    local_x = sp.Symbol('x', real=True)
    a = rc([2, 3, 5, 7, 'e'])
    b = rc([-3,-2,-1,1,2,3])
    d = rc([-3,-2,-1,1,2,3])
    while b == d: d = rc([-3,-2,-1,1,2,3])
    c = rc(NZ)
    f = rc(NZ)
    
    base_str = "e" if a == 'e' else str(a)
    expr1 = b*local_x + c
    expr2 = d*local_x + f
    
    q_latex = f"{base_str}^{{{sp.latex(expr1)}}} = {base_str}^{{{sp.latex(expr2)}}}"
    ans = sp.Rational(f-c, b-d)
    
    q_text = rc([
        "Solve the following exponential equation by equating exponents.",
        "Find the exact solution for \\( x \\).",
        "Determine the value of \\( x \\) that makes the equation true."
    ])
    return q_text, q_latex, f"x = {sp.latex(ans)}", f"x = {ans}"

def gen_solve_exp_different_bases():
    """Solve a^(bx+c) = k^(dx+f)"""
    local_x = sp.Symbol('x', real=True)
    a, k = random.sample([2, 3, 5, 7], 2)
    b = rc([1, 2, 3])
    d = rc([1, 2, 3])
    c = rc([-3, -2, -1, 1, 2, 3])
    f = rc([-3, -2, -1, 1, 2, 3])
    
    q_latex = f"{a}^{{{sp.latex(b*local_x + c)}}} = {k}^{{{sp.latex(d*local_x + f)}}}"
    
    num = f*sp.ln(k) - c*sp.ln(a)
    den = b*sp.ln(a) - d*sp.ln(k)
    
    if den == 0: return None
        
    ans = sp.simplify(num / den)
    
    q_text = rc([
        "Solve the exponential equation. Give the exact solution in terms of natural logarithms.",
        "Find the exact solution for \\( x \\) by taking the logarithm of both sides.",
        "Solve for \\( x \\) exactly."
    ])
    return q_text, q_latex, f"x = {sp.latex(ans)}", f"x = {ans}"

def gen_solve_log_substitution():
    """(log_b x)^2 + B(log_b x) + C = 0"""
    local_x = sp.Symbol('x', real=True, positive=True)
    base = rc([2, 3, 10, 'e'])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    
    r1 = rc([-2, -1, 1, 2, 3])
    r2 = rc([-2, -1, 1, 2])
    
    B = -(r1 + r2)
    C = r1 * r2
    
    if B > 0: q_latex = f"({log_str} x)^2 + {B}{log_str} x + {C} = 0"
    elif B < 0: q_latex = f"({log_str} x)^2 - {abs(B)}{log_str} x + {C} = 0"
    else: q_latex = f"({log_str} x)^2 + {C} = 0"
        
    sol1 = sp.exp(r1) if base == 'e' else base**r1
    sol2 = sp.exp(r2) if base == 'e' else base**r2
    
    sols = list(set([sol1, sol2]))
    ans_latex = "x = " + ", ".join([sp.latex(s) for s in sols])
    ans_plain = "x = " + ", ".join([str(s) for s in sols])
    
    q_text = "Solve the logarithmic equation. (Hint: It is quadratic in form)."
    return q_text, q_latex, ans_latex, ans_plain

def gen_solve_base_variable():
    """log_x(A) = B"""
    loc_x = sp.Symbol('x', positive=True)
    B = rc([2, 3])
    x_val = rc([2, 3, 4, 5])
    
    A = x_val**B
    
    v = rc(["simple", "binomial"])
    if v == "simple":
        q_latex = f"\\log_x({A}) = {B}"
        ans = x_val
    else:
        shift = rc([1, 2, 3])
        sign = rc(["+", "-"])
        
        if sign == "+":
            q_latex = f"\\log_{{x+{shift}}}({A}) = {B}"
            ans = x_val - shift
        else:
            q_latex = f"\\log_{{x-{shift}}}({A}) = {B}"
            ans = x_val + shift
            
    base_val = ans + shift if (v == "binomial" and sign == "+") else ans - shift if (v == "binomial" and sign == "-") else ans
    if base_val <= 0 or base_val == 1: return None
        
    q_text = "Solve the logarithmic equation for \\( x \\) by converting to exponential form."
    return q_text, q_latex, f"x = {ans}", f"x = {ans}"

def gen_find_inverse_function():
    """Find the inverse of f(x) = A log_b(x+C) + D OR f(x) = A b^(x+C) + D"""
    local_x = sp.Symbol('x', real=True)
    is_log = rc([True, False])
    base = rc([2, 3, 10, 'e'])
    
    a = rc([1, -1, 2, -2, 3, -3, 5, -5])
    c = rc([-3, -2, -1, 0, 1, 2, 3])
    d = rc([-5, -3, -2, -1, 0, 1, 2, 3, 5])
    
    if is_log:
        log_str = "\\ln" if base == 'e' else "\\log" if base == 10 else f"\\log_{{{base}}}"
        arg_str = f"x {sp.latex(c)}" if c != 0 else "x"
        if c > 0: arg_str = f"x + {c}"
        
        func_core = f"{log_str}({arg_str})"
        if a == 1: term = func_core
        elif a == -1: term = f"-{func_core}"
        else: term = f"{a} {func_core}"
        
        if d > 0: q_latex = f"f(x) = {term} + {d}"
        elif d < 0: q_latex = f"f(x) = {term} - {abs(d)}"
        else: q_latex = f"f(x) = {term}"
        
        expr_exponent = (local_x - d) / a
        if base == 'e': inv_expr = sp.exp(expr_exponent) - c
        else: inv_expr = base**(expr_exponent) - c
            
        ans_latex = f"f^{{-1}}(x) = {sp.latex(inv_expr)}"
        ans_plain = f"f^-1(x) = {inv_expr}"
    else:
        # Exponential
        base_str = "e" if base == 'e' else str(base)
        arg = local_x + c if c != 0 else local_x
        
        if a == 1: term = f"{base_str}^{{{sp.latex(arg)}}}"
        elif a == -1: term = f"-{base_str}^{{{sp.latex(arg)}}}"
        else: term = f"{a} \\cdot {base_str}^{{{sp.latex(arg)}}}"
        
        if d > 0: q_latex = f"f(x) = {term} + {d}"
        elif d < 0: q_latex = f"f(x) = {term} - {abs(d)}"
        else: q_latex = f"f(x) = {term}"
        
        inner_expr = (local_x - d) / a
        if base == 'e': inv_expr = sp.ln(inner_expr) - c
        else: inv_expr = sp.log(inner_expr, base) - c
            
        # sympy might simplify natural log abstractly or display weirdly, so we format standard
        ans_latex = f"f^{{-1}}(x) = {sp.latex(inv_expr)}"
        ans_plain = f"f^-1(x) = {inv_expr}"
        
    q_text = "Find the inverse of the following function."
    return q_text, q_latex, ans_latex, ans_plain

def gen_system_of_logs():
    """Systems of logarithmic equations"""
    base = rc([2, 3, 10])
    
    if base == 2:
        x_val = rc([2, 4, 8, 16, 32])
        y_val = rc([2, 4, 8, 16])
    elif base == 3:
        x_val = rc([3, 9, 27, 81])
        y_val = rc([3, 9, 27])
    else:
        x_val = rc([10, 100])
        y_val = rc([10, 100])
        
    if x_val == y_val:
        choices = [v for v in [2,4,8,16,3,9,27,10,100] if v != y_val and sp.log(v, base).is_integer]
        if choices: x_val = rc(choices)
            
    C = int(math.log(x_val, base) + math.log(y_val, base))
    D = x_val - y_val
    sign_D = "-" if D < 0 else ""
    
    log_str = "\\log" if base == 10 else f"\\log_{{{base}}}"
    q_latex = f"\\begin{{cases}} {log_str}(x) + {log_str}(y) = {C} \\\\ x - y = {D} \\end{{cases}}"
    
    q_text = "Solve the system of equations for \\( (x, y) \\)."
    ans_latex = f"(x, y) = ({x_val}, {y_val})"
    ans_plain = f"(x, y) = ({x_val}, {y_val})"
    
    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# SCHOLAR GENERATORS
# ===========================================================================

def gen_solve_exp_quadratic():
    """Solve Ae^{2x} + Be^x + C = 0"""
    r1 = rc([-3, -2, -1, 1, 2, 3, 4, 5])
    r2 = rc([-2, -1, 1, 2, 3])
    
    B = -(r1 + r2)
    C = r1 * r2
    
    base = rc(['e', 2, 3, 10])
    base_str = "e" if base == 'e' else str(base)
    
    if B > 0:
        q_latex = f"{base_str}^{{2x}} + {B}{base_str}^x + {C} = 0"
    elif B < 0:
        q_latex = f"{base_str}^{{2x}} - {abs(B)}{base_str}^x + {C} = 0"
    else:
        q_latex = f"{base_str}^{{2x}} + {C} = 0"
        
    sols = []
    for r in [r1, r2]:
        if r > 0:
            if base == 'e':
                sols.append(sp.ln(r))
            else:
                sols.append(sp.log(r, base))
                
    if not sols:
        ans_latex = "\\text{No real solution}"
        ans_plain = "No real solution"
    else:
        sols = list(set(sols))
        ans_latex = "x = " + ", ".join([sp.latex(sol) for sol in sols])
        ans_plain = "x = " + ", ".join([str(sol) for sol in sols])
        
    q_text = rc([
        "Solve the exponential equation of quadratic type.",
        "Substitute to solve the following equation exactly in terms of log.",
        "Find all valid real solutions to the equation."
    ])
    return q_text, q_latex, ans_latex, ans_plain

def gen_log_inequality():
    """Solve log_b(ax+c) > d or < d"""
    local_x = sp.Symbol('x', real=True)
    base = rc([2, 3, 4, 10, 'e'])
    d = rc([0, 1, 2, 3])
    a = rc([1, 2, 3])
    c = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    
    op = rc([">", "<", "\\ge", "\\le"])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    q_latex = f"{log_str}({sp.latex(a*local_x + c)}) {op} {d}"
    
    domain_bound = sp.Rational(-c, a)
    val = sp.E**d if base == 'e' else base**d
    eq_bound = (val - c) / a
    
    if op in [">", "\\ge"]:
        if op == ">":
            ans_latex = f"\\left({sp.latex(eq_bound)}, \\infty\\right)"
        else:
            ans_latex = f"\\left[{sp.latex(eq_bound)}, \\infty\\right)"
    else:
        if op == "<":
            ans_latex = f"\\left({sp.latex(domain_bound)}, {sp.latex(eq_bound)}\\right)"
        else:
            ans_latex = f"\\left({sp.latex(domain_bound)}, {sp.latex(eq_bound)}\\right]"
            
    ans_plain = ans_latex.replace("\\left", "").replace("\\right", "").replace("\\infty", "oo").replace("\\", "")
    
    q_text = rc([
        "Solve the logarithmic inequality. Express your answer in interval notation.",
        "Find the interval of \\( x \\) values that satisfy the inequality.",
        "Determine the solution set for the inequality."
    ])
    return q_text, q_latex, ans_latex, ans_plain

def gen_logarithmic_differentiation():
    """Find dy/dx for y = f(x)^g(x) using logarithmic differentiation"""
    local_x = sp.Symbol('x', real=True, positive=True)
    v = rc(["x_to_x", "sin_to_x", "x_to_lnx"])
    a = rc([1, 2, 3, 4, 5])
    b = rc([1, 2, 3])
    
    if v == "x_to_x":
        inner = a*local_x
        outer = b*local_x
        expr = inner**outer
        ans = expr * (outer/local_x + b*sp.ln(inner))
        q_latex = f"y = {sp.latex(inner)}^{{{sp.latex(outer)}}}"
    elif v == "sin_to_x":
        expr = sp.sin(a*local_x)**(b*local_x)
        ans = expr * (b*sp.ln(sp.sin(a*local_x)) + b*a*local_x * sp.cot(a*local_x))
        q_latex = f"y = (\\sin {a}x)^{{{b}x}}"
    else:
        expr = local_x**(b*sp.ln(local_x))
        ans = expr * (2*b * sp.ln(local_x) / local_x)
        q_latex = f"y = x^{{{b}\\ln x}}"
        
    q_text = "Use logarithmic differentiation to find the derivative \\( \\frac{dy}{dx} \\)."
    return q_text, q_latex, sp.latex(ans), str(ans)

# ===========================================================================
# CALCULUS GENERATORS
# ===========================================================================

def gen_log_derivative():
    """Find the derivative of log functions"""
    local_x = sp.Symbol('x', real=True)
    base = rc([2, 3, 5, 10, 'e'])
    log_str = "\\ln" if base == 'e' else f"\\log_{{{base}}}"
    
    v = rc(["chain_poly", "product", "quotient", "power"])
    a = rc([1, 2, 3])
    b = rc([-3, -2, -1, 1, 2, 3])
    
    if v == "chain_poly":
        n = rc([2, 3, 4])
        inner = a*local_x**n + b
        if base == 'e':
            expr = sp.ln(inner)
        else:
            expr = sp.log(inner, base)
    elif v == "product":
        n = rc([2, 3])
        if base == 'e':
            expr = local_x**n * sp.ln(local_x)
        else:
            expr = local_x**n * sp.log(local_x, base)
    elif v == "quotient":
        if base == 'e':
            expr = sp.ln(local_x) / local_x**2
        else:
            expr = sp.log(local_x, base) / local_x**2
    else:
        n = rc([2, 3, 4])
        if base == 'e':
            expr = sp.ln(local_x)**n
        else:
            expr = sp.log(local_x, base)**n
            
    ans = sp.simplify(sp.diff(expr, local_x))
    
    q_latex = f"\\frac{{d}}{{dx}} \\left[ {sp.latex(expr)} \\right]"
    q_text = rc([
        "Find the derivative of the logarithmic function.",
        "Differentiate the given expression with respect to \\( x \\).",
        "Compute the first derivative of the function."
    ])
    
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_log_integral():
    """Integrals resulting in log forms or involving logs"""
    local_x = sp.Symbol('x', real=True)
    v = rc(["1_over_x", "u_sub_ln", "integration_by_parts"])
    a = rc([1, 2, 3, 4])
    b = rc([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
    
    if v == "1_over_x":
        expr = a / (local_x + b)
        ans = a * sp.ln(abs(local_x + b))
    elif v == "u_sub_ln":
        expr = sp.ln(local_x) / local_x
        ans = sp.ln(local_x)**2 / 2
    else:
        n = rc([1, 2])
        expr = local_x**n * sp.ln(local_x)
        ans = local_x**(n+1)*sp.ln(local_x)/(n+1) - local_x**(n+1)/(n+1)**2
        
    q_latex = f"\\int {sp.latex(expr)}\\,dx"
    q_text = rc([
        "Evaluate the indefinite integral.",
        "Find the antiderivative of the logarithmic function.",
        "Integrate the expression with respect to \\( x \\)."
    ])
    
    # Indefinite integrals need a + C
    ans_latex = sp.latex(ans) + " + C"
    ans_plain = str(ans) + " + C"
    
    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# WORD PROBLEM GENERATORS
# ===========================================================================

def gen_word_problems():
    """Real-world applications of logarithms"""
    v = rc(["compound_interest", "half_life", "ph_scale", "richter_scale", "newtons_cooling"])
    
    if v == "compound_interest":
        P = rc([1000, 1500, 2000, 3000, 5000, 7500, 10000, 15000])
        r_pct = rc([1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 8.0])
        r = r_pct / 100
        A_target = rc([2, 2.5, 3, 3.5, 4, 5]) * P
        if isinstance(A_target, float) and A_target.is_integer(): A_target = int(A_target)
        
        # A = P * e^(rt) => t = ln(A/P) / r
        ans = sp.ln(A_target / P) / r
        ans_approx = round(float(ans.evalf()), 2)
        
        q_latex = f"{A_target} = {P} \\cdot e^{{rt}}"
        q_text = f"An investment of \\(\\${P:,}\\) earns continuous compound interest at an annual rate of {r_pct}%. How many years will it take for the investment to grow to \\(\\${A_target:,}\\)? (Use natural logarithm for exact answer)"
        
        ans_latex = f"t = {sp.latex(ans)} \\approx {ans_approx}\\text{{ years}}"
        ans_plain = f"t = {ans} ~ {ans_approx} years"
        
    elif v == "half_life":
        isotope = rc(["Carbon-14", "Uranium-235", "Radium-226", "Plutonium-239", "Tritium"])
        if isotope == "Carbon-14": hl = 5730
        elif isotope == "Radium-226": hl = 1600
        elif isotope == "Plutonium-239": hl = 24100
        elif isotope == "Tritium": hl = 12
        else: hl = 700000000
            
        remain_pct = rc([5, 10, 15, 20, 25, 30, 35, 40, 50, 60, 75, 80])
        
        # N(t) = N0 * (1/2)^(t/hl) => remain_pct/100 = (1/2)^(t/hl) => ln(remain/100) = (t/hl)ln(1/2)
        ans = hl * sp.ln(remain_pct/100) / sp.ln(0.5)
        ans_approx = round(float(ans.evalf()), 1)
        
        q_latex = f"N(t) = N_0 \\left(\\frac{{1}}{{2}}\\right)^{{t/{hl}}}"
        q_text = f"The half-life of {isotope} is exactly {hl:,} years. How old is a sample that contains {remain_pct}% of its original amount? (Use natural logarithm for exact answer)"
        
        ans_latex = f"t = {sp.latex(ans)} \\approx {ans_approx}\\text{{ years}}"
        ans_plain = f"t = {ans} ~ {ans_approx} years"
        
    elif v == "ph_scale":
        H_ion = rc([
            "1.0 \\times 10^{-2}", "1.5 \\times 10^{-3}", "2.5 \\times 10^{-4}", "3.0 \\times 10^{-4}",
            "4.2 \\times 10^{-5}", "5.0 \\times 10^{-6}", "6.8 \\times 10^{-7}", "7.5 \\times 10^{-8}",
            "8.2 \\times 10^{-8}", "3.2 \\times 10^{-8}", "1.8 \\times 10^{-9}", "9.1 \\times 10^{-10}"
        ])
        
        # pH = -log10[H+]
        H_float = float(H_ion.replace("\\times 10^{", "e").replace("}", "").replace(" ", ""))
        ans_approx = round(-math.log10(H_float), 2)
        
        q_latex = f"pH = -\\log_{{10}}[H^+] = -\\log_{{10}}({H_ion})"
        q_text = f"The pH of a solution is given by \\(pH = -\\log_{{10}}[H^+]\\). Determine the approximate pH of a solution with a hydrogen ion concentration of \\([H^+] = {H_ion}\\text{{ M}}\\)."
        
        ans_latex = f"pH \\approx {ans_approx}"
        ans_plain = f"pH ~ {ans_approx}"
        
    elif v == "richter_scale":
        mag1 = rc([3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5])
        mag2 = mag1 + rc([0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5])
        
        # log10(I2/I1) = M2 - M1 => I2/I1 = 10^(M2 - M1)
        ans = 10**(mag2 - mag1)
        ans_approx = round(ans, 1)
        if ans_approx.is_integer(): ans_approx = int(ans_approx)
        
        q_latex = f"M_2 - M_1 = \\log_{{10}}\\left(\\frac{{I_2}}{{I_1}}\\right)"
        q_text = f"An earthquake has a magnitude of {mag2} on the Richter scale. Another has a magnitude of {mag1}. Using \\(M_2 - M_1 = \\log_{{10}}\\left(\\frac{{I_2}}{{I_1}}\\right)\\), how many times more intense is the stronger earthquake?"
        
        ans_latex = f"{ans_approx}\\text{{ times stronger}}"
        ans_plain = f"{ans_approx} times stronger"
        
    else:
        T_env = rc([60, 65, 68, 70, 72, 75])
        T_0 = rc([160, 175, 180, 190, 200, 210]) # coffee
        T_final = rc([100, 110, 120, 130, 140, 150])
        k = rc([0.02, 0.04, 0.05, 0.06, 0.08, 0.10, 0.12, 0.15]) # cooling rate
        
        # T(t) = T_env + (T_0 - T_env)e^(-kt)
        ans = -sp.ln((T_final - T_env) / (T_0 - T_env)) / k
        ans_approx = round(float(ans.evalf()), 1)
        
        q_latex = f"T(t) = {T_env} + ({T_0} - {T_env})e^{{-{k}t}}"
        q_text = f"A cup of coffee at \\({T_0}^\\circ F\\) is placed in a room at \\({T_env}^\\circ F\\). It cools according to Newton's Law of Cooling. How many minutes will it take for the coffee to cool to \\({T_final}^\\circ F\\)?"
        
        ans_latex = f"t = {sp.latex(ans)} \\approx {ans_approx}\\text{{ minutes}}"
        ans_plain = f"t = {ans} ~ {ans_approx} minutes"

    return q_text, q_latex, ans_latex, ans_plain

def gen_log_limits():
    """Limit problems involving logarithms (L'Hopital's)"""
    local_x = sp.Symbol('x', real=True, positive=True)
    v = rc(["inf_over_inf", "zero_times_inf", "one_to_inf"])
    
    if v == "inf_over_inf":
        n = rc([1, 2, 3, 4])
        a = rc([1, 2, 3, 5])
        expr = sp.ln(a*local_x) / local_x**n
        ans = sp.limit(expr, local_x, sp.oo)
        q_latex = f"\\lim_{{x \\to \\infty}} \\frac{{\\ln({a}x)}}{{x^{n}}}"
    elif v == "zero_times_inf":
        n = rc([1, 2, 3])
        a = rc([1, 2, 3])
        expr = local_x**n * sp.ln(a*local_x)
        ans = sp.limit(expr, local_x, 0, dir='+')
        if n == 1:
            q_latex = f"\\lim_{{x \\to 0^+}} x \\ln({a}x)"
        else:
            q_latex = f"\\lim_{{x \\to 0^+}} x^{n} \\ln({a}x)"
    else:
        # (1 + k/x)^(mx) => limit is e^(mk)
        k = rc([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
        m = rc([1, 2, 3])
        expr = (1 + k/local_x)**(m*local_x)
        ans = sp.E**(k*m)
        sign = "+" if k > 0 else "-"
        q_latex = f"\\lim_{{x \\to \\infty}} \\left(1 {sign} \\frac{{{abs(k)}}}{{x}}\\right)^{{{m}x}}"
        
    q_text = "Evaluate the limit. Use L'Hôpital's Rule if necessary."
    return q_text, q_latex, sp.latex(ans), str(ans)

def gen_log_taylor_series():
    """Taylor/Maclaurin series for ln(A+Bx)"""
    local_x = sp.Symbol('x', real=True)
    a = rc([-4, -3, -2, -1, 1, 2, 3, 4, 5])
    k = rc([1, 2, 3])
    
    # ln(k + ax) = ln(k(1 + a/k x)) = ln(k) + ln(1 + a/k x)
    term1_const = sp.ln(k) if k > 1 else 0
    mult = sp.Rational(a, k)
    
    term1_lin = mult*local_x
    term2 = -sp.Rational(1,2)*(mult*local_x)**2
    term3 = sp.Rational(1,3)*(mult*local_x)**3
    term4 = -sp.Rational(1,4)*(mult*local_x)**4
    
    if term1_const == 0:
        ans = term1_lin + term2 + term3 + term4
    else:
        # need 4 non-zero terms total, which means constant + x + x^2 + x^3
        ans = term1_const + term1_lin + term2 + term3
        
    sign_str = "+" if a > 0 else "-"
    
    q_latex = f"f(x) = \\ln({k} {sign_str} {abs(a)}x)"
    q_text = "Find the first four non-zero terms of the Maclaurin series for the function."
    
    ans_latex = sp.latex(ans) + " + \\cdots"
    ans_plain = str(ans) + " + ..."
    
    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# DISPATCHER
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "evaluate_basic",
        "rewrite_exp_to_log",
        "rewrite_log_to_exp",
        "domain_log",
        "inverse_properties",
        "estimate_log"
    ],
    "medium": [
        "expand_log_simple",
        "expand_log_complex",
        "condense_log_complex",
        "change_of_base",
        "express_in_terms_of",
        "combine_constants",
        "graphing_features",
        "graph_log_function"
    ],
    "hard": [
        "solve_log_single",
        "solve_log_multi",
        "solve_log_both_sides",
        "solve_exp_simple",
        "solve_exp_different_bases",
        "solve_log_substitution",
        "solve_base_variable",
        "system_of_logs",
        "find_inverse_function",
        "word_problems"
    ],
    "scholar": [
        "solve_exp_quadratic",
        "log_inequality",
        "log_derivative",
        "log_integral",
        "logarithmic_differentiation",
        "log_limits",
        "log_taylor_series"
    ]
}

def call_generator(q_type):
    generators = {
        "evaluate_basic": gen_evaluate_basic,
        "rewrite_exp_to_log": gen_rewrite_exp_to_log,
        "rewrite_log_to_exp": gen_rewrite_log_to_exp,
        "domain_log": gen_domain_log,
        "inverse_properties": gen_inverse_properties,
        "estimate_log": gen_estimate_log,
        
        "expand_log_simple": gen_expand_log_simple,
        "expand_log_complex": gen_expand_log_complex,
        "condense_log_complex": gen_condense_log_complex,
        "change_of_base": gen_change_of_base,
        "express_in_terms_of": gen_express_in_terms_of,
        "combine_constants": gen_combine_constants,
        "graphing_features": gen_graphing_features,
        "graph_log_function": gen_graph_log_function,
        
        "solve_log_single": gen_solve_log_single,
        "solve_log_multi": gen_solve_log_multi,
        "solve_log_both_sides": gen_solve_log_both_sides,
        "solve_exp_simple": gen_solve_exp_simple,
        "solve_exp_different_bases": gen_solve_exp_different_bases,
        "solve_log_substitution": gen_solve_log_substitution,
        "solve_base_variable": gen_solve_base_variable,
        "system_of_logs": gen_system_of_logs,
        "find_inverse_function": gen_find_inverse_function,
        "word_problems": gen_word_problems,
        
        "solve_exp_quadratic": gen_solve_exp_quadratic,
        "log_inequality": gen_log_inequality,
        "log_derivative": gen_log_derivative,
        "log_integral": gen_log_integral,
        "logarithmic_differentiation": gen_logarithmic_differentiation,
        "log_limits": gen_log_limits,
        "log_taylor_series": gen_log_taylor_series
    }
    
    if q_type not in generators:
        return None
        
    res = generators[q_type]()
    if res is None: 
        return None
        
    if isinstance(res, dict):
        return res
        
    q_text, q_latex, ans_latex, ans_plain = res
    return {
        "q_text": q_text,
        "q_latex": q_latex,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain
    }

def generate_logarithm_questions(n_target=2000):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = n_target * 50
    
    local_x = sp.Symbol('x', real=True)
    
    while len(questions) < n_target and attempts < max_attempts:
        attempts += 1
        
        # Determine difficulty distribution
        rv = random.random()
        if rv < 0.20:
            diff = "basic"
        elif rv < 0.45:
            diff = "medium"
        elif rv < 0.70:
            diff = "hard"
        else:
            diff = "scholar"
            
        q_type = rc(DIFFICULTY_TYPES[diff])
        
        # apply specific weights to certain question types
        if q_type == "log_integral" and random.random() < 0.5: continue
        if q_type == "graph_log_function" and random.random() < 0.5: continue
        
        data = call_generator(q_type)
        if data is None: 
            continue
            
        # Deduplication using LaTeX string
        dup_key = data["q_latex"]
        if dup_key in seen:
            continue
            
        seen.add(dup_key)
        
        entry = {
            "id": len(questions) + 1,
            "type": q_type,
            "difficulty": diff,
            "expression_latex": data["q_latex"],
            "question_text": data["q_text"],
            "answer_latex": data["ans_latex"],
            "answer_plain": data["ans_plain"]
        }
        
        if _fig_gen_available and q_type in _FIGURE_TYPES_LOGARITHMS:
            try:
                fig_path = _fig_gen.generate_figure_for_logarithm(
                    q_type, data, entry["id"], _figures_dir_logarithms)
                if fig_path:
                    entry["figure_svg"] = fig_path
            except Exception as e:
                print(f"Figure gen failed for {q_type} id={entry['id']}: {e}")
                
        questions.append(entry)
        
    return questions

if __name__ == "__main__":
    qs = generate_logarithm_questions(2000)
    
    out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "logarithms.json")
    
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Logarithms",
            "description": "Logarithmic equations, expanding, condensing, and solving.",
            "questions": qs
        }, f, separators=(',', ':'))
        
    print(f"Generated {len(qs)} logarithm questions and saved to {out_path}.")
    
    from collections import Counter
    types = Counter(q["type"] for q in qs)
    diffs = Counter(q["difficulty"] for q in qs)
    
    print(f"\nBy difficulty:")
    for d, cnt in diffs.most_common():
        print(f"  {d}: {cnt}")
        
    print(f"\nBy type ({len(types)} types):")
    for tp, cnt in types.most_common():
        print(f"  {tp}: {cnt}")
