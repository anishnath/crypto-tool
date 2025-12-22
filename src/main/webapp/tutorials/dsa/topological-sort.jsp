<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "topological-sort" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Topological Sorting - DAG Ordering | DSA Tutorial</title>
            <meta name="description" content="Master topological sorting - ordering vertices in DAG. Learn Kahn's algorithm, DFS-based approach, and course schedule problems.">
            <meta name="keywords" content="topological sort, DAG, Kahn's algorithm, course schedule, build order, dependencies">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/topological-sort.jsp">
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
        <body class="tutorial-body no-preview" data-lesson="topological-sort">
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
                            <span>Topological Sort</span>
                        </nav>
                        <header class="lesson-header">
                            <h1 class="lesson-title">📑 Topological Sorting</h1>
                            <div class="lesson-meta">
                                <span>Intermediate</span>
                                <span>~30 min read</span>
                            </div>
                        </header>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="top" />
                        </jsp:include>
                        <div class="lesson-body">
                            <p class="lead">You're taking computer science courses. Some courses have prerequisites - you must take CS101 before CS201, and CS201 before CS301. In what order should you take the courses? Topological sorting finds a valid order that respects all dependencies!</p>

                            <h2>The Dependency Problem</h2>
                            <p>Many real-world problems involve dependencies that must be ordered correctly:</p>

                            <div class="info-box">
                                <h4>Real-World Applications</h4>
                                <ul>
                                    <li><strong>Course Prerequisites:</strong> Order courses respecting prerequisites</li>
                                    <li><strong>Build Systems:</strong> Compile dependencies before dependents</li>
                                    <li><strong>Task Scheduling:</strong> Execute tasks in dependency order</li>
                                    <li><strong>Package Managers:</strong> Install dependencies first</li>
                                    <li><strong>Event Ordering:</strong> Order events with dependencies</li>
                                </ul>
                            </div>

                            <h2>What is Topological Sort?</h2>
                            <div class="success-box">
                                <h4>Definition</h4>
                                <p>Given a <strong>Directed Acyclic Graph (DAG)</strong>, topological sort produces a linear ordering of vertices such that:</p>
                                <ul>
                                    <li>For every edge (u, v), u comes before v in the ordering</li>
                                    <li>All dependencies are satisfied</li>
                                </ul>
                                <p><strong>Note:</strong> Only works for DAGs (no cycles)! If cycle exists, topological sort is impossible.</p>
                            </div>

                            <h3>See Topological Sort in Action</h3>
                            <div id="topologicalSortVisualization"></div>

                            <h2>Kahn's Algorithm (BFS-based)</h2>
                            <div class="success-box">
                                <h4>Algorithm Steps</h4>
                                <ol>
                                    <li>Calculate in-degree for each vertex</li>
                                    <li>Add all vertices with in-degree 0 to queue</li>
                                    <li>While queue not empty:
                                        <ul>
                                            <li>Dequeue vertex, add to result</li>
                                            <li>For each neighbor, decrement in-degree</li>
                                            <li>If in-degree becomes 0, add to queue</li>
                                        </ul>
                                    </li>
                                    <li>If result size ≠ total vertices, cycle exists!</li>
                                </ol>
                                <p><strong>Key insight:</strong> Process vertices with no dependencies first!</p>
                            </div>

                            <h2>DFS-based Approach</h2>
                            <div class="info-box">
                                <h4>Algorithm Steps</h4>
                                <ol>
                                    <li>Perform DFS on all unvisited vertices</li>
                                    <li>When vertex finishes (all descendants processed), add to stack</li>
                                    <li>Reverse stack to get topological order</li>
                                </ol>
                                <p><strong>Key insight:</strong> Finish time order gives topological sort (reversed)!</p>
                            </div>

                            <h2>Cycle Detection</h2>
                            <p>If topological sort cannot process all vertices, a cycle exists in the graph. This is a natural way to detect cycles in directed graphs!</p>

                            <jsp:include page="../tutorial-ad-slot.jsp">
                                <jsp:param name="slot" value="middle" />
                            </jsp:include>

                            <h2>The Complete Code</h2>
                            <jsp:include page="../tutorial-compiler.jsp">
                                <jsp:param name="codeFile" value="dsa/topological-sort.py" />
                                <jsp:param name="language" value="python" />
                                <jsp:param name="editorId" value="compiler-topo" />
                            </jsp:include>

                            <h2>Course Schedule Problem</h2>
                            <div class="info-box">
                                <h4>The Problem</h4>
                                <p>Given n courses and prerequisites, can you finish all courses?</p>
                                <p><strong>Solution:</strong> Topological sort - if all courses can be ordered, yes; if cycle exists, no.</p>
                            </div>

                            <h2>Build Order Problem</h2>
                            <div class="info-box">
                                <h4>The Problem</h4>
                                <p>Given projects and dependencies, in what order should projects be built?</p>
                                <p><strong>Solution:</strong> Topological sort gives valid build order!</p>
                            </div>

                            <h2>Kahn's vs DFS-based</h2>
                            <div class="info-box">
                                <h4>Comparison</h4>
                                <table>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>Kahn's Algorithm</th>
                                        <th>DFS-based</th>
                                    </tr>
                                    <tr>
                                        <td><strong>Approach</strong></td>
                                        <td>BFS (queue)</td>
                                        <td>DFS (stack/recursion)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Complexity</strong></td>
                                        <td>O(V + E)</td>
                                        <td>O(V + E)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Intuition</strong></td>
                                        <td>Start with no dependencies</td>
                                        <td>Finish times give order</td>
                                    </tr>
                                    <tr>
                                        <td><strong>When to Use</strong></td>
                                        <td>When you need level-by-level</td>
                                        <td>When DFS is natural</td>
                                    </tr>
                                </table>
                            </div>

                            <h2>Summary</h2>
                            <div class="summary-box">
                                <h3>What You've Learned</h3>
                                <p>Topological sort orders vertices in DAG:</p>
                                <ol>
                                    <li><strong>Definition:</strong> Linear ordering respecting edge directions</li>
                                    <li><strong>Requirement:</strong> Graph must be DAG (no cycles)</li>
                                    <li><strong>Kahn's:</strong> BFS-based, start with in-degree 0 vertices</li>
                                    <li><strong>DFS-based:</strong> Use finish times (reversed)</li>
                                    <li><strong>Time:</strong> O(V + E) for both approaches</li>
                                    <li><strong>Applications:</strong> Course schedules, build systems, task scheduling</li>
                                    <li><strong>Cycle Detection:</strong> If not all vertices processed, cycle exists</li>
                                </ol>
                            </div>

                            <h2>What's Next?</h2>
                            <p>Congratulations! You've completed Module 10: Graphs! You now understand graph representation, BFS, DFS, and topological sorting. These are fundamental algorithms used throughout computer science. You're ready to explore more advanced graph algorithms like shortest paths and minimum spanning trees!</p>
                        </div>
                        <jsp:include page="../tutorial-ad-slot.jsp">
                            <jsp:param name="slot" value="bottom" />
                        </jsp:include>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="dfs.jsp" />
                            <jsp:param name="prevTitle" value="DFS" />
                            <jsp:param name="nextLink" value="dijkstra.jsp" />
                            <jsp:param name="nextTitle" value="Dijkstra's Algorithm" />
                            <jsp:param name="currentLessonId" value="topological-sort" />
                        </jsp:include>
                    </article>
                </main>
                <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/topological-sort-viz.js"></script>
        </body>
        </html>
