<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "dfs" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>DFS (Depth-First Search) - Deep Traversal | DSA Tutorial</title>
            <meta name="description" content="Master DFS - depth-first graph traversal. Learn recursive and iterative implementations, cycle detection, and maze solving.">
            <meta name="keywords" content="DFS, depth-first search, graph traversal, recursion, cycle detection, stack">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/dfs.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="dfs">
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
                            <span>DFS</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">🌲 DFS (Depth-First Search)</h1>
                            <div class="lesson-meta">
                                <span>Intermediate</span>
                                <span>~30 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">You're exploring a maze. Instead of checking all paths at the same level, you go deep down one path until you hit a dead end, then backtrack and try another. This is exactly what DFS (Depth-First Search) does - it explores as deep as possible before backtracking!</p>

                            <h2>The Exploration Problem</h2>
                            <p>DFS takes a different approach than BFS - it goes deep before going wide:</p>

                            <div class="info-box">
                                <h4>Real-World DFS Applications</h4>
                                <ul>
                                    <li><strong>Maze Solving:</strong> Explore paths until finding exit</li>
                                    <li><strong>Topological Sort:</strong> Order tasks with dependencies</li>
                                    <li><strong>Cycle Detection:</strong> Find cycles in graphs</li>
                                    <li><strong>Connected Components:</strong> Find all components</li>
                                    <li><strong>Path Finding:</strong> Find any path (not necessarily shortest)</li>
                                    <li><strong>Backtracking:</strong> Explore all possibilities</li>
                                </ul>
                            </div>

                            <h2>How DFS Works</h2>
                            <div class="success-box">
                                <h4>DFS Algorithm</h4>
                                <ol>
                                    <li>Start with source vertex, mark visited</li>
                                    <li>For each unvisited neighbor:
                                        <ul>
                                            <li>Recursively call DFS on neighbor</li>
                                            <li>Or push to stack (iterative)</li>
                                        </ul>
                                    </li>
                                    <li>Backtrack when no more unvisited neighbors</li>
                                </ol>
                                <p><strong>Key insight:</strong> Stack/recursion naturally explores depth first!</p>
                            </div>

                            <h3>See DFS in Action</h3>
                            <div id="dfsVisualization"></div>

                            <h2>Recursive vs Iterative</h2>
                            <h3>Recursive DFS</h3>
                            <div class="info-box">
                                <h4>Advantages</h4>
                                <ul>
                                    <li>More intuitive and readable</li>
                                    <li>Natural backtracking via call stack</li>
                                    <li>Easier to implement</li>
                                </ul>
                            </div>

                            <h3>Iterative DFS</h3>
                            <div class="info-box">
                                <h4>Advantages</h4>
                                <ul>
                                    <li>More control over the process</li>
                                    <li>Avoids stack overflow for deep graphs</li>
                                    <li>Uses explicit stack</li>
                                </ul>
                            </div>

                            <h2>Cycle Detection</h2>
                            <div class="success-box">
                                <h4>Undirected Graph</h4>
                                <p>Back edge (edge to already visited node that's not parent) = cycle</p>
                            </div>

                            <div class="success-box">
                                <h4>Directed Graph</h4>
                                <p>Use three colors: WHITE (unvisited), GRAY (being explored), BLACK (finished)</p>
                                <p>Back edge to GRAY vertex = cycle!</p>
                            </div>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/dfs.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-dfs" />
                            </jsp:include>

                            <h2>DFS Applications</h2>
                            <div class="info-box">
                                <h4>Common Use Cases</h4>
                                <ul>
                                    <li><strong>Maze Solving:</strong> Explore all paths</li>
                                    <li><strong>Topological Sort:</strong> Order vertices in DAG</li>
                                    <li><strong>Cycle Detection:</strong> Find cycles efficiently</li>
                                    <li><strong>Connected Components:</strong> Find all components</li>
                                    <li><strong>Path Finding:</strong> Find any path</li>
                                    <li><strong>Tree Problems:</strong> Many tree algorithms use DFS</li>
                                </ul>
                            </div>

                            <h2>DFS vs BFS</h2>
                            <div class="info-box">
                                <h4>When to Use Each</h4>
                                <table>
                                    <tr>
                                        <th>Use DFS When</th>
                                        <th>Use BFS When</th>
                                    </tr>
                                    <tr>
                                        <td>Finding any path</td>
                                        <td>Finding shortest path (unweighted)</td>
                                    </tr>
                                    <tr>
                                        <td>Cycle detection</td>
                                        <td>Level-order traversal</td>
                                    </tr>
                                    <tr>
                                        <td>Topological sort</td>
                                        <td>Finding vertices at distance K</td>
                                    </tr>
                                    <tr>
                                        <td>Maze solving</td>
                                        <td>Web crawling level by level</td>
                                    </tr>
                                    <tr>
                                        <td>Backtracking problems</td>
                                        <td>GPS navigation</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>DFS is a fundamental graph traversal algorithm:</p>
                                <ol>
                                    <li><strong>Algorithm:</strong> Stack/recursion-based deep traversal</li>
                                    <li><strong>Time:</strong> O(V + E) - visit each vertex and edge once</li>
                                    <li><strong>Space:</strong> O(V) - recursion depth or stack size</li>
                                    <li><strong>Cycle Detection:</strong> Back edge detection reveals cycles</li>
                                    <li><strong>Applications:</strong> Maze solving, topological sort, cycle detection</li>
                                    <li><strong>Key insight:</strong> Stack/recursion naturally explores depth first</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>You've mastered DFS! Next, we'll explore <strong>Topological Sorting</strong> - ordering vertices in a directed acyclic graph, essential for build systems, course prerequisites, and task scheduling!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="bfs.jsp" />
                            <jsp:param name="prevTitle" value="BFS" />
                            <jsp:param name="nextLink" value="topological-sort.jsp" />
                            <jsp:param name="nextTitle" value="Topological Sort" />
                            <jsp:param name="currentLessonId" value="dfs" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/dfs-viz.js"></script>
        </body>
        </html>
