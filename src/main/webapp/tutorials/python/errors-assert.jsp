<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "errors-assert");
   request.setAttribute("currentModule", "Error Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Assert - Debugging, Invariants, When to Use Assertions | 8gwifi.org</title>
    <meta name="description"
        content="Master Python assert statement for debugging. Learn when to use assertions, assert vs raise, internal invariants, and common pitfalls to avoid.">
    <meta name="keywords"
        content="python assert, python assertions, python debugging, python AssertionError, python invariants, assert vs raise">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Assert - Debugging, Invariants, When to Use Assertions">
    <meta property="og:description" content="Master Python assert for debugging: internal invariants, helpful messages, and when NOT to use assertions.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/errors-assert.jsp">
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
        "name": "Python Assertions",
        "description": "Master Python assert statement for debugging. Learn when to use assertions, assert vs raise, and common pitfalls to avoid.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Assert statement syntax", "AssertionError", "Assert messages", "Internal invariants", "Preconditions and postconditions", "Assert vs raise", "Optimization mode", "Common pitfalls"],
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

<body class="tutorial-body no-preview" data-lesson="errors-assert">
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
                    <span>Assertions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Assertions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>assert</code> statement is a debugging aid that tests conditions
                    during development. If a condition is true, nothing happens. If it's false, Python raises
                    <code>AssertionError</code>. Unlike exceptions for handling errors, assertions catch bugs -
                    they verify things that should NEVER be false if your code is correct!</p>

                    <!-- Section 1: Assert Basics -->
                    <h2>Assert Statement Basics</h2>
                    <p>The basic syntax is <code>assert condition</code> or <code>assert condition, message</code>.
                    When the condition is true, nothing happens and execution continues. When false, Python raises
                    <code>AssertionError</code> with your message. The key insight: assertions can be disabled
                    with the <code>-O</code> flag, so never use them for critical checks!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/assert-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Assert Syntax:</strong><br>
                        <code>assert condition</code> - Raises AssertionError if condition is false<br>
                        <code>assert condition, message</code> - Same, with custom error message<br><br>
                        <strong>Internally equivalent to:</strong><br>
                        <code>if __debug__ and not condition: raise AssertionError(message)</code>
                    </div>

                    <!-- Section 2: Assert Messages -->
                    <h2>Writing Helpful Assert Messages</h2>
                    <p>Always include a message with your assertions. Good messages include the actual values
                    that caused the failure, not just what was expected. This makes debugging much easier.
                    The message is only evaluated when the assertion fails, so computing it has no performance
                    impact during normal execution.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/assert-messages.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-messages" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Good Assert Messages:</strong><br>
                        <code>assert x > 0, f"x must be positive, got {x}"</code> - Shows actual value<br>
                        <code>assert key in data, f"Missing {key} in {list(data.keys())}"</code> - Shows context<br>
                        <code>assert result == expected, f"Expected {expected}, got {result}"</code> - Shows both<br><br>
                        Bad: <code>assert x > 0</code> - No information on what went wrong!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: When to Use Assert -->
                    <h2>When to Use Assertions</h2>
                    <p>Use assertions for things that should NEVER be false if your code is correct - internal
                    invariants, preconditions for internal functions, postconditions to verify results, and
                    sanity checks in complex algorithms. Assertions document your assumptions and catch bugs
                    during development.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/assert-usecases.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-usecases" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Use Assert For:</strong><br>
                        - Internal invariants (things that MUST be true)<br>
                        - Development-time sanity checks<br>
                        - Documenting assumptions in code<br>
                        - Catching programmer errors (bugs)<br>
                        - Verifying algorithm correctness<br><br>
                        <strong>Key principle:</strong> Assertions catch BUGS, not bad input!
                    </div>

                    <!-- Section 4: Pitfalls -->
                    <h2>Assert Pitfalls - When NOT to Use</h2>
                    <p>Never use assert for input validation, security checks, or anything that must work
                    in production. Python's <code>-O</code> (optimize) flag disables all assertions! Also
                    watch out for the tuple syntax bug: <code>assert(condition, message)</code> is always
                    true because it's a non-empty tuple.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/assert-pitfalls.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-pitfalls" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>NEVER Use Assert For:</strong><br>
                        - User input validation (use <code>if</code> + <code>raise ValueError</code>)<br>
                        - Security/authentication checks (use proper auth exceptions)<br>
                        - File/network operations (use proper error handling)<br>
                        - Anything that could fail in production<br><br>
                        <strong>Why?</strong> Running <code>python -O</code> removes ALL assertions!
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using assert for input validation</h4>
                        <pre><code class="language-python"># WRONG - assert disabled with python -O!
def process_payment(amount):
    assert amount > 0, "Amount must be positive"  # DANGEROUS!
    charge_card(amount)

