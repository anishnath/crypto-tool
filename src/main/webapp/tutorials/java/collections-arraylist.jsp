<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-arraylist" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java ArrayList - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java ArrayList. Understand dynamic arrays, adding, removing, and accessing elements in the Collections Framework.">
            <meta name="keywords"
                content="java arraylist, java dynamic array, java collections arraylist, arraylist vs array, java list interface">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java ArrayList - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the most generic used collection in Java: The ArrayList.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-arraylist.jsp">
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
    "name": "Java ArrayList",
    "description": "Guide to using ArrayLists in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["ArrayList Basics", "Add/Remove Elements", "Resizing Arrays"],
    "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="collections-arraylist">
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
                                    <span>ArrayList</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java ArrayList</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>ArrayList</code> class is the most commonly used collection
                                        in Java. It's a resizable array implementation of the <code>List</code> interface,
                                        offering fast random access and dynamic sizing.</p>

                                    <!-- Section 1: Array vs ArrayList -->
                                    <h2>Array vs ArrayList</h2>
                                    <p>Unlike fixed-size arrays, <code>ArrayList</code> grows and shrinks automatically:</p>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Array</th>
                                                <th>ArrayList</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Size</strong></td>
                                                <td>Fixed at creation</td>
                                                <td>Dynamic (grows/shrinks)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Type</strong></td>
                                                <td>Primitives and Objects</td>
                                                <td>Objects only (use wrappers)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Methods</strong></td>
                                                <td>Only <code>.length</code></td>
                                                <td>add(), remove(), contains(), etc.</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Performance</strong></td>
                                                <td>Slightly faster</td>
                                                <td>Slight overhead for flexibility</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-arraylist-structure.svg"
                                            alt="Java ArrayList Internal Structure Diagram"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 2: Creating ArrayList -->
                                    <h2>Creating an ArrayList</h2>
                                    <pre><code class="language-java">import java.util.ArrayList;
import java.util.List;

// Standard way - specify type in angle brackets (generics)
ArrayList&lt;String&gt; cars = new ArrayList&lt;String&gt;();

// Diamond operator (Java 7+) - type inferred
ArrayList&lt;String&gt; cars = new ArrayList&lt;&gt;();

// Best practice: program to interface
List&lt;String&gt; cars = new ArrayList&lt;&gt;();

// With initial capacity (optimization)
List&lt;String&gt; bigList = new ArrayList&lt;&gt;(1000);</code></pre>

                                    <!-- Section 3: Operations -->
                                    <h2>Essential Operations</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Method</th>
                                                <th>Time Complexity</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Add at end</td>
                                                <td><code>add(element)</code></td>
                                                <td>O(1) amortized</td>
                                            </tr>
                                            <tr>
                                                <td>Add at index</td>
                                                <td><code>add(index, element)</code></td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td>Get by index</td>
                                                <td><code>get(index)</code></td>
                                                <td>O(1)</td>
                                            </tr>
                                            <tr>
                                                <td>Set at index</td>
                                                <td><code>set(index, element)</code></td>
                                                <td>O(1)</td>
                                            </tr>
                                            <tr>
                                                <td>Remove by index</td>
                                                <td><code>remove(index)</code></td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td>Search</td>
                                                <td><code>contains(element)</code></td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td><code>size()</code></td>
                                                <td>O(1)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ArrayListExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-arraylist" />
                                    </jsp:include>

                                    <!-- Section 4: Looping -->
                                    <h2>Iterating Through ArrayList</h2>
                                    <pre><code class="language-java">List&lt;String&gt; fruits = new ArrayList&lt;&gt;();
fruits.add("Apple");
fruits.add("Banana");
fruits.add("Cherry");

// 1. For-each loop (preferred for reading)
for (String fruit : fruits) {
    System.out.println(fruit);
}

// 2. Traditional for loop (when you need index)
for (int i = 0; i < fruits.size(); i++) {
    System.out.println(i + ": " + fruits.get(i));
}

// 3. Iterator (when removing during iteration)
Iterator&lt;String&gt; it = fruits.iterator();
while (it.hasNext()) {
    if (it.next().startsWith("B")) {
        it.remove();  // Safe removal
    }
}

// 4. Java 8+ forEach with lambda
fruits.forEach(fruit -> System.out.println(fruit));

// 5. Java 8+ Stream API
fruits.stream()
      .filter(f -> f.length() > 5)
      .forEach(System.out::println);</code></pre>

                                    <!-- Section 5: Useful Methods -->
                                    <h2>More Useful Methods</h2>
                                    <pre><code class="language-java">List&lt;Integer&gt; numbers = new ArrayList&lt;&gt;();
numbers.addAll(Arrays.asList(5, 2, 8, 1, 9));

// Sorting
Collections.sort(numbers);           // [1, 2, 5, 8, 9]
Collections.reverse(numbers);        // [9, 8, 5, 2, 1]

// Searching (list must be sorted for binarySearch)
Collections.sort(numbers);
int idx = Collections.binarySearch(numbers, 5);

// Min/Max
int min = Collections.min(numbers);  // 1
int max = Collections.max(numbers);  // 9

// Sublist (view, not copy)
List&lt;Integer&gt; sub = numbers.subList(1, 4);

// Convert to array
Integer[] arr = numbers.toArray(new Integer[0]);

// Check if empty
boolean empty = numbers.isEmpty();</code></pre>

                                    <!-- Section 6: Wrapper Classes -->
                                    <h2>Wrapper Classes for Primitives</h2>
                                    <p>ArrayList can only store objects. For primitive types, use wrapper classes:</p>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Primitive</th>
                                                <th>Wrapper Class</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr><td><code>int</code></td><td><code>Integer</code></td></tr>
                                            <tr><td><code>double</code></td><td><code>Double</code></td></tr>
                                            <tr><td><code>boolean</code></td><td><code>Boolean</code></td></tr>
                                            <tr><td><code>char</code></td><td><code>Character</code></td></tr>
                                            <tr><td><code>long</code></td><td><code>Long</code></td></tr>
                                        </tbody>
                                    </table>
                                    <pre><code class="language-java">// Autoboxing: Java automatically converts
ArrayList&lt;Integer&gt; nums = new ArrayList&lt;&gt;();
nums.add(42);        // int autoboxed to Integer
int n = nums.get(0); // Integer unboxed to int</code></pre>

                                    <div class="info-box">
                                        <strong>When to Use ArrayList:</strong>
                                        <ul style="margin-bottom: 0;">
                                            <li>You need fast random access by index - O(1)</li>
                                            <li>You mostly add elements at the end</li>
                                            <li>You rarely insert/delete in the middle</li>
                                            <li>You don't know the size in advance</li>
                                        </ul>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>ArrayList</strong> is a dynamic array with O(1) random access</li>
                                            <li>Use <code>List&lt;Type&gt;</code> interface for flexibility</li>
                                            <li>Best for: reading by index, appending elements</li>
                                            <li>Avoid for: frequent insertions/deletions in middle</li>
                                            <li>Use wrapper classes for primitive types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% // Linking to end of previous module (Polymorphism) -> Overview
                                            String prevLinkUrl = request.getContextPath() +
                                            "/tutorials/java/collections-overview.jsp";
                                            String nextLinkUrl = request.getContextPath() +
                                            "/tutorials/java/collections-linkedlist.jsp";
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Collections Overview" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="LinkedList →" />
                                                <jsp:param name="currentLessonId" value="collections-arraylist" />
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