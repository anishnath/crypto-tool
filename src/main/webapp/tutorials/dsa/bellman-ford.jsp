<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "bellman-ford" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Bellman-Ford Algorithm - Negative Weights & Cycle Detection | DSA Tutorial</title>
            <meta name="description" content="Master Bellman-Ford algorithm - shortest path with negative weights and negative cycle detection. Learn currency arbitrage and routing protocols.">
            <meta name="keywords" content="Bellman-Ford, negative weights, cycle detection, shortest path, currency arbitrage">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/bellman-ford.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="bellman-ford">
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
                            <span>Bellman-Ford Algorithm</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">⚖️ Bellman-Ford Algorithm</h1>
                            <div class="lesson-meta">
                                <span>Advanced</span>
                                <span>~35 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">Currency exchange rates can create arbitrage opportunities - if you can exchange currencies in a cycle and end up with more money than you started! Bellman-Ford algorithm detects such opportunities by finding negative cycles in graphs with negative weights.</p>

                            <h2>The Negative Weight Problem</h2>
                            <p>Dijkstra's fails with negative weights. Bellman-Ford handles them:</p>

                            <div class="info-box">
                                <h4>Real-World Applications</h4>
                                <ul>
                                    <li><strong>Currency Arbitrage:</strong> Detect profitable currency exchange cycles</li>
                                    <li><strong>Routing Protocols:</strong> Handle negative costs (rebates, discounts)</li>
                                    <li><strong>Negative Cycle Detection:</strong> Identify impossible/contradictory constraints</li>
                                    <li><strong>Network Protocols:</strong> Distance-vector routing (RIP, BGP)</li>
                                </ul>
                            </div>

                            <h2>How Bellman-Ford Works</h2>
                            <div class="success-box">
                                <h4>Relaxation Process</h4>
                                <ol>
                                    <li>Initialize distances (start = 0, others = ∞)</li>
                                    <li>Relax all edges V-1 times</li>
                                    <li>After V-1 iterations, distances should be optimal</li>
                                    <li>One more relaxation: If any edge can still be relaxed, negative cycle exists!</li>
                                </ol>
                                <p><strong>Key insight:</strong> After V-1 iterations, if we can still relax, there's a negative cycle!</p>
                            </div>

                            <h3>See Bellman-Ford in Action</h3>
                            <div id="bellmanFordVisualization"></div>

                            <h2>Negative Cycle Detection</h2>
                            <div class="info-box">
                                <h4>Why V-1 Iterations?</h4>
                                <p>In a graph with V vertices, shortest path has at most V-1 edges. After V-1 relaxations, all shortest paths should be found.</p>
                                <p>If we can still relax after V-1 iterations, it means there's a cycle with negative total weight!</p>
                            </div>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/bellman-ford.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-bellman" />
                            </jsp:include>

                            <h2>Dijkstra vs Bellman-Ford</h2>
                            <div class="info-box">
                                <h4>When to Use Each</h4>
                                <table>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>Dijkstra</th>
                                        <th>Bellman-Ford</th>
                                    </tr>
                                    <tr>
                                        <td><strong>Time Complexity</strong></td>
                                        <td>O((V+E) log V)</td>
                                        <td>O(VE)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Negative Weights</strong></td>
                                        <td>No</td>
                                        <td>Yes</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Negative Cycles</strong></td>
                                        <td>Cannot detect</td>
                                        <td>Can detect</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Best For</strong></td>
                                        <td>Non-negative weights</td>
                                        <td>Any weights, need cycle detection</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Currency Arbitrage Example</h2>
                            <p>Convert exchange rates to graph: if you can exchange currencies in a cycle and end up with more money, there's a negative cycle (profitable arbitrage)!</p>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>Bellman-Ford algorithm handles negative weights:</p>
                                <ol>
                                    <li><strong>Algorithm:</strong> Relax edges V-1 times, then check for cycles</li>
                                    <li><strong>Time:</strong> O(VE) - Slower than Dijkstra</li>
                                    <li><strong>Space:</strong> O(V)</li>
                                    <li><strong>Advantage:</strong> Handles negative weights and detects negative cycles</li>
                                    <li><strong>Applications:</strong> Currency arbitrage, routing protocols</li>
                                    <li><strong>Key insight:</strong> If edges can still be relaxed after V-1 iterations, negative cycle exists</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>You've mastered Bellman-Ford! Next, we'll explore <strong>Minimum Spanning Tree (MST)</strong> - connecting all vertices with minimum total edge weight, perfect for network design and cluster analysis!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="dijkstra.jsp" />
                            <jsp:param name="prevTitle" value="Dijkstra's Algorithm" />
                            <jsp:param name="nextLink" value="mst.jsp" />
                            <jsp:param name="nextTitle" value="Minimum Spanning Tree" />
                            <jsp:param name="currentLessonId" value="bellman-ford" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/bellman-ford-viz.js"></script>
        </body>
        </html>
