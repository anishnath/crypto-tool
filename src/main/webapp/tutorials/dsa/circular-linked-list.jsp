<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "circular-linked-list" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Circular Linked List - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Circular Linked Lists where last node points to first - perfect for round-robin scheduling, circular buffers, and the Josephus problem!">
            <meta name="keywords"
                content="circular linked list, round robin, circular buffer, josephus problem, cyclic data structure">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Circular Linked List - The Circle of Data">
            <meta property="og:description"
                content="Learn circular linked lists - no null termination, perfect for cyclic processes!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/circular-linked-list.jsp">
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
        "name": "Circular Linked List",
        "description": "Master circular linked lists with no null termination - perfect for cyclic processes and round-robin algorithms.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Circular Linked List", "Round Robin", "Josephus Problem", "Cyclic Data Structures"],
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

        <body class="tutorial-body no-preview" data-lesson="circular-linked-list">
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
                                    <span>Circular Linked List</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">⭕ Circular Linked List</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                        <span class="interview-badge">⭐ Classic Problems</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">What if a linked list had no end? In a <strong>Circular Linked
                                            List</strong>, the last node points back to the first - forming a complete
                                        circle! No null termination, infinite traversal. Perfect for round-robin
                                        scheduling, circular buffers, and the famous Josephus problem!</p>

                                    <div class="warning-box">
                                        <h4>🎯 The Circular Power!</h4>
                                        <p><strong>Circular Linked List features:</strong></p>
                                        <ul>
                                            <li>✅ <strong>No null termination</strong> - last points to first!</li>
                                            <li>✅ <strong>Infinite traversal</strong> - can go around forever!</li>
                                            <li>✅ <strong>Perfect for cycles</strong> - round-robin, circular buffers
                                            </li>
                                            <li>✅ <strong>Josephus problem</strong> - the classic circular list problem!
                                            </li>
                                            <li>⚠️ <strong>Avoid infinite loops</strong> - must use proper termination!
                                            </li>
                                        </ul>
                                        <p><strong>Natural for cyclic processes!</strong></p>
                                    </div>

                                    <h2>The Structure</h2>

                                    <div class="info-box">
                                        <h4>Last Points to First!</h4>
                                        <pre><code class="language-python">class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

# Create circular structure
last.next = head  # No null!</code></pre>

                                        <p><strong>Visual representation:</strong></p>
                                        <pre><code>    10 → 20 → 30 → 40
    ↑                ↓
    └────────────────┘
    
Forms complete circle!</code></pre>

                                        <p><strong>Key difference:</strong></p>
                                        <ul>
                                            <li>Singly: last.next = <code>null</code></li>
                                            <li>Circular: last.next = <code>head</code> ⭕</li>
                                        </ul>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch the circular structure work:</p>

                                    <div id="circularLinkedListVisualization"></div>

                                    <h2>The Circular Nature</h2>

                                    <div class="success-box">
                                        <h4>Infinite Traversal</h4>
                                        <pre><code class="language-python"># Can traverse forever!
current = head
for i in range(100):  # Go around many times
    print(current.data)
    current = current.next  # Never reaches null!</code></pre>

                                        <p><strong>Termination condition:</strong></p>
                                        <pre><code class="language-python"># Singly list: while current != null
# Circular list: while current.next != head

# Traverse once around
current = head
while True:
    print(current.data)
    current = current.next
    if current == head:  # Back to start!
        break</code></pre>
                                    </div>

                                    <h2>The Josephus Problem</h2>

                                    <p>The CLASSIC circular linked list problem! N people stand in a circle. Starting
                                        from a given position, count k people and eliminate the kth person. Repeat until
                                        one person remains.</p>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p><strong>Example:</strong> 7 people (1-7), eliminate every 3rd person</p>
                                        <pre><code>Circle: 1 → 2 → 3 → 4 → 5 → 6 → 7 → (back to 1)

Round 1: Count 1, 2, 3 → Eliminate 3
Circle: 1 → 2 → 4 → 5 → 6 → 7 → (back to 1)

Round 2: Count 4, 5, 6 → Eliminate 6
Circle: 1 → 2 → 4 → 5 → 7 → (back to 1)

Round 3: Count 7, 1, 2 → Eliminate 2
Circle: 1 → 4 → 5 → 7 → (back to 1)

