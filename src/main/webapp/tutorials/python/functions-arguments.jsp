<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-arguments");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Function Arguments - *args, **kwargs, Default Values | 8gwifi.org</title>
    <meta name="description"
        content="Master Python function arguments - positional, keyword, default values, *args for variable arguments, **kwargs for keyword arguments. Learn flexible function design.">
    <meta name="keywords"
        content="python function arguments, python kwargs, python args, python default arguments, python positional arguments, python keyword arguments">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Function Arguments - *args, **kwargs, Default Values">
    <meta property="og:description" content="Master Python function arguments: positional, keyword, defaults, *args, and **kwargs.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions-arguments.jsp">
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
        "name": "Python Function Arguments",
        "description": "Master Python function arguments - positional, keyword, default values, *args, and **kwargs for flexible function design.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Positional arguments", "Keyword arguments", "Default parameter values", "*args for variable positional arguments", "**kwargs for variable keyword arguments", "Argument unpacking"],
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

<body class="tutorial-body no-preview" data-lesson="functions-arguments">
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
                    <span>Function Arguments</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Function Arguments</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python offers incredible flexibility in how you pass data to functions.
                    From simple positional arguments to powerful <code>*args</code> and <code>**kwargs</code>,
                    understanding argument types lets you design functions that are both easy to use and
                    incredibly versatile. Master these patterns and you'll write more Pythonic, flexible code!</p>

                    <!-- Section 1: Positional and Keyword Arguments -->
                    <h2>Positional vs Keyword Arguments</h2>
                    <p>When calling a function, you can pass arguments by position (where order matters) or
                    by keyword (where you explicitly name the parameter). Keyword arguments make your code
                    more readable and let you skip optional parameters.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/args-positional-keyword.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-pos-kw" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Parameters vs Arguments:</strong> A <em>parameter</em> is the variable in the
                        function definition (<code>def greet(name)</code>). An <em>argument</em> is the value
                        you pass when calling the function (<code>greet("Alice")</code>). Parameters define
                        what a function expects; arguments are what you provide.
                    </div>

                    <!-- Section 2: Default Values -->
                    <h2>Default Parameter Values</h2>
                    <p>Default values make parameters optional. If the caller doesn't provide an argument,
                    the default is used. This pattern is essential for creating user-friendly APIs with
                    sensible defaults that can be overridden when needed.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/args-default.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-default" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Mutable Default Values Trap!</strong> Never use mutable objects (lists, dicts)
                        as default values. They're created once when the function is defined, not each call.
                        Use <code>None</code> instead: <code>def func(items=None): if items is None: items = []</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: *args and **kwargs -->
                    <h2>Arbitrary Arguments: *args and **kwargs</h2>
                    <p>Sometimes you don't know in advance how many arguments a function will receive.
                    <code>*args</code> collects extra positional arguments into a tuple, while
                    <code>**kwargs</code> collects extra keyword arguments into a dictionary. These make
                    your functions incredibly flexible.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/args-arbitrary.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-arbitrary" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Parameter Order Rule:</strong> When combining parameter types, they must appear
                        in this order: (1) regular positional, (2) <code>*args</code>, (3) keyword-only,
                        (4) <code>**kwargs</code>. Example: <code>def func(a, b, *args, option=True, **kwargs)</code>
                    </div>

                    <!-- Section 4: Practical Patterns -->
                    <h2>Practical Argument Patterns</h2>
                    <p>Let's look at real-world patterns using these argument types - building flexible APIs,
                    configuration functions, and wrapper functions that pass arguments through.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/args-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Keyword arguments before positional</h4>
                        <pre><code class="language-python"># Wrong - keyword args must come after positional
greet(name="Alice", "Smith")  # SyntaxError!

# Correct - positional first, then keyword
greet("Alice", last_name="Smith")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using mutable default values</h4>
                        <pre><code class="language-python"># Wrong - list is shared across calls!
def add_item(item, items=[]):
    items.append(item)
    return items

add_item("a")  # ['a']
add_item("b")  # ['a', 'b'] - unexpected!

# Correct - use None and create new list
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Putting default parameters before required ones</h4>
                        <pre><code class="language-python"># Wrong - default before non-default
def greet(greeting="Hello", name):  # SyntaxError!
    print(f"{greeting}, {name}")

# Correct - required parameters first
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Confusing *args unpacking</h4>
                        <pre><code class="language-python">def show_args(*args):
    print(args)

# Wrong - passing a list creates tuple with one element
my_list = [1, 2, 3]
show_args(my_list)  # ([1, 2, 3],) - tuple containing the list

# Correct - unpack the list with *
show_args(*my_list)  # (1, 2, 3) - each element is separate</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Forgetting that **kwargs is a dict copy</h4>
                        <pre><code class="language-python">def modify_kwargs(**kwargs):
    kwargs['new_key'] = 'new_value'
    return kwargs

original = {'a': 1, 'b': 2}
result = modify_kwargs(**original)
print(result)   # {'a': 1, 'b': 2, 'new_key': 'new_value'}
print(original) # {'a': 1, 'b': 2} - original unchanged!

# **kwargs creates a new dict from the passed keyword arguments</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Flexible Print Function</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a flexible logging function.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Accept a message (required)</li>
                            <li>Accept a level with default "INFO"</li>
                            <li>Accept any additional context via <code>**kwargs</code></li>
                            <li>Print formatted output like: <code>[INFO] Message | key=value</code></li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-arguments.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-args" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def log(message, level="INFO", **context):
    """Log a message with optional context."""
    output = f"[{level}] {message}"
    if context:
        extras = " | ".join(f"{k}={v}" for k, v in context.items())
        output += f" | {extras}"
    print(output)

# Test it
log("User logged in")
log("Payment failed", level="ERROR")
log("Order placed", user="alice", order_id=12345, amount=99.99)</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Positional:</strong> <code>func(a, b)</code> - order matters</li>
                            <li><strong>Keyword:</strong> <code>func(a=1, b=2)</code> - explicit names, order flexible</li>
                            <li><strong>Default values:</strong> <code>def func(a, b=10)</code> - optional parameters</li>
                            <li><strong>*args:</strong> <code>def func(*args)</code> - tuple of extra positional args</li>
                            <li><strong>**kwargs:</strong> <code>def func(**kwargs)</code> - dict of extra keyword args</li>
                            <li><strong>Unpacking:</strong> <code>func(*list)</code> or <code>func(**dict)</code></li>
                            <li><strong>Order:</strong> positional, *args, keyword-only, **kwargs</li>
                            <li><strong>Never:</strong> Use mutable objects (list, dict) as defaults</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you know how to pass data into functions, let's learn about <strong>Return
                    Values</strong> - how functions send data back to the caller, returning multiple values,
                    and the difference between <code>return</code> and <code>print</code>!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions.jsp" />
                    <jsp:param name="prevTitle" value="Defining Functions" />
                    <jsp:param name="nextLink" value="functions-return.jsp" />
                    <jsp:param name="nextTitle" value="Return Values" />
                    <jsp:param name="currentLessonId" value="functions-arguments" />
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
