<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-context");
   request.setAttribute("currentModule", "File Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Context Managers - with Statement, __enter__, __exit__, contextlib | 8gwifi.org</title>
    <meta name="description"
        content="Master Python context managers - use the with statement for automatic resource management, create custom context managers with __enter__/__exit__, and use contextlib decorators.">
    <meta name="keywords"
        content="python context manager, python with statement, python __enter__, python __exit__, python contextlib, python resource management, python auto close">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Context Managers - with Statement, __enter__, __exit__, contextlib">
    <meta property="og:description" content="Master Python context managers: automatic resource management with the 'with' statement.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/files-context.jsp">
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
        "name": "Python Context Managers",
        "description": "Master Python context managers - use the with statement for automatic resource management and create custom context managers.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["The with statement", "Automatic resource cleanup", "Multiple context managers", "Custom __enter__ and __exit__", "contextlib module", "@contextmanager decorator"],
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

<body class="tutorial-body no-preview" data-lesson="files-context">
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
                    <span>Context Managers</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Context Managers</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Context managers are one of Python's most elegant features - they ensure resources
                    are properly acquired and released, even when errors occur. The <code>with</code> statement is the
                    Pythonic way to handle files, database connections, locks, and any resource that needs cleanup.
                    Understanding context managers will make your code safer, cleaner, and more professional!</p>

                    <!-- Section 1: Basics -->
                    <h2>The 'with' Statement</h2>
                    <p>The <code>with</code> statement guarantees that cleanup code runs no matter what - even if an
                    exception occurs. For files, this means they're always closed properly. Compare it to try/finally:
                    the <code>with</code> statement is cleaner and less error-prone.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/context-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why Use Context Managers?</strong><br>
                        - Automatic cleanup (files closed, connections released)<br>
                        - Exception-safe (cleanup runs even if errors occur)<br>
                        - Cleaner code (no explicit try/finally blocks)<br>
                        - Clear intent (setup and cleanup are paired together)<br>
                        - Less bugs (can't forget to close resources)
                    </div>

                    <!-- Section 2: Multiple -->
                    <h2>Multiple Context Managers</h2>
                    <p>You can use multiple context managers in a single <code>with</code> statement - perfect for
                    copying files, processing input to output, or managing multiple resources together. All resources
                    are cleaned up in reverse order of acquisition, ensuring proper shutdown.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/context-multiple.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-multiple" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Multiple Files Syntax (Python 3.10+):</strong>
                        <pre><code class="language-python">with (
    open("input.txt") as infile,
    open("output.txt", "w") as outfile,
    open("log.txt", "a") as logfile
):
    # All three files available here</code></pre>
                        For older Python, use: <code>with open("a") as f1, open("b") as f2:</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Custom -->
                    <h2>Creating Custom Context Managers</h2>
                    <p>Any class can become a context manager by implementing <code>__enter__</code> and
                    <code>__exit__</code> methods. The <code>__enter__</code> method sets up the resource and returns
                    what gets bound to the <code>as</code> variable. The <code>__exit__</code> method handles cleanup
                    and can optionally suppress exceptions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/context-custom.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-custom" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Exception Handling in __exit__:</strong> The <code>__exit__</code> method receives
                        exception info as arguments. Return <code>True</code> to suppress the exception (usually not
                        recommended), or <code>False</code> to let it propagate. The cleanup code should run regardless!
                    </div>

                    <!-- Section 4: contextlib -->
                    <h2>The contextlib Module</h2>
                    <p>Writing a class with <code>__enter__</code> and <code>__exit__</code> can be verbose. The
                    <code>contextlib</code> module provides shortcuts: the <code>@contextmanager</code> decorator
                    turns a generator function into a context manager, and utilities like <code>suppress()</code>
                    and <code>closing()</code> handle common patterns.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/context-contextlib.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-contextlib" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>contextlib Utilities:</strong><br>
                        <code>@contextmanager</code> - Create context manager from generator<br>
                        <code>closing(obj)</code> - Call obj.close() on exit<br>
                        <code>suppress(*exceptions)</code> - Ignore specified exceptions<br>
                        <code>redirect_stdout(f)</code> - Redirect print() to file<br>
                        <code>nullcontext()</code> - Do-nothing context manager<br>
                        <code>ExitStack()</code> - Manage dynamic number of context managers
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using file object after 'with' block</h4>
                        <pre><code class="language-python"># Wrong - file is closed!
with open("data.txt", "r") as f:
    pass

content = f.read()  # ValueError: I/O on closed file

# Correct - read inside the block
with open("data.txt", "r") as f:
    content = f.read()

# Or store what you need
with open("data.txt", "r") as f:
    lines = f.readlines()  # Now 'lines' persists</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting 'as' when you need the resource</h4>
                        <pre><code class="language-python"># Wrong - no way to access the file!
with open("data.txt", "r"):
    content = ???  # Can't read without variable

# Correct - bind to variable
with open("data.txt", "r") as f:
    content = f.read()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not yielding in @contextmanager</h4>
                        <pre><code class="language-python">from contextlib import contextmanager

# Wrong - forgot yield!
@contextmanager
def broken_manager():
    print("Setup")
    # Missing yield!
    print("Cleanup")

# Correct - must yield
@contextmanager
def working_manager():
    print("Setup")
    yield  # Control returns here
    print("Cleanup")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Swallowing all exceptions in __exit__</h4>
                        <pre><code class="language-python"># Wrong - hides all errors!
def __exit__(self, exc_type, exc_val, exc_tb):
    self.cleanup()
    return True  # Suppresses ALL exceptions!

# Correct - only suppress specific exceptions
def __exit__(self, exc_type, exc_val, exc_tb):
    self.cleanup()
    if exc_type is SomeExpectedException:
        return True  # Only suppress this one
    return False  # Let others propagate</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Cleanup not in finally block for @contextmanager</h4>
                        <pre><code class="language-python">from contextlib import contextmanager

# Wrong - cleanup skipped on exception!
@contextmanager
def unsafe():
    resource = acquire()
    yield resource
    release(resource)  # Skipped if exception!

# Correct - use try/finally
@contextmanager
def safe():
    resource = acquire()
    try:
        yield resource
    finally:
        release(resource)  # Always runs</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Database Connection Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a context manager that simulates database connection handling.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a class-based context manager for database connections</li>
                            <li>Print messages when connecting and disconnecting</li>
                            <li>Include a query() method to simulate database queries</li>
                            <li>Ensure the connection closes even if an error occurs</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-files-context.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-context" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class DatabaseConnection:
    """Simulated database connection context manager."""

    def __init__(self, database_name):
        self.database_name = database_name
        self.connected = False

    def __enter__(self):
        print(f"Connecting to database: {self.database_name}")
        self.connected = True
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Disconnecting from: {self.database_name}")
        self.connected = False
        if exc_type:
            print(f"Error occurred: {exc_val}")
        return False  # Don't suppress exceptions

    def query(self, sql):
        if not self.connected:
            raise RuntimeError("Not connected!")
        print(f"Executing: {sql}")
        return f"Results for: {sql}"


# Test normal operation
print("=== Normal Operation ===")
with DatabaseConnection("myapp.db") as db:
    result = db.query("SELECT * FROM users")
    print(result)
print()

# Test with exception
print("=== With Exception ===")
try:
    with DatabaseConnection("myapp.db") as db:
        db.query("SELECT * FROM users")
        raise ValueError("Simulated error!")
except ValueError:
    print("Exception caught outside context")
print()

# Verify connection is closed after exception
print(f"Connection state: {'connected' if db.connected else 'disconnected'}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>with statement:</strong> <code>with open("f") as f:</code> - auto cleanup</li>
                            <li><strong>Multiple resources:</strong> <code>with open("a") as f1, open("b") as f2:</code></li>
                            <li><strong>__enter__:</strong> Setup code, return value bound to <code>as</code> variable</li>
                            <li><strong>__exit__:</strong> Cleanup code, receives exception info, return True to suppress</li>
                            <li><strong>@contextmanager:</strong> Create from generator with yield</li>
                            <li><strong>closing():</strong> Call .close() automatically</li>
                            <li><strong>suppress():</strong> Ignore specific exceptions</li>
                            <li><strong>Always cleanup:</strong> Use try/finally in @contextmanager</li>
                            <li><strong>Exception safety:</strong> Cleanup runs even if errors occur</li>
                            <li><strong>Best practice:</strong> Use context managers for all resources</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand context managers, let's explore <strong>working with paths</strong> using
                    Python's <code>os.path</code> and the modern <code>pathlib</code> module. These tools make it easy
                    to navigate directories, join paths, check file existence, and write cross-platform code!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-write.jsp" />
                    <jsp:param name="prevTitle" value="Writing Files" />
                    <jsp:param name="nextLink" value="files-paths.jsp" />
                    <jsp:param name="nextTitle" value="Working with Paths" />
                    <jsp:param name="currentLessonId" value="files-context" />
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
