<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Functions - Define, Call, and Document Functions | 8gwifi.org</title>
    <meta name="description"
        content="Learn to define Python functions with def keyword. Master function calling, parameters, docstrings, and best practices for reusable code.">
    <meta name="keywords"
        content="python functions, python def, python function tutorial, python docstring, python function parameters, python reusable code">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Functions - Define, Call, and Document Functions">
    <meta property="og:description" content="Master Python functions: definition, calling, parameters, and docstrings.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions.jsp">
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
        "name": "Python Functions",
        "description": "Learn to define Python functions with def keyword. Master function calling, parameters, docstrings, and best practices.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Function definition with def", "Calling functions", "Function parameters", "Docstrings and documentation", "Function naming conventions"],
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

<body class="tutorial-body no-preview" data-lesson="functions">
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
                    <span>Functions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Defining Functions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Functions are the building blocks of reusable code. They let you define a block of
                    code once and use it anywhere in your program by simply calling its name. Functions make your
                    code more organized, readable, and maintainable - they're essential for writing professional
                    Python code!</p>

                    <!-- Section 1: Defining Functions -->
                    <h2>Defining Functions</h2>
                    <p>In Python, you define a function using the <code>def</code> keyword, followed by the function
                    name, parentheses for parameters, and a colon. The function body is indented below. Good
                    function names use <code>snake_case</code> and start with a verb describing what the function does.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/functions-defining.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-defining" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Function vs Method:</strong> A function is a standalone block of code defined with
                        <code>def</code>. A method is a function that belongs to an object and is called with dot
                        notation like <code>list.append()</code>. Under the hood, methods are just functions that
                        receive the object as their first argument (<code>self</code>).
                    </div>

                    <!-- Section 2: Calling Functions -->
                    <h2>Calling Functions</h2>
                    <p>To execute a function, you call it by writing its name followed by parentheses. The
                    parentheses are crucial - without them, you're referring to the function object itself,
                    not executing it. You can pass arguments, store return values, and chain function calls.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/functions-calling.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-calling" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Positional vs Keyword Arguments:</strong> When calling a function, positional
                        arguments must come before keyword arguments. <code>func(1, 2, c=3)</code> is valid,
                        but <code>func(a=1, 2, 3)</code> is a syntax error. Keyword arguments make calls more
                        readable and allow you to skip optional parameters.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Docstrings -->
                    <h2>Docstrings: Documenting Functions</h2>
                    <p>A docstring is a string literal that appears as the first statement in a function.
                    It documents what the function does, its parameters, and return value. Python's built-in
                    <code>help()</code> function and IDEs use docstrings to provide documentation.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/functions-docstrings.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-docstrings" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Comments vs Docstrings:</strong> Regular comments (<code>#</code>) are for
                        implementation notes and are not accessible at runtime. Docstrings (<code>"""..."""</code>)
                        are stored in the function's <code>__doc__</code> attribute and can be accessed
                        programmatically. Always use docstrings for function documentation, not comments.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Function Examples</h2>
                    <p>Let's look at some real-world function examples - utility functions for temperature
                    conversion, string processing, validation, and working with lists. These patterns will
                    appear constantly in your Python programs.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/functions-examples.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-examples" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting parentheses when calling</h4>
                        <pre><code class="language-python"># Wrong - this is the function object, not a call
result = my_function  # No execution!
print(result)  # Prints: <function my_function at 0x...>

# Correct - use parentheses to call
result = my_function()
print(result)  # Prints the actual return value</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Missing colon after function definition</h4>
                        <pre><code class="language-python"># Wrong - missing colon
def greet(name)  # SyntaxError!
    print(f"Hello, {name}")

# Correct - include the colon
def greet(name):
    print(f"Hello, {name}")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Incorrect indentation in function body</h4>
                        <pre><code class="language-python"># Wrong - inconsistent indentation
def calculate(a, b):
    result = a + b
  extra = result * 2  # IndentationError!
    return extra

# Correct - consistent indentation
def calculate(a, b):
    result = a + b
    extra = result * 2
    return extra</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Calling function before definition</h4>
                        <pre><code class="language-python"># Wrong - function called before it's defined
result = add(3, 5)  # NameError: name 'add' is not defined

def add(a, b):
    return a + b

# Correct - define first, then call
def add(a, b):
    return a + b

result = add(3, 5)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Using wrong number of arguments</h4>
                        <pre><code class="language-python">def greet(first_name, last_name):
    print(f"Hello, {first_name} {last_name}")

# Wrong - too few arguments
greet("Alice")  # TypeError: missing 1 required positional argument

# Wrong - too many arguments
greet("Alice", "Smith", "Ms.")  # TypeError: takes 2 positional arguments but 3 were given

# Correct - exact number of arguments
greet("Alice", "Smith")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Calculator Functions</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create basic calculator functions.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Define <code>add(a, b)</code> - returns sum</li>
                            <li>Define <code>subtract(a, b)</code> - returns difference</li>
                            <li>Define <code>multiply(a, b)</code> - returns product</li>
                            <li>Each function should have a docstring</li>
                            <li>Test each function with sample values</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-functions" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def add(a, b):
    """Return the sum of a and b."""
    return a + b

def subtract(a, b):
    """Return a minus b."""
    return a - b

def multiply(a, b):
    """Return the product of a and b."""
    return a * b

# Test the functions
print(f"5 + 3 = {add(5, 3)}")
print(f"10 - 4 = {subtract(10, 4)}")
print(f"6 * 7 = {multiply(6, 7)}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Define:</strong> <code>def function_name(parameters):</code></li>
                            <li><strong>Call:</strong> <code>function_name(arguments)</code></li>
                            <li><strong>Naming:</strong> Use <code>snake_case</code> with descriptive verbs</li>
                            <li><strong>Docstrings:</strong> First line in function body: <code>"""Description."""</code></li>
                            <li><strong>Parameters:</strong> Variables in definition; arguments are values passed when calling</li>
                            <li><strong>Execution order:</strong> Define before calling; Python reads top-to-bottom</li>
                            <li><strong>Parentheses:</strong> Always use <code>()</code> to call; without them you get the function object</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can define and call functions, let's dive deeper into <strong>Function
                    Arguments</strong> - you'll learn about default values, keyword arguments, and how to
                    create flexible functions that accept any number of arguments with <code>*args</code>
                    and <code>**kwargs</code>!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="nested-structures.jsp" />
                    <jsp:param name="prevTitle" value="Nested Structures" />
                    <jsp:param name="nextLink" value="functions-arguments.jsp" />
                    <jsp:param name="nextTitle" value="Function Arguments" />
                    <jsp:param name="currentLessonId" value="functions" />
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
