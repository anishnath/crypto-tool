<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "heap-applications" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Heap Applications - Top K, Merge, Median | DSA Tutorial</title>
            <meta name="description"
                content="Master practical heap applications - K largest/smallest, merge K lists, running median, task scheduling, and meeting rooms.">
            <meta name="keywords"
                content="heap applications, top k, merge k lists, running median, priority queue problems, heap problems">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/heap-applications.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="heap-applications">
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
                                    <span>Heap Applications</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Heap Applications</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate to Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">You're running an e-commerce site. You need to show "Top 10
                                        Products," merge customer activity from multiple servers, and calculate
                                        real-time statistics. These aren't just coding problems - they're real business
                                        needs that heaps solve brilliantly!</p>

                                    <h2>Why Heaps Excel at These Problems</h2>

                                    <div class="info-box">
                                        <h4>The Heap Advantage</h4>
                                        <p>Heaps are perfect when you need:</p>
                                        <ul>
                                            <li><strong>Top K items:</strong> O(n log k) instead of O(n log n)</li>
                                            <li><strong>Streaming data:</strong> Process items one at a time</li>
                                            <li><strong>Priority-based:</strong> Always access min/max in O(1)</li>
                                            <li><strong>Space efficiency:</strong> O(k) space for top K problems</li>
                                        </ul>
                                    </div>

                                    <h3>See the Applications</h3>
                                    <div id="heapAppsVisualization"></div>

                                    <h2>Application 1: K Largest Elements</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find the K largest elements from a dataset.</p>
                                        <p><strong>Real-world:</strong> Top K products, highest scores, trending items,
                                            leaderboards</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution: Min Heap of Size K</h4>
                                        <p><strong>Key insight:</strong> Keep only K largest by maintaining a min heap
                                        </p>
                                        <ol>
                                            <li>Maintain min heap of size K</li>
                                            <li>For each element: add to heap</li>
                                            <li>If size > K, remove minimum</li>
                                            <li>Heap contains K largest!</li>
                                        </ol>
                                        <p><strong>Why min heap?</strong> Smallest of K largest is at top - easy to
                                            remove!</p>
                                        <p><strong>Time:</strong> O(n log k) vs O(n log n) for sorting</p>
                                    </div>

                                    <h2>Application 2: Merge K Sorted Lists</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Merge K sorted lists into one sorted list.</p>
                                        <p><strong>Real-world:</strong> Merge log files, combine sorted data streams,
                                            database operations</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution: Min Heap</h4>
                                        <ol>
                                            <li>Add first element from each list to min heap</li>
                                            <li>Pop minimum → add to result</li>
                                            <li>Add next element from same list</li>
                                            <li>Repeat until all elements processed</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(N log k) where N = total elements</p>
                                        <p><strong>Better than:</strong> Merging lists pairwise O(N k)</p>
                                    </div>

                                    <h2>Application 3: Running Median</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find median from a continuous stream of numbers.</p>
                                        <p><strong>Real-world:</strong> Real-time analytics, monitoring systems,
                                            streaming statistics</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution: Two Heaps!</h4>
                                        <p><strong>Brilliant insight:</strong> Use two heaps to split data</p>
                                        <ul>
                                            <li><strong>Max heap:</strong> Smaller half (largest at top)</li>
                                            <li><strong>Min heap:</strong> Larger half (smallest at top)</li>
                                        </ul>
                                        <p><strong>Invariant:</strong> Heap sizes differ by at most 1</p>
                                        <p><strong>Median:</strong> Top of larger heap (or average of both tops)</p>
                                        <p><strong>Time:</strong> O(log n) to add, O(1) to get median</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Application 4: Meeting Rooms</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Find minimum meeting rooms needed for given intervals.</p>
                                        <p><strong>Real-world:</strong> Conference room scheduling, resource allocation,
                                            CPU scheduling</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>The Solution: Min Heap of End Times</h4>
                                        <ol>
                                            <li>Sort meetings by start time</li>
                                            <li>Use min heap to track end times</li>
                                            <li>If earliest end ≤ current start, reuse room</li>
                                            <li>Otherwise, allocate new room</li>
                                            <li>Heap size = rooms needed</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(n log n)</p>
                                    </div>

                                    <h2>More Applications</h2>

                                    <h3>5. Top K Frequent Elements</h3>
                                    <p><strong>Use case:</strong> Trending topics, popular products</p>
                                    <p><strong>Solution:</strong> Count frequencies, use min heap of size K</p>

                                    <h3>6. Task Scheduler</h3>
                                    <p><strong>Use case:</strong> CPU scheduling with cooling periods</p>
                                    <p><strong>Solution:</strong> Max heap of task frequencies</p>

                                    <h3>7. Kth Largest in Stream</h3>
                                    <p><strong>Use case:</strong> Leaderboards, ranking systems</p>
                                    <p><strong>Solution:</strong> Min heap of size K, always O(1) access</p>

                                    <h3>8. K Closest Points</h3>
                                    <p><strong>Use case:</strong> Location-based services, nearest neighbors</p>
                                    <p><strong>Solution:</strong> Max heap of distances, size K</p>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/heap-applications.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-heap-apps" />
                                    </jsp:include>

                                    <h2>Problem-Solving Strategy</h2>

                                    <div class="success-box">
                                        <h4>When to Use Heaps</h4>
                                        <ul>
                                            <li><strong>"Top K" or "K largest/smallest":</strong> Use heap of size K
                                            </li>
                                            <li><strong>"Merge K sorted":</strong> Use min heap</li>
                                            <li><strong>"Median" or "middle element":</strong> Use two heaps</li>
                                            <li><strong>"Scheduling" or "intervals":</strong> Use heap of end times</li>
                                            <li><strong>"Stream processing":</strong> Heaps handle one-at-a-time</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Heaps solve many practical problems efficiently:</p>
                                        <ol>
                                            <li><strong>K Largest:</strong> Min heap of size K - O(n log k)</li>
                                            <li><strong>Merge K Lists:</strong> Min heap - O(N log k)</li>
                                            <li><strong>Running Median:</strong> Two heaps - O(log n) add, O(1) median
                                            </li>
                                            <li><strong>Meeting Rooms:</strong> Min heap of end times - O(n log n)</li>
                                            <li><strong>Pattern:</strong> "Top K" → heap of size K</li>
                                            <li><strong>Pattern:</strong> "Median/middle" → two heaps</li>
                                            <li><strong>Pattern:</strong> "Merge/combine" → min heap</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered heaps and their applications! Next, we'll explore
                                        <strong>Tries</strong> - a tree structure perfect for string problems like
                                        autocomplete and spell checking!
                                    </p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="heaps.jsp" />
                                    <jsp:param name="prevTitle" value="Heaps" />
                                    <jsp:param name="nextLink" value="tries.jsp" />
                                    <jsp:param name="nextTitle" value="Tries" />
                                    <jsp:param name="currentLessonId" value="heap-applications" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/heap-applications-viz.js"></script>
        </body>

        </html>