<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "errors-finally");
   request.setAttribute("currentModule", "Error Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Finally & Else - Guaranteed Cleanup, Success Blocks, Resource Management | 8gwifi.org</title>
    <meta name="description"
        content="Master Python finally and else clauses. Learn guaranteed cleanup with finally, success-only code with else, proper resource management, and avoiding common pitfalls.">
    <meta name="keywords"
        content="python finally, python else block, python try finally, python cleanup, python resource management, python exception handling">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Finally & Else - Guaranteed Cleanup, Success Blocks, Resource Management">
    <meta property="og:description" content="Master Python finally for guaranteed cleanup and else for success-only code. Learn proper resource management patterns.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/errors-finally.jsp">
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
        "name": "Python Finally & Else",
        "description": "Master Python finally and else clauses. Learn guaranteed cleanup with finally, success-only code with else, and proper resource management patterns.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Finally clause basics", "Guaranteed cleanup", "Finally with return", "Else clause", "Success-only code", "Resource management", "Context managers", "File handling cleanup"],
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

<body class="tutorial-body no-preview" data-lesson="errors-finally">
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
                    <span>Finally & Else</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Finally & Else</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>finally</code> clause guarantees code runs no matter what - whether an
                    exception occurs, the code returns early, or breaks from a loop. The <code>else</code> clause
                    runs only when no exception occurred. Together, they complete Python's exception handling toolkit,
                    enabling robust resource management and clean code separation!</p>

                    <!-- Section 1: Finally Basics -->
                    <h2>Finally Block Basics</h2>
                    <p>The <code>finally</code> block always executes - when an exception occurs, when no exception
                    occurs, even when the code uses <code>return</code>, <code>break</code>, or <code>continue</code>.
                    This makes it perfect for cleanup code that must run no matter what happens.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/finally-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>When Finally Runs:</strong><br>
                        - After <code>try</code> completes normally<br>
                        - After <code>except</code> handles an exception<br>
                        - Before <code>return</code> completes<br>
                        - Before <code>break</code> or <code>continue</code> in loops<br>
                        - Before an exception propagates up<br><br>
                        <strong>Key insight:</strong> Finally runs BEFORE control leaves the try/except block!
                    </div>

                    <!-- Section 2: Finally with Return -->
                    <h2>Finally with Return Statements</h2>
                    <p>When a function returns inside a try block, finally still runs - but there's a catch.
                    If finally also has a return statement, it <em>overrides</em> the try's return! This is
                    usually a bug, so avoid return statements in finally blocks.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/finally-return.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-return" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Avoid These in Finally!</strong><br>
                        - <code>return</code> - Overrides the try block's return value<br>
                        - <code>raise</code> - Replaces the original exception<br>
                        - <code>break/continue</code> - Overrides loop control<br><br>
                        Finally should ONLY contain cleanup code - closing files, releasing locks, etc.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: The Else Clause -->
                    <h2>The Else Clause</h2>
                    <p>The <code>else</code> clause runs only when no exception occurred in the try block. This
                    lets you separate "code that might fail" from "code to run on success". It keeps your try
                    block minimal and makes the code's intent clearer.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/finally-else.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-else" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Execution Order:</strong><br>
                        1. <code>try</code> - Runs first<br>
                        2. <code>except</code> - Only if exception occurred<br>
                        3. <code>else</code> - Only if NO exception occurred<br>
                        4. <code>finally</code> - Always runs last<br><br>
                        <strong>Why use else?</strong> Keep try blocks minimal - only wrap code that might fail!
                    </div>

                    <!-- Section 4: Resource Management -->
                    <h2>Resource Management Patterns</h2>
                    <p>The most common use of finally is resource cleanup - closing files, disconnecting from
                    databases, releasing locks. But Python's <code>with</code> statement (context managers)
                    is usually cleaner. Still, understanding the finally pattern helps when with isn't available.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/finally-resources.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-resources" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Prefer Context Managers:</strong><br>
                        <code>with open(file) as f:</code> - File automatically closed<br>
                        <code>with lock:</code> - Lock automatically released<br>
                        <code>with connection:</code> - Connection automatically closed<br><br>
                        Use try/finally only when context managers aren't available or appropriate.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Returning in finally</h4>
                        <pre><code class="language-python"># Wrong - return in finally overrides try's return!
def get_data():
    try:
        return fetch_from_server()
    finally:
        return None  # This ALWAYS returns None!

# Correct - only cleanup in finally
def get_data():
    connection = None
    try:
        connection = connect()
        return connection.fetch()
    finally:
        if connection:
            connection.close()  # Just cleanup, no return</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Raising in finally (suppresses original)</h4>
                        <pre><code class="language-python"># Wrong - new exception replaces original!
