<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "errors-try-except");
   request.setAttribute("currentModule", "Error Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Try/Except - Exception Handling, Multiple Except, Error Patterns | 8gwifi.org</title>
    <meta name="description"
        content="Master Python try/except for exception handling. Learn to catch specific exceptions, handle multiple error types, access exception details, and implement common error handling patterns.">
    <meta name="keywords"
        content="python try except, python exception handling, python catch exception, python error handling, python multiple except, python exception patterns">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Try/Except - Exception Handling, Multiple Except, Error Patterns">
    <meta property="og:description" content="Master Python try/except: catch exceptions, handle multiple error types, and implement robust error handling patterns.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/errors-try-except.jsp">
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
        "name": "Python Try/Except",
        "description": "Master Python try/except for exception handling. Learn to catch specific exceptions, handle multiple error types, and implement common error handling patterns.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Try/except syntax", "Catching specific exceptions", "Multiple except clauses", "Accessing exception details", "Exception object attributes", "Common error handling patterns", "Safe type conversion", "Retry patterns"],
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

<body class="tutorial-body no-preview" data-lesson="errors-try-except">
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
                    <span>Try/Except</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Try/Except</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>try/except</code> block is Python's primary mechanism for handling
                    exceptions. Instead of crashing when an error occurs, you can catch the exception, handle it
                    gracefully, and keep your program running. This is essential for building robust applications
                    that handle unexpected situations - from invalid user input to network failures!</p>

                    <!-- Section 1: Basic Try/Except -->
                    <h2>Basic Try/Except</h2>
                    <p>The basic structure is simple: code that might fail goes in the <code>try</code> block,
                    and the error handling code goes in the <code>except</code> block. When an exception occurs
                    in the try block, Python immediately jumps to the except block. If no exception occurs, the
                    except block is skipped entirely.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/try-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>How Try/Except Works:</strong><br>
                        1. Python executes code in the <code>try</code> block<br>
                        2. If an exception occurs, execution jumps to the matching <code>except</code> block<br>
                        3. If no exception occurs, the <code>except</code> block is skipped<br>
                        4. Either way, code after try/except continues normally<br><br>
                        <strong>Key insight:</strong> Only lines <em>after</em> the exception are skipped in try block - lines before it still run!
                    </div>

                    <!-- Section 2: Multiple Except Clauses -->
                    <h2>Multiple Except Clauses</h2>
                    <p>Different errors require different handling. You can have multiple <code>except</code>
                    clauses, each catching a specific exception type. Python checks them in order and runs the
                    first matching handler. You can also catch multiple exception types in a single clause using
                    a tuple.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/try-multiple.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-multiple" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Order Matters!</strong> Put specific exceptions before general ones. If you catch
                        <code>Exception</code> first, more specific handlers will never run because <code>Exception</code>
                        catches everything. Python uses the first matching handler, not the most specific one.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Accessing Exception Details -->
                    <h2>Accessing Exception Details</h2>
                    <p>Use <code>as</code> to capture the exception object and access its details. Different
                    exception types have different attributes - <code>FileNotFoundError</code> has <code>filename</code>,
                    <code>KeyError</code> has <code>args[0]</code> for the missing key. You can also re-raise
                    exceptions after logging them.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/try-access-exception.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-access" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Useful Exception Attributes:</strong><br>
                        <code>str(e)</code> - Human-readable error message<br>
                        <code>e.args</code> - Tuple of arguments passed to exception<br>
                        <code>type(e).__name__</code> - Exception class name as string<br>
                        <code>repr(e)</code> - Debug representation with class name<br>
                        <code>e.__context__</code> - Original exception if this was raised during handling another
                    </div>

                    <!-- Section 4: Common Patterns -->
                    <h2>Common Error Handling Patterns</h2>
                    <p>Exception handling isn't just about catching errors - it's about handling them intelligently.
                    These patterns appear frequently in production code: safe file reading, type conversion with
                    defaults, retry logic for flaky operations, and user-friendly error messages.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/try-patterns.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-patterns" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Pattern Summary:</strong><br>
                        <code>Safe File Reading</code> - Return None or default on file errors<br>
                        <code>Safe Type Conversion</code> - Convert with fallback: <code>safe_int("x", 0)</code><br>
                        <code>Retry Pattern</code> - Retry flaky operations N times before giving up<br>
                        <code>User-Friendly Messages</code> - Convert technical errors to helpful messages<br>
                        <code>Cleanup Pattern</code> - Use finally to ensure cleanup always happens
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using bare except</h4>
                        <pre><code class="language-python"># Wrong - catches EVERYTHING including Ctrl+C!
try:
    risky_operation()
except:  # Bare except - NEVER do this!
    pass  # Silently swallows all errors

# Wrong - too broad, hides bugs
try:
    risky_operation()
except Exception:
    pass  # Still catches too much

# Correct - catch specific exceptions
try:
    risky_operation()
except ValueError:
    print("Invalid value")
except ConnectionError:
    print("Network failed")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Catching exceptions in wrong order</h4>
                        <pre><code class="language-python"># Wrong - FileNotFoundError is never reached!
