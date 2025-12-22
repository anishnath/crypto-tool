<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "heaps" ); request.setAttribute("currentModule", "Trees" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Heaps & Priority Queue | DSA Tutorial</title>
            <meta name="description"
                content="Master heaps - efficient priority queue implementation. Learn min/max heaps, insert, extract, and heapify operations.">
            <meta name="keywords" content="heap, priority queue, min heap, max heap, heapify, heap sort, binary heap">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/heaps.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="heaps">
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
                                    <span>Heaps & Priority Queue</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔥 Heaps & Priority Queue</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine a hospital emergency room. Patients aren't treated
                                        first-come-first-served - they're prioritized by urgency. Critical cases go
                                        first, minor injuries wait. This is exactly what a <strong>heap</strong> does -
                                        it efficiently manages priorities!</p>

                                    <h2>The Priority Problem</h2>

                                    <p>Many real-world scenarios need priority-based processing:</p>

                                    <div class="info-box">
                                        <h4>Real-World Priority Systems</h4>
                                        <ul>
                                            <li><strong>Emergency Room:</strong> Treat critical patients first</li>
                                            <li><strong>Task Scheduler:</strong> Run high-priority tasks first</li>
                                            <li><strong>Network Routing:</strong> Send urgent packets first</li>
                                            <li><strong>Event Systems:</strong> Process events by timestamp</li>
                                        </ul>
                                    </div>

                                    <p>We need a data structure that can:</p>
                                    <ul>
                                        <li>Quickly find the highest priority item</li>
                                        <li>Efficiently add new items</li>
                                        <li>Remove the highest priority item</li>
                                    </ul>

                                    <h2>The Heap Solution</h2>

                                    <div class="success-box">
                                        <h4>What is a Heap?</h4>
                                        <p>A <strong>heap</strong> is a complete binary tree with a special property:
                                        </p>
                                        <ul>
                                            <li><strong>Min Heap:</strong> Parent ≤ children (root is minimum)</li>
                                            <li><strong>Max Heap:</strong> Parent ≥ children (root is maximum)</li>
                                        </ul>
                                        <p><strong>Key insight:</strong> Root is always the min/max - O(1) access!</p>
                                    </div>

                                    <h3>See the Structure</h3>
                                    <div id="heapsVisualization"></div>

                                    <h2>Why Heaps Are Brilliant</h2>

                                    <div class="info-box">
                                        <h4>The Magic of Array Storage</h4>
                                        <p>Heaps are stored in arrays - no pointers needed!</p>
                                        <p><strong>Parent of i:</strong> (i - 1) / 2</p>
                                        <p><strong>Left child of i:</strong> 2i + 1</p>
                                        <p><strong>Right child of i:</strong> 2i + 2</p>
                                        <p>This makes heaps incredibly space-efficient!</p>
                                    </div>

                                    <h2>Basic Operations</h2>

                                    <h3>1. Insert (Bubble Up)</h3>
                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Add new element to end of array</li>
                                            <li>Compare with parent</li>
                                            <li>If smaller (min heap), swap with parent</li>
                                            <li>Repeat until heap property restored</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(log n) - at most h swaps where h = height</p>
                                    </div>

                                    <h3>2. Extract Min/Max (Bubble Down)</h3>
                                    <div class="success-box">
                                        <h4>How It Works</h4>
                                        <ol>
                                            <li>Save root (min/max value)</li>
                                            <li>Move last element to root</li>
                                            <li>Compare with children</li>
                                            <li>Swap with smaller child (min heap)</li>
                                            <li>Repeat until heap property restored</li>
                                        </ol>
                                        <p><strong>Time:</strong> O(log n)</p>
                                    </div>

                                    <h3>3. Heapify (Build Heap)</h3>
                                    <div class="success-box">
                                        <h4>Build Heap from Array</h4>
                                        <p>Start from last non-leaf node, heapify down</p>
                                        <p><strong>Time:</strong> O(n) - surprisingly faster than n inserts!</p>
                                        <p><strong>Why O(n)?</strong> Most nodes are near bottom, require few swaps</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/heaps.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-heaps" />
                                    </jsp:include>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Heaps Are Used</h4>
                                        <ul>
                                            <li><strong>Priority Queues:</strong> Task scheduling, event systems</li>
                                            <li><strong>Dijkstra's Algorithm:</strong> Finding shortest paths</li>
                                            <li><strong>Heap Sort:</strong> O(n log n) sorting</li>
                                            <li><strong>Top K Problems:</strong> Find K largest/smallest elements</li>
                                            <li><strong>Median Maintenance:</strong> Running median from stream</li>
                                            <li><strong>Operating Systems:</strong> Process scheduling</li>
                                        </ul>
                                    </div>

                                    <h2>Min Heap vs Max Heap</h2>

                                    <div class="info-box">
                                        <h4>When to Use Each</h4>
                                        <p><strong>Min Heap:</strong></p>
                                        <ul>
                                            <li>Find minimum quickly</li>
                                            <li>Dijkstra's algorithm (shortest path)</li>
                                            <li>Merge K sorted lists</li>
                                        </ul>
                                        <p><strong>Max Heap:</strong></p>
                                        <ul>
                                            <li>Find maximum quickly</li>
                                            <li>Find K largest elements</li>
                                            <li>Heap sort (descending order)</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Heaps are efficient priority-based data structures:</p>
                                        <ol>
                                            <li><strong>Structure:</strong> Complete binary tree in array</li>
                                            <li><strong>Property:</strong> Parent ≤ children (min) or ≥ (max)</li>
                                            <li><strong>Insert:</strong> Add to end, bubble up - O(log n)</li>
                                            <li><strong>Extract:</strong> Remove root, bubble down - O(log n)</li>
                                            <li><strong>Heapify:</strong> Build heap from array - O(n)</li>
                                            <li><strong>Peek:</strong> Get min/max - O(1)</li>
                                            <li><strong>Applications:</strong> Priority queues, sorting, algorithms</li>
                                        </ol>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered heaps! Next, we'll explore <strong>heap applications</strong> -
                                        solving real problems like finding K largest elements, heap sort, and
                                        maintaining running median!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="tree-problems.jsp" />
                                    <jsp:param name="prevTitle" value="Tree Problems" />
                                    <jsp:param name="nextLink" value="heap-applications.jsp" />
                                    <jsp:param name="nextTitle" value="Heap Applications" />
                                    <jsp:param name="currentLessonId" value="heaps" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/heaps-viz.js"></script>
        </body>

        </html>