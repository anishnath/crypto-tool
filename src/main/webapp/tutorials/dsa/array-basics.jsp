<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "array-basics" ); request.setAttribute("currentModule", "Arrays & Strings"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Array Fundamentals - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn array fundamentals with O(1) access and O(n) operations. Understand when to use arrays and common patterns.">
            <meta name="keywords" content="arrays, data structures, O(1) access, array operations, DSA tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Array Fundamentals - DSA Tutorial">
            <meta property="og:description" content="Master array basics with interactive examples and visualizations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/array-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror-modes/python.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/array-viz.css">

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
        "name": "Array Fundamentals",
        "description": "Learn array basics, O(1) access, and when to use arrays.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Arrays", "O(1) Access", "Array Operations", "Data Structures"],
        "timeRequired": "PT10M",
        "isPartOf": {
            "@type": "Course",
            "name": "Data Structures and Algorithms Tutorial",
            "url": "https://8gwifi.org/tutorials/dsa/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="array-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-dsa.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Array Fundamentals</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">📊 Array Fundamentals</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're building a game leaderboard. Players can view their rank
                                        instantly - that's O(1) access! But adding a new player requires shifting
                                        everyone below - that's O(1). Arrays are perfect for some tasks and terrible for
                                        others. Let's see when to use them.</p>

                                    <!-- Section 1: What is an Array? -->
                                    <h2>What is an Array?</h2>

                                    <p>An array is a collection of elements stored in <strong>contiguous
                                            memory</strong>. Think of it like numbered boxes in a row:</p>

                                    <div class="info-box">
                                        <h4>Array Structure</h4>
                                        <pre><code class="language-plaintext">Index:  0    1    2    3    4
Value: [10] [20] [30] [40] [50]
        ↑
    Memory address: 1000, 1004, 1008, 1012, 1016...</code></pre>
                                        <p><strong>Key insight:</strong> Because elements are next to each other in
                                            memory, you can jump directly to any index using math:</p>
                                        <p><code>address = base_address + (index × element_size)</code></p>
                                        <p>This makes access <strong>O(1)</strong> - instant, regardless of array size!
                                        </p>
                                    </div>

                                    <!-- Section 2: Array Operations -->
                                    <h2>Array Operations</h2>

                                    <p>Let's see the core operations and their complexities:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/array-operations.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-array-ops" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>The Tradeoff:</strong>
                                        <ul>
                                            <li>✅ <strong>Access by index:</strong> O(1) - Lightning fast!</li>
                                            <li>❌ <strong>Insert/Delete:</strong> O(n) - Must shift elements</li>
                                            <li>❌ <strong>Search by value:</strong> O(n) - Must check each element</li>
                                        </ul>
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is <code>array[100]</code> instant (O(1))?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                The computer calculates the exact memory address using
                                                <code>base + (100 × size)</code> and jumps directly there. No loop
                                                needed!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>Why is inserting at index 0 slow (O(n))?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                You must shift ALL existing elements one position to the right to make
                                                room. For n elements, that's n shifts = O(n).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Compact Visualization -->
                                    <h2>See It in Action</h2>

                                    <div id="arrayVizCompact"></div>

                                    <!-- Common Patterns -->
                                    <h2>Common Array Patterns</h2>

                                    <p>Here are techniques you'll use frequently:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/array-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-array-patterns" />
                                    </jsp:include>

                                    <!-- When to Use Arrays -->
                                    <h2>When to Use Arrays</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use Arrays When</th>
                                                <th>Avoid Arrays When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>✅ You need fast random access</td>
                                                <td>❌ Frequent insertions/deletions</td>
                                            </tr>
                                            <tr>
                                                <td>✅ Size is known or fixed</td>
                                                <td>❌ Size changes unpredictably</td>
                                            </tr>
                                            <tr>
                                                <td>✅ Iterating through all elements</td>
                                                <td>❌ Searching by value frequently</td>
                                            </tr>
                                            <tr>
                                                <td>✅ Memory efficiency matters</td>
                                                <td>❌ Need fast insertions at beginning</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="success-box">
                                        <h4>Real-World Uses</h4>
                                        <ul>
                                            <li><strong>Leaderboards:</strong> Fast rank lookup</li>
                                            <li><strong>Image pixels:</strong> Direct coordinate access</li>
                                            <li><strong>Audio samples:</strong> Sequential processing</li>
                                            <li><strong>Database records:</strong> Index-based queries</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Index Out of Bounds</h4>
                                        <pre><code class="language-python">arr = [1, 2, 3]
print(arr[3])  # Error! Valid indices: 0, 1, 2</code></pre>
                                        <p><strong>Fix:</strong> Always check <code>if index < len(arr)</code></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Modifying While Iterating</h4>
                                        <pre><code class="language-python">for i in range(len(arr)):
    arr.append(i)  # Infinite loop!</code></pre>
                                        <p><strong>Fix:</strong> Create a copy or iterate backwards</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Array Guide</h3>
                                        <ol>
                                            <li><strong>Access:</strong> O(1) - Use arrays when you need fast lookups by
                                                index</li>
                                            <li><strong>Insert/Delete:</strong> O(n) - Avoid arrays for frequent
                                                modifications</li>
                                            <li><strong>Memory:</strong> Contiguous storage = cache-friendly and
                                                efficient</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> When asked "Why use
                                            an array?", mention O(1) access and memory locality!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand arrays, you're ready for <strong>array
                                            techniques</strong>! Next lesson: <strong>Two Pointers</strong> - a powerful
                                        pattern for solving array problems efficiently.</p>

                                    <div class="tip-box">
                                        <strong>Preview:</strong> Two pointers can solve problems like "find two numbers
                                        that sum to target" in O(n) instead of O(n²). Stay tuned!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="algorithm-analysis.jsp" />
                                    <jsp:param name="prevTitle" value="Algorithm Analysis" />
                                    <jsp:param name="nextLink" value="two-pointers.jsp" />
                                    <jsp:param name="nextTitle" value="Two Pointers Technique" />
                                    <jsp:param name="currentLessonId" value="array-basics" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/visualizations/array-viz.js"></script>
        </body>

        </html>