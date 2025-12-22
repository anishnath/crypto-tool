<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linear-search" );
        request.setAttribute("currentModule", "Searching Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Linear Search - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Linear Search - the simplest searching algorithm. O(n) time, works on any array, foundation for understanding search algorithms.">
            <meta name="keywords" content="linear search, sequential search, O(n), simple search, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Linear Search - DSA Tutorial">
            <meta property="og:description"
                content="Master Linear Search - the baseline searching algorithm that works on any array.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linear-search.jsp">
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

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Linear Search Algorithm",
        "description": "Learn Linear Search - the simplest searching algorithm with O(n) complexity.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Linear Search", "Sequential Search", "O(n)", "Search Algorithms"],
        "timeRequired": "PT10M",
        "isPartOf": {
            "@type": "Course",
            "name": "Data Structures and Algorithms Tutorial",
            "url": "https://8gwifi.org/tutorials/dsa/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="linear-search">
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
                                    <span>Linear Search</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔍 Linear Search</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Looking for your keys? You check the table, then the couch, then
                                        your pockets, one by one until you find them. That's <strong>Linear
                                            Search</strong> - the simplest and most intuitive searching algorithm. Check
                                        each element sequentially until you find what you're looking for!</p>

                                    <h2>The Detective's Method</h2>

                                    <p>Imagine a detective searching for a suspect in a lineup of people:</p>

                                    <div class="info-box">
                                        <h4>The Simple Strategy</h4>
                                        <ol>
                                            <li><strong>Start at the beginning:</strong> Check the first person</li>
                                            <li><strong>Compare:</strong> Is this the suspect?</li>
                                            <li><strong>If yes:</strong> Found! Stop searching</li>
                                            <li><strong>If no:</strong> Move to the next person</li>
                                            <li><strong>Repeat:</strong> Until found or everyone checked</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> Simple, straightforward, works every time!</p>
                                    </div>

                                    <h3>Why Linear Search?</h3>

                                    <div class="success-box">
                                        <h4>The Advantages</h4>
                                        <ul>
                                            <li><strong>Simplest algorithm:</strong> Easiest to understand and implement
                                            </li>
                                            <li><strong>Works on any array:</strong> Sorted or unsorted - doesn't
                                                matter!</li>
                                            <li><strong>No preprocessing:</strong> No need to sort first</li>
                                            <li><strong>Small arrays:</strong> Fast enough for small datasets</li>
                                            <li><strong>Baseline:</strong> Foundation for understanding search
                                                algorithms</li>
                                        </ul>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch how Linear Search checks each element sequentially:</p>

                                    <div id="linearSearchVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li><strong>Yellow box:</strong> Currently checking this element</li>
                                            <li><strong>Faded boxes:</strong> Already checked, not a match</li>
                                            <li><strong>Green box:</strong> Target found!</li>
                                            <li><strong>Sequential:</strong> Checks left to right, one by one</li>
                                        </ul>
                                    </div>

                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linear-search-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-linear-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Sentinel Optimization:</strong> By placing the target at the end, we can
                                        eliminate the end-of-array check in the loop condition. This makes the code
                                        slightly faster in practice!
                                    </div>

                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is Linear Search O(n) and not O(1)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                In the worst case (target is last or not found), we must check ALL n
                                                elements. Best case is O(1) if target is first, but worst case
                                                determines the complexity: O(n).
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When would you use Linear Search instead of Binary Search?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                When the array is UNSORTED! Binary Search requires sorted data. Also for
                                                very small arrays (< 10 elements), Linear Search is fast enough and
                                                    simpler. Linear Search is the ONLY option for unsorted data!
                                                    </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Case</th>
                                                <th>Time</th>
                                                <th>When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Best</td>
                                                <td>O(1)</td>
                                                <td>Target is first element</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(n/2) = O(n)</td>
                                                <td>Target in middle</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n)</td>
                                                <td>Target is last or not found</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>No extra space needed</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Linear vs Binary Search</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Linear Search</th>
                                                <th>Binary Search</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Time Complexity</td>
                                                <td>O(n)</td>
                                                <td>O(log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Requires Sorted</td>
                                                <td>No ✓</td>
                                                <td>Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Works on Any Array</td>
                                                <td>Yes ✓</td>
                                                <td>Sorted only</td>
                                            </tr>
                                            <tr>
                                                <td>Implementation</td>
                                                <td>Very simple ✓</td>
                                                <td>Medium</td>
                                            </tr>
                                            <tr>
                                                <td>Best For</td>
                                                <td>Small or unsorted</td>
                                                <td>Large and sorted ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <h4>The Trade-off</h4>
                                        <p><strong>Linear Search is slower BUT more flexible:</strong></p>
                                        <ul>
                                            <li>Binary Search: 50,000x faster for 1M elements</li>
                                            <li>But requires sorted data (sorting costs O(n log n))</li>
                                            <li>Linear Search: Works on ANY array immediately</li>
                                            <li>For unsorted data: Linear Search is the ONLY option!</li>
                                        </ul>
                                    </div>

                                    <h2>When to Use Linear Search</h2>

                                    <div class="success-box">
                                        <h4>✅ Perfect For:</h4>
                                        <ul>
                                            <li><strong>Unsorted arrays:</strong> Only option!</li>
                                            <li><strong>Small arrays:</strong>
                                                < 10 elements, fast enough</li>
                                            <li><strong>Single search:</strong> Not worth sorting first</li>
                                            <li><strong>Linked lists:</strong> Can't use Binary Search</li>
                                            <li><strong>Simplicity matters:</strong> Easy to implement and debug</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li><strong>Large sorted arrays:</strong> Use Binary Search instead</li>
                                            <li><strong>Many searches:</strong> Sort once, Binary Search many times</li>
                                            <li><strong>Performance critical:</strong> O(n) too slow for large data</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Linear Search is the <strong>baseline searching algorithm</strong>:</p>
                                        <ul>
                                            <li>✅ O(n) - checks every element in worst case</li>
                                            <li>✅ Simplest - easiest to understand and implement</li>
                                            <li>✅ Flexible - works on ANY array (sorted or not)</li>
                                            <li>✅ Foundation - basis for understanding search algorithms</li>
                                            <li>⚠️ Slow for large data - O(n) doesn't scale well</li>
                                            <li>⚠️ But ONLY option for unsorted data!</li>
                                        </ul>
                                        <p><strong>Know when to use it vs Binary Search!</strong></p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Linear Search Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Check each element sequentially until found
                                            </li>
                                            <li><strong>Complexity:</strong> O(n) - simple but slow for large data</li>
                                            <li><strong>Use when:</strong> Unsorted data or small arrays</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Linear
                                            Search as the baseline. Explain it's O(n), works on any array, but Binary
                                            Search is O(log n) for sorted data. Show you understand the trade-offs!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've learned both major search algorithms! Next: <strong>Binary Search
                                            Variants</strong> - solving interview problems with binary search
                                        techniques.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement Linear Search from scratch. Try the
                                        sentinel optimization. Compare performance with Binary Search on sorted arrays!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="binary-search.jsp" />
                                    <jsp:param name="prevTitle" value="Binary Search" />
                                    <jsp:param name="nextLink" value="binary-search-variants.jsp" />
                                    <jsp:param name="nextTitle" value="Binary Search Variants" />
                                    <jsp:param name="currentLessonId" value="linear-search" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/linear-search-viz.js"></script>
        </body>

        </html>