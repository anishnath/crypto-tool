<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-scope");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Variable Scope - Local, Global, LEGB Rule, nonlocal | 8gwifi.org</title>
    <meta name="description"
        content="Master Python variable scope - local vs global variables, the LEGB lookup rule, global keyword, and nonlocal for closures. Avoid common scope-related bugs.">
    <meta name="keywords"
        content="python scope, python global variable, python local variable, python global keyword, python nonlocal, python LEGB rule, python closures">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Variable Scope - Local, Global, LEGB Rule, nonlocal">
    <meta property="og:description" content="Master Python variable scope: local, global, LEGB rule, and nonlocal keyword.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions-scope.jsp">
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
        "name": "Python Variable Scope",
        "description": "Master Python variable scope - local vs global variables, the LEGB lookup rule, global keyword, and nonlocal for closures.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Local scope", "Global scope", "The LEGB rule", "global keyword", "nonlocal keyword", "Closures"],
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

<body class="tutorial-body no-preview" data-lesson="functions-scope">
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
                    <span>Variable Scope</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Variable Scope</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Understanding scope is essential for writing bug-free Python code. Scope determines
                    where variables can be accessed and modified. Python follows the LEGB rule - Local, Enclosing,
                    Global, Built-in - to look up variable names. Master scope and you'll avoid one of the most
                    common sources of confusion in programming!</p>

                    <!-- Section 1: Local Scope -->
                    <h2>Local Scope</h2>
                    <p>Variables created inside a function are <em>local</em> to that function. They're created when
                    the function is called and destroyed when it returns. Local variables cannot be accessed from
                    outside the function, and each function call gets fresh local variables.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/scope-local.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-local" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why Local Scope Exists:</strong> Local scope protects you from accidentally
                        modifying variables elsewhere in your program. When a function has its own private
                        variables, you can understand and test it in isolation. This is a key principle of
                        good software design called <em>encapsulation</em>.
                    </div>

                    <!-- Section 2: Global Scope -->
                    <h2>Global Scope and the global Keyword</h2>
                    <p>Variables defined at the module level (outside any function) are <em>global</em>. Functions
                    can read global variables freely, but to modify them, you must use the <code>global</code>
                    keyword. However, overusing global variables is generally considered bad practice.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/scope-global.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-global" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Avoid Global Variables:</strong> Global state makes code harder to understand,
                        test, and debug. Functions that modify globals have "hidden" dependencies. Instead,
                        pass values as arguments and return results. Use globals only for true constants
                        (like <code>PI = 3.14159</code>) or configuration that genuinely needs to be module-wide.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: LEGB Rule -->
                    <h2>The LEGB Rule</h2>
                    <p>When Python encounters a variable name, it searches for it in a specific order: Local,
                    Enclosing, Global, Built-in. This is the LEGB rule. Understanding it helps you predict
                    which variable Python will find when names overlap.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/scope-legb.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-legb" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>LEGB Memory Aid:</strong> <strong>L</strong>ocal (inside current function) →
                        <strong>E</strong>nclosing (outer function if nested) → <strong>G</strong>lobal (module
                        level) → <strong>B</strong>uilt-in (Python's built-in names like <code>len</code>,
                        <code>print</code>). Python stops at the first match it finds.
                    </div>

                    <!-- Section 4: nonlocal -->
                    <h2>The nonlocal Keyword</h2>
                    <p>When you have nested functions and need to modify a variable from an enclosing (but not
                    global) scope, use <code>nonlocal</code>. This is especially useful for creating closures -
                    functions that "remember" state from their enclosing scope.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/scope-nonlocal.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-nonlocal" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. UnboundLocalError when modifying globals</h4>
                        <pre><code class="language-python">count = 0

def increment():
    count += 1  # UnboundLocalError!
    # Python sees assignment, creates local 'count'
    # But tries to read count before it's assigned

# Fix: use global keyword
def increment():
    global count
    count += 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Shadowing built-in names</h4>
                        <pre><code class="language-python"># Bad - shadows built-in list()
list = [1, 2, 3]
# Later...
new_list = list("hello")  # TypeError: 'list' object is not callable

# Fix: use different variable names
items = [1, 2, 3]
new_list = list("hello")  # Works: ['h', 'e', 'l', 'l', 'o']</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Thinking assignment creates reference to global</h4>
                        <pre><code class="language-python">data = [1, 2, 3]

def modify():
    data = [4, 5, 6]  # Creates LOCAL data!
    # Global data is unchanged

modify()
print(data)  # [1, 2, 3] - surprised?

# If you want to modify the global:
def modify():
    global data
    data = [4, 5, 6]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using global when nonlocal is needed</h4>
                        <pre><code class="language-python">def outer():
    x = 10

    def inner():
        global x  # Wrong! Looks for module-level x
        x += 1

    inner()
    print(x)  # Still 10 - inner modified a different x

# Fix: use nonlocal for enclosing scope
def outer():
    x = 10

    def inner():
        nonlocal x  # Correct!
        x += 1

    inner()
    print(x)  # 11</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Mutable globals can be modified without 'global'</h4>
                        <pre><code class="language-python"># Surprising: this works without 'global'
items = []

def add_item(item):
    items.append(item)  # Modifying, not reassigning!

add_item("apple")
print(items)  # ['apple']

# But this needs 'global':
def reset_items():
    global items
    items = []  # Reassignment needs global</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Counter Factory</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that returns a counter function using closures.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create <code>make_counter(start=0)</code></li>
                            <li>Returns a function that increments and returns the count</li>
                            <li>Use <code>nonlocal</code> to maintain state</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-scope.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-scope" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def make_counter(start=0):
    """Create a counter function starting at 'start'."""
    count = start

    def counter():
        nonlocal count
        count += 1
        return count

    return counter

# Test it
counter1 = make_counter()
counter2 = make_counter(100)

print(f"Counter 1: {counter1()}, {counter1()}, {counter1()}")
print(f"Counter 2: {counter2()}, {counter2()}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Local:</strong> Variables inside functions - created on call, destroyed on return</li>
                            <li><strong>Global:</strong> Variables at module level - use <code>global</code> keyword to modify</li>
                            <li><strong>LEGB:</strong> Lookup order: Local → Enclosing → Global → Built-in</li>
                            <li><strong>nonlocal:</strong> Modify enclosing (not global) scope in nested functions</li>
                            <li><strong>Shadowing:</strong> Local variables can shadow global/built-in names</li>
                            <li><strong>Best practice:</strong> Avoid global state; prefer passing values and returning results</li>
                            <li><strong>Closures:</strong> Functions that capture and remember enclosing scope</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand scope, let's learn about <strong>Lambda Functions</strong> -
                    small, anonymous functions perfect for short operations. Lambdas are widely used with
                    functions like <code>map()</code>, <code>filter()</code>, and <code>sorted()</code>!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions-return.jsp" />
                    <jsp:param name="prevTitle" value="Return Values" />
                    <jsp:param name="nextLink" value="functions-lambda.jsp" />
                    <jsp:param name="nextTitle" value="Lambda Functions" />
                    <jsp:param name="currentLessonId" value="functions-scope" />
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
