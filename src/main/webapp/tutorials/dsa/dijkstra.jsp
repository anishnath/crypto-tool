<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "dijkstra" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dijkstra's Algorithm - Shortest Path in Weighted Graphs | DSA Tutorial</title>
            <meta name="description" content="Master Dijkstra's algorithm - shortest path in weighted graphs. Learn priority queue optimization, GPS navigation, and network routing.">
            <meta name="keywords" content="Dijkstra, shortest path, weighted graph, priority queue, GPS navigation, algorithm">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/dijkstra.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="dijkstra">
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
                            <span>Dijkstra's Algorithm</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">🛣️ Dijkstra's Algorithm</h1>
                            <div class="lesson-meta">
                                <span>Advanced</span>
                                <span>~35 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">You're planning a road trip. Some routes are longer but faster highways, others are shorter but slower. Dijkstra's algorithm finds the optimal route considering distances, just like GPS navigation finds the best path considering real-world road conditions!</p>

                            <h2>The Weighted Path Problem</h2>
                            <p>BFS finds shortest path in unweighted graphs, but real-world graphs have weights (distances, costs, latencies). Dijkstra's solves this:</p>

                            <div class="info-box">
                                <h4>Real-World Applications</h4>
                                <ul>
                                    <li><strong>GPS Navigation:</strong> Find fastest route considering distances and speeds</li>
                                    <li><strong>Network Routing:</strong> Route packets through least-latency paths</li>
                                    <li><strong>Flight Routes:</strong> Find cheapest flight path</li>
                                    <li><strong>Game Pathfinding:</strong> Navigate characters through weighted terrain</li>
                                    <li><strong>Resource Allocation:</strong> Optimize resource distribution</li>
                                </ul>
                            </div>

                            <h2>How Dijkstra's Works</h2>
                            <div class="success-box">
                                <h4>Greedy Algorithm</h4>
                                <ol>
                                    <li>Start at source vertex (distance = 0)</li>
                                    <li>Maintain distances to all vertices (initialized to ∞)</li>
                                    <li>Use priority queue (min heap) to track closest unvisited vertices</li>
                                    <li>Extract minimum (closest vertex)</li>
                                    <li>Relax edges: Update distances to neighbors</li>
                                    <li>Repeat until all vertices processed</li>
                                </ol>
                                <p><strong>Key insight:</strong> Greedy choice (closest vertex) is always optimal!</p>
                            </div>

                            <h3>See Dijkstra's in Action</h3>
                            <div id="dijkstraVisualization"></div>

                            <h2>Why Priority Queue?</h2>
                            <div class="info-box">
                                <h4>Efficiency Gain</h4>
                                <ul>
                                    <li><strong>Without PQ:</strong> O(V²) - scan all vertices to find minimum</li>
                                    <li><strong>With PQ (heap):</strong> O((V+E) log V) - extract min in O(log V)</li>
                                    <li><strong>Better for sparse graphs:</strong> E << V²</li>
                                </ul>
                            </div>

                            <h2>Important Limitations</h2>
                            <div class="success-box">
                                <h4>Non-Negative Weights Only!</h4>
                                <p>Dijkstra's algorithm <strong>cannot handle negative edge weights</strong>.</p>
                                <p>If negative weights exist, use <strong>Bellman-Ford algorithm</strong> instead.</p>
                                <p><strong>Why?</strong> Greedy choice assumes distances only decrease, but negative edges can decrease distances after a vertex is processed.</p>
                            </div>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/dijkstra.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-dijkstra" />
                            </jsp:include>

                            <h2>Dijkstra vs BFS</h2>
                            <div class="info-box">
                                <h4>Comparison</h4>
                                <table>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>BFS</th>
                                        <th>Dijkstra</th>
                                    </tr>
                                    <tr>
                                        <td><strong>Graph Type</strong></td>
                                        <td>Unweighted</td>
                                        <td>Weighted (non-negative)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Data Structure</strong></td>
                                        <td>Queue</td>
                                        <td>Priority Queue</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Time Complexity</strong></td>
                                        <td>O(V + E)</td>
                                        <td>O((V + E) log V)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Shortest Path</strong></td>
                                        <td>Yes (unweighted)</td>
                                        <td>Yes (weighted)</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Path Reconstruction</h2>
                            <p>Track parent of each vertex during algorithm execution. After completion, reconstruct path by following parents from destination to source.</p>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>Dijkstra's algorithm finds shortest path in weighted graphs:</p>
                                <ol>
                                    <li><strong>Algorithm:</strong> Greedy approach using priority queue</li>
                                    <li><strong>Time:</strong> O((V + E) log V) with heap, O(V²) with array</li>
                                    <li><strong>Space:</strong> O(V)</li>
                                    <li><strong>Limitation:</strong> Only works with non-negative weights</li>
                                    <li><strong>Applications:</strong> GPS navigation, network routing, pathfinding</li>
                                    <li><strong>Key insight:</strong> Greedy choice (closest vertex) is always optimal</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>You've mastered Dijkstra's! Next, we'll explore <strong>Bellman-Ford Algorithm</strong> - which handles negative weights and detects negative cycles, perfect for currency arbitrage and routing protocols!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="topological-sort.jsp" />
                            <jsp:param name="prevTitle" value="Topological Sort" />
                            <jsp:param name="nextLink" value="bellman-ford.jsp" />
                            <jsp:param name="nextTitle" value="Bellman-Ford" />
                            <jsp:param name="currentLessonId" value="dijkstra" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/dijkstra-viz.js"></script>
        </body>
        </html>
