<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linked-list-advanced" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Advanced Linked List Problems - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master advanced linked list problems - merge, reorder, partition, rotate. Combining all techniques for FAANG interviews!">
            <meta name="keywords"
                content="advanced linked list, merge sorted lists, reorder list, partition list, rotate list, FAANG interview">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Advanced Linked List Problems - FAANG Level">
            <meta property="og:description" content="Master 8 advanced problems combining all linked list techniques!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linked-list-advanced.jsp">
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
        "name": "Advanced Linked List Problems",
        "description": "Master advanced linked list problems combining all techniques - perfect for FAANG interviews.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Advanced Algorithms", "Problem Solving", "Interview Preparation", "Linked List Mastery"],
        "timeRequired": "PT30M",
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

        <body class="tutorial-body no-preview" data-lesson="linked-list-advanced">
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
                                    <span>Advanced Problems</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🚀 Advanced Linked List Problems</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                        <span class="interview-badge">⭐⭐⭐ FAANG Level</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You've mastered the fundamentals. Now it's time to combine them!
                                        <strong>Advanced linked list problems</strong> require using multiple techniques
                                        together: reversal + two pointers, dummy nodes + partition, slow-fast + merge.
                                        These are the problems asked at Google, Amazon, Microsoft, and Facebook!</p>

                                    <div class="warning-box">
                                        <h4>🎯 FAANG Interview Alert!</h4>
                                        <p><strong>These 8 problems appear frequently:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Merge Two Sorted Lists</strong> - Google, Amazon</li>
                                            <li>✅ <strong>Reorder List</strong> - Facebook, Microsoft</li>
                                            <li>✅ <strong>Add Two Numbers</strong> - Amazon, Apple</li>
                                            <li>✅ <strong>Partition List</strong> - LinkedIn, Google</li>
                                            <li>✅ <strong>Rotate List</strong> - Microsoft, Amazon</li>
                                            <li>✅ <strong>Remove Duplicates</strong> - Common warm-up</li>
                                            <li>✅ <strong>Clone with Random</strong> - Advanced challenge</li>
                                            <li>✅ <strong>Flatten Multilevel</strong> - Recursion test</li>
                                        </ul>
                                        <p><strong>Master these = Ace FAANG interviews!</strong></p>
                                    </div>

                                    <h2>The 8 Essential Problems</h2>

                                    <h3>See Them in Action</h3>
                                    <p>Watch how we combine techniques:</p>

                                    <div id="advancedLinkedListVisualization"></div>

                                    <h2>Problem 1: Merge Two Sorted Lists</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Merge two sorted linked lists into one sorted list.</p>
                                        <p><strong>Example:</strong></p>
                                        <pre><code>List 1: 1 → 3 → 5
List 2: 2 → 4 → 6
Merged: 1 → 2 → 3 → 4 → 5 → 6</code></pre>

                                        <p><strong>Solution: Two Pointers</strong></p>
                                        <pre><code class="language-python">def merge_sorted(list1, list2):
    dummy = Node(0)
    current = dummy
    
    while list1 and list2:
        if list1.data <= list2.data:
            current.next = list1
            list1 = list1.next
        else:
            current.next = list2
            list2 = list2.next
        current = current.next
    
    # Attach remaining
    current.next = list1 if list1 else list2
    
    return dummy.next</code></pre>

                                        <p><strong>Time:</strong> O(m + n), <strong>Space:</strong> O(1)</p>
                                    </div>

                                    <h2>Problem 2: Reorder List</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Reorder L0→L1→L2→...→Ln to L0→Ln→L1→Ln-1→L2→Ln-2...</p>
                                        <p><strong>Example:</strong></p>
                                        <pre><code>Input:  1 → 2 → 3 → 4 → 5
Output: 1 → 5 → 2 → 4 → 3</code></pre>

                                        <p><strong>Solution: Find Middle + Reverse + Merge</strong></p>
                                        <pre><code class="language-python">def reorder_list(head):
    # 1. Find middle (slow-fast)
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    # 2. Reverse second half
    prev = None
    current = slow
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    
    # 3. Merge alternating
    first = head
    second = prev
    while second.next:
        first_next = first.next
        second_next = second.next
        
        first.next = second
        second.next = first_next
        
        first = first_next
        second = second_next</code></pre>

                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(1)</p>
                                        <p><strong>Combines:</strong> Slow-fast + Reversal + Merge!</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Problem 3: Add Two Numbers</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Add two numbers represented as linked lists (digits in reverse order).</p>
                                        <p><strong>Example:</strong></p>
                                        <pre><code>342 + 465 = 807
Stored as: 2→4→3 + 5→6→4 = 7→0→8</code></pre>

                                        <p><strong>Solution: Handle Carry</strong></p>
                                        <pre><code class="language-python">def add_two_numbers(l1, l2):
    dummy = Node(0)
    current = dummy
    carry = 0
    
    while l1 or l2 or carry:
        val1 = l1.data if l1 else 0
        val2 = l2.data if l2 else 0
        
        total = val1 + val2 + carry
        carry = total // 10
        digit = total % 10
        
        current.next = Node(digit)
        current = current.next
        
        if l1: l1 = l1.next
        if l2: l2 = l2.next
    
    return dummy.next</code></pre>

                                        <p><strong>Time:</strong> O(max(m, n)), <strong>Space:</strong> O(max(m, n))</p>
                                    </div>

                                    <h2>Problem 4: Partition List</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Partition list so all nodes < x come before nodes ≥ x.</p>
                                                <p><strong>Example:</strong></p>
                                                <pre><code>Input:  3 → 5 → 8 → 5 → 10 → 2 → 1, x = 5
