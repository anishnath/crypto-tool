<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "two-pointers" ); request.setAttribute("currentModule", "Arrays & Strings"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Two Pointers Technique - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master the two pointers technique to solve array problems in O(n) instead of O(n²). Learn patterns for interviews.">
            <meta name="keywords" content="two pointers, array techniques, two sum, DSA, algorithm patterns">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Two Pointers Technique - DSA Tutorial">
            <meta property="og:description" content="Solve array problems efficiently with the two pointers pattern.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/two-pointers.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/two-pointers-viz.css">

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
        "name": "Two Pointers Technique",
        "description": "Learn the two pointers pattern to solve array problems efficiently.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["Two Pointers", "Array Techniques", "Algorithm Patterns", "Two Sum"],
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

        <body class="tutorial-body no-preview" data-lesson="two-pointers">
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
                                    <span>Two Pointers</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">👉👈 Two Pointers Technique</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner to Intermediate</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You need to find two numbers in a sorted array that sum to a target.
                                        The naive approach checks every pair - that's 4,950 comparisons for 100 numbers!
                                        The two pointers technique does it in just 100 steps. Let's see how.</p>

                                    <!-- Section 1: The Problem -->
                                    <h2>The Problem: Two Sum</h2>

                                    <p>Given a <strong>sorted</strong> array, find two numbers that add up to a target
                                        value.</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <pre><code class="language-plaintext">Array:  [1, 2, 3, 4, 6, 8, 9]
Target: 10
Answer: indices 2 and 5 (3 + 7 doesn't exist, but 4 + 6 = 10)</code></pre>
                                        <p><strong>Naive approach:</strong> Check every pair → O(n²)</p>
                                        <p><strong>Two pointers:</strong> Work from both ends → O(n)</p>
                                    </div>

                                    <!-- Section 2: How It Works -->
                                    <h2>How Two Pointers Works</h2>

                                    <p>The key insight: In a <strong>sorted array</strong>, you can eliminate half the
                                        search space with each comparison.</p>

                                    <div class="success-box">
                                        <h4>The Algorithm</h4>
                                        <ol>
                                            <li>Start with <code>left = 0</code>, <code>right = n-1</code></li>
                                            <li>Calculate <code>sum = arr[left] + arr[right]</code></li>
                                            <li>If <code>sum == target</code>: Found it! ✅</li>
                                            <li>If <code>sum < target</code>: Move <code>left++</code> (need larger sum)
                                            </li>
                                            <li>If <code>sum > target</code>: Move <code>right--</code> (need smaller
                                                sum)</li>
                                            <li>Repeat until <code>left >= right</code></li>
                                        </ol>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>

                                    <div id="twoPointersViz"></div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/two-pointers-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-two-pointers" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why it works:</strong>
                                        <ul>
                                            <li>If sum is too small, the only way to increase it is to move left pointer
                                                right</li>
                                            <li>If sum is too large, the only way to decrease it is to move right
                                                pointer left</li>
                                            <li>This eliminates one element per step → O(n) time!</li>
                                        </ul>
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why does this only work on sorted arrays?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Because we rely on the fact that moving left increases the sum and
                                                moving right decreases it. This only holds if the array is sorted!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>What if the array isn't sorted?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Sort it first! Sorting is O(n log n), but that's still better than O(n²)
                                                for checking all pairs.
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Common Patterns -->
                                    <h2>Three Common Patterns</h2>

                                    <p>Two pointers isn't just for two sum. Here are the main patterns:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/two-pointers-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>When to Use</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Opposite Ends</strong></td>
                                                <td>Sorted array, find pairs/triplets</td>
                                                <td>Two sum, three sum</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Same Direction</strong></td>
                                                <td>In-place modifications</td>
                                                <td>Remove duplicates, partition</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Sliding Window</strong></td>
                                                <td>Subarrays of fixed/variable size</td>
                                                <td>Max sum subarray, longest substring</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- When to Use -->
                                    <h2>When to Use Two Pointers</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Two Pointers When:</h4>
                                        <ul>
                                            <li>Array is sorted (or can be sorted)</li>
                                            <li>Need to find pairs/triplets that satisfy a condition</li>
                                            <li>Removing duplicates in-place</li>
                                            <li>Reversing or checking palindromes</li>
                                            <li>Partitioning arrays</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Don't Use When:</h4>
                                        <ul>
                                            <li>Array can't be sorted (order matters)</li>
                                            <li>Need to preserve original indices</li>
                                            <li>Looking for single elements (use binary search instead)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Forgetting to Sort</h4>
                                        <pre><code class="language-python">arr = [3, 1, 4, 2]  # Not sorted!
two_sum(arr, 5)  # Won't work correctly</code></pre>
                                        <p><strong>Fix:</strong> <code>arr.sort()</code> first</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Wrong Pointer Movement</h4>
                                        <pre><code class="language-python">if sum < target:
    right -= 1  # Wrong! Should be left += 1</code></pre>
                                        <p><strong>Remember:</strong> Too small → move left. Too large → move right.</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Two Pointers Guide</h3>
                                        <ol>
                                            <li><strong>Pattern:</strong> Start from both ends, move based on comparison
                                            </li>
                                            <li><strong>Complexity:</strong> O(n) time, O(1) space - much better than
                                                O(n²)</li>
                                            <li><strong>Requirement:</strong> Array must be sorted (or sortable)</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> When you see
                                            "sorted array" and "find pair", think two pointers!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered two pointers! Next up: <strong>Sliding Window</strong> - a
                                        variation of two pointers for finding optimal subarrays. It's one of the most
                                        powerful patterns for string and array problems.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try solving "3Sum" (find three numbers that sum to
                                        target) using two pointers. Hint: Fix one number, then use two pointers on the
                                        rest!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="array-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Array Fundamentals" />
                                    <jsp:param name="nextLink" value="sliding-window.jsp" />
                                    <jsp:param name="nextTitle" value="Sliding Window" />
                                    <jsp:param name="currentLessonId" value="two-pointers" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/visualizations/two-pointers-viz.js"></script>
        </body>

        </html>