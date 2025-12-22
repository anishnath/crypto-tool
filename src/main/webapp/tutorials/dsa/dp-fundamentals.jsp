<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "dp-fundamentals"); request.setAttribute("currentModule", "Dynamic Programming"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DP Fundamentals - Memoization vs Tabulation | DSA Tutorial</title>
    <meta name="description" content="Master Dynamic Programming fundamentals. Learn memoization vs tabulation, Fibonacci, climbing stairs, and when to use each approach.">
    <meta name="keywords" content="dynamic programming, memoization, tabulation, fibonacci, DP, algorithm">
    <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/dp-fundamentals.jsp">
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
<body class="tutorial-body no-preview" data-lesson="dp-fundamentals">
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
                    <span>DP Fundamentals</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">🎓 DP Fundamentals</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">You're calculating Fibonacci numbers. The naive recursive approach recalculates the same values over and over. Dynamic Programming remembers previous results, making it incredibly efficient! This is the power of DP - solving problems by remembering answers to subproblems.</p>

                    <h2>What is Dynamic Programming?</h2>
                    <div class="success-box">
                        <h4>Dynamic Programming Definition</h4>
                        <p><strong>Dynamic Programming (DP)</strong> is an optimization technique that solves complex problems by:</p>
                        <ul>
                            <li>Breaking them into smaller subproblems</li>
                            <li>Solving each subproblem only once</li>
                            <li>Storing results to avoid recomputation</li>
                        </ul>
                        <p><strong>Key properties:</strong></p>
                        <ul>
                            <li>✅ <strong>Overlapping Subproblems:</strong> Same subproblem solved multiple times</li>
                            <li>✅ <strong>Optimal Substructure:</strong> Optimal solution contains optimal subproblem solutions</li>
                        </ul>
                    </div>

                    <h2>Two Approaches: Memoization vs Tabulation</h2>
                    <p>DP can be implemented two ways:</p>

                    <div class="info-box">
                        <h4>Memoization (Top-Down)</h4>
                        <ul>
                            <li>Recursive approach with caching</li>
                            <li>Think: "How do I solve this using subproblems?"</li>
                            <li>Only solves needed subproblems</li>
                            <li>Uses recursion stack</li>
                        </ul>
                    </div>

                    <div class="info-box">
                        <h4>Tabulation (Bottom-Up)</h4>
                        <ul>
                            <li>Iterative approach building from base cases</li>
                            <li>Think: "Build from smallest to largest"</li>
                            <li>Solves all subproblems</li>
                            <li>No recursion (more control)</li>
                        </ul>
                    </div>

                    <h3>See the Comparison</h3>
                    <div id="dpFundamentalsVisualization"></div>

                    <h2>Classic Example: Fibonacci</h2>
                    <p>Fibonacci is the perfect DP example - it has overlapping subproblems!</p>

                    <div class="success-box">
                        <h4>Fibonacci Problem</h4>
                        <p><strong>Recurrence:</strong> F(n) = F(n-1) + F(n-2)</p>
                        <p><strong>Base cases:</strong> F(0) = 0, F(1) = 1</p>
                        <p><strong>Naive recursion:</strong> O(2^n) - recalculates same values!</p>
                        <p><strong>DP solution:</strong> O(n) - each value calculated once</p>
                    </div>

                    <h2>The Complete Code</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-fundamentals.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-fundamentals" />
                    </jsp:include>

                    <h2>Climbing Stairs Problem</h2>
                    <p>Climbing stairs is essentially Fibonacci in disguise!</p>

                    <div class="info-box">
                        <h4>Problem</h4>
                        <p>You can climb 1 or 2 steps at a time. How many ways to reach step n?</p>
                        <p><strong>Solution:</strong> dp[i] = ways to reach step i</p>
                        <p><strong>Recurrence:</strong> dp[i] = dp[i-1] + dp[i-2] (same as Fibonacci!)</p>
                    </div>

                    <h2>When to Use Each Approach</h2>
                    <div class="info-box">
                        <h4>Use Memoization When:</h4>
                        <ul>
                            <li>Natural recursive thinking fits the problem</li>
                            <li>Not all subproblems need to be solved</li>
                            <li>Recursion depth is acceptable</li>
                        </ul>
                        <h4>Use Tabulation When:</h4>
                        <ul>
                            <li>Need to avoid recursion stack overflow</li>
                            <li>Want more control over computation order</li>
                            <li>All subproblems will be needed anyway</li>
                        </ul>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Key DP Insights</h2>
                    <div class="success-box">
                        <h4>DP Problem-Solving Checklist</h4>
                        <ol>
                            <li><strong>Recognize overlapping subproblems</strong> - Are you solving same thing multiple times?</li>
                            <li><strong>Define state</strong> - What does dp[i] or dp[i][j] represent?</li>
                            <li><strong>Find recurrence</strong> - How to compute dp[i] from previous states?</li>
                            <li><strong>Set base cases</strong> - What are the smallest subproblems?</li>
                            <li><strong>Choose approach</strong> - Memoization or tabulation?</li>
                        </ol>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <h3>What You've Learned</h3>
                        <ol>
                            <li><strong>DP Definition:</strong> Optimization by solving subproblems once</li>
                            <li><strong>Two Approaches:</strong> Memoization (top-down) and Tabulation (bottom-up)</li>
                            <li><strong>Key Properties:</strong> Overlapping subproblems + Optimal substructure</li>
                            <li><strong>Fibonacci:</strong> Classic DP example - O(2^n) → O(n)</li>
                            <li><strong>Climbing Stairs:</strong> Fibonacci in disguise</li>
                            <li><strong>Both approaches:</strong> Same time complexity, different style</li>
                        </ol>
                    </div>

                    <h2>What's Next?</h2>
                    <p>You've learned the fundamentals! Next, we'll explore <strong>1D DP Problems</strong> - House Robber, Coin Change, and other single-array dynamic programming challenges!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="advanced-graphs.jsp" />
                    <jsp:param name="prevTitle" value="Advanced Graphs" />
                    <jsp:param name="nextLink" value="dp-problems.jsp" />
                    <jsp:param name="nextTitle" value="DP Problems" />
                    <jsp:param name="currentLessonId" value="dp-fundamentals" />
                </jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
    <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/dp-fundamentals-viz.js"></script>
</body>
</html>