Output: 3 → 2 → 1 → 5 → 8 → 5 → 10</code></pre>

                                                <p><strong>Solution: Two Dummy Nodes</strong></p>
                                                <pre><code class="language-python">def partition(head, x):
    less_dummy = Node(0)
    greater_dummy = Node(0)
    
    less = less_dummy
    greater = greater_dummy
    
    while head:
        if head.data < x:
            less.next = head
            less = less.next
        else:
            greater.next = head
            greater = greater.next
        head = head.next
    
    greater.next = None
    less.next = greater_dummy.next
    
    return less_dummy.next</code></pre>

                                                <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(1)</p>
                                                <p><strong>Key:</strong> Dummy nodes simplify edge cases!</p>
                                    </div>

                                    <h2>Problem 5: Rotate List</h2>

                                    <div class="success-box">
                                        <h4>The Problem</h4>
                                        <p>Rotate list to the right by k places.</p>
                                        <p><strong>Example:</strong></p>
                                        <pre><code>Input:  1 → 2 → 3 → 4 → 5, k = 2
Output: 4 → 5 → 1 → 2 → 3</code></pre>

                                        <p><strong>Solution: Find New Head/Tail</strong></p>
                                        <pre><code class="language-python">def rotate_right(head, k):
    # Get length and tail
    length = 1
    tail = head
    while tail.next:
        length += 1
        tail = tail.next
    
    # Optimize k
    k = k % length
    if k == 0:
        return head
    
    # Find new tail
    new_tail = head
    for _ in range(length - k - 1):
        new_tail = new_tail.next
    
    # Rotate
    new_head = new_tail.next
    new_tail.next = None
    tail.next = head
    
    return new_head</code></pre>

                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(1)</p>
                                    </div>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linked-list-advanced.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-advanced" />
                                    </jsp:include>

                                    <h2>Complexity Summary</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Problem</th>
                                                <th>Time</th>
                                                <th>Space</th>
                                                <th>Technique</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Merge sorted lists</td>
                                                <td>O(m+n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Two pointers</td>
                                            </tr>
                                            <tr>
                                                <td>Reorder list</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Slow-fast + Reverse</td>
                                            </tr>
                                            <tr>
                                                <td>Add two numbers</td>
                                                <td>O(max(m,n))</td>
                                                <td>O(max(m,n))</td>
                                                <td>Carry handling</td>
                                            </tr>
                                            <tr>
                                                <td>Partition list</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Dummy nodes</td>
                                            </tr>
                                            <tr>
                                                <td>Rotate list</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Find new head</td>
                                            </tr>
                                            <tr>
                                                <td>Remove duplicates</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Single pass</td>
                                            </tr>
                                            <tr>
                                                <td>Clone with random</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Interweaving</td>
                                            </tr>
                                            <tr>
                                                <td>Flatten multilevel</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                                <td>Recursion/Stack</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Patterns</h2>

                                    <div class="info-box">
                                        <h4>Pattern Recognition</h4>
                                        <ol>
                                            <li><strong>Two Pointers:</strong> Merge, partition</li>
                                            <li><strong>Slow-Fast:</strong> Find middle for reorder</li>
                                            <li><strong>Reversal:</strong> Reorder, rotate</li>
                                            <li><strong>Dummy Nodes:</strong> Merge, partition, add numbers</li>
                                            <li><strong>Multiple Passes:</strong> Often clearer than single pass</li>
                                        </ol>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Advanced Problems</h4>
                                        <ul>
                                            <li>✅ <strong>Break into steps:</strong> Don't try to do everything at once
                                            </li>
                                            <li>✅ <strong>Use dummy nodes:</strong> Simplify edge cases</li>
                                            <li>✅ <strong>Draw it out:</strong> Visualize transformations</li>
                                            <li>✅ <strong>Combine techniques:</strong> Slow-fast + reverse + merge</li>
                                            <li>✅ <strong>Check edge cases:</strong> Empty, single node, even/odd</li>
                                            <li>✅ <strong>Explain your approach:</strong> Show you understand WHY</li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Advanced Problems Mastery</h3>
                                        <ol>
                                            <li><strong>Combine techniques:</strong> Use multiple patterns together</li>
                                            <li><strong>Dummy nodes are powerful:</strong> Simplify many problems</li>
                                            <li><strong>Break complex problems:</strong> Into manageable steps</li>
                                            <li><strong>Most are O(1) space:</strong> In-place solutions preferred</li>
                                            <li><strong>Practice these 8:</strong> They appear in FAANG interviews!</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Advanced problems
                                            test your ability to combine basic techniques. Draw the transformations,
                                            explain your approach step-by-step, and always check edge cases!</p>
                                    </div>

                                    <h2>Congratulations!</h2>
                                    <div class="success-box">
                                        <h3>🎉 You've Completed Module 5: Linked Lists!</h3>
                                        <p><strong>What you've mastered:</strong></p>
                                        <ul>
                                            <li>✅ Singly linked lists - basics and operations</li>
                                            <li>✅ Reversal - 3-pointer technique</li>
                                            <li>✅ Cycle detection - Floyd's algorithm</li>
                                            <li>✅ Two pointers - slow-fast and gap patterns</li>
                                            <li>✅ Doubly linked lists - bidirectional power</li>
                                            <li>✅ Circular linked lists - no end!</li>
                                            <li>✅ Advanced problems - combining everything!</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>You're now ready for FAANG linked list
                                                interviews!</strong> 🚀</p>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Next Module:</strong> Continue your DSA journey with more advanced data
                                        structures and algorithms!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="circular-linked-list.jsp" />
                                    <jsp:param name="prevTitle" value="Circular Linked List" />
                                    <jsp:param name="nextLink" value="stack-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Stack Basics" />
                                    <jsp:param name="currentLessonId" value="linked-list-advanced" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/advanced-linked-list-viz.js"></script>
        </body>

        </html>