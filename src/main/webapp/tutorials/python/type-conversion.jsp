<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "type-conversion");
   request.setAttribute("currentModule", "Variables & Data Types"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Type Conversion - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python type conversion: int(), float(), str(), bool(), list(), tuple(), set(), dict(). Learn explicit and implicit type casting.">
    <meta name="keywords"
        content="python type conversion, python type casting, python int float str, python list tuple set dict conversion">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Type Conversion - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python type conversion with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/type-conversion.jsp">
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
        "name": "Python Type Conversion",
        "description": "Master Python type conversion: int(), float(), str(), bool(), list(), tuple(), set(), dict().",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Type conversion functions", "Numeric conversions", "String conversions", "Collection conversions", "Implicit type coercion"],
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

<body class="tutorial-body no-preview" data-lesson="type-conversion">
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
                    <span>Type Conversion</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Type Conversion</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Type conversion (or type casting) is the process of converting a value from one
                    data type to another. Python provides built-in functions like <code>int()</code>, <code>float()</code>,
                    <code>str()</code>, and <code>bool()</code> for this purpose.</p>

                    <!-- Section 1: Basic Conversions -->
                    <h2>Basic Type Conversions</h2>
                    <p>Python provides several built-in functions to convert between basic types:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>Converts To</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>int()</code></td><td>Integer</td><td><code>int("42")</code> → 42</td></tr>
                            <tr><td><code>float()</code></td><td>Float</td><td><code>float("3.14")</code> → 3.14</td></tr>
                            <tr><td><code>str()</code></td><td>String</td><td><code>str(42)</code> → "42"</td></tr>
                            <tr><td><code>bool()</code></td><td>Boolean</td><td><code>bool(1)</code> → True</td></tr>
                            <tr><td><code>type()</code></td><td>N/A</td><td>Returns the type of a value</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/type-conversion-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Remember:</strong> <code>int()</code> truncates toward zero - it doesn't round!
                        <code>int(3.9)</code> gives 3, not 4. Use <code>round()</code> if you need rounding.
                    </div>

                    <!-- Section 2: Numeric Conversions -->
                    <h2>Numeric Type Conversions</h2>
                    <p>Python has three numeric types: <code>int</code>, <code>float</code>, and <code>complex</code>.
                    Understanding how they convert between each other is crucial.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/type-conversion-numbers.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-numbers" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Type Hierarchy:</strong> When mixing types in operations, Python converts to the
                        "higher" type: <code>int → float → complex</code>. This is called implicit type coercion.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: String Conversions -->
                    <h2>String Conversions</h2>
                    <p>Converting to and from strings is one of the most common operations, especially when
                    dealing with user input or file data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/type-conversion-strings.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-strings" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Common Pitfall:</strong> You can't convert a float string directly to int!
                        <code>int("3.14")</code> raises ValueError. Use <code>int(float("3.14"))</code> instead.
                    </div>

                    <!-- Section 4: Collection Conversions -->
                    <h2>Collection Type Conversions</h2>
                    <p>Python's collection types (<code>list</code>, <code>tuple</code>, <code>set</code>, <code>dict</code>)
                    can be converted between each other.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>Creates</th>
                                <th>Key Behavior</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>list()</code></td><td>List</td><td>Mutable, ordered sequence</td></tr>
                            <tr><td><code>tuple()</code></td><td>Tuple</td><td>Immutable, ordered sequence</td></tr>
                            <tr><td><code>set()</code></td><td>Set</td><td>Unique values only, unordered</td></tr>
                            <tr><td><code>dict()</code></td><td>Dictionary</td><td>From key-value pairs</td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/type-conversion-collections.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-collections" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Quick Tip:</strong> Use <code>set()</code> to easily remove duplicates from a list:
                        <code>unique = list(set(my_list))</code>. Note: order may not be preserved!
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Converting non-numeric strings to int/float</h4>
                        <pre><code class="language-python"># This raises ValueError!
int("hello")    # ValueError
float("abc")    # ValueError

# Always validate before converting
user_input = "42"
if user_input.isdigit():
    number = int(user_input)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Expecting int() to round</h4>
                        <pre><code class="language-python"># int() truncates, doesn't round!
int(2.9)    # 2, not 3
int(-2.9)   # -2, not -3

# Use round() for rounding
round(2.9)  # 3
round(2.5)  # 2 (banker's rounding!)
round(3.5)  # 4</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Thinking bool("False") is False</h4>
                        <pre><code class="language-python"># Any non-empty string is truthy!
bool("False")  # True! (non-empty string)
bool("")       # False (empty string)

# For string "False" to False
text = "False"
result = text.lower() == "true"  # False</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Losing precision with float-to-string</h4>
                        <pre><code class="language-python"># str() may not show all decimal places
pi = 3.141592653589793
print(str(pi))   # '3.141592653589793'

# Use formatting for control
print(f"{pi:.2f}")   # '3.14'
print(f"{pi:.10f}")  # '3.1415926536'</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Type Conversion Practice</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Practice converting between Python's different data types.</p>

                        <p><strong>Skills tested:</strong></p>
                        <ul>
                            <li>Basic type conversions (int, float, str, bool)</li>
                            <li>Collection conversions (list, tuple, set, dict)</li>
                            <li>Character conversions (ord, chr)</li>
                            <li>Chained conversions</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-type-conversion.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-conversion" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">string_number = "123"
float_number = 45.67
mixed_list = [1, 2, 2, 3, 3, 3, 4]
text = "Python"
pairs = [("name", "Alice"), ("age", "25")]

# 1. String to int, add 10
print(int(string_number) + 10)  # 133

# 2. Float to int (truncate)
print(int(float_number))  # 45

# 3. Float to string with 1 decimal
print(f"{float_number:.1f}")  # '45.7'

# 4. Remove duplicates
print(list(set(mixed_list)))  # [1, 2, 3, 4]

# 5. String to list of chars
print(list(text))  # ['P', 'y', 't', 'h', 'o', 'n']

# 6. Pairs to dictionary
print(dict(pairs))  # {'name': 'Alice', 'age': '25'}

# 7. ASCII value of first char
print(ord(text[0]))  # 80

# 8. Boolean to int
print(int(10 > 5))  # 1

# 9. List of ASCII to string
print(''.join(chr(n) for n in [72, 105, 33]))  # 'Hi!'

# 10. String → int → add → string
print(str(int("42") + 8))  # '50'</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>int():</strong> Convert to integer (truncates floats)</li>
                            <li><strong>float():</strong> Convert to floating-point number</li>
                            <li><strong>str():</strong> Convert to string representation</li>
                            <li><strong>bool():</strong> Convert to boolean (falsy values → False)</li>
                            <li><strong>list(), tuple(), set():</strong> Convert sequences</li>
                            <li><strong>dict():</strong> Create dictionary from key-value pairs</li>
                            <li><strong>ord(), chr():</strong> Character ↔ ASCII/Unicode conversion</li>
                            <li><strong>Implicit coercion:</strong> Python auto-converts in operations (int → float → complex)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>In the next lesson, we'll explore <strong>None</strong> - Python's special null value that
                    represents the absence of a value.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="booleans.jsp" />
                    <jsp:param name="prevTitle" value="Booleans" />
                    <jsp:param name="nextLink" value="none-type.jsp" />
                    <jsp:param name="nextTitle" value="None Type" />
                    <jsp:param name="currentLessonId" value="type-conversion" />
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
