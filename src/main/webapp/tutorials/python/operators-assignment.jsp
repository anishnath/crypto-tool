<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-assignment");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Assignment Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python assignment operators: =, +=, -=, *=, /=, and the walrus operator :=. Learn augmented assignment, multiple assignment, and value swapping with examples.">
    <meta name="keywords"
        content="python assignment operators, python augmented assignment, python walrus operator, python +=, python variable assignment, python swap values">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Assignment Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python assignment operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-assignment.jsp">
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
        "name": "Python Assignment Operators",
        "description": "Master Python assignment operators: basic assignment, augmented operators, and the walrus operator.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Basic assignment =", "Augmented assignment +=, -=, *=, /=", "Multiple assignment", "Value swapping", "Walrus operator :="],
        "timeRequired": "PT15M",
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

<body class="tutorial-body no-preview" data-lesson="operators-assignment">
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
                    <span>Assignment Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Assignment Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Assignment operators store values in variables. Beyond the basic <code>=</code>,
                    Python provides powerful shortcuts like <code>+=</code> and <code>*=</code> that combine operations
                    with assignment - making your code shorter and more expressive!</p>

                    <!-- Section 1: Basic Assignment -->
                    <h2>Basic Assignment</h2>
                    <p>The <code>=</code> operator assigns a value to a variable. Python also supports assigning
                    multiple variables at once and swapping values elegantly.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-assignment-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> Python's multiple assignment (<code>a, b = 1, 2</code>) and
                        swap syntax (<code>a, b = b, a</code>) are unique features that make code cleaner.
                        In most languages, swapping requires a temporary variable!
                    </div>

                    <!-- Section 2: Augmented Assignment -->
                    <h2>Augmented Assignment Operators</h2>
                    <p>Augmented assignment operators combine an arithmetic operation with assignment in a single step.
                    These are shortcuts that make code more concise.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Example</th>
                                <th>Equivalent To</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>+=</code></td><td><code>x += 5</code></td><td><code>x = x + 5</code></td><td>Add and assign</td></tr>
                            <tr><td><code>-=</code></td><td><code>x -= 5</code></td><td><code>x = x - 5</code></td><td>Subtract and assign</td></tr>
                            <tr><td><code>*=</code></td><td><code>x *= 5</code></td><td><code>x = x * 5</code></td><td>Multiply and assign</td></tr>
                            <tr><td><code>/=</code></td><td><code>x /= 5</code></td><td><code>x = x / 5</code></td><td>Divide and assign</td></tr>
                            <tr><td><code>//=</code></td><td><code>x //= 5</code></td><td><code>x = x // 5</code></td><td>Floor divide and assign</td></tr>
                            <tr><td><code>%=</code></td><td><code>x %= 5</code></td><td><code>x = x % 5</code></td><td>Modulus and assign</td></tr>
                            <tr><td><code>**=</code></td><td><code>x **= 5</code></td><td><code>x = x ** 5</code></td><td>Exponent and assign</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-assignment-augmented.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-augmented" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use augmented operators whenever possible. <code>x += 1</code>
                        is not only shorter than <code>x = x + 1</code>, but can also be slightly more efficient
                        for some data types!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Assignment with Strings -->
                    <h2>Assignment with Strings</h2>
                    <p>Augmented assignment works with strings too! Use <code>+=</code> to concatenate strings
                    and <code>*=</code> to repeat them.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-assignment-strings.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-strings" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Performance Note:</strong> Building strings with <code>+=</code> in a loop is
                        inefficient for large strings because strings are immutable. Each <code>+=</code> creates
                        a new string object. For many concatenations, use <code>"".join()</code> or f-strings instead.
                    </div>

                    <!-- Section 4: The Walrus Operator -->
                    <h2>The Walrus Operator :=</h2>
                    <p>Python 3.8 introduced the "walrus operator" (<code>:=</code>), which assigns a value AND
                    returns it in a single expression. It's called the walrus operator because <code>:=</code>
                    looks like a walrus face sideways!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-assignment-walrus.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-walrus" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>When to Use :=</strong> The walrus operator is great when you need to:
                        (1) assign and test a value in an if statement, (2) avoid duplicate calculations in
                        comprehensions, or (3) assign values in while loop conditions.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing = with ==</h4>
                        <pre><code class="language-python"># Wrong - assigns instead of comparing!
if x = 5:  # SyntaxError in Python!
    print("x is 5")

# Correct - use == for comparison
if x == 5:
    print("x is 5")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using augmented operators on undefined variables</h4>
                        <pre><code class="language-python"># Wrong - count doesn't exist yet!
count += 1  # NameError: name 'count' is not defined

# Correct - initialize first
count = 0
count += 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting that /= produces a float</h4>
                        <pre><code class="language-python"># Surprise! Result is a float
x = 10
x /= 2
print(x)  # 5.0, not 5!

# Use //= for integer division
x = 10
x //= 2
print(x)  # 5</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Wrong order in multiple assignment</h4>
                        <pre><code class="language-python"># Wrong - values don't match variables
name, age = 25, "Alice"  # Now name=25, age="Alice"!

# Correct - keep order consistent
name, age = "Alice", 25</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Score Tracker</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Manage a game score using assignment operators.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Start with score = 0</li>
                            <li>Add 10 points using <code>+=</code></li>
                            <li>Double the score using <code>*=</code></li>
                            <li>Subtract a penalty of 5 using <code>-=</code></li>
                            <li>Divide by 3 using <code>/=</code></li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-assignment.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-assignment" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">score = 0
print(f"Initial score: {score}")

# 1. Add 10 to score using +=
score += 10
print(f"After +10: {score}")  # 10

# 2. Multiply score by 2 using *=
score *= 2
print(f"After x2: {score}")   # 20

# 3. Subtract 5 from score using -=
score -= 5
print(f"After -5: {score}")   # 15

# 4. Divide score by 3 using /=
score /= 3
print(f"Final score: {score}")  # 5.0</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>=</strong> assigns a value to a variable</li>
                            <li><strong>Multiple assignment:</strong> <code>a, b = 1, 2</code> assigns multiple values at once</li>
                            <li><strong>Value swap:</strong> <code>a, b = b, a</code> swaps without a temp variable</li>
                            <li><strong>Augmented operators</strong> (+=, -=, *=, /=, //=, %=, **=) combine operation + assignment</li>
                            <li><strong>String +=</strong> concatenates, <strong>*=</strong> repeats</li>
                            <li><strong>Walrus operator :=</strong> (Python 3.8+) assigns AND returns a value</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can efficiently assign and update values, let's explore <strong>bitwise operators</strong>
                    - powerful tools for working with individual bits in numbers, essential for low-level programming
                    and optimizations.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-logical.jsp" />
                    <jsp:param name="prevTitle" value="Logical Operators" />
                    <jsp:param name="nextLink" value="operators-bitwise.jsp" />
                    <jsp:param name="nextTitle" value="Bitwise Operators" />
                    <jsp:param name="currentLessonId" value="operators-assignment" />
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
