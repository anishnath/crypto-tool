<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "doubly-linked-list" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Doubly Linked List - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Doubly Linked Lists with prev pointers - O(1) operations at both ends, bidirectional traversal. Perfect for LRU cache and browser history!">
            <meta name="keywords"
                content="doubly linked list, prev pointer, bidirectional traversal, O(1) tail delete, LRU cache, deque">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Doubly Linked List - Bidirectional Power">
            <meta property="og:description"
                content="Learn doubly linked lists with O(1) operations at both ends - the superpower of prev pointers!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/doubly-linked-list.jsp">
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
        "name": "Doubly Linked List",
        "description": "Master doubly linked lists with bidirectional traversal and O(1) operations at both ends.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Doubly Linked List", "Bidirectional Traversal", "Prev Pointers", "Data Structures"],
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

        <body class="tutorial-body no-preview" data-lesson="doubly-linked-list">
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
                                    <span>Doubly Linked List</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">↔️ Doubly Linked List</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                        <span class="interview-badge">⭐ Real-World Power</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Singly linked lists can only go forward. What if you need to go
                                        backward too? Enter <strong>Doubly Linked Lists</strong> - each node has BOTH
                                        next and prev pointers! This enables O(1) operations at both ends and
                                        bidirectional traversal. Perfect for browser history, LRU cache, and deque!</p>

                                    <div class="warning-box">
                                        <h4>🎯 The Superpowers!</h4>
                                        <p><strong>Doubly Linked List advantages:</strong></p>
                                        <ul>
                                            <li>✅ <strong>O(1) tail delete</strong> - vs O(n) in singly linked list!
                                            </li>
                                            <li>✅ <strong>O(1) delete any node</strong> - if you have reference!</li>
                                            <li>✅ <strong>Bidirectional traversal</strong> - go forward AND backward!
                                            </li>
                                            <li>✅ <strong>Simpler reverse</strong> - just swap pointers!</li>
                                            <li>⚠️ <strong>More memory</strong> - 3 pointers vs 2 per node</li>
                                        </ul>
                                        <p><strong>Trade-off: More memory for more flexibility!</strong></p>
                                    </div>

                                    <h2>The Structure</h2>

                                    <div class="info-box">
                                        <h4>Node with Prev Pointer</h4>
                                        <pre><code class="language-python">class Node:
    def __init__(self, data):
        self.data = data
        self.next = None  # Forward pointer
        self.prev = None  # Backward pointer!</code></pre>

                                        <p><strong>Visual representation:</strong></p>
                                        <pre><code>null ← [10] ↔ [20] ↔ [30] ↔ [40] → null
       ↑                           ↑
      HEAD                       TAIL</code></pre>

                                        <p><strong>Each node knows:</strong></p>
                                        <ul>
                                            <li>Its data</li>
                                            <li>Next node (forward)</li>
                                            <li>Previous node (backward)</li>
                                        </ul>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch bidirectional links work:</p>

                                    <div id="doublyLinkedListVisualization"></div>

                                    <h2>The Three Superpowers</h2>

                                    <h3>Superpower #1: O(1) Tail Delete</h3>

                                    <div class="success-box">
                                        <h4>Singly vs Doubly</h4>
                                        <p><strong>Singly Linked List - O(n):</strong></p>
                                        <pre><code class="language-python"># Must find second-to-last node
current = head
while current.next.next:  # O(n) traversal!
    current = current.next
current.next = None  # Remove tail</code></pre>

                                        <p><strong>Doubly Linked List - O(1):</strong></p>
                                        <pre><code class="language-python"># Just use prev pointer!
tail = tail.prev  # O(1) - instant!
tail.next = None</code></pre>

                                        <p><strong>This is HUGE!</strong> Tail operations are now as fast as head
                                            operations!</p>
                                    </div>

                                    <h3>Superpower #2: O(1) Delete Any Node</h3>

                                    <div class="success-box">
                                        <h4>The Magic of Prev Pointer</h4>
                                        <p><strong>If you have a reference to a node:</strong></p>
                                        <pre><code class="language-python">def delete_node(node):
    # Update previous node's next
    if node.prev:
        node.prev.next = node.next
    
    # Update next node's prev
    if node.next:
        node.next.prev = node.prev
    
    # Done in O(1)!</code></pre>

                                        <p><strong>This is IMPOSSIBLE with singly linked list!</strong></p>
                                        <p>You'd need to traverse from head to find the previous node - O(n).</p>
                                    </div>

                                    <h3>Superpower #3: Bidirectional Traversal</h3>

                                    <div class="success-box">
                                        <h4>Go Both Ways!</h4>
                                        <p><strong>Forward (head to tail):</strong></p>
                                        <pre><code class="language-python">current = head
while current:
    print(current.data)
    current = current.next  # Forward</code></pre>

                                        <p><strong>Backward (tail to head):</strong></p>
                                        <pre><code class="language-python">current = tail
