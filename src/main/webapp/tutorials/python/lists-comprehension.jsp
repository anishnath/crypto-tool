<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "lists-comprehension");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python List Comprehensions - Elegant One-Liner Syntax | 8gwifi.org</title>
    <meta name="description"
        content="Master Python list comprehensions - the elegant way to create and transform lists in one line. Learn filtering, nested comprehensions, and if-else conditions.">
    <meta name="keywords"
        content="python list comprehension, python list comprehension if else, python filter list, python one liner list, python nested list comprehension">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python List Comprehensions - Elegant One-Liner Syntax">
    <meta property="og:description" content="Master Python list comprehensions for concise, readable list creation and transformation.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/lists-comprehension.jsp">
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
        "name": "Python List Comprehensions",
        "description": "Master Python list comprehensions for elegant, one-liner list creation and transformation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Basic comprehension syntax", "Filtering with conditions", "If-else in comprehensions", "Nested comprehensions", "Performance benefits"],
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

<body class="tutorial-body no-preview" data-lesson="lists-comprehension">
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
                    <span>List Comprehensions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">List Comprehensions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">List comprehensions are one of Python's most beloved features - they let you
                    create new lists by transforming and filtering existing iterables in a single, elegant line of code.
                    Once you learn them, you'll wonder how you ever lived without them!</p>

                    <!-- Section 1: Basic Syntax -->
                    <h2>Basic List Comprehension</h2>
                    <p>The basic syntax is <code>[expression for item in iterable]</code>. It's equivalent to a
                    for loop that appends to a list, but more concise and often faster.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/listcomp-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why Use List Comprehensions?</strong> They're not just shorter - they're often
                        faster than equivalent for loops because Python optimizes them internally. They're also
                        considered more "Pythonic" - the preferred Python style for creating lists.
                    </div>

                    <!-- Section 2: Filtering -->
                    <h2>Filtering with Conditions</h2>
                    <p>Add an <code>if</code> clause at the end to filter items: <code>[expr for item in iterable if condition]</code>.
                    Only items that satisfy the condition are included in the result.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/listcomp-filter.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-filter" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The filtering <code>if</code> goes at the END of the comprehension
                        (after <code>for</code>). This filters which items to include. Don't confuse it with the
                        if-else ternary expression, which goes at the BEGINNING and transforms values.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: If-Else -->
                    <h2>If-Else Transformation</h2>
                    <p>Use the ternary expression <code>true_expr if condition else false_expr</code> as your
                    expression to transform items differently based on a condition. This goes BEFORE the <code>for</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/listcomp-ternary.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-ternary" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Position Matters!</strong> Filtering <code>if</code> (no else) goes at the END:
                        <code>[x for x in nums if x > 0]</code>. Ternary if-else goes at the START:
                        <code>[x if x > 0 else 0 for x in nums]</code>. Mixing them up is a common source of syntax errors!
                    </div>

                    <!-- Section 4: Nested -->
                    <h2>Nested List Comprehensions</h2>
                    <p>You can nest comprehensions to work with 2D data. Read them left-to-right: the outer loop
                    comes first, then the inner loop.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/listcomp-nested.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-nested" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Wrong position for if vs if-else</h4>
                        <pre><code class="language-python"># Wrong - filter if with else
evens = [x if x % 2 == 0 for x in nums]  # SyntaxError!

# Correct - filter if (no else) goes at end
evens = [x for x in nums if x % 2 == 0]

# Correct - ternary if-else goes at start
labels = [x if x % 2 == 0 else "odd" for x in nums]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Overcomplicating with too much nesting</h4>
                        <pre><code class="language-python"># Hard to read - too complex
result = [[y*2 for y in x if y > 0] for x in matrix if sum(x) > 5]

# Better - break into steps or use regular loops
filtered_rows = [row for row in matrix if sum(row) > 5]
result = [[y*2 for y in row if y > 0] for row in filtered_rows]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting that comprehensions create NEW lists</h4>
                        <pre><code class="language-python"># Wrong - expecting in-place modification
numbers = [1, 2, 3]
[x * 2 for x in numbers]  # Creates new list, thrown away!
print(numbers)  # Still [1, 2, 3]

# Correct - assign the result
numbers = [x * 2 for x in numbers]
print(numbers)  # [2, 4, 6]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Variable scope leaking (Python 2 issue)</h4>
                        <pre><code class="language-python"># In Python 3, comprehension variables are scoped
x = 10
squares = [x**2 for x in range(5)]
print(x)  # Still 10 in Python 3!

# This was a bug in Python 2 where x would become 4
# Python 3 fixed this - comprehension variables stay local</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Filtering and Transforming</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use list comprehensions to process a list of words.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a list of the length of each word</li>
                            <li>Create a list of words longer than 5 characters</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-lists-comprehension.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-comp" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">words = ["apple", "banana", "cherry", "date", "elderberry"]

# List of lengths
lengths = [len(word) for word in words]
print(f"Lengths: {lengths}")  # [5, 6, 6, 4, 10]

# Words longer than 5 characters
long_words = [word for word in words if len(word) > 5]
print(f"Long words: {long_words}")  # ['banana', 'cherry', 'elderberry']</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic:</strong> <code>[expr for item in iterable]</code></li>
                            <li><strong>Filter:</strong> <code>[expr for item in iterable if condition]</code></li>
                            <li><strong>Transform:</strong> <code>[true_expr if cond else false_expr for item in iterable]</code></li>
                            <li><strong>Nested:</strong> <code>[expr for outer in iterable1 for inner in iterable2]</code></li>
                            <li><strong>Position:</strong> Filter <code>if</code> at END, ternary if-else at START</li>
                            <li><strong>Benefits:</strong> More concise, often faster, more Pythonic</li>
                            <li><strong>Readability:</strong> If it's too complex, use a regular loop instead</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's learn about <strong>Tuples</strong> - Python's immutable sequence type.
                    They're like lists that can't be changed, which makes them perfect for data that shouldn't
                    be modified!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="lists-methods.jsp" />
                    <jsp:param name="prevTitle" value="List Methods" />
                    <jsp:param name="nextLink" value="tuples.jsp" />
                    <jsp:param name="nextTitle" value="Tuples" />
                    <jsp:param name="currentLessonId" value="lists-comprehension" />
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
