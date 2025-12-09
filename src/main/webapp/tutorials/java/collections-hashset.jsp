<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-hashset" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java HashSet - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java HashSet. Understand how to use Sets to store unique elements and perform efficient lookups.">
            <meta name="keywords"
                content="java hashset, set interface, unique elements, remove duplicates java, hashset example">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java HashSet - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="A comprehensive guide to using HashSet for storing unique collections in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-hashset.jsp">
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
    "name": "Java HashSet",
    "description": "Guide to using HashSet in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["HashSet Basics", "Uniqueness", "Handling Duplicates"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-hashset">
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
                                    <span>HashSet</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java HashSet</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <code>HashSet</code> is the most commonly used <code>Set</code>
                                        implementation. It stores unique elements using a hash table, providing O(1)
                                        average time for add, remove, and contains operations.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-hashset-buckets.svg"
                                            alt="Java HashSet Internal Structure with Buckets"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 1: How HashSet Works -->
                                    <h2>How HashSet Works</h2>
                                    <p>HashSet is backed by a <code>HashMap</code> internally. When you add an element:</p>
                                    <ol>
                                        <li>The element's <code>hashCode()</code> is calculated</li>
                                        <li>The hash determines which "bucket" to use</li>
                                        <li><code>equals()</code> checks if element already exists in that bucket</li>
                                        <li>If unique, element is added; if duplicate, it's ignored</li>
                                    </ol>

                                    <div class="info-box">
                                        <strong>Important:</strong> For custom objects in HashSet, you MUST override both
                                        <code>hashCode()</code> and <code>equals()</code> methods for correct behavior.
                                    </div>

                                    <!-- Section 2: Key Features -->
                                    <h2>Key Characteristics</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>HashSet</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Duplicates</strong></td>
                                                <td>Not allowed (silently ignored)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Null elements</strong></td>
                                                <td>One null allowed</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Order</strong></td>
                                                <td>No guaranteed order</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Thread-safe</strong></td>
                                                <td>No (use Collections.synchronizedSet())</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Performance</strong></td>
                                                <td>O(1) average for add, remove, contains</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 3: Creating HashSet -->
                                    <h2>Creating a HashSet</h2>
                                    <pre><code class="language-java">import java.util.HashSet;
import java.util.Set;
import java.util.Arrays;

// Standard way
Set&lt;String&gt; fruits = new HashSet&lt;&gt;();

// With initial capacity (default is 16)
Set&lt;String&gt; bigSet = new HashSet&lt;&gt;(1000);

// From existing collection
List&lt;String&gt; list = Arrays.asList("A", "B", "A", "C");
Set&lt;String&gt; unique = new HashSet&lt;&gt;(list); // {A, B, C}

// Java 9+ factory method (immutable)
Set&lt;String&gt; immutable = Set.of("A", "B", "C");</code></pre>

                                    <!-- Section 4: Operations -->
                                    <h2>Essential Operations</h2>
                                    <pre><code class="language-java">Set&lt;String&gt; colors = new HashSet&lt;&gt;();

// Adding elements
colors.add("Red");      // true (added)
colors.add("Green");    // true (added)
colors.add("Red");      // false (duplicate ignored)

// Checking membership - O(1)
boolean hasRed = colors.contains("Red");   // true
boolean hasBlue = colors.contains("Blue"); // false

// Removing elements
colors.remove("Green"); // true (removed)
colors.remove("Pink");  // false (not found)

// Size and empty check
int size = colors.size();      // 1
boolean empty = colors.isEmpty(); // false

// Clear all
colors.clear();</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/HashSetExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-hashset" />
                                    </jsp:include>

                                    <!-- Section 5: Set Operations -->
                                    <h2>Set Operations (Union, Intersection, Difference)</h2>
                                    <pre><code class="language-java">Set&lt;Integer&gt; setA = new HashSet&lt;&gt;(Arrays.asList(1, 2, 3, 4));
Set&lt;Integer&gt; setB = new HashSet&lt;&gt;(Arrays.asList(3, 4, 5, 6));

// Union (A ∪ B) - all elements from both sets
Set&lt;Integer&gt; union = new HashSet&lt;&gt;(setA);
union.addAll(setB);  // {1, 2, 3, 4, 5, 6}

// Intersection (A ∩ B) - common elements
Set&lt;Integer&gt; intersection = new HashSet&lt;&gt;(setA);
intersection.retainAll(setB);  // {3, 4}

// Difference (A - B) - elements in A but not in B
Set&lt;Integer&gt; difference = new HashSet&lt;&gt;(setA);
difference.removeAll(setB);  // {1, 2}

// Subset check
boolean isSubset = setA.containsAll(setB); // false</code></pre>

                                    <!-- Section 6: Custom Objects -->
                                    <h2>Using Custom Objects</h2>
                                    <pre><code class="language-java">class Person {
    String name;
    int age;

    // MUST override equals and hashCode!
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Person)) return false;
        Person p = (Person) o;
        return age == p.age && Objects.equals(name, p.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }
}

// Now HashSet works correctly with Person objects
Set&lt;Person&gt; people = new HashSet&lt;&gt;();</code></pre>

                                    <!-- Section 7: Comparison -->
                                    <h2>When to Use Which Set?</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Set Type</th>
                                                <th>Order</th>
                                                <th>Performance</th>
                                                <th>Use When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>HashSet</code></td>
                                                <td>None</td>
                                                <td>O(1)</td>
                                                <td>Best general-purpose choice</td>
                                            </tr>
                                            <tr>
                                                <td><code>LinkedHashSet</code></td>
                                                <td>Insertion order</td>
                                                <td>O(1)</td>
                                                <td>Need predictable iteration</td>
                                            </tr>
                                            <tr>
                                                <td><code>TreeSet</code></td>
                                                <td>Sorted</td>
                                                <td>O(log n)</td>
                                                <td>Need sorted elements</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>HashSet</strong> provides O(1) performance for most operations</li>
                                            <li>No duplicates - uses <code>equals()</code> and <code>hashCode()</code></li>
                                            <li>No guaranteed iteration order</li>
                                            <li>Perfect for: removing duplicates, membership testing, set operations</li>
                                            <li>Custom objects need proper <code>equals()</code> and <code>hashCode()</code></li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-linkedlist.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-treeset.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="LinkedList" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="TreeSet →" />
                                                <jsp:param name="currentLessonId" value="collections-hashset" />
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