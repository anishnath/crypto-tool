<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "none-type" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <title>None Type - Python Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Python's None type: the null value representing absence. Learn when to use None, how to check for it, and common patterns.">
            <meta name="keywords"
                content="python None, python null, python NoneType, python is None, python default arguments, python optional values">

            <meta property="og:type" content="article">
            <meta property="og:title" content="None Type - Python Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master Python's None type with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/none-type.jsp">
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
        "name": "Python None Type",
        "description": "Master Python's None type: the null value representing absence of value.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["None type basics", "Checking for None", "None in functions", "Default arguments", "Common None patterns"],
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

        <body class="tutorial-body no-preview" data-lesson="none-type">
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
                                    <span>None Type</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">None Type</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><code>None</code> is Python's way of representing "no value" or
                                        "nothing" - similar
                                        to <code>null</code> in other languages. It's used to indicate the absence of a
                                        value, uninitialized
                                        variables, and optional parameters.</p>

                                    <!-- Section 1: None Basics -->
                                    <h2>What is None?</h2>
                                    <p><code>None</code> is a special singleton object in Python. There's only one
                                        <code>None</code>
                                        object, and any variable set to <code>None</code> points to the same object.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/none-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Point:</strong> <code>None</code> is <em>not</em> the same as
                                        <code>False</code>,
                                        <code>0</code>, or an empty string <code>""</code>. These are all different
                                        values, though they
                                        all evaluate as "falsy" in boolean contexts.
                                    </div>

                                    <!-- Section 2: Checking for None -->
                                    <h2>Checking for None</h2>
                                    <p>Always use <code>is</code> or <code>is not</code> to check for <code>None</code>,
                                        not <code>==</code>.
                                        This is one of Python's most important conventions!</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Check</th>
                                                <th>Syntax</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Is None</td>
                                                <td><code>x is None</code></td>
                                                <td>✓ Correct way</td>
                                            </tr>
                                            <tr>
                                                <td>Is not None</td>
                                                <td><code>x is not None</code></td>
                                                <td>✓ Correct way</td>
                                            </tr>
                                            <tr>
                                                <td>Equals None</td>
                                                <td><code>x == None</code></td>
                                                <td>✗ Works but not recommended</td>
                                            </tr>
                                            <tr>
                                                <td>Truthy check</td>
                                                <td><code>if x:</code></td>
                                                <td>✗ Wrong - fails for valid falsy values</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/none-checking.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-checking" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Critical Mistake:</strong> Don't use <code>if x:</code> to check for
                                        None! This fails
                                        when <code>x</code> is a valid value like <code>0</code>, <code>""</code>, or
                                        <code>[]</code>.
                                        Always use <code>if x is None:</code> or <code>if x is not None:</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: None in Functions -->
                                    <h2>None in Functions</h2>
                                    <p>None plays a crucial role in Python functions - it's the default return value,
                                        and it's the
                                        preferred way to handle optional parameters with mutable default values.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/none-functions.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-functions" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always use <code>None</code> as the default
                                        value for mutable
                                        arguments (lists, dicts, sets). Then check for None inside the function and
                                        create a fresh
                                        mutable object if needed.
                                    </div>

                                    <!-- Section 4: Common Patterns -->
                                    <h2>Common None Patterns</h2>
                                    <p>Here are useful patterns for working with None values in real-world code.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/none-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using == instead of is</h4>
                                        <pre><code class="language-python"># Not recommended
if x == None:
    print("x is None")

# Correct - use 'is'
if x is None:
    print("x is None")</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using mutable default arguments</h4>
                                        <pre><code class="language-python"># WRONG - the list persists between calls!
def add_item(item, items=[]):
    items.append(item)
    return items

# CORRECT - use None as default
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing 'if x' with 'if x is not None'</h4>
                                        <pre><code class="language-python">count = 0

# WRONG - 0 is valid but treated as "no value"
if count:
    print(f"Count: {count}")
else:
    print("No count")  # This prints!

# CORRECT
if count is not None:
    print(f"Count: {count}")  # This prints "Count: 0"</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Calling methods on potentially None values</h4>
                                        <pre><code class="language-python">name = get_user_name()  # Might return None

# WRONG - crashes if name is None
print(name.upper())  # AttributeError!

# CORRECT - check first
if name is not None:
    print(name.upper())
else:
    print("No name available")</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: None Type Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Practice working with None values in various
                                            scenarios.</p>

                                        <p><strong>Skills tested:</strong></p>
                                        <ul>
                                            <li>Checking for None correctly</li>
                                            <li>Providing default values</li>
                                            <li>Filtering None values</li>
                                            <li>Working with None in functions</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-none-type.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-none" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">name = None
age = 25
scores = [85, None, 92, None, 78]
config = {"host": "localhost", "port": None, "debug": True}

# 1. Check if name is None
print(name is None)  # True

# 2. Default value if None
print(name if name is not None else "Guest")  # 'Guest'

# 3. Check if age is NOT None
print(age is not None)  # True

# 4. Count None values
print(sum(1 for s in scores if s is None))  # 2

# 5. Filter out None
print([s for s in scores if s is not None])  # [85, 92, 78]

# 6. Get port with default
port = config.get("port")
print(port if port is not None else 8080)  # 8080

# 7. Keys with None values
print([k for k, v in config.items() if v is None])  # ['port']

# 8. Function returning None for negative
def safe_square(n):
    return None if n < 0 else n ** 2

print(safe_square(-5))  # None
print(safe_square(5))   # 25

# 9. bool(None) is False
print(bool(None) == False)  # True

# 10. Replace None with 0
print([s if s is not None else 0 for s in scores])  # [85, 0, 92, 0, 78]</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>None:</strong> Python's null value representing "no value"</li>
                                            <li><strong>Singleton:</strong> There's only one None object - all None
                                                references point to it</li>
                                            <li><strong>Checking:</strong> Always use <code>is None</code> or
                                                <code>is not None</code></li>
                                            <li><strong>Falsy:</strong> None is falsy but NOT equal to False, 0, or ""
                                            </li>
                                            <li><strong>Functions:</strong> Default return value when no return
                                                statement</li>
                                            <li><strong>Default args:</strong> Use None as default for mutable
                                                parameters</li>
                                            <li><strong>Type:</strong> <code>type(None)</code> is <code>NoneType</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed the <strong>Variables & Data Types</strong>
                                        module. In the next
                                        module, we'll explore <strong>Operators</strong> - arithmetic, comparison,
                                        logical, and more.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="type-conversion.jsp" />
                                    <jsp:param name="prevTitle" value="Type Conversion" />
                                    <jsp:param name="nextLink" value="operators-arithmetic.jsp" />
                                    <jsp:param name="nextTitle" value="Arithmetic Operators" />
                                    <jsp:param name="currentLessonId" value="none-type" />
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