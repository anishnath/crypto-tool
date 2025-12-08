<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-generators" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Generators - yield Keyword, Generator Functions & Expressions | 8gwifi.org</title>
            <meta name="description"
                content="Master Python generators and the yield keyword. Learn how to create generator functions and generator expressions for memory-efficient iteration, infinite sequences, and lazy evaluation.">
            <meta name="keywords"
                content="python generator, python yield, python generator expression, generator function, lazy evaluation, python iteration">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Generators - yield Keyword, Generator Functions & Expressions">
            <meta property="og:description"
                content="Master Python generators and the yield keyword. Learn generator functions and expressions for memory-efficient iteration with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-generators.jsp">
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
        "name": "Python Generators",
        "description": "Master Python generators and the yield keyword. Learn generator functions and expressions for memory-efficient iteration.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Generator functions", "yield keyword", "Generator expressions", "Lazy evaluation", "Memory efficiency", "Infinite sequences", "Generator vs list", "Generator iteration"],
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

        <body class="tutorial-body no-preview" data-lesson="adv-generators">
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
                                    <h1 class="lesson-title">Generators</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Generators provide an elegant way to create iterators without the
                                        boilerplate of <code>__iter__</code> and <code>__next__</code> methods. Using the
                                        <code>yield</code> keyword, generator functions automatically implement the iterator
                                        protocol. They're perfect for memory-efficient iteration, infinite sequences, and
                                        lazy evaluation - generating values only when needed!</p>

                                    <h2>Generator Functions and yield</h2>
                                    <p>A generator function looks like a regular function, but uses <code>yield</code>
                                        instead of <code>return</code>. When called, it returns a generator object (an
                                        iterator) without executing the function body immediately. Each call to
                                        <code>next()</code> resumes execution until the next <code>yield</code>, which
                                        produces a value and pauses the function.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-generators-yield.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-yield" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How yield Works:</strong><br>
                                        - When a generator function is called, it returns a generator object without
                                        executing<br>
                                        - Calling <code>next()</code> executes until the first <code>yield</code><br>
                                        - The function pauses at <code>yield</code> and returns the yielded value<br>
                                        - Next call to <code>next()</code> resumes after <code>yield</code> and continues
                                        until the next <code>yield</code> or function ends<br>
                                        - When the function ends or returns, <code>StopIteration</code> is raised
                                        automatically
                                    </div>

                                    <h2>Memory Efficiency: Generators vs Lists</h2>
                                    <p>Generators generate values on-demand, using minimal memory. Compare this to lists
                                        that must store all values in memory at once. For large datasets, generators are
                                        essential!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-generators-memory.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-memory" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use generators when you don't need all values at once or
                                        when dealing with large datasets. You can convert a generator to a list with
                                        <code>list(generator)</code> if you need random access, but this defeats the
                                        memory advantage!
                                    </div>

                                    <h2>Generator Expressions</h2>
                                    <p>Generator expressions are like list comprehensions but create generators instead of
                                        lists. They use parentheses <code>()</code> instead of square brackets
                                        <code>[]</code>. Perfect for simple generator creation!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-generators-expressions.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-expressions" />
                                    </jsp:include>

                                    <h2>Infinite Sequences</h2>
                                    <p>Since generators produce values lazily, they can represent infinite sequences that
                                        would be impossible to store in memory. This is perfect for mathematical sequences
                                        or continuous data streams.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-generators-infinite.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-infinite" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Caution:</strong> Infinite generators can loop forever if not handled
                                        carefully. Always use <code>break</code> conditions or limit the number of values
                                        consumed. Never try to convert an infinite generator to a list - it will consume
                                        all memory!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to reuse a consumed generator</h4>
                                        <pre><code class="language-python"># Wrong - generator is exhausted after first iteration
def numbers():
    yield 1
    yield 2
    yield 3

gen = numbers()
print(list(gen))  # [1, 2, 3]
print(list(gen))  # [] - empty!

# Correct - create a new generator each time
def numbers():
    yield 1
    yield 2
    yield 3

print(list(numbers()))  # [1, 2, 3]
print(list(numbers()))  # [1, 2, 3] - new generator</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Converting infinite generators to lists</h4>
                                        <pre><code class="language-python"># Wrong - will consume all memory and crash!
def infinite_numbers():
    i = 0
    while True:
        yield i
        i += 1

all_numbers = list(infinite_numbers())  # Never completes!

# Correct - use generator directly with limits
def infinite_numbers():
    i = 0
    while True:
        yield i
        i += 1

# Use with itertools.islice or for loop with break
for num in infinite_numbers():
    if num > 10:
        break
    print(num)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing return and yield</h4>
                                        <pre><code class="language-python"># Wrong - return ends the generator immediately
def bad_generator():
    yield 1
    return 2  # Generator stops here, never yields 3
    yield 3

# Correct - use yield for all values, return is optional for cleanup
def good_generator():
    yield 1
    yield 2
    yield 3
    # Optional: return value (accessed via StopIteration.value)</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Fibonacci Generator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a generator function that produces Fibonacci
                                            numbers. The Fibonacci sequence starts with 0, 1, and each subsequent number
                                            is the sum of the previous two.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>fibonacci()</code> generator function</li>
                                            <li>Yield numbers starting from 0, then 1, then continue the sequence</li>
                                            <li>The function should be able to generate numbers indefinitely</li>
                                            <li>Test it by printing the first 10 Fibonacci numbers</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-generators.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-generators" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">def fibonacci():
    """Generator that yields Fibonacci numbers indefinitely."""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b


# Print first 10 Fibonacci numbers
print("First 10 Fibonacci numbers:")
fib = fibonacci()
for i in range(10):
    print(next(fib))

# Or using a for loop with enumerate
print("\nUsing for loop with break:")
for i, num in enumerate(fibonacci()):
    if i >= 10:
        break
    print(f"F({i}) = {num}")</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Generator Functions:</strong> Functions that use <code>yield</code>
                                                instead of <code>return</code>, automatically creating iterators</li>
                                            <li><strong>yield:</strong> Pauses function execution, returns a value, and
                                                resumes on next call</li>
                                            <li><strong>Memory Efficient:</strong> Generators produce values on-demand,
                                                perfect for large datasets</li>
                                            <li><strong>Generator Expressions:</strong> Syntax <code>(expr for item in
                                                    iterable)</code> creates generators like list comprehensions create
                                                lists</li>
                                            <li><strong>Lazy Evaluation:</strong> Values are generated only when needed,
                                                not all at once</li>
                                            <li><strong>Infinite Sequences:</strong> Generators can represent infinite
                                                sequences impossible to store in memory</li>
                                            <li><strong>One-time Use:</strong> Generators are consumed after iteration;
                                                create new ones to iterate again</li>
                                            <li><strong>Under the Hood:</strong> Generators automatically implement
                                                <code>__iter__</code> and <code>__next__</code> methods</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Generators are powerful tools for iteration! Next, we'll explore
                                        <strong>decorators</strong>, which allow you to modify or extend function behavior
                                        without permanently changing the function itself. Decorators are commonly used with
                                        generators for timing, logging, and caching!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-iterators.jsp" />
                                    <jsp:param name="prevTitle" value="Iterators" />
                                    <jsp:param name="nextLink" value="adv-decorators.jsp" />
                                    <jsp:param name="nextTitle" value="Decorators" />
                                    <jsp:param name="currentLessonId" value="adv-generators" />
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