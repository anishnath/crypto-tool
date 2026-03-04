import sympy as sp
import json
import random
import os

try:
    from worksheet_figure_gen import generate_figure_for_system_equations
    FIGURES_ENABLED = True
except ImportError:
    FIGURES_ENABLED = False
    print("Warning: worksheet_figure_gen.py not found. Figures will not be generated.")

x, y, z, w = sp.symbols('x y z w')
rc = random.choice

# ---------------------------------------------------------------------------
# LaTeX helpers
# ---------------------------------------------------------------------------

def cases_latex(lines):
    """Build a raw \begin{cases} system for KaTeX (no \(...\) delimiters —
    worksheet-engine passes expression_latex directly to katex.render())."""
    inner = r" \\ ".join(lines)
    return r"\begin{cases} " + inner + r" \end{cases}"

# ===========================================================================
# BASIC GENERATORS (2 Variables)
# ===========================================================================

def gen_check_solution():
    """Verify if a given point is the solution to the system."""
    ans_x = random.randint(-6, 6)
    ans_y = random.randint(-6, 6)

    a, b, d, e = rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3])
    while a*e == b*d:
        d = rc([-5,-4,4,5])

    c = a*ans_x + b*ans_y
    f = d*ans_x + e*ans_y

    eq1_lhs = a*x + b*y
    eq2_lhs = d*x + e*y

    # 50% chance to be the correct point
    is_correct = random.random() < 0.5
    if is_correct:
        test_x, test_y = ans_x, ans_y
        ans_latex = r"\text{Yes, it is a solution}"
        ans_plain = "Yes"
    else:
        test_x = ans_x + rc([-2, -1, 1, 2])
        test_y = ans_y + rc([-2, -1, 1, 2])
        ans_latex = r"\text{No, it is not a solution}"
        ans_plain = "No"

    q_latex = cases_latex([f"{sp.latex(eq1_lhs)} = {c}", f"{sp.latex(eq2_lhs)} = {f}"])
    q_text = f"Is the ordered pair \\(({test_x}, {test_y})\\) a solution to the following system of linear equations?"

    return q_text, q_latex, ans_latex, ans_plain

def gen_solve_by_substitution():
    """Solve system using substitution."""
    ans_x = random.randint(-8, 8)
    ans_y = random.randint(-8, 8)

    var_isolated = rc(['x', 'y'])
    a = rc([-4,-3,-2,-1,1,2,3,4])
    b = rc([-4,-3,-2,-1,1,2,3,4])

    if var_isolated == 'y':
        m = rc([-3,-2,-1,1,2,3])
        c = ans_y - m*ans_x
        eq1_lhs, eq1_rhs = y, m*x + c
        eq2_lhs, eq2_rhs = a*x + b*y, a*ans_x + b*ans_y
    else:
        m = rc([-3,-2,-1,1,2,3])
        c = ans_x - m*ans_y
        eq1_lhs, eq1_rhs = x, m*y + c
        eq2_lhs, eq2_rhs = a*x + b*y, a*ans_x + b*ans_y

    q_latex = cases_latex([
        f"{sp.latex(eq1_lhs)} = {sp.latex(eq1_rhs)}",
        f"{sp.latex(eq2_lhs)} = {eq2_rhs}"
    ])
    q_text = "Solve the system of linear equations using the substitution method."

    ans_latex = f"({ans_x}, {ans_y})"
    ans_plain = f"(x, y) = ({ans_x}, {ans_y})"
    return q_text, q_latex, ans_latex, ans_plain

def gen_solve_by_elimination():
    """Solve system using elimination."""
    ans_x = random.randint(-8, 8)
    ans_y = random.randint(-8, 8)

    a = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    b = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    d = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
    e = rc([-5,-4,-3,-2,-1,1,2,3,4,5])

    while a*e == b*d:
        d += 1

    c = a*ans_x + b*ans_y
    f = d*ans_x + e*ans_y

    q_latex = cases_latex([f"{sp.latex(a*x + b*y)} = {c}", f"{sp.latex(d*x + e*y)} = {f}"])
    q_text = "Solve the system of linear equations using the elimination/addition method."

    ans_latex = f"({ans_x}, {ans_y})"
    ans_plain = f"(x, y) = ({ans_x}, {ans_y})"
    return q_text, q_latex, ans_latex, ans_plain

