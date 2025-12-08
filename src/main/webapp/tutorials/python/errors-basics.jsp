<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "errors-basics");
   request.setAttribute("currentModule", "Error Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Exceptions - TypeError, ValueError, KeyError, Tracebacks | 8gwifi.org</title>
    <meta name="description"
        content="Understand Python exceptions - learn the difference between syntax errors and runtime exceptions, common exception types, the exception hierarchy, and how to read tracebacks.">
    <meta name="keywords"
        content="python exceptions, python errors, python TypeError, python ValueError, python traceback, python exception types, python error handling">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Exceptions - TypeError, ValueError, KeyError, Tracebacks">
    <meta property="og:description" content="Master Python exceptions: syntax errors vs exceptions, common types, and reading tracebacks.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/errors-basics.jsp">
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
        "name": "Python Exceptions Basics",
        "description": "Understand Python exceptions - the difference between syntax errors and exceptions, common exception types, and how to read tracebacks.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Syntax errors vs exceptions", "Common exception types", "Exception hierarchy", "Reading tracebacks", "Error messages", "Debugging errors"],
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

<body class="tutorial-body no-preview" data-lesson="errors-basics">
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
                    <span>Exceptions Basics</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Exceptions Basics</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Errors happen - files go missing, users enter invalid data, networks fail. Python's
                    exception system lets you handle these gracefully instead of crashing. Understanding the difference
                    between syntax errors and runtime exceptions, knowing the common exception types, and being able to
                    read tracebacks are essential skills for every Python developer!</p>

                    <!-- Section 1: Syntax vs Exception -->
                    <h2>Syntax Errors vs Exceptions</h2>
                    <p><strong>Syntax errors</strong> occur when Python can't parse your code - it doesn't understand
                    what you wrote. These must be fixed before the program can run. <strong>Exceptions</strong> occur
                    during execution when something goes wrong at runtime. The code is valid Python, but the operation
                    failed (like dividing by zero).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/errors-syntax-vs-exception.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-syntax" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Difference:</strong><br>
                        <code>SyntaxError</code> - Python can't understand your code (missing colons, unmatched brackets)<br>
                        - Detected before the program runs<br>
                        - Cannot be caught with try/except<br><br>
                        <code>Exception</code> - Code is valid but fails at runtime (divide by zero, file not found)<br>
                        - Detected during execution<br>
                        - Can be caught and handled
                    </div>

                    <!-- Section 2: Common Types -->
                    <h2>Common Exception Types</h2>
                    <p>Python has dozens of built-in exception types, each for specific error conditions. Knowing the
                    common ones helps you write better error handling and debug faster. The most frequent exceptions
                    you'll encounter are <code>TypeError</code>, <code>ValueError</code>, <code>KeyError</code>,
                    <code>IndexError</code>, and <code>FileNotFoundError</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/errors-common-types.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-common" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Quick Exception Reference:</strong><br>
                        <code>TypeError</code> - Wrong type: <code>"a" + 1</code>, <code>len(42)</code><br>
                        <code>ValueError</code> - Bad value: <code>int("abc")</code><br>
                        <code>IndexError</code> - Bad index: <code>list[999]</code><br>
                        <code>KeyError</code> - Missing key: <code>dict["missing"]</code><br>
                        <code>AttributeError</code> - No attribute: <code>"str".append()</code><br>
                        <code>FileNotFoundError</code> - File missing: <code>open("nope.txt")</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Hierarchy -->
                    <h2>Exception Hierarchy</h2>
                    <p>Python exceptions form a class hierarchy. All exceptions inherit from <code>BaseException</code>,
                    and most inherit from <code>Exception</code>. Understanding the hierarchy helps you catch related
                    exceptions together - catching <code>LookupError</code> catches both <code>IndexError</code> and
                    <code>KeyError</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/errors-hierarchy.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-hierarchy" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Don't catch BaseException!</strong> Only catch <code>Exception</code> or more specific
                        types. <code>BaseException</code> includes <code>KeyboardInterrupt</code> (Ctrl+C) and
                        <code>SystemExit</code> - catching these prevents users from stopping your program!
                    </div>

                    <!-- Section 4: Tracebacks -->
                    <h2>Reading Tracebacks</h2>
                    <p>When an exception occurs, Python prints a <strong>traceback</strong> - a record of where the
                    error happened and how the code got there. Read tracebacks from <strong>bottom to top</strong>:
                    the error type is at the bottom, and the call stack shows how you got there.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/errors-tracebacks.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-tracebacks" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Reading Tracebacks:</strong><br>
                        1. Start at the BOTTOM - that's the error type and message<br>
                        2. Read UP to see the call stack<br>
                        3. Look for YOUR code (not library files)<br>
                        4. The last line of your code before the error is usually the problem<br>
                        5. Check variable values at that point
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Catching too broadly</h4>
                        <pre><code class="language-python"># Wrong - catches everything, hides bugs!
