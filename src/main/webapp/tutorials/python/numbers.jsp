<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "numbers");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Numbers - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Python numeric types: integers, floats, and complex numbers. Master arithmetic operations, the math module, and number formatting.">
    <meta name="keywords"
        content="python numbers, python int, python float, python complex, python arithmetic, python math module">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Numbers - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python numeric types with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/numbers.jsp">
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
        "name": "Python Numbers",
        "description": "Learn Python numeric types: integers, floats, and complex numbers.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Python integers", "Python floats", "Complex numbers", "Arithmetic operations", "Math module"],
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

<body class="tutorial-body no-preview" data-lesson="numbers">
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
                    <span>Numbers</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Numbers</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python supports three numeric types: <strong>integers</strong> (whole numbers),
                    <strong>floats</strong> (decimal numbers), and <strong>complex</strong> numbers.
                    This lesson covers each type, arithmetic operations, and the powerful math module.</p>

                    <!-- Section 1: Integers -->
                    <h2>Integers (int)</h2>
                    <p>Integers are whole numbers without decimal points. Unlike many languages, Python integers
                    have <strong>unlimited precision</strong> - they can be as large as your memory allows!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/numbers-integers.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-integers" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Number Bases:</strong> Python supports binary (<code>0b</code>), octal (<code>0o</code>),
                        and hexadecimal (<code>0x</code>) notation. This is useful when working with low-level data,
                        colors (hex), or file permissions (octal).
                    </div>

                    <!-- Section 2: Floats -->
                    <h2>Floating Point Numbers (float)</h2>
                    <p>Floats represent decimal numbers. They use the IEEE 754 double-precision format,
                    giving about 15-17 digits of precision.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/numbers-floats.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-floats" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Float Precision:</strong> <code>0.1 + 0.2</code> doesn't equal <code>0.3</code> exactly!
                        This is a fundamental limitation of binary floating-point representation.
                        For financial calculations, use the <code>decimal</code> module.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Complex Numbers -->
                    <h2>Complex Numbers (complex)</h2>
                    <p>Complex numbers have a real and imaginary part. Python uses <code>j</code> for the imaginary unit
                    (mathematicians use <em>i</em>, engineers use <em>j</em>).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/numbers-complex.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-complex" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>When to use complex:</strong> Complex numbers are essential in electrical engineering,
                        signal processing, quantum computing, and certain mathematical algorithms.
                    </div>

                    <!-- Section 4: Arithmetic Operations -->
                    <h2>Arithmetic Operations</h2>
                    <p>Python provides all standard arithmetic operators:</p>

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
                            <tr><td><code>+</code></td><td>Addition</td><td><code>5 + 3</code></td><td>8</td></tr>
                            <tr><td><code>-</code></td><td>Subtraction</td><td><code>5 - 3</code></td><td>2</td></tr>
                            <tr><td><code>*</code></td><td>Multiplication</td><td><code>5 * 3</code></td><td>15</td></tr>
                            <tr><td><code>/</code></td><td>Division</td><td><code>5 / 3</code></td><td>1.666...</td></tr>
                            <tr><td><code>//</code></td><td>Floor Division</td><td><code>5 // 3</code></td><td>1</td></tr>
                            <tr><td><code>%</code></td><td>Modulo</td><td><code>5 % 3</code></td><td>2</td></tr>
                            <tr><td><code>**</code></td><td>Exponent</td><td><code>5 ** 3</code></td><td>125</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/numbers-arithmetic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-arithmetic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Division Note:</strong> In Python 3, <code>/</code> always returns a float.
                        Use <code>//</code> for integer (floor) division. In Python 2, <code>/</code> performed
                        integer division if both operands were integers.
                    </div>

                    <!-- Section 5: Math Module -->
                    <h2>The Math Module</h2>
                    <p>Python's <code>math</code> module provides advanced mathematical functions:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/numbers-math-module.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-math" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Integer division expecting float result</h4>
                        <pre><code class="language-python"># Oops - using // when / was intended
result = 7 // 2    # Returns 3, not 3.5
result = 7 / 2     # Returns 3.5</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Comparing floats for equality</h4>
                        <pre><code class="language-python"># Don't do this
if 0.1 + 0.2 == 0.3:  # False!

# Do this instead
if abs((0.1 + 0.2) - 0.3) < 0.0001:  # True</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Division by zero</h4>
                        <pre><code class="language-python"># This raises ZeroDivisionError
result = 10 / 0

# Check first
if divisor != 0:
    result = 10 / divisor</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Simple Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Given two numbers, perform all arithmetic operations
                        and display the results.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Calculate: addition, subtraction, multiplication</li>
                            <li>Calculate: division (both regular and integer)</li>
                            <li>Calculate: modulo and power (num1 squared)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-numbers-calculator.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-calc" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">num1 = 25
num2 = 7

print(f"{num1} + {num2} = {num1 + num2}")
print(f"{num1} - {num2} = {num1 - num2}")
print(f"{num1} * {num2} = {num1 * num2}")
print(f"{num1} / {num2} = {num1 / num2:.3f}")
print(f"{num1} // {num2} = {num1 // num2}")
print(f"{num1} % {num2} = {num1 % num2}")
print(f"{num1} ** 2 = {num1 ** 2}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>int:</strong> Whole numbers with unlimited precision</li>
                            <li><strong>float:</strong> Decimal numbers (IEEE 754 double-precision)</li>
                            <li><strong>complex:</strong> Numbers with real and imaginary parts (<code>3+4j</code>)</li>
                            <li><strong>Division:</strong> <code>/</code> returns float, <code>//</code> returns integer</li>
                            <li><strong>Math module:</strong> Use <code>import math</code> for advanced functions</li>
                            <li><strong>Precision:</strong> Use <code>decimal</code> module for financial calculations</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>In the next lesson, we'll explore <strong>strings</strong> - Python's powerful text data type,
                    including indexing, slicing, and common string operations.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="variables.jsp" />
                    <jsp:param name="prevTitle" value="Variables" />
                    <jsp:param name="nextLink" value="strings.jsp" />
                    <jsp:param name="nextTitle" value="Strings" />
                    <jsp:param name="currentLessonId" value="numbers" />
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
