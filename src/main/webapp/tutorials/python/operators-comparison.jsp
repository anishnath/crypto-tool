<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-comparison");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Comparison Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python comparison operators: equal, not equal, greater than, less than. Learn chained comparisons and type comparisons with interactive examples.">
    <meta name="keywords"
        content="python comparison operators, python equality, python greater than, python less than, python chained comparison">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Comparison Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python comparison operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-comparison.jsp">
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
        "name": "Python Comparison Operators",
        "description": "Master Python comparison operators with interactive examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Equality comparison", "Inequality operators", "Greater/less than", "Chained comparisons", "Type comparisons"],
        "timeRequired": "PT18M",
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

<body class="tutorial-body no-preview" data-lesson="operators-comparison">
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
                    <span>Comparison Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Comparison Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~18 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Comparison operators let you compare values and make decisions in your code.
                    They always return a boolean value (<code>True</code> or <code>False</code>), which is essential
                    for controlling program flow with if statements and loops.</p>

                    <!-- Section 1: Basic Comparison Operators -->
                    <h2>Basic Comparison Operators</h2>
                    <p>These operators compare two values and return <code>True</code> or <code>False</code>.</p>

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
                            <tr><td><code>==</code></td><td>Equal to</td><td><code>5 == 5</code></td><td><code>True</code></td></tr>
                            <tr><td><code>!=</code></td><td>Not equal to</td><td><code>5 != 3</code></td><td><code>True</code></td></tr>
                            <tr><td><code>&gt;</code></td><td>Greater than</td><td><code>5 &gt; 3</code></td><td><code>True</code></td></tr>
                            <tr><td><code>&lt;</code></td><td>Less than</td><td><code>5 &lt; 3</code></td><td><code>False</code></td></tr>
                            <tr><td><code>&gt;=</code></td><td>Greater than or equal</td><td><code>5 &gt;= 5</code></td><td><code>True</code></td></tr>
                            <tr><td><code>&lt;=</code></td><td>Less than or equal</td><td><code>5 &lt;= 3</code></td><td><code>False</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-comparison-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> Don't confuse <code>=</code> (assignment) with <code>==</code>
                        (comparison). <code>x = 5</code> assigns the value 5 to x, while <code>x == 5</code> checks
                        if x equals 5.
                    </div>

                    <!-- Section 2: Comparing Different Types -->
                    <h2>Comparing Different Types</h2>
                    <p>Python can compare values of different types in some cases, but not all. Understanding
                    these rules prevents unexpected errors.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-comparison-types.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-types" />
                    </jsp:invoke>

                    <div class="warning-box">
                        <strong>Caution:</strong> Comparing incompatible types (like strings and numbers with
                        <code>&gt;</code> or <code>&lt;</code>) raises a <code>TypeError</code> in Python 3.
                        Always ensure you're comparing compatible types!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Chained Comparisons -->
                    <h2>Chained Comparisons</h2>
                    <p>Python has a unique and powerful feature: you can chain comparison operators together!
                    This makes range checks much more readable.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-comparison-chained.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-chained" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Chained comparisons like <code>1 &lt; x &lt; 10</code> are more
                        readable and slightly faster than <code>x &gt; 1 and x &lt; 10</code>. Use them for range
                        checks!
                    </div>

                    <!-- Section 4: String Comparisons -->
                    <h2>String Comparisons</h2>
                    <p>Strings are compared lexicographically (dictionary order) based on Unicode values.
                    This can sometimes produce surprising results!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-comparison-strings.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-strings" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> For case-insensitive string comparison, convert both
                        strings to the same case first: <code>str1.lower() == str2.lower()</code>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using = instead of ==</h4>
                        <pre><code class="language-python"># Wrong - this is assignment, not comparison!
if x = 5:    # SyntaxError!
    print("x is 5")

# Correct
if x == 5:
    print("x is 5")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Comparing floats for exact equality</h4>
                        <pre><code class="language-python"># Wrong - floating point precision issues!
result = 0.1 + 0.2
print(result == 0.3)  # False! (result is 0.30000000000000004)

# Correct - use a tolerance
import math
print(math.isclose(result, 0.3))  # True

# Or use a manual tolerance
tolerance = 0.0001
print(abs(result - 0.3) < tolerance)  # True</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting case sensitivity in strings</h4>
                        <pre><code class="language-python"># Wrong - case matters!
name = "Alice"
print(name == "alice")  # False

# Correct - normalize case
print(name.lower() == "alice".lower())  # True</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Comparing different types unexpectedly</h4>
                        <pre><code class="language-python"># Surprising results!
print("10" > "9")   # False (string comparison: "1" < "9")
print(10 > 9)       # True (number comparison)

# Be explicit about types
print(int("10") > int("9"))  # True</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Grade Checker</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Write comparison expressions for a grading system.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if a score is passing (>= 60)</li>
                            <li>Check if a score is an A (90-100)</li>
                            <li>Check if age is valid for voting (exactly 18 or older)</li>
                            <li>Compare two students' scores</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-comparison.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-comparison" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Given values
score = 85
age = 17
student1_score = 92
student2_score = 88

# 1. Check if passing (>= 60)
is_passing = score >= 60
print("Is passing:", is_passing)  # True

# 2. Check if score is an A (90-100) - use chained comparison!
is_grade_a = 90 <= score <= 100
print("Is grade A:", is_grade_a)  # False

# 3. Check if can vote (18 or older)
can_vote = age >= 18
print("Can vote:", can_vote)  # False

# 4. Compare students
student1_higher = student1_score > student2_score
print("Student 1 scored higher:", student1_higher)  # True

# 5. Check if scores are equal
scores_equal = student1_score == student2_score
print("Scores are equal:", scores_equal)  # False</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Equality:</strong> <code>==</code> and <code>!=</code> check if values are equal/not equal</li>
                            <li><strong>Ordering:</strong> <code>&gt;</code> <code>&lt;</code> <code>&gt;=</code> <code>&lt;=</code> compare values</li>
                            <li><strong>Results:</strong> All comparisons return <code>True</code> or <code>False</code></li>
                            <li><strong>Chaining:</strong> Python allows <code>1 &lt; x &lt; 10</code> for range checks</li>
                            <li><strong>Strings:</strong> Compared lexicographically (Unicode order)</li>
                            <li><strong>Floats:</strong> Use <code>math.isclose()</code> instead of <code>==</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can compare values, let's learn about <strong>logical operators</strong>
                    (<code>and</code>, <code>or</code>, <code>not</code>) - how to combine multiple conditions
                    to create complex decision logic.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-arithmetic.jsp" />
                    <jsp:param name="prevTitle" value="Arithmetic Operators" />
                    <jsp:param name="nextLink" value="operators-logical.jsp" />
                    <jsp:param name="nextTitle" value="Logical Operators" />
                    <jsp:param name="currentLessonId" value="operators-comparison" />
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