try:
    result = do_something()
except:  # Bare except - NEVER do this!
    pass

# Also wrong - too broad
except Exception:
    pass  # Silently ignoring all errors

# Correct - catch specific exceptions
try:
    result = do_something()
except ValueError:
    print("Invalid value provided")
except FileNotFoundError:
    print("File not found")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Ignoring the error message</h4>
                        <pre><code class="language-python"># Wrong - throwing away useful info!
try:
    data = json.loads(user_input)
except json.JSONDecodeError:
    print("Invalid JSON")  # What was wrong?

# Correct - use the error message
try:
    data = json.loads(user_input)
except json.JSONDecodeError as e:
    print(f"Invalid JSON at position {e.pos}: {e.msg}")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Catching exceptions in wrong order</h4>
                        <pre><code class="language-python"># Wrong - specific exception never reached!
try:
    open("file.txt")
except OSError:
    print("OS error")  # Catches FileNotFoundError too!
except FileNotFoundError:
    print("File not found")  # Never runs!

# Correct - specific exceptions first
try:
    open("file.txt")
except FileNotFoundError:
    print("File not found")  # Runs for missing files
except OSError:
    print("Other OS error")  # Catches remaining OS errors</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using exceptions for flow control</h4>
                        <pre><code class="language-python"># Wrong - using exceptions as if/else
try:
    value = my_dict[key]
except KeyError:
    value = default

# Correct - use dict.get() or 'in' check
value = my_dict.get(key, default)

# Or
if key in my_dict:
    value = my_dict[key]
else:
    value = default</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not reading the full traceback</h4>
                        <pre><code class="language-python"># Error: AttributeError: 'NoneType' has no attribute 'strip'
# Many developers just see "AttributeError" and get confused

# The key info is 'NoneType' - something returned None!
# Check what could be None:

result = get_user_input()  # This returned None!
cleaned = result.strip()   # Can't call .strip() on None

# Fix: Check for None
result = get_user_input()
if result is not None:
    cleaned = result.strip()</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Exception Identifier</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that identifies what type of exception a piece of code raises.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Write a function that takes a callable and returns the exception name</li>
                            <li>Return "No exception" if no error occurs</li>
                            <li>Test with various error-causing operations</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-errors-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-basics" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def identify_exception(func):
    """Run a function and return the exception type name."""
    try:
        func()
        return "No exception"
    except Exception as e:
        return type(e).__name__


# Test cases
test_cases = [
    ("Division by zero", lambda: 1 / 0),
    ("String + int", lambda: "a" + 1),
    ("List index", lambda: [1, 2, 3][10]),
    ("Dict key", lambda: {}["missing"]),
    ("Int parse", lambda: int("hello")),
    ("File open", lambda: open("nonexistent.txt")),
    ("No error", lambda: 1 + 1),
]

print("=== Exception Identifier ===\n")
for name, func in test_cases:
    result = identify_exception(func)
    print(f"{name:20} -> {result}")

# Expected output:
# Division by zero     -> ZeroDivisionError
# String + int         -> TypeError
# List index           -> IndexError
# Dict key             -> KeyError
# Int parse            -> ValueError
# File open            -> FileNotFoundError
# No error             -> No exception</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax errors:</strong> Detected before running, can't be caught</li>
                            <li><strong>Exceptions:</strong> Runtime errors, can be caught with try/except</li>
                            <li><strong>TypeError:</strong> Wrong type for operation</li>
                            <li><strong>ValueError:</strong> Right type, invalid value</li>
                            <li><strong>KeyError:</strong> Dictionary key not found</li>
                            <li><strong>IndexError:</strong> List index out of range</li>
                            <li><strong>FileNotFoundError:</strong> File doesn't exist</li>
                            <li><strong>Hierarchy:</strong> Exceptions inherit from parent classes</li>
                            <li><strong>Tracebacks:</strong> Read bottom-to-top for error details</li>
                            <li><strong>Best practice:</strong> Catch specific exceptions, not broad ones</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand what exceptions are, let's learn how to <strong>handle them</strong>
                    with <code>try/except</code>. You'll learn to catch exceptions gracefully, handle multiple
                    exception types, and keep your programs running even when errors occur!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-json.jsp" />
                    <jsp:param name="prevTitle" value="JSON Files" />
                    <jsp:param name="nextLink" value="errors-try-except.jsp" />
                    <jsp:param name="nextTitle" value="Try/Except" />
                    <jsp:param name="currentLessonId" value="errors-basics" />
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
