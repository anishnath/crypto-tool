<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-iterators" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Iterators - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use Java Iterators to traverse collections and safely remove elements while looping.">
            <meta name="keywords"
                content="java iterator, iterator interface, hasnext next remove, iterating collections, java loop removal">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Iterators - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the Iterator pattern in Java for safe collection traversal and modification.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-iterators.jsp">
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
    "name": "Java Iterators",
    "description": "Guide to using Iterators in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Iterator Basics", "hasNext and next methods", "Safe Removal"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-iterators">
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
                                    <span>Iterators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Iterators</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An <code>Iterator</code> is a design pattern that provides a standard
                                        way to traverse any Collection without exposing its internal structure. It's
                                        essential for safely modifying collections during iteration.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-iterators.svg"
                                            alt="Java Iterator Pattern and Safe Collection Modification"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 1: Why Iterators? -->
                                    <h2>Why Use Iterators?</h2>
                                    <ul>
                                        <li><strong>Uniform traversal:</strong> Same approach works for any Collection</li>
                                        <li><strong>Safe removal:</strong> Only way to remove elements during iteration</li>
                                        <li><strong>Encapsulation:</strong> Don't need to know internal structure</li>
                                        <li><strong>Fail-fast:</strong> Detects concurrent modifications immediately</li>
                                    </ul>

                                    <!-- Section 2: Iterator Interface -->
                                    <h2>The Iterator Interface</h2>
                                    <pre><code class="language-java">public interface Iterator&lt;E&gt; {
    boolean hasNext();  // Returns true if more elements exist
    E next();           // Returns next element, advances cursor
    void remove();      // Removes last element returned by next()

    // Java 8+ default method
    void forEachRemaining(Consumer&lt;? super E&gt; action);
}</code></pre>

                                    <!-- Section 3: Basic Usage -->
                                    <h2>Basic Usage</h2>
                                    <pre><code class="language-java">import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;

List&lt;String&gt; names = new ArrayList&lt;&gt;();
names.add("Alice");
names.add("Bob");
names.add("Charlie");

// Get iterator
Iterator&lt;String&gt; it = names.iterator();

// Classic iteration pattern
while (it.hasNext()) {
    String name = it.next();
    System.out.println(name);
}

// Java 8+ forEachRemaining
Iterator&lt;String&gt; it2 = names.iterator();
it2.forEachRemaining(name -> System.out.println(name));</code></pre>

                                    <!-- Section 4: Safe Removal -->
                                    <h2>Safe Removal During Iteration</h2>
                                    <p>This is the main reason to use Iterator over for-each loops:</p>
                                    <pre><code class="language-java">List&lt;Integer&gt; numbers = new ArrayList&lt;&gt;(
    Arrays.asList(1, 5, 12, 3, 8, 15, 7, 20)
);

// CORRECT: Using Iterator.remove()
Iterator&lt;Integer&gt; it = numbers.iterator();
while (it.hasNext()) {
    Integer num = it.next();
    if (num &gt; 10) {
        it.remove();  // Safe! Removes current element
    }
}
// numbers is now [1, 5, 3, 8, 7]

// WRONG: Modifying during for-each
for (Integer num : numbers) {
    if (num &gt; 10) {
        numbers.remove(num);  // Throws ConcurrentModificationException!
    }
}</code></pre>

                                    <div class="warning-box" style="background: #ffebee; border-left: 4px solid #e53935; padding: 1rem; margin: 1rem 0;">
                                        <strong>ConcurrentModificationException:</strong> This occurs when a collection
                                        is modified while iterating with for-each. Always use <code>Iterator.remove()</code>
                                        or Java 8+ <code>removeIf()</code> instead.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/IteratorExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-iterators" />
                                    </jsp:include>

                                    <!-- Section 5: ListIterator -->
                                    <h2>ListIterator (For Lists Only)</h2>
                                    <p><code>ListIterator</code> extends Iterator with bidirectional traversal and modification:</p>
                                    <pre><code class="language-java">List&lt;String&gt; list = new ArrayList&lt;&gt;(Arrays.asList("A", "B", "C", "D"));
