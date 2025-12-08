<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-control");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Loop Control - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python loop control statements: break, continue, and pass. Learn to exit loops early, skip iterations, and use placeholders effectively.">
    <meta name="keywords"
        content="python break, python continue, python pass, python loop control, python exit loop, python skip iteration">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Loop Control - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python loop control statements: break, continue, and pass.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/loops-control.jsp">
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
        "name": "Python Loop Control",
        "description": "Master Python loop control statements: break, continue, and pass.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["break statement", "continue statement", "pass statement", "Loop else clause", "Early exit patterns"],
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

<body class="tutorial-body no-preview" data-lesson="loops-control">
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
                    <span>Loop Control</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Loop Control Statements</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Loop control statements give you fine-grained control over loop execution.
                    <code>break</code> exits the loop entirely, <code>continue</code> skips to the next iteration,
                    and <code>pass</code> does nothing (but is syntactically useful).</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Statement</th>
                                <th>Effect</th>
                                <th>Common Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td><code>break</code></td><td>Exit loop immediately</td><td>Found what you're looking for</td></tr>
                            <tr><td><code>continue</code></td><td>Skip to next iteration</td><td>Filter/skip certain items</td></tr>
                            <tr><td><code>pass</code></td><td>Do nothing</td><td>Placeholder for future code</td></tr>
                        </tbody>
                    </table>

                    <!-- Section 1: break -->
                    <h2>The <code>break</code> Statement</h2>
                    <p>Use <code>break</code> to exit a loop immediately. Execution continues with the first
                    statement after the loop. If the loop has an <code>else</code> clause, it is NOT executed.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-control-break.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-break" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Performance Tip:</strong> Using <code>break</code> for early exit can significantly
                        improve performance. When searching a million items for a value that's at position 42,
                        break lets you stop after checking just 42 items instead of all million!
                    </div>

                    <!-- Section 2: continue -->
                    <h2>The <code>continue</code> Statement</h2>
                    <p>Use <code>continue</code> to skip the rest of the current iteration and move to the next one.
                    The loop doesn't end - it just skips ahead.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-control-continue.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-continue" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> <code>continue</code> is great for "guard clauses" at the start
                        of a loop. Check for invalid conditions and <code>continue</code> early, then write the
                        main logic without deep nesting.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: pass -->
                    <h2>The <code>pass</code> Statement</h2>
                    <p>The <code>pass</code> statement does nothing. It's a placeholder when Python syntax requires
                    a statement but you don't want to execute any code.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-control-pass.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-pass" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Don't Confuse pass and continue!</strong> <code>pass</code> does nothing and
                        continues to the next line. <code>continue</code> skips the rest of the iteration.
                        After <code>pass</code>, the code keeps running; after <code>continue</code>, it jumps
                        to the next iteration.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>These statements are essential for real-world patterns like validation, filtering,
                    and early-exit optimizations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/loops-control-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using break when you meant continue</h4>
                        <pre><code class="language-python"># Wrong - exits the entire loop!
for item in items:
    if not is_valid(item):
        break  # Stops processing all items!

# Correct - skip invalid, process rest
for item in items:
    if not is_valid(item):
        continue  # Skip this item, continue with others</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing pass with continue</h4>
                        <pre><code class="language-python"># These are different!
for i in range(3):
    if i == 1:
        pass
    print(i)  # Prints 0, 1, 2 - pass does nothing

for i in range(3):
    if i == 1:
        continue
    print(i)  # Prints 0, 2 - continue skips 1</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting break only exits ONE loop</h4>
                        <pre><code class="language-python"># break only exits the inner loop!
for i in range(3):
    for j in range(3):
        if j == 1:
            break  # Only breaks inner loop
    print(f"i={i}")  # Still runs for each i!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Unnecessary else after continue</h4>
                        <pre><code class="language-python"># Unnecessary else
for num in numbers:
    if num % 2 == 0:
        continue
    else:  # This else is redundant!
        print(num)

# Cleaner
for num in numbers:
    if num % 2 == 0:
        continue
    print(num)  # Only reaches here if didn't continue</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Find First Even Number</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Find the first even number in a list.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Iterate through the list</li>
                            <li>Skip odd numbers with <code>continue</code></li>
                            <li>Print and <code>break</code> when even number found</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-loops-control.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-control" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">numbers = [1, 3, 5, 7, 8, 9, 10]
found_even = None

for num in numbers:
    if num % 2 != 0:  # Odd number
        continue  # Skip to next
    # If we reach here, it's even
    found_even = num
    print(f"First even: {num}")
    break

if found_even is None:
    print("No even numbers found")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>break:</strong> Exit the loop immediately, skip loop's else</li>
                            <li><strong>continue:</strong> Skip rest of current iteration, go to next</li>
                            <li><strong>pass:</strong> Do nothing (placeholder)</li>
                            <li><strong>break in nested loops:</strong> Only exits the innermost loop</li>
                            <li><strong>Use break</strong> for early exit (found item, reached limit)</li>
                            <li><strong>Use continue</strong> for filtering/skipping invalid items</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can control loop flow, let's learn about <strong>nested loops</strong> -
                    loops inside loops! These are essential for working with 2D data like grids, matrices,
                    and combinations.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-while.jsp" />
                    <jsp:param name="prevTitle" value="While Loops" />
                    <jsp:param name="nextLink" value="loops-nested.jsp" />
                    <jsp:param name="nextTitle" value="Nested Loops" />
                    <jsp:param name="currentLessonId" value="loops-control" />
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
