<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-arithmetic");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Arithmetic Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python arithmetic operators: addition, subtraction, multiplication, division, modulus, exponentiation, and floor division with interactive examples.">
    <meta name="keywords"
        content="python arithmetic operators, python math operators, python division, python modulus, python exponentiation, python floor division">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Arithmetic Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python arithmetic operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-arithmetic.jsp">
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
        "name": "Python Arithmetic Operators",
        "description": "Master Python arithmetic operators with interactive examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Addition and subtraction", "Multiplication and division", "Floor division", "Modulus operator", "Exponentiation", "Order of operations"],
        "timeRequired": "PT20M",
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

<body class="tutorial-body no-preview" data-lesson="operators-arithmetic">
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
                    <span>Arithmetic Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Arithmetic Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Arithmetic operators are the foundation of mathematical operations in Python.
                    From basic addition to powerful exponentiation, these operators let you perform calculations
                    on numbers with ease.</p>

                    <!-- Section 1: Basic Operators -->
                    <h2>Basic Arithmetic Operators</h2>
                    <p>Python supports all the standard mathematical operations you'd expect, plus a few extras.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Name</th>
                                <th>Example</th>
                                <th>Result</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>+</code></td><td>Addition</td><td><code>10 + 3</code></td><td><code>13</code></td></tr>
                            <tr><td><code>-</code></td><td>Subtraction</td><td><code>10 - 3</code></td><td><code>7</code></td></tr>
                            <tr><td><code>*</code></td><td>Multiplication</td><td><code>10 * 3</code></td><td><code>30</code></td></tr>
                            <tr><td><code>/</code></td><td>Division</td><td><code>10 / 3</code></td><td><code>3.333...</code></td></tr>
                            <tr><td><code>//</code></td><td>Floor Division</td><td><code>10 // 3</code></td><td><code>3</code></td></tr>
                            <tr><td><code>%</code></td><td>Modulus</td><td><code>10 % 3</code></td><td><code>1</code></td></tr>
                            <tr><td><code>**</code></td><td>Exponentiation</td><td><code>10 ** 3</code></td><td><code>1000</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-arithmetic-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Python 3 vs Python 2:</strong> In Python 3, the <code>/</code> operator always
                        returns a float, even when dividing two integers. In Python 2, <code>10 / 3</code> would
                        return <code>3</code>. This tutorial uses Python 3.
                    </div>

                    <!-- Section 2: Division Types -->
                    <h2>Division: Regular vs Floor</h2>
                    <p>Python has two division operators with different behaviors. Understanding the difference
                    is crucial for writing correct programs.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-division.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-division" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>//</code> when you need a whole number result, like
                        calculating how many complete items fit in a container. Use <code>/</code> when you need
                        the precise decimal result.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Modulus Operator -->
                    <h2>The Modulus Operator (%)</h2>
                    <p>The modulus operator returns the <strong>remainder</strong> of a division. It's incredibly
                    useful for checking divisibility, cycling through values, and many other tasks.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-modulus.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-modulus" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> The modulus operator with negative numbers can be confusing!
                        Python's modulus always returns a result with the same sign as the divisor, which differs
                        from some other languages. <code>-7 % 3</code> returns <code>2</code>, not <code>-1</code>.
                    </div>

                    <!-- Section 4: Order of Operations -->
                    <h2>Order of Operations (PEMDAS)</h2>
                    <p>Python follows the standard mathematical order of operations. Use parentheses to control
                    the order explicitly.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Priority</th>
                                <th>Operators</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>1 (highest)</td><td><code>()</code></td><td>Parentheses</td></tr>
                            <tr><td>2</td><td><code>**</code></td><td>Exponentiation</td></tr>
                            <tr><td>3</td><td><code>+x, -x</code></td><td>Unary plus/minus</td></tr>
                            <tr><td>4</td><td><code>*, /, //, %</code></td><td>Multiplication, Division</td></tr>
                            <tr><td>5 (lowest)</td><td><code>+, -</code></td><td>Addition, Subtraction</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-precedence.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-precedence" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> When in doubt, use parentheses! They make your code clearer
                        and ensure the calculation happens in the order you intend, even if you're not sure about
                        operator precedence.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing / and //</h4>
                        <pre><code class="language-python"># Wrong - unexpected float when you wanted int
pages = 100
per_chapter = 7
chapters = pages / per_chapter  # 14.285714...

# Correct - use floor division for whole numbers
chapters = pages // per_chapter  # 14</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Integer division truncates toward negative infinity</h4>
                        <pre><code class="language-python"># Surprising behavior with negative numbers!
print(7 // 3)    # 2 (as expected)
print(-7 // 3)   # -3 (not -2!)

# Floor division rounds DOWN, not toward zero
# -7 / 3 = -2.33... rounds down to -3</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting operator precedence</h4>
                        <pre><code class="language-python"># Wrong - calculates (2 + 3) last
result = 2 + 3 * 4  # 14, not 20!

# Correct - use parentheses
result = (2 + 3) * 4  # 20</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Division by zero</h4>
                        <pre><code class="language-python"># This crashes your program!
result = 10 / 0  # ZeroDivisionError!

# Always check before dividing
divisor = 0
if divisor != 0:
    result = 10 / divisor
else:
    print("Cannot divide by zero")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Calculator Practice</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use arithmetic operators to solve real-world calculations.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Calculate the area of a rectangle (length * width)</li>
                            <li>Calculate how many full boxes are needed (using floor division)</li>
                            <li>Check if a number is even (using modulus)</li>
                            <li>Calculate compound interest using exponentiation</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-arithmetic.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-arithmetic" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Given values
length = 15
width = 8
total_items = 100
items_per_box = 12
number = 42
principal = 1000
rate = 0.05
years = 3

# 1. Area of rectangle
area = length * width
print("Area:", area)  # 120

# 2. Full boxes needed
full_boxes = total_items // items_per_box
print("Full boxes:", full_boxes)  # 8

# 3. Check if even (remainder is 0)
is_even = number % 2 == 0
print("Is even:", is_even)  # True

# 4. Compound interest: A = P(1 + r)^t
final_amount = principal * (1 + rate) ** years
print("Final amount:", final_amount)  # 1157.625</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic operators:</strong> <code>+</code> <code>-</code> <code>*</code> <code>/</code> work as expected</li>
                            <li><strong>Floor division:</strong> <code>//</code> rounds down to nearest integer</li>
                            <li><strong>Modulus:</strong> <code>%</code> returns the remainder of division</li>
                            <li><strong>Exponentiation:</strong> <code>**</code> raises to a power</li>
                            <li><strong>PEMDAS:</strong> Parentheses, Exponents, Multiplication/Division, Addition/Subtraction</li>
                            <li><strong>Use parentheses:</strong> When in doubt, make precedence explicit</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can perform calculations, let's learn about <strong>comparison operators</strong>
                    - how to compare values and make decisions based on the results. These are essential for
                    controlling program flow.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="none-type.jsp" />
                    <jsp:param name="prevTitle" value="None Type" />
                    <jsp:param name="nextLink" value="operators-comparison.jsp" />
                    <jsp:param name="nextTitle" value="Comparison Operators" />
                    <jsp:param name="currentLessonId" value="operators-arithmetic" />
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
