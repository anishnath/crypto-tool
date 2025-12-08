<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "strings");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Strings - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python strings: creation, indexing, slicing, escape characters, and formatting. Learn to manipulate text data effectively.">
    <meta name="keywords"
        content="python strings, python string indexing, python slicing, python f-strings, python string formatting, python escape characters">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Strings - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python strings with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/strings.jsp">
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
        "name": "Python Strings",
        "description": "Master Python strings: creation, indexing, slicing, escape characters, and formatting.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["String creation", "String indexing", "String slicing", "Escape characters", "String formatting", "f-strings"],
        "timeRequired": "PT30M",
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

<body class="tutorial-body no-preview" data-lesson="strings">
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
                    <span>Strings</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Strings</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Strings are one of Python's most used data types. They represent text and are
                    <strong>immutable sequences</strong> of characters. This lesson covers creating strings,
                    accessing characters, slicing, and formatting.</p>

                    <!-- Section 1: Creating Strings -->
                    <h2>Creating Strings</h2>
                    <p>Python strings can be created using single quotes, double quotes, or triple quotes for multiline strings.
                    There's no difference between single and double quotes - use whichever is more convenient.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>String Immutability:</strong> Once created, strings cannot be changed. Operations like
                        concatenation or slicing create <em>new</em> strings rather than modifying the original.
                    </div>

                    <!-- Section 2: String Indexing -->
                    <h2>String Indexing</h2>
                    <p>Every character in a string has a position called an <strong>index</strong>. Python uses
                    <strong>zero-based indexing</strong> - the first character is at index 0. You can also use
                    negative indices to count from the end.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-indexing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-indexing" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Negative Indexing Tip:</strong> Use <code>-1</code> to get the last character without
                        knowing the string length. This is one of Python's most beloved features!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: String Slicing -->
                    <h2>String Slicing</h2>
                    <p>Slicing extracts a portion of a string using the syntax <code>string[start:end:step]</code>.
                    The <code>start</code> index is included, but <code>end</code> is excluded.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-slicing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-slicing" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Remember:</strong> The slice <code>[start:end]</code> includes <code>start</code> but
                        excludes <code>end</code>. Think of indices as pointing <em>between</em> characters.
                    </div>

                    <!-- Section 4: Escape Characters -->
                    <h2>Escape Characters</h2>
                    <p>Escape characters let you include special characters in strings. The backslash <code>\</code>
                    is the escape character.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Escape</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>\n</code></td><td>Newline</td><td><code>"Line1\nLine2"</code></td></tr>
                            <tr><td><code>\t</code></td><td>Tab</td><td><code>"Col1\tCol2"</code></td></tr>
                            <tr><td><code>\\</code></td><td>Backslash</td><td><code>"C:\\path"</code></td></tr>
                            <tr><td><code>\'</code></td><td>Single quote</td><td><code>'It\'s'</code></td></tr>
                            <tr><td><code>\"</code></td><td>Double quote</td><td><code>"Say \"Hi\""</code></td></tr>
                            <tr><td><code>\r</code></td><td>Carriage return</td><td><code>"Before\rAfter"</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-escape.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-escape" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Raw Strings:</strong> Prefix a string with <code>r</code> to create a raw string where
                        backslashes are treated literally. Perfect for file paths and regex patterns!
                    </div>

                    <!-- Section 5: String Operations -->
                    <h2>String Operations</h2>
                    <p>Python provides operators for string concatenation, repetition, and membership testing.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-operations.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-operations" />
                    </jsp:include>

                    <!-- Section 6: String Formatting -->
                    <h2>String Formatting</h2>
                    <p>Python offers several ways to format strings. <strong>f-strings</strong> (Python 3.6+) are the
                    most modern and recommended approach.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/strings-formatting.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-formatting" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>f-string Requirement:</strong> f-strings require Python 3.6 or later. For older Python
                        versions, use <code>.format()</code> or the <code>%</code> operator.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Index out of range</h4>
                        <pre><code class="language-python">text = "Hello"
print(text[5])  # IndexError! Valid indices are 0-4
print(text[4])  # Correct - gets 'o'</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Trying to modify strings</h4>
                        <pre><code class="language-python">text = "Hello"
text[0] = "J"  # TypeError! Strings are immutable

# Do this instead:
text = "J" + text[1:]  # Creates new string "Jello"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Concatenating strings with numbers</h4>
                        <pre><code class="language-python">age = 25
# print("Age: " + age)  # TypeError!

# Solutions:
print("Age: " + str(age))   # Convert to string
print(f"Age: {age}")        # Use f-string (recommended)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting case sensitivity</h4>
                        <pre><code class="language-python">text = "Python"
print("python" in text)  # False! Case matters
print("python" in text.lower())  # True</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: String Manipulation</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Practice string indexing, slicing, and operations with the given string.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Extract specific characters using indexing</li>
                            <li>Extract words using slicing</li>
                            <li>Reverse the string</li>
                            <li>Check for substring membership</li>
                            <li>Create a pattern using repetition</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-strings-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-strings" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">text = "Learning Python is Fun!"

# 1. First character
print(text[0])              # 'L'

# 2. Last character
print(text[-1])             # '!'

# 3. Extract "Python"
print(text[9:15])           # 'Python'

# 4. Reverse the string
print(text[::-1])           # '!nuF si nohtyP gninraeL'

# 5. Check if "Python" is in text
print("Python" in text)     # True

# 6. Length of string
print(len(text))            # 23

# 7. Every other character
print(text[::2])            # 'Lann yhn sFn'

# 8. Create pattern
print("=-" * 6 + "=")       # '=-=-=-=-=-=-='</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Creation:</strong> Use single <code>'...'</code>, double <code>"..."</code>, or triple <code>"""..."""</code> quotes</li>
                            <li><strong>Indexing:</strong> Access characters with <code>string[index]</code>, starting at 0</li>
                            <li><strong>Negative indices:</strong> <code>-1</code> is last character, <code>-2</code> is second-to-last</li>
                            <li><strong>Slicing:</strong> <code>string[start:end:step]</code> extracts substrings</li>
                            <li><strong>Escape characters:</strong> <code>\n</code> (newline), <code>\t</code> (tab), <code>\\</code> (backslash)</li>
                            <li><strong>Raw strings:</strong> Prefix with <code>r</code> to disable escape processing</li>
                            <li><strong>f-strings:</strong> Use <code>f"..."</code> for modern, readable formatting</li>
                            <li><strong>Immutable:</strong> Strings cannot be changed - operations create new strings</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>In the next lesson, we'll explore <strong>string methods</strong> - powerful built-in functions
                    for searching, transforming, and manipulating strings.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="numbers.jsp" />
                    <jsp:param name="prevTitle" value="Numbers" />
                    <jsp:param name="nextLink" value="string-methods.jsp" />
                    <jsp:param name="nextTitle" value="String Methods" />
                    <jsp:param name="currentLessonId" value="strings" />
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
