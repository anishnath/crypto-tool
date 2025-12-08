<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-return");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Return Values - Multiple Returns, Return vs Print | 8gwifi.org</title>
    <meta name="description"
        content="Master Python return statements - return single values, multiple values, dictionaries. Learn the difference between return and print for better function design.">
    <meta name="keywords"
        content="python return statement, python return multiple values, python function return, python return vs print, python return tuple">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Return Values - Multiple Returns, Return vs Print">
    <meta property="og:description" content="Master Python return statements and the difference between return and print.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions-return.jsp">
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
        "name": "Python Return Values",
        "description": "Master Python return statements - return single values, multiple values, dictionaries. Learn the difference between return and print.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Return statement basics", "Returning multiple values", "Return vs print", "Early return patterns", "Factory functions"],
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

<body class="tutorial-body no-preview" data-lesson="functions-return">
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
                    <span>Return Values</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Return Values</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Functions don't just perform actions - they can also compute and send back
                    results. The <code>return</code> statement is how functions communicate their output back
                    to the code that called them. Understanding return values is crucial for writing functions
                    that can be composed, tested, and reused effectively!</p>

                    <!-- Section 1: Basic Return -->
                    <h2>Basic Return Statements</h2>
                    <p>The <code>return</code> statement immediately exits the function and sends a value back
                    to the caller. If a function doesn't have a return statement, or has <code>return</code>
                    without a value, it returns <code>None</code> by default.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/return-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Return Immediately Exits:</strong> When Python encounters a <code>return</code>
                        statement, it immediately leaves the function. Any code after the return statement in
                        that code path will never execute. This makes return useful for "early exits" when
                        validation fails.
                    </div>

                    <!-- Section 2: Multiple Values -->
                    <h2>Returning Multiple Values</h2>
                    <p>Python makes it easy to return multiple values from a function. You can return a tuple
                    (the most common approach), a dictionary (for named values), a list, or even a named tuple
                    for the best of both worlds.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/return-multiple.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-multiple" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Tuple Unpacking:</strong> When a function returns multiple values as a tuple,
                        you can unpack them directly: <code>min_val, max_val = get_min_max(nums)</code>. This
                        is cleaner than <code>result = get_min_max(nums); min_val = result[0]</code>. Use
                        named tuples when the meaning of each position isn't obvious.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Return vs Print -->
                    <h2>Return vs Print</h2>
                    <p>A common beginner confusion: <code>print()</code> displays output to the screen,
                    while <code>return</code> sends data back to the caller. Functions that print can't
                    be composed or tested easily - always prefer return for reusable functions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/return-vs-print.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-vs-print" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Print Returns None!</strong> <code>print()</code> always returns <code>None</code>,
                        not the string it displays. If you write <code>result = print("Hello")</code>, result
                        will be <code>None</code>. Use print for user output, return for function output.
                    </div>

                    <!-- Section 4: Practical Patterns -->
                    <h2>Practical Return Patterns</h2>
                    <p>Professional Python code uses return in many patterns: early returns for validation,
                    guard clauses for cleaner logic, factory functions to create objects, and result patterns
                    for error handling.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/return-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using print instead of return</h4>
                        <pre><code class="language-python"># Wrong - can't use the result
def add(a, b):
    print(a + b)

result = add(3, 5)  # result is None!
# result + 10 would cause TypeError

# Correct - return the value
def add(a, b):
    return a + b

result = add(3, 5)  # result is 8
print(result + 10)  # Works: 18</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting to capture the return value</h4>
                        <pre><code class="language-python">def calculate_tax(amount):
    return amount * 0.1

# Wrong - return value is lost
calculate_tax(100)
# The 10.0 is calculated but never stored

# Correct - capture the result
tax = calculate_tax(100)
print(f"Tax: \${tax}")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Unreachable code after return</h4>
                        <pre><code class="language-python"># Wrong - cleanup never runs!
def get_data():
    return fetch_from_database()
    close_connection()  # Never executes!

# Correct - use try/finally or context manager
def get_data():
    try:
        return fetch_from_database()
    finally:
        close_connection()  # Always runs</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Inconsistent return types</h4>
                        <pre><code class="language-python"># Confusing - returns different types
def find_user(user_id):
    if user_id in database:
        return database[user_id]  # Returns dict
    return "Not found"  # Returns string!

# Better - consistent return type
def find_user(user_id):
    if user_id in database:
        return database[user_id]
    return None  # Always returns dict or None

# Or return a result tuple
def find_user(user_id):
    if user_id in database:
        return True, database[user_id]
    return False, None</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Returning inside a loop without break logic</h4>
                        <pre><code class="language-python"># Wrong - only checks first item
def contains_even(numbers):
    for n in numbers:
        if n % 2 == 0:
            return True
        return False  # Returns on first iteration!

contains_even([1, 2, 3])  # Returns False (wrong!)

# Correct - check all items
def contains_even(numbers):
    for n in numbers:
        if n % 2 == 0:
            return True
    return False  # Only after loop completes

contains_even([1, 2, 3])  # Returns True (correct)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Statistics Function</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that returns statistics about a list of numbers.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Accept a list of numbers</li>
                            <li>Return a dictionary with: min, max, sum, and average</li>
                            <li>Handle empty list case (return None or empty dict)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-return.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-return" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def get_stats(numbers):
    """Return statistics about a list of numbers."""
    if not numbers:
        return None

    return {
        "min": min(numbers),
        "max": max(numbers),
        "sum": sum(numbers),
        "average": sum(numbers) / len(numbers)
    }

# Test it
stats = get_stats([1, 2, 3, 4, 5])
print(f"Stats: {stats}")
print(f"Average: {stats['average']}")

empty_stats = get_stats([])
print(f"Empty: {empty_stats}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Return basics:</strong> <code>return value</code> exits function and sends value back</li>
                            <li><strong>No return:</strong> Functions without return (or bare <code>return</code>) return <code>None</code></li>
                            <li><strong>Multiple values:</strong> <code>return a, b, c</code> returns a tuple</li>
                            <li><strong>Unpack:</strong> <code>x, y, z = func()</code> unpacks returned tuple</li>
                            <li><strong>Return vs print:</strong> Return sends data back; print displays to screen</li>
                            <li><strong>Early return:</strong> Use return to exit early on validation failure</li>
                            <li><strong>Consistency:</strong> Return the same type(s) from all code paths</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand how functions communicate through arguments and return values,
                    let's explore <strong>Variable Scope</strong> - understanding where variables exist and
                    how Python looks them up. This is essential for avoiding bugs and writing cleaner code!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions-arguments.jsp" />
                    <jsp:param name="prevTitle" value="Function Arguments" />
                    <jsp:param name="nextLink" value="functions-scope.jsp" />
                    <jsp:param name="nextTitle" value="Variable Scope" />
                    <jsp:param name="currentLessonId" value="functions-return" />
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
