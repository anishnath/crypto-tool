<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-graphs" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Advanced Graph Algorithms - Floyd-Warshall, SCC, Articulation Points | DSA Tutorial</title>
            <meta name="description" content="Master advanced graph algorithms - Floyd-Warshall, strongly connected components, articulation points, and bridges for network analysis.">
            <meta name="keywords" content="Floyd-Warshall, strongly connected components, articulation points, bridges, graph algorithms">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/advanced-graphs.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="advanced-graphs">
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
                            <span>Advanced Graph Algorithms</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">🎯 Advanced Graph Algorithms</h1>
                            <div class="lesson-meta">
                                <span>Advanced</span>
                                <span>~45 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">Network administrators need to identify critical infrastructure - which routers or connections, if removed, would disconnect the network? Advanced graph algorithms help find these vulnerabilities and optimize network design!</p>

                            <h2>Three Advanced Algorithms</h2>
                            <h3>1. Floyd-Warshall Algorithm</h3>
                            <div class="success-box">
                                <h4>All-Pairs Shortest Path</h4>
                                <p>Finds shortest path between <strong>all pairs</strong> of vertices in O(V³) time.</p>
                                <p><strong>Use when:</strong> Need shortest paths between all pairs, not just from one source.</p>
                            </div>

                            <h3>2. Strongly Connected Components (Kosaraju's)</h3>
                            <div class="success-box">
                                <h4>Find Components in Directed Graph</h4>
                                <p>Groups vertices that are mutually reachable using two DFS passes.</p>
                                <p><strong>Use when:</strong> Analyzing dependencies, finding clusters in directed graphs.</p>
                            </div>

                            <h3>3. Articulation Points & Bridges</h3>
                            <div class="success-box">
                                <h4>Find Critical Network Infrastructure</h4>
                                <p><strong>Articulation Points:</strong> Vertices whose removal disconnects graph</p>
                                <p><strong>Bridges:</strong> Edges whose removal disconnects graph</p>
                                <p><strong>Use when:</strong> Network vulnerability analysis, finding critical connections.</p>
                            </div>

                            <h3>See Advanced Algorithms in Action</h3>
                            <div id="advancedGraphsVisualization"></div>

                            <h2>Floyd-Warshall Details</h2>
                            <div class="info-box">
                                <h4>Dynamic Programming Approach</h4>
                                <p>For each intermediate vertex k, update distances: dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])</p>
                                <p><strong>Time:</strong> O(V³) - Slower than Dijkstra for single source, but finds all pairs at once</p>
                                <p><strong>Works with:</strong> Negative weights (but not negative cycles)</p>
                            </div>

                            <h2>Strongly Connected Components</h2>
                            <div class="info-box">
                                <h4>Kosaraju's Two-Pass Algorithm</h4>
                                <ol>
                                    <li>First DFS: Get finish times</li>
                                    <li>Build transpose graph</li>
                                    <li>Second DFS on transpose in reverse finish order</li>
                                </ol>
                                <p><strong>Time:</strong> O(V + E) - Two DFS passes</p>
                            </div>

                            <h2>Articulation Points & Bridges</h2>
                            <div class="info-box">
                                <h4>Using DFS with Discovery/Low Times</h4>
                                <p><strong>Discovery time:</strong> When vertex first visited</p>
                                <p><strong>Low time:</strong> Earliest discovery time reachable</p>
                                <p><strong>Articulation Point:</strong> If low[neighbor] >= disc[vertex] (not root) or root with 2+ children</p>
                                <p><strong>Bridge:</strong> If low[neighbor] > disc[vertex]</p>
                            </div>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/advanced-graphs.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-advanced" />
                            </jsp:include>

                            <h2>Applications</h2>
                            <div class="info-box">
                                <h4>Real-World Uses</h4>
                                <ul>
                                    <li><strong>Floyd-Warshall:</strong> All-pairs routing, transitive closure</li>
                                    <li><strong>SCC:</strong> Dependency analysis, compiler optimizations</li>
                                    <li><strong>Articulation Points:</strong> Network vulnerability, critical infrastructure</li>
                                    <li><strong>Bridges:</strong> Finding critical connections in networks</li>
                                </ul>
                            </div>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>Advanced graph algorithms for complex analysis:</p>
                                <ol>
                                    <li><strong>Floyd-Warshall:</strong> All-pairs shortest path in O(V³)</li>
                                    <li><strong>Kosaraju's:</strong> Find SCCs using two DFS passes</li>
                                    <li><strong>Articulation Points:</strong> Critical vertices using DFS with discovery/low times</li>
                                    <li><strong>Bridges:</strong> Critical edges using same technique</li>
                                    <li><strong>Applications:</strong> Network analysis, vulnerability detection, optimization</li>
                                    <li><strong>Key insight:</strong> DFS with additional tracking reveals graph structure</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>Congratulations! You've completed Module 11: Advanced Graphs! You now understand shortest path algorithms (Dijkstra, Bellman-Ford), minimum spanning trees, and advanced graph analysis. These are fundamental algorithms used throughout computer science and engineering. You're ready to tackle even more complex algorithmic challenges!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="mst.jsp" />
                            <jsp:param name="prevTitle" value="Minimum Spanning Tree" />
                            <jsp:param name="nextLink" value="dp-fundamentals.jsp" />
                            <jsp:param name="nextTitle" value="DP Fundamentals" />
                            <jsp:param name="currentLessonId" value="advanced-graphs" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/advanced-graphs-viz.js"></script>
        </body>
        </html>