def process():
    try:
        raise ValueError("Original error")
    finally:
        raise RuntimeError("Cleanup failed")  # Original lost!

# Correct - log cleanup errors, don't raise
def process():
    try:
        raise ValueError("Original error")
    finally:
        try:
            cleanup()
        except Exception as e:
            logging.error(f"Cleanup failed: {e}")
            # Don't raise - let original propagate</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing else with finally</h4>
                        <pre><code class="language-python"># Wrong - using else for cleanup
try:
    data = load_data()
except FileNotFoundError:
    data = default_data()
else:
    file.close()  # Wrong place! What if exception occurred?

# Correct - else for success-only code, finally for cleanup
try:
    data = load_data()
except FileNotFoundError:
    data = default_data()
else:
    process(data)  # Only runs on success
finally:
    file.close()  # Always runs</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Too much code in try block</h4>
                        <pre><code class="language-python"># Wrong - everything in try
try:
    f = open(filename)
    data = f.read()
    parsed = json.loads(data)
    result = process(parsed)
    save(result)
except Exception:
    print("Something failed")  # Which part?

# Correct - minimal try, use else for success path
try:
    f = open(filename)
except FileNotFoundError:
    print("File not found")
    f = None
else:
    try:
        data = f.read()
        parsed = json.loads(data)
    except json.JSONDecodeError:
        print("Invalid JSON")
    else:
        result = process(parsed)
        save(result)
finally:
    if f:
        f.close()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not using context managers when available</h4>
                        <pre><code class="language-python"># Verbose - manual try/finally
f = None
try:
    f = open(filename)
    data = f.read()
finally:
    if f:
        f.close()

# Better - context manager handles cleanup
with open(filename) as f:
    data = f.read()
# Automatically closed, even if exception occurs!

# For multiple resources
with open('in.txt') as infile, open('out.txt', 'w') as outfile:
    outfile.write(infile.read())</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Safe Database Query</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that safely queries a database with proper cleanup.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Connect to the database in try block</li>
                            <li>Use else for processing the results</li>
                            <li>Always disconnect in finally, even if errors occur</li>
                            <li>Return the results or an error message</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-errors-finally.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-finally" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class Database:
    """Simulated database for exercise."""
    def __init__(self, name):
        self.name = name
        self.connected = False

    def connect(self):
        self.connected = True
        print(f"Connected to {self.name}")

    def disconnect(self):
        if self.connected:
            self.connected = False
            print(f"Disconnected from {self.name}")

    def query(self, sql):
        if not self.connected:
            raise RuntimeError("Not connected!")
        if "error" in sql.lower():
            raise ValueError("Query syntax error")
        return [{"id": 1}, {"id": 2}]


def safe_query(db, sql):
    """
    Safely query database with proper cleanup.
    Returns (success, result_or_error).
    """
    try:
        db.connect()
    except Exception as e:
        return (False, f"Connection failed: {e}")
    else:
        # Only runs if connect succeeded
        try:
            results = db.query(sql)
            return (True, results)
        except ValueError as e:
            return (False, f"Query failed: {e}")
    finally:
        # Always disconnect
        db.disconnect()


# Test the function
db = Database("production")

print("=== Test 1: Successful query ===")
success, result = safe_query(db, "SELECT * FROM users")
print(f"Success: {success}, Result: {result}\n")

print("=== Test 2: Failed query ===")
success, result = safe_query(db, "SELECT error FROM bad")
print(f"Success: {success}, Result: {result}\n")

print("=== Verify cleanup ===")
print(f"Database connected: {db.connected}")  # Should be False</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>finally:</strong> Always runs - perfect for cleanup code</li>
                            <li><strong>else:</strong> Runs only when no exception occurred</li>
                            <li><strong>Order:</strong> try → except (if error) OR else (if no error) → finally</li>
                            <li><strong>finally with return:</strong> Runs before return, but avoid returning in finally</li>
                            <li><strong>Don't in finally:</strong> return, raise, break, continue</li>
                            <li><strong>Use else to:</strong> Keep try blocks minimal, separate success code</li>
                            <li><strong>Resource management:</strong> Finally ensures cleanup happens</li>
                            <li><strong>Prefer context managers:</strong> <code>with</code> is cleaner than try/finally</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now you know how to catch and clean up after exceptions. But what if you need to
                    <em>signal</em> an error yourself? Next, we'll learn about <code>raise</code> to create
                    and throw your own exceptions, and how to create custom exception classes for your
                    specific error conditions!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="errors-try-except.jsp" />
                    <jsp:param name="prevTitle" value="Try/Except" />
                    <jsp:param name="nextLink" value="errors-raise.jsp" />
                    <jsp:param name="nextTitle" value="Raising Exceptions" />
                    <jsp:param name="currentLessonId" value="errors-finally" />
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
