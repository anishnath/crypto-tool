<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linked-list-two-pointers" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Two Pointer Techniques - Linked Lists | DSA Tutorial</title>
            <meta name="description"
                content="Master two-pointer patterns for linked lists: slow-fast for middle, gap for nth from end, palindrome checking. Essential interview skills!">
            <meta name="keywords"
                content="two pointers, slow fast pointers, find middle, nth from end, palindrome check, linked list patterns">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Two Pointer Techniques for Linked Lists">
            <meta property="og:description"
                content="Learn the essential two-pointer patterns that appear in every FAANG interview!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linked-list-two-pointers.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror-modes/python.min.css">
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
        "name": "Two Pointer Techniques for Linked Lists",
        "description": "Master slow-fast and gap patterns for linked list problems - critical interview patterns.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Two Pointer Technique", "Slow-Fast Pattern", "Gap Pattern", "Interview Preparation"],
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

        <body class="tutorial-body no-preview" data-lesson="linked-list-two-pointers">
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
                                    <span>Two Pointer Techniques</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">📍📍 Two Pointer Techniques</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                        <span class="interview-badge">⭐ Essential Pattern</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Two pointers are THE fundamental technique for linked list problems.
                                        Master <strong>two patterns</strong>: slow-fast (different speeds) and gap (same
                                        speed, different start). These patterns solve 90% of linked list interview
                                        questions in O(1) space!</p>

                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert!</h4>
                                        <p><strong>Two-pointer patterns appear EVERYWHERE:</strong></p>
                                        <ul>
                                            <li>✅ Find middle - Asked by Google, Amazon, Microsoft</li>
                                            <li>✅ Nth from end - Top interview question</li>
                                            <li>✅ Palindrome check - Facebook, LinkedIn favorite</li>
                                            <li>✅ Remove duplicates - Common follow-up</li>
                                            <li>✅ Reorder list - Advanced variation</li>
                                        </ul>
                                        <p><strong>Master these patterns and you'll ace linked list interviews!</strong>
                                        </p>
                                    </div>

                                    <h2>The Two Patterns</h2>

                                    <div class="info-box">
                                        <h4>Pattern 1: Slow-Fast (Different Speeds)</h4>
                                        <pre><code class="language-python">slow = head  # Moves 1 step
fast = head  # Moves 2 steps

while fast and fast.next:
    slow = slow.next      # 1 step
    fast = fast.next.next # 2 steps

# When fast reaches end, slow is at middle!</code></pre>
                                        <p><strong>Use for:</strong> Find middle, Detect cycle, Palindrome check</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>Pattern 2: Gap (Same Speed, Different Start)</h4>
                                        <pre><code class="language-python"># Move first pointer n steps ahead
first = head
for i in range(n):
    first = first.next

# Move both together
second = head
while first:
    first = first.next
    second = second.next