def gen_number_of_solutions():
    """Determine number of solutions: 0, 1, or Infinite."""
    sol_type = rc(["one", "none", "infinite"])

    a = rc([-5,-4,-3,-2,-1,2,3,4,5])
    b = rc([-5,-4,-3,-2,-1,2,3,4,5])
    c = rc([-10, -5, -2, 2, 5, 10])

    mult = rc([-3, -2, 2, 3])

    if sol_type == "one":
        d = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
        e = rc([-5,-4,-3,-2,-1,1,2,3,4,5])
        while a*e == b*d: e += 1
        f = rc([-10, 10])
        ans_plain = "One unique solution"
        ans_latex = r"\text{One unique solution (Consistent \& Independent)}"
    elif sol_type == "none":
        d = a * mult
        e = b * mult
        f = c * mult + rc([-3, -2, 2, 3])
        ans_plain = "No solution"
        ans_latex = r"\text{No solution (Inconsistent -- Parallel Lines)}"
    else: # infinite
        d = a * mult
        e = b * mult
        f = c * mult
        ans_plain = "Infinitely many solutions"
        ans_latex = r"\text{Infinitely many solutions (Consistent \& Dependent -- Coincident Lines)}"

    q_latex = cases_latex([f"{sp.latex(a*x + b*y)} = {c}", f"{sp.latex(d*x + e*y)} = {f}"])
    q_text = "Without solving the system, classify it and determine the number of solutions."
    return q_text, q_latex, ans_latex, ans_plain

def gen_solve_by_graphing():
    """Solve system using graphing/intercepts method (simple integers)."""
    ans_x = random.randint(-5, 5)
    ans_y = random.randint(-5, 5)

    a1, b1 = rc([(-2, 1), (-1, 1), (1, 1), (2, 1), (3, 1), (1, 2), (1, 3)])
    c1 = a1*ans_x + b1*ans_y

    a2, b2 = rc([(-3, 1), (-1, -1), (1, -1), (2, -1), (1, -2), (2, 3)])
    c2 = a2*ans_x + b2*ans_y

    while a1*b2 == a2*b1: # ensure independent
        a2 += 1
        c2 = a2*ans_x + b2*ans_y

    eq1_lhs = a1*x + b1*y
    eq1_rhs = c1
    eq2_lhs = a2*x + b2*y
    eq2_rhs = c2

    q_latex = cases_latex([f"{sp.latex(eq1_lhs)} = {c1}", f"{sp.latex(eq2_lhs)} = {c2}"])
    q_text = "Solve the system of linear equations by graphing."

    ans_latex = f"({ans_x}, {ans_y})"
    ans_plain = f"(x, y) = ({ans_x}, {ans_y})"

    # Return additional metadata for the figure generator
    return {
        "q_text": q_text,
        "q_latex": q_latex,
        "ans_latex": ans_latex,
        "ans_plain": ans_plain,
        "payload": {
            "eq1_lhs": eq1_lhs,
            "eq1_rhs": eq1_rhs,
            "eq2_lhs": eq2_lhs,
            "eq2_rhs": eq2_rhs,
            "var_x": x,
            "var_y": y,
            "ans_x": ans_x,
            "ans_y": ans_y,
            "f": None # Differentiator
        }
    }

# ===========================================================================
# MEDIUM GENERATORS
# ===========================================================================

