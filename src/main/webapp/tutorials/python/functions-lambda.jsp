<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-lambda");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Lambda Functions - Anonymous Functions, map, filter, sorted | 8gwifi.org</title>
    <meta name="description"
        content="Master Python lambda functions - anonymous functions for concise code. Learn to use lambdas with map(), filter(), sorted(), and when to prefer def instead.">
    <meta name="keywords"
        content="python lambda, python anonymous function, python map lambda, python filter lambda, python sorted lambda, python lambda vs def">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Lambda Functions - Anonymous Functions, map, filter, sorted">
    <meta property="og:description" content="Master Python lambda functions for concise, functional-style programming.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions-lambda.jsp">
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
        "name": "Python Lambda Functions",
        "description": "Master Python lambda functions - anonymous functions for concise code with map, filter, and sorted.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Lambda syntax", "Lambda with sorted()", "Lambda with map()", "Lambda with filter()", "Conditional lambdas", "Lambda vs def"],
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

<body class="tutorial-body no-preview" data-lesson="functions-lambda">
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
                    <span>Lambda Functions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Lambda Functions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Lambda functions are small, anonymous functions defined with a single expression.
                    They're perfect for short operations you need to pass to other functions like
                    <code>sorted()</code>, <code>map()</code>, or <code>filter()</code>. While powerful, lambdas
                    have their place - knowing when to use them (and when not to) is key to writing clean Python!</p>

                    <!-- Section 1: Lambda Basics -->
                    <h2>Lambda Function Basics</h2>
                    <p>The syntax is <code>lambda arguments: expression</code>. A lambda can take any number of
                    arguments but consists of a single expression that's automatically returned. Think of it
                    as a compact way to define simple functions inline.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lambda-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why "Lambda"?</strong> The name comes from lambda calculus, a mathematical notation
                        for defining functions. In Python, <code>lambda x: x + 1</code> is equivalent to the
                        mathematical notation λx.x+1. Don't worry about the theory - just think of lambdas as
                        "inline functions."
                    </div>

                    <!-- Section 2: Lambda with Built-ins -->
                    <h2>Lambda with Built-in Functions</h2>
                    <p>Lambdas truly shine when used with Python's built-in functions that accept function
                    arguments: <code>sorted()</code> for custom sorting, <code>map()</code> for transforming
                    data, and <code>filter()</code> for selecting elements.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lambda-with-builtins.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-builtins" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>The key Parameter:</strong> Functions like <code>sorted()</code>, <code>max()</code>,
                        and <code>min()</code> accept a <code>key</code> parameter - a function that extracts the
                        value to compare. Lambdas are perfect here: <code>sorted(items, key=lambda x: x["price"])</code>
                        sorts by the "price" field.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Advanced Patterns -->
                    <h2>Advanced Lambda Patterns</h2>
                    <p>Lambdas can include conditional expressions, be returned from functions to create
                    specialized functions, and work with <code>reduce()</code> for aggregation. These
                    patterns unlock functional programming techniques in Python.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lambda-advanced.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-advanced" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Lambda Limitations:</strong> Lambdas can only contain a single expression - no
                        statements, no multiple lines, no assignments. If you need any of these, use a regular
                        <code>def</code> function. Lambdas also can't have docstrings, making them harder to
                        document.
                    </div>

                    <!-- Section 4: Lambda vs def -->
                    <h2>Lambda vs def: When to Use Which</h2>
                    <p>While lambdas are convenient, they're not always the best choice. Understanding when to
                    use <code>lambda</code> versus <code>def</code> is crucial for writing readable, maintainable
                    code. Often, list comprehensions are clearer than <code>map</code>/<code>filter</code> with lambdas.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lambda-vs-def.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-vs-def" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Assigning lambdas to variables (use def instead)</h4>
                        <pre><code class="language-python"># Not recommended (PEP 8)
square = lambda x: x ** 2

# Better - use def for named functions
def square(x):
    return x ** 2

