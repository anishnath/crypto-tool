<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-control");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Loop Control - break, continue, exit, return | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash loop control: break and continue statements, exit vs return, breaking nested loops, and controlling script flow.">
    <meta name="keywords"
        content="bash break, bash continue, bash exit, bash return, loop control, break nested loop, shell scripting control">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Loop Control - break, continue, exit, return">
    <meta property="og:description" content="Master loop control statements for fine-grained control over loop execution.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/loops-control.jsp">
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
        "name": "Bash Loop Control",
        "description": "Learn Bash loop control statements: break, continue, exit, and return for controlling loop execution.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Break statement", "Continue statement", "Exit vs return", "Nested loop control", "Loop flow control"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
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
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Loop Control</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Loop Control</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Loop control statements give you fine-grained control over loop execution. <code>break</code> exits a loop early, <code>continue</code> skips to the next iteration, <code>exit</code> terminates the entire script, and <code>return</code> exits a function. Understanding these control mechanisms is essential for writing robust, efficient scripts that can handle edge cases and terminate gracefully!</p>

                    <!-- Section 1: Break Statement -->
                    <h2>Break Statement</h2>
                    <p>The <code>break</code> statement immediately exits the innermost loop, regardless of the loop's normal termination condition. It's useful when you've found what you're looking for or encountered an error condition.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-control.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-control" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic break usage
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "Breaking at $i"
        break
    fi
    echo "$i"
done

# Output:
# 1
# 2
# 3
# 4
# Breaking at 5

# Break in while loop
count=0
while true; do
    count=$((count + 1))
    if [ $count -ge 5 ]; then
        break
    fi
    echo "Count: $count"
done</code></pre>

                    <div class="info-box">
                        <strong>Break Behavior:</strong><br>
                        - Exits only the <strong>innermost</strong> loop<br>
                        - Execution continues after the loop<br>
                        - Can be used with all loop types (for, while, until)<br>
                        - Often used with if statements inside loops
                    </div>

                    <!-- Section 2: Continue Statement -->
                    <h2>Continue Statement</h2>
                    <p>The <code>continue</code> statement skips the rest of the current loop iteration and jumps to the next iteration. It's useful for skipping specific cases while continuing the loop.</p>

                    <pre><code class="language-bash"># Continue example: Skip even numbers
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue  # Skip to next iteration
    fi
    echo "$i"  # Only prints odd numbers
done

# Output:
# 1
# 3
# 5
# 7
# 9

# Continue in while loop
count=0
while [ $count -lt 10 ]; do
    count=$((count + 1))
    if [ $((count % 3)) -eq 0 ]; then
        continue  # Skip multiples of 3
    fi
    echo "Count: $count"
done</code></pre>

                    <div class="tip-box">
                        <strong>Continue vs Break:</strong><br>
                        - <code>continue</code>: Skip remaining code in current iteration, go to next iteration<br>
                        - <code>break</code>: Exit the loop entirely, go to code after loop
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Breaking Nested Loops -->
                    <h2>Breaking Nested Loops</h2>
                    <p>By default, <code>break</code> only exits the innermost loop. To break out of multiple nested loops, you need to use flags or restructure your code.</p>

                    <pre><code class="language-bash"># Break only exits inner loop
for i in {1..3}; do
    for j in {1..3}; do
        if [ $j -eq 2 ]; then
            break  # Only breaks inner loop
        fi
        echo "i=$i, j=$j"
    done
    echo "After inner loop: i=$i"
done

# Output:
# i=1, j=1
# After inner loop: i=1
# i=2, j=1
# After inner loop: i=2
# i=3, j=1
# After inner loop: i=3

# Breaking outer loop using a flag
outer_done=false
for i in {1..3}; do
    for j in {1..3}; do
        if [ $i -eq 2 ] && [ $j -eq 2 ]; then
            outer_done=true
            break  # Break inner loop
        fi
        echo "i=$i, j=$j"
    done
    if [ "$outer_done" = true ]; then
        break  # Break outer loop
    fi
done</code></pre>

                    <div class="info-box">
                        <strong>Breaking Multiple Loops:</strong><br>
                        - Bash doesn't support labeled breaks like some languages<br>
                        - Use boolean flags to break outer loops<br>
                        - Consider restructuring code with functions if breaking becomes complex<br>
                        - Functions can use return to exit early
                    </div>

                    <!-- Section 4: Exit vs Return -->
                    <h2>Exit vs Return</h2>
                    <p><code>exit</code> and <code>return</code> are related but different: <code>exit</code> terminates the entire script, while <code>return</code> exits only the current function.</p>

                    <pre><code class="language-bash"># Exit: Terminates entire script
