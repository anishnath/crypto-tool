<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "bubble-sort" ); request.setAttribute("currentModule", "Sorting Algorithms"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Bubble Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Bubble Sort with interactive visualization. Understand why it's O(n²) and when to use it.">
            <meta name="keywords" content="bubble sort, sorting algorithm, O(n²), algorithm visualization, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Bubble Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Bubble Sort with visual examples and understand its complexity.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/bubble-sort.jsp">
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
        "name": "Bubble Sort Algorithm",
        "description": "Learn Bubble Sort with interactive visualization and understand its O(n²) complexity.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Bubble Sort", "Sorting Algorithms", "Algorithm Complexity"],
        "timeRequired": "PT12M",
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

        <body class="tutorial-body no-preview" data-lesson="bubble-sort">
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
                                    <span>Bubble Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🫧 Bubble Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You need to sort a list of numbers. The simplest approach? Compare
                                        neighbors and swap if they're out of order. That's Bubble Sort - easy to
                                        understand but slow for large datasets. Let's see why.</p>

                                    <!-- Section 1: How It Works -->
                                    <h2>How Bubble Sort Works</h2>

                                    <p>Bubble Sort repeatedly steps through the array, comparing adjacent elements and
                                        swapping them if they're in the wrong order.</p>

                                    <div class="info-box">
                                        <h4>The Algorithm</h4>
                                        <ol>
                                            <li>Compare adjacent elements (arr[i] and arr[i+1])</li>
                                            <li>If they're out of order, swap them</li>
                                            <li>Repeat for the entire array</li>
                                            <li>After one pass, the largest element "bubbles" to the end</li>
                                            <li>Repeat, ignoring the last sorted elements</li>
                                        </ol>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>

                                    <div class="visualization-container">
                                        <div id="bubbleSortVisualization"></div>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/bubble-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-bubble-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why "Bubble"?</strong> Larger elements "bubble up" to the end of the
                                        array, just like bubbles rising in water!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>How many passes does Bubble Sort need for an array of size
                                                n?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                At most n-1 passes. After each pass, one more element is in its final
                                                position.
                                            </details>
                                        </li>
                                        <li>
                                            <strong>What's the time complexity?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                O(n²) - two nested loops. Outer loop runs n times, inner loop runs n-i
                                                times. Total: n(n-1)/2 ≈ n²/2 = O(n²).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Optimization -->
                                    <h2>Optimization: Early Exit</h2>

                                    <p>If no swaps occur in a pass, the array is already sorted - we can stop early!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/bubble-sort-optimized.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-bubble-opt" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <h4>Optimization Impact</h4>
                                        <ul>
                                            <li><strong>Best case (sorted):</strong> O(n) instead of O(n²)</li>
                                            <li><strong>Average/Worst case:</strong> Still O(n²)</li>
                                            <li><strong>Space:</strong> O(1) - sorts in place</li>
                                        </ul>
                                    </div>

                                    <!-- Complexity Analysis -->
                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Case</th>
                                                <th>Time</th>
                                                <th>When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Best</td>
                                                <td>O(n)</td>
                                                <td>Already sorted (with optimization)</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(n²)</td>
                                                <td>Random order</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n²)</td>
                                                <td>Reverse sorted</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>In-place sorting</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- When to Use -->
                                    <h2>When to Use Bubble Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Use When:</h4>
                                        <ul>
                                            <li>Learning sorting algorithms (simplest to understand)</li>
                                            <li>Array is small (< 100 elements)</li>
                                            <li>Array is nearly sorted</li>
                                            <li>Simplicity matters more than speed</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li>Array is large (O(n²) is too slow)</li>
                                            <li>Performance matters (use Quick Sort or Merge Sort)</li>
                                            <li>In production systems</li>
                                        </ul>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Bubble Sort is the slowest sorting algorithm"</h4>
                                        <p><strong>Reality:</strong> Bubble Sort can be <strong>O(n)</strong> on already
                                            sorted data with optimization!</p>
                                        <ul>
                                            <li>✅ <strong>Best case:</strong> O(n) with early exit flag (sorted data)
                                            </li>
                                            <li>❌ <strong>Worst case:</strong> O(n²) (reverse sorted)</li>
                                            <li><strong>Key:</strong> It's <strong>adaptive</strong> - performance
                                                depends on input!</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Bubble Sort is never useful"</h4>
                                        <p><strong>Reality:</strong> Bubble Sort shines when data is <strong>nearly
                                                sorted</strong>!</p>
                                        <ul>
                                            <li>✅ <strong>Nearly sorted data:</strong> Exits early, runs in ~O(n)</li>
                                            <li>✅ <strong>Small datasets:</strong> Simple and works fine</li>
                                            <li>✅ <strong>Teaching:</strong> Best for understanding sorting concepts
                                            </li>
                                            <li>❌ <strong>Large random data:</strong> Too slow, use Quick/Merge Sort
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Optimization doesn't help much"</h4>
                                        <p><strong>Reality:</strong> The early exit flag makes a <strong>huge</strong>
                                            difference!</p>
                                        <ul>
                                            <li><strong>Without flag:</strong> Always O(n²), even on sorted data</li>
                                            <li><strong>With flag:</strong> O(n) on sorted data - 100x faster for n=100!
                                            </li>
                                            <li><strong>Example:</strong> Sorting 1000 sorted elements: 1000 vs 500,000
                                                comparisons!</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Bubble Sort and Selection Sort are the same"</h4>
                                        <p><strong>Reality:</strong> They have different strengths!</p>
                                        <ul>
                                            <li><strong>Bubble Sort:</strong> Adaptive (O(n) best case), Stable, Many
                                                swaps</li>
                                            <li><strong>Selection Sort:</strong> Not adaptive (always O(n²)), Not
                                                stable, Few swaps</li>
                                            <li><strong>Choose Bubble:</strong> Nearly sorted data or need stability
                                            </li>
                                            <li><strong>Choose Selection:</strong> Expensive swaps (large objects)</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 When to Actually Use Bubble Sort</h4>
                                        <ul>
                                            <li>✅ <strong>Learning:</strong> Simplest sorting algorithm to understand
                                            </li>
                                            <li>✅ <strong>Nearly sorted data:</strong> Can be faster than Quick Sort!
                                            </li>
                                            <li>✅ <strong>Small datasets:</strong> Simplicity wins (< 50 elements)</li>
                                            <li>✅ <strong>Need stability:</strong> Preserves order of equal elements
                                            </li>
                                            <li>❌ <strong>Production with large data:</strong> Use Quick/Merge/Tim Sort
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Bubble Sort Guide</h3>
                                        <ol>
                                            <li><strong>Simple:</strong> Compare neighbors, swap if wrong order</li>
                                            <li><strong>Slow:</strong> O(n²) - not suitable for large arrays</li>
                                            <li><strong>Optimize:</strong> Use flag to exit early if sorted</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Know Bubble Sort
                                            for understanding, but mention better alternatives (Quick Sort, Merge Sort)
                                            for real use!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Bubble Sort is great for learning, but we can do better! Next: <strong>Selection
                                            Sort</strong> - reduces the number of swaps by selecting the minimum element
                                        each time.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try implementing Bubble Sort for descending order, or
                                        count the number of swaps for different inputs!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="string-basics.jsp" />
                                    <jsp:param name="prevTitle" value="String Manipulation" />
                                    <jsp:param name="nextLink" value="selection-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Selection Sort" />
                                    <jsp:param name="currentLessonId" value="bubble-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/core/visualizer-base.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/core/ui-components.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/bubble-sort-viz.js"></script>
        </body>

        </html>