def gen_fractional_coeffs():
    """System of equations with fractional coefficients."""
    ans_x = random.randint(-6, 6)
    ans_y = random.randint(-6, 6)

    denom1 = rc([2, 3, 4, 5])
    denom2 = rc([2, 3, 4, 5])

    # eq1: (a/denom1)x + (b/denom2)y = c
    a, b = rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3])

    c = sp.Rational(a, denom1)*ans_x + sp.Rational(b, denom2)*ans_y
    eq1_lhs = sp.Rational(a, denom1)*x + sp.Rational(b, denom2)*y

    denom3 = rc([2, 3])
    denom4 = rc([2, 3])
    d, e = rc([-3,-2,-1,1,2,3]), rc([-3,-2,-1,1,2,3])
    while a*e*denom1*denom4 == b*d*denom2*denom3: e += 1 # ensure independent

    f = sp.Rational(d, denom3)*ans_x + sp.Rational(e, denom4)*ans_y
    eq2_lhs = sp.Rational(d, denom3)*x + sp.Rational(e, denom4)*y

    q_latex = cases_latex([
        f"{sp.latex(eq1_lhs)} = {sp.latex(c)}",
        f"{sp.latex(eq2_lhs)} = {sp.latex(f)}"
    ])
    q_text = "Solve the following system of linear equations involving fractions."

    ans_latex = f"({ans_x}, {ans_y})"
    ans_plain = f"(x, y) = ({ans_x}, {ans_y})"
    return q_text, q_latex, ans_latex, ans_plain

def gen_system_3x3():
    """Solve system of 3 linear equations with 3 variables."""
    ans_x = random.randint(-4, 4)
    ans_y = random.randint(-4, 4)
    ans_z = random.randint(-4, 4)

    coeffs = [[rc([-3, -2, -1, 1, 2, 3]) for _ in range(3)] for _ in range(3)]

    # Check determinant for unique solution
    matrix = sp.Matrix(coeffs)
    while matrix.det() == 0:
        coeffs = [[rc([-3, -2, -1, 1, 2, 3]) for _ in range(3)] for _ in range(3)]
        matrix = sp.Matrix(coeffs)

    system_lines = []
    for i in range(3):
        a, b, c = coeffs[i][0], coeffs[i][1], coeffs[i][2]
        d = a*ans_x + b*ans_y + c*ans_z
        system_lines.append(f"{sp.latex(a*x + b*y + c*z)} = {d}")

    q_latex = cases_latex(system_lines)
    q_text = "Solve the system of three linear equations."

    ans_latex = f"({ans_x}, {ans_y}, {ans_z})"
    ans_plain = f"(x, y, z) = ({ans_x}, {ans_y}, {ans_z})"
    return q_text, q_latex, ans_latex, ans_plain

def gen_word_ticket_coin():
    """Ticket/Coin word problems (x + y = totals, ax + by = total$)."""
    item1, item2 = rc([("Adult tickets", "Child tickets"), ("Dimes", "Quarters"), ("Nickels", "Dimes"), ("Student tickets", "General admission tickets")])

    if item1 == "Dimes" and item2 == "Quarters":
        val1, val2 = 0.10, 0.25
        x_qty = random.randint(10, 30)
        y_qty = random.randint(10, 30)
        scenario = "coins"
    elif item1 == "Nickels" and item2 == "Dimes":
        val1, val2 = 0.05, 0.10
        x_qty = random.randint(15, 35)
        y_qty = random.randint(15, 35)
        scenario = "coins"
    else:
        val1 = rc([8, 10, 12, 15])
        val2 = val1 - rc([3, 4, 5])
        x_qty = random.randint(20, 100)
        y_qty = random.randint(20, 100)
        scenario = "tickets"

    total_qty = x_qty + y_qty
    total_val = round(x_qty * val1 + y_qty * val2, 2)

    # Plain-text dedup key (no LaTeX commands)
    q_latex = f"WordProblem_ticket_coin_{total_qty}_{total_val}"

    if scenario == "coins":
        q_text = f"A piggy bank contains {item1.lower()} and {item2.lower()} worth a total of \\(\\${total_val:.2f}\\). If there are exactly {total_qty} coins in total, how many of each type are there?"
    else:
        q_text = f"A local theater sold {total_qty} tickets to a play. {item1} cost \\(\\${val1}\\) each and {item2.lower()} cost \\(\\${val2}\\) each. If the total revenue was \\(\\${total_val:.2f}\\), how many of each ticket type were sold?"

    ans_latex = f"{x_qty} \\text{{ {item1.lower()}}},\\quad {y_qty} \\text{{ {item2.lower()}}}"
    ans_plain = f"{x_qty} {item1.lower()}, {y_qty} {item2.lower()}"
    return q_text, q_latex, ans_latex, ans_plain

