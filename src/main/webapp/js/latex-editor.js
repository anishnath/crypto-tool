/**
 * LaTeX Equation Editor - JavaScript Engine
 */

let autoPreviewEnabled = true;

// LaTeX symbol definitions
const latexSymbols = {
    structures: [
        { latex: '\\frac{a}{b}', label: 'Fraction', cursor: 6 },
        { latex: 'x^{2}', label: 'Superscript', cursor: 3 },
        { latex: 'x_{i}', label: 'Subscript', cursor: 3 },
        { latex: '\\sqrt{x}', label: 'Square Root', cursor: 6 },
        { latex: '\\sqrt[n]{x}', label: 'Nth Root', cursor: 7 },
        { latex: '\\sum_{i=1}^{n}', label: 'Summation', cursor: 8 },
        { latex: '\\int_{a}^{b}', label: 'Integral', cursor: 7 },
        { latex: '\\lim_{x \\to \\infty}', label: 'Limit', cursor: 6 },
        { latex: '\\prod_{i=1}^{n}', label: 'Product', cursor: 8 },
        { latex: '\\bigcup_{i=1}^{n}', label: 'Union', cursor: 11 },
        { latex: '\\bigcap_{i=1}^{n}', label: 'Intersection', cursor: 11 },
        { latex: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix}', label: '2×2 Matrix', cursor: 16 }
    ],
    functions: [
        { latex: '\\sin(x)', label: 'Sine' },
        { latex: '\\cos(x)', label: 'Cosine' },
        { latex: '\\tan(x)', label: 'Tangent' },
        { latex: '\\log(x)', label: 'Logarithm' },
        { latex: '\\ln(x)', label: 'Natural Log' },
        { latex: '\\exp(x)', label: 'Exponential' },
        { latex: '\\arcsin(x)', label: 'Arcsin' },
        { latex: '\\arccos(x)', label: 'Arccos' },
        { latex: '\\arctan(x)', label: 'Arctan' },
        { latex: '\\sinh(x)', label: 'Hyperbolic Sine' },
        { latex: '\\cosh(x)', label: 'Hyperbolic Cosine' },
        { latex: '\\tanh(x)', label: 'Hyperbolic Tangent' }
    ],
    operators: [
        { latex: '\\pm', label: 'Plus-Minus' },
        { latex: '\\mp', label: 'Minus-Plus' },
        { latex: '\\times', label: 'Times' },
        { latex: '\\div', label: 'Division' },
        { latex: '\\cdot', label: 'Dot' },
        { latex: '\\neq', label: 'Not Equal' },
        { latex: '\\leq', label: 'Less or Equal' },
        { latex: '\\geq', label: 'Greater or Equal' },
        { latex: '\\approx', label: 'Approximately' },
        { latex: '\\equiv', label: 'Equivalent' },
        { latex: '\\propto', label: 'Proportional' },
        { latex: '\\infty', label: 'Infinity' },
        { latex: '\\partial', label: 'Partial' },
        { latex: '\\nabla', label: 'Nabla' },
        { latex: '\\forall', label: 'For All' },
        { latex: '\\exists', label: 'Exists' },
        { latex: '\\in', label: 'Element Of' },
        { latex: '\\notin', label: 'Not Element Of' },
        { latex: '\\subset', label: 'Subset' },
        { latex: '\\supset', label: 'Superset' },
        { latex: '\\cup', label: 'Union' },
        { latex: '\\cap', label: 'Intersection' },
        { latex: '\\emptyset', label: 'Empty Set' },
        { latex: '\\mathbb{R}', label: 'Real Numbers' }
    ],
    greek: [
        { latex: '\\alpha', label: 'Alpha' },
        { latex: '\\beta', label: 'Beta' },
        { latex: '\\gamma', label: 'Gamma' },
        { latex: '\\delta', label: 'Delta' },
        { latex: '\\epsilon', label: 'Epsilon' },
        { latex: '\\zeta', label: 'Zeta' },
        { latex: '\\eta', label: 'Eta' },
        { latex: '\\theta', label: 'Theta' },
        { latex: '\\iota', label: 'Iota' },
        { latex: '\\kappa', label: 'Kappa' },
        { latex: '\\lambda', label: 'Lambda' },
        { latex: '\\mu', label: 'Mu' },
        { latex: '\\nu', label: 'Nu' },
        { latex: '\\xi', label: 'Xi' },
        { latex: '\\pi', label: 'Pi' },
        { latex: '\\rho', label: 'Rho' },
        { latex: '\\sigma', label: 'Sigma' },
        { latex: '\\tau', label: 'Tau' },
        { latex: '\\upsilon', label: 'Upsilon' },
        { latex: '\\phi', label: 'Phi' },
        { latex: '\\chi', label: 'Chi' },
        { latex: '\\psi', label: 'Psi' },
        { latex: '\\omega', label: 'Omega' },
        { latex: '\\Gamma', label: 'Gamma (Cap)' },
        { latex: '\\Delta', label: 'Delta (Cap)' },
        { latex: '\\Theta', label: 'Theta (Cap)' },
        { latex: '\\Lambda', label: 'Lambda (Cap)' },
        { latex: '\\Xi', label: 'Xi (Cap)' },
        { latex: '\\Pi', label: 'Pi (Cap)' },
        { latex: '\\Sigma', label: 'Sigma (Cap)' },
        { latex: '\\Phi', label: 'Phi (Cap)' },
        { latex: '\\Psi', label: 'Psi (Cap)' },
        { latex: '\\Omega', label: 'Omega (Cap)' }
    ],
    arrows: [
        { latex: '\\rightarrow', label: 'Right Arrow' },
        { latex: '\\leftarrow', label: 'Left Arrow' },
        { latex: '\\leftrightarrow', label: 'Left-Right Arrow' },
        { latex: '\\Rightarrow', label: 'Double Right' },
        { latex: '\\Leftarrow', label: 'Double Left' },
        { latex: '\\Leftrightarrow', label: 'Double Both' },
        { latex: '\\uparrow', label: 'Up Arrow' },
        { latex: '\\downarrow', label: 'Down Arrow' },
        { latex: '\\mapsto', label: 'Maps To' },
        { latex: '\\to', label: 'To' }
    ]
};