# When first reaches end, second is nth from end!</code></pre>
                                        <p><strong>Use for:</strong> Nth from end, Remove nth from end</p>
                                    </div>

                                    <h3>See Them in Action</h3>
                                    <p>Watch both patterns work:</p>

                                    <div id="twoPointerVisualization"></div>

                                    <h2>Pattern 1: Find Middle (Slow-Fast)</h2>

                                    <p>The slow-fast pattern is elegant: when the fast pointer reaches the end, the slow
                                        pointer is exactly at the middle!</p>

                                    <div class="success-box">
                                        <h4>Why It Works</h4>
                                        <p><strong>The logic:</strong></p>
                                        <ul>
                                            <li>Fast moves twice as fast as slow</li>
                                            <li>When fast travels distance D, slow travels D/2</li>
                                            <li>When fast reaches end (distance = n), slow is at n/2 (middle!)</li>
                                        </ul>
                                    </div>

                                    <h3>Step-by-Step Example</h3>

                                    <div class="info-box">
                                        <p><strong>List:</strong> 1 → 2 → 3 → 4 → 5</p>

                                        <p><strong>Step 0:</strong> Both at 1</p>
                                        <pre><code>slow=1, fast=1</code></pre>

                                        <p><strong>Step 1:</strong> Slow moves to 2, Fast moves to 3</p>
                                        <pre><code>slow=2, fast=3</code></pre>

                                        <p><strong>Step 2:</strong> Slow moves to 3, Fast moves to 5</p>
                                        <pre><code>slow=3, fast=5</code></pre>

                                        <p><strong>Result:</strong> Fast reached end, slow is at middle (3)!</p>
                                    </div>

                                    <h2>Pattern 2: Nth from End (Gap)</h2>

                                    <p>The gap pattern maintains a fixed distance between two pointers. When the first
                                        reaches the end, the second is exactly n positions from the end!</p>

                                    <div class="success-box">
                                        <h4>Why It Works</h4>
                                        <p><strong>The logic:</strong></p>
                                        <ul>
                                            <li>Create gap of n by moving first pointer n steps</li>
                                            <li>Move both pointers together - gap stays constant!</li>
                                            <li>When first reaches end, second is n behind (n from end!)</li>
                                        </ul>
                                    </div>

                                    <h3>Step-by-Step Example</h3>

                                    <div class="info-box">
                                        <p><strong>List:</strong> 1 → 2 → 3 → 4 → 5 → 6</p>
                                        <p><strong>Find:</strong> 2nd from end</p>

                                        <p><strong>Phase 1:</strong> Move first 2 steps ahead</p>
                                        <pre><code>first=1 → first=2 → first=3
