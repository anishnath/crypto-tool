<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "tries" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tries (Prefix Trees) - Autocomplete & Search | DSA Tutorial</title>
            <meta name="description"
                content="Master Tries - efficient prefix tree for autocomplete, spell check, and string search. Learn insert, search, and prefix operations.">
            <meta name="keywords"
                content="trie, prefix tree, autocomplete, spell checker, string search, trie data structure">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/tries.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="tries">
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
                                    <span>Tries (Prefix Trees)</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">📖 Tries (Prefix Trees)</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">You're typing "app" in a search box. Instantly, suggestions appear:
                                        "apple," "application," "apply." How does it find all words starting with "app"
                                        so fast? Meet the <strong>Trie</strong> - a tree structure designed specifically
                                        for prefix-based operations!</p>

                                    <h2>The Dictionary Problem</h2>

                                    <p>Imagine building a dictionary. You need to:</p>
                                    <ul>
                                        <li>Check if a word exists</li>
                                        <li>Find all words starting with a prefix</li>
                                        <li>Suggest corrections for misspellings</li>
                                    </ul>

                                    <div class="info-box">
                                        <h4>Why Not Use a Hash Table?</h4>
                                        <p><strong>Hash table:</strong> Great for exact lookups, but can't efficiently
                                            find all words with prefix "app"</p>
                                        <p><strong>Trie:</strong> Designed for prefix operations - finds all matches in
                                            O(m + n) time!</p>
                                    </div>

                                    <h2>What is a Trie?</h2>

                                    <div class="success-box">
                                        <h4>Trie = Tree of Characters</h4>
                                        <p>A <strong>Trie</strong> (pronounced "try") is a tree where:</p>
                                        <ul>
                                            <li>Each node represents a character</li>
                                            <li>Each path from root to marked node = one word</li>
                                            <li>Shared prefixes share nodes (space efficient!)</li>
                                        </ul>
                                        <p><strong>Example:</strong> "app", "apple", "apply" share nodes a→p→p</p>
                                    </div>

                                    <h3>See the Structure</h3>
                                    <div id="triesVisualization"></div>

                                    <h2>Basic Operations</h2>

                                    <h3>1. Insert</h3>
                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Start at root</li>
                                            <li>For each character in word:</li>
                                            <ul>
                                                <li>If child node exists, move to it</li>
                                                <li>If not, create new node</li>
                                            </ul>
                                            <li>Mark last node as "end of word"</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(m) where m = word length</p>
                                    </div>

                                    <h3>2. Search</h3>
                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Follow path for each character</li>
                                            <li>If path breaks → word doesn't exist</li>
                                            <li>If reach end, check if marked as "end of word"</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> "app" exists, but "appl" might not (even if
                                            path exists!)</p>
                                        <p><strong>Time:</strong> O(m)</p>
                                    </div>

                                    <h3>3. Prefix Search (Autocomplete)</h3>
                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Navigate to prefix node</li>
                                            <li>Collect all words in that subtree</li>
                                            <li>Return as suggestions</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(m + n) where m = prefix length, n = number of
                                            results</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Tries Shine</h4>
                                        <ul>
                                            <li><strong>Autocomplete:</strong> Google search, IDE code completion</li>
                                            <li><strong>Spell Checkers:</strong> Word processors, browsers</li>
                                            <li><strong>IP Routing:</strong> Longest prefix matching</li>
                                            <li><strong>Dictionary:</strong> Word games, text editors</li>
                                            <li><strong>Phone Contacts:</strong> T9 predictive text</li>
                                            <li><strong>DNA Sequencing:</strong> Pattern matching in genomes</li>
                                        </ul>
                                    </div>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/tries.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-tries" />
                                    </jsp:include>

                                    <h2>Trie vs Hash Table</h2>

                                    <div class="info-box">
                                        <h4>Comparison</h4>
                                        <table>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Trie</th>
                                                <th>Hash Table</th>
                                            </tr>
                                            <tr>
                                                <td>Insert</td>
                                                <td>O(m)</td>
                                                <td>O(m)</td>
                                            </tr>
                                            <tr>
                                                <td>Search</td>
                                                <td>O(m)</td>
                                                <td>O(m)</td>
                                            </tr>
                                            <tr>
                                                <td>Prefix search</td>
                                                <td>O(m + n) ✓</td>
                                                <td>O(N) ✗</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(ALPHABET × N × M)</td>
                                                <td>O(N × M)</td>
                                            </tr>
                                        </table>
                                        <p><strong>Trie advantage:</strong> Prefix operations!</p>
                                        <p><strong>Trie disadvantage:</strong> More space (but shared prefixes help)</p>
                                    </div>

                                    <h2>Space Optimization</h2>

                                    <div class="info-box">
                                        <h4>Reducing Memory Usage</h4>
                                        <ul>
                                            <li><strong>Compressed Trie:</strong> Merge single-child chains</li>
                                            <li><strong>Ternary Search Tree:</strong> Use 3-way branching</li>
                                            <li><strong>Hash Map Children:</strong> Instead of array (saves space for
                                                sparse alphabets)</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Tries are specialized trees for string operations:</p>
                                        <ol>
                                            <li><strong>Structure:</strong> Each path = one word</li>
                                            <li><strong>Insert:</strong> Create nodes for each character - O(m)</li>
                                            <li><strong>Search:</strong> Follow path, check end marker - O(m)</li>
                                            <li><strong>Prefix:</strong> Navigate to prefix, collect subtree - O(m + n)
                                            </li>
                                            <li><strong>Space:</strong> Shared prefixes save memory</li>
                                            <li><strong>Applications:</strong> Autocomplete, spell check, IP routing
                                            </li>
                                            <li><strong>Trade-off:</strong> More space for faster prefix operations</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've completed Module 9! You now understand heaps, their applications, and
                                        tries. These are powerful tools for real-world systems. Next, we can explore
                                        more advanced data structures or move to graphs and algorithms!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="heap-applications.jsp" />
                                    <jsp:param name="prevTitle" value="Heap Applications" />
                                    <jsp:param name="nextLink" value="graph-representation.jsp" />
                                    <jsp:param name="nextTitle" value="Graph Representation" />
                                    <jsp:param name="currentLessonId" value="tries" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/tries-viz.js"></script>
        </body>

        </html>