def gen_word_age_number():
    """Age or basic numbers relationships (x = 2y - 5)."""
    val = rc(["age", "numbers"])

    if val == "age":
        y_val = random.randint(5, 50)
        mult = rc([2, 3, 4, 5])
        offset = random.randint(-15, 15)
        if offset == 0: offset = 1
        x_val = mult * y_val + offset

        sum_ages = x_val + y_val

        if offset > 0:
            rel = f"{offset} years older than {mult} times"
        else:
            rel = f"{abs(offset)} years younger than {mult} times"

        # Plain-text dedup key
        q_latex = f"WordProblem_age_{x_val}_{y_val}"
        q_text = f"The sum of Mary's age and John's age is {sum_ages}. Mary is {rel} John's age. Find their individual ages."
        ans_latex = f"\\text{{Mary: }} {x_val}, \\quad \\text{{John: }} {y_val}"
        ans_plain = f"Mary = {x_val}, John = {y_val}"

    else:
        y_val = random.randint(10, 100)
        mult = rc([2, 3, 4, 5])
        offset = random.randint(-20, 20)
        if offset == 0: offset = 3
        x_val = mult * y_val + offset

        diff = x_val - y_val

        offset_text = f"more" if offset > 0 else "less"
        q_latex = f"WordProblem_number_{x_val}_{y_val}"
        q_text = f"The difference between two numbers is {diff}. The larger number is {abs(offset)} {offset_text} than {mult} times the smaller number. Find the two numbers."
        ans_latex = f"\\text{{Larger: }} {x_val}, \\quad \\text{{Smaller: }} {y_val}"
        ans_plain = f"Larger = {x_val}, Smaller = {y_val}"

    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# HARD GENERATORS
# ===========================================================================

def gen_word_mixture():
    """Mixture problems (x + y = total, %x + %y = total%)."""
    sol1_pct = rc([5, 10, 15, 20, 25, 30])
    sol2_pct = rc([35, 40, 50, 60, 75, 80, 90])

    # We want valid amounts directly
    vol_x = random.randint(5, 100)
    vol_y = random.randint(5, 100)
    total_vol = vol_x + vol_y

    target_pct = (sol1_pct * vol_x + sol2_pct * vol_y) / total_vol
    target_pct = round(target_pct, 2)

    # Plain-text dedup key
    q_latex = f"WordProblem_mixture_{sol1_pct}_{sol2_pct}_{vol_x}_{vol_y}"
    q_text = f"A chemist needs {total_vol} liters of a {target_pct}% acid solution. They have two stock solutions: one is {sol1_pct}% acid and the other is {sol2_pct}% acid. How many liters of each should be mixed together?"

    ans_latex = f"{vol_x} \\text{{ L of }} {sol1_pct}\\%, \\quad {vol_y} \\text{{ L of }} {sol2_pct}\\%"
    ans_plain = f"{vol_x} L of {sol1_pct}%, {vol_y} L of {sol2_pct}%"
    return q_text, q_latex, ans_latex, ans_plain

def gen_word_distance_rate():
    """Distance/Rate/Time wind/current problem. D = (r+w)t and D = (r-w)t."""
    # airplane/wind or boat/current
    prob_type = rc(["airplane", "boat"])

    if prob_type == "airplane":
        rate = random.randint(150, 600)
        wind = random.randint(10, 100)
        t_with = random.randint(2, 10)
        t_against = t_with + random.randint(1, 5)
    else:
        rate = random.randint(15, 80)
        wind = random.randint(2, 12)
        t_with = random.randint(2, 8)
        t_against = t_with + random.randint(1, 4)

    dist1 = (rate + wind) * t_with
    dist2 = (rate - wind) * t_against

    if prob_type == "airplane":
        q_latex = f"WordProblem_airplane_{rate}_{wind}_{t_with}"
        q_text = f"An airplane travels {dist1} miles in {t_with} hours with a tailwind. The return trip against the same wind takes {t_against} hours covering {dist2} miles. Find the speed of the plane in still air and the speed of the wind."
        ans_latex = f"r = {rate} \\text{{ mph}}, \\quad w = {wind} \\text{{ mph}}"
        ans_plain = f"plane = {rate} mph, wind = {wind} mph"
    else:
        q_latex = f"WordProblem_boat_{rate}_{wind}_{t_with}"
        q_text = f"A boat travels downstream {dist1} miles in {t_with} hours. The return trip upstream against the current takes {t_against} hours to cover {dist2} miles. Find the speed of the boat in still water and the speed of the current."
        ans_latex = f"r = {rate} \\text{{ mph}}, \\quad c = {wind} \\text{{ mph}}"
        ans_plain = f"boat = {rate} mph, current = {wind} mph"

    return q_text, q_latex, ans_latex, ans_plain

