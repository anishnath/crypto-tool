<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-logical");
   request.setAttribute("currentModule", "Operators & Arithmetic"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Logical Operators - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash logical operators including && (AND), || (OR), ! (NOT), and command chaining. Master combining conditions and short-circuit evaluation in shell scripts.">
    <meta name="keywords"
        content="bash logical operators, bash && ||, bash and or not, bash command chaining, bash short circuit, bash -a -o">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Logical Operators - Bash Tutorial">
    <meta property="og:description" content="Master Bash logical operators for combining conditions and command chaining in shell scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/operators-logical.jsp">
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
        "name": "Bash Logical Operators",
        "description": "Learn Bash logical operators including && (AND), || (OR), ! (NOT), and command chaining patterns.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["AND operator &&", "OR operator ||", "NOT operator !", "Command chaining", "Short-circuit evaluation", "POSIX -a and -o"],
        "timeRequired": "PT15M",
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

<body class="tutorial-body no-preview" data-lesson="operators-logical">
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
                    <span>Logical Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Logical Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Logical operators let you combine multiple conditions and control command execution flow in Bash. You'll learn to use AND (<code>&&</code>), OR (<code>||</code>), and NOT (<code>!</code>) to build complex conditional logic, plus a powerful technique for command chaining based on success or failure!</p>

                    <!-- Section 1: Logical Operators in Conditions -->
                    <h2>Logical Operators in Conditions</h2>
                    <p>Inside <code>[[ ]]</code> or <code>(( ))</code>, use <code>&&</code> (AND), <code>||</code> (OR), and <code>!</code> (NOT) to combine conditions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-logical.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-logical" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>&&</code></td>
                                <td>AND</td>
                                <td>True if BOTH conditions are true</td>
                                <td><code>[[ \$a -gt 5 && \$b -lt 10 ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>||</code></td>
                                <td>OR</td>
                                <td>True if EITHER condition is true</td>
                                <td><code>[[ \$x == "yes" || \$x == "y" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>!</code></td>
                                <td>NOT</td>
                                <td>Inverts the condition (true becomes false)</td>
                                <td><code>[[ ! -f "\$file" ]]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Operator Precedence:</strong> NOT (<code>!</code>) has the highest precedence, then AND (<code>&&</code>), then OR (<code>||</code>). Use parentheses to group conditions: <code>[[ (cond1 || cond2) && cond3 ]]</code>.
                    </div>

                    <!-- Section 2: Command Chaining -->
                    <h2>Command Chaining with && and ||</h2>
                    <p>Outside of <code>[[ ]]</code>, these operators chain commands based on exit status. This is one of the most useful patterns in shell scripting!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-logical-commands.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-commands" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Pattern</th>
                                <th>Behavior</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>cmd1 && cmd2</code></td>
                                <td>Run cmd2 only if cmd1 succeeds (exit 0)</td>
                                <td>Sequential dependent tasks</td>
                            </tr>
                            <tr>
                                <td><code>cmd1 || cmd2</code></td>
                                <td>Run cmd2 only if cmd1 fails (exit non-0)</td>
                                <td>Fallback/error handling</td>
                            </tr>
                            <tr>
                                <td><code>cmd && true || false</code></td>
                                <td>Ternary-like: do one thing on success, another on failure</td>
                                <td>Conditional actions</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The <code>cmd && success_action || failure_action</code> pattern is great for one-liners but can be tricky. If <code>success_action</code> itself fails, <code>failure_action</code> will also run! For complex logic, use proper <code>if</code> statements.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Short-Circuit Evaluation -->
                    <h2>Short-Circuit Evaluation</h2>
                    <p>Bash uses <strong>short-circuit evaluation</strong>, meaning it stops evaluating as soon as the result is determined. This is important for both performance and avoiding errors!</p>

                    <pre><code class="language-bash"># AND short-circuits on first false
[[ false && echo "This won't run" ]]

# OR short-circuits on first true
[[ true || echo "This won't run" ]]

# Practical use: check variable exists before using
[[ -n "\$file" && -f "\$file" ]] && cat "\$file"
# If file is empty/unset, the -f test never runs

# Safe division: check denominator first
denom=0
[[ \$denom -ne 0 && \$((10 / denom)) -gt 5 ]]
# Division never executes because first condition is false</code></pre>

                    <div class="info-box">
                        <strong>Why It Matters:</strong>
                        <ul>
                            <li><strong>Performance:</strong> Unnecessary checks are skipped</li>
                            <li><strong>Safety:</strong> Prevents errors from invalid operations</li>
                            <li><strong>Guard Pattern:</strong> Check existence before accessing (<code>[[ -f \$f && cat \$f ]]</code>)</li>
                        </ul>
                    </div>

                    <!-- Section 4: POSIX Operators -->
                    <h2>POSIX Operators: -a and -o (Legacy)</h2>
                    <p>Inside <code>[ ]</code> (single brackets), the POSIX-compatible operators are <code>-a</code> (AND) and <code>-o</code> (OR). You'll see these in older scripts.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-logical-posix.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-posix" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> The <code>-a</code> and <code>-o</code> operators are deprecated and can cause issues with certain inputs. Always prefer <code>&&</code> and <code>||</code> inside <code>[[ ]]</code> for modern scripts. Only use <code>-a</code> and <code>-o</code> when writing strictly POSIX-compliant scripts for non-Bash shells.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using && and || in single brackets [ ]</h4>
                        <pre><code class="language-bash"># Wrong - && is command chaining, not logical AND in [ ]
[ \$a -gt 5 && \$b -lt 10 ]  # Syntax error or wrong behavior

# Correct - use -a inside [ ]
[ \$a -gt 5 -a \$b -lt 10 ]

# Better - use [[ ]] with &&
[[ \$a -gt 5 && \$b -lt 10 ]]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Misunderstanding the ternary-like pattern</h4>
                        <pre><code class="language-bash"># Potentially wrong behavior
[[ condition ]] && echo "success" || echo "fail"
# If echo "success" fails somehow, "fail" also prints!

# Safer alternative for complex logic
if [[ condition ]]; then
    echo "success"
else
    echo "fail"
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting parentheses for precedence</h4>
                        <pre><code class="language-bash"># Confusing precedence
[[ \$a == "x" || \$b == "y" && \$c == "z" ]]
# This is: a=="x" OR (b=="y" AND c=="z")

# Use parentheses for clarity
[[ (\$a == "x" || \$b == "y") && \$c == "z" ]]
# This is: (a=="x" OR b=="y") AND c=="z"</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Access Control Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that checks multiple conditions for access control!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if user is "admin" OR user is "root"</li>
                            <li>Check if age is 18+ AND has permission flag</li>
                            <li>Use NOT to check if user is NOT banned</li>
                            <li>Use command chaining to create a log file only on success</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Access Control Script

user="admin"
age=25
has_permission=true
banned_users="guest blocked"

echo "=== Access Control Check ==="
echo "User: \$user, Age: \$age, Has Permission: \$has_permission"
echo ""

# Check 1: Admin OR Root
echo "--- Check 1: Admin or Root ---"
if [[ "\$user" == "admin" || "\$user" == "root" ]]; then
    echo "PASS: User is admin or root"
else
    echo "FAIL: User is not admin or root"
fi

# Check 2: Age AND Permission
echo ""
echo "--- Check 2: Age and Permission ---"
if [[ \$age -ge 18 && "\$has_permission" == "true" ]]; then
    echo "PASS: User is 18+ with permission"
else
    echo "FAIL: Age or permission check failed"
fi

# Check 3: NOT Banned
echo ""
echo "--- Check 3: Not Banned ---"
if [[ ! "\$banned_users" =~ \$user ]]; then
    echo "PASS: User is not banned"
else
    echo "FAIL: User is banned"
fi

# Command chaining: Log success
echo ""
echo "--- Command Chaining ---"
[[ "\$user" == "admin" ]] && echo "Access granted" || echo "Access denied"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>AND (<code>&&</code>):</strong> Both conditions must be true; in command chaining, runs second only if first succeeds</li>
                            <li><strong>OR (<code>||</code>):</strong> Either condition can be true; in command chaining, runs second only if first fails</li>
                            <li><strong>NOT (<code>!</code>):</strong> Inverts the condition's truth value</li>
                            <li><strong>Short-Circuit:</strong> Evaluation stops when result is determined</li>
                            <li><strong>Precedence:</strong> ! > && > || (use parentheses for clarity)</li>
                            <li><strong>Legacy:</strong> <code>-a</code> and <code>-o</code> for POSIX compatibility (prefer <code>&&</code> and <code>||</code>)</li>
                            <li><strong>Command Chaining:</strong> <code>cmd1 && cmd2 || cmd3</code> for conditional execution</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can combine conditions, let's learn about <strong>File Test Operators</strong>. You'll discover how to check if files exist, are readable, writable, executable, and much more. These are essential for any script that works with files!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-comparison.jsp" />
                    <jsp:param name="prevTitle" value="Comparison Operators" />
                    <jsp:param name="nextLink" value="operators-file-test.jsp" />
                    <jsp:param name="nextTitle" value="File Test Operators" />
                    <jsp:param name="currentLessonId" value="operators-logical" />
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
