<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "binary-tree" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Binary Tree Basics - Hierarchical Data | DSA Tutorial</title>
            <meta name="description"
                content="Master binary trees - hierarchical data structures with nodes and children. Learn tree terminology, types, and operations.">
            <meta name="keywords"
                content="binary tree, tree data structure, hierarchical data, tree traversal, tree operations">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/binary-tree.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="binary-tree">
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
                                    <span>Binary Tree Basics</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🌳 Binary Tree Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Think about your family tree - grandparents at the top, parents
                                        below, then you and your siblings. Or consider a company's organization chart -
                                        CEO at the top, managers below, employees at the bottom. This hierarchical
                                        structure is exactly what a <strong>tree</strong> represents in computer
                                        science!</p>

                                    <h2>Why Trees?</h2>

                                    <p>Unlike arrays and linked lists which are linear (one element after another),
                                        trees are <strong>hierarchical</strong>. They model relationships where items
                                        have parent-child connections.</p>

                                    <div class="info-box">
                                        <h4>🌍 Trees in the Real World</h4>
                                        <ul>
                                            <li><strong>File Systems:</strong> Folders contain subfolders and files</li>
                                            <li><strong>HTML DOM:</strong> Web pages are trees of elements</li>
                                            <li><strong>Organization Charts:</strong> Company hierarchy</li>
                                            <li><strong>Decision Trees:</strong> AI/ML models</li>
                                            <li><strong>Family Trees:</strong> Genealogy</li>
                                        </ul>
                                    </div>

                                    <h2>What is a Binary Tree?</h2>

                                    <p>A <strong>binary tree</strong> is a tree where each node has <strong>at most 2
                                            children</strong>: a left child and a right child.</p>

                                    <div class="success-box">
                                        <h4>Key Characteristics</h4>
                                        <ul>
                                            <li><strong>Hierarchical:</strong> Nodes arranged in levels</li>
                                            <li><strong>Binary:</strong> Maximum 2 children per node</li>
                                            <li><strong>Recursive:</strong> Each subtree is also a binary tree</li>
                                        </ul>
                                    </div>

                                    <h3>See the Structure</h3>
                                    <div id="binaryTreeVisualization"></div>

                                    <h2>Tree Terminology</h2>

                                    <p>Understanding these terms is essential:</p>

                                    <div class="info-box">
                                        <h4>Essential Terms</h4>
                                        <ul>
                                            <li><strong>Root:</strong> The top node (no parent)</li>
                                            <li><strong>Leaf:</strong> A node with no children</li>
                                            <li><strong>Parent:</strong> A node with children</li>
                                            <li><strong>Child:</strong> A node connected below a parent</li>
                                            <li><strong>Siblings:</strong> Nodes with the same parent</li>
                                            <li><strong>Depth:</strong> Distance from root to a node</li>
                                            <li><strong>Height:</strong> Longest path from root to any leaf</li>
                                        </ul>
                                    </div>

                                    <h2>Types of Binary Trees</h2>

                                    <div class="success-box">
                                        <h4>1. Full Binary Tree</h4>
                                        <p>Every node has either 0 or 2 children (no nodes with just 1 child).</p>
                                        <p><strong>Use case:</strong> Expression trees in compilers</p>
                                    </div>

                                    <div class="success-box">
                                        <h4>2. Complete Binary Tree</h4>
                                        <p>All levels are completely filled except possibly the last level, which is
                                            filled from left to right.</p>
                                        <p><strong>Use case:</strong> Heap data structure</p>
                                    </div>

                                    <div class="success-box">
                                        <h4>3. Perfect Binary Tree</h4>
                                        <p>All internal nodes have 2 children and all leaves are at the same level.</p>
                                        <p><strong>Property:</strong> Has exactly 2^(h+1) - 1 nodes where h is height
                                        </p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Basic Operations</h2>

                                    <div class="info-box">
                                        <h4>Common Operations</h4>
                                        <ul>
                                            <li><strong>Insert:</strong> Add a new node</li>
                                            <li><strong>Search:</strong> Find a node with specific value</li>
                                            <li><strong>Height:</strong> Calculate tree height</li>
                                            <li><strong>Size:</strong> Count total nodes</li>
                                            <li><strong>Traversal:</strong> Visit all nodes in specific order</li>
                                        </ul>
                                    </div>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/binary-tree.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-tree" />
                                    </jsp:include>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Binary Trees Are Used</h4>
                                        <ul>
                                            <li><strong>File Systems:</strong> Directory structure (folders and files)
                                            </li>
                                            <li><strong>Databases:</strong> B-trees for indexing</li>
                                            <li><strong>Compilers:</strong> Expression parsing and syntax trees</li>
                                            <li><strong>AI/ML:</strong> Decision trees for classification</li>
                                            <li><strong>Graphics:</strong> Scene graphs in 3D rendering</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Binary trees are hierarchical data structures that model parent-child
                                            relationships:</p>
                                        <ol>
                                            <li><strong>Structure:</strong> Each node has at most 2 children</li>
                                            <li><strong>Terminology:</strong> Root, leaf, parent, child, height, depth
                                            </li>
                                            <li><strong>Types:</strong> Full, complete, and perfect binary trees</li>
                                            <li><strong>Operations:</strong> Insert, search, height, size, traversal
                                            </li>
                                            <li><strong>Applications:</strong> File systems, databases, compilers, AI
                                            </li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand binary tree structure, let's explore how to
                                        <strong>traverse</strong> trees - visiting all nodes in different orders. This
                                        is essential for processing tree data!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="advanced-hashing.jsp" />
                                    <jsp:param name="prevTitle" value="Advanced Hashing" />
                                    <jsp:param name="nextLink" value="tree-traversals.jsp" />
                                    <jsp:param name="nextTitle" value="Tree Traversals" />
                                    <jsp:param name="currentLessonId" value="binary-tree" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/binary-tree-viz.js"></script>
        </body>

        </html>