def gen_word_investment():
    """Investment accounts (x+y=Total, r1*x + r2*y = TotalInterest)."""
    amt1 = random.randint(10, 200) * 100
    amt2 = random.randint(10, 200) * 100
    total_invest = amt1 + amt2

    r1 = rc([1.5, 2, 2.5, 3, 3.5, 4, 4.5])  # %
    r2 = rc([5, 5.5, 6, 6.5, 7, 7.5, 8, 9, 10]) # %

    total_interest = round((amt1 * r1 + amt2 * r2) / 100, 2)

    q_latex = f"WordProblem_investment_{amt1}_{amt2}_{r1}_{r2}"
    q_text = f"A total of \\(\\${total_invest}\\) is invested in two accounts. The first account earns {r1}% simple interest and the second earns {r2}% simple interest. After one year, the total interest earned from both accounts is \\(\\${total_interest:.2f}\\). How much was invested in each account?"

    ans_latex = f"\\${amt1} \\text{{ at }} {r1}\\%, \\quad \\${amt2} \\text{{ at }} {r2}\\%"
    ans_plain = f"${amt1} at {r1}%, ${amt2} at {r2}%"
    return q_text, q_latex, ans_latex, ans_plain

def gen_system_4x4():
    """Solve system of 4 linear equations with 4 variables."""
    ans_x = random.randint(-2, 2)
    ans_y = random.randint(-2, 2)
    ans_z = random.randint(-2, 2)
    ans_w = random.randint(-2, 2)

    coeffs = [[rc([-2, -1, 1, 2]) for _ in range(4)] for _ in range(4)]

    # Check determinant for unique solution
    matrix = sp.Matrix(coeffs)
    while matrix.det() == 0:
        coeffs = [[rc([-2, -1, 1, 2]) for _ in range(4)] for _ in range(4)]
        matrix = sp.Matrix(coeffs)

    system_lines = []
    for i in range(4):
        a, b, c, c_w = coeffs[i][0], coeffs[i][1], coeffs[i][2], coeffs[i][3]
        d = a*ans_x + b*ans_y + c*ans_z + c_w*ans_w
        system_lines.append(f"{sp.latex(a*x + b*y + c*z + c_w*w)} = {d}")

    q_latex = cases_latex(system_lines)
    q_text = "Solve the system of four linear equations for \\(x, y, z\\) and \\(w\\)."

    ans_latex = f"({ans_x}, {ans_y}, {ans_z}, {ans_w})"
    ans_plain = f"(x, y, z, w) = ({ans_x}, {ans_y}, {ans_z}, {ans_w})"
    return q_text, q_latex, ans_latex, ans_plain


# ===========================================================================
# SCHOLAR GENERATORS
# ===========================================================================

