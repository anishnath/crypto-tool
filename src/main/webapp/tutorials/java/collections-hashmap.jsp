<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-hashmap" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java HashMap - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java HashMap. Store data in key-value pairs and perform fast lookups based on keys.">
            <meta name="keywords"
                content="java hashmap, map interface, key value pair, dictionary in java, hashmap put get">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java HashMap - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="The definitive guide to Java HashMaps. Learn to map keys to values efficiently.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-hashmap.jsp">
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
    "name": "Java HashMap",
    "description": "Guide to using HashMap in Java for key-value storage.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["HashMap Basics", "Key-Value Pairs", "Put and Get Methods"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-hashmap">
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
                                    <span>HashMap</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java HashMap</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <code>HashMap</code> is Java's most used key-value data structure,
                                        providing O(1) average time for get and put operations. It's similar to Python's
                                        Dictionary or JavaScript's Object/Map.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-hashmap-structure.svg"
                                            alt="Java HashMap Internal Structure Diagram"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 1: How HashMap Works -->
                                    <h2>How HashMap Works</h2>
                                    <p>HashMap uses a hash table with bucket-based storage:</p>
                                    <ol>
                                        <li>Key's <code>hashCode()</code> determines which bucket</li>
                                        <li>Entry (key-value pair) is stored in that bucket</li>
                                        <li>Collisions are handled with linked lists (or trees in Java 8+)</li>
                                        <li>On retrieval, <code>equals()</code> finds the exact key</li>
                                    </ol>

                                    <div class="info-box">
                                        <strong>Java 8+ Optimization:</strong> When a bucket has more than 8 entries,
                                        the linked list converts to a red-black tree for O(log n) lookup instead of O(n).
                                    </div>

                                    <!-- Section 2: Key Characteristics -->
                                    <h2>Key Characteristics</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>HashMap</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Key uniqueness</strong></td>
                                                <td>Keys must be unique (duplicates overwrite)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Value uniqueness</strong></td>
                                                <td>Values can be duplicated</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Null keys</strong></td>
                                                <td>One null key allowed</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Null values</strong></td>
                                                <td>Multiple null values allowed</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Order</strong></td>
                                                <td>No guaranteed order</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Thread-safe</strong></td>
                                                <td>No (use ConcurrentHashMap)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 3: Creating HashMap -->
                                    <h2>Creating a HashMap</h2>
                                    <pre><code class="language-java">import java.util.HashMap;
import java.util.Map;

// Standard way
Map&lt;String, Integer&gt; ages = new HashMap&lt;&gt;();

// With initial capacity
Map&lt;String, String&gt; bigMap = new HashMap&lt;&gt;(1000);

// With initial capacity and load factor
Map&lt;String, String&gt; map = new HashMap&lt;&gt;(16, 0.75f);

// Java 9+ factory method (immutable)
Map&lt;String, Integer&gt; immutable = Map.of(
    "Alice", 30,
    "Bob", 25
);</code></pre>

                                    <!-- Section 4: Essential Operations -->
                                    <h2>Essential Operations</h2>
                                    <pre><code class="language-java">Map&lt;String, Integer&gt; scores = new HashMap&lt;&gt;();

// Adding entries
scores.put("Alice", 95);
scores.put("Bob", 87);
scores.put("Alice", 98);  // Overwrites! Returns old value (95)

// Getting values
Integer aliceScore = scores.get("Alice");     // 98
Integer unknown = scores.get("Unknown");      // null

// Safe get with default
Integer score = scores.getOrDefault("Charlie", 0); // 0

// Check existence
boolean hasAlice = scores.containsKey("Alice");    // true
boolean has95 = scores.containsValue(95);          // false (was overwritten)

// Remove
Integer removed = scores.remove("Bob");  // Returns 87

// Size
int size = scores.size();</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/HashMapExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-hashmap" />
                                    </jsp:include>

                                    <!-- Section 5: Iterating -->
                                    <h2>Iterating Through HashMap</h2>
                                    <pre><code class="language-java">Map&lt;String, Integer&gt; scores = new HashMap&lt;&gt;();
scores.put("Alice", 95);
scores.put("Bob", 87);
scores.put("Charlie", 92);

