<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-linkedlist" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java LinkedList - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java LinkedList. Understand the differences between ArrayList and LinkedList, and when to use each.">
            <meta name="keywords"
                content="java linkedlist, arraylist vs linkedlist, java doubly linked list, addfirst addlast, removefirst removelast">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java LinkedList - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the LinkedList data structure in Java and optimize your data manipulation.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-linkedlist.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

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
    "name": "Java LinkedList",
    "description": "Guide to using LinkedList in Java and comparing it with ArrayList.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["LinkedList Basics", "ArrayList vs LinkedList", "Stack and Queue methods"],
    "timeRequired": "PT15M",
    "isPartOf": {
        "@type": "Course",
        "name": "Java Tutorial",
        "url": "https://8gwifi.org/tutorials/java/"
    }
}
</script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="collections-linkedlist">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>LinkedList</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java LinkedList</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>LinkedList</code> class implements both <code>List</code>
                                        and <code>Deque</code> interfaces, making it versatile for lists, stacks, and queues.
                                        It uses a doubly-linked list structure internally.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-linkedlist-structure.svg"
                                            alt="Java LinkedList Internal Structure Diagram"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <h2>How LinkedList Works</h2>
                                    <p>Each element is stored in a <strong>Node</strong> that contains:</p>
                                    <ul>
                                        <li>The actual data (element)</li>
                                        <li>A reference to the <strong>previous</strong> node</li>
                                        <li>A reference to the <strong>next</strong> node</li>
                                    </ul>
                                    <pre><code class="language-java">// Internal Node structure (simplified)
private static class Node&lt;E&gt; {
    E item;
    Node&lt;E&gt; next;
    Node&lt;E&gt; prev;
}</code></pre>

                                    <!-- Section 1: ArrayList vs LinkedList -->
                                    <h2>ArrayList vs. LinkedList</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>ArrayList</th>
                                                <th>LinkedList</th>
                                                <th>Winner</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>get(index)</strong></td>
                                                <td>O(1) - Direct access</td>
                                                <td>O(n) - Must traverse</td>
                                                <td>ArrayList</td>
                                            </tr>
                                            <tr>
                                                <td><strong>add(element)</strong></td>
                                                <td>O(1) amortized</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td><strong>add(0, element)</strong></td>
                                                <td>O(n) - Shift all</td>
                                                <td>O(1)</td>
                                                <td>LinkedList</td>
                                            </tr>
                                            <tr>
                                                <td><strong>remove(0)</strong></td>
                                                <td>O(n) - Shift all</td>
                                                <td>O(1)</td>
                                                <td>LinkedList</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Memory</strong></td>
                                                <td>Compact array</td>
                                                <td>Extra node overhead</td>
                                                <td>ArrayList</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Iterator remove</strong></td>
                                                <td>O(n)</td>
                                                <td>O(1)</td>
                                                <td>LinkedList</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>When to Use LinkedList:</strong>
                                        <ul style="margin-bottom: 0;">
                                            <li>Frequent insertions/deletions at beginning or middle</li>
                                            <li>Implementing a Queue (FIFO) or Stack (LIFO)</li>
                                            <li>You iterate and remove elements frequently</li>
                                            <li>You don't need random access by index</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Creating LinkedList -->
                                    <h2>Creating a LinkedList</h2>
                                    <pre><code class="language-java">import java.util.LinkedList;
import java.util.List;
import java.util.Deque;

// As a List
List&lt;String&gt; list = new LinkedList&lt;&gt;();

// As a Deque (Double-ended queue)
Deque&lt;String&gt; deque = new LinkedList&lt;&gt;();

// Direct type (for LinkedList-specific methods)
LinkedList&lt;String&gt; linkedList = new LinkedList&lt;&gt;();</code></pre>

                                    <!-- Section 3: Special Methods -->
                                    <h2>Deque Methods (Double-Ended Queue)</h2>
                                    <p>LinkedList implements <code>Deque</code>, providing powerful head/tail operations:</p>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>First Element</th>
                                                <th>Last Element</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Add</strong></td>
                                                <td><code>addFirst(e)</code></td>
                                                <td><code>addLast(e)</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Remove</strong></td>
                                                <td><code>removeFirst()</code></td>
                                                <td><code>removeLast()</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Get</strong></td>
                                                <td><code>getFirst()</code></td>
                                                <td><code>getLast()</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Peek (no exception)</strong></td>
                                                <td><code>peekFirst()</code></td>
                                                <td><code>peekLast()</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Poll (no exception)</strong></td>
                                                <td><code>pollFirst()</code></td>
                                                <td><code>pollLast()</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/LinkedListExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-linkedlist" />
                                    </jsp:include>

                                    <!-- Section 4: Use as Stack/Queue -->
                                    <h2>Using LinkedList as Stack and Queue</h2>
                                    <pre><code class="language-java">LinkedList&lt;String&gt; stack = new LinkedList&lt;&gt;();

// Stack operations (LIFO - Last In First Out)
stack.push("First");    // Same as addFirst()
stack.push("Second");
stack.push("Third");
String top = stack.pop();  // "Third" - removeFirst()
String peek = stack.peek(); // "Second" - peekFirst()

// Queue operations (FIFO - First In First Out)
LinkedList&lt;String&gt; queue = new LinkedList&lt;&gt;();
queue.offer("First");   // Same as addLast()
queue.offer("Second");
queue.offer("Third");
String first = queue.poll(); // "First" - pollFirst()
String next = queue.peek();  // "Second" - peekFirst()</code></pre>

                                    <!-- Section 5: Iteration -->
                                    <h2>Efficient Iteration</h2>
                                    <pre><code class="language-java">LinkedList&lt;String&gt; list = new LinkedList&lt;&gt;();
list.addAll(Arrays.asList("A", "B", "C", "D", "E"));

// Good: Using Iterator (O(n) total)
Iterator&lt;String&gt; it = list.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
}

// Good: For-each loop
for (String s : list) {
    System.out.println(s);
}

// BAD: Using get(i) - O(n²) total!
// Each get(i) traverses from head
for (int i = 0; i < list.size(); i++) {
    System.out.println(list.get(i)); // Slow!
}

// Good: Descending Iterator
Iterator&lt;String&gt; descIt = list.descendingIterator();
while (descIt.hasNext()) {
    System.out.println(descIt.next()); // E, D, C, B, A
}</code></pre>

                                    <div class="warning-box" style="background: #fff3e0; border-left: 4px solid #ff9800; padding: 1rem; margin: 1rem 0;">
                                        <strong>Performance Warning:</strong> Never use <code>get(i)</code> in a loop
                                        with LinkedList! Each call is O(n), making the loop O(n²). Use an Iterator instead.
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>LinkedList</strong> uses doubly-linked nodes - O(1) insert/delete at ends</li>
                                            <li>Implements both <code>List</code> and <code>Deque</code> interfaces</li>
                                            <li>Best for: Stack/Queue operations, frequent insert/delete</li>
                                            <li>Avoid for: Random access by index (use ArrayList instead)</li>
                                            <li>Always iterate with Iterator or for-each, never with get(i)</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-arraylist.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-hashset.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="ArrayList" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="HashSet →" />
                                                <jsp:param name="currentLessonId" value="collections-linkedlist" />
                                            </jsp:include>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>