# Lambdas are best used inline
sorted(items, key=lambda x: x.value)  # Good!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Complex logic in lambdas</h4>
                        <pre><code class="language-python"># Bad - too complex, hard to read
process = lambda x: x.strip().lower().replace(' ', '_') if x else 'default'

# Better - use a named function
def process(x):
    if not x:
        return 'default'
    return x.strip().lower().replace(' ', '_')</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting that lambda captures variables by reference</h4>
                        <pre><code class="language-python"># Problem: all functions use the LAST value of i
funcs = []
for i in range(3):
    funcs.append(lambda: i)

print([f() for f in funcs])  # [2, 2, 2] - not [0, 1, 2]!

# Fix: capture i as default argument
funcs = []
for i in range(3):
    funcs.append(lambda i=i: i)  # i=i captures current value

print([f() for f in funcs])  # [0, 1, 2] - correct!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using map/filter with lambda when comprehension is clearer</h4>
                        <pre><code class="language-python"># Overly functional style
result = list(map(lambda x: x*2, filter(lambda x: x > 0, numbers)))

# More Pythonic - use comprehension
result = [x * 2 for x in numbers if x > 0]

# Even clearer for complex operations
result = [
    transform(x)
    for x in numbers
    if is_valid(x)
]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Trying to use statements in lambda</h4>
                        <pre><code class="language-python"># Wrong - print is a statement effect, not useful here
# And assignments aren't allowed
process = lambda x: print(x)  # Works but returns None
process = lambda x: x = x + 1  # SyntaxError!

# Lambda can only have expressions
process = lambda x: x + 1  # Expression returns value</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Sort and Transform</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use lambda functions to sort and transform data.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Sort a list of products by price (ascending)</li>
                            <li>Use <code>map()</code> to apply a 10% discount to all prices</li>
                            <li>Use <code>filter()</code> to get products under $50</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-lambda.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-lambda" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">products = [
    {"name": "Laptop", "price": 999},
    {"name": "Mouse", "price": 25},
    {"name": "Keyboard", "price": 75},
    {"name": "Monitor", "price": 300}
]

# Sort by price
sorted_products = sorted(products, key=lambda p: p["price"])
print("Sorted by price:")
for p in sorted_products:
    print(f"  {p['name']}: \${p['price']}")

# Apply 10% discount
discounted = list(map(lambda p: {**p, "price": p["price"] * 0.9}, products))
print("\nWith 10% discount:")
for p in discounted:
    print(f"  {p['name']}: \${p['price']:.2f}")

# Filter under $50
cheap = list(filter(lambda p: p["price"] < 50, products))
print(f"\nUnder $50: {[p['name'] for p in cheap]}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax:</strong> <code>lambda arguments: expression</code></li>
                            <li><strong>Best use:</strong> Short operations passed to <code>sorted()</code>, <code>map()</code>, <code>filter()</code></li>
                            <li><strong>With key:</strong> <code>sorted(items, key=lambda x: x.value)</code></li>
                            <li><strong>With map:</strong> <code>map(lambda x: x*2, items)</code></li>
                            <li><strong>With filter:</strong> <code>filter(lambda x: x > 0, items)</code></li>
                            <li><strong>Conditional:</strong> <code>lambda x: "yes" if x else "no"</code></li>
                            <li><strong>Limitation:</strong> Single expression only, no statements</li>
                            <li><strong>When to use def:</strong> Named functions, complex logic, need docstrings</li>
                            <li><strong>Often prefer:</strong> List comprehensions over map/filter with lambda</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Recursion</strong> - functions that call themselves! This
                    powerful technique is perfect for problems that have a natural recursive structure, like
                    traversing trees, calculating factorials, or solving puzzles.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions-scope.jsp" />
                    <jsp:param name="prevTitle" value="Variable Scope" />
                    <jsp:param name="nextLink" value="functions-recursion.jsp" />
                    <jsp:param name="nextTitle" value="Recursion" />
                    <jsp:param name="currentLessonId" value="functions-lambda" />
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