// Templates - Comprehensive Math Formula Library
const templates = [
    // Algebra (Expanded)
    {
        name: 'Quadratic Formula',
        latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
        category: 'Algebra'
    },
    {
        name: 'Completing the Square',
        latex: 'x^2 + bx + c = (x + \\frac{b}{2})^2 - (\\frac{b}{2})^2 + c',
        category: 'Algebra'
    },
    {
        name: 'Quadratic Sum',
        latex: '(a+b)^2 = a^2 + 2ab + b^2',
        category: 'Algebra'
    },
    {
        name: 'Quadratic Difference',
        latex: '(a-b)^2 = a^2 - 2ab + b^2',
        category: 'Algebra'
    },
    {
        name: 'Difference of Squares',
        latex: 'a^2 - b^2 = (a+b)(a-b)',
        category: 'Algebra'
    },
    {
        name: 'Sum of Cubes',
        latex: 'a^3 + b^3 = (a+b)(a^2 - ab + b^2)',
        category: 'Algebra'
    },
    {
        name: 'Difference of Cubes',
        latex: 'a^3 - b^3 = (a-b)(a^2 + ab + b^2)',
        category: 'Algebra'
    },
    {
        name: 'Cube of Sum',
        latex: '(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3',
        category: 'Algebra'
    },
    {
        name: 'Binomial Theorem',
        latex: '(x+y)^n = \\sum_{k=0}^{n} \\binom{n}{k} x^{n-k} y^k',
        category: 'Algebra'
    },
    {
        name: 'Logarithm Product',
        latex: '\\log_b(xy) = \\log_b(x) + \\log_b(y)',
        category: 'Algebra'
    },
    {
        name: 'Logarithm Quotient',
        latex: '\\log_b(\\frac{x}{y}) = \\log_b(x) - \\log_b(y)',
        category: 'Algebra'
    },
    {
        name: 'Logarithm Power',
        latex: '\\log_b(x^n) = n\\log_b(x)',
        category: 'Algebra'
    },
    {
        name: 'Change of Base',
        latex: '\\log_b(x) = \\frac{\\log_a(x)}{\\log_a(b)}',
        category: 'Algebra'
    },
    {
        name: 'Exponential Growth',
        latex: 'A(t) = A_0 e^{rt}',
        category: 'Algebra'
    },
    {
        name: 'Compound Interest',
        latex: 'A = P(1 + \\frac{r}{n})^{nt}',
        category: 'Algebra'
    },
    {
        name: 'Arithmetic Sequence',
        latex: 'a_n = a_1 + (n-1)d',
        category: 'Algebra'
    },
    {
        name: 'Geometric Sequence',
        latex: 'a_n = a_1 \\cdot r^{n-1}',
        category: 'Algebra'
    },
    {
        name: 'Arithmetic Series Sum',
        latex: 'S_n = \\frac{n}{2}(a_1 + a_n)',
        category: 'Algebra'
    },
    {
        name: 'Geometric Series Sum',
        latex: 'S_n = a_1\\frac{1-r^n}{1-r}',
        category: 'Algebra'
    },
    {
        name: 'Infinite Geometric Series',
        latex: 'S = \\frac{a}{1-r}, \\quad |r| < 1',
        category: 'Algebra'
    },
    {
        name: 'Complex Number',
        latex: 'z = a + bi, \\quad i = \\sqrt{-1}',
        category: 'Algebra'
    },
    {
        name: 'Complex Conjugate',
        latex: '\\overline{z} = a - bi',
        category: 'Algebra'
    },
    {
        name: 'Absolute Value Inequality',
        latex: '|x| < a \\iff -a < x < a',
        category: 'Algebra'
    },

    // Geometry (Expanded)
    {
        name: 'Pythagorean Theorem',
        latex: 'a^2 + b^2 = c^2',
        category: 'Geometry'
    },
    {
        name: 'Distance Formula',
        latex: 'd = \\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}',
        category: 'Geometry'
    },
    {
        name: 'Midpoint Formula',
        latex: 'M = \\left(\\frac{x_1+x_2}{2}, \\frac{y_1+y_2}{2}\\right)',
        category: 'Geometry'
    },
    {
        name: 'Circle Area',
        latex: 'A = \\pi r^2',
        category: 'Geometry'
    },
    {
        name: 'Circle Circumference',
        latex: 'C = 2\\pi r',
        category: 'Geometry'
    },
    {
        name: 'Circle Equation',
        latex: '(x-h)^2 + (y-k)^2 = r^2',
        category: 'Geometry'
    },
    {
        name: 'Triangle Area (Base-Height)',
        latex: 'A = \\frac{1}{2}bh',
        category: 'Geometry'
    },
    {
        name: 'Triangle Area (Heron\'s)',
        latex: 'A = \\sqrt{s(s-a)(s-b)(s-c)}, \\quad s = \\frac{a+b+c}{2}',
        category: 'Geometry'
    },
    {
        name: 'Rectangle Area',
        latex: 'A = lw',
        category: 'Geometry'
    },
    {
        name: 'Rectangle Perimeter',
        latex: 'P = 2(l+w)',
        category: 'Geometry'
    },
    {
        name: 'Trapezoid Area',
        latex: 'A = \\frac{1}{2}(b_1+b_2)h',
        category: 'Geometry'
    },
    {
        name: 'Regular Polygon Area',
        latex: 'A = \\frac{1}{4}ns^2\\cot\\left(\\frac{\\pi}{n}\\right)',
        category: 'Geometry'
    },
    {
        name: 'Ellipse Area',
        latex: 'A = \\pi ab',
        category: 'Geometry'
    },
    {
        name: 'Sector Area',
        latex: 'A = \\frac{1}{2}r^2\\theta',
        category: 'Geometry'
    },
    {
        name: 'Sphere Volume',
        latex: 'V = \\frac{4}{3}\\pi r^3',
        category: 'Geometry'
    },
    {
        name: 'Sphere Surface Area',
        latex: 'A = 4\\pi r^2',
        category: 'Geometry'
    },
    {
        name: 'Cylinder Volume',
        latex: 'V = \\pi r^2 h',
        category: 'Geometry'
    },
    {
        name: 'Cone Volume',
        latex: 'V = \\frac{1}{3}\\pi r^2 h',
        category: 'Geometry'
    },
    {
        name: 'Cube Volume',
        latex: 'V = s^3',
        category: 'Geometry'
    },
    {
        name: 'Rectangular Prism Volume',
        latex: 'V = lwh',
        category: 'Geometry'
    },

    // Trigonometry (Expanded)
    {
        name: 'Pythagorean Identity',
        latex: '\\sin^2\\theta + \\cos^2\\theta = 1',
        category: 'Trigonometry'
    },
    {
        name: 'Tangent Identity',
        latex: '\\tan^2\\theta + 1 = \\sec^2\\theta',
        category: 'Trigonometry'
    },
    {
        name: 'Cotangent Identity',
        latex: '1 + \\cot^2\\theta = \\csc^2\\theta',
        category: 'Trigonometry'
    },
    {
        name: 'Sine Law',
        latex: '\\frac{a}{\\sin A} = \\frac{b}{\\sin B} = \\frac{c}{\\sin C}',
        category: 'Trigonometry'
    },
    {
        name: 'Cosine Law',
        latex: 'c^2 = a^2 + b^2 - 2ab\\cos C',
        category: 'Trigonometry'
    },
    {
        name: 'Sum Formula (Sine)',
        latex: '\\sin(\\alpha \\pm \\beta) = \\sin\\alpha\\cos\\beta \\pm \\cos\\alpha\\sin\\beta',
        category: 'Trigonometry'
    },
    {
        name: 'Sum Formula (Cosine)',
        latex: '\\cos(\\alpha \\pm \\beta) = \\cos\\alpha\\cos\\beta \\mp \\sin\\alpha\\sin\\beta',
        category: 'Trigonometry'
    },
    {
        name: 'Sum Formula (Tangent)',
        latex: '\\tan(\\alpha \\pm \\beta) = \\frac{\\tan\\alpha \\pm \\tan\\beta}{1 \\mp \\tan\\alpha\\tan\\beta}',
        category: 'Trigonometry'
    },
    {
        name: 'Double Angle (Sine)',
        latex: '\\sin(2\\theta) = 2\\sin\\theta\\cos\\theta',
        category: 'Trigonometry'
    },
    {
        name: 'Double Angle (Cosine)',
        latex: '\\cos(2\\theta) = \\cos^2\\theta - \\sin^2\\theta',
        category: 'Trigonometry'
    },
    {
        name: 'Double Angle (Tangent)',
        latex: '\\tan(2\\theta) = \\frac{2\\tan\\theta}{1-\\tan^2\\theta}',
        category: 'Trigonometry'
    },
    {
        name: 'Half Angle (Sine)',
        latex: '\\sin\\frac{\\theta}{2} = \\pm\\sqrt{\\frac{1-\\cos\\theta}{2}}',
        category: 'Trigonometry'
    },
    {
        name: 'Half Angle (Cosine)',
        latex: '\\cos\\frac{\\theta}{2} = \\pm\\sqrt{\\frac{1+\\cos\\theta}{2}}',
        category: 'Trigonometry'
    },
    {
        name: 'Product-to-Sum',
        latex: '\\sin\\alpha\\cos\\beta = \\frac{1}{2}[\\sin(\\alpha+\\beta) + \\sin(\\alpha-\\beta)]',
        category: 'Trigonometry'
    },
    {
        name: 'Sum-to-Product',
        latex: '\\sin\\alpha + \\sin\\beta = 2\\sin\\frac{\\alpha+\\beta}{2}\\cos\\frac{\\alpha-\\beta}{2}',
        category: 'Trigonometry'
    },

    // Calculus (Expanded)
    {
        name: 'Derivative Definition',
        latex: 'f\'(x) = \\lim_{h \\to 0} \\frac{f(x+h) - f(x)}{h}',
        category: 'Calculus'
    },
    {
        name: 'Power Rule',
        latex: '\\frac{d}{dx}[x^n] = nx^{n-1}',
        category: 'Calculus'
    },
    {
        name: 'Chain Rule',
        latex: '\\frac{d}{dx}[f(g(x))] = f\'(g(x)) \\cdot g\'(x)',
        category: 'Calculus'
    },
    {
        name: 'Product Rule',
        latex: '\\frac{d}{dx}[f(x)g(x)] = f\'(x)g(x) + f(x)g\'(x)',
        category: 'Calculus'
    },
    {
        name: 'Quotient Rule',
        latex: '\\frac{d}{dx}\\left[\\frac{f(x)}{g(x)}\\right] = \\frac{f\'(x)g(x) - f(x)g\'(x)}{[g(x)]^2}',
        category: 'Calculus'
    },
    {
        name: 'Exponential Derivative',
        latex: '\\frac{d}{dx}[e^x] = e^x',
        category: 'Calculus'
    },
    {
        name: 'Logarithm Derivative',
        latex: '\\frac{d}{dx}[\\ln x] = \\frac{1}{x}',
        category: 'Calculus'
    },
    {
        name: 'Sine Derivative',
        latex: '\\frac{d}{dx}[\\sin x] = \\cos x',
        category: 'Calculus'
    },
    {
        name: 'Cosine Derivative',
        latex: '\\frac{d}{dx}[\\cos x] = -\\sin x',
        category: 'Calculus'
    },
    {
        name: 'Fundamental Theorem',
        latex: '\\int_{a}^{b} f(x) dx = F(b) - F(a)',
        category: 'Calculus'
    },
    {
        name: 'Integration by Parts',
        latex: '\\int u \\, dv = uv - \\int v \\, du',
        category: 'Calculus'
    },
    {
        name: 'U-Substitution',
        latex: '\\int f(g(x))g\'(x)dx = \\int f(u)du',
        category: 'Calculus'
    },
    {
        name: 'Power Integral',
        latex: '\\int x^n dx = \\frac{x^{n+1}}{n+1} + C, \\quad n \\neq -1',
        category: 'Calculus'
    },
    {
        name: 'Exponential Integral',
        latex: '\\int e^x dx = e^x + C',
        category: 'Calculus'
    },
    {
        name: 'Logarithm Integral',
        latex: '\\int \\frac{1}{x} dx = \\ln|x| + C',
        category: 'Calculus'
    },
    {
        name: 'Mean Value Theorem',
        latex: 'f\'(c) = \\frac{f(b)-f(a)}{b-a}',
        category: 'Calculus'
    },
    {
        name: 'L\'Hôpital\'s Rule',
        latex: '\\lim_{x \\to c} \\frac{f(x)}{g(x)} = \\lim_{x \\to c} \\frac{f\'(x)}{g\'(x)}',
        category: 'Calculus'
    },

    // Analysis
    {
        name: 'Euler\'s Identity',
        latex: 'e^{i\\pi} + 1 = 0',
        category: 'Analysis'
    },
    {
        name: 'Taylor Series',
        latex: 'f(x) = \\sum_{n=0}^{\\infty} \\frac{f^{(n)}(a)}{n!}(x-a)^n',
        category: 'Analysis'
    },
    {
        name: 'Maclaurin Series',
        latex: 'e^x = \\sum_{n=0}^{\\infty} \\frac{x^n}{n!}',
        category: 'Analysis'
    },
    {
        name: 'Cauchy-Schwarz',
        latex: '|\\langle u, v \\rangle| \\leq \\|u\\| \\|v\\|',
        category: 'Analysis'
    },
    {
        name: 'Fourier Transform',
        latex: 'F(\\omega) = \\int_{-\\infty}^{\\infty} f(t) e^{-i\\omega t} dt',
        category: 'Analysis'
    },
    {
        name: 'Laplace Transform',
        latex: 'F(s) = \\int_{0}^{\\infty} f(t) e^{-st} dt',
        category: 'Analysis'
    },

    // Linear Algebra (Expanded)
    {
        name: 'Matrix Multiplication',
        latex: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix} \\begin{pmatrix}e & f\\\\g & h\\end{pmatrix} = \\begin{pmatrix}ae+bg & af+bh\\\\ce+dg & cf+dh\\end{pmatrix}',
        category: 'Linear Algebra'
    },
    {
        name: '2×2 Determinant',
        latex: '\\det(A) = \\begin{vmatrix}a & b\\\\c & d\\end{vmatrix} = ad - bc',
        category: 'Linear Algebra'
    },
    {
        name: '3×3 Determinant',
        latex: '\\det(A) = a(ei-fh) - b(di-fg) + c(dh-eg)',
        category: 'Linear Algebra'
    },
    {
        name: 'Matrix Transpose',
        latex: '(A^T)_{ij} = A_{ji}',
        category: 'Linear Algebra'
    },
    {
        name: 'Matrix Inverse',
        latex: 'A^{-1} = \\frac{1}{\\det(A)} \\text{adj}(A)',
        category: 'Linear Algebra'
    },
    {
        name: '2×2 Matrix Inverse',
        latex: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix}^{-1} = \\frac{1}{ad-bc}\\begin{pmatrix}d & -b\\\\-c & a\\end{pmatrix}',
        category: 'Linear Algebra'
    },
    {
        name: 'Eigenvalue Equation',
        latex: 'Av = \\lambda v',
        category: 'Linear Algebra'
    },
    {
        name: 'Characteristic Equation',
        latex: '\\det(A - \\lambda I) = 0',
        category: 'Linear Algebra'
    },
    {
        name: 'Dot Product',
        latex: '\\vec{a} \\cdot \\vec{b} = |\\vec{a}||\\vec{b}|\\cos\\theta',
        category: 'Linear Algebra'
    },
    {
        name: 'Cross Product',
        latex: '\\vec{a} \\times \\vec{b} = |\\vec{a}||\\vec{b}|\\sin\\theta\\,\\vec{n}',
        category: 'Linear Algebra'
    },
    {
        name: 'Vector Magnitude',
        latex: '|\\vec{v}| = \\sqrt{v_1^2 + v_2^2 + v_3^2}',
        category: 'Linear Algebra'
    },
    {
        name: 'Unit Vector',
        latex: '\\hat{v} = \\frac{\\vec{v}}{|\\vec{v}|}',
        category: 'Linear Algebra'
    },
    {
        name: 'Projection',
        latex: '\\text{proj}_{\\vec{b}}\\vec{a} = \\frac{\\vec{a} \\cdot \\vec{b}}{|\\vec{b}|^2}\\vec{b}',
        category: 'Linear Algebra'
    },
    {
        name: 'Gram-Schmidt',
        latex: '\\vec{v}_k = \\vec{u}_k - \\sum_{j=1}^{k-1} \\text{proj}_{\\vec{v}_j}\\vec{u}_k',
        category: 'Linear Algebra'
    },

    // Statistics & Probability
    {
        name: 'Normal Distribution',
        latex: 'f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} e^{-\\frac{(x-\\mu)^2}{2\\sigma^2}}',
        category: 'Statistics'
    },
    {
        name: 'Mean (Average)',
        latex: '\\bar{x} = \\frac{1}{n}\\sum_{i=1}^{n} x_i',
        category: 'Statistics'
    },
    {
        name: 'Variance',
        latex: '\\sigma^2 = \\frac{1}{n}\\sum_{i=1}^{n} (x_i - \\mu)^2',
        category: 'Statistics'
    },
    {
        name: 'Standard Deviation',
        latex: '\\sigma = \\sqrt{\\frac{1}{n}\\sum_{i=1}^{n} (x_i - \\mu)^2}',
        category: 'Statistics'
    },
    {
        name: 'Bayes\' Theorem',
        latex: 'P(A|B) = \\frac{P(B|A)P(A)}{P(B)}',
        category: 'Statistics'
    },
    {
        name: 'Binomial Probability',
        latex: 'P(X=k) = \\binom{n}{k} p^k (1-p)^{n-k}',
        category: 'Statistics'
    },

    // Combinatorics (Expanded)
    {
        name: 'Permutations',
        latex: 'P(n,r) = \\frac{n!}{(n-r)!}',
        category: 'Combinatorics'
    },
    {
        name: 'Combinations',
        latex: 'C(n,r) = \\binom{n}{r} = \\frac{n!}{r!(n-r)!}',
        category: 'Combinatorics'
    },
    {
        name: 'Permutations with Repetition',
        latex: 'P = \\frac{n!}{n_1!n_2!\\cdots n_k!}',
        category: 'Combinatorics'
    },
    {
        name: 'Circular Permutations',
        latex: 'P_{\\text{circular}} = (n-1)!',
        category: 'Combinatorics'
    },
    {
        name: 'Stars and Bars',
        latex: '\\binom{n+k-1}{k-1}',
        category: 'Combinatorics'
    },
    {
        name: 'Inclusion-Exclusion',
        latex: '|A \\cup B| = |A| + |B| - |A \\cap B|',
        category: 'Combinatorics'
    },
    {
        name: 'Pascal\'s Identity',
        latex: '\\binom{n}{k} = \\binom{n-1}{k-1} + \\binom{n-1}{k}',
        category: 'Combinatorics'
    },
    {
        name: 'Vandermonde Identity',
        latex: '\\binom{m+n}{r} = \\sum_{k=0}^{r} \\binom{m}{k}\\binom{n}{r-k}',
        category: 'Combinatorics'
    },
    {
        name: 'Multinomial Coefficient',
        latex: '\\binom{n}{k_1, k_2, \\ldots, k_m} = \\frac{n!}{k_1!k_2!\\cdots k_m!}',
        category: 'Combinatorics'
    },
    {
        name: 'Derangements',
        latex: 'D_n = n!\\sum_{k=0}^{n} \\frac{(-1)^k}{k!}',
        category: 'Combinatorics'
    },

    // Differential Equations (Expanded)
    {
        name: 'First Order Linear',
        latex: '\\frac{dy}{dx} + P(x)y = Q(x)',
        category: 'Differential Equations'
    },
    {
        name: 'Separable Equation',
        latex: '\\frac{dy}{dx} = f(x)g(y)',
        category: 'Differential Equations'
    },
    {
        name: 'Exact Equation',
        latex: 'M(x,y)dx + N(x,y)dy = 0, \\quad \\frac{\\partial M}{\\partial y} = \\frac{\\partial N}{\\partial x}',
        category: 'Differential Equations'
    },
    {
        name: 'Second Order Homogeneous',
        latex: 'ay\'\' + by\' + cy = 0',
        category: 'Differential Equations'
    },
    {
        name: 'Second Order Non-Homogeneous',
        latex: 'ay\'\' + by\' + cy = f(x)',
        category: 'Differential Equations'
    },
    {
        name: 'Characteristic Equation',
        latex: 'ar^2 + br + c = 0',
        category: 'Differential Equations'
    },
    {
        name: 'Euler\'s Method',
        latex: 'y_{n+1} = y_n + hf(x_n, y_n)',
        category: 'Differential Equations'
    },
    {
        name: 'Bernoulli Equation',
        latex: '\\frac{dy}{dx} + P(x)y = Q(x)y^n',
        category: 'Differential Equations'
    },
    {
        name: 'Homogeneous Equation',
        latex: '\\frac{dy}{dx} = f\\left(\\frac{y}{x}\\right)',
        category: 'Differential Equations'
    },

    // Number Theory (Expanded)
    {
        name: 'Division Algorithm',
        latex: 'a = bq + r, \\quad 0 \\leq r < b',
        category: 'Number Theory'
    },
    {
        name: 'Euclidean Algorithm',
        latex: '\\gcd(a,b) = \\gcd(b, a \\bmod b)',
        category: 'Number Theory'
    },
    {
        name: 'Fermat\'s Little Theorem',
        latex: 'a^{p-1} \\equiv 1 \\pmod{p}',
        category: 'Number Theory'
    },
    {
        name: 'Euler\'s Theorem',
        latex: 'a^{\\phi(n)} \\equiv 1 \\pmod{n}',
        category: 'Number Theory'
    },
    {
        name: 'Euler\'s Totient',
        latex: '\\phi(n) = n\\prod_{p|n}\\left(1 - \\frac{1}{p}\\right)',
        category: 'Number Theory'
    },
    {
        name: 'Chinese Remainder',
        latex: 'x \\equiv a_i \\pmod{n_i}, \\quad \\gcd(n_i,n_j) = 1',
        category: 'Number Theory'
    },
    {
        name: 'Wilson\'s Theorem',
        latex: '(p-1)! \\equiv -1 \\pmod{p}',
        category: 'Number Theory'
    },
    {
        name: 'Prime Number Theorem',
        latex: '\\pi(x) \\sim \\frac{x}{\\ln x}',
        category: 'Number Theory'
    },
    {
        name: 'Sum of Divisors',
        latex: '\\sigma(n) = \\sum_{d|n} d',
        category: 'Number Theory'
    },
    {
        name: 'Möbius Function',
        latex: '\\mu(n) = \\begin{cases}1 & n=1\\\\(-1)^k & n=p_1\\cdots p_k\\\\0 & \\text{otherwise}\\end{cases}',
        category: 'Number Theory'
    },

    // Physics (Expanded)
    {
        name: 'Newton\'s 2nd Law',
        latex: 'F = ma',
        category: 'Physics'
    },
    {
        name: 'Universal Gravitation',
        latex: 'F = G\\frac{m_1m_2}{r^2}',
        category: 'Physics'
    },
    {
        name: 'Kinetic Energy',
        latex: 'KE = \\frac{1}{2}mv^2',
        category: 'Physics'
    },
    {
        name: 'Potential Energy',
        latex: 'PE = mgh',
        category: 'Physics'
    },
    {
        name: 'Work-Energy Theorem',
        latex: 'W = \\Delta KE = \\frac{1}{2}m(v_f^2 - v_i^2)',
        category: 'Physics'
    },
    {
        name: 'Momentum',
        latex: 'p = mv',
        category: 'Physics'
    },
    {
        name: 'Impulse',
        latex: 'J = \\Delta p = F\\Delta t',
        category: 'Physics'
    },
    {
        name: 'Conservation of Momentum',
        latex: 'm_1v_{1i} + m_2v_{2i} = m_1v_{1f} + m_2v_{2f}',
        category: 'Physics'
    },
    {
        name: 'Einstein\'s Equation',
        latex: 'E = mc^2',
        category: 'Physics'
    },
    {
        name: 'Kinematic Equation 1',
        latex: 'v = v_0 + at',
        category: 'Physics'
    },
    {
        name: 'Kinematic Equation 2',
        latex: 'x = x_0 + v_0t + \\frac{1}{2}at^2',
        category: 'Physics'
    },
    {
        name: 'Kinematic Equation 3',
        latex: 'v^2 = v_0^2 + 2a(x-x_0)',
        category: 'Physics'
    },
    {
        name: 'Centripetal Acceleration',
        latex: 'a_c = \\frac{v^2}{r}',
        category: 'Physics'
    },
    {
        name: 'Angular Momentum',
        latex: 'L = I\\omega',
        category: 'Physics'
    },
    {
        name: 'Torque',
        latex: '\\tau = rF\\sin\\theta',
        category: 'Physics'
    },
    {
        name: 'Ideal Gas Law',
        latex: 'PV = nRT',
        category: 'Physics'
    },
    {
        name: 'Ohm\'s Law',
        latex: 'V = IR',
        category: 'Physics'
    },
    {
        name: 'Electric Power',
        latex: 'P = IV = I^2R = \\frac{V^2}{R}',
        category: 'Physics'
    },
    {
        name: 'Coulomb\'s Law',
        latex: 'F = k\\frac{q_1q_2}{r^2}',
        category: 'Physics'
    },
    {
        name: 'Schrödinger Equation',
        latex: 'i\\hbar\\frac{\\partial}{\\partial t}\\Psi = \\hat{H}\\Psi',
        category: 'Physics'
    },
    {
        name: 'Wave Equation',
        latex: 'v = f\\lambda',
        category: 'Physics'
    },
    {
        name: 'Snell\'s Law',
        latex: 'n_1\\sin\\theta_1 = n_2\\sin\\theta_2',
        category: 'Physics'
    }
];

