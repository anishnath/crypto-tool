<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-nested");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Nested Loops - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python nested loops. Learn to iterate over 2D data, matrices, print patterns, and work with complex data structures using loops within loops.">
    <meta name="keywords"
        content="python nested loops, python loop inside loop, python 2d array iteration, python matrix loop, python pattern printing">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Nested Loops - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python nested loops for complex iterations.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/loops-nested.jsp">
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
        "name": "Python Nested Loops",
        "description": "Master Python nested loops for 2D data, matrices, patterns, and complex iterations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Nested loop syntax", "2D data iteration", "Matrix operations", "Pattern printing", "Break in nested loops"],
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

<body class="tutorial-body no-preview" data-lesson="loops-nested">
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
                    <span>Nested Loops</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Nested Loops</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">A nested loop is a loop inside another loop. The inner loop executes completely
                    for each iteration of the outer loop. Think of it like a clock: for every hour that passes,
                    the minute hand goes around 60 times!</p>

                    <!-- Section 1: Basic Nested Loops -->
                    <h2>How Nested Loops Work</h2>
                    <p>In a nested loop, the inner loop runs its full course for each single iteration of the outer loop.
                    This creates a multiplicative effect on the total number of iterations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-nested-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Iteration Count:</strong> If the outer loop runs <code>m</code> times and the inner loop
                        runs <code>n</code> times, the code inside the inner loop runs <code>m × n</code> times total.
                        A 10×10 nested loop runs 100 times; a 100×100 runs 10,000 times!
                    </div>

                    <!-- Section 2: 2D Data -->
                    <h2>Working with 2D Data</h2>
                    <p>Nested loops are essential for working with 2D data structures like matrices, grids, and
                    tables. The outer loop handles rows, the inner loop handles columns.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-nested-2d.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-2d" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> When searching in 2D data, you need to break out of BOTH loops
                        when you find what you're looking for. Use a flag variable or put the nested loop in a
                        function and use <code>return</code>.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Pattern Printing -->
                    <h2>Pattern Printing</h2>
                    <p>Nested loops are the classic way to print patterns - triangles, pyramids, rectangles, and more.
                    The outer loop controls rows, the inner loop controls what's printed in each row.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-nested-patterns.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-patterns" />
                    </jsp:include>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Nested loops are used for combinations, comparisons, grid-based applications, and processing
                    hierarchical data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-nested-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Performance Warning:</strong> Nested loops can be slow for large data!
                        O(n²) complexity means doubling the data quadruples the time. For 1000 items,
                        a nested loop runs 1,000,000 times. Consider using built-in functions, list comprehensions,
                        or libraries like NumPy for better performance.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Wrong variable in inner loop</h4>
                        <pre><code class="language-python"># Wrong - using outer variable i in inner loop!
for i in range(3):
    for j in range(3):
        print(i)  # Should be j or both

# Correct
for i in range(3):
    for j in range(3):
        print(f"({i}, {j})")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Break only exits inner loop</h4>
                        <pre><code class="language-python"># Wrong assumption - break exits both loops
for i in range(5):
    for j in range(5):
        if found:
            break  # Only exits inner loop!
    # Outer loop continues!

# Correct - use flag
found = False
for i in range(5):
    for j in range(5):
        if condition:
            found = True
            break
    if found:
        break</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Modifying list while iterating</h4>
                        <pre><code class="language-python"># Wrong - modifying during iteration
for row in matrix:
    for i, val in enumerate(row):
        if val == 0:
            row.remove(val)  # Dangerous!

# Correct - build new structure
new_matrix = []
for row in matrix:
    new_row = [val for val in row if val != 0]
    new_matrix.append(new_row)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Off-by-one in indices</h4>
                        <pre><code class="language-python"># Wrong - accessing out of bounds
for i in range(len(matrix)):
    for j in range(len(matrix)):  # Wrong if not square!
        print(matrix[i][j])

# Correct - use actual row length
for i in range(len(matrix)):
    for j in range(len(matrix[i])):  # Each row's length
        print(matrix[i][j])</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Triangle Pattern</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Print a right triangle pattern using nested loops.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Print 5 rows</li>
                            <li>Row 1: 1 star, Row 2: 2 stars, ... Row 5: 5 stars</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-loops-nested.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-nested" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">rows = 5

for i in range(1, rows + 1):    # 1 to 5
    for j in range(i):          # 0 to i-1 (prints i stars)
        print("*", end="")
    print()  # New line after each row

# Output:
# *
# **
# ***
# ****
# *****</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Nested loop:</strong> Loop inside another loop</li>
                            <li><strong>Iterations:</strong> Inner loop runs completely for each outer iteration</li>
                            <li><strong>Total runs:</strong> outer_iterations × inner_iterations</li>
                            <li><strong>2D data:</strong> Outer loop = rows, inner loop = columns</li>
                            <li><strong>break:</strong> Only exits the innermost loop</li>
                            <li><strong>Performance:</strong> O(n²) - can be slow for large data</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Control Flow module! You now have full control over
                    program flow with conditionals and loops. Next, we'll dive into <strong>Lists</strong> -
                    Python's most versatile data structure for storing collections of items!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-control.jsp" />
                    <jsp:param name="prevTitle" value="Loop Control" />
                    <jsp:param name="nextLink" value="lists.jsp" />
                    <jsp:param name="nextTitle" value="Lists" />
                    <jsp:param name="currentLessonId" value="loops-nested" />
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
