<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "binary-search-tree" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Binary Search Tree - O(log n) Search | DSA Tutorial</title>
            <meta name="description"
                content="Master Binary Search Trees - ordered trees enabling O(log n) search, insert, and delete operations.">
            <meta name="keywords"
                content="binary search tree, BST, tree search, tree insert, tree delete, balanced tree">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/binary-search-tree.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="binary-search-tree">
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
                                    <span>Binary Search Tree</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔍 Binary Search Tree</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine a library where books are organized: smaller numbers on the
                                        left shelves, larger numbers on the right. To find a book, you compare and go
                                        left or right - much faster than checking every shelf! This is exactly how a
                                        <strong>Binary Search Tree (BST)</strong> works.
                                    </p>

                                    <h2>The Problem with Regular Trees</h2>

                                    <p>In a regular binary tree, finding a value requires checking every node - O(n)
                                        time. But what if we could organize the tree so we can eliminate half the
                                        remaining nodes with each comparison?</p>

                                    <div class="info-box">
                                        <h4>The BST Solution</h4>
                                        <p>Add one simple rule: <strong>Left < Root < Right</strong>
                                        </p>
                                        <p>This single property enables O(log n) search in balanced trees!</p>
                                    </div>

                                    <h2>The BST Property</h2>

                                    <p>For every node in a BST:</p>

                                    <div class="success-box">
                                        <h4>The Golden Rule</h4>
                                        <ul>
                                            <li>All values in the <strong>left subtree</strong> are
                                                <strong>smaller</strong>
                                            </li>
                                            <li>All values in the <strong>right subtree</strong> are
                                                <strong>larger</strong>
                                            </li>
                                            <li>This applies to <strong>every node</strong> in the tree</li>
                                        </ul>
                                    </div>

                                    <h3>See the Property</h3>
                                    <div id="bstVisualization"></div>

                                    <h2>Why BST is Powerful</h2>

                                    <div class="info-box">
                                        <h4>The Magic of Ordering</h4>
                                        <p><strong>Inorder traversal gives sorted values!</strong></p>
                                        <p>Example: Tree with [50, 30, 70, 20, 40, 60, 80]</p>
                                        <p>Inorder: [20, 30, 40, 50, 60, 70, 80] ✓ Sorted!</p>
                                    </div>

                                    <h2>Basic Operations</h2>

                                    <h3>1. Search</h3>
                                    <div class="success-box">
                                        <h4>How to Search</h4>
                                        <ol>
                                            <li>Start at root</li>
                                            <li>If target equals current node → Found!</li>
                                            <li>If target < current → Go left</li>
                                            <li>If target > current → Go right</li>
                                            <li>Repeat until found or reach null</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(log n) average, O(n) worst case</p>
                                    </div>

                                    <h3>2. Insert</h3>
                                    <div class="success-box">
                                        <h4>How to Insert</h4>
                                        <ol>
                                            <li>Search for the value (as above)</li>
                                            <li>When you reach null, insert there</li>
                                            <li>BST property is automatically maintained!</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(log n) average, O(n) worst case</p>
                                    </div>

                                    <h3>3. Delete</h3>
                                    <div class="success-box">
                                        <h4>Three Cases</h4>
                                        <p><strong>Case 1: Leaf node</strong> - Simply remove it</p>
                                        <p><strong>Case 2: One child</strong> - Replace with that child</p>
                                        <p><strong>Case 3: Two children</strong> - Replace with inorder successor (min
                                            in right subtree)</p>
                                        <p><strong>Time:</strong> O(log n) average, O(n) worst case</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/binary-search-tree.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-bst" />
                                    </jsp:include>

                                    <h2>Balanced vs Skewed Trees</h2>

                                    <div class="info-box">
                                        <h4>Performance Depends on Balance</h4>
                                        <p><strong>Balanced tree:</strong> Height = O(log n) → Operations are O(log n)
                                        </p>
                                        <p><strong>Skewed tree:</strong> Height = O(n) → Operations degrade to O(n)</p>
                                        <p><strong>Solution:</strong> Self-balancing trees (AVL, Red-Black) maintain
                                            O(log n)</p>
                                    </div>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where BSTs Are Used</h4>
                                        <ul>
                                            <li><strong>Databases:</strong> Index structures for fast queries</li>
                                            <li><strong>File Systems:</strong> Directory organization</li>
                                            <li><strong>Compilers:</strong> Symbol tables</li>
                                            <li><strong>Autocomplete:</strong> Dictionary implementations</li>
                                            <li><strong>Priority Queues:</strong> Efficient min/max operations</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Binary Search Trees enable efficient searching through ordering:</p>
                                        <ol>
                                            <li><strong>BST Property:</strong> Left < Root < Right</li>
                                            <li><strong>Search:</strong> Compare and go left/right - O(log n)</li>
                                            <li><strong>Insert:</strong> Find position and add - O(log n)</li>
                                            <li><strong>Delete:</strong> Three cases (leaf, one child, two children)
                                            </li>
                                            <li><strong>Inorder:</strong> Gives sorted values</li>
                                            <li><strong>Balance matters:</strong> Skewed trees degrade to O(n)</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered BST fundamentals! The Trees module is complete. Next, we'll
                                        explore more advanced data structures and algorithms!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="tree-traversals.jsp" />
                                    <jsp:param name="prevTitle" value="Tree Traversals" />
                                    <jsp:param name="nextLink" value="tree-problems.jsp" />
                                    <jsp:param name="nextTitle" value="Tree Problems" />
                                    <jsp:param name="currentLessonId" value="binary-search-tree" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/bst-viz.js"></script>
        </body>

        </html>