/**
 * Initialize the editor
 */
function init() {
    // Populate symbol buttons
    populateSymbolGrid('structuresGrid', latexSymbols.structures);
    populateSymbolGrid('functionsGrid', latexSymbols.functions);
    populateSymbolGrid('operatorsGrid', latexSymbols.operators);
    populateSymbolGrid('greekGrid', latexSymbols.greek);
    populateSymbolGrid('arrowsGrid', latexSymbols.arrows);

    // Populate templates for both desktop and mobile
    populateTemplates('desktopTemplatesContainer', 'desktopTemplateSearch');
    populateTemplates('mobileTemplatesContainer', 'mobileTemplateSearch');

    // Initial preview
    updatePreview();

    // Add input listener for auto-preview
    document.getElementById('latexInput').addEventListener('input', function() {
        if (autoPreviewEnabled) {
            updatePreview();
        }
    });

    // Load from URL if present
    loadFromURL();
}

/**
 * Populate symbol button grid
 */
function populateSymbolGrid(gridId, symbols) {
    const grid = document.getElementById(gridId);
    grid.innerHTML = '';

    symbols.forEach(symbol => {
        const btn = document.createElement('button');
        btn.className = 'symbol-btn';
        btn.onclick = () => insertLatex(symbol.latex, symbol.cursor);

        const previewDiv = document.createElement('div');
        previewDiv.className = 'preview';
        try {
            katex.render(symbol.latex, previewDiv, {
                throwOnError: false,
                displayMode: false
            });
        } catch (e) {
            previewDiv.textContent = symbol.latex;
        }

        const labelDiv = document.createElement('div');
        labelDiv.className = 'label';
        labelDiv.textContent = symbol.label;

        btn.appendChild(previewDiv);
        btn.appendChild(labelDiv);
        grid.appendChild(btn);
    });
}

