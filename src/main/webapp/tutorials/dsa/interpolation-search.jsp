<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "interpolation-search" );
        request.setAttribute("currentModule", "Searching Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Interpolation Search - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Interpolation Search - O(log log n) for uniformly distributed data. Better than Binary Search for phone books and dictionaries.">
            <meta name="keywords"
                content="interpolation search, O(log log n), uniform distribution, phone book search, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Interpolation Search - DSA Tutorial">
            <meta property="og:description"
                content="Master Interpolation Search - faster than Binary Search for uniform data.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/interpolation-search.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

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
        "name": "Interpolation Search Algorithm",
        "description": "Learn Interpolation Search - O(log log n) for uniformly distributed data.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Interpolation Search", "O(log log n)", "Uniform Distribution"],
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

        <body class="tutorial-body no-preview" data-lesson="interpolation-search">
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
                                    <span>Interpolation Search</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">📞 Interpolation Search</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Looking for "Smith" in a phone book? You don't open to the middle -
                                        you go near the end! That's <strong>Interpolation Search</strong> - it makes
                                        smart guesses based on the value you're searching for. For uniformly distributed
                                        data, it's even faster than Binary Search!</p>

                                    <h2>The Phone Book Strategy</h2>

                                    <p>Imagine searching for a name in a phone book:</p>

                                    <div class="info-box">
                                        <h4>Smart vs Naive</h4>
                                        <p><strong>Binary Search:</strong> Always opens to the middle, regardless of
                                            what you're searching for.</p>
                                        <p><strong>Interpolation Search:</strong> Makes an educated guess!</p>
                                        <ul>
                                            <li>Searching for "Adams"? → Start near beginning</li>
                                            <li>Searching for "Smith"? → Start near end</li>
                                            <li>Searching for "Miller"? → Start in middle</li>
                                        </ul>
                                        <p><strong>Key insight:</strong> Use the VALUE to estimate POSITION!</p>
                                    </div>

                                    <h3>The Formula</h3>

                                    <div class="success-box">
                                        <h4>Interpolation Formula</h4>
                                        <pre><code>pos = left + ((target - arr[left]) / (arr[right] - arr[left])) × (right - left)</code></pre>
                                        <p><strong>Intuition:</strong></p>
                                        <ul>
                                            <li>How far is target from left value? → <code>(target - arr[left])</code>
                                            </li>
                                            <li>What's the total range of values? →
                                                <code>(arr[right] - arr[left])</code></li>
                                            <li>Proportion × array length = estimated position!</li>
                                        </ul>
                                    </div>

                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/interpolation-search-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-interpolation" />
                                    </jsp:include>

                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is Interpolation Search O(log log n) for uniform data?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                For uniformly distributed data, each guess gets us very close to the
                                                target. Instead of halving the search space (log n), we reduce it much
                                                faster (log log n). Example: For 1 million elements, Binary Search needs
                                                ~20 steps, Interpolation needs ~5-6!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When does Interpolation Search perform poorly?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                When data is NOT uniformly distributed! Example: [1, 2, 3, 4, 5, 1000,
                                                2000, 3000]. The gap causes bad estimates, potentially O(n) worst case.
                                                Always use Binary Search if distribution is unknown!
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
                                                <td>First guess is correct</td>
                                            </tr>
                                            <tr>
                                                <td>Average (uniform)</td>
                                                <td>O(log log n) ✓</td>
                                                <td>Uniformly distributed data</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n)</td>
                                                <td>Non-uniform distribution</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>No extra space</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Interpolation vs Binary Search</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Binary Search</th>
                                                <th>Interpolation Search</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Best Case</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                            </tr>
                                            <tr>
                                                <td>Average (uniform)</td>
                                                <td>O(log n)</td>
                                                <td>O(log log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Worst Case</td>
                                                <td>O(log n) ✓</td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td>Requires</td>
                                                <td>Sorted array</td>
                                                <td>Sorted + uniform ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Predictable</td>
                                                <td>Yes ✓</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Best For</td>
                                                <td>General use ✓</td>
                                                <td>Uniform data ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>When to Use</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Interpolation Search When:</h4>
                                        <ul>
                                            <li><strong>Uniformly distributed data:</strong> Phone books, dictionaries
                                            </li>
                                            <li><strong>Large datasets:</strong> 1M+ elements where O(log log n) matters
                                            </li>
                                            <li><strong>Sequential IDs:</strong> User IDs, order numbers</li>
                                            <li><strong>Known distribution:</strong> You know data is uniform</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Use Binary Search Instead When:</h4>
                                        <ul>
                                            <li><strong>Unknown distribution:</strong> Can't verify uniformity</li>
                                            <li><strong>Non-uniform data:</strong> Gaps or clusters in values</li>
                                            <li><strong>Small datasets:</strong>
                                                < 10K elements, difference negligible</li>
                                            <li><strong>Safety matters:</strong> Need predictable O(log n)</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Interpolation Search is <strong>Binary Search's smarter cousin</strong>:</p>
                                        <ul>
                                            <li>✅ O(log log n) for uniform data - faster than Binary!</li>
                                            <li>✅ Makes educated guesses based on values</li>
                                            <li>✅ Perfect for phone books, dictionaries</li>
                                            <li>⚠️ O(n) worst case for non-uniform data</li>
                                            <li>⚠️ Only use when distribution is known</li>
                                        </ul>
                                        <p><strong>Rule of thumb: If in doubt, use Binary Search!</strong></p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Interpolation Search Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Estimate position using value proportion</li>
                                            <li><strong>Complexity:</strong> O(log log n) for uniform, O(n) worst case
                                            </li>
                                            <li><strong>Use when:</strong> Large uniform datasets (phone books!)</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention
                                            Interpolation Search as an optimization for Binary Search when data is
                                            uniformly distributed. Explain the trade-off: faster average but worse
                                            worst-case!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Exponential Search</strong> - for unbounded or infinite arrays!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="binary-search-variants.jsp" />
                                    <jsp:param name="prevTitle" value="Binary Search Variants" />
                                    <jsp:param name="nextLink" value="exponential-search.jsp" />
                                    <jsp:param name="nextTitle" value="Exponential Search" />
                                    <jsp:param name="currentLessonId" value="interpolation-search" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>