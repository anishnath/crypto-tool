<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-ternary");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Ternary Operator - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python's ternary operator (conditional expression). Learn to write concise one-line if-else statements for cleaner, more readable code.">
    <meta name="keywords"
        content="python ternary operator, python conditional expression, python one line if else, python inline if, python shorthand if">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Ternary Operator - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python's ternary operator for concise conditional logic.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/control-ternary.jsp">
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
        "name": "Python Ternary Operator",
        "description": "Master Python's ternary operator (conditional expression) for concise one-line conditionals.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Ternary operator syntax", "Conditional expressions", "Inline if-else", "When to use ternary vs if-else", "Nested ternary pitfalls"],
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

<body class="tutorial-body no-preview" data-lesson="control-ternary">
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
                    <span>Ternary Operator</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Ternary Operator</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The ternary operator (also called conditional expression) lets you write simple
                    <code>if...else</code> statements in a single line. It's perfect for assigning values based
                    on conditions - making your code more concise and Pythonic!</p>

                    <!-- Section 1: Basic Syntax -->
                    <h2>Basic Syntax</h2>
                    <p>Python's ternary syntax is unique - it reads almost like English:</p>

                    <div class="code-block">
                        <pre><code class="language-python">value_if_true if condition else value_if_false</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-ternary-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Python vs Other Languages:</strong> While languages like C, Java, and JavaScript use
                        <code>condition ? value_if_true : value_if_false</code>, Python uses explicit keywords:
                        <code>value_if_true if condition else value_if_false</code>. This makes it more readable!
                    </div>

                    <!-- Section 2: Practical Uses -->
                    <h2>Practical Uses</h2>
                    <p>The ternary operator shines in specific scenarios like default values, formatting,
                    and list comprehensions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-ternary-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The ternary operator is especially useful in list comprehensions
                        and f-strings where you need inline conditional logic. It keeps your code on one line
                        without sacrificing readability.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Nested Ternary -->
                    <h2>Nested Ternary (Use Sparingly!)</h2>
                    <p>You can chain ternary operators for multiple conditions, but be careful -
                    it can quickly become hard to read.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-ternary-nested.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-nested" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Readability Warning:</strong> Nested ternary operators can make code confusing.
                        If you have more than one level of nesting, consider using a traditional if-elif-else
                        statement instead. Code is read more often than it's written!
                    </div>

                    <!-- Section 4: When to Use -->
                    <h2>Ternary vs Traditional if-else</h2>
                    <p>Knowing when to use each approach is key to writing clean, readable code.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/control-ternary-vs-ifelse.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-vs" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Rule of Thumb:</strong> Use ternary for simple value assignments that fit on one line.
                        Use if-else when you have multiple statements, complex conditions, or when the ternary
                        would exceed ~80 characters.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Putting condition first (like other languages)</h4>
                        <pre><code class="language-python"># Wrong - this is C/Java style!
# x > 0 ? "positive" : "negative"  # SyntaxError!

# Correct - Python puts condition in the middle
result = "positive" if x > 0 else "negative"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using ternary for side effects</h4>
                        <pre><code class="language-python"># Wrong - confusing and bad practice
print("yes") if condition else print("no")

# Correct - use if-else for actions
if condition:
    print("yes")
else:
    print("no")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Over-nesting ternary operators</h4>
                        <pre><code class="language-python"># Wrong - unreadable!
x = a if b else c if d else e if f else g

# Correct - use if-elif-else for multiple conditions
if b:
    x = a
elif d:
    x = c
elif f:
    x = e
else:
    x = g</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting the else part</h4>
                        <pre><code class="language-python"># Wrong - ternary requires both if and else!
x = "yes" if condition  # SyntaxError!

# Correct
x = "yes" if condition else "no"</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Ticket Pricing</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use ternary operators to determine prices and labels.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>If age is under 12, ticket price is $10; otherwise $20</li>
                            <li>Determine if a number is "Even" or "Odd"</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-control-ternary.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-ternary" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">age = 10

# 1. Ticket Price (under 12: $10, else: $20)
price = 10 if age < 12 else 20
print(f"Age: {age}, Ticket Price: \${price}")

# 2. Even or Odd
number = 7
type = "Even" if number % 2 == 0 else "Odd"
print(f"Number: {number}, Type: {type}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax:</strong> <code>value_if_true if condition else value_if_false</code></li>
                            <li><strong>Use for:</strong> Simple value assignments, default values, inline formatting</li>
                            <li><strong>Avoid for:</strong> Multiple statements, complex logic, side effects</li>
                            <li><strong>Nesting:</strong> Possible but often hurts readability</li>
                            <li><strong>Always include:</strong> Both the if AND else parts (both are required)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can write concise conditionals, let's learn about <strong>for loops</strong> -
                    the primary way to iterate over sequences and repeat actions in Python. This is where
                    programming gets really powerful!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="control-if.jsp" />
                    <jsp:param name="prevTitle" value="If Statements" />
                    <jsp:param name="nextLink" value="loops-for.jsp" />
                    <jsp:param name="nextTitle" value="For Loops" />
                    <jsp:param name="currentLessonId" value="control-ternary" />
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