# CORRECT - always validate with if/raise
def process_payment(amount):
    if amount <= 0:
        raise ValueError("Amount must be positive")
    charge_card(amount)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. The tuple bug - always true!</h4>
                        <pre><code class="language-python"># WRONG - this ALWAYS passes!
x = -5
assert(x > 0, "x must be positive")  # (False, "msg") is truthy tuple!

# CORRECT - no parentheses
x = -5
assert x > 0, "x must be positive"  # Properly fails

# Or use explicit parentheses only around condition
assert (x > 0), "x must be positive"  # Also correct</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Side effects in assert (removed with -O)</h4>
                        <pre><code class="language-python"># WRONG - pop() doesn't happen with -O!
assert items.pop() == expected_item

# CORRECT - separate operation from assertion
item = items.pop()
assert item == expected_item

# WRONG - file never closes with -O!
assert file.close() is None

# CORRECT - close normally, then verify if needed
file.close()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. No message (hard to debug)</h4>
                        <pre><code class="language-python"># WRONG - no information on failure
assert user_id in valid_users

# CORRECT - include useful context
assert user_id in valid_users, \
    f"User {user_id} not found. Valid: {list(valid_users)[:5]}..."

# WRONG - message just restates condition
assert x > 0, "x must be greater than 0"

# CORRECT - show actual value
assert x > 0, f"x must be positive, got {x}"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Using assert for security checks</h4>
                        <pre><code class="language-python"># WRONG - security bypassed with -O!
def delete_all_data(user):
    assert user.is_admin, "Only admins can delete"  # DANGEROUS!
    database.delete_all()

# CORRECT - always check permissions
def delete_all_data(user):
    if not user.is_admin:
        raise PermissionError("Only admins can delete")
    database.delete_all()</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Debug Helper</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function with proper assertions for debugging.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a <code>calculate_average</code> function</li>
                            <li>Add assertions for internal invariants (not input validation)</li>
                            <li>Include helpful messages with actual values</li>
                            <li>Add a postcondition to verify the result</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-errors-assert.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-assert" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def calculate_average(numbers):
    """
    Calculate average of a list of numbers.
    Uses assertions to catch bugs, not validate input.
    """
    # Input validation (NOT assertions - these are user-facing)
    if not isinstance(numbers, list):
        raise TypeError(f"Expected list, got {type(numbers).__name__}")
    if len(numbers) == 0:
        raise ValueError("Cannot calculate average of empty list")

    # Calculate sum
    total = sum(numbers)

    # Internal invariant: length should still be positive
    n = len(numbers)
    assert n > 0, f"Bug: length became {n} after sum()"

    # Calculate average
    average = total / n

    # Postcondition: average should be within range of input values
    min_val = min(numbers)
    max_val = max(numbers)
    assert min_val <= average <= max_val, \
        f"Bug: average {average} outside range [{min_val}, {max_val}]"

    return average


# Test the function
test_cases = [
    [1, 2, 3, 4, 5],
    [10, 20, 30],
    [100],
    [-5, 0, 5],
]

print("=== Calculate Average Tests ===\n")
for numbers in test_cases:
    result = calculate_average(numbers)
    print(f"avg({numbers}) = {result}")

# Test error cases
print("\n=== Error Cases ===")
try:
    calculate_average([])
except ValueError as e:
    print(f"Empty list: {e}")

try:
    calculate_average("not a list")
except TypeError as e:
    print(f"Wrong type: {e}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>assert:</strong> <code>assert condition, message</code> - raises AssertionError if false</li>
                            <li><strong>Purpose:</strong> Catch bugs during development, not handle errors</li>
                            <li><strong>Good for:</strong> Internal invariants, postconditions, sanity checks</li>
                            <li><strong>NOT for:</strong> Input validation, security checks, production checks</li>
                            <li><strong>Messages:</strong> Always include actual values: <code>f"got {x}"</code></li>
                            <li><strong>-O flag:</strong> <code>python -O</code> disables ALL assertions</li>
                            <li><strong>Tuple bug:</strong> <code>assert(x, "msg")</code> is always true!</li>
                            <li><strong>Rule:</strong> If it could fail from user input, use raise not assert</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations! You've completed the Error Handling module. You now know how to catch
                    exceptions with <code>try/except</code>, clean up with <code>finally</code>, raise your own
                    exceptions, create custom exception classes, and use assertions for debugging. Next, we'll
                    move on to Object-Oriented Programming and learn how to create classes and objects!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="errors-raise.jsp" />
                    <jsp:param name="prevTitle" value="Raising Exceptions" />
                    <jsp:param name="nextLink" value="oop-classes.jsp" />
                    <jsp:param name="nextTitle" value="Classes & Objects" />
                    <jsp:param name="currentLessonId" value="errors-assert" />
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
