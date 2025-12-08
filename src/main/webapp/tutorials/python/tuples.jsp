<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "tuples");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Tuples - Immutable Sequences & Unpacking | 8gwifi.org</title>
    <meta name="description"
        content="Master Python tuples - immutable, ordered sequences. Learn tuple creation, unpacking, operations, and when to use tuples vs lists for better code.">
    <meta name="keywords"
        content="python tuples, python tuple unpacking, python immutable, tuple vs list python, python tuple example">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Tuples - Immutable Sequences & Unpacking">
    <meta property="og:description" content="Master Python tuples for immutable data storage, unpacking, and efficient code.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/tuples.jsp">
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
        "name": "Python Tuples",
        "description": "Master Python tuples - immutable sequences, unpacking, and tuple operations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Creating tuples", "Tuple unpacking", "Extended unpacking", "Tuple operations", "Tuples vs lists"],
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

<body class="tutorial-body no-preview" data-lesson="tuples">
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
                    <span>Tuples</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Tuples</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Tuples are Python's immutable sequence type - once created, they cannot be changed.
                    This makes them perfect for data that should stay constant, like coordinates, RGB colors, or database
                    records. They're also faster and use less memory than lists!</p>

                    <!-- Section 1: Creating Tuples -->
                    <h2>Creating Tuples</h2>
                    <p>Tuples are created with parentheses <code>()</code> or just comma-separated values.
                    Watch out for the single-item tuple gotcha - it needs a trailing comma!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/tuples-creating.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-creating" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Single Item Tuple Gotcha:</strong> A single item in parentheses like <code>("apple")</code>
                        is just a string, not a tuple! You must add a trailing comma: <code>("apple",)</code>. This is one
                        of Python's most common gotchas for beginners.
                    </div>

                    <!-- Section 2: Unpacking -->
                    <h2>Tuple Unpacking</h2>
                    <p>One of Python's most elegant features is tuple unpacking - extracting tuple values into
                    separate variables in a single statement. It's used everywhere from variable swapping to
                    function returns.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/tuples-unpacking.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-unpacking" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use underscore <code>_</code> for values you don't need:
                        <code>name, _, age = ("Alice", "ignored", 25)</code>. Use <code>*_</code> to ignore
                        multiple values: <code>first, *_, last = (1, 2, 3, 4, 5)</code>.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Operations -->
                    <h2>Tuple Operations and Methods</h2>
                    <p>Tuples support most list operations except modification. They have only two methods
                    (<code>count()</code> and <code>index()</code>) but work with all built-in functions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/tuples-operations.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-operations" />
                    </jsp:include>

                    <!-- Section 4: Tuples vs Lists -->
                    <h2>Tuples vs Lists</h2>
                    <p>When should you use a tuple instead of a list? Understanding the differences helps you
                    write more efficient and safer code.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/tuples-vs-lists.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-vs-lists" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Important:</strong> While tuples are immutable, if a tuple contains a mutable object
                        (like a list), that object CAN be modified! <code>t = ([1, 2], 3)</code> - you can do
                        <code>t[0].append(4)</code> but not <code>t[0] = [5, 6]</code>.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting comma in single-item tuple</h4>
                        <pre><code class="language-python"># Wrong - this is a string, not a tuple!
single = ("apple")
print(type(single))  # <class 'str'>

# Correct - need trailing comma
single = ("apple",)
print(type(single))  # <class 'tuple'></code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Trying to modify a tuple</h4>
                        <pre><code class="language-python"># Wrong - tuples are immutable!
point = (10, 20)
point[0] = 15  # TypeError!

# Correct - create a new tuple
point = (15, point[1])
# Or convert to list, modify, convert back
temp = list(point)
temp[0] = 15
point = tuple(temp)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Wrong number of variables in unpacking</h4>
                        <pre><code class="language-python"># Wrong - count mismatch
point = (10, 20, 30)
x, y = point  # ValueError: too many values to unpack

# Correct - match the count
x, y, z = point
# Or use * to capture extras
x, *rest = point  # x=10, rest=[20, 30]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Confusing tuple methods with list methods</h4>
                        <pre><code class="language-python"># Wrong - tuples don't have append, sort, etc.
t = (3, 1, 2)
t.append(4)  # AttributeError!
t.sort()     # AttributeError!

# Correct - tuples only have count() and index()
print(t.count(1))  # 1
print(t.index(2))  # 2

# For sorting, use sorted() which returns a list
sorted_list = sorted(t)  # [1, 2, 3]</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Working with Coordinates</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Work with tuples representing 2D coordinates.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a tuple for point (10, 20)</li>
                            <li>Unpack it into variables x and y</li>
                            <li>Print the coordinates</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-tuples-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-tuples" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Create a tuple for point (10, 20)
point = (10, 20)

# Unpack into x and y
x, y = point

# Print the coordinates
print(f"Point coordinates: x={x}, y={y}")
# Output: Point coordinates: x=10, y=20</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Creating:</strong> Use <code>()</code> or comma-separated values</li>
                            <li><strong>Single item:</strong> Requires trailing comma: <code>("item",)</code></li>
                            <li><strong>Immutable:</strong> Cannot modify after creation</li>
                            <li><strong>Unpacking:</strong> <code>x, y, z = tuple</code></li>
                            <li><strong>Extended unpacking:</strong> <code>first, *rest, last = tuple</code></li>
                            <li><strong>Methods:</strong> Only <code>count()</code> and <code>index()</code></li>
                            <li><strong>Use tuples:</strong> For fixed data, dict keys, function returns</li>
                            <li><strong>Use lists:</strong> When you need to modify the collection</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Sets</strong> - Python's unordered collection of unique elements.
                    Sets are perfect for removing duplicates and performing mathematical set operations like
                    union, intersection, and difference!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="lists-comprehension.jsp" />
                    <jsp:param name="prevTitle" value="List Comprehensions" />
                    <jsp:param name="nextLink" value="sets.jsp" />
                    <jsp:param name="nextTitle" value="Sets" />
                    <jsp:param name="currentLessonId" value="tuples" />
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
