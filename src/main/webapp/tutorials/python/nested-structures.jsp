<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "nested-structures");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Nested Data Structures - Lists of Dicts, Dicts of Lists, JSON | 8gwifi.org</title>
    <meta name="description"
        content="Master Python nested data structures - lists of dictionaries, dicts of lists, hierarchical data. Learn patterns for API responses, configs, and complex data modeling.">
    <meta name="keywords"
        content="python nested list, python nested dictionary, python list of dicts, python dict of lists, python json structure, python complex data">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Nested Data Structures - Lists of Dicts, Dicts of Lists, JSON">
    <meta property="og:description" content="Master Python nested data structures for real-world complex data modeling.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/nested-structures.jsp">
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
        "name": "Python Nested Data Structures",
        "description": "Master Python nested data structures - lists of dictionaries, dicts of lists, hierarchical data for real-world complex data modeling.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["List of dictionaries pattern", "Dictionary of lists pattern", "Dictionary of dictionaries pattern", "JSON-like nested structures", "Deep navigation and data extraction"],
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

<body class="tutorial-body no-preview" data-lesson="nested-structures">
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
                    <span>Nested Structures</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Nested Data Structures</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Real-world data is rarely flat - it's usually nested, hierarchical, and complex.
                    Whether you're working with JSON from APIs, configuration files, or database results, you'll
                    encounter lists inside dictionaries, dictionaries inside lists, and deeper combinations. Mastering
                    nested structures is essential for working with real data in Python!</p>

                    <!-- Section 1: List of Dictionaries -->
                    <h2>List of Dictionaries</h2>
                    <p>The most common pattern you'll encounter, especially when working with JSON APIs. A list of
                    dictionaries represents a collection of records, where each dictionary is one record with
                    named fields. Think of it like rows in a spreadsheet or database table.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/nested-list-of-dicts.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-list-dicts" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why List of Dicts?</strong> This pattern is so common because it maps perfectly to
                        tabular data - each dictionary is a "row" with column names as keys. JSON APIs almost always
                        return data in this format: <code>[{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]</code>.
                    </div>

                    <!-- Section 2: Dictionary of Lists -->
                    <h2>Dictionary of Lists</h2>
                    <p>Use this pattern when you need to group or categorize items. The dictionary keys are
                    category names, and each value is a list of items belonging to that category. Perfect for
                    grouping, tagging, or organizing data by some attribute.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/nested-dict-of-lists.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dict-lists" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Building Dict of Lists:</strong> When aggregating data, remember to initialize empty
                        lists before appending. Use <code>dict.setdefault(key, [])</code> or
                        <code>collections.defaultdict(list)</code> to handle missing keys automatically.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Dictionary of Dictionaries -->
                    <h2>Dictionary of Dictionaries</h2>
                    <p>When you need to create hierarchical or tree-like structures, dictionaries of dictionaries
                    are your tool. This pattern is perfect for configuration files, organizational charts, or
                    any data with named sub-sections.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/nested-dict-of-dicts.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dict-dicts" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Deep Access Safety:</strong> When accessing deeply nested data like
                        <code>data["a"]["b"]["c"]</code>, any missing key raises a <code>KeyError</code>. Chain
                        <code>.get()</code> calls with defaults: <code>data.get("a", {}).get("b", {}).get("c", default)</code>
                        to safely navigate nested structures.
                    </div>

                    <!-- Section 4: JSON-like Complex Structures -->
                    <h2>Working with JSON-like Data</h2>
                    <p>Real API responses combine all these patterns - they have lists of dictionaries, where
                    dictionaries contain more lists and dictionaries. Let's look at navigating, extracting,
                    and transforming this complex nested data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/nested-json-like.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-json-like" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to handle missing keys</h4>
                        <pre><code class="language-python"># Wrong - crashes if "address" doesn't exist
city = user["address"]["city"]  # KeyError!

# Correct - use get() with defaults
city = user.get("address", {}).get("city", "Unknown")

# Or use try/except for complex cases
try:
    city = user["address"]["city"]
except KeyError:
    city = "Unknown"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Modifying while iterating</h4>
                        <pre><code class="language-python"># Wrong - modifying dict while iterating
for key in data:
    if should_remove(key):
        del data[key]  # RuntimeError!

# Correct - iterate over a copy of keys
for key in list(data.keys()):
    if should_remove(key):
        del data[key]

# Or use dict comprehension to filter
data = {k: v for k, v in data.items() if not should_remove(k)}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Creating unintended shared references</h4>
                        <pre><code class="language-python"># Wrong - all inner lists are the same object!
matrix = [[]] * 3
matrix[0].append(1)
print(matrix)  # [[1], [1], [1]] - oops!

# Correct - create separate list objects
matrix = [[] for _ in range(3)]
matrix[0].append(1)
print(matrix)  # [[1], [], []]

# Same issue with nested dicts
data = {"users": {}} * 3  # Wrong thinking - can't multiply dicts
# Use comprehension or explicit creation</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Wrong index type for nested access</h4>
                        <pre><code class="language-python"># Data structure
data = {"users": [{"name": "Alice"}, {"name": "Bob"}]}

# Wrong - mixing up list index and dict key
user = data["users"]["0"]  # KeyError - "0" is string, not int
user = data[0]["name"]  # KeyError - data is dict, not list

# Correct - use proper types
user = data["users"][0]  # List uses integer index
name = data["users"][0]["name"]  # Dict uses string key</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Assuming data structure without checking</h4>
                        <pre><code class="language-python"># API might return different structures
response = get_api_data()

# Wrong - assumes "data" always exists and is a list
for item in response["data"]:  # Might crash!
    process(item)

# Correct - validate structure first
if response.get("status") == "success":
    data = response.get("data", [])
    if isinstance(data, list):
        for item in data:
            process(item)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Process API Response</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Extract and aggregate data from a nested API response.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Find all user emails</li>
                            <li>Calculate total posts across all users</li>
                            <li>Find the user with the most posts</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-nested-structures.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-nested" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">api_response = {
    "data": {
        "users": [
            {"name": "Alice", "email": "alice@test.com", "posts": [1, 2, 3]},
            {"name": "Bob", "email": "bob@test.com", "posts": [4, 5]},
            {"name": "Charlie", "email": "charlie@test.com", "posts": [6, 7, 8, 9]}
        ]
    }
}

# 1. All emails
emails = [user["email"] for user in api_response["data"]["users"]]
print(f"Emails: {emails}")

# 2. Total posts
total = sum(len(user["posts"]) for user in api_response["data"]["users"])
print(f"Total posts: {total}")

# 3. User with most posts
most_posts_user = max(api_response["data"]["users"], key=lambda u: len(u["posts"]))
print(f"Most active: {most_posts_user['name']} ({len(most_posts_user['posts'])} posts)")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>List of dicts:</strong> Collection of records - <code>[{"name": "Alice"}, {"name": "Bob"}]</code></li>
                            <li><strong>Dict of lists:</strong> Grouped/categorized items - <code>{"even": [2,4], "odd": [1,3]}</code></li>
                            <li><strong>Dict of dicts:</strong> Hierarchical/config data - <code>{"db": {"host": "localhost"}}</code></li>
                            <li><strong>Access nested data:</strong> Chain brackets: <code>data["users"][0]["name"]</code></li>
                            <li><strong>Safe access:</strong> Chain <code>.get()</code>: <code>data.get("a", {}).get("b", default)</code></li>
                            <li><strong>Extract data:</strong> Use comprehensions with nested loops</li>
                            <li><strong>Transform:</strong> Build new structures from nested data with comprehensions</li>
                            <li><strong>Always validate:</strong> Check structure before accessing deeply nested paths</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Data Structures module! You now know how to work with
                    all of Python's built-in data structures. Next, we'll dive into <strong>Functions</strong> -
                    how to define reusable blocks of code, pass arguments, return values, and write cleaner,
                    more modular programs!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="dictionaries-comprehension.jsp" />
                    <jsp:param name="prevTitle" value="Dict Comprehensions" />
                    <jsp:param name="nextLink" value="functions.jsp" />
                    <jsp:param name="nextTitle" value="Functions" />
                    <jsp:param name="currentLessonId" value="nested-structures" />
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
