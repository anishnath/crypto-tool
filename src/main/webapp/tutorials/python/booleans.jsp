<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "booleans");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Booleans - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python booleans: True/False values, comparison operators, logical operators (and, or, not), and truthy/falsy concepts.">
    <meta name="keywords"
        content="python boolean, python True False, python comparison operators, python and or not, python truthy falsy">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Booleans - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python booleans with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/booleans.jsp">
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
        "name": "Python Booleans",
        "description": "Master Python booleans: True/False values, comparison operators, logical operators, and truthy/falsy concepts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Boolean values", "Comparison operators", "Logical operators", "Truthy and falsy", "Short-circuit evaluation"],
        "timeRequired": "PT30M",
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

<body class="tutorial-body no-preview" data-lesson="booleans">
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
                    <span>Booleans</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Booleans</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Booleans are the simplest data type - they can only be <code>True</code> or <code>False</code>.
                    Yet they're fundamental to programming, controlling <strong>decisions</strong>, <strong>loops</strong>,
                    and <strong>logic</strong> in every program you write.</p>

                    <!-- Section 1: Boolean Basics -->
                    <h2>Boolean Values</h2>
                    <p>Python's boolean type (<code>bool</code>) has exactly two values: <code>True</code> and <code>False</code>.
                    Note the capital letters - <code>true</code> and <code>false</code> won't work!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/booleans-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Fun Fact:</strong> In Python, <code>bool</code> is actually a subclass of <code>int</code>.
                        That's why <code>True == 1</code> and <code>False == 0</code>, and you can use them in arithmetic!
                    </div>

                    <!-- Section 2: Comparison Operators -->
                    <h2>Comparison Operators</h2>
                    <p>Comparison operators compare values and return booleans. They're essential for conditions and filtering.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>==</code></td><td>Equal to</td><td><code>5 == 5</code> → True</td></tr>
                            <tr><td><code>!=</code></td><td>Not equal to</td><td><code>5 != 3</code> → True</td></tr>
                            <tr><td><code>&lt;</code></td><td>Less than</td><td><code>3 &lt; 5</code> → True</td></tr>
                            <tr><td><code>&gt;</code></td><td>Greater than</td><td><code>5 &gt; 3</code> → True</td></tr>
                            <tr><td><code>&lt;=</code></td><td>Less than or equal</td><td><code>5 &lt;= 5</code> → True</td></tr>
                            <tr><td><code>&gt;=</code></td><td>Greater than or equal</td><td><code>5 &gt;= 3</code> → True</td></tr>
                            <tr><td><code>is</code></td><td>Same object</td><td><code>x is None</code></td></tr>
                            <tr><td><code>in</code></td><td>Member of</td><td><code>"a" in "abc"</code> → True</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/booleans-comparison.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-comparison" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Chained Comparisons:</strong> Python uniquely allows <code>10 &lt; x &lt; 20</code> instead
                        of <code>10 &lt; x and x &lt; 20</code>. Use this feature - it's cleaner and more Pythonic!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Logical Operators -->
                    <h2>Logical Operators</h2>
                    <p>Logical operators combine boolean expressions. Python uses English words: <code>and</code>, <code>or</code>, <code>not</code>.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>and</code></td><td>True if BOTH are True</td><td><code>True and True</code> → True</td></tr>
                            <tr><td><code>or</code></td><td>True if AT LEAST ONE is True</td><td><code>True or False</code> → True</td></tr>
                            <tr><td><code>not</code></td><td>Inverts the value</td><td><code>not False</code> → True</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/booleans-logical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-logical" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Operator Precedence:</strong> <code>not</code> &gt; <code>and</code> &gt; <code>or</code>.
                        Use parentheses to make your intent clear: <code>(a and b) or c</code> vs <code>a and (b or c)</code>.
                    </div>

                    <!-- Section 4: Truthy and Falsy -->
                    <h2>Truthy and Falsy Values</h2>
                    <p>In Python, any value can be used in a boolean context. Values that act like <code>False</code> are
                    called <strong>falsy</strong>; values that act like <code>True</code> are called <strong>truthy</strong>.</p>

                    <div class="info-box">
                        <strong>Falsy Values:</strong>
                        <ul style="margin: 0.5em 0 0 1.5em; padding: 0;">
                            <li><code>False</code>, <code>None</code></li>
                            <li>Zero: <code>0</code>, <code>0.0</code>, <code>0j</code></li>
                            <li>Empty sequences: <code>""</code>, <code>[]</code>, <code>()</code>, <code>{}</code>, <code>set()</code></li>
                        </ul>
                        <p style="margin-top: 0.5em; margin-bottom: 0;"><strong>Everything else is truthy!</strong></p>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/booleans-truthy-falsy.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-truthy" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Common Pattern:</strong> Use <code>or</code> for default values: <code>name = user_input or "Anonymous"</code>.
                        If <code>user_input</code> is empty/falsy, <code>name</code> becomes "Anonymous".
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using = instead of ==</h4>
                        <pre><code class="language-python"># Wrong - this is assignment!
