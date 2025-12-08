<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-membership");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Membership & Identity Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python membership operators (in, not in) and identity operators (is, is not). Learn to check for values in sequences and compare object identity.">
    <meta name="keywords"
        content="python membership operators, python identity operators, python in operator, python is operator, python not in, python is not">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Membership & Identity Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python membership and identity operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-membership.jsp">
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
        "name": "Python Membership & Identity Operators",
        "description": "Master Python membership operators (in, not in) and identity operators (is, is not).",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["in operator", "not in operator", "is operator", "is not operator", "None checking", "Object identity vs equality"],
        "timeRequired": "PT15M",
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

<body class="tutorial-body no-preview" data-lesson="operators-membership">
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
                    <span>Membership & Identity Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Membership & Identity Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python provides intuitive operators for checking if values exist in sequences
                    (<code>in</code>, <code>not in</code>) and for comparing object identity (<code>is</code>,
                    <code>is not</code>). These make your code read almost like English!</p>

                    <!-- Section 1: The 'in' Operator -->
                    <h2>The 'in' Membership Operator</h2>
                    <p>The <code>in</code> operator checks if a value exists within a sequence like a list, string,
                    tuple, set, or dictionary.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Sequence Type</th>
                                <th>What 'in' Checks</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>List</td><td>Item in list</td><td><code>'a' in ['a', 'b']</code> → True</td></tr>
                            <tr><td>String</td><td>Substring in string</td><td><code>'or' in 'world'</code> → True</td></tr>
                            <tr><td>Tuple</td><td>Item in tuple</td><td><code>1 in (1, 2, 3)</code> → True</td></tr>
                            <tr><td>Set</td><td>Item in set</td><td><code>5 in {1, 5, 9}</code> → True</td></tr>
                            <tr><td>Dictionary</td><td>Key in dict (not value!)</td><td><code>'name' in {'name': 'Jo'}</code> → True</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-membership-in.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-in" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> For dictionaries, <code>in</code> checks keys by default.
                        Use <code>value in dict.values()</code> to check values, or
                        <code>value in dict.items()</code> for key-value pairs.
                    </div>

                    <!-- Section 2: The 'not in' Operator -->
                    <h2>The 'not in' Operator</h2>
                    <p>The <code>not in</code> operator is the opposite of <code>in</code> - it returns True when
                    a value is NOT found in the sequence.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-membership-notin.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-notin" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Performance Tip:</strong> Checking membership in a <code>set</code> is O(1) constant time,
                        while lists are O(n). For large collections with many lookups, convert to a set first!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Identity Operators -->
                    <h2>Identity Operators: 'is' and 'is not'</h2>
                    <p>Identity operators check if two variables point to the <strong>same object in memory</strong>,
                    not just if they have equal values.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>is</code></td><td>True if same object</td><td><code>a is b</code></td></tr>
                            <tr><td><code>is not</code></td><td>True if different objects</td><td><code>a is not b</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-identity.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-identity" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Important:</strong> Don't use <code>is</code> to compare values! Use <code>==</code>
                        for value comparison. <code>is</code> should primarily be used for checking <code>None</code>,
                        <code>True</code>, or <code>False</code>.
                    </div>

                    <!-- Section 4: Practical Uses -->
                    <h2>Practical Uses of Identity Operators</h2>
                    <p>The most common and important use of <code>is</code> is checking for <code>None</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-identity-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Always use <code>is None</code> or <code>is not None</code>
                        instead of <code>== None</code>. It's faster, safer, and the recommended Python style (PEP 8).
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using 'is' to compare values</h4>
                        <pre><code class="language-python"># Wrong - may work sometimes, but unreliable!
if name is "Alice":  # Don't do this!
    print("Hello Alice")

# Correct - use == for value comparison
if name == "Alice":
    print("Hello Alice")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Checking dictionary values with 'in'</h4>
                        <pre><code class="language-python">person = {"name": "Alice", "age": 30}

# Wrong - checks keys, not values!
if "Alice" in person:  # False!
    print("Found Alice")

# Correct - explicitly check values
if "Alice" in person.values():
    print("Found Alice")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Case-sensitive string membership</h4>
                        <pre><code class="language-python">text = "Hello World"

# This fails because of case
if "hello" in text:  # False!
    print("Found")

# Correct - normalize case first
if "hello" in text.lower():
    print("Found")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using == instead of 'is' for None</h4>
                        <pre><code class="language-python"># Works but not recommended
if result == None:
    print("No result")

# Correct and preferred
if result is None:
    print("No result")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Access Control</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Build an access control checker using membership operators.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if a user is in the guests list using <code>in</code></li>
                            <li>Check if a user is in the banned list using <code>in</code></li>
                            <li>Check if a user is NOT banned using <code>not in</code></li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-membership.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-membership" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">guests = ["Alice", "Bob", "Charlie", "David"]
banned_users = ["Eve", "Mallory"]

name_to_check = "Bob"
banned_name = "Eve"

# 1. Check if name is in guests list
is_invited = name_to_check in guests
print(f"Is {name_to_check} invited? {is_invited}")  # True

# 2. Check if name is in banned list
is_banned = banned_name in banned_users
print(f"Is {banned_name} banned? {is_banned}")  # True

# 3. Check if name is NOT in banned list
is_safe = name_to_check not in banned_users
print(f"Is {name_to_check} safe? {is_safe}")  # True</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>in:</strong> Checks if a value exists in a sequence (list, string, tuple, set, dict keys)</li>
                            <li><strong>not in:</strong> Checks if a value does NOT exist in a sequence</li>
                            <li><strong>is:</strong> Checks if two variables point to the same object in memory</li>
                            <li><strong>is not:</strong> Checks if two variables point to different objects</li>
                            <li><strong>Use <code>==</code></strong> for value comparison, <strong><code>is</code></strong> for identity/None checks</li>
                            <li><strong>Performance:</strong> Set membership is O(1), list membership is O(n)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Operators module! You now have all the tools to build
                    expressions and make decisions in Python. Next, we'll learn about <strong>control flow</strong>
                    with <code>if</code> statements - using these operators to direct your program's execution!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-bitwise.jsp" />
                    <jsp:param name="prevTitle" value="Bitwise Operators" />
                    <jsp:param name="nextLink" value="control-if.jsp" />
                    <jsp:param name="nextTitle" value="If Statements" />
                    <jsp:param name="currentLessonId" value="operators-membership" />
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