def gen_cramers_rule_3x3():
    """Specifically ask for Cramer's Rule matrices to find one specific variable."""
    ans_x = random.randint(-4, 4)
    ans_y = random.randint(-4, 4)
    ans_z = random.randint(-4, 4)

    coeffs = [[rc([-3, -2, -1, 1, 2, 3]) for _ in range(3)] for _ in range(3)]

    matrix = sp.Matrix(coeffs)
    while matrix.det() == 0:
        coeffs = [[rc([-3, -2, -1, 1, 2, 3]) for _ in range(3)] for _ in range(3)]
        matrix = sp.Matrix(coeffs)

    consts = []
    system_lines = []
    for i in range(3):
        a, b, c = coeffs[i][0], coeffs[i][1], coeffs[i][2]
        d = a*ans_x + b*ans_y + c*ans_z
        consts.append(d)
        system_lines.append(f"{sp.latex(a*x + b*y + c*z)} = {d}")

    target_var = rc(['x', 'y', 'z'])

    q_latex = cases_latex(system_lines)
    q_text = f"Use Cramer's Rule to solve for {target_var} only. Show the determinant forms."

    D_mat = sp.Matrix(coeffs)
    D = D_mat.det()

    if target_var == 'x':
        num_mat = D_mat.copy()
        num_mat[:, 0] = sp.Matrix(consts)
        ans_val = ans_x
    elif target_var == 'y':
        num_mat = D_mat.copy()
        num_mat[:, 1] = sp.Matrix(consts)
        ans_val = ans_y
    else:
        num_mat = D_mat.copy()
        num_mat[:, 2] = sp.Matrix(consts)
        ans_val = ans_z

    # Use mat_delim='' to avoid nested \left[\begin{matrix}...\right] inside \left|...\right|
    num_inner = sp.latex(num_mat, mat_delim='')
    d_inner = sp.latex(D_mat, mat_delim='')
    num_det = num_mat.det()

    ans_latex = (
        f"{target_var} = \\frac{{\\left|{num_inner}\\right|}}{{\\left|{d_inner}\\right|}}"
        f" = \\frac{{{num_det}}}{{{D}}} = {ans_val}"
    )
    ans_plain = f"{target_var} = {ans_val}"

    return q_text, q_latex, ans_latex, ans_plain

def gen_find_k_parameter():
    """Find the value of k such that the system has infinite or no solution."""
    k_sym = sp.Symbol('k')
    sol_type = rc(["no solution", "infinitely many solutions"])

    # a1*x + b1*y = c1
    # a2*x + b2*y = c2
    a1, b1, c1 = rc([-4,-3,-2,-1,2,3,4]), rc([-4,-3,-2,-1,2,3,4]), rc([-6,-4,-2,2,4,6])
    mult = rc([-3, -2, 2, 3])

    a2 = a1 * mult
    b2 = b1 * mult

    if sol_type == "infinitely many solutions":
        c2 = c1 * mult
    else:
        c2 = c1 * mult + rc([-3, -2, -1, 1, 2, 3])

    # We substitute one coefficient with 'k'
    pos = rc(["a1", "b1", "a2", "b2"])

    if pos == "a1":
        ans_k = a1
        eq1_lhs = k_sym*x + b1*y
        eq2_lhs = a2*x + b2*y
    elif pos == "b1":
        ans_k = b1
        eq1_lhs = a1*x + k_sym*y
        eq2_lhs = a2*x + b2*y
    elif pos == "a2":
        ans_k = a2
        eq1_lhs = a1*x + b1*y
        eq2_lhs = k_sym*x + b2*y
    else:
        ans_k = b2
        eq1_lhs = a1*x + b1*y
        eq2_lhs = a2*x + k_sym*y

    q_latex = cases_latex([f"{sp.latex(eq1_lhs)} = {c1}", f"{sp.latex(eq2_lhs)} = {c2}"])
    q_text = f"Find the value of \\(k\\) such that the system has {sol_type}."

    ans_latex = f"k = {ans_k}"
    ans_plain = f"k = {ans_k}"
    return q_text, q_latex, ans_latex, ans_plain