try:
    open("missing.txt")
except OSError:
    print("OS error")  # This catches FileNotFoundError too
except FileNotFoundError:
    print("File not found")  # NEVER RUNS - dead code!

# Correct - specific exceptions first
try:
    open("missing.txt")
except FileNotFoundError:
    print("File not found")  # Specific first
except OSError:
    print("Other OS error")  # General second</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Swallowing exceptions silently</h4>
                        <pre><code class="language-python"># Wrong - error disappears, debugging nightmare!
def get_user(user_id):
    try:
        return database.fetch(user_id)
    except:
        return None  # What went wrong? Nobody knows!

# Correct - at least log the error
import logging

def get_user(user_id):
    try:
        return database.fetch(user_id)
    except DatabaseError as e:
        logging.error(f"Failed to fetch user {user_id}: {e}")
        return None</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using exceptions for flow control</h4>
                        <pre><code class="language-python"># Wrong - slow and unclear, exceptions aren't for flow control
def find_item(items, target):
    try:
        return items.index(target)
    except ValueError:
        return -1

# Also wrong for dictionaries
try:
    value = my_dict[key]
except KeyError:
    value = default

# Correct - use built-in methods
def find_item(items, target):
    return items.index(target) if target in items else -1

# Correct for dictionaries
value = my_dict.get(key, default)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Too much code in try block</h4>
                        <pre><code class="language-python"># Wrong - too much in try, unclear what might fail
try:
    data = load_config()
    processed = process_data(data)
    result = calculate(processed)
    save_result(result)
    send_notification()
except Exception as e:
    print(f"Something failed: {e}")  # Which operation?

# Correct - minimal try blocks, clear error handling
try:
    data = load_config()
except FileNotFoundError:
    data = default_config()

try:
    processed = process_data(data)
    result = calculate(processed)
except ValueError as e:
    print(f"Invalid data: {e}")
    return

save_result(result)  # Let this fail if it fails</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Safe Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a calculator function that handles all possible errors gracefully.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Handle division by zero</li>
                            <li>Handle invalid number inputs</li>
                            <li>Handle unknown operations</li>
                            <li>Return a tuple of (success, result_or_error)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-errors-try-except.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-try-except" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def safe_calculate(a, b, operation):
    """
    Safely perform calculation with full error handling.
    Returns (True, result) on success, (False, error_msg) on failure.
    """
    # Convert inputs to numbers
    try:
        num_a = float(a)
        num_b = float(b)
    except (ValueError, TypeError) as e:
        return (False, f"Invalid number: {e}")

    # Perform operation
    operations = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y,
        '**': lambda x, y: x ** y,
    }

    if operation not in operations:
        return (False, f"Unknown operation: {operation}")

    try:
        result = operations[operation](num_a, num_b)
        return (True, result)
    except ZeroDivisionError:
        return (False, "Cannot divide by zero")
    except OverflowError:
        return (False, "Result too large")


# Test the calculator
test_cases = [
    (10, 5, '+'),      # Normal addition
    (10, 0, '/'),      # Division by zero
    ('abc', 5, '+'),   # Invalid input
    (10, 5, '%'),      # Unknown operation
    (2, 1000, '**'),   # Large exponent (might overflow)
    ('10', '3', '-'),  # String numbers (should work)
]

print("=== Safe Calculator Tests ===\n")
for a, b, op in test_cases:
    success, result = safe_calculate(a, b, op)
    status = "OK" if success else "ERR"
    print(f"{a} {op} {b} => [{status}] {result}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>try/except:</strong> Code in try runs; if it fails, except handles the error</li>
                            <li><strong>Specific exceptions:</strong> Always catch specific types, not bare except</li>
                            <li><strong>Multiple except:</strong> Handle different errors differently, specific first</li>
                            <li><strong>as keyword:</strong> Capture exception: <code>except ValueError as e</code></li>
                            <li><strong>Exception attributes:</strong> <code>str(e)</code>, <code>e.args</code>, <code>type(e).__name__</code></li>
                            <li><strong>Tuple syntax:</strong> <code>except (TypeError, ValueError)</code> for multiple types</li>
                            <li><strong>Re-raise:</strong> Use bare <code>raise</code> to re-raise after logging</li>
                            <li><strong>Keep try blocks small:</strong> Only wrap code that might fail</li>
                            <li><strong>Don't swallow errors:</strong> At minimum, log what went wrong</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now you know how to catch exceptions, but what about cleanup code that must always run?
                    And what if you want to do something only when no exception occurs? Next, we'll learn about
                    <code>finally</code> for guaranteed cleanup and <code>else</code> for success-only code -
                    completing your exception handling toolkit!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="errors-basics.jsp" />
                    <jsp:param name="prevTitle" value="Exceptions Basics" />
                    <jsp:param name="nextLink" value="errors-finally.jsp" />
                    <jsp:param name="nextTitle" value="Finally & Else" />
                    <jsp:param name="currentLessonId" value="errors-try-except" />
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
