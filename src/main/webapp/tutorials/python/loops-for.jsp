<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-for");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>For Loops - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python for loops. Learn to iterate over lists, strings, dictionaries with range(), enumerate(), and zip(). Practical examples included.">
    <meta name="keywords"
        content="python for loop, python iteration, python range function, python enumerate, python zip, python iterate list">

    <meta property="og:type" content="article">
    <meta property="og:title" content="For Loops - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python for loops for iterating over sequences.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/loops-for.jsp">
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
        "name": "Python For Loops",
        "description": "Master Python for loops for iterating over sequences with range(), enumerate(), and zip().",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["for loop syntax", "Iterating over sequences", "range() function", "enumerate() function", "zip() function", "Dictionary iteration"],
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

<body class="tutorial-body no-preview" data-lesson="loops-for">
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
                    <span>For Loops</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">For Loops</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>for</code> loop is Python's workhorse for iteration. Unlike traditional
                    counter-based loops in C or Java, Python's for loop iterates directly over items in a sequence -
                    making it elegant, readable, and powerful!</p>

                    <!-- Section 1: Basic Iteration -->
                    <h2>Iterating Over Sequences</h2>
                    <p>Python's for loop works with any iterable: lists, strings, tuples, sets, dictionaries, and more.
                    The loop variable takes each value in the sequence, one at a time.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-for-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Python vs Other Languages:</strong> In C-style languages, you write
                        <code>for (int i = 0; i &lt; n; i++)</code>. In Python, you simply write
                        <code>for item in collection:</code>. This is called "iterating over" a sequence
                        rather than "counting up to" a number.
                    </div>

                    <!-- Section 2: The range() Function -->
                    <h2>The <code>range()</code> Function</h2>
                    <p>When you need to repeat something a specific number of times or need numeric sequences,
                    use <code>range()</code>. It generates numbers on-demand without creating a full list in memory.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Syntax</th>
                                <th>Description</th>
                                <th>Example Output</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>range(5)</code></td><td>0 to 4 (stop-1)</td><td>0, 1, 2, 3, 4</td></tr>
                            <tr><td><code>range(2, 6)</code></td><td>2 to 5 (start to stop-1)</td><td>2, 3, 4, 5</td></tr>
                            <tr><td><code>range(0, 10, 2)</code></td><td>0 to 8, step by 2</td><td>0, 2, 4, 6, 8</td></tr>
                            <tr><td><code>range(5, 0, -1)</code></td><td>5 to 1, counting down</td><td>5, 4, 3, 2, 1</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-for-range.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-range" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Memory Efficiency:</strong> <code>range()</code> doesn't create a list in memory -
                        it generates numbers one at a time. This means <code>range(1000000)</code> uses minimal memory,
                        unlike <code>list(range(1000000))</code> which would create a million-item list!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: enumerate() -->
                    <h2>Using <code>enumerate()</code></h2>
                    <p>When you need both the index and the value while iterating, <code>enumerate()</code> is your
                    friend. It's cleaner than maintaining a manual counter!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-for-enumerate.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-enumerate" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>enumerate(items, start=1)</code> when you want
                        human-friendly numbering starting from 1 instead of 0. Perfect for menus and lists!
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>For loops are essential for processing data, building new collections, and combining
                    information from multiple sources.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-for-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Don't Modify While Iterating:</strong> Never add or remove items from a list
                        while looping over it! This can cause unexpected behavior or errors. Instead, create
                        a new list or iterate over a copy: <code>for item in list.copy():</code>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Off-by-one errors with range()</h4>
                        <pre><code class="language-python"># Wrong - this prints 0-9, not 1-10!
for i in range(10):
    print(i)

# Correct - for 1-10
for i in range(1, 11):  # stop is exclusive!
    print(i)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using range(len()) when not needed</h4>
                        <pre><code class="language-python"># Unnecessary - don't do this!
for i in range(len(fruits)):
    print(fruits[i])

# Better - iterate directly
for fruit in fruits:
    print(fruit)

# If you need the index too, use enumerate
for i, fruit in enumerate(fruits):
    print(i, fruit)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Modifying list while iterating</h4>
                        <pre><code class="language-python"># Wrong - unpredictable behavior!
for item in items:
    if some_condition:
        items.remove(item)  # Don't do this!

# Correct - iterate over a copy
for item in items.copy():
    if some_condition:
        items.remove(item)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting the colon</h4>
                        <pre><code class="language-python"># Wrong - SyntaxError!
for item in items
    print(item)

# Correct
for item in items:
    print(item)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Sum Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Calculate sums using for loops.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Calculate the sum of the <code>numbers</code> list</li>
                            <li>Calculate the sum of numbers from 1 to 100 using <code>range()</code></li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-loops-for.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-for" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">numbers = [10, 20, 30, 40, 50]
total_sum = 0

# 1. Sum of list
for num in numbers:
    total_sum += num
print(f"Sum of list: {total_sum}")  # 150

# 2. Sum of 1-100
range_sum = 0
for i in range(1, 101):  # 101 because stop is exclusive
    range_sum += i
print(f"Sum of 1-100: {range_sum}")  # 5050</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>for item in sequence:</strong> Iterates over each item directly</li>
                            <li><strong>range(stop):</strong> Generates 0 to stop-1</li>
                            <li><strong>range(start, stop, step):</strong> Full control over the sequence</li>
                            <li><strong>enumerate():</strong> Get both index and value</li>
                            <li><strong>zip():</strong> Iterate over multiple sequences in parallel</li>
                            <li><strong>dict.items():</strong> Iterate over dictionary key-value pairs</li>
                            <li><strong>Don't modify</strong> lists while iterating over them</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can iterate with for loops, let's learn about <strong>while loops</strong> -
                    loops that continue as long as a condition is true. While loops are perfect when you don't
                    know in advance how many iterations you need!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="control-ternary.jsp" />
                    <jsp:param name="prevTitle" value="Ternary Operator" />
                    <jsp:param name="nextLink" value="loops-while.jsp" />
                    <jsp:param name="nextTitle" value="While Loops" />
                    <jsp:param name="currentLessonId" value="loops-for" />
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
