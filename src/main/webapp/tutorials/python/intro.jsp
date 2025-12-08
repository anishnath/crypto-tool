<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "intro");
   request.setAttribute("currentModule", "Introduction"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Hello World - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Write your first Python program! Learn print(), comments, and basic syntax. Start your Python journey with interactive examples.">
    <meta name="keywords"
        content="python hello world, python print, python syntax, learn python, python tutorial, python comments, python basics">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Hello World - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Write your first Python program with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/intro.jsp">
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
        "name": "Python Hello World",
        "description": "Write your first Python program. Learn print(), comments, and basic syntax.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["print() function", "Python comments", "Basic syntax", "String output", "Code execution"],
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

<body class="tutorial-body no-preview" data-lesson="intro">
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
                    <span>Hello World</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Hello World</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Welcome to Python! In this first lesson, you'll write your very first Python program.
                    Unlike many other languages, Python doesn't require complex setup - you can start coding immediately
                    with just a single line of code.</p>

                    <!-- Section 1: The Print Function -->
                    <h2>The <code>print()</code> Function</h2>
                    <p>The <code>print()</code> function is Python's way of displaying output to the screen. It's the most
                    basic and most-used function in Python - you'll use it constantly for debugging and displaying results.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/intro-hello.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-hello" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Why Python?</strong> Unlike Java or C++, Python doesn't require you to define a class
                        or a <code>main()</code> function just to print something. This simplicity is one of Python's
                        greatest strengths for beginners and experts alike.
                    </div>

                    <!-- Section 2: Printing Different Things -->
                    <h2>Printing Different Values</h2>
                    <p>The <code>print()</code> function can output much more than just text. It can display numbers,
                    the results of calculations, and multiple values at once.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/intro-print-values.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-values" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> When printing multiple items with commas, Python automatically adds
                        a space between them. Use this to your advantage for readable output!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Comments -->
                    <h2>Comments</h2>
                    <p>Comments are notes you leave in your code for yourself or other programmers. Python ignores
                    comments completely - they're just for humans to read.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Comment Type</th>
                                <th>Syntax</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Single-line</td>
                                <td><code># comment here</code></td>
                                <td>Short notes, inline explanations</td>
                            </tr>
                            <tr>
                                <td>Multi-line</td>
                                <td><code>""" or '''</code></td>
                                <td>Longer explanations, documentation</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/intro-comments.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-comments" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> Don't over-comment! Good code should be self-explanatory.
                        Comments should explain <em>why</em> you're doing something, not <em>what</em> you're doing.
                        <code>x = x + 1  # add 1 to x</code> is a bad comment because it's obvious.
                    </div>

                    <!-- Section 4: Python Syntax Basics -->
                    <h2>Python Syntax Basics</h2>
                    <p>Python has a clean, readable syntax that sets it apart from other languages. Here are the key
                    things to know:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/intro-syntax.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-syntax" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Indentation Matters!</strong> Unlike most languages that use braces <code>{}</code>,
                        Python uses indentation (spaces) to define code blocks. Standard practice is 4 spaces per level.
                        We'll explore this more in the Control Flow lessons.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting quotes around strings</h4>
                        <pre><code class="language-python"># Wrong - Python thinks Hello is a variable
print(Hello World)  # NameError!

# Correct - strings need quotes
print("Hello World")
print('Hello World')  # Single quotes work too</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Mismatched quotes</h4>
                        <pre><code class="language-python"># Wrong - started with " but ended with '
print("Hello World')  # SyntaxError!

# Correct - matching quotes
print("Hello World")
print('Hello World')</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using Print instead of print</h4>
                        <pre><code class="language-python"># Wrong - Python is case-sensitive!
Print("Hello")  # NameError: name 'Print' is not defined

# Correct - lowercase
print("Hello")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting parentheses (Python 3)</h4>
                        <pre><code class="language-python"># Wrong - this was valid in Python 2, not Python 3
print "Hello"  # SyntaxError!

# Correct - print is a function in Python 3
print("Hello")</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Your First Program</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a program that introduces yourself!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Print your name</li>
                            <li>Print your favorite programming language</li>
                            <li>Print a calculation (like your birth year)</li>
                            <li>Include at least one comment</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-intro.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-intro" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># My first Python program!

# Print my name
print("Hello, my name is Alex!")

# Print my favorite language
print("My favorite language is Python")

# Print a calculation - my birth year
current_year = 2024
age = 25
print("I was born in", current_year - age)

# Print multiple things
print("I started coding", age - 15, "years ago")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>print():</strong> Displays output to the screen - the most basic Python function</li>
                            <li><strong>Strings:</strong> Text must be wrapped in quotes (<code>"text"</code> or <code>'text'</code>)</li>
                            <li><strong>Comments:</strong> Use <code>#</code> for notes that Python ignores</li>
                            <li><strong>Case-sensitive:</strong> <code>print</code> and <code>Print</code> are different!</li>
                            <li><strong>No boilerplate:</strong> Python doesn't need classes or main functions for simple programs</li>
                            <li><strong>Indentation:</strong> Python uses spaces (not braces) to define code blocks</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on writing your first Python program! In the next lesson, we'll explore
                    <strong>variables</strong> - how to store and work with data in Python. You'll learn about
                    different data types and how to give meaningful names to your values.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="index.jsp" />
                    <jsp:param name="prevTitle" value="Course Overview" />
                    <jsp:param name="nextLink" value="variables.jsp" />
                    <jsp:param name="nextTitle" value="Variables" />
                    <jsp:param name="currentLessonId" value="intro" />
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
