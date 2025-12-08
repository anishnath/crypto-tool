<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-logical");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Logical Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python logical operators: and, or, not. Learn short-circuit evaluation, truthy/falsy values, and combining conditions with interactive examples.">
    <meta name="keywords"
        content="python logical operators, python and or not, python boolean logic, python short circuit, python truthy falsy">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Logical Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python logical operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-logical.jsp">
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
        "name": "Python Logical Operators",
        "description": "Master Python logical operators: and, or, not with interactive examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["and operator", "or operator", "not operator", "Short-circuit evaluation", "Truthy and falsy values", "Combining conditions"],
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

<body class="tutorial-body no-preview" data-lesson="operators-logical">
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
                    <span>Logical Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Logical Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Logical operators let you combine multiple conditions to create complex decision logic.
                    Python uses the keywords <code>and</code>, <code>or</code>, and <code>not</code> - making your code
                    read almost like English!</p>

                    <!-- Section 1: The Three Logical Operators -->
                    <h2>The Three Logical Operators</h2>
                    <p>Python has three logical operators for combining boolean expressions.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                                <th>Result</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>and</code></td><td>True if BOTH are true</td><td><code>True and True</code></td><td><code>True</code></td></tr>
                            <tr><td><code>or</code></td><td>True if AT LEAST ONE is true</td><td><code>True or False</code></td><td><code>True</code></td></tr>
                            <tr><td><code>not</code></td><td>Inverts the value</td><td><code>not False</code></td><td><code>True</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-logical-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> Python uses words (<code>and</code>, <code>or</code>, <code>not</code>)
                        instead of symbols (<code>&amp;&amp;</code>, <code>||</code>, <code>!</code>) like other languages.
                        This makes code more readable!
                    </div>

                    <!-- Section 2: Truth Tables -->
                    <h2>Truth Tables</h2>
                    <p>Understanding truth tables helps you predict the outcome of logical operations.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>A</th>
                                <th>B</th>
                                <th>A and B</th>
                                <th>A or B</th>
                                <th>not A</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>True</td><td>True</td><td>True</td><td>True</td><td>False</td></tr>
                            <tr><td>True</td><td>False</td><td>False</td><td>True</td><td>False</td></tr>
                            <tr><td>False</td><td>True</td><td>False</td><td>True</td><td>True</td></tr>
                            <tr><td>False</td><td>False</td><td>False</td><td>False</td><td>True</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-logical-tables.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-tables" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Memory Tip:</strong> Think of <code>and</code> as "both must be true" and <code>or</code>
                        as "at least one must be true". For <code>not</code>, just flip the value!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Short-Circuit Evaluation -->
                    <h2>Short-Circuit Evaluation</h2>
                    <p>Python uses "short-circuit" evaluation - it stops evaluating as soon as it knows the result.
                    This can improve performance and prevent errors!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-logical-shortcircuit.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-shortcircuit" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> Because of short-circuit evaluation, side effects in the second
                        operand may not happen! Don't rely on the second expression always being evaluated.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Logical operators are essential for real-world conditions like access control, validation, and filtering.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-logical-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Use parentheses to make complex conditions clearer, even if
                        they're not strictly required: <code>(a and b) or (c and d)</code>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using && and || instead of and/or</h4>
                        <pre><code class="language-python"># Wrong - these are not valid Python!
if x > 0 && x < 10:  # SyntaxError!
if a || b:           # SyntaxError!

# Correct - use words
if x > 0 and x < 10:
if a or b:</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing 'and' with 'or' in conditions</h4>
                        <pre><code class="language-python"># Wrong - impossible condition! (nothing is both < 0 AND > 100)
if score < 0 and score > 100:
    print("Invalid")  # Never executes!

# Correct - use 'or' for "either/or" conditions
if score < 0 or score > 100:
    print("Invalid")  # Catches both cases</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting operator precedence</h4>
                        <pre><code class="language-python"># Confusing - what does this mean?
if a or b and c:
    pass
# This is actually: a or (b and c)
# 'and' has higher precedence than 'or'!

# Clear - use parentheses
if (a or b) and c:
    pass</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Double negatives</h4>
                        <pre><code class="language-python"># Confusing - hard to read!
if not is_invalid:
    print("Valid")

# Clearer - use positive naming
if is_valid:
    print("Valid")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Access Control System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Build access control logic using logical operators.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Admin access: Must be logged in AND be an admin</li>
                            <li>Content access: Logged in AND (is subscriber OR has free trial)</li>
                            <li>Blocked user: NOT banned</li>
                            <li>Premium feature: (Admin OR premium user) AND not in maintenance mode</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-logical.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-logical" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Given values
is_logged_in = True
is_admin = False
is_subscriber = True
has_free_trial = False
is_banned = False
is_premium = True
maintenance_mode = False

# 1. Admin access: logged in AND admin
can_access_admin = is_logged_in and is_admin
print("Admin access:", can_access_admin)  # False

# 2. Content access: logged in AND (subscriber OR free trial)
can_access_content = is_logged_in and (is_subscriber or has_free_trial)
print("Content access:", can_access_content)  # True

# 3. Not blocked: NOT banned
is_allowed = not is_banned
print("Is allowed:", is_allowed)  # True

# 4. Premium feature: (admin OR premium) AND not maintenance
can_use_premium = (is_admin or is_premium) and not maintenance_mode
print("Premium access:", can_use_premium)  # True</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>and:</strong> True only if BOTH operands are True</li>
                            <li><strong>or:</strong> True if AT LEAST ONE operand is True</li>
                            <li><strong>not:</strong> Inverts True to False and vice versa</li>
                            <li><strong>Short-circuit:</strong> Python stops evaluating when result is known</li>
                            <li><strong>Precedence:</strong> <code>not</code> > <code>and</code> > <code>or</code></li>
                            <li><strong>Readability:</strong> Use parentheses for complex conditions</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can combine conditions, let's learn about <strong>assignment operators</strong>
                    - shortcuts for updating variable values with operations like <code>+=</code>, <code>-=</code>, and more.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-comparison.jsp" />
                    <jsp:param name="prevTitle" value="Comparison Operators" />
                    <jsp:param name="nextLink" value="operators-assignment.jsp" />
                    <jsp:param name="nextTitle" value="Assignment Operators" />
                    <jsp:param name="currentLessonId" value="operators-logical" />
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