second=1 (hasn't moved yet)</code></pre>

                                        <p><strong>Phase 2:</strong> Move both together</p>
                                        <pre><code>first=3, second=1
first=4, second=2
first=5, second=3
first=6, second=4
first=null, second=5</code></pre>

                                        <p><strong>Result:</strong> Second is at 5 (2nd from end)!</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Application: Palindrome Check</h2>

                                    <p>Combine slow-fast with reversal to check if a list is a palindrome - all in O(1)
                                        space!</p>

                                    <div class="success-box">
                                        <h4>The 3-Step Algorithm</h4>
                                        <ol>
                                            <li><strong>Find middle</strong> using slow-fast pattern</li>
                                            <li><strong>Reverse second half</strong> of the list</li>
                                            <li><strong>Compare</strong> first half with reversed second half</li>
                                        </ol>
                                        <pre><code class="language-python"># Step 1: Find middle
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next

# Step 2: Reverse second half
prev = None
while slow:
    next_node = slow.next
    slow.next = prev
    prev = slow
    slow = next_node

# Step 3: Compare
while prev:
    if head.data != prev.data:
        return False
    head = head.next
    prev = prev.next

return True</code></pre>
                                    </div>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linked-list-two-pointers.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-two-pointers" />
                                    </jsp:include>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Time</th>
                                                <th>Space</th>
                                                <th>Pattern</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Find middle</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Slow-Fast</td>
                                            </tr>
                                            <tr>
                                                <td>Find nth from end</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Gap</td>
                                            </tr>
                                            <tr>
                                                <td>Check palindrome</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Slow-Fast + Reverse</td>
                                            </tr>
                                            <tr>
                                                <td>Remove nth from end</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Gap</td>
                                            </tr>
                                            <tr>
                                                <td>Find intersection</td>
                                                <td>O(m+n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Align + Move</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Not Checking fast.next</h4>
                                        <pre><code class="language-python"># WRONG - crashes on odd-length lists!
while fast:
    fast = fast.next.next  # Crashes if fast.next is null!

# RIGHT - check both
while fast and fast.next:
    fast = fast.next.next  # Safe!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Wrong Gap Size</h4>
                                        <pre><code class="language-python"># WRONG - off by one!
for i in range(n):  # Creates gap of n
    first = first.next

# For removing nth from end, need gap of n+1
for i in range(n + 1):  # Creates gap of n+1
    first = first.next</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #3: Calculating Length First</h4>
                                        <pre><code class="language-python"># WRONG - two passes, less elegant
length = get_length(head)
middle_idx = length // 2
# ... traverse to middle_idx

# RIGHT - one pass with two pointers!
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
# slow is at middle!</code></pre>
                                    </div>

                                    <h2>Interview Variations</h2>

                                    <div class="info-box">
                                        <h4>Common Follow-ups</h4>
                                        <ol>
                                            <li><strong>Find middle</strong> ✓ (covered)</li>
                                            <li><strong>Find nth from end</strong> ✓ (covered)</li>
                                            <li><strong>Check palindrome</strong> ✓ (covered)</li>
                                            <li><strong>Remove nth from end</strong> ✓ (covered)</li>
                                            <li><strong>Reorder list:</strong> L0→Ln→L1→Ln-1→L2→Ln-2...</li>
                                            <li><strong>Partition around value:</strong> All less than x before greater
                                            </li>
                                            <li><strong>Split into k parts:</strong> Divide list into k equal parts</li>
                                        </ol>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Two-Pointer Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Identify the pattern:</strong> Different speeds or gap?</li>
                                            <li>✅ <strong>Draw it out:</strong> Visualize pointer movements</li>
                                            <li>✅ <strong>Explain O(1) space:</strong> Key advantage over arrays!</li>
                                            <li>✅ <strong>Handle edge cases:</strong> Empty, single node, even/odd
                                                length</li>
                                            <li>✅ <strong>Check fast.next:</strong> Avoid null pointer errors</li>
                                            <li>✅ <strong>Know both patterns:</strong> When to use each</li>
                                        </ul>
                                    </div>

                                    <div class="success-box">
                                        <h4>✅ Pattern Selection Guide</h4>
                                        <ul>
                                            <li><strong>Use Slow-Fast when:</strong> Need middle, detect cycle, or split
                                                in half</li>
                                            <li><strong>Use Gap when:</strong> Need nth from end or remove nth from end
                                            </li>
                                            <li><strong>Combine patterns when:</strong> Checking palindrome, reordering
                                                list</li>
                                        </ul>
                                    </div>

                                    <h2>Real-World Applications</h2>

                                    <div class="info-box">
                                        <h4>Where Are These Used?</h4>
                                        <ul>
                                            <li><strong>Music players:</strong> Finding middle of playlist</li>
                                            <li><strong>Undo/Redo:</strong> Navigating history n steps back</li>
                                            <li><strong>Text editors:</strong> Finding center of document</li>
                                            <li><strong>Network protocols:</strong> Sliding window algorithms</li>
                                            <li><strong>Data validation:</strong> Palindrome checking</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Two-Pointer Mastery</h3>
                                        <ol>
                                            <li><strong>Slow-Fast Pattern:</strong> Different speeds (1 vs 2 steps)
                                                <ul>
                                                    <li>Find middle: When fast reaches end, slow at middle</li>
                                                    <li>Detect cycle: If they meet, cycle exists</li>
                                                </ul>
                                            </li>
                                            <li><strong>Gap Pattern:</strong> Same speed, different start
                                                <ul>
                                                    <li>Nth from end: Create gap of n, move together</li>
                                                    <li>Remove nth: Create gap of n+1 (for previous node)</li>
                                                </ul>
                                            </li>
                                            <li><strong>All O(n) time, O(1) space:</strong> Optimal solutions!</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Two pointers are
                                            more elegant than calculating length. Always check fast.next to avoid
                                            crashes. Draw the pointers moving to visualize!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered two-pointer techniques! Next: <strong>Doubly Linked
                                            Lists</strong> - bidirectional traversal with prev pointers!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement all 5 operations. Try the variations. Draw
                                        pointer movements on paper!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linked-list-cycle.jsp" />
                                    <jsp:param name="prevTitle" value="Cycle Detection" />
                                    <jsp:param name="nextLink" value="doubly-linked-list.jsp" />
                                    <jsp:param name="nextTitle" value="Doubly Linked List" />
                                    <jsp:param name="currentLessonId" value="linked-list-two-pointers" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/two-pointer-viz.js"></script>
        </body>

        </html>