def gen_nonlinear_system():
    """Solve a linear/quadratic, linear/circle, or parabola/circle system."""
    sys_type = rc(["quadratic", "circle", "parabola_circle"])

    ans1_x = random.randint(-8, 8)
    ans1_y = random.randint(-8, 8)

    if sys_type == "quadratic":
        # y = ax^2 + bx + c
        # y = mx + d
        a = rc([-2, -1, 1, 2])
        ans2_x = ans1_x + rc([-3,-2,2,3])

        m = rc([-2, -1, 1, 2, 3])
        d = ans1_y - m*ans1_x
        ans2_y = m*ans2_x + d

        b = m - a*(ans1_x + ans2_x)
        c = d + a*ans1_x*ans2_x

        eq1_lhs = y
        eq1_rhs = a*x**2 + b*x + c
        eq2_lhs = m*x - y
        eq2_rhs = -d

        q_latex = cases_latex([
            f"{sp.latex(eq1_lhs)} = {sp.latex(eq1_rhs)}",
            f"{sp.latex(eq2_lhs)} = {sp.latex(eq2_rhs)}"
        ])
        ans_latex = f"({ans1_x}, {ans1_y}) \\text{{ and }} ({ans2_x}, {ans2_y})"
        ans_plain = f"({ans1_x}, {ans1_y}) and ({ans2_x}, {ans2_y})"

    elif sys_type == "circle":
        r = rc([5, 10, 13, 15, 17])
        if r == 5:
            pt1 = (3, 4)
            pt2 = (4, -3)
        elif r == 10:
            pt1 = (6, 8)
            pt2 = (8, -6)
        elif r == 13:
            pt1 = (5, 12)
            pt2 = (12, -5)
        elif r == 15:
            pt1 = (9, 12)
            pt2 = (12, -9)
        else: # 17
            pt1 = (8, 15)
            pt2 = (15, -8)

        # Flip randomly
        if random.random() < 0.5:
            pt1 = (-pt1[0], pt1[1])

        x1, y1 = pt1
        x2, y2 = pt2

        # slope
        m = sp.Rational(y2 - y1, x2 - x1)
        d = y1 - m*x1

        # mx - y = -d — multiply by denominator to avoid fractions
        denom = m.q
        eq2_lhs = m.p * x - denom * y
        eq2_rhs = -d * denom

        eq1_lhs = x**2 + y**2
        eq1_rhs = r**2

        q_latex = cases_latex([
            f"{sp.latex(eq1_lhs)} = {eq1_rhs}",
            f"{sp.latex(eq2_lhs)} = {eq2_rhs}"
        ])
        ans_latex = f"({x1}, {y1}) \\text{{ and }} ({x2}, {y2})"
        ans_plain = f"({x1}, {y1}) and ({x2}, {y2})"

    else: # sys_type == "parabola_circle":
        # x^2 + y = A
        # x^2 + y^2 = B
        # Substitution yields: y^2 - y + (A - B) = 0
        # Roots are (1 +/- k)/2 integer values if discriminant is k^2
        k = rc([3, 5, 7])
        C = (1 - k**2) // 4
        y1 = (1 + k) // 2
        y2 = (1 - k) // 2
        
        # Ensure A >= max(y1, y2) so x is real (x^2 = A - y)
        min_A = max(y1, y2) 
        A = random.randint(min_A, min_A + 6)
        B = A - C  # C = A - B
        
        eq1_lhs = x**2 + y
        eq1_rhs = A
        eq2_lhs = x**2 + y**2
        eq2_rhs = B
        
        q_latex = cases_latex([
            f"{sp.latex(eq1_lhs)} = {eq1_rhs}",
            f"{sp.latex(eq2_lhs)} = {eq2_rhs}"
        ])
        
        sols_latex = []
        sols_plain = []
        for y_val in (y1, y2):
            x_sq = A - y_val
            if x_sq == 0:
                sols_latex.append(f"(0, {y_val})")
                sols_plain.append(f"(0, {y_val})")
            else:
                x_val = sp.sqrt(x_sq)
                sols_latex.append(f"({sp.latex(-x_val)}, {y_val})")
                sols_latex.append(f"({sp.latex(x_val)}, {y_val})")
                
                # Try simple plain representation
                if x_val.is_integer:
                    sols_plain.append(f"({-x_val}, {y_val})")
                    sols_plain.append(f"({x_val}, {y_val})")
                else:
                    sols_plain.append(f"(-sqrt({x_sq}), {y_val})")
                    sols_plain.append(f"(sqrt({x_sq}), {y_val})")
                    
        ans_latex = ", \\quad ".join(sols_latex)
        ans_plain = " and ".join(sols_plain)

    q_text = "Solve the non-linear system of equations algebraically."
    return q_text, q_latex, ans_latex, ans_plain

# ===========================================================================
# DISPATCHER
# ===========================================================================

