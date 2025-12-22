<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "dp-problems"); request.setAttribute("currentModule", "Dynamic Programming"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DP Problems - 1D, 2D & Knapsack | DSA Tutorial</title>
    <meta name="description" content="Master DP problems: 1D DP (House Robber, Coin Change), 2D DP (LCS, Edit Distance), and Knapsack problems. Learn patterns and solutions.">
    <meta name="keywords" content="dynamic programming, 1D DP, 2D DP, knapsack, house robber, coin change, LCS, edit distance">
    <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/dp-problems.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="dp-problems">
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
                    <span>DP Problems</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">📊 DP Problems: 1D, 2D & Knapsack</h1>
                    <div class="lesson-meta">
                        <span>Intermediate to Advanced</span>
                        <span>~45 min read</span>
                    </div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">Now that you understand DP fundamentals, let's solve real problems! We'll explore 1D DP (single array), 2D DP (matrix/grid), and Knapsack problems - three essential DP patterns used in countless interviews and real-world applications.</p>

                    <h2>Part 1: 1D DP Problems</h2>
                    <p>1D DP uses a single array where <code>dp[i]</code> represents the answer for subproblem ending at index <code>i</code>.</p>

                    <h3>House Robber Problem</h3>
                    <div class="success-box">
                        <h4>Problem</h4>
                        <p>You can't rob adjacent houses. Maximize total money robbed.</p>
                        <p><strong>State:</strong> dp[i] = maximum money robbed up to house i</p>
                        <p><strong>Transition:</strong> dp[i] = max(rob house i, skip house i) = max(dp[i-2] + houses[i], dp[i-1])</p>
                    </div>

                    <h3>Coin Change</h3>
                    <div class="info-box">
                        <h4>Two Variants</h4>
                        <p><strong>Minimum Coins:</strong> Fewest coins to make amount</p>
                        <p><strong>Number of Ways:</strong> Total ways to make amount</p>
                        <p><strong>Key insight:</strong> For each amount, try all coin choices</p>
                    </div>

                    <h3>Other 1D DP Problems</h3>
                    <ul>
                        <li><strong>Decode Ways:</strong> Ways to decode string (A=1, B=2, ..., Z=26)</li>
                        <li><strong>Longest Increasing Subsequence (LIS):</strong> Length of longest increasing subsequence</li>
                        <li><strong>Palindrome Partitioning:</strong> Minimum cuts to partition into palindromes</li>
                    </ul>

                    <h2>The Complete Code: 1D DP</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-1d.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-1d" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Part 2: 2D DP Problems</h2>
                    <p>2D DP uses a matrix where <code>dp[i][j]</code> represents the answer at position (i, j) or for subproblem involving first i elements of sequence 1 and first j elements of sequence 2.</p>

                    <h3>Longest Common Subsequence (LCS)</h3>
                    <div class="success-box">
                        <h4>Problem</h4>
                        <p>Find longest subsequence common to both strings.</p>
                        <p><strong>State:</strong> dp[i][j] = LCS length of text1[0:i] and text2[0:j]</p>
                        <p><strong>Transition:</strong> If match: dp[i][j] = dp[i-1][j-1] + 1, else: dp[i][j] = max(dp[i-1][j], dp[i][j-1])</p>
                    </div>

                    <h3>Edit Distance (Levenshtein)</h3>
                    <div class="info-box">
                        <h4>Problem</h4>
                        <p>Minimum operations (insert, delete, replace) to convert word1 to word2.</p>
                        <p><strong>Application:</strong> Spell checkers, DNA sequence alignment, fuzzy matching</p>
                    </div>

                    <h3>Unique Paths</h3>
                    <p>Robot can move right or down. How many paths from top-left to bottom-right?</p>
                    <p><strong>Transition:</strong> dp[i][j] = dp[i-1][j] + dp[i][j-1]</p>

                    <h2>The Complete Code: 2D DP</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-2d.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-2d" />
                    </jsp:include>

                    <h2>Part 3: Knapsack Problems</h2>
                    <p>Knapsack problems involve selecting items with constraints (weight, value, capacity).</p>

                    <h3>0/1 Knapsack</h3>
                    <div class="success-box">
                        <h4>Problem</h4>
                        <p>Each item can be taken at most once. Maximize value within weight capacity.</p>
                        <p><strong>State:</strong> dp[i][w] = maximum value using first i items with capacity w</p>
                        <p><strong>Transition:</strong> dp[i][w] = max(don't take: dp[i-1][w], take: dp[i-1][w-weight[i]] + value[i])</p>
                    </div>

                    <h3>Unbounded Knapsack</h3>
                    <div class="info-box">
                        <h4>Key Difference</h4>
                        <p>Items can be taken unlimited times. Same as coin change problem!</p>
                        <p><strong>Transition:</strong> dp[w] = max(dp[w-weight[i]] + value[i]) for all items</p>
                    </div>

                    <h3>Subset Sum</h3>
                    <p>Can we form target sum using subset of numbers? Boolean DP problem.</p>

                    <h2>The Complete Code: Knapsack</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/knapsack.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-knapsack" />
                    </jsp:include>

                    <h2>Pattern Summary</h2>
                    <div class="summary-box">
                        <h3>Key Patterns</h3>
                        <ul>
                            <li><strong>1D DP:</strong> dp[i] = answer ending/up to index i. Common: max/min, sum, count</li>
                            <li><strong>2D DP:</strong> dp[i][j] = answer at (i,j) or for sequences up to i and j. Common: paths, matching, optimization</li>
                            <li><strong>Knapsack:</strong> dp[i][w] = best value with capacity w. Common: include/exclude choices</li>
                        </ul>
                    </div>

                    <h2>Complexity Analysis</h2>
                    <table style="width: 100%; margin: 20px 0;">
                        <tr>
                            <th>Problem Type</th>
                            <th>Time</th>
                            <th>Space</th>
                        </tr>
                        <tr>
                            <td>1D DP</td>
                            <td>O(n)</td>
                            <td>O(n) or O(1)</td>
                        </tr>
                        <tr>
                            <td>2D DP</td>
                            <td>O(m × n)</td>
                            <td>O(m × n) or O(n)</td>
                        </tr>
                        <tr>
                            <td>Knapsack</td>
                            <td>O(n × W)</td>
                            <td>O(W)</td>
                        </tr>
                    </table>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <h3>What You've Learned</h3>
                        <ol>
                            <li><strong>1D DP:</strong> Single array, linear problems (House Robber, Coin Change, LIS)</li>
                            <li><strong>2D DP:</strong> Matrix, grid/sequence problems (LCS, Edit Distance, Unique Paths)</li>
                            <li><strong>Knapsack:</strong> Selection with constraints (0/1, Unbounded, Subset Sum)</li>
                            <li><strong>Space Optimization:</strong> Often can reduce from O(n²) to O(n) or O(1)</li>
                            <li><strong>Pattern Recognition:</strong> Learn to identify which DP pattern fits a problem</li>
                        </ol>
                    </div>

                    <h2>What's Next?</h2>
                    <p>You've mastered the core DP patterns! Next, we'll explore <strong>Advanced DP</strong> - DP on strings, trees, bitmask DP, and problem-solving strategies to tackle any DP challenge!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="dp-fundamentals.jsp" />
                    <jsp:param name="prevTitle" value="DP Fundamentals" />
                    <jsp:param name="nextLink" value="dp-advanced.jsp" />
                    <jsp:param name="nextTitle" value="Advanced DP" />
                    <jsp:param name="currentLessonId" value="dp-problems" />
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