echo "Before exit"
exit 0  # Script stops here, exit code 0
echo "This never executes"

# Return: Exits function only
function test_function() {
    echo "Inside function"
    return 0  # Exits function, returns to caller
    echo "This never executes"
}

echo "Before function"
test_function
echo "After function"  # This executes

# Exit codes
exit 0   # Success
exit 1   # General error
exit 2   # Misuse of shell command
# ... other codes

# Return codes (functions)
return 0   # Success
return 1   # Error
# Check with $?</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Statement</th>
                                <th>Scope</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>break</code></td>
                                <td>Exits innermost loop</td>
                                <td>Early loop termination</td>
                            </tr>
                            <tr>
                                <td><code>continue</code></td>
                                <td>Skips current iteration</td>
                                <td>Skip specific cases in loop</td>
                            </tr>
                            <tr>
                                <td><code>exit</code></td>
                                <td>Terminates entire script</td>
                                <td>Fatal errors, script completion</td>
                            </tr>
                            <tr>
                                <td><code>return</code></td>
                                <td>Exits current function</td>
                                <td>Function early return, error handling</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using exit instead of break in loops</h4>
                        <pre><code class="language-bash"># Wrong - exit terminates entire script
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        exit 0  # Script ends here!
    fi
    echo "$i"
done
echo "This never executes"

# Correct - break exits loop only
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break  # Only exits loop
    fi
    echo "$i"
done
echo "This executes"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using return outside a function</h4>
                        <pre><code class="language-bash"># Wrong - return only works in functions
#!/bin/bash
if [ $# -eq 0 ]; then
    return 1  # Error: can only return from function
fi

# Correct - use exit in main script
#!/bin/bash
if [ $# -eq 0 ]; then
    exit 1  # Exit script with error
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing continue and break</h4>
                        <pre><code class="language-bash"># Wrong - break exits loop when we want to skip
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        break  # Wrong! Exits loop entirely
    fi
    echo "$i"
done  # Only prints 1

# Correct - continue skips to next iteration
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue  # Skips even numbers, continues loop
    fi
    echo "$i"
done  # Prints all odd numbers</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Control Loop Execution</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Practice using loop control statements!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use break to exit a loop when a condition is met</li>
                            <li>Use continue to skip specific iterations</li>
                            <li>Create nested loops and break the outer loop using a flag</li>
                            <li>Demonstrate exit vs return in a function</li>
                            <li>Show how break and continue differ in behavior</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Loop control exercises

# 1. Break example
echo "Break example (stops at 5):"
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "Breaking at $i"
        break
    fi
    echo "  $i"
done

# 2. Continue example
echo -e "\nContinue example (skips even):"
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue
    fi
    echo "  $i"
done

# 3. Breaking nested loops
echo -e "\nBreaking nested loops:"
outer_done=false
for i in {1..3}; do
    for j in {1..3}; do
        if [ $i -eq 2 ] && [ $j -eq 2 ]; then
            echo "  Breaking at i=$i, j=$j"
            outer_done=true
            break
        fi
        echo "  i=$i, j=$j"
    done
    [ "$outer_done" = true ] && break
done

# 4. Exit vs Return
echo -e "\nExit vs Return:"
function test_return() {
    echo "  Inside function"
    return 0
    echo "  This won't execute"
}

echo "Before function"
test_return
echo "After function (script continues)"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>break:</strong> Exits innermost loop immediately</li>
                            <li><strong>continue:</strong> Skips to next iteration of loop</li>
                            <li><strong>exit:</strong> Terminates entire script (use exit codes)</li>
                            <li><strong>return:</strong> Exits current function (function-only)</li>
                            <li><strong>Nested Loops:</strong> Use flags to break outer loops</li>
                            <li><strong>Loop Scope:</strong> break/continue only affect loops, not scripts</li>
                            <li><strong>Function Scope:</strong> return only works inside functions</li>
                            <li><strong>Exit Codes:</strong> Use appropriate exit codes (0=success, non-zero=error)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Perfect! You've mastered loop control statements. Next, we'll learn about <strong>Select Menus</strong> - interactive menu loops that let users choose from options. Select loops are perfect for creating user-friendly command-line interfaces!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-while.jsp" />
                    <jsp:param name="prevTitle" value="While & Until Loops" />
                    <jsp:param name="nextLink" value="loops-select.jsp" />
                    <jsp:param name="nextTitle" value="Select Menus" />
                    <jsp:param name="currentLessonId" value="loops-control" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>

