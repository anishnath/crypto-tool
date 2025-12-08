<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "dictionaries");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Dictionaries - Key-Value Data Storage | 8gwifi.org</title>
    <meta name="description"
        content="Master Python dictionaries - key-value data structures. Learn to create, access, modify, and loop through dictionaries with practical examples.">
    <meta name="keywords"
        content="python dictionary, python dict, python key value, python hashmap, python dict methods, python dict loop">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Dictionaries - Key-Value Data Storage">
    <meta property="og:description" content="Master Python dictionaries for efficient key-value data storage and retrieval.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/dictionaries.jsp">
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
        "name": "Python Dictionaries",
        "description": "Master Python dictionaries for efficient key-value data storage and retrieval.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Creating dictionaries", "Accessing values", "Modifying dictionaries", "Looping through dictionaries", "Dictionary methods"],
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

<body class="tutorial-body no-preview" data-lesson="dictionaries">
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
                    <span>Dictionaries</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Dictionaries</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Dictionaries are Python's built-in mapping type - they store data as key-value pairs.
                    Think of them like a real dictionary where you look up a word (key) to find its definition (value).
                    They're incredibly fast for lookups and one of Python's most useful data structures!</p>

                    <!-- Section 1: Creating Dictionaries -->
                    <h2>Creating Dictionaries</h2>
                    <p>Dictionaries are created with curly braces <code>{}</code> containing <code>key: value</code> pairs,
                    or with the <code>dict()</code> constructor. Keys must be immutable (hashable), but values can be anything.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dicts-creating.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-creating" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Dictionary Properties:</strong> Since Python 3.7, dictionaries maintain insertion order.
                        Keys must be unique and immutable (strings, numbers, tuples). Values can be any type including
                        lists, other dictionaries, or even functions!
                    </div>

                    <!-- Section 2: Accessing Values -->
                    <h2>Accessing Dictionary Values</h2>
                    <p>Access values using square brackets <code>dict[key]</code> or the safer <code>get()</code> method.
                    Use <code>in</code> to check if a key exists, and <code>keys()</code>, <code>values()</code>,
                    <code>items()</code> to get different views.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dicts-accessing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-accessing" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Always use <code>get()</code> when the key might not exist.
                        <code>dict.get('key', default)</code> returns the default value instead of raising a KeyError.
                        This makes your code more robust and avoids try/except blocks.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Modifying Dictionaries -->
                    <h2>Modifying Dictionaries</h2>
                    <p>Dictionaries are mutable - you can add, update, and remove key-value pairs. Use assignment,
                    <code>update()</code>, <code>pop()</code>, and <code>del</code> to modify your dictionaries.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dicts-modifying.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-modifying" />
                    </jsp:include>

                    <!-- Section 4: Looping -->
                    <h2>Looping Through Dictionaries</h2>
                    <p>Iterate over keys, values, or both using <code>keys()</code>, <code>values()</code>, and
                    <code>items()</code>. The default iteration is over keys.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dicts-looping.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-looping" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Don't Modify While Iterating!</strong> Never add or remove keys while looping through
                        a dictionary - it will raise a RuntimeError. Instead, iterate over a copy
                        (<code>dict.copy()</code>) or build a new dictionary.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. KeyError when accessing missing key</h4>
                        <pre><code class="language-python"># Wrong - raises KeyError
person = {"name": "Alice"}
print(person["age"])  # KeyError: 'age'

# Correct - use get() with default
print(person.get("age", "Unknown"))  # "Unknown"

# Or check first
if "age" in person:
    print(person["age"])</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using mutable objects as keys</h4>
                        <pre><code class="language-python"># Wrong - lists are mutable/unhashable
my_dict = {[1, 2]: "value"}  # TypeError!

# Correct - use tuples instead
my_dict = {(1, 2): "value"}  # Works!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Modifying dict while iterating</h4>
                        <pre><code class="language-python"># Wrong - modifying size during iteration
for key in my_dict:
    if some_condition:
        del my_dict[key]  # RuntimeError!

# Correct - iterate over copy or use comprehension
for key in list(my_dict.keys()):  # Creates copy of keys
    if some_condition:
        del my_dict[key]

# Or build new dict
my_dict = {k: v for k, v in my_dict.items() if not some_condition}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Overwriting when you meant to update</h4>
                        <pre><code class="language-python"># Wrong - completely replaces the dict
config = {"debug": True, "verbose": False}
config = {"timeout": 30}  # Lost debug and verbose!

# Correct - update existing dict
config.update({"timeout": 30})
# Or
config["timeout"] = 30</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Student Profile</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create and modify a dictionary representing a student.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a dictionary with name, age, and grade</li>
                            <li>Update the grade to "A+"</li>
                            <li>Add a new key "subject" with value "Computer Science"</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-dicts-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-dicts" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Create student dictionary
student = {
    "name": "John",
    "age": 20,
    "grade": "B"
}
print(f"Original: {student}")

# Update grade to A+
student["grade"] = "A+"
print(f"After grade update: {student}")

# Add subject
student["subject"] = "Computer Science"
print(f"Final: {student}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Creating:</strong> <code>{"key": value}</code> or <code>dict(key=value)</code></li>
                            <li><strong>Accessing:</strong> <code>dict[key]</code> or <code>dict.get(key, default)</code></li>
                            <li><strong>Adding/Updating:</strong> <code>dict[key] = value</code> or <code>dict.update()</code></li>
                            <li><strong>Removing:</strong> <code>del dict[key]</code>, <code>dict.pop(key)</code>, <code>dict.clear()</code></li>
                            <li><strong>Checking:</strong> <code>key in dict</code></li>
                            <li><strong>Looping:</strong> <code>.keys()</code>, <code>.values()</code>, <code>.items()</code></li>
                            <li><strong>Properties:</strong> Ordered (3.7+), mutable, unique keys, O(1) lookup</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's learn <strong>Dictionary Comprehensions</strong> - the elegant, one-liner way to
                    create and transform dictionaries, similar to list comprehensions!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="sets.jsp" />
                    <jsp:param name="prevTitle" value="Sets" />
                    <jsp:param name="nextLink" value="dictionaries-comprehension.jsp" />
                    <jsp:param name="nextTitle" value="Dict Comprehensions" />
                    <jsp:param name="currentLessonId" value="dictionaries" />
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
