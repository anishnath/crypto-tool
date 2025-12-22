<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "linked-list-basics" );
        request.setAttribute("currentModule", "Linked Lists" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Singly Linked List - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Singly Linked Lists - dynamic data structure with O(1) insert/delete at head. Foundation for stacks, queues, and graphs.">
            <meta name="keywords" content="linked list, singly linked list, pointers, dynamic data structure, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Singly Linked List - DSA Tutorial">
            <meta property="og:description"
                content="Learn Singly Linked Lists - foundation for advanced data structures.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/linked-list-basics.jsp">
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
        "name": "Singly Linked List",
        "description": "Learn Singly Linked Lists - dynamic data structure with pointer-based nodes.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["Linked Lists", "Pointers", "Dynamic Data Structures", "Node Operations"],
        "timeRequired": "PT15M",
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

        <body class="tutorial-body no-preview" data-lesson="linked-list-basics">
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
                                    <span>Singly Linked List</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔗 Singly Linked List</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner to Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Arrays require contiguous memory and fixed size. What if you need
                                        dynamic growth? Enter <strong>Linked Lists</strong> - a chain of nodes connected
                                        by pointers. Each node holds data and a reference to the next node. Perfect for
                                        when you need O(1) insert/delete at the beginning!</p>

                                    <h2>The Chain of Nodes</h2>

                                    <div class="info-box">
                                        <h4>What is a Linked List?</h4>
                                        <p>A <strong>linked list</strong> is a sequence of nodes where:</p>
                                        <ul>
                                            <li><strong>Each node contains:</strong> Data + Pointer to next node</li>
                                            <li><strong>Head:</strong> First node in the list</li>
                                            <li><strong>Tail:</strong> Last node (points to null)</li>
                                            <li><strong>Dynamic:</strong> Grows and shrinks as needed</li>
                                        </ul>
                                        <pre><code>head → [10|→] → [20|→] → [30|→] → null</code></pre>
                                    </div>

                                    <h3>Node Structure</h3>

                                    <div class="success-box">
                                        <h4>The Building Block</h4>
                                        <pre><code class="language-python">class Node:
    def __init__(self, data):
        self.data = data  # Store value
        self.next = None  # Pointer to next node</code></pre>
                                        <p><strong>That's it!</strong> Just data and a next pointer.</p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch how linked list operations work:</p>

                                    <div id="linkedListVisualization"></div>

                                    <h2>How Operations Work - Step by Step</h2>

                                    <p>Understanding linked list operations is crucial. Let's see exactly what happens
                                        during each operation, even if you don't play the animation!</p>

                                    <h3>1. Insert at HEAD - O(1)</h3>

                                    <div class="success-box">
                                        <h4>Why O(1)? Only 3 steps!</h4>
                                        <p><strong>Starting state:</strong></p>
                                        <pre><code>HEAD → [10] → [20] → [30] → null</code></pre>

                                        <p><strong>Want to insert 5 at HEAD:</strong></p>

                                        <p><strong>Step 1:</strong> Create new node with value 5</p>
                                        <pre><code>[5] (new node, not connected yet)</code></pre>

                                        <p><strong>Step 2:</strong> Point new node's next to current HEAD</p>
                                        <pre><code>[5] → [10] → [20] → [30] → null
                                        ↑
                                    (points to old HEAD)</code></pre>

                                        <p><strong>Step 3:</strong> Update HEAD to point to new node</p>
                                        <pre><code>HEAD → [5] → [10] → [20] → [30] → null
       ✓ New HEAD!</code></pre>

                                        <p><strong>Result:</strong> Done in 3 operations - <strong>O(1)</strong>! No
                                            matter how long the list is, always 3 steps.</p>
                                    </div>

                                    <h3>2. Insert at TAIL - O(n)</h3>

                                    <div class="warning-box">
                                        <h4>Why O(n)? Must traverse entire list!</h4>
                                        <p><strong>Starting state:</strong></p>
                                        <pre><code>HEAD → [10] → [20] → [30] → null
                              ↑ TAIL</code></pre>

                                        <p><strong>Want to insert 40 at TAIL:</strong></p>

                                        <p><strong>Step 1:</strong> Create new node with value 40</p>
                                        <pre><code>[40] (new node, not connected yet)</code></pre>

                                        <p><strong>Step 2:</strong> Traverse from HEAD to find TAIL</p>
                                        <pre><code>Visit [10] → not TAIL, continue
Visit [20] → not TAIL, continue
Visit [30] → next is null, this is TAIL!</code></pre>
                                        <p><em>Must visit every node - this is why it's O(n)!</em></p>

                                        <p><strong>Step 3:</strong> Point current TAIL's next to new node</p>
                                        <pre><code>HEAD → [10] → [20] → [30] → [40] → null
                              ↑ old TAIL  ↑ new TAIL</code></pre>

                                        <p><strong>Result:</strong> If list has n nodes, must visit all n nodes -
                                            <strong>O(n)</strong>!</p>
                                        <p><strong>Optimization:</strong> Keep a tail pointer → makes this O(1)!</p>
                                    </div>

                                    <h3>3. Delete HEAD - O(1)</h3>

                                    <div class="success-box">
                                        <h4>Why O(1)? Just move pointer!</h4>
                                        <p><strong>Starting state:</strong></p>
                                        <pre><code>HEAD → [10] → [20] → [30] → null</code></pre>

                                        <p><strong>Want to delete HEAD (10):</strong></p>

                                        <p><strong>Step 1:</strong> Identify current HEAD</p>
                                        <pre><code>HEAD → [10] ← Delete this!
        ↓
       [20] → [30] → null</code></pre>

                                        <p><strong>Step 2:</strong> Move HEAD pointer to next node</p>
                                        <pre><code>       [10] (will be garbage collected)
        
HEAD → [20] → [30] → null
       ✓ New HEAD!</code></pre>

                                        <p><strong>Result:</strong> Done in 2 operations - <strong>O(1)</strong>! Old
                                            head is automatically garbage collected.</p>
                                    </div>

                                    <h3>4. Search for Value - O(n)</h3>

                                    <div class="info-box">
                                        <h4>Why O(n)? Must check each node!</h4>
                                        <p><strong>Starting state:</strong></p>
                                        <pre><code>HEAD → [10] → [20] → [30] → null</code></pre>

                                        <p><strong>Want to find value 20:</strong></p>

                                        <p><strong>Step 1:</strong> Start at HEAD, check value</p>
                                        <pre><code>HEAD → [10] ← Check: 10 == 20? No, continue
        ↓
       [20] → [30] → null</code></pre>

                                        <p><strong>Step 2:</strong> Move to next, check value</p>
                                        <pre><code>HEAD → [10] → [20] ← Check: 20 == 20? YES! Found it!
               ↓
              [30] → null</code></pre>

                                        <p><strong>Result:</strong> Worst case: value is at end or not found - must
                                            check all n nodes - <strong>O(n)</strong>!</p>
                                        <p><strong>Best case:</strong> Value is at HEAD - O(1)</p>
                                        <p><strong>Average case:</strong> Value is in middle - O(n/2) = O(n)</p>
                                    </div>

                                    <h3>5. Delete TAIL - O(n)</h3>

                                    <div class="warning-box">
                                        <h4>Why O(n)? Must find second-to-last node!</h4>
                                        <p><strong>Starting state:</strong></p>
                                        <pre><code>HEAD → [10] → [20] → [30] → null
                              ↑ TAIL</code></pre>

                                        <p><strong>Want to delete TAIL (30):</strong></p>

                                        <p><strong>Problem:</strong> We need to set [20]'s next to null, but we can't go
                                            backwards!</p>

                                        <p><strong>Solution:</strong> Traverse to find second-to-last node</p>
                                        <pre><code>Visit [10] → next.next exists, continue
Visit [20] → next.next is null, this is second-to-last!</code></pre>

                                        <p><strong>Step 2:</strong> Set second-to-last's next to null</p>
                                        <pre><code>HEAD → [10] → [20] → null
                      ↑ new TAIL
              
              [30] (will be garbage collected)</code></pre>

                                        <p><strong>Result:</strong> Must traverse to find second-to-last -
                                            <strong>O(n)</strong>!</p>
                                        <p><strong>This is why doubly linked lists exist!</strong> They have prev
                                            pointers.</p>
                                    </div>

                                    <h3>Key Insights</h3>

                                    <div class="tip-box">
                                        <h4>💡 Understanding the Patterns</h4>
                                        <ul>
                                            <li><strong>O(1) operations:</strong> Work with HEAD directly (insert/delete
                                                at head)</li>
                                            <li><strong>O(n) operations:</strong> Need to traverse the list (anything
                                                with TAIL, search)</li>
                                            <li><strong>Why no backwards?</strong> Singly linked list only has "next"
                                                pointer, not "prev"</li>
                                            <li><strong>Memory trade-off:</strong> Each node needs extra space for the
                                                "next" pointer</li>
                                        </ul>
                                    </div>

                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/linked-list-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-ll-basics" />
                                    </jsp:include>

                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is insert at head O(1) but insert at tail O(n)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Insert at head: Just create new node, point it to current head, update
                                                head pointer - 3 operations, O(1)! Insert at tail: Must traverse entire
                                                list to find last node - O(n) operations. (Can be O(1) with tail
                                                pointer!)
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When would you use a linked list instead of an array?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Use linked list when: (1) Frequent insert/delete at beginning, (2) Don't
                                                know size in advance, (3) Don't need random access. Use array when: (1)
                                                Need O(1) access by index, (2) Size is known, (3) Memory locality
                                                matters.
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Time</th>
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Insert at head</td>
                                                <td>O(1) ✓</td>
                                                <td>Direct pointer update</td>
                                            </tr>
                                            <tr>
                                                <td>Insert at tail</td>
                                                <td>O(n)</td>
                                                <td>Must traverse to end</td>
                                            </tr>
                                            <tr>
                                                <td>Delete head</td>
                                                <td>O(1) ✓</td>
                                                <td>Move head to next</td>
                                            </tr>
                                            <tr>
                                                <td>Delete tail</td>
                                                <td>O(n)</td>
                                                <td>Must find second-last</td>
                                            </tr>
                                            <tr>
                                                <td>Search</td>
                                                <td>O(n)</td>
                                                <td>Must check each node</td>
                                            </tr>
                                            <tr>
                                                <td>Access by index</td>
                                                <td>O(n)</td>
                                                <td>Must traverse from head</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(n)</td>
                                                <td>Extra space for pointers</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Linked List vs Array</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Array</th>
                                                <th>Linked List</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Access by index</td>
                                                <td>O(1) ✓</td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td>Insert at head</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Insert at tail</td>
                                                <td>O(1) ✓</td>
                                                <td>O(n) or O(1)*</td>
                                            </tr>
                                            <tr>
                                                <td>Delete at head</td>
                                                <td>O(n)</td>
                                                <td>O(1) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Memory</td>
                                                <td>Contiguous ✓</td>
                                                <td>Scattered</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td>Fixed</td>
                                                <td>Dynamic ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Cache locality</td>
                                                <td>Better ✓</td>
                                                <td>Worse</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <p><small>* O(1) with tail pointer</small></p>

                                    <h2>When to Use Linked Lists</h2>

                                    <div class="success-box">
                                        <h4>✅ Use Linked List When:</h4>
                                        <ul>
                                            <li><strong>Frequent insert/delete at beginning:</strong> O(1) operations!
                                            </li>
                                            <li><strong>Unknown size:</strong> Dynamic growth</li>
                                            <li><strong>Implementing stacks/queues:</strong> Perfect fit</li>
                                            <li><strong>No random access needed:</strong> Sequential access is fine</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Use Array Instead When:</h4>
                                        <ul>
                                            <li><strong>Need random access:</strong> Array is O(1), list is O(n)</li>
                                            <li><strong>Cache locality matters:</strong> Arrays are contiguous</li>
                                            <li><strong>Memory overhead matters:</strong> Pointers use extra space</li>
                                            <li><strong>Size is known:</strong> Arrays are simpler</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Losing References</h4>
                                        <pre><code class="language-python"># WRONG - loses rest of list!
head = head.next  # Old head is lost!

# RIGHT - save reference first
temp = head
head = head.next
# Can still access temp if needed</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Not Checking for NULL</h4>
                                        <pre><code class="language-python"># WRONG - crashes if list is empty!
print(head.data)

# RIGHT - check first
if head is not None:
    print(head.data)</code></pre>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Singly Linked List is the <strong>foundation for dynamic data
                                                structures</strong>:</p>
                                        <ul>
                                            <li>✅ O(1) insert/delete at head - faster than arrays!</li>
                                            <li>✅ Dynamic size - grows as needed</li>
                                            <li>✅ Foundation for stacks, queues, graphs</li>
                                            <li>⚠️ O(n) access by index - slower than arrays</li>
                                            <li>⚠️ Extra memory for pointers</li>
                                        </ul>
                                        <p><strong>Master pointers - they're everywhere in interviews!</strong></p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Linked List Guide</h3>
                                        <ol>
                                            <li><strong>Structure:</strong> Chain of nodes, each with data + next
                                                pointer</li>
                                            <li><strong>Strength:</strong> O(1) insert/delete at head, dynamic size</li>
                                            <li><strong>Weakness:</strong> O(n) access by index, no cache locality</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Always check for
                                            null pointers! Draw the list on paper to visualize pointer changes. Most
                                            linked list bugs are from losing references or null pointer errors.</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've learned the basics! Next: <strong>Linked List Reversal</strong> - one of
                                        the most common interview problems!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement a linked list from scratch. Try reversing
                                        it. Practice on paper first - draw the pointers!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="exponential-search.jsp" />
                                    <jsp:param name="prevTitle" value="Exponential Search" />
                                    <jsp:param name="nextLink" value="linked-list-reversal.jsp" />
                                    <jsp:param name="nextTitle" value="Linked List Reversal" />
                                    <jsp:param name="currentLessonId" value="linked-list-basics" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/linked-list-viz.js"></script>
        </body>

        </html>