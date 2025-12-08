<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-if");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>If Statements - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python if, elif, and else statements. Learn conditional logic, nested conditions, truthy/falsy values, and decision-making patterns with examples.">
    <meta name="keywords"
        content="python if statement, python elif, python else, python conditional logic, python truthy falsy, python nested if">

    <meta property="og:type" content="article">
    <meta property="og:title" content="If Statements - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python conditional logic with if, elif, and else statements.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/control-if.jsp">
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
        "name": "Python If Statements",
        "description": "Master Python if, elif, and else statements for conditional logic.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["if statement", "else clause", "elif chain", "Nested conditions", "Truthy and falsy values", "Logical operators in conditions"],
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

<body class="tutorial-body no-preview" data-lesson="control-if">
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
                    <span>If Statements</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">If Statements</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Conditional statements let your program make decisions! The <code>if</code> statement
                    is the cornerstone of control flow - it executes code only when a specific condition is true,
                    allowing your programs to respond dynamically to different situations.</p>

                    <!-- Section 1: Basic if -->
                    <h2>The Basic <code>if</code> Statement</h2>
                    <p>The <code>if</code> statement executes a block of code only when the condition evaluates to
                    <code>True</code>. Python uses <strong>indentation</strong> to define the code block.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-if-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Indentation Matters!</strong> Python uses indentation (typically 4 spaces) to define
                        code blocks. All lines with the same indentation after an <code>if</code> statement belong
                        to that block. This is different from languages that use braces <code>{}</code>.
                    </div>

                    <!-- Section 2: if-else -->
                    <h2>The <code>if...else</code> Statement</h2>
                    <p>Add an <code>else</code> clause to handle the case when the condition is <code>False</code>.
                    Either the <code>if</code> block OR the <code>else</code> block will execute - never both!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-if-else.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-else" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> You can check if a list is empty by using it directly as the condition:
                        <code>if my_list:</code> is True when the list has items, False when empty. This works for
                        strings, dicts, and other collections too!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: if-elif-else -->
                    <h2>The <code>if...elif...else</code> Chain</h2>
                    <p>Use <code>elif</code> (short for "else if") when you have multiple conditions to check.
                    Python evaluates conditions from top to bottom and executes only the FIRST matching block.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-if-elif.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-elif" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Order Matters!</strong> In an if-elif chain, conditions are checked top to bottom.
                        Once a condition is True, the rest are skipped. Put more specific conditions before
                        general ones: check <code>score >= 90</code> before <code>score >= 80</code>.
                    </div>

                    <!-- Section 4: Nested if -->
                    <h2>Nested If Statements</h2>
                    <p>You can place <code>if</code> statements inside other <code>if</code> statements for more
                    complex decision trees. Each level adds another 4 spaces of indentation.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-if-nested.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-nested" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Readability Tip:</strong> Deeply nested if statements (more than 3 levels) are hard to read.
                        Consider using early returns, breaking into functions, or using <code>and</code>/<code>or</code>
                        to combine conditions.
                    </div>

                    <!-- Section 5: Truthy/Falsy -->
                    <h2>Truthy and Falsy Values</h2>
                    <p>Python treats certain values as "falsy" (equivalent to False in a condition) and everything
                    else as "truthy". This allows for cleaner condition checks!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-if-truthy.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-truthy" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using = instead of == in conditions</h4>
                        <pre><code class="language-python"># Wrong - this is assignment, not comparison!
if x = 5:  # SyntaxError!
    print("x is 5")

# Correct - use == for comparison
if x == 5:
    print("x is 5")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting the colon</h4>
                        <pre><code class="language-python"># Wrong - missing colon!
if age >= 18
    print("Adult")  # SyntaxError!

# Correct
if age >= 18:
    print("Adult")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Inconsistent indentation</h4>
                        <pre><code class="language-python"># Wrong - mixed indentation!
if condition:
    print("Line 1")
  print("Line 2")  # IndentationError!

# Correct - consistent 4 spaces
if condition:
    print("Line 1")
    print("Line 2")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Comparing with True/False explicitly</h4>
                        <pre><code class="language-python"># Not recommended
if is_valid == True:
    print("Valid")

# Better - cleaner and more Pythonic
if is_valid:
    print("Valid")

# For checking False, use 'not'
if not is_valid:
    print("Not valid")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Grade Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a grading system that assigns letter grades based on scores.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>90-100: Grade "A"</li>
                            <li>80-89: Grade "B"</li>
                            <li>70-79: Grade "C"</li>
                            <li>60-69: Grade "D"</li>
                            <li>Below 60: Grade "F"</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-control-if.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-if" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">score = 75
grade = ""

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"Score: {score}, Grade: {grade}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>if:</strong> Executes code block when condition is True</li>
                            <li><strong>else:</strong> Executes when no preceding condition was True</li>
                            <li><strong>elif:</strong> Checks additional conditions (can have multiple)</li>
                            <li><strong>Indentation:</strong> Python uses 4 spaces to define code blocks</li>
                            <li><strong>Colon:</strong> Every if/elif/else line must end with <code>:</code></li>
                            <li><strong>Falsy values:</strong> False, None, 0, "", [], {}, (), set()</li>
                            <li><strong>Truthy:</strong> Everything else is considered True in conditions</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can make decisions with if statements, let's learn about the <strong>ternary operator</strong>
                    - a concise one-line way to write simple if-else expressions that's perfect for assigning values
                    based on conditions!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-membership.jsp" />
                    <jsp:param name="prevTitle" value="Membership Operators" />
                    <jsp:param name="nextLink" value="control-ternary.jsp" />
                    <jsp:param name="nextTitle" value="Ternary Operator" />
                    <jsp:param name="currentLessonId" value="control-if" />
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