ListIterator&lt;String&gt; lit = list.listIterator();

// Forward traversal
while (lit.hasNext()) {
    int index = lit.nextIndex();
    String element = lit.next();
    System.out.println(index + ": " + element);
}

// Backward traversal
while (lit.hasPrevious()) {
    int index = lit.previousIndex();
    String element = lit.previous();
    System.out.println(index + ": " + element);
}

// Start from specific index
ListIterator&lt;String&gt; fromMiddle = list.listIterator(2); // Start at index 2

// Modify during iteration
ListIterator&lt;String&gt; modifier = list.listIterator();
while (modifier.hasNext()) {
    String s = modifier.next();
    if (s.equals("B")) {
        modifier.set("B-modified");  // Replace current element
    }
    if (s.equals("C")) {
        modifier.add("C-extra");     // Add after current element
    }
}</code></pre>

                                    <!-- Section 6: Java 8+ Alternatives -->
                                    <h2>Java 8+ Alternatives</h2>
                                    <pre><code class="language-java">List&lt;Integer&gt; numbers = new ArrayList&lt;&gt;(
    Arrays.asList(1, 5, 12, 3, 8, 15, 7, 20)
);

// removeIf() - Cleaner than Iterator for simple removal
numbers.removeIf(n -> n &gt; 10);  // Same result as Iterator example

// Stream filter (creates new collection)
List&lt;Integer&gt; filtered = numbers.stream()
    .filter(n -> n &lt;= 10)
    .collect(Collectors.toList());

// forEach with lambda
numbers.forEach(n -> System.out.println(n));

// replaceAll
numbers.replaceAll(n -> n * 2);  // Double all values</code></pre>

                                    <!-- Section 7: Iterator vs For-Each -->
                                    <h2>When to Use Iterator vs For-Each</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use Case</th>
                                                <th>Best Choice</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Simple traversal (read-only)</td>
                                                <td>for-each loop</td>
                                            </tr>
                                            <tr>
                                                <td>Need to remove elements</td>
                                                <td>Iterator or removeIf()</td>
                                            </tr>
                                            <tr>
                                                <td>Need current index</td>
                                                <td>Traditional for loop or ListIterator</td>
                                            </tr>
                                            <tr>
                                                <td>Bidirectional traversal</td>
                                                <td>ListIterator</td>
                                            </tr>
                                            <tr>
                                                <td>Add elements during iteration</td>
                                                <td>ListIterator</td>
                                            </tr>
                                            <tr>
                                                <td>Parallel processing</td>
                                                <td>Stream API</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 8: Iterable Interface -->
                                    <h2>The Iterable Interface</h2>
                                    <p>Any class implementing <code>Iterable</code> can be used in for-each loops:</p>
                                    <pre><code class="language-java">public class NumberRange implements Iterable&lt;Integer&gt; {
    private final int start;
    private final int end;

    public NumberRange(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    public Iterator&lt;Integer&gt; iterator() {
        return new Iterator&lt;Integer&gt;() {
            private int current = start;

            @Override
            public boolean hasNext() {
                return current &lt;= end;
            }

            @Override
            public Integer next() {
                return current++;
            }
        };
    }
}

// Now usable in for-each!
for (int num : new NumberRange(1, 5)) {
    System.out.println(num);  // 1, 2, 3, 4, 5
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Iterator</strong> provides safe, uniform collection traversal</li>
                                            <li>Use <code>Iterator.remove()</code> to safely remove during iteration</li>
                                            <li><strong>ListIterator</strong> adds bidirectional traversal and modification</li>
                                            <li>For-each uses Iterator internally but doesn't allow removal</li>
                                            <li>Java 8+: Consider <code>removeIf()</code>, <code>forEach()</code>, and Streams</li>
                                            <li>Implement <code>Iterable</code> to make custom classes for-each compatible</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-treemap.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-generics.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="TreeMap" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Generics →" />
                                                <jsp:param name="currentLessonId" value="collections-iterators" />
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