/**
 * Populate templates with collapsible categories and search
 */
function populateTemplates(containerId, searchBoxId) {
    const container = document.getElementById(containerId);
    if (!container) return; // Container doesn't exist (e.g., mobile view when desktop)

    container.innerHTML = '';

    // Get existing search box
    const searchBox = document.getElementById(searchBoxId);
    if (!searchBox) return;

    // Group templates by category
    const categorized = {};
    templates.forEach(template => {
        if (!categorized[template.category]) {
            categorized[template.category] = [];
        }
        categorized[template.category].push(template);
    });

    // Create collapsible sections for each category
    Object.keys(categorized).sort().forEach((category, index) => {
        const categorySection = document.createElement('div');
        categorySection.className = 'template-category-section mb-2';

        // Category header (clickable)
        const categoryHeader = document.createElement('div');
        categoryHeader.className = 'template-category-header';
        categoryHeader.innerHTML = `
            <i class="fas fa-chevron-down category-icon"></i>
            <span class="category-name">${category}</span>
            <span class="badge bg-secondary ms-auto">${categorized[category].length}</span>
        `;
        categoryHeader.onclick = function() {
            const content = this.nextElementSibling;
            const icon = this.querySelector('.category-icon');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                icon.classList.remove('fa-chevron-right');
                icon.classList.add('fa-chevron-down');
            } else {
                content.style.display = 'none';
                icon.classList.remove('fa-chevron-down');
                icon.classList.add('fa-chevron-right');
            }
        };

        // Category content (templates)
        const categoryContent = document.createElement('div');
        categoryContent.className = 'template-category-content';
        categoryContent.style.display = 'none'; // All categories closed by default

        categorized[category].forEach(template => {
            const card = document.createElement('div');
            card.className = 'template-card';
            card.setAttribute('data-name', template.name.toLowerCase());
            card.setAttribute('data-category', category.toLowerCase());
            card.onclick = () => loadTemplate(template.latex);

            const name = document.createElement('div');
            name.className = 'name';
            name.textContent = template.name;

            const preview = document.createElement('div');
            preview.className = 'preview-small';
            try {
                katex.render(template.latex, preview, {
                    throwOnError: false,
                    displayMode: true
                });
            } catch (e) {
                preview.textContent = 'Error rendering';
            }

            card.appendChild(name);
            card.appendChild(preview);
            categoryContent.appendChild(card);
        });

        // Update icon - all categories start closed
        categoryHeader.querySelector('.category-icon').classList.remove('fa-chevron-down');
        categoryHeader.querySelector('.category-icon').classList.add('fa-chevron-right');

        categorySection.appendChild(categoryHeader);
        categorySection.appendChild(categoryContent);
        container.appendChild(categorySection);
    });

    // Search functionality
    searchBox.addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const allCards = container.querySelectorAll('.template-card');
        const allCategories = container.querySelectorAll('.template-category-section');

        if (searchTerm === '') {
            // Reset view
            allCards.forEach(card => card.style.display = 'block');
            allCategories.forEach(cat => cat.style.display = 'block');
        } else {
            // Filter templates
            allCards.forEach(card => {
                const name = card.getAttribute('data-name');
                const category = card.getAttribute('data-category');
                if (name.includes(searchTerm) || category.includes(searchTerm)) {
                    card.style.display = 'block';
                    // Show parent category and expand it
                    const parent = card.closest('.template-category-section');
                    parent.style.display = 'block';
                    const content = parent.querySelector('.template-category-content');
                    const icon = parent.querySelector('.category-icon');
                    content.style.display = 'block';
                    icon.classList.remove('fa-chevron-right');
                    icon.classList.add('fa-chevron-down');
                } else {
                    card.style.display = 'none';
                }
            });

            // Hide empty categories
            allCategories.forEach(cat => {
                const visibleCards = cat.querySelectorAll('.template-card[style*="display: block"]');
                if (visibleCards.length === 0) {
                    cat.style.display = 'none';
                }
            });
        }
    });
}

