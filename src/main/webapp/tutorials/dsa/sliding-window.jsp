<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "sliding-window" );
        request.setAttribute("currentModule", "Arrays & Strings" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Sliding Window Technique - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master the sliding window technique to find optimal subarrays in O(n) time. Learn fixed and variable window patterns.">
            <meta name="keywords" content="sliding window, subarray, substring, algorithm patterns, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Sliding Window Technique - DSA Tutorial">
            <meta property="og:description"
                content="Find optimal subarrays efficiently with the sliding window pattern.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/sliding-window.jsp">
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
        "name": "Sliding Window Technique",
        "description": "Learn the sliding window pattern for finding optimal subarrays and substrings.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Sliding Window", "Subarray Problems", "Algorithm Patterns"],
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

        <body class="tutorial-body no-preview" data-lesson="sliding-window">
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
                                    <span>Sliding Window</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🪟 Sliding Window Technique</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You need to find the maximum sum of 3 consecutive elements in an
                                        array. The naive approach recalculates the sum for each window - that's
                                        wasteful! Sliding window reuses the previous sum by subtracting the left element
                                        and adding the right. Let's see how.</p>

                                    <!-- Section 1: The Problem -->
                                    <h2>The Problem: Maximum Sum Subarray</h2>

                                    <p>Given an array, find the maximum sum of <code>k</code> consecutive elements.</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <pre><code class="language-plaintext">Array: [2, 1, 5, 1, 3, 2]
k = 3

Windows:
[2, 1, 5] = 8
[1, 5, 1] = 7
[5, 1, 3] = 9  ← Maximum!
[1, 3, 2] = 6</code></pre>
                                        <p><strong>Naive:</strong> Recalculate each sum → O(n×k)</p>
                                        <p><strong>Sliding window:</strong> Reuse previous sum → O(n)</p>
                                    </div>

                                    <!-- Section 2: How It Works -->
                                    <h2>How Sliding Window Works</h2>

                                    <p>Instead of recalculating the entire sum, <strong>slide</strong> the window by
                                        removing the leftmost element and adding the next element.</p>

                                    <div class="success-box">
                                        <h4>The Algorithm (Fixed Window)</h4>
                                        <ol>
                                            <li>Calculate sum of first <code>k</code> elements</li>
                                            <li>For each new element:
                                                <ul>
                                                    <li>Subtract the element leaving the window</li>
                                                    <li>Add the element entering the window</li>
                                                </ul>
                                            </li>
                                            <li>Track the maximum sum</li>
                                        </ol>
                                        <pre><code class="language-python">window_sum = window_sum - arr[i-k] + arr[i]</code></pre>
                                    </div>

                                    <!-- Code Example -->
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/sliding-window-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-sliding-window" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why it's faster:</strong>
                                        <ul>
                                            <li>Naive: Recalculate k elements for each window → O(n×k)</li>
                                            <li>Sliding: Just 2 operations per window → O(n)</li>
                                            <li>For k=100, n=1000: 100,000 ops vs 2,000 ops!</li>
                                        </ul>
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is it called "sliding" window?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Because the window "slides" one position at a time, removing the left
                                                element and adding the right element - like sliding a physical window
                                                frame!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>What's the space complexity?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                O(1) - we only store the current window sum and max, regardless of array
                                                size!
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Patterns -->
                                    <h2>Two Types of Windows</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/sliding-window-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Window Size</th>
                                                <th>When to Use</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Fixed Window</strong></td>
                                                <td>Constant (k)</td>
                                                <td>Find optimal k-sized subarray</td>
                                                <td>Max sum of k elements</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Variable Window</strong></td>
                                                <td>Grows/shrinks</td>
                                                <td>Find optimal size based on condition</td>
                                                <td>Longest substring with k distinct chars</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- When to Use -->
                                    <h2>When to Use Sliding Window</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Sliding Window When:</h4>
                                        <ul>
                                            <li>Finding optimal <strong>contiguous</strong> subarray/substring</li>
                                            <li>Problem asks for "maximum/minimum of k elements"</li>
                                            <li>Problem asks for "longest/shortest substring with condition"</li>
                                            <li>Elements must be consecutive (no gaps)</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Don't Use When:</h4>
                                        <ul>
                                            <li>Elements don't need to be contiguous</li>
                                            <li>Need to find pairs/triplets (use two pointers)</li>
                                            <li>Need all subarrays (not just optimal one)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Forgetting to Initialize Window</h4>
                                        <pre><code class="language-python"># Wrong: Starting from index k
for i in range(k, len(arr)):
    window_sum = window_sum - arr[i-k] + arr[i]
# window_sum is undefined!

# Right: Calculate first window
window_sum = sum(arr[:k])
for i in range(k, len(arr)):
    window_sum = window_sum - arr[i-k] + arr[i]</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Wrong Index for Removal</h4>
                                        <pre><code class="language-python"># Wrong
window_sum = window_sum - arr[i] + arr[i+k]

# Right: Remove element k positions back
window_sum = window_sum - arr[i-k] + arr[i]</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Sliding Window Guide</h3>
                                        <ol>
                                            <li><strong>Pattern:</strong> Reuse previous calculation by sliding the
                                                window</li>
                                            <li><strong>Complexity:</strong> O(n) time, O(1) space - much better than
                                                O(n×k)</li>
                                            <li><strong>Types:</strong> Fixed size (constant k) or variable size
                                                (dynamic)</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> When you see
                                            "contiguous subarray" or "substring", think sliding window!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered array techniques! Next: <strong>String Manipulation</strong> -
                                        learn string operations, pattern matching, and how to apply sliding window to
                                        string problems.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try "Longest Substring Without Repeating Characters"
                                        - it combines sliding window with a hash map!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="two-pointers.jsp" />
                                    <jsp:param name="prevTitle" value="Two Pointers" />
                                    <jsp:param name="nextLink" value="string-basics.jsp" />
                                    <jsp:param name="nextTitle" value="String Manipulation" />
                                    <jsp:param name="currentLessonId" value="sliding-window" />
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