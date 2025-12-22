<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linked-list-reversal" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Linked List Reversal - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master the 3-pointer technique for reversing linked lists - one of the most common interview questions! O(1) space solution.">
            <meta name="keywords"
                content="linked list reversal, 3-pointer technique, iterative reversal, recursive reversal, interview questions">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Linked List Reversal - The 3-Pointer Technique">
            <meta property="og:description"
                content="Learn the most common linked list interview question - appears in 50%+ of interviews!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linked-list-reversal.jsp">
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
        "name": "Linked List Reversal",
        "description": "Master the 3-pointer technique for reversing linked lists - critical interview skill.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Linked List Reversal", "3-Pointer Technique", "Iterative Algorithms", "Interview Preparation"],
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

        <body class="tutorial-body no-preview" data-lesson="linked-list-reversal">
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
                                    <span>Linked List Reversal</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔄 Linked List Reversal</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                        <span class="interview-badge">⭐ Top Interview Question</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Reversing a linked list is <strong>THE most common linked list
                                            interview question</strong> - appearing in 50%+ of interviews at Google,
                                        Amazon, Microsoft, Facebook, and Apple. Master the <strong>3-pointer
                                            technique</strong> for O(1) space complexity!</p>

                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert!</h4>
                                        <p><strong>This question appears EVERYWHERE:</strong></p>
                                        <ul>
                                            <li>✅ Google - Asked frequently</li>
                                            <li>✅ Amazon - Top 10 question</li>
                                            <li>✅ Microsoft - Common first-round</li>
                                            <li>✅ Facebook - Standard question</li>
                                            <li>✅ Apple - Appears regularly</li>
                                        </ul>
                                        <p><strong>If you learn ONE linked list algorithm, make it this one!</strong>
                                        </p>
                                    </div>

                                    <h2>The Problem</h2>

                                    <div class="info-box">
                                        <h4>Given a linked list, reverse it</h4>
                                        <p><strong>Input:</strong></p>
                                        <pre><code>HEAD → [1] → [2] → [3] → [4] → null</code></pre>
                                        <p><strong>Output:</strong></p>
                                        <pre><code>HEAD → [4] → [3] → [2] → [1] → null</code></pre>
                                        <p><strong>Constraints:</strong></p>
                                        <ul>
                                            <li>Must reverse in-place</li>
                                            <li>O(n) time complexity</li>
                                            <li>O(1) space complexity (no extra data structures!)</li>
                                        </ul>
                                    </div>

                                    <h2>The 3-Pointer Technique</h2>

                                    <p>The key insight: We need <strong>3 pointers</strong> to reverse the list without
                                        losing references!</p>

                                    <div class="success-box">
                                        <h4>The Magic Formula</h4>
                                        <pre><code class="language-python">prev = None
current = head

while current:
    next_node = current.next  # 1. Save next!
    current.next = prev       # 2. Reverse pointer
    prev = current            # 3. Move forward
    current = next_node

head = prev  # Update head</code></pre>
                                        <p><strong>That's it!</strong> Just 6 lines to reverse a linked list.</p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch the 3 pointers work together:</p>

                                    <div id="reversalVisualization"></div>

                                    <h2>Step-by-Step Walkthrough</h2>

                                    <p>Let's reverse [1] → [2] → [3] → [4] → null step by step:</p>

                                    <h3>Initial State</h3>
                                    <div class="info-box">
                                        <pre><code>prev = null
current = 1
next = ?