// 1. Iterate over entries (most common)
for (Map.Entry&lt;String, Integer&gt; entry : scores.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}

// 2. Iterate over keys only
for (String name : scores.keySet()) {
    System.out.println(name);
}

// 3. Iterate over values only
for (Integer score : scores.values()) {
    System.out.println(score);
}

// 4. Java 8+ forEach with lambda
scores.forEach((name, score) ->
    System.out.println(name + " scored " + score)
);</code></pre>

                                    <!-- Section 6: Advanced Operations -->
                                    <h2>Advanced Operations (Java 8+)</h2>
                                    <pre><code class="language-java">Map&lt;String, Integer&gt; wordCount = new HashMap&lt;&gt;();

// Compute if absent (great for counters/caches)
wordCount.computeIfAbsent("hello", k -> 0);

// Merge (perfect for counting)
String[] words = {"apple", "banana", "apple", "cherry", "apple"};
for (String word : words) {
    wordCount.merge(word, 1, Integer::sum);
}
// {apple=3, banana=1, cherry=1}

// putIfAbsent (only add if key missing)
wordCount.putIfAbsent("date", 1);

// Replace (only if key exists)
wordCount.replace("apple", 5);

// Conditional replace
wordCount.replace("apple", 5, 10);  // Only if value is 5

// Remove only if value matches
wordCount.remove("banana", 1);  // Removes banana

// Compute (update based on current value)
wordCount.compute("apple", (k, v) -> v == null ? 1 : v + 1);</code></pre>

                                    <!-- Section 7: Common Patterns -->
                                    <h2>Common Patterns</h2>
                                    <pre><code class="language-java">// Pattern 1: Counting frequency
Map&lt;Character, Integer&gt; charCount = new HashMap&lt;&gt;();
for (char c : "hello".toCharArray()) {
    charCount.merge(c, 1, Integer::sum);
}

// Pattern 2: Grouping
Map&lt;String, List&lt;String&gt;&gt; byLength = new HashMap&lt;&gt;();
for (String word : Arrays.asList("cat", "dog", "elephant", "ant")) {
    byLength.computeIfAbsent(
        word.length() > 3 ? "long" : "short",
        k -> new ArrayList&lt;&gt;()
    ).add(word);
}

// Pattern 3: Caching/Memoization
Map&lt;Integer, Long&gt; cache = new HashMap&lt;&gt;();
long fibonacci(int n) {
    return cache.computeIfAbsent(n, k ->
        k <= 1 ? k : fibonacci(k-1) + fibonacci(k-2)
    );
}</code></pre>

                                    <!-- Section 8: Map Comparison -->
                                    <h2>When to Use Which Map?</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Map Type</th>
                                                <th>Key Order</th>
                                                <th>Performance</th>
                                                <th>Use When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>HashMap</code></td>
                                                <td>None</td>
                                                <td>O(1)</td>
                                                <td>Best general-purpose choice</td>
                                            </tr>
                                            <tr>
                                                <td><code>LinkedHashMap</code></td>
                                                <td>Insertion order</td>
                                                <td>O(1)</td>
                                                <td>Need predictable iteration</td>
                                            </tr>
                                            <tr>
                                                <td><code>TreeMap</code></td>
                                                <td>Sorted by key</td>
                                                <td>O(log n)</td>
                                                <td>Need sorted keys</td>
                                            </tr>
                                            <tr>
                                                <td><code>ConcurrentHashMap</code></td>
                                                <td>None</td>
                                                <td>O(1)</td>
                                                <td>Multi-threaded access</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>HashMap</strong> provides O(1) performance for get/put operations</li>
                                            <li>Keys must be unique; values can duplicate</li>
                                            <li>Use <code>entrySet()</code> for efficient iteration</li>
                                            <li>Java 8+ methods: <code>merge()</code>, <code>computeIfAbsent()</code>, <code>forEach()</code></li>
                                            <li>Not thread-safe - use ConcurrentHashMap for concurrent access</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-treeset.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-treemap.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="TreeSet" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="TreeMap →" />
                                                <jsp:param name="currentLessonId" value="collections-hashmap" />
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