Continue until one remains...</code></pre>

                                        <p><strong>Solution:</strong></p>
                                        <pre><code class="language-python">def josephus(n, k):
    # Create circular list of n people
    head = Node(1)
    current = head
    for i in range(2, n + 1):
        current.next = Node(i)
        current = current.next
    current.next = head  # Make circular!
    
    # Eliminate every kth person
    current = head
    while current.next != current:
        # Count k-1 steps
        for _ in range(k - 1):
            current = current.next
        
        # Eliminate next person
        print(f"Eliminated: {current.next.data}")
        current.next = current.next.next
    
    return current.data  # Survivor!</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/circular-linked-list.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-circular" />
                                    </jsp:include>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Circular Lists Shine</h4>

                                        <h5>1. Round-Robin CPU Scheduling</h5>
                                        <ul>
                                            <li>Processes in circular queue</li>
                                            <li>Each gets time slice</li>
                                            <li>Move to next, repeat forever</li>
                                        </ul>

                                        <h5>2. Circular Buffers</h5>
                                        <ul>
                                            <li>Audio/video streaming</li>
                                            <li>Fixed-size buffer</li>
                                            <li>Write wraps around to start</li>
                                        </ul>

                                        <h5>3. Multiplayer Games</h5>
                                        <ul>
                                            <li>Turn-based games</li>
                                            <li>Players in circle</li>
                                            <li>Next player after last = first</li>
                                        </ul>

                                        <h5>4. Music Playlists</h5>
                                        <ul>
                                            <li>Repeat mode</li>
                                            <li>After last song, go to first</li>
                                            <li>Infinite playback</li>
                                        </ul>

                                        <h5>5. Network Packet Routing</h5>
                                        <ul>
                                            <li>Token ring networks</li>
                                            <li>Token passes in circle</li>
                                            <li>Each node gets turn</li>
                                        </ul>
                                    </div>

                                    <h2>Comparison with Other Lists</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Singly</th>
                                                <th>Doubly</th>
                                                <th>Circular</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Last node points to</td>
                                                <td>null</td>
                                                <td>null</td>
                                                <td>head ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Can loop forever</td>
                                                <td>No</td>
                                                <td>No</td>
                                                <td>Yes ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Traverse backward</td>
                                                <td>No</td>
                                                <td>Yes ✓</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Memory per node</td>
                                                <td>2 pointers ✓</td>
                                                <td>3 pointers</td>
                                                <td>2 pointers ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Perfect for</td>
                                                <td>Stacks, queues</td>
                                                <td>LRU cache</td>
                                                <td>Round-robin ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Infinite Loop!</h4>
                                        <pre><code class="language-python"># WRONG - infinite loop!
current = head
while current:  # Never null in circular list!
    print(current.data)
    current = current.next

# RIGHT - check if back to head
current = head
while True:
    print(current.data)
    current = current.next
    if current == head:  # Back to start!
        break</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Forgetting to Make Circular</h4>
                                        <pre><code class="language-python"># WRONG - not circular!
last.next = None  # Still singly linked!

# RIGHT - point back to head
last.next = head  # Now circular!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #3: Wrong Termination in Josephus</h4>
                                        <pre><code class="language-python"># WRONG - checks for null (never happens!)
while current.next != None:

# RIGHT - check if only one left
while current.next != current:</code></pre>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Circular List Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Always avoid infinite loops:</strong> Use proper termination!
                                            </li>
                                            <li>✅ <strong>Check current.next != head:</strong> Not != null!</li>
                                            <li>✅ <strong>Know Josephus problem:</strong> Classic circular list
                                                question!</li>
                                            <li>✅ <strong>Mention round-robin:</strong> Real-world application!</li>
                                            <li>✅ <strong>Draw the circle:</strong> Visualize the structure!</li>
                                            <li>✅ <strong>Floyd's works here too:</strong> Detect circular structure!
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="success-box">
                                        <h4>✅ When to Use Circular Lists</h4>
                                        <ul>
                                            <li><strong>Round-robin scheduling:</strong> CPU, network, games</li>
                                            <li><strong>Circular buffers:</strong> Audio, video, logging</li>
                                            <li><strong>Josephus problem:</strong> Elimination games</li>
                                            <li><strong>Cyclic processes:</strong> Anything that repeats</li>
                                            <li><strong>No natural end:</strong> Continuous loops</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Circular Linked List Mastery</h3>
                                        <ol>
                                            <li><strong>Structure:</strong> Last node points to head (no null!)</li>
                                            <li><strong>Infinite traversal:</strong> Can go around forever</li>
                                            <li><strong>Termination:</strong> Use current.next != head (not != null)
                                            </li>
                                            <li><strong>Josephus problem:</strong> THE classic circular list problem
                                            </li>
                                            <li><strong>Perfect for:</strong> Round-robin, circular buffers, cyclic
                                                processes</li>
                                            <li><strong>Avoid:</strong> Infinite loops - always use proper termination!
                                            </li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Circular lists are
                                            natural for cyclic processes. Know the Josephus problem - it appears
                                            frequently! Always check current.next != head, not != null!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered circular linked lists! Next: <strong>Advanced Linked List
                                            Problems</strong> - putting it all together!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement the Josephus problem. Try round-robin
                                        scheduling simulation!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="doubly-linked-list.jsp" />
                                    <jsp:param name="prevTitle" value="Doubly Linked List" />
                                    <jsp:param name="nextLink" value="linked-list-advanced.jsp" />
                                    <jsp:param name="nextTitle" value="Advanced Problems" />
                                    <jsp:param name="currentLessonId" value="circular-linked-list" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/circular-linked-list-viz.js"></script>
        </body>

        </html>