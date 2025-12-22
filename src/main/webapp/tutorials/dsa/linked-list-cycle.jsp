<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linked-list-cycle" ); request.setAttribute("currentModule", "Linked Lists"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Cycle Detection - Floyd's Algorithm | DSA Tutorial</title>
            <meta name="description"
                content="Master Floyd's Tortoise and Hare algorithm for cycle detection in linked lists. O(n) time, O(1) space - top FAANG interview question!">
            <meta name="keywords"
                content="cycle detection, Floyd's algorithm, tortoise and hare, linked list cycle, fast slow pointers">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Cycle Detection - Floyd's Tortoise and Hare">
            <meta property="og:description"
                content="Learn the famous algorithm for detecting cycles in linked lists - critical interview skill!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linked-list-cycle.jsp">
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
        "name": "Cycle Detection in Linked Lists",
        "description": "Master Floyd's Tortoise and Hare algorithm - detect cycles in O(1) space.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Floyd's Algorithm", "Cycle Detection", "Two Pointer Technique", "Interview Preparation"],
        "timeRequired": "PT25M",
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

        <body class="tutorial-body no-preview" data-lesson="linked-list-cycle">
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
                                    <span>Cycle Detection</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🐢🐇 Cycle Detection - Floyd's Algorithm</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                        <span class="interview-badge">⭐ Top Interview Question</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Imagine a linked list where the last node points back to an earlier
                                        node instead of null - creating an infinite loop! <strong>Floyd's Tortoise and
                                            Hare algorithm</strong> detects this in O(n) time with O(1) space. This
                                        elegant solution appears frequently at Google, Amazon, Microsoft, and Facebook!
                                    </p>

                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert!</h4>
                                        <p><strong>Floyd's algorithm is a MUST-KNOW:</strong></p>
                                        <ul>
                                            <li>✅ Google - Common question</li>
                                            <li>✅ Amazon - Frequently asked</li>
                                            <li>✅ Microsoft - Standard interview</li>
                                            <li>✅ Facebook - Regular appearance</li>
                                            <li>✅ LinkedIn - Popular question</li>
                                        </ul>
                                        <p><strong>The O(1) space solution is what separates good from great!</strong>
                                        </p>
                                    </div>

                                    <h2>The Problem</h2>

                                    <div class="info-box">
                                        <h4>Detect if a linked list has a cycle</h4>
                                        <p><strong>Example WITH cycle:</strong></p>
                                        <pre><code>1 → 2 → 3 → 4 → 5
        ↑           ↓
        └───────────┘
        
Cycle exists! Node 5 points back to node 3</code></pre>

                                        <p><strong>Example WITHOUT cycle:</strong></p>
                                        <pre><code>1 → 2 → 3 → 4 → 5 → null

