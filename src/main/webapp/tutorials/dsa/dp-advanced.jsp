<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "dp-advanced"); request.setAttribute("currentModule", "Dynamic Programming"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced DP - Strings, Trees, Bitmask & Problem-Solving | DSA Tutorial</title>
    <meta name="description" content="Master advanced DP: String DP (palindromes, word break), Tree DP (max path sum, diameter), Bitmask DP (TSP), and problem-solving strategies.">
    <meta name="keywords" content="advanced DP, string DP, tree DP, bitmask DP, TSP, palindrome, word break, dynamic programming">
    <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/dp-advanced.jsp">
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
<body class="tutorial-body no-preview" data-lesson="dp-advanced">
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
                    <span>Advanced DP</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">🚀 Advanced DP</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~50 min read</span>
                    </div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">You've mastered the core DP patterns! Now let's tackle advanced topics: DP on strings (palindromes, word matching), DP on trees (path optimization), bitmask DP (TSP), and most importantly - how to recognize and solve any DP problem!</p>

                    <h2>Part 1: DP on Strings</h2>
                    <p>String DP problems often use 2D tables where <code>dp[i][j]</code> represents the answer for substring <code>s[i:j]</code> or sequences involving positions i and j.</p>

                    <h3>Longest Palindromic Subsequence (LPS)</h3>
                    <div class="success-box">
                        <h4>Problem</h4>
                        <p>Find longest subsequence that is a palindrome.</p>
                        <p><strong>State:</strong> dp[i][j] = LPS length of s[i:j+1]</p>
                        <p><strong>Transition:</strong> If s[i]==s[j]: dp[i][j] = dp[i+1][j-1] + 2, else: dp[i][j] = max(dp[i+1][j], dp[i][j-1])</p>
                    </div>

                    <h3>Word Break</h3>
                    <div class="info-box">
                        <h4>Problem</h4>
                        <p>Can string be segmented into dictionary words?</p>
                        <p><strong>State:</strong> dp[i] = can s[0:i] be segmented?</p>
                        <p><strong>Application:</strong> Text processing, spell checkers, natural language processing</p>
                    </div>

                    <h3>Other String DP Problems</h3>
                    <ul>
                        <li><strong>Edit Distance:</strong> Minimum operations to transform strings</li>
                        <li><strong>Distinct Subsequences:</strong> Count how many times pattern appears in text</li>
                        <li><strong>Regular Expression Matching:</strong> Match pattern with '.' and '*'</li>
                    </ul>

                    <h2>The Complete Code: DP on Strings</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-strings.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-strings" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Part 2: DP on Trees</h2>
                    <p>Tree DP uses post-order DFS where we process children first, then compute current node's value based on children.</p>

                    <h3>Maximum Path Sum</h3>
                    <div class="success-box">
                        <h4>Problem</h4>
                        <p>Find maximum sum path in binary tree (any node to any node).</p>
                        <p><strong>Key Insight:</strong> For each node, compute max path through it and max path extending upward</p>
                        <p><strong>Return value:</strong> Max path from node downward (can extend to parent)</p>
                        <p><strong>Global max:</strong> Track max path sum across all nodes</p>
                    </div>

                    <h3>Diameter of Binary Tree</h3>
                    <div class="info-box">
                        <h4>Problem</h4>
                        <p>Longest path between any two nodes (number of edges).</p>
                        <p><strong>Approach:</strong> For each node, diameter = left_depth + right_depth</p>
                        <p><strong>Return value:</strong> Max depth from node</p>
                    </div>

                    <h3>House Robber III</h3>
                    <p>Rob houses arranged in tree. Can't rob connected nodes. Returns [rob_this_node, skip_this_node] state.</p>

                    <h2>The Complete Code: DP on Trees</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-trees.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-trees" />
                    </jsp:include>

                    <h2>Part 3: Advanced DP Patterns</h2>
                    <p>Advanced patterns use clever state compression and optimization techniques.</p>

                    <h3>Bitmask DP</h3>
                    <div class="success-box">
                        <h4>Traveling Salesman Problem (TSP)</h4>
                        <p>Visit all cities exactly once with minimum cost. Uses bitmask to represent visited cities.</p>
                        <p><strong>State:</strong> dp[mask][last] = min cost to visit cities in mask, ending at last</p>
                        <p><strong>Application:</strong> Route optimization, task scheduling, assignment problems</p>
                        <p><strong>Complexity:</strong> O(2^n × n²) - exponential but efficient for n ≤ 20</p>
                    </div>

                    <h3>Digit DP</h3>
                    <div class="info-box">
                        <h4>Problem</h4>
                        <p>Count numbers with constraints (e.g., no consecutive digits, sum constraints).</p>
                        <p><strong>Approach:</strong> Process digits one by one, track state (tight bound, previous digit, etc.)</p>
                    </div>

                    <h3>State Compression</h3>
                    <p>Reduce state space using clever encoding. Common in optimization problems.</p>

                    <h2>The Complete Code: Advanced DP Patterns</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-advanced.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-advanced" />
                    </jsp:include>

                    <h2>Part 4: DP Problem-Solving Strategy</h2>
                    <p>Learn how to recognize DP problems and develop a systematic approach to solve them.</p>

                    <h3>How to Recognize DP Problems</h3>
                    <div class="success-box">
                        <h4>Key Indicators</h4>
                        <ol>
                            <li><strong>Optimization Problem:</strong> Min, max, count possibilities</li>
                            <li><strong>Overlapping Subproblems:</strong> Same problem solved multiple times</li>
                            <li><strong>Optimal Substructure:</strong> Optimal solution contains optimal subproblems</li>
                            <li><strong>Can Break into Subproblems:</strong> Problem naturally divides</li>
                        </ol>
                    </div>

                    <h3>DP Problem-Solving Steps</h3>
                    <div class="info-box">
                        <h4>Systematic Approach</h4>
                        <ol>
                            <li><strong>Understand:</strong> Read problem carefully, identify what to optimize</li>
                            <li><strong>Identify Subproblems:</strong> What are smaller versions?</li>
                            <li><strong>Define State:</strong> What does dp[i] or dp[i][j] represent?</li>
                            <li><strong>Find Recurrence:</strong> How to compute dp[i] from previous states?</li>
                            <li><strong>Set Base Cases:</strong> Smallest subproblems (no dependencies)</li>
                            <li><strong>Choose Implementation:</strong> Memoization (top-down) or Tabulation (bottom-up)</li>
                            <li><strong>Optimize Space:</strong> Can we reduce space complexity?</li>
                        </ol>
                    </div>

                    <h3>Common DP Patterns</h3>
                    <table style="width: 100%; margin: 20px 0;">
                        <tr>
                            <th>Pattern</th>
                            <th>State</th>
                            <th>Transition</th>
                            <th>Examples</th>
                        </tr>
                        <tr>
                            <td>Linear</td>
                            <td>dp[i]</td>
                            <td>dp[i] = f(dp[i-1], dp[i-2])</td>
                            <td>Fibonacci, Climbing Stairs</td>
                        </tr>
                        <tr>
                            <td>Grid</td>
                            <td>dp[i][j]</td>
                            <td>dp[i][j] = f(dp[i-1][j], dp[i][j-1])</td>
                            <td>Unique Paths, Min Path Sum</td>
                        </tr>
                        <tr>
                            <td>Subsequence</td>
                            <td>dp[i][j]</td>
                            <td>Match or skip pattern</td>
                            <td>LCS, LIS</td>
                        </tr>
                        <tr>
                            <td>Knapsack</td>
                            <td>dp[i][w]</td>
                            <td>Include or exclude</td>
                            <td>0/1 Knapsack, Coin Change</td>
                        </tr>
                        <tr>
                            <td>Tree</td>
                            <td>Return value</td>
                            <td>Post-order DFS</td>
                            <td>Max Path Sum, Diameter</td>
                        </tr>
                        <tr>
                            <td>Bitmask</td>
                            <td>dp[mask]</td>
                            <td>Extend mask</td>
                            <td>TSP, Assignment</td>
                        </tr>
                    </table>

                    <h2>The Complete Code: DP Problem-Solving</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="dsa/dp-problem-solving.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dp-problem-solving" />
                    </jsp:include>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <h3>What You've Learned</h3>
                        <ol>
                            <li><strong>String DP:</strong> 2D table for substrings, common in text processing</li>
                            <li><strong>Tree DP:</strong> Post-order DFS, return values from children</li>
                            <li><strong>Bitmask DP:</strong> Use integers as sets, efficient for small n</li>
                            <li><strong>Problem-Solving:</strong> Systematic approach to recognize and solve DP problems</li>
                            <li><strong>Pattern Recognition:</strong> Identify which DP pattern fits a problem</li>
                            <li><strong>Space Optimization:</strong> Often can reduce space complexity significantly</li>
                        </ol>
                    </div>

                    <h2>Congratulations! 🎉</h2>
                    <div class="success-box">
                        <h4>You've Completed Dynamic Programming!</h4>
                        <p>You now understand:</p>
                        <ul>
                            <li>✅ DP fundamentals (memoization vs tabulation)</li>
                            <li>✅ 1D, 2D, and Knapsack DP problems</li>
                            <li>✅ Advanced DP on strings and trees</li>
                            <li>✅ Bitmask DP and state compression</li>
                            <li>✅ Systematic problem-solving approach</li>
                        </ul>
                        <p><strong>This completes the Dynamic Programming module and brings you closer to mastering all DSA topics!</strong></p>
                    </div>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="dp-problems.jsp" />
                    <jsp:param name="prevTitle" value="DP Problems" />
                    <jsp:param name="nextLink" value="../index.jsp" />
                    <jsp:param name="nextTitle" value="DSA Home" />
                    <jsp:param name="currentLessonId" value="dp-advanced" />
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