/**
 * Insert LaTeX at cursor position
 */
function insertLatex(latex, cursorOffset = 0) {
    const input = document.getElementById('latexInput');
    const start = input.selectionStart;
    const end = input.selectionEnd;
    const text = input.value;

    // Insert latex at cursor
    const newText = text.substring(0, start) + latex + text.substring(end);
    input.value = newText;

    // Set cursor position
    const newCursorPos = start + (cursorOffset || latex.length);
    input.focus();
    input.setSelectionRange(newCursorPos, newCursorPos);

    if (autoPreviewEnabled) {
        updatePreview();
    }
}

/**
 * Load template
 */
function loadTemplate(latex) {
    document.getElementById('latexInput').value = latex;
    updatePreview();
    showMessage('Template loaded!', 'success');
}

/**
 * Update preview
 */
function updatePreview() {
    const input = document.getElementById('latexInput').value;
    const preview = document.getElementById('preview');
    const errorMsg = document.getElementById('errorMessage');

    errorMsg.style.display = 'none';

    if (!input.trim()) {
        preview.innerHTML = '<span style="color: #999;">Enter LaTeX code to see preview...</span>';
        return;
    }

    try {
        katex.render(input, preview, {
            throwOnError: true,
            displayMode: true
        });
    } catch (error) {
        errorMsg.textContent = 'LaTeX Error: ' + error.message;
        errorMsg.style.display = 'block';
        preview.innerHTML = '<span style="color: #dc3545;">Invalid LaTeX syntax</span>';
    }
}

