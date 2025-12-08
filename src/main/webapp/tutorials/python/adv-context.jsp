<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-context" ); request.setAttribute("currentModule", "Advanced Topics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Context Managers - with Statement, __enter__ & __exit__ | 8gwifi.org</title>
            <meta name="description"
                content="Master Python context managers and the with statement. Learn __enter__ and __exit__ methods, resource management, creating custom context managers, and the @contextmanager decorator.">
            <meta name="keywords"
                content="python context manager, python with statement, python __enter__, python __exit__, resource management, python contextlib">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Context Managers - with Statement, __enter__ & __exit__">
            <meta property="og:description"
                content="Master Python context managers and the with statement. Learn __enter__ and __exit__ methods for proper resource management with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-context.jsp">
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
        "name": "Python Context Managers",
        "description": "Master Python context managers and the with statement. Learn __enter__ and __exit__ methods for proper resource management.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["with statement", "__enter__ method", "__exit__ method", "Resource management", "Custom context managers", "@contextmanager decorator", "Multiple context managers", "Exception handling in context managers"],
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

        <body class="tutorial-body no-preview" data-lesson="adv-context">
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
                                    <h1 class="lesson-title">Context Managers</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Context managers provide a clean way to manage resources that need
                                        setup and cleanup. Using the <code>with</code> statement ensures resources are
                                        properly acquired and released, even if exceptions occur. This eliminates the need
                                        for try/finally blocks and makes your code more readable and robust!</p>

                                    <h2>The with Statement</h2>
                                    <p>The <code>with</code> statement is Python's way of using context managers. When you
                                        use <code>with</code>, Python automatically calls setup code (enter) before the
                                        block and cleanup code (exit) after, even if an exception occurs. The most common
                                        example is file handling!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-context-with.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-with" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How with Works:</strong><br>
                                        1. The expression after <code>with</code> must return a context manager<br>
                                        2. Python calls <code>__enter__()</code> before the block executes<br>
                                        3. The return value of <code>__enter__()</code> is assigned to the variable after
                                        <code>as</code><br>
                                        4. The code block executes<br>
                                        5. Python calls <code>__exit__()</code> after the block, even if an exception
                                        occurred<br>
                                        6. <code>__exit__()</code> receives exception info if one occurred
                                    </div>

                                    <h2>The Context Manager Protocol</h2>
                                    <p>To create a custom context manager, you need a class that implements
                                        <code>__enter__()</code> and <code>__exit__()</code> methods. The
                                        <code>__enter__</code> method runs setup code and optionally returns a value. The
                                        <code>__exit__</code> method handles cleanup.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-context-protocol.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-protocol" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The <code>__exit__</code> method receives three arguments
                                        when an exception occurs: exception type, exception value, and traceback. Returning
                                        <code>True</code> from <code>__exit__</code> suppresses the exception (use
                                        sparingly)!</div>

                                    <h2>Multiple Context Managers</h2>
                                    <p>You can use multiple context managers in a single <code>with</code> statement,
                                        either on separate lines or using commas. This is perfect for managing multiple
                                        resources simultaneously!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-context-multiple.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-multiple" />
                                    </jsp:include>

                                    <h2>Using @contextmanager</h2>
                                    <p>The <code>contextlib</code> module provides the <code>@contextmanager</code>
                                        decorator, which lets you create context managers using generator functions. This is
                                        often simpler than creating a full class!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-context-decorator.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-decorator" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> With <code>@contextmanager</code>, everything before
                                        <code>yield</code> is setup code (like <code>__enter__</code>), and everything
                                        after <code>yield</code> is cleanup code (like <code>__exit__</code>). If an
                                        exception occurs, Python continues after <code>yield</code> to run cleanup, so use
                                        try/finally if needed!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not using with for resources</h4>
                                        <pre><code class="language-python"># Wrong - file might not close if exception occurs
file = open("data.txt")
content = file.read()
# What if exception happens here?
file.close()  # Might not execute!

# Correct - use with statement
with open("data.txt") as file:
    content = file.read()
# File automatically closed, even if exception occurs</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting to handle exceptions in __exit__</h4>
                                        <pre><code class="language-python"># Wrong - cleanup might fail and hide original exception
class MyContext:
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cleanup()  # If this raises, original exception lost!

# Correct - handle cleanup exceptions
class MyContext:
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        try:
            self.cleanup()
        except Exception:
            pass  # Log but don't raise
        return False  # Don't suppress original exception</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Returning True from __exit__ unintentionally</h4>
                                        <pre><code class="language-python"># Wrong - suppresses all exceptions!
class SuppressContext:
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        return True  # Suppresses ALL exceptions!

with SuppressContext():
    raise ValueError("This error is hidden!")  # Won't propagate!

# Correct - only suppress specific exceptions
class SuppressContext:
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type == ValueError:  # Only suppress ValueError
            return True  # Suppress this specific exception
        return False  # Let others propagate</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Create a Timer Context Manager</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a custom context manager class that measures
                                            execution time. Use <code>__enter__</code> and <code>__exit__</code> methods,
                                            and print the elapsed time when exiting.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Import the <code>time</code> module</li>
                                            <li>Create a <code>Timer</code> class with <code>__enter__</code> and
                                                <code>__exit__</code> methods</li>
                                            <li>Record start time in <code>__enter__</code></li>
                                            <li>Calculate and print elapsed time in <code>__exit__</code></li>
                                            <li>Test it with the <code>with</code> statement and simulate some work</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-context.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-context" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">import time

class Timer:
    """Context manager for measuring execution time."""
    def __enter__(self):
        self.start = time.time()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.end = time.time()
        elapsed = self.end - self.start
        print(f"Elapsed time: {elapsed:.4f} seconds")
        return False  # Don't suppress exceptions


# Test the Timer context manager
with Timer():
    time.sleep(0.5)  # Simulate some work

with Timer() as timer:
    total = sum(range(1000000))
    print(f"Sum result: {total}")</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Context Managers:</strong> Objects that manage resources with setup
                                                and cleanup code</li>
                                            <li><strong>with Statement:</strong> Ensures proper resource management,
                                                automatically calls <code>__enter__</code> and <code>__exit__</code></li>
                                            <li><strong>__enter__:</strong> Setup method called before the block, return
                                                value assigned to variable after <code>as</code></li>
                                            <li><strong>__exit__:</strong> Cleanup method called after the block, receives
                                                exception info if one occurred</li>
                                            <li><strong>Exception Handling:</strong> <code>__exit__</code> runs even if
                                                exceptions occur; return <code>True</code> to suppress exceptions</li>
                                            <li><strong>@contextmanager:</strong> Decorator from <code>contextlib</code> to
                                                create context managers from generator functions</li>
                                            <li><strong>Multiple Contexts:</strong> Use commas or separate lines in
                                                <code>with</code> statement for multiple resources</li>
                                            <li><strong>Common Uses:</strong> File handling, database connections, locks,
                                                temporary state changes, timing/debugging</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Context managers are essential for proper resource management! Next, we'll explore
                                        <strong>regular expressions</strong> (regex), powerful pattern matching tools that
                                        let you search, extract, and manipulate text with complex patterns. Regex is
                                        invaluable for text processing, validation, and data extraction!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-decorators.jsp" />
                                    <jsp:param name="prevTitle" value="Decorators" />
                                    <jsp:param name="nextLink" value="adv-regex.jsp" />
                                    <jsp:param name="nextTitle" value="Regular Expressions" />
                                    <jsp:param name="currentLessonId" value="adv-context" />
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