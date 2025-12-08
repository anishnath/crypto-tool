<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules-math");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Math Module - sqrt, ceil, floor, sin, cos, log, factorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python math module - square roots, trigonometry, logarithms, factorials, GCD/LCM, and mathematical constants like pi and e. Includes built-in functions.">
    <meta name="keywords"
        content="python math, python math module, python sqrt, python ceil, python floor, python sin cos tan, python logarithm, python factorial, python pi, python gcd lcm">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Math Module - sqrt, ceil, floor, sin, cos, log, factorial">
    <meta property="og:description" content="Master Python math: built-in functions, trigonometry, logarithms, and more.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules-math.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <script>
        (function () {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Python Math Module",
        "description": "Master Python math module - square roots, trigonometry, logarithms, factorials, GCD/LCM, and mathematical constants.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Built-in math functions", "math module basics", "Trigonometric functions", "Logarithms", "Factorials and combinations", "GCD and LCM", "Math constants"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="modules-math">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Math</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Math Module</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python provides powerful mathematical capabilities through both built-in functions
                    and the <code>math</code> module. From basic operations like finding minimum/maximum values to
                    advanced functions like trigonometry, logarithms, and factorials - Python has you covered for
                    scientific computing, game development, data analysis, and any math-heavy application!</p>

                    <!-- Section 1: Built-in Functions -->
                    <h2>Built-in Math Functions</h2>
                    <p>Python includes several math functions that don't require any imports. These built-in functions
                    handle common operations: finding extremes with <code>min()</code> and <code>max()</code>,
                    absolute values with <code>abs()</code>, powers with <code>pow()</code>, and rounding with
                    <code>round()</code>. They work with both integers and floats.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/math-builtin.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-builtin" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>round() Behavior:</strong> Python uses "banker's rounding" (round half to even).
                        So <code>round(2.5)</code> gives 2, but <code>round(3.5)</code> gives 4. This reduces
                        cumulative rounding errors in large datasets. For traditional rounding, use
                        <code>math.floor(x + 0.5)</code> or the <code>decimal</code> module.
                    </div>

                    <!-- Section 2: math Module Basics -->
                    <h2>The math Module Basics</h2>
                    <p>The <code>math</code> module provides essential mathematical functions: square roots,
                    ceiling/floor operations, and important constants like <code>pi</code> and <code>e</code>.
                    Unlike built-in functions, you must import the math module first.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/math-module-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>ceil vs floor vs trunc:</strong><br>
                        <code>ceil()</code> rounds UP toward positive infinity<br>
                        <code>floor()</code> rounds DOWN toward negative infinity<br>
                        <code>trunc()</code> rounds TOWARD ZERO (removes decimal)<br>
                        For positive numbers: floor = trunc. For negative: they differ!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Trigonometry -->
                    <h2>Trigonometric Functions</h2>
                    <p>The math module provides all standard trigonometric functions: sine, cosine, tangent, and
                    their inverses. <strong>Important:</strong> All angles are in radians, not degrees! Use
                    <code>math.radians()</code> to convert degrees to radians, and <code>math.degrees()</code>
                    for the reverse conversion.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/math-trigonometry.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-trig" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Radians, Not Degrees!</strong> A common mistake is passing degrees directly to
                        trig functions. <code>math.sin(90)</code> doesn't give 1 - it calculates sine of 90 radians!
                        Always convert: <code>math.sin(math.radians(90))</code> gives the expected result of 1.0.
                    </div>

                    <!-- Section 4: Advanced Functions -->
                    <h2>Advanced Math Functions</h2>
                    <p>Beyond basics, the math module offers factorials, combinations/permutations, logarithms,
                    GCD/LCM, and special value checking. These are invaluable for statistics, cryptography,
                    combinatorics, and scientific applications.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/math-advanced.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-advanced" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using degrees instead of radians</h4>
                        <pre><code class="language-python">import math

# Wrong - 90 is interpreted as radians!
result = math.sin(90)
print(result)  # 0.893... (not 1!)

# Correct - convert to radians first
result = math.sin(math.radians(90))
print(result)  # 1.0</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting to import math</h4>
                        <pre><code class="language-python"># Wrong - NameError!
result = sqrt(16)

# Correct options:
import math
result = math.sqrt(16)

# Or import specific function
from math import sqrt
result = sqrt(16)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Integer division surprise</h4>
                        <pre><code class="language-python"># Python 3: / always returns float
print(5 / 2)   # 2.5

# Use // for integer division
print(5 // 2)  # 2

# math.floor vs //
import math
print(math.floor(-7/2))  # -4 (floor)
print(-7 // 2)           # -4 (same)
print(int(-7/2))         # -3 (truncation!)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Floating point comparison</h4>
                        <pre><code class="language-python">import math

# Wrong - floating point errors!
if 0.1 + 0.2 == 0.3:
    print("Equal")  # Never prints!

# Correct - use isclose()
if math.isclose(0.1 + 0.2, 0.3):
    print("Equal")  # Prints!

# Or specify tolerance
if math.isclose(a, b, rel_tol=1e-9, abs_tol=1e-9):
    print("Close enough")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. sqrt of negative numbers</h4>
                        <pre><code class="language-python">import math

# Wrong - math.sqrt can't handle negative!
result = math.sqrt(-1)  # ValueError!

# For complex numbers, use cmath
import cmath
result = cmath.sqrt(-1)
print(result)  # 1j (imaginary unit)

# Or check first
n = -1
if n >= 0:
    result = math.sqrt(n)
else:
    print("Cannot calculate sqrt of negative")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Geometry Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create functions to calculate geometric properties.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Calculate the area of a circle given radius</li>
                            <li>Calculate the hypotenuse of a right triangle given two sides</li>
                            <li>Calculate the distance between two points (x1, y1) and (x2, y2)</li>
                            <li>Use appropriate math module functions</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-math.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-math" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">import math

def circle_area(radius):
    """Calculate area of a circle: pi * r^2"""
    return math.pi * radius ** 2

def hypotenuse(a, b):
    """Calculate hypotenuse using Pythagorean theorem."""
    # Could also use: math.sqrt(a**2 + b**2)
    return math.hypot(a, b)

def distance(x1, y1, x2, y2):
    """Calculate distance between two points."""
    # Could also use: math.sqrt((x2-x1)**2 + (y2-y1)**2)
    return math.dist((x1, y1), (x2, y2))

# Test the functions
print(f"Circle area (r=5): {circle_area(5):.2f}")
print(f"Hypotenuse (3, 4): {hypotenuse(3, 4)}")
print(f"Distance (0,0) to (3,4): {distance(0, 0, 3, 4)}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Built-in:</strong> <code>min()</code>, <code>max()</code>, <code>abs()</code>, <code>pow()</code>, <code>round()</code>, <code>sum()</code></li>
                            <li><strong>Roots:</strong> <code>math.sqrt()</code>, <code>math.isqrt()</code></li>
                            <li><strong>Rounding:</strong> <code>math.ceil()</code>, <code>math.floor()</code>, <code>math.trunc()</code></li>
                            <li><strong>Constants:</strong> <code>math.pi</code>, <code>math.e</code>, <code>math.tau</code>, <code>math.inf</code></li>
                            <li><strong>Trig:</strong> <code>sin()</code>, <code>cos()</code>, <code>tan()</code>, <code>asin()</code>, <code>acos()</code>, <code>atan()</code></li>
                            <li><strong>Conversion:</strong> <code>math.radians(deg)</code>, <code>math.degrees(rad)</code></li>
                            <li><strong>Logs:</strong> <code>math.log()</code>, <code>math.log10()</code>, <code>math.log2()</code></li>
                            <li><strong>Advanced:</strong> <code>math.factorial()</code>, <code>math.gcd()</code>, <code>math.lcm()</code>, <code>math.comb()</code></li>
                            <li><strong>Float checks:</strong> <code>math.isclose()</code>, <code>math.isfinite()</code>, <code>math.isinf()</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can handle mathematical operations, let's learn about the <strong>json module</strong>
                    for working with JSON data - the universal format for data exchange in web APIs, configuration
                    files, and modern applications!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="modules-dates.jsp" />
                    <jsp:param name="prevTitle" value="Dates" />
                    <jsp:param name="nextLink" value="modules-json.jsp" />
                    <jsp:param name="nextTitle" value="JSON" />
                    <jsp:param name="currentLessonId" value="modules-math" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
