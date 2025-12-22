<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "queue-variations" );
        request.setAttribute("currentModule", "Stacks & Queues" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Queue Variations - Circular, Deque, Priority | DSA Tutorial</title>
            <meta name="description"
                content="Master queue variations - Circular Queue, Deque, Priority Queue, Sliding Window. Advanced queue types for interviews!">
            <meta name="keywords" content="circular queue, deque, priority queue, sliding window, monotonic deque">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/queue-variations.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="queue-variations">
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
                                    <span>Queue Variations</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Queue Variations</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate to Advanced</span>
                                        <span>~25 min read</span>
                                        <span class="interview-badge">⭐⭐ Interview Favorites</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Regular queues are great, but sometimes you need more! <strong>Queue
                                            variations</strong> solve specific problems: Circular Queue for fixed
                                        buffers, Deque for sliding windows, Priority Queue for scheduling. Master these
                                        for advanced interviews!</p>
                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert - 3 Essential Variations!</h4>
                                        <p><strong>Master these:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Circular Queue</strong> - Fixed-size buffers, round-robin</li>
                                            <li>✅ <strong>Deque</strong> - Sliding window maximum (very common!)</li>
                                            <li>✅ <strong>Priority Queue</strong> - Dijkstra's, A*, scheduling</li>
                                        </ul>
                                    </div>
                                    <h2>Variation 1: Circular Queue</h2>
                                    <div class="success-box">
                                        <h4>Fixed Size, Wraps Around</h4>
                                        <p><strong>Key feature:</strong> Rear wraps to beginning when it reaches end</p>
                                        <pre><code class="language-python">class CircularQueue:
    def __init__(self, capacity):
        self.items = [None] * capacity
        self.front = 0
        self.rear = -1
        self.size = 0
    
    def enqueue(self, item):
        self.rear = (self.rear + 1) % self.capacity  # Wrap!
        self.items[self.rear] = item
        self.size += 1
    
    def dequeue(self):
        item = self.items[self.front]
        self.front = (self.front + 1) % self.capacity  # Wrap!
        self.size -= 1
        return item</code></pre>
                                        <p><strong>Use cases:</strong> Buffers, Round-robin scheduling</p>
                                    </div>
                                    <h3>See Variations in Action</h3>
                                    <div id="queueVariationsVisualization"></div>
                                    <h2>Variation 2: Deque (Double-Ended Queue)</h2>
                                    <div class="success-box">
                                        <h4>Add/Remove from BOTH Ends</h4>
                                        <p><strong>Operations:</strong></p>
                                        <ul>
                                            <li>add_front(), add_rear()</li>
                                            <li>remove_front(), remove_rear()</li>
                                        </ul>
                                        <pre><code class="language-python">from collections import deque

dq = deque()
dq.append(1)      # Add to rear
dq.appendleft(0)  # Add to front
dq.pop()          # Remove from rear
dq.popleft()      # Remove from front</code></pre>
                                        <p><strong>Use cases:</strong> Sliding window, palindrome check</p>
                                    </div>
                                    <h2>Variation 3: Priority Queue</h2>
                                    <div class="success-box">
                                        <h4>Highest Priority First</h4>
                                        <pre><code class="language-python">import heapq

pq = []
heapq.heappush(pq, (priority, item))
item = heapq.heappop(pq)  # Lowest value = highest priority</code></pre>
                                        <p><strong>Use cases:</strong> Dijkstra's, A*, task scheduling</p>
                                    </div>
                                    <h2>Application: Sliding Window Maximum</h2>
                                    <div class="info-box">
                                        <h4>THE Deque Interview Question!</h4>
                                        <p><strong>Problem:</strong> Find maximum in each window of size k</p>
                                        <pre><code class="language-python">def sliding_window_max(arr, k):
    dq = deque()  # Stores indices
    result = []
    
    for i in range(len(arr)):
        # Remove outside window
        while dq and dq[0] < i - k + 1:
            dq.popleft()
        
        # Remove smaller elements
        while dq and arr[dq[-1]] < arr[i]:
            dq.pop()
        
        dq.append(i)
        
        if i >= k - 1:
            result.append(arr[dq[0]])
    
    return result</code></pre>
                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(k)</p>
                                        <p><strong>Key:</strong> Monotonic decreasing deque!</p>
                                    </div>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/queue-variations.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-queue-var" />
                                    </jsp:include>
                                    <h2>Comparison Table</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Add</th>
                                                <th>Remove</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Regular Queue</td>
                                                <td>Rear only</td>
                                                <td>Front only</td>
                                                <td>BFS, buffering</td>
                                            </tr>
                                            <tr>
                                                <td>Circular Queue</td>
                                                <td>Rear (wrap)</td>
                                                <td>Front (wrap)</td>
                                                <td>Fixed buffer</td>
                                            </tr>
                                            <tr>
                                                <td>Deque</td>
                                                <td>Both ends</td>
                                                <td>Both ends</td>
                                                <td>Sliding window</td>
                                            </tr>
                                            <tr>
                                                <td>Priority Queue</td>
                                                <td>By priority</td>
                                                <td>Highest first</td>
                                                <td>Dijkstra, scheduling</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h2>Interview Tips</h2>
                                    <div class="tip-box">
                                        <h4>💡 How to Ace Queue Variation Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Circular Queue:</strong> Explain modulo wrapping</li>
                                            <li>✅ <strong>Deque:</strong> Use collections.deque for O(1) both ends</li>
                                            <li>✅ <strong>Priority Queue:</strong> Use heapq for O(log n)</li>
                                            <li>✅ <strong>Sliding Window:</strong> Monotonic deque pattern!</li>
                                            <li>✅ <strong>Know when to use each type</strong></li>
                                        </ul>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Queue Variations Mastery</h3>
                                        <ol>
                                            <li><strong>Circular Queue:</strong> Fixed size, wraps around</li>
                                            <li><strong>Deque:</strong> Operations at both ends</li>
                                            <li><strong>Priority Queue:</strong> Highest priority first</li>
                                            <li><strong>Sliding Window:</strong> Monotonic deque (O(n))</li>
                                            <li><strong>Choose wisely:</strong> Right tool for the job!</li>
                                        </ol>
                                    </div>
                                    <h2>What's Next?</h2>
                                    <p>You've mastered queue variations! Next: <strong>Combined Problems</strong> -
                                        Advanced stack & queue challenges!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="queue-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Queue Basics" />
                                    <jsp:param name="nextLink" value="stack-queue-combined.jsp" />
                                    <jsp:param name="nextTitle" value="Combined Problems" />
                                    <jsp:param name="currentLessonId" value="queue-variations" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/queue-variations-viz.js"></script>
        </body>

        </html>