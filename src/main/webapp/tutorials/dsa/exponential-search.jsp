<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exponential-search" );
        request.setAttribute("currentModule", "Searching Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Exponential Search - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Exponential Search - O(log n) for unbounded arrays. Perfect for infinite streams and unknown array sizes.">
            <meta name="keywords" content="exponential search, unbounded array, infinite stream, O(log n), DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Exponential Search - DSA Tutorial">
            <meta property="og:description" content="Master Exponential Search for unbounded and infinite arrays.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/exponential-search.jsp">
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
        "name": "Exponential Search Algorithm",
        "description": "Learn Exponential Search for unbounded arrays and infinite streams - O(log n) complexity.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Exponential Search", "Unbounded Arrays", "Infinite Streams", "O(log n)"],
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

        <body class="tutorial-body no-preview" data-lesson="exponential-search">
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
                                    <span>Exponential Search</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">∞ Exponential Search</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Searching in a log file that's still being written? Don't know the
                                        array size? <strong>Exponential Search</strong> to the rescue! It combines
                                        doubling to find a range, then Binary Search within that range. Perfect for
                                        unbounded or infinite arrays!</p>

                                    <h2>The Infinite Stream Problem</h2>

                                    <p>Imagine searching in data where you don't know the size:</p>

                                    <div class="info-box">
                                        <h4>The Challenge</h4>
                                        <p><strong>Scenario:</strong> Log file being written in real-time, infinite data
                                            stream, or unknown array size.</p>
                                        <p><strong>Problem:</strong> Binary Search needs to know the array size!</p>
                                        <p><strong>Solution:</strong> Exponential Search!</p>
                                        <ol>
                                            <li><strong>Phase 1:</strong> Find range by doubling (1, 2, 4, 8, 16, ...)
                                            </li>
                                            <li><strong>Phase 2:</strong> Binary Search in found range</li>
                                        </ol>
                                    </div>

                                    <h3>The Doubling Strategy</h3>

                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <p><strong>Step 1: Find Range</strong></p>
                                        <pre><code>Check index 1, then 2, then 4, then 8, then 16, ...
Stop when arr[i] > target or reached end</code></pre>
                                        <p><strong>Step 2: Binary Search</strong></p>
                                        <pre><code>Search in range [i/2, i] using Binary Search</code></pre>
                                        <p><strong>Why doubling?</strong> Ensures O(log n) - we check at most log₂(n)
                                            positions!</p>
                                    </div>

                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/exponential-search-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-exponential" />
                                    </jsp:include>

                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is Exponential Search O(log n)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Phase 1 (doubling) checks at most log₂(n) positions: 1, 2, 4, 8, ..., n.
                                                Phase 2 (binary search) is O(log n). Total: O(log n) + O(log n) = O(log
                                                n)!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When is Exponential Search better than Binary Search?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                When target is near the beginning! If target is at index 8 in a
                                                1000-element array, Exponential finds it in ~3 steps (1→2→4→8), while
                                                Binary needs ~10 steps. Also essential when array size is unknown!
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
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Best</td>
                                                <td>O(1)</td>
                                                <td>Target at index 0 or 1</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(log n)</td>
                                                <td>Doubling + Binary Search</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(log n)</td>
                                                <td>Same as Binary Search</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>No extra space needed</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Exponential vs Binary Search</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Binary Search</th>
                                                <th>Exponential Search</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Time Complexity</td>
                                                <td>O(log n)</td>
                                                <td>O(log n)</td>
                                            </tr>
                                            <tr>
                                                <td>Needs Array Size</td>
                                                <td>Yes</td>
                                                <td>No ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Unbounded Arrays</td>
                                                <td>Can't handle</td>
                                                <td>Perfect! ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Target Near Start</td>
                                                <td>~log n steps</td>
                                                <td>Very few steps ✓</td>
                                            </tr>
                                            <tr>
                                                <td>General Use</td>
                                                <td>Better ✓</td>
                                                <td>Specialized</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>When to Use</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Exponential Search When:</h4>
                                        <ul>
                                            <li><strong>Unbounded arrays:</strong> Don't know the size</li>
                                            <li><strong>Infinite streams:</strong> Data keeps coming</li>
                                            <li><strong>Target likely near start:</strong> Much faster than Binary</li>
                                            <li><strong>Log files:</strong> Searching while file grows</li>
                                            <li><strong>Real-time data:</strong> Streaming applications</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Use Binary Search Instead When:</h4>
                                        <ul>
                                            <li><strong>Known array size:</strong> Binary is simpler</li>
                                            <li><strong>Target position unknown:</strong> No advantage</li>
                                            <li><strong>Standard sorted array:</strong> Binary is standard</li>
                                        </ul>
                                    </div>

                                    <h2>Real-World Applications</h2>

                                    <div class="success-box">
                                        <h4>Where Exponential Search Shines</h4>
                                        <ul>
                                            <li><strong>Log file analysis:</strong> Find first error in growing log</li>
                                            <li><strong>Debugging:</strong> Find first occurrence in trace</li>
                                            <li><strong>Streaming data:</strong> Search in infinite stream</li>
                                            <li><strong>Database cursors:</strong> Unknown result set size</li>
                                            <li><strong>Network packets:</strong> Search in continuous stream</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Exponential Search is <strong>Binary Search for the unknown</strong>:</p>
                                        <ul>
                                            <li>✅ O(log n) - same as Binary Search</li>
                                            <li>✅ Works without knowing array size!</li>
                                            <li>✅ Faster when target is near beginning</li>
                                            <li>✅ Perfect for unbounded/infinite arrays</li>
                                            <li>✅ Combines doubling + Binary Search</li>
                                        </ul>
                                        <p><strong>Use when you don't know the size or target is likely near the
                                                start!</strong></p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Exponential Search Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Double to find range, then Binary Search</li>
                                            <li><strong>Complexity:</strong> O(log n) - same as Binary Search</li>
                                            <li><strong>Use when:</strong> Unbounded arrays or target near start</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Exponential
                                            Search for unbounded array problems. Explain the two phases: doubling to
                                            find range (1,2,4,8,...) then Binary Search. Show you know specialized
                                            search algorithms!</p>
                                    </div>

                                    <h2>Congratulations!</h2>
                                    <p>🎉 <strong>You've completed Module 4: Searching Algorithms!</strong></p>

                                    <div class="success-box">
                                        <h4>You Now Master:</h4>
                                        <ul>
                                            <li>✅ Binary Search - O(log n) foundation</li>
                                            <li>✅ Linear Search - O(n) baseline</li>
                                            <li>✅ Binary Search Variants - Interview favorites</li>
                                            <li>✅ Interpolation Search - O(log log n) for uniform data</li>
                                            <li>✅ Exponential Search - For unbounded arrays</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>5 search algorithms - interview
                                                ready!</strong></p>
                                    </div>

                                    <p>Next up: <strong>Module 5: Linked Lists</strong> - pointer-based data structures!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="interpolation-search.jsp" />
                                    <jsp:param name="prevTitle" value="Interpolation Search" />
                                    <jsp:param name="nextLink" value="linked-list-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Singly Linked List" />
                                    <jsp:param name="currentLessonId" value="exponential-search" />
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