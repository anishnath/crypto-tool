<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-while");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>While Loops - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python while loops. Learn condition-based iteration, while-else, infinite loops, and practical patterns for input validation and retry logic.">
    <meta name="keywords"
        content="python while loop, python infinite loop, python loop condition, python while else, python iteration">

    <meta property="og:type" content="article">
    <meta property="og:title" content="While Loops - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python while loops for condition-based iteration.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/loops-while.jsp">
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
        "name": "Python While Loops",
        "description": "Master Python while loops for condition-based iteration with practical examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["while loop syntax", "Loop conditions", "while-else clause", "Infinite loops", "Input validation", "Retry logic"],
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

<body class="tutorial-body no-preview" data-lesson="loops-while">
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
                    <span>While Loops</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">While Loops</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>while</code> loop executes code repeatedly as long as a condition is true.
                    Unlike <code>for</code> loops that iterate a known number of times, while loops are perfect when
                    you don't know in advance how many iterations you need!</p>

                    <!-- Section 1: Basic While Loop -->
                    <h2>Basic While Loop</h2>
                    <p>A while loop checks its condition before each iteration. When the condition becomes False,
                    the loop stops and execution continues after the loop.</p>

                    <div class="code-block">
                        <pre><code class="language-python">while condition:
    # code to execute (repeat while condition is True)
    # IMPORTANT: Update something to eventually make condition False!</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-while-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Difference:</strong> Use <code>for</code> loops when you know how many times
                        to iterate (or are iterating over a sequence). Use <code>while</code> loops when the
                        number of iterations depends on a condition that changes during execution.
                    </div>

                    <!-- Section 2: While-Else -->
                    <h2>The <code>while...else</code> Clause</h2>
                    <p>Python's while loop has an optional <code>else</code> clause that runs when the condition
                    becomes False normally. If the loop exits via <code>break</code>, the else is skipped.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-while-else.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-else" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The <code>while...else</code> pattern is useful for search loops.
                        The <code>else</code> block runs only if the item wasn't found (no break). Think of it as
                        "if not found" code!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>While loops excel at input validation, processing queues, retry logic, and any situation
                    where you repeat until a condition is met.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-while-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Section 4: Infinite Loops -->
                    <h2>Infinite Loops: Danger and Use Cases</h2>
                    <p>An infinite loop occurs when the condition never becomes False. Usually this is a bug,
                    but sometimes <code>while True:</code> with a <code>break</code> is a valid pattern.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-while-infinite.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-infinite" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Infinite Loop Prevention:</strong> Always ensure your while loop has: (1) a condition
                        that can become False, (2) code inside the loop that changes the condition, or (3) a
                        <code>break</code> statement that will eventually execute. Consider adding a failsafe
                        maximum iteration count!
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to update the loop variable</h4>
                        <pre><code class="language-python"># Wrong - infinite loop!
count = 1
while count <= 5:
    print(count)
    # Missing: count += 1

# Correct
count = 1
while count <= 5:
    print(count)
    count += 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Off-by-one errors</h4>
                        <pre><code class="language-python"># Wrong - prints 1-4, not 1-5
count = 1
while count < 5:  # Should be <= 5
    print(count)
    count += 1

# Correct - prints 1-5
count = 1
while count <= 5:
    print(count)
    count += 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Updating in wrong direction</h4>
                        <pre><code class="language-python"># Wrong - counting up when should count down!
n = 10
while n > 0:
    print(n)
    n += 1  # Should be n -= 1!

# Correct
n = 10
while n > 0:
    print(n)
    n -= 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Condition never matches</h4>
                        <pre><code class="language-python"># Wrong - 5 can never equal 10 with step of 2
x = 5
while x != 10:
    print(x)
    x += 2  # x: 5, 7, 9, 11, 13... never 10!

# Correct - use >= or <=
x = 5
while x < 10:
    print(x)
    x += 2</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Countdown Timer</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a countdown using a while loop.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Print numbers from 10 down to 1</li>
                            <li>Print "Blastoff!" after the loop</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-loops-while.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-while" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">start = 10
current = start

while current > 0:
    print(current)
    current -= 1  # Decrease by 1 each iteration

print("Blastoff!")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>while condition:</strong> Repeats while condition is True</li>
                            <li><strong>Must update</strong> something to eventually make condition False</li>
                            <li><strong>while...else:</strong> else runs only if loop completes normally (no break)</li>
                            <li><strong>while True:</strong> Intentional infinite loop, must have break</li>
                            <li><strong>Use cases:</strong> Input validation, retry logic, processing until done</li>
                            <li><strong>Danger:</strong> Infinite loops when condition never becomes False</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you know both for and while loops, let's learn about <strong>loop control statements</strong>
                    - <code>break</code>, <code>continue</code>, and <code>pass</code>. These give you fine-grained
                    control over loop execution!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-for.jsp" />
                    <jsp:param name="prevTitle" value="For Loops" />
                    <jsp:param name="nextLink" value="loops-control.jsp" />
                    <jsp:param name="nextTitle" value="Loop Control" />
                    <jsp:param name="currentLessonId" value="loops-while" />
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