/**
 * Clear input
 */
function clearInput() {
    if (confirm('Clear all input?')) {
        document.getElementById('latexInput').value = '';
        updatePreview();
    }
}

/**
 * Copy LaTeX to clipboard
 */
function copyLatex() {
    const input = document.getElementById('latexInput');
    input.select();
    document.execCommand('copy');
    showMessage('LaTeX code copied to clipboard!', 'success');
}

/**
 * Toggle auto-preview
 */
function toggleAutoPreview() {
    autoPreviewEnabled = document.getElementById('autoPreview').checked;
}

/**
 * Show message
 */
function showMessage(message, type) {
    const msgElement = document.getElementById(type === 'success' ? 'successMessage' : 'errorMessage');
    msgElement.textContent = message;
    msgElement.style.display = 'block';

    setTimeout(() => {
        msgElement.style.display = 'none';
    }, 3000);
}

/**
 * Export as PNG
 */
/**
 * Export as PNG using html2canvas
 */
async function exportAsImage() {
    const preview = document.getElementById('preview');
    const latexInput = document.getElementById('latexInput').value;

    if (!latexInput.trim() || preview.textContent.includes('Enter LaTeX code') || preview.textContent.includes('Invalid LaTeX')) {
        alert('No equation to export. Please enter valid LaTeX code and update preview first.');
        return;
    }

    // Get the rendered equation from preview
    const katexElement = preview.querySelector('.katex');
    if (!katexElement) {
        alert('No rendered equation found. Please update preview first.');
        return;
    }

    try {
        // Check if html2canvas is loaded
        if (typeof html2canvas === 'undefined') {
            alert('html2canvas library not loaded. Please refresh the page.');
            return;
        }

        // Create a temporary container with better styling
        const container = document.createElement('div');
        container.style.cssText = `
            position: fixed;
            top: -10000px;
            left: -10000px;
            background: white;
            padding: 80px;
            display: inline-block;
        `;

        // Clone and enlarge the equation for better quality
        const clonedEquation = katexElement.cloneNode(true);
        clonedEquation.style.fontSize = '72px';
        container.appendChild(clonedEquation);
        document.body.appendChild(container);

        // Wait for fonts and rendering
        await new Promise(resolve => setTimeout(resolve, 200));

        // Use html2canvas to capture the element
        const canvas = await html2canvas(container, {
            backgroundColor: '#ffffff',
            scale: 2,
            logging: false,
            useCORS: true
        });

        // Remove temporary container
        if (container.parentNode) {
            container.parentNode.removeChild(container);
        }

        // Download the canvas as PNG
        canvas.toBlob(function(blob) {
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.download = '8gwifi.org-math-' + Date.now() + '.png';
            link.href = url;
            link.click();
            URL.revokeObjectURL(url);
            showMessage('PNG image downloaded!', 'success');
        }, 'image/png');

    } catch (error) {
        console.error('PNG Export Error:', error);
        alert('PNG export failed: ' + error.message);
    }
}