No cycle - ends with null</code></pre>

                                        <p><strong>Challenge:</strong> Detect cycle in O(1) space (no HashSet!)</p>
                                    </div>

                                    <h2>Floyd's Tortoise and Hare 🐢🐇</h2>

                                    <p>The brilliant insight: Use <strong>two pointers moving at different
                                            speeds</strong>!</p>

                                    <div class="success-box">
                                        <h4>The Algorithm</h4>
                                        <pre><code class="language-python">def has_cycle(head):
    slow = head  # 🐢 Tortoise - moves 1 step
    fast = head  # 🐇 Hare - moves 2 steps
    
    while fast and fast.next:
        slow = slow.next      # Move 1 step
        fast = fast.next.next # Move 2 steps
        
        if slow == fast:
            return True  # They met - cycle!
    
    return False  # Hare reached end - no cycle</code></pre>
                                        <p><strong>That's it!</strong> Just 9 lines to detect cycles.</p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch the tortoise and hare move through the list:</p>

                                    <div id="cycleVisualization"></div>

                                    <h2>Why It Works</h2>

                                    <div class="tip-box">
                                        <h4>💡 The Race Track Analogy</h4>
                                        <p>Think of a circular race track:</p>
                                        <ul>
                                            <li>🐢 <strong>Tortoise</strong> runs at 1 mph</li>
                                            <li>🐇 <strong>Hare</strong> runs at 2 mph (twice as fast!)</li>
                                            <li>If the track is circular, the hare will eventually <strong>lap</strong>
                                                the tortoise</li>
                                            <li>They MUST meet at some point!</li>
                                        </ul>
                                        <p><strong>Same with linked lists:</strong> If there's a cycle, fast will catch
                                            slow!</p>
                                    </div>

                                    <h3>Step-by-Step Example</h3>

                                    <p>Let's trace through a list with a cycle:</p>

                                    <div class="info-box">
                                        <p><strong>List structure:</strong></p>
                                        <pre><code>1 → 2 → 3 → 4 → 5
        ↑           ↓
        └───────────┘</code></pre>

                                        <p><strong>Step 0:</strong> Both start at node 1</p>
                                        <pre><code>🐢🐇 at 1</code></pre>

                                        <p><strong>Step 1:</strong> Slow moves to 2, Fast moves to 3</p>
                                        <pre><code>🐢 at 2, 🐇 at 3</code></pre>

                                        <p><strong>Step 2:</strong> Slow moves to 3, Fast moves to 5</p>
                                        <pre><code>🐢 at 3, 🐇 at 5</code></pre>

                                        <p><strong>Step 3:</strong> Slow moves to 4, Fast moves to 4 (via cycle!)</p>
                                        <pre><code>🐢 at 4, 🐇 at 4 → They met! Cycle detected!</code></pre>
                                    </div>

                                    <h2>Finding the Cycle Start</h2>

                                    <p>Once we know there's a cycle, where does it start?</p>

                                    <div class="success-box">
                                        <h4>The Magic Trick</h4>
                                        <pre><code class="language-python">def find_cycle_start(head):
    # Step 1: Detect cycle and find meeting point
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break  # Found meeting point
    else:
        return None  # No cycle
    
    # Step 2: Find cycle start
    slow = head  # Move slow to head
    
    while slow != fast:
        slow = slow.next  # Both move 1 step
        fast = fast.next
    
    return slow  # This is the cycle start!</code></pre>
                                    </div>

                                    <h3>Why Does This Work?</h3>

                                    <div class="tip-box">
                                        <h4>💡 The Mathematics</h4>
                                        <p><strong>Let's define:</strong></p>
                                        <ul>
                                            <li>x = distance from head to cycle start</li>
                                            <li>y = distance from cycle start to meeting point</li>
                                            <li>C = cycle length</li>
                                        </ul>

                                        <p><strong>When they meet:</strong></p>
                                        <ul>
                                            <li>Slow traveled: x + y</li>
                                            <li>Fast traveled: x + y + nC (n complete cycles)</li>
                                            <li>Fast = 2 × Slow (twice the distance)</li>
                                        </ul>

                                        <p><strong>Therefore:</strong></p>
                                        <pre><code>x + y + nC = 2(x + y)
x + y + nC = 2x + 2y
nC = x + y
x = nC - y</code></pre>

                                        <p><strong>This means:</strong> Distance from head to cycle start (x) equals
                                            distance from meeting point to cycle start (nC - y)!</p>
                                        <p><strong>So:</strong> If we move both pointers at same speed, they meet at
                                            cycle start!</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linked-list-cycle.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-cycle" />
                                    </jsp:include>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Time</th>
                                                <th>Space</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Detect cycle</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Floyd's algorithm</td>
                                            </tr>
                                            <tr>
                                                <td>Find cycle start</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Two-phase approach</td>
                                            </tr>
                                            <tr>
                                                <td>Get cycle length</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Count after detection</td>
                                            </tr>
                                            <tr>
                                                <td>Remove cycle</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Find start, break link</td>
                                            </tr>
                                            <tr>
                                                <td>Using HashSet</td>
                                                <td>O(n)</td>
                                                <td>O(n)</td>
                                                <td>Not optimal!</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Not Checking fast.next</h4>
                                        <pre><code class="language-python"># WRONG - crashes if fast.next is null!
while fast:
    fast = fast.next.next  # Crashes!

# RIGHT - check both fast and fast.next
while fast and fast.next:
    fast = fast.next.next  # Safe!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Moving Both Same Speed</h4>
                                        <pre><code class="language-python"># WRONG - both move 1 step
