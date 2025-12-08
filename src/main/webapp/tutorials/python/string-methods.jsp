<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "string-methods");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>String Methods - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python string methods: case conversion, searching, splitting, joining, and validation. Learn 30+ built-in string methods with examples.">
    <meta name="keywords"
        content="python string methods, python split, python join, python replace, python strip, python find, python upper lower">

    <meta property="og:type" content="article">
    <meta property="og:title" content="String Methods - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python string methods with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/string-methods.jsp">
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
        "name": "Python String Methods",
        "description": "Master Python string methods: case conversion, searching, splitting, joining, and validation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["String case methods", "String search methods", "split and join", "String validation", "String formatting"],
        "timeRequired": "PT35M",
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

<body class="tutorial-body no-preview" data-lesson="string-methods">
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
                    <span>String Methods</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">String Methods</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~35 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python strings come with over 40 built-in methods that make text manipulation easy.
                    This lesson covers the most important methods for <strong>case conversion</strong>, <strong>searching</strong>,
                    <strong>splitting/joining</strong>, and <strong>validation</strong>.</p>

                    <div class="info-box">
                        <strong>Remember:</strong> Strings are immutable. All string methods return a <em>new</em> string;
                        the original is unchanged. You must assign the result to a variable to keep it.
                    </div>

                    <!-- Section 1: Case Methods -->
                    <h2>Case Conversion Methods</h2>
                    <p>These methods change the case of characters in a string.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>upper()</code></td><td>All uppercase</td><td><code>"hello".upper()</code> → <code>"HELLO"</code></td></tr>
                            <tr><td><code>lower()</code></td><td>All lowercase</td><td><code>"HELLO".lower()</code> → <code>"hello"</code></td></tr>
                            <tr><td><code>capitalize()</code></td><td>First char uppercase</td><td><code>"hello".capitalize()</code> → <code>"Hello"</code></td></tr>
                            <tr><td><code>title()</code></td><td>Each word capitalized</td><td><code>"hello world".title()</code> → <code>"Hello World"</code></td></tr>
                            <tr><td><code>swapcase()</code></td><td>Swap upper/lower</td><td><code>"Hello".swapcase()</code> → <code>"hELLO"</code></td></tr>
                            <tr><td><code>casefold()</code></td><td>Aggressive lowercase</td><td><code>"Straße".casefold()</code> → <code>"strasse"</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-case-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-case" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Use <code>lower()</code> or <code>casefold()</code> for case-insensitive
                        comparisons. <code>casefold()</code> handles special characters better for international text.
                    </div>

                    <!-- Section 2: Search Methods -->
                    <h2>Search Methods</h2>
                    <p>These methods help you find and count substrings within strings.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Description</th>
                                <th>Not Found</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>find(sub)</code></td><td>Index of first occurrence</td><td>Returns -1</td></tr>
                            <tr><td><code>rfind(sub)</code></td><td>Index of last occurrence</td><td>Returns -1</td></tr>
                            <tr><td><code>index(sub)</code></td><td>Like find()</td><td>Raises ValueError</td></tr>
                            <tr><td><code>count(sub)</code></td><td>Count occurrences</td><td>Returns 0</td></tr>
                            <tr><td><code>startswith(prefix)</code></td><td>Check start</td><td>Returns False</td></tr>
                            <tr><td><code>endswith(suffix)</code></td><td>Check end</td><td>Returns False</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-search-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-search" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>find() vs index():</strong> Use <code>find()</code> when missing substrings are expected
                        (returns -1). Use <code>index()</code> when the substring should always exist (raises error if not).
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Modification Methods -->
                    <h2>Modification Methods</h2>
                    <p>These methods return modified versions of strings - perfect for cleaning, formatting, and transforming text.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-modify-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-modify" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>split() and join() are opposites:</strong>
                        <code>"a,b,c".split(",")</code> → <code>["a", "b", "c"]</code><br>
                        <code>",".join(["a", "b", "c"])</code> → <code>"a,b,c"</code>
                    </div>

                    <!-- Section 4: Validation Methods -->
                    <h2>Validation Methods</h2>
                    <p>These methods check the content of strings and return <code>True</code> or <code>False</code>.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Returns True If</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>isalpha()</code></td><td>All characters are letters (a-z, A-Z)</td></tr>
                            <tr><td><code>isdigit()</code></td><td>All characters are digits (0-9)</td></tr>
                            <tr><td><code>isalnum()</code></td><td>All characters are letters or digits</td></tr>
                            <tr><td><code>isspace()</code></td><td>All characters are whitespace</td></tr>
                            <tr><td><code>isupper()</code></td><td>All cased characters are uppercase</td></tr>
                            <tr><td><code>islower()</code></td><td>All cased characters are lowercase</td></tr>
                            <tr><td><code>istitle()</code></td><td>String is titlecased</td></tr>
                            <tr><td><code>isnumeric()</code></td><td>All characters are numeric (includes ½, ², etc.)</td></tr>
                            <tr><td><code>isdecimal()</code></td><td>All characters are decimal digits</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-check-methods.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-check" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Empty String Note:</strong> Most <code>is*()</code> methods return <code>False</code> for
                        empty strings, since there are no characters to check.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting that methods return new strings</h4>
                        <pre><code class="language-python">name = "john"
