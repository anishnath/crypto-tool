<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-treemap" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java TreeMap - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java TreeMap. Store key-value pairs in a sorted order based on keys.">
            <meta name="keywords" content="java treemap, sorted map, java collections treemap, sorted key value pair">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java TreeMap - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Organize your key-value data with automatic sorting using Java TreeMap.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-treemap.jsp">
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
    "name": "Java TreeMap",
    "description": "Guide to using TreeMap in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["TreeMap Basics", "Sorted Map Interface", "Navigating Maps"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-treemap">
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
                                    <span>TreeMap</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java TreeMap</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <code>TreeMap</code> is a <code>NavigableMap</code> implementation
                                        that stores key-value pairs sorted by keys using a Red-Black tree. It provides
                                        O(log n) time for get, put, and remove operations.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-treemap-structure.svg"
                                            alt="Java TreeMap Red-Black Tree Structure with Key-Value Pairs"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 1: Key Characteristics -->
                                    <h2>Key Characteristics</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>HashMap</th>
                                                <th>TreeMap</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Key order</strong></td>
                                                <td>No order</td>
                                                <td>Sorted by key</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Performance</strong></td>
                                                <td>O(1) average</td>
                                                <td>O(log n)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Null keys</strong></td>
                                                <td>One null allowed</td>
                                                <td>No nulls allowed</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Underlying structure</strong></td>
                                                <td>Hash table</td>
                                                <td>Red-Black tree</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Best for</strong></td>
                                                <td>Fast lookup by key</td>
                                                <td>Sorted keys, range queries</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 2: Creating TreeMap -->
                                    <h2>Creating a TreeMap</h2>
                                    <pre><code class="language-java">import java.util.TreeMap;
import java.util.Map;
import java.util.Comparator;

// Natural ordering (keys must implement Comparable)
TreeMap&lt;String, Integer&gt; scores = new TreeMap&lt;&gt;();

// Custom comparator (reverse order)
TreeMap&lt;String, Integer&gt; descending = new TreeMap&lt;&gt;(
    Comparator.reverseOrder()
);

// Case-insensitive keys
TreeMap&lt;String, String&gt; caseInsensitive = new TreeMap&lt;&gt;(
    String.CASE_INSENSITIVE_ORDER
);

// From existing map
Map&lt;String, Integer&gt; hashMap = new HashMap&lt;&gt;();
hashMap.put("banana", 2);
hashMap.put("apple", 1);
TreeMap&lt;String, Integer&gt; sorted = new TreeMap&lt;&gt;(hashMap);
// Keys sorted: apple, banana</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/collections-treemap.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-treemap" />
                                    </jsp:include>

                                    <!-- Section 3: Navigation Methods -->
                                    <h2>NavigableMap Methods</h2>
                                    <p>TreeMap provides powerful navigation for finding entries by key:</p>
                                    <pre><code class="language-java">TreeMap&lt;Integer, String&gt; map = new TreeMap&lt;&gt;();
map.put(10, "Ten");
map.put(20, "Twenty");
map.put(30, "Thirty");
map.put(40, "Forty");
map.put(50, "Fifty");

// First and last
Map.Entry&lt;Integer, String&gt; first = map.firstEntry(); // 10=Ten
Map.Entry&lt;Integer, String&gt; last = map.lastEntry();   // 50=Fifty
Integer firstKey = map.firstKey();  // 10
Integer lastKey = map.lastKey();    // 50

// Floor/Ceiling entries (closest)
Map.Entry&lt;Integer, String&gt; floor = map.floorEntry(25);   // 20=Twenty (&lt;=25)
Map.Entry&lt;Integer, String&gt; ceiling = map.ceilingEntry(25); // 30=Thirty (&gt;=25)
Map.Entry&lt;Integer, String&gt; lower = map.lowerEntry(30);   // 20=Twenty (&lt;30)
Map.Entry&lt;Integer, String&gt; higher = map.higherEntry(30); // 40=Forty (&gt;30)

// Polling (retrieve and remove)
Map.Entry&lt;Integer, String&gt; pollFirst = map.pollFirstEntry(); // Removes 10
Map.Entry&lt;Integer, String&gt; pollLast = map.pollLastEntry();   // Removes 50

// Submaps (views, backed by original)
SortedMap&lt;Integer, String&gt; head = map.headMap(30);      // {20=Twenty}
SortedMap&lt;Integer, String&gt; tail = map.tailMap(30);      // {30=Thirty, 40=Forty}
SortedMap&lt;Integer, String&gt; sub = map.subMap(20, 40);    // {20=Twenty, 30=Thirty}

// Inclusive bounds
NavigableMap&lt;Integer, String&gt; inc = map.subMap(20, true, 40, true);

// Descending view
NavigableMap&lt;Integer, String&gt; desc = map.descendingMap();</code></pre>

                                    <!-- Section 4: Common Use Cases -->
                                    <h2>Common Use Cases</h2>
                                    <pre><code class="language-java">// 1. Time-based data (sorted by timestamp)
TreeMap&lt;LocalDateTime, String&gt; events = new TreeMap&lt;&gt;();
events.put(LocalDateTime.now(), "Event A");
events.put(LocalDateTime.now().plusHours(1), "Event B");
// Get events after a certain time
SortedMap&lt;LocalDateTime, String&gt; future = events.tailMap(LocalDateTime.now());

// 2. Price lookup (find nearest price tier)
TreeMap&lt;Integer, Double&gt; priceTiers = new TreeMap&lt;&gt;();
priceTiers.put(100, 0.10);   // 100+ units: $0.10 each
priceTiers.put(500, 0.08);   // 500+ units: $0.08 each
priceTiers.put(1000, 0.05);  // 1000+ units: $0.05 each

int quantity = 750;
Double rate = priceTiers.floorEntry(quantity).getValue(); // 0.08

// 3. Alphabetically sorted dictionary
TreeMap&lt;String, String&gt; dictionary = new TreeMap&lt;&gt;();
dictionary.put("apple", "a fruit");
dictionary.put("car", "a vehicle");
dictionary.put("book", "something to read");
// Iterates: apple, book, car

// 4. Score rankings with navigation
TreeMap&lt;Integer, List&lt;String&gt;&gt; rankings = new TreeMap&lt;&gt;(
    Comparator.reverseOrder()  // Highest first
);
// Get top 3 scores
rankings.entrySet().stream().limit(3).forEach(System.out::println);</code></pre>

                                    <!-- Section 5: Thread Safety -->
                                    <h2>Thread Safety</h2>
                                    <pre><code class="language-java">// TreeMap is NOT thread-safe. For concurrent access:

// Option 1: Synchronized wrapper
Map&lt;String, Integer&gt; syncMap = Collections.synchronizedSortedMap(
    new TreeMap&lt;&gt;()
);

// Option 2: ConcurrentSkipListMap (better performance)
ConcurrentNavigableMap&lt;String, Integer&gt; concurrentMap =
    new ConcurrentSkipListMap&lt;&gt;();</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>TreeMap</strong> keeps keys sorted using Red-Black tree</li>
                                            <li>O(log n) for get, put, remove operations</li>
                                            <li>Keys must be Comparable or use a Comparator</li>
                                            <li>Navigation: firstKey(), lastKey(), floorEntry(), ceilingEntry()</li>
                                            <li>Range views: headMap(), tailMap(), subMap()</li>
                                            <li>No null keys allowed (null values are OK)</li>
                                            <li>Use ConcurrentSkipListMap for thread-safe sorted maps</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-hashmap.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-iterators.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="HashMap" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Iterators →" />
                                                <jsp:param name="currentLessonId" value="collections-treemap" />
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