slow = slow.next
fast = fast.next  # They'll never meet!

# RIGHT - fast moves 2 steps
slow = slow.next
fast = fast.next.next  # Twice as fast!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #3: Using Extra Space</h4>
                                        <pre><code class="language-python"># WRONG - uses O(n) space
visited = set()
while current:
    if current in visited:
        return True
    visited.add(current)

# RIGHT - O(1) space with Floyd's
# (Use the algorithm above!)</code></pre>
                                    </div>

                                    <h2>Interview Variations</h2>

                                    <div class="info-box">
                                        <h4>Common Follow-ups</h4>
                                        <ol>
                                            <li><strong>Detect if cycle exists</strong> ✓ (covered)</li>
                                            <li><strong>Find where cycle starts</strong> ✓ (covered)</li>
                                            <li><strong>Find length of cycle</strong> ✓ (covered)</li>
                                            <li><strong>Remove the cycle</strong> ✓ (covered)</li>
                                            <li><strong>Find intersection of two lists</strong> (similar technique!)
                                            </li>
                                            <li><strong>Check if list is palindrome</strong> (uses slow/fast pointers)
                                            </li>
                                        </ol>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace This Question</h4>
                                        <ul>
                                            <li>✅ <strong>Explain the analogy:</strong> "Like a race track - faster
                                                runner laps slower"</li>
                                            <li>✅ <strong>Draw it out:</strong> Visualize the cycle and pointer
                                                movements</li>
                                            <li>✅ <strong>Mention O(1) space:</strong> This is the key advantage over
                                                HashSet!</li>
                                            <li>✅ <strong>Handle edge cases:</strong> Empty list, single node, no cycle
                                            </li>
                                            <li>✅ <strong>Explain the math:</strong> Show you understand WHY it works
                                            </li>
                                            <li>✅ <strong>Know the variations:</strong> Finding start, length, removal
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="success-box">
                                        <h4>✅ What Interviewers Want to See</h4>
                                        <ul>
                                            <li>Understanding of two-pointer technique</li>
                                            <li>Ability to optimize space complexity</li>
                                            <li>Knowledge of mathematical reasoning</li>
                                            <li>Handling edge cases properly</li>
                                            <li>Clear communication of algorithm</li>
                                        </ul>
                                    </div>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Is This Used?</h4>
                                        <ul>
                                            <li><strong>Deadlock detection:</strong> Finding circular dependencies</li>
                                            <li><strong>Memory leak detection:</strong> Circular references</li>
                                            <li><strong>Graph algorithms:</strong> Detecting cycles in graphs</li>
                                            <li><strong>Duplicate detection:</strong> Finding repeated sequences</li>
                                            <li><strong>Infinite loop detection:</strong> Program analysis</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Floyd's Tortoise and Hare</h3>
                                        <ol>
                                            <li><strong>Use two pointers:</strong> slow (1 step) and fast (2 steps)</li>
                                            <li><strong>If cycle exists:</strong> They will meet inside the cycle</li>
                                            <li><strong>If no cycle:</strong> Fast reaches null</li>
                                            <li><strong>To find start:</strong> Move one to head, both move 1 step, meet
                                                at start</li>
                                            <li><strong>O(n) time, O(1) space:</strong> Optimal solution!</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> This is a classic
                                            two-pointer problem. The key insight is using different speeds to detect
                                            cycles. Always explain the race track analogy - it shows deep understanding!
                                        </p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered cycle detection! Next: <strong>Two Pointer Techniques</strong> -
                                        finding middle, nth from end, and palindrome checking!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try implementing all 4 operations (detect, find
                                        start, get length, remove). Draw cycles on paper to visualize!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linked-list-reversal.jsp" />
                                    <jsp:param name="prevTitle" value="Linked List Reversal" />
                                    <jsp:param name="nextLink" value="linked-list-two-pointers.jsp" />
                                    <jsp:param name="nextTitle" value="Two Pointer Techniques" />
                                    <jsp:param name="currentLessonId" value="linked-list-cycle" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/cycle-viz.js"></script>
        </body>

        </html>