name.upper()  # Returns "JOHN" but doesn't save it!
print(name)   # Still "john"

# Correct:
name = name.upper()
print(name)   # "JOHN"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using find() result without checking</h4>
                        <pre><code class="language-python">text = "Hello World"
pos = text.find("Python")  # Returns -1

# Wrong: using -1 as an index
print(text[pos])  # Prints 'd' (last char, not what you want!)

# Correct: check first
if pos != -1:
    print(text[pos])
else:
    print("Not found")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Calling join() on the wrong object</h4>
                        <pre><code class="language-python">words = ["Hello", "World"]

# Wrong:
# words.join(" ")  # AttributeError: list has no join()

# Correct: call join on the separator
result = " ".join(words)  # "Hello World"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using split() without argument vs with space</h4>
                        <pre><code class="language-python">text = "  Hello   World  "

# split() with no arg - splits on any whitespace, removes empty
text.split()      # ['Hello', 'World']

# split(' ') - splits only on single space, keeps empty strings
text.split(' ')   # ['', '', 'Hello', '', '', 'World', '', '']</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: String Methods Practice</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use string methods to process and validate text data.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Clean and transform text using case and strip methods</li>
                            <li>Search for and count substrings</li>
                            <li>Split and join strings</li>
                            <li>Validate string content</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-string-methods.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-methods" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">text = "   Python Programming Language   "
email = "User.Name@Example.COM"
csv_data = "apple,banana,cherry,date"
words_list = ["Hello", "World", "Python"]

# 1. Strip and uppercase
print(text.strip().upper())  # 'PYTHON PROGRAMMING LANGUAGE'

# 2. Lowercase email
print(email.lower())  # 'user.name@example.com'

# 3. Count 'a' in csv_data
print(csv_data.count('a'))  # 4

# 4. Check if ends with .com (case-insensitive)
print(email.lower().endswith('.com'))  # True

# 5. Split csv_data
print(csv_data.split(','))  # ['apple', 'banana', 'cherry', 'date']

# 6. Join words_list
print(' - '.join(words_list))  # 'Hello - World - Python'

# 7. Replace commas with semicolons
print(csv_data.replace(',', ';'))  # 'apple;banana;cherry;date'

# 8. Check if 'Programming' is in text
print('Programming' in text.strip())  # True</code></pre>
                        </details>
                    </div>

                    <!-- Quick Reference -->
                    <h2>Quick Reference</h2>
                    <div class="summary-box">
                        <p><strong>Case Methods:</strong> <code>upper()</code>, <code>lower()</code>, <code>capitalize()</code>, <code>title()</code>, <code>swapcase()</code></p>
                        <p><strong>Search Methods:</strong> <code>find()</code>, <code>rfind()</code>, <code>index()</code>, <code>count()</code>, <code>startswith()</code>, <code>endswith()</code></p>
                        <p><strong>Modify Methods:</strong> <code>replace()</code>, <code>strip()</code>, <code>lstrip()</code>, <code>rstrip()</code>, <code>split()</code>, <code>join()</code></p>
                        <p><strong>Check Methods:</strong> <code>isalpha()</code>, <code>isdigit()</code>, <code>isalnum()</code>, <code>isspace()</code>, <code>isupper()</code>, <code>islower()</code></p>
                        <p><strong>Padding:</strong> <code>center()</code>, <code>ljust()</code>, <code>rjust()</code>, <code>zfill()</code></p>
                    </div>

                    <h2>What's Next?</h2>
                    <p>In the next lesson, we'll explore <strong>booleans</strong> - Python's logical data type for
                    representing True and False values, including truthy/falsy concepts and comparisons.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strings.jsp" />
                    <jsp:param name="prevTitle" value="Strings" />
                    <jsp:param name="nextLink" value="booleans.jsp" />
                    <jsp:param name="nextTitle" value="Booleans" />
                    <jsp:param name="currentLessonId" value="string-methods" />
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
