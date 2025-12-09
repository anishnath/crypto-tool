<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-overview" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Collections Framework - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Overview of the Java Collections Framework. Understand the hierarchy of interfaces like List, Set, and Map.">
            <meta name="keywords"
                content="java collections framework, java list set map, java collection hierarchy, java iterable">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Collections Framework - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the Java Collections Framework for managing data structures.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-overview.jsp">
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
    "name": "Java Collections Framework",
    "description": "Overview of Java Collections.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Collections Hierarchy", "List vs Set vs Map"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-overview">
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
                                    <span>Collections Overview</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Collections Framework</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <strong>Collections Framework</strong> provides a unified architecture
                                        for storing, manipulating, and retrieving groups of objects. It's one of the most
                                        important parts of Java's standard library.</p>

                                    <h2>Why Use Collections?</h2>
                                    <p>Before collections, Java programmers had to use arrays, which have significant limitations:</p>
                                    <ul>
                                        <li><strong>Fixed Size:</strong> Arrays cannot grow or shrink after creation</li>
                                        <li><strong>No Built-in Methods:</strong> No add, remove, or search operations</li>
                                        <li><strong>Type Safety:</strong> Arrays don't prevent mixing incompatible types at compile time</li>
                                    </ul>
                                    <p>Collections solve all these problems and provide powerful, type-safe data structures.</p>

                                    <h2>The Hierarchy</h2>
                                    <p>The root interface is <code>Collection</code> (which extends <code>Iterable</code>).
                                        Note that <code>Map</code> is NOT part of the Collection hierarchy but is still considered
                                        part of the Collections Framework.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-collections-hierarchy.svg"
                                            alt="Java Collections Framework Hierarchy Diagram"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <ul class="file-tree">
                                        <li><strong>Collection</strong> (extends Iterable)
                                            <ul>
                                                <li><strong>List</strong>: Ordered sequence, allows duplicates, index-based access
                                                    <ul>
                                                        <li>ArrayList - Fast random access, slow insert/delete</li>
                                                        <li>LinkedList - Fast insert/delete, slow random access</li>
                                                    </ul>
                                                </li>
                                                <li><strong>Set</strong>: Unique elements only
                                                    <ul>
                                                        <li>HashSet - O(1) operations, unordered</li>
                                                        <li>TreeSet - O(log n) operations, sorted</li>
                                                        <li>LinkedHashSet - O(1) operations, insertion order</li>
                                                    </ul>
                                                </li>
                                                <li><strong>Queue</strong>: FIFO (First-In-First-Out) ordering
                                                    <ul>
                                                        <li>PriorityQueue - Elements ordered by priority</li>
                                                        <li>ArrayDeque - Double-ended queue, fast operations</li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </li>
                                        <li><strong>Map</strong> (Separate hierarchy): Key-Value pairs
                                            <ul>
                                                <li>HashMap - O(1) operations, unordered keys</li>
                                                <li>TreeMap - O(log n) operations, sorted keys</li>
                                                <li>LinkedHashMap - O(1) operations, insertion order</li>
                                            </ul>
                                        </li>
                                    </ul>

                                    <h2>Key Interfaces</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Interface</th>
                                                <th>Description</th>
                                                <th>Common Implementations</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>List</code></td>
                                                <td>Ordered collection with index-based access. Allows duplicate elements.</td>
                                                <td>ArrayList, LinkedList, Vector</td>
                                            </tr>
                                            <tr>
                                                <td><code>Set</code></td>
                                                <td>Collection with no duplicate elements. Models mathematical set abstraction.</td>
                                                <td>HashSet, TreeSet, LinkedHashSet</td>
                                            </tr>
                                            <tr>
                                                <td><code>Queue</code></td>
                                                <td>Collection designed for holding elements prior to processing.</td>
                                                <td>PriorityQueue, ArrayDeque</td>
                                            </tr>
                                            <tr>
                                                <td><code>Map</code></td>
                                                <td>Object that maps unique keys to values. Cannot contain duplicate keys.</td>
                                                <td>HashMap, TreeMap, LinkedHashMap</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Choosing the Right Collection</h2>
                                    <div class="info-box">
                                        <strong>Decision Guide:</strong>
                                        <ul style="margin-bottom: 0;">
                                            <li><strong>Need key-value pairs?</strong> &rarr; Use a <code>Map</code></li>
                                            <li><strong>Need unique elements?</strong> &rarr; Use a <code>Set</code></li>
                                            <li><strong>Need ordered with duplicates?</strong> &rarr; Use a <code>List</code></li>
                                            <li><strong>Need FIFO processing?</strong> &rarr; Use a <code>Queue</code></li>
                                        </ul>
                                    </div>

                                    <h2>Time Complexity Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Collection</th>
                                                <th>Add</th>
                                                <th>Remove</th>
                                                <th>Search</th>
                                                <th>Access by Index</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>ArrayList</code></td>
                                                <td>O(1)*</td>
                                                <td>O(n)</td>
                                                <td>O(n)</td>
                                                <td>O(1)</td>
                                            </tr>
                                            <tr>
                                                <td><code>LinkedList</code></td>
                                                <td>O(1)</td>
                                                <td>O(1)**</td>
                                                <td>O(n)</td>
                                                <td>O(n)</td>
                                            </tr>
                                            <tr>
                                                <td><code>HashSet/HashMap</code></td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>N/A</td>
                                            </tr>
                                            <tr>
                                                <td><code>TreeSet/TreeMap</code></td>
                                                <td>O(log n)</td>
                                                <td>O(log n)</td>
                                                <td>O(log n)</td>
                                                <td>N/A</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p><small>* Amortized time (occasional resize). ** When position is known.</small></p>

                                    <h2>Common Collection Methods</h2>
                                    <p>All collections share these methods from the <code>Collection</code> interface:</p>
                                    <pre><code class="language-java">// Adding elements
collection.add(element);
collection.addAll(otherCollection);

// Removing elements
collection.remove(element);
collection.removeAll(otherCollection);
collection.clear();

// Querying
collection.size();
collection.isEmpty();
collection.contains(element);

// Converting
collection.toArray();
collection.stream();  // Java 8+</code></pre>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/polymorphism-runtime.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-arraylist.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Polymorphism" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="ArrayList →" />
                                                <jsp:param name="currentLessonId" value="collections-overview" />
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