HEAD → [1] → [2] → [3] → [4] → null</code></pre>
                                    </div>

                                    <h3>Iteration 1: Reverse node 1</h3>
                                    <div class="success-box">
                                        <p><strong>Step 1:</strong> Save next (so we don't lose the rest!)</p>
                                        <pre><code>next_node = current.next  # next_node = 2</code></pre>

                                        <p><strong>Step 2:</strong> Reverse the pointer</p>
                                        <pre><code>current.next = prev  # 1 now points to null
null ← [1]   [2] → [3] → [4] → null</code></pre>

                                        <p><strong>Step 3:</strong> Move pointers forward</p>
                                        <pre><code>prev = current     # prev = 1
current = next_node  # current = 2

null ← [1]   [2] → [3] → [4] → null
       ↑     ↑
      prev  curr</code></pre>
                                    </div>

                                    <h3>Iteration 2: Reverse node 2</h3>
                                    <div class="success-box">
                                        <p><strong>Save next:</strong> next_node = 3</p>
                                        <p><strong>Reverse pointer:</strong> 2 now points to 1</p>
                                        <pre><code>null ← [1] ← [2]   [3] → [4] → null</code></pre>
                                        <p><strong>Move forward:</strong> prev = 2, current = 3</p>
                                    </div>

                                    <h3>Iteration 3: Reverse node 3</h3>
                                    <div class="success-box">
                                        <p><strong>Save next:</strong> next_node = 4</p>
                                        <p><strong>Reverse pointer:</strong> 3 now points to 2</p>
                                        <pre><code>null ← [1] ← [2] ← [3]   [4] → null</code></pre>
                                        <p><strong>Move forward:</strong> prev = 3, current = 4</p>
                                    </div>

                                    <h3>Iteration 4: Reverse node 4</h3>
                                    <div class="success-box">
                                        <p><strong>Save next:</strong> next_node = null</p>
                                        <p><strong>Reverse pointer:</strong> 4 now points to 3</p>
                                        <pre><code>null ← [1] ← [2] ← [3] ← [4]   null</code></pre>
                                        <p><strong>Move forward:</strong> prev = 4, current = null</p>
                                    </div>

                                    <h3>Final Step: Update HEAD</h3>
                                    <div class="success-box">
                                        <p><strong>Loop ends</strong> (current is null)</p>
                                        <p><strong>Update head:</strong> head = prev (which is 4)</p>
                                        <pre><code>HEAD → [4] → [3] → [2] → [1] → null
       ✓ Reversed!</code></pre>
                                    </div>

                                    <h2>Why 3 Pointers?</h2>

                                    <div class="tip-box">
                                        <h4>💡 Understanding the Need</h4>
                                        <ul>
                                            <li><strong>prev:</strong> Where current should point to (building reversed
                                                list)</li>
                                            <li><strong>current:</strong> The node we're currently reversing</li>
                                            <li><strong>next:</strong> Save the rest of the list before we break the
                                                link!</li>
                                        </ul>
                                        <p><strong>Without next:</strong> We'd lose the rest of the list when we reverse
                                            current's pointer!</p>
                                        <p><strong>This is the #1 mistake:</strong> Forgetting to save next before
                                            reversing.</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linked-list-reversal.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-reversal" />
                                    </jsp:include>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Approach</th>
                                                <th>Time</th>
                                                <th>Space</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Iterative (3-pointer)</td>
                                                <td>O(n) ✓</td>
                                                <td>O(1) ✓✓</td>
                                                <td>Best! Use in interviews</td>
                                            </tr>
                                            <tr>
                                                <td>Recursive</td>
                                                <td>O(n) ✓</td>
                                                <td>O(n)</td>
                                                <td>Call stack overhead</td>
                                            </tr>
                                            <tr>
                                                <td>Using Stack</td>
                                                <td>O(n)</td>
                                                <td>O(n)</td>
                                                <td>Not optimal</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Not Saving Next</h4>
                                        <pre><code class="language-python"># WRONG - loses rest of list!
current.next = prev
current = current.next  # current.next is now prev!

# RIGHT - save next first
next_node = current.next
current.next = prev
current = next_node</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Forgetting to Update Head</h4>
                                        <pre><code class="language-python"># WRONG - head still points to old first node
while current:
    # ... reversal logic ...
# head is still [1], not [4]!

# RIGHT - update head to prev
while current:
    # ... reversal logic ...
head = prev  # Now head is [4]</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #3: Not Handling Edge Cases</h4>
                                        <pre><code class="language-python"># WRONG - crashes on empty list
current = head
while current:  # Crashes if head is None!

# RIGHT - check first
if not head or not head.next:
    return head  # Already reversed or empty</code></pre>
                                    </div>

                                    <h2>Interview Variations</h2>

                                    <div class="info-box">
                                        <h4>Common Follow-ups</h4>
                                        <ol>
                                            <li><strong>Reverse first k nodes</strong> - Stop after k iterations</li>
                                            <li><strong>Reverse in groups of k</strong> - Reverse k, then next k, etc.
                                            </li>
                                            <li><strong>Reverse between positions m and n</strong> - Reverse only middle
                                                part</li>
                                            <li><strong>Check if palindrome</strong> - Reverse half, compare with other
                                                half</li>
                                            <li><strong>Reverse alternate k nodes</strong> - Reverse k, skip k, reverse
                                                k...</li>
                                        </ol>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace This Question</h4>
                                        <ul>
                                            <li>✅ <strong>Draw it out!</strong> Visualize on paper before coding</li>
                                            <li>✅ <strong>Explain the 3 pointers</strong> - show you understand WHY</li>
                                            <li>✅ <strong>Handle edge cases:</strong> Empty list, single node, two nodes
                                            </li>
                                            <li>✅ <strong>Mention O(1) space</strong> - this is the key advantage!</li>
                                            <li>✅ <strong>Walk through an example</strong> - show step-by-step</li>
                                            <li>✅ <strong>Compare with recursive</strong> - show you know trade-offs
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="success-box">
                                        <h4>✅ What Interviewers Want to See</h4>
                                        <ul>
                                            <li>Understanding of pointer manipulation</li>
                                            <li>Ability to track multiple variables</li>
                                            <li>Awareness of space complexity</li>
                                            <li>Handling edge cases</li>
                                            <li>Clear communication while coding</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Pointer Reversal</h3>
                                        <ol>
                                            <li><strong>Use 3 pointers:</strong> prev (null), current (head), next
                                                (temp)</li>
                                            <li><strong>Loop while current exists:</strong>
                                                <ul>
                                                    <li>Save next: next_node = current.next</li>
                                                    <li>Reverse: current.next = prev</li>
                                                    <li>Move forward: prev = current, current = next_node</li>
                                                </ul>
                                            </li>
                                            <li><strong>Update head:</strong> head = prev</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> This is THE most
                                            common linked list question. Practice until you can code it in your sleep!
                                            Draw it out, explain each step, and you'll ace it.</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered reversal! Next: <strong>Cycle Detection</strong> - another top
                                        interview question using Floyd's algorithm!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try reversing a list on paper. Then code it without
                                        looking. Then try the variations!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linked-list-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Singly Linked List" />
                                    <jsp:param name="nextLink" value="linked-list-cycle.jsp" />
                                    <jsp:param name="nextTitle" value="Cycle Detection" />
                                    <jsp:param name="currentLessonId" value="linked-list-reversal" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/reversal-viz.js"></script>
        </body>

        </html>