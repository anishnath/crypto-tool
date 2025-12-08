<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-comparison");
   request.setAttribute("currentModule", "Operators & Arithmetic"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Comparison Operators - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash comparison operators for integers and strings. Master [[ ]], test command, numeric comparisons (-eq, -ne, -lt, -gt), string comparisons (==, !=), and regex matching (=~).">
    <meta name="keywords"
        content="bash comparison operators, bash test, bash [[ ]], bash -eq -ne -lt -gt, bash string comparison, bash regex, bash pattern matching">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Comparison Operators - Bash Tutorial">
    <meta property="og:description" content="Master Bash comparison operators for integers, strings, and pattern matching in shell scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/operators-comparison.jsp">
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
        "name": "Bash Comparison Operators",
        "description": "Learn Bash comparison operators for integers and strings, including [[ ]], test command, and regex matching.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Integer comparison operators", "String comparison operators", "test command", "[[ ]] syntax", "Pattern matching", "Regex matching =~", "BASH_REMATCH"],
        "timeRequired": "PT25M",
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

<body class="tutorial-body no-preview" data-lesson="operators-comparison">
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
                    <span>Comparison Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Comparison Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Comparison operators are the foundation of conditional logic in Bash. They let you compare numbers, strings, and patterns to make decisions in your scripts. You'll learn about the <code>[[ ]]</code> test construct, numeric comparison flags, string operators, and powerful pattern matching with regex!</p>

                    <!-- Section 1: Integer Comparisons -->
                    <h2>Integer Comparison Operators</h2>
                    <p>Bash provides two main ways to compare integers: using <code>(( ))</code> with C-style operators, or using <code>[[ ]]</code> with flag-based operators. Both are widely used.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-comparison.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-comparison" />
                    </jsp:include>

                    <h3>C-Style Operators in (( ))</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>==</code></td>
                                <td>Equal to</td>
                                <td><code>((a == b))</code></td>
                            </tr>
                            <tr>
                                <td><code>!=</code></td>
                                <td>Not equal to</td>
                                <td><code>((a != b))</code></td>
                            </tr>
                            <tr>
                                <td><code>&lt;</code></td>
                                <td>Less than</td>
                                <td><code>((a < b))</code></td>
                            </tr>
                            <tr>
                                <td><code>&gt;</code></td>
                                <td>Greater than</td>
                                <td><code>((a > b))</code></td>
                            </tr>
                            <tr>
                                <td><code>&lt;=</code></td>
                                <td>Less than or equal</td>
                                <td><code>((a <= b))</code></td>
                            </tr>
                            <tr>
                                <td><code>&gt;=</code></td>
                                <td>Greater than or equal</td>
                                <td><code>((a >= b))</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>Flag-Based Operators in [[ ]] or [ ]</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>-eq</code></td>
                                <td>Equal to</td>
                                <td><code>[[ \$a -eq \$b ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-ne</code></td>
                                <td>Not equal to</td>
                                <td><code>[[ \$a -ne \$b ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-lt</code></td>
                                <td>Less than</td>
                                <td><code>[[ \$a -lt \$b ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-gt</code></td>
                                <td>Greater than</td>
                                <td><code>[[ \$a -gt \$b ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-le</code></td>
                                <td>Less than or equal</td>
                                <td><code>[[ \$a -le \$b ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-ge</code></td>
                                <td>Greater than or equal</td>
                                <td><code>[[ \$a -ge \$b ]]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Key Point:</strong> Use <code>(( ))</code> for arithmetic comparisons (looks cleaner, supports C-style operators). Use <code>[[ ]]</code> when mixing with string tests or when you need the flag-based operators for POSIX compatibility.
                    </div>

                    <!-- Section 2: String Comparisons -->
                    <h2>String Comparison Operators</h2>
                    <p>String comparisons check text values. Always quote your variables inside <code>[[ ]]</code> to handle empty strings and spaces correctly!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-comparison-strings.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-strings" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>==</code> or <code>=</code></td>
                                <td>String equality</td>
                                <td><code>[[ "\$a" == "\$b" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>!=</code></td>
                                <td>String inequality</td>
                                <td><code>[[ "\$a" != "\$b" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>&lt;</code></td>
                                <td>Less than (lexicographic)</td>
                                <td><code>[[ "\$a" < "\$b" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>&gt;</code></td>
                                <td>Greater than (lexicographic)</td>
                                <td><code>[[ "\$a" > "\$b" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-z</code></td>
                                <td>String is empty (zero length)</td>
                                <td><code>[[ -z "\$str" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-n</code></td>
                                <td>String is not empty</td>
                                <td><code>[[ -n "\$str" ]]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Always quote variables in string comparisons: <code>[[ "\$var" == "text" ]]</code>. This prevents errors when variables are empty or contain spaces. Inside <code>[[ ]]</code>, word splitting doesn't occur, but quoting is still a good habit!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Pattern Matching -->
                    <h2>Pattern Matching and Regex</h2>
                    <p>The <code>[[ ]]</code> construct supports glob-style pattern matching with <code>==</code> and full regex matching with <code>=~</code>. These are powerful tools for string validation!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-comparison-regex.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-regex" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Pattern Matching Types:</strong>
                        <ul>
                            <li><strong>Glob patterns</strong> with <code>==</code>: Use <code>*</code> (any chars), <code>?</code> (one char), <code>[...]</code> (character class)</li>
                            <li><strong>Regex patterns</strong> with <code>=~</code>: Full extended regex support</li>
                            <li><strong>BASH_REMATCH</strong>: Array containing regex matches (index 0 = full match, 1+ = capture groups)</li>
                        </ul>
                    </div>

                    <div class="warning-box">
                        <strong>Caution:</strong> When using <code>=~</code> for regex, do NOT quote the pattern! Quoting turns it into a literal string match. Write <code>[[ \$str =~ ^[0-9]+$ ]]</code> not <code>[[ \$str =~ "^[0-9]+$" ]]</code>.
                    </div>

                    <!-- Section 4: The test Command -->
                    <h2>The test Command and [ ]</h2>
                    <p>The <code>test</code> command and <code>[ ]</code> are the POSIX-compliant, portable way to do comparisons. They work in any shell, not just Bash.</p>

                    <pre><code class="language-bash"># test command and [ ] are equivalent
test 5 -eq 5 && echo "Equal"
[ 5 -eq 5 ] && echo "Equal"

# String tests
test -n "hello" && echo "Not empty"
[ -z "" ] && echo "Empty"

# Combining with && and ||
[ "\$USER" = "root" ] && echo "You are root" || echo "Not root"

# IMPORTANT: Spaces are required!
# [ "\$a"="\$b" ]   # WRONG - no spaces
# [ "\$a" = "\$b" ] # CORRECT - spaces around =</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Prefer <code>[[ ]]</code> over <code>[ ]</code> in Bash scripts. It's more powerful (supports regex, pattern matching), safer (no word splitting), and doesn't require escaping <code><</code> and <code>></code>. Use <code>[ ]</code> only when writing portable POSIX scripts.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using = vs == for strings</h4>
                        <pre><code class="language-bash"># In [ ], use single =
[ "\$str" = "hello" ]   # Correct for [ ]

# In [[ ]], prefer ==
[[ "\$str" == "hello" ]]  # Preferred for [[ ]]

# Don't use -eq for strings!
[[ "\$str" -eq "hello" ]]  # Wrong! -eq is for numbers</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Missing spaces in [ ]</h4>
                        <pre><code class="language-bash"># Wrong - no spaces
[\$a -eq \$b]      # Error: command not found
[ \$a -eq\$b ]     # Error

# Correct - spaces required
[ \$a -eq \$b ]    # Works
[[ \$a -eq \$b ]]  # Works</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Quoting regex patterns</h4>
                        <pre><code class="language-bash"># Wrong - pattern is quoted, treated as literal
[[ "test123" =~ "^[a-z]+[0-9]+$" ]]  # Fails

# Correct - don't quote regex patterns
[[ "test123" =~ ^[a-z]+[0-9]+$ ]]    # Works</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Comparing numbers as strings</h4>
                        <pre><code class="language-bash"># Problematic - string comparison
[[ "10" > "9" ]]    # False! '10' < '9' lexicographically

# Correct - numeric comparison
[[ 10 -gt 9 ]]      # True
((10 > 9))          # True</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Input Validation Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that validates different types of input!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if a number is within a range (1-100)</li>
                            <li>Validate that a string is not empty</li>
                            <li>Check if a filename has a specific extension (.sh)</li>
                            <li>Use regex to validate a simple email format</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Input Validation Script

echo "=== Input Validation ==="
echo ""

# Number range check
number=50
echo "Checking number: \$number"
if ((number >= 1 && number <= 100)); then
    echo "  Valid: \$number is between 1 and 100"
else
    echo "  Invalid: Out of range"
fi
echo ""

# String not empty
username="alice"
echo "Checking username: '\$username'"
if [[ -n "\$username" ]]; then
    echo "  Valid: Username is not empty"
else
    echo "  Invalid: Username is empty"
fi
echo ""

# Filename extension
filename="script.sh"
echo "Checking filename: '\$filename'"
if [[ "\$filename" == *.sh ]]; then
    echo "  Valid: File has .sh extension"
else
    echo "  Invalid: Not a shell script"
fi
echo ""

# Email validation (simple regex)
email="user@example.com"
echo "Checking email: '\$email'"
if [[ "\$email" =~ ^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$ ]]; then
    echo "  Valid: Looks like an email"
else
    echo "  Invalid: Not a valid email format"
fi</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Integer Comparisons:</strong> Use <code>(( ))</code> with <code>==, !=, <, >, <=, >=</code> or <code>[[ ]]</code> with <code>-eq, -ne, -lt, -gt, -le, -ge</code></li>
                            <li><strong>String Comparisons:</strong> Use <code>==, !=, <, ></code> inside <code>[[ ]]</code>; check empty with <code>-z</code> and <code>-n</code></li>
                            <li><strong>Pattern Matching:</strong> Use <code>==</code> with glob patterns (<code>*, ?, [...]</code>)</li>
                            <li><strong>Regex Matching:</strong> Use <code>=~</code> with unquoted regex; access matches via <code>BASH_REMATCH</code></li>
                            <li><strong>[[ ]] vs [ ]:</strong> Prefer <code>[[ ]]</code> for Bash; use <code>[ ]</code> for POSIX portability</li>
                            <li><strong>Always Quote:</strong> Quote variables in comparisons to handle empty values safely</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can compare values, let's learn about <strong>Logical Operators</strong>. You'll discover how to combine conditions using AND (<code>&&</code>), OR (<code>||</code>), and NOT (<code>!</code>) to build complex conditional logic in your scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-arithmetic.jsp" />
                    <jsp:param name="prevTitle" value="Arithmetic Operations" />
                    <jsp:param name="nextLink" value="operators-logical.jsp" />
                    <jsp:param name="nextTitle" value="Logical Operators" />
                    <jsp:param name="currentLessonId" value="operators-comparison" />
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