DIFFICULTY_TYPES = {
    "basic": [
        "check_solution",
        "solve_by_substitution",
        "solve_by_elimination",
        "solve_by_graphing",
        "number_of_solutions"
    ],
    "medium": [
        "fractional_coeffs",
        "system_3x3",
        "word_ticket_coin",
        "word_age_number",
        "solve_by_graphing"
    ],
    "hard": [
        "word_mixture",
        "word_distance_rate",
        "word_investment",
        "system_4x4"
    ],
    "scholar": [
        "cramers_rule_3x3",
        "find_k_parameter",
        "nonlinear_system"
    ]
}

def call_generator(q_type):
    generators = {
        "check_solution": gen_check_solution,
        "solve_by_substitution": gen_solve_by_substitution,
        "solve_by_elimination": gen_solve_by_elimination,
        "solve_by_graphing": gen_solve_by_graphing,
        "number_of_solutions": gen_number_of_solutions,

        "fractional_coeffs": gen_fractional_coeffs,
        "system_3x3": gen_system_3x3,
        "word_ticket_coin": gen_word_ticket_coin,
        "word_age_number": gen_word_age_number,

        "word_mixture": gen_word_mixture,
        "word_distance_rate": gen_word_distance_rate,
        "word_investment": gen_word_investment,
        "system_4x4": gen_system_4x4,

        "cramers_rule_3x3": gen_cramers_rule_3x3,
        "find_k_parameter": gen_find_k_parameter,
        "nonlinear_system": gen_nonlinear_system
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

def generate_system_questions(n_target):
    questions = []
    seen = set()
    attempts = 0
    max_attempts = n_target * 50

    while len(questions) < n_target and attempts < max_attempts:
        attempts += 1

        # Determine difficulty distribution
        rv = random.random()
        if rv < 0.25:
            diff = "basic"
        elif rv < 0.55:
            diff = "medium"
        elif rv < 0.85:
            diff = "hard"
        else:
            diff = "scholar"

        q_type = rc(DIFFICULTY_TYPES[diff])

        # Restrict the amount of graph generations to ~40
        if q_type == "solve_by_graphing" and random.random() < 0.82:
            continue

        data = call_generator(q_type)
        if data is None:
            continue

        # Deduplication using LaTeX/key string
        dup_key = data["q_latex"]
        if dup_key in seen:
            continue

        seen.add(dup_key)

        # Word problem types have no system formula to display
        WORD_PROBLEM_TYPES = {
            "word_ticket_coin", "word_age_number", "word_mixture",
            "word_distance_rate", "word_investment"
        }
        raw_expr = data.get("q_latex", "")
        display_expr = "" if q_type in WORD_PROBLEM_TYPES else raw_expr

        # Construct JSON output entry
        entry = {
            "id": len(questions) + 1,
            "type": q_type,
            "difficulty": diff,
            "expression_latex": display_expr,
            "question_text": data.get("q_text", ""),
            "answer_latex": data.get("ans_latex", ""),
            "answer_plain": data.get("ans_plain", "")
        }

        # Check if there is SVG image generation needed
        if "payload" in data and FIGURES_ENABLED:
            img_path = generate_figure_for_system_equations(
                q_type, data["payload"], entry["id"],
                os.path.join(os.path.dirname(os.path.abspath(__file__)), "src/main/webapp/worksheet/math/algebra/figures/systems")
            )
            if img_path:
                entry["answer_svg"] = img_path

        questions.append(entry)

    return questions

if __name__ == "__main__":
    import json
    random.seed(42)
    qs = generate_system_questions(2000)

    out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "src", "main", "webapp", "worksheet", "math", "algebra")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "systems_of_linear_equations.json")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "topic": "Systems of Equations",
            "description": "Comprehensive worksheet on systems of equations including 2x2, 3x3, word problems, non-linear systems, and Cramer's Rule.",
            "questions": qs
        }, f, separators=(',', ':'))

    print(f"Generated {len(qs)} System of Equation questions and saved to {out_path}.")

    from collections import Counter
    types = Counter(q["type"] for q in qs)
    diffs = Counter(q["difficulty"] for q in qs)

    print(f"\nBy difficulty:")
    for d, cnt in diffs.most_common():
        print(f"  {d}: {cnt}")

    print(f"\nBy type ({len(types)} types):")
    for tp, cnt in types.most_common():
        print(f"  {tp}: {cnt}")
