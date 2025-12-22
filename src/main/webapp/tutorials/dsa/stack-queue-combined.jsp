<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "stack-queue-combined" );
        request.setAttribute("currentModule", "Stacks & Queues" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Combined Stack & Queue Problems | DSA Tutorial</title>
            <meta name="description"
                content="Master advanced stack & queue problems - Queue using Stacks, Next Greater Element, Min Stack. FAANG interview favorites!">
            <meta name="keywords"
                content="queue using stacks, next greater element, min stack, monotonic stack, interview questions">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/stack-queue-combined.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="stack-queue-combined">
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
                                    <span>Combined Problems</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🚀 Combined Stack & Queue Problems</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                        <span class="interview-badge">⭐⭐⭐ FAANG Favorites</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Time to combine everything! These <strong>advanced problems</strong>
                                        use stacks and queues together to solve complex challenges. Master Queue using
                                        Stacks, Next Greater Element, Min Stack - THE most common stack/queue interview
                                        questions at Google, Amazon, Microsoft!</p>
                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert - Top 6 Problems!</h4>
                                        <p><strong>These appear in 90% of stack/queue interviews:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Queue using Stacks</strong> - O(1) amortized (Very Common!)
                                            </li>
                                            <li>✅ <strong>Next Greater Element</strong> - Monotonic stack (Essential!)
                                            </li>
                                            <li>✅ <strong>Min Stack</strong> - O(1) getMin (Classic!)</li>
                                            <li>✅ <strong>Sliding Window Maximum</strong> - Monotonic deque</li>
                                            <li>✅ <strong>Valid Parentheses</strong> - Stack matching</li>
                                            <li>✅ <strong>Stack using Queues</strong> - Design problem</li>
                                        </ul>
                                    </div>
                                    <h2>Problem 1: Queue using Two Stacks ⭐⭐⭐</h2>
                                    <div class="success-box">
                                        <h4>THE Most Common Design Question!</h4>
                                        <p><strong>Challenge:</strong> Implement queue using only stacks</p>
                                        <pre><code class="language-python">class QueueUsingStacks:
    def __init__(self):
        self.stack1 = []  # For enqueue
        self.stack2 = []  # For dequeue
    
    def enqueue(self, item):
        self.stack1.append(item)  # O(1)
    
    def dequeue(self):
        if not self.stack2:
            # Transfer from stack1 to stack2
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        return self.stack2.pop()  # O(1) amortized</code></pre>
                                        <p><strong>Time:</strong> O(1) amortized for both operations!</p>
                                        <p><strong>Key insight:</strong> Transfer only when stack2 is empty</p>
                                    </div>
                                    <h3>See Problems in Action</h3>
                                    <div id="combinedVisualization"></div>
                                    <h2>Problem 2: Next Greater Element ⭐⭐⭐</h2>
                                    <div class="success-box">
                                        <h4>Monotonic Stack Pattern!</h4>
                                        <p><strong>Challenge:</strong> Find next greater element for each element</p>
                                        <pre><code class="language-python">def next_greater_element(arr):
    result = [-1] * len(arr)
    stack = []  # Stores indices
    
    for i in range(len(arr)):
        # Pop smaller elements
        while stack and arr[stack[-1]] < arr[i]:
            idx = stack.pop()
            result[idx] = arr[i]
        stack.append(i)
    
    return result</code></pre>
                                        <p><strong>Example:</strong> [4, 5, 2, 25] → [5, 25, 25, -1]</p>
                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(n)</p>
                                    </div>
                                    <h2>Problem 3: Min Stack ⭐⭐</h2>
                                    <div class="success-box">
                                        <h4>O(1) getMin!</h4>
                                        <pre><code class="language-python">class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []  # Tracks minimums
    
    def push(self, item):
        self.stack.append(item)
        if not self.min_stack or item <= self.min_stack[-1]:
            self.min_stack.append(item)
    
    def pop(self):
        item = self.stack.pop()
        if item == self.min_stack[-1]:
            self.min_stack.pop()
        return item
    
    def get_min(self):
        return self.min_stack[-1]  # O(1)!</code></pre>
                                        <p><strong>All operations O(1)!</strong></p>
                                    </div>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/stack-queue-combined.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-combined" />
                                    </jsp:include>
                                    <h2>Interview Tips</h2>
                                    <div class="tip-box">
                                        <h4>💡 How to Ace Combined Problems</h4>
                                        <ul>
                                            <li>✅ <strong>Queue using Stacks:</strong> Explain amortized O(1)</li>
                                            <li>✅ <strong>Next Greater:</strong> Monotonic stack is KEY!</li>
                                            <li>✅ <strong>Min Stack:</strong> Auxiliary stack pattern</li>
                                            <li>✅ <strong>Practice these 6 problems</strong> - they're VERY common!</li>
                                            <li>✅ <strong>Know time complexities</strong> - interviewers will ask!</li>
                                        </ul>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Combined Problems Mastery</h3>
                                        <ol>
                                            <li><strong>Queue using Stacks:</strong> O(1) amortized with two stacks</li>
                                            <li><strong>Next Greater Element:</strong> Monotonic stack pattern</li>
                                            <li><strong>Min Stack:</strong> Auxiliary stack for O(1) getMin</li>
                                            <li><strong>Sliding Window Max:</strong> Monotonic deque</li>
                                            <li><strong>Valid Parentheses:</strong> Stack matching</li>
                                            <li><strong>These are FAANG favorites!</strong> Practice them!</li>
                                        </ol>
                                    </div>
                                    <div class="success-box">
                                        <h3>🎉 Congratulations - Module 6 Complete!</h3>
                                        <p>You've mastered <strong>Stacks & Queues</strong>!</p>
                                        <p><strong>What you learned:</strong></p>
                                        <ul>
                                            <li>✅ Stack Basics (LIFO, operations)</li>
                                            <li>✅ Stack Applications (balanced parentheses, expression eval)</li>
                                            <li>✅ Queue Basics (FIFO, circular queue)</li>
                                            <li>✅ Queue Variations (deque, priority queue)</li>
                                            <li>✅ Combined Problems (advanced interview questions)</li>
                                        </ul>
                                        <p><strong>You're now ready for FAANG stack/queue interviews!</strong> 🚀</p>
                                    </div>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="queue-variations.jsp" />
                                    <jsp:param name="prevTitle" value="Queue Variations" />
                                    <jsp:param name="nextLink" value="hash-tables.jsp" />
                                    <jsp:param name="nextTitle" value="Hash Tables" />
                                    <jsp:param name="currentLessonId" value="stack-queue-combined" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/stack-queue-combined-viz.js"></script>
        </body>

        </html>