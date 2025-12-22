<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "binary-search" );
        request.setAttribute("currentModule", "Searching Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Binary Search - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Binary Search - the most important searching algorithm! O(log n) time complexity, 50,000x faster than linear search.">
            <meta name="keywords" content="binary search, O(log n), logarithmic time, divide and conquer, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Binary Search - DSA Tutorial">
            <meta property="og:description"
                content="Learn Binary Search - the foundation of efficient searching with O(log n) complexity.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/binary-search.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">

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
        "name": "Binary Search Algorithm",
        "description": "Master Binary Search with O(log n) complexity - the most important searching algorithm.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["Binary Search", "O(log n)", "Divide and Conquer", "Logarithmic Time"],
        "timeRequired": "PT15M",
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

        <body class="tutorial-body no-preview" data-lesson="binary-search">
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
                                    <span>Binary Search</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">📖 Binary Search</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner to Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Looking for a word in a dictionary with 100,000 words? Do you start
                                        from page 1 and check every word? <strong>No!</strong> You open the middle, see
                                        if your word comes before or after, then repeat. Each step cuts the search space
                                        in <strong>half</strong>. That's Binary Search - the most elegant algorithm in
                                        computer science!</p>

                                    <!-- Section 1: The Dictionary Lookup -->
                                    <h2>The Dictionary Lookup</h2>

                                    <p>Imagine searching for "algorithm" in a dictionary:</p>

                                    <div class="info-box">
                                        <h4>The Smart Strategy</h4>
                                        <ol>
                                            <li><strong>Open middle:</strong> See "mango" - your word comes BEFORE</li>
                                            <li><strong>Throw away second half:</strong> Only search first half</li>
                                            <li><strong>Open middle of first half:</strong> See "dog" - your word comes
                                                BEFORE again</li>
                                            <li><strong>Repeat:</strong> Keep halving until you find it!</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> Each step eliminates HALF the remaining words!
                                        </p>
                                    </div>

                                    <h3>The Power of Halving</h3>

                                    <div class="success-box">
                                        <h4>Why O(log n) is Amazing</h4>
                                        <p>With 1 million items, how many steps? <strong>Just 20!</strong></p>
                                        <ul>
                                            <li>1,000,000 → 500,000 → 250,000 → 125,000 → ...</li>
                                            <li>Each step cuts the problem in half</li>
                                            <li>After 20 steps: down to 1 item!</li>
                                        </ul>
                                        <p><strong>That's O(log n) - logarithmic time!</strong></p>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Binary Search eliminates half the array with each comparison:</p>

                                    <div id="binarySearchVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li><strong>L (Left):</strong> Start of search range</li>
                                            <li><strong>R (Right):</strong> End of search range</li>
                                            <li><strong>M (Mid):</strong> Middle element to compare</li>
                                            <li><strong>Blue boxes:</strong> Current search range</li>
                                            <li><strong>Faded boxes:</strong> Eliminated from search</li>
                                            <li><strong>Green box:</strong> Target found!</li>
                                        </ul>
                                    </div>

                                    <!-- The Requirement -->
                                    <h3>The Requirement: Sorted Array</h3>

                                    <div class="warning-box">
                                        <h4>⚠️ Binary Search ONLY Works on Sorted Arrays</h4>
                                        <p><strong>Why?</strong> We need to know if the target is in the left or right
                                            half!</p>
                                        <ul>
                                            <li>✅ Sorted: [1, 3, 5, 7, 9] - Binary Search works!</li>
                                            <li>❌ Random: [5, 1, 9, 3, 7] - Binary Search fails!</li>
                                        </ul>
                                        <p>If your array isn't sorted, either sort it first (O(n log n)) or use Linear
                                            Search (O(n)).</p>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/binary-search-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-binary-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Iterative vs Recursive:</strong> Both have O(log n) time, but iterative
                                        uses O(1) space while recursive uses O(log n) space for the call stack.
                                        Iterative is recommended for production!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is Binary Search O(log n) and not O(n)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Each comparison eliminates HALF the remaining elements. How many times
                                                can you halve n until you reach 1? log₂(n) times! For 1 million
                                                elements, that's only 20 comparisons. Linear search would need up to 1
                                                million!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>What's the common mistake: mid = (left + right) / 2?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Integer overflow! If left and right are large, their sum might overflow.
                                                Safe version: mid = left + (right - left) / 2. This avoids overflow
                                                while giving the same result.
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Complexity Analysis -->
                                    <h2>Why O(log n)?</h2>

                                    <p>Let's understand logarithmic time complexity:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Array Size</th>
                                                <th>Linear Search</th>
                                                <th>Binary Search</th>
                                                <th>Speedup</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>10</td>
                                                <td>10</td>
                                                <td>4</td>
                                                <td>2.5x</td>
                                            </tr>
                                            <tr>
                                                <td>100</td>
                                                <td>100</td>
                                                <td>7</td>
                                                <td>14x</td>
                                            </tr>
                                            <tr>
                                                <td>1,000</td>
                                                <td>1,000</td>
                                                <td>10</td>
                                                <td>100x</td>
                                            </tr>
                                            <tr>
                                                <td>1,000,000</td>
                                                <td>1,000,000</td>
                                                <td>20</td>
                                                <td>50,000x</td>
                                            </tr>
                                            <tr>
                                                <td>1,000,000,000</td>
                                                <td>1,000,000,000</td>
                                                <td>30</td>
                                                <td>33,000,000x</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="success-box">
                                        <h4>✅ The Magic of Logarithms</h4>
                                        <p><strong>Doubling the input only adds ONE more step!</strong></p>
                                        <ul>
                                            <li>1,000 elements: 10 steps</li>
                                            <li>2,000 elements: 11 steps (just +1!)</li>
                                            <li>1,000,000 elements: 20 steps</li>
                                            <li>2,000,000 elements: 21 steps (just +1!)</li>
                                        </ul>
                                        <p>This is why Binary Search scales beautifully to massive datasets!</p>
                                    </div>

                                    <!-- Common Pitfalls -->
                                    <h2>Common Pitfalls</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Pitfall 1: Integer Overflow</h4>
                                        <p><strong>Wrong:</strong> <code>mid = (left + right) / 2</code></p>
                                        <p><strong>Right:</strong> <code>mid = left + (right - left) / 2</code></p>
                                        <p>If left and right are large (e.g., near 2 billion), their sum can overflow!
                                        </p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Pitfall 2: Infinite Loop</h4>
                                        <p><strong>Wrong:</strong> <code>right = mid</code> (can loop forever)</p>
                                        <p><strong>Right:</strong> <code>right = mid - 1</code></p>
                                        <p>Always move the pointer PAST the mid to avoid infinite loops!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Pitfall 3: Off-by-One Error</h4>
                                        <p><strong>Wrong:</strong> <code>while left < right</code></p>
                                        <p><strong>Right:</strong> <code>while left <= right</code></p>
                                        <p>Use <= to handle the case when left and right point to the same element!</p>
                                    </div>

                                    <!-- Real-World Applications -->
                                    <h2>Real-World Applications</h2>

                                    <div class="success-box">
                                        <h4>Where Binary Search is Used</h4>
                                        <ul>
                                            <li><strong>Databases:</strong> B-tree indexes use binary search variant
                                            </li>
                                            <li><strong>Java:</strong> <code>Arrays.binarySearch()</code></li>
                                            <li><strong>Python:</strong> <code>bisect</code> module</li>
                                            <li><strong>C++:</strong> <code>std::binary_search()</code></li>
                                            <li><strong>Git:</strong> <code>git bisect</code> finds bugs in commit
                                                history</li>
                                            <li><strong>Games:</strong> Pathfinding optimizations</li>
                                            <li><strong>Libraries:</strong> Finding books, contacts, any sorted data
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Comparison -->
                                    <h2>Binary Search vs Linear Search</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Linear Search</th>
                                                <th>Binary Search</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Time Complexity</td>
                                                <td>O(n)</td>
                                                <td>O(log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Space Complexity</td>
                                                <td>O(1) ✓</td>
                                                <td>O(1) iterative ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Requirement</td>
                                                <td>Any array ✓</td>
                                                <td>Sorted array only</td>
                                            </tr>
                                            <tr>
                                                <td>Best Case</td>
                                                <td>O(1) - first element</td>
                                                <td>O(1) - middle element</td>
                                            </tr>
                                            <tr>
                                                <td>Worst Case</td>
                                                <td>O(n)</td>
                                                <td>O(log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Use When</td>
                                                <td>Small or unsorted</td>
                                                <td>Large and sorted ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <h4>The Trade-off</h4>
                                        <p><strong>Binary Search is faster BUT requires sorted data.</strong></p>
                                        <ul>
                                            <li>If data is already sorted: Use Binary Search!</li>
                                            <li>If sorting cost < search savings: Sort then Binary Search</li>
                                            <li>If data is unsorted and small: Linear Search is fine</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Binary Search is the <strong>most important searching algorithm</strong>:</p>
                                        <ul>
                                            <li>✅ O(log n) - logarithmic time complexity</li>
                                            <li>✅ 50,000x faster than linear for 1M elements</li>
                                            <li>✅ Foundation for many interview problems</li>
                                            <li>✅ Used everywhere in production code</li>
                                            <li>⚠️ Requires sorted array</li>
                                            <li>⚠️ Watch for overflow and off-by-one errors</li>
                                        </ul>
                                        <p><strong>Master Binary Search - it's essential for every programmer!</strong>
                                        </p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Binary Search Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Divide and conquer - eliminate half each step
                                            </li>
                                            <li><strong>Complexity:</strong> O(log n) - 20 steps for 1 million items!
                                            </li>
                                            <li><strong>Requirement:</strong> Array must be sorted</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Binary Search is a
                                            MUST KNOW. Practice iterative and recursive versions. Know the variants
                                            (first/last occurrence, rotated array). Mention O(log n) and the sorted
                                            requirement!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered Binary Search! Next: <strong>Linear Search</strong> - the
                                        baseline searching algorithm for comparison.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement Binary Search from scratch. Try the
                                        variants: find first occurrence, find last occurrence, search in rotated sorted
                                        array!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="tim-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Tim Sort" />
                                    <jsp:param name="nextLink" value="linear-search.jsp" />
                                    <jsp:param name="nextTitle" value="Linear Search" />
                                    <jsp:param name="currentLessonId" value="binary-search" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/binary-search-viz.js"></script>
        </body>

        </html>