while current:
    print(current.data)
    current = current.prev  # Backward!</code></pre>

                                        <p><strong>Perfect for:</strong> Browser history, undo/redo, music playlists</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/doubly-linked-list.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-doubly" />
                                    </jsp:include>

                                    <h2>Singly vs Doubly Comparison</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Singly</th>
                                                <th>Doubly</th>
                                                <th>Winner</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Insert at head</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td>Insert at tail</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Doubly!</td>
                                            </tr>
                                            <tr>
                                                <td>Delete at head</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td>Delete at tail</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Doubly!</td>
                                            </tr>
                                            <tr>
                                                <td>Delete specific node</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Doubly!</td>
                                            </tr>
                                            <tr>
                                                <td>Traverse backward</td>
                                                <td>Impossible</td>
                                                <td>O(n) ✓</td>
                                                <td>Doubly!</td>
                                            </tr>
                                            <tr>
                                                <td>Memory per node</td>
                                                <td>2 pointers ✓</td>
                                                <td>3 pointers</td>
                                                <td>Singly</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Doubly Linked Lists Shine</h4>

                                        <h5>1. Browser History</h5>
                                        <ul>
                                            <li>Back button: Move to prev</li>
                                            <li>Forward button: Move to next</li>
                                            <li>Visit new page: Delete forward history, add new</li>
                                        </ul>

                                        <h5>2. LRU Cache</h5>
                                        <ul>
                                            <li>Most recently used at head</li>
                                            <li>Least recently used at tail</li>
                                            <li>O(1) move to head when accessed</li>
                                            <li>O(1) remove from tail when full</li>
                                        </ul>

                                        <h5>3. Music Player Playlist</h5>
                                        <ul>
                                            <li>Next song: Move forward</li>
                                            <li>Previous song: Move backward</li>
                                            <li>Remove song: O(1) delete</li>
                                        </ul>

                                        <h5>4. Undo/Redo System</h5>
                                        <ul>
                                            <li>Undo: Move backward</li>
                                            <li>Redo: Move forward</li>
                                            <li>New action: Delete forward, add new</li>
                                        </ul>

                                        <h5>5. Deque (Double-Ended Queue)</h5>
                                        <ul>
                                            <li>Add/remove from both ends in O(1)</li>
                                            <li>Perfect for sliding window algorithms</li>
                                        </ul>
                                    </div>

                                    <h2>When to Use Each</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Doubly Linked List When:</h4>
                                        <ul>
                                            <li><strong>Need bidirectional traversal:</strong> Browser history,
                                                playlists</li>
                                            <li><strong>Need O(1) tail operations:</strong> Deque, LRU cache</li>
                                            <li><strong>Need O(1) delete with reference:</strong> Priority queues</li>
                                            <li><strong>Implementing deque:</strong> Add/remove from both ends</li>
                                            <li><strong>Memory not critical:</strong> Extra pointer acceptable</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Use Singly Linked List When:</h4>
                                        <ul>
                                            <li><strong>Only forward traversal:</strong> Simple iteration</li>
                                            <li><strong>Memory is limited:</strong> Embedded systems</li>
                                            <li><strong>Only head operations:</strong> Stack implementation</li>
                                            <li><strong>Simpler is better:</strong> Less complexity needed</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Forgetting to Update Prev</h4>
                                        <pre><code class="language-python"># WRONG - only updates next!
new_node.next = head
head = new_node

# RIGHT - update both next and prev
new_node.next = head
head.prev = new_node  # Don't forget!
head = new_node</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Not Updating Tail</h4>
                                        <pre><code class="language-python"># WRONG - tail not updated!
new_node.prev = tail
tail.next = new_node

# RIGHT - update tail pointer
new_node.prev = tail
tail.next = new_node
tail = new_node  # Update tail!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #3: Memory Leaks</h4>
                                        <pre><code class="language-python"># WRONG - doesn't clear pointers!
node.prev.next = node.next
node.next.prev = node.prev

# RIGHT - clear deleted node's pointers
node.prev.next = node.next
node.next.prev = node.prev
node.prev = None  # Clear!
node.next = None  # Clear!</code></pre>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Doubly Linked List Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Always update both pointers:</strong> next AND prev</li>
                                            <li>✅ <strong>Don't forget head and tail:</strong> Update both when needed
                                            </li>
                                            <li>✅ <strong>Mention O(1) advantages:</strong> Tail ops, delete with
                                                reference</li>
                                            <li>✅ <strong>Know real-world uses:</strong> LRU cache, browser history</li>
                                            <li>✅ <strong>Draw it out:</strong> Visualize bidirectional links</li>
                                            <li>✅ <strong>Compare with singly:</strong> Show you understand trade-offs
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Doubly Linked List Mastery</h3>
                                        <ol>
                                            <li><strong>Structure:</strong> Each node has data, next, AND prev</li>
                                            <li><strong>Superpower #1:</strong> O(1) tail operations (vs O(n) in singly)
                                            </li>
                                            <li><strong>Superpower #2:</strong> O(1) delete with reference</li>
                                            <li><strong>Superpower #3:</strong> Bidirectional traversal</li>
                                            <li><strong>Trade-off:</strong> More memory (3 pointers) for more
                                                flexibility</li>
                                            <li><strong>Perfect for:</strong> LRU cache, browser history, deque,
                                                undo/redo</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Doubly linked lists
                                            are EASIER for many operations! Always update both next and prev. Know when
                                            to use doubly vs singly - it's about trade-offs!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered doubly linked lists! Next: <strong>Circular Linked Lists</strong>
                                        - where the last node points back to the first!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement a deque using doubly linked list. Try
                                        implementing LRU cache!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linked-list-two-pointers.jsp" />
                                    <jsp:param name="prevTitle" value="Two Pointer Techniques" />
                                    <jsp:param name="nextLink" value="circular-linked-list.jsp" />
                                    <jsp:param name="nextTitle" value="Circular Linked List" />
                                    <jsp:param name="currentLessonId" value="doubly-linked-list" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/doubly-linked-list-viz.js"></script>
        </body>

        </html>