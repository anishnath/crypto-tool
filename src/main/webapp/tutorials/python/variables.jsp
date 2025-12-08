<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Variables - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Python variables: assignment, naming conventions, multiple assignment, dynamic typing, constants, and scope. Complete guide with executable examples.">
    <meta name="keywords"
        content="python variables, python variable assignment, python naming conventions, python constants, python scope, python dynamic typing">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Variables - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python variables with interactive examples. Learn assignment, naming rules, constants, and scope.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/variables.jsp">
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
        "name": "Python Variables",
        "description": "Learn Python variables: assignment, naming conventions, multiple assignment, dynamic typing, constants, and scope.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Python variables", "Variable assignment", "Naming conventions", "Dynamic typing", "Constants", "Variable scope"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "description": "Complete Python programming course for beginners",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="variables">
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
                    <span>Variables</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Variables</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <!-- Introduction -->
                    <p class="lead">Variables are fundamental building blocks in Python. They act as containers that store data values,
                    allowing you to reference and manipulate data throughout your program. Unlike many other languages,
                    Python doesn't require you to declare variable types explicitly.</p>

                    <!-- Section 1: Variable Assignment -->
                    <h2>Variable Assignment</h2>
                    <p>In Python, you create a variable by simply assigning a value to a name using the <code>=</code> operator.
                    No type declaration is needed - Python figures out the type automatically.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-assignment.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-assignment" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> The <code>type()</code> function returns the data type of any variable.
                        This is useful for debugging and understanding your data.
                    </div>

                    <!-- Section 2: Naming Rules -->
                    <h2>Variable Naming Rules</h2>
                    <p>Python has specific rules for naming variables:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Rule</th>
                                <th>Valid</th>
                                <th>Invalid</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Must start with letter or underscore</td>
                                <td><code>name</code>, <code>_private</code></td>
                                <td><code>2name</code></td>
                            </tr>
                            <tr>
                                <td>Can contain letters, numbers, underscores</td>
                                <td><code>user_name</code>, <code>count2</code></td>
                                <td><code>user-name</code></td>
                            </tr>
                            <tr>
                                <td>Case-sensitive</td>
                                <td><code>Name</code> ≠ <code>name</code></td>
                                <td>-</td>
                            </tr>
                            <tr>
                                <td>Cannot be reserved keywords</td>
                                <td><code>my_class</code></td>
                                <td><code>class</code>, <code>if</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>Python Naming Conventions (PEP 8)</h3>
                    <ul>
                        <li><strong>Variables:</strong> <code>snake_case</code> (lowercase with underscores)</li>
                        <li><strong>Constants:</strong> <code>SCREAMING_SNAKE_CASE</code> (all uppercase)</li>
                        <li><strong>Classes:</strong> <code>PascalCase</code> (each word capitalized)</li>
                        <li><strong>Private:</strong> <code>_leading_underscore</code> (convention, not enforced)</li>
                    </ul>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-naming.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-naming" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Multiple Assignment -->
                    <h2>Multiple Assignment</h2>
                    <p>Python allows several elegant ways to assign values to multiple variables at once:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-multiple.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-multiple" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The swap trick <code>a, b = b, a</code> is a Pythonic way to swap values
                        without needing a temporary variable. It works because Python evaluates the right side first,
                        then assigns to the left side.
                    </div>

                    <!-- Section 4: Dynamic Typing -->
                    <h2>Dynamic Typing</h2>
                    <p>Python is <strong>dynamically typed</strong>, meaning:</p>
                    <ul>
                        <li>You don't declare variable types</li>
                        <li>A variable can hold different types at different times</li>
                        <li>Type checking happens at runtime, not compile time</li>
                    </ul>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-dynamic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dynamic" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> While dynamic typing is flexible, it can lead to bugs if you're not careful.
                        Consider using type hints (covered in advanced topics) for larger projects.
                    </div>

                    <!-- Section 5: Constants -->
                    <h2>Constants</h2>
                    <p>Python doesn't have true constants (immutable variables). Instead, we use a <strong>naming convention</strong> -
                    ALL_CAPS indicates a value that shouldn't be changed:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-constants.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-constants" />
                    </jsp:include>

                    <!-- Section 6: Variable Scope -->
                    <h2>Variable Scope (Preview)</h2>
                    <p>Variables have different <strong>scope</strong> - where they can be accessed:</p>
                    <ul>
                        <li><strong>Global:</strong> Defined outside functions, accessible everywhere</li>
                        <li><strong>Local:</strong> Defined inside functions, only accessible within that function</li>
                    </ul>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/variables-scope.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-scope" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <h4>1. Starting variable names with numbers</h4>
                        <pre><code class="language-python"># Wrong
2nd_place = "Silver"  # SyntaxError

# Correct
second_place = "Silver"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using reserved keywords</h4>
                        <pre><code class="language-python"># Wrong
class = "Math 101"  # SyntaxError

# Correct
class_name = "Math 101"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting case sensitivity</h4>
                        <pre><code class="language-python">Name = "Alice"
print(name)  # NameError: 'name' is not defined</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Fix the Variable Names</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> The code below has invalid or non-Pythonic variable names.
                        Fix them to make the code run and follow Python conventions.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Fix all invalid names so the code runs</li>
                            <li>Use <code>snake_case</code> for regular variables</li>
                            <li>Use <code>ALL_CAPS</code> for the constant</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-variables-naming.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-naming" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">first_place = "Gold"      # Changed from 1st_place
user_name = "alice"       # Changed from user-name
max_value = 100           # Changed from MaxValue (snake_case)
MY_CONSTANT = 3.14        # Changed from "my constant" (ALL_CAPS)

print(f"1st place: {first_place}")
print(f"Username: {user_name}")
print(f"Max value: {max_value}")
print(f"Constant: {MY_CONSTANT}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Assignment:</strong> Use <code>=</code> to assign values; no type declaration needed</li>
                            <li><strong>Naming:</strong> Start with letter/underscore, use <code>snake_case</code></li>
                            <li><strong>Multiple assignment:</strong> <code>a, b, c = 1, 2, 3</code></li>
                            <li><strong>Dynamic typing:</strong> Variables can change type at runtime</li>
                            <li><strong>Constants:</strong> Use <code>ALL_CAPS</code> convention</li>
                            <li><strong>Scope:</strong> Global vs local - use <code>global</code> keyword to modify globals</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <h2>What's Next?</h2>
                    <p>Now that you understand variables, let's explore Python's <strong>data types</strong> in detail.
                    In the next lesson, we'll cover numeric types: integers, floats, and complex numbers.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="intro.jsp" />
                    <jsp:param name="prevTitle" value="Introduction" />
                    <jsp:param name="nextLink" value="numbers.jsp" />
                    <jsp:param name="nextTitle" value="Numbers" />
                    <jsp:param name="currentLessonId" value="variables" />
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
