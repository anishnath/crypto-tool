<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "graph-representation" ); request.setAttribute("currentModule", "Graphs" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Graph Representation - Adjacency Matrix, List, Edge List | DSA Tutorial</title>
            <meta name="description"
                content="Master graph representation - adjacency matrix, adjacency list, and edge list. Learn when to use each representation for different graph problems.">
            <meta name="keywords"
                content="graph representation, adjacency matrix, adjacency list, edge list, graph data structure">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/graph-representation.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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

        <body class="tutorial-body no-preview" data-lesson="graph-representation">
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
                                    <span>Graph Representation</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">📊 Graph Representation</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Think of a social network - Facebook friends, Twitter followers,
                                        LinkedIn connections. How do we store these relationships in code? Graphs are
                                        everywhere, but choosing the right representation makes all the difference!</p>

                                    <h2>The Graph Problem</h2>

                                    <p>Graphs model relationships between entities. Before we can work with graphs, we
                                        need to represent them in code:</p>

                                    <div class="info-box">
                                        <h4>Real-World Graphs</h4>
                                        <ul>
                                            <li><strong>Social Networks:</strong> People (nodes) connected by
                                                friendships (edges)</li>
                                            <li><strong>Maps:</strong> Cities (nodes) connected by roads (edges)</li>
                                            <li><strong>Web:</strong> Pages (nodes) connected by links (edges)</li>
                                            <li><strong>Dependencies:</strong> Tasks (nodes) with prerequisites (edges)
                                            </li>
                                            <li><strong>Networks:</strong> Computers (nodes) connected by cables
                                                (edges)</li>
                                        </ul>
                                    </div>

                                    <p>We need a data structure that can:</p>
                                    <ul>
                                        <li>Store vertices (nodes)</li>
                                        <li>Store edges (connections)</li>
                                        <li>Efficiently check if an edge exists</li>
                                        <li>Get all neighbors of a vertex</li>
                                    </ul>

                                    <h2>Three Ways to Represent Graphs</h2>

                                    <div class="success-box">
                                        <h4>The Three Representations</h4>
                                        <ol>
                                            <li><strong>Adjacency Matrix:</strong> V×V matrix, matrix[i][j] = 1 if edge
                                                exists</li>
                                            <li><strong>Adjacency List:</strong> Each vertex has list of neighbors</li>
                                            <li><strong>Edge List:</strong> Simple list of all edges</li>
                                        </ol>
                                        <p><strong>Each has different trade-offs!</strong></p>
                                    </div>

                                    <h3>See the Representations</h3>
                                    <div id="graphRepresentationVisualization"></div>

                                    <h2>1. Adjacency Matrix</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <p>Use a V×V matrix where:</p>
                                        <ul>
                                            <li>matrix[i][j] = 1 if edge from i to j exists</li>
                                            <li>matrix[i][j] = 0 if no edge</li>
                                            <li>For weighted graphs, store weight instead of 1</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>Adjacency Matrix Properties</h4>
                                        <ul>
                                            <li><strong>Space:</strong> O(V²) - Always V² regardless of edges</li>
                                            <li><strong>Check edge:</strong> O(1) - Just matrix[i][j]</li>
                                            <li><strong>Get neighbors:</strong> O(V) - Scan entire row</li>
                                            <li><strong>Add edge:</strong> O(1) - Just set matrix[i][j]</li>
                                        </ul>
                                        <p><strong>Best for:</strong> Dense graphs (E ≈ V²), when you need fast edge
                                            lookups</p>
                                        <p><strong>Worst for:</strong> Sparse graphs (wasteful space)</p>
                                    </div>

                                    <h2>2. Adjacency List</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <p>Each vertex stores a list of its neighbors:</p>
                                        <ul>
                                            <li>adj_list[i] = list of (neighbor, weight) tuples</li>
                                            <li>Only stores edges that exist</li>
                                            <li>Space-efficient for sparse graphs</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>Adjacency List Properties</h4>
                                        <ul>
                                            <li><strong>Space:</strong> O(V + E) - Only stores existing edges</li>
                                            <li><strong>Check edge:</strong> O(degree) - Search in neighbor list</li>
                                            <li><strong>Get neighbors:</strong> O(degree) - Directly available</li>
                                            <li><strong>Add edge:</strong> O(1) - Append to list</li>
                                        </ul>
                                        <p><strong>Best for:</strong> Sparse graphs, most graph algorithms (BFS, DFS,
                                            etc.)</p>
                                        <p><strong>Worst for:</strong> Frequent edge existence checks</p>
                                    </div>

                                    <h2>3. Edge List</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <p>Simple list of all edges:</p>
                                        <ul>
                                            <li>edges = [(from, to, weight), ...]</li>
                                            <li>Minimal representation</li>
                                            <li>Just stores what's needed</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>Edge List Properties</h4>
                                        <ul>
                                            <li><strong>Space:</strong> O(E) - Only edges, no vertices</li>
                                            <li><strong>Check edge:</strong> O(E) - Must iterate all edges</li>
                                            <li><strong>Get neighbors:</strong> O(E) - Must search all edges</li>
                                            <li><strong>Add edge:</strong> O(1) - Append to list</li>
                                        </ul>
                                        <p><strong>Best for:</strong> Kruskal's algorithm, when you need to iterate all
                                            edges</p>
                                        <p><strong>Worst for:</strong> Any operation that needs quick lookups</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/graph-representation.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-graph-rep" />
                                    </jsp:include>

                                    <h2>When to Use Each Representation</h2>

                                    <div class="info-box">
                                        <h4>Decision Guide</h4>
                                        <table>
                                            <tr>
                                                <th>Representation</th>
                                                <th>Use When</th>
                                                <th>Avoid When</th>
                                            </tr>
                                            <tr>
                                                <td><strong>Adjacency Matrix</strong></td>
                                                <td>Dense graph (E ≈ V²)<br>Need fast edge checks<br>Small graph</td>
                                                <td>Sparse graph<br>Large graph (memory)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Adjacency List</strong></td>
                                                <td>Sparse graph (E << V²)<br>Most algorithms (BFS, DFS)<br>Default choice</td>
                                                <td>Frequent edge existence checks<br>Very dense graphs</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Edge List</strong></td>
                                                <td>Kruskal's algorithm<br>Need to iterate all edges<br>Minimal space</td>
                                                <td>Need neighbor lookups<br>Need edge checks</td>
                                            </tr>
                                        </table>
                                    </div>

                                    <h2>Directed vs Undirected Graphs</h2>

                                    <div class="info-box">
                                        <h4>Representation Differences</h4>
                                        <p><strong>Undirected Graph:</strong></p>
                                        <ul>
                                            <li>Edge (u, v) means connection both ways</li>
                                            <li>Adjacency Matrix: matrix[u][v] = matrix[v][u] = 1</li>
                                            <li>Adjacency List: Add v to u's list AND u to v's list</li>
                                        </ul>
                                        <p><strong>Directed Graph:</strong></p>
                                        <ul>
                                            <li>Edge (u, v) means only u → v</li>
                                            <li>Adjacency Matrix: Only matrix[u][v] = 1</li>
                                            <li>Adjacency List: Only add v to u's list</li>
                                        </ul>
                                    </div>

                                    <h2>Weighted Graphs</h2>

                                    <div class="info-box">
                                        <h4>Storing Weights</h4>
                                        <ul>
                                            <li><strong>Adjacency Matrix:</strong> Store weight at matrix[i][j] instead
                                                of 1</li>
                                            <li><strong>Adjacency List:</strong> Store (neighbor, weight) tuples</li>
                                            <li><strong>Edge List:</strong> Store (from, to, weight) tuples</li>
                                        </ul>
                                        <p><strong>Example:</strong> City distances, network latencies, social network
                                            strengths</p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Three ways to represent graphs, each with different trade-offs:</p>
                                        <ol>
                                            <li><strong>Adjacency Matrix:</strong> O(V²) space, O(1) edge check - Best
                                                for dense graphs</li>
                                            <li><strong>Adjacency List:</strong> O(V + E) space, O(degree) operations -
                                                Best for most cases</li>
                                            <li><strong>Edge List:</strong> O(E) space, O(E) lookups - Best for
                                                iterating edges</li>
                                            <li><strong>Default choice:</strong> Adjacency list (best balance)</li>
                                            <li><strong>Key insight:</strong> Choose based on graph density and
                                                operations needed</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've learned how to represent graphs! Next, we'll explore <strong>BFS (Breadth-First Search)</strong>
                                        - a fundamental algorithm for traversing graphs level by level, perfect for
                                        finding shortest paths in unweighted graphs!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="tries.jsp" />
                                    <jsp:param name="prevTitle" value="Tries" />
                                    <jsp:param name="nextLink" value="bfs.jsp" />
                                    <jsp:param name="nextTitle" value="BFS" />
                                    <jsp:param name="currentLessonId" value="graph-representation" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/graph-representation-viz.js"></script>
        </body>

        </html>