/**
 * Export as SVG
 */
/**
 * Export as SVG
 */
/**
 * Export as SVG (Fixed version with full KaTeX CSS)
 */
async function exportAsSVG() {
    const preview = document.getElementById('preview');
    const latexInput = document.getElementById('latexInput').value;

    if (!latexInput.trim() || preview.textContent.includes('Enter LaTeX code') || preview.textContent.includes('Invalid LaTeX')) {
        alert('No equation to export. Please enter valid LaTeX code and update preview first.');
        return;
    }

    // Fetch full KaTeX CSS asynchronously
    let katexCSS;
    try {
        const response = await fetch('https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css');
        katexCSS = await response.text();
    } catch (error) {
        console.error('Failed to fetch KaTeX CSS:', error);
        alert('Error loading KaTeX styles for export. Please check your internet connection.');
        return;
    }

    // Create a temporary container with proper styling
    const container = document.createElement('div');
    container.style.cssText = `
        position: absolute;
        left: -9999px;
        background: white;
        padding: 40px;
        font-size: 32px;
        display: inline-block;
    `;
    document.body.appendChild(container);

    // Render the equation in the container
    try {
        katex.render(latexInput, container, {
            throwOnError: true,
            displayMode: true
        });
    } catch (e) {
        document.body.removeChild(container);
        alert('Error rendering equation: ' + e.message);
        return;
    }

    // Wait a bit for rendering to complete
    await new Promise(resolve => setTimeout(resolve, 100));

    const rect = container.getBoundingClientRect();
    const padding = 40;

    // Create SVG with foreignObject containing the rendered equation + full CSS
    const svgData = `
        <svg xmlns="http://www.w3.org/2000/svg" width="${rect.width + padding * 2}" height="${rect.height + padding * 2}">
            <rect width="100%" height="100%" fill="white"/>
            <style>${katexCSS}</style>
            <foreignObject x="${padding}" y="${padding}" width="${rect.width}" height="${rect.height}">
                <div xmlns="http://www.w3.org/1999/xhtml">
                    ${container.innerHTML}
                </div>
            </foreignObject>
        </svg>
    `;

    document.body.removeChild(container);

    // Download the SVG
    const blob = new Blob([svgData], {type: 'image/svg+xml;charset=utf-8'});
    const url = URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.download = '8gwifi.org-math-equation-' + Date.now() + '.svg';
    link.href = url;
    link.click();

    URL.revokeObjectURL(url);
    showMessage('SVG image downloaded! (Fixed rendering)', 'success');
}

/**
 * Share equation
 */
function shareEquation() {
    const latex = document.getElementById('latexInput').value;
    if (!latex.trim()) {
        alert('Please enter LaTeX code first.');
        return;
    }

    // Encode LaTeX to base64
    const encoded = btoa(encodeURIComponent(latex));
    const url = window.location.origin + window.location.pathname + '?eq=' + encoded;

    // Copy to clipboard
    navigator.clipboard.writeText(url).then(() => {
        showMessage('Share link copied to clipboard!', 'success');
    }).catch(() => {
        // Fallback
        prompt('Copy this link:', url);
    });
}

/**
 * Load from URL
 */
function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const encoded = urlParams.get('eq');

    if (encoded) {
        try {
            const latex = decodeURIComponent(atob(encoded));
            document.getElementById('latexInput').value = latex;
            updatePreview();
        } catch (e) {
            console.error('Error loading from URL:', e);
        }
    }
}

/**
 * ============================================
 * SESSION STORAGE FUNCTIONS
 * ============================================
 */

// Storage keys
const STORAGE_KEY = 'latex_saved_equations';
const AUTO_SAVE_KEY = 'latex_auto_save';
const AUTO_SAVE_ENABLED_KEY = 'latex_auto_save_enabled';

// Auto-save state
let autoSaveEnabled = true;
let autoSaveTimer = null;

