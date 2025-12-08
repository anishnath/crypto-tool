<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "dictionaries-comprehension");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Dictionary Comprehensions - One-Liner Dict Creation | 8gwifi.org</title>
    <meta name="description"
        content="Master Python dictionary comprehensions - create and transform dictionaries in one elegant line. Learn filtering, transforming keys/values, and practical examples.">
    <meta name="keywords"
        content="python dict comprehension, python dictionary comprehension, python create dict one line, python transform dictionary">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Dictionary Comprehensions - One-Liner Dict Creation">
    <meta property="og:description" content="Master Python dictionary comprehensions for elegant, concise dictionary creation.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/dictionaries-comprehension.jsp">
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
        "name": "Python Dictionary Comprehensions",
        "description": "Master Python dictionary comprehensions for elegant, concise dictionary creation and transformation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Basic dict comprehension syntax", "Filtering with conditions", "Transforming keys and values", "Practical use cases"],
        "timeRequired": "PT20M",
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

<body class="tutorial-body no-preview" data-lesson="dictionaries-comprehension">
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
                    <span>Dict Comprehensions</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Dictionary Comprehensions</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Dictionary comprehensions are the dictionary equivalent of list comprehensions -
                    they let you create and transform dictionaries in a single, elegant line of code. Once you master
                    them, you'll find yourself using them everywhere to write cleaner, more Pythonic code!</p>

                    <!-- Section 1: Basic Syntax -->
                    <h2>Basic Dictionary Comprehension</h2>
                    <p>The syntax is <code>{key_expr: value_expr for item in iterable}</code>. It's like a loop
                    that builds a dictionary one key-value pair at a time.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dictcomp-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>List vs Dict Comprehension:</strong> List comprehensions use <code>[]</code> and
                        produce a list. Dict comprehensions use <code>{}</code> with <code>key: value</code> and
                        produce a dictionary. Set comprehensions also use <code>{}</code> but without the colon.
                    </div>

                    <!-- Section 2: Filtering -->
                    <h2>Filtering with Conditions</h2>
                    <p>Add an <code>if</code> clause to filter which items are included in the resulting dictionary.
                    The condition goes at the end of the comprehension.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dictcomp-filter.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-filter" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Dict comprehensions are perfect for filtering dictionaries.
                        Instead of looping and conditionally adding items, use
                        <code>{k: v for k, v in dict.items() if condition}</code> for clean, readable filtering.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Transformations -->
                    <h2>Transforming Keys and Values</h2>
                    <p>Dict comprehensions shine when you need to transform an existing dictionary - modify keys,
                    values, or both. You can even use if-else expressions for conditional transformations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dictcomp-transform.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-transform" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Duplicate Keys Warning:</strong> If your key expression produces duplicate keys,
                        later values will overwrite earlier ones silently! For example,
                        <code>{x % 2: x for x in range(5)}</code> results in <code>{0: 4, 1: 3}</code> because
                        keys 0 and 1 get overwritten multiple times.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Use Cases</h2>
                    <p>Dictionary comprehensions are incredibly useful for real-world tasks like creating
                    lookup tables, parsing config strings, inverting dictionaries, and grouping data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dictcomp-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting the colon between key and value</h4>
                        <pre><code class="language-python"># Wrong - missing colon creates a set!
result = {x for x in range(5)}  # Set: {0, 1, 2, 3, 4}

# Correct - use key: value
result = {x: x**2 for x in range(5)}  # Dict: {0:0, 1:1, ...}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not handling duplicate keys</h4>
                        <pre><code class="language-python"># Unexpected - later values overwrite earlier
words = ["apple", "ant", "bear"]
first_letter = {word[0]: word for word in words}
print(first_letter)  # {'a': 'ant', 'b': 'bear'} - apple lost!

# If you need all values, use a list
from collections import defaultdict
d = defaultdict(list)
for word in words:
    d[word[0]].append(word)
print(dict(d))  # {'a': ['apple', 'ant'], 'b': ['bear']}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Overcomplicating with too much logic</h4>
                        <pre><code class="language-python"># Hard to read - too complex
result = {k: (v*2 if v > 5 else v*3 if v > 2 else v)
          for k, v in data.items() if k not in exclude}

# Better - break into steps or use regular loop
result = {}
for k, v in data.items():
    if k not in exclude:
        if v > 5:
            result[k] = v * 2
        elif v > 2:
            result[k] = v * 3
        else:
            result[k] = v</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using unhashable expressions as keys</h4>
                        <pre><code class="language-python"># Wrong - lists can't be dictionary keys
d = {[i]: i for i in range(3)}  # TypeError!

# Correct - use tuples instead
d = {(i,): i for i in range(3)}  # Works!</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Word Lengths</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a dictionary mapping words to their lengths.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use dictionary comprehension</li>
                            <li>Key = word, Value = length of word</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-dicts-comprehension.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-dict-comp" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">words = ["apple", "banana", "cherry", "date"]

# Dict comprehension: word -> length
word_lengths = {word: len(word) for word in words}
print(f"Word lengths: {word_lengths}")
# Output: {'apple': 5, 'banana': 6, 'cherry': 6, 'date': 4}</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic:</strong> <code>{key: value for item in iterable}</code></li>
                            <li><strong>Filter:</strong> <code>{k: v for k, v in dict.items() if condition}</code></li>
                            <li><strong>Transform:</strong> <code>{k.upper(): v*2 for k, v in dict.items()}</code></li>
                            <li><strong>From lists:</strong> <code>{k: v for k, v in zip(keys, values)}</code></li>
                            <li><strong>Conditional value:</strong> <code>{k: (v if cond else x) for k, v in items}</code></li>
                            <li><strong>Watch for:</strong> Duplicate keys (later overwrites earlier)</li>
                            <li><strong>Readability:</strong> If too complex, use a regular loop</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's learn about <strong>Nested Data Structures</strong> - how to work with lists of
                    dictionaries, dictionaries of lists, and other complex combinations that you'll encounter
                    constantly in real-world Python programming!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="dictionaries.jsp" />
                    <jsp:param name="prevTitle" value="Dictionaries" />
                    <jsp:param name="nextLink" value="nested-structures.jsp" />
                    <jsp:param name="nextTitle" value="Nested Structures" />
                    <jsp:param name="currentLessonId" value="dictionaries-comprehension" />
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