if x = 5:  # SyntaxError!

# Correct - comparison
if x == 5:
    print("x is 5")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using 'is' for value comparison</h4>
                        <pre><code class="language-python">a = 1000
b = 1000

# Wrong - compares object identity
if a is b:  # May be False!

# Correct - compares values
if a == b:  # True
    print("a equals b")

# 'is' is correct for None
if x is None:  # Correct way to check None</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing 'and' short-circuit behavior</h4>
                        <pre><code class="language-python"># 'and' returns first falsy value, or last value
result = "" and "hello"  # Returns "", not False!
result = "hi" and "hello"  # Returns "hello", not True!

# If you need actual boolean, use bool()
result = bool("" and "hello")  # False</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Checking empty containers wrong way</h4>
                        <pre><code class="language-python">items = []

# Works, but not Pythonic
if len(items) == 0:
    print("empty")

# Pythonic way - use truthy/falsy
if not items:
    print("empty")

if items:  # Check if not empty
    print("has items")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Boolean Logic Practice</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Predict the result of each boolean expression, then run to verify.</p>

                        <p><strong>Skills tested:</strong></p>
                        <ul>
                            <li>Comparison operators</li>
                            <li>Logical operators (and, or, not)</li>
                            <li>Truthy/falsy understanding</li>
                            <li>Short-circuit evaluation</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-booleans.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-booleans" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Answers</summary>
                            <pre><code class="language-python">age = 17
score = 85
has_permission = True
name = ""
items = [1, 2, 3]

# 1. age >= 18 → False (17 is not >= 18)
# 2. score > 80 and score < 90 → True (85 is between 80 and 90)
# 3. age < 18 or has_permission → True (17 < 18 is True)
# 4. not has_permission → False (not True = False)
# 5. bool(name) → False (empty string is falsy)
# 6. bool(items) → True (non-empty list is truthy)
# 7. 10 < age < 20 → True (17 is between 10 and 20)
# 8. name or "Anonymous" → "Anonymous" (empty string is falsy)
# 9. items and items[0] → 1 (items is truthy, returns items[0])
# 10. not name and has_permission → True (not "" is True, and True = True)</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Boolean values:</strong> <code>True</code> and <code>False</code> (capital letters!)</li>
                            <li><strong>Comparison:</strong> <code>==</code>, <code>!=</code>, <code>&lt;</code>, <code>&gt;</code>, <code>&lt;=</code>, <code>&gt;=</code></li>
                            <li><strong>Identity:</strong> <code>is</code>, <code>is not</code> (for object identity, use with <code>None</code>)</li>
                            <li><strong>Membership:</strong> <code>in</code>, <code>not in</code></li>
                            <li><strong>Logical:</strong> <code>and</code>, <code>or</code>, <code>not</code></li>
                            <li><strong>Falsy values:</strong> <code>False</code>, <code>None</code>, <code>0</code>, empty sequences</li>
                            <li><strong>Short-circuit:</strong> <code>and</code> stops at first falsy, <code>or</code> stops at first truthy</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>In the next lesson, we'll explore <strong>type conversion</strong> - how to convert between
                    Python's data types like int, float, str, and bool.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="string-methods.jsp" />
                    <jsp:param name="prevTitle" value="String Methods" />
                    <jsp:param name="nextLink" value="type-conversion.jsp" />
                    <jsp:param name="nextTitle" value="Type Conversion" />
                    <jsp:param name="currentLessonId" value="booleans" />
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
