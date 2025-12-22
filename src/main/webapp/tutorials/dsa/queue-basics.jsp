<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "queue-basics" ); request.setAttribute("currentModule", "Stacks & Queues"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Queue Basics - FIFO Data Structure | DSA Tutorial</title>
            <meta name="description"
                content="Master Queue basics - FIFO principle, circular array, enqueue/dequeue operations. Essential for BFS and scheduling!">
            <meta name="keywords" content="queue data structure, FIFO, circular queue, enqueue dequeue, BFS">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/queue-basics.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="queue-basics">
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
                                    <span>Queue Basics</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎫 Queue Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner to Intermediate</span>
                                        <span>~20 min read</span>
                                        <span class="interview-badge">⭐ Essential</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine waiting in line at a store - first person in line gets
                                        served first! That's exactly how a <strong>Queue</strong> works. It's a
                                        <strong>FIFO (First In, First Out)</strong> data structure where the first
                                        element added is the first one removed. Queues power BFS, task scheduling,
                                        buffering, and more!</p>
                                    <div class="warning-box">
                                        <h4>🎯 Why Queues Matter!</h4>
                                        <p><strong>Queues are EVERYWHERE:</strong></p>
                                        <ul>
                                            <li>✅ <strong>BFS</strong> - Breadth-First Search (level-by-level)</li>
                                            <li>✅ <strong>Task Scheduling</strong> - CPU, print queue, requests</li>
                                            <li>✅ <strong>Buffering</strong> - IO, streaming, network packets</li>
                                            <li>✅ <strong>Customer Service</strong> - First come, first served</li>
                                            <li>✅ <strong>Async Processing</strong> - Message queues, job queues</li>
                                        </ul>
                                        <p><strong>All operations are O(1) - super efficient!</strong></p>
                                    </div>
                                    <h2>The FIFO Principle</h2>
                                    <div class="success-box">
                                        <h4>First In, First Out</h4>
                                        <p><strong>Think of a line at a store:</strong></p>
                                        <pre><code>Enqueue (join line):
  [Person 1] ← First in (at front)
  [Person 2]
  [Person 3] ← Last in (at rear)

Dequeue (serve):
  Serve Person 1 first (first in, first out!)
  Then Person 2
  Then Person 3</code></pre>
                                        <p><strong>Key insight:</strong> Add at rear, remove from front!</p>
                                    </div>
                                    <h3>See It in Action</h3>
                                    <div id="queueBasicsVisualization"></div>
                                    <h2>Queue Operations</h2>
                                    <div class="info-box">
                                        <h4>Three Core Operations</h4>
                                        <h5>1. Enqueue - Add to Rear</h5>
                                        <pre><code class="language-python">queue.enqueue(10)  # Add 10 to rear
queue.enqueue(20)  # Add 20 to rear</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>
                                        <h5>2. Dequeue - Remove from Front</h5>
                                        <pre><code class="language-python">value = queue.dequeue()  # Remove from front (10)
# Now front is 20</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>
                                        <h5>3. Peek - View Front</h5>
                                        <pre><code class="language-python">front = queue.peek()  # View front without removing</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>
                                    </div>
                                    <h2>Implementation: Circular Array</h2>
                                    <div class="success-box">
                                        <h4>Why Circular?</h4>
                                        <p>Prevents wasted space! Front and rear wrap around.</p>
                                        <pre><code class="language-python">class QueueArray:
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
                                        <p><strong>Key:</strong> Use modulo (%) for circular wrapping!</p>
                                    </div>
                                    <h2>Queue vs Stack</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Queue (FIFO)</th>
                                                <th>Stack (LIFO)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Principle</td>
                                                <td>First In, First Out</td>
                                                <td>Last In, First Out</td>
                                            </tr>
                                            <tr>
                                                <td>Add</td>
                                                <td>Enqueue (rear)</td>
                                                <td>Push (top)</td>
                                            </tr>
                                            <tr>
                                                <td>Remove</td>
                                                <td>Dequeue (front)</td>
                                                <td>Pop (top)</td>
                                            </tr>
                                            <tr>
                                                <td>Access Points</td>
                                                <td>Two (front & rear)</td>
                                                <td>One (top)</td>
                                            </tr>
                                            <tr>
                                                <td>Use Case</td>
                                                <td>BFS, scheduling</td>
                                                <td>DFS, undo/redo</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/queue-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-queue" />
                                    </jsp:include>
                                    <h2>Real-World Applications</h2>
                                    <div class="info-box">
                                        <h4>Where Queues Are Used</h4>
                                        <h5>1. BFS (Breadth-First Search)</h5>
                                        <ul>
                                            <li>Level-by-level traversal</li>
                                            <li>Shortest path in unweighted graphs</li>
                                        </ul>
                                        <h5>2. Task Scheduling</h5>
                                        <ul>
                                            <li>CPU scheduling (Round Robin)</li>
                                            <li>Print queue</li>
                                            <li>Request handling</li>
                                        </ul>
                                        <h5>3. Buffering</h5>
                                        <ul>
                                            <li>IO buffers</li>
                                            <li>Streaming data</li>
                                            <li>Network packets</li>
                                        </ul>
                                    </div>
                                    <h2>Interview Tips</h2>
                                    <div class="tip-box">
                                        <h4>💡 How to Ace Queue Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Always mention FIFO!</strong></li>
                                            <li>✅ <strong>Circular array:</strong> Explain modulo wrapping</li>
                                            <li>✅ <strong>All operations O(1)</strong></li>
                                            <li>✅ <strong>Queue vs Stack:</strong> Know differences</li>
                                            <li>✅ <strong>Common follow-up:</strong> Implement using stacks</li>
                                            <li>✅ <strong>Know BFS:</strong> Queue is essential!</li>
                                        </ul>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Queue Basics Mastery</h3>
                                        <ol>
                                            <li><strong>FIFO Principle:</strong> First In, First Out</li>
                                            <li><strong>Operations:</strong> Enqueue (rear), Dequeue (front), Peek (all
                                                O(1))</li>
                                            <li><strong>Circular Array:</strong> Use modulo for wrapping</li>
                                            <li><strong>Applications:</strong> BFS, scheduling, buffering</li>
                                            <li><strong>vs Stack:</strong> FIFO vs LIFO, two access points vs one</li>
                                        </ol>
                                    </div>
                                    <h2>What's Next?</h2>
                                    <p>You've mastered queue basics! Next: <strong>Queue Variations</strong> - Circular
                                        Queue, Deque, Priority Queue!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="stack-applications.jsp" />
                                    <jsp:param name="prevTitle" value="Stack Applications" />
                                    <jsp:param name="nextLink" value="queue-variations.jsp" />
                                    <jsp:param name="nextTitle" value="Queue Variations" />
                                    <jsp:param name="currentLessonId" value="queue-basics" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/queue-basics-viz.js"></script>
        </body>

        </html>