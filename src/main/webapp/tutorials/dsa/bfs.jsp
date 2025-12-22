<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "bfs" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>BFS (Breadth-First Search) - Level-wise Traversal | DSA Tutorial</title>
            <meta name="description" content="Master BFS - level-wise graph traversal algorithm. Learn shortest path in unweighted graphs, web crawling, and GPS navigation.">
            <meta name="keywords" content="BFS, breadth-first search, graph traversal, shortest path, queue, level-order">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/bfs.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="bfs">
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
                            <span>BFS</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">🔍 BFS (Breadth-First Search)</h1>
                            <div class="lesson-meta">
                                <span>Intermediate</span>
                                <span>~30 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">You're navigating a city map. You want the shortest route from your location to the destination. BFS (Breadth-First Search) explores the map level by level, guaranteeing you find the shortest path in unweighted graphs!</p>

                            <h2>The Navigation Problem</h2>
                            <p>When traversing a graph, you need to visit all vertices systematically. BFS does this by exploring level by level:</p>

                            <div class="info-box">
                                <h4>Real-World BFS Applications</h4>
                                <ul>
                                    <li><strong>GPS Navigation:</strong> Find shortest route (unweighted roads)</li>
                                    <li><strong>Web Crawling:</strong> Crawl websites level by level</li>
                                    <li><strong>Social Networks:</strong> Find people within K connections</li>
                                    <li><strong>Puzzle Solving:</strong> Minimum moves to solve puzzle</li>
                                    <li><strong>Network Broadcasting:</strong> Spread message level by level</li>
                                </ul>
                            </div>

                            <h2>How BFS Works</h2>
                            <div class="success-box">
                                <h4>BFS Algorithm</h4>
                                <ol>
                                    <li>Start with source vertex, mark visited</li>
                                    <li>Add source to queue</li>
                                    <li>While queue not empty:
                                        <ul>
                                            <li>Dequeue vertex</li>
                                            <li>Process vertex</li>
                                            <li>Enqueue all unvisited neighbors</li>
                                        </ul>
                                    </li>
                                </ol>
                                <p><strong>Key insight:</strong> Queue (FIFO) ensures level-by-level exploration!</p>
                            </div>

                            <h3>See BFS in Action</h3>
                            <div id="bfsVisualization"></div>

                            <h2>Why BFS Finds Shortest Path</h2>
                            <div class="info-box">
                                <h4>The Guarantee</h4>
                                <p>In unweighted graphs, BFS guarantees shortest path because:</p>
                                <ul>
                                    <li>All vertices at distance 1 are visited before distance 2</li>
                                    <li>Queue ensures we process closer vertices first</li>
                                    <li>First time we reach a vertex = shortest path</li>
                                </ul>
                                <p><strong>Note:</strong> Only works for unweighted graphs! For weighted graphs, use Dijkstra's.</p>
                            </div>

                            <h2>Implementation Details</h2>
                            <h3>1. Queue-Based</h3>
                            <div class="success-box">
                                <h4>Why Queue?</h4>
                                <p>Queue (FIFO - First In First Out) ensures:</p>
                                <ul>
                                    <li>Level 0 vertices processed before level 1</li>
                                    <li>Level 1 before level 2, etc.</li>
                                    <li>Natural level-by-level order</li>
                                </ul>
                            </div>

                            <h3>2. Visited Tracking</h3>
                            <p>Mark vertices as visited to avoid cycles and reprocessing.</p>

                            <h3>3. Distance Tracking</h3>
                            <p>Track distance from source to each vertex - useful for shortest path problems.</p>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/bfs.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-bfs" />
                            </jsp:include>

                            <h2>BFS Applications</h2>
                            <div class="info-box">
                                <h4>Common Use Cases</h4>
                                <ul>
                                    <li><strong>Shortest Path:</strong> Unweighted graphs</li>
                                    <li><strong>Level-order Traversal:</strong> Trees and graphs</li>
                                    <li><strong>Connected Components:</strong> Find all components</li>
                                    <li><strong>Web Crawling:</strong> Visit sites level by level</li>
                                    <li><strong>Social Networks:</strong> Degrees of separation</li>
                                    <li><strong>Bipartite Check:</strong> Two-coloring graphs</li>
                                </ul>
                            </div>

                            <h2>BFS vs DFS</h2>
                            <div class="info-box">
                                <h4>Comparison</h4>
                                <table>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>BFS</th>
                                        <th>DFS</th>
                                    </tr>
                                    <tr>
                                        <td><strong>Data Structure</strong></td>
                                        <td>Queue (FIFO)</td>
                                        <td>Stack/Recursion</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Order</strong></td>
                                        <td>Level by level</td>
                                        <td>Deep first</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Shortest Path</strong></td>
                                        <td>Yes (unweighted)</td>
                                        <td>No guarantee</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Space</strong></td>
                                        <td>O(V) - stores level</td>
                                        <td>O(V) - recursion depth</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>BFS is a fundamental graph traversal algorithm:</p>
                                <ol>
                                    <li><strong>Algorithm:</strong> Queue-based level-by-level traversal</li>
                                    <li><strong>Time:</strong> O(V + E) - visit each vertex and edge once</li>
                                    <li><strong>Space:</strong> O(V) - queue can hold all vertices at widest level</li>
                                    <li><strong>Shortest Path:</strong> Guarantees shortest path in unweighted graphs</li>
                                    <li><strong>Applications:</strong> GPS navigation, web crawling, level-order problems</li>
                                    <li><strong>Key insight:</strong> Queue ensures closer vertices processed first</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>You've mastered BFS! Next, we'll explore <strong>DFS (Depth-First Search)</strong> - going deep into the graph before backtracking, perfect for maze solving, cycle detection, and topological sorting!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="graph-representation.jsp" />
                            <jsp:param name="prevTitle" value="Graph Representation" />
                            <jsp:param name="nextLink" value="dfs.jsp" />
                            <jsp:param name="nextTitle" value="DFS" />
                            <jsp:param name="currentLessonId" value="bfs" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/bfs-viz.js"></script>
        </body>
        </html>
