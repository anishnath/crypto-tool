<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-decorators" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Decorators - Function Decorators, @ Syntax & Wrappers | 8gwifi.org</title>
            <meta name="description"
                content="Master Python decorators and the @ syntax. Learn how to modify function behavior without changing the function itself, create wrappers, and build reusable decorator patterns.">
            <meta name="keywords"
                content="python decorator, python wrapper, python @ syntax, higher order function, function decorator, python metaprogramming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Decorators - Function Decorators, @ Syntax & Wrappers">
            <meta property="og:description"
                content="Master Python decorators and the @ syntax. Learn how to modify function behavior without changing the function itself with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-decorators.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "name": "Python Decorators",
        "description": "Master Python decorators and the @ syntax. Learn how to modify function behavior without changing the function itself.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Function decorators", "@ decorator syntax", "Wrapper functions", "Decorator with arguments", "Multiple decorators", "Class decorators", "Decorator patterns", "functools.wraps"],
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

        <body class="tutorial-body no-preview" data-lesson="adv-decorators">
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
                                    <span>Advanced</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Decorators</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Decorators are a powerful Python feature that lets you modify or
                                        extend the behavior of functions (or classes) without permanently changing them.
                                        They work by wrapping functions in other functions, adding functionality like
                                        timing, logging, caching, or access control. The <code>@</code> syntax makes
                                        applying decorators clean and readable!</p>

                                    <h2>Understanding Decorators</h2>
                                    <p>At its core, a decorator is a function that takes another function as an argument
                                        and returns a modified (or wrapped) version of it. This allows you to add
                                        behavior before or after the original function executes.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-decorators-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How Decorators Work:</strong><br>
                                        1. A decorator is a function that accepts a function as an argument<br>
                                        2. It defines an inner wrapper function that adds extra behavior<br>
                                        3. The wrapper calls the original function and may add code before/after<br>
                                        4. The decorator returns the wrapper function<br>
                                        5. When you call the decorated function, you're actually calling the wrapper
                                    </div>

                                    <h2>The @ Syntax</h2>
                                    <p>Python provides the <code>@decorator_name</code> syntax as syntactic sugar for
                                        applying decorators. Instead of manually wrapping functions, you can simply place
                                        <code>@decorator</code> above the function definition!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-decorators-syntax.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-syntax" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The <code>@decorator</code> syntax is equivalent to
                                        <code>function = decorator(function)</code>. It's applied at function definition
                                        time, not when the function is called!
                                    </div>

                                    <h2>Preserving Function Metadata</h2>
                                    <p>By default, decorators can hide the original function's name, docstring, and
                                        other metadata. Use <code>functools.wraps</code> to preserve this information,
                                        which is important for debugging and documentation!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-decorators-wraps.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-wraps" />
                                    </jsp:include>

                                    <h2>Decorators with Arguments</h2>
                                    <p>Sometimes you want decorators that accept arguments to customize their behavior.
                                        This requires an extra level of function nesting - a decorator factory that returns
                                        the actual decorator!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-decorators-args.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-args" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> When using decorators with arguments, you need three
                                        levels: the decorator factory (accepts args), the decorator (accepts function),
                                        and the wrapper (calls the function). Don't forget the parentheses when calling:
                                        <code>@decorator(args)</code> not <code>@decorator</code>!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Multiple Decorators</h2>
                                    <p>You can apply multiple decorators to a single function. They're applied from
                                        bottom to top (the one closest to the function is applied first).</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-decorators-multiple.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-multiple" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting parentheses when decorator needs arguments</h4>
                                        <pre><code class="language-python"># Wrong - missing parentheses
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                func(*args, **kwargs)
        return wrapper
    return decorator

@repeat  # Missing parentheses - will crash!
def greet():
    print("Hello")

# Correct - use parentheses
@repeat(3)
def greet():
    print("Hello")</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not preserving function metadata</h4>
                                        <pre><code class="language-python"># Wrong - loses original function info
def timer(func):
    def wrapper(*args, **kwargs):
        # ... timing code ...
        return func(*args, **kwargs)
    return wrapper

@timer
def calculate():
    """Performs complex calculation."""
    pass

print(calculate.__name__)  # 'wrapper', not 'calculate'!
print(calculate.__doc__)   # None, not the docstring!

# Correct - use functools.wraps
from functools import wraps

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        # ... timing code ...
        return func(*args, **kwargs)
    return wrapper</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not accepting *args and **kwargs in wrapper</h4>
                                        <pre><code class="language-python"># Wrong - only works with no-argument functions
def logger(func):
    def wrapper():  # No arguments!
        print("Calling function")
        return func()
    return wrapper

@logger
def add(a, b):  # Will crash when called with args!
    return a + b

# Correct - accept any arguments
def logger(func):
    def wrapper(*args, **kwargs):  # Accept any arguments
        print("Calling function")
        return func(*args, **kwargs)  # Pass them through
    return wrapper</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Create a Timing Decorator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a decorator that measures and prints the
                                            execution time of a function. Use the <code>time</code> module and the
                                            <code>@</code> syntax.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Import <code>time</code> module</li>
                                            <li>Create a <code>timing</code> decorator function</li>
                                            <li>Use <code>functools.wraps</code> to preserve function metadata</li>
                                            <li>Record start time before calling the function, end time after</li>
                                            <li>Print the elapsed time in seconds</li>
                                            <li>Apply the decorator to a test function</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-decorators.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-decorators" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">import time
from functools import wraps

def timing(func):
    """Decorator that measures function execution time."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        elapsed = end - start
        print(f"{func.__name__} took {elapsed:.4f} seconds")
        return result
    return wrapper


@timing
def slow_function():
    """Simulates a slow operation."""
    time.sleep(0.5)  # Sleep for 0.5 seconds
    return "Done"

@timing
def fast_function(n):
    """Performs quick calculation."""
    return sum(range(n))

# Test the decorator
slow_function()
fast_function(1000000)</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Decorators:</strong> Functions that modify or extend other
                                                functions without changing them permanently</li>
                                            <li><strong>@ Syntax:</strong> <code>@decorator</code> is shorthand for
                                                <code>function = decorator(function)</code></li>
                                            <li><strong>Wrapper Pattern:</strong> Decorators wrap functions in wrapper
                                                functions that add behavior before/after execution</li>
                                            <li><strong>functools.wraps:</strong> Preserves original function metadata
                                                (name, docstring) for debugging and documentation</li>
                                            <li><strong>Decorator Arguments:</strong> Use decorator factories (functions
                                                returning decorators) when decorators need arguments</li>
                                            <li><strong>Multiple Decorators:</strong> Applied bottom-to-top; closest to
                                                function is applied first</li>
                                            <li><strong>Accept *args, **kwargs:</strong> Wrapper functions should accept
                                                any arguments and pass them to the original function</li>
                                            <li><strong>Common Uses:</strong> Timing, logging, caching, access control,
                                                validation, retry logic</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Decorators are powerful tools for extending function behavior! Next, we'll explore
                                        <strong>context managers</strong> and the <code>with</code> statement, which
                                        provide a clean way to manage resources and ensure proper cleanup. Context
                                        managers work beautifully with decorators through the <code>@contextmanager</code>
                                        decorator!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-generators.jsp" />
                                    <jsp:param name="prevTitle" value="Generators" />
                                    <jsp:param name="nextLink" value="adv-context.jsp" />
                                    <jsp:param name="nextTitle" value="Context Managers" />
                                    <jsp:param name="currentLessonId" value="adv-decorators" />
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