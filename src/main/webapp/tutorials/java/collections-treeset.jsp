<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-treeset" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java TreeSet - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java TreeSet. Store unique elements in a sorted order using tree-based data structures.">
            <meta name="keywords"
                content="java treeset, sorted set, unique sorted elements, java collections treeset, set ordering">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java TreeSet - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Combine uniqueness with sorting using the Java TreeSet.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-treeset.jsp">
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
    "name": "Java TreeSet",
    "description": "Guide to using TreeSet in Java for sorted unique collections.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["TreeSet Basics", "Sorted Set Interface", "Natural Ordering"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-treeset">
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
                                    <span>TreeSet</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java TreeSet</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <code>TreeSet</code> is a <code>NavigableSet</code> implementation
                                        that keeps elements <strong>sorted</strong> using a Red-Black tree. All operations
                                        are O(log n), making it ideal when you need sorted unique elements.</p>

                                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-treeset-structure.svg"
                                            alt="Java TreeSet Red-Black Tree Structure"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <!-- Section 1: How TreeSet Works -->
                                    <h2>How TreeSet Works</h2>
                                    <p>TreeSet uses a self-balancing Red-Black tree internally:</p>
                                    <ul>
                                        <li>Elements are sorted using natural ordering or a custom Comparator</li>
                                        <li>The tree stays balanced, ensuring O(log n) operations</li>
                                        <li>In-order traversal gives sorted output</li>
                                    </ul>

                                    <div class="info-box">
                                        <strong>Important:</strong> Elements must implement <code>Comparable</code> OR
                                        you must provide a <code>Comparator</code> to the TreeSet constructor.
                                    </div>

                                    <!-- Section 2: Key Characteristics -->
                                    <h2>Key Characteristics</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>HashSet</th>
                                                <th>TreeSet</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Order</strong></td>
                                                <td>No order</td>
                                                <td>Sorted (natural or custom)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Performance</strong></td>
                                                <td>O(1) average</td>
                                                <td>O(log n)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Null elements</strong></td>
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
                                                <td>Fast lookup</td>
                                                <td>Sorted data, range queries</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 3: Creating TreeSet -->
                                    <h2>Creating a TreeSet</h2>
                                    <pre><code class="language-java">import java.util.TreeSet;
import java.util.Set;
import java.util.Comparator;

// Natural ordering (elements must implement Comparable)
TreeSet&lt;Integer&gt; numbers = new TreeSet&lt;&gt;();
TreeSet&lt;String&gt; names = new TreeSet&lt;&gt;();

// Custom comparator (reverse order)
TreeSet&lt;Integer&gt; descending = new TreeSet&lt;&gt;(Comparator.reverseOrder());

// Custom comparator for objects
TreeSet&lt;String&gt; byLength = new TreeSet&lt;&gt;(
    Comparator.comparingInt(String::length)
);

// From existing collection (sorts automatically)
List&lt;Integer&gt; list = Arrays.asList(5, 2, 8, 1, 9);
TreeSet&lt;Integer&gt; sorted = new TreeSet&lt;&gt;(list); // {1, 2, 5, 8, 9}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/TreeSetExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-treeset" />
                                    </jsp:include>

                                    <!-- Section 4: Navigation Methods -->
                                    <h2>NavigableSet Methods</h2>
                                    <p>TreeSet implements <code>NavigableSet</code>, providing powerful navigation operations:</p>
                                    <pre><code class="language-java">TreeSet&lt;Integer&gt; set = new TreeSet&lt;&gt;();
set.addAll(Arrays.asList(10, 20, 30, 40, 50, 60, 70, 80, 90, 100));

// Boundary elements
Integer first = set.first();   // 10 (smallest)
Integer last = set.last();     // 100 (largest)

// Floor/Ceiling (closest elements)
Integer floor = set.floor(35);     // 30 (<=35)
Integer ceiling = set.ceiling(35); // 40 (>=35)
Integer lower = set.lower(40);     // 30 (&lt;40)
Integer higher = set.higher(40);   // 50 (&gt;40)

// Polling (retrieve and remove)
Integer pollFirst = set.pollFirst(); // 10 (removes it)
Integer pollLast = set.pollLast();   // 100 (removes it)

// Subsets (views, not copies!)
SortedSet&lt;Integer&gt; head = set.headSet(50);      // [20, 30, 40]
SortedSet&lt;Integer&gt; tail = set.tailSet(50);      // [50, 60, 70, 80, 90]
SortedSet&lt;Integer&gt; sub = set.subSet(30, 70);    // [30, 40, 50, 60]

// Inclusive bounds (NavigableSet)
NavigableSet&lt;Integer&gt; inclusive = set.subSet(30, true, 70, true); // [30...70]

// Descending view
NavigableSet&lt;Integer&gt; desc = set.descendingSet(); // [90, 80, 70...]</code></pre>

                                    <!-- Section 5: Custom Objects -->
                                    <h2>Using Custom Objects</h2>
                                    <pre><code class="language-java">// Option 1: Implement Comparable
class Student implements Comparable&lt;Student&gt; {
    String name;
    int grade;

    @Override
    public int compareTo(Student other) {
        return Integer.compare(this.grade, other.grade);
    }
}
TreeSet&lt;Student&gt; byGrade = new TreeSet&lt;&gt;();

// Option 2: Use Comparator
class Employee {
    String name;
    double salary;
}
TreeSet&lt;Employee&gt; bySalary = new TreeSet&lt;&gt;(
    Comparator.comparingDouble(e -> e.salary)
);

// Multi-level sorting
TreeSet&lt;Employee&gt; sorted = new TreeSet&lt;&gt;(
    Comparator.comparing((Employee e) -> e.name)
              .thenComparingDouble(e -> e.salary)
);</code></pre>

                                    <!-- Section 6: Common Use Cases -->
                                    <h2>Common Use Cases</h2>
                                    <pre><code class="language-java">// 1. Finding k-th smallest/largest element
TreeSet&lt;Integer&gt; nums = new TreeSet&lt;&gt;(Arrays.asList(5, 2, 8, 1, 9, 3));
// Get 3rd smallest
Iterator&lt;Integer&gt; it = nums.iterator();
for (int i = 0; i &lt; 2; i++) it.next();
int thirdSmallest = it.next(); // 3

// 2. Range queries
TreeSet&lt;Integer&gt; scores = new TreeSet&lt;&gt;();
// ... add scores
SortedSet&lt;Integer&gt; passing = scores.tailSet(60); // All >= 60

// 3. Finding closest values
TreeSet&lt;Integer&gt; prices = new TreeSet&lt;&gt;();
// Find price closest to budget
int budget = 150;
Integer lower = prices.floor(budget);
Integer higher = prices.ceiling(budget);

// 4. Maintaining sorted leaderboard
TreeSet&lt;Player&gt; leaderboard = new TreeSet&lt;&gt;(
    Comparator.comparingInt(Player::getScore).reversed()
);</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>TreeSet</strong> keeps elements sorted using Red-Black tree</li>
                                            <li>O(log n) for add, remove, contains operations</li>
                                            <li>Elements must be Comparable or use a Comparator</li>
                                            <li>Provides navigation: first(), last(), floor(), ceiling()</li>
                                            <li>Range views: headSet(), tailSet(), subSet()</li>
                                            <li>No null elements allowed</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-hashset.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-hashmap.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="HashSet" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="HashMap →" />
                                                <jsp:param name="currentLessonId" value="collections-treeset" />
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