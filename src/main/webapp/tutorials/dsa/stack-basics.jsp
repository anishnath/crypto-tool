<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "stack-basics" ); request.setAttribute("currentModule", "Stacks & Queues"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Stack Basics - LIFO Data Structure | DSA Tutorial</title>
            <meta name="description"
                content="Master Stack basics - LIFO principle, push/pop/peek operations, array vs linked list implementations. Essential for function calls and expression evaluation!">
            <meta name="keywords"
                content="stack data structure, LIFO, push pop peek, stack implementation, function call stack">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Stack Basics - LIFO Data Structure">
            <meta property="og:description" content="Learn stack fundamentals with LIFO principle and O(1) operations!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/stack-basics.jsp">
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
        "name": "Stack Basics - LIFO Data Structure",
        "description": "Master stack fundamentals with LIFO principle, push/pop/peek operations, and implementations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["Stack Data Structure", "LIFO Principle", "Stack Operations", "Data Structures"],
        "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="stack-basics">
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
                                    <span>Stack Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">📚 Stack Basics</h1>
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
                                    <p class="lead">Imagine a stack of plates - you can only add or remove from the top!
                                        That's exactly how a <strong>Stack</strong> works. It's a <strong>LIFO (Last In,
                                            First Out)</strong> data structure where the last element added is the first
                                        one removed. Stacks power function calls, undo/redo, browser history, and
                                        expression evaluation!</p>

                                    <div class="warning-box">
                                        <h4>🎯 Why Stacks Matter!</h4>
                                        <p><strong>Stacks are EVERYWHERE:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Function calls</strong> - Every function call uses a stack!
                                            </li>
                                            <li>✅ <strong>Undo/Redo</strong> - Text editors, Photoshop, browsers</li>
                                            <li>✅ <strong>Expression evaluation</strong> - Calculators, compilers</li>
                                            <li>✅ <strong>Backtracking</strong> - Maze solving, Sudoku, DFS</li>
                                            <li>✅ <strong>Browser history</strong> - Back button navigation</li>
                                        </ul>
                                        <p><strong>All operations are O(1) - super efficient!</strong></p>
                                    </div>

                                    <h2>The LIFO Principle</h2>

                                    <div class="success-box">
                                        <h4>Last In, First Out</h4>
                                        <p><strong>Think of a stack of plates:</strong></p>
                                        <pre><code>Push (add) plates:
  [Plate 3] ← Last in (on top)
  [Plate 2]
  [Plate 1] ← First in (at bottom)

Pop (remove) plates:
  Remove Plate 3 first (last in, first out!)
  Then Plate 2
  Finally Plate 1</code></pre>

                                        <p><strong>Key insight:</strong> You can only access the TOP element!</p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch LIFO in action:</p>

                                    <div id="stackBasicsVisualization"></div>

                                    <h2>Stack Operations</h2>

                                    <div class="info-box">
                                        <h4>Three Core Operations</h4>

                                        <h5>1. Push - Add to Top</h5>
                                        <pre><code class="language-python">stack.push(10)  # Add 10 to top
stack.push(20)  # Add 20 to top (now top is 20)</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>

                                        <h5>2. Pop - Remove from Top</h5>
                                        <pre><code class="language-python">value = stack.pop()  # Remove and return top (20)
# Now top is 10</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>

                                        <h5>3. Peek - View Top (without removing)</h5>
                                        <pre><code class="language-python">top = stack.peek()  # View top without removing
# Stack unchanged</code></pre>
                                        <p><strong>Time:</strong> O(1), <strong>Space:</strong> O(1)</p>
                                    </div>

                                    <h2>Implementation 1: Array-based Stack</h2>

                                    <div class="success-box">
                                        <h4>Using Dynamic Array</h4>
                                        <pre><code class="language-python">class StackArray:
    def __init__(self):
        self.items = []  # Python list (dynamic array)
    
    def push(self, item):
        self.items.append(item)  # O(1) amortized
    
    def pop(self):
        if self.is_empty():
            return None
        return self.items.pop()  # O(1)
    
    def peek(self):
        if self.is_empty():
            return None
        return self.items[-1]  # O(1)
    
    def is_empty(self):
        return len(self.items) == 0  # O(1)
    
    def size(self):
        return len(self.items)  # O(1)</code></pre>

                                        <p><strong>Pros:</strong> Simple, cache-friendly, less memory overhead</p>
                                        <p><strong>Cons:</strong> May need resizing (amortized O(1))</p>
                                    </div>

                                    <h2>Implementation 2: Linked List-based Stack</h2>

                                    <div class="success-box">
                                        <h4>Using Linked List</h4>
                                        <pre><code class="language-python">class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class StackLinkedList:
    def __init__(self):
        self.top = None
        self._size = 0
    
    def push(self, item):
        new_node = Node(item)
        new_node.next = self.top
        self.top = new_node
        self._size += 1  # O(1)
    
    def pop(self):
        if self.is_empty():
            return None
        item = self.top.data
        self.top = self.top.next
        self._size -= 1
        return item  # O(1)
    
    def peek(self):
        if self.is_empty():
            return None
        return self.top.data  # O(1)
    
    def is_empty(self):
        return self.top is None  # O(1)
    
    def size(self):
        return self._size  # O(1)</code></pre>

                                        <p><strong>Pros:</strong> No resizing, truly O(1) push</p>
                                        <p><strong>Cons:</strong> More memory (pointers), worse cache performance</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/stack-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-stack" />
                                    </jsp:include>

                                    <h2>Array vs Linked List Comparison</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Array</th>
                                                <th>Linked List</th>
                                                <th>Winner</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Push</td>
                                                <td>O(1) amortized</td>
                                                <td>O(1) ✓</td>
                                                <td>Linked List</td>
                                            </tr>
                                            <tr>
                                                <td>Pop</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td>Peek</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td>Memory</td>
                                                <td>Less ✓</td>
                                                <td>More (pointers)</td>
                                                <td>Array</td>
                                            </tr>
                                            <tr>
                                                <td>Cache</td>
                                                <td>Better ✓</td>
                                                <td>Worse</td>
                                                <td>Array</td>
                                            </tr>
                                            <tr>
                                                <td>Resizing</td>
                                                <td>Needed</td>
                                                <td>Not needed ✓</td>
                                                <td>Linked List</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Stacks Are Used</h4>

                                        <h5>1. Function Call Stack</h5>
                                        <pre><code>main() {
    processData();  // Push main
}

processData() {
    validate();     // Push processData
}

validate() {
    return;         // Pop validate
                    // Pop processData
                    // Pop main
}</code></pre>

                                        <h5>2. Undo/Redo</h5>
                                        <ul>
                                            <li>Undo stack: Push each action</li>
                                            <li>Ctrl+Z: Pop from undo stack</li>
                                            <li>Redo: Use second stack</li>
                                        </ul>

                                        <h5>3. Expression Evaluation</h5>
                                        <ul>
                                            <li>Infix to postfix conversion</li>
                                            <li>Evaluate postfix expressions</li>
                                            <li>Check balanced parentheses</li>
                                        </ul>

                                        <h5>4. Browser History</h5>
                                        <ul>
                                            <li>Back button: Pop from history stack</li>
                                            <li>Visit new page: Push to stack</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Not Checking Empty</h4>
                                        <pre><code class="language-python"># WRONG - crashes if empty!
value = stack.pop()

# RIGHT - check first
if not stack.is_empty():
    value = stack.pop()
else:
    print("Stack is empty!")</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Confusing Peek and Pop</h4>
                                        <pre><code class="language-python"># Peek - view without removing
top = stack.peek()  # Stack unchanged

# Pop - remove and return
top = stack.pop()   # Stack changed!</code></pre>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Stack Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Always mention LIFO!</strong> Show you understand the
                                                principle</li>
                                            <li>✅ <strong>All operations are O(1)</strong> - emphasize efficiency</li>
                                            <li>✅ <strong>Know both implementations</strong> - array and linked list
                                            </li>
                                            <li>✅ <strong>Discuss trade-offs</strong> - memory vs cache performance</li>
                                            <li>✅ <strong>Check for empty</strong> - before pop/peek</li>
                                            <li>✅ <strong>Know applications</strong> - function calls, undo/redo,
                                                expression eval</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Stack Basics Mastery</h3>
                                        <ol>
                                            <li><strong>LIFO Principle:</strong> Last In, First Out</li>
                                            <li><strong>Three Operations:</strong> Push, Pop, Peek (all O(1))</li>
                                            <li><strong>Two Implementations:</strong> Array (cache-friendly) and Linked
                                                List (no resizing)</li>
                                            <li><strong>Applications:</strong> Function calls, undo/redo, expression
                                                evaluation, backtracking</li>
                                            <li><strong>Key Advantage:</strong> All operations are O(1) - super
                                                efficient!</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Stacks are simple
                                            but powerful! Always check for empty before pop/peek. Know the difference
                                            between array and linked list implementations!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered stack basics! Next: <strong>Stack Applications</strong> -
                                        expression evaluation, balanced parentheses, and more!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement both array and linked list versions. Try
                                        the LIFO demo!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linked-list-advanced.jsp" />
                                    <jsp:param name="prevTitle" value="Advanced Linked List" />
                                    <jsp:param name="nextLink" value="stack-applications.jsp" />
                                    <jsp:param name="nextTitle" value="Stack Applications" />
                                    <jsp:param name="currentLessonId" value="stack-basics" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/stack-basics-viz.js"></script>
        </body>

        </html>