/**
 * Get all saved equations from session storage
 */
function getSavedEquations() {
    try {
        const saved = sessionStorage.getItem(STORAGE_KEY);
        return saved ? JSON.parse(saved) : [];
    } catch (e) {
        console.error('Error reading saved equations:', e);
        return [];
    }
}

/**
 * Save equations to session storage
 */
function setSavedEquations(equations) {
    try {
        sessionStorage.setItem(STORAGE_KEY, JSON.stringify(equations));
        updateSavedEquationsList();
    } catch (e) {
        console.error('Error saving equations:', e);
        showMessage('Error saving equation. Storage may be full.', 'error');
    }
}

/**
 * Save current equation
 */
function saveEquation() {
    const latex = document.getElementById('latexInput').value.trim();

    if (!latex) {
        showMessage('Please enter an equation to save', 'error');
        return;
    }

    const equations = getSavedEquations();

    // Check if equation already exists
    const exists = equations.some(eq => eq.latex === latex);
    if (exists) {
        showMessage('This equation is already saved', 'error');
        return;
    }

    // Add new equation
    const newEquation = {
        id: Date.now(),
        latex: latex,
        timestamp: new Date().toISOString(),
        preview: latex.substring(0, 50) + (latex.length > 50 ? '...' : '')
    };

    equations.unshift(newEquation); // Add to beginning

    // Limit to 20 saved equations
    if (equations.length > 20) {
        equations.pop();
    }

    setSavedEquations(equations);
    showMessage('Equation saved successfully!', 'success');
}

/**
 * Load saved equation
 */
function loadSavedEquation(id) {
    const equations = getSavedEquations();
    const equation = equations.find(eq => eq.id === id);

    if (equation) {
        document.getElementById('latexInput').value = equation.latex;
        updatePreview();
        showMessage('Equation loaded!', 'success');

        // Scroll to top
        window.scrollTo({top: 0, behavior: 'smooth'});
    }
}

/**
 * Delete saved equation
 */
function deleteSavedEquation(id) {
    if (!confirm('Delete this saved equation?')) {
        return;
    }

    let equations = getSavedEquations();
    equations = equations.filter(eq => eq.id !== id);
    setSavedEquations(equations);
    showMessage('Equation deleted', 'success');
}

/**
 * Clear all saved equations
 */
function clearAllSaved() {
    if (!confirm('Delete all saved equations? This cannot be undone.')) {
        return;
    }

    sessionStorage.removeItem(STORAGE_KEY);
    updateSavedEquationsList();
    showMessage('All saved equations cleared', 'success');
}

/**
 * Update saved equations list UI
 */
function updateSavedEquationsList() {
    const container = document.getElementById('savedEquationsList');
    const countBadge = document.getElementById('savedCount');
    const equations = getSavedEquations();

    countBadge.textContent = equations.length;

    if (equations.length === 0) {
        container.innerHTML = `
            <div class="empty-saved-state">
                <div><i class="fas fa-inbox"></i></div>
                <div>No saved equations yet</div>
                <small>Click "Save Current" to store your equations</small>
            </div>
        `;
        return;
    }

    container.innerHTML = equations.map(eq => {
        const date = new Date(eq.timestamp);
        const timeStr = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
        const dateStr = date.toLocaleDateString();

        return `
            <div class="saved-equation-item">
                <div class="saved-equation-preview" onclick="loadSavedEquation(${eq.id})">
                    <div style="flex: 1; overflow: hidden;">
                        <div class="rendered-preview" id="saved-preview-${eq.id}"></div>
                        <div class="saved-equation-meta">
                            <i class="fas fa-clock"></i> ${timeStr} - ${dateStr}
                        </div>
                    </div>
                </div>
                <div class="saved-equation-actions">
                    <button onclick="loadSavedEquation(${eq.id})" title="Load equation">
                        <i class="fas fa-upload"></i>
                    </button>
                    <button class="delete-btn" onclick="deleteSavedEquation(${eq.id})" title="Delete">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');

    // Render previews
    equations.forEach(eq => {
        const previewEl = document.getElementById(`saved-preview-${eq.id}`);
        if (previewEl) {
            try {
                katex.render(eq.latex, previewEl, {
                    throwOnError: false,
                    displayMode: false
                });
            } catch (e) {
                previewEl.textContent = eq.preview;
            }
        }
    });
}

/**
 * Auto-save functionality
 */
function autoSave() {
    if (!autoSaveEnabled) return;

    const latex = document.getElementById('latexInput').value.trim();
    if (latex) {
        sessionStorage.setItem(AUTO_SAVE_KEY, latex);
    }
}

/**
 * Load auto-saved equation
 */
function loadAutoSaved() {
    const autoSaved = sessionStorage.getItem(AUTO_SAVE_KEY);
    if (autoSaved) {
        const current = document.getElementById('latexInput').value.trim();

        // Only load if current input is empty or default
        const defaultValue = 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}';
        if (!current || current === defaultValue) {
            document.getElementById('latexInput').value = autoSaved;
            updatePreview();
        }
    }
}

/**
 * Toggle auto-save
 */
function toggleAutoSave() {
    autoSaveEnabled = document.getElementById('autoSave').checked;
    sessionStorage.setItem(AUTO_SAVE_ENABLED_KEY, autoSaveEnabled);

    if (autoSaveEnabled) {
        showMessage('Auto-save enabled', 'success');
        setupAutoSave();
    } else {
        showMessage('Auto-save disabled', 'success');
        if (autoSaveTimer) {
            clearInterval(autoSaveTimer);
        }
    }
}

/**
 * Setup auto-save timer
 */
function setupAutoSave() {
    // Clear existing timer
    if (autoSaveTimer) {
        clearInterval(autoSaveTimer);
    }

    // Auto-save every 5 seconds
    autoSaveTimer = setInterval(autoSave, 5000);

    // Also save on input (debounced)
    let inputTimer;
    document.getElementById('latexInput').addEventListener('input', function() {
        clearTimeout(inputTimer);
        inputTimer = setTimeout(autoSave, 2000);
    });
}

/**
 * Initialize storage features
 */
function initStorage() {
    // Load auto-save preference
    const autoSavePref = sessionStorage.getItem(AUTO_SAVE_ENABLED_KEY);
    if (autoSavePref !== null) {
        autoSaveEnabled = autoSavePref === 'true';
        document.getElementById('autoSave').checked = autoSaveEnabled;
    }

    // Setup auto-save
    if (autoSaveEnabled) {
        setupAutoSave();
        loadAutoSaved();
    }

    // Load saved equations list
    updateSavedEquationsList();
}

// Initialize when page loads
window.addEventListener('DOMContentLoaded', function() {
    init();
    initStorage();
});
