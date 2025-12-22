<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "tree-problems" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tree Problems & Patterns | DSA Tutorial</title>
            <meta name="description"
                content="Master common tree problems and patterns - depth, paths, LCA, symmetry. Learn problem-solving techniques used in real applications.">
            <meta name="keywords"
                content="tree problems, tree patterns, LCA, path sum, tree depth, symmetric tree, tree algorithms">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/tree-problems.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="tree-problems">
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
                                    <span>Tree Problems & Patterns</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Tree Problems & Patterns</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate to Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine you're managing a company's organization chart. You need to
                                        find the deepest department level, calculate total budget paths, find common
                                        managers, and verify structural symmetry. These real-world scenarios map
                                        directly to common tree problems!</p>

                                    <h2>Why These Patterns Matter</h2>

                                    <p>Most tree problems fall into recognizable patterns. Master these patterns, and
                                        you can solve hundreds of variations!</p>

                                    <div class="info-box">
                                        <h4>Real-World Applications</h4>
                                        <ul>
                                            <li><strong>Organization Charts:</strong> Find hierarchy depth, common
                                                managers</li>
                                            <li><strong>File Systems:</strong> Calculate folder depths, find shared
                                                directories</li>
                                            <li><strong>Decision Trees:</strong> Validate paths, find optimal routes
                                            </li>
                                            <li><strong>Network Routing:</strong> Find shortest paths, validate symmetry
                                            </li>
                                        </ul>
                                    </div>

                                    <h3>See the Patterns</h3>
                                    <div id="treeProblemsVisualization"></div>

                                    <h2>Pattern 1: Depth & Height</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find the maximum depth (height) of a tree - the longest path from root to any
                                            leaf.</p>
                                        <p><strong>Real-world:</strong> How many management levels? How deep is the
                                            folder structure?</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution</h4>
                                        <p><strong>Approach:</strong> Recursive - height of tree = 1 + max(left height,
                                            right height)</p>
                                        <p><strong>Base case:</strong> Empty tree has height 0 (or -1)</p>
                                        <p><strong>Time:</strong> O(n) - visit every node once</p>
                                        <p><strong>Space:</strong> O(h) - recursion stack</p>
                                    </div>

                                    <h2>Pattern 2: Path Sum</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find if there's a root-to-leaf path with a specific sum.</p>
                                        <p><strong>Real-world:</strong> Does any budget allocation path equal target? Is
                                            there a route with specific cost?</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution</h4>
                                        <p><strong>Approach:</strong> DFS with running sum, subtract current value from
                                            target</p>
                                        <p><strong>Base case:</strong> At leaf, check if remaining sum equals leaf value
                                        </p>
                                        <p><strong>Variations:</strong> Find all paths, find maximum path sum, count
                                            paths</p>
                                    </div>

                                    <h2>Pattern 3: Lowest Common Ancestor (LCA)</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find the lowest common ancestor of two nodes.</p>
                                        <p><strong>Real-world:</strong> Who is the common manager? What's the shared
                                            parent directory?</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution (BST)</h4>
                                        <p><strong>Approach:</strong> Use BST property - if p < root < q, root is
                                                LCA</p>
                                                <p><strong>If both smaller:</strong> LCA is in left subtree</p>
                                                <p><strong>If both larger:</strong> LCA is in right subtree</p>
                                                <p><strong>Time:</strong> O(h) - only traverse one path</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Pattern 4: Symmetric Tree</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Check if a tree is symmetric (mirror image of itself).</p>
                                        <p><strong>Real-world:</strong> Validate design symmetry, check pattern matching
                                        </p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution</h4>
                                        <p><strong>Approach:</strong> Compare left subtree with right subtree as mirrors
                                        </p>
                                        <p><strong>Check:</strong> left.left == right.right AND left.right == right.left
                                        </p>
                                        <p><strong>Recursive:</strong> Apply same check to subtrees</p>
                                    </div>

                                    <h2>More Essential Patterns</h2>

                                    <h3>5. Invert Tree</h3>
                                    <p><strong>Use case:</strong> Mirror image flipping, UI direction changes</p>
                                    <p><strong>Solution:</strong> Swap left and right children recursively</p>

                                    <h3>6. Kth Smallest in BST</h3>
                                    <p><strong>Use case:</strong> Find median salary, nth percentile</p>
                                    <p><strong>Solution:</strong> Inorder traversal (gives sorted order), count to k</p>

                                    <h3>7. Validate BST</h3>
                                    <p><strong>Use case:</strong> Data integrity check, validation</p>
                                    <p><strong>Solution:</strong> Ensure each node is within valid range [min, max]</p>

                                    <h3>8. Serialize & Deserialize</h3>
                                    <p><strong>Use case:</strong> Save tree to file, network transmission</p>
                                    <p><strong>Solution:</strong> Preorder traversal with null markers</p>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/tree-problems.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-tree-problems" />
                                    </jsp:include>

                                    <h2>Problem-Solving Strategy</h2>

                                    <div class="success-box">
                                        <h4>How to Approach Tree Problems</h4>
                                        <ol>
                                            <li><strong>Identify the pattern:</strong> Depth? Path? Comparison?</li>
                                            <li><strong>Choose traversal:</strong> DFS (recursion) or BFS (queue)?</li>
                                            <li><strong>Define base case:</strong> What happens at null or leaf?</li>
                                            <li><strong>Recursive case:</strong> How to combine left and right results?
                                            </li>
                                            <li><strong>Track state:</strong> Need running sum? Count? Min/max?</li>
                                        </ol>
                                    </div>

                                    <h2>When You'll Use These</h2>

                                    <div class="info-box">
                                        <h4>These patterns appear in:</h4>
                                        <ul>
                                            <li><strong>System Design:</strong> Designing hierarchical systems</li>
                                            <li><strong>Databases:</strong> Query optimization, index structures</li>
                                            <li><strong>Compilers:</strong> Expression trees, syntax validation</li>
                                            <li><strong>AI/ML:</strong> Decision trees, game trees</li>
                                            <li><strong>Graphics:</strong> Scene graphs, spatial partitioning</li>
                                            <li><strong>Coding Challenges:</strong> Yes, these are common in technical
                                                interviews too!</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>You've mastered the most common tree problem patterns:</p>
                                        <ol>
                                            <li><strong>Depth/Height:</strong> Find tree dimensions - O(n)</li>
                                            <li><strong>Path Sum:</strong> Find paths with target sum - O(n)</li>
                                            <li><strong>LCA:</strong> Find common ancestor - O(h) for BST</li>
                                            <li><strong>Symmetric:</strong> Check mirror property - O(n)</li>
                                            <li><strong>Invert:</strong> Mirror the tree - O(n)</li>
                                            <li><strong>Kth Smallest:</strong> Use inorder for BST - O(n)</li>
                                            <li><strong>Validate BST:</strong> Check range constraints - O(n)</li>
                                            <li><strong>Serialize:</strong> Convert to/from string - O(n)</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> Most tree problems use DFS (recursion) or BFS
                                            (queue). Recognize the pattern, apply the technique!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've completed the Trees module! You now understand hierarchical data
                                        structures and can solve complex tree problems. Next up: exploring more advanced
                                        data structures like Heaps, Graphs, or diving into Dynamic Programming!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="binary-search-tree.jsp" />
                                    <jsp:param name="prevTitle" value="Binary Search Tree" />
                                    <jsp:param name="nextLink" value="heaps.jsp" />
                                    <jsp:param name="nextTitle" value="Heaps" />
                                    <jsp:param name="currentLessonId" value="tree-problems" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/tree-problems-viz.js"></script>
        </body>

        </html>