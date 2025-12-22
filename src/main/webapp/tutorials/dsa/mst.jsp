<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "mst" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Minimum Spanning Tree - Kruskal & Prim Algorithms | DSA Tutorial</title>
            <meta name="description" content="Master MST algorithms - Kruskal's and Prim's. Learn Union-Find data structure, network design, and cluster analysis.">
            <meta name="keywords" content="MST, minimum spanning tree, Kruskal, Prim, Union-Find, network design">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/mst.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="mst">
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
                            <span>Minimum Spanning Tree</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">🌳 Minimum Spanning Tree (MST)</h1>
                            <div class="lesson-meta">
                                <span>Advanced</span>
                                <span>~40 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">You need to connect all cities with cable networks. Some connections are expensive, others cheap. What's the minimum cost to connect all cities? Minimum Spanning Tree finds the optimal network design!</p>

                            <h2>The Connectivity Problem</h2>
                            <p>Given a weighted graph, find a tree that connects all vertices with minimum total edge weight:</p>

                            <div class="info-box">
                                <h4>Real-World Applications</h4>
                                <ul>
                                    <li><strong>Network Design:</strong> Connect all nodes with minimum cable cost</li>
                                    <li><strong>Cluster Analysis:</strong> Group similar data points</li>
                                    <li><strong>Approximation Algorithms:</strong> TSP approximation</li>
                                    <li><strong>Image Segmentation:</strong> Connect similar pixels</li>
                                    <li><strong>Circuit Design:</strong> Minimize wire connections</li>
                                </ul>
                            </div>

                            <h2>Two Algorithms for MST</h2>
                            <h3>1. Kruskal's Algorithm</h3>
                            <div class="success-box">
                                <h4>Edge-Based Greedy</h4>
                                <ol>
                                    <li>Sort all edges by weight</li>
                                    <li>Add smallest edge that doesn't create cycle</li>
                                    <li>Use Union-Find to detect cycles</li>
                                    <li>Repeat until V-1 edges added</li>
                                </ol>
                                <p><strong>Time:</strong> O(E log E) - Best for sparse graphs</p>
                            </div>

                            <h3>2. Prim's Algorithm</h3>
                            <div class="success-box">
                                <h4>Vertex-Based Greedy</h4>
                                <ol>
                                    <li>Start from any vertex</li>
                                    <li>Add minimum edge from MST to non-MST vertex</li>
                                    <li>Use priority queue to find minimum edge</li>
                                    <li>Repeat until all vertices in MST</li>
                                </ol>
                                <p><strong>Time:</strong> O(E log V) - Best for dense graphs</p>
                            </div>

                            <h3>See MST Algorithms in Action</h3>
                            <div id="mstVisualization"></div>

                            <h2>Union-Find Data Structure</h2>
                            <div class="info-box">
                                <h4>Used in Kruskal's</h4>
                                <ul>
                                    <li><strong>Find(x):</strong> Find root with path compression</li>
                                    <li><strong>Union(x, y):</strong> Merge sets using union by rank</li>
                                    <li><strong>Cycle Detection:</strong> If Find(u) == Find(v), edge creates cycle!</li>
                                    <li><strong>Time:</strong> O(α(V)) amortized - Nearly constant!</li>
                                </ul>
                            </div>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/mst.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-mst" />
                            </jsp:include>

                            <h2>Kruskal vs Prim</h2>
                            <div class="info-box">
                                <h4>When to Use Each</h4>
                                <table>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>Kruskal</th>
                                        <th>Prim</th>
                                    </tr>
                                    <tr>
                                        <td><strong>Approach</strong></td>
                                        <td>Edge-based</td>
                                        <td>Vertex-based</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Time (Sparse)</strong></td>
                                        <td>O(E log E)</td>
                                        <td>O(E log V)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Time (Dense)</strong></td>
                                        <td>O(E log E)</td>
                                        <td>O(V²)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Best For</strong></td>
                                        <td>Sparse graphs</td>
                                        <td>Dense graphs</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>MST connects all vertices with minimum total weight:</p>
                                <ol>
                                    <li><strong>Kruskal:</strong> Sort edges, add smallest (no cycle) - O(E log E)</li>
                                    <li><strong>Prim:</strong> Start from vertex, add minimum edge - O(E log V)</li>
                                    <li><strong>Union-Find:</strong> Efficient cycle detection in Kruskal's</li>
                                    <li><strong>Both are greedy:</strong> Optimal solution guaranteed</li>
                                    <li><strong>Applications:</strong> Network design, cluster analysis</li>
                                    <li><strong>Key insight:</strong> Greedy choice (minimum edge) is always in MST</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>You've mastered MST! Next, we'll explore <strong>Advanced Graph Algorithms</strong> - Floyd-Warshall for all-pairs shortest path, strongly connected components, and finding critical network infrastructure!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="bellman-ford.jsp" />
                            <jsp:param name="prevTitle" value="Bellman-Ford" />
                            <jsp:param name="nextLink" value="advanced-graphs.jsp" />
                            <jsp:param name="nextTitle" value="Advanced Graphs" />
                            <jsp:param name="currentLessonId" value="mst" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/mst-viz.js"></script>
        </body>
        </html>
