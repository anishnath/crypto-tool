<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "sets");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Sets - Unique Collections & Set Operations | 8gwifi.org</title>
    <meta name="description"
        content="Master Python sets - unordered collections with no duplicates. Learn set operations (union, intersection, difference), methods, and practical use cases.">
    <meta name="keywords"
        content="python sets, python set operations, python union intersection, python remove duplicates, python set methods">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Sets - Unique Collections & Set Operations">
    <meta property="og:description" content="Master Python sets for unique collections and mathematical set operations.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/sets.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "name": "Python Sets",
        "description": "Master Python sets for unique collections and mathematical set operations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Creating sets", "Set methods", "Union and intersection", "Difference and symmetric difference", "Practical use cases"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="sets">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Sets</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Sets</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Sets are Python's unordered collections with no duplicate elements. They're perfect
                    for removing duplicates, testing membership efficiently, and performing mathematical set operations
                    like union, intersection, and difference. Think of them as mathematical sets from school!</p>

                    <!-- Section 1: Creating Sets -->
                    <h2>Creating Sets</h2>
                    <p>Sets are created with curly braces <code>{}</code> or the <code>set()</code> constructor.
                    Duplicates are automatically removed, and only immutable (hashable) items can be stored.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/sets-creating.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-creating" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Empty Set Gotcha:</strong> To create an empty set, you MUST use <code>set()</code>,
                        not <code>{}</code>. Empty curly braces <code>{}</code> create an empty dictionary, not a set!
                        This is one of Python's most common gotchas.
                    </div>

                    <!-- Section 2: Set Methods -->
                    <h2>Adding and Removing Elements</h2>
                    <p>Sets are mutable - you can add and remove elements. Use <code>add()</code> for single items,
                    <code>update()</code> for multiple items, and <code>remove()</code> or <code>discard()</code> to delete.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/sets-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-methods" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>discard()</code> instead of <code>remove()</code> when
                        you're not sure if an element exists. <code>remove()</code> raises a KeyError for missing
                        elements, while <code>discard()</code> silently does nothing.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Set Operations -->
                    <h2>Set Operations</h2>
                    <p>Sets support mathematical operations: union (|), intersection (&), difference (-), and
                    symmetric difference (^). These are powerful tools for comparing and combining data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/sets-operations.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-operations" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Operators vs Methods:</strong> Set operations can use operators (<code>|</code>,
                        <code>&</code>, <code>-</code>, <code>^</code>) or methods (<code>.union()</code>,
                        <code>.intersection()</code>, etc.). Methods accept any iterable as argument, while
                        operators require both sides to be sets.
                    </div>

                    <!-- Section 4: Practical Uses -->
                    <h2>Practical Use Cases</h2>
                    <p>Sets excel at removing duplicates, finding common elements, fast membership testing,
                    and comparing datasets. Let's see some real-world examples.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/sets-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using {} for empty set</h4>
                        <pre><code class="language-python"># Wrong - creates empty dict, not set!
empty = {}
print(type(empty))  # <class 'dict'>

# Correct
empty_set = set()
print(type(empty_set))  # <class 'set'></code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Trying to add mutable items</h4>
                        <pre><code class="language-python"># Wrong - lists are mutable/unhashable
my_set = {[1, 2, 3]}  # TypeError!

# Correct - use tuples instead
my_set = {(1, 2, 3)}  # Works!
print(my_set)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Expecting order in sets</h4>
                        <pre><code class="language-python"># Wrong assumption
my_set = {3, 1, 2}
first = list(my_set)[0]  # NOT guaranteed to be 3!

# Sets are unordered - don't rely on element order
# Use sorted() if you need order
ordered = sorted(my_set)
print(ordered)  # [1, 2, 3]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using remove() without checking</h4>
                        <pre><code class="language-python"># Wrong - raises KeyError if not found
my_set = {1, 2, 3}
my_set.remove(5)  # KeyError: 5

# Correct - use discard() or check first
my_set.discard(5)  # No error
# OR
if 5 in my_set:
    my_set.remove(5)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Guest List Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Manage a party guest list using sets.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Add "David" to the guest list</li>
                            <li>Try adding "Alice" again (observe what happens)</li>
                            <li>Remove "Bob" from the list</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-sets-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-sets" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">guests = {"Alice", "Bob", "Charlie"}

# Add David
guests.add("David")
print(f"After adding David: {guests}")

# Try adding Alice again - no duplicate!
guests.add("Alice")
print(f"After adding Alice again: {guests}")

# Remove Bob
guests.remove("Bob")
print(f"After removing Bob: {guests}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Creating:</strong> Use <code>{}</code> with items, or <code>set()</code> for empty</li>
                            <li><strong>Properties:</strong> Unordered, no duplicates, only hashable items</li>
                            <li><strong>Adding:</strong> <code>add()</code> single, <code>update()</code> multiple</li>
                            <li><strong>Removing:</strong> <code>remove()</code> (error if missing), <code>discard()</code> (no error)</li>
                            <li><strong>Union:</strong> <code>A | B</code> or <code>A.union(B)</code></li>
                            <li><strong>Intersection:</strong> <code>A & B</code> or <code>A.intersection(B)</code></li>
                            <li><strong>Difference:</strong> <code>A - B</code> or <code>A.difference(B)</code></li>
                            <li><strong>Best for:</strong> Removing duplicates, fast membership testing, comparing datasets</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Dictionaries</strong> - Python's powerful key-value data structure.
                    Dictionaries let you store and retrieve data using descriptive keys instead of numeric indices!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="tuples.jsp" />
                    <jsp:param name="prevTitle" value="Tuples" />
                    <jsp:param name="nextLink" value="dictionaries.jsp" />
                    <jsp:param name="nextTitle" value="Dictionaries" />
                    <jsp:param name="currentLessonId" value="sets" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
