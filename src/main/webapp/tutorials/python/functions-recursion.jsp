<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-recursion");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Recursion - Recursive Functions, Base Case, Memoization | 8gwifi.org</title>
    <meta name="description"
        content="Master Python recursion - functions that call themselves. Learn base cases, recursive patterns, tree traversal, memoization, and when to use iteration instead.">
    <meta name="keywords"
        content="python recursion, python recursive function, python factorial recursion, python fibonacci, python memoization, python base case">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Recursion - Recursive Functions, Base Case, Memoization">
    <meta property="og:description" content="Master Python recursion: functions that call themselves for elegant problem solving.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/functions-recursion.jsp">
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
        "name": "Python Recursion",
        "description": "Master Python recursion - functions that call themselves. Learn base cases, recursive patterns, tree traversal, and memoization.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Recursive function basics", "Base cases", "Factorial and Fibonacci", "Tree traversal", "Memoization", "Recursion vs iteration"],
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

<body class="tutorial-body no-preview" data-lesson="functions-recursion">
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
                    <span>Recursion</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Recursion</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Recursion is a powerful technique where a function calls itself to solve a problem
                    by breaking it down into smaller subproblems. It's elegant for problems with natural recursive
                    structure - like tree traversal, mathematical sequences, and divide-and-conquer algorithms.
                    Understanding recursion opens doors to solving complex problems with surprisingly simple code!</p>

                    <!-- Section 1: Recursion Basics -->
                    <h2>Recursion Basics</h2>
                    <p>A recursive function has two essential parts: a <strong>base case</strong> that stops the
                    recursion, and a <strong>recursive case</strong> that calls the function with a smaller problem.
                    Without a base case, recursion continues forever (until Python raises a <code>RecursionError</code>).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/recursion-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>The Call Stack:</strong> Each recursive call adds a new frame to Python's call stack.
                        When a base case is reached, functions return and frames are removed. This is why understanding
                        the call stack helps debug recursion - you can trace how values flow through each call level.
                    </div>

                    <!-- Section 2: Practical Examples -->
                    <h2>Practical Recursion Examples</h2>
                    <p>Recursion is perfect for problems that can be expressed in terms of smaller versions of
                    themselves: calculating Fibonacci numbers, reversing strings, summing lists, and checking
                    palindromes. Let's see these classic patterns in action.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/recursion-examples.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-examples" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Thinking Recursively:</strong> Ask yourself: "Can I solve this problem by solving
                        a smaller version of it?" For factorial: <code>n! = n × (n-1)!</code>. For list sum:
                        <code>sum([1,2,3,4]) = 1 + sum([2,3,4])</code>. The base case is the smallest version
                        you can solve directly.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Tree-like Structures -->
                    <h2>Recursion with Nested Structures</h2>
                    <p>Recursion truly shines when working with nested or tree-like data structures. Traversing
                    nested dictionaries, flattening lists of lists, or processing file systems becomes elegant
                    with recursion - the function naturally handles any level of nesting.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/recursion-trees.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-trees" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Recursion Depth Limit:</strong> Python has a default recursion limit (~1000 calls)
                        to prevent stack overflow. Check with <code>sys.getrecursionlimit()</code>. For deeply
                        nested data, consider iterative solutions with explicit stacks, or use
                        <code>sys.setrecursionlimit()</code> carefully.
                    </div>

                    <!-- Section 4: Optimization -->
                    <h2>Optimization and When to Avoid Recursion</h2>
                    <p>Naive recursion can be slow due to redundant calculations (like in Fibonacci). Memoization
                    caches results to avoid recalculating. Sometimes, an iterative solution is simpler, faster,
                    and avoids stack overflow - know when to use each approach.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/recursion-optimization.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-optimization" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Missing or incorrect base case</h4>
                        <pre><code class="language-python"># Wrong - no base case, infinite recursion!
def count_down(n):
    print(n)
    count_down(n - 1)  # Never stops!

# Correct - include base case
def count_down(n):
    if n <= 0:  # Base case
        return
    print(n)
    count_down(n - 1)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not moving toward the base case</h4>
                        <pre><code class="language-python"># Wrong - n never decreases!
def factorial(n):
    if n == 1:
        return 1
    return n * factorial(n)  # Should be (n-1)!

# Correct - progress toward base case
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)  # n decreases</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using recursion when iteration is simpler</h4>
                        <pre><code class="language-python"># Overcomplicated recursion
def sum_list(lst, index=0):
    if index >= len(lst):
        return 0
    return lst[index] + sum_list(lst, index + 1)

# Simpler iteration
def sum_list(lst):
    total = 0
    for item in lst:
        total += item
    return total

# Or just use built-in!
total = sum(lst)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting to return the recursive result</h4>
                        <pre><code class="language-python"># Wrong - missing return!
def factorial(n):
    if n <= 1:
        return 1
    factorial(n - 1) * n  # Result not returned!

# Correct - return the result
def factorial(n):
    if n <= 1:
        return 1
    return factorial(n - 1) * n</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not handling edge cases</h4>
                        <pre><code class="language-python"># Wrong - crashes on negative numbers
def factorial(n):
    if n == 1:
        return 1
    return n * factorial(n - 1)

factorial(-3)  # Infinite recursion!

# Correct - handle edge cases
def factorial(n):
    if n < 0:
        raise ValueError("Factorial not defined for negative numbers")
    if n <= 1:
        return 1
    return n * factorial(n - 1)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Binary Search</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Implement binary search recursively.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Search for a target in a sorted list</li>
                            <li>Return the index if found, -1 if not</li>
                            <li>Use recursion to divide the search space in half</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-functions-recursion.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-recursion" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">def binary_search(arr, target, low=0, high=None):
    """Recursively search for target in sorted array."""
    if high is None:
        high = len(arr) - 1

    # Base case: not found
    if low > high:
        return -1

    mid = (low + high) // 2

    # Base case: found
    if arr[mid] == target:
        return mid

    # Recursive cases
    if arr[mid] > target:
        return binary_search(arr, target, low, mid - 1)
    else:
        return binary_search(arr, target, mid + 1, high)

# Test it
numbers = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
print(f"Search for 7: index {binary_search(numbers, 7)}")
print(f"Search for 15: index {binary_search(numbers, 15)}")
print(f"Search for 6: index {binary_search(numbers, 6)}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Recursion:</strong> A function that calls itself to solve smaller subproblems</li>
                            <li><strong>Base case:</strong> Condition that stops recursion - always required!</li>
                            <li><strong>Recursive case:</strong> Breaks problem down and calls itself</li>
                            <li><strong>Best for:</strong> Tree structures, divide-and-conquer, naturally recursive problems</li>
                            <li><strong>Memoization:</strong> Cache results with <code>@lru_cache</code> to avoid redundant calls</li>
                            <li><strong>Limit:</strong> Python has ~1000 call depth limit by default</li>
                            <li><strong>Consider iteration:</strong> Often simpler and no stack overflow risk</li>
                            <li><strong>Pattern:</strong> Can I solve this by solving a smaller version of it?</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Functions module! You now have powerful tools for writing
                    reusable, modular code. Next, we'll explore <strong>Modules and Packages</strong> - how to
                    organize your code into files, import functionality, and use Python's vast ecosystem of
                    third-party packages!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="functions-lambda.jsp" />
                    <jsp:param name="prevTitle" value="Lambda Functions" />
                    <jsp:param name="nextLink" value="modules.jsp" />
                    <jsp:param name="nextTitle" value="Modules" />
                    <jsp:param name="currentLessonId" value="functions-recursion" />
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
