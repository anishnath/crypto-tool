<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "tree-traversals" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tree Traversals - DFS & BFS | DSA Tutorial</title>
            <meta name="description"
                content="Master tree traversals - inorder, preorder, postorder, and level-order. Learn when to use each traversal method.">
            <meta name="keywords"
                content="tree traversal, inorder, preorder, postorder, level-order, DFS, BFS, tree algorithms">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/tree-traversals.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="tree-traversals">
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
                                    <span>Tree Traversals</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔄 Tree Traversals</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine you're reading a book. You could read it page by page
                                        (linear), or you could read the table of contents first, then each chapter's
                                        introduction, then the details (hierarchical). Similarly, there are different
                                        ways to <strong>visit all nodes</strong> in a tree - each useful for different
                                        purposes!</p>

                                    <h2>Why Different Traversals?</h2>

                                    <p>Just like there are different ways to explore a building (top-down, bottom-up,
                                        floor-by-floor), trees can be traversed in different orders depending on what
                                        you need to do:</p>

                                    <div class="info-box">
                                        <h4>Real-World Analogies</h4>
                                        <ul>
                                            <li><strong>File System:</strong> List files in sorted order (inorder)</li>
                                            <li><strong>Backup:</strong> Copy folder structure first (preorder)</li>
                                            <li><strong>Delete:</strong> Delete files before folders (postorder)</li>
                                            <li><strong>Search:</strong> Check closest folders first (level-order)</li>
                                        </ul>
                                    </div>

                                    <h2>The Four Main Traversals</h2>

                                    <p>There are two categories: <strong>Depth-First</strong> (go deep) and
                                        <strong>Breadth-First</strong> (go wide).
                                    </p>

                                    <h3>See Them in Action</h3>
                                    <div id="treeTraversalsVisualization"></div>

                                    <h2>1. Inorder: Left → Root → Right</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Visit left subtree</li>
                                            <li>Visit root</li>
                                            <li>Visit right subtree</li>
                                        </ol>
                                        <p><strong>Key property:</strong> For Binary Search Trees, gives values in
                                            sorted order!</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>When to Use Inorder</h4>
                                        <ul>
                                            <li>Get sorted values from BST</li>
                                            <li>Validate if tree is a BST</li>
                                            <li>Find kth smallest element</li>
                                        </ul>
                                    </div>

                                    <h2>2. Preorder: Root → Left → Right</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Visit root</li>
                                            <li>Visit left subtree</li>
                                            <li>Visit right subtree</li>
                                        </ol>
                                        <p><strong>Key property:</strong> Visits parent before children - perfect for
                                            copying!</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>When to Use Preorder</h4>
                                        <ul>
                                            <li>Copy/clone a tree</li>
                                            <li>Serialize tree to string</li>
                                            <li>Create prefix expressions</li>
                                        </ul>
                                    </div>

                                    <h2>3. Postorder: Left → Right → Root</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Visit left subtree</li>
                                            <li>Visit right subtree</li>
                                            <li>Visit root</li>
                                        </ol>
                                        <p><strong>Key property:</strong> Visits children before parent - perfect for
                                            deletion!</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>When to Use Postorder</h4>
                                        <ul>
                                            <li>Delete tree (delete children first)</li>
                                            <li>Evaluate postfix expressions</li>
                                            <li>Calculate tree height/size</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>4. Level-order: Level by Level (BFS)</h2>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Visit all nodes at level 0 (root)</li>
                                            <li>Visit all nodes at level 1</li>
                                            <li>Visit all nodes at level 2</li>
                                            <li>Continue until all levels visited</li>
                                        </ol>
                                        <p><strong>Key difference:</strong> Uses a queue instead of recursion!</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>When to Use Level-order</h4>
                                        <ul>
                                            <li>Find shortest path in tree</li>
                                            <li>Print tree level by level</li>
                                            <li>Serialize tree for transmission</li>
                                        </ul>
                                    </div>

                                    <h2>Recursive vs Iterative</h2>

                                    <p>All DFS traversals can be implemented two ways:</p>

                                    <div class="info-box">
                                        <h4>Comparison</h4>
                                        <table>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Recursive</th>
                                                <th>Iterative</th>
                                            </tr>
                                            <tr>
                                                <td>Code</td>
                                                <td>Cleaner, shorter</td>
                                                <td>More verbose</td>
                                            </tr>
                                            <tr>
                                                <td>Stack</td>
                                                <td>Uses call stack</td>
                                                <td>Uses explicit stack</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(h)</td>
                                                <td>O(h)</td>
                                            </tr>
                                            <tr>
                                                <td>Control</td>
                                                <td>Less control</td>
                                                <td>More control</td>
                                            </tr>
                                        </table>
                                    </div>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/tree-traversals.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-traversals" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Tree traversals are systematic ways to visit all nodes:</p>
                                        <ol>
                                            <li><strong>Inorder (L-Root-R):</strong> Sorted order for BST</li>
                                            <li><strong>Preorder (Root-L-R):</strong> Copy tree structure</li>
                                            <li><strong>Postorder (L-R-Root):</strong> Delete tree safely</li>
                                            <li><strong>Level-order (BFS):</strong> Level by level with queue</li>
                                            <li><strong>All are O(n) time:</strong> Visit each node once</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you can traverse any tree, let's learn about <strong>Binary Search Trees
                                            (BST)</strong> - a special tree where inorder traversal gives sorted values,
                                        enabling O(log n) search!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="binary-tree.jsp" />
                                    <jsp:param name="prevTitle" value="Binary Tree Basics" />
                                    <jsp:param name="nextLink" value="binary-search-tree.jsp" />
                                    <jsp:param name="nextTitle" value="Binary Search Tree" />
                                    <jsp:param name="currentLessonId" value="tree-traversals" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/tree-traversals-viz.js"